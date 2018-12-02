unit Unit1;

interface

{$I fs.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fs_iInterpreter, StdCtrls, fs_ipascal, fs_itools;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    fsPascal1: TfsPascal;
    fsScript1: TfsScript;
    function OnCall(Instance: TObject; ClassType: TClass;
    const MethodName: String; var Params: Variant): Variant;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{$IFDEF Delphi6}
uses Variants;
{$ENDIF}

procedure TForm1.Button1Click(Sender: TObject);
begin
  { clear all items }
  //fsScript1.Clear;
  fsScript1.AddMethod('function a(i : Integer):Integer',OnCall);
  fsScript1.Parent := fsGlobalUnit;
  { script text }
  fsScript1.Lines := Memo1.Lines;
  { frGlobalUnit contains standard types and functions }

  { compile the script }
  if fsScript1.Compile then
    fsScript1.Execute else   { execute if compilation was succesfull }
    ShowMessage(fsScript1.ErrorMsg); { show an error message }
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  fsPascal1 := TfsPascal.Create(Self);
  fsScript1 := TfsScript.Create(Self);

end;

function TForm1.OnCall(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
begin
  Result := 1;
end;

end.
