object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 506
  ClientWidth = 783
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 783
    Height = 100
    Align = alTop
    TabOrder = 0
    object TopNoteLbl: TLabel
      Left = 1
      Top = 1
      Width = 781
      Height = 13
      Align = alTop
      Caption = 
        'A sample project that connects to SQL Server using FireDAC and r' +
        'uns some performance tests'
      WordWrap = True
      ExplicitWidth = 453
    end
    object Label4: TLabel
      Left = 232
      Top = 31
      Width = 80
      Height = 13
      Caption = 'Database Name:'
    end
    object Label19: TLabel
      Left = 181
      Top = 57
      Width = 109
      Height = 13
      Caption = 'SQL Server Username:'
    end
    object Label20: TLabel
      Left = 371
      Top = 57
      Width = 50
      Height = 13
      Caption = 'Password:'
    end
    object Label10: TLabel
      Left = 5
      Top = 31
      Width = 58
      Height = 13
      Caption = 'SQL Server:'
    end
    object CurrentIndexLbl: TLabel
      Left = 576
      Top = 17
      Width = 78
      Height = 13
      Caption = 'CurrentIndexLbl'
      Visible = False
    end
    object CurrentFilterLbl: TLabel
      Left = 576
      Top = 36
      Width = 74
      Height = 13
      Caption = 'CurrentFilterLbl'
      Visible = False
    end
    object CurrentRecordCountLbl: TLabel
      Left = 576
      Top = 55
      Width = 113
      Height = 13
      Caption = 'CurrentRecordCountLbl'
      Visible = False
    end
    object DBNameEdit: TEdit
      Left = 316
      Top = 27
      Width = 221
      Height = 21
      TabOrder = 0
      Text = 'GULFE2_28698_27AUG25_29699_15SEP25_FLB'
    end
    object SQLServerUsernameEdit: TEdit
      Left = 296
      Top = 53
      Width = 61
      Height = 21
      TabOrder = 1
      Text = 'fernando.leite@pakenergy.com'
    end
    object SQLServerPasswordEdit: TEdit
      Left = 422
      Top = 53
      Width = 115
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
    end
    object UseOSAuthenticationCB: TCheckBox
      Left = 10
      Top = 55
      Width = 155
      Height = 17
      Caption = 'Use Windows Authentication'
      TabOrder = 3
      OnClick = UseOSAuthenticationCBClick
    end
    object SQLServerNameEdit: TEdit
      Left = 66
      Top = 27
      Width = 151
      Height = 21
      TabOrder = 4
      Text = 'tcp:pe-erpsql-dev-srv001.database.windows.net,1433'
    end
    object UseAzureADInteractiveCB: TCheckBox
      Left = 10
      Top = 78
      Width = 250
      Height = 17
      Caption = 'Use Azure AD Interactive Authentication'
      TabOrder = 5
      OnClick = UseAzureADInteractiveCBClick
    end
    object btnConnect: TButton
      Left = 576
      Top = 71
      Width = 164
      Height = 25
      Caption = 'Connect'
      TabOrder = 6
      OnClick = btnConnectClick
    end
    object ConnectionAliveCB: TCheckBox
      Left = 270
      Top = 78
      Width = 140
      Height = 17
      Caption = 'Connection Alive'
      TabOrder = 7
      OnClick = ConnectionAliveCBClick
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 364
    Width = 783
    Height = 142
    Align = alClient
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object PageControl: TPageControl
    Left = 0
    Top = 100
    Width = 783
    Height = 264
    ActivePage = tsCommand
    Align = alTop
    TabOrder = 2
    object tsCommand: TTabSheet
      Caption = 'Command'
    end
    object ConnectionOptionsTab: TTabSheet
      Caption = 'Connection Options'
      ImageIndex = 1
      object Button6: TButton
        Left = 6
        Top = 248
        Width = 229
        Height = 25
        Caption = '5. Open Table with "BYDESCRIPTION" Index'
        TabOrder = 0
      end
      object ckbFilterFetchOptions: TCheckBox
        Left = 241
        Top = 247
        Width = 46
        Height = 17
        Caption = 'Filter'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = ckbFilterFetchOptionsClick
      end
      object PageControl1: TcxPageControl
        Left = 0
        Top = 0
        Width = 775
        Height = 236
        Align = alClient
        TabOrder = 2
        Properties.ActivePage = FetchOptionsTab
        Properties.CustomButtons.Buttons = <>
        ClientRectBottom = 232
        ClientRectLeft = 4
        ClientRectRight = 771
        ClientRectTop = 24
        object FetchOptionsTab: TcxTabSheet
          Caption = 'FetchOptionsTab'
          ImageIndex = 0
          object lblRecsSkip: TLabel
            Left = 162
            Top = 119
            Width = 42
            Height = 13
            Caption = 'RecsSkip'
          end
          object lblRecsMax: TLabel
            Left = 234
            Top = 119
            Width = 43
            Height = 13
            Caption = 'RecsMax'
          end
          object lblRowsetSize: TLabel
            Left = 300
            Top = 119
            Width = 55
            Height = 13
            Caption = 'RowsetSize'
          end
          object Label13: TLabel
            Left = 592
            Top = 2
            Width = 49
            Height = 13
            Caption = 'FetchItem'
          end
          object lblCache: TLabel
            Left = 592
            Top = 83
            Width = 30
            Height = 13
            Caption = 'Cache'
          end
          object lblDetailDelay: TLabel
            Left = 367
            Top = 119
            Width = 54
            Height = 13
            Caption = 'DetailDelay'
          end
          object rgCursorKind: TRadioGroup
            Left = 6
            Top = 10
            Width = 131
            Height = 105
            Caption = 'CursorKind'
            ItemIndex = 0
            Items.Strings = (
              'ckAutomatic'
              'ckDefault'
              'ckDynamic'
              'ckStatic'
              'ckForwardOnly')
            TabOrder = 0
          end
          object rgFetchMode: TRadioGroup
            Left = 143
            Top = 10
            Width = 125
            Height = 105
            Caption = 'Mode'
            ItemIndex = 1
            Items.Strings = (
              'fmManual'
              'fmOnDemand'
              'fmAll'
              'fmExactRecsMax')
            TabOrder = 1
          end
          object chkLiveWindowParanoic: TCheckBox
            Left = 274
            Top = 10
            Width = 143
            Height = 17
            Caption = 'LiveWindowParanoic'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
          object chkLiveWindowFastFirst: TCheckBox
            Left = 274
            Top = 33
            Width = 143
            Height = 17
            Caption = 'LiveWindowFastFirst'
            TabOrder = 3
          end
          object rgAutoFetchAll: TRadioGroup
            Left = 6
            Top = 121
            Width = 141
            Height = 70
            Caption = 'AutoFetchAll'
            ItemIndex = 0
            Items.Strings = (
              'afAll'
              'afTruncate'
              'afDisable')
            TabOrder = 4
          end
          object edRecsSkip: TEdit
            Left = 160
            Top = 137
            Width = 53
            Height = 21
            NumbersOnly = True
            TabOrder = 5
            Text = '-1'
          end
          object edRecsMax: TEdit
            Left = 232
            Top = 137
            Width = 53
            Height = 21
            NumbersOnly = True
            TabOrder = 6
            Text = '-1'
          end
          object edRowsetSize: TEdit
            Left = 300
            Top = 137
            Width = 53
            Height = 21
            NumbersOnly = True
            TabOrder = 7
            Text = '-1'
          end
          object ckFetchItem: TcxCheckListBox
            Left = 591
            Top = 18
            Width = 141
            Height = 59
            Items = <
              item
                State = cbsChecked
                Text = 'fiBlobs'
              end
              item
                State = cbsChecked
                Text = 'fiDetails'
              end
              item
                State = cbsChecked
                Text = 'fiMeta'
              end>
            TabOrder = 8
          end
          object ckCache: TcxCheckListBox
            Left = 591
            Top = 99
            Width = 141
            Height = 59
            Items = <
              item
                State = cbsChecked
                Text = 'fiBlobs'
              end
              item
                State = cbsChecked
                Text = 'fiDetails'
              end
              item
                State = cbsChecked
                Text = 'fiMeta'
              end>
            TabOrder = 9
          end
          object chkAutoClose: TCheckBox
            Left = 274
            Top = 57
            Width = 143
            Height = 17
            Caption = 'AutoClose'
            TabOrder = 10
          end
          object rgRecordCountMode: TRadioGroup
            Left = 423
            Top = 79
            Width = 123
            Height = 79
            Caption = 'RecordCountMode'
            ItemIndex = 0
            Items.Strings = (
              'cmVisible'
              'cmFetched'
              'cmTotal')
            TabOrder = 11
          end
          object chkUnidirectional: TCheckBox
            Left = 274
            Top = 80
            Width = 143
            Height = 17
            Caption = 'Unidirectional'
            TabOrder = 12
          end
          object edDetailDelay: TEdit
            Left = 367
            Top = 137
            Width = 53
            Height = 21
            NumbersOnly = True
            TabOrder = 13
            Text = '-1'
          end
          object chkDetailOptimize: TCheckBox
            Left = 423
            Top = 10
            Width = 138
            Height = 17
            Caption = 'DetailOptimize'
            Checked = True
            State = cbChecked
            TabOrder = 14
          end
          object chkDetailCascade: TCheckBox
            Left = 423
            Top = 33
            Width = 138
            Height = 17
            Caption = 'DetailCascade'
            Checked = True
            State = cbChecked
            TabOrder = 15
          end
          object chkDetailServerCascade: TCheckBox
            Left = 423
            Top = 56
            Width = 138
            Height = 17
            Caption = 'DetailServerCascade'
            Checked = True
            State = cbChecked
            TabOrder = 16
          end
          object btnFetchOptionsRestoreDefaults: TButton
            Left = 562
            Top = 162
            Width = 170
            Height = 43
            Caption = 'Restore Defaults'
            TabOrder = 17
            OnClick = btnFetchOptionsRestoreDefaultsClick
          end
        end
        object FormatOptionsTab: TcxTabSheet
          Caption = 'FormatOptionsTab'
          ImageIndex = 1
          object Label14: TLabel
            Left = 15
            Top = 10
            Width = 57
            Height = 13
            Caption = 'SortOptions'
          end
          object ckSortOptions: TcxCheckListBox
            Left = 14
            Top = 29
            Width = 141
            Height = 140
            Items = <
              item
                Text = 'soNoCase'
              end
              item
                Text = 'soNullFirst'
              end
              item
                Text = 'soDescNullLast'
              end
              item
                Text = 'soDescending'
              end
              item
                Text = 'soUnique'
              end
              item
                Text = 'soPrimary'
              end
              item
                Text = 'soNoSymbols'
              end
              item
                Text = 'soDigitsAsNumbers'
              end>
            TabOrder = 0
          end
          object rgSortLocate: TRadioGroup
            Left = 177
            Top = 10
            Width = 224
            Height = 159
            Caption = 'SortLocate'
            ItemIndex = 1
            Items.Strings = (
              'LOCALE_SYSTEM_DEFAULT'
              'LOCALE_USER_DEFAULT'
              'LOCALE_CUSTOM_DEFAULT'
              'LOCALE_CUSTOM_UNSPECIFIED'
              'LOCALE_CUSTOM_UI_DEFAULT'
              'LOCALE_NEUTRAL'
              'LOCALE_INVARIANT')
            TabOrder = 1
          end
          object chkStrsTrim: TCheckBox
            Left = 418
            Top = 11
            Width = 87
            Height = 17
            Caption = 'StrsTrim'
            TabOrder = 2
          end
          object chkStrsEmpty2Null: TCheckBox
            Left = 418
            Top = 34
            Width = 119
            Height = 17
            Caption = 'StrsEmpty2Null'
            TabOrder = 3
          end
          object chkStrsTrim2Len: TCheckBox
            Left = 418
            Top = 57
            Width = 103
            Height = 17
            Caption = 'StrsTrim2Len'
            TabOrder = 4
          end
          object chkCheckPrecision: TCheckBox
            Left = 418
            Top = 80
            Width = 103
            Height = 17
            Caption = 'CheckPrecision'
            TabOrder = 5
          end
          object chkADOCompatibility: TCheckBox
            Left = 418
            Top = 126
            Width = 143
            Height = 17
            Caption = 'ADOCompatibility'
            TabOrder = 6
          end
          object chkDataSnapCompatibility: TCheckBox
            Left = 418
            Top = 103
            Width = 167
            Height = 17
            Caption = 'DataSnapCompatibility'
            TabOrder = 7
          end
          object chkQuoteIdentifiers: TCheckBox
            Left = 418
            Top = 149
            Width = 143
            Height = 17
            Caption = 'QuoteIdentifiers'
            TabOrder = 8
          end
          object btnFormatOptionsRestoreDefaults: TButton
            Left = 571
            Top = 21
            Width = 170
            Height = 43
            Caption = 'Restore Defaults'
            TabOrder = 9
            OnClick = btnFormatOptionsRestoreDefaultsClick
          end
        end
        object ResourceOptionsTab: TcxTabSheet
          Caption = 'ResourceOptions'
          ImageIndex = 2
          object chkMacroCreate: TCheckBox
            Left = 18
            Top = 19
            Width = 111
            Height = 17
            Caption = 'MacroCreate'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object chkMacroExpand: TCheckBox
            Left = 18
            Top = 42
            Width = 111
            Height = 17
            Caption = 'MacroExpand'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object chkDirectExecute: TCheckBox
            Left = 18
            Top = 65
            Width = 111
            Height = 17
            Caption = 'DirectExecute'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
          object chkServerOutput: TCheckBox
            Left = 146
            Top = 19
            Width = 111
            Height = 17
            Caption = 'ServerOutput'
            TabOrder = 3
          end
          object btnResourceOptionsRestoreDefaults: TButton
            Left = 263
            Top = 29
            Width = 170
            Height = 43
            Caption = 'Restore Defaults'
            TabOrder = 4
            OnClick = btnResourceOptionsRestoreDefaultsClick
          end
          object chkSilentMode: TCheckBox
            Left = 146
            Top = 42
            Width = 111
            Height = 17
            Caption = 'SilentMode'
            TabOrder = 5
          end
        end
        object UpdateOptionsTab: TcxTabSheet
          Caption = 'UpdateOptions'
          ImageIndex = 3
          object rgLockMode: TRadioGroup
            Left = 27
            Top = 18
            Width = 182
            Height = 87
            Caption = 'LockMode'
            Items.Strings = (
              'lmNone'
              'lmPessimistic'
              'lmOptimistic')
            TabOrder = 0
          end
          object rgLockPoint: TRadioGroup
            Left = 215
            Top = 18
            Width = 182
            Height = 87
            Caption = 'LockPoint'
            Items.Strings = (
              'lpImmediate'
              'lpDeferred')
            TabOrder = 1
          end
          object rgUpdateMode: TRadioGroup
            Left = 415
            Top = 18
            Width = 182
            Height = 87
            Caption = 'UpdateMode'
            Items.Strings = (
              'upWhereAll'
              'upWhereChanged'
              'upWhereKeyOnly')
            TabOrder = 2
          end
          object chkLockWait: TCheckBox
            Left = 215
            Top = 122
            Width = 87
            Height = 17
            Caption = 'LockWait'
            TabOrder = 3
          end
          object chkAutoCommitUpdates: TCheckBox
            Left = 215
            Top = 145
            Width = 150
            Height = 17
            Caption = 'AutoCommitUpdates'
            TabOrder = 4
          end
          object btnUpdateOptionsRestoreDefaults: TButton
            Left = 417
            Top = 110
            Width = 170
            Height = 43
            Caption = 'Restore Defaults'
            TabOrder = 5
            OnClick = btnUpdateOptionsRestoreDefaultsClick
          end
          object rgFetchGeneratorsPoint: TRadioGroup
            Left = 27
            Top = 115
            Width = 182
            Height = 85
            Caption = 'FetchGeneratorsPoint'
            Items.Strings = (
              'gpNone'
              'gpImmediate'
              'gpDeferred')
            TabOrder = 6
          end
        end
      end
    end
  end
  object ConnectionCheckTimer: TTimer
    Interval = 60000
    OnTimer = ConnectionCheckTimerTimer
    Left = 700
    Top = 12
  end
  object SQLFDConnection: TFDConnection
    FormatOptions.AssignedValues = [fvSortOptions]
    Left = 440
    Top = 16
  end
  object FDTable1: TFDTable
    Connection = SQLFDConnection
    Left = 472
    Top = 8
  end
  object SQLFDQuery: TFDQuery
    Indexes = <
      item
        Name = 'BYDESCRIPTION'
        Fields = 'DescriptionSrch;PurchDate1'
      end>
    Connection = SQLFDConnection
    Left = 512
    Top = 65528
  end
  object DataSource1: TDataSource
    DataSet = SQLFDQuery
    Left = 412
    Top = 193
  end
end
