{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 17/02/2004
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTTABLEAUBORD ()
Mots clefs ... : TOF;BTTABLEAUBORD
*****************************************************************}
unit BTTableauBord_TOF;

interface

uses StdCtrls,
  Controls,
  Classes,
  {$IFNDEF EAGLCLIENT}
  db,
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  Fe_Main,
  {$ELSE}
  MaineAGL,
  {$ENDIF}
  forms,
  sysutils,
  ComCtrls,
  Menus,
  HCtrls,
  HEnt1,
  HQry,
  HMsgBox,
  UTOF,
  Stat,
  UTOB,
  utobview,
  AGLInit,
  AGLInitBTP,
  facture,
  Btputil,
  UtilSaisieConso,
  UtilReglementAffaire,
  uTofAfBaseCodeAffaire,
  Affaireutil,
  Lookup,
  Ent1,
  CalcOLEGenericBTP,
  UtilTableauBord;

type

  TOF_BTTABLEAUBORD = class(TOF_AFBASECODEAFFAIRE)
    procedure OnNew; override;
    procedure OnDelete; override;
    procedure OnUpdate; override;
    procedure OnLoad; override;
    procedure OnArgument(S: string); override;
    procedure OnClose; override;
    procedure NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_: THEdit); override;

  private
    TV1         : TTobViewer;
    TOBBTB      : TOB;
    DateDeb     : TdateTime;
    DateFin     : TDateTime;
    CodeAffaire : String;
    CodeAffaire0: String;
    CodeAffaire1: String;
    CodeAffaire2: String;
    CodeAffaire3: string;
    CodeAvenant: string;
    CodeClient  : String;
    Responsable : String;
    Apporteur   : string;
    Etablissement : string;
    CodeChantier : String;

    // Ajout LS
    DateMvtDeb,DateMvtFin : TdateTime;
    OptionChoixPrevuAvanc : TchoixPrevuAvanc;
    // ---

    // --- Ajout FV ---
    CChantier     : TCheckBox;
    CContrat      : TCheckBox;
    CAppel        : TCheckBox;
    CCumulAffaire : TCheckBox;
    CSelSansConso : TCheckBox;
    CSelReglement : TCheckBox;
    CEclatNatPrest: TCheckBox;
    CEclatFamNiv1 : TCheckBox;
    //
    THAffaire     : THEdit;
    THAffaire0    : THEdit;
    THAffaire1    : THEdit;
    THAffaire2    : THEdit;
    THAffaire3    : THEdit;
    THAvenant     : THEdit;
    THResponsable	: THEdit;
    //
    T_Affaire : THLabel;
    //
    MontantPA     : Double;
    MontantPR     : Double;
    MontantPV     : Double;
    Qte           : Double;
    // ---


    procedure OnDblClickTV(Sender: TObject);

    procedure ChargeLesChantiers;
    procedure ChargeLesConsos;

    procedure AjouteChampSup(var TOBTMP: TOB);
    procedure CompletelesChantiers;
    procedure InsereChampsDesire(TOBL, TOBAFF: TOB);

    procedure ChargeLeReste(TOBTMP: TOB);
    //
    function AvanceVide(TOBL: TOB): boolean;
    function EngageVide(TOBL: TOB): boolean;
    function FactureVide(TOBL: TOB): boolean;
    function LigneVide(TOBL: TOB): boolean;
    function PrevueVide(TOBL: TOB): boolean;
    function RealiseVide(TOBL: TOB): boolean;
    //
    function ChargeAffaireRef(CodeAffaire, AffaireSaisie: String): String;
    //
    procedure Repartition_Eclatement(Eclatement, TypeMt: String; Montant: Double; TOBTMP: Tob);
    procedure Repartition_Fournisseur(FamNiveau1: String; TOBTMP: TOB);
    procedure Repartition_Frais(TypeRessource, FamNiveau1 : String; TobTMP : TOB);
    procedure Repartition_IntSsTraitLocAut(TypeRessource, NatPrestation : String; TobTMP : TOB);
    procedure Repartition_MoInterne(TypeRessource, NatPrestation: String; TOBTMP: Tob);
    procedure Traitement_Repartition(TOBEclate, TOBTMP : TOB);
    procedure Repartition_MatOutil(TypeRessource, NatPrestation: String; TobTMP: TOB);
		Procedure MAJ_PremiereLigne(NomChampSup : String);
    // Modif FV puis LS et enfin le pape
    procedure CChoixClick(Sender: TObject);
    procedure ListeResponsable(Sender: TObject);
    // --
    procedure CCumulAffaireClick(Sender: TObject);
  end;

implementation

procedure TOF_BTTABLEAUBORD.OnNew;
begin
  inherited;
end;

procedure TOF_BTTABLEAUBORD.OnDelete;
begin
  inherited;
end;

procedure TOF_BTTABLEAUBORD.OnUpdate;
begin
  inherited;

	CodeChantier := CodeAffaireRegroupe(CodeAffaire0, CodeAffaire1,CodeAffaire2,CodeAffaire3,CodeAvenant,TaModif,false,false,false);

  TOBBTB.cleardetail;

  ChargeLesChantiers;

  if CSELSANSCONSO.Checked then CompletelesChantiers;

  if TOBBTB <> nil then
     begin
     ChargeLesConsos;
     TFStat(Ecran).LaTOB := TOBBTB;
     end;

end;

procedure TOF_BTTABLEAUBORD.OnLoad;
begin
  inherited;

  DateDeb := StrtoDate(GetControltext('BTBDATE'));
  DateFin := StrtoDate(GetControltext('BTBDATE_'));

  CodeAffaire0  := GetControltext('BTBAFFAIRE0');
  CodeAffaire  := GetControltext('BTBAFFAIRE');
  CodeAffaire1 := GetControltext('BTBAFFAIRE1');
  CodeAffaire2 := GetControltext('BTBAFFAIRE2');
  CodeAffaire3 := GetControltext('BTBAFFAIRE3');
  CodeAvenant  := GetControltext('BTBAVENANT');

  CodeClient := GetControltext('BTBTIERS');

  Responsable := GetControltext('BTBRESPONSABLE');

  Apporteur := GetControltext('BTBAPPORTEUR');
  Etablissement := GetControltext('BTBETABLISSEMENT');

  // Ajout LS
  DateMVTDeb := StrtoDate(GetControltext('DATEMVTDEB'));
  DateMVTFin := StrtoDate(GetControltext('DATEMVTDEB_'));

  OptionChoixPrevuAvanc := [OptGlobal];

  if TcheckBox(GetControl('CDBT')).Checked then
     OptionChoixPrevuAvanc := OptionChoixPrevuAvanc + [OptDetailDev]
  else
     OptionChoixPrevuAvanc := OptionChoixPrevuAvanc - [OptDetailDev];

  if TcheckBox(GetControl('CPBT')).Checked then
     OptionChoixPrevuAvanc := OptionChoixPrevuAvanc + [OptDetailPBT]
  else
     OptionChoixPrevuAvanc := OptionChoixPrevuAvanc - [OptDetailPBT];

  if TcheckBox(GetControl('CETU')).Checked then
     OptionChoixPrevuAvanc := OptionChoixPrevuAvanc + [OptDetailETU]
  else
     OptionChoixPrevuAvanc := OptionChoixPrevuAvanc - [OptDetailETU];

  if TcheckBox(GetControl('CBCE')).Checked then
     OptionChoixPrevuAvanc := OptionChoixPrevuAvanc + [OptDetailBCE]
  else
     OptionChoixPrevuAvanc := OptionChoixPrevuAvanc - [OptDetailBCE];

  if TcheckBox(GetControl('CFAC')).Checked then
     OptionChoixPrevuAvanc := OptionChoixPrevuAvanc + [OptDetailFAC]
  else
     OptionChoixPrevuAvanc := OptionChoixPrevuAvanc - [OptDetailFAC];
  // --
end;

procedure TOF_BTTABLEAUBORD.OnArgument(S: string);
Var Req : String;
    QQ  : TQuery;
    CC : THValCOmboBox;
