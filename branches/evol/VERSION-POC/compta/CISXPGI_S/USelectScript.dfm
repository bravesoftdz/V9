�
 TFSELSCRIPT 0�  TPF0TFSelScript
FSelScriptLeft�Top� Width6HeightYActiveControlPanel1Caption   Sélectionnez un scriptColor	clBtnFace
ParentFont	OldCreateOrder	PositionpoScreenCenterOnShowFormShowPixelsPerInch`
TextHeight TPanelPanel1Left Top Width.Height!AlignalTop
BevelOuterbvNoneTabOrder  TEditScriptSelectLeft� TopWidthyHeightTabOrder Visible  TPanelPanel3Left Top Width.Height)AlignalTopTabOrder TLabelTDOMAINELeft'Top
Width*HeightCaptionDomaine  THValComboBoxDomaineLefteTopWidthzHeightStylecsDropDownList
ItemHeightTabOrder TagDispatch 
ComboWidth,    TPanelPanel2Left Top!Width.HeightAlignalClient
BevelOuterbvNoneCaptionPanel2TabOrder TDBGridDBGrid1Left Top Width.HeightAlignalClientBiDiModebdLeftToRight
DataSourceSQOptionsdgTitlesdgIndicatordgColumnResize
dgColLines
dgRowLinesdgTabsdgRowSelectdgConfirmDeletedgCancelOnExit ParentBiDiModeTabOrder TitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style 
OnDblClickDBGrid1DblClick   TDataSourceSQDataSetQLeftZTop�   THQueryQAutoCalcFieldsLockType
ltReadOnlyMarshalOptionsmoMarshalModifiedOnly	EnableBCD
Parameters SQL.Strings=SELECT DOMAINE,CLE,COMMENT,CLEPAR,MODIFIABLE from GZIMPREQ.DB dataBaseNameGLOBALMAJAutoDistinctLeftTop�  TStringFieldQCLEDisplayLabelNom	FieldNameCLESize  TStringFieldQCOMMENTDisplayLabel   Libellé	FieldNameCOMMENTSize<  TStringFieldQDOMAINEDisplayLabelDomaine	FieldNameDOMAINESize    