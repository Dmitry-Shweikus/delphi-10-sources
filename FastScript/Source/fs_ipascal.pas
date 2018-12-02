
{******************************************}
{                                          }
{             FastScript v1.8              }
{              Pascal grammar              }
{                                          }
{  (c) 2003-2005 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_ipascal;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_itools;

type
  TfsPascal = class(TComponent);

procedure fsModifyPascalForFR;

implementation

const
  PASCAL_GRAMMAR = 
  '<?xml version="1.0"?><language text="PascalScript"><parser><commentline1' +
  ' text="//"/><commentblock1 text="{,}"/><commentblock2 text="(*,*)"/><str' +
  'ingquotes text="''"/><hexsequence text="$"/><keywords><and/><array/><beg' +
  'in/><break/><case/><const/><continue/><div/><do/><downto/><else/><end/><' +
  'except/><exit/><finally/><for/><function/><goto/><if/><in/><is/><label/>' +
  '<mod/><not/><of/><or/><procedure/><program/><repeat/><shl/><shr/><then/>' +
  '<to/><try/><until/><uses/><var/><while/><with/><xor/></keywords><errors>' +
  '<err1 text="Identifier expected"/><err2 text="Expression expected"/><err' +
  '3 text="Statement expected"/><err4 text="'':'' expected"/><err5 text="''' +
  ';'' expected"/><err6 text="''.'' expected"/><err7 text="'')'' expected"/' +
  '><err8 text="'']'' expected"/><err9 text="''='' expected"/><err10 text="' +
  '''BEGIN'' expected"/><err11 text="''END'' expected"/><err12 text="''OF''' +
  ' expected"/><err13 text="''THEN'' expected"/><err14 text="''UNTIL'' expe' +
  'cted"/><err15 text="''TO'' or ''DOWNTO'' expected"/><err16 text="''DO'' ' +
  'expected"/><err17 text="''FINALLY'' or ''EXCEPT'' expected"/><err18 text' +
  '="''['' expected"/><err19 text="''..'' expected"/><err20 text="''&#62;''' +
  ' expected"/></errors></parser><types/><empty/><program><optional><keywor' +
  'd text="PROGRAM"/><ident err="err1"/><char text=";" err="err5"/></option' +
  'al><optional><usesclause/></optional><block/><char text="." err="err6"/>' +
  '</program><usesclause node="uses"><keyword text="USES"/><loop text=","><' +
  'string add="file" err="err1"/></loop><char text=";" err="err5"/></usescl' +
  'ause><block><optionalloop><declsection/></optionalloop><compoundstmt err' +
  '="err10"/></block><declsection><switch><constsection/><varsection/><proc' +
  'eduredeclsection/></switch></declsection><constsection><keyword text="CO' +
  'NST"/><loop><constantdecl/></loop></constsection><constantdecl node="con' +
  'st"><ident add="ident" err="err1" term="1"/><char text="=" err="err9"/><' +
  'expression err="err2"/><char text=";" err="err5"/></constantdecl><varsec' +
  'tion><keyword text="VAR"/><loop><varlist/><char text=";" err="err5"/></l' +
  'oop></varsection><varlist node="var"><loop text=","><ident add="ident" e' +
  'rr="err1" term="1"/></loop><char text=":" err="err4"/><typeident err="er' +
  'r1"/><optional><initvalue/></optional></varlist><typeident><optional><ar' +
  'ray/></optional><ident add="type"/></typeident><array node="array"><keyw' +
  'ord text="ARRAY"/><optional><char text="["/><loop text=","><' +
  'arraydim err="err2"/></loop><char text="]" err="err8"/></optional><keywo' +
  'rd text="OF" err="err12"/></array><arraydim node="dim"><switch><sequence' +
  '><expression/><char text="."/><char text="." skip="0"/><expression/></se' +
  'quence><expression/></switch></arraydim><initvalue node="init"><char tex' +
  't="="/><expression err="err2"/></initvalue><expression node="expr"><simp' +
  'leexpression/><optionalloop><relop/><simpleexpression/></optionalloop></' +
  'expression><simpleexpression><optional><char text="-" add="op" addtext="' +
  'unminus"/></optional><term/><optionalloop><addop/><term/></optionalloop>' +
  '</simpleexpression><term><factor/><optionalloop><mulop/><factor/></optio' +
  'nalloop></term><factor><switch><designator/><number add="number"/><strin' +
  'g add="string"/><sequence><char text="(" add="op"/><expression err="err2' +
  '"/><char text=")" add="op" err="err7"/></sequence><sequence><keyword tex' +
  't="NOT" add="op" addtext="not"/><factor err="err2"/></sequence><sequence' +
  '><char text="["/><setconstructor err="err2"/><char text="]" err="err8"/>' +
  '</sequence><sequence><char text="&#60;"/><frstring/><char text="&#62;" e' +
  'rr="err20"/></sequence></switch></factor><setconstructor node="set"><loo' +
  'p text=","><setnode/></loop></setconstructor><setnode><expression/><opti' +
  'onal><char text="." add="range"/><char text="." err="err6"/><expression/' +
  '></optional></setnode><relop><switch><sequence><char text="&#62;"/><char' +
  ' text="=" skip="0" add="op" addtext="&#62;="/></sequence><sequence><char' +
  ' text="&#60;"/><char text="&#62;" skip="0" add="op" addtext="&#60;&#62;"' +
  '/></sequence><sequence><char text="&#60;"/><char text="=" skip="0" add="' +
  'op" addtext="&#60;="/></sequence><char text="&#62;" add="op" addtext="&#' +
  '62;"/><char text="&#60;" add="op" addtext="&#60;"/><char text="=" add="o' +
  'p" addtext="="/><keyword text="IN" add="op" addtext="in"/><keyword text=' +
  '"IS" add="op" addtext="is"/></switch></relop><addop><switch><char text="' +
  '+" add="op"/><char text="-" add="op"/><keyword text="OR" add="op" addtex' +
  't="or"/><keyword text="XOR" add="op" addtext="xor"/></switch></addop><mu' +
  'lop><switch><char text="*" add="op"/><char text="/" add="op"/><keyword t' +
  'ext="DIV" add="op" addtext="div"/><keyword text="MOD" add="op" addtext="' +
  'mod"/><keyword text="AND" add="op" addtext="and"/><keyword text="SHL" ad' +
  'd="op" addtext="shl"/><keyword text="SHR" add="op" addtext="shr"/></swit' +
  'ch></mulop><designator node="dsgn"><optional><char text="@" add="addr"/>' +
  '</optional><ident add="node"/><optionalloop><switch><sequence><char text' +
  '="."/><keyword add="node" err="err1"/></sequence><sequence><char text="[" ' +
  'add="node"/><exprlist err="err2"/><char text="]" err="err8"/></sequence>' +
  '<sequence><char text="("/><exprlist err="err2"/><char text=")" err="err7' +
  '"/></sequence></switch></optionalloop></designator><exprlist><optionalloop text=' +
  '","><expression/></optionalloop></exprlist><statement><optionalswitch><simplesta' +
  'tement/><structstmt/></optionalswitch></statement><stmtlist><loop text="' +
  ';"><statement/></loop></stmtlist><simplestatement><switch><assignstmt/><' +
  'callstmt/><switch><keyword text="BREAK" node="break"/><keyword text="CON' +
  'TINUE" node="continue"/><keyword text="EXIT" node="exit"/></switch></swi' +
  'tch></simplestatement><assignstmt node="assignstmt"><designator/><char t' +
  'ext=":"/><char text="=" skip="0" err="err9"/><expression err="err2"/></a' +
  'ssignstmt><callstmt node="callstmt"><designator/></callstmt><structstmt>' +
  '<switch><compoundstmt/><conditionalstmt/><loopstmt/><trystmt/><withstmt/' +
  '></switch></structstmt><compoundstmt node="compoundstmt"><keyword text="' +
  'BEGIN"/><stmtlist/><keyword text="END" err="err5"/></compoundstmt><cond' +
  'itionalstmt><switch><ifstmt/><casestmt/></switch></conditionalstmt><ifst' +
  'mt node="ifstmt"><keyword text="IF"/><expression err="err2"/><keyword te' +
  'xt="THEN" err="err13"/><statement node="thenstmt"/><optional><keyword te' +
  'xt="ELSE"/><statement node="elsestmt"/></optional></ifstmt><casestmt nod' +
  'e="casestmt"><keyword text="CASE"/><expression err="err2"/><keyword text' +
  '="OF" err="err12"/><loop text=";" skip="1"><caseselector/></loop><option' +
  'al><keyword text="ELSE"/><statement/></optional><optional><char text=";"' +
  '/></optional><keyword text="END" err="err11"/></casestmt><caseselector n' +
  'ode="caseselector"><setconstructor err="err2"/><char text=":" err="err4"' +
  '/><statement/></caseselector><loopstmt><switch><repeatstmt/><whilestmt/>' +
  '<forstmt/></switch></loopstmt><repeatstmt node="repeatstmt"><keyword tex' +
  't="REPEAT"/><stmtlist/><keyword text="UNTIL" err="err14"/><expression er' +
  'r="err2"/></repeatstmt><whilestmt node="whilestmt"><keyword text="WHILE"' +
  '/><expression err="err2"/><keyword text="DO" err="err16"/><statement/></' +
  'whilestmt><forstmt node="forstmt"><keyword text="FOR"/><ident add="ident' +
  '" err="err1"/><char text=":" err="err4"/><char text="=" skip="0" err="er' +
  'r9"/><expression err="err2"/><switch err="err15"><keyword text="TO"/><ke' +
  'yword text="DOWNTO" add="downto"/></switch><expression err="err2"/><keyw' +
  'ord text="DO" err="err16"/><statement/></forstmt><trystmt node="trystmt"' +
  '><keyword text="TRY"/><stmtlist/><switch err="err17"><sequence><keyword ' +
  'text="FINALLY"/><stmtlist node="finallystmt"/></sequence><sequence><keyw' +
  'ord text="EXCEPT"/><stmtlist node="exceptstmt"/></sequence></switch><key' +
  'word text="END" err="err11"/></trystmt><withstmt node="with"><keyword te' +
  'xt="WITH"/><loop text=","><designator err="err2"/></loop><keyword text="' +
  'DO" err="err16"/><statement/></withstmt><proceduredeclsection><switch><p' +
  'roceduredecl/><functiondecl/></switch></proceduredeclsection><procedured' +
  'ecl node="procedure"><procedureheading/><char text=";" err="err5"/><bloc' +
  'k/><char text=";" err="err5"/></proceduredecl><procedureheading><keyword' +
  ' text="PROCEDURE"/><ident add="name" err="err1"/><optional><formalparame' +
  'ters/></optional></procedureheading><functiondecl node="function"><funct' +
  'ionheading/><char text=";" err="err5"/><block/><char text=";" err="err5"' +
  '/></functiondecl><functionheading><keyword text="FUNCTION"/><ident add="' +
  'name" err="err1"/><optional><formalparameters/></optional><char text=":"' +
  ' err="err4"/><ident add="type" err="err1"/></functionheading><formalpara' +
  'meters node="parameters"><char text="("/><loop text=";"><formalparam/></' +
  'loop><char text=")" err="err7"/></formalparameters><formalparam><optiona' +
  'lswitch><keyword text="VAR" node="varparams"/><keyword text="CONST"/></o' +
  'ptionalswitch><varlist/></formalparam></language>';


procedure fsModifyPascalForFR;
var
  i: Integer;
  s, s1: String;
begin
  s := PASCAL_GRAMMAR;
  s1 := '<char text="["/><setconstructor err="err2"/><char text="]" err="err8"/>';
  i := Pos(s1, s);
  if i <> 0 then
  begin
    Delete(s, i, Length(s1));
    s1 := '<char text="`"/><setconstructor err="err2"/><char text="`" err="err8"/>' +
      '</sequence><sequence><char text="["/><frstring/><char text="]" err="err8"/>';
    Insert(s1, s, i);
    fsRegisterLanguage('PascalScript', s);
  end;
end;


initialization
  fsRegisterLanguage('PascalScript', PASCAL_GRAMMAR);

end.
