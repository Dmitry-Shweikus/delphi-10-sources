
{******************************************}
{                                          }
{             FastScript v1.8              }
{        BDE classes and functions         }
{                                          }
{  (c) 2003-2005 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_ibdertti;

interface

{$i fs.inc}

uses SysUtils, Classes, fs_iinterpreter, fs_itools, fs_idbrtti, DB, DBTables;

type
  TfsBDERTTI = class(TComponent); // fake component


implementation

type
  TFunctions = class(TObject)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function GetProp(Instance: TObject; ClassType: TClass;
      const PropName: String): Variant;
  public
    constructor Create;
    destructor Destroy; override;
  end;

var
  Functions: TFunctions;


{ TFunctions }

constructor TFunctions.Create;
begin
  with fsGlobalUnit do
  begin
    AddedBy := Self;
    AddEnum('TTableType', 'ttDefault, ttParadox, ttDBase, ttFoxPro, ttASCII');
    AddEnum('TParamBindMode', 'pbByName, pbByNumber');

    AddClass(TSession, 'TComponent');
    AddClass(TDatabase, 'TComponent');
    AddClass(TBDEDataSet, 'TDataSet');
    AddClass(TDBDataSet, 'TBDEDataSet');
    with AddClass(TTable, 'TDBDataSet') do
    begin
      AddMethod('procedure CreateTable', CallMethod);
      AddMethod('procedure DeleteTable', CallMethod);
      AddMethod('procedure EmptyTable', CallMethod);
      AddMethod('function FindKey(const KeyValues: array): Boolean', CallMethod);
      AddMethod('procedure FindNearest(const KeyValues: array)', CallMethod);
      AddMethod('procedure RenameTable(const NewTableName: string)', CallMethod);
    end;
    with AddClass(TQuery, 'TDBDataSet') do
    begin
      AddMethod('procedure ExecSQL', CallMethod);
      AddMethod('function ParamByName(const Value: string): TParam', CallMethod);
      AddMethod('procedure Prepare', CallMethod);
      AddProperty('ParamCount', 'Word', GetProp, nil);
    end;
    with AddClass(TStoredProc, 'TDBDataSet') do
    begin
      AddMethod('procedure ExecProc', CallMethod);
      AddMethod('function ParamByName(const Value: string): TParam', CallMethod);
      AddMethod('procedure Prepare', CallMethod);
      AddProperty('ParamCount', 'Word', GetProp, nil);
    end;

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

  function DoFindKey: Boolean;
  var
    ar: TVarRecArray;
  begin
    VariantToVarRec(Params[0], ar);
    Result := TTable(Instance).FindKey(ar);
    ClearVarRec(ar);
  end;

  procedure DoFindNearest;
  var
    ar: TVarRecArray;
  begin
    VariantToVarRec(Params[0], ar);
    TTable(Instance).FindNearest(ar);
    ClearVarRec(ar);
  end;

begin
  Result := 0;

  if ClassType = TTable then
  begin
    if MethodName = 'CREATETABLE' then
      TTable(Instance).CreateTable
    else if MethodName = 'DELETETABLE' then
      TTable(Instance).DeleteTable
    else if MethodName = 'EMPTYTABLE' then
      TTable(Instance).EmptyTable
    else if MethodName = 'FINDKEY' then
      Result := DoFindKey
    else if MethodName = 'FINDNEAREST' then
      DoFindNearest
    else if MethodName = 'RENAMETABLE' then
      TTable(Instance).RenameTable(Params[0])
  end
  else if ClassType = TQuery then
  begin
    if MethodName = 'EXECSQL' then
      TQuery(Instance).ExecSQL
    else if MethodName = 'PARAMBYNAME' then
      Result := Integer(TQuery(Instance).ParamByName(Params[0]))
    else if MethodName = 'PREPARE' then
      TQuery(Instance).Prepare
  end
  else if ClassType = TStoredProc then
  begin
    if MethodName = 'EXECPROC' then
      TStoredProc(Instance).ExecProc
    else if MethodName = 'PARAMBYNAME' then
      Result := Integer(TStoredProc(Instance).ParamByName(Params[0]))
    else if MethodName = 'PREPARE' then
      TStoredProc(Instance).Prepare
  end
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TQuery then
  begin
    if PropName = 'PARAMCOUNT' then
      Result := TQuery(Instance).ParamCount
  end
  else if ClassType = TStoredProc then
  begin
    if PropName = 'PARAMCOUNT' then
      Result := TStoredProc(Instance).ParamCount
  end
end;


initialization
  Functions := TFunctions.Create;

finalization
  Functions.Free;


end.
