{***********UNITE*************************************************
Auteur  ...... : Bruno DUCLOS
Cr�� le ...... : 02/02/2007
Modifi� le ... :   /  /
Description .. : L'objet TAFO_LibelleAffaire permet de conserver une
Suite ........ : liste des codes affaires avec les libell�s correspondants
Suite ........ : Une instance de cet object est d�clar�e dans
Suite ........ : la classe : LaVariableGC (EntGC)
Suite ........ : L'objet est utilis� pour :
Suite ........ :   - Libell� de l'affaire dans les informations lignes
Suite ........ :   - Param�trage des �critures comptables
Suite ........ :
Suite ........ : L'objet TAFO_TiersParc permet de conserver une
Suite ........ : liste des tiers reli�s � des ligne de parc 
Mots clefs ... :
*****************************************************************}
unit UAFO_Affaire;

interface

uses
  UTob,
  Classes;

type
  TAFO_LibelleAffaire = class
    fAffaire: TStringList;
    constructor Create;
    destructor Destroy; override; 
    function Ajoute(pstAffaire: String): String;
    procedure AjouteParTob(ptbTob: TOB; pstChampAffaire: String); overload;
    procedure AjouteParTob(ptbTob: TOB; pstChampCode, pstChampLibelle: String); overload;
    function Cherche(pstAffaire: String; pboAjoute: Boolean): String;
    procedure Maj(pstAffaire, pstLibelle: String);
  private
  end;

  TAFO_TiersParc = class
    fTiers: TStringList;
    constructor Create;
    destructor Destroy; override;
    function Cherche(pstLigneAffaire, Affaire: String; Force: Integer): String;
    procedure Vide;
  private
  end;

  // GA_20080311_BDU_GA14560_DEBUT
  // Objet g�n�rique pour conserver des informations
  TAFO_AncetreInformation = class
  private
    FListe: TStringList;
    FForceRelecture: Boolean;
  public
    property ForceRelecture: Boolean read FForceRelecture Write FForceRelecture;
    constructor Create;
    destructor Destroy; override;
  end;

  // Objet qui va contenir les informations des ressources
  TAFO_ObjetInformationRessource = class
    FContenu: TOB;
  public
    property Contenu: TOB read FContenu Write FContenu;
    constructor Create;
    destructor Destroy; override;
  end;

  // Objet d'information sur les ressources
  TAFO_InformationRessource = class(TAFO_AncetreInformation)
  public
    constructor Create;
    destructor Destroy; override;
    function Cherche(Code: String; Champs: array of String): String;
  end;
  // GA_20080311_BDU_GA14560_FIN

implementation
uses
  {$IFNDEF DBXPRESS}
    dbtables,
  {$ELSE}
    {$ifndef EAGLCLIENT}
      uDbxDataSet,
    {$ENDIF}
  {$ENDIF}
  HCtrls,
  SysUtils;

{***********A.G.L.***********************************************
Auteur  ...... : BDU
Cr�� le ...... : 02/02/2007
Modifi� le ... : 02/02/2007
Description .. : Ajoute le libell� d'une affaire
Suite ........ :
Suite ........ : pstAffaire : Code de l'affaire qu'il faut ajouter
Mots clefs ... :
*****************************************************************}
function TAFO_LibelleAffaire.Ajoute(pstAffaire: String): String;
var
  vqrRequete: TQuery;
begin
  Result := '';
  vqrRequete := OpenSQL('SELECT AFF_LIBELLE FROM AFFAIRE WHERE AFF_AFFAIRE = "' + pstAffaire + '"', True);
  try
    if not vqrRequete.EOF then
    begin
      // Ajoute le r�sultat sous la forme CODE AFFAIRE = LIBELLE AFFAIRE dans la liste
      fAffaire.Add(Format('%s=%s', [pstAffaire, vqrRequete.Fields[0].AsString]));
      Result := vqrRequete.Fields[0].AsString;
    end;
  finally
    Ferme(vqrRequete);
  end;
end;

constructor TAFO_LibelleAffaire.Create;
begin
  inherited Create;
  fAffaire := TStringList.Create;
  // Chaque affaire ne sera pr�sente dans la liste qu'une seule fois
  fAffaire.Duplicates := dupIgnore;
  fAffaire.Sorted := True;
end;

destructor TAFO_LibelleAffaire.Destroy;
begin
  FreeAndNil(fAffaire);
  inherited Destroy;
end;

