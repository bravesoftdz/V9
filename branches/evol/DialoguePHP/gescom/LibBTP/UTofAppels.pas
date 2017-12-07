{***********UNITE*************************************************
Auteur  ...... : VAUTRAIN
Créé le ...... : 18/04/2005
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : gestion des appels
                 dans le module d'interventions ()
Mots clefs ... : TOF;UTOFAPPEL
*****************************************************************}
Unit UTofAppels;

Interface

Uses StdCtrls,
     Controls,
     Graphics,
     Classes,
     FileCtrl,
     Messages,
     ShellAPI,
     Windows,
     Doc_Parser,
     UtilPGI,
     BTPUtil,
     HDB,
{$IFDEF CTI}
     CtiGrc,CTiPcb,
     UtilCti,
{     BTPCtiPcb,}
//     HeureUtil,
     EntRt,
{$ENDIF}

{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
     Fe_Main,
     EdtREtat,
     EdtRDoc,
{$else}
     eMul,
     Maineagl,
     UtileAGL,
{$ENDIF}
     forms,
     vierge,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOB,
     EntGC,
     AppelsUtil,
     AffaireUtil,
     CalcOleGenericBTP,
     AglInitGc,
     UTOF,
     TiersUtil,
     Lookup,
     HTB97,
     HPanel,
     Ent1,
     Facture,
     FactUtil,
     AglInit,
     FactAdresse,
     uRecupSQLModele,
     Paramsoc,
     HRichOle,
     AglMail,
     MailOl,
     BTPLANNING,
     UTOF_BTRECHCONTACT,
     MsgUtil,
     PlanUtil,uEntCommun,UtilRT;

Type
  TOF_APPEL = Class (TOF)
  private
    procedure PositionneEtabUser(NomChamp: string);
  public
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (Argument : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;


  Private

    GestGrille     : AffGrille;
    HeureDeb       : TDateTime;
    CtiHeureDebCom : TDateTime;
    CtiHeureFinCom : TDateTime;

    AFTypeAction   : TActionFiche;

    TToolAffect	   : TToolWindow97;
    TToolEvenement : TToolWindow97;
    TToolConso     : TToolWindow97;

    Adresse1    : THEdit;
    AdresseInt  : THEdit;
    Client      : THEdit;
    CodePostal  : THEdit;
    Contact     : THEdit;
    Contrat     : THEdit;
    Contrat3    : THEdit;
    NomContact  : THEdit;
    NomTiers    : THEdit;
    Responsable : THEdit;
    Risque      : THEdit;
    Telephone   : THEdit;
    Fax         : THEdit;
    Telex       : THEdit;
    Ville       : THEdit;
    Chantier    : THEdit;

    AFF_APPEL0  : THEdit;
    AFF_APPEL1  : THEdit;
    AFF_APPEL2  : THEdit;
    AFF_APPEL3  : THEdit;
    APP_AVENANT : THEdit;

    ETATAFFAIRE : THValComboBox;
    PRIOCONTRAT : THValComboBox;
    CHKTACHES   : TCheckBox;

    FeuVert     : TToolbarButton97;
    FeuOrange   : TToolbarButton97;
    FeuRouge    : TToolbarButton97;
    BTContact   : TToolbarButton97;
    BTContrat   : TToolbarButton97;
    BTChantier  : TToolbarButton97;
    BTHAUTE     : TToolbarButton97;
    BTNORMALE   : TToolbarButton97;
    BTBASSE     : TToolbarButton97;
    BTNEW       : TToolbarButton97;
    BTMAINTEL   : TToolbarButton97;
    BTHISTORIQUE: TToolbarButton97;
    BTLIGNE     : TToolBarButton97;
    BImprimer   : TToolBarButton97;
    BTConso     : TToolBarButton97;
    BPhone      : TToolBarButton97;
    BAttente    : TToolBarButton97;
    BEffaceApp	: TToolBarButton97;
    BEffaceCon	: TToolBarButton97;
    BEffaceCha  : TToolBarButton97;
    BEffaceClt  : TToolBarButton97;
    BEffaceRes  : TToolBarButton97;
    BStop       : TToolBarButton97;

    BPlanning 	: TToolBarButton97;
    BTELDOM,BTELBUR,BTELPORT : TToolbarButton97;

    BTAffectation : TToolbarButton97;

    Lib_Affaire  : THLabel;
    AFF_LIBELLE  : THEdit;
    DESCRIPTIF  : THRichEditOLE;

    //Gestion de l'affichage historique
    PanelAffectation  : THPanel;
    PanelEvenement    : THPanel;
    PanelConso        : THPanel;

    GrilleAffectation : THGrid;
    GrilleEvenement   : THGrid;
    GrilleConso       : THGrid;

    DetailAppel    	  : THRichEditOLE;
    DetailInt     	  : THRichEditOLE;
    Lib_DetailAppel   : THLabel;
    Lib_DetailInt     : THLabel;

    Affaire0     : String;
    CodeAppel    : String;
    CodeContrat  : String;
    CodeChantier : String;
    EtabChantier : String;

    CodeEtat    : string;
    CodeTiers   : String;
    CleTel   		: String;
    Auxiliaire  : String;
    Titre       : String;
    Status      : String;
    Devise      : string;
    EtatRisque  : string;
    Importance  : String;
    AppelantCTI : string;
    WhereUpdate : String;
    ParamCti    : String;

    FactureHT	  : String;

    P0          : String;
    P1          : String;
    P2          : String;
    P3          : String;
    Avn         : String;

    FirstWay       : Boolean;
    ChargeGrille   : Boolean;
    Ok_SaisieAppel : Boolean;
    AppelCtiOk	   : Boolean;
    SerieCTI		   : Boolean;
    AppelCti		   : Boolean;
    CtiCCA 			   : Boolean;
    AppelPlan		   : Boolean;


    NoAdresse   : Integer;
    NbPiece     : integer;

    CleDocAffaire  : R_CLEDOC;

    OldAdr1     : String;
    OldCP       : String;
    OldNomCon   : string;
    OldNomTie   : String;
    OldNoTel    : String;
    OldTiers    : String;
    OldVille    : String;

    AdrMailClt	: String;
    AdrMailRes	: String;
    AdrMailAge  : String;

    TypeAction	: String;

    TobAppel    : Tob;
    TobAdrInt   : Tob;

    TobHistoAppel : Tob;
    TobEventAppel : Tob;
    TobConsoAppel : Tob;

    //Declaration Procédure
    Procedure AfficheAdresseIntervention(TobAdrInt : tob);
    Procedure AfficheAnnule;
    Procedure AfficheChantier(TobChantier: tob);
    Procedure AfficheContact(TobContact : tob);
    Procedure AfficheContrat(TobContrat : tob);
    Procedure AfficheErreur;
    Procedure AfficheGroupContrat(Enable: Boolean);
    Procedure AfficheResponsable(TobRessource : tob);
    Procedure AfficheTiers(TobTiers : Tob);
    Procedure AppelContactTiers(Requete: string);
    Procedure AppelRechTiers(Arg: string);
    procedure ChargeAffectation;
    Procedure ChargeConso;
    procedure ChargeEvenement;
    Procedure ChargementAppel;
    Procedure ChargementContact(TobContact: tob);
    Procedure ChargeHistorique;
    Procedure ControleChamp(Champ, Valeur: String);
    Procedure ControleCritere(Critere: String);
    procedure DecoupeYTContact (Var Param1: string; Var Param2 : string);
    Procedure DefiniLibelle;
    procedure DefiniToolAffect;
    procedure DefiniToolConso;
    procedure DefiniToolEvenement;
    Procedure EcranConsultation;
    Procedure EditeMaquetteWord;
    Procedure GestionCalculAutoNumAppel;
    Procedure GestionDuMail(TypeMail, AdresseMail : String; BlocNote : THRichEditOLE);
    procedure GestionSaisieNumAppel;
    Procedure InitGrille;
    Procedure LectureAdresseIntervention;
    Function  LectureChantier : Boolean  ;
    Procedure LectureContact;
    Procedure LectureContrat;
    Procedure LectureResponsable;
    Procedure LectureRessourceAssociee (Utilisateur : String; Var CodRes, LibRes : String);
    Procedure LectureUtilisateur;
    procedure MajEvenement;
    Procedure Raz_Zone_Ecran;
    Procedure RechContactTiers;
    Procedure RechContratTiers;
    procedure SetCleAffaireEnabled(bEnabled: Boolean);
    procedure VerifieAffectation;


    //Procedure propre à l'ensemble des zones de la fiche
    Procedure Adresse1Exit(sender : TObject);
    Procedure AppelAdresseLiv(sender : TObject);
    procedure AppelClient(Sender : TObject);
    Procedure AppelContact(sender: Tobject);
    Procedure AppelContrat(sender: Tobject);
    Procedure AppelExit(Sender: TObject);
    Procedure AppelResponsable(sender: Tobject);
    Procedure BasseClick(sender : TObject);
    procedure BEffaceChaClick(Sender: TObject);
    procedure BEffaceCltClick(Sender: TObject);
    procedure BEffaceConClick(Sender: TObject);
    procedure BEffaceResClick(Sender: TObject);
    procedure BImprimerClick(Sender: TObject);
    procedure BTHistoriqueClick(Sender: Tobject);
    Procedure BTLigneClick(Sender: TObject);
    Procedure BPhoneClick(Sender: TObject);
    Procedure BPlanningClick(Sender: TObject);
    Procedure ChantierExit(sender : TObject);
    procedure CHKTACHESClick(Sender: TObject);
    Procedure ClientExit (Sender : TObject);
    Procedure CodePostalExit(sender : TObject);
    procedure ContratExit(Sender: TObject);
    Procedure CtrlResponsable (Sender : TObject);
    procedure EtatAffaireOnChange(Sender: TObject);
    Procedure FaxExit(sender : TObject);
    Procedure FicheActivate(Sender : TObject);
    Procedure GestionFeuEncour(sender : TObject);
    Procedure GrilleAffectationDBLClick(Sender: TObject);
    procedure GrilleAffectationClick(Sender: TObject);
    Procedure GrilleEvenementDBLClick(Sender: TObject);
    Procedure HauteClick(sender : TObject);
    procedure ListeAffectation(Sender: TObject);
    procedure MaintenanceTel(Sender: TObject);
    Procedure NomContactExit(sender : TObject);
    Procedure NomTiersExit(sender : TObject);
    Procedure NormaleClick(sender : TObject);
	  procedure OnGetVar(Sender: TObject; VarName: string; VarIndx: Integer; Var Value: variant);
	  Procedure OnNewRecord(sender : TObject);
    Procedure PrioContratOnChange(Sender: TObject);
	  Procedure TelephoneExit(sender : TObject);
    Procedure TelExit(sender : TObject);
    procedure TToolAffectClose(sender : TObject);
    procedure TToolConsoClose(sender: TObject);
    procedure TToolEventClose(sender: TObject);
    Procedure villeExit(sender : TObject);
    procedure VisualisationConso(Sender : TObject);
    Procedure VoirAdrInt(Sender: TObject);
    procedure VoirChantier(Sender: TOBJect);
    Procedure VoirContacts(Sender: TOBJect);
	  Procedure VoirContrats(Sender: TOBJect);
    Procedure VoirEncours(sender : TObject);
    Procedure VoirResponsable(sender : TObject);
    Procedure DescriptifExit(sender : TObject);

    //Declaration Fonction
    function ClientFerme(FERME: String): Boolean;
    function ControleAdresseInt(NatAux: string): Boolean;
    function ControleDevise: Boolean;
    function ControlRisque: boolean;
    Function CtrlExitZoneContact(NomZone, ZoneTxt: String) : boolean;
    function CtrlExitZoneTiers(NomZone, ZoneTxt: String): boolean;
    function CtrlNomAdresse(NomZone, ZoneTxt: String): Boolean;
    function FabricNomWord: string;
    function LectureTiers: Boolean;
    function RisqueTiers: String;
    procedure SetInfosTel(Etat: boolean);
    procedure ComplementsClick (Sender : Tobject);
    procedure BTELBUR_OnClick(Sender: TObject);
    procedure BTELDOM_OnClick(Sender: TObject);
    procedure BTELPORT_OnClick(Sender: TObject);
    procedure BAttenteClick(Sender: TObject);
    procedure BStopClick(Sender: TObject);
    procedure SetEtatBoutonCti;
    procedure BVisuParcClick (Sender : TObject);
    //
  end;

const

	// libellés des messages
  TexteMessage: array[1..39] of string  = (
      {1}   'Le code doit être renseigné',
      {2}   'Le contrat n''est plus sous garantie',
	  	{3}   'Le contrat est arrivé à expiration le ',
	 		{4}   'Le Contrat est résilié depuis le ',
      {5}   'Le Descriptif de l''appel est obligatoire',
      {6}   'Code appel non valide',
      {7}	  'Code client non valide',
      {8}   'Contact inexistant, veuillez vérifier l''orthographe',
      {9}   'Ce contact n''est associé à aucun tiers',
      {10}  'Confirmez vous la mise à jour de ',
      {11}  'Code client non renseigné',
      {12}  'Suppression impossible Cet appel est utilisée sur des lignes d''activités',
      {13}  'Suppression impossible Cet appel est utilisée sur des lignes de pièces',
      {14}  'Suppression impossible Cet appel est utilisée sur des pièces',
      {15}  'Suppression impossible Cet appel est utilisée par un planning.',
      {16}  'Désirez(-vous créer ce contact pour votre tiers ',
			{17}  'Création de l''appel impossible sur un client fermé',
      {18}  'Création de l''appel impossible, la ressource n''existe pas',
      {19}  'La ressource est obligatoire',
      {20}  'Renseignez un modèle d''édition WORD dans les paramètres sociétés',
      {21}  'Renseignez un répertoire de stockage dans les paramètres sociétés',
      {22}  'Le Répertoire des modèles n''existe pas',
      {23}  'Le Fichier modèle n''existe pas',
      {24}  'Client inexistant',
      {25}  'Ce client a un état comptable rouge, la création d''affaires est impossible',
      {26}  'Attention : Ce client a un état comptable orange',
			{27}  'Attention : Ce client a un état comptable rouge',
      {28}  'Voulez-vous envoyer un Mail de confirmation au client',
      {29}  'Voulez-vous envoyer un Mail de confirmation au Responsable',
      {30}  'Le Contact est obligatoire',
      {31}  'Plus d''une pièce associée à l''affaire',
      {32}  'Vous venez du planning la ressource est obligatoire',
      {33}  'Création de l''évènement impossible pas de compteur "BEP"',
      {34}  'Voulez-vous placer l''intervenant en copie ?',
      {35}  'le paramétrage du code affaire est différent de celui de l''appel !',
      {36}  'Ce client est fermé',
      {37}  'Pas d''Adresse d''intervention pour ce Client',
      {38}  'Le regroupement d''appel sur facture impose d''avoir un code chantier associé.' + chr(10) + 'dans le cas contraire le regroupement sera impossible',
      {39}  'Le chantier associé est inconnu.'
                      );

	// Nom des champs à formater
	ChpAFormater: array[1..6] of string 	= (
          {1}   'TLIBELLE',
          {2}   'T_PRENOM',
          {3}   'T_ADRESSE1',
          {4}   'T_ADRESSE2',
          {5}   'T_ADRESSE3',
          {6}   'T_VILLE'
                                          );
{ pour forcer dans le cas d'une numérotation infructueuse : }
{	erreur connexion}
  ModeAppelSortant : integer = 1 ;

Implementation

uses ctiAlerte,factcomm;

procedure TOF_APPEL.OnNew;
Var StNotel,CodeAppel : string;
begin
  inherited;

  Affaire0 := 'W';
  Status := 'APP';
  Importance := '2';
  TypeAction := GetParamSoc('SO_TYPEACTION');

  Client.Enabled := True;
  NomContact.Enabled := True;
  Telephone.Enabled := True;

  ControleChamp('ACTION', 'CREATION');
  ControleChamp('ETAT', 'ECO');

  //Chargement du N° de l'Appel
	Lib_Affaire.Caption := '';

//  CodeTiers    := '';
  CodeAppel    := '';
  CodeContrat  := '';
  CodeChantier := '';
  EtabChantier := '';

  CodeEtat := 'ECO';
  NoAdresse   := 0;
  Auxiliaire  := '';
  Titre       := '';
  Devise      := '';
  EtatRisque  := '';

  OldAdr1     := '';
  OldCP       := '';
  OldNomCon   := '';
  OldNomTie   := '';
  OldNoTel    := '';
  OldTiers    := '';
  OldVille    := '';

  SetControlText('CAFF_AFFAIRE0','W');
  SetControlText('CAFF_AFFAIRE1','');
  SetControlText('CAFF_AFFAIRE2','');
  SetControlText('CAFF_AFFAIRE3','');
  SetControlText('CAFF_AVENANT','00');

  SetControlText('AFF_APPEL0','W');
  SetControlText('AFF_APPEL1','');
  SetControlText('AFF_APPEL2','');
  SetControlText('AFF_APPEL3','');
  SetControlText('APP_AVENANT','00');

  SetControlText('AFF_LIBELLE','');

  Ok_SaisieAppel := False;

  Ok_SaisieAppel := GetParamSocSecur('SO_SAISIECODEAPPEL', False);

  SetControlProperty('AFF_AFFAIRE', 'VISIBLE', not Ok_SaisieAppel);
  SetControlProperty('AFF_AFFAIRE', 'VISIBLE', not Ok_SaisieAppel);

  SetControlProperty('GROUPAPPEL', 'VISIBLE', Ok_SaisieAppel);
  SetControlProperty('GROUPAPPEL', 'VISIBLE', Ok_SaisieAppel);

  SetControlProperty('AFF_DATESOUHAIT','Enabled', True);
  SetControlProperty('AFF_HEURESOUHAIT','Enabled', True);

  SetControlProperty('TAFF_DATEINT', 'Visible', false);
  SetControlProperty('AFF_DATEINT', 'Visible', false);
  SetControlProperty('TAFF_DATEINT2', 'Visible', false);
  SetControlProperty('AFF_HEUREINT', 'Visible', false);
  //Initialisation des zones ecran
  Raz_Zone_Ecran;

	if CodeTiers <> '' then
  begin
  	Client.Text := CodeTiers;
    ClientExit(self); 
  end;

  if ok_SaisieAppel then
     Begin
     if AFTypeAction = TaModif then
        SetCleAffaireEnabled(false)
     else
        SetCleAffaireEnabled(true) ;
     end;

  //Controle CTI
  if AppelantCTI <> '' then
     begin
     if GetParamSoc('SO_RTSUPPZERO') then StNotel:='0'+AppelantCTI;
     Telephone.text := StNotel;
     end;

  if AppelPlan then
     Begin
     BPlanning.Visible := not AppelPlan;
     BTNew.Visible := not AppelPlan;
     end
  else
     BPlanning.Visible := GetParamSocSecur('SO_AFFRAPIDE', False);

  if not Ok_SaisieAppel then
     Begin
     Lib_Affaire.Caption := 'APPEL N° ----------';
     Client.SetFocus;
     //SetFocusControl('AFF_TIERS');
     End
  else
     SetFocusControl('AFF_APPEL1');

  CalculeCodeAffaire (THEDIT(GetControl('AFF_APPEL0')) , THEDIT (GetControl ('AFF_APPEL1') ) , THEDIT (GetControl ('AFF_APPEL2') ) ,
                      THEDIT(GetControl('AFF_APPEL3')) , THEDIT (GetControl ('APP_AVENANT') ) , nil, AFTypeAction, CodeAppel , True,True) ;

  PositionneEtabUser ('AFF_ETABLISSEMENT') ;
end;

Procedure TOF_APPEL.GestionCalculAutoNumAppel;
Begin

  // Si en création calcul du N° d'appel
    CodeAppel := CalculCodeAppel(getcontrolText('CAFF_AFFAIRE0'),
                                 getcontrolText('CAFF_AFFAIRE1'),
                                 getcontrolText('CAFF_AFFAIRE2'),
                                 getcontrolText('CAFF_AFFAIRE3'),
                                 getcontrolText('CAFF_AVENANT'),
                                 client.Text);
                                 //getcontrolText('AFF_TIERS'));
  // test si code appel à blanc (sans ignorer la présence du statut et de l’avenant)
  if Trim(Copy(CodeAppel,2,14)) = '' then Exit;
  //
  GestionSaisieNumAppel;
  //
  if GetControlText('CAFF_AVENANT') <> '00' then
     Lib_Affaire.Caption := 'APPEL N° ' + P1 + P2 + P3 + ' - (' + Avn + ')'
  else
     Lib_Affaire.Caption := 'APPEL N° ' + P1 + P2 + P3;

end;

procedure TOF_APPEL.SetCleAffaireEnabled (bEnabled: Boolean) ;
begin

  AFF_APPEL0.Enabled := Benabled;
  AFF_APPEL1.Enabled := Benabled;
  AFF_APPEL2.Enabled := Benabled;
  AFF_APPEL3.Enabled := Benabled;

  APP_AVENANT.Enabled := Benabled;

  Client.Enabled := Benabled;

end;

//Suppression d'une fiche appel
procedure TOF_APPEL.OnDelete ;
var DateSupprime : TDateTime;
    Arg          : String;
    QQ					 : TQuery;
    TOBparam     : Tob;
    Return    	 : string;
begin
  Inherited ;

  TOBParam := TOB.Create ('SUPPAPPEL',nil,-1);
  TOBParam.AddChampSupValeur  ('RETOUR','-');

  if PGIAsk('Confirmez vous la suppression de cet appel ?', Ecran.caption) = mrNo then exit;

  DateSupprime := now;

  //Contrôle si l'appel n'est pas déjà affecté.
  Arg := 'SELECT BEP_CODEEVENT FROM BTEVENPLAN WHERE BEP_AFFAIRE="' + CodeAppel + '"';
  QQ := OpenSQL(Arg, true);
  if Not QQ.Eof then
     Begin
     //Message d'erreur
     LastError := 15;
     AfficheErreur;
     Ferme(QQ);
     LastError := 0;
     Exit;
     end;

  Ferme(QQ);

  //Saisie du motif de l'annulation
  Arg := 'ACTION=CREATION;';
  Arg := Arg + 'ETAT=ANN;';
  Arg := Arg + 'APPEL='+ CodeAppel + ';';
  Arg := Arg + 'AFFAIRE0=' + GetControlText('CAFF_AFFAIRE0')+ ';';
  Arg := Arg + 'AFFAIRE1=' + GetControlText('CAFF_AFFAIRE1')+ ';';
  Arg := Arg + 'AFFAIRE2=' + GetControlText('CAFF_AFFAIRE2')+ ';';
  Arg := Arg + 'AFFAIRE3=' + GetControlText('CAFF_AFFAIRE3')+ ';';
  Arg := Arg + 'AVENANT=' + GetControlText('CAFF_AVENANT')+ ';';
  Arg := Arg + 'DATE=' + DatetoStr(DateSupprime);

  TheTOB := TOBparam;
  AGLLanceFiche ('BTP','BTANNULAPP','','',Arg);

  //retour de saisie si annule ou validation
  return := TOBparam.GetValue('RETOUR');
  TOBparam.free;

  TheTOB := nil;

  if return <> 'X' then exit;

  //suppression de l'appel
  CodeEtat := 'ANN';
  TobAppel.PutValue('AFF_ETATAFFAIRE', 'ANN');

  //Chargement des dates et heure
  TobAppel.PutValue('AFF_DATEFIN', DateSupprime);
  TobAppel.setAllModifie(true);
  TobAppel.UpdateDB(true);

	ecran.Close;


end ;

//Mise a jour d'une fiche appel
procedure TOF_APPEL.OnUpdate ;
Var QAdr     	  : TQuery;
    //TempoDate   : TDateTime;
    BlocNote 	  : THRichEditOLE;
    iPartErreur : integer;
begin
  Inherited ;

  //Contrôle de la saisie du tiers
  //if GetControlText('AFF_TIERS') = '' then
  if Client.Text = '' then
     Begin
     LastError := 11;
     AfficheErreur;
     Client.SetFocus;
     TFVierge(Ecran).ModalResult := 0;
     Exit;
     End;

	//Contrôle de la saisie du contact en fonction paramètre
  If GetParamSoc('SO_OBLIGECONTACT') then
     Begin

     if GetControlText('T_NOMCONTACT') = '' then
      	Begin
        LastError := 30;
     	  AfficheErreur;
     	  SetFocusControl('T_NOMCONTACT');
     	  TFVierge(Ecran).ModalResult :=  0;
     	  Exit;
     	  End;

     End;

  //Descriptif de l'appel obligatoire
  BlocNote :=THRichEditOLE(GetControl('AFF_DESCRIPTIF'));
  if (Length(BlocNote.Text) = 0) or (BlocNote.Text = #$D#$A) then
     Begin
     LastError := 5;
     AfficheErreur;
     SetFocusControl('AFF_DESCRIPTIF');
     TFVierge(Ecran).ModalResult :=  0;
     Exit;
     End;

  //Si on vient du planning la ressource est obligatoire
  if (AppelPlan) AND (LaTob <> nil) then
     if GetControlText('AFF_RESPONSABLE')= '' then
		  Begin
        LastError := 32;
     	  AfficheErreur;
     	  SetFocusControl('AFF_DESCRIPTIF');
     	  TFVierge(Ecran).ModalResult :=  0;
     	  Exit;
        end;

  //Contrôle de la saisie du code Chantier si paramétre regroupement sur facture décoché
  If not GetParamSoc('SO_BTFACAPPELDETAIL') then
     begin
     if CodeChantier = '' then
        Begin
        LastError := 38;
        Titre := 'Regroupement sur facture';
        AfficheErreur;
     	  TFVierge(Ecran).ModalResult :=  0;
        Titre := '';
        exit;
        end;
     end;

	//Contrôle de l'existence du chantier
  if CodeChantier = 'A              00' then CodeChantier := ''; // cf FQ 15615
  If not LectureChantier then
     Begin
        LastError := 39;
     	  AfficheErreur;
     	  SetFocusControl('AFF_CHANTIER1');
     	  TFVierge(Ecran).ModalResult :=  0;
     	  Exit;
     End;

  if (AFTypeAction = taCreat) then
     if (Ok_SaisieAppel) then
        Begin
        CodeAppel := DechargeCleAffaire(AFF_APPEL0, AFF_APPEL1, AFF_APPEL2, AFF_APPEL3, APP_AVENANT, Client.Text, AFTypeAction, True, True, false, iPartErreur);
        if (CodeAppel <> '') then GestionSaisieNumAppel
        end
      else
        Begin
        CodeAppel := RegroupePartiesAppel(P0, P1, P2, P3, Avn);
        if (CodeAppel <> '') then GestionCalculAutoNumAppel;
        end;

  // test si code appel à blanc (sans ignorer la présence du statut et de l’avenant)
  if Trim(Copy(CodeAppel,2,14)) = '' then
     begin
     LastError := 6;
     AfficheErreur;
     SetFocusControl('AFF_APPEL1');
     TFVierge(Ecran).ModalResult :=  0;
     Exit;
     end;

  //Verification si le contact existe pour création.

  //Mise à jour de la table Affaire avec les zones de l'écran
  TobAppel.PutValue('AFF_AFFAIRE', CodeAppel);
  TobAppel.PutValue('AFF_AFFAIREREF', CodeAppel);

  TobAppel.PutValue('AFF_AFFAIRE0', GetControlText('CAFF_AFFAIRE0'));
  TobAppel.PutValue('AFF_AFFAIRE1', GetControlText('CAFF_AFFAIRE1'));
  TobAppel.PutValue('AFF_AFFAIRE2', GetControlText('CAFF_AFFAIRE2'));
  TobAppel.PutValue('AFF_AFFAIRE3', GetControlText('CAFF_AFFAIRE3'));
  TobAppel.PutValue('AFF_AVENANT', GetControlText('CAFF_AVENANT'));

  TobAppel.PutValue('AFF_STATUTAFFAIRE', 'APP');
  TobAppel.PutValue('AFF_GENERAUTO', 'DIR');
  TobAppel.PutValue('AFF_DEVISE', Devise);

  TobAppel.PutValue('AFF_AFFAIREHT', FactureHT);

  TobAppel.PutValue('AFF_TIERS', CodeTiers);
  if GetParamSocSecur('SO_GCVENTCPTAAFF', False) then
  begin
  	TobAppel.PutValue('AFF_COMPTAAFFAIRE', GetControlText('AFF_COMPTAAFFAIRE'));
  end;

  TobAppel.PutValue('AFF_LIBELLE', GetControlText('AFF_LIBELLE'));

  //TempoDate := StrToDate(GetControlText('AFF_DATESIGNE'));
  //TobAppel.PutValue('AFF_DATESIGNE', TempoDate);

  //Gestion heure de Début et date de Début
  //Gestion heure de fin et date de fin
  if AFTypeAction = taCreat then
    begin
    TobAppel.PutValue('AFF_DATEDEBUT', HeureDeb);
    if CodeEtat <> 'REA' then TobAppel.PutValue('AFF_DATEFIN', iDate2099);
    end;

  //TobAppel.PutValue('AFF_DATELIMITE', StrToDate(GetControlText('AFF_DATELIMITE')));
  //TobAppel.PutValue('AFF_DATEGARANTIE', StrToDate(GetControlText('AFF_DATEGARANTIE')));

  TobAppel.PutValue('AFF_DATEREPONSE', StrToDate(GetControlText('AFF_DATEINT'))+StrToTime(GetControlText('AFF_HEUREINT')));

  TobAppel.PutValue('AFF_DATESIGNE', StrToDate(GetControlText('AFF_DATESOUHAIT'))+StrToTime(GetControlText('AFF_HEURESOUHAIT')));

  TobAppel.PutValue('AFF_RESPONSABLE', GetControlText('AFF_RESPONSABLE'));

  TobAppel.PutValue('AFF_ETATAFFAIRE', CodeEtat);

  TobAppel.PutValue('AFF_AFFAIREINIT', CodeContrat);

  TobAppel.PutValue('AFF_CHANTIER', CodeChantier);

  if GetControlText('YTC_CONTACT') <> '' then
     TobAppel.PutValue('AFF_NUMEROCONTACT', GetControlText('YTC_CONTACT'));

  TobAppel.PutValue('AFF_DESCRIPTIF', GetControlText('AFF_DESCRIPTIF'));

  TobAppel.PutValue('AFF_PRIOCONTRAT', Importance);
  TobAppel.PutValue('AFF_ETABLISSEMENT', GetControlText('AFF_ETABLISSEMENT'));

  TobAppel.setAllModifie(true);
  TobAppel.InsertOrUpdateDB(true);
  NoAdresse := 0;
  QAdr := OpenSQL ('SELECT * FROM ADRESSES WHERE ADR_REFCODE="'+CodeAppel+'" AND ADR_TYPEADRESSE="INT"', TRUE) ;
  if QAdr.EOF then
     Begin
     NoAdresse := GetSetNumAdresse;
     if NoAdresse <=0 then NoAdresse := 1;
     TobAdrInt.PutValue('ADR_NUMEROADRESSE', NoAdresse);
     end
  else
     TobAdrInt.PutValue('ADR_NUMEROADRESSE', QAdr.Fields[0].AsInteger);
  ferme(QAdr);

  TobAdrInt.PutValue('ADR_NATUREAUXI', '');
  TobAdrInt.PutValue('ADR_REFCODE', CodeAppel);
  TobAdrInt.PutValue('ADR_TYPEADRESSE', 'INT');
  TobAdrInt.PutValue('ADR_JURIDIQUE', GetControlText('T_JURIDIQUE'));
  TobAdrInt.PutValue('ADR_LIBELLE', GetControlText('TLIBELLE'));
  TobAdrInt.PutValue('ADR_LIBELLE2', GetControlText('T_PRENOM'));
  TobAdrInt.PutValue('ADR_ADRESSE1', GetControlText('T_ADRESSE1'));
  TobAdrInt.PutValue('ADR_ADRESSE2', GetControlText('T_ADRESSE2'));
  TobAdrInt.PutValue('ADR_ADRESSE3', GetControlText('T_ADRESSE3'));
  TobAdrInt.PutValue('ADR_CODEPOSTAL', GetControlText('T_CODEPOSTAL'));
  TobAdrInt.PutValue('ADR_VILLE', GetControlText('T_VILLE'));
  TobAdrInt.PutValue('ADR_PAYS', GetControlText('T_PAYS'));
  TobAdrInt.PutValue('ADR_TELEPHONE', Telephone.text);

  if GetControlText('YTC_CONTACT') <> '' then
     Begin
	   TobAdrInt.PutValue('ADR_NUMEROCONTACT', GetControlText('YTC_CONTACT'));
		 TobAdrInt.PutValue('ADR_CONTACT', GetControlText('T_NOMCONTACT'));
     end
  else
	   TobAdrInt.PutValue('ADR_CONTACT', GetControlText('T_NOMCONTACT'));

  TobAdrInt.PutValue('ADR_EMAIL', GetControlText('T_EMAIL'));
  TobAdrInt.PutValue('ADR_REGION', GetControlText('T_REGION'));

  TobAdrInt.PutValue('ADR_LIVR', 'X');
  TobAdrInt.PutValue('ADR_FACT', 'X');
  TobAdrInt.PutValue('ADR_REGL', 'X');
//  TobAdrInt.PutValue('ADR_INT',  'X');

  TobAdrint.setAllModifie(true);
  ExecuteSql ('DELETE FROM ADRESSES WHERE ADR_REFCODE="'+ CodeAppel+'" AND ADR_TYPEADRESSE="INT"');
  TobAdrInt.InsertDB(nil,true);

  //Verification si l'adresse d'intervention existe au niveau du tiers pour création.

  //mise à jour table événement avec controle si un evenement n'existe pas déjà sinon rien
  //if CodeEtat = 'AFF' then
  //    Begin
  //   QAdr := OpenSQL ('SELECT * FROM BTEVENPLAN WHERE BEP_AFFAIRE="'+ CodeAppel +'"', TRUE) ;
  //	 if QAdr.EOF then MajEvenement;
  //   Ferme(QAdr);
  //   end;

  If AppelPlan = true then
     if LaTob <> nil then MajEvenement;

  //Confirmation par mail à la ressource et au client.
  If GetParamSocSecur('SO_CUMULMAIL', False) then
     GestionDuMail('',AdrMailClt + ';' + AdrMailRes, BlocNote)
  Else
     Begin
     If GetParamSocSecur('SO_BTGESMAILCLT', False) then GestionDuMail('C',AdrMailClt, BlocNote);
     If GetParamSocSecur('SO_BTGESMAILRES', False) then GestionDuMail('R',AdrMailRes, BlocNote);
     If GetParamSocSecur('SO_BTGESMAILRES', False) then GestionDuMail('A',AdrMailAge, BlocNote);
     end;

  if AFTypeAction = taCreat then
     begin
     AFTypeAction := TaModif;
     SetControlProperty('INTERVENANT', 'Enabled', True);
     SetControlProperty('AFF_DATEINT', 'Visible', false);
     SetControlProperty('AFF_HEUREINT', 'Visible', false);
     SetControlProperty('TAFF_DATEINT', 'Visible', false);
     SetControlProperty('TAFF_HEUREINT', 'Visible', false);
     if not AppelPlan then TFVierge(ecran).ModalResult := 0;
     end;

end;

//Gestion de l'envoi du mail
Procedure TOF_APPEL.GestionDuMail(TypeMail,AdresseMail : String; BlocNote:THRichEditOLE);
Var rep 			: string;
    Sujet			: HString;
    Copie			: String;
    Fichier   : String;
    Str       : String;
    Liste			: HTStringList;
    i					: Integer;
    //OkOk			: boolean;
    ResultMailForm : TResultMailForm;
Begin

  //TypeMail : C = Client
  //           R = Ressource
  //           A = Agence
  //           ''= Client en adresse principale et le reste en Copie

  Str := AdresseMail;
  if (Trim(ReadTokenSt(AdresseMail))) = '' then exit;

	if TypeMail = 'C' then
	   if PGIAsk(TraduireMemoire(TexteMessage[28]), rep) = mrno then exit
  else if TypeMail = 'R' then
     if PGIAsk(TraduireMemoire(TexteMessage[29]), rep) = mrno then exit
  else if TypeMail = 'A' then
     if PGIAsk(TraduireMemoire(TexteMessage[35]), rep) = mrno then exit
  else if TypeMail = '' then
     if PGIAsk(TraduireMemoire(TexteMessage[34]), rep) = mrno then exit
  else
  	 exit;

	//Génération du Bloc Note pour envoie du Mail


  Liste := HTStringList.Create;

  TRY
     for i := 0 to BlocNote.lines.Count - 1 do
         Begin
         Liste.add(BlocNote.Lines.Strings [i]);
		     end;
     Sujet := 'Confirmation d''appel N° ' + Trim(Copy(CodeAppel,2,14));
     Copie := '';
     Fichier := '';
     if TypeMail = '' then
        Begin
        AdresseMail:=(Trim(ReadTokenSt(Str)));
        Copie := Str;
        end;
     //Envoie du mail
     ResultMailForm := AglMailForm(Sujet,AdresseMail,Copie,Liste,Fichier,false);
     if ResultMailForm = rmfOkButNotSend then SendMail(Sujet,AdresseMail,Copie,Liste,Fichier,True,1, '', '');
  FINALLY
     Liste.Free;
  END;

end;

//Modification d'une fiche achat
procedure TOF_APPEL.OnLoad ;

begin
  Inherited ;

  SetControlVisible('BDELETE', False);

  // Si en création calcul du N° d'appel
  if AFTypeAction = taCreat then
     OnNew
  else if AFTypeAction = TaConsult then
     OnDisplay
  else
  	 Begin
	   SetControlVisible('BDELETE', true);
  	 end;

  if not GetParamSocSecur ('SO_RTCTIGESTION', False) then
  begin
    SetControlVisible('BTELBUR',False);
    SetControlVisible('BTELDOM',False);
    SetControlVisible('BTELPORT',False);
  end;
  if EtabForce <> '' then
    THValComboBox (GetControl ('AFF_ETABLISSEMENT') ).enabled := false;
  // cas du 'decroche;COUPLAGE' = Bouton Appel Sortant
  if (RTFormCti=Ecran) and (AppelCtiOk=True) then
     CtiNumAct:=RTCTIGenereAction(True,Client.Text,Auxiliaire,CtiHeureDeb+CCAHeureDeb,0,'',CtiModeAppel+CCAModeAppel,0);

end ;

procedure TOF_APPEL.OnArgument (Argument : String );
var Critere : String;
    Valeur  : String;
    Champ   : String;
    X       : integer;
begin
  Inherited ;
//  SetControlProperty('BTCONTACT', 'VISIBLE', True);

  AFTypeAction := TaCreat;

  AppelPlan := False;

  TypeAction := GetParamSoc('SO_TYPEACTION');

  {$IFDEF CTI}
	WhereUpdate:='';
	AppelCti:=false;
	CtiRaccrocherFiche:=False ;
	CtiCCA:=False;
	AppelantCTI:='';
  {$ENDIF}
	CodeTiers    := '';
  //Récupération valeur de argument
  Critere:=(Trim(ReadTokenSt(Argument)));

  while (Critere <> '') do
    begin
      if Critere <> '' then
        begin
        X := pos (':', Critere) ;
        if x = 0 then
          X := pos ('=', Critere) ;
        if x <> 0 then
          begin
          Champ := copy (Critere, 1, X - 1) ;
          Valeur := Copy (Critere, X + 1, length (Critere) - X) ;
          ControleChamp(champ, valeur);
	  			end
        end;
      ControleCritere(Critere);
      Critere := (Trim(ReadTokenSt(Argument)));
    end;

  //Controle si code affaire et code appel ont le même nombre de parties et si ces
  //Parties ont la même taille
  if (GetParamSoc('SO_AFFCODENBPARTIE') <> GetParamSoc('SO_APPCODENBPARTIE')) OR
     (GetParamSoc('SO_AFFCO1LNG') <> GetParamSoc('SO_APPCO1LNG')) OR
     (GetParamSoc('SO_AFFCO2LNG') <> GetParamSoc('SO_APPCO2LNG')) OR
     (GetParamSoc('SO_AFFCO3LNG') <> GetParamSoc('SO_APPCO3LNG')) Then
     Begin
     LastError := 35;
     AfficheErreur;
     PostMessage(TFVierge(Ecran).Handle, WM_CLOSE, 0, 0);
     end;

  {cas particulier du CCA ou si montée de fiche, c que l'appel est ok }
  {$IFDEF CTI}
  if AppelCti and CtiCCA then AppelCtiOk:=True;
  {$ENDIF}

  //Déclarations et procédures des zones ecran
  Client := THEdit(GetControl('AFF_TIERS'));
  Client.OnExit := ClientExit;
  Client.OnElipsisClick := AppelClient;

  AFF_APPEL0 :=THEdit(GetControl('AFF_APPEL0'));
  AFF_APPEL0.OnExit := AppelExit;

  AFF_APPEL1 :=THEdit(GetControl('AFF_APPEL1'));
  AFF_APPEL1.OnExit := AppelExit;

  AFF_APPEL2 :=THEdit(GetControl('AFF_APPEL2'));
  AFF_APPEL2.OnExit := AppelExit;

  AFF_APPEL3 :=THEdit(GetControl('AFF_APPEL3'));
  AFF_APPEL3.OnExit := AppelExit;

  APP_AVENANT :=THEdit(GetControl('APP_AVENANT'));

   //formatage du code Appel
  SetControlText('AFF_APPEL0','A');
  ChargeCleAffaire(AFF_APPEL0, AFF_APPEL1, AFF_APPEL2, AFF_APPEL3, APP_AVENANT, BEFFACEAPP, AfTypeAction, CodeAppel, True);

  //formatage du code contrat
  ChargeCleAffaire(THEDIT(GetControl('AFF_CONTRAT0')),THEDIT(GetControl('AFF_CONTRAT1')), THEDIT(GetControl('AFF_CONTRAT2')), THEDIT(GetControl('AFF_CONTRAT3')), THEDIT(GetControl('CON_AVENANT')), BEFFACECON, AfTypeAction, CodeContrat, False);

  //Formatage du code chantier
  ChargeCleAffaire(THEDIT(GetControl('AFF_CHANTIER0')),THEDIT(GetControl('AFF_CHANTIER1')), THEDIT(GetControl('AFF_CHANTIER2')), THEDIT(GetControl('AFF_CHANTIER3')), THEDIT(GetControl('CHA_AVENANT')), BTCHANTIER, AfTypeAction, CodeChantier, False);

  AdresseInt :=THEdit(GetControl('YTC_NADRESSELIV'));
  AdresseInt.OnElipsisClick := AppelAdresseLiv;

  Telephone := THEdit(GetControl('T_TELEPHONE'));
  Telephone.OnExit := TelephoneExit;

  Fax := THEdit(GetControl('T_FAX'));
  Fax.OnExit := FaxExit;

  Telex := THEdit(GetControl('T_TELEX'));
  Telex.OnExit := TelExit;

  NomContact := THEdit(GetControl('T_NOMCONTACT'));
  NomContact.OnExit := NomContactExit;

  NomTiers := THEdit(GetControl('TLIBELLE'));
  NomTiers.OnExit := NomTiersExit;

  Contact :=THEdit(GetControl('YTC_CONTACT'));
  Contact.OnElipsisClick := AppelContact;

  Contrat :=THEdit(GetControl('YTC_CONTRAT'));
  Contrat.OnExit := ContratExit;
  Contrat.OnElipsisClick := AppelContrat;

  Contrat3 :=THEdit(GetControl('AFF_CONTRAT3'));
  Contrat3.OnExit := ContratExit;

  Chantier :=THEdit(GetControl('AFF_CHANTIER1'));
  Chantier.OnExit := ChantierExit;

  Chantier :=THEdit(GetControl('AFF_CHANTIER2'));
  Chantier.OnExit := ChantierExit;

  Chantier :=THEdit(GetControl('AFF_CHANTIER3'));
  Chantier.OnExit := ChantierExit;

  Responsable :=THEdit(GetControl('AFF_RESPONSABLE'));
  Responsable.OnElipsisClick := AppelResponsable;
  Responsable.OnDblClick := VoirResponsable;
  Responsable.OnExit := CtrlResponsable;

  Risque := THEdit(GetControl('T_RISQUE'));
  Risque.OnChange := GestionFeuEncour;

  Adresse1 := THEdit(GetControl('T_ADRESSE1'));
  Adresse1.OnDblClick := VoirAdrInt;
  Adresse1.OnExit := Adresse1Exit;

  CodePostal := THEdit(GetControl('T_CODEPOSTAL'));
  CodePostal.OnExit := CodePostalExit;

  Ville := THEdit(GetControl('T_VILLE'));
  Ville.OnExit := VilleExit;

  FeuVert := TToolbarButton97(ecran.FindComponent('FEUVERT'));
  FeuVert.onclick := VoirEncours;
  FeuOrange := TToolbarButton97(ecran.FindComponent('FEUORANGE'));
  FeuOrange.onclick := VoirEncours;
  FeuRouge := TToolbarButton97(ecran.FindComponent('FEUROUGE'));
  Feurouge.onclick := VoirEncours;

  BTContact := TToolbarButton97(ecran.FindComponent('BTContact'));
  BTContact.OnClick := VoirContacts;

  BTContrat := TToolbarButton97(ecran.FindComponent('BTContrat'));
  BTContrat.OnClick := VoirContrats;

  BTChantier := TToolbarButton97(ecran.FindComponent('BTChantier'));
  BTChantier.OnClick := VoirChantier;

  BTHaute := TToolbarButton97(ecran.FindComponent('BTHAUTE'));
  BTHaute.OnClick := HauteClick;

  BTNormale := TToolbarButton97(ecran.FindComponent('BTNORMALE'));
  BTNormale.OnClick := NormaleClick;

  BTBasse := TToolbarButton97(ecran.FindComponent('BTBASSE'));
  BTBasse.OnClick := BasseClick;

  BTNew := TToolbarButton97(ecran.FindComponent('BTNEW'));
  BTNew.onclick := OnNewRecord;

  BTConso := TToolbarButton97(ecran.FindComponent('BTCONSO'));
  BTConso.onclick := VisualisationConso;

  TToolbarButton97(ecran.FindComponent('BTCOMPLEMENTS')).onclick := ComplementsClick;

  BImprimer := TToolbarButton97(ecran.FindComponent('BImprimer'));
  BImprimer.OnClick := BImprimerClick;

  BTMAINTEL := TToolbarButton97(ecran.FindComponent('BTMAINTEL'));
  BTMAINTEL.OnClick := MaintenanceTel;

  BTLIGNE := TToolbarButton97(ecran.FindComponent('BTLIGNE'));
  BTLIGNE.OnClick := BTLigneClick;

  BPhone := TToolbarButton97(ecran.FindComponent('BPhone'));
  BPhone.OnClick := BPhoneClick;

  BStop := TToolbarButton97(ecran.FindComponent('BStop'));
  BStop.onClick := BStopClick;

  BAttente := TToolbarButton97(ecran.FindComponent('BATTENTE'));
  BAttente.onClick := BAttenteClick;

  BTELDOM := TToolbarButton97(ecran.FindComponent('BTELDOM'));
  BTELBUR := TToolbarButton97(ecran.FindComponent('BTELBUR'));
  BTELPORT := TToolbarButton97(ecran.FindComponent('BTELPORT'));

  BPlanning := TToolbarButton97(ecran.FindComponent('BTPLANNING'));
  BPlanning.OnClick := BPlanningClick;

  BTAffectation := TToolbarButton97(ecran.FindComponent('BTAFFECTATION'));
  BTAffectation.OnClick := ListeAffectation;

  BTHISTORIQUE := TToolbarButton97(ecran.FindComponent('BTHISTORIQUE'));
  BTHISTORIQUE.OnClick := BTHistoriqueClick;

  BEffaceApp := TToolBarButton97(ecran.FindComponent('BEFFACEAPP'));

  BEffaceCon := TToolbarButton97(ecran.FindComponent('BEffaceCon'));
  BEffaceCon.OnClick := BEffaceConClick;
  BEffaceCha := TToolbarButton97(ecran.FindComponent('BEffaceCha'));
  BEffaceCha.OnClick := BEffaceChaClick;
  BEffaceClt := TToolbarButton97(ecran.FindComponent('BEffaceClt'));
  BEffaceClt.OnClick := BEffaceCltClick;
  BEffaceRes := TToolbarButton97(ecran.FindComponent('BEffaceRes'));
  BEffaceRes.OnClick := BEffaceResClick;

  PanelAffectation  := THPanel(ecran.FindComponent('PANELAFFECTATION'));
  PanelEvenement    := THPanel(ecran.FindComponent('PANELEVENEMENT'));
  PanelConso        := THPanel(ecran.FindComponent('PANELCONSO'));

  GrilleAffectation := THgrid(ecran.FindComponent('GRILLEAFFECTATION'));
  GrilleAffectation.OnDblClick := GrilleAffectationDBLClick;
  GrilleAffectation.OnClick := GrilleAffectationClick;

  GrilleEvenement := THgrid(ecran.FindComponent('GRILLEEVENEMENT'));
  GrilleEvenement.OnDblClick := GrilleEvenementDBLClick;

  GrilleConso     := THgrid(ecran.FindComponent('GRILLECONSO'));

  DetailAppel    	  := THRichEditOLE(ecran.FindComponent('AFFDESCRIPTIF'));
  DetailInt     	  := THRichEditOLE(ecran.FindComponent('AFFDESCRIPTIF1'));
  Lib_DetailAppel   := THLabel(ecran.FindComponent('DETAILAPPEL'));
  Lib_DetailInt     := THLabel(ecran.FindComponent('DETAILINT'));

  Descriptif    	  := THRichEditOLE(ecran.FindComponent('AFF_DESCRIPTIF'));
  Descriptif.OnExit := DescriptifExit;

  ETATAFFAIRE := ThValComboBox(ecran.FindComponent('ETATAFFAIRE'));
  ETATAFFAIRE.OnChange := ETATAFFAIREOnChange;

  PRIOCONTRAT := ThValComboBox(ecran.FindComponent('PRIOCONTRAT'));
  PRIOCONTRAT.OnChange := PRIOCONTRATOnChange;

  CHKTACHES   := ThCheckBox(ecran.FindComponent('CHKTACHES'));
  CHKTACHES.OnClick := CHKTACHESClick;

  if Assigned(GetControl('BTELPORT')) then
    TToolBarButton97(GetControl('BTELPORT')).OnClick := BTELPORT_OnClick;

  if Assigned(GetControl('BTELBUR')) then
    TToolBarButton97(GetControl('BTELBUR')).OnClick := BTELBUR_OnClick;

  if Assigned(GetControl('BTELDOM')) then
    TToolBarButton97(GetControl('BTELDOM')).OnClick := BTELDOM_OnClick;
  //Creation du masque d'affichage d'affectation Appel
  TToolAffect    := TToolWindow97.Create (ecran);
  TToolEvenement := TToolWindow97.Create (ecran);
  TToolConso     := TToolWindow97.Create (ecran);

  DefiniToolAffect;
  DefiniToolEvenement;
  DefiniToolConso;

	InitGrille;

  //Chargement des Tob génériques
  TobAppel := Tob.Create('AFFAIRE' ,Nil, -1);
  TobAdrInt := Tob.Create('ADRESSES' ,Nil, -1);

  {$IFDEF CTI}
  {$ENDIF}

  Lib_Affaire :=  THLabel (GetControl('AFF_AFFAIRE'));
  if not GetParamSocSecur('SO_RTCTIGESTION', False) then
  begin
    BPhone.Visible := GetParamSocSecur('SO_RTCTIGESTION', False);
    BAttente.Visible:= GetParamSocSecur('SO_RTCTIGESTION', False);
    BStop.Visible:= GetParamSocSecur('SO_RTCTIGESTION', False);
  end else
  begin
  	SetEtatBoutonCti;
    If AFTypeAction = TaModif then
    Begin
//       BPhone.Visible := false;
//       BAttente.Visible:= false;
//       BStop.Visible:= false;
       BTELDOM.Visible := true;
       BTELBUR.Visible := true;
       BTELPORT.Visible := true;
    end;
//    If AFTypeAction = TaCreat then
//    Begin
//    	 SetEtatBoutonCti;
//    end;
  end;
  BPlanning.Visible := GetParamSocSecur('SO_AFFRAPIDE', False);

  SetControlText('AFF_ETABLISSEMENT',  VH^.EtablisDefaut); 
  PositionneEtabUser ('AFF_ETABLISSEMENT') ;
  if not VH^.EtablisCpta then
  begin
  	if THLabel(GetControl('TAFF_ETABLISSEMENT')) <> nil then THLabel(GetControl('TAFF_ETABLISSEMENT')).Visible := false;
			GetControl('AFF_ETABLISSEMENT').visible := false;
  end;

	if AFTypeAction <> TaConsult then
   	begin
	 	FirstWay := true;
 	  Ecran.OnActivate := FicheActivate;
    end;
  if not GetParamSocSecur('SO_GCVENTCPTAAFF', False) then
  begin
  	SetControlVisible ('TAFF_COMPTAAFFAIRE',  False) ;
  	SetControlVisible ('AFF_COMPTAAFFAIRE',  False) ;
  	SetControlText ('AFF_COMPTAAFFAIRE', '') ;
  end;

SetControlVisible ('BTELDOM',  GetParamSocSecur('SO_RTCTIGESTION',false));
SetControlVisible ('BTELPORT', GetParamSocSecur('SO_RTCTIGESTION',false));
SetControlVisible ('BTELBUR',  GetParamSocSecur('SO_RTCTIGESTION',false));
if JaiLeDroitTag(323210) then
begin
	SetControlVisible ('BVISUPARC',  true);
  TToolBarButton97(GetControl('BVISUPARC')).onclick := BVisuParcClick;
end;


end;

Procedure TOF_APPEL.ControleChamp(Champ : String;Valeur : String);
Begin

  //Propriété des champ à l'affichage quelque soit l'état de l'appel
  SetControlProperty('AFF_DESCRIPTIF','Height', 198);
  SetControlProperty('BTMAINTEL','Visible',False);

  if Champ = 'ACTION' then
	   Begin
     if Valeur = 'CREATION' Then
        AFTypeAction := TaCreat
     else if Valeur = 'MODIFICATION' then
        AFTypeAction := TaModif
     else
	      AFTypeAction := TaConsult
  end;

  //Chargement du code affaire
  if Champ ='CODEAPPEL' then CodeAppel :=valeur;

  if Champ ='CODETIERS' then CodeTiers :=valeur;

  if Champ ='NUMTEL' then CleTel :=valeur;

	// ce doit etre le dernier argument car il risque de comporter des ";"
  if Champ='UPDCTI' then WhereUpdate := WhereUpdate+Valeur;

  if Champ='APPELANT' then AppelantCTI:=Valeur;

end;

Procedure Tof_APPEL.ControleCritere(Critere : String);
Begin

	if critere='SERIECTI' then SerieCTI:=True;

  if (critere='DECROCHE') and (CtiHeureDeb<>0) then
     begin
     AppelCtiOk:=True;
     CtiHeureDebCom:=CtiHeureDeb;
     end;

  if (critere='COUPLAGE') or (critere='NUMEROTER') then RTFormCti:=Ecran;

  if critere='APPEL' then AppelCti:=true;

  if critere='CCA' then CtiCCA:=true;

  If critere='PLANNING' Then
     Begin
     AppelPlan := True;
     end;

end;

procedure TOF_APPEL.Raz_Zone_Ecran;
Var DateDeb	: TDateTime;
    StReq		: String;
    QQ			: TQuery;
    NbJour  : Integer;
    jj      : Word;
    mm      : Word;
    yyyy    : Word;
Begin

  SetControlProperty('YTC_NADRESSELIV', 'VISIBLE', False);
  SetControlProperty('YTC_CONTACT', 'VISIBLE', False);
  SetControlProperty('YTC_CONTRAT', 'VISIBLE', False);
  SetControlProperty('YTC_RESPONSABLE', 'VISIBLE', False);

  SetControlText('YTC_NADRESSELIV','');
  SetControlText('YTC_CONTACT','');
  SetControlText('YTC_CONTRAT','');
//  SetControlText('ARS_RESSOURCE','');

  SetControlText('AFF_CHANTIER0','A');
  SetControlText('AFF_CHANTIER1','');
  SetControlText('AFF_CHANTIER2','');
  SetControlText('AFF_CHANTIER3','');
  SetControlText('CHA_AVENANT','00');
  SetControlText('TT_LIBAFFAIRE','');

  SetControlText('AFF_CONTRAT0','I');
  SetControlText('AFF_CONTRAT1','');
  SetControlText('AFF_CONTRAT2','');
  SetControlText('AFF_CONTRAT3','');
  SetControlText('CON_AVENANT','00');

//  BTCONTACT.VISIBLE := False;
//BTCONTRAT.VISIBLE := False;
//BTCHANTIER.VISIBLE:= False;
  BTLIGNE.VISIBLE		:= False;
  BTMAINTEL.Visible := True;

  BTAffectation.Visible := False;

  BTHaute.Flat := False;
  BTNormale.Flat := True;
  BTBasse.Flat := False;

  SetControlProperty('AFF_DATELIMITE', 'VISIBLE', False);
  SetControlProperty('AFF_DATESIGNE', 'VISIBLE', False);
  SetControlProperty('AFF_DATEGARANTIE', 'VISIBLE', False);

  SetControlCaption('TAFF_IMPORTANCE', 'NORMALE');

  SetControlProperty('GROUPVALEUR', 'VISIBLE', False);

  SetControlProperty('CHKCONTRAT', 'ENABLED', False);
  SetControlChecked('CHKCONTRAT', False);
  SetControlProperty('CHKGARANTIE', 'ENABLED', False);
  SetControlChecked('CHKGARANTIE', False);
  SetControlProperty('CHKTACHE', 'ENABLED', False);
  SetControlChecked('CHKTACHE', False);

  SetControlCaption('GROUPCONTRAT', 'CONTRAT');

  //SetControlText('AFF_TIERS','');
  Client.text := '';

  SetControlText('TLIBELLE','');
  SetControlText('T_PRENOM','');
  SetControlText('T_ADRESSE1','');
  SetControlText('T_ADRESSE2','');
  SetControlText('T_ADRESSE3','');
  SetControlText('T_CODEPOSTAL','');
  SetControlText('T_VILLE','');
  SetControlText('T_PAYS','');
  SetControlText('T_REGION','');
  SetControlText('T_EMAIL','');
  SetControlText('T_RVA','');

  NomContact.text := '';
  Telephone.text := '';
  Fax.text := '';
  Telex.Text := '';

  AdrMailClt := '';
  AdrMailRes := '';

  SetControlText('AFF_DESCRIPTIF','');
  SetControlText('AFF_TOTALHTDEV','0.00');

  SetControlText('AFF_RESPONSABLE','');
  SetControlText('TAFF_RESPONSABLE','');
//  Responsable.Text := '';

  //Chargement des dates et heure
  HeureDeb := Now;
  SetControlText('AFF_DATEDEBUT', DateToStr(HeureDeb));
  SetControlText('AFF_HEUREDEBUT', TimeToStr(HeureDeb));

  SetControlText('AFF_DATEINT', DateToStr(idate2099));
  SetControlText('AFF_HEUREINT', TimeToStr(0));

  NbJour := GetParamSocSecur('SO_BTDATESOUHAIT', 0);
  DateDeb := PlusDate(Now,NbJour,'J'); 
  SetControlText('AFF_DATESOUHAIT', DateToStr(DateDeb));
  SetControlText('AFF_HEURESOUHAIT', FormatDateTime('hh:mm',DateDeb));

  SetControlText('AFF_DATEFIN',DateToStr(idate2099));
  SetControlText('AFF_HEUREFIN', TimeToStr(iDate1900));

  SetControlText('AFF_DATEGARANTIE',dateToStr(idate2099));
  SetControlText('AFF_DATESIGNE',dateToStr(idate2099));
  SetControlText('AFF_DATELIMITE',dateToStr(idate2099));

  //si un évènement au moins existe alors on bloque l'intervenant
  StReq := 'SELECT BEP_CODEEVENT FROM BTEVENPLAN';
  QQ := OpenSQL(StREq, false);
  
  if QQ.eof then
	  SetControlProperty('INTERVENANT', 'Enabled', True)
  else
	  SetControlProperty('INTERVENANT', 'Enabled', false);

  ferme(qq);

  //Si création à partir du Planning...
  if AppelPlan then
     Begin
       if LaTob <> nil then
       Begin
       //chargement des information propre à la création d'un évènement....
       SetControlText('AFF_RESPONSABLE',LaTOB.GetString('RESSOURCE'));
       SetControlProperty('INTERVENANT', 'Enabled', false);
       DateDeb := StrToDateTime(LaTOB.GetValue('DATEDEB'));
       SetControlText('AFF_DATEINT'  ,DateToStr(DateDeb));
       SetControlText('AFF_HEUREINT' ,TimeToStr(DateDeb));
       SetControlText('AFF_DATESOUHAIT'  ,DateToStr(DateDeb));
       SetControlText('AFF_HEURESOUHAIT' ,FormatDateTime('hh:mm',DateDeb));
       setcontrolProperty('AFF_DATEINT','Visible', True);
       SetControlProperty('AFF_HEUREINT', 'Visible', True);
       LectureResponsable;
       end;
     end;

end ;


procedure TOF_APPEL.OnClose ;
begin
  Inherited ;
                    
	// Appels en série : on sort sans avoir raccroché : on empêche de sortir
  if (AppelCtiOk) and (SerieCTI) and (not CtiRaccrocherFiche) then
  	 begin
     LastError := 1;
     AfficheErreur;
     exit;
     end
	else
     // Appels Sortant seul : on sort sans avoir raccroché : on mémorise l'heure de début de Communication
     if (AppelCtiOk) and (not SerieCTI) and (not CtiRaccrocherFiche) then
        CtiHeureDeb:=CtiHeureDebCom;

	if RTFormCti<> Nil then RTFormCti:=Nil;

  TobAdrInt.free;
  TobAppel.free;

end ;

procedure TOF_APPEL.OnDisplay () ;
Var Req        : string;
    QQ         : TQuery;
    //HInter     : String;
begin
  Inherited ;

  Client.enabled := False;
  BEffaceClt.Visible := False;
  NomContact.enabled := false;
  Telephone.enabled := false;

  SetControlProperty('GROUPVALEUR', 'VISIBLE', False);

  GestionSaisieNumAppel;
  //
  if GetControlText('CAFF_AVENANT') <> '00' then
     Lib_Affaire.Caption := 'APPEL N° ' + P1 + P2 + P3 + ' - (' + Avn + ')'
  else
     Lib_Affaire.Caption := 'APPEL N° ' + P1 + P2 + P3;

  //Affaire0 := GetControlText('CAFF_AFFAIRE0');

  Req := '';

  //Modification d'un enregistrement
  req := 'SELECT * FROM AFFAIRE WHERE AFF_AFFAIRE ="' + CodeAppel + '"';
  QQ := OpenSql (Req,true);

  if QQ.eof then
  begin
     ferme(QQ);
     Exit;
  end;

  TobAppel.selectDB('',QQ);
  ferme (QQ);

  CodeTiers := TobAppel.GetValue('AFF_TIERS');
  Status := TobAppel.GetValue('AFF_AFFAIRE0');
  Devise := TobAppel.GetValue('AFF_DEVISE');
  CodeEtat := TobAppel.GetValue('AFF_ETATAFFAIRE');
  Importance := TobAppel.GetValue('AFF_PRIOCONTRAT');

  CodeContrat := TobAppel.GetValue('AFF_AFFAIREINIT');
  CodeChantier := TobAppel.GetValue('AFF_CHANTIER');

  //Chargement du status de l'affaire
  if CodeEtat = 'ECO'      then
     Begin
     SetControlCaption('TAFF_ETAT', 'En-Cours');
     BTMAINTEL.visible := True;
     BTAffectation.visible := false;
     end
  else if CodeEtat = 'AFF' then
     Begin
     SetControlCaption('TAFF_ETAT', 'Affecté');
     BTMAINTEL.visible := True;
     BTAffectation.visible := True;
     SetControlProperty('BImprimer', 'Visible', true);
     end
  else if CodeEtat = 'ACD' then
     Begin
     SetControlCaption('TAFF_ETAT', 'Attente Acceptation Devis');
     BTMAINTEL.visible := False;
     BTAffectation.visible := False;
     end
  else if CodeEtat = 'ACA' then
     Begin
     SetControlCaption('TAFF_ETAT', 'Devis Accepté');
     BTMAINTEL.visible := False;
     BTAffectation.visible := False;
     end
  else if CodeEtat = 'ANN' then
     Begin
	  AFTypeAction := taConsult;
     SetControlCaption('TAFF_ETAT', 'Annulé');
     End
  else if CodeEtat = 'FAC' then
     Begin
     AFTypeAction := taConsult;
     SetControlCaption('TAFF_ETAT', 'Facturé');
     end
  else if CodeEtat = 'REA' then
     Begin
     AFTypeAction := taConsult;
     SetControlCaption('TAFF_ETAT', 'Réalisé');
  	 end
  else
     Begin
     AFTypeAction := taConsult;
     SetControlCaption('TAFF_ETAT', 'Terminé');
     End;

  SetControlText('AFF_APPEL0', 'W');

  SetControlText('AFF_CONTRAT0', 'I');
  SetControlText('AFF_CHANTIER0', 'A');

  SetControlText('AFF_LIBELLE', TobAppel.GetValue('AFF_LIBELLE'));

  //Contrôle si aucune affectation sur cet appel
  VerifieAffectation;
//  SetControlText('AFF_RESPONSABLE', TobAppel.GetValue('AFF_RESPONSABLE'));

  SetControlText('YTC_CONTRAT', TobAppel.GetValue('AFF_AFFAIREINIT'));
  if TobAppel.GetValue('AFF_CREERPAR') = 'TAC' then
     SetControlChecked('CHKTACHE', True)
  else
     SetControlChecked('CHKTACHE', False);

  SetControlText('YTC_CONTACT', TobAppel.GetValue('AFF_NUMEROCONTACT'));

  SetControltext('AFF_DATEDEBUT', DateToStr(TobAppel.GetValue('AFF_DATEDEBUT')));
  SetControltext('AFF_DATEFIN', DatetoStr(TobAppel.GetValue('AFF_DATEFIN')));
  SetControlText('AFF_HEUREDEBUT', TimeToStr(TobAppel.GetValue('AFF_DATEDEBUT')));
  SetControlText('AFF_HEUREFIN', TimeToStr(TobAppel.GetValue('AFF_DATEFIN')));

  //HInter := TimeToStr(TobAppel.GetValue('AFF_DATEREPONSE'));
  SetControlText('AFF_DATEINT', DateToStr(TobAppel.GetValue('AFF_DATEREPONSE')));
  SetControlText('AFF_HEUREINT', FormatDateTime('hh:mm',TobAppel.GetValue('AFF_DATEREPONSE')));

//  SetControlProperty('AFF_DATESOUHAIT','Enabled', True);
//  SetControlProperty('AFF_HEURESOUHAIT','Enabled', True);
  SetControlText('AFF_DATESOUHAIT', DateToStr(TobAppel.GetValue('AFF_DATESIGNE')));
  SetControlText('AFF_HEURESOUHAIT', FormatDateTime('hh:mm',TobAppel.GetValue('AFF_DATESIGNE')));

  //SetControlText('AFF_DATESIGNE', DatetoStr(TobAppel.GetValue('AFF_DATESIGNE')));
  //SetControlText('AFF_DATELIMITE', DatetoStr(TobAppel.GetValue('AFF_DATELIMITE')));
  //SetControlText('AFF_DATEGARANTIE', DatetoStr(TobAppel.GetValue('AFF_DATEGARANTIE')));

  SetControlText('AFF_DESCRIPTIF', TobAppel.GetValue('AFF_DESCRIPTIF'));
  SetControlText('AFF_COMPTAAFFAIRE', TobAppel.GetValue('AFF_COMPTAAFFAIRE'));
  SetControlText('AFF_ETABLISSEMENT', TobAppel.GetValue('AFF_ETABLISSEMENT'));
  SetControlText('AFF_RESPONSABLE', TobAppel.GetValue('AFF_RESPONSABLE'));

  if TobAppel.getvalue('AFF_TOTALHTDEV') <> 0 then
     Begin
     SetControlProperty('GROUPVALEUR', 'VISIBLE', True);
     SetControlText('AFF_TOTALHTDEV', TobAppel.GetValue('AFF_TOTALHTDEV'));
     end;

  if Importance = '3' then
     BTBasse.OnClick (BTBasse)
  else if Importance = '1' then
     BTHaute.OnClick (BTHaute)
  else
     BTNormale.OnClick (BTNormale);

  //Chargement du Tiers
  if Not LectureTiers then
     Begin
     Titre := 'Modification Appel';
     AfficheErreur;
     Titre := '';
     end
  else
     Client.Text := CodeTiers;
     //SetControlText('AFF_TIERS', CodeTiers);

  //Chargement de l'intervenant
  LectureResponsable;

  //Chargement des infos contrat
  LectureContrat;

  //Chargement des infos chantier
  LectureChantier;

  //Chargement des infos Contact
  LectureContact;

  //Chargement de l'adresse d'intervention
  Req := 'SELECT * FROM ADRESSES WHERE ADR_REFCODE="' + TobAppel.getvalue('AFF_AFFAIRE') + '" ';
  Req := req + 'AND ADR_TYPEADRESSE="INT"';
  QQ := OpenSQL(Req, true);
  if QQ.eof then
  Begin
    ferme(QQ);
    exit;
  end;

  TobAdrInt.SelectDB('',QQ);

  Ferme(QQ);

  NoAdresse := TobAdrInt.GetValue('ADR_NUMEROADRESSE');

  SetControlText('T_JURIDIQUE',TobAdrInt.GetValue('ADR_JURIDIQUE'));
  SetControlText('TLIBELLE',TobAdrInt.GetValue('ADR_LIBELLE'));
  SetControlText('T_PRENOM',TobAdrInt.GetValue('ADR_LIBELLE2'));
  SetControlText('T_ADRESSE1',TobAdrInt.GetValue('ADR_ADRESSE1'));
  SetControlText('T_ADRESSE2',TobAdrInt.GetValue('ADR_ADRESSE2'));
  SetControlText('T_ADRESSE3',TobAdrInt.GetValue('ADR_ADRESSE3' ));
  SetControlText('T_CODEPOSTAL',TobAdrInt.GetValue('ADR_CODEPOSTAL'));
  SetControlText('T_VILLE',TobAdrInt.GetValue('ADR_VILLE'));
  SetControlText('T_PAYS',TobAdrInt.GetValue('ADR_PAYS' ));

  Telephone.text := TobAdrInt.GetValue('ADR_TELEPHONE');

  Cletel := CleTelephone(TobAdrInt.GetValue('ADR_TELEPHONE'));;

  SetControlText('YTC_CONTACT',TobAdrInt.GetValue('ADR_NUMEROCONTACT'));
  SetControlText('T_NOMCONTACT',TobAdrInt.GetValue('ADR_CONTACT'));
  SetControlText('T_EMAIL',TobAdrInt.GetValue('ADR_EMAIL' ));
  SetControlText('T_REGION',TobAdrInt.GetValue('ADR_REGION'));
  SetControlProperty('BTCOMPLEMENTS', 'Visible', true);

  if AFTypeAction = taConsult then EcranConsultation;

  if CodeEtat = 'FAC' Then
     SetControlProperty('BTLIGNE', 'VISIBLE', True);
  if CodeEtat = 'ANN' Then
  	 AfficheAnnule;
  if CodeEtat = 'REA' then
  	 AfficheAnnule;
  if CodeEtat = 'CL1' then
  	 AfficheAnnule;

end ;

Procedure TOF_APPEL.AfficheAnnule;
Var Req : String;
    QQ         : TQuery;
    TobOLE     : Tob;
Begin

	Req := '';

  //Modification d'un enregistrement
  req := 'SELECT * FROM LIENSOLE WHERE ';
  Req := Req + ' LO_TABLEBLOB = "APP"';
  Req := Req + ' AND LO_QUALIFIANTBLOB = "MOT"';
//  Req := Req + ' AND LO_EMPLOIBLOB IN ("' + CodeEtat + '","TER")';
  Req := Req + ' AND LO_IDENTIFIANT ="' + CodeAppel + '"';
  Req := Req + ' AND LO_RANGBLOB = 1';

  QQ := OpenSql (Req,true);

  if QQ.eof then
  begin
     ferme(QQ);
     Exit;
  end;

  TobOLE := Tob.Create('LIENSOLE' ,Nil, -1);
  TobOLE.selectDB('',QQ);
  ferme (QQ);

  if CodeEtat = 'ANN' then
	  SetControlProperty('TAFF_MOTIF','Caption','MOTIF ANNULATION')
  else if CodeEtat = 'REA' then
  	Begin
  	SetControlProperty('TAFF_MOTIF','Caption','DESCRIPTIF INTERVENTION');
    end;

  SetControlProperty('AFF_DESCRIPTIF','Height', 120);
  SetControlProperty('LO_MOTIF','Height', 82);
  SetControlProperty('TAFF_MOTIF', 'Visible', True);
  SetControlProperty('LO_MOTIF', 'Visible', True);
  SetControlProperty('LO_MOTIF', 'Enabled', False);

  SetControlText('LO_MOTIF', TobOLE.GetVALUE('LO_OBJET'));

  TobOLE.Free;

end;

Procedure TOF_APPEL.EcranConsultation;
Begin

	//SetControlProperty('AFF_TIERS', 'Enabled', False);

  Client.Enabled := False;
  BEffaceCLT.Enabled := False;

 	SetControlProperty('AFF_RESPONSABLE', 'Enabled', False);
  SetControlProperty('AFF_MONTANTECHDEV','Enabled', False);
  //SetControlProperty('AFF_DESCRIPTIF','Enabled', False);

  BTCONTACT.VISIBLE := False;
	//BTCONTRAT.VISIBLE := False;
	//BTCHANTIER.VISIBLE := False;
//  BTLIGNE.VISIBLE := False;

	SetControlProperty('FEUROUGE', 'Visible', False);
	SetControlProperty('FEUORANGE', 'Visible', False);
	SetControlProperty('FEUVERT', 'Visible', False);

	SetControlProperty('BTHAUTE', 'enabled', True);
 	SetControlProperty('BTNORMALE', 'enabled', True);
 	SetControlProperty('BTBASSE', 'enabled', True);

  BEFFACEAPP.Visible := False;
  //BEFFACECON.Visible := False;
  //BEFFACECHA.Visible := False;
  BEFFACERES.Visible := False;
  BEFFACECLT.Visible := False;

 	SetControlProperty('BTNEW', 'Visible', False);
//	SetControlProperty('BTLIGNE', 'Visible', False);
	SetControlProperty('BTADRESSES', 'Visible', False);

  BTMAINTEL.Visible := False;
  BTAffectation.visible := True;

 	SetControlProperty('BTINTTYPE', 'Visible', False);
 	SetControlProperty('BDELETE', 'Visible', False);
 	//SetControlProperty('BVALIDER', 'Visible', False);

	SetControlProperty('CHKCONTRAT', 'Enabled', False);
 	SetControlProperty('CHKGARANTIE', 'Enabled', False);
  SetControlProperty('CHKGARANTIE', 'Enabled', False);

	SetControlProperty('T_JURIDIQUE', 'Enabled', False);
 	SetControlProperty('T_NOMCONTACT', 'Enabled', False);
 	SetControlProperty('TLIBELLE', 'Enabled', False);
	SetControlProperty('T_PRENOM', 'Enabled', False);
 	SetControlProperty('T_ADRESSE1', 'Enabled', False);
 	SetControlProperty('T_ADRESSE2', 'Enabled', False);
	SetControlProperty('T_ADRESSE3', 'Enabled', False);
	SetControlProperty('T_CODEPOSTAL', 'Enabled', False);
	SetControlProperty('T_VILLE', 'Enabled', False);
  SetControlProperty('T_PAYS','Enabled', False);
  SetControlProperty('T_EMAIL','Enabled', False);
  SetControlProperty('T_REGION','Enabled', False);
  SetControlProperty('T_RVA','Enabled', False);

  TELEPHONE.Enabled := False;
	TELEX.Enabled	:= False;
	FAX.Enabled	:= False;

  SetControlProperty('AFF_DATEINT','Enabled', False);
  SetControlProperty('AFF_HEUREINT','Enabled', False);
  
  SetControlProperty('AFF_DATESOUHAIT','Enabled', False);
  SetControlProperty('AFF_HEURESOUHAIT','Enabled', False);

  SetControlProperty('ARS_RESSOURCE','Enabled', False);
  SetControlProperty('YTC_CONTRAT','Enabled', False);
  SetControlProperty('YTC_CONTACT','Enabled', False);

end;

procedure TOF_APPEL.OnCancel () ;
begin
  Inherited ;
end ;

// controle des zones écrans.
// contrôle existance du client
procedure TOF_APPEL.ContratExit(Sender: TObject);
Var C0			 : String;
    C1			 : String;
    C2			 : String;
    C3 			 : String;
    Avenant	 : String;
    Tiers 	 : String;

begin

	C0 := GetControlText('AFF_CONTRAT0');
	C1 := GetControlText('AFF_CONTRAT1');
	C2 := GetControlText('AFF_CONTRAT2');
	C3 := GetControlText('AFF_CONTRAT3');
	Avenant := GetControlText('CON_AVENANT');
  
	Tiers := Client.Text;//GetControlText('AFF_TIERS');

	CodeContrat := CodeAffaireRegroupe(C0, C1,C2,C3,Avenant,AfTypeAction,false,false,false);

	if CodeContrat = '' then exit;

	LectureContrat;

  if CodeTiers = '' then Client.OnExit(Client);

  SetControlText('AFF_CONTRAT1', C1);
  SetControlText('AFF_CONTRAT2', C2);
  SetControlText('AFF_CONTRAT3', C3);
  SetControlText('CON_AVENANT', Avenant);

end;

procedure TOF_APPEL.ChantierExit(Sender: TObject);
Var C0			 : String;
    C1			 : String;
    C2			 : String;
    C3 			 : String;
    Avenant	 : String;
    Tiers 	 : String;

begin

	C0 := GetControlText('AFF_CHANTIER0');
	C1 := GetControlText('AFF_CHANTIER1');
	C2 := GetControlText('AFF_CHANTIER2');
	C3 := GetControlText('AFF_CHANTIER3');
	Avenant := GetControlText('CHA_AVENANT');
	Tiers := Client.Text; //GetControlText('AFF_TIERS');

  CodeChantier := CodeAffaireRegroupe(C0, C1,C2,C3,Avenant,AfTypeAction,false,false,false);

	if CodeChantier = '' then exit;

	LectureChantier;

  if CodeTiers = '' then Client.OnExit(Client);

  SetControlText('AFF_CHANTIER1', C1);
  SetControlText('AFF_CHANTIER2', C2);
  SetControlText('AFF_CHANTIER3', C3);
  SetControlText('CHA_AVENANT', Avenant);
  if EtabChantier <> '' then
     SetControltext('AFF_ETABLISSEMENT', EtabChantier);
end;

procedure TOF_APPEL.AppelExit(Sender: TObject);
Var C0			 : String;
    C1			 : String;
    C2			 : String;
    C3 			 : String;
    Avenant	 : String;
    Tiers 	 : String;

begin

	C0 := 'W';
	C1 := AFF_APPEL1.Text;
	C2 := AFF_APPEL2.text;
	C3 := AFF_APPEL3.text;
	Avenant := APP_AVENANT.Text;
	Tiers := client.Text; //GetControlText('AFF_TIERS');

	CodeAppel := CodeAffaireRegroupe(C0, C1,C2,C3,Avenant,AfTypeAction,false,false,false);

  //control existence
  	if CodeAppel = '' then exit;

  SetControlText('AFF_APPEL0', C0);
  SetControlText('AFF_APPEL1', C1);
  SetControlText('AFF_APPEL2', C2);
  SetControlText('AFF_APPEL3', C3);
  SetControlText('APP_AVENANT', Avenant);

  GestionSaisieNumAppel;

end;

// contrôle existance du client
procedure TOF_APPEL.ClientExit(Sender: TObject);
begin

	CodeTiers :=  Client.Text; //GetControlText('AFF_TIERS');

  if OldTiers = CodeTiers then
  	 exit
  else
  	 Begin
     BTCONTRAT.VISIBLE := True;
     if Oldtiers <> '' then
        Begin
     		BEffaceCon.Click;
        BEffaceCha.Click;
        end;
     end;

  If not CtrlExitZoneTiers('T_TIERS=', CodeTiers) then
  	 Begin
     CodeTiers:='';
     AfficheErreur;
     AppelRechTiers('T_NATUREAUXI="CLI"');
     end;

  RechContactTiers;

  if CodeContrat = '' then RechContratTiers;

  SetFocusControl('AFF_DESCRIPTIF');
  SetInfosTel (false);
  SetControlProperty('BTCONTACT', 'VISIBLE', True);
end;

Procedure TOF_APPEL.AfficheTiers(TobTiers : Tob);
Begin

  With TobTiers.Detail[0] do
  	Begin
    SetControlText('GB_Client', GetValue('T_LIBELLE'));
    Client.Text := GetValue('T_TIERS');
	  //SetControltext('AFF_TIERS', GetValue('T_TIERS'));
  	SetControltext('TLIBELLE', GetValue('T_LIBELLE'));
	  SetControltext('T_JURIDIQUE', GetValue('T_JURIDIQUE'));
    SetControltext('T_PRENOM', GetValue('T_PRENOM'));
    SetControltext('T_ADRESSE1', GetValue('T_ADRESSE1'));
    SetControltext('T_ADRESSE2', GetValue('T_ADRESSE2'));
    SetControltext('T_ADRESSE3', GetValue('T_ADRESSE3'));
    SetControltext('T_CODEPOSTAL', GetValue('T_CODEPOSTAL'));
    SetControltext('T_VILLE', GetValue('T_VILLE'));
    SetControltext('T_PAYS', GetValue('T_PAYS'));
    SetControltext('T_REGION', GetValue('T_REGION'));
    FactureHT := GetValue('T_FACTUREHT');
    if GetControlText('T_NOMCONTACT') = '' then
    	 Begin
    	 TELEPHONE.text := GetValue('T_TELEPHONE');
    	 FAX.text := GetValue('T_FAX');
    	 TELEX.text := GetValue('T_TELEX');
       SetControltext('T_EMAIL', GetValue('T_EMAIL'));
	     SetControltext('T_RVA', GetValue('T_RVA'));
    	 End;
    AdrMailClt := GetControlText('T_EMAIL');
  	end;

end;


procedure TOF_APPEL.AppelClient(Sender: TObject);
Begin
	AppelRechTiers('T_NATUREAUXI="CLI"');
end;


procedure TOF_APPEL.AppelRechTiers(Arg : string);
Var EditTiers : THCritMaskEdit;
begin

  EditTiers := ThCritMaskEdit.Create(TFvierge(ecran));
  EditTiers.parent := TFvierge(ecran);
  EditTiers.Visible := false;
  EditTiers.DataType := 'AFF_TIERS';
  EditTiers.Text := CodeTiers;

  Codetiers := '';

  CodeTiers :=  DispatchRecherche(EditTiers,2,Arg,'','');

  EditTiers.Free;

  Client.Text := CodeTiers; //SetControlText('AFF_TIERS', CodeTiers);

  if CodeTiers = '' then
  begin
     //SetFocusControl('AFF_TIERS');
     Client.setFocus;
     exit;
  end;

  Client.OnExit(Client);

end;

// Control si client est à Risque
function TOF_APPEL.ControlRisque : boolean;
Var EtatRisque : string;
Begin

  Result := false;

  EtatRisque := GetEtatRisqueClient(CodeTiers) ;

  if EtatRisque = 'R' then
  begin
     Titre := 'Risque Client';
     if VH_GC.GCIfDefCEGID then //29/04/02
     Begin
       Result := True;
       LastError := 27
     end
     else
     begin
       Result := true;
       //SetcontrolText('AFF_TIERS', '') ;
       Client.Text := '';
       OldTiers := '';
       SetFocusControl ('AFF_TIERS') ;
       LastError := 25;
       exit;
     end;
  end;

  if EtatRisque = 'O' then
  begin
     Result := false;
     LastError := 26;
  end;

end;

// Control si le Client Fermé
Function TOF_APPEL.ClientFerme(FERME : String) : Boolean;
Begin

	Result := False;

  if FERME = 'X' then
	   begin
     Titre := 'Client fermé';
     Result := true;
     LastError := 36;
     //SetControlText ('AFF_TIERS', '');
     Client.Text := '';
     OldTiers := '';
     Client.SetFocus;
     end;

End;

//Controle de la Devise
Function TOF_APPEL.ControleDevise : Boolean;
begin

	result := false;

	Devise := V_PGI.DevisePivot;

  if GetParamSoc('SO_GCTOUTEURO') and (Devise = 'EUR')   or
                                      (Devise = 'FRF') then
  begin
    Devise := 'EUR';
    result := True;
  end;

  // Mois de clôture
  //if ctxScot in V_PGI.PGIContexte then
  //begin
  //  MoisCloture := Q.FindField ('T_MOISCLOTURE') .AsInteger;
  //  if MoisCloture <> 0 then
  //  begin
  //    SetControlText ('MOISCLOTURE', LongMonthNames [MoisCloture] ) ;
  //  end;
  //end;

end;


Function TOF_APPEL.ControleAdresseInt(NatAux : string):Boolean;
Var TobAdrInt : TOB;
    Req : String;
begin

  Result := True;

  //Lecture de la table des Adresses pour récupération adresse d'intervention
  //du tiers

	Req := 'SELECT * FROM ADRESSES WHERE ADR_INT="X" AND ADR_NATUREAUXI="' + NatAux;
  Req := Req + '" AND ADR_REFCODE ="' + CodeTiers + '"';

  TobAdrInt := Tob.Create('LesAdrInt',Nil, -1);
  TobAdrInt.LoadDetailDBFromSQL('ADRESSES',req,false);

  if TobAdrInt.Detail.Count=0  then
     Result := false
  else if TobAdrInt.Detail.Count > 1 then
  //lancement d'une grille pour sélection de l'adresse d'intervention
     Begin
     SetControlProperty('YTC_NADRESSELIV', 'VISIBLE', true);
     AdresseInt.ElipsisClick (AdresseInt);
     End
  else
     Begin
     SetControlText('YTC_NADRESSELIV', TobAdrInt.Detail[0].GetValue('ADR_NADRESSE'));
	   AfficheAdresseIntervention(TobAdrInt);
     End;

  TobAdrInt.free;

end;

procedure TOF_APPEL.AppelAdresseLiv(sender : Tobject);
Var Req       : String;
begin

//	Req := ' ADR_TYPEADRESSE="INT"';
	Req := ' ADR_INT="X"';
  Req := Req + ' AND ADR_REFCODE="' + CodeTiers + '"';
//  req := Req + ' AND ADR_TYPEADRESSE="INT"';

  SetControlProperty('YTC_NADRESSELIV', 'Plus', req);

  //LookupCombo(Adresseint);
  VoirAdrInt(Sender);

  if GetControlText('YTC_NADRESSELIV')='' then exit;

  //Lecture de l'adresse sélectionnée et affichage des informations
  LectureAdresseIntervention;

End;

//Appel de la fiche des adresses }
Procedure TOF_APPEL.VoirAdrInt(Sender : TObject);
Var Range    : String;
		Argument : String;
    NumAdr   : string;
    Q        : TQuery;
Begin

   Range := 'ADR_INT=X;ADR_TYPEADRESSE=TIE;ADR_NATUREAUXI=CLI;ADR_REFCODE=' + CodeTiers;

   Argument := 'YTC_TIERSLIVRE=' + CodeTiers;
   Argument := Argument + ';TYPEADRESSE=TIE';
   Argument := Argument + ';TITRE=' + GetControlText('TLIBELLE');
   Argument := Argument + ';PART=-';
   Argument := Argument + ';CLI=' + Auxiliaire;
   Argument := Argument + ';TIERS=' + CodeTiers;
   Argument := Argument + ';NATUREAUXI=CLI';

   NumAdr := AglLanceFiche('GC', 'GCADRESSES', Range, '', Argument);

   if NumAdr <> '' then
  	  Begin
	    Argument := 'SELECT ADR_NADRESSE FROM ADRESSES WHERE ADR_NUMEROADRESSE='+ NumAdr;
      Q := OpenSQL(Argument,false);
      SetControlText('YTC_NADRESSELIV', Q.findfield('ADR_NADRESSE').AsString);
      Ferme(Q);
	    LectureAdresseIntervention;
      end;

end;

Procedure TOF_APPEL.LectureAdresseIntervention;
Var TobAdrInt : Tob;
		Req       : String;
Begin

  req := '';

  Req := 'SELECT ADR_LIBELLE,ADR_LIBELLE2,ADR_ADRESSE1, ADR_ADRESSE2, ADR_ADRESSE3, ';
  Req := Req + 'ADR_CODEPOSTAL, ADR_VILLE, ADR_PAYS, ADR_NUMEROCONTACT, ADR_TELEPHONE, ';
  Req := Req + 'ADR_BLOCNOTE ';
  Req := Req + ' FROM ADRESSES WHERE AND ADR_REFCODE ="' + CodeTiers;
  Req := Req + '" AND ADR_INT="X" AND ADR_NADRESSE=' + GetControlText('YTC_NADRESSELIV');
//  Req := Req + '" AND ADR_TYPEADRESSE="INT" AND ADR_NADRESSE=' + GetControlText('YTC_NADRESSELIV');

  TobAdrInt := Tob.Create('LesAdrInt',Nil, -1);
  TobAdrInt.LoadDetailDBFromSQL('ADRESSES',req,false);

  if TobAdrInt.Detail.Count <> 0 then AfficheAdresseIntervention(TobAdrInt);

  TobAdrInt.free;

end;

//Affichage de l'adresse d'intervention
Procedure TOF_APPEL.AfficheAdresseIntervention(TobAdrInt : TOB);
Begin

  SetControlProperty('YTC_NADRESSELIV', 'VISIBLE', false);

  With TobAdrInt.Detail[0] do
  	   Begin
  	   SetControltext('TLIBELLE', GetValue('ADR_LIBELLE'));
       SetControltext('T_PRENOM', GetValue('ADR_LIBELLE2'));
	     SetControltext('T_ADRESSE1', GetValue('ADR_ADRESSE1'));
	     SetControltext('T_ADRESSE2', GetValue('ADR_ADRESSE2'));
	     SetControltext('T_ADRESSE3', GetValue('ADR_ADRESSE3'));
	     SetControltext('T_CODEPOSTAL', GetValue('ADR_CODEPOSTAL'));
	     SetControltext('T_VILLE', GetValue('ADR_VILLE'));
	     SetControltext('T_PAYS', GetValue('ADR_PAYS'));
       //SetControltext('AFF_DESCRIPTIF', GetValue('ADR_BLOCNOTE'));
       if GetControlText('T_NOMCONTACT') = '' then
     	  	Begin
	 	      SetControltext('YTC_CONTACT', GetValue('ADR_NUMEROCONTACT'));
	        SetControltext('T_TELEPHONE', GetValue('ADR_TELEPHONE'));
          end;
       end;
       
end;

{***********A.G.L.***********************************************
Auteur  ...... : Franck Vautrain
Créé le ...... : 11/05/2005
Modifié le ... :   /  /
Description .. : Description .. : Fonction d'affichage des données du
Suite ........ : Contact principal dans la fiche Appel.
Mots clefs ... :
*****************************************************************}
Procedure TOF_APPEL.RechContactTiers;
var Req        : String;
    TobContact : Tob;
begin

  Req := 'SELECT * FROM CONTACT WHERE ';
  Req := Req + 'C_TYPECONTACT = "T" AND ';
  Req := Req + 'C_AUXILIAIRE ="' + auxiliaire + '" AND ';
  Req := Req + 'C_TIERS = "'+ CodeTiers + '" AND ';
  Req := Req + 'C_NATUREAUXI = "CLI" ';

  TobContact := Tob.Create('LesContacts',Nil, -1);
  TobContact.LoadDetailDBFromSQL('CONTACT',req,false);

  if TobContact.Detail.Count = 0 then
  	 Begin
     {
     SetControlProperty('T_FAX', 'Visible', False);
     Telex.Visible := false;
     //SetControlProperty('T_TELEX', 'Visible', False);
     SetControlProperty('T_EMAIL', 'Visible', False);
     SetControlProperty('T_RVA', 'Visible', False);
		 SetControlProperty('BTCONTACT', 'Visible', False);
     }
  	 end
  Else if TobContact.Detail.Count > 1 then
     //lancement d'un grille pour sélection du Contact
  	 Begin
//     SetControlProperty('YTC_CONTACT', 'VISIBLE', true);
//     Contact.ElipsisClick(Contact);
     VoirContacts (application);
     End
  else
  	 Begin
     SetControlText('YTC_CONTACT', TobContact.Detail[0].GetValue('C_NUMEROCONTACT'));
     AfficheContact(TOBContact);
  	 end;

  TobContact.free;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Franck Vautrain
Créé le ...... : 11/05/2005
Modifié le ... :   /  /
Description .. : Appel de la recherche des contacts dans le cas ou le client
Suite ........ : dispose de + d'un contact
Mots clefs ... :
*****************************************************************}
procedure TOF_APPEL.AppelContact(sender : Tobject);
Var Req        : String;
begin

  Req := '';
  Req := 'C_AUXILIAIRE="' + Auxiliaire + '"';

  SetControlProperty('YTC_CONTACT', 'Datatype', 'BTCONTACT');
  SetControlProperty('YTC_CONTACT', 'Plus', req);

  LookupCombo(Contact);

  if getcontroltext('YTC_CONTACT')='' then exit;

	//if OkRechercheContact (GetControl('YTC_CONTACT'),['C_NUMEROCONTACT','C_CLETEL'],Req) then exit;

  //Lecture du contact sélectionné et affichage des informations
  Lecturecontact;

end;

procedure TOF_APPEL.AppelContactTiers(Requete : string);
Begin

  SetControlProperty('YTC_CONTACT', 'Datatype', 'BTCONTACTTIERS');
  SetControlProperty('YTC_CONTACT', 'Plus', Requete);

  LookupCombo(Contact);

	//if OkRechercheContact (GetControl('YTC_CONTACT'),['C_NUMEROCONTACT','C_AUXILIAIRE'],Requete) then exit;

  if getcontroltext('YTC_CONTACT')='' then exit;

end;

Procedure TOF_APPEL.VoirContacts(Sender : TOBJect);
Var Argument   : String;
		NumContact : String;
Begin

  Argument := '';
  NumContact := '';

  Argument := 'TYPE=T;';
  Argument := Argument + 'TYPE2=CLI;';
  Argument := Argument + 'PART=-;';
  Argument := Argument + 'TITRE='+ GetControlText('TLIBELLE') +';';
  Argument := Argument + 'TIERS='+CodeTiers+';';
  Argument := Argument + 'ALLCONTACT';

  Numcontact := AGLLanceFiche('YY','YYCONTACT','T;'+Auxiliaire,'', Argument);

  if Numcontact = '' then
     NumContact := GetControlText('YTC_CONTACT')
  Else
     SetControlText('YTC_CONTACT', NumContact);

	LectureContact;

end;


Procedure TOF_APPEL.LectureContact;
Var TobContact  : TOB;
    Req         : String;
    CodeContact : String;
    Numtel			: String;
Begin

  DecoupeYTContact(CodeContact, Numtel);
  if CodeContact = '' then exit;
  Req := '';
  Req := 'SELECT * FROM CONTACT WHERE C_AUXILIAIRE ="' + Auxiliaire + '" AND C_NUMEROCONTACT=' + CodeContact;

  TobContact := Tob.Create('LesContacts',Nil, -1);
  TobContact.LoadDetailDBFromSQL('CONTACT',req,false);

  if TobContact.Detail.Count <> 0 then AfficheContact(TobContact);

  SetControlProperty('YTC_CONTACT', 'VISIBLE', False);

  TobContact.free;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Franck Vautrain
Créé le ...... : 10/05/2005
Modifié le ... :   /  /
Description .. : Découpage de la zone YTC_CONTACT lorsque celle ci
Suite ........ : passe le compte auxiliaire et le code contact
Mots clefs ... :
*****************************************************************}
procedure Tof_Appel.DecoupeYTContact (Var Param1: string; Var Param2 : string);
Var //NoContact  : String;
    indice     : integer;
    Chaine,param : string;
Begin

	Chaine := GetControlText('YTC_CONTACT');
  Indice := 0;

	repeat
    param := READTOKENST (Chaine);
    if Param <> '' then
       begin
       if indice = 0 then
          Param1 := Param
       Else
          Param2:=param;
       inc(indice);
       end;
  until Param = '';

	setcontrolText('YTC_CONTACT', Param1);

end;

Procedure TOF_APPEL.AfficheContact(TobContact: TOB);
Begin

  Telex.visible := True;
  //SetControlProperty('T_TELEX', 'VISIBLE', True);
  SetControlProperty('T_FAX', 'VISIBLE', True);
  SetControlProperty('T_EMAIL', 'VISIBLE', True);

	With TobContact.Detail[0] do
			 Begin
		   SetControltext('YTC_CONTACT', GetValue('C_NUMEROCONTACT'));
			 SetControltext('T_NOMCONTACT', GetValue('C_NOM'));
			 SetControltext('T_TELEPHONE', GetValue('C_TELEPHONE'));
       Telex.text :=    GetValue('C_TELEX');
  		 //SetControltext('T_TELEX', GetValue('C_TELEX'));
			 SetControltext('T_FAX', GetValue('C_FAX'));
			 SetControltext('T_EMAIL', GetValue('C_RVA'));
  		 End;

  AdrMailClt := GetControlText('T_EMAIL');

End;

//Description .. : Fonction d'affichage des données du contrat principal
//Suite ........ : dans la fiche Appel.
Procedure TOF_APPEL.RechContratTiers;
var Req        : String;
    TobContrat : TOB;
begin

  Req := 'SELECT * FROM AFFAIRE WHERE AFF_STATUTAFFAIRE = "INT" AND AFF_TIERS = "'+ CodeTiers +'"';
  Req := Req + 'AND AFF_ETATAFFAIRE <> "CLO"';

  TobContrat := Tob.Create('LesContrats',Nil, -1);
  TobContrat.LoadDetailDBFromSQL('AFFAIRE',req,false);

  if TobContrat.detail.count = 0 then
     AfficheGroupContrat(False)
  Else if TobContrat.detail.count > 1 then
     Begin
//     SetControlProperty('YTC_CONTRAT', 'VISIBLE', true);
//     Contrat.ElipsisClick (Contrat);
		 VoirContrats (Application);
     End
  Else
     Begin
     SetControltext('YTC_CONTRAT', TobContrat.Detail[0].GetValue('AFF_AFFAIRE'));
     AfficheContrat(TobContrat);
     End;

  TobContrat.free;

End;

Procedure TOF_APPEL.AfficheGroupContrat(Enable : Boolean);
Begin

  SetControlProperty('CHKCONTRAT', 'ENABLED', not Enable);
  SetControlProperty('CHKGARANTIE', 'ENABLED', not Enable);
  SetControlProperty('CHKTACHE', 'ENABLED', not Enable);

  SetControlProperty('AFF_CONTRAT1', 'ENABLED', Enable);
  SetControlProperty('AFF_CONTRAT2', 'ENABLED', Enable);
  SetControlProperty('AFF_CONTRAT3', 'ENABLED', Enable);

  SetControlProperty('CON_AVENANT', 'ENABLED', Enable);

  //BTCONTRAT.VISIBLE := Enable;
  //BEFFACECON.VISIBLE := Enable;

end;

procedure TOF_APPEL.AppelContrat(sender: Tobject);
Var Req : String;
begin

  Req := ' AFF_TIERS="' + CodeTiers + '" AND AFF_ETATAFFAIRE <> "CLO"';

  SetControlProperty('YTC_CONTRAT', 'Datatype', 'BTCONTRAT');
  SetControlProperty('YTC_CONTRAT', 'Plus', req);

  LookupCombo(Contrat);

  if getcontroltext('YTC_CONTRAT')='' then exit;

  CodeContrat := getcontroltext('YTC_CONTRAT');

  //Lecture du contact sélectionné et affichage des informations
  Lecturecontrat;

end;

procedure TOF_APPEL.VoirChantier(Sender: TOBJect);
Var Argument   : string;
		C0, C1, C2, C3 : THCritMaskEdit;
    Avenant, Tiers : THCritMaskEdit;
begin

  SetControlText('AFF_CHANTIER0', 'A');

	C0 := THEDIT(GetControl('AFF_CHANTIER0'));
	C1 := THEDIT(GetControl('AFF_CHANTIER1'));
	C2 := THEDIT(GetControl('AFF_CHANTIER2'));
	C3 := THEDIT(GetControl('AFF_CHANTIER3'));
	Avenant := THEDIT(GetControl('CHA_AVENANT'));
	Tiers := THEDIT(GetControl('AFF_TIERS'));

  if CodeChantier = '' then
     Begin       
     if not GetAffaireEnteteSt(C0,C1,C2,C3,Avenant, Tiers, CodeChantier,false,false,false,true,false) then
      	CodeChantier := '';
     end
  else
  	 Begin
	   Argument := '';
     Argument := 'STATUT:AFF;AFF_TIERS=' + Codetiers;
     Argument := AGLLanceFiche('BTP','BTAFFAIRE','',CodeChantier, Argument);
  	 End;

  if CodeChantier = '' then exit;

  if CodeTiers = '' then Client.OnExit(Client);;

  LectureChantier;

  if EtabChantier <> '' then
     SetControltext('AFF_ETABLISSEMENT', EtabChantier);

end;

Function TOF_APPEL.LectureChantier : Boolean  ;
Var TobChantier: TOB;
    Req        : String;
Begin
  Result := True;
  Req := '';

  Req := 'SELECT * FROM AFFAIRE ';
  Req := Req + 'WHERE AFF_AFFAIRE ="' + CodeChantier + '"';

  TobChantier := Tob.Create('LesChantiers',Nil, -1);
  TobChantier.LoadDetailDBFromSQL('AFFAIRE',req,false);

  if TobChantier.Detail.Count <> 0 then AfficheChantier(TobChantier)
  else if CodeChantier <> '' then Result := False;

  TobChantier.free;

End;

Procedure TOF_APPEL.AfficheChantier(TobChantier : tob);
Var A1      : String;
    A2      : String;
    A3      : String;
Begin

  A1 := TobChantier.Detail[0].GetValue('AFF_AFFAIRE1');
  A2 := TobChantier.Detail[0].GetValue('AFF_AFFAIRE2');
  A3 := TobChantier.Detail[0].GetValue('AFF_AFFAIRE3');

  CodeChantier := TobChantier.Detail[0].GetValue('AFF_AFFAIRE');

  //SetControlCaption('GROUPCONTRAT', 'CONTRAT N° ' + A1 + A2 + A3);

  SetControlText('AFF_CHANTIER0', TobChantier.Detail[0].GetValue('AFF_AFFAIRE0'));
  SetControlText('AFF_CHANTIER1', A1);
  SetControlText('AFF_CHANTIER2', A2);
  SetControlText('AFF_CHANTIER3', A3);
  SetControlText('CHA_AVENANT', TobChantier.Detail[0].GetValue('AFF_AVENANT'));
  if GetParamSocSecur('SO_GCVENTCPTAAFF', False) then
  begin
  	SetControlText('AFF_COMPTAAFFAIRE',TobChantier.Detail[0].GetValue('AFF_COMPTAAFFAIRE'));
  end;
  SetControlText('TT_LIBAFFAIRE',TobChantier.Detail[0].GetValue('AFF_LIBELLE'));

  if CodeTiers = '' then
     client.Text := TobChantier.Detail[0].GetValue('AFF_TIERS');
  	 //Begin
		 //SetControlText('AFF_TIERS',TobChantier.Detail[0].GetValue('AFF_TIERS'));
     //end;
  EtabChantier := TobChantier.Detail[0].GetValue('AFF_ETABLISSEMENT');

End;

procedure TOF_APPEL.VoirContrats(Sender: TOBJect);
Var Argument   : string;
		C0, C1, C2, C3 : THCritMaskEdit;
    Avenant, Tiers : THCritMaskEdit;
    CC0,CC1,CC2,CC3,AV : string;
begin

	C0 := THEDIT(GetControl('AFF_CONTRAT0'));
	C1 := THEDIT(GetControl('AFF_CONTRAT1'));
	C2 := THEDIT(GetControl('AFF_CONTRAT2'));
	C3 := THEDIT(GetControl('AFF_CONTRAT3'));
	Avenant := THEDIT(GetControl('CON_AVENANT'));
	Tiers := THEDIT(GetControl('AFF_TIERS'));

  if CodeContrat = '' then
     Begin
     if not GetAffaireEnteteSt(C0,C1,C2,C3,Avenant, Tiers, CodeContrat,false,false,false,false,false,'',false,true,false,'ACP') then
      	CodeContrat := '';
     end
  else
  	 Begin
	   Argument := '';
     //Argument := 'STATUT:INT;ETAT:ENC;';
     Argument := 'STATUT:INT;';
     Argument := Argument + 'AFF_TIERS=' + Codetiers;
     Argument := AGLLanceFiche('BTP','BTAFFAIRE','',CodeContrat, Argument);
  	 End;

  if CodeContrat = '' then exit;
  BTPCodeAffaireDecoupe (CodeContrat,CC0,CC1,CC2,CC3,Av,taCreat,false);
  C0.Text := CC0;
  C1.Text := CC1;
  C2.Text := CC2;
  C3.Text := CC3;
  Avenant.Text := AV;
  SetControlText('YTC_CONTRAT', CodeContrat);

  if CodeTiers = '' then Client.OnExit(Client);;

	LectureContrat;

end;

procedure TOF_APPEL.LectureContrat;
Var TobContrat : TOB;
    Req        : String;
Begin

  Req := '';

  Req := 'SELECT * FROM AFFAIRE ';
  Req := Req + 'WHERE AFF_AFFAIRE ="' + CodeContrat + '"';

  if codetiers <> '' then
	  Req := Req + 'AND AFF_TIERS ="' + CodeTiers + '"';

  TobContrat := Tob.Create('LesContrats',Nil, -1);
  TobContrat.LoadDetailDBFromSQL('AFFAIRE',req,false);

  if TobContrat.Detail.Count <> 0 then AfficheContrat(TobContrat);

  SetControlProperty('YTC_CONTRAT', 'VISIBLE', False);

  TobContrat.free;

End;

Procedure TOF_APPEL.AfficheContrat(TobContrat : tob);
Var A1      : String;
    A2      : String;
    A3      : String;
    DateRef : TdateTime;
Begin

  SetControlProperty('YTC_CONTRAT', 'VISIBLE', False);

  BTCONTRAT.VISIBLE := True;

  A1 := TobContrat.Detail[0].GetValue('AFF_AFFAIRE1');
  A2 := TobContrat.Detail[0].GetValue('AFF_AFFAIRE2');
  A3 := TobContrat.Detail[0].GetValue('AFF_AFFAIRE3');

  CodeContrat := TobContrat.Detail[0].GetValue('AFF_AFFAIRE');

  AfficheGroupContrat(true);

  //SetControlCaption('GROUPCONTRAT', 'CONTRAT N° ' + A1 + A2 + A3);

  SetControlText('AFF_CONTRAT0', TobContrat.Detail[0].GetValue('AFF_AFFAIRE0'));
  SetControlText('AFF_CONTRAT1', A1);
  SetControlText('AFF_CONTRAT2', A2);
  SetControlText('AFF_CONTRAT3', A3);
  SetControlText('CON_AVENANT', TobContrat.Detail[0].GetValue('AFF_AVENANT'));

  SetControlText('AFF_DATEDEBCONTRAT',TobContrat.Detail[0].GetValue('AFF_DATEDEBUT'));
  SetControlText('AFF_DATEFINCONTRAT',TobContrat.Detail[0].GetValue('AFF_DATEFIN'));

  SetControlText('AFF_DATEGARANTIE',TobContrat.Detail[0].GetValue('AFF_DATEGARANTIE'));
  SetControlText('AFF_DATESIGNE',TobContrat.Detail[0].GetValue('AFF_DATESIGNE'));
  SetControlText('AFF_DATELIMITE',TobContrat.Detail[0].GetValue('AFF_DATELIMITE'));

  SetControlProperty('AFF_DATELIMITE', 'VISIBLE', True);
  SetControlProperty('AFF_DATESIGNE', 'VISIBLE', True);
  SetControlProperty('AFF_DATEGARANTIE', 'VISIBLE', True);

  //SetControlText('ARS_RESSOURCE',TobContrat.Detail[0].GetValue('AFF_RESPONSABLE'));

  //Si création à partir du Planning...
  //if AppelPlan then
  //   if LaTob <> nil then SetControlText('ARS_RESSOURCE',LaTOB.GetString('RESSOURCE'));

  //if GetControlText('ARS_RESSOURCE') <> '' then LectureResponsable;

  if TobContrat.Detail[0].GetValue('AFF_DATERESIL') <> idate2099 then
     if TobContrat.Detail[0].GetValue('AFF_DATERESIL') < date then
	   Begin
   	   LastErrorMsg := TexteMessage [4] + datetostr(TobContrat.Detail[0].GetValue('AFF_DATERESIL'));
       if TobContrat.Detail[0].GetValue('AFF_RESILAFF') <> '' then
       	LastErrorMsg := LastErrorMsg+ ' pour ' + TobContrat.Detail[0].GetValue('AFF_RESILAFF');
			 Titre := 'Résiliation Contrat';
       AfficheErreur;
       Titre := '';
     End;

  if TobContrat.Detail[0].GetValue('AFF_DATEGARANTIE') < date then
  Begin
     SetControlChecked('CHKGARANTIE', False);
     LastError := 2;
     Titre := 'Date de Garantie';
     AfficheErreur;
     Titre := '';
  end
  Else
     SetControlChecked('CHKGARANTIE', True);

  DateRef := TobContrat.Detail[0].GetValue('AFF_DATEFIN');

  if DateRef < date then
  Begin
     LastErrorMsg := TexteMessage [3] + DateToStr(DateRef);
     Titre := 'Date de Fin de Contrat';
     AfficheErreur;
     Titre := '';
  end;

  if CodeTiers = '' then Client.Text := TobContrat.Detail[0].GetValue('AFF_TIERS');
  	 //Begin
  	 //SetControlText('AFF_TIERS',TobContrat.Detail[0].GetValue('AFF_TIERS'));
     //end;

End;

procedure TOF_APPEL.AppelResponsable(sender: Tobject);
Var Req        : String;
begin

  Req := '';
  Req := ' ARS_TYPERESSOURCE="SAL" OR ARS_TYPERESSOURCE="ST"';

  SetControlProperty('AFF_RESPONSABLE', 'Plus', req);

  LookupCombo(Responsable);

  if getcontroltext('AFF_RESPONSABLE')='' then BEGIN SetControltext('TAFF_RESPONSABLE','');exit; END;

//  SetControlText('ARS_RESSOURCE', GetControlText('AFF_RESPONSABLE'));
//  SetControlText('AFF_RESPONSABLE', '');

  //Lecture des Ressources sélectionné et affichage des informations
  LectureResponsable;

end;

procedure TOF_APPEL.VoirResponsable(sender: TObject);
Var NumRessource : String;
    Argument   : string;
begin

  Argument := '';

  NumRessource := AGLLanceFiche('AFF','RESSOURCE','',GetControlText('AFF_RESPONSABLE'), '');

  if NumRessource = '' then exit;

  SetControlText('AFF_RESPONSABLE', NumRessource);

  LectureResponsable;

end;

procedure TOF_APPEL.LectureResponsable;
Var TobRessource : TOB;
    Req          : String;
Begin

  Req := '';
  Req := 'SELECT * FROM RESSOURCE ';
  Req := Req + 'WHERE ARS_RESSOURCE ="' + GetControlText('AFF_RESPONSABLE') + '"';

  TobRessource := Tob.Create('LesRessources',Nil, -1);
  TobRessource.LoadDetailDBFromSQL('RESSOURCE',req,false);

  if TobRessource.Detail.Count <> 0 then
     AfficheResponsable(TobRessource)
  else
     LectureUtilisateur;

  TobRessource.free;

end;

procedure TOF_APPEL.LectureRessourceAssociee (Utilisateur : String; Var CodRes, LibRes : String);
Var TobRessource : TOB;
    Req          : String;
Begin

  Req := '';
  Req := 'SELECT ARS_RESSOURCE, ARS_LIBELLE, ARS_LIBELLE2 FROM RESSOURCE ';
  Req := Req + 'WHERE ARS_UTILASSOCIE ="' + Utilisateur + '"';

  TobRessource := Tob.Create('LesRessources',Nil, -1);
  TobRessource.LoadDetailDBFromSQL('RESSOURCE',req,false);

  if TobRessource.Detail.Count <> 0 then
  begin
    CodRes := TobRessource.Detail[0].getValue('ARS_RESSOURCE');
    LibRes := TobRessource.Detail[0].getValue('ARS_LIBELLE')+' '+TobRessource.Detail[0].getValue('ARS_LIBELLE2');
  end else
  begin
    CodRes := '';
    LibRes := '';
  end;
  TobRessource.free;
end;

procedure TOF_APPEL.LectureUtilisateur;
var TobUser : TOB;
    Req     : String;
    Nom		  : String;
begin

	Nom := '';

  Req := 'SELECT US_LIBELLE FROM UTILISAT ';
  Req := Req + 'WHERE US_UTILISATEUR ="' + GetControlText('AFF_RESPONSABLE') + '"';

  TobUser := Tob.Create('TobUser',Nil, -1);
  TobUser.LoadDetailDBFromSQL('UTILISAT',req,false);

  if TobUser.Detail.Count <> 0 then
     Begin
     Nom := TobUser.Detail[0].GetValue('US_LIBELLE');
     SetControlText('TAFF_RESPONSABLE',Nom);
     end
  else
  	 begin
//     SetControlText('ARS_RESSOURCE','');
     SetControlText('TAFF_RESPONSABLE',Nom);
     end;

	TobUser.free;

end;

function TOF_APPEL.LectureTiers : Boolean;
Var TobTiers : TOB;
    Req          : String;
Begin

  Result := True;

  Req := '';
  Req := 'SELECT * FROM TIERS ';
  Req := Req + 'WHERE T_NATUREAUXI ="CLI" AND T_TIERS="' + CodeTiers + '"';

  TobTiers := Tob.Create('LesTiers',Nil, -1);
  TobTiers.LoadDetailDBFromSQL('TIERS',req,false);

  if TobTiers.Detail.Count = 0 then
  Begin
     Result := false;
     LastError := 24;
     exit;
  end;

  Auxiliaire := TobTiers.Detail[0].GetValue('T_AUXILIAIRE');

  RisqueTiers;

  if ControlRisque then exit;

  if ClientFerme(TobTiers.Detail[0].GetValue('T_FERME')) then exit;

  if TobTiers.Detail[0].getvalue('T_DEVISE') <> '' then
     devise := TobTiers.Detail[0].getvalue('T_DEVISE')
  else
     Result := ControleDevise;

	AfficheTiers(TobTiers);

  TobTiers.free;

end;

procedure TOF_APPEL.AfficheResponsable(TobRessource: tob);
Var Nom : String;
begin

  Nom := TobRessource.Detail[0].GetValue('ARS_LIBELLE') + ' ' + TobRessource.Detail[0].GetValue('ARS_LIBELLE2');
  AdrMailRes := TobRessource.Detail[0].GetValue('ARS_EMAIL');

  SetControlText('TAFF_RESPONSABLE',Nom);

  if AFTypeAction = taConsult then exit;

  if getControlText('AFF_RESPONSABLE')= '' then
     // SetControlText('ARS_RESSOURCE', '')
  Else
     Begin
     if (CodeEtat <> 'ACA') And (CodeEtat <> 'ACD') And (CodeEtat <> 'FAC') then
        Begin
	 	  CodeEtat := 'AFF';
     	  SetControlCaption('TAFF_ETAT', 'Affecté');
     	  end;
     end;

end;

procedure TOF_APPEL.CtrlResponsable(Sender: TObject);
begin

  if getControlText('AFF_RESPONSABLE')= '' then
  Begin
//     SetControlText('ARS_RESSOURCE','');
     if TobAppel.getValue('AFF_ETATAFFAIRE') = 'ECO' then
		  SetControlCaption('TAFF_ETAT', 'En-Cours')
     else if TobAppel.getValue('AFF_ETATAFFAIRE') = 'ACA' then
		  SetControlCaption('TAFF_ETAT', 'Accepté')
     else if TobAppel.getValue('AFF_ETATAFFAIRE') = 'ACD' then
		  SetControlCaption('TAFF_ETAT', 'Attente Acceptation')
	  else if TobAppel.getValue('AFF_ETATAFFAIRE') = 'ANN' then
	     SetControlCaption('TAFF_ETAT', 'Annulé')
	  else if TobAppel.getValue('AFF_ETATAFFAIRE') = 'REA' then
	     SetControlCaption('TAFF_ETAT', 'Réalisé')
     else if TobAppel.getValue('AFF_ETATAFFAIRE') = 'FAC' then
	     SetControlCaption('TAFF_ETAT', 'Facturé')
     else if TobAppel.getValue('AFF_ETATAFFAIRE') = 'TER' then
	     SetControlCaption('TAFF_ETAT', 'Terminé')
     else
	     SetControlCaption('TAFF_ETAT', 'En-Cours');
  end Else
  Begin
    CodeEtat := 'AFF';
    SetControlCaption('TAFF_ETAT', 'Affecté');
//    SetControlText('ARS_RESSOURCE', GetControlText('AFF_RESPONSABLE'));
		LectureResponsable ;
  end;

end;

//Appel de l'écran des encours
procedure TOF_APPEL.VoirEncours(sender : Tobject);
var TobTiers : TOB ;
    VOR, OkOk : string ;
    Action : TActionFiche ;
    Qfiche : TQuery;
begin

Action:=AFTypeAction;

Qfiche := OpenSql ('SELECT * FROM TIERS WHERE T_TIERS = "'+ CodeTiers + '"',true);
TOBTiers:=Tob.create('TIERS',Nil,-1);
TOBTiers.selectDB ('',QFiche,True) ;
ferme (Qfiche);

CalculSoldesAuxi(TOBTiers.GetValue('T_AUXILIAIRE')) ;

// Pour recharger les données calculées
TobTiers.LoadDB(True);
TheTob:=TobTiers;

OkOk:=AglLanceFiche('GC', 'GCENCOURS','','',ActionToSTring(Action));

TheTob := nil;

if (OkOk='OK') and (Action<>taConsult) then
   begin
   VOR:=tobTiers.getvalue('T_ETATRISQUE');
   if VOR <> '' then
      setControlText('T_RISQUE',VOR)
   else
      setControlText('T_RISQUE',EtatRisque);
   setControlText('T_ETATRISQUE',VOR) ;
   end;

TobTiers.free;

end;

// version provisoire du calcul du risque client
function TOF_APPEL.RisqueTiers: String;
var RisqueTiers : double;
    CreditAcc   : double;
    CreditPlaf  : double;
    TobTiers    : TOB;
    QFiche      : TQuery;
begin

// L'état du risque calculé est stocké dans EtatRisque.
//La fonction retourne l'état réelle qui a pu être forcé
EtatRisque:='V' ;

Qfiche := OpenSql ('SELECT * FROM TIERS WHERE T_TIERS = "'+ CodeTiers + '"',true);

// DCA - FQ MODE 10855 - Eviter requête inutile
CreditAcc := QFiche.findfield ('T_CREDITACCORDE').AsInteger ;
CreditPlaf := QFiche.findfield ('T_CREDITPLAFOND').AsInteger ;

if (CreditAcc>0) or (CreditPlaf>0) then
  begin
  TOBTiers:=Tob.create('TIERS',Nil,-1);
	TOBTiers.selectDB ('',QFiche,True) ;
  RisqueTiers:=RisqueTiersGC(TOBTiers)+RisqueTiersCPTA(TOBTiers,V_PGI.DateEntree) ;
  if ((CreditAcc>0 ) and (RisqueTiers > CreditAcc)) then EtatRisque:='O' ;
  if ((CreditPlaf>0 ) and (RisqueTiers > CreditPlaf)) then EtatRisque:='R' ;
  TobTiers.free;
  end;

SetControlText('T_RISQUE',EtatRisque);

if QFiche.findfield ('T_ETATRISQUE').AsString <>'' then
   begin
   setcontroltext('T_RISQUE',QFiche.findfield ('T_ETATRISQUE').AsString);
   end;

ferme (Qfiche);

End;

//Gestion de l'affichage du bouton feu en fonction du risque (0/R/V)
Procedure TOF_APPEL.GestionFeuEncour(Sender: TObject);
Var Couleur : String;
Begin

	Couleur := GetControlText('T_RISQUE');

	SetControlProperty('FEUROUGE', 'visible', Couleur='R');
	SetControlProperty('FEUORANGE', 'visible', Couleur='O');
	SetControlProperty('FEUVERT', 'visible', Couleur='V');

End;

{***********A.G.L.***********************************************
Auteur  ...... : Franck Vautrain
Créé le ...... : 09/05/2005
Modifié le ... : 09/05/2005
Description .. : gestion du click sur le bouton Importance Basse
Suite ........ :
Mots clefs ... : IMPORTANCE BASSE
*****************************************************************}
procedure TOF_APPEL.BasseClick(sender: TObject);
var GP_Val : TGroupBox;
begin

	BTHaute.Flat := False;
  BTNormale.Flat := False;
  BTBasse.Flat := True;

  Importance := '3';
 	SetControlCaption('TAFF_IMPORTANCE', 'BASSE');

  GP_VAL := TGroupBox(GetControl('GROUPVALEUR'));

  if GP_Val.visible then
     Begin
	   Lib_Affaire.Font.Color := clBlue;
	   Lib_Affaire.Refresh;
     end;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Franck Vautrain
Créé le ...... : 09/05/2005
Modifié le ... : 09/05/2005
Description .. : gestion du click sur le bouton Importance Haute
Suite ........ :
Mots clefs ... : IMPORTANCE HAUTE
*****************************************************************}
procedure TOF_APPEL.HauteClick(sender: TObject);
var GP_Val : TGroupBox;
begin

  BTNormale.Flat := False;
  BTBasse.Flat := False;
 	BTHaute.Flat := True;

  Importance := '1';
 	SetControlCaption('TAFF_IMPORTANCE', 'HAUTE');

  GP_VAL := TGroupBox(GetControl('GROUPVALEUR'));

  if GP_Val.visible then
     Begin
  	 Lib_Affaire.Font.Color := clMaroon;
	   Lib_Affaire.Refresh;
     end;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Franck Vautrain
Créé le ...... : 09/05/2005
Modifié le ... : 09/05/2005
Description .. : gestion du click sur le bouton Importance Normale
Suite ........ :
Mots clefs ... : IMPORTANCE NORMALE
*****************************************************************}
procedure TOF_APPEL.NormaleClick(sender: TObject);
var GP_Val : TGroupBox;
begin

	BTHaute.Flat := False;
  BTBasse.Flat := False;
  BTNormale.Flat := True;

  Importance := '2';
 	SetControlCaption('TAFF_IMPORTANCE', 'NORMALE');

  GP_VAL := TGroupBox(GetControl('GROUPVALEUR'));

  if GP_Val.visible then
     Begin
	   Lib_Affaire.Font.Color := ClGreen;
  	 Lib_Affaire.Refresh;
     end;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Franck Vautrain
Créé le ...... : 09/05/2005
Modifié le ... :   /  /
Description .. : Controle si le tiers ou le contact existe en fonction
Suite ........ : de son Numero de Téléphone
Mots clefs ... : NUMERO DE TÉLÉPHONE
*****************************************************************}
procedure TOF_APPEL.TelephoneExit(sender: TObject);
begin

  CleTel := '';
  CleTel := GetControlText('T_TELEPHONE');

  if CleTel = '' then Exit;

  if CodeTiers <> '' then Exit;

  ChargementAppel;
  SetInfosTel (false);
  if OldNoTel = CleTel then exit;

  OldNoTel := CleTel;

