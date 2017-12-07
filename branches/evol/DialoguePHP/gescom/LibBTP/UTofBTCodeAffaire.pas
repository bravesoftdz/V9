unit UTofBTCodeAffaire;

interface
uses  StdCtrls,Controls,Classes,forms,sysutils,ComCtrls,
{$IFDEF EAGLCLIENT}
    MaineAGL,emul,
{$ELSE}
    {$IFNDEF ERADIO}
    Fe_Main,
    {$ENDIF !ERADIO}
    {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
    HDB,
    Mul,
    UtilGc,
{$ENDIF}
		M3Fp,
    HCtrls,
    HEnt1,
    HMsgBox,
    UTOF,
    AffaireUtil,
    Dicobtp,
    SaisUtil,
    EntGC,
    utofAfBaseCodeAffaire,
    HTB97,
    ParamSoc,
    Hpanel,
    UtilPGI,
    Facture,
    AGLInitBTP,
    UTOB,
    menus,
    AglInit,
    UentCommun,
    UdefExport,
    Ent1;
//Ajout FV

Type
     TOF_BTCODEAFFAIRE = Class (TOF_AFBASECODEAFFAIRE)
     private

        isMemoire : boolean;
        GS : THGRID;

        CodeEtat : String;
        Bouvrir : TToolbarButton97;
        BInsert : TToolBarButton97;

{$IFDEF EAGLCLIENT}
        Fliste	: THGrid;
{$ELSE}
        Fliste	: THDbGrid;
{$ENDIF}
        Consultation : Boolean;
        ModifDateSit : boolean;
        procedure RenommageEnteteColonnes(TypePiece : string);
        procedure ControleChamp(Champ, Valeur: String);
        //
{$IFDEF LINE}
		    procedure GestionMulDevis_S1(StArg: String);
        procedure GestionLine;
		    procedure FlisteDblClickLine(Sender: TObject);
{$ELSE}
		    procedure FlisteDblClick(Sender: TObject);

{$ENDIF}
		    procedure FlisteRowEnter(Sender: TObject);
        procedure ExportExcelClick (Sender : TObject);
				procedure ExportXMLClick (Sender : Tobject);
        procedure ExportDocMandateClick (Sender : Tobject);
				procedure MnExpCotraitXml (Sender : Tobject);
        Procedure BInsertClick(Sender : TObject);
        procedure GestionMulDevisSuitePlace(StArg: String);
        procedure GestionSuitePlace;
				procedure ModificationDateSituation (TheChaine : string);
     public
        procedure OnArgument(stArgument : String ) ; override ;
        procedure NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_:THEdit);override ;
        procedure Onload ;override;
        procedure OnUpdate ;override;
     END ;
implementation

uses Grids,USpecifLSE,UfactExportXLS,UcoTraitance;

procedure TOF_BTCODEAFFAIRE.OnArgument(stArgument : String );
var Bacomptes : TToolbarButton97;
    critere,valmul,champmul : string;
    x : integer;
    F : TFMul ;
    i : integer;
    CC : THValCOmboBox;
    TT : TToolbarButton97;
    TL : THlabel;
    TP : TTabSheet;
    TE : THEdit;
Begin
fMulDeTraitement  := true;
Inherited;
fTableName            := 'PIECE';

IsMemoire := false;
ModifDateSit := false;
Repeat
    Critere:=uppercase(ReadTokenSt(stArgument)) ;
    valMul := '';
    if Critere<>'' then
        begin
        x:=pos('=',Critere);
        if x<>0 then
           begin
           ChampMul:=copy(Critere,1,x-1);
           ValMul:=copy(Critere,x+1,length(Critere));
           end
        else
           ChampMul := Critere;
        ControleChamp(ChampMul, ValMul);
        end;
until  Critere='';

UpdateCaption(Ecran);

	 if TToolbarButton97 (GetControl('BACOMPTES')) <> nil then
   	  Begin
	    BAcomptes :=TToolbarButton97 (GetControl('BACOMPTES'));
   	  if GetParamSoc ('SO_ACOMPTEOBLIG') then
         Bacomptes.down := true
	    else
         Bacomptes.down := false;
	    end;


   if TToolbarButton97 (GetControl('BInsert')) <> nil then
      Begin
      BInsert := TToolbarButton97 (GetControl('BINSERT'));
      BInsert.OnClick := BInsertClick;
      end;

	// gestion des etablissements
	CC:=THValComboBox(GetControl('GP_ETABLISSEMENT')) ; if CC<>Nil then PositionneEtabUser(CC) ;

  SetControlProperty('BSELECTCON', 'Visible', VH_GC.BTSeriaContrat);
  SetControlProperty('TGPAFFAIRE1', 'Visible', VH_GC.BTSeriaContrat);
  SetControlProperty('AFF_CONTRAT1', 'Visible', VH_GC.BTSeriaContrat);
  SetControlProperty('AFF_CONTRAT2', 'Visible', VH_GC.BTSeriaContrat);
  SetControlProperty('AFF_CONTRAT3', 'Visible', VH_GC.BTSeriaContrat);
  SetControlProperty('CON_AVENANT', 'Visible', VH_GC.BTSeriaContrat);
  SetControlProperty('BEFFACECON', 'Visible', VH_GC.BTSeriaContrat);


{$IFDEF LINE}
	GestionLine;
{$ELSE}
	GestionSuitePlace;
{$ENDIF}
//
End;

{$IFNDEF LINE}
function IsDevisIntModifiable (cledoc : R_CLEDOC) : boolean;
var QQ : TQuery;
		Sql : string;
begin
	result := false;
	SQl := 'SELECT AFF_ETATAFFAIRE FROM AFFAIRE WHERE '+
  			 'AFF_AFFAIRE=(SELECT GP_AFFAIRE FROM PIECE WHERE '+
         'GP_NATUREPIECEG="'+Cledoc.NaturePiece +'" AND GP_SOUCHE="'+Cledoc.Souche +'" AND '+
         'GP_NUMERO='+IntToStr(Cledoc.NumeroPiece )+' AND GP_INDICEG='+IntToStr(Cledoc.Indice)+')';
  QQ := OpenSql (Sql,true,1,'',true);
  TRY
    if not QQ.eof then
    begin
      if Pos(QQ.FindField('AFF_ETATAFFAIRE').AsString,'ACD;ECO')> 0 then
      begin
        result := true;
      end;
    end;
  FINALLY
  	Ferme (QQ);
  END;
end;
{$ENDIF}

