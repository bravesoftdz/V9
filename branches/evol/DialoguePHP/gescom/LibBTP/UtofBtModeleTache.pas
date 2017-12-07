{***********UNITE*************************************************
Auteur  ...... : AB
Créé le ...... : 18/02/2003
Modifié le ... :   /  /
Description .. : Saisie des Modèles de tâches
Mots clefs ... : TABLE : AFMODELETACHE - Fiche BTTACHEMODELE
******************************************************************}
unit UtofBtModeleTache;

interface
uses StdCtrls,
  UTOF,
  Controls,
  Classes,
  HTB97,
{$IFNDEF EAGLCLIENT}
  db,
{$IFNDEF DBXPRESS}
  dbtables {BDE},
{$ELSE}
  uDbxDataSet,
{$ENDIF}
  Fiche,
  FE_Main,
{$ELSE}
  eFiche,
  MaineAGL,
{$ENDIF}
  forms,
  sysutils,
  ComCtrls,
  HCtrls,
  HEnt1,
  HMsgBox,
  UTOM,
  UTob,
  UtilConfid,
  UtilGC,
  AfUtilArticle,
  UtilTaches,
  UtilRessource,
  paramsoc,
  Vierge,
  AGLInitGC,
  Dicobtp;

type
  TOF_BTMODELETACHE = class (TOF)
    procedure OnNew                   ; override;
    procedure OnDelete                ; override;
    procedure OnUpdate                ; override;
    procedure OnLoad                  ; override;
    procedure OnArgument(StArgument: string); override;
    procedure OnClose                 ; override;

  private

    fAction   : TActionFiche;
    fStatut   : TActionFiche; // statut interne de la fiche (pour enregistrement)

    fTobModele  : Tob;
    TobTacheJour: TOB;

    DateDebPeriode : THEdit;
    DateFinPeriode : THEdit;

    CodeModele  : String;

    fStLibelleParDefaut : string;

    fRB_MODEGENE1       : TRadioButton;
    fRB_MODEGENE2       : TRadioButton;
    fRB_QUOTIDIENNE     : TRadioButton;
    fRB_NBINTERVENTION  : TRadioButton;
    fRB_HEBDOMADAIRE    : TRadioButton;
    fRB_ANNUELLE        : TRadioButton;
    fRB_MENSUELLE       : TRadioButton;
    fRB_MOISMETHODE1    : TRadioButton;
    fRB_MOISMETHODE2    : TRadioButton;
    fRB_MOISMETHODE3    : TRadioButton;

    fPC_FREQUENCE       : TPageControl;

    fTS_QUOTIDIENNE     : TTAbSheet;
    fTS_NBINTERVENTION  : TTAbSheet;
    fTS_HEBDOMADAIRE    : TTAbSheet;
    fTS_ANNUELLE        : TTAbSheet;
    fTS_MENSUELLE       : TTAbSheet;

    procedure AlimTob (NoJour: integer);
    procedure ArticleOnElipsisClick(sender: Tobject);
    procedure ArticleOnexit(sender: Tobject);
    procedure BDupliqueOnClick(Sendre: TObject);
    procedure BInsertOnClick(Sendre: TObject);

    procedure fRB_ANNUELLEOnClick(Sender: TObject);
    procedure fED_DATEPERIODDEBOnExit (SEnder: TObject);
    procedure fED_DATEPERIODFINOnExit (SEnder: TObject);
    procedure fRB_HEBDOMADAIREOnClick(Sender: TObject);
    procedure fRB_MENSUELLEOnClick(Sender: TObject);
    procedure fRB_MODEGENE1OnClick(Sender: TObject);
    procedure fRB_MODEGENE2OnClick(Sender: TObject);
    procedure fRB_MOISMETHODE1OnClick(SEnder: TObject);
    procedure fRB_MOISMETHODE2OnClick(SEnder: TObject);
    procedure fRB_MOISMETHODE3OnClick(SEnder: TObject);
    procedure fRB_NBINTERVENTIONOnClick(Sender: TObject);
    procedure fRB_QUOTIDIENNEOnClick(Sender: TObject);
    procedure MODELETACHEOnexit(Sender: TObject);
    procedure TypeActionOnExit(Sender: TObject);
    procedure AFM_UNITETEMPSOnChange(Sender: TObject);

    procedure ControleChamp(Champ, Valeur: String);
    procedure GestionEcran;
    procedure InitNewModele;
    procedure InitNewRegles;
    procedure LectureTypeAction(TypeAction: string);
    procedure RaffraichirArticle;

  end;

implementation
const
  TexteMessage: array [1..8] of string = (
    {1}  'La date de début est supérieure à la date de fin.'
    {2}, 'L''article est obligatoire.'
    {3}, 'L''article n''existe pas.'
    {4}, 'La durée d''une intervention doit être positive.'
    {5}, 'La famille de tâche est obligatoire.'
    {6}, 'Ce modèle de tâche a été utilisé en création de tâche,#13#10 Confirmez-vous sa suppression ?'
    {7}, 'La saisie du champ suivant est obligatoire : '
    {8}, 'Le code modèle de tâche est obligatoire '
    );

{ TOF_BTMODELETACHE }

procedure TOF_BTMODELETACHE.OnArgument(StArgument: string);
var Critere : String;
    Valeur  : String;
    Champ   : String;
    X       : integer;
begin
  inherited;

  fAction := TaCreat;
  fStatut := TaCreat;

  //Récupération valeur de argument
  Critere:=(Trim(ReadTokenSt(stArgument)));

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
      Critere := (Trim(ReadTokenSt(stArgument)));
    end;

  //Chargement du code affaire
  if GetControlText('AFM_MODELETACHE') <> '' then CodeModele :=GetControlText('AFM_MODELETACHE');

  GestionEcran;

end;

Procedure TOF_BTMODELETACHE.ControleChamp(Champ : String;Valeur : String);
Begin

  if Champ = 'ACTION' then
	   Begin
     if Valeur = 'CREATION' Then
        fAction := TaCreat
     else if Valeur = 'MODIFICATION' then
        fAction := TaModif
     else
	      fAction := TaConsult
  end;

  if Champ ='CODEMODELE' then CodeModele :=valeur;

end;