end;

procedure TOF_APPEL.FaxExit(sender: TObject);
begin

  CleTel := '';
  CleTel := Fax.text;

  if CleTel = '' then Exit;

  if CodeTiers <> '' then Exit;

  ChargementAppel;
  SetInfosTel (false);

  if OldNoTel = CleTel then exit;

  OldNoTel := CleTel;

end;

procedure TOF_APPEL.TelExit(sender: TObject);
begin

  CleTel := '';
  CleTel := Telex.text;

  if CleTel = '' then Exit;

  if CodeTiers <> '' then Exit;

  ChargementAppel;
  SetInfosTel (false);

  if OldNoTel = CleTel then exit;

  OldNoTel := CleTel;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Franck Vautrain
Créé le ...... : 11/05/2005
Modifié le ... :   /  /
Description .. : Recherche le contact en fonction de son nom
Mots clefs ... :
*****************************************************************}
procedure TOF_APPEL.NomContactExit(sender: TObject);
begin

  If OldNomCon = GetControlText('T_NOMCONTACT') then exit;

  If CodeTiers <> '' then Exit;

  OldNomCon := GetControlText('T_NOMCONTACT');

  If not CtrlExitZoneContact('C_NOM LIKE ', OldNomCon + '%') then
     Begin
     AfficheErreur;
     SetControlText('T_NOMCONTACT', '');
     OldNomCon := '';
     end;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Franck Vautrain