procedure TOF_BTCODEAFFAIRE.FlisteRowEnter(Sender: TObject);
var mandataire : string;
begin
  if pos('BTDEVIS_MUL',ecran.name) > 0 then
  begin
		TToolbarButton97 (getControl('BEXPORTS')).visible := true;
    if TmenuItem(getControl('MnSepCot')) <> nil then
    begin
      TmenuItem(getControl('MnSepCot')).visible := false;
    end;
    if TmenuItem(getControl('MnExportMandate')) <> nil then
    begin
      TmenuItem(getControl('MnExportMandate')).visible := false;
    end;
    if TmenuItem(getControl('MnExpCotraitXml')) <> nil then
    begin
      TmenuItem(getControl('MnExpCotraitXml')).visible := false;
    end;
{$IFDEF EAGLCLIENT}
    TFMul(ecran).Q.TQ.Seek(TFMul(ecran).FListe.Row-1) ;
    mandataire := TFMul(ecran).Q.FindField('AFF_MANDATAIRE').AsString;
{$ELSE}
		mandataire := '';
		if Fliste.DataSource.DataSet.FindField('AFF_MANDATAIRE') <> nil then
    begin
    	mandataire := Fliste.datasource.dataset.FindField('AFF_MANDATAIRE').AsString;
    end;
{$ENDIF}
	  if Mandataire = 'X' then
    begin
    	if TmenuItem(getControl('MnSepCot')) <> nil then
      begin
    		TmenuItem(getControl('MnSepCot')).visible := true;
      end;
    	if TmenuItem(getControl('MnExportMandate')) <> nil then
      begin
    		TmenuItem(getControl('MnExportMandate')).visible := true;
      end;
      if TmenuItem(getControl('MnExpCotraitXml')) <> nil then
      begin
        TmenuItem(getControl('MnExpCotraitXml')).visible := true;
      end;
    end;
  end;
end;

procedure TOF_BTCODEAFFAIRE.ExportExcelClick (Sender : TObject);
var cledoc : r_cledoc;
		ExportXls : TexportDocXls;
begin
  if pos('BTDEVIS_MUL',ecran.name) > 0 then
  begin
{$IFDEF EAGLCLIENT}
    TFMul(ecran).Q.TQ.Seek(TFMul(ecran).FListe.Row-1) ;
    Cledoc.naturePiece := TFMul(ecran).Q.FindField('GP_NATUREPIECEG').AsString;
    Cledoc.souche := TFMul(ecran).Q.FindField('GP_SOUCHE').AsString;
    Cledoc.numeroPiece := StrToInt(TFMul(ecran).Q.FindField('GP_NUMERO').AsString);
    Cledoc.indice := StrToInt(TFMul(ecran).Q.FindField('GP_INDICEG').AsString);
{$ELSE}
    Cledoc.naturePiece := Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').AsString;
    Cledoc.souche := Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
    Cledoc.numeroPiece := StrToInt(Fliste.datasource.dataset.FindField('GP_NUMERO').AsString);
    Cledoc.indice := StrToInt(Fliste.datasource.dataset.FindField('GP_INDICEG').AsString);
{$ENDIF}
    ExportXls := TexportDocXls.create;
    ExportXls.ModeExport  := TmeExcel;
    ExportXls.TypeExport := TteDevis;
    ExportXls.CleDoc := cledoc;
    ExportXls.ModeAction := XmaDocument;
    ExportXls.Genere;
    ExportXls.free;
  end;
end;

procedure TOF_BTCODEAFFAIRE.ExportXmlClick (Sender : Tobject);
var cledoc : r_cledoc;
		ExportXls : TexportDocXls;
begin
  if pos('BTDEVIS_MUL',ecran.name) > 0 then
  begin
{$IFDEF EAGLCLIENT}
    TFMul(ecran).Q.TQ.Seek(TFMul(ecran).FListe.Row-1) ;
    Cledoc.naturePiece := TFMul(ecran).Q.FindField('GP_NATUREPIECEG').AsString;
    Cledoc.souche := TFMul(ecran).Q.FindField('GP_SOUCHE').AsString;
    Cledoc.numeroPiece := StrToInt(TFMul(ecran).Q.FindField('GP_NUMERO').AsString);
    Cledoc.indice := StrToInt(TFMul(ecran).Q.FindField('GP_INDICEG').AsString);
{$ELSE}
    Cledoc.naturePiece := Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').AsString;
    Cledoc.souche := Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
    Cledoc.numeroPiece := StrToInt(Fliste.datasource.dataset.FindField('GP_NUMERO').AsString);
    Cledoc.indice := StrToInt(Fliste.datasource.dataset.FindField('GP_INDICEG').AsString);
{$ENDIF}
    ExportXls := TexportDocXls.create;
    ExportXls.ModeExport  := TmeXml;
    ExportXls.TypeExport := TteDevis;
    ExportXls.CleDoc := cledoc;
    ExportXls.ModeAction := XmaDocument;
    ExportXls.Genere;
    ExportXls.free;
  end;
end;


procedure TOF_BTCODEAFFAIRE.ExportDocMandateClick (Sender : Tobject);
var cledoc      : r_cledoc;
    faffaire    : string;
		ExportXls   : TexportDocXls;
    fournisseur : string;
begin
  if pos('BTDEVIS_MUL',ecran.name) > 0 then
  begin
{$IFDEF EAGLCLIENT}
    TFMul(ecran).Q.TQ.Seek(TFMul(ecran).FListe.Row-1) ;
    Cledoc.naturePiece := TFMul(ecran).Q.FindField('GP_NATUREPIECEG').AsString;
    Cledoc.souche := TFMul(ecran).Q.FindField('GP_SOUCHE').AsString;
    Cledoc.numeroPiece := StrToInt(TFMul(ecran).Q.FindField('GP_NUMERO').AsString);
    Cledoc.indice := StrToInt(TFMul(ecran).Q.FindField('GP_INDICEG').AsString);
{$ELSE}
    Cledoc.naturePiece := Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').AsString;
    Cledoc.souche := Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
    Cledoc.numeroPiece := StrToInt(Fliste.datasource.dataset.FindField('GP_NUMERO').AsString);
    Cledoc.indice := StrToInt(Fliste.datasource.dataset.FindField('GP_INDICEG').AsString);
{$ENDIF}
  	fournisseur := AGLLanceFiche('BTP','BTMULAFFECTEXTE','','','COTRAITANCE;DOCUMENT='+EncodeCleDoc(cledoc)+';SELECTION');
    if fournisseur <> '' then
    begin
      ExportXls := TexportDocXls.create;
    	ExportXls.ModeExport  := TmeExcel;
      ExportXls.TypeExport := TteCotrait;
      ExportXls.CleDoc := cledoc;
      ExportXls.ModeAction := XmaDocument;
      ExportXls.Fournisseur := Fournisseur;
      ExportXls.Genere;
      ExportXls.free;
    end;
  end;