procedure TOF_BTMODELETACHE.OnDelete;
begin

  inherited;

  //6, 'Ce modèle de tâche a été utilisé en création de tâche,#13#10 Confirmez-vous sa suppression ?'}
  if ExisteSQL('SELECT ATA_AFFAIRE FROM TACHE WHERE ATA_MODELETACHE="' + codemodele + '"') and
    (PGIAskAF (TexteMessage [6] , Ecran.Caption) <> mrYes) then
    begin
    LastError := 6;
    exit;
    end;

  // il faut aussi détruire la table tachejour et la table mémo associée
  ExecuteSql ('DELETE FROM AFMODELETACHE WHERE AFM_MODELETACHE="' + CodeModele + '"');
  ExecuteSql ('DELETE FROM AFTACHEJOUR WHERE ATJ_TYPEJOUR="MOD" AND ATJ_MODELETACHE="' + CodeModele + '"');
  ExecuteSql ('DELETE FROM LIENSOLE WHERE LO_TABLEBLOB="AFM" AND LO_IDENTIFIANT="' + CodeModele + '"');

  OnClose;

end;

procedure TOF_BTMODELETACHE.OnLoad;
Var Tobjour : Tob;
    TobDet  : Tob;
    StrSQL  : String;
    QQ      : TQuery;
    ii      : integer;
    annee   : Word;
    jj      : Word;
    mm      : Word;
    Qte     : Double;
begin
  inherited;

  SetActiveTabSheet('PGENERAL');

  AppliquerConfidentialite(Ecran, '');

  InitNewRegles;

  if fAction = taCreat then
     Begin
     OnNew;
     Exit;
     end;

  //si modification chargment de la tob Modele de Tache
  StrSQL := 'SELECT * FROM AFMODELETACHE WHERE AFM_MODELETACHE ="' + CodeModele + '"';
  QQ := OpenSql (StrSQL,true);

  if QQ.eof then
     begin
     ferme(QQ);
     fAction := TaCreat;
     OnNew;
     Exit;
     end;

  fTobModele.selectDB('',QQ);
  ferme (QQ);

  //Chargement de la Tob des Jours
  TobJour := Tob.create ('_AFTACHEJOUR_', nil, -1);
  StrSQL := 'SELECT * FROM AFTACHEJOUR WHERE ATJ_TYPEJOUR="MOD" AND ATJ_MODELETACHE="' + CodeModele + '"';
  TobJour.LoadDetailDBFromSQL ('_AFTACHEJOUR_', StrSQL, True);

  //chargement de l'écran PGENERAL
  SetControlText('AFM_MODELETACHE', CodeModele);
  SetcontrolProperty('AFM_MODELETACHE','Enabled', false);

  SetControlText('AFM_FAMILLETACHE', Ftobmodele.GetString('AFM_FAMILLETACHE'));
  SetControlText('AFM_TYPEARTICLE', Ftobmodele.GetString('AFM_TYPEARTICLE'));
  SetControlText('AFM_CODEARTICLE', Ftobmodele.GetString('AFM_CODEARTICLE'));
  SetControlText('AFM_LIBELLETACHE1', Ftobmodele.GetString('AFM_LIBELLETACHE1'));
  SetControlText('AFM_LIBELLETACHE2', Ftobmodele.GetString('AFM_LIBELLETACHE2'));

  SetControlText('AFM_BTETAT', Ftobmodele.GetString('AFM_BTETAT'));
  LectureTypeAction(GetControlText('AFM_BTETAT'));

  SetControlText('AFM_DATEDEBPERIOD', Ftobmodele.GetString('AFM_DATEDEBPERIOD'));
  SetControlText('AFM_DATEFINPERIOD', Ftobmodele.GetString('AFM_DATEFINPERIOD'));
  SetControlText('AFM_UNITETEMPS', Ftobmodele.GetString('AFM_UNITETEMPS'));
  SetControlText('AFM_DESCRIPTIF', Ftobmodele.GetString('AFM_DESCRIPTIF'));

  //Chargement de l'écran des règles
  Qte := strtofloat(Ftobmodele.GetValue('AFM_QTEINTERVENT'));

  SetControlText('AFM_NBINTERVENTION', Ftobmodele.GetString('AFM_NBINTERVENTION'));
  SetControlText('AFM_QTEINTERVENT', FloatToStr(Qte));
  SetControlText('AFM_DATEANNUELLE', Ftobmodele.GetString('AFM_DATEANNUELLE'));
  SetControlText('AFM_METHODEDECAL', Ftobmodele.GetString('AFM_METHODEDECAL'));
  SetControlText('AFM_NBJOURSDECAL', Ftobmodele.GetString('AFM_NBJOURSDECAL'));

  if FtobModele.GetValue('AFM_MODEGENE') = 1 then
     fRB_MODEGENE1.Checked := True // au plus tôt
  else
     fRB_MODEGENE2.Checked := True; // au plus tard

  if FtobModele.GetValue('AFM_PERIODICITE') = 'Q' then fRB_QUOTIDIENNE.Checked := true;
  if FtobModele.GetValue('AFM_PERIODICITE') = 'NBI' then  fRB_NBINTERVENTION.Checked := true;

  if FtobModele.GetValue('AFM_PERIODICITE') = 'S' then
     Begin
     fRB_HEBDOMADAIRE.Checked := true;
     for ii := 0 to Tobjour.detail.count - 1 do
         begin
         TobDet := TobJour.detail [ii] ;
         TCheckBox(GetControl('AFM_JOUR' + IntToStr (TobDet.getvalue ('ATJ_JOURAPLANIF')) + 'H')).checked := True;
         end;
     end;

  if FtobModele.GetValue('AFM_PERIODICITE') = 'A' then
     begin
     fRB_ANNUELLE.Checked := true;
     Decodedate (FtobModele.GetValue('AFM_DATEANNUELLE'), annee, mm, jj);
     SetControlText ('JOURAN', IntToStr (jj));
     SetControlText ('MOISAN', IntTostr (mm));
     end;

  if FtobModele.GetValue('AFM_PERIODICITE') = 'M' then
     Begin
     fRB_MENSUELLE.Checked := true;
     SetControlText('AFM_MOISFIXE', FtobModele.GetValue('AFM_MOISFIXE'));
     if FtobModele.GetValue('AFM_MOISMETHODE') = '1' then
        begin
        fRB_MOISMETHODE1.Checked := true;
        end
     else if FtobModele.GetValue('AFM_MOISMETHODE') = '2' then
        begin
        fRB_MOISMETHODE2.Checked := true;
        THValComboBox(GetControl('AFM_MOISSEMAINE1')).value := FtobModele.GetValue('AFM_MOISSEMAINE');
        end
     else if FtobModele.GetValue('AFM_MOISMETHODE') = '3' then
        begin
        fRB_MOISMETHODE3.Checked := true;
        THValComboBox(GetControl('AFM_MOISSEMAINE2')).value := FtobModele.GetValue('AFM_MOISSEMAINE');
        for ii := 0 to Tobjour.detail.count - 1 do
            begin
            TobDet := TobJour.detail [ii] ;
            TCheckBox(GetControl('AFM_JOUR' + IntToStr(TobDEt.getvalue('ATJ_JOURAPLANIF')) + 'M')).checked := True;
            end;
        end;
     end;

  Tobjour.free;

