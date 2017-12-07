{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 16/03/2015
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : INTEGREFICTPI ()
Mots clefs ... : TOF;INTEGREFICTPI
*****************************************************************}
Unit Utof_BTIntegrefictpi ;

Interface

Uses vierge,
     StdCtrls,
     Controls, 
     Classes,
{$IFNDEF EAGLCLIENT}
     db,
     FE_Main,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF} 
     mul,
{$else}
     eMul, 
     uTob, 
{$ENDIF}
     forms,
     sysutils, 
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     Utob,
     HTB97,
     Windows,
     UtilsEtat,
		 hPDFPrev,
     hPDFViewer,
     uPDFBatch,
     Graphics,
     Grids,
     UTOF ;

Type
  TOF_INTEGREFICTPI = Class (TOF)
    //
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
//

  Private
    //
    FichierImport   : THEdit;
    DateMvt         : THEdit;
    Analyse         : THEdit;
    Depot           : THEdit;
    //
    Client          : THEdit;
    Affaire         : THEdit;
    Affaire0        : THEdit;
    Affaire1        : THEdit;
    Affaire2        : THEdit;
    Affaire3        : THEdit;
    Avenant         : THEdit;
    CAB_Affaire     : THEdit;
    //
    CodeTiers       : THEdit;
    CAB_Tiers       : THEdit;
    Juridique       : THLabel;
    Nom             : THLabel;
    ADR1            : THLabel;
    ADR2            : THLabel;
    ADR3            : THLabel;
    ADR4            : THLabel;
    CP              : THLabel;
    Ville           : THLabel;
    //
    TNumCde         : THLabel;
    TNumBL          : THLabel;
    NumCde          : THEdit;
    NumBL           : THEdit;
    //
    BTSelectNumCde  : TToolBarButton97;
    BTSelectNumBL   : TToolBarButton97;
    //
    CodeArticle     : THEdit;
    Article         : THEdit;
    Qte             : THNumEdit;
    CoefUSUV        : THEdit;
    CoefUAUS        : THEdit;
    PAHT            : THEdit;
    PAUA            : THEdit;
    DPA             : THEdit;
    PMAP            : THEdit;
    CAB_Article     : THEdit;
    //
    Aff_Ferme       : TCheckBox;
    Frs_Ferme       : TCheckBox;
    Art_Ferme       : TCheckBox;
    Art_TenueStock  : TCheckBox;
    //
    Lib_Depot       : THLabel;
    Lib_Affaire     : THLabel;
    Lib_Tiers       : THLabel;
    Lib_Article     : THLabel;
    Lib_Responsable : THLabel;
    Lib_Domaine     : THLabel;
    LIB_TenueStock  : THLabel;
    CaptionErreur   : THLabel;
    //
    PageGrille      : TPageControl;
    PToutes         : TTabSheet;
    PAnomalies      : TTabSheet;
    //
    Pages           : TPageControl;
    PGeneralite     : TTabSheet;
    PAffaire        : TTabSheet;
    PFournisseur    : TTabSheet;
    PArticle        : TTabSheet;
    PEdition        : TTabSheet;
    PInventaire     : TTabSheet;
    //
    TypeMVT         : THValComboBox;
    Art_QualifCAB   : THValComboBox;
    Frs_QualifCAB   : THValComboBox;
    Aff_QualifCAB   : THValComboBox;
    QualifUS        : THValComboBox;
    QualifUA        : THValComboBox;
    QualifUV        : THValComboBox;
    //
    OkAccepte       : Boolean;
    //
    FichierHisto    : String;
    //
    Grille          : THGrid;
    Grille1         : THGrid;
    Grille2         : THGrid;
    //
    FF              : string;
    //
    fColNamesGrille     : string;
    Falignement         : string;
    Ftitre              : string;
    fLargeur            : string;
    //
    fColNamesGrille1    : string;
    FalignementGrille1  : string;
    FtitreGrille1       : string;
    fLargeurGrille1     : string;
    //
    fColNamesGrille2    : string;
    FalignementGrille2  : string;
    FtitreGrille2       : string;
    fLargeurGrille2     : string;
    //
    Domaine         : string;
    Etablissement   : string;
    LibErreur       : String;
    //
    QQ              : TQuery ;
    StSQL           : String ;
    //
    TOBGrille       : TOB;
    TobAnomalie     : TOB;
    TobValide       : TOB;
    TobRejete       : TOB;
    TobInventaire   : TOB;
    //
    TOBPiece        : TOB;
    TobLigne        : TOB;
    //
    TOBAffaire      : TOB;
    TOBTiers        : TOB;
    TobArticle      : TOB;
    TobDepot        : TOB;
    //
    BtImport        : TToolBarButton97;
    //
    BtSelect1       : TToolBarButton97;
    BtSelect2       : TToolBarButton97;
    BtSelect3       : TToolBarButton97;
    //
    BtEfface1       : TToolBarButton97;
    BtEfface2       : TToolBarButton97;
    BtEfface3       : TToolBarButton97;
    //
    BtSelectCAB1    : TToolBarButton97;
    BtSelectCAB2    : TToolBarButton97;
    BtSelectCAB3    : TToolBarButton97;
    //
    BGeneration     : TToolBarButton97;

    //Variable névcessaire pour la gestion de l'état
    BParamEtat    : TToolBarButton97;
    //
    ChkApercu     : TCheckBox;
    ChkReduire    : TCheckBox;
    ChkCouleur    : TCheckBox;
    //
    FETAT         : THValComboBox;
    TEtat         : ThLabel;
    //
    OptionEdition : TOptionEdition;
    TheType       : String;
    TheNature     : String;
    TheTitre      : String;
    TheModele     : String;
    //
    FETAT1        : THValComboBox;
    TEtat1        : ThLabel;
    BParamEtat1   : TToolBarButton97;
    //
    OptionEdition1: TOptionEdition;
    TheType1      : String;
    TheNature1    : String;
    TheTitre1     : String;
    TheModele1    : String;
    //
    Idef          : Integer;
    //
    Cancel        : Boolean;
    //
    //
    //
    procedure AdditionQteInventaire(CodeArticle: String; QteArt : Double; NoLig : Integer);
    procedure AffichageGrilleAnomalie(TOBG : TOB);
    procedure AffichageGrilleInventaire;
    procedure AnalyseOnExit(Sender: Tobject);
    function  ArchivagefichierTPI: Boolean;
    //
    procedure BtEffaceOnclick(Sender: TObject);
    procedure BTGenerationOnClick(Sender: TObject);
    procedure BtImportOnClick(Sender : TObject);
    procedure BtSelectOnClick(Sender: TObject);
    procedure BtSelectCABOnClick(Sender: TObject);
    //
    procedure ChargeBL(TOBL: TOB; CodeBarre : String);
    procedure ChargeEtatRejete;
    procedure ChargeEtatValide;
    procedure ChargeGrilleToScreen(Arow: Integer; TOBL : TOB);
    procedure ChargeInfoAffaire(TOBL : TOB);
    procedure ChargeInfoArticle(TOBL : TOB);
    procedure ChargeInfoTiers(TOBL : TOB);
    procedure ChargeLigneCommentaire(TypeMvt : string;TOBLIGNE, TOBL: TOB);
    procedure ChargementLigneTOB(TOBL: TOB; StLig: String);
    procedure ChargeTOB;
    procedure ChargeTobAffaire(TOBL : TOB; CodeBarre: string);
    procedure ChargeTobArticle(TOBL : TOB; CodeBarre: string);
    procedure ChargeTOBDepot(TOBL: TOB; CodeDepot: string);
    procedure ChargeTOBGRILLEwithTOBAFFAIRE(Tobl, TOBAffaire: TOB);
    procedure ChargeTOBGRILLEwithTOBARTICLE(Tobl, TOBArticle: TOB);
    procedure ChargeTOBGRILLEwithTOBTIERS(Tobl, TOBTiers: TOB);
    procedure ChargeTobLigne(STypeMVT : string; TOBL, TOBLigne: TOB);
    procedure ChargeTobTiers(TOBL : TOB; CodeBarre: string);
    Procedure CodeBarreOnExit(Sender : Tobject);
    procedure CodeOnExit(Sender : TObject);
    procedure ControleChamp(Champ, Valeur: String);
    function  ControleFichierArchi : Boolean;
    procedure ControleFichierImport;
    function  ControleRepertoire(DefaultPath : String) : String;
    procedure CreateEnteteDoc(Nature : String; TOBL : Tob);
    procedure CreateLigne(TobLigne: TOB);
    procedure CreateTOB;
    procedure CreateTOBPiece;
    //
    procedure DateMVTOnExit(Sender: Tobject);
    procedure DefinieGrid;
    procedure DepotOnExit(Sender: TObject);
    procedure DestroyTOB;
    //
    procedure EditeRejete;
    procedure EditeValide;
    //
    Function  GenerationDeLaPiece(TOBL: TOB; TypeMvt: String) : Boolean;
    function  GenerationMsgAnomalie(TOBL: TOB): String;
    procedure GestionAnomalie;
    procedure GestionGrilleInventaire;
    procedure GestionModif(Question, Zone, NewCode, OldCode: string; IndLigne: Integer);
    function  GestionRejet(Tobl: TOB): Boolean;
    procedure GestionRuptureChantier(TOBL: TOB; AncienAff: String);
    procedure GestionRuptureDate(TOBL: TOB; AncienDateMvt: TDatetime);
    procedure GestionRuptureFournisseur(TOBL: TOB; AncienFrs: String);
    procedure GestionRuptureNumCde(TOBL: TOB; AncienNumero: String);
    procedure GestionRuptureTypeMvt(TOBL: TOB; AncienTypeMvt: String; var LigToDel: Integer);
    procedure GestionValide(Tobl: TOB);
    procedure GetCellCanvas(ACol, ARow: Integer; Canvas: TCanvas;AState: TGridDrawState);
    procedure GetObjects;
    procedure GrilleRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
    procedure Grille1RowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
    //
    procedure ImportElipsis(Sender: TObject);
    procedure InitZoneAffaire;
    Procedure InitZoneAffaireToTob(TOBL : TOB);
    procedure InitZoneArticle;
    Procedure InitZoneArticleToTob(TOBL : TOB);
    Procedure InitZoneEcran;
    procedure InitzoneFournisseur;
    procedure InitZoneFournisseurToTob(TOBL: TOB);
    procedure InitZoneTOB(TOBL: TOB);
    procedure InventaireDblClick(Sender: TObject);
    //
    function  MAJInventaire(TOBL : TOB) : Boolean;
    procedure MAJLigneInventaire(TOBResult, TOBL : TOB);
    procedure MajTobRejet(TOBL : TOB;TypeErr, Motif: String);
    procedure ModificationEnSerie(Zone, OldCode, Newcode: String; TOBL: TOB; IndLigne: Integer);
    procedure ModificationSimple(zone, Newcode: String; TOBL: TOB;IndLigne: Integer);
    //
    procedure NumeroOnExit(Sender: Tobject);
    //
    procedure OnChangeEtat(Sender: Tobject);
    procedure OnChangeEtat1(Sender: Tobject);
    procedure OnClickApercu(Sender: Tobject);
    procedure OnClickReduire(Sender: Tobject);
    //
    procedure ParamEtat(Sender: TOBJect);
    procedure ParamEtat1(Sender: TOBJect);
    //
    procedure QteOnExit(Sender: Tobject);
    //
    procedure RechercheAffaire;
    procedure RechercheArticle;
    procedure RechercheCABAffaire;
    procedure RechercheCABArticle;
    procedure RechercheCABFournisseur;
    procedure RechercheFournisseur;
    procedure RechercheInventaireArticle(TOBL : TOB);
    procedure RecupLignePiecePrecedente(TOBL, TobLigne: TOB);
    procedure ReinitialiseTobPiece;
    //
    procedure SetGrilleEvents(Etat: boolean);
    procedure SetScreenEvents;
    procedure SoustractionQteInv(CodeArticle: String; QteArt: Double; NoLig : Integer);

    procedure TraitementAnomalie;
    procedure TriTableGrille;
    procedure TypeMVTOnchange(Sender: TObject);
    procedure BTSelectNumCdeOnClick(Sender: TObject);


  end ;
  Type TGestionGS = Record
                  fColNamesGS     : string;
                  FalignementGS   : string;
                  FtitreGS        : string;
                  fLargeurGS      : string;
                  GS              : THGrid;
                  TOBG            : TOB;
                  End ;
  //

  //
  procedure ChargementGrille(GestionGS : TGestionGS);
  procedure DessineGrille(GestionGS : TGestionGS);
  //
  Var GestionGS : TGestionGS;
  //
  const
    SG_TYPEMVT      = 1;
    SG_DATEMVT      = 2;
    SG_DEPOT        = 3;
    SG_FOURNISSEUR  = 4;
    SG_AFFAIRE      = 5;
    SG_ARTICLE      = 6;
    SG_QTE          = 7;

Implementation
uses Paramsoc,
     Dialogs,
     AffaireUtil,
     FactUtil,
     GerePiece,
     FileCtrl,
     FactComm;

procedure TOF_INTEGREFICTPI.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_INTEGREFICTPI.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_INTEGREFICTPI.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_INTEGREFICTPI.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_INTEGREFICTPI.OnArgument (S : String ) ;
var i       : Integer;
    Critere : string;
    Champ   : string;
    Valeur  : string;
    ChoixRepertoire : string;
begin

  Inherited ;

  Cancel := false;

  Ecran.caption := 'Intégration fichier LSE';

  //Chargement des zones ecran dans des zones programme
  GetObjects;
  //
  CreateTOB;
  //
  Critere := S;
  //
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

  //Gestion des évènement des zones écran
  SetScreenEvents;

  //Gestion des évènement de Grille
  SetGrilleEvents(True);

  // définition de la grille
  DefinieGrid;

  GestionGS.fColNamesGS   := fColNamesGrille;
  GestionGS.FalignementGS := Falignement;
  GestionGS.FtitreGS      := Ftitre;
  GestionGS.fLargeurGS    := fLargeur;
  GestionGS.GS            := Grille;

  //dessin de la grille
  DessineGrille(GestionGS);

  if V_PGI.OkDecQ>0 then
  begin
    FF:='# ##0.';
    for i:=1 to V_PGI.OkDecQ-1 do
    begin
       FF:=FF+'0';
    end;
    FF:=FF+'0';
  end;

  PageGrille.ActivePage := PToutes;
  //
  PAnomalies.TabVisible   := False;
  //
  PGeneralite.TabVisible  := True;
  PInventaire.TabVisible  := False;

  //On se positionne sur le bon onglet
  Pages.ActivePage := PGeneralite;
  Pages.enabled := False;

  InitZoneEcran;

  FichierImport.Text := ControleRepertoire(GetParamSocSecur('SO_REPRECUPFIC', '', False));

  if FichierImport.text = '' then
  begin
    if PGIAsk('Importation impossible le répertoire de récupération n''existe pas. Voulez-vous en sélectionner un ?', 'Erreur Répertoire Stockage')=Mryes then
    begin
       If not SelectDirectory(ChoixRepertoire,[sdAllowCreate,sdPerformCreate,sdPrompt],0) then Exit else FichierImport.Text := ChoixRepertoire;
    end
    else Exit;
  end;

  FichierImport.Text := FichierImport.Text + '\lsecab.txt';

  ControleFichierImport;

  if FichierImport.Text = 'C:\' Then BtImport.Visible :=False;

  ChargeEtatRejete;

  ChargeEtatValide;

  OkAccepte := GetParamSocSecur('SO_BTINTERDIREACHATS', False);

end ;

Procedure TOF_INTEGREFICTPI.ControleFichierImport;
begin

  If not FileExists(FichierImport.text) then
  Begin
    PGIError('Aucun fichier à traiter...','Erreur Importation');
    FichierImport.Text := 'C:\';
  end;

end;

function TOF_INTEGREFICTPI.ControleFichierArchi : Boolean;
Var StDate    : String;
    StTime    : String;
    FileName  : String;
begin

  Result := False;

  StDate := DateToStr(NowH);
  StTime := TimeToStr(Nowh);
  //
  StDate := FindEtReplace(StDate,'/','',True);
  StTime := FindEtReplace(Sttime,':','',True);
  //
  FileName      := ExtractFileName(FichierImport.text);
  if FileName = '' then exit;
  FileName      := Copy(FileName,1, Length(FileName)-4);

  FichierHisto  := ControleRepertoire(GetParamSocSecur('SO_REPARCHFIC', '', False));
  FichierHisto  := FichierHisto + '\lsecab_' + StDate + '_' + StTime + '.Arc';

  if FileExists(FichierHisto) then
  begin
    if FichierHisto = '' then
    begin
      if PGIAsk('Archivage impossible le répertoire d''Archivage n''existe pas. Voulez-vous en sélectionner un ?', 'Erreur Répertoire Archivage')=Mryes then
      begin
        if not SelectDirectory(FichierHisto,[sdAllowCreate,sdPerformCreate,sdPrompt],0) then Exit;
      end
      else Exit;
    end;
    if ControleFichierArchi then Result := True;
  end
  else
    Result := True;

end;

Function TOF_INTEGREFICTPI.ControleRepertoire(DefaultPath : String) : String;
var ChoixRepertoire : string;
begin

  Result := defaultPath;

  if Result <> '' then
  begin
    if not DirectoryExists(Result) then Result := '';
  end
  else
  begin
    If SelectDirectory(ChoixRepertoire,[sdAllowCreate,sdPerformCreate,sdPrompt],0) Then Result := ChoixRepertoire;
  end;

end;

procedure TOF_INTEGREFICTPI.OnClose ;
begin
  Inherited ;

  DestroyTOB;

  FreeAndNil(OptionEdition);
  
end ;

procedure TOF_INTEGREFICTPI.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_INTEGREFICTPI.OnCancel () ;
begin
  Inherited ;
end ;

  //Chargement des zones ecran dans des zones programme
