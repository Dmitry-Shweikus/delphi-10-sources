unit Unit1;

interface

uses
  Forms, TB2Dock, Dialogs, TB2MDI, TBSkinPlus, Menus, TB2Item, Classes,
  ActnList, ImgList, Controls, StdCtrls, Buttons, ExtCtrls, TB2ToolWindow,
  TB2ExtItems, TB2Toolbar, Windows, Graphics;

type
  TForm1 = class(TForm)
    TopDock: TTBDock;
    TBDock2: TTBDock;
    HotToolbarImages: TImageList;
    ActionList: TActionList;
    RemoveComponent: TAction;
    TBPopupMenu1: TTBPopupMenu;
    TBToolbar5: TTBToolbar;
    TBItem429: TTBItem;
    TBItem430: TTBItem;
    TBItem431: TTBItem;
    TBItem432: TTBItem;
    RightDock: TTBDock;
    TBDock4: TTBDock;
    TBEditItem1: TTBEditItem;
    TBItem450: TTBItem;
    TBSeparatorItem155: TTBSeparatorItem;
    TBSeparatorItem156: TTBSeparatorItem;
    TBSeparatorItem157: TTBSeparatorItem;
    TBSeparatorItem62: TTBSeparatorItem;
    TBSkin: TTBSkin;
    TBMDIHandler: TTBMDIHandler;
    ColorDialog: TColorDialog;
    TBToolbar2: TTBToolbar;
    ToolbarImages: TImageList;
    TBItem43: TTBItem;
    TBItem45: TTBItem;
    WinXPBackground: TTBBackground;
    Disabled: TAction;
    OfficeXP: TAction;
    WindowsXP: TAction;
    OfficeXPColorset: TAction;
    WindowsXPColorset: TAction;
    CustomColorset: TAction;
    TBToolbar1: TTBToolbar;
    TBItem2: TTBItem;
    TBItem3: TTBItem;
    TBSeparatorItem2: TTBSeparatorItem;
    TBItem4: TTBItem;
    TBItem1: TTBItem;
    TBItem5: TTBItem;
    TBItem6: TTBItem;
    TBItem7: TTBItem;
    MenuBar: TTBToolbar;
    NavigatorImages: TImageList;
    NavigatorImagesHot: TImageList;
    TBItem36: TTBItem;
    TBSeparatorItem9: TTBSeparatorItem;
    TBEditItem2: TTBEditItem;
    TBEditItem3: TTBEditItem;
    TBEditItem4: TTBEditItem;
    SkinOptionsToolWindow: TTBToolWindow;
    TBSkinOptions: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Shape1: TShape;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    ColorSetPanel: TPanel;
    Label2: TLabel;
    Shape2: TShape;
    RadioButton100: TRadioButton;
    RadioButton101: TRadioButton;
    RadioButton102: TRadioButton;
    CustomColosetPanel: TPanel;
    Label3: TLabel;
    Shape3: TShape;
    OptionsPanel: TPanel;
    Label4: TLabel;
    Shape4: TShape;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    StaticText1: TStaticText;
    StaticText3: TStaticText;
    NavigatorImagesDisabled: TImageList;
    RadioButton4: TRadioButton;
    WindowsXPNative: TAction;
    TBSeparatorItem17: TTBSeparatorItem;
    FileSubMenu: TTBSubmenuItem;
    TBItem48: TTBItem;
    TBItem50: TTBItem;
    TBItem51: TTBItem;
    TBItem52: TTBItem;
    TBSeparatorItem21: TTBSeparatorItem;
    TBItem53: TTBItem;
    TBItem54: TTBItem;
    TBSeparatorItem23: TTBSeparatorItem;
    TBItem55: TTBItem;
    TBItem56: TTBItem;
    TBItem59: TTBItem;
    TBItem60: TTBItem;
    TBSubmenuItem12: TTBSubmenuItem;
    TBItem61: TTBItem;
    TBSubmenuItem13: TTBSubmenuItem;
    TBSeparatorItem22: TTBSeparatorItem;
    TBItem49: TTBItem;
    TBItem62: TTBItem;
    TBItem63: TTBItem;
    TBItem64: TTBItem;
    TBSeparatorItem19: TTBSeparatorItem;
    TBItem65: TTBItem;
    TBItem66: TTBItem;
    TBItem67: TTBItem;
    TBItem68: TTBItem;
    EditSubMenu: TTBSubmenuItem;
    TBItem69: TTBItem;
    TBSeparatorItem24: TTBSeparatorItem;
    TBItem70: TTBItem;
    TBSeparatorItem25: TTBSeparatorItem;
    TBItem71: TTBItem;
    TBItem72: TTBItem;
    TBItem73: TTBItem;
    ViewSubMenu: TTBSubmenuItem;
    TBItem74: TTBItem;
    TBItem75: TTBItem;
    TBItem76: TTBItem;
    TBSeparatorItem26: TTBSeparatorItem;
    TBSubmenuItem16: TTBSubmenuItem;
    TBSubmenuItem17: TTBSubmenuItem;
    TBSeparatorItem27: TTBSeparatorItem;
    TBItem77: TTBItem;
    TBItem78: TTBItem;
    TBSubmenuItem18: TTBSubmenuItem;
    TBSeparatorItem28: TTBSeparatorItem;
    TBSubmenuItem19: TTBSubmenuItem;
    TBItem79: TTBItem;
    TBSubmenuItem20: TTBSubmenuItem;
    TBItem80: TTBItem;
    TBItem82: TTBItem;
    TBSeparatorItem29: TTBSeparatorItem;
    TBItem83: TTBItem;
    TBItem84: TTBItem;
    TBItem85: TTBItem;
    TBItem81: TTBItem;
    TBSeparatorItem30: TTBSeparatorItem;
    TBItem86: TTBItem;
    TBItem87: TTBItem;
    TBItem88: TTBItem;
    TBItem89: TTBItem;
    TBItem90: TTBItem;
    TBItem91: TTBItem;
    TBSeparatorItem31: TTBSeparatorItem;
    TBItem92: TTBItem;
    TBSeparatorItem32: TTBSeparatorItem;
    TBItem93: TTBItem;
    TBItem94: TTBItem;
    TBItem95: TTBItem;
    TBItem96: TTBItem;
    TBItem97: TTBItem;
    TBItem98: TTBItem;
    TBItem99: TTBItem;
    TBItem100: TTBItem;
    TBItem101: TTBItem;
    TBSeparatorItem33: TTBSeparatorItem;
    TBSubmenuItem21: TTBSubmenuItem;
    TBItem102: TTBItem;
    TBItem103: TTBItem;
    TBItem104: TTBItem;
    TBItem105: TTBItem;
    TBItem106: TTBItem;
    TBSeparatorItem34: TTBSeparatorItem;
    TBItem107: TTBItem;
    TBItem108: TTBItem;
    TBSeparatorItem35: TTBSeparatorItem;
    TBItem109: TTBItem;
    TBSeparatorItem36: TTBSeparatorItem;
    TBItem110: TTBItem;
    TBSeparatorItem37: TTBSeparatorItem;
    TBItem111: TTBItem;
    TBItem112: TTBItem;
    TBSeparatorItem38: TTBSeparatorItem;
    TBItem113: TTBItem;
    TBSeparatorItem39: TTBSeparatorItem;
    TBItem114: TTBItem;
    TBSeparatorItem40: TTBSeparatorItem;
    TBItem115: TTBItem;
    TBItem116: TTBItem;
    TBItem117: TTBItem;
    TBSeparatorItem41: TTBSeparatorItem;
    TBItem118: TTBItem;
    TBItem119: TTBItem;
    TBItem120: TTBItem;
    TBItem121: TTBItem;
    TBSeparatorItem42: TTBSeparatorItem;
    TBItem122: TTBItem;
    TBSeparatorItem43: TTBSeparatorItem;
    TBItem123: TTBItem;
    TBItem124: TTBItem;
    TBItem125: TTBItem;
    TBItem126: TTBItem;
    TBItem127: TTBItem;
    TBSeparatorItem44: TTBSeparatorItem;
    TBItem128: TTBItem;
    TBSeparatorItem45: TTBSeparatorItem;
    TBItem129: TTBItem;
    TBItem130: TTBItem;
    TBSeparatorItem46: TTBSeparatorItem;
    TBItem131: TTBItem;
    TBItem132: TTBItem;
    TBSeparatorItem47: TTBSeparatorItem;
    TBItem133: TTBItem;
    TBItem134: TTBItem;
    TBSeparatorItem48: TTBSeparatorItem;
    TBItem135: TTBItem;
    TBItem136: TTBItem;
    TBItem137: TTBItem;
    TBItem138: TTBItem;
    HelpSubMenu: TTBSubmenuItem;
    ToolsSubMenu: TTBSubmenuItem;
    TBItem139: TTBItem;
    TBSeparatorItem49: TTBSeparatorItem;
    TBItem140: TTBItem;
    TBSeparatorItem50: TTBSeparatorItem;
    TBItem141: TTBItem;
    TBItem142: TTBItem;
    MailSubMenu: TTBSubmenuItem;
    TBItem144: TTBItem;
    TBItem145: TTBItem;
    TBItem146: TTBItem;
    TBItem147: TTBItem;
    TBItem148: TTBItem;
    TBSeparatorItem51: TTBSeparatorItem;
    TBItem149: TTBItem;
    TBSeparatorItem52: TTBSeparatorItem;
    TBItem150: TTBItem;
    TBItem151: TTBItem;
    TBItem152: TTBItem;
    TBItem153: TTBItem;
    TBItem154: TTBItem;
    TBSubmenuItem1: TTBSubmenuItem;
    TBSubmenuItem2: TTBSubmenuItem;
    TBSubmenuItem3: TTBSubmenuItem;
    TBSubmenuItem4: TTBSubmenuItem;
    TBSeparatorItem1: TTBSeparatorItem;
    TBSubmenuItem5: TTBSubmenuItem;
    TBSkin2: TTBSkin;
    PopupStylePanel: TPanel;
    Label5: TLabel;
    Shape5: TShape;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    ImageBackPanel: TPanel;
    Label6: TLabel;
    Shape6: TShape;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    PopupDefault: TAction;
    ImgBackDefault: TAction;
    ImgBackGradVert: TAction;
    ImgBackGradHorz: TAction;
    PopupGradVert: TAction;
    PopupGradHorz: TAction;
    ColorsListBox: TListBox;
    TBSeparatorItem5: TTBSeparatorItem;
    TBBackground: TSpeedButton;
    DockBackground: TTBBackground;
    TBSubmenuItem7: TTBSubmenuItem;
    TBSeparatorItem6: TTBSeparatorItem;
    TBItemContainer: TTBItemContainer;
    TBSubmenuItem9: TTBSubmenuItem;
    TBItem17: TTBItem;
    TBItem16: TTBItem;
    TBItem15: TTBItem;
    TBSubmenuItem8: TTBSubmenuItem;
    TBItem18: TTBItem;
    TBItem19: TTBItem;
    TBItem20: TTBItem;
    TBItem21: TTBItem;
    TBItem22: TTBItem;
    TBItem58: TTBItem;
    TBItem57: TTBItem;
    TBItem8: TTBItem;
    TBSeparatorItem3: TTBSeparatorItem;
    TBItem12: TTBItem;
    TBItem11: TTBItem;
    TBItem10: TTBItem;
    TBSeparatorItem4: TTBSeparatorItem;
    TBSubmenuItem6: TTBSubmenuItem;
    TBItem13: TTBItem;
    MainToolbar: TTBSubmenuItem;
    procedure TBItem429Click(Sender: TObject);
    procedure RemoveComponentExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure DisabledExecute(Sender: TObject);
    procedure OfficeXPColorsetExecute(Sender: TObject);
    procedure TopDockResize(Sender: TObject);
    procedure TBSubmenuItem7Click(Sender: TObject);
    procedure WindowsXPNativeUpdate(Sender: TObject);
    procedure TBItem48Click(Sender: TObject);
    procedure PopupDefaultExecute(Sender: TObject);
    procedure ImgBackDefaultExecute(Sender: TObject);
    procedure ColorsListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ColorsListBoxDblClick(Sender: TObject);
    procedure TBBackgroundClick(Sender: TObject);
  public
    MdiCounter: Integer;
  end;