Créé le ...... : 11/05/2005
Modifié le ... :   /  /
Description .. : Recherche le tiers en fonction du Nom, de l'adresse
Mots clefs ... :
*****************************************************************}
procedure TOF_APPEL.NomTiersExit(sender: TObject);
begin

	Titre := '';

  if GetControlText('TLIBELLE') = '' then Exit;

  if Codetiers <> '' then exit;

  if OldNomTie = GetControlText('TLIBELLE') then exit;

  OldNomTie := GetControlText('TLIBELLE');

  If not CtrlExitZoneTiers('T_LIBELLE LIKE ', OldNomTie + '%') then
  	 Begin
     If not CtrlExitZoneTiers('T_PHONETIQUE LIKE ', phoneme(OldNomTie) + '%') then
        Begin
        if not CtrlNomAdresse('ADR_LIBELLE LIKE ', OldNomTie + '%') then
           Begin
           AfficheErreur;
			     AppelRechTiers('T_NATUREAUXI="CLI"');
           end;
        end;
     end;

	If CodeTiers = '' then OldNomTie := '';

  RechContactTiers;

  RechContratTiers;

  SetFocusControl('AFF_DESCRIPTIF');

end;
{***********A.G.L.***********************************************
Auteur  ...... : Franck Vautrain
Créé le ...... : 10/05/2005
Modifié le ... :   /  /
Description .. : Controle des zones en sortie appartenant au tiers
Mots clefs ... :
*****************************************************************}
Function TOF_APPEL.CtrlExitZoneTiers(NomZone, ZoneTxt : String) : boolean;
Var TobTiers   : Tob;
		QQ         : TQuery;
    Req        : String;
    NatAux     : String;
    LibTiers	 : String;
