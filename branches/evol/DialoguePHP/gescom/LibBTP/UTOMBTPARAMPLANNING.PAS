{***********UNITE*************************************************
Auteur  ...... : GF
Créé le ...... : 24/09/2000
Modifié le ... : 19/02/2001
Description .. : Tom du paramétrage planning graphique & numerique (en
Suite ........ : quantité)
Mots clefs ... : PLANNING
*****************************************************************}

unit UtomBTPARAMPLANNING;

interface
uses
  Classes,
  Controls,
  Forms,
  graphics,
  StdCtrls,
  ComCtrls,
  DbCtrls,
  ParamDBG,
  UTOM,
  utob,
  SysUtils,
  msgUtil,
  //
  {$IFDEF EAGLCLIENT}
  MaineAGL,
  EFiche,
  UtileAGL,
  {$ELSE}
  db,
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  Fiche,
  Fe_main,
  {$ENDIF}
  //
  M3FP,
  Paramsoc,
  HCtrls,
  HDB,
  Hqry,
  HTB97,
  AglInit,
  //
  HEnt1;
       
type

  TOM_HRPARAMPLANNING = class(TOM)

  public
    procedure OnArgument(Arguments: string); override;
    procedure OnNewRecord; override;
    procedure OnUpdateRecord; override;
    procedure OnLoadRecord; override;
    procedure Duplication(CleDuplic: string); //REGIS

  private

    //Gestion des variables globales
    CodeParam           : String;
    //
    AFTypeAction				: TActionFiche;
    //                           
    //Gestion des boutons
    BAPERCU						  : TToolbarButton97;
    BCOULEURLUNDI		  	: TToolbarButton97;
    BCOULEURMARDI			  : TToolbarButton97;
    BCOULEURMERCREDI	  : TToolbarButton97;
    BCOULEURJEUDI			  : TToolbarButton97;
    BCOULEURVENDREDI	  : TToolbarButton97;
    BCOULEURSAMEDI		  : TToolbarButton97;
    BCOULEURDIMANCHE	  : TToolbarButton97;
	  BCOULEURVEILJFERIE  : TToolbarButton97;
	  BCOULEURJFERIE			: TToolbarButton97;
    BDUPLICATION				: TToolbarButton97;
    BFOND						    : TToolbarButton97;
    BPARAMITEM					: TToolbarButton97;
    BPARAMHINT					: TToolbarButton97;
    BPARAMGAPP					: TToolbarButton97;
    BSELECTION					: TToolBarButton97;
    BFONTE    					: TToolbarButton97;

    //Gestions des Libellés
    LFond						  : THEdit;
    LSelection				: THEdit;
    LSamedi						: THEdit;
    LDimanche					: THEdit;
    LLundi						: THEdit;
    LMardi						: THEdit;
    LMercredi					: THEdit;
    LJeudi						: THEdit;
    LVendredi					: THEdit;
    LVeilJFerie				: THEdit;
    LJFerie						: THEdit;

    LFonte						: THLabel;

    //Gestion des combo
    HPP_MODEPLANNING 		: THDBValComboBox;
    HPP_FAMRES					: THDBValComboBox;
    HPP_CADENCEMENT			: THDBValComboBox;
    HPP_CONTENUITEM			: THDBValComboBox;
  	HPP_CONTENUHINT			: THDBValComboBox;
	  HPP_CONTENUGAPP			: THDBValComboBox;

    //Gestion des Zônes de Saisie
    HPP_LIBCOL1				: THDBEdit;
    HPP_LIBCOL2				: THDBEdit;
    HPP_LIBCOL3				: THDBEdit;
    HPP_LIBCOL4				: THDBEdit;
    HPP_LIBCOL5				: THDBEdit;
    HPP_LIBCOL6				: THDBEdit;
    HPP_LIBCOL7				: THDBEdit;
    HPP_LIBCOL8				: THDBEdit;
    HPP_LIBCOL9				: THDBEdit;

    HPP_NBCOLDIVERS			: THDBSpinEdit;
    HPP_NBLIGDIVERS			: THDBSpinEdit;

    HPP_PLANNINGTYPEET  : TDBCheckBox;
    HPP_PLANNINGTYPETD  : TDBCheckBox;

    HEUREDEBUT        : THEdit;
    HEUREFIN	        : THEdit;

    ListeItem					: string;
	  ListeHint					: string;
    ListeGapp					: String;
	  Cadencement 			: String;

    AncValNbCol				: Integer;
    AncValNbLig				: Integer;

    //Procedure propres aux évènements des objets de la fiche
    Procedure BAPERCU_OnClick(Sender: TObject);
    Procedure BCOULEURDIMANCHE_OnClick(Sender: TObject);
    Procedure BCOULEURJEUDI_OnClick(Sender: TObject);
    Procedure BCOULEURJFERIE_OnClick(Sender: TObject);
    Procedure BCOULEURLUNDI_OnClick(Sender: TObject);
    Procedure BCOULEURMARDI_OnClick(Sender: TObject);
    Procedure BCOULEURMERCREDI_OnClick(Sender: TObject);
    Procedure BCOULEURSAMEDI_OnClick(Sender: TObject);
    Procedure BCOULEURVEILJFERIE_OnClick(Sender: TObject);
    Procedure BCOULEURVENDREDI_OnClick(Sender: TObject);
    Procedure BDUPLICATION_OnClick(Sender: TObject);
    Procedure BFOND_OnClick(Sender: TObject);
    Procedure BFONTE_OnClick(Sender: TObject);
    Procedure BPARAMHINT_OnClick(Sender: TObject);
    Procedure BPARAMITEM_OnClick(Sender: TObject);
    Procedure BPARAMGAPP_OnClick(Sender: TObject);
    Procedure BSELECTION_OnClick(Sender: TObject);

    Procedure HPP_CADENCEMENT_OnChange(Sender: TObject);
    Procedure HPP_CONTENUITEM_OnChange(Sender: TObject);
	  Procedure HPP_CONTENUHINT_OnChange(Sender: TObject);
    Procedure HPP_CONTENUGAPP_OnChange(Sender: TObject);
    Procedure HPP_FAMRES_OnChange(Sender: TObject);
    Procedure HPP_NBCOLDIVERS_OnChange(Sender: TObject);
    Procedure HPP_NBLIGDIVERS_OnChange(Sender: TObject);
    procedure HPP_MODEPLANNING_OnChange(Sender: TObject);
    Procedure HPP_PLANNINGTYPEET_OnExit(Sender: TObject);
    Procedure HPP_PLANNINGTYPETD_OnExit(Sender: TObject);

    procedure GestionParamStandard;
    procedure ControleChamp(Champ, Valeur: String);
    procedure ControleCritere(Valeur: String);

  end;

