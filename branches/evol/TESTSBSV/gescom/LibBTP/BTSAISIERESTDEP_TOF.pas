{***********UNITE*************************************************
Auteur  ...... : FV1 (VAUTRAIN)
Cr�� le ...... : 04/04/2013
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : BTSAISIERESTDEP ()
Mots clefs ... : TOF;BTSAISIERESTDEP
*****************************************************************}
Unit BTSAISIERESTDEP_TOF ;

Interface

Uses StdCtrls,
     Controls, 
     Classes, 
{$IFNDEF EAGLCLIENT}
     db, 
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF} 
     mul, 
{$else}
     eMul, 
{$ENDIF}
     uTob,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     Hpanel,
     HTB97,
     HRichOle,
     SAISUTIL,
     vierge,
     Grids,
     Graphics,
     Types,
     AffaireUtil,
     windows,
     Fe_main,
     StrUtils,
     UTOF ;

Type
  TOF_BTSAISIERESTDEP = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  Private
    //
    Action            : TActionFiche;
    //
   	TOBGrille         : TOB;
    TOBMO             : TOB;
    TOBFraisMO        : TOB;
    TOBFournitures    : TOB;
    TOBInternes       : TOB;
    TOBExternes       : TOB;
    TOBSsTraitance    : TOB;
    TOBdiverse        : TOB;
    TOBFacturation    : TOB;
    TOBFraisCh        : TOB;
    //
    TOBAffaire        : TOB;
    TOBRAD            : TOB;
    //
    stcell            : string;
    FF                : string;
    JournalConso      : String;
    //
    GS                : THgrid;
    //
    ColBudgetQte      : Integer;
    ColBudgetMT       : Integer;
    ColBudgetMTPA     : Integer;
    ColEngage         : Integer;
    ColTheoQte        : Integer;
    ColTheoMT         : Integer;
    ColTheoMTPA       : Integer;
    //
    ColResteQTE       : Integer;
    ColResteMT        : Integer;
    ColRealiseQte     : Integer;
    ColRealiseMt      : Integer;
    ColRealiseMtPA    : Integer;
    ColDepuisQte      : Integer;
    ColDepuisMt       : Integer;
    ColDepuisMtPA     : Integer;
    ColFinAffaire     : Integer;
    ColFinAffairePA   : Integer;
    //
    LastEnreg         : Integer;
    //
    AFFAIRE           : THEdit;
    AFFAIRE0          : THEdit;
    AFFAIRE1          : THEdit;
    AFFAIRE2          : THEdit;
    AFFAIRE3          : THEdit;
    AFFAIRE4          : THEdit;
    //
    AFFAIRE_          : THEdit;
    AFFAIRE0_         : THEdit;
    AFFAIRE1_         : THEdit;
    AFFAIRE2_         : THEdit;
    AFFAIRE3_         : THEdit;
    AFFAIRE4_         : THEdit;
    //
    DATEDEB           : THEdit;
    DATEFIN           : THEdit;
    //
    TIERS             : THEdit;
    TIERS_            : THEdit;
    //
    RESPONSABLE       : THEdit;
    MOIS              : THEdit;
    ANNEE             : THEdit;
    DATEARRETEE       : THEdit;
    //
    TotalEngageTDEP   : Double;
    TotalBudgetTDEP   : Double;
    TotalBudgetTDEPPA : Double;
    TotalRealiseTDEP  : Double;
    TotalRealiseTDEPPA: Double;
    TotalReaDepuisTDEP: Double;
    TotalReaDepuisTDEPPA  : Double;
    TotalQteReaDepuisTDEP : Double;
    TotalTheoTDEP     : double;
    TotalTheoTDEPPA   : Double;
    TotalResteTDEP    : Double;
    TotalFinAffTDEP   : Double;
    TotalFinAffTDEPPA : Double;
    //
    TotalEngageDPR    : Double;
    TotalBudgetDPR    : Double;
    TotalBudgetDPRPA  : Double;
    TotalRealiseDPR   : Double;
    TotalRealiseDPRPA : Double;
    TotalReaDepuisDPR : Double;
    TotalReaDepuisDPRPA   : Double;
    TotalQteReaDepuisDPR  : Double;
    TotalTheoDPR          : Double;
    TotalTheoDPRPA        : Double;
    TotalResteDPR         : Double;
    TotalFinAffDPR        : Double;
    TotalFinAffDPRPA      : Double;
    //
    TotalBudgetMAR        : Double;
    TotalBudgetMARPA      : Double;
    TotalRealiseMAR       : Double;
    TotalRealiseMARPA     : Double;
    TotalReaDepuisMAR     : Double;
    TotalReaDepuisMARPA   : Double;
    TotalQteReaDepuisMAR  : Double;
    TotalTheoMAR          : Double;
    TotalTheoMARPA        : Double;
    TotalResteMAR         : Double;
    TotalFinAffMAR        : Double;
    TotalFinAffMARPA      : Double;
    //
    TotalBudgetFAC        : Double;
    TotalRealiseFAC       : Double;
    TotalMtDepuisFAC      : Double;
    TotalEngageFAC        : Double;
    TotalTheoFAC          : Double;
    TotalResteFAC         : Double;
    TotalFinAffFAC        : Double;
    //
    BaseBudgetFac         : Double;
    BaseRealiseFac        : Double;
    BaseDepuisFAC         : Double;
    BaseEngageFAC         : Double;
    BaseTheoFAC           : Double;
    BaseFINAFFFac         : double;
    BaseResteFAC          : Double;
    //
    BaseBudget            : Double;
    BaseRealise           : Double;
    BaseTheorique         : Double;
    BaseFINAFF            : double;
    BaseBudgetPA          : Double;
    BaseRealisePA         : Double;
    BaseTheoriquePA       : Double;
    BaseFINAFFPA          : double;
    //
    LIBAFFAIRE        : THLabel;
    LIBTIERS          : THLabel;
    LIBRESPONSABLE    : THLabel;
    //
    CHKALLNAT         : ThCheckbox;
    CHKPROVISION      : Boolean;
    CHKEngage         : ThCheckbox;
    CHKGestionEnPa    : ThCheckbox;
    //
    PanelLeft         : THPanel;
    PanelBottom       : THPanel;
    //
    BNAFFAIRE         : THRichEditOle;
    //
    BValider          : TToolbarButton97;
    BImprimer         : TToolbarButton97;
    BLanceReq         : TToolbarButton97;
    BDEFINITIVE       : TToolbarButton97;
    BPremier          : TToolbarButton97;
    BPrecedent        : TToolbarButton97;
    BSuivant          : TToolbarButton97;
    BDernier          : TToolbarButton97;
    BSaisieConso      : TToolbarButton97;
    //
    fColNamesGS       : string;
    Falignement       : string;
    Ftitre            : string;
    fLargeur          : string;
    //
    OK_LanceReq       : Boolean;
    Ok_CtrlSaisie     : Boolean;
    VisuEngage        : boolean;
    GestionEnPa       : Boolean;
    CoefFGFromDomaine : boolean;
    DepuisINTheorique : boolean;
    DateArreteEncours : boolean;
    FromArrete        : boolean;
    ValideRADaZero    : Boolean;
    RADDefinitf       : Boolean;
    Ok_ModifRadValide : Boolean;
    Ok_Marque         : Boolean;
    //
    COEFFG            : double;
    budgetDepuis      : string;

    //
    procedure AffecteMoisAnne(DateP: TDateTime);
    procedure AfficheLagrille (First : boolean=false);
    procedure AjouteEventSUPRESS(MessEvent: string);
    procedure AnneeExit(Sender: TObject);
    //
    procedure BDefinitiveOnClick(Sender: TObject);
    procedure BDeleteClick (Sender : Tobject);
    procedure BDernierOnClick(Sender: TObject);
    procedure BPremierOnClick(Sender: TObject);
    procedure BPrecedentOnClick(Sender: TObject);
    procedure BSuivantOnClick(Sender: TObject);
    Procedure BSaisieConsoOnClick(Sender : Tobject);
    //
    procedure CalculColGrille;
    procedure Calcultotaldepenses;
    procedure CalculDPR;
    procedure CalculMarge;
    procedure CalculSsTot(TypeSt: String);
    //
    procedure CellEnter(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
    procedure CellExit(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
    //
    procedure ChargeEnteteAffaire;
    procedure ChargeInfoAffaire;
    Procedure ChargementFirstAffaire;
    procedure ChargeNaturesPrestation;
    procedure ChargeGrilleWithTobInt;
    procedure ChargeInfoDateArretee;
    procedure ChargementBudget;
    procedure ChargementBudgetBCE;
    procedure ChargementBudgetFrais(PieceFRais : String);
    procedure ChargementBudgetPrev;
    procedure ChargementConsomme(DateDebut, DateArrete: TDateTime);
    procedure ChargementConsommeDepuis(DateDebut, DateArrete: TDateTime);
    procedure ChargementEngage(DateArrete : TDateTime);
    procedure ChargementFacturation(DateDebut, DateArrete: TDateTime);
    procedure ChargementFactureDepuis(DateDebut, DateArrete: TDateTime);
    procedure ChargementLigneVide(TOBMere: TOB; TheTitre, TypeTob: String);
    procedure ChargementRecettesFraisAnnexes(DateDebut, DateArrete: TDateTime);
    procedure ChargementRecettesAnnexesFraisDepuis(DateDebut, DateArrete: TDateTime);
    procedure ChargementResteADepenser;
    procedure ChargeSsTot(TypeSt: String);
    procedure ChargeTob(TOBL, TOBMere: TOB; TheTitre, TypeTotal : String);
    //
    procedure CHKAllNatOnClick(Sender: TObject);
    Procedure CHKGestionEnPaOnClick(Sender: TObject);
    Procedure CHKEngageOnClick(Sender: TObject);
    //
    procedure ConstitueDateArrete;
    procedure ControleChamp(Champ, Valeur: String);
    function  ControleEnregRAD: Boolean;
    //
    procedure CreateLigneSsTotalToGrille(TheTitre, TypeSt : String);
    procedure CreateLigneTitreToGrille(TobALire: TOB);
    procedure CreateLigneToGrille(TOBL: TOB);
    Procedure CreateLigneTotal(TOBL : TOB);
    procedure CreateTOB;
    procedure CreateZoneTobIntermediaire(TOBINT: TOB);
    procedure ConstitueOuvrages(TOBLIGNES, TOBDESOUV, TOBOUVRAGES: TOB);
    //
    procedure DateArreteExit(Sender: TObject);
    procedure DefinieGrid;
    procedure DessineGrille;
    procedure DestroyTOB;
    procedure DispatchTob(TobDispatch: TOB);
    //
    procedure GetCellCanvas(ACol, ARow: Longint; Canvas: TCanvas; AState: TGridDrawState);
    procedure GetObjects;
    function  GetTOBGrille(ARow: integer): TOB;
    procedure GSOnKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure GSOnDblClick(Sender: TObject);
    //
    procedure ImprimerOnClick(Sender: TObject);
    //
    procedure LanceReqOnClick(Sender: TObject);
    procedure LectureEnteteAffaire;
    procedure LoadTOBOuvrages(NaturePiece : String; TOBLIGNES,TOBOUVRAGES: TOB) ; OverLoad;
    Procedure LoadTOBOuvrages(NaturePiece : String; Numero : Integer; TOBLIGNES,TOBOUVRAGES : TOB) ; Overload;

    procedure MiseAJourRAD(TOBLRAD, TOBL: TOB; Valide : String);
    procedure MoisExit(Sender: TObject);

    procedure NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_: THEdit);

    //procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure PostDrawCell(ACol, ARow: Longint; Canvas: TCanvas; AState: TGridDrawState);

    procedure RafraichitSSTot;
    Procedure RecuperationPieceFrais;
    procedure RemplitTobIntermediaire;

    procedure SetGrilleEvents(Etat: boolean);
    procedure SetScreenEvents;

    procedure TotalisationColonnes;
    procedure TraitelesOuvrages (TOBLIGNESO,TOBOUVRAGES,TOBBudget : TOB);

    procedure ValiderOnClick(Sender: TObject);
    //
    function  ZoneAccessible(var ACol, ARow: integer): boolean;
    procedure ZoneSuivanteOuOk(var ACol, ARow: integer; var Cancel: boolean);

    //
  end ;

Implementation
uses  Messages,
      ParamSoc,
      BTPUtil,
      DateUtils,
      StockUtil,
      UPrintScreen,
      factDomaines,
      UFonctionsCBP;

procedure TOF_BTSAISIERESTDEP.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTSAISIERESTDEP.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTSAISIERESTDEP.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_BTSAISIERESTDEP.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTSAISIERESTDEP.OnArgument (S : String ) ;
var i       : Integer;
    Critere : string;
    Champ   : string;
    Valeur  : string;
begin
  Inherited ;
  //
  BudgetDepuis      := GetParamSocSecur('SO_BTBUDGETRADFROM','001');
  VisuEngage        := GetParamSocSecur('SO_BTVISUENGAGE',false);
  GestionEnPa       := GetParamSocSecur('SO_BTRADENPA',false);
  CoefFGFromDomaine := GetParamSocSecur('SO_BTCOEFFGFROMDOMAINE',false);
  DepuisINTheorique := GetParamSocSecur('SO_BTRADDEPUISENTHEO',false);
  DateArreteEncours := GetParamSocSecur('SO_BTARRETEENCOURS',false);
  CHKPROVISION      := GetParamSocSecur('SO_RADLIGNEPROVISION', False);
  ValideRADaZero    := GetParamSocSecur('SO_VALIDERADAZERO', False);
  Ok_Marque         := GetParamSocSecur('SO_BTGESTIONMARQ', False);
  //
  THValComboBox(GetControl('BUDGETDEPUIS')).Value := BudgetDepuis;
  //
  ColBudgetQte  := -1;
  ColBudgetMT   := -1;
  ColBudgetMTPA := -1;
  ColRealiseMt  := -1;
  ColRealiseMtPA:= -1;
  ColRealiseQte := -1;
  ColEngage     := -1;
  ColDepuisQte  := -1;
  ColDepuisMt   := -1;
  ColDepuisMtPA := -1;
  ColTheoQte    := -1;
  ColTheoMT     := -1;
  ColTheoMTPA   := -1;
  ColResteQTE   := -1;
  ColResteMT    := -1;
  ColFinAffaire := -1;
  ColFinAffairePA := -1;

  OK_LanceReq   := False;
  Ok_CtrlSaisie := False;

  //Chargement des zones ecran dans des zones programme
  GetObjects;

  //
  if not DateArreteEncours then DateArretee.Enabled := false;

  CHKALLNAT.Checked := GetParamSocSecur('SO_BTCHKALLNATURE', False);
  CHKEngage.Checked := VisuEngage;
  CHKGestionEnPa.Checked := GestionEnPa;

  CreateTOB;

  BDefinitive.Visible := True;
  //
  BPrecedent.Visible  := True;
  BPremier.Visible    := True;
  BSuivant.Visible    := True;
  BDernier.Visible    := True;
  BDEFINITIVE.Enabled := false;
  BValider.Enabled    := false;
  //BSaisieConso.Visible:= True;

  Critere := S;

  if LaTob <> nil then
    ChargementFirstAffaire
  else
  begin
    While (Critere <> '') do
    BEGIN
      i:=pos(':',Critere);
      if i = 0 then i:=pos('=',Critere);
      if i <> 0 then
         begin
         Champ:=copy(Critere,1,i-1);
         Valeur:=Copy (Critere,i+1,length(Critere)-i);
         end
      else
         Champ := Critere;
      Controlechamp(Champ, Valeur);
      Critere:=(Trim(ReadTokenSt(S)));
    END;
  end;

  //FF:='# ### ##';
  if V_PGI.OkDecQ>0 then
  begin
    FF:='# ##0.';
    for i:=1 to V_PGI.OkDecQ-1 do
    begin
       FF:=FF+'0';
    end;
    FF:=FF+'0';
  end;

  // d�finition de la grille
  DefinieGrid;

  //dessin de la grille
  DessineGrille;

  //FS#2207 - TEAM RESEAUX : ajouter �galement dans la saisie de la grille le passage de la ligne en cours de saisie en surbrillance ou autre moyen de la distinguer. 
  GS.DBIndicator := True;

  //FS#763 - BAGE : En saisie RAD, ajout d�un droit d�acc�s pour la validation d�finitive
  if not (ExJaiLeDroitConcept(TConcept(bt519),False)) then
    BDEFINITIVE.Visible := False
  Else
    BDEFINITIVE.Visible := True;

  //chargement des informations de l'affaire (Ent�te)
  ChargeInfoAffaire;
  
  //Gestion des �v�nement des zones �cran
  SetScreenEvents;

  if LaTob <> nil then BValider.ModalResult := 0 else BValider.ModalResult := 1;

end ;

//chargement des informations de l'affaire (Ent�te)
Procedure TOF_BTSAISIERESTDEP.ChargeInfoAffaire;
var COEFMARG : double;
begin

  Ok_CtrlSaisie := False;

  NomsChampsAffaire(AFFAIRE, AFFAIRE0, AFFAIRE1, AFFAIRE2, AFFAIRE3, AFFAIRE4, AFFAIRE_, AFFAIRE0_, AFFAIRE1_, AFFAIRE2_, AFFAIRE3_, AFFAIRE4_, TIERS, TIERS_);

  ChargeCleAffaire(AFFAIRE0,AFFAIRE1,AFFAIRE2,AFFAIRE3,AFFAIRE4,Nil,taconsult,AFFAIRE.Text,False);

  LectureEnteteAffaire;

  ChargeEnteteAffaire;

  ChargeInfoDateArretee;

  if CoefFGFromDomaine then
  begin
    COEFFG := 0;
    COEFMARG := 0;
    GetCoefDomaine (TOBAffaire.GetString('AFF_DOMAINE'),COEFFG,COEFMARG);
    if COEFFG = 0 then
    begin
      CoefFG := 0;
      THLabel(GetControl('LBLCOEFMARGE')).Caption := 'Coef. de frais g�n�raux non d�fini...Repris depuis les �l�ments de chiffrages';
      THLabel(GetControl('LBLCOEFMARGE')).visible := true;
      CoefFGFromDomaine := false;
    end else
    begin
      THLabel(GetControl('LBLCOEFMARGE')).Caption := Format ('Domaine : %s Coefficient Frais G�n�raux : %8.4f',[TOBAffaire.getString('AFF_DOMAINE'),CoefFG]);
      THLabel(GetControl('LBLCOEFMARGE')).visible := true;
    end;
  end;       

  if OK_LanceReq then LanceReqOnClick(self);

end;

Procedure TOF_BTSAISIERESTDEP.AffecteMoisAnne(DateP : TDateTime);
var Day     : Word;
    Month   : Word;
    Year    : Word;
begin
  DecodeDate(DateP, Year, Month, Day);

  if not FromArrete then
  begin
    if Month = 1 then
    begin
      Mois.text   := IntToStr(12);
      Annee.text  := IntToStr(Year-1);
    end
    else
    begin
      MOIS.Text   := IntToStr(Month-1);
      ANNEE.text  := IntToStr(Year);
    end;
  end else
  begin
    MOIS.Text   := IntToStr(Month);
    ANNEE.text  := IntToStr(Year);
  end;
  if StrToInt(mois.text) < 10 then Mois.text := Trim(Mois.text);
end;


Procedure TOF_BTSAISIERESTDEP.ChargeInfoDateArretee;
var ThisDate : Tdatetime;
begin
  FromArrete := false;

  if (DateArretee.text = DateToStr(idate1900)) then
  begin
    OK_LanceReq := False;
    if not DateArreteEncours then
    begin
      ThisDate := FinDeMois(plusmois(Now, -1));
    end else
    begin
      ThisDate := now;
    end;
    DATEARRETEE.text := DateToStr(ThisDate);
    DateArreteExit (self);
    Mois.SetFocus;
  end else
  begin
    FromArrete := true;
    DateArreteExit (self);
    OK_LanceReq := True;
  end;

end;

procedure TOF_BTSAISIERESTDEP.OnClose ;
begin
  Inherited ;

  //controle si au moins une saisie � �t� faite...
  If Ok_CtrlSaisie then
  begin
    if PGIAsk('Des modifications ont �t� effectu�es, voulez-vous les enregistrer ?', 'Sauvegarde RAD')=MrYes then
    begin
      ValiderOnClick(Self);
    end;
  end;
  DestroyTOB;
end ;

procedure TOF_BTSAISIERESTDEP.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTSAISIERESTDEP.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BTSAISIERESTDEP.CreateTOB;
begin

   	TOBGrille         := TOB.Create('LA GRILLE', nil, -1);
    TOBMO             := TOB.Create('MAIN OEUVRE', nil, -1);
    TOBFraisMO        := TOB.Create('FRAIS MO', nil, -1);
    TOBFournitures    := TOB.Create('FOURNITURES', nil, -1);
    TOBInternes       := TOB.Create('INTERNES', nil, -1);
    TOBExternes       := TOB.Create('EXTERNES', nil, -1);
    TOBSsTraitance    := TOB.Create('SOUS TRAITE', nil, -1);
    TOBdiverse        := TOB.Create('DIVERSE', nil, -1);
    TOBFacturation    := TOB.Create('FACTURATION', nil, -1);
    TOBFraisCh        := TOB.Create('FRAISCHANTIER', nil, -1);

    TOBAffaire        := TOB.Create('AFFAIRE', nil, -1);
    TOBRAD            := TOB.Create('BTRESTEADEP', nil, -1);

end;

procedure TOF_BTSAISIERESTDEP.DestroyTOB;
begin
  FreeAndNil(TOBGrille);
  FreeAndNil(TOBMO);
  FreeAndNil(TOBFraisMO);
  FreeAndNil(TOBFournitures);
  FreeAndNil(TOBInternes);
  FreeAndNil(TOBExternes);
  FreeAndNil(TOBSsTraitance);
  FreeAndNil(TOBdiverse);
  FreeAndNil(TOBFacturation);
  FreeandNil(TOBFraisCh);
  //
  FreeAndNil(TOBAffaire);
  FreeAndNil(TOBRAD);
end;

procedure TOF_BTSAISIERESTDEP.GetObjects;
begin
  //
  GS          := THgrid(GetControl('GRILLESAISIE'));
  //
  BValider    := TToolbarButton97 (GetControl('BVALIDER'));
  BImprimer   := TToolbarButton97 (GetControl('BIMPRIMER'));
  BLanceReq   := TToolbarButton97 (GetControl('LANCEREQUETE'));
  BDefinitive := TToolbarButton97 (GetControl('BDEFINITIVE'));
  BPremier    := TToolbarButton97 (GetControl('BPremier'));
  BPrecedent  := TToolbarButton97 (GetControl('BPrecedent'));
  BSuivant    := TToolbarButton97 (GetControl('BSuivant'));
  BDernier    := TToolbarButton97 (GetControl('BDernier'));
  //BSaisieConso:= TToolbarButton97 (GetControl('BTSAISIECONSO'));

  //
  AFFAIRE     := THEdit (GetControl('AFFAIRE'));
  AFFAIRE0    := THEdit (GetControl('AFFAIRE0'));
  AFFAIRE1    := THEdit (GetControl('AFFAIRE1'));
  AFFAIRE2    := THEdit (GetControl('AFFAIRE2'));
  AFFAIRE3    := THEdit (GetControl('AFFAIRE3'));
  AFFAIRE4    := THEdit (GetControl('AVENANT'));
  //
  TIERS       := THEdit (GetControl('TIERS'));
  RESPONSABLE := THEdit (GetControl('RESPONSABLE'));
  MOIS        := THEdit (GetControl('MOIS'));
  ANNEE       := THEdit (GetControl('ANNEE'));
  DATEDEB     := THEdit (GetControl('DATEDEB'));
  DATEFIN     := THEdit (GetControl('DATEFIN'));
  DATEARRETEE := THEdit (GetControl('DATEARRETEE'));
  //
  PanelLeft   := THPanel(GetControl('PANELLEFT'));
  PanelBottom := THPanel(GetControl('PANELBOTTOM'));
  //
  CHKALLNAT   := THCheckBox(GetControl('CHKALLNAT'));
  CHKEngage   := THCheckBox(GetControl('ENGAGE'));
  CHKGestionEnPa := THCheckBox(GetControl('GESTIONPA'));
  //
  BNAFFAIRE   := THDBRichEditOLE (GetControl('BNAFFAIRE'));
  //
  LIBAFFAIRE  := THLabel(GetControl('LIBAFFAIRE'));
  LIBTIERS    := THLabel(GetControl('LIBTIERS'));
  LIBRESPONSABLE := THLabel(GetControl('LIBRESPONSABLE'));
  //
end;

procedure TOF_BTSAISIERESTDEP.SetGrilleEvents (Etat : boolean);
begin
  if Etat then
  begin
    GS.OnCellEnter  := CellEnter;
    GS.OnCellExit   := CellExit;
    GS.GetCellCanvas:= GetCellCanvas;
    GS.PostDrawCell := PostDrawCell;
    GS.OnKeyDown    := GSOnKeyDown;
    GS.OnDblClick   := GSOnDblClick;
  end else
  begin
    GS.OnCellEnter  := nil;
    GS.OnCellExit   := nil;
    GS.GetCellCanvas:= nil;
    GS.PostDrawCell := nil;
    GS.OnKeyDown    := nil;
    GS.OnDblClick   := Nil;
  end;

end;

procedure TOF_BTSAISIERESTDEP.SetScreenEvents;
begin

  BValider.OnClick    := ValiderOnClick;
  BImprimer.OnClick   := ImprimerOnClick;
  BLanceReq.OnClick   := LanceReqOnClick;
  BDefinitive.OnClick := BDefinitiveOnClick;

  BPremier.OnClick    := BPremierOnClick;
  BPrecedent.OnClick  := BPrecedentOnClick;
  BSuivant.OnClick    := BSuivantOnClick;
  BDernier.OnClick    := BDernierOnClick;
  //BSaisieConso.OnClick:= BSaisieConsoOnClick;

  Mois.OnExit         := MoisExit;
  ANNEE.OnExit        := AnneeExit;
  DATEARRETEE.onexit  := DateArreteExit;
  CHKALLNAT.OnClick   := CHKAllNatOnClick;
  CHKEngage.OnClick   := CHKEngageOnClick;
  CHKGestionEnPa.OnClick := CHKGestionEnPaOnClick;

  TToolBarbutton97(getControl('BDelete')).onClick := BDeleteClick;
end;

Procedure TOF_BTSAISIERESTDEP.GSOnDblClick(Sender: TObject);
Var TypeRessource : String;
    NatPrestation : String;
    StArgument    : String;
    //
    DateDebut     : TDateTime;
    LDateArrete    : TDateTime;
    //
    LastAutoSearch: boolean;
begin

  //Colonnes : R�alis� Qt� et R�alis� Mt

  TypeRessource := TobGrille.Detail[GS.Row-1].GetString('TYPERESSOURCE');
  NatPrestation := TobGrille.Detail[GS.Row-1].GetString('NATUREPRESTATION');

  //DateDebut  := StrToDAte('01/' + MOIS.text + '/' + ANNEE.Text);
  //DateArrete := StrToDate(DATEARRETEE.Text);
  LDateArrete := IncDay(StrToDate(DATEARRETEE.Text), 1);


  if (JournalConso = 'REALISE') then
  begin
    DateDebut  := idate1900;
    LDateArrete := StrToDate(DATEARRETEE.Text);
  end
  else if (JournalConso = 'DEPUIS')  then
  begin
    DateDebut  := LDateArrete;
    LDateArrete := idate2099;
  end
  else exit;

  StArgument := 'AFFAIRE=' + Affaire.Text;
  StArgument := StArgument + ';DATEDEB=' + DateToStr(DateDebut) + ';DATEFIN=' +DateToStr(LDateArrete);
  StArgument := StArgument + ';FULLSCREEN';

  if (TypeRessource = 'INT') then StArgument := StArgument + ';AVANCE';

  if      (TypeRessource = 'ACH') OR (TypeRessource = 'STK')                            then StArgument := StArgument + ';NATUREMOUV=FOU'
  Else if (TypeRessource = 'AUT') OR (TypeRessource = 'LOC') OR (TypeRessource = 'ST')  then StArgument := StArgument + ';NATUREMOUV=EXT'
  Else if (TypeRessource = 'MAT') OR (TypeRessource = 'OUT')                            then StArgument := StArgument + ';NATUREMOUV=RES'
  Else if  TypeRessource = 'FRA'                                                        then StArgument := StArgument + ';NATUREMOUV=FRS'
  Else if  TypeRessource = 'SAL'                                                        then StArgument := StArgument + ';NATUREMOUV=MO';

  LastAutoSearch := V_PGI.AutoSearch;
  V_PGI.AutoSearch := true;

  AGLLanceFiche('BTP','BTJOUCON','','',StArgument) ;

  V_PGI.AutoSearch := lastautoSearch;

  JournalConso     := '';
   
end;

Procedure TOF_BTSAISIERESTDEP.GSOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
Var Arow  : Integer;
    Acol  : Integer;
    Cancel : Boolean;
begin

  if (Key = VK_RETURN) then
  Begin
    Key := 0;
    ACol := GS.Col;
    Arow := GS.Row;
    Cancel := True;
    CellExit(Self, ACol, ARow, Cancel);
  End;

end;

procedure TOF_BTSAISIERESTDEP.DateArreteExit(Sender: TObject);
var ThisDate : TDateTime;
begin
  Mois.OnExit         := nil;
  ANNEE.OnExit        := nil;
  //
  ThisDate := StrToDate(DATEARRETEE.text);
  FromArrete := true;
  AffecteMoisAnne (thisDate);
  //
  Mois.OnExit         := MoisExit;
  ANNEE.OnExit        := AnneeExit;
end;

Procedure  TOF_BTSAISIERESTDEP.AnneeExit(Sender: TObject);
begin
  ConstitueDateArrete;
end;

Procedure  TOF_BTSAISIERESTDEP.MoisExit(Sender: TObject);
begin
  if StrToInt(mois.text) < 10 then Mois.text := AnsiReplaceStr(Mois.text,'0','');
  if StrToInt(Mois.text) < 1  then Mois.text := '01';
  if StrToInt(Mois.text) > 12 then Mois.text := '12';
  ConstitueDateArrete;
end;

{*
Procedure TOF_BTSAISIERESTDEP.OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  //Gestion de la Touche F9
  if (Key = VK_F9) or (Key = vk_applique) then
  Begin
    Key := 0 ;
    LanceReqOnClick(Self);
  End;

end;
*}

procedure TOF_BTSAISIERESTDEP.ImprimerOnClick(Sender: TObject);
begin

  PrintThisScreen(Tform(Ecran),Ecran.Caption);

end;

procedure TOF_BTSAISIERESTDEP.ValiderOnClick(Sender: TObject);
Var TOBL    : TOB;
    TOBLRAD : TOB;
    Ind     : Integer;
    StSQL   : String;
    ACol    : Integer;
    ARow    : Integer;
    Cancel  : Boolean;
begin

  if TobGrille = nil then exit;

  ACol    := GS.Col;
  ARow    := GS.Row;
  Cancel  := True;

  CellExit(Self, ACol, ARow, Cancel);
  TOBLRAD := TOB.Create('BTRESTEADEP', nil, -1);
  //
  StSQl := 'DELETE FROM BTRESTEADEP WHERE RAD_AFFAIRE="' + AFFAIRE.Text + '" AND '+
           'RAD_DATEARRETEE  ="' + USDATETIME(StrtoDate(DATEARRETEE.text))+ '" ';
  ExecuteSql (StSql);

  For ind := 0 to TOBGRILLE.detail.count -1 do
  begin
    TobL := TOBGrille.detail[Ind];
    //si ligne de titre ou de totaux on sort
    if (TOBL.GetString('TYPELIGNE') = 'TI') OR (TOBL.GetString('TYPELIGNE') = 'ST') Then Continue;
    if (TOBL.GetDouble('RESTEMT') <> 0) or (TOBL.GetDouble('RESTEQTE') <> 0) Or (ValideRADaZero) then
    begin
      MiseAJourRAD(TOBLRAD, TOBL, '-');
    end;
  end;

  TOBLRAD.free;
  Ok_CtrlSaisie := False;

end;

Procedure TOF_BTSAISIERESTDEP.MiseAJourRAD(TOBLRAD, TOBL : TOB; Valide : String);
begin

  TOBLRAD.InitValeurs(false);

  TOBLRAD.PutVALUE('RAD_AFFAIRE',      Affaire.text);
  TOBLRAD.PutVALUE('RAD_ANNEE',        ANNEE.text);
  TOBLRAD.PutVALUE('RAD_MOIS',         MOIS.text);
  TOBLRAD.PutVALUE('RAD_DATEARRETEE',  DATEARRETEE.text);
  TOBLRAD.PutVALUE('RAD_TYPERESSOURCE',TOBL.GetString('TYPERESSOURCE'));
  TOBLRAD.PutVALUE('RAD_NATUREPRES',   TOBL.GetString('NATUREPRESTATION'));
  TOBLRAD.PutVALUE('RAD_ARTICLE',      TOBL.GetString('CODEARTICLE'));
  TOBLRAD.PutVALUE('RAD_QTERESTE',     TOBL.GetDouble('RESTEQTE'));
  TOBLRAD.PutVALUE('RAD_MTRESTE',      TOBL.GetDouble('RESTEMT'));
  TOBLRAD.PutVALUE('RAD_VALIDE',       Valide);

  TOBLRAD.SetAllModifie(True);

  TOBLRAD.InsertDB(nil);

end;

procedure TOF_BTSAISIERESTDEP.BDefinitiveOnClick(Sender: TObject);
Var TOBL : TOB;
    TOBLRAD : TOB;
    Ind   : Integer;
    StSQL : String;
    ACol    : Integer;
    ARow    : Integer;
    Cancel  : Boolean;
begin

  if PGIAsk('D�sirez-vous valider d�finitivement la saisie', 'confirmation')=MrNo then exit;

  if TobGrille = nil then exit;

  ACol    := GS.Col;
  ARow    := GS.Row;
  Cancel  := True;
  CellExit(Self, ACol, ARow, Cancel);
  TOBLRAD := TOB.Create('BTRESTEADEP', nil, -1);
  //
  StSQl := 'DELETE FROM BTRESTEADEP WHERE RAD_AFFAIRE="' + AFFAIRE.Text + '" AND '+
           'RAD_DATEARRETEE  ="' + USDATETIME(StrtoDate(DATEARRETEE.text))+ '" ';
  ExecuteSql (StSql);

  For ind := 0 to TOBGRILLE.detail.count -1 do
  begin
    TobL := TOBGrille.detail[Ind];
    //si ligne de titre ou de totaux on sort
    if (TOBL.GetString('TYPELIGNE') = 'TI') OR (TOBL.GetString('TYPELIGNE') = 'ST') Then Continue;
    if (TOBL.GetDouble('RESTEMT') <> 0) or (TOBL.GetDouble('RESTEQTE') <> 0) Or (ValideRADaZero) then
    begin
      MiseAJourRAD(TOBLRAD, TOBL, 'X');
    end;
  end;
  //
  DestroyTOB;
  //
  GS.Visible := False;

end;

procedure TOF_BTSAISIERESTDEP.LanceReqOnClick(Sender: TObject);
var TOBL     : TOB;
begin

  Action := taCreat;
  SetGrilleEvents (false);

  CHKEngage.Checked := VisuEngage;
  CHKGestionEnPA.Checked := GestionEnPA;

  GS.Enabled := True;
  BImprimer.Visible := True;
  if not BSuivant.Visible then TToolBarbutton97(getControl('BDelete')).visible    := true;
  BDEFINITIVE.Enabled := true;
  BValider.Enabled    := true;

  DestroyTOB;

  OK_LanceReq := True;
  Ok_CtrlSaisie := false;
  if TFVierge(Ecran).ActiveControl <> nil then
  begin
    if TFVierge(Ecran).ActiveControl.Name = 'MOIS' then MoisExit(Self);
  end;
  
  DateArretee.Refresh;

  //FV1 - 16/06/2016 : FS#2051 - GUINIER : modification exceptionnelle d'un reste � d�penser valid� d�finitivement
  RADDefinitf := ControleEnregRAD;
  Ok_ModifRadValide := ExJaiLeDroitConcept(TConcept(bt522),False);

  if RADDefinitf then
  begin
    if Ok_ModifRadValide then
    begin
      Action := taModif;
      GS.Enabled := True;
      BDEFINITIVE.enabled := True;
      BValider.enabled := False;
      TToolBarbutton97(getControl('BDelete')).visible    := false;
    end
    else
    begin
      PGIBox ('Cette saisie est valid�e et ne peut �tre modifi�e');
      Action := taConsult;
      //GS.Enabled := false;
      BDEFINITIVE.enabled := False;
      BValider.enabled := false;
      TToolBarbutton97(getControl('BDelete')).visible    := false;
    end;
  end;
  //
  (*
  DateTemp := StrToDAte('01/' + MOIS.text + '/' + ANNEE.Text);
  DateTemp := FinDeMois(DateTemp);

  DATEARRETEE.text := DateToStr(DateTemp);
  *)

  //cr�ation de l'ensemble des tob de l'Unit.
  CreateTOB;

  if not GS.Visible then GS.Visible := True;

  //remplissage de l'ensemble des TOB qui serviront � remplir la TOB Grille
  RemplitTobIntermediaire;

  //Chargement de la tob qui sera utilis�e pour remplir la grille
  ChargeGrilleWithTobInt;

  //Affichage de la grille
  AfficheLaGrille (True);

  SetGrilleEvents (True);

  //Mois.Enabled  := False;
  //Annee.Enabled := False;

  if Action = taCreat then
  begin
    TOBL := TOBGrille.FindFirst(['TYPELIGNE'], ['LI'], False);
    if TOBL = nil then
      exit
    else
    begin
      GS.col := ColResteQte;
      GS.row := TOBL.GetIndex+1;
      stCell := GS.cells [GS.col ,GS.row];
      GS.SetFocus;
    end;
  end;

end;

Function TOF_BTSAISIERESTDEP.ControleEnregRAD : Boolean;
Var StSQl : String;
Begin

  Result := False;

  //contr�le si la saisie dispo n'est pas d�j� valid�e...
  StSQl := 'SELECT * FROM BTRESTEADEP WHERE RAD_AFFAIRE="' + AFFAIRE.Text + '" AND '+
           'AND RAD_DATEARRETEE  ="' + USDATETIME(StrtoDate(DATEARRETEE.text))+ '" AND '+
           'RAD_VALIDE="X"';

  if ExisteSQL(StSQL) then Result := True;

end;

//initialisation des zones �cran (Ent�te)
procedure TOF_BTSAISIERESTDEP.LectureEnteteAffaire;
Var STSQL : String;
    QQ    : TQuery;
begin

  StSQL := 'SELECT AFF_AFFAIRE, AFF_LIBELLE AS LIBAFFAIRE, AFF_TIERS, T_LIBELLE AS LIBTIERS,';
  StSQL := STSQL + 'AFF_RESPONSABLE, ARS_LIBELLE AS LIBRESPONSABLE, AFF_DATEDEBUT,';
  StSQL := StSQL + 'AFF_DATEFIN, AFF_DESCRIPTIF,AFF_DOMAINE ';
  StSQL := StSQL + 'FROM AFFAIRE LEFT JOIN TIERS ON AFF_TIERS=T_TIERS ';
  StSQl := StSQL + 'LEFT JOIN RESSOURCE ON AFF_RESPONSABLE=ARS_RESSOURCE ';
  StSQL := STSQL + 'WHERE AFF_AFFAIRE = "'+ AFFAIRE.Text +'" AND AFF_ETATAFFAIRE="ACP"';

  QQ := OpenSQL(StSQL, false);
  if QQ.Eof then
    //message d'erreur
  else
  begin
    TobAffaire.SelectDB('',QQ,False);
  end;

end;

procedure TOF_BTSAISIERESTDEP.ChargeEnteteAffaire;
begin

  AFFAIRE.Text := TobAffaire.GetString('AFF_AFFAIRE');
  LIBAFFAIRE.Caption := TobAffaire.GetString('LIBAFFAIRE');

  TIERS.Text := TobAffaire.GetString('AFF_TIERS');
  LIBTIERS.Caption := TobAffaire.GetString('LIBTIERS');

  RESPONSABLE.Text := TobAffaire.GetString('AFF_RESPONSABLE');
  LIBRESPONSABLE.Caption := TobAffaire.GetString('LIBRESPONSABLE');

  DATEDEB.Text := TobAffaire.GetString('AFF_DATEDEBUT');
  DATEFIN.Text := TobAffaire.GetString('AFF_DATEFIN');

  BNAFFAIRE.Text := TobAffaire.GetString('AFF_DESCRIPTIF');
  BNAFFAIRE.Enabled := false;

end;
procedure TOF_BTSAISIERESTDEP.DessineGrille;
var st              : String;
    lestitres       : String;
    lesalignements  : String;
    FF              : String;
    alignement      : String;
    Nam             : String;
    leslargeurs     : String;
    lalargeur       : String;
    letitre         : String;
    lelement        : string;
    //
    Obli            : Boolean;
    OkLib           : Boolean;
    OkVisu          : Boolean;
    OkNulle         : Boolean;
    OkCumul         : Boolean;
    Sep             : Boolean;
    Okimg           : boolean;
    //
    dec             : Integer;
    NbCols          : integer;
    indice          : Integer;
begin
  //
  //Calcul du nombre de Colonnes du Tableau en fonction des noms
  st := fColNamesGS;

  NbCols := 0;

  repeat
    lelement := READTOKENST (st);
    if lelement <> '' then
    begin
      inc(NbCols);
    end;
  until lelement = '';
  //
  GS.ColCount     := Nbcols+1;
  //
  st              := fColNamesGS ;
  lesalignements  := Falignement;
  lestitres       := Ftitre;
  leslargeurs     := fLargeur;

  //Mise en forme des colonnes
  for indice := 0 to Nbcols -1 do
  begin
    Nam := ReadTokenSt (St); // nom
    //
    alignement  := ReadTokenSt(lesalignements);
    lalargeur   := readtokenst(leslargeurs);
    letitre     := readtokenst(lestitres);
    //
    TransAlign(alignement,FF,Dec,Sep,Obli,OkLib,OkVisu,OkNulle,OkCumul) ;
    //
    GS.cells[Indice+1,0]     := leTitre;
    GS.ColNames [Indice+1]   := Nam;
    //
    if      nam = 'RESTEQTE'          then ColResteQte   := Indice+1
    else if nam = 'RESTEMT'           then ColResteMt    := Indice+1
    else if nam = 'REALISEMT'         then ColRealiseMt  := Indice+1
    else if nam = 'REALISEMTPA'       then ColRealiseMtPA:= Indice+1
    else if nam = 'REALISEDEPUISPA'   then ColDepuisMtPA := Indice+1
    else if nam = 'REALISEDEPUIS'     then ColDepuisMt   := Indice+1
    else if nam = 'REALISEQTE'        then ColRealiseQte := Indice+1
    else if nam = 'REALISEQTEDEPUIS'  then ColDepuisQte  := Indice+1
    else if nam = 'BUDGETQTE'         then ColBudgetQte  := Indice+1
    else if nam = 'BUDGETMTPA'        then ColBudgetMTPA := Indice+1
    else if nam = 'BUDGETMT'          then ColBudgetMT   := Indice+1
    else if nam = 'ENGAGE'            then ColEngage     := Indice+1
    else if nam = 'THEOQTE'           then ColTheoQte    := Indice+1
    else if nam = 'THEOMT'            then ColTheoMT     := Indice+1
    else if nam = 'THEOMTPA'          then ColTheoMTPA   := Indice+1
    else if nam = 'FINAFFAIRE'        then ColFinAffaire := Indice+1
    else if nam = 'FINAFFAIREPA'      then ColFinAffairePA := Indice+1
    ;

    //Alignement des cellules
    if copy(Alignement,1,1)='G'       then //Cadr� � Gauche
      GS.ColAligns[indice+1] := taLeftJustify
    else if copy(Alignement,1,1)='D'  then  //Cadr� � Droite
      GS.ColAligns[indice+1] := taRightJustify
    else if copy(Alignement,1,1)='C'  then
      GS.ColAligns[indice+1] := taCenter; //Cadr� au centre

    //Colonne visible ou non
    if OkVisu then
  		GS.ColWidths[indice+1] := strtoint(lalargeur)*GS.Canvas.TextWidth('W')
    else
    	GS.ColWidths[indice+1] := -1;

    //Affichage d'une image ou du texte
    okImg := (copy(Alignement,8,1)='X');
    if (OkLib) or (okImg) then
    begin
    	GS.ColFormats[indice+1] := 'CB=' + Get_Join(Nam);
      if OkImg then
      begin
      	GS.ColDrawingModes[Indice+1]:= 'IMAGE';
      end;
    end;

    if (Dec<>0) or (Sep) then
    begin
    	if OkNulle then
        GS.ColFormats[indice+1] := FF+';; ;' //'#'
      else
      	GS.ColFormats[indice+1] := FF; //'#';
    end;

  end ;

end;

procedure TOF_BTSAISIERESTDEP.DefinieGrid;
begin
  if VisuEngage then
  begin
    if gestionEnpa then
    begin
      // D�finition de la liste de saisie pour la grille D�tail
      fColNamesGS := 'LIBTYPEARTICLE;BUDGETQTE;BUDGETMTPA;REALISEQTE;REALISEMTPA;REALISEQTEDEPUIS;REALISEDEPUISPA;ENGAGE;THEOQTE;THEOMTPA;RESTEQTE;RESTEMT;FINAFFAIREPA';
      Falignement := 'G.0  ---;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-';
      Ftitre := 'Libelle;Budget Qt�;Budget Mt PA;R�alis� Qt�;R�alis� Mt PA;Qt� Depuis;Mt Depuis PA;Engag� Depuis;Th�o. Qt�;Th�o. Mt PA;Reste Qt�;Reste Mt;Fin d''affaire';
      fLargeur := '120;30;30;30;30;30;30;30;30;30;30;30;30';
    end else
    begin
      // D�finition de la liste de saisie pour la grille D�tail
      fColNamesGS := 'LIBTYPEARTICLE;BUDGETQTE;BUDGETMT;REALISEQTE;REALISEMT;REALISEQTEDEPUIS;REALISEDEPUIS;ENGAGE;THEOQTE;THEOMT;RESTEQTE;RESTEMT;FINAFFAIRE';
      Falignement := 'G.0  ---;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-';
      Ftitre := 'Libelle;Budget Qt�;Budget Mt;R�alis� Qt�;R�alis� Mt;Qt� Depuis;Mt Depuis;Engag� Depuis;Th�o. Qt�;Th�o. Mt;Reste Qt�;Reste Mt;Fin d''affaire';
      fLargeur := '120;30;30;30;30;30;30;30;30;30;30;30;30';
    end;
  end else
  begin
    if GestionEnPa then
    begin
      // D�finition de la liste de saisie pour la grille D�tail
      fColNamesGS := 'LIBTYPEARTICLE;BUDGETQTE;BUDGETMTPA;REALISEQTE;REALISEMTPA;REALISEQTEDEPUIS;REALISEDEPUISPA;THEOQTE;THEOMTPA;RESTEQTE;RESTEMT;FINAFFAIREPA';
      Falignement := 'G.0  ---;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-';
      Ftitre := 'Libelle;Budget Qt�;Budget Mt;R�alis� Qt�;R�alis� Mt;Qt� Depuis;Mt Depuis;Th�o. Qt�;Th�o. Mt;Reste Qt�;Reste Mt;Fin d''affaire';
      fLargeur := '120;30;30;30;30;30;30;30;30;30;30;30';
    end else
    begin
      // D�finition de la liste de saisie pour la grille D�tail
      fColNamesGS := 'LIBTYPEARTICLE;BUDGETQTE;BUDGETMT;REALISEQTE;REALISEMT;REALISEQTEDEPUIS;REALISEDEPUIS;THEOQTE;THEOMT;RESTEQTE;RESTEMT;FINAFFAIRE';
      Falignement := 'G.0  ---;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-;D/2  -X-';
      Ftitre := 'Libelle;Budget Qt�;Budget Mt;R�alis� Qt�;R�alis� Mt;Qt� Depuis;Mt Depuis;Th�o. Qt�;Th�o. Mt;Reste Qt�;Reste Mt;Fin d''affaire';
      fLargeur := '120;30;30;30;30;30;30;30;30;30;30;30';
    end;
  end;

end;

procedure TOF_BTSAISIERESTDEP.RemplitTobIntermediaire;
Var DateDebut : TDateTime;
    DateArrete: TDateTime;
Begin

  TobGrille.ClearDetail;

  DateDebut  := StrToDate('01' + '/' + MOIS.Text + '/' + ANNEE.Text);
  DateArrete := IncDay(StrToDate(DATEARRETEE.Text),1);
  //
  if CHKALLNAT.checked = True then ChargeNaturesPrestation;
  //
  ChargementBudget;
  //
  ChargementConsomme(DateDebut, DateArrete);
  //
  if VisuEngage then ChargementEngage(DateArrete);
  //
  ChargementFacturation(DateDebut, DateArrete);
  //
  ChargementRecettesFraisAnnexes(DateDebut, DateArrete);
  //
  ChargementResteADepenser;
  //
  ChargementConsommeDepuis(DateDebut, DateArrete);
  //
  ChargementFactureDepuis(DateDebut, DateArrete);
  //
  ChargementRecettesAnnexesFraisDepuis(DateDebut, DateArrete);
  //
end;

//chargement de la TOBMO, TOBFRAISMO, TOBFournitures, TOBInternes, TOBExternes, TOBSsTraitance, TOBdiverse
//en fonction des natures de prestations existantes
procedure TOF_BTSAISIERESTDEP.ChargeNaturesPrestation;
Var STSQL         : String;
    QQ            : TQuery;
    TOBNatPresta  : TOB;
begin

  //Requ�te de r�cup�ration des zones budget
  StSQl :='SELECT "TYPEELT" = "NATPRESTA", '+
          'BNP_TYPERESSOURCE AS TYPERESSOURCE, '+
          'BNP_NATUREPRES    AS NATUREPRESTATION, '+
          'GA_TYPEARTICLE    AS TYPEARTICLE ' +
          'FROM NATUREPREST  INNER JOIN ARTICLE ' +
          'ON BNP_NATUREPRES=GA_NATUREPRES ' +
          'GROUP BY BNP_NATUREPRES, BNP_TYPERESSOURCE, GA_TYPEARTICLE ' +
          'ORDER BY BNP_NATUREPRES';

  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TOBNatPresta := TOB.Create('NATPRESTA', nil, -1);
    TOBNatPresta.LoadDetailDB('Les NATPRESTA','','',QQ, False);
    DispatchTob(TOBNatPresta);
  end;

  Ferme (QQ);

  FreeAndNil(TOBNatPresta);

end;
Procedure TOF_BTSAISIERESTDEP.ChargementBudgetPrev;
Var STSQL : String;
    QQ        : TQuery;
    TOBBudget : TOB;
begin
  TobBudget := TOB.Create('BUDGET', nil, -1);
  //Requ�te de r�cup�ration des zones budget � partir des pr�visions de chantier
  StSQl := 'SELECT "TYPEELT" = "BUDGET", ' +
           '"TYPERESSOURCE" = CASE GLC_NATURETRAVAIL WHEN "002" THEN "ST" ELSE BNP_TYPERESSOURCE END, '+
           '"NATUREPRESTATION" = CASE GA_NATUREPRES WHEN " " THEN GA_TYPEARTICLE ELSE GA_NATUREPRES END,'+
           'GA_TYPEARTICLE     AS TYPEARTICLE,'+
           'GL_TYPELIGNE       AS TYPELIGNE,'+
           'GL_CODEARTICLE     AS CODEARTICLE,'+
           'GL_LIBELLE         AS LIBELLEART,'+
           'GL_QTEFACT         AS BUDGETQTE,'+
           'GL_QTEFACT*GL_DPA  AS BUDGETMTPA,'+
           'GL_QTEFACT*GL_DPR  AS BUDGETMT,'+
           'GL_AFFAIRE         AS CODEAFFAIRE, '+
           'GL_DPR             AS REVIENT '+
           'FROM LIGNE '+
           'LEFT JOIN ARTICLE ON GA_ARTICLE=GL_ARTICLE '+
           'LEFT JOIN NATUREPREST ON BNP_NATUREPRES=GA_NATUREPRES '+
           'LEFT JOIN LIGNECOMPL  ON GLC_NATUREPIECEG=GL_NATUREPIECEG  AND '+
                'GLC_SOUCHE=GL_SOUCHE AND GLC_NUMERO=GL_NUMERO AND GLC_INDICEG=GL_INDICEG AND '+
                'GLC_NUMORDRE=GL_NUMORDRE '+
           'WHERE GL_NATUREPIECEG = "PBT" AND GL_TYPELIGNE LIKE "AR%" AND GL_AFFAIRE="' + AFFAIRE.Text + '" '+
           'ORDER BY TYPEELT, TYPERESSOURCE, NATUREPRESTATION';

  QQ := OpenSQL(StSQL, False);
  TRY
    If Not QQ.eof then
    begin
      TOBBudget.LoadDetailDB('Le BUDGET','','',QQ, False);
      DispatchTob(TobBudget);
    end;
  FINALLY
    Ferme (QQ);
    FreeAndNil(TobBudget);
  end;
end;

Procedure TOF_BTSAISIERESTDEP.LoadTOBOuvrages (NaturePiece : String; TOBLIGNES,TOBOUVRAGES : TOB);
var QQ : TQuery;
    StSql : string;
    TOBDESOUV : TOB;
begin

  TOBDESOUV := TOB.Create('LES OUV',nil,-1);

  TRY
    StSql := 'SELECT  BLO_NATUREPIECEG,BLO_SOUCHE,BLO_NUMERO,BLO_INDICEG,BLO_NUMLIGNE,BLO_N1,BLO_N2,BLO_N3,BLO_N4,BLO_N5,';
    StSQL := StSQL + 'BLO_TYPEARTICLE,BLO_CODEARTICLE,BLO_LIBELLE,BLO_DPA,BLO_DPR,BLO_AFFAIRE,BLO_QTEDUDETAIL,BLO_QTEFACT,';
    StSQL := StSQL + '"TYPERESSOURCE" = CASE BLO_NATURETRAVAIL WHEN "002" THEN "ST" ELSE BNP_TYPERESSOURCE END, ';
    StSQL := StSQL + '"NATUREPRESTATION" = CASE GA_NATUREPRES WHEN " " THEN GA_TYPEARTICLE ELSE GA_NATUREPRES END,';
    StSQL := StSQL + 'GA_TYPEARTICLE     AS TYPEARTICLE ';
    StSQL := StSQL + ' FROM LIGNEOUV ';
    StSQL := StSQL + ' LEFT JOIN ARTICLE ON GA_ARTICLE=BLO_ARTICLE ';
    StSQL := StSQL + ' LEFT JOIN NATUREPREST ON BNP_NATUREPRES=GA_NATUREPRES ';
    StSQL := StSQL + 'WHERE BLO_NATUREPIECEG = "' + NaturePiece + '" ';
    StSQL := StSQL + '  AND BLO_AFFAIRE="' + AFFAIRE.Text + '" ';
    StSQL := StSQL + 'ORDER BY BLO_NATUREPIECEG,BLO_SOUCHE,BLO_NUMERO,BLO_INDICEG,BLO_NUMLIGNE,BLO_N1,BLO_N2,BLO_N3,BLO_N4,BLO_N5';
    QQ := OpenSQL(StSql,True,-1,'',true);
    TOBDESOUV.LoadDetailDB('LIGNEOUV','','',QQ,false);
    ConstitueOuvrages (TOBLIGNES,TOBDESOUV,TOBOUVRAGES);
  FINALLY
    TOBDESOUV.Free;
  END;

end;

Procedure TOF_BTSAISIERESTDEP.LoadTOBOuvrages (NaturePiece : String; Numero : Integer; TOBLIGNES,TOBOUVRAGES : TOB);
var QQ : TQuery;
    StSql : string;
    TOBDESOUV : TOB;
begin

  TOBDESOUV := TOB.Create('LES OUV',nil,-1);

  TRY
    StSql := 'SELECT  BLO_NATUREPIECEG,BLO_SOUCHE,BLO_NUMERO,BLO_INDICEG,BLO_NUMLIGNE,BLO_N1,BLO_N2,BLO_N3,BLO_N4,BLO_N5,';
    StSQL := StSQL + 'BLO_TYPEARTICLE,BLO_CODEARTICLE,BLO_LIBELLE,BLO_DPA,BLO_DPR,BLO_AFFAIRE,BLO_QTEDUDETAIL,BLO_QTEFACT,';
    StSQl := StSQl + '"TYPERESSOURCE"     = "FRS",';
    StSQL := StSQL + '"NATUREPRESTATION"  = "FRA",';
    StSQL := StSQL + '"TYPEARTICLE"       = "FRA"';
    //StSQL := StSQL + '"NATUREPRESTATION" = CASE GA_NATUREPRES WHEN " " THEN GA_TYPEARTICLE ELSE GA_NATUREPRES END,';
    //StSQL := StSQL + 'GA_TYPEARTICLE AS TYPEARTICLE ';
    StSQL := StSQL + ' FROM LIGNEOUV ';
    StSQL := StSQL + ' LEFT JOIN ARTICLE ON GA_ARTICLE=BLO_ARTICLE ';
    StSQL := StSQL + ' LEFT JOIN NATUREPREST ON BNP_NATUREPRES=GA_NATUREPRES ';
    StSQL := StSQL + 'WHERE BLO_NATUREPIECEG = "' + NaturePiece + '" ';
    StSQL := StSql + '  AND BLO_NUMERO = ' + IntToStr(Numero);
    StSQL := StSQL + '  AND BLO_AFFAIRE="' + AFFAIRE.Text + '" ';
    StSQL := StSQL + 'ORDER BY BLO_NATUREPIECEG,BLO_SOUCHE,BLO_NUMERO,BLO_INDICEG,BLO_NUMLIGNE,BLO_N1,BLO_N2,BLO_N3,BLO_N4,BLO_N5';
    QQ := OpenSQL(StSql,True,-1,'',true);
    TOBDESOUV.LoadDetailDB('LIGNEOUV','','',QQ,false);
    ConstitueOuvrages (TOBLIGNES,TOBDESOUV,TOBOUVRAGES);
  FINALLY
    TOBDESOUV.Free;
  END;

end;

procedure TOF_BTSAISIERESTDEP.ConstitueOuvrages (TOBLIGNES,TOBDESOUV,TOBOUVRAGES : TOB);
var Lig : integer;
    indice : integer;
    TOBLig ,TOBNOuv, TOBPere, TOBnewDet,TOBL : TOB;
    LigneN1,LigneN2,LigneN3,LigneN4,LigneN5 : integer;
    souche : string;
    numero,indiceg : Integer;
    Table : String;
begin

  // Initialisation
  Lig     := 0;
  numero  := 0;
  souche  := '';
  indiceg := 0;

  TOBNouv := nil;
  //
  for Indice := 0 TO TOBDESOUV.detail.count -1 do
  begin
    TOBLig := TOBDESOUV.detail[Indice];
    if (TOBLIg.getValue('BLO_NUMLIGNE') <> lig)      or
       (TOBLIg.getValue('BLO_SOUCHE')   <> Souche)   or
       (TOBLIg.getValue('BLO_NUMERO')   <> Numero) then
    begin
      Lig     := TOBLIg.getValue('BLO_NUMLIGNE');
      numero  := TOBLIg.getValue('BLO_NUMERO');
      Souche  := TOBLIg.getValue('BLO_SOUCHE');
      indiceg := TOBLIg.getValue('BLO_INDICEG');
      // rupture sur un ds crit�res --> donc nouvel ouvrage
      TOBNOuv := TOB.create ('NEW OUV',TOBOUVRAGES,-1);
      TOBNOUV.AddChampSupValeur('SOUCHE',Souche);
      TOBNOUV.AddChampSupValeur('NUMERO',numero);
      TOBNOUV.AddChampSupValeur('INDICE',indiceg);
      TOBNOUV.AddChampSupValeur('LIGNE',Lig);
      TOBL := TOBLIGNES.findFirst(['GL_SOUCHE','GL_NUMERO','GL_INDICEG','GL_NUMLIGNE'],[souche,numero,indiceg,Lig],True);
      if TOBL<> nil then TOBL.putValue('GL_INDICENOMEN',TOBOUVRAGES.detail.count);
    end;
    LigneN1 := TOBLig.GetValue('BLO_N1');
    LigneN2 := TOBLig.GetValue('BLO_N2');
    LigneN3 := TOBLig.GetValue('BLO_N3');
    LigneN4 := TOBLig.GetValue('BLO_N4');
    LigneN5 := TOBLig.GetValue('BLO_N5');

    if LigneN5 > 0 then
    begin
      TOBPere:=TOBNOuv.FindFirst(['BLO_SOUCHE','BLO_NUMERO','BLO_INDICEG','BLO_NUMLIGNE','BLO_N1','BLO_N2','BLO_N3','BLO_N4','BLO_N5'],[souche,numero,indiceg,Lig,LigneN1,LigneN2,LigneN3,LigneN4,0],True) ;
    end else
    if LigneN4 > 0 then
    begin
      TOBPere:=TOBNOuv.FindFirst(['BLO_SOUCHE','BLO_NUMERO','BLO_INDICEG','BLO_NUMLIGNE','BLO_N1','BLO_N2','BLO_N3','BLO_N4','BLO_N5'],[souche,numero,indiceg,Lig,LigneN1,LigneN2,LigneN3,0,0],True) ;
    end else
    if LigneN3 > 0 then
    begin
      TOBPere:=TOBNOuv.FindFirst(['BLO_SOUCHE','BLO_NUMERO','BLO_INDICEG','BLO_NUMLIGNE','BLO_N1','BLO_N2','BLO_N3','BLO_N4','BLO_N5'],[souche,numero,indiceg,Lig,LigneN1,LigneN2,0,0,0],True) ;
    end else
    if LigneN2 > 0 then
    begin
      TOBPere:=TOBNOuv.FindFirst(['BLO_SOUCHE','BLO_NUMERO','BLO_INDICEG','BLO_NUMLIGNE','BLO_N1','BLO_N2','BLO_N3','BLO_N4','BLO_N5'],[souche,numero,indiceg,Lig,LigneN1,0,0,0,0],True) ;
    end else
    begin
      TOBPere:=TOBNOuv;
    end;

    if TOBPere<>Nil then
    BEGIN
       TOBNewDet:=TOB.Create(Table,TOBPere,-1) ;
       TOBNewDet.Dupliquer(TOBLig,False,True) ;
    END;
  end;
end;

Procedure TOF_BTSAISIERESTDEP.ChargementBudgetBCE;
Var STSQL : String;
    QQ        : TQuery;
    TOBBudget,TOBLIGNES,TOBOUVRAGES,TOBLIGNESO : TOB;
begin

  TobBudget := TOB.Create('BUDGET', nil, -1);
  TOBLIGNES := TOB.Create ('LES BUUDD',nil,-1);
  TOBOUVRAGES := TOB.Create ('LES OUV',nil,-1);
  TOBLIGNESO := TOB.Create ('LES LIGNES',nil,-1);

  TRY
    //Requ�te de r�cup�ration des zones budget � partir des Contres etudes
    StSQl := 'SELECT "TYPEELT" = "BUDGET", ' +
             '"TYPERESSOURCE" = CASE GLC_NATURETRAVAIL WHEN "002" THEN "ST" ELSE BNP_TYPERESSOURCE END, '+
             '"NATUREPRESTATION" = CASE GA_NATUREPRES WHEN " " THEN GA_TYPEARTICLE ELSE GA_NATUREPRES END,'+
             'GA_TYPEARTICLE     AS TYPEARTICLE,'+
             'GL_TYPELIGNE       AS TYPELIGNE,'+
             'GL_CODEARTICLE     AS CODEARTICLE,'+
             'GL_LIBELLE         AS LIBELLEART,'+
             'GL_QTEFACT         AS BUDGETQTE,'+
             'ROUND(GL_QTEFACT*GL_DPA,4)  AS BUDGETMTPA,'+
             'ROUND(GL_QTEFACT*GL_DPR,4)  AS BUDGETMT,'+
             'GL_AFFAIRE         AS CODEAFFAIRE, '+
             'GL_DPR             AS REVIENT '+
             'FROM LIGNE LEFT JOIN ARTICLE ON GA_ARTICLE=GL_ARTICLE '+
             'LEFT JOIN NATUREPREST ON BNP_NATUREPRES=GA_NATUREPRES '+
             'LEFT JOIN LIGNECOMPL  ON GLC_NATUREPIECEG=GL_NATUREPIECEG  AND '+
             'GLC_SOUCHE=GL_SOUCHE AND GLC_NUMERO=GL_NUMERO AND GLC_INDICEG=GL_INDICEG AND GLC_NUMORDRE=GL_NUMORDRE '+
             'WHERE GL_NATUREPIECEG = "BCE" AND GL_TYPELIGNE="ART" AND '+
             '((NOT GL_TYPEARTICLE IN ("OUV","ARP")) OR (GL_INDICENOMEN=0)) AND '+
             'GL_AFFAIRE="' + AFFAIRE.Text + '" '+
             'ORDER BY TYPEELT, TYPERESSOURCE, NATUREPRESTATION';

    QQ := OpenSQL(StSQL, False);
    TRY
      If Not QQ.eof then
      begin
        TOBBudget.LoadDetailDB('Le BUDGET','','',QQ, False);
      end;
    FINALLY
      ferme (QQ);
    End;
    //
    StSQl := 'SELECT '+
             'GL_NATUREPIECEG,GL_SOUCHE,GL_NUMERO,GL_INDICEG,GL_NUMLIGNE,GL_NUMORDRE,GL_INDICENOMEN,GL_QTEFACT '+
             'FROM LIGNE '+
             'WHERE GL_NATUREPIECEG = "BCE" AND GL_TYPELIGNE = "ART" AND '+
             '(GL_TYPEARTICLE IN ("OUV","ARP")) AND (GL_INDICENOMEN <> 0) AND '+
             'GL_AFFAIRE="' + AFFAIRE.Text + '" ORDER BY GL_NATUREPIECEG,GL_SOUCHE,GL_NUMERO,GL_INDICEG,GL_NUMLIGNE';

    QQ := OpenSQL(StSQL, False);
    TRY
      If Not QQ.eof then
      begin
        TOBLIGNESO.LoadDetailDB('LIGNE','','',QQ, False);
        TRY
          LoadTOBOuvrages ('BCE', TOBLIGNESO,TOBOUVRAGES);
          TraitelesOuvrages (TOBLIGNESO,TOBOUVRAGES,TOBBudget);
        finally
          TOBLIGNESO.ClearDetail; // optimisation m�moire
        end;
      end;
    FINALLY
      ferme (QQ);
    End;
    DispatchTob(TobBudget);

  FINALLY
    TobBudget.free;
    TOBLIGNES.free;
    TOBOUVRAGES.free;
    TOBLIGNESO.free;
  end;
end;

//FV1 : 04/02/2016 - FS#1890 - TEAM RESEAUX : En saisie restes � d�penser, ajouter les frais de chantier en budget
Procedure TOF_BTSAISIERESTDEP.RecuperationPieceFrais;
Var STSQL       : String;
    QQ          : TQuery;
    Ind         : Integer;
    TobPiece    : TOB;
    PieceFrais  : string;
    NumPieceFRC : string;
    DatePiece   : String;
    Nature      : String;
    Souche      : String;
    Numero      : Integer;
    //Indice      : Integer;
begin

  TobPiece := TOB.Create('PIECES', nil, -1);

  //Requ�te de r�cup�ration du numero de Pi�ce de frais sur contre-Etude
  StSQl := 'SELECT GP_PIECEFRAIS ' +
           'FROM PIECE WHERE GP_NATUREPIECEG = "BCE" AND GP_AFFAIRE="' + AFFAIRE.Text + '" ';

  QQ := OpenSQL(StSQL, False);

  TRY
    If Not QQ.eof then
    begin
      TOBPiece.LoadDetailDB('La PIECE','','',QQ, False);
    end;
  FINALLY
    ferme (QQ);
  End;

  NumPieceFRC := '';

  //Traitement du Tobpi�ce pour lecture des lignes de frais
  For ind := 0 to TOBPIECE.Detail.count -1 do
  begin
    PieceFrais := TOBPIECE.detail[ind].GetString('GP_PIECEFRAIS');
    if PieceFrais <> '' then
    begin
      //d�compostion de piece frais
      //On passe � lecture des lignes de frais pour chargement du budget...
      DatePiece := ReadTokenSt(PieceFrais);
      Nature    := ReadTokenSt(PieceFrais);
      Souche    := ReadTokenSt(PieceFrais);
      Numero    := StrToInt(ReadTokenSt(PieceFrais));
      //Indice    := StrToInt(ReadTokenSt(PieceFrais));
      if NumPieceFRC = '' then
        NumPieceFRC := 'in (' + IntToStr(Numero)
      else
        NumPieceFRC := NumPieceFRC + ',' + IntToStr(Numero);
    end;
  end;

  if NumPieceFRC <> '' then
  begin
    NumPieceFRC := NumPieceFRC + ') ';
    ChargementBudgetFrais(NumPieceFRC);
  end;

  FreeAndNil(TOBPIECE);

end;

Procedure TOF_BTSAISIERESTDEP.ChargementBudgetFrais(PieceFrais : string);
Var StSQl       : string;
    QQ          : TQuery;
    TOBBudget   : TOB;

begin

  //on cr�e les TOBs qui vont bien...
  TobBudget := TOB.Create('BUDGET', nil, -1);

  //lecture des lignes pour chargement du budget frais sur chantier
  TRY
    StSQl := 'SELECT "TYPEELT" = "BUDGET", ';
    StSQl := StSQl + '"FRC"               AS TYPERESSOURCE,';
    StSQL := StSQL + '"FRA"               AS NATUREPRESTATION,';
    StSQL := StSQL + '"FRA"               AS TYPEARTICLE,';
    StSQl := StSQl + 'SUM(GP_TOTALHTDEV)  AS BUDGETMTPA ';
    StSQl := StSQl + 'FROM piece ';
    StSQl := StSQl + 'WHERE GP_NATUREPIECEG = "FRC"  AND GP_SOUCHE  = "FRC" ';
    StSQl := StSQl + '  AND GP_NUMERO '   + PieceFrais;
    StSQl := StSQl + '  AND GP_AFFAIRE="' + AFFAIRE.Text + '" ';
    StSQl := StSQl + 'ORDER BY TYPEELT, TYPERESSOURCE, NATUREPRESTATION';
    //
    QQ := OpenSQL(StSQL, False);
    TRY
      If Not QQ.eof then
      begin
        TOBBudget.LoadDetailDB('Le BUDGET','','',QQ, False);
      end;
    FINALLY
      ferme (QQ);
    End;

    DispatchTob(TobBudget);

  finally
    TobBudget.free;
  end;

end;

//chargement de la TOBMO, TOBFRAISMO, TOBFournitures, TOBInternes, TOBExternes, TOBSsTraitance, TOBdiverse
Procedure TOF_BTSAISIERESTDEP.ChargementBudget;
begin
  budgetDepuis := THValComboBox(getControl('BUDGETDEPUIS')).Value;
  if BudgetDepuis ='001' then
  begin
    // chargement du budget depuis la pr�vision de chantier
    ChargementBudgetPrev;
  end else if BudgetDepuis ='002' then
  begin
    // chargement du budget depuis la contre etude
    ChargementBudgetBCE;
    // chargement du budget depuis les frais de chantier associ�s aux contre etude
    RecuperationPieceFrais;
  end;
end;

//FV1 : 17/09/2013 - FS#657 - BAGE : En reste � d�penser, montant de facturation incorrect (le montant r�alis� doit prendre en compte la somme des recettes annexes)
//Chargement des Recettes Annexes
Procedure TOF_BTSAISIERESTDEP.ChargementRecettesFraisAnnexes(DateDebut, DateArrete : TDateTime);
Var STSQL   : String;
    QQ      : TQuery;
    i       : Integer;
    TOBFact : TOB;
begin
  TobFact := TOB.Create('FACTURE', nil, -1);

  //Chargement des recettes annexes pour cumul dans facturation budget...
  StSQl := 'SELECT "TYPEELT" = "FACRAN", ' +
           '"TYPERESSOURCE"  = "FAC",' +
           'SUM(BCO_MONTANTHT)*-1 AS FACTURE, ' +
           'SUM(BCO_MONTANTPR)*-1 AS REVIENT  ' +
           'FROM CONSOMMATIONS '+
//           'LEFT JOIN ARTICLE ON GA_ARTICLE= BCO_ARTICLE ' +
           'WHERE BCO_DATEMOUV < "' + UsDateTime(DateArrete) + '" '+
           'AND BCO_NATUREPIECEG NOT IN ("CF","BLF","BFA","FF","LFR","LCR") ' +
           'AND BCO_TRANSFORME="-" AND BCO_TRAITEVENTE<>"X" ' +
           //FV1 : 17/09/2013 - FS#657 - BAGE : En reste � d�penser, montant de facturation incorrect (le montant r�alis� doit prendre en compte la somme des recettes annexes)
           'AND BCO_NATUREMOUV IN ("RAN") '+
           'AND BCO_AFFAIRE ="' + AFFAIRE.Text + '" ';

  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TobFact.LoadDetailDB('Le FACTURE','','',QQ, False);
    For i := 0 TO TobFact.Detail.count -1 do
    Begin
      if TobFact.Detail[i].GeTDouble('FACTURE') <> 0 then
        ChargeTob(TobFact.Detail[i], TOBFacturation,'Facturation', 'FAC')
    end;
  end;

  Ferme (QQ);
  TobFact.ClearDetail;

   //Chargement des recettes annexes pour cumul dans facturation budget...
  StSQl := 'SELECT "TYPEELT" = "FACFAN", ' +
           '"TYPERESSOURCE"  = "AUT",' +
           'SUM(BCO_MONTANTHT) AS FACTURE, ' +
           'SUM(BCO_MONTANTPR) AS REVIENT  ' +
           'FROM CONSOMMATIONS '+
//           'LEFT JOIN ARTICLE ON GA_ARTICLE= BCO_ARTICLE ' +
           'WHERE BCO_DATEMOUV < "' + UsDateTime(DateArrete) + '" '+
           'AND BCO_NATUREPIECEG NOT IN ("CF","BLF","BFA","FF","LFR","LCR") ' +
           'AND BCO_TRANSFORME="-" AND BCO_TRAITEVENTE<>"X" ' +
           //FV1 : 17/09/2013 - FS#657 - BAGE : En reste � d�penser, montant de facturation incorrect (le montant r�alis� doit prendre en compte la somme des recettes annexes)
           'AND BCO_NATUREMOUV IN ("FAN") '+
           'AND BCO_AFFAIRE ="' + AFFAIRE.Text + '" ';

  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TobFact.LoadDetailDB('Le FACTURE','','',QQ, False);
    For i := 0 TO TobFact.Detail.count -1 do
    Begin
      if TobFact.Detail[i].GeTDouble('FACTURE') <> 0 then
        ChargeTob(TobFact.Detail[i], TOBDiverse,'D�penses Diverses', 'DEP')
    end;
  end;

  Ferme (QQ);

  TOBfact.Free;
end;

//FV1 : 17/09/2013 - FS#657 - BAGE : En reste � d�penser, montant de facturation incorrect (le montant r�alis� doit prendre en compte la somme des recettes annexes)
//Chargement des Recettes Annexes Depuis
Procedure TOF_BTSAISIERESTDEP.ChargementRecettesAnnexesFraisDepuis(DateDebut, DateArrete : TDateTime);
Var STSQL   : String;
    QQ      : TQuery;
    i       : Integer;
    TOBFact : TOB;
begin

  TobFact := TOB.Create('FACTURE', nil, -1);
  //Chargement des recettes annexes pour cumul dans facturation depuis...
  StSQl := 'SELECT "TYPEELT" = "FACRANDEPUIS", ' +
           '"TYPERESSOURCE"  = "FAC",' +
           'SUM(BCO_MONTANTHT)*-1 AS FACTURE, ' +
           'SUM(BCO_MONTANTPR)*-1 AS REVIENT ' +
           'FROM CONSOMMATIONS LEFT JOIN ARTICLE ON GA_ARTICLE= BCO_ARTICLE ' +
           'WHERE BCO_DATEMOUV >= "' + UsDateTime(DateArrete) + '" '+
           'AND BCO_NATUREPIECEG NOT IN ("CF","BLF","BFA","FF","LFR","LCR") ' +
           'AND BCO_TRANSFORME="-" AND BCO_TRAITEVENTE<>"X" ' +
           'AND BCO_NATUREMOUV IN ("RAN") '+
           'AND BCO_AFFAIRE ="' + AFFAIRE.Text + '"';

  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TobFact.LoadDetailDB('Le FACTURE','','',QQ, False);
    For i := 0 TO TobFact.Detail.count -1 do
    Begin
      if TobFact.Detail[i].GeTDouble('FACTURE') <> 0 then
        ChargeTob(TobFact.Detail[i], TOBFacturation,'Facturation', 'FAC')
    end;
  end;

  Ferme (QQ);
  TobFact.ClearDetail;

  //Chargement des recettes annexes pour cumul dans facturation depuis...
  StSQl := 'SELECT "TYPEELT" = "FACFANDEPUIS", ' +
           '"TYPERESSOURCE"  = "AUT",' +
           'SUM(BCO_MONTANTHT) AS FACTURE, ' +
           'SUM(BCO_MONTANTPR) AS REVIENT ' +
           'FROM CONSOMMATIONS LEFT JOIN ARTICLE ON GA_ARTICLE= BCO_ARTICLE ' +
           'WHERE BCO_DATEMOUV >= "' + UsDateTime(DateArrete) + '" '+
           'AND BCO_NATUREPIECEG NOT IN ("CF","BLF","BFA","FF","LFR","LCR") ' +
           'AND BCO_TRANSFORME="-" AND BCO_TRAITEVENTE<>"X" ' +
           'AND BCO_NATUREMOUV IN ("FAN") '+
           'AND BCO_AFFAIRE ="' + AFFAIRE.Text + '"';

  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TobFact.LoadDetailDB('Le FACTURE','','',QQ, False);
    For i := 0 TO TobFact.Detail.count -1 do
    Begin
      if TobFact.Detail[i].GeTDouble('FACTURE') <> 0 then
        ChargeTob(TobFact.Detail[i], TOBDiverse,'D�penses Annexes', 'DEP')
    end;
  end;

  Ferme (QQ);
  TOBFact.Free;

end;

//Chargement du consomm�
Procedure TOF_BTSAISIERESTDEP.ChargementConsomme(DateDebut, DateArrete : TDateTime);
Var STSQL : String;
    QQ        : TQuery;
    TOBConso  : TOB;
begin
  TobConso := TOB.Create('CONSOMME', nil, -1);

  //chargement d'une ligne Stock m�me si nous n'avons rien � afficher !!!!
  STSQL := 'SELECT "TYPEELT" = "STOCK", "TYPERESSOURCE" = "", "NATUREPRESTATION" = "MAR", "TYPEARTICLE" = "MAR"';
  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TRY
      TobConso.LoadDetailDB('Le CONSOMME','','',QQ, False);
      DispatchTob(TobConso);
    FINALLY
      TOBConso.ClearDetail;
    END;
  end;

  Ferme (QQ);


  //chargement d'une ligne achat m�me si nous n'avons rien � afficher !!!!
  STSQL := 'SELECT "TYPEELT" = "CONSO", "TYPERESSOURCE" = "", "NATUREPRESTATION" = "MAR", "TYPEARTICLE" = "MAR"';
  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TRY
      TobConso.LoadDetailDB('Le CONSOMME','','',QQ, False);
      DispatchTob(TobConso);
    FINALLY
      TOBConso.ClearDetail;
    END;
  end;

  //Chargement du consomm� Main d'oeuvre Principalement
  StSQl := 'SELECT "TYPEELT" = "CONSO", ' +
           '(SELECT ARS_TYPERESSOURCE FROM RESSOURCE WHERE ARS_RESSOURCE=BCO_RESSOURCE) AS TYPERESSOURCE, ' +
           '"NATUREPRESTATION" = CASE GA_NATUREPRES WHEN " " THEN GA_TYPEARTICLE ELSE GA_NATUREPRES END,'+
           'GA_TYPEARTICLE AS TYPEARTICLE,'+
           'BCO_ARTICLE    AS CODEARTICLE,'+
           'BCO_LIBELLE    AS LIBELLEART,'+
           'BCO_MONTANTACH AS BUDGETMTPA,'+
           'BCO_MONTANTPR  AS BUDGETMT,'+
           'BCO_QUANTITE   AS QUANTITE,'+
           'BCO_DPR        AS REVIENT, '+
           'BCO_AFFAIRE    AS CODEAFFAIRE '+
           'FROM CONSOMMATIONS LEFT JOIN ARTICLE ON GA_ARTICLE= BCO_ARTICLE ' +
           'WHERE BCO_DATEMOUV < "' + UsDateTime(DateArrete) + '" '+
           'AND BCO_NATUREPIECEG NOT IN ("CF","BLF","BFA","FF","LFR","LCR") AND BCO_TRANSFORME="-" AND BCO_TRAITEVENTE<>"X" ' +
           //FV1 : 17/09/2013 - FS#657 - BAGE : En reste � d�penser, montant de facturation incorrect (le montant r�alis� doit prendre en compte la somme des recettes annexes)
           'AND BCO_NATUREMOUV NOT IN ("FOU", "RAN", "FAN") '+
           'AND BCO_AFFAIRE ="' + AFFAIRE.Text + '" '+
           'ORDER BY TYPEELT, TYPERESSOURCE, NATUREPRESTATION';
  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TRY
      TobConso.LoadDetailDB('Le CONSOMME','','',QQ, False);
      DispatchTob(TobConso);
    FINALLY
      TOBConso.ClearDetail;
    END;
  end;

  Ferme (QQ);
  //Chargement du Consomm� Achat
  StSQl := 'SELECT "TYPEELT" = "CONSOFOU", ' +
           '(SELECT ARS_TYPERESSOURCE FROM RESSOURCE WHERE ARS_RESSOURCE=BCO_RESSOURCE) AS TYPERESSOURCE, ' +
           '"NATUREPRESTATION" = CASE GA_NATUREPRES WHEN "" THEN GA_TYPEARTICLE ELSE GA_NATUREPRES END,'+
           'GA_TYPEARTICLE AS TYPEARTICLE,'+
           'BCO_ARTICLE    AS CODEARTICLE, '+
           'BCO_LIBELLE    AS LIBELLEART,'+
           'BCO_MONTANTACH AS BUDGETMTPA, ' +
           'BCO_MONTANTPR  AS BUDGETMT, ' +
           'BCO_QUANTITE   AS QUANTITE, ' +
           'BCO_DPR        AS REVIENT, ' +
           'BCO_AFFAIRE    AS CODEAFFAIRE, '+
           'GL_NATUREPIECEG,'+
           'GL_PIECEPRECEDENTE, '+
           'GL_PIECEORIGINE '+
           'FROM CONSOMMATIONS '+
           'LEFT JOIN LIGNE ON GL_NATUREPIECEG= BCO_NATUREPIECEG ' +
           'AND GL_SOUCHE= BCO_SOUCHE ' +
           'AND GL_NUMERO= BCO_NUMERO AND GL_NUMORDRE= BCO_NUMORDRE ' +
           'LEFT JOIN ARTICLE AA ON GA_ARTICLE=BCO_ARTICLE WHERE ' +
           'BCO_TRANSFORME="-" AND BCO_NATUREPIECEG NOT IN ("CF","CFR","BLF","LFR","BFA","FF") '+
           'AND BCO_DATEMOUV < "' + UsDateTime(DateArrete) + '" '+
           'AND BCO_AFFAIRE ="' + AFFAIRE.text + '" AND BCO_NATUREMOUV = "FOU"';
  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TobConso.LoadDetailDB('Le CONSOMME','','',QQ, False);
    DispatchTob(TobConso);
  end;

  FreeAndNil(TobConso);

end;

Procedure TOF_BTSAISIERESTDEP.ChargementFacturation(DateDebut, DateArrete : TDateTime);
Var STSQL, NaturePiece     : String;
    QQ        : TQuery;
    i         : Integer;
    TOBFact   : TOB;
begin
  if BudgetDepuis ='002' then NaturePiece := 'BCE'
  else NaturePiece := 'DBT';

  TobFact := TOB.Create('FACTURE', nil, -1);
  //Chargement de la TOb Facturation pour chargement Budget
  StSQl := 'SELECT "TYPEELT" = "FACB", ' +
           '"TYPERESSOURCE" = "FAC", ' +
           'SUM(GP_TOTALHTDEV) AS FACTURE, ' +
           'SUM(GP_MONTANTPR)  AS REVIENT FROM PIECE ' +
           'WHERE GP_NATUREPIECEG = "' + NaturePiece+ '" AND GP_AFFAIRE="' + AFFAIRE.text + '" ' +
           '  AND GP_DATEPIECE < "' + UsDateTime(DateArrete) + '" ';

  //FV1 : 17/09/2013 - FS#657 - BAGE : En reste � d�penser, montant de facturation incorrect (le montant budget de facturation ne doit pas prendre les devis en cours)
  if NaturePiece = 'DBT' then
    StSQL := StSQL + '  AND (SELECT AFF_ETATAFFAIRE FROM AFFAIRE WHERE AFF_AFFAIRE = GP_AFFAIREDEVIS) <> "ENC" ';

  StSQL := StSQL + 'GROUP BY GP_NATUREPIECEG';

  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TobFact.LoadDetailDB('Le FACTURE','','',QQ, False);
    For i := 0 TO TobFact.Detail.count -1 do
    Begin
      ChargeTob(TobFact.Detail[i], TOBFacturation,'Facturation', 'FAC')
    end;
  end;

  Ferme (QQ);
  TOBFact.ClearDetail;

  //Chargement de la TOb Facturation Pour chargement Conso (R�alis�)
  StSQl := 'SELECT "TYPEELT" = "FACR", ' +
           '"TYPERESSOURCE" = "FAC", ' +
           'SUM(GP_TOTALHTDEV) AS FACTURE, ' +
           'SUM(GP_MONTANTPR)  AS REVIENT FROM PIECE ' +
           'WHERE GP_NATUREPIECEG IN ("FBT", "ABT") AND GP_AFFAIRE="' + AFFAIRE.text + '" ' +
           '  AND GP_DATEPIECE < "' + UsDateTime(DateArrete) + '" '+
           'GROUP BY GP_NATUREPIECEG';

  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TobFact.LoadDetailDB('Le FACTURE','','',QQ, False);
    For i := 0 TO TobFact.Detail.count -1 do
    Begin
      ChargeTob(TobFact.Detail[i], TOBFacturation,'Facturation', 'FAC')
    end;
  end;

  Ferme (QQ);

  FreeAndNil(Tobfact);

end;

//chargement de la TOB Reste � D�penser (cas de la modification sinon blanc)
Procedure TOF_BTSAISIERESTDEP.ChargementResteADepenser;
VAR StSQL     : String;
    QQ        : TQuery;
begin

  StSQl := 'SELECT "TYPEELT" = "REST", ' +
           'RAD_TYPERESSOURCE AS TYPERESSOURCE, ' +
           'RAD_NATUREPRES    AS NATUREPRESTATION, ' +
           'RAD_ARTICLE       AS CODEARTICLE, GA_LIBELLE AS LIBELLEART,'+
           'RAD_QTERESTE      AS QTERESTE,'+
           'RAD_MTRESTE       AS MTRESTE,'+
           'RAD_AFFAIRE       AS CODEAFFAIRE '+
           ' FROM BTRESTEADEP LEFT JOIN ARTICLE ON GA_ARTICLE=RAD_ARTICLE '+
           ' LEFT JOIN NATUREPREST ON BNP_NATUREPRES=RAD_NATUREPRES '+
           'WHERE RAD_AFFAIRE="' + AFFAIRE.Text + '" AND ' +
           'RAD_DATEARRETEE  ="' + USDATETIME(StrtoDate(DATEARRETEE.text))+ '" '+
           'ORDER BY TYPEELT, TYPERESSOURCE, NATUREPRESTATION';

  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TOBRAD.LoadDetailDB('RESTEADEP','','',QQ, False);
    DispatchTob(TOBRAD);
  end;

  Ferme (QQ);

end;

Procedure TOF_BTSAISIERESTDEP.ChargementConsommeDepuis(DateDebut, DateArrete : TDateTime);
Var STSQL     : String;
    QQ        : TQuery;
    TOBConso  : TOB;
begin

  TobConso := TOB.Create('CONSOMME', nil, -1);
//  DateArrete := IncDay(DateArrete, 1);

  //Chargement du consomm� Main d'oeuvre depuis
  StSQl := 'SELECT "TYPEELT" = "CONSODEPUIS", ' +
           '(SELECT ARS_TYPERESSOURCE FROM RESSOURCE WHERE ARS_RESSOURCE=BCO_RESSOURCE) AS TYPERESSOURCE, ' +
           '"NATUREPRESTATION" = CASE GA_NATUREPRES WHEN " " THEN GA_TYPEARTICLE ELSE GA_NATUREPRES END,'+
           'GA_TYPEARTICLE AS TYPEARTICLE,'+
           'BCO_ARTICLE    AS CODEARTICLE,'+
           'BCO_LIBELLE    AS LIBELLEART,'+
           'BCO_MONTANTACH AS BUDGETMTPA,'+
           'BCO_MONTANTPR  AS BUDGETMT,'+
           'BCO_QUANTITE   AS QUANTITE,'+
           'BCO_DPR        AS REVIENT, '+
           'BCO_AFFAIRE    AS CODEAFFAIRE '+
           'FROM CONSOMMATIONS LEFT JOIN ARTICLE ON GA_ARTICLE= BCO_ARTICLE ' +
           'WHERE BCO_DATEMOUV >= "' + UsDateTime(DateArrete) + '" '+
           'AND BCO_NATUREPIECEG NOT IN ("CF","CFR","BLF","LFR","BFA","FF") ' +
           'AND BCO_TRANSFORME="-" ' +
           //FV1 : 17/09/2013 - FS#657 - BAGE : En reste � d�penser, montant de facturation incorrect (le montant budget de facturation ne doit pas prendre les devis en cours)
           'AND BCO_NATUREMOUV NOT IN ("FOU", "RAN", "FAN") '+
           'AND BCO_AFFAIRE ="' + AFFAIRE.Text + '"'+
           'ORDER BY TYPEELT, TYPERESSOURCE, NATUREPRESTATION';

  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TobConso.LoadDetailDB('Le CONSOMME','','',QQ, False);
    DispatchTob(TobConso);
  end;

  Ferme (QQ);
  TOBConso.ClearDetail;
  //Chargement du Consomm� Achat
  StSQl := 'SELECT "TYPEELT" = "CONSOFOUDEPUIS", ' +
           '(SELECT ARS_TYPERESSOURCE FROM RESSOURCE WHERE ARS_RESSOURCE=BCO_RESSOURCE) AS TYPERESSOURCE, ' +
           '"NATUREPRESTATION" = CASE GA_NATUREPRES WHEN "" THEN GA_TYPEARTICLE ELSE GA_NATUREPRES END,'+
           'GA_TYPEARTICLE AS TYPEARTICLE,'+
           'BCO_ARTICLE    AS CODEARTICLE, '+
           'BCO_LIBELLE    AS LIBELLEART,'+
           'BCO_MONTANTACH AS BUDGETMTPA, ' +
           'BCO_MONTANTPR  AS BUDGETMT, ' +
           'BCO_QUANTITE   AS QUANTITE, ' +
           'BCO_DPR        AS REVIENT, ' +
           'BCO_AFFAIRE    AS CODEAFFAIRE, '+
           'GL_NATUREPIECEG,'+
           'GL_PIECEPRECEDENTE, '+
           'GL_PIECEORIGINE '+
           'FROM CONSOMMATIONS '+
           'LEFT JOIN LIGNE ON GL_NATUREPIECEG= BCO_NATUREPIECEG ' +
           'AND GL_SOUCHE= BCO_SOUCHE ' +
           'AND GL_NUMERO= BCO_NUMERO AND GL_NUMORDRE= BCO_NUMORDRE ' +
           'LEFT JOIN ARTICLE AA ON GA_ARTICLE=BCO_ARTICLE WHERE ' +
           'BCO_TRANSFORME="-" AND BCO_NATUREPIECEG NOT IN ("CF","CFR","BLF","LFR","BFA","FF") '+
           'AND BCO_DATEMOUV >= "' + UsDateTime(DateArrete) + '" '+
           'AND BCO_AFFAIRE ="' + AFFAIRE.text + '" AND BCO_NATUREMOUV = "FOU"';
  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TobConso.LoadDetailDB('Le CONSOMME','','',QQ, False);
    DispatchTob(TobConso);
  end;

  FreeAndNil(TobConso);

end;

Procedure TOF_BTSAISIERESTDEP.ChargementFactureDepuis(DateDebut, DateArrete : TDateTime);
Var STSQL     : String;
    QQ        : TQuery;
    i         : Integer;
    TOBFact   : TOB;
begin

{  Modif BRL 18/10/2013 : inutile pour l'instant
  //Chargement de la TOb Facturation realise depuis
  StSQl := 'SELECT "TYPEELT" = "FACBDEPUIS", ' +
           '"TYPERESSOURCE" = "FAC", ' +
           'SUM(GP_TOTALHTDEV) AS FACTURE, ' +
           'SUM(GP_MONTANTPR)  AS REVIENT FROM PIECE ' +
           'WHERE GP_NATUREPIECEG IN ("DBT") AND GP_AFFAIRE="' + AFFAIRE.text + '" ' +
           '  AND GP_DATEPIECE > "' + UsDateTime(DateArrete) + '" '+
           //FV1 : 17/09/2013 - FS#657 - BAGE : En reste � d�penser, montant de facturation incorrect (le montant budget de facturation ne doit pas prendre les devis en cours)
           '  AND (SELECT AFF_ETATAFFAIRE FROM AFFAIRE WHERE AFF_AFFAIRE = GP_AFFAIREDEVIS) <> "ENC" ' +
           'GROUP BY GP_NATUREPIECEG';

  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TobFact := TOB.Create('FACTURE', nil, -1);
    TobFact.LoadDetailDB('Le FACTURE','','',QQ, False);
    For i := 0 TO TobFact.Detail.count -1 do
    Begin
      ChargeTob(TobFact.Detail[i], TOBFacturation,'Facturation', 'FAC')
    end;
  end;

  Ferme (QQ);
}

  TobFact := TOB.Create('FACTURE', nil, -1);
  //Chargement de la TOb Facturation Pour chargement Conso (R�alis�)
  StSQl := 'SELECT "TYPEELT" = "FACRDEPUIS", ' +
           '"TYPERESSOURCE" = "FAC", ' +
           'SUM(GP_TOTALHTDEV) AS FACTURE, ' +
           'SUM(GP_MONTANTPR)  AS REVIENT FROM PIECE ' +
           'WHERE GP_NATUREPIECEG IN ("FBT", "ABT") AND GP_AFFAIRE="' + AFFAIRE.text + '" ' +
           '  AND GP_DATEPIECE >= "' + UsDateTime(DateArrete) + '" '+
           'GROUP BY GP_NATUREPIECEG';

  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TobFact.LoadDetailDB('Le FACTURE','','',QQ, False);
    For i := 0 TO TobFact.Detail.count -1 do
    Begin
      ChargeTob(TobFact.Detail[i], TOBFacturation,'Facturation', 'FAC')
    end;
  end;

  Ferme (QQ);

  FreeAndNil(Tobfact);

end;

Procedure TOF_BTSAISIERESTDEP.DispatchTob(TobDispatch : TOB);
var i     : Integer;
    TOBL  : TOB;
    STSQL : String;
    QQ    : TQuery;
    //TypeRessource : string;
    TypeElt : string;
    //Mt : double;
begin

  For i:= 0 TO TobDispatch.Detail.count -1 do
  Begin
    TOBL := TobDispatch.Detail[i];
    TypeElt := TOBL.getString('TYPEELT');
    // ----- LS
    TOBL.SetString('TYPERESSOURCE',     trim(TOBL.GetSTring('TYPERESSOURCE')));
    TOBL.SetString('NATUREPRESTATION',  trim(TOBL.GetSTring('NATUREPRESTATION')));
    TOBL.SetString('TYPEARTICLE',       trim(TOBL.GetSTring('TYPEARTICLE')));
    // --
    //dans certain cas en conso (quand on vient de la saisie des Achats)
    //le type de ressource n'est pas renseign� ce qui dispatch les valeurs
    //dans les mauvaises zones de la grille. Pour �viter cela
    //on lit la nature de prestation pour r�cup�rer le type de ressource
    //Dans les autres cas (Budget) on ne change rien.
    //MT := TOBL.GetDouble('BUDGETMT');

    if (TypeElt='CONSOFOU') or (TypeElt='CONSOFOUDEPUIS') then
    begin
      // d�termination si stock ou pas pour les conso fourniture
      if Pos (TOBL.GetString('GL_NATUREPIECEG'),'LBT;FBC;BLC')>0 then
      begin
        if not IsLivChantier(TOBL.GetString('GL_PIECEPRECEDENTE'),TOBL.GetString('GL_PIECEORIGINE')) then
        begin
          if TypeElt = 'CONSOFOU' then TOBL.setString('TYPEELT','STOCK') else
          if TypeElt = 'CONSOFOUDEPUIS' then TOBL.setString('TYPEELT','STOCKDEPUIS') else
        end
        else
        begin
          if TypeElt = 'CONSOFOU' then TOBL.setString('TYPEELT','CONSO') else
          if TypeElt = 'CONSOFOUDEPUIS' then TOBL.setString('TYPEELT','CONSODEPUIS') else
        end;
      end
      else if TOBL.GetString('GL_NATUREPIECEG')='' then
      begin
          if TypeElt = 'CONSOFOU' then TOBL.setString('TYPEELT','STOCK') else
          if TypeElt = 'CONSOFOUDEPUIS' then TOBL.setString('TYPEELT','STOCKDEPUIS') else
      end
      else
      begin
          if TypeElt = 'CONSOFOU' then TOBL.setString('TYPEELT','CONSO') else
          if TypeElt = 'CONSOFOUDEPUIS' then TOBL.setString('TYPEELT','CONSODEPUIS') else
      end;
    end;

    if (TOBL.GetString('TYPEELT')= 'CONSO') OR (TOBL.GetString('TYPEELT') = 'CONSODEPUIS') then
    begin
      IF TOBL.GetString('TYPEARTICLE')='PRE' then
      Begin
        STSQL := 'SELECT BNP_TYPERESSOURCE AS TYPERESSOURCE FROM NATUREPREST WHERE BNP_NATUREPRES="' + TOBL.GetString('NATUREPRESTATION') + '"';
        QQ    := OpenSQL(StSQL, False);
        If Not QQ.eof then TOBL.PutValue('TYPERESSOURCE', QQ.FindField('TYPERESSOURCE').AsString);
        Ferme(QQ);
      end;
    end;

    if TOBL.GetSTring('TYPERESSOURCE') = 'FAC' then
      ChargeTob(TOBL, TOBFacturation, 'Facturation', 'FAC')   //Facturation (???)
    else if TOBL.GetSTring('TYPERESSOURCE') = 'SAL' then      //Main d'Oeuvre
    begin
      if TOBL.GetSTring('NATUREPRESTATION') = 'FRA' then
        ChargeTob(TOBL, TOBFraisMO, 'Frais Main d''Oeuvre', 'SAL')
      else
        ChargeTob(TOBL, TOBMO, 'Main d''Oeuvre', 'SAL');
    end
    Else If TOBL.GetSTring('TYPERESSOURCE') = 'ST' then  //Sous-Traitantce
    Begin
      if TOBL.GetSTring('NATUREPRESTATION') = 'FRA' then
        ChargeTob(TOBL, TOBDiverse,'D�penses Diverses', 'DEP')
      Else
        ChargeTob(TOBL, TOBSsTraitance,'Sous-Traitance', 'DEP');
    end
    Else If TOBL.GetSTring('TYPERESSOURCE') = 'MAT' then //Mat�riels Internes
    Begin
      if TOBL.GetSTring('NATUREPRESTATION') = 'FRA' then
        ChargeTob(TOBL, TOBDiverse,'D�penses Diverses', 'DEP')
      Else
        ChargeTob(TOBL, TOBInternes,'Mat�riels Internes', 'DEP');
    end
    Else IF TOBL.GetString('TYPERESSOURCE') = 'AUT' then //Diverses
    Begin
      ChargeTob(TOBL, TOBDiverse,'D�penses Diverses', 'DEP');
    end
    Else IF TOBL.GetString('TYPERESSOURCE') = 'LOC' then //Prestation Externes
    begin
      if TOBL.GetSTring('NATUREPRESTATION') = 'FRA' then
        ChargeTob(TOBL, TOBDiverse,'D�penses Diverses', 'DEP')
      Else
        ChargeTob(TOBL, TOBExternes, 'Mat�riels Externes', 'DEP');
    end
    Else IF TOBL.GetString('TYPERESSOURCE') = 'INT' then //Main d'Oeuvre Interim
    begin
      if TOBL.GetSTring('NATUREPRESTATION') = 'FRA' then
        ChargeTob(TOBL, TOBFraisMO, 'Frais Main d''Oeuvre', 'SAL')
      Else
        ChargeTob(TOBL, TOBMO, 'Main d''Oeuvre', 'SAL');
    end
    Else IF TOBL.GetString('TYPERESSOURCE') = 'OUT' then
    Begin
      if TOBL.GetSTring('NATUREPRESTATION') = 'FRA' then //Mat�riels Internes
        ChargeTob(TOBL, TOBDiverse,'D�penses Diverses', 'DEP')
      Else
        ChargeTob(TOBL, TOBInternes,'Mat�riels Internes', 'DEP');
    end
    Else IF TOBL.GetString('TYPERESSOURCE') = 'FRC' then
    Begin
      if TOBL.GetSTring('NATUREPRESTATION') = 'FRA' then //Frais sur Chantier
        ChargeTob(TOBL, TOBFraisCh,'Frais de Chantier', 'FRA');
    end
    Else
    begin
      if TOBL.GetSTring('NATUREPRESTATION') = 'FRA' then //Fournitures
      begin
        //ChargeTob(TOBL, TOBDiverse,'D�penses Diverses', 'DEP')
        TOBL.PutValue('TYPERESSOURCE', 'SAL');
        ChargeTob(TOBL, TOBFraisMO, 'Frais Main d''Oeuvre', 'SAL');
      end
      Else
      begin
        ChargeTob(TOBL, TOBFournitures, 'Fournitures', 'DEP');
      end;
    end;
  end;

end;

Procedure TOF_BTSAISIERESTDEP.ChargeTob(TOBL, TOBMere : TOB; TheTitre, TypeTotal : String);
Var TOBIntLig   : TOB;
    LibNatPresta: String;
Begin

  If TobMere.detail.count =0 then
  Begin
    TOBMere.AddChampSupValeur ('TYPEELT',       TOBL.GetString('TYPEELT'));
    TOBMere.AddChampSupValeur ('TYPERESSOURCE', TOBL.GetString('TYPERESSOURCE'));
    TOBMere.AddChampSupValeur ('TITRE', TheTitre);
  end;
  //
  TOBIntLig := Tob.Create('LES LIGNES', TOBMere, -1);
  //
  CreateZoneTobIntermediaire(TOBIntLig);
  //
  TOBIntLig.PutValue('TYPEELT',          TOBL.GetString('TYPEELT'));
  TOBIntLig.PutValue('TYPERESSOURCE',    TOBL.GetString('TYPERESSOURCE'));

  if (TOBL.GetString('TYPEELT') = 'FACB') or
     (TOBL.GetString('TYPEELT') = 'FACR') OR
//   (TOBL.GetString('TYPEELT') = 'FACBDEPUIS') OR   // Modif BRL 18/10/2013 : inutile pour l'instant
     (TOBL.GetString('TYPEELT') = 'FACRDEPUIS') Then
  begin
    TOBIntLig.PutValue('NATUREPRESTATION', 'FAC');
    TOBIntLig.PutValue('LIBNATPRESTATION', 'Facturation');
    TOBIntLig.PutValue('TYPEARTICLE',      '');
    TOBIntLig.PutValue('CODEARTICLE',      '');
    TOBIntLig.PutValue('LIBELLEART',       '');
  end
  Else
  if (TOBL.GetString('TYPEELT') = 'FACRAN') OR
//   (TOBL.GetString('TYPEELT') = 'FACBDEPUIS') OR   // Modif BRL 18/10/2013 : inutile pour l'instant
     (TOBL.GetString('TYPEELT') = 'FACRANDEPUIS') Then
  begin
    TOBIntLig.PutValue('NATUREPRESTATION', 'RAN');
    TOBIntLig.PutValue('LIBNATPRESTATION', 'Recettes Annexes');
    TOBIntLig.PutValue('TYPEARTICLE',      '');
    TOBIntLig.PutValue('CODEARTICLE',      '');
    TOBIntLig.PutValue('LIBELLEART',       '');
  end
  Else
  if (TOBL.GetString('TYPEELT') = 'FACFAN') OR
//   (TOBL.GetString('TYPEELT') = 'FACBDEPUIS') OR   // Modif BRL 18/10/2013 : inutile pour l'instant
     (TOBL.GetString('TYPEELT') = 'FACFANDEPUIS') Then
  begin
    TOBIntLig.PutValue('NATUREPRESTATION', 'FAN');
    TOBIntLig.PutValue('LIBNATPRESTATION', 'D�penses Annexes');
    TOBIntLig.PutValue('TYPEARTICLE',      '');
    TOBIntLig.PutValue('CODEARTICLE',      '');
    TOBIntLig.PutValue('LIBELLEART',       '');
  end
  Else
  begin
    LibNatPresta := '';
    //Si article en prix pos� on force � marchandise
    if TOBL.GetString('NATUREPRESTATION') = 'ARP' then
      TOBIntLig.PutValue('NATUREPRESTATION', 'MAR')
    else
      TOBIntLig.PutValue('NATUREPRESTATION', TOBL.GetString('NATUREPRESTATION'));

    //Gestion du Libell� de la nature de prestation
    LibNatPresta :=  RechDom('BTNATPRESTATION',TOBL.GetString('NATUREPRESTATION') ,False);

    if TOBL.GetString('TYPERESSOURCE')='' then
    begin
      if TOBL.GetString('NATUREPRESTATION') = 'FRA' then
        LibNatPresta := 'D�penses Diverses'
      Else
      begin
        if (TOBL.GetString('TYPEELT') = 'STOCK') or (TOBL.GetString('TYPEELT') = 'STOCKDEPUIS') then
        begin
          TOBIntLig.PutValue('TYPERESSOURCE', 'STK');
          LibNatPresta := 'Stocks';
        end
        else
        begin
          TOBIntLig.PutValue('TYPERESSOURCE','ACH');
          LibNatPresta := 'Achats';
        end;
      end;
    end;

    if TOBL.GetString('TYPERESSOURCE') = 'INT' then
      LibNatPresta := RechDom('GCTYPEARTICLE',TOBL.GetString('NATUREPRESTATION') ,False) + ' ' + RechDom('AFTTYPERESSOURCE', TOBL.GetString('TYPERESSOURCE'), False);

    if LibNatPresta = '' then
    begin
      LibNatPresta := RechDom('GCTYPEARTICLE',TOBL.GetString('NATUREPRESTATION') ,False);
    end;

    TOBIntLig.PutValue('LIBNATPRESTATION', LibNatPresta);

    TOBIntLig.PutValue('TYPEARTICLE',     TOBL.GetString('TYPEARTICLE'));
    TOBIntLig.PutValue('CODEARTICLE',     TOBL.GetString('CODEARTICLE'));
    TOBIntLig.PutValue('LIBELLEART',      TOBL.GetString('LIBELLEART'));
  end;

  TOBIntLig.PutValue('RESTEQTE',0);
  TOBIntLig.PutValue('RESTEMT',0);

  if TOBL.GetString('TYPEELT') = 'BUDGET' then
  Begin
    if ((TOBL.GetString('TYPERESSOURCE')= 'SAL') OR (TOBL.GetString('TYPERESSOURCE') = 'INT')) AND
        (TOBL.GetString('NATUREPRESTATION') <> 'FRA') then
      TOBIntLig.PutValue('BUDGETQTE',     TOBL.GetDouble('BUDGETQTE'));
    //
    TOBIntLig.PutValue('BUDGETMTPA',      TOBL.GetDouble('BUDGETMTPA'));
    TOBIntLig.PutValue('BUDGETMT',        TOBL.GetDouble('BUDGETMT'));
  end
  Else if TOBL.GetString('TYPEELT') = 'CONSO' then
  Begin
    if ((TOBL.GetString('TYPERESSOURCE')= 'SAL') OR (TOBL.GetString('TYPERESSOURCE') = 'INT')) AND
        (TOBL.GetString('NATUREPRESTATION') <> 'FRA') then
      TOBIntLig.PutValue('REALISEQTE',    TOBL.GetDouble('QUANTITE'));
    //
    TOBIntLig.PutValue('REALISEMTPA',     TOBL.GetDouble('BUDGETMTPA'));
    TOBIntLig.PutValue('REALISEMT',       TOBL.GetDouble('BUDGETMT'));
  end
  Else if TOBL.GetString('TYPEELT') = 'ENGAGE' then
  Begin
    TOBIntLig.PutValue('ENGAGE',          TOBL.GetDouble('ENGAGE'));
  end
  Else if (TOBL.GetString('TYPEELT') = 'STOCK') then
  begin
    if ((TOBL.GetString('TYPERESSOURCE')= 'SAL') OR (TOBL.GetString('TYPERESSOURCE') = 'INT')) AND
        (TOBL.GetString('NATUREPRESTATION') <> 'FRA') then
      TOBIntLig.PutValue('REALISEQTE',    TOBL.GetDouble('QUANTITE'));
    //
    TOBIntLig.PutValue('REALISEMTPA',     TOBL.GetDouble('BUDGETMTPA'));
    TOBIntLig.PutValue('REALISEMT',       TOBL.GetDouble('BUDGETMT'));
  end
  else if TOBL.GetString('TYPEELT') = 'CONSODEPUIS' then
  begin
    if ((TOBL.GetString('TYPERESSOURCE')= 'SAL') OR (TOBL.GetString('TYPERESSOURCE') = 'INT')) AND
        (TOBL.GetString('NATUREPRESTATION') <> 'FRA') then
      TOBIntLig.PutValue('REALISEQTEDEPUIS',TOBL.GetDouble('QUANTITE'));
    TOBIntLig.PutValue('REALISEDEPUISPA',   TOBL.GetDouble('BUDGETMTPA'));
    TOBIntLig.PutValue('REALISEDEPUIS',     TOBL.GetDouble('BUDGETMT'));
  end
  else if TOBL.GetString('TYPEELT') = 'STOCKDEPUIS' then
  begin
    if ((TOBL.GetString('TYPERESSOURCE')= 'SAL') OR (TOBL.GetString('TYPERESSOURCE') = 'INT')) AND
        (TOBL.GetString('NATUREPRESTATION') <> 'FRA') then
      TOBIntLig.PutValue('REALISEQTEDEPUIS',TOBL.GetDouble('QUANTITE'));
    TOBIntLig.PutValue('REALISEDEPUISPA',   TOBL.GetDouble('BUDGETMTPA'));
    TOBIntLig.PutValue('REALISEDEPUIS',     TOBL.GetDouble('BUDGETMT'));
  end
  Else if TOBL.GetString('TYPEELT') = 'FACB' then
  begin
    TOBIntLig.PutValue('BUDGETMTPA',      TOBL.GetDouble('FACTURE'));
    TOBIntLig.PutValue('BUDGETMT',        TOBL.GetDouble('FACTURE'));
  end
  Else If (TOBL.GetSTring('TYPEELT') = 'FACR') or
          (TOBL.GetSTring('TYPEELT') = 'FACRAN')  or
          (TOBL.GetSTring('TYPEELT') = 'FACFAN') Then
  begin
    TOBIntLig.PutValue('REALISEMTPA',     TOBL.GetDouble('FACTURE'));
    TOBIntLig.PutValue('REALISEMT',       TOBL.GetDouble('FACTURE'));
  end
{  Modif BRL 18/10/2013 : inutile pour l'instant
  Else if TOBL.GetString('TYPEELT') = 'FACBDEPUIS' then
  begin
    TOBIntLig.PutValue('REALISEDEPUIS',  TOBL.GetDouble('FACTURE'));
  end
}
  Else If (TOBL.GetSTring('TYPEELT') = 'FACRDEPUIS') or
          (TOBL.GetSTring('TYPEELT') = 'FACRANDEPUIS') or
          (TOBL.GetSTring('TYPEELT') = 'FACFANDEPUIS') Then
  begin
    TOBIntLig.PutValue('REALISEDEPUISPA', TOBL.GetDouble('FACTURE'));
    TOBIntLig.PutValue('REALISEDEPUIS',   TOBL.GetDouble('FACTURE'));
  end
  Else if TOBL.GetString('TYPEELT') = 'REST' then
  begin
    TOBIntLig.PutValue('LIBNATPRESTATION', TheTitre);
    TOBIntLig.PutValue('RESTEQTE',        TOBL.GetDouble('QTERESTE'));
    TOBIntLig.PutValue('RESTEMT',         TOBL.GetDouble('MTRESTE'));
  end;

  TOBIntLig.PutValue('THEORIQUEQTE',  0);
  TOBIntLig.PutValue('THEORIQUEMTPA',   0);
  TOBIntLig.PutValue('THEORIQUEMT',   0);
  TOBIntLig.PutValue('RESTEFINAFF',0);
  //
  TOBIntLig.PutValue('CODEAFFAIRE',AFFAIRE.Text);
  TOBIntLig.PutValue('DATEARRETE',DATEARRETEE.Text);
  TOBIntLig.PutValue('VALIDE','-');
  TOBIntLig.PutValue('TYPETOTAL', TypeTotal);

end;

procedure TOF_BTSAISIERESTDEP.ChargeGrilleWithTobInt;
Var indice  : Integer;
begin

  //chargement de la grille avec les Budgets MO (TOBMO)
  if (TOBMO <> nil) then
  begin
     if TOBMO.Detail.count > 0 then
    begin
      CreateLigneTitreToGrille(TOBMO);
      For indice := 0 to TobMO.detail.count -1 do
      begin
        CreateLigneToGrille(TOBMO.detail[indice]);
      end;
    end;
  end;

  //chargement de la grille avec les Frais de MO (TOBFraisMO)
  if (TOBFraisMO <> nil) then
  begin
    if TOBFraisMO.Detail.count > 0 then
    begin
      CreateLigneTitreToGrille(TOBFraisMO);
      For indice := 0 to TOBFraisMO.detail.count -1 do
      begin
        CreateLigneToGrille(TOBFraisMO.detail[indice]);
        //If Indice = TOBFraisMO.detail.count -1 then
      end;
    end;
  end;

  CreateLigneSsTotalToGrille('Sous-Total Main d''Oeuvre', 'SAL');

  //chargement de la grille avec les Fournitures (TOBFournitures)
  if (TOBFournitures <> nil) then
  begin
    if TOBFournitures.Detail.count > 0 then
    begin
      CreateLigneTitreToGrille(TOBFournitures);
      For indice := 0 to TOBFournitures.detail.count -1 do
      begin
        if Trim(TOBFournitures.detail[indice].GetString('NATUREPRESTATION'))='' then
          TOBFournitures.detail[indice].SetString('NATUREPRESTATION','MAR');
        CreateLigneToGrille(TOBFournitures.detail[indice]);
      end;
    end;
  end;

  //chargement de la grille avec les Mat�riels Internes (TOBInternes)
  if (TOBInternes <> nil) then
  begin
    if TOBInternes.Detail.count > 0 then
    begin
      CreateLigneTitreToGrille(TOBInternes);
      For indice := 0 to TOBInternes.detail.count -1 do
      begin
        CreateLigneToGrille(TOBInternes.detail[indice]);
      end;
    end;
  end;

  //chargement de la grille avec les Mat�riels Externes (TOBExternes)
  if (TOBExternes <> nil) then
  begin
    if TObExternes.Detail.count > 0 then
    begin
      CreateLigneTitreToGrille(TOBExternes);
      For indice := 0 to TOBExternes.detail.count -1 do
      begin
        CreateLigneToGrille(TOBExternes.detail[indice]);
      end;
    end;
  end;

  //chargement de la grille avec les Sous-Traitants (TOBSsTraitance)
  if (TOBSsTraitance <> nil) then
  begin
    if TOBSsTraitance.Detail.count > 0 then
    begin
      CreateLigneTitreToGrille(TOBSsTraitance);
      For indice := 0 to TOBSsTraitance.detail.count -1 do
      begin
        CreateLigneToGrille(TOBSsTraitance.detail[indice]);
      end;
    end;
  end;

  //chargement de la grille avec les D�penses Diverses (TOBDiverse)
  if (TOBdiverse <> nil) then
  begin
    if TOBdiverse.Detail.count > 0 then
    begin
      CreateLigneTitreToGrille(TOBdiverse);
      For indice := 0 to TOBdiverse.detail.count -1 do
      begin
        CreateLigneToGrille(TOBdiverse.detail[indice]);
      end;
    end;
  end;

  CreateLigneSsTotalToGrille('Sous-Total D�penses', 'DEP');
  CreateLigneSsTotalToGrille('Total D�penses', 'TEP');

  //chargement de la grille avec les Frais de chantier (TobFraisCH)
  if (TobFraisCH <> nil) then
  begin
    if TobFraisCH.Detail.count > 0 then
    begin
      CreateLigneSsTotalToGrille('Frais de Chantier', 'FRC');
      For indice := 0 to TobFraisCH.detail.count -1 do
      begin
        CreateLigneTotal(TobFraisCH.detail[indice]);
      end;
    end;
  end;

  //
  if CHKPROVISION then CreateLigneSsTotalToGrille('Provisions', 'PRV');

  CreateLigneSsTotalToGrille('Total Prix de Revient', 'DPR');

  //chargement de la grille avec les Facturations (TOBFacturation)
  if (TOBFacturation <> nil) then
  begin
    if TOBFacturation.Detail.count = 0 then ChargementLigneVide(TOBFacturation, 'Facturation', 'FAC');
    //if TOBFacturation.Detail.count > 0 then
    //begin
      CreateLigneTitreToGrille(TOBFacturation);
      For indice := 0 to TOBFacturation.detail.count -1 do
      begin
        CreateLigneToGrille(TOBFacturation.detail[indice]);
      end;
    //end;
  end;
  //
  CreateLigneSsTotalToGrille('Marge (PV-PR)', 'MRG');


  TotalisationColonnes;

end;

procedure TOF_BTSAISIERESTDEP.ChargementLigneVide(TOBMere : TOB; TheTitre, TypeTob : String);
Var TobLigne : Tob;
begin

  if TobMere.Detail.count =0 then
  begin
    TOBMere.AddChampSupValeur ('TYPEELT',       TypeTob);
    TOBMere.AddChampSupValeur ('TYPERESSOURCE', TypeTob);
    TOBMere.AddChampSupValeur ('TITRE',         TheTitre);
  end;
  //
  TOBLigne := Tob.Create('LES LIGNES', TOBMere, -1);
  //
  CreateZoneTobIntermediaire(TOBLigne);
  //
  TobLigne.PutValue('TYPEELT',          TypeTob);
  TobLigne.PutValue('TYPERESSOURCE',    TypeTob);

  TobLigne.PutValue('NATUREPRESTATION', TypeTob);
  TobLigne.PutValue('LIBNATPRESTATION', TheTitre);
  TobLigne.PutValue('TYPEARTICLE',      '');
  TobLigne.PutValue('CODEARTICLE',      '');
  TobLigne.PutValue('LIBELLEART',       '');

  TobLigne.PutValue('THEORIQUEQTE',  0);
  TobLigne.PutValue('THEORIQUEMTPA',   0);
  TobLigne.PutValue('THEORIQUEMT',   0);
  TobLigne.PutValue('RESTEFINAFF',0);
  //
  TobLigne.PutValue('CODEAFFAIRE',AFFAIRE.Text);
  TobLigne.PutValue('DATEARRETE',DATEARRETEE.Text);
  TobLigne.PutValue('VALIDE','-');
  TobLigne.PutValue('TYPETOTAL', TypeTob);
             
end;

Procedure TOF_BTSAISIERESTDEP.TotalisationColonnes;
begin

  //calcul des colonnes th�orique et fin affaire
  CalculColGrille;

  //Calcul Total Main D'oeuvre et Total D�penses Diverses
  CalculSsTot('SAL');
  CalculSsTot('DEP');

  Calcultotaldepenses;

  ChargeSsTot('TEP');

  //Calcul de la ligne de Prix de revient
  CalculDPR;

  //Calcul de la ligne de marge
  CalculMarge;

  ChargeSsTot('DPR');
  ChargeSsTot('MRG');

end;


Procedure TOF_BTSAISIERESTDEP.Calcultotaldepenses;
Var TOBL : TOB;
begin

  TotalBudgetTDEP    := 0; TotalBudgetTDEPPA    := 0;
  TotalRealiseTDEP   := 0; TotalRealiseTDEPPA   := 0;
  TotalReaDepuisTDEP := 0; TotalReaDepuisTDEPPA := 0;
  TotalTheoTDEP      := 0; TotalTheoTDEPPA      := 0;
  TotalResteTDEP     := 0;
  TotalFinAffTDEP    := 0; TotalFinAffTDEPPA    := 0;
  TotalEngageTDEP    := 0;

  TOBL := TobGrille.FindFirst(['TYPELIGNE','TYPERESSOURCE'],['ST','SAL'], False);

  if TOBL <> nil then
  begin
    TotalBudgetTDEP := TotalBudgetTDEP + TOBL.GetDouble('BUDGETMT');
    TotalRealiseTDEP:= TotalRealiseTDEP+ TOBL.GetDouble('REALISEMT');
    TotalReaDepuisTDEP := TotalReaDepuisTDEP + TOBL.GetDouble('REALISEDEPUIS');
    TotalTheoTDEP   := TotalTheoTDEP   + TOBL.GetDouble('THEOMT');
    TotalResteTDEP  := TotalResteTDEP  + TOBL.GetDouble('RESTEMT');
    TotalFinAffTDEP := TotalFinAffTDEP + TOBL.GetDouble('FINAFFAIRE');
    //
    if CoefFGFromDomaine then
    begin
      TotalBudgetTDEPPA := TotalBudgetTDEPPA + TOBL.GetDouble('BUDGETMTPA');;
      TotalRealiseTDEPPA:= TotalRealiseTDEPPA + TOBL.GetDouble('REALISEMTPA');
      TotalReaDepuisTDEPPA := TotalReaDepuisTDEPPA + TOBL.GetDouble('REALISEDEPUISPA');
      TotalTheoTDEPPA   := TotalTheoTDEPPA+ TOBL.GetDouble('THEOMTPA');
      TotalFinAffTDEPPA := TotalFinAffTDEPPA+ TOBL.GetDouble('FINAFFAIREPA')
    end else
    begin
      TotalBudgetTDEPPA := TotalBudgetTDEP;
      TotalRealiseTDEPPA:= TotalRealiseTDEP;
      TotalReaDepuisTDEPPA := TotalReaDepuisTDEP;
      TotalTheoTDEPPA   := TotalTheoTDEP;
      TotalFinAffTDEPPA := TotalFinAffTDEP;
    end;
  end;

  TOBL := TobGrille.FindFirst(['TYPELIGNE','TYPERESSOURCE'],['ST','DEP'], False);

  if TOBL <> nil then
  begin
    TotalBudgetTDEP := TotalBudgetTDEP + TOBL.GetDouble('BUDGETMT');
    TotalRealiseTDEP:= TotalRealiseTDEP+ TOBL.GetDouble('REALISEMT');
    TotalEngageTDEP := TotalEngageTDEP+ TOBL.GetDouble('ENGAGE');
    TotalReaDepuisTDEP := TotalReaDepuisTDEP + TOBL.GetDouble('REALISEDEPUIS');
    TotalTheoTDEP   := TotalTheoTDEP   + TOBL.GetDouble('THEOMT');
    TotalResteTDEP  := TotalResteTDEP  + TOBL.GetDouble('RESTEMT');
    TotalFinAffTDEP := TotalFinAffTDEP + TOBL.GetDouble('FINAFFAIRE');
    //
    if CoefFGFromDomaine then
    begin
      TotalBudgetTDEPPA := TotalBudgetTDEPPA + TOBL.GetDouble('BUDGETMTPA');;
      TotalRealiseTDEPPA:= TotalRealiseTDEPPA + TOBL.GetDouble('REALISEMTPA');
      TotalReaDepuisTDEPPA := TotalReaDepuisTDEPPA + TOBL.GetDouble('REALISEDEPUISPA');
      TotalTheoTDEPPA   := TotalTheoTDEPPA+ TOBL.GetDouble('THEOMTPA');
      TotalFinAffTDEPPA := TotalFinAffTDEPPA+ TOBL.GetDouble('FINAFFAIREPA')
    end else
    begin
      TotalBudgetTDEPPA := TotalBudgetTDEP;
      TotalRealiseTDEPPA:= TotalRealiseTDEP;
      TotalReaDepuisTDEPPA := TotalReaDepuisTDEP;
      TotalTheoTDEPPA   := TotalTheoTDEP;
      TotalFinAffTDEPPA := TotalFinAffTDEP;
    end;
  end;
end;


Procedure TOF_BTSAISIERESTDEP.CalculDPR;
Var TOBL : TOB;
begin

  TotalBudgetDPR      := 0;
  TotalBudgetDPRPA    := 0;
  TotalRealiseDPR     := 0;
  TotalRealiseDPRPA   := 0;
  TotalReaDepuisDPR   := 0;
  TotalReaDepuisDPRPA := 0;
  TotalTheoDPR        := 0;
  TotalTheoDPRPA      := 0;
  TotalResteDPR       := 0;
  TotalFinAffDPR      := 0;
  TotalFinAffDPRPA    := 0;
  TotalEngageDpr      := 0;

  TOBL := TobGrille.FindFirst(['TYPELIGNE','TYPERESSOURCE'],['ST','SAL'], False);

  if TOBL <> nil then
  begin
    TotalBudgetDPR    := TotalBudgetDPR + TOBL.GetDouble('BUDGETMT');
    TotalRealiseDPR   := TotalRealiseDPR+ TOBL.GetDouble('REALISEMT');
    TotalReaDepuisDPR := TotalReaDepuisDPR + TOBL.GetDouble('REALISEDEPUIS');
    TotalTheoDPR      := TotalTheoDPR   + TOBL.GetDouble('THEOMT');
    TotalResteDPR     := TotalResteDPR  + TOBL.GetDouble('RESTEMT');
    TotalFinAffDPR    := TotalFinAffDPR + TOBL.GetDouble('FINAFFAIRE');
    //
    if CoefFGFromDomaine then
    begin
      TotalBudgetDPRPA    := TotalBudgetDPRPA + TOBL.GetDouble('BUDGETMTPA');;
      TotalRealiseDPRPA   := TotalRealiseDPRPA + TOBL.GetDouble('REALISEMTPA');
      TotalReaDepuisDPRPA := TotalReaDepuisDPRPA + TOBL.GetDouble('REALISEDEPUISPA');
      TotalTheoDPRPA      := TotalTheoDPRPA+ TOBL.GetDouble('THEOMTPA');
      TotalFinAffDPRPA    := TotalFinAffDPRPA+ TOBL.GetDouble('FINAFFAIREPA')
    end else
    begin
      TotalBudgetDPRPA    := TotalBudgetDPR;
      TotalRealiseDPRPA   := TotalRealiseDPR;
      TotalReaDepuisDPRPA := TotalReaDepuisDPR;
      TotalTheoDPRPA      := TotalTheoDPR;
      TotalFinAffDPRPA    := TotalFinAffDPR;
    end;
  end;

  TOBL := TobGrille.FindFirst(['TYPELIGNE','TYPERESSOURCE'],['ST','DEP'], False);

  if TOBL <> nil then
  begin
    TotalBudgetDPR    := TotalBudgetDPR + TOBL.GetDouble('BUDGETMT');
    TotalRealiseDPR   := TotalRealiseDPR+ TOBL.GetDouble('REALISEMT');
    TotalEngageDpr    := TotalEngageDpr+ TOBL.GetDouble('ENGAGE');
    TotalReaDepuisDPR := TotalReaDepuisDPR + TOBL.GetDouble('REALISEDEPUIS');
    TotalTheoDPR      := TotalTheoDPR   + TOBL.GetDouble('THEOMT');
    TotalResteDPR     := TotalResteDPR  + TOBL.GetDouble('RESTEMT');
    TotalFinAffDPR    := TotalFinAffDPR + TOBL.GetDouble('FINAFFAIRE');
    //
    if CoefFGFromDomaine then
    begin
      TotalBudgetDPRPA    := TotalBudgetDPRPA + TOBL.GetDouble('BUDGETMTPA');;
      TotalRealiseDPRPA   := TotalRealiseDPRPA + TOBL.GetDouble('REALISEMTPA');
      TotalReaDepuisDPRPA := TotalReaDepuisDPRPA + TOBL.GetDouble('REALISEDEPUISPA');
      TotalTheoDPRPA      := TotalTheoDPRPA+ TOBL.GetDouble('THEOMTPA');
      TotalFinAffDPRPA    := TotalFinAffDPRPA+ TOBL.GetDouble('FINAFFAIREPA')
    end else
    begin
      TotalBudgetDPRPA    := TotalBudgetDPR;
      TotalRealiseDPRPA   := TotalRealiseDPR;
      TotalReaDepuisDPRPA := TotalReaDepuisDPR;
      TotalTheoDPRPA      := TotalTheoDPR;
      TotalFinAffDPRPA    := TotalFinAffDPR;
    end;
  end;
  // Ajout des frais de chantier
  TOBL := TobGrille.FindFirst(['TYPELIGNE','TYPERESSOURCE'],['ST','FRC'], False);

  if TOBL <> nil then
  begin
    TotalBudgetDPR    := TotalBudgetDPR + TOBL.GetDouble('BUDGETMT');
    TotalRealiseDPR   := TotalRealiseDPR+ TOBL.GetDouble('REALISEMT');
    TotalReaDepuisDPR := TotalReaDepuisDPR + TOBL.GetDouble('REALISEDEPUIS');
    TotalTheoDPR      := TotalTheoDPR   + TOBL.GetDouble('THEOMT');
    TotalResteDPR     := TotalResteDPR  + TOBL.GetDouble('RESTEMT');
    TotalFinAffDPR    := TotalFinAffDPR + TOBL.GetDouble('FINAFFAIRE');
    //
    if CoefFGFromDomaine then
    begin
      TotalBudgetDPRPA    := TotalBudgetDPRPA + TOBL.GetDouble('BUDGETMTPA');;
      TotalRealiseDPRPA   := TotalRealiseDPRPA + TOBL.GetDouble('REALISEMTPA');
      TotalReaDepuisDPRPA := TotalReaDepuisDPRPA + TOBL.GetDouble('REALISEDEPUISPA');
      TotalTheoDPRPA      := TotalTheoDPRPA+ TOBL.GetDouble('THEOMTPA');
      TotalFinAffDPRPA    := TotalFinAffDPRPA+ TOBL.GetDouble('FINAFFAIREPA')
    end else
    begin
      TotalBudgetDPRPA    := TotalBudgetDPR;
      TotalRealiseDPRPA   := TotalRealiseDPR;
      TotalReaDepuisDPRPA := TotalReaDepuisDPR;
      TotalTheoDPRPA      := TotalTheoDPR;
      TotalFinAffDPRPA    := TotalFinAffDPR;
    end;
  end;
  //
  if CoefFGFromDomaine then
  begin
    TotalBudgetDPRPA    := TotalBudgetDPRPA * COEFFG;
    TotalRealiseDPRPA   := TotalRealiseDPRPA * COEFFG;
    TotalReaDepuisDPRPA := TotalReaDepuisDPRPA * COEFFG;
    TotalTheoDPRPA      := TotalTheoDPRPA * COEFFG;
    TotalFinAffDPRPA    := TotalFinAffDPRPA * COEFFG;
  end;
end;

Procedure TOF_BTSAISIERESTDEP.CalculMarge;
Var TOBL : TOB;
begin

  TotalBudgetMAR    := 0;
  TotalRealiseMAR   := 0;
  TotalReaDepuisMAR := 0;
  TotalTheoMAR      := 0;
  TotalResteMAR     := 0;
  TotalFinAffMAR    := 0;
  //
  BaseBudget        := 0;
  BaseRealise       := 0;
  BaseTheorique     := 0;
  BaseFINAFF        := 0;
  BaseBudgetPA      := 0;
  BaseRealisePA     := 0;
  BaseTheoriquePA   := 0;
  BaseFINAFFPA      := 0;
  //
  TotalBudgetFAC    := 0;
  TotalRealiseFAC   := 0;
  TotalMtDepuisFAC  := 0;
  TotalTheoFAC      := 0;
  TotalResteFAC     := 0;
  TotalFinAffFAC    := 0;
  //
  BaseBudgetFac     := 0;
  BaseRealiseFac    := 0;
  BaseDepuisFAC     := 0;
  BaseEngageFAC     := 0;
  BaseTheoFAC       := 0;
  BaseFINAFFFac     := 0;
  BaseResteFAC      := 0;
  //
  TotalBudgetMARPA    := 0;
  TotalRealiseMARPA   := 0;
  TotalReaDepuisMARPA := 0;
  TotalTheoMARPA      := 0;
  TotalFinAffMARPA    := 0;
  //

  TOBL := TobGrille.FindFirst(['TYPERESSOURCE','NATUREPRESTATION'],['FAC','FAC'], False);

  if TOBL <> nil then
  begin
    TotalBudgetMAR    := TOBL.GetDouble('BUDGETMT')       - TotalBudgetDPR;
    TotalRealiseMAR   := TOBL.GetDouble('REALISEMT')      - TotalRealiseDPR;
    TotalReaDepuisMAR := TOBL.GetDouble('REALISEDEPUIS')  - TotalReaDepuisMAR;
    TotalTheoMAR      := TOBL.GetDouble('THEOMT')         - TotalTheoDPR;
    if CoefFG <> 0 then
      TotalResteMAR   := TOBL.GetDouble('RESTEMT')        - (TotalResteDPR * CoefFG)
    else
      TotalResteMAR   := TOBL.GetDouble('RESTEMT')        - TotalResteDPR;
    TotalFinAffMAR    := TOBL.GetDouble('FINAFFAIRE')     - TotalFinAffDPR;
    //
    //FV1 - 20/07/2017 : FS#2639 - GUINIER : dans l'�cran RAD, prendre en compte le param�tre de calcul de marge sur PV (% de marque)
    TotalBudgetFAC    := TotalBudgetFAC   + TOBL.GetDouble('BUDGETMT');
    TotalRealiseFAC   := TotalRealiseFAC  + TOBL.GetDouble('REALISEMT') ;
    TotalMtDepuisFAC  := TotalMtDepuisFAC + TOBL.GetDouble('REALISEDEPUIS');
    TotalTheoFAC      := TotalTheoFAC     + TOBL.GetDouble('THEOMT');
    TotalResteFAC     := TotalResteFAC    + TOBL.GetDouble('RESTEMT');
    TotalFinAffFAC    := TotalFinAffFAC   + TOBL.GetDouble('FINAFFAIRE');
    //
    if CoefFGFromDomaine then
    begin
      TotalBudgetMARPA    := TOBL.GetDouble('BUDGETMTPA')  - TotalBudgetDPRPA;
      TotalRealiseMARPA   := TOBL.GetDouble('REALISEMTPA') - TotalRealiseDPRPA;
      TotalReaDepuisMARPA := TOBL.GetDouble('REALISEDEPUISPA') - TotalReaDepuisMARPA;
      TotalTheoMARPA      := TOBL.GetDouble('THEOMTPA')    - TotalTheoDPRPA;
      TotalFinAffMARPA    := TOBL.GetDouble('FINAFFAIREPA')- TotalFinAffDPRPA;
    end else
    begin
      TotalBudgetMARPA    := TotalBudgetMAR;
      TotalRealiseMARPA   := TotalRealiseMAR;
      TotalReaDepuisMARPA := TotalReaDepuisMAR;
      TotalTheoMARPA      := TotalTheoMAR;
      TotalFinAffMARPA    := TotalFinAffMAR;
    end;
    //
    BaseBudgetFac     := TotalBudgetFAC;
    BaseRealiseFac    := TotalRealiseFAC;
    BaseDepuisFAC     := TotalMtDepuisFAC;
    BaseEngageFAC     := TotalEngageFAC;
    BaseTheoFAC       := TotalTheoFAC;
    BaseResteFAC      := TotalResteFAC;
    BaseFINAFFFac     := TotalFinAffFAC;
    //
    BaseBudget        := TotalBudgetDPR;
    BaseRealise       := TotalRealiseDPR;
    BaseTheorique     := TotalTheoDPR;
    BaseFINAFF        := TotalFinAffDPR;
    //
    BaseBudgetPA      := TotalBudgetDPRPA;
    BaseRealisePA     := TotalRealiseDPRPA;
    BaseTheoriquePA   := TotalTheoDPRPA;
    BaseFINAFFPA      := TotalFinAffDPRPA;
  end;

  TOBL := TobGrille.FindFirst(['TYPERESSOURCE','NATUREPRESTATION'],['FAC','RAN'], False);
  if TOBL <> nil then
  begin
    TotalRealiseMAR       := TotalRealiseMAR + TOBL.GetDouble('REALISEMT');
    TotalReaDepuisMAR     := TotalReaDepuisMAR + TOBL.GetDouble('REALISEDEPUIS');
    TotalTheoMAR          := TotalTheoMAR + TOBL.GetDouble('THEOMT');
    TotalResteMAR         := TotalResteMAR + TOBL.GetDouble('RESTEMT');
    TotalFinAffMAR        := TotalFinAffMAR + TOBL.GetDouble('FINAFFAIRE');
    if CoefFGFromDomaine then
    begin
      TotalRealiseMARPA   := TotalRealiseMARPA + TOBL.GetDouble('REALISEMTPA');
      TotalReaDepuisMARPA := TotalReaDepuisMARPA + TOBL.GetDouble('REALISEDEPUISPA') ;
      TotalTheoMARPA      := TotalTheoMARPA + TOBL.GetDouble('THEOMTPA');
      TotalFinAffMARPA    := TotalFinAffMARPA + TOBL.GetDouble('FINAFFAIREPA');
      //
    end else
    begin
      TotalRealiseMARPA   := TotalRealiseMAR;
      TotalReaDepuisMARPA := TotalReaDepuisMAR;
      TotalTheoMARPA      := TotalTheoMAR;
      TotalFinAffMARPA    := TotalFinAffMAR;
    end;

  end;

  TOBL := TobGrille.FindFirst(['TYPERESSOURCE','NATUREPRESTATION'],['FAC','FAN'], False);
  if TOBL <> nil then
  begin
    TotalRealiseMAR       := TotalRealiseMAR      - TOBL.GetDouble('REALISEMT');
    TotalReaDepuisMAR     := TotalReaDepuisMAR    - TOBL.GetDouble('REALISEDEPUIS');
    TotalTheoMAR          := TotalTheoMAR         - TOBL.GetDouble('THEOMT');
    TotalResteMAR         := TotalResteMAR        - TOBL.GetDouble('RESTEMT');
    TotalFinAffMAR        := TotalFinAffMAR       - TOBL.GetDouble('FINAFFAIRE');
    if CoefFGFromDomaine then
    begin
      TotalRealiseMARPA   := TotalRealiseMARPA    - TOBL.GetDouble('REALISEMTPA');
      TotalReaDepuisMARPA := TotalReaDepuisMARPA  - TOBL.GetDouble('REALISEDEPUISPA') ;
      TotalTheoMARPA      := TotalTheoMARPA       - TOBL.GetDouble('THEOMTPA');
      TotalFinAffMARPA    := TotalFinAffMARPA     - TOBL.GetDouble('FINAFFAIREPA');
      //
    end else
    begin
      TotalRealiseMARPA   := TotalRealiseMAR;
      TotalReaDepuisMARPA := TotalReaDepuisMAR;
      TotalTheoMARPA      := TotalTheoMAR;
      TotalFinAffMARPA    := TotalFinAffMAR;
    end;
  end;

end;

//cr�ation de la ligne de titre
Procedure TOF_BTSAISIERESTDEP.CreateLigneTitreToGrille(TOBaLire : TOB);
Var TOBGrilleLig : TOB;
begin

  TOBGrilleLig := TOB.Create('LES LIGNES GRILLE', TobGrille, -1);
  //
  TOBGrilleLig.AddChampSupValeur('SEL','');
  TOBGrilleLig.AddChampSupValeur('LIBTYPEARTICLE', TOBALire.GetString('TITRE'));
  TOBGrilleLig.AddChampSupValeur('BUDGETQTE', '');
  TOBGrilleLig.AddChampSupValeur('BUDGETMTPA',  '');
  TOBGrilleLig.AddChampSupValeur('BUDGETMT',  '');
  TOBGrilleLig.AddChampSupValeur('REALISEQTE','');
  TOBGrilleLig.AddChampSupValeur('REALISEMTPA', '');
  TOBGrilleLig.AddChampSupValeur('REALISEMT', '');
  TOBGrilleLig.AddChampSupValeur('ENGAGE', 0);
  TOBGrilleLig.AddChampSupValeur('REALISEQTEDEPUIS', '');
  TOBGrilleLig.AddChampSupValeur('REALISEDEPUISPA', '');
  TOBGrilleLig.AddChampSupValeur('REALISEDEPUIS', '');
  TOBGrilleLig.AddChampSupValeur('THEOQTE','');
  TOBGrilleLig.AddChampSupValeur('THEOMTPA','');
  TOBGrilleLig.AddChampSupValeur('THEOMT','');
  TOBGrilleLig.AddChampSupValeur('RESTEQTE','');
  TOBGrilleLig.AddChampSupValeur('RESTEMT','');
  TOBGrilleLig.AddChampSupValeur('FINAFFAIREPA','');
  TOBGrilleLig.AddChampSupValeur('FINAFFAIRE','');
  TOBGrilleLig.AddChampSupValeur('TYPEELT', '');
  TOBGrilleLig.AddChampSupValeur('TYPERESSOURCE', '');
  TOBGrilleLig.AddChampSupValeur('NATUREPRESTATION', '');
  TobGrilleLig.AddChampSupValeur('TYPELIGNE', 'TI');
  //
end;

//cr�ation de la ligne de titre
Procedure TOF_BTSAISIERESTDEP.CreateLigneToGrille(TOBL : TOB);
Var TOBGrilleLig : TOB;
begin

  //recherche dans la TOB MO si le type de ressource et la nature Article Existe d�j� !!!!
  TOBGrilleLig := TOBGrille.FindFirst(['TYPERESSOURCE','NATUREPRESTATION'],[TOBL.GetString('TYPERESSOURCE'),TOBL.GetSTring('NATUREPRESTATION')], False);

  if TOBGrilleLig=nil then
  begin
    TOBGrilleLig := TOB.Create('LES LIGNES GRILLE', TobGrille, -1);
    //
    TOBGrilleLig.AddChampSupValeur('SEL', '');
    TOBGrilleLig.AddChampSupValeur('LIBTYPEARTICLE',TOBL.GetString('LIBNATPRESTATION'));
    TOBGrilleLig.AddChampSupValeur('BUDGETQTE',     TOBL.GetDouble('BUDGETQTE'));
    TOBGrilleLig.AddChampSupValeur('BUDGETMTPA',    TOBL.GetDouble('BUDGETMTPA'));
    TOBGrilleLig.AddChampSupValeur('BUDGETMT',      TOBL.GetDouble('BUDGETMT'));
    TOBGrilleLig.AddChampSupValeur('REALISEQTE',    TOBL.GetDouble('REALISEQTE'));
    TOBGrilleLig.AddChampSupValeur('REALISEMTPA',   TOBL.GetDouble('REALISEMTPA'));
    TOBGrilleLig.AddChampSupValeur('REALISEMT',     TOBL.GetDouble('REALISEMT'));
    TOBGrilleLig.AddChampSupValeur('ENGAGE',        TOBL.GetDouble('ENGAGE'));
    TOBGrilleLig.AddChampSupValeur('REALISEDEPUISPA', TOBL.GetDouble('REALISEDEPUISPA'));
    TOBGrilleLig.AddChampSupValeur('REALISEDEPUIS', TOBL.GetDouble('REALISEDEPUIS'));
    TOBGrilleLig.AddChampSupValeur('REALISEQTEDEPUIS', TOBL.GetDouble('REALISEQTEDEPUIS'));
    TOBGrilleLig.AddChampSupValeur('THEOQTE',       TOBL.GetDouble('THEORIQUEQTE'));
    TOBGrilleLig.AddChampSupValeur('THEOMTPA',      TOBL.GetDouble('THEORIQUEMTPA'));
    TOBGrilleLig.AddChampSupValeur('THEOMT',        TOBL.GetDouble('THEORIQUEMT'));
    TOBGrilleLig.AddChampSupValeur('RESTEQTE',      TOBL.GetDouble('RESTEQTE'));
    TOBGrilleLig.AddChampSupValeur('RESTEMT',       TOBL.GetDouble('RESTEMT'));
    TOBGrilleLig.AddChampSupValeur('FINAFFAIREPA',  TOBL.GetDouble('RESTEFINAFFPA'));
    TOBGrilleLig.AddChampSupValeur('FINAFFAIRE',    TOBL.GetDouble('RESTEFINAFF'));
    TOBGrilleLig.AddChampSupValeur('TYPEELT',       TOBL.GetString('TYPEELT'));
    TOBGrilleLig.AddChampSupValeur('TYPERESSOURCE', TOBL.GetString('TYPERESSOURCE'));
    TOBGrilleLig.AddChampSupValeur('NATUREPRESTATION', TOBL.GetString('NATUREPRESTATION'));
    TOBGrilleLig.AddChampSupValeur('TYPETOTAL',     TOBL.GetString('TYPETOTAL'));
    TobGrilleLig.AddChampSupValeur('TYPELIGNE', 'LI');
  end
  Else
  begin
    if (TOBL.GetString('TYPERESSOURCE') = 'AVC') then
    begin
      TOBGrilleLig.PutValue('BUDGETQTE',      TOBGrilleLig.GetDouble('BUDGETQTE')         -TOBL.GetDouble('BUDGETQTE'));
      TOBGrilleLig.PutValue('BUDGETMT',       TOBGrilleLig.GetDouble('BUDGETMT')          -TOBL.GetDouble('BUDGETMT'));
      TOBGrilleLig.PutValue('BUDGETMTPA',     TOBGrilleLig.GetDouble('BUDGETMTPA')        -TOBL.GetDouble('BUDGETMTPA'));
    end
    Else
    begin
      TOBGrilleLig.PutValue('BUDGETQTE',      TOBGrilleLig.GetDouble('BUDGETQTE')         +TOBL.GetDouble('BUDGETQTE'));
      TOBGrilleLig.PutValue('BUDGETMT',       TOBGrilleLig.GetDouble('BUDGETMT')          +TOBL.GetDouble('BUDGETMT'));
      TOBGrilleLig.PutValue('BUDGETMTPA',     TOBGrilleLig.GetDouble('BUDGETMTPA')        +TOBL.GetDouble('BUDGETMTPA'));
    end;
    TOBGrilleLig.PutValue('REALISEQTE',       TOBGrilleLig.GetDouble('REALISEQTE')        +TOBL.GetDouble('REALISEQTE'));
    TOBGrilleLig.PutValue('REALISEMT',        TOBGrilleLig.GetDouble('REALISEMT')         +TOBL.GetDouble('REALISEMT'));
    TOBGrilleLig.PutValue('REALISEMTPA',      TOBGrilleLig.GetDouble('REALISEMTPA')       +TOBL.GetDouble('REALISEMTPA'));
    TOBGrilleLig.PutValue('ENGAGE',           TOBGrilleLig.GetDouble('ENGAGE')            +TOBL.GetDouble('ENGAGE'));
    TOBGrilleLig.PutValue('REALISEDEPUIS',    TOBGrilleLig.GetDouble('REALISEDEPUIS')     +TOBL.GetDouble('REALISEDEPUIS'));
    TOBGrilleLig.PutValue('REALISEDEPUISPA',  TOBGrilleLig.GetDouble('REALISEDEPUISPA')   +TOBL.GetDouble('REALISEDEPUISPA'));
    TOBGrilleLig.PutValue('REALISEQTEDEPUIS', TOBGrilleLig.GetDouble('REALISEQTEDEPUIS')  +TOBL.GetDouble('REALISEQTEDEPUIS'));
    TOBGrilleLig.PutValue('THEOQTE',          TOBGrilleLig.GetDouble('THEORIQUEQTE')      +TOBL.GetDouble('THEORIQUEQTE'));
    TOBGrilleLig.PutValue('THEOMTPA',         TOBGrilleLig.GetDouble('THEORIQUEMTPA')     +TOBL.GetDouble('THEORIQUEMTPA'));
    TOBGrilleLig.PutValue('THEOMT',           TOBGrilleLig.GetDouble('THEORIQUEMT')       +TOBL.GetDouble('THEORIQUEMT'));
    TOBGrilleLig.PutValue('RESTEQTE',         TOBGrilleLig.GetDouble('RESTEQTE')          +TOBL.GetDouble('RESTEQTE'));
    TOBGrilleLig.PutValue('RESTEMT',          TOBGrilleLig.GetDouble('RESTEMT')           +TOBL.GetDouble('RESTEMT'));
    TOBGrilleLig.PutValue('FINAFFAIREPA',     TOBGrilleLig.GetDouble('RESTEFINAFFPA')     +TOBL.GetDouble('RESTEFINAFFPA'));
    TOBGrilleLig.PutValue('FINAFFAIRE',       TOBGrilleLig.GetDouble('RESTEFINAFF')       +TOBL.GetDouble('RESTEFINAFF'));
  end;
  //
end;

Procedure TOF_BTSAISIERESTDEP.CreateLigneTotal(TOBL : TOB );
Var TOBGrilleLig : TOB;
Begin

  //On recherche la ligne correspondante au total � charger dans la tob de la grille
  TOBGrilleLig := TOBGrille.FindFirst(['TYPERESSOURCE','TYPELIGNE'],[TOBL.GetString('TYPERESSOURCE'),'ST'], False);

  if TOBGrilleLig=nil then exit;

  if (TOBL.GetString('TYPERESSOURCE') = 'AVC') then
  begin
    TOBGrilleLig.PutValue('BUDGETQTE',      TOBGrilleLig.GetDouble('BUDGETQTE')         -TOBL.GetDouble('BUDGETQTE'));
    TOBGrilleLig.PutValue('BUDGETMT',       TOBGrilleLig.GetDouble('BUDGETMT')          -TOBL.GetDouble('BUDGETMT'));
    TOBGrilleLig.PutValue('BUDGETMTPA',     TOBGrilleLig.GetDouble('BUDGETMTPA')        -TOBL.GetDouble('BUDGETMTPA'));
  end
  Else
  begin
    TOBGrilleLig.PutValue('BUDGETQTE',      TOBGrilleLig.GetDouble('BUDGETQTE')         +TOBL.GetDouble('BUDGETQTE'));
    TOBGrilleLig.PutValue('BUDGETMT',       TOBGrilleLig.GetDouble('BUDGETMT')          +TOBL.GetDouble('BUDGETMT'));
    TOBGrilleLig.PutValue('BUDGETMTPA',     TOBGrilleLig.GetDouble('BUDGETMTPA')        +TOBL.GetDouble('BUDGETMTPA'));
  end;

  TOBGrilleLig.PutValue('REALISEQTE',       TOBGrilleLig.GetDouble('REALISEQTE')        +TOBL.GetDouble('REALISEQTE'));
  TOBGrilleLig.PutValue('REALISEMT',        TOBGrilleLig.GetDouble('REALISEMT')         +TOBL.GetDouble('REALISEMT'));
  TOBGrilleLig.PutValue('REALISEMTPA',      TOBGrilleLig.GetDouble('REALISEMTPA')       +TOBL.GetDouble('REALISEMTPA'));
  TOBGrilleLig.PutValue('ENGAGE',           TOBGrilleLig.GetDouble('ENGAGE')            +TOBL.GetDouble('ENGAGE'));
  TOBGrilleLig.PutValue('REALISEDEPUIS',    TOBGrilleLig.GetDouble('REALISEDEPUIS')     +TOBL.GetDouble('REALISEDEPUIS'));
  TOBGrilleLig.PutValue('REALISEDEPUISPA',  TOBGrilleLig.GetDouble('REALISEDEPUISPA')   +TOBL.GetDouble('REALISEDEPUISPA'));
  TOBGrilleLig.PutValue('REALISEQTEDEPUIS', TOBGrilleLig.GetDouble('REALISEQTEDEPUIS')  +TOBL.GetDouble('REALISEQTEDEPUIS'));
  TOBGrilleLig.PutValue('THEOQTE',          TOBGrilleLig.GetDouble('THEORIQUEQTE')      +TOBL.GetDouble('THEORIQUEQTE'));
  TOBGrilleLig.PutValue('THEOMTPA',         TOBGrilleLig.GetDouble('THEORIQUEMTPA')     +TOBL.GetDouble('THEORIQUEMTPA'));
  TOBGrilleLig.PutValue('THEOMT',           TOBGrilleLig.GetDouble('THEORIQUEMT')       +TOBL.GetDouble('THEORIQUEMT'));
  TOBGrilleLig.PutValue('RESTEQTE',         TOBGrilleLig.GetDouble('RESTEQTE')          +TOBL.GetDouble('RESTEQTE'));
  TOBGrilleLig.PutValue('RESTEMT',          TOBGrilleLig.GetDouble('RESTEMT')           +TOBL.GetDouble('RESTEMT'));
  TOBGrilleLig.PutValue('FINAFFAIREPA',     TOBGrilleLig.GetDouble('RESTEFINAFFPA')     +TOBL.GetDouble('RESTEFINAFFPA'));
  TOBGrilleLig.PutValue('FINAFFAIRE',       TOBGrilleLig.GetDouble('RESTEFINAFF')       +TOBL.GetDouble('RESTEFINAFF'));

end;

//cr�ation de la ligne Sous-Total
Procedure TOF_BTSAISIERESTDEP.CreateLigneSsTotalToGrille(TheTitre, TypeSt : String);
Var TOBGrilleLig : TOB;
begin

  TOBGrilleLig := TOB.Create('LES LIGNES GRILLE', TobGrille, -1);
  //
  TOBGrilleLig.AddChampSupValeur('SEL',               '');
  TOBGrilleLig.AddChampSupValeur('LIBTYPEARTICLE', TheTitre);
  TOBGrilleLig.AddChampSupValeur('BUDGETQTE',          0);
  TOBGrilleLig.AddChampSupValeur('BUDGETMTPA',         0);
  TOBGrilleLig.AddChampSupValeur('BUDGETMT',           0);
  TOBGrilleLig.AddChampSupValeur('REALISEQTE',         0);
  TOBGrilleLig.AddChampSupValeur('REALISEMTPA',        0);
  TOBGrilleLig.AddChampSupValeur('REALISEMT',          0);
  TOBGrilleLig.AddChampSupValeur('ENGAGE',             0);
  TOBGrilleLig.AddChampSupValeur('REALISEDEPUISPA',    0);
  TOBGrilleLig.AddChampSupValeur('REALISEDEPUIS',      0);
  TOBGrilleLig.AddChampSupValeur('REALISEQTEDEPUIS',   0);
  TOBGrilleLig.AddChampSupValeur('THEOQTE',            0);
  TOBGrilleLig.AddChampSupValeur('THEOMTPA',           0);
  TOBGrilleLig.AddChampSupValeur('THEOMT',             0);
  TOBGrilleLig.AddChampSupValeur('RESTEQTE',           0);
  TOBGrilleLig.AddChampSupValeur('RESTEMT',            0);
  TOBGrilleLig.AddChampSupValeur('FINAFFAIREPA',       0);
  TOBGrilleLig.AddChampSupValeur('FINAFFAIRE',        '');
  TOBGrilleLig.AddChampSupValeur('TYPEELT',           '');
  TOBGrilleLig.AddChampSupValeur('TYPERESSOURCE', TypeSt);
  TOBGrilleLig.AddChampSupValeur('NATUREPRESTATION',  '');
  //
  TOBGrilleLig.AddChampSupValeur('BASEBUDGETFAC',      0);
  TOBGrilleLig.AddChampSupValeur('BASEREALISEFAC',     0);
  TOBGrilleLig.AddChampSupValeur('BASEDEPUISFAC',      0);
  TOBGrilleLig.AddChampSupValeur('BASEENGAGEFAC',      0);
  TOBGrilleLig.AddChampSupValeur('BASETHEOFAC',        0);
  TOBGrilleLig.AddChampSupValeur('BASERESTEFAC',       0);
  TOBGrilleLig.AddChampSupValeur('BASEFINAFFFAC',         0);
  //
  TOBGrilleLig.AddChampSupValeur('BASEBUDGET',         0);
  TOBGrilleLig.AddChampSupValeur('BASEREALISE',        0);
  TOBGrilleLig.AddChampSupValeur('BASETHEORIQUE',      0);
  TOBGrilleLig.AddChampSupValeur('BASEFINAFFAIRE',     0);
  TOBGrilleLig.AddChampSupValeur('BASEBUDGETPA',       0);
  TOBGrilleLig.AddChampSupValeur('BASEREALISEPA',      0);
  TOBGrilleLig.AddChampSupValeur('BASETHEORIQUEPA',    0);
  TOBGrilleLig.AddChampSupValeur('BASEFINAFFAIREPA',   0);
  //
  TobGrilleLig.AddChampSupValeur('TYPELIGNE',       'ST');
  //
end;


Procedure TOF_BTSAISIERESTDEP.CalculSsTot(TypeSt : String);
Var TotBudgetQTe  : Double;
    TotBudgetMt,TotBudgetMtPA : Double;
    TotRealiseQte : Double;
    TotRealiseMt,TotRealiseMtPA : Double;
    TotRealiseDep,TotRealiseDepPA : Double;
    TotQteRealiseDep : Double;
    TotTheoQte    : Double;
    TotTheoMt,TotTheoMtPA     : Double;
    TotResteQte   : Double;
    TotResteMt : Double;
    TotFinAffaire,TotFinAffairePa : Double;
    TotEngage     : double;
    Ind           : Integer;
    TOBL          : TOB;
begin

  If TobGrille = nil then exit;

  TotBudgetQTe      := 0;
  TotBudgetMt       := 0;
  TotBudgetMtPA     := 0;
  TotRealiseQte     := 0;
  TotQteRealiseDep  := 0;
  TotRealiseMt      := 0;
  TotRealiseDep     := 0;
  TotRealiseMtPA    := 0;
  TotRealiseDepPA   := 0;
  TotTheoQte        := 0;
  TotTheoMt         := 0;
  TotTheoMtPA       := 0;
  TotResteQte       := 0;
  TotResteMt        := 0;
  TotFinAffaire     := 0;
  TotFinAffairePA   := 0;
  TotEngage         := 0;

  For Ind := 0 to Tobgrille.detail.count -1 do
  begin
    TOBL := TobGrille.detail[Ind];
    If TOBL.GetString('TYPELIGNE') = 'TI' then
    Begin
      continue;
    end
    Else if Tobl.GetString('TYPELIGNE') = 'LI' then
    begin
      if Tobl.GetString('TYPETOTAL') = TypeST then
      begin
        TotBudgetQTe    := TotBudgetQTe       + TOBL.GetDouble('BUDGETQTE');
        TotBudgetMt     := TotBudgetMt        + TOBL.GetDouble('BUDGETMT');
        TotBudgetMtPA   := TotBudgetMtPA      + TOBL.GetDouble('BUDGETMTPA');
        TotRealiseQte   := TotRealiseQTE      + TOBL.GetDouble('REALISEQTE');
        TotRealiseMt    := TotRealiseMt       + TOBL.GetDouble('REALISEMT');
        TotRealiseMtPA  := TotRealiseMtPA     + TOBL.GetDouble('REALISEMTPA');
        TotEngage       := TotEngage          + TOBL.GetDouble('ENGAGE');
        TotRealiseDep   := TotRealiseDep      + TOBL.GetDouble('REALISEDEPUIS');
        TotRealiseDepPA := TotRealiseDepPA    + TOBL.GetDouble('REALISEDEPUISPA');
        TotQteRealiseDep:= TotQteRealiseDep   + TOBL.GetDouble('REALISEQTEDEPUIS');
        TotTheoQte      := TotTheoQte         + TOBL.GetDouble('THEOQTE');
        TotTheoMtPA     := TotTheoMtPA        + TOBL.GetDouble('THEOMTPA');
        TotTheoMt       := TotTheoMt          + TOBL.GetDouble('THEOMT');
        TotResteQte     := TotResteQte        + TOBL.GetDouble('RESTEQTE');
        TotResteMt      := TotResteMt         + TOBL.GetDouble('RESTEMT');
        TotFinAffaire   := TotFinAffaire      + TOBL.GetDouble('FINAFFAIRE');
        TotFinAffairePA := TotFinAffairePA    + TOBL.GetDouble('FINAFFAIREPA');
      end;
    end
    else
    begin
      if TOBL.GetString('TYPERESSOURCE') = TypeST then
      begin
        TOBL.PutValue('BUDGETQTE',        TotBudgetQTe);
        TOBL.PutValue('BUDGETMTPA',       TotBudgetMtPA);
        TOBL.PutValue('BUDGETMT',         TotBudgetMt);
        TOBL.PutValue('REALISEQTE',       TotRealiseQte);
        TOBL.PutValue('REALISEMTPA',      TotRealiseMtPA);
        TOBL.PutValue('REALISEMT',        TotRealiseMt);
        TOBL.PutValue('ENGAGE',           TotEngage);
        TOBL.PutValue('REALISEDEPUIS',    TotRealiseDep);
        TOBL.PutValue('REALISEDEPUISPA',  TotRealiseDepPA);
        TOBL.PutValue('REALISEQTEDEPUIS', TotQteRealiseDep);
        TOBL.PutValue('THEOQTE',          TotTheoQte);
        TOBL.PutValue('THEOMTPA',         TotBudgetMTPA - TotRealiseMtPA);
        TOBL.PutValue('THEOMT',           TotBudgetMT - TotRealiseMt);
        if DepuisINTheorique then
        begin
          TOBL.PutValue('THEOQTE',        TOBL.GetValue('THEOQTE')- TotQteRealiseDep);
          TOBL.PutValue('THEOMTPA',       TOBL.GetValue('THEOMTPA') - TotRealiseDepPA);
          TOBL.PutValue('THEOMT',         TOBL.GetValue('THEOMT') - TotRealiseDep);
        end;
        TOBL.PutValue('RESTEQTE',         TotResteQte);
        TOBL.PutValue('RESTEMT',          TotResteMt);
        TOBL.PutValue('FINAFFAIREPA',     TotRealiseMtPA + TotResteMt);
        TOBL.PutValue('FINAFFAIRE',       TotRealiseMt + TotResteMt);
      end;
    end;
  end;

end;

Procedure TOF_BTSAISIERESTDEP.RafraichitSSTot;
var TOBL : TOB;
begin

  TOBL := TobGrille.FindFirst(['TYPELIGNE'],['ST'], False);
  repeat
    if TOBL <> nil then
    begin
      TOBL.PutLigneGrid (GS,TOBL.GetIndex +1,false,false,fColNamesGS);
      TOBL := TobGrille.Findnext(['TYPELIGNE'],['ST'], False);
    end;
  until TOBl = nil;

end;

Procedure TOF_BTSAISIERESTDEP.ChargeSsTot(TypeSt : String);
Var TOBL : TOB;
begin

    If TobGrille = nil then exit;

    TOBL := TobGrille.FindFirst(['TYPELIGNE', 'TYPERESSOURCE'],['ST', TypeST], False);

    if TOBL = nil then exit;

    if TypeST = 'DPR' then
    begin
      TOBL.PutValue('BUDGETMTPA',      TotalBudgetDPRPA);
      TOBL.PutValue('BUDGETMT',        TotalBudgetDPR);
      TOBL.PutValue('REALISEMTPA',     TotalRealiseDPRPA);
      TOBL.PutValue('REALISEMT',       TotalRealiseDPR);
      TOBL.PutValue('ENGAGE',          TotalEngageDPR);
      TOBL.PutValue('REALISEDEPUISPA', TotalReaDepuisDPRPA);
      TOBL.PutValue('REALISEDEPUIS',   TotalReaDepuisDPR);
      TOBL.PutValue('REALISEQTEDEPUIS',TotalQteReaDepuisDPR);
      TOBL.PutValue('THEOMTPA',        TotalBudgetDPRPA -  TotalRealiseDPRPA);
      TOBL.PutValue('THEOMT',          TotalBudgetDPR   -  TotalRealiseDPR);
      if DepuisINTheorique then
      begin
        TOBL.PutValue('THEOMTPA',      TOBL.GetValue('THEOMTPA')  -  TotalReaDepuisDPRPA);
        TOBL.PutValue('THEOMT',        TOBL.GetValue('THEOMT')    -  TotalReaDepuisDPR);
      end;
      //FV1 - 04/07/2016 : FS#2074 - TEAM RESEAUX : Pb de calcul dans l'�cran reste � d�penser
      if CoefFG <> 0 then
        TOBL.PutValue('RESTEMT',       TotalResteDPR * CoefFG)
      else
        TOBL.PutValue('RESTEMT',       TotalResteDPR);
      //FV1 : 04/07/2016 - FS#2074 - TEAM RESEAUX : Pb de calcul dans l'�cran reste � d�penser
      TOBL.PutValue('FINAFFAIREPA',    TotalFinAffDPRPA);
      TOBL.PutValue('FINAFFAIRE',      TotalRealiseDPR   + TotalResteDPR);
    end Else if TypeST = 'MRG' then
    begin
      TOBL.PutValue('BUDGETMTPA',      TotalBudgetMARPA);
      TOBL.PutValue('BUDGETMT',        TotalBudgetMAR);
      TOBL.PutValue('REALISEMTPA',     TotalRealiseMARPA);
      TOBL.PutValue('REALISEMT',       TotalRealiseMAR);
      TOBL.PutValue('REALISEDEPUISPA', TotalReaDepuisMARPA);
      TOBL.PutValue('REALISEDEPUIS',   TotalReaDepuisMAR);
      TOBL.PutValue('REALISEQTEDEPUIS',TotalQteReaDepuisMAR);
      TOBL.PutValue('THEOMTPA',        TotalBudgetMARPA -  TotalRealiseMARPA);
      TOBL.PutValue('THEOMT',          TotalBudgetMAR   -  TotalRealiseMAR);
      if DepuisINTheorique then
      begin
        TOBL.PutValue('THEOMTPA',      TOBL.GetValue('THEOMTPA') -  TotalReaDepuisMARPA);
        TOBL.PutValue('THEOMT',        TOBL.GetValue('THEOMT')    -  TotalReaDepuisMAR);
      end;
      TOBL.PutValue('RESTEMT',         TotalResteMAR);
      TOBL.PutValue('FINAFFAIREPA',    TotalRealiseMARPA + TotalResteMAR);
      TOBL.PutValue('FINAFFAIRE',      TotalRealiseMAR + TotalResteMAR);
      //
      TOBL.SetDouble('BASEBUDGET',     BaseBudget);
      TOBL.SetDouble('BASEREALISE',    BaseRealise);
      TOBL.SetDouble('BASETHEORIQUE',  BaseTheorique);
      TOBL.SetDouble('BASEFINAFFAIRE', BaseFINAFF);
      //
      TOBL.SetDouble('BASEBUDGETPA',    BaseBudgetPA);
      TOBL.SetDouble('BASEREALISEPA',   BaseRealisePA);
      TOBL.SetDouble('BASETHEORIQUEPA', BaseTheoriquePA);
      TOBL.SetDouble('BASEFINAFFAIREPA',BaseFINAFFPA);
      //
      TOBL.SetDouble('BASEBUDGETFAC',   BaseBudgetFac);
      TOBL.SetDouble('BASEREALISEFAC',  BaseRealiseFac);
      TOBL.SetDouble('BASEDEPUISFAC',   BaseDepuisFAC);
      TOBL.SetDouble('BASEENGAGEFAC',   BaseEngageFAC);
      TOBL.SetDouble('BASETHEOFAC',     BaseTheoFAC);
      TOBL.SetDouble('BASERESTEFAC',    BaseResteFAC);
      TOBL.SetDouble('BASEFINAFFFAC',   BaseFINAFFFac);
    end else if TypeST = 'TEP' then
    begin
      TOBL.PutValue('BUDGETMTPA',      TotalBudgetTDEPPA);
      TOBL.PutValue('BUDGETMT',        TotalBudgetTDEP);
      TOBL.PutValue('REALISEMTPA',     TotalRealiseTDEPPA);
      TOBL.PutValue('REALISEMT',       TotalRealiseTDEP);
      TOBL.PutValue('ENGAGE',          TotalEngageTDEP);
      TOBL.PutValue('REALISEDEPUISPA', TotalReaDepuisTDEPPA);
      TOBL.PutValue('REALISEDEPUIS',   TotalReaDepuisTDEP);
      TOBL.PutValue('REALISEQTEDEPUIS',TotalQteReaDepuisTDEP);
      TOBL.PutValue('THEOMTPA',        TotalBudgetTDEPPA -  TotalRealiseTDEPPA);
      TOBL.PutValue('THEOMT',          TotalBudgetTDEP   -  TotalRealiseTDEP);
      if DepuisINTheorique then
      begin
        TOBL.PutValue('THEOMTPA',      TOBL.GetValue('THEOMTPA')  -  TotalReaDepuisTDEPPA);
        TOBL.PutValue('THEOMT',        TOBL.GetValue('THEOMT')    -  TotalReaDepuisTDEP);
      end;
      TOBL.PutValue('RESTEMT',         TotalResteTDEP);
      TOBL.PutValue('FINAFFAIREPA',    TotalRealiseTDEPPA + TotalResteTDEP);
      TOBL.PutValue('FINAFFAIRE',      TotalRealiseTDEP + TotalResteTDEP);
    end;

end;

Procedure TOF_BTSAISIERESTDEP.CalculColGrille;
Var Ind : Integer;
    TOBL: TOB;
begin

  If TobGrille = nil then exit;

  for ind := 0 to TobGrille.detail.count -1 do
  begin
    TOBL := TobGrille.detail[Ind];
    if TOBL.Getstring('TYPELIGNE')='LI' then
    begin
      TOBL.PutValue('THEOQTE',      TOBL.GetDouble('BUDGETQTE')   - TOBL.GetDouble('REALISEQTE'));
      TOBL.PutValue('THEOMT',       TOBL.GetDouble('BUDGETMT')    - TOBL.GetDouble('REALISEMT'));
      TOBL.PutValue('THEOMTPA',     TOBL.GetDouble('BUDGETMTPA')  - TOBL.GetDouble('REALISEMTPA'));
      if DepuisINTheorique then
      begin
        TOBL.PutValue('THEOQTE',    TOBL.GetDouble('THEOQTE')   - TOBL.GetDouble('REALISEQTEDEPUIS'));
        TOBL.PutValue('THEOMT',     TOBL.GetDouble('THEOMT')    - TOBL.GetDouble('REALISEDEPUIS'));
        TOBL.PutValue('THEOMTPA',   TOBL.GetDouble('THEOMTPA')  - TOBL.GetDouble('REALISEDEPUISPA'));
      end;
      TOBL.PutValue('FINAFFAIRE',   TOBL.GetDouble('REALISEMT')   + TOBL.GetDouble('RESTEMT'));
      TOBL.PutValue('FINAFFAIREPA', TOBL.GetDouble('REALISEMTPA') + TOBL.GetDouble('RESTEMT'));
    end;
  end;

end;


procedure TOF_BTSAISIERESTDEP.AfficheLagrille (First : boolean=false);
var indice : integer;
    ListLocked : TStringList;
begin

  if TOBGrille.detail.count = 0 then
		GS.RowCount := TOBGrille.detail.count + 2
  else
		GS.RowCount := TOBGrille.detail.count + 1;

  //redimensionnement de la fiche et de la grille en fonction des donn�es
  (*
  if First then
  begin
    PanelBottom.Top     := PanelLeft.Height;

    Tform(Ecran).ClientHeight := (PanelLeft.Height + ((GS.RowCount+2) * GS.DefaultRowHeight)) + ((TOBGrille.detail.count + 1) * GS.GridLineWidth) + TDock97(GetControl('Dock971')).Height + 10;

    if TForm(Ecran).Height > Screen.DesktopHeight then
      TForm(Ecran).Height := Screen.DesktopHeight;

    TForm(Ecran).Top := (Screen.DesktopHeight - Tform(Ecran).Height) div 2;
    TForm(Ecran).Refresh;

  end;
  *)
  GS.DoubleBuffered := true;
  GS.BeginUpdate;

  TRY
    GS.SynEnabled := false;
    for Indice := 0 to TOBGrille.detail.count -1 do
    begin
      TOBGrille.detail[Indice].PutLigneGrid (GS,Indice+1,false,false,fColNamesGS);
      GS.RowHeights [Indice+1] := 18;
      if TOBGrille.detail[Indice].GetString('TYPERESSOURCE')='MRG' then
      begin
        GS.RowHeights [Indice+1] := 18 * 3;
      end;
    end;
  FINALLY
    GS.SynEnabled := true;
    GS.EndUpdate;
  END;
  if First then
  begin
    TFVierge(ecran).HMTrad.ResizeGridColumns(GS);
    ListLocked := TStringList.Create;
    ListLocked.add( 'GS' );
    TFVierge(ecran).HMTrad.LockedCtrls := ListLocked;
    ListLocked.Free;
  end;

end;

procedure TOF_BTSAISIERESTDEP.ControleChamp(Champ, Valeur: String);
begin

  if champ ='AFF_AFFAIRE' then AFFAIRE.Text := Valeur;

end;


Procedure TOF_BTSAISIERESTDEP.CreateZoneTobIntermediaire(TOBINT : TOB);
Begin

  TOBINT.AddchampsupValeur('TYPEELT', '');
  TOBINT.AddchampsupValeur('TYPERESSOURCE', '');
  TOBINT.AddchampsupValeur('NATUREPRESTATION','');
  TOBINT.AddchampsupValeur('LIBNATPRESTATION','');
  TOBINT.AddchampsupValeur('TYPEARTICLE','');
  TOBINT.AddchampsupValeur('CODEARTICLE','');
  TOBINT.AddchampsupValeur('LIBELLEART','');
  TOBINT.AddchampsupValeur('BUDGETQTE', 0);
  TOBINT.AddchampsupValeur('BUDGETMTPA',  0);
  TOBINT.AddchampsupValeur('BUDGETMT',  0);
  TOBINT.AddchampsupValeur('REALISEQTE',0);
  TOBINT.AddchampsupValeur('REALISEMTPA', 0);
  TOBINT.AddchampsupValeur('REALISEMT', 0);
  TOBINT.AddchampsupValeur('ENGAGE', 0);
  TOBINT.AddchampsupValeur('REALISEDEPUISPA', 0);
  TOBINT.AddchampsupValeur('REALISEDEPUIS', 0);
  TOBINT.AddchampsupValeur('REALISEQTEDEPUIS', 0);
  TOBINT.AddchampsupValeur('THEORIQUEQTE',0);
  TOBINT.AddchampsupValeur('THEORIQUEMTPA',0);
  TOBINT.AddchampsupValeur('THEORIQUEMT',0);
  TOBINT.AddchampsupValeur('RESTEQTE',0);
  TOBINT.AddchampsupValeur('RESTEMT',0);
  TOBINT.AddchampsupValeur('RESTEFINAFF',0);
  TOBINT.AddchampsupValeur('CODEAFFAIRE',AFFAIRE.TEXT);
  TOBINT.AddchampsupValeur('DATEARRETE','01/01/1900');
  TOBINT.AddchampsupValeur('VALIDE','-');
  TOBINT.AddchampsupValeur('TYPETOTAL', '');
  TOBINT.AddChampSupValeur('BMARGE', '');

end;

procedure TOF_BTSAISIERESTDEP.CellEnter(Sender: TObject; var ACol,  ARow: Integer; var Cancel: Boolean);
begin

  stCell := GS.cells [Acol,Arow];

  ZoneSuivanteOuOk(ACol, ARow, Cancel);

end;

procedure TOF_BTSAISIERESTDEP.CellExit(Sender: TObject; var ACol,  ARow: Integer; var Cancel: Boolean);
Var TOBL        : TOB;
    //
    PUAchat,PUR     : Double;
    Quantite    : Double;
    MtReste,MtRestePa     : Double;
    FinAffaire,FinAffairepa  : Double;
    //
    TypeLigne   : String;
    TypeRess    : String;
    TypeNat     : String;
begin

  if (Tobgrille = nil) Or (TobGrille.detail.count = 0) then exit;

  PUAchat := 0;
  MtReste := 0;
  PUR     := 0;

  if GS.cells[Acol,Arow] = stcell then
    Exit
  else
    Ok_CtrlSaisie := True;

  //chargement de la ligne
  TOBL := GetTOBGrille(Arow);

  TypeLigne := TobL.GetString('TYPELIGNE');
  TypeRess  := TobL.GetString('TYPERESSOURCE');
  TypeNat   := TobL.GetString('NATUREPRESTATION');

  if (TypeLigne = 'TI') or (TypeLigne = 'ST') then exit;

  // traitement avant modification de la valeur
  if TypeRess <> 'FAC' then
  begin
    TotalResteDPR := TotalResteDPR    -  TOBL.GetDouble('RESTEMT');
    TotalResteMAR := TotalResteMAR    -  TOBL.GetDouble('RESTEMT');
  end else
  begin
    TotalResteMAR := TotalResteDPR    +  TOBL.GetDouble('RESTEMT');
    TotalResteFAC := TotalResteFAC    -  TOBL.GetDouble('RESTEMT');
  end;

  FinAffaire      := TOBL.GetDouble('FINAFFAIRE') - TOBL.GetDouble('RESTEMT');
  FinAffairePA    := TOBL.GetDouble('FINAFFAIREPA') - TOBL.GetDouble('RESTEMT');
  //
  if Acol = ColResteQTE then
  begin
    Quantite:= valeur(GS.cells[Acol,Arow]);
    //
    if (TOBL.GetDouble('BUDGETQTE') <> 0) and (TOBL.GetDouble('BUDGETMTPA') <> 0) then
    begin
      PUAchat := TOBL.GetDouble('BUDGETMTPA')/TOBL.GetDouble('BUDGETQTE');
    end else
    begin
      if (TOBL.GetDouble('REALISEQTE') <> 0) and (TOBL.GetDouble('REALISEMTPA') <> 0) then
        PUAchat := TOBL.GetDouble('REALISEMTPA')/TOBL.GetDouble('REALISEQTE')
      else if (TOBL.GetDouble('REALISEQTEDEPUIS') <> 0) and (TOBL.GetDouble('REALISEDEPUISPA') <> 0) then
        PUAchat := TOBL.GetDouble('REALISEDEPUISPA')/TOBL.GetDouble('REALISEQTEDEPUIS');
    end;
    //
    if (TOBL.GetDouble('BUDGETQTE') <> 0) and (TOBL.GetDouble('BUDGETMT') <> 0) then
    begin
      PUR     := TOBL.GetDouble('BUDGETMT')/TOBL.GetDouble('BUDGETQTE');
    end else
    begin
      if (TOBL.GetDouble('REALISEQTE') <> 0) and (TOBL.GetDouble('REALISEMT') <> 0) then
        PUR   := TOBL.GetDouble('REALISEMT')/TOBL.GetDouble('REALISEQTE')
      else if (TOBL.GetDouble('REALISEQTEDEPUIS') <> 0) and (TOBL.GetDouble('REALISEDEPUIS') <> 0) then
        PUR   := TOBL.GetDouble('REALISEDEPUIS')/TOBL.GetDouble('REALISEQTEDEPUIS');
    end;

    MtReste   := PUR * Quantite;
    MtRestePA := PUAchat * Quantite;
    TOBL.SetDouble('RESTEQTE',   Arrondi(Quantite,   V_PGI.OkDecQ));
    TOBL.SetDouble('RESTEMTPA',  Arrondi(MtRestePA,  V_PGI.OkDecV));
    TOBL.SetDouble('RESTEMT',    Arrondi(MtReste,    V_PGI.OkDecV));
  end
  else if Acol = ColResteMT then
  begin
    MtReste   := Valeur(GS.cells[Acol,Arow]);
    TOBL.SetDouble('RESTEMT',    Arrondi(MtReste,    V_PGI.OkDecV));
  end;

  //Recalcul de fin d'affaire
  FinAffaire := FinAffaire + MtReste;
  FinAffairePA := FinAffairePA + MtReste;
  TOBL.PutValue('FINAFFAIRE', Arrondi(FinAffaire, V_PGI.OkDecV));
  TOBL.PutValue('FINAFFAIREPA', Arrondi(FinAffairePA, V_PGI.OkDecV));

  //Recalcul du Total Reste DPR apres modification de la valeur
  if TypeRess <> 'FAC' then
  begin
    TotalResteDPR := TotalResteDPR    +  TOBL.GetDouble('RESTEMT');
    TotalResteMAR := TotalResteMAR    +  TOBL.GetDouble('RESTEMT');
  end
  else
  Begin
    TotalResteMAR := TotalResteDPR    -  TOBL.GetDouble('RESTEMT');
    TotalResteFAC := TotalResteFAC    +  TOBL.GetDouble('RESTEMT');
  end;

  TotalisationColonnes;

  //Affichage de la grille
  GS.SynEnabled := false;
  GS.BeginUpdate;
  TRY
    TOBL.PutLigneGrid (GS,TOBL.GetIndex +1,false,false,fColNamesGS);
    RafraichitSSTot;
  FINALLY
    GS.SynEnabled := true;
    GS.EndUpdate;
  END;

end;

procedure TOF_BTSAISIERESTDEP.ZoneSuivanteOuOk(var ACol, ARow: integer; var Cancel: boolean);
var Sens    : Integer;
    Lim     : Integer;
    OldEna  : Boolean;
    ChgLig  : Boolean;
    //ChgSens : Boolean;
    lastCol,LastRow : integer;
begin

  LastCol := Acol;
  LastRow := ARow;
  OldEna := GS.SynEnabled;
  GS.SynEnabled := False;

  Sens := -1;

  ChgLig := (GS.Row <> ARow);
  //ChgSens := False;

  if GS.Row > ARow then Sens := 1 else if ((GS.Row = ARow) and (ACol <= GS.Col)) then Sens := 1;

  ACol := GS.Col;
  ARow := GS.Row;

  Journalconso := '';

  if (ACol = ColRealiseMT) then
    JournalConso := 'REALISE'
  else if (ACol = ColDepuisMT) then
    JournalConso := 'DEPUIS'
  else  if (ACol = ColRealiseQte) then
    JournalConso := 'REALISE'
  else if (ACol = ColDepuisQte) then
    JournalConso := 'DEPUIS';

  If Journalconso <> '' then
  begin
    Acol := LastCol;
    Cancel := true;
  end;

  while not ZoneAccessible(ACol, ARow) do
  begin
    Cancel := True;
    //
    if Sens = 1 then
    begin
      Lim := GS.RowCount -1;
      // ---
      if ((ACol > ColResteMT) and (ARow >= Lim)) then
      begin
        Acol := LastCol;
        ARow := LastRow;
        Cancel := true;
        break;
      end;

      if ChgLig then
      begin
        ACol := GS.FixedCols - 1;
        ChgLig := False;
      end;
      if ACol < GS.ColCount - 1 then
      begin
        Inc(ACol);
      end else
      begin
        Inc(ARow);
        ACol := GS.FixedCols;
      end;
    end else
    begin
      if ((ACol <= ColResteQTE) and (ARow <= 2)) then
      begin
        Acol := LastCol;
        ARow := LastRow;
        Cancel := true;
        break;
      end;
      if ChgLig then
      begin
        ACol := GS.ColCount;
        ChgLig := False;
      end;
      if ACol > GS.FixedCols then
        Dec(ACol)
      else
      begin
        Dec(ARow);
        ACol := GS.ColCount - 1;
      end;
    end;
  end;

  GS.SynEnabled := OldEna;

end;

function TOF_BTSAISIERESTDEP.ZoneAccessible(var ACol, ARow: integer): boolean;
Var TypeLigne : String;
    TypeRess  : String;
    TypeNat   : String;
    TOBL      : TOB;
begin

  Result := False;
            
  //FV1 : 25/10/2016 - FS#2207 - TEAM RESEAUX ; en saisie RAD,
  if (RADDefinitf) and (not Ok_ModifRadValide) then exit;

  if (Tobgrille = nil) Or (TobGrille.detail.count = 0) Or (TobGrille.detail.count < ARow) then exit;

  TOBL := GetTOBGrille(Arow);

  if TOBL = nil then exit;

  TypeLigne := TobL.GetString('TYPELIGNE');
  TypeRess  := TobL.GetString('TYPERESSOURCE');
  TypeNat   := TobL.GetString('NATUREPRESTATION');

  if (TypeLigne = 'TI') or (TypeLigne='ST') then
  begin
    if (Typeress = 'PRV') and ((Acol = ColFinAffaire) or (Acol = ColFinAffairePA)) and (Arow <> 1) then
    begin
      Result := True;
    end;
    exit;
  end;

  if ((TypeRess= 'SAL') OR (TypeRess = 'INT')) AND (TypeNat <> 'FRA') then
  begin
    if ((Acol = ColResteQte) Or (Acol = ColResteMt)) and (ARow <> 1) then
    begin
      Result := True;
      Exit;
    end;
  end
  else
  begin
    if (Acol = ColResteMt) and (ARow <> 1) then
    begin
      Result := True;
      Exit;
    end;
  end;

end;

procedure TOF_BTSAISIERESTDEP.GetCellCanvas(ACol, ARow: Integer; Canvas: TCanvas; AState: TGridDrawState);
var TOBl : TOB;
begin
  if (ACol < GS.FixedCols) or (Arow < GS.Fixedrows) then Exit;
  //
  TOBL := GetTOBGrille(ARow);

  if TOBL = nil then Exit;

  if TOBL.GetString('TYPELIGNE')='TI' then
  begin
    // gestion des titres
    Canvas.Font.Style := Canvas.Font.Style + [fsBold];
//    
    if (Acol = ColBudgetQte) Or (Acol=ColBudgetMT) Or (Acol=ColBudgetMTPA)        then
      GS.Canvas.Brush.Color := $f8dfdf
    else if (Acol=ColRealiseQte) Or (Acol=ColRealiseMt) Or (Acol=ColRealiseMtPA) Or (Acol=ColEngage)    then
      GS.Canvas.Brush.Color := $f5dff8
    else if (Acol=ColDepuisQte) Or (Acol=ColDepuisMt) Or (Acol=ColDepuisMtPA)   then
      GS.Canvas.Brush.Color := $cff6f6
    else if (Acol=ColTheoQte) Or (Acol=ColTheoMT) Or (Acol=ColTheoMTPA)   then
      GS.Canvas.Brush.Color := $def7de
    else if (Acol=ColResteQTE) Or (Acol=ColResteMT)  then
      GS.Canvas.Brush.Color := ClCream
    else if (Acol=ColFinAffaire) or (Acol=ColFinAffairePA) then
      GS.Canvas.Brush.Color := $cfd6f6;
  end
  else if TOBL.GetString('TYPELIGNE')='ST' then
  begin
    // Gestion des sous totaux
    canvas.Brush.Color := clActiveBorder;
    Canvas.Font.Style  := Canvas.Font.Style + [fsBold];
    if TOBL.GetString('TYPERESSOURCE')='PRV' then
    begin
      // ligne de provisions
      if (Acol=ColFinAffaire) or (Acol=ColFinAffairePA)  then
        GS.Canvas.Brush.Color := $cfd6f6;
    end;
  end
  else
  begin
    if (Acol = ColBudgetQte) Or (Acol=ColBudgetMT) Or (Acol=ColBudgetMTPA)       then
      GS.Canvas.Brush.Color := $f8dfdf
    else if (Acol=ColRealiseQte) Or (Acol=ColRealiseMt) Or (Acol=ColRealiseMtPA) Or (Acol=ColEngage)    then
      GS.Canvas.Brush.Color := $f5dff8
    else if (Acol=ColDepuisQte) Or (Acol=ColDepuisMt)  Or (Acol=ColDepuisMtPA)   then
      GS.Canvas.Brush.Color := $cff6f6
    else if (Acol=ColTheoQte) Or (Acol=ColTheoMT)  Or (Acol=ColTheoMTPA)    then
      GS.Canvas.Brush.Color := $def7de
    else if (Acol=ColResteQTE) Or (Acol=ColResteMT)  then
      GS.Canvas.Brush.Color := ClCream
    else if (Acol=ColFinAffaire) or (Acol=ColFinAffairePA)  then
      GS.Canvas.Brush.Color := $cfd6f6;
  end;
end;



procedure TOF_BTSAISIERESTDEP.PostDrawCell(ACol, ARow: Integer; Canvas: TCanvas; AState: TGridDrawState);
var Arect     : Trect;
    TOBL      : TOB;
    Decalage,LL,HH  : integer;
    TheText   : string;
    Mt,Coef,Pourcent,PR : double;
begin

  if GS.RowHeights[ARow] <= 0 then Exit;

  ARect := GS.CellRect(ACol, ARow);

  if (ACol < GS.FixedCols) or (ARow < GS.FixedRows) then exit;

  GS.Canvas.Pen.Style := psSolid;
  GS.Canvas.Brush.Style := BsSolid;

  TOBL := GetTOBGrille(ARow);

  if TOBL = nil then exit;

  Decalage := canvas.TextWidth('w') * 3;

  if (Acol = 1) and (TOBL.GetString('TYPELIGNE')='LI')then
  begin
    TheText := TOBL.GetString('LIBTYPEARTICLE');
    Canvas.FillRect(ARect);
    GS.Canvas.Brush.Style := bsSolid;
    GS.Canvas.TextOut (Arect.left+Decalage+1,Arect.Top +2 ,Thetext);
  end;
  if TOBL.GetString('TYPERESSOURCE')='MRG' then
  begin
    if (Acol = 1) or
       (Acol = ColBudgetMT) or (aCol = ColBudgetMTPA) or
       (Acol = ColRealiseMt) or (Acol = ColRealiseMtPA) or
       (Acol = ColTheoMT) or (Acol = ColTheoMTPA) or
       (Acol = ColFinAffaire) or (Acol = ColFinAffairePA) then
    begin
      Canvas.FillRect(ARect);
      if (Acol = 1) then
      begin
        TheText := TOBL.GetString('LIBTYPEARTICLE');
        //LL := GS.Canvas.TextWidth(TheText);
        //
        GS.Canvas.Brush.Style := bsSolid;
        GS.Canvas.TextOut ( (Arect.left + 2),Arect.Top +2 ,Thetext);
        if Ok_Marque then
          TheText := 'Coef. Marque'
        else
          TheText := 'Coef. Marge';
        HH := GS.Canvas.TextHeight(TheText);
        GS.Canvas.TextOut ( (Arect.Left + 10),Arect.Top +4 + HH ,Thetext);
        if Ok_Marque then
          TheText := '% Marque'
        else
          TheText := '% Marge';
        GS.Canvas.TextOut ( (Arect.left + 10),Arect.Top +6 + 2 * HH ,Thetext);
        exit;
      end;
      Mt := 0;
      PR := 0;
      if (Acol = ColBudgetMT) then
      begin
        Mt :=  TOBL.GetValue('BUDGETMT');
        if Ok_Marque then
          PR :=  TOBL.GetValue('BASEBUDGETFAC')
        else
          PR :=  TOBL.GetValue('BASEBUDGET');
      end else if (Acol = ColBudgetMTPA) then
      begin
        Mt :=  TOBL.GetValue('BUDGETMTPA');
        if Ok_Marque then
          PR :=  TOBL.GetValue('BASEBUDGETFAC')
        else
          PR :=  TOBL.GetValue('BASEBUDGETPA');
      end else if (Acol = ColRealiseMt) then
      begin
        Mt :=  TOBL.GetValue('REALISEMT');
        if Ok_Marque then
          PR :=  TOBL.GetValue('BASEREALISEFAC')
        else
          PR :=  TOBL.GetValue('BASEREALISE');
      end else if (Acol = ColRealiseMtPA) then
      begin
        Mt :=  TOBL.GetValue('REALISEMTPA');
        if Ok_Marque then
          PR :=  TOBL.GetValue('BASEREALISEFAC')
        else
          PR :=  TOBL.GetValue('BASEREALISEPA');
      end else if (Acol = ColTheoMT) then
      begin
        Mt :=  TOBL.GetValue('THEOMT');
        if Ok_Marque then
          PR :=  TOBL.GetValue('BASETHEOFAC')
        else
          PR :=  TOBL.GetValue('BASETHEORIQUE');
      end else if (Acol = ColTheoMTPA) then
      begin
        Mt :=  TOBL.GetValue('THEOMTPA');
        if Ok_Marque then
          PR :=  TOBL.GetValue('BASETHEOFAC')
        else
          PR :=  TOBL.GetValue('BASETHEORIQUEPA');
      end else if (Acol = ColFinAffaire) then
      begin
        Mt :=  TOBL.GetValue('FINAFFAIRE');
        if Ok_Marque then
          PR :=  TOBL.GetValue('BASEFINAFFFAC')
        else
          PR :=  TOBL.GetValue('BASEFINAFFAIRE');
      end else if (Acol = ColFinAffairePA) then
      begin
        Mt :=  TOBL.GetValue('FINAFFAIREPA');
        if Ok_Marque then
          PR :=  TOBL.GetValue('BASEFINAFFFAC')
        else
          PR :=  TOBL.GetValue('BASEFINAFFAIREPA');
      end;
      //
      //
      //
      if PR <> 0 then
      begin
        Coef := 1+Arrondi(Mt/PR,4);
        pourcent := Arrondi((Mt/PR)*100,2);
      end
      else
      begin
        Coef := 1;
        Pourcent := 100;
      end;
      //
      TheText := StrF00 ( Mt,2);
      GS.Canvas.Brush.Style := bsSolid;
      LL := GS.Canvas.TextWidth(TheText);
      HH := GS.Canvas.TextHeight(TOBL.GetString('LIBTYPEARTICLE'));
      //
      GS.Canvas.TextOut ( (Arect.right -LL - 2),Arect.Top +2 ,Thetext);
      TheText := StrF00 (Coef,4);
      LL := GS.Canvas.TextWidth(TheText);
      GS.Canvas.TextOut ( (Arect.right -LL - 2),Arect.Top +4 + HH ,Thetext);
      //
      if Pourcent <> 0 then
        TheText := StrF00 (Pourcent,2)+' %'
      else
        TheText := '';
      LL := GS.Canvas.TextWidth(TheText);
      GS.Canvas.TextOut ( (Arect.right -LL - 2),Arect.Top +6 + 2 * HH ,Thetext);
    end;
  end;

end;

function TOF_BTSAISIERESTDEP.GetTOBGrille(ARow: integer): TOB;
begin
  result := nil;
  if Arow > TOBGrille.detail.count Then exit;
  Result := TOBGrille.detail[Arow -1];
end;

procedure TOF_BTSAISIERESTDEP.NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_:THEdit);
begin

  Aff:=THEdit(GetControl('AFFAIRE'));

  // MODIF LS
  Aff0 := THEdit(GetControl('AFFAIRE0'));

  // --
  Aff1 := THEdit(GetControl('AFFAIRE1'));
  Aff2 := THEdit(GetControl('AFFAIRE2'));
  Aff3 := THEdit(GetControl('AFFAIRE3'));
  Aff4 := THEdit(GetControl('AVENANT'));
  Tiers:= THEdit(GetControl('TIERS'));

  // affaire de r�f�rence pour recherche
  Aff_ := THEdit(GetControl('AFF_AFFAIREREF'));
  Aff1_:= THEdit(GetControl('AFFAIREREF1'));
  Aff2_:= THEdit(GetControl('AFFAIREREF2'));
  Aff3_:= THEdit(GetControl('AFFAIREREF3'));
  Aff4_:= THEdit(GetControl('AFFAIREREF4'));

