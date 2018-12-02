unit fsFIBDemoFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  ExtCtrls, FIBDatabase, pFIBDatabase, DB, FIBDataSet, pFIBDataSet,
  // FastScript
  fs_idbctrlsrtti, fs_idbrtti, fs_idialogsrtti, fs_iformsrtti,
  fs_igraphicsrtti, fs_iclassesrtti, fs_ipascal, fs_iinterpreter,
  fs_synmemo, fs_ifibrtti, fs_tree, fs_iextctrlsrtti;

type
  TfsFIBDemoForm = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    fsScript1: TfsScript;
    fsPascal1: TfsPascal;
    fsClassesRTTI1: TfsClassesRTTI;
    fsGraphicsRTTI1: TfsGraphicsRTTI;
    fsFormsRTTI1: TfsFormsRTTI;
    fsDialogsRTTI1: TfsDialogsRTTI;
    fsDBRTTI1: TfsDBRTTI;
    fsDBCtrlsRTTI1: TfsDBCtrlsRTTI;
    pFIBDatabase1: TpFIBDatabase;
    pFIBDataSet1: TpFIBDataSet;
    pFIBTransaction1: TpFIBTransaction;
    SyntaxEdit1: TfsSyntaxMemo;
    fsExtCtrlsRTTI1: TfsExtCtrlsRTTI;
    fsTree1: TfsTree;
    fsFIBRTTI1: TfsFIBRTTI;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fsFIBDemoForm: TfsFIBDemoForm;

implementation

{$R *.dfm}

procedure TfsFIBDemoForm.Button1Click(Sender: TObject);
begin
 fsScript1.Clear;
 fsScript1.Parent := fsGlobalUnit;
 fsScript1.Lines.Assign( SyntaxEdit1.Lines );
 if fsScript1.Compile
 then begin
       fsScript1.Execute
      end
 else begin
       MessageDlg(Format( '%s %s', [ fsScript1.ErrorMsg, fsScript1.ErrorPos ] ), mtError, [mbOK], 0);
      end;
end;

procedure TfsFIBDemoForm.FormCreate(Sender: TObject);
begin
  fsGlobalUnit.AddForm(fsFIBDemoForm);
end;

end.