implementation


Procedure TOM_HRPARAMPLANNING.OnArgument(Arguments : string);
var Critere : String;
    Valeur  : String;
    Champ   : String;
    X       : integer;
Begin
  Inherited ;

  AncValNbCol := 1;
  AncValNbLig := 1;

  CodeParam := '';

  //traitement Arguments
	Critere:=(Trim(ReadTokenSt(Arguments)));

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
      Critere := (Trim(ReadTokenSt(Arguments)));
    end;

  BApercu := TToolbarButton97(ecran.FindComponent('BAPERCU'));
  BApercu.onclick := BApercu_OnClick;

  BCouleurLundi := TToolbarButton97(ecran.FindComponent('BCOULEURLUNDI'));
  BCouleurLundi.onclick := BCouleurLundi_OnClick;

  BCouleurMardi := TToolbarButton97(ecran.FindComponent('BCOULEURMARDI'));
  BCouleurMardi.onclick := BCouleurMardi_OnClick;

  BCouleurMercredi := TToolbarButton97(ecran.FindComponent('BCOULEURMERCREDI'));
  BCouleurMercredi.onclick := BCouleurMercredi_OnClick;

  BCouleurJeudi := TToolbarButton97(ecran.FindComponent('BCOULEURJEUDI'));
  BCouleurJeudi.onclick := BCouleurJeudi_OnClick;

  BCouleurVendredi := TToolbarButton97(ecran.FindComponent('BCOULEURVENDREDI'));
  BCouleurVendredi.onclick := BCouleurVendredi_OnClick;

  BCouleurSamedi := TToolbarButton97(ecran.FindComponent('BCOULEURSAMEDI'));
  BCouleurSamedi.onclick := BCouleurSamedi_OnClick;

  BCouleurDimanche := TToolbarButton97(ecran.FindComponent('BCOULEURDIMANCHE'));
  BCouleurDimanche.onclick := BCouleurDimanche_OnClick;

  BCouleurVeilJFerie := TToolbarButton97(ecran.FindComponent('BCOULEURVEILJFERIE'));
  BCouleurVeilJFerie.OnClick := BCouleurVeilJFerie_OnClick;

  BCouleurJFerie := TToolbarButton97(ecran.FindComponent('BCOULEURJFERIE'));
  BCouleurJFerie.OnClick := BCouleurJFerie_OnClick;

  BDuplication := TToolbarButton97(ecran.FindComponent('B_DUPLICATION'));
  BDuplication.onclick := BDuplication_OnClick;

  BFond := TToolbarButton97(ecran.FindComponent('BFOND'));
  BFond.onclick := BFond_OnClick;

  BFonte := TToolbarButton97(ecran.FindComponent('BFONTE'));
  BFonte.onclick := BFonte_OnClick;

  BSelection := TToolbarButton97(ecran.FindComponent('BSELECTION'));
  BSelection.onclick :=   BSelection_OnClick;

  BPARAMITEM := TToolbarButton97(ecran.FindComponent('BPARAMITEM'));
  BPARAMITEM.onclick := BPARAMITEM_OnClick;

  BPARAMHINT := TToolbarButton97(ecran.FindComponent('BPARAMHINT'));
  BPARAMHINT.onclick := BPARAMHINT_OnClick;

  BPARAMGAPP := TToolbarButton97(ecran.FindComponent('BPARAMGAPP'));
  BPARAMGAPP.onclick := BPARAMGAPP_OnClick;

  LFond 			:= THEdit(ecran.FindComponent('LFOND'));
	LSelection 	:= THEdit(ecran.FindComponent('LSELECTION'));
  LSamedi 		:= THEdit(ecran.FindComponent('LSAMEDI'));
  LDimanche 	:= THEdit(ecran.FindComponent('LDIMANCHE'));
  LLundi 			:= THEdit(ecran.FindComponent('LLUNDI'));
  LMardi 			:= THEdit(ecran.FindComponent('LMARDI'));
  LMercredi 	:= THEdit(ecran.FindComponent('LMERCREDI'));
  LJeudi 			:= THEdit(ecran.FindComponent('LJEUDI'));
  LVendredi 	:= THEdit(ecran.FindComponent('LVENDREDI'));
  LVeilJFerie := THEdit(ecran.FindComponent('LVEILJFERIE'));
  LJFerie 		:= THEdit(ecran.FindComponent('LJFERIE'));

	LFonte 			:= THLabel(ecran.FindComponent('LFONTE'));

  if CodeParam = 'PLA' then
     Begin
     HPP_FAMRES := THDBValComboBox(Ecran.FindComponent('HPP_FAMRES'));
     HPP_FAMRES.OnChange := HPP_FAMRES_OnChange;
     HPP_LIBCOL4 := THDBEdit(Ecran.FindComponent('HPP_LIBCOL4'));
     HPP_LIBCOL5 := THDBEdit(Ecran.FindComponent('HPP_LIBCOL5'));
     //HPP_PLANNINGTYPEET := TDBCheckBox(Ecran.FindComponent('HPP_PLANNINGTYPEET'));
     //HPP_PLANNINGTYPEET.OnExit := HPP_PLANNINGTYPEET_OnExit;
     HPP_PLANNINGTYPETD := TDBCheckBox(Ecran.FindComponent('HPP_PLANNINGTYPETD'));
     HPP_PLANNINGTYPETD.OnExit := HPP_PLANNINGTYPETD_OnExit;
     end;

  HPP_MODEPLANNING := THDBValComboBox(Ecran.FindComponent('HPP_MODEPLANNING'));
  HPP_MODEPLANNING.OnChange := HPP_MODEPLANNING_OnChange;

  HPP_CADENCEMENT	 := THDBValComboBox(Ecran.FindComponent('HPP_CADENCEMENT'));
  HPP_CADENCEMENT.OnChange := HPP_CADENCEMENT_OnChange;

  HPP_CONTENUITEM := THDBValComboBox(Ecran.FindComponent('HPP_CONTENUITEM'));
  HPP_CONTENUITEM.OnChange := HPP_CONTENUITEM_OnChange;

  HPP_CONTENUHINT := THDBValComboBox(Ecran.FindComponent('HPP_CONTENUHINT'));
  HPP_CONTENUHINT.OnChange := HPP_CONTENUHINT_OnChange;

  HPP_CONTENUGAPP := THDBValComboBox(Ecran.FindComponent('HPP_AXECONTINGENT1'));
  HPP_CONTENUGAPP.OnChange := HPP_CONTENUGAPP_OnChange;

  HPP_NBCOLDIVERS := THDBSpinEdit(Ecran.FindComponent('HPP_NBCOLDIVERS'));
  HPP_NBCOLDIVERS.OnChange := HPP_NBCOLDIVERS_OnChange;

  HPP_NBLIGDIVERS := THDBSpinEdit(Ecran.FindComponent('HPP_NBLIGDIVERS'));
  HPP_NBLIGDIVERS.OnChange := HPP_NBLIGDIVERS_OnChange;

  HPP_LIBCOL1 := THDBEdit(Ecran.FindComponent('HPP_LIBCOL1'));
  HPP_LIBCOL2 := THDBEdit(Ecran.FindComponent('HPP_LIBCOL2'));
  HPP_LIBCOL3 := THDBEdit(Ecran.FindComponent('HPP_LIBCOL3'));
  HPP_LIBCOL6 := THDBEdit(Ecran.FindComponent('HPP_LIBCOL6'));
  HPP_LIBCOL7 := THDBEdit(Ecran.FindComponent('HPP_LIBCOL7'));
  HPP_LIBCOL8 := THDBEdit(Ecran.FindComponent('HPP_LIBCOL8'));
  HPP_LIBCOL9 := THDBEdit(Ecran.FindComponent('HPP_LIBCOL9'));

  HEUREDEBUT := THEdit(Ecran.FindComponent('HEUREDEBUT'));
  HEUREFIN 	 := THEdit(Ecran.FindComponent('HEUREFIN'));

  AvertirTable('BTFAMRES');

