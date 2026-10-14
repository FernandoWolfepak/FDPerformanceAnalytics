unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.Client, DB, System.Math,
  FireDAC.Comp.DataSet, FireDAC.Phys.MSSQL, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Consts, Vcl.CheckLst, cxCheckBox, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxCustomListBox,
  cxCheckListBox, StStrL, dxBarBuiltInMenu, cxPC, System.Diagnostics,
  System.Generics.Collections, System.Generics.Defaults, System.TypInfo, System.IOUtils, Vcl.Samples.Spin;

type
  TPerfTestProc = reference to procedure(ADataSet: TFDDataSet; out RowsProcessed: Integer; out Notes: string);

  TPerfTestKind = (ptFullIteration, ptFindKey, ptSetRange, ptLocate);

  TBenchApplyProc = TProc<TFDConnection>;

  { One value of a benchmarked FireDAC property, e.g. 'RowsetSize=100'. }
  TBenchOption = record
    Caption: string;
    Apply: TBenchApplyProc;
  end;

  { One benchmarked FireDAC property and the values to try. CurrentCaption is the
    value held by the Connection Options tab (the "original" configuration). }
  TBenchDimension = record
    CurrentCaption: string;
    Options: TArray<TBenchOption>;
  end;

  { One combination of option values, plus the timings measured for it. }
  TBenchConfig = class
  private
    FSamples: TList<Double>;
  public
    Caption: string;
    Apply: TBenchApplyProc;
    IsBaseline: Boolean;
    ErrorCount: Integer;
    Notes: string;
    constructor Create(const ACaption: string; const AApply: TBenchApplyProc);
    destructor Destroy; override;
    function Combine(const AOption: TBenchOption): TBenchConfig;
    function DisplayName: string;
    function Average: Double;
    function Median: Double;
    property Samples: TList<Double> read FSamples;
  end;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    TopNoteLbl: TLabel;
    Label4: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label10: TLabel;
    DBNameEdit: TEdit;
    SQLServerUsernameEdit: TEdit;
    SQLServerPasswordEdit: TEdit;
    UseOSAuthenticationCB: TCheckBox;
    UseAzureADInteractiveCB: TCheckBox;
    UseAzureADIntegratedCB: TCheckBox;
    SQLServerNameEdit: TEdit;
    SQLFDConnection: TFDConnection;
    FDTable1: TFDTable;
    SQLFDQuery: TFDQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    CurrentIndexLbl: TLabel;
    CurrentFilterLbl: TLabel;
    CurrentRecordCountLbl: TLabel;
    PageControl: TPageControl;
    ConnectionOptionsTab: TTabSheet;
    PageControlConnection: TcxPageControl;
    FetchOptionsTab: TcxTabSheet;
    lblRecsSkip: TLabel;
    lblRecsMax: TLabel;
    lblRowsetSize: TLabel;
    Label13: TLabel;
    lblCache: TLabel;
    lblDetailDelay: TLabel;
    rgCursorKind: TRadioGroup;
    rgFetchMode: TRadioGroup;
    chkLiveWindowParanoic: TCheckBox;
    chkLiveWindowFastFirst: TCheckBox;
    rgAutoFetchAll: TRadioGroup;
    edRecsSkip: TEdit;
    edRecsMax: TEdit;
    edRowsetSize: TEdit;
    ckFetchItem: TcxCheckListBox;
    ckCache: TcxCheckListBox;
    chkAutoClose: TCheckBox;
    rgRecordCountMode: TRadioGroup;
    chkUnidirectional: TCheckBox;
    edDetailDelay: TEdit;
    chkDetailOptimize: TCheckBox;
    chkDetailCascade: TCheckBox;
    chkDetailServerCascade: TCheckBox;
    btnFetchOptionsRestoreDefaults: TButton;
    FormatOptionsTab: TcxTabSheet;
    Label14: TLabel;
    ckSortOptions: TcxCheckListBox;
    rgSortLocate: TRadioGroup;
    chkStrsTrim: TCheckBox;
    chkStrsEmpty2Null: TCheckBox;
    chkStrsTrim2Len: TCheckBox;
    chkCheckPrecision: TCheckBox;
    chkADOCompatibility: TCheckBox;
    chkDataSnapCompatibility: TCheckBox;
    chkQuoteIdentifiers: TCheckBox;
    btnFormatOptionsRestoreDefaults: TButton;
    ResourceOptionsTab: TcxTabSheet;
    chkMacroCreate: TCheckBox;
    chkMacroExpand: TCheckBox;
    chkDirectExecute: TCheckBox;
    chkServerOutput: TCheckBox;
    btnResourceOptionsRestoreDefaults: TButton;
    chkSilentMode: TCheckBox;
    UpdateOptionsTab: TcxTabSheet;
    rgLockMode: TRadioGroup;
    rgLockPoint: TRadioGroup;
    rgUpdateMode: TRadioGroup;
    chkLockWait: TCheckBox;
    chkAutoCommitUpdates: TCheckBox;
    btnUpdateOptionsRestoreDefaults: TButton;
    rgFetchGeneratorsPoint: TRadioGroup;
    btnConnect: TButton;
    ConnectionAliveCB: TCheckBox;
    ConnectionCheckTimer: TTimer;
    PerfTestsTab: TTabSheet;
    lblPerfTableName: TLabel;
    cbxPerfTables: TComboBox;
    btnRefreshPerfTables: TButton;
    chkPerfUseQuery: TCheckBox;
    btnRunFullIteration: TButton;
    btnRunFindKey: TButton;
    btnRunSetRange: TButton;
    btnRunLocate: TButton;
    btnClearPerfResults: TButton;
    grdPerfResults: TStringGrid;
    lblBenchTest: TLabel;
    cbxBenchTest: TComboBox;
    lblBenchTable: TLabel;
    cbxBenchTables: TComboBox;
    btnBenchRefreshTables: TButton;
    rgBenchDataSet: TRadioGroup;
    lblBenchReps: TLabel;
    seBenchReps: TSpinEdit;
    btnBenchRun: TButton;
    btnBenchCancel: TButton;
    btnBenchExport: TButton;
    pbBench: TProgressBar;
    lblBenchStatus: TLabel;
    grdBenchResults: TStringGrid;
    pbProgress: TProgressBar;
    pnlFooter: TPanel;
    lblProgress: TLabel;
    procedure UseOSAuthenticationCBClick(Sender: TObject);
    procedure UseAzureADInteractiveCBClick(Sender: TObject);
    procedure UseAzureADIntegratedCBClick(Sender: TObject);
    function UseAnyAzureAD: Boolean;
    procedure FormShow(Sender: TObject);
    procedure btnFetchOptionsRestoreDefaultsClick(Sender: TObject);
    procedure btnFormatOptionsRestoreDefaultsClick(Sender: TObject);
    procedure btnResourceOptionsRestoreDefaultsClick(Sender: TObject);
    procedure btnUpdateOptionsRestoreDefaultsClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure ConnectionAliveCBClick(Sender: TObject);
    procedure ConnectionCheckTimerTimer(Sender: TObject);
    procedure btnRefreshPerfTablesClick(Sender: TObject);
    procedure chkPerfUseQueryClick(Sender: TObject);
    procedure btnRunFullIterationClick(Sender: TObject);
    procedure btnRunFindKeyClick(Sender: TObject);
    procedure btnRunSetRangeClick(Sender: TObject);
    procedure btnRunLocateClick(Sender: TObject);
    procedure btnClearPerfResultsClick(Sender: TObject);
    procedure btnBenchRefreshTablesClick(Sender: TObject);
    procedure btnBenchRunClick(Sender: TObject);
    procedure btnBenchCancelClick(Sender: TObject);
    procedure btnBenchExportClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FUpdatingConnectionToggle: Boolean;
    FPerfKeyFieldName: string;
    FBenchRunning: Boolean;
    FBenchCancel: Boolean;
    FBenchResults: TObjectList<TBenchConfig>;
    FBenchInfo: string;
    procedure Filter(Checked: Boolean; aFilter: string);
    function PrtYN(const yn: boolean): string;
    procedure SetConnection;
    procedure AssignIndexAndFilterEdits;
    procedure OpenTable(aTableName: string; IndexToUse: string);
    function GetDataSet: TFDDataSet;
    function TableExists(aTableName: string): Boolean;
    procedure UpdateConnectionAliveIndicator;
    procedure EnsurePerfConnection;
    procedure InitPerfResultsGrid;
    procedure AutoSizePerfResultsColumns;
    function FormatPerfElapsed(ElapsedMs: Int64): string;
    procedure AppendPerfResultRow(const TestName: string; ElapsedMs: Int64; RowsProcessed: Integer; const Notes: string);
    function DetectPerfKeyField(ADataSet: TFDDataSet): TField;
    function CollectPerfKeySample(ADataSet: TFDDataSet; AKeyField: TField; ASampleSize: Integer): TArray<Variant>;
    procedure ReportProgress(const ATask: string; ACount, ATotal: Integer; AForce: Boolean = False);
    procedure ExecutePerfTest(const aTableName: string; Proc: TPerfTestProc; out ElapsedMs: Double;
      out RowsProcessed: Integer; out Notes, ErrorMsg: string);
    procedure RunPerfTest(const TestName: string; Proc: TPerfTestProc);
    function GetPerfTestProc(AKind: TPerfTestKind): TPerfTestProc;
    procedure LoadTableNames(ACombo: TComboBox);
    procedure AutoSizeGridColumns(AGrid: TStringGrid);

    function BuildBenchDimensions: TArray<TBenchDimension>;
    function BuildBenchConfigs: TObjectList<TBenchConfig>;
    function RunBenchOnce(AConfig: TBenchConfig; AKind: TPerfTestKind; const aTableName: string;
      out ElapsedMs: Double; out RowsProcessed: Integer; out ErrorMsg: string): Boolean;
    procedure SetBenchRunning(ARunning: Boolean);
    procedure RankBenchResults(AConfigs: TObjectList<TBenchConfig>);
    procedure ShowBenchResults;
    procedure InitBenchResultsGrid;
    function BenchResultsToCsv: string;

    procedure SetFDConnectionOptions;
    procedure SetFetchOptions(AConnection: TFDConnection);
    procedure SetFormatOptions(AConnection: TFDConnection);
    procedure SetResourceOptions(AConnection: TFDConnection);
    procedure SetUpdateOptions(AConnection: TFDConnection);

    procedure LoadFDConnectionOptions;
    procedure LoadDefaultConnectionOptions;
    procedure LoadFetchOptions(AConnection: TFDConnection);
    procedure LoadFormatOptions(AConnection: TFDConnection);
    procedure LoadResourceOptions(AConnection: TFDConnection);
    procedure LoadUpdateOptions(AConnection: TFDConnection);

    property FDataSet: TFDDataSet read GetDataSet;
  public
    destructor Destroy; override;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  Tick       = #39; { single quotation mark }
  ProgressInterval = 50; { records between footer progress updates }
  PerfTestNames: array[TPerfTestKind] of string =
    ('Full Iteration', 'FindKey / GotoKey', 'SetRange / CancelRange', 'Locate');

