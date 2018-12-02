{******************************************}
{                                          }
{             FastScript v1.8              }
{        FIBPlus classes and functions     }
{                                          }
{ (C) Roman V. Babenko aka romb            }
{  mailto: romb@interbase-world.com        }
{  Version: 1.2                            }
{******************************************}

unit fs_ifibrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter,
  fs_itools, fs_idbrtti, db,
  FIBDataSet, pFIBProps,
  FIBDatabase, pFIBDatabase, pFIBDataSet, pFIBQuery;

type
  TfsFIBRTTI = class(TComponent); // fake component


implementation

uses FIBQuery, Dialogs, Contnrs;

type
  TFunctions = class(TObject)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    procedure SetProp( Instance: TObject; ClassType: TClass;
      const PropName: String; Value : Variant );
    function GetProp( Instance: TObject; ClassType: TClass;
      const PropName: String ) : Variant;
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
    AddEnumSet( 'TpFIBQueryOptions', 'qoStartTransaction, qoAutoCommit, qoTrimCharFields, qoNoForceIsNull, qoFreeHandleAfterExecute' );
    AddEnumSet( 'TDetailConditions', 'dcForceOpen,dcIgnoreMasterClose,dcForceMasterRefresh, dcWaitEndMasterScroll' );
    AddEnum( 'TpFIBDsOption', 'poTrimCharFields,poRefreshAfterPost,poRefreshDeletedRecord, poStartTransaction,poAutoFormatFields,poProtectedEdit,poKeepSorting, poAllowChangeSqls, poPersistentSorting,poVisibleRecno,poNoForceIsNull,poFetchAll,poFreeHandlesAfterClose' );
    AddEnum( 'TpPrepareOption', 'pfSetRequiredFields,pfSetReadOnlyFields,pfImportDefaultValues,psUseBooleanField,psUseGuidField,psSQLINT64ToBCD,psApplyRepositary,psGetOrderInfo, psAskRecordCount,psCanEditComputedFields,psSetEmptyStrToNull,psSupportUnicodeBlobs' );

    AddClass( TAutoUpdateOptions, 'TPersistent' );
    AddClass( TConnectParams, 'TPersistent' );
    AddClass( TSQLs, 'TPersistent' );
    AddClass( TFormatFields, 'TPersistent' );

    with AddClass( TCondition, 'TObject' ) do
     begin
      AddProperty( 'Enabled', 'Boolean', GetProp, SetProp );
      AddProperty( 'Name', 'String', GetProp, SetProp );
      AddProperty( 'Value', 'String', GetProp, SetProp );
     end;

    with AddClass( TConditions, 'TStringList' ) do
     begin
      AddMethod( 'function    ByName(const Name:string):TCondition', CallMethod );
      AddMethod( 'procedure   Apply', CallMethod );
      AddMethod( 'function    AddCondition(const Name,Condition:string;Enabled:boolean):TCondition', CallMethod );
      AddProperty( 'Applied', 'Boolean', GetProp );
     end;

    with AddClass( TFIBXSQLVAR, 'TObject' ) do
     begin
      AddProperty( 'Value', 'Variant', GetProp, SetProp );
     end;

    AddClass(TDBParams, 'TStringList' );

    AddClass(TFIBDataBase, 'TComponent' );
    AddClass(TpFIBDataBase, 'TFIBDataBase' );

    with AddClass(TFIBTransaction, 'TComponent') do
     begin
      AddProperty( 'InTransaction', 'Boolean', GetProp );      // !
      AddMethod( 'procedure StartTransaction', CallMethod );   // !
      AddMethod( 'procedure Commit', CallMethod );             // !
      AddMethod( 'procedure CommitRetaining', CallMethod );    // !
      AddMethod( 'procedure Rollback', CallMethod );           // !
      AddMethod( 'procedure RollbackRetaining', CallMethod );  // !
     end;

    with AddClass(TpFIBTransaction, 'TFIBTransaction') do
     begin
      // inherited
     end;

    AddClass( TFIBCustomDataSet, 'TDataSet' );
    with AddClass(TFIBDataSet, 'TFIBCustomDataSet') do
     begin
      AddMethod( 'function FN(const FieldName: string): TField', CallMethod );
     end;
    with AddClass(TpFIBDataSet, 'TFIBDataSet') do
     begin
      AddMethod( 'function  PN(const ParamName:string): TFIBXSQLVAR', CallMethod );
      AddMethod( 'function  RecordCountFromSrv: integer;', CallMethod );
     end;

    with AddClass(TFIBQuery, 'TComponent') do
     begin
      AddProperty( 'EoF', 'Boolean', GetProp );
      AddMethod('procedure Close', CallMethod);
      AddMethod('function  Next: TFIBXSQLDA;', CallMethod);
     end;

    with AddClass(TpFIBQuery, 'TFIBQuery') do
     begin
      AddMethod('procedure ExecQuery', CallMethod); // !
      AddMethod('function  FN(const FieldName:String) : TFIBXSQLVAR', CallMethod);
      AddMethod( 'function  PN(const ParamName:String): TFIBXSQLVAR', CallMethod );
     end;
    AddedBy := nil;
  end;
