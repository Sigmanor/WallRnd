object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'About'
  ClientHeight = 173
  ClientWidth = 343
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000000040000000000000000000000000000000000000000
    00000000000000000000000000000000001E0000003100000033000000330000
    0033000000310000001E00000000000000000000000000000000FFFFFF000000
    0000000000000000000E000000339A5113AAAD5A14F9AD5912FFAD5912FFAD59
    12FFAD5A14F99A5113AA000000330000000E0000000000000000FFFFFF000000
    00000000000E733E106BAD5A13FFCA8948FFE0AD6EFFE6B77BFFE6B77AFFE6B7
    7BFFE0AD6EFFCA8948FFAD5A13FF733E106B0000000E00000000FFFFFF000000
    0000733E106BB16019FFDAA464FFE1B172FFDFAC6BFFDCA663FFDCA560FFDCA6
    63FFDFAC6CFFE1B172FFDAA464FFB16019FF733E106B00000000FFFFFF000000
    001EAE5B14FFD89F5EFFDFAC6BFFDDA866FFECD0B0FFFFFFFFFFFFFFFFFFFFFF
    FFFFDAA35EFFDDA866FFDFAC6BFFD89F5EFFAE5B14FF0000001EFFFFFF009B53
    14A9C5823EFFDCA766FFDAA362FFD9A15EFFD69C55FFECD0B0FFFFFFFFFFD495
    4BFFD79F5AFFD9A260FFDAA362FFDCA766FFC5823EFF9B5314A9FFFFFF00AE5B
    16F9D59C58FFD9A05CFFD79E5AFFD79D58FFD5984FFFECCFAFFFFFFFFFFFD394
    49FFD69C57FFD79E5AFFD79E5AFFD9A05CFFD59C58FFAE5B16F9FFFFFF00AF5B
    15FFD79F5AFFD49A55FFD49954FFD49852FFD19349FFEBCDACFFFFFFFFFFD08F
    43FFD39751FFD49954FFD49954FFD49A55FFD79F5AFFAF5B15FFFFFFFF00AE5B
    14FFDAA769FFD2954DFFD2954EFFD2944CFFCF8E42FFE9CAA8FFFFFFFFFFCE8B
    3DFFD1934BFFD2954EFFD2954EFFD2954DFFDAA769FFAE5B14FFFFFFFF00AE5A
    13FFDEAF78FFCE8E46FFCF9048FFCF8F47FFCC883DFFFFFFFFFFFFFFFFFFCB87
    3BFFCE8E47FFCF9049FFCF9048FFCE8E46FFDEAF78FFAE5A13FFFFFFFF00AD5A
    12F8E4BE96FFCC893DFFCD8A41FFCD8B41FFCB873BFFC77F2DFFC77D2BFFCA86
    38FFCD8B41FFCD8C43FFCD8A41FFCC893DFFE4BE96FFAD5A12F8FFFFFF00AF5C
    1495D5A67BFFD9A86FFFC88436FFC98639FFC78233FFE8CAA9FFFFFFFFFFC680
    2FFFC9863AFFC9863AFFC88436FFD9A86FFFD5A67BFFAF5C1495FFFFFF000000
    0000B15E19FFE8CBAEFFD7A269FFC57D2DFFC57B2AFFE7C8A7FFFFFFFFFFC379
    27FFC67E2FFFC67E2EFFD7A269FFE8CBAEFFB15E19FF00000000FFFFFF000000
    0000B05D1546B76C2CFFE4C3A0FFE1BB90FFCE924EFFC27825FFC0711BFFC37A
    2AFFCF9351FFE1BB90FFE4C3A0FFB76C2CFFB05D154600000000FFFFFF000000
    000000000000B05D1546B15E1AFFCC9360FFE2C09DFFEACFB0FFEACEB0FFEACF
    B1FFE2C09DFFCC9360FFB15E1AFFB05D15460000000000000000FFFFFF000000
    0000000000000000000000000000AF5C1495AE5911F7AD5810FFAD580FFFAD58
    10FFAE5911F7AF5C149500000000000000000000000000000000FFFFFF00F01F
    0000C00700008003000080030000000100000001000000010000000100000001
    00000001000000010000000100008003000080030000C0070000F01F0000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object AppVersionLabel: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 337
    Height = 24
    Align = alTop
    Caption = 'WallRnd 1.0.0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitLeft = 208
    ExplicitTop = 0
    ExplicitWidth = 135
  end
  object AppInfoMemo: TMemo
    Left = 0
    Top = 30
    Width = 343
    Height = 143
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    ReadOnly = True
    TabOrder = 0
  end
end