end;

procedure TOF_BTMODELETACHE.OnNew;
begin
  inherited;

  SetActiveTabSheet('PGeneral');

  // pour l'instant, on initialise avec Heure comme unité de saisie
  SetControlText('AFM_UNITETEMPS', 'H');
  SetControlText ('AFM_FAMILLETACHE', GetParamsocSecur('SO_BTFAMILLEDEF', ''));

  SetControlProperty('fRB_MODEGENE1', 'Checked', true);
  SetControlProperty('fRB_MENSUELLE', 'Checked', true);
  SetControlProperty('fRB_MOISMETHODE1', 'Checked', true);

  SetControlText('AFM_MOISMETHODE', '1');
  SetControlText('AFM_MOISFIXE', '1');
  SetControlText('AFM_MOISJOURLIB', 'J1');
  SetControlText('AFM_MOISJOURFIXE', '1');

  SetControlText('AFM_DESCRIPTIF', '');

  fRB_MensuelleOnClick(self);

  SetFocusControl('AFM_MODELETACHE');

  InitNewRegles;

  InitNewModele;

end;


procedure TOF_BTMODELETACHE.OnUpdate;
Var vStCodeArticle  : String;
    vStArticle      : String;
    vStTypeArticle  : String;
    vStFacturable   : String;
    vStUnite        : String;
    vStLibelle      : string;
    vStStatutPla    : String;
    Tobdet          : tob;
    QQ              : Tquery;
    ii              : Integer;
    indice          : integer;
    NomChamp        : string;
    PR              : Double;
    PV              : double;
    Qte             : Integer;
    Year, Month, Day: Word;