begin
  inherited;

  // Gestion des évènements du TB
  TV1 := TTobViewer(GetControl('TV'));
  TV1.OnDblClick := OnDblClickTV;
  TOBBTB := TOB.create('Ma Tob', nil, -1);
  //
  THAffaire  := THEdit(GetControl('BTBAFFAIRE'));
  //
  THAffaire0 := THEdit(GetControl('BTBAFFAIRE0'));
  THAffaire1 := THEdit(GetControl('BTBAFFAIRE1'));
  THAffaire2 := THEdit(GetControl('BTBAFFAIRE2'));
  THAffaire3 := THEdit(GetControl('BTBAFFAIRE3'));
  THAvenant  := THEdit(GetControl('BTBAVENANT'));
  //
  THResponsable	:= THEdit(GetControl('BTBRESPONSABLE'));
  THResponsable.OnElipsisClick := ListeResponsable;
  //
  CChantier := ThCheckBox(ecran.FindComponent('CCHANTIER'));
  CChantier.OnClick := CChoixClick;
  //
  CContrat  := ThCheckBox(ecran.FindComponent('CCONTRAT'));
  CContrat.OnClick := CChoixClick;
  //
  CAppel    := ThCheckBox(ecran.FindComponent('CAPPEL'));
  CAppel.OnClick := CChoixClick;
  //
  CSelSansConso  := ThCheckBox(ecran.FindComponent('CSELSANSCONSO'));
  CCumulAffaire  := ThCheckBox(ecran.FindComponent('CCUMAFFAIRE'));
  CCumulAffaire.OnClick := CCumulAffaireClick;
  CSelReglement  := ThCheckBox(ecran.FindComponent('CSELREGLEMENT'));
  //
  CEclatNatPrest := ThCheckBox(ecran.FindComponent('CECLATNATPREST'));
  CEclatFamNiv1  := ThCheckBox(ecran.FindComponent('CECLATFAMNIV1'));
  //
  T_Affaire :=  THLabel (GetControl('TBTB_AFFAIRE'));
  //
  //Vérification si des appels existent et si des contrats existent
  Req := 'Select AFF_AFFAIRE0 FROM AFFAIRE WHERE AFF_AFFAIRE0="I"';
  QQ := OpenSQL(req, true,-1,'',true);
  if QQ.eof then CContrat.visible := False;
  Ferme(QQ);

  Req := 'Select AFF_AFFAIRE0 FROM AFFAIRE WHERE AFF_AFFAIRE0="W"';
  QQ := OpenSQL(req, true,-1,'',true);
  if QQ.eof then CAppel.visible := False;
  ferme(QQ);

  if (CAppel.visible = false) and (CContrat.Visible = false) then
     //SetControlproperty('GCHOIXAFFAIRE', 'Visible', False);
     SetControlproperty('CChantier', 'Visible', False);
  // --
  THAffaire0.text := 'A';

	{$IFDEF LINE}
  SetControlProperty('TOPTIONS', 'TabVisible', False);
  SetControlProperty('PCOMPLEMENT', 'TabVisible', False);
  SetControlProperty('PAVANCE', 'TabVisible', False);
  SetControlProperty('GCHOIXAFFAIRE', 'Visible', False);
  {$ENDIF}


  	// gestion Etablissement (BTP)
	CC:=THValComboBox(GetControl('BTBETABLISSEMENT')) ;
	if CC<>Nil then
  begin
  	PositionneEtabUser(CC) ;
    if not VH^.EtablisCpta then
    begin
    	if THLabel(GetControl('TBTB_ETABLISSEMENT')) <> nil then THLabel(GetControl('TBTB_ETABLISSEMENT')).Visible := false;
			CC.visible := false;
    end;
	end;
end;

Procedure Tof_BTTABLEAUBORD.ListeResponsable(Sender : TObject);
Var Req       : String;
begin

	Req := ' ARS_TYPERESSOURCE="SAL"';

  SetControlProperty('BTBRESPONSABLE', 'Plus', req);

  LookupCombo(THResponsable);

end;

procedure TOF_BTTABLEAUBORD.OnClose;
begin
  inherited;
  FreeAndNil(TOBBTB);
end;

//******************************************************************************
//********************* Zooms / double clic  ***********************************
//******************************************************************************

procedure TOF_BTTABLEAUBORD.OnDblClickTV(Sender: TObject);
var
  Req, Arg: string;
  QQ: Tquery;
  OneTOb : TOB;
  lastautoSearch : boolean;
begin

  if Copy(TV1.ColName[TV1.CurrentCol], 1, 5) = 'PREVU' then
     begin
     Req := 'SELECT GP_NATUREPIECEG, GP_DATEPIECE, GP_SOUCHE, GP_NUMERO, GP_INDICEG ' +
            'FROM PIECE ' +
            'WHERE GP_AFFAIRE="' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE'), TV1.CurrentRow] + '" ' +
            'AND GP_NATUREPIECEG="PBT"';
     QQ := OpenSQL(Req, true,-1,'',true);
     if not QQ.EOF then
        begin
        Arg := QQ.Fields[0].AsString + ';' + QQ.Fields[1].AsString + ';' + QQ.Fields[2].AsString + ';' +
               IntToStr(QQ.Fields[3].AsInteger) + ';' + IntToStr(QQ.Fields[4].AsInteger);
        AppelPiece([Arg, 'ACTION=CONSULTATION'], 2);
        end;
     ferme(QQ);
     end
  else if Copy(TV1.ColName[TV1.CurrentCol], 1, 6) = 'AVANCE' then
     begin
     Req := 'SELECT GP_NATUREPIECEG, GP_DATEPIECE, GP_SOUCHE, GP_NUMERO, GP_INDICEG, GP_TIERS, GP_AFFAIRE ' +
            'FROM PIECE ' +
            'WHERE GP_AFFAIRE="' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE'), TV1.CurrentRow] + '" ' +
            'AND GP_NATUREPIECEG="PBT"';
     QQ := OpenSQL(Req, true,-1,'',true);
     if not QQ.EOF then
        begin
        SaisieAvancementChantier(QQ.Fields[0].AsString,QQ.Fields[1].AsString,QQ.Fields[2].AsString,
                                 QQ.Fields[5].AsString, QQ.Fields[6].AsString,
                                 QQ.Fields[3].AsInteger, QQ.Fields[4].AsInteger, TaConsult);
        end;
     ferme(QQ);
     end
  else if Copy(TV1.ColName[TV1.CurrentCol], 1, 7) = 'FACTURE' then
     begin
     Arg := 'GP_NATUREPIECEG=ABT:FBT:AVC:FAC;GP_AFFAIRE=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE'), TV1.CurrentRow];
     Arg := Arg + ';GP_AFFAIRE1=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE1'), TV1.CurrentRow];
     Arg := Arg + ';GP_AFFAIRE2=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE2'), TV1.CurrentRow];
     Arg := Arg + ';GP_AFFAIRE3=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE3'), TV1.CurrentRow];
     AGLLanceFiche('BTP', 'BTPIECESAFF_MUL', Arg + ';CONSULTATION=X', '', ''); // affichage factures
     end
  else if Copy(TV1.ColName[TV1.CurrentCol], 1, 5) = 'REGLE' then
     begin
     Arg := 'GP_NATUREPIECEG=DAC:FBT;GP_AFFAIRE=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE'), TV1.CurrentRow];
     Arg := Arg + ';GP_AFFAIRE1=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE1'), TV1.CurrentRow];
     Arg := Arg + ';GP_AFFAIRE2=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE2'), TV1.CurrentRow];
     Arg := Arg + ';GP_AFFAIRE3=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE3'), TV1.CurrentRow];
     AGLLanceFiche('BTP', 'BTREGLAFFAIRE', Arg + ';CONSULTATION=X', '', ''); // affichage reglements
     end
  else if Copy(TV1.ColName[TV1.CurrentCol], 1, 7) = 'REALISE' then
     begin
     Arg := 'BCOAFFAIRE=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE'), TV1.CurrentRow];
     Arg := Arg + ';BCOAFFAIRE1=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE1'), TV1.CurrentRow];
     Arg := Arg + ';BCOAFFAIRE2=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE2'), TV1.CurrentRow];
     Arg := Arg + ';BCOAFFAIRE3=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE3'), TV1.CurrentRow];
     AGLLanceFiche('BTP','BTCONSOS',Arg,'','AUTO;'+TV1.ColName[TV1.CurrentCol]) ;
     end
  else if (TV1.ColName[TV1.CurrentCol] = 'ENGAGEFOU') or (TV1.ColName[TV1.CurrentCol] = 'ENGAGECHA') then
     begin
     Arg := 'CF:BFA';
     if (TV1.ColName[TV1.CurrentCol] = 'ENGAGECHA') then
        Arg := Arg + ':BLF:FF:AF:AFS';
     Arg := 'GP_NATUREPIECEG=' + Arg + ';GP_AFFAIRE=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE'), TV1.CurrentRow];
     AGLLanceFiche('BTP', 'BTPIECESAFF_MUL', Arg + ';CONSULTATION=X', '', ''); // affichage commandes et réceptions
     end
  else if TV1.ColName[TV1.CurrentCol] = 'FACTNONPAR' then
     begin
     Arg := 'CF:BFA:BLF:FF:AF:AFS';
     Arg := 'GP_NATUREPIECEG=' + Arg + ';GP_AFFAIRE=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE'), TV1.CurrentRow];
     AGLLanceFiche('BTP', 'BTPIECESAFF_MUL', Arg + ';CONSULTATION=X', '', ''); // affichage commandes et réceptions
     end
  else if TV1.ColName[TV1.CurrentCol] = 'BCO_AFFAIRE' then
     begin
     Arg := 'BCPAFFAIRE=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE'), TV1.CurrentRow];
     Arg := Arg + ';BCPAFFAIRE1=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE1'), TV1.CurrentRow];
     Arg := Arg + ';BCPAFFAIRE2=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE2'), TV1.CurrentRow];
     Arg := Arg + ';BCPAFFAIRE3=' + TV1.AsString[TV1.ColIndex('BCO_AFFAIRE3'), TV1.CurrentRow];
     AGLLanceFiche('BTP','BTCOMPARATIF',Arg,'','AUTO') ;
     end
  else if TV1.ColName[TV1.CurrentCol] = 'AFF_LIBELLE' then
     begin
     // ESSAIS ANALYSE GRAPHIQUE
     //TheTOB:=TOBBTB;
     //AGLLanceFiche('BTP','BTBRL','','','') ;
     //---------