{***********A.G.L.***********************************************
Auteur  ...... : BDU
Cr�� le ...... : 02/02/2007
Modifi� le ... : 02/02/2007
Description .. : Retourne le libell� d'une affaire
Suite ........ :
Suite ........ : pstAffaire : Code de l'affaire dont on cherche le libell�
Suite ........ : pboAjoute : Si TRUE, ajoute l'affaire si elle n'existe pas
Mots clefs ... :
*****************************************************************}
function TAFO_LibelleAffaire.Cherche(pstAffaire: String; pboAjoute: Boolean): String;
var
  vinBoucle: Integer;
begin
  Result := '';
  // Recherche l'index de l'affaire
  vinBoucle := fAffaire.IndexOfName(pstAffaire);
  if vinBoucle <> -1 then
    // Il est diff�rent de -1, l'affaire a �t� trouv�e, on retourne son libell�
    Result := fAffaire.Values[fAffaire.Names[vinBoucle]]
  // Elle n'existe pas, on l'ajoute
  else if pboAjoute then
    Result := Ajoute(pstAffaire);
end;

{***********A.G.L.***********************************************
Auteur  ...... : BDU
Cr�� le ...... : 02/02/2007
Modifi� le ... : 02/02/2007
Description .. : Charge les libell�s des affaires pass�es dans la TOB
Suite ........ :
Suite ........ : ptbTob : TOB contenant au moins un champ avec le code affaire
Suite ........ : pstChampAffaire : Nom du champ contenant le code affaire
Mots clefs ... :
*****************************************************************}
procedure TAFO_LibelleAffaire.AjouteParTob(ptbTob: TOB;
  pstChampAffaire: String);
var
  vinBoucle: Integer;
begin
  for vinBoucle := 0 to ptbTob.Detail.Count - 1 do
    // On lance la recherche et on demande l'ajout si pas encore dans la liste
    Cherche(ptbTob.Detail[vinBoucle].GetString(pstChampAffaire), True);
end;

{***********A.G.L.***********************************************
Auteur  ...... : BDU
Cr�� le ...... : 02/02/2007
Modifi� le ... :   /  /
Description .. : Charge les libell�s des affaires pass�es dans la TOB
Suite ........ : Le libell� est pr�sent dans la TOB
Suite ........ :
Suite ........ : ptbTob : TOB contenant au moins deux champs
Suite ........ : avec le code affaire et le libell�
Suite ........ : pstChampCode : Nom du champ contenant le code affaire
Suite ........ : pstChampLibelle : Nom du champ contenant le libell�
Mots clefs ... :
*****************************************************************}
procedure TAFO_LibelleAffaire.AjouteParTob(ptbTob: TOB; pstChampCode,
  pstChampLibelle: String);
var
  vinBoucle: Integer;
begin
  for vinBoucle := 0 to ptbTob.Detail.Count - 1 do
  begin
    // On lance la recherche mais on ne demande pas l'ajout
    if Cherche(ptbTob.Detail[vinBoucle].GetString(pstChampCode), False) = '' then
      // L'ajout est effectu� maintenant SANS requ�te SQL puisque tout est dans la TOB
      fAffaire.Add(Format('%s=%s', [ptbTob.Detail[vinBoucle].GetString(pstChampCode),
       ptbTob.Detail[vinBoucle].GetString(pstChampLibelle)]));
  end;
end;

procedure TAFO_LibelleAffaire.Maj(pstAffaire, pstLibelle: String);
var
  vinBoucle: Integer;
begin
  vinBoucle := fAffaire.IndexOfName(pstAffaire);
  if vinBoucle <> -1 then
    fAffaire.Delete(vinBoucle);
  fAffaire.Add(Format('%s=%s', [pstAffaire, pstLibelle]));
end;

{ TAFO_TiersParc }

function TAFO_TiersParc.Cherche(pstLigneAffaire, Affaire: String; Force: Integer): String;
var
  X: Integer;
  S: String;
  Q: TQuery;