end;

procedure TOF_BTCODEAFFAIRE.MnExpCotraitXml (Sender : Tobject);
var cledoc : r_cledoc;
		ExportXls : TexportDocXls;
    fournisseur : string;
begin
  if pos('BTDEVIS_MUL',ecran.name) > 0 then
  begin
{$IFDEF EAGLCLIENT}
    TFMul(ecran).Q.TQ.Seek(TFMul(ecran).FListe.Row-1) ;
    Cledoc.naturePiece := TFMul(ecran).Q.FindField('GP_NATUREPIECEG').AsString;
    Cledoc.souche := TFMul(ecran).Q.FindField('GP_SOUCHE').AsString;
    Cledoc.numeroPiece := StrToInt(TFMul(ecran).Q.FindField('GP_NUMERO').AsString);
    Cledoc.indice := StrToInt(TFMul(ecran).Q.FindField('GP_INDICEG').AsString);
{$ELSE}
    Cledoc.naturePiece := Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').AsString;
    Cledoc.souche := Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
    Cledoc.numeroPiece := StrToInt(Fliste.datasource.dataset.FindField('GP_NUMERO').AsString);
    Cledoc.indice := StrToInt(Fliste.datasource.dataset.FindField('GP_INDICEG').AsString);
{$ENDIF}
  	fournisseur := AGLLanceFiche('BTP','BTMULAFFECTEXTE','','','COTRAITANCE;DOCUMENT='+EncodeCleDoc(cledoc)+';SELECTION');
    if fournisseur <> '' then
    begin
      ExportXls := TexportDocXls.create;
    	ExportXls.ModeExport  := TmeXml;
      ExportXls.TypeExport := TteCotrait;
      ExportXls.CleDoc := cledoc;
      ExportXls.ModeAction := XmaDocument;
      ExportXls.Fournisseur := Fournisseur;
      ExportXls.Genere;
      ExportXls.free;
    end;
  end;
end;
{$IFNDEF LINE}
procedure TOF_BTCODEAFFAIRE.FlisteDblClick(Sender: TObject);
Var StArg 				: String;
		TypeRessource : String;
    Ressource 		: String;
    ClePiece			: array [0..7] of Variant;
    TheAction			: ThEdit;
    TheModeSais   : TcheckBox;
    TheChaine     : string;
    cledoc : r_cledoc;
begin
    if copy(ecran.name,1,14)='BTDEVISINT_MUL' then
    begin
{$IFDEF EAGLCLIENT}
			TFMul(ecran).Q.TQ.Seek(TFMul(ecran).FListe.Row-1) ;
      Cledoc.NaturePiece := TFMul(ecran).Q.FindField('GP_NATUREPIECEG').AsString;
      cledoc.DatePiece := TFMul(ecran).Q.FindField('GP_DATEPIECE').AsDateTime;
      Cledoc.Souche := TFMul(ecran).Q.FindField('GP_SOUCHE').AsString;
      Cledoc.NumeroPiece  := TFMul(ecran).Q.FindField('GP_NUMERO').AsString;
      Cledoc.Indice := TFMul(ecran).Q.FindField('GP_INDICEG').AsString;
{$ELSE}
      Cledoc.NaturePiece  := Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').AsString;
      cledoc.DatePiece  := Fliste.datasource.dataset.FindField('GP_DATEPIECE').AsDateTime;
      Cledoc.Souche  := Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
      Cledoc.NumeroPiece  := StrToInt(Fliste.datasource.dataset.FindField('GP_NUMERO').AsString);
      Cledoc.Indice  := StrToInt(Fliste.datasource.dataset.FindField('GP_INDICEG').AsString);
{$ENDIF}
      if (Consultation) or (not IsDevisIntModifiable (cledoc)) then
      begin
      	SaisiePiece (CleDoc, taconsult);
    		Refreshdb;
      end else
      begin
       	SaisiePiece(Cledoc,taModif);
    		Refreshdb;
      end;
			exit;
    end;
    // -------------------------------------------------------------------
		TheAction := THEdit(GetControl('ZEACTION'));
    TheModeSais := TcheckBox(GetControl('AVANC'));
		if pos('BTDEVIS_MUL',ecran.name) > 0 then
    begin
      ClePiece[0] := TFMul(Ecran).Name ;
{$IFDEF EAGLCLIENT}
			TFMul(ecran).Q.TQ.Seek(TFMul(ecran).FListe.Row-1) ;
      ClePiece[1] := TFMul(ecran).Q.FindField('GP_NATUREPIECEG').AsString;
      ClePiece[2] := DateTimeToStr(TFMul(ecran).Q.FindField('GP_DATEPIECE').AsDateTime);
      ClePiece[3] := TFMul(ecran).Q.FindField('GP_SOUCHE').AsString;
      ClePiece[4] := TFMul(ecran).Q.FindField('GP_NUMERO').AsString;
      ClePiece[5] := TFMul(ecran).Q.FindField('GP_INDICEG').AsString;
      ClePiece[6] := 'ACTION=CONSULTATION';
{$ELSE}
      ClePiece[1] := Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').AsString;
      ClePiece[2] := DateTimeToStr(Fliste.datasource.dataset.FindField('GP_DATEPIECE').AsDateTime);
      ClePiece[3] := Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
      ClePiece[4] := Fliste.datasource.dataset.FindField('GP_NUMERO').AsString;
      ClePiece[5] := Fliste.datasource.dataset.FindField('GP_INDICEG').AsString;
      ClePiece[6] := 'ACTION=CONSULTATION';
{$ENDIF}

    end else
    begin
      ClePiece[0] := TFMul(Ecran).Name ;
{$IFDEF EAGLCLIENT}
			TFMul(ecran).Q.TQ.Seek(TFMul(ecran).FListe.Row-1) ;
      ClePiece[1] := TFMul(ecran).Q.FindField('GP_NATUREPIECEG').AsString;
      ClePiece[2] := DateTimeToStr(TFMul(ecran).Q.FindField('GP_DATEPIECE').AsDateTime);
      ClePiece[3] := TFMul(ecran).Q.FindField('GP_SOUCHE').AsString;
      ClePiece[4] := TFMul(ecran).Q.FindField('GP_NUMERO').AsString;
      ClePiece[5] := TFMul(ecran).Q.FindField('GP_INDICEG').AsString;
      ClePiece[6] := TFMul(ecran).Q.FindField('GP_TIERS').AsString;
      if TFMul(ecran).Q.findField('GP_AFFAIRE') <> nil then
      begin
      	ClePiece[7] := TFMul(ecran).Q.FindField('GP_AFFAIRE').AsString;
      end;
    end;
{$ELSE}
      ClePiece[1] := Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').AsString;
      ClePiece[2] := DateTimeToStr(Fliste.datasource.dataset.FindField('GP_DATEPIECE').AsDateTime);
      ClePiece[3] := Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
      ClePiece[4] := Fliste.datasource.dataset.FindField('GP_NUMERO').AsString;
      ClePiece[5] := Fliste.datasource.dataset.FindField('GP_INDICEG').AsString;
      ClePiece[6] := Fliste.datasource.dataset.FindField('GP_TIERS').AsString;
      if Fliste.datasource.DataSet.findField('GP_AFFAIRE') <> nil then
      begin
      	ClePiece[7] := Fliste.datasource.dataset.FindField('GP_AFFAIRE').AsString;
      end;
    end;
{$ENDIF}
		TheChaine := ClePiece[1]+';'+ClePiece[2]+';'+ClePiece[3]+';'+ClePiece[4]+';'+ClePiece[5]+';';

    if Consultation Then
       Begin
       AppelPiece([TheChaine,'ACTION=CONSULTATION'],2);
    		Refreshdb;
       Exit;
       End;

    if ModifDateSit then
    begin
    	ModificationDateSituation (TheChaine);
    	Refreshdb;
