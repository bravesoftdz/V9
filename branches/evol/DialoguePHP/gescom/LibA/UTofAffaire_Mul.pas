{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... :
Modifié le ... :   /  /
Description .. : Gestion des la grille multicritères des affaires
Mots clefs ... : TOF;UTOFAFFAIRE_MUL
*****************************************************************}
unit UTofAffaire_Mul;

interface

uses  StdCtrls,
			Controls,
      Classes,
      M3FP,
      HTB97,
      HPanel,
      windows,
      messages,
      Ent1,
{$IFDEF EAGLCLIENT}
      eMul,
      Maineagl,
      HQry,
{$ELSE}
      db,
      {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
      DBGrids,
      mul,FE_Main,
{$ENDIF}
      forms,
      sysutils,
      HDB,
      ParamSoc,
      utob,
      ComCtrls,
      HCtrls,
      HEnt1,
      HMsgBox,
      UTOF,
      ConfidentAffaire,
      AffaireUtil,
      AffaireRegroupeUtil,
      Dicobtp,
      SaisUtil,
      EntGC,
      BTPUtil,
      utofAfBaseCodeAffaire,
      utilpgi,
      AglInit,
      UtilGc,
      UtofAfAvenant, // à laisser car du scirpt, appel d'une fiche avec cette tof. Pour Ok dans projet
      AssistCreationAffaire, // mcd 10/06/02 appelé du script. a laisser
      TraducAffaire;
Type
     TOF_AFFAIRE_MUL = Class (TOF_AFBASECODEAFFAIRE)
        procedure OnArgument(stArgument : String ) ; override ;
        procedure OnUpdate ; override ;
        procedure OnLoad ; override ;
        procedure AfterShow;
        procedure NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_:THEdit); override;
        procedure TraiteRetour;
        procedure TraiteInvite;
     private
     		MAffaire0   : THValComboBox;
        VUserInvite : boolean;
        GNbLoads 		: integer;
{$IFDEF CTI}
				Contact : string;
				Numtel : string;
{$ENDIF}
        BOuvrir1   	: TToolBarButton97;
        BInsert			: TToolBarButton97;

        Fonction 		: string;
        Affaire0		: String;
        Statut			: String;
        sPlus       : String;
				NomFiche		: String;

        Top 				: Integer;
        bPasSiUn		: Boolean;
        bItDatesMax : Boolean;
        AffEtat     : Boolean;
        ChangeStatut: Boolean;
        EtatAffaire : THMultiValComboBox;

        StatutAff		: THValComboBox;

        Fliste 			: THDbGrid;

        TResponsable: THEdit;

		    procedure AffectationRessource(Sender : TOBJect);
				procedure ControleCritere(Critere, Champ, Valeur : string);
		    procedure StatutExit(Sender: TObject);
        procedure PositionneAffaire0 (Sender : Tobject);
        //
        //Modif FV
				Procedure FlisteDblClick (Sender : TObject);
		    Procedure BInsert_OnClick(Sender: TObject);
        procedure BRechResponsable(Sender: TObject);
		    procedure ChargeEcranStatutAffaire;
        procedure VisuAffaireClick(Sender: TObject);

     END ;
Type
     TOF_APPORTEUR_MUL = Class (TOF)
        procedure OnArgument(stArgument : String ) ; override ;
     END ;

Procedure AFLanceFiche_MulEAffaire;
Procedure AFLanceFiche_MulAffaire(Range,Argument:string);
Function  AFLanceFiche_AffaireRech(Range,Argument:string):variant;
Procedure AFLanceFiche_MulAffCompta;
Procedure AFLanceFiche_Mul_Apporteur;
Procedure AFLanceFiche_MulAvenantAff(Range,Argument:string);
Procedure AFLanceFiche_IntervAff;

implementation
uses UtilRessource, uTOFComm;

procedure TOF_AFFAIRE_MUL.AfterShow;
begin

with TFMul(Ecran) do
  begin
  if Q.RecordCount=1 then
    begin
    if isInside(TFmul(Ecran)) then
      begin
      THPanel(parent).CloseInside;
      THPanel(parent).VideToolBar ;
      end ;
{$IFNDEF EAGLCLIENT}
    Retour := Fliste.datasource.dataset.findfield('AFF_AFFAIRE').text+';'+Fliste.datasource.dataset.findfield('AFF_TIERS').text;
{$ELSE}
    Retour := Q.TQ.FindField('AFF_AFFAIRE').AsString+';'+Q.TQ.FindField('AFF_TIERS').AsString;
{$ENDIF}
//    if Not (V_PGI.ModeTSE) then
      PostMessage(TFmul(Ecran).Handle, WM_CLOSE, 0, 0);
//    PostMessage(Handle, WM_CLOSE, 0, 0);
    end;
  end;
end;

procedure TOF_AFFAIRE_MUL.OnArgument(stArgument : String );
var Critere {, sValeursEtatsAffaire} : string;
    champ,valeur : string;
    X : integer;
    CC : THValCOmboBox;
Begin
fMulDeTraitement  := true;
Inherited;
	 fTableName := 'AFFAIRE';