end;

procedure TOF_BTSAISIERESTDEP.ChargementFirstAffaire;
begin

  //Si un seul enregistrement ne pas afficher les bouton de navigation....
  If LaTob.Detail.Count = 1 then
  Begin
    BPremier.visible    := false;
    BPrecedent.visible  := false;
    BSuivant.visible    := false;
    BDernier.visible    := false;
  end;

  LastEnreg := 0;

  AFFAIRE.Text := LaTob.detail[0].GetString('AFFAIRE');

  DATEARRETEE.Text := DateToStr(LaTob.detail[0].GetDateTime('DATEARRETEE'));

end;

procedure TOF_BTSAISIERESTDEP.CHKAllNatOnClick(Sender: TObject);
begin

  if OK_LanceReq then LanceReqOnClick(Self);

end;

procedure TOF_BTSAISIERESTDEP.CHKEngageOnClick(Sender: TObject);
begin

  VisuEngage := CHKEngage.Checked;

  // d�finition de la grille
  DefinieGrid;

  //dessin de la grille
  DessineGrille;

  if OK_LanceReq then LanceReqOnClick(Self);

end;

procedure TOF_BTSAISIERESTDEP.CHKGestionEnPaOnClick(Sender: TObject);
begin

  GestionEnPa := CHKGestionEnPa.Checked;

  // d�finition de la grille
  DefinieGrid;

  //dessin de la grille
  DessineGrille;

  if OK_LanceReq then LanceReqOnClick(Self);