//      TToolBarButton97(GetControl('Bcherche')).Click;
      exit;
    end;

    // generation de la prevision de chantier
 	  if (TheAction <> nil) and  (TheAction.Text = 'PLANNIFICATION') then
       Begin
       AglPlannificationChantier(ClePiece,5);
    		Refreshdb;
//			 TToolBarButton97(GetControl('Bcherche')).Click;
       Exit;
       End;

    // generation de la contre etude
    if (TheAction <> nil) and  (TheAction.text = 'GENCONTRETU') then
       Begin
       AGLGenereContreEtude(ClePiece,5);
    	 Refreshdb;
//			 TToolBarButton97(GetControl('Bcherche')).Click;
       Exit;
       End;

    if (TheAction <> nil) and  (TheAction.text = 'GENCONTRETU') then
       Begin
       AGLGenereContreEtude(ClePiece,5);
    	 Refreshdb;
//			 TToolBarButton97(GetControl('Bcherche')).Click;
       Exit;
       End;

    if (TheModeSais <> nil) and  (TheModeSais.checked ) then
       Begin
			 AglAvancementChantier (ClePiece,7);
    	 Refreshdb;
//			 TToolBarButton97(GetControl('Bcherche')).Click;
       Exit;
       End;

    // Modification de devis
		AppelPiece([TheChaine,'ACTION=MODIFICATION'],2);
    //
    //if GetParamSocSecur('SO_REFRESHMUL', true) then TToolBarButton97(GetControl('Bcherche')).Click;
    Refreshdb;

end;
{$ENDIF}

Procedure TOF_BTCODEAFFAIRE.GestionSuitePlace;
var Bacomptes : TToolbarButton97;
    critere,valmul,champmul : string;
    x : integer;
    F : TFMul ;
    i : integer;
    CC : THValCOmboBox;
    TT : TToolbarButton97;
    TL : THlabel;
    TP : TTabSheet;
    TE : THEdit;
begin
	if (copy(ecran.name,1,11)='BTDEVIS_MUL') then
     Begin
     GestionMulDevisSuitePlace(StArgument);
     SetControlText('TGPAFFAIRE', 'Code Chantier');
     end
	Else if (copy(ecran.name,1,14)='BTDEVISINT_MUL') then
     Begin
     GestionMulDevisSuitePlace(StArgument);
     SetControlText('TGPAFFAIRE', 'Code Appel');
     end
	Else if (copy(ecran.name,1,11)='BTPIECE_MUL') then
     Begin
     GestionMulDevisSuitePlace(StArgument);
     SetControlText('TGPAFFAIRE', 'Code Chantier');
     end
  else if (copy(ecran.name,1,12)='BTACCDEV_MUL') then
     Begin
     SetControlText('TAFF_AFFAIRE', 'Code Chantier');
     end
	else if (copy(ecran.name,1,12)='BTPREFAC_MUL') then
     Begin
     SetControlText('TAFF_AFFAIRE', 'Code Chantier');
     end;
//  else
//		TFMUL(Ecran).SetDbliste('BTMULPIECE_S1');
end;


Procedure TOF_BTCODEAFFAIRE.GestionMulDevisSuitePlace(StArg : String);
Begin
   SetControlText('TGPAFFAIRE', 'Code Chantier');
{$IFDEF EAGLCLIENT}
   if THGrid (GetControl('FLISTE')) <> nil then
     	Begin
	  	Fliste := THGrid (GetControl('FLISTE'));
{$IFDEF LINE}
    	Fliste.OnDblClick := FlisteDblClickLine;
{$ELSE}
    	Fliste.OnDblClick := FlisteDblClick;
    	Fliste.OnRowEnter := FlisteRowEnter;
{$ENDIF}
     	end;
{$ELSE}
   if THDbGrid (GetControl('FLISTE')) <> nil then
     	Begin
	  	Fliste := THDbGrid (GetControl('FLISTE'));
{$IFDEF LINE}
    	Fliste.OnDblClick := FlisteDblClickLine;
{$ELSE}
    	Fliste.OnDblClick := FlisteDblClick;
    	Fliste.OnRowEnter := FlisteRowEnter;
{$ENDIF}
     	end;
{$ENDIF}
   if TmenuItem(getControl('MnExportExcel')) <> nil then
   begin
     TmenuItem(getControl('MnExportExcel')).OnClick := ExportExcelClick;
   end;
   if TmenuItem(getControl('MnExportXML')) <> nil then
   begin
     TmenuItem(getControl('MnExportXML')).OnClick := ExportXmlClick;
   end;
   if TmenuItem(getControl('MnExportXML')) <> nil then
   begin
     TmenuItem(getControl('MnExportXML')).OnClick := ExportXMLClick;
   end;
   if TmenuItem(getControl('MnExportMandate')) <> nil then
   begin
     TmenuItem(getControl('MnExportMandate')).OnClick := ExportDocMandateClick;
   end;
   if TmenuItem(getControl('MnExpCotraitXml')) <> nil then
   begin
     TmenuItem(getControl('MnExpCotraitXml')).OnClick := MnExpCotraitXml;
   end;

   if GetArgumentValue(StArg, 'ACTION') = 'MODIFICATION'  then
	    begin
  		Consultation := False;
	    end ;
	 if GetArgumentValue(StArg, 'ACTION') = 'CONSULTATION'  then
  		begin
  		Consultation := True;
	    SetControlProperty('BInsert1','visible',False);
		  SetControlProperty('BInsert','visible',False);
	    end ;