//     V_PGI.DispatchTT(5, taConsult, TV1.AsString[TV1.ColIndex('BCO_AFFAIRE'), TV1.CurrentRow], '', '');

       lastautoSearch := V_PGI.AutoSearch;
			 V_PGI.AutoSearch := true;
			 OneTOB := TOB.Create ('LE LIEN',nil,-1);
       ONETOB.AddChampSupValeur ('DATEMVTDEB',DateMvtDeb);
       ONETOB.AddChampSupValeur ('DATEMVTFIN',DateMvtFIN);
       ONETOB.AddChampSupValeur ('CHANTIER',TV1.AsString[TV1.ColIndex('BCO_AFFAIRE'), TV1.CurrentRow]);
       ONETOB.AddChampSupValeur ('CHANTIER1',TV1.AsString[TV1.ColIndex('BCO_AFFAIRE1'), TV1.CurrentRow]);
       ONETOB.AddChampSupValeur ('CHANTIER2',TV1.AsString[TV1.ColIndex('BCO_AFFAIRE2'), TV1.CurrentRow]);
       ONETOB.AddChampSupValeur ('CHANTIER3',TV1.AsString[TV1.ColIndex('BCO_AFFAIRE3'), TV1.CurrentRow]);
       ONETOB.AddChampSupValeur ('LIBELLECHANTIER',TV1.AsString[TV1.ColIndex('AFF_LIBELLE'), TV1.CurrentRow]);
       TheTOB := OneTOB;
       AglLanceFiche('BTP','BTRESULTCHADET','','','');
       TheTOB := nil;
       OneTOB.free;
			 V_PGI.AutoSearch := lastautoSearch;
     end
  else if (TV1.ColName[TV1.CurrentCol] = 'AFF_APPORTEUR') and (TV1.AsString[TV1.ColIndex('AFF_APPORTEUR'), TV1.CurrentRow] <> '') then
     begin
     V_PGI.DispatchTT(14, taConsult, TV1.AsString[TV1.ColIndex('AFF_APPORTEUR'), TV1.CurrentRow], '', '');
     end
  else if TV1.ColName[TV1.CurrentCol] = 'AFF_RESPONSABLE' then
     begin
     V_PGI.DispatchTT(6, taConsult, TV1.AsString[TV1.ColIndex('AFF_RESPONSABLE'), TV1.CurrentRow], '', '');
     end
  else if TV1.ColName[TV1.CurrentCol] = 'AFF_TIERS' then
     begin
     Req := 'SELECT T_AUXILIAIRE FROM TIERS ' +
            'WHERE T_TIERS="' + TV1.AsString[TV1.ColIndex('AFF_TIERS'), TV1.CurrentRow] + '" ' +
            'AND T_NATUREAUXI="CLI"';
     QQ := OpenSQL(Req, true,-1,'',true);
     if not QQ.EOF then
        V_PGI.DispatchTT(8, taConsult, QQ.findfield('T_AUXILIAIRE').AsString, '', '');
     ferme(QQ);
     end;

end;

procedure TOF_BTTABLEAUBORD.NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_: THEdit);
begin

  Aff0 := THEdit(GetControl('BTBAFFAIRE0'));
  Aff := THEdit(GetControl('BTBAFFAIRE'));
  Aff1 := THEdit(GetControl('BTBAFFAIRE1'));
  Aff2 := THEdit(GetControl('BTBAFFAIRE2'));
  Aff3 := THEdit(GetControl('BTBAFFAIRE3'));
  Aff4 := THEdit(GetControl('BTBAVENANT'));

  Tiers := THEdit(GetControl('BTBTIERS'));

end;

// Ajout des champs dans la TOB

procedure TOF_BTTABLEAUBORD.AjouteChampSup(var TOBTMP: TOB);
begin
  //Champ Ajouté par FV
  TOBTMP.addchampsup('COUTANNEXE', false); TOBTMP.PutValue('COUTANNEXE', 0.0);
  TOBTMP.addchampsup('RECETTEANNEXE', false); TOBTMP.PutValue('RECETTEANNEXE', 0.0);
  if Not TOBTMP.FieldExists('CHANTIER_ASSOCIE') then  // a pu être créé avant par inserechampdesire appelé par completeleschantiers
  begin
     TOBTMP.addchampsup('CHANTIER_ASSOCIE', false); TOBTMP.PutValue('CHANTIER_ASSOCIE', '');
  end;
  //
  TOBTMP.addchampsup('PREVUPA', false); TOBTMP.PutValue('PREVUPA', 0.0);
  TOBTMP.addchampsup('PREVUPR', false); TOBTMP.PutValue('PREVUPR', 0.0);
  TOBTMP.addchampsup('PREVUPV', false); TOBTMP.PutValue('PREVUPV', 0.0);
  TOBTMP.addchampsup('TPS_PREVU', false); TOBTMP.PutValue('TPS_PREVU', 0.0);
  //
  TOBTMP.addchampsup('REALISETOTALPA', false); TOBTMP.PutValue('REALISETOTALPA', 0.0);
  TOBTMP.addchampsup('REALISETOTALPR', false); TOBTMP.PutValue('REALISETOTALPR', 0.0);
  TOBTMP.addchampsup('REALISETOTALPV', false); TOBTMP.PutValue('REALISETOTALPV', 0.0);
  //
  TOBTMP.addchampsup('REALISEMOPA', false); TOBTMP.PutValue('REALISEMOPA', 0.0);
  TOBTMP.addchampsup('REALISEMOPR', false); TOBTMP.PutValue('REALISEMOPR', 0.0);
  TOBTMP.addchampsup('REALISEMOPV', false); TOBTMP.PutValue('REALISEMOPV', 0.0);
  TOBTMP.addchampsup('TPS_REALISE', false); TOBTMP.PutValue('TPS_REALISE', 0.0);
  TOBTMP.addchampsup('TPS_REALISEINT', false); TOBTMP.PutValue('TPS_REALISEINT', 0.0);
  //
  TOBTMP.addchampsup('REALISEFOURNITURESPA', false); TOBTMP.PutValue('REALISEFOURNITURESPA', 0.0);
  TOBTMP.addchampsup('REALISEFOURNITURESPR', false); TOBTMP.PutValue('REALISEFOURNITURESPR', 0.0);
  TOBTMP.addchampsup('REALISEFOURNITURESPV', false); TOBTMP.PutValue('REALISEFOURNITURESPV', 0.0);
  //
  TOBTMP.addchampsup('REALISEPRESTATIONSPA', false); TOBTMP.PutValue('REALISEPRESTATIONSPA', 0.0);
  TOBTMP.addchampsup('REALISEPRESTATIONSPR', false); TOBTMP.PutValue('REALISEPRESTATIONSPR', 0.0);
  TOBTMP.addchampsup('REALISEPRESTATIONSPV', false); TOBTMP.PutValue('REALISEPRESTATIONSPV', 0.0);
  //
  TOBTMP.addchampsup('REALISEMATERIELSPA', false); TOBTMP.PutValue('REALISEMATERIELSPA', 0.0);
  TOBTMP.addchampsup('REALISEMATERIELSPR', false); TOBTMP.PutValue('REALISEMATERIELSPR', 0.0);
  TOBTMP.addchampsup('REALISEMATERIELSPV', false); TOBTMP.PutValue('REALISEMATERIELSPV', 0.0);
  // AJOUT LS
	AjouteChampSupRealiseDetail (TOBTmp);
  //
  TOBTMP.addchampsup('AVANCEPA', false); TOBTMP.PutValue('AVANCEPA', 0.0);
  TOBTMP.addchampsup('AVANCEPR', false); TOBTMP.PutValue('AVANCEPR', 0.0);
  TOBTMP.addchampsup('AVANCEPV', false); TOBTMP.PutValue('AVANCEPV', 0.0);
  TOBTMP.addchampsup('TPS_AVANCE', false); TOBTMP.PutValue('TPS_AVANCE', 0.0);

  TOBTMP.addchampsup('FACTUREHT', false); TOBTMP.PutValue('FACTUREHT', 0.0);
  TOBTMP.addchampsup('FACTURE', false); TOBTMP.PutValue('FACTURE', 0.0);
  TOBTMP.addchampsup('REGLE', false); TOBTMP.PutValue('REGLE', 0.0);
  TOBTMP.addchampsup('REGLEHT', false); TOBTMP.PutValue('REGLEHT', 0.0);

  TOBTMP.addchampsup('ENGAGEFOU', false); TOBTMP.PutValue('ENGAGEFOU', 0.0);
  TOBTMP.addchampsup('ENGAGECHA', false); TOBTMP.PutValue('ENGAGECHA', 0.0);
  TOBTMP.addchampsup('FACTNONPAR', false); TOBTMP.PutValue('FACTNONPAR', 0.0);

  TOBTMP.addchampsup('COURECANN', false); TOBTMP.PutValue('COURECANN', 0.0);

  // AJOUT LS
  if (OptDetailETU in OptionChoixPrevuAvanc) then AjouteChampSupPrevu(TOBTmp,'ETU');
  if (OptDetailDEV in OptionChoixPrevuAvanc) then AjouteChampSupPrevu(TOBTmp,'DBT');
  if (OptDetailBCE in OptionChoixPrevuAvanc) then AjouteChampSupPrevu(TOBTmp,'BCE');
  if (OptDetailPBT in OptionChoixPrevuAvanc) or (OptGlobal in OptionChoixPrevuAvanc) then AjouteChampSupPrevu(TOBTmp,'PBT');
  // AJOUT BRL
  if (OptDetailFAC in OptionChoixPrevuAvanc) then AjouteChampSupFactureDetail (TOBTmp);
end;

