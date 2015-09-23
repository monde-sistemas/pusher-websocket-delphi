object PusherClientExampleForm: TPusherClientExampleForm
  Left = 0
  Top = 0
  Caption = 'PusherClient Delphi Example'
  ClientHeight = 448
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    640
    448)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 275
    Height = 145
    Align = alCustom
    Caption = 'Connection'
    TabOrder = 0
    object LblStatus: TLabel
      Left = 181
      Top = 124
      Width = 76
      Height = 13
      Alignment = taRightJustify
      Caption = 'Disconnected'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object EdtKey: TLabeledEdit
      Left = 24
      Top = 29
      Width = 233
      Height = 21
      EditLabel.Width = 54
      EditLabel.Height = 13
      EditLabel.Caption = 'Pusher Key'
      TabOrder = 0
      Text = 'monde'
    end
    object EdtHost: TLabeledEdit
      Left = 24
      Top = 68
      Width = 233
      Height = 21
      EditLabel.Width = 73
      EditLabel.Height = 13
      EditLabel.Caption = 'Host (Optional)'
      TabOrder = 1
      Text = 'pusher.monde.com.br'
    end
    object ChkUseSSL: TCheckBox
      Left = 24
      Top = 99
      Width = 59
      Height = 17
      Caption = 'UseSSL'
      TabOrder = 2
    end
    object BtnConnect: TButton
      Left = 181
      Top = 95
      Width = 76
      Height = 25
      Caption = 'Connect'
      TabOrder = 3
      OnClick = BtnConnectClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 281
    Top = 0
    Width = 352
    Height = 145
    Align = alCustom
    Caption = 'Subscription'
    TabOrder = 1
    object EdtChannel: TLabeledEdit
      Left = 18
      Top = 29
      Width = 161
      Height = 21
      EditLabel.Width = 39
      EditLabel.Height = 13
      EditLabel.Caption = 'Channel'
      TabOrder = 0
    end
    object EdtEvent: TLabeledEdit
      Left = 18
      Top = 68
      Width = 161
      Height = 21
      EditLabel.Width = 58
      EditLabel.Height = 13
      EditLabel.Caption = 'Event Name'
      TabOrder = 1
    end
    object BtnSubscribe: TButton
      Left = 18
      Top = 95
      Width = 75
      Height = 25
      Caption = 'Subscribe'
      TabOrder = 2
      OnClick = BtnSubscribeClick
    end
    object SubscribeList: TListBox
      AlignWithMargins = True
      Left = 202
      Top = 18
      Width = 145
      Height = 122
      Align = alRight
      ItemHeight = 13
      TabOrder = 3
    end
  end
  object GroupBox3: TGroupBox
    Left = 2
    Top = 145
    Width = 630
    Height = 120
    Caption = 'OnError'
    TabOrder = 2
    object MemoError: TMemo
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 620
      Height = 97
      Align = alClient
      Lines.Strings = (
        '')
      TabOrder = 0
      ExplicitLeft = 7
    end
  end
  object GroupBox4: TGroupBox
    Left = 2
    Top = 266
    Width = 630
    Height = 174
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'OnLog'
    TabOrder = 3
    object MemoLog: TMemo
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 620
      Height = 151
      Align = alClient
      Lines.Strings = (
        '')
      TabOrder = 0
    end
  end
end
