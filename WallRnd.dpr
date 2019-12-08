program WallRnd;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {Form1},
  AboutForm in 'AboutForm.pas' {Form2},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