procedure TOF_BTTABLEAUBORD.InsereChampsDesire(TOBL,TOBAFF : TOB);
begin
	TOBL.AddChampSupValeur ('AFF_TIERS',TOBAFF.geTValue('AFF_TIERS'));
	TOBL.AddChampSupValeur ('AFF_APPORTEUR',TOBAFF.geTValue('AFF_APPORTEUR'));
	TOBL.AddChampSupValeur ('AFF_ETABLISSEMENT',TOBAFF.geTValue('AFF_ETABLISSEMENT'));
	TOBL.AddChampSupValeur ('AFF_RESPONSABLE',TOBAFF.geTValue('AFF_RESPONSABLE'));
	TOBL.AddChampSupValeur ('AFF_LIBELLE',TOBAFF.geTValue('AFF_LIBELLE'));
	TOBL.AddChampSupValeur ('AFF_LIBREAFF1',TOBAFF.geTValue('AFF_LIBREAFF1'));
	TOBL.AddChampSupValeur ('AFF_LIBREAFF2',TOBAFF.geTValue('AFF_LIBREAFF2'));
	TOBL.AddChampSupValeur ('AFF_LIBREAFF3',TOBAFF.geTValue('AFF_LIBREAFF3'));
	TOBL.AddChampSupValeur ('AFF_BOOLLIBRE1',TOBAFF.geTValue('AFF_BOOLLIBRE1'));
	TOBL.AddChampSupValeur ('AFF_BOOLLIBRE2',TOBAFF.geTValue('AFF_BOOLLIBRE2'));
	TOBL.AddChampSupValeur ('AFF_BOOLLIBRE3',TOBAFF.geTValue('AFF_BOOLLIBRE3'));
	TOBL.AddChampSupValeur ('BCO_AFFAIRE',TOBAFF.geTValue('AFF_AFFAIRE'));
	TOBL.AddChampSupValeur ('BCO_AFFAIRE0',TOBAFF.geTValue('AFF_AFFAIRE0'));
	TOBL.AddChampSupValeur ('BCO_AFFAIRE1',TOBAFF.geTValue('AFF_AFFAIRE1'));
	TOBL.AddChampSupValeur ('BCO_AFFAIRE2',TOBAFF.geTValue('AFF_AFFAIRE2'));
	TOBL.AddChampSupValeur ('BCO_AFFAIRE3',TOBAFF.geTValue('AFF_AFFAIRE3'));
  //Test de gestion du cumul sur affaire
  //Gestion des affaires de référence
  if CCumulAffaire.checked then
    TOBL.AddChampSupValeur('CHANTIER_ASSOCIE', ChargeAffaireRef(TOBAFF.getValue('AFF_AFFAIRE'), ''));
end;

procedure TOF_BTTABLEAUBORD.CompletelesChantiers;
var Req       : string;
    QQ        : Tquery;
    TOBAFF    : TOB;
    TOBL      : TOB;
    Indice    : integer;
    WhereSql  : string;
    SelAPartir, CodCha: String;
begin

  WhereSql := RecupWhereCritere (TPageControl(GetControl('PAGES')));

  Req := 'SELECT AFF_TIERS, AFF_APPORTEUR, AFF_RESPONSABLE, AFF_ETABLISSEMENT,'+
         'AFF_LIBELLE, AFF_LIBREAFF1, AFF_LIBREAFF2, AFF_LIBREAFF3,'+
         'AFF_BOOLLIBRE1,AFF_BOOLLIBRE2,AFF_BOOLLIBRE3,AFF_ETATAFFAIRE,'+
	 'AFF_AFFAIRE, AFF_AFFAIRE0,AFF_AFFAIRE1, AFF_AFFAIRE2, AFF_AFFAIRE3  FROM AFFAIRE ';

  if WhereSql = '' then
     Req := Req + ' WHERE '
  else
     begin
     WhereSql := StringReplace (WhereSql, 'BCO_', 'AFF_', [rfReplaceAll]);
     Req := Req + WhereSql+' AND ';
     end;

  if Not CCumulAffaire.checked then
    Req := Req + 'AFF_AFFAIRE IN (SELECT DISTINCT GP_AFFAIRE FROM PIECE WHERE '+
                 'GP_NATUREPIECEG IN ("PBT","AFF","FBT","FAC","AVC","ABT") AND GP_AFFAIRE <> "")';

  //Ne pas prendre l'affaire si la date de fin est antérieure ou égale à la date d'entrée
  // mis en commentaire par BRL le 11/01/2011 : remplacé par l'ajout du code état affaire dans les champs dispos
  //Req := Req + ' AND (AFF_DATEFIN > "' + UsDateTime(V_PGI.DateEntree) + '") ';

  //Gestion des Sélection à Partir de ...
  SelAPartir := '';
  if CChantier.checked then SelAPartir := 'AFF_AFFAIRE0 = "A" ';

  if CContrat.checked  then
     if Selapartir <> '' then
        Selapartir := SelAPartir + ' OR AFF_AFFAIRE0 = "I" '
     else
        Selapartir := 'AFF_AFFAIRE0 = "I" ';

  if CAppel.Checked Then
     if Selapartir <> '' then
        Selapartir := SelAPartir + ' OR AFF_AFFAIRE0 = "W" '
     else
        Selapartir := 'AFF_AFFAIRE0 = "W" ';

  if Selapartir <> '' then Req := Req + ' AND (' + SelAPartir + ')';

  if CCumulAffaire.checked then
  Begin
    CodCha := Trim(Copy(CodeChantier,2,14));
  	if (CodCha <> '') then
      Req := Req + ' AND (AFF_CHANTIER LIKE "%' + CodCha + '%" OR (AFF_AFFAIRE LIKE "%' + Codcha + '%" AND AFF_AFFAIRE0 = "A"))'
  end else
  Begin
  	if CodeAffaire <> '' then
     	Req := Req + ' AND AFF_AFFAIRE = "' + CodeAffaire + '"'
  	else
     	begin
     	if CodeAffaire1 <> '' then
      	Req := Req + ' AND AFF_AFFAIRE1 = "' + CodeAffaire1 + '"';
     	if CodeAffaire2 <> '' then
        Req := Req + ' AND AFF_AFFAIRE2 = "' + CodeAffaire2 + '"';
     	if CodeAffaire3 <> '' then
        Req := Req + ' AND AFF_AFFAIRE3 = "' + CodeAffaire3 + '"';
     	end;
  end;

  if CodeClient <> '' then
     Req := Req + ' AND AFF_TIERS = "' + CodeClient + '"';

  if Responsable <> '' then
     Req := Req + ' AND AFF_RESPONSABLE = "' + Responsable + '"';

  if Apporteur <> '' then
     Req := Req + ' AND AFF_APPORTEUR = "' + Apporteur + '"';


  if Etablissement <> '' then
     Req := Req + ' AND AFF_ETABLISSEMENT = "' + Etablissement + '"';

  QQ := OpenSql (Req,True,-1,'',true);

  TOBAFF := TOB.Create ('LES AFFAIRES',nil,-1);
  TOBAFF.LoadDetailDB ('AFFAIRE','','',QQ,false,true);

  ferme (QQ);

  for Indice := 0 TO TOBAFF.detail.count -1 do
      begin
      if TOBBTB.FindFirst (['BCO_AFFAIRE'],[TOBAFF.detail[Indice].getValue('AFF_AFFAIRE')],true) = nil then
         begin
    	   TOBL := TOB.Create ('',TOBBTB,-1);
         insereChampsDesire(TOBL, TOBAFF.detail[Indice]);
         end;
      end;

  TOBAFF.free;

end;

procedure TOF_BTTABLEAUBORD.ChargeLesChantiers;
var Req         : string;
    QQ          : Tquery;
    SelAPartir, CodCha  : String;
begin

  Req := TFStat(Ecran).stSQL;

  // On met à jour la TOB uniquement pour les chantiers
  // ayant des mouvements dans les dates sélectionnées
  Req := Req + '  AND BCO_DATEMOUV BETWEEN "' + UsDateTime(DateDeb) +
               '" AND "' + UsDateTime(DateFin) + '"';

  //Gestion des Sélection à Partir de ...
  SelAPartir := '';
  if CChantier.checked then SelAPartir := 'BCO_AFFAIRE0 = "A" ';

  if CContrat.checked  then
     if Selapartir <> '' then
        Selapartir := SelAPartir + ' OR BCO_AFFAIRE0 = "I" '
     else
        Selapartir := 'BCO_AFFAIRE0 = "I" ';

  if CAppel.Checked Then
     if Selapartir <> '' then
        Selapartir := SelAPartir + ' OR BCO_AFFAIRE0 = "W" '
     else
        Selapartir := 'BCO_AFFAIRE0 = "W" ';

  if Selapartir <> '' then Req := Req + ' AND (' + SelAPartir + ')';

  if CCumulAffaire.checked then
  Begin
    CodCha := Trim(Copy(CodeChantier,2,14));
  	if (CodCha <> '') then
      Req := Req + ' AND (AFF_CHANTIER LIKE "%' + CodCha + '%" OR BCO_AFFAIRE LIKE "%' + Codcha + '%")'
  end else
  Begin
  	if CodeAffaire <> '' then
    	Req := Req + ' AND BCO_AFFAIRE = "' + CodeAffaire + '"'
  	else
    	begin
     	if CodeAffaire1 <> '' then
        Req := Req + ' AND BCO_AFFAIRE1 = "' + CodeAffaire1 + '"';
     	if CodeAffaire2 <> '' then
        Req := Req + ' AND BCO_AFFAIRE2 = "' + CodeAffaire2 + '"';
     	if CodeAffaire3 <> '' then
        Req := Req + ' AND BCO_AFFAIRE3 = "' + CodeAffaire3 + '"';
     	end;
	end;

  if CodeClient <> '' then
     Req := Req + ' AND AFF_TIERS = "' + CodeClient + '"';

  if Responsable <> '' then
     Req := Req + ' AND AFF_RESPONSABLE = "' + Responsable + '"';

  if Apporteur <> '' then
     Req := Req + ' AND AFF_APPORTEUR = "' + Apporteur + '"';

  if Etablissement <> '' then
     Req := Req + ' AND AFF_ETABLISSEMENT = "' + Etablissement + '"';

  QQ := OpenSQL(Req, true,-1,'',true);
  TOBBTB.LoadDetailDB('', '', '', QQ, true);
  ferme(QQ);

