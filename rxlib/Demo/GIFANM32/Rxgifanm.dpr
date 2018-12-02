program RxGIFAnm;

uses
  Forms,
  RxExcptDlg,
  GifMain in 'GIFMAIN.PAS' {AnimatorForm},
  GifPrvw in 'GIFPRVW.PAS' {PreviewForm},
  GIFPal in 'GIFPal.pas' {PaletteForm},
  About in 'About.pas';

{$R *.RES}

begin
  RxErrorIntercept;
  Application.Title := 'RX GIF Animator';
  Application.CreateForm(TAnimatorForm, AnimatorForm);
  Application.Run;
end.
