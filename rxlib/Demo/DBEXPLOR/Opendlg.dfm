object OpenDatabaseDlg: TOpenDatabaseDlg
  Left = 208
  Top = 168
  ActiveControl = rxDBLookupCombo1
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Open Database'
  ClientHeight = 151
  ClientWidth = 302
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 285
    Height = 105
    Shape = bsFrame
    IsControl = True
  end
  object Label1: TLabel
    Left = 20
    Top = 16
    Width = 45
    Height = 13
    Caption = '&Aliases:   '
    FocusControl = rxDBLookupCombo1
  end
  object Label2: TLabel
    Left = 20
    Top = 60
    Width = 54
    Height = 13
    Caption = '&Directory:   '
    FocusControl = DirectoryEdit1
  end
  object rxDBLookupCombo1: TRxDBLookupCombo
    Left = 20
    Top = 32
    Width = 261
    Height = 21
    DropDownCount = 8
    ItemHeight = 14
    LookupField = 'NAME'
    LookupDisplay = 'NAME'
    LookupSource = DataSource1
    TabOrder = 0
    OnChange = rxDBLookupCombo1Change
    OnGetImage = DBLookupComboGetImage
  end
  object DirectoryEdit1: TDirectoryEdit
    Left = 20
    Top = 76
    Width = 261
    Height = 21
    AcceptFiles = True
    ButtonHint = 'Select directory|'
    CharCase = ecLowerCase
    NumGlyphs = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnChange = DirectoryEdit1Change
  end
  object OkBtn: TButton
    Left = 134
    Top = 121
    Width = 77
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 216
    Top = 121
    Width = 77
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object DatabaseList: TBDEItems
    Active = True
    Left = 148
    Top = 28
  end
  object DataSource1: TDataSource
    DataSet = DatabaseList
    Left = 176
    Top = 28
  end
  object FormStorage: TFormStorage
    Options = [fpPosition]
    StoredProps.Strings = (
      'DirectoryEdit1.InitialDir')
    StoredValues = <>
    Left = 8
    Top = 116
  end
  object PicClip: TPicClip
    Cols = 3
    Picture.Data = {
      07544269746D617096010000424D960100000000000076000000280000003000
      00000C0000000100040000000000200100000000000000000000100000000000
      000000000000000080000080000000808000800000008000800080800000C0C0
      C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
      FF00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00000DDDDDDDDD80000008
      DDDDDDDDDDDDDDDDDDDDDDDDD088F780DDDDDDD8877778808DDDDDD000000000
      0DDDDDDDD087F880DDDDDDD0F77888880DDDDDD0FFF0FFFF0DDDDDDDD088F780
      DDDDDDD8800000088DDDDDD0F4F0F44F0DDDDDDDD087F880DDDDDDD887777880
      8DDDDDD0FFF0FFFF0DDDDDDDD0000000DDDDDDD0F77888880DDDDDD0F4F0F44F
      0DDDDDDDD0EEEEE0DDDDDDD8800000088DDDDDD0FFF0FFFF0DDDDDDDDD00000D
      DDDDDDD8877777708DDDDDD0000000000DDDDDDDDDDDDDDDDDDDDDD0F7777777
      0DDDDDD0EEEEEEEE0DDDDDD44444D44444DDDDD87FFFFF788DDDDDD000000000
      0DDDD444DDD444DDD4DDDDDD88000088DDDDDDDDDDDDDDDDDDDDDDD44444D444
      44DD}
    Left = 204
    Top = 28
  end
end