procedure TForm1.AssignIndexAndFilterEdits;
begin
  CurrentIndexLbl.Caption := 'FDTable1.IndexName: ' + FDataSet.IndexName;
  if FDataSet.Filtered
    then CurrentFilterLbl.Caption := 'FDTable1.Filter: ' + FDataSet.Filter
    else CurrentFilterLbl.Caption := 'FDTable1.Filter: (' + 'None' + ')';
  CurrentRecordCountLbl.Caption := 'FDTable1.RecordCount: ' + IntToStr(FDataSet.RecordCount);
  if not CurrentIndexLbl.Visible
    then CurrentIndexLbl.Visible := true;
  if not CurrentFilterLbl.Visible
    then CurrentFilterLbl.Visible := true;
  if not CurrentRecordCountLbl.Visible
    then CurrentRecordCountLbl.Visible := true;
end;

procedure TForm1.Filter(Checked: Boolean; aFilter: string);
begin
  try
    FDataSet.Filtered := False;
    if Checked then
    begin
      FDataSet.Filter := aFilter;
      FDataSet.Filtered := True;
    end;
  finally
    AssignIndexAndFilterEdits;
  end;
end;

function TForm1.TableExists(aTableName: string): Boolean;
begin
  SQLFDQuery.Close;
  SQLFDQuery.SQL.Clear;
  SQLFDQuery.SQL.Add('select count(1) as Count from sys.tables t WHERE t.NAME = '
                    +Tick+aTableName+Tick);
  SQLFDQuery.Open;
  Result := SQLFDQuery.FieldByName('Count').AsInteger > 0;

end;

procedure TForm1.btnConnectClick(Sender: TObject);
var
  aAuth, ErrorMessage: string;
begin
  try
    if SQLFDConnection.Connected
      then SQLFDConnection.Connected := False;

    SetConnection;
    SetFDConnectionOptions;

    SQLFDConnection.Params.Database := DBNameEdit.Text;
    try
      SQLFDConnection.Connected := True;
    except on E: Exception do
      begin
        aAuth := SQLFDConnection.Params.Values['ODBCAdvanced'];
        if aAuth = ''
          then
            if UseOSAuthenticationCB.Checked
              then aAuth := 'Windows Authentication'
              else aAuth := 'SQL Server Authentication';
        ErrorMessage := Format('Could not connect to SQL Server "%s", database "%s" (%s).%s%s: %s',
          [SQLServerNameEdit.Text, DBNameEdit.Text, aAuth, sLineBreak + sLineBreak, E.ClassName, E.Message]);
        raise Exception.Create(ErrorMessage);
      end;
    end;
  finally
    UpdateConnectionAliveIndicator;
  end;
end;

procedure TForm1.ConnectionAliveCBClick(Sender: TObject);
begin
  if FUpdatingConnectionToggle
    then Exit;

  if ConnectionAliveCB.Checked
    then btnConnectClick(ConnectionAliveCB)
    else
      begin
        SQLFDConnection.Connected := False;
        UpdateConnectionAliveIndicator;
      end;
end;

procedure TForm1.ConnectionCheckTimerTimer(Sender: TObject);
begin
  UpdateConnectionAliveIndicator;
end;

procedure TForm1.UpdateConnectionAliveIndicator;
var
  IsAlive: Boolean;
begin
  IsAlive := SQLFDConnection.Connected;
  if IsAlive then
    try
      IsAlive := SQLFDConnection.Ping;
    except
      IsAlive := False;
    end;

  FUpdatingConnectionToggle := True;
  try
    ConnectionAliveCB.Checked := IsAlive;
  finally
    FUpdatingConnectionToggle := False;
  end;
end;

procedure TForm1.btnFetchOptionsRestoreDefaultsClick(Sender: TObject);
begin
  SQLFDConnection.FetchOptions.RestoreDefaults;
  LoadFDConnectionOptions;
end;

procedure TForm1.btnFormatOptionsRestoreDefaultsClick(Sender: TObject);
begin
  SQLFDConnection.FormatOptions.RestoreDefaults;
  LoadFDConnectionOptions;
end;

procedure TForm1.btnResourceOptionsRestoreDefaultsClick(Sender: TObject);
begin
  SQLFDConnection.ResourceOptions.RestoreDefaults;
  LoadFDConnectionOptions;
end;

procedure TForm1.btnUpdateOptionsRestoreDefaultsClick(Sender: TObject);
begin
  SQLFDConnection.UpdateOptions.RestoreDefaults;
  LoadFDConnectionOptions;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  Kind: TPerfTestKind;
begin
  UseOSAuthenticationCB.Checked := False;
  UseAzureADIntegratedCB.Checked := False;
  UseAzureADInteractiveCB.Checked := True;
  UseAzureADInteractiveCBClick(UseAzureADInteractiveCB);
  SQLFDConnection.Connected := False;

  LoadDefaultConnectionOptions;
  LoadFetchOptions(SQLFDConnection);
  LoadFormatOptions(SQLFDConnection);
  LoadResourceOptions(SQLFDConnection);
  LoadUpdateOptions(SQLFDConnection);

  InitPerfResultsGrid;

  cbxBenchTest.Items.Clear;
  for Kind := Low(TPerfTestKind) to High(TPerfTestKind) do
    cbxBenchTest.Items.Add(PerfTestNames[Kind]);
  cbxBenchTest.ItemIndex := 0;
  InitBenchResultsGrid;

  UpdateConnectionAliveIndicator;
  PageControl.ActivePageIndex := 0;