//
   GNbLoads := 0;
   bPasSiUn := false;
   bItDatesMax := false;
   VUserInvite:=False;
   top :=0;
   Statut :='';
   sPlus := '';
   Fonction := '';

   if assigned(GetControl('AFF_MANDATAIRE')) then THDBCheckbox (GetControl('AFF_MANDATAIRE')).State := cbGrayed;
   if Assigned(GetControl('AFF_RESPONSABLE')) Then
   begin
      TResponsable := THEdit(GetControl('AFF_RESPONSABLE'));
      TResponsable.OnElipsisClick := BRechResponsable;
   end;
   //
	 if copy(ecran.name ,1,12) <> 'BTAPPOFF_MUL' then
   begin
    if Assigned(GetControl('AFF_ETATAFFAIRE')) then EtatAffaire := THMultiValComboBox (GetControl ('AFF_ETATAFFAIRE'));
	 end;
   //

   Critere:=(Trim(ReadTokenSt(stArgument)));

   While (Critere <>'') do
       BEGIN
       X:=pos(':',Critere);
       if x=0 then X:=pos('=',Critere);
       if x<>0 then
          begin
          Champ  :=copy(Critere,1,X-1);
          Valeur :=Copy (Critere,X+1,length(Critere)-X);
          end
       else
          champ  := critere;
       ControleCritere(Critere, Champ, Valeur);
       Critere:=(Trim(ReadTokenSt(stArgument)));
       END;

   //RECUPERATION DES ZONES ECRAN
   if copy(ecran.name ,1,12) <> 'BTAPPOFF_MUL' then
   begin
     Fliste := THDbGrid (GetControl('FLISTE'));
     Fliste.OnDblClick := FlisteDblClick;
   end;

 	 Nomfiche := 'BTAFFAIRE';

   {$IFDEF LINE}
   Nomfiche := 'BTAFFAIRE_S1';
	 {$ENDIF}

   {$IFDEF EAGLCLIENT}
   TraduitAFLibGridSt(TFMul(Ecran).FListe);
   {$ELSE}
   TraduitAFLibGridDB(TFMul(Ecran).FListe);
   {$ENDIF}

   //Déclarations et procédures des zones ecran
   StatutAff := THValComboBox(GetControl('AFF_STATUTAFFAIRE'));
   StatutAff.OnExit := StatutExit;

if Not(ModifAffaireAutorise) and (GetControlText('XXAction') <> 'ACTION=RECH') then SetControlText('XXAction','ACTION=CONSULTATION');

If GetControl ('XXACTION') <> Nil then
  begin
  if GetControlText('XXAction') <> '' then
   begin
   if (StringToAction(GetControlText('XXAction')) = taconsult) then
      begin
{$IFDEF BTP}
      SetControlVisible ('BInsert',true); // on autorise la creation d'affaire en recherche
{$ELSE}
      SetControlVisible ('BInsert',False);
{$ENDIF}
      SetControlVisible ('BInsert1',False);
      end;
   end;
  end;

  ChargeEcranStatutAffaire;

// Caption de la form
if Ecran.Name = 'AFFAIREAVT_MUL' then
   begin // Avenants sur affaires
   if Statut = 'PRO' then
   	  Ecran.Caption := TraduitGA('Avenants sur propositions d''affaires')
   else if Statut = 'INT' then
      Ecran.Caption := TraduitGA('Avenants sur contrat')
   else if Statut = 'APP' then
      Ecran.Caption := TraduitGA('Compléments d''appel')
   else
   	  Ecran.Caption := TraduitGA('Avenants sur affaires');
   end;

UpdateCaption(Ecran);

// on peut modifier le statut, il faut donc avoir les 2 boutons d'insert
if (top = 0) then
   begin
   if fonction <> '' then
      Begin
      SetControlVisible ('BInsert',false);
      SetControlVisible ('BInsert1',False);
      end
   else
      Begin
	    SetControlVisible ('BInsert',true);
	    SetControlVisible ('BInsert1',true);
      end;
   end;



// Gestion des sous affaires
if not(GereSousAffaire) then
   begin
   SetcontrolVisible('TAFF_AFFAIREREF',False);
   SetcontrolVisible('AFFAIREREF1',False);
   SetcontrolVisible('AFFAIREREF2',False);
   SetcontrolVisible('AFFAIREREF3',False);
   SetcontrolVisible('AFFAIREREF4',False);
   SetcontrolVisible('AFF_ISAFFAIREREF',False);
   SetcontrolVisible('BSELECTAFF2',False);
   end;

{$IFDEF BTP}
//SetcontrolVisible('PCOMPLEMENT',False);
SetcontrolVisible('TAFF_TOTALHTGLO',False);
SetcontrolVisible('AFF_TOTALHTGLO',False);
SetcontrolVisible('TAFF_TOTALHTGLO_',False);
SetcontrolVisible('AFF_TOTALHTGLO_',False);
SetcontrolVisible('AFF_MODELE',False);
SetcontrolVisible('AFF_ADMINISTRATIF',False);

SetcontrolVisible('TAFF_STATUTAFFAIRE',ChangeStatut);
SetcontrolVisible('AFF_STATUTAFFAIRE',ChangeStatut);

SetcontrolVisible('TAFF_ETATAFFAIRE',AffEtat);
SetcontrolVisible('AFF_ETATAFFAIRE',AffEtat);

SetControlVisible('TAFF_CHANTIER', False);
SetControlVisible('AFF_CHANTIER', False);

{$ENDIF}

// Test droit d'accès en création
if not(CreationAffaireAutorise) then
   begin
   SetControlVisible('bAssistantCreation',False);
   SetControlVisible('bInsert',False);
   SetControlVisible ('BInsert1',False);
   end;
{$IFDEF EAGLCLIENT}
//SetControlVisible ('BASSISTANTCREATION',False); portage en Eagl de l'assistant création affaire
TraduitAFLibGridSt(TFMul(Ecran).FListe);
{$ELSE}
TraduitAFLibGridDB(TFMul(Ecran).FListe);
{$ENDIF}

