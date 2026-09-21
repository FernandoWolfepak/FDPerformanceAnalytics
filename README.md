# FDPerformanceAnalytics

A small single-form Delphi VCL diagnostic tool for interactively exercising and
inspecting **FireDAC** (`TFDConnection`/`TFDTable`/`TFDQuery`) connection
options against a SQL Server (including Azure SQL) database.

## What it does

- **Connect** via Windows (OS) authentication, SQL authentication, or Azure AD
  Interactive authentication.
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

## Build

Delphi project (`FDPerformanceAnalytics.dproj`, Delphi 11.x, Win32). Build
with the Delphi IDE, or from the command line:

```bash
msbuild FDPerformanceAnalytics.dproj /t:Build /p:Config=Debug /p:Platform=Win32
msbuild FDPerformanceAnalytics.dproj /t:Build /p:Config=Release /p:Platform=Win32
```

If `msbuild`/`dcc32` aren't on `PATH`, the .NET Framework's MSBuild works
too, as long as `BDS`/`BDSBIN` point at the RAD Studio install (required by
`CodeGear.Delphi.Targets`):

```bash
export BDS="C:\Program Files (x86)\Embarcadero\Studio\22.0"
export BDSBIN="C:\Program Files (x86)\Embarcadero\Studio\22.0\bin"
"C:/Windows/Microsoft.NET/Framework64/v4.0.30319/MSBuild.exe" FDPerformanceAnalytics.dproj /t:Build /p:Config=Debug /p:Platform=Win32
```

There is no lint or test tooling in this repo — no unit tests, no test
runner, no CI pipeline.

## More info

See [CLAUDE.md](CLAUDE.md) for architecture notes and conventions, and
[PERFORMANCE_TESTS_PLAN.md](PERFORMANCE_TESTS_PLAN.md) /
[PERFORMANCE_TESTS_PROGRESS.md](PERFORMANCE_TESTS_PROGRESS.md) for the
Performance Tests feature's design and implementation status.
