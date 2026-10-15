# FDPerformanceAnalytics

A small single-form Delphi VCL diagnostic tool for interactively exercising and
inspecting **FireDAC** (`TFDConnection`/`TFDTable`/`TFDQuery`) connection
options against a SQL Server (including Azure SQL) database.

## What it does

- **Connect** via Windows (OS) authentication, SQL authentication, Azure AD
  Interactive authentication, or Azure AD Integrated (silent) authentication.
- **Connection Options tab** — toggle every `TFDConnection` sub-option group
  (`FetchOptions`, `FormatOptions`, `ResourceOptions`, `UpdateOptions`)
  through UI controls and apply/reload them live.
- **Performance Tests tab** — pick a table (typed name or from a
  `sys.tables` dropdown), choose whether to run against a `TFDTable` or a
  `TFDQuery`, and time four common dataset operations against it:
  1. Full Iteration (`First`..`Eof`)
  2. FindKey / GotoKey
  3. SetRange / CancelRange
  4. Locate

  Each run reopens the dataset fresh (closing and reapplying whatever
  connection options are set on the Connection Options tab first) and
  appends a row to a results grid — elapsed time (auto-formatted as
  ms/s/min), row count, and notes — so different connection-option
  configurations can be compared side by side.
- **Auto Benchmark tab** — automatically compares connection-option
  configurations instead of changing them by hand:
  - Pick the test (Full Iteration, FindKey, SetRange or Locate), table,
    dataset kind (`TFDTable`/`TFDQuery`) and number of repetitions.
  - Check which `FetchOptions`, `FormatOptions`, `ResourceOptions` and
    `UpdateOptions` properties to vary. `RowsetSize` and `Mode` are combined
    as a cross product; every other checked property is varied one at a time
    on top of the baseline.
  - The configuration currently set on the Connection Options tab is the
    baseline ("Original"). A plan summary (configurations x repetitions, plus
    one warm-up run) is shown before you start.
  - Results show average/median time and % improvement vs. the baseline,
    ranked best first, with a progress bar and a Cancel button.
  - **Export CSV** saves the ranked results (including the per-run samples
    and any errors).

