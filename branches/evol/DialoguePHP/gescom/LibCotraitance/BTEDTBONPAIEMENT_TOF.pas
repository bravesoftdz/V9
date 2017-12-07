{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 24/06/2011
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTEDTBONPAIEMENT ()
Mots clefs ... : TOF;BTEDTBONPAIEMENT
*****************************************************************}
Unit BTEDTBONPAIEMENT_TOF;

Interface

Uses  StdCtrls,
      Controls,
      Classes,
      forms,
      sysutils,
      ComCtrls,
      HCtrls,
      HEnt1,
      HMsgBox,
      UTOF,
      UTOB,
{$IFDEF EAGLCLIENT}
      MaineAGL,
      emul,
{$ELSE}
    {$IFNDEF ERADIO}
      Fe_Main,
      uPDFBatch,
    {$ENDIF !ERADIO}
    {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
      HDB,
      Mul,
      UtilGc,
{$ENDIF}
			hPDFPrev,
      hPDFViewer,
      EntGC,
      utofAfBaseCodeAffaire,
      HTB97,
      Hpanel,
      uEntCommun,
      UtilTOBPiece,
      uRecupSQLModele,
      UtilsEtat,
      paramsoc,
      Ent1;

Type

  TOF_BTEDTBONPAIEMENT = Class (TOF_AFBASECODEAFFAIRE)
  public
    procedure OnArgument(stArgument : String ) ; override ;
    procedure OnClose; override;
    procedure NomsChampsAffaire( Var Aff,Aff0,Aff1,Aff2,Aff3,Aff4,Aff_,Aff0_,Aff1_,Aff2_,Aff3_,Aff4_,Tiers,Tiers_ : THEdit ) ; override ;
  private
    TobPIECE      : TOB;
    TobAffaire    : TOB;
    TobPiecTrait  : TOB;
    TobCalcul     : TOB;
    TobMandataire : TOB;
    TobTiersFact  : TOB;
    TobSociete    : TOB;
    //
    Ok_Recap      : Boolean;
    Ok_Multiple   : Boolean;
    Ok_LastEdit   : Boolean;
    //
    BOuvrir       : TToolbarButton97;
    BParamEtat    : TToolBarButton97;
    BParamEtat1   : TToolBarButton97;
    //
    ChkApercu     : TCheckBox;
    ChkReduire    : TCheckBox;
    ChkCouleur    : TCheckBox;
    ChkEditjust   : TCheckBox;
    //
    Fliste	      : THDbGrid;
    FETAT         : THValComboBox;
    FETAT1        : THValComboBox;
    //
    TheType       : String;
    TheNature     : String;
    TheTitre      : String;
    TheModele     : String;
    //
    TheType1      : String;
    TheNature1    : String;
    TheTitre1     : String;
    TheModele1    : String;
    //
    Cledoc        : r_cledoc;
    //
    OptionEdition : TOptionEdition;
    OptionEdition1: TOptionEdition;
    //
    procedure ChargeCotraitantEdition(TobLigEdt,TOBCalc: TOB);
    Procedure ChargeEnteteEdition(TOBEE, TobEdition: TOB);
    procedure ChargeEtatEdition;
    procedure Chargementlignefrais;
    procedure ChargementMandataire(CodeAffaire : String);
    procedure ChargeMandataireEdition(TobLigEdt, Tobcalc : TOB);
    procedure ChargementSociete;
    procedure ChargementTiersFacture(TiersFacture: string);
    Procedure ChargeTob(Sender : TOBJect);
    procedure ChargeTobCalcul;
    procedure ChargeTobPrincipale(Cledoc: R_Cledoc);
    procedure ControleChamp(Champ, Valeur: String);
    procedure CreationLigneMandataire;
    procedure EditionMultiple(TOBEE : TOB);
    procedure EditionSimple(TOBEE : TOB);
    procedure GenereRecap;
    procedure InitTob;
    procedure LanceEdition;
    procedure OnChangeEtat(Sender : TObject);
    procedure OnChangeEtat1(Sender: Tobject);
    procedure OnClickApercu(Sender: Tobject);
    procedure OnClickReduire(Sender: Tobject);
    procedure ParamEtat(Sender : TOBJect);
    procedure ParamEtat1(Sender: TOBJect);
    Procedure ReleaseTob;
  end;

implementation

uses TntStdCtrls, BTPUtil;

procedure TOF_BTEDTBONPAIEMENT.OnArgument(stArgument : String );
var Critere  : string;
    ValMul   : string;
    ChampMul : string;
    x        : integer;
Begin
  inherited;

  TheType   := 'E';
  TheNature := 'BSO';
  TheTitre  := 'Editionn documents cotraitant';
  TheModele := '';

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
  until Critere='';

  SetControlText('XX_WHERE', ' AND AFF_MANDATAIRE="X"');

  if Assigned(GetControl('Bouvrir')) then
  begin
    BOuvrir := TToolbarButton97(ecran.FindComponent('BOuvrir'));
    BOuvrir.OnClick := ChargeTob;
  end;

  if Assigned(GetControl('BParamEtat')) then
  begin
    BParamEtat := TToolbarButton97(ecran.FindComponent('BParamEtat'));
    BParamEtat.OnClick := ParamEtat;
  end;

  if Assigned(GetControl('BParamEtat1')) then
  begin
    BParamEtat1 := TToolbarButton97(ecran.FindComponent('BParamEtat1'));
    BParamEtat1.OnClick := ParamEtat1;
  end;

  if Assigned(GetControl('Fliste')) then
    Fliste := THDbGrid(ecran.FindComponent('Fliste'));

  if Assigned(GetControl('fApercu'))  then
  begin
    ChkApercu := TCheckBox(Ecran.FindComponent('fApercu'));
    ChkApercu.OnClick := OnClickApercu;
    ChkApercu.Checked :=True;
  end;

  if Assigned(GetControl('FReduire')) then
  begin
    ChkReduire := TCheckBox(Ecran.FindComponent('fReduire'));
    ChkReduire.OnClick := OnClickReduire;
    ChkReduire.Checked:=False;
  end;

  if Assigned(GetControl('fCouleur')) then
  begin
    ChkCouleur  := TCheckBox(Ecran.FindComponent('fCouleur'));
    ChkCouleur.Checked:=False;
  end;

  if Assigned(GetControl('fCouleur')) then
  begin
    ChkEditJust := TCheckBox(Ecran.FindComponent('fEDITJUST'));
    ChkEditJust.Checked:=False;
  end;

  if Assigned(GetControl('fEtat'))    then
  begin
     FEtat := ThValComboBox(ecran.FindComponent('FEtat'));
     FETAT.OnChange := OnChangeEtat;
     FEtat.Items.Clear;
     FEtat.Values.Clear;
  end;

  if Assigned(GetControl('fEtat1'))    then
  begin
     FEtat1 := ThValComboBox(ecran.FindComponent('FEtat1'));
     FETAT1.OnChange := OnChangeEtat1;
     FEtat1.Items.Clear;
     FEtat1.Values.Clear;
  end;

  //chargement de l'état en fonction du type de paiement : si direct Attestation, si regroupement eclatement
  ChargeEtatEdition;
            
end;

Procedure TOF_BTEDTBONPAIEMENT.ControleChamp(Champ : String;Valeur : String);
Begin

end;

procedure TOF_BTEDTBONPAIEMENT.ChargeEtatEdition;
var Idef : Integer;
begin

  TheType   := 'E';
  TheNature := 'BSO';
  TheModele := '';
  TheTitre  := 'Edition Lettre d''Eclatement';

  OptionEdition := TOptionEdition.Create(TheType, TheNature, TheModele, TheTitre, '', ChkApercu.Checked, ChkReduire.Checked, True, False, False, TPageControl(Ecran.FindComponent('Pages')), fEtat);

  OptionEdition.first := True;
  OptionEdition.ChargeListeEtat(fEtat,Idef);

  TheModele := FETAT.values[fetat.itemindex];

  TheType1   := 'E';
  TheNature1 := 'BST';
  TheModele1 := '';
  TheTitre1  := 'Edition Attestation Paiement Direct';

  OptionEdition1 := TOptionEdition.Create(TheType1, TheNature1, TheModele1, TheTitre1, '', ChkApercu.Checked, ChkReduire.Checked, True, False, False, TPageControl(Ecran.FindComponent('Pages')), fEtat1);

  OptionEdition1.first := True;
  OptionEdition1.ChargeListeEtat(fEtat1,Idef);

  TheModele1 := FETAT1.values[fetat1.itemindex];

end;

procedure TOF_BTEDTBONPAIEMENT.InitTob;
Begin

  TobPIECE      := TOB.Create('LES PIECES',nil, -1);
  TobAFFAIRE    := TOB.Create('LES AFFAIRES',nil, -1);
  TobPiecTrait  := TOB.Create('PIECETRAIT',nil, -1);
  //
  TobTiersFact  := TOB.Create('TIERSFACT', nil, -1);
  TobMandataire := TOB.Create('MANDATAIRE', nil, -1);
  TobSociete    := TOB.Create('SOCIETE', nil, -1);
  //

end;

//appel de l'écran de modificatuion/création d'état
procedure TOF_BTEDTBONPAIEMENT.ParamEtat(Sender : TOBJect);
begin

  OptionEdition.Appel_Generateur;

end;

procedure TOF_BTEDTBONPAIEMENT.ParamEtat1(Sender : TOBJect);
begin

  OptionEdition1.Appel_Generateur;

end;

procedure TOF_BTEDTBONPAIEMENT.ChargeTob(Sender : TOBJect);
var iInd        : Integer;
begin

  InitTob;

  Ok_Multiple := False;
  Ok_LastEdit := False;

  if not FListe.AllSelected then
  begin
    if FListe.NbSelected = 0 then
      PGIInfo('Selectionner au moins une ligne SVP !', 'Edition des bons de payement')
    else
    begin
      for iInd := 0 to FListe.NbSelected -1 do
      begin
        FListe.GotoLeBookMark(iInd);
        cledoc.NaturePiece  := Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').AsString;
        cledoc.NumeroPiece  := Fliste.datasource.dataset.FindField('GP_NUMERO').AsInteger;
        cledoc.Souche       := Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
        cledoc.Indice       := Fliste.datasource.dataset.FindField('GP_INDICEG').AsInteger;
        //Chargement des Tob principales nécessaires pour l'édition
        ChargeTobPrincipale(Cledoc);

        ChargeTobCalcul;
        //
        if (iInd = 0) and (FListe.NbSelected > 1) then
        begin
          StartPDFBatch;
          Ok_Multiple := True;
        end;
        if iInd = Fliste.nbSelected - 1 then Ok_LastEdit := True;
        LanceEdition;
        if iInd = Fliste.nbSelected - 1 then
        begin
          if Ok_Multiple then
          begin
            if Chkapercu.Checked then
              PreviewPDFFile('Edition Cotraitance',GetMultiPDFPath,True)
            else
              PrintPdf(GetMultiPDFPath, '', '');
          end;
        end
        else
        begin
        end;
      end;
    end;
  end;

  FListe.ClearSelected;

  TToolbarButton97(ecran.FindComponent('BOuvrir')).Down := False;
  FListe.AllSelected := False;

  ReleaseTob;

end;

Procedure TOF_BTEDTBONPAIEMENT.ChargeTobPrincipale(Cledoc : R_Cledoc);
Var StSQL : string;
    QQ    : TQuery;
begin

  //chargement de la pièce...
  StSQL := 'SELECT * FROM PIECE WHERE ' + WherePiece(Cledoc, ttdPiece,True);
  QQ:=OpenSQL(StSQL, True, 1, '', True);
  if not QQ.Eof then
  begin
    TobPiece.SelectDB('', QQ);
    //
    ChargementTiersFacture(TobPIECE.GetString('GP_TIERSFACTURE'));
    //
    ChargementMandataire(TobPIECE.GetString('GP_AFFAIRE'));
    //
    StSQL := 'Select * From PIECETRAIT Where ' + WherePiece(cledoc, ttdPieceTrait, True);
    TobPiecTrait.LoadDetailFromSQL(StSQl);
  end;

  ferme(QQ);

end;

procedure TOF_BTEDTBONPAIEMENT.ChargeTobCalcul;
begin

  if not Assigned(TobPiecTrait) then Exit;

  TobCalcul := TOB.Create('CALCUL', nil, -1);
  TobCalcul.Dupliquer(TobPiecTrait, True, true);

  TobCalcul.AddChampSupValeur('TODAY', Now);

  CreationLigneMandataire;

  ChargementligneFrais;

end;

Procedure TOF_BTEDTBONPAIEMENT.ChargementMandataire(CodeAffaire : string);
var StSQL : string;
    QQ    : TQuery;
    TOBBQE: TOB;
begin

  //lecture de la fiche affaire pour chargement mandataire
  StSql := 'Select AFF_BQMANDATAIRE, AFF_CODEBQ, AFF_TIERS, AFF_ETABLISSEMENT, AFF_REFEXTERNE, AFF_TYPEPAIE FROM AFFAIRE WHERE AFF_AFFAIRE="' + CodeAffaire +'"';
  QQ := OpenSQL(StSql, True);
  if QQ.eof then
  begin
    PGIInfo('erreur de chargement de l''affaire :' + CodeAffaire + ' du document !');
    Exit;
  end;

  //chargement des info mandataires associées à l'affaire...
  TobMandataire.AddChampSupValeur('MANDATAIRE', QQ.FindField('AFF_ETABLISSEMENT').AsString);

  TobMandataire.AddChampSupValeur('REGROUPEMENT', QQ.FindField('AFF_REFEXTERNE').AsString);
  TobMandataire.AddChampSupValeur('TYPEPAIE', QQ.FindField('AFF_TYPEPAIE').AsString);
  TobMandataire.AddChampSupValeur('CODEBQ', QQ.FindField('AFF_CODEBQ').AsString);
  TobMandataire.AddChampSupValeur('BQMANDATAIRE', QQ.FindField('AFF_BQMANDATAIRE').AsString);
  //
  TobMandataire.AddChampSupValeur('NOMMANDAT', '');
  TobMandataire.AddChampSupValeur('ADRESSE1', '');
  TobMandataire.AddChampSupValeur('ADRESSE2', '');
  TobMandataire.AddChampSupValeur('ADRESSE3', '');
  TobMandataire.AddChampSupValeur('CODEPOSTAL', '');
  TobMandataire.AddChampSupValeur('VILLE', '');
  TobMandataire.AddChampSupValeur('TELEPHONE', '');
  TobMandataire.AddChampSupValeur('FAX', '');
  TobMandataire.AddChampSupValeur('EMAIL', '');
  TobMandataire.AddChampSupValeur('STATUTMANDAT', '');
  TobMandataire.AddChampSupValeur('SIRETMANDAT', '');
  TobMandataire.AddChampSupValeur('APEMANDAT', '');

  //chargement des infos société
  ChargementSociete;

  Ferme(QQ);

  //lecture de l'établissement
    StSql := 'SELECT * FROM ETABLISS WHERE ET_ETABLISSEMENT="' + TobMandataire.GetString('MANDATAIRE') +'"';
    QQ := OpenSQL(StSql, True);
    if not QQ.eof then
    begin
      //chargement des infos société
      TobMandataire.PutValue('NOMMANDAT',   QQ.FindField('ET_LIBELLE').AsString);
      TobMandataire.PutValue('ADRESSE1',    QQ.FindField('ET_ADRESSE1').AsString);
      TobMandataire.PutValue('ADRESSE2',    QQ.FindField('ET_ADRESSE2').AsString);
      TobMandataire.PutValue('ADRESSE3',    QQ.FindField('ET_ADRESSE3').AsString);
      TobMandataire.PutValue('CODEPOSTAL',  QQ.FindField('ET_CODEPOSTAL').AsString);
      TobMandataire.PutValue('VILLE',       QQ.FindField('ET_VILLE').AsString);
      TobMandataire.PutValue('TELEPHONE',   QQ.FindField('ET_TELEPHONE').AsString);
      TobMandataire.PutValue('FAX',         QQ.FindField('ET_FAX').AsString);
      TobMandataire.PutValue('EMAIL',       QQ.FindField('ET_EMAIL').AsString);
      TobMandataire.PutValue('STATUTMANDAT',QQ.FindField('ET_JURIDIQUE').AsString);
      TobMandataire.PutValue('SIRETMANDAT', QQ.FindField('ET_SIRET').AsString);
      TobMandataire.PutValue('APEMANDAT',   QQ.FindField('ET_APE').AsString);
  end
  else
  begin
    TobMandataire.PutValue('MANDATAIRE',  GetParamSocSecur('SO_SOCIETE', ''));
    TobMandataire.PutValue('NOMMANDAT',   GetParamSocSecur('SO_LIBELLE', ''));
  end;

  TOBBQE := Tob.Create('BANQUECP', nil, -1);

  //chargement du numero de compte regroupement...
  LectBanque(TOBBQE, TobMandataire.GetString('CODEBQ'));
  TobMandataire.AddChampSupValeur('COMPTE_REGROUPEMENT', TOBBQE.GetString('BQ_NUMEROCOMPTE'));
  TobMandataire.AddChampSupValeur('DOMICILIATION_REGROUPEMENT', TOBBQE.GetString('BQ_DOMICILIATION'));
  TobMandataire.AddChampSupValeur('VILLEBQ_REGROUPEMENT', TOBBQE.GetString('BQ_VILLE'));

  //chargement du compte bancaire du mandataire...
  LectBanque(TOBBQE, TobMandataire.GetString('BQMANDATAIRE'));

  TobMandataire.AddChampSupValeur('DESBANQUE', TOBBQE.GetString('BQ_LIBELLE'));
  TobMandataire.AddChampSupValeur('ETABBQ', TOBBQE.GetString('BQ_ETABBQ'));
  TobMandataire.AddChampSupValeur('GUICHET',TOBBQE.GetString('BQ_GUICHET'));
  TobMandataire.AddChampSupValeur('COMPTE_COTRAITE', TOBBQE.GetString('BQ_NUMEROCOMPTE'));
  TobMandataire.AddChampSupValeur('CLERIB', TOBBQE.GetString('BQ_CLERIB'));
  TobMandataire.AddChampSupValeur('DOMICILIATION', TOBBQE.GetString('BQ_DOMICILIATION'));
  TobMandataire.AddChampSupValeur('VILLEBQ', TOBBQE.GetString('BQ_VILLE'));
  TobMandataire.AddChampSupValeur('IBAN', TOBBQE.GetString('BQ_IBAN'));

  FreeAndNil(TOBBQE);

end;

Procedure TOF_BTEDTBONPAIEMENT.ChargementSociete;
begin

  TobSociete.AddChampSupValeur('SOCIETE',     GetParamSocSecur('SO_SOCIETE', ''));
  TobSociete.AddChampSupValeur('RAISONSOC',   GetParamSocSecur('SO_LIBELLE', ''));
  TobSociete.AddChampSupValeur('ADRSOC1',     GetParamSocSecur('SO_ADRESSE1', ''));
  TobSociete.AddChampSupValeur('ADRSOC2',     GetParamSocSecur('SO_ADRESSE2',''));
  TobSociete.AddChampSupValeur('ADRSOC3',     GetParamSocSecur('SO_ADRESSE3',''));
  TobSociete.AddChampSupValeur('CPSOC',       GetParamSocSecur('SO_CODEPOSTAL',''));
  TobSociete.AddChampSupValeur('VILLESOC',    GetParamSocSecur('SO_VILLE', ''));
  TobSociete.AddChampSupValeur('TELSOC',      GetParamSocSecur('SO_TELEPHONE', ''));
  TobSociete.AddChampSupValeur('FAXSOC',      GetParamSocSecur('SO_FAX', ''));
  TobSociete.AddChampSupValeur('EMAILSOC',    GetParamSocSecur('SO_EMAIL', ''));
  TobSociete.AddChampSupValeur('JURIDIQUE',   GetParamSocSecur('SO_NATUREJURIDIQUE', ''));
  TobSociete.AddChampSupValeur('CAPITAL',     GetParamSocSecur('SO_CAPITAL', ''));
  TobSociete.AddChampSupValeur('SIRET',       GetParamSocSecur('SO_SIRET', ''));
  TobSociete.AddChampSupValeur('APE',         GetParamSocSecur('SO_APE', ''));
  TobSociete.AddChampSupValeur('RC',          GetParamSocSecur('SO_RC', ''));
  TobSociete.AddChampSupValeur('RVA',         GetParamSocSecur('SO_RVA', ''));

end;


Procedure TOF_BTEDTBONPAIEMENT.ChargementTiersFacture(TiersFacture : string);
var StSQL         : string;
    QQ            : TQuery;
begin

  //Recherche adresse tiers de la pièce facturé...
  StSql := 'Select * FROM PIECEADRESSE WHERE GPA_TYPEPIECEADR="001" AND ' + WherePiece(CleDoc, ttdPieceAdr, true);
  QQ := OpenSQL(StSql, True);
  if QQ.eof then
    PGIInfo('erreur de chargement de l''adresse du client Facturé :' + TiersFacture + ' du document !')
  else
  begin
    TobTiersFact.AddChampSupValeur('TIERSFACTURE', TiersFacture);
    TobTiersFact.AddChampSupValeur('NOMTIERS',    QQ.FindField('GPA_LIBELLE').AsString);
    TobTiersFact.AddChampSupValeur('ADRTIERS1',   QQ.FindField('GPA_ADRESSE1').AsString);
    TobTiersFact.AddChampSupValeur('ADRTIERS2',   QQ.FindField('GPA_ADRESSE2').AsString);
    TobTiersFact.AddChampSupValeur('ADRTIERS3',   QQ.FindField('GPA_ADRESSE3').AsString);
    TobTiersFact.AddChampSupValeur('CPTIERS',     QQ.FindField('GPA_CODEPOSTAL').AsString);
    TobTiersFact.AddChampSupValeur('VILLETIERS',  QQ.FindField('GPA_VILLE').AsString);
  end;
  Ferme(QQ);

end;

procedure TOF_BTEDTBONPAIEMENT.CreationLigneMandataire;
var TOBXX       : TOB;
begin

  //Création de la ligne mandataire
  TOBXX := TobCalcul.FindFirst(['BPE_FOURNISSEUR'], [''], false);

  if TOBXX <> nil then FreeAndNil(TOBXX);

  TOBXX := TOB.create('', TobCalcul, 0);

  TobXX.AddChampSupValeur('NATUREPIECEG', TobPIECE.GetString('GP_NATUREPIECEG'));
  TobXX.AddChampSupValeur('SOUCHE',  TobPIECE.GetString('GP_SOUCHE'));
  TobXX.AddChampSupValeur('INDICEG', TobPIECE.GetString('GP_INDICEG'));
  TobXX.AddChampSupValeur('AFFAIRE', TobPIECE.GetString('GP_AFFAIRE'));
  TobXX.AddChampSupValeur('BPE_FOURNISSEUR', '');
  TobXX.AddChampSupValeur('MANDATAIRE', TobMandataire.GetString('MANDATAIRE'));
  TobXX.AddChampSupValeur('NOMMANDAT', TobMandataire.GetString('NOMMANDAT'));

  TobXX.AddChampSupValeur('ETABBQ', TobMandataire.GetString('ETABBQ'));
  TobXX.AddChampSupValeur('GUICHET', TobMandataire.GetString('GUICHET'));
  TobXX.AddChampSupValeur('COMPTE_COTRAITE', TobMandataire.GetString('COMPTE_COTRAITE'));
  TobXX.AddChampSupValeur('CLERIB', TobMandataire.GetString('CLERIB'));
  TobXX.AddChampSupValeur('DOMICILIATION', TobMandataire.GetString('DOMICILIATION'));
  TobXX.AddChampSupValeur('VILLEBQ', TobMandataire.GetString('VILLEBQ'));

  TobXX.AddChampSupValeur('TOTALFRAIS', 0);
  TobXX.AddChampSupValeur('MTDEMANDE', 0);
  TobXX.AddChampSupValeur('MONTANTREGLE', 0);

end;

Procedure TOF_BTEDTBONPAIEMENT.Chargementlignefrais;
var iInd      : integer;
    jInd      : Integer;
    StSql     : string;
    CodeFrs   : String;
    Affaire   : String;
    NumRib    : integer;
    QQ        : TQuery;
    //
    CoefFrais : Double;
    //
    TotDemande: Double;
    TotFrais  : Double;
    TotRegle  : Double;
    //
    LigFrais  : Double;
    LigRegle  : Double;
    //
    MtDemande : Double;
    MtFrais   : Double;
    //
    TOBBQE    : TOB;
begin

  Affaire    := TobPIECE.GetString('GP_AFFAIRE');
  //
  TotDemande := TobPIECE.GetDouble('GP_TOTALTTCDEV');
  TotFrais   := 0;
  TotRegle   := 0;

  //mise en place de la Tob de calcul des montants réglés et à régler par cotraitant et mandataires
  for iInd := 0 to TobCalcul.Detail.Count -1 do
  begin
    CodeFrs := TobCalcul.detail[iInd].GetString('BPE_FOURNISSEUR');
    //
    //lecture des frais de gestion
    if CodeFrs  <> '' then
    begin
      MtDemande := TobCalcul.detail[iInd].GetDouble('BPE_TOTALTTCDEV');
      LigFrais := 0;

      //Création des zone pour valeurs cotraitant
      TobCalcul.Detail[iInd].AddChampSupValeur('FOURNISSEUR', CodeFrs);
      TobCalcul.Detail[iInd].AddChampSupValeur('NOMFRS',        '');
      TobCalcul.Detail[iInd].AddChampSupValeur('ADRESSE1',      '');
      TobCalcul.Detail[iInd].AddChampSupValeur('ADRESSE2',      '');
      TobCalcul.Detail[iInd].AddChampSupValeur('ADRESSE3',      '');
      TobCalcul.Detail[iInd].AddChampSupValeur('CODEPOSTAL',    '');
      TobCalcul.Detail[iInd].AddChampSupValeur('VILLE',         '');
      TobCalcul.Detail[iInd].AddChampSupValeur('DESBANQUE',     '');
      TobCalcul.Detail[iInd].AddChampSupValeur('ETABBQ',        '');
      TobCalcul.Detail[iInd].AddChampSupValeur('GUICHET',       '');
      TobCalcul.Detail[iInd].AddChampSupValeur('COMPTE_COTRAITE','');
      TobCalcul.Detail[iInd].AddChampSupValeur('CLERIB',        '');
      TobCalcul.Detail[iInd].AddChampSupValeur('DOMICILIATION', '');
      TobCalcul.Detail[iInd].AddChampSupValeur('VILLEBQ',       '');
      TobCalcul.Detail[iInd].AddChampSupValeur('IBAN',          '');
      TobCalcul.Detail[iInd].AddChampSupValeur('MTDEMANDE',     FormatFloat('#0.00', 0));
      TobCalcul.Detail[iInd].AddChampSupValeur('TOTALFRAIS',    FormatFloat('#0.00', 0));
      TobCalcul.Detail[iInd].AddChampSupValeur('MONTANTREGLE',  FormatFloat('#0.00', 0));

      //
      //recherche informations fournisseurs (nom)
      StSQl := 'SELECT T_LIBELLE, T_ADRESSE1, T_ADRESSE2, T_ADRESSE3, T_CODEPOSTAL, T_VILLE From TIERS WHERE T_AUXILIAIRE="' + CodeFrs + '"';
      QQ := OpenSQL(StSql, True);
      if not QQ.Eof then
      begin
        TobCalcul.Detail[iInd].PutValue('NOMFRS',     QQ.Findfield('T_LIBELLE').asString);
        TobCalcul.Detail[iInd].PutValue('ADRESSE1',   QQ.FindField('T_ADRESSE1').AsString);
        TobCalcul.Detail[iInd].PutValue('ADRESSE2',   QQ.FindField('T_ADRESSE2').AsString);
        TobCalcul.Detail[iInd].PutValue('ADRESSE3',   QQ.FindField('T_ADRESSE3').AsString);
        TobCalcul.Detail[iInd].PutValue('CODEPOSTAL', QQ.FindField('T_CODEPOSTAL').AsString);
        TobCalcul.Detail[iInd].PutValue('VILLE',      QQ.FindField('T_VILLE').AsString);
      end
      Else
      begin
        TobCalcul.Detail[iInd].PutValue('NOMFRS', 'Cotraitant inconnu');
      end;
      Ferme(QQ);

      //Recherche des ligne d'intervention sur affaire pour récupération renseignement bancaire....
      StSql := 'SELECT BAI_NUMERORIB FROM AFFAIREINTERV WHERE BAI_AFFAIRE="' + Affaire + '" AND BAI_TIERSFOU ="' + CodeFrs + '"';
      QQ := OpenSQL(StSql, True);
      if not QQ.eof then
      begin
        NumRib := QQ.findfield('BAI_NUMERORIB').AsInteger;
      end
      else NumRib := 0;
      //
      //recherche des informations bancaires du cotraitant
      TOBBQE := Tob.Create('RIB', nil, -1);
      LectRIB(TOBBQE, CodeFrs, NumRIB);
      TobCalcul.Detail[iInd].PutValue('DESBANQUE', '');
      TobCalcul.Detail[iInd].PutValue('ETABBQ',          TOBBQE.GetString('R_ETABBQ'));
      TobCalcul.Detail[iInd].PutValue('GUICHET',         TOBBQE.GetString('R_GUICHET'));
      TobCalcul.Detail[iInd].PutValue('COMPTE_COTRAITE', TOBBQE.GetString('R_NUMEROCOMPTE'));
      TobCalcul.Detail[iInd].PutValue('CLERIB',          TOBBQE.GetString('R_CLERIB'));
      TobCalcul.Detail[iInd].PutValue('DOMICILIATION',   TOBBQE.GetString('R_DOMICILIATION'));
      TobCalcul.Detail[iInd].PutValue('VILLEBQ',         TOBBQE.GetString('R_VILLE'));
      TobCalcul.Detail[iInd].PutValue('IBAN',            TOBBQE.GetString('R_CODEIBAN'));
      //
      //Recherche des frais de gestion sur cotraitant...
      StSQl := 'Select *, GPO_LIBELLE from AFFAIREFRSGEST LEFT JOIN PORT ON BAF_CODEPORT=GPO_CODEPORT where BAF_AFFAIRE="' + Affaire + '"';
      StSql := StSql + ' AND BAF_TIERS="' + CodeFrs + '"';
      TobCalcul.Detail[Iind].LoadDetailFromSQL(StSQL);
      For jInd := 0 to TobCalcul.Detail[iInd].Detail.count -1 do
      begin
        MtFrais := TobCalcul.Detail[iInd].Detail[jInd].GetDouble('BAF_PVTTC');
        if MtFrais = 0 then MtFrais := TobCalcul.Detail[iInd].Detail[jInd].GetDouble('BAF_PVHT');
        CoefFrais := TobCalcul.Detail[iInd].Detail[jInd].GetDouble('BAF_COEFF');
        if CoefFrais <> 0 then MtFrais := (MtDemande * (CoefFrais/100));
        TobCalcul.Detail[iInd].Detail[jInd].AddChampSupValeur('MTFRAIS', FormatFloat('#0.00', MtFrais));
        LigFrais := LigFrais + MtFrais;
      end;
      //
      LigRegle := MTDemande - LigFrais;
      TobCalcul.Detail[iInd].PutValue('MTDEMANDE', FormatFloat('#0.00', MtDemande));
      TobCalcul.Detail[iInd].PutValue('TOTALFRAIS', FormatFloat('#0.00',LigFrais));
      TobCalcul.Detail[iInd].PutValue('MONTANTREGLE', FormatFloat('#0.00',LigRegle));
      TotFrais    := TotFrais + LigFrais;
      TotRegle    := TotRegle + LigRegle;
      //
    end;
  end;

  //repositionnement sur le mandataire pour calcul du montant réglé...
  TobCalcul.Detail[0].PutValue('TOTALFRAIS', FormatFloat('#0.00',TotFrais));
  TobCalcul.Detail[0].PutValue('MTDEMANDE', FormatFloat('#0.00',TotDemande));
  TotRegle := TotDemande - TotRegle;
  TobCalcul.Detail[0].PutValue('MONTANTREGLE', FormatFloat('#0.00',TotRegle));

end;

procedure TOF_BTEDTBONPAIEMENT.ReleaseTob;
Begin
  //
  FreeAndNil(TobPIECE);
  FreeAndNil(TobAffaire);
  FreeAndNil(TobPiecTrait);
  //
  FreeAndNil(TobTiersFact);
  FreeAndNil(TobMandataire);
  FreeAndNil(TobSociete);
  //
  FreeAndNil(TobCalcul);
end;

procedure TOF_BTEDTBONPAIEMENT.LanceEdition;
var iInc      : Integer;
    TobEdition: TOB;
    TOBLigEdt : TOB;
    TOBEE     : TOB;
    Ok_Entete : Boolean;
Begin

  Ok_Entete := False;
  Ok_Recap  := False;

  TOBEE := TOB.create ('LES ETATS',nil,-1);

  //chargement de la tob d'édition par la tob de Calcul....
  TobEdition := TOB.Create('EDITION', TOBEE, -1);

  TRY
    if TobMandataire.GetString('TYPEPAIE') = '000' then
    begin
      ChargeEnteteEdition(TOBEE, TobEdition);
    end;
    //
    iInc := 0;
    //
    Repeat
      if TobMandataire.GetString('TYPEPAIE') = '000' then //Regroupement sur paiement
      begin
        if TOBCalcul.detail[iInc].GetString('FOURNISSEUR') = '' then
        begin
          if Assigned(TobEdition) then
          begin
            //chargement des lignes mandataire dans la TobEdition
            TOBLigEdt := TOB.create('LE MANDATAIRE', TobEdition, -1);
            ChargeMandataireEdition(TobLigEdt, TOBCalcul.detail[iInc]);
          end;
        end
        else
        begin
          if Assigned(TobEdition) then
          begin
            TOBLigEdt := TOB.create('LES COTRAITANTS', TobEdition, -1);
            ChargeCotraitantEdition(TOBLigEdt, TOBCalcul.detail[iInc]);
          end;
        end;
      end
      else                                                  //Paiement direct
      begin
        if not Ok_Entete then
        begin
          Ok_Entete  := True;
          //TobEdition := TOB.Create('EDITION', TOBEE, -1);
          ChargeEnteteEdition(TOBEE, TobEdition);
        end;
        if TOBCalcul.detail[iInc].GetString('FOURNISSEUR') <> '' then
        begin
            TOBLigEdt := TOB.create('LES COTRAITANTS', TobEdition, -1);
            ChargeCotraitantEdition(TOBLigEdt, TOBCalcul.detail[iInc]);
        end else
        begin
            TOBLigEdt := TOB.create('LE MANDATAIRE', TobEdition, -1);
            ChargeMandataireEdition(TobLigEdt, TOBCalcul.detail[iInc]);
        end;
      end;
      Inc(iInc) ;
    Until iInc > TobCalcul.detail.count-1;
    //
  FINALLY
    if Ok_Multiple then
      EditionMultiple(TOBEE)
    else
      EditionSimple(TOBEE);
  END;

end;

procedure TOF_BTEDTBONPAIEMENT.EditionSimple(TOBEE : TOB);
begin

  if ChkEditjust.Checked then StartPDFBatch;

  if TobMandataire.GetString('TYPEPAIE') = '000' then
  begin
    if OptionEdition.LanceImpression('', TobEE) < 0 then V_PGI.IoError:=oeUnknown;
  end
  else if TobMandataire.GetString('TYPEPAIE') = '001' then
  begin
    if OptionEdition1.LanceImpression('', TobEE) < 0 then V_PGI.IoError:=oeUnknown;
  end
  else
    pgiinfo('le type de paiement de l''affaire associée n''est pas prise en charge...');

  FreeAndNil(TOBEE);

  //Edition récapitulatif des frais...
  if ChkEditjust.Checked then
  begin
    LastPdfBatch;
    GenereRecap;
    if V_PGI.ioError <> OeOk then CancelPDFBatch;

    if Chkapercu.Checked then
      PreviewPDFFile('Edition Cotraitance',GetMultiPDFPath,True)
    else
      PrintPdf(GetMultiPDFPath, '', '');
    CancelPDFBatch;
  end;

  optionEdition1.Tip    := 'E';
  optionEdition1.Nature := 'BST';
  optionEdition1.Modele := TheModele1;
  optionEdition1.Titre  := 'Edition Attestation Paiement Direct';

  if ChkEditjust.Checked then Deletefile(GetMultiPDFPath);

end;

procedure TOF_BTEDTBONPAIEMENT.EditionMultiple(TOBEE : TOB);
begin

  if TobMandataire.GetString('TYPEPAIE') = '000' then
  begin
    if not (ChkEditjust.Checked) AND (Ok_LastEdit) then LastPdfBatch;
    if OptionEdition.LanceImpression('', TobEE) < 0 then V_PGI.IoError:=oeUnknown;
  end
  else if TobMandataire.GetString('TYPEPAIE') = '001' then
  begin
    if not (ChkEditjust.Checked) AND (Ok_LastEdit) then LastPdfBatch;
    if OptionEdition1.LanceImpression('', TobEE) < 0 then V_PGI.IoError:=oeUnknown;
  end
  else
    pgiinfo('le type de paiement de l''affaire associée n''est pas prise en charge...');

  FreeAndNil(TOBEE);

  //Edition récapitulatif des frais...
  if ChkEditjust.Checked then
  begin
    GenereRecap;
  end;

  optionEdition1.Tip    := 'E';
  optionEdition1.Nature := 'BST';
  optionEdition1.Modele := TheModele1;
  optionEdition1.Titre  := 'Edition Attestation Paiement Direct';

  if V_PGI.ioError <> OeOk then CancelPDFBatch;

end;


Procedure TOF_BTEDTBONPAIEMENT.ChargeEnteteEdition(TOBEE, TobEdition : TOB);
Begin

  //chargement des informations du tiers facturé
  TobEdition.AddChampSupValeur('NOMTIERS',    TobTiersFact.GetString('NOMTIERS'));
  TobEdition.AddChampSupValeur('ADRTIERS1',   TobTiersFact.GetString('ADRTIERS1'));
  TobEdition.AddChampSupValeur('ADRTIERS2',   TobTiersFact.GetString('ADRTIERS2'));
  TobEdition.AddChampSupValeur('ADRTIERS3',   TobTiersFact.GetString('ADRTIERS3'));
  TobEdition.AddChampSupValeur('CPTIERS',     TobTiersFact.GetString('CPTIERS'));
  TobEdition.AddChampSupValeur('VILLETIERS',  TobTiersFact.GetString('VILLETIERS'));

  //chargement des informations de la société
  TobEdition.AddChampSupValeur('SOCIETE',     TobSociete.GetString('SOCIETE'));
  TobEdition.AddChampSupValeur('RAISONSOC',   TobSociete.GetString('RAISONSOC'));
  TobEdition.AddChampSupValeur('ADRSOC1',     TobSociete.GetString('ADRSOC1'));
  TobEdition.AddChampSupValeur('ADRSOC2',     TobSociete.GetString('ADRSOC2'));
  TobEdition.AddChampSupValeur('ADRSOC3',     TobSociete.GetString('ADRSOC3'));
  TobEdition.AddChampSupValeur('CPSOC',       TobSociete.GetString('CPSOC'));
  TobEdition.AddChampSupValeur('VILLESOC',    TobSociete.GetString('VILLESOC'));
  TobEdition.AddChampSupValeur('TELSOC',      TobSociete.GetString('TELSOC'));
  TobEdition.AddChampSupValeur('FAXSOC',      TobSociete.GetString('FAXSOC'));
  TobEdition.AddChampSupValeur('EMAILSOC',    TobSociete.GetString('EMAILSOC'));
  TobEdition.AddChampSupValeur('JURIDIQUE',   TobSociete.GetString('JURIDIQUE'));
  TobEdition.AddChampSupValeur('CAPITAL',     TobSociete.GetString('CAPITAL'));
  TobEdition.AddChampSupValeur('SIRET',       TobSociete.GetString('SIRET'));
  TobEdition.AddChampSupValeur('APESOC',      TobSociete.GetString('APE'));
  TobEdition.AddChampSupValeur('RC',          TobSociete.GetString('RC'));
  TobEdition.AddChampSupValeur('RVA',         TobSociete.GetString('RVA'));


  //chargement des informations du mandataire/Etablissment
  TobEdition.AddChampSupValeur('MANDATAIRE',    TobMandataire.GetString('NOMMANDAT'));
  TobEdition.AddChampSupValeur('ADRMANDAT1',    TobMandataire.GetString('ADRESSE1'));
  TobEdition.AddChampSupValeur('ADRMANDAT2',    TobMandataire.GetString('ADRESSE2'));
  TobEdition.AddChampSupValeur('ADRMANDAT3',    TobMandataire.GetString('ADRESSE3'));
  TobEdition.AddChampSupValeur('CPMANDAT',      TobMandataire.GetString('CODEPOSTAL'));
  TobEdition.AddChampSupValeur('VILLEMANDAT',   TobMandataire.GetString('VILLE'));
  TobEdition.AddChampSupValeur('TELMANDAT',     TobMandataire.GetString('TELEPHONE'));
  TobEdition.AddChampSupValeur('FAXMANDAT',     TobMandataire.GetString('FAX'));
  TobEdition.AddChampSupValeur('EMAILMANDAT',   TobMandataire.GetString('EMAIL'));
  TobEdition.AddChampSupValeur('REGROUPEMENT',  TobMandataire.GetString('REGROUPEMENT'));
  TobEdition.AddChampSupValeur('CODEBANQUE',    TobMandataire.GetString('CODEBQ'));
  TobEdition.AddChampSupValeur('COMPTE_REGROUPEMENT',  TobMandataire.GetString('COMPTE_REGROUPEMENT'));
  TobEdition.AddChampSupValeur('DOMICILIATION_REGROUPEMENT', TobMandataire.GetString('DOMICILIATION_REGROUPEMENT'));
  TobEdition.AddChampSupValeur('VILLEBQ_REGROUPEMENT', TobMandataire.GetString('VILLEBQ_REGROUPEMENT'));

  TobEdition.AddChampSupValeur('STATUTMANDAT',  TobMandataire.GetString('JURIDIQUE'));
  TobEdition.AddChampSupValeur('SIRETMANDAT',   TobMandataire.GetString('SIRET'));
  TobEdition.AddChampSupValeur('APEMANDAT',     TobMandataire.GetString('APE'));

  //Chargement des informations de la pièce facture
  TobEdition.AddChampSupValeur('NATUREPIECEG',  TobPiece.GetString('GP_NATUREPIECEG'));
  TobEdition.AddChampSupValeur('NUMERO',        TobPiece.GetString('GP_NUMERO'));
  TobEdition.AddChampSupValeur('DATEPIECE',     TobPiece.GetDateTime('GP_DATEPIECE'));
  TobEdition.AddChampSupValeur('TOTALTTCDEV',   TobPIECE.GetDouble('GP_TOTALTTCDEV'));
  //
end;

Procedure TOF_BTEDTBONPAIEMENT.ChargeMandataireEdition(TobLigEdt, Tobcalc : TOB);
begin

  TOBLigEdt.AddChampSupValeur('TYPETIERS', 'M');
  TOBLigEdt.AddChampSupValeur('BAF_TIERS', Tobcalc.GetString('FOURNISSEUR'));

  TOBLigEdt.AddChampSupValeur('NOMFRS', TobMandataire.GetString('NOMMANDAT'));
  //
  TOBLigEdt.AddChampSupValeur('ADRESSE1', TobMandataire.GetString('ADRESSE1'));
  TOBLigEdt.AddChampSupValeur('ADRESSE2', TobMandataire.GetString('ADRESSE2'));
  TOBLigEdt.AddChampSupValeur('ADRESSE3', TobMandataire.GetString('ADRESSE3'));
  TOBLigEdt.AddChampSupValeur('CODEPOSTAL', TobMandataire.GetString('CODEPOSTAL'));
  TOBLigEdt.AddChampSupValeur('VILLE', TobMandataire.GetString('VILLE'));
  //
  TOBLigEdt.AddChampSupValeur('NOMBQE', TobMandataire.GetString('DESBANQUE'));
  TOBLigEdt.AddChampSupValeur('ETABBQ', TobMandataire.GetString('ETABBQ'));
  TOBLigEdt.AddChampSupValeur('GUICHET', TobMandataire.GetString('GUICHET'));
  TOBLigEdt.AddChampSupValeur('COMPTE_COTRAITE', TobMandataire.GetString('COMPTE_COTRAITE'));
  TOBLigEdt.AddChampSupValeur('CLERIB', TobMandataire.GetString('CLERIB'));
  TOBLigEdt.AddChampSupValeur('DOMICILIATION', TobMandataire.GetString('DOMICILIATION'));
  TOBLigEdt.AddChampSupValeur('VILLEBQ', TobMandataire.GetString('VILLEBQ'));
  TOBLigEdt.AddChampSupValeur('IBAN', TobMandataire.GetString('IBAN'));

  TOBLigEdt.AddChampSupValeur('TOTALFRAIS', Tobcalc.GetDouble('TOTALFRAIS'));
  TOBLigEdt.AddChampSupValeur('MTDEMANDE', Tobcalc.GetDouble('MTDEMANDE'));
  TOBLigEdt.AddChampSupValeur('MONTANTREGLE', Tobcalc.GetDouble('MONTANTREGLE'));

end;

Procedure TOF_BTEDTBONPAIEMENT.ChargeCotraitantEdition(TobLigEdt, TOBCalc : TOB);
var TobLigFrs : TOB;
    iInc      : Integer;
Begin

  //chargement des lignes calcul dans la tobedition
  TOBLigEdt.AddChampSupValeur('TYPETIERS', 'C');
  TOBLigEdt.AddChampSupValeur('BAF_TIERS', TOBCalc.GetString('FOURNISSEUR'));

  TOBLigEdt.AddChampSupValeur('NOMFRS', TOBCalc.GetString('NOMFRS'));
  //
  TOBLigEdt.AddChampSupValeur('ADRESSE1', TobCalcul.GetString('ADRESSE1'));
  TOBLigEdt.AddChampSupValeur('ADRESSE2', TobCalcul.GetString('ADRESSE2'));
  TOBLigEdt.AddChampSupValeur('ADRESSE3', TobCalcul.GetString('ADRESSE3'));
  TOBLigEdt.AddChampSupValeur('CODEPOSTAL', TobCalcul.GetString('CODEPOSTAL'));
  TOBLigEdt.AddChampSupValeur('VILLE', TobCalcul.GetString('VILLE'));
  //
  TOBLigEdt.AddChampSupValeur('NOMBQE', TobCalcul.GetString('DESBANQUE'));

  TOBLigEdt.AddChampSupValeur('ETABBQ',TOBCalc.GetString('ETABBQ'));
  TOBLigEdt.AddChampSupValeur('GUICHET', TOBCalc.GetString('GUICHET'));
  TOBLigEdt.AddChampSupValeur('COMPTE_COTRAITE', TOBCalc.GetString('COMPTE_COTRAITE'));
  TOBLigEdt.AddChampSupValeur('CLERIB', TOBCalc.GetString('CLERIB'));
  TOBLigEdt.AddChampSupValeur('DOMICILIATION', TOBCalc.GetString('DOMICILIATION'));
  TOBLigEdt.AddChampSupValeur('VILLEBQ', TOBCalc.GetString('VILLEBQ'));
  TOBLigEdt.AddChampSupValeur('IBAN', TOBCalc.GetString('IBAN'));

  TOBLigEdt.AddChampSupValeur('TOTALFRAIS', TOBCalc.GetDouble('TOTALFRAIS'));
  TOBLigEdt.AddChampSupValeur('MTDEMANDE', TOBCalc.GetDouble('MTDEMANDE'));
  TOBLigEdt.AddChampSupValeur('MONTANTREGLE', TOBCalc.GetDouble('MONTANTREGLE'));

  if Ok_Recap then
  begin
    for iInc := 0 to TOBCalc.Detail.count -1 do
    begin
      //chargement des lignes de frais...
      TobLigFrs := TOB.Create('LES FRAIS', TOBLigEdt, iInc);
      TobLigFrs.AddChampSupValeur('BAF_CODEPORT', TOBCalc.detail[iInc].GetString('BAF_CODEPORT'));
      TobLigFrs.AddChampSupValeur('LIBFRAIS', TOBCalc.detail[iInc].GetString('GPO_LIBELLE'));
      if TOBCalc.detail[iInc].Getdouble('BAF_PVTTC') = 0 then
        TobLigFrs.AddChampSupValeur('MTFRAIS', TOBCalc.detail[iInc].GetDOUBLE('BAF_PVHT'))
      else
        TobLigFrs.AddChampSupValeur('MTFRAIS', TOBCalc.detail[iInc].GetDOUBLE('BAF_PVTTC'));
      TobLigFrs.AddChampSupValeur('PERCENT', TOBCalc.detail[iInc].GetDOUBLE('BAF_COEFF'));
      TobLigFrs.AddChampSupValeur('CALCFRAIS', TOBCalc.detail[iInc].GetDOUBLE('MTFRAIS'));
    end;
  end;

end;

Procedure TOF_BTEDTBONPAIEMENT.GenereRecap;
var iInc      : Integer;
    TOBLigEdt : TOB;
    TOBRecap  : TOB;
    NumLig    : Integer;
begin

  Ok_Recap := true;

  TOBRecap := TOB.create ('LES RECAPS',nil,-1);

  for iInc := 0 to Tobcalcul.Detail.Count -1 do
  begin
    NumLig := iInc-1;
    if TOBCalcul.detail[iInc].GetString('FOURNISSEUR') <> '' then
    begin
      TOBLigEdt := TOB.create('LES COTRAITANTS', TobRecap, -1);
      ChargeCotraitantEdition(TOBLigEdt, TOBCalcul.detail[iInc]);
      //
      if NumLig = TOBRecap.Detail.count then
        ChargeEnteteEdition(TOBRecap, TOBRecap.detail[Numlig-1])
      else
        ChargeEnteteEdition(TOBRecap, TOBRecap.detail[Numlig]);
    end;
  end;
  //
  optionEdition1.Tip    := 'E';
  optionEdition1.Nature := 'BSR';
  optionEdition1.Modele := 'JUS';
  optionEdition1.Titre  := 'Edition Justificatif Frais Cotraitance';
  //
  if Ok_LastEdit then LastPdfBatch;

  if OptionEdition1.LanceImpression('', TOBRecap) < 0 then V_PGI.IoError:=oeUnknown;

  FreeAndNil(TOBRecap);

end;

Procedure TOF_BTEDTBONPAIEMENT.OnChangeEtat(Sender : Tobject);
Begin
   OptionEdition.Modele := FETAT.values[fetat.itemindex];
   TheModele  := OptionEdition.Modele;
end;

Procedure TOF_BTEDTBONPAIEMENT.OnChangeEtat1(Sender : Tobject);
Begin
   OptionEdition1.Modele := FETAT1.values[fetat1.itemindex];
   TheModele1 := OptionEdition1.Modele;
end;

procedure TOF_BTEDTBONPAIEMENT.OnClickApercu(Sender : Tobject);
begin
  OptionEdition.Apercu := ChkApercu.checked;
end;

procedure TOF_BTEDTBONPAIEMENT.OnClickReduire(Sender : Tobject);
begin
  OptionEdition.DeuxPages := ChkReduire.checked;
end;

Procedure TOF_BTEDTBONPAIEMENT.NomsChampsAffaire ( Var Aff,Aff0,Aff1,Aff2,Aff3,Aff4,Aff_,Aff0_,Aff1_,Aff2_,Aff3_,Aff4_,Tiers,Tiers_ : THEdit ) ;
BEGIN
  inherited;

  Aff:=THEdit(GetControl('GP_AFFAIRE'));
  Aff0:=THEdit(GetControl('AFFAIRE0')) ;
  Aff1:=THEdit(GetControl('GP_AFFAIRE1')) ;
  Aff2:=THEdit(GetControl('GP_AFFAIRE2')) ;
  Aff3:=THEdit(GetControl('GP_AFFAIRE3')) ;
  Aff4:=THEdit(GetControl('GP_AVENANT'))  ;

END ;

procedure TOF_BTEDTBONPAIEMENT.OnClose;
begin

  FreeAndNil(OptionEdition);
  FreeAndNil(OptionEdition1);

  inherited;

end;

Initialization
  registerclasses ( [ TOF_BTEDTBONPAIEMENT ] ) ; 
end.