end;


procedure TOM_HRPARAMPLANNING.OnNewRecord;
Var Req : String;
begin

  AncValNbCol := 1;
  AncValNbLig := 1;

  // Initilisation des champs
  SetField('HPP_TAILLECOL1', 60);
  //
  SetField('HPP_HAUTLIGNEENT', 18);
  SetField('HPP_HAUTLIGNEDATA', 18);
  //
  SetField('HPP_TAILLECOLONNE', 100);
  SetField('HPP_INTERVALLEDEB', 0);
  SetField('HPP_INTERVALLEFIN', 7);
  SetField('HPP_DUREETIMER', 5);
  //
  Setfield('HPP_COULEURSAMEDI',ColorToString($000000FE));
  Setfield('HPP_COULDIMANCHE',ColorToString($000000FE));
  Setfield('HPP_COULSELECTION',ColorToString($00FE0000));
  Setfield('HPP_COULEURFOND',ColorToString($00FFFFFE));
  //
  Setfield('HPP_FORMEGRAPHIQUE', 'PGL');
  SetField('HPP_FONTCOLONNE', 'Ms Sans Serif');
  SetField('HPP_AFFDATEGROUP', 'X');
  SetField('HPP_PLANNINGGRAPH', 'X');
  //
  SetField('HPP_VISUTYPERES', '-');
  //
  SetField('HPP_AXECONTINGENT1','001');    // Rajout LS Suite plantage en entrée dans le planning
  //
  if CodeParam = '' then
     SetField('HPP_MODEPLANNING', 'PLA')
  else
     SetField('HPP_MODEPLANNING', CodeParam);
  //
  SetControlEnabled('BAPERCU', True);
  //
  //Controle si un planning par defaut existe déjà pour ce type de planning...
  Req := 'Select HPP_PLANNINGDEFAUT from HRPARAMPLANNING where HPP_PLANNINGDEFAUT="X"';
  Req := Req + 'AND HPP_MODEPLANNING="' + HPP_MODEPLANNING.Value + '"';
  if ExisteSQL(req) then
     begin
     SetField('HPP_PLANNINGDEFAUT', '-');
     SetControlEnabled('HPP_PLANNINGDEFAUT', False);
     end
  else
     SetControlEnabled('HPP_PLANNINGDEFAUT', True);
  //
  SetControlProperty('THPP_TAILLECOLENTETE1','Enabled', true);
  SetControlProperty('THPP_TAILLECOLENTETE2','Enabled', False);
  SetControlProperty('THPP_TAILLECOLENTETE3','Enabled', False);
  SetControlProperty('THPP_TAILLECOLENTETE4','Enabled', true);
  SetControlProperty('THPP_TAILLECOLENTETE5','Enabled', False);
  SetControlProperty('THPP_TAILLECOLENTETE6','Enabled', False);
  SetControlProperty('THPP_TAILLECOLENTETE7','Enabled', False);
  SetControlProperty('THPP_TAILLECOLENTETE8','Enabled', False);
  SetControlProperty('THPP_TAILLECOLENTETE9','Enabled', False);
  //
	SetControlProperty('HPP_TAILLECOLENT1','Enabled', true);
  SetControlProperty('HPP_TAILLECOLENT2','Enabled', False);
  SetControlProperty('HPP_TAILLECOLENT3','Enabled', False);
	SetControlProperty('HPP_TAILLECOLENT4','Enabled', true);
  SetControlProperty('HPP_TAILLECOLENT5','Enabled', False);
  SetControlProperty('HPP_TAILLECOLENT6','Enabled', False);
	SetControlProperty('HPP_TAILLECOLENT7','Enabled', False);
  SetControlProperty('HPP_TAILLECOLENT8','Enabled', False);
  SetControlProperty('HPP_TAILLECOLENT9','Enabled', False);
  //
	SetControlProperty('HPP_REGCOL1','Visible', true);
  SetControlProperty('HPP_REGCOL2','Visible', False);
  SetControlProperty('HPP_REGCOL3','Visible', False);
  //
  SetField('HPP_TAILLECOLENT1', 0);
  SetField('HPP_TAILLECOLENT2', 0);
  SetField('HPP_TAILLECOLENT3', 0);
  //
  SetField('HPP_TAILLECOLENT4', 60);
  SetField('HPP_TAILLECOLENT5', 0);
  SetField('HPP_TAILLECOLENT6', 0);
  SetField('HPP_TAILLECOLENT7', 0);
  SetField('HPP_TAILLECOLENT8', 0);
  SetField('HPP_TAILLECOLENT9', 0);
  //
  SetField('HPP_HEUREDEBUT', '00:00');
  SetField('HPP_HEUREFIN', '00:00');
  //
  BPARAMITEM.Visible := false;
  BPARAMHINT.Visible := false;
  BPARAMGAPP.Visible := false;

  //Chargement des combos de mise en forme
  HPP_CONTENUITEM.ItemIndex := 0;
  HPP_CONTENUHINT.ItemIndex := 0;
  HPP_CONTENUGAPP.ItemIndex := 0;

