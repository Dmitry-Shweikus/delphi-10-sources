
{******************************************}
{                                          }
{             FastScript v1.8              }
{            Registration unit             }
{                                          }
{  (c) 2003-2005 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_ireg;

{$i fs.inc}
{$I fs_ireg.inc}

interface


procedure Register;

implementation

uses
  Classes
{$IFNDEF Delphi6}
, DsgnIntf
{$ELSE}
, DesignIntf
{$ENDIF}
, fs_iinterpreter, fs_iclassesrtti, fs_igraphicsrtti, fs_iformsrtti
, fs_iextctrlsrtti, fs_idialogsrtti, 
  fs_ipascal, fs_icpp, fs_ijs, fs_ibasic
{$IFNDEF CLX}
, fs_ichartrtti, fs_synmemo
{$ENDIF}
, fs_tree;

{-----------------------------------------------------------------------}

procedure Register;
begin
  RegisterComponents('FastScript', 
    [TfsScript, TfsPascal, TfsCPP, TfsJScript, TfsBasic,
    TfsClassesRTTI, TfsGraphicsRTTI, TfsFormsRTTI, TfsExtCtrlsRTTI, 
    TfsDialogsRTTI
{$IFNDEF CLX}
  , TfsChartRTTI, TfsSyntaxMemo
{$ENDIF}
  , TfsTree]);
end;

end.
