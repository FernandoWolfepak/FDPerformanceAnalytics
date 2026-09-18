# FireDAC Performance Tests — Implementation Plan

## Goal
Add a "Performance Tests" tab to `TForm1` that runs common FireDAC dataset
operations (full iteration, FindKey/GotoKey, SetRange/CancelRange, Locate)
against a user-chosen table, using whatever connection is already configured
on the Connection Options tab (`SetFDConnectionOptions` / the Fetch / Format /
Resource / Update option groups), and reports elapsed time per test in a grid.

Tests are implemented **one at a time**, in the order listed below. Each test
is a self-contained procedure that plugs into a shared "run + time + record"
helper, so adding the next test is additive (new button + new procedure),
not a rewrite.

## Decisions already made
- Table selection: new edit box (typed name) + dropdown populated from
  `sys.tables` (reuse the query pattern already in `TableExists`), on the new
  tab. Not tied to `DBNameEdit` (that's the database, not the table).
- Dataset reset: **reopen the dataset before every test** (close, reapply
  connection options, reopen) so each test starts from a clean state — first
  record, no filter, no range.
- Metrics: **single run, elapsed ms only** (`TStopwatch`), no repeat/average.
  Can be revisited later if results are too noisy.
- Key field for FindKey / SetRange / Locate: **auto-detect** from the opened
  dataset's `IndexDefs`/`FieldDefs` (first indexed field, falling back to the
  first field) rather than hardcoding a column name.
- The old `DescriptionSrch` / `BYDESCRIPTION` references in `Button6` and
  `Filter` are leftovers from an earlier, unrelated test and are **not**
  reused. `Button6` has no `OnClick` and `OpenTable` is currently unused —
  left as-is; not in scope for this change.

## UI changes (`main.dfm` / `main.pas`)

New `TTabSheet` on `PageControl`, e.g. `PerfTestsTab` (Caption: "Performance
Tests"), containing:

- `Label` + `edPerfTableName: TEdit` — table name to test against.
- `cbxPerfTables: TComboBox` (`Style = csDropDown`) — populated on tab show
  (or via a "Refresh Tables" button) from:
  ```sql
  select t.name from sys.tables t order by t.name
  ```
  Selecting an item fills `edPerfTableName.Text`.
- `btnRunFullIteration: TButton` — "1. Full Iteration (First..Eof)".
  (Later tests add `btnRunFindKey`, `btnRunSetRange`, `btnRunLocate` the same
  way — one button each, added when that test is implemented.)
- `grdPerfResults: TStringGrid` — columns: `Test` | `Elapsed (ms)` | `Rows` |
  `Notes`. Fixed header row; one row appended per test run (results
  accumulate across runs in the same session so different configs can be
  compared — not cleared automatically).
- `btnClearPerfResults: TButton` — clears the grid back to the header row.

## Core plumbing (`main.pas`)

### Shared dataset-for-test helper
```pascal
function TForm1.OpenPerfTestDataSet: TFDDataSet;
```
- Closes `FDataSet` if open.
- Calls `SetConnection` + `SetFDConnectionOptions` (reuses existing
  connection-option wiring so the test runs under whatever is set on the
  Connection Options tab) if not already connected.
- Opens `FDataSet` against `edPerfTableName.Text` (mirrors `OpenTable`'s
  open logic for `TFDTable`/`TFDQuery`, without the index/filter parts).
- Returns `FDataSet` positioned on the first record.

### Key field detection
```pascal
function TForm1.DetectPerfKeyField(ADataSet: TFDDataSet): TField;
```
- Inspect `ADataSet.IndexDefs`; if any index exists, use its first field
  name to resolve `ADataSet.FieldByName(...)`.
- Fallback: `ADataSet.Fields[0]`.
- Used by FindKey/GotoKey, SetRange/CancelRange, and Locate tests.

### Run + time + record helper
```pascal
type
  TPerfTestProc = reference to procedure(ADataSet: TFDDataSet; out RowsProcessed: Integer; out Notes: string);

procedure TForm1.RunPerfTest(const TestName: string; Proc: TPerfTestProc);
```
- Calls `OpenPerfTestDataSet`.
- Starts `TStopwatch`.
- Invokes `Proc(FDataSet, RowsProcessed, Notes)`.
- Stops stopwatch.
- Appends a row to `grdPerfResults`: `TestName`, elapsed ms, RowsProcessed,
  Notes.
- Wrapped in try/finally so a failed test still reports (Notes = error
  message, elapsed = time to failure) rather than leaving the grid silent.

Each test button's `OnClick` just calls
`RunPerfTest('<name>', procedure(...) begin ... end)`.

## Tests (implement in this order)

1. **Full Iteration** — `First`; loop `while not Eof do Next`; `RowsProcessed`
   = loop count.
2. **FindKey / GotoKey** — using the detected key field, collect a small
   sample of existing key values up front (e.g. every Nth record's key while
   doing the Full Iteration pass, or first/middle/last), then for each
   sampled value: `SetKeyFields`? — actually for `TFDTable` use
   `FindKey([Value])`; time the total loop over the sample.
   `RowsProcessed` = number of keys looked up; `Notes` = hit/miss count.
3. **SetRange / CancelRange** — using min and max key values from the
   sample, call `SetRange([MinValue], [MaxValue])`, iterate `First..Eof`
   within the range to count rows, then `CancelRange`. `RowsProcessed` =
   rows within range.
4. **Locate** — for each sampled key value, `Locate(KeyFieldName, Value, [])`;
   time the total; `RowsProcessed` = number of successful locates.

(FindKey/SetRange only apply cleanly to `TFDTable` with an index; if
`FDataSet` is a `TFDQuery`, those two tests should report
`Notes := 'Not applicable to TFDQuery'` and `RowsProcessed := 0` rather than
raising.)

## Out of scope / not touched
- No changes to existing Connection Options, Fetch/Format/Resource/Update
  tabs — the new tests just consume whatever is already configured there.
- No CSV export, no N-repeat averaging (can be added later if needed).
- `Button6` / `OpenTable` dead code left untouched.
