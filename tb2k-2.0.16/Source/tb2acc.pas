unit TB2Acc;

{
  Toolbar2000
  Copyright (C) 1998-2003 by Jordan Russell
  All rights reserved.
  For conditions of distribution and use, see LICENSE.TXT.

  $jrsoftware: tb2k/Source/TB2Acc.pas,v 1.1.2.3 2003/06/23 17:59:00 jr Exp $

  This unit is used internally to implement the IAccessible interface on
  TTBView and TTBItemViewer for Microsoft Active Accessibility support.
}

interface

{$I TB2Ver.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TB2Item;

type
  { Our declaration for IAccessible }
  ITBAccessible = interface(IDispatch)
    ['{618736E0-3C3D-11CF-810C-00AA00389B71}']
    function get_accParent(out ppdispParent: IDispatch): HRESULT; stdcall;
    function get_accChildCount(out pcountChildren: Integer): HRESULT; stdcall;
    function get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HRESULT; stdcall;
    function get_accName(varChild: OleVariant; out pszName: WideString): HRESULT; stdcall;
    function get_accValue(varChild: OleVariant; out pszValue: WideString): HRESULT; stdcall;
    function get_accDescription(varChild: OleVariant; out pszDescription: WideString): HRESULT; stdcall;
    function get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HRESULT; stdcall;
    function get_accState(varChild: OleVariant; out pvarState: OleVariant): HRESULT; stdcall;
    function get_accHelp(varChild: OleVariant; out pszHelp: WideString): HRESULT; stdcall;
    function get_accHelpTopic(out pszHelpFile: WideString; varChild: OleVariant; out pidTopic: Integer): HRESULT; stdcall;
    function get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: WideString): HRESULT; stdcall;
    function get_accFocus(out pvarID: OleVariant): HRESULT; stdcall;
    function get_accSelection(out pvarChildren: OleVariant): HRESULT; stdcall;
    function get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: WideString): HRESULT; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HRESULT; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
      out pcyHeight: Integer; varChild: OleVariant): HRESULT; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEnd: OleVariant): HRESULT; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarID: OleVariant): HRESULT; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HRESULT; stdcall;
    function put_accName(varChild: OleVariant; const pszName: WideString): HRESULT; stdcall;
    function put_accValue(varChild: OleVariant; const pszValue: WideString): HRESULT; stdcall;
  end;

  TTBViewAccObject = class(TTBBaseAccObject, IUnknown, IDispatch, ITBAccessible)
  private
    FView: TTBView;
    function Check(const varChild: OleVariant; var ErrorCode: HRESULT): Boolean;
    { ITBAccessible }
    function accDoDefaultAction(varChild: OleVariant): HRESULT; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarID: OleVariant): HRESULT; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
      out pcyHeight: Integer; varChild: OleVariant): HRESULT; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEnd: OleVariant): HRESULT; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HRESULT; stdcall;
    function get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HRESULT; stdcall;
    function get_accChildCount(out pcountChildren: Integer): HRESULT; stdcall;
    function get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: WideString): HRESULT; stdcall;
    function get_accDescription(varChild: OleVariant; out pszDescription: WideString): HRESULT; stdcall;
    function get_accFocus(out pvarID: OleVariant): HRESULT; stdcall;
    function get_accHelp(varChild: OleVariant; out pszHelp: WideString): HRESULT; stdcall;
    function get_accHelpTopic(out pszHelpFile: WideString; varChild: OleVariant; out pidTopic: Integer): HRESULT; stdcall;
    function get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: WideString): HRESULT; stdcall;
    function get_accName(varChild: OleVariant; out pszName: WideString): HRESULT; stdcall;
    function get_accParent(out ppdispParent: IDispatch): HRESULT; stdcall;
    function get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HRESULT; stdcall;
    function get_accSelection(out pvarChildren: OleVariant): HRESULT; stdcall;
    function get_accState(varChild: OleVariant; out pvarState: OleVariant): HRESULT; stdcall;
    function get_accValue(varChild: OleVariant; out pszValue: WideString): HRESULT; stdcall;
    function put_accName(varChild: OleVariant; const pszName: WideString): HRESULT; stdcall;
    function put_accValue(varChild: OleVariant; const pszValue: WideString): HRESULT; stdcall;
  public
    constructor Create(AView: TTBView);
    destructor Destroy; override;
    procedure ClientIsDestroying; override;
  end;

  TTBItemViewerAccObject = class(TTBBaseAccObject, IUnknown, IDispatch, ITBAccessible)
  private
    FViewer: TTBItemViewer;
    function Check(const varChild: OleVariant; var ErrorCode: HRESULT): Boolean;
    function IsAvailable: Boolean;
    { ITBAccessible }
    function accDoDefaultAction(varChild: OleVariant): HRESULT; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarID: OleVariant): HRESULT; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
      out pcyHeight: Integer; varChild: OleVariant): HRESULT; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEnd: OleVariant): HRESULT; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HRESULT; stdcall;
    function get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HRESULT; stdcall;
    function get_accChildCount(out pcountChildren: Integer): HRESULT; stdcall;
    function get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: WideString): HRESULT; stdcall;
    function get_accDescription(varChild: OleVariant; out pszDescription: WideString): HRESULT; stdcall;
    function get_accFocus(out pvarID: OleVariant): HRESULT; stdcall;
    function get_accHelp(varChild: OleVariant; out pszHelp: WideString): HRESULT; stdcall;
    function get_accHelpTopic(out pszHelpFile: WideString; varChild: OleVariant; out pidTopic: Integer): HRESULT; stdcall;
    function get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: WideString): HRESULT; stdcall;
    function get_accName(varChild: OleVariant; out pszName: WideString): HRESULT; stdcall;
    function get_accParent(out ppdispParent: IDispatch): HRESULT; stdcall;
    function get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HRESULT; stdcall;
    function get_accSelection(out pvarChildren: OleVariant): HRESULT; stdcall;
    function get_accState(varChild: OleVariant; out pvarState: OleVariant): HRESULT; stdcall;
    function get_accValue(varChild: OleVariant; out pszValue: WideString): HRESULT; stdcall;
    function put_accName(varChild: OleVariant; const pszName: WideString): HRESULT; stdcall;
    function put_accValue(varChild: OleVariant; const pszValue: WideString): HRESULT; stdcall;
  public
    constructor Create(AViewer: TTBItemViewer);
    destructor Destroy; override;
    procedure ClientIsDestroying; override;
  end;