end;

procedure TForm1.EnsurePerfConnection;
begin
  if SQLFDConnection.Connected then
    Exit;

  SetConnection;
  SetFDConnectionOptions;
  SQLFDConnection.Params.Database := DBNameEdit.Text;
  SQLFDConnection.Connected := True;
end;

procedure TForm1.InitPerfResultsGrid;
begin
  grdPerfResults.RowCount := 1;
  grdPerfResults.Cells[0, 0] := 'Test';
  grdPerfResults.Cells[1, 0] := 'Elapsed';
  grdPerfResults.Cells[2, 0] := 'Rows';
  grdPerfResults.Cells[3, 0] := 'Notes';
  AutoSizePerfResultsColumns;
end;

function TForm1.FormatPerfElapsed(ElapsedMs: Int64): string;
var
  Minutes: Int64;
  Seconds: Double;
begin
  if ElapsedMs < 1000 then
    Result := Format('%d ms', [ElapsedMs])
  else if ElapsedMs < 60000 then
    Result := Format('%.2f s', [ElapsedMs / 1000])
  else
  begin
    Minutes := ElapsedMs div 60000;
    Seconds := (ElapsedMs mod 60000) / 1000;
    Result := Format('%dm %.2fs', [Minutes, Seconds]);
  end;
end;

procedure TForm1.AppendPerfResultRow(const TestName: string; ElapsedMs: Int64; RowsProcessed: Integer; const Notes: string);
var
  Row: Integer;
begin
  Row := grdPerfResults.RowCount;
  grdPerfResults.RowCount := Row + 1;
  grdPerfResults.Cells[0, Row] := TestName;
  grdPerfResults.Cells[1, Row] := FormatPerfElapsed(ElapsedMs);
  grdPerfResults.Cells[2, Row] := IntToStr(RowsProcessed);
  grdPerfResults.Cells[3, Row] := Notes;
  AutoSizePerfResultsColumns;
end;

procedure TForm1.AutoSizePerfResultsColumns;
begin
  AutoSizeGridColumns(grdPerfResults);
end;

procedure TForm1.AutoSizeGridColumns(AGrid: TStringGrid);
const
  Padding = 12;
var
  Col, Row, MaxWidth, TextW: Integer;
begin
  for Col := 0 to AGrid.ColCount - 1 do
  begin
    MaxWidth := 0;
    for Row := 0 to AGrid.RowCount - 1 do
    begin
      TextW := AGrid.Canvas.TextWidth(AGrid.Cells[Col, Row]);
      if TextW > MaxWidth then
        MaxWidth := TextW;
    end;
    AGrid.ColWidths[Col] := MaxWidth + Padding;
  end;
end;

function TForm1.DetectPerfKeyField(ADataSet: TFDDataSet): TField;
var
  FieldName: string;
begin
  if ADataSet.IndexDefs.Count > 0 then
  begin
    FieldName := ADataSet.IndexDefs[0].Fields;
    if Pos(';', FieldName) > 0 then
      FieldName := Copy(FieldName, 1, Pos(';', FieldName) - 1);
    Result := ADataSet.FieldByName(FieldName);
  end
  else
    Result := ADataSet.Fields[0];
  FPerfKeyFieldName := Result.FieldName;
end;

{ Shows the current task in the footer. Loops call it for every record; the footer is
  only repainted every ProgressInterval records (or when AForce is set, e.g. at the end
  of a loop). ATotal is a best-effort estimate; the bar is stretched if ACount passes it. }
procedure TForm1.ReportProgress(const ATask: string; ACount, ATotal: Integer; AForce: Boolean);
begin
  if (not AForce) and (ACount mod ProgressInterval <> 0) then
    Exit;
  lblProgress.Caption := Format('%s (%d records)', [ATask, ACount]);
  pbProgress.Max := Max(1, Max(ATotal, ACount));
  pbProgress.Position := ACount;
  pnlFooter.Update;
end;

function TForm1.CollectPerfKeySample(ADataSet: TFDDataSet; AKeyField: TField; ASampleSize: Integer): TArray<Variant>;
var
  Keys: TList<Variant>;
  SampleStep, Count, Total: Integer;
begin
  Keys := TList<Variant>.Create;
  try
    Total := ADataSet.RecordCount;
    SampleStep := Max(1, Total div ASampleSize);
    Count := 0;
    ADataSet.First;
    while (not ADataSet.Eof) and (Keys.Count < ASampleSize) do
    begin
      if Count mod SampleStep = 0 then
        Keys.Add(AKeyField.Value);
      Inc(Count);
      ReportProgress('Sampling key values', Count, Total);
      ADataSet.Next;
    end;
    ReportProgress('Sampled key values', Count, Total, True);
    Result := Keys.ToArray;
  finally
    Keys.Free;
  end;
end;

{ Opens the table fresh, runs Proc with controls disabled and times the whole thing.
  Shared by the manual Performance Tests and the Auto Benchmark. Errors are returned
  in ErrorMsg rather than raised. }
procedure TForm1.ExecutePerfTest(const aTableName: string; Proc: TPerfTestProc; out ElapsedMs: Double;
  out RowsProcessed: Integer; out Notes, ErrorMsg: string);
var
  DataSet: TFDDataSet;
  Stopwatch: TStopwatch;
begin
  RowsProcessed := 0;
  Notes := '';
  ErrorMsg := '';
  FPerfKeyFieldName := '';
  Stopwatch := TStopwatch.StartNew;
  try
    try
      OpenTable(aTableName, '');
      DataSet := FDataSet;
      DataSet.DisableControls;
      try
        Proc(DataSet, RowsProcessed, Notes);
      finally
        DataSet.EnableControls;
      end;
    except
      on E: Exception do
        ErrorMsg := E.Message;
    end;
  finally
    Stopwatch.Stop;
    ElapsedMs := Stopwatch.Elapsed.TotalMilliseconds;
  end;
end;

procedure TForm1.RunPerfTest(const TestName: string; Proc: TPerfTestProc);
var
  ElapsedMs: Double;
  RowsProcessed: Integer;
  Notes, ErrorMsg: string;
  Description: string;
begin
  ExecutePerfTest(cbxPerfTables.Text, Proc, ElapsedMs, RowsProcessed, Notes, ErrorMsg);
  if ErrorMsg <> '' then
    Notes := 'Error: ' + ErrorMsg;
  if chkPerfUseQuery.Checked
    then Description := Format('%s - %s via TFDQuery', [TestName, cbxPerfTables.Text])
    else Description := Format('%s - %s via TFDTable', [TestName, cbxPerfTables.Text]);
  if FPerfKeyFieldName <> '' then
    Description := Description + ', key: ' + FPerfKeyFieldName;
  AppendPerfResultRow(Description, Trunc(ElapsedMs), RowsProcessed, Notes);
end;

procedure TForm1.LoadTableNames(ACombo: TComboBox);
var
  Count: Integer;
begin
  EnsurePerfConnection;

  SQLFDQuery.Close;
  SQLFDQuery.SQL.Clear;
  SQLFDQuery.SQL.Add('select t.name from sys.tables t order by t.name');
  SQLFDQuery.Open;

  ACombo.Items.Clear;
  Count := 0;
  while not SQLFDQuery.Eof do
  begin
    ACombo.Items.Add(SQLFDQuery.FieldByName('name').AsString);
    Inc(Count);
    ReportProgress('Loading table names', Count, SQLFDQuery.RecordCount);
    SQLFDQuery.Next;
  end;
  ReportProgress('Loaded table names', Count, Count, True);
  SQLFDQuery.Close;
end;

procedure TForm1.btnRefreshPerfTablesClick(Sender: TObject);
begin
  LoadTableNames(cbxPerfTables);
end;

procedure TForm1.btnClearPerfResultsClick(Sender: TObject);
begin
  InitPerfResultsGrid;
