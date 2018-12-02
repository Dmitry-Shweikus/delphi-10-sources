
{******************************************}
{                                          }
{             FastScript v1.8              }
{            Standard functions            }
{                                          }
{  (c) 2003-2005 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_isysrtti;

interface

{$i fs.inc}

implementation

uses SysUtils, Classes, fs_iinterpreter, fs_itools
{$IFDEF CLX}
, QDialogs, MaskUtils
{$ELSE}
  {$IFNDEF NOFORMS}
, Dialogs
  {$ENDIF}
{$IFDEF Delphi6}
, MaskUtils, Variants, Windows
{$ELSE}
, Mask
{$ENDIF}
{$ENDIF}
{$IFDEF OLE}
, ComObj
{$ENDIF};

type
  TFunctions = class(TObject)
  private
    FCatConv: String;
    FCatDate: String;
    FCatFormat: String;
    FCatMath: String;
    FCatOther: String;
    FCatStr: String;
    function CallMethod1(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function CallMethod2(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function CallMethod3(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function CallMethod4(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function CallMethod5(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function CallMethod6(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function CallMethod7(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
  public
    constructor Create;
    destructor Destroy; override;
  end;

var
  Functions: TFunctions;


function FormatV(const Fmt: String; Args: Variant): String;
var
  ar: TVarRecArray;
begin
  VariantToVarRec(Args, ar);
  Result := Format(Fmt, ar);
  ClearVarRec(ar);
end;

function VArrayCreate(Args: Variant; Typ: Integer): Variant;
var
  i, n: Integer;
  ar: array of Integer;
begin
  n := VarArrayHighBound(Args, 1) + 1;
  SetLength(ar, n);
  for i := 0 to n - 1 do
    ar[i] := Args[i];

  Result := VarArrayCreate(ar, Typ);
  ar := nil;
end;

function NameCase(const s: String): String;
var
  i: Integer;
begin
  Result := AnsiLowercase(s);
  for i := 1 to Length(s) do
    if i = 1 then
      Result[i] := AnsiUpperCase(s[i])[1]
    else if i < Length(s) then
      if s[i] = ' ' then
        Result[i + 1] := AnsiUpperCase(s[i + 1])[1];
end;

function ValidInt(cInt: String): Boolean;
begin
  Result := True;
  try
    StrToInt(cInt);
  except
    Result := False;
  end;
end;

function ValidFloat(cFlt: String): Boolean;
begin
  Result := True;
  try
    StrToFloat(cFlt);
  except
    Result := False;
  end;
end;

function ValidDate(cDate: String) :Boolean;
begin
  Result := True;
  try
    StrToDate(cDate);
  except
    Result := False;
  end;
end;

function DaysInMonth(nYear, nMonth: Integer): Integer;
const
  Days: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  Result := Days[nMonth];
  if (nMonth = 2) and IsLeapYear(nYear) then Inc(Result);
end;


{ TFunctions }

constructor TFunctions.Create;
begin
  FCatStr := 'ctString';
  FCatDate := 'ctDate';
  FCatConv := 'ctConv';
  FCatFormat := 'ctFormat';
  FCatMath := 'ctMath';
  FCatOther := 'ctOther';

  with fsGlobalUnit do
  begin
    AddedBy := Self;
    AddMethod('function IntToStr(i: Integer): String', CallMethod1, FCatConv);
    AddMethod('function FloatToStr(e: Extended): String', CallMethod1, FCatConv);
    AddMethod('function DateToStr(e: Extended): String', CallMethod1, FCatConv);
    AddMethod('function TimeToStr(e: Extended): String', CallMethod1, FCatConv);
    AddMethod('function DateTimeToStr(e: Extended): String', CallMethod1, FCatConv);
    AddMethod('function VarToStr(v: Variant): String', CallMethod7, FCatConv);

    AddMethod('function StrToInt(s: String): Integer', CallMethod2, FCatConv);
    AddMethod('function StrToFloat(s: String): Extended', CallMethod2, FCatConv);
    AddMethod('function StrToDate(s: String): Extended', CallMethod2, FCatConv);
    AddMethod('function StrToTime(s: String): Extended', CallMethod2, FCatConv);
    AddMethod('function StrToDateTime(s: String): Extended', CallMethod2, FCatConv);

    AddMethod('function Format(Fmt: String; Args: array): String', CallMethod3, FCatFormat);
    AddMethod('function FormatFloat(Fmt: String; Value: Extended): String', CallMethod3, FCatFormat);
    AddMethod('function FormatDateTime(Fmt: String; DateTime: TDateTime): String', CallMethod3, FCatFormat);
    AddMethod('function FormatMaskText(EditMask: string; Value: string): string', CallMethod3, FCatFormat);

    AddMethod('function EncodeDate(Year, Month, Day: Word): TDateTime', CallMethod4, FCatDate);
    AddMethod('procedure DecodeDate(Date: TDateTime; var Year, Month, Day: Word)', CallMethod4, FCatDate);
    AddMethod('function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime', CallMethod4, FCatDate);
    AddMethod('procedure DecodeTime(Time: TDateTime; var Hour, Min, Sec, MSec: Word)', CallMethod4, FCatDate);
    AddMethod('function Date: TDateTime', CallMethod4, FCatDate);
    AddMethod('function Time: TDateTime', CallMethod4, FCatDate);
    AddMethod('function Now: TDateTime', CallMethod4, FCatDate);
    AddMethod('function DayOfWeek(aDate: TDateTime): Integer', CallMethod4, FCatDate);
    AddMethod('function IsLeapYear(Year: Word): Boolean', CallMethod4, FCatDate);
    AddMethod('function DaysInMonth(nYear, nMonth: Integer): Integer', CallMethod4, FCatDate);

    AddMethod('function Length(s: Variant): Integer', CallMethod5, FCatStr);
    AddMethod('function Copy(s: String; from, count: Integer): String', CallMethod5, FCatStr);
    AddMethod('function Pos(substr, s: String): Integer', CallMethod5, FCatStr);
    AddMethod('procedure Delete(var s: String; from, count: Integer)', CallMethod5, FCatStr);
    AddMethod('procedure DeleteStr(var s: String; from, count: Integer)', CallMethod5, FCatStr);
    AddMethod('procedure Insert(s: String; var s2: String; pos: Integer)', CallMethod5, FCatStr);
    AddMethod('function Uppercase(s: String): String', CallMethod5, FCatStr);
    AddMethod('function Lowercase(s: String): String', CallMethod5, FCatStr);
    AddMethod('function Trim(s: String): String', CallMethod5, FCatStr);
    AddMethod('function NameCase(s: String): String', CallMethod5, FCatStr);
    AddMethod('function CompareText(s, s1: String): Integer', CallMethod5, FCatStr);
    AddMethod('function Chr(i: Integer): Char', CallMethod5, FCatStr);
    AddMethod('function Ord(ch: Char): Integer', CallMethod5, FCatStr);
    AddMethod('procedure SetLength(var S: Variant; L: Integer)', CallMethod5, FCatStr);

    AddMethod('function Round(e: Extended): Integer', CallMethod6, FCatMath);
    AddMethod('function Trunc(e: Extended): Integer', CallMethod6, FCatMath);
    AddMethod('function Int(e: Extended): Integer', CallMethod6, FCatMath);
    AddMethod('function Frac(X: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Sqrt(e: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Abs(e: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Sin(e: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Cos(e: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function ArcTan(X: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Tan(X: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Exp(X: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Ln(X: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Pi: Extended', CallMethod6, FCatMath);

    AddMethod('procedure Inc(var i: Integer; incr: Integer = 1)', CallMethod7, FCatOther);
    AddMethod('procedure Dec(var i: Integer; decr: Integer = 1)', CallMethod7, FCatOther);
    AddMethod('procedure RaiseException(Param: String)', CallMethod7, FCatOther);
    AddMethod('procedure ShowMessage(Msg: Variant)', CallMethod7, FCatOther);
    AddMethod('procedure Randomize', CallMethod7, FCatOther);
    AddMethod('function Random: Extended', CallMethod7, FCatOther);
    AddMethod('function ValidInt(cInt: String): Boolean', CallMethod7, FCatOther);
    AddMethod('function ValidFloat(cFlt: String): Boolean', CallMethod7, FCatOther);
    AddMethod('function ValidDate(cDate: String): Boolean', CallMethod7, FCatOther);
{$IFDEF OLE}
    AddMethod('function CreateOleObject(ClassName: String): Variant', CallMethod7, FCatOther);
{$ENDIF};
    AddMethod('function VarArrayCreate(Bounds: Array; Typ: Integer): Variant', CallMethod7, FCatOther);
    AddMethod('function VarType(V: Variant): Integer', CallMethod7, FCatOther);

    AddConst('varEmpty', 'Integer', 0);
    AddConst('varNull', 'Integer', 1);
    AddConst('varSmallint', 'Integer', 2);
    AddConst('varInteger', 'Integer', 3);
    AddConst('varSingle', 'Integer', 4);
    AddConst('varDouble', 'Integer', 5);
    AddConst('varCurrency', 'Integer', 6);
    AddConst('varDate', 'Integer', 7);
    AddConst('varOleStr', 'Integer', 8);
    AddConst('varDispatch', 'Integer', 9);
    AddConst('varError', 'Integer', $000A);
    AddConst('varBoolean', 'Integer', $000B);
    AddConst('varVariant', 'Integer', $000C);
    AddConst('varUnknown', 'Integer', $000D);
    AddConst('varShortInt', 'Integer', $0010);
    AddConst('varByte', 'Integer', $0011);
    AddConst('varWord', 'Integer', $0012);
    AddConst('varLongWord', 'Integer', $0013);
    AddConst('varInt64', 'Integer', $0014);
    AddConst('varStrArg', 'Integer', $0048);
    AddConst('varString', 'Integer', $0100);
    AddConst('varAny', 'Integer', $0101);
    AddConst('varTypeMask', 'Integer', $0FFF);
    AddConst('varArray', 'Integer', $2000);
    AddConst('varByRef', 'Integer', $4000);
    
    AddedBy := nil;
  end;
end;

destructor TFunctions.Destroy;
begin
  if fsGlobalUnit <> nil then
    fsGlobalUnit.RemoveItems(Self);
  inherited;
end;

function TFunctions.CallMethod1(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
var
{$IFDEF Delphi6}
  i: Int64;
{$ELSE}
  i: Integer;
{$ENDIF}
begin
  if MethodName = 'INTTOSTR' then
  begin
    i := Params[0];
    Result := IntToStr(i)
  end
  else if MethodName = 'FLOATTOSTR' then
    Result := FloatToStr(Params[0])
  else if MethodName = 'DATETOSTR' then
    Result := DateToStr(Params[0])
  else if MethodName = 'TIMETOSTR' then
    Result := TimeToStr(Params[0])
  else if MethodName = 'DATETIMETOSTR' then
    Result := DateTimeToStr(Params[0])
end;

function TFunctions.CallMethod2(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
begin
  if MethodName = 'STRTOINT' then
    Result := StrToInt(Params[0])
  else if MethodName = 'STRTOFLOAT' then
    Result := StrToFloat(Params[0])
  else if MethodName = 'STRTODATE' then
    Result := StrToDate(Params[0])
  else if MethodName = 'STRTOTIME' then
    Result := StrToTime(Params[0])
  else if MethodName = 'STRTODATETIME' then
    Result := StrToDateTime(Params[0])
end;

function TFunctions.CallMethod3(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
begin
  if MethodName = 'FORMAT' then
    Result := FormatV(Params[0], Params[1])
  else if MethodName = 'FORMATFLOAT' then
    Result := FormatFloat(Params[0], Params[1])
  else if MethodName = 'FORMATDATETIME' then
    Result := FormatDateTime(Params[0], Params[1])
  else if MethodName = 'FORMATMASKTEXT' then
    Result := FormatMaskText(Params[0], Params[1])
end;

function TFunctions.CallMethod4(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
var
  w1, w2, w3, w4: Word;
begin
  if MethodName = 'ENCODEDATE' then
    Result := EncodeDate(Params[0], Params[1], Params[2])
  else if MethodName = 'ENCODETIME' then
    Result := EncodeTime(Params[0], Params[1], Params[2], Params[3])
  else if MethodName = 'DECODEDATE' then
  begin
    DecodeDate(Params[0], w1, w2, w3);
    Params[1] := w1;
    Params[2] := w2;
    Params[3] := w3;
  end
  else if MethodName = 'DECODETIME' then
  begin
    DecodeTime(Params[0], w1, w2, w3, w4);
    Params[1] := w1;
    Params[2] := w2;
    Params[3] := w3;
    Params[4] := w4;
  end
  else if MethodName = 'DATE' then
    Result := Date
  else if MethodName = 'TIME' then
    Result := Time
  else if MethodName = 'NOW' then
    Result := Now
  else if MethodName = 'DAYOFWEEK' then
    Result := DayOfWeek(Params[0])
  else if MethodName = 'ISLEAPYEAR' then
    Result := IsLeapYear(Params[0])
  else if MethodName = 'DAYSINMONTH' then
    Result := DaysInMonth(Params[0], Params[1])
end;

function TFunctions.CallMethod5(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
var
  s: String;
  v: Variant;
begin
  if MethodName = 'LENGTH' then
  begin
    v := Params[0];
    if VarIsArray(v) then
      Result := VarArrayHighBound(v, 1) - VarArrayLowBound(v, 1) + 1
    else
      Result := Length(v)
  end
  else if MethodName = 'COPY' then
    Result := Copy(Params[0], Integer(Params[1]), Integer(Params[2]))
  else if MethodName = 'POS' then
    Result := Pos(Params[0], Params[1])
  else if (MethodName = 'DELETE') or (MethodName = 'DELETESTR') then
  begin
    s := Params[0];
    Delete(s, Integer(Params[1]), Integer(Params[2]));
    Params[0] := s;
  end
  else if MethodName = 'INSERT' then
  begin
    s := Params[1];
    Insert(Params[0], s, Integer(Params[2]));
    Params[1] := s;
  end
  else if MethodName = 'UPPERCASE' then
    Result := AnsiUppercase(Params[0])
  else if MethodName = 'LOWERCASE' then
    Result := AnsiLowercase(Params[0])
  else if MethodName = 'TRIM' then
    Result := Trim(Params[0])
  else if MethodName = 'NAMECASE' then
    Result := NameCase(Params[0])
  else if MethodName = 'COMPARETEXT' then
    Result := AnsiCompareText(Params[0], Params[1])
  else if MethodName = 'CHR' then
    Result := Chr(Integer(Params[0]))
  else if MethodName = 'ORD' then
    Result := Ord(String(Params[0])[1])
  else if MethodName = 'SETLENGTH' then
  begin
    if (TVarData(Params[0]).VType = varString) or
      (TVarData(Params[0]).VType = varOleStr) then
    begin
      s := Params[0];
      SetLength(s, Integer(Params[1]));
      Params[0] := s;
    end
    else
    begin
      v := Params[0];
      VarArrayRedim(v, Integer(Params[1]) - 1);
      Params[0] := v;
    end;
  end
end;

function TFunctions.CallMethod6(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
begin
  if MethodName = 'ROUND' then
    Result := Integer(Round(Params[0]))
  else if MethodName = 'TRUNC' then
    Result := Integer(Trunc(Params[0]))
  else if MethodName = 'INT' then
    Result := Int(Params[0])
  else if MethodName = 'FRAC' then
    Result := Frac(Params[0])
  else if MethodName = 'SQRT' then
    Result := Sqrt(Params[0])
  else if MethodName = 'ABS' then
    Result := Abs(Params[0])
  else if MethodName = 'SIN' then
    Result := Sin(Params[0])
  else if MethodName = 'COS' then
    Result := Cos(Params[0])
  else if MethodName = 'ARCTAN' then
    Result := ArcTan(Params[0])
  else if MethodName = 'TAN' then
    Result := Sin(Params[0]) / Cos(Params[0])
  else if MethodName = 'EXP' then
    Result := Exp(Params[0])
  else if MethodName = 'LN' then
    Result := Ln(Params[0])
  else if MethodName = 'PI' then
    Result := Pi
end;

function TFunctions.CallMethod7(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
begin
  if MethodName = 'INC' then
  begin
    Params[0] := Params[0] + Params[1];
  end
  else if MethodName = 'DEC' then
  begin
    Params[0] := Params[0] - Params[1];
  end
  else if MethodName = 'RAISEEXCEPTION' then
    raise Exception.Create(Params[0])
{$IFNDEF NOFORMS}
  else if MethodName = 'SHOWMESSAGE' then
    ShowMessage(Params[0])
{$ENDIF}
  else if MethodName = 'RANDOMIZE' then
    Randomize
  else if MethodName = 'RANDOM' then
    Result := Random
  else if MethodName = 'VALIDINT' then
    Result := ValidInt(Params[0])
  else if MethodName = 'VALIDFLOAT' then
    Result := ValidFloat(Params[0])
  else if MethodName = 'VALIDDATE' then
    Result := ValidDate(Params[0])
{$IFDEF OLE}
  else if MethodName = 'CREATEOLEOBJECT' then
    Result := CreateOleObject(Params[0])
{$ENDIF}
  else if MethodName = 'VARARRAYCREATE' then
    Result := VArrayCreate(Params[0], Params[1])
  else if MethodName = 'VARTOSTR' then
    Result := VarToStr(Params[0])
  else if MethodName = 'VARTYPE' then
    Result := VarType(Params[0])
end;


initialization
  Functions := TFunctions.Create;

finalization
  Functions.Free;

end.