end;


procedure TOF_BTSAISIERESTDEP.BDernierOnClick(Sender: TObject);
begin

  //controle si au moins une saisie � �t� faite...
  If Ok_CtrlSaisie then
  begin
    if PGIAsk('Des modifications ont �t� effectu�es, voulez-vous les enregistrer ?', 'Sauvegarde RAD')=MrYes then
    begin
      ValiderOnClick(Self);
    end;
  end;

  //if OK_LanceReq then ValiderOnClick(Self);

  LastEnreg := LaTOb.detail.count-1;

  AFFAIRE.Text := LaTob.detail[Lastenreg].GetString('AFFAIRE');

  ChargeInfoAffaire;

  //if OK_LanceReq then
  LanceReqOnClick(Self);

end;

procedure TOF_BTSAISIERESTDEP.BPrecedentOnClick(Sender: TObject);
begin

  //controle si au moins une saisie � �t� faite...
  If Ok_CtrlSaisie then
  begin
    if PGIAsk('Des modifications ont �t� effectu�es, voulez-vous les enregistrer ?', 'Sauvegarde RAD')=MrYes then
    begin
      ValiderOnClick(Self);
    end;
  end;

  //if OK_LanceReq then ValiderOnClick(Self);

  If Lastenreg <> 0 then  LastEnreg := LastEnreg - 1;

  AFFAIRE.Text := LaTob.detail[Lastenreg].GetString('AFFAIRE');

  ChargeInfoAffaire;

  //if OK_LanceReq then
  LanceReqOnClick(Self);