end;

{ The test bodies, shared by the manual buttons and the Auto Benchmark. }
function TForm1.GetPerfTestProc(AKind: TPerfTestKind): TPerfTestProc;
begin
  case AKind of
    ptFindKey:
      Result :=
        procedure(ADataSet: TFDDataSet; out RowsProcessed: Integer; out Notes: string)
        var
          KeyField: TField;
          Sample: TArray<Variant>;
          HitCount, i: Integer;
        begin
          RowsProcessed := 0;
          Notes := '';

          KeyField := DetectPerfKeyField(ADataSet);
          ADataSet.IndexFieldNames := KeyField.FieldName;

          Sample := CollectPerfKeySample(ADataSet, KeyField, 20);
          HitCount := 0;
          for i := 0 to High(Sample) do
            if ADataSet.FindKey([Sample[i]]) then
              Inc(HitCount);

          RowsProcessed := HitCount;
          Notes := Format('%d/%d hit', [HitCount, Length(Sample)]);
        end;
    ptSetRange:
      Result :=
        procedure(ADataSet: TFDDataSet; out RowsProcessed: Integer; out Notes: string)
        var
          KeyField: TField;
          Sample: TArray<Variant>;
          MinValue, MaxValue: Variant;
          RangeTotal: Integer;
        begin
          RowsProcessed := 0;
          Notes := '';

          KeyField := DetectPerfKeyField(ADataSet);
          ADataSet.IndexFieldNames := KeyField.FieldName;

          Sample := CollectPerfKeySample(ADataSet, KeyField, 20);
          if Length(Sample) = 0 then
          begin
            Notes := 'No rows to sample';
            Exit;
          end;

          MinValue := Sample[0];
          MaxValue := Sample[High(Sample)];

          ADataSet.SetRange([MinValue], [MaxValue]);
          try
            ADataSet.First;
            RangeTotal := ADataSet.RecordCount;
            while not ADataSet.Eof do
            begin
              Inc(RowsProcessed);
              ReportProgress('Reading records in range', RowsProcessed, RangeTotal);
              ADataSet.Next;
            end;
            ReportProgress('Read records in range', RowsProcessed, RangeTotal, True);
          finally
            ADataSet.CancelRange;
          end;

          Notes := Format('Range [%s..%s]', [VarToStr(MinValue), VarToStr(MaxValue)]);
        end;
    ptLocate:
      Result :=
        procedure(ADataSet: TFDDataSet; out RowsProcessed: Integer; out Notes: string)
        var
          KeyField: TField;
          Sample: TArray<Variant>;
          HitCount, i: Integer;
        begin
          KeyField := DetectPerfKeyField(ADataSet);
          Sample := CollectPerfKeySample(ADataSet, KeyField, 20);

          HitCount := 0;
          for i := 0 to High(Sample) do
            if ADataSet.Locate(KeyField.FieldName, Sample[i], []) then
              Inc(HitCount);

          RowsProcessed := HitCount;
          Notes := Format('%d/%d hit', [HitCount, Length(Sample)]);
        end;
  else
    Result :=
      procedure(ADataSet: TFDDataSet; out RowsProcessed: Integer; out Notes: string)
      var
        Total: Integer;
      begin
        RowsProcessed := 0;
        Notes := '';
        ADataSet.First;
        Total := ADataSet.RecordCount;
        while not ADataSet.Eof do
        begin
          Inc(RowsProcessed);
          ReportProgress('Iterating all records', RowsProcessed, Total);
          ADataSet.Next;
        end;
        ReportProgress('Iterated all records', RowsProcessed, Total, True);
      end;
  end;
end;

procedure TForm1.btnRunFindKeyClick(Sender: TObject);
begin
  RunPerfTest(PerfTestNames[ptFindKey], GetPerfTestProc(ptFindKey));
end;

procedure TForm1.btnRunSetRangeClick(Sender: TObject);
begin
  RunPerfTest(PerfTestNames[ptSetRange], GetPerfTestProc(ptSetRange));
end;

procedure TForm1.btnRunLocateClick(Sender: TObject);
begin
  RunPerfTest(PerfTestNames[ptLocate], GetPerfTestProc(ptLocate));
end;

procedure TForm1.btnRunFullIterationClick(Sender: TObject);
begin
  RunPerfTest(PerfTestNames[ptFullIteration], GetPerfTestProc(ptFullIteration));
end;

function TForm1.GetDataSet: TFDDataSet;
begin
  if chkPerfUseQuery.Checked then
    Result := SQLFDQuery
  else
    Result := FDTable1;
end;

procedure TForm1.chkPerfUseQueryClick(Sender: TObject);
begin
  if FDTable1.Active then
    FDTable1.Close;
  if SQLFDQuery.Active then
    SQLFDQuery.Close;
end;

procedure TForm1.OpenTable(aTableName: string; IndexToUse: string);
begin
  if FDataSet.Active then
    FDataSet.Close;

  DataSource1.DataSet := FDataSet;

  if SQLFDConnection.Connected
    then SQLFDConnection.Connected := False
    else
      begin
        SetConnection;
        SetFDConnectionOptions;
      end;

  SQLFDConnection.Params.Database := DBNameEdit.Text;
  SQLFDConnection.Connected := True;

  if chkPerfUseQuery.Checked then
  begin
    SQLFDQuery.SQL.Text := 'select * from [dbo].['+aTableName+']';
    SQLFDQuery.IndexName := IndexToUse;
    SQLFDQuery.Open;
  end
  else
  begin
    FDTable1.TableName := '[dbo].['+aTableName+']';
    FDTable1.IndexName := IndexToUse;
    FDTable1.Open;
  end;

  FDataSet.First;
  AssignIndexAndFilterEdits;
end;

{ ---- Auto Benchmark ---- }

function ChainApply(const APrev, ACur: TBenchApplyProc): TBenchApplyProc;
begin
  Result :=
    procedure(AConnection: TFDConnection)
    begin
      if Assigned(APrev) then
        APrev(AConnection);
      ACur(AConnection);
    end;
end;

function MakeRowsetSizeOption(ASize: Integer): TBenchOption;
begin
  Result.Caption := 'RowsetSize=' + IntToStr(ASize);
  Result.Apply :=
    procedure(AConnection: TFDConnection)
    begin
      AConnection.FetchOptions.RowsetSize := ASize;
    end;
end;

function FetchModeCaption(AMode: TFDFetchMode): string;
begin
  Result := 'Mode=' + GetEnumName(TypeInfo(TFDFetchMode), Ord(AMode));
end;

function MakeFetchModeOption(AMode: TFDFetchMode): TBenchOption;
begin
  Result.Caption := FetchModeCaption(AMode);
  Result.Apply :=
    procedure(AConnection: TFDConnection)
    begin
      AConnection.FetchOptions.Mode := AMode;
    end;
end;

function CsvIf(ACondition: Boolean; const AValue: string): string;
begin
  if ACondition
    then Result := AValue
    else Result := '';
end;

function CsvQuote(const S: string): string;
begin
  Result := '"' + StringReplace(S, '"', '""', [rfReplaceAll]) + '"';
end;

constructor TBenchConfig.Create(const ACaption: string; const AApply: TBenchApplyProc);
begin
  inherited Create;
  Caption := ACaption;
  Apply := AApply;
  FSamples := TList<Double>.Create;
end;

destructor TBenchConfig.Destroy;
begin
  FSamples.Free;
  inherited;
end;

function TBenchConfig.Combine(const AOption: TBenchOption): TBenchConfig;
var
  NewCaption: string;
begin
  if Caption = ''
    then NewCaption := AOption.Caption
    else NewCaption := Caption + ', ' + AOption.Caption;
  Result := TBenchConfig.Create(NewCaption, ChainApply(Apply, AOption.Apply));
end;

function TBenchConfig.DisplayName: string;
begin
  if IsBaseline
    then Result := Caption + ' (original)'
    else Result := Caption;
end;

function TBenchConfig.Average: Double;
var
  Value: Double;
begin
  Result := 0;
  if FSamples.Count = 0 then
    Exit;
  for Value in FSamples do
    Result := Result + Value;
  Result := Result / FSamples.Count;