end;

procedure TOM_HRPARAMPLANNING.OnUpdateRecord;
Var LibCol	: String;
    I				: Integer;
begin
  //
  Lasterror := 0;
  //
  if codeParam <> 'PLA' then
     setfield('HPP_ABREGE', Getfield('HPP_LIBELLE'));
     
  if GetField('HPP_COULEURFOND') = '' then   SetField('HPP_COULEURFOND','ClWhite');

  if GetField('HPP_COULSELECTION') = '' then SetField('HPP_COULSELECTION','ClBlue');

  if GetField('HPP_COULEURSAMEDI') = '' then SetField('HPP_COULEURSAMEDI','ClRed');

  if GetField('HPP_COULDIMANCHE') = '' then  SetField('HPP_COULDIMANCHE','ClRed');

  {if (GetField('HPP_AXECONTINGENT2') <> '') and (GetField('HPP_AXECONTINGENT1') = GetField('HPP_AXECONTINGENT2')) Then
     Begin
     AfficheErreur(ecran.Name,'11','Paramètre du Planning');
     exit;
	   end;}

  // Vérification de la validité des champs
  if CodeParam = 'PLA' then
     Begin
     if GetField('HPP_FAMRES') = '' then
        begin
        Lasterror := 1;
        AfficheErreur(ecran.Name,'1','Paramètre du Planning');
        SetActiveTabSheet('PGENERAL');
        SetFocusControl('HPP_FAMRES');
        exit;
        end;
     end;

  if GetField('HPP_NBLIGDIVERS') = 0 then
     begin
     Lasterror := 12;
     AfficheErreur(ecran.Name,'12','Paramètre du Planning');
     SetActiveTabSheet('PGENERAL');
     SetFocusControl('HPP_NBLIGDIVERS');
     exit;
     end;

  if GetField('HPP_NBCOLDIVERS') = 0 then
     begin
     Lasterror := 13;
     AfficheErreur(ecran.Name,'13','Paramètre du Planning');
     SetActiveTabSheet('PMISEFORME');
     SetFocusControl('HPP_NBCOLDIVERS');
     exit;
     end;

  if GetField('HPP_FORMATDATECOL0') = '' then
     begin
     Lasterror := 4;
     AfficheErreur(ecran.Name,'4','Paramètre du Planning');
     SetActiveTabSheet('PGENERAL');
     SetFocusControl('HPP_FORMATDATECOL0');
     exit;
     end;

  SetField('HPP_HEUREDEBUT', HEUREDEBUT.text);
  SetField('HPP_HEUREFIN', HEUREFIN.text);

  //Controle des libellés de la colonne d'entête
  For i:=1 To GetField('HPP_NBLIGDIVERS') do
      Begin
      Libcol := Getfield('HPP_LIBCOL' + IntToStr(i));
      LibCol := LectLibCol('CC', 'BLI', Libcol, 'CC_LIBRE');
      if LibCol = '' then
         begin
         Lasterror := 4+i;
         AfficheErreur(ecran.Name, IntToStr(4+i),'Paramètre du Planning');
         SetActiveTabSheet('PGENERAL');
         SetFocusControl('HPP_LIBCOL' + IntToStr(i));
         exit;
         end;
      end;

  For i:=1 To GetField('HPP_NBCOLDIVERS') Do
      Begin
      LibCol := LectLibCol('CC','BLI', GetControlText('HPP_LIBCOLENT' + IntToStr(I+3)), 'CC_LIBRE');
      if LibCol = '' then
         begin
         Lasterror := 10+i;
         AfficheErreur(ecran.Name, IntToStr(10+I),'Paramètre du Planning');
         SetActiveTabSheet('PMISEFORME');
         SetFocusControl('HPP_LIBCOLENT' + IntToStr(I+3));
         exit;
         end;
      end;

  //
  SetField('HPP_AXECONTINGENT1', HPP_CONTENUGAPP.Value);
  SetField('HPP_CONTENUHINT', HPP_CONTENUHINT.Value);
  SetField('HPP_CONTENUITEM', HPP_CONTENUITEM.Value);
  //
end;

procedure TOM_HRPARAMPLANNING.OnLoadRecord;
var fonte			: String;