// PL le 25/06/03 : gestion de la non ouverture si un seul element est trouvé
if bPasSiUn then
  begin
    TFmul(Ecran).OnAfterFormShow := AfterShow;
  end;

	// PL le 09/07/03 : on force l'intervalle de dates au maximum pour ramener toutes les missions dans certains cas (saisie d'activité par exemple)
  // On réduit également le tiers au code tiers exact et non pas au like "ZZZ%"
	if bItDatesMax then
  	 begin
     SetControlText ('AFF_DATEDEBUT', datetostr (idate1900));
     SetControlText ('AFF_DATEDEBUT_',  datetostr (idate2099));
   	 SetControlProperty( 'AFF_TIERS', 'operateur', Egal);
     TFMul(Ecran).FListe.SetFocus;
  	 end;

  {$IFDEF CCS3}
  if (getcontrol('PZONE') <> Nil) then SetControlVisible ('PZONE', False);
  if (getcontrol('PSTAT') <> Nil) and  (Ecran.Name <> 'AFFAIREAVT_MUL') then SetControlVisible ('PSTAT', False);
  {$ENDIF}

	// gestion Etablissement (BTP)
	CC:=THValComboBox(GetControl('AFF_ETABLISSEMENT')) ;
	if CC<>Nil then
  begin
  	PositionneEtabUser(CC) ;
    if not VH^.EtablisCpta then
    begin
    	if THLabel(GetControl('TAFF_ETABLISSEMENT')) <> nil then THLabel(GetControl('TAFF_ETABLISSEMENT')).Visible := false;
			CC.visible := false;
    end;
	end;

{$IFDEF LINE}
  if THLabel(GetControl('TAFF_RESPONSABLE')) <> nil then THLabel(GetControl('TAFF_RESPONSABLE')).visible := false;
  if THLabel(GetControl('AFF_RESPONSABLE')) <> nil then THLabel(GetControl('AFF_RESPONSABLE')).visible := false;
  if THLabel(GetControl('TAFFAIRE0')) <> nil then THLabel(GetControl('TAFFAIRE0')).visible := false;
  if THValComboBox(GetControl('AFFAIRE0')) <> nil then THValComboBox(GetControl('AFFAIRE0')).visible := false;
  if THLabel(GetControl('TAFF_ETABLISSEMENT')) <> nil then THLabel(GetControl('TAFF_ETABLISSEMENT')).visible := false;
  if THValComboBox(GetControl('AFF_ETABLISSEMENT')) <> nil then THValComboBox(GetControl('AFF_ETABLISSEMENT')).visible := false;
	TFMUL(Ecran).SetDbliste('BTMULAFFAIRE_S1');
{$ENDIF}

End;

Procedure TOF_AFFAIRE_MUL.ChargeEcranStatutAffaire;
Begin

  //chargement du combo en avec le code statut... (AFFAIRE0)
  MAffaire0 := THValComboBox(GetControl('AFFAIRE0'));
  //
  if Maffaire0 <> nil then
     begin
     MAffaire0.OnChange := PositionneAffaire0;
     Maffaire0.plus := SetPlusAffaire0;
     MAffaire0.enabled := false;
     end;

  StatutAff.Value := Statut;
  //SetControlProperty('AFF_STATUTAFFAIRE','Value', Statut);

  //Si statut Affaire = contrat d'Intervention
	if Statut = 'INT' then   //contrats
  begin
    Ecran.Caption := TraduitGA('Interventions - Contrats');
    SetControlProperty('BInsert','Hint', TraduitGA('Nouveau contrat'));
    SetControlVisible ('BInsert',False);
    sPlus := sPlus + ' AND (CC_LIBRE IN ("BTP","CON"))';
    Statut := 'INT';
    Affaire0 := 'I';
    SetControlText ('TAFF_AFFAIRE', TraduitGa ('Contrat') ) ;
    ETATAFFAIRE.Value := 'ENC';
    ETATAFFAIRE.Plus  := sPlus;
    ETATAFFAIRE.Enabled := True;
    if Maffaire0 <> nil then Maffaire0.Value := Affaire0;
  End Else if Statut = 'APP' then  //appels
  begin
    if fonction = 'AFFECTATION' then
       Ecran.Caption := TraduitGA('Affectation par Lots des Appels')
    Else if fonction = 'REALISATION' then
    Begin
      Ecran.Caption := TraduitGA('Réalisation par lots des Appels');
      BOuvrir1 := TToolbarButton97(ecran.FindComponent('BOuvrir1'));
      BOuvrir1.OnClick := AffectationRessource;
      BOuvrir1.Visible := True;
      BOuvrir1.hint := 'Indiquer la réalisation des appels' ;
      SetControlVisible ('BOuvrir',False);
      SetControlVisible ('BSelectAll',True);
      ETATAFFAIRE.Text := 'AFF';
      ETATAFFAIRE.Enabled := false;
      SetControlproperty('FListe', 'Multiselection', true);
    End
    Else if fonction = 'TERMINE' then
    Begin
      Ecran.Caption := TraduitGA('Clôture par Lots des Appels');
      BOuvrir1 := TToolbarButton97(ecran.FindComponent('BOuvrir1'));
      BOuvrir1.OnClick := AffectationRessource;
      BOuvrir1.Visible := True;
      BOuvrir1.hint := 'clôturer les appels' ;
      SetControlVisible ('BOuvrir',False);
      SetControlVisible ('BSelectAll',True);
      THedit(GetCOntrol('XX_WHERE')).Text :=  ' AND (NOT AFF_ETATAFFAIRE IN ("ANN","CL1","FIN","TER","FAC"))';
      SetControlproperty('FListe', 'Multiselection', true);
    end
    Else
      Ecran.Caption := TraduitGA('Appels - Interventions');
    //
    SetControlProperty('BInsert','Hint', TraduitGA('Nouvel Appel')) ;
    SetControlVisible ('BInsert',False);
    sPlus := sPlus + ' AND (ISNUMERIC(CC_LIBRE)=1)';
    Statut := 'APP';
    Affaire0 := 'W';
    SetControlText ('TAFF_AFFAIRE', TraduitGa ('Appel') ) ;
    SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Appel');
    SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Critéres Appel');
    SetControlProperty('AFF_PRIOCONTRAT','Value','');
    ETATAFFAIRE.Plus := sPlus;
    if Maffaire0 <> nil then Maffaire0.Value := Affaire0;
  end else if Statut = 'AFF' then // affaires - chantiers
  begin
     Ecran.Caption := TraduitGA('Chantiers');
     SetControlProperty('BInsert','Hint', TraduitGA('Nouveau Chantier')) ;
     SetControlVisible ('BInsert1',False);
     sPlus := sPlus + ' AND CC_LIBRE="BTP"';
     Statut := 'AFF';
     Affaire0 := 'A';
     SetControlText ('TAFF_AFFAIRE', TraduitGa ('Chantier') ) ;
     ETATAFFAIRE.Plus := sPlus;
     Thedit(GetControl('AFF_AFFAIRE')).Text := '';
     if Maffaire0 <> nil then Maffaire0.Value := Affaire0;
  end else if statut = 'PRO' then   //Si statut Affaire = Appel d'offre
  begin
    Ecran.Caption := TraduitGA('Etudes Appel d''offres');
    SetControlProperty('BInsert','Hint', TraduitGA('Nouvel appel d''offre')) ;
    SetControlVisible ('BInsert',False);
    SetControlText ('TAFF_AFFAIRE', TraduitGa ('Appel d''offre') ) ;
    SetControlText ('AFF_AFFAIRE', '');
    Affaire0 := 'P';
    if Maffaire0 <> nil then
    begin
      Maffaire0.Value := Affaire0;
      Maffaire0.Text := Affaire0;
    end;
  end else
  begin
    SetControlVisible ('BInsert1',False);