procedure CallNotifyWinEvent(event: DWORD; hwnd: HWND; idObject: DWORD;
  idChild: Longint);
function InitializeOleAcc: Boolean;

var
  LresultFromObjectFunc: function(const riid: TGUID; wParam: WPARAM;
    pUnk: IUnknown): LRESULT; stdcall;
  AccessibleObjectFromWindowFunc: function(hwnd: HWND; dwId: DWORD;
    const riid: TGUID; out ppvObject: Pointer): HRESULT; stdcall;

  { For debugging purposes only: }
  ViewAccObjectInstances: Integer = 0;
  ItemViewerAccObjectInstances: Integer = 0;

implementation

uses
  {$IFDEF JR_D6} Variants, {$ENDIF} ComObj, Menus, TB2Common;
  { Note: ComObj is 'used' because it calls CoInitialize }

const
  { Constants from OleAcc.h }
  ROLE_SYSTEM_MENUBAR = $2;
  ROLE_SYSTEM_CLIENT = $a;
  ROLE_SYSTEM_MENUPOPUP = $b;
  ROLE_SYSTEM_MENUITEM = $c;
  ROLE_SYSTEM_SEPARATOR = $15;
  ROLE_SYSTEM_TOOLBAR = $16;
  ROLE_SYSTEM_PUSHBUTTON = $2b;

  STATE_SYSTEM_HASPOPUP = $40000000;

  NAVDIR_UP         = 1;
  NAVDIR_DOWN       = 2;
  NAVDIR_LEFT       = 3;
  NAVDIR_RIGHT      = 4;
  NAVDIR_NEXT       = 5;
  NAVDIR_PREVIOUS   = 6;
  NAVDIR_FIRSTCHILD = 7;
  NAVDIR_LASTCHILD  = 8;