begin

  CodeParam := HPP_MODEPLANNING.value;
  if getField('HPP_AXECONTINGENT1')='' then
  begin
    if not (DS.State in [dsInsert, dsEdit]) then DS.edit; // pour passer DS.state en mode dsEdit
  	SetField('HPP_AXECONTINGENT1','001');
  end;
  GestionParamStandard;

  // Gestion du chargement des listes d'items et de Hint
  ListeItem := RechDom('BTCONTENUITEM',HPP_CONTENUITEM.Value, true);
  ListeHint := RechDom('BTCONTENUHINT',HPP_CONTENUHINT.Value, true);
  ListeGapp	:= RechDom('BTCONTENUGAPP',HPP_CONTENUGAPP.Value, true);

  // Chargement des couleurs dans la fiche
  AfficheCouleur(LFOND, THEdit(GetControl('HPP_COULEURFOND')));
  AfficheCouleur(LSELECTION, THEdit(GetControl('HPP_COULSELECTION')));
  AfficheCouleur(LSAMEDI, THEdit(GetControl('HPP_COULEURSAMEDI')));
  AfficheCouleur(LDIMANCHE, THEdit(GetControl('HPP_COULDIMANCHE')));
  AfficheCouleur(LLUNDI, THEdit(GetControl('HPP_COULLUNDI')));
  AfficheCouleur(LMARDI, THEdit(GetControl('HPP_COULMARDI')));
  AfficheCouleur(LMERCREDI, THEdit(GetControl('HPP_COULMERCREDI')));
  AfficheCouleur(LJEUDI, THEdit(GetControl('HPP_COULJEUDI')));
  AfficheCouleur(LVENDREDI, THEdit(GetControl('HPP_COULVENDREDI')));
  AfficheCouleur(LJFERIE, THEdit(GetControl('HPP_COULJFERIE')));
  AfficheCouleur(LVEILJFERIE, THEdit(GetControl('HPP_COULVEILJF')));

  // Chargement de la fonte dans la fiche
  fonte := GetField('HPP_FONTCOLONNE');
  LFonte.font.name := fonte;

  HEUREDEBUT.Text := FormatDateTime('hh:mm', Getfield('HPP_HEUREDEBUT'));
  HEUREFIN.Text := FormatDateTime('hh:mm', Getfield('HPP_HEUREFIN'));

  HPP_NBLIGDIVERS.Text := GetField('HPP_NBLIGDIVERS');
  HPP_NBCOLDIVERS.Text := GetField('HPP_NBCOLDIVERS');

  SetControlEnabled('BFONTE', true);
  SetControlEnabled('BFOND', true);
  SetControlEnabled('BSELECTION', true);
  SetControlEnabled('BAPERCU', True);
  SetControlEnabled('HPP_AFFDATEGROUP', true);
  SetControlEnabled('HPP_AFFICHEICONE', true);
  SetControlEnabled('HPP_MOUSE', true);
  SetControlEnabled('HPP_FORMEGRAPHIQUE', true);
  SetControlEnabled('HPP_MOVEHORIZONTAL', True);
  SetControlVisible('THPP_NOMBRELIGDIVERS', True);
  SetControlVisible('HPP_NOMBRELIGDIVERS', true);
  SetControlEnabled('HPP_VISULIGNETO', True);

  AncValNbCol := GetField('HPP_NBCOLDIVERS');
  AncValNbLig := GetField('HPP_NBLIGDIVERS');

end;

procedure TOM_HRPARAMPLANNING.GestionParamStandard;
Var Q					: TQuery;
	  StSQL 		: string;
Begin

  //Rajout du script de la fiche...
  //HPP_PLANNINGTYPEET_OnExit(HPP_PLANNINGTYPEET);
  //HPP_PLANNINGTYPETD_OnExit(HPP_PLANNINGTYPETD);

  //HPP_MODEPLANNING.Value := CodeParam;

  if CodeParam = 'PLA' then
     Begin
     SetControlVisible('HPP_PLANNINGTYPETD',True);
     SetControlVisible('HPP_VISUTYPERES',True);
     SetControlVisible('THPP_ABREGE',True);
     SetControlVisible('HPP_ABREGE',True);
     end
  Else
     Begin
     SetField('HPP_VISUTYPERES', '-');
     SetControlVisible('HPP_PLANNINGTYPETD',False);
     SetControlVisible('THPP_ABREGE',False);
     SetControlVisible('HPP_ABREGE',False);
     SetControlVisible('HPP_VISUTYPERES',False);
     if CodeParam = 'PTA' then
        SetControlVisible('HPP_PLANNINGTYPETD',True);
     end;

  // Gestion planning par defaut
  //Controle si un planning par defaut existe déjà pour ce type de planning...
  SetControlEnabled('HPP_PLANNINGDEFAUT', True);

  StSQL := 'Select HPP_PLANNINGDEFAUT from HRPARAMPLANNING where HPP_PLANNINGDEFAUT="X"';
  StSQL := StSQL + 'AND HPP_MODEPLANNING="' + HPP_MODEPLANNING.Value + '"';
  if ExisteSQL(StSQL) then
     SetControlEnabled('HPP_PLANNINGDEFAUT', False)
  else
     SetControlEnabled('HPP_PLANNINGDEFAUT', True);
  //
  if GetField('HPP_PLANNINGDEFAUT') = '-' then
     SetControlEnabled('BDELETE', True)
  else
     SetControlEnabled('BDELETE', False);

  //Chargement du Cadencement en fonction de la famille de Planning
  Cadencement := '' ;
  if Getfield('HPP_FAMRES') <> '' then
     begin
     StSQL := 'SELECT HFR_RYTHMEGESTION FROM HRFAMRES WHERE HFR_FAMRES="' + Getfield('HPP_FAMRES') + '"';
     Q := OpenSQL(StSQL, True);
     if not Q.EOF then
        Cadencement := Q.FindField('HFR_RYTHMEGESTION').asString;
     Ferme(Q);
     end;

  if Cadencement <> '' then
     begin
     //SetField('HPP_CADENCEMENT', Cadencement);
     THValComboBox(GetControl('HPP_CADENCEMENT')).Value := Cadencement;
     if (GetField('HPP_CADENCEMENT') = '001') Or
        (GetField('HPP_CADENCEMENT') = '002') Or
        (GetField('HPP_CADENCEMENT') = '003') then
        begin
        HEUREDEBUT.Visible := True;
        HEUREFIN.Visible := True;
        SetControlVisible('THPP_HEUREDEBUT', True);
        SetControlVisible('THPP_HEUREFIN', True);
        HEUREDEBUT.Text := FormatDateTime('hh:mm', GetParamSocSecur('SO_HEUREDEB', '00:00'));
        HEUREFIN.Text := FormatDateTime('hh:mm', GetParamSocSecur('SO_HEUREFIN', '00:00'));
        THLabel(GetControl('THPP_FORMATDATECOL0')).Caption := 'Format d''heure';
        end;
     end
  else
     begin
     HEUREDEBUT.Visible := False;
     HEUREFIN.Visible := False;
     SetControlVisible('THPP_HEUREDEBUT', False);
     SetControlVisible('THPP_HEUREFIN', False);
     HeureDebut.Text := FormatDateTime('hh:mm', StrToTime('00:00'));
     HeureFin.Text := FormatDateTime('hh:mm', StrToTime('00:00'));
     end;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Guillaume Fontana
Créé le ...... : 25/07/2000
Modifié le ... : 03/10/2000
Description .. : Recupere le format de la date (ex :dd/mm/yyyy)
Suite ........ : Lit le champ CC_LIBELLE de  la tablette HRFORMATDATE
Suite ........ : partir du champ  CC_CODE passé par paramètre.
Mots clefs ... : FORMAT;DATE;FORMATDATE
*****************************************************************}