end;

procedure TOF_BTSAISIERESTDEP.BPremierOnClick(Sender: TObject);
begin

  //controle si au moins une saisie � �t� faite...
  If Ok_CtrlSaisie then
  begin
    if PGIAsk('Des modifications ont �t� effectu�es, voulez-vous les enregistrer ?', 'Sauvegarde RAD')=MrYes then
    begin
      ValiderOnClick(Self);
    end;
  end;

  //if OK_LanceReq then ValiderOnClick(Self);

  LastEnreg := 0;

  AFFAIRE.Text := LaTob.detail[Lastenreg].GetString('AFFAIRE');

  ChargeInfoAffaire;

  //if OK_LanceReq then
  LanceReqOnClick(Self);

end;

procedure TOF_BTSAISIERESTDEP.BSuivantOnClick(Sender: TObject);
begin

  //controle si au moins une saisie � �t� faite...
  If Ok_CtrlSaisie then
  begin
    if PGIAsk('Des modifications ont �t� effectu�es, voulez-vous les enregistrer ?', 'Sauvegarde RAD')=MrYes then
    begin
      ValiderOnClick(Self);
    end;
  end;

  //if OK_LanceReq then ValiderOnClick(Self);

  If Lastenreg <> LaTob.detail.count-1 then  LastEnreg := LastEnreg + 1;

  AFFAIRE.Text := LaTob.detail[Lastenreg].GetString('AFFAIRE');

  ChargeInfoAffaire;

  //if OK_LanceReq then
  LanceReqOnClick(Self);