end;

{$IFDEF LINE}

procedure TOF_BTCODEAFFAIRE.FlisteDblClickLine(Sender: TObject);
Var StArg 				: String;
		TypeRessource : String;
    Ressource 		: String;
    ClePiece			: array [0..6] of Variant;
    TheAction			: ThEdit;
begin

		TheAction := THEdit(GetControl('ZEACTION'));

    ClePiece[0] := TFMul(Ecran).Name ;
	  ClePiece[1] := Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').AsString;
    ClePiece[2] := DateTimeToStr(Fliste.datasource.dataset.FindField('GP_DATEPIECE').AsDateTime);
    ClePiece[3] := Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
    ClePiece[4] := Fliste.datasource.dataset.FindField('GP_NUMERO').AsString;
    ClePiece[5] := Fliste.datasource.dataset.FindField('GP_INDICEG').AsString;
    ClePiece[6] := 'ACTION=CONSULTATION';

    if Consultation Then
       Begin
       AppelPiece(ClePiece,6);
       Exit;
       End;

    // generation de la prevision de chantier
 	  if TheAction.Text = 'PLANNIFICATION' then
       Begin
       AglPlannificationChantier(ClePiece,5);
    		Refreshdb;
			 //TToolBarButton97(GetControl('Bcherche')).Click;
       Exit;
       End;

    // generation de la contre etude
    if TheAction.text = 'GENCONTRETU' then
       Begin
       AGLGenereContreEtude(ClePiece,5);
    	Refreshdb;
			 //TToolBarButton97(GetControl('Bcherche')).Click;
       Exit;
       End;

    // Modification de devis
    if GetControlText('GP_VIVANTE')='X' then
	     AppelPiece(ClePiece, 5)
    else
	     AppelPiece(ClePiece, 6);
    //
    if GetParamSocSecur('SO_REFRESHMUL', true) then Refreshdb;
//TToolBarButton97(GetControl('Bcherche')).Click;

end;


Procedure TOF_BTCODEAFFAIRE.GestionLine;
var Bacomptes : TToolbarButton97;
    critere,valmul,champmul : string;
    x : integer;
    F : TFMul ;
    i : integer;
    CC : THValCOmboBox;
    TT : TToolbarButton97;
    TL : THlabel;
    TP : TTabSheet;
    TE : THEdit;
begin
  if cc <> nil then CC.visible := false;

  TT:=TToolBarButton97(GetControl('BINSERT1')) ; if TT<>Nil then TT.visible := false;
  TL:=THlabel(GetControl('TGP_ETABLISSEMENT')) ; if TL<>Nil then TL.visible := false;
  CC := THValCOmboBox(GetControl('AFF_GENERAUTO')); if CC <> nil then CC.plus := 'BTP" AND CO_CODE <> "DAC';
  CC := THValCOmboBox(GetControl('GP_REPRESENTANT')); if CC <> nil then CC.visible := false;
  TL:=THlabel(GetControl('TGP_REPRESENTANT')) ; if TL<>Nil then TL.visible := false;
  CC := THValCOmboBox(GetControl('GP_DEVISE')); if CC <> nil then CC.visible := false;
  TL:=THlabel(GetControl('TGP_DEVISE')) ; if TL<>Nil then TL.visible := false;
  CC := THValCOmboBox(GetControl('GP_LIBREPIECE1')); if CC <> nil then CC.visible := false;
  TL:=THlabel(GetControl('TGP_LIBREPIECE1')) ; if TL<>Nil then TL.visible := false;
  CC := THValCOmboBox(GetControl('GP_LIBREPIECE2')); if CC <> nil then CC.visible := false;
  TL:=THlabel(GetControl('TGP_LIBREPIECE2')) ; if TL<>Nil then TL.visible := false;
  CC := THValCOmboBox(GetControl('GP_LIBREPIECE3')); if CC <> nil then CC.visible := false;
  TL:=THlabel(GetControl('TGP_LIBREPIECE3')) ; if TL<>Nil then TL.visible := false;
  TT:=TToolBarButton97(GetControl('BACOMPTES')) ; if TT<>Nil then TT.visible := false;
  if Copy(Ecran.Name,1,12)='BTACCDEV_MUL' then
  begin
    TP := TTabSheet(GetControl('PCOMPLEMENT')) ; if TP<>Nil then TP.tabvisible := false;
  end;

  if BAcomptes <> nil then
     BEGIN
     BAcomptes.down := false;
     BAcomptes.visible := false;
     END;

  TE := THEdit(GetCOntrol('AFF_RESPONSABLE'));
  if TE <> nil then TE.visible := false;

  TL := THLabel(GetCOntrol('TAFF_RESPONSABLE'));
  if TL <> nil then TL.visible := false;

  if (copy(ecran.name,1,14)='BTDEVIS_MUL_S1') then
     GestionMulDevis_S1(StArgument)
	Else if (copy(ecran.name,1,11)='BTDEVIS_MUL') then
     Begin
     TFMUL(Ecran).SetDbliste('BTMULDEVIS_S1');
     SetControlText('TGPAFFAIRE', 'Code Chantier');
     end
	Else if (copy(ecran.name,1,11)='BTPIECE_MUL') then
     Begin
     TFMUL(Ecran).SetDbliste('BTMULDEVIS_S1');
     SetControlText('TGPAFFAIRE', 'Code Chantier');
     SetControlVisible('GP_VIVANTE', false);
     end
  else if (copy(ecran.name,1,12)='BTACCDEV_MUL') then
     Begin
     TFMUL(Ecran).SetDbliste('BTMULDEVIS_S1');
     SetControlText('TAFF_AFFAIRE', 'Code Chantier');
     end
	else if (copy(ecran.name,1,12)='BTPREFAC_MUL') then
     Begin
     TFMUL(Ecran).SetDbliste('BTPREFACIMM_S1');
     SetControlText('TAFF_AFFAIRE', 'Code Chantier');
     end;
