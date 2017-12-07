object FplanningBTP: TFplanningBTP
  Left = 60
  Top = 138
  Width = 1139
  Height = 759
  Caption = 'Planning'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PCENTRE: TPanel
    Left = 0
    Top = 71
    Width = 1123
    Height = 543
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object PCENTER: TPanel
      Left = 0
      Top = 0
      Width = 1123
      Height = 543
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object G2: THGrid
        Left = 739
        Top = 0
        Width = 384
        Height = 537
        ColCount = 16
        DefaultColWidth = 35
        DefaultRowHeight = 18
        FixedCols = 0
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        ScrollBars = ssHorizontal
        TabOrder = 0
        SortedCol = -1
        Couleur = False
        MultiSelect = False
        TitleBold = True
        TitleCenter = True
        ColCombo = 0
        SortEnabled = False
        SortRowExclude = 0
        TwoColors = False
        AlternateColor = clSilver
      end
      object G1: THGrid
        Left = 0
        Top = 1
        Width = 448
        Height = 537
        DefaultRowHeight = 18
        FixedCols = 0
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        ScrollBars = ssVertical
        TabOrder = 1
        SortedCol = -1
        Couleur = False
        MultiSelect = False
        TitleBold = True
        TitleCenter = True
        ColCombo = 0
        SortEnabled = False
        SortRowExclude = 0
        TwoColors = False
        AlternateColor = clSilver
      end
    end
  end
  object PHAUT: TPanel
    Left = 0
    Top = 0
    Width = 1123
    Height = 71
    Align = alTop
    BevelOuter = bvNone
    Locked = True
    TabOrder = 1
    object TLIBAFFAIRE: THLabel
      Left = 22
      Top = 48
      Width = 30
      Height = 13
      Caption = 'Affaire'
    end
    object TLIBELLE: THLabel
      Left = 88
      Top = 48
      Width = 118
      Height = 13
      Caption = 'R'#233'f'#233'rence && D'#233'signation'
    end
    object TLIBHRSPREV: THLabel
      Left = 264
      Top = 38
      Width = 38
      Height = 26
      Alignment = taCenter
      Caption = 'Heures pr'#233'vues'
      WordWrap = True
    end
    object TLIBRESTEAPLANNIF: THLabel
      Left = 336
      Top = 38
      Width = 40
      Height = 26
      Alignment = taCenter
      Caption = 'Reste '#224' planifier'
      WordWrap = True
    end
    object GMois: THGrid
      Left = 585
      Top = 13
      Width = 320
      Height = 18
      BorderStyle = bsNone
      ColCount = 15
      DefaultRowHeight = 18
      DefaultDrawing = False
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      ScrollBars = ssNone
      TabOrder = 0
      SortedCol = -1
      Couleur = False
      MultiSelect = False
      TitleBold = True
      TitleCenter = True
      ColCombo = 0
      SortEnabled = False
      SortRowExclude = 0
      TwoColors = False
      AlternateColor = clSilver
    end
    object GSem: THGrid
      Left = 585
      Top = 32
      Width = 320
      Height = 18
      BorderStyle = bsNone
      ColCount = 15
      DefaultRowHeight = 18
      DefaultDrawing = False
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      ScrollBars = ssNone
      TabOrder = 1
      OnDrawCell = GSemDrawCell
      SortedCol = -1
      Couleur = False
      MultiSelect = False
      TitleBold = True
      TitleCenter = True
      ColCombo = 0
      SortEnabled = False
      SortRowExclude = 0
      TwoColors = False
      AlternateColor = clSilver
    end
    object GDate: THGrid
      Left = 585
      Top = 51
      Width = 320
      Height = 18
      BorderStyle = bsNone
      ColCount = 15
      DefaultRowHeight = 18
      DefaultDrawing = False
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      ScrollBars = ssNone
      TabOrder = 2
      SortedCol = -1
      Couleur = False
      MultiSelect = False
      TitleBold = True
      TitleCenter = True
      ColCombo = 0
      SortEnabled = False
      SortRowExclude = 0
      TwoColors = False
      AlternateColor = clSilver
    end
  end
  object PBAS: TPanel
    Left = 0
    Top = 614
    Width = 1123
    Height = 65
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object TLIBTOTALHRS: THLabel
      Left = 467
      Top = 8
      Width = 79
      Height = 13
      Caption = 'Total des heures'
    end
    object TLibEffectif: THLabel
      Left = 467
      Top = 24
      Width = 38
      Height = 13
      Caption = 'Effectifs'
    end
    object LNBRRESS: TLabel
      Left = 9
      Top = 8
      Width = 155
      Height = 13
      Caption = 'Nombre de personnes '#224' affecter '
    end
    object LNBHRS: TLabel
      Left = 9
      Top = 28
      Width = 128
      Height = 13
      Caption = 'Nombre d'#39'heures '#224' affecter'
    end
    object GTHeures: THGrid
      Left = 585
      Top = 1
      Width = 320
      Height = 18
      BorderStyle = bsNone
      ColCount = 15
      DefaultRowHeight = 18
      DefaultDrawing = False
      Enabled = False
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
      ScrollBars = ssNone
      TabOrder = 0
      SortedCol = -1
      Couleur = False
      MultiSelect = False
      TitleBold = True
      TitleCenter = True
      ColCombo = 0
      SortEnabled = False
      SortRowExclude = 0
      TwoColors = False
      AlternateColor = clSilver
    end
    object GTEffectifs: THGrid
      Left = 585
      Top = 20
      Width = 320
      Height = 18
      BorderStyle = bsNone
      ColCount = 15
      DefaultRowHeight = 18
      DefaultDrawing = False
      Enabled = False
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
      ScrollBars = ssNone
      TabOrder = 1
      SortedCol = -1
      Couleur = False
      MultiSelect = False
      TitleBold = True
      TitleCenter = True
      ColCombo = 0
      SortEnabled = False
      SortRowExclude = 0
      TwoColors = False
      AlternateColor = clSilver
    end
    object NBRRESS: THSpinEdit
      Left = 169
      Top = 4
      Width = 41
      Height = 22
      MaxValue = 99
      MinValue = 1
      TabOrder = 2
      Value = 1
      OnChange = NBRRESSChange
    end
    object NBHRS: THNumEdit
      Left = 168
      Top = 24
      Width = 85
      Height = 21
      TabOrder = 3
      OnExit = NBHRSExit
      Decimals = 2
      Digits = 12
      Masks.PositiveMask = '#,##0.00'
      Debit = False
      UseRounding = True
      Validate = False
    end
  end
  object PACTIONS: TPanel
    Left = 0
    Top = 679
    Width = 1123
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      1123
      41)
    object BValider: TToolbarButton97
      Left = 1061
      Top = 3
      Width = 28
      Height = 27
      Hint = 'Enregistrer la pi'#232'ce'
      Caption = 'Enregistrer'
      Anchors = [akTop, akRight]
      DisplayMode = dmGlyphOnly
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
      OnClick = BValiderClick
      GlobalIndexImage = 'M0012_S16G1'
      IsControl = True
    end
    object BAbandon: TToolbarButton97
      Tag = 1
      Left = 1089
      Top = 3
      Width = 28
      Height = 27
      Hint = 'Fermer'
      Caption = 'Annuler'
      Anchors = [akTop, akRight]
      Cancel = True
      DisplayMode = dmGlyphOnly
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ModalResult = 2
      Opaque = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      GlobalIndexImage = 'Z0021_S16G1'
      IsControl = True
    end
    object BRefresh: TToolbarButton97
      Left = 1034
      Top = 3
      Width = 27
      Height = 27
      Hint = 'Raffraichir les donn'#233'es'
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      OnClick = BRefreshClick
      GlobalIndexImage = 'M0063_S16G1'
    end
    object BOuvrirFermer: TToolbarButton97
      Left = 176
      Top = 8
      Width = 27
      Height = 27
      DisplayMode = dmGlyphOnly
      Images = ImgListPlusMoins
      Opaque = False
      OnClick = BOuvrirFermerClick
    end
    object BMODIF: TToolbarButton97
      Left = 1005
      Top = 3
      Width = 27
      Height = 27
      Hint = 'Modifier la plannification'
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      OnClick = BMODIFClick
      GlobalIndexImage = 'O0066_S24G1'
    end
    object BANNULE: TToolbarButton97
      Left = 1089
      Top = 3
      Width = 28
      Height = 27
      Anchors = [akLeft, akTop, akRight]
      Visible = False
      OnClick = BANNULEClick
      GlobalIndexImage = 'Z0021_S16G1'
    end
    object BPARAMS: TToolbarButton97
      Left = 16
      Top = 3
      Width = 27
      Height = 27
      Hint = 'Param'#232'tres'
      AllowAllUp = True
      GroupIndex = 1
      ParentShowHint = False
      ShowHint = True
      OnClick = BPARAMSClick
      GlobalIndexImage = 'O0008_S24G1'
    end
    object TBVIEWARBO: TToolbarButton97
      Left = 45
      Top = 3
      Width = 27
      Height = 27
      Hint = 'Param'#232'tres'
      AllowAllUp = True
      GroupIndex = 2
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = TBVIEWARBOClick
      GlobalIndexImage = 'Z0189_S16G0'
    end
  end
  object TTPARAMS: TToolWindow97
    Left = 448
    Top = 128
    ClientHeight = 106
    ClientWidth = 270
    Caption = 'Param'#232'tres'
    ClientAreaHeight = 106
    ClientAreaWidth = 270
    TabOrder = 4
    Visible = False
    OnClose = TTPARAMSClose
    object HLabel1: THLabel
      Left = 28
      Top = 24
      Width = 56
      Height = 13
      Caption = 'Date d'#233'part'
    end
    object HLabel2: THLabel
      Left = 28
      Top = 46
      Width = 40
      Height = 13
      Caption = 'Date Fin'
    end
    object BREFRESHP: TToolbarButton97
      Left = 213
      Top = 27
      Width = 27
      Height = 27
      Hint = 'Appliquer les dates'
      ParentShowHint = False
      ShowHint = True
      OnClick = BREFRESHPClick
      GlobalIndexImage = 'M0063_S16G1'
    end
    object DateD: THCritMaskEdit
      Left = 91
      Top = 21
      Width = 110
      Height = 21
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 0
      Text = '  /  /    '
      TagDispatch = 0
      OpeType = otDate
      ElipsisButton = True
      ControlerDate = True
    end
    object DateD_: THCritMaskEdit
      Left = 91
      Top = 43
      Width = 110
      Height = 21
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 1
      Text = '  /  /    '
      TagDispatch = 0
      OpeType = otDate
      ElipsisButton = True
      ControlerDate = True
    end
    object CAffHeures: TCheckBox
      Left = 28
      Top = 69
      Width = 173
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Affichage des heures'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = CAffHeuresClick
    end
  end
  object TTARBO: TToolWindow97
    Left = 56
    Top = 112
    ClientHeight = 418
    ClientWidth = 305
    Caption = 'Arborescence'
    ClientAreaHeight = 418
    ClientAreaWidth = 305
    TabOrder = 5
    Visible = False
    OnClose = TTARBOClose
    object TTVARBO: TTreeView
      Left = 0
      Top = 0
      Width = 305
      Height = 418
      Align = alClient
      Indent = 19
      RowSelect = True
      TabOrder = 0
      OnClick = TTVARBOClick
    end
  end
  object ImgListPlusMoins: THImageList
    GlobalIndexImages.Strings = (
      'Z1160_S16G1'
      'Z1135_S16G1')
    Height = 18
    Width = 18
    Left = 688
    Top = 152
  end
  object POPACTIONS: TPopupMenu
    Left = 536
    Top = 103
    object PlannifCh: TMenuItem
      Caption = 'Planifier le chantier'
      OnClick = PlannifChClick
    end
  end
end
