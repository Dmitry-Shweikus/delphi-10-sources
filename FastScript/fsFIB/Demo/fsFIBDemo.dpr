program fsFIBDemo;

uses
  Forms,
  fsFIBDemoFrm in 'fsFIBDemoFrm.pas' {fsFIBDemoForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfsFIBDemoForm, fsFIBDemoForm);
  Application.Run;
end.