end;

procedure TOF_BTSAISIERESTDEP.BSaisieConsoOnClick(Sender: TObject);
begin

  AGLLanceFiche('BTP', 'BTSAISIECONSO', '','','MODIFICATION');

end;

procedure TOF_BTSAISIERESTDEP.TraitelesOuvrages(TOBLIGNESO, TOBOUVRAGES,TOBBudget: TOB);

  procedure ConstitueBudgetFin (Qte : Double;TOBOuv,TOBBudget : TOB);
  var TOBB : TOB;
  begin
    TOBB := TOB.Create('Le BUDGET',TOBBudget,-1);
    TOBB.AddChampSupValeur('TYPEELT','BUDGET');
    TOBB.AddChampSupValeur('TYPERESSOURCE',   TOBOuv.GetString('TYPERESSOURCE'));
    TOBB.AddChampSupValeur('NATUREPRESTATION',TOBOuv.GetString('NATUREPRESTATION'));
    TOBB.AddChampSupValeur('TYPEARTICLE',     TOBOuv.GetString('TYPEARTICLE'));
    TOBB.AddChampSupValeur('TYPELIGNE',       'ART');
    TOBB.AddChampSupValeur('CODEARTICLE',     TOBOuv.GetString('BLO_CODEARTICLE'));
    TOBB.AddChampSupValeur('LIBELLEART',      TOBOuv.GetString('BLO_LIBELLE'));
    TOBB.AddChampSupValeur('BUDGETQTE',       Qte);
    TOBB.AddChampSupValeur('BUDGETMTPA',      Arrondi(Qte*TOBOuv.GetDouble('BLO_DPA'),4));
    TOBB.AddChampSupValeur('BUDGETMT',        Arrondi(Qte*TOBOuv.GetDouble('BLO_DPR'),4));
    TOBB.AddChampSupValeur('CODEAFFAIRE',     TOBOuv.GetString('BLO_AFFAIRE'));
    TOBB.AddChampSupValeur('REVIENT',         TOBOuv.GetString('BLO_DPR'));
  end;

  procedure ConstitueBudgetDet (Qte : Double;TOBOuv,TOBBudget : TOB);
  var QteSuite,QteDuDetail : double;
      II : Integer;
      TOBO : TOB;
  begin
    For II := 0 to TOBOuv.Detail.count -1 do
    begin
      TOBO := TOBOuv.detail[II];
      QteDuDetail := TOBO.GetInteger('BLO_QTEDETAIL'); if QteDuDetail = 0 then QteDuDetail := 1;
      QteSuite := Arrondi(Qte * TOBO.GetDouble('BLO_QTEFACT') / QteDuDetail,V_PGI.OkDecQ);
      if TOBO.detail.count > 0 then
      begin
        ConstitueBudgetDet (QteSuite,TOBO,TOBBudget);
      end else
      begin
        ConstitueBudgetFin (QteSuite,TOBO,TOBBudget);
      end;
    end;
  end;

  procedure ConstitueBudget (TOBL,TOBOuv,TOBBudget : TOB);
  var Qte : Double;
      II : Integer;
      TOBO : TOB;
      QteSuite,QteDuDetail : double;
  begin
    Qte := TOBL.GetInteger('GL_QTEFACT');
    for II := 0 to TOBOuv.Detail.count -1 do
    begin
      TOBO := TOBOuv.detail[II];
      QteDuDetail := TOBO.GetInteger('BLO_QTEDUDETAIL');
      if QteDuDetail = 0 then QteDuDetail := 1;
      QteSuite := Arrondi(Qte * TOBO.GetDouble('BLO_QTEFACT') / QteDuDetail,V_PGI.OkDecQ);
      if TOBO.detail.count > 0 then
      begin
        ConstitueBudgetDet (QteSuite,TOBO,TOBBudget);
      end else
      begin
        ConstitueBudgetFin (QteSuite,TOBO,TOBBudget);
      end;
    end;
  end;