end;

procedure TOF_BTTABLEAUBORD.ChargeLesConsos;
var Req           : String;
    Indice        : integer;
    QQ            : Tquery;
    TOBTMP        : TOB;
    TOBECLATE     : TOB;
    I             : integer;
    AffaireSaisie, CodeAff : String;
begin

  // Mise à jour des montants réalisés et engagés pour les chantiers concernés
  for i := 0 to TOBBTB.Detail.Count - 1 do
      begin
      TOBTMP := TOBBTB.Detail[i];
      if (TOBTMP <> nil) then
         begin
         AjouteChampSup(TOBTMP);
         CodeAff := TOBTMP.GetValue('BCO_AFFAIRE');
         Req := 'SELECT BNP_TYPERESSOURCE,BCO_NATUREPIECEG, BCO_NATUREMOUV, ' +
                'BCO_RESSOURCE, BCO_ARTICLE, BCO_QUANTITE, BCO_MONTANTACH AS ACHAT, ' +
                'BCO_MONTANTPR AS REVIENT, BCO_MONTANTHT AS VENTE, ARS_TYPERESSOURCE, ' +
                'BCO_AFFAIRESAISIE AS CONTRATASSOCIE, ' +
                'GA_NATUREPRES AS NATUREPRESTATION, GA_FAMILLENIV1 AS FAMILLEART ' +
                'FROM CONSOMMATIONS ' +
                'LEFT JOIN ARTICLE ON GA_ARTICLE=BCO_ARTICLE ' +
                'LEFT JOIN NATUREPREST ON BNP_NATUREPRES=GA_NATUREPRES '+
                'LEFT JOIN RESSOURCE ON ARS_RESSOURCE=BCO_RESSOURCE '+
                'WHERE BCO_TRANSFORME="-" AND BCO_TRAITEVENTE="-" ' +
                'AND BCO_AFFAIRE="' + CodeAff + '" ';
         Req := Req + '  AND BCO_DATEMOUV BETWEEN "' + UsDateTime(DateMvtDeb) +
                      '" AND "' + UsDateTime(DateMvtFin) + '" ';
         Req := Req + 'ORDER BY BCO_AFFAIRE, BCO_NATUREPIECEG, BCO_NATUREMOUV';
         QQ := OpenSQL(Req, true,-1,'',true);
         TOBECLATE := TOB.create('Repartition', nil, -1);
         TOBECLATE.LoadDetailDB('', '', '', QQ, true);
         ferme(QQ);
         //Boucle sur tob pour gestion des différents éclatements...
         for Indice := 0 TO TOBECLATE.detail.count -1 do
             Begin
             //Test de gestion du cumul sur affaire
             //Gestion des affaires de référence : chargement niveau ligne
             AffaireSaisie := TOBECLATE.Detail[Indice].GetString('CONTRATASSOCIE');
             if CCumulAffaire.checked then
                TOBTMP.PutValue('CHANTIER_ASSOCIE', ChargeAffaireRef(CodeAff, AffaireSaisie));
             //
             Traitement_Repartition(TOBEclate.detail[Indice], TOBTMP);
             end;
         FreeAndNil(TOBECLATE);
         // Calcul des factures fournisseurs non parvenues
         // Cumul des lignes de commandes et de réceptions non transformées.
         // MODIF BRL 29/11 : on contrôle que la pièce d'achat est vivante
         Req := 'SELECT SUM(BCO_MONTANTACH) AS ACHAT FROM CONSOMMATIONS LEFT JOIN PIECE ON ' +
                'BCO_NATUREPIECEG=GP_NATUREPIECEG AND BCO_SOUCHE=GP_SOUCHE AND BCO_NUMERO=GP_NUMERO ' +
                'WHERE GP_VIVANTE="X" AND BCO_TRANSFORME="-" AND (BCO_NATUREPIECEG="CF" OR BCO_NATUREPIECEG="BLF") ' +
                'AND BCO_AFFAIRE="' + TOBTMP.GetValue('BCO_AFFAIRE') + '"';
         Req := Req + ' AND BCO_DATEMOUV BETWEEN "' + UsDateTime(DateMvtDeb) + '" ';
         Req := Req + ' AND "' + UsDateTime(DateMvtFin) + '" ';
         QQ := OpenSQL(Req, true,-1,'',true);
         if not QQ.EOF then
            begin
            MontantPA := QQ.findfield('ACHAT').AsFloat;
            TOBTMP.PutValue('FACTNONPAR', TOBTMP.GetValue('FACTNONPAR') + MontantPA);
            end;
         ferme(QQ);
         ChargeLeReste(TOBTMP);
         //if LigneVide(TOBTMP) then TOBTMP.free;
         end;
      end;

end;

Procedure TOF_BTTABLEAUBORD.Traitement_Repartition(TOBEclate, TOBTMP : TOB);
Var TypeRessource : string;
    NatureMouv    : String;
    NatPrestation : String;
    FamNiveau1    : String;
Begin

  // Traitements du réalisé
  MontantPA     := TOBECLATE.GetValue('ACHAT');
  MontantPR     := TOBECLATE.GetValue('REVIENT');
  MontantPV     := TOBECLATE.GetValue('VENTE');
  Qte           := TOBECLATE.GetValue('BCO_QUANTITE');
  //
  NatPrestation := TOBECLATE.GetString('NATUREPRESTATION');
  FamNiveau1    := TOBECLATE.GetString('FAMILLEART');
  NatureMouv    := TOBECLATE.GetString('BCO_NATUREMOUV');
  TypeRessource := TOBECLATE.GetString('ARS_TYPERESSOURCE');
  //
  if TypeRessource = '' then
     TypeRessource := TOBECLATE.GetString('BNP_TYPERESSOURCE');
  //
  if (TOBECLATE.GetString('BCO_NATUREPIECEG') = '') or     // consos saisies
     (TOBECLATE.GetString('BCO_NATUREPIECEG') = 'AFS') or   // correction BRL le 06/04/05 prise ne compte des avoirs en consos
     (TOBECLATE.GetString('BCO_NATUREPIECEG') = 'AF') or    // ...
     (TOBECLATE.GetString('BCO_NATUREPIECEG') = 'BFC') or   // Retour chantier
     (TOBECLATE.GetString('BCO_NATUREPIECEG') = 'LBT') then // consos issues de bons de livraison clients
     begin
     // Répartition Fournitures
     if NatureMouv = 'FOU' then
        Repartition_Fournisseur(FamNiveau1, TOBTMP)
     // Répartition MO Interne
     Else if NatureMouv = 'MO' then
        Repartition_MOInterne(TypeRessource, NatPrestation, TobTMP)
     // Répartition Frais
     Else if NatureMouv = 'FRS' then
        Repartition_Frais(TypeRessource, FamNiveau1, TobTMP)
     // Répartition Matériels + Outils
     Else if NatureMouv = 'RES' then
        Repartition_MatOutil(TypeRessource, NatPrestation, TobTMP)
     // Répartition Intérim + Sous-traitance + Location + Autres
     Else if NatureMouv = 'EXT' then
        Repartition_IntSsTraitLocAut(TypeRessource, NatPrestation, TobTMP)
     // Répartition coûts et recettes annexes
     Else if NatureMouv = 'RAN' Then
        Begin
        TOBTMP.PutValue('COURECANN', TOBTMP.GetValue('COURECANN') - MontantPV);
        MontantPV := MontantPV * -1;
        TOBTMP.PutValue('RECETTEANNEXE', TOBTMP.GetValue('RECETTEANNEXE') + MontantPV);
        end
     Else If NatureMouv = 'FAN' then
        Begin
        TOBTMP.PutValue('COURECANN', TOBTMP.GetValue('COURECANN') - MontantPV);
        TOBTMP.PutValue('COUTANNEXE', TOBTMP.GetValue('COUTANNEXE') + MontantPV);
        end;
     end;

  // consos issues de bons de réception fournisseurs (engagé chantier)
  if (TOBECLATE.GetString('BCO_NATUREPIECEG') = 'BLF') or
     (TOBECLATE.GetString('BCO_NATUREPIECEG') = 'FF')  or
     (TOBECLATE.GetString('BCO_NATUREPIECEG') = 'AFS') or // correction LS le 09/09/05
     (TOBECLATE.GetString('BCO_NATUREPIECEG') = 'AF')  then
     TOBTMP.PutValue('ENGAGECHA', TOBTMP.GetValue('ENGAGECHA') + MontantPA)
  // consos issues de bons de commande fournisseurs (engagé fournisseur)
  else if (TOBECLATE.GetString('BCO_NATUREPIECEG') = 'CF') or
          (TOBECLATE.GetString('BCO_NATUREPIECEG') = 'BFA')then
     begin
     TOBTMP.PutValue('ENGAGEFOU', TOBTMP.GetValue('ENGAGEFOU') + MontantPA);
     TOBTMP.PutValue('ENGAGECHA', TOBTMP.GetValue('ENGAGECHA') + MontantPA);
     end;
end;

Procedure TOF_BTTABLEAUBORD.Repartition_Fournisseur(FamNiveau1 : String; TOBTMP : TOB);
begin
  TOBTMP.PutValue('REALISEFOURNITURESPA', TOBTMP.GetValue('REALISEFOURNITURESPA') + MontantPA);
  TOBTMP.PutValue('REALISEFOURNITURESPR', TOBTMP.GetValue('REALISEFOURNITURESPR') + MontantPR);
  TOBTMP.PutValue('REALISEFOURNITURESPV', TOBTMP.GetValue('REALISEFOURNITURESPV') + MontantPV);

  if CEclatFamNiv1.checked then
     begin
     if FamNiveau1 = '' Then FamNiveau1 := 'NONRENSEIGNE';
     Repartition_Eclatement('FOU'+FamNiveau1, 'PA', MontantPA, TOBTMP);
     Repartition_Eclatement('FOU'+FamNiveau1, 'PV', MontantPV, TOBTMP);
     Repartition_Eclatement('FOU'+FamNiveau1, 'PR', MontantPR, TOBTMP);
     end;
