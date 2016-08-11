object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Dweetta Client v0.1.0.63'
  ClientHeight = 584
  ClientWidth = 736
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
  object Splitter1: TSplitter
    Left = 0
    Top = 421
    Width = 736
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 37
    ExplicitWidth = 343
  end
  object panTop: TPanel
    Left = 0
    Top = 0
    Width = 736
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      736
      65)
    object btnSend: TButton
      Left = 656
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akLeft, akRight]
      Caption = '&Send'
      TabOrder = 1
      OnClick = btnSendClick
    end
    object btnSettings: TButton
      Left = 656
      Top = 35
      Width = 75
      Height = 25
      Anchors = [akLeft, akRight]
      Caption = 'S&ettings'
      TabOrder = 2
      OnClick = btnSettingsClick
    end
    object edtStatus: TEdit
      Left = 8
      Top = 6
      Width = 642
      Height = 53
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      TabOrder = 0
    end
  end
  object panClient: TPanel
    Left = 0
    Top = 65
    Width = 736
    Height = 356
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object vstTweets: TVirtualStringTree
      Left = 0
      Top = 0
      Width = 736
      Height = 356
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
      Columns = <>
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 565
    Width = 736
    Height = 19
    Panels = <
      item
        Text = 'Ready'
        Width = 50
      end>
  end
  object panLog: TPanel
    Left = 0
    Top = 424
    Width = 736
    Height = 141
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object memLog: TMemo
      Left = 0
      Top = 0
      Width = 736
      Height = 141
      Align = alClient
      TabOrder = 0
    end
  end
  object tmrMain: TTimer
    Enabled = False
    OnTimer = tmrMainTimer
    Left = 688
    Top = 448
  end
end
