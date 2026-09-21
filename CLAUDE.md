# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`FDPerformanceAnalytics` is a small single-form Delphi VCL application (`TForm1` in `main.pas`/`main.dfm`) used to interactively exercise and inspect **FireDAC** (`TFDConnection`/`TFDTable`/`TFDQuery`) connection options against a SQL Server database. It's a diagnostic/testing tool, not a production app — there are no automated tests, no CI config, and no other units besides `main.pas`.

The UI has two top-level tabs on `PageControl`: **Performance Tests** (`PerfTestsTab`, the default active tab) and **Connection Options** (`ConnectionOptionsTab`).

On the Connection Options tab, you can:
- Connect to SQL Server via OS authentication, SQL auth, or Azure AD Interactive auth (`SetConnection`).
- Toggle every `TFDConnection` sub-option group — `FetchOptions`, `FormatOptions`, `ResourceOptions`, `UpdateOptions` — through UI controls on nested tabs (`FetchOptionsTab`, `FormatOptionsTab`, `ResourceOptionsTab`, `UpdateOptionsTab`) and apply/reload them via matching `Set*Options`/`Load*Options` procedure pairs.
- Poll connection liveness on a timer (`ConnectionCheckTimer` → `UpdateConnectionAliveIndicator`, which uses `SQLFDConnection.Ping`).

On the Performance Tests tab, you can:
- Pick a table (typed into `cbxPerfTables`, or from `sys.tables` via `btnRefreshPerfTables`).
- Choose `TFDTable` vs `TFDQuery` as the dataset under test (`chkPerfUseQuery` — see `GetDataSet` below).
- Run four dataset operations against it — Full Iteration, FindKey/GotoKey, SetRange/CancelRange, Locate (`btnRunFullIteration`/`btnRunFindKey`/`btnRunSetRange`/`btnRunLocate`) — each opening the table fresh via `OpenTable`, timing the operation, and appending a row (elapsed time, row count, notes) to `grdPerfResults` via the shared `RunPerfTest` helper.
- Inspect the live index, filter, and record count for whichever dataset is open (`AssignIndexAndFilterEdits`, called from `OpenTable`).

See [PERFORMANCE_TESTS_PLAN.md](PERFORMANCE_TESTS_PLAN.md) and [PERFORMANCE_TESTS_PROGRESS.md](PERFORMANCE_TESTS_PROGRESS.md) for that feature's design and implementation status.

## Build

This is a Delphi project (`FDPerformanceAnalytics.dproj`, project version 19.5 / Delphi 11.x, Win32 target). Build with `msbuild` or the Delphi IDE:

```bash
msbuild FDPerformanceAnalytics.dproj /t:Build /p:Config=Debug /p:Platform=Win32
msbuild FDPerformanceAnalytics.dproj /t:Build /p:Config=Release /p:Platform=Win32
```

There is no lint or test tooling in this repo — there are no unit tests, no test runner, and no CI pipeline defined. See [README.md](README.md) for a headless-build workaround (setting `BDS`/`BDSBIN`) if `msbuild`/`dcc32` aren't on `PATH`.

## Architecture notes

- **Single-unit app**: all logic lives in `main.pas`. There's no separation between UI event handlers and connection/business logic — `TForm1` methods directly manipulate `TFDConnection`/`TFDTable`/`TFDQuery` components declared on the form.
- **Options mirroring pattern**: for each FireDAC option group (Fetch/Format/Resource/Update), there is a `Set<Group>Options(AConnection)` (UI → FireDAC) and a `Load<Group>Options(AConnection)` (FireDAC → UI) procedure. When adding a new FireDAC option to expose, add the UI control in `main.dfm`, then wire it into **both** the `Set*` and `Load*` procedures for that group to keep the round-trip consistent.
- **Connection setup is idempotent-ish via `Params`**: `SetConnection` checks `Params.IndexOfName(...)` before adding vs. updating a param (Server, OSAuthent, Encrypt, TrustServerCertificate, ODBCAdvanced) — follow this pattern rather than blindly calling `Params.Add`, since FireDAC params can't hold duplicate names.
- **`FDataSet` is a property, not a fixed component**: `GetDataSet` returns `SQLFDQuery` or `FDTable1` depending on `chkPerfUseQuery.Checked`. `OpenTable` branches on that same flag — not on `FDataSet.ClassType` — to decide whether to set `SQL.Text`/`IndexName` on `SQLFDQuery` or `TableName`/`IndexName` on `FDTable1`. Use `chkPerfUseQuery.Checked` as the source of truth for "which dataset kind" rather than re-deriving it from `FDataSet`'s runtime type.
- **`OpenTable` always closes-then-reopens**: it unconditionally closes whatever's active on `FDataSet` and reopens with the given table/index, leaving the dataset positioned on `First`. This is required by the Performance Tests tab (each test needs a clean, fresh dataset) and is `OpenTable`'s only caller today (via `RunPerfTest`). If you add another caller that expects "open once, ignore later calls if already open," it will need its own guard — don't assume `OpenTable` is a no-op on an already-open dataset.
- **`RunPerfTest` disables `DataSource1`-bound controls during the timed test body**: `DBGrid1` is bound to `FDataSet` via `DataSource1`, so navigating a dataset (`Next`, `FindKey`, `Locate`, ...) would otherwise repaint the grid on every move and skew timings. `RunPerfTest` wraps the test body in `DataSet.DisableControls`/`EnableControls` (in a `finally`) — route new tests through `RunPerfTest` rather than driving `FDataSet` directly, to keep this guarantee.
- **`FindKey`/`SetRange`/`CancelRange`/`IndexFieldNames` work on `TFDQuery`, not just `TFDTable`**: these are declared on `TFDDataSet` itself (confirmed in FireDAC's source, `FireDAC.Comp.DataSet.pas`), not on `TFDTable`. For `TFDTable` they map to a real server-side index; for `TFDQuery` FireDAC builds a local/client-side index over the already-fetched rows. Both are valid — they just measure different things — so don't reintroduce a "not applicable to TFDQuery" guard for these operations.
- **`FUpdatingConnectionToggle` guard**: `ConnectionAliveCB`'s checkbox is both user-toggleable and programmatically updated by `UpdateConnectionAliveIndicator`; the guard flag prevents the programmatic update from re-triggering `ConnectionAliveCBClick`. Preserve this pattern when adding new two-way-bound checkboxes tied to live state.