Procedure TOF_INTEGREFICTPI.GetObjects;
begin
  //
  Pages         := TPageControl(GetControl('PAGES'));
  PageGrille    := TPageControl(GetControl('PAGEGRILLE'));
  //
  Ptoutes       := TTabSheet(GetControl('PTOUTES'));
  PAnomalies    := TTabSheet(GetControl('PANOMALIES'));
  //
  PGeneralite   := TTabSheet(GetControl('GENERALITES'));
  PAffaire      := TTabSheet(GetControl('AFFAIRE'));
  PFournisseur  := TTabSheet(GetControl('FOURNISSEUR'));
  PArticle      := TTabSheet(GetControl('ARTICLE'));
  PEdition      := TTabSheet(GetControl('EDITION'));
  PInventaire   := TTabSheet(GetControl('INVENTAIRE'));
  //
  FichierImport := THEdit(GetControl('FICHIERIMPORT'));
  //
  TypeMVT       := THValcombobox(GetControl('TYPEMVT'));
  DateMvt       := THEdit(GetControl('DATEMVT'));
  Analyse       := THEdit(GetControl('ANALYSE'));
  Depot         := THEdit(GetControl('DEPOT'));
  //
  //chargement de la grille
  Grille        := THGrid(GetControl('GRILLE'));
  Grille1       := THGrid(GetControl('GRILLE1'));
  Grille2       := THGrid(GetControl('GRILLE2'));
  //
  //chargement des zones écran liées à l'affaire
  Client        := THEdit(GetControl('TIERS'));
  //
  Affaire       := THEdit(GetControl('AFF_AFFAIRE'));
  Affaire0      := THEdit(GetControl('AFFAIRE0'));
  Affaire1      := THEdit(GetControl('AFF_AFFAIRE1'));
  Affaire2      := THEdit(GetControl('AFF_AFFAIRE2'));
  Affaire3      := THEdit(GetControl('AFF_AFFAIRE3'));
  Avenant       := THEdit(GetControl('AFF_AVENANT'));
  //
  CAB_Affaire   := THEdit(GetControl('AFF_CODEBARRE'));
  //
  Lib_Depot       := THLabel(GetControl('LIBDEPOT'));
  Lib_Affaire     := THLabel(GetControl('LIBAFFAIRE'));
  Lib_Tiers       := THLabel(GetControl('LIBTIERS'));
  LIB_TenueStock  := THLabel(Getcontrol('LIBTENUESTOCK'));
  Lib_Responsable := THLabel(GetControl('LIB_RESPONSABLE'));
  Lib_Domaine     := THLabel(GetControl('LIB_DOMAINE'));
  CaptionErreur   := THLabel(GetControl('LIBERREUR'));
  //
  Aff_Ferme       := TCheckBox(GetControl('AFF_FERME'));
  //
  //chargement des zones écran liées au fournisseur
  //
  CodeTiers       := THEdit(GetControl('T_TIERS'));
  CAB_Tiers       := THEdit(GetControl('T_CODEBARRE'));;
  Juridique       := THLabel(GetControl('JURIDIQUE'));
  Nom             := THLabel(GetControl('T_NOM'));
  ADR1            := THLabel(GetControl('ADR1'));
  ADR2            := THLabel(GetControl('ADR2'));
  ADR3            := THLabel(GetControl('ADR3'));
  ADR4            := THLabel(GetControl('ADR4'));
  CP              := THLabel(GetControl('CP'));
  Ville           := THLabel(GetControl('VILLE'));
  Frs_Ferme       := TCheckBox(GetControl('T_FERME'));
  NumCde          := THEdit(GetControl('NUMCDE'));
  NumBL           := THEdit(GetControl('NUMBL'));
  TNumCde         := THLabel(GetControl('TNUMCDE'));
  TNumBL          := THLabel(GetControl('TNUMBL'));
  //
  //chargement des zones écran liées à l'article
  //
  CodeArticle     := THEdit(GetControl('GA_CODEARTICLE'));
  Article         := THEdit(GetControl('GA_ARTICLE'));
  Qte             := THNumEdit(GetControl('QTE'));
  CoefUSUV        := THEdit(GetControl('GA_COEFCONVQTEVTE'));
  CoefUAUS        := THEdit(GetControl('GA_COEFCONVQTEACH'));
  PAHT            := THEdit(GetControl('GA_PAHT'));
  PAUA            := THEdit(GetControl('GA_PAUA'));
  DPA             := THEdit(GetControl('GA_DPA'));
  PMAP            := THEdit(GetControl('GA_PMAP'));
  CAB_Article     := THEdit(GetControl('GA_CODEBARRE'));
  Lib_Article     := THLabel(GetControl('LIBARTICLE'));
  //
  Art_Ferme       := TCheckBox(Getcontrol('GA_FERME'));
  Art_TenueStock  := TcheckBox(GetControl('GA_TENUESTOCK'));
  //
  Art_QualifCAB   := THValComboBox(GetControl('GA_QUALIFCODEBARRE'));
  Frs_QualifCAB   := THValComboBox(GetControl('T_QUALIFCODEBARRE'));
  Aff_QualifCAB   := THValComboBox(GetControl('AFF_QUALIFCODEBARRE'));
  QualifUS        := THValComboBox(GetControl('GA_QUALIFUNITESTO'));
  QualifUA        := THValComboBox(GetControl('GA_QUALIFUNITEACH'));
  QualifUV        := THValComboBox(GetControl('GA_QUALIFUNITEVTE'));
  //
  BtImport        := TToolBarButton97(Getcontrol('BTIMPORT'));
  //
  BtSelect1       := TToolBarButton97(Getcontrol('BSelect1'));
  BtSelect2       := TToolBarButton97(Getcontrol('BSelect2'));
  BtSelect3       := TToolBarButton97(Getcontrol('BSelect3'));
  //
  BtEfface1       := TToolBarButton97(Getcontrol('BEfface1'));
  BtEfface2       := TToolBarButton97(Getcontrol('BEfface2'));
  BtEfface3       := TToolBarButton97(Getcontrol('BEfface3'));
  //
  BtSelectCAB1    := TToolBarButton97(Getcontrol('BSelectCAB1'));
  BtSelectCAB2    := TToolBarButton97(Getcontrol('BSelectCAB2'));
  BtSelectCAB3    := TToolBarButton97(Getcontrol('BSelectCAB3'));
  //
  BtSelectNUMCDE  := TToolBarButton97(Getcontrol('BSelectNUMCDE'));
  BtSelectNUMBL   := TToolBarButton97(Getcontrol('BSelectNUMBL'));
  //
  BGeneration     := TToolbarButton97(GetControl('BTGENERATION'));
  //
  BParamEtat      := TToolbarButton97(GetCONTROL('BPARAMETAT'));
  TEtat           := ThLabel(ecran.FindComponent('TEtat'));
  FEtat           := ThValComboBox(ecran.FindComponent('FEtat'));
  //
  BParamEtat1     := TToolbarButton97(GetCONTROL('BPARAMETAT1'));
  TEtat1          := ThLabel(ecran.FindComponent('TEtat1'));
  FEtat1          := ThValComboBox(ecran.FindComponent('FEtat1'));
  //
  ChkApercu       := TCheckBox(Ecran.FindComponent('fApercu'));
  ChkReduire      := TCheckBox(Ecran.FindComponent('fReduire'));
  ChkCouleur      := TCheckBox(Ecran.FindComponent('fCouleur'));
  //
end;
  //
Procedure TOF_INTEGREFICTPI.CreateTOB;
begin

  TobGrille     := Tob.create('LA GRILLE', nil, -1);
  TobAnomalie   := Tob.Create('ANOMALIES', nil, -1);
  TobInventaire := Tob.Create('INVENTAIRES', nil, -1);

  TOBRejete     := TOB.Create('REJETE', nil, -1);
  TOBValide     := TOB.Create('VALIDE', nil, -1);

  TOBPiece      := TOB.Create('LA PIECE', nil,  -1);

end;

procedure TOF_INTEGREFICTPI.InitZoneTOB(TOBL : TOB);
begin

  //zone nécessaire à la grille
  TOBL.AddChampSupValeur('NOLIG', '');
  TOBL.AddChampSupValeur('TYPEMVT', '');
  TOBL.AddChampSupValeur('DATEMVT', iDate1900);
  TOBL.AddChampSupValeur('DEPOT', '');
  TOBL.AddChampSupValeur('LIB_DEPOT', '');
  TOBL.AddChampSupValeur('CODEAFFAIRE', '');
  TOBL.AddChampSupValeur('CODEFOURNISSEUR', '');
  TOBL.AddChampSupValeur('CODEARTICLE', '');
  TOBL.AddChampSupValeur('QTE', '0.00');
  //
  TOBL.AddChampSupValeur('ANALYSE', '');
  //
  TOBL.AddChampSupValeur('ANOMALIE',    '');
  TOBL.AddChampSupValeur('ANOMALIEAFF', '');
  TOBL.AddChampSupValeur('LIBANOMALIEAFF', '');
  TOBL.AddChampSupValeur('ANOMALIEFRS', '');
  TOBL.AddChampSupValeur('LIBANOMALIEFRS', '');
  TOBL.AddChampSupValeur('ANOMALIEMAR', '');
  TOBL.AddChampSupValeur('LIBANOMALIEMAR', '');
  TOBL.AddChampSupValeur('ANOMALIECLI', '');
  TOBL.AddChampSupValeur('LIBANOMALIECLI', '');
  //
  TOBL.AddChampSupValeur('TYPEERREUR', '');

  //Zone nécessaire à l'affaire
  TOBL.AddChampSupValeur('CLIENT', '');
  TOBL.AddChampSupValeur('LIB_CLIENT', '...');

  TOBL.AddChampSupValeur('AFF_AFFAIRE', '');
  TOBL.AddChampSupValeur('LIB_AFFAIRE', '');
  //
  TOBL.AddChampSupValeur('CAB_Affaire',   '');
  TOBL.AddChampSupValeur('AFF_QUALIFCAB', '');
  //
  TOBL.AddChampSupValeur('Lib_Responsable', '...');
  TOBL.AddChampSupValeur('Domaine',        '');
  TOBL.AddChampSupValeur('Etablissement',  '');
  TOBL.AddChampSupValeur('Lib_Domaine', '...');
  //
  //zone nécessaire au fournisseur
  TOBL.AddChampSupValeur('T_TIERS',        '');
  TOBL.AddChampSupValeur('CAB_Tiers',      '');
  TOBL.AddChampSupValeur('Frs_QualifCAB',  '');
  TOBL.AddChampSupValeur('Juridique',   '...');
  TOBL.AddChampSupValeur('Nom',         '...');
  TOBL.AddChampSupValeur('ADR1',        '...');
  TOBL.AddChampSupValeur('ADR2',        '...');
  TOBL.AddChampSupValeur('ADR3',        '...');
  TOBL.AddChampSupValeur('ADR4',        '...');
  TOBL.AddChampSupValeur('CP',          '...');
  TOBL.AddChampSupValeur('Ville',       '...');

  //Zone nécessaire à l'article
  TOBL.AddChampSupValeur('GA_ARTICLE',     '');
  TOBL.AddChampSupValeur('Lib_Article', '...');
  //
  TOBL.AddChampSupValeur('CAB_Article',    '');
  TOBL.AddChampSupValeur('Art_QualifCAB',  '');
  //
  TOBL.AddChampSupValeur('QUALIFUNITESTO',  '');
  TOBL.AddChampSupValeur('QUALIFUNITEACH',  '');
  TOBL.AddChampSupValeur('QUALIFUNITEVTE',  '');
  //
  TOBL.AddChampSupValeur('CoefUSUV',       '');
  TOBL.AddChampSupValeur('CoefUAUS',       '');
  TOBL.AddChampSupValeur('PAHT',       '0.00');
  TOBL.AddChampSupValeur('PAUA',       '0.00');
  TOBL.AddChampSupValeur('DPA',        '0.00');
  TOBL.AddChampSupValeur('PMAP',       '0.00');

  TOBL.AddChampSupValeur('TENUESTOCK',    '-');
  TOBL.AddChampSupValeur('ART_FERME',     '-');
  TOBL.AddChampSupValeur('AFF_FERME',     '-');
  TOBL.AddChampSupValeur('FRS_FERME',     '-');

  TOBL.AddChampSupValeur('NUMBL',         '0');
  TOBL.AddChampSupValeur('NUMCDE',        '0');
  TOBL.AddChampSupValeur('REFINTERNE',    ' ');
  TOBL.AddChampSupValeur('NATPIECEPREC',  ' ');

end;

Procedure TOF_INTEGREFICTPI.Controlechamp(Champ, Valeur : String);
begin

end;

procedure TOF_INTEGREFICTPI.SetScreenEvents;
begin

  FichierImport.OnElipsisClick := ImportElipsis;

  TypeMVT.OnChange      := TypeMVTOnchange;
  DateMvt.OnExit        := DateMVTOnExit;
  Analyse.OnExit        := AnalyseOnExit;
  Depot.OnExit          := DepotOnExit;
  Qte.OnExit            := QteOnExit;
  //
  Affaire1.Onexit       := CodeOnExit;
  Affaire2.OnExit       := CodeOnExit;
  Affaire3.OnExit       := CodeOnExit;
  CodeTiers.Onexit      := CodeOnExit;
  CodeArticle.Onexit    := CodeOnExit;
  //
  //NumBL.OnExit          := NumeroOnExit;
  NumCde.OnExit         := NumeroOnExit;
  //
  CAB_Affaire.Onexit    := codeBarreOnExit;
  CAB_Tiers.OnExit      := codeBarreOnExit;
  CAB_Article.OnExit    := codeBarreOnExit;

  BtImport.OnClick      := BtImportOnClick;

  BtSelect1.OnClick     := BtSelectOnClick;
  BtEfface1.OnClick     := BtEffaceOnclick;
  BtSelectCAB1.OnClick  := BtSelectCABOnClick;
  //
  BtSelect2.OnClick     := BtSelectOnClick;
  BtEfface2.OnClick     := BtEffaceOnclick;
  BtSelectCAB2.OnClick  := BtSelectCABOnClick;
  //
  BtSelect3.OnClick     := BtSelectOnClick;
  BtEfface3.OnClick     := BtEffaceOnclick;
  BtSelectCAB3.OnClick  := BtSelectCABOnClick;
  //
  BtSelectNUMCDE.OnClick:= BTSelectNumCdeOnClick;
  //
  BGeneration.OnClick   := BTGenerationOnClick;
  //
  BParamEtat.OnClick    := ParamEtat;
  BParamEtat1.OnClick   := ParamEtat1;

  //
  if assigned(ChkApercu)    then ChkApercu.OnClick    := OnClickApercu;
  if assigned(ChkReduire)   then ChkReduire.OnClick   := OnClickReduire;

  if assigned(FETAT)        then FETAT.OnChange       := OnChangeEtat;
  if assigned(FETAT1)       then FETAT1.OnChange      := OnChangeEtat1;

end;

procedure TOF_INTEGREFICTPI.SetGrilleEvents (Etat : boolean);
begin

  if Etat then
  begin
    Grille.OnRowEnter   := GrilleRowEnter;
    Grille.GetCellCanvas:= GetCellCanvas;
    Grille1.OnRowEnter  := Grille1RowEnter;
    Grille2.OnDblClick  := InventaireDblClick;

  end
  else
  begin
    Grille.OnRowEnter   := Nil;
    Grille.GetCellCanvas:= nil;
    Grille1.OnRowEnter  := Nil;
    Grille2.OnDblClick  := Nil;
  end;

end;

procedure TOF_INTEGREFICTPI.DestroyTOB;
begin

  FreeAndNil(TOBGrille);
  FreeAndNil(TobAnomalie);
  FreeAndNil(TobInventaire);

  FreeAndNil(TOBPIECE);

  FreeAndNil(Tobrejete);
  FreeandNil(TobValide);

end;

procedure TOF_INTEGREFICTPI.DefinieGrid;
begin

  // Définition de la liste de saisie pour la grille Détail
  fColNamesGrille   := 'SEL;TYPEMVT;DATEMVT;DEPOT;CODEFOURNISSEUR;CODEAFFAIRE;CODEARTICLE;QTE';
  Falignement       := 'C.0  ---;G.0  ---;C.0  ---;G.0  ---;G.0  ---;G.0  ---;G.0  ---;D/2  -X-';
  Ftitre            := ' ;Type Mvt;Date Mvt;Dépot;Fournisseur;Chantier;Article;Qté';
  fLargeur          := '2;30;15;15;15;30;30;30;5';
  //
  // Définition de la liste de saisie pour la grille anomalie
  fColNamesGrille1  := 'SEL;TYPEERREUR;DEPOT;CODEFOURNISSEUR;CODEAFFAIRE;CODEARTICLE;QTE';
  FalignementGrille1:= 'C.0  ---;G.0  ---;G.0  ---;G.0  ---;G.0  ---;G.0  ---;D/2  -X-';
  FtitreGrille1     := ' ;Type Erreur;Dépot;Fournisseur;Chantier;Article;Qté';
  fLargeurGrille1   := '2;40;15;15;30;30;30;5';
  //
  // Définition de la liste de saisie pour la grille Inventaire
  fColNamesGrille2  := 'SEL;GIE_CODELISTE;GIE_LIBELLE;GIE_DEPOT;GIE_DATEINVENTAIRE;GIE_TYPEINVENTAIRE';
  FalignementGrille2:= 'C.0  ---;C.0  ---;G.0  ---;G.0  ---;G.0  ---;C.0  ---';
  FtitreGrille2     := ' ;Code Inv;Désignation;Dépot;Date Inv.;Type Inv.';
  fLargeurGrille2   := '2;15;30;15;15;10';

end;


procedure TOF_INTEGREFICTPI.ImportElipsis(Sender : TObject);
var TT  : TOpenDialog;
    rep : string;
