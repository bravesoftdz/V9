object FSimulRentab: TFSimulRentab
  Left = 113
  Top = 105
  Width = 800
  Height = 517
  Caption = 'Etude de rentabilit'#233
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PPIED: TPanel
    Left = 0
    Top = 413
    Width = 792
    Height = 39
    Align = alBottom
    TabOrder = 0
    object HLabel1: THLabel
      Left = 8
      Top = 12
      Width = 62
      Height = 16
      Caption = 'TOTAUX'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BAction: TToolbarButton97
      Left = 96
      Top = 16
      Width = 17
      Height = 17
      DisplayMode = dmGlyphOnly
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Layout = blGlyphTop
      Opaque = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      OnClick = BActionClick
    end
  end
  object DockBottom: TDock97
    Left = 0
    Top = 452
    Width = 792
    Height = 31
    BackgroundTransparent = True
    Position = dpBottom
    object Outils97: TToolbar97
      Left = 0
      Top = 0
      Caption = 'Actions'
      CloseButton = False
      DefaultDock = DockBottom
      DockPos = 0
      TabOrder = 0
      object BDetailVal: TToolbarButton97
        Tag = 1
        Left = 28
        Top = 0
        Width = 28
        Height = 27
        Hint = 'Valorisation d'#233'taill'#233'e'
        AllowAllUp = True
        GroupIndex = 1
        DisplayMode = dmGlyphOnly
        Caption = 'Arborescence Paragraphes'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Layout = blGlyphTop
        Opaque = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        OnClick = BDetailValClick
        GlobalIndexImage = 'M0004_S16G1'
        IsControl = True
      end
      object Barbo: TToolbarButton97
        Tag = 1
        Left = 0
        Top = 0
        Width = 28
        Height = 27
        Hint = 'structure de l'#39#233'tude'
        AllowAllUp = True
        GroupIndex = 1
        DisplayMode = dmGlyphOnly
        Caption = 'Arborescence Etude'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Layout = blGlyphTop
        Opaque = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        OnClick = BarboClick
        GlobalIndexImage = 'Z0189_S16G0'
        IsControl = True
      end
    end
    object Valide97: TToolbar97
      Left = 589
      Top = 0
      Caption = 'Validation'
      CloseButton = False
      DefaultDock = DockBottom
      DockableTo = [dpTop, dpBottom, dpRight]
      DockPos = 589
      TabOrder = 1
      object BValider: TToolbarButton97
        Left = 0
        Top = 0
        Width = 28
        Height = 27
        Hint = 'Enregistrer la pi'#232'ce'
        DisplayMode = dmGlyphOnly
        Caption = 'Enregistrer'
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
        GlyphMask.Data = {00000000}
        Layout = blGlyphTop
        NumGlyphs = 2
        Opaque = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        OnClick = BValiderClick
        IsControl = True
      end
      object BAbandon: TToolbarButton97
        Tag = 1
        Left = 28
        Top = 0
        Width = 28
        Height = 27
        Hint = 'Fermer'
        Cancel = True
        DisplayMode = dmGlyphOnly
        Caption = 'Annuler'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Opaque = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        OnClick = BAbandonClick
        GlobalIndexImage = 'Z0021_S16G1'
        IsControl = True
      end
      object BAide: TToolbarButton97
        Tag = 1
        Left = 56
        Top = 0
        Width = 28
        Height = 27
        Hint = 'Aide'
        HelpContext = 119000017
        DisplayMode = dmGlyphOnly
        Caption = 'Aide'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Layout = blGlyphTop
        Opaque = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        GlobalIndexImage = 'Z1117_S16G1'
        IsControl = True
      end
    end
  end
  object GS: THGrid
    Left = 0
    Top = 0
    Width = 792
    Height = 413
    Align = alClient
    ColCount = 13
    DefaultColWidth = 60
    DefaultRowHeight = 18
    RowCount = 100
    Options = [goFixedVertLine, goFixedHorzLine, goRangeSelect, goColSizing, goEditing, goTabs, goAlwaysShowEditor]
    TabOrder = 2
    OnMouseMove = GSMouseMove
    SortedCol = -1
    Couleur = False
    MultiSelect = False
    TitleBold = True
    TitleCenter = True
    OnRowEnter = GSRowEnter
    OnRowExit = GSRowExit
    OnCellEnter = GSCellEnter
    OnCellExit = GSCellExit
    ColCombo = 0
    SortEnabled = False
    SortRowExclude = 0
    TwoColors = False
    AlternateColor = clSilver
    ColWidths = (
      60
      21
      118
      67
      65
      87
      93
      87
      60
      60
      60
      60
      60)
  end
  object TTarborescence: TToolWindow97
    Left = 240
    Top = 48
    ClientHeight = 333
    ClientWidth = 249
    Caption = 'Arborescence de l'#39#233'tude'
    ClientAreaHeight = 333
    ClientAreaWidth = 249
    TabOrder = 4
    Visible = False
    OnClose = TTarborescenceClose
    object TV: THTreeView
      Left = 0
      Top = 0
      Width = 249
      Height = 333
      Align = alClient
      Color = clInfoBk
      Indent = 19
      TabOrder = 0
      OnClick = TVClick
    end
  end
  object TDetailVal: TToolWindow97
    Left = 88
    Top = 108
    ClientHeight = 213
    ClientWidth = 649
    Caption = 'D'#233'tail des valorisations'
    ClientAreaHeight = 213
    ClientAreaWidth = 649
    TabOrder = 3
    Visible = False
    OnClose = TDetailValClose
    object PHeures: TPanel
      Left = 0
      Top = 0
      Width = 649
      Height = 217
      Align = alTop
      TabOrder = 0
      object LHEURES: THLabel
        Left = 14
        Top = 11
        Width = 51
        Height = 13
        Caption = 'Nb Heures'
      end
      object HLabel2: THLabel
        Left = 14
        Top = 56
        Width = 70
        Height = 13
        Caption = 'Montant Achat'
      end
      object HLabel3: THLabel
        Left = 14
        Top = 104
        Width = 79
        Height = 13
        Caption = 'Montant Revient'
      end
      object HLabel4: THLabel
        Left = 14
        Top = 144
        Width = 70
        Height = 13
        Caption = 'Montant Vente'
      end
      object HLabel5: THLabel
        Left = 349
        Top = 57
        Width = 39
        Height = 13
        Caption = 'Coef FR'
      end
      object HLabel6: THLabel
        Left = 220
        Top = 104
        Width = 55
        Height = 13
        Caption = 'Coef Marge'
      end
      object HLabel7: THLabel
        Left = 409
        Top = 58
        Width = 83
        Height = 13
        Caption = 'Prix Achat Moyen'
      end
      object HLabel8: THLabel
        Left = 409
        Top = 100
        Width = 92
        Height = 13
        Caption = 'Prix Revient Moyen'
      end
      object HLabel9: THLabel
        Left = 409
        Top = 144
        Width = 82
        Height = 13
        Caption = 'Prix Vente moyen'
      end
      object ApplicPAH: TToolbarButton97
        Left = 614
        Top = 54
        Width = 19
        Height = 21
        Hint = 'Application '#224' tous le document'
        DisplayMode = dmGlyphOnly
        Opaque = False
        ParentShowHint = False
        ShowHint = True
        OnClick = ApplicPAHClick
        GlobalIndexImage = 'M0062_S16G1'
      end
      object ApplicPRH: TToolbarButton97
        Left = 614
        Top = 98
        Width = 19
        Height = 21
        Hint = 'Application '#224' tous le document'
        DisplayMode = dmGlyphOnly
        Opaque = False
        ParentShowHint = False
        ShowHint = True
        OnClick = ApplicPRHClick
        GlobalIndexImage = 'M0062_S16G1'
      end
      object ApplicPVH: TToolbarButton97
        Left = 614
        Top = 141
        Width = 19
        Height = 21
        Hint = 'Application '#224' tous le document'
        DisplayMode = dmGlyphOnly
        Opaque = False
        ParentShowHint = False
        ShowHint = True
        OnClick = ApplicPVHClick
        GlobalIndexImage = 'M0062_S16G1'
      end
      object TLIBMTTTC: THLabel
        Left = 14
        Top = 188
        Width = 100
        Height = 13
        Caption = 'Montant Vente (TTC)'
      end
      object TLIBPVMOYTTC: THLabel
        Left = 409
        Top = 188
        Width = 112
        Height = 13
        Caption = 'Prix Vente moyen (TTC)'
      end
      object ApplicPVTTC: TToolbarButton97
        Left = 614
        Top = 184
        Width = 19
        Height = 21
        Hint = 'Application '#224' tous le document'
        DisplayMode = dmGlyphOnly
        Opaque = False
        ParentShowHint = False
        ShowHint = True
        OnClick = ApplicPVTTCClick
        GlobalIndexImage = 'M0062_S16G1'
      end
      object HLabel10: THLabel
        Left = 292
        Top = 57
        Width = 38
        Height = 13
        Caption = 'Coef FC'
      end
      object HLabel11: THLabel
        Left = 230
        Top = 57
        Width = 39
        Height = 13
        Caption = 'Coef FG'
      end
      object QTE: THNumEdit
        Left = 121
        Top = 8
        Width = 85
        Height = 21
        Decimals = 2
        Digits = 12
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Masks.PositiveMask = '#,##0.000'
        Debit = False
        ParentFont = False
        TabOrder = 0
        UseRounding = True
        Validate = False
        OnEnter = QTEEnter
        OnExit = QTEChange
      end
      object MPA: THNumEdit
        Left = 121
        Top = 54
        Width = 85
        Height = 21
        Decimals = 2
        Digits = 12
        Masks.PositiveMask = '#,##0.00'
        Debit = False
        TabOrder = 1
        UseRounding = True
        Validate = False
        OnEnter = MPAEnter
        OnExit = MPAChange
      end
      object MPR: THNumEdit
        Left = 121
        Top = 98
        Width = 85
        Height = 21
        Decimals = 2
        Digits = 12
        Masks.PositiveMask = '#,##0.00'
        Debit = False
        TabOrder = 2
        UseRounding = True
        Validate = False
        OnEnter = MPREnter
        OnExit = MPRChange
      end
      object MPV: THNumEdit
        Left = 121
        Top = 141
        Width = 85
        Height = 21
        Decimals = 2
        Digits = 12
        Masks.PositiveMask = '#,##0.00'
        Debit = False
        TabOrder = 3
        UseRounding = True
        Validate = False
        OnEnter = MPVEnter
        OnExit = MPVChange
      end
      object COEFFR: THNumEdit
        Left = 343
        Top = 76
        Width = 52
        Height = 21
        Decimals = 2
        Digits = 12
        Masks.PositiveMask = '#,##0.0000'
        Debit = False
        TabOrder = 4
        UseRounding = True
        Validate = False
      end
      object COEFMARG: THNumEdit
        Left = 220
        Top = 120
        Width = 53
        Height = 21
        Decimals = 2
        Digits = 12
        Masks.PositiveMask = '#,##0.0000'
        Debit = False
        TabOrder = 5
        UseRounding = True
        Validate = False
        OnEnter = COEFMARGEnter
        OnExit = COEFMARGChange
      end
      object PVMOY: THNumEdit
        Left = 524
        Top = 141
        Width = 85
        Height = 21
        Decimals = 2
        Digits = 12
        Masks.PositiveMask = '#,##0.00'
        Debit = False
        TabOrder = 8
        UseRounding = True
        Validate = False
        OnEnter = PVMOYEnter
        OnExit = PVMOYChange
      end
      object PRMOY: THNumEdit
        Left = 524
        Top = 98
        Width = 85
        Height = 21
        Decimals = 2
        Digits = 12
        Masks.PositiveMask = '#,##0.00'
        Debit = False
        TabOrder = 7
        UseRounding = True
        Validate = False
        OnEnter = PRMOYEnter
        OnExit = PRMOYChange
      end
      object PAMOY: THNumEdit
        Left = 524
        Top = 54
        Width = 85
        Height = 21
        Decimals = 2
        Digits = 12
        Masks.PositiveMask = '#,##0.00'
        Debit = False
        TabOrder = 6
        UseRounding = True
        Validate = False
        OnEnter = PAMOYEnter
        OnExit = PAMOYChange
      end
      object MPVTTC: THNumEdit
        Left = 121
        Top = 184
        Width = 85
        Height = 21
        Decimals = 2
        Digits = 12
        Masks.PositiveMask = '#,##0.00'
        Debit = False
        TabOrder = 9
        UseRounding = True
        Validate = False
        OnEnter = MPVTTCEnter
        OnExit = MPVTTCExit
      end
      object PVMOYTTC: THNumEdit
        Left = 524
        Top = 184
        Width = 85
        Height = 21
        Decimals = 2
        Digits = 12
        Masks.PositiveMask = '#,##0.00'
        Debit = False
        TabOrder = 10
        UseRounding = True
        Validate = False
        OnEnter = PVMOYTTCEnter
        OnExit = PVMOYTTCExit
      end
      object COEFFC: THNumEdit
        Left = 283
        Top = 76
        Width = 52
        Height = 21
        Decimals = 2
        Digits = 12
        Masks.PositiveMask = '#,##0.0000'
        Debit = False
        TabOrder = 11
        UseRounding = True
        Validate = False
      end
      object COEFFG: THNumEdit
        Left = 223
        Top = 75
        Width = 52
        Height = 21
        Decimals = 2
        Digits = 12
        Masks.PositiveMask = '#,##0.0000'
        Debit = False
        TabOrder = 12
        UseRounding = True
        Validate = False
        OnEnter = COEFFGEnter
        OnExit = COEFFGChange
      end
    end
  end
  object IListeDeploie: THImageList
    GlobalIndexImages.Strings = (
      'Z0898_S16G1'
      'Z0898_S16G1')
    Left = 88
    Top = 336
  end
end