//  else
//		TFMUL(Ecran).SetDbliste('BTMULPIECE_S1');
end;

Procedure TOF_BTCODEAFFAIRE.GestionMulDevis_S1(StArg : String);
Begin

   TFMUL(Ecran).SetDbliste('BTMULDEVIS_S1');

   SetControlText('TGPAFFAIRE', 'Code Chantier');

   TTABSheet(GetControl('PCOMPLEMENT')).TabVisible := False;

   if THDbGrid (GetControl('FLISTE')) <> nil then
     	Begin
	  	Fliste := THDbGrid (GetControl('FLISTE'));
    	Fliste.OnDblClick := FlisteDblClickLine;
     	end;

   if GetArgumentValue(StArg, 'ACTION') = 'MODIFICATION'  then
	    begin
		  //GP_NATUREPIECEG.enabled:=false;
  		Consultation := False;
	    end ;

	 if GetArgumentValue(StArg, 'ACTION') = 'CONSULTATION'  then
  		begin
	    //GP_NATUREPIECEG.enabled:=false;
  		Consultation := True;
	    SetControlProperty('BInsert1','visible',False);
		  SetControlProperty('BInsert','visible',False);
	    end ;

end;


{$ENDIF LINE}
Procedure TOF_BTCODEAFFAIRE.ControleChamp(Champ : String;Valeur : String);
Begin

	if Champ='MEMOIRE' then IsMemoire:=true;
  if Champ='MODIFDATSIT' then
  begin
  	ModifDateSit := true;
    SetControlEnabled('AFF_GENERAUTO', False);
  end;

  //if champ='STATUT' then SetControlText('GP_STATUTAFFAIRE0', Valeur);

  if champ='ETAT' then SetControlText('AFF_ETATAFFAIRE', Valeur);

  if Champ='STATUT' then
     Begin
     if Valeur = 'APP' then
        Begin
	    	SetControlText('XX_WHERE', ' AND SUBSTRING(GP_AFFAIRE,1,1) IN ("","W")');
        SetControlText('AFFAIRE0', 'W');
        SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Appel');
        SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Critères Appel');
        SetControlText('TGPAFFAIRE', 'Code Appel');
        end
     else if Valeur = 'INT' then
        Begin
      	SetControlText('XX_WHERE', ' AND (SUBSTRING(GP_AFFAIRE,1,1)="I")');
        SetControlText('AFFAIRE0', 'I');
        SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Contrat');
        SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Critères Contrat');
        SetControlText('TGPAFFAIRE', 'Code Contrat');
        End
     else if Valeur = 'GRP' then
        Begin
	    	SetControlText('XX_WHERE', ' AND SUBSTRING(GP_AFFAIRE,1,1)IN ("W","A")');
        SetControlText('AFFAIRE0', 'A');
        SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Affaire');
        SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Critères Affaire');
        SetControlText('TGPAFFAIRE', 'Code Affaire');
        end
     else if Valeur = 'AFF' then
        Begin
      	SetControlText('XX_WHERE', ' AND SUBSTRING(GP_AFFAIRE,1,1)="A"');
        SetControlText('AFFAIRE0', 'A');
        SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Chantier');
        SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Critères Chantier');
        SetControlText('TGPAFFAIRE', 'Code Chantier');
        end
     else if Valeur = 'PRO' then
        Begin
      	SetControlText('XX_WHERE', ' AND SUBSTRING(GP_AFFAIRE,1,1)="P"');
        SetControlText('AFFAIRE0', 'P');
        SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Appel d''offre');
        SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Critères Appel d''offre');
        SetControlText('TGPAFFAIRE', 'Code Appel d''offre');
        end
     else
        Begin
      	SetControlText('XX_WHERE', '');
        SetControlText('AFFAIRE0', '');
        SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Affaire');
        SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Critères Affaire');
        SetControlText('TGPAFFAIRE', 'Code Affaire');
        end;
     end;
  if Champ='ACCEPTINVERSE' then
  begin
    SetControltext('ACCEPTINVERSE','X');
    SetControlText('AFF_ETATAFFAIRE', 'ACP');
  end;
  if Champ='AFF_GENERAUTO' then
  begin
    SetControltext('AFF_GENERAUTO',Valeur);
  end;
end;

procedure TOF_BTCODEAFFAIRE.Onload;
var TypePiece,Caption : string;
    i : integer;
    QQ : TQuery;
begin
Inherited;

TypePiece := GetControlText ('GP_NATUREPIECEG');

// En cas d'appel multi natures de pices, remplacement de : par ;
TypePiece := StringReplace(TypePiece,':',';',[rfReplaceAll]);
SetControlText ('GP_NATUREPIECEG',TypePiece);
Setcontrolproperty('B_DUPLICATION1','visible',false);
Setcontrolproperty('B_DUPLICATION','visible',true);

if (TypePiece <> ''){ and (Length(TypePiece) = 3) } then
  Begin
  if copy(ecran.name,1,12)<>'BTACCDEV_MUL' then
  begin
    Caption := 'Liste '+rechdom('GCNATUREPIECEG',GetControlText ('GP_NATUREPIECEG'),false);
    if IsMemoire then
      begin
      Caption := TraduireMemoire ( 'Traitement de cloture');
      end;
  end else
  begin
    if GetControlText('ACCEPTINVERSE')<>'X' then
    begin
      Caption := 'Acceptation '+rechdom('GCNATUREPIECEG',GetControlText ('GP_NATUREPIECEG'),false);
    end else
    begin
      Caption := 'Annulation de l''acceptation '+rechdom('GCNATUREPIECEG',GetControlText ('GP_NATUREPIECEG'),false);
    end;
  end;
  ecran.caption := caption;
  UpdateCaption(Ecran);
  RenommageEnteteColonnes(TypePiece);
  end;

	 if (GetInfoParPiece(TypePiece,'GPP_VENTEACHAT'))='ACH'  then
   begin
   Setcontrolvisible('AFF_GENERAUTO',False);
   Setcontrolvisible('TAFF_GENERAUTO',False);
   Setcontrolvisible('B_DUPLICATION',False);
   Setcontrolproperty('GP_TIERS','Plus',' AND T_NATUREAUXI="FOU"');
   end
else if TypePiece = 'DBT' then
   begin
     if THEdit(GetControl ('ZEACTION')) <> nil then
     begin
       if GetControlText ('ZEACTION')='GENCONTRETU' then
       begin
         Setcontrolvisible('BINSERT',False);
         Setcontrolvisible('BINSERT1',False);
        Setcontrolvisible('B_DUPLICATION',False);
       end;
     end;
   end