Begin

  Titre := '';
  Result := False;
  CodeTiers := '';
  LibTiers := '';

  Raz_Zone_Ecran;
  if ZoneTxt = '' then Exit;

  //Lecture du tiers pour Récupération code tiers
	Req := Req + 'SELECT * FROM TIERS ';
  Req := Req + 'WHERE ' + NomZone + '"' + ZoneTxt + '" ';
	Req := Req + 'AND T_NATUREAUXI="CLI"';

  QQ := OpenSQL(Req, False);
	if QQ.eof then
     begin
   	 Ferme(QQ);
     Titre := 'Client Inexistant';
     LastError := 24;
     Exit;
		 end;

  TobTiers := Tob.Create('LES TIERS' ,Nil, -1);
  TobTiers.LoadDetailDB('TIERS','','',QQ,false);

	Ferme(QQ);

  if TobTiers.Detail.Count = 1 then
     Begin
     NatAux := TobTiers.Detail[0].GetValue('T_NATUREAUXI');
		 Auxiliaire := TobTiers.Detail[0].GetValue('T_AUXILIAIRE');
	   CodeTiers := TobTiers.Detail[0].GetValue('T_TIERS');
	   LibTiers := TobTiers.Detail[0].GetValue('T_LIBELLE');
     devise := TobTiers.Detail[0].GetValue('T_DEVISE');
     End
  else if TobTiers.Detail.Count > 1 then
  	 Begin
     AppelRechTiers(NomZone + '"' + ZoneTxt + '" AND T_NATUREAUXI="CLI"');
     Result := True;
	   TobTiers.free;
     Client.OnExit(Client);
     exit;
     end;

  if CodeTiers = '' then
     Begin
     TobTiers.free;
     exit;
     end;

  Oldtiers := CodeTiers;

  //SetControlText('AFF_TIERS', CodeTiers);
  Client.Text := CodeTiers;
  SetControlText('GB_CLIENT', LibTiers);

  RisqueTiers;

  if ControlRisque then
     Begin
     TobTiers.free;
     exit;
     end;

  if ClientFerme(TobTiers.Detail[0].GetValue('T_FERME')) then
     Begin
     TobTiers.free;
     exit;
     end;

  ControleDevise;

  if ControleAdresseInt(NatAux) then
     Begin
     SetControltext('T_JURIDIQUE', TobTiers.Detail[0].GetValue('T_JURIDIQUE'));
     SetControltext('T_PRENOM', TobTiers.Detail[0].GetValue('T_PRENOM'));
     SetControltext('T_REGION', TobTiers.Detail[0].GetValue('T_REGION'));
     SetControltext('T_FAX', TobTiers.Detail[0].GetValue('T_FAX'));
     Telex.text := TobTiers.Detail[0].GetValue('T_TELEX');
     //SetControltext('T_TELEX', TobTiers.Detail[0].GetValue('T_TELEX'));
     SetControltext('T_EMAIL', TobTiers.Detail[0].GetValue('T_EMAIL'));
     SetControltext('T_RVA', TobTiers.Detail[0].GetValue('T_RVA'));
     end
  else
     begin
     AfficheTiers(TobTiers);
     end;

  AdrMailClt := GetControlText('T_EMAIL');

  Result := True;

  TobTiers.free;

