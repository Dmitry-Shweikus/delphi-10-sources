
{******************************************}
{                                          }
{             FastScript v1.8              }
{            Registration unit             }
{                                          }
{  (c) 2003-2005 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_iibxreg;

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
, fs_iibxrtti;

{-----------------------------------------------------------------------}

procedure Register;
begin
  RegisterComponents('FastScript', [TfsIBXRTTI]);
end;

end.
