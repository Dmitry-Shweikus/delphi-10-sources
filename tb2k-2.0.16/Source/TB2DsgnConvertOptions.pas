unit TB2DsgnConvertOptions;

{
  Toolbar2000
  Copyright (C) 1998-2002 by Jordan Russell
  All rights reserved.
  For conditions of distribution and use, see LICENSE.TXT.

  $jrsoftware: tb2k/Source/TB2DsgnConvertOptions.pas,v 1.4 2002/11/15 00:15:07 jr Exp $
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TTBConvertOptionsForm = class(TForm)
    MenuCombo: TComboBox;
    Label1: TLabel;
    ConvertButton: TButton;
    HelpButton: TButton;
    Button1: TButton;
    procedure HelpButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTBConvertOptionsForm.HelpButtonClick(Sender: TObject);
const
  SMsg1 = 'This will import the contents of a TMainMenu or TPopupMenu ' +
    'component on the form.'#13#10#13#10 +
    'The new items will take the names of the old menu ' +
    'items. The old menu items will have "_OLD" appended to the end of ' +
    'their names.'#13#10#13#10 +
    'After the conversion process completes, you should verify that ' +
    'everything was copied correctly. Afterward, you may delete the ' +
    'old menu component.';
begin
  Application.MessageBox(SMsg1, 'Convert Help', MB_OK or MB_ICONINFORMATION);
end;

end.
