object FsplashScreen: TFsplashScreen
  Left = 450
  Top = 239
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Message'
  ClientHeight = 163
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 393
    Height = 24
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'XXX'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 0
    Top = 136
    Width = 393
    Height = 27
    Align = alBottom
    Alignment = taCenter
    AutoSize = False
    Caption = 'Veuillez patienter...'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object TRestaure: TLabel
    Left = 8
    Top = 34
    Width = 119
    Height = 13
    Caption = 'Sauvegarde '#224' Restaurer '
    Visible = False
  end
  object Animate1: TAnimate
    Left = 59
    Top = 64
    Width = 272
    Height = 60
    CommonAVI = aviCopyFile
    StopFrame = 20
  end
  object ComboFile: TComboBox
    Left = 136
    Top = 32
    Width = 241
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'ComboFile'
    Visible = False
  end
end
