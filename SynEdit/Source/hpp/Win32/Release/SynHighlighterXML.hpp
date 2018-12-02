﻿// CodeGear C++Builder
// Copyright (c) 1995, 2017 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'SynHighlighterXML.pas' rev: 33.00 (Windows)

#ifndef SynhighlighterxmlHPP
#define SynhighlighterxmlHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Win.Registry.hpp>
#include <SynEditTypes.hpp>
#include <SynEditHighlighter.hpp>
#include <SynUnicode.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Synhighlighterxml
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TSynXMLSyn;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TtkTokenKind : unsigned char { tkAposAttrValue, tkAposEntityRef, tkAttribute, tkCDATA, tkComment, tkElement, tkEntityRef, tkEqual, tkNull, tkProcessingInstruction, tkQuoteAttrValue, tkQuoteEntityRef, tkSpace, tkSymbol, tkText, tknsAposAttrValue, tknsAposEntityRef, tknsAttribute, tknsEqual, tknsQuoteAttrValue, tknsQuoteEntityRef, tkDocType };

enum DECLSPEC_DENUM TRangeState : unsigned char { rsAposAttrValue, rsAPosEntityRef, rsAttribute, rsCDATA, rsComment, rsElement, rsEntityRef, rsEqual, rsProcessingInstruction, rsQuoteAttrValue, rsQuoteEntityRef, rsText, rsnsAposAttrValue, rsnsAPosEntityRef, rsnsEqual, rsnsQuoteAttrValue, rsnsQuoteEntityRef, rsDocType, rsDocTypeSquareBraces };

class PASCALIMPLEMENTATION TSynXMLSyn : public Synedithighlighter::TSynCustomHighlighter
{
	typedef Synedithighlighter::TSynCustomHighlighter inherited;
	
private:
	TRangeState fRange;
	TtkTokenKind fTokenID;
	Synedithighlighter::TSynHighlighterAttributes* fElementAttri;
	Synedithighlighter::TSynHighlighterAttributes* fSpaceAttri;
	Synedithighlighter::TSynHighlighterAttributes* fTextAttri;
	Synedithighlighter::TSynHighlighterAttributes* fEntityRefAttri;
	Synedithighlighter::TSynHighlighterAttributes* fProcessingInstructionAttri;
	Synedithighlighter::TSynHighlighterAttributes* fCDATAAttri;
	Synedithighlighter::TSynHighlighterAttributes* fCommentAttri;
	Synedithighlighter::TSynHighlighterAttributes* fDocTypeAttri;
	Synedithighlighter::TSynHighlighterAttributes* fAttributeAttri;
	Synedithighlighter::TSynHighlighterAttributes* fnsAttributeAttri;
	Synedithighlighter::TSynHighlighterAttributes* fAttributeValueAttri;
	Synedithighlighter::TSynHighlighterAttributes* fnsAttributeValueAttri;
	Synedithighlighter::TSynHighlighterAttributes* fSymbolAttri;
	bool FWantBracesParsed;
	void __fastcall NullProc();
	void __fastcall CarriageReturnProc();
	void __fastcall LineFeedProc();
	void __fastcall SpaceProc();
	void __fastcall LessThanProc();
	void __fastcall GreaterThanProc();
	void __fastcall CommentProc();
	void __fastcall ProcessingInstructionProc();
	void __fastcall DocTypeProc();
	void __fastcall CDATAProc();
	void __fastcall TextProc();
	void __fastcall ElementProc();
	void __fastcall AttributeProc();
	void __fastcall QAttributeValueProc();
	void __fastcall AAttributeValueProc();
	void __fastcall EqualProc();
	void __fastcall IdentProc();
	void __fastcall NextProcedure();
	bool __fastcall NextTokenIs(System::UnicodeString Token);
	void __fastcall EntityRefProc();
	void __fastcall QEntityRefProc();
	void __fastcall AEntityRefProc();
	
protected:
	virtual System::UnicodeString __fastcall GetSampleSource();
	virtual bool __fastcall IsFilterStored();
	virtual bool __fastcall IsNameChar();
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetLanguageName();
	__classmethod virtual System::UnicodeString __fastcall GetFriendlyLanguageName();
	__fastcall virtual TSynXMLSyn(System::Classes::TComponent* AOwner);
	virtual Synedithighlighter::TSynHighlighterAttributes* __fastcall GetDefaultAttribute(int Index);
	virtual bool __fastcall GetEol();
	virtual void * __fastcall GetRange();
	TtkTokenKind __fastcall GetTokenID();
	virtual Synedithighlighter::TSynHighlighterAttributes* __fastcall GetTokenAttribute();
	virtual int __fastcall GetTokenKind();
	virtual void __fastcall Next();
	virtual void __fastcall SetRange(void * Value);
	virtual void __fastcall ResetRange();
	
__published:
	__property Synedithighlighter::TSynHighlighterAttributes* ElementAttri = {read=fElementAttri, write=fElementAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* AttributeAttri = {read=fAttributeAttri, write=fAttributeAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* NamespaceAttributeAttri = {read=fnsAttributeAttri, write=fnsAttributeAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* AttributeValueAttri = {read=fAttributeValueAttri, write=fAttributeValueAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* NamespaceAttributeValueAttri = {read=fnsAttributeValueAttri, write=fnsAttributeValueAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* TextAttri = {read=fTextAttri, write=fTextAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* CDATAAttri = {read=fCDATAAttri, write=fCDATAAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* EntityRefAttri = {read=fEntityRefAttri, write=fEntityRefAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* ProcessingInstructionAttri = {read=fProcessingInstructionAttri, write=fProcessingInstructionAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* CommentAttri = {read=fCommentAttri, write=fCommentAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* DocTypeAttri = {read=fDocTypeAttri, write=fDocTypeAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* SpaceAttri = {read=fSpaceAttri, write=fSpaceAttri};
	__property Synedithighlighter::TSynHighlighterAttributes* SymbolAttri = {read=fSymbolAttri, write=fSymbolAttri};
	__property bool WantBracesParsed = {read=FWantBracesParsed, write=FWantBracesParsed, default=1};
public:
	/* TSynCustomHighlighter.Destroy */ inline __fastcall virtual ~TSynXMLSyn() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Synhighlighterxml */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_SYNHIGHLIGHTERXML)
using namespace Synhighlighterxml;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// SynhighlighterxmlHPP