function ScriptRecupFormatDate(parms: array of variant; nb: integer): variant;
var QFormatDate: TQuery;
begin
  QFormatDate := OpenSQL('Select CC_LIBELLE from CHOIXCOD where CC_CODE="' + parms[1] + '" and CO_TYPE="HFD"', True);
  Result := QFormatDate.Fields[0].AsString;
  Ferme(QFormatDate);
end;

{***********A.G.L.***********************************************
Auteur  ...... : Guillaume Fontana
Créé le ...... : 25/07/2000
Modifié le ... : 03/10/2000
Description .. : Recupère le libellé de la famille en fonction du code famille
Suite ........ : passé en paramètre
Mots clefs ... : FAMILLE
*****************************************************************}

function ScriptRecupFamille(parms: array of variant; nb: integer): variant;
var QFamille: TQuery;
begin
  QFamille := OpenSQL('Select HFR_LIBELLE from HRFAMRES where HFR_FAMRES="' + parms[1] + '"', True);
  Result := QFamille.Fields[0].AsString;
  Ferme(QFamille);
end;

function ScriptTesterSurbook(parms: array of variant; nb: integer): variant;
var F: TForm;
  Famille: string;
  QFamille: TQuery;
begin
  result := false;
  F := TForm(Longint(Parms[0]));
  Famille := TEdit(F.FindComponent('HPP_FAMRES')).Text;
  Qfamille := OpenSQL('Select HFR_SURBOOKTYPRES,HFR_SURBOOKRESS from HRFAMRES where HFR_FAMRES="' + Famille + '"', True);
  if (Qfamille.FindField('HFR_SURBOOKTYPRES').AsString = 'X') or (Qfamille.FindField('HFR_SURBOOKRESS').AsString = 'X') then
  begin
    result := True;
  end;
  if Qfamille <> nil then Ferme(QFamille);
end;

procedure ScriptActiverOnglet(parms: array of variant; nb: integer);
var F: TForm;
begin
  F := TForm(Longint(Parms[0]));
  TPageControl(F.FindComponent(Parms[1])).ActivePage := TTabSheet(F.FindComponent(Parms[2]));
end;

function ScriptRadioGroupValue(parms: array of variant; nb: integer): variant;
var F: TForm;
begin
  F := TForm(Longint(Parms[0]));
  Result := TDBRadioGroup(F.FindComponent(Parms[1])).Value;
end;

procedure InitPlanning;
begin
  RegisterAglFunc('RecupFormatDate', True, 1, ScriptRecupFormatDate);
  RegisterAglFunc('RecupFamille', True, 1, ScriptRecupFamille);
  RegisterAglProc('ActiverOnglet', True, 2, ScriptActiverOnglet);
  RegisterAglFunc('RadioGroupValue', True, 1, ScriptRadioGroupValue);
  RegisterAglFunc('TesterSurbook', True, 0, ScriptTesterSurbook);
end;

procedure TOM_HRPARAMPLANNING.Duplication(CleDuplic: string);
var TobForm				: TOB;
    i						: integer;
    HrParamPlanning	: string;
    CC					: Tcontrol;
    CC_RO				: Boolean;
begin

  TobForm := TOB.Create('HRPARAMPLANNING', nil, -1);

  if TobForm = nil then exit;

  if CleDuplic = '' then
     begin
     HrParamPlanning := GetControlText('HPP_PARAMPLANNING');
     If (DS.State <> dsInsert) then TFFiche(Ecran).Bouge(NbInsert);
     if not TobForm.SelectDB('"' + HrParamPlanning + '"', nil) then HrParamPlanning := '';
     end;

  if HrParamPlanning <> '' then
     begin
     for i := 1 to TobForm.NbChamps do
         begin
         CC := TControl(Ecran.findcomponent(TobForm.GetNomChamp(i)));
         {$IFDEF EAGLCLIENT}
         CC_RO := ((CC is TEdit) and (TEdit(CC).ReadOnly));
         {$ELSE}
         CC_RO := (((CC is TEdit) and (TEdit(CC).ReadOnly)) or ((CC is TDBEdit) and (TDBEdit(CC).ReadOnly)));
         {$ENDIF}
         if (CC <> nil) and (not CC_RO) then SetField(TobForm.GetNomChamp(i), TobForm.GetValeur(i));
         if (TobForm.GetNomChamp(i) = 'HPP_PARAMPLANNING') then SetField(TobForm.GetNomChamp(i), '');
         if (TobForm.GetNomChamp(i) = 'HPP_PLANNINGDEFAUT') then SetField(TobForm.GetNomChamp(i), '-');
         end;
     SetControlEnabled('HPP_PARAMPLANNING', True);
     end;

  TobForm.Free;

  SetActiveTabSheet(TFFiche(Ecran).pages.Pages[0].name);

  OnLoadRecord;

  SetFocusControl('HPP_PARAMPLANNING');

end;

procedure TOM_HRPARAMPLANNING.HPP_PLANNINGTYPEET_OnExit(Sender: TObject);
begin

  IF HPP_PLANNINGTYPEET.checked Then
     begin
     SetControlVisible('HPP_LIBCOL4',true);
     SetControlVisible('TTHPP_LIBCOL4',true);
     end
  else
		 begin
     SetControlVisible('HPP_LIBCOL4',false);
     SetControlVisible('TTHPP_LIBCOL4',false);
	   end;

end;

procedure TOM_HRPARAMPLANNING.HPP_PLANNINGTYPETD_OnExit(Sender: TObject);
begin

  {IF HPP_PLANNINGTYPETD.checked Then
     begin
     SetControlVisible('HPP_LIBCOL5',true);
     SetControlVisible('TTHPP_LIBCOL5',true);
     end
  else
     begin
     SetControlVisible('HPP_LIBCOL5',false);
     SetControlVisible('TTHPP_LIBCOL5',false);
     end;}

end;

procedure TOM_HRPARAMPLANNING.HPP_FAMRES_OnChange(Sender: TObject);
Var QQ	: TQuery;
    Req	: String;
