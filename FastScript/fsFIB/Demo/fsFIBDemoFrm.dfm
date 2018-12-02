object fsFIBDemoForm: TfsFIBDemoForm
  Left = 288
  Top = 222
  Width = 696
  Height = 480
  Caption = 'fsFIBDemoForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Button1: TButton
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Run'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object SyntaxEdit1: TfsSyntaxMemo
    Left = 200
    Top = 41
    Width = 488
    Height = 412
    Cursor = crIBeam
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    TabStop = True
    BlockColor = clHighlight
    BlockFontColor = clHighlightText
    CommentAttr.Charset = DEFAULT_CHARSET
    CommentAttr.Color = clNavy
    CommentAttr.Height = -13
    CommentAttr.Name = 'Courier New'
    CommentAttr.Style = [fsItalic]
    KeywordAttr.Charset = DEFAULT_CHARSET
    KeywordAttr.Color = clWindowText
    KeywordAttr.Height = -13
    KeywordAttr.Name = 'Courier New'
    KeywordAttr.Style = [fsBold]
    StringAttr.Charset = DEFAULT_CHARSET
    StringAttr.Color = clNavy
    StringAttr.Height = -13
    StringAttr.Name = 'Courier New'
    StringAttr.Style = []
    TextAttr.Charset = DEFAULT_CHARSET
    TextAttr.Color = clWindowText
    TextAttr.Height = -13
    TextAttr.Name = 'Courier New'
    TextAttr.Style = []
    Lines.Strings = (
      'var'
      ' DataBase        : TpFIBDatabase;'
      ' DataSet         : TpFIBDataSet;'
      ' DataSource      : TDataSource;'
      ' ReadTransaction : TpFIBTransaction;'
      ' MainForm        : TForm;'
      ' DBGrid          : TDBGrid;'
      'begin'
      ' DataBase := TpFIBDatabase.Create( nil );'
      ' ReadTransaction := TpFIBTransaction.Create( nil );'
      ' DataSet := TpFIBDataSet.Create( nil );'
      ' DataSource := TDataSource.Create(nil);'
      ' MainForm := TForm.Create( nil );'
      ' DBGrid := TDBGrid.Create( nil );'
      ''
      ' ReadTransaction.DefaultDatabase := DataBase;'
      ' DataSet.DataBase := DataBase;'
      ' DataSet.Transaction := ReadTransaction;'
      ' DataSet.UpdateTransaction := ReadTransaction;'
      '// DataSet.DataSet_ID := 100;'
      
        ' DataSet.SQLs.SelectSQL.Text := '#39'SELECT * FROM FIB$DATASETS_INFO' +
        #39';'
      ' DataSource.DataSet := DataSet;'
      ' DBGrid.DataSource := DataSource;'
      ''
      ' with DataBase do'
      '  begin'
      '   DBName := '#39'localhost:path\fsfibdemo.fdb'#39';'
      '   SQLDialect := 3;'
      '   with ConnectParams do'
      '    begin'
      '     UserName := '#39'SYSDBA'#39';'
      '     Password := '#39'masterkey'#39';'
      '    end;'
      '   Connected := True;'
      '  end;'
      ''
      ' with DataSet.AutoUpdateOptions do'
      '  begin'
      '   CanChangeSQLs   := True;'
      '   AutoReWriteSQLs := True;'
      '   KeyFields       := '#39'DS_ID'#39';'
      '   UpdateTableName :='#39'FIB$DATASETS_INFO'#39';'
      '  end;'
      ' DataSet.Open;'
      ' DBGrid.Parent := MainForm;'
      ' DBGrid.Align := alClient;'
      ' MainForm.Position := poScreenCenter;'
      
        ' MainForm.Caption := '#39'RecordCountFromSrv='#39' + IntToStr( DataSet.R' +
        'ecordCountFromSrv );'
      ' MainForm.Show;'
      'end.')
    ReadOnly = False
    SyntaxType = stPascal
    ShowFooter = True
    ShowGutter = True
  end
  object fsTree1: TfsTree
    Left = 0
    Top = 41
    Width = 200
    Height = 412
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'fsTree1'
    TabOrder = 2
    ShowClasses = True
    ShowFunctions = True
    ShowTypes = True
    ShowVariables = True
    Expanded = True
    ExpandLevel = 2
  end
  object fsScript1: TfsScript
    SyntaxType = 'PascalScript'
    Left = 24
    Top = 88
  end
  object fsPascal1: TfsPascal
    Left = 72
    Top = 88
  end
  object fsClassesRTTI1: TfsClassesRTTI
    Left = 64
    Top = 192
  end
  object fsGraphicsRTTI1: TfsGraphicsRTTI
    Left = 160
    Top = 192
  end
  object fsFormsRTTI1: TfsFormsRTTI
    Left = 264
    Top = 184
  end
  object fsDialogsRTTI1: TfsDialogsRTTI
    Left = 64
    Top = 248
  end
  object fsDBRTTI1: TfsDBRTTI
    Left = 160
    Top = 248
  end
  object fsDBCtrlsRTTI1: TfsDBCtrlsRTTI
    Left = 264
    Top = 248
  end
  object pFIBDatabase1: TpFIBDatabase
    DBName = 'localhost:tv'
    DBParams.Strings = (
      'user_name=SYSDBA'
      'password=masterkey'
      'lc_ctype=WIN1251')
    SQLDialect = 3
    Timeout = 0
    LibraryName = 'fbclient.dll'
    WaitForRestoreConnect = 0
    Left = 152
    Top = 96
  end
  object pFIBDataSet1: TpFIBDataSet
    SelectSQL.Strings = (
      'SELECT'
      '    T.DS_ID,'
      '    T.DESCRIPTION,'
      '    T.SELECT_SQL,'
      '    T.UPDATE_SQL,'
      '    T.INSERT_SQL,'
      '    T.DELETE_SQL,'
      '    T.REFRESH_SQL,'
      '    T.NAME_GENERATOR,'
      '    T.KEY_FIELD,'
      '    T.UPDATE_TABLE_NAME,'
      '    T.UPDATE_ONLY_MODIFIED_FIELDS,'
      '    T.CONDITIONS,'
      '    T.FIB$VERSION'
      'FROM'
      '    FIB$DATASETS_INFO T')
    Transaction = pFIBTransaction1
    Database = pFIBDatabase1
    DataSet_ID = 100
    Left = 240
    Top = 96
    poApplyRepositary = True
  end
  object pFIBTransaction1: TpFIBTransaction
    DefaultDatabase = pFIBDatabase1
    TimeoutAction = TARollback
    Left = 360
    Top = 96
  end
  object fsExtCtrlsRTTI1: TfsExtCtrlsRTTI
    Left = 360
    Top = 192
  end
  object fsFIBRTTI1: TfsFIBRTTI
    Left = 360
    Top = 248
  end
end