else if TypePiece = 'ABT' then
   begin
   Setcontrolvisible('AFF_GENERAUTO',False);
   Setcontrolvisible('TAFF_GENERAUTO',False);
   end
else if (TypePiece = 'PBT') or (TypePiece = 'CBT') or (TypePiece = 'FPR') or (TypePiece = 'FAC') or (TypePiece = 'AVC') then
   begin
   Setcontrolvisible('AFF_GENERAUTO',False);
   Setcontrolvisible('TAFF_GENERAUTO',False);
   Setcontrolvisible('B_DUPLICATION',False);
   if (typePiece = 'FPR') or (typePiece = 'FAC') or (typePiece = 'AVC') then SetControlText ('AFF_GENERAUTO','');
   end
else if (TypePiece = 'DAP') or (TypePiece = 'DAC') then
   begin
   if copy(Ecran.name,1,14)<>'BTDEVISINT_MUL' then
   begin
   	Setcontrolvisible('BINSERT',False);
   end;
   Setcontrolvisible('BACOMPTES',False);
   Setcontrolvisible('B_DUPLICATION',False);
   Setcontrolvisible('AFF_GENERAUTO',False);
   Setcontrolvisible('TAFF_GENERAUTO',False);
   end
else if TypePiece = 'ETU' then
   begin
   Setcontrolvisible('BINSERT1',False);
   Setcontrolvisible('BACOMPTES',False);
   Setcontrolproperty('BINSERT','Hint',TraduireMemoire('Nouvelle étude'));
   Setcontrolproperty('BOUVRIR','Hint',TraduireMemoire('Valider les études sélectionnées'));
   Setcontrolproperty('B_DUPLICATION1','Hint',TraduireMemoire('dupliquer l''étude'));
   Setcontrolproperty('B_DUPLICATION','visible',true);
//   Setcontrolproperty('B_DUPLICATION1','visible',true);
   end
else if TypePiece = 'LBT' then
   begin
   Setcontrolproperty('B_DUPLICATION','visible',false);
   end
else if TypePiece = 'BCE' then
   begin
   Setcontrolproperty('BINSERT','Hint',TraduireMemoire('Nouvelle contre-étude'));
   Setcontrolproperty('B_DUPLICATION1','Hint',TraduireMemoire('dupliquer la contre étude'));
   Setcontrolproperty('B_DUPLICATION1','visible',true);
   Setcontrolproperty('B_DUPLICATION','visible',false);
   end;

if UpperCase(copy(Ecran.Name,1,11)) = 'BTDEVIS_MUL' then
begin
  if THEdit(GetControl ('ZEACTION')) <> nil then
  begin
    if THEdit(GetControl ('ZEACTION')).Text = 'PLANNIFICATION' then
    begin
      THEdit(GetControl('AFF_ETATAFFAIRE')).Enabled := false;
      TToolbarButton97(GetControl('BInsert')).visible := false;
      TToolbarButton97(GetControl('BINSERT1')).visible := false;
      TToolbarButton97(GetControl('B_DUPLICATION')).visible := false;
    end else if THEdit(GetControl ('ZEACTION')).Text = 'GENCONTRETU' then
    begin
      THEdit(GetControl('AFF_ETATAFFAIRE')).Enabled := false;
      TToolbarButton97(GetControl('BInsert')).visible := false;
      TToolbarButton97(GetControl('BINSERT1')).visible := false;
      TToolbarButton97(GetControl('B_DUPLICATION')).visible := false;
    end else if THEdit(GetControl ('ZEACTION')).Text = '' then
    begin
    	if THEdit(GetControl('GP_AFFAIRE')).text <> '' then
      begin
      	QQ := OpenSql ('SELECT AFF_ETATAFFAIRE FROM AFFAIRE WHERE AFF_AFFAIRE="'+THEdit(GetControl('GP_AFFAIRE')).text+'"',true,1,'',True);
        if not QQ.eof then
        begin
        	if Pos(QQ.FindField('AFF_ETATAFFAIRE').AsString,'TER;CLO')>0 then
          begin
            TToolbarButton97(GetControl('BInsert')).visible := false;
            TToolbarButton97(GetControl('BINSERT1')).visible := false;
            TToolbarButton97(GetControl('B_DUPLICATION')).visible := false;
          end;
        end;
        ferme (QQ);
      end;
    end;
  end;
end;

if UpperCase(copy(Ecran.Name,1,13)) = 'BTREGLAFFAIRE' then
begin
if GetControlText ('GP_AFFAIRE') = '' then
  begin
  Setcontrolvisible('BSELECTAFF1',True);
  Setcontrolvisible('BEFFACEAFF1',True);
  Setcontrolenabled('GP_AFFAIRE1',True);
  Setcontrolenabled('GP_AFFAIRE2',True);
  Setcontrolenabled('GP_AFFAIRE3',True);
  Setcontrolproperty('TGPAFFAIRE','Caption',TraduireMemoire('Affaire'));
  end;
end;

if UpperCase(copy(Ecran.Name,1,15)) = 'BTPIECESAFF_MUL' then
begin
if TCheckBox(GetControl('CONSULTATION')).checked=True then
  begin
  Setcontrolvisible('BSELECTAFF1',False);
  Setcontrolvisible('BEFFACEAFF1',False);
  Setcontrolenabled('GP_AFFAIRE1',False);
  Setcontrolenabled('GP_AFFAIRE2',False);
  Setcontrolenabled('GP_AFFAIRE3',False);
  Setcontrolenabled('GP_TIERS',False);
  Setcontrolenabled('T_LIBELLE',False);
  Setcontrolvisible('Binsert',False);
  Setcontrolvisible('B_DUPLICATION',False);
  end;
end;

if GetControlText('AVANC')='X' then SetControlVisible('BInsert',false); 

end;

procedure TOF_BTCODEAFFAIRE.OnUpdate;
var  F : TFMul ;
    i:integer;
    CC:THLabel ;
begin
inherited ;
if not (Ecran is TFMul) then exit;
If ((Ecran.name='BTDEVIS_MUL') or (Ecran.name='BTACCDEV_MUL')) {$IFNDEF LINE} and (GetControlText ('GP_NATUREPIECEG') = 'ETU') {$ENDIF} then
   Begin
   F:=TFMul(Ecran) ;
{$IFDEF EAGLCLIENT}
   for i:=0 to F.FListe.ColCount-1 do
       begin
