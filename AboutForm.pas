unit AboutForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TForm2 = class(TForm)
    AppVersionLabel: TLabel;
    AppInfoMemo: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

function GetAppVersionStr: string;
var
  Exe: string;
  Size, Handle: DWORD;
  Buffer: TBytes;
  FixedPtr: PVSFixedFileInfo;
begin
  Exe := ParamStr(0);
  Size := GetFileVersionInfoSize(PChar(Exe), Handle);
  if Size = 0 then
    RaiseLastOSError;
  SetLength(Buffer, Size);
  if not GetFileVersionInfo(PChar(Exe), Handle, Size, Buffer) then
    RaiseLastOSError;
  if not VerQueryValue(Buffer, '\', Pointer(FixedPtr), Size) then
    RaiseLastOSError;
  Result := Format('%d.%d.%d', [LongRec(FixedPtr.dwFileVersionMS).Hi,
    LongRec(FixedPtr.dwFileVersionMS).Lo, LongRec(FixedPtr.dwFileVersionLS).Hi,
    LongRec(FixedPtr.dwFileVersionLS).Lo])
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  AppVersionLabel.Caption := 'WallRnd ' + GetAppVersionStr;
  AppInfoMemo.Text :=
    'This is an open-source app created by Sigmanor and licensed under MIT.' +
    'The source code, issues and documentation posted on GitHub.' + sLineBreak +
    sLineBreak + 'Github: https://github.com/Sigmanor/WallRnd' + sLineBreak +
    'Website: https://sigmanor.net/' + sLineBreak +
    'Icons: https://www.fatcow.com/free-icons';
end;

end.