end;

destructor TFunctions.Destroy;
begin
 if fsGlobalUnit <> nil
 then fsGlobalUnit.RemoveItems( Self );
 inherited;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
begin
 Result := 0;
 {TpFIBQuery}
 if ClassType = TpFIBQuery
 then begin
  if MethodName = 'EXECQUERY'
  then TpFIBQuery(Instance).ExecQuery;

  if MethodName = 'FN'
  then Result := Integer( TpFIBQuery( Instance ).FieldByName( Params[ 0 ] ) );

  if MethodName = 'PN'
  then begin
        Result := Integer( TpFIBQuery( Instance ).ParamByName( Params[ 0 ] ) );
       end;
 end
 else
 {TFIBDataSet}
 if ClassType = TFIBDataSet
 then begin
  if MethodName = 'FN'
  then begin
        Result := Integer( TFIBDataSet( Instance ).FieldByName( Params[ 0 ] ) );
       end;
 end;

 if ClassType = TpFIBDataSet
 then begin
  if MethodName = 'PN'
  then begin
        Result := Integer( TpFIBDataSet( Instance ).ParamByName( Params[ 0 ] ) );
       end;
  if MethodName = 'RECORDCOUNTFROMSRV'
  then Result := TpFIBDataSet( Instance ).RecordCountFromSrv
 end
  else
  {TFIBTransaction}
  if ClassType = TFIBTransaction
  then begin
   if MethodName = 'STARTTRANSACTION'
   then begin
         TFIBTransaction( Instance ).StartTransaction
        end;

   if MethodName = 'COMMIT'
   then begin
         TFIBTransaction( Instance ).Commit
        end;

   if MethodName = 'COMMITRETAINING'
   then begin
         TFIBTransaction( Instance ).CommitRetaining;
        end;

   if MethodName = 'ROLLBACK'
   then begin
         TFIBTransaction( Instance ).Rollback
        end;

   if MethodName = 'ROLLBACKRETAINING'
   then begin
         TFIBTransaction( Instance ).RollbackRetaining
        end;
 end
 else
 {TFIBQuery}
 if ClassType = TFIBQuery
 then begin
       if MethodName = 'CLOSE'
       then begin
             TFIBQuery( Instance ).Close
            end;

       if MethodName = 'NEXT'
       then begin
             Result := Integer( TFIBQuery( Instance ).Next )
            end;
 end
 else
 {TConditions}
 if ClassType = TConditions
 then begin
  if MethodName ='BYNAME'
  then Result := Integer( TConditions( Instance ).ByName( Params[0] ) );

  if MethodName ='ADDCONDITION'
  then Result := Integer( TConditions( Instance ).AddCondition( Params[0], Params[1], Params[2] ) );

  if MethodName ='APPLY'
  then TConditions( Instance ).Apply;
 end;
end;


procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
 {TFIBXSQLVAR}
 if ClassType = TFIBXSQLVAR
 then begin
  if PropName='VALUE'
  then begin
        TFIBXSQLVAR( Instance ).Value := Value
       end;
 end
 else
 {TCondition}
 if ClassType = TCondition
 then begin
  if PropName = 'ENABLED'
  then begin
        TCondition( Instance ).Enabled := Value;
       end;

  if PropName = 'NAME'
  then begin
        TCondition( Instance ).Name := Value;
       end;

  if PropName = 'VALUE'
  then begin
        TCondition( Instance ).Value := Value;
       end;
 end;
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
 {TFIBXSQLVAR}
 if ClassType = TFIBXSQLVAR
 then begin
  if PropName='VALUE'
  then begin
        Result := TFIBXSQLVAR( Instance ).Value
       end;
  end
 else
 {TFIBTransaction}
 if ClassType = TFIBTransaction
 then begin
       if PropName = 'INTRANSACTION'
       then Result := TFIBTransaction( Instance ).InTransaction
 end
 else
 {TFIBQuery}
 if ClassType = TFIBQuery
 then begin
  if PropName = 'EOF'
  then Result := TFIBQuery( Instance ).Eof
 end
 else
 {TConditions}
 if ClassType = TConditions
 then begin
       if PropName = 'APPLIED'
       then Result := TConditions( Instance ).Applied
      end
 else
 {TCondition}
 if ClassType = TCondition
 then begin
       if PropName = 'ENABLED'
       then Result := TCondition( Instance ).Enabled;

       if PropName = 'NAME'
       then Result := TCondition( Instance ).Name;

       if PropName = 'VALUE'
       then Result := TCondition( Instance ).Value;
      end;
end;

initialization
  Functions := TFunctions.Create;

finalization
  Functions.Free;


end.