end;

function TBenchConfig.Median: Double;
var
  Sorted: TArray<Double>;
  Mid: Integer;
begin
  Result := 0;
  if FSamples.Count = 0 then
    Exit;
  Sorted := FSamples.ToArray;
  TArray.Sort<Double>(Sorted);
  Mid := Length(Sorted) div 2;
  if Odd(Length(Sorted))
    then Result := Sorted[Mid]
    else Result := (Sorted[Mid - 1] + Sorted[Mid]) / 2;
end;

{ To benchmark another FireDAC property, add a dimension here (one TBenchOption per
  value to try, plus the caption of the value currently on the Connection Options tab).
  Every dimension is cross-multiplied with the others. }
function TForm1.BuildBenchDimensions: TArray<TBenchDimension>;
const
  RowsetSizes: array[0..3] of Integer = (50, 100, 500, 1000);
  FetchModes: array[0..1] of TFDFetchMode = (fmOnDemand, fmAll);
var
  Dim: TBenchDimension;
  i: Integer;
begin
  SetLength(Result, 2);

  Dim.CurrentCaption := 'RowsetSize=' + IntToStr(StrToInt(edRowsetSize.Text));
  SetLength(Dim.Options, Length(RowsetSizes));
  for i := 0 to High(RowsetSizes) do
    Dim.Options[i] := MakeRowsetSizeOption(RowsetSizes[i]);
  Result[0] := Dim;

  Dim.CurrentCaption := FetchModeCaption(TFDFetchMode(Max(0, rgFetchMode.ItemIndex)));
  SetLength(Dim.Options, Length(FetchModes));
  for i := 0 to High(FetchModes) do
    Dim.Options[i] := MakeFetchModeOption(FetchModes[i]);
  Result[1] := Dim;
end;

{ Cross product of all dimensions. The configuration currently on the Connection
  Options tab is flagged as the baseline (added if it is not one of the combinations). }
function TForm1.BuildBenchConfigs: TObjectList<TBenchConfig>;
var
  Dims: TArray<TBenchDimension>;
  Dim: TBenchDimension;
  Next: TObjectList<TBenchConfig>;
  Cfg, Baseline: TBenchConfig;
  Opt: TBenchOption;
  BaselineCaption: string;
begin
  Dims := BuildBenchDimensions;
  Result := TObjectList<TBenchConfig>.Create(True);
  try
    Result.Add(TBenchConfig.Create('', nil));
    BaselineCaption := '';
    for Dim in Dims do
    begin
      if BaselineCaption = ''
        then BaselineCaption := Dim.CurrentCaption
        else BaselineCaption := BaselineCaption + ', ' + Dim.CurrentCaption;

      Next := TObjectList<TBenchConfig>.Create(True);
      try
        for Cfg in Result do
          for Opt in Dim.Options do
            Next.Add(Cfg.Combine(Opt));
      except
        Next.Free;
        raise;
      end;
      Result.Free;
      Result := Next;
    end;

    Baseline := nil;
    for Cfg in Result do
      if SameText(Cfg.Caption, BaselineCaption) then
      begin
        Baseline := Cfg;
        Break;
      end;
    if Baseline = nil then
    begin
      Baseline := TBenchConfig.Create(BaselineCaption, nil);
      Result.Insert(0, Baseline);
    end;
    Baseline.IsBaseline := True;
  except
    Result.Free;
    raise;
  end;
end;

