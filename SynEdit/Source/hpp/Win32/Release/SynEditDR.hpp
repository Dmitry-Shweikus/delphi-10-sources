﻿// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'SynEditDR.dpk' rev: 33.00 (Windows)

#ifndef SyneditdrHPP
#define SyneditdrHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// (rtl)
#include <SysInit.hpp>
#include <SynTextDrawer.hpp>
#include <SynAutoCorrect.hpp>
#include <SynAutoCorrectEditor.hpp>
#include <SynCompletionProposal.hpp>
#include <SynDBEdit.hpp>
#include <SynEdit.hpp>
#include <SynEditAutoComplete.hpp>
#include <SynEditExport.hpp>
#include <SynEditHighlighter.hpp>
#include <SynEditKbdHandler.hpp>
#include <SynEditKeyCmdEditor.hpp>
#include <SynEditKeyCmds.hpp>
#include <SynEditKeyCmdsEditor.hpp>
#include <SynEditKeyConst.hpp>
#include <SynEditMiscClasses.hpp>
#include <SynEditMiscProcs.hpp>
#include <SynEditOptionsDialog.hpp>
#include <SynEditPlugins.hpp>
#include <SynEditWordWrap.hpp>
#include <SynEditPrint.hpp>
#include <SynEditPrinterInfo.hpp>
#include <SynEditPrintHeaderFooter.hpp>
#include <SynEditPrintMargins.hpp>
#include <SynEditPrintMarginsDialog.hpp>
#include <SynEditPrintPreview.hpp>
#include <SynEditPrintTypes.hpp>
#include <SynEditPythonBehaviour.hpp>
#include <SynEditRegexSearch.hpp>
#include <SynEditSearch.hpp>
#include <SynEditStrConst.hpp>
#include <SynEditTextBuffer.hpp>
#include <SynEditTypes.hpp>
#include <SynExportHTML.hpp>
#include <SynExportRTF.hpp>
#include <SynExportTeX.hpp>
#include <SynHighlighterADSP21xx.hpp>
#include <SynHighlighterAsm.hpp>
#include <SynHighlighterAWK.hpp>
#include <SynHighlighterBaan.hpp>
#include <SynHighlighterBat.hpp>
#include <SynHighlighterCAC.hpp>
#include <SynHighlighterCache.hpp>
#include <SynHighlighterCobol.hpp>
#include <SynHighlighterCPM.hpp>
#include <SynHighlighterCpp.hpp>
#include <SynHighlighterCS.hpp>
#include <SynHighlighterDfm.hpp>
#include <SynHighlighterDml.hpp>
#include <SynHighlighterFortran.hpp>
#include <SynHighlighterFoxpro.hpp>
#include <SynHighlighterGalaxy.hpp>
#include <SynHighlighterGeneral.hpp>
#include <SynHighlighterGWS.hpp>
#include <SynHighlighterHashEntries.hpp>
#include <SynHighlighterHaskell.hpp>
#include <SynHighlighterHC11.hpp>
#include <SynHighlighterHP48.hpp>
#include <SynHighlighterHtml.hpp>
#include <SynHighlighterIDL.hpp>
#include <SynHighlighterIni.hpp>
#include <SynHighlighterInno.hpp>
#include <SynHighlighterJava.hpp>
#include <SynHighlighterJScript.hpp>
#include <SynHighlighterKix.hpp>
#include <SynHighlighterM3.hpp>
#include <SynHighlighterModelica.hpp>
#include <SynHighlighterMsg.hpp>
#include <SynHighlighterMulti.hpp>
#include <SynHighlighterPas.hpp>
#include <SynHighlighterPerl.hpp>
#include <SynHighlighterPHP.hpp>
#include <SynHighlighterProgress.hpp>
#include <SynHighlighterPython.hpp>
#include <SynHighlighterRC.hpp>
#include <SynHighlighterRuby.hpp>
#include <SynHighlighterSDD.hpp>
#include <SynHighlighterSml.hpp>
#include <SynHighlighterSQL.hpp>
#include <SynHighlighterST.hpp>
#include <SynHighlighterTclTk.hpp>
#include <SynHighlighterTeX.hpp>
#include <SynHighlighterUNIXShellScript.hpp>
#include <SynHighlighterUnreal.hpp>
#include <SynHighlighterVB.hpp>
#include <SynHighlighterVBScript.hpp>
#include <SynHighlighterXML.hpp>
#include <SynMacroRecorder.hpp>
#include <SynMemo.hpp>
#include <SynRegExpr.hpp>
#include <SynHighlighterCSS.hpp>
#include <SynHighlighterLDraw.hpp>
#include <SynHighlighterURI.hpp>
#include <SynURIOpener.hpp>
#include <SynHighlighterDOT.hpp>
#include <SynHighlighterDWS.hpp>
#include <SynHighlighterVrml97.hpp>
#include <SynHighlighterEiffel.hpp>
#include <SynUnicode.hpp>
#include <SynUsp10.hpp>
#include <SynEditHighlighterOptions.hpp>
#include <SynHighlighterJSON.hpp>
#include <SynHighlighterRexx.hpp>
#include <System.UITypes.hpp>	// (rtl)
#include <Winapi.Windows.hpp>	// (rtl)
#include <Winapi.PsAPI.hpp>	// (rtl)
#include <System.Character.hpp>	// (rtl)
#include <System.Internal.ExcUtils.hpp>	// (rtl)
#include <System.SysUtils.hpp>	// (rtl)
#include <System.VarUtils.hpp>	// (rtl)
#include <System.Variants.hpp>	// (rtl)
#include <System.Math.hpp>	// (rtl)
#include <System.Rtti.hpp>	// (rtl)
#include <System.TypInfo.hpp>	// (rtl)
#include <System.Generics.Defaults.hpp>	// (rtl)
#include <System.Classes.hpp>	// (rtl)
#include <System.TimeSpan.hpp>	// (rtl)
#include <System.DateUtils.hpp>	// (rtl)
#include <System.IOUtils.hpp>	// (rtl)
#include <System.IniFiles.hpp>	// (rtl)
#include <System.Win.Registry.hpp>	// (rtl)
#include <System.UIConsts.hpp>	// (rtl)
#include <Vcl.Graphics.hpp>	// (vcl)
#include <System.Messaging.hpp>	// (rtl)
#include <System.Actions.hpp>	// (rtl)
#include <Vcl.ActnList.hpp>	// (vcl)
#include <System.HelpIntfs.hpp>	// (rtl)
#include <System.SyncObjs.hpp>	// (rtl)
#include <Winapi.UxTheme.hpp>	// (rtl)
#include <Vcl.GraphUtil.hpp>	// (vcl)
#include <Vcl.StdCtrls.hpp>	// (vcl)
#include <Winapi.ShellAPI.hpp>	// (rtl)
#include <Vcl.Printers.hpp>	// (vcl)
#include <Vcl.Clipbrd.hpp>	// (vcl)
#include <Vcl.ComCtrls.hpp>	// (vcl)
#include <Vcl.Dialogs.hpp>	// (vcl)
#include <Vcl.ExtCtrls.hpp>	// (vcl)
#include <Vcl.Themes.hpp>	// (vcl)
#include <System.AnsiStrings.hpp>	// (rtl)
#include <System.Win.ComObj.hpp>	// (rtl)
#include <Winapi.FlatSB.hpp>	// (rtl)
#include <Vcl.Forms.hpp>	// (vcl)
#include <Vcl.Menus.hpp>	// (vcl)
#include <Winapi.MsCTF.hpp>	// (rtl)
#include <Vcl.Controls.hpp>	// (vcl)
#include <Vcl.Buttons.hpp>	// (vcl)
#include <Data.SqlTimSt.hpp>	// (dbrtl)
#include <Data.FmtBcd.hpp>	// (dbrtl)
#include <Data.DB.hpp>	// (dbrtl)
#include <Vcl.DBLogDlg.hpp>	// (vcldb)
#include <Vcl.DBPWDlg.hpp>	// (vcldb)
#include <Vcl.DBCtrls.hpp>	// (vcldb)
// SO_SFX: 240
// PRG_EXT: .bpl
// BPI_DIR: C:\Users\Public\Documents\Embarcadero\Studio\20.0\Dcp
// OBJ_DIR: C:\Users\Public\Documents\Embarcadero\Studio\20.0\Dcp
// OBJ_EXT: .obj

//-- user supplied -----------------------------------------------------------

namespace Syneditdr
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
}	/* namespace Syneditdr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_SYNEDITDR)
using namespace Syneditdr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// SyneditdrHPP
