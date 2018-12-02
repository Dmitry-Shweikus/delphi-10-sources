
{******************************************}
{                                          }
{             FastScript v1.8              }
{        IBX classes and functions         }
{                                          }
{  (c) 2003-2005 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_iibxrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_itools, fs_idbrtti, db, ibdatabase,
  IBCustomDataSet, IBQuery, IBTable, IBStoredProc;

type
  TfsIBXRTTI = class(TComponent); // fake component


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
    AddClass(TIBDataBase, 'TComponent');
    AddClass(TIBTransaction, 'TComponent');
    AddClass(TIBCustomDataSet, 'TDataSet');
    AddClass(TIBTable, 'TIBCustomDataSet');
    with AddClass(TIBQuery, 'TIBCustomDataSet') do
      AddMethod('procedure ExecSQL', CallMethod);
    with AddClass(TIBStoredProc, 'TIBCustomDataSet') do
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

  if ClassType = TIBQuery then
  begin
    if MethodName = 'EXECSQL' then
      TIBQuery(Instance).ExecSQL
  end
  else if ClassType = TIBStoredProc then
  begin
    if MethodName = 'EXECPROC' then
      TIBStoredProc(Instance).ExecProc
  end
end;



initialization
  Functions := TFunctions.Create;

finalization
  Functions.Free;


end.
