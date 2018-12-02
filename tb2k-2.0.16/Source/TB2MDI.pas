unit TB2MDI;

{
  Toolbar2000
  Copyright (C) 1998-2001 by Jordan Russell
  All rights reserved.
  For conditions of distribution and use, see LICENSE.TXT.

  TBSkin+ Modifications (C) Haralabos Michael 2001-2003

  $jrsoftware: tb2k/Source/TB2MDI.pas,v 1.11 2003/03/31 02:42:52 jr Exp $
}

interface

{$I TB2Ver.inc}

uses
  Windows, Messages, Classes, Graphics, Controls, Forms,
  Menus, TB2Item, TB2Toolbar;

type
  TTBMDIButtonsItem = class;
  TTBMDISystemMenuItem = class;

  TTBMDIHandler = class(TComponent)
  private
    FButtonsItem: TTBMDIButtonsItem;
    FSystemMenuItem: TTBMDISystemMenuItem;
    FToolbar: TTBCustomToolbar;
    procedure SetToolbar(Value: TTBCustomToolbar);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Toolbar: TTBCustomToolbar read FToolbar write SetToolbar;
  end;

  TTBMDIWindowItem = class(TTBCustomItem)
  private
    FForm: TForm;
    FOnUpdate: TNotifyEvent;
    FWindowMenu: TMenuItem;
    procedure ItemClick(Sender: TObject);
    procedure SetForm(AForm: TForm);
  protected
    procedure EnabledChanged; override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure InitiateAction; override;
  published
    property Enabled;
    property OnUpdate: TNotifyEvent read FOnUpdate write FOnUpdate;
  end;

  TTBMDISystemMenuItem = class(TTBCustomItem)
  private
    FImageList: TImageList;
    procedure CommandClick(Sender: TObject);
  protected
    function GetItemViewerClass(AView: TTBView): TTBItemViewerClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
  end;

  TTBMDISystemMenuItemViewer = class(TTBItemViewer)
  protected
    procedure CalcSize(const Canvas: TCanvas; var AWidth, AHeight: Integer);
      override;
    procedure Paint(const Canvas: TCanvas; const ClientAreaRect: TRect;
      IsSelected, IsPushed, UseDisabledShadow: Boolean); override;
  end;

  TTBMDIButtonType = (tbmbMinimize, tbmbRestore, tbmbClose);

  TTBMDIButtonItem = class(TTBCustomItem)
  private
    FButtonType: TTBMDIButtonType;
  protected
    function GetItemViewerClass(AView: TTBView): TTBItemViewerClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TTBMDIButtonItemViewer = class(TTBItemViewer)
  protected
    procedure CalcSize(const Canvas: TCanvas; var AWidth, AHeight: Integer);
      override;
    procedure Paint(const Canvas: TCanvas; const ClientAreaRect: TRect;
      IsSelected, IsPushed, UseDisabledShadow: Boolean); override;
  end;

  TTBMDISepItem = class(TTBSeparatorItem)
  protected
    function GetItemViewerClass(AView: TTBView): TTBItemViewerClass; override;
  end;

  TTBMDISepItemViewer = class(TTBSeparatorItemViewer)
  protected
    procedure CalcSize(const Canvas: TCanvas; var AWidth, AHeight: Integer);
      override;
  end;

  TTBMDIButtonsItem = class(TTBCustomItem)
  private
    FMinimizeItem: TTBMDIButtonItem;
    FRestoreItem: TTBMDIButtonItem;
    FCloseItem: TTBMDIButtonItem;
    FSep1, FSep2: TTBMDISepItem;
    procedure InvalidateSystemMenuItem;
    procedure ItemClick(Sender: TObject);
    procedure UpdateState(W: HWND; Maximized: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  TB2Common, TB2Consts, CommCtrl,
  TBSkinPlus; //Skin Patch

type
  TTBCustomToolbarAccess = class(TTBCustomToolbar);
  

{ TTBMDIHandler }

constructor TTBMDIHandler.Create(AOwner: TComponent);
begin
  inherited;
  FSystemMenuItem := TTBMDISystemMenuItem.Create(Self);
  FButtonsItem := TTBMDIButtonsItem.Create(Self);
end;

destructor TTBMDIHandler.Destroy;
begin
  Toolbar := nil;
  inherited;
end;

procedure TTBMDIHandler.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (AComponent = FToolbar) and (Operation = opRemove) then
    Toolbar := nil;
end;

procedure TTBMDIHandler.SetToolbar(Value: TTBCustomToolbar);
var
  Rebuild: Boolean;
begin
  if FToolbar <> Value then begin
    if Assigned(FToolbar) then begin
      Rebuild := False;
      if TTBCustomToolbarAccess(FToolbar).FMDIButtonsItem = FButtonsItem then begin
        TTBCustomToolbarAccess(FToolbar).FMDIButtonsItem := nil;
        Rebuild := True;
      end;
      if TTBCustomToolbarAccess(FToolbar).FMDISystemMenuItem = FSystemMenuItem then begin
        TTBCustomToolbarAccess(FToolbar).FMDISystemMenuItem := nil;
        Rebuild := True;
      end;
      if Rebuild and Assigned(FToolbar.View) then
        FToolbar.View.RecreateAllViewers;
    end;
    FToolbar := Value;
    if Assigned(Value) then begin
      Value.FreeNotification(Self);
      TTBCustomToolbarAccess(Value).FMDIButtonsItem := FButtonsItem;
      TTBCustomToolbarAccess(Value).FMDISystemMenuItem := FSystemMenuItem;
      Value.View.RecreateAllViewers;
    end;
  end;
end;


{ TTBMDISystemMenuItem }

constructor TTBMDISystemMenuItem.Create(AOwner: TComponent);
begin
  inherited;
  ItemStyle := ItemStyle + [tbisSubMenu, tbisDontSelectFirst] -
    [tbisRedrawOnSelChange, tbisRedrawOnMouseOverChange];
  Caption := '&-';

  {$R TB2MDI.res}
  FImageList := TImageList.Create(Self);
  FImageList.Handle := ImageList_LoadBitmap(HInstance, 'TB2SYSMENUIMAGES',
    16, 0, clSilver);
  SubMenuImages := FImageList;

//Setting this number tag in order avoid the
//shadows on the menu icon the
  Tag := 1234567890; //Skin Patch
end;

function TTBMDISystemMenuItem.GetItemViewerClass(AView: TTBView): TTBItemViewerClass;
begin
  Result := TTBMDISystemMenuItemViewer;
end;

procedure TTBMDISystemMenuItem.Click;
var
  I: Integer;
  Form: TForm;
  M: HMENU;
  State, ID: UINT;
  Item: TTBCustomItem;
  Buf: array[0..1023] of Char;
begin
  inherited;
  Clear;
  if Application.MainForm = nil then
    Exit;
  Form := Application.MainForm.ActiveMDIChild;
  if Form = nil then
    Exit;
  M := GetSystemMenu(Form.Handle, False);
  for I := 0 to GetMenuItemCount(M)-1 do begin
    State := GetMenuState(M, I, MF_BYPOSITION);
    if State and MF_SEPARATOR <> 0 then
      Add(TTBSeparatorItem.Create(Self))
    else begin
      Item := TTBCustomItem.Create(Self);
      if State and MF_GRAYED <> 0 then
        Item.Enabled := False;
      if GetMenuString(M, I, Buf, SizeOf(Buf), MF_BYPOSITION) = 0 then
        Buf[0] := #0;
      Item.Caption := Buf;
      ID := GetMenuItemID(M, I);
      Item.Tag := ID;
      case ID and $FFF0 of
        SC_RESTORE: Item.ImageIndex := 3;
        SC_MINIMIZE: Item.ImageIndex := 2;
        SC_MAXIMIZE: Item.ImageIndex := 1;
        SC_CLOSE: begin
            Item.ImageIndex := 0;
            Item.Options := Item.Options + [tboDefault];
          end;
      end;
      Item.OnClick := CommandClick;
      Add(Item);
    end;
  end;
end;

procedure TTBMDISystemMenuItem.CommandClick(Sender: TObject);
var
  Form: TForm;
begin
  if Assigned(Application.MainForm) then begin
    Form := Application.MainForm.ActiveMDIChild;
    if Assigned(Form) then
      SendMessage(Form.Handle, WM_SYSCOMMAND, TTBCustomItem(Sender).Tag,
        GetMessagePos);
  end;
end;


{ TTBMDISystemMenuItemViewer }

procedure TTBMDISystemMenuItemViewer.CalcSize(const Canvas: TCanvas;
  var AWidth, AHeight: Integer);
begin
  AWidth := GetSystemMetrics(SM_CXSMICON) + 2;
  AHeight := GetSystemMetrics(SM_CYSMICON) + 2;
end;

procedure TTBMDISystemMenuItemViewer.Paint(const Canvas: TCanvas;
  const ClientAreaRect: TRect; IsSelected, IsPushed, UseDisabledShadow: Boolean);

  function GetIconHandle: HICON;
  var
    Form: TForm;
  begin
    Result := 0;
    if Assigned(Application.MainForm) then begin
      Form := Application.MainForm.ActiveMDIChild;
      if Assigned(Form) then
        Result := Form.Icon.Handle;
    end;
    if Result = 0 then
      Result := Application.Icon.Handle;
    if Result = 0 then
      Result := LoadIcon(0, IDI_APPLICATION);
  end;

var
  R: TRect;
  TempIcon: HICON;
begin
  R := ClientAreaRect;
  InflateRect(R, -1, -1);
  TempIcon := CopyImage(GetIconHandle, IMAGE_ICON, R.Right - R.Left,
    R.Bottom - R.Top, LR_COPYFROMRESOURCE);
  DrawIconEx(Canvas.Handle, R.Left, R.Top, TempIcon, 0, 0, 0, 0, DI_NORMAL);
  DestroyIcon(TempIcon);
end;


{ TTBMDIButtonItem }

constructor TTBMDIButtonItem.Create(AOwner: TComponent);
begin
  inherited;
  ItemStyle := ItemStyle - [tbisSelectable, tbisRedrawOnSelChange] +
    [tbisRightAlign];
  ItemStyle := ItemStyle + [tbisRedrawOnSelChange]; //Skin Patch
end;

function TTBMDIButtonItem.GetItemViewerClass(AView: TTBView): TTBItemViewerClass;
begin
  Result := TTBMDIButtonItemViewer;
end;


{ TTBMDIButtonItemViewer }

procedure TTBMDIButtonItemViewer.CalcSize(const Canvas: TCanvas;
  var AWidth, AHeight: Integer);
begin
  if NewStyleControls then begin
    AWidth := GetSystemMetrics(SM_CXMENUSIZE) - 2;
    if AWidth < 0 then AWidth := 0;
    AHeight := GetSystemMetrics(SM_CYMENUSIZE) - 4;
    if AHeight < 0 then AHeight := 0;

//Skin Patch Begin
  If Assigned(View.Skin) and (View.Skin.SkinType = tbsOfficeXP) then
   Inc(AHeight)
  else
   if (DefaultSkin.SkinType = tbsOfficeXP) then
    Inc(AHeight)
//Skin Patch End
  end
  else begin
    AWidth := 16;
    AHeight := 14;
  end;
end;

procedure TTBMDIButtonItemViewer.Paint(const Canvas: TCanvas;
  const ClientAreaRect: TRect; IsSelected, IsPushed, UseDisabledShadow: Boolean);
const
  ButtonTypeFlags: array[TTBMDIButtonType] of UINT = (DFCS_CAPTIONMIN,
    DFCS_CAPTIONRESTORE, DFCS_CAPTIONCLOSE);
  PushedFlags: array[Boolean] of UINT = (0, DFCS_PUSHED);
  EnabledFlags: array[Boolean] of UINT = (DFCS_INACTIVE, 0);
//Skin Patch Begin
  TextMap: array[TTBMDIButtonType, 0..1] of PChar =
   (('0', '12'), ('2', '12'), ('r', '10'));
  MDIButtonTypeXP: array[TTBMDIButtonType] of WindowPart =
  (WP_MDIMINBUTTON, WP_MDIRESTOREBUTTON, WP_MDICLOSEBUTTON);
//(Symbol Letter, Size)
Var
 CSkin: TTBBaseSkin;
 Brush: HBrush;
 R: TRect;
 DC: HDC;
 CurFont,
 SaveFont: HFont;
//Skin Patch End
begin
//Skin Patch Begin
  If Assigned(View.Skin) and not(View.Skin.SkinType = tbsDisabled) then
   CSkin := View.Skin
  else
   if not (DefaultSkin.SkinType = tbsDisabled) then
    CSkin := DefaultSkin else CSkin := nil;

  if Assigned(CSkin) then
  if CSkin.SkinType = tbsNativeXP then begin
    DC := Canvas.Handle; //Optimization
    R := ClientAreaRect;

    aTheme := OpenThemeData(0, WindowThemeName);
    aPart := Integer(MDIButtonTypeXP[TTBMDIButtonItem(Item).FButtonType]);

    If Not Item.Enabled Then
      aState := Integer(ButtonState(CBS_DISABLED))
    Else
     If IsPushed Then
      aState := Integer(ButtonState(CBS_PUSHED))
     Else
      If IsSelected Then
        aState := Integer(ButtonState(CBS_HOT))
      Else
       aState := Integer(ButtonState(CBS_NORMAL));

    DrawThemeBackground(aTheme, DC, aPart, aState, R, nil);
    CloseThemeData(aTheme);
  end
  else begin
    Brush := 0;

    DC := Canvas.Handle; //Optimization
    R := ClientAreaRect;

    if IsSelected and not (vsModal in View.State) then
      Brush := CreateSolidBrush(CSkin.RGBColor(cSelBar))
    else if IsPushed then
      Brush := CreateSolidBrush(CSkin.RGBColor(cSelPushed));

    if Brush <> 0 then begin
      FillRect(DC, R, Brush);
      DeleteObject(Brush);
    end;

    if IsSelected and not (vsModal in View.State) then
      Brush := CreateSolidBrush(CSkin.RGBColor(cSelBarBorder))
    else if IsPushed then
      Brush := CreateSolidBrush(CSkin.RGBColor(cSelPushedBorder));

    if Brush <> 0 then begin
      FrameRect(DC, R, Brush);
      DeleteObject(Brush);
    end;

    CurFont := CreateFont(-10,
                          0, 0, 0, FW_NORMAL, 0, 0, 0,
                          DEFAULT_CHARSET,
                          OUT_TT_PRECIS,
                          CLIP_DEFAULT_PRECIS,
                          DEFAULT_QUALITY,
                          DEFAULT_PITCH,
                          'Marlett');

    SaveFont := SelectObject(DC, CurFont);

    SetBkMode(DC, TRANSPARENT);

    if IsSelected then
     SetTextColor(DC, CSkin.RGBColor(cText))
    else
     SetTextColor(DC, ColorToRGB(clBtnText));

    Inc(R.Top);

    DrawText(DC, TextMap[TTBMDIButtonItem(Item).FButtonType][0],
             1, R,
             DT_CENTER or DT_VCENTER or DT_NOCLIP or DT_NOPREFIX or
             DT_SINGLELINE);

    SelectObject(DC, SaveFont);
    DeleteObject(CurFont);
   end
  else //Skin Patch End
  DrawFrameControl(Canvas.Handle, ClientAreaRect, DFC_CAPTION,
    ButtonTypeFlags[TTBMDIButtonItem(Item).FButtonType] or
    PushedFlags[IsPushed] or EnabledFlags[Item.Enabled]);
end;


{ TTBMDISepItem }

function TTBMDISepItem.GetItemViewerClass(AView: TTBView): TTBItemViewerClass;
begin
  Result := TTBMDISepItemViewer;
end;


{ TTBMDISepItemViewer }

procedure TTBMDISepItemViewer.CalcSize(const Canvas: TCanvas;
  var AWidth, AHeight: Integer);
begin
  if View.Orientation <> tbvoVertical then begin
    AWidth := 2;
    AHeight := 6;
  end
  else begin
    AWidth := 6;
    AHeight := 2;
  end;
end;


{ TTBMDIButtonsItem }

var
  CBTHookHandle: HHOOK;
  MDIButtonsItems: TList;

function WindowIsMDIChild(W: HWND): Boolean;
var
  I: Integer;
  MainForm, ChildForm: TForm;
begin
  MainForm := Application.MainForm;
  if Assigned(MainForm) then
    for I := 0 to MainForm.MDIChildCount-1 do begin
      ChildForm := MainForm.MDIChildren[I];
      if ChildForm.HandleAllocated and (ChildForm.Handle = W) then begin
        Result := True;
        Exit;
      end;
    end;
  Result := False;
end;

function CBTHook(Code: Integer; WParam: WPARAM; LParam: LPARAM): LRESULT;
stdcall;
var
  Maximizing: Boolean;
  WindowPlacement: TWindowPlacement;
  I: Integer;
begin
  case Code of
    HCBT_SETFOCUS: begin
        if WindowIsMDIChild(HWND(WParam)) and Assigned(MDIButtonsItems) then begin
          for I := 0 to MDIButtonsItems.Count-1 do
            TTBMDIButtonsItem(MDIButtonsItems[I]).InvalidateSystemMenuItem;
        end;
      end;
    HCBT_MINMAX: begin
        if WindowIsMDIChild(HWND(WParam)) and Assigned(MDIButtonsItems) and
           (LParam in [SW_SHOWNORMAL, SW_SHOWMAXIMIZED, SW_MINIMIZE, SW_RESTORE]) then begin
          Maximizing := (LParam = SW_MAXIMIZE);
          if (LParam = SW_RESTORE) and not IsZoomed(HWND(WParam)) then begin
            WindowPlacement.length := SizeOf(WindowPlacement);
            GetWindowPlacement(HWND(WParam), @WindowPlacement);
            Maximizing := (WindowPlacement.flags and WPF_RESTORETOMAXIMIZED <> 0);
          end;
          for I := 0 to MDIButtonsItems.Count-1 do
            TTBMDIButtonsItem(MDIButtonsItems[I]).UpdateState(HWND(WParam),
              Maximizing);
        end;
      end;
    HCBT_DESTROYWND: begin
        if WindowIsMDIChild(HWND(WParam)) and Assigned(MDIButtonsItems) then begin
          for I := 0 to MDIButtonsItems.Count-1 do
            TTBMDIButtonsItem(MDIButtonsItems[I]).UpdateState(HWND(WParam),
              False);
        end;
      end;
  end;
  Result := CallNextHookEx(CBTHookHandle, Code, WParam, LParam);
end;

constructor TTBMDIButtonsItem.Create(AOwner: TComponent);

  function CreateItem(const AType: TTBMDIButtonType): TTBMDIButtonItem;
  begin
    Result := TTBMDIButtonItem.Create(Self);
    Result.FButtonType := AType;
    Result.OnClick := ItemClick;
  end;

begin
  inherited;
  ItemStyle := ItemStyle + [tbisEmbeddedGroup];
  FMinimizeItem := CreateItem(tbmbMinimize);
  FRestoreItem := CreateItem(tbmbRestore);
  FCloseItem := CreateItem(tbmbClose);
  FSep1 := TTBMDISepItem.Create(Self);
  FSep1.Blank := True;
  FSep1.ItemStyle := FSep1.ItemStyle + [tbisRightAlign, tbisNoLineBreak];
  FSep2 := TTBMDISepItem.Create(Self);
  FSep2.Blank := True;
  FSep2.ItemStyle := FSep2.ItemStyle + [tbisRightAlign, tbisNoLineBreak];
  Add(FSep1);
  Add(FMinimizeItem);
  Add(FRestoreItem);
  Add(FSep2);
  Add(FCloseItem);
  UpdateState(0, False);
  AddToList(MDIButtonsItems, Self);
  if CBTHookHandle = 0 then
    CBTHookHandle := SetWindowsHookEx(WH_CBT, CBTHook, 0, GetCurrentThreadId);
end;

destructor TTBMDIButtonsItem.Destroy;
begin
  RemoveFromList(MDIButtonsItems, Self);
  if (MDIButtonsItems = nil) and (CBTHookHandle <> 0) then begin
    UnhookWindowsHookEx(CBTHookHandle);
    CBTHookHandle := 0;
  end;
  inherited;
end;

procedure TTBMDIButtonsItem.UpdateState(W: HWND; Maximized: Boolean);
var
  HasMaxChild, VisibilityChanged: Boolean;

  procedure UpdateVisibleEnabled(const Item: TTBCustomItem;
    const AEnabled: Boolean);
  begin
    if (Item.Visible <> HasMaxChild) or (Item.Enabled <> AEnabled) then begin
      Item.Visible := HasMaxChild;
      Item.Enabled := AEnabled;
      VisibilityChanged := True;
    end;
  end;

var
  MainForm, ActiveMDIChild, ChildForm: TForm;
  I: Integer;
begin
  HasMaxChild := False;
  MainForm := Application.MainForm;
  ActiveMDIChild := nil;
  if Assigned(MainForm) then begin
    for I := 0 to MainForm.MDIChildCount-1 do begin
      ChildForm := MainForm.MDIChildren[I];
      if ChildForm.HandleAllocated and
         (((ChildForm.Handle = W) and Maximized) or
          ((ChildForm.Handle <> W) and IsZoomed(ChildForm.Handle))) then begin
        HasMaxChild := True;
        Break;
      end;
    end;
    ActiveMDIChild := MainForm.ActiveMDIChild;
  end;

  VisibilityChanged := False;
  UpdateVisibleEnabled(TTBMDIHandler(Owner).FSystemMenuItem, True);
  UpdateVisibleEnabled(FSep1, True);
  UpdateVisibleEnabled(FMinimizeItem, (ActiveMDIChild = nil) or
    (GetWindowLong(ActiveMDIChild.Handle, GWL_STYLE) and WS_MINIMIZEBOX <> 0));
  UpdateVisibleEnabled(FRestoreItem, True);
  UpdateVisibleEnabled(FSep2, True);
  UpdateVisibleEnabled(FCloseItem, True);

  if VisibilityChanged and Assigned((Owner as TTBMDIHandler).FToolbar) then begin
    TTBMDIHandler(Owner).FToolbar.View.InvalidatePositions;
    TTBMDIHandler(Owner).FToolbar.View.TryValidatePositions;
  end;
end;

procedure TTBMDIButtonsItem.ItemClick(Sender: TObject);
var
  MainForm, ChildForm: TForm;
  Cmd: WPARAM;
begin
  MainForm := Application.MainForm;
  if Assigned(MainForm) then begin
    ChildForm := MainForm.ActiveMDIChild;
    if Assigned(ChildForm) then begin
      { Send WM_SYSCOMMAND messages so that we get sounds }
      if Sender = FRestoreItem then
        Cmd := SC_RESTORE
      else if Sender = FCloseItem then
        Cmd := SC_CLOSE
      else
        Cmd := SC_MINIMIZE;
      SendMessage(ChildForm.Handle, WM_SYSCOMMAND, Cmd, GetMessagePos);
    end;
  end;
end;

procedure TTBMDIButtonsItem.InvalidateSystemMenuItem;
var
  View: TTBView;
begin
  if Assigned((Owner as TTBMDIHandler).FToolbar) then begin
    View := TTBMDIHandler(Owner).FToolbar.View;
    View.Invalidate(View.Find(TTBMDIHandler(Owner).FSystemMenuItem));
  end;
end;


{ TTBMDIWindowItem }

constructor TTBMDIWindowItem.Create(AOwner: TComponent);
var
  Form: TForm;
begin
  inherited;
  ItemStyle := ItemStyle + [tbisEmbeddedGroup];
  Caption := STBMDIWindowItemDefCaption;
  FWindowMenu := TMenuItem.Create(Self);

  if not(csDesigning in ComponentState) then begin
    { Need to set WindowMenu before MDI children are created. Otherwise the
      list incorrectly shows the first 9 child windows, even if window 10+ is
      active. }  
    Form := Application.MainForm;
    if (Form = nil) and (Screen.FormCount > 0) then
      Form := Screen.Forms[0];
    SetForm(Form);
  end;
end;

procedure TTBMDIWindowItem.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

procedure TTBMDIWindowItem.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FForm) then
    SetForm(nil);
