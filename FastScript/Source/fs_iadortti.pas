
{******************************************}
{                                          }
{             FastScript v1.8              }
{        ADO classes and functions         }
{                                          }
{  (c) 2003-2005 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_iadortti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_itools, fs_idbrtti, DB, ADODB, ADOInt;

type
  TfsADORTTI = class(TComponent); // fake component


implementation

type
  TFunctions = class(TObject)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
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
    AddType('TDataType', fvtInt);
    AddClass(TADOConnection, 'TComponent');
    AddClass(TParameter, 'TCollectionItem');
    with AddClass(TParameters, 'TCollection') do
    begin
      AddMethod('function AddParameter: TParameter', CallMethod);
      AddDefaultProperty('Items', 'Integer', 'TParameter', CallMethod, True);
    end;
    AddClass(TCustomADODataSet, 'TDataSet');
    AddClass(TADOTable, 'TCustomADODataSet');
    with AddClass(TADOQuery, 'TCustomADODataSet') do
      AddMethod('procedure ExecSQL', CallMethod);
    with AddClass(TADOStoredProc, 'TCustomADODataSet') do
      AddMethod('procedure ExecProc', CallMethod);

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
begin
  Result := 0;

  if ClassType = TParameters then
  begin
    if MethodName = 'ADDPARAMETER' then
      Result := Integer(TParameters(Instance).AddParameter)
    else if MethodName = 'ITEMS.GET' then
      Result := Integer(TParameters(Instance).Items[Params[0]])
  end
  else if ClassType = TADOQuery then
  begin
    if MethodName = 'EXECSQL' then
      TADOQuery(Instance).ExecSQL
  end
  else if ClassType = TADOStoredProc then
  begin
    if MethodName = 'EXECPROC' then
      TADOStoredProc(Instance).ExecProc
  end
end;


initialization
  Functions := TFunctions.Create;

finalization
  Functions.Free;


end.
