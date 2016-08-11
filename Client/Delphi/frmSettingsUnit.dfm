object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 63
  ClientWidth = 316
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblUsername: TLabel
    Left = 8
    Top = 8
    Width = 48
    Height = 13
    Caption = '&Username'
    FocusControl = edtUsername
  end
  object lblPassword: TLabel
    Left = 8
    Top = 36
    Width = 46
    Height = 13
    Caption = '&Password'
    FocusControl = edtPassword
  end
  object edtUsername: TEdit
    Left = 62
    Top = 5
    Width = 163
    Height = 21
    TabOrder = 0
  end
  object edtPassword: TEdit
    Left = 62
    Top = 33
    Width = 163
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 236
    Top = 3
    Width = 75
    Height = 25
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 236
    Top = 31
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'C&ancel'
    ModalResult = 2
    TabOrder = 3
  end
end
