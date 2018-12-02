﻿// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'SynHighlighterTeX.pas' rev: 33.00 (Windows)

#ifndef SynhighlightertexHPP
#define SynhighlightertexHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Vcl.Graphics.hpp>
#include <SynEditTypes.hpp>
#include <SynEditHighlighter.hpp>
#include <SynUnicode.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Synhighlightertex
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TSynTeXSyn;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TtkTokenKind : unsigned char { tkBrace, tkBracket, tkNull, tkSpace, tkText, tkComment, tkControlSequence, tkMathMode };

class PASCALIMPLEMENTATION TSynTeXSyn : public Synedithighlighter::TSynCustomHighlighter
{
	typedef Synedithighlighter::TSynCustomHighlighter inherited;
	
private:
	TtkTokenKind fTokenID;
	Synedithighlighter::TSynHighlighterAttributes* fTextAttri;
	Synedithighlighter::TSynHighlighterAttributes* fControlSequenceAttri;
	Synedithighlighter::TSynHighlighterAttributes* fMathmodeAttri;
	Synedithighlighter::TSynHighlighterAttributes* fCommentAttri;
	Synedithighlighter::TSynHighlighterAttributes* fSpaceAttri;
	Synedithighlighter::TSynHighlighterAttributes* fBracketAttri;
	Synedithighlighter::TSynHighlighterAttributes* fBraceAttri;
	Synedithighlighter::TSynHighlighterAttributes* __fastcall CreateHighlighterAttributes(System::UnicodeString Name, System::UnicodeString FriendlyName, System::Uitypes::TColor Foreground, System::Uitypes::TColor Background, System::Uitypes::TFontStyles FontStyles);
	void __fastcall CRProc();
	void __fastcall TextProc();
	void __fastcall LFProc();
	void __fastcall NullProc();
	void __fastcall CommentProc();
	void __fastcall SpaceProc();
	void __fastcall ControlSequenceProc();
	void __fastcall BraceOpenProc();
	void __fastcall BraceCloseProc();
	void __fastcall BracketOpenProc();
	void __fastcall BracketCloseProc();
	void __fastcall MathmodeProc();
	
protected:
	virtual System::UnicodeString __fastcall GetSampleSource();
	virtual bool __fastcall IsFilterStored();
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetLanguageName();
	__classmethod virtual System::UnicodeString __fastcall GetFriendlyLanguageName();
	__fastcall virtual TSynTeXSyn(System::Classes::TComponent* AOwner);
	virtual Synedithighlighter::TSynHighlighterAttributes* __fastcall GetDefaultAttribute(int Index);
	virtual bool __fastcall GetEol();
	TtkTokenKind __fastcall GetTokenID();
	virtual Synedithighlighter::TSynHighlighterAttributes* __fastcall GetTokenAttribute();
	virtual int __fastcall GetTokenKind();
	virtual void __fastcall Next();
	
__published:
	__property Synedithighlighter::TSynHighlighterAttributes* CommentAttri = {read=fCommentAttri, write=fCommentAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* TextAttri = {read=fTextAttri, write=fTextAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* ControlSequenceAttri = {read=fControlSequenceAttri, write=fControlSequenceAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* MathmodeAttri = {read=fMathmodeAttri, write=fMathmodeAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* SpaceAttri = {read=fSpaceAttri, write=fSpaceAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* BraceAttri = {read=fBraceAttri, write=fBraceAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* BracketAttri = {read=fBracketAttri, write=fBracketAttri};
public:
	/* TSynCustomHighlighter.Destroy */ inline __fastcall virtual ~TSynTeXSyn() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Synhighlightertex */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_SYNHIGHLIGHTERTEX)
using namespace Synhighlightertex;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// SynhighlightertexHPP
