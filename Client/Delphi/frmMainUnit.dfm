object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Dweetta Client v0.1.0.25'
  ClientHeight = 486
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object panTop: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object btnTest: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Test'
      TabOrder = 0
      OnClick = btnTestClick
    end
    object edtUsername: TEdit
      Left = 96
      Top = 10
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Username'
    end
    object edtPassword: TEdit
      Left = 232
      Top = 10
      Width = 121
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
      Text = 'Password'
    end
  end
  object panClient: TPanel
    Left = 0
    Top = 37
    Width = 635
    Height = 430
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 116
    ExplicitTop = 156
    ExplicitWidth = 185
    ExplicitHeight = 41
    object vstTweets: TVirtualStringTree
      Left = 0
      Top = 0
      Width = 635
      Height = 430
      Align = alClient
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.MainColumn = -1
      TabOrder = 0
      OnFreeNode = vstTweetsFreenode
      OnGetText = vstTweetsGetText
      OnGetNodeDataSize = vstTweetsGetNodeDataSize
      ExplicitLeft = 128
      ExplicitTop = 196
      ExplicitWidth = 200
      ExplicitHeight = 100
      Columns = <>
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 467
    Width = 635
    Height = 19
    Panels = <
      item
        Text = 'Ready'
        Width = 50
      end>
    ExplicitLeft = 1
    ExplicitTop = 405
    ExplicitWidth = 633
  end
end