type
  TControlAccess = class(TControl);
  TTBViewAccess = class(TTBView);
  TTBCustomItemAccess = class(TTBCustomItem);
  TTBItemViewerAccess = class(TTBItemViewer);

var
  NotifyWinEventInited: Boolean;
  NotifyWinEventFunc: procedure(event: DWORD; hwnd: HWND; idObject: DWORD;
    idChild: Longint); stdcall;

procedure CallNotifyWinEvent(event: DWORD; hwnd: HWND; idObject: DWORD;
  idChild: Longint);
begin
  if not NotifyWinEventInited then begin
    NotifyWinEventFunc := GetProcAddress(GetModuleHandle(user32), 'NotifyWinEvent');
    NotifyWinEventInited := True;
  end;
  if Assigned(NotifyWinEventFunc) then
    NotifyWinEventFunc(event, hwnd, idObject, idChild);
end;

var
  OleAccInited: Boolean;
  OleAccAvailable: Boolean;

function InitializeOleAcc: Boolean;
var
  M: HMODULE;
begin
  if not OleAccInited then begin
    M := {$IFDEF JR_D5} SafeLoadLibrary {$ELSE} LoadLibrary {$ENDIF} ('oleacc.dll');
    if M <> 0 then begin
      LresultFromObjectFunc := GetProcAddress(M, 'LresultFromObject');
      AccessibleObjectFromWindowFunc := GetProcAddress(M, 'AccessibleObjectFromWindow');
      if Assigned(LresultFromObjectFunc) and
         Assigned(AccessibleObjectFromWindowFunc) then
        OleAccAvailable := True;
    end;
    OleAccInited := True;
  end;
  Result := OleAccAvailable;
end;

function AccObjectFromWindow(const Wnd: HWND; out ADisp: IDispatch): Boolean;
var
  P: Pointer;
begin
  if Assigned(AccessibleObjectFromWindowFunc) and
     (AccessibleObjectFromWindowFunc(Wnd, OBJID_WINDOW, IDispatch, P) = S_OK) then begin
    ADisp := IDispatch(P);
    IDispatch(P)._Release;
    Result := True;
  end
  else
    Result := False;
end;

function ShouldPublishViewer(const AViewer: TTBItemViewer): Boolean;
{ Returns True if MSAA clients should know about the viewer, specifically
  if it's either shown, off-edge, or clipped (in other words, not completely
  invisible/inaccessible). }
begin
  { Note: Can't simply check AViewer.Item.Visible because the chevron item's
    Visible property is always True }
  Result := AViewer.Show or AViewer.OffEdge or AViewer.Clipped;
end;

{ TTBViewAccObject }

constructor TTBViewAccObject.Create(AView: TTBView);
begin
  inherited Create;
  FView := AView;
  InterlockedIncrement(ViewAccObjectInstances);
end;

destructor TTBViewAccObject.Destroy;
begin
  InterlockedDecrement(ViewAccObjectInstances);
  if Assigned(FView) then begin
    TTBViewAccess(FView).FAccObjectInstance := nil;
    FView := nil;
  end;
  inherited;
end;

procedure TTBViewAccObject.ClientIsDestroying;
begin
  FView := nil;
end;

function TTBViewAccObject.Check(const varChild: OleVariant;
  var ErrorCode: HRESULT): Boolean;
begin
  if FView = nil then begin
    ErrorCode := E_FAIL;
    Result := False;
  end
  else if (VarType(varChild) <> varInteger) or (varChild <> CHILDID_SELF) then begin
    ErrorCode := E_INVALIDARG;
    Result := False;
  end
  else
    Result := True;
end;

function TTBViewAccObject.accDoDefaultAction(varChild: OleVariant): HRESULT;
begin
  Result := S_FALSE;