end;

Procedure TOF_BTTABLEAUBORD.Repartition_MoInterne(TypeRessource, NatPrestation : String; TOBTMP : Tob);
Begin
  // Traitement des intérimaires saisis en détail dans les heures
     if TypeRessource = 'INT' then
        begin
        TOBTMP.PutValue('REALISEPRESTATIONSPA', TOBTMP.GetValue('REALISEPRESTATIONSPA') + MontantPA);
        TOBTMP.PutValue('REALISEPRESTATIONSPR', TOBTMP.GetValue('REALISEPRESTATIONSPR') + MontantPR);
        TOBTMP.PutValue('REALISEPRESTATIONSPV', TOBTMP.GetValue('REALISEPRESTATIONSPV') + MontantPV);
        //
        TOBTMP.PutValue('REALISE_INTERIM_PA', TOBTMP.GetValue('REALISE_INTERIM_PA') + MontantPA);
        TOBTMP.PutValue('REALISE_INTERIM_PR', TOBTMP.GetValue('REALISE_INTERIM_PR') + MontantPR);
        TOBTMP.PutValue('REALISE_INTERIM_PV', TOBTMP.GetValue('REALISE_INTERIM_PV') + MontantPV);
        TOBTMP.PutValue('TPS_REALISEINT', TOBTMP.GetValue('TPS_REALISEINT') + Qte);
  			//
				if CEclatNatPrest.checked then
     			Begin
     			Repartition_Eclatement('INT'+NatPrestation, 'PA', MontantPA, TOBTMP);
     			Repartition_Eclatement('INT'+NatPrestation, 'PV', MontantPV, TOBTMP);
     			Repartition_Eclatement('INT'+NatPrestation, 'PR', MontantPR, TOBTMP);
     			Repartition_Eclatement('INT'+NatPrestation, 'QTE', Qte, TOBTMP);
     			end;
        end
     else
        // Traitement des salariés
        begin
        TOBTMP.PutValue('REALISEMOPA', TOBTMP.GetValue('REALISEMOPA') + MontantPA);
        TOBTMP.PutValue('REALISEMOPR', TOBTMP.GetValue('REALISEMOPR') + MontantPR);
        TOBTMP.PutValue('REALISEMOPV', TOBTMP.GetValue('REALISEMOPV') + MontantPV);
        TOBTMP.PutValue('TPS_REALISE', TOBTMP.GetValue('TPS_REALISE') + Qte);
        //
        TOBTMP.PutValue('REALISE_SAL_PA', TOBTMP.GetValue('REALISE_SAL_PA') + MontantPA);
        TOBTMP.PutValue('REALISE_SAL_PR', TOBTMP.GetValue('REALISE_SAL_PR') + MontantPR);
        TOBTMP.PutValue('REALISE_SAL_PV', TOBTMP.GetValue('REALISE_SAL_PV') + MontantPV);
  			//
  			if CEclatNatPrest.checked then
     			Begin
     			Repartition_Eclatement('MO'+NatPrestation, 'PA', MontantPA, TOBTMP);
     			Repartition_Eclatement('MO'+NatPrestation, 'PV', MontantPV, TOBTMP);
     			Repartition_Eclatement('MO'+NatPrestation, 'PR', MontantPR, TOBTMP);
     			Repartition_Eclatement('MO'+NatPrestation, 'QTE', Qte, TOBTMP);
     			end;
        end;
end;

Procedure TOF_BTTABLEAUBORD.Repartition_Frais(TypeRessource, FamNiveau1 : String; TobTMP : TOB);
begin
     if TypeRessource = 'INT' then
        begin
  	    // Traitement des intérimaires saisis en détail dans les frais
        TOBTMP.PutValue('REALISEPRESTATIONSPA', TOBTMP.GetValue('REALISEPRESTATIONSPA') + MontantPA);
        TOBTMP.PutValue('REALISEPRESTATIONSPR', TOBTMP.GetValue('REALISEPRESTATIONSPR') + MontantPR);
        TOBTMP.PutValue('REALISEPRESTATIONSPV', TOBTMP.GetValue('REALISEPRESTATIONSPV') + MontantPV);
        //
        TOBTMP.PutValue('REALISE_INTERIM_PA', TOBTMP.GetValue('REALISE_INTERIM_PA') + MontantPA);
        TOBTMP.PutValue('REALISE_INTERIM_PR', TOBTMP.GetValue('REALISE_INTERIM_PR') + MontantPR);
        TOBTMP.PutValue('REALISE_INTERIM_PV', TOBTMP.GetValue('REALISE_INTERIM_PV') + MontantPV);
			  //
        if CEclatFamNiv1.checked then
        	begin
     			if FamNiveau1 = '' Then FamNiveau1 := 'NONRENSEIGNE';
     			Repartition_Eclatement('FRSINT'+FamNiveau1, 'PA', MontantPA, TOBTMP);
     			Repartition_Eclatement('FRSINT'+FamNiveau1, 'PV', MontantPV, TOBTMP);
     			Repartition_Eclatement('FRSINT'+FamNiveau1, 'PR', MontantPR, TOBTMP);
     			end;
        end
     else
        begin
        // Realise main d'oeuvre salarie
        TOBTMP.PutValue('REALISE_SAL_PA', TOBTMP.GetValue('REALISE_SAL_PA') + MontantPA);
        TOBTMP.PutValue('REALISE_SAL_PR', TOBTMP.GetValue('REALISE_SAL_PR') + MontantPR);
        TOBTMP.PutValue('REALISE_SAL_PV', TOBTMP.GetValue('REALISE_SAL_PV') + MontantPV);
        //
        TOBTMP.PutValue('REALISEMOPA', TOBTMP.GetValue('REALISEMOPA') + MontantPA);
        TOBTMP.PutValue('REALISEMOPR', TOBTMP.GetValue('REALISEMOPR') + MontantPR);
        TOBTMP.PutValue('REALISEMOPV', TOBTMP.GetValue('REALISEMOPV') + MontantPV);
			  //
        if CEclatFamNiv1.checked then
        	begin
     			if FamNiveau1 = '' Then FamNiveau1 := 'NONRENSEIGNE';
     			Repartition_Eclatement('FRSMO'+FamNiveau1, 'PA', MontantPA, TOBTMP);
     			Repartition_Eclatement('FRSMO'+FamNiveau1, 'PV', MontantPV, TOBTMP);
     			Repartition_Eclatement('FRSMO'+FamNiveau1, 'PR', MontantPR, TOBTMP);
     			end;
        end;
end;

Procedure TOF_BTTABLEAUBORD.Repartition_MatOutil(TypeRessource, NatPrestation : String; TobTMP : TOB);
begin
     if TypeRessource = 'MAT' then
        begin
        TOBTMP.PutValue('REALISE_MAT_PA', TOBTMP.GetValue('REALISE_MAT_PA') + MontantPA);
        TOBTMP.PutValue('REALISE_MAT_PR', TOBTMP.GetValue('REALISE_MAT_PR') + MontantPR);
        TOBTMP.PutValue('REALISE_MAT_PV', TOBTMP.GetValue('REALISE_MAT_PV') + MontantPV);
  			if CEclatNatPrest.checked then
     			Begin
     			Repartition_Eclatement('MAT'+NatPrestation, 'PA', MontantPA, TOBTMP);
     			Repartition_Eclatement('MAT'+NatPrestation, 'PV', MontantPV, TOBTMP);
          Repartition_Eclatement('MAT'+NatPrestation, 'PR', MontantPR, TOBTMP);
     			Repartition_Eclatement('MAT'+NatPrestation, 'QTE', Qte, TOBTMP);
          end;
     		end
     else
        begin
        TOBTMP.PutValue('REALISE_OUTIL_PA', TOBTMP.GetValue('REALISE_OUTIL_PA') + MontantPA);
        TOBTMP.PutValue('REALISE_OUTIL_PR', TOBTMP.GetValue('REALISE_OUTIL_PR') + MontantPR);
        TOBTMP.PutValue('REALISE_OUTIL_PV', TOBTMP.GetValue('REALISE_OUTIL_PV') + MontantPV);
  			if CEclatNatPrest.checked then
     			Begin
     			Repartition_Eclatement('OUT'+NatPrestation, 'PA', MontantPA, TOBTMP);
     			Repartition_Eclatement('OUT'+NatPrestation, 'PV', MontantPV, TOBTMP);
          Repartition_Eclatement('OUT'+NatPrestation, 'PR', MontantPR, TOBTMP);
     			Repartition_Eclatement('OUT'+NatPrestation, 'QTE', Qte, TOBTMP);
          end;
        end;
     TOBTMP.PutValue('REALISEMATERIELSPA', TOBTMP.GetValue('REALISEMATERIELSPA') + MontantPA);
     TOBTMP.PutValue('REALISEMATERIELSPR', TOBTMP.GetValue('REALISEMATERIELSPR') + MontantPR);
     TOBTMP.PutValue('REALISEMATERIELSPV', TOBTMP.GetValue('REALISEMATERIELSPV') + MontantPV);
end;

