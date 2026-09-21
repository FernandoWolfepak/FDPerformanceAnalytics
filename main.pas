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
  System.Generics.Collections;

type
  TPerfTestProc = reference to procedure(ADataSet: TFDDataSet; out RowsProcessed: Integer; out Notes: string);

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
    procedure UseOSAuthenticationCBClick(Sender: TObject);
    procedure UseAzureADInteractiveCBClick(Sender: TObject);
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
  private
    FUpdatingConnectionToggle: Boolean;
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
    procedure RunPerfTest(const TestName: string; Proc: TPerfTestProc);

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
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  Tick       = #39; { single quotation mark }

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
begin
  try
    if SQLFDConnection.Connected
      then SQLFDConnection.Connected := False;

    SetConnection;
    SetFDConnectionOptions;

    SQLFDConnection.Params.Database := DBNameEdit.Text;
    SQLFDConnection.Connected := True;
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
begin
  UseOSAuthenticationCB.Checked := False;
  UseAzureADInteractiveCB.Checked := True;
  UseAzureADInteractiveCBClick(UseAzureADInteractiveCB);
  SQLFDConnection.Connected := False;

  LoadDefaultConnectionOptions;
  LoadFetchOptions(SQLFDConnection);
  LoadFormatOptions(SQLFDConnection);
  LoadResourceOptions(SQLFDConnection);
  LoadUpdateOptions(SQLFDConnection);

  InitPerfResultsGrid;

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
const
  Padding = 12;
var
  Col, Row, MaxWidth, TextW: Integer;
begin
  for Col := 0 to grdPerfResults.ColCount - 1 do
  begin
    MaxWidth := 0;
    for Row := 0 to grdPerfResults.RowCount - 1 do
    begin
      TextW := grdPerfResults.Canvas.TextWidth(grdPerfResults.Cells[Col, Row]);
      if TextW > MaxWidth then
        MaxWidth := TextW;
    end;
    grdPerfResults.ColWidths[Col] := MaxWidth + Padding;
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
end;

function TForm1.CollectPerfKeySample(ADataSet: TFDDataSet; AKeyField: TField; ASampleSize: Integer): TArray<Variant>;
var
  Keys: TList<Variant>;
  SampleStep, Count: Integer;
begin
  Keys := TList<Variant>.Create;
  try
    SampleStep := Max(1, ADataSet.RecordCount div ASampleSize);
    Count := 0;
    ADataSet.First;
    while (not ADataSet.Eof) and (Keys.Count < ASampleSize) do
    begin
      if Count mod SampleStep = 0 then
        Keys.Add(AKeyField.Value);
      Inc(Count);
      ADataSet.Next;
    end;
    Result := Keys.ToArray;
  finally
    Keys.Free;
  end;
end;

procedure TForm1.RunPerfTest(const TestName: string; Proc: TPerfTestProc);
var
  DataSet: TFDDataSet;
  Stopwatch: TStopwatch;
  RowsProcessed: Integer;
  Notes: string;
begin
  RowsProcessed := 0;
  Notes := '';
  Stopwatch := TStopwatch.StartNew;
  try
    try
      OpenTable(cbxPerfTables.Text, '');
      DataSet := FDataSet;
      DataSet.DisableControls;
      try
        Proc(DataSet, RowsProcessed, Notes);
      finally
        DataSet.EnableControls;
      end;
    except
      on E: Exception do
        Notes := 'Error: ' + E.Message;
    end;
  finally
    Stopwatch.Stop;
    AppendPerfResultRow(TestName, Stopwatch.ElapsedMilliseconds, RowsProcessed, Notes);
  end;
end;

procedure TForm1.btnRefreshPerfTablesClick(Sender: TObject);
begin
  EnsurePerfConnection;

  SQLFDQuery.Close;
  SQLFDQuery.SQL.Clear;
  SQLFDQuery.SQL.Add('select t.name from sys.tables t order by t.name');
  SQLFDQuery.Open;

  cbxPerfTables.Items.Clear;
  while not SQLFDQuery.Eof do
  begin
    cbxPerfTables.Items.Add(SQLFDQuery.FieldByName('name').AsString);
    SQLFDQuery.Next;
  end;
  SQLFDQuery.Close;
end;

procedure TForm1.btnClearPerfResultsClick(Sender: TObject);
begin
  InitPerfResultsGrid;
end;