//    sPlus := sPlus + ' AND CC_LIBRE="BTP" ';
    sPlus := sPlus + ' AND CC_LIBRE="BTP"';
    Statut := 'AFF';
    Affaire0 := 'A';
    SetControlText ('TAFF_AFFAIRE', TraduitGa ('Affaire') ) ;
    ETATAFFAIRE.Plus := sPlus;

    if Maffaire0 <> nil then
       begin
       Thedit(GetControl('AFF_AFFAIRE')).Text := '';
       Maffaire0.Value := Affaire0;
       Maffaire0.Text := Affaire0;
       MAffaire0.enabled := True;
       end;
  end;


end;

procedure TOF_AFFAIRE_MUL.FlisteDblClick(Sender: TObject);
var Affaire				: String;
		Tiers					: String;
    EtatAffaire		: String;
    Action 				: string;
    statut : string;
begin

   //SI pas d'enreg double click interdit ==> FV 05112008
	 if FListe.datasource.DataSet.RecordCount = 0  then exit;

   statut := StatutAff.Value;
   Affaire:=Fliste.datasource.dataset.FindField('AFF_AFFAIRE').AsString;
   if Fliste.datasource.dataset.FindField ('AFF_ETATAFFAIRE') <> nil then
   begin
	  EtatAffaire:=Fliste.datasource.dataset.FindField('AFF_ETATAFFAIRE').AsString;
   end else
   begin
	  EtatAffaire:='';
   end;

	 Tiers:=Fliste.datasource.dataset.FindField('AFF_TIERS').AsString;

   Action:=GetControlText('XXAction');

   if Action='ACTION=RECH' then
      begin
      TFMul(Ecran).Retour :=Affaire+';'+Tiers;
      TFMUL(Ecran).Close;
      end
   else
      begin
      if Pos(EtatAffaire,'TER;CLO')>0 then Action := 'ACTION=CONSULTATION';
      if pos('APP',StatutAff.value)>0 then
         AGLLanceFiche ('BTP','BTAPPELINT','','','CODEAPPEL:' + Affaire + ';ETAT:'+ EtatAffaire + ';ACTION=MODIFICATION')
      else
         AGLLanceFiche ('BTP',Nomfiche,'',Affaire,'STATUT:'+StatutAff.Value+';ETAT:'+ EtatAffaire +';'+Action);
         refreshdb;
//	       TtoolBarButton97(GetCOntrol('Bcherche')).Click;
      end;

end;

procedure TOF_AFFAIRE_MUL.VisuAffaireClick(Sender: TObject);
var Affaire				: String;
		Tiers					: String;
    EtatAffaire		: String;
    statut : string;
begin

  //SI pas d'enreg double click interdit ==> FV 05112008
  if FListe.datasource.DataSet.RecordCount = 0  then exit;

  statut := StatutAff.Value;
  Affaire:=Fliste.datasource.dataset.FindField('AFF_AFFAIRE').AsString;
  if Fliste.datasource.dataset.FindField ('AFF_ETATAFFAIRE') <> nil then
  begin
  	EtatAffaire:=Fliste.datasource.dataset.FindField('AFF_ETATAFFAIRE').AsString;
  end else
  begin
  	EtatAffaire:='';
  end;

  Tiers:=Fliste.datasource.dataset.FindField('AFF_TIERS').AsString;

  Action:=GetControlText('XXAction');

  if pos('APP',StatutAff.value)>0 then
  	AGLLanceFiche ('BTP','BTAPPELINT','','','CODEAPPEL:' + Affaire + ';ETAT:'+ EtatAffaire + ';ACTION=CONSULTATION')
  else
  	AGLLanceFiche ('BTP',Nomfiche,'',Affaire,'STATUT:'+StatutAff.Value+';ETAT:'+ EtatAffaire +';ACTION=CONSULTATION');
  refreshdb;

end;


procedure TOF_AFFAIRE_MUL.BInsert_OnClick(Sender: TObject);
var natpiece			: String;
    StatutAffaire	: String;
    EtatAffaire		: String;
    Tiers,stTiers	: String;
    stCTI 				: string;
    RetourAff     : string;
