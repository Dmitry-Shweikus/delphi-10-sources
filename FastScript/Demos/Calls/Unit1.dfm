�
 TFORM1 0�  TPF0TForm1Form1Left� TopkBorderStylebsDialogCaption	Call demoClientHeight!ClientWidth�Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameTahoma
Font.Style OldCreateOrderPositionpoScreenCenterPixelsPerInch`
TextHeight TLabelLabel1LeftTopWidth�HeightAutoSizeCaptioneThis demo shows how to call a Delphi function from script and how to call script function from DelphiWordWrap	  TButtonButton1LeftTopWidthUHeightCaptionCall DelphiFuncTabOrder OnClickButton1Click  TMemoMemo1LeftTop$Width�Height� Font.CharsetANSI_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Style Lines.Strings0procedure ScriptFunc(Msg: String; Num: Integer);begin$  ShowMessage('1st param: ' + Msg + %    '  2nd param: ' + IntToStr(Num));end; begin#  DelphiFunc('Call DelphiFunc', 1);end. 
ParentFontTabOrder  TButtonButton2Left`TopWidthUHeightCaptionCall ScriptFuncTabOrderOnClickButton2Click  	TfsScript	fsScript1
SyntaxTypePascalScriptLeft$Top�   	TfsPascal	fsPascal1LeftDTop�    