begin
  inherited;

  vStCodeArticle := trim (GetControlText('AFM_CODEARTICLE'));
  vStTypeArticle := GetControlText('AFM_TYPEARTICLE');
  vStUnite := GetControlText('AFM_UNITETEMPS');
  Qte := StrToInt(GetControlText('AFM_QTEINTERVENT'));

 //contrôle de la cohérence des zones
  if GetControlText('AFM_MODELETACHE') = '' then
     begin
     LastError := 8;
     LastErrorMsg := TraduitGa(TexteMessage [LastError] );
     SetFocusControl ('AFM_MODELETACHE');
     exit;
     end;

  //1'La date de début est supérieure à la date de fin.'
  if strToDate (getControlText('AFM_DATEDEBPERIOD')) > strToDate (getControlText('AFM_DATEFINPERIOD')) then
     begin
     LastError := 1;
     LastErrorMsg := TraduitGa (TexteMessage [LastError] );
     SetFocusControl ('AFM_DATEFINPERIOD');
     exit;
     end;

  //2, 'L'article est obligatoire.'
  {if vStCodeArticle = '' then
     begin
     LastError := 2;
     LastErrorMsg := TraduitGa (TexteMessage [LastError] );
     SetFocusControl ('AFM_CODEARTICLE');
     exit;
     end;}

  //3, 'L'article n'existe pas.'
  if vStCodeArticle <> '' then
     Begin
     if not controleCodeArticle (vStCodeArticle, vStTypeArticle, vStArticle, vStFacturable, vStUnite, vStLibelle, PR, PV, vStStatutPla) then
        begin
        LastError := 3;
        LastErrorMsg := TraduitGa (TexteMessage [LastError] );
        SetFocusControl ('AFM_CODEARTICLE');
        exit;
        end;
     end;

  //4, 'La durée d'une intervention doit être positive.'
  if Qte <= 0 then
      begin
      LastError := 4;
      LastErrorMsg :=TraduitGa (TexteMessage [LastError] );
      SetFocusControl ('AFM_QTEINTERVENT');
      exit;
      end;

  //7, 'La saisie du champ suivant est obligatoire : '}
  NomChamp := VerifierChampsObligatoires (Ecran, '');
  if NomChamp <> '' then
     begin
     NomChamp := ReadTokenSt (NomChamp);
     SetFocusControl (NomChamp);
     LastError := 7;
     LastErrorMsg := TexteMessage [LastError] + champToLibelle (NomChamp);
     end;

  TobTacheJour := Tob.create ('AFTACHEJOUR', nil, -1);

  SetActiveTabSheet('PGENERAL');

  //chargement de la tob modèle de tâche
  FtobModele.PutValue('AFM_MODELETACHE', GetControlText('AFM_MODELETACHE'));
  FtobModele.PutValue('AFM_FAMILLETACHE', GetControlText('AFM_FAMILLETACHE'));
  FtobModele.PutValue('AFM_TYPEARTICLE', vStTypeArticle);
  FtobModele.PutValue('AFM_ARTICLE', vStArticle);
  FtobModele.PutValue('AFM_CODEARTICLE', vStCodeArticle);
  Ftobmodele.PutValue('AFM_BTETAT',  GetControlText('AFM_BTETAT'));
  FtobModele.PutValue('AFM_DATEDEBPERIOD', StrToDate (GetControlText ('AFM_DATEDEBPERIOD')));
  FtobModele.PutValue('AFM_DATEFINPERIOD', StrToDate (GetControlText ('AFM_DATEFINPERIOD')));
  FtobModele.PutValue('AFM_UNITETEMPS', GetControlText('AFM_UNITETEMPS'));
  FtobModele.PutValue('AFM_NBINTERVENTION', GetControlText ('AFM_NBINTERVENTION'));
  FtobModele.PutValue('AFM_QTEINTERVENT', Qte);
  FtobModele.PutValue('AFM_METHODEDECAL', GetControlText ('AFM_METHODEDECAL'));
  FtobModele.PutValue('AFM_NBJOURSDECAL', GetControlText ('AFM_NBJOURSDECAL'));

  FtobModele.PutValue('AFM_LIBELLETACHE1', GetControlText ('AFM_LIBELLETACHE1'));
  FtobModele.PutValue('AFM_LIBELLETACHE2', GetControlText ('AFM_LIBELLETACHE2'));
  FtobModele.PutValue('AFM_DESCRIPTIF', GetControlText ('AFM_DESCRIPTIF'));

  if fRB_MODEGENE1.Checked then
     FtobModele.PutValue('AFM_MODEGENE', 1)
  else
     FtobModele.PutValue('AFM_MODEGENE', 2);

  if fRB_QUOTIDIENNE.Checked then
     Begin
     FtobModele.PutValue('AFM_PERIODICITE', 'Q');
     FtobModele.PutValue('AFM_JOURINTERVAL', GetControlText('AFM_JOURINTERVAL'));
     end;

  if fRB_NBINTERVENTION.Checked then
     FtobModele.PutValue('AFM_PERIODICITE', 'NBI');

  if fRB_HEBDOMADAIRE.Checked then
     begin
     FtobModele.PutValue('AFM_PERIODICITE', 'S');
     FtobModele.PutValue('AFM_SEMAINEINTERV', GetControlText('AFM_SEMAINEINTERV'));
     if TCheckBox (GetControl('AFM_JOUR1H')).Checked then AlimTob (1);
     if TCheckBox (GetControl('AFM_JOUR2H')).Checked then AlimTob (2);
     if TCheckBox (GetControl('AFM_JOUR3H')).Checked then AlimTob (3);
     if TCheckBox (GetControl('AFM_JOUR4H')).Checked then AlimTob (4);
     if TCheckBox (GetControl('AFM_JOUR5H')).Checked then AlimTob (5);
     if TCheckBox (GetControl('AFM_JOUR6H')).Checked then AlimTob (6);
     if TCheckBox (GetControl('AFM_JOUR7H')).Checked then AlimTob (7);
     end;

  if fRB_MENSUELLE.Checked then
     begin
     FtobModele.PutValue('AFM_PERIODICITE', 'M');
     if fRB_MOISMETHODE1.Checked then
        begin
        FTobModele.PutValue('AFM_MOISMETHODE', '1');
        FTobModele.PutValue('AFM_MOISJOURFIXE', GetControlText('AFM_MOISJOURFIXE'));
        FTobModele.PutValue('AFM_MOISFIXE', GetControlText('AFM_MOISFIXE'));
        end
     else if fRB_MOISMETHODE2.Checked then
        begin
        FTobModele.PutValue('AFM_MOISMETHODE', '2');
        FTobModele.PutValue('AFM_MOISSEMAINE', THValComboBox(GetControl('AFM_MOISSEMAINE1')).value);
        FTobModele.PutValue('AFM_MOISJOURLIB', THValComboBox(GetControl('AFM_MOISJOURLIB')).value);
        FTobModele.PutValue('AFM_MOISFIXE', GetControlText ('AFM_MOISFIXE'));
        end
    else if fRB_MOISMETHODE3.Checked then
        begin
        FTobModele.PutValue('AFM_MOISMETHODE', '3');
        FTobModele.PutValue('AFM_MOISSEMAINE', THValComboBox (GetControl ('AFM_MOISSEMAINE2')).value);
        FTobModele.PutValue('AFM_MOISFIXE', GetControlText ('AFM_MOISFIXE'));
        if TCheckBox (GetControl ('AFM_JOUR1M')).Checked then AlimTob (1);
        if TCheckBox (GetControl ('AFM_JOUR2M')).Checked then AlimTob (2);
        if TCheckBox (GetControl ('AFM_JOUR3M')).Checked then AlimTob (3);
        if TCheckBox (GetControl ('AFM_JOUR4M')).Checked then AlimTob (4);
        if TCheckBox (GetControl ('AFM_JOUR5M')).Checked then AlimTob (5);
        if TCheckBox (GetControl ('AFM_JOUR6M')).Checked then AlimTob (6);
        if TCheckBox (GetControl ('AFM_JOUR7M')).Checked then AlimTob (7);
        end;
     end;

  //mis d'une année fictive dans la date .. seul jour et mois utilisé
  if fRB_ANNUELLE.Checked then
     begin
     FtobModele.PutValue('AFM_PERIODICITE', 'A');
     DecodeDate(now, Year, Month, Day);
     FTobModele.PutValue('AFM_DATEANNUELLE', Encodedate(Year, StrToInt(GetControlText('MOISAN')), StrToInt(GetControlText('JOURAN'))));
     FTobModele.PutValue('AFM_ANNEENB', StrToInt(GetControlText('AFM_ANNEENB')));
     end;

  FTobModele.InsertOrUpdateDb(False);

  ExecuteSql ('DELETE FROM AFTACHEJOUR WHERE ATJ_TYPEJOUR="MOD" AND ATJ_MODELETACHE="' + CodeModele + '"');
  indice := 0;
  QQ := OpenSQL ('SELECT MAX(ATJ_JOURNUMERO) FROM AFTACHEJOUR', true);
  if not QQ.Eof then Indice := QQ.Fields [0].AsInteger + 1;
  Ferme (QQ);
  for ii := 0 to TobTacheJour.detail.count - 1 do
      begin
      Tobdet := TobTacheJour.detail [ii] ;
      Tobdet.putvalue ('ATJ_JOURNUMERO', Indice);
      Inc (indice);
      end;

  TobTacheJour.InsertOrUpdateDb (False);
  TobTacheJour.free;

  fStatut := taConsult;

end;

Procedure TOF_BTMODELETACHE.GestionEcran;
Var Bt    : TToolBarButton97;
    Ed    : THEdit;
    VArtic: THEdit;
    Combo : THValComboBox;
