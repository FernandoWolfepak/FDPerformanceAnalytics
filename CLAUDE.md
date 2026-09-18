# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`FDPerformanceAnalytics` is a small single-form Delphi VCL application (`TForm1` in `main.pas`/`main.dfm`) used to interactively exercise and inspect **FireDAC** (`TFDConnection`/`TFDTable`/`TFDQuery`) connection options against a SQL Server database. It's a diagnostic/testing tool, not a production app — there are no automated tests, no CI config, and no other units besides `main.pas`.

The UI lets you:
- Connect to SQL Server via OS authentication, SQL auth, or Azure AD Interactive auth (`SetConnection`).
- Toggle every `TFDConnection` sub-option group — `FetchOptions`, `FormatOptions`, `ResourceOptions`, `UpdateOptions` — through UI controls on tabs (`FetchOptionsTab`, `FormatOptionsTab`, `ResourceOptionsTab`, `UpdateOptionsTab`) and apply/reload them via matching `Set*Options`/`Load*Options` procedure pairs.
- Open a table/query and inspect the live index, filter, and record count (`AssignIndexAndFilterEdits`).
- Poll connection liveness on a timer (`ConnectionCheckTimer` → `UpdateConnectionAliveIndicator`, which uses `SQLFDConnection.Ping`).

## Build

This is a Delphi project (`FDPerformanceAnalytics.dproj`, project version 19.5 / Delphi 11.x, Win32 target). Build with `msbuild` or the Delphi IDE:

```bash
msbuild FDPerformanceAnalytics.dproj /t:Build /p:Config=Debug /p:Platform=Win32
msbuild FDPerformanceAnalytics.dproj /t:Build /p:Config=Release /p:Platform=Win32
```

There is no lint or test tooling in this repo — there are no unit tests, no test runner, and no CI pipeline defined.

## Architecture notes

- **Single-unit app**: all logic lives in `main.pas`. There's no separation between UI event handlers and connection/business logic — `TForm1` methods directly manipulate `TFDConnection`/`TFDTable`/`TFDQuery` components declared on the form.
- **Options mirroring pattern**: for each FireDAC option group (Fetch/Format/Resource/Update), there is a `Set<Group>Options(AConnection)` (UI → FireDAC) and a `Load<Group>Options(AConnection)` (FireDAC → UI) procedure. When adding a new FireDAC option to expose, add the UI control in `main.dfm`, then wire it into **both** the `Set*` and `Load*` procedures for that group to keep the round-trip consistent.
- **Connection setup is idempotent-ish via `Params`**: `SetConnection` checks `Params.IndexOfName(...)` before adding vs. updating a param (Server, OSAuthent, Encrypt, TrustServerCertificate, ODBCAdvanced) — follow this pattern rather than blindly calling `Params.Add`, since FireDAC params can't hold duplicate names.
- **`FDataSet` is a property, not a fixed component**: `GetDataSet` currently always returns `FDTable1`, but `OpenTable` branches on `FDataSet.ClassType = TFDQuery` — so the dataset in use is meant to be swappable between `TFDTable1` and `SQLFDQuery`.
- **`FUpdatingConnectionToggle` guard**: `ConnectionAliveCB`'s checkbox is both user-toggleable and programmatically updated by `UpdateConnectionAliveIndicator`; the guard flag prevents the programmatic update from re-triggering `ConnectionAliveCBClick`. Preserve this pattern when adding new two-way-bound checkboxes tied to live state.