var II : Integer;
    TOBL,TOBOuv : TOB;
    IndiceNomen : Integer;
begin
  For II := 0 to TOBLIGNESO.detail.count -1 do
  begin
    TOBL := TOBLIGNESO.detail[II];
    IndiceNomen := TOBL.GetInteger('GL_INDICENOMEN');
    if IndiceNomen= 0 Then Continue;
    if TOBOUVRAGES.detail.count = 0 then
    begin
      PGIInfo('Attention il existe des ouvrages sans sous-d�tails. V�rifiez votre document : ' + TOBL.GetValue('GL_NATUREPIECEG') + '-' + TOBL.GetValue('GL_SOUCHE')+ '-' + IntToStr(TOBL.GetValue('GL_NUMERO')));
    end
    else
    begin
      if II >= TOBOUVRAGES.detail.count then Continue;
      TOBOuv := TOBOUVRAGES.detail[IndiceNomen-1];
    end;
    //
    if TOBOUv = nil then exit;

    ConstitueBudget (TOBL,TOBOuv,TOBBudget);
  end;
end;

procedure TOF_BTSAISIERESTDEP.ChargementEngage(DateArrete: TDateTime);

  function ConstitueRefPiece (TOBE : TOB) : string;
  var std : string;
  begin
    StD := FormatDateTime('ddmmyyyy', TOBE.GetValue('DATEPIECE'));
    Result := StD + ';' + TOBE.GetValue('NATUREPIECEG') + ';' +
              TOBE.GetValue('SOUCHE')  + ';' +
              IntToStr(TOBE.GetValue('NUMERO') ) + ';' +
              IntToStr(TOBE.GetValue('INDICEG') ) + ';' +
              IntToStr(TOBE.GetValue('NUMORDRE')) + ';';
  end;

  procedure ConstitueEngageADate (TOBEngage: TOB; DateArrete : TDateTime);
  var QQ : TQuery;
      SQL : string;
  begin

    SQl := 'SELECT "TYPEELT" = "ENGAGE", ' +
             '"TYPERESSOURCE" = CASE GLC_NATURETRAVAIL WHEN "002" THEN "ST" ELSE BNP_TYPERESSOURCE END, '+
             '"NATUREPRESTATION" = CASE GA_NATUREPRES WHEN " " THEN GA_TYPEARTICLE ELSE GA_NATUREPRES END,'+
             'GA_TYPEARTICLE AS TYPEARTICLE,'+
             'GL_ARTICLE    AS CODEARTICLE,'+
             'GL_LIBELLE    AS LIBELLEART,'+
             'GL_QTEFACT*GL_PUHTNET  AS ENGAGE,'+
             'GL_QTEFACT     AS QUANTITE,'+
             'GL_PUHTNET        AS REVIENT, '+
             'GL_AFFAIRE    AS CODEAFFAIRE, '+
             'GL_NATUREPIECEG AS NATUREPIECEG,'+
             'GL_SOUCHE AS SOUCHE,'+
             'GL_NUMERO AS NUMERO,'+
             'GL_INDICEG AS INDICEG,'+
             'GL_NUMORDRE AS NUMORDRE,'+
             'GL_DATEPIECE AS DATEPIECE,'+
             '0 AS QTERECEPT, '+
             'GL_QTEFACT AS RESTE '+
             'FROM LIGNE '+
             'LEFT JOIN ARTICLE ON GA_ARTICLE=GL_ARTICLE '+
             'LEFT JOIN NATUREPREST ON BNP_NATUREPRES=GA_NATUREPRES '+
             'LEFT JOIN LIGNECOMPL  ON GLC_NATUREPIECEG=GL_NATUREPIECEG  AND '+
                  'GLC_SOUCHE=GL_SOUCHE AND GLC_NUMERO=GL_NUMERO AND GLC_INDICEG=GL_INDICEG AND '+
                  'GLC_NUMORDRE=GL_NUMORDRE '+
             'WHERE GL_DATEPIECE >= "' + UsDateTime(DateArrete) + '" '+
             'AND GL_NATUREPIECEG IN ("BLF","LFR","FF") ' +
             'AND GL_AFFAIRE ="' + AFFAIRE.Text + '" AND '+
             'AND GL_TYPELIGNE="ART" '+
             'ORDER BY TYPEELT, TYPERESSOURCE, NATUREPRESTATION';
    QQ := OpenSQL(SQL, False);

    If Not QQ.eof then
    begin
      TOBEngage.LoadDetailDB('Le DETAIL','','',QQ, True);
    end;
    Ferme (QQ);
  end;