Begin

  //création de la Tob Modele de taches
  fTobModele := Tob.create('AFMODELETACHE', nil, -1);

  // Gestion des Boutons
  Bt := TToolBarButton97(GetControl('BInsert')); //création d'un nouvel Enregistrement
  if (Bt <> nil) then Bt.Onclick := BInsertOnClick;

  Bt := TToolBarButton97(GetControl('BDuplique')); // Duplication du modéle de tache sélectionné
  if (Bt <> nil) then
    Bt.Onclick := bDupliqueOnClick;

  //Gestion des Liste de choix...
  vArtic := THedit(getcontrol('AFM_CODEARTICLE'));
  if vArtic is THEdit then
     begin
     vArtic.OnExit := ArticleOnexit;
     vArtic.OnElipsisClick := ArticleOnElipsisClick;
     end;

  Ed := THedit(GetControl('AFM_MODELETACHE'));
  Ed.OnExit := MODELETACHEOnexit;

  Ed := THedit(GetControl('AFM_BTETAT'));
  Ed.OnExit := TypeActionOnexit;

  Ed := THedit(GetControl('AFM_DATEDEBPERIOD'));
  Ed.OnExit := fED_DATEPERIODDEBOnExit;

  Ed := THedit(GetControl('AFM_DATEFINPERIOD'));
  Ed.OnExit := fED_DATEPERIODFINOnExit;

  combo := THValComboBox(GetControl('AFM_UNITETEMPS'));
  if combo <> nil then
  begin
    combo.OnChange := AFM_UNITETEMPSOnChange;
  end;

  // gestion de l'onglet règles
  fRB_MODEGENE1 := TRadioButton(GetControl('RB_MODEGENE1'));
  fRB_MODEGENE2 := TRadioButton(GetControl('RB_MODEGENE2'));
  fRB_MODEGENE1.OnClick := fRB_MODEGENE1OnClick;
  fRB_MODEGENE2.OnClick := fRB_MODEGENE2OnClick;

  fRB_QUOTIDIENNE := TRadioButton(GetControl('RB_QUOTIDIENNE'));
  fRB_NBINTERVENTION := TRadioButton(GetControl('RB_NBINTERVENTION'));
  fRB_HEBDOMADAIRE := TRadioButton(GetControl('RB_HEBDOMADAIRE'));
  fRB_ANNUELLE := TRadioButton(GetControl('RB_ANNUELLE'));
  fRB_MENSUELLE := TRadioButton(GetControl('RB_MENSUELLE'));

  fRB_QUOTIDIENNE.OnClick := fRB_QUOTIDIENNEOnClick;
  fRB_NBINTERVENTION.OnClick := fRB_NBINTERVENTIONOnClick;
  fRB_HEBDOMADAIRE.OnClick := fRB_HEBDOMADAIREOnClick;
  fRB_ANNUELLE.OnClick := fRB_ANNUELLEOnClick;
  fRB_MENSUELLE.OnClick := fRB_MENSUELLEOnClick;

  fPC_FREQUENCE := TPageControl(GetControl('PC_FREQUENCE'));
  fTS_QUOTIDIENNE := TTabSheet(GetControl('TS_QUOTIDIENNE'));
  fTS_NBINTERVENTION := TTabSheet(GetControl('TS_NBINTERVENTION'));
  fTS_HEBDOMADAIRE := TTabSheet(GetControl('TS_HEBDOMADAIRE'));
  fTS_ANNUELLE := TTabSheet(GetControl('TS_ANNUELLE'));
  fTS_MENSUELLE := TTabSheet(GetControl('TS_MENSUELLE'));

  fTS_QUOTIDIENNE.TabVisible := false;
  fTS_HEBDOMADAIRE.TabVisible := false;
  fTS_NBINTERVENTION.TabVisible := false;
  fTS_ANNUELLE.TabVisible := false;
  fTS_MENSUELLE.TabVisible := false;

  fRB_MOISMETHODE1 := TRadioButton(GetControl('RB_MOISMETHODE1'));
  fRB_MOISMETHODE2 := TRadioButton(GetControl('RB_MOISMETHODE2'));
  fRB_MOISMETHODE3 := TRadioButton(GetControl('RB_MOISMETHODE3'));
  fRB_MOISMETHODE1.OnClick := fRB_MOISMETHODE1OnClick;
  fRB_MOISMETHODE2.OnClick := fRB_MOISMETHODE2OnClick;
  fRB_MOISMETHODE3.OnClick := fRB_MOISMETHODE3OnClick;

  SetControlProperty ('AFM_TYPEARTICLE', 'Plus', PlusTypeArticle (true));

  SetcontrolProperty('PCOMPLEMENT', 'Visible', False);

(*
  if GetParamsocSecur ('SO_BTPLANDECHARGE', False) then
     begin
     setControlEnabled ('AFM_UNITETEMPS', False);
     setcontrolvisible ('PREGLES', False);
     end;
*)
end;

procedure Tof_BTMODELETACHE.BInsertOnClick(Sendre : TObject);
Begin
end;

procedure Tof_BTMODELETACHE.BDupliqueOnClick(Sendre : TObject);
Begin
end;

//Procedure de chargement des paramètre par défaut
procedure TOF_BTMODELETACHE.InitNewModele;
var vStTypeArticle: String;
    vStArticle    : String;
    vStCodeArticle: String;
    vStFacturable : String;
    vStUnite      : String;
    vStLibelle    : String;
    vStStatutPla  : String;
    frequence     : String;
    PR            : Double;
    PV            : Double;
Begin

  // article par défault
  //SetControlText('AFM_TYPEARTICLE', GetParamSocSecur('SO_BTTYPEARTDEF','PRE'));
  //SetControlText('AFM_CODEARTICLE', GetParamSocSecur('SO_BTPRESDEFAUT',''));

  vStCodeArticle := GetParamSocSecur('SO_BTPRESDEFAUT', '');
  vStTypeArticle := GetParamSocSecur('SO_BTTYPEARTDEF', 'PRE');
  vStFacturable  := '';
  vStUnite       := '';

  if ControleCodeArticle (vStCodeArticle, vStTypeArticle, vStArticle, vStFacturable, vStUnite, vStLibelle, PR, PV, vStStatutPla) then
     begin
     SetControlText('AFM_TYPEARTICLE', vStTypeArticle);
     SetControlText('AFM_CODEARTICLE', vStCodeArticle);
     SetControlText('AFM_UNITETEMPS', vStUnite);
     if GetControlText('AFM_LIBELLETACHE1') = '' then SetControlText('AFM_LIBELLETACHE1', vStLibelle);
     end
  else
     begin
     SetControlText('AFM_CODEARTICLE', '');
     SetControlText('AFM_TYPEARTICLE', GetParamsocSecur ('SO_BTTYPEARTDEF', 'PRE'));
     SetControlText('AFM_ARTICLE', '');
     end;

  SetControlEnabled('AFM_TYPEARTICLE', false);
  SetControlText('AFM_FAMILLETACHE', GetParamSocSecur('SO_BTFAMILLEDEF', ''));

  SetControlText('AFM_BTETAT', GetParamSocSecur('SO_BTETAT', ''));

  SetControlText ('JOURAN', '01');
  SetControlText ('MOISAN', '01');

  SetControlText('AFM_NBJOURSDECAL', GetParamSocSecur('SO_BTJOURDECAL', '5'));

  SetControlText ('AFM_DATEANNUELLE', DateToStr(now));
  SetControlText('AFM_MODECALC', '');

  setControlText ('AFM_DATEDEBPERIOD', DateToStr(now));
  setControlText ('AFM_DATEFINPERIOD', DateToStr(idate2099));

  setControlText ('AFM_MOISSEMAINE', '1');
  setControlText ('AFM_MODEGENE', '1');
  setControlText ('AFM_QTEINTERVENT', '1');

  Frequence := GetParamSocSecur('SO_BTPERIODDEFAUT', 'A');

  if Frequence = 'Q' then fRB_QUOTIDIENNE.Checked := true;
  if Frequence = 'H' then fRB_HEBDOMADAIRE.checked := True;
  if Frequence = 'M' then fRB_MENSUELLE.Checked := True;
  if Frequence = 'A' then fRB_ANNUELLE.Checked := true;
  if Frequence = 'N' then fRB_NBINTERVENTION.Checked := true;

  setControlText ('AFM_NBJOURSDECAL', GetParamsocSecur ('SO_BTJOURSDECAL', 5));
  setControlText ('AFM_METHODEDECAL', GetParamsocSecur ('SO_BTJOURSPLANIF', 'P'));