begin
  stCTI := '';
  StatutAffaire	:= GetControlText('AFF_STATUTAFFAIRE');
  EtatAffaire		:= 'ETAT:' + GetControlText('AFF_ETATAFFAIRE');

  Tiers 				:= 'AFF_TIERS:' + GetControlText('AFF_TIERS');

  if (StatutAffaire = 'PRO') then
     natpiece := 'ETU'
  else if (StatutAffaire = 'APP') then
     natpiece := 'DAP'
  else if (StatutAffaire = 'INT') then
     natpiece := 'AFF'
  else
     natpiece := 'DBT';
{$IFDEF CTI}
	stCTI := ';NUMTEL='+NumTel+ ';APPELANT='+Contact;
  stTiers := 'AFF_TIERS=' + GetControlText('AFF_TIERS');
{$ENDIF}
  if StatutAffaire = 'APP' then
  begin
  	stTiers := 'CODETIERS=' + GetControlText('AFF_TIERS');
    AGLLanceFiche('BTP','BTAPPELINT','','','ACTION=CREATION;' + stTiers+stCti);
  end else
  begin
  	retourAff := AGLLanceFiche('BTP',NomFiche,'','','ACTION=CREATION;STATUT:'+ StatutAffaire + ';' + Tiers + ';'+ EtatAffaire + ';NATURE:'+natpiece);
    if (GetParamSocSecur ('SO_BTREOUVNEWAFF',False)) and (retouraff <> '') then
    begin
    	StatutAffaire := ReadTokenSt(RetourAff);
    	AGLLanceFiche ('BTP',Nomfiche,'',retouraff,'ACTION=MODIFICATION;'+'STATUT:'+ StatutAffaire );
    end;
  end;

	// TtoolBarButton97(GetCOntrol('Bcherche')).Click;
  RefreshDB(retouraff);

end;



procedure TOF_AFFAIRE_MUL.ControleCritere(Critere, Champ, Valeur : string);
Var TobEtatsBloques : TOB;
		I								: Integer;
Begin


	// MCD 29/09/00 tout revu pour prendre en compte ce qui était fait dans le script
  // Xlequel peut permettre de passer ce code tiers
	// au prog de saisie pour forcer MAJ sur ce code
  // gm 02/09/02 , quand on veut les affaires d'un client, il les faut toutes
  // les  voir qu'elles soient administratives ou non
  if Champ ='AFF_TIERS' then
     begin
     SetControlText('XXlequel' ,Critere);
     SetControltext ('AFF_TIERS',valeur);
   	 SetControlProperty( 'AFF_TIERS', 'operateur', Egal);
     SetControlVisible ('AFF_TIERS',False);
     SetControlVisible ('TAFF_TIERS',False);
     SetControlVisible ('BEffaceaff1',False);
     TCheckBox(GetControl('AFF_ADMINISTRATIF')).State := cbGrayed;
     end;

  if champ ='ACTION' then SetControlText('XXAction',Critere);

  // Modif BTP
  if champ ='ETAT' then
     if Statut = 'APP' then
        Begin
		    EtatAffaire.text := StringReplace(Valeur, ',', ';', [rfReplaceAll]);
        Exit;
        End
     else
        Begin
	      EtatAffaire.text := Valeur;
        exit;
        end;

  // --
  // -- INT = Gestion des contrats
  // -- APP = Gestion des  Appels d'Interventions
  // -- PRO = Gestion des Appels d'Offre
  //sPlus := EtatAffaire.plus;
  if (champ = 'STATUT') then  Statut := Valeur;

  // Réduction de la multicombo des états de l'affaire en fonction des blocages affaire
  if (Champ = 'CTX') and (EtatAffaire <> nil) then
     begin
     TobEtatsBloques := nil;
     try
        TobEtatsBloques := TOBEtatsBloquesAffaire (copy (critere, 5, 3), '-', V_PGI.groupe);
        sPlus := EtatAffaire.plus;
        if (TobEtatsBloques <> nil) then
           for i:=0 to TobEtatsBloques.Detail.count - 1 do
               begin
               sPlus := sPlus  + ' AND CC_CODE<>"' + TobEtatsBloques.Detail[i].GetValue('ABA_ETATAFFAIRE') + '"';
               end;
           SetControlProperty('AFF_ETATAFFAIRE','Plus', sPlus);
     finally
        TobEtatsBloques.Free;
     end;
     end;

  if critere = 'APPOFFACCEPT' then
     begin
     SetControlVisible ('BInsert',False);
     SetControlVisible ('BSelectAll',True);
{$IFDEF BTP}
     SetControlProperty('AFF_STATUTAFFAIRE','Value','PRO');
{$ENDIF}
     Statut := 'PRO';
     SetControlProperty('Fliste','Multiselection',true);
     end;

  if critere = 'NOCHANGETIERS' then BEGIN SetControlEnabled('AFF_TIERS',False); bChangetiers := False; END;
  if critere = 'MODELEONLY' then SetControlProperty ('AFF_MODELE','Checked',True);
  if critere = 'ADMINGRAYED' then TCheckBox(GetControl('AFF_ADMINISTRATIF')).State := cbGrayed;
  if critere = 'NOFILTRE' then   Tfmul(Ecran).FiltreDisabled:=true;
  if critere = 'PASSIUN' then   bPasSiUn := true;
  if critere = 'ITDATESMAX' then   bItDatesMax := true;
  if critere = 'REDUIT' then
     if Not(GetParamsoc('SO_AfSaisAffInterdit')) then VUserInvite := True; //mcd 18/10/02 ajout test paramsoc

  if assigned(GetControl('AFF_MANDATAIRE')) then
  begin
    if Champ = 'MANDATAIRE' then
    begin
      if Valeur = 'X' then
        THDBCheckbox (GetControl('AFF_MANDATAIRE')).State := cbchecked
      else
        THDBCheckbox (GetControl('AFF_MANDATAIRE')).State := cbUnchecked;
    end;
  end;

  if champ = 'TOUS' then 	MAffaire0.enabled := true;

  if critere = 'NOCHANGESTATUT' then
     BEGIN
     ChangeStatut := False;
     top :=1;
     END;

  if critere = 'NOAFFETAT' then
		 AffEtat := false
  else
	   AffEtat := True;

	// gm 04/07/02 pour gerer le mul avec stat client
  if critere = 'PASMULTI'    then
     begin
     TFMul(Ecran).caption:=TraduitGa('Affaires (avec critères clients)');
     SetControlChecked('Multi',false);
     SetControlVisible('PCLIENTSTAT',true);
     TFMUL(Ecran).Dbliste:='AFMULAFFAIREMULTI';
     if TfMul(Ecran).Q <> NIL then TfMul(Ecran).Q.Liste  := 'AFMULAFFAIREMULTI';
     UpdateCaption(TFMul(Ecran)) ;
     end ;

  if critere = 'AFFECTATION' then
     begin
     Fonction := critere;
     BOuvrir1 := TToolbarButton97(ecran.FindComponent('BOuvrir1'));
     BOuvrir1.OnClick := AffectationRessource;
     SetControlVisible ('BOuvrir',False);
     BOuvrir1.Visible := True;
     SetControlVisible ('BSelectAll',True);
     ETATAFFAIRE.Value := 'ECO';
     ETATAFFAIRE.Enabled := false;
     SetControlproperty('FListe', 'Multiselection', true);
     end;

  if critere = 'REALISATION' then  Fonction := critere;

  if critere = 'TERMINE' then Fonction := critere;
{$IFDEF CTI}
  if champ = 'APPELANT' then Contact := Valeur;
  if champ = 'NUMTEL' then Numtel := Valeur;
{$ENDIF}
  BInsert := TToolbarButton97(ecran.FindComponent('BInsert'));
  BInsert.OnClick := BInsert_OnClick;
  if TToolBarButton97(GetControl('BVISUAFFAIRE'))<> nil then
  begin
  	TToolBarButton97(GetControl('BVISUAFFAIRE')).OnClick := VisuAffaireClick;
  end;
{$IFDEF LINE}
	if TTabSheet(GetControl('PCOMPLEMENT'))<> nil then TTabSheet(GetControl('PCOMPLEMENT')).tabVisible := false;
{$ENDIF}