end;

procedure TTBMDIWindowItem.SetForm(AForm: TForm);
begin
  if FForm <> AForm then begin
    if Assigned(FForm) and (FForm.WindowMenu = FWindowMenu) then
      FForm.WindowMenu := nil;
    FForm := AForm;
    if Assigned(FForm) then
      FForm.FreeNotification(Self);
  end;
  if Assigned(FForm) then
    FForm.WindowMenu := FWindowMenu;
end;

procedure TTBMDIWindowItem.EnabledChanged;
var
  I: Integer;
begin
  inherited;
  for I := 0 to Count-1 do
    Items[I].Enabled := Enabled;
end;

procedure TTBMDIWindowItem.InitiateAction;
var
  MainForm: TForm;
  I: Integer;
  M: HMENU;
  Item: TTBCustomItem;
  ItemCount: Integer;
  Buf: array[0..1023] of Char;
begin
  inherited;
  if csDesigning in ComponentState then
    Exit;
  MainForm := Application.MainForm;
  if Assigned(MainForm) then
    SetForm(MainForm);
  if FForm = nil then
    Exit;
  if FForm.ClientHandle <> 0 then
    { This is needed, otherwise windows selected on the More Windows dialog
      don't move back into the list } 
    SendMessage(FForm.ClientHandle, WM_MDIREFRESHMENU, 0, 0);
  M := FWindowMenu.Handle;
  ItemCount := GetMenuItemCount(M) - 1;
  if ItemCount < 0 then
    ItemCount := 0;
  while Count < ItemCount do begin
    Item := TTBCustomItem.Create(Self);
    Item.Enabled := Enabled;
    Item.OnClick := ItemClick;
    Add(Item);
  end;
  while Count > ItemCount do
    Items[Count-1].Free;
  for I := 0 to ItemCount-1 do begin
    Item := Items[I];
    Item.Tag := GetMenuItemID(M, I+1);
    if GetMenuString(M, I+1, Buf, SizeOf(Buf), MF_BYPOSITION) = 0 then
      Buf[0] := #0;
    Item.Caption := Buf;
    Item.Checked := GetMenuState(M, I+1, MF_BYPOSITION) and MF_CHECKED <> 0;
  end;
  if Assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

procedure TTBMDIWindowItem.ItemClick(Sender: TObject);
var
  Form: TForm;
begin
  Form := Application.MainForm;
  if Assigned(Form) then
    PostMessage(Form.Handle, WM_COMMAND, TTBCustomItem(Sender).Tag, 0);
end;

end.