//Répartition Intérim + Sous-traitance + Location + Autres
Procedure TOF_BTTABLEAUBORD. Repartition_IntSsTraitLocAut(TypeRessource, NatPrestation : String; TobTMP : TOB);
begin
     if TypeRessource = 'INT' then
        begin
        TOBTMP.PutValue('REALISE_INTERIM_PA', TOBTMP.GetValue('REALISE_INTERIM_PA') + MontantPA);
        TOBTMP.PutValue('REALISE_INTERIM_PR', TOBTMP.GetValue('REALISE_INTERIM_PR') + MontantPR);
        TOBTMP.PutValue('REALISE_INTERIM_PV', TOBTMP.GetValue('REALISE_INTERIM_PV') + MontantPV);
        TOBTMP.PutValue('TPS_REALISEINT', TOBTMP.GetValue('TPS_REALISEINT') + Qte);
        end
     else if TypeRessource = 'ST' then
        begin
        TOBTMP.PutValue('REALISE_ST_PA', TOBTMP.GetValue('REALISE_ST_PA') + MontantPA);
        TOBTMP.PutValue('REALISE_ST_PR', TOBTMP.GetValue('REALISE_ST_PR') + MontantPR);
        TOBTMP.PutValue('REALISE_ST_PV', TOBTMP.GetValue('REALISE_ST_PV') + MontantPV);
        end
     else if TypeRessource = 'LOC' then
        begin
        TOBTMP.PutValue('REALISE_LOC_PA', TOBTMP.GetValue('REALISE_LOC_PA') + MontantPA);
        TOBTMP.PutValue('REALISE_LOC_PR', TOBTMP.GetValue('REALISE_LOC_PR') + MontantPR);
        TOBTMP.PutValue('REALISE_LOC_PV', TOBTMP.GetValue('REALISE_LOC_PV') + MontantPV);
        end
     else if TypeRessource = 'AUT' then
        begin
        TOBTMP.PutValue('REALISE_AUTRE_PA', TOBTMP.GetValue('REALISE_AUTRE_PA') + MontantPA);
        TOBTMP.PutValue('REALISE_AUTRE_PR', TOBTMP.GetValue('REALISE_AUTRE_PR') + MontantPR);
        TOBTMP.PutValue('REALISE_AUTRE_PV', TOBTMP.GetValue('REALISE_AUTRE_PV') + MontantPV);
        end;
     TOBTMP.PutValue('REALISEPRESTATIONSPA', TOBTMP.GetValue('REALISEPRESTATIONSPA') + MontantPA);
     TOBTMP.PutValue('REALISEPRESTATIONSPR', TOBTMP.GetValue('REALISEPRESTATIONSPR') + MontantPR);
     TOBTMP.PutValue('REALISEPRESTATIONSPV', TOBTMP.GetValue('REALISEPRESTATIONSPV') + MontantPV);

  //
  if CEclatNatPrest.checked then
     Begin
     Repartition_Eclatement('EXT'+NatPrestation, 'PA', MontantPA, TOBTMP);
     Repartition_Eclatement('EXT'+NatPrestation, 'PV', MontantPV, TOBTMP);
     Repartition_Eclatement('EXT'+NatPrestation, 'PR', MontantPR, TOBTMP);
     Repartition_Eclatement('EXT'+NatPrestation, 'QTE', Qte, TOBTMP);
     end;

end;

Procedure TOF_BTTABLEAUBORD.MAJ_PremiereLigne(NomChampSup : String);
Begin

  if TOBBTB.Detail.count = 0 Then Exit;
  if Not TOBBTB.Detail[0].FieldExists(NomChampSup) then
  begin
     TOBBTB.Detail[0].AddChampSupValeur(NomChampSup, 0);
  end;

end;

Procedure TOF_BTTABLEAUBORD.Repartition_Eclatement(Eclatement, TypeMt : String; Montant : Double; TOBTMP : Tob);
Begin

  if Not TobTMP.FieldExists('CONSOMME' + Eclatement + TypeMt) then
  begin
     TOBTMP.AddChampSupValeur('CONSOMME' + Eclatement + TypeMt, Montant);
     MAJ_PremiereLigne('CONSOMME' + Eclatement + TypeMt);
  end else
     TOBTMP.PutValue('CONSOMME' + Eclatement + TypeMt, TOBTMP.GetValue('CONSOMME' + Eclatement + TypeMt) + Montant);

end;

procedure TOF_BTTABLEAUBORD.ChargeLeReste(TOBTMP : TOB);
var Req         : String;
    WherePiece  : string;
    QQ          : Tquery;
  //TOBTMP: TOB;
    Montant     : DOuble;
    Coef        : Double;
    TTC         : Double;
    HTX         : Double;
begin

  // Mise à jour des autres montants pour les chantiers concernés

  // recalcul du montant reglé par situations
  if CSelReglement.Checked then
     CalcReglementSituations(TOBTMP.GetValue('BCO_AFFAIRE'));

  // Calcul des Totaux Réalisés
  Montant := TOBTMP.GetValue('REALISEMOPA') +
             TOBTMP.GetValue('REALISEFOURNITURESPA') +
             TOBTMP.GetValue('REALISEMATERIELSPA') +
             TOBTMP.GetValue('REALISEPRESTATIONSPA') ;
  TOBTMP.PutValue('REALISETOTALPA', Montant);

  Montant := TOBTMP.GetValue('REALISEMOPR') +
             TOBTMP.GetValue('REALISEFOURNITURESPR') +
             TOBTMP.GetValue('REALISEMATERIELSPR') +
             TOBTMP.GetValue('REALISEPRESTATIONSPR') ;
  TOBTMP.PutValue('REALISETOTALPR', Montant);

  Montant := TOBTMP.GetValue('REALISEMOPV') +
             TOBTMP.GetValue('REALISEFOURNITURESPV') +
             TOBTMP.GetValue('REALISEMATERIELSPV') +
             TOBTMP.GetValue('REALISEPRESTATIONSPV') ;
  TOBTMP.PutValue('REALISETOTALPV', Montant);

  if (OptDetailDev in OptionChoixPrevuAvanc) then
     SetPrevuAvance (TOBTMP,'DBT',OptionChoixPrevuAvanc);

  if (OptDetailPBT in OptionChoixPrevuAvanc) or(OptGlobal in OptionChoixPrevuAvanc) then
     begin
     if TOBTMP.GetValue('BCO_AFFAIRE0')='I' then
        SetPrevuAvance (TOBTMP,'AFF',OptionChoixPrevuAvanc)
     else
       	SetPrevuAvance (TOBTMP,'PBT',OptionChoixPrevuAvanc);
     end;

  if (OptDetailETU in OptionChoixPrevuAvanc) then  SetPrevuAvance (TOBTMP,'ETU',OptionChoixPrevuAvanc);
  if (OptDetailBCE in OptionChoixPrevuAvanc) then  SetPrevuAvance (TOBTMP,'BCE',OptionChoixPrevuAvanc);

  Coef := 1;

  // Récupération du facturé
  Req := 'SELECT SUM(GP_TOTALHTDEV) AS FACTUREHT, SUM(GP_TOTALTTCDEV) AS FACTURE FROM PIECE ';
  if TOBTMP.GetValue('BCO_AFFAIRE0')='A' then
     WherePiece := '(GP_NATUREPIECEG = "FBT" OR GP_NATUREPIECEG = "ABT" OR GP_NATUREPIECEG = "FAC" OR GP_NATUREPIECEG = "AVC")'
  else
     WherePiece := '(GP_NATUREPIECEG = "FAC" OR GP_NATUREPIECEG = "AVC")';

  req := req + 'WHERE '+ WherePiece;
  Req := Req + '  AND GP_AFFAIRE="' + TOBTMP.GetValue('BCO_AFFAIRE') + '"';
  Req := Req + '  AND GP_DATEPIECE BETWEEN "' + UsDateTime(DateMvtDeb) + '"';
  Req := Req + '  AND "' + UsDateTime(DateMvtFin) + '" ';
  Req := Req + 'GROUP BY GP_AFFAIRE';

  QQ := OpenSQL(Req, true,-1,'',true);

  if QQ.EOF then
     Begin
     Ferme(QQ);
     exit;
     end;


  HTX := QQ.findfield('FACTUREHT').AsFloat;
  TOBTMP.PutValue('FACTUREHT', HTX);

  TTC := QQ.findfield('FACTURE').AsFloat;
  TOBTMP.PutValue('FACTURE', TTC);

  // Calcul approximatif du REGLE HT
  if HTX <> 0 then
     Coef := TTC / HTX
  else
     Coef := 1;

  ferme(QQ);

//Récupération facturé détaillé
	if (OptDetailFAC in OptionChoixPrevuAvanc) then
    begin
    // Clause Where à transmettre à la fonction pour prise en compte
    // des natures de pièces à traiter et des dates
  	WherePiece := WherePiece + ' AND GP_AFFAIRE="' + TOBTMP.GetValue('BCO_AFFAIRE') + '"';
  	WherePiece := WherePiece + ' AND GP_DATEPIECE BETWEEN "' + UsDateTime(DateMvtDeb) + '"';
  	WherePiece := WherePiece + ' AND "' + UsDateTime(DateMvtFin) + '" ';

  	SetPrevuAvance (TOBTMP,'FBT',OptionChoixPrevuAvanc,WherePiece);
  end;

//Recuperation du regle
  if CSelReglement.Checked then
     Begin
     TTC := GetReglementAffaire(TOBTMP.GetValue('BCO_AFFAIRE'));
     TOBTMP.PutValue('REGLE', TTC);
     if Coef = 0.0 then HTX := 0.0
     else HTX := TTC / Coef;
     TOBTMP.PutValue('REGLEHT', HTX);
     end;