begin

	Req := 'SELECT HFR_RYTHMEGESTION FROM HRFAMRES ';
  Req := Req + 'WHERE HFR_FAMRES="' + HPP_FAMRES.Value  + '"';

  QQ := OpenSQL(req, True);

  if Not QQ.EOF then
     SetField('HPP_CADENCEMENT',QQ.FindField('HFR_RYTHMEGESTION').asString);

  ferme(QQ);

  if (GetControlText('HPP_CADENCEMENT') = '001') Or
  	 (GetControlText('HPP_CADENCEMENT') = '002') Or
  	 (GetControlText('HPP_CADENCEMENT') = '003') then
     begin
     HEUREDEBUT.Visible := True;
     HEUREFIN.Visible := True;
     HEUREDEBUT.Text := FormatDateTime('hh:mm', GetParamSocSecur('SO_HEUREDEB', '00:00'));
     HEUREFIN.Text := FormatDateTime('hh:mm', GetParamSocSecur('SO_HEUREFIN', '00:00'));
     SetControlVisible('THPP_HEUREDEBUT', True);
     SetControlVisible('THPP_HEUREFIN', True);
     SetControlCaption('THPP_FORMATDATECOL0','Format d''heure');
     end
  else
     begin
     HEUREDEBUT.Visible := False;
     HEUREFIN.Visible := False;
     HEUREDEBUT.Text := FormatDateTime('hh:mm', StrToTime('00:00'));
     HEUREFIN.Text := FormatDateTime('hh:mm', StrToTime('00:00'));
     SetControlVisible('THPP_HEUREDEBUT', False);
     SetControlVisible('THPP_HEUREFIN', False);
     end;

end;

procedure TOM_HRPARAMPLANNING.HPP_CONTENUITEM_OnChange(Sender: TObject);
Begin

	ListeItem := RechDom('BTCONTENUITEM',HPP_CONTENUITEM.Value, true);

	If ListeItem <> '' then BPARAMITEM.Visible := true

end;

procedure TOM_HRPARAMPLANNING.HPP_CONTENUHINT_OnChange(Sender: TObject);
begin

	ListeHint := RechDom('BTCONTENUHINT',HPP_CONTENUHINT.Value, true);

  If ListeHint <> '' then BPARAMHINT.Visible := true

end;

procedure TOM_HRPARAMPLANNING.HPP_CONTENUGAPP_OnChange(Sender: TObject);
Begin

	ListeGapp := RechDom('BTCONTENUGAPP',HPP_CONTENUGAPP.Value, true);

	If ListeGapp <> '' then BPARAMGAPP.Visible := true

end;

procedure TOM_HRPARAMPLANNING.BPARAMITEM_OnClick(Sender: TObject);
begin

  {$IFDEF EAGLCLIENT}
  ParamListe(ListeItem, nil, '');
  {$ELSE}
  ParamListe(ListeItem, nil, nil, '');
  {$ENDIF}

end;

procedure TOM_HRPARAMPLANNING.BPARAMHINT_OnClick(Sender: TObject);
begin

  {$IFDEF EAGLCLIENT}
  ParamListe(ListeHint, nil, '');
  {$ELSE}
  ParamListe(ListeHint, nil, nil, '');
  {$ENDIF}

end;

procedure TOM_HRPARAMPLANNING.BPARAMGAPP_OnClick(Sender: TObject);
begin

  {$IFDEF EAGLCLIENT}
  ParamListe(ListeGapp, nil, '');
  {$ELSE}
  ParamListe(ListeGapp, nil, nil, '');
  {$ENDIF}

end;

procedure TOM_HRPARAMPLANNING.BFond_OnClick(Sender: TObject);
begin

  SelColorNew(LFOND,THEdit(GetControl('HPP_COULEURFOND')), TForm(Ecran));

end;

procedure TOM_HRPARAMPLANNING.BSELECTION_OnClick(Sender: TObject);
begin

  SelColorNew(LSELECTION,THEdit(GetControl('HPP_COULSELECTION')), TForm(Ecran));

end;

procedure TOM_HRPARAMPLANNING.BCOULEURDIMANCHE_OnClick(Sender: TObject);
begin

  SelColorNew(LDIMANCHE,THEdit(GetControl('HPP_COULDIMANCHE')), TForm(Ecran));

end;

procedure TOM_HRPARAMPLANNING.BCOULEURJEUDI_OnClick(Sender: TObject);
begin

  SelColorNew(LJEUDI,THEdit(GetControl('HPP_COULJEUDI')), TForm(Ecran));

end;

procedure TOM_HRPARAMPLANNING.BCOULEURLUNDI_OnClick(Sender: TObject);
begin

  SelColorNew(LLUNDI,THEdit(GetControl('HPP_COULLUNDI')), TForm(Ecran));

end;

procedure TOM_HRPARAMPLANNING.BCOULEURMARDI_OnClick(Sender: TObject);
begin

  SelColorNew(LMARDI,THEdit(GetControl('HPP_COULMARDI')), TForm(Ecran));

end;

procedure TOM_HRPARAMPLANNING.BCOULEURMERCREDI_OnClick(Sender: TObject);
begin

  SelColorNew(LMERCREDI,THEdit(GetControl('HPP_COULMERCREDI')), TForm(Ecran));

end;

procedure TOM_HRPARAMPLANNING.BCOULEURSAMEDI_OnClick(Sender: TObject);
begin

  SelColorNew(LSAMEDI,THEdit(GetControl('HPP_COULEURSAMEDI')), TForm(Ecran));

end;

procedure TOM_HRPARAMPLANNING.BCOULEURVENDREDI_OnClick(Sender: TObject);
begin

  SelColorNew(LVENDREDI,THEdit(GetControl('HPP_COULVENDREDI')), TForm(Ecran));

end;

procedure TOM_HRPARAMPLANNING.BCOULEURJFERIE_OnClick(Sender: TObject);
begin

  SelColorNew(LJFERIE,THEdit(GetControl('HPP_COULJFERIE')), TForm(Ecran));

end;

procedure TOM_HRPARAMPLANNING.BCOULEURVEILJFERIE_OnClick(Sender: TObject);
begin

  SelColorNew(LVEILJFERIE,THEdit(GetControl('HPP_COULVEILJF')), TForm(Ecran));

end;

procedure TOM_HRPARAMPLANNING.BFONTE_OnClick(Sender: TObject);
begin

	SelFonteNew(LFONTE, THEdit(GetControl('HPP_FONTCOLONNE')), TForm(Ecran));

end;