begin

  Rep := FichierImport.text;

  //ouverture du sélecteur de fichier windows dans le répertoire des modèles...
	TT := TOpenDialog.Create(Ecran);
  TRY
    TT.DefaultExt := '.txt';
    TT.Filter := 'Modèle Texte (*.txt)|*.txt';
    if (rep = '') or (rep = 'C:\') then Rep := GetParamSocSecur('SO_REPRECUPFIC', '', False);
    //Rep := ExtractFilePath(rep);
    TT.InitialDir := rep;
    if TT.Execute then
    begin
      FichierImport.text := TT.FileName;
    end;
  FINALLY
  	TT.Free;
  end;

  if FichierImport.Text <> '' Then BtImport.Visible := True;

end;

procedure TOF_INTEGREFICTPI.BtImportOnClick(Sender: TObject);
begin

  //Chargement de la Tob en fonction des élément préchargés.
  ChargeTOB;

  //chargement de la grille avec les éléments de la TOB
  GestionGS.TOBG  := TOBGrille;
  GestionGS.GS    := Grille;
  //
  ChargementGrille(GestionGS);

  //Vérification si des lignes ont été rejetées
  TraitementAnomalie;

  //On se positionne sur le bon onglet
  Pages.ActivePage := PGeneralite;

  //Chargement de la première ligne
  if TOBGrille.detail.count <> 0 then
  begin
    //on Se positionne sur la première ligne de la grille
    Grille.row := 1;
    GrilleRowEnter(self, Grille.Row, Cancel, true);
    Pages.enabled := True;
  end;

  //Création de la TOBPiece pour génération ultérieure des Documents
  CreateTOBPiece;

  FichierImport.Enabled := False;
  BtImport.Visible      := False;

end;

Procedure TOF_INTEGREFICTPI.TraitementAnomalie();
Var TOBL  : TOB;
    ind   : Integer;
begin

  //
  For ind := 0 To TobGrille.Detail.count -1 do
  begin
    //chargepment de la tob anomalie avec les lignes taggées
    If (TOBGrille.Detail[ind].GetValue('ANOMALIEAFF')='X') OR
       (TOBGrille.Detail[ind].GetValue('ANOMALIECLI')='X') OR
       (TOBGrille.Detail[ind].GetValue('ANOMALIEFRS')='X') OR
       (TOBGrille.Detail[ind].GetValue('ANOMALIEMAR')='X') or
       (TOBGrille.Detail[ind].GetValue('ANOMALIEMAR')='S') or
       (TOBGrille.Detail[ind].GetValue('ANOMALIEMAR')='F') or
       (TOBGrille.Detail[Ind].GetValue('ANOMALIE')= 'DEPOT')   then
    begin
      //Affichage de l'onglet anomalie
      if PAnomalies.TabVisible=False then PAnomalies.TabVisible := True;
      TOBL := TOB.Create('Ligne Anomalie', TOBAnomalie,-1);
      TOBL.Dupliquer(TobGrille.Detail[Ind], True, true);
    end;
  end;

  AffichageGrilleAnomalie(TOBAnomalie);

end;

procedure TOF_INTEGREFICTPI.AffichageGrilleAnomalie(TOBG : Tob);
var GestionG1: TGestionGS;
begin

  if TOBG.Detail.count <> 0 then
  begin
    //suppression de l'onglet anomalie
    PAnomalies.TabVisible   := True;
    //chargement de la grille avec les éléments de la TOB
    GestionG1.fColNamesGS   := fColNamesGrille1;
    GestionG1.FalignementGS := FalignementGrille1;
    GestionG1.FtitreGS      := FtitreGrille1;
    GestionG1.fLargeurGS    := fLargeurGrille1;
    GestionG1.TOBG          := TOBG;
    GestionG1.GS            := Grille1;
    //
    DessineGrille(GestionG1);
    //
    ChargementGrille(GestionG1);
    //
    Grille1.row := 1;
  end
  else
  begin
    //suppression de l'onglet anomalie
    PAnomalies.TabVisible := False;
    TOBG.ClearDetail;
  end;

end;

procedure TOF_INTEGREFICTPI.BtSelectOnClick(Sender: TObject);
begin

  if Pages.ActivePage = PAffaire          then
  begin
    RechercheAffaire;
    Grille.Cells [SG_AFFAIRE,Grille.Row] := TOBGrille.Detail[Grille.row-1].GetString('CODEAFFAIRE');
  end
  else if Pages.ActivePage = PFournisseur then
  begin
    RechercheFournisseur;
    Grille.Cells [SG_FOURNISSEUR,Grille.Row] := TOBGrille.Detail[Grille.row-1].GetString('CODEFOURNISSEUR');
  end
  else if Pages.ActivePage = PArticle     then
  Begin
    RechercheArticle;
    Grille.Cells [SG_ARTICLE,Grille.Row] := TOBGrille.Detail[Grille.row-1].GetString('CODEARTICLE');
  end;

end;

procedure TOF_INTEGREFICTPI.BtEffaceOnclick(Sender: TObject);
begin

  if Pages.ActivePage = PAffaire          then
  begin
    InitZoneAffaire;
    InitZoneAffaireToTob(TOBGrille.Detail[Grille.Row-1]);
    //Remise à blanc de la zone dans la TOBGrille
    if TOBGRille.Detail.count <> 0 then
    begin
      Grille.Cells[SG_AFFAIRE,Grille.Row] := '';
      If TOBGRille.Detail[Grille.Row-1].GetString('TYPEMVT') <> 'BT' then
        Affaire0.Text := 'A'
      else
        Affaire0.Text := 'W';
    end;
    Affaire1.SetFocus;
  end
  else if Pages.ActivePage = PFournisseur then
  begin
    InitzoneFournisseur;
    InitZoneFournisseurToTob(TOBGrille.Detail[Grille.Row-1]);
    //Remise à blanc de la zone dans la TOBGrille
    if TOBGRille.Detail.count <> 0 then
    begin
      Grille.Cells[SG_FOURNISSEUR,Grille.Row] := '';
    end;
    CodeTiers.SetFocus;
  end
  else if Pages.ActivePage = PArticle     then
  Begin
    SoustractionQteInv(CodeArticle.Text, StrToFloat(Qte.Text),TOBGRille.Detail[Grille.Row-1].GetValue('NOLIG'));
    InitZoneArticle;
    InitZoneArticleToTob(TOBGrille.Detail[Grille.Row-1]);
    //Remise à blanc de la zone dans la TOBGrille
    if TOBGRille.Detail.count <> 0 then
    begin
      Grille.Cells[SG_ARTICLE,Grille.Row] := '';
    end;
    CodeArticle.SetFocus;
  end;

end;

procedure TOF_INTEGREFICTPI.BtSelectCABOnClick(Sender: TObject);
begin

  if Pages.ActivePage = PAffaire          then
  Begin
    RechercheCABAffaire;
    Grille.Cells[SG_AFFAIRE,Grille.Row] := TOBGrille.Detail[Grille.Row-1].GetString('CODEAFFAIRE');
  end
  else if Pages.ActivePage = PFournisseur then
  begin
    RechercheCABFournisseur;
    Grille.Cells[SG_FOURNISSEUR,Grille.Row] := TOBGrille.Detail[Grille.Row-1].GetString('CODEFOURNISSEUR');
  end
  else if Pages.ActivePage = PArticle     then
  begin
    RechercheCABArticle;
    Grille.Cells[SG_ARTICLE,Grille.Row] := TOBGrille.Detail[Grille.Row-1].GetString('CODEARTICLE');
  end;

end;

Procedure TOF_INTEGREFICTPI.BTSelectNumCdeOnClick(Sender : TObject);
begin

end;

procedure TOf_INTEGREFICTPI.TypeMVTOnchange(Sender: TObject);
Var TOBL      : TOB;
    CodeBarre : string;
begin

  if TypeMVT.Value= '' then exit;

  TOBL := TobGrille.Detail[Grille.row-1];

  if TypeMvt.Value=TOBL.GetString('TYPEMVT') then exit;

  //ON MODIFIE LA LIGNE DE LA GRILLE AVEC LA NOUVELLE VALEUR DU TYPE mvt !!!
  TOBL.PutValue('TYPEMVT', TypeMVT.Value);

  Grille.Cells [SG_TYPEMVT,Grille.Row] := RechDom('BTTYPEMVT',TOBL.GetString('TYPEMVT'),False);

  //on réinitialise toutes les valeur d'anomalie à part le dépôt
  TOBL.PutValue('ANOMALIEAFF', '');
  TOBL.PutValue('ANOMALIEFRS', '');
  TOBL.PutValue('ANOMALIECLI', '');
  TOBL.PutValue('ANOMALIEMAR', '');

  //On charge l'onglet Affaire en fonction du type de Mouvement
  if (TypeMVT.Value = 'SA') OR (TypeMVT.Value = 'EA') then
  begin
    CodeBarre     := TOBL.GetString('CodeAFFAIRE');
    ChargeTobAffaire(TOBL, CodeBarre);
  end;

  //On charge l'onglet Fournisseur en fonction du type de Mouvement
  if (TypeMVT.Value = 'CD') then
  begin
    CodeBarre     := TOBL.GetString('CodeAFFAIRE');
    ChargeTobAffaire(TOBL, CodeBarre);
    CodeBarre     := TOBL.GetString('CodeFOURNISSEUR');
    ChargeTOBTiers(TOBL, CodeBarre);
  end;

  if TypeMVT.Value = 'BL' then
  begin
    CodeBarre     := TOBL.GetString('NUMCDE');  
    ChargeBL(TOBL, CodeBarre);
  end;

  GestionAnomalie;

  AffichageGrilleAnomalie(TobAnomalie);

  //if Grille.row < Grille.RowCount-1 then
  //  Grille.row := Grille.row + 1
  //else
  //  Grille.row := 1;

  //GrilleRowEnter(self, Grille.Row, Cancel, true);

End;

procedure  TOF_INTEGREFICTPI.DateMVTOnExit(Sender : Tobject);
Var Indice  : Integer;
begin

  if DateMvt.Text <> TobGrille.detail[Grille.row-1].GetString('DATEMVT') then
  begin
    if PgiAsk('Voulez-vous appliquer cette modification à l''ensemble des lignes ?','Modification Date')=MrYes then
    begin
      For Indice := 0 to TOBGrille.detail.count -1 do
      begin
        TobGrille.Detail[Indice].PutValue('DATEMVT', DateMVT.Text);
        Grille.Cells [SG_DATEMVT,Indice+1] := TOBGrille.Detail[Indice].GetString('DATEMVT');
      end;
    end
    else
    begin
      TobGrille.Detail[Grille.row-1].PutValue('DATEMVT', DateMVT.Text);
      Grille.Cells [SG_DATEMVT,Grille.Row] := TOBGrille.Detail[Grille.row-1].GetString('DATEMVT');
    end;
  end;

  //if Grille.row < Grille.RowCount-1 then
  //  Grille.row := Grille.row + 1
  //else
  //  Grille.row := 1;

  //GrilleRowEnter(self, Grille.Row, Cancel, true);

end;

procedure  TOF_INTEGREFICTPI.AnalyseOnExit(Sender : Tobject);
Var Indice : Integer;
begin

  if Analyse.Text ='' then exit;

  IF Analyse.Text <> TobGrille.detail[Grille.row-1].GetString('ANALYSE') then
  begin
    if PgiAsk('Voulez-vous appliquer cette modification à l''ensemble des lignes ?','Modification Date')=MrYes then
    begin
      For Indice := 0 to TOBGrille.detail.count -1 do
      begin
        TobGrille.Detail[Indice].PutValue('ANALYSE', Analyse.Text);
      end;
    end
    else
    begin
      TobGrille.Detail[Grille.row-1].PutValue('ANALYSE', Analyse.Text);
    end;
  end;

  //if Grille.row < Grille.RowCount-1 then
  //  Grille.row := Grille.row + 1
  //else
  //  Grille.row := 1;

  //GrilleRowEnter(self, Grille.Row, Cancel, true);

end;

procedure TOf_INTEGREFICTPI.DepotOnExit(Sender: TObject);
Var Indice : Integer;
begin

  if Depot.text='' then exit;

  ChargeTobDepot(TobGrille.Detail[Grille.row-1], Depot.text);

  IF Depot.Text <> TobGrille.detail[Grille.row-1].GetString('DEPOT') then
  begin
    if PgiAsk('Voulez-vous appliquer cette modification à l''ensemble des lignes ?','Modification Date')=MrYes then
    begin
      For Indice := 0 to TOBGrille.detail.count -1 do
      begin
        Grille.Row := Indice+1;
        TobGrille.Detail[Indice].PutValue('DEPOT', Depot.Text);
        Grille.Cells [SG_DEPOT,Indice+1] := TOBGrille.Detail[Indice].GetString('DEPOT');
        TobGrille.Detail[Indice].PutValue('ANOMALIE','');
        GestionAnomalie;
      end;
    end
    else
    begin
      TobGrille.Detail[Grille.row-1].PutValue('DEPOT', Depot.Text);
      Grille.Cells [SG_DEPOT,Grille.Row] := TOBGrille.Detail[Grille.row-1].GetString('DEPOT');
      GestionAnomalie;
    end;
  end;

  AffichageGrilleAnomalie(TobAnomalie);

  //if Grille.row < Grille.RowCount-1 then
  //   Grille.row := Grille.row + 1
  //else
  //  Grille.row := 1;

  //????  c'est là que ça merde !!!!!!!!!
  //GrilleRowEnter(self, Grille.Row, Cancel, true);

end;

procedure TOf_INTEGREFICTPI.QteOnExit(Sender: TObject);
Var QteArt      : Double;
begin

  QteArt := TobGrille.Detail[Grille.row-1].GetDouble('QTE');

  SoustractionQteInv(CodeArticle.text, QteArt,TobGrille.Detail[Grille.row-1].GetValue('NOLIG'));

  //ON MODIFIE LA LIGNE DE LA GRILLE AVEC LA NOUVELLE VALEUR !!
  TobGrille.Detail[Grille.row-1].PutValue('QTE', Qte.text);
  Grille.Cells [SG_QTE,Grille.Row] := TOBGrille.Detail[Grille.row-1].GetString('QTE');

  AdditionQteInventaire(CodeArticle.text, StrToFloat(Qte.Text), TobGrille.Detail[Grille.row-1].GetValue('NOLIG'));

  //if Grille.row < Grille.RowCount-1 then
  //  Grille.row := Grille.row + 1
  //else
  //  Grille.row := 1;

  //GrilleRowEnter(self, Grille.Row, Cancel, true);

end;

Procedure TOF_INTEGREFICTPI.NumeroOnExit(Sender : Tobject);
var TOBL      : TOB;
    OldNumCde : string;
    OldNumBL  : string;
    Question  : String;
    ARow      : Integer;
begin

  if TOBGrille = nil then exit;
  
  ARow := Grille.Row;

  if ((ARow <= 0) or (ARow > TOBGrille.Detail.Count)) then Exit;

  TOBL := TOBGrille.Detail[ARow - 1];

  if TOBL = nil then Exit;

  OldNumCde := TOBL.GetString('NUMCDE');
  OldNumBL  := TOBL.GetString('NUMBL');

  Question := 'Voulez-vous appliquer cette modification à l''ensemble des lignes affectées à cette Réception';

  GestionModif(Question,'NUMERO',NumCde.Text,OldNumCde,0);

  TOBL.PutValue('NUMCDE', NumCde.Text);

end;

Procedure TOF_INTEGREFICTPI.CodeOnExit(Sender : Tobject);
Var IP      : Integer;
    TOBL    : Tob;
    OldCode : String;
    Question: String;
    ARow    : Integer;
begin

  ARow := Grille.Row;

  if ((ARow <= 0) or (ARow > TOBGrille.Detail.Count)) then Exit;

  TOBL := TOBGrille.Detail[ARow - 1];

  if TOBL = nil then Exit;

  if Pages.ActivePage = PAffaire          then
  begin
    OldCode       := TOBL.GetString('CODEAFFAIRE');
    Affaire.text  := DechargeCleAffaire(Affaire0, Affaire1, Affaire2, Affaire3, Avenant, Client.text, Taconsult, False, True, false, IP);
    ChargeTobAffaire(TOBL, Affaire.text);
    Question := 'Voulez-vous appliquer cette modification à l''ensemble des lignes affectées à cet Article?';
    GestionModif(Question,'CODEAFFAIRE',Affaire.Text,OldCode,SG_AFFAIRE);
  end
  else if Pages.ActivePage = PFournisseur then
  begin
    OldCode := TOBL.GetString('CODEFOURNISSEUR');
    ChargeTobTiers(TOBL, Codetiers.text);
    Question := 'Voulez-vous appliquer cette modification à l''ensemble des lignes affectées à cet Article?';
    GestionModif(Question,'CODEFOURNISSEUR',Codetiers.Text,OldCode,SG_FOURNISSEUR);
  end
  else if Pages.ActivePage = PArticle     then
  begin
    OldCode := TOBL.GetString('CODEARTICLE');
    ChargeTobArticle(TOBL, CodeArticle.text);
    Question := 'Voulez-vous appliquer cette modification à l''ensemble des lignes affectées à cet Article?';
    GestionModif(Question,'CODEARTICLE',CodeArticle.Text,OldCode,SG_ARTICLE);
  end;

end;

Procedure TOF_INTEGREFICTPI.CodeBarreOnExit(Sender : TObject);
Var IP      : Integer;
    TOBL    : Tob;
    OldCode : String;
    Question: String;
begin

  TOBL := TobGrille.Detail[Grille.row-1];

  if Pages.ActivePage = PAffaire          then
  begin
    OldCode       := TOBL.GetString('CODEAFFAIRE');
    Affaire.text  := DechargeCleAffaire(Affaire0, Affaire1, Affaire2, Affaire3, Avenant, Client.text, Taconsult, False, True, false, IP);
    ChargeTobAffaire(TOBL, Affaire.text);
    Question := 'Voulez-vous appliquer cette modification à l''ensemble des lignes affectées à cet Article?';
    GestionModif(Question,'CODEAFFAIRE',Affaire.Text,OldCode,SG_AFFAIRE);
  end
    //GestionAffaire(CAB_Affaire.text,TOBL.GetString('CAB_AFFAIRE'), TOBL)
  else if Pages.ActivePage = PFournisseur then
  begin
    OldCode := TOBL.GetString('CODEFOURNISSEUR');
    if TOBL.GetValue('TYPEMVT') = 'BL' then
    begin
      if OldCode <> CodeTiers.text then
      begin
        PGIBox('Modification impossible ce fournisseur appartient à une réception', 'Modification Impossible');
        Codetiers.text := OldCode;
      end;
    end
    else
    begin
      ChargeTobTiers(TOBL, Codetiers.text);
      Question := 'Voulez-vous appliquer cette modification à l''ensemble des lignes affectées à cet Article?';
      GestionModif(Question,'CODEFOURNISSEUR',Codetiers.Text,OldCode,SG_FOURNISSEUR);
    end;
  end
    //GestionFournisseur(CAB_Tiers.text,TOBL.GetString('CAB_Tiers'), TOBL)
  else if Pages.ActivePage = PArticle     then
  begin
    OldCode := TOBL.GetString('CODEARTICLE');
    ChargeTobArticle(TOBL, CodeArticle.text);
    Question := 'Voulez-vous appliquer cette modification à l''ensemble des lignes affectées à cet Article?';
    GestionModif(Question,'CODEARTICLE',CodeArticle.Text,OldCode,SG_ARTICLE);
  end;

end;

Procedure TOF_INTEGREFICTPI.GestionModif(Question, Zone, NewCode, OldCode : string; IndLigne : Integer);
Var TobL        : TOB;
    TOBC        : TOB;
begin

  Tobl    := TobGrille.Detail[Grille.row-1];

  //Si le nouveau code = l'ancien aucune modifs
  if NewCode = OldCode then Exit;

  //si l'ancien code était à blanc pas de modif en série
  if OldCode = '' then
    ModificationSimple(zone, Newcode, TOBL, IndLigne)
  else
  begin
    //s'il n'y a pas au moins deux ligne avec le même code pas de modification en série
    TOBC := TOBGrille.FindFirst([zone],[OldCode],False);
    if TOBC <> Nil then
    begin
      TOBC := TOBGrille.FindNext([zone],[OldCode],False);
      if TOBC = Nil then
        ModificationSimple(zone, Newcode, TOBL, IndLigne)
      else
      begin
        if PgiAsk(Question,'Modification en Série')=MrNo then
          ModificationSimple(zone, Newcode, TOBL,IndLigne)
        else
          ModificationenSerie(zone,OldCode, Newcode, TOBL, IndLigne);
      end;
    end
    else
    begin
      ModificationSimple(zone, Newcode, TOBL, IndLigne)
    end;
  end;

  AffichageGrilleAnomalie(TobAnomalie);

  //if Grille.row < Grille.RowCount-1 then
  //  Grille.row := Grille.row + 1
  //else
  //  Grille.row := 1;

  //GrilleRowEnter(self, Grille.Row, Cancel, true);

end;

Procedure TOF_INTEGREFICTPI.ModificationSimple(zone, Newcode : String; TOBL : TOB;IndLigne : Integer);
begin

  //pas de gestion en série...
  Grille.Cells [IndLigne,Grille.Row] := NewCode;

  if Zone = 'CODEARTICLE' then
  begin
    //chargement des infos article avec la nouvelle saisie
    ChargeTOBArticle(TOBL, NewCode);
    if TOBL.GetString('ANOMALIEMAR')='' then ChargeInfoArticle(TOBL);
  end
  else if Zone = 'CODEFOURNISSEUR' then
  begin
    //chargement des infos article avec la nouvelle saisie
    ChargeTOBTiers(TOBL, NewCode);
    if TOBL.GetString('ANOMALIEFRS')='' then ChargeInfoTiers(TOBL);
  end
  else if Zone = 'CODEAFFAIRE' then
  begin
    //chargement des infos article avec la nouvelle saisie
    ChargeTOBAffaire(TOBL, NewCode);
    if TOBL.GetString('ANOMALIEAFF')='' then ChargeInfoAffaire(TOBL);
  end
  else if Zone = 'NUMERO' then
  begin
    ChargeBL(TOBL, NewCode);
    ChargeInfoTiers(TOBL);
  end;

  Grille.Cells [IndLigne, Grille.Row] := NewCode;

  GestionAnomalie;

end;

Procedure TOF_INTEGREFICTPI.ModificationEnSerie(Zone, OldCode, Newcode : String; TOBL : TOB;IndLigne : Integer);
Var TobLInvArt  : TOB;
    Indice      : Integer;
begin

  //Suppression de la ligne d'inventaire pour l'ancien article
  if Zone = 'CODEARTICLE' then
  begin
    TobLInvArt  := TobInventaire.FindFirst(['CODEARTICLE'],[OldCode],True);
    if TOBLinvArt <> nil then FreeAndNil(TOBLInvArt);
  end;

  //
  //On boucle sur la tobgrille pour mettre à jour les codes
  For Indice := 0 to TOBGrille.Detail.Count -1 do
  begin
    if TobGrille.Detail[Indice].GetString(Zone) = OldCode then
    begin
      Grille.Row := Indice+1;
      TobGrille.Detail[Indice].PutVALUE(Zone, NewCode);
      Grille.Cells [IndLigne, Grille.Row] := NewCode;
      if Zone = 'CODEAFFAIRE' then
        ChargeTOBAffaire(TobGrille.Detail[Grille.row-1], NewCode)
      else if Zone = 'CODEFOURNISSEUR' then        //chargement des infos fournisseurs avec la nouvelle saisie
        ChargeTobTiers(TobGrille.Detail[Grille.row-1], NewCode)
      else if Zone = 'CODEARTICLE' then           //chargement des infos article avec la nouvelle saisie
        ChargeTOBArticle(TobGrille.Detail[Grille.row-1], NewCode);
      GestionAnomalie;
    end;
  end;

  Grille1.Row := 1;
  GrilleRowEnter(self, Grille.Row, Cancel, true);

end;

procedure TOF_INTEGREFICTPI.GrilleRowEnter(Sender: TObject; Ou: Longint; var Cancel: Boolean; Chg: Boolean);
Var Indice : Integer;
    NoLig  : String;
begin

  if Grille.RowCount = 0 then Exit;

  NoLig := TOBGrille.detail[ou-1].GetValue('NOLIG');

  ChargeGrilleToScreen(Ou, TOBGrille.detail[ou-1]);

  //GestionAnomalie;

  //AffichageGrilleAnomalie(TobAnomalie);

  Grille1.Row := 1;

  CaptionErreur.Caption := '';
      
  //positionnement sur la grille Anomalie pour garder la cohérence d'affichage
  for Indice := 0 to TobAnomalie.detail.count -1 do  begin
    if TobAnomalie.Detail[Indice].GetValue('NOLIG')= NoLig then
    begin
      Grille1.Row := Indice + 1;
      CaptionErreur.Caption := TobAnomalie.Detail[Indice].GetValue('TYPEERREUR');
      break;
    end;
  end;

end;

procedure TOF_INTEGREFICTPI.Grille1RowEnter(Sender: TObject; Ou: Longint; var Cancel: Boolean; Chg: Boolean);
Var TypeErr : string;
begin

  if Grille1.RowCount = 0 then Exit;

  //positionnement sur la grille toutes
  //il faut dans un premier temps trouver la ligne dans la tob...
  if TOBGrille.Detail.count > 0 then
  begin
    Grille.Row := StrToInt(TOBanomalie.detail[ou-1].GetValue('NOLIG'));
    GrilleRowEnter(self, Grille.Row, Cancel, true);
  end
  else
  begin
    if TobRejete.Detail.Count > 0 then
    begin
      TypeErr := Tobrejete.detail[Ou-1].GetString('TYPEERREUR');
      if TypeErr = 'GEN' then
      begin
        PGeneralite.TabVisible  := True;
        PArticle.TabVisible     := False;
        PFournisseur.TabVisible := False;
        PAffaire.TabVisible     := False;
        PEdition.TabVisible     := False;
        PInventaire.TabVisible  := False;
      end
      else if TypeErr = 'ART' then
      begin
        PGeneralite.TabVisible  := False;
        PArticle.TabVisible     := True;
        PFournisseur.TabVisible := False;
        PAffaire.TabVisible     := False;
        PEdition.TabVisible     := False;
        PInventaire.TabVisible  := False;
      end
      else if TypeErr = 'AFF' then
      begin
        PGeneralite.TabVisible  := False;
        PArticle.TabVisible     := False;
        PFournisseur.TabVisible := False;
        PAffaire.TabVisible     := True;
        PEdition.TabVisible     := False;
        PInventaire.TabVisible  := False;
      end
      else if TypeErr = 'FRS' then
      begin
        PGeneralite.TabVisible  := False;
        PArticle.TabVisible     := False;
        PFournisseur.TabVisible := True;
        PAffaire.TabVisible     := False;
        PEdition.TabVisible     := False;
        PInventaire.TabVisible  := False;
      end
      else if TypeErr = 'INV' then
      begin
        GestionGrilleInventaire;
      end
    end;
  end;

end;

Procedure TOF_INTEGREFICTPI.GestionGrilleInventaire;
begin

  PGeneralite.TabVisible  := False;
  PArticle.TabVisible     := False;
  PFournisseur.TabVisible := False;
  PAffaire.TabVisible     := False;
  PEdition.TabVisible     := False;
  //
  AffichageGrilleInventaire;
  //
  PInventaire.TabVisible  := True;

end;

Procedure TOF_INTEGREFICTPI.InventaireDblClick(Sender: TObject);
Var TOBLigInvent : TOB;
    TOBL         : TOB;
begin

  With GestionGS do
  begin
    TOBLigInvent := TOBG.detail[GS.Row +1];
    TOBL         := TobGrille.Detail[Grille.row+1];
    //
    MAJLigneInventaire(TOBLigInvent, TOBL);
  end;

end;

procedure TOF_INTEGREFICTPI.ChargeTOB;
Var FSource  : TextFile;
    StLig    : string;
    TOBL     : TOB;
    RImport  : string;
    CodeBarre: String;
    NoLig    : Integer;
    Indice   : Integer;
    TypeMvt  : string;
begin

  RImport   := FichierImport.text;

  NoLig     := 0;

  AssignFile(FSource,RImport);   //Associe la variable F au fichier texte
  try
    Reset(FSource); //Ouvre le fichier sans le modifier

    While Not eof(FSource) do
    Begin
        TOBL := TOB.Create('Les Lignes',TOBGrille,-1);
        LibErreur := '';
        Readln(FSource, StLig); //Lit une ligne du fichier text jusqu'au prochain saut de ligne
        //on initialise les zones de la TOB
        InitZoneTOB(TOBL);
        //On charge la tob avec les valeurs du fichier text
        ChargementLigneTOB(TOBL,StLig);
    end;

  finally
    CloseFile(FSource); //Ferme l'association entre la variable F et le fichier texte
    if TOBGrille.Detail.count > 0 then TOBGrille.Detail.Sort('TYPEMVT;DEPOT;CODEFOURNISSEUR;CODEAFFAIRE;NUMCDE;NUMBL');
  end;

  for Indice := 0 To TobGrille.Detail.count -1 do
  begin
    TobL := TobGrille.detail[Indice];

    //Oncharge le Numéro de ligne
    inc(NoLig);
    TOBL.PutValue('NOLIG', NoLig);
    //
    TypeMvt       := TOBL.GetString('TYPEMVT');
    //
    //On Contrôle l'existence du dépot
    CodeBarre     := TOBL.GetString('DEPOT');
    ChargeTobDepot(TOBL, CodeBarre);

    //On charge l'onglet Affaire en fonction du type de Mouvement
    if (TypeMVT ='SA') OR (TypeMVT='EA') then
    begin
      CodeBarre     := TOBL.GetString('CODEAFFAIRE');
      ChargeTobAffaire(TOBL, CodeBarre);
    end;

    //On charge l'onglet Fournisseur en fonction du type de Mouvement
    if (TypeMVT = 'CD') then
    begin
      CodeBarre     := TOBL.GetString('CODEAFFAIRE');
      ChargeTobAffaire(TOBL, CodeBarre);
      CodeBarre     := TOBL.GetString('CodeFOURNISSEUR');
      ChargeTOBTiers(TOBL, CodeBarre);
    end;

    if (TypeMVT = 'BL') then
    BEGIN
      CodeBarre     := TOBL.GetString('NUMCDE');
      ChargeBL(TOBL, CodeBarre);
    END;

    //On charge l'onglet Article
    CodeBarre     := TOBL.GetString('CodeARTICLE');
    ChargeTobArticle(TOBL, CodeBarre);
    //
    TOBL.PutValue('TYPEERREUR', GenerationMsgAnomalie(TOBL));

  end;

end;

Function TOF_INTEGREFICTPI.GenerationMsgAnomalie(TOBL : TOB) : String;
Var MotifAnomalie : string;
begin

  Result := '';

  if (TOBL.getString('ANOMALIE') = '')    AND
     (TOBL.GetString('TYPEERREUR') = '')  AND
     (TOBL.GetString('ANOMALIEAFF') = '') AND
     (TOBL.GetString('ANOMALIECLI') = '') AND
     (TOBL.GetString('ANOMALIEFRS') = '') AND
     (TOBL.GetString('ANOMALIEMAR') = '') Then Exit;

  //contrôle si des anomalies et chargement du libellé d'erreur
  IF TOBL.GetString('ANOMALIE')='DEPOT' then
  begin
    if Result = '' then Result := 'Erreur sur la ligne :';
    MotifAnomalie := 'Dépôt Inexistant';
    Result := Result + ' ' + MotifAnomalie;
  end;

  IF (TOBL.GetString('TYPEERREUR') = 'GEN') OR
     (TOBL.GetString('TYPEERREUR') = 'ART') OR
     (TOBL.GetString('TYPEERREUR') = 'AFF') OR
     (TOBL.GetString('TYPEERREUR') = 'FRS') OR
     (TOBL.GetString('TYPEERREUR') = 'INV') then
  begin
    if Result = '' then Result := 'Erreur sur la ligne :';
    MotifAnomalie := TOBL.GetString('MOTIF');
    Result := Result + ' ' + MotifAnomalie;
  end;

  IF TOBL.GetString('ANOMALIEAFF')='X' then
  begin
    if Result = '' then Result := 'Erreur sur la ligne :';
    MotifAnomalie := TOBL.GetString('LIBANOMALIEAFF');
    if motifAnomalie = '' then
      Result := Result + 'Anomalie Affaire'
    else
      Result := Result + ' ' + MotifAnomalie;
  end;

  IF TOBL.GetString('ANOMALIECLI')='X' then
  begin
    if Result = '' then Result := 'Erreur sur la ligne :';
    MotifAnomalie := TOBL.GetString('LIBANOMALIECLI');
    if motifAnomalie = '' then
      Result := Result + 'Anomalie Client'
    else
      Result := Result + ' ' + MotifAnomalie;
  end;

  IF TOBL.GetString('ANOMALIEFRS')='X' then
  begin
    if Result = '' then Result := 'Erreur sur la ligne :';
    MotifAnomalie := TOBL.GetString('LIBANOMALIEFRS');
    if motifAnomalie = '' then
      Result := Result + 'Anomalie Fournisseur'
    else
      Result := Result + ' ' + MotifAnomalie;
  end;

  IF (TOBL.GetString('ANOMALIEMAR')='X') OR
     (TOBL.GetString('ANOMALIEMAR')='S') OR
     (TOBL.GetString('ANOMALIEMAR')='F') then
  begin
    if Result = '' then Result := 'Erreur sur la ligne :';
    MotifAnomalie := TOBL.GetString('LIBANOMALIEMAR');
    if motifAnomalie = '' then
      Result := Result + 'Anomalie Marchandise'
    else
      Result := Result + ' ' + MotifAnomalie;
  end;

end;

procedure TOF_INTEGREFICTPI.ChargeTOBDepot(TOBL : TOB; CodeDepot : string);
Var CodeArticle : String;
    Qteinv      : Double;
    Qte         : double;
    ToblInvArt  : TOB;
begin

  TOBDepot := TOB.Create('DEPOTS',nil,-1);

  TOBL.PutValue('ANOMALIE', '');

  StSQL := 'SELECT GDE_LIBELLE FROM DEPOTS WHERE GDE_DEPOT="' + CodeDepot + '"';
  QQ := OpenSQL(STSQL,False);

  //Chargement des zones écran....
  if Not QQ.Eof then
  begin
    TOBDepot.SelectDB('UN DEPOT',QQ);
    TOBL.PutVALUE('LIB_DEPOT',      TOBDepot.GetString('GDE_LIBELLE'));
    //Recherche de la ligne Article/Dépôt dans l'inventaire pour Mise à jour de la quantité de la ligne
    CodeArticle := TOBL.GetString('CODEARTICLE');
    TobLInvArt  := TobInventaire.FindFirst(['CODEARTICLE','CODEDEPOT'],[CodeArticle,CodeDepot],True);
    //
    if TOBLinvArt <> nil then
    begin
      QteInv  := TOBLinvArt.GetDouble('QTE');
      QTE     := TOBL.GetDouble('QTE');
      QteInv  := QteInv + Qte;
      TOBLInvArt.PutValue('QTE', QteInv);
    end;
  end
  else
  begin
    TOBL.PutValue('ANOMALIE', 'DEPOT');
  end;

  Ferme(QQ);

  FreeAndNil(TobDepot);

end;


Procedure TOF_INTEGREFICTPI.ChargementLigneTOB(TOBL : TOB;StLig : String);
Var StDate  : string;
    StQte   : String;
    DateMvt : TDateTime;
    Qte     : Double;
    TypeMvt : string;
begin

  if StLig = '' then Exit;

  TypeMVT := copy(StLig,1,2);

  StDate  := Copy(StLig,9,2) + '/' + copy(StLig,7,2) + '/' + copy(StLig,3,4);
  DateMvt := StrToDate(StDate);
  //
  StQte := Trim(FindEtReplace(Copy(StLig,31,12),'.',',',True));
  if IsNumeric(StQte, True) Then Qte := StrToFloat(StQte) else Qte := 0;

  //On découpe l'enreg et on positionne les zones dans la TOBGrille
  TOBL.PutValue('TYPEMVT',TypeMvt);

  if DateMvt = iDate1900 then
    TOBL.PutValue('DATEMVT',DateToStr(now))
  else
    TOBL.PutValue('DATEMVT',DateTimeToStr(DateMvt));

  TOBL.PutValue('DEPOT',           Trim(Copy(StLig,73,20)));
  //
  if TypeMvt = 'BL' then
  begin
    TOBL.PutValue('NUMBL',         Trim(Copy(StLig,43,20)));
    TOBL.PutValue('NUMCDE',        Trim(Copy(StLig,93,20)));
    NumBL.Text  := TOBL.GetValue('NUMBL');
    NumCde.Text := TOBL.GetValue('NUMCDE');
  end
  else
  begin
    TOBL.PutValue('CODEAFFAIRE',     Trim(Copy(StLig,43,20)));
    TOBL.PutValue('CODEFOURNISSEUR', Trim(Copy(StLig,93,20)));
  end;
  //
  TOBL.PutValue('CODEARTICLE',     Trim(copy(StLig,11,20)));
  TOBL.PutValue('QTE', Qte);
  TOBL.PutValue('ANALYSE',         Trim(Copy(StLig,63,10)));
  //
end;

procedure TOF_INTEGREFICTPI.ChargeGrilleToScreen(Arow : Integer; TOBL : TOB);
Var ValQte      : Double;
begin

  InitZoneEcran;
  //
  PAffaire.TabVisible      := False;
  PFournisseur.TabVisible  := False;
  PArticle.TabVisible      := False;
  //
  TNumCde.Visible          := False;
  NumCde.Visible           := False;
  TNumBL.Visible           := False;
  NumBL.Visible            := False;
  BTSelectNumCde.Visible   := False;
  //
  CodeTiers.Enabled        := True;
  CAB_Tiers.Enabled        := True;

  //On charge l'onglet Généralité
  TypeMVT.Value := TOBL.GetString('TYPEMVT');
  DateMvt.Text  := TOBL.GetString('DATEMVT');
  Analyse.Text  := TOBL.GetString('ANALYSE');
  Depot.Text    := TOBL.GetString('DEPOT');

  ValQte        := StrToFloat(TOBL.GetString('QTE'));
  if ValQte     <> 0 then Qte.enabled := False else Qte.enabled := true;
  Qte.Text      := FloatToStr(ValQte);

  if  (TypeMvt.Value = 'BT') or (TypeMVT.Value = 'SA') Or (TypeMVT.Value = 'EA') then
  begin
    PAffaire.TabVisible      := True;
    PFournisseur.tabVisible  := False;
    //On charge l'onglet Affaire
    ChargeInfoAffaire(TOBL);
    //Pages.ActivePage := PAffaire;
  end
  else if (TypeMVT.Value = 'CD') then
  begin
    PAffaire.TabVisible      := True;
    ChargeInfoAffaire(TOBL);
    PFournisseur.TabVisible  := True;
    //On charge l'onglet fournisseur
    ChargeInfoTiers(TOBL);
    //Pages.ActivePage := PFournisseur;
  end
  else if (TypeMVT.Value = 'BL') then
  begin
    if TOBL.GetString('CODEAFFAIRE') <> '' then
    begin
      PAffaire.TabVisible := True;
      //On charge l'onglet Affaire
      ChargeInfoAffaire(TOBL);
      PAffaire.Enabled    := False;
    end;
    PFournisseur.TabVisible  := True;    //On charge l'onglet fournisseur
    BtSelect2.Visible         := False;
    BtEfface2.Visible         := False;
    CodeTiers.Enabled        := False;
    CAB_Tiers.Enabled        := False;
    ChargeInfoTiers(TOBL);
    TNumCde.Visible          := True;
    NumCde.Visible           := True;
    TNumBL.Visible           := True;
    NumBL.Visible            := True;
    //BTSelectNumCde.Visible   := True;
  end
  else if (TypeMvt.Value = 'BT') then
    PAffaire.Caption := 'Appels/Interventions'
  else
    PAffaire.Caption := 'Chantiers';

  PArticle.TabVisible  := True;

  LIB_TenueStock.visible  := False;
  Art_TenueStock.Checked  := False;
  Art_Ferme.Checked       := False;
  Frs_Ferme.Checked       := False;
  Aff_Ferme.Checked       := False;

  //chargement à partir de TOBL le reste est fait dans charge tob...
  Lib_Depot.caption := TOBL.GetString('LIB_DEPOT');

  //On charge l'onglet Article
  ChargeInfoArticle(TOBL);

  Pages.ActivePage := PGeneralite;
  
  //On se positionne sur le bon onglet
  //if  (TypeMvt.Value = 'BT') or (TypeMVT.Value = 'SA') Or (TypeMVT.Value = 'EA') then
  //  Pages.ActivePage := PAffaire
  //else if (TypeMVT.Value = 'CD') then
  //  Pages.ActivePage := PFournisseur
  //else
  //  Pages.ActivePage := PArticle;

end;

procedure TOF_INTEGREFICTPI.ChargeTobAffaire(TOBL : TOB; CodeBarre : string);
Var TypeMvt : string;
begin

  if CodeBarre = '' then exit;

  TOBAffaire := TOB.Create('CAB_AFFAIRE',nil,-1);

  TOBL.PutValue('ANOMALIEAFF', '');

  //FV1 - 16/12/2015 : FS#1833 - GESTION TPI : Modification dans la récupération du code chantier.
  if copy(CodeBarre,1,1) <> 'A' then Codebarre := 'A' + CodeBarre;

  ChargeCleAffaire (Affaire0,Affaire1,Affaire2,Affaire3,Avenant, BtSelect1, TaModif, CodeBarre, True);

  StSQL := 'SELECT *  FROM AFFAIRE ';
  StSQL := StSQL + ' WHERE AFF_AFFAIRE0="' + Affaire0.Text + '" ';
  StSQL := StSQL + '   AND AFF_AFFAIRE1="' + Affaire1.Text + '" ';
  StSQL := StSQL + '   AND AFF_AFFAIRE2="' + Affaire2.Text + '" ';
  StSQL := StSQL + '   AND AFF_AFFAIRE3="' + Affaire3.Text + '" ';

  QQ    := OpenSQL(StSQL, False);

  TypeMvt       := TOBL.GetString('TYPEMVT');

  //Chargement des zones écran....
  if Not QQ.Eof then
  begin
    TOBAffaire.SelectDB('UNE AFFAIRE',QQ);
    if (TypeMVT = 'CD') And (OkAccepte) And (TOBAffaire.GetValue('AFF_ETATAFFAIRE')<> 'ACP') then
    begin
      TOBL.PutValue('ANOMALIEAFF', 'X');
      TOBL.PutValue('LIBANOMALIEAFF','Chantier Non Accepté');
      ChargeTOBGRILLEwithTOBAFFAIRE(TOBL, TOBAFFAIRE);
    end
    Else
      ChargeTOBGRILLEwithTOBAFFAIRE(TOBL, TOBAFFAIRE);
  end
  else
  begin
    TOBL.PutValue('ANOMALIEAFF', 'X');
    TOBL.PutValue('LIBANOMALIEAFF','Chantier Inexistant');
  end;

  Ferme(QQ);

  FreeAndNil(TobAffaire);

end;

procedure TOF_INTEGREFICTPI.ChargeTOBGRILLEwithTOBAFFAIRE(TOBL,TOBAFFAIRE : TOB);
Begin

  TOBL.PutVALUE('CLIENT',      TOBAffaire.GetString('AFF_TIERS'));

  TOBL.PutValue('ANOMALIECLI', '');

  StSQL := 'SELECT T_LIBELLE FROM TIERS WHERE T_NATUREAUXI="CLI" AND T_TIERS="' + TOBAffaire.GetString('AFF_TIERS') + '"';
  QQ := Opensql(StSQL,False);
  if not QQ.eof then
    TOBL.PutVALUE('LIB_CLIENT', QQ.Findfield('T_LIBELLE').asString)
  else
  begin
    TOBL.PutValue('ANOMALIECLI', 'X');
    TOBL.PutValue('LIBANOMALIECLI','Client Inexistant');
    TOBL.PutVALUE('CLIENT', '');
    TOBL.PutValue('LIB_CLIENT','');
  end;
  Ferme(QQ);

  TOBL.PutVALUE('CODEAFFAIRE', TOBAffaire.GetString('AFF_AFFAIRE'));
  TOBL.PutVALUE('AFF_AFFAIRE', TOBAffaire.GetString('AFF_AFFAIRE'));
  TOBL.PutVALUE('LIB_AFFAIRE', TOBAffaire.GetString('AFF_LIBELLE'));
  //
  IF TOBAffaire.FieldExists('BCB_CODEBARRE')        then TOBL.PutVALUE('CAB_Affaire',   TOBAffaire.GetString('BCB_CODEBARRE'));
  IF TOBAffaire.FieldExists('BCB_QUALIFCODEBARRE')  then TOBL.PutVALUE('AFF_QUALIFCAB', TOBAffaire.GetString('BCB_QUALIFCODEBARRE'));
  //
  TOBL.PutVALUE('Lib_Responsable'  , RechDom('AFLRESSOURCE',TOBAffaire.GetString('AFF_RESPONSABLE'),False));
  TOBL.PutVALUE('Domaine'          , TOBAffaire.GetString('AFF_DOMAINE'));
  TOBL.PutVALUE('Etablissement'    , TOBAffaire.GetString('AFF_ETABLISSEMENT'));
  TOBL.PutVALUE('Lib_Domaine'      , RechDom('AFLRESSOURCE',TOBAffaire.GetString('AFF_DOMAINE'), False));
  //
  TOBL.PutVALUE('AFF_FERME',   TOBAffaire.GetString('AFF_FERME'));
  //
end;

procedure TOF_INTEGREFICTPI.ChargeInfoAffaire(TOBL : TOB);
begin

  Client.Text         := TOBL.GetString('CLIENT');
  Lib_Tiers.caption   := TOBL.GetString('LIB_CLIENT');
  //
  Affaire.Text        := TOBL.GetString('CODEAFFAIRE');
  if copy(Affaire.Text,1,1) <> 'A' then Affaire.Text := 'A' + Affaire.Text;
  TOBL.PutValue('CODEAFFAIRE', Affaire.text);
  //
  Lib_Affaire.Caption := TOBL.GetString('LIB_AFFAIRE');
  //
  CAB_Affaire.Text    := TOBL.GetString('CAB_Affaire');
  Aff_QualifCAB.Value := TOBL.GetString('Aff_QualifCAB');
  //
  Lib_Responsable.Caption := TOBL.GetString('Lib_Responsable');
  Domaine                 := TOBL.GetString('DOMAINE');
  Etablissement           := TOBL.GetString('ETABLISSEMENT');
  Lib_Domaine.Caption     := TOBL.GetString('LIB_DOMAINE');
  //
  If TOBL.GetString('AFF_FERME')='X' then Aff_Ferme.Checked := True else Aff_Ferme.Checked := False;
  //
  ChargeCleAffaire (Affaire0,Affaire1,Affaire2,Affaire3,Avenant, BtSelect1, TaModif, Affaire.Text, True);

end;

procedure TOF_INTEGREFICTPI.ChargeTobTiers(TOBL : TOB; CodeBarre : string);
begin

  TOBTiers   := TOB.Create('CAB_TIERS  ',nil,-1);

  TOBL.PutValue('ANOMALIEFRS', '');

  StSQL := 'SELECT * FROM TIERS WHERE T_NATUREAUXI="FOU" AND T_TIERS="' + CodeBarre + '"';
  QQ    := OpenSQL(StSQL, False);

  //Chargement des zones écran....
  if Not QQ.Eof then
  begin
    TOBTiers.SelectDB('UN TIERS',QQ);
    ChargeTOBGRILLEwithTOBTIERS(TobL, TOBTiers);
  end
  else
  begin
    TOBL.PutValue('ANOMALIEFRS', 'X');
    TOBL.PutValue('LIBANOMALIEFRS', 'Fournisseur Inexistant');
  end;

  Ferme(QQ);

  FreeAndNil(TobTiers);

end;

procedure TOF_INTEGREFICTPI.ChargeBL(TOBL : TOB; CodeBarre : String);
Var CodeTiers : String;
    Codeaff   : String;
begin

  if CodeBarre = '' then exit;

  StSQL := 'SELECT GP_REFINTERNE, GP_TIERS, GP_AFFAIRE FROM PIECE WHERE GP_NATUREPIECEG="CF" ';
  StSQL := StSQL + '  AND GP_NUMERO=' + CodeBarre;
  StSQL := StSQL + '  AND GP_INDICEG=0';
  QQ    := OpenSQL(StSQL, False,1,'',True);

  //chargement du Numéro de Fournisseur
  if Not QQ.eof then
  begin
    CodeTiers  := QQ.Findfield('GP_TIERS').asString;
    CodeAff    := QQ.Findfield('GP_AFFAIRE').asString;
    TOBL.PutValue('REFINTERNE'  , QQ.Findfield('GP_REFINTERNE').asString);
    TOBL.PutValue('NATPIECEPREC', 'CF');
    Ferme(QQ);

    if Codeaff <> '' then ChargeTobAffaire(TOBL, CodeAff);

    ChargeTobTiers(TOBL, CodeTiers);

    TOBL.PutValue('ANOMALIEFRS', '');
    TOBL.PutValue('LIBANOMALIEFRS', '');
  end
  else
  begin
    TOBL.PutValue('ANOMALIEFRS', 'X');
    TOBL.PutValue('LIBANOMALIEFRS', 'Commande fournisseur Inexistante');
  end;


end;


procedure TOF_INTEGREFICTPI.ChargeTOBGRILLEwithTOBTIERS(TOBL, TOBTiers : TOB);
begin

  TOBL.PutValue('T_TIERS', TOBTiers.GetString('T_TIERS'));
  TOBL.PutValue('CODEFOURNISSEUR', TOBTiers.GetString('T_TIERS'));

  IF TOBTiers.FieldExists('BCB_CODEBARRE') Then
    TOBL.PutVALUE('CAB_Tiers',TOBTiers.GetString('BCB_CODEBARRE'))
  else
    TOBL.PutVALUE('CAB_Tiers',TOBTiers.GetString('T_CODEBARRE'));
  //
  IF TOBTiers.FieldExists('BCB_QUALIFCODEBARRE') Then
    TOBL.PutVALUE('Frs_QualifCAB',TOBTiers.GetString('BCB_QUALIFCODEBARRE'))
  else
    TOBL.PutVALUE('Frs_QualifCAB',TOBTiers.GetString('T_QUALIFCODEBARRE'));

  TOBL.PutVALUE('Juridique', RechDom('TTFORMEJURIDIQUE',TOBTiers.GetString('T_JURIDIQUE'),False));

  TOBL.PutVALUE('Nom',  TOBTiers.GetString('T_LIBELLE'));
  TOBL.PutVALUE('ADR1', TOBTiers.GetString('T_PRENOM'));
  TOBL.PutVALUE('ADR2', TOBTiers.GetString('T_ADRESSE1'));
  TOBL.PutVALUE('ADR3', TOBTiers.GetString('T_ADRESSE2'));
  TOBL.PutVALUE('ADR4', TOBTiers.GetString('T_ADRESSE3'));
  TOBL.PutVALUE('CP',   TOBTiers.GetString('T_CODEPOSTAL'));
  TOBL.PutVALUE('Ville',TOBTiers.GetString('T_VILLE'));

  TOBL.PutVALUE('Frs_Ferme', TobTiers.GetString('T_FERME'));

end;

procedure TOF_INTEGREFICTPI.ChargeInfoTiers(TOBL : TOB);
begin

  CodeTiers.Text      := TOBL.GetString('CODEFOURNISSEUR');

  NUMCDE.Visible          := TOBL.GetString('TYPEMVT') = 'BL';
  NUMBL.Visible           := TOBL.GetString('TYPEMVT') = 'BL';
  //BTSelectNumCde.Visible  := TOBL.GetString('TYPEMVT') = 'BL';
  TNumCde.Visible         := TOBL.GetString('TYPEMVT') = 'BL';
  TNumBL.Visible          := TOBL.GetString('TYPEMVT') = 'BL';

  if TOBL.GetString('TYPEMVT') = 'BL' then
  begin
    NUMCDE.text       := TOBL.GetString('NUMCDE');
    NUMBL.text        := TOBL.GetString('NUMBL');
  end;

  CAB_Tiers.Text      := TOBL.GetString('CAB_Tiers');
  //
  Frs_QualifCAB.Value := TOBL.GetString('Frs_QualifCAB');

  Juridique.Caption   := TOBL.GetString('Juridique');

  Nom.caption         := TOBL.GetString('Nom');
  ADR1.Caption        := TOBL.GetString('ADR1');
  ADR2.Caption        := TOBL.GetString('ADR2');
  ADR3.Caption        := TOBL.GetString('ADR3');
  ADR4.Caption        := TOBL.GetString('ADR4');
  CP.Caption          := TOBL.GetString('CP');
  Ville.Caption       := TOBL.GetString('Ville');

  If TOBL.GetString('T_FERME')='X' then Frs_Ferme.Checked := True else Frs_Ferme.Checked := False;

end;

procedure TOF_INTEGREFICTPI.ChargeTobArticle(TOBL : TOB; CodeBarre : string);
begin

  TOBarticle   := TOB.Create('CAB_ARTICLE',nil,-1);

  TOBL.PutValue('ANOMALIEMAR', '');

  //Lecture du fichier CodeBarre pour récupération du code affaire
  StSQL := 'SELECT * FROM BTCODEBARRE LEFT JOIN ARTICLE ON BCB_IDENTIFCAB=GA_ARTICLE ';
  StSQL := StSQL + ' WHERE BCB_NATURECAB= GA_TYPEARTICLE ';
  StSQL := StSQL + '   AND BCB_CODEBARRE="' + CodeBarre + '"';
  QQ    := OpenSQL(StSQL, False);

  if QQ.EOF then
  begin
    StSQL := 'SELECT * FROM ARTICLE WHERE GA_TYPEARTICLE="MAR" ';
    StSQL := StSQL + '  AND (GA_CODEARTICLE="' + CodeBarre + '" ';
    StSQL := StSQL + '   OR GA_ARTICLE="' + CodeBarre + '")';
    QQ    := OpenSQL(StSQL, False);
  end;

  //Chargement des zones écran....
  if Not QQ.Eof then
  begin
    TOBarticle.SelectDB('UN ARTICLE',QQ);
    ChargeTOBGRILLEwithTOBArticle(TobL, TOBArticle);
    RechercheInventaireArticle(TOBL);
  end
  else
  Begin
    TOBL.PutValue('ANOMALIEMAR', 'X');
    TOBL.PutValue('LIBANOMALIEMAR', 'Article Inexistant');
  end;

  Ferme(QQ);

  FreeAndNil(TOBarticle);

end;

Procedure TOF_INTEGREFICTPI.RechercheInventaireArticle(TOBL : TOB);
Var TOBLInvArt  : TOB;
    TOBLInv     : TOB;
    TOBLigInv   : TOB;
    CodeArticle : String;
    CodeDepot   : String;
begin

  CodeArticle := TOBL.GetString('CODEARTICLE');
  CodeDepot   := TOBL.GetString('DEPOT');

  //On vérifie que l'article n'existe pas déjà dans la TOBInventaire
  TobLInvArt  := TobInventaire.FindFirst(['CODEARTICLE'],[CodeArticle],True);
  if TOBLinvArt = nil then  //il n'existe pas
  Begin
    TOBLInvArt := TOB.Create('ARTINV', TobInventaire,-1);
    TOBLInvArt.AddChampSupValeur('CODEARTICLE',CodeArticle);
    TOBLInvArt.AddChampSupValeur('QTECALC', 0.00);
  end;

  //Il existe on vérifie s'il a déjà des lignes d'inventaire par dépôt
  TobLInv  := TobLInvArt.FindFirst(['GIL_CODEARTICLE','GIL_DEPOT'],[CodeArticle, Depot.text],True);
  if TOBLinv = nil then //Aucune ligne pour cet article/Dépot
  Begin
    //on lit la liste d'inventaire de l'Article chargé
    StSQL := 'SELECT *  FROM LISTEINVENT LEFT JOIN LISTEINVLIG ';
    StSQL := StSQL + '    ON GIE_CODELISTE=GIL_CODELISTE ';
    StSQL := STSQL + ' WHERE GIE_VALIDATION="-" ';
    StsQL := StSQL + '   AND GIE_UTILISATEUR="' + V_PGI.User + '"';
    StSQL := StSQL + '   AND GIL_CODEARTICLE="' + CodeArticle + '"';
    //
    QQ := OpenSQL(StsQl, False);
    //
    if not QQ.eof then
    begin
      TOBLinv := TOB.Create ('lignes inventaire', TOBLInvArt, -1);
      TOBLInv.SelectDB('Ligne Inventaire', QQ);
      TOBLInv.AddChampSupValeur('QTECALC', 0.00);
      TOBLInv.AddChampSupValeur('NOLIG', TOBL.GetValue('NOLIG'));
      AdditionQteInventaire(CodeArticle, TOBL.GetDouble('QTE'), TOBL.GetValue('NOLIG'));
    end;
    Ferme(QQ);
  end
  else //Il existe au moins une liste pour cet article/dépot
  begin
    //Cette liste correspond à la ligne que nous sommes en train de traiter
    If TobLInv.GetValue('NOLIG')=TOBL.GetValue('NOLIG') then
      AdditionQteInventaire(CodeArticle, TOBL.GetDouble('QTE'),TOBL.GetValue('NOLIG'))
    else
    begin //elle ne correspond pas on la duplique
      TOBLiginv := TOB.Create ('lignes inventaire', TOBLInvArt, -1);
      TOBLIginv.Dupliquer(TobLInv, True, True);
      TOBLInv.PutValue('NOLIG', TOBL.GetValue('NOLIG'));
      TOBLInv.PutValue('QTECALC', 0.00);
      AdditionQteInventaire(CodeArticle, TOBL.GetDouble('QTE'),TOBL.GetValue('NOLIG'));
    end;
  end;

end;

procedure TOF_INTEGREFICTPI.ChargeTOBGRILLEwithTOBArticle(TOBL, TOBArticle : TOB);
begin

  TOBL.PutValue('CODEARTICLE',    TobArticle.GetString('GA_CODEARTICLE'));
  TOBL.PutValue('GA_ARTICLE',     TobArticle.GetString('GA_ARTICLE'));
  TOBL.PutVALUE('Article'    ,    TobArticle.GetString('GA_ARTICLE'));
  TOBL.PutVALUE('Lib_Article',    TOBArticle.GetString('GA_LIBELLE'));
  //
  IF TobArticle.FieldExists('BCB_CODEBARRE') Then
    TOBL.PutVALUE('CAB_Article',  TOBArticle.GetString('BCB_CODEBARRE'))
  else
    TOBL.PutVALUE('CAB_Article',  TOBArticle.GetString('GA_CODEBARRE'));

  IF TobArticle.FieldExists('BCB_QUALIFCODEBARRE') Then
    TOBL.PutVALUE('Art_QualifCAB',TOBArticle.GetString('BCB_QUALIFCODEBARRE'))
  else
    TOBL.PutVALUE('Art_QualifCAB',TOBArticle.GetString('GA_QUALIFCODEBARRE'));
  //
  TOBL.PutVALUE('QUALIFUNITESTO', TobArticle.GetString('GA_QUALIFUNITESTO'));
  TOBL.PutVALUE('QUALIFUNITEACH', TobArticle.GetString('GA_QUALIFUNITEACH'));
  TOBL.PutVALUE('QUALIFUNITEVTE', TobArticle.GetString('GA_QUALIFUNITEVTE'));
  //
  TOBL.PutVALUE('CoefUSUV',       TobArticle.GetString('GA_COEFCONVQTEVTE'));
  TOBL.PutVALUE('CoefUAUS',       TobArticle.GetString('GA_COEFCONVQTEACH'));
  TOBL.PutVALUE('PAHT',           TobArticle.GetString('GA_PAHT'));
  TOBL.PutVALUE('PAUA',           TobArticle.GetString('GA_PAUA'));
  TOBL.PutVALUE('DPA',            TobArticle.GetString('GA_DPA'));
  TOBL.PutVALUE('PMAP',           TobArticle.GetString('GA_PMAP'));

  TOBL.PutVALUE('ART_FERME',      TobArticle.GetString('GA_FERME'));

  If TOBL.GetString('ART_FERME')='X'    then
  begin
    TOBL.PutValue('ANOMALIEMAR','F');
    TOBL.PutValue('LIBANOMALIEMAR'   ,'Art. Fermé');
  end;

  TOBL.PutVALUE('TENUESTOCK',     TobArticle.GetString('GA_TENUESTOCK'));

  If TOBL.GetString('TENUESTOCK')='-'  then
  Begin
    TOBL.PutValue('ANOMALIEMAR','S');
    TOBL.PutValue('LIBANOMALIEMAR','Art. non tenu en Stock');
  end;

end;

procedure TOF_INTEGREFICTPI.ChargeInfoArticle(TOBL : TOB);
begin

  CodeArticle.text     := TOBL.GetString('CODEARTICLE');
  Article.text         := TOBL.GetString('GA_ARTICLE');
  //
  Lib_Article.Caption  := TOBL.GetString('Lib_Article');
  //
  CAB_Article.text     := TOBL.GetString('CAB_Article');

  Art_QualifCAB.Value  := TOBL.GetString('Art_QualifCAB');
  //
  QualifUS.Value       :=  TOBL.GetString('QUALIFUNITESTO');
  QualifUA.Value       :=  TOBL.GetString('QUALIFUNITEACH');
  QualifUV.Value       :=  TOBL.GetString('QUALIFUNITEVTE');
  //
  CoefUSUV.Text        := TOBL.GetString('CoefUSUV');
  CoefUAUS.text        := TOBL.GetString('CoefUAUS');
  PAHT.Text            := TOBL.GetString('PAHT');
  PAUA.text            := TOBL.GetString('PAUA');
  DPA.text             := TOBL.GetString('DPA');
  PMAP.text            := TOBL.GetString('PMAP');

  IF CodeArticle.text = '' then TOBL.PutValue('ANOMALIEMAR', 'X');

  if TOBL.GetString('ANOMALIEMAR')='X' then exit;

  If TOBL.GetString('GA_FERME')='X'    then
    Art_Ferme.Checked := True
  else
    Art_Ferme.Checked := False;
  //
  If TOBL.GetString('TENUESTOCK')='X'  then
  begin
    LIB_TenueStock.visible := False;
    Art_TenueStock.checked := True;
  end
  else
  begin
    Art_TenueStock.checked := True;
    LIB_TenueStock.visible := false;
    //
    if PGIAsk('Cet Article : ' + Tobl.GetString('CODEARTICLE') + ' n''est pas tenue en stock, voulez-vous le modifier ?', 'Intégration TPI')=Mryes then
    begin
      StSQL := 'UPDATE ARTICLE SET GA_TENUESTOCK="X" WHERE GA_TYPEARTICLE="MAR" AND GA_ARTICLE="' + Article.Text + '"';
      If ExecuteSQL(StSQL)=0 then
      begin
        PgiError('La mise à jour de l''article à echouée !','Mise à jour Article');
        TOBL.PutValue('ANOMALIEMAR','S');
        TOBL.PutValue('LIBANOMALIEMAR', 'Art. non tenu en Stock');
      end
      else
      begin
        Art_TenueStock.checked := True;
        LIB_TenueStock.visible := false;
        TOBL.PUTVALUE('TENUESTOCK','X');
        TOBL.PutValue('ANOMALIEMAR','');
        TOBL.PutValue('LIBANOMALIEMAR', '');
        GestionAnomalie;
        AffichageGrilleAnomalie(TobAnomalie);
      end;
    end;
  end;

end;

Procedure TOF_INTEGREFICTPI.InitZoneEcran;
begin

  //On charge l'onglet Généralité
  TypeMVT.Value := '';
  DateMvt.Text  := '01/01/1900';
  Analyse.Text  := '';
  Depot.Text    := '';
  //
  InitZoneAffaire;
  //
  InitZoneFournisseur;
  //
  InitZoneArticle;
end;

procedure TOf_INTEGREFICTPI.InitZoneAffaire;
begin
  //
  Affaire0.Text := '';
  //
  Client.Text   := '';
  Affaire.Text  := '';
  Affaire1.text :='';
  Affaire2.text := '';
  Affaire3.Text := '';
  Avenant.Text  := '';
  //
  Lib_Affaire.Caption     := '';
  CAB_Affaire.Text        := '';
  Aff_QualifCAB.Value     := '';
  Lib_Responsable.Caption := '...';
  Lib_Domaine.Caption     := '...';

end;

Procedure TOF_INTEGREFICTPI.InitZoneAffaireToTob(TOBL : TOB);
begin

  TOBL.PutVALUE('CLIENT',      '');

  TOBL.PutValue('ANOMALIECLI', '');
  TOBL.PutValue('ANOMALIEAFF', '');

  TOBL.PutVALUE('LIB_CLIENT',  '...');
  TOBL.PutVALUE('CODEAFFAIRE', '');
  TOBL.PutVALUE('AFF_AFFAIRE', '');
  TOBL.PutVALUE('LIB_AFFAIRE', '...');
  //
  TOBL.PutVALUE('CAB_Affaire',   '');
  TOBL.PutVALUE('AFF_QUALIFCAB', '');
  //
  TOBL.PutVALUE('Lib_Responsable'  , '...');
  TOBL.PutVALUE('Domaine'          , '...');
  TOBL.PutVALUE('Etablissement'    , '...');
  TOBL.PutVALUE('Lib_Domaine'      , '...');
  //
  TOBL.PutVALUE('AFF_FERME',   '-');
  //
end;

procedure TOf_INTEGREFICTPI.InitZoneFournisseur;
begin

  CodeTiers.Text      := '';
  CAB_Tiers.Text      := '';
  Frs_QualifCAB.Value := '';
  //
  Juridique.Caption   := '...';
  Nom.caption         := '...';
  ADR1.Caption        := '...';
  ADR2.Caption        := '...';
  ADR3.Caption        := '...';
  ADR4.Caption        := '...';
  CP.Caption          := '...';
  Ville.Caption       := '...';

end;

Procedure TOF_INTEGREFICTPI.InitZoneFournisseurToTob(TOBL : TOB);
begin

  TOBL.PutValue('T_TIERS',          '');
  TOBL.PutValue('CODEFOURNISSEUR',  '');

  TOBL.PutVALUE('CAB_Tiers',        '');
  //
  TOBL.PutVALUE('Frs_QualifCAB',    '');

  TOBL.PutVALUE('Juridique',        '');

  TOBL.PutVALUE('Nom',  '');
  TOBL.PutVALUE('ADR1', '');
  TOBL.PutVALUE('ADR2', '');
  TOBL.PutVALUE('ADR3', '');
  TOBL.PutVALUE('ADR4', '');
  TOBL.PutVALUE('CP',   '');
  TOBL.PutVALUE('Ville','');

  TOBL.PutVALUE('Frs_Ferme', '');

end;

Procedure TOF_INTEGREFICTPI.InitZoneArticle;
Begin
  //
  CodeArticle.text     := '';
  Article.text         := '';
  CAB_Article.text     := '';
  Lib_Article.Caption  := '...';
  Art_QualifCAB.Value  := '';
  QualifUV.Value       := '';
  QualifUS.Value       := '';
  QualifUA.Value       := '';
  CoefUSUV.Text        := '';
  CoefUAUS.text        := '';
  PAHT.Text            := '0.00';
  PAUA.text            := '0.00';
  DPA.text             := '0.00';
  PMAP.text            := '0.00';
  //
end;

Procedure TOF_INTEGREFICTPI.InitZoneArticleToTob(TOBL : TOB);
begin

  //TOBL.PutValue('CODEARTICLE',    '');
  TOBL.PutVALUE('Article'    ,    '');
  TOBL.PutVALUE('Lib_Article',    '');
  //
  TOBL.PutVALUE('CAB_Article',    '');
  TOBL.PutVALUE('Art_QualifCAB',  '');
  //
  TOBL.PutVALUE('QUALIFUNITESTO', '');
  TOBL.PutVALUE('QUALIFUNITEACH', '');
  TOBL.PutVALUE('QUALIFUNITEVTE', '');
  //
  TOBL.PutVALUE('CoefUSUV',       '');
  TOBL.PutVALUE('CoefUAUS',       '');
  TOBL.PutVALUE('PAHT',           0);
  TOBL.PutVALUE('PAUA',           0);
  TOBL.PutVALUE('DPA',            0);
  TOBL.PutVALUE('PMAP',           0);

  TOBL.PutVALUE('GA_FERME',       '-');

  TOBL.PutVALUE('TENUESTOCK',     '-');

end;

procedure TOF_INTEGREFICTPI.RechercheAffaire;
Var StChamps  : String;
    CodeBarre : String;
    Question  : String;
begin

  StChamps  := Affaire.Text;

  if TypeMVT.Value = 'BT' then
    Affaire0.Text := 'W'
  else
    AFFAIRE0.Text := 'A';

  if GetAffaireEnteteSt(AFFAIRE0, Affaire1, Affaire2, Affaire3, AVENANT, Client, CodeBarre, false, false, false, True, true,'') then AFFAIRE.text := CodeBarre;

  If Affaire.Text <> '' then
  begin
    Question := 'Voulez-vous appliquer cette modification à l''ensemble des lignes affectées à cette affaire ?';
    GestionModif(Question,'CODEAFFAIRE',Affaire.text,StChamps,SG_AFFAIRE);
  end;

end;

Procedure TOF_INTEGREFICTPI.RechercheFournisseur;
Var StChamps  : string;
    Question  : string;
begin

  StChamps  := CodeTiers.Text;
  if stChamps = '' then Stchamps := TobGrille.Detail[Grille.row-1].getString('CODEFOURNISSEUR');

  CodeTiers.Text := AGLLanceFiche('GC','GCFOURNISSEUR_MUL','T_TIERS=' + CodeTiers.text +';T_NATUREAUXI=FOU','','SELECTION');

  If CodeTiers.Text <> '' then
  begin
    Question := 'Voulez-vous appliquer cette modification à l''ensemble des lignes affectées à ce Fournisseur ?';
    GestionModif(Question,'CODEFOURNISSEUR',Codetiers.Text, StChamps, SG_FOURNISSEUR);
  end;

end;

Procedure TOF_INTEGREFICTPI.RechercheArticle;
Var StChamps  : string;
    SWhere    : string;
    Question  : string;
begin

  if CodeArticle.text <> '' then
  begin
    SoustractionQteInv(CodeArticle.text, StrtoFloat(Qte.text),TobGrille.Detail[Grille.row-1].getValue('NOLIG'));
  end;

	sWhere := ' AND ((GA_TYPEARTICLE="MAR") AND GA_TENUESTOCK="X")';

  StChamps := CodeArticle.Text;
  if stChamps = '' then Stchamps := TobGrille.Detail[Grille.row-1].getString('CODEARTICLE');

  if CodeArticle.Text <> '' then
    sWhere := 'GA_CODEARTICLE=' + Trim(Copy(CodeArticle.text, 1, 18)) + ';XX_WHERE=' + sWhere
  else
    sWhere := 'XX_WHERE=' + sWhere;

	CodeArticle.text := AGLLanceFiche('BTP', 'BTARTICLE_RECH', '', '', sWhere+';RECHERCHEARTICLE');
  CodeArticle.text := Trim(Copy(CodeArticle.text, 1, 18));

  If CodeArticle.Text <> '' then
  begin
    Question := 'Voulez-vous appliquer cette modification à l''ensemble des lignes affectées à cet Article ?';
    GestionModif(Question,'CODEARTICLE',CodeArticle.Text, StChamps,SG_ARTICLE);
  end;

end;

procedure TOf_INTEGREFICTPI.RechercheCABAffaire;
Var StChamps : String;
    Question : String;
begin

  Stchamps := Cab_Affaire.text;
  if stChamps = '' then Stchamps := TobGrille.Detail[Grille.row-1].getString('CAB_AFFAIRE');

  CAB_Affaire.Text := AGLLanceFiche('BTP', 'BTCODEBARRE_MUL', '', '', '');

  If CAB_Affaire.Text <> '' then
  begin
    Question := 'Voulez-vous appliquer cette modification à l''ensemble des lignes affectées à cette affaire ?';
    GestionModif(Question,'CODEAFFAIRE',CAB_Affaire.text,StChamps,SG_AFFAIRE);
  end;

end;

procedure TOf_INTEGREFICTPI.RechercheCABFournisseur;
begin

end;

procedure TOf_INTEGREFICTPI.RechercheCABArticle;
begin

end;

procedure TOF_INTEGREFICTPI.GestionAnomalie;
Var TOBL : TOB;
begin

  LibErreur := '';
  LibErreur := GenerationMsgAnomalie(TOBGrille.Detail[Grille.row-1]);
  //
  if LibErreur <> '' then
  begin
    //vérification si la Ligne TobAnomalie existait
    TOBL := TobAnomalie.FindFirst(['NOLIG'], [TOBGrille.Detail[Grille.row-1].GetValue('NOLIG')], false);
    if TOBL = nil then
    begin
      TOBL := TOB.Create('Ligne Anomalie', TOBAnomalie,-1);
      TOBL.Dupliquer(TobGrille.Detail[Grille.row-1], True, true);
      TOBL.PutValue('TYPEERREUR', LibErreur);
    end
    else
    begin
      TOBL.PutValue('TYPEERREUR' , LibErreur);
    end;
  end
  else
  begin
    //vérification si la Ligne TobAnomalie existait
    TOBL := TobAnomalie.FindFirst(['NOLIG'], [TOBGrille.Detail[Grille.row-1].GetValue('NOLIG')], false);
    if TOBL <> nil then
    begin
      FreeAndNil(TOBL);
    end;
  end;

end;

Procedure TOF_INTEGREFICTPI.BTGenerationOnClick(Sender: TObject);
Var Indice    : Integer;
    TOBL      : TOB;
    TobTempo  : TOB;

    SCodeFrs  : String; //Ancien Code
    CodeFrs   : String; //Nouveau Code

    STypeMvt  : String;
    TypeMvt   : String;

    SCodeAff  : String;
    CodeAff   : String;

    SDateMvt  : TDateTime;
    DateMvt   : TDateTime;

    SNumCde   : String;
    NumCde    : String;

    LigToDel  : Integer;
begin

  BGeneration.enabled := False;
  //
  if TobAnomalie.detail.count <> 0 then
  begin
    if PGIAsk('Attention, La liste de vos anomalies d''intégration n''est pas vide... voulez-vous tout de même continuer ?', 'Anomalies')= MrNo then
    begin
      //On se positionne sur les bonnes pages et les bons onglets
      Pages.ActivePage      := PGeneralite;
      PageGrille.ActivePage := PAnomalies;
      Grille1.Row := 1;
      //
      BGeneration.enabled := True;
      exit;
    end;
  end;

  //
  if not ArchivageFichierTPI then
  begin
    PGIError('Une erreur c''est produit lors de l''archivage de ' + fichierImport.text + ' en ' + FichierHisto, 'Erreur d''archivage');
    //On se positionne sur les bonnes pages et les bons onglets
    Pages.ActivePage      := PGeneralite;
    PageGrille.ActivePage := PAnomalies;
    //
    AffichageGrilleAnomalie(TobAnomalie);
    //
    Grille1.Row := 1;
    //
    BGeneration.enabled := True;
    //
    Exit;
  end;

  //après Archivage on supprime le fichier import
  if not SysUtils.DeleteFile(fichierImport.text) then PGIError('Une erreur s''est produite lors de la suppression de ' +  fichierImport.text, 'Suppresison');

  //On retri la table grille on réindexe cette dernière et on gère les anomalies restantes
  TriTableGrille;

  LigToDel  := 1;
  TOBTempo := Tob.Create('TEMPO',nil,-1);
  TobTempo.Dupliquer(TobGrille,true, true);

  //génération de la tob pour génération des documents en fonction des lignes lues
  For indice := 0 to TobTempo.detail.count -1 do
  begin
    TOBL      := TOBTempo.detail[indice];
    //
    TypeMvt  := TOBL.GetString('TYPEMVT');
    CodeFrs  := TOBL.GetString('CODEFOURNISSEUR');
    CodeAff  := TOBL.GetString('CODEAFFAIRE');
    DateMvt  := StrToDate(TOBL.GetString('DATEMVT'));
    NumCde   := TOBL.GetString('NUMCDE');
    //
    if not GestionRejet(TOBL) then
    Begin
      STypeMvt  := TOBL.GetString('TYPEMVT');
      SCodeFrs  := TOBL.GetString('CODEFOURNISSEUR');
      SCodeAff  := TOBL.GetString('CODEAFFAIRE');
      SDateMvt  := StrToDate(TOBL.GetString('DATEMVT'));
      SNumCde   := TOBL.GetString('NUMCDE');

      LigToDel  := LigToDel + 1;
      continue;
    end;
    //
    //Rupture sur piéce en fonction du type de mouvement, du fournisseur et de l'affaire....
    //
    if StypeMvt <> TypeMvt then
    begin
      GestionRuptureTypeMvt(TOBL, STypeMvt, LigToDel);
      STypeMvt  := TOBL.GetString('TYPEMVT');
      SCodeFrs  := TOBL.GetString('CODEFOURNISSEUR');
      SCodeAff  := TOBL.GetString('CODEAFFAIRE');
      SDateMvt  := StrToDate(TOBL.GetString('DATEMVT'));
      SNumCde   := TOBL.GetString('NUMCDE');

      if TypeMvt = 'IN' then Continue;
    end
    else
    begin
      if TypeMvt = 'IN' then //Si on est sur un inventaire il faut le créer quelque soit la rupture...
      begin
        if not GenerationDeLaPiece(TOBL, TypeMvt) then
           LigToDel := LigToDel + 1
        else
        begin
          Grille.DeleteRow(LigToDel);
        end;
        //
        if LigToDel < TobGrille.Detail.count -1 then TOBGrille.Detail[LigToDel].Free;
        Continue;
      end
      else if (TypeMvt='ED') Or (TypeMvt = 'SD') Or (TypeMvt = 'SA') Or (TypeMvt = 'EA') OR (TypeMvt = 'CD') OR (TypeMvt = 'BL') then //Si on est sur une Sortie ou entrée Exceptionnelle il faut gérer la rupture sur la date de pièce
      begin
        if SNumCde <> NumCde then
        begin
          if SCodeFrs <> CodeFrs   then
          begin
            GestionRuptureFournisseur(TOBL, SCodeFrs);
            SCodeFrs  := TOBL.GetString('CODEFOURNISSEUR');
            SNumCde   := TOBL.GetString('NUMCDE');
          end
          else
          begin
            GestionRuptureNumCde(TOBL, SNumCde);
            SNumCde := TOBL.GetString('NUMCDE');
          end;
        end
        else if DateMvt <> SDateMvt then
        begin
           GestionRuptureDate(TOBL, SDateMvt);
           SDateMvt  := StrToDate(TOBL.GetString('DATEMVT'));
        end
        else if SCodeFrs <> CodeFrs   then
        begin
          GestionRuptureFournisseur(TOBL, SCodeFrs);
          SCodeFrs  := TOBL.GetString('CODEFOURNISSEUR');
        end
        else
        begin
          If SCodeAff <> Codeaff then
          begin
            GestionRuptureChantier(TOBL, SCodeAff);
            SCodeAff  := TOBL.GetString('CODEAFFAIRE');
          end;
        end;
      end
      else
      begin
        if SCodeFrs <> CodeFrs   then
        begin
          GestionRuptureFournisseur(TOBL, SCodeFrs);
          SCodeFrs  := TOBL.GetString('CODEFOURNISSEUR');
        end
        else
        begin
          If SCodeAff <> Codeaff then
          begin
            GestionRuptureChantier(TOBL, SCodeAff);
            SCodeAff  := TOBL.GetString('CODEAFFAIRE');
          end;
        end;
      end;
    end;

    //création des lignes qui vont bien....
    TobLigne := TOB.Create('LES LIGNES', TOBPiece,-1);

    //Création des champs de la tob ligne de piece
    CreateLigne(TobLigne);

    //Chargement des champs de la tob ligne de piece
    ChargeTobLigne(STypeMVT, TOBL, TOBLigne);
    //
    //Chargement de la tob de validation de la ligne
    GestionValide(TOBL);
    //
    STypeMvt := TOBL.GetString('TYPEMVT');
    SCodeFrs := TOBL.GetString('CODEFOURNISSEUR');
    SCodeAff := TOBL.GetString('CODEAFFAIRE');
    SDateMvt := StrToDate(TOBL.GetString('DATEMVT'));
    SNumCde  := TOBL.GetString('NUMCDE');
    //
    Grille.DeleteRow(LigToDel);
    if LigToDel < TobGrille.Detail.count -1 then TOBGrille.Detail[LigToDel].Free;
    //
  end;

  FreeAndNil(TobTempo);

  if TobPiece.detail.count <> 0 then CreatePieceFromTob(TOBPiece, nil, nil);
  //
  ReinitialiseTobPiece;
  //
  //edition des lignes rejetées
  EditeRejete;

  EditeValide;
  //
  if TobRejete.detail.count <> 0 then
  begin
    Grille.row := 1;
    //
    Tobanomalie.ClearDetail;
    TobGrille.ClearDetail;
    //
    TobGrille.Dupliquer(Tobrejete,true, true);
    //
    GestionGS.TOBG  := TOBGrille;
    GestionGS.GS    := Grille;
    //
    ChargementGrille(GestionGS);
    //
    For indice := 0 to TobGrille.detail.count -1 do
    begin
      Grille.Row := Indice+1;
      TobGrille.detail[Indice].putValue('NOLIG', Grille.Row);
      GestionAnomalie;
    end;
    //
    AffichageGrilleAnomalie(TobAnomalie);
    //
    Grille.row := 1;
    //
    TobRejete.ClearDetail;
    TobValide.ClearDetail;
    //
    PGIBox('Traitement terminé avec des erreurs', 'Intégration fichier : ' + FichierImport.text);
    Pages.enabled := False;
  end
  else
  Begin
    PGIBox('Traitement terminé sans erreur', 'Intégration fichier : ' + FichierImport.text);
    Pages.enabled := False;
  end;

end;

Procedure TOF_INTEGREFICTPI.CreateLigne(TobLigne : TOB);
begin

  TobLigne.AddChampSupValeur('TYPELIGNE',   '');
  TobLigne.AddChampSupValeur('AFFAIRE',     '');
  TobLigne.AddChampSupValeur('CODEARTICLE', '');
  TobLigne.AddChampSupValeur('ARTICLE',     '');
  TobLigne.AddChampSupValeur('LIBELLE',     '');
  TobLigne.AddChampSupValeur('QTEFACT',      0);
  TobLigne.AddChampSupValeur('QUALIFQTE',   '');
  TobLigne.AddChampSupValeur('PUHTDEV',     '');
  TobLigne.AddChampSupValeur('PAHT',         0);
  TobLigne.AddChampSupValeur('DPA',          0);
  TobLigne.AddChampSupValeur('PMAP',         0);
  TobLigne.AddChampSupValeur('DATELIVRAISON', idate1900);
  TobLigne.AddChampSupValeur('DEPOT',       '');
  TobLigne.AddChampSupValeur('PIECEPRECEDENTE', '');
  TobLigne.AddChampSupValeur('PIECEORIGINE', '');

end;

Procedure TOF_INTEGREFICTPI.ChargeTobLigne(STypeMVT : String; TOBL, TOBLigne : TOB);
Var DateLiv   : String;
    Qte       : Double;
    Pa        : Double;
begin

  TobLigne.PutValue('TYPELIGNE',   'ART');
  TobLigne.PutValue('AFFAIRE',     TOBL.GetString('CODEAFFAIRE'));
  TobLigne.PutValue('CODEARTICLE', TOBL.GetString('CODEARTICLE'));
  TobLigne.PutValue('ARTICLE',     TOBL.GetString('GA_ARTICLE'));
  TobLigne.PutValue('LIBELLE',     TOBL.GetString('LIB_ARTICLE'));

  Qte := TOBL.GetDouble('QTE');
  Pa  := TOBL.GetDouble('PAHT');

  if STypeMvt = 'EA' then
  Begin
    if QTE > 0 then Qte := Qte * -1;
  end
  else if STypeMvt = 'SA' then
  Begin
    if Qte < 0 then Qte := Qte * -1;
  end;

  TobLigne.PutValue('QTEFACT',     Qte);
  TobLigne.PutValue('QUALIFQTE',   TOBL.GetString('QUALIFUNITEACH'));
  TobLigne.PutValue('PUHTDEV',     TOBL.GetDouble('PAUA'));
  TobLigne.PutValue('PAHT',        TOBL.GetDouble('PAHT'));
  TobLigne.PutValue('DPA',         TOBL.GetDouble('DPA'));
  TobLigne.PutValue('PMAP',        TOBL.GetDouble('PMAP'));
  TobLigne.PutValue('DATELIVRAISON', idate1900);

  if STypeMVT = 'CD' then
  begin
    DateLiv := DateToStr(Now);
    TobLigne.PutValue('DATELIVRAISON',DateLiv);
  end
  else if StypeMVT = 'BL' then
  begin
    RecupLignePiecePrecedente(TOBL, TobLigne);
  end;

  if Depot.text = '' then
    TobLigne.PutValue('DEPOT', GetParamSocSecur('SO_GCDEPOTDEFAUT', '', False))
  else
    TobLigne.PutValue('DEPOT', Depot.text);

end;

Procedure TOF_INTEGREFICTPI.RecupLignePiecePrecedente(TOBL, TobLigne : TOB);
VAR TOBLignePiece : TOB;
begin

  StSQL := 'SELECT GL_NATUREPIECEG, GL_SOUCHE, GL_NUMERO, GL_INDICEG, GL_AFFAIRE, ';
  StSQL := STSQL + ' GL_NUMORDRE, GL_PIECEORIGINE, GL_DATEPIECE, GL_IDENTIFIANTWOL FROM LIGNE';
  StSQL := StSQL + ' WHERE GL_NATUREPIECEG="CF" AND GL_NUMERO=' + InttoStr(TOBL.GetValue('NUMCDE'));
  StSQL := StSQL + '   AND GL_ARTICLE="' + TOBL.GetString('GA_ARTICLE') + '"';

  QQ := OpenSQL(STSQL, False,1,'',True);

  if Not QQ.eof then
  begin
    TOBLignePiece := Tob.Create('LIGNE',nil,-1);
    TOBLignePiece.selectDB('LIGNE', QQ);
    TOBLigne.PutValue('PIECEPRECEDENTE', EncodeRefPiece(TOBLignePiece));
    TOBLigne.PutValue('PIECEORIGINE',    EncodeRefPiece(TOBLignePiece));
    if TOBLigne.GetString('GL_AFFAIRE') <> '' then
    begin
      IF TOBLIGNE.GetValue('GL_IDENTIFIANTWOL') = 1 then
      begin
        StSQL := 'UPDATE LIGNE SET GL_IDENTIFIANTWOL=0 ';
        StSQL := StSQL + ' WHERE GL_NATUREPIECEG="CF" AND GL_NUMERO=' + InttoStr(TOBL.GetValue('NUMCDE'));
        StSQL := StSQL + '   AND GL_ARTICLE="' + TOBL.GetString('GA_ARTICLE') + '"';
      end;
    end;
    TOBLignePiece.free;
  end;

  Ferme(QQ);

end;


Procedure TOF_INTEGREFICTPI.GestionRuptureTypeMvt(TOBL : TOB; AncienTypeMvt: String; Var LigToDel : Integer);
begin

  if (AncienTypeMvt <> '') then CreatePieceFromTob(TOBPiece, nil, nil);

  ReinitialiseTobPiece;

  if TOBL.GetString('TYPEMVT') = 'IN' then
  begin
    if not GenerationDeLaPiece(TOBL,  TOBL.GetString('TYPEMVT')) then
       LigToDel := LigToDel + 1
    else
    Begin
      Grille.DeleteRow(LigToDel);
    end;
    if LigToDel < TobGrille.Detail.count -1 then TOBGrille.Detail[LigToDel].Free;
  end
  else
  begin
    if Not GenerationDeLaPiece(TOBL,  TOBL.GetString('TYPEMVT')) then Exit;
  end;

end;

Procedure TOF_INTEGREFICTPI.GestionRuptureFournisseur(TOBL : TOB; AncienFrs : String);
begin

  If AncienFrs <> ''     then CreatePieceFromTob(TOBPiece, nil, nil);

  ReinitialiseTobPiece;

  if Not GenerationDeLaPiece(TOBL, TOBL.GetString('TYPEMVT')) then Exit;

end;

Procedure TOF_INTEGREFICTPI.GestionRuptureChantier(TOBL : TOB; AncienAff : String);
begin

  If AncienAff <> ''     then CreatePieceFromTob(TOBPiece, nil, nil);

  ReinitialiseTobPiece;

  if Not GenerationDeLaPiece(TOBL, TOBL.GetString('TYPEMVT')) then Exit;

end;


Procedure TOF_INTEGREFICTPI.GestionRuptureDate(TOBL : TOB; AncienDateMvt : TDateTime);
begin

  If AncienDateMvt <> idate1900 then CreatePieceFromTob(TOBPiece, nil, nil);

  ReinitialiseTobPiece;

  if Not GenerationDeLaPiece(TOBL, TOBL.GetString('TYPEMVT')) then Exit;

end;

Procedure TOF_INTEGREFICTPI.GestionRuptureNumCde(TOBL : TOB; AncienNumero : String);
begin

  If AncienNumero <> '' then
  begin
    // Création TOB pour ligne de pièce
    TobLigne := Tob.Create ('LES LIGNES', TobPiece, -1);
    CreateLigne(TobLigne);
    ChargeLigneCommentaire('BL', TOBLIGNE, TOBL);
  end;

end;


Procedure TOF_INTEGREFICTPI.TriTableGrille;
Var Indice : Integer;
begin

  TobGrille.Detail.Sort('TYPEMVT;DEPOT;CODEFOURNISSEUR;CODEAFFAIRE;NUMCDE');

  Grille.row := 1;

  Tobanomalie.ClearDetail;
  //
  GestionGS.TOBG  := TOBGrille;
  GestionGS.GS    := Grille;
  //
  ChargementGrille(GestionGS);
  //
  For indice := 0 to TobGrille.detail.count -1 do
  begin
    Grille.Row := Indice+1;
    TobGrille.detail[Indice].putValue('NOLIG', Grille.Row);
    GestionAnomalie;
  end;
  //
  AffichageGrilleAnomalie(TobAnomalie);
  //
  Grille.row := 1;
  //
end;

Procedure TOF_INTEGREFICTPI.ReinitialiseTobPiece;
begin

  TobPiece.ClearDetail;

  TOBPiece.InitValeurs;

end;

Function TOF_INTEGREFICTPI.GenerationDeLaPiece(TOBL : TOB; TypeMvt : String) : Boolean;
Begin

  Result := true;

  If      TypeMvt = 'IN' then       ///gestion des inventaires
  begin
    Result := MAJInventaire(TOBL);
    exit;
  end
  Else If TypeMvt = 'SA' then      ///Affectation Livraison sur chantier (LBT)
    CreateEnteteDoc('LBT', TOBL)
  Else If TypeMvt = 'EA' then      ///Affectation Retour chantier (BFC)
    CreateEnteteDoc('BFC', TOBL)
  Else If TypeMvt = 'SD' then      ///Affectation Sorties Exceptionnelles (SEX)
  begin
    CreateEnteteDoc('SEX', TOBL);
    Exit;
  end
  Else If TypeMvt = 'ED' then      ///Affectation Entrées Exceptionnelles (EEX)
  Begin
    CreateEnteteDoc('EEX', TOBL);
    Exit;
  end
  Else If TypeMvt = 'CD' then      ///Affectation Commandes Fournisseurs (CF)
    CreateEnteteDoc('CF',  TOBL)
  Else If TypeMvt = 'BT' then      ///Affectation Livraison sur Chantier (???)
    CreateEnteteDoc('LBT', TOBL)
  Else If TypeMvt = 'BL' then      ///Affectation Réception fournisseur
    CreateEnteteDoc('BLF', TOBL);

  // Création TOB pour ligne de pièce
  TobLigne := Tob.Create ('LES LIGNES', TobPiece, -1);

  CreateLigne(TobLigne);

  ChargeLigneCommentaire(TypeMvt, TOBLIGNE, TOBL);

end;

procedure TOF_INTEGREFICTPI.ChargeLigneCommentaire(TypeMvt : String; TOBLIGNE, TOBL : TOB);
Var Refp : String;
begin

  TobLigne.PutValue('TYPELIGNE',   'COM');
  TobLigne.PutValue('CODEARTICLE', '');
  TobLigne.PutValue('ARTICLE',     '');

  if TypeMvt = 'BL' then
    RefP := RechDom('GCNATUREPIECEG', TOBL.GetValue('NATPIECEPREC'),False)
  else
    RefP := RechDom('GCNATUREPIECEG', TOBPiece.GetString('NATUREPIECEG'),False);
  RefP := RefP + ' N° ' + TOBL.GetString('NUMCDE');
  RefP := RefP + ' du ' + DateToStr(TOBPiece.GetValue('DATEPIECE'));
  RefP := RefP + ' '    + TOBPiece.GetString('REFINTERNE');
  //
  RefP:=Copy(RefP,1,70) ;
  //
  TobLigne.PutValue('LIBELLE', RefP);
  //
  TobLigne.PutValue('QTEFACT',      0.00);
  TobLigne.PutValue('QUALIFQTE',   '');
  TobLigne.PutValue('PUHTDEV',      0.00);
  TobLigne.PutValue('PAHT',         0.00);
  TobLigne.PutValue('DPA',          0.00);
  TobLigne.PutValue('PMAP',         0.00);
  TobLigne.PutValue('DATELIVRAISON',idate1900);
  //
  if Depot.text = '' then
    TobLigne.PutValue('DEPOT', GetParamSocSecur('SO_GCDEPOTDEFAUT', '', False))
  else
    TobLigne.PutValue('DEPOT', Depot.text);

end;

Function TOF_INTEGREFICTPI.MAJInventaire(TOBL : TOB) : Boolean;
Var TOBLInvArt : TOB;
    TOBLInv    : TOB;
begin

  Result := false;

  //on recherche les lignes d'inventaire correspondant à l'article
  TobLInvArt := TobInventaire.FindFirst(['CODEARTICLE'],[TOBL.GetString('CODEARTICLE')],False);
  If TOBLInvArt = nil then
    MajTobRejet(TOBL,'INV', 'Aucune liste d''inventaire pour ' + TOBL.GetString('CODEARTICLE'))
  else
  begin
    //On Recherche la lignes correspondantes à l'Article/dépôt
    TobLInv := TOBLInvArt.findFirst(['GIL_CODEARTICLE','GIL_DEPOT'],[TOBL.GetString('CODEARTICLE'),TOBL.GetString('DEPOT')],False);
    if TobLInv <> nil then
    begin
      if TOBLinv.getValue('GIE_VALIDATION')='X' then
      begin
        MajTobRejet(TOBL,'INV', 'Liste d''inventaire déjà validée : ' + TOBLinv.GetString('GIE_CODELISTE'));
      end
      else if TOBLinv.getValue('GIL_SAISIINV')='X' then
        MajTobRejet(TOBL,'INV', 'Article déjà inventorié : ' + TOBLinv.GetString('GIL_CODEARTICLE'))
      else
      begin
        Result := True;
        MAJLigneInventaire(TOBLInv, TOBL);
      end;
      FreeAndNil(ToblInv);
    end
    else
      MajTobRejet(TOBL,'INV', 'Aucune liste d''inventaire sur ce dépôt ' + TOBL.GetString('CODEDEPOT'));
  end;

end;

procedure TOF_INTEGREFICTPI.AffichageGrilleInventaire;
var GestionG2 : TGestionGS;
    TOBLInv   : TOB;
begin

  //On Recherche si par hasard l'article possède une Liste Inventaire
  TobLInv := TobInventaire.FindFirst(['CODEARTICLE','CODEDEPOT'],[TOBGrille.Detail[Grille.row+1].GetString('CODEARTICLE'),TOBGrille.Detail[Grille.row+1].GetString('DEPOT')],True);

  //Si Oui...
  if TOBLInv <> nil then
  begin
    //chargement de la grille avec les éléments de la TOB
    GestionG2.fColNamesGS   := fColNamesGrille1;
    GestionG2.FalignementGS := FalignementGrille1;
    GestionG2.FtitreGS      := FtitreGrille1;
    GestionG2.fLargeurGS    := fLargeurGrille1;
    GestionG2.TOBG          := TobLInv;
    GestionG2.GS            := Grille2;
    //
    DessineGrille(GestionG2);
    //
    ChargementGrille(GestionG2);
    //
    Grille2.row := 1;
  end;

end;

procedure TOF_INTEGREFICTPI.MAJLigneInventaire(TOBResult, TOBL : TOB);
Var Qte        : Double;
begin

  Qte := TOBL.Getdouble('QTE');

  StSQL := 'UPDATE LISTEINVLIG SET GIL_INVENTAIRE=' + FloatToStr(Qte);
  StSQL := StSQL + ', GIL_DATESAISIE="' + USDATETIME(StrToDateTime(TOBL.GetString('DATEMVT'))) + '" ';
  StSQL := StSQL + ', GIL_SAISIINV="X" ';
  //if TOBL.GetString('CODEFOURNISSEUR') <> '' then
  //  StSQL := StSQL + ', GIL_FOURNISSEUR="'    + TOBL.GetString('CODEFOURNISSEUR') + '" ';
  StSQL := StSQL + '  WHERE GIL_CODELISTE="'  + TOBResult.GetString('GIE_CODELISTE') + '" ';
  StSQL := STSQL + '    AND GIL_DEPOT="'      + TOBL.GetString('DEPOT') + '" ';
  StSQL := StSQL + '    AND GIL_CODEARTICLE="'+ TOBL.GetString('CODEARTICLE') + '"';

  If ExecuteSQL(StSQL) = 0 then
  begin
    PgiError('La mise à jour de l''inventaire a échouée !','Mise à jour Inventaire');
    MajTobRejet(TOBL, 'INV', 'La mise à jour de l''inventaire a échouée');
  end
  else GestionValide(TOBL);

end;

Procedure TOF_INTEGREFICTPI.CreateEnteteDoc(Nature : String; TOBL : TOB);
Var DateMouv : TDateTime;
begin

  DateMouv := StrToDate(TOBL.GetValue('DATEMVT'));

  TobPiece.PutValue ('ETABLISSEMENT',TOBL.GetString('Etablissement'));
  TobPiece.PutValue ('DOMAINE',      TOBL.GetString('Domaine'));
  TobPiece.PutValue ('DATEPIECE',    DateMouv);
  TobPiece.PutValue ('REFINTERNE',   TOBL.GetString('REFINTERNE'));
  TobPiece.PutValue ('CREEPAR',      'TPI');
  TobPiece.PutValue ('ORIGINE',      'CODEBARRE');
  TobPiece.PutValue ('REFEXTERNE',   '');

  TobPiece.PutValue ('NATUREPIECEG', Nature);

  IF (TOBL.GetString('TYPEMVT') = 'SA') OR (TOBL.GetString('TYPEMVT') = 'EA') OR (TOBL.GetString('TYPEMVT') = 'BT') THEN
  begin
    TobPiece.PutValue ('AFFAIRE',    TOBL.GetString('CODEAFFAIRE'));
    TobPiece.PutValue ('TIERS',      TOBL.GetString('CLIENT'));
  end
  else IF (TOBL.GetString('TYPEMVT') = 'CD') then
  begin
    TobPiece.PutValue ('AFFAIRE',    TOBL.GetString('CODEAFFAIRE'));
    TobPiece.PutValue ('TIERS',      TOBL.GetString('CODEFOURNISSEUR'));
  end
  else IF (TOBL.GetString('TYPEMVT') = 'BL') then
  Begin
    TobPiece.PutValue ('AFFAIRE',    TOBL.GetString('CODEAFFAIRE'));
    TobPiece.PutValue ('TIERS',      TOBL.GetString('CODEFOURNISSEUR'));
    TobPiece.PutValue ('REFEXTERNE', 'Bon Livraison N°' + TOBL.GetString('NUMBL'));
  end
  else
  begin
    TobPiece.PutValue ('AFFAIRE',    '');
    TobPiece.PutValue ('TIERS',      '');
  end;

end;

Procedure TOF_INTEGREFICTPI.CreateTOBPiece;
begin

  TobPiece.AddChampSupValeur ('NATUREPIECEG', '');
  TobPiece.AddChampSupValeur ('AFFAIRE',      '');
  TobPiece.AddChampSupValeur ('TIERS',        '');
  TobPiece.AddChampSupValeur ('ETABLISSEMENT','');
  TobPiece.AddChampSupValeur ('DOMAINE',      '');
  TobPiece.AddChampSupValeur ('DATEPIECE',    '');
  TobPiece.AddChampSupValeur ('REFINTERNE',   '');
  TobPiece.AddChampSupValeur ('REFEXTERNE',   '');
  TobPiece.AddChampSupValeur ('CREEPAR',      'TPI');

  TobPiece.AddChampSupValeur ('ORIGINE',      'CODEBARRE');

end;

{***********A.G.L.***********************************************
Auteur  ...... : FV1
Créé le ...... : 26/03/2015
Modifié le ... : 26/03/2015
Description .. : Gestion des rejets et des validations
Mots clefs ... : ETAT;REJET;VALIDATION
*****************************************************************}

Function TOF_INTEGREFICTPI.GestionRejet(TOBL : TOB) : Boolean;
Var Motif       : String;
    TypeMvt     : string;
    TypeErr     : string;
begin

  Result := True;
  Motif  := '';
  TypeErr := '';
  TypeMvt := Tobl.GetString('TYPEMVT');

  If TypeMvt = '' then
  begin
    TypeErr := 'GEN';
    if Motif = '' then Motif := 'Erreur :';
    Motif   := Motif + ' Type de Mouvement inconnu : + ' + TypeMvt;
  end;

  If TOBL.GetString('ANOMALIE') = 'DEPOT' then
  begin
    TypeErr := 'DEP';
    if Motif = '' then Motif := 'Erreur :';
    Motif := Motif + ' Code Dépôt inexistant';
  end;

  If TOBL.GetString('CODEARTICLE') = '' then
  begin
    TypeErr := 'ART';
    if Motif = '' then Motif := 'Erreur :';
    Motif := Motif + ' Code Article non renseigné';
  end;

  If (TypeMvt = 'CD') AND (TOBL.GetString('CODEFOURNISSEUR') = '') then //commande Fournisseur
  begin
    TypeErr := 'FRS';
    if Motif = '' then Motif := 'Erreur :';
    Motif := Motif + ' Code fournisseur à blanc sur Commande fournisseur';
  end;

  If ((TypeMvt = 'SA') OR (TypeMvt = 'EA')) AND (TOBL.GetString('CODEAFFAIRE') = '') then
  begin
    TypeErr := 'AFF';
    if Motif = '' then Motif := 'Erreur :';
    Motif := Motif + ' Le Code Affaire n''est pas renseigné';
  end;

  If (TOBL.GetString('LIB_ARTICLE') = '...') then
  begin
    TypeErr := 'ART';
    if Motif = '' then Motif := 'Erreur :';
    Motif := Motif + ' L''Article est inexistant';
  end;

  If (TOBL.GetString('ANOMALIECLI') = 'X') then
  begin
    TypeErr := 'CLI';
    if Motif = '' then Motif := 'Erreur :';
    Motif := Motif + TOBL.GetString('LIBANOMALIECLI');
  end;

  If  (TOBL.GetString('ANOMALIEMAR') = 'X') Or
      (TOBL.GetString('ANOMALIEMAR') = 'F') Or
      (TOBL.GetString('ANOMALIEMAR') = 'S') then
  begin
    TypeErr := 'ART';
    if Motif = '' then Motif := 'Erreur :';
    Motif := Motif + TOBL.GetString('LIBANOMALIEMAR');
  end;

  If (TOBL.GetString('ANOMALIEFRS') = 'X') then
  begin
    TypeErr := 'FRS';
    if Motif = '' then Motif := 'Erreur :';
    Motif := Motif + TOBL.GetString('LIBANOMALIEFRS');
  end;

  If (TOBL.GetString('ANOMALIEAFF') = 'X') then
  begin
    TypeErr := 'AFF';
    if Motif = '' then Motif := 'Erreur :';
    Motif := Motif + TOBL.GetString('LIBANOMALIEAFF');
  end;

  if TOBL.GetString('GA_FERME') = 'X' then
  begin
    TypeErr := 'ART';
    if Motif = '' then Motif := 'Erreur :';
    Motif := Motif + ' Article ' + TOBL.GetString('CODEARTICLE') + ' Fermé';
  end;

  if TOBL.GetString('AFF_FERME') = 'X' then
  begin
    TypeErr := 'AFF';
    if Motif = '' then Motif := 'Erreur :';
    Motif := Motif + ' L''affaire ' + TOBL.GetString('CODEAFFAIRE')  + ' est fermée';
  end;

  if TOBL.GetString('FRS_FERME') = 'X' then
  begin
    TypeErr := 'FRS';
    if Motif = '' then Motif := 'Erreur :';
    Motif := Motif + ' Le fournisseur ' + TOBL.GetString('CODEFOURNISSEUR') + ' est fermé';
  end;

  if (TOBL.GetString('TENUESTOCK') = '-') then
  begin
    TypeErr := 'ART';
    if Motif = '' then Motif := 'Erreur :';
    Motif := Motif + ' Article ' +  TOBL.GetString('CODEARTICLE') + ' non tenu en Stock';
  end;

  if Motif <> '' then
  begin
    MajTobRejet(TOBL, TypeErr, Motif);
    Result := False;
  end;

end;

Procedure TOF_INTEGREFICTPI.MajTobRejet(TOBL : TOB;TypeErr, Motif : String);
Var  TobLRejete  : TOB;
begin

    TObLRejete := TOB.Create('REJET', TOBRejete,-1);
    TObLRejete.Dupliquer(TOBL, True, true);
    TobLRejete.PutValue('TYPEERREUR', TypeErr);
    TobLRejete.AddChampSupValeur('MOTIF', Motif);

end;

Procedure TOF_INTEGREFICTPI.GestionValide(TOBL : TOB);
Var TobLValide  : TOB;
begin

  TObLValide := TOB.Create('VALIDE', TobValide,-1);
  TObLValide.Dupliquer(TOBL, True, true);

end;


procedure TOF_INTEGREFICTPI.ChargeEtatRejete;
begin
  TheType   := 'E';
  TheNature := 'BCB';
  TheModele := 'BCR';
  TheTitre  := 'Edition des lignes Rejetées';

  OptionEdition := TOptionEdition.Create(TheType, TheNature, TheModele, TheTitre, '', ChkApercu.Checked, ChkReduire.Checked, True, False, False, Pages, fEtat);

  OptionEdition.first := True;
  OptionEdition.ChargeListeEtat(fEtat,Idef);

  if fetat.itemindex  >= 0 then TheModele := FETAT.values[fetat.itemindex];

end;

procedure TOF_INTEGREFICTPI.ChargeEtatValide;
begin

  TheType1   := 'E';
  TheNature1 := 'BCB';
  TheModele1 := 'BCV';
  TheTitre1  := 'Edition des Lignes Validées';

  OptionEdition1 := TOptionEdition.Create(TheType1, TheNature1, TheModele1, TheTitre1, '', ChkApercu.Checked, ChkReduire.Checked, True, False, False, Pages, FETAT1);

  OptionEdition1.first := True;
  OptionEdition1.ChargeListeEtat(fEtat1,Idef);

  if fetat1.itemindex  >= 0 then TheModele1 := FETAT1.values[fetat1.itemindex];

end;

procedure TOF_INTEGREFICTPI.ParamEtat(Sender : TOBJect);
begin

  OptionEdition.Appel_Generateur

end;
procedure TOF_INTEGREFICTPI.ParamEtat1(Sender : TOBJect);
begin

  OptionEdition1.Appel_Generateur

end;

procedure TOF_INTEGREFICTPI.OnClickApercu(Sender : Tobject);
begin
  OptionEdition.Apercu  := ChkApercu.checked;
  OptionEdition1.Apercu := ChkApercu.checked;
end;

procedure TOF_INTEGREFICTPI.OnClickReduire(Sender : Tobject);
begin
  OptionEdition.DeuxPages  := ChkReduire.checked;
  OptionEdition1.DeuxPages := ChkReduire.checked;
end;

Procedure TOF_INTEGREFICTPI.OnChangeEtat(Sender : Tobject);
Begin

   OptionEdition.Modele := FETAT.values[fetat.itemindex];

   TheModele := OptionEdition.Modele;

end;

Procedure TOF_INTEGREFICTPI.OnChangeEtat1(Sender : Tobject);
Begin

   OptionEdition1.Modele := FETAT1.values[fetat1.itemindex];

   TheModele1 := OptionEdition1.Modele;

end;

procedure TOF_INTEGREFICTPI.EditeRejete;
begin

  if TobRejete.detail.count = 0 then exit;

  if TobValide.detail.count <> 0 then StartPdfBatch;

  OptionEdition.Apercu    := ChkApercu.Checked;
  OptionEdition.DeuxPages := ChkReduire.Checked;
  OptionEdition.Spages    := Pages;

  if OptionEdition.LanceImpression('', TobRejete) < 0 then V_PGI.IoError:=oeUnknown;

end;
procedure TOF_INTEGREFICTPI.EditeValide;
begin

  if TobValide.detail.count = 0 then exit;

  OptionEdition1.Apercu    := ChkApercu.Checked;
  OptionEdition1.DeuxPages := ChkReduire.Checked;
  OptionEdition1.Spages    := Pages;

  if OptionEdition1.LanceImpression('', TobValide) < 0 then V_PGI.IoError:=oeUnknown;

  if TobRejete.detail.count <> 0 then
  begin
    CancelPDFBatch ;
    PreviewPDFFile('',GetMultiPDFPath,True);
  end;

end;


function TOF_INTEGREFICTPI.ArchivagefichierTPI : Boolean;
Var FileName : string;
    FileNameH : String;
begin

  Result := False;

  FileName := FichierImport.text;

  if ControleFichierArchi then
  begin
    FileNameH := FichierHisto;
    if CopyFile(PChar(FileName), PChar(FileNameH), False) then Result := True; //on copie le fichier dans le répertoire des archives
  end;

end;

Procedure TOF_INTEGREFICTPI.SoustractionQteInv(CodeArticle : String; QteArt : Double;NoLig : Integer);
Var TobLinvArt  : TOB;
    TOBLInv     : TOB;
    QteCalc     : Double;
begin

  //Modification de la ligne d'inventaire pour l'ancien article/dépôt
  TobLInvArt   := TobInventaire.FindFirst(['CODEARTICLE','CODEDEPOT'],[CodeArticle,Depot.text],True);

  if TOBLinvArt <> nil then
  begin
    QteCalc    := TOBLinvArt.GetDouble('QTECALC');
    QteCalc    := QteCalc - QteArt;
    TOBLInvArt.PutValue('QTECALC', FloatToStr(QteCalc));
    //si la quantité Calculée est égale à zéro on supprime l'enregistrement
    If QteCalc = 0 then
      FreeAndNil(TOBLinvArt)
    else
    begin
      //Recherche par dépot
      TOBLInv   := TobLinvArt.Findfirst(['GIL_CODEARTICLE','GIL_DEPOT','NOLIG'], [CodeArticle,Depot.text,NoLig], False);
      If TOBLinv <> nil then
      begin
        QteCalc := TOBLinvArt.GetDouble('QTECALC');
        QteCalc := QteCalc - QteArt;
        TOBLInv.PutValue('QTECALC', QteCalc);
      end;
    end;
  end;

end;

Procedure TOF_INTEGREFICTPI.AdditionQteInventaire(CodeArticle : String; QteArt : Double; Nolig : Integer);
Var TobLinvArt  : TOB;
    TOBLInv     : TOB;
    QteCalc     : Double;
begin

  //Modification de la ligne d'inventaire pour l'ancien article/dépôt
  TobLInvArt  := TobInventaire.FindFirst(['CODEARTICLE'],[CodeArticle],False);

  //Ligne inventaire générale par Article
  if TOBLinvArt <> nil then
  begin
    QteCalc := TOBLinvArt.GetDouble('QTECALC');
    QteCalc := QteCalc + QteArt;
    TOBLInvArt.PutValue('QTECALC', QteCalc);
    //Recherche par dépôt
    TOBLInv   := TobLinvArt.FindFirst(['GIL_CODEARTICLE','GIL_DEPOT','NOLIG'], [CodeArticle,Depot.text,Nolig], True);
    If TOBLinv <> nil then
    begin
      QteCalc := TOBLinv.GetDouble('QTECALC');
      QteCalc := QteCalc + QteArt;
      TOBLInv.PutValue('QTECALC', QteCalc);
    end;
  end;

end;

procedure TOF_INTEGREFICTPI.GetCellCanvas(ACol, ARow: Longint; Canvas: TCanvas; AState: TGridDrawState);
var TOBL: TOB;
begin

  if ACol < Grille.FixedCols then Exit;
  if Arow < Grille.Fixedrows then Exit;

  if ((ARow <= 0) or (ARow > TOBGrille.Detail.Count)) then Exit;

  TOBL := TOBGrille.Detail[ARow - 1];

  if TOBL = nil then Exit;

  if (TOBL.GetValue('ANOMALIE') <> '') OR
     (TOBL.GetValue('ANOMALIEAFF') <> '') OR
     (TOBL.GetValue('ANOMALIEFRS') <> '') OR
     (TOBL.GetValue('ANOMALIEMAR') <> '') OR
     (TOBL.GetValue('ANOMALIECLI') <> '') then
  begin
  	Canvas.Font.Color := clRed;
  end
  else
  begin
    Canvas.Font.Color := clWindowText;
  end;

end;


procedure DessineGrille(GestionGs : TGestionGS);
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
    //Okimg           : boolean;
    //
    dec             : Integer;
    NbCols          : integer;
    indice          : Integer;
begin
  //
  //Calcul du nombre de Colonnes du Tableau en fonction des noms
  st := GestionGS.fColNamesGS;

  NbCols := 0;

  repeat
    lelement := READTOKENST (st);
    if lelement <> '' then
    begin
      inc(NbCols);
    end;
  until lelement = '';
  //
  GestionGS.GS.ColCount     := Nbcols;
  //
  st              := GestionGS.fColNamesGS;
  lesalignements  := GestionGS.FalignementGS;
  lestitres       := GestionGS.FtitreGS;
  leslargeurs     := GestionGS.FlargeurGS;

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
    GestionGS.GS.cells[Indice,0]     := leTitre;
    GestionGS.GS.ColNames [Indice]   := Nam;
    //
    //Alignement des cellules
    if copy(Alignement,1,1)='G'       then //Cadré à Gauche
      GestionGS.GS.ColAligns[indice] := taLeftJustify
    else if copy(Alignement,1,1)='D'  then  //Cadré à Droite
      GestionGS.GS.ColAligns[indice] := taRightJustify
    else if copy(Alignement,1,1)='C'  then
      GestionGS.GS.ColAligns[indice] := taCenter; //Cadré au centre

    If Nam = 'TYPEMVT'    then GestionGS.GS.ColFormats[indice]:='CB=BTTYPEMVT'
    Else If Nam = 'DEPOT' then GestionGS.GS.ColFormats[indice]:='CB=GCDEPOT';

    //Colonne visible ou non
    if OkVisu then
  		GestionGS.GS.ColWidths[indice] := StrToInt(lalargeur) * GestionGS.GS.Canvas.TextWidth('W')
    else
    	GestionGS.GS.ColWidths[indice] := -1;

    //Affichage d'une image ou du texte
    {*
    okImg := (copy(Alignement,8,1)='X');
    if (OkLib) or (okImg) then
    begin
    	Grille.ColFormats[indice] := 'CB=' + Get_Join(Nam);
      if OkImg then
      begin
      	Grille.ColDrawingModes[Indice]:= 'IMAGE';
      end;
    end;
    *}

    if (Dec<>0) or (Sep) then
    begin
    	if OkNulle then
        GestionGS.GS.ColFormats[indice] := FF+';; ;' //'#'
      else
      	GestionGS.GS.ColFormats[indice] := FF; //'#';
    end;
  end ;

end;

Procedure ChargementGrille(GestionGS : TGestionGS);
var indice : integer;
begin

  With GestionGs do
  begin
    if TOBG.Detail.count <> 0 then
      GS.RowCount := TOBG.detail.count + 1
    else
      Exit;
    //
    GS.DoubleBuffered := true;
    GS.BeginUpdate;
    //
    TRY
      GS.SynEnabled := false;
      for Indice := 0 to TOBG.detail.count -1 do
      begin
        GS.row := Indice+1;
        TOBG.PutGridDetail(GS,False,True,fColNamesGS);
      end;
    FINALLY
      GS.SynEnabled := true;
      GS.EndUpdate;
    END;
    TFVierge(Tform).HMTrad.ResizeGridColumns(GS);
  end;

end;





Initialization
  registerclasses ( [ TOF_INTEGREFICTPI ] ) ;
end.

