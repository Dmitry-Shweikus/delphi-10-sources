// $jrsoftware: tb2k/Packages/tb2k_cb4.cpp,v 1.8 2002/11/14 18:07:19 jr Exp $
//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USEPACKAGE("vcl40.bpi");
USEUNIT("..\Source\TB2Common.pas");
USEUNIT("..\Source\TB2Consts.pas");
USEUNIT("..\Source\TB2Dock.pas");
USEUNIT("..\Source\TB2ExtItems.pas");
USEUNIT("..\Source\TB2Item.pas");
USEUNIT("..\Source\TB2Toolbar.pas");
USEUNIT("..\Source\TB2Version.pas");
USEUNIT("..\Source\TB2Hook.pas");
USEUNIT("..\Source\TB2ToolWindow.pas");
USEUNIT("..\Source\TB2MRU.pas");
USEUNIT("..\Source\TB2Anim.pas");
USEUNIT("..\Source\TB2MDI.pas");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
    return 1;
}
//---------------------------------------------------------------------------

