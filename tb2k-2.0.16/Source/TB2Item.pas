unit TB2Item;

{
  Toolbar2000
  Copyright (C) 1998-2003 by Jordan Russell
  All rights reserved.
  For conditions of distribution and use, see LICENSE.TXT.

  TBSkin+ Modifications (C) Haralabos Michael 2001-2003

  $jrsoftware: tb2k/Source/TB2Item.pas,v 1.241.2.6 2003/06/08 18:35:44 jr Exp $
}

interface

{$I TB2Ver.inc}
{x$DEFINE TB2K_NO_ANIMATION}
  { Enabling the above define disables all menu animation. For debugging
    purpose only. }
{x$DEFINE TB2K_USE_STRICT_O2K_MENU_STYLE}
  { Enabling the above define forces it to use clBtnFace for the menu color
    instead of clMenu, and disables the use of flat menu borders on Windows
    XP with themes enabled. }

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Menus, ActnList, ImgList, TB2Anim,
  TBSkinPlus; //Skin Patch

type
  TTBCustomItem = class;
  TTBCustomItemClass = class of TTBCustomItem;
  TTBCustomItemActionLink = class;
  TTBCustomItemActionLinkClass = class of TTBCustomItemActionLink;
  TTBItemViewer = class;
  TTBItemViewerClass = class of TTBItemViewer;
  TTBPopupWindow = class;
  TTBPopupWindowClass = class of TTBPopupWindow;
  TTBView = class;

  TTBDoneAction = (tbdaNone, tbdaClickItem, tbdaOpenSystemMenu, tbdaHelpContext);
  PTBDoneActionData = ^TTBDoneActionData;
  TTBDoneActionData = record
    DoneAction: TTBDoneAction;
    case TTBDoneAction of
      tbdaClickItem: (ClickItem: TTBCustomItem; Sound: Boolean);
      tbdaOpenSystemMenu: (Wnd: HWND; Key: Cardinal);
      tbdaHelpContext: (ContextID: Integer);
  end;
  TTBInsertItemProc = procedure(AParent: TComponent; AItem: TTBCustomItem) of object;
  TTBItemChangedAction = (tbicInserted, tbicDeleting, tbicSubitemsChanged,
    tbicSubitemsBeginUpdate, tbicSubitemsEndUpdate, tbicInvalidate,
    tbicInvalidateAndResize, tbicRecreateItemViewers, tbicNameChanged,
    tbicSubMenuImagesChanged);
  TTBItemChangedProc = procedure(Sender: TTBCustomItem; Relayed: Boolean;
    Action: TTBItemChangedAction; Index: Integer; Item: TTBCustomItem) of object;
  TTBItemData = record
    Item: TTBCustomItem;
  end;
  PTBItemDataArray = ^TTBItemDataArray;
  TTBItemDataArray = array[0..$7FFFFFFF div SizeOf(TTBItemData)-1] of TTBItemData;
  TTBItemDisplayMode = (nbdmDefault, nbdmTextOnly, nbdmTextOnlyInMenus, nbdmImageAndText);
  TTBItemEventData = record
    RootView: TTBView;
    CaptureWnd: HWND;
    MouseDownOnMenu, CancelLoop: Boolean;
    DoneActionData: PTBDoneActionData;
  end;
  TTBItemOption = (tboDefault, tboDropdownArrow, tboImageAboveCaption,
    tboLongHintInMenuOnly, tboNoRotation, tboSameWidth, tboShowHint,
    tboToolbarStyle, tboToolbarSize);
  TTBItemOptions = set of TTBItemOption;
  TTBItemStyle = set of (tbisSubmenu, tbisSelectable, tbisSeparator,
    tbisEmbeddedGroup, tbisClicksTransparent, tbisCombo, tbisNoAutoOpen,
    tbisSubitemsEditable, tbisNoLineBreak, tbisRightAlign, tbisDontSelectFirst,
    tbisRedrawOnSelChange, tbisRedrawOnMouseOverChange);
  TTBPopupAlignment = (tbpaLeft, tbpaRight, tbpaCenter);
  TTBPopupEvent = procedure(Sender: TTBCustomItem; FromLink: Boolean) of object;
  TTBSelectEvent = procedure(Sender: TTBCustomItem; Viewer: TTBItemViewer;
    Selecting: Boolean) of object;
  TTBPopupPosition = (tbpTop, tbpRight, tbpOther); //Skin Patch

  ETBItemError = class(Exception);

  TTBImageChangeLink = class(TChangeLink)
  private
    FLastWidth, FLastHeight: Integer;
  end;
  {$IFNDEF JR_D5}
  TImageIndex = type Integer;
  {$ENDIF}

  TTBCustomItem = class(TComponent)
  private
    FActionLink: TTBCustomItemActionLink;
    FAutoCheck: Boolean;
    FCaption: String;
    FChecked: Boolean;
    FDisplayMode: TTBItemDisplayMode;
    FEnabled: Boolean;
    FEffectiveOptions: TTBItemOptions;
    FGroupIndex: Integer;
    FHelpContext: THelpContext;
    FHint: String;
    FImageIndex: TImageIndex;
    FImages: TCustomImageList;
    FImagesChangeLink: TTBImageChangeLink;
    FItems: PTBItemDataArray;
    FItemCount: Integer;
    FItemStyle: TTBItemStyle;
    FLinkParents: TList;
    FMaskOptions: TTBItemOptions;
    FOptions: TTBItemOptions;
    FInheritOptions: Boolean;
    FNotifyList: TList;
    FOnClick: TNotifyEvent;
    FOnPopup: TTBPopupEvent;
    FOnSelect: TTBSelectEvent;
    FParent: TTBCustomItem;
    FParentComponent: TComponent;
    FShortCut: TShortCut;
    FSubMenuImages: TCustomImageList;
    FSubMenuImagesChangeLink: TTBImageChangeLink;
    FLinkSubitems: TTBCustomItem;
    FVisible: Boolean;
    FSkin: TTBBaseSkin; //Skin Patch .. For TTBPopupMenu usuage

    procedure DoActionChange(Sender: TObject);
    function ChangeImages(var AImages: TCustomImageList;
      const Value: TCustomImageList; var AChangeLink: TTBImageChangeLink): Boolean;
    class procedure ClickWndProc(var Message: TMessage);
    function FindItemWithShortCut(AShortCut: TShortCut;
      var ATopmostParent: TTBCustomItem): TTBCustomItem;
    function FixOptions(const AOptions: TTBItemOptions): TTBItemOptions;
    function GetAction: TBasicAction;
    function GetItem(Index: Integer): TTBCustomItem;
    procedure ImageListChangeHandler(Sender: TObject);
    {$IFDEF JR_D6}
    function IsAutoCheckStored: Boolean;
    {$ENDIF}
    function IsCaptionStored: Boolean;
    function IsCheckedStored: Boolean;
    function IsEnabledStored: Boolean;
    function IsHelpContextStored: Boolean;
    function IsHintStored: Boolean;
    function IsImageIndexStored: Boolean;
    function IsOnClickStored: Boolean;
    function IsShortCutStored: Boolean;
    function IsVisibleStored: Boolean;
    procedure Notify(Sender: TTBCustomItem; Action: TTBItemChangedAction;
      Index: Integer; Item: TTBCustomItem);
    procedure RefreshOptions;
    procedure SetAction(Value: TBasicAction);
    procedure SetCaption(Value: String);
    procedure SetChecked(Value: Boolean);
    procedure SetDisplayMode(Value: TTBItemDisplayMode);
    procedure SetEnabled(Value: Boolean);
    procedure SetGroupIndex(Value: Integer);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetImages(Value: TCustomImageList);
    procedure SetInheritOptions(Value: Boolean);
    procedure SetLinkSubitems(Value: TTBCustomItem);
    procedure SetMaskOptions(Value: TTBItemOptions);
    procedure SetOptions(Value: TTBItemOptions);
    procedure SetSubMenuImages(Value: TCustomImageList);
    procedure SetVisible(Value: Boolean);
    procedure SubMenuImagesChanged;
    procedure TurnSiblingsOff;
  protected
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); dynamic;
    procedure Change(NeedResize: Boolean); virtual;
    function CreatePopup(const ParentView: TTBView; const ParentViewer: TTBItemViewer;
      const PositionAsSubmenu, SelectFirstItem, Customizing: Boolean;
      const APopupPoint: TPoint; const Alignment: TTBPopupAlignment): TTBPopupWindow; virtual;
    procedure DoPopup(Sender: TTBCustomItem; FromLink: Boolean); virtual;
    procedure EnabledChanged; virtual;
    function GetActionLinkClass: TTBCustomItemActionLinkClass; dynamic;
    function GetChevronParentView: TTBView; virtual;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetItemViewerClass(AView: TTBView): TTBItemViewerClass; virtual;
    function GetPopupWindowClass: TTBPopupWindowClass; virtual;
    procedure IndexError;
    procedure Loaded; override;
    function NeedToRecreateViewer(AViewer: TTBItemViewer): Boolean; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure OpenPopup(const SelectFirstItem, TrackRightButton: Boolean;
      const PopupPoint: TPoint; const Alignment: TTBPopupAlignment);
    procedure RecreateItemViewers;
    procedure SetChildOrder(Child: TComponent; Order: Integer); override;
    procedure SetName(const NewName: TComponentName); override;
    procedure SetParentComponent(Value: TComponent); override;

    property ActionLink: TTBCustomItemActionLink read FActionLink write FActionLink;
    property ItemStyle: TTBItemStyle read FItemStyle write FItemStyle;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function HasParent: Boolean; override;
    function GetParentComponent: TComponent; override;

    procedure Add(AItem: TTBCustomItem);
    procedure Clear;
    procedure Click; virtual;
    function ContainsItem(AItem: TTBCustomItem): Boolean;
    procedure Delete(Index: Integer);
    function GetHintText: String;
    function GetShortCutText: String;
    function IndexOf(AItem: TTBCustomItem): Integer;
    procedure InitiateAction; virtual;
    procedure Insert(NewIndex: Integer; AItem: TTBCustomItem);
    function IsShortCut(var Message: TWMKey): Boolean;
    procedure Move(CurIndex, NewIndex: Integer);
    procedure Popup(X, Y: Integer; TrackRightButton: Boolean;
      Alignment: TTBPopupAlignment = tbpaLeft);
    procedure RegisterNotification(ANotify: TTBItemChangedProc);
    procedure Remove(Item: TTBCustomItem);
    procedure UnregisterNotification(ANotify: TTBItemChangedProc);
    procedure ViewBeginUpdate;
    procedure ViewEndUpdate;

    property Action: TBasicAction read GetAction write SetAction;
    property AutoCheck: Boolean read FAutoCheck write FAutoCheck {$IFDEF JR_D6} stored IsAutoCheckStored {$ENDIF} default False;
    property Caption: String read FCaption write SetCaption stored IsCaptionStored;
    property Count: Integer read FItemCount;
    property Checked: Boolean read FChecked write SetChecked stored IsCheckedStored default False;
    property DisplayMode: TTBItemDisplayMode read FDisplayMode write SetDisplayMode default nbdmDefault;
    property EffectiveOptions: TTBItemOptions read FEffectiveOptions;
    property Enabled: Boolean read FEnabled write SetEnabled stored IsEnabledStored default True;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;
    property HelpContext: THelpContext read FHelpContext write FHelpContext stored IsHelpContextStored default 0;
    property Hint: String read FHint write FHint stored IsHintStored;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex stored IsImageIndexStored default -1;
    property Images: TCustomImageList read FImages write SetImages;
    property InheritOptions: Boolean read FInheritOptions write SetInheritOptions default True;
    property Items[Index: Integer]: TTBCustomItem read GetItem; default;
    property LinkSubitems: TTBCustomItem read FLinkSubitems write SetLinkSubitems;
    property MaskOptions: TTBItemOptions read FMaskOptions write SetMaskOptions default [];
    property Options: TTBItemOptions read FOptions write SetOptions default [];
    property Parent: TTBCustomItem read FParent;
    property ParentComponent: TComponent read FParentComponent write FParentComponent;
    property ShortCut: TShortCut read FShortCut write FShortCut stored IsShortCutStored default 0;
    property SubMenuImages: TCustomImageList read FSubMenuImages write SetSubMenuImages;
    property Visible: Boolean read FVisible write SetVisible stored IsVisibleStored default True;
    property OnClick: TNotifyEvent read FOnClick write FOnClick stored IsOnClickStored;
    property OnPopup: TTBPopupEvent read FOnPopup write FOnPopup;
    property OnSelect: TTBSelectEvent read FOnSelect write FOnSelect;
  end;

  TTBCustomItemActionLink = class(TActionLink)
  protected
    FClient: TTBCustomItem;
    procedure AssignClient(AClient: TObject); override;
    {$IFDEF JR_D6}
    function IsAutoCheckLinked: Boolean; virtual;
    {$ENDIF}
    function IsCaptionLinked: Boolean; override;
    function IsCheckedLinked: Boolean; override;
    function IsEnabledLinked: Boolean; override;
    function IsHelpContextLinked: Boolean; override;
    function IsHintLinked: Boolean; override;
    function IsImageIndexLinked: Boolean; override;
    function IsShortCutLinked: Boolean; override;
    function IsVisibleLinked: Boolean; override;
    function IsOnExecuteLinked: Boolean; override;
    {$IFDEF JR_D6}
    procedure SetAutoCheck(Value: Boolean); override;
    {$ENDIF}
    procedure SetCaption(const Value: String); override;
    procedure SetChecked(Value: Boolean); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetHelpContext(Value: THelpContext); override;
    procedure SetHint(const Value: String); override;
    procedure SetImageIndex(Value: Integer); override;
    procedure SetShortCut(Value: TShortCut); override;
    procedure SetVisible(Value: Boolean); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;
  end;

  TTBBaseAccObject = class(TInterfacedObject, IDispatch)
  public
    procedure ClientIsDestroying; virtual; abstract;
    { IDispatch }
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
  end;

  TTBItemViewer = class
  private
    FBoundsRect: TRect;
    FClipped: Boolean;
    FItem: TTBCustomItem;
    FOffEdge: Boolean;
    FShow: Boolean;
    FView: TTBView;
    function GetIndex: Integer;
  protected
    FAccObjectInstance: TTBBaseAccObject; 
    procedure CalcSize(const Canvas: TCanvas; var AWidth, AHeight: Integer);
      virtual;
    function CaptionShown: Boolean; dynamic;
    procedure DrawItemCaption(const Canvas: TCanvas; ARect: TRect;
      const ACaption: String; ADrawDisabledShadow: Boolean; AFormat: UINT;
      const Disabled3D: Boolean = False); virtual;
    procedure Entering; virtual;
    function GetCaptionText: String; virtual;
    procedure GetCursor(const Pt: TPoint; var ACursor: HCURSOR); virtual;
    function GetImageList: TCustomImageList;
    function ImageShown: Boolean;
    function IsRotated: Boolean;
    function IsToolbarSize: Boolean;
    function IsPtInButtonPart(X, Y: Integer): Boolean; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState;
      var EventData: TTBItemEventData); virtual;
    procedure Leaving; virtual;
    procedure LosingCapture; virtual;
    procedure MouseDown(Shift: TShiftState; X, Y: Integer;
      var EventData: TTBItemEventData); virtual;
    procedure MouseMove(X, Y: Integer; var EventData: TTBItemEventData); virtual;
    procedure MouseUp(X, Y: Integer; var EventData: TTBItemEventData); virtual;
    procedure MouseWheel(WheelDelta: Integer; X, Y: Integer;
      var EventData: TTBItemEventData); virtual;
    procedure Paint(const Canvas: TCanvas; const ClientAreaRect: TRect;
      IsSelected, IsPushed, UseDisabledShadow: Boolean); virtual;
    function UsesSameWidth: Boolean; virtual;
  public
    State: set of (tbisInvalidated, tbisLineSep);
    property BoundsRect: TRect read FBoundsRect;
    property Clipped: Boolean read FClipped;
    property Index: Integer read GetIndex;
    property Item: TTBCustomItem read FItem;
    property OffEdge: Boolean read FOffEdge;
    property Show: Boolean read FShow;
    property View: TTBView read FView;
    constructor Create(AView: TTBView; AItem: TTBCustomItem); virtual;
    destructor Destroy; override;
    function GetAccObject: IDispatch;
    function IsToolbarStyle: Boolean;
    function ScreenToClient(const P: TPoint): TPoint;
  end;
  PTBItemViewerArray = ^TTBItemViewerArray;
  TTBItemViewerArray = array[0..$7FFFFFFF div SizeOf(TTBItemViewer)-1] of TTBItemViewer;
  TTBViewOptions = set of (nbvoUnused);
  TTBViewOrientation = (tbvoHorizontal, tbvoVertical, tbvoFloating);
  TTBEnterToolbarLoopOptions = set of (tbetMouseDown, tbetDropDownMenus,
    tbetKeyboardControl);
  TTBViewState = set of (vsModal, vsMouseInWindow, vsDrawInOrder, vsOppositePopup,
    vsIgnoreFirstMouseUp, vsShowAccels, vsDropDownMenus, vsNoAnimation);
  TTBViewStyle = set of (vsMenuBar, vsUseHiddenAccels, vsAlwaysShowHints);
  TTBViewTimerID = (tiOpen, tiClose, tiScrollUp, tiScrollDown);

  TTBViewClass = class of TTBView;
  TTBView = class(TComponent)
  private
    FActiveTimers: set of TTBViewTimerID;
    FBackgroundColor: TColor;
    FBaseSize: TPoint;
    FCapture: Boolean;
    FChevronOffset: Integer;
    FChevronParentView: TTBView;
    FChevronSize: Integer;
    FCurParentItem: TTBCustomItem;
    FCustomizing: Boolean;
    FInternalViewersAtEnd: Integer;
    FInternalViewersAtFront: Integer;
    FIsPopup: Boolean;
    FIsToolbar: Boolean;
    FMaxHeight: Integer;
    FMonitorRect: TRect;
    FMouseOverSelected: Boolean;
    FOpenViewer: TTBItemViewer;
    FOpenViewerView: TTBView;
    FOpenViewerWindow: TTBPopupWindow;
    FParentView: TTBView;
    FParentItem: TTBCustomItem;
    FPriorityList: TList;
    FOptions: TTBViewOptions;
    FOrientation: TTBViewOrientation;
    FScrollOffset: Integer;
    FSelected: TTBItemViewer;
    FShowDownArrow: Boolean;
    FShowUpArrow: Boolean;
    FSkin: TTBBaseSkin; //Skin Patch
    FState: TTBViewState;
    FStyle: TTBViewStyle;
    FUpdating: Integer;
    FUsePriorityList: Boolean;
    FValidated: Boolean;
    FViewerCount: Integer;
    FViewers: PTBItemViewerArray;
    FWindow: TWinControl;
    FWrapOffset: Integer;

    procedure DeletingViewer(Viewer: TTBItemViewer);
    procedure DrawItem(Viewer: TTBItemViewer; DrawTo: TCanvas; Offscreen: Boolean);
    procedure FreeViewers;
    procedure ImagesChanged;
    procedure ItemNotification(Sender: TTBCustomItem; Relayed: Boolean;
      Action: TTBItemChangedAction; Index: Integer; Item: TTBCustomItem);
    procedure LinkNotification(Sender: TTBCustomItem; Relayed: Boolean;
      Action: TTBItemChangedAction; Index: Integer; Item: TTBCustomItem);
    procedure NotifyFocusEvent;
    procedure RecreateItemViewer(const I: Integer);
    procedure Scroll(ADown: Boolean);
    procedure SetCustomizing(Value: Boolean);
    procedure SetSelected(Value: TTBItemViewer);
    procedure SetUsePriorityList(Value: Boolean);
    procedure StartTimer(const ATimer: TTBViewTimerID; const Interval: Integer);
    procedure StopAllTimers;
    procedure StopTimer(const ATimer: TTBViewTimerID);
    procedure UpdateCurParentItem;
  protected
    FAccObjectInstance: TTBBaseAccObject;
    procedure AutoSize(AWidth, AHeight: Integer); virtual;
    function CalculatePositions(const CanMoveControls: Boolean;
      const AOrientation: TTBViewOrientation;
      AWrapOffset, AChevronOffset, AChevronSize: Integer;
      var ABaseSize, TotalSize: TPoint;
      var AWrappedLines: Integer): Boolean;
    function ClickSelectedItem(var EventData: TTBItemEventData): Boolean;
    procedure DoUpdatePositions(var ASize: TPoint); virtual;
    function GetChevronItem: TTBCustomItem; virtual;
    procedure GetMargins(AOrientation: TTBViewOrientation; var Margins: TRect);
      virtual;
    function GetMDIButtonsItem: TTBCustomItem; virtual;
    function GetMDISystemMenuItem: TTBCustomItem; virtual;
    function GetFont: TFont; virtual;
    function GetParentToolbarView: TTBView;
    function GetRootView: TTBView;
    function HandleWMGetObject(var Message: TMessage): Boolean;
    procedure InitiateActions;
    procedure KeyDown(var Key: Word; Shift: TShiftState;
      var EventData: TTBItemEventData); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function OpenChildPopup(const SelectFirstItem: Boolean): Boolean;
    procedure SetAccelsVisibility(AShowAccels: Boolean);
  public
    constructor CreateView(AOwner: TComponent; AParentView: TTBView;
      AParentItem: TTBCustomItem; AWindow: TWinControl;
      AIsToolbar, ACustomizing, AUsePriorityList: Boolean); virtual;
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure CancelCapture;
    procedure CloseChildPopups;
    function ContainsView(AView: TTBView): Boolean;
    procedure DrawSubitems(ACanvas: TCanvas);
    procedure EndUpdate;
    procedure EnterToolbarLoop(Options: TTBEnterToolbarLoopOptions);
    function Find(Item: TTBCustomItem): TTBItemViewer;
    function FirstSelectable: TTBItemViewer;
    function GetAccObject: IDispatch;
    procedure GetOffEdgeControlList(const List: TList);
    procedure GivePriority(AViewer: TTBItemViewer);
    function HighestPriorityViewer: TTBItemViewer;
    procedure Invalidate(AViewer: TTBItemViewer);
    procedure InvalidatePositions; virtual;
    function IndexOf(AViewer: TTBItemViewer): Integer;
    function NextSelectable(CurViewer: TTBItemViewer; GoForward: Boolean): TTBItemViewer;
    function NextSelectableWithAccel(CurViewer: TTBItemViewer; Key: Char;
      RequirePrimaryAccel: Boolean; var IsOnlyItemWithAccel: Boolean): TTBItemViewer;
    procedure RecreateAllViewers;
    procedure ScrollSelectedIntoView;
    procedure SetCapture;
    procedure TryValidatePositions;
    procedure UpdateSelection(const P: PPoint; const AllowNewSelection: Boolean);
    function UpdatePositions: TPoint;
    procedure ValidatePositions;
    function ViewerFromPoint(const P: TPoint): TTBItemViewer;

    property BackgroundColor: TColor read FBackgroundColor write FBackgroundColor;
    property BaseSize: TPoint read FBaseSize;
    property Capture: Boolean read FCapture;
    property ChevronOffset: Integer read FChevronOffset write FChevronOffset;
    property ChevronSize: Integer read FChevronSize write FChevronSize;
    property Customizing: Boolean read FCustomizing write SetCustomizing;
    property IsPopup: Boolean read FIsPopup;
    property IsToolbar: Boolean read FIsToolbar;
    property MouseOverSelected: Boolean read FMouseOverSelected;
    property Options: TTBViewOptions read FOptions write FOptions;
    property ParentView: TTBView read FParentView;
    property ParentItem: TTBCustomItem read FParentItem;
    property OpenViewer: TTBItemViewer read FOpenViewer;
    property OpenViewerView: TTBView read FOpenViewerView;
    property Orientation: TTBViewOrientation read FOrientation write FOrientation;
    property Selected: TTBItemViewer read FSelected write SetSelected;
    property Skin: TTBBaseSkin read FSkin write FSkin; //Skin Patch
    property State: TTBViewState read FState;
    property Style: TTBViewStyle read FStyle write FStyle;
    property UsePriorityList: Boolean read FUsePriorityList write SetUsePriorityList;
    property Viewers: PTBItemViewerArray read FViewers;
    property ViewerCount: Integer read FViewerCount;
    property Window: TWinControl read FWindow;
    property WrapOffset: Integer read FWrapOffset write FWrapOffset;
  end;

  TTBRootItemClass = class of TTBRootItem;
  TTBRootItem = class(TTBCustomItem);
  { same as TTBCustomItem, except there's a property editor for it }

  TTBItem = class(TTBCustomItem)
  published
    property Action;
    property AutoCheck;
    property Caption;
    property Checked;
    property DisplayMode;
    property Enabled;
    property GroupIndex;
    property HelpContext;
    property Hint;
    property ImageIndex;
    property Images;
    property InheritOptions;
    property MaskOptions;
    property Options;
    property ShortCut;
    property Visible;

    property OnClick;
    property OnSelect;
  end;

  TTBGroupItem = class(TTBCustomItem)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property InheritOptions;
    property LinkSubitems;
    property MaskOptions;
    property Options;
  end;

  TTBSubmenuItem = class(TTBCustomItem)
  private
    function GetDropdownCombo: Boolean;
    procedure SetDropdownCombo(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Action;
    property AutoCheck;
    property Caption;
    property Checked;
    //property DisplayAsToolbar;
    property DisplayMode;
    property DropdownCombo: Boolean read GetDropdownCombo write SetDropdownCombo default False;
    property Enabled;
    property GroupIndex;
    property HelpContext;
    property Hint;
    property ImageIndex;
    property Images;
    property InheritOptions;
    property LinkSubitems;
    property MaskOptions;
    property Options;
    property ShortCut;
    property SubMenuImages;
    property Visible;

    property OnClick;
    property OnPopup;
    property OnSelect;
  end;

  TTBSeparatorItem = class(TTBCustomItem)
  private
    FBlank: Boolean;
    procedure SetBlank(Value: Boolean);
  protected
    function GetItemViewerClass(AView: TTBView): TTBItemViewerClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Blank: Boolean read FBlank write SetBlank default False;
    property Hint;
    property Visible;
  end;

  TTBSeparatorItemViewer = class(TTBItemViewer)
  protected
    procedure CalcSize(const Canvas: TCanvas;
      var AWidth, AHeight: Integer); override;
    procedure Paint(const Canvas: TCanvas; const ClientAreaRect: TRect;
      IsSelected, IsPushed, UseDisabledShadow: Boolean); override;
    function UsesSameWidth: Boolean; override;
  end;

  TTBControlItem = class(TTBCustomItem)
  private
    FControl: TControl;
    FDontFreeControl: Boolean;
    procedure SetControl(Value: TControl);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateControlItem(AOwner: TComponent; AControl: TControl);
    destructor Destroy; override;
    property DontFreeControl: Boolean read FDontFreeControl write FDontFreeControl;
  published
    property Control: TControl read FControl write SetControl;
  end;

  TTBPopupView = class(TTBView)
  protected
    procedure AutoSize(AWidth, AHeight: Integer); override;
    function GetFont: TFont; override;
  end;

  TTBPopupWindow = class(TCustomControl)
  private
    FAccelsVisibilitySet: Boolean;
    FAnimationDirection: TTBAnimationDirection;
    FView: TTBView;
//Skin Patch Begin
    FSkin: TTBBaseSkin;
    FShadowPR, //Popup Right Shadow
    FShadowPB, //Popup Bottom Shadow
    FShadowIR, //Item Right Shadow
    FShadowIB: TShadow; //Item Bottom Shadow
    procedure WMTB2kAnimationEnded(var Message: TMessage); message WM_TB2K_ANIMATIONENDED;
//Skin Patch End
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMClose(var Message: TWMClose); message WM_CLOSE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMGetObject(var Message: TMessage); message WM_GETOBJECT;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMPrint(var Message: TMessage); message WM_PRINT;
    procedure WMPrintClient(var Message: TMessage); message WM_PRINTCLIENT;
    procedure WMTB2kStepAnimation(var Message: TMessage); message WM_TB2K_STEPANIMATION;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWindowHandle; override;
    function GetViewClass: TTBViewClass; dynamic;
    procedure Paint; override;
    procedure PaintScrollArrows; virtual;
  public
    constructor CreatePopupWindow(AOwner: TComponent; const AParentView: TTBView;
      const AItem: TTBCustomItem; const ACustomizing: Boolean); virtual;
    destructor Destroy; override;
    procedure BeforeDestruction; override;

    property View: TTBView read FView;
    property Skin: TTBBaseSkin read FSkin write FSkin; //Skin Patch
  end;

  ITBItems = interface
    ['{A5C0D7CC-3EC4-4090-A0F8-3D03271877EA}']
    function GetItems: TTBCustomItem;
  end;

  TTBItemContainer = class(TComponent, ITBItems)
  private
    FItem: TTBRootItem;
    function GetImages: TCustomImageList;
    function GetItems: TTBCustomItem;
    procedure SetImages(Value: TCustomImageList);
  protected
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Items: TTBRootItem read FItem;
  published
    property Images: TCustomImageList read GetImages write SetImages;
  end;

  TTBPopupMenu = class(TPopupMenu, ITBItems)
  private
    FItem: TTBRootItem;
    FSkin: TTBBaseSkin; //Skin Patch
    //procedure SetItems(Value: TTBCustomItem);
    function GetImages: TCustomImageList;
    function GetItems: TTBCustomItem;
    function GetLinkSubitems: TTBCustomItem;
    function GetOptions: TTBItemOptions;
    procedure RootItemClick(Sender: TObject);
    procedure SetImages(Value: TCustomImageList);
    procedure SetLinkSubitems(Value: TTBCustomItem);
    procedure SetOptions(Value: TTBItemOptions);
    procedure SetSkin(const Value: TTBBaseSkin); //Skin Patch
  protected
    {$IFNDEF JR_D5}
    procedure DoPopup(Sender: TObject);
    {$ENDIF}
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function GetRootItemClass: TTBRootItemClass; dynamic;
    procedure SetChildOrder(Child: TComponent; Order: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override; //Skin Patch
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsShortCut(var Message: TWMKey): Boolean; override;
    procedure Popup(X, Y: Integer); override;
  published
    property Images: TCustomImageList read GetImages write SetImages;
    property Items: TTBRootItem read FItem;
    property LinkSubitems: TTBCustomItem read GetLinkSubitems write SetLinkSubitems;
    property Skin: TTBBaseSkin read FSkin write SetSkin; //Skin Patch
    property Options: TTBItemOptions read GetOptions write SetOptions default [];
  end;

  TTBCustomImageList = class(TImageList)
  private
    FCheckedImages: TCustomImageList;
    FCheckedImagesChangeLink: TChangeLink;
    FDisabledImages: TCustomImageList;
    FDisabledImagesChangeLink: TChangeLink;
    FHotImages: TCustomImageList;
    FHotImagesChangeLink: TChangeLink;
    FImagesBitmap: TBitmap;
    FImagesBitmapMaskColor: TColor;
    procedure ChangeImages(var AImageList: TCustomImageList;
      Value: TCustomImageList; AChangeLink: TChangeLink);
    procedure ImageListChanged(Sender: TObject);
    procedure ImagesBitmapChanged(Sender: TObject);
    procedure SetCheckedImages(Value: TCustomImageList);
    procedure SetDisabledImages(Value: TCustomImageList);
    procedure SetHotImages(Value: TCustomImageList);
    procedure SetImagesBitmap(Value: TBitmap);
    procedure SetImagesBitmapMaskColor(Value: TColor);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property CheckedImages: TCustomImageList read FCheckedImages write SetCheckedImages;
    property DisabledImages: TCustomImageList read FDisabledImages write SetDisabledImages;
    property HotImages: TCustomImageList read FHotImages write SetHotImages;
    property ImagesBitmap: TBitmap read FImagesBitmap write SetImagesBitmap;
    property ImagesBitmapMaskColor: TColor read FImagesBitmapMaskColor
      write SetImagesBitmapMaskColor default clFuchsia;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DrawState(Canvas: TCanvas; X, Y, Index: Integer;
      Enabled, Selected, Checked: Boolean); virtual;
  end;

  TTBImageList = class(TTBCustomImageList)
  published
    property CheckedImages;
    property DisabledImages;
    property HotImages;
    property ImagesBitmap;
    property ImagesBitmapMaskColor;
  end;

const
  {$IFNDEF TB2K_USE_STRICT_O2K_MENU_STYLE}
  tbMenuBkColor = clMenu;
  tbMenuTextColor = clMenuText;
  {$ELSE}
  tbMenuBkColor = clBtnFace;
  tbMenuTextColor = clBtnText;
  {$ENDIF}

  tbMenuVerticalMargin = 4;
  tbMenuImageTextSpace = 1;
  tbMenuLeftTextMargin = 2;
  tbMenuRightTextMargin = 3;

  tbMenuSeparatorOffset = 12;

  tbMenuScrollArrowHeight = 19;

  tbDropdownArrowWidth = 8;
  tbDropdownArrowMargin = 3;
  tbDropdownComboArrowWidth = 11;
  tbDropdownComboMargin = 2;

  tbLineSpacing = 6;
  tbLineSepOffset = 1;
  tbDockedLineSepOffset = 4;

  WM_TB2K_CLICKITEM = WM_USER + $100;

procedure TBInitToolbarSystemFont;
procedure TBRegisterControlItem;

var
  ToolbarFont: TFont;

implementation

uses
  MMSYSTEM, TB2Consts, TB2Common, IMM, TB2Acc,
  TB2Dock, TB2Toolbar, TBSkinShared; //Skin Patch

var
  LastPos: TPoint;

threadvar
  ThreadItemCount: Integer;
  ClickWnd: HWND;
  ClickedItem: TTBCustomItem;
//Skin Patch Begin
  KeyHover: Boolean;
  ShowShadow: Boolean;
  PopupPosition: TTBPopupPosition;
//Skin Patch End

type
  TTBModalHandler = class
  private
    FCreatedWnd: Boolean;
    FInited: Boolean;
    FWnd: HWND;
  public
    constructor Create(AExistingWnd: HWND);
    destructor Destroy; override;
    procedure Loop(const RootView: TTBView; const AMouseDown, ADropDownMenus,
      KeyboardControl, TrackRightButton: Boolean;
      var DoneActionData: TTBDoneActionData);
    property Wnd: HWND read FWnd;
  end;

  PItemChangedNotificationData = ^TItemChangedNotificationData;
  TItemChangedNotificationData = record
    Proc: TTBItemChangedProc;
    RefCount: Integer;
  end;

  TComponentAccess = class(TComponent);
  TControlAccess = class(TControl);

const
  ViewTimerBaseID = 9000;


{ Misc. }

var
  ControlItemRegistered: Boolean = False;

procedure TBRegisterControlItem;
begin
  if not ControlItemRegistered then begin
    RegisterClass(TTBControlItem);
    ControlItemRegistered := True;
  end;
end;

procedure ProcessDoneAction(const DoneActionData: TTBDoneActionData);
begin
  case DoneActionData.DoneAction of
    tbdaNone: ;
    tbdaClickItem: begin
        if DoneActionData.Sound and NeedToPlaySound('MenuCommand') then
          PlaySound('MenuCommand', 0, SND_ALIAS or SND_ASYNC or SND_NODEFAULT or SND_NOSTOP);
        { As with standard menus, post a message to the message queue so that
          the item's Click handler is run when control is returned to the
          message loop. }
        ClickedItem := DoneActionData.ClickItem;
        if ClickWnd = 0 then
          ClickWnd := {$IFDEF JR_D6}Classes.{$ENDIF} AllocateHWnd(TTBCustomItem.ClickWndProc);
        PostMessage(ClickWnd, WM_TB2K_CLICKITEM, 0, 0);
      end;
    tbdaOpenSystemMenu: begin
        SendMessage(DoneActionData.Wnd, WM_SYSCOMMAND, SC_KEYMENU, DoneActionData.Key);
      end;
    tbdaHelpContext: begin
        { Based on code in TPopupList.WndProc: }
        if Assigned(Screen.ActiveForm) and
           (biHelp in Screen.ActiveForm.BorderIcons) then
          Application.HelpCommand(HELP_CONTEXTPOPUP, DoneActionData.ContextID)
        else
          Application.HelpContext(DoneActionData.ContextID);
      end;
  end;
end;


{ TTBItemDataArray routines }

procedure InsertIntoItemArray(var AItems: PTBItemDataArray;
  var AItemCount: Integer; NewIndex: Integer; AItem: TTBCustomItem);
begin
  ReallocMem(AItems, (AItemCount+1) * SizeOf(AItems[0]));
  if NewIndex < AItemCount then
    System.Move(AItems[NewIndex], AItems[NewIndex+1],
      (AItemCount-NewIndex) * SizeOf(AItems[0]));
  AItems[NewIndex].Item := AItem;
  Inc(AItemCount);
end;

procedure DeleteFromItemArray(var AItems: PTBItemDataArray;
  var AItemCount: Integer; Index: Integer);
begin
  Dec(AItemCount);
  if Index < AItemCount then
    System.Move(AItems[Index+1], AItems[Index],
      (AItemCount-Index) * SizeOf(AItems[0]));
  ReallocMem(AItems, AItemCount * SizeOf(AItems[0]));
end;

procedure InsertIntoViewerArray(var AItems: PTBItemViewerArray;
  var AItemCount: Integer; NewIndex: Integer; AItem: TTBItemViewer);
begin
  ReallocMem(AItems, (AItemCount+1) * SizeOf(AItems[0]));
  if NewIndex < AItemCount then
    System.Move(AItems[NewIndex], AItems[NewIndex+1],
      (AItemCount-NewIndex) * SizeOf(AItems[0]));
  AItems[NewIndex] := AItem;
  Inc(AItemCount);
end;

procedure DeleteFromViewerArray(var AItems: PTBItemViewerArray;
  var AItemCount: Integer; Index: Integer);
begin
  Dec(AItemCount);
  if Index < AItemCount then
    System.Move(AItems[Index+1], AItems[Index],
      (AItemCount-Index) * SizeOf(AItems[0]));
  ReallocMem(AItems, AItemCount * SizeOf(AItems[0]));
end;


{ TTBCustomItemActionLink }

procedure TTBCustomItemActionLink.AssignClient(AClient: TObject);
begin
  FClient := AClient as TTBCustomItem;
end;

{$IFDEF JR_D6}
function TTBCustomItemActionLink.IsAutoCheckLinked: Boolean;
begin
  Result := (FClient.AutoCheck = (Action as TCustomAction).AutoCheck);
end;
{$ENDIF}

function TTBCustomItemActionLink.IsCaptionLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and
    (FClient.Caption = (Action as TCustomAction).Caption);
end;

function TTBCustomItemActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCheckedLinked and
    (FClient.Checked = (Action as TCustomAction).Checked);
end;

function TTBCustomItemActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and
    (FClient.Enabled = (Action as TCustomAction).Enabled);
end;

function TTBCustomItemActionLink.IsHelpContextLinked: Boolean;
begin
  Result := inherited IsHelpContextLinked and
    (FClient.HelpContext = (Action as TCustomAction).HelpContext);
end;

function TTBCustomItemActionLink.IsHintLinked: Boolean;
begin
  Result := inherited IsHintLinked and
    (FClient.Hint = (Action as TCustomAction).Hint);
end;

function TTBCustomItemActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and
    (FClient.ImageIndex = (Action as TCustomAction).ImageIndex);
end;

function TTBCustomItemActionLink.IsShortCutLinked: Boolean;
begin
  Result := inherited IsShortCutLinked and
    (FClient.ShortCut = (Action as TCustomAction).ShortCut);
end;

function TTBCustomItemActionLink.IsVisibleLinked: Boolean;
begin
  Result := inherited IsVisibleLinked and
    (FClient.Visible = (Action as TCustomAction).Visible);
end;

function TTBCustomItemActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked and
    MethodsEqual(TMethod(FClient.OnClick), TMethod(Action.OnExecute));
end;

{$IFDEF JR_D6}
procedure TTBCustomItemActionLink.SetAutoCheck(Value: Boolean);
begin
  if IsAutoCheckLinked then FClient.AutoCheck := Value;
end;
{$ENDIF}

procedure TTBCustomItemActionLink.SetCaption(const Value: string);
begin
  if IsCaptionLinked then FClient.Caption := Value;
end;

procedure TTBCustomItemActionLink.SetChecked(Value: Boolean);
begin
  if IsCheckedLinked then FClient.Checked := Value;
end;

procedure TTBCustomItemActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then FClient.Enabled := Value;
end;

procedure TTBCustomItemActionLink.SetHelpContext(Value: THelpContext);
begin
  if IsHelpContextLinked then FClient.HelpContext := Value;
end;

procedure TTBCustomItemActionLink.SetHint(const Value: string);
begin
  if IsHintLinked then FClient.Hint := Value;
end;

procedure TTBCustomItemActionLink.SetImageIndex(Value: Integer);
begin
  if IsImageIndexLinked then FClient.ImageIndex := Value;
end;

procedure TTBCustomItemActionLink.SetShortCut(Value: TShortCut);
begin
  if IsShortCutLinked then FClient.ShortCut := Value;
end;

procedure TTBCustomItemActionLink.SetVisible(Value: Boolean);
begin
  if IsVisibleLinked then FClient.Visible := Value;
end;

procedure TTBCustomItemActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  if IsOnExecuteLinked then FClient.OnClick := Value;
end;


{ TTBCustomItem }

{}function ItemContainingItems(const AItem: TTBCustomItem): TTBCustomItem;
begin
  if Assigned(AItem) and Assigned(AItem.FLinkSubitems) then
    Result := AItem.FLinkSubitems
  else
    Result := AItem;
end;

constructor TTBCustomItem.Create(AOwner: TComponent);
begin
  inherited;
  FEnabled := True;
  FImageIndex := -1;
  FInheritOptions := True;
  FItemStyle := [tbisSelectable, tbisRedrawOnSelChange, tbisRedrawOnMouseOverChange];
  FVisible := True;
  Inc(ThreadItemCount);
end;

destructor TTBCustomItem.Destroy;
var
  I: Integer;
begin
  Destroying;
  if ClickedItem = Self then
    ClickedItem := nil;
  { Changed in 0.33. Moved FParent.Remove call *after* the child items are
    deleted. }
  for I := Count-1 downto 0 do
    Items[I].Free;
  if Assigned(FParent) then
    FParent.Remove(Self);
  FreeMem(FItems);
  FActionLink.Free;
  FActionLink := nil;
  FreeAndNil(FSubMenuImagesChangeLink);
  FreeAndNil(FImagesChangeLink);
  inherited;
  if Assigned(FNotifyList) then begin
    for I := FNotifyList.Count-1 downto 0 do
      Dispose(PItemChangedNotificationData(FNotifyList[I]));
    FNotifyList.Free;
  end;
  FLinkParents.Free;
  Dec(ThreadItemCount);
  if (ThreadItemCount = 0) and (ClickWnd <> 0) then begin
    {$IFDEF JR_D6}Classes.{$ENDIF} DeallocateHWnd(ClickWnd);
    ClickWnd := 0;
  end;
end;

{$IFDEF JR_D6}
function TTBCustomItem.IsAutoCheckStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsAutoCheckLinked;
end;
{$ENDIF}

function TTBCustomItem.IsCaptionStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsCaptionLinked;
end;

function TTBCustomItem.IsCheckedStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsCheckedLinked;
end;

function TTBCustomItem.IsEnabledStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsEnabledLinked;
end;

function TTBCustomItem.IsHintStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsHintLinked;
end;

function TTBCustomItem.IsHelpContextStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsHelpContextLinked;
end;

function TTBCustomItem.IsImageIndexStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsImageIndexLinked;
end;

function TTBCustomItem.IsShortCutStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsShortCutLinked;
end;

function TTBCustomItem.IsVisibleStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsVisibleLinked;
end;

function TTBCustomItem.IsOnClickStored: Boolean;
begin
  Result := (ActionLink = nil) or not FActionLink.IsOnExecuteLinked;
end;

function TTBCustomItem.GetAction: TBasicAction;
begin
  if FActionLink <> nil then
    Result := FActionLink.Action
  else
    Result := nil;
end;

function TTBCustomItem.GetActionLinkClass: TTBCustomItemActionLinkClass;
begin
  Result := TTBCustomItemActionLink;
end;

procedure TTBCustomItem.DoActionChange(Sender: TObject);
begin
  if Sender = Action then ActionChange(Sender, False);
end;

procedure TTBCustomItem.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  if Action is TCustomAction then
    with TCustomAction(Sender) do
    begin
      {$IFDEF JR_D6}
      if not CheckDefaults or (Self.AutoCheck = False) then
        Self.AutoCheck := AutoCheck;
      {$ENDIF}
      if not CheckDefaults or (Self.Caption = '') then
        Self.Caption := Caption;
      if not CheckDefaults or (Self.Checked = False) then
        Self.Checked := Checked;
      if not CheckDefaults or (Self.Enabled = True) then
        Self.Enabled := Enabled;
      if not CheckDefaults or (Self.HelpContext = 0) then
        Self.HelpContext := HelpContext;
      if not CheckDefaults or (Self.Hint = '') then
        Self.Hint := Hint;
      if not CheckDefaults or (Self.ImageIndex = -1) then
        Self.ImageIndex := ImageIndex;
      if not CheckDefaults or (Self.ShortCut = scNone) then
        Self.ShortCut := ShortCut;
      if not CheckDefaults or (Self.Visible = True) then
        Self.Visible := Visible;
      if not CheckDefaults or not Assigned(Self.OnClick) then
        Self.OnClick := OnExecute;
    end;
end;

procedure TTBCustomItem.SetAction(Value: TBasicAction);
begin
  if Value = nil then begin
    FActionLink.Free;
    FActionLink := nil;
  end
  else begin
    if FActionLink = nil then
      FActionLink := GetActionLinkClass.Create(Self);
    FActionLink.Action := Value;
    FActionLink.OnChange := DoActionChange;
    ActionChange(Value, csLoading in Value.ComponentState);
    Value.FreeNotification(Self);
  end;
end;

procedure TTBCustomItem.InitiateAction;
begin
  if FActionLink <> nil then FActionLink.Update;
end;

procedure TTBCustomItem.Loaded;
begin
  inherited;
  if Action <> nil then ActionChange(Action, True);
end;

procedure TTBCustomItem.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
begin
  for I := 0 to FItemCount-1 do
    Proc(FItems[I].Item);
end;

procedure TTBCustomItem.SetChildOrder(Child: TComponent; Order: Integer);
var
  I: Integer;
begin
  I := IndexOf(Child as TTBCustomItem);
  if I <> -1 then
    Move(I, Order);
end;

function TTBCustomItem.HasParent: Boolean;
begin
  Result := True;
end;

function TTBCustomItem.GetParentComponent: TComponent;
begin
  if (FParent <> nil) and (FParent.FParentComponent <> nil) then
    Result := FParent.FParentComponent
  else
    Result := FParent;
end;

procedure TTBCustomItem.SetName(const NewName: TComponentName);
begin
  if Name <> NewName then begin
    inherited;
    if Assigned(FParent) then
      FParent.Notify(FParent, tbicNameChanged, 0, Self);
  end;
end;

procedure TTBCustomItem.SetParentComponent(Value: TComponent);
var
  Intf: ITBItems;
begin
  if FParent <> nil then FParent.Remove(Self);
  if Value <> nil then begin
    if Value is TTBCustomItem then
      TTBCustomItem(Value).Add(Self)
    else if Value.GetInterface(ITBItems, Intf) then
      Intf.GetItems.Add(Self);
  end;
end;

procedure TTBCustomItem.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then begin
    RemoveFromList(FLinkParents, AComponent);
    if AComponent = Action then Action := nil;
    if AComponent = Images then Images := nil;
    if AComponent = SubMenuImages then SubMenuImages := nil;
    if AComponent = LinkSubitems then LinkSubitems := nil;
  end;
end;

procedure TTBCustomItem.IndexError;
begin
  raise ETBItemError.Create(STBToolbarIndexOutOfBounds);
end;

class procedure TTBCustomItem.ClickWndProc(var Message: TMessage);
var
  Item: TTBCustomItem;
begin
  if Message.Msg = WM_TB2K_CLICKITEM then begin
    Item := ClickedItem;
    ClickedItem := nil;
    if Assigned(Item) then
      try
        Item.Click;
      except
        Application.HandleException(Item);
      end;
  end
  else
    with Message do
      Result := DefWindowProc(ClickWnd, Msg, wParam, lParam);
end;

procedure TTBCustomItem.Click;
begin
  ProcessPaintMessages; //Skin Patch
  { Following code based on D6's TMenuItem.Click }
  {$IFDEF JR_D6}
  if (not Assigned(ActionLink) and AutoCheck) or
     (Assigned(ActionLink) and not ActionLink.IsAutoCheckLinked and AutoCheck) then
  {$ELSE}
  if AutoCheck then
  {$ENDIF}
    Checked := not Checked;
  { Following code based on D4's TControl.Click }
  { Call OnClick if assigned and not equal to associated action's OnExecute.
    If associated action's OnExecute assigned then call it, otherwise, call
    OnClick. }
  if Assigned(FOnClick) and (Action <> nil) and
     not MethodsEqual(TMethod(FOnClick), TMethod(Action.OnExecute)) then
    FOnClick(Self)
  else
  if not(csDesigning in ComponentState) and (ActionLink <> nil) then
    ActionLink.Execute {$IFDEF JR_D6}(Self){$ENDIF}
  else
  if Assigned(FOnClick) then
    FOnClick(Self);
end;

function TTBCustomItem.GetItem(Index: Integer): TTBCustomItem;
begin
  if (Index < 0) or (Index >= FItemCount) then IndexError;
  Result := FItems[Index].Item;
end;

procedure TTBCustomItem.Add(AItem: TTBCustomItem);
begin
  Insert(Count, AItem);
end;

procedure TTBCustomItem.Notify(Sender: TTBCustomItem;
  Action: TTBItemChangedAction; Index: Integer; Item: TTBCustomItem);

  procedure RelayToParent(const RelayTo: TTBCustomItem);
  begin
    if (tbisEmbeddedGroup in RelayTo.ItemStyle) and Assigned(RelayTo.Parent) then
      RelayTo.Parent.Notify(RelayTo, Action, Index, Item);
  end;

var
  I: Integer;
  P: TTBCustomItem;
  SaveProc: TTBItemChangedProc;
begin
  if Sender = Self then begin
    { If Self is an embedded item, relay the notification to the parent }
    RelayToParent(Self);
    { If any embedded items are linked to Self, relay the notification to
      those items' parents }
    if Assigned(FLinkParents) then
      for I := 0 to FLinkParents.Count-1 do begin
        P := FLinkParents[I];
        if P <> Parent then
          RelayToParent(P);
      end;
  end;
  if Assigned(FNotifyList) then begin
    I := 0;
    while I < FNotifyList.Count do begin
      with PItemChangedNotificationData(FNotifyList[I])^ do begin
        SaveProc := Proc;
        Proc(Sender, Sender <> Self, Action, Index, Item);
      end;
      { Is I now out of bounds? }
      if I >= FNotifyList.Count then
        Break;
      { Only proceed to the next index if the list didn't change }
      if MethodsEqual(TMethod(PItemChangedNotificationData(FNotifyList[I])^.Proc),
         TMethod(SaveProc)) then
        Inc(I);
    end;
  end;
end;

procedure TTBCustomItem.ViewBeginUpdate;
begin
  Notify(Self, tbicSubitemsBeginUpdate, 0, nil);
end;

procedure TTBCustomItem.ViewEndUpdate;
begin
  Notify(Self, tbicSubitemsEndUpdate, 0, nil);
end;

procedure TTBCustomItem.Insert(NewIndex: Integer; AItem: TTBCustomItem);
begin
  if Assigned(AItem.FParent) then
    raise ETBItemError.Create(STBToolbarItemReinserted);
  if (NewIndex < 0) or (NewIndex > FItemCount) then IndexError;
  InsertIntoItemArray(FItems, FItemCount, NewIndex, AItem);
  AItem.FParent := Self;
  ViewBeginUpdate;
  try
    Notify(Self, tbicInserted, NewIndex, AItem);
    AItem.RefreshOptions;
  finally
    ViewEndUpdate;
  end;
end;

procedure TTBCustomItem.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FItemCount) then IndexError;
  Notify(Self, tbicDeleting, Index, FItems[Index].Item);
  FItems[Index].Item.FParent := nil;
  DeleteFromItemArray(FItems, FItemCount, Index);
end;

function TTBCustomItem.IndexOf(AItem: TTBCustomItem): Integer;
var
  I: Integer;
begin
  for I := 0 to FItemCount-1 do
    if FItems[I].Item = AItem then begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

procedure TTBCustomItem.Remove(Item: TTBCustomItem);
var
  I: Integer;
begin
  I := IndexOf(Item);
  //if I = -1 then raise ETBItemError.Create(STBToolbarItemNotFound);
  if I <> -1 then
    Delete(I);
end;

procedure TTBCustomItem.Clear;
var
  I: Integer;
begin
  for I := Count-1 downto 0 do
    Items[I].Free;
end;

procedure TTBCustomItem.Move(CurIndex, NewIndex: Integer);
var
  Item: TTBCustomItem;
begin
  if CurIndex <> NewIndex then begin
    if (NewIndex < 0) or (NewIndex >= FItemCount) then IndexError;
    Item := Items[CurIndex];
    ViewBeginUpdate;
    try
      Delete(CurIndex);
      Insert(NewIndex, Item);
    finally
      ViewEndUpdate;
    end;
  end;
end;

function TTBCustomItem.ContainsItem(AItem: TTBCustomItem): Boolean;
begin
  while Assigned(AItem) and (AItem <> Self) do
    AItem := AItem.Parent;
  Result := Assigned(AItem);
end;

procedure TTBCustomItem.RegisterNotification(ANotify: TTBItemChangedProc);
var
  I: Integer;
  Data: PItemChangedNotificationData;
begin
  if FNotifyList = nil then FNotifyList := TList.Create;
  for I := 0 to FNotifyList.Count-1 do
    with PItemChangedNotificationData(FNotifyList[I])^ do
      if MethodsEqual(TMethod(ANotify), TMethod(Proc)) then begin
        Inc(RefCount);
        Exit;
      end;
  FNotifyList.Expand;
  New(Data);
  Data.Proc := ANotify;
  Data.RefCount := 1;
  FNotifyList.Add(Data);
end;

procedure TTBCustomItem.UnregisterNotification(ANotify: TTBItemChangedProc);
var
  I: Integer;
  Data: PItemChangedNotificationData;
begin
  if Assigned(FNotifyList) then
    for I := 0 to FNotifyList.Count-1 do begin
      Data := FNotifyList[I];
      if MethodsEqual(TMethod(Data.Proc), TMethod(ANotify)) then begin
        Dec(Data.RefCount);
        if Data.RefCount = 0 then begin
          FNotifyList.Delete(I);
          Dispose(Data);
          if FNotifyList.Count = 0 then begin
            FNotifyList.Free;
            FNotifyList := nil;
          end;
        end;
        Break;
      end;
    end;
end;

function TTBCustomItem.GetPopupWindowClass: TTBPopupWindowClass;
begin
  Result := TTBPopupWindow;
end;

procedure TTBCustomItem.DoPopup(Sender: TTBCustomItem; FromLink: Boolean);
begin
  if Assigned(FOnPopup) then
    FOnPopup(Sender, FromLink);
  if not(tbisCombo in ItemStyle) then
    Click;
end;

var
  PlayedSound: Boolean = False;

function TTBCustomItem.CreatePopup(const ParentView: TTBView;
  const ParentViewer: TTBItemViewer; const PositionAsSubmenu, SelectFirstItem,
  Customizing: Boolean; const APopupPoint: TPoint;
  const Alignment: TTBPopupAlignment): TTBPopupWindow;

  function CountObscured(X, Y, W, H: Integer): Integer;
  var
    I: Integer;
    P: TPoint;
    V: TTBItemViewer;
  begin
    Result := 0;
    if ParentView = nil then
      Exit;
    P := ParentView.FWindow.ClientToScreen(Point(0, 0));
    Dec(X, P.X);
    Dec(Y, P.Y);
    Inc(W, X);
    Inc(H, Y);
    for I := 0 to ParentView.FViewerCount-1 do begin
      V := ParentView.FViewers[I];
      if V.Show and (V.BoundsRect.Left >= X) and (V.BoundsRect.Right <= W) and
         (V.BoundsRect.Top >= Y) and (V.BoundsRect.Bottom <= H) then
        Inc(Result);
    end;
  end;

var
  EventItem, ParentItem: TTBCustomItem;
  Opposite: Boolean;
  ChevronParentView: TTBView;
  X, X2, Y, Y2, W, H: Integer;
  P: TPoint;
  RepeatCalcX: Boolean;
  ParentItemRect: TRect;
  MonitorRect: TRect;
  AnimDir: TTBAnimationDirection;
//Skin Patch Begin
  CSkin: TTBBaseSkin;
  Skinned: Boolean;
 //Skin Patch End
begin
//Skin Patch Begin
  CSkin := Nil;
  PopupPosition := tbpOther;

  If Assigned(ParentView) and Assigned(ParentView.FSkin) and
     not(ParentView.FSkin.SkinType = tbsDisabled) then
    CSkin := ParentView.FSkin
  else if Assigned(FSkin) and not (FSkin.SkinType = tbsDisabled) then
    CSkin := FSkin
  else if not (DefaultSkin.SkinType = tbsDisabled) then
    CSkin := DefaultSkin;

  Skinned := Assigned(CSkin);

  if Skinned then PopupMenuWindowNCSize := CSkin.GetPopupNCSize
  else PopupMenuWindowNCSize := 3;

//Skin Patch End
  EventItem := ItemContainingItems(Self);
  if EventItem <> Self then
    EventItem.DoPopup(Self, True);
  DoPopup(Self, False);

  ChevronParentView := GetChevronParentView;
  if ChevronParentView = nil then
    ParentItem := Self
  else
    ParentItem := ChevronParentView.FParentItem;

  Opposite := Assigned(ParentView) and (vsOppositePopup in ParentView.FState);
  Result := GetPopupWindowClass.CreatePopupWindow(nil, ParentView, ParentItem,
    Customizing);
  try
    if Assigned(ChevronParentView) then begin
      ChevronParentView.FreeNotification(Result.View);
      Result.View.FChevronParentView := ChevronParentView;
      Result.View.FIsToolbar := True;
      Result.View.Style := Result.View.Style +
        (ChevronParentView.Style * [vsAlwaysShowHints]);
      if not Skinned or Skinned and (CSkin.SkinType = tbsDisabled) then
        Result.Color := clBtnFace;
    end;

    { Calculate ParentItemRect, and MonitorRect (the rectangle of the monitor
      that the popup window will be confined to) }
    if Assigned(ParentView) then begin
      ParentView.ValidatePositions;
      ParentItemRect := ParentViewer.BoundsRect;
      P := ParentView.FWindow.ClientToScreen(Point(0, 0));
      OffsetRect(ParentItemRect, P.X, P.Y);
      if not IsRectEmpty(ParentView.FMonitorRect) then
        MonitorRect := ParentView.FMonitorRect
      else
        MonitorRect := GetRectOfMonitorContainingRect(ParentItemRect, False);
    end
    else begin
      ParentItemRect.TopLeft := APopupPoint;
      ParentItemRect.BottomRight := APopupPoint;
      MonitorRect := GetRectOfMonitorContainingPoint(APopupPoint, False);
    end;
    Result.View.FMonitorRect := MonitorRect;

    { Initialize item positions and size of the popup window }
    if ChevronParentView = nil then
      Result.View.FMaxHeight := (MonitorRect.Bottom - MonitorRect.Top) -
        (PopupMenuWindowNCSize * 2)
    else
      Result.View.WrapOffset := (MonitorRect.Right - MonitorRect.Left) -
        (PopupMenuWindowNCSize * 2);
    if SelectFirstItem then
      Result.View.Selected := Result.View.FirstSelectable;
    Result.View.UpdatePositions;
    W := Result.Width;
    H := Result.Height;

    { Calculate initial X,Y position of the popup window }
    if Assigned(ParentView) then begin
      if not PositionAsSubmenu then begin
        if ChevronParentView = nil then begin
          if (ParentView = nil) or (ParentView.FOrientation <> tbvoVertical) then begin
            if GetSystemMetrics(SM_MENUDROPALIGNMENT) = 0 then
              X := ParentItemRect.Left
            else
              X := ParentItemRect.Right - W;
            Y := ParentItemRect.Bottom;
          end
          else begin
            X := ParentItemRect.Left - W;
            Y := ParentItemRect.Top;
          end;
        end
        else begin
          if ChevronParentView.FOrientation <> tbvoVertical then begin
            X := ParentItemRect.Right - W;
            Y := ParentItemRect.Bottom;
          end
          else begin
            X := ParentItemRect.Left - W;
            Y := ParentItemRect.Top;
          end;
        end;
      end
      else begin
        X := ParentItemRect.Right - PopupMenuWindowNCSize;
        Y := ParentItemRect.Top - PopupMenuWindowNCSize;
      end;
    end
    else begin
      X := APopupPoint.X;
      Y := APopupPoint.Y;
      case Alignment of
        tbpaRight: Dec(X, W);
        tbpaCenter: Dec(X, W div 2);
      end;
    end;

    { Adjust the Y position of the popup window }
    { If the window is going off the bottom of the monitor, try placing it
      above the parent item }
    if (Y + H > MonitorRect.Bottom) and
       ((ParentView = nil) or (ParentView.FOrientation <> tbvoVertical)) then begin
      if not PositionAsSubmenu then
        Y2 := ParentItemRect.Top
      else
        Y2 := ParentItemRect.Bottom + PopupMenuWindowNCSize;
      Dec(Y2, H);
      { Only place it above the parent item if it isn't going to go off the
        top of the monitor }
      if Y2 >= MonitorRect.Top then
      begin
        Y := Y2;
        PopupPosition := tbpTop; //Skin Patch
      end;
    end;
    { If it's still going off the bottom (which can be possible if a menu bar
      was off the screen to begin with), clip it to the bottom of the monitor }
    if Y + H > MonitorRect.Bottom then
      Y := MonitorRect.Bottom - H;
    if Y < MonitorRect.Top then
      Y := MonitorRect.Top;

    { Other adjustments to the position of the popup window }
    if not PositionAsSubmenu then begin
      if (ParentView = nil) and (Alignment = tbpaRight) and (X < MonitorRect.Left) then
        Inc(X, W);
      if X + W > MonitorRect.Right then begin
        if Assigned(ParentView) or (Alignment <> tbpaLeft) then
          X := MonitorRect.Right;
        Dec(X, W);
      end;
      if X < MonitorRect.Left then
        X := MonitorRect.Left;
      if (ParentView = nil) or (ParentView.FOrientation <> tbvoVertical) then begin
        Y2 := ParentItemRect.Top - H;
        if Y2 >= MonitorRect.Top then begin
          { Would the popup window obscure less items if it popped out to the
            top instead? }
          if (CountObscured(X, Y2, W, H) < CountObscured(X, Y, W, H)) or
             ((Y < ParentItemRect.Bottom) and (Y + H > ParentItemRect.Top) and
              (X < ParentItemRect.Right) and (X + W > ParentItemRect.Left)) then
          begin
            Y := Y2;
            PopupPosition := tbpTop; //Skin Patch
          end;
        end;
        { Make sure a tall popup window doesn't overlap the parent item }
        if (Y < ParentItemRect.Bottom) and (Y + H > ParentItemRect.Top) and
           (X < ParentItemRect.Right) and (X + W > ParentItemRect.Left) then begin
          if ParentItemRect.Right + W <= MonitorRect.Right then
            X := ParentItemRect.Right
          else
            X := ParentItemRect.Left - W;
          if X < MonitorRect.Top then
            X := MonitorRect.Top;
        end;
      end
      else begin
        X2 := ParentItemRect.Right;
        if X2 + W <= MonitorRect.Right then begin
          { Would the popup window obscure less items if it popped out to the
            right instead? }
          if (CountObscured(X2, Y, W, H) < CountObscured(X, Y, W, H)) or
             ((Y < ParentItemRect.Bottom) and (Y + H > ParentItemRect.Top) and
              (X < ParentItemRect.Right) and (X + W > ParentItemRect.Left)) then
          begin
            X := X2;
            PopupPosition := tbpRight; //Skin Patch
          end;
        end;
        { Make sure a wide popup window doesn't overlap the parent item }
        if (Y < ParentItemRect.Bottom) and (Y + H > ParentItemRect.Top) and
           (X < ParentItemRect.Right) and (X + W > ParentItemRect.Left) then begin
          if ParentItemRect.Bottom + H <= MonitorRect.Bottom then
            Y := ParentItemRect.Bottom
          else
            Y := ParentItemRect.Top - H;
          if Y < MonitorRect.Top then
            Y := MonitorRect.Top;
        end;
      end;
    end
    else begin
      { Make nested submenus go from left to right on the screen. Each it
        runs out of space on the screen, switch directions }
      repeat
        RepeatCalcX := False;
        X2 := X;
        if Opposite or (X2 + W > MonitorRect.Right) then begin
          if Assigned(ParentView) then
            X2 := ParentItemRect.Left + PopupMenuWindowNCSize;
          Dec(X2, W);
          if not Opposite then
            Include(Result.View.FState, vsOppositePopup)
          else begin
            if X2 < MonitorRect.Left then begin
              Opposite := False;
              RepeatCalcX := True;
            end
            else
              Include(Result.View.FState, vsOppositePopup);
          end;
        end;
      until not RepeatCalcX;
      X := X2;
      if X < MonitorRect.Left then
        X := MonitorRect.Left;
    end;

//Skin Patch Begin
    if Assigned(ParentView) then begin
      if not Assigned(ParentView.FSkin) then begin
       if (not (tboPopupOverlap In DefaultSkin.Options)) then begin
        Inc(X, 3); Inc(Y, 2);
       end
      end
     else begin
       if (not (tboPopupOverlap in ParentView.Skin.Options)) and
                   (ParentView.Owner is TTBPopupWindow) and
                   (not Assigned(ParentView.FChevronParentView)) then begin
           Inc(X, 2); Inc(Y, 2);
       end;
     end;
    end;
//Skin Patch End

    { Determine animation direction }
    AnimDir := [];
    if not PositionAsSubmenu then begin
      if Y >= ParentItemRect.Bottom then
        Include(AnimDir, tbadDown)
      else if Y + H <= ParentItemRect.Top then
        Include(AnimDir, tbadUp);
      if X >= ParentItemRect.Right then
        Include(AnimDir, tbadRight)
      else if X + W <= ParentItemRect.Left then
        Include(AnimDir, tbadLeft);
    end
    else begin
      if X + W div 2 >= ParentItemRect.Left + (ParentItemRect.Right - ParentItemRect.Left) div 2 then
        Include(AnimDir, tbadRight)
      else
        Include(AnimDir, tbadLeft);
    end;
//Skin Patch Begin
//Adjust the position of the Popup if it's get called
//from a Toolbar Item

    If Skinned and not (CSkin.SkinType in [tbsWindowsXP, tbsNativeXP]) and
       Assigned(ParentView) and ParentView.FIsToolbar then
     if not (ParentView.FOrientation = tbvoVertical) then
      begin
       If PopupPosition = tbpTop then
        Inc(Y, 2)
       else
        Dec(Y, 2);
      end
     else
      begin
       If PopupPosition = tbpRight then
        Dec(X, 2)
       else
        Inc(X, 2);
      end;
//Skin Patch End
    Result.FAnimationDirection := AnimDir;

    Result.SetBounds(X, Y, W, H);
    if Assigned(ParentView) then begin
      Result.FreeNotification(ParentView);
      ParentView.FOpenViewerWindow := Result;
      ParentView.FOpenViewerView := Result.View;
      ParentView.FOpenViewer := ParentViewer;
      if ParentView.FIsToolbar then begin
        ParentView.Invalidate(ParentViewer);
        ParentView.FWindow.Update;
      end;
    end;
    Include(Result.View.FState, vsDrawInOrder);
    if not NeedToPlaySound('MenuPopup') then begin
      { Don't call PlaySound if we don't have to }
      Result.Visible := True;
    end
    else begin
      if not PlayedSound then begin
        { Work around Windows 2000 "bug" where there's a 1/3 second delay upon the
          first call to PlaySound (or sndPlaySound) by painting the window
          completely first. This way the delay isn't very noticable. }
        PlayedSound := True;
        Result.Visible := True;
        Result.Update;
        PlaySound('MenuPopup', 0, SND_ALIAS or SND_ASYNC or SND_NODEFAULT or SND_NOSTOP);
      end
      else begin
        PlaySound('MenuPopup', 0, SND_ALIAS or SND_ASYNC or SND_NODEFAULT or SND_NOSTOP);
        Result.Visible := True;
      end;
    end;
    CallNotifyWinEvent(EVENT_SYSTEM_MENUPOPUPSTART, Result.View.FWindow.Handle,
      OBJID_CLIENT, CHILDID_SELF);
    { Call NotifyFocusEvent now that the window is visible }
    if Assigned(Result.View.Selected) then
      Result.View.NotifyFocusEvent;
  except
    Result.Free;
    raise;
  end;
end;

procedure TTBCustomItem.OpenPopup(const SelectFirstItem, TrackRightButton: Boolean;
  const PopupPoint: TPoint; const Alignment: TTBPopupAlignment);
var
  ModalHandler: TTBModalHandler;
  DoneActionData: TTBDoneActionData;
  Popup: TTBPopupWindow;
begin
  FillChar(DoneActionData, SizeOf(DoneActionData), 0);
  ModalHandler := TTBModalHandler.Create(0);
  try
    Popup := CreatePopup(nil, nil, False, SelectFirstItem, False, PopupPoint,
      Alignment);
    try
      Include(Popup.View.FState, vsIgnoreFirstMouseUp);
      ModalHandler.Loop(Popup.View, False, False, SelectFirstItem,
        TrackRightButton, DoneActionData);
    finally
      { Remove vsModal state from the root view before any TTBView.Destroy
        methods get called, so that NotifyFocusEvent becomes a no-op }
      Exclude(Popup.View.FState, vsModal);
      Popup.Free;
    end;
  finally
    ModalHandler.Free;
  end;
  ProcessDoneAction(DoneActionData);
end;

procedure TTBCustomItem.Popup(X, Y: Integer; TrackRightButton: Boolean;
  Alignment: TTBPopupAlignment = tbpaLeft);
var
  P: TPoint;
begin
  P.X := X;
  P.Y := Y;
  OpenPopup(False, TrackRightButton, P, Alignment);
end;

function TTBCustomItem.FindItemWithShortCut(AShortCut: TShortCut;
  var ATopmostParent: TTBCustomItem): TTBCustomItem;

  function DoItem(AParentItem: TTBCustomItem; LinkDepth: Integer): TTBCustomItem;
  var
    I: Integer;
    NewParentItem, Item: TTBCustomItem;
  begin
    Result := nil;
    NewParentItem := AParentItem;
    if Assigned(NewParentItem.LinkSubitems) then begin
      NewParentItem := NewParentItem.LinkSubitems;
      Inc(LinkDepth);
      if LinkDepth > 25 then
        Exit;  { prevent infinite link recursion }
    end;
    for I := 0 to NewParentItem.Count-1 do begin
      Item := NewParentItem.Items[I];
      if Item.ShortCut = AShortCut then begin
        Result := Item;
        Exit;
      end;
      Result := DoItem(Item, LinkDepth);
      if Assigned(Result) then begin
        ATopmostParent := Item;
        Exit;
      end;
    end;
  end;

begin
  ATopmostParent := nil;
  Result := DoItem(Self, 0);
end;

function TTBCustomItem.IsShortCut(var Message: TWMKey): Boolean;
var
  ShortCut: TShortCut;
  ShiftState: TShiftState;
  ShortCutItem, TopmostItem, Item, EventItem: TTBCustomItem;
  I: Integer;
label 1;
begin
  Result := False;
  ShiftState := KeyDataToShiftState(Message.KeyData);
  ShortCut := Menus.ShortCut(Message.CharCode, ShiftState);
1:ShortCutItem := FindItemWithShortCut(ShortCut, TopmostItem);
  if Assigned(ShortCutItem) then begin
    { Send OnPopup/OnClick events to ShortCutItem's parents so that they can
      update the Enabled state of ShortCutItem if needed }
    Item := Self;
    repeat
      if not Item.Enabled then
        Exit;
      EventItem := ItemContainingItems(Item);
      if not(csDesigning in ComponentState) then begin
        for I := 0 to EventItem.Count-1 do
          EventItem.Items[I].InitiateAction;
      end;
      if not(tbisEmbeddedGroup in Item.ItemStyle) then begin
        if EventItem <> Item then begin
          try
            EventItem.DoPopup(Item, True);
          except
            Application.HandleException(Self);
          end;
        end;
        try
          Item.DoPopup(Item, False);
        except
          Application.HandleException(Self);
        end;
      end;
      ShortCutItem := Item.FindItemWithShortCut(ShortCut, TopmostItem);
      if ShortCutItem = nil then
        { Can no longer find the shortcut inside TopmostItem. Start over
          because the shortcut might have moved. }
        goto 1;
      Item := TopmostItem;
    until Item = nil;
    if ShortCutItem.Enabled then begin
      try
        ShortCutItem.Click;
      except
        Application.HandleException(Self);
      end;
      Result := True;
    end;
  end;
end;

function TTBCustomItem.GetChevronParentView: TTBView;
begin
  Result := nil;
end;

function TTBCustomItem.GetItemViewerClass(AView: TTBView): TTBItemViewerClass;
begin
  Result := TTBItemViewer;
end;

function TTBCustomItem.NeedToRecreateViewer(AViewer: TTBItemViewer): Boolean;
begin
  Result := False;
end;

function TTBCustomItem.GetShortCutText: String;
var
  P: Integer;
begin
  P := Pos(#9, Caption);
  if P = 0 then begin
    if ShortCut <> 0 then
      Result := ShortCutToText(ShortCut)
    else
      Result := '';
  end
  else
    Result := Copy(Caption, P+1, Maxint);
end;

function TTBCustomItem.GetHintText: String;
var
  Actn: TCustomAction;
begin
  Result := GetShortHint(Hint);
  { Call DoHint and add shortcut text to hint if item is based on an action.
    (Based on code from TControlActionLink.DoShowHint.) }
  if Assigned(ActionLink) and (ActionLink.Action is TCustomAction) then begin
    Actn := TCustomAction(ActionLink.Action);
    if Actn.DoHint(Result) and Application.HintShortCuts and
       (Actn.ShortCut <> scNone) then begin
      if Result <> '' then
        Result := Format('%s (%s)', [Result, ShortCutToText(Actn.ShortCut)]);
    end;
  end;
end;

procedure TTBCustomItem.Change(NeedResize: Boolean);
const
  ItemChangedActions: array[Boolean] of TTBItemChangedAction =
    (tbicInvalidate, tbicInvalidateAndResize);
begin
  if Assigned(FParent) then
    FParent.Notify(FParent, ItemChangedActions[NeedResize], 0, Self);
end;

procedure TTBCustomItem.RecreateItemViewers;
begin
  if Assigned(FParent) then
    FParent.Notify(FParent, tbicRecreateItemViewers, 0, Self);
end;

procedure TTBCustomItem.ImageListChangeHandler(Sender: TObject);
var
  Resize: Boolean;
begin
  if Sender = FSubMenuImages then begin
    FSubMenuImagesChangeLink.FLastWidth := FSubMenuImages.Width;
    FSubMenuImagesChangeLink.FLastHeight := FSubMenuImages.Height;
    SubMenuImagesChanged;
  end
  else begin
    { Sender is FImages }
    Resize := False;
    if (FImagesChangeLink.FLastWidth <> FImages.Width) or
       (FImagesChangeLink.FLastHeight <> FImages.Height) then begin
      FImagesChangeLink.FLastWidth := FImages.Width;
      FImagesChangeLink.FLastHeight := FImages.Height;
      Resize := True;
    end;
    Change(Resize);
  end;
end;

procedure TTBCustomItem.SubMenuImagesChanged;
begin
  Notify(Self, tbicSubMenuImagesChanged, 0, nil);
end;

procedure TTBCustomItem.TurnSiblingsOff;
var
  I: Integer;
  Item: TTBCustomItem;
begin
  if (GroupIndex <> 0) and Assigned(FParent) then begin
    for I := 0 to FParent.Count-1 do begin
      Item := FParent[I];
      if (Item <> Self) and (Item.GroupIndex = GroupIndex) then
        Item.Checked := False;
    end;
  end;
end;

procedure TTBCustomItem.SetCaption(Value: String);
begin
  if FCaption <> Value then begin
    FCaption := Value;
    Change(True);
  end;
end;

procedure TTBCustomItem.SetChecked(Value: Boolean);
begin
  if FChecked <> Value then begin
    FChecked := Value;
    Change(False);
    if Value then
      TurnSiblingsOff;
  end;
end;

procedure TTBCustomItem.SetDisplayMode(Value: TTBItemDisplayMode);
begin
  if FDisplayMode <> Value then begin
    FDisplayMode := Value;
    Change(True);
  end;
end;

procedure TTBCustomItem.EnabledChanged;
begin
  Change(False);
end;

procedure TTBCustomItem.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then begin
    FEnabled := Value;
    EnabledChanged;
  end;
end;

procedure TTBCustomItem.SetGroupIndex(Value: Integer);
begin
  if FGroupIndex <> Value then begin
    FGroupIndex := Value;
    if Checked then
      TurnSiblingsOff;
  end;
end;

procedure TTBCustomItem.SetImageIndex(Value: TImageIndex);
var
  HadNoImage: Boolean;
begin
  if FImageIndex <> Value then begin
    HadNoImage := FImageIndex = -1;
    FImageIndex := Value;
    Change(HadNoImage xor (Value = -1));
  end;
end;

function TTBCustomItem.ChangeImages(var AImages: TCustomImageList;
  const Value: TCustomImageList; var AChangeLink: TTBImageChangeLink): Boolean;
{ Returns True if image list was resized }
var
  LastWidth, LastHeight: Integer;
begin
  Result := False;
  LastWidth := -1;
  LastHeight := -1;
  if Assigned(AImages) then begin
    LastWidth := AImages.Width;
    LastHeight := AImages.Height;
    AImages.UnregisterChanges(AChangeLink);
    if Value = nil then begin
      AChangeLink.Free;
      AChangeLink := nil;
      Result := True;
    end;
  end;
  AImages := Value;
  if Assigned(Value) then begin
    Result := (Value.Width <> LastWidth) or (Value.Height <> LastHeight);
    if AChangeLink = nil then begin
      AChangeLink := TTBImageChangeLink.Create;
      AChangeLink.FLastWidth := Value.Width;
      AChangeLink.FLastHeight := Value.Height;
      AChangeLink.OnChange := ImageListChangeHandler;
    end;
    Value.RegisterChanges(AChangeLink);
    Value.FreeNotification(Self);
  end;
end;

procedure TTBCustomItem.SetImages(Value: TCustomImageList);
begin
  if FImages <> Value then
    Change(ChangeImages(FImages, Value, FImagesChangeLink));
end;

procedure TTBCustomItem.SetSubMenuImages(Value: TCustomImageList);
begin
  if FSubMenuImages <> Value then begin
    ChangeImages(FSubMenuImages, Value, FSubMenuImagesChangeLink);
    SubMenuImagesChanged;
  end;
end;

procedure TTBCustomItem.SetInheritOptions(Value: Boolean);
begin
  if FInheritOptions <> Value then begin
    FInheritOptions := Value;
    RefreshOptions;
  end;
end;

procedure TTBCustomItem.SetLinkSubitems(Value: TTBCustomItem);
begin
  if Value = Self then
    Value := nil;
  if FLinkSubitems <> Value then begin
    if Assigned(FLinkSubitems) then
      RemoveFromList(FLinkSubitems.FLinkParents, Self);
    FLinkSubitems := Value;
    if Assigned(Value) then begin
      Value.FreeNotification(Self);
      AddToList(Value.FLinkParents, Self);
    end;
    Notify(Self, tbicSubitemsChanged, {these are not used:} 0, nil);
  end;
end;

function TTBCustomItem.FixOptions(const AOptions: TTBItemOptions): TTBItemOptions;
begin
  Result := AOptions;
  if not(tboToolbarStyle in Result) then
    Exclude(Result, tboToolbarSize);
end;

procedure TTBCustomItem.RefreshOptions;
const
  NonInheritedOptions = [tboDefault];
  ChangeOptions = [tboDefault, tboDropdownArrow, tboImageAboveCaption,
    tboNoRotation, tboSameWidth, tboToolbarStyle, tboToolbarSize];
var
  OldOptions, NewOptions: TTBItemOptions;
  I: Integer;
  Item: TTBCustomItem;
begin
  OldOptions := FEffectiveOptions;
  if FInheritOptions and Assigned(FParent) then
    NewOptions := FParent.FEffectiveOptions - NonInheritedOptions
  else
    NewOptions := [];
  NewOptions := FixOptions(NewOptions - FMaskOptions + FOptions);
  if FEffectiveOptions <> NewOptions then begin
    FEffectiveOptions := NewOptions;
    if (OldOptions * ChangeOptions) <> (NewOptions * ChangeOptions) then
      Change(True);
    for I := 0 to FItemCount-1 do begin
      Item := FItems[I].Item;
      if Item.FInheritOptions then
        Item.RefreshOptions;
    end;
  end;
end;

procedure TTBCustomItem.SetMaskOptions(Value: TTBItemOptions);
begin
  if FMaskOptions <> Value then begin
    FMaskOptions := Value;
    RefreshOptions;
  end;
end;

procedure TTBCustomItem.SetOptions(Value: TTBItemOptions);
begin
  Value := FixOptions(Value);
  if FOptions <> Value then begin
    FOptions := Value;
    RefreshOptions;
  end;
end;

procedure TTBCustomItem.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then begin
    FVisible := Value;
    Change(True);
  end;
end;


{ TTBGroupItem }

constructor TTBGroupItem.Create(AOwner: TComponent);
begin
  inherited;
  ItemStyle := ItemStyle + [tbisEmbeddedGroup, tbisSubitemsEditable];
end;


{ TTBSubmenuItem }

constructor TTBSubmenuItem.Create(AOwner: TComponent);
begin
  inherited;
  ItemStyle := ItemStyle + [tbisSubMenu, tbisSubitemsEditable];
end;

function TTBSubmenuItem.GetDropdownCombo: Boolean;
begin
  Result := tbisCombo in ItemStyle;
end;

procedure TTBSubmenuItem.SetDropdownCombo(Value: Boolean);
begin
  if (tbisCombo in ItemStyle) <> Value then begin
    if Value then
      ItemStyle := ItemStyle + [tbisCombo]
    else
      ItemStyle := ItemStyle - [tbisCombo];
    Change(True);
  end;
end;


{ TTBSeparatorItem }

constructor TTBSeparatorItem.Create(AOwner: TComponent);
begin
  inherited;
  ItemStyle := ItemStyle - [tbisSelectable, tbisRedrawOnSelChange,
    tbisRedrawOnMouseOverChange] + [tbisSeparator, tbisClicksTransparent];
end;

function TTBSeparatorItem.GetItemViewerClass(AView: TTBView): TTBItemViewerClass;
begin
  Result := TTBSeparatorItemViewer;
end;

procedure TTBSeparatorItem.SetBlank(Value: Boolean);
begin
  if FBlank <> Value then begin
    FBlank := Value;
    Change(False);
  end;
end;


{ TTBSeparatorItemViewer }

procedure TTBSeparatorItemViewer.CalcSize(const Canvas: TCanvas;
  var AWidth, AHeight: Integer);
Var //Skin Patch
  Skinned: Boolean; //Skin Patch
begin
  if not IsToolbarStyle then
  begin
//Skin Patch Begin
   Skinned := (Assigned(FView.FSkin) and not (FView.FSkin.SkinType = tbsDisabled)) or
              not (DefaultSkin.SkinType = tbsDisabled);

    if Skinned then
      AHeight := 3
    else
//Skin Patch End
      Inc(AHeight, DivRoundUp(GetTextHeight(Canvas.Handle) * 2, 3))
  end else begin
    AWidth := 6;
    AHeight := 6;
  end;
end;

procedure TTBSeparatorItemViewer.Paint(const Canvas: TCanvas;
  const ClientAreaRect: TRect; IsSelected, IsPushed, UseDisabledShadow: Boolean);
var
  R: TRect;
  ToolbarStyle, Horiz, LineSep: Boolean;
//Skin Patch Begin
  CSkin: TTBBaseSkin;
  Skinned: Boolean;
  LeftMargin, I: Integer;
//Skin Patch End
begin
//Skin Patch Begin
  If Assigned(FView.FSkin) and not (FView.FSkin.SkinType = tbsDisabled) then
   CSkin := FView.FSkin
  else
    if not (DefaultSkin.SkinType = tbsDisabled) then
     CSkin := DefaultSkin else CSkin := nil;

  Skinned := Assigned(CSkin);
//Skin Patch End
  if TTBSeparatorItem(Item).FBlank then
    Exit;

  R := ClientAreaRect;
  ToolbarStyle := IsToolbarStyle;
  Horiz := not ToolbarStyle or (View.FOrientation = tbvoVertical);
  LineSep := tbisLineSep in State;
  if LineSep then
    Horiz := not Horiz;
  if Horiz then begin
    R.Top := R.Bottom div 2 - 1;
    if not ToolbarStyle then
      InflateRect(R, -tbMenuSeparatorOffset, 0)
    else if LineSep then begin
      if View.FOrientation = tbvoFloating then
        InflateRect(R, -tbLineSepOffset, 0)
      else
        InflateRect(R, -tbDockedLineSepOffset, 0);
    end;
//Skin Patch Begin
    LeftMargin := 0;
    if Skinned then begin
      case CSkin.SkinType of
        tbsNativeXP: begin
                      R := ClientAreaRect;

                      aTheme := OpenThemeData(0, ToolbarThemeName);
                      aPart := Integer(TP_SEPARATORVERT);
                      aState := 0;

                      DrawThemeBackground(aTheme, Canvas.Handle, aPart, aState, R, nil);
                      CloseThemeData(aTheme);
                     end;
       tbsWindowsXP: begin
                      Canvas.Brush.Color := CSkin.Colors.tcSeparator;
                      Canvas.FillRect(Rect(3, 1, ClientAreaRect.Right -3, 2));
                     end;
        tbsOfficeXP: begin
                       If Not FView.IsToolbar Then
                        Begin
                         for i := 0 to FView.FViewerCount -1 do
                          if FView.FViewers[i].FItem.Visible then begin
                           LeftMargin := GetImgListMargin(FView.FViewers[i]) -2;
                           break;
                          end;

                         if CSkin.ImgBackStyle = tbimsDefault then begin
                           Canvas.Brush.Color := CSkin.Colors.tcImageList;
                           Canvas.FillRect(Rect(0, 0, LeftMargin +2, 3));
                         end;

                         Canvas.Brush.Color := CSkin.Colors.tcSeparator;
                         Canvas.FillRect(Rect(LeftMargin +4, 1, ClientAreaRect.Right, 2));
                        End
                       Else
                        Begin
                         Canvas.Brush.Color := CSkin.Colors.tcSeparator;
                         Canvas.FillRect(Rect(0, 1, ClientAreaRect.Right, 2));
                        End;
                       end;
      end;
    end //Skin Patch End
    else DrawEdge(Canvas.Handle, R, EDGE_ETCHED, BF_TOP);
  end
  else begin
    R.Left := R.Right div 2 - 1;
    if LineSep then
      InflateRect(R, 0, -tbDockedLineSepOffset);
//Skin Patch Begin
    if Skinned then
      case CSkin.SkinType of
        tbsNativeXP: begin
                      R := ClientAreaRect;

                      aTheme := OpenThemeData(0, ToolbarThemeName);
                      aPart := Integer(TP_SEPARATOR);
                      aState := 0;

                      DrawThemeBackground(aTheme, Canvas.Handle, aPart, aState, R, nil);
                      CloseThemeData(aTheme);
                     end;
                else begin
                      Canvas.Brush.Color := CSkin.Colors.tcSeparator;
                      Canvas.FillRect(Rect(2, 0, 3, R.Bottom));
                     end;
      end
    else //Skin Patch End
     DrawEdge(Canvas.Handle, R, EDGE_ETCHED, BF_LEFT);
  end;
end;

function TTBSeparatorItemViewer.UsesSameWidth: Boolean;
begin
  Result := False;
end;


{ TTBControlItem }

constructor TTBControlItem.Create(AOwner: TComponent);
begin
  inherited;
  ItemStyle := ItemStyle - [tbisSelectable] + [tbisClicksTransparent];
end;

constructor TTBControlItem.CreateControlItem(AOwner: TComponent;
  AControl: TControl);
begin
  FControl := AControl;
  AControl.FreeNotification(Self);
  Create(AOwner);
end;

destructor TTBControlItem.Destroy;
begin
  inherited;
  { Free the associated control *after* the item is completely destroyed }
  if not FDontFreeControl and Assigned(FControl) and
     not(csAncestor in FControl.ComponentState) then
    FControl.Free;
end;

procedure TTBControlItem.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FControl) then
    Control := nil;
end;

procedure TTBControlItem.SetControl(Value: TControl);
begin
  if FControl <> Value then begin
    FControl := Value;
    if Assigned(Value) then
      Value.FreeNotification(Self);
    Change(True);
  end;
end;


{ TTBItemViewer }

constructor TTBItemViewer.Create(AView: TTBView; AItem: TTBCustomItem);
begin
  FItem := AItem;
  FView := AView;
end;

destructor TTBItemViewer.Destroy;
begin
  if Assigned(FAccObjectInstance) then begin
    FAccObjectInstance.ClientIsDestroying;
    FAccObjectInstance := nil;
  end;
  inherited;
end;

function TTBItemViewer.GetAccObject: IDispatch;
begin
  if FAccObjectInstance = nil then begin
    if not InitializeOleAcc then begin
      Result := nil;
      Exit;
    end;
    FAccObjectInstance := TTBItemViewerAccObject.Create(Self);
  end;
  Result := FAccObjectInstance;
end;

function TTBItemViewer.GetCaptionText: String;
var
  P: Integer;
begin
  Result := Item.Caption;
  P := Pos(#9, Result);
  if P <> 0 then
    SetLength(Result, P-1);
end;

function TTBItemViewer.CaptionShown: Boolean;
begin
  Result := (GetCaptionText <> '') and (not IsToolbarSize or
    (Item.ImageIndex < 0) or (Item.DisplayMode in [nbdmTextOnly, nbdmImageAndText])) or
    (tboImageAboveCaption in Item.EffectiveOptions);
end;

function TTBItemViewer.ImageShown: Boolean;
begin
  {}{should also return false if Images=nil (use UsedImageList?)}
  ImageShown := (Item.ImageIndex >= 0) and
    ((Item.DisplayMode in [nbdmDefault, nbdmImageAndText]) or
     (IsToolbarStyle and (Item.DisplayMode = nbdmTextOnlyInMenus)));
end;

function TTBItemViewer.GetImageList: TCustomImageList;
var
  V: TTBView;
begin
  Result := Item.Images;
  if Assigned(Result) then
    Exit;
  V := View;
  repeat
    if Assigned(V.FCurParentItem) then begin
      Result := V.FCurParentItem.SubMenuImages;
      if Assigned(Result) then
        Break;
    end;
    if Assigned(V.FParentItem) then begin
      Result := V.FParentItem.SubMenuImages;
      if Assigned(Result) then
        Break;
    end;
    V := V.FParentView;
  until V = nil;
end;

function TTBItemViewer.IsRotated: Boolean;
{ Returns True if the caption should be drawn with rotated (vertical) text,
  underneath the image }
begin
  Result := (View.Orientation = tbvoVertical) and
    not (tboNoRotation in Item.EffectiveOptions) and
    not (tboImageAboveCaption in Item.EffectiveOptions);
end;

procedure TTBItemViewer.CalcSize(const Canvas: TCanvas;
  var AWidth, AHeight: Integer);
var
  ToolbarStyle: Boolean;
  DC: HDC;
  TextMetrics: TTextMetric;
  H, LeftMargin: Integer;
  ImgList: TCustomImageList;
  S: String;
  RotatedFont, SaveFont: HFONT;
//Skin Patch Begin
  CSkin: TTBBaseSkin;
  Skinned: Boolean;
//Skin Patch End;
begin
  ToolbarStyle := IsToolbarStyle;
  DC := Canvas.Handle;
  ImgList := GetImageList;
//Skin Patch Begin
  If Assigned(FView.FSkin) and (FView.FSkin.SkinType = tbsOfficeXP) then
    CSkin := FView.FSkin
  else
    if (DefaultSkin.SkinType = tbsOfficeXP) then
     CSkin := DefaultSkin else CSkin := nil;

  Skinned := Assigned(CSkin);
//Skin Patch End;
  if ToolbarStyle then begin
    AWidth := 6;
    AHeight := 6;

//Skin Patch Begin
//Determinate if it's menubar and dec it's height by 2
    if Skinned and
       Assigned(FView.FWindow) and
       (FView.FWindow is TTBCustomToolbar) and
       TTBCustomToolbar(FView.FWindow).MenuBar then
     Dec(AHeight, 2);
//Skin Patch End
  end
  else begin
    AWidth := 0;
    AHeight := 0;
  end;
  if not ToolbarStyle or CaptionShown then begin
    if not IsRotated then begin
      GetTextMetrics(DC, TextMetrics);
      Inc(AHeight, TextMetrics.tmHeight);
      Inc(AWidth, GetTextWidth(DC, GetCaptionText, True));
      if ToolbarStyle then
        Inc(AWidth, 6);
//Skin Patch Begin
      if Skinned then
        Inc(AHeight, 3);
//Skin Patch End
    end
    else begin
      { Vertical text isn't always the same size as horizontal text, so we have
        to select the rotated font into the DC to get an accurate size }
      RotatedFont := CreateRotatedFont(DC);
      SaveFont := SelectObject(DC, RotatedFont);
      GetTextMetrics(DC, TextMetrics);
      Inc(AWidth, TextMetrics.tmHeight);
      Inc(AHeight, GetTextWidth(DC, GetCaptionText, True));
      if ToolbarStyle then
        Inc(AHeight, 6);
      SelectObject(DC, SaveFont);
      DeleteObject(RotatedFont);
    end;
  end;
  if ToolbarStyle and ImageShown and Assigned(ImgList) then begin
    if not IsRotated and not(tboImageAboveCaption in Item.EffectiveOptions) then begin
      Inc(AWidth, ImgList.Width + 1);
      if AHeight < ImgList.Height + 6 then
        AHeight := ImgList.Height + 6;
    end
    else begin
      Inc(AHeight, ImgList.Height);
      if AWidth < ImgList.Width + 7 then
        AWidth := ImgList.Width + 7;
    end;
  end;
  if ToolbarStyle and (tbisSubmenu in Item.ItemStyle) then begin
    if tbisCombo in Item.ItemStyle then
      Inc(AWidth, tbDropdownComboArrowWidth)
    else
    if tboDropdownArrow in Item.EffectiveOptions then begin
      if View.Orientation <> tbvoVertical then
        Inc(AWidth, tbDropdownArrowWidth)
      else
        Inc(AHeight, tbDropdownArrowWidth);
    end;
  end;
  if not ToolbarStyle then begin
    Inc(AHeight, TextMetrics.tmExternalLeading + tbMenuVerticalMargin);
//Skin Patch Begin
    if Skinned then
     Inc(AHeight, 2);
//Skin Patch End
    if Assigned(ImgList) then begin
      H := ImgList.Height + 3;
      if H > AHeight then
        AHeight := H;
      LeftMargin := MulDiv(ImgList.Width + 3, AHeight, H);
    end
    else
      LeftMargin := AHeight;
    Inc(AWidth, LeftMargin + tbMenuImageTextSpace + tbMenuLeftTextMargin +
      tbMenuRightTextMargin);
    S := Item.GetShortCutText;
    if S <> '' then
      Inc(AWidth, (AHeight - 6) + GetTextWidth(DC, S, True));
    Inc(AWidth, AHeight);
  end;
end;

procedure TTBItemViewer.DrawItemCaption(const Canvas: TCanvas; ARect: TRect;
  const ACaption: String; ADrawDisabledShadow: Boolean; AFormat: UINT;
  const Disabled3D: Boolean);
var
  DC: HDC;

  procedure Draw;
  begin
    if not IsRotated then
      DrawText(DC, PChar(ACaption), Length(ACaption), ARect, AFormat)
    else
      DrawRotatedText(DC, ACaption, ARect, AFormat);
  end;

var
  ShadowColor, HighlightColor, SaveTextColor: DWORD;
//Skin Patch Begin
  CSkin: TTBBaseSkin;
  Skinned: Boolean;
//Skin Patch End
begin
  DC := Canvas.Handle;

//Skin Patch Begin
  If (Assigned(FView.FSkin) and not (FView.FSkin.SkinType = tbsDisabled)) then
   CSkin := FView.FSkin
  else if Assigned(DefaultSkin) and not (DefaultSkin.SkinType = tbsDisabled) then
   CSkin := DefaultSkin else CSkin := Nil;

  Skinned := Assigned(CSkin);
//Skin Patch End
  if not ADrawDisabledShadow then
    Draw
  else begin
//Skin Patch Begin
    If Skinned and not Disabled3D then begin //Disabled item painting
      ShadowColor := GetSysColor(COLOR_BTNSHADOW);
      HighlightColor := GetSysColor(COLOR_BTNHIGHLIGHT);
      SaveTextColor := SetTextColor(DC, HighlightColor);
      SetTextColor(DC, ShadowColor);
      Draw;
      SetTextColor(DC, SaveTextColor);
    end else begin
//Skin Patch End
      ShadowColor := GetSysColor(COLOR_BTNSHADOW);
      HighlightColor := GetSysColor(COLOR_BTNHIGHLIGHT);
      OffsetRect(ARect, 1, 1);
      SaveTextColor := SetTextColor(DC, HighlightColor);
      Draw;
      OffsetRect(ARect, -1, -1);
      SetTextColor(DC, ShadowColor);
      Draw;
      SetTextColor(DC, SaveTextColor);
    end; //Skin Patch
  end;
end;

procedure TTBItemViewer.Paint(const Canvas: TCanvas;
  const ClientAreaRect: TRect; IsSelected, IsPushed, UseDisabledShadow: Boolean);
var
  ShowEnabled, HasArrow: Boolean;
  MenuCheckWidth, MenuCheckHeight: Integer;
  CSkin: TTBBaseSkin; //Skin Patch
  Skinned: Boolean; //Skin Patch

  function GetDrawTextFlags: UINT;
  begin
    Result := 0;
    if not AreKeyboardCuesEnabled and (vsUseHiddenAccels in View.FStyle) and
       not(vsShowAccels in View.FState) then
      Result := DT_HIDEPREFIX;
  end;

  procedure DrawSubmenuArrow;
  var
    BR: TRect;
    Bmp: TBitmap;

    procedure DrawWithColor(AColor: TColor);
    const
      ROP_DSPDxax = $00E20746;
    var
      DC: HDC;
      SaveTextColor, SaveBkColor: TColorRef;
    begin
      Canvas.Brush.Color := AColor;
      DC := Canvas.Handle;
      SaveTextColor := SetTextColor(DC, clWhite);
      SaveBkColor := SetBkColor(DC, clBlack);
      BitBlt(DC, BR.Left, BR.Top, MenuCheckWidth, MenuCheckHeight,
        Bmp.Canvas.Handle, 0, 0, ROP_DSPDxax);
      SetBkColor(DC, SaveBkColor);
      SetTextColor(DC, SaveTextColor);
      Canvas.Brush.Style := bsClear;
    end;

  begin
    Bmp := TBitmap.Create;
    try
      Bmp.Monochrome := True;
      Bmp.Width := MenuCheckWidth;
      Bmp.Height := MenuCheckHeight;
      BR := Rect(0, 0, MenuCheckWidth, MenuCheckHeight);
      DrawFrameControl(Bmp.Canvas.Handle, BR, DFC_MENU, DFCS_MENUARROW);
      OffsetRect(BR, ClientAreaRect.Right - MenuCheckWidth,
        ClientAreaRect.Top + ((ClientAreaRect.Bottom - ClientAreaRect.Top) - MenuCheckHeight) div 2);
      if not UseDisabledShadow then begin
        if ShowEnabled and (tbisCombo in Item.ItemStyle) and IsSelected then begin
          OffsetRect(BR, 1, 1);
          DrawWithColor(clBtnText);
        end
        else
          DrawWithColor(Canvas.Font.Color);
      end
      else begin
        OffsetRect(BR, 1, 1);
        DrawWithColor(clBtnHighlight);
        OffsetRect(BR, -1, -1);
        DrawWithColor(clBtnShadow);
      end;
    finally
      Bmp.Free;
    end;
  end;

  procedure DrawDropdownArrow(R: TRect; Rotated: Boolean);

    procedure DrawWithColor(AColor: TColor);
    var
      X, Y: Integer;
      P: array[0..2] of TPoint;
    begin
      X := (R.Left + R.Right) div 2;
      Y := (R.Top + R.Bottom) div 2;
      if not Rotated then begin
        Dec(Y);
        P[0].X := X-2;
        P[0].Y := Y;
        P[1].X := X+2;
        P[1].Y := Y;
        P[2].X := X;
        P[2].Y := Y+2;
      end
      else begin
        Dec(X);
        P[0].X := X;
        P[0].Y := Y+2;
        P[1].X := X;
        P[1].Y := Y-2;
        P[2].X := X-2;
        P[2].Y := Y;
      end;
      Canvas.Pen.Color := AColor;
      Canvas.Brush.Color := AColor;
      Canvas.Polygon(P);
    end;

  begin
    if not UseDisabledShadow then
      DrawWithColor(Canvas.Font.Color)
    else begin
      OffsetRect(R, 1, 1);
      DrawWithColor(clBtnHighlight);
      OffsetRect(R, -1, -1);
      DrawWithColor(clBtnShadow);
    end;
  end;

  function GetDitherBitmap: TBitmap;
  begin
    Result := AllocPatternBitmap(clBtnFace, clBtnHighlight);
    Result.HandleType := bmDDB;  { needed for Win95, or else brush is solid white }
  end;

const
//Skin Patch Begin
  BorderColors: array[0..1] of TColor = (clBtnHighlight, clBtnShadow);
//Skin Patch End
  EdgeStyles: array[Boolean] of UINT = (BDR_RAISEDINNER, BDR_SUNKENOUTER);
  CheckMarkPoints: array[0..11] of TPoint = (
    { Black }
    (X: -2; Y: -2), (X: 0; Y:  0), (X:  4; Y: -4),
    (X:  4; Y: -3), (X: 0; Y:  1), (X: -2; Y: -1),
    (X: -2; Y: -2),
    { White }
    (X: -3; Y: -2), (X: -3; Y: -1), (X: 0; Y: 2),
    (X:  5; Y: -3), (X:  5; Y: -5));
var
  ToolbarStyle, ImageIsShown: Boolean;
  R, RC, RD: TRect;
  S: String;
  ImgList: TCustomImageList;
  I, X, Y: Integer;
  Points: array[0..11] of TPoint;
  DrawTextFlags: UINT;
  LeftMargin: Integer;
  TextMetrics: TTextMetric;

//Skin Patch Begin
  ImgBitmap: TBitmap;
  SkinMargin,
  HoverMargin: Integer;
  IsPopupOpen,
  IsChevronPopup: Boolean;
  HotImgList: TCustomImageList;
//Skin Patch End;
begin
//Skin Patch Begin
  If Assigned(FView.FSkin) and not (FView.FSkin.SkinType = tbsDisabled) then
    CSkin := FView.FSkin
  else
    if not (DefaultSkin.SkinType = tbsDisabled) then
     CSkin := DefaultSkin else CSkin := nil;

  Skinned := Assigned(CSkin);

  IsChevronPopup := Assigned(FView.FChevronParentView) and
                    (tbisSubmenu in FItem.FItemStyle);
  IsPopupOpen := IsPushed and not (FView.FOpenViewer = Nil);
//Skin Patch End
  ToolbarStyle := IsToolbarStyle;
  ShowEnabled := Item.Enabled or View.Customizing;
  HasArrow := (tbisSubmenu in Item.ItemStyle) and
    ((tbisCombo in Item.ItemStyle) or (tboDropdownArrow in Item.EffectiveOptions));
  MenuCheckWidth := GetSystemMetrics(SM_CXMENUCHECK);
  MenuCheckHeight := GetSystemMetrics(SM_CYMENUCHECK);
  ImgList := GetImageList;
  ImageIsShown := ImageShown and Assigned(ImgList);
  LeftMargin := 0;
  if not ToolbarStyle then begin
    if Assigned(ImgList) then
      LeftMargin := MulDiv(ImgList.Width + 3, ClientAreaRect.Bottom, ImgList.Height + 3)
    else
      LeftMargin := ClientAreaRect.Bottom;
  end;
  Inc(LeftMargin, 2); //Skin Patch
  { Border }
  RC := ClientAreaRect;
  if ToolbarStyle then begin
    if HasArrow then begin
      if tbisCombo in Item.ItemStyle then begin
        Dec(RC.Right, tbDropdownComboMargin);
        RD := RC;
        Dec(RC.Right, tbDropdownComboArrowWidth - tbDropdownComboMargin);
        RD.Left := RC.Right;
      end
      else begin
        if View.Orientation <> tbvoVertical then
          RD := Rect(RC.Right - tbDropdownArrowWidth - tbDropdownArrowMargin, 0,
            RC.Right - tbDropdownArrowMargin, RC.Bottom)
        else
          RD := Rect(0, RC.Bottom - tbDropdownArrowWidth - tbDropdownArrowMargin,
            RC.Right, RC.Bottom - tbDropdownArrowMargin);
      end;
    end
    else
      SetRectEmpty(RD);
    if (IsSelected and (ShowEnabled or
//Skin Patch Begin
        (Skinned and not (CSkin.SkinType = tbsOfficeXP)) or
        (Skinned and (CSkin.SkinType = tbsOfficeXP) and not FView.FMouseOverSelected))) or
//Skin Patch End
        Item.Checked or (csDesigning in Item.ComponentState) then begin
      if not(tbisCombo in Item.ItemStyle) then
//Skin Patch Begin
       if Skinned then
         case CSkin.SkinType of
            tbsNativeXP: begin
                          if (FView.FWindow is TTBCustomToolbar) and
                             TTBCustomToolbar(FView.FWindow).MenuBar then begin
                             Canvas.Brush.Color := CSkin.Colors.tcSelItem;
                             Canvas.FillRect(RC);
                          end
                          else begin
                            aTheme := OpenThemeData(0, ToolbarThemeName);
                            aPart := Integer(ToolbarPart(TP_BUTTON));

                            If Not Item.Enabled Then
                             aState := Integer(ToolbarState(TS_DISABLED))
                            Else
                             If Item.Checked Then
                              Begin
                               If IsSelected Then
                                aState := Integer(ToolbarState(TS_HOTCHECKED))
                               Else
                                aState := Integer(ToolbarState(TS_CHECKED));
                              End
                             Else
                              If IsPushed Then
                               aState := Integer(ToolbarState(TS_PRESSED))
                              Else
                               If IsSelected Then
                                aState := Integer(ToolbarState(TS_HOT))
                               Else
                                aState := Integer(ToolbarState(TS_NORMAL));

                            DrawThemeBackground(aTheme, Canvas.Handle, aPart, aState, RC, nil);
                            CloseThemeData(aTheme);
                          end;
                         end;
           tbsWindowsXP: begin
                           if (FView.FWindow is TTBCustomToolbar) and
                              TTBCustomToolbar(FView.FWindow).MenuBar then begin
                             Canvas.Brush.Color := CSkin.Colors.tcSelItem;
                             Canvas.FillRect(RC);
                           end
                           else if Item.Enabled then begin
                             if Item.Checked and not IsPushed then
                              Canvas.Brush.Color := CSkin.Colors.tcChecked
                             else
                              Canvas.Brush.Color := CSkin.Colors.tcSelBar;

                             Canvas.Pen.Color := CSkin.Colors.tcSelBarBorder;
                             Canvas.RoundRect(RC.Left, RC.Top, RC.Right, RC.Bottom, 6, 6);
                           end;
                         end;
            tbsOfficeXP: begin
                           if IsPopupOpen and
                               (tbisSubmenu in Item.ItemStyle) then
                             if (not Item.Enabled and not FView.FMouseOverSelected) then
                               Canvas.Brush.Color := CSkin.Colors.tcSelBar
                             else
                               Canvas.Brush.Color := CSkin.Colors.tcImageList
                           else if (IsPushed or Item.Checked) then
                             if not IsPushed then
                               Canvas.Brush.Color := CSkin.Colors.tcCheckedOver
                             else
                               Canvas.Brush.Color := CSkin.Colors.tcSelPushed
                           else
                             Canvas.Brush.Color := CSkin.Colors.tcSelBar;

                           Canvas.FillRect(RC);

                           if (tbisSubMenu in Item.ItemStyle) then
                            If IsPopupOpen then
                             if (not Item.Enabled and not FView.FMouseOverSelected) then
                               Canvas.Brush.Color := CSkin.Colors.tcSelBarBorder
                             else
                               Canvas.Brush.Color := CSkin.Colors.tcBorder
                            else
                             If IsChevronPopup then
                              Canvas.Brush.Color := CSkin.Colors.tcBorder
                             else
                              Canvas.Brush.Color := CSkin.Colors.tcSelBarBorder
                           else
                            Canvas.Brush.Color := CSkin.Colors.tcSelBarBorder;

                           Canvas.FrameRect(RC);
                         end;
         end
//Skin Patch End
         else DrawEdge(Canvas.Handle, RC, EdgeStyles[IsPushed or Item.Checked], BF_RECT)
      else begin
//Skin Patch Begin
       if Skinned then begin
         case CSkin.SkinType Of
           tbsOfficeXP: begin
                         if IsPopupOpen and (tbisCombo in Item.ItemStyle) then
                           if (not Item.Enabled and not FView.FMouseOverSelected) then
                             Canvas.Brush.Color := CSkin.Colors.tcSelBar
                           else
                             Canvas.Brush.Color := CSkin.Colors.tcImageList
                         else if (IsPushed or Item.Checked) then
                            Canvas.Brush.Color := CSkin.Colors.tcSelPushed
                          else
                            Canvas.Brush.Color := CSkin.Colors.tcSelBar;

                         Canvas.FillRect(RC);

                         If IsPopupOpen then
                           if (not Item.Enabled and not FView.FMouseOverSelected) then
                             Canvas.Brush.Color := CSkin.Colors.tcSelBarBorder
                           else begin
                             Canvas.Brush.Color := CSkin.Colors.tcBorder;
                             Inc(RC.Right); //Not show the right border when it's open
                           end
                         else
                          If IsChevronPopup then
                           Canvas.Brush.Color := CSkin.Colors.tcBorder
                          else
                           Canvas.Brush.Color := CSkin.Colors.tcSelBarBorder;

                         Canvas.FrameRect(RC);
                        end;
          tbsWindowsXP: begin
                         if (FView.FWindow is TTBCustomToolbar) and
                            TTBCustomToolbar(FView.FWindow).MenuBar then begin
                           if (IsPushed or Item.Checked) then
                            Canvas.Brush.Color := CSkin.Colors.tcSelPushed
                           else
                            Canvas.Brush.Color := CSkin.Colors.tcSelItem;

                           Canvas.FillRect(RC);
                         end
                         else begin
                           if Item.Checked and not IsPushed then
                            Canvas.Brush.Color := CSkin.Colors.tcChecked
                           else
                            Canvas.Brush.Color := CSkin.Colors.tcSelBar;

                           Canvas.Pen.Color := CSkin.Colors.tcSelBarBorder;
                           Canvas.RoundRect(RC.Left, RC.Top, RC.Right, RC.Bottom, 6, 6);
                         end;
                        end;
           tbsNativeXP: begin
                         aTheme := OpenThemeData(0, ToolbarThemeName);
                         aPart := Integer(ToolbarPart(TP_SPLITBUTTON));

                         If Not Item.Enabled Then
                          aState := Integer(ToolbarState(TS_DISABLED))
                         Else
                          If Item.Checked Then
                           Begin
                            If IsSelected Then
                             aState := Integer(ToolbarState(TS_HOTCHECKED))
                            Else
                             aState := Integer(ToolbarState(TS_CHECKED));
                           End
                          Else
                           If IsPushed and View.FCapture Then
                            aState := Integer(ToolbarState(TS_PRESSED))
                           Else
                            If IsSelected Then
                             aState := Integer(ToolbarState(TS_HOT))
                            Else
                             aState := Integer(ToolbarState(TS_NORMAL));

                          DrawThemeBackground(aTheme, Canvas.Handle, aPart, aState, RC, nil);
                          CloseThemeData(aTheme);
                        end;
         end;
       end
//Skin Patch End
       else
        DrawEdge(Canvas.Handle, RC, EdgeStyles[(IsPushed and View.FCapture) or Item.Checked], BF_RECT);

        if (IsSelected and (ShowEnabled or not FView.FMouseOverSelected)) or //Skin Patch
           (csDesigning in Item.ComponentState) then
//Skin Patch Begin
         if Skinned then begin
           case CSkin.SkinType Of
             tbsOfficeXP: begin
                           if IsPopupOpen and (tbisCombo in Item.ItemStyle) then
                              if (not Item.Enabled and not FView.FMouseOverSelected) then
                                Canvas.Brush.Color := CSkin.Colors.tcSelBar
                              else
                                Canvas.Brush.Color := CSkin.Colors.tcImageList
                            else
                               Canvas.Brush.Color := CSkin.Colors.tcSelBar;

                            Canvas.FillRect(RD);

                            Dec(RD.Left);
                            Inc(RD.Right);

                            If IsPopupOpen then
                              if (not Item.Enabled and not FView.FMouseOverSelected) then
                                Canvas.Brush.Color := CSkin.Colors.tcSelBarBorder
                              else
                                Canvas.Brush.Color := CSkin.Colors.tcBorder
                            else
                             If IsChevronPopup then
                              Canvas.Brush.Color := CSkin.Colors.tcBorder
                             else
                              Canvas.Brush.Color := CSkin.Colors.tcSelBarBorder;

                            Canvas.FrameRect(RD);

                            //We "erase" the left line of the Frame when the popup opens
                            If IsPopupOpen then begin
                               Canvas.Pen.Color := CSkin.Colors.tcImageList;
                               Canvas.Polyline([Point(RD.Left, RD.Top +1), Point(RD.Left, RD.Bottom -1)]);
                            end;
                          end;
            tbsWindowsXP: if (FView.FWindow is TTBCustomToolbar) and
                             TTBCustomToolbar(FView.FWindow).MenuBar then begin
                            Canvas.Brush.Color := CSkin.Colors.tcSelItem;
                            Canvas.FillRect(RD);
                          end
                          else begin
                            if Item.Checked and not IsPushed then
                             Canvas.Brush.Color := CSkin.Colors.tcChecked
                            else
                             Canvas.Brush.Color := CSkin.Colors.tcSelBar;

                            Canvas.Pen.Color := CSkin.Colors.tcSelBarBorder;
                            Canvas.RoundRect(RD.Left -2, RD.Top, RD.Right +2, RD.Bottom, 6, 6);
                          end;
           end;
         end
//Skin Patch End
         else
          DrawEdge(Canvas.Handle, RD, EdgeStyles[IsPushed and not View.FCapture], BF_RECT);
      end;
    end;
    if HasArrow then begin
     if not Skinned then //Skin Patch
      if not(tbisCombo in Item.ItemStyle) and IsPushed then
        OffsetRect(RD, 1, 1);
//Skin Patch Begin
      if Skinned and (CSkin.SkinType = tbsNativeXP) and
        (tbisCombo in Item.ItemStyle) then begin
        Inc(RD.Right, 2);

        aTheme := OpenThemeData(0, ToolbarThemeName);
        aPart := Integer(ToolbarPart(TP_SPLITBUTTONDROPDOWN));

        If Not Item.Enabled Then
         aState := Integer(ToolbarState(TS_DISABLED))
        Else
         If Item.Checked Then
          Begin
           If IsSelected Then
            aState := Integer(ToolbarState(TS_HOTCHECKED))
           Else
            aState := Integer(ToolbarState(TS_CHECKED));
          End
         Else
          If IsPushed Then
           aState := Integer(ToolbarState(TS_PRESSED))
          Else
           If IsSelected Then
            aState := Integer(ToolbarState(TS_HOT))
           Else
            aState := Integer(ToolbarState(TS_NORMAL));

        DrawThemeBackground(aTheme, Canvas.Handle, aPart, aState, RD, nil);
        CloseThemeData(aTheme);

        Dec(RD.Right, 2);
        end
      else
//Skin Patch End;
      DrawDropdownArrow(RD, not(tbisCombo in Item.ItemStyle) and
        (View.Orientation = tbvoVertical));
    end;
    InflateRect(RC, -1, -1);
    if Item.Checked and not (IsSelected and ShowEnabled) then begin
      If Skinned then //Skin Patch
        Canvas.Brush.Color := CSkin.Colors.tcChecked //Skin Patch
      else Canvas.Brush.Bitmap := GetDitherBitmap;
        If (not skinned) or (Skinned and not (CSkin.SkinType in [tbsWindowsXP, tbsNativeXP])) then //Skin Patch
          Canvas.FillRect(RC);
      Canvas.Brush.Style := bsClear;
    end;
    InflateRect(RC, -1, -1);

    if not Skinned then //Skin Patch
     if Item.Checked or
        ((IsSelected and IsPushed) and
         (not(tbisCombo in Item.ItemStyle) or View.FCapture)) then
       OffsetRect(RC, 1, 1);

    if HasArrow and not(tbisCombo in Item.ItemStyle) then begin
      if View.Orientation <> tbvoVertical then
        Dec(RC.Right, tbDropdownArrowWidth)
      else
        Dec(RC.Bottom, tbDropdownArrowWidth);
    end;
  end
  else begin
    { On selected menu items, fill the background with the selected color.
      Note: This assumes the brush color was not changed from the initial
      value. }
    if IsSelected then begin
      R := RC;

      if not Skinned then //Skin Patch
       if ImageIsShown or Item.Checked then
         Inc(R.Left, LeftMargin + tbMenuImageTextSpace);

      if (tbisCombo in Item.ItemStyle) and IsSelected and ShowEnabled then
        Dec(R.Right, MenuCheckWidth);
//Skin Patch Begin
       if Skinned then
         case CSkin.SkinType of
           tbsOfficeXP: If ShowEnabled then begin
                          Inc(R.Left);
                          //Dec(R.Right);

                          if (tboGradSelItem in CSkin.Options) then
                            FillGradient(Canvas.Handle, R,
                                         CSkin.Colors.tcGradStart,
                                         CSkin.Colors.tcGradEnd,
                                         CSkin.Gradient)
                          else begin
                            Canvas.Brush.Color := CSkin.Colors.tcSelItem;
                            Canvas.FillRect(R);
                          end;

                          Canvas.Brush.Color := CSkin.Colors.tcSelItemBorder;
                          Canvas.FrameRect(R);
                                  //stop
                          if (tbisCombo in Item.ItemStyle) and IsSelected then
                          begin
                            Canvas.Brush.Color := CSkin.Colors.tcSelPushedBorder;
                            Canvas.FrameRect(Rect(R.Right -1, 0, R.Right + MenuCheckWidth, R.Bottom));
                          end;
                        end
                        else if KeyHover or (not FView.FMouseOverSelected) then begin
                          Canvas.Brush.Color := CSkin.Colors.tcPopup;
                          Canvas.FillRect(R);

                          Canvas.Brush.Color := CSkin.Colors.tcSelBarBorder;
                          Canvas.FrameRect(R);

                          KeyHover := False;

                          Dec(R.Left);
                          Inc(R.Right);
                        end;
          tbsNativeXP,
          tbsWindowsXP: begin
                          Inc(RC.Left, 2); //Adjust Windows XP Selection Bar
                          Dec(RC.Right, 2); //Adjust Windows XP Selection Bar
                          Inc(R.Left, 2); //Adjust Windows XP Selection Bar
                          Dec(R.Right, 2); //Adjust Windows XP Selection Bar

                          if (tboGradSelItem in CSkin.Options) then
                            FillGradient(Canvas.Handle, RC,
                                         CSkin.Colors.tcGradStart,
                                         CSkin.Colors.tcGradEnd,
                                         CSkin.Gradient)
                          else begin
                            if (tbisCombo in Item.ItemStyle) then
                             Inc(R.Right, MenuCheckWidth -1);

                            Canvas.Brush.Color := CSkin.Colors.tcSelItem;
                            Canvas.FillRect(R);
                          end;

                          Canvas.Brush.Color := CSkin.Colors.tcSelItemBorder;
                          Canvas.FrameRect(RC);

                          Dec(RC.Left, 2); //Adjust Windows XP Selection Bar
                          Inc(RC.Right, 2); //Adjust Windows XP Selection Bar
                          Dec(R.Left, 2); //Adjust Windows XP Selection Bar
                          Inc(R.Right, 2); //Adjust Windows XP Selection Bar
                        end;
         end
//Skin Patch End
       else Canvas.FillRect(R);
    end;
  end;

  { Adjust brush & font }
  Canvas.Brush.Style := bsClear;
  if tboDefault in Item.EffectiveOptions then
    with Canvas.Font do Style := Style + [fsBold];
  GetTextMetrics(Canvas.Handle, TextMetrics);

//Skin Patch Begin
  if Skinned then begin

    if ((FView.FWindow is TTBCustomToolbar) and
        TTBCustomToolbar(FView.FWindow).MenuBar) or
        (FView.FWindow is TTBPopupWindow) then
      if ShowEnabled and not (IsPopupOpen or IsSelected) then
        Canvas.Font.Color := CSkin.Colors.tcText
      else
        Canvas.Font.Color := CSkin.Colors.tcHighlightText;
  end;
//Skin Patch End

  { Caption }
  if CaptionShown then begin
    S := GetCaptionText;
    R := RC;
    DrawTextFlags := GetDrawTextFlags;
    if ToolbarStyle then begin
      if ImageIsShown then begin
        if (View.Orientation <> tbvoVertical) and
           not(tboImageAboveCaption in Item.EffectiveOptions) then
          Inc(R.Left, ImgList.Width + 1)
        else
          Inc(R.Top, ImgList.Height + 1);
      end;
      DrawItemCaption(Canvas, R, S, UseDisabledShadow,
        DT_SINGLELINE or DT_CENTER or DT_VCENTER or DrawTextFlags,
// Skin Patch Begin
        (not Skinned) or (Skinned and (CSkin.SkinType = tbsWindowsXP) and
        not ((FView.FWindow is TTBCustomToolbar) and
              TTBCustomToolbar(FView.FWindow).MenuBar)));
// Skin Patch End

//Skin Patch Begin
      if Skinned then
       Inc(R.Left, XPMargin *2);
//Skin Patch End

    end
    else begin
      Inc(R.Left, LeftMargin + tbMenuImageTextSpace + tbMenuLeftTextMargin);
      { Like standard menus, shift the text up one pixel if the text height
        is 4 pixels less than the total item height. This is done so underlined
        characters aren't displayed too low. }
      if (R.Bottom - R.Top) - (TextMetrics.tmHeight + TextMetrics.tmExternalLeading) = tbMenuVerticalMargin then
        Dec(R.Bottom);
      Inc(R.Top, TextMetrics.tmExternalLeading);

//Skin Patch Begin
      If Skinned then begin
       Inc(R.Left, 2);

       DrawItemCaption(Canvas, R, S, Not ShowEnabled,
          DT_SINGLELINE or DT_LEFT or DT_VCENTER or DrawTextFlags,
          False); //Skin Patch

       Dec(R.Left, 2);
      end
      else
//Skin Patch End
         DrawItemCaption(Canvas, R, S, UseDisabledShadow,
           DT_SINGLELINE or DT_LEFT or DT_VCENTER or DrawTextFlags);
    end;
  end;

  { Shortcut and/or submenu arrow (menus only) }
  if not ToolbarStyle then begin
    S := Item.GetShortCutText;
    if S <> '' then begin
      R := RC;
      R.Left := R.Right - (R.Bottom - R.Top) - GetTextWidth(Canvas.Handle, S, True);
      { Like standard menus, shift the text up one pixel if the text height
        is 4 pixels less than the total item height. This is done so underlined
        characters aren't displayed too low. }
      if (R.Bottom - R.Top) - (TextMetrics.tmHeight + TextMetrics.tmExternalLeading) = tbMenuVerticalMargin then
        Dec (R.Bottom);
      Inc(R.Top, TextMetrics.tmExternalLeading);

//Skin Patch Begin
      If Skinned then
         DrawItemCaption(Canvas, R, S, not ShowEnabled,
           DT_SINGLELINE or DT_LEFT or DT_VCENTER or DT_NOPREFIX)
      else
//Skin Patch end
        DrawItemCaption(Canvas, R, S, UseDisabledShadow,
          DT_SINGLELINE or DT_LEFT or DT_VCENTER or DT_NOPREFIX);
    end;
    if tbisSubmenu in Item.ItemStyle then begin
      if not Skinned then //Skin Patch
       if tbisCombo in Item.ItemStyle then begin
         R := RC;
         R.Left := R.Right - MenuCheckWidth;
         if IsSelected and ShowEnabled then
          DrawEdge(Canvas.Handle, R, BDR_SUNKENOUTER, BF_RECT or BF_MIDDLE)
         else begin
           Dec(R.Left);
           if not IsSelected then
             DrawEdge(Canvas.Handle, R, EDGE_ETCHED, BF_LEFT)
            else
             DrawEdge(Canvas.Handle, R, BDR_SUNKENOUTER, BF_LEFT);
         end;
       end;
      DrawSubmenuArrow;
    end;
  end;

  { Image, or check box }
  if ImageIsShown or (not ToolbarStyle and Item.Checked) then begin
    R := RC;
    if ToolbarStyle then begin
      if (View.Orientation <> tbvoVertical) and
         not(tboImageAboveCaption in Item.EffectiveOptions) then
        R.Right := R.Left + ImgList.Width + 2
      else
        R.Bottom := R.Top + ImgList.Height + 2;
    end
    else begin
       R.Right := R.Left + LeftMargin;
//Skin Patch Begin
      if Skinned then begin
       if Item.Checked then begin
         InflateRect(R, -1 - Integer(Skinned and (CSkin.SkinType = tbsOfficeXP)), -1);

         case CSkin.SkinType of
          tbsNativeXP,
           tbsWindowsXP: begin
                          if tboGradSelItem in CSkin.Options then
                           FillGradient(Canvas.Handle, R,
                                        ColorDarker(CSkin.Colors.tcGradStart, Integer(IsSelected) * 20),
                                        ColorDarker(CSkin.Colors.tcGradEnd, Integer(IsSelected) * 20),
                                        CSkin.Gradient)
                          else begin
                            if IsSelected then
                              Canvas.Brush.Color := CSkin.Colors.tcSelPushed
                            else
                              Canvas.Brush.Color := CSkin.Colors.tcSelItem;

                            if Item.ImageIndex <> -1 then
                             Canvas.FillRect(R);
                          end;

                          if IsSelected then
                            Canvas.Brush.Color := CSkin.Colors.tcSelPushedBorder
                          else
                            Canvas.Brush.Color := CSkin.Colors.tcSelItemBorder;

                          if Item.ImageIndex <> -1 then
                            Canvas.FrameRect(R);
                         end;
            tbsOfficeXP: begin
                          if tboGradSelItem in CSkin.Options then
                           FillGradient(Canvas.Handle, R,
                                        ColorDarker(CSkin.Colors.tcGradStart, Integer(IsSelected) * 20),
                                        ColorDarker(CSkin.Colors.tcGradEnd, Integer(IsSelected) * 20),
                                        CSkin.Gradient)
                          else begin
                            if IsSelected then
                              Canvas.Brush.Color := CSkin.Colors.tcSelPushed
                            else
                              Canvas.Brush.Color := CSkin.Colors.tcSelItem;

                            Canvas.FillRect(R);
                          end;

                          if IsSelected then
                            Canvas.Brush.Color := CSkin.Colors.tcSelPushedBorder
                          else
                            Canvas.Brush.Color := CSkin.Colors.tcSelItemBorder;

                          Canvas.FrameRect(R);
                         end;
         end;
       end
      end
      else //SkinPatch End
       if (IsSelected and ShowEnabled) or Item.Checked then
        DrawEdge(Canvas.Handle, R, EdgeStyles[Item.Checked], BF_RECT or BF_MIDDLE);

      if not skinned then begin
        if Item.Checked and not IsSelected then begin
          InflateRect(R, -1, -1);
          Canvas.Brush.Bitmap := GetDitherBitmap;
          Canvas.FillRect(R);
          Canvas.Brush.Style := bsClear;
          InflateRect(R, 1, 1);
        end;

        if Item.Checked then
          OffsetRect(R, 1, 1);
      end;
    end;

    if ImageIsShown then begin
      X := R.Left + ((R.Right - R.Left) - ImgList.Width) div 2;
      Y := R.Top + ((R.Bottom - R.Top) - ImgList.Height) div 2;
//Skin Patch Begin
      if Skinned then begin
       if ShowEnabled then begin
         SkinMargin := 0;
         HoverMargin := 0;

         if (ImgList is TTBCustomImageList) and
             Assigned(TTBCustomImageList(ImgList).FHotImages) then
           HotImgList := TTBCustomImageList(ImgList).FHotImages
         else HotImgList := nil;

         if CSkin.SkinType = tbsOfficeXP then
           if (IsSelected)  and //If the mouse is over
              (not IsPushed) and// and it isn't pushed or checked
              (not Item.Checked) then begin //then create & draw the imagelist shadow
             ImgBitmap := TBitmap.Create;
             Canvas.Brush.Color := CSkin.Colors.tcImgListShadow;

             if not (tboNoHoverIconShadow in CSkin.Options) then
             begin
               if Assigned(HotImgList) then begin
                  ImgBitmap.Width := HotImgList.Width;
                  ImgBitmap.Height := HotImgList.Height;
                  HotImgList.ImageType := itMask;
                  HotImgList.Draw(ImgBitmap.Canvas, 0, 0, Item.ImageIndex);
               end
               else begin
                 ImgBitmap.Width := ImgList.Width;
                 ImgBitmap.Height := ImgList.Height;
                 ImgList.ImageType := itMask;
                 ImgList.Draw(ImgBitmap.Canvas, 0, 0, Item.ImageIndex);
               end;

               DrawState(Canvas.Handle, Canvas.Brush.Handle, Nil,
                         Integer(ImgBitmap.Handle), 0, X + 1, Y + 1,
                         0, R.Bottom -4, DST_BITMAP or DSS_MONO);

               ImgBitmap.Free;
             end;

             HoverMargin := -1;

             //Put the draw state back to for drawing the image
             if Assigned(HotImgList) then
              HotImgList.ImageType := itImage
             else ImgList.ImageType := itImage;
           end
           else
            HoverMargin := -4;

         case CSkin.SkinType of
          tbsNativeXP,
          tbsWindowsXP: if IsPushed and View.FCapture then SkinMargin := 1
                        else SkinMargin := 0;
           tbsOfficeXP: if IsPushed or Item.Checked then SkinMargin := 4
                         else SkinMargin := 0;
         end;

         if (ImgList is TTBCustomImageList) then
          if Item.Checked and Assigned(TTBCustomImageList(ImgList).FCheckedImages) then
           ImgList := TTBCustomImageList(ImgList).FCheckedImages;

         if IsSelected then // Is the mouse over ?
           if Assigned(HotImgList) then // Is there any hot images?
             HotImgList.Draw(Canvas, // Yes, draw from HotImages
               X + SkinMargin + HoverMargin,
               Y + SkinMargin + HoverMargin,
               Item.ImageIndex, True)
           else
             ImgList.Draw(Canvas, // No, draw from Images
               X + SkinMargin + HoverMargin,
               Y + SkinMargin + HoverMargin,
               Item.ImageIndex, True)
         else if (tboBlendedImages in CSkin.Options) and not Item.Checked then begin
           If FView.FIsToolbar Then
            BlendTBXIcon(Canvas, Rect(X, Y, R.Right, R.Bottom), ImgList, Item.ImageIndex, 200)
           Else
            BlendTBXIcon(Canvas, Rect(X, Y, R.Right, R.Bottom), ImgList, Item.ImageIndex, 210);
          end
         else
// draw from Images when mouse is not over
           ImgList.Draw(Canvas, X, Y, Item.ImageIndex, True);
       end
       else // Draw disabled style
         if (ImgList is TTBCustomImageList) and
             Assigned(TTBCustomImageList(ImgList).FDisabledImages) then begin
           TTBCustomImageList(ImgList).FDisabledImages.Draw (Canvas, X, Y, Item.ImageIndex, True);
         end
         else begin
           DrawTBXIconShadow(Canvas, Rect(X, Y, R.Right, R.Bottom),
                             ImgList, Item.ImageIndex);
         end;
      end
//Skin Patch End
      else begin //It's not skinned and execute the original TB2k imagelist routine
        if ImgList is TTBCustomImageList then
          TTBCustomImageList(ImgList).DrawState(Canvas, X, Y, Item.ImageIndex,
            ShowEnabled, IsSelected, Item.Checked)
        else
          ImgList.Draw(Canvas, X, Y, Item.ImageIndex, ShowEnabled);
      end
    end
    else
      if not ToolbarStyle and Item.Checked then begin
        { Draw check mark }
        X := (R.Left + R.Right) div 2 - 2;
        Y := (R.Top + R.Bottom) div 2 + 1;
        System.Move(CheckMarkPoints, Points, 12 * SizeOf(TPoint));
        for I := Low(Points) to High(Points) do begin
          Inc(Points[I].X, X);
          Inc(Points[I].Y, Y);
        end;
        Canvas.Pen.Color := clBtnText;
        Polyline(Canvas.Handle, Points[0], 7);
//Skin Patch begin
        if (not Skinned) or (Skinned and (CSkin.SkinType <> tbsOfficeXP)) then
        begin
//Skin Patch end
          Canvas.Pen.Color := clBtnHighlight;
          Polyline(Canvas.Handle, Points[7], 5);
        end; //Skin Patch
      end;
  end;
end;

procedure TTBItemViewer.GetCursor(const Pt: TPoint; var ACursor: HCURSOR);
begin
end;

function TTBItemViewer.GetIndex: Integer;
begin
  Result := View.IndexOf(Self);
end;

function TTBItemViewer.IsToolbarSize: Boolean;
begin
  Result := View.FIsToolbar or (tboToolbarSize in Item.FEffectiveOptions);
end;

function TTBItemViewer.IsToolbarStyle: Boolean;
begin
  Result := View.FIsToolbar or (tboToolbarStyle in Item.FEffectiveOptions);
end;

function TTBItemViewer.IsPtInButtonPart(X, Y: Integer): Boolean;
var
  W: Integer;
begin
  Result := not(tbisSubmenu in Item.ItemStyle);
  if tbisCombo in Item.ItemStyle then begin
    if IsToolbarStyle then
      W := tbDropdownComboArrowWidth
    else
      W := GetSystemMetrics(SM_CXMENUCHECK);
    Result := X < (BoundsRect.Right - BoundsRect.Left) - W;
  end;
end;

procedure TTBItemViewer.MouseDown(Shift: TShiftState; X, Y: Integer;
  var EventData: TTBItemEventData);

  function HandleDefaultDoubleClick(const View: TTBView): Boolean;
  { Looks for a tboDefault item in View. Returns True if an item was found and
    the modal loop should be canceled }
  var
    I: Integer;
    Item: TTBCustomItem;
  begin
    Result := False;
    for I := 0 to View.FViewerCount-1 do begin
      Item := View.FViewers[I].Item;
      if View.FViewers[I].Show and (tboDefault in Item.EffectiveOptions) and
         (tbisSelectable in Item.ItemStyle) and Item.Enabled and Item.Visible then begin
        View.GivePriority(View.FViewers[I]);
        EventData.DoneActionData.DoneAction := tbdaClickItem;
        EventData.DoneActionData.ClickItem := Item;
        EventData.DoneActionData.Sound := (View <> EventData.RootView) or
          EventData.RootView.FIsPopup;
        Result := True;
        Break;
      end;
    end;
  end;

var
  ParentToolbarView: TTBView;
begin
  if not Item.Enabled then begin
    if (View = EventData.RootView) and IsToolbarStyle then
      EventData.CancelLoop := True;
    Exit;
  end;
  if IsPtInButtonPart(X, Y) then begin
    if IsToolbarStyle then begin
      if View = View.GetParentToolbarView then
        Exclude(View.FState, vsDropDownMenus);
      View.CloseChildPopups;
      View.SetCapture;
      View.Invalidate(Self);
    end;
  end
  else begin
    if View.OpenChildPopup(False) then begin
      ParentToolbarView := View.GetParentToolbarView;
      if (View = ParentToolbarView) and (vsDropDownMenus in View.FState) then
        EventData.MouseDownOnMenu := True;
      if Assigned(ParentToolbarView) then
        Include(ParentToolbarView.FState, vsDropDownMenus);
      if (ssDouble in Shift) and not(tbisCombo in Item.ItemStyle) and
         HandleDefaultDoubleClick(View.FOpenViewerView) then
        EventData.CancelLoop := True;
    end;
  end;
end;

procedure TTBItemViewer.MouseMove(X, Y: Integer; var EventData: TTBItemEventData);
begin
end;

procedure TTBItemViewer.MouseUp(X, Y: Integer; var EventData: TTBItemEventData);
var
  HadCapture, IsToolbarItem: Boolean;
begin
  HadCapture := View.FCapture;
  View.CancelCapture;
  IsToolbarItem := (View = EventData.RootView) and not EventData.RootView.FIsPopup;
  if not View.FMouseOverSelected or not Item.Enabled or
     (tbisClicksTransparent in Item.ItemStyle) then begin
    if IsToolbarItem then
      EventData.CancelLoop := True;
    Exit;
  end;
  if (tbisSubmenu in Item.ItemStyle) and not IsPtInButtonPart(X, Y) then begin
    if IsToolbarItem and EventData.MouseDownOnMenu then
      EventData.CancelLoop := True;
  end
  else begin
    { it's a 'normal' item }
    if not IsToolbarStyle or HadCapture then begin
      View.GivePriority(Self);
      EventData.DoneActionData.DoneAction := tbdaClickItem;
      EventData.DoneActionData.ClickItem := Item;
      EventData.DoneActionData.Sound := not IsToolbarItem;
      EventData.CancelLoop := True;
    end;
  end;
end;

procedure TTBItemViewer.MouseWheel(WheelDelta, X, Y: Integer;
  var EventData: TTBItemEventData);
begin
end;

procedure TTBItemViewer.LosingCapture;
begin
  View.Invalidate(Self);
end;

procedure TTBItemViewer.Entering;
begin
  if Assigned(Item.FOnSelect) then
    Item.FOnSelect(Item, Self, True);
end;

procedure TTBItemViewer.Leaving;
begin
  if Assigned(Item.FOnSelect) then
    Item.FOnSelect(Item, Self, False);
end;

procedure TTBItemViewer.KeyDown(var Key: Word; Shift: TShiftState;
  var EventData: TTBItemEventData);
begin
end;

function TTBItemViewer.ScreenToClient(const P: TPoint): TPoint;
begin
  Result := View.FWindow.ScreenToClient(P);
  Dec(Result.X, BoundsRect.Left);
  Dec(Result.Y, BoundsRect.Top);
end;

function TTBItemViewer.UsesSameWidth: Boolean;
{ If UsesSameWidth returns True, the item viewer's width will be expanded to
  match the widest item viewer on the same view whose UsesSameWidth method
  also returns True. }
begin
  Result := (tboImageAboveCaption in Item.FEffectiveOptions) and
    (tboSameWidth in Item.FEffectiveOptions) and IsToolbarSize;
end;


{ TTBView }

constructor TTBView.CreateView(AOwner: TComponent; AParentView: TTBView;
  AParentItem: TTBCustomItem; AWindow: TWinControl;
  AIsToolbar, ACustomizing, AUsePriorityList: Boolean);
begin
  Create(AOwner);
  FBackgroundColor := clDefault;
  FCustomizing := ACustomizing;
  FIsPopup := not AIsToolbar;
  FIsToolbar := AIsToolbar;
  FParentView := AParentView;
  FParentItem := AParentItem;
  if Assigned(FParentItem) then begin
    //FIsToolbar := FIsToolbar or FParentItem.FDisplayAsToolbar;
    FParentItem.RegisterNotification(LinkNotification);
    FParentItem.FreeNotification(Self);
  end;

//Skin Patch Begin
 if AOwner is TTBCustomDockableWindow then begin
    if Assigned(TTBCustomDockableWindow(AOwner).Skin) then
      FSkin := TTBCustomDockableWindow(AOwner).Skin;
  end else if (AOwner is TTBPopupWindow) and
              Assigned(AParentItem) and
              Assigned(AParentItem.Owner) and
              (AParentItem.Owner is TTBPopupMenu) then
  begin
   if Assigned(TTBPopupMenu(AParentItem.Owner).Skin) then
    FSkin := TTBPopupMenu(AParentItem.Owner).Skin;
    TTBPopupWindow(AOwner).Skin := FSkin;
  end else if Assigned(AParentView) then
    if Assigned(AParentView.Skin) then
      FSkin := AParentView.Skin;
//Skin Patch End

  FUsePriorityList := AUsePriorityList;
  FWindow := AWindow;
  UpdateCurParentItem;
end;

destructor TTBView.Destroy;
begin
  CloseChildPopups;
  if Assigned(FAccObjectInstance) then begin
    FAccObjectInstance.ClientIsDestroying;
    { Get rid of our own reference to FAccObjectInstance. Normally the
      reference count will be now be zero and FAccObjectInstance will be
      freed, unless MSAA still holds a reference. }
    FAccObjectInstance._Release;
    FAccObjectInstance := nil;
  end;
  { If parent view is a toolbar, invalidate the open item so that it's
    redrawn back in the "up" position }
  if Assigned(ParentView) and ParentView.FIsToolbar then begin
    Include(ParentView.FState, vsNoAnimation);
    if Assigned(ParentView.FOpenViewer) then
      ParentView.Invalidate(ParentView.FOpenViewer);
  end;
  if Assigned(FCurParentItem) then
    FCurParentItem.UnregisterNotification(ItemNotification);
  if Assigned(FParentItem) then
    FParentItem.UnregisterNotification(LinkNotification);
  inherited;
  FPriorityList.Free;
  FreeViewers;
  { Now that we're destroyed, "focus" the parent view }
  if Assigned(FParentView) then
    FParentView.NotifyFocusEvent;
end;

function TTBView.GetAccObject: IDispatch;
begin
  if FAccObjectInstance = nil then begin
    if not InitializeOleAcc then begin
      Result := nil;
      Exit;
    end;
    FAccObjectInstance := TTBViewAccObject.Create(Self);
    { Strictly as an optimization, take a reference for ourself and keep it
      for the lifetime of the view. (Destroy calls _Release.) }
    FAccObjectInstance._AddRef;
  end;
  Result := FAccObjectInstance;
end;

function TTBView.HandleWMGetObject(var Message: TMessage): Boolean;
begin
  if (Message.LParam = Integer(OBJID_CLIENT)) and InitializeOleAcc then begin
    Message.Result := LresultFromObjectFunc(ITBAccessible, Message.WParam, GetAccObject);
    Result := True;
  end
  else
    Result := False;
end;

procedure TTBView.UpdateCurParentItem;
var
  Value: TTBCustomItem;
begin
  Value := ItemContainingItems(FParentItem);
  if FCurParentItem <> Value then begin
    CloseChildPopups;
    if Assigned(FCurParentItem) then
      FCurParentItem.UnregisterNotification(ItemNotification);
    FCurParentItem := Value;
    if Assigned(Value) then
      Value.RegisterNotification(ItemNotification);
    RecreateAllViewers;
    if Assigned(Value) and not(csDesigning in Value.ComponentState) then
      InitiateActions;
  end;
end;

procedure TTBView.InitiateActions;
var
  I: Integer;
begin
  { Use a 'while' instead of a 'for' since an InitiateAction implementation
    may add/delete items }
  I := 0;
  while I < FViewerCount do begin
    FViewers[I].Item.InitiateAction;
    Inc(I);
  end;
end;

procedure TTBView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then begin
    if AComponent = FParentItem then begin
      FParentItem := nil;
      UpdateCurParentItem;
      if Assigned(FParentView) then
        FParentView.CloseChildPopups;
    end
    else if AComponent = FOpenViewerWindow then begin
      FOpenViewerWindow := nil;
      FOpenViewerView := nil;
      FOpenViewer := nil;
    end
    else if AComponent = FChevronParentView then
      FChevronParentView := nil;
  end
end;

function TTBView.ContainsView(AView: TTBView): Boolean;
begin
  while Assigned(AView) and (AView <> Self) do
    AView := AView.FParentView;
  Result := Assigned(AView);
end;

function TTBView.GetRootView: TTBView;
begin
  Result := Self;
  while Assigned(Result.FParentView) do
    Result := Result.FParentView;
end;

function TTBView.GetParentToolbarView: TTBView;
begin
  Result := Self;
  while Assigned(Result) and not Result.FIsToolbar do
    Result := Result.FParentView;
end;

procedure TTBView.FreeViewers;
var
  VI: PTBItemViewerArray;
  I, C: Integer;
begin
  if Assigned(FViewers) then begin
    VI := FViewers;
    C := FViewerCount;
    FViewers := nil;
    FViewerCount := 0;
    for I := C-1 downto 0 do
      FreeAndNil(VI[I]);
    FreeMem(VI);
  end;
end;

procedure TTBView.InvalidatePositions;
begin
  if FValidated then begin
    FValidated := False;
    if Assigned(FWindow) and FWindow.HandleAllocated then
      InvalidateRect(FWindow.Handle, nil, True);
  end;
end;

procedure TTBView.ValidatePositions;
begin
  if not FValidated then
    UpdatePositions;
end;

procedure TTBView.TryValidatePositions;
begin
  if (FUpdating = 0) and
     (not Assigned(FParentItem) or not(csLoading in FParentItem.ComponentState)) and
     (not Assigned(FParentItem.Owner) or not(csLoading in FParentItem.Owner.ComponentState)) then
    ValidatePositions;
end;

(*procedure TTBView.TryRevalidatePositions;
begin
  if FValidated then begin
    if FUpdating = 0 then begin
      FreePositions;
      UpdatePositions;
    end
    else
      InvalidatePositions;
  end;
end;*)

function TTBView.Find(Item: TTBCustomItem): TTBItemViewer;
var
  I: Integer;
begin
  for I := 0 to FViewerCount-1 do
    if FViewers[I].Item = Item then begin
      Result := FViewers[I];
      Exit;
    end;
  raise ETBItemError.Create(STBViewerNotFound);
end;

function TTBView.IndexOf(AViewer: TTBItemViewer): Integer;
var
  I: Integer;
begin
  if Assigned(AViewer) then
    for I := 0 to FViewerCount-1 do
      if FViewers[I] = AViewer then begin
        Result := I;
        Exit;
      end;
  Result := -1;
end;


procedure TTBView.DeletingViewer(Viewer: TTBItemViewer);
begin
  if FSelected = Viewer then
    FSelected := nil;
  if FOpenViewer = Viewer then
    CloseChildPopups;
end;

procedure TTBView.RecreateItemViewer(const I: Integer);
var
  OldViewer, NewViewer: TTBItemViewer;
  J: Integer;
begin
  OldViewer := FViewers[I];
  NewViewer := OldViewer.Item.GetItemViewerClass(Self).Create(Self, OldViewer.Item);
  FViewers[I] := NewViewer;
  if Assigned(FPriorityList) then begin
    J := FPriorityList.IndexOf(OldViewer);
    if J <> -1 then
      FPriorityList[J] := NewViewer;
  end;
  DeletingViewer(OldViewer);
  OldViewer.Free;
end;

procedure TTBView.ItemNotification(Sender: TTBCustomItem; Relayed: Boolean;
  Action: TTBItemChangedAction; Index: Integer; Item: TTBCustomItem);

  procedure ItemInserted;

    procedure InsertItem(NewIndex: Integer; AItem: TTBCustomItem);
    var
      NewViewer: TTBItemViewer;
    begin
      NewViewer := AItem.GetItemViewerClass(Self).Create(Self, AItem);
      InsertIntoViewerArray(FViewers, FViewerCount, NewIndex,
        NewViewer);
      if FUsePriorityList then begin
        if csLoading in AItem.ComponentState then
          AddToList(FPriorityList, NewViewer)
        else
          { When new items are inserted programmatically at run-time, place
            them at the top of FPriorityList }
          AddToFrontOfList(FPriorityList, NewViewer);
      end;
    end;

  var
    I, InsertPoint, Start, Last: Integer;
    Subitems, EmbItem, NextItem, LinkItem: TTBCustomItem;
    Found: Boolean;
  begin
    InvalidatePositions;
    Start := 0;
    Subitems := ItemContainingItems(Sender);
    if Sender = FCurParentItem then
      InsertPoint := FViewerCount
    else begin
      { Sender <> FCurParentItem, so apparently an item has been inserted
        inside an embedded item group }
      Found := False;
      while Start < FViewerCount do begin
        EmbItem := FViewers[Start].Item;
        if (tbisEmbeddedGroup in EmbItem.ItemStyle) and (EmbItem = Sender) then begin
          Inc(Start);
          Found := True;
          Break;
        end;
        Inc(Start);
      end;
      if not Found then
        { Couldn't find Sender; it shouldn't get here }
        Exit;
      InsertPoint := Start;
      while (InsertPoint < FViewerCount) and
         (FViewers[InsertPoint].Item.Parent = Subitems) do
        Inc(InsertPoint);
    end;
    if InsertPoint = FViewerCount then begin
      { Don't add items after the chevron or MDI buttons item }
      Dec(InsertPoint, FInternalViewersAtEnd);
      if InsertPoint < 0 then
        InsertPoint := 0;  { just in case? }
    end;
    { If the new item wasn't placed at the end, adjust InsertPoint accordingly }
    if Index < Subitems.Count-1 then begin
      Last := InsertPoint;
      InsertPoint := Start;
      NextItem := Subitems.FItems[Index+1].Item;
      while (InsertPoint < Last) and (FViewers[InsertPoint].Item <> NextItem) do
        Inc(InsertPoint);
    end;
    InsertItem(InsertPoint, Item);
    Inc(InsertPoint);
    { If a new embedded item group is being inserted, insert all its child
      items too }
    if not FCustomizing and
       (tbisEmbeddedGroup in Item.ItemStyle) and
       (Sender = FCurParentItem) then begin
      { ^ (Sender = FCurParentItem) check is there because we don't allow
        embedded item groups inside other embedded item groups }
      LinkItem := ItemContainingItems(Item);
      for I := 0 to LinkItem.Count-1 do begin
        InsertItem(InsertPoint, LinkItem.FItems[I].Item);
        Inc(InsertPoint);
      end;
    end;
  end;

  procedure ItemDeleting;

    procedure DeleteItem(DeleteIndex: Integer);
    var
      Viewer: TTBItemViewer;
    begin
      Viewer := FViewers[DeleteIndex];
      DeletingViewer(Viewer);
      RemoveFromList(FPriorityList, Viewer);
      FreeAndNil(Viewer);
      DeleteFromViewerArray(FViewers, FViewerCount, DeleteIndex);
    end;

  var
    I: Integer;
    FoundItem: TTBCustomItem;
  begin
    InvalidatePositions;
    I := 0;
    FoundItem := nil;
    while I < FViewerCount do begin
      if Assigned(FoundItem) then begin
        if FViewers[I].Item.Parent <> FoundItem then
          FoundItem := nil
        else begin
          DeleteItem(I);
          Continue;
        end;
      end;
      if FViewers[I].Item = Item then begin
        if Item.Parent = Sender then
          { Delete any embedded items next }
          FoundItem := ItemContainingItems(Item);
        DeleteItem(I);
        Continue;
      end;
      Inc(I);
    end;
  end;

var
  I: Integer;
begin
  case Action of
    tbicInserted: ItemInserted;
    tbicDeleting: ItemDeleting;
    tbicSubitemsChanged: RecreateAllViewers;
    tbicSubitemsBeginUpdate: BeginUpdate;
    tbicSubitemsEndUpdate: EndUpdate;
    tbicInvalidate: begin
        for I := 0 to FViewerCount-1 do
          if FViewers[I].Item = Item then
            Invalidate(FViewers[I]);
      end;
    tbicInvalidateAndResize: InvalidatePositions;
    tbicRecreateItemViewers: begin
        InvalidatePositions;
        for I := 0 to FViewerCount-1 do
          if FViewers[I].Item = Item then
            RecreateItemViewer(I);
      end;
    tbicSubMenuImagesChanged: ImagesChanged;
  else
    { Prevent TryValidatePositions from being called below on Actions other than
      those listed above. Currently there are no other Actions, but for forward
      compatibility, we should ignore unknown Actions completely. }
    Exit;
  end;
  TryValidatePositions;
end;

procedure TTBView.LinkNotification(Sender: TTBCustomItem; Relayed: Boolean;
  Action: TTBItemChangedAction; Index: Integer; Item: TTBCustomItem);
{ This notification procedure watches for tbicSubitemsChanged notifications
  from FParentItem }
begin
  case Action of
    tbicSubitemsChanged: UpdateCurParentItem;
    tbicSubMenuImagesChanged: begin
        { In case the images were inherited from the actual parent instead of
          the linked parent... }
        if FParentItem <> FCurParentItem then
          ImagesChanged;
      end;
  end;
end;

procedure TTBView.ImagesChanged;
begin
  InvalidatePositions;
  TryValidatePositions;
  if Assigned(FOpenViewerView) then
    FOpenViewerView.ImagesChanged;
end;

procedure TTBView.GivePriority(AViewer: TTBItemViewer);
{ Move item to top of priority list. Rearranges items if necessary. }
var
  I: Integer;
begin
  if Assigned(FChevronParentView) then begin
    I := AViewer.Index + FChevronParentView.FInternalViewersAtFront;
    if I < FChevronParentView.FViewerCount then  { range check just in case }
      FChevronParentView.GivePriority(FChevronParentView.FViewers[I]);
    Exit;
  end;
  if Assigned(FPriorityList) then begin
    I := FPriorityList.IndexOf(AViewer);
    if I <> -1 then begin
      FPriorityList.Move(I, 0);
      if not FValidated or AViewer.OffEdge then
        UpdatePositions;
    end;
  end;
  { Call GivePriority on parent view, so that if an item on a submenu is
    clicked, the parent item of the submenu gets priority. }
  if Assigned(FParentView) and Assigned(FParentView.FOpenViewer) then
    FParentView.GivePriority(FParentView.FOpenViewer);
end;

function TTBView.HighestPriorityViewer: TTBItemViewer;
{ Returns index of first visible, non-separator item at top of priority list,
  or -1 if there are no items found }
var
  I: Integer;
  J: TTBItemViewer;
begin
  ValidatePositions;
  Result := nil;
  if Assigned(FPriorityList) then begin
    for I := 0 to FPriorityList.Count-1 do begin
      J := FPriorityList[I];
      if J.Show and not(tbisSeparator in J.Item.ItemStyle) then begin
        Result := J;
        Break;
      end;
    end;
  end
  else begin
    for I := 0 to FViewerCount-1 do begin
      J := FViewers[I];
      if J.Show and not(tbisSeparator in J.Item.ItemStyle) then begin
        Result := J;
        Break;
      end;
    end;
  end;
end;

procedure TTBView.StartTimer(const ATimer: TTBViewTimerID;
  const Interval: Integer);
{ Starts a timer. Stops any previously set timer of the same ID first.
  Note: WM_TIMER messages generated by timers set by the method are handled
  in PopupMessageLoop. }
begin
  StopTimer(ATimer);
  if (FWindow is TTBPopupWindow) and FWindow.HandleAllocated then begin
    SetTimer(FWindow.Handle, ViewTimerBaseID + Ord(ATimer), Interval, nil);
    Include(FActiveTimers, ATimer);
  end;
end;

procedure TTBView.StopAllTimers;
var
  I: TTBViewTimerID;
begin
  for I := Low(I) to High(I) do
    StopTimer(I);
end;

procedure TTBView.StopTimer(const ATimer: TTBViewTimerID);
begin
  if ATimer in FActiveTimers then begin
    if (FWindow is TTBPopupWindow) and FWindow.HandleAllocated then
      KillTimer(FWindow.Handle, ViewTimerBaseID + Ord(ATimer));
    Exclude(FActiveTimers, ATimer);
  end;
end;

function TTBView.OpenChildPopup(const SelectFirstItem: Boolean): Boolean;
var
  Item: TTBCustomItem;
begin
  StopTimer(tiClose);
  StopTimer(tiOpen);
  if FSelected <> FOpenViewer then begin
    CloseChildPopups;
    if Assigned(FSelected) then begin
      Item := FSelected.Item;
      if Item.Enabled and (tbisSubmenu in Item.ItemStyle) then
        Item.CreatePopup(Self, FSelected, not FIsToolbar, SelectFirstItem,
          False, Point(0, 0), tbpaLeft);
    end;
  end;
  Result := Assigned(FOpenViewer);
end;

function TTBView.ViewerFromPoint(const P: TPoint): TTBItemViewer;
var
  I: Integer;
begin
  ValidatePositions;
  for I := 0 to FViewerCount-1 do begin
    if FViewers[I].Show and
       PtInRect(FViewers[I].BoundsRect, P) then begin
      Result := FViewers[I];
      Exit;
    end;
  end;
  Result := nil;
end;

procedure TTBView.NotifyFocusEvent;
{ Notifies Active Accessibility of a change in "focus". Has no effect if the
  view or the root view lacks the vsModal state. }
var
  I: Integer;
begin
  { Note: We don't notify about windows not yet shown (e.g. a popup menu that
    is still initializing) because that would probably confuse screen readers.
    Also allocating a window handle at this point *might* not be a good idea. }
  if (vsModal in FState) and (vsModal in GetRootView.FState) and
     FWindow.HandleAllocated and IsWindowVisible(FWindow.Handle) then begin
    I := IndexOf(FSelected) + 1;
    if (I = 0) and Assigned(FParentView) then begin
      { If we have no selected item, report the the selected item on the parent
        view as having the "focus".
        Note: With standard menus, when you go from having a selection to no
        selection on a submenu, it sends two focus events - first with the
        client window as having the focus, then with the parent item. I
        figure that's probably a bug, so I don't try to emulate that behavior
        here. }
      FParentView.NotifyFocusEvent;
    end
    else begin
      CallNotifyWinEvent(EVENT_OBJECT_FOCUS, FWindow.Handle, OBJID_CLIENT, I);
      { Note: I may be 0 (CHILDID_SELF) here, in which case NotifyWinEvent
        will report the client window itself as being "focused". This is OK,
        because it's what happens when a standard context menu has no
        selection. }
    end;
  end;
end;

procedure TTBView.SetSelected(Value: TTBItemViewer);
var
  OldSelected: TTBItemViewer;
  NewMouseOverSelected: Boolean;
  P: TPoint;
begin
  OldSelected := FSelected;
  if Value <> OldSelected then begin
    { If there's a new selection and the parent item on the parent view
      isn't currently selected, select it. Also stop any timer running on
      the parent view. }
    if Assigned(Value) and Assigned(FParentView) and
       Assigned(FParentView.FOpenViewer) and
       (FParentView.FSelected <> FParentView.FOpenViewer) then begin
      FParentView.Selected := FParentView.FOpenViewer;
      FParentView.StopTimer(tiClose);
      FParentView.StopTimer(tiOpen);
    end;
    CancelCapture;
    if Assigned(OldSelected) then
      OldSelected.Leaving;
    FSelected := Value;
  end;
  NewMouseOverSelected := False;
  if Assigned(Value) and Assigned(FWindow) then begin
    P := SmallPointToPoint(TSmallPoint(GetMessagePos()));
    if FindDragTarget(P, True) = FWindow then begin
      P := FWindow.ScreenToClient(P);
      NewMouseOverSelected := (ViewerFromPoint(P) = Value);
      if NewMouseOverSelected and FCapture and
         not Value.IsPtInButtonPart(P.X - Value.BoundsRect.Left,
         P.Y - Value.BoundsRect.Top) then
        NewMouseOverSelected := False;
    end;
  end;
  if Value <> OldSelected then begin
    FMouseOverSelected := NewMouseOverSelected;
    if Assigned(OldSelected) and (tbisRedrawOnSelChange in OldSelected.Item.ItemStyle) then
      Invalidate(OldSelected);
    if Assigned(Value) then begin
      if tbisRedrawOnSelChange in Value.Item.ItemStyle then
        Invalidate(Value);
      Value.Entering;
    end;
    NotifyFocusEvent;
  end
  else if FMouseOverSelected <> NewMouseOverSelected then begin
    FMouseOverSelected := NewMouseOverSelected;
    if Assigned(Value) and FCapture and (tbisRedrawOnMouseOverChange in Value.Item.ItemStyle) then
      Invalidate(Value);
  end;
end;

procedure TTBView.UpdateSelection(const P: PPoint; const AllowNewSelection: Boolean);
{ Called in response to a mouse movement, this method updates the current
  selection and updates the vsMouseInWindow view state. If the view is modal
  (vsModal), it additionally closes/opens child popups, and enables/disables
  the scroll arrow timers. }

  function IsPtInScrollArrow(ADownArrow: Boolean): Boolean;
  var
    P2: TPoint;
    R: TRect;
  begin
    Result := False;
    if (vsModal in FState) and (vsMouseInWindow in FState) and
       Assigned(P) then begin
      P2 := FWindow.ScreenToClient(P^);
      R := FWindow.ClientRect;
      if PtInRect(R, P2) then begin
        if ADownArrow then
          Result := FShowDownArrow and (P2.Y >= R.Bottom - tbMenuScrollArrowHeight)
        else
          Result := FShowUpArrow and (P2.Y < tbMenuScrollArrowHeight);
      end;
    end;
  end;

var
  NewSelected, ViewerAtPoint: TTBItemViewer;
  P2: TPoint;
  MouseWasInWindow: Boolean;
  OldSelected: TTBItemViewer;
  MenuShowDelay: Integer;
begin
  ValidatePositions;

  { If modal, default to keeping the existing selection }
  if vsModal in FState then
    NewSelected := FSelected
  else
    NewSelected := nil;

  { Is the mouse inside the window? }
  MouseWasInWindow := vsMouseInWindow in FState;
  if Assigned(P) and Assigned(FWindow) and (FindDragTarget(P^, True) = FWindow) then begin
    { If we're a popup window and the mouse is inside, default to no selection }
    if FIsPopup then
      NewSelected := nil;
    Include(FState, vsMouseInWindow);
    if AllowNewSelection or Assigned(FSelected) then begin
      P2 := FWindow.ScreenToClient(P^);
      ViewerAtPoint := ViewerFromPoint(P2);
      if Assigned(ViewerAtPoint) then
        NewSelected := ViewerAtPoint;
    end;
  end
  else
    Exclude(FState, vsMouseInWindow);

  { If FCapture is True, don't allow the selection to change }
  if FCapture and (NewSelected <> FSelected) then
    NewSelected := FSelected;

  { If we're a popup window and there is a selection... }
  if FIsPopup and Assigned(NewSelected) then begin
    { If the mouse just moved out of the window and no submenu was open,
      remove the highlight }
    if not FCapture and MouseWasInWindow and not(vsMouseInWindow in FState) and
       (not Assigned(FOpenViewerView) or not(tbisSubmenu in NewSelected.Item.ItemStyle)) then
      NewSelected := nil;
  end;

  { Now we set the new Selected value.
    Was a submenu item selected for the first time, or if a submenu was
    already open, has the selection has moved to a different item? }
  if (vsModal in FState) and (vsMouseInWindow in FState) and
     (FOpenViewer <> NewSelected) and
     (Assigned(FOpenViewer) or (tbisSubmenu in NewSelected.Item.ItemStyle)) then begin
    if FIsToolbar then begin
      { So that MSAA receives events in the right order, close child popups
        *before* changing selection }
      CloseChildPopups;
      Selected := NewSelected;
      if Assigned(FParentView) and not FCapture then
        { On chevron popups, always drop down menus when mouse passes
          over them, like Office 2000 }
        Include(FState, vsDropDownMenus);
      if vsDropDownMenus in FState then
        OpenChildPopup(False);
    end
    else begin
      { Use timers to delay the showing/hiding of submenus of submenus }
      OldSelected := FSelected;
      Selected := NewSelected;
      MenuShowDelay := GetMenuShowDelay;
      if not(tiOpen in FActiveTimers) then
        StartTimer(tiClose, MenuShowDelay);
      if not(tiOpen in FActiveTimers) or (FSelected <> OldSelected) then
        StartTimer(tiOpen, MenuShowDelay);
    end;
  end
  else
    Selected := NewSelected;

  { Update scroll arrow timers }
  if IsPtInScrollArrow(False) then begin
    StopTimer(tiScrollDown);
    if not(tiScrollUp in FActiveTimers) then
      StartTimer(tiScrollUp, 100);
  end
  else if IsPtInScrollArrow(True) then begin
    StopTimer(tiScrollUp);
    if not(tiScrollDown in FActiveTimers) then
      StartTimer(tiScrollDown, 100);
  end
  else begin
    StopTimer(tiScrollUp);
    StopTimer(tiScrollDown);
  end;
end;

procedure TTBView.RecreateAllViewers;

  procedure DoItem(const Item: TTBCustomItem; const AddPriority: Boolean);
  var
    NewViewer: TTBItemViewer;
  begin
    NewViewer := Item.GetItemViewerClass(Self).Create(Self, Item);
    InsertIntoViewerArray(FViewers, FViewerCount, FViewerCount,
      NewViewer);
    if AddPriority and FUsePriorityList then
      AddToList(FPriorityList, NewViewer);
  end;

  function Recurse(const ParentItem: TTBCustomItem;
    const AddPriority, InEmbedded: Boolean): Integer;
  var
    I: Integer;
    Item: TTBCustomItem;
  begin
    Result := 0;
    for I := 0 to ParentItem.Count-1 do begin
      Item := ParentItem.FItems[I].Item;
      DoItem(Item, AddPriority);
      Inc(Result);
      if not InEmbedded and not FCustomizing and
         (tbisEmbeddedGroup in Item.ItemStyle) then
        Inc(Result, Recurse(ItemContainingItems(Item), AddPriority, True));
    end;
  end;

var
  Item: TTBCustomItem;
begin
  { Since the FViewers list is being rebuilt, FOpenViewer and FSelected
    will no longer be valid, so ensure they're set to nil. }
  CloseChildPopups;
  Selected := nil;

  InvalidatePositions;

  FreeAndNil(FPriorityList);
  FreeViewers;
  FInternalViewersAtFront := 0;
  FInternalViewersAtEnd := 0;
  { MDI system menu item }
  Item := GetMDISystemMenuItem;
  if Assigned(Item) then begin
    DoItem(Item, False);
    Inc(FInternalViewersAtFront);
  end;
  { Items }
  if Assigned(FCurParentItem) then
    Recurse(FCurParentItem, True, False);
  { MDI buttons item }
  Item := GetMDIButtonsItem;
  if Assigned(Item) then
    Inc(FInternalViewersAtEnd, Recurse(Item, False, True));
  { Chevron item }
  Item := GetChevronItem;
  if Assigned(Item) then begin
    DoItem(Item, False);
    Inc(FInternalViewersAtEnd);
  end;
end;

function TTBView.CalculatePositions(const CanMoveControls: Boolean;
  const AOrientation: TTBViewOrientation;
  AWrapOffset, AChevronOffset, AChevronSize: Integer;
  var ABaseSize, TotalSize: TPoint;
  var AWrappedLines: Integer): Boolean;
{ Returns True if the positions have changed }
type
  PTempPosition = ^TTempPosition;
  TTempPosition = record
    BoundsRect: TRect;
    Show, OffEdge, LineSep, Clipped, SameWidth: Boolean;
  end;
  PTempPositionArray = ^TTempPositionArray;
  TTempPositionArray = array[0..$7FFFFFFF div SizeOf(TTempPosition)-1] of TTempPosition;
var
  DC: HDC;
  LeftX, TopY, CurX, CurY, I: Integer;
  NewPositions: PTempPositionArray;
  GroupSplit, DidWrap: Boolean;
  LineStart, HighestHeightOnLine, HighestWidthOnLine: Integer;

  function GetSizeOfGroup(const StartingIndex: Integer): Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := StartingIndex to FViewerCount-1 do begin
      if not NewPositions[I].Show then
        Continue;
      if tbisSeparator in FViewers[I].Item.ItemStyle then
        Break;
      with NewPositions[I] do begin
        if AOrientation <> tbvoVertical then
          Inc(Result, BoundsRect.Right)
        else
          Inc(Result, BoundsRect.Bottom);
      end;
    end;
  end;

  procedure Mirror;
  { Reverses the horizontal ordering (i.e. first item becomes last) }
  var
    I, NewRight: Integer;
  begin
    for I := 0 to FViewerCount-1 do
      with NewPositions[I] do
        if Show then begin
          NewRight := TotalSize.X - BoundsRect.Left;
          BoundsRect.Left := TotalSize.X - BoundsRect.Right;
          BoundsRect.Right := NewRight;
        end;
  end;

  procedure HandleMaxHeight;
  { Decreases, if necessary, the height of the view to FMaxHeight, and adjusts
    the visibility of the scroll arrows }
  var
    MaxOffset, I, MaxTop, MaxBottom: Integer;
  begin
    FShowUpArrow := False;
    FShowDownArrow := False;
    if (FMaxHeight > 0) and (TotalSize.Y > FMaxHeight) then begin
      MaxOffset := TotalSize.Y - FMaxHeight;
      if FScrollOffset > MaxOffset then
        FScrollOffset := MaxOffset;
      if FScrollOffset < 0 then
        FScrollOffset := 0;
      FShowUpArrow := (FScrollOffset > 0);
      FShowDownArrow := (FScrollOffset < MaxOffset);
      MaxTop := 0;
      if FShowUpArrow then
        MaxTop := tbMenuScrollArrowHeight;
      MaxBottom := FMaxHeight;
      if FShowDownArrow then
        Dec(MaxBottom, tbMenuScrollArrowHeight);
      for I := 0 to FViewerCount-1 do begin
        if not IsRectEmpty(NewPositions[I].BoundsRect) then begin
          OffsetRect(NewPositions[I].BoundsRect, 0, -FScrollOffset);
          if NewPositions[I].Show and
             ((NewPositions[I].BoundsRect.Top < MaxTop) or
              (NewPositions[I].BoundsRect.Bottom > MaxBottom)) then begin
            NewPositions[I].Show := False;
            NewPositions[I].Clipped := True;
          end;
        end;
      end;
      TotalSize.Y := FMaxHeight;
    end
    else
      FScrollOffset := 0;
  end;

  procedure FinalizeLine(const LineEnd: Integer; const LastLine: Boolean);
  var
    I, RightAlignStart: Integer;
    Item: TTBCustomItem;
    IsButton: Boolean;
    Pos: PTempPosition;
    Z: Integer;
  begin
    if LineStart <> -1 then begin
      if DidWrap and (FChevronParentView = nil) then begin
        { When wrapping on a docked toolbar, extend TotalSize.X/Y to
          AWrapOffset so that the toolbar always fills the whole row }
        if (AOrientation = tbvoHorizontal) and (TotalSize.X < AWrapOffset) then
          TotalSize.X := AWrapOffset
        else if (AOrientation = tbvoVertical) and (TotalSize.Y < AWrapOffset) then
          TotalSize.Y := AWrapOffset;
      end;
      RightAlignStart := -1;
      for I := LineStart to LineEnd do begin
        Pos := @NewPositions[I];
        if not Pos.Show then
          Continue;
        Item := FViewers[I].Item;
        if (RightAlignStart < 0) and (tbisRightAlign in Item.ItemStyle) then
          RightAlignStart := I;
        IsButton := FIsToolbar or (tboToolbarSize in Item.FEffectiveOptions);
        if FIsToolbar then begin
          if LastLine and not DidWrap and (AOrientation <> tbvoFloating) then begin
            { In case the toolbar is docked next to a taller/wider toolbar... }
            HighestWidthOnLine := TotalSize.X;
            HighestHeightOnLine := TotalSize.Y;
          end;
          { Make separators on toolbars as tall/wide as the tallest/widest item }
          if tbisSeparator in Item.ItemStyle then begin
            if AOrientation <> tbvoVertical then
              Pos.BoundsRect.Bottom := Pos.BoundsRect.Top + HighestHeightOnLine
            else
              Pos.BoundsRect.Right := Pos.BoundsRect.Left + HighestWidthOnLine;
          end
          else begin
            { Center the item }
            if AOrientation <> tbvoVertical then begin
              Z := (HighestHeightOnLine - (Pos.BoundsRect.Bottom - Pos.BoundsRect.Top)) div 2;
              Inc(Pos.BoundsRect.Top, Z);
              Inc(Pos.BoundsRect.Bottom, Z);
            end
            else begin
              Z := (HighestWidthOnLine - (Pos.BoundsRect.Right - Pos.BoundsRect.Left)) div 2;
              Inc(Pos.BoundsRect.Left, Z);
              Inc(Pos.BoundsRect.Right, Z);
            end;
          end;
        end
        else begin
          { Make items in a menu as wide as the widest item }
          if not IsButton then begin
            with Pos.BoundsRect do Right := Left + HighestWidthOnLine;
          end;
        end;
      end;
      if RightAlignStart >= 0 then begin
        Z := 0;
        for I := LineEnd downto RightAlignStart do begin
          Pos := @NewPositions[I];
          if not Pos.Show then
            Continue;
          if AOrientation <> tbvoVertical then
            Z := Min(AWrapOffset, TotalSize.X) - Pos.BoundsRect.Right
          else
            Z := Min(AWrapOffset, TotalSize.Y) - Pos.BoundsRect.Bottom;
          Break;
        end;
        if Z > 0 then begin
          for I := RightAlignStart to LineEnd do begin
            Pos := @NewPositions[I];
            if not Pos.Show then
              Continue;
            if AOrientation <> tbvoVertical then begin
              Inc(Pos.BoundsRect.Left, Z);
              Inc(Pos.BoundsRect.Right, Z);
            end
            else begin
              Inc(Pos.BoundsRect.Top, Z);
              Inc(Pos.BoundsRect.Bottom, Z);
            end;
          end;
        end;
      end;
    end;
    LineStart := -1;
    HighestHeightOnLine := 0;
    HighestWidthOnLine := 0;
  end;

  procedure PositionItem(const CurIndex: Integer; var Pos: TTempPosition);
  var
    O, X, Y: Integer;
    IsLineSep, Vert: Boolean;
  begin
    if LineStart = -1 then begin
      LineStart := CurIndex;
      HighestHeightOnLine := 0;
      HighestWidthOnLine := 0;
    end;
    IsLineSep := False;
    Vert := (AOrientation = tbvoVertical);
    if not Vert then
      O := CurX
    else
      O := CurY;
    if (AWrapOffset > 0) and (O > 0) then begin
      if not Vert then
        Inc(O, Pos.BoundsRect.Right)
      else
        Inc(O, Pos.BoundsRect.Bottom);
      if (tbisSeparator in FViewers[CurIndex].Item.ItemStyle) and
         ((GroupSplit and not(tbisNoLineBreak in FViewers[CurIndex].Item.ItemStyle))
          or (O + GetSizeOfGroup(CurIndex+1) > AWrapOffset)) then begin
        DidWrap := True;
        Inc(AWrappedLines);
        if not Vert then begin
          CurX := 0;
          Inc(CurY, HighestHeightOnLine);
        end
        else begin
          CurY := 0;
          Inc(CurX, HighestWidthOnLine);
        end;
        FinalizeLine(CurIndex-1, False);
        LineStart := CurIndex+1;
        if not Vert then begin
          Pos.BoundsRect.Right := 0;
          Pos.BoundsRect.Bottom := tbLineSpacing;
        end
        else begin
          Pos.BoundsRect.Right := tbLineSpacing;
          Pos.BoundsRect.Bottom := 0;
        end;
        Pos.LineSep := True;
        IsLineSep := True;
      end
      else if O > AWrapOffset then begin
        { proceed to next row }
        DidWrap := True;
        Inc(AWrappedLines);
        if not Vert then begin
          CurX := LeftX;
          Inc(CurY, HighestHeightOnLine);
        end
        else begin
          CurY := TopY;
          Inc(CurX, HighestWidthOnLine);
        end;
        GroupSplit := True;
        FinalizeLine(CurIndex-1, False);
        LineStart := CurIndex;
      end;
    end;
    if Pos.BoundsRect.Bottom > HighestHeightOnLine then
      HighestHeightOnLine := Pos.BoundsRect.Bottom;
    if Pos.BoundsRect.Right > HighestWidthOnLine then
      HighestWidthOnLine := Pos.BoundsRect.Right;
    X := CurX;
    Y := CurY;
    if X < 0 then X := 0;
    if Y < 0 then Y := 0;
    OffsetRect(Pos.BoundsRect, X, Y);
    if IsLineSep then begin
      if not Vert then begin
        CurX := LeftX;
        Inc(CurY, tbLineSpacing);
      end
      else begin
        CurY := TopY;
        Inc(CurX, tbLineSpacing);
      end;
      GroupSplit := False;
    end;
  end;

var
  SaveOrientation: TTBViewOrientation;
  ChevronItem: TTBCustomItem;
  CalcCanvas: TCanvas;
  LastWasSep, LastWasButton, IsButton, IsControl: Boolean;
  Item: TTBCustomItem;
  Ctl: TControl;
  ChangedBold: Boolean;
  HighestSameWidthViewerWidth, Total, J, TotalVisibleItems: Integer;
  IsFirst: Boolean;
  Viewer: TTBItemViewer;
  UseChevron, NonControlsOffEdge, TempViewerCreated: Boolean;
  Margins: TRect;
label 1;
begin
  SaveOrientation := FOrientation;
  AWrappedLines := 1;
  ChevronItem := GetChevronItem;
  NewPositions := nil;
  DC := 0;
  CalcCanvas := nil;
  try
    FOrientation := AOrientation;

    CalcCanvas := TCanvas.Create;
    DC := GetDC(0);
    CalcCanvas.Handle := DC;
    CalcCanvas.Font.Assign(GetFont);

    NewPositions := AllocMem(FViewerCount * SizeOf(TTempPosition));

    { Figure out which items should be shown }
    LastWasSep := True;  { set to True initially so it won't show leading seps }
    for I := 0 to FViewerCount-1 do begin
      Item := FViewers[I].Item;
      IsControl := Item is TTBControlItem;
      with NewPositions[I] do begin
        { Show is initially False since AllocMem initializes to zero }
        if Item = ChevronItem then
          Continue;
        if Assigned(FChevronParentView) then begin
          if IsControl then
            Continue;
          FChevronParentView.ValidatePositions;
          J := I + FChevronParentView.FInternalViewersAtFront;
          if J < FChevronParentView.FViewerCount then
            { range check just in case }
            Viewer := FChevronParentView.FViewers[J]
          else
            Viewer := nil;
          if (Viewer = nil) or (not Viewer.OffEdge and not(tbisSeparator in Item.ItemStyle)) then
            Continue;
        end;
        if not IsControl then begin
          if not(tbisEmbeddedGroup in Item.ItemStyle) or FCustomizing then begin
            Show := Item.Visible;
            { Don't display two consecutive separators }
            if Show then begin
              if (tbisSeparator in Item.ItemStyle) and LastWasSep then
                Show := False;
              LastWasSep := tbisSeparator in Item.ItemStyle;
            end;
          end;
        end
        else begin
          { Controls can only be rendered on a single Parent, so only
            include the control if its parent is currently equal to
            FWindow }
          Ctl := TTBControlItem(Item).FControl;
          if Assigned(Ctl) and Assigned(FWindow) and (Ctl.Parent = FWindow) and
             (Ctl.Visible or (csDesigning in Ctl.ComponentState)) then begin
            Show := True;
            LastWasSep := False;
          end;
        end;
      end;
    end;

    { Hide any trailing separators, so that they aren't included in the
      base size }
    for I := FViewerCount-1 downto 0 do begin
      with NewPositions[I] do
        if Show then begin
          if not(tbisSeparator in FViewers[I].Item.ItemStyle) then
            Break;
          Show := False;
        end;
    end;

    { Calculate sizes of all the items }
    HighestSameWidthViewerWidth := 0;
    for I := 0 to FViewerCount-1 do begin
      Item := FViewers[I].Item;
      IsControl := Item is TTBControlItem;
      with NewPositions[I] do begin
        { BoundsRect is currently empty since AllocMem initializes to zero }
        if not Show then
          Continue;
        if not IsControl then begin
          ChangedBold := False;
          if tboDefault in Item.EffectiveOptions then
            with CalcCanvas.Font do
              if not(fsBold in Style) then begin
                ChangedBold := True;
                Style := Style + [fsBold];
              end;
          Viewer := FViewers[I];
          TempViewerCreated := False;
          if Item.NeedToRecreateViewer(Viewer) then begin
            if CanMoveControls then begin
              RecreateItemViewer(I);
              Viewer := FViewers[I];
            end
            else begin
              Viewer := Item.GetItemViewerClass(Self).Create(Self, Item);
              TempViewerCreated := True;
            end;
          end;
          try
            Viewer.CalcSize(CalcCanvas, BoundsRect.Right, BoundsRect.Bottom);
            if Viewer.UsesSameWidth then begin
              SameWidth := True;
              if (BoundsRect.Right > HighestSameWidthViewerWidth) then
                HighestSameWidthViewerWidth := BoundsRect.Right;
            end;
          finally
            if TempViewerCreated then
              Viewer.Free;
          end;
          if ChangedBold then
            with CalcCanvas.Font do
              Style := Style - [fsBold];
        end
        else begin
          Ctl := TTBControlItem(Item).FControl;
          BoundsRect.Right := Ctl.Width;
          BoundsRect.Bottom := Ctl.Height;
        end;
      end;
    end;

    { Increase widths of SameWidth items if necessary. Also calculate
      ABaseSize.X (or Y). }
    ABaseSize.X := 0;
    ABaseSize.Y := 0;
    for I := 0 to FViewerCount-1 do begin
      with NewPositions[I] do begin
        if SameWidth and (BoundsRect.Right < HighestSameWidthViewerWidth) then
          BoundsRect.Right := HighestSameWidthViewerWidth;
        if AOrientation <> tbvoVertical then
          Inc(ABaseSize.X, BoundsRect.Right)
        else
          Inc(ABaseSize.Y, BoundsRect.Bottom);
      end;
    end;

    { Hide partially visible items, mark them as 'OffEdge' }
    if AOrientation <> tbvoVertical then
      Total := ABaseSize.X
    else
      Total := ABaseSize.Y;
    NonControlsOffEdge := False;
    UseChevron := Assigned(ChevronItem) and (AChevronOffset > 0) and
      (Total > AChevronOffset);
    if UseChevron then begin
      Dec(AChevronOffset, AChevronSize);
      while Total > AChevronOffset do begin
        { Count number of items. Stop loop if <= 1 }
        TotalVisibleItems := 0;
        for I := FViewerCount-1 downto 0 do begin
          if NewPositions[I].Show and not(tbisSeparator in FViewers[I].Item.ItemStyle) then
            Inc(TotalVisibleItems);
        end;
        if TotalVisibleItems <= 1 then
          Break;
        { Hide any trailing separators }
        for I := FViewerCount-1 downto 0 do begin
          with NewPositions[I] do
            if Show then begin
              if not(tbisSeparator in FViewers[I].Item.ItemStyle) then
                Break;
              Show := False;
              if AOrientation <> tbvoVertical then
                Dec(Total, BoundsRect.Right)
              else
                Dec(Total, BoundsRect.Bottom);
              goto 1;
            end;
        end;
        { Find an item to hide }
        if Assigned(FPriorityList) then
          I := FPriorityList.Count-1
        else
          I := FViewerCount-1;
        while I >= 0 do begin
          if Assigned(FPriorityList) then begin
            Viewer := FPriorityList[I];
            J := Viewer.Index;
          end
          else begin
            Viewer := FViewers[I];
            J := I;
          end;
          if NewPositions[J].Show and not(tbisSeparator in Viewer.Item.ItemStyle) then begin
            NewPositions[J].Show := False;
            NewPositions[J].OffEdge := True;
            if AOrientation <> tbvoVertical then
              Dec(Total, NewPositions[J].BoundsRect.Right)
            else
              Dec(Total, NewPositions[J].BoundsRect.Bottom);
            if not NonControlsOffEdge and not(Viewer.Item is TTBControlItem) then
              NonControlsOffEdge := True;
            goto 1;
          end;
          Dec(I);
        end;
        Break;  { prevent endless loop }
        1:
        { Don't show two consecutive separators }
        LastWasSep := True;  { set to True initially so it won't show leading seps }
        for J := 0 to FViewerCount-1 do begin
          Item := FViewers[J].Item;
          with NewPositions[J] do begin
            if Show then begin
              if (tbisSeparator in Item.ItemStyle) and LastWasSep then begin
                Show := False;
                if AOrientation <> tbvoVertical then
                  Dec(Total, BoundsRect.Right)
                else
                  Dec(Total, BoundsRect.Bottom);
              end;
              LastWasSep := tbisSeparator in Item.ItemStyle;
            end;
          end;
        end;
      end;
    end;

    { Hide any trailing separators after items were hidden }
    for I := FViewerCount-1 downto 0 do begin
      with NewPositions[I] do
        if Show then begin
          if not(tbisSeparator in FViewers[I].Item.ItemStyle) then
            Break;
          Show := False;
        end;
    end;

    { Set the ABaseSize.Y (or X) *after* items were hidden }
    for I := 0 to FViewerCount-1 do begin
      with NewPositions[I] do
        if Show then begin
          if AOrientation <> tbvoVertical then begin
            if BoundsRect.Bottom > ABaseSize.Y then
              ABaseSize.Y := BoundsRect.Bottom;
          end
          else begin
            if BoundsRect.Right > ABaseSize.X then
              ABaseSize.X := BoundsRect.Right;
          end;
        end;
    end;

    { On menus, set all non-separator items to be as tall as the tallest item }
    {if not FIsToolbar then begin
      J := 0;
      for I := 0 to FViewerCount-1 do begin
        Item := FViewers[I].Item;
        with NewPositions[I] do
          if Show and not(tbisSeparator in Item.ItemStyle) and
             not(tboToolbarSize in Item.FEffectiveOptions) and
             (BoundsRect.Bottom - BoundsRect.Top > J) then
            J := BoundsRect.Bottom - BoundsRect.Top;
      end;
      for I := 0 to FViewerCount-1 do begin
        Item := FViewers[I].Item;
        with NewPositions[I] do
          if Show and not(tbisSeparator in Item.ItemStyle) and
             not(tboToolbarSize in Item.FEffectiveOptions) then
            BoundsRect.Bottom := BoundsRect.Top + J;
      end;
    end;}

    { Calculate the position of the items }
    GetMargins(AOrientation, Margins);
    LeftX := Margins.Left;
    TopY := Margins.Top;
    if AWrapOffset > 0 then begin
      Dec(AWrapOffset, Margins.Right);
      if AWrapOffset < 1 then AWrapOffset := 1;
    end;
    CurX := LeftX;
    CurY := TopY;
    GroupSplit := False;
    DidWrap := False;
    LastWasButton := FIsToolbar;
    LineStart := -1;
    for I := 0 to FViewerCount-1 do begin
      Item := FViewers[I].Item;
      with NewPositions[I] do begin
        if not Show then
          Continue;
        IsButton := FIsToolbar or (tboToolbarSize in Item.FEffectiveOptions);
        if LastWasButton and not IsButton then begin
          { On a menu, if last item was a button and the current item isn't,
            proceed to next row }
          CurX := LeftX;
          CurY := TotalSize.Y;
        end;
        LastWasButton := IsButton;
        PositionItem(I, NewPositions[I]);
        if IsButton and (AOrientation <> tbvoVertical) then
          Inc(CurX, BoundsRect.Right - BoundsRect.Left)
        else
          Inc(CurY, BoundsRect.Bottom - BoundsRect.Top);
        if BoundsRect.Right > TotalSize.X then
          TotalSize.X := BoundsRect.Right;
        if BoundsRect.Bottom > TotalSize.Y then
          TotalSize.Y := BoundsRect.Bottom;
      end;
    end;
    if FViewerCount <> 0 then
      FinalizeLine(FViewerCount-1, True);
    Inc(TotalSize.X, Margins.Right);
    Inc(TotalSize.Y, Margins.Bottom);
    if AOrientation = tbvoVertical then
      Mirror;
    HandleMaxHeight;
    if CanMoveControls then begin
      for I := 0 to FViewerCount-1 do begin
        Item := FViewers[I].Item;
        if Item is TTBControlItem then begin
          if NewPositions[I].Show then begin
            Ctl := TTBControlItem(Item).FControl;
            if not EqualRect(NewPositions[I].BoundsRect, Ctl.BoundsRect) then
              Ctl.BoundsRect := NewPositions[I].BoundsRect;
          end
          else if NewPositions[I].OffEdge or NewPositions[I].Clipped then begin
            { Simulate hiding of OddEdge controls by literally moving them
              off the edge. Do the same for Clipped controls. }
            Ctl := TTBControlItem(Item).FControl;
            Ctl.SetBounds(FWindow.ClientWidth, FWindow.ClientHeight,
              Ctl.Width, Ctl.Height);
          end;
        end;
      end;
    end;
    { Set size of line separators }
    if FIsToolbar then
      for I := 0 to FViewerCount-1 do begin
        Item := FViewers[I].Item;
        with NewPositions[I] do
          if Show and (tbisSeparator in Item.ItemStyle) and
             LineSep then begin
            if AOrientation <> tbvoVertical then
              BoundsRect.Right := TotalSize.X
            else
              BoundsRect.Bottom := TotalSize.Y;
          end;
      end;

    { Position the chevron item }
    if UseChevron then begin
      if CanMoveControls then
        ChevronItem.Enabled := NonControlsOffEdge;
      NewPositions[FViewerCount-1].Show := True;
      I := AChevronOffset;
      if AOrientation <> tbvoVertical then begin
        if I < TotalSize.X then
          I := TotalSize.X;
        NewPositions[FViewerCount-1].BoundsRect := Bounds(I, 0,
          AChevronSize, TotalSize.Y);
      end
      else begin
        if I < TotalSize.Y then
          I := TotalSize.Y;
        NewPositions[FViewerCount-1].BoundsRect := Bounds(0, I,
          TotalSize.X, AChevronSize);
      end;
    end;

    { Commit changes }
    Result := False;
    if CanMoveControls then begin
      for I := 0 to FViewerCount-1 do begin
        if not Result and
           (not EqualRect(FViewers[I].BoundsRect, NewPositions[I].BoundsRect) or
            (FViewers[I].Show <> NewPositions[I].Show) or
            (tbisLineSep in FViewers[I].State <> NewPositions[I].LineSep)) then
          Result := True;
        FViewers[I].FBoundsRect := NewPositions[I].BoundsRect;
        FViewers[I].FShow := NewPositions[I].Show;
        FViewers[I].FOffEdge := NewPositions[I].OffEdge;
        FViewers[I].FClipped := NewPositions[I].Clipped;
        if NewPositions[I].LineSep then
          Include(FViewers[I].State, tbisLineSep)
        else
          Exclude(FViewers[I].State, tbisLineSep);
      end;
    end;
  finally
    FOrientation := SaveOrientation;
    if Assigned(CalcCanvas) then
      CalcCanvas.Handle := 0;
    if DC <> 0 then ReleaseDC(0, DC);
    CalcCanvas.Free;
    FreeMem(NewPositions);
  end;
  if (ABaseSize.X = 0) or (ABaseSize.Y = 0) then begin
    { If there are no visible items... }
    {}{scale this?}
    ABaseSize.X := 23;
    ABaseSize.Y := 22;
    if TotalSize.X < 23 then TotalSize.X := 23;
    if TotalSize.Y < 22 then TotalSize.Y := 22;
  end;
end;

procedure TTBView.DoUpdatePositions(var ASize: TPoint);
{ This is called by UpdatePositions }
var
  Bmp: TBitmap;
  CtlCanvas: TControlCanvas;
  WrappedLines: Integer;
begin
  { Don't call InvalidatePositions before CalculatePositions so that
    endless recursion doesn't happen if an item's CalcSize uses a method that
    calls ValidatePositions }
  if not CalculatePositions(True, FOrientation, FWrapOffset, FChevronOffset,
     FChevronSize, FBaseSize, ASize, WrappedLines) then begin
    { If the new positions are identical to the previous ones, continue using
      the previous ones, and don't redraw }
    FValidated := True;
    { Just because the positions are the same doesn't mean the size hasn't
      changed. (If a shrunken toolbar moves between docks, the positions of
      the non-OffEdge items may be the same on the new dock as on the old
      dock.) }
    AutoSize(ASize.X, ASize.Y);
  end
  else begin
    if not(csDesigning in ComponentState) then begin
      FValidated := True;
      { Need to call ValidateRect before AutoSize, otherwise Windows will
        erase the client area during a resize }
      if FWindow.HandleAllocated then
        ValidateRect(FWindow.Handle, nil);
      AutoSize(ASize.X, ASize.Y);
      if Assigned(FWindow) and FWindow.HandleAllocated and
         IsWindowVisible(FWindow.Handle) and
         (FWindow.ClientWidth > 0) and (FWindow.ClientHeight > 0) then begin
        CtlCanvas := nil;
        Bmp := TBitmap.Create;
        try
          CtlCanvas := TControlCanvas.Create;
          CtlCanvas.Control := FWindow;
          Bmp.Width := FWindow.ClientWidth;
          Bmp.Height := FWindow.ClientHeight;

          SendMessage(FWindow.Handle, WM_ERASEBKGND, WPARAM(Bmp.Canvas.Handle), 0);
          SendMessage(FWindow.Handle, WM_PAINT, WPARAM(Bmp.Canvas.Handle), 0);
          BitBlt(CtlCanvas.Handle, 0, 0, Bmp.Width, Bmp.Height,
            Bmp.Canvas.Handle, 0, 0, SRCCOPY);
          ValidateRect(FWindow.Handle, nil);
        finally
          CtlCanvas.Free;
          Bmp.Free;
        end;
      end;
    end
    else begin
      { Delphi's handling of canvases is different at design time -- child
        controls aren't clipped from a parent control's canvas, so the above
        offscreen rendering code doesn't work right at design-time }
      InvalidatePositions;
      FValidated := True;
      AutoSize(ASize.X, ASize.Y);
    end;
  end;
end;

function TTBView.UpdatePositions: TPoint;
{ Called whenever the size or orientation of a view changes. When items are
  added or removed from the view, InvalidatePositions must be called instead,
  otherwise the view may not be redrawn properly. }
begin
  Result.X := 0;
  Result.Y := 0;
  DoUpdatePositions(Result);
end;

procedure TTBView.AutoSize(AWidth, AHeight: Integer);
begin
end;

function TTBView.GetChevronItem: TTBCustomItem;
begin
  Result := nil;
end;

procedure TTBView.GetMargins(AOrientation: TTBViewOrientation;
  var Margins: TRect);
begin
  if AOrientation = tbvoFloating then begin
    Margins.Left := 4;
    Margins.Top := 2;
    Margins.Right := 4;
    Margins.Bottom := 1;
  end
  else begin
    Margins.Left := 0;
    Margins.Top := 0;
    Margins.Right := 0;
    Margins.Bottom := 0;
  end;
end;

function TTBView.GetMDIButtonsItem: TTBCustomItem;
begin
  Result := nil;
end;

function TTBView.GetMDISystemMenuItem: TTBCustomItem;
begin
  Result := nil;
end;

function TTBView.GetFont: TFont;
begin
  Result := ToolbarFont;
end;

procedure TTBView.DrawItem(Viewer: TTBItemViewer; DrawTo: TCanvas;
  Offscreen: Boolean);
const
  COLOR_MENUHILIGHT = 29;
  clMenuHighlight = TColor(COLOR_MENUHILIGHT or $80000000);
var
  Bmp: TBitmap;
  DrawToDC, BmpDC: HDC;
  DrawCanvas: TCanvas;
  R1, R2, R3: TRect;
  IsOpen, IsSelected, IsPushed: Boolean;
  ToolbarStyle: Boolean;
  UseDisabledShadow: Boolean;
  SaveIndex, SaveIndex2: Integer;
  BkColor: TColor;
begin
  ValidatePositions;

  if tbisInvalidated in Viewer.State then begin
    Offscreen := True;
    Exclude(Viewer.State, tbisInvalidated);
  end;

  R1 := Viewer.BoundsRect;
  if not Viewer.Show or IsRectEmpty(R1) or (Viewer.Item is TTBControlItem) then
    Exit;
  R2 := R1;
  OffsetRect(R2, -R2.Left, -R2.Top);

  IsOpen := FOpenViewer = Viewer;
  IsSelected := (FSelected = Viewer);
  IsPushed := IsSelected and (IsOpen or (FMouseOverSelected and FCapture));
  ToolbarStyle := Viewer.IsToolbarStyle;

  DrawToDC := DrawTo.Handle;
  Bmp := nil;
  { Must deselect any currently selected handles before calling SaveDC, because
    if they are left selected and DeleteObject gets called on them after the
    SaveDC call, it will fail on Win9x/Me, and thus leak GDI resources. }
  DrawTo.Refresh;
  SaveIndex := SaveDC(DrawToDC);
  try
    IntersectClipRect(DrawToDC, R1.Left, R1.Top, R1.Right, R1.Bottom);
    GetClipBox(DrawToDC, R3);
    if IsRectEmpty(R3) then
      Exit;

    if not Offscreen then begin
      MoveWindowOrg(DrawToDC, R1.Left, R1.Top);
      { Tweak the brush origin so that the checked background drawn behind
        checked items always looks the same regardless of whether the item
        is positioned on an even or odd Left or Top coordinate. }
      SetBrushOrgEx(DrawToDC, R1.Left and 1, R1.Top and 1, nil);
      DrawCanvas := DrawTo;
    end
    else begin
      Bmp := TBitmap.Create;
      Bmp.Width := R2.Right;
      Bmp.Height := R2.Bottom;
      DrawCanvas := Bmp.Canvas;
      BmpDC := DrawCanvas.Handle;
      SaveIndex2 := SaveDC(BmpDC);
      SetWindowOrgEx(BmpDC, R1.Left, R1.Top, nil);
      FWindow.Perform(WM_ERASEBKGND, WPARAM(BmpDC), 0);
      RestoreDC(BmpDC, SaveIndex2);
    end;

    { Initialize brush }
    if not ToolbarStyle and IsSelected then begin
      {$IFNDEF TB2K_USE_STRICT_O2K_MENU_STYLE}
      if AreFlatMenusEnabled then
        { Windows XP uses a different fill color for selected menu items when
          flat menus are enabled }
        DrawCanvas.Brush.Color := clMenuHighlight
      else
      {$ENDIF}
        DrawCanvas.Brush.Color := clHighlight;
    end
    else
      DrawCanvas.Brush.Style := bsClear;

    { Initialize font }
    DrawCanvas.Font.Assign(GetFont);
    if Viewer.Item.Enabled then begin
      if not ToolbarStyle and IsSelected then
        DrawCanvas.Font.Color := clHighlightText
      else begin
        if ToolbarStyle then
          DrawCanvas.Font.Color := clBtnText
        else
          DrawCanvas.Font.Color := tbMenuTextColor;
      end;
      UseDisabledShadow := False;
    end
    else begin
      DrawCanvas.Font.Color := clGrayText;
      { Use the disabled shadow if either:
        1. The item is a toolbar-style item.
        2. The item is not selected, and the background color equals the
           button-face color.
        3. The gray-text color is the same as the background color.
           Note: Windows actually uses dithered text in this case. }
      BkColor := ColorToRGB(TControlAccess(FWindow).Color);
      UseDisabledShadow := ToolbarStyle or
        (not IsSelected and (BkColor = ColorToRGB(clBtnFace))) or
        (ColorToRGB(clGrayText) = BkColor);
    end;

    Viewer.Paint(DrawCanvas, R2, IsSelected, IsPushed, UseDisabledShadow);

    if Offscreen then
      BitBlt(DrawToDC, R1.Left, R1.Top, Bmp.Width, Bmp.Height, DrawCanvas.Handle,
        0, 0, SRCCOPY);
  finally
    DrawTo.Refresh;  { must do this before a RestoreDC }
    RestoreDC(DrawToDC, SaveIndex);
    Bmp.Free;
  end;
end;

procedure TTBView.DrawSubitems(ACanvas: TCanvas);
var
  I: Integer;
begin
  for I := 0 to FViewerCount-1 do begin
    if (vsDrawInOrder in FState) or (FViewers[I] <> FSelected) then
      DrawItem(FViewers[I], ACanvas, False);
  end;
  if not(vsDrawInOrder in FState) and Assigned(FSelected) then
    DrawItem(FSelected, ACanvas, False);

  Exclude(FState, vsDrawInOrder);
end;

procedure TTBView.Invalidate(AViewer: TTBItemViewer);
begin
  if not FValidated or not Assigned(FWindow) or not FWindow.HandleAllocated then
    Exit;
  if AViewer.Show and not IsRectEmpty(AViewer.BoundsRect) and
     not(AViewer.Item is TTBControlItem) then begin
    Include(AViewer.State, tbisInvalidated);
    InvalidateRect(FWindow.Handle, @AViewer.BoundsRect, False);
  end;
end;

procedure TTBView.SetAccelsVisibility(AShowAccels: Boolean);
var
  I: Integer;
  Viewer: TTBItemViewer;
begin
  { Always show accels when keyboard cues are enabled }
  AShowAccels := AShowAccels or not(vsUseHiddenAccels in FStyle) or
    AreKeyboardCuesEnabled;
  if AShowAccels <> (vsShowAccels in FState) then begin
    if AShowAccels then
      Include(FState, vsShowAccels)
    else
      Exclude(FState, vsShowAccels);
    if Assigned(FWindow) and FWindow.HandleAllocated and
       IsWindowVisible(FWindow.Handle) then
      { ^ the visibility check is just an optimization }
      for I := 0 to FViewerCount-1 do begin
        Viewer := FViewers[I];
        if Viewer.CaptionShown and
           (FindAccelChar(Viewer.GetCaptionText) <> #0) then
          Invalidate(Viewer);
      end;
  end;
end;

function TTBView.FirstSelectable: TTBItemViewer;
var
  FirstViewer: TTBItemViewer;
begin
  Result := NextSelectable(nil, True);
  if Assigned(Result) then begin
    FirstViewer := Result;
    while tbisDontSelectFirst in Result.Item.ItemStyle do begin
      Result := NextSelectable(Result, True);
      if Result = FirstViewer then
        { don't loop endlessly if all items have the tbisDontSelectFirst style }
        Break;
    end;
  end;
end;

function TTBView.NextSelectable(CurViewer: TTBItemViewer;
  GoForward: Boolean): TTBItemViewer;
var
  I, J: Integer;
begin
  ValidatePositions;
  Result := nil;
  if FViewerCount = 0 then Exit;
  J := -1;
  I := IndexOf(CurViewer);
  while True do begin
    if GoForward then begin
      Inc(I);
      if I >= FViewerCount then I := 0;
    end
    else begin
      Dec(I);
      if I < 0 then I := FViewerCount-1;
    end;
    if J = -1 then
      J := I
    else
      if I = J then
        Exit;
    if (FViewers[I].Show or FViewers[I].Clipped) and FViewers[I].Item.Visible and
       (tbisSelectable in FViewers[I].Item.ItemStyle) then
      Break;
  end;
  Result := FViewers[I];
end;

function TTBView.NextSelectableWithAccel(CurViewer: TTBItemViewer;
  Key: Char; RequirePrimaryAccel: Boolean; var IsOnlyItemWithAccel: Boolean): TTBItemViewer;

  function IsAccelItem(const Index: Integer;
    const Primary, EnabledItems: Boolean): Boolean;
  var
    S: String;
    LastAccel: Char;
    Viewer: TTBItemViewer;
    Item: TTBCustomItem;
  begin
    Result := False;
    Viewer := FViewers[Index];
    Item := Viewer.Item;
    if (Viewer.Show or Viewer.Clipped) and (tbisSelectable in Item.ItemStyle) and
       (Item.Enabled = EnabledItems) and
       Item.Visible and Viewer.CaptionShown then begin
      S := Viewer.GetCaptionText;
      if S <> '' then begin
        LastAccel := FindAccelChar(S);
        if Primary then begin
          if LastAccel <> #0 then
            Result := AnsiCompareText(LastAccel, Key) = 0;
        end
        else
          if (LastAccel = #0) and (Key <> ' ') then
            Result := AnsiCompareText(S[1], Key) = 0;
      end;
    end;
  end;

  function FindAccel(I: Integer;
    const Primary, EnabledItems: Boolean): Integer;
  var
    J: Integer;
  begin
    Result := -1;
    J := -1;
    while True do begin
      Inc(I);
      if I >= FViewerCount then I := 0;
      if J = -1 then
        J := I
      else
        if I = J then
          Break;
      if IsAccelItem(I, Primary, EnabledItems) then begin
        Result := I;
        Break;
      end;
    end;
  end;

var
  Start, I: Integer;
  Primary, EnabledItems: Boolean;
begin
  ValidatePositions;
  Result := nil;
  IsOnlyItemWithAccel := False;
  if FViewerCount = 0 then Exit;

  Start := IndexOf(CurViewer);
  for Primary := True downto False do
    if not RequirePrimaryAccel or Primary then
      for EnabledItems := True downto False do begin
        I := FindAccel(Start, Primary, EnabledItems);
        if I <> -1 then begin
          Result := FViewers[I];
          IsOnlyItemWithAccel := not EnabledItems or
            (FindAccel(I, Primary, EnabledItems) = I);
          Exit;
        end;
      end;
end;

procedure TTBView.EnterToolbarLoop(Options: TTBEnterToolbarLoopOptions);
var
  ModalHandler: TTBModalHandler;
  DoneActionData: TTBDoneActionData;
  P: TPoint;
begin
  if vsModal in FState then Exit;
  FillChar(DoneActionData, SizeOf(DoneActionData), 0);
  ModalHandler := TTBModalHandler.Create(FWindow.Handle);
  try
    { remove all states except... }
    FState := FState * [vsShowAccels];
    try
      Include(FState, vsModal);
      { Now that the vsModal state has been added, send an MSAA focus event }
      if Assigned(Selected) then
        NotifyFocusEvent;
      ModalHandler.Loop(Self, tbetMouseDown in Options,
        tbetDropDownMenus in Options, tbetKeyboardControl in Options, False,
        DoneActionData);
    finally
      { Remove vsModal state from the root view before any TTBView.Destroy
        methods get called (as a result of the CloseChildPopups call below),
        so that NotifyFocusEvent becomes a no-op }
      Exclude(FState, vsModal);
      StopAllTimers;
      CloseChildPopups;
      GetCursorPos(P);
      UpdateSelection(@P, True);
    end;
  finally
    ModalHandler.Free;
  end;
  SetAccelsVisibility(False);
  Selected := nil;
  // caused flicker: FWindow.Update;
  ProcessDoneAction(DoneActionData);
end;

procedure TTBView.CloseChildPopups;
begin
  if Assigned(FOpenViewerView) then
    FOpenViewerView.CloseChildPopups;
  FOpenViewerWindow.Free;
  FOpenViewerWindow := nil;
  FOpenViewerView := nil;
  FOpenViewer := nil;
end;

procedure TTBView.SetCustomizing(Value: Boolean);
begin
  if FCustomizing <> Value then begin
    FCustomizing := Value;
    RecreateAllViewers;
  end;
end;

procedure TTBView.BeginUpdate;
begin
  Inc(FUpdating);
end;

procedure TTBView.EndUpdate;
begin
  Dec(FUpdating);
  if FUpdating = 0 then
    TryValidatePositions;
end;

procedure TTBView.GetOffEdgeControlList(const List: TList);
var
  I: Integer;
  Item: TTBCustomItem;
begin
  for I := 0 to FViewerCount-1 do begin
    Item := FViewers[I].Item;
    if (Item is TTBControlItem) and FViewers[I].OffEdge and
       (TTBControlItem(Item).FControl is TWinControl) then
      List.Add(TTBControlItem(Item).FControl);
  end;
end;

procedure TTBView.SetCapture;
begin
  FCapture := True;
end;

procedure TTBView.CancelCapture;
begin
  if FCapture then begin
    FCapture := False;
    LastPos.X := Low(LastPos.X);
    if Assigned(FSelected) then
      FSelected.LosingCapture;
  end;
end;

procedure TTBView.KeyDown(var Key: Word; Shift: TShiftState;
  var EventData: TTBItemEventData);

  procedure SelNextItem(const ParentView: TTBView; const GoForward: Boolean);
  var
    NewSelected: TTBItemViewer;
  begin
    NewSelected := ParentView.NextSelectable(ParentView.FSelected,
      GoForward);
    { So that MSAA receives events in the right order, close child popups
      *before* changing selection }
    if (ParentView.Selected <> NewSelected) and
       Assigned(ParentView.FOpenViewer) then
      ParentView.CloseChildPopups;
    ParentView.Selected := NewSelected;
    ParentView.ScrollSelectedIntoView;
  end;

  procedure AutoOpenPopup(const View: TTBView);
  begin
    if (vsDropDownMenus in View.FState) and Assigned(View.FSelected) and
       not(tbisNoAutoOpen in View.FSelected.Item.ItemStyle) then
      View.OpenChildPopup(True)
    else
      View.CloseChildPopups;
  end;

  procedure HelpKey;
  var
    V: TTBView;
    ContextID: Integer;
  begin
    ContextID := 0;
    V := Self;
    while Assigned(V) do begin
      if Assigned(V.FSelected) then begin
        ContextID := V.FSelected.Item.HelpContext;
        if ContextID <> 0 then Break;
      end;
      V := V.FParentView;
    end;
    if ContextID <> 0 then begin
      EventData.DoneActionData.DoneAction := tbdaHelpContext;
      EventData.DoneActionData.ContextID := ContextID;
      EventData.CancelLoop := True;
    end;
  end;

var
  ParentTBView: TTBView;
begin
  ParentTBView := GetParentToolbarView;
  case Key of
    VK_TAB: begin
        SelNextItem(Self, GetKeyState(VK_SHIFT) >= 0);
      end;
    VK_RETURN: begin
        if Assigned(FSelected) and FSelected.Item.Enabled then begin
          if ClickSelectedItem(EventData) then
            EventData.CancelLoop := True;
        end
        else
          EventData.CancelLoop := True;
      end;
    VK_MENU, VK_F10: begin
        EventData.CancelLoop := True;
      end;
    VK_ESCAPE: begin
        Key := 0;
        if Self = EventData.RootView then
          EventData.CancelLoop := True
        else begin
          if FParentView.FIsToolbar then
            Exclude(FParentView.FState, vsDropDownMenus);
          FParentView.CloseChildPopups;
        end;
      end;
    VK_LEFT, VK_RIGHT: begin
        if (Self = ParentTBView) and (Orientation = tbvoVertical) then begin
          if OpenChildPopup(True) then
            Include(ParentTBView.FState, vsDropDownMenus);
        end
        else if Key = VK_LEFT then begin
          if Assigned(ParentTBView) and (ParentTBView.Orientation <> tbvoVertical) then begin
            if (Self = ParentTBView) or
               (FParentView = ParentTBView) then begin
              SelNextItem(ParentTBView, False);
              AutoOpenPopup(ParentTBView);
            end
            else
              FParentView.CloseChildPopups;
          end
          else
            if Self <> EventData.RootView then begin
              if FParentView.FIsToolbar then
                Exclude(FParentView.FState, vsDropDownMenus);
              FParentView.CloseChildPopups;
            end;
        end
        else begin
          if ((Self = ParentTBView) or not OpenChildPopup(True)) and
             (Assigned(ParentTBView) and (ParentTBView.Orientation <> tbvoVertical)) then begin
            { If we're on ParentTBView, or if the selected item can't display
              a submenu, proceed to next item on ParentTBView }
            SelNextItem(ParentTBView, True);
            AutoOpenPopup(ParentTBView);
          end;
        end;
      end;
    VK_UP, VK_DOWN: begin
        if (Self = ParentTBView) and (Orientation <> tbvoVertical) then begin
          if OpenChildPopup(True) then
            Include(ParentTBView.FState, vsDropDownMenus);
        end
        else
          SelNextItem(Self, Key = VK_DOWN);
      end;
    VK_HOME, VK_END: begin
        Selected := NextSelectable(nil, Key = VK_HOME);
        ScrollSelectedIntoView;
      end;
    VK_F1: HelpKey;
  else
    Exit;  { don't set Key to 0 for unprocessed keys }
  end;
  Key := 0;
end;

function TTBView.ClickSelectedItem(var EventData: TTBItemEventData): Boolean;
{ Returns True if modal loop should be canceled }
var
  Item: TTBCustomItem;
begin
  Item := FSelected.Item;
  if not(tbisCombo in Item.ItemStyle) and OpenChildPopup(True) then begin
    if Self = GetParentToolbarView then
      Include(FState, vsDropDownMenus);
    Result := False;
    Exit;
  end;
  if Assigned(Item) and (tbisSelectable in Item.ItemStyle) then begin
    GivePriority(FSelected);
    EventData.DoneActionData.DoneAction := tbdaClickItem;
    EventData.DoneActionData.ClickItem := Item;
    EventData.DoneActionData.Sound := (Self <> EventData.RootView) or
      EventData.RootView.FIsPopup;
  end;
  Result := True;
  Exit; asm db 0,'Toolbar2000 (C) 1998-2002 Jordan Russell',0 end;
end;

procedure TTBView.Scroll(ADown: Boolean);
var
  CurPos, NewPos, I: Integer;
begin
  ValidatePositions;
  if ADown then begin
    NewPos := High(NewPos);
    CurPos := FMaxHeight - tbMenuScrollArrowHeight;
    for I := 0 to FViewerCount-1 do begin
      with FViewers[I] do
        if Clipped and not(tbisSeparator in Item.ItemStyle) and
          (BoundsRect.Bottom < NewPos) and (BoundsRect.Bottom > CurPos) then
          NewPos := BoundsRect.Bottom;
    end;
    if NewPos = High(NewPos) then
      Exit;
    Dec(NewPos, FMaxHeight - tbMenuScrollArrowHeight);
  end
  else begin
    NewPos := Low(NewPos);
    CurPos := tbMenuScrollArrowHeight;
    for I := 0 to FViewerCount-1 do begin
      with FViewers[I] do
        if Clipped and not(tbisSeparator in Item.ItemStyle) and
          (BoundsRect.Top > NewPos) and (BoundsRect.Top < CurPos) then
          NewPos := BoundsRect.Top;
    end;
    if NewPos = Low(NewPos) then
      Exit;
    Dec(NewPos, tbMenuScrollArrowHeight);
  end;
  Inc(FScrollOffset, NewPos);
  UpdatePositions;
end;

procedure TTBView.ScrollSelectedIntoView;
begin
  ValidatePositions;
  if (FSelected = nil) or not FSelected.Clipped then
    Exit;

  if FSelected.BoundsRect.Top < tbMenuScrollArrowHeight then begin
    Dec(FScrollOffset, tbMenuScrollArrowHeight - FSelected.BoundsRect.Top);
    UpdatePositions;
  end
  else if FSelected.BoundsRect.Bottom > FMaxHeight - tbMenuScrollArrowHeight then begin
    Dec(FScrollOffset, (FMaxHeight - tbMenuScrollArrowHeight) -
      FSelected.BoundsRect.Bottom);
    UpdatePositions;
  end;
end;

procedure TTBView.SetUsePriorityList(Value: Boolean);
begin
  if FUsePriorityList <> Value then begin
    FUsePriorityList := Value;
    RecreateAllViewers;
  end;
end;


{ TTBModalHandler }

constructor TTBModalHandler.Create(AExistingWnd: HWND);
begin
  inherited Create;
  LastPos := SmallPointToPoint(TSmallPoint(GetMessagePos()));
  if AExistingWnd <> 0 then
    FWnd := AExistingWnd
  else begin
    FWnd := {$IFDEF JR_D6}Classes.{$ENDIF} AllocateHWnd(nil);
    FCreatedWnd := True;
  end;
  SetCapture(FWnd);
  SetCursor(LoadCursor(0, IDC_ARROW));
  CallNotifyWinEvent(EVENT_SYSTEM_MENUSTART, FWnd, OBJID_CLIENT, CHILDID_SELF);
  FInited := True;
end;

destructor TTBModalHandler.Destroy;
begin
  if FWnd <> 0 then begin
    if GetCapture = FWnd then
      ReleaseCapture;
    if FInited then
      CallNotifyWinEvent(EVENT_SYSTEM_MENUEND, FWnd, OBJID_CLIENT, CHILDID_SELF);
    if FCreatedWnd then
      {$IFDEF JR_D6}Classes.{$ENDIF} DeallocateHWnd(FWnd);
  end;
  inherited;
end;

procedure TTBModalHandler.Loop(const RootView: TTBView;
  const AMouseDown, ADropDownMenus, KeyboardControl, TrackRightButton: Boolean;
  var DoneActionData: TTBDoneActionData);
var
  EventData: TTBItemEventData;

  function GetActiveView: TTBView;
  begin
    Result := RootView;
    while Assigned(Result.FOpenViewerView) do
      Result := Result.FOpenViewerView;
  end;

  procedure UpdateAllSelections(const P: TPoint; const AllowNewSelection: Boolean);
  var
    View, CapView: TTBView;
  begin
    View := GetActiveView;

    CapView := View;
    while Assigned(CapView) and not CapView.FCapture do
      CapView := CapView.FParentView;

    while Assigned(View) do begin
      if (CapView = nil) or (View = CapView) then
        View.UpdateSelection(@P, AllowNewSelection);
      View := View.FParentView;
    end;
  end;

  function GetSelectedViewer(var AView: TTBView; var AViewer: TTBItemViewer): Boolean;
  { Returns True if AViewer <> nil. }
  var
    View: TTBView;
  begin
    AView := nil;
    AViewer := nil;
    { Look for a capture item first }
    View := RootView;
    repeat
      if View.FCapture then begin
        AView := View;
        AViewer := View.FSelected;
        Break;
      end;
      View := View.FOpenViewerView;
    until View = nil;
    if View = nil then begin
      View := RootView;
      repeat
        if Assigned(View.FSelected) and View.FMouseOverSelected then begin
          AView := View;
          AViewer := View.FSelected;
          Break;
        end;
        if vsMouseInWindow in View.FState then begin
          { ...there is no current selection, but the mouse is still in the
            window. This can happen if the mouse is over the non-client area
            of the toolbar or popup window, or in an area not containing an
            item. }
          AView := View;
          Break;
        end;
        View := View.FOpenViewerView;
      until View = nil;
    end;
    Result := Assigned(AViewer);
  end;

  function ContinueLoop: Boolean;
  begin
    Result := GetCapture = FWnd;
  end;

  function SendKeyEvent(const View: TTBView; var Key: Word;
    const Shift: TShiftState): Boolean;
  begin
    Result := True;
    if Assigned(View.FSelected) then begin
      View.FSelected.KeyDown(Key, Shift, EventData);
      if EventData.CancelLoop then
        Exit;
    end;
    if Key <> 0 then begin
      View.KeyDown(Key, Shift, EventData);
      if EventData.CancelLoop then
        Exit;
    end;
    Result := False;
  end;

  procedure DoHintMouseMessage(const Ctl: TControl; const P: TPoint);
  var
    M: TWMMouseMove;
  begin
    M.Msg := WM_MOUSEMOVE;
    M.Keys := 0;
    M.Pos := PointToSmallPoint(P);
    Application.HintMouseMessage(Ctl, TMessage(M));
  end;

  procedure MouseMoved;
  var
    View: TTBView;
    Cursor: HCURSOR;
    Item: TTBCustomItem;
    P: TPoint;
    R: TRect;
  begin
    UpdateAllSelections(LastPos, True);
    View := GetActiveView;
    Cursor := 0;
    if Assigned(View.FSelected) and Assigned(View.FWindow) then begin
      Item := View.FSelected.Item;
      P := View.FWindow.ScreenToClient(LastPos);
      if ((vsAlwaysShowHints in View.FStyle) or
          (tboShowHint in Item.FEffectiveOptions)) and not View.FCapture then begin
        { Display popup hint for the item. Update is called
          first to minimize flicker caused by the hiding &
          showing of the hint window. }
        View.FWindow.Update;
        DoHintMouseMessage(View.FWindow, P);
      end
      else
        Application.CancelHint;
      R := View.FSelected.BoundsRect;
      Dec(P.X, R.Left);
      Dec(P.Y, R.Top);
      View.FSelected.GetCursor(P, Cursor);
    end
    else
      Application.CancelHint;
    if Cursor = 0 then
      Cursor := LoadCursor(0, IDC_ARROW);
    SetCursor(Cursor);
  end;

  procedure UpdateAppHint;
  var
    View: TTBView;
  begin
    View := RootView;
    while Assigned(View.FOpenViewerView) and Assigned(View.FOpenViewerView.FSelected) do
      View := View.FOpenViewerView;
    if Assigned(View.FSelected) then
      Application.Hint := GetLongHint(View.FSelected.Item.Hint)
    else
      Application.Hint := '';
  end;

  procedure HandleTimer(const View: TTBView; const ID: TTBViewTimerID);
  begin
    case ID of
      tiOpen: begin
          { Similar to standard menus, always close child popups, even if
            Selected = OpenViewer. }
          View.CloseChildPopups;
          { Note: OpenChildPopup stops the tiClose and tiOpen timers. }
          View.OpenChildPopup(False);
        end;
      tiClose: begin
          View.StopTimer(tiClose);
          View.CloseChildPopups;
        end;
      tiScrollUp: begin
          if View.FShowUpArrow then
            View.Scroll(False)
          else
            View.StopTimer(tiScrollUp);
        end;
      tiScrollDown: begin
          if View.FShowDownArrow then
            View.Scroll(True)
          else
            View.StopTimer(tiScrollDown);
        end;
    end;
  end;

var
  FirstLoop: Boolean;
  Msg: TMsg;
  P: TPoint;
  Ctl: TControl;
  View: TTBView;
  IsOnlyItemWithAccel: Boolean;
  MouseIsDown: Boolean;
  Key: Word;
  Shift: TShiftState;
  Viewer: TTBItemViewer;
begin
  RootView.ValidatePositions;
  if ADropDownMenus then
    Include(RootView.FState, vsDropDownMenus)
  else
    Exclude(RootView.FState, vsDropDownMenus);
  try
  try
    EventData.RootView := RootView;
    EventData.CaptureWnd := FWnd;
    EventData.MouseDownOnMenu := False;
    EventData.CancelLoop := False;
    EventData.DoneActionData := @DoneActionData;
    if AMouseDown then begin
      P := RootView.FSelected.ScreenToClient(SmallPointToPoint(TSmallPoint(GetMessagePos())));
      RootView.FSelected.MouseDown([], P.X, P.Y, EventData);
      if EventData.CancelLoop then
        Exit;
      EventData.MouseDownOnMenu := False;  { never set MouseDownOnMenu to True on first click }
    end;
    if vsDropDownMenus in RootView.FState then
      RootView.OpenChildPopup(KeyboardControl);
    FirstLoop := True;
    while ContinueLoop do begin
      if not FirstLoop then
        WaitMessage;
      FirstLoop := False;
      while ContinueLoop and PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) do begin
        case Msg.message of
          WM_LBUTTONDOWN, WM_RBUTTONDOWN: begin
              P := SmallPointToPoint(TSmallPoint(Msg.lParam));
              Windows.ClientToScreen(Msg.hwnd, P);
              Ctl := FindDragTarget(P, True);
              { Was the mouse not clicked on a popup, or was it clicked on a
                popup that is not a child of RootView?
                (The latter can happen when in customization mode, for example,
                if the user right-clicks a popup menu being customized and
                the context menu is displayed.) }
              if not(Ctl is TTBPopupWindow) or
                 not RootView.ContainsView(TTBPopupWindow(Ctl).View) then begin
                { If the root view is a popup, or if the root view is a toolbar
                  and the user clicked outside the toolbar or in its non-client
                  area (e.g. on its drag handle), exit }
                if RootView.FIsPopup or (Ctl <> RootView.FWindow) or
                   not PtInRect(RootView.FWindow.ClientRect, RootView.FWindow.ScreenToClient(P)) then
                  Exit
                else
                  if Msg.message = WM_LBUTTONDOWN then begin
                    { If the user clicked inside a toolbar on anything but an
                      item, exit }
                    UpdateAllSelections(P, True);
                    if (RootView.FSelected = nil) or not RootView.FMouseOverSelected or
                       (tbisClicksTransparent in RootView.FSelected.Item.ItemStyle) then
                      Exit;
                  end;
              end;
          end;
        end;
        if PeekMessage(Msg, 0, 0, 0, PM_REMOVE or PM_NOYIELD) then begin
          case Msg.message of
            $4D:
              { This undocumented message is sent to the focused window when
                F1 is pressed. Windows handles it by sending a WM_HELP message
                to the same window. We don't want this to happen while a menu
                is up, so swallow the message. }
              ;
            WM_CONTEXTMENU:
              { Windows still sends WM_CONTEXTMENU messages for "context menu"
                keystrokes even if WM_KEYUP messages are never dispatched,
                so it must specifically ignore this message }
              ;
            WM_KEYFIRST..WM_KEYLAST: begin
                Application.CancelHint;
                MouseIsDown := (GetKeyState(VK_LBUTTON) < 0) or
                  (TrackRightButton and (GetKeyState(VK_RBUTTON) < 0));
                case Msg.message of
                  WM_KEYDOWN, WM_SYSKEYDOWN:
                    begin
                      if Msg.wParam = VK_PROCESSKEY then
                        { Don't let IME process the key }
                        Msg.wParam := ImmGetVirtualKey(Msg.hwnd);
                      if not MouseIsDown or (Msg.wParam = VK_F1) then begin
                        Key := Word(Msg.wParam);
                        if SendKeyEvent(GetActiveView, Key,
                           KeyDataToShiftState(Msg.lParam)) then
                          Exit;
                        { If it's not handled by a KeyDown method, translate
                          it into a WM_*CHAR message }
                        if Key <> 0 then
                          TranslateMessage(Msg);
                      end;
                    end;
                  WM_CHAR, WM_SYSCHAR:
                    if not MouseIsDown then begin
                      View := GetActiveView;
                      Viewer := View.NextSelectableWithAccel(View.FSelected,
                        Chr(Msg.WParam), False, IsOnlyItemWithAccel);
                      if Viewer = nil then begin
                        if (Msg.WParam in [VK_SPACE, Ord('-')]) and
                           not RootView.FIsPopup and (View = RootView) and
                           (GetActiveWindow <> 0) then begin
                          EventData.DoneActionData.DoneAction := tbdaOpenSystemMenu;
                          EventData.DoneActionData.Wnd := GetActiveWindow;
                          EventData.DoneActionData.Key := Msg.WParam;
                          Exit;
                        end
                        else
                          MessageBeep(0);
                      end
                      else begin
                        View.Selected := Viewer;
                        if IsOnlyItemWithAccel then begin
                          { Simulate an Enter key press }
                          Key := VK_RETURN;
                          if SendKeyEvent(View, Key, []) then
                            Exit;
                        end;
                        View.ScrollSelectedIntoView;
                      end;
                    end;
                end;
              end;
            WM_TIMER:
              begin
                Ctl := FindControl(Msg.hwnd);
                if Assigned(Ctl) and (Ctl is TTBPopupWindow) and
                   (Msg.wParam >= ViewTimerBaseID + Ord(Low(TTBViewTimerID))) and
                   (Msg.wParam <= ViewTimerBaseID + Ord(High(TTBViewTimerID))) then begin
                  if Assigned(TTBPopupWindow(Ctl).FView) then
                    HandleTimer(TTBPopupWindow(Ctl).FView,
                      TTBViewTimerID(WPARAM(Msg.wParam - ViewTimerBaseID)));
                end
                else
                  DispatchMessage(Msg);
              end;
            $118: ;
                { ^ Like standard menus, don't dispatch WM_SYSTIMER messages
                  (the internal Windows message used for things like caret
                  blink and list box scrolling). }
            WM_MOUSEFIRST..WM_MOUSELAST:
              case Msg.message of
                WM_MOUSEMOVE: begin
                    if (Msg.pt.X <> LastPos.X) or (Msg.pt.Y <> LastPos.Y) then begin
                      LastPos := Msg.pt;
                      MouseMoved;
                    end;
                    if GetSelectedViewer(View, Viewer) then begin
                      P := Viewer.ScreenToClient(Msg.pt);
                      Viewer.MouseMove(P.X, P.Y, EventData);
                    end;
                  end;
                WM_MOUSEWHEEL:
                  if GetSelectedViewer(View, Viewer) then begin
                    P := Viewer.ScreenToClient(Msg.pt);
                    Viewer.MouseWheel(Smallint(LongRec(Msg.wParam).Hi), P.X, P.Y, EventData);
                  end;
                WM_LBUTTONDOWN, WM_LBUTTONDBLCLK, WM_RBUTTONDOWN:
                  if (Msg.message <> WM_RBUTTONDOWN) or TrackRightButton then begin
                    Application.CancelHint;
                    EventData.MouseDownOnMenu := False;
                    Exclude(RootView.FState, vsIgnoreFirstMouseUp);
                    UpdateAllSelections(Msg.pt, True);
                    if GetSelectedViewer(View, Viewer) then begin
                      if Msg.message <> WM_LBUTTONDBLCLK then
                        Shift := []
                      else
                        Shift := [ssDouble];
                      P := Viewer.ScreenToClient(Msg.pt);
                      Viewer.MouseDown(Shift, P.X, P.Y, EventData);
                      if EventData.CancelLoop then
                        Exit;
                      LastPos := SmallPointToPoint(TSmallPoint(GetMessagePos()));
                    end;
                  end;
                WM_LBUTTONUP, WM_RBUTTONUP:
                  if (Msg.message = WM_LBUTTONUP) or TrackRightButton then begin
                    UpdateAllSelections(Msg.pt, False);
                    { ^ False is used so that when a popup menu is
                      displayed with the cursor currently inside it, the item
                      under the cursor won't be accidentally selected when the
                      user releases the button. The user must move the mouse at
                      at least one pixel (generating a WM_MOUSEMOVE message),
                      and then release the button. }
                    if not GetSelectedViewer(View, Viewer) then begin
                      { Mouse was not released over any item. Cancel out of the
                        loop if it's outside all views, or is inside unused
                        space on a topmost toolbar }
                      if not Assigned(View) or
                         ((View = RootView) and RootView.FIsToolbar) then begin
                        if not(vsIgnoreFirstMouseUp in RootView.FState) then
                          Exit
                        else
                          Exclude(RootView.FState, vsIgnoreFirstMouseUp);
                      end;
                    end
                    else begin
                      P := Viewer.ScreenToClient(Msg.pt);
                      Viewer.MouseUp(P.X, P.Y, EventData);
                      if EventData.CancelLoop then
                        Exit;
                    end;
                  end;
              end;
          else
            DispatchMessage(Msg);
          end;
          if LastPos.X = Low(LastPos.X) then begin
            LastPos := SmallPointToPoint(TSmallPoint(GetMessagePos()));
            MouseMoved;
          end;
          UpdateAppHint;
        end;
      end;
    end;
  finally
    RootView.CancelCapture;
  end;
  finally
    Application.Hint := '';
    { Make sure there are no outstanding WM_*CHAR messages }
    RemoveMessages(WM_CHAR, WM_DEADCHAR);
    RemoveMessages(WM_SYSCHAR, WM_SYSDEADCHAR);
    { Nor any outstanding 'send WM_HELP' messages caused by an earlier press
      of the F1 key }
    RemoveMessages($4D, $4D);
  end;
end;


{ TTBPopupView }

procedure TTBPopupView.AutoSize(AWidth, AHeight: Integer);
//Skin Patch Begin
var
  FWidth: Integer;
begin
  FWidth := AWidth + (PopupMenuWindowNCSize * 2);

  if (Skin <> nil) and (Skin.SkinType = tbsOfficeXP) then
    Dec(FWidth);
//Skin Patch End

  with FWindow do
    SetBounds(Left, Top, FWidth, //Skin Patch
      AHeight + (PopupMenuWindowNCSize * 2));
end;

function TTBPopupView.GetFont: TFont;
begin
  Result := (Owner as TTBPopupWindow).Font;
end;


{ TTBPopupWindow }

constructor TTBPopupWindow.CreatePopupWindow(AOwner: TComponent;
  const AParentView: TTBView; const AItem: TTBCustomItem;
  const ACustomizing: Boolean);
//Skin Patch Begin
Var
 CSkin: TTBBaseSkin;
 Skinned: Boolean;
//Skin Patch End
begin
  inherited Create(AOwner);
  Visible := False;
  SetBounds(0, 0, 320, 240);
  ControlStyle := ControlStyle - [csCaptureMouse];
  Color := tbMenuBkColor;
  ShowHint := True;

//Skin Patch Begin
 if Assigned(AParentView) and Assigned(AParentView.FSkin) and
    not (AParentView.FSkin.SkinType = tbsDisabled) then
    CSkin := AParentView.FSkin
  else if Assigned(FSkin) and not (FSkin.SkinType = tbsDisabled) then
    CSkin := FSkin
  else if Assigned(AItem) and Assigned(AItem.FSkin) and not (AItem.FSkin.SkinType = tbsDisabled) then
    CSkin := AItem.FSkin
  else if not (DefaultSkin.SkinType in [tbsDisabled, tbsNativeXP]) then
    CSkin := DefaultSkin Else CSkin := Nil;

  Skinned := Assigned(CSkin);
//Skin Patch End

  { Inherit the font from the parent view, or use the system menu font if
    there is no parent view }
  if Assigned(AParentView) then
    Font.Assign(AParentView.GetFont)
  else
    Font.Assign(ToolbarFont);

  FView := GetViewClass.CreateView(Self, AParentView, AItem, Self, False,
    ACustomizing, False);
  Include(FView.FState, vsModal);

//Skin Patch Begin
  Skin := CSkin;
  FView.FSkin := CSkin;

  if Skinned and (tboShadow in CSkin.Options) then begin
   FShadowPR := TShadow.Create(Nil, True, True);
   FShadowPB := TShadow.Create(Nil, False, True);

   FShadowPR.ShadowStyle := CSkin.ShadowStyle;
   FShadowPB.ShadowStyle := CSkin.ShadowStyle;

   if Assigned(AParentView) and (CSkin.SkinType = tbsOfficeXP) then begin
     FShadowIR := TShadow.Create(Nil, True, False);

     if not ((aparentview.FOrientation = tbvoHorizontal) and
             (PopupPosition = tbpTop)) then
       FShadowIB := TShadow.Create(Nil, False, False);
   end;
  end;

  if Skinned then
    Color := CSkin.Colors.tcPopup
  else
//Skin Patch End

  { Inherit the accelerator visibility state from the parent view. If there
    is no parent view (i.e. it's a standalone popup menu), then default to
    hiding accelerator keys, but change this in CreateWnd if the last input
    came from the keyboard. }
  if Assigned(AParentView) then begin
    if vsUseHiddenAccels in AParentView.FStyle then
      Include(FView.FStyle, vsUseHiddenAccels);
    if vsShowAccels in AParentView.FState then
      Include(FView.FState, vsShowAccels);
  end
  else
    Include(FView.FStyle, vsUseHiddenAccels);

  if Application.Handle <> 0 then
    { Use Application.Handle if possible so that the taskbar button for the app
      doesn't pop up when a TTBEditItem on a popup menu is focused }
    ParentWindow := Application.Handle
  else
    { When Application.Handle is zero, use GetDesktopWindow() as the parent
      window, not zero, otherwise UpdateControlState won't show the window }
    ParentWindow := GetDesktopWindow;
end;

destructor TTBPopupWindow.Destroy;
begin
  Destroying;

//Skin Patch Begin
  if Assigned(FShadowPR) then
   FreeAndNil(FShadowPR);

  if Assigned(FShadowPB) then
   FreeAndNil(FShadowPB);

  if Assigned(FShadowIR) then
   FreeAndNil(FShadowIR);

  if Assigned(FShadowIB) then
   FreeAndNil(FShadowIB);
//Skin Patch End

  { Ensure window handle is destroyed *before* FView is freed, since
    DestroyWindowHandle calls CallNotifyWinEvent which may result in
    FView.HandleWMObject being called }
  if HandleAllocated then
    DestroyWindowHandle;
  FreeAndNil(FView);
  inherited;
end;

procedure TTBPopupWindow.BeforeDestruction;
begin
  { The inherited BeforeDestruction method hides the form. We need to close
    any child popups first, so that pixels behind the popups are properly
    restored without generating a WM_PAINT message. }
  if Assigned(FView) then
    FView.CloseChildPopups;
  inherited;
end;

function TTBPopupWindow.GetViewClass: TTBViewClass;
begin
  Result := TTBPopupView;
end;

procedure TTBPopupWindow.CreateParams(var Params: TCreateParams);
const
  CS_DROPSHADOW = $00020000;
//Skin Patch Begin
var
 ShowShadows: boolean;
//Skin Patch End
begin
  inherited;
  with Params do begin
    Style := (Style and not (WS_CHILD or WS_GROUP or WS_TABSTOP)) or WS_POPUP;
    ExStyle := ExStyle or WS_EX_TOPMOST or WS_EX_TOOLWINDOW;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    { Enable drop shadow effect on Windows XP and later }
//Skin Patch Begin
    if Assigned(FSkin) then
      ShowShadows := (FSkin.SkinType = tbsNativeXP) or (FSkin.SkinType = tbsDisabled)
    else
      ShowShadows := True;

     if IsWindowsXP and ShowShadows then
//Skin Patch End
       WindowClass.Style := WindowClass.Style or CS_DROPSHADOW;
  end;
end;

procedure TTBPopupWindow.CreateWnd;
const
  WM_CHANGEUISTATE = $0127;
  WM_QUERYUISTATE  = $0129;
  UIS_INITIALIZE = 3;
  UISF_HIDEACCEL = $2;
var
  B: Boolean;
begin
  inherited;
  { On a top-level popup window, send WM_CHANGEUISTATE & WM_QUERYUISTATE
    messages to the window to see if the last input came from the keyboard
    and if the accelerator keys should be shown }
  if (FView.ParentView = nil) and not FAccelsVisibilitySet then begin
    FAccelsVisibilitySet := True;
    SendMessage(Handle, WM_CHANGEUISTATE, UIS_INITIALIZE, 0);
    B := (SendMessage(Handle, WM_QUERYUISTATE, 0, 0) and UISF_HIDEACCEL = 0);
    FView.SetAccelsVisibility(B);
  end;
end;

procedure TTBPopupWindow.DestroyWindowHandle;
begin
  { Before destroying the window handle, we must stop any animation, otherwise
    the animation thread will use an invalid handle }
  TBEndAnimation(WindowHandle);
  { Cleanly destroy any timers before the window handle is destroyed }
  if Assigned(FView) then
    FView.StopAllTimers;
  CallNotifyWinEvent(EVENT_SYSTEM_MENUPOPUPEND, WindowHandle, OBJID_CLIENT,
    CHILDID_SELF);
  inherited;
end;

procedure TTBPopupWindow.WMGetObject(var Message: TMessage);
begin
  if not FView.HandleWMGetObject(Message) then
    inherited;
end;

procedure TTBPopupWindow.CMShowingChanged(var Message: TMessage);
const
  ShowFlags: array[Boolean] of UINT = (
    SWP_NOSIZE or SWP_NOMOVE or SWP_NOZORDER or SWP_NOACTIVATE or SWP_HIDEWINDOW,
    SWP_NOSIZE or SWP_NOMOVE or SWP_NOZORDER or SWP_NOACTIVATE or SWP_SHOWWINDOW);
  SPI_GETMENUFADE = $1012;
var
  Animate: BOOL;
  Blend: Boolean;
begin
  { Must override TCustomForm/TForm's CM_SHOWINGCHANGED handler so that the
    form doesn't get activated when Visible is set to True. }

  { Handle animation. NOTE: I do not recommend trying to enable animation on
    Windows 95 and NT 4.0 because there's a difference in the way the
    SetWindowPos works on those versions. See the comment in the
    TBStartAnimation function of TB2Anim.pas. }
  {$IFNDEF TB2K_NO_ANIMATION}
  if ((FView.ParentView = nil) or not(vsNoAnimation in FView.FParentView.FState)) and
     Showing and (FView.Selected = nil) and not IsWindowVisible(WindowHandle) and
     SystemParametersInfo(SPI_GETMENUANIMATION, 0, @Animate, 0) and Animate then begin
    Blend := SystemParametersInfo(SPI_GETMENUFADE, 0, @Animate, 0) and Animate;
    if Blend or (FAnimationDirection <> []) then begin
      TBStartAnimation(WindowHandle, 150, Blend, FAnimationDirection);
      Exit;
    end;
  end;
  {$ENDIF}

  { No animation... }
  if not Showing then begin
    { Call TBEndAnimation to ensure WS_EX_LAYERED style is removed before
      hiding, otherwise windows under the popup window aren't repainted
      properly. }
    TBEndAnimation(WindowHandle);
  end;
  SetWindowPos(WindowHandle, 0, 0, 0, 0, 0, ShowFlags[Showing]);
end;

procedure TTBPopupWindow.WMTB2kStepAnimation(var Message: TMessage);
begin
  TBStepAnimation(Message);
end;

procedure TTBPopupWindow.WMEraseBkgnd(var Message: TWMEraseBkgnd);
Var
  Brush: HBrush;
  R: TRect;
begin
  { May be necessary in some cases... }
  TBEndAnimation(WindowHandle);

//Skin Patch Begin
 if not (FSkin = nil) and not Assigned(FView.FChevronParentView) then begin
   R := ClientRect;

   if not (FSkin.SkinType in [tbsDisabled, tbsNativeXP]) then
     case FSkin.PopupStyle of
       tbpsGradVert,
       tbpsGradHorz: FillGradient(Message.DC, R, FSkin.Colors.tcPopupGradStart,
                       FSkin.Colors.tcPopupGradEnd,
                      TTBGradDir(FSkin.PopupStyle = tbpsGradVert));
       else inherited;
     end
   else
     inherited;

   if FView.ViewerCount >0 then
     R := Rect(R.Left, R.Top,  GetImgListMargin(FView.FViewers[0]), R.Bottom)
   else
     R := Rect(R.Left, R.Top, 0, R.Bottom);

   with FSkin do
   if SkinType in [tbsOfficeXP, tbsWindowsXP] then
   if (ImgBackStyle <> tbimsDefault) then
     FillGradient(Message.DC, R, Colors.tcImgGradStart, Colors.tcImgGradEnd,
       TTBGradDir(ImgBackStyle = tbimsGradVert))
   else
   begin
     Brush := CreateSolidBrush(FSkin.RGBColor(cImageList));
     FillRect(Message.DC, R, Brush);
     DeleteObject(Brush);
   end;
 end
 else //Skin Patch End
  inherited;
end;

procedure TTBPopupWindow.WMPaint(var Message: TWMPaint);
begin
  { Must abort animation when a WM_PAINT message is received }
  TBEndAnimation(WindowHandle);
  inherited;
end;

procedure TTBPopupWindow.Paint;
begin
  FView.DrawSubitems(Canvas);
  PaintScrollArrows;
end;

procedure TTBPopupWindow.PaintScrollArrows;

  procedure DrawArrow(const R: TRect; ADown: Boolean);
  var
    X, Y: Integer;
    P: array[0..2] of TPoint;
  begin
    X := (R.Left + R.Right) div 2;
    Y := (R.Top + R.Bottom) div 2;
    Dec(Y);
    P[0].X := X-3;
    P[0].Y := Y;
    P[1].X := X+3;
    P[1].Y := Y;
    P[2].X := X;
    P[2].Y := Y;
    if ADown then
      Inc(P[2].Y, 3)
    else begin
      Inc(P[0].Y, 3);
      Inc(P[1].Y, 3);
    end;
    Canvas.Pen.Color := tbMenuTextColor;
    Canvas.Brush.Color := tbMenuTextColor;
    Canvas.Polygon(P);
  end;

begin
  if FView.FShowUpArrow then
    DrawArrow(Rect(0, 0, ClientWidth, tbMenuScrollArrowHeight), False);
  if FView.FShowDownArrow then
    DrawArrow(Bounds(0, ClientHeight - tbMenuScrollArrowHeight,
      ClientWidth, tbMenuScrollArrowHeight), True);
end;

procedure TTBPopupWindow.WMClose(var Message: TWMClose);
begin
  { do nothing -- ignore Alt+F4 keypresses }
end;

procedure TTBPopupWindow.WMNCCalcSize(var Message: TWMNCCalcSize);
begin
  InflateRect(Message.CalcSize_Params^.rgrc[0],
    -PopupMenuWindowNCSize, -PopupMenuWindowNCSize);
//Skin Patch Begin
  if Assigned(FSkin) and (FSkin.SkinType = tbsOfficeXP) then
    InflateRect(Message.CalcSize_Params^.rgrc[0], 1, 0);
//Skin Patch End
  inherited;
end;

//Skin Patch Begin
procedure TTBPopupWindow.WMTB2kAnimationEnded(var Message: TMessage);
begin
 if Assigned(FShadowIR) then begin
    FShadowIR.Prepare;
    FShadowIR.Show;
 end;

 if Assigned(FShadowIB) then begin
   FShadowIB.Prepare;
   FShadowIB.Show;
 end;

 if Assigned(FShadowPR) then begin
   FShadowPR.Prepare;
   FShadowPR.Show;
 end;

 if Assigned(FShadowPB) then begin
   FShadowPB.Prepare;
   FShadowPB.Show;
 end;
end;

procedure ProcessSkinNCPaint(Wnd: HWND; DC: HDC; AppData: Longint);
Var
  Brush: HBrush;
  Pen,
  SavePen: HPen;
  ItemHeight,
  ItemWidth,
  I3, I4,
  ClipS, ClipE: Integer;
  PI, PP: TPoint;
  R, IR, IB, PR, PB, ItemRect, PopupRect: TRect;
  Orientation: TTBViewOrientation;
  IsCombo,
  IsChevron,
  MenuShadows: Boolean;
  Skin: TTBBaseSkin;
  Window: TTBPopupWindow;
  View: TTBView;
begin
  Skin := PTBData(AppData).Skin;
  Window := PTBData(AppData).Window;
  View := PTBData(AppData).View;

  I3 := 0;

  ClipS := -1;
  ClipE := -1;

  IsCombo := False;
  IsChevron := False;
  ItemHeight := 0;
  ItemWidth := 0;

  MenuShadows := (Skin.SkinType = tbsOfficeXP) and not PTBData(AppData).MDI;

  GetWindowRect(Wnd, R); OffsetRect(R, -R.Left, -R.Top);

  case Skin.SkinType of
   tbsNativeXP,
   tbsWindowsXP: begin
                  Brush := CreateSolidBrush(Skin.rgbColor(cBorder));
                  FrameRect(DC, R, Brush);
                  DeleteObject(Brush);

                  InflateRect(R, -1, -1);

                  Brush := CreateSolidBrush(Skin.rgbColor(cPopup));
                  FrameRect(DC, R, Brush);
                  DeleteObject(Brush);

                  InflateRect(R, -1, -1);

                  Brush := CreateSolidBrush(Skin.rgbColor(cPopup));
                  FrameRect(DC, R, Brush);
                  DeleteObject(Brush);

                  I3 := -2;
                 end;
    tbsOfficeXP: begin
                   Pen := CreatePen(PS_SOLID, 1, Skin.rgbColor(cPopup));
                   SavePen := SelectObject(DC, Pen);
                   PolyLineEx(DC, [Point(R.Left, R.Top +1),
                                   Point(R.Right, R.Top +1)]);
                   PolyLineEx(DC, [Point(R.Left, R.Bottom -2),
                                   Point(R.Right, R.Bottom -2)]);
                   SelectObject(DC, SavePen);
                   DeleteObject(Pen);

                   Brush := CreateSolidBrush(Skin.rgbColor(cBorder));
                   FrameRect(DC, R, Brush);
                   DeleteObject(Brush);

                   If Assigned(Window.FView.FParentView) and
                      (Window.FView.FParentView.IsToolbar) and
                      (not PTBData(AppData).MDI) then begin

                    IsCombo := tbisCombo in View.FParentItem.ItemStyle;
                    IsChevron := View.FParentView = View.FChevronParentView;
                    ItemRect := Window.FView.FParentView.FOpenViewer.FBoundsRect;
                    PopupRect := Window.BoundsRect;
                    ItemHeight := (ItemRect.Bottom - ItemRect.Top);
                    ItemWidth := (ItemRect.Right - ItemRect.Left);
                    Orientation := Window.FView.FParentView.FOrientation;

                    PI := Window.FView.FParentView.FWindow.ClientToScreen(
                     Point(Window.FView.FParentView.FOpenViewer.FBoundsRect.TopLeft.X,
                           Window.FView.FParentView.FOpenViewer.FBoundsRect.BottomRight.Y));

                    PP := Window.ClientToScreen(Point(0, 0));

                     If Orientation = tbvoVertical then begin
                       I3 := PI.Y - PP.Y;

                       if I3 < 0 then begin
                         I3 := -2;
                         I4 := 1;
                       end else I4 := I3 + 3;
                     end
                     else begin
                       I3 := PI.X - PP.X;

                       if I3 < 0 then begin
                         I3 := -2;
                         I4 := 1;
                       end else I4 := I3 + 3;

                       If PI.X < 0 Then
                        I3 := I3 + PI.X;
                     end;

                     Pen := CreatePen(PS_SOLID, 1, Skin.rgbColor(cImageList));
                     SavePen := SelectObject(DC, Pen);

                     With R Do
                       If (Orientation = tbvoVertical) then begin

                         ClipS := I4 - ItemHeight;
                         ClipE := I3 +1; //+ Integer(IsCombo);

                         if I3 > I4 then begin
                          Inc(ClipS);
                          Inc(ClipE);
                         end;

                         if PopupPosition = tbpRight then
                           PolyLineEx(DC, [Point(Left, ClipS),
                                           Point(Left, ClipE)])
                         else
                           PolyLineEx(DC, [Point(Right -1, ClipS),
                                           Point(Right -1, ClipE)]);
                         end
                         else begin
                           ClipS := I4;
                           ClipE := I3 + ItemWidth + (Integer(not IsCombo));

                           if I3 > 0 then begin
                            Dec(ClipS);
                            Dec(ClipE);
                           end;

                           if PopupPosition = tbpTop then begin
                             PolyLineEx(DC, [Point(ClipS, Bottom -1),
                                             Point(ClipE, Bottom -1)])
                           end
                           else
                            //Popup is too long ? Don't draw the line
{                            if (Orientation = tbvoHorizontal) and
                                not (PP.X -1 = PI.X +
                                ItemRect.Right - ItemRect.Left) then}
                             PolyLineEx(DC, [Point(ClipS, Top),
                                             Point(ClipE, Top)]);
                         end;


                     SelectObject(DC, SavePen);
                     DeleteObject(Pen);
                   end;
                 end;
  end;

  if (tboShadow in Skin.Options) and Window.Showing then begin
    If Assigned(Window.FView.FParentView) And Window.FView.FParentView.FIsToolbar then
     with ItemRect do begin

       If (View.FParentView.FOrientation = tbvoVertical) then begin
         if PopupPosition = tbpRight then begin
           with Window, BoundsRect.TopLeft do begin
             if MenuShadows then
               FShadowIB.SetBounds(X - ItemWidth + XPMargin + XPMargin Div 2 -
                                   Integer(IsCombo),
                                   ClipS + Y + ItemHeight -1,
                                   ItemWidth,
                                   XPMargin);

             FShadowPR.SetBounds(X + Width,
                                 Y,
                                 XPMargin,
                                 Height);
             FShadowPB.SetBounds(Left + XPMargin,
                                 Y + Height,
                                 Width,
                                 XPMargin);

             if MenuShadows then
               FShadowIB.Corner1 := True;

             FShadowPR.Corner1 := True;
             FShadowPB.Corner1 := True;
             FShadowPB.Corner2 := True;
           end;
         end
         else begin
           with Window, BoundsRect.TopLeft do begin
             if MenuShadows then begin
               FShadowIR.SetBounds(Left + Width + ItemWidth - XPMargin Div 2 -
                                   Integer(IsCombo),
                                   ClipS + Y,
                                   XPMargin,
                                   ItemHeight  -1);
               FShadowIB.SetBounds(X + Width - XPMargin,
                                   Y + ItemHeight + ClipS -1,
                                   ItemWidth + 2 - Integer(IsCombo) + XPMargin,
                                   XPMargin);
             end;

             FShadowPR.SetBounds(X + Width,
                                 Y - Integer(IsCombo) + XPMargin,
                                 XPMargin,
                                 Height + Integer(IsCombo) - XPMargin);
             FShadowPB.SetBounds(Left + XPMargin,
                                 Y + Height,
                                 Width,
                                 XPMargin);

             if MenuShadows then begin
               FShadowIR.Corner1 := True;
               FShadowIB.Corner2 := True;

               If ClipS <5 Then ClipS := 4;

               FShadowPR.ClipStart := ClipS -1 - (Integer(ClipS <> 4) * XPMargin) + Integer(IsCombo);
               FShadowPR.ClipFinish := ClipE + Integer(IsCombo);
             end;

             FShadowPR.Corner1 := True;
             FShadowPB.Corner1 := True;
             FShadowPB.Corner2 := True;
           end;
         end;
       end
       else if PopupPosition = tbpTop then begin
         with Window, BoundsRect, TopLeft do begin
           if MenuShadows then begin
             IR := Rect(Left + ClipE +1,
                        Y + Height - XPMargin *2,
                        XPMargin,
                        ItemHeight + XPMargin + 2);
             IB := Rect(PI.X + XPMargin - Integer(IsCombo),
                        Y + Height + ItemHeight - 2,
                        ItemWidth,
                        XPMargin);

             FShadowIR.SetBounds(IR.Left, IR.Top, IR.Right, IR.Bottom);
             FShadowIB.SetBounds(IB.Left, IB.Top, IB.Right, IB.Bottom);

             FShadowIB.Corner1 := True;
             FShadowIB.Corner2 := True;

             if ClipS >1 then begin
              FShadowPB.ClipStart := ClipS -XPMargin -1 + Integer(IsCombo);
              FShadowPB.ClipFinish := ClipE + Integer(IsCombo);
              FShadowPB.Corner1 := True;
             end else begin
               FShadowPB.ClipStart := 1;
               FShadowPB.ClipFinish := ItemWidth -2 +
                                       (Integer(PI.X <0) * PI.X +1);
             end;
           end;

           FShadowPR.SetBounds(X + Width,
                               Y,
                               XPMargin,
                               Height);
           FShadowPB.SetBounds(X + XPMargin -
                               Integer(IsCombo),
                               Y + Height,
                               Width + Integer(IsCombo),
                               XPMargin);

           FShadowPR.Corner1 := True;
           FShadowPR.Corner2 := True;
           FShadowPB.Corner2 := True;
         end;
       end
       else begin
         with Window, BoundsRect.TopLeft do begin
           if MenuShadows then begin
             IR := Rect(X + ItemWidth + I3 +2 - Integer(Boolean(ClipS >1)) - Integer(IsCombo),
                        Top - ItemHeight + XPMargin Div 2,
                        XPMargin,
                        ItemHeight - XPMargin + XPMargin Div 2);

             FShadowIR.SetBounds(IR.Left, IR.Top, IR.Right, IR.Bottom);
             FShadowIR.Corner1 := True;
           end;

           PR := Rect(X + Width, Y, XPMargin, Height);
           PB := Rect(Left + XPMargin, Y + Height, Width, XPMargin);

           if IsChevron then begin
            Dec(PR.Top, XPMargin *2);
            Inc(PR.Bottom, XPMargin *2);
           end;

           FShadowPR.SetBounds(PR.Left, PR.Top, PR.Right, PR.Bottom);
           FShadowPB.SetBounds(PB.Left, PB.Top, PB.Right, PB.Bottom);

           if not IsChevron then
            FShadowPR.Corner1 := True;

           FShadowPB.Corner1 := True;
           FShadowPB.Corner2 := True;
         end;
       end;
     end
     else //Single Popup Shadows
       with Window, BoundsRect.TopLeft do begin
         FShadowPR.SetBounds(X + Width,
                             Y + XPMargin,
                             XPMargin,
                             Height - XPMargin);
         FShadowPB.SetBounds(Left + XPMargin,
                             Y + Height,
                             Width,
                             XPMargin);
         FShadowPR.Corner1 := True;
         FShadowPB.Corner1 := True;
         FShadowPB.Corner2 := True;
       end;

   if ShowShadow then
    with Window do begin
     if Assigned(FShadowIR) and not FShadowIR.Visible then begin
       FShadowIR.Prepare;
       FShadowIR.Show;
     end;

     if Assigned(Window.FShadowIB) and not FShadowIB.Visible then begin
       FShadowIB.Prepare;
       FShadowIB.Show;
     end;

     if not FShadowPR.Visible and not FShadowPB.Visible then begin
       FShadowPR.Prepare;
       FShadowPR.Show;
     end;

     if not FShadowPB.Visible and not FShadowPB.Visible then begin
       FShadowPB.Prepare;
       FShadowPB.Show;
     end;
    End;
  end;
end;
//Skin Patch End;

procedure PopupWindowNCPaintProc(Wnd: HWND; DC: HDC; AppData: Longint);
var
  R: TRect;
  {$IFNDEF TB2K_USE_STRICT_O2K_MENU_STYLE}
  Brush: HBRUSH;
  {$ENDIF}
begin
  GetWindowRect(Wnd, R);  OffsetRect(R, -R.Left, -R.Top);
  {$IFNDEF TB2K_USE_STRICT_O2K_MENU_STYLE}
  if not AreFlatMenusEnabled then begin
  {$ENDIF}
    DrawEdge(DC, R, EDGE_RAISED, BF_RECT or BF_ADJUST);
    FrameRect(DC, R, GetSysColorBrush(COLOR_BTNFACE));
  {$IFNDEF TB2K_USE_STRICT_O2K_MENU_STYLE}
  end
  else begin
    FrameRect(DC, R, GetSysColorBrush(COLOR_BTNSHADOW));
    Brush := CreateSolidBrush(ColorToRGB(TTBPopupWindow(AppData).Color));
    InflateRect(R, -1, -1);
    FrameRect(DC, R, Brush);
    InflateRect(R, -1, -1);
    FrameRect(DC, R, Brush);
    DeleteObject(Brush);
  end;
  {$ENDIF}
end;

procedure TTBPopupWindow.WMNCPaint(var Message: TMessage);
var
  DC: HDC;
  CSkin: TTBBaseSkin; //Skin Patch
  Data: TTBData;
begin
  DC := GetWindowDC(Handle);
  try
    SelectNCUpdateRgn(Handle, DC, HRGN(Message.WParam));
//Skin Patch Begin
    If Assigned(Skin) and not (Skin.SkinType = tbsDisabled) and
       not (Skin.SkinType = tbsNativeXP) then
      CSkin := Skin
    else
      If Assigned(FView.FParentView) and Assigned(FView.FParentView.FSkin) and
         not (FView.FParentView.FSkin.SkinType = tbsDisabled) and
         not (FView.FParentView.FSkin.SkinType = tbsNativeXP) then
        CSkin := FView.FParentView.FSkin
      else CSkin := Nil;

    ShowShadow := True;

    with Data do begin
     Window := Self;
     Skin := CSkin;
     View := FView;
     MDI := (FView.ParentItem.Tag = 1234567890);
    end;

    if Assigned(CSkin) then
      ProcessSkinNCPaint(Handle, DC, LongInt(@Data))
    else //Skin Patch End
      PopupWindowNCPaintProc(Handle, DC, Longint(Self));
  finally
    ReleaseDC(Handle, DC);
  end;
end;

procedure TTBPopupWindow.WMPrint(var Message: TMessage);
//Skin Patch Begin
Var
  CSkin: TTBBaseSkin;
  Data: TTBData;
//Skin Patch End
begin
//Skin Patch Begin
  If Assigned(FSkin) and not (Skin.SkinType = tbsDisabled)
     and not (Skin.SkinType = tbsNativeXP) then
    CSkin := FSkin
  else
    If Assigned(View.FParentView) and Assigned(View.FParentView.FSkin) and
       not (View.FParentView.FSkin.SkinType = tbsDisabled) and
       not (View.FParentView.FSkin.SkinType = tbsNativeXP) then
      CSkin := View.FParentView.FSkin
    else if not (DefaultSkin.SkinType = tbsDisabled)
        and not (DefaultSkin.SkinType = tbsNativeXP) then
      CSkin := DefaultSkin else CSkin := Nil;

  ShowShadow := False;

  with Data do begin
   Window := Self;
   Skin := CSkin;
   View := FView;
   MDI := (FView.ParentItem.Tag = 1234567890);
  end;

  If Assigned(CSkin) then
    HandleWMPrint(Handle, Message, ProcessSkinNCPaint, LongInt(@Data))
  else //Skin Patch End
    HandleWMPrint(Handle, Message, PopupWindowNCPaintProc, Longint(Self));
end;

procedure TTBPopupWindow.WMPrintClient(var Message: TMessage);
begin
  HandleWMPrintClient(Self, Message);
end;

procedure TTBPopupWindow.CMHintShow(var Message: TCMHintShow);
begin
  with Message.HintInfo^ do begin
    HintStr := '';
    if Assigned(FView.Selected) then begin
      CursorRect := FView.Selected.BoundsRect;
      HintStr := FView.FSelected.Item.GetHintText;
    end;
  end;
end;


{ TTBItemContainer }

constructor TTBItemContainer.Create(AOwner: TComponent);
begin
  inherited;
  FItem := TTBRootItem.Create(Self);
  FItem.ParentComponent := Self;
end;

destructor TTBItemContainer.Destroy;
begin
  FItem.Free;
  inherited;
end;

function TTBItemContainer.GetItems: TTBCustomItem;
begin
  Result := FItem;
end;

procedure TTBItemContainer.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
  FItem.GetChildren(Proc, Root);
end;

function TTBItemContainer.GetImages: TCustomImageList;
begin
  Result := FItem.SubMenuImages;
end;

procedure TTBItemContainer.SetImages(Value: TCustomImageList);
begin
  FItem.SubMenuImages := Value;
end;


{ TTBPopupMenu }

constructor TTBPopupMenu.Create(AOwner: TComponent);
begin
  FSkin := DefaultSkin; //Skin Patch
  inherited;
  FItem := GetRootItemClass.Create(Self);
  FItem.ParentComponent := Self;
  FItem.OnClick := RootItemClick;
end;

destructor TTBPopupMenu.Destroy;
begin
  FItem.Free;
  inherited;
end;

//Skin Patch Begin
procedure TTBPopupMenu.SetSkin(const Value: TTBBaseSkin);
begin
  if FSkin <> Value then
  begin
    if Assigned(Value) then
    begin
      FSkin.FreeNotification(Self);
      FSkin := Value;
      FItem.FSkin := Value;
    end else begin
      FSkin := DefaultSkin;
      FItem.FSkin := DefaultSkin;
    end;
  end;
end;
//Skin Patch End

function TTBPopupMenu.GetItems: TTBCustomItem;
begin
  Result := FItem;
end;

procedure TTBPopupMenu.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
  FItem.GetChildren(Proc, Root);
end;

procedure TTBPopupMenu.SetChildOrder(Child: TComponent; Order: Integer);
begin
  FItem.SetChildOrder(Child, Order);
end;

//Skin Patch Begin
procedure TTBPopupMenu.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FSkin then begin
      Skin := DefaultSkin;
      FItem.FSkin := DefaultSkin;
    end;
  end;
end;
//Skin Patch End

function TTBPopupMenu.GetRootItemClass: TTBRootItemClass;
begin
  Result := TTBRootItem;
end;

function TTBPopupMenu.GetImages: TCustomImageList;
begin
  Result := FItem.SubMenuImages;
end;

function TTBPopupMenu.GetLinkSubitems: TTBCustomItem;
begin
  Result := FItem.LinkSubitems;
end;

function TTBPopupMenu.GetOptions: TTBItemOptions;
begin
  Result := FItem.Options;
end;

procedure TTBPopupMenu.SetImages(Value: TCustomImageList);
begin
  FItem.SubMenuImages := Value;
end;

procedure TTBPopupMenu.SetLinkSubitems(Value: TTBCustomItem);
begin
  FItem.LinkSubitems := Value;
end;

procedure TTBPopupMenu.SetOptions(Value: TTBItemOptions);
begin
  FItem.Options := Value;
end;

procedure TTBPopupMenu.RootItemClick(Sender: TObject);
begin
  if Sender = FItem then
    Sender := Self;
  DoPopup(Sender);
end;

{$IFNDEF JR_D5}
procedure TTBPopupMenu.DoPopup(Sender: TObject);
begin
  if Assigned(OnPopup) then OnPopup(Sender);
end;
{$ENDIF}

procedure TTBPopupMenu.Popup(X, Y: Integer);
begin
  {$IFDEF JR_D5}
  PPoint(@PopupPoint)^ := Point(X, Y);
  {$ENDIF}
  FItem.Popup(X, Y, TrackButton = tbRightButton, TTBPopupAlignment(Alignment));
end;

function TTBPopupMenu.IsShortCut(var Message: TWMKey): Boolean;
begin
  Result := FItem.IsShortCut(Message);
end;


{ TTBImageList }

constructor TTBCustomImageList.Create(AOwner: TComponent);
begin
  inherited;
  FCheckedImagesChangeLink := TChangeLink.Create;
  FCheckedImagesChangeLink.OnChange := ImageListChanged;
  FDisabledImagesChangeLink := TChangeLink.Create;
  FDisabledImagesChangeLink.OnChange := ImageListChanged;
  FHotImagesChangeLink := TChangeLink.Create;
  FHotImagesChangeLink.OnChange := ImageListChanged;
  FImagesBitmap := TBitmap.Create;
  FImagesBitmap.OnChange := ImagesBitmapChanged;
  FImagesBitmapMaskColor := clFuchsia;
end;

destructor TTBCustomImageList.Destroy;
begin
  FreeAndNil(FImagesBitmap);
  FreeAndNil(FHotImagesChangeLink);
  FreeAndNil(FDisabledImagesChangeLink);
  FreeAndNil(FCheckedImagesChangeLink);
  inherited;
end;

procedure TTBCustomImageList.ImagesBitmapChanged(Sender: TObject);
begin
  if not ImagesBitmap.Empty then begin
    Clear;
    AddMasked(ImagesBitmap, FImagesBitmapMaskColor);
  end;
end;

procedure TTBCustomImageList.ImageListChanged(Sender: TObject);
begin
  Change;
end;

procedure TTBCustomImageList.DefineProperties(Filer: TFiler);
type
  TProc = procedure(ASelf: TObject; Filer: TFiler);
begin
  if (Filer is TReader) or FImagesBitmap.Empty then
    inherited
  else
    { Bypass TCustomImageList.DefineProperties when we've got an ImageBitmap }
    TProc(@TComponentAccess.DefineProperties)(Self, Filer);
end;

procedure TTBCustomImageList.DrawState(Canvas: TCanvas; X, Y, Index: Integer;
  Enabled, Selected, Checked: Boolean);
begin
  if not Enabled and Assigned(DisabledImages) then
    DisabledImages.Draw(Canvas, X, Y, Index)
  else if Checked and Assigned(CheckedImages) then
    CheckedImages.Draw(Canvas, X, Y, Index, Enabled)
  else if Selected and Assigned(HotImages) then
    HotImages.Draw(Canvas, X, Y, Index, Enabled)
  else
    Draw(Canvas, X, Y, Index, Enabled);
end;

procedure TTBCustomImageList.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then begin
    if AComponent = CheckedImages then CheckedImages := nil;
    if AComponent = DisabledImages then DisabledImages := nil;
    if AComponent = HotImages then HotImages := nil;
  end;
end;

procedure TTBCustomImageList.ChangeImages(var AImageList: TCustomImageList;
  Value: TCustomImageList; AChangeLink: TChangeLink);
begin
  if Value = Self then
    Value := nil;
  if AImageList <> Value then begin
    if Assigned(AImageList) then
      AImageList.UnregisterChanges(AChangeLink);
    AImageList := Value;
    if Assigned(Value) then begin
      Value.RegisterChanges(AChangeLink);
      Value.FreeNotification(Self);
    end;
    { Don't call Change while loading because it causes the Delphi IDE to
      think the form has been modified (?). Also, don't call Change while
      destroying since there's no reason to. }
    if not(csLoading in ComponentState) and
       not(csDestroying in ComponentState) then
      Change;
  end;
end;

procedure TTBCustomImageList.SetCheckedImages(Value: TCustomImageList);
begin
  ChangeImages(FCheckedImages, Value, FCheckedImagesChangeLink);
end;

procedure TTBCustomImageList.SetDisabledImages(Value: TCustomImageList);
begin
  ChangeImages(FDisabledImages, Value, FDisabledImagesChangeLink);
end;

procedure TTBCustomImageList.SetHotImages(Value: TCustomImageList);
begin
  ChangeImages(FHotImages, Value, FHotImagesChangeLink);
end;

procedure TTBCustomImageList.SetImagesBitmap(Value: TBitmap);
begin
  FImagesBitmap.Assign(Value);
end;

procedure TTBCustomImageList.SetImagesBitmapMaskColor(Value: TColor);
begin
  if FImagesBitmapMaskColor <> Value then begin
    FImagesBitmapMaskColor := Value;
    ImagesBitmapChanged(nil);
  end;
end;


{ TTBBaseAccObject }

{ According to the MSAA docs:
  "With Active Accessibility 2.0, servers can return E_NOTIMPL from IDispatch
  methods and Active Accessibility will implement the IAccessible interface
  for them."
  And there was much rejoicing. }

function TTBBaseAccObject.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TTBBaseAccObject.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HResult;
begin
  Result := E_NOTIMPL;
end;

function TTBBaseAccObject.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TTBBaseAccObject.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;


{ Initialization & finalization }

procedure TBInitToolbarSystemFont;
var
  NonClientMetrics: TNonClientMetrics;
begin
  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
  if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
    ToolbarFont.Handle := CreateFontIndirect(NonClientMetrics.lfMenuFont);
end;

initialization
  ToolbarFont := TFont.Create;
  TBInitToolbarSystemFont;
finalization
  if ClickWnd <> 0 then begin
    {$IFDEF JR_D6}Classes.{$ENDIF} DeallocateHWnd(ClickWnd);
    ClickWnd := 0;
  end;
  ToolbarFont.Free;
  ToolbarFont := nil;
end.