procedure TOM_HRPARAMPLANNING.BAPERCU_OnClick(Sender: TObject);
var TobModele: TOB;
begin

  TobModele := TOB.Create('HRPARAMPLANNING', nil, -1);

  TobModele.GetEcran(ecran); //.GetEcran(F);
  TheTob := TobModele;

  AglLancefiche('BTP', 'BTPLANNINGEX', '', '', '');

  TobModele.free;

end;

procedure TOM_HRPARAMPLANNING.BDUPLICATION_OnClick(Sender: TObject);
Begin

	Duplication('');

End;

procedure TOM_HRPARAMPLANNING.HPP_MODEPLANNING_OnChange(Sender: TObject);
begin

  CodeParam := HPP_MODEPLANNING.Value;

  GestionParamStandard;

end;

procedure TOM_HRPARAMPLANNING.HPP_CADENCEMENT_OnChange(Sender: TObject);
begin

   Cadencement := HPP_CADENCEMENT.Value;

	if (Cadencement = '001') Or
	   (Cadencement = '002') Or
 	   (Cadencement = '003') then
     Begin
     HEUREDEBUT.Visible := True;
     HEUREFIN.Visible := True;
     HEUREDEBUT.Text := FormatDateTime('hh:mm', GetParamSocSecur('SO_HEUREDEB', '00:00'));
     HEUREFIN.Text := FormatDateTime('hh:mm', GetParamSocSecur('SO_HEUREFIN', '00:00'));
     SetControlVisible('THPP_HEUREDEBUT',True);
     SetControlVisible('THPP_HEUREFIN',True);
	   end
   else
     Begin
     HEUREDEBUT.Visible := False;
     HEUREFIN.Visible := False;
     HEUREDEBUT.Text := FormatDateTime('hh:mm', StrToTime('00:00'));
     HEUREFIN.Text := FormatDateTime('hh:mm', StrToTime('00:00'));
     SetControlVisible('THPP_HEUREDEBUT',False);
     SetControlVisible('THPP_HEUREFIN',False);
	  end;

end;

Procedure TOM_HRPARAMPLANNING.HPP_NBCOLDIVERS_OnChange(Sender: TObject);
Var i				: integer;
    Valeur	: Integer;
Begin

  Valeur := StrToInt(HPP_NBCOLDIVERS.Text);

  if Valeur > AncValNbCol then
     Begin
     For i := (AncValNbCol+1) To Valeur do
         Begin
         SetControlProperty('THPP_TAILLECOLENTETE'+ IntToStr(I+3),'Enabled', true);
         SetControlProperty('HPP_TAILLECOLENT' + IntToStr(I+3),'Enabled', true);
         SetControlProperty('THPP_LIBCOL' + IntToStr(I+3),'Enabled', true);
         SetControlProperty('HPP_LIBCOLENT' + IntToStr(I+3),'Enabled', True);
         SetField('HPP_TAILLECOLENT' + IntToStr(I+3), 60);
         end;
     end
  else
     Begin
     For i := AncValNbCol DownTo (Valeur+1) Do
         Begin
         SetControlProperty('THPP_TAILLECOLENTETE' + IntToStr(I+3),'Enabled', False);
         SetControlProperty('HPP_TAILLECOLENT' + IntToStr(I+3),'Enabled', False);
         SetControlProperty('THPP_LIBCOL' + IntToStr(I+3),'Enabled', False);
         SetControlProperty('HPP_LIBCOLENT' + IntToStr(I+3),'Enabled', False);
         SetField('HPP_TAILLECOLENT' + IntToStr(I+3), 1);
         SetControlChecked('THHP_LIBCOL' + IntToStr(I+3), False);
         SetField('HPP_COL' + IntToStr(I+3) + 'LIB','...');
         SetField('HPP_LIBCOLENT' + IntToStr(I+3),'');
         End;
     end;

  AncValNbCol := Valeur;

end;

procedure TOM_HRPARAMPLANNING.HPP_NBLIGDIVERS_OnChange(Sender: TObject);
Var i				: integer;
    Valeur	: Integer;
begin

	Valeur := StrToInt(HPP_NBLIGDIVERS.Text);

  if Valeur > AncValNbLig then
     Begin
     For i := (AncValNbLig+1) To Valeur do
         Begin
         SetControlProperty('THPP_TAILLECOLENTETE'+ IntToStr(I),'Enabled', true);
         SetControlProperty('HPP_TAILLECOLENT' + IntToStr(I),'Enabled', true);
         SetControlProperty('HPP_LIBCOL' + IntToStr(I),'Enabled', True);
         SetControlProperty('HPP_REGCOL'+ IntToStr(I),'Enabled', True);
         SetControlProperty('THPP_COL'+ IntToStr(I) + 'LIB','Enabled', True);
         //SetField('HPP_TAILLECOLENT' + IntToStr(I), 60);
         end;
     end
  else
     Begin
     For i := AncValNbLig DownTo (Valeur+1) Do
         Begin
         SetControlProperty('THPP_TAILLECOLENTETE' + IntToStr(I),'Enabled', False);
         SetControlProperty('HPP_TAILLECOLENT' + IntToStr(I),'Enabled', False);
         SetControlProperty('HPP_LIBCOL' + IntToStr(I),'Enabled', False);
         SetControlProperty('HPP_REGCOL'+ IntToStr(I),'Enabled', False);
         SetControlProperty('THPP_COL' + IntToStr(I) + 'LIB','Enabled', False);
         //Reinitialisation des zones de tri
         SetField('HPP_TAILLECOLENT' + IntToStr(I), 0);
         SetField('HPP_LIBCOL' + IntToStr(I),'');
         SetControlChecked('HHP_REGCOL' + IntToStr(I), False);
         SetField('THPP_COL' + IntToStr(I) + 'LIB','...');
         End;
     end;

  AncValNbLig := Valeur;

end;

Procedure TOM_HRPARAMPLANNING.ControleChamp(Champ : String;Valeur : String);
Begin

  if champ = 'MODEPLANNING' then CodeParam := Valeur;

  if Champ = 'ACTION' then
	   Begin
     if Valeur = 'CREATION' Then
     else if Valeur = 'MODIFICATION' then
     else
  end;

end;

Procedure TOM_HRPARAMPLANNING.ControleCritere(Valeur : String);
Begin

end;

initialization
  RegisterClasses([TOM_HRPARAMPLANNING]);
  InitPlanning;
end.
