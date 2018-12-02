unit TB2ToolWindow;

{
  Toolbar2000
  Copyright (C) 1998-2002 by Jordan Russell
  All rights reserved.
  For conditions of distribution and use, see LICENSE.TXT.

  TBSkin+ Modifications (C) Haralabos Michael 2001-2003

  $jrsoftware: tb2k/Source/TB2ToolWindow.pas,v 1.16 2003/03/13 17:51:07 jr Exp $
}

interface

{$I TB2Ver.inc}

uses
  Windows, Messages, Classes, Graphics, Controls, TB2Dock;

type
  { TTBToolWindow }

  TTBToolWindow = class(TTBCustomDockableWindow)
  private
    FMinClientWidth, FMinClientHeight, FMaxClientWidth, FMaxClientHeight: Integer;
    FBarHeight, FBarWidth: Integer;
    function CalcSize(ADock: TTBDock): TPoint;
    function GetClientAreaWidth: Integer;
    procedure SetClientAreaWidth(Value: Integer);
    function GetClientAreaHeight: Integer;
    procedure SetClientAreaHeight(Value: Integer);
    procedure SetClientAreaSize(AWidth, AHeight: Integer);
//Skin Patch Begin
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
//Skin Patch End
  protected
    function DoArrange(CanMoveControls: Boolean; PreviousDockType: TTBDockType;
      NewFloating: Boolean; NewDock: TTBDock): TPoint; override;
    procedure GetBaseSize(var ASize: TPoint); override;
    procedure GetMinMaxSize(var AMinClientWidth, AMinClientHeight,
      AMaxClientWidth, AMaxClientHeight: Integer); override;
    procedure Paint; override;
    procedure SizeChanging(const AWidth, AHeight: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure ReadPositionData(const Data: TTBReadPositionData); override;
    procedure WritePositionData(const Data: TTBWritePositionData); override;
  published
    property ActivateParent;
    property Align;
    property Anchors;
    property BorderStyle;
    property Caption;
    property Color;
    property CloseButton;
    property CloseButtonWhenDocked;
    property ClientAreaHeight: Integer read GetClientAreaHeight write SetClientAreaHeight;
    property ClientAreaWidth: Integer read GetClientAreaWidth write SetClientAreaWidth;
    property CurrentDock;
    property DefaultDock;
    property DockableTo;
    property DockMode;
    property DockPos;
    property DockRow;
    property DragHandleStyle;
    property DockTextAlign; //Skin Patch
    property FloatingMode;
    property Font;
    property FullSize;
    property HideWhenInactive;
    property LastDock;
    property MaxClientHeight: Integer read FMaxClientHeight write FMaxClientHeight default 0;
    property MaxClientWidth: Integer read FMaxClientWidth write FMaxClientWidth default 0;
    property MinClientHeight: Integer read FMinClientHeight write FMinClientHeight default 32;
    property MinClientWidth: Integer read FMinClientWidth write FMinClientWidth default 32;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Resizable;
    property ShowCaption;
    property ShowHint;
    property Stretch;
    property SmoothDrag;
    property TabOrder;
    property UseLastDock;
    {}{property Version;}
    property Visible;
    property Skin; //Skin Patch

    property OnClose;
    property OnCloseQuery;
    {$IFDEF JR_D5}
    property OnContextPopup;
    {$ENDIF}
    property OnDragDrop;
    property OnDragOver;
    property OnDockChanged;
    property OnDockChanging;
    property OnDockChangingHidden;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMove;
    property OnRecreated;
    property OnRecreating;
    property OnResize;
    property OnVisibleChanged;
  end;

implementation

Uses TBSkinPlus;

const
  { Constants for TTBToolWindow-specific registry values. Do not localize! }
  rvClientWidth = 'ClientWidth';
  rvClientHeight = 'ClientHeight';


{ TTBToolWindow }

constructor TTBToolWindow.Create(AOwner: TComponent);
begin
  inherited;
  FMinClientWidth := 32;
  FMinClientHeight := 32;
  { Initialize the client size to 32x32 }
  SetBounds(Left, Top, 32, 32);
end;

procedure TTBToolWindow.Paint;
var
  R: TRect;
begin
  { Draw dotted border in design mode }
  if csDesigning in ComponentState then
    with Canvas do begin
      R := ClientRect;
      Pen.Style := psDot;
      Pen.Color := clBtnShadow;
      Brush.Style := bsClear;
      Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      Pen.Style := psSolid;
    end;
end;

procedure TTBToolWindow.ReadPositionData(const Data: TTBReadPositionData);
begin
  inherited;
  { Restore ClientAreaWidth/ClientAreaHeight variables }
  if Resizable then
    with Data do
      SetClientAreaSize(ReadIntProc(Name, rvClientWidth, FBarWidth, ExtraData),
        ReadIntProc(Name, rvClientHeight, FBarHeight, ExtraData));
end;

procedure TTBToolWindow.WritePositionData(const Data: TTBWritePositionData);
begin
  inherited;
  { Write values of FBarWidth/FBarHeight }
  with Data do begin
    WriteIntProc(Name, rvClientWidth, FBarWidth, ExtraData);
    WriteIntProc(Name, rvClientHeight, FBarHeight, ExtraData);
  end;
end;

procedure TTBToolWindow.GetMinMaxSize(var AMinClientWidth, AMinClientHeight,
  AMaxClientWidth, AMaxClientHeight: Integer);
begin
  AMinClientWidth := FMinClientWidth;
  AMinClientHeight := FMinClientHeight;
  AMaxClientWidth := FMaxClientWidth;
  AMaxClientHeight := FMaxClientHeight;
end;

procedure TTBToolWindow.SizeChanging(const AWidth, AHeight: Integer);
begin
  FBarWidth := AWidth;
  if Parent <> nil then Dec(FBarWidth, Width - ClientWidth);
  FBarHeight := AHeight;
  if Parent <> nil then Dec(FBarHeight, Height - ClientHeight);
end;

function TTBToolWindow.CalcSize(ADock: TTBDock): TPoint;
begin
  Result.X := FBarWidth;
  Result.Y := FBarHeight;
  if Assigned(ADock) and (FullSize or Stretch) then begin
    { If docked and stretching, return the minimum size so that the toolbar
      can shrink below FBarWidth/FBarHeight }
    if not(ADock.Position in [dpLeft, dpRight]) then
      Result.X := FMinClientWidth
    else
      Result.Y := FMinClientHeight;
  end;
end;

procedure TTBToolWindow.GetBaseSize(var ASize: TPoint);
begin
  ASize := CalcSize(CurrentDock);
end;

function TTBToolWindow.DoArrange(CanMoveControls: Boolean;
  PreviousDockType: TTBDockType; NewFloating: Boolean; NewDock: TTBDock): TPoint;
begin
  Result := CalcSize(NewDock);
end;

function TTBToolWindow.GetClientAreaWidth: Integer;
begin
  if Parent = nil then
    Result := Width
  else
    Result := ClientWidth;
end;

procedure TTBToolWindow.SetClientAreaWidth(Value: Integer);
begin
  SetClientAreaSize(Value, ClientAreaHeight);
end;

function TTBToolWindow.GetClientAreaHeight: Integer;
begin
  if Parent = nil then
    Result := Height
  else
    Result := ClientHeight;
end;

procedure TTBToolWindow.SetClientAreaHeight(Value: Integer);
begin
  SetClientAreaSize(ClientAreaWidth, Value);
end;

procedure TTBToolWindow.SetClientAreaSize(AWidth, AHeight: Integer);
var
  Client: TRect;
begin
  if Parent = nil then
    SetBounds(Left, Top, AWidth, AHeight)
  else begin
    Client := GetClientRect;
    SetBounds(Left, Top, Width - Client.Right + AWidth,
      Height - Client.Bottom + AHeight);
  end;
end;

//Skin Patch Begin
procedure TTBToolWindow.WMEraseBkgnd(var Message: TWMEraseBkgnd);
Var
 Brush: HBrush;
 CSkin: TTBBaseSkin;
begin
 if not Assigned(Skin) then
   Inherited
 else begin
   If Assigned(Skin) then CSkin := Skin
   else CSkin := DefaultSkin;

   if (CSkin.SkinType = tbsOfficeXP) and Assigned(CurrentDock) then
     if not ((Assigned(CurrentDock.Background)) and
             (CurrentDock.BackgroundOnToolbars)) then begin
        Brush := CreateSolidBrush(Skin.RGBColor(cToolbar));

       FillRect(Message.DC, ClientRect, Brush);
       DeleteObject(Brush);

       Message.Result := 1;
     end
     else Inherited
   else Inherited;
 end;
end;
//Skin Patch End

end.