end;

procedure TOF_BTMODELETACHE.InitNewRegles;
begin

  SetControltext('AFM_MOISSEMAINE1', '1');
  SetControlText('AFM_MOISSEMAINE2', '1');

  SetControlText('AFM_MOISFIXE', '1');

  SetControlProperty('AFM_JOUR1H', 'checked', false);
  SetControlProperty('AFM_JOUR2H', 'checked', false);
  SetControlProperty('AFM_JOUR3H', 'checked', false);
  SetControlProperty('AFM_JOUR4H', 'checked', false);
  SetControlProperty('AFM_JOUR5H', 'checked', false);
  SetControlProperty('AFM_JOUR6H', 'checked', false);
  SetControlProperty('AFM_JOUR7H', 'checked', false);

  SetControlProperty('AFM_JOUR1MH', 'checked', false);
  SetControlProperty('AFM_JOUR2M', 'checked', false);
  SetControlProperty('AFM_JOUR3M', 'checked', false);
  SetControlProperty('AFM_JOUR4M', 'checked', false);
  SetControlProperty('AFM_JOUR5M', 'checked', false);
  SetControlProperty('AFM_JOUR6M', 'checked', false);
  SetControlProperty('AFM_JOUR7M', 'checked', false);

(*
  SetControlEnabled ('RB_MODEGENE1', GetParamsocSecur('SO_BTGENELIMIT', False));
  SetControlEnabled ('RB_MODEGENE2', GetParamsocSecur('SO_BTGENELIMIT', False));
*)
end;

procedure TOF_BTMODELETACHE.fRB_MODEGENE1OnClick (Sender: TObject);
begin

  fRB_MODEGENE2.checked := not fRB_MODEGENE1.Checked;

end;

procedure TOF_BTMODELETACHE.fRB_MODEGENE2OnClick (Sender: TObject);
begin

  fRB_MODEGENE1.Checked := not fRB_MODEGENE2.Checked;

end;

procedure TOF_BTMODELETACHE.fRB_MOISMETHODE1OnClick(SEnder: TObject);
begin

  fRB_MOISMETHODE2.checked := not fRB_MOISMETHODE1.checked;
  fRB_MOISMETHODE3.checked := not fRB_MOISMETHODE1.checked;

  SetControlEnabled('AFM_MOISJOURFIXE', True);
  SetControlEnabled('AFM_MOISFIXE', True);
  SetControlEnabled('AFM_MOISSEMAINE1', false);
  SetControlEnabled('AFM_MOISJOURLIB', false);
  SetControlEnabled('AFM_MOISSEMAINE2', false);


  SetControlEnabled('AFM_JOUR1M', false);
  SetControlEnabled('AFM_JOUR2M', false);
  SetControlEnabled('AFM_JOUR3M', false);
  SetControlEnabled('AFM_JOUR4M', false);
  SetControlEnabled('AFM_JOUR5M', false);
  SetControlEnabled('AFM_JOUR6M', false);
  SetControlEnabled('AFM_JOUR7M', false);

end;

procedure TOF_BTMODELETACHE.fRB_MOISMETHODE2OnClick(SEnder: TObject);
begin

  fRB_MOISMETHODE1.checked := not fRB_MOISMETHODE2.checked;
  fRB_MOISMETHODE3.checked := not fRB_MOISMETHODE2.checked;

  SetControlEnabled('AFM_MOISJOURFIXE', false);
  SetControlEnabled('AFM_MOISFIXE', True);
  SetControlEnabled('AFM_MOISSEMAINE1', true);
  SetControlEnabled('AFM_MOISJOURLIB', true);
  SetControlEnabled('AFM_MOISSEMAINE2', false);

  SetControlEnabled('AFM_JOUR1M', false);
  SetControlEnabled('AFM_JOUR2M', false);
  SetControlEnabled('AFM_JOUR3M', false);
  SetControlEnabled('AFM_JOUR4M', false);
  SetControlEnabled('AFM_JOUR5M', false);
  SetControlEnabled('AFM_JOUR6M', false);
  SetControlEnabled('AFM_JOUR7M', false);

end;

procedure TOF_BTMODELETACHE.fRB_MOISMETHODE3OnClick(SEnder: TObject);
begin

  fRB_MOISMETHODE1.checked := not fRB_MOISMETHODE3.checked;
  fRB_MOISMETHODE2.checked := not fRB_MOISMETHODE3.checked;

  SetControlEnabled('AFM_MOISJOURFIXE', false);
  SetControlEnabled('AFM_MOISFIXE', True);
  SetControlEnabled('AFM_MOISSEMAINE1', false);
  SetControlEnabled('AFM_MOISJOURLIB', false);
  SetControlEnabled('AFM_MOISSEMAINE2', true);

  SetControlEnabled('AFM_JOUR1M', true);
  SetControlEnabled('AFM_JOUR2M', true);
  SetControlEnabled('AFM_JOUR3M', true);
  SetControlEnabled('AFM_JOUR4M', true);
  SetControlEnabled('AFM_JOUR5M', true);
  SetControlEnabled('AFM_JOUR6M', true);
  SetControlEnabled('AFM_JOUR7M', true);

end;

