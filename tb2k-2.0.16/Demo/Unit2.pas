unit Unit2;

interface

uses
  Forms, Classes, Controls, StdCtrls;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.DFM}

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Dec(Form1.MdiCounter);

  If (Form1.MdiCounter = 0) and
     Not (Form1.TBSkinOptions = nil) Then
   Form1.SkinOptionsToolWindow.Visible := True;

  Action := caFree;
end;

end.