end;

function TTBViewAccObject.accHitTest(xLeft, yTop: Integer;
  out pvarID: OleVariant): HRESULT;
var
  ViewWnd, W: HWND;
  R: TRect;
  P: TPoint;
  D: IDispatch;
  V: TTBItemViewer;
begin
  try
    if FView = nil then begin
      Result := E_FAIL;
      Exit;
    end;
    ViewWnd := FView.Window.Handle;
    GetWindowRect(ViewWnd, R);
    P.X := xLeft;
    P.Y := yTop;
    if PtInRect(R, P) then begin
      P := FView.Window.ScreenToClient(P);
      W := ChildWindowFromPointEx(ViewWnd, P, CWP_SKIPINVISIBLE);
      if (W <> 0) and (W <> ViewWnd) then begin
        { Point is inside a child window (most likely belonging to a
          TTBControlItem) }
        if AccObjectFromWindow(W, D) then begin
          pvarID := D;
          Result := S_OK;
        end
        else
          Result := E_UNEXPECTED;
      end
      else begin
        V := FView.ViewerFromPoint(P);
        if Assigned(V) then
          pvarID := V.GetAccObject
        else
          pvarID := CHILDID_SELF;
        Result := S_OK;
      end;
    end
    else
      Result := S_FALSE;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBViewAccObject.accLocation(out pxLeft, pyTop, pcxWidth,
  pcyHeight: Integer; varChild: OleVariant): HRESULT;
var
  R: TRect;
begin
  try
    if not Check(varChild, Result) then
      Exit;
    GetWindowRect(FView.Window.Handle, R);
    pxLeft := R.Left;
    pyTop := R.Top;
    pcxWidth := R.Right - R.Left;
    pcyHeight := R.Bottom - R.Top;
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBViewAccObject.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEnd: OleVariant): HRESULT;
var
  I: Integer;
begin
  try
    if not Check(varStart, Result) then
      Exit;
    Result := S_FALSE;
    case navDir of
      NAVDIR_FIRSTCHILD: begin
          for I := 0 to FView.ViewerCount-1 do
            if ShouldPublishViewer(FView.Viewers[I]) then begin
              pvarEnd := FView.Viewers[I].GetAccObject;
              Result := S_OK;
              Break;
            end;
        end;
      NAVDIR_LASTCHILD: begin
          for I := FView.ViewerCount-1 downto 0 do
            if ShouldPublishViewer(FView.Viewers[I]) then begin
              pvarEnd := FView.Viewers[I].GetAccObject;
              Result := S_OK;
              Break;
            end;
        end;
    end;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBViewAccObject.accSelect(flagsSelect: Integer;
  varChild: OleVariant): HRESULT;
begin
  Result := DISP_E_MEMBERNOTFOUND;
end;

function TTBViewAccObject.get_accChild(varChild: OleVariant;
  out ppdispChild: IDispatch): HRESULT;
var
  I, J: Integer;
  Viewer: TTBItemViewer;
  Ctl: TControl;