End;

{***********A.G.L.***********************************************
Auteur  ...... : Franck Vautrain
Créé le ...... : 10/05/2005
Modifié le ... :   /  /
Description .. : Controle de la sortie des zone appartenant au contact
Mots clefs ... :
*****************************************************************}
Function TOF_APPEL.CtrlExitZoneContact(NomZone, ZoneTxt : String):Boolean;
Var TobContact : Tob;
    Req        : String;
    CodeContact: String;
    CodeTiers  : String;
Begin

  Result := false;
  Titre := 'Nom du Contact';

  CodeContact := '';

  //Lecture du fichier contact pour retrouver le Tiers
	Req := Req + 'SELECT * FROM CONTACT ';
  Req := Req + 'WHERE ' + NomZone + '"' + ZoneTxt + '" ';
	Req := Req + 'AND C_NATUREAUXI="CLI"';

  TobContact := Tob.Create('LES CONTACTS' ,Nil, -1);
  TobContact.LoadDetailDBFromSQL('CONTACT',req,false);

  if TobContact.Detail.Count = 1 then
		 Begin
		 Auxiliaire := TobContact.Detail[0].GetValue('C_AUXILIAIRE');
     CleTel := TobContact.Detail[0].GetValue('C_CLETELEPHONE');
	   SetControlText('YTC_CONTACT',TobContact.Detail[0].GetValue('C_NUMEROCONTACT'));
     Result := true;
     //if CleTel <> '' then
	   //   ChargementAppel
     //else
     ChargementContact(TobContact);
     TobContact.free;
     exit;
     End
	else if TobContact.Detail.Count = 0 then
     begin
     TobContact.free;
		 SetControlText('YTC_CONTACT','');
     if CodeTiers <> '' then
	      Begin
   	    Result := True;
        exit;
	      end
     else
        Begin
	      LastError := 8;
        Exit;
        end;
		 end;

	AppelContactTiers(NomZone + '"' + ZoneTxt + '" AND C_NATUREAUXI="CLI"');

  DecoupeYTContact (CodeContact,Auxiliaire);

  if CodeContact = '' then
     Begin
     LastError := 8;
  	 Exit;
  	 end;

  Result := true;

  Req := '';
	Req := 'SELECT * FROM CONTACT WHERE C_AUXILIAIRE ="' + Auxiliaire + '" AND C_NUMEROCONTACT=' + CodeContact;

  TobContact.LoadDetailDBFromSQL('CONTACT',req,false);

  //LectureContact;
  ChargementContact(TobContact);

  TobContact.free;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Franck Vautrain
