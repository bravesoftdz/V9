inherited FStockAjustMODE: TFStockAjustMODE
  Top = 214
  Caption = 'Assistant de r�ajustement des stocks'
  PixelsPerInch = 96
  TextHeight = 13
  inherited bFin: TToolbarButton97
    Enabled = False
  end
  inherited P: TPageControl
    ActivePage = TabSheet1
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object TWarning: THLabel
        Left = 7
        Top = 59
        Width = 318
        Height = 26
        AutoSize = False
        Caption = 'Attention ce traitement peut �tre long'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object HLabel2: THLabel
        Left = 8
        Top = 84
        Width = 317
        Height = 47
        AutoSize = False
        Caption = 
          'Le traitement va v�rifier les quantit�s de stock et les prix de ' +
          'revalorisation en scrutant les mouvements effectu�s depuis le de' +
          'rnier traitement de fin de p�riode.'
        WordWrap = True
      end
      object PTITRE: THPanel
        Left = 0
        Top = 0
        Width = 338
        Height = 41
        Align = alTop
        Caption = 'R�ajustement des stocks'
        FullRepaint = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clActiveCaption
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        BackGroundEffect = bdFlat
        ColorShadow = clWindowText
        ColorStart = clBtnFace
        TextEffect = tenone
      end
      object GBParam: TGroupBox
        Left = 0
        Top = 147
        Width = 338
        Height = 89
        Caption = 'Param�trage'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clActiveCaption
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object TDepot: THLabel
          Left = 29
          Top = 31
          Width = 29
          Height = 13
          Caption = 'D�p�t'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object Depot: THValComboBox
          Left = 67
          Top = 27
          Width = 142
          Height = 21
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 0
          TagDispatch = 0
          Vide = True
          DataType = 'GCDEPOT'
        end
        object GestionNomen: TCheckBox
          Left = 68
          Top = 60
          Width = 153
          Height = 17
          Caption = 'Gestion des nomenclatures'
          TabOrder = 1
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object HLabel1: THLabel
        Left = 11
        Top = 60
        Width = 312
        Height = 45
        AutoSize = False
        WordWrap = True
      end
      object TRecap: THLabel
        Left = 5
        Top = 126
        Width = 59
        Height = 13
        Caption = 'R�capitulatif'
      end
      object PanelFin: TPanel
        Left = 5
        Top = 4
        Width = 329
        Height = 97
        TabOrder = 0
        object TTextFin1: THLabel
          Left = 23
          Top = 8
          Width = 279
          Height = 26
          Caption = 
            'Le param�trage est correctement renseign� pour permettre le lanc' +
            'ement de la v�rification des stocks.'
          WordWrap = True
        end
        object TTextFin2: THLabel
          Left = 23
          Top = 49
          Width = 285
          Height = 39
          Caption = 
            'Si vous d�sirez revoir le param�trage, il suffit de cliquer sur ' +
            'le bouton Pr�c�dent sinon, le bouton Fin, permet de d�buter le t' +
            'raitement.'
          WordWrap = True
        end
      end
      object LBX_Param: TListBox
        Left = 5
        Top = 144
        Width = 329
        Height = 73
        Color = clBtnFace
        ItemHeight = 13
        TabOrder = 1
      end
    end
  end
  inherited Msg: THMsgBox
    Mess.Strings = (
      'Etape'
      
        '1;?caption?;Voulez-vous quitter l'#39'assistant et annuler l'#39'op�rati' +
        'on?;Q;YN;Y;C;'
      
        '2;?caption?;Probl�mes rencontr�s : l'#39'op�ration a �t� annul�e;W;O' +
        ';O;O;'
      '3;?caption?;Aucun r�ajustement n'#39'est n�cessaire;W;O;O;O;'
      '')
    Left = 75
    Top = 8
  end
end
