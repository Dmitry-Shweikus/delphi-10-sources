unit Unit2;

interface

{$I fs.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, fs_iInterpreter;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    ExpressionE: TEdit;
    Label2: TLabel;
    ResultM: TMemo;
    procedure ExpressionEKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

uses Unit1
{$IFDEF Delphi6}
,Variants
{$ENDIF};



procedure TForm2.ExpressionEKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    ResultM.Text := VarToStr(Form1.fsScript1.Evaluate(ExpressionE.Text));
    ExpressionE.SelectAll;
  end
  else if Key = #27 then
    Close;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  ExpressionE.SelectAll;
  ResultM.Text := '';
end;

end.