var
  Form1: TForm1;

implementation

uses SysUtils, Unit2, TB2Common;

{$R *.dfm}

procedure TForm1.TBItem429Click(Sender: TObject);
begin
 TTBItem(Sender).Checked := Not TTBItem(Sender).Checked;
end;

procedure TForm1.RemoveComponentExecute(Sender: TObject);
begin
 TBSkin.Free;
 TBSkin := Nil;
 TBSkinOptions.Free;
 SkinOptionsToolWindow.Free;
 RemoveComponent.Enabled := False;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 MdiCounter := 0;
 OfficeXP.Checked := True;
 OfficeXP.Execute;
 OfficeXPColorSet.Checked := True;
 OfficeXPColorSet.Execute;

 Caption := 'TBSkin+ With Patch ' + TBSkin.Version +
            ' For Toolbar 2000 - Demo Application -';
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
 If (Sender as TSpeedButton).Down Then
  TBSkin.Options := TBSkin.Options + [tboPopupOverlap]
 Else
  TBSkin.Options := TBSkin.Options - [tboPopupOverlap];
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
 If (Sender as TSpeedButton).Down Then
  TBSkin.Options := TBSkin.Options + [tboShadow]
 Else
  TBSkin.Options := TBSkin.Options - [tboShadow];
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
 If (Sender as TSpeedButton).Down Then
  TBSkin.Options := TBSkin.Options + [tboDockedCaptions]
 Else
  TBSkin.Options := TBSkin.Options - [tboDockedCaptions];
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
 If (Sender as TSpeedButton).Down Then
  TBSkin.Options := TBSkin.Options + [tboMenuTBColor]
 Else
  TBSkin.Options := TBSkin.Options - [tboMenuTBColor];
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
 If (Sender as TSpeedButton).Down Then
  TBSkin.Options := TBSkin.Options + [tboGradSelItem]
 Else
  TBSkin.Options := TBSkin.Options - [tboGradSelItem];