(* ----
      // Récupération du prévu et de l'avancé
      Req := 'SELECT SUM(GL_QTEFACT*GL_DPA) AS ACHAT, SUM(GL_QTEFACT*GL_DPR) AS REVIENT, SUM(GL_QTEFACT*GL_PUHTNETDEV) AS VENTE, ' +
        'SUM(GL_QTEPREVAVANC*GL_DPA) AS AVANCEPA, SUM(GL_QTEPREVAVANC*GL_DPR) AS AVANCEPR, SUM(GL_QTEPREVAVANC*GL_PUHTNETDEV) AS AVANCEPV ' +
        'FROM LIGNE ' +
        'WHERE GL_NATUREPIECEG = "PBT" AND GL_AFFAIRE="' + TOBTMP.GetValue('BCO_AFFAIRE') + '"' +
        'GROUP BY GL_AFFAIRE';
      QQ := OpenSQL(Req, true);
      if not QQ.EOF then
      begin
        Montant := QQ.findfield('ACHAT').AsFloat;
        TOBTMP.PutValue('PREVUPA', Montant);
        Montant := QQ.findfield('REVIENT').AsFloat;
        TOBTMP.PutValue('PREVUPR', Montant);
        Montant := QQ.findfield('VENTE').AsFloat;
        TOBTMP.PutValue('PREVUPV', Montant);
        Montant := QQ.findfield('AVANCEPA').AsFloat;
        TOBTMP.PutValue('AVANCEPA', Montant);
        Montant := QQ.findfield('AVANCEPR').AsFloat;
        TOBTMP.PutValue('AVANCEPR', Montant);
        Montant := QQ.findfield('AVANCEPV').AsFloat;
        TOBTMP.PutValue('AVANCEPV', Montant);
      end;
      ferme(QQ);

      // Récupération du total des heures prévues et avancées
      Req := 'SELECT SUM(GL_QTEFACT) AS TPS_PREVU, SUM(GL_QTEPREVAVANC) AS TPS_AVANCE ' +
        'FROM LIGNE ' +
        'LEFT JOIN ARTICLE ON GA_ARTICLE=GL_ARTICLE '+
        'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=GA_NATUREPRES '+
        'WHERE GL_NATUREPIECEG = "PBT" AND BNP_TYPERESSOURCE="SAL" AND GL_AFFAIRE="' + TOBTMP.GetValue('BCO_AFFAIRE') + '"' +
        ' GROUP BY GL_AFFAIRE';
      QQ := OpenSQL(Req, true);
      if not QQ.EOF then
      begin
        Montant := QQ.findfield('TPS_PREVU').AsFloat;
        TOBTMP.PutValue('TPS_PREVU', Montant);
        Montant := QQ.findfield('TPS_AVANCE').AsFloat;
        TOBTMP.PutValue('TPS_AVANCE', Montant);
      end;
      ferme(QQ);
*)
      //
    //Req := 'SELECT SUM(GP_TOTALHTDEV) AS FACTUREHT, SUM(GP_TOTALTTCDEV) AS FACTURE, SUM(GP_ACOMPTE) AS REGLE ' +
(*
     Req := 'SELECT SUM(BST_MONTANTREGL) AS REGLE ' +
            'FROM BSITUATIONS ' +
            'WHERE (BST_NATUREPIECE = "FBT" OR BST_NATUREPIECE = "ABT") AND BST_AFFAIRE="' + TOBTMP.GetValue('BCO_AFFAIRE') + '"';
     QQ := OpenSQL(Req, true);
     if not QQ.EOF then
        begin
        TTC := QQ.findfield('REGLE').AsFloat;
        TOBTMP.PutValue('REGLE', TTC);
        HTX := TTC / Coef;
        TOBTMP.PutValue('REGLEHT', HTX);
        end;
     ferme(QQ);
*)
//
    //end;

end;

Function TOF_BTTABLEAUBORD.PrevueVide(TOBL : TOB) : boolean;
begin
    result := (TOBL.GetValue('PREVUPA')= 0.0) and
    					(TOBL.GetValue('PREVUPR')=  0.0) and
    					(TOBL.GetValue('PREVUPV')= 0.0) and
    					(TOBL.GetValue('TPS_PREVU')= 0.0);
end;

Function TOF_BTTABLEAUBORD.RealiseVide(TOBL : TOB) : boolean;
begin
    result := (TOBL.GetValue('REALISETOTALPA')= 0.0) and
    					(TOBL.GetValue('REALISETOTALPR')=  0.0) and
    					(TOBL.GetValue('REALISETOTALPV')= 0.0) and
    					(TOBL.GetValue('TPS_REALISE')= 0.0);
end;

function TOF_BTTABLEAUBORD.AvanceVide(TOBL : TOB) : boolean;
begin
   result := (TOBL.GetValue('AVANCEPA')= 0.0) and
    					(TOBL.GetValue('AVANCEPR')=  0.0) and
    					(TOBL.GetValue('AVANCEPV')= 0.0) and
    					(TOBL.GetValue('TPS_AVANCE')= 0.0);
end;

function TOF_BTTABLEAUBORD.FactureVide(TOBL : TOB) : boolean;
begin
    result := (TOBL.GetValue('FACTUREHT')= 0.0) and
    					(TOBL.GetValue('FACTURE')=  0.0) and
    					(TOBL.GetValue('REGLE')= 0.0) and
    					(TOBL.GetValue('REGLEHT')= 0.0);
end;

function TOF_BTTABLEAUBORD.EngageVide(TOBL : TOB) : boolean;
begin
    result := (TOBL.GetValue('ENGAGEFOU')= 0.0) and
    					(TOBL.GetValue('ENGAGECHA')=  0.0) and
    					(TOBL.GetValue('FACTNONPAR')= 0.0);
end;

Function  TOF_BTTABLEAUBORD.LigneVide (TOBL : TOB) : boolean;
begin
  	result := false;
  	if PrevueVide(TOBL) and RealiseVide(TOBL) and
       AvanceVide(TOBL) and FactureVide(TOBL) and
       EngageVide(TOBL) and (TOBL.GetValue('COURECANN')=0.0) then result:= true;
end;


//var Indice : integer;
//		TOBTMP : TOB;
//begin
//  Indice := 0;
//  repeat
//  	TOBTMP := TOBBTB.Detail[indice];
//    if LigneVide(TOBTMP) then TOBTMP.free else Inc(Indice);
//  until Indice >= TOBBTB.detail.count;
//end;

procedure TOF_BTTABLEAUBORD.CChoixClick(Sender: TObject);
begin

  THAffaire0.text := 'A';

  	if CCumulAffaire.checked then
  	begin
    T_Affaire.Caption := 'Chantier associé';
    Exit;
  	end;

   if (CChantier.checked) and (not CContrat.Checked ) And (not CAppel.Checked ) then
      Begin
      T_Affaire.Caption := 'Chantier';
      end
   Else if (CChantier.checked) and (CContrat.Checked) and (CAppel.Checked) then
      begin
      T_Affaire.Caption := 'Affaire';
      end
   Else if (CChantier.checked) and (not CContrat.Checked) and (CAppel.Checked) then
      begin
      T_Affaire.Caption := 'Affaire';
      end
   Else if (CChantier.checked) and (CContrat.Checked) and (not CAppel.Checked) then
      begin
      T_Affaire.Caption := 'Affaire';
      end
   Else if (not CChantier.checked) and (not CContrat.Checked) And (not CAppel.Checked) then
      begin
      T_Affaire.Caption := 'Affaire';
      end
   Else if (not CChantier.checked) and (CContrat.Checked) And (CAppel.Checked) then
      begin
      T_Affaire.Caption := 'Affaire';
      end
   Else if (not CChantier.checked) and (CContrat.Checked) And (not CAppel.Checked) then
      Begin
      T_Affaire.Caption := 'Contrat';
      THAffaire0.text := 'I';
      end
   Else if (not CChantier.checked) and (not CContrat.Checked) And (CAppel.Checked) then
      Begin
      T_Affaire.Caption := 'Appel';
      THAffaire0.text := 'W';
      end
   Else
      Begin
      T_Affaire.Caption := 'Chantier';
      end;
  //
  //ChargeCleAffaire(THAffaire0, THAffaire1, THAffaire2, THAffaire3, THAvenant, nil, TaModif, THAffaire.Text, false);
  //

end;

Function TOF_BTTABLEAUBORD.ChargeAffaireRef(CodeAffaire, AffaireSaisie : String) : String;
Var QQ  : Tquery;
    Req : String;
Begin

  Result := '';

  If Copy(CodeAffaire, 1, 1) =  'A' then
     Begin
     Result := CodeAffaire;
     exit;
     end;

  //Récupération du code affaire dans les lignes d'appel
  Req := 'SELECT AFF_CHANTIER FROM AFFAIRE WHERE AFF_AFFAIRE = "' + CodeAffaire + '"';

  QQ := OpenSQL(Req, true,-1,'',true);
  if QQ.EOF then
     begin
     ferme(QQ);
     exit;
     end;

  Result := QQ.findfield('AFF_CHANTIER').AsString;

  ferme(QQ);

  if AffaireSaisie = '' then exit;

  if Result = '' then
     Begin
     Req := 'SELECT AFF_CHANTIER FROM AFFAIRE WHERE AFF_AFFAIRE = "' + AffaireSaisie + '"';
     QQ := OpenSQL(Req, true,-1,'',true);
     if QQ.eof then
        Begin
        ferme(QQ);
        exit;
        end;
     Result := QQ.findfield('AFF_CHANTIER').AsString;
     ferme(QQ);
     end;

end;

procedure TOF_BTTABLEAUBORD.CCumulAffaireClick(Sender: TObject);
begin
	CChoixClick(Self);
end;


initialization
  registerclasses([TOF_BTTABLEAUBORD]);
end.