procedure TForm1.btnRunFindKeyClick(Sender: TObject);
begin
  RunPerfTest('FindKey / GotoKey',
    procedure(ADataSet: TFDDataSet; out RowsProcessed: Integer; out Notes: string)
    var
      KeyField: TField;
      Sample: TArray<Variant>;
      HitCount, i: Integer;
    begin
      RowsProcessed := 0;
      Notes := '';

      if ADataSet.ClassType <> TFDTable then
      begin
        Notes := 'Not applicable to TFDQuery';
        Exit;
      end;

      KeyField := DetectPerfKeyField(ADataSet);
      TFDTable(ADataSet).IndexFieldNames := KeyField.FieldName;

      Sample := CollectPerfKeySample(ADataSet, KeyField, 20);
      HitCount := 0;
      for i := 0 to High(Sample) do
        if TFDTable(ADataSet).FindKey([Sample[i]]) then
          Inc(HitCount);

      RowsProcessed := HitCount;
      Notes := Format('%d/%d hit', [HitCount, Length(Sample)]);
    end);
end;

procedure TForm1.btnRunSetRangeClick(Sender: TObject);
begin
  RunPerfTest('SetRange / CancelRange',
    procedure(ADataSet: TFDDataSet; out RowsProcessed: Integer; out Notes: string)
    var
      KeyField: TField;
      Sample: TArray<Variant>;
      MinValue, MaxValue: Variant;
    begin
      RowsProcessed := 0;
      Notes := '';

      if ADataSet.ClassType <> TFDTable then
      begin
        Notes := 'Not applicable to TFDQuery';
        Exit;
      end;

      KeyField := DetectPerfKeyField(ADataSet);
      TFDTable(ADataSet).IndexFieldNames := KeyField.FieldName;

      Sample := CollectPerfKeySample(ADataSet, KeyField, 20);
      if Length(Sample) = 0 then
      begin
        Notes := 'No rows to sample';
        Exit;
      end;

      MinValue := Sample[0];
      MaxValue := Sample[High(Sample)];

      TFDTable(ADataSet).SetRange([MinValue], [MaxValue]);
      try
        ADataSet.First;
        while not ADataSet.Eof do
        begin
          Inc(RowsProcessed);
          ADataSet.Next;
        end;
      finally
        TFDTable(ADataSet).CancelRange;
      end;

      Notes := Format('Range [%s..%s]', [VarToStr(MinValue), VarToStr(MaxValue)]);
    end);
end;

procedure TForm1.btnRunLocateClick(Sender: TObject);
begin
  RunPerfTest('Locate',
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
    end);
end;

procedure TForm1.btnRunFullIterationClick(Sender: TObject);
begin
  RunPerfTest('Full Iteration',
    procedure(ADataSet: TFDDataSet; out RowsProcessed: Integer; out Notes: string)
    begin
      RowsProcessed := 0;
      Notes := '';
      ADataSet.First;
      while not ADataSet.Eof do
      begin
        Inc(RowsProcessed);
        ADataSet.Next;
      end;
    end);
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

function TForm1.PrtYN(const yn: boolean): string;
begin
  if yn
    then result := 'Yes'
    else result := 'No';
end;

procedure TForm1.SetConnection;
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
    then SQLFDConnection.Params.Values['Encrypt'] := PrtYN(UseAzureADInteractiveCB.Checked)
    else SQLFDConnection.Params.Add('Encrypt=' + PrtYN(UseAzureADInteractiveCB.Checked));

  if SQLFDConnection.Params.IndexOfName('TrustServerCertificate') > -1 then
    SQLFDConnection.Params.Values['TrustServerCertificate'] := 'Yes'
  else
    SQLFDConnection.Params.Add('TrustServerCertificate=Yes');

  if UseAzureADInteractiveCB.Checked
    then
      begin
        if SQLFDConnection.Params.IndexOfName('ODBCAdvanced') > -1
          then SQLFDConnection.Params.Values['ODBCAdvanced'] := 'Authentication=ActiveDirectoryInteractive'
          else SQLFDConnection.Params.Add('ODBCAdvanced=Authentication=ActiveDirectoryInteractive');
      end
    else
      begin
        if SQLFDConnection.Params.IndexOfName('ODBCAdvanced') > -1
          then SQLFDConnection.Params.Delete(SQLFDConnection.Params.IndexOfName('ODBCAdvanced'));
      end;

  SQLFDConnection.Params.UserName := SQLServerUsernameEdit.Text;
  if not UseAzureADInteractiveCB.Checked
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
    then UseAzureADInteractiveCB.Checked := False;

  SQLServerUsernameEdit.Enabled := not UseOSAuthenticationCB.Checked;
  SQLServerPasswordEdit.Enabled := not UseOSAuthenticationCB.Checked and not UseAzureADInteractiveCB.Checked;
end;

procedure TForm1.UseAzureADInteractiveCBClick(Sender: TObject);
begin
  if UseAzureADInteractiveCB.Checked
    then UseOSAuthenticationCB.Checked := False;

  SQLServerUsernameEdit.Enabled := not UseOSAuthenticationCB.Checked;
  SQLServerPasswordEdit.Enabled := not UseOSAuthenticationCB.Checked and not UseAzureADInteractiveCB.Checked;
end;

end.