procedure TOF_BTMODELETACHE.fRB_HEBDOMADAIREOnClick(Sender: TObject);
begin

  //Chargement de la Tob principale
  //fTobModele.PutValue('AFM_PLANNINGPERIOD', 'S');

  fRB_QUOTIDIENNE.checked := not fRB_HEBDOMADAIRE.checked;
  fRB_MENSUELLE.checked := not fRB_HEBDOMADAIRE.checked;
  fRB_ANNUELLE.checked := not fRB_HEBDOMADAIRE.checked;
  fRB_NBINTERVENTION.checked := not fRB_HEBDOMADAIRE.checked;

  TCheckBox(GetControl('AFM_JOUR1H')).checked := not fRB_HEBDOMADAIRE.checked;
  TCheckBox(GetControl('AFM_JOUR2H')).checked := not fRB_HEBDOMADAIRE.checked;
  TCheckBox(GetControl('AFM_JOUR3H')).checked := not fRB_HEBDOMADAIRE.checked;
  TCheckBox(GetControl('AFM_JOUR4H')).checked := not fRB_HEBDOMADAIRE.checked;
  TCheckBox(GetControl('AFM_JOUR5H')).checked := not fRB_HEBDOMADAIRE.checked;
  TCheckBox(GetControl('AFM_JOUR6H')).checked := not fRB_HEBDOMADAIRE.checked;
  TCheckBox(GetControl('AFM_JOUR7H')).checked := not fRB_HEBDOMADAIRE.checked;

  fPC_FREQUENCE.ActivePage := fTS_HEBDOMADAIRE;

end;

procedure TOF_BTMODELETACHE.fRB_QUOTIDIENNEOnClick(Sender: TObject);
begin

  //Chargement de la Tob principale
  //fTobModele.PutValue('AFM_PLANNINGPERIOD', 'Q');

  fRB_HEBDOMADAIRE.checked := not fRB_QUOTIDIENNE.checked;
  fRB_MENSUELLE.checked := not fRB_QUOTIDIENNE.checked;
  fRB_ANNUELLE.checked := not fRB_QUOTIDIENNE.checked;
  fRB_NBINTERVENTION.checked := not fRB_QUOTIDIENNE.checked;
  fPC_FREQUENCE.ActivePage := fTS_QUOTIDIENNE;

end;

procedure TOF_BTMODELETACHE.fRB_MENSUELLEOnClick(Sender: TObject);
begin

  //Chargement de la Tob principale
  //fTobModele.PutValue('AFM_PLANNINGPERIOD', 'M');

  fRB_HEBDOMADAIRE.checked := not fRB_MENSUELLE.checked;
  fRB_QUOTIDIENNE.checked := not fRB_MENSUELLE.checked;
  fRB_ANNUELLE.checked := not fRB_MENSUELLE.checked;
  fRB_NBINTERVENTION.checked := not fRB_MENSUELLE.checked;
  fPC_FREQUENCE.ActivePage := fTS_MENSUELLE;

  TCheckBox(GetControl('AFM_JOUR1M')).checked := not fRB_MENSUELLE.checked;
  TCheckBox(GetControl('AFM_JOUR2M')).checked := not fRB_MENSUELLE.checked;
  TCheckBox(GetControl('AFM_JOUR3M')).checked := not fRB_MENSUELLE.checked;
  TCheckBox(GetControl('AFM_JOUR4M')).checked := not fRB_MENSUELLE.checked;
  TCheckBox(GetControl('AFM_JOUR5M')).checked := not fRB_MENSUELLE.checked;
  TCheckBox(GetControl('AFM_JOUR6M')).checked := not fRB_MENSUELLE.checked;
  TCheckBox(GetControl('AFM_JOUR7M')).checked := not fRB_MENSUELLE.checked;

end;

procedure TOF_BTMODELETACHE.fRB_ANNUELLEOnClick(Sender: TObject);
begin

  //Chargement de la Tob principale
  //fTobModele.PutValue('AFM_PLANNINGPERIOD', 'A');

  fRB_HEBDOMADAIRE.checked := not fRB_ANNUELLE.checked;
  fRB_QUOTIDIENNE.checked := not fRB_ANNUELLE.checked;
  fRB_MENSUELLE.checked := not fRB_ANNUELLE.checked;
  fRB_NBINTERVENTION.checked := not fRB_ANNUELLE.checked;

  fPC_FREQUENCE.ActivePage := fTS_ANNUELLE;

end;

procedure TOF_BTMODELETACHE.fRB_NBINTERVENTIONOnClick (Sender: TObject);
begin

  //Chargement de la Tob principale
  //fTobModele.PutValue('AFM_PLANNINGPERIOD', 'NBI');

  fRB_HEBDOMADAIRE.checked := not fRB_NBINTERVENTION.checked;
  fRB_QUOTIDIENNE.checked := not fRB_NBINTERVENTION.checked;
  fRB_MENSUELLE.checked := not fRB_NBINTERVENTION.checked;
  fRB_ANNUELLE.checked := not fRB_NBINTERVENTION.checked;
  fPC_FREQUENCE.ActivePage := fTS_NBINTERVENTION;

  SetControlEnabled ('RB_MODEGENE2', false);
  SetControlEnabled ('RB_MODEGENE1', false);

end;


Procedure TOF_BTMODELETACHE.ArticleOnexit(sender : Tobject);
var vStCodeArticle  : String;
    vStTypeArticle  : String;
    vStArticle      : String;
    vStFacturable   : String;
    vStUnite        : String;
    VstLibelle      : string;
    vStStatutPla    : String;
    PR              : Double;
    PV              : double;
begin

  vStCodeArticle := GetControlText('AFM_CODEARTICLE');

  if ControleCodeArticle(vStCodeArticle, vStTypeArticle, vStArticle, vStFacturable, vStunite, vStLibelle, PR, PV, vStStatutPla) then
     begin
     //SetControlText ('AFM_TYPEARTICLE', vStTypeArticle);
     if IsTachePrestation(vStTypeArticle) then    //AB-200605 - FQ 12918
        SetControlText('AFM_UNITETEMPS', vStUnite)
     else
        SetControlText('AFM_UNITETEMPS', 'J'); // pour frais et marchandise on met à J
        if getControlText('AFM_LIBELLETACHE1') = '' then
           SetControlText('AFM_LIBELLETACHE1', vStLibelle);
     end
  else
     begin
     PGIBoxAF (TexteMessage [3] , '');    {3, 'L''article n''existe pas.'}
     exit;
     end;

  //if getControlText ('AFM_CODEARTICLE') <> '' then
  //   SetControlEnabled ('AFM_TYPEARTICLE', False)
  //else
  //  SetControlEnabled ('AFM_TYPEARTICLE', true);

