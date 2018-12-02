
{******************************************}
{                                          }
{             FastScript v1.8              }
{               C++ grammar                }
{                                          }
{  (c) 2003-2005 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_icpp;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_itools;

type
  TfsCPP = class(TComponent);

procedure fsModifyCppForFR;

implementation

const
  CPP_GRAMMAR = 
  '<?xml version="1.0"?><language text="C++Script"><parser><commentline1 te' +
  'xt="//"/><commentblock1 text="/*,*/"/><commentblock2 text="/*,*/"/><stri' +
  'ngquotes text="&#34;"/><hexsequence text="0x"/><casesensitive text="1"/><keywords><break/><case/>' +
  '<continue/><define/><default/><delete/><do/><else/><except/><finally/><f' +
  'or/><in/><is/><if/><new/><return/><switch/><try/><while/></keywords><err' +
  'ors><err1 text="Identifier expected"/><err2 text="Expression expected"/>' +
  '<err3 text="Statement expected"/><err4 text="'':'' expected"/><err5 text' +
  '="'';'' expected"/><err6 text="''.'' expected"/><err7 text="'')'' expect' +
  'ed"/><err8 text="'']'' expected"/><err9 text="''='' expected"/><err10 te' +
  'xt="''{'' expected"/><err11 text="''}'' expected"/><err12 text="''('' ex' +
  'pected"/><err13 text="''DEFINE'' expected"/><err14 text="''WHILE'' expec' +
  'ted"/><err17 text="''FINALLY'' or ''EXCEPT'' expected"/><err18 text="''[' +
  ''' expected"/><err19 text="''..'' expected"/><err20 text="''&#62;'' expe' +
  'cted"/></errors></parser><types><int type="integer"/><long type="integer' +
  '"/><void type="integer"/><bool type="boolean"/><float type="extended"/><' +
  '/types><empty/><program><optional><usesclause/></optional><optionalloop>' +
  '<declsection/></optionalloop><compoundstmt err="err10"/></program><usesc' +
  'lause node="uses"><char text="#"/><keyword text="INCLUDE"/><loop text=",' +
  '"><string add="file" err="err1"/></loop></usesclause><declsection><switc' +
  'h><constsection/><functiondecl/><sequence><varstmt/><char text=";" err="' +
  'err5"/></sequence></switch></declsection><constsection><char text="#"/><' +
  'keyword text="DEFINE" err="err13"/><constantdecl/></constsection><consta' +
  'ntdecl node="const"><ident add="ident" err="err1"/><expression err="err2' +
  '"/></constantdecl><varstmt node="var"><ident add="type"/><loop text=",">' +
  '<ident add="ident"/><optional><array/></optional><optional><initvalue/><' +
  '/optional></loop></varstmt><array node="array"><loop><char text="["/><op' +
  'tionalloop text=","><arraydim err="err2"/></optionalloop><char text="]" ' +
  'err="err8"/></loop></array><arraydim node="dim"><expression/></arraydim>' +
  '<initvalue node="init"><char text="="/><expression err="err2"/></initval' +
  'ue><expression node="expr"><simpleexpression/><optionalloop><relop/><sim' +
  'pleexpression/></optionalloop></expression><simpleexpression><optional><' +
  'char text="-" add="op" addtext="unminus"/></optional><term/><optionalloo' +
  'p><addop/><term/></optionalloop></simpleexpression><term><factor/><optio' +
  'nalloop><mulop/><factor/></optionalloop></term><factor><switch><designat' +
  'or/><number add="number"/><string add="string"/><sequence><char text="("' +
  ' add="op"/><expression err="err2"/><char text=")" add="op" err="err7"/><' +
  '/sequence><sequence><char text="!" add="op" addtext="not"/><factor err="' +
  'err2"/></sequence><sequence><char text="["/><setconstructor err="err2"/>' +
  '<char text="]" err="err8"/></sequence><newoperator/><sequence><char text' +
  '="&#60;"/><frstring/><char text="&#62;" err="err20"/></sequence></switch' +
  '></factor><setconstructor node="set"><loop text=","><setnode/></loop></s' +
  'etconstructor><setnode><expression/><optional><char text="."/><char text' +
  '="." add="range"/><expression/></optional></setnode><newoperator node="n' +
  'ew"><keyword text="NEW"/><designator err="err2"/></newoperator><relop><s' +
  'witch><sequence><char text="&#62;"/><char text="=" skip="0" add="op" add' +
  'text="&#62;="/></sequence><sequence><char text="&#60;"/><char text="=" s' +
  'kip="0" add="op" addtext="&#60;="/></sequence><char text="&#62;" add="op' +
  '" addtext="&#62;"/><char text="&#60;" add="op" addtext="&#60;"/><sequenc' +
  'e><char text="="/><char text="=" skip="0" add="op" addtext="="/></sequen' +
  'ce><sequence><char text="!"/><char text="=" skip="0" add="op" addtext="&' +
  '#60;&#62;"/></sequence><keyword text="IN" add="op" addtext="in"/><keywor' +
  'd text="IS" add="op" addtext="is"/></switch></relop><addop><switch><char' +
  ' text="+" add="op"/><char text="-" add="op"/><sequence><char text="|"/><' +
  'char text="|" add="op" addtext="or"/></sequence><char text="^" add="op" ' +
  'addtext="xor"/></switch></addop><mulop><switch><char text="*" add="op"/>' +
  '<char text="/" add="op"/><keyword text="DIV" add="op" addtext="div"/><ch' +
  'ar text="%" add="op" addtext="mod"/><sequence><char text="&#38;"/><char ' +
  'text="&#38;" add="op" addtext="and"/></sequence><sequence><char text="&#' +
  '60;"/><char text="&#60;" skip="0" add="op" addtext="shl"/></sequence><se' +
  'quence><char text="&#62;"/><char text="&#62;" skip="0" add="op" addtext=' +
  '"shr"/></sequence></switch></mulop><designator node="dsgn"><optional><ch' +
  'ar text="&#38;" add="addr"/></optional><ident add="node"/><optionalloop>' +
  '<switch><sequence><char text="."/><keyword add="node"/></sequence><seque' +
  'nce><char text="[" add="node"/><exprlist err="err2"/><char text="]" err=' +
  '"err8"/><optionalloop><char text="["/><exprlist err="err2"/><char text="' +
  ']" err="err8"/></optionalloop></sequence><sequence><char text="("/><opti' +
  'onal><exprlist/></optional><char text=")" err="err7"/></sequence></switc' +
  'h></optionalloop></designator><exprlist><loop text=","><expression/></lo' +
  'op></exprlist><statement><optionalswitch><sequence><simplestatement/><ch' +
  'ar text=";" err="err5"/></sequence><structstmt/><emptystmt/></optionalsw' +
  'itch></statement><emptystmt node="empty"><char text=";"/></emptystmt><st' +
  'mtlist><loop><statement/></loop></stmtlist><simplestatement><switch><del' +
  'etestmt/><varstmt/><returnstmt/><keyword text="BREAK" node="break"/><key' +
  'word text="CONTINUE" node="continue"/><keyword text="EXIT" node="exit"/>' +
  '<assignstmt/><callstmt/></switch></simplestatement><deletestmt node="del' +
  'ete"><keyword text="DELETE"/><designator err="err2"/></deletestmt><assig' +
  'nstmt node="assignstmt"><designator/><switch><sequence><char text="+" op' +
  't="1" add="modificator"/><char text="=" skip="0"/></sequence><sequence><' +
  'char text="-" opt="1" add="modificator"/><char text="=" skip="0"/></sequ' +
  'ence><sequence><char text="*" opt="1" add="modificator"/><char text="=" ' +
  'skip="0"/></sequence><sequence><char text="/" opt="1" add="modificator"/' +
  '><char text="=" skip="0"/></sequence><char text="="/></switch><expressio' +
  'n err="err2"/></assignstmt><callstmt node="callstmt"><designator/><optio' +
  'nalswitch><sequence><char text="+"/><char text="+" skip="0" add="modific' +
  'ator"/></sequence><sequence><char text="-"/><char text="-" skip="0" add=' +
  '"modificator"/></sequence></optionalswitch></callstmt><returnstmt node="' +
  'return"><keyword text="RETURN"/><optional><expression/></optional></retu' +
  'rnstmt><structstmt><switch><compoundstmt/><conditionalstmt/><loopstmt/><' +
  'trystmt/></switch></structstmt><compoundstmt node="compoundstmt"><char t' +
  'ext="{"/><optional><stmtlist/></optional><char text="}" err="err11"/></c' +
  'ompoundstmt><conditionalstmt><switch><ifstmt/><casestmt/></switch></cond' +
  'itionalstmt><ifstmt node="ifstmt"><keyword text="IF"/><char text="(" err' +
  '="err12"/><expression err="err2"/><char text=")" err="err7"/><statement ' +
  'node="thenstmt"/><optional><keyword text="ELSE"/><statement node="elsest' +
  'mt"/></optional></ifstmt><casestmt node="casestmt"><keyword text="SWITCH' +
  '"/><char text="(" err="err12"/><expression err="err2"/><char text=")" er' +
  'r="err7"/><char text="{" err="err10"/><loop><caseselector/></loop><optio' +
  'nal><keyword text="DEFAULT"/><char text=":" err="err4"/><statement/></op' +
  'tional><char text="}" err="err11"/></casestmt><caseselector node="casese' +
  'lector"><keyword text="CASE"/><setconstructor err="err2"/><char text=":"' +
  ' err="err4"/><statement/></caseselector><loopstmt><switch><repeatstmt/><' +
  'whilestmt/><forstmt/></switch></loopstmt><repeatstmt node="repeatstmt"><' +
  'keyword text="DO"/><statement/><optional><char text=";"/></optional><key' +
  'word text="WHILE" err="err14"/><char text="(" err="err12"/><expression e' +
  'rr="err2"/><empty add="inverse"/><char text=")" err="err7"/><char text="' +
  ';" err="err5"/></repeatstmt><whilestmt node="whilestmt"><keyword text="W' +
  'HILE"/><char text="(" err="err12"/><expression err="err2"/><char text=")' +
  '" err="err7"/><statement/></whilestmt><forstmt node="cppforstmt"><keywor' +
  'd text="FOR"/><char text="(" err="err12"/><forcompoundstmt/><char text="' +
  ';" err="err5"/><expression err="err2"/><char text=";" err="err5"/><forco' +
  'mpoundstmt/><char text=")" err="err7"/><statement/></forstmt><forcompoun' +
  'dstmt node="compoundstmt"><loop text=","><forstmtitem/></loop></forcompo' +
  'undstmt><forstmtitem><switch><assignstmt/><varstmt/><callstmt/><empty no' +
  'de="empty"/></switch></forstmtitem><trystmt node="trystmt"><keyword text' +
  '="TRY"/><compoundstmt/><switch err="err17"><sequence><keyword text="FINA' +
  'LLY"/><compoundstmt node="finallystmt"/></sequence><sequence><keyword te' +
  'xt="EXCEPT"/><compoundstmt node="exceptstmt"/></sequence></switch></trys' +
  'tmt><functiondecl node="function"><functionheading/><compoundstmt/></fun' +
  'ctiondecl><functionheading><ident add="type"/><ident add="name"/><formal' +
  'parameters/></functionheading><formalparameters node="parameters"><char ' +
  'text="("/><optionalloop text=","><formalparam/></optionalloop><char text' +
  '=")" err="err7"/></formalparameters><formalparam node="var"><ident add="' +
  'type"/><optional><char text="&#38;" add="varparam"/></optional><ident ad' +
  'd="ident" err="err1"/><optional><initvalue/></optional></formalparam></l' +
  'anguage>';


procedure fsModifyCppForFR;
var
  i: Integer;
  s, s1: String;
begin
  s := CPP_GRAMMAR;
  s1 := '<char text="["/><setconstructor err="err2"/><char text="]" err="err8"/>';
  i := Pos(s1, s);
  if i <> 0 then
  begin
    Delete(s, i, Length(s1));
    s1 := '<char text="`"/><setconstructor err="err2"/><char text="`" err="err8"/>' +
      '</sequence><sequence><char text="["/><frstring/><char text="]" err="err8"/>';
    Insert(s1, s, i);
    fsRegisterLanguage('C++Script', s);
  end;
end;


initialization
  fsRegisterLanguage('C++Script', CPP_GRAMMAR);

end.