End;

procedure TOF_AFFAIRE_MUL.OnUpdate;
{$IFDEF BTP}
var
  i : integer;
{$ENDIF}
Begin
// Gestion repositionnement auto sur l'affaire en cours si sortie rapide / bug par prg ( ou Eagl)

inherited;
if Not (VH_GC.CleAffaire.Co2Visible) then SetControlText('AFF_AFFAIRE2','');
if Not (VH_GC.CleAffaire.Co3Visible) then SetControlText('AFF_AFFAIRE3','');

{$IFDEF BTP}
if GetControlText('AFF_ETATAFFAIRE') = 'ACP' then
  begin
{$IFDEF EAGLCLIENT}
for i:=0 to TFMul(Ecran).FListe.ColCount-1 do
    begin
// AFAIREEAGL
    end;
{$ELSE}
  For i:=0 to TFMul(Ecran).FListe.Columns.Count-1 do
    Begin
    If (TFMul(Ecran).FListe.Columns[i].FieldName = 'AFF_REFERENCE') Then
      TFMul(Ecran).FListe.columns[i].visible:=False ;
    end;
{$ENDIF}
  end;
{$ENDIF}
End;

procedure TOF_AFFAIRE_MUL.TraiteRetour;
Var stRetour : string;
    Champ : string;
begin
stRetour := GetControlText ('RETOUR');
if stRetour <> '' then
   begin
   // On récupére dans l'ordre le client + Affaire 1,2,3
   Champ:=(Trim(ReadTokenSt(stRetour)));
   if Champ <> '' then SetControltext('AFF_TIERS',Champ);
   Champ:=(Trim(ReadTokenSt(stRetour)));
   if Champ <> '' then SetControltext('AFF_AFFAIRE1',Champ);
   Champ:=(Trim(ReadTokenSt(stRetour)));
   if (Champ <> '') And (VH_GC.CleAffaire.Co2Visible) then SetControltext('AFF_AFFAIRE2',Champ);
   Champ:=(Trim(ReadTokenSt(stRetour)));
   if (Champ <> '') And (VH_GC.CleAffaire.Co3Visible) then SetControltext('AFF_AFFAIRE3',Champ);
   end;
SetControlText('RETOUR', '');
end;


procedure TOF_AFFAIRE_MUL.OnLoad;
Var //RazAffRef : Boolean;
		//Affaire0 : string;
    Affaire, Affaire1  ,Affaire2 ,Affaire3,Avenant,Aff0 : string;
begin
inherited;
Inc (GNbLoads);

if VUserInvite and ( not V_PGI.Superviseur) and ( not V_PGI.Controleur) then TraiteInvite;

if GereSousAffaire then
   begin
     if (GetControl('AFFAIREREF1')<>NIL) then  // gm 25/08/03
     begin
      if (GetControlText('AFFAIREREF1')='') then
        SetControlText('AFF_AFFAIREREF','')
      else
        begin
        Aff0 := Affaire0;
        Affaire1 := GetControlText('AFFAIREREF1');
        Affaire2 := GetControlText('AFFAIREREF2');
        Affaire3 := GetControlText('AFFAIREREF3');
        Avenant := GetControlText('AFFAIREREF4');
        Affaire := CodeAffaireRegroupe (Aff0, Affaire1, Affaire2, Affaire3, Avenant, taModif, false, false, false);
        if not ExisteAffaire (Affaire, '') then SetControlText('AFF_AFFAIREREF',Trim(Copy(Affaire,1,15)));
        end;
     end;
   end;

// PL le 26/06/03 : en scot on agrandit l'intervalle quand le client est préselectionné et seulement
// la première fois
if (ctxScot In V_PGI.PGIContexte) and (GetControlText('AFF_TIERS') <> '') and (GNbLoads <= 1) then
  begin
    SetControlText ('AFF_DATEDEBUT', datetostr (idate1900));
    SetControlText ('AFF_DATEDEBUT_', datetostr (idate2099));
  end;

end;

