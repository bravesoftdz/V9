unit PlanUtil;

interface

uses {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  Graphics,
  HPlanning,
  StdCtrls,
  ExtCtrls,
  Controls,
  HCtrls,
  HStatus,
  MsgUtil,
  SysUtils,
  Hent1,
  dialogs,
  HMsgBox,
  HRichOLE,
  Paramsoc,
  HeureUtil,
  uJoursFeries,
	UAFO_Ferie,
  Windows,
  AglMail,
  MailOl,
  UDateUtils,
  UTOB;

type
  THPlanningBTP = Class(THPlanning)
  public
    FamRes          : String; //Famille ressource
    CodeOnglet      : String; //Permet de définir quelles information est dans l'onglet
    TypePlanning    : String; //PSF : Sous-Famille - PTA : Type Action
    AppelsTraites   : Boolean; // Gestion des appels traités ou pas
  end;

  RecordPlanning = record
    TobItems          : TOB;
    TobEtats          : TOB;
    TobRes            : TOB;
    TobCols           : TOB;
    TobRows           : TOB;
    TobEvents         : TOB;
    TobPeriodeDivers  : TOB;
  end;

Procedure AffichageDateHeure(TobTMP : Tob);
procedure AfficheLFixe(P: THPlanningBTP; T: Tob);
Procedure ChargeCadencement(R: RecordPlanning; P: THPlanningBTP; T: TOB);
Procedure ChargementEtat(var R: RecordPlanning; var P: THPlanningBTP; T: TOB; DateEnCours: TDateTime; ModeGestionPlanning: Boolean);
procedure ChargeEvent(var R: RecordPlanning; var P: THPlanningBTP);

Function ChargeRequeteEventMat    (P : THPlanningBTP; DateDebut, DateFin : TdateTime) : String;
Function ChargeRequeteFamilleMat  (P : THPlanningBTP; DateDebut, DateFin : TdateTime) : String;
Function ChargeRequeteTypeAction  (P : THPlanningBTP; DateDebut, DateFin : TdateTime) : String;
Function ChargeRequeteIntervention(P : THPlanningBTP; DateDebut, DateFin : TdateTime) : String;

procedure ChargeItemPlanning(var R: RecordPlanning; var P: THPlanningBTP; T: TOB; DateEnCours: TDateTime; TableEvent : String);
procedure ChargeItemPlanningSelectif(var R: RecordPlanning; var P: THPlanningBTP; T: TOB; var Item: tob; Mode: Integer);
Procedure ChargementTobItem(TobTmp : Tob);

procedure ChargeEventMatInEvenPlan (R :RecordPlanning;P :THPlanningBTP;DateDebut,DateFin : TdateTime);
procedure ChargeItemMaterielSelectif(var R: RecordPlanning; Var P: THPlanningBTP; T: TOB; var Item: Tob; Mode: Integer);
Procedure ChargementTobItemParc(TobTmp : Tob);

procedure ChargeParamPlanning(var R: RecordPlanning; var P: THPlanningBTP; T: TOB; DateEnCours: TDateTime; ModegestionPlanning: Boolean);
procedure CompleteRequete(var Requete: string; ListeChamps: string);
Procedure ControleCadencement(Cadencement : String;R: RecordPlanning;P: THPlanningBTP; T : TOB);

function  DeleteEvenementMateriel (CodeMateriel : string; NumEventMat : integer) : boolean;

procedure MajParamplanning;
procedure RecupChamps(var ListeChamps: array of string; iTable: integer);
procedure TobFree(var T: TOB);

function AffecteDataType(NomChamp: string): string;
function AnalyseChamp(Tobligne: TOB; ListeChamps: string; Formats: string): string;
Function ChargeFamres : String;
Function ChargeFamMat : String;
Function ChargeSQLPla(TypRes : String; var P: THPlanningBTP) : String;
Function ChargeSQLSpe(TypRes : String; var P: THPlanningBTP) : String;
function ChargeStrByTablette(CodeTablette,ZoneARecuperer: String): String;
function LibelleChamp(CodeTablette: string): string;
//function MajItem(Liste: string; var Format: string; ZoneARecup : String): string;
function TabletteAssociee(NomTable: string): string;
procedure CalculDureeEvenementRess(TOBCalenDar,TOBParamPlanning: TOB;var DateDeb,DateFin : double; var HeureDeb,HeureFin : double);
function GestionDateFinPourModif (DateDeFin : TdateTime) : TdateTime;
function GestionDateFinPourEnreg (DateDeFin : TdateTime) : TdateTime;
function CalculDateDebut (DateDebut : TdateTime) : TdateTime;
function CalculDateFin (DateFin : TdateTime) : TdateTime; Overload

function IsModifiable(Item: TOB): boolean;

function ControleHoraires (var DateDebEvt,DateFinEvt : TdateTime; ModeOption: string; Duree : double; CodeRessource : string) : boolean;
function LibelleDuree (NbMinutes : double; withLibDuree : boolean=true) : string;
function GetDescriptifCourt ( TOBD : TOB) : string;
procedure ChargeActionsGRCDetail (TOBdetailAction : TOB;DateDebut,DateFin:TdateTime;
																	AppelsTraites: boolean;Auxiliaire : string;
                                  NumAction : integer);
procedure TransformeActionsEnItem (TOBAct: TOB;R :RecordPlanning); overload;
procedure TransformeActionsEnItem (TOBAct ,TOBevt : TOB; P: THplanningBTP); overload;
procedure TransformeEventMatEnItem(TOBItem, TOBEvt : TOB);

function  UpdateActionGRC (Auxiliaire : string; NumAction : integer; DateDebut,DateFin:TdateTime): boolean;
function  DeleteActionGRC (Auxiliaire : string; NumAction : integer) : boolean;

procedure EnvoieEltEmailFromGRC (Auxiliaire: string;NumAction: integer; TypeEnvoie : string; NewDate : TdateTime;newdelai : integer; InfoFrom : boolean=false);
procedure EnvoieEltEmailFromAction ( TOBElt : TOB; TypeEnvoie : string; NewDate : TdateTime;newdelai : integer; InfoFrom : boolean=false; NewRess : string='');
procedure EnvoieEmailFromIntervention ( TOBElt : TOB; Requete : string; TypeEnvoie : string; NewDate : TdateTime;newdelai : integer; InfoFrom : boolean=false; NewRess : string='');

var

  ModeSaisie: Boolean = True; // True On peut travailler, False on consulte
  NumLigneTO: Integer;
  NumYield: Integer;

  GestAffiche   : AffGrille;

  TobParametres : Tob;

  Cadencement: string;

implementation

uses  uBtpEtatPlanning ,
      DateUtils,
      TntClasses,
      Classes,
      UtilsParc,
      DB;

var
  ContenuItem: string;
  FormatItem: string;
  ContenuHint: string;
  FormatHint: string;

procedure TobFree(var T: TOB);
begin
  if T <> nil then
  begin
    T.Free;
    T := nil;
  end;
end;


procedure ChargeParamPlanning(var R: RecordPlanning; var P: THPlanningBTP; T: TOB; DateEnCours: TDateTime; ModeGestionPlanning: Boolean);
var
  // TobResFille: array of tob;
  NomDuChamp  : array[1..9] of string;
  LibDuChamp  : array[1..9] of string;
  TypeDuChamp : array[1..9] of string;
  TailleChamp : array[1..9] of Integer;
  //ModeDuChamp : array[1..9] of Boolean;
  Formegraphique: Variant;
  SQL         : string;
  Req         : string;
  //LibFamRes   : string;
  TypRes      : String;
  // TmpIcone: string;
  NomHpp      : string;
  //PeriodeDebut: string;
  //PeriodeFin  : string;
  //MaValeur    : string;
  StrTempo    : String;
  ZoneRes     : String;
  LibZone     : String;
  // QNbTypres: TQuery;
  //QRecupFamRes: TQuery;
  QRessource  : TQuery;
  //QTypeRes    : TQuery;
  QEtats      : TQuery;
  Boucle      : integer;
  //Compteur    : integer;
  I           : integer;
  NbCF        : integer;
  NbCT        : integer;
  Ind         : integer;
  TailleColFixe: Integer;
  IconesExiste: Boolean;
  Regroupement: Boolean;
begin

  If T <> nil then TobParametres := T;

  //Mise à jour des paramètres planning mode Graphique
  MajParamplanning;

  //Remise à zéro des tob Etats et Ressources 
  TobFree(R.TobRes);
  TobFree(R.TobItems);

  NumLigneTO  := -1;
  NumYield    := -1;

  // Barre de patiente
  InitMove(10, 'Chargement du planning en cours');

  //Mise en place de la gestion du surbooking et des Week-end
  with P do
  begin
    SurBooking      := True;
    ActiveSaturday  := True;
    ActiveSunday    := True;
  end;

  // MAJ regroupement de date
  //P.ActiveLigneGroupeDate := TobParametres.Getvalue('HPP_AFFDATEGROUP') = 'X';

  if pos(P.TypePlanning, 'PMA;PFM;PPA') > 0 then
    P.Famres := ChargeFamMat
  else
    P.Famres := ChargeFamRes;

  // Changement date d'un séjour sur planning possible O/N
  P.MoveHorizontal := True;

  // Chargement de la forme graphique
  FormeGraphique := TobParametres.Getvalue('HPP_FORMEGRAPHIQUE');

  if (Formegraphique = 'PGF') then
    P.FormeGraphique := pgFleche
  else if (FormeGraphique = 'PGB') then
    P.FormeGraphique := pgBerceau
  else if (FormeGraphique = 'PGL') then
    P.FormeGraphique := pgLosange
  else if (FormeGraphique = 'PGE') then
    P.FormeGraphique := pgEtoile
  else if (FormeGraphique = 'PGA') then
    P.FormeGraphique := pgRoundRect
  else if (FormeGraphique = 'PGI') then
    P.FormeGraphique := pgBisot
  else if (FormeGraphique = 'PGR') then
    P.FormeGraphique := pgRectangle
  else
    P.FormeGraphique := pgFleche;

  //Cadencement
  ChargeCadencement(R, P, T);

  MoveCur(FALSE);

  // Gestion des couleurs du planning
  P.ColorSelection := StringToColor(T.Getvalue('HPP_COULSELECTION'));
  P.ColorBackground := StringToColor(T.Getvalue('HPP_COULEURFOND'));
  if T.Getvalue('HPP_COULEURSAMEDI') <> '' then
    P.ColorOfSaturday := StringToColor(T.Getvalue('HPP_COULEURSAMEDI'));
  if T.Getvalue('HPP_COULDIMANCHE') <> '' then
    P.ColorOfSunday := StringToColor(T.Getvalue('HPP_COULDIMANCHE'));
  if T.Getvalue('HPP_COULLUNDI') <> '' then
    P.ColorOfMonday := StringToColor(T.Getvalue('HPP_COULLUNDI'));
  if T.Getvalue('HPP_COULMARDI') <> '' then
    P.ColorOfTuesday := StringToColor(T.Getvalue('HPP_COULMARDI'));
  if T.Getvalue('HPP_COULMERCREDI') <> '' then
    P.ColorOfWednesday := StringToColor(T.Getvalue('HPP_COULMERCREDI'));
  if T.Getvalue('HPP_COULJEUDI') <> '' then
    P.ColorOfThuesday := StringToColor(T.Getvalue('HPP_COULJEUDI'));
  if T.Getvalue('HPP_COULVENDREDI') <> '' then
    P.ColorOfFriday := StringToColor(T.Getvalue('HPP_COULVENDREDI'));
  if T.Getvalue('HPP_COULVEILJF') <> '' then
  begin
    P.ColorVeilleJoursFeries := StringToColor(T.Getvalue('HPP_COULVEILJF'));
    P.GestionVeilleJoursFeries := True;
  end;
  if T.Getvalue('HPP_COULJFERIE') <> '' then
  begin
    P.ColorJoursFeries := StringToColor(T.Getvalue('HPP_COULJFERIE'));
    P.GestionJoursFeriesActive := True;
  end;

  //Lignes du planning
  if pos(P.TypePlanning, 'PMA;PFM;PPA') > 0 then
    P.RowFieldID      := 'R_CODEMATERIEL'
  else
    P.RowFieldID      := 'R_RESSOURCE';

  P.RowFieldReadOnly  := 'R_RO';
  P.RowFieldColor     := 'R_COLOR';

  MoveCur(FALSE);

  // MAJ de la police des colonnes
  P.FontNameColRowFixed := T.Getvalue('HPP_FONTCOLONNE');

  // Encadrement
  P.FrameOn := True;

  // Champ des items
  if pos(P.TypePlanning, 'PMA;PFM;PPA') > 0 then
  begin
    P.ChampdateDebut  := 'BEM_DATEDEB';
    P.ChampDateFin    := 'BEM_DATEFIN';
    P.MultiLine       := False;
    P.ChampLibelle    := 'LIBELLE';
  end
  else
  begin
    P.ChampdateDebut  := 'BEP_DATEDEB';
    P.ChampDateFin    := 'BEP_DATEFIN';
    P.MultiLine       := False;
    P.ChampLibelle    := 'LIBELLE';
  end;

  if T.Getvalue('HPP_CONTENUITEM') = '' then
  begin
    ContenuItem := 'BEP_BTETAT;("#13#10");BEP_DUREE';
    FormatItem := ';';
  end
  else
  begin
    GestAffiche.FormatGapp := '';
    //ContenuItem := MajItem(RechDom('BTCONTENUITEM', T.Getvalue('HPP_CONTENUITEM'), true), FormatItem,'C');
    ContenuItem := MajItem(RechDom('BTCONTENUITEM', T.Getvalue('HPP_CONTENUITEM'), true), GestAffiche,'C');
    FormatItem := GestAffiche.FormatGapp;
    // item avec un retour chariot à l'intérieur
    if pos('#13#10', contenuitem) <> 0 then P.MultiLine := True;
    if ContenuItem = '' then
    begin
     ContenuItem := 'BEP_BTETAT;("#13#10");BEP_DUREE';
     FormatItem := ';';
    end;
  end;

  if T.Getvalue('HPP_CONTENUHINT') = '' then
  Begin
    ContenuHint := 'BTA_ABREGE;BTA_DUREEMINI';
    FormatHint := '$;;$;;';
  end
  else
  Begin
    FormatHint := '';
    ContenuHint := MajItem(RechDom('BTCONTENUHINT', T.Getvalue('HPP_CONTENUHINT'), true), GestAffiche, 'C');
    FormatHint := GestAffiche.FormatGapp;
    If Contenuhint = '' then
    begin
      ContenuHint := 'BTA_ABREGE;BTA_DUREEMINI';
      FormatHint := '$;;$;;';
    end;
  end;

  // Champ des Type Actions
  P.EtatChampCode             := 'BTA_BTETAT';
  P.EtatChampLibelle          := 'BTA_LIBELLE';
  P.EtatChampBackGroundColor  := 'BTA_COULEURFOND';
  P.EtatChampFontColor        := 'BTA_COULEUR';
  P.EtatChampFontName         := 'BTA_FONTE';
  P.EtatChampFontSize         := 'BTA_FONTESIZE';
  P.EtatChampFontStyle        := 'BTA_FONTESTYLE';
  P.EtatChampIcone            := 'BTA_NUMEROICONE';
  
  MoveCur(FALSE);

  // Gestion des évenements (Salons, concert, ...)
  P.ChampCodeEvenement        := 'HEV_EVENEMENT';
  P.ChampLibelleEvenement     := 'HEV_LIBELLE';
  P.ChampDateDebutEvenement   := 'HEV_DATEDEBUT';
  P.ChampDateDeFinEvenement   := 'HEV_DATEFIN';
  P.ChampCouleurEvenement     := 'HEV_COULEUR';
  P.ChampStyleEvenement       := 'HEV_STYLE';

  MoveCur(FALSE);

  // Activation bulles d'aide
  P.ShowHint := ModegestionPlanning;

  // Ordre de tri des colonnes.
  NbCF := T.getinteger('HPP_NBCOLDIVERS');

  //Gestion des Sous-TypeRessource
  TypRes := T.getvalue('HPP_PLANNINGTYPETD');

  if (P.TypePlanning = 'PLA') Or (P.TypePlanning = 'PMA') then
    Req := ChargeSQLPla(TypRes, P)
  else
    Req := ChargeSQLSpe(TypRes, P);

  QRessource := OpenSQL(req, True,-1,'',true);
  R.TobRes := Tob.Create('THE RESSOURCES', nil, -1);
  R.TobRes.LoadDetailDB('', '', '', Qressource, True);
  ferme(Qressource);

  IconesExiste := False;

  if R.TobRes.Detail.Count = 0 then
  begin
    AfficheErreur('BTPLANNINGEX', '1', 'Chargement du Planning');
    Exit;
  end;

  MoveCur(FALSE);

  ind := 0;

  //Affichage du libellé pour un tri par sous famille ressource en fonction parametrage Planning
  if TypRes = 'X' then
  Begin
    NomDuChamp[1]  := 'BTR_LIBELLE';
    LibDuChamp[1]  := 'Sous-Type Res.';
    TypeduChamp[1] := 'VARCHAR(35)';
    TailleChamp[1] := 100;
    Ind := 1;
  end;

  // Récupératon des libéllés des champs pour les colonnes d'entete
  for boucle := 1 to NbCf do
  begin
    StrTempo := '';
    NomHpp := 'HPP_LIBCOLENT';
    //
    if pos(P.TypePlanning, 'PMA;PFM;PPA') > 0 then
    begin
      ZoneRes := LectLibCol('CC', 'BMA', T.getvalue(NomHpp + IntToStr(Boucle + 3)), 'CC_LIBRE');
      LibZone := LectLibCol('CC', 'BMA', T.Getvalue(NomHpp + IntToStr(Boucle + 3)), 'CC_LIBELLE');
    end
    else
    begin
      ZoneRes := LectLibCol('CC', 'BLI', T.getvalue(NomHpp + IntToStr(Boucle + 3)), 'CC_LIBRE');
      LibZone := LectLibCol('CC', 'BLI', T.Getvalue(NomHpp + IntToStr(Boucle + 3)), 'CC_LIBELLE');
    end;
    //
    TailleColFixe := StrToInt(format('%2.2d', [Integer(T.Getvalue('HPP_TAILLECOLENT' + IntToStr(Boucle+3)))]));
    //
    for i := 1 to Boucle do
    Begin
      StrTempo := StrTempo + NomDuChamp[i];
    end;
    //
    if pos(ZoneRes, StrTempo) = 0 then
    Begin
      Ind := Ind + 1;
      NomDuChamp[Ind]  := ZoneRes;
      LibDuChamp[Ind]  := LibZone;
      TypeduChamp[Ind] := ChampToType(ZoneRes);
      TailleChamp[Ind] := TailleColFixe;
    end
  end;

  MoveCur(FALSE);

  P.DisplayEnteteColFixed := True;
  P.SortOnColFixed        := True;

  if pos(P.TypePlanning, 'PMA;PFM;PPA') > 0 then
    P.ResChampID := 'BMA_CODEMATERIEL'
  else
    P.ResChampID := 'ARS_RESSOURCE';

  // Initalisation des colonnes d'entete
  for Boucle := 1 to Ind do //NbCf do
  begin
    if Boucle = 1 then
    Begin
      P.TokenFieldColFixed  := NomDuChamp[Boucle];
      P.TokenSizeColFixed   := IntToStr(TailleChamp[Boucle]);
      P.TokenAlignColFixed  := 'C';
      P.TokenFieldColEntete := LibDuChamp[Boucle];
    end
    else
    begin
      P.TokenFieldColFixed  := P.TokenFieldColFixed + ';' + NomDuChamp[Boucle];
      P.TokenSizeColFixed   := P.TokenSizeColFixed + ';' + IntToStr(TailleChamp[Boucle]);
      P.TokenAlignColFixed  := P.TokenAlignColFixed + ';C';
      P.TokenFieldColEntete := P.TokenFieldColEntete + '; ' + LibDuChamp[Boucle];
    end;
  end;

  // la précédente tob des Ressources n'a pas été vidé il faut donc la vider
  P.TobRes := R.TobRes;

  //Chargement des types d'action pour affichage des items
  ChargementEtat(R, P, T, DateEnCours, ModeGestionPlanning);

  MoveCur(FALSE);

  // Icones
  if T.Getvalue('HPP_AFFICHEICONE') = 'X' then P.ChampIcone := 'ICONETYPDOS';

  // MAJ Taille des colonnes largeurs
  P.ColSizeData   := T.Getvalue('HPP_TAILLECOLONNE');
  P.ColSizeEntete := T.Getvalue('HPP_TAILLECOLENTET');

  // MAJ Taille des colonnes largeurs
  P.RowSizeData   := T.Getvalue('HPP_HAUTLIGNEDATA');
  P.RowSizeEntete := T.Getvalue('HPP_HAUTLIGNEENT');

  if pos(P.TypePlanning, 'PMA;PFM;PPA') > 0 then
  Begin
    P.ChampLineID  := 'BEM_CODEMATERIEL';
    P.ChampEtat    := 'BEM_BTETAT';
  end
  else
  Begin
    P.ChampEtat    := 'BEP_BTETAT';
    P.ChampLineID  := 'BEP_RESSOURCE';
  end;

  if (ModegestionPlanning) then P.ChampHint := 'HINT';

  if pos(P.TypePlanning, 'PMA;PFM;PPA') > 0 then
    ChargeItemPlanning(R, P, T, DateEnCours,'BTEVENTMAT' )
  else
    ChargeItemPlanning(R, P, T, DateEnCours,'BTEVENPLAN');

end;

Procedure ControleCadencement(Cadencement : String; R: RecordPlanning; P: THPlanningBTP; T : TOB);
Var StSQL         : String;
    PeriodeDebut  : string;
    PeriodeFin    : string;
    FormatDate    : string;
begin

  PeriodeDebut  := '000';
  PeriodeFin    := '999';

    //Mise à jour du format de la date
  if Cadencement = '001' then
  begin
    P.Interval    := piQuartHeure;
    FormatDate    := T.Getvalue('HPP_FORMATDATECOL0');
    P.DateFormat  := 'hh:mm';
  end
  else if Cadencement = '002' then
  begin
    P.Interval    := piDemiHeure;
    FormatDate    := T.Getvalue('HPP_FORMATDATECOL0');
    P.DateFormat  := 'hh:mm';
  end
  else if (Cadencement = '003') then
  begin
    P.Interval    := piHeure;
    FormatDate    := T.Getvalue('HPP_FORMATDATECOL0');
    P.dateFormat  := 'hh:mm';
  end
  else if (Cadencement = '004') then
  Begin
    P.ActiveLigneGroupeDate := False;
    P.interval := piDemiJour;
  end
  else if (Cadencement = '005') then
  begin
    P.Interval    := piJour;
    FormatDate    := T.Getvalue('HPP_FORMATDATECOL0');
    P.DateFormat  := Rechdom('HRFORMATDATE', FormatDate, True);
  end
  else if (Cadencement = '006') then
  begin
    P.Interval    := piSemaine;
    P.DateFormat  := 'dd/mm/yyyy';
  end
  else if (Cadencement = '007') then
  begin
    P.Interval    := pimois;
    P.DateFormat  := 'mmmmm';
  end
  else if cadencement = '008' then  //Lecture de la tablette Service de CHR (???)
  begin
    P.ActiveLigneGroupeDate := False;
    P.interval              := piDivers;
    if (not assigned(R.TobPeriodeDivers)) then
    begin
      R.TobPeriodeDivers    := TOB.Create('la tob', nil, -1);
      StSQL := 'SELECT * FROM CHOIXCOD WHERE CC_TYPE="HSE" ';
      StSQL := StSQL + '  AND CC_CODE>="' + PeriodeDebut + '"';
      StSQL := StSQL + '  AND CC_CODE<="' + PeriodeFin + '"';
      R.TobPeriodeDivers.LoadDetailFromSQL(StSql);
    end;
    P.TobPeriodeDivers      := R.TobPeriodeDivers;
    P.ChampLibelleDivers    := 'CC_LIBELLE';
    P.ChampNumPeriodeDebut  := 'NUMEROHRPERIODEDEBUT';
    P.ChampNumPeriodeFin    := 'NUMEROHRPERIODEFIN';
  end
  else if cadencement = '009' then
  begin
    P.ActiveLigneGroupeDate := False;
    P.interval              := piNone;
    P.DateFormat            := 'ddd dd/mm' ;
  end;

  if (P.ActiveLigneGroupeDate) then
  begin
    if pos(cadencement,'001;002;003;004') > 0 then
      P.CumulInterval := PciJour
    else if cadencement = '005' then
      P.CumulInterval := pciSemaine
    else if cadencement = '006' then
      P.CumulInterval := pciMois
    else if cadencement = '007' then
      P.CumulInterval := pciTrimestre
    else
      P.CumulInterval := pciNone;
  end;

  if pos(cadencement,'001;002;003;004;005') > 0 then
  begin
    if T.Getvalue('HPP_HEUREDEBUT')=0 then
       P.JourneeDebut := GetParamSoc('SO_HEUREDEB')
    else
       P.JourneeDebut := T.Getvalue('HPP_HEUREDEBUT');
    if T.Getvalue('HPP_HEUREFIN')=0 then
       P.JourneeFin := GetParamSoc('SO_HEUREFIN')
    else
       P.JourneeFin := T.Getvalue('HPP_HEUREFIN');
  end;

end;

//Chargement des informations propres à la famille ressource si planning Standard
Function ChargeFamres : String;
var QRecupFamRes  : Tquery;
    Req           : String;
    LibFamRes     : String;
Begin

  if TobParametres.Getvalue('HPP_VISUTYPERES') = 'X' then
     Result := 'GEN'
  else
     if TobParametres.getvalue('HPP_FAMRES') = '' then
        Result := 'GEN'
     else
        Result := TobParametres.getvalue('HPP_FAMRES');

  //Récupération des information de la famille de Planning
  Req := 'SELECT HFR_LIBELLE,HFR_HRPERIODEDEBUT,HFR_HRPERIODEFIN FROM HRFAMRES ';

  //Modif pour planning Général
  if Result <> 'GEN' then
     Req := Req + 'WHERE HFR_FAMRES="' + Result + '"';

  QRecupFamRes := OpenSQL(Req, True,-1,'',true);

  if not QRecupFamRes.eof then
    begin
    LibFamRes := QRecupFamRes.findfield('HFR_LIBELLE').Asstring;
    //PeriodeDebut := QRecupFamRes.findfield('HFR_HRPERIODEDEBUT').Asstring;
    //PeriodeFin := QRecupFamRes.findfield('HFR_HRPERIODEFIN').Asstring;
    end;
  ferme(QRecupFamRes);

end;

//Chargement des informations propres à la famille Matériel si planning Standard
Function ChargeFamMat : String;
var QRecupFamMat  : Tquery;
    Req           : String;
    LibFamMat     : String;
Begin

  if TobParametres.Getvalue('HPP_VISUTYPERES') = 'X' then
     Result := 'GEN'
  else
  begin
    if TobParametres.getvalue('HPP_FAMRES') = '' then
    begin
      if TobParametres.getvalue('HPP_FAMMATGERE') = '' then
        Result := 'GEN'
      else
        Result := FormatMultiValComboforSQL(TobParametres.getvalue('HPP_FAMMATGERE'));
    end
    else
    begin
      Result :=  TobParametres.getvalue('HPP_FAMRES');
      //Récupération des information de la famille de Planning
      Req := 'SELECT BFM_LIBELLE FROM BTFAMILLEMAT ';
      //Modif pour planning Général
      Req := Req + 'WHERE BFM_CODEFAMILLE ="' + Result + '" AND BFM_NONGEREPLANNING="X"';
      Result := '"' + result + '"';
      QRecupFamMat := OpenSQL(Req, True,-1,'',true);
      if not QRecupFamMat.eof then LibFamMat := QRecupFamMat.findfield('BFM_LIBELLE').Asstring;
      ferme(QRecupFamMat);
    end;
  end;

end;

//Procedure de chargement de la commande SQL si l'on se trouve dans un planning
//de type "STANDARD". On charge en fonction de la famille de ressource et de la
//sous famille si la zone est cochée au niveau des paramètres.
//Cette fonction permet également de déterminé les élèments de tri.
Function ChargeSQLPla(TypRes : String; var P: THPlanningBTP) : String;
Var Req           : String;
    SQL           : String;
    ZoneRes       : String;
    I             : integer;
    NbCT          : integer;
    Ind           : integer;
    Regroupement  : Boolean;
Begin

  NbCT := TobParametres.getinteger('HPP_NBLIGDIVERS') + 1;

  if TypRes = 'X' then NbCT := NbCT+1;

  Result := '';

  if pos(P.TypePlanning, 'PMA;PFM;PPA') > 0 then
  begin
    ZoneRes := ChargeStrByTablette('BMA', 'CC_LIBRE');
    Req := 'SELECT ' + ZoneRes + ' FROM BTMATERIEL ';
    Req := req + 'LEFT JOIN BTFAMILLEMAT ON BMA_CODEFAMILLE=BFM_CODEFAMILLE ';
    //Gestion des conditions de selection des enregistrement
    Req := Req + ' WHERE BMA_FERME="-" ';
    if P.Famres <> 'GEN' then Req := Req + 'AND BMA_CODEFAMILLE IN (' + p.FamRes + ')';
    Req := Req + ' AND BFM_NONGEREPLANNING="X"';
  end
  else
  begin
    ZoneRes := ChargeStrByTablette('BLI', 'CC_LIBRE');
    ZoneRes := ZoneRes + ', ARS_STANDCALEN, ARS_CALENSPECIF';
    //chargement de l'état de la ressource (Type d'action)
    //gestion de la jointure si planning sur sous famille ressource
    if TypRes = 'X' then
    Begin
      Req := 'SELECT ' + ZoneRes + ',BTR_LIBELLE FROM RESSOURCE LEFT JOIN BTTYPERES ON ARS_CHAINEORDO=BTR_TYPRES';
      //Gestion Affichage du sous-type ressource au Planning
      req := Req + ' WHERE ARS_RESSOURCE in ';
      Req := Req + '(SELECT ARS_RESSOURCE FROM RESSOURCE LEFT JOIN BTTYPERES ON ARS_CHAINEORDO=BTR_TYPRES ';
      Req := Req + 'WHERE BTR_GEREPLANNING="X") OR ARS_CHAINEORDO="" AND ';
    end
    else
      Req := 'SELECT ' + ZoneRes + ' FROM RESSOURCE WHERE ';

    //Gestion des conditions de selection des enregistrement
    Req := Req + 'ARS_FERME="-" ';
    if P.Famres <> 'GEN' then Req := Req + 'AND ARS_TYPERESSOURCE="' + p.FamRes + '"';
  end;

  //gestion du tri en fonction des paramètres récupérés au dessus
  I := 1;

  //Tri en fonction des types de ressource associés à la famille de ressource
  SQL := '';
  if TypRes = 'X' then
  Begin
    P.SetLinkColFixed(0, True); //---> voir nouvel AGL
    SQL := 'ARS_CHAINEORDO';
    I := 2
  end;

  //Tri en fonction des paramétrage du client
  for ind := I to NbCT do
  begin
    i := ind;
    //
    if TypRes = 'X' then I := I - 1;
    //
    if TobParametres.GetValue('HPP_REGCOL' + IntToStr(I))= 'X' then
       Regroupement := true
    else
       Regroupement := False;
    //
    if TypRes = 'X' then
       P.SetLinkColFixed(I, Regroupement)
    else
       P.SetLinkColFixed(I-1, Regroupement);
    //
    if pos(P.TypePlanning, 'PMA;PFM;PPA') > 0 then
      ZoneRes := LectLibCol('CC', 'BMA', TobParametres.getvalue('HPP_LIBCOL' + IntToStr(I)), 'CC_LIBRE')
    else
      ZoneRes := LectLibCol('CC', 'BLI', TobParametres.getvalue('HPP_LIBCOL' + IntToStr(I)), 'CC_LIBRE');
    //
    if SQL = '' then
       SQL :=  ZoneRes
    else
    begin
      if ZoneRes <> '' then
      begin
        if Pos(ZoneRes, SQL) = 0 then SQL := SQL + ',' + ZoneRes;
      end;
    end;
  end;

  if (SQL = '') then
  begin
    if (P.TypePlanning ='PMA')       then SQL := 'BMA_CODEMATERIEL'
    else if (P.TypePlanning = 'PMF') then SQL := 'BMA_CODEFAMILLE'
    else if (P.TypePlanning = 'PPA') then SQL := 'BMA_CODEMATERIEL'

    else SQL := 'ARS_RESSOURCE';
  end;

  Req := Req + ' ORDER BY ' + SQL;

  Result := Req;

end;

//Procedure de chargement de la commande SQL si l'on se trouve dans un planning
//de type "SPECIFIQUE". On charge en fonction du mode Planning
//Cette fonction permet également de déterminé les élèments de tri.
Function ChargeSQLSpe(TypRes : String;  var P: THPlanningBTP) : String;
Var Req           : String;
    SQL           : String;
    ZoneRes       : String;
    Condition     : String;
    I             : integer;
    NbCT          : integer;
    Ind           : integer;
    Regroupement  : Boolean;
Begin

  NbCT := TobParametres.getinteger('HPP_NBLIGDIVERS') + 1;

  if TypRes = 'X' then NbCT := NbCT+1;

  Result := '';

  //gestion du tri en fonction des paramètres récupérés au dessus
  I := 1;

  SQL := '';

  //Tri en fonction des types de ressource associés à la famille de ressource
  if TypRes = 'X' then
     Begin
     P.SetLinkColFixed(0, True); //---> voir nouvel AGL
     SQL := 'ARS_CHAINEORDO';
     I := 2
     end;

  //Tri en fonction des paramétrage du client
  for ind := I to NbCT do
  begin
    i := ind;
    if TobParametres.GetValue('HPP_REGCOL' + IntToStr(I))= 'X' then
       Regroupement := True
    else
       Regroupement := False;
    //
    P.SetLinkColFixed(I-1, Regroupement);
    if (P.TypePlanning = 'PFM') then
    begin
      if ind = 1 then SQL := LectLibCol('CC', 'BMA', TobParametres.getvalue('HPP_LIBCOL' + IntToStr(I)), 'CC_LIBRE') else
      if LectLibCol('CC', 'BMA', TobParametres.getvalue('HPP_LIBCOL' + IntToStr(I)), 'CC_LIBRE') <> '' then
         SQL := SQL + ',' + LectLibCol('CC', 'BMA', TobParametres.getvalue('HPP_LIBCOL' + IntToStr(I)),'CC_LIBRE');
      if (SQL = '') then  SQL := 'BMA_CODEMATERIEL';
      //
      ZoneRes := ChargeStrByTablette('BMA', 'CC_LIBRE');
      ZoneRes := ZoneRes + ', ARS_STANDCALEN, ARS_CALENSPECIF';
      Condition := LectLibCol('CO', 'BMP', p.TypePlanning,'CO_LIBRE') + '="' + P.CodeOnglet + '"';
      //
      Result := 'SELECT ' + ZoneRes + ' FROM BTMATERIEL ';
      Result := Result + ' LEFT JOIN BTFAMILLEMAT ON (BMA_CODEFAMILLE=BFM_CODEFAMILLE) ';
      Result := Result + ' LEFT JOIN RESSOURCE    ON (BMA_RESSOURCE=ARS_RESSOURCE) ';
      Result := Result + ' WHERE BMA_CODEFAMILLE' + Condition + ' AND ';
      //Gestion des conditions de selection des enregistrement
      Result := Result + 'BMA_FERME="-" ';
      if (SQL = '') then  SQL := 'BMA_CODEFAMILLE';
      Result := Result + ' ORDER BY ' + SQL;
      Exit;
    end
    else if (P.TypePlanning = 'PPA') then
    begin
      if ind = 1 then SQL := LectLibCol('CC', 'BMA', TobParametres.getvalue('HPP_LIBCOL' + IntToStr(I)), 'CC_LIBRE') else
      if LectLibCol('CC', 'BMA', TobParametres.getvalue('HPP_LIBCOL' + IntToStr(I)), 'CC_LIBRE') <> '' then
         SQL := SQL + ',' + LectLibCol('CC', 'BMA', TobParametres.getvalue('HPP_LIBCOL' + IntToStr(I)),'CC_LIBRE');
      if (SQL = '') then  SQL := 'BMA_CODEMATERIEL';

      ZoneRes := ChargeStrByTablette('BMA', 'CC_LIBRE');
      ZoneRes := ZoneRes + ', ARS_STANDCALEN, ARS_CALENSPECIF';
      Condition := LectLibCol('CO', 'BMP', p.TypePlanning,'CO_LIBRE') + '="' + P.CodeOnglet + '"';
      //lecture
      Result := 'SELECT DISTINCT ' + Zoneres + ' FROM BTMATERIEL ';
      Result := Result + ' LEFT JOIN BTFAMILLEMAT ON (BMA_CODEFAMILLE=BFM_CODEFAMILLE) ';
      Result := Result + ' LEFT JOIN RESSOURCE    ON (BMA_RESSOURCE=ARS_RESSOURCE) ';
      Result := Result + ' LEFT JOIN BTEVENTMAT   ON (BEM_CODEMATERIEL=BMA_CODEMATERIEL) ';
      Result := Result + ' LEFT JOIN BTETAT       ON (BEM_BTETAT=BTA_BTETAT) ';
      Result := Result + ' WHERE BMA_FERME="-" ';
      ///gestion de la famille renseignée au niveau du paramétrage Planning
      if P.Famres <> 'GEN' then Result := Result + 'AND BMA_CODEFAMILLE IN (' + P.FamRes + ') ';
      //
      Result := Result + 'AND BFM_NONGEREPLANNING="X"';
      if (SQL = '') then  SQL := 'BTA_BTETAT';
      Result := Result + ' ORDER BY ' + SQL;
      //
      exit;
    end
    else
    begin
      if ind = 1 then SQL := LectLibCol('CC', 'BLI', TobParametres.getvalue('HPP_LIBCOL' + IntToStr(I)), 'CC_LIBRE') else
      if LectLibCol('CC', 'BLI', TobParametres.getvalue('HPP_LIBCOL' + IntToStr(I)), 'CC_LIBRE') <> '' then
         SQL := SQL + ',' + LectLibCol('CC', 'BLI', TobParametres.getvalue('HPP_LIBCOL' + IntToStr(I)),'CC_LIBRE');
      if (SQL = '') then  SQL := 'ARS_RESSOURCE';

      ZoneRes := ChargeStrByTablette('BLI', 'CC_LIBRE');
      ZoneRes := ZoneRes + ', ARS_STANDCALEN, ARS_CALENSPECIF';
      Condition := LectLibCol('CO', 'BMP', p.TypePlanning,'CO_LIBRE') + '="' + P.CodeOnglet + '"';
    end;
  end;    

  //debut du select en fonction du mode planning
  if p.TypePlanning = 'PSF' then
     Req := 'SELECT ' + ZoneRes + ' FROM RESSOURCE WHERE ' + Condition + ' AND '
  else
     if TypRes = 'X' then
        Begin
        Req := 'SELECT ' + ZoneRes + ',BTR_LIBELLE FROM RESSOURCE LEFT JOIN BTTYPERES ON ARS_CHAINEORDO=BTR_TYPRES';
        //Gestion Affichage du sous-type ressource au Planning
        Req := Req + ' WHERE ARS_RESSOURCE in ';
        Req := Req + '(SELECT ARS_RESSOURCE FROM RESSOURCE LEFT JOIN BTTYPERES ON ARS_CHAINEORDO=BTR_TYPRES ';
        Req := Req + 'WHERE BTR_GEREPLANNING="X") OR ARS_CHAINEORDO="" AND ';
        end
     else
        Req := 'SELECT ' + ZoneRes + ' FROM RESSOURCE WHERE ';

  //Gestion des conditions de selection des enregistrement
  Req := Req + 'ARS_FERME="-" ';
  if P.Famres <> 'GEN' then Req := Req + 'AND ARS_TYPERESSOURCE="' + P.FamRes + '"';

  if (SQL = '') then  SQL := 'ARS_RESSOURCE';

  Req := Req + ' ORDER BY ' + SQL;

  Result := Req;

end;

function ConstitueRequeteAbsenceConges (P :THPlanningBTP;DateD,DateF : TdateTime) : string ;
begin
	result := '( '+ // 1
            '(PCN_DATEDEBUTABS>="' + UsDateTime(DateD) + '" AND PCN_DATEDEBUTABS<="' + UsDateTime(DateF) + '") OR '+
						'(PCN_DATEFINABS>="' + USDateTime(DateD) + '" AND PCN_DATEFINABS<="' + USDateTime(DateF) + '") OR ' +
						'(PCN_DATEDEBUTABS<="' + UsDateTime(DateD) + '" AND PCN_DATEFINABS>="' + UsDateTime(DateF) + '")' +
            ')'; //1
end;

procedure TransformeAbsenceEnItem (TOBABS,TOBevt : TOB);
var DateD,DateF,HeureD,heureF,DD,DF : TdateTime;
begin
  TOBevt.putValue('BEP_BTETAT','ABSPAIE'); // obligatoire d'en fixer un donc cela sera caaaaa
  TOBevt.putValue('BEP_MODIFIABLE','-');
  TOBevt.putValue('BEP_RESPRINCIPALE','-');
  TOBevt.putValue('BEP_EQUIPESEP','-');
  TOBevt.putValue('BEP_OBLIGATOIRE','X');
  TOBevt.putValue('BEP_GEREPLAN','X');
  TOBevt.putValue('BEP_HEURETRAV','-');
  TOBevt.putValue('BEP_CREAPLANNING','-');
  TOBevt.putValue('BEP_RESSOURCE',TOBAbs.getValue('ARS_RESSOURCE'));
  DateD := StrToDate(DateToStr(TOBAbs.getValue('PCN_DATEDEBUTABS')));
  if TOBAbs.getValue('PCN_DEBUTDJ')='MAT' then
  begin
    heureD := GetDebutMatinee;
  end else
  begin
    heureD := GetDebutApresMidi;
  end;
  DateF := StrToDate(DateToStr(TOBAbs.getValue('PCN_DATEFINABS')));
  if TOBAbs.getValue('PCN_FINDJ')='MAT' then
  begin
    heureF := GetFinMatinee;
  end else
  begin
    heureF := GetFinApresMidi;
  end;
  TOBEvt.putValue('BEP_DATEDEB',DateD+heureD);
  TOBEvt.putValue('BEP_HEUREDEB',heureD);
  TOBEvt.putValue('BEP_DATEFIN',DateF+heureF);
  TOBEvt.putValue('BEP_HEUREFIN',heureF);
  TOBEvt.putvalue('BEP_DUREE',CalculDureeEvenement (DD,DF));
  if TOBAbs.getValue('PCN_TYPEMVT')='CPA' then // congés payes
  begin
    TOBEvt.putvalue('BEP_BLOCNOTE','CONGES PAYES');
  end else
  begin
    TOBEvt.putvalue('BEP_BLOCNOTE',rechDom('PGMOTIFABSENCE',TOBAbs.getValue('PCN_TYPECONGE'),false));
  end;
end;

procedure TransformeActionsEnItem (TOBAct : TOb;R :RecordPlanning);
var DateD,DateF,HeureD,heureF,DD,DF : TdateTime;
		libAction : string;
    QQ :TQuery;
    TOBevt,TOBEvtS : TOB;
begin
	TOBEvt := TOB.Create ('BTEVENPLAN',R.TobItems,-1);

  TOBevt.putValue('BEP_BTETAT','ACT-GRC'); // obligatoire d'en fixer un donc cela sera caaaaa
  if  TOBAct.getValue('RAC_ETATACTION')='PRE' then
  begin
  	TOBevt.putValue('BEP_MODIFIABLE','X');
  end else
  begin
  	TOBevt.putValue('BEP_MODIFIABLE','-');
  end;
  TOBevt.putValue('BEP_RESPRINCIPALE','-');
  TOBevt.putValue('BEP_EQUIPESEP','-');
  TOBevt.putValue('BEP_OBLIGATOIRE','X');
  TOBevt.putValue('BEP_GEREPLAN','X');
  TOBevt.putValue('BEP_HEURETRAV','-');
  TOBevt.putValue('BEP_CREAPLANNING','-');
  TOBevt.putValue('BEP_RESSOURCE',TOBAct.getValue('RAC_INTERVENANT'));
  DateD := StrToDate(DateToStr(TOBAct.getValue('RAC_DATEACTION')));
  heureD := StrToTime(TimeToStr(TOBAct.getValue('RAC_HEUREACTION')));
  DateF := AjouteDuree(DateD+heureD ,TOBAct.getValue('RAC_DUREEACTION')) ;
  HeureF :=StrToTime(TimeToStr(DateF));
  TOBEvt.putValue('BEP_DATEDEB',DateD+heureD);
  TOBEvt.putValue('BEP_HEUREDEB',heureD);
  TOBEvt.putValue('BEP_DATEFIN',DateF);
  TOBEvt.putValue('BEP_HEUREFIN',heureF);
  TOBEvt.putvalue('BEP_DUREE',TOBAct.getValue('RAC_DUREEACTION'));
  LibAction := rechDom('RTTYPEACTIONALL',TOBAct.getValue('RAC_TYPEACTION'),false)+'#13#10'+
               TOBAct.getValue('T_LIBELLE')+ ' ('+TOBAct.getValue('T_VILLE')+')#13#10'+
               TOBAct.getValue('RAC_LIBELLE');
  TOBEvt.putvalue('BEP_BLOCNOTE',LibAction);
  TOBEvt.AddChampSupValeur('ACTIONSGRC', TOBAct.getValue('RAC_NUMACTION')); // définir que cela provient d'une action
  TOBEvt.AddChampSupValeur('CLIENTGRC',   TOBAct.getValue('RAC_AUXILIAIRE'));

  // maintenant on traite les intervenants suplémentaires
  QQ := OpenSql ('SELECT RAI_RESSOURCE FROM ACTIONINTERVENANT WHERE '+
  							 'RAI_AUXILIAIRE="'+TOBACt.getValue('RAC_AUXILIAIRE')+'" '+
                 'AND RAI_NUMACTION='+inttoStr(TOBAct.getValue('RAC_NUMACTION')),true,-1,'',true);
  if not QQ.eof then
  begin
  	QQ.First;
    repeat
    	if QQ.FindField('RAI_RESSOURCE').AsString <> TOBAct.getValue('RAC_INTERVENANT') then
      begin
				TOBEvts := TOB.Create ('BTEVENPLAN',R.TobItems,-1);
        TOBEvts.Dupliquer(TOBevt,false,true);
        TOBEvts.putValue('BEP_RESSOURCE',QQ.FindField('RAI_RESSOURCE').AsString);
      end;
      QQ.Next;
    until QQ.eof;
  end;
  ferme (QQ);
end;

procedure TransformeActionsEnItem (TOBAct ,TOBevt : TOB; P: THplanningBTP);
var DateD,DateF,HeureD,heureF,DD,DF : TdateTime;
		libAction : string;
    QQ :TQuery;
    TOBEvtS : TOB;
begin
  TOBevt.putValue('BEP_BTETAT','ACT-GRC'); // obligatoire d'en fixer un donc cela sera caaaaa
  if  TOBAct.getValue('RAC_ETATACTION')='PRE' then
  begin
  	TOBevt.putValue('BEP_MODIFIABLE','X');
  end else
  begin
  	TOBevt.putValue('BEP_MODIFIABLE','-');
  end;
  TOBevt.putValue('BEP_RESPRINCIPALE','-');
  TOBevt.putValue('BEP_EQUIPESEP','-');
  TOBevt.putValue('BEP_OBLIGATOIRE','X');
  TOBevt.putValue('BEP_GEREPLAN','X');
  TOBevt.putValue('BEP_HEURETRAV','-');
  TOBevt.putValue('BEP_CREAPLANNING','-');
  TOBevt.putValue('BEP_RESSOURCE',TOBAct.getValue('RAC_INTERVENANT'));
  DateD := StrToDate(DateToStr(TOBAct.getValue('RAC_DATEACTION')));
  heureD := StrToTime(TimeToStr(TOBAct.getValue('RAC_HEUREACTION')));
  DateF := AjouteDuree(DateD+heureD ,TOBAct.getValue('RAC_DUREEACTION')) ;
  HeureF :=StrToTime(TimeToStr(DateF));
  TOBEvt.putValue('BEP_DATEDEB',DateD+heureD);
  TOBEvt.putValue('BEP_HEUREDEB',heureD);
  TOBEvt.putValue('BEP_DATEFIN',DateF);
  TOBEvt.putValue('BEP_HEUREFIN',heureF);
  TOBEvt.putvalue('BEP_DUREE',TOBAct.getValue('RAC_DUREEACTION'));
  LibAction := rechDom('RTTYPEACTIONALL',TOBAct.getValue('RAC_TYPEACTION'),false)+'#13#10'+
               TOBAct.getValue('T_LIBELLE')+ ' ('+TOBAct.getValue('T_VILLE')+')#13#10'+
               TOBAct.getValue('RAC_LIBELLE');
  TOBEvt.putvalue('BEP_BLOCNOTE',LibAction);
  TOBEvt.AddChampSupValeur ('ACTIONSGRC',TOBAct.getValue('RAC_NUMACTION')); // définir que cela provient d'une action
  TOBEvt.AddChampSupValeur('CLIENTGRC',TOBAct.getValue('RAC_AUXILIAIRE'));
  // maintenant on traite les intervenants suplémentaires
  QQ := OpenSql ('SELECT RAI_RESSOURCE FROM ACTIONINTERVENANT WHERE '+
  							 'RAI_AUXILIAIRE="'+TOBACt.getValue('RAC_AUXILIAIRE')+'" '+
                 'AND RAI_NUMACTION='+inttoStr(TOBAct.getValue('RAC_NUMACTION')),true,-1,'',true);
  if not QQ.eof then
  begin
  	QQ.First;
    repeat
    	if QQ.FindField('RAI_RESSOURCE').AsString <> TOBAct.getValue('RAC_INTERVENANT') then
      begin
				TOBEvts := TOB.Create ('BTEVENPLAN',TOBevt.parent,-1);
        TOBEvts.Dupliquer(TOBevt,false,true);
        TOBEvts.putValue('BEP_RESSOURCE',QQ.FindField('RAI_RESSOURCE').AsString);
      	ChargementTobItem (TOBEvts);
        P.AddItem (TOBEvts) ;
        P.InvalidateItem (TOBEvts);
      end;
      QQ.Next;
    until QQ.eof;
  end;
  ferme (QQ);
end;

procedure ChargeActionsGRCDetail (TOBdetailAction : TOB;DateDebut,DateFin:TdateTime;
																	AppelsTraites: boolean;Auxiliaire : string;
                                  NumAction : integer);
var MaRequete : string;
		QQ : TQuery;
begin
  Marequete:='SELECT RAC_TIERS,RAC_AUXILIAIRE,RAC_LIBELLE,RAC_NUMACTION,RAC_TYPEACTION,RAC_DATEACTION'+
                 ',RAC_HEUREACTION,RAC_INTERVENANT,RAC_ETATACTION,RAC_DUREEACTION,RAC_BLOCNOTE'+
                 ',RAC_CHAINAGE,RAC_NUMLIGNE,RAC_GESTRAPPEL,RAC_DELAIRAPPEL,RAC_DATERAPPEL,RAC_NUMEROCONTACT'+
                 ',T_LIBELLE,T_VILLE,T_NATUREAUXI FROM RTVACTIONS '+
                 'WHERE ' ;
  if NumAction <> 0 then
  begin
  	maRequete := MaRequete + 'RAC_NUMACTION='+IntToStr(NumAction)+' AND RAC_AUXILIAIRE="'+Auxiliaire+'" AND ';
  end;

  if (not AppelsTraites) then
  begin
  	maRequete := MaRequete + 'RAC_ETATACTION="PRE" ';
  end else
  begin
  	maRequete := MaRequete + 'RAC_ETATACTION in ("PRE","REA","NRE") ';
  end;

  if DateDebut <> IDate1900 then
  begin
    maRequete := maRequete + 'AND RAC_DATEACTION >= "'+UsDateTime(DateDebut) + '" AND ' +
                'RAC_DATEACTION <= "'+UsDateTime(DateFin) + '"';
  end;
  maRequete := Marequete + 'ORDER BY RAC_DATEACTION';

  TRY
  	QQ := OpenSql (Marequete,true,-1,'',true);
    if not QQ.eof then
    begin
    	TOBdetailAction.loadDetailDb('ACTIONS','','',QQ,false);
    end;
  FINALLY
  	ferme (QQ);
  END;
end;

procedure EnvoieEltEmailFromGRC (Auxiliaire: string;NumAction: integer; TypeEnvoie : string; NewDate : TdateTime;newdelai : integer; InfoFrom : boolean=false);
var maRequete : string;
		QQ : Tquery;
    Sujet : HString;
    Corps : HTStringList;
    ResultMailForm : TResultMailForm;
    copie,fichiers,Destinataire : string;
begin
	Corps := hTStringList.Create;
//
	Destinataire := '';
  QQ := OpenSql ('SELECT RAI_RESSOURCE,ARS_EMAIL FROM ACTIONINTERVENANT '+
             		 'LEFT JOIN RESSOURCE ON ARS_RESSOURCE=RAI_RESSOURCE '+
  							 'WHERE '+
  							 'RAI_AUXILIAIRE="'+Auxiliaire+'" '+
                 'AND RAI_NUMACTION='+inttoStr(NumAction),true,-1,'',true);
  if not QQ.eof then
  begin
  	QQ.First;
    repeat
    	if  QQ.FindField('ARS_EMAIL').AsString <> '' then
      begin
        if destinataire = '' then Destinataire := QQ.FindField('ARS_EMAIL').AsString
                             else Destinataire := destinataire +';'+ QQ.FindField('ARS_EMAIL').AsString;
      end;
      QQ.Next;
    until QQ.eof;
  end;
  ferme (QQ);
//
  Marequete:='SELECT RAC_NUMACTION,RAC_AUXILIAIRE,RAC_INTERVENANT,RAC_LIBELLE,RAC_DATEACTION,RAC_HEUREACTION,'+
  					 'RAC_DUREEACTION,ARS_EMAIL,T_LIBELLE,'+
  					 'T_ADRESSE1,T_ADRESSE2,T_CODEPOSTAL,T_VILLE FROM RTVACTIONS '+
             'LEFT JOIN RESSOURCE ON ARS_RESSOURCE=RAC_INTERVENANT '+
             'WHERE RAC_NUMACTION='+IntToStr(NumAction)+' AND RAC_AUXILIAIRE="'+Auxiliaire+'"';
  TRY
  	QQ := OpenSql (MaRequete,True,1,'',true);
    if not QQ.eof then
    begin
      if QQ.findField ('ARS_EMAIL').AsString ='' then exit;
//      Destinataire := QQ.findField ('ARS_EMAIL').AsString;
      if TypeEnvoie = 'S' then
      begin
        Sujet := 'Annulation de votre action '+IntToStr(QQ.findField('RAC_NUMACTION').AsInteger);
        Corps.Add('Votre action N°'+IntToStr(QQ.findField('RAC_NUMACTION').AsInteger)+' a été annulée');
        Corps.Add('');
        Corps.Add('Pour information :');
        Corps.Add('Action :'+QQ.findField('RAC_LIBELLE').AsString +' pour le client '+QQ.findField('T_LIBELLE').AsString);
        Corps.Add('Adresse :');
        if QQ.findField('T_ADRESSE1').AsString <> '' then
        begin
          Corps.add('         '+QQ.findField('T_ADRESSE1').AsString);
        end;
        if QQ.findField('T_ADRESSE2').AsString <> '' then
        begin
          Corps.Add('         '+QQ.findField('T_ADRESSE2').AsString);
        end;
        if (QQ.findField('T_CODEPOSTAL').AsString <> '') or (QQ.findField('T_VILLE').AsString<>'') then
        begin
        	Corps.Add('         '+QQ.findField('T_CODEPOSTAL').AsString+' '+QQ.findField('T_VILLE').AsString);
        end;
      end else if (Typeenvoie = 'M') or (TypeEnvoie='R') then
      begin
        Sujet := 'Modification de votre action '+IntToStr(QQ.findField('RAC_NUMACTION').AsInteger);
        Corps.Add('Votre action N°'+IntToStr(QQ.findField('RAC_NUMACTION').AsInteger)+' a été modifiée');
        Corps.Add('');
        Corps.Add('Pour information :');
        Corps.Add('Action :'+QQ.findField('RAC_LIBELLE').AsString +' pour le client '+QQ.findField('T_LIBELLE').AsString);
        Corps.Add('');
        if not InfoFrom then
        begin
          Corps.Add('prévue le :'+DateTimeToStr(QQ.findField('RAC_DATEACTION').AsDateTime)+' à '+TimeToStr(QQ.findField('RAC_HEUREACTION').AsDateTime));
          Corps.Add('d''une durée de :'+LibelleDuree(QQ.findField('RAC_DUREEACTION').Asinteger,false));
        end else
        begin
          Corps.Add('prévue le :'+DateTimeToStr(NewDate)+' à '+TimeToStr(NewDate));
          Corps.Add('d''une durée de :'+LibelleDuree(newdelai,false));
        end;
        Corps.Add('Adresse :');
        if QQ.findField('T_ADRESSE1').AsString <> '' then
        begin
          Corps.add('         '+QQ.findField('T_ADRESSE1').AsString);
        end;
        if QQ.findField('T_ADRESSE2').AsString <> '' then
        begin
          Corps.Add('         '+QQ.findField('T_ADRESSE2').AsString);
        end;
        if (QQ.findField('T_CODEPOSTAL').AsString <> '') or (QQ.findField('T_VILLE').AsString<>'') then
        begin
        	Corps.Add('         '+QQ.findField('T_CODEPOSTAL').AsString+' '+QQ.findField('T_VILLE').AsString);
        end;
        Corps.Add('');
        if not InfoFrom then
        begin
          Corps.Add('à été décalée au :'+DateToStr(NewDate)+' à '+TimeToStr(NewDate));
          Corps.Add('pour une durée de :'+LibelleDuree(newdelai,false));
        end else
        begin
          Corps.Add('à été décalée au :'+DateToStr(QQ.findField('RAC_DATEACTION').AsDateTime)+' à '+TimeToStr(QQ.findField('RAC_HEUREACTION').AsDateTime));
          Corps.Add('pour une durée de :'+LibelleDuree(QQ.findField('RAC_DUREEACTION').Asinteger,false));
        end;
      end else
      begin
      	exit; // non pris en charge
      end;

      ResultMailForm := AglMailForm(Sujet,Destinataire,copie,Corps,fichiers,false);
      if ResultMailForm = rmfOkButNotSend then SendMail(Sujet,Destinataire,Copie,Corps,fichiers,True,1, '', '');

    end;
  FINALLY
  	ferme (QQ);
    Corps.Free;
  End;
end;

function  DeleteActionGRC (Auxiliaire : string; NumAction : integer) : boolean;
var MaRequete : string;
		Email,Sujet,Copie : string;
begin
	result := true;
  if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
  begin
    EnvoieEltEmailFromGRC (Auxiliaire,NumAction,'S',Idate1900,0);
  end;
  Marequete:='DELETE FROM ACTIONS '+
             'WHERE RAC_NUMACTION='+IntToStr(NumAction)+' AND RAC_AUXILIAIRE="'+Auxiliaire+'"';
  if ExecuteSql (Marequete) <= 0 then result := false;
end;

function UpdateActionGRC (Auxiliaire : string; NumAction : integer; DateDebut,DateFin:TdateTime): boolean;
var MaRequete : string;
		DateD,heureD : Tdatetime;
    Duree : double;
begin
	result := true;
	DateD := StrToDate(DateToStr(DateDebut));
  heureD := StrToTime(TimetoStr(DateDebut));
  Duree := CalculDureeEvenement (DateDebut,DateFin);
  if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
  begin
    EnvoieEltEmailFromGRC (Auxiliaire,NumAction,'M',DateDebut,round(Duree));
  end;
  Marequete:='UPDATE ACTIONS SET RAC_DATEACTION="'+USDateTime(DateD)+'",'+
  					 'RAC_HEUREACTION="'+USDateTime(heureD)+'",RAC_DUREEACTION='+IntToStr(round(Duree))+
             'WHERE RAC_NUMACTION='+IntToStr(NumAction)+' AND RAC_AUXILIAIRE="'+Auxiliaire+'"';
  if ExecuteSql (Marequete) <= 0 then result := false;
end;

procedure ChargeActionsGRC (R :RecordPlanning;P :THPlanningBTP;DateDebut,DateFin : TdateTime);
var DateD,DateF : TdateTime;
		OneTOB,TOBEVT : TOB;
    QQ : TQuery;
    indice : Integer;
    Marequete : string;
begin
	ONETOB := TOB.create('LES ACTIONS',nil,-1);
	DateD := StrToDate(DateTOStr(DateDebut));
	DateF := StrToDate(DateTOStr(DateFin));
  ChargeActionsGRCDetail (OneTOB,DateD,DateF,P.AppelsTraites,'',0);

  for Indice := 0 to OneTOB.detail.count -1 do
  begin
    TransformeActionsEnItem (OneTOB.detail[indice],R);
  end;
  OneTOB.free;
  R.TOBItems.detail.Sort('BEP_DATEDEB');
end;

procedure ChargeAbsenceSalaries (R :RecordPlanning;P :THPlanningBTP;DateDebut,DateFin : TdateTime);
var DateD,DateF : TdateTime;
		OneTOB,TOBEVT : TOB;
    QQ : TQuery;
    indice : Integer;
    Marequete : string;
begin
	ONETOB := TOB.create('LES ABSENCES',nil,-1);
	DateD := StrToDate(DateTOStr(DateDebut));
	DateF := StrToDate(DateTOStr(DateFin));
  // chargement des événements absences de la paye pour les salariés dans la période
 	MaRequete := 'SELECT *,R1.ARS_RESSOURCE FROM ABSENCESALARIE '+
  						 'LEFT JOIN RESSOURCE R1 ON R1.ARS_SALARIE=PCN_SALARIE '+
  						 'WHERE '+
  						 '(R1.ARS_RESSOURCE <>'') AND ('+
               ConstitueRequeteAbsenceConges (P,DateD,DateF) + ') AND (PCN_DATEANNULATION="'+USDATETIME(Idate1900)+'") '+
               'AND (PCN_VALIDRESP<>"")';
  TRY
  	QQ := OpenSql (Marequete,true,-1,'',true);
    if not QQ.eof then
    begin
    	OneTOB.loadDetailDb('ABSENCESALARIE','','',QQ,false);
    end;
  FINALLY
  	ferme (QQ);
  END;
  for Indice := 0 to OneTOB.detail.count -1 do
  begin
  	TOBEvt := TOB.Create ('BTEVENPLAN',R.TobItems,-1);
    TransformeAbsenceEnItem (OneTOB.detail[indice],TOBevt);
  end;
  OneTOB.free;
  R.TOBItems.detail.Sort('BEP_DATEDEB');
end;

Function ChargeRequeteIntervention(P : THPlanningBTP; DateDebut, DateFin : TdateTime) : String;
begin

  // Les items
  Result := 'SELECT BTEVENPLAN.*, ';
  Result := Result + '"" AS LIBELLE, "" AS HINT, "" AS ICONETYPDOS, ';
  Result := Result + '0 AS NUMEROHRPERIODEDEBUT, ';
  Result := Result + '0 AS NUMEROHRPERIODEFIN ';
  Result := Result + 'FROM BTEVENPLAN ';
  Result := Result + 'LEFT JOIN BTETAT    ON (BTA_BTETAT=BEP_BTETAT) ';
  Result := Result + 'LEFT JOIN RESSOURCE ON (ARS_RESSOURCE=BEP_RESSOURCE) ';
  Result := Result + 'LEFT JOIN AFFAIRE   ON (AFF_AFFAIRE=BEP_AFFAIRE) ';
  Result := Result + 'LEFT JOIN TIERS     ON (T_AUXILIAIRE=BEP_TIERS) ';
  Result := Result + 'LEFT JOIN ADRESSES  ON (ADR_REFCODE=AFF_AFFAIRE) ';

  if p.TypePlanning = 'PTA' then
    Result := Result + 'WHERE BEP_BTETAT="' + P.CodeOnglet + '" AND BTA_TYPEACTION="INT" AND'
  else
    Result := Result + 'WHERE ';

  Result := Result + '  ((BEP_DATEDEB>="' + UsDateTime(Datedebut) + '" ';
  Result := Result+ 'AND BEP_DATEDEB<="'  + UsDateTime(Datefin) + '") ';
  Result := Result+ 'OR (BEP_DATEFIN>="'  + USDateTime(DateDebut) + '" ';
  Result := Result+ 'AND BEP_DATEFIN<="'  + USDateTime(DateFin) + '") ';
  Result := Result+ 'OR (BEP_DATEDEB<="'  + UsDateTime(DateDebut) + '" ';
  Result := Result+ 'AND BEP_DATEFIN>="'  + UsDateTime(DateFin) + '")) ';
  Result := Result+ 'AND BTA_ASSOSRES="X" ';

  if (not P.AppelsTraites) then
    Result := Result + 'AND (((BEP_AFFAIRE <> "") AND (AFF_ETATAFFAIRE="AFF")) OR (BEP_AFFAIRE="")) ';

  Result := Result+ ' ORDER BY BEP_DATEDEB';

end;

Function ChargeRequeteFamilleMat(P : THPlanningBTP; DateDebut, DateFin : TdateTime) : String;
begin

  Result := 'SELECT BTEVENTMAT.*, ';
  Result := Result + ' "" AS LIBELLE, "" AS HINT, "" AS ICONETYPDOS, ';
  Result := Result + '  0 AS NUMEROHRPERIODEDEBUT, ';
  Result := Result + '  0 AS NUMEROHRPERIODEFIN ';
  Result := Result + '  FROM BTEVENTMAT ';
  Result := Result + '  LEFT JOIN BTMATERIEL   ON (BMA_CODEMATERIEL=BEM_CODEMATERIEL) ';
  Result := Result + '  LEFT JOIN BTFAMILLEMAT ON (BFM_CODEFAMILLE=BMA_CODEFAMILLE) ';
  Result := Result + '  LEFT JOIN BTETAT       ON (BTA_BTETAT=BEM_BTETAT) ';
  Result := Result + '  LEFT JOIN RESSOURCE    ON (ARS_RESSOURCE=BEM_RESSOURCE) ';
  Result := Result + '  LEFT JOIN AFFAIRE      ON (AFF_AFFAIRE=BEM_AFFAIRE) ';
  Result := Result + '  LEFT JOIN TIERS        ON (T_AUXILIAIRE=BEM_TIERS) ';
  Result := Result + '  LEFT JOIN ADRESSES     ON (ADR_REFCODE=AFF_AFFAIRE) ';

  Result := Result + ' WHERE   BFM_CODEFAMILLE="' + P.CodeOnglet + '" ';

  Result := Result + '   AND ((BEM_DATEDEB>="'    + UsDateTime(Datedebut) + '" ';
  Result := Result + '   AND   BEM_DATEDEB<="'    + UsDateTime(Datefin) + '") ';
  Result := Result + '    OR  (BEM_DATEFIN>="'    + USDateTime(DateDebut) + '" ';
  Result := Result + '   AND   BEM_DATEFIN<="'    + USDateTime(DateFin) + '") ';
  Result := Result + '    OR  (BEM_DATEDEB<="'    + UsDateTime(DateDebut) + '" ';
  Result := Result + '   AND   BEM_DATEFIN>="'    + UsDateTime(DateFin) + '")) ';
  Result := Result + '   AND   BTA_ASSOSRES="X" ';
  Result := Result + ' ORDER BY BEM_DATEDEB';

end;

Function ChargeRequeteTypeAction(P : THPlanningBTP; DateDebut, DateFin : TdateTime) : String;
begin

  Result := 'SELECT BTEVENTMAT.*, ';
  Result := Result + ' "" AS LIBELLE, "" AS HINT, "" AS ICONETYPDOS, ';
  Result := Result + '  0 AS NUMEROHRPERIODEDEBUT, ';
  Result := Result + '  0 AS NUMEROHRPERIODEFIN ';
  Result := Result + '  FROM BTEVENTMAT ';
  Result := Result + '  LEFT JOIN BTMATERIEL   ON (BMA_CODEMATERIEL=BEM_CODEMATERIEL) ';
  Result := Result + '  LEFT JOIN BTFAMILLEMAT ON (BFM_CODEFAMILLE=BMA_CODEFAMILLE) ';
  Result := Result + '  LEFT JOIN BTETAT       ON (BTA_BTETAT=BEM_BTETAT) ';
  Result := Result + '  LEFT JOIN RESSOURCE    ON (ARS_RESSOURCE=BEM_RESSOURCE) ';
  Result := Result + '  LEFT JOIN AFFAIRE      ON (AFF_AFFAIRE=BEM_AFFAIRE) ';
  Result := Result + '  LEFT JOIN TIERS        ON (T_AUXILIAIRE=BEM_TIERS) ';
  Result := Result + '  LEFT JOIN ADRESSES     ON (ADR_REFCODE=AFF_AFFAIRE) ';

  Result := Result + ' WHERE   BTA_TYPEACTION="PMA" AND BTA_BTETAT="' + P.CodeOnglet + '" ';

  Result := Result + '   AND ((BEM_DATEDEB>="'    + UsDateTime(Datedebut) + '" ';
  Result := Result + '   AND   BEM_DATEDEB<="'    + UsDateTime(Datefin) + '") ';
  Result := Result + '    OR  (BEM_DATEFIN>="'    + USDateTime(DateDebut) + '" ';
  Result := Result + '   AND   BEM_DATEFIN<="'    + USDateTime(DateFin) + '") ';
  Result := Result + '    OR  (BEM_DATEDEB<="'    + UsDateTime(DateDebut) + '" ';
  Result := Result + '   AND   BEM_DATEFIN>="'    + UsDateTime(DateFin) + '")) ';
  Result := Result + '   AND   BTA_ASSOSRES="X" ';
  Result := Result + ' ORDER BY BEM_DATEDEB';

end;




Function ChargeRequeteEventMat(P : THPlanningBTP; DateDebut, DateFin : TdateTime) : String;
begin

  //Pourquoi on n'utilise pas la requete utilisée pour l'affichage de l'évènement ??????
  Result := 'SELECT BTEVENTMAT.*, ';
  Result := Result + '"" AS LIBELLE, "" AS HINT, "" AS ICONETYPDOS, ';
  Result := Result + '0 AS NUMEROHRPERIODEDEBUT, 0 AS NUMEROHRPERIODEFIN ';
  Result := Result + 'FROM BTEVENTMAT ';
  Result := Result + 'LEFT JOIN BTETAT     ON (BTA_BTETAT=BEM_BTETAT) ';
  Result := Result + 'LEFT JOIN BTMATERIEL ON (BMA_CODEMATERIEL=BEM_CODEMATERIEL) ';
  Result := Result + 'LEFT JOIN RESSOURCE  ON (ARS_RESSOURCE=BEM_RESSOURCE) ';
  Result := Result + 'LEFT JOIN AFFAIRE    ON (AFF_AFFAIRE=BEM_AFFAIRE) ';
  Result := Result + 'LEFT JOIN TIERS      ON (T_AUXILIAIRE=BEM_TIERS) ';

  Result := Result + 'WHERE ';
  //
  Result := Result + '  ((BEM_DATEDEB>="'  + UsDateTime(Datedebut) + '" ';
  Result := Result + 'AND BEM_DATEDEB<="'  + UsDateTime(Datefin) + '") ';
  Result := Result + ' OR (BEM_DATEFIN>="' + USDateTime(DateDebut) + '" ';
  Result := Result + 'AND BEM_DATEFIN<="'  + USDateTime(DateFin) + '") ';
  Result := Result + ' OR (BEM_DATEDEB<="' + UsDateTime(DateDebut) + '" ';
  Result := Result + 'AND BEM_DATEFIN>="'  + UsDateTime(DateFin) + '")) ';
  Result := Result + 'AND BTA_ASSOSRES="X" ';
  //
  Result := Result + 'ORDER BY BEM_DATEDEB';

end;

procedure ChargeItemPlanning(var R: RecordPlanning; var P: THPlanningBTP; T: TOB; DateEnCours: TDateTime; TableEvent : String);
var Qitem		  : TQuery;
    QIcone    : TQuery;
    TobIcone	: Tob;
    Tobinter	: Tob;
    DateDebut	: TDateTime;
    datefin	  : TDateTime;
    MaRequete	: string;
    Civilite	: string;
    indice    : integer;
    Icone		  : integer;
    LibTypAct : String;
    ZoneItem	: String;
  	HeureDeb,HeureFin	: TDateTime;
begin

  TobFree(R.TobItems);

  P.Activate      := False;
  P.IntervalDebut := DateEnCours - (T.GetValue('HPP_INTERVALLEDEB'));
  P.IntervalFin   := DateEnCours + (T.GetValue('HPP_INTERVALLEFIN'));
  P.DateOfStart   := DateEnCours;
  Civilite        := '';

  //Chargement des données (items) comprises dans l'intervalle choisi
  // Calcul de la date de debut et de fin
  HeureDeb  := StrToTime('00:00:00');
  HeureFin  := StrToTime('23:59:59');

  DateDebut := DateEncours - T.getvalue('HPP_INTERVALLEDEB');
  DateFin   := T.getvalue('HPP_INTERVALLEFIN') + DateEncours;

  DateDebut := Trunc(DateDebut) + HeureDeb;
  DateFin   := Trunc(DateFin)   + HeureFin;

  AfficheLFixe(P, T);

  if (p.TypePlanning = 'PMA') then
    MaRequete := ChargeRequeteEventMat(P, DateDebut, DateFin)
  else if p.TypePlanning = 'PFM' then
    MaRequete := ChargeRequeteFamilleMat(P, DateDebut, DateFin)
  else if p.TypePlanning = 'PPA' then
    MaRequete := ChargeRequeteTypeAction(P, DateDebut, DateFin)
  else
    MaRequete := ChargeRequeteIntervention(P, DateDebut, DateFin);

  completeRequete(Marequete, Contenuitem);
  completeRequete(Marequete, Contenuhint);

  QItem := OpenSQL(MaRequete, True,-1,'',true);

  R.TobItems := Tob.Create('LES EVENTS', nil, -1);
  R.TobItems.LoadDetailDB(TableEvent, '', '', QItem, True);

  Ferme(QItem);

  //A ne pas faire si on est sur du parc/Matériel !!!!!!!
  if   pos(p.TypePlanning, 'PMA;PFM;PPA') = 0 then
  begin
    if (T.getValue('HPP_FAMRES')='SAL') or (T.getValue('HPP_FAMRES')='') then
    begin
      ChargeAbsenceSalaries (R,P,DateDebut,DateFin);
      ChargeActionsGRC (R,P,DateDebut,DateFin);
    end;
  end;

  for Indice := 0 to R.TobItems.detail.count -1 do
  begin
    if   pos(p.TypePlanning, 'PMA;PFM;PPA') > 0 then
      ChargementTobItemParc(R.TobItems.detail[indice])
    else
    begin
      ChargementTobItem(R.TobItems.Detail[indice]);
      //chargement des événements Matériels en fonction du code ressource associé au matériel...
      //cela implique la lecture du code matériel et de l'ensemble des événement associé à ce
      //matériel.
      if (T.GetBoolean('HPP_AFFEVTMAT')) then ChargeEventMatInEvenPlan(R,P,DateDebut,datefin);
    end;
  end;

  P.TobItems := R.TobItems;

  // Gestion evenements
  ChargeEvent(R, P);

  P.DisplayOptionLier               := False;
  P.DisplayOptionSuppressionLiaison := False;
  P.DisplayOptionLiaison            := False;

  FINIMOVE;

  P.Activate := True;

end;

procedure ChargeItemPlanningSelectif(var R: RecordPlanning; var P: THPlanningBTP; T: TOB; var Item: tob; Mode: Integer);
var Qitem			  : TQuery;
    QIcone			: TQuery;
    MaRequete		: string;
    ZoneItem		: String;
    ListeChamps	: array of string;
    i				    : Integer;
    Icone			  : Integer;
    iTable			: Integer;
    Tobitem		  : Tob;
    TobIcone		: Tob;
    Tobtmp			: Tob;
    TobFille		: Tob;
begin


  if pos(P.TypePlanning, 'PMA;PFM;PPA') > 0 then
  begin
    ChargeItemMaterielSelectif(R,P, T, Item, Mode);
    exit;
  end;

  //chargement de la requete de lecture des items
  MaRequete := 'SELECT BTEVENPLAN.* '
  	  	       + ',"" AS LIBELLE, "" AS HINT, "" AS ICONETYPDOS, '
    		       + '0 AS NUMEROHRPERIODEDEBUT, 0 AS NUMEROHRPERIODEFIN '
			         + 'FROM BTEVENPLAN LEFT JOIN BTETAT ON (BTA_BTETAT=BEP_BTETAT) '
		           + 'LEFT JOIN RESSOURCE ON (ARS_RESSOURCE=BEP_RESSOURCE) '
	             + 'LEFT JOIN AFFAIRE   ON (AFF_AFFAIRE=BEP_AFFAIRE) '
    		       + 'LEFT JOIN TIERS     ON (T_AUXILIAIRE=BEP_TIERS) '
		           + 'LEFT JOIN ADRESSES  ON (ADR_REFCODE=AFF_AFFAIRE) WHERE ';

  //Lecture en fonction de l'option choisie
  if Mode = 0 then
	   MaRequete := MaRequete + 'BEP_CODEEVENT ="' + Item.getvalue('BEP_CODEEVENT') + '"'
  else if mode = 1 then
	   MaRequete := MaRequete + 'BEP_AFFAIRE ="' + Item.getvalue('BEP_AFFAIRE') + '"'
  else if mode = 2 then
     Begin
     if Item.getvalue('BEP_EQUIPERESS') = '' then
    	  MaRequete := MaRequete + 'BEP_AFFAIRE ="' + Item.getvalue('BEP_AFFAIRE') + '"'
     else
	  	  MaRequete := MaRequete + 'BEP_AFFAIRE ="' + Item.getvalue('BEP_AFFAIRE') + '" AND BEP_EQUIPERESS="'+ Item.getvalue('BEP_EQUIPERESS')+ '"';
     end
  else if mode = 3 then
 	   MaRequete := MaRequete + 'BEP_CODEEVENT ="' + Item.getvalue('BEP_CODEEVENT') + '" AND BEP_EQUIPERESS="'+ Item.getvalue('BEP_EQUIPERESS')+ '"';


  CompleteRequete(MaRequete, ContenuItem);
  CompleteRequete(MaRequete, ContenuHint);

  Qitem := OpenSQL(MaRequete, True,-1,'',true);
  Tobitem := Tob.Create('BTEVENPLAN', nil, -1);
  Tobitem.LoadDetailDB('BTEVENPLAN', '', '', Qitem, False);
  Ferme(Qitem);

  if Tobitem.Detail.Count = 0 then
     Begin
     TobFree(TobItem);
     exit;
     end;

  Tobitem.detail[0].AddchampSup('ICONETYPDOS', True);
  Tobitem.detail[0].AddchampSup('LIBELLE', True);
  Tobitem.detail[0].AddchampSup('HINT', True);

  while Tobitem.detail.count <> 0 do
      begin
      ChargementTobItem(Tobitem.Detail[i]);
      //
      //Controle de l'item pour réaffichage ou affichage
      TobFille := P.TobItems.FindFirst(['BEP_CODEEVENT'], [TobItem.detail[i].getValue('BEP_CODEEVENT')], True);
      //
      if TobFille = nil then
         Begin
         TobFille := Tobitem.Detail[i];
         TobFille.ChangeParent(P.TobItems, -1);
         P.AddItem(TobFille);
         P.InvalidateItem(TobFille);
         end
      else
         Begin
	        Try
           P.DeleteItem(TobFille);
           Except
           end;
         TobFille := Tobitem.Detail[i];
         TobFille.ChangeParent(P.TobItems, -1);
         P.AddItem(TobFille);
         P.InvalidateItem(TobFille);
         end;
    end;

  TobFree(TobIcone);

  P.Raffraichir;

  AfficheLFixe(P, T);

  TobFree(TobItem);

end;

Procedure ChargementTobItem(TobTmp : Tob);
Var ZoneItem : String;
    Icone    : Integer;
    QIcone   : TQuery;
    TobIcone : Tob;
    LibTypAct: String;
    BlocNote : Variant;
Begin

  // Gestion des icones selon type d'évènement
  QIcone   := OpenSQL('SELECT * FROM BTETAT WHERE BTA_ASSOSRES="X" ORDER BY BTA_BTETAT', True,-1,'',true);
  TobIcone := TOB.Create ('Les Icones', Nil, -1) ;
  TobIcone.LoadDetailDB('BTETAT', '', '', QIcone, False);
  Ferme(QIcone);
  // pour la GRC
  if not TobTmp.FieldExists('ACTIONSGRC') then
  begin
  	TobTmp.AddChampSupValeur('ACTIONSGRC',0);
  end;
  if not TobTmp.FieldExists('CLIENTGRC') then
  begin
  	TobTmp.AddChampSupValeur('CLIENTGRC','');
  end;
  if not TobTmp.FieldExists('ORIGINEITEMS') then
  begin
  	TobTmp.AddChampSupValeur('ORIGINEITEMS','');
  end;
  //
  //
  if (TobTmp.FieldExists('LIBELLE')) then
  begin
  	if TOBTMP.getValue('ACTIONSGRC') <> 0 then
    begin
  		TobTmp.PutValue('LIBELLE',TOBTMP.getValue('BEP_BLOCNOTE'));
    end
    else if TOBTMP.getValue('BEP_CODEEVENT') = '' then
    begin
  		TobTmp.PutValue('LIBELLE',GetDescriptifCourt(TOBTMP));
  	end
    else if TOBTMP.getValue('BEP_AFFAIRE') = '' then
    begin
  		TobTmp.PutValue('LIBELLE',TOBTMP.getValue('BEP_BTETAT'));
    end
    else
    begin
  		TobTmp.PutValue('LIBELLE', AnalyseChamp(TobTmp, ContenuItem, FormatItem));
    end;
  end
  else
  begin
  	if TOBTMP.getValue('ACTIONSGRC') <> 0 then
    begin
  		TobTmp.AddChampSupValeur('LIBELLE',TOBTMP.getValue('BEP_BLOCNOTE'));
  	end
    else if TOBTMP.getValue('BEP_CODEEVENT') = '' then
    begin
  		TobTmp.AddChampSupValeur('LIBELLE',GetDescriptifCourt(TOBTMP));
  	end
    else if TOBTMP.getValue('BEP_AFFAIRE') = '' then
    begin
  		TobTmp.AddChampSupValeur('LIBELLE', TOBTMP.getValue('BEP_BTETAT'));
    end
    else
    begin
  		TobTmp.AddChampSupValeur('LIBELLE', AnalyseChamp(TobTmp, ContenuItem, FormatItem), False);
    end;
  end;

  ZoneItem := TobTmp.GetString('LIBELLE');

  if (TobTmp.FieldExists('HINT')) then
  begin
  	if TOBTMP.getValue('BEP_AFFAIRE') = '' then
    begin
  		TobTmp.PutValue('HINT', GetDescriptifCourt(TOBTMP));
    end else
    begin
  		TobTmp.PutValue('HINT', AnalyseChamp(TobTmp, ContenuHint, FormatHint))
    end;
  end else
  begin
  	if TOBTMP.getValue('BEP_AFFAIRE') = '' then
    begin
  		TobTmp.AddChampSupValeur('HINT', GetDescriptifCourt(TOBTMP));
    end else
    begin
  		TobTmp.AddChampSupValeur('HINT', AnalyseChamp(TobTmp, ContenuHint, FormatHint), False);
    end;
  end;

  Icone := -1;
  LibTypAct := '';

  if TobIcone.FindFirst(['BTA_BTETAT'], [TobTmp.getvalue('BEP_BTETAT')], TRUE) <> nil then
     Begin
     Icone      := TobIcone.FindFirst(['BTA_BTETAT'], [TobTmp.getvalue('BEP_BTETAT')], TRUE).GetValue('BTA_NUMEROICONE');
     LibTypAct  := TobIcone.FindFirst(['BTA_BTETAT'], [TobTmp.getvalue('BEP_BTETAT')], TRUE).GetValue('BTA_LIBELLE');
     end;

  if (Tobtmp.FieldExists('ICONETYPDOS')) then
     TobTmp.PutValue('ICONETYPDOS', Icone)
  else
     TobTmp.AddChampSupValeur('ICONETYPDOS', Icone);

  //
  // on decale la date de fin
  AffichageDateHeure(TobTmp);
  (*
  ZoneItem := trim(StringReplace(ZoneItem,'#13#10','',[rfReplaceAll]));
  if (ZoneItem = '') or (ZoneItem = LibTypAct) then
     Begin
     BlocNote  :=  TobTmp.GetValue('BEP_BLOCNOTE');
     if (Length(BlocNote) = 0) or (BlocNote = #$D#$A) then
        Tobtmp.PutValue('LIBELLE', LibTypAct)
     else
        Tobtmp.PutValue('LIBELLE', BlocNote);
     end;
  *)
  Tobfree(TobIcone);

end;

Procedure AffichageDateHeure(TobTmp : Tob);
Var DateDebE	: string;
  	HeureDeb	: TDateTime;
  	DateFinE	: String;
  	HeureFin,HeureFinT	: TDateTime;
Begin

  // Gestion de la date et l'heure
  if TobTMP.fieldExists('BEM_CODEMATERIEL') then
  begin
    DateDebE := DateToStr(TobTmp.GetValue('BEM_DATEDEB'));
    DateFinE := DateToStr(TobTmp.GetValue('BEM_DATEFIN'));
    HeureDeb  := StrToTime('00:00:00');
    HeureFin  := StrToTime('23:59:59');
  end
  else
  begin
    DateDebE := DateToStr(TobTmp.GetValue('BEP_DATEDEB'));
    DateFinE := DateToStr(TobTmp.GetValue('BEP_DATEFIN'));
    HeureDeb := TobTmp.GetValue('BEP_HEUREDEB');
    HeureFin := TobTmp.GetValue('BEP_HEUREFIN');
  end;
  //
  if heuredeb = heureFin then HeureFin := IncHour(HeureFin);
  //

  if Cadencement = '001' then // gestion par 1/4 Heure
  begin
     HeureFinT := IncMinute (HeureFin, -15);
     if heureFinT > heureDeb then heureFin := heureFinT;
  end else if Cadencement = '002' then // gestion par 1/2 Heure
  begin
     HeureFinT := IncMinute (HeureFin,-30);
     if heureFinT >= heureDeb then heureFin := heureFinT;
  end else if Cadencement = '003' then // gestion par heure
  begin
     HeureFinT := IncHour (HeureFin, - 1);
     if heureFinT >= heureDeb then heureFin := heureFinT;
  end else if Cadencement = '004' then // gestion par 1/2 Journée
  Begin
     HeureFinT := incminute (HeureFin,-72);
     if heureFinT >= heureDeb then heureFin := heureFinT;
  end else if Cadencement = '005' then // gestion par Journée
  begin
  	// pas de decalage dans ce cas la
  end else if Cadencement = '008' then // gestion par Période
  begin
     {TobTmp.PutValue('BEP_DATEFIN', TobTmp.GetValue('BEP_DATEFIN'));}
  end;

  if TobTMP.fieldExists('BEM_CODEMATERIEL') then
  begin
    TobTmp.PutValue('BEM_DATEDEB', Trunc(StrToDate(DateDebe)) + HeureDeb);
    TobTmp.PutValue('BEM_DATEFIN', Trunc(StrToDate(DateFine)) + HeureFin);
    TobTmp.PutValue('BEP_HEUREDEB', HeureDeb);
    TobTmp.PutValue('BEP_HEUREFIN', HeureFin);
  end
  else
  begin
    TobTmp.PutValue('BEP_DATEDEB', Trunc(StrToDate(DateDebe)) + HeureDeb);
    TobTmp.PutValue('BEP_DATEFIN', Trunc(StrToDate(DateFine)) + HeureFin);
    TobTmp.PutValue('BEP_HEUREDEB', HeureDeb);
    TobTmp.PutValue('BEP_HEUREFIN', HeureFin);
  end;


end;

procedure ChargeEvent(var R: RecordPlanning; var P: THPlanningBTP);
Var DateDebE	: string;
  	HeureDeb	: TDateTime;
  	DateFinE	: String;
  	HeureFin,HeureFinT	: TDateTime;
  	Qitem: TQuery;
  	MaRequete: string;
  	Indice : integer;
begin

  TobFree(R.TobEvents);

  P.TobEvenements := nil;
  R.TobEvents := TOB.Create('la tob', nil, -1);

  MaRequete := 'SELECT * FROM HREVENEMENT WHERE ((HEV_DATEDEBUT<="' + UsDateTime(P.IntervalFin)
    + '" AND HEV_DATEDEBUT>="' + UsDateTime(P.IntervalDebut) + '") OR '
    + '(HEV_DATEFIN<="' + UsDateTime(P.IntervalFin) + '" AND HEV_DATEFIN>="' + UsDateTime(P.IntervalDebut) + '") OR '
    + '(HEV_DATEFIN>="' + UsDateTime(P.IntervalFin) + '" AND HEV_DATEDEBUT<="' + UsDateTime(P.IntervalDebut) + '"))'
    + ' AND (HEV_EVENEMENT NOT LIKE "!%")';

  // Les items totaux
  QItem := OpenSQL(MaRequete, True,-1,'',true);

  R.TobEvents.LoadDetailDB('HREVENEMENT', '', '', Qitem, False, True);
  for Indice := 0 to R.TobEvents.detail.count -1 do
  begin
    DateDebE := DateToStr(R.TobEvents.detail[Indice].GetValue('HEV_DATEDEBUT'));
    DateFinE := DateToStr(R.TobEvents.detail[Indice].GetValue('HEV_DATEFIN'));
    HeureDeb := StrToTime('00:00:00');
    HeureFin := StrToTime('23:59:59');
    R.TobEvents.detail[Indice].PutValue('HEV_DATEDEBUT', Trunc(StrToDate(DateDebe)) + HeureDeb);
    R.TobEvents.detail[Indice].PutValue('HEV_DATEFIN', Trunc(StrToDate(DateFine)) + HeureFin);
  end;

  Ferme(QItem);

  P.GestionEvenements := False;

  if (R.TobEvents.detail.count > 0) then
  begin
    P.GestionEvenements := True;
    P.TobEvenements := R.TobEvents;
  end;

end;

function AnalyseChamp(Tobligne: TOB; ListeChamps: string; Formats: string): string;
var
  ChampEnCours: string;
  FormatEnCours: string;
  CharTmp: string;
  TypeChamp: string;
  ZHeure   : String;
  ZDate    : String;
begin
  result := '';

  //if (TobLigne.Getvalue('HDR_NOMBRERES') > 1) then
  //  Result := '(' + inttostr(TobLigne.Getvalue('HDR_NOMBRERES')) + ')';

  while ListeChamps <> '' do
  begin
    ChampEncours := ReadTokenst(ListeChamps);
    FormatEnCours := ReadTokenst(Formats);
    if Copy(ChampEncours, 0, 1) <> '(' then
    begin
      if Tobligne.FieldExists(ChampEncours) then
        if pos('HEURE', ChampEncours) <> 0 then
           Begin
           Zheure := TimeTostr(Tobligne.getvalue(ChampEnCours));
           Zheure := FormatDateTime('hh:mm', StrToTime(zheure));
           Result := Result + Zheure + ' ';
           end
        else if pos('DATE', ChampEncours) <> 0 then
          Result := Result + DateTimeTostr(Tobligne.getvalue(ChampEnCours)) + ' '
        else if FormatEncours = '$' then
        begin
          CharTmp := AffecteDataType(ChampEncours);
          CharTmp := RechDom(CharTmp, Tobligne.getvalue(ChampEnCours), False);

          if CharTmp = 'Error' then
            CharTmp := '';

          Result := Result + CharTmp + ' ';
        end
        else
        begin
          typeChamp := ChampToType(ChampEnCours);
          if typechamp = 'INTEGER' then
            Result := Result + inttostr(Tobligne.getvalue(ChampEnCours)) + ' '
          else if typechamp = 'DOUBLE' then
            Result := Result + floattostr(Tobligne.getvalue(ChampEnCours)) + ' '
          else
            Result := Result + Tobligne.getvalue(ChampEnCours) + ' ';
        end;
    end
    else
      // on retire les paranthèses
      Result := Result + Copy(ChampEncours, 3, Length(ChampEncours) - 4) + ' ';
  end;

end;

function LibelleChamp(CodeTablette: string): string;
begin

  Result := 'ARS_LIBELLE';

  if CodeTablette = 'H21' then
    Result := 'HTR_TYPRES'
  else if CodeTablette = 'H22' then
    Result := 'HTR_ABREGE'
  else if CodeTablette = 'H23' then
    Result := 'HTR_TYPRES'
  else if CodeTablette = 'H24' then
    Result := 'HTR_RESSOURCE';

end;

function TabletteAssociee(NomTable: string): string;
begin

  Result := '';

  if NomTable = 'HTR_FAMRES' then
    Result := 'HRFAMRES'
  else if NomTable = 'ARS_TYPERESSOURCE' then
    Result := 'AFTTYPERESSOURCE';

end;

procedure AfficheLFixe(P: THPlanningBTP; T: Tob);
var
  NbCol: integer;
  FontTo: Tfont;
  TauxOccupation: array of Hstring;
  Attribue: Boolean;
  FaireInit: Boolean;
  procedure InitTableau;
  begin
    FontTO.Name := T.Getvalue('HPP_FONTCOLONNE');
    NbCol := trunc(P.IntervalFin) - trunc(P.IntervalDebut) + 1;
    SetLength(TauxOccupation, NBcol);
  end;
begin

  FaireInit := True;

  FontTO := TFont.Create();

  try
    if (T.FieldExists('HPP_VISULIGNETRF')) and (T.GetValue('HPP_VISULIGNETRF') = 'X') then
    begin
      InitTableau;
      FaireInit := False;
      //if (NumYield < 0) then // uniquement en création
      //   if (LigneTarifYield(P.IntervalDebut, P.IntervalFin, TauxOccupation)) then
      //       NumYield := P.AjoutLigneFixe(FontTO, T.Getvalue('HPP_COULEURFOND'), TauxOccupation);
      NumYield := 999;
    end;

    if (T.FieldExists('HPP_VISULIGNETO')) and (T.GetValue('HPP_VISULIGNETO') = 'X') then
    begin
      if FaireInit then InitTableau;
      // Gestion sur attribué ou dispo
      Attribue := T.Getvalue('HPP_MODEGESTION') = 'ATT';
      //ToutesResDispo(T.getvalue('HPP_FAMRES'), P.IntervalDebut, P.IntervalFin, TauxOccupation, Attribue);
      if (NumLigneTO = 0) then
        P.UpdateLigneFixe(NumLigneTO, TauxOccupation)
      else
        NumLigneTO := P.AjoutLigneFixe(FontTO, T.Getvalue('HPP_COULEURFOND'), TauxOccupation);
    end;

  finally
    FreeAndNil(FontTO);
  end;

end;

//Permet de gérer la mise en forme des items et des hints en
//fonction de la requete de mise à jour de TobItem
procedure CompleteRequete(var Requete: string; ListeChamps: string);
var Complemt  : string;
    Champs    : string;
    position  : Integer;
begin

  while ListeChamps <> '' do
  begin
    Champs := ReadTokenst(ListeChamps);
    if Copy(Champs, 0, 1) <> '(' then
      if pos(Champs, Requete) = 0 then //nouveau champ
        Complemt := Complemt + ',' + Champs;
    // Pas un champs
  end;

  if complemt <> '' then
  begin
    Position := Pos(' FROM ', Requete);
    Insert(Complemt, Requete, Position);
  end;

end;

function AffecteDataType(NomChamp: string): string;
begin
  Result := '';
  Result := Get_Join(NomChamp);
end;

procedure MajParamplanning;
begin

  //Mise à jour des paramètres planning mode Graphique
  if (ExisteSQL('SELECT HPP_PARAMPLANNING FROM HRPARAMPLANNING WHERE HPP_MODEPLANNING=""')) then
     begin
     ExecuteSQL('UPDATE HRPARAMPLANNING SET HPP_MODEPLANNING="1DE" WHERE HPP_PLANNINGGRAPH="X"');
     ExecuteSQL('UPDATE HRPARAMPLANNING SET HPP_MODEPLANNING="4NR" WHERE HPP_PLANNINGGRAPH="-"');
     ExecuteSQL('UPDATE HRPARAMPLANNING SET HPP_MODEPLANNING="6NP" WHERE HPP_PLANNINGGRAPH=" "');
     end;

end;

procedure RecupChamps(var ListeChamps: array of string; iTable: integer);
var iChamp: integer;
begin

  for iChamp := 1 to high(V_PGI.DeChamps[iTable]) do
    begin
    ListeChamps[iChamp] := V_PGI.DEChamps[iTable, iChamp].Nom;
    end;

  ListeChamps[Length(ListeChamps) - 1] := '';
  ListeChamps[Length(ListeChamps) - 2] := '';
  ListeChamps[Length(ListeChamps) - 3] := 'ICONETYPDOS';
  ListeChamps[Length(ListeChamps) - 4] := 'HINT';
  ListeChamps[Length(ListeChamps) - 5] := 'LIBELLE';

end;

function ChargeStrByTablette(CodeTablette,ZoneARecuperer: String): String;
var StReq : String;
    QQ    : TQuery;
    TTab  : Tob;
    I			: Integer;
begin

    Result := '';

    StReq := 'SELECT ' + ZoneARecuperer + ' FROM CHOIXCOD WHERE CC_TYPE="' + CodeTablette + '"';

    // Lecture de la tablette passée en paramètre
    QQ := OpenSQL(StReq, True,-1,'',true);
    TTab := Tob.Create('Tob Tablette', nil, -1);
    TTab.LoadDetailDB('CHOIXCOD', '', '', QQ, False);
    Ferme(QQ);

    for I := 0 to TTab.Detail.Count-1 do
    Begin
        Result := Result + TTab.detail[i].GetValue(ZoneARecuperer) + ',';
    end;

    if result = '' then 
       Result := '*'
    else
       Result := Copy(result, 0, length(result)-1);

end;

procedure CalculDureeEvenementRess(TOBCalenDar,TOBParamPlanning: TOB;var DateDeb,DateFin : double; var HeureDeb,HeureFin : double);
Var HeureFinTemp  : Double;
    HeureDebTemp  : Double;
    HeureDeb1     : Double;
    HeureDeb2     : Double;
    HeureFin1     : Double;
    HeureFin2     : Double;
    //EcartTemp	  : Double;
    //Duree		    : Double;
    //NbHeureTotal: Double;
    DureeJournee  : double;
    //IntervalDate: TDateTime;
    //QQ			    : TQuery;
    StSQL		      : String;
    //NoJour    	: String;
    NbHeure       : double;
    NbJours       : double;
    Ok_TpsReel    : boolean;
Begin
  StSQL  := '';
  DureeJournee := 0;
  NbHeure := 0;
  HeureDeb1    := 0;
  HeureDeb2    := 0;
  HeureFin1    := 0;
  HeureFin2    := 0;
  Ok_TpsReel := GetParamSoc('SO_GESTEMPSREEL');

  if Assigned(TobCalendar) and (TOBcalendar.detail.count > 0) then
  Begin
  	// calcul de la durée en fonction du calendrier du salarié
    DureeJournee := TobCalendar.Detail[0].GetValue('ACA_DUREE');
    HeureDeb1    := TobCalendar.Detail[0].GetValue('ACA_HEUREDEB1');
    HeureDeb2    := TobCalendar.Detail[0].GetValue('ACA_HEUREDEB2');
    HeureFin1    := TobCalendar.Detail[0].GetValue('ACA_HEUREFIN1');
    HeureFin2    := TobCalendar.Detail[0].GetValue('ACA_HEUREFIN2');
  End;

  if DureeJournee = 0 then
  Begin
  	// calcul de la durée en fonction des elements standard paramétré si pas de calendrier salairié
    HeureDeb1    := TimeToFloat(GetParamSoc('SO_BTAMDEBUT'));
    HeureDeb2    := TimeToFloat(GetParamSoc('SO_BTAMFIN'));
    HeureFin1    := TimeToFloat(GetParamSoc('SO_BTPMDEBUT'));
    HeureFin2    := TimeToFloat(GetParamSoc('SO_BTPMFIN'));
    DureeJournee := HeureFin2 - HeureDeb1;
    if DureeJournee = 0 then
    Begin
      HeureDeb1 := TimeToFloat(GetParamSoc('SO_HEUREDEB'));
      HeureFin2 := TimeToFloat(GetParamSoc('SO_HEUREFIN'));
      DureeJournee := HeureFin2 - HeureDeb1;
      if DureeJournee = 0 then
      Begin
        HeureDeb1 := TimeToFloat(TOBParamPlanning.getvalue('HPP_HEUREDEBUT'), True);
        HeureFin2 := TimeToFloat(TOBParamPlanning.getvalue('HPP_HEUREFIN'), True);
        DureeJournee := HeureFinTemp - HeureDebTemp;
      end;
    end;
  end;

  //test si l'heure de début est inférieure à l'heure de déb du Calendrier
  if FloatToTime(HeureDeb) < FloatToTime(HeureDeb1) Then HeureDeb := HeureDeb1;
  //Test si l'heure de fin est supérieure à l'heure de fin du Calendrier
  if FloatToTime(HeureFin) > FloatToTime(HeureFin2) Then HeureFin := HeureFin2;

end;

function GestionDateFinPourModif (DateDeFin : TdateTime) : TdateTime;
Var DateFinE	: TDateTime;
  	HeureFin	: TDateTime;
    Delta : integer;
Begin

  // Gestion de la date et l'heure
  DateFinE := StrToDate(DateToStr(DateDeFin));
  HeureFin := StrTotime(TimetoStr(DateDeFin));
  if Cadencement = '001' then // gestion par 1/4 Heure
  begin
    HeureFin := IncMinute (HeureFin, 15);
  end else if Cadencement = '002' then // gestion par 1/2 Heure
  begin
    HeureFin := IncMinute (HeureFin,30);
  end else if Cadencement = '003' then // gestion par heure
  begin
    HeureFin := IncHour (HeureFin, 1);
  end else if Cadencement = '004' then // gestion par 1/2 Journée
  Begin
    if heureFin > GetFinMatinee then
    begin
    	Delta :=  MinutesBetween(heureFin,GetFinApresMidi);
    end else
    begin
    	Delta := MinutesBetWeen(HeureFin,GetFinMatinee);
    end;
    HeureFin := incminute (HeureFin,Delta);
  end else if Cadencement = '005' then // gestion par Journée
  begin
  	// pas de decalage dans ce cas la
  end else if Cadencement = '008' then // gestion par Période
  begin
     {TobTmp.PutValue('BEP_DATEFIN', TobTmp.GetValue('BEP_DATEFIN'));}
  end;
  result := DateFinE + heureFin;
end;

function GestionDateFinPourEnreg (DateDeFin : TdateTime) : TdateTime;
Var
  	DateFinE	: TDateTime;
  	HeureFin	: TDateTime;
    Delta : integer;
Begin

  // Gestion de la date et l'heure (Decalage pour la gestion de l'affichage)
  DateFinE := StrToDate(DateToStr(DateDeFin));
  HeureFin := StrTotime(TimetoStr(DateDeFin));
  //
  if Cadencement = '001' then // gestion par 1/4 Heure
  begin
     HeureFin := IncMinute (HeureFin, -15);
  end else if Cadencement = '002' then // gestion par 1/2 Heure
  begin
     HeureFin := IncMinute (HeureFin,-30);
  end else if Cadencement = '003' then // gestion par heure
  begin
     HeureFin := IncHour (HeureFin, - 1);
  end else if Cadencement = '004' then // gestion par 1/2 Journée
  Begin
    if heureFin > GetFinMatinee then
    begin
    	Delta :=  MinutesBetween(heureFin,GetFinApresMidi);
    end else
    begin
    	Delta := MinutesBetWeen(HeureFin,GetFinMatinee);
    end;
     HeureFin := incminute (HeureFin,Delta*(-1));
  end else if Cadencement = '005' then // gestion par Journée
  begin
  	// pas de decalage dans ce cas la
  end else if Cadencement = '008' then // gestion par Période
  begin
     {TobTmp.PutValue('BEP_DATEFIN', TobTmp.GetValue('BEP_DATEFIN'));}
  end;
  result := DateFinE + heureFin;
end;

function CalculDateDebut (DateDebut : TdateTime) : TdateTime;
Var DateDebE	  : TDateTime;
  	HeureDeb    : TdateTime;
    HeureDebAM  : TdateTime;
    HeureFinAM  : TDateTime;
    HeureDebPM  : Tdatetime;
    HeureFinPM  : TDateTime;
    HeureDebJr  : TDateTime;
Begin

  // Gestion de la date et l'heure (Decalage pour la gestion de l'affichage)
  DateDebE := StrToDate(DateToStr(DateDebut));
  HeureDeb := StrTotime(TimetoStr(DateDebut));
  HeureDebAm := GetDebutMatinee;
  HeureFinAm := GetFinMatinee;
  HeureDebPm := GetDebutApresMidi;
  HeurefinPm := GetfinApresMidi;
  HeureDebJr := HeureDebAm;

  //
  if (pos(Cadencement,'001;002;003')>0) then
  begin
  	 if (heureDeb < heureDebAM) then HeureDeb := heureDebAM;
     if (heureDeb > HeureFinAM) and (heureDeb < HeureDebPm) then heureDeb := HeureDebPm;
  end
  else if cadencement = '005' then  // gestion par journée
  begin
    HeureDeb := HeureDebJr;
  end
  else if Cadencement = '004' then // gestion par 1/2 Journée
  Begin
    if heureDeb > HeureFinAm then
    begin
    	heureDeb := heureDebpm;
    end
    else
    begin
    	heureDeb := HeureDebAm;
    end;
  end;
  result := DateDebE + HeureDeb;
end;

function CalculDateFin (DateFin : TdateTime) : TdateTime;
Var DateFinE	  : TDateTime;
  	HeureFin    : TdateTime;
    HeureDebAM  : TdateTime;
    HeureFinPM  : Tdatetime;
    HeureFinAM  : TDateTime;
    HeureFinJr  : TDateTime;
Begin

  // Gestion de la date et l'heure (Decalage pour la gestion de l'affichage)
  DateFinE := StrToDate(DateToStr(DateFin));
  HeureFin := StrTotime(TimetoStr(DateFin));
  HeureDebAm := GetDebutMatinee;
  HeureFINAm := GetFinMatinee;
  HeureFINPM := GetFinApresMidi;
  HeureFINJr := HeureFINPM;

  //
  if (pos(Cadencement,'001;002;003')>0) then
  begin
  	 if (heureFin > HeureFinPM) then HeureFin := HeureFinPM;
     if (heureFin < HeureFinAM) and (heureFin > HeureDebAm) then heureFin := HeureFinAM;
  end
  else if cadencement = '005' then  // gestion par journée
  begin
    Heurefin := HeureFinJr;
  end
  else if Cadencement = '004' then // gestion par 1/2 Journée
  Begin
    if heureFin > HeureFinAM then
    begin
    	heureFin := heureFinPM;
    end
    else
    begin
    	heureFin := HeureFinAm;
    end;
  end;
  result := DateFinE + HeureFin;
end;


function ControleHoraires (var DateDebEvt,DateFinEvt : TdateTime;ModeOption: string; Duree : double; CodeRessource : string) : boolean;
Var DateDeb,DateFin,HeureDeb,heureFin,HeureDebAM,HeureFinAm,heureDebPm,heureFinPM	: TDateTime;
begin
	result := true;
  //
  DateDeb := StrToDate(DateToStr(DateDebEvt));
  DateFin := StrToDate(DateToStr(DateFinEvt));
  HeureDeb := StrToTime(TimeToStr(DateDebEvt));
  HeureFin := StrToTime(TimeToStr(DateFinEvt));
  //
  if IsDateClosed (DateDeb) then
  begin
  	pgiInfo ('Impossible : La date de début est un jour non travaillé');
    result := false;
    exit;
  end;
  if ModeOption <> 'D' then
  begin
    if IsDateClosed (DateFin) then
    begin
      pgiInfo ('Impossible : La date de fin est un jour non travaillé');
      result := false;
      exit;
    end;
  end;
  //
  HeureDebAm := GetDebutMatinee;
  HeureDebPm := GetDebutApresMidi;
  HeureFinAm := GetFinMatinee;
  HeureFinPm := GetFinApresMidi;

  if (HeureDeb < heureDebAm) or
  	 (HeureDeb > heureFinPm) or
     ((HeureDeb > HeureFinAm) and
     (HeureDeb < heureDebPM)) then
  begin
  	if (HeureDeb < heureDebAM) then
    begin
    	heureDeb := HeureDebAM;
      DateDebEvt := DateDeb + heureDeb;
    end else if (heureDeb < HeureDebPM ) and (heureDeb > HeureFinAm) then
    begin
    	heureDeb := HeureDebPM;
      DateDebEvt := DateDeb + heureDeb;
    end else if (heureDeb > HeureFinPM ) then
    begin
    	heureDeb := HeureDebAM;
      DateDebEvt := IncDay(DateDeb,1) + heureDeb;
      DateDeb := StrToDate(DateToStr(DateDebEvt));
    end;
  end;
  //
  if ModeOption = 'D' then
  begin
  	DateFinEvt := AjouteDuree (DateDebEvt,round(Duree));
  	DateFin := StrToDate(DateToStr(DateFinEvt));
  	HeureFin := StrToTime(TimeToStr(DateFinEvt));
  end;
  //
  if (HeureFin < heureDebAm) or
  	 (HeureFin > heureFinPm) or
     ((HeureFin > HeureFinAm) and
     (HeureFin <= heureDebPM)) then
  begin
  	if (heureFin > heureFinAm) and (HeureFin <= heureDebPM) then
    begin
    	heureFin := HeureFinAM;
      DateFinEvt := DateFin + heureFin;
    end else if (heureFin < heureDebAm) then
    begin
    	heureFin := HeureDebAM;
      DateFinEvt := IncDay (DateFin,-1) + heureFin;
    end else if (heureFin > heureFinPM) then
    begin
    	heureFin := HeureDebAM;
      DateFinEvt := IncDay (DateFin,1) + heureFin;
    end;
  end;

end;

function LibelleDuree (NbMinutes : double; withLibDuree : boolean=true) : string;
var zHours,Zminutes : integer;
begin
	zHours := trunc(NbMinutes/60);
  zMinutes := round(NbMinutes - (zHours *60));
  if WithLibDuree then
  begin
  	Result := 'Durée : ' + Format ('%d:%2.2d', [zHours,zMinutes]);
  end else
  begin
  	Result := Format ('%d:%2.2d', [zHours,zMinutes]);
  end;
end;

function GetDescriptifCourt ( TOBD : TOB) : string;
var
  Memo: Tmemo;
  Panel: TPanel;
begin
  Panel := TPanel.Create(nil);
  try
    Panel.Visible := False;
    Panel.ParentWindow := GetDesktopWindow;
    Memo := Tmemo.Create(Panel);
    Memo.Parent := Panel;
    Memo.Visible := False;
    memo.text :=  TOBD.GetValue('BEP_BLOCNOTE');
    result := memo.lines.Strings [0]+'#13#10';
    if (memo.lines.Strings [1] <> '') and (memo.lines.Strings [1]<>'#13#10') then
    begin
    	result := result + memo.lines.Strings [1];
    end;
    if (memo.lines.Strings [2] <> '') and (memo.lines.Strings [2]<>'#13#10') then
    begin
    	result := result +'#13#10...';
    end;
    Memo.Free;
  finally
    Panel.Free;
  end

end;

function GetDescriptifTotal ( TOBD : TOB) : string;
var
  Memo: Tmemo;
  Panel: TPanel;
begin
  Panel := TPanel.Create(nil);
  try
    Panel.Visible := False;
    Panel.ParentWindow := GetDesktopWindow;
    Memo := Tmemo.Create(Panel);
    Memo.Parent := Panel;
    Memo.Visible := False;
    memo.text :=  TOBD.GetValue('BEP_BLOCNOTE');
    result := memo.lines.Strings [0]+'#13#10';
    if (memo.lines.Strings [1] <> '') and (memo.lines.Strings [1]<>'#13#10') then
    begin
    	result := result + memo.lines.Strings [1];
    end;
    if (memo.lines.Strings [2] <> '') and (memo.lines.Strings [2]<>'#13#10') then
    begin
    	result := result +'#13#10...';
    end;
    Memo.Free;
  finally
    Panel.Free;
  end

end;


procedure EnvoieEltEmailFromAction ( TOBElt : TOB; TypeEnvoie : string; NewDate : TdateTime;newdelai : integer; InfoFrom : boolean=false; NewRess : string='');
var maRequete : string;
		QQ : Tquery;
    Sujet : HString;
    Corps : HTStringList;
    ResultMailForm : TResultMailForm;
    copie,fichiers,Destinataire : string;
    Memo: Tmemo;
    Panel: TPanel;
    indice : integer;
    TOBL : TOB;
begin
	Corps := hTStringList.Create;
  Marequete:='SELECT ARS_EMAIL FROM RESSOURCE '+
             'WHERE ARS_RESSOURCE="'+TOBELT.getValue('BEP_RESSOURCE')+'"';
  Panel := TPanel.Create(nil);
  Panel.Visible := False;
  Panel.ParentWindow := GetDesktopWindow;
  Memo := Tmemo.Create(Panel);
  Memo.Parent := Panel;
  Memo.Visible := False;
  memo.text :=  TOBElt.GetValue('BEP_BLOCNOTE');
  TRY
  	QQ := OpenSql (MaRequete,True,1,'',true);
    if not QQ.eof then
    begin
      if QQ.findField ('ARS_EMAIL').AsString ='' then exit;
      Destinataire := QQ.findField ('ARS_EMAIL').AsString;
			if TypeEnvoie = 'C' then   // création
      begin
        Sujet := 'Nouveau(nouvelle) '+Rechdom('BTTYPEACTION',TOBELt.getValue('BEP_BTETAT'),false);
        Corps.add ('Prévue le : '+DateToStr(TOBElt.getValue('BEP_DATEDEB'))+' à '+ TimeToStr(TOBElt.getValue('BEP_HEUREDEB')));
        Corps.Add('d''une durée de :'+LibelleDuree(TOBElt.getValue('BEP_DUREE')));
        Corps.Add('');
        Corps.add ('détail :');
        for indice := 0 to memo.Lines.Count -1 do
        begin
        	Corps.Add(memo.lines.Strings [Indice]);
        end;
        Corps.Add('');
      end else if TypeEnvoie = 'S' then // suppression
      begin
        Sujet := 'Annulation de votre '+Rechdom('BTTYPEACTION',TOBELt.getValue('BEP_BTETAT'),false);
        Corps.Add('Votre '+Rechdom('BTTYPEACTION',TOBELt.getValue('BEP_BTETAT'),false)+' a été annulé(e)');
        Corps.add('Prévue le : '+DateToStr(TOBElt.getValue('BEP_DATEDEB'))+' à '+ TimeToStr(TOBElt.getValue('BEP_HEUREDEB'))+
        				 'est annulée');
      end else if (Typeenvoie = 'M') or (TypeEnvoie='R') then // etirement, reduction, modification, déplacement
      begin
      	if (NewRess <> '') and (NewRess <> TOBELt.getValue('BEP_RESSOURCE')) then
        begin
        	if InfoFrom then
          begin
          	// préparation des infos pour l'ancienne ressource -> Annulation de son action
          	TOBL := TOB.Create ('BTEVENPLAN',nil,-1);
            TRY
              TOBL.dupliquer (TOBElt,false,true);
              TOBL.putValue('BEP_DATEDEB',newDate);
              TOBL.putValue('BEP_HEUREDEB',StrToTime(TimeToStr(newDate)));
              TOBL.putValue('BEP_RESSOURCE',NewRess);
              EnvoieEltEmailFromAction (TOBL,'S',Idate1900,0); // envoie de l'annulation
              EnvoieEltEmailFromAction (TOBElt,'C',Idate1900,0); // envoie de l'info a la nouvelle ressource
            FINALLY
            	TOBL.free;
            END;
          end else
          begin
          	// préparation des infos pour la nouvelle ressource
          	TOBL := TOB.Create ('BTEVENPLAN',nil,-1);
            TRY
              TOBL.dupliquer (TOBElt,false,true);
              TOBL.putValue('BEP_DATEDEB',newDate);
              TOBL.putValue('BEP_HEUREDEB',StrToTime(TimeToStr(newDate)));
              TOBL.putValue('BEP_RESSOURCE',NewRess);
              EnvoieEltEmailFromAction (TOBL,'C',Idate1900,0); // envoie de l'info a la nouvelle ressource
              EnvoieEltEmailFromAction (TOBElt,'S',Idate1900,0); // envoie de l'annulation
            FINALLY
            	TOBL.free;
            END;
          end;
          exit;
        end else
        begin
          Sujet := 'Modification de '+Rechdom('BTTYPEACTION',TOBELt.getValue('BEP_BTETAT'),false);
          Corps.Add('Votre '+Rechdom('BTTYPEACTION',TOBELt.getValue('BEP_BTETAT'),false)+' a été modifié(e)');
          Corps.Add('');
          Corps.Add('Pour information :');
          for indice := 0 to memo.Lines.Count -1 do
          begin
            Corps.Add(memo.lines.Strings [Indice]);
          end;
          Corps.Add('');
          if not InfoFrom then
          begin
            Corps.add('Prévue le : '+DateToStr(TOBElt.getValue('BEP_DATEDEB'))+' à '+ TimeToStr(TOBElt.getValue('BEP_HEUREDEB')));
            Corps.Add('d''une durée de :'+LibelleDuree(TOBElt.getValue('BEP_DUREE')));
          end else
          begin
            Corps.Add('prévue le :'+DateTimeToStr(NewDate)+' à '+TimeToStr(NewDate));
            Corps.Add('d''une durée de :'+LibelleDuree(newdelai,false));
          end;
          Corps.Add('');
          if not InfoFrom then
          begin
            Corps.Add('à été décalée au :'+DateToStr(NewDate)+' à '+TimeToStr(NewDate));
            Corps.Add('pour une durée de :'+LibelleDuree(newdelai,false));
          end else
          begin
            Corps.add('à été décalée au :'+DateToStr(TOBElt.getValue('BEP_DATEDEB'))+' à '+ TimeToStr(TOBElt.getValue('BEP_HEUREDEB')));
            Corps.Add('pour une durée de :'+LibelleDuree(TOBElt.getValue('BEP_DUREE')));
          end;
        end;
      end else exit;

      ResultMailForm := AglMailForm(Sujet,Destinataire,copie,Corps,fichiers,false);
      if ResultMailForm = rmfOkButNotSend then SendMail(Sujet,Destinataire,Copie,Corps,fichiers,True,1, '', '');

    end;
  FINALLY
    Panel.Free;
  	ferme (QQ);
    Corps.Free;
  End;
end;

procedure EnvoieEmailFromIntervention ( TOBElt : TOB; Requete : string; TypeEnvoie : string; NewDate : TdateTime;newdelai : integer; InfoFrom : boolean=false; NewRess : string='');
var maRequete : string;
		QQ : Tquery;
    Sujet : HString;
    Corps : HTStringList;
    ResultMailForm : TResultMailForm;
    copie,fichiers,Destinataire : string;
    Memo: THRichEditOLE;
    Panel: TPanel;
    indice : integer;
    TOBL : TOB;
begin
	Corps := hTStringList.Create;
  Panel := TPanel.Create(nil);
  Panel.Visible := False;
  Panel.ParentWindow := GetDesktopWindow;
  Memo := THRichEditOLE.Create(Panel);
  Memo.Parent := Panel;
  Memo.Visible := False;
  MaRequete := 'SELECT AFF_DESCRIPTIF FROM AFFAIRE WHERE AFF_AFFAIRE="'+TOBELt.getValue('BEP_AFFAIRE')+'"';
  QQ := OpenSql(Marequete,true,1,'',true);
  if not QQ.eof then
  begin
  	memo.text :=  QQ.findField('AFF_DESCRIPTIF').AsString;
  end;
  ferme (QQ);
  Marequete:='SELECT ARS_EMAIL FROM RESSOURCE '+
             'WHERE ARS_RESSOURCE IN (SELECT BEP_RESSOURCE FROM BTEVENPLAN '+Requete+')';
  TRY
  	QQ := OpenSql (MaRequete,True,-1,'',true);
    if not QQ.eof then
    begin
    	QQ.first;
      Destinataire := '';
      repeat
      	if QQ.findField ('ARS_EMAIL').AsString <>'' then
        begin
          if Destinataire = '' then Destinataire := QQ.findField ('ARS_EMAIL').AsString
                               else Destinataire := Destinataire + ';'+QQ.findField ('ARS_EMAIL').AsString;
        end;
        QQ.next;
      until QQ.eof;
      if destinataire = '' then exit;
			if TypeEnvoie = 'C' then   // création
      begin
        Sujet := 'Nouveau(nouvelle) '+Rechdom('BTTYPEACTION',TOBELt.getValue('BEP_BTETAT'),false);
        Corps.add ('Prévue le : '+DateToStr(TOBElt.getValue('BEP_DATEDEB'))+' à '+ TimeToStr(TOBElt.getValue('BEP_HEUREDEB')));
        Corps.Add('d''une durée de :'+LibelleDuree(TOBElt.getValue('BEP_DUREE')));
        Corps.Add('');
        Corps.add ('détail :');
        for indice := 0 to memo.Lines.Count -1 do
        begin
        	Corps.Add(memo.lines.Strings [Indice]);
        end;
        Corps.Add('');
      end else if TypeEnvoie = 'S' then // suppression
      begin
        Sujet := 'Annulation de votre '+Rechdom('BTTYPEACTION',TOBELt.getValue('BEP_BTETAT'),false);
        Corps.Add('Votre '+Rechdom('BTTYPEACTION',TOBELt.getValue('BEP_BTETAT'),false));
        Corps.add('Prévue le : '+DateToStr(TOBElt.getValue('BEP_DATEDEB'))+' à '+ TimeToStr(TOBElt.getValue('BEP_HEUREDEB')));
        Corps.Add('a été annulé(e)');
        Corps.add ('détail :');
        for indice := 0 to memo.Lines.Count -1 do
        begin
        	Corps.Add(memo.lines.Strings [Indice]);
        end;
        Corps.Add('');
      end else if (Typeenvoie = 'M') or (TypeEnvoie='R') then // etirement, reduction, modification, déplacement
      begin
      	if (NewRess <> '') and (NewRess <> TOBELt.getValue('BEP_RESSOURCE')) then
        begin
        	if InfoFrom then
          begin
          	// préparation des infos pour l'ancienne ressource -> Annulation de son action
          	TOBL := TOB.Create ('BTEVENPLAN',nil,-1);
            TRY
              TOBL.dupliquer (TOBElt,false,true);
              TOBL.putValue('BEP_DATEDEB',newDate);
              TOBL.putValue('BEP_HEUREDEB',StrToTime(TimeToStr(newDate)));
              TOBL.putValue('BEP_RESSOURCE',NewRess);
              EnvoieEltEmailFromAction (TOBL,'S',Idate1900,0); // envoie de l'annulation
              EnvoieEltEmailFromAction (TOBElt,'C',Idate1900,0); // envoie de l'info a la nouvelle ressource
            FINALLY
            	TOBL.free;
            END;
          end else
          begin
          	// préparation des infos pour la nouvelle ressource
          	TOBL := TOB.Create ('BTEVENPLAN',nil,-1);
            TRY
              TOBL.dupliquer (TOBElt,false,true);
              TOBL.putValue('BEP_DATEDEB',newDate);
              TOBL.putValue('BEP_HEUREDEB',StrToTime(TimeToStr(newDate)));
              TOBL.putValue('BEP_RESSOURCE',NewRess);
              EnvoieEltEmailFromAction (TOBL,'C',Idate1900,0); // envoie de l'info a la nouvelle ressource
              EnvoieEltEmailFromAction (TOBElt,'S',Idate1900,0); // envoie de l'annulation
            FINALLY
            	TOBL.free;
            END;
          end;
          exit;
        end else
        begin
          Sujet := 'Modification de '+Rechdom('BTTYPEACTION',TOBELt.getValue('BEP_BTETAT'),false);
          Corps.Add('Votre '+Rechdom('BTTYPEACTION',TOBELt.getValue('BEP_BTETAT'),false)+' a été modifié(e)');
          Corps.Add('');
          Corps.Add('Pour information :');
          for indice := 0 to memo.Lines.Count -1 do
          begin
            Corps.Add(memo.lines.Strings [Indice]);
          end;
          Corps.Add('');
          if not InfoFrom then
          begin
            Corps.add('Prévue le : '+DateToStr(TOBElt.getValue('BEP_DATEDEB'))+' à '+ TimeToStr(TOBElt.getValue('BEP_HEUREDEB')));
            Corps.Add('d''une durée de :'+LibelleDuree(TOBElt.getValue('BEP_DUREE')));
          end else
          begin
            Corps.Add('prévue le :'+DateTimeToStr(NewDate)+' à '+TimeToStr(NewDate));
            Corps.Add('d''une durée de :'+LibelleDuree(newdelai,false));
          end;
          Corps.Add('');
          if not InfoFrom then
          begin
            Corps.Add('à été décalée au :'+DateToStr(NewDate)+' à '+TimeToStr(NewDate));
            Corps.Add('pour une durée de :'+LibelleDuree(newdelai,false));
          end else
          begin
            Corps.add('à été décalée au :'+DateToStr(TOBElt.getValue('BEP_DATEDEB'))+' à '+ TimeToStr(TOBElt.getValue('BEP_HEUREDEB')));
            Corps.Add('pour une durée de :'+LibelleDuree(TOBElt.getValue('BEP_DUREE')));
          end;
        end;
      end else exit;

      ResultMailForm := AglMailForm(Sujet,Destinataire,copie,Corps,fichiers,false);
      if ResultMailForm = rmfOkButNotSend then SendMail(Sujet,Destinataire,Copie,Corps,fichiers,True,1, '', '');

    end;
  FINALLY
    Panel.Free;
  	ferme (QQ);
    Corps.Free;
  End;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FV1
Créé le ...... : 22/09/2015
Modifié le ... : 22/09/2015
Description .. : Gestion des événements parc/matériel
Mots clefs ... : PARC, MATERIEL
*****************************************************************}
function  DeleteEvenementMateriel (CodeMateriel : string; NumEventMat : integer) : boolean;
var MaRequete : string;
		Email,Sujet,Copie : string;
begin

	result := true;

  Marequete:='DELETE FROM BTEVENTMAT WHERE BEM_IDEVENTMAT='+IntToStr(NumEventMat)+' AND BEM_CODEMATERIEL="'+CodeMateriel+'"';

  if ExecuteSql (Marequete) <= 0 then result := false;

end;

procedure ChargeEventMatInEvenPlan (R :RecordPlanning;P :THPlanningBTP;DateDebut,DateFin : TdateTime);
Var MaRequete : string;
    OneTOB    : TOB;
    TOBEVT    : TOB;
    QItem     : TQuery;
    indice    : Integer;
    Stwhere   : String;
begin

  ONETOB := TOB.create('BTEVENTMAT',nil,-1);

  //Pourquoi on n'utilise pas la requete utilisée pour l'affichage de l'évènement ??????

  MaRequete := 'SELECT *, '
             + '"" AS LIBELLE, "" AS HINT, "" AS ICONETYPDOS, '
             + '0 AS NUMEROHRPERIODEDEBUT, 0 AS NUMEROHRPERIODEFIN '
             + 'FROM BTEVENTMAT '
             + 'LEFT JOIN BTETAT     ON (BTA_BTETAT=BEM_BTETAT) '
             + 'LEFT JOIN BTMATERIEL ON (BMA_CODEMATERIEL=BEM_CODEMATERIEL) '
             + 'LEFT JOIN RESSOURCE  ON (ARS_RESSOURCE=BEM_RESSOURCE) '
             + 'LEFT JOIN AFFAIRE    ON (AFF_AFFAIRE=BEM_AFFAIRE) '
             + 'LEFT JOIN TIERS      ON (T_AUXILIAIRE=BEM_TIERS) ';
  //
  if p.TypePlanning = 'PTA' then StWhere := ' WHERE BEM_BTETAT="' + P.CodeOnglet + '" AND ';

  if StWhere <> '' then MaRequete := MaRequete + StWhere  Else MaRequete := MaRequete + ' WHERE ';
  //
  MaRequete := MaRequete + '  ((BEM_DATEDEB>="' + UsDateTime(Datedebut) + '" '
                         + 'AND BEM_DATEDEB<="' + UsDateTime(Datefin) + '") '
                         + 'OR (BEM_DATEFIN>="' + USDateTime(DateDebut) + '" '
                         + 'AND BEM_DATEFIN<="' + USDateTime(DateFin) + '") '
                         + 'OR (BEM_DATEDEB<="' + UsDateTime(DateDebut) + '" '
                         + 'AND BEM_DATEFIN>="' + UsDateTime(DateFin) + '")) '
                         + 'AND BTA_ASSOSRES="X" ';
  //
  MaRequete := MaRequete + 'ORDER BY BEM_DATEDEB';
  //
  TRY
  	QItem := OpenSql (Marequete,true,-1,'',true);
    if not QItem.eof then OneTOB.loadDetailDb('EVENEMENT MATERIEL','','',QItem,false);
  FINALLY
  	ferme (QItem);
  END;

  for Indice := 0 to OneTOB.detail.count -1 do
  begin
  	TOBEvt := TOB.Create ('BTEVENPLAN', R.TobItems,-1);
    TransformeEventMatEnItem (OneTOB.detail[indice],TOBevt);
  end;

  OneTOB.free;

  R.TOBItems.detail.Sort('BEP_DATEDEB');

end;

procedure  TransformeEventMatEnItem(TOBItem, TOBEvt : TOB);
Var DateD : TDateTime;
    DateF : TDateTime;
    HeureD: TDateTime;
    Heuref: TDateTime;
    DD,DF : TdateTime;
begin

  TOBevt.putValue('BEP_BTETAT',       TOBItem.GetString('BEM_BTETAT'));
  TOBevt.putValue('BEP_RESSOURCE',    TOBItem.GetString('BEM_RESSOURCE'));
  TOBevt.putValue('BEP_CODEEVENT',    TOBItem.GetString('BEM_IDEVENTMAT'));
  TOBevt.putValue('BEP_AFFAIRE',      TOBItem.GetString('BEM_AFFAIRE'));
  TOBevt.putValue('BEP_TIERS',        TOBItem.GetString('BEM_TIERS'));
  TOBevt.putValue('BEP_DUREE',        TOBItem.GetString('BEM_NBHEURE'));

  TOBevt.putValue('BEP_MODIFIABLE',   '-');
  TOBevt.putValue('BEP_RESPRINCIPALE','-');
  TOBevt.putValue('BEP_EQUIPESEP',    '-');
  TOBevt.putValue('BEP_OBLIGATOIRE',  'X');
  TOBevt.putValue('BEP_GEREPLAN',     'X');
  TOBevt.putValue('BEP_HEURETRAV',    '-');
  TOBevt.putValue('BEP_CREAPLANNING', '-');

  DateD   := StrToDate(DateToStr(TOBItem.getValue('BEM_DATEDEB')));
  HeureD  := GetDebutMatinee;
  DateF   := StrToDate(DateToStr(TOBItem.getValue('BEM_DATEFIN')));
  HeureF := GetFinApresMidi;

  TOBEvt.putValue('BEP_DATEDEB',      DateD+heureD);
  TOBEvt.putValue('BEP_HEUREDEB',     heureD);
  TOBEvt.putValue('BEP_DATEFIN',      DateF+heureF);
  TOBEvt.putValue('BEP_HEUREFIN',     heureF);
  TOBEvt.putvalue('BEP_DUREE',        CalculDureeEvenement (DD,DF));

  TOBEvt.putvalue('BEP_BLOCNOTE',               TobItem.GetString('BEM_LIBACTION'));

  TOBevt.AddChampSupValeur('BEP_CODEMATERIEL',  TOBItem.GetString('BEM_CODEMATERIEL'));
  TobEvt.AddChampSupValeur('BEP_LIBREALISE',    TobItem.GetString('BEM_LIBREALISE'));

  TOBEvt.AddChampSupValeur('LIBELLE',           TobItem.GetString('LIBELLE'));
  TOBEvt.AddChampSupValeur('HINT',              TobItem.GetString('HINT'));
  TobEvt.AddChampSupValeur('ICONETYPDOS',       TobItem.GetString('ICONETYPDOS'));

  TobEvt.AddChampSupValeur('ORIGINEITEMS',      TobItem.GetString('PARCMAT'));


end;

procedure ChargeItemMaterielSelectif(var R: RecordPlanning; Var P: THPlanningBTP; T: TOB; var Item: Tob; Mode: Integer);
var Qitem			  : TQuery;
    QIcone			: TQuery;
    MaRequete		: string;
    ZoneItem		: String;
    ListeChamps	: array of string;
    i				    : Integer;
    Icone			  : Integer;
    iTable			: Integer;
    Tobitem		  : Tob;
    TobIcone		: Tob;
    Tobtmp			: Tob;
    TobFille		: Tob;
begin

  if item = nil then exit;

  MaRequete := 'SELECT BTEVENTMAT.*, '
    + '"" AS LIBELLE, "" AS HINT, "" AS ICONETYPDOS, '
    + '0 AS NUMEROHRPERIODEDEBUT, 0 AS NUMEROHRPERIODEFIN '
    + 'FROM BTEVENTMAT '
    + 'LEFT JOIN BTETAT     ON (BTA_BTETAT=BEM_BTETAT) '
    + 'LEFT JOIN BTMATERIEL ON (BMA_CODEMATERIEL=BEM_CODEMATERIEL) '
    + 'LEFT JOIN RESSOURCE  ON (ARS_RESSOURCE=BEM_RESSOURCE) '
    + 'LEFT JOIN AFFAIRE    ON (AFF_AFFAIRE=BEM_AFFAIRE) '
    + 'LEFT JOIN TIERS      ON (T_AUXILIAIRE=BEM_TIERS) WHERE ';
  //
  //On ne prends pas les type action non géré au planning
  MaRequete := MaRequete + 'BTA_ASSOSRES="X" ';

  if Mode = 0 then //lecture sur le Type Actio n
  begin
    MaRequete := MaRequete + 'AND BEM_BTETAT ="' + Item.getvalue('BEM_BTETAT') + '"'
  end
  else if Mode = 1 then //lecture sur le code matériel
  begin
    MaRequete := MaRequete + 'AND BEM_CODEMATERIEL ="' + Item.getvalue('BEM_CODEMATERIEL') + '"'
  end
  else if mode = 2 then //Lecture sur le code identifiant
  begin
	   MaRequete := MaRequete + 'AND BEM_IDEVENTMAT ="' + Item.getvalue('BEM_IDEVENTMAT') + '"'
  end;
  //
  completeRequete(Marequete, Contenuitem);
  completeRequete(Marequete, Contenuhint);
  //
    TRY
	  QItem := OpenSQL(MaRequete, True,-1,'',true);
    if QItem.eof then
    begin
      TobFree(TobIcone);
      P.Raffraichir;
      AfficheLFixe(P, T);
      TobFree(TobItem);
      Exit;
    end
    else
    begin
      TobItem := TOB.create('BTEVENTMAT',nil,-1);
      TobItem.LoadDetailDB('BTEVENTMAT', '', '', QItem, False);
    end;
  FINALLY
  	ferme (QItem);
  END;

  while Tobitem.detail.count <> 0 do
  begin
    ChargementTobItemParc(Tobitem.Detail[i]);
    //
    //Controle de l'item pour réaffichage ou affichage
    TobFille := P.TobItems.FindFirst(['BEM_IDEVENTMAT'], [TobItem.detail[i].getValue('BEM_IDEVENTMAT')], True);
    //
    if TobFille = nil then
    Begin
      TobFille := Tobitem.Detail[i];
      TobFille.ChangeParent(P.TobItems, -1);
      P.AddItem(TobFille);
      P.InvalidateItem(TobFille);
    end
    else
    Begin
      Try
        P.DeleteItem(TobFille);
      Except
      end;
        TobFille := Tobitem.Detail[i];
        TobFille.ChangeParent(P.TobItems, -1);
        P.AddItem(TobFille);
        P.InvalidateItem(TobFille);
    end;
  end;

  TobFree(TobIcone);

  P.Raffraichir;

  AfficheLFixe(P, T);

  TobFree(TobItem);

end;

Procedure ChargementTobItemParc(TobTmp : Tob);
Var ZoneItem  : String;
    Icone     : Integer;
    QIcone    : TQuery;
    TobIcone  : Tob;
    LibTypAct : String;
    BlocNote  : Variant;
   	HeureDeb  : TDatetime;
    HeureFin	: TDateTime;
Begin

  // Gestion des icones selon type d'évènement
  QIcone   := OpenSQL('SELECT * FROM BTETAT WHERE BTA_TYPEACTION="PMA" AND BTA_ASSOSRES="X" ORDER BY BTA_BTETAT', True,-1,'',true);
  TobIcone := TOB.Create ('Les Icones', Nil, -1) ;
  TobIcone.LoadDetailDB('BTETAT', '', '', QIcone, False);

  Ferme(QIcone);

  //On charge le contenu de l'item
  if (TobTmp.FieldExists('LIBELLE')) then
   	TobTmp.PutValue('LIBELLE', AnalyseChamp(TobTmp, ContenuItem, FormatItem))
  else
 		TobTmp.AddChampSupValeur('LIBELLE', AnalyseChamp(TobTmp, ContenuItem, FormatItem), False);

  ZoneItem := TobTmp.GetString('LIBELLE');

  //On charge le contenu de l'info bulle
  if (TobTmp.FieldExists('HINT')) then
  	TobTmp.PutValue('HINT', AnalyseChamp(TobTmp, ContenuHint, FormatHint))
  else
    TobTmp.AddChampSupValeur('HINT', AnalyseChamp(TobTmp, ContenuHint, FormatHint), False);

  Icone     := -1;
  LibTypAct := '';

  //On charge le N° d'icône
  if TobIcone.FindFirst(['BTA_BTETAT'], [TobTmp.getvalue('BEM_BTETAT')], TRUE) <> nil then
  Begin
    Icone     := TobIcone.FindFirst(['BTA_BTETAT'], [TobTmp.getvalue('BEM_BTETAT')], TRUE).GetValue('BTA_NUMEROICONE');
    LibTypAct := TobIcone.FindFirst(['BTA_BTETAT'], [TobTmp.getvalue('BEM_BTETAT')], TRUE).GetValue('BTA_LIBELLE');
    if (Tobtmp.FieldExists('ICONETYPDOS')) then
      TobTmp.PutValue('ICONETYPDOS', Icone)
    else
      TobTmp.AddChampSupValeur('ICONETYPDOS', Icone);
  end;

  //on recharge la date et les heures dans des champs supp.
  TobTmp.AddChampSupValeur('BEP_DATEDEB', TobTmp.GetDateTime('BEM_DATEDEB'));
  TobTmp.AddChampSupValeur('BEP_DATEFIN', TobTmp.GetDateTime('BEM_DATEFIN'));
  HeureDeb  := StrToTime('00:00:00');
  HeureFin  := StrToTime('23:59:59');
  TobTmp.AddChampSupValeur('BEP_HEUREDEB',HeureDeb);
  TobTmp.AddChampSupValeur('BEP_HEUREFIN',HeureFin);

  if TobTmp.GetString('BEM_CODEETAT') = 'REA' then
    TobTmp.AddChampSupValeur('BEP_MODIFIABLE','-')
  else
    TobTmp.AddChampSupValeur('BEP_MODIFIABLE','X');

  // on decale la date de fin
  AffichageDateHeure(TobTmp);
  //
  Tobfree(TobIcone);

end;

Procedure ChargementEtat(var R: RecordPlanning; var P: THPlanningBTP; T: TOB; DateEnCours: TDateTime; ModeGestionPlanning: Boolean);
Var StSQL  :  string;
    QEtats : TQuery;
begin

  FreeandNil(R.TobEtats);
  if P.TobEtats <> nil then P.TobEtats.ClearDetail;

  R.TobEtats := TOB.Create ('Les etats', Nil, -1);

  // Chargement de la tob Etats - Type d'action
  if pos(P.TypePlanning, 'PMA;PFM;PPA') > 0 then
    StSQL := 'SELECT * FROM BTETAT WHERE BTA_TYPEACTION="PMA" AND BTA_ASSOSRES="X" ORDER BY BTA_BTETAT'
  else
  begin
    if T.GetBoolean('HPP_AFFEVTMAT') then
      StSQL := 'SELECT * FROM BTETAT WHERE BTA_ASSOSRES="X" ORDER BY BTA_BTETAT'
    else
      StSQL := 'SELECT * FROM BTETAT WHERE BTA_TYPEACTION="INT" AND BTA_ASSOSRES="X" ORDER BY BTA_BTETAT';
  end;

  QEtats   := OpenSQL(StSQL, True,-1,'',true);
  R.TobEtats.LoadDetailDB('BTETAT', '', '', QEtats, False);

  MajFontStyle(R.TobEtats);

  P.TobEtats := R.TobEtats;

  Ferme(QEtats);

end;

Procedure ChargeCadencement(R: RecordPlanning; P: THPlanningBTP; T: TOB);
Var   FormatDate  : string;
begin

  cadencement             := T.Getvalue('HPP_CADENCEMENT');

  // MAJ regroupement de date
  P.ActiveLigneGroupeDate := T.Getvalue('HPP_AFFDATEGROUP') = 'X';

  P.interval              := piNone;

  ControleCadencement(Cadencement, R, P, TobParametres);


end;

function IsModifiable(Item: TOB): boolean;
var QQ          : TQuery;
    NumEventMat : Integer;
    CodeMateriel: string;
    codeAffaire : string;
begin

  if Item = nil then exit;

  if not assigned(Item) then exit;

  if Item.getValue('BEP_MODIFIABLE') <> 'X' then exit;

	result := True;

  CodeMateriel  := Item.GetString('BEP_CODEMATERIEL');
  CodeAffaire   := Item.getValue('BEP_AFFAIRE');

  if (Item.fieldExists('ACTIONSGRC')) and (Item.GetValue('ACTIONSGRC') <> 0) then
  begin
    QQ := OpenSql ('SELECT RAC_ETATACTION FROM ACTIONS WHERE RAC_AUXILIAIRE="'+
                   Item.getValue('CLIENTGRC')+'" AND RAC_NUMACTION='+IntToStr(Item.getValue('ACTIONSGRC')),true,1,'',true);
    if not QQ.eof then
    begin
      if QQ.FindField('RAC_ETATACTION').AsString <> 'PRE' then result := false;
    end;
    ferme (QQ);
    exit;
  end;

	if CodeAffaire = '' then exit;

  QQ := OpenSql ('SELECT AFF_ETATAFFAIRE FROM AFFAIRE WHERE AFF_AFFAIRE="' + CodeAffaire + '"',true,1,'',true);
  if not QQ.eof then
  begin
  	if QQ.FindField('AFF_ETATAFFAIRE').AsString <> 'AFF' then result := false;
  end;

  ferme (QQ);

end;

end.