end;

procedure TForm1.DisabledExecute(Sender: TObject);
begin
 TBSkin.SkinType := TTBSkins(TAction(Sender).Tag);

 SpeedButton1.Down := False;
 SpeedButton2.Down := False;

 OptionsPanel.Enabled := Not (TBSkin.SkinType = tbsNativeXP);
 ColorSetPanel.Enabled := Not (TBSkin.SkinType = tbsNativeXP);
 PopupStylePanel.Enabled := Not (TBSkin.SkinType = tbsNativeXP);
 ImageBackPanel.Enabled := Not (TBSkin.SkinType = tbsNativeXP);

 Case TBSkin.SkinType Of
   tbsOfficeXP: Begin
                 RadioButton100.Checked := True;
                 SpeedButton2.Down := True;

                 TBSkin.Options := TBSkin.Options + [tboGradSelItem];
                End;
  tbsWindowsXP: Begin
                 SpeedButton1.Down := True;
                 SpeedButton2.Down := True;
                 RadioButton101.Checked := True;

                 SpeedButton5.Down := False;
                 TBSkin.Options := TBSkin.Options - [tboGradSelItem];
                End;
   tbsNativeXP: Begin
                 RadioButton101.Checked := True;

                 SpeedButton5.Down := False;
                 TBSkin.Options := TBSkin.Options - [tboGradSelItem];
                End;
 End;