procedure TOF_AFFAIRE_MUL.NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_:THEdit);
begin
Aff:=THEdit(GetControl('AFF_AFFAIRE'));
// MODIF LS
Aff0 := THEdit(GetControl('AFF_AFFAIRE0'));
// --
Aff1:=THEdit(GetControl('AFF_AFFAIRE1'));
Aff2:=THEdit(GetControl('AFF_AFFAIRE2'));
Aff3:=THEdit(GetControl('AFF_AFFAIRE3'));
Aff4:=THEdit(GetControl('AFF_AVENANT'));
Tiers:=THEdit(GetControl('AFF_TIERS'));
// affaire de référence pour recherche
Aff_:=THEdit(GetControl('AFF_AFFAIREREF'));
Aff1_:=THEdit(GetControl('AFFAIREREF1'));
Aff2_:=THEdit(GetControl('AFFAIREREF2'));
Aff3_:=THEdit(GetControl('AFFAIREREF3'));
Aff4_:=THEdit(GetControl('AFFAIREREF4'));
end;

procedure TOF_AFFAIRE_MUL.TraiteInvite;
var
lstzone,zone : string;
begin
  lstzone := 'AFF_RESPONSABLE;AFF_RESSOURCE1;AFF_RESSOURCE2;AFF_RESSOURCE3';
  while lstzone <> '' do
    begin
     zone := ReadTokenSt(Lstzone);
     if ThEdit(GetControl(zone))<> nil then
      begin
        SetControlText(zone,'');
        SetControlEnabled(zone,True);
      end;
    end;
  //ThDBGrid(GetControl('FListe')).OnDblClick := nil;
  TToolBarButton97(GetControl('BInsert')).enabled := False;
  TToolBarButton97(GetControl('BInsert1')).enabled := False;
  TToolBarButton97(GetControl('BVOIRAFFAIRE')).enabled := False;
end;

procedure TOF_AFFAIRE_MUL.StatutExit(Sender : TObject);
Begin

	if StatutAff.value='PRO' then
		 begin
     SetcontrolVisible('TAFF_ETATAFFAIRE',True);
		 SetcontrolVisible('AFF_ETATAFFAIRE',True);
   	 end
	else
		 begin
     SetcontrolVisible('TAFF_ETATAFFAIRE',False);
		 SetcontrolVisible('AFF_ETATAFFAIRE',False);
	   ETATAFFAIRE.value := '';
     end;
ChargeEcranStatutAffaire;
end;

Procedure TOF_AFFAIRE_MUL.AffectationRessource(Sender : TOBJect);
var Arg,Affaire      : String;
    TOBparam : Tob;
    TOB1Appel: Tob;
    TOBDAppel: Tob;
    F 			 : TFMul;
    i 			 : integer;
    QQ			 : TQuery ;
{$IFDEF EAGLCLIENT}
    L 			 : THGrid;
{$ELSE}
    Ext 		 : String;
    L 			 : THDBGrid;
{$ENDIF}

begin
  Inherited ;

  Arg := '';
  Ext := '';

	F:=TFMul(Ecran);

	if(F.FListe.NbSelected=0)and(not F.FListe.AllSelected) then
  	 begin
	   PGIInfo('Aucun élément sélectionné','');
  	 exit;
   	 end;

  if Fonction = 'AFFECTATION' then
     Begin
  	 TOBParam := TOB.Create ('AFFECT ',nil,-1);
  	 TOBParam.AddChampSupValeur ('RESSOURCE','');
		 TOBParam.AddChampSupValeur ('RETOUR','-');
     TheTOB := TOBparam;
     AGLLanceFiche ('BTP','BTAFFECTATION','','','');
     TheTOB := nil;
     if TOBparam.GetValue('RETOUR')='-' then
	    	Begin
  	    TobParam.free;
        exit ;
        end;
     end;

	if PGIAsk('Confirmez-vous le traitement ?','') <> mrYes then
     Begin
     TobParam.free;
  	 exit ;
     end;

  TOBDAppel := tob.create('LES APPELS', nil, -1);

	L:= F.FListe;
  SourisSablier;

  try
	if L.AllSelected then
  	 begin
  	 QQ:=F.Q;
  	 QQ.First;
	   while Not QQ.EOF do
     Begin
     	 Affaire := QQ.FindField('AFF_AFFAIRE').AsString;
       TOB1Appel := TOB.Create ('AFFAIRE',TOBDappel,-1);
       TOB1Appel.putValue('AFF_AFFAIRE',Affaire);
       if TOB1Appel.LoadDb (false) then
          begin
          if Fonction = 'AFFECTATION' then
             Begin
          	 TOB1Appel.PutValue('AFF_RESPONSABLE',TOBParam.getValue ('RESSOURCE'));
	           TOB1Appel.putValue('AFF_ETATAFFAIRE','AFF');
             End
          else if Fonction = 'REALISATION' then
             Begin
	           TOB1Appel.putValue('AFF_ETATAFFAIRE','REA');
	           TOB1Appel.putValue('AFF_DATEFIN', now);
             end
          else if Fonction = 'TERMINE' then
             Begin
	           TOB1Appel.putValue('AFF_ETATAFFAIRE','CL1');
	           TOB1Appel.putValue('AFF_DATEFIN', now);
             end;
          end
       else
          TOB1Appel.free;
     	 QQ.Next;
   	 end;
	   L.AllSelected:=False;
  	 end
  else
     begin
     for i:=0 to L.NbSelected-1 do
         begin
	       L.GotoLeBookmark(i);
         Affaire := TFMul(F).Fliste.datasource.dataset.FindField('AFF_AFFAIRE').AsString;
         TOB1Appel := TOB.Create ('AFFAIRE',TOBDappel,-1);
         TOB1Appel.putValue('AFF_AFFAIRE',Affaire);
         if TOB1Appel.LoadDb (false) then
            Begin
            if Fonction = 'AFFECTATION' then
         	 	   begin
	             TOB1Appel.PutValue('AFF_RESPONSABLE',TOBParam.getValue ('RESSOURCE'));
             	 TOB1Appel.putValue('AFF_ETATAFFAIRE','AFF');
            	 end
            else if Fonction = 'REALISATION' then
               begin
   	           TOB1Appel.putValue('AFF_ETATAFFAIRE','REA');
	             TOB1Appel.putValue('AFF_DATEFIN', now);
               end
            else if Fonction = 'TERMINE' then
               Begin
               TOB1Appel.putValue('AFF_ETATAFFAIRE','CL1');
               TOB1Appel.putValue('AFF_DATEFIN', now);
               end;
            end
         else
            TOB1Appel.free;
      	 end;
	   		 L.ClearSelected;
	   end;
  if TOBDappel.detail.count > 0 then TOBDappel.UpdateDB (true);
	finally
  TOBDappel.free;
  TobParam.free;
	SourisNormale;
  F.BChercheClick(ecran);
  end;