end;


Procedure TOF_BTMODELETACHE.ArticleOnElipsisClick(sender : Tobject);
begin

  if GetControlText('AFM_LIBELLETACHE1') = fStLibelleParDefaut then SetControlText('AFM_LIBELLETACHE1', '');

  SetControlText('AFM_CODEARTICLE', DispatchRecherche(nil, 1, '', 'GA_CODEARTICLE='
+ GetControltext('AFM_CODEARTICLE') + ';RETOUR_CODEARTICLE=X;GA_TYPEARTICLE='
+ GetControlText('AFM_TYPEARTICLE'), ''));

  RaffraichirArticle;

end;

procedure TOF_BTMODELETACHE.RaffraichirArticle;
var vStCodeArticle  : string;
    vStTypeArticle  : string;
    vStArticle      : string;
    vStFacturable   : string;
    vStUnite        : string;
    vStLibelle      : string;
    vStStatutPla    : String;
    PR,PV           : Double;
begin

  vStCodeArticle := GetControlText('AFM_CODEARTICLE');

  if vStCodeArticle <> '' then
     begin
     if ControleCodeArticle(vStCodeArticle, vStTypeArticle, vStArticle, vStFacturable, vStUnite, vStLibelle, PR, PV, vStStatutPla) then
        begin
        SetControlText('AFM_TYPEARTICLE', vStTypeArticle);
        if IsTachePrestation (vStTypeArticle) then  //AB-200605 - FQ 12918
           begin
           SetControlText('AFM_UNITETEMPS', vStUnite);
           end
        else
           SetControlText('AFM_UNITETEMPS', 'J'); // pour frais et marchandise on met à J
        end;
     SetControlText('AFM_LIBELLETACHE1', vStLibelle);
     SetControlText('AFM_ARTICLE', vStArticle);
     end;

end;

procedure TOF_BTMODELETACHE.MODELETACHEOnexit(Sender: TObject);
var Req  : String;
    QQ   : TQuery;
begin

  fStatut := taModif;

  if fAction = taModif then exit;

  //Lecture de la table modele de tache pour
  //vérification existance code ou non en création
  CodeModele := GetControlText('AFM_MODELETACHE');

  if CodeModele = '' then exit;

  req := 'SELECT * FROM AFMODELETACHE WHERE AFM_MODELETACHE ="' + CodeModele + '"';
  QQ := OpenSql(Req,true);

  if QQ.eof then
     begin
     ferme(QQ);
     Exit;
     end;

  fAction := taModif;

  fTobModele.selectDB('',QQ);
  ferme (QQ);

  onload;

end;

procedure TOF_BTMODELETACHE.TypeActionOnExit(Sender: TObject);
var StReq : String;
    QQ    : TQuery;
Begin

  fStatut := taModif;

  LectureTypeAction(GetControlText('AFM_BTETAT'));

  if GetControlText('AFM_BTETAT') = '' then exit;

  StReq := 'SELECT BTA_DUREEMINI FROM BTETAT WHERE BTA_BTETAT = "' + GetControlText('AFM_BTETAT') + '"';
  QQ := nil;

  try
    QQ := OpenSQL(StReq, True);
    if (not QQ.EOF) then
       begin
       setControlText('AFM_QTEINTERVENT', FloatToStr(QQ.findField('BTA_DUREEMINI').asfloat));
       end;
  finally
    ferme(QQ);
  end;

end;

procedure TOF_BTMODELETACHE.LectureTypeAction (TypeAction : string);
var Req           : String;
    TobTypeAction : Tob;
begin

  if TypeAction = '' then exit;

  SetControlText('LTYPEACTION', '');

  //Lecture du Type ACtion Evenement sélectionné et affichage des informations
  req := 'SELECT BTA_LIBELLE FROM BTETAT WHERE BTA_BTETAT="' + TypeAction + '"';

  TobTypeAction := Tob.Create('#BTETAT',Nil, -1);
  TobTypeAction.LoadDetailFromSQL(Req);
  if TobTypeAction.Detail.Count > 0 then
     Setcontroltext('LTYPEACTION', TobTypeAction.detail[0].GetString('BTA_LIBELLE'))
  else
     Setcontroltext('LTYPEACTION', '');

  TobTypeAction.free;

end;


procedure TOF_BTMODELETACHE.AlimTob(NoJour: integer);
var
  tobdet: tob;
begin

  Tobdet := Tob.Create ('AFTACHEJOUR', TobTacheJour, -1);

  TOBDet.PutValue ('ATJ_Affaire', '');
  TOBDet.PutValue ('ATJ_NumeroTache', 0);
  TOBDet.PutValue ('ATJ_JourHeureDeb', 0);
  TOBDet.PutValue ('ATJ_JourNbHeures', 0);
  TOBdet.PutValue ('ATJ_JourAplanif', noJour);
  TOBdet.PutValue ('ATJ_ModeleTache', Getcontroltext('AFM_ModeleTache'));
  TOBdet.PutValue ('ATJ_TypeJour', 'MOD');

end;

procedure TOF_BTMODELETACHE.fED_DATEPERIODDEBOnExit(SEnder: TObject);
var DateDeb : TDateTime;
begin

  if TFFiche (Ecran).TypeAction = taConsult then exit;

  fStatut := taModif;

  DateDeb :=StrToDateTime(GetControlText ('AFM_DATEDEBPERIOD'));

  FtobModele.Putvalue('AFM_DATEDEBPERIOD', DateDeb);

end;

procedure TOF_BTMODELETACHE.fED_DATEPERIODFINOnExit(SEnder: TObject);
var DateFin : TDateTime;
begin

  if TFFiche (Ecran).TypeAction = taConsult then  exit;

  fstatut := taModif;

  DateFin :=StrToDateTime(GetControlText ('AFM_DATEFINPERIOD'));

  FtobModele.Putvalue('AFM_DATEFINPERIOD', DateFin);

end;

procedure TOF_BTMODELETACHE.AFM_UNITETEMPSOnChange(SEnder: TObject);
begin
  if getControlText('AFM_UNITETEMPS') = 'J' then
    SetControlCaption('AFM_UNITETEMPS2', 'Jour(s)')
  else
    SetControlCaption('AFM_UNITETEMPS2', 'Heure(s)');
end;

procedure TOF_BTMODELETACHE.OnClose;
begin
  inherited;

  if fTobModele <> nil then fTobModele.free

end;

initialization
  registerclasses ([TOF_BTMODELETACHE] );
end.