end;

procedure TForm1.OfficeXPColorsetExecute(Sender: TObject);
begin
 TBSkin.ColorSet := TTBColorSets(TAction(Sender).Tag);
 CustomColosetPanel.Enabled := TBSkin.ColorSet = tbcCustom;
 ColorsListBox.Refresh;
end;

procedure TForm1.TopDockResize(Sender: TObject);
Var
 Bitmap: TBitmap;
begin
{ If Assigned(TBSkin) and Not (TBSkin.SkinType = tbsWindowsXP) Then
  Exit;}

 Bitmap := TBitmap.Create;
 Bitmap.Width := TopDock.Width;
 Bitmap.Height := TopDock.Height;

 SetStretchBltMode(Bitmap.Canvas.Handle,HALFTONE);
 StretchBlt(Bitmap.Canvas.Handle,
            0, 0, Bitmap.Width, Bitmap.Height +5,
            WinXPBackground.Bitmap.Canvas.Handle, 0, 0,
            WinXPBackground.Bitmap.Width,
            WinXPBackground.Bitmap.Height,
            SRCCOPY);

 DockBackground.Bitmap.Assign(Bitmap);
 Bitmap.Free;
end;

procedure TForm1.TBSubmenuItem7Click(Sender: TObject);
var
  F: TForm2;
begin
  F := TForm2.Create(Application);
  F.Caption := 'MDI child #' + IntToStr(MdiCounter +1);
  F.Memo1.Text := IntToStr(MdiCounter+1);
  Inc (MdiCounter);

  If Not (TBSkinOptions = Nil) Then
   SkinOptionsToolWindow.Visible := False;
end;

procedure TForm1.WindowsXPNativeUpdate(Sender: TObject);
begin
 WindowsXPNative.Enabled := IsWindowsXP and IsThemeActive;
end;

procedure TForm1.TBItem48Click(Sender: TObject);
begin
 Close;
end;

procedure TForm1.PopupDefaultExecute(Sender: TObject);
begin
 TBSkin.PopupStyle := TTBPopupStyle(TCustomAction(Sender).Tag);
end;

procedure TForm1.ImgBackDefaultExecute(Sender: TObject);
begin
 TBSkin.ImgBackStyle := TTBImgBackStyle(TCustomAction(Sender).Tag);