end;

//******************************************************************************
//************************ TOF Multicritères apporteur *************************
//******************************************************************************
procedure TOF_APPORTEUR_MUL.OnArgument(stArgument : String );

Begin
Inherited;
if ctxScot In V_PGI.PGIContexte then
    BEGIN
    SetcontrolVisible('TGCL_TYPECOMMERCIAL',False);
    SetcontrolVisible('GCL_TYPECOMMERCIAL',False);
    SetcontrolVisible('TGCL_ZONECOM',False);
    SetcontrolVisible('GCL_ZONECOM',False);
    End;

// Type commercial forcé à apporteur gm25/08/03
SetControlText('GCL_TYPECOMMERCIAL', 'APP');
END;


//******************************************************************************
//************* Fonction appellées depuis le Scripts ***************************
//******************************************************************************
procedure MajMulAffaire( parms: array of variant; nb: integer ) ;
var  F : TForm ;
     LaTof : TOF;
begin
F:=TForm(Longint(Parms[0])) ;
if (F is TFMul) then Latof:=TFMul(F).Latof else exit;
if (LaTof is TOF_AFFAIRE_MUL) then TOF_AFFAIRE_MUL(LaTof).TraiteRetour else exit;
end;

Procedure AFLanceFiche_MulEAffaire;
begin
AGLLanceFiche ('AFF','AFEAFFAIRE_MUL','','','');
end;
Procedure AFLanceFiche_MulAffaire(Range,Argument:string);
begin
AGLLanceFiche ('AFF','AFFAIRE_MUL',Range,'',Argument);
end;
Function AFLanceFiche_AffaireREch(Range,Argument:string):variant;
begin
result:=AGLLanceFiche ('AFF','AFFAIRERECH_MUL',Range,'',Argument);
end;
Procedure AFLanceFiche_MulAffCompta;
begin
AGLLanceFiche ('AFF','AFFAIRE_MUL_COMPT','','','');
end;
Procedure AFLanceFiche_Mul_Apporteur;
begin
AGLLanceFiche ('AFF','AFAPPORTEUR_Mul','','','');
end;
Procedure AFLanceFiche_MulAvenantAff(Range,Argument:string);
begin
AGLLanceFiche ('AFF','AFFAIREAVT_MUL',Range,'',Argument);
end;
Procedure AFLanceFiche_IntervAff;
begin
AGLLanceFiche ('AFF','AFINTERVENANTSAFF','','','');
end;



procedure TOF_AFFAIRE_MUL.PositionneAffaire0(Sender: Tobject);
var splus : string;
begin

	THEdit(GetControl('AFF_AFFAIRE0')).Text := mAffaire0.Value;

	if Length(THEdit(GetControl('AFF_AFFAIRE')).Text) <= 1 then
     begin
  	 THEdit(GetControl('AFF_AFFAIRE')).Text := '';
     if maffaire0.value = 'I' then
        begin
        SetControlProperty('AFF_STATUTAFFAIRE','Value','INT');
        sPlus := sPlus + ' AND (CC_LIBRE IN ("BTP","CON"))' ;
        SetControlProperty('AFF_ETATAFFAIRE','Value','ENC');
        end
     else if maffaire0.value = 'W' then
        begin
        SetControlProperty('AFF_STATUTAFFAIRE','Value','APP');
        sPlus := sPlus + ' AND (ISNUMERIC(CC_LIBRE)=1)';
        SetControlProperty('AFF_ETATAFFAIRE','Value','AFF');
        end
     else if maffaire0.value = 'P' then
        begin
        SetControlProperty('AFF_STATUTAFFAIRE','Value','PRO');
        sPlus := sPlus + ' AND (CC_LIBRE="BTP")';
        SetControlProperty('AFF_ETATAFFAIRE','Value','ENC');
        end
     else if maffaire0.value = 'A' then
        begin
      	SetControlProperty('AFF_STATUTAFFAIRE','Value','AFF');
        sPlus := sPlus + ' AND CC_LIBRE="BTP"';
        SetControlProperty('AFF_ETATAFFAIRE','Value','');
        end;
     SetControlProperty ('AFF_ETATAFFAIRE','Plus', sPlus);
//     THValComboBox(GetControl('AFF_ETATAFFAIRE')).ReLoad ;
     end;

end;

procedure TOF_AFFAIRE_MUL.BRechResponsable(Sender: TObject);
begin

  GetRessourceRecherche(TResponsable,'ARS_TYPERESSOURCE="SAL"', '', '');
  IF TResponsable.text <> '' then
    SetControlproperty('LIBRESSOURCE', 'Visible', True)
  else
    SetControlproperty('LIBRESSOURCE', 'Visible', False)

end;

Initialization
registerclasses([TOF_AFFAIRE_MUL]);
registerclasses([TOF_APPORTEUR_MUL]);
RegisterAglProc( 'MajMulAffaire', TRUE , 0, MajMulAffaire);
end.
