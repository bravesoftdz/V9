object fChoisir: TfChoisir
  Left = 213
  Top = 220
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'S'#233'lectionner dans la liste'
  ClientHeight = 324
  ClientWidth = 364
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlCorps: THPanel
    Left = 0
    Top = 0
    Width = 364
    Height = 283
    FullRepaint = False
    TabOrder = 0
    BackGroundEffect = bdFlat
    ColorShadow = clWindowText
    ColorStart = clBtnFace
    TextEffect = tenone
    object Grid: THGrid
      Left = 1
      Top = 3
      Width = 362
      Height = 279
      Align = alBottom
      ColCount = 3
      DefaultColWidth = 60
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 3
      Options = [goFixedHorzLine, goRangeSelect, goDrawFocusSelected, goRowSizing, goRowSelect]
      ScrollBars = ssVertical
      TabOrder = 0
      OnDblClick = GridDblClick
      OnKeyDown = GridKeyDown
      SortedCol = -1
      Couleur = False
      MultiSelect = False
      TitleBold = True
      TitleCenter = True
      ColCombo = 0
      SortEnabled = False
      SortRowExclude = 0
      TwoColors = False
      AlternateColor = 13224395
      ColWidths = (
        71
        60
        104)
    end
  end
  object pnlBottom: THPanel
    Left = 0
    Top = 283
    Width = 364
    Height = 41
    FullRepaint = False
    TabOrder = 1
    BackGroundEffect = bdFlat
    ColorShadow = clWindowText
    ColorStart = clBtnFace
    TextEffect = tenone
    object BOuvrir: TToolbarButton97
      Left = 300
      Top = 9
      Width = 28
      Height = 27
      Hint = 'Valider'
      DisplayMode = dmGlyphOnly
      Caption = 'Ouvrir'
      Flat = False
      Glyph.Data = {
        BE060000424DBE06000000000000360400002800000024000000120000000100
        0800000000008802000000000000000000000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        03030303030303030303030303030303030303030303FF030303030303030303
        03030303030303040403030303030303030303030303030303F8F8FF03030303
        03030303030303030303040202040303030303030303030303030303F80303F8
        FF030303030303030303030303040202020204030303030303030303030303F8
        03030303F8FF0303030303030303030304020202020202040303030303030303
        0303F8030303030303F8FF030303030303030304020202FA0202020204030303
        0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
        040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
        03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
        FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
        0303030303030303030303FA0202020403030303030303030303030303F8FF03
        03F8FF03030303030303030303030303FA020202040303030303030303030303
        0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
        03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
        030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
        0202040303030303030303030303030303F8FF03F8FF03030303030303030303
        03030303FA0202030303030303030303030303030303F8FFF803030303030303
        030303030303030303FA0303030303030303030303030303030303F803030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303}
      GlyphMask.Data = {00000000}
      Layout = blGlyphTop
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = BOuvrirClick
    end
    object BAnnuler: TToolbarButton97
      Left = 329
      Top = 9
      Width = 28
      Height = 27
      Hint = 'Fermer'
      Cancel = True
      DisplayMode = dmGlyphOnly
      Caption = 'Fermer'
      Flat = False
      Glyph.Data = {
        BE060000424DBE06000000000000360400002800000024000000120000000100
        0800000000008802000000000000000000000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303F8F80303030303030303030303030303030303FF03030303030303030303
        0303030303F90101F80303030303F9F80303030303030303F8F8FF0303030303
        03FF03030303030303F9010101F8030303F90101F8030303030303F8FF03F8FF
        030303FFF8F8FF030303030303F901010101F803F901010101F80303030303F8
        FF0303F8FF03FFF80303F8FF030303030303F901010101F80101010101F80303
        030303F8FF030303F8FFF803030303F8FF030303030303F90101010101010101
        F803030303030303F8FF030303F803030303FFF80303030303030303F9010101
        010101F8030303030303030303F8FF030303030303FFF8030303030303030303
        030101010101F80303030303030303030303F8FF0303030303F8030303030303
        0303030303F901010101F8030303030303030303030303F8FF030303F8030303
        0303030303030303F90101010101F8030303030303030303030303F803030303
        F8FF030303030303030303F9010101F8010101F803030303030303030303F803
        03030303F8FF0303030303030303F9010101F803F9010101F803030303030303
        03F8030303F8FF0303F8FF03030303030303F90101F8030303F9010101F80303
        03030303F8FF0303F803F8FF0303F8FF03030303030303F9010303030303F901
        0101030303030303F8FFFFF8030303F8FF0303F8FF0303030303030303030303
        030303F901F903030303030303F8F80303030303F8FFFFFFF803030303030303
        03030303030303030303030303030303030303030303030303F8F8F803030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303}
      GlyphMask.Data = {00000000}
      Layout = blGlyphTop
      ModalResult = 2
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = BAnnulerClick
    end
    object BAide: TToolbarButton97
      Left = 173
      Top = 9
      Width = 28
      Height = 27
      Hint = 'Aide'
      DisplayMode = dmGlyphOnly
      Caption = 'Aide'
      Flat = False
      Glyph.Data = {
        BE060000424DBE06000000000000360400002800000024000000120000000100
        0800000000008802000000000000000000000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
        A400000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        03030606030303030303030303030303030303FFFF0303030303030303030303
        0303030303060404060303030303030303030303030303F8F8FF030303030303
        030303030303030303FE06060403030303030303030303030303F8FF03F8FF03
        0303030303030303030303030303FE060603030303030303030303030303F8FF
        FFF8FF0303030303030303030303030303030303030303030303030303030303
        030303F8F8030303030303030303030303030303030304040603030303030303
        0303030303030303FFFF03030303030303030303030303030306060604030303
        0303030303030303030303F8F8F8FF0303030303030303030303030303FE0606
        0403030303030303030303030303F8FF03F8FF03030303030303030303030303
        03FE06060604030303030303030303030303F8FF03F8FF030303030303030303
        030303030303FE060606040303030303030303030303F8FF0303F8FF03030303
        0303030303030303030303FE060606040303030303030303030303F8FF0303F8
        FF030303030303030303030404030303FE060606040303030303030303FF0303
        F8FF0303F8FF030303030303030306060604030303FE06060403030303030303
        F8F8FF0303F8FF0303F8FF03030303030303FE06060604040406060604030303
        030303F8FF03F8FFFFFFF80303F8FF0303030303030303FE0606060606060606
        06030303030303F8FF0303F8F8F8030303F8FF030303030303030303FEFE0606
        060606060303030303030303F8FFFF030303030303F803030303030303030303
        0303FEFEFEFEFE03030303030303030303F8F8FFFFFFFFFFF803030303030303
        0303030303030303030303030303030303030303030303F8F8F8F8F803030303
        0303}
      GlyphMask.Data = {00000000}
      Layout = blGlyphTop
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      Visible = False
    end
    object LblInfo: TLabel
      Left = 7
      Top = 5
      Width = 225
      Height = 34
      AutoSize = False
      Caption = 'LblInfo'
      Transparent = True
      WordWrap = True
    end
    object BDelete: TBitBtn
      Left = 246
      Top = 9
      Width = 28
      Height = 27
      Hint = 'Supprimer'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Visible = False
      OnClick = BDeleteClick
      Glyph.Data = {
        66010000424D6601000000000000760000002800000014000000140000000100
        040000000000F000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888800008888888888888888889800008898888888888888898800008899
        88777777777798880000889990000000000998880000888990BFFFBFFF998888
        0000888899FCCCCCCF97888800008888999FBFFFB9978888000088888999CCC9
        990788880000888880999FB99F0788880000888880FC9999CF07888800008888
        80FF9999BF0788880000888880FC9999000788880000888880B99F099F078888
        0000888880999F099998888800008888999FBF0F089988880000889999000000
        8889988800008899988888888888898800008888888888888888889800008888
        88888888888888880000}
    end
  end
  object HMTrad: THSystemMenu
    MaxInsideSize = False
    ActiveResize = False
    ResizeDBGrid = True
    Caption = '&Personnalisation'
    Separator = True
    Traduction = True
    Left = 78
    Top = 121
  end
end