// A FAIRE
       end;
{$ELSE}
    for i:=0 to F.FListe.Columns.Count-1 do
       begin
{$IFNDEF LINE}
       if F.FListe.Columns[i].FieldName='GP_NUMERO' then
          F.FListe.Columns[i].Title.caption:=TraduireMemoire('N Etude');
{$ENDIF}
       if F.FListe.Columns[i].FieldName='AFF_AVENANT' then
       begin
          F.Fliste.columns[i].visible:=false ;
          F.SetVisibleColumn(i,false)
        end;
       end;
{$ENDIF}
    end;
	FListeRowEnter(self);
end;

procedure TOF_BTCODEAFFAIRE.NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_:THEdit);
begin
Aff:=THEdit(GetControl('GP_AFFAIRE'));
Aff0:=THEdit(GetControl('AFFAIRE0'));
Aff1:=THEdit(GetControl('GP_AFFAIRE1'));
Aff2:=THEdit(GetControl('GP_AFFAIRE2'));
Aff3:=THEdit(GetControl('GP_AFFAIRE3'));
Aff4:=THEdit(GetControl('GP_AVENANT'));
Tiers:=THEdit(GetControl('GP_TIERS'));
end;

procedure TOF_BTCODEAFFAIRE.RenommageEnteteColonnes(TypePiece: string);
var i : integer;
{$IFDEF EAGLCLIENT}
		Gr : THgrid;
{$ELSE}
		Gr : THDbgrid;
{$ENDIF}

    stChamp,Libelle : string;
begin
	Gr := TFMul(ecran).fliste;
{$IFDEF EAGLCLIENT}
	For i:=0 to Gr.ColCount -1 do
  Begin
    StChamp := TFMul(Ecran).Q.FormuleQ.GetFormule(Gr.ColNames [i]); //21/10/2005 on rcupre le nom ttoaldu champ
    if UpperCase (stChamp)='GP_NUMERO' then
    begin
    	if TypePiece = 'ETU' then Libelle := 'N Etude'
    	else if TypePiece = 'BCE' then Libelle := 'N C.Etude'
      else if (TypePiece = 'DBT') or (TypePiece = 'DAP') then Libelle := 'N Devis'
      else Libelle := 'Numéro';
			TFMul(ecran).SetDisplayLabel (StChamp,TraduireMemoire(Libelle));
    end;
  end;
{$ELSE}
	For i:=0 to Gr.Columns.Count-1 do
  Begin
    StChamp := TFMul(Ecran).Q.FormuleQ.GetFormule(Gr.Columns[i].FieldName); //21/10/2005 on rcupre le nom ttoaldu champ
    if UpperCase (stChamp)='GP_NUMERO' then
    begin
    	if TypePiece = 'ETU' then Libelle := 'N Etude'
    	else if TypePiece = 'BCE' then Libelle := 'N C.Etude'
      else if (TypePiece = 'DBT') or (TypePiece = 'DAP') then Libelle := 'N Devis'
      else Libelle := 'Numéro';
			TFMul(ecran).SetDisplayLabel (StChamp,TraduireMemoire(Libelle));
    end;
  end;
{$ENDIF}

end;

procedure TOF_BTCODEAFFAIRE.BInsertClick(Sender: TObject);
begin
	if GetControlText('GP_AFFAIRE') = '' then
		 AGLCreerPieceBTP(['','',GetControltext('GP_NATUREPIECEG'),'','',GetControlText('AFFAIRE0')], 0)
	else
		 AGLCreerPieceBTP([GetControlText('GP_TIERS'),GetControlText('GP_AFFAIRE'),GetControltext('GP_NATUREPIECEG'),'','CRE', GetControlText('AFFAIRE0')],0);
  if GetParamSocSecur('SO_REFRESHMUL', true) then
  begin
  	//TToolBarButton97(GetControl('Bcherche')).Click;
    Refreshdb;
  end;

end;

procedure TOF_BTCODEAFFAIRE.ModificationDateSituation (TheChaine : string);
var naturepiece,Souche,LaChaine,bof : string;
		Numero,Indice : integer;
    TOBDates,TOBSit : TOB;
    DateSit : TDateTime;
    QQ : TQuery;
    Req : String;
begin

	laChaine := TheChaine;
	naturePiece := READTOKENST(LaChaine);
  Bof := READTOKENST(LaChaine); // Date
  Souche :=READTOKENST(LaChaine);
  Numero := StrToInt(READTOKENST(LaChaine));
  Indice := StrToInt(READTOKENST(LaChaine));
  TOBSIT := TOB.Create ('BSITUATIONS',nil,-1);
  TOBDates := TOB.Create ('LES DATES', nil,-1);
  //
  Req := 'SELECT * FROM BSITUATIONS WHERE BST_NATUREPIECE="'+NaturePiece+'" AND '+
  				'BST_SOUCHE="'+Souche+'" AND BST_NUMEROFAC="'+IntToStr(Numero)+'"';
  //
  QQ := openSql(Req,true,-1,'',true);
  if not QQ.eof then
  begin
  	TOBSit.SelectDB('',QQ);
  end;
  Ferme (QQ);
  if TOBSit.GetInteger('BST_NUMEROFAC')=Numero then
  begin
    TOBDates.AddChampSupValeur('RETOUROK','-');
    TOBDates.AddChampSupValeur('DATEFAC',TOBSit.getValue('BST_DATESIT'));
    TOBDates.AddChampSupValeur('DATESITUATION','X');
    TRY
      TheTOB := TOBDates;
      AGLLanceFiche('BTP','BTDEMANDEDATES','','','');
      TheTOB := nil;
    FINALLY
      if TOBDates.getValue('RETOUROK')='X' then
      begin
        TOBSit.SetDateTime ('BST_DATESIT',TOBDates.GetDateTime('DATEFAC'));
        TOBSit.UpdateDB(false);
      end;
    END;
  end;
  freeAndNil(TOBDates);
  FreeAndNil(TOBSIT);

end;

procedure BTPgenerePropal(parms: array of variant; nb: integer);
var F: TForm;
  Titre, NaturePiece,Souche: string;
  Numero,Indice : integer;
begin
  F := TForm(Longint(Parms[0]));
  Titre := F.Caption;
  NaturePiece := Trim(string(Parms[1]));
  Souche := string(Parms[2]);
  Numero := integer(Parms[3]);
  Indice := integer(Parms[4]);
  LSEGenerepropal (naturePiece,Souche,Numero,Indice);
end;



Initialization
registerclasses([TOF_BTCODEAFFAIRE]);
RegisterAglProc( 'BTPGenerepropal', TRUE , 5, BTPgenerePropal);
end.
