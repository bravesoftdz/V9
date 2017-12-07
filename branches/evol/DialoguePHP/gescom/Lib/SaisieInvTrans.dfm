object FSaisieInvTrans: TFSaisieInvTrans
  Left = 230
  Top = 170
  Width = 648
  Height = 421
  Caption = 'Inventaire transmis'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PENTETE: THPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 61
    Align = alTop
    FullRepaint = False
    TabOrder = 0
    BackGroundEffect = bdFlat
    ColorShadow = clWindowText
    ColorStart = clBtnFace
    TextEffect = tenone
    object TGIN_EMPLACEMENT: THLabel
      Left = 8
      Top = 36
      Width = 64
      Height = 13
      Caption = '&Emplacement'
    end
    object TGIT_DEPOT: THLabel
      Left = 8
      Top = 9
      Width = 29
      Height = 13
      Caption = '&D�p�t'
      FocusControl = GIT_DEPOT
    end
    object TGIT_LIBELLE: THLabel
      Left = 324
      Top = 36
      Width = 31
      Height = 13
      Caption = '&Intitul�'
      FocusControl = GIT_LIBELLE
    end
    object TGIT_CODETRANS: THLabel
      Left = 324
      Top = 9
      Width = 74
      Height = 13
      Caption = '&Transmission n�'
      FocusControl = GIT_CODETRANS
    end
    object LConsult: TLabel
      Left = 513
      Top = 10
      Width = 109
      Height = 13
      Caption = 'Consultation seulement'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
      Visible = False
    end
    object GIT_DEPOT: THValComboBox
      Left = 80
      Top = 5
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = GIT_DEPOTChange
      TagDispatch = 0
      VideString = 'Tous'
      DataType = 'GCDEPOT'
    end
    object GIT_CODETRANS: TEdit
      Left = 404
      Top = 5
      Width = 84
      Height = 21
      TabOrder = 1
    end
    object GIT_LIBELLE: TEdit
      Left = 404
      Top = 32
      Width = 218
      Height = 21
      TabOrder = 3
    end
    object GIN_EMPLACEMENT: TEdit
      Left = 80
      Top = 32
      Width = 145
      Height = 21
      TabOrder = 2
      OnExit = GIN_EMPLACEMENTExit
    end
  end
  object PPIED: THPanel
    Left = 0
    Top = 316
    Width = 640
    Height = 42
    Align = alBottom
    FullRepaint = False
    TabOrder = 1
    BackGroundEffect = bdFlat
    ColorShadow = clWindowText
    ColorStart = clBtnFace
    TextEffect = tenone
    object TGA_GRILLEDIM4: THLabel
      Left = 7
      Top = 3
      Width = 3
      Height = 13
    end
    object TGA_GRILLEDIM5: THLabel
      Left = 126
      Top = 3
      Width = 3
      Height = 13
    end
    object LDTOTQTEINV: TLabel
      Left = 566
      Top = 8
      Width = 31
      Height = 13
      Caption = 'pi�ces'
    end
    object LGTOTQTEINV: TLabel
      Left = 464
      Top = 8
      Width = 30
      Height = 13
      Caption = 'Total :'
    end
    object GA_CODEDIM4: THCritMaskEdit
      Left = 7
      Top = 19
      Width = 113
      Height = 21
      ReadOnly = True
      TabOrder = 0
      Visible = False
      TagDispatch = 0
    end
    object GA_CODEDIM5: THCritMaskEdit
      Left = 126
      Top = 19
      Width = 113
      Height = 21
      ReadOnly = True
      TabOrder = 1
      Visible = False
      TagDispatch = 0
    end
    object TOTQTEINV: THNumEdit
      Left = 504
      Top = 4
      Width = 57
      Height = 21
      Ctl3D = True
      Decimals = 2
      Digits = 15
      Enabled = False
      Masks.PositiveMask = '#,##0'
      Debit = False
      NumericType = ntDecimal
      ParentCtl3D = False
      TabOrder = 2
      UseRounding = True
      Validate = False
    end
  end
  object G_InvTrans: THGrid
    Tag = 1
    Left = 0
    Top = 61
    Width = 640
    Height = 255
    Align = alClient
    DefaultRowHeight = 18
    RowCount = 12
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goEditing, goTabs, goThumbTracking]
    TabOrder = 3
    OnEnter = G_InvTransEnter
    OnKeyDown = G_InvTransKeyDown
    SortedCol = -1
    Couleur = False
    MultiSelect = False
    TitleBold = False
    TitleCenter = True
    OnRowEnter = G_InvTransRowEnter
    OnRowExit = G_InvTransRowExit
    OnCellEnter = G_InvTransCellEnter
    OnCellExit = G_InvTransCellExit
    ColCombo = 0
    SortEnabled = True
    SortRowExclude = 0
    TwoColors = True
    AlternateColor = 13224395
    OnElipsisClick = G_InvTransElipsisClick
    RowHeights = (
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      17
      18)
  end
  object Dock971: TDock97
    Left = 0
    Top = 358
    Width = 640
    Height = 36
    Position = dpBottom
    object ToolWindow971: TToolWindow97
      Left = 0
      Top = 0
      ClientHeight = 32
      ClientWidth = 627
      Caption = 'Outils inventaire'
      ClientAreaHeight = 32
      ClientAreaWidth = 627
      DockPos = 0
      FullSize = True
      TabOrder = 0
      object BChercher: TToolbarButton97
        Tag = 1
        Left = 2
        Top = 3
        Width = 28
        Height = 27
        Hint = 'Rechercher '
        DisplayMode = dmGlyphOnly
        Caption = 'Rechercher'
        Flat = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Glyph.Data = {
          42010000424D4201000000000000760000002800000011000000110000000100
          040000000000CC00000000000000000000001000000010000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          77777000000077777777777777777000000070000077777000007000000070B0
          00777770F0007000000070F000777770B0007000000070000000700000007000
          0000700B000000B0000070000000700F000700F0000070000000700B000700B0
          0000700000007700000000000007700000007770B00070B00077700000007770
          0000700000777000000077770007770007777000000077770B07770B07777000
          0000777700077700077770000000777777777777777770000000777777777777
          777770000000}
        Layout = blGlyphTop
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        OnClick = BChercherClick
        IsControl = True
      end
      object BValider: TToolbarButton97
        Left = 530
        Top = 3
        Width = 28
        Height = 27
        Hint = 'Valider'
        Anchors = [akTop, akRight]
        Default = True
        DisplayMode = dmGlyphOnly
        Caption = 'Enregistrer'
        Flat = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
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
        Layout = blGlyphTop
        ModalResult = 1
        NumGlyphs = 2
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        OnClick = BValiderClick
        IsControl = True
      end
      object BAbandon: TToolbarButton97
        Tag = 1
        Left = 562
        Top = 3
        Width = 28
        Height = 27
        Hint = 'Annuler'
        Anchors = [akTop, akRight]
        Cancel = True
        DisplayMode = dmGlyphOnly
        Caption = 'Fermer'
        Flat = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Glyph.Data = {
          CE070000424DCE07000000000000360000002800000024000000120000000100
          1800000000009807000000000000000000000000000000000000008080008080
          0080800080800080800080800080800080800080800080800080800080800080
          8000808000808000808000808000808000808000808000808000808000808000
          8080008080008080008080008080008080008080008080008080008080008080
          0080800080800080800080800080800080808080808080800080800080800080
          8000808000808000808000808000808000808000808000808000808000808000
          8080008080008080008080FFFFFF008080008080008080008080008080008080
          0080800080800080800080800080800080800080800080800080800000FF0000
          800000808080800080800080800080800080800080800000FF80808000808000
          8080008080008080008080008080008080008080808080808080FFFFFF008080
          008080008080008080008080008080FFFFFF0080800080800080800080800080
          800080800080800000FF00008000008000008080808000808000808000808000
          00FF000080000080808080008080008080008080008080008080008080808080
          FFFFFF008080808080FFFFFF008080008080008080FFFFFF808080808080FFFF
          FF0080800080800080800080800080800080800000FF00008000008000008000
          00808080800080800000FF000080000080000080000080808080008080008080
          008080008080008080808080FFFFFF008080008080808080FFFFFF008080FFFF
          FF808080008080008080808080FFFFFF00808000808000808000808000808000
          80800000FF000080000080000080000080808080000080000080000080000080
          000080808080008080008080008080008080008080808080FFFFFF0080800080
          80008080808080FFFFFF808080008080008080008080008080808080FFFFFF00
          80800080800080800080800080800080800000FF000080000080000080000080
          0000800000800000800000808080800080800080800080800080800080800080
          80008080808080FFFFFF00808000808000808080808000808000808000808000
          8080FFFFFF808080008080008080008080008080008080008080008080008080
          0000FF0000800000800000800000800000800000808080800080800080800080
          80008080008080008080008080008080008080808080FFFFFF00808000808000
          8080008080008080008080FFFFFF808080008080008080008080008080008080
          0080800080800080800080800080800000800000800000800000800000808080
          8000808000808000808000808000808000808000808000808000808000808000
          8080808080FFFFFF008080008080008080008080008080808080008080008080
          0080800080800080800080800080800080800080800080800080800000FF0000
          8000008000008000008080808000808000808000808000808000808000808000
          8080008080008080008080008080008080808080FFFFFF008080008080008080
          8080800080800080800080800080800080800080800080800080800080800080
          800080800000FF00008000008000008000008000008080808000808000808000
          8080008080008080008080008080008080008080008080008080008080808080
          008080008080008080008080808080FFFFFF0080800080800080800080800080
          800080800080800080800080800000FF00008000008000008080808000008000
          0080000080808080008080008080008080008080008080008080008080008080
          008080008080808080008080008080008080008080008080808080FFFFFF0080
          800080800080800080800080800080800080800080800000FF00008000008000
          00808080800080800000FF000080000080000080808080008080008080008080
          008080008080008080008080008080808080008080008080008080808080FFFF
          FF008080008080808080FFFFFF00808000808000808000808000808000808000
          80800000FF0000800000808080800080800080800080800000FF000080000080
          000080808080008080008080008080008080008080008080808080FFFFFF0080
          80008080808080008080808080FFFFFF008080008080808080FFFFFF00808000
          80800080800080800080800080800080800000FF000080008080008080008080
          0080800080800000FF0000800000800000800080800080800080800080800080
          80008080808080FFFFFFFFFFFF808080008080008080008080808080FFFFFF00
          8080008080808080FFFFFF008080008080008080008080008080008080008080
          0080800080800080800080800080800080800080800000FF0000800000FF0080
          8000808000808000808000808000808000808080808080808000808000808000
          8080008080008080808080FFFFFFFFFFFFFFFFFF808080008080008080008080
          0080800080800080800080800080800080800080800080800080800080800080
          8000808000808000808000808000808000808000808000808000808000808000
          8080008080008080008080008080008080008080008080808080808080808080
          0080800080800080800080800080800080800080800080800080800080800080
          8000808000808000808000808000808000808000808000808000808000808000
          8080008080008080008080008080008080008080008080008080008080008080
          008080008080008080008080008080008080}
        ModalResult = 2
        NumGlyphs = 2
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        OnClick = BAbandonClick
        IsControl = True
      end
      object BAide: TToolbarButton97
        Tag = 1
        Left = 594
        Top = 3
        Width = 28
        Height = 27
        Hint = 'Aide'
        Anchors = [akTop, akRight]
        DisplayMode = dmGlyphOnly
        Caption = 'Aide'
        Flat = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
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
        Layout = blGlyphTop
        NumGlyphs = 2
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        IsControl = True
      end
      object BAddLigne: TToolbarButton97
        Tag = 1
        Left = 175
        Top = 3
        Width = 28
        Height = 27
        Hint = 'Ajouter un article'
        DisplayMode = dmGlyphOnly
        Caption = 'Ajout'
        Flat = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Glyph.Data = {
          42010000424D4201000000000000760000002800000011000000110000000100
          040000000000CC00000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          88888000000088888888888888888000000080000008888888888000000080FF
          FF08888888888000000080FFFF08888888888000000080000008888888888000
          000080FFFF08888888888000000080FFFF0888888888800000008000000888C8
          888880000000888888888CC880000000000088888888CCCCC0EE000000008000
          00088CC880EE0000000080FFFF0888C880000000000080FFFF08888888888000
          0000800000088888888880000000888888888888888880000000888888888888
          888880000000}
        Layout = blGlyphTop
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        Visible = False
        IsControl = True
      end
      object BDelLigne: TToolbarButton97
        Tag = 1
        Left = 33
        Top = 3
        Width = 28
        Height = 27
        Hint = 'Supprimer l'#39'article'
        DisplayMode = dmGlyphOnly
        Caption = 'Suppression'
        Flat = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Glyph.Data = {
          42010000424D4201000000000000760000002800000011000000110000000100
          040000000000CC00000000000000000000001000000010000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          77777000000077777777777777777000000070000007777777777000000070FF
          FF07777777777000000070FFFF07777777777000000070000007777777777000
          000070FFFF07777777777000000070FFFF077777777770000000700000000007
          747770000000777770FEFE07744770000000777770EFEF044444700000007000
          0000000774477000000070FFFF07777774777000000070FFFF07777777777000
          0000700000077777777770000000777777777777777770000000777777777777
          777770000000}
        Layout = blGlyphTop
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        OnClick = BDelLigneClick
        IsControl = True
      end
      object BDelete: TToolbarButton97
        Left = 64
        Top = 3
        Width = 28
        Height = 27
        Hint = 'Remise � z�ro des quantit�s'
        DisplayMode = dmGlyphOnly
        Caption = 'Supprimer'
        Flat = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
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
        Layout = blGlyphTop
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = BDeleteClick
      end
      object BImprimer: TToolbarButton97
        Left = 96
        Top = 3
        Width = 28
        Height = 27
        Hint = 'Imprimer'
        DisplayMode = dmGlyphOnly
        Caption = 'Imprimer'
        Flat = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Glyph.Data = {
          4E010000424D4E01000000000000760000002800000012000000120000000100
          040000000000D800000000000000000000001000000010000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          DDDDDD000000DDD00000000000DDDD000000DD0777777777070DDD000000D000
          000000000070DD000000D0777777FFF77000DD000000D077777799977070DD00
          0000D0000000000000770D000000D0777777777707070D000000DD0000000000
          70700D000000DDD0FFFFFFFF07070D000000DDDD0FCCCCCF0000DD000000DDDD
          0FFFFFFFF0DDDD000000DDDDD0FCCCCCF0DDDD000000DDDDD0FFFFFFFF0DDD00
          0000DDDDDD000000000DDD000000DDDDDDDDDDDDDDDDDD000000DDDDDDDDDDDD
          DDDDDD000000DDDDDDDDDDDDDDDDDD000000}
        Layout = blGlyphTop
        Margin = 2
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = BImprimerClick
      end
      object PageScroller1: TPageScroller
        Left = 236
        Top = -4
        Width = 150
        Height = 45
        AutoScroll = False
        TabOrder = 0
        Visible = False
      end
    end
  end
  object FindLigne: TFindDialog
    OnFind = FindLigneFind
    Left = 20
    Top = 284
  end
end