begin
  Result := '';
  X := fTiers.IndexOfName(Format('%s', [pstLigneAffaire]));
  if (X <> -1) and (Force > 0) then
  begin
    fTiers.Delete(X);
    X := -1;
  end;
  if X = -1 then
  begin
    S := Format('SELECT ##TOP 1## WPC_TIERS,WPN_ARTICLEPARC FROM WPARC ' +   // gm 02/07/07 ajout article parc pour SIC
      'INNER JOIN WPARCNOME ON (WPC_IDENTIFIANT = WPN_IDENTPARC) ' +
      'WHERE WPN_AFFAIRE = "%s" ' +
      'AND WPN_REFLIGNEAFF = "%s"',
      [Affaire, pstLigneAffaire]);
    Q := OpenSQL(S, True);
    try
      if not Q.EOF then
      begin
        Result := Q.FindField('WPC_TIERS').AsString + '/'+ Q.FindField('WPN_ARTICLEPARC').AsString ;
        fTiers.Add(Format('%s=%s', [pstLigneAffaire, Result]));
      end
      else
        fTiers.Add(Format('%s=', [pstLigneAffaire]));
    finally
      Ferme(Q);
    end;
  end
  else
    Result := fTiers.Values[fTiers.Names[X]];
end;

constructor TAFO_TiersParc.Create;
begin
  fTiers := TStringList.Create;
  fTiers.Duplicates := dupIgnore;
  fTiers.Sorted := True;
end;

destructor TAFO_TiersParc.Destroy;
begin
  FreeAndNil(fTiers);
  inherited Destroy;
end;

procedure TAFO_TiersParc.Vide;
begin
  fTiers.Clear;
end;

{ TInformation }

// GA_20080311_BDU_GA14560_DEBUT
constructor TAFO_AncetreInformation.Create;
begin
  inherited;
  FListe := TStringList.Create;
  FForceRelecture := False;
end;

destructor TAFO_AncetreInformation.Destroy;
begin
  FreeAndNil(FListe);
  inherited;
end;

{ TInformationRessource }

function TAFO_InformationRessource.Cherche(Code: String; Champs: array of String): String;
var
  X: Integer;
  Tmp: TAFO_ObjetInformationRessource;

  function CalculResultat: String;
  var
    X: Integer;
    Separateur: String;
  begin
    Result := '';
    if Tmp.Contenu.Detail.Count > 0 then
    begin
      Separateur := '';
      for X := Low(Champs) to High(Champs) do
      begin
        Result := Format('%s%s%s', [Result, Separateur, Tmp.Contenu.Detail[0].GetString(Champs[X])]);
        Separateur := ' ';
      end;
    end;
  end;

begin
  Result := '';
  // On ne force pas la relecture
  if not ForceRelecture then
  begin
    X := FListe.IndexOf(Code);
    // L'�l�ment existe d�j� dans la liste
    if X <> -1 then
    begin
      // R�cup�ration de l'objet conteneur des informations
      Tmp := TAFO_ObjetInformationRessource(FListe.Objects[X]);
      if Assigned(Tmp) and (Tmp.Contenu.Detail.Count > 0) then
      begin
        // Calcul le r�sultat
        Result := CalculResultat;
        Exit;
      end;
    end;
  end;
  // L'�l�ment n'existe pas et le code n'est pas vide
  if Code <> '' then
  begin
    // Cr�ation du conteneur d'information
    Tmp := TAFO_ObjetInformationRessource.Create;
    // Le conteneur contient une TOB
    Tmp.Contenu := TOB.Create('une info', nil, -1);
    Tmp.Contenu.LoadDetailDbFromSQL('', Format('SELECT * FROM RESSOURCE ' +
      'WHERE ARS_RESSOURCE = "%s"', [Code]));
    if Assigned(Tmp) and (Tmp.Contenu.Detail.Count > 0) then
    begin
      FListe.AddObject(Code, Tmp);
      // Calcul le r�sultat
      Result := CalculResultat;
    end;
  end;
end;

constructor TAFO_InformationRessource.Create;
begin
  inherited;
end;

destructor TAFO_InformationRessource.Destroy;
var
  X: Integer;
  Tmp: TAFO_ObjetInformationRessource;
begin
  // Pour chaque �l�ment de la liste
  for X := 0 to FListe.Count - 1 do
  begin
    // On d�truit l'objet conteneur des informations
    Tmp := TAFO_ObjetInformationRessource(FListe.Objects[X]);
    FreeAndNil(Tmp);
  end;
  inherited;
end;

{ TAFO_ObjetInformationRessource }

constructor TAFO_ObjetInformationRessource.Create;
begin
  inherited;
  FContenu := TOB.Create('les informations', nil, -1);
end;

destructor TAFO_ObjetInformationRessource.Destroy;
begin
  FreeAndNil(FContenu);
  inherited;
end;
// GA_20080311_BDU_GA14560_FIN

end.
