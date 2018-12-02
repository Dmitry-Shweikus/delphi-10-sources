
{******************************************}
{                                          }
{             FastScript v1.8              }
{    Dialogs.pas classes and functions     }
{                                          }
{  (c) 2003-2005 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_idialogsrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_iclassesrtti
{$IFDEF CLX}
, QDialogs
{$ELSE}
, Dialogs
{$ENDIF};

type
  TfsDialogsRTTI = class(TComponent); // fake component


implementation

type
{$IFDEF CLX}
  THackDialog = class(TDialog);
{$ELSE}
  THackDialog = class(TCommonDialog);
{$ENDIF}

  TFunctions = class(TObject)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
  public
    constructor Create;
    destructor Destroy; override;
  end;

type
  TWordSet = set of 0..15;
  PWordSet = ^TWordSet;

var
  Functions: TFunctions;


{ TFunctions }

constructor TFunctions.Create;
var
  dlg: String;
begin
  with fsGlobalUnit do
  begin
    AddedBy := Self;
    AddEnumSet('TOpenOptions', 'ofReadOnly, ofOverwritePrompt, ofHideReadOnly,' +
      'ofNoChangeDir, ofShowHelp, ofNoValidate, ofAllowMultiSelect,' +
      'ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofCreatePrompt,' +
      'ofShareAware, ofNoReadOnlyReturn, ofNoTestFileCreate, ofNoNetworkButton,' +
      'ofNoLongNames, ofOldStyleDialog, ofNoDereferenceLinks, ofEnableIncludeNotify,' +
      'ofEnableSizing');
    AddEnum('TFileEditStyle', 'fsEdit, fsComboBox');
    AddEnumSet('TColorDialogOptions', 'cdFullOpen, cdPreventFullOpen, cdShowHelp,' +
      'cdSolidColor, cdAnyColor');
    AddEnumSet('TFontDialogOptions', 'fdAnsiOnly, fdTrueTypeOnly, fdEffects,' +
      'fdFixedPitchOnly, fdForceFontExist, fdNoFaceSel, fdNoOEMFonts,' +
      'fdNoSimulations, fdNoSizeSel, fdNoStyleSel,  fdNoVectorFonts,' +
      'fdShowHelp, fdWysiwyg, fdLimitSize, fdScalableOnly, fdApplyButton');
    AddEnum('TFontDialogDevice', 'fdScreen, fdPrinter, fdBoth');
    AddEnum('TPrintRange', 'prAllPages, prSelection, prPageNums');
    AddEnumSet('TPrintDialogOptions', 'poPrintToFile, poPageNums, poSelection,' +
      'poWarning, poHelp, poDisablePrintToFile');
{$IFNDEF CLX}
    AddEnum('TMsgDlgType', 'mtWarning, mtError, mtInformation, mtConfirmation, mtCustom');
    AddEnumSet('TMsgDlgButtons', 'mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, ' +
      'mbIgnore, mbAll, mbNoToAll, mbYesToAll, mbHelp');
{$ELSE}
    AddEnum('TMsgDlgType', 'mtCustom, mtInformation, mtWarning, mtError, mtConfirmation');
    AddEnumSet('TMsgDlgButtons', 'mbNone, mbOk, mbCancel, mbYes, mbNo, mbAbort, ' +
      'mbRetry, mbIgnore');
{$ENDIF}

{$IFDEF CLX}
    dlg := 'TDialog';
    with AddClass(TDialog, 'TComponent') do
{$ELSE}
    dlg := 'TCommonDialog';
    with AddClass(TCommonDialog, 'TComponent') do
{$ENDIF}
      AddMethod('function Execute: Boolean', CallMethod);
    AddClass(TOpenDialog, dlg);
    AddClass(TSaveDialog, dlg);
    AddClass(TColorDialog, dlg);
    AddClass(TFontDialog, dlg);
{$IFNDEF CLX}
    AddClass(TPrintDialog, dlg);
    AddClass(TPrinterSetupDialog, dlg);
{$ENDIF}
    AddMethod('function MessageDlg(Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer', CallMethod, 'ctOther');
    AddMethod('function InputBox(ACaption, APrompt, ADefault: string): string', CallMethod, 'ctOther');
    AddMethod('function InputQuery(ACaption, APrompt: string; var Value: string): Boolean', CallMethod, 'ctOther');

    AddedBy := nil;
  end;
end;

destructor TFunctions.Destroy;
begin
  if fsGlobalUnit <> nil then
    fsGlobalUnit.RemoveItems(Self);
  inherited;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
var
  s: String;
  b: TMsgDlgButtons;
begin
  Result := 0;

{$IFDEF CLX}
  if ClassType = TDialog then
{$ELSE}
  if ClassType = TCommonDialog then
{$ENDIF}
  begin
    if MethodName = 'EXECUTE' then
      Result := THackDialog(Instance).Execute
  end
  else if MethodName = 'INPUTBOX' then
    Result := InputBox(Params[0], Params[1], Params[2])
  else if MethodName = 'INPUTQUERY' then
  begin
    s := Params[2];
    Result := InputQuery(Params[0], Params[1], s);
    Params[2] := s;
  end
  else if MethodName = 'MESSAGEDLG' then
  begin
    Word(PWordSet(@b)^) := Params[2];
    Result := MessageDlg(Params[0], Params[1], b, Params[3]);
  end
end;



initialization
  Functions := TFunctions.Create;

finalization
  Functions.Free;

end.
