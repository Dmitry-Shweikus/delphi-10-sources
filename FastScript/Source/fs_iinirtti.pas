{******************************************}
{                                          }
{             FastScript v1.8              }
{    IniFiles.pas classes and functions    }
{                                          }
{  (c) 2003-2005 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{  Copyright (c) 2004 by Stalker SoftWare  }
{                                          }
{******************************************}

unit fs_iinirtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, IniFiles;

type
  TfsIniRTTI = class(TComponent); // fake component


implementation

type
  TFunctions = class(TObject)
  private
    function CallMethod(Instance: TObject; ClassType: TClass; const MethodName: String; var Params: Variant): Variant;
    function GetProp(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
  public
    constructor Create;
    destructor Destroy; override;
  end;

var
  Functions: TFunctions;


{ TFunctions }

constructor TFunctions.Create;
begin

 with fsGlobalUnit do begin
 
   AddedBy := Self;

   with AddClass(TIniFile, 'TObject') do  begin
     AddConstructor('constructor Create(const FileName: String)', CallMethod);
     AddMethod('procedure WriteString(const Section, Ident, Value: String)', CallMethod);
     AddMethod('function ReadString(const Section, Ident, Default: String): String;', CallMethod);
     AddMethod('function ReadInteger(const Section, Ident: String; Default: LongInt): LongInt', CallMethod);
     AddMethod('procedure WriteInteger(const Section, Ident: String; Value: LongInt)', CallMethod);
     AddMethod('function ReadBool(const Section, Ident: String; Default: Boolean): Boolean', CallMethod);
     AddMethod('procedure WriteBool(const Section, Ident: String; Value: Boolean)', CallMethod);
     AddMethod('function ReadDate(const Section, Name: String; Default: TDateTime): TDateTime', CallMethod);
     AddMethod('procedure WriteDate(const Section, Name: String; Value: TDateTime)', CallMethod);
     AddMethod('function ReadDateTime(const Section, Name: String; Default: TDateTime): TDateTime', CallMethod);
     AddMethod('procedure WriteDateTime(const Section, Name: String; Value: TDateTime)', CallMethod);
     AddMethod('function ReadFloat(const Section, Name: String; Default: Double): Double', CallMethod);
     AddMethod('procedure WriteFloat(const Section, Name: String; Value: Double)', CallMethod);
     AddMethod('function ReadTime(const Section, Name: String; Default: TDateTime): TDateTime', CallMethod);
     AddMethod('procedure WriteTime(const Section, Name: String; Value: TDateTime);', CallMethod);
     AddMethod('function ReadBinaryStream(const Section, Name: String; Value: TStream): Integer', CallMethod);
     AddMethod('procedure WriteBinaryStream(const Section, Name: String; Value: TStream)', CallMethod);
     AddMethod('function SectionExists(const Section: String): Boolean', CallMethod);
     AddMethod('procedure DeleteKey(const Section, Ident: String)', CallMethod);
     AddMethod('function ValueExists(const Section, Ident: String): Boolean', CallMethod);
     AddMethod('procedure ReadSection(const Section: String; Strings: TStrings)', CallMethod);
     AddMethod('procedure ReadSections(Strings: TStrings)', CallMethod);
     AddMethod('procedure ReadSectionValues(const Section: String; Strings: TStrings)', CallMethod);
     AddMethod('procedure EraseSection(const Section: String)', CallMethod);
     AddMethod('procedure ReadSectionValuesEx(const Section: String; Strings: TStrings)', CallMethod);
     AddProperty('FileName', 'String', GetProp);
   end; { with }

   AddedBy := nil;

 end; { with }

end; { Create }

destructor TFunctions.Destroy;
begin

 if fsGlobalUnit <> nil then
   fsGlobalUnit.RemoveItems(Self);

 inherited;

end; { Destroy }

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass; const MethodName: String; var Params: Variant): Variant;
var
  oTIniFile :TIniFile;
  oList     :TStrings;
  nCou      :Integer;

begin

 Result := 0;

 if ClassType = TIniFile then begin

   oTIniFile := TIniFile(Instance);

   if MethodName = 'CREATE' then
     Result := Integer(oTIniFile.Create(Params[0]))
   else
   if MethodName = 'WRITESTRING' then
     oTIniFile.WriteString(Params[0], Params[1], Params[2])
   else
   if MethodName = 'READSTRING' then
     Result := oTIniFile.ReadString(Params[0], Params[1], Params[2])
   else
   if MethodName = 'WRITEINTEGER' then
     oTIniFile.WriteInteger(Params[0], Params[1], Params[2])
   else
   if MethodName = 'READINTEGER' then
     Result := oTIniFile.ReadInteger(Params[0], Params[1], Params[2])
   else
   if MethodName = 'WRITEBOOL' then
     oTIniFile.WriteBool(Params[0], Params[1], Params[2])
   else
   if MethodName = 'READBOOL' then
     Result := oTIniFile.ReadBool(Params[0], Params[1], Params[2])
   else
   if MethodName = 'WRITEDATE' then
     oTIniFile.WriteDate(Params[0], Params[1], Params[2])
   else
   if MethodName = 'READDATE' then
     Result := oTIniFile.ReadDate(Params[0], Params[1], Params[2])
   else
   if MethodName = 'WRITEDATETIME' then
     oTIniFile.WriteDateTime(Params[0], Params[1], Params[2])
   else
   if MethodName = 'READDATETIME' then
     Result := oTIniFile.ReadDateTime(Params[0], Params[1], Params[2])
   else
   if MethodName = 'WRITEFLOAT' then
     oTIniFile.WriteFloat(Params[0], Params[1], Params[2])
   else
   if MethodName = 'READFLOAT' then
     Result := oTIniFile.ReadFloat(Params[0], Params[1], Params[2])
   else
   if MethodName = 'WRITETIME' then
     oTIniFile.WriteTime(Params[0], Params[1], Params[2])
   else
   if MethodName = 'READTIME' then
     Result := oTIniFile.ReadTime(Params[0], Params[1], Params[2])
   else
   if MethodName = 'WRITEBINARYSTREAM' then
     oTIniFile.WriteBinaryStream(Params[0], Params[1], TStream(Integer(Params[2])))
   else
   if MethodName = 'READBINARYSTREAM' then
     Result := oTIniFile.ReadBinaryStream(Params[0], Params[1], TStream(Integer(Params[2])))
   else
   if MethodName = 'SECTIONEXISTS' then
     Result := oTIniFile.SectionExists(Params[0])
   else
   if MethodName = 'DELETEKEY' then
     oTIniFile.DeleteKey(Params[0], Params[1])
   else
   if MethodName = 'VALUEEXISTS' then
     Result := oTIniFile.ValueExists(Params[0], Params[1])
   else
   if MethodName = 'READSECTION' then
     oTIniFile.ReadSection(Params[0], TStrings(Integer(Params[1])))
   else
   if MethodName = 'READSECTIONS' then
     oTIniFile.ReadSections(TStrings(Integer(Params[0])))
   else
   if MethodName = 'READSECTIONVALUES' then
     oTIniFile.ReadSectionValues(Params[0], TStrings(Integer(Params[1])))
   else
   if MethodName = 'ERASESECTION' then
     oTIniFile.EraseSection(Params[0])
   else
   if MethodName = 'READSECTIONVALUESEX' then begin

     oList := TStringList.Create;
     try
     
       oTIniFile.ReadSectionValues(Params[0], oList);

       TStrings(Integer(Params[1])).Clear;

       for nCou := 0 to oList.Count-1 do
         TStrings(Integer(Params[1])).Add(oList.ValueFromIndex[nCou]);

     finally
       oList.Free;
     end; { try }

   end; { if }

 end; { if }

end; { CallMethod }

function TFunctions.GetProp(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin

 Result := 0;

 if ClassType = TIniFile then begin

   if PropName = 'FILENAME' then
     Result := TIniFile(Instance).FileName

 end; { if }

end; { GetProp }

initialization
  Functions := TFunctions.Create;

finalization
  Functions.Free;

end.