Var STSQL : String;
    QQ        : TQuery;
    TOBEngage  : TOB;
begin
  DateArrete := IncDay(DateArrete, 1);

  TOBEngage := TOB.Create('L ENGAGE', nil, -1);
  //Chargement du command� depuis
  StSQl := 'SELECT "TYPEELT" = "ENGAGE", ' +
           '"TYPERESSOURCE" = CASE GLC_NATURETRAVAIL WHEN "002" THEN "ST" ELSE BNP_TYPERESSOURCE END, '+
           '"NATUREPRESTATION" = CASE GA_NATUREPRES WHEN " " THEN GA_TYPEARTICLE ELSE GA_NATUREPRES END,'+
           'GA_TYPEARTICLE  AS TYPEARTICLE,'+
           'GL_ARTICLE      AS CODEARTICLE,'+
           'GL_LIBELLE      AS LIBELLEART,'+
           'GL_QTERESTE*GL_PUHTNET  AS ENGAGE,'+
           'GL_QTERESTE     AS QUANTITE,'+
           'GL_PUHTNET      AS REVIENT, '+
           'GL_AFFAIRE      AS CODEAFFAIRE, '+
           'GL_NATUREPIECEG AS NATUREPIECEG,'+
           'GL_SOUCHE       AS SOUCHE,'+
           'GL_NUMERO       AS NUMERO,'+
           'GL_INDICEG      AS INDICEG,'+
           'GL_NUMORDRE     AS NUMORDRE,'+
           'GL_DATEPIECE    AS DATEPIECE,'+
           '0               AS QTERECEPT, '+
           'GL_MTRESTE      AS MTRESTE '+
           'FROM LIGNE '+
           'LEFT JOIN ARTICLE ON GA_ARTICLE=GL_ARTICLE '+
           'LEFT JOIN NATUREPREST ON BNP_NATUREPRES=GA_NATUREPRES '+
           'LEFT JOIN LIGNECOMPL  ON GLC_NATUREPIECEG=GL_NATUREPIECEG  AND '+
                'GLC_SOUCHE=GL_SOUCHE AND GLC_NUMERO=GL_NUMERO AND GLC_INDICEG=GL_INDICEG AND '+
                'GLC_NUMORDRE=GL_NUMORDRE '+
           //FV1 - 25/10/2016 - FS#2207 - TEAM RESEAUX ; en saisie RAD, modifier la valeur de l'engag� en engag� depuis.
           //'WHERE GL_DATEPIECE < "' + UsDateTime(DateArrete) + '" '+
           'WHERE GL_DATEPIECE > "' + UsDateTime(DateArrete) + '" '+
           'AND GL_NATUREPIECEG = "CF" ' +
           'AND GL_AFFAIRE ="' + AFFAIRE.Text + '" '+
           'AND GL_TYPELIGNE="ART" '+
           'AND (GL_QTERESTE <> 0 OR GL_MTRESTE <> 0)'+
           'ORDER BY TYPEELT, TYPERESSOURCE, NATUREPRESTATION';

  QQ := OpenSQL(StSQL, False);

  If Not QQ.eof then
  begin
    TOBEngage.LoadDetailDB('Le DETAIL','','',QQ, False);
    ConstitueEngageADate (TOBEngage,DateArrete);
    DispatchTob(TOBEngage);
  end;
  Ferme (QQ);
  
  TOBEngage.free;