Créé le ...... : 11/05/2005
Modifié le ... :   /  /
Description .. : Recherche dans la table adresse d'intervention si le nom,
Suite ........ : l'adresse1 ou le codepostal et la ville existe
Mots clefs ... :
*****************************************************************}
Function TOF_APPEL.CtrlNomAdresse(NomZone, ZoneTxt : String):Boolean;
var TobAdresse : Tob;
		Req        : String;
    QQ         : TQuery;
Begin

	Result := False;

  if ZoneTxt = '' then Exit;

  //Lecture du tiers pour Récupération code tiers
	Req := Req + 'SELECT * FROM ADRESSES ';
  Req := Req + 'WHERE ' + NomZone + '"' + ZoneTxt + '" ';
	Req := Req + 'AND ADR_NATUREAUXI="CLI"';
//	Req := Req + 'AND ADR_TYPEADRESSE="TIE"';
  Req := Req + 'AND ADR_TYPEADRESSE="INT"';

  QQ := OpenSQL(Req, False);
	if QQ.eof then
     begin
   	 Ferme(QQ);
     Titre := 'Adresse d''Intervention';
     LastError := 37;
     Exit;
		 end;

  TobAdresse := Tob.Create('LES ADRESSES' ,Nil, -1);
  TobAdresse.LoadDetailDB('ADRESSES','','',QQ,false);

	Ferme(QQ);

  if TobAdresse.Detail.Count = 1 then
     Begin
	   CodeTiers := TobAdresse.Detail[0].GetValue('ADR_REFCODE');
     End;

  If not CtrlExitZoneTiers('T_TIERS=', CodeTiers) then
  	 Begin
     AfficheErreur;
     AppelRechTiers('T_NATUREAUXI="CLI"');
     end;

  Result := True;

  RechContactTiers;

  RechContratTiers;

End;

procedure TOF_APPEL.Adresse1Exit(sender: TObject);
begin

	Titre := '';

  if GetControlText('T_ADRESSE1') = '' then Exit;

  if CodeTiers <> '' then exit;

  if OldAdr1 = GetControlText('T_ADRESSE1') then exit;

  OldAdr1 := GetControlText('T_ADRESSE1');

  If not CtrlExitZoneTiers('T_ADRESSE1 LIKE ', OldAdr1 + '%') then
  	 Begin
     AfficheErreur;
     AppelRechTiers('T_NATUREAUXI="CLI"');
     end;

  RechContactTiers;

  RechContratTiers;

  SetFocusControl('AFF_DESCRIPTIF');

end;

procedure TOF_APPEL.CodePostalExit(sender: TObject);
begin

	Titre := '';

  if GetControlText('T_CODEPOSTAL') = '' then Exit;

  if codetiers <> '' then exit;

  if OldCP = GetControlText('T_CODEPOSTAL') then exit;

  OldCP := GetControlText('T_CODEPOSTAL');

  If not CtrlExitZoneTiers('T_CODEPOSTAL LIKE ', OldCP + '%') then
  	 Begin
     AfficheErreur;
     AppelRechTiers('T_NATUREAUXI="CLI"');
     end;

  RechContactTiers;

  RechContratTiers;

  SetFocusControl('AFF_DESCRIPTIF');

end;

procedure TOF_APPEL.VilleExit(sender: TObject);
begin

	Titre := '';

  if GetControlText('T_VILLE') = '' then Exit;

  if codetiers <> '' then exit;

  if OldVille = GetControlText('T_VILLE') then exit;

  OldVille := GetControlText('T_VILLE');

  If not CtrlExitZoneTiers('T_VILLE=', OldVille) then
  	 Begin
     AfficheErreur;
     AppelRechTiers('T_NATUREAUXI="CLI"');
     end;

  RechContactTiers;

  RechContratTiers;

  SetFocusControl('AFF_DESCRIPTIF');

end;

procedure TOF_APPEL.DescriptifExit(sender: TObject);
begin
  if GetControlText('AFF_LIBELLE') = '' then DefiniLibelle;
end;

procedure TOF_APPEL.OnNewRecord(sender: TObject);
Var rep : string;
begin

  if PGIAsk(TraduireMemoire(TexteMessage[10] + Lib_Affaire.Caption), rep) = mrNo then
		 Begin
     SetFocusControl('AFF_DESCRIPTIF');
  	 Exit;
     End;

  //Mise à jour de l'enregistrement
	OnUpdate;

  TobAdrInt.free;
  TobAppel.free;

	AFTypeAction := TaCreat;

  //chargement nouvel enreg
  OnArgument('ACTION=CREATION');
  OnLoad;
  SetFocusControl('AFF_NOMCONTACT');

end;

Procedure TOF_APPEL.MaintenanceTel(Sender : TObject);
Var Arg       : String;
    TOBParam 	: TOB;
    DateAppel : TDateTime;
    Return, CodRes, LibRes : string;
    iPartErreur : integer;
begin

  TOBParam := TOB.Create ('LES PARAMS',nil,-1);
  TOBParam.AddChampSupValeur ('RETOUR','-');
  if (AFTypeAction = taCreat) then
     if (Ok_SaisieAppel) then
        Begin
        CodeAppel := DechargeCleAffaire(AFF_APPEL0, AFF_APPEL1, AFF_APPEL2, AFF_APPEL3, APP_AVENANT, GetControlText('AFF_TIERS'), AFTypeAction, True, True, false, iPartErreur);
        if (CodeAppel <> '') then GestionSaisieNumAppel
        end
      else
        Begin
        CodeAppel := RegroupePartiesAppel(P0, P1, P2, P3, Avn);
        if (CodeAppel <> '') then GestionCalculAutoNumAppel;
        end;

	If CodeAppel = '' then
     Begin
     LastError := 6;
     AfficheErreur;
     exit;
     end;

  If Client.Text = '' then //GetControlText('AFF_TIERS') = '' then
  	 Begin
     LastError := 11;
     AfficheErreur;
     //SetFocusControl('AFF_TIERS');
     Client.SetFocus;
     exit;
     end;

  If GetControlText('AFF_RESPONSABLE') = '' then
  	 Begin
     SetFocusControl('AFF_RESPONSABLE');
     LectureRessourceAssociee (V_PGI.User, CodRes, LibRes);
     if CodRes = '' then
       begin
       SetcontrolText('AFF_RESPONSABLE', V_PGI.User);
       SetcontrolText('TAFF_RESPONSABLE', V_PGI.UserName);
       end else
       begin
       SetcontrolText('AFF_RESPONSABLE', CodRes);
       SetcontrolText('TAFF_RESPONSABLE', LibRes);
       end;
     end;

  DateAppel := Now;

  //Saisie du motif de l'annulation
  Arg := 'ACTION=CREATION;';
  Arg := Arg + 'ETAT=TER;';
  Arg := Arg + 'APPEL='+ CodeAppel + ';';
  Arg := Arg + 'AFFAIRE0=' + GetControlText('CAFF_AFFAIRE0')+ ';';
  Arg := Arg + 'AFFAIRE1=' + GetControlText('CAFF_AFFAIRE1')+ ';';
  Arg := Arg + 'AFFAIRE2=' + GetControlText('CAFF_AFFAIRE2')+ ';';
  Arg := Arg + 'AFFAIRE3=' + GetControlText('CAFF_AFFAIRE3')+ ';';
  Arg := Arg + 'AVENANT=' + GetControlText('CAFF_AVENANT')+ ';';
  Arg := Arg + 'DATE=' + DatetoStr(DateAppel);

  TheTOB := TOBparam;
  AGLLanceFiche ('BTP','BTANNULAPP','','',Arg);
  TheTOB := nil;

  //retour de saisie si annule ou validation
  return := TOBparam.GetValue('RETOUR');
  TOBparam.free;

  if Return <> 'X' then exit;

  //Réalisation de l'appel
  CodeEtat := 'REA';

  //Chargement de la date et heure d'enregistrement
  TobAppel.PutValue('AFF_DATEFIN', DateAppel);

  OnUpdate;

  ecran.Close;

end;

Procedure TOF_APPEL.ListeAffectation(Sender : TObject);
Begin

  if Not BTAffectation.down then
     Begin
     InitGrille;
     Exit;
     end;

  //Affichage du panel
  SetcontrolProperty('HPANELGRILLE', 'Visible', False);
  SetcontrolProperty('PANELINFO', 'Visible', False);

  //Chargement et dessin de la grille des affectations
  ChargeListeAssociee('AFMULRESSOURCE', 'Liste des Affectations', TToolAffect, GestGrille);
  DessineGrille(TToolAffect, GrilleAffectation, GestGrille);

  //Chargement de la grille affectation
  ChargeAffectation;

end;

Procedure TOF_APPEL.ChargeAffectation;
Var StSQL     : String;
    ZoneTable : String;
    QAppel		: TQuery;
    I		      : integer;
    J				  : integer;
Begin

  //Chargement de la grille AFFECTATION => en utilisant le paramétrage grille appels
  ZoneTable := '';

  StSql := GestGrille.ColGAppel;

  //Chargement de la TOB
  while  StSql <> '' do
     begin
     if ZoneTable = '' Then
	 	  	ZoneTable := ReadTokenst(StSql)
     else
	      ZoneTable := ZoneTable + ',' + ReadTokenst(StSql);
     end;

  TobHistoAppel := Tob.create('Les Affectations', nil, -1);

  StSQL := 'SELECT ' + ZoneTable + ' FROM ' + GestGrille.TableGapp;
  stSql := StSQL + ' LEFT JOIN BTEVENPLAN ON BEP_RESSOURCE = ARS_RESSOURCE ';
  StSQL := StSQL + ' WHERE BEP_AFFAIRE = "' + CodeAppel + '"';

  if GestGrille.TriGapp <> '' then  StSQL := StSQL + ' ORDER BY ' + GestGrille.TriGapp;

  QAppel := OpenSQL(StSQL, True);

  //Lecture du fichier affaire/Ressources si on ne gère pas les évènements planning
  if QAppel.eof then
  	 Begin
	   StSQL := 'SELECT ' + ZoneTable + ' FROM ' + GestGrille.TableGapp;
	   stSql := StSQL + ' LEFT JOIN AFFAIRE ON AFF_RESPONSABLE = ARS_RESSOURCE ';
	   StSQL := StSQL + ' WHERE AFF_AFFAIRE = "' + CodeAppel + '"';
     if GestGrille.TriGapp <> '' then  StSQL := StSQL + ' ORDER BY ' + GestGrille.TriGapp;
     end;

  TobHistoAppel.LoadDetailDB('RESSOURCE', '', '', QAppel, False);

  Ferme(QAppel);

  StSql := GestGrille.ColGAppel;

  with GrilleAffectation do
       Begin
       if TobHistoAppel.detail.count = 0 then
          Begin
	        RowCount := 2;
          For J := 1 to ColCount - 1 do
              Begin
              Cells[J, 1] := '';
              end;
          end
       else
          Begin
          RowCount := TobHistoAppel.detail.count + 1;
    	    For i := 0 to TobHistoAppel.detail.count - 1 Do
              Begin
              Cells[0, I] := '';
              StSql := GestGrille.ColGAppel;
  		        For J := 1 to ColCount - 1 do
                  begin
                  Cells[0, I+1] := '';
                  Cells[J, I+1] := TobHistoAppel.Detail[I].GetValue(ReadTokenst(StSql));
					        end;
              end;
          row := 1;
          end;
       end;

  //Affichage de la ttoolwindows historique des Appels
  TToolAffect.Visible := true;

end;


Procedure TOF_APPEL.BTHistoriqueClick(Sender : Tobject);
Begin

  if Not BTHistorique.down then
     Begin
     ChargeGrille := false;
     InitGrille;
     Exit;
     end;

  ChargeGrille := True;

  //Affichage du panel
  SetcontrolProperty('HPANELGRILLE', 'Visible', true);

  ChargeListeAssociee('BTMULAPPELS', 'Liste des Affectations', TToolAffect, GestGrille);
  DessineGrille(TToolAffect, GrilleAffectation,GestGrille );

  //Recadrage des descriptifs
  DetailAppel.Width := (TToolAffect.Width - 15) div 2;
  DetailInt.Width   := TToolAffect.Width - (DetailAppel.Width + 15);
  Lib_DetailAppel.width := DetailAppel.Width;
  Lib_DetailInt.width   := DetailInt.Width;

  EtatAffaire.Value := '';
  PrioContrat.Value := '';

  ChargeHistorique;

  ChargeGrille := False;

end;



Procedure TOF_APPEL.ChargeHistorique;
Var StSQL     : String;
    ZoneTable : String;
    QAppel		: TQuery;
    I		      : integer;
    J				  : integer;
Begin

  //Chargement de la grille Historique des Appels => en utilisant le paramétrage grille appels
  ZoneTable := '';

  StSql := GestGrille.ColGAppel;

  //Chargement de la TOB
  while  StSql <> '' do
  begin
    if ZoneTable = '' Then
      ZoneTable := ReadTokenst(StSql)
    else
      ZoneTable := ZoneTable + ',' + ReadTokenst(StSql);
  end;

  TobHistoAppel := Tob.create('Les Appels', nil, -1);

  StSQL := 'SELECT AFF_DESCRIPTIF,AFF_AFFAIREINIT,AFF_CREERPAR,' + ZoneTable + ',LO_OBJET';
  StSQL := StSQL + ' FROM ' + GestGrille.TableGapp;
  StSQL := StSQL + ' LEFT JOIN LIENSOLE ON AFF_AFFAIRE = LO_IDENTIFIANT';
  StSQL := StSQL + ' WHERE AFF_AFFAIRE0 = "W" AND AFF_TIERS = "' + CodeTiers + '"';

  if ChkTaches.Checked then
     StSql := StSQL + ' AND AFF_CREERPAR="TAC"';

  if EtatAffaire.value <> '' then
     StSql := StSQL + ' AND AFF_ETATAFFAIRE="'+ EtatAffaire.Value +'"';

  if PrioContrat.Value <> '' then
     StSql := StSQL + ' AND AFF_PRIOCONTRAT="'+ PrioContrat.Value +'"';

  if GestGrille.TriGapp <> '' then  StSQL := StSQL + ' ORDER BY ' + GestGrille.TriGapp;

  QAppel := OpenSQL(StSQL, True);
  if Qappel.Eof then
     Begin
     //Ferme(QAppel);
     //exit;
     end;

  TobHistoAppel.LoadDetailDB('AFFAIRE', '', '', QAppel, False);

  Ferme(QAppel);

  StSql := GestGrille.ColGAppel;

  with GrilleAffectation do
       Begin
       if TobHistoAppel.detail.count = 0 then
          Begin
	        RowCount := 2;
          SetcontrolProperty('PANELINFO', 'Visible', False);
          For J := 1 to ColCount - 1 do
              Begin
              Cells[J, 1] := '';
              end;
          end
       else
          Begin
          RowCount := TobHistoAppel.detail.count + 1;
    	    For i := 0 to TobHistoAppel.detail.count - 1 Do
              Begin
              Cells[0, I] := '';
              StSql := GestGrille.ColGAppel;
  		        For J := 1 to ColCount - 1 do
                  begin
                  Cells[0, I+1] := '';
                  Cells[J, I+1] := TobHistoAppel.Detail[I].GetValue(ReadTokenst(StSql));
					        end;
 			        Cells[ColCount, I+1] := TobHistoAppel.Detail[I].GetValue('AFF_AFFAIRE');
              Cells[ColCount+1, I+1] := TobHistoAppel.Detail[I].GetValue('AFF_DESCRIPTIF');
              end;
          row := 1;
          SetcontrolProperty('PANELINFO', 'Visible', True);
          if TobHistoAppel.Detail[GrilleAffectation.Row-1].GetString('AFF_ETATAFFAIRE') = 'ANN' then
             Lib_DetailInt.Caption := 'DETAIL ANNULATION'
          Else
             Lib_DetailInt.Caption := 'DETAIL D''INTERVENTION';
          Lib_DetailInt.width   := DetailInt.Width;
          DetailAppel.Text := TobHistoAppel.Detail[0].GetString('AFF_DESCRIPTIF');
          DetailInt.Text   := TobHistoAppel.Detail[0].GetString('LO_OBJET');
          end;
       end;

  //Affichage de la ttoolwindows historique des Appels
  TToolAffect.Visible := true;

end;

Procedure Tof_APPEL.InitGrille;
Begin

	BTAffectation.down := False;
 	BTHistorique.down  := False;

  if TobHistoAppel <> nil then TobHistoAppel.free;

  TToolAffect.Width := 0;

  GrilleAffectation.ColCount := 1;
	GrilleAffectation.RowCount := 1;

  ChkTaches.Checked := False;

	TToolAffect.Visible := BTHistorique.down;
	TToolEvenement.Visible := BTHistorique.down;
  TToolConso.Visible := BTHistorique.down;

