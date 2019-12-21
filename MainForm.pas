unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Vcl.ExtDlgs,
  Vcl.StdCtrls, Vcl.FileCtrl, IniFiles, AboutForm, Registry, Vcl.Themes,
  Vcl.Buttons, System.ImageList, Vcl.ImgList;

type
  TForm1 = class(TForm)
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Exit1: TMenuItem;
    Pause1: TMenuItem;
    Timer1: TTimer;
    ListBox1: TListBox;
    Settings1: TMenuItem;
    NextWallpaper1: TMenuItem;
    About1: TMenuItem;
    DirectoryLabel: TLabel;
    DirectoryEdit: TEdit;
    IntervalLabel: TLabel;
    IntervalEdit: TEdit;
    FileOpenDialog1: TFileOpenDialog;
    Rescan1: TMenuItem;
    StartupCheckBox: TCheckBox;
    N1: TMenuItem;
    ThemeComboBox: TComboBox;
    ThemeLabel: TLabel;
    ChangeWallpaperCheckBox: TCheckBox;
    ChooseFolderButton: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Pause1Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure NextWallpaper1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Rescan1Click(Sender: TObject);
    procedure ThemeComboBoxChange(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure ChooseFolderButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Res: Integer;
  options: TSelectDirOpts;
  chosenDirectory: string;
  FDir: string;
  WallpaperName: string;

implementation

{$R *.dfm}

procedure ScanDir(StartDir: String; Mask: string; List: TStrings);
Var
  SearchRec: TSearchRec;
Begin
  IF Mask = '' then
    Mask := '*.*';
  IF StartDir[Length(StartDir)] <> '\' then
    StartDir := StartDir + '\';
  IF FindFirst(StartDir + Mask, faAnyFile, SearchRec) = 0 then
  Begin
    Repeat
      Application.ProcessMessages;
      IF (SearchRec.Attr and faDirectory) <> faDirectory then
        List.Add(StartDir + SearchRec.Name)
      else IF (SearchRec.Name <> '..') and (SearchRec.Name <> '.') then
      Begin
        List.Add(StartDir + SearchRec.Name + '\');
        ScanDir(StartDir + SearchRec.Name + '\', Mask, List);
      End;
    Until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  End;
end;

procedure SetAutoStart(AppName, AppTitle: string; bRegister: Boolean);
const
  RegKey = '\Software\Microsoft\Windows\CurrentVersion\Run';
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if Registry.OpenKey(RegKey, False) then
    begin
      if bRegister = False then
        Registry.DeleteValue(AppTitle)
      else
        Registry.WriteString(AppTitle, AppName);
    end;
  finally
    Registry.Free;
  end;
end;

procedure SaveSettings();
Var
  IniFile: TIniFile;
Begin
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  IniFile.WriteString('Main', 'Directory', Form1.DirectoryEdit.Text);
  IniFile.WriteString('Main', 'Interval', Form1.IntervalEdit.Text);
  IniFile.WriteBool('Main', 'Startup', Form1.StartupCheckBox.Checked);
  SetAutoStart(ParamStr(0), 'WallRnd', Form1.StartupCheckBox.Checked);
  IniFile.WriteInteger('Main', 'Theme', Form1.ThemeComboBox.ItemIndex);
  IniFile.WriteBool('Main', 'ChangeWallpaper',
    Form1.ChangeWallpaperCheckBox.Checked);
end;

procedure LoadSettings();
Var
  IniFile: TIniFile;
Begin
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  Form1.DirectoryEdit.Text := IniFile.ReadString('Main', 'Directory', '');
  Form1.IntervalEdit.Text := IniFile.ReadString('Main', 'Interval', '');
  Form1.StartupCheckBox.Checked := IniFile.ReadBool('Main', 'Startup', False);
  Form1.ThemeComboBox.ItemIndex := IniFile.ReadInteger('Main', 'Theme', 0);
  TStyleManager.TrySetStyle(Form1.ThemeComboBox.Text);
  Form1.ChangeWallpaperCheckBox.Checked :=
    IniFile.ReadBool('Main', 'ChangeWallpaper', False);
  Form1.Pause1.Checked := IniFile.ReadBool('Main', 'Timer', False);
  Form1.Timer1.Enabled := IniFile.ReadBool('Main', 'Timer', False);
end;

function BoolToStr(const value: Boolean): string;
begin
  if value then
    Result := 'Enabled'
  else
    Result := 'Disabled';
end;

procedure TrayIconHint();
Var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  Form1.TrayIcon1.Hint := 'Timer: ' + BoolToStr(Form1.Timer1.Enabled) +
    sLineBreak + 'Interval: ' + Form1.IntervalEdit.Text + ' minutes' +
    sLineBreak + 'Current image: ' + IniFile.ReadString('Main', 'WallpaperName',
    '') + sLineBreak + 'Number of wallpapers: ' +
    Form1.ListBox1.Items.Count.ToString;
end;

procedure RandomizeWallpaper();
var
  FileExtension: String;
  RandomNumber: Integer;
  IniFile: TIniFile;
begin
  if Form1.ListBox1.Items.Count <> 0 then
  begin
    RandomNumber := Random(Form1.ListBox1.Items.Count);
    FileExtension := ExtractFileExt(Form1.ListBox1.Items[RandomNumber]);
    WallpaperName := ExtractFileName(Form1.ListBox1.Items[RandomNumber]);
    if (FileExtension = '.jpeg') Or (FileExtension = '.jpg') Or
      (FileExtension = '.png') Or (FileExtension = '.bmp') then
    begin
      IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
      SystemParametersInfo(SPI_SETDESKWALLPAPER, 0,
        pChar(Form1.ListBox1.Items[RandomNumber]), SPIF_SENDWININICHANGE);
      IniFile.WriteString('Main', 'WallpaperName', WallpaperName);
    end
    else
    begin
      RandomizeWallpaper();
    end;

  end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
  IniFile: TIniFile;
begin
  CanClose := False;
  hide();
  SaveSettings();
  if (DirectoryEdit.Text <> '') And (IntervalEdit.Text <> '') then
  begin
    IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    Timer1.Interval := StrToInt(IntervalEdit.Text) * 60000;
    Timer1.Enabled := IniFile.ReadBool('Main', 'Timer', False);
  end;
  TrayIconHint();
end;

procedure TForm1.FormCreate(Sender: TObject);
Var
  IniFile: TIniFile;
begin
  LoadSettings();
  if (DirectoryEdit.Text <> '') And (IntervalEdit.Text <> '') then
  begin
    IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    Application.ShowMainForm := False;
    Timer1.Interval := StrToInt(IntervalEdit.Text) * 60000;
    Timer1.Enabled := IniFile.ReadBool('Main', 'Timer', False);
    ListBox1.Items.Clear;
    ScanDir(Form1.DirectoryEdit.Text, '', Form1.ListBox1.Items);
    if ChangeWallpaperCheckBox.Checked then
    begin
      RandomizeWallpaper();
    end;
  end;
  TrayIconHint();
end;

procedure TForm1.NextWallpaper1Click(Sender: TObject);
begin
  if (DirectoryEdit.Text <> '') And (IntervalEdit.Text <> '') then
  begin
    RandomizeWallpaper();
  end;
end;

procedure TForm1.Pause1Click(Sender: TObject);
Var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  IniFile.WriteBool('Main', 'Timer', Form1.Pause1.Checked);
  if (DirectoryEdit.Text <> '') And (IntervalEdit.Text <> '') then
  begin
    Timer1.Interval := StrToInt(IntervalEdit.Text) * 60000;
    Timer1.Enabled := Pause1.Checked
  end;
  TrayIconHint();
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
Begin
  if (DirectoryEdit.Text <> '') And (IntervalEdit.Text <> '') then
  begin
    Pause1.Enabled := True;
  end
  else
  begin
    Pause1.Enabled := False;
  end;
end;

procedure TForm1.Rescan1Click(Sender: TObject);
begin
  if Form1.ListBox1.Items.Count <> 0 then
  begin
    ListBox1.Items.Clear;
    ScanDir(Form1.DirectoryEdit.Text, '', Form1.ListBox1.Items);
  end;
end;

procedure TForm1.Settings1Click(Sender: TObject);
begin
  show;
end;

procedure TForm1.ThemeComboBoxChange(Sender: TObject);
begin
  TStyleManager.TrySetStyle(Form1.ThemeComboBox.Text);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  RandomizeWallpaper();
  TrayIconHint();
end;

procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  if (DirectoryEdit.Text <> '') And (IntervalEdit.Text <> '') then
  begin
    RandomizeWallpaper();
    TrayIconHint();
  end;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  Form2.show;
end;

procedure TForm1.ChooseFolderButtonClick(Sender: TObject);
begin
  if Win32MajorVersion >= 6 then
    with TFileOpenDialog.Create(nil) do
      try
        options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
        DefaultFolder := FDir;
        FileName := FDir;
        if Execute then
          if FileName <> '' then
          begin
            DirectoryEdit.Text := FileName;
            ListBox1.Items.Clear;
            ScanDir(Form1.DirectoryEdit.Text, '', Form1.ListBox1.Items);
          end;

      finally
        Free;
      end
  else if SelectDirectory('Select Directory', ExtractFileDrive(FDir), FDir,
    [sdNewUI, sdNewFolder]) then
    if FDir <> '' then
    begin
      DirectoryEdit.Text := FDir;
      ListBox1.Items.Clear;
      ScanDir(Form1.DirectoryEdit.Text, '', Form1.ListBox1.Items);
    end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
var
  Res: Integer;
begin
  Res := MessageBox(Self.Handle, pChar('Really close the app?'), pChar('Exit'),
    MB_YESNO + MB_ICONINFORMATION);
  case Res of
    IDYES:
      begin
        Application.Terminate();
      end;
  end;
end;

end.