{ One measured run: the connection gets the Connection Options tab values, then the
  configuration's overrides, so nothing leaks from the previous configuration. }
function TForm1.RunBenchOnce(AConfig: TBenchConfig; AKind: TPerfTestKind; const aTableName: string;
  out ElapsedMs: Double; out RowsProcessed: Integer; out ErrorMsg: string): Boolean;
var
  Notes: string;
begin
  ElapsedMs := 0;
  RowsProcessed := 0;
  ErrorMsg := '';
  try
    { OpenTable would reset the options from the UI if the connection were down. }
    EnsurePerfConnection;
    SetFetchOptions(SQLFDConnection);
    if Assigned(AConfig.Apply) then
      AConfig.Apply(SQLFDConnection);
  except
    on E: Exception do
    begin
      ErrorMsg := E.Message;
      Exit(False);
    end;
  end;
  ExecutePerfTest(aTableName, GetPerfTestProc(AKind), ElapsedMs, RowsProcessed, Notes, ErrorMsg);
  Result := ErrorMsg = '';
end;

procedure TForm1.SetBenchRunning(ARunning: Boolean);
begin
  FBenchRunning := ARunning;
  btnBenchRun.Enabled := not ARunning;
  btnBenchCancel.Enabled := ARunning;
  btnBenchExport.Enabled := (not ARunning) and (FBenchResults <> nil) and (FBenchResults.Count > 0);
  cbxBenchTest.Enabled := not ARunning;
  cbxBenchTables.Enabled := not ARunning;
  btnBenchRefreshTables.Enabled := not ARunning;
  rgBenchDataSet.Enabled := not ARunning;
  seBenchReps.Enabled := not ARunning;
  { Nothing else may touch the connection/datasets while the benchmark owns them. }
  Panel2.Enabled := not ARunning;
  PerfTestsTab.Enabled := not ARunning;
  ConnectionOptionsTab.Enabled := not ARunning;
end;

procedure TForm1.btnBenchRefreshTablesClick(Sender: TObject);
begin
  LoadTableNames(cbxBenchTables);
end;

procedure TForm1.btnBenchCancelClick(Sender: TObject);
begin
  FBenchCancel := True;
  lblBenchStatus.Caption := 'Cancelling after the current run...';
end;

{ Everything runs on the main thread: a TFDConnection and its datasets must not be
  shared between threads, and the VCL is not thread-safe. Application.ProcessMessages is
  only called between runs (never inside a timed run), which keeps the UI responsive
  to Cancel without affecting the measurements. }
procedure TForm1.btnBenchRunClick(Sender: TObject);
var
  Configs: TObjectList<TBenchConfig>;
  Cfg, Baseline: TBenchConfig;
  Kind: TPerfTestKind;
  TableName, ErrorMsg, Prefix: string;
  Reps, Rep, i, Done, Total, Rows, ExpectedRows: Integer;
  ElapsedMs: Double;
  SavedUseQuery, SavedTimer: Boolean;
begin
  if FBenchRunning then
    Exit;
  TableName := Trim(cbxBenchTables.Text);
  if TableName = '' then
    raise Exception.Create('Select or type a table name first.');
  if cbxBenchTest.ItemIndex < 0 then
    raise Exception.Create('Select the test to benchmark first.');

  Kind := TPerfTestKind(cbxBenchTest.ItemIndex);
  Reps := seBenchReps.Value;
  Configs := BuildBenchConfigs;
  try
    Baseline := nil;
    for Cfg in Configs do
      if Cfg.IsBaseline then
        Baseline := Cfg;

    FBenchInfo := Format('%s | %s | %s | %d repetitions',
      [PerfTestNames[Kind], TableName, rgBenchDataSet.Items[rgBenchDataSet.ItemIndex], Reps]);
    SavedUseQuery := chkPerfUseQuery.Checked;
    SavedTimer := ConnectionCheckTimer.Enabled;
    ConnectionCheckTimer.Enabled := False;
    FBenchCancel := False;
    SetBenchRunning(True);
    try
      chkPerfUseQuery.Checked := rgBenchDataSet.ItemIndex = 1;

      Total := 1 + Reps * Configs.Count;
      Done := 0;
      ExpectedRows := -1;
      pbBench.Max := Total;
      pbBench.Position := 0;

      { Untimed warm-up on the original configuration so server/driver caches are
        warm for every measured run. }
      lblBenchStatus.Caption := 'Warm-up run...';
      Application.ProcessMessages;
      RunBenchOnce(Baseline, Kind, TableName, ElapsedMs, Rows, ErrorMsg);
      Inc(Done);
      pbBench.Position := Done;
      pbBench.Update;

      { Repetition-major order with a rotating start, so slow drift (cache, load)
        does not favour whichever configuration happens to run first. }
      for Rep := 0 to Reps - 1 do
      begin
        for i := 0 to Configs.Count - 1 do
        begin
          Application.ProcessMessages;
          if FBenchCancel then
            Break;
          Cfg := Configs[(i + Rep) mod Configs.Count];
          lblBenchStatus.Caption := Format('Run %d/%d (repetition %d/%d): %s',
            [Done, Total - 1, Rep + 1, Reps, Cfg.DisplayName]);
          lblBenchStatus.Update;  { repaint now; the main thread blocks during the run }

          if RunBenchOnce(Cfg, Kind, TableName, ElapsedMs, Rows, ErrorMsg) then
          begin
            Cfg.Samples.Add(ElapsedMs);
            if ExpectedRows < 0 then
              ExpectedRows := Rows
            else if Rows <> ExpectedRows then
              Cfg.Notes := Format('Row count differs (%d vs %d)', [Rows, ExpectedRows]);
          end
          else
          begin
            Inc(Cfg.ErrorCount);
            Cfg.Notes := ErrorMsg;
          end;
          Inc(Done);
          pbBench.Position := Done;
          pbBench.Update;
        end;
        if FBenchCancel then
          Break;
      end;

      if FBenchCancel
        then Prefix := 'Cancelled (partial results)'
        else Prefix := 'Completed';
      FreeAndNil(FBenchResults);
      FBenchResults := Configs;
      Configs := nil;
      RankBenchResults(FBenchResults);
      ShowBenchResults;
      lblBenchStatus.Caption := Prefix + ': ' + FBenchInfo;
    finally
      chkPerfUseQuery.Checked := SavedUseQuery;
      try
        SetFetchOptions(SQLFDConnection);
      except
        { UI values were already applied once; nothing more to restore if they are invalid. }
      end;
      ConnectionCheckTimer.Enabled := SavedTimer;
      SetBenchRunning(False);
    end;
  finally
    Configs.Free;
  end;
end;

procedure TForm1.RankBenchResults(AConfigs: TObjectList<TBenchConfig>);
begin
  AConfigs.Sort(TComparer<TBenchConfig>.Construct(
    function(const L, R: TBenchConfig): Integer
    begin
      if (L.Samples.Count = 0) and (R.Samples.Count = 0) then
        Result := 0
      else if L.Samples.Count = 0 then
        Result := 1
      else if R.Samples.Count = 0 then
        Result := -1
      else
        Result := CompareValue(L.Average, R.Average);
    end));
end;

procedure TForm1.InitBenchResultsGrid;
begin
  grdBenchResults.RowCount := 1;
  grdBenchResults.Cells[0, 0] := 'Rank';
  grdBenchResults.Cells[1, 0] := 'Configuration';
  grdBenchResults.Cells[2, 0] := 'Average';
  grdBenchResults.Cells[3, 0] := 'Median';
  grdBenchResults.Cells[4, 0] := 'vs Original (+ = faster)';
  grdBenchResults.Cells[5, 0] := 'OK / Errors';
  grdBenchResults.Cells[6, 0] := 'Notes';
  AutoSizeGridColumns(grdBenchResults);
end;

procedure TForm1.ShowBenchResults;
var
  Cfg, Baseline: TBenchConfig;
  Row, Rank: Integer;
  Improvement: string;
begin
  InitBenchResultsGrid;
  Baseline := nil;
  for Cfg in FBenchResults do
    if Cfg.IsBaseline then
      Baseline := Cfg;

  Rank := 0;
  for Cfg in FBenchResults do
  begin
    Row := grdBenchResults.RowCount;
    grdBenchResults.RowCount := Row + 1;
    if Cfg.Samples.Count = 0 then
    begin
      grdBenchResults.Cells[0, Row] := '-';
      grdBenchResults.Cells[2, Row] := '-';
      grdBenchResults.Cells[3, Row] := '-';
      Improvement := '-';
    end
    else
    begin
      Inc(Rank);
      grdBenchResults.Cells[0, Row] := IntToStr(Rank);
      grdBenchResults.Cells[2, Row] := Format('%.1f ms', [Cfg.Average]);
      grdBenchResults.Cells[3, Row] := Format('%.1f ms', [Cfg.Median]);
      if Cfg.IsBaseline then
        Improvement := '0.0% (original)'
      else if (Baseline <> nil) and (Baseline.Samples.Count > 0) and (Baseline.Average > 0) then
        Improvement := Format('%+.1f%%', [(Baseline.Average - Cfg.Average) / Baseline.Average * 100])
      else
        Improvement := '-';
    end;
    grdBenchResults.Cells[1, Row] := Cfg.DisplayName;
    grdBenchResults.Cells[4, Row] := Improvement;
    grdBenchResults.Cells[5, Row] := Format('%d / %d', [Cfg.Samples.Count, Cfg.ErrorCount]);
    grdBenchResults.Cells[6, Row] := Cfg.Notes;
  end;
  AutoSizeGridColumns(grdBenchResults);
end;

function TForm1.BenchResultsToCsv: string;
var
  Lines: TStringList;
  Cfg, Baseline: TBenchConfig;
  FS: TFormatSettings;
  Rank: Integer;
  Samples: TStringList;
  Value: Double;
  Improvement: string;
begin
  FS := TFormatSettings.Invariant;
  Baseline := nil;
  for Cfg in FBenchResults do
    if Cfg.IsBaseline then
      Baseline := Cfg;

  Lines := TStringList.Create;
  Samples := TStringList.Create;
  try
    Lines.Add('Rank,Configuration,Original,Average_ms,Median_ms,Improvement_vs_Original_pct,' +
      'OK_Runs,Errors,Samples_ms,Notes,Run');
    Rank := 0;
    for Cfg in FBenchResults do
    begin
      Samples.Clear;
      for Value in Cfg.Samples do
        Samples.Add(Format('%.3f', [Value], FS));

      if Cfg.Samples.Count > 0 then
        Inc(Rank);
      if (Cfg.Samples.Count = 0) or (Baseline = nil) or (Baseline.Samples.Count = 0) or (Baseline.Average <= 0)
        then Improvement := ''
        else Improvement := Format('%.2f', [(Baseline.Average - Cfg.Average) / Baseline.Average * 100], FS);

      Lines.Add(string.Join(',', [
        CsvIf(Cfg.Samples.Count > 0, IntToStr(Rank)),
        CsvQuote(Cfg.Caption),
        PrtYN(Cfg.IsBaseline),
        CsvIf(Cfg.Samples.Count > 0, Format('%.3f', [Cfg.Average], FS)),
        CsvIf(Cfg.Samples.Count > 0, Format('%.3f', [Cfg.Median], FS)),
        Improvement,
        IntToStr(Cfg.Samples.Count),
        IntToStr(Cfg.ErrorCount),
        CsvQuote(string.Join(';', Samples.ToStringArray)),
        CsvQuote(Cfg.Notes),
        CsvQuote(FBenchInfo)]));
    end;
    Result := Lines.Text;
  finally
    Samples.Free;
    Lines.Free;
  end;
end;

procedure TForm1.btnBenchExportClick(Sender: TObject);
var
  Dialog: TSaveDialog;
begin
  if (FBenchResults = nil) or (FBenchResults.Count = 0) then
  begin
    ShowMessage('Run the Auto Benchmark first.');
    Exit;
  end;
  Dialog := TSaveDialog.Create(nil);
  try
    Dialog.Filter := 'CSV files (*.csv)|*.csv|All files (*.*)|*.*';
    Dialog.DefaultExt := 'csv';
    Dialog.FileName := 'AutoBenchmark_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.csv';
    Dialog.Options := Dialog.Options + [ofOverwritePrompt];
    if Dialog.Execute then
      TFile.WriteAllText(Dialog.FileName, BenchResultsToCsv, TEncoding.UTF8);
  finally
    Dialog.Free;
  end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  { The benchmark owns the connection; ask it to stop and let the user close afterwards. }
  CanClose := not FBenchRunning;
  if FBenchRunning then
    FBenchCancel := True;
end;

destructor TForm1.Destroy;
begin
  FBenchResults.Free;
  inherited;
end;

function TForm1.PrtYN(const yn: boolean): string;
begin
  if yn
    then result := 'Yes'
    else result := 'No';
end;

function TForm1.UseAnyAzureAD: Boolean;
begin
  result := UseAzureADInteractiveCB.Checked or UseAzureADIntegratedCB.Checked;
end;

procedure TForm1.SetConnection;
var
  aAuthMode: string;
begin
  SQLFDConnection.Params.DriverID := 'MSSQL';

  if SQLFDConnection.Params.IndexOfName('Server') > -1 then
    SQLFDConnection.Params.Values['Server'] := SQLServerNameEdit.Text
  else
    SQLFDConnection.Params.AddPair('Server', SQLServerNameEdit.Text);

  if SQLFDConnection.Params.IndexOfName('OSAuthent') > -1 then
    SQLFDConnection.Params.Values['OSAuthent'] := PrtYN(UseOSAuthenticationCB.Checked)
  else
    SQLFDConnection.Params.AddPair('OSAuthent', PrtYN(UseOSAuthenticationCB.Checked));

  if SQLFDConnection.Params.IndexOfName('Encrypt') > -1
    then SQLFDConnection.Params.Values['Encrypt'] := PrtYN(UseAnyAzureAD)
    else SQLFDConnection.Params.Add('Encrypt=' + PrtYN(UseAnyAzureAD));

  if SQLFDConnection.Params.IndexOfName('TrustServerCertificate') > -1 then
    SQLFDConnection.Params.Values['TrustServerCertificate'] := 'Yes'
  else
    SQLFDConnection.Params.Add('TrustServerCertificate=Yes');

  if UseAnyAzureAD
    then
      begin
        if UseAzureADIntegratedCB.Checked
          then aAuthMode := 'ActiveDirectoryIntegrated'
          else aAuthMode := 'ActiveDirectoryInteractive';
        if SQLFDConnection.Params.IndexOfName('ODBCAdvanced') > -1
          then SQLFDConnection.Params.Values['ODBCAdvanced'] := 'Authentication=' + aAuthMode
          else SQLFDConnection.Params.Add('ODBCAdvanced=Authentication=' + aAuthMode);
      end
    else
      begin
        if SQLFDConnection.Params.IndexOfName('ODBCAdvanced') > -1
          then SQLFDConnection.Params.Delete(SQLFDConnection.Params.IndexOfName('ODBCAdvanced'));
      end;

  SQLFDConnection.Params.UserName := SQLServerUsernameEdit.Text;
  if not UseAnyAzureAD
    then SQLFDConnection.Params.Password := SQLServerPasswordEdit.Text;
end;

procedure TForm1.SetFDConnectionOptions;
var
  i: Integer;
begin
  with SQLFDConnection do
    begin
      FetchOptions.RestoreDefaults;
      ResourceOptions.RestoreDefaults;
      UpdateOptions.RestoreDefaults;
      FormatOptions.RestoreDefaults;

      LoginPrompt := False;
    end;

  SetFetchOptions(SQLFDConnection);
  SetFormatOptions(SQLFDConnection);
  SetResourceOptions(SQLFDConnection);
  SetUpdateOptions(SQLFDConnection);

end;

procedure TForm1.SetFetchOptions(AConnection: TFDConnection);
var
  i: Integer;
  FetchItems: TFDFetchItems;
begin
  with AConnection do
    begin
      FetchOptions.CursorKind := TFDCursorKind(rgCursorKind.ItemIndex);
      FetchOptions.Mode := TFDFetchMode(rgFetchMode.ItemIndex);

      FetchOptions.LiveWindowParanoic := chkLiveWindowParanoic.Checked;  {Default is True}
      FetchOptions.LiveWindowFastFirst := chkLiveWindowFastFirst.Checked; {Default is False}
      FetchOptions.AutoClose := chkAutoClose.Checked;
      FetchOptions.Unidirectional := chkUnidirectional.Checked;
      FetchOptions.DetailOptimize := chkDetailOptimize.Checked;
      FetchOptions.DetailCascade := chkDetailCascade.Checked;
      FetchOptions.DetailServerCascade := chkDetailServerCascade.Checked;

      FetchOptions.AutoFetchAll := TFDAutoFetchAll(rgAutoFetchAll.ItemIndex);

      FetchOptions.RecsSkip := StrToInt(edRecsSkip.Text);
      FetchOptions.RecsMax := StrToInt(edRecsMax.Text);
      FetchOptions.RowsetSize := StrToInt(edRowsetSize.Text);
      FetchOptions.DetailDelay := StrToInt(edDetailDelay.Text);

      FetchItems := [];
      for i := 0 to ckFetchItem.Items.Count - 1 do
      begin
        if ckFetchItem.Items[i].Checked then
        begin
          FetchItems := FetchItems + [TFDFetchItem(i)];
        end;
      end;

      FetchOptions.Items := FetchItems;

      FetchItems := [];
      for i := 0 to ckCache.Items.Count - 1 do
      begin
        if ckCache.Items[i].Checked then
        begin
          FetchItems := FetchItems + [TFDFetchItem(i)];
        end;
      end;
      FetchOptions.Cache := FetchItems;

      FetchOptions.RecordCountMode := TFDRecordCountMode(rgRecordCountMode.ItemIndex);
    end;
end;

procedure TForm1.SetFormatOptions(AConnection: TFDConnection);
var
  i: Integer;
begin
  with AConnection do
    begin
      FormatOptions.StrsTrim := chkStrsTrim.Checked;
      FormatOptions.StrsEmpty2Null := chkStrsEmpty2Null.Checked;
      FormatOptions.StrsTrim2Len := chkStrsTrim2Len.Checked;
      FormatOptions.CheckPrecision := chkCheckPrecision.Checked;
      FormatOptions.ADOCompatibility := chkADOCompatibility.Checked;
      FormatOptions.DataSnapCompatibility := chkDataSnapCompatibility.Checked;
      FormatOptions.QuoteIdentifiers := chkQuoteIdentifiers.Checked;

      case rgSortLocate.ItemIndex of
        0: FormatOptions.SortLocale := LOCALE_SYSTEM_DEFAULT;
        1: FormatOptions.SortLocale := LOCALE_USER_DEFAULT;
        2: FormatOptions.SortLocale := LOCALE_CUSTOM_DEFAULT;
        3: FormatOptions.SortLocale := LOCALE_CUSTOM_UNSPECIFIED;
        4: FormatOptions.SortLocale := LOCALE_CUSTOM_UI_DEFAULT;
        5: FormatOptions.SortLocale := LOCALE_NEUTRAL;
        6: FormatOptions.SortLocale := LOCALE_INVARIANT;
      end;

      FormatOptions.SortOptions := [];

      for i := 0 to ckSortOptions.Items.Count - 1 do
      begin
        if ckSortOptions.Items[i].Checked then
        begin
          FormatOptions.SortOptions := FormatOptions.SortOptions +
          [TFDSortOption(i)];
        end;
      end;
    end;
end;

procedure TForm1.SetResourceOptions(AConnection: TFDConnection);
begin
  with AConnection do
    begin
      ResourceOptions.ServerOutput := chkServerOutput.Checked;
      ResourceOptions.MacroCreate := chkMacroCreate.Checked;
      ResourceOptions.MacroExpand := chkMacroExpand.Checked;
      ResourceOptions.DirectExecute := chkDirectExecute.Checked;
      ResourceOptions.SilentMode := chkSilentMode.Checked;
    end;
end;

procedure TForm1.SetUpdateOptions(AConnection: TFDConnection);
begin
  with AConnection do
    begin
      UpdateOptions.LockMode := TFDLockMode(rgLockMode.ItemIndex); //(Default is lmNone)
      UpdateOptions.LockPoint := TFDLockPoint(rgLockPoint.ItemIndex); //(lpDeferred)
      UpdateOptions.LockWait := chkLockWait.Checked;  //(Default is False)
      UpdateOptions.AutoCommitUpdates := chkAutoCommitUpdates.Checked; //(Default is False)
      UpdateOptions.UpdateMode := DB.TUpdateMode(rgUpdateMode.ItemIndex); // upWhereKeyOnly is the Default
      UpdateOptions.FetchGeneratorsPoint := TFDFetchGeneratorsPoint(rgFetchGeneratorsPoint.ItemIndex);
    end;
end;

procedure TForm1.LoadDefaultConnectionOptions;
begin
  with SQLFDConnection do
    begin
      FetchOptions.RestoreDefaults;
      ResourceOptions.RestoreDefaults;
      UpdateOptions.RestoreDefaults;
      FormatOptions.RestoreDefaults;

      FetchOptions.CursorKind := ckAutomatic;
      FetchOptions.Mode := fmOnDemand;
      FetchOptions.LiveWindowParanoic := True;  {Default is True}
      FetchOptions.LiveWindowFastFirst := True; {Default is False}
      FetchOptions.AutoFetchAll := afAll; {Default is afAll}

      ResourceOptions.MacroCreate := False; {Default is True}
      ResourceOptions.MacroExpand := False; {Default is True}
      ResourceOptions.DirectExecute := False; {Default is False}

      UpdateOptions.LockMode := lmPessimistic; {Default is lmNone}
      UpdateOptions.LockPoint := lpImmediate;  {Default is lpDeferred}
      UpdateOptions.LockWait := False;  {Default is False}
      UpdateOptions.AutoCommitUpdates := True; {Default is False}
      UpdateOptions.UpdateMode := DB.upWhereKeyOnly;  {Default is upWhereKeyOnly}

    end;
end;

procedure TForm1.LoadFDConnectionOptions;
begin
  if not SQLFDConnection.Connected then
  begin
    SetConnection;
    SQLFDConnection.Connected := True;
  end;

  LoadFetchOptions(SQLFDConnection);
  LoadFormatOptions(SQLFDConnection);
  LoadResourceOptions(SQLFDConnection);
  LoadUpdateOptions(SQLFDConnection);
end;

procedure TForm1.LoadFetchOptions(AConnection: TFDConnection);
var
  FetchItem: TFDFetchItem;
begin
  with AConnection do
    begin
      rgCursorKind.ItemIndex := Ord(FetchOptions.CursorKind);
      rgFetchMode.ItemIndex := Ord(FetchOptions.Mode);

      chkLiveWindowParanoic.Checked := FetchOptions.LiveWindowParanoic;
      chkLiveWindowFastFirst.Checked := FetchOptions.LiveWindowFastFirst;
      chkAutoClose.Checked := FetchOptions.AutoClose;
      chkUnidirectional.Checked := FetchOptions.Unidirectional;
      chkDetailOptimize.Checked := FetchOptions.DetailOptimize;
      chkDetailCascade.Checked := FetchOptions.DetailCascade;
      chkDetailServerCascade.Checked := FetchOptions.DetailServerCascade;

      rgAutoFetchAll.ItemIndex := Ord(FetchOptions.AutoFetchAll);

      edRecsSkip.Text := FetchOptions.RecsSkip.ToString;
      edRecsMax.Text := FetchOptions.RecsMax.ToString;
      edRowsetSize.Text := FetchOptions.RowsetSize.ToString;
      edDetailDelay.Text := FetchOptions.DetailDelay.ToString;

      for FetchItem := Low(TFDFetchItem) to High(TFDFetchItem) do
      begin
        ckFetchItem.Items[Ord(FetchItem)].Checked := FetchItem in FetchOptions.Items;
      end;

      for FetchItem := Low(TFDFetchItem) to High(TFDFetchItem) do
      begin
        ckCache.Items[Ord(FetchItem)].Checked := FetchItem in FetchOptions.Cache;
      end;

      rgRecordCountMode.ItemIndex := Ord(FetchOptions.RecordCountMode);
    end;
end;

procedure TForm1.LoadFormatOptions(AConnection: TFDConnection);
var
  SortOption: TFDSortOption;
begin
  with AConnection do
    begin
      chkStrsTrim.Checked := FormatOptions.StrsTrim;
      chkStrsEmpty2Null.Checked := FormatOptions.StrsEmpty2Null;
      chkStrsTrim2Len.Checked := FormatOptions.StrsTrim2Len;
      chkCheckPrecision.Checked := FormatOptions.CheckPrecision;
      chkADOCompatibility.Checked := FormatOptions.ADOCompatibility;
      chkDataSnapCompatibility.Checked := FormatOptions.DataSnapCompatibility;
      chkQuoteIdentifiers.Checked := FormatOptions.QuoteIdentifiers;

      case FormatOptions.SortLocale of
        LOCALE_SYSTEM_DEFAULT: rgSortLocate.ItemIndex := 0;
        LOCALE_USER_DEFAULT: rgSortLocate.ItemIndex := 1;
        LOCALE_CUSTOM_DEFAULT: rgSortLocate.ItemIndex := 2;
        LOCALE_CUSTOM_UNSPECIFIED: rgSortLocate.ItemIndex := 3;
        LOCALE_CUSTOM_UI_DEFAULT: rgSortLocate.ItemIndex := 4;
        LOCALE_NEUTRAL: rgSortLocate.ItemIndex := 5;
        LOCALE_INVARIANT: rgSortLocate.ItemIndex := 6;
      else
        rgSortLocate.ItemIndex := -1;
      end;

      for SortOption := Low(TFDSortOption) to High(TFDSortOption) do
      begin
        ckSortOptions.Items[Ord(SortOption)].Checked := SortOption in FormatOptions.SortOptions;
      end;
    end;
end;

procedure TForm1.LoadResourceOptions(AConnection: TFDConnection);
begin
  with AConnection do
    begin
      chkServerOutput.Checked := ResourceOptions.ServerOutput;
      chkMacroCreate.Checked := ResourceOptions.MacroCreate;
      chkMacroExpand.Checked := ResourceOptions.MacroExpand;
      chkDirectExecute.Checked := ResourceOptions.DirectExecute;
      chkSilentMode.Checked := ResourceOptions.SilentMode;
    end;
end;

procedure TForm1.LoadUpdateOptions(AConnection: TFDConnection);
begin
  with AConnection do
    begin
      rgLockMode.ItemIndex := Ord(UpdateOptions.LockMode);   //(Default is lmNone)
      rgLockPoint.ItemIndex := Ord(UpdateOptions.LockPoint); //(lpDeferred)
      chkLockWait.Checked := UpdateOptions.LockWait;    //(Default is False)
      chkAutoCommitUpdates.Checked := UpdateOptions.AutoCommitUpdates;    //(Default is False)
      rgUpdateMode.ItemIndex := Ord(UpdateOptions.UpdateMode);  //is the Default
      rgFetchGeneratorsPoint.ItemIndex := Ord(UpdateOptions.FetchGeneratorsPoint);
    end;
end;

procedure TForm1.UseOSAuthenticationCBClick(Sender: TObject);
begin
  if UseOSAuthenticationCB.Checked
    then
      begin
        UseAzureADInteractiveCB.Checked := False;
        UseAzureADIntegratedCB.Checked := False;
      end;

  SQLServerUsernameEdit.Enabled := not UseOSAuthenticationCB.Checked;
  SQLServerPasswordEdit.Enabled := not UseOSAuthenticationCB.Checked and not UseAnyAzureAD;
end;

procedure TForm1.UseAzureADInteractiveCBClick(Sender: TObject);
begin
  if UseAzureADInteractiveCB.Checked
    then
      begin
        UseOSAuthenticationCB.Checked := False;
        UseAzureADIntegratedCB.Checked := False;
      end;

  SQLServerUsernameEdit.Enabled := not UseOSAuthenticationCB.Checked;
  SQLServerPasswordEdit.Enabled := not UseOSAuthenticationCB.Checked and not UseAnyAzureAD;
end;

procedure TForm1.UseAzureADIntegratedCBClick(Sender: TObject);
begin
  if UseAzureADIntegratedCB.Checked
    then
      begin
        UseOSAuthenticationCB.Checked := False;
        UseAzureADInteractiveCB.Checked := False;
      end;

  SQLServerUsernameEdit.Enabled := not UseOSAuthenticationCB.Checked;
  SQLServerPasswordEdit.Enabled := not UseOSAuthenticationCB.Checked and not UseAnyAzureAD;
end;

end.