begin
  try
    if FView = nil then begin
      Result := E_FAIL;
      Exit;
    end;
    if VarType(varChild) <> varInteger then begin
      Result := E_INVALIDARG;
      Exit;
    end;
    I := varChild;
    if I = CHILDID_SELF then begin
      ppdispChild := Self;
      Result := S_OK;
    end
    else begin
      { Convert a one-based child index (I) into a real viewer index (J) }
      J := 0;
      while J < FView.ViewerCount do begin
        if ShouldPublishViewer(FView.Viewers[J]) then begin
          if I = 1 then Break;
          Dec(I);
        end;
        Inc(J);
      end;
      if J >= FView.ViewerCount then begin
        { 'I' was either negative or too high }
        Result := E_INVALIDARG;
        Exit;
      end;
      Viewer := FView.Viewers[J];
      if Viewer.Item is TTBControlItem then begin
        { For windowed controls, return the window's accessible object instead
          of the item viewer's }
        Ctl := TTBControlItem(Viewer.Item).Control;
        if (Ctl is TWinControl) and TWinControl(Ctl).HandleAllocated then begin
          if AccObjectFromWindow(TWinControl(Ctl).Handle, ppdispChild) then
            Result := S_OK
          else
            Result := E_UNEXPECTED;
          Exit;
        end;
      end;
      ppdispChild := Viewer.GetAccObject;
      Result := S_OK;
    end;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBViewAccObject.get_accChildCount(out pcountChildren: Integer): HRESULT;
var
  Count, I: Integer;
begin
  try
    if Assigned(FView) then begin
      Count := 0;
      for I := 0 to FView.ViewerCount-1 do
        if ShouldPublishViewer(FView.Viewers[I]) then
          Inc(Count);
      pCountChildren := Count;
      Result := S_OK;
    end
    else
      Result := E_FAIL;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBViewAccObject.get_accDefaultAction(varChild: OleVariant;
  out pszDefaultAction: WideString): HRESULT;
begin
  Result := S_FALSE;
end;

function TTBViewAccObject.get_accDescription(varChild: OleVariant;
  out pszDescription: WideString): HRESULT;
begin
  Result := S_FALSE;
end;

function TTBViewAccObject.get_accFocus(out pvarID: OleVariant): HRESULT;
begin
  Result := S_FALSE;
end;

function TTBViewAccObject.get_accHelp(varChild: OleVariant;
  out pszHelp: WideString): HRESULT;
begin
  Result := S_FALSE;
end;

function TTBViewAccObject.get_accHelpTopic(out pszHelpFile: WideString;
  varChild: OleVariant; out pidTopic: Integer): HRESULT;
begin
  pidTopic := 0;  { Delphi doesn't implicitly clear Integer 'out' parameters }
  Result := S_FALSE;
end;

function TTBViewAccObject.get_accKeyboardShortcut(varChild: OleVariant;
  out pszKeyboardShortcut: WideString): HRESULT;
begin
  try
    if not Check(varChild, Result) then
      Exit;
    if vsMenuBar in FView.Style then begin
      pszKeyboardShortcut := ShortCutToText(VK_MENU);
      Result := S_OK;
    end
    else
      Result := S_FALSE;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBViewAccObject.get_accName(varChild: OleVariant;
  out pszName: WideString): HRESULT;
var
  S: String;
begin
  try
    if not Check(varChild, Result) then
      Exit;
    if Assigned(FView.ParentView) and Assigned(FView.ParentView.OpenViewer) then
      S := StripAccelChars(TTBItemViewerAccess(FView.ParentView.OpenViewer).GetCaptionText);
    if S = '' then
      S := TControlAccess(FView.Window).Caption;
    pszName := S;
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBViewAccObject.get_accParent(out ppdispParent: IDispatch): HRESULT;
begin
  try
    if Assigned(FView) then begin
      if Assigned(FView.ParentView) and Assigned(FView.ParentView.OpenViewer) then begin
        ppdispParent := FView.ParentView.OpenViewer.GetAccObject;
        Result := S_OK;
      end
      else begin
        if AccObjectFromWindow(FView.Window.Handle, ppdispParent) then
          Result := S_OK
        else
          Result := E_UNEXPECTED;
      end;
    end
    else
      Result := E_FAIL;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBViewAccObject.get_accRole(varChild: OleVariant;
  out pvarRole: OleVariant): HRESULT;
begin
  try
    if not Check(varChild, Result) then
      Exit;
    if FView.IsPopup then
      pvarRole := ROLE_SYSTEM_MENUPOPUP
    else begin
      if vsMenuBar in FView.Style then
        pvarRole := ROLE_SYSTEM_MENUBAR
      else
        pvarRole := ROLE_SYSTEM_TOOLBAR;
    end;
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBViewAccObject.get_accSelection(out pvarChildren: OleVariant): HRESULT;
begin
  Result := S_FALSE;
end;

function TTBViewAccObject.get_accState(varChild: OleVariant;
  out pvarState: OleVariant): HRESULT;
begin
  try
    if not Check(varChild, Result) then
      Exit;
    pvarState := 0;
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBViewAccObject.get_accValue(varChild: OleVariant;
  out pszValue: WideString): HRESULT;
begin
  Result := S_FALSE;
end;

function TTBViewAccObject.put_accName(varChild: OleVariant;
  const pszName: WideString): HRESULT;
begin
  Result := S_FALSE;
end;

function TTBViewAccObject.put_accValue(varChild: OleVariant;
  const pszValue: WideString): HRESULT;
begin
  Result := S_FALSE;
end;

{ TTBItemViewerAccObject }

constructor TTBItemViewerAccObject.Create(AViewer: TTBItemViewer);
begin
  inherited Create;
  FViewer := AViewer;
  InterlockedIncrement(ItemViewerAccObjectInstances);
end;

destructor TTBItemViewerAccObject.Destroy;
begin
  InterlockedDecrement(ItemViewerAccObjectInstances);
  if Assigned(FViewer) then begin
    TTBItemViewerAccess(FViewer).FAccObjectInstance := nil;
    FViewer := nil;
  end;
  inherited;
end;

procedure TTBItemViewerAccObject.ClientIsDestroying;
begin
  FViewer := nil;
end;

function TTBItemViewerAccObject.Check(const varChild: OleVariant;
  var ErrorCode: HRESULT): Boolean;
begin
  if FViewer = nil then begin
    ErrorCode := E_FAIL;
    Result := False;
  end
  else if (VarType(varChild) <> varInteger) or (varChild <> CHILDID_SELF) then begin
    ErrorCode := E_INVALIDARG;
    Result := False;
  end
  else
    Result := True;
end;

function TTBItemViewerAccObject.IsAvailable: Boolean;
begin
  Result := FViewer.Item.Enabled and
    (tbisSelectable in TTBCustomItemAccess(FViewer.Item).ItemStyle);
end;

function TTBItemViewerAccObject.accDoDefaultAction(varChild: OleVariant): HRESULT;
begin
  Result := S_FALSE;{}
end;

function TTBItemViewerAccObject.accHitTest(xLeft, yTop: Integer;
  out pvarID: OleVariant): HRESULT;
var
  P: TPoint;
begin
  try
    if FViewer = nil then begin
      Result := E_FAIL;
      Exit;
    end;
    P := FViewer.View.Window.ScreenToClient(Point(xLeft, yTop));
    if PtInRect(FViewer.BoundsRect, P) then begin
      pvarID := CHILDID_SELF;
      Result := S_OK;
    end
    else
      Result := S_FALSE;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBItemViewerAccObject.accLocation(out pxLeft, pyTop, pcxWidth,
  pcyHeight: Integer; varChild: OleVariant): HRESULT;
var
  R: TRect;
  P: TPoint;
begin
  try
    if not Check(varChild, Result) then
      Exit;
    R := FViewer.BoundsRect;
    P := FViewer.View.Window.ClientToScreen(Point(0, 0));
    OffsetRect(R, P.X, P.Y);
    pxLeft := R.Left;
    pyTop := R.Top;
    pcxWidth := R.Right - R.Left;
    pcyHeight := R.Bottom - R.Top;
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBItemViewerAccObject.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEnd: OleVariant): HRESULT;
var
  I, J: Integer;
  View: TTBView;
begin
  try
    if not Check(varStart, Result) then
      Exit;
    Result := S_FALSE;
    if (navDir = NAVDIR_FIRSTCHILD) or (navDir = NAVDIR_LASTCHILD) then begin
      { Return the child view's acc. object }
      View := FViewer.View.OpenViewerView;
      if Assigned(View) then begin
        pvarEnd := View.GetAccObject;
        Result := S_OK;
      end;
    end
    else begin
      I := FViewer.View.IndexOf(FViewer);
      if I >= 0 then begin
        case navDir of
          NAVDIR_UP, NAVDIR_LEFT, NAVDIR_PREVIOUS:
            for J := I-1 downto 0 do
              if ShouldPublishViewer(FViewer.View.Viewers[J]) then begin
                pvarEnd := FViewer.View.Viewers[J].GetAccObject;
                Result := S_OK;
                Break;
              end;
          NAVDIR_DOWN, NAVDIR_RIGHT, NAVDIR_NEXT:
            for J := I+1 to FViewer.View.ViewerCount-1 do
              if ShouldPublishViewer(FViewer.View.Viewers[J]) then begin
                pvarEnd := FViewer.View.Viewers[J].GetAccObject;
                Result := S_OK;
                Break;
              end;
        end;
      end;
    end;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBItemViewerAccObject.accSelect(flagsSelect: Integer;
  varChild: OleVariant): HRESULT;
begin
  Result := DISP_E_MEMBERNOTFOUND;
end;

function TTBItemViewerAccObject.get_accChild(varChild: OleVariant;
  out ppdispChild: IDispatch): HRESULT;
var
  View: TTBView;
begin
  try
    if FViewer = nil then begin
      Result := E_FAIL;
      Exit;
    end;
    Result := E_INVALIDARG;
    if VarType(varChild) = varInteger then begin
      if varChild = CHILDID_SELF then begin
        ppdispChild := Self;
        Result := S_OK;
      end
      else if varChild = 1 then begin
        { Return the child view's acc. object }
        View := FViewer.View.OpenViewerView;
        if Assigned(View) then begin
          ppdispChild := View.GetAccObject;
          Result := S_OK;
        end;
      end;
    end;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBItemViewerAccObject.get_accChildCount(out pcountChildren: Integer): HRESULT;
begin
  try
    if FViewer = nil then begin
      Result := E_FAIL;
      Exit;
    end;
    { Return 1 if the viewer has a child view }
    if FViewer.View.OpenViewer = FViewer then
      pCountChildren := 1
    else
      pCountChildren := 0;
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBItemViewerAccObject.get_accDefaultAction(varChild: OleVariant;
  out pszDefaultAction: WideString): HRESULT;
begin
  try
    if not Check(varChild, Result) then
      Exit;
    if IsAvailable then begin
      { I'm not sure if these should be localized, or even if any screen
        readers make use of this text... }
      if FViewer.View.OpenViewer = FViewer then
        pszDefaultAction := 'Close'
      else if tbisSubmenu in TTBCustomItemAccess(FViewer.Item).ItemStyle then
        pszDefaultAction := 'Open'
      else if FViewer.View.IsPopup or (vsMenuBar in FViewer.View.Style) then
        pszDefaultAction := 'Execute'
      else
        pszDefaultAction := 'Press';
      Result := S_OK;
    end
    else
      Result := S_FALSE;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBItemViewerAccObject.get_accDescription(varChild: OleVariant;
  out pszDescription: WideString): HRESULT;
begin
  Result := S_FALSE;
end;

function TTBItemViewerAccObject.get_accFocus(out pvarID: OleVariant): HRESULT;
begin
  try
    if FViewer = nil then begin
      Result := E_FAIL;
      Exit;
    end;
    if (vsModal in FViewer.View.State) and
       (FViewer.View.Selected = FViewer) then begin
      pvarID := CHILDID_SELF;
      Result := S_OK;
    end
    else
      Result := S_FALSE;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBItemViewerAccObject.get_accHelp(varChild: OleVariant;
  out pszHelp: WideString): HRESULT;
begin
  Result := S_FALSE;
end;

function TTBItemViewerAccObject.get_accHelpTopic(out pszHelpFile: WideString;
  varChild: OleVariant; out pidTopic: Integer): HRESULT;
begin
  pidTopic := 0;  { Delphi doesn't implicitly clear Integer 'out' parameters }
  Result := S_FALSE;
end;

function TTBItemViewerAccObject.get_accKeyboardShortcut(varChild: OleVariant;
  out pszKeyboardShortcut: WideString): HRESULT;
var
  C: Char;
begin
  try
    if not Check(varChild, Result) then
      Exit;
    Result := S_FALSE;
    if TTBItemViewerAccess(FViewer).CaptionShown then begin
      C := FindAccelChar(TTBItemViewerAccess(FViewer).GetCaptionText);
      if C <> #0 then begin
        if FViewer.View.IsPopup then
          pszKeyboardShortcut := C
        else begin
          { Prefix 'Alt+' }
          pszKeyboardShortcut := ShortCutToText(VK_MENU) + '+' + C;
        end;
        Result := S_OK;
      end;
    end;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBItemViewerAccObject.get_accName(varChild: OleVariant;
  out pszName: WideString): HRESULT;
var
  C, S: String;
begin
  try
    if not Check(varChild, Result) then
      Exit;
    C := StripAccelChars(TTBItemViewerAccess(FViewer).GetCaptionText);
    if not FViewer.IsToolbarStyle then
      S := FViewer.Item.GetShortCutText;
    if S = '' then
      pszName := C
    else
      pszName := C + #9 + S;
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBItemViewerAccObject.get_accParent(out ppdispParent: IDispatch): HRESULT;
begin
  try
    if Assigned(FViewer) then begin
      ppdispParent := FViewer.View.GetAccObject;
      Result := S_OK;
    end
    else
      Result := E_FAIL;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBItemViewerAccObject.get_accRole(varChild: OleVariant;
  out pvarRole: OleVariant): HRESULT;
var
  Role: Integer;
begin
  try
    if not Check(varChild, Result) then
      Exit;
    if FViewer.Item is TTBControlItem then
      Role := ROLE_SYSTEM_CLIENT
    else if tbisSeparator in TTBCustomItemAccess(FViewer.Item).ItemStyle then
      Role := ROLE_SYSTEM_SEPARATOR
    else if FViewer.View.IsPopup or (vsMenuBar in FViewer.View.Style) then
      Role := ROLE_SYSTEM_MENUITEM
    else
      Role := ROLE_SYSTEM_PUSHBUTTON;
    pvarRole := Role;
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBItemViewerAccObject.get_accSelection(out pvarChildren: OleVariant): HRESULT;
begin
  Result := S_FALSE;
end;

function TTBItemViewerAccObject.get_accState(varChild: OleVariant;
  out pvarState: OleVariant): HRESULT;
var
  Flags: Integer;
begin
  try
    if not Check(varChild, Result) then
      Exit;
    Flags := 0;
    if FViewer.View.Selected = FViewer then begin
      Flags := Flags or STATE_SYSTEM_HOTTRACKED;
      if vsModal in FViewer.View.State then
        Flags := Flags or STATE_SYSTEM_FOCUSED;
      if FViewer.View.MouseOverSelected and FViewer.View.Capture then
        { ^ based on "IsPushed :=" code in TTBView.DrawItem }
        Flags := Flags or STATE_SYSTEM_PRESSED;
    end;
    if tbisSubmenu in TTBCustomItemAccess(FViewer.Item).ItemStyle then
      Flags := Flags or STATE_SYSTEM_HASPOPUP;
    if not FViewer.Show and not FViewer.Clipped then
      Flags := Flags or STATE_SYSTEM_INVISIBLE;
    if not IsAvailable then
      Flags := Flags or STATE_SYSTEM_UNAVAILABLE;
    if FViewer.Item.Checked then
      Flags := Flags or STATE_SYSTEM_CHECKED;
    pvarState := Flags;
    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TTBItemViewerAccObject.get_accValue(varChild: OleVariant;
  out pszValue: WideString): HRESULT;
begin
  Result := S_FALSE;
end;

function TTBItemViewerAccObject.put_accName(varChild: OleVariant;
  const pszName: WideString): HRESULT;
begin
  Result := S_FALSE;
end;

function TTBItemViewerAccObject.put_accValue(varChild: OleVariant;
  const pszValue: WideString): HRESULT;
begin
  Result := S_FALSE;
end;

end.
