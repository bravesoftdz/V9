{-------------------------------------------------------------------------------------
    Version   |  Date   | Qui | Commentaires
--------------------------------------------------------------------------------------
 7.00.001.001  22/11/05   JP   Cr�ation de l'unit� : Anc�tre des vignettes Compta et Tr�so
 8.01.001.001  25/01/07   JP   Gestion de la GED
--------------------------------------------------------------------------------------}
unit uAncetreVignettePlugIn;

interface

uses
  Classes, UTob,
  {$IFNDEF DBXPRESS}
  dbtables,
  {$ELSE}
  uDbxDataSet,
  {$ENDIF}
  HEnt1, uToolsPlugIn;

type
  TVAncetreForm = (vaf_None, vaf_Autre, vaf_Vierge, vaf_Mul, vaf_Fiche, vaf_Etat, vaf_Web,
                   vaf_Graph, vaf_Image, vaf_Raccourci, vaf_Calendrier);

  TAncetreVignettePlugIn = class(TVignettePlugIn)
  private
    FAncetre : TVAncetreForm;
    FAspectGraph : string;
    FDateRef : TDateTime;
    FPeriode : Char;
    FCodeUser : string; {JP 15/06/06}

    function  GetAncetre       : TVAncetreForm;
    function  GetAspectGraph   : string;
    function  GetDateReference : TDateTime;
    {01/06/06 : Pour la property Periode}
    procedure SetPeriode(Value : Char);
    function  GetPeriode : Char;
    {JP 15/06/06 : Nouvelle gestion des User � la demande de EPZ}
    function GetCodeUser : string;
  protected
    {Param�tres du Dispacth
     Remarques Le premier param�tre doit toujours �tre 'AVEC' (donn�es) ou 'SANS' (donn�es)}
    FParam : string;
    {Gestion du Warning si pas de donn�es}
    MsgWarning : string; {Message d'avertissement affich� dans le portail}
    WarningOk  : Boolean; {S'il faut g�rer le champ Warning ou pas : par d�faut � True}

    {R�cup�ration des controls/valeurs depuis la TobRequest}
    function  GetInterface(NomGrille : string = '') : Boolean; virtual;
    {Affectation des controls/valeurs dans la TobRespons}
    function  SetInterface : Boolean;    virtual;
    {Fonction de traitement des donn�s}
    procedure RecupDonnees ;             virtual;
    {Fonction de g�n�ration de la clause where � partir des crit�es}
    procedure GetClauseWhere;            virtual;
    {Pour d�ssiner la grille apr�s le PutGridDetail}
    procedure DrawGrid(Grille : string); virtual;
    {Traite les param�tres du dispatch}
    procedure TraiteParam(Param : string); virtual;
    procedure Rapport; virtual;
    function  GetVignetteZoom(aDom, aNom, aCaption : string; aAncetre : TVAncetreForm = vaf_Vierge) : TOB;
  public
    FTip         : string;
    FNat         : string;
    FModele      : string;
    FLanguePrinc : string;

    {Pointeur sur les tobs d'entr�es et de sorties}
    TobResponse  : TOB;
    TobRequest   : TOB;
    {Tob qui contient les donn�e de la requ�te metier}
    TobDonnees   : TOB;
    {Tob avec les donn�es s�lectionn�es dans la vignette}
    TobSelection : TOB;
    {Indique s'il y a des donn�es � mettre dans la TobSelection.
    Le premier param�tre doit toujours �tre 'AVEC' (donn�es) ou 'SANS' (donn�es)}
    AvecSelection : Boolean;

    ClauseWhere : HString;
    {Pour stocker le message d'erreur qui ira dans la TobResponse}
    MessageErreur : string;
    {A True si l'on ne veut pas lancer le SetInterface}
    SansInterface : Boolean;

    class function NouvelleInstance(Param : string; RequestTob : TOB; ClassName : string) : TOB; virtual; abstract;

    constructor Create(TobIn, TobOut : Tob); override;
    destructor  Destroy; override;
    {Lancement de la requ�te metier}
    procedure LanceTraitement(Param : string); //virtual;
    procedure SetClause(s : string);

    function  GetRowSelectCount(Grille : string) : Integer;
    {Pour les fiches reli�e � une table, affiche l'enregistrement suivant}
    procedure RaffraichirFiche;
    {Renvoie la devise pivot}
    function GetDevisePivot(SigleOk : Boolean) : string;

    {31/05/06 : Gestion des d�placements de la date de r�f�rence}
    procedure GereDeplacement;
    {31/05/06 : D�finition du libell� P�riode apr�s le calcul de la DateRef}
    function MajLibPeriode(aDate : TDateTime = 2) : string; virtual;
    {01/06/06 : Initialisation de la combo PERIODE, appel� dans le GetPeriode}
    function InitPeriode : Char; virtual;
    {01/06/06 : Si la p�riode est l'exercice}
    function GereExercice(Chp : string; aDate : TDateTime = 2) : string; virtual;
    {25/01/07 : Extrait de la base un document stock� par la Ged; SystemeOk : s'il s'agit de la Ged
                syst�me (YFILES / YFILEPARTS) ou bien de la GED transversale (YDOCUMENTS / YDOCFILES)}
    procedure RecupDocument(NoGuid : string; SystemOk : Boolean = False);
    {25/01/07 : Met � disposition un fichier pour le portail}
    procedure PrepareFichier(FileName : string);

    function  StrToTVAncetre(tType : string) : TVAncetreForm;
    function  TVAncetreToStr(tType : TVAncetreForm) : string;

    property Ancetre : TVAncetreForm read GetAncetre default vaf_None;
    {12/05/06 : Nouvelle propri�t� pour la gestion des dimensions (2D / 3D) dans les graphiques}
    property AspectGraph : string read GetAspectGraph write FAspectGraph;
    {12/05/06 : Nouvelle gestion de la date de r�f�rence pour les requ�tes}
    property DateRef : TDateTime read GetDateReference write FDateRef;
    {01/06/06 : Gestion de la p�riode issue de la combo "PERIODE"}
    property Periode : Char read GetPeriode write SetPeriode;
    {JP 15/06/06 : Nouvelle gestion des User � la demande de EPZ}
    property CodeUser : string read GetCodeUser write FCodeUser;
  end;

const
  PARAMPLUS  = 'PERPLUS';
  PARAMMOINS = 'PERMOINS';

implementation

uses
  SysUtils, HCtrls, EdtREtat, hQuickRP, eSession, aglEtat,
  MajTable, ParamSoc, IniFiles, Forms, UGedFiles, Windows;

{---------------------------------------------------------------------------------------}
procedure TAncetreVignettePlugIn.RecupDonnees;
{---------------------------------------------------------------------------------------}
begin
  GetClauseWhere;
end;

{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.GetInterface(NomGrille : string = '') : Boolean;
{---------------------------------------------------------------------------------------}
var
  T1 : TOB;
  T2 : TOB;
  n  : Integer;
begin
  MessageErreur := '';
  Result := TobRequest <> nil;
  n := -1;

  {JP 25/01/07 : Pour le Changement de gestion des graphs}
  if TobRequest.FieldExists('WIDTH') then TobResponse.AddChampSupValeur('FWIDTH', TobRequest.GetString('WIDTH'));
  if TobRequest.FieldExists('HEIGHT') then TobResponse.AddChampSupValeur('FHEIGHT', TobRequest.GetString('HEIGHT'));

  {R�cup�ration �ventuelle des donn�es de la TobRequest}
  if Result and AvecSelection and (NomGrille <> '') then begin
    try
      while True do begin
        T2 := GetGridDataSelected(NomGrille, n);
        if T2 <> nil then begin
          T1 := TOB.Create('FILLESELECTION', TobSelection, -1);
          T1.Dupliquer(T2, False, True);
        end
        else
          break;
      end;
    except
      on E : Exception do begin
        Result := False;
        MessageErreur := 'Erreur lors de la r�cup�ration des donn�es s�lectionn�es :'#13 + E.Message;
      end;
    end;
  end;
end;

{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.SetInterface : Boolean;
{---------------------------------------------------------------------------------------}
var
  T : TOB;
  G : string;
begin
  Result := True;
  if not SansInterface then begin
    if Assigned(TobDonnees) then begin
      {Mets les donn�es dans la grille}
      case Ancetre of
        vaf_Vierge : G := 'GRID';
        vaf_Mul    : G := 'FListe';
        else G := 'GRID';
      end;
      ddWriteLN('PGIVIGNETTES : Resultat (' + IntToStr(TobDonnees.Detail.Count) + ')');
      T := TOB.Create('~TEMP', nil, -1);
      try
        {On est oblig� de sauvegarder la Tob car le PutGridDetail change le Parent des filles}
        T.Dupliquer(TobDonnees, True, True);
        {Mets les donn�es dans la grille}
        PutGridDetail(G, TobDonnees);
        SetControlValue(G, 1);
        TobDonnees.Dupliquer(T, True, True);
      finally
        FreeAndNil(T);
      end;
      {"Dessine la grille"}
      DrawGrid(G);
    end
    else
      Result := False;
  end;

  if WarningOk and (MsgWarning <> '') then begin
    TobResponse.AddChampSupValeur('WARNING', MsgWarning);
    ddWriteLN('PGIVIGNETTES : WARNING : ' + MsgWarning);
  end;
end;

{Pour d�finir les propri�t�s d'une grille
{---------------------------------------------------------------------------------------}
procedure TAncetreVignettePlugIn.DrawGrid(Grille : string);
{---------------------------------------------------------------------------------------}
begin
{Format : 'D.2  ---', 'G.0  ---', 'C.0  ---'
 Width : Integer
 Titre : 'Cha�ne'
}
end;

{---------------------------------------------------------------------------------------}
procedure TAncetreVignettePlugIn.GetClauseWhere;
{---------------------------------------------------------------------------------------}
begin
  ClauseWhere := '';
end;

{Utilitaire de constitution des requ�tes
{---------------------------------------------------------------------}
procedure TAncetreVignettePlugIn.SetClause(s : string);
{---------------------------------------------------------------------}
begin
  if ClauseWhere = '' then ClauseWhere := s
                      else ClauseWhere := ClauseWhere + ' AND ' + s;
end;

{---------------------------------------------------------------------------------------}
procedure TAncetreVignettePlugIn.LanceTraitement(Param : string);
{---------------------------------------------------------------------------------------}
begin
  {29/09/06 : Gestion du champ Warning}
  WarningOk  := True;
//  MsgWarning := TraduireMemoire('La s�lection ne renvoie aucun enregistrement');
  MsgWarning := '';

  AvecSelection := False; {JP 31/05/06}
  {Traite les param�tres du dispact}
  TraiteParam(Param);
  {JP 31/05/06 : Gestion �ventuelle du d�placement des p�riodes de traitement}
  GereDeplacement;

  {R�cup�re les donn�es de la vignette}
  if GetInterface then begin
    {Traitement proprement dit}
    RecupDonnees;


    {29/09/06 : Si pas de donn�es, on ajoute un warning}
    if (TobDonnees.Detail.Count = 0) and WarningOk then begin
      if MsgWarning = '' then
        MsgWarning := TraduireMemoire('La s�lection ne renvoie aucun enregistrement');
      TobResponse.AddChampSupValeur('WARNING', MsgWarning);
      ddWriteLN('PGIVIGNETTES : WARNING : Pas de donnees sur la periode');
      {Pour r�initialiser le la Grille a Vide}
      DrawGrid('');
    end

    {On s'assure que le traitement s'est convenablement d�roul�}
    else if MessageErreur <> '' then begin
      TobResponse.SetString('ERROR', MessageErreur);
      ddWriteLN('PGIVIGNETTES : ' + MessageErreur);
    end

    {Mise � jour de la vignette}
    else if not SetInterface then begin
      if MessageErreur = '' then MessageErreur := 'Impossible de reconstituer l''interface';
      TobResponse.SetString('ERROR', MessageErreur);
      ddWriteLN('PGIVIGNETTES : ' + MessageErreur);
    end;
  end
  else begin
    if MessageErreur = '' then MessageErreur := 'Impossible d''interpr�ter l''interface';
    TobResponse.SetString('ERROR', MessageErreur);
    ddWriteLN('PGIVIGNETTES : ' + MessageErreur);
  end;
  {Rafra�chissement des crit�res}
end;

{---------------------------------------------------------------------------------------}
constructor TAncetreVignettePlugIn.Create(TobIn, TobOut : Tob);
{---------------------------------------------------------------------------------------}
begin
  inherited Create(TobIn, TobOut);
  {Affectation des TOB}
  TobResponse  := TobOut;
  TobRequest   := TobIn;
  TobDonnees   := TOB.Create('VIGNETTES', nil, -1 );
  TobSelection := TOB.Create('MERESELECTION', nil, -1 );

  {12/05/06 : Nouvelle gestion de la date de r�f�rence}
  FDateRef := iDate1900;
  FPeriode := '@';
end;

{---------------------------------------------------------------------------------------}
destructor TAncetreVignettePlugIn.Destroy;
{---------------------------------------------------------------------------------------}
begin
  if Assigned(TobDonnees) then FreeAndNil(TobDonnees);
  if Assigned(TobSelection) then FreeAndNil(TobSelection);
  inherited Destroy;
end;

{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.GetAncetre : TVAncetreForm;
{---------------------------------------------------------------------------------------}
begin
  if FAncetre = vaf_None then 
    FAncetre := StrToTVAncetre(TobRequest.GetString('ANCETRE'));
  Result := FAncetre;
end;

{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.StrToTVAncetre(tType : string) : TVAncetreForm;
{---------------------------------------------------------------------------------------}
begin
       if tType = 'VGV' then Result := vaf_Vierge
  else if tType = 'VGM' then Result := vaf_Mul
  else if tType = 'VGF' then Result := vaf_Fiche
  else if tType = 'VGR' then Result := vaf_Etat
  else if tType = 'VGW' then Result := vaf_Web
  else if tType = 'VGG' then Result := vaf_Graph
  else if tType = 'VGI' then Result := vaf_Image
  else if tType = 'VGL' then Result := vaf_Raccourci
  else if tType = 'VGC' then Result := vaf_Calendrier
                        else Result := vaf_Autre;
end;

{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.TVAncetreToStr(tType : TVAncetreForm) : string;
{---------------------------------------------------------------------------------------}
begin
  case tType of
    vaf_Vierge     : Result := 'VGV';
    vaf_Mul        : Result := 'VGM';
    vaf_Fiche      : Result := 'VGF';
    vaf_Etat       : Result := 'VGR';
    vaf_Web        : Result := 'VGW';
    vaf_Graph      : Result := 'VGG';
    vaf_Image      : Result := 'VGI';
    vaf_Raccourci  : Result := 'VGL';
    vaf_Calendrier : Result := 'VGC';
  else
    Result := '';
  end;
end;

{12/05/06 : Nouvelle propri�t� pour la gestion des dimensions (2D / 3D) dans les graphiques
{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.GetAspectGraph : string;
{---------------------------------------------------------------------------------------}
begin
  if FAspectGraph = '' then
    FAspectGraph := TobRequest.GetString('ASPECTGRAPH');

  if not ((FAspectGraph = '2D') or (FAspectGraph = '3D')) then
    FAspectGraph := '2D';
  Result := FAspectGraph;
end;

{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.GetDateReference : TDateTime;
{---------------------------------------------------------------------------------------}
var
  Ini : TIniFile;
  dd  : string;
begin
  if FDateRef = iDate1900 then begin
    if GetDateTime('FDATEDEBUT') <> iDate1900 then
      FDateRef := GetDateTime('FDATEDEBUT')
    else begin
      Ini:= TIniFile.Create(ExtractFilePath(Application.ExeName) + 'portail.ini');
      dd := Ini.ReadString('GENERAL', 'DATEENTREE', DatetoStr(Date));
      FreeAndNil(Ini);
      FDateRef := StrToDateTime(dd);
    end;
  end;
  Result := FDateRef;
end;

{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.GetRowSelectCount(Grille : string): Integer;
{---------------------------------------------------------------------------------------}
var
  TG : TOB;
  n  : Integer;
begin
  Result := 0;
  TG := TobRequest.FindFirst(['NAME'], [Grille], True);
  if TG <> nil then
    for n := 0 to TG.Detail.count - 1 do begin
      if TG.Detail[n].NomTable = 'T_BOOKMARKS' then
        Result := TG.Detail[n].Detail.Count;
    end;
end;

{Traite les param�tres du dispact
{---------------------------------------------------------------------------------------}
procedure TAncetreVignettePlugIn.TraiteParam(Param : string);
{---------------------------------------------------------------------------------------}
begin
  FParam := Param; {JP 31/05/06}
end;

{---------------------------------------------------------------------------------------}
procedure TAncetreVignettePlugIn.RaffraichirFiche;
{---------------------------------------------------------------------------------------}
var
  DataTob : TOB;
  stSQL,
  TableName : string;
  RowCount,
  FirstRow : Integer;
begin
  DataTob := Tob.Create('une tob', nil, -1 );
  try
    ddwriteln('Raffraichissement de la fiche');
    FirstRow := TobRequest.GetValue('FIRSTROW');
    TableName := TobRequest.GetValue('TABLENAME');
    stSQL := GetSQLFiche(TableName, RowCount);
    if FirstRow = -1 then FirstRow := 0;
    DataTob.LoadDetailFromSQL(StSQL, False, False, 1, FirstRow);
    if DataTob.Detail.count > 0 then begin
      SetDesignedData('T_DATAEDIT', 'ROWCOUNT', RowCount);
      PutEcran(DataTob.Detail[0]);
    end
    else
      PutEcran(nil);
  finally
    FreeAndNil(DataTob);
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TAncetreVignettePlugIn.Rapport;
{---------------------------------------------------------------------------------------}
var
  T : TOB;
  T_LANCEETATTOB : TOB;
begin
  {JP 04/10/06 : on blinde pour �viter un plantage dans le Portail}
  if TobDonnees.Detail.Count = 0 then Exit;

  ddwriteln('PGIVIGNETTES : Rapport / Modele =' + FModele);
  ddwriteln('PGIVIGNETTES : Rapport / Tip =' + FTip);
  ddwriteln('PGIVIGNETTES : Rapport / Nature =' +FNat);

  if (FModele = '') or (FNat = '') or (FTip = '') or (FLanguePrinc = '') then begin
    MessageErreur := TraduireMemoire('L''�tat n''est pas renseign�.');
    Exit;
  end;


  T_LANCEETATTOB := TOB.Create('T_LANCEETATTOB', TobResponse, -1);
  T_LANCEETATTOB.AddChampSupValeur('CODEETAT', FModele);
  T_LANCEETATTOB.AddChampSupValeur('TYPEETAT', FTip);
  T_LANCEETATTOB.AddChampSupValeur('NATUREETAT', FNat);
  T_LANCEETATTOB.AddChampSupValeur('LANGUEPRINC', FLanguePrinc);
  T_LANCEETATTOB.AddChampSupValeur('SQL', '');
  T_LANCEETATTOB.AddChampSupValeur('TITRE', '');
  T_LANCEETATTOB.AddChampSupValeur('TOB', 'TOBTRAITEMENT');

  T := TOB.Create('DONNEESBIS', T_LANCEETATTOB, -1);
  T.Dupliquer(TobDonnees, True, True);

end;

{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.GetVignetteZoom(aDom, aNom, aCaption : string; aAncetre : TVAncetreForm = vaf_Vierge) : TOB;
{---------------------------------------------------------------------------------------}
begin
  Result := nil;
  if (aDom = '') or (aNom = '') then Exit;

  Result := TOB.Create('T_ZOOM', TobResponse, -1);
  Result.AddChampSupValeur('DOMAIN'  , aDom);
  Result.AddChampSupValeur('FORMNAME', aNom);
  Result.AddChampSupValeur('ANCETRE' , TVAncetreToStr(aAncetre));
  Result.AddChampSupValeur('CAPTION' , aCaption);
  TOB.Create('T_LINKDATA', Result, -1);
end;

{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.GetDevisePivot(SigleOk : Boolean) : string;
{---------------------------------------------------------------------------------------}
var
  Dev : string;
begin
  Dev := LookupCurrentSession.DevisePivot;
  if Dev = '' then Dev := GetParamSocSecur('SO_DEVISEPRINC', 'EUR');

  if SigleOk then begin
         if Dev = 'EUR' then Dev := '�'
    else if Dev = 'USD' then Dev := '$'
    else if Dev = 'GBP' then Dev := '�'
    else if Dev = 'JPY' then Dev := '�';
  end;
  Result := Dev;
end;

{31/05/06 : Gestion des d�placements de la date de r�f�rence
  Valeurs : J -> Jour
            N -> Semaine
            Z -> Quinzaine
            M -> Mois
            B -> Bimestre
            T -> Trimestre
            Q -> Quadrimestre
            S -> Semestre
            A -> Ann�e
            E -> Exercice;
{---------------------------------------------------------------------------------------}
procedure TAncetreVignettePlugIn.GereDeplacement;
{---------------------------------------------------------------------------------------}
var
  D : TDateTime;
begin
  {On est en d�placement de p�riode}
  if (Pos(PARAMPLUS, FParam) > 0) or (Pos(PARAMMOINS, FParam) > 0) then begin
    D := GetDateTime('FDATEDEBUT');
    {Par d�faut la date de d�but avec la date de r�f�rence}
    if D = iDate1900 then D := DateRef;

    {On se d�place en avant}
    if Pos(PARAMPLUS, FParam) > 0 then begin
      case Periode of
        'J' : D := PlusDate(D, +  1, 'J');
        'N' : D := PlusDate(D, +  7, 'J');
        'Z' : D := PlusDate(D, + 14, 'J');
        'M' : D := PlusDate(D, +  1, 'M');
        'B' : D := PlusDate(D, +  2, 'M');
        'T' : D := PlusDate(D, +  3, 'M');
        'Q' : D := PlusDate(D, +  4, 'M');
        'S' : D := PlusDate(D, +  6, 'M');
        'A' : D := PlusDate(D, +  1, 'A');
        'E' : D := PlusDate(D, +  1, 'A');
        else
          D := PlusDate (D, + 1, 'J');
      end;
    end
    {On se d�place en arri�re}
    else begin
      case Periode of
        'J' : D := PlusDate(D, -  1, 'J');
        'N' : D := PlusDate(D, -  7, 'J');
        'Z' : D := PlusDate(D, - 14, 'J');
        'M' : D := PlusDate(D, -  1, 'M');
        'B' : D := PlusDate(D, -  2, 'M');
        'T' : D := PlusDate(D, -  3, 'M');
        'Q' : D := PlusDate(D, -  4, 'M');
        'S' : D := PlusDate(D, -  6, 'M');
        'A' : D := PlusDate(D, -  1, 'A');
        'E' : D := PlusDate(D, -  1, 'A');
        else
          D := PlusDate (D, - 1, 'J');
      end;
    end;
    DateRef := D;

    {Mise � Jour du libell� p�riode}
    MajLibPeriode;
  end;

  {on r�initialise FDATEDEBUT avec la date de r�f�rence}
  SetCritereValue('FDATEDEBUT', DateRef);
end;

{31/05/06 : D�finition du libell� P�riode apr�s le calcul de la DateRef
{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.MajLibPeriode(aDate : TDateTime = 2) : string;
{---------------------------------------------------------------------------------------}
var
  D : string;
  c : string;
  s : string;
  A : Word;
  M : Word;
  J : Word;
  JS : Integer;
  NS : Integer;
  Maj : Boolean;
begin
  Maj := False;
  if aDate = 2 then begin
    aDate := DateRef;
    Maj := True;
  end;
  JS :=  DayofWeek(aDate);
  DecodeDate(aDate, A, M, J);

  case Periode of
    'J' : D := DateToStr(aDate); {Jour}
    'N' : begin {Semaine}
            NS := NumSemaine(aDate, IsLeapYear(A));
            {JP 05/10/06 : Le 1er janvier est dans la semaine 1 s'il y a encore
                           4 jours jusqu'au dimanche (compris), donc s'il est compris
                           entre le lundi et le jeudi; sinon c'est le premier lundi
                           de l'ann�e qui marque la premi�re semaine}
            if (NS > 2) and (aDate = DebutAnnee(aDate)) then
              D := 'Sem. ' + IntToStr(NS) + ' ' + IntToStr(A - 1)
            else
              D := 'Sem. ' + IntToStr(NS) + ' ' + IntToStr(A);
            {On fonctionne par num�ro de semaine, on modifie donc la date de R�f�rence.
             DayofWeek commence le Dimanche alors que la Num�rotation des semaines commence
             le lundi => +2 (JP 05/10/06)}
            aDate := aDate - JS + 2;
          end;
    'Z' : begin {Quinzaine}
            {On fonctionne par num�ro de semaine, on modifie donc la date de R�f�rence.
             DayofWeek commence le Dimanche}
            aDate := aDate - JS + 1;
            DecodeDate(aDate, A, M, J);
            if J < 10 then s := '0' + IntToStr(J)
                      else s := IntToStr(J);
            if M < 10 then c := '0' + IntToStr(M)
                      else c := IntToStr(M);
            D := s + '/' +  c + '-';

            DecodeDate(aDate + 14, A, M, J);
            if J < 10 then s := '0' + IntToStr(J)
                      else s := IntToStr(J);
            if M < 10 then c := '0' + IntToStr(M)
                      else c := IntToStr(M);
            D := D + s + '/' + c + '/' + Copy(IntToStr(A), 3, 2);
          end;
    'M' : begin {Mois}
            case M of
              1  : D := 'Janv.' + ' ' + IntToStr(A);
              2  : D := 'F�v.'  + ' ' + IntToStr(A);
              3  : D := 'Mars'  + ' ' + IntToStr(A);
              4  : D := 'Avril' + ' ' + IntToStr(A);
              5  : D := 'Mai'   + ' ' + IntToStr(A);
              6  : D := 'Juin'  + ' ' + IntToStr(A);
              7  : D := 'Juil.' + ' ' + IntToStr(A);
              8  : D := 'Ao�t'  + ' ' + IntToStr(A);
              9  : D := 'Sept.' + ' ' + IntToStr(A);
              10 : D := 'Oct.'  + ' ' + IntToStr(A);
              11 : D := 'Nov.'  + ' ' + IntToStr(A);
              12 : D := 'D�c.'  + ' ' + IntToStr(A);
            end;
            aDate := DebutDeMois(aDate);
          end;
    'B' : begin {Bimestre}
            if (M mod 2) = 1 then NS := (M + 1) div 2
                             else NS := M div 2;
            D := IntToStr(NS) + '� Trim. ' + IntToStr(A);
            JS := 2 * NS - 1; {le 1B commence au mois 1 (2 * 1 - 1) le 2B mois 3 (2 * 2 - 1) le 3B le mois 5 (2 * 3 - 1) ...}
            aDate := EncodeDate(A, JS, 1);
          end;
    'T' : begin {Trimestre}
            if M <= 3 then begin
              D := '1� Trim. ' + IntToStr(A);
              aDate := EncodeDate(A, 1, 1);
            end
            else if M <= 6 then begin
              D := '2� Trim. ' + IntToStr(A);
              aDate := EncodeDate(A, 4, 1);
            end
            else if M <= 9 then begin
              D := '3� Trim. ' + IntToStr(A);
              aDate := EncodeDate(A, 7, 1);
            end
            else begin
              D := '4� Trim. ' + IntToStr(A);
              aDate := EncodeDate(A, 10, 1);
            end;
          end;
    'Q' : begin {Quadrimestre}
            if M <= 4 then begin
              D := '1� Quad. ' + IntToStr(A);
              aDate := EncodeDate(A, 1, 1);
            end
            else if M <= 8 then begin
              D := '2� Quad. ' + IntToStr(A);
              aDate := EncodeDate(A, 5, 1);
            end
            else begin
              D := '3� Quad. ' + IntToStr(A);
              aDate := EncodeDate(A, 9, 1);
            end;
          end;
    'S' : begin {Semestre}
            if M <= 6 then begin
              D := '1� Semest. ' + IntToStr(A);
              aDate := EncodeDate(A, 1, 1);
            end
            else begin
              D := '2� Semest. ' + IntToStr(A);
              aDate := EncodeDate(A, 7, 1);
            end;
          end;
    'A' : begin {Ann�e}
            D := IntToStr(A);
            aDate := DebutAnnee(DateRef);
          end;
    'E' : begin
            D := GereExercice('EX_ABREGE');
            aDate := DateRef;
          end;
    else
      D := DateToStr(DateRef);
  end;

  if Maj then DateRef := aDate;
  {On r�initialise FDATEDEBUT avec la date de r�f�rence �ventuellement modifi�e}
  SetCritereValue('FDATEDEBUT', DateRef);
  SetControlValue('N1', D);
  Result := D;
end;

{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.GetPeriode : Char;
{---------------------------------------------------------------------------------------}
var
  ch : string;
begin
  if (FPeriode = '@') then begin
    ch := GetString('PERIODE', False);
    if Trim(ch) <> '' then FPeriode := ch[1]
                      else FPeriode := InitPeriode;
    SetControlValue('PERIODE', FPeriode);
    MajLibPeriode;
  end;
  Result := FPeriode;
end;

{---------------------------------------------------------------------------------------}
procedure TAncetreVignettePlugIn.SetPeriode(Value : Char);
{---------------------------------------------------------------------------------------}
begin
  if Value <> FPeriode then begin
    FPeriode := Value;
    SetControlValue('PERIODE', Value);
  end;
end;

{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.InitPeriode : Char;
{---------------------------------------------------------------------------------------}
begin
  {Pour initialiser la combo PERIODE}
  Result := 'M';
end;

{Traitement sp�cifique si la p�riode choisie est l'exercice
{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.GereExercice(Chp : string; aDate : TDateTime = 2) : string;
{---------------------------------------------------------------------------------------}
var
  Q : TQuery;
  S : string;
  Maj : Boolean;
begin
  Maj := False;
  if aDate = 2 then begin
    aDate := DateRef;
    Maj := True;
  end;

  S := 'SELECT EX_ABREGE, EX_DATEDEBUT, EX_DATEFIN, EX_ETATCPTA, EX_EXERCICE, EX_LIBELLE FROM EXERCICE ';
  S := S + 'WHERE "' + UsDateTime(aDate) + '" BETWEEN EX_DATEDEBUT AND EX_DATEFIN ';
  Q := OpenSelect(S);
  try
    if not Q.EOF then begin
      if Chp <> '' then Result := Q.FindField(Chp).AsString;
      if Maj then DateRef := Q.FindField('EX_DATEDEBUT').AsDateTime;
    end
    else begin
      {Pas d'exercice, on r�initialise la date de r�f�rence et on recommence}
      if Maj then 
        DateRef := iDate1900;
      Result := GereExercice(Chp);
    end;

  finally
    Ferme(Q);
  end;
end;

{---------------------------------------------------------------------------------------}
function TAncetreVignettePlugIn.GetCodeUser : string;
{---------------------------------------------------------------------------------------}
begin
  if FCodeUser = '' then
    FCodeUser := TobRequest.GetString('V_PGI.USER');
  Result := FCodeUser;
end;

{25/01/07 : Extrait de la base un document stock� par la Ged; SystemeOk : s'il s'agit de la Ged
            syst�me (YFILES / YFILEPARTS) ou bien de la GED transversale (YDOCUMENTS / YDOCFILES)}
{---------------------------------------------------------------------------------------}
procedure TAncetreVignettePlugIn.RecupDocument(NoGuid : string; SystemOk : Boolean = False);
{---------------------------------------------------------------------------------------}
var
  sExtension : string;
  sFileName  : string;
  TobDoc : TOB;
  TEnreg : TOB;
begin

  ddWriteLN('PGIVIGNETTES : RecupDocument : ' + TraduireMemoire('Recup�ration des informations de la GED'));
  if NoGuid = '' then begin
    MsgWarning := TraduireMemoire('Il n''y a pas de document attach�.');
    Exit;
  end;

 if V_GedFiles = nil then
 begin
    if V_PGI.RunFromLanceur then
      InitializeGedFiles(V_PGI.DefaultSectionDbName, nil)
    else
      InitializeGedFiles(V_PGI.DbName, nil);
 end;


// GP le 15/07/2008 : because ca passe plus en compil avec agl 7.2  V_GedFiles := TGedFiles.Create(nil);
  TobDoc := TOB.Create('Les documents', Nil, -1);
  try
    if SystemOk then
      {Chargement de l'enregistrement correspondant au GuidId}
      TobDoc.LoadDetailFromSQL('SELECT YFI_FILEGUID, YFI_FILENAME FROM YFILES  WHERE YFI_FILEGUID = "' + NoGuid + '"')
    else
      {Chargement de l'enregistrement correspondant au GuidId}
      TobDoc.LoadDetailFromSQL('SELECT YDO_DOCGUID, YDF_DOCGUID, YFI_FILEGUID, YFI_FILENAME ' +
                                     'FROM YDOCUMENTS ' +
                                     'LEFT JOIN YDOCFILES ON YDO_DOCGUID = YDF_DOCGUID ' +
                                     'LEFT JOIN YFILES ON YDF_FILEGUID = YFI_FILEGUID ' +
                                     'WHERE YDO_DOCGUID = "' + NoGuid + '" AND YDF_FILEROLE = "PAL"');

    if TobDoc.Detail.Count = 0 then begin
      MessageErreur := TraduireMemoire('Document n� ') + NoGuid + TraduireMemoire(' non trouv�.');
      Exit;
    end;

    {1 seul enregistrement, tant qu'on ne fait r�f�rence qu'� un fichier PRINCIPAL du document}
    TEnreg := TobDoc.Detail[0];

    {Ne peut th�oriquement arriver qu'en mode transversale}
    if TEnreg.GetString('YFI_FILEGUID') = '' then begin
      MessageErreur := TraduireMemoire('Pas de fichier associ� au document n� ') + TEnreg.GetValue('YDO_DOCGUID');
      Exit;
    end;

    {R�cup�ration du Guid syst�me}
    NoGuid := TEnreg.GetString('YFI_FILEGUID');
    {On r�cup�re l'extension du fichier stock�}
    sExtension := ExtractFileExt(TEnreg.GetValue('YFI_FILENAME'));
    {Si pas d'extension, le portail ne pourra pas savoir quelle application lancer pour lire le document}
    if sExtension = '' then begin
      MessageErreur := TraduireMemoire('Le fichier est de type inconnu.');
      Exit;
    end;

    {Composition du chemin de stockage sur le serveur}
    {06/04/07 : Je reprends le GUID pour que le nom du fichier soit unique et �viter des probl�mes
                de cache si YFI_FILENAME a le nom d'une autre enregsitrement : par exemple, en saisie
                par d�faut, YFI_FILENAME vaut toujours Image.Pdf et une fois la premi�re facture visualis�e
                le cache renvoie toujours le m�me pdf, m�me pour d'autres factures
    sFileName := LookupCurrentSession.eAglDocPath + 'Portail\' + TEnreg.GetValue('YFI_FILENAME');}
    sFileName := LookupCurrentSession.eAglDocPath + 'Portail\' + TEnreg.GetValue('YFI_FILEGUID') + '.PDF';
    {Suppression du fichier s'il existe}
    if FileExists(sFileName) then SysUtils.DeleteFile(sFileName);

    ddWriteLN('PGIVIGNETTES : RecupDocument : ' + TraduireMemoire('Avant extraction du document'));
    if V_GedFiles.Extract(sFileName, TEnreg.GetString('YFI_FILEGUID')) then begin
      PrepareFichier(sFileName);
      {if UpperCase(sExtension) = '.PDF' then
        TobResponse.AddChampSupValeur('PDF', '/Portail/' + TEnreg.GetValue('YFI_FILENAME'))
      else}
      ddWriteLN('PGIVIGNETTES : RecupDocument : ' + TraduireMemoire('Apr�s extraction du document'));
    end
    else
      MessageErreur := TraduireMemoire('Impossible d''extraire le fichier de la base.');

  finally
    TobDoc.Free;
// GP le 15/07/2008 : because ca passe en compil avec agl 7.2 MAIS on se dit que ce serait peut �tre mieux comme �a, ca d�pend, faut voir....
//    V_GedFiles.Free;
    FinalizeGedFiles ;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TAncetreVignettePlugIn.PrepareFichier(FileName: string);
{---------------------------------------------------------------------------------------}
var
  sExtension  : string;
  sNomFichier : string;
  sChemin     : string;
  PSource     : PChar;
  PDest       : PChar;
begin
  {Suppression du fichier s'il existe}
  ddWriteLN('PGIVIGNETTES : PrepareFichier : ' + TraduireMemoire('Recup�ration du Fichier'));
  if not FileExists(FileName) then begin
    MessageErreur := TraduireMemoire('Le fichier n''existe pas');
    Exit;
  end;

  {On r�cup�re le nom du fichier}
  sNomFichier := ExtractFileName(FileName);

  {On r�cup�re l'extension du fichier}
  sExtension := ExtractFileExt(sNomFichier);
  {Si pas d'extension, le portail ne pourra pas savoir quelle application lancer pour lire le document}
  if sExtension = '' then begin
    MessageErreur := TraduireMemoire('Le fichier est de type inconnu.');
    Exit;
  end;

  ddWriteLN('PGIVIGNETTES : PrepareFichier : ' + TraduireMemoire('Copie du fichier'));
  {Constituion du FileName d�finitif}
  sChemin := LookupCurrentSession.eAglDocPath + 'Portail\' + sNomFichier;
  {Si le fichier n'est pas sous root, on copy le fichier}
  if sChemin <> FileName then begin
    PSource := PChar(FileName);
    PDest   := PChar(sChemin);
    {Copie du fichier source}
    if not CopyFile(PSource, PDest, True) then begin
      MessageErreur := TraduireMemoire('Erreur lors de la copie du fichier');
      Exit;
    end;
  end;

  {On s'assure que la copie s'est bien passer}
  if not FileExists(sChemin) then begin
    ddWriteLN('PGIVIGNETTES : PrepareFichier : ' + TraduireMemoire('La copie du fichier a echoue'));
    MessageErreur := TraduireMemoire('La copie du Fichier a �chou�');
    Exit;
  end;

  TobResponse.AddChampSupValeur('FILE', '/Portail/' + sNomFichier);
  ddWriteLN('PGIVIGNETTES : RecupDocument : ' + '/Portail/' + sNomFichier);
end;

end.