end;

procedure TForm1.ColorsListBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
Var
 CurColor: TColor;
begin
 With TBSkin.Colors Do
  Case Index Of
   0: CurColor := tcFace;
   1: CurColor := tcPopup;
   2: CurColor := tcBorder;
   3: CurColor := tcToolbar;
   4: CurColor := tcImageList;
   5: CurColor := tcDockBorderIn;
   6: CurColor := tcDockBorderOut;
   7: CurColor := tcDragHandle;
   8: CurColor := tcChecked;
   9: CurColor := tcCheckedOver;
   10: CurColor := tcSelBar;
   11: CurColor := tcSelBarBorder;
   12: CurColor := tcSelItem;
   13: CurColor := tcSelItemBorder;
   14: CurColor := tcSelPushed;
   15: CurColor := tcSelPushedBorder;
   16: CurColor := tcSeparator;
   17: CurColor := tcImgListShadow;
   18: CurColor := tcGradStart;
   19: CurColor := tcGradEnd;
   20: CurColor := tcPopupGradStart;
   21: CurColor := tcPopupGradEnd;
   22: CurColor := tcImgGradStart;
   23: CurColor := tcImgGradEnd;
   24: CurColor := tcMenuText;
   else CurColor := tcHighlightText;
  End;

 With TListbox(Control), Canvas Do
  If Index > -1 Then
   Begin
    Rect.Right := ClientWidth;

    If odSelected In State Then
     Brush.Color := clBlue
    else
     Brush.Color := clWindow;

    FillRect(Rect);

    Brush.Color := CurColor;
    Brush.Style := bsSolid;
    Rect.Right := 50;

    FillRect(Rect);

    Rect.Left := 54;
    Rect.Right := ClientWidth;

    Canvas.Brush.Style := bsClear;

    DrawText(Handle, PChar(Items[Index]), -1, Rect, DT_VCENTER);
   End;
end;

procedure TForm1.ColorsListBoxDblClick(Sender: TObject);
begin
 With TBSkin.Colors, ColorDialog Do
  Case ColorsListBox.ItemIndex Of
   0: Color := tcFace;
   1: Color := tcPopup;
   2: Color := tcBorder;
   3: Color := tcToolbar;
   4: Color := tcImageList;
   5: Color := tcDockBorderIn;
   6: Color := tcDockBorderOut;
   7: Color := tcDragHandle;
   8: Color := tcChecked;
   9: Color := tcCheckedOver;
   10: Color := tcSelBar;
   11: Color := tcSelBarBorder;
   12: Color := tcSelItem;
   13: Color := tcSelItemBorder;
   14: Color := tcSelPushed;
   15: Color := tcSelPushedBorder;
   16: Color := tcSeparator;
   17: Color := tcImgListShadow;
   18: Color := tcGradStart;
   19: Color := tcGradEnd;
   20: Color := tcPopupGradStart;
   21: Color := tcPopupGradEnd;
   22: Color := tcImgGradStart;
   23: Color := tcImgGradEnd;
   24: Color := tcMenuText;
   else Color := tcHighlightText;
  End;

 With TBSkin.Colors, ColorDialog Do
  If Execute Then
   Case ColorsListBox.ItemIndex Of
    0: tcFace := Color;
    1: tcPopup := Color;
    2: tcBorder := Color;
    3: tcToolbar := Color;
    4: tcImageList := Color;
    5: tcDockBorderIn := Color;
    6: tcDockBorderOut := Color;
    7: tcDragHandle := Color;
    8: tcChecked := Color;
    9: tcCheckedOver := Color;
    10: tcSelBar := Color;
    11: tcSelBarBorder := Color;
    12: tcSelItem := Color;
    13: tcSelItemBorder := Color;
    14: tcSelPushed := Color;
    15: tcSelPushedBorder := Color;
    16: tcSeparator := Color;
    17: tcImgListShadow := Color;
    18: tcGradStart := Color;
    19: tcGradEnd := Color;
    20: tcPopupGradStart := Color;
    21: tcPopupGradEnd := Color;
    22: tcImgGradStart := Color;
    23: tcImgGradEnd := Color;
    24: tcMenuText := Color;
    else tcHighlightText := Color;
   End;
end;

procedure TForm1.TBBackgroundClick(Sender: TObject);
begin
 If TSpeedButton(Sender).Down Then
  TopDock.Background := DockBackground
 Else
  TopDock.Background := Nil;

 TopDock.OnResize(Self);
end;

end.