end;

procedure TOF_BTSAISIERESTDEP.ConstitueDateArrete;
var DateTemp : TDateTime;
begin
  DateTemp := StrToDAte('01/' + MOIS.text + '/' + ANNEE.Text);
  DateTemp := FinDeMois(DateTemp);
  DATEARRETEE.text := DateToStr(DateTemp);
end;

procedure TOF_BTSAISIERESTDEP.BDeleteClick(Sender: Tobject);
var StSql,ST : string;
begin
  if PgiAsk ('ATTENTION : Vous allez supprimer la saisie de ce reste � d�pnser.#13#10 Confirmez-Vous ?')<> MrYes then exit;
  StSQl := 'DELETE FROM BTRESTEADEP WHERE RAD_AFFAIRE="' + AFFAIRE.Text + '" AND '+
           'RAD_DATEARRETEE  ="' + USDATETIME(StrtoDate(DATEARRETEE.text))+ '" ';
  ExecuteSql (StSql);
  St := 'Reste � d�penser de l''affaire '+AFFAIRE.Text+' Pour la date du '+DATEARRETEE.text;
  AjouteEventSUPRESS (St);
  TFVierge(Ecran).ModalResult  := 2;
end;


procedure TOF_BTSAISIERESTDEP.AjouteEventSUPRESS (MessEvent : string);
var QQ: TQuery;
  MotifPiece: TStrings;
  NumEvent: integer;
  LeLibelle: string;
begin
  LeLibelle := 'Supression d''une saisie de reste � d�penser';
  MotifPiece := TStringList.Create;
  MotifPiece.Add(MessEvent);
  NumEvent := 0;
  QQ := OpenSQL('SELECT MAX(GEV_NUMEVENT) FROM JNALEVENT', True,-1, '', True);
  if not QQ.EOF then NumEvent := QQ.Fields[0].AsInteger;
  Ferme(QQ);
  Inc(NumEvent);
  QQ := OpenSQL('SELECT * FROM JNALEVENT WHERE GEV_TYPEEVENT="BRD" AND GEV_NUMEVENT=-1', False);
  QQ.Insert;
  InitNew(QQ);
  QQ.FindField('GEV_NUMEVENT').AsInteger := NumEvent;
  QQ.FindField('GEV_TYPEEVENT').AsString := 'BRD';
  QQ.FindField('GEV_LIBELLE').AsString := LeLibelle;
  QQ.FindField('GEV_DATEEVENT').AsDateTime := Date;
  QQ.FindField('GEV_UTILISATEUR').AsString := V_PGI.User;
  QQ.FindField('GEV_ETATEVENT').AsString := 'OK';
  TMemoField(QQ.FindField('GEV_BLOCNOTE')).Assign(MotifPiece);
  QQ.Post;
  Ferme(QQ);
  MotifPiece.Free;
end;

Initialization
  registerclasses ( [ TOF_BTSAISIERESTDEP ] ) ;
end.