end;

procedure TOF_APPEL.BTLigneClick (Sender: TObject) ;
var NaturePiece   : String;
    StatutAffaire : String;
    Arg       		: String;
    QQ						: TQuery;
    cledoc : r_cledoc;
begin

  if CodeAppel = '' then
     begin
     LastError := 6;
     OnNew;
     Exit;
     end;

  if Client.Text = '' then //GetControlText('AFF_TIERS') = '' then
     begin
     LastError := 11;
     AfficheErreur;
     Exit;
     end;

  OnUpdate;

  NaturePiece:= 'DAP';
  statutAffaire := 'APP' ;

  NbPiece := SelectPieceAffaire (CodeAppel, StatutAffaire , CleDocAffaire);

  //Controle si le nbre de piéce est à zéro... Si oui Création Pièce
  if (NbPiece = 0) and (AFTypeAction <> taConsult) then
     if CreerPieceAffaire (Client.text, CodeAppel, StatutAffaire ,'', CleDocAffaire, True, False) then
        NbPiece := 1;

  
  if (NbPiece = 1) then
  begin
     if CodeEtat = 'ACA' then
     begin
        SaisiePiece (CleDocAffaire, taConsult)
     end Else if CodeEtat = 'FAC' then
     Begin
        SaisiePiece (CleDocAffaire, taConsult);
        exit;
     end else
     begin
     	if AFTypeAction = taConsult then
      begin
        SaisiePiece (CleDocAffaire, taConsult);
      end else
      begin
      	SaisiePiece (CleDocAffaire, taModif);
      end;
     end;
  end Else
  Begin
  	if AFTypeAction <> taConsult then
    begin
     LastError := 31;
     AfficheErreur;
     Exit;
    end;
  end;
  if AfTypeAction = taConsult then exit;
  //Controle si le devis existe et si montant pas à blanc
  Arg := 'GP_NATUREPIECEG,GP_SOUCHE,GP_NUMERO,GP_INDICEG,GP_TOTALHT, GP_TOTALHTDEV, GP_TOTALTTC, GP_TOTALTTCDEV, GP_NUMERO';
  Arg := 'SELECT ' + Arg + ' FROM PIECE WHERE GP_AFFAIRE ="' + CodeAppel + '"';
  QQ := OpenSQL(Arg,false);

  //le devis n'existe pas
  if QQ.eof then
  begin
     if getControlText('AFF_RESPONSABLE')= '' then
     Begin
        CodeEtat := 'ECO';
        SetControlCaption('TAFF_ETAT', 'En-Cours');
     end Else
     Begin
        CodeEtat := 'AFF';
        SetControlCaption('TAFF_ETAT', 'Affecté');
     end;
	   SetControlProperty('GROUPVALEUR', 'VISIBLE', False);
     TobAppel.PutValue('AFF_TOTALHT', 0);
	   TobAppel.PutValue('AFF_TOTALHTDEV', 0);
     TobAppel.PutValue('AFF_TOTALTTC', 0);
     TobAppel.PutValue('AFF_TOTALTTCDEV', 0);
     TobAppel.PutValue('AFF_ETATAFFAIRE', CodeEtat);
     TobAppel.setAllModifie(true);
     TobAppel.InsertOrUpdateDB(true);
     ferme(QQ);
     exit;
  end;

  //Le Devis existe
	SetControlProperty('GROUPVALEUR', 'VISIBLE', True);
	SetControlCaption('GROUPVALEUR','Devis N°' + QQ.FindField('GP_NUMERO').AsString );
  SetControlText('AFF_TOTALHTDEV', QQ.FindField('GP_TOTALHTDEV').AsString );

  TobAppel.PutValue('AFF_TOTALHT', QQ.FindField('GP_TOTALHT').AsString );
  TobAppel.PutValue('AFF_TOTALHTDEV', QQ.FindField('GP_TOTALHTDEV').AsString );
  TobAppel.PutValue('AFF_TOTALTTC', QQ.FindField('GP_TOTALTTC').AsString );
  TobAppel.PutValue('AFF_TOTALTTCDEV', QQ.FindField('GP_TOTALTTCDEV').AsString );

  if QQ.FindField('GP_TOTALHTDEV').AsString = '0' then
  Begin
  	FillChar (cledoc,sizeof(cledoc),#0);
  	cledoc.NaturePiece := QQ.findField('GP_NATUREPIECEG').asString;
  	cledoc.Souche := QQ.findField('GP_SOUCHE').asString;
  	cledoc.NumeroPiece  := QQ.findField('GP_NUMERO').AsInteger ;
  	cledoc.Indice   := QQ.findField('GP_INDICEG').AsInteger ;
  	DetruitAncien ( cledoc,Idate1900);
     SetControlProperty('GROUPVALEUR', 'VISIBLE', False);
     TobAppel.PutValue('AFF_TOTALHT', 0);
	   TobAppel.PutValue('AFF_TOTALHTDEV', 0);
     TobAppel.PutValue('AFF_TOTALTTC', 0);
     TobAppel.PutValue('AFF_TOTALTTCDEV', 0);
     if getControlText('AFF_RESPONSABLE')= '' then
     Begin
        CodeEtat := 'ECO';
        SetControlCaption('TAFF_ETAT', 'En-Cours');
     end Else
     Begin
        CodeEtat := 'AFF';
        SetControlCaption('TAFF_ETAT', 'Affecté');
     end;
  End else
  begin
  	if CodeEtat <> 'ACA' then
    Begin
      CodeEtat := 'ACD';
      SetControlCaption('TAFF_ETAT', 'Attente Acceptation Devis');
    end;
  end;

  TobAppel.PutValue('AFF_ETATAFFAIRE', CodeEtat);

  TobAppel.setAllModifie(true);
  TobAppel.InsertOrUpdateDB(true);

  ferme(QQ);

end;

procedure TOF_APPEL.BImprimerClick (Sender: TObject) ;
Var StWhere		: string;
		StModele	: String;
    TL 				: TList;
    TT 				: TStrings;
		TitreEtat	: String;
begin

If GetParamSoc('SO_EDITMAQWORD') then
   Begin
	 EditeMaquetteWord;
   Exit;
   end;

stWhere := '';
stModele := GetParamSOC('SO_BTMODBI');

stWhere := 'AFF_AFFAIRE="'  + CodeAppel + '"';

TL := TList.Create ;
TT := TStringList.Create ;
TT.Add (stWhere);
TL.Add (TT);

V_PGI.NoPrintDialog := False;

TitreEtat := Copy (CodeAppel,2,14);
LanceEtat('E','INT',stModele,True, false, false,Nil,trim (stWhere),'INTERVENTION '+TitreEtat,False);


end;

procedure TOF_APPEL.EditeMaquetteWord;
var ii				: integer;
  stModele		: String;
  stDocWord		: String;
	stModWord		: String;
  stPathWord	: string;
  Okok: boolean;
begin

  Titre := 'Edition des Bons d''Intervention';

 	if TobAppel = nil then exit ;

  {Tests préliminaires}
  okok := True;

  if ((not BImprimer.Visible) or (not BImprimer.Enabled)) then Exit;

  stModele := GetParamSoc('SO_BINOMMAQUETTE');
  stPathWord := GetParamSoc('SO_BTDIRMAQUETTE');

  if stModele = '' then
  	 Begin
     LastError := 20;
     okok := False;
     end;

  if stPathWord = '' then
     Begin
  	 LastError := 21;
     okok := False;
     end;

  if not DirectoryExists(stPathWord) then
     Begin
  	 LastError := 22;
     okok := False;
     end;

  if not FileExists(stPathWord + '\' + stModele) then
     Begin
     LastError := 23;
     okok := False;
     end;

  if not Okok then
	   begin
   	 AfficheErreur;
     Exit;
	   end;

  {Traitement}
  stDocWord := stPathWord + '\' + FabricNomWord;
  StModWord := stPathWord + '\' + StModele;

  DeleteFile(stDocWord);

  ii := ConvertDocFile(stModWord, stDocWord, nil, nil, nil, OnGetVar, nil, nil);

  if ii = 0 then ShellExecute(0, PCHAR('open'), PChar(stDocWord), nil, nil, SW_RESTORE);

end;

function TOF_APPEL.FabricNomWord: string;
var St: string;
begin

  St := 'Bon_Intervention_' + CodeAppel;

  St := St + '_' + GetControlText('TLIBELLE') + '.DOC';

  Result := St;

end;

//Procedure de lecture du fichier Doc et remplacement des valeurs
procedure TOF_APPEL.OnGetVar(Sender: TObject; VarName: string; VarIndx: Integer; var Value: variant);
begin

  Value := '';

  if VarName = 'DESCRIPTIF' then
  	 begin
     BlobToFile(VarName, TobAppel.GetValue('AFF_DESCRIPTIF'));
     Value := '';
	   end
  else if VarName = 'ARS_LIBELLE' then
    Value := GetControlText('AFF_RESPONSABLE')
  else if Pos('ADR_', VarName) > 0 then
  	Value := TobAdrInt.GetValue(VarName)
  else if Pos('AFF_', VarName) > 0 then
    Value := TobAppel.GetValue(VarName)
  else Value := '';

end;

procedure TOF_APPEL.FicheActivate(Sender: TObject);
begin
Inherited    ;

  //
  if Not FirstWay then exit;
  //
  FirstWay := False;
  //
	if AFTypeAction = TaModif then
		 Begin
     OnDisplay;
     exit;
     end;
  //
  if CleTel <> '' Then
     Begin
     SetControlText('T_TELEPHONE',CleTel);
  	 ChargementAppel;
     end;

end;

Procedure TOF_APPEL.ChargementAppel;
Var Req					: String;
		StTiers     : String;
    StNatAuxi   : String;
    StContact	  : String;
    TobContact	: Tob;
    TobAdrInt		: Tob;
    TobTiers  	: Tob;
begin

  StTiers := '';
  StNatauxi := '';
  StContact := '0';

  Cletel := CleTelephone(CleTel);

  TobContact := Tob.Create('LesContact',Nil, -1);
  TobAdrInt := Tob.Create('LesAdrInt',Nil, -1);
  TobTiers := Tob.Create('LesTiers',Nil, -1);

  //Recherche du contact en fonction du N° de Téléphone
  If Telephone.text <> '' then
	   Req := 'Select * From CONTACT Where C_CLETELEPHONE ="' + CleTel + '"'
  else If Fax.text <> '' then
	   Req := 'Select * From CONTACT Where C_CLEFAX ="' + CleTel + '"'
  else If Telex.text <> '' then
	   Req := 'Select * From CONTACT Where C_CLETELEX ="' + CleTel + '"';

  TobContact.LoadDetailDBFromSQL('CONTACT',req,false);

  if TobContact.Detail.Count = 1 then
     Begin
     AfficheContact(TobContact);
     StTiers   := TobContact.Detail[0].GetValue('C_TIERS');
     StNatAuxi := TobContact.Detail[0].GetValue('C_NATUREAUXI');
     StContact := TobContact.Detail[0].GetValue('C_NUMEROCONTACT');
	   Req := 'Select * From TIERS Where T_TIERS="' + StTiers + '" And T_NATUREAUXI="' + StNatAuxi + '"';
     End
  Else if TobContact.Detail.Count = 0 then
     Begin
     If Telephone.text <> '' then
	      Req := 'Select * From TIERS Where T_CLETELEPHONE="' + CleTel + '"'
		 Else	If Fax.text <> '' then
	      Req := 'Select * From TIERS Where T_CLEFAX="' + CleTel + '"'
		 Else If Telex.text <> '' then
	      Req := 'Select * From TIERS Where T_CLETELEPHONE3="' + CleTel + '"'
     end
  Else
     Begin
     AppelContactTiers('C_CLETELEPHONE ="' + CleTel + '"');
     DecoupeYTContact (StContact,StTiers);
     Req := '';
	   Req := 'SELECT * FROM CONTACT WHERE C_AUXILIAIRE ="' + StTiers + '" AND C_NUMEROCONTACT=' + StContact;
	   TobContact.LoadDetailDBFromSQL('CONTACT',req,false);
	   if TobContact.Detail.Count <> 0 then AfficheContact(TobContact);
      SetControlProperty('YTC_CONTACT', 'VISIBLE', False);
	   Req := 'Select * From TIERS Where T_AUXILIAIRE="' + StTiers + '"';
     end;

  //Recherche du tiers en fonction du N° de télephone si Contact
  //n'existe pas ou en fonction du code Tiers s'il existe
  TobTiers.LoadDetailDBFromSQL('TIERS',req,false);

  if TobTiers.Detail.Count = 1 then
  	 Begin
	   AfficheTiers(TobTiers);
     Auxiliaire := TobTiers.Detail[0].GetValue('T_AUXILIAIRE');
     StTiers   := TobTiers.Detail[0].GetValue('T_TIERS');
     StNatAuxi := TobTiers.Detail[0].GetValue('T_NATUREAUXI');
     Req := 'Select * From ADRESSES Where ADR_REFCODE="' + StTiers + '"';
     Req := Req + ' And ADR_NATUREAUXI="' + StNatAuxi + '"';
     Req := Req + ' And ADR_TYPEADRESSE="INT"';
     If StContact <> '' then
        Req := Req + ' And ADR_NUMEROCONTACT=' + StContact;
     end
	else
     Req := 'Select * FROM ADRESSES WHERE  ADR_CLETELEPHONE="' + CleTel + '"';

	//Recherche de l'adresse d'intervention en fontion du N° de Téléphone
  //si contact n'existe pas ou en fonction du contact si il existe
  TobAdrInt.LoadDetailDBFromSQL('ADRINT',req,false);

  if TobAdrInt.Detail.Count = 1 then
     begin
     AfficheAdresseIntervention(TobAdrInt);
     If IntToStr(TobAdrInt.Detail[0].GetValue('ADR_NUMEROCONTACT')) <> StContact then
     	  Begin
	     With TobAdrInt.Detail[0] do
		       Begin
		  	    SetControltext('YTC_CONTACT', GetValue('ADR_NUMEROCONTACT'));
		       Telephone.Text := GetValue('ADR_TELEPHONE');
		       Fax.Text := '';
		       Telex.Text := '';
		       end;
     	  end;
     If StTiers = '' then
        Begin
        StTiers   := TobAdrInt.Detail[0].GetValue('ADR_REFCODE');
        StNatAuxi := TobAdrInt.Detail[0].GetValue('ADR_NATUREAUXI');
        Req := 'Select * From TIERS Where T_TIERS="' + StTiers + '"';
        TobTiers.LoadDetailDBFromSQL('TIERS',req,false);
        If TobTiers.dEtail.count <> 0 then
        	 Begin
	         SetControlText('GB_Client', TobTiers.Detail[0].GetValue('T_LIBELLE'));
   	       //SetControltext('AFF_TIERS', TobTiers.Detail[0].GetValue('T_TIERS'));
           Client.text := TobTiers.Detail[0].GetValue('T_TIERS');
        	 End
        Else
        	  Begin
	          SetControlText('GB_Client', 'Client Inconnu');
   	        //SetControltext('AFF_TIERS', StTiers);
            Client.Text :=  StTiers;
           end;
        end;
     end;

  CodeTiers := stTiers;
  OldTiers  := StTiers;

  TobContact.free;
  TobAdrInt.free;
  TobTiers.free;

  if CodeTiers = '' then
     Begin
     LastError := 11;
     AfficheErreur;
     Raz_Zone_Ecran;
     Client.setfocus;
	   //SetFocusControl('AFF_TIERS');
     end
  else
  	 Begin
	   RechContratTiers;
	   SetFocusControl('AFF_DESCRIPTIF');
     end;

end;

procedure TOF_APPEL.ChargementContact(TobContact : tob);
var req				: string;
		StTiers   : String;
    StNatAuxi : String;
    StContact	: String;
    TobAdrInt	: Tob;
    TobTiers  : Tob;
Begin

	StContact := '';

  if TobContact.Detail.Count <> 0 then AfficheContact(TobContact);

  TobAdrInt := Tob.Create('LesAdrInt',Nil, -1);
  TobTiers := Tob.Create('LesTiers',Nil, -1);

  StContact := GetControlText('YTC_CONTACT');

  //lecture de la fiche tiers en fonction de l'Auxilliaire du Contact
  Req := 'Select * From TIERS Where T_AUXILIAIRE="' + Auxiliaire + '"';

  TobTiers.LoadDetailDBFromSQL('TIERS',req,false);

  if TobTiers.Detail.Count = 1 then
  	 Begin
		 AfficheTiers(TobTiers);
     StTiers   := TobTiers.Detail[0].GetValue('T_TIERS');
     StNatAuxi := TobTiers.Detail[0].GetValue('T_NATUREAUXI');
     Req := 'Select * From ADRESSES Where ADR_REFCODE="' + StTiers + '"';
     Req := Req + ' And ADR_NATUREAUXI="' + StNatAuxi + '"';
     Req := Req + ' And ADR_TYPEADRESSE="INT"';
     If StContact <> '' then
        Req := Req + ' And ADR_NUMEROCONTACT=' + StContact;
     end;

  CodeTiers := stTiers;
  OldTiers  := StTiers;

	//Recherche de l'adresse d'intervention
  TobAdrInt.LoadDetailDBFromSQL('ADRINT',req,false);

  req := '';

  If TobAdrInt.Detail.Count = 0 then
     Begin
     Req := 'Select * From ADRESSES Where ADR_REFCODE="' + StTiers + '"';
     Req := Req + ' And ADR_NATUREAUXI="' + StNatAuxi + '"';
     Req := Req + ' And ADR_TYPEADRESSE="INT"';
     end;

  TobAdrInt.LoadDetailDBFromSQL('ADRINT',req,false);

  req := '';

  if TobAdrInt.Detail.Count = 1 then
     AfficheAdresseIntervention(TobAdrInt)
  else if TobAdrInt.Detail.Count > 1 then
  	 begin
     Req := 'ADR_REFCODE="' + StTiers + '"';
     Req := Req + ' And ADR_NATUREAUXI="' + StNatAuxi + '"';
     Req := Req + ' And ADR_TYPEADRESSE="INT"';
     If StContact <> '' then
     	  Req := Req + ' And ADR_NUMEROCONTACT=' + StContact;
     end;

  if req <> '' then
     Begin
	   SetControlProperty('YTC_NADRESSELIV', 'Plus', req);
     LookupCombo(Adresseint);
     //Lecture de l'adresse sélectionnée et affichage des informations
     if GetControlText('YTC_NADRESSELIV')<>'' then LectureAdresseIntervention;
     end;

  TobAdrInt.free;
  TobTiers.free;

  if CodeTiers = '' then
     Begin
     LastError := 11;
     AfficheErreur;
     Raz_Zone_Ecran;
     Client.SetFocus;
	   //SetFocusControl('AFF_TIERS');
     end
  else
  	 Begin
	   RechContratTiers;
	   SetFocusControl('AFF_DESCRIPTIF');
     end;

end;

procedure TOF_APPEL.DefiniLibelle;

	function IsLigneRenseignee (ligne : string) : boolean;
  var indice : integer;
  		TheChar : Char;
  begin
  	result := false;
  	for indice := 0 to length(ligne) do
    begin
    	TheChar := Ligne[Indice];
  		if IsCharAlphaNumeric(TheChar) then
      begin
      	result := true;
        break;
      end;
  	end;
  end;

var Memo	 : TMemo;
    lng 	 : integer;
    Indice : integer;
    LibAff : String;
    LigneNonVide : boolean;
begin

  LibAff := '';
  Indice := 0;

  Memo := TMemo(GetControl('AFF_DESCRIPTIF'));

  //if CompareStr(LibAff, TobAppel.GetValue('AFF_LIBELLE')) <> 0 then exit;

  // trouve la premiere ligne non vide
  repeat
    lng := Pos (#$D#$A, Memo.lines [indice] ) ;
    LigneNonVide := IsLigneRenseignee (memo.lines[Indice]);
    if (lng > 1) or (LigneNonVide) then
    begin
    	if Lng = 0 then Lng := Length(memo.lines[Indice]);
       break;
    end else
    begin
       inc(indice);
    end;
  until indice > Memo.lines.count;

  if Indice > Memo.lines.count then exit;

  if (lng > 35) then
     LibAff := Copy (Memo.lines [Indice] , 0, 35)
  else
     LibAff := Copy (Memo.lines [indice] , 0, lng - 1);

  TobAppel.PutValue('AFF_LIBELLE', LibAff);
  SetControlText('AFF_LIBELLE', LibAff);

end;

//gestion de l'effacage des zones de recherche
procedure TOF_APPEL.BEffaceConClick(Sender: TObject);
Begin

	CodeContrat := '';

  setcontroltext('AFF_CONTRAT1', '');
  setcontroltext('AFF_CONTRAT2', '');
  setcontroltext('AFF_CONTRAT3', '');
  setcontroltext('CON_AVENANT', '00');

  SetControlProperty('CHKCONTRAT', 'ENABLED', False);
  SetControlChecked('CHKCONTRAT', False);
  SetControlProperty('CHKGARANTIE', 'ENABLED', False);
  SetControlChecked('CHKGARANTIE', False);

end;

procedure TOF_APPEL.BEffaceChaClick(Sender: TObject);
Begin

	CodeChantier := '';

  setcontroltext('AFF_CHANTIER1', '');
  setcontroltext('AFF_CHANTIER2', '');
  setcontroltext('AFF_CHANTIER3', '');
  setcontroltext('CHA_AVENANT', '00');

end;

procedure TOF_APPEL.BEffaceCltClick(Sender: TObject);
Begin

  CodeTiers := '';

  Client.text := '';
  //Setcontroltext('AFF_TIERS', '');

end;

procedure TOF_APPEL.BEffaceResClick(Sender: TObject);
Begin

  setcontroltext('AFF_RESPONSABLE','');
  setcontroltext('TAFF_RESPONSABLE','');
//  SetControlText('ARS_RESSOURCE','');

  CodeEtat := 'ECO';
  SetControlCaption('TAFF_ETAT', 'En-Cours');

  //BPlanning.Visible := true;
  BPlanning.Visible := GetParamSocSecur('SO_AFFRAPIDE', False);

  SetControlProperty('INTERVENANT', 'Enabled', True);

  //SetControlVisible('INTERVENANT', True);

end;

procedure TOF_APPEL.BPlanningClick(Sender: TObject);
Var StVar	: String;
		TheDate : String;
Begin

  OnUpdate;
  if (StrToDate(GetControltext('AFF_DATEINT')) = Idate1900) or (StrToDate(GetControltext('AFF_DATEINT')) = Idate2099) then
  begin
  	TheDate := GetControltext('AFF_DATESOUHAIT');
  end else
  begin
  	TheDate := GetControltext('AFF_DATEINT');
  end;
	StVar := 'APPEL' + ';' + CodeAppel + ';' + TheDate;

  Saisieplanning(StVar, 1, taModif);

  VerifieAffectation;
  OnDisplay;

End;

Procedure TOF_Appel.VerifieAffectation;
Var StSql  : String;
    QEvent : TQuery;
Begin

  BPlanning.Visible := GetParamSocSecur('SO_AFFRAPIDE', False);

  SetControlProperty('TAFF_DATEINT', 'Visible', True);
  SetControlProperty('AFF_DATEINT', 'Visible', True);
  SetControlProperty('TAFF_DATEINT2', 'Visible', True);
  SetControlProperty('AFF_HEUREINT', 'Visible', True);

  StSql := 'SELECT * FROM BTEVENPLAN ';
  StSql := StSql + 'WHERE BEP_AFFAIRE="' + CodeAppel + '" ORDER BY BEP_CODEEVENT';

  QEvent := OpenSQL(StSQL, False);
  If QEvent.Eof then
     Begin
     //TobAppel.PutValue('AFF_RESPONSABLE', TobAppel.GetValue('AFF_RESPONSABLE'));
     //TobAppel.PutValue('AFF_ETATAFFAIRE', TobAppel.GetValue('AFF_ETATAFFAIRE'));
     SetControlProperty('INTERVENANT', 'Enabled', True);
     SetControlProperty('TAFF_DATEINT', 'Visible', False);
     SetControlProperty('AFF_DATEINT', 'Visible', False);
     SetControlProperty('TAFF_DATEINT2', 'Visible', False);
     SetControlProperty('AFF_HEUREINT', 'Visible', False);
     SetControlProperty('AFF_DATESOUHAIT','Enabled', True);
     SetControlProperty('AFF_HEURESOUHAIT','Enabled', True);
     end
  else
     Begin
     TobAppel.PutValue('AFF_RESPONSABLE', QEvent.findfield('BEP_RESSOURCE').asString);
     TobAppel.PutValue('AFF_DATEREPONSE', QEvent.findfield('BEP_DATEDEB').AsDateTime);
     TobAppel.PutValue('AFF_ETATAFFAIRE', 'AFF');
     SetControlProperty('INTERVENANT', 'Enabled', False);
     SetControlProperty('TAFF_DATEINT', 'Visible', True);
     SetControlProperty('AFF_DATEINT', 'Visible', True);
     SetControlProperty('TAFF_DATEINT2', 'Visible', True);
     SetControlProperty('AFF_HEUREINT', 'Visible', True);
     SetControlProperty('AFF_DATESOUHAIT','Enabled', False);
     SetControlProperty('AFF_HEURESOUHAIT','Enabled', False);
     SetControlText('AFF_DATEINT', DateToStr(TobAppel.GetValue('AFF_DATEREPONSE')));
     SetControlText('AFF_HEUREINT', FormatDateTime('hh:mm',TobAppel.GetValue('AFF_DATEREPONSE')));
     SetControlProperty('AFF_DATEINT', 'Enabled', false);
     SetControlProperty('AFF_HEUREINT', 'Enabled', False);
     End;

	ferme(QEvent);

end;

procedure TOF_APPEL.VisualisationConso(Sender: TObject);
Var Arg : String;
begin

  Arg := Arg + 'APPEL='+ CodeAppel;

  AGLLanceFiche ('BTP','BTAPPELCONSO','','',Arg);

end;

Procedure TOF_APPEL.AfficheErreur;
Begin

  Titre := TraduireMemoire(Titre);

  if LastError <> 0 then
	   LastErrorMsg := TraduireMemoire(TexteMessage[LastError])
  Else
	   LastErrorMsg := TraduireMemoire(LastErrorMsg);

  PGIBox(LastErrorMsg,Titre);

  LastError := 0;

end;

//Définition du TToolAffectation pour affichage de la liste des affectés
procedure TOF_APPEL.definiToolAffect;
begin

	TToolAffect.parent := Ecran;
	TToolAffect.caption := 'Liste des Affectations';
	TToolAffect.BorderStyle := bsSingle;
	TToolAffect.clientAreaHeight := PanelAffectation.Height;
	TToolAffect.clientAreaWidth := PanelAffectation.Width;
	TToolAffect.ClientHeight := TToolAffect.clientAreaHeight;
	TToolAffect.clientWidth := TToolAffect.clientAreaWidth;

	TToolAffect.DragHandleStyle := dhDouble;
	TToolAffect.HideWhenInactive := True;
	TToolAffect.fullsize := false;
	TToolAffect.Resizable := false;
	TToolAffect.Height := PanelAffectation.Height + 10;

  TToolAffect.top := PanelAffectation.Top;
  TToolAffect.left := PanelAffectation.left;

  PanelAffectation.Parent := TToolAffect;
  PanelAffectation.Enabled := true;
  PanelAffectation.Visible := true;
  PanelAffectation.Align := Alclient;

  TToolAffect.OnClose := TToolAffectClose;
  TToolEvenement.Onclose := TToolEventClose;
  TToolConso.Onclose := TToolConsoClose;


end;

procedure TOF_APPEL.definiToolEvenement;
begin

	TToolEvenement.parent := Ecran;
	TToolEvenement.caption := 'Liste des Evenements';
	//TToolEvenement.BorderStyle := bsSingle;
	TToolEvenement.clientAreaHeight := PanelEvenement.Height;
	TToolEvenement.clientAreaWidth := PanelEvenement.Width;
	TToolEvenement.ClientHeight := TToolEvenement.clientAreaHeight;
	TToolEvenement.ClientWidth := TToolEvenement.clientAreaWidth;

	TToolEvenement.DragHandleStyle := dhDouble;
	TToolEvenement.HideWhenInactive := False;
	TToolEvenement.fullsize := false;
	TToolEvenement.Resizable := True;
	TToolEvenement.Height := PanelEvenement.Height + 10;

  TToolEvenement.top := PanelEvenement.Top;
  TToolEvenement.left := PanelEvenement.left;

  PanelEvenement.Parent := TToolEvenement;
  PanelEvenement.Enabled := True;
  PanelEvenement.Visible := True;
  PanelEvenement.Align := Alclient;

end;

procedure TOF_APPEL.definiToolConso;
begin

	TToolConso.parent := Ecran;
	TToolConso.caption := 'Liste des Consommations';
	TToolConso.clientAreaHeight := PanelConso.Height;
	TToolConso.clientAreaWidth := PanelConso.Width;
	TToolConso.ClientHeight := TToolConso.clientAreaHeight;
	TToolConso.ClientWidth := TToolConso.clientAreaWidth;

	TToolConso.DragHandleStyle := dhDouble;
	TToolConso.HideWhenInactive := False;
	TToolConso.fullsize := false;
	TToolConso.Resizable := True;
	TToolConso.Height := PanelConso.Height + 10;

  TToolConso.top := PanelConso.Top;
  TToolConso.left := PanelConso.left;

  PanelConso.Parent := TToolConso;
  PanelConso.Enabled := True;
  PanelConso.Visible := True;
  PanelConso.Align := Alclient;

end;

procedure TOF_APPEL.TToolAffectClose(sender : TObject);
begin

  InitGrille;

end;

procedure TOF_APPEL.TToolEventClose(sender : TObject);
begin

  if TobEventAppel <> nil then TobEventAppel.free;

  TToolEvenement.Width := 0;

  GrilleEvenement.ColCount := 1;
	GrilleEvenement.RowCount := 1;

  TToolEvenement.Visible := false;

end;

procedure TOF_APPEL.TToolConsoClose(sender : TObject);
begin

  if TobConsoAppel <> nil then TobConsoAppel.free;

  TToolConso.Width := 0;

  GrilleConso.ColCount := 1;
	GrilleConso.RowCount := 1;

  TToolConso.Visible := false;

end;

procedure TOF_APPEL.MajEvenement;
Var TobLigEvt	: Tob;
		TobRes		: Tob;
    QQ				: TQuery;
    StSQL			: String;
    HeureDeb	: String;
    HeureFin	: String;
    Equipe		: String;
    Rep				: String;
    NumRes		: String;
    TypeAction: String;
	  NumEvent	: Integer;
    DeltaDate	: TDateTime;
    DateDeb		: TDateTime;
    DateFin		: TDateTime;
    Duree			: Double;
    I					: Integer;
    NbEnreg		: Integer;
begin

	Equipe := '';

  if LaTob <> nil then
     Begin
  	 NumRes := LaTob.GetValue('RESSOURCE');
     TypeAction := LaTOB.GetString('TYPEACTION');
     DateDeb := LaTob.getValue('DATEDEB');
     DateFin := LaTob.getValue('DATEFIN');
     end
  else
     Begin
  	 NumRes := GetControlText('AFF_RESPONSABLE');
     TypeAction := GetParamSoc('SO_TYPEACTION');
     DateDeb := TobAppel.GetValue('AFF_DATEDEBUT');
     DateFin := TobAppel.GetValue('AFF_DATEFIN');
     end;

  if NumRes = '' then exit;

  if datefin = iDate2099 then datefin := datedeb;

  //recherche si la ressource principale appartient à un équipe
  StSQL := 'SELECT ARS_EQUIPERESS FROM RESSOURCE WHERE ARS_RESSOURCE = "' + numres + '"';

  QQ := OpenSQL(StSQL, true);
  if Not QQ.Eof then Equipe := QQ.findfield('ARS_EQUIPERESS').AsString;

  if Equipe <> '' then
     Begin
     if PGIAsk(TraduireMemoire('La Ressource appartient à l''Equipe ' + Equipe + '.' + Chr(10) + 'Voulez-vous gérer l''equipe ?'), rep) = mryes then
        StSQL := 'SELECT ARS_RESSOURCE FROM RESSOURCE WHERE ARS_EQUIPERESS = "' + Equipe + '" ORDER BY ARS_TYPERESSOURCE'
     else
        Begin
        Equipe := '';
	      StSQL := 'SELECT ARS_RESSOURCE FROM RESSOURCE WHERE ARS_RESSOURCE = "' + NumRes + '"';
        end;
     end
  else
  	 StSQL := 'SELECT ARS_RESSOURCE FROM RESSOURCE WHERE ARS_RESSOURCE = "' + NumRes + '"';
  ferme(QQ);


  QQ := OpenSql (StSQL,true);
  TobRes:= Tob.create('LESRESSOURCES', nil, -1);
	if Not QQ.eof then TobRes.LoadDetailDB('RESSOURCE', '', '', QQ, True);
  Ferme(QQ);

  //chargement de la Tob Type d'action
  StSQL := 'SELECT * FROM BTETAT WHERE BTA_BTETAT = "' + TypeAction + '"';
  QQ := OpenSQL(StSQL, true);
  if QQ.Eof then
     begin
     if LaTob <> nil then LaTob.PutValue('RETOUR', 0);
     Ferme(QQ);
     exit;
     end;

  HeureDeb 	:= TimeToStr(DateDeb);
  DeltaDate := StrToTime(HeureDeb);
  Duree   := QQ.FindField('BTA_DUREEMINI').AsFloat;
  DeltaDate := DeltaDate + (Duree * 60) / 1440;
  HeureFin := FormatDateTime('hh:mm', DeltaDate);

  NbEnreg := TobRes.detail.count -1;

  for I := 0 to NbEnreg do
      Begin
      //Chargement de la Tob des Evènements avec la tob de l'Appel
      if GetNumCompteur('BEP', NumEvent) then
         Begin
         TobLigEvt := Tob.create('BTEVENPLAN',nil, -1);
			   TobLigEvt.PutValue('BEP_CODEEVENT', IntToStr(NumEvent));
			   TobLigEvt.PutValue('BEP_RESSOURCE', TobRes.detail[I].GetValue('ARS_RESSOURCE'));
         TobLigEvt.PutValue('BEP_BTETAT', TypeAction);
         TobLigEvt.PutValue('BEP_AFFAIRE', CodeAppel);
         TobLigEvt.PutValue('BEP_TIERS', CodeTiers);
         TobLigEvt.PutValue('BEP_NUMEROADRESSE', NoAdresse);
         TobLigEvt.PutValue('BEP_EQUIPERESS', Equipe);
         TobLigEvt.PutValue('BEP_MODIFIABLE', 'X');
         TobLigEvt.PutValue('BEP_RESPRINCIPALE', 'X');
         TobLigEvt.PutValue('BEP_EQUIPESEP', '-');
         TobLigEvt.PutValue('BEP_OBLIGATOIRE', QQ.FindField('BTA_OBLIGATOIRE').AsString);
         TobLigEvt.PutValue('BEP_DUREE', Duree);
         TobLigEvt.PutValue('BEP_DATEDEB', Trunc(DateDeb) + StrToTime(HeureDeb));
         TobLigEvt.PutValue('BEP_HEUREDEB', StrToTime(HeureDeb));
         TobLigEvt.PutValue('BEP_DATEFIN', Trunc(DateFin) + StrToTime(HeureFin));
         TobLigEvt.PutValue('BEP_HEUREFIN', StrToTime(HeureFin));
         TobLigEvt.PutValue('BEP_PERIODEDEBUT', '');
         TobLigEvt.PutValue('BEP_PERIODEFIN', '');
         TobLigEvt.PutValue('BEP_GEREPLAN', QQ.FindField('BTA_ASSOSRES').AsString);
         TobLigEvt.PutValue('BEP_HEURETRAV', 'X');
         TobLigEvt.PutValue('BEP_CREAPLANNING', 'X');
         TobLigEvt.PutValue('BEP_BLOCNOTE', '');
         TobLigEvt.InsertOrUpdateDB;
         LaTob.PutValue('BEP_AFFAIRE', CodeAppel);
				 LaTob.PutValue('BEP_EQUIPERESS', Equipe);
         LaTob.PutValue('RETOUR', 1);
         TobLigEvt.Free;
         end
      else
      	 Break;
  		end;

  Ferme(QQ);

  TobRes.Free;

end;

procedure TOF_APPEL.GestionSaisieNumAppel;
begin

  //
  CodeAppelDecoupe(CodeAppel, P0, P1, P2, P3, Avn);

	//chargement des zones écran cachées
	SetControlText('CAFF_AFFAIRE0', P0) ;
  SetControlText('CAFF_AFFAIRE1', P1);
	SetControlText('CAFF_AFFAIRE2', P2);
	SetControlText('CAFF_AFFAIRE3', P3);
  SetControlText('CAFF_AVENANT', Avn);

end;

procedure TOF_APPEL.CHKTACHESClick(Sender: TObject);
begin

  if not ChargeGrille then
     Begin
     ChargeListeAssociee('BTMULAPPELS', 'Liste des Affectations', TToolAffect, GestGrille);
     ChargeHistorique;
     End;

end;

procedure TOF_APPEL.EtatAffaireOnChange(Sender: TObject);
begin

  if not ChargeGrille then
     Begin
     ChargeListeAssociee('BTMULAPPELS', 'Liste des Affectations', TToolAffect, GestGrille);
     ChargeHistorique;
     End;

end;

procedure TOF_APPEL.PrioContratOnChange(Sender: TObject);
begin

  if not ChargeGrille then
     Begin
     ChargeListeAssociee('BTMULAPPELS', 'Liste des Affectations', TToolAffect, GestGrille);
     ChargeHistorique;
     End;

end;

Procedure Tof_Appel.GrilleAffectationClick(Sender: TObject);
Begin

  if TobHistoAppel.Detail.Count <> 0 then
     Begin
     DetailAppel.Text := TobHistoAppel.Detail[GrilleAffectation.Row-1].GetString('AFF_DESCRIPTIF');
     if TobHistoAppel.Detail[GrilleAffectation.Row-1].GetString('AFF_ETATAFFAIRE') = 'ANN' then
        Lib_DetailInt.Caption := 'DETAIL ANNULATION'
     Else
        Lib_DetailInt.Caption := 'DETAIL D''INTERVENTION';
     Lib_DetailInt.width   := DetailInt.Width;
     DetailInt.Text   := TobHistoAppel.Detail[GrilleAffectation.Row-1].GetString('LO_OBJET');
     end;

end;

Procedure Tof_Appel.GrilleAffectationDBLClick(Sender: TObject);
Begin

  //Appel de la grille des evenements au planning
  //Il faut que l'appel soit affecté
  if TobHistoAppel.Detail.Count = 0 then exit;

  if TobHistoAppel.Detail[GrilleAffectation.Row-1].GetString('AFF_RESPONSABLE') = '' then exit;

  //Chargement et dessin de la grille
  ChargeListeAssociee('BLITEMSPLANN1', 'Liste des Evenements sur Appel', TToolEvenement, GestGrille);
  DessineGrille(TToolEvenement, GrilleEvenement, GestGrille);

  //Chargement des infos de la grille affectation
  ChargeEvenement;

  if TobEventAppel.Detail.Count = 0 then
     Begin
     TToolEventClose(sender);
     ChargeListeAssociee('BTSAISIECONSO', 'Liste des Consommations sur Appel', TToolConso, GestGrille);
	   DessineGrille(TToolConso, GrilleConso, GestGrille);
     //Chargement des infos de la grille affectation
     ChargeConso;
     end;
end;

Procedure Tof_Appel.GrilleEvenementDBLClick(Sender: TObject);
Begin

  //Appel de la grille des evenements au planning
  //Il faut que l'appel soit affecté
  if TobEventAppel.Detail.Count = 0 then exit;

  //Chargement et dessin de la grille
  ChargeListeAssociee('BTSAISIECONSO', 'Liste des Consommations sur Appel', TToolConso, GestGrille);
  DessineGrille(TToolConso, GrilleConso, GestGrille);

  //Chargement des infos de la grille affectation
  ChargeConso;

end;

procedure TOF_APPEL.ChargeEvenement;
Var StSQL     : String;
    StAppel   : String;
    ZoneTable : String;
    QAppel		: TQuery;
    I		      : integer;
    J				  : integer;
Begin

  //Chargement de la grille Evenement=> en utilisant le paramétrage grille appels
  ZoneTable := '';
  StAppel   := TobHistoAppel.Detail[GrilleAffectation.Row-1].GetString('AFF_AFFAIRE');

  StSql := GestGrille.ColGAppel;

  //Chargement de la TOB
  while  StSql <> '' do
     begin
     if ZoneTable = '' Then
	 	  	ZoneTable := ReadTokenst(StSql)
     else
	      ZoneTable := ZoneTable + ',' + ReadTokenst(StSql);
     end;

  TobEventAppel := Tob.create('Les Affectations', nil, -1);

  StSQL := 'SELECT BEP_RESSOURCE,' + ZoneTable + ' FROM ' + GestGrille.TableGapp;
  stSql := StSQL + ' LEFT JOIN RESSOURCE ON (ARS_RESSOURCE = BEP_RESSOURCE)';
  StSQL := StSQL + ' WHERE BEP_AFFAIRE = "' + StAppel + '"';

  if GestGrille.TriGapp <> '' then  StSQL := StSQL + ' ORDER BY ' + GestGrille.TriGapp;

  QAppel := OpenSQL(StSQL, True);

  TobEventAppel.LoadDetailDB('EVENEMENT', '', '', QAppel, False);

  Ferme(QAppel);

  StSql := GestGrille.ColGAppel;

  with GrilleEvenement do
       Begin
       if TobEventAppel.detail.count = 0 then
          Begin
	        RowCount := 2;
          For J := 1 to ColCount - 1 do
              Begin
              Cells[J, 1] := '';
              end;
          end
       else
          Begin
          RowCount := TobEventAppel.detail.count + 1;
    	    For i := 0 to TobEventAppel.detail.count - 1 Do
              Begin
              Cells[0, I] := '';
              StSql := GestGrille.ColGAppel;
  		        For J := 1 to ColCount - 1 do
                  begin
                  Cells[0, I+1] := '';
                  Cells[J, I+1] := TobEventAppel.Detail[I].GetValue(ReadTokenst(StSql));
					        end;
              end;
          row := 1;
          end;
       end;

  //Affichage de la ttoolwindows historique des Appels
  TToolEvenement.Visible := true;
  GrilleEvenement.SetFocus;

end;

procedure TOF_APPEL.ChargeConso;
Var StSQL       : String;
    StAppel     : String;
    StRessource : String;
    ZoneTable   : String;
    QAppel		  : TQuery;
    I		        : integer;
    J				    : integer;
Begin

  //Chargement de la grille Evenement=> en utilisant le paramétrage grille appels
  ZoneTable   := '';

  StAppel     := TobHistoAppel.Detail[GrilleAffectation.Row-1].GetString('AFF_AFFAIRE');
  StRessource := TobHistoAppel.Detail[GrilleAffectation.Row-1].GetString('AFF_RESPONSABLE');

  StSql := GestGrille.ColGAppel;

  //Chargement de la TOB
  while  StSql <> '' do
     begin
     if ZoneTable = '' Then
	 	  	ZoneTable := ReadTokenst(StSql)
     else
	      ZoneTable := ZoneTable + ',' + ReadTokenst(StSql);
     end;

  TobConsoAppel := Tob.create('Les Consommations', nil, -1);

  StSQL := 'SELECT ' + ZoneTable + ' FROM ' + GestGrille.TableGapp;
  StSQL := StSQL + ' WHERE BCO_AFFAIRE = "' + StAppel;
  StSql := StSQL + '" AND BCO_RESSOURCE = "' + StRessource + '"';

  if GestGrille.TriGapp <> '' then  StSQL := StSQL + ' ORDER BY ' + GestGrille.TriGapp;

  QAppel := OpenSQL(StSQL, True);

  TobConsoAppel.LoadDetailDB('CONSOMMATION', '', '', QAppel, False);

  Ferme(QAppel);

  StSql := GestGrille.ColGAppel;

  with GrilleConso do
       Begin
       if TobConsoAppel.detail.count = 0 then
          Begin
	        RowCount := 2;
          For J := 1 to ColCount - 1 do
              Begin
              Cells[J, 1] := '';
              end;
          end
       else
          Begin
          RowCount := TobConsoAppel.detail.count + 1;
    	    For i := 0 to TobConsoAppel.detail.count - 1 Do
              Begin
              Cells[0, I] := '';
              StSql := GestGrille.ColGAppel;
  		        For J := 1 to ColCount - 1 do
                  begin
                  Cells[0, I+1] := '';
                  Cells[J, I+1] := TobConsoAppel.Detail[I].GetValue(ReadTokenst(StSql));
					        end;
              end;
          row := 1;
          end;
       end;

  //Affichage de la ttoolwindows consommation sur Appels
  TToolConso.Visible := true;
  GrilleConso.SetFocus;

end;

procedure TOF_APPEL.SetInfosTel(Etat : boolean);
begin
	SetControlEnabled ('T_TELEPHONE',Etat);
	SetControlEnabled ('T_FAX',Etat);
	SetControlEnabled ('T_TELEX',Etat);
end;

procedure TOF_APPEL.ComplementsClick(Sender: Tobject);
begin
 TheTOB := TobAppel;
 AglLanceFiche ('BTP','BTAPPELINTCOMPL','','',ActionToSTring(AFTypeAction));
 TheTOB := nil;
end;


procedure TOF_APPEL.BTELBUR_OnClick(Sender: TObject);
begin
  FonctionCTI ('MAKECALL', GetControlText ('T_FAX'), 'T_AUXILIAIRE=' + Auxiliaire); // $$$ JP 13/08/07 FQ 10691 GetControlText ('T_TELEX'));
	SetEtatBoutonCti;
end;

procedure TOF_APPEL.BTELDOM_OnClick(Sender: TObject);
begin
  FonctionCTI ('MAKECALL', GetControlText ('T_TELEPHONE'), 'T_AUXILIAIRE=' + Auxiliaire);
	SetEtatBoutonCti;
end;


procedure TOF_APPEL.BPhoneClick(Sender: TObject);
begin
  SetControlProperty('INFOSCTI','Caption','Communication en cours');
  FonctionCTI ('GETCALL','');
  BPHONE.Down := True;
  BPHONE.enabled := false;
  BAttente.Visible:= True;
  BStop.Visible:= True;
end;

procedure TOF_APPEL.BStopClick (Sender : TObject);
begin
  SetControlProperty('INFOSCTI','Caption','Communication terminée');
  FonctionCTI ('CALLBYE','');
  BPHONE.Down := false;
  BPHONE.enabled := true;
  BAttente.Visible:= false;
  BStop.Visible:= false;
	SetEtatBoutonCti;
end;

procedure TOF_APPEL.BAttenteClick (Sender : TObject);
begin
  if BATTENTE.hint = 'Mise en attente' then
  begin
  SetControlProperty('INFOSCTI','Caption','Mise en attente');
  FonctionCTI ('CALLWAIT','');
  BATTENTE.hint := 'Reprise de l''appel';
  end else
  begin
  SetControlProperty('INFOSCTI','Caption','Communication en cours');
  FonctionCTI ('CALLWAIT','');
  BATTENTE.hint := 'Mise en attente';
  end;
end;

procedure TOF_APPEL.BTELPORT_OnClick(Sender: TObject);
begin
  FonctionCTI ('MAKECALL', GetControlText ('T_TELEX'), 'T_AUXILIAIRE=' + Auxiliaire); // $$$ JP 13/08/07 FQ 10691 GetControlText ('T_GetControlText ('T_FAX'));
	SetEtatBoutonCti;
end;

procedure TOF_APPEL.SetEtatBoutonCti;
begin
  BPhone.Visible := (VH_RT.ctiAlerte.GetState<>TCtiDisable)
  									and (VH_RT.ctiAlerte.GetState<>TctiDecroche)
                    and (VH_RT.ctiAlerte.GetState<>TctiNothingToDo)   ;
  BAttente.Visible:= (VH_RT.ctiAlerte.GetState<>TCtiDisable)
  										and (VH_RT.ctiAlerte.GetState=TctiDecroche);
  BStop.Visible:= (VH_RT.ctiAlerte.GetState<>TCtiDisable)
  								and (VH_RT.ctiAlerte.GetState=TctiDecroche) ;
end;

procedure TOF_Appel.PositionneEtabUser(NomChamp: string);
Var Etab : String ;
    Forcer : Boolean ;
    CC :THDbValComboBox;
    LastEnabled : boolean;
begin
CC := THDBValCOmboBox (GetCOntrol(NOMChamp));
if CC = nil then exit;
LastEnabled := CC.Enabled ;
if Not VH^.EtablisCpta then Exit ;
if Not CC.Visible then Exit ;
Etab:=VH^.ProfilUserC[prEtablissement].Etablissement ; if Etab='' then Exit ;
Forcer:=VH^.ProfilUserC[prEtablissement].ForceEtab ;
if CC.Values.IndexOf(Etab)<0 then Exit ;
if ((Not CC.Enabled) and (CC.Value<>Etab)) then CC.enabled := true;
SetControlText(NomChamp,Etab);
if (Forcer) then CC.Enabled:=False ;
end;

procedure TOF_APPEL.BVisuParcClick(Sender: TObject);
var		ActionT : string;
begin
	if AFTypeAction<>taConsult then ActionT := 'ACTION=MODIFICATION'
  							 						 else ActionT := 'ACTION=CONSULTATION';
  if CodeTiers  <> '' then
     AGLLanceFiche ('BTP','BTPARCTIER','',CodeTiers,ActionT+';TIERS='+CodeTiers+';MONOFICHE');

end;

Initialization
  registerclasses ( [ TOF_APPEL ] ) ;
end.

