{***********UNITE*************************************************
Auteur  ...... : Thierry Petetin & Denis Koza
Cr�� le ...... : 05/02/2003
Description .. : Unit� de gestion de pi�ce.
*****************************************************************}
unit GerePiece;
{

  Cette unit� permet de CREER (et uniquement ceci) des pi�ces PGI, � partir du contenu d'une TobData.
  (cf CreatePieceFromTob)

  . La TobData fournie en entr�e, doit �tre structur�e comme suit

    . Une TobMere contenant au minimum les champs sups suivants :

        NATUREPIECEG  => GP_NATUREPIECEG : Nature de la pi�ce � cr�er ('CC', 'CF', ....);
        TIERS         => GP_TIERS        : Code Tiers principal de la pi�ce
        AFFAIRE       => GP_AFFAIRE
        ETABLISSEMENT => GP_ETABLISSEMENT
        DOMAINE       => GP_DOMAINE

        La pr�sence de ces cinq champs sups est obligatoires, si l'un d'eux est manquant,
        une erreur est retourn�e, et la pi�ce n'est pas cr�e. (cf VerifTobDataEntete & GetChampsObligatoireEntete)

        DATEPIECE     => GP_DATEPIECE : si non renseign�e prend la date d'entr�e

        Si vous souhaitez mettre � jour le champ GP_XXXXXXX de la table des pi�ces, il suffit
        de cr�er un champ Sup XXXXXXX dans la TobData. (cf PutChampsSupInTobPiece)
        (Les champs obligatoires sont toujours exclus de cette copie ainsi que les champs faisant partie de la cl�)

        La r�gle est que le champs sups doit porter le nom du champ dans PIECE sans Pr�fixe

    . Des tobs filles correspondant aux lignes de la pi�ce. Ces Tobs Filles doivent au minimu contenir les champs
      suivants :
          CODEARTICLE     => GL_CODEARTICLE   : Code de l'article (sur 18)
          ARTICLE         => GL_ARTICLE       : Article (sur 35)
          QTEFACT         => GL_QTEFACT       : Quantit�
          QUALIFQTE       => GL_QUALIFQTEACH ou GL_QUALIFQTEVTE suivant si pi�ce d'achat ou de vente
          DATELIVRAISON   => GL_DATELIVRAISON : D�lai de livraison
          DEPOT           => GL_DEPOT         : d�pot de stock

      . Si un de ces champs est manquant dans une des filles de la TobDATA, la pi�ce n'est pas g�n�r�e et une erreur est
      retourn�e. (cf VerifTobDataLigne & GetChampsObligatoireLigne)
      . Si vous souhaitez mettre � jour le champ GL_XXXXXXX de la table des lignes, il suffit
      de cr�er un champ Sup XXXXXXX dans la TobData. (cf PutChampsSupInTobPiece)
      (Les champs obligatoires sont toujours exclus de cette copie ainsi que les champs de la cl�)

    . Pour chacune des TobsFilles on peut avoir (facultatif) des sous TobFilles contenant les N� de lots
      et/ou les num�ros de s�ries.
      Chacune de ces lignes est identifi�es par NomTable = 'SERIE' ou nomTable = 'LOT'

  . Si la pi�ce � pu �tre cr�e, la fonction renvoi true, et met � jour dans la tobData, la cl� de la pi�ce et des
    lignes qui ont �t� cr�e (par ajout de champ sup voir PutClePieceLigne)

  . En cas de probl�me, la fonction renvoi False et la TobData est mise � jour avec un champ sup error contenant
    le libell� de l'erreur (cf PutError)

  Limitations :

    . La TobData ne doit contenir qu'une seule m�re (Seulement une pi�ce g�n�r�e � la fois)
    . Pour l'instant, il n'y a que des CREATIONS de pi�ce (pas de transformation, ni de modification)

}
interface

uses
  Classes, SysUtils,
  uTob, hEnt1, hCtrls,
  EntGC, SaisUtil,
  wCommuns
  ,uEntCommun
  ,UtilConso,
  Db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  FactSpec, AffaireUtil, BTPUtil
  ;

type

  TypeCopie = (tcPiece, tcLigne);

  { Transaction N� de pi�ce }
  TValideNumPiece = Class
    TobPiece: TOB;
    CleDoc: R_CleDoc;
    Procedure GetNumPiece;
  end;

  { Transaction validation de la pi�ce }
  TValideLaPiece = Class
    TobPiece, TobTiers, TobAdresses, TobArticles, TobCatalogu, TobAffaire, TobConds, TobBases, TOBBasesL,TobPorcs, TobNomenclature,TOBOuvrage,TOBOuvragesP: Tob;
    TOBmetres : TOB;
    TobCpta, TobAnaP, TobAnaS, TobEches, TobAcomptes: Tob;
    TobLigneTarif, TobTarif: Tob;
    TobPiece_O: Tob;
    TobSerie, TobDesLots: Tob;
    TOBLigneRG : TOB;
    TOBpieceTrait : TOB;
    TOBSSTRAIT : TOB;
    TOBTimbres : TOB;
    TOBAffaireInterv : TOB;
    TOBPieceRG,TOBBasesRG : TOB;
    TOBSITUATIONS : TOB;
    TOBpieceRGP,TObbasesRGP,TobPiedBaseP : TOB;
    TOBLigneFac : TOB;
    TOBrepartTva : TOB;
    TOBresult : TOB;
    TOBVTECOL : TOB;
{V500_002_TS_28/10/2003}
    TobComms: Tob;
    { NDP : Mettre � jour TGerePieceRecordTobs en cas d'ajout de Tob }
    CleDoc: R_CleDoc;
    Action: TActionFiche;
    TransfoPiece, DuplicPiece: Boolean;
    NewNature, CodeEtat: String;
{V500_002_TS_28/10/2003}
    TypeCom: string;
    Dev: RDevise;
    GestionConso : TGestionConso;
    Procedure ValideMaPiece;
  private
    procedure InitToutModif;
    procedure ValideLaNumerotation;
    procedure CreerTob;
    procedure SupprimerTob;
    procedure ReajustePiecesPrecedente(TOBPiece, TOBArticles, TobNomenclature, TOBOuvrage : TOB);
  end ;

  { Record des tobs }
  TGerePieceRecordTobs = Record
                          TobData,
                          TobPiece, TobTiers, TobAdresses, TobArticles, TobCatalogu, TobAffaire,
                          TobConds, TobBases, TOBbasesL, TobPorcs, TobNomenclature,
                          TobLigneTarif, TobTarif: Tob;
                          TobCpta, TobAnaP, TobAnaS, TobEches, TobAcomptes,
                          TobPiece_O: Tob;
                          TobSerie, TobDesLots: Tob;
                          TOBpieceTrait : TOB;
                          TOBSSTRAIT : TOB;
{V500_002_TS_28/10/2003}
                          TobComms:Tob;
                          TOBmetres : TOB;
                          TOBPieceRG,TOBBasesRG : TOB;
                          TOBSITUATIONS : TOB;
                          TOBpieceRGP,TObbasesRGP : TOB;
                          TOBLigneFac : TOB;
                          TobPiedBaseP : TOB;
                          TOBrepartTva : TOB;
	                       end;


  { Fonction avant et apr�s validation de la piece }
	TFuncGerePiece = Function(Var RecordTobs: TGerePieceRecordTobs): Boolean;

  { Cr�ation d'une pi�ce � partir d'une tob de donn�es }
function CreatePieceFromTob(TobData: Tob; FuncBeforeValidePiece: TFuncGerePiece = nil;
                                          FuncAfterValidePiece: TFuncGerePiece = nil ;
                                          FuncBeforeGenPiece: TFuncGerePiece = nil;
                                          CodeEtat : String=''; TOBresult : TOB=nil): Boolean;
  { D�finit les champs obligatoires que doivent contenir les tobpiece & tobl }
  procedure GetChampsObligatoireEntete(List: TStrings);
  procedure GetChampsObligatoireLigne(List: TStrings);
  function wMajDevenirPiece(RefOrig, RefDest: string): integer;

implementation

uses
  ParamSoc
  ,FactComm
  ,FactUtil
  ,FactCalc
  ,FactCpta
  ,FactNomen
  ,StockUtil
  ,Ent1
  ,FactTiers
  ,FactPiece
  ,FactAdresse
  ,FactTob
  ,FactTarifs
  {$IFDEF EDI}
    ,EDITiers
    ,EDITransfert
  {$ENDIF EDI}
  ,FactTimbres
  ,FactOuvrage
  ,FactureBtp
  ,UtilTOBPiece
  ,Ucotraitance
  ,FactRG
  ,FactAdresseBTP      
  ,UCumulCollectifs
  ;

function wMajDevenirPiece(RefOrig, RefDest: string): integer;
var
  sSql, DatePiece, NaturePieceG, Souche, Numero, IndiceG : string;
begin
  DatePiece := ReadTokenSt(RefOrig);
  DatePiece := UsDateTime(StrToDate(copy(DatePiece,1,2) + '/' + copy(DatePiece,3,2) +  '/' + copy(DatePiece,5,4)));
  NaturePieceG := ReadTokenSt(RefOrig);
  Souche := ReadTokenSt(RefOrig);
  Numero := ReadTokenSt(RefOrig);
  IndiceG := ReadTokenSt(RefOrig);
  sSql := 'UPDATE PIECE SET GP_DEVENIRPIECE = "'+RefDest+'" '+
                      ' WHERE GP_DATEPIECE = "' + DatePiece + '"' +
                      ' AND   GP_NATUREPIECEG = "' + NaturePieceG + '"' +
                      ' AND   GP_SOUCHE = "' + Souche + '"' +
                      ' AND   GP_NUMERO = ' + Numero +
                      ' AND   GP_INDICEG = ' + IndiceG;

  Result := ExecuteSQL(sSql);
end;

// A VOIR : Devrait �tre dans FactUtil
procedure RazCleDoc(Var CleDoc: R_CleDoc);
begin
  FillChar(CleDoc, Sizeof(CleDoc), #0);
end;

// A VOIR : Devrait �tre dans FactUtil
function CreerTobTiers: Tob;
begin
  Result := TOB.Create('TIERS', nil, -1);
  Result.AddChampSup('RIB', False);
end;

// A VOIR : Devrait �tre dans FactUtil
function CreerTobAdresses: Tob;
begin
  Result := TOB.Create('LESADRESSES', nil, -1);
  {$IFNDEF EDI}  {TS� : GPAO EDI}
  if GetParamSoc('SO_GCPIECEADRESSE') then
  begin
    TOB.Create('PIECEADRESSE', Result, -1); {Livraison}
    TOB.Create('PIECEADRESSE', Result, -1); {Facturation}
  end
  else
  begin
    TOB.Create('ADRESSES', Result, -1) ; {Livraison}
    TOB.Create('ADRESSES', Result, -1) ; {Facturation}
  end;
  {$ELSE EDI}
    TOB.Create('PIECEADRESSE', Result, -1); {Livraison}
    TOB.Create('PIECEADRESSE', Result, -1); {Facturation}
  {$ENDIF EDI}
end;

// A VOIR : Devrait �tre dans FactUtil
procedure InitDevise(CleDoc: R_CleDoc; TobPiece, TobTiers: Tob; Var Dev: RDevise);
begin
  DEV.Code := TOBTiers.GetValue('T_DEVISE');
  if (DEV.Code = '') then DEV.Code := V_PGI.DevisePivot;
  GetInfosDevise(DEV);
  DEV.Taux:= GetTaux(DEV.Code, DEV.DateTaux, CleDoc.DatePiece);
  TOBPiece.PutValue('GP_DEVISE', DEV.Code);
  TOBPiece.PutValue('GP_TAUXDEV', DEV.Taux);
  TOBPiece.PutValue('GP_DATETAUXDEV', CleDoc.DatePiece);
end;

procedure ChargeCleDoc(Var CleDoc: R_CleDoc; TobData: Tob);
begin

  RazCleDoc(CleDoc);

  CleDoc.NaturePiece := TobData.GetValue('NATUREPIECEG');

  if CleDoc.NaturePiece = '' then exit;

  if TobData.FieldExists('DATEPIECE') then
    CleDoc.DatePiece := TobData.GetValue('DATEPIECE')
  else
    CleDoc.DatePiece := V_PGI.DateEntree;

end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Thierry Petetin
Cr�� le ...... : 11/02/2003
Description .. : Ecrit une erreur dans la TobData
*****************************************************************}
procedure PutError(TheTob: Tob; LibErreur: String);
begin
  if Assigned(TheTob) then
  begin
    TheTob.AddChampSupValeur('Error', LibErreur);
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Thierry Petetin
Cr�� le ...... : 14/02/2003
Description .. : Liste des champs obligatoire dans l'ent�te de la TobDATA
*****************************************************************}
procedure GetChampsObligatoireEntete(List: TStrings);
begin
  List.Add('NATUREPIECEG');
  List.Add('TIERS');
  List.Add('AFFAIRE');
  List.Add('ETABLISSEMENT');
//  List.Add('DOMAINE');
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Thierry Petetin
Cr�� le ...... : 14/02/2003
Description .. : Liste des champs obligatoire dans les lignes de la TobDATA
*****************************************************************}
procedure GetChampsObligatoireLigne(List: TStrings);
begin
  List.Add('CODEARTICLE');
  List.Add('ARTICLE');
  List.Add('QTEFACT');
//  List.Add('QUALIFQTE');
//  List.Add('DATELIVRAISON');
//  List.Add('DEPOT');
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Thierry Petetin
Cr�� le ...... : 11/02/2003
Description .. : V�rifie l'ent�te de la TobData
*****************************************************************}
function VerifTobDataEntete(TobData: Tob): Boolean;
var
  i: Integer;
  List: TStrings;
begin
  List := TStringList.Create;
  try
    { Liste des ChampsSup 'OBLIGATOIRE' devant figurer dans la tobPiece }
    GetChampsObligatoireEntete(List);
    { Test l''existence de ces champs }
    Result := True; i := -1;
    while (i < List.Count - 1) and Result do
    begin
      Inc(i);
      Result := TobData.FieldExists(List[i]);
      if not Result then
        PutError(TobData, TraduireMemoire('Le champ') + ' : ' + List[i] + ' ' + TraduireMemoire(' n''existe pas'));
    end;
  finally
    List.Free;
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Thierry Petetin
Cr�� le ...... : 11/02/2003
Description .. : V�rifie les lignes de la TobData
*****************************************************************}
function VerifTobDataLignes(TobData: Tob): Boolean;
var
  iLigne, iChamp: Integer;
  List: TStrings;
begin
  List := TStringList.Create;
  try
    { ChampsSup devant OBLIGATOIREMENT figurer dans les lignes de la TobData }
    GetChampsObligatoireLigne(List);
    { V�rifie la pr�sence des champs }
    Result := True; iLigne := - 1;
    while (iLigne < TobData.Detail.count - 1) and (Result) do { Boucle sur les lignes de la pi�ce }
    begin
      Inc(iLigne);
      iChamp := -1;
      while (iChamp < List.Count - 1) and Result do { Boucle sur la liste des champs }
      begin
        Inc(iChamp);
        Result := TobData.Detail[iLigne].FieldExists(List[iChamp]);
        if not Result then
          PutError(TobData.Detail[iLigne], TraduireMemoire('Le champ') + ' : ' + List[iChamp] + ' ' + TraduireMemoire(' n''existe pas'));
      end;
    end;
  finally
    List.Free;
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Thierry Petetin
Cr�� le ...... : 11/02/2003
Description .. : Ecrit les ChampsSup de la cl� de la pi�ce et de ses lignes
Suite ........ : dans la TobDATA
*****************************************************************}
Procedure PutClePieceLigne(TobPiece, TobData: Tob);
var
  i: Integer;
begin
  { pour l'ent�te }
  TobData.AddChampSupValeur('GP_NATUREPIECEG', TobPiece.GetValue('GP_NATUREPIECEG'));
  TobData.AddChampSupValeur('GP_SOUCHE', TobPiece.GetValue('GP_SOUCHE'));
  TobData.AddChampSupValeur('GP_NUMERO', TobPiece.GetValue('GP_NUMERO'));
  TobData.AddChampSupValeur('GP_INDICEG', TobPiece.GetValue('GP_INDICEG'));
  TobData.AddChampSupValeur('GP_DATEPIECE', TobPiece.GetValue('GP_DATEPIECE'));
  for i := 0 to TobPiece.Detail.Count - 1 do
  begin
    TobData.Detail[i].AddChampSupValeur('GL_NATUREPIECEG', TobPiece.Detail[i].GetValue('GL_NATUREPIECEG'));
    TobData.Detail[i].AddChampSupValeur('GL_SOUCHE', TobPiece.Detail[i].GetValue('GL_SOUCHE'));
    TobData.Detail[i].AddChampSupValeur('GL_NUMERO', TobPiece.Detail[i].GetValue('GL_NUMERO'));
    TobData.Detail[i].AddChampSupValeur('GL_INDICEG', TobPiece.Detail[i].GetValue('GL_INDICEG'));
    TobData.Detail[i].AddChampSupValeur('GL_NUMLIGNE', TobPiece.Detail[i].GetValue('GL_NUMLIGNE'));
    TobData.Detail[i].AddChampSupValeur('GL_DATEPIECE', TobPiece.Detail[i].GetValue('GL_DATEPIECE'));
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Thierry Petetin
Cr�� le ...... : 14/02/2003
Description .. : Copie des champs sups de la tobData vers une tobPiece.
Description .. : <!> Les champs obligatoires ne sont pas copi�s
Description .. : <!> Les champs faisant partie de la cl�1 de la table ne sont pas copi�s
*****************************************************************}
procedure PutChampsSupInTobPiece(TobSource: Tob; PrefixeCible: String; TobCible: Tob);
var
  i: Integer;
  NomChamp, s, Clef1: String;
  Oblig: TStrings;

  function PutChamp(NomChamp: String; iChamp: Integer): boolean;
  begin
    Result := False;
    if wExistFieldInDechamps(NomChamp) then
    begin
      if TobCible.FieldExists(NomChamp) then
      begin
        TobCible.PutValue(Nomchamp, TobSource.GetValeur(iChamp));
        Result := True;
      end;
    end;
  end;

begin
  Oblig := TStringList.Create;
  try
    { R�cup�re la liste des champs obligatoire }
    if PrefixeCible = 'GP' then
      GetChampsObligatoireEntete(Oblig)
    else if PrefixeCible = 'GL' then
      GetChampsObligatoireLigne(Oblig);
    { Ajoute les champs de la cl� de la table }
    Clef1 := wGetFieldsClef1(PrefixeToTable(PrefixeCible));
    s := ReadTokenPipe(Clef1, ',');
    while Clef1 <> '' do
    begin
      s := Trim(UpperCase(s));
      Oblig.add(s);
      s := ReadTokenPipe(Clef1, ',');
    end;
    { Copie des champs }
    for i := 1000 to (1000 + TobSource.ChampsSup.Count - 1) do
    begin
      if Oblig.IndexOf(TobSource.GetNomChamp(i)) = - 1 then
      begin
        { Regarde si le champSup existe dans la TobCible }
        NomChamp := PrefixeCible + '_' + TobSource.GetNomChamp(i);
        if not PutChamp(NomChamp, i) and (PrefixeCible = 'GL') then      
        begin
          NomChamp := 'GLC_' + TobSource.GetNomChamp(i);
          PutChamp(NomChamp, i);
        end;
      end;
    end;
  finally
    Oblig.Free;
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Thierry Petetin
Cr�� le ...... : 14/02/2003
Description .. : Copie les tobs dans le Record pour la fonction avant
Suite ........ : validation de la piece
*****************************************************************}
procedure PutTobsInRecord(ObjValide: TValideLaPiece; TobData:Tob; var RecordTobs: TGerePieceRecordTobs);
begin
  RecordTobs.TobData          := TobData;
  RecordTobs.TobPiece         := ObjValide.TobPiece;
  RecordTobs.TobTiers         := ObjValide.TobTiers;
  RecordTobs.TobAdresses      := ObjValide.TobAdresses;
  RecordTobs.TobArticles      := ObjValide.TobArticles;
  RecordTobs.TobCatalogu      := ObjValide.TobCatalogu;
  RecordTobs.TobAffaire       := ObjValide.TobAffaire;
  RecordTobs.TobTarif         := ObjValide.TobTarif;
  RecordTobs.TobLigneTarif    := ObjValide.TobLigneTarif;
  RecordTobs.TobConds         := ObjValide.TobConds;
  RecordTobs.TobBases         := ObjValide.TobBases;
  RecordTobs.TobBasesL        := ObjValide.TobBasesL;
  RecordTobs.TobPorcs         := ObjValide.TobPorcs;
  RecordTobs.TobNomenclature  := ObjValide.TobNomenclature;
  RecordTobs.TobCpta          := ObjValide.TobCpta;
  RecordTobs.TobAnaP          := ObjValide.TobAnaP;
  RecordTobs.TobAnaS          := ObjValide.TobAnaS;
  RecordTobs.TobEches         := ObjValide.TobEches;
  RecordTobs.TobAcomptes      := ObjValide.TobAcomptes;
  RecordTobs.TobPiece_O       := ObjValide.TobPiece_O;
  RecordTobs.TobPieceRG       := ObjValide.TobPieceRG;
  RecordTobs.TobBasesRG       := ObjValide.TobBasesRG;
  RecordTobs.TOBSITUATIONS    := ObjValide.TOBSITUATIONS;
  RecordTobs.TOBpieceRGP      := ObjValide.TOBpieceRGP;
  RecordTobs.TObbasesRGP      := ObjValide.TObbasesRGP;
  RecordTobs.TOBLigneFac      := ObjValide.TOBLigneFac;
  RecordTobs.TobPiedBaseP      := ObjValide.TobPiedBaseP;
  RecordTobs.TOBrepartTva     := ObjValide.TOBrepartTva;
{V500_002_TS_28/10/2003}
  RecordTobs.TobComms         := ObjValide.TobComms;
end;

procedure SetAdressefacturation (CodeTiersFac : string; TOBpiece,TOBAdresses : TOB);
begin
  GetAdrFromCode(TOBAdresses.Detail[1], CodeTiersFac) ;
  if GetParamSoc('SO_GCPIECEADRESSE') then TOBPiece.PutValue('GP_NUMADRESSEFACT', +2)
  else TOBPiece.PutValue('GP_NUMADRESSEFACT', -2);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Thierry Petetin & Denis Koza
Cr�� le ...... : 07/02/2003
Description .. : Cr�ation d'une pi�ce � partir d'une tob de donn�es
*****************************************************************}
function CreatePieceFromTob(TobData: Tob; FuncBeforeValidePiece: TFuncGerePiece = nil;
                                          FuncAfterValidePiece: TFuncGerePiece = nil ;
                                          FuncBeforeGenPiece: TFuncGerePiece = nil;
                                          CodeEtat : String=''; TOBresult : TOB=nil): Boolean;
var
  TobLigne, TobArt, TobC,TOBP,TOBRG: Tob;
  TOBmetres,TOBA : TOB;
  CodeAffaire, Etablissement, Domaine: String;
  CodeTiers,CodeTiersFac : String;
  EnHT, SaisieContre: Boolean;
  RechTiers: T_RechTiers;
  i: Integer;
  V: TValideLaPiece;
  ValideNumPiece: TValideNumPiece;
  Error: TIoErr;
  Ok: Boolean;
  RecordTobs: TGerePieceRecordTobs;
  //----- REPRISE DE DONNEES DE FACTURATION (voir SPINNAKER)
  DejaFacture : double;
  CumulRG : double;
  CumulRBF : double; // retenue de bonne fin
  MtCaution : double;
  NumCaution : string;
  NumSit : integer;
  NumFacSit : string;
  DateDerSit : TdateTime;
  MtCautionconsomme : double;
  Autoliquidation : boolean;
  Commercial : string;
  // ----------------------------------------

begin
  Result := False;
  Autoliquidation := false;
  if Assigned(TobData) then
  begin
    V := TValideLaPiece.Create;
    try
      V.TOBresult := TOBresult;
      { V�rification de la structure de la TobData }
      if VerifTobDataEntete(TobData) and VerifTobDataLignes(TobData) then
      begin
        { Cr�ation des Tobs }
        V.CreerTob;
        if Assigned(FuncBeforeGenPiece) then
        begin
          PutTobsInRecord(V, TobData, RecordTobs);
          Ok := TFuncGerePiece(FuncBeforeGenPiece)(RecordTobs);
          if not Ok then V_PGI.ioerror := oeUnknown;
        end;
        { Chargement de la cl� de la pi�ce }
        ChargeCleDoc(V.CleDoc, TobData);
        //FV1 : On peut cr�er une pi�ce alors que la nature de pi�ce n'est pas renseign�e !!!!
        if V.CleDoc.NaturePiece = '' then exit;
        { R�cup�re les donn�es de l'ent�te de la TobData (champs obligatoires) }
        CodeTiers     := TobData.GetValue('TIERS');
        CodeAffaire   := TobData.GetValue('AFFAIRE');
        Etablissement := TobData.GetValue('ETABLISSEMENT');
        Domaine       := TobData.GetValue('DOMAINE');
        Commercial := '';
        if TOBData.FieldExists ('APPORTEUR') then Commercial := TOBData.GetString ('APPORTEUR');
        CodeTiersFac  := CodeTiers;
        if TOBData.FieldExists('TIERSFAC') then CodeTiersFac  := TOBData.getString('TIERSFAC'); // difference entre CF et Devis
        if TOBData.FieldExists('AUTOLIQUIDATION') then Autoliquidation := TOBData.GetBoolean('AUTOLIQUIDATION');
        EnHT          := False;
        SaisieContre  := False;
        { Initialise la TobPiece }
        V.TobPiece := CreerTOBPieceVide(V.CleDoc, CodeTiers, CodeAffaire, Etablissement, Domaine, EnHT, SaisieContre);
        if Assigned(V.TobPiece) then
        begin
          { Copie les champs sup XXXX de la tobData dans GP_XXXX de la TobPiece }
          PutChampsSupInTobPiece(TobData, 'GP', V.TobPiece);
          { Gestion du gp_NumOrdre }
          EvaluerMaxNumOrdre(V.TOBPiece);
          if V.TOBPieceRG.detail.count > 0 then ReajusteNumOrdre (V.TOBPiece,V.TOBPieceRg);
          { Rempli la TobTiers }
          RechTiers := RemplirTobTiers(V.TobTiers, CodeTiers, V.CleDoc.NaturePiece, True);
          if RechTiers = trtOk then
          begin
            { Divers sur la TobPiece }
            V.TobPiece.PutValue('GP_TVAENCAISSEMENT', PositionneExige(V.TobTiers));
            V.TobPiece.PutValue('GP_REMISEPIED', V.TOBTiers.GetValue('T_REMISE'));
{V500_002_TS_28/10/2003 D�but}
            V.TypeCom := GetInfoParPiece(V.CleDoc.NaturePiece, 'GPP_TYPECOMMERCIAL');
            if V.TypeCom = '' then if ctxFO in V_PGI.PGIContexte then V.TypeCom := 'VEN' else V.TypeCom := 'REP';
            if Commercial <> ''  then V.TobPiece.PutValue('GP_REPRESENTANT', Commercial)
                                 else V.TobPiece.PutValue('GP_REPRESENTANT', V.TOBTiers.GetValue('T_REPRESENTANT'));
{V500_002_TS_28/10/2003 Fin}
            { Rempli la TobAdresse }
            TiersVersAdresses(V.TobTiers, V.TobAdresses, V.TobPiece);
            { Rempli la TobPorcs }
            TiersFraisVersPiedPort(V.TobPiece, V.TobTiers, V.TobPorcs);
            { Rempli le Record Devise }
            InitDevise(V.CleDoc, V.TobPiece, V.TobTiers, V.Dev);
            if CodeTiersFac <> CodeTiers then
            begin
              V.TOBpiece.setString('GP_TIERSFACTURE',CodeTiersFac);
              SetAdressefacturation (CodeTiersFac,V.TOBpiece,V.TobAdresses);
            end;
            { Cr�ation et chargement des lignes de la TobPiece }
            for i := 0 to TobData.Detail.Count - 1 do
            begin
              TobLigne := NewTOBLigne(V.TobPiece, 0);
              { Init de la tobligne avec les champs de la tobData }
              PutChampsSupInTobPiece(TobData.Detail[i], 'GL', TobLigne);
              { Initialise la ligne }
              PieceVersLigne(V.TobPiece, TobLigne);
              TobLigne.PutValue('GL_NUMORDRE', 0);
              if TobData.Detail[i].GetValue('TYPELIGNE')='ART' then
              begin
                if TobData.Detail[i].FieldExists('DEPOT') then TobLigne.PutValue('GL_DEPOT', TobData.Detail[i].GetValue('DEPOT'))
                                                          ELSE TobLigne.PutValue('GL_DEPOT', VH_GC.GCDepotDefaut);
                // Mise � jour code d�p�t entete depuis la premi�re ligne :
                if (i=0) then V.TOBpiece.PutValue('GP_DEPOT', TobLigne.GetValue('GL_DEPOT'));

                { Rempli la TobArticles }
                TobArt := ChargeTOBA(V.TobArticles, TobData.Detail[i].GetValue('ARTICLE'),TobLigne.GetValue('GL_DEPOT'));
                if TOBART = nil then Continue;
                { Article }
                TobLigne.PutValue('GL_TYPEREF', 'ART');

                TobLigne.PutValue('GL_ARTICLE', TobData.Detail[i].GetValue('ARTICLE'));

                if not TobData.Detail[i].FieldExists('CODEARTICLE') then TobLigne.PutValue('GL_CODEARTICLE', TobData.Detail[i].GetValue('CODEARTICLE'))
                                                                    else TobLigne.PutValue('GL_CODEARTICLE', copy(TobLigne.GetValue('GL_ARTICLE'),1,18));

                if TobData.Detail[i].FieldExists('REFARTSAISIE') then TobLigne.PutValue('GL_REFARTSAISIE', TobData.Detail[i].GetValue('REFARTSAISIE'))
                                                                 else TobLigne.PutValue('GL_REFARTSAISIE', TobLigne.GetValue('GL_CODEARTICLE'));
                { Quantit�s }
                if TobData.Detail[i].FieldExists('QTEFACT') then TobLigne.PutValue('GL_QTEFACT', TobData.Detail[i].GetValue('QTEFACT'))
                                                            else TobLigne.PutValue('GL_QTEFACT', 1);

                if not TobData.Detail[i].FieldExists('LIVDIRECTE') then TobLigne.PutValue('GL_IDENTIFIANTWOL', -1);
                if not TobData.FieldExists('QTESTOCK') then TobLigne.PutValue('GL_QTESTOCK', TobLigne.GetValue('GL_QTEFACT'));
                if not TobData.FieldExists('QTERESTE') then TobLigne.PutValue('GL_QTERESTE', TobLigne.GetValue('GL_QTESTOCK'));
                //
                if CtrlOkReliquat(TobLigne, 'GL') then TobLigne.PutValue('GL_MTRESTE', TobLigne.GetValue('GL_MONTANTHTDEV'));
                { Divers }
                TobLigne.PutValue('GL_PERIODE', GetPeriode(TobLigne.GetValue('GL_DATEPIECE')));
                TobLigne.PutValue('GL_SEMAINE', NumSemaine(TobLigne.GetValue('GL_DATEPIECE')));
                ///
                //FV1 : 23/08/2017 - FS#2648 - DELABOUDINIERE - Rendre les consos associ�es � un appel facturable
                if TobData.Detail[i].FieldExists('FACTURABLE') then TobLigne.PutValue('FACTURABLE', TobData.Detail[i].GetString('FACTURABLE'));
                ///
                //Si par malheur la tobArt est � nil �a plante grave !!!!!!
                ///
                ///
                if TobArt.GetValue('GA_STATUTART') = 'UNI' then
                   TobLigne.PutValue('GL_TYPEDIM', 'NOR')
                else
                   TobLigne.PutValue('GL_TYPEDIM', TobArt.GetValue('GA_STATUTART'));

                if TobData.FieldExists('ORIGINE') then
                  PreAffecteLigne(V.TobPiece, TobLigne, V.TobLigneTarif, TobArt, V.TobTiers, V.TobTarif, V.TobConds, V.TobAffaire, nil, nil, i + 1, V.Dev, TobLigne.GetValue('GL_QTEFACT'),True, false)
                else
                  PreAffecteLigne(V.TobPiece, TobLigne, V.TobLigneTarif, TobArt, V.TobTiers, V.TobTarif, V.TobConds, V.TobAffaire, nil, nil, i + 1, V.Dev, TobLigne.GetValue('GL_QTEFACT'),True);
                //
                TraiteLesOuvrages(nil,V.TOBPiece, V.TOBArticles, V.TOBOuvrage,nil,TobMetres,TobLigne.GetIndex+1, False, V.DEV, true);

                //Laisser ces lignes apr�s PreAffecteLigne :
                if TobData.Detail[i].FieldExists('QUALIFQTE') then
                begin
                if GetInfoParPiece(V.CleDoc.NaturePiece, 'GPP_VENTEACHAT') = 'VEN' then
                   TobLigne.PutValue('GL_QUALIFQTEVTE', TobData.Detail[i].GetValue('QUALIFQTE'))
                else
                   TobLigne.PutValue('GL_QUALIFQTEACH', TobData.Detail[i].GetValue('QUALIFQTE'));
                end;
                if TobData.Detail[i].FieldExists('LIBELLE') then TobLigne.PutValue('GL_LIBELLE', TobData.Detail[i].GetValue('LIBELLE'));
                if TobData.Detail[i].FieldExists('DATELIVRAISON') then TobLigne.PutValue('GL_DATELIVRAISON', TobData.Detail[i].GetValue('DATELIVRAISON'));
                if Not TobData.Detail[i].FieldExists('AVECPRIX') then
                begin
                  if TobData.FieldExists('ORIGINE') then
                    TarifVersLigne(TobArt, V.TobTiers, TobLigne, V.TobLigneTarif, V.TobPiece, V.TobTarif, True, True, V.Dev, False)
                  else
                    TarifVersLigne(TobArt, V.TobTiers, TobLigne, V.TobLigneTarif, V.TobPiece, V.TobTarif, True, True, V.Dev);
                end
                else
                begin
                  if TobData.Detail[i].FieldExists('DPA') then TobLigne.PutValue('GL_DPA', TobData.Detail[i].GetValue('DPA'));

                  if TobData.Detail[i].FieldExists('DPR') then TobLigne.PutValue('GL_DPR', TobData.Detail[i].GetValue('DPR'));

                  if TobData.Detail[i].FieldExists('PUHTDEV') then
                  begin
                    if (Pos(TobLigne.GetString('GL_TYPEARTICLE'),'OUV;ARP')>0) and (TobData.Detail[i].GetValue('PUHTDEV')<>0) then
                    begin
                      TraitePrixOuvrage(V.TOBPiece,TobLigne,V.TOBBases,V.TOBBasesL,V.TOBOuvrage, true, TobData.Detail[i].GetValue('PUHTDEV'),0,V.DEV,false);
                      ReinitCoefMarg (TobLigne,V.TOBOuvrage);
                    end else
                    begin
                      TobLigne.PutValue('GL_PUHTDEV', TobData.Detail[i].GetValue('PUHTDEV'));
                        TobLigne.PutValue('GL_COEFMARG', 0);
                    end;
                  end else
                  begin
                    if TobData.Detail[i].FieldExists('PUHT') then TobLigne.PutValue('GL_PUHT', TobData.Detail[i].GetValue('PUHT'));
                  end;
                end;
                if TobData.Detail[i].FieldExists('CODETVA') then
                  TobLigne.PutValue('GL_FAMILLETAXE1', TobData.Detail[i].GetValue('CODETVA'));
  {V500_002_TS_28/10/2003 D�but}
                AjouteRepres(TobLigne.GetValue('GL_REPRESENTANT'), V.TypeCom, V.TOBComms);
                CommVersLigne(V.TOBPiece, V.TOBArticles, V.TOBComms, i + 1, True);
  {V500_002_TS_28/10/2003 Fin}
                if CodeTiersFac <> CodeTiers then
                begin
                  TobLigne.setString('GL_TIERSFACTURE',CodeTiersFac);
                end;
                // --- gestion autoliquidation de TVA ---
                // if Autoliquidation then TobLigne.SetString('GL_FAMILLETAXE1',getparamSocSecur('SO_CODETVALIQUIDST',''));
                // --------------------------------------
                LoadTOBDispo (TobArt,true,'"'+TobLigne.GetString('GL_DEPOT')+'"');
                TobC := ChargeAjouteCompta(V.TobCpta, V.TobPiece, TobLigne, TobArt, V.TobTiers, nil, V.TobAffaire, True);
                PreVentileLigne(TobC, V.TobAnaP, V.TobAnaS, Tobligne);
              end else if TobData.Detail[i].GetValue('TYPELIGNE')='RG' then
              begin
                TobLigne.PutValue('GL_TYPELIGNE', 'RG');
                TobLigne.PutValue('GL_QTEFACT', 5);
                TobLigne.PutValue('GL_QTESTOCK', TobLigne.GetValue('GL_QTEFACT'));
                TobLigne.PutValue('GL_QTERESTE', TobLigne.GetValue('GL_QTESTOCK'));
                TobLigne.PutValue('GL_MTRESTE', TobLigne.GetValue('GL_MONTANTHTDEV'));
                TobLigne.PutValue('GL_PUHTDEV',  TobData.Detail[i].GetValue('PUHTDEV'));
                TobLigne.PutValue('GL_LIBELLE',  TobData.Detail[i].GetValue('LIBELLE'));
                TobLigne.PutValue('GL_DATELIVRAISON', TobData.Detail[i].GetValue('DATELIVRAISON'));
                TobLigne.PutValue('GL_PRIXPOURQTE', 100);
                TobLigne.PutValue('INDICERG', 1);
              end else if TobData.Detail[i].GetValue('TYPELIGNE')='COM' then
              begin
                TobLigne.PutValue('GL_TYPELIGNE', 'COM');
                TobLigne.PutValue('GL_LIBELLE',  TobData.Detail[i].GetValue('LIBELLE'));
              end;
            end;
            { NumOrdre }
            NumeroteLignesGC(nil, V.TobPiece);
            if (TOBData.GetDouble('BASERG')<>0) and (TOBData.GetDouble('CUMULRG')<> 0) or (TOBData.GetDouble('VALEURCAUTION')<> 0) then
            begin
              TOBRG := V.TobPiece.findFirst(['GL_TYPELIGNE'],['RG'],true);
              if TOBRG <> nil then
              begin
                TOBP := TOB.Create ('PIECERG',V.TOBPieceRG,-1);
                TOBP.SetInteger('PRG_NUMLIGNE',TOBRG.GeTInteger('GL_NUMORDRE'));
                TOBP.SetString('PRG_TYPERG','TTC'); // fixe artbitrairement par nous
                TOBP.SetDouble('PRG_TAUXRG',5);
                TOBP.SetDouble('PRG_MTHTRG',TobData.GetDouble('BASERG'));
                TOBP.SetDouble('PRG_MTHTRGDEV',TobData.GetDouble('BASERG'));
                TOBP.SetDouble('PRG_MTTTCRG',Arrondi(TobData.GetDouble('BASERG')*1.2,V_PGI.okdecV));
                TOBP.SetDouble('PRG_MTTTCRGDEV',TOBP.GetDouble('PRG_MTTTCRG'));
                if TOBData.GetDouble('VALEURCAUTION')<>0 then
                begin
                  TOBP.SetDouble('PRG_CAUTIONMTDEV',TOBData.GetDouble('VALEURCAUTION'));
                  TOBP.SetDouble('PRG_CAUTIONMT',TOBData.GetDouble('VALEURCAUTION'));
                  if TOBData.GetString('NUMCAUTION')<>'' then
                  begin
                    TOBP.SetString('PRG_NUMCAUTION',TOBData.GetString('NUMCAUTION'));
                    TOBP.SetString('PRG_BANQUECP',TOBData.GetString('BANQUECP'));
                  end;
                  if TOBP.getDouble('PRG_CAUTIONMT')<> 0 then
                  begin
                    MtCautionconsomme := Arrondi(TobData.GetDouble('DEJAFACTURE')+V.TOBrepartTva.getDouble('TVARGTOT'),V_PGI.okdecV);
                    TOBP.SetDouble('PRG_CAUTIONMTUDEV',MtCautionconsomme);
                    TOBP.SetDouble('PRG_CAUTIONMTU',MtCautionconsomme);
                  end;
                end;
                TOBP.SetString('PRG_APPLICABLE','X'); // fixe artbitrairement par nous
                TOBP.AddChampSupValeur ('INDICERG', 1);
                TOBP.addchampsupValeur('PIECEPRECEDENTE', '');
                TOBP.AddChampSupValeur ('NUMORDRE',0);
                TOBP.AddChampSupValeur ('CAUTIONUTIL',0);
                TOBP.AddChampSupValeur ('CAUTIONUTILDEV',0);
                TOBP.AddChampSupValeur ('CAUTIONAPRES',0);
                TOBP.AddChampSupValeur ('CAUTIONAPRESDEV',0);
              end;
            end;

            { TVA }
            PieceVersLigneExi(V.TobPiece, Nil);
            { Visa }
//              GetVisaInfoEtPositionne(V.TobPiece, V.TobTiers);
            { Enregistre la piece }
            V.Action := taCreat;   // On ne g�re que les cr�ations pour l'instant
            { Appel de la fonction avant lancement de la validation }
            Ok := True;
            if Ok then
            begin
              { Recalcul complet de la piece }
              CalculeMontantsDoc(V.TobPiece ,V.TOBOuvrage,false );
              // Reinit avant calcul
              V.TOBBases.clearDetail; V.TOBBasesL.clearDetail; ZeroFacture (V.TOBpiece);
              ZeroMontantPorts (V.TOBPorcs);
              if V.TOBOuvragesP <> nil then V.TOBOuvragesP.clearDetail;  //modif BRL 31/03/2010 suite pb pouchain
              // ---
              V.TOBVTECOL.ClearDetail;
              CalculFacture(V.TobAffaire ,V.TobPiece, V.TOBPieceTrait,V.TOBSSTRAIT, V.TOBOuvrage,V.TOBOuvragesP, V.TobBases, V.TobBasesL, V.TobTiers, V.TobArticles, V.TobPorcs, V.TOBPieceRG, V.TOBBasesRG,V.TOBVTECOL, V.Dev,False,taCreat);
              GereEcheancesGC (V.TobPiece,V.TobTiers,V.TobEches,V.TobAcomptes,V.TOBPieceRG,V.TOBpieceTrait,V.TobPorcs,TaCreat,V.Dev,false);
              // A voir (sert seulement � ValideLesAdresses }
              V.TobPiece_O.Dupliquer(V.TobPiece, True, True);
            end;
            if Assigned(FuncBeforeValidePiece) then
            begin
              PutTobsInRecord(V, TobData, RecordTobs);
              Ok := TFuncGerePiece(FuncBeforeValidePiece)(RecordTobs);
              if not Ok then V_PGI.ioerror := oeUnknown;
            end;
            if (ok) and (V.TOBpiece.GetString('GP_NATUREPIECEG')='CF') then
            begin
              // gestion des adresses de livraisons sur les CF
              LivAffaireVersAdresses (V.TOBAffaire,V.TOBAdresses,V.TOBPiece,false);
            end;
            if Ok then
            begin
              { ---- Incr�mente la souche ---- }
              ValideNumPiece := TValideNumPiece.Create;
              try
                ValideNumPiece.CleDoc := V.CleDoc;
                ValideNumPiece.TobPiece := V.TobPiece;
                V_PGI.IoError := Transactions(ValideNumPiece.GetNumPiece, 2);
                if V_PGI.IoError = oeOk then
                  V.CleDoc.NumeroPiece := ValideNumPiece.CleDoc.NumeroPiece;
              finally
                ValideNumPiece.Free;
              end;
              if V_PGI.IoError = oeOk then
              begin
                { Enregistre la pi�ce et ses lignes }
                V.CodeEtat := CodeEtat;
                Error := Transactions(V.ValideMaPiece, 0);
                if Error = oeOk then
                begin
                  { Ecrit les cl�s des pi�ces lignes dans la TobData }
                  PutClePieceLigne(V.TobPiece, TobData);
                  if Assigned(FuncAfterValidePiece) then
                  begin
                    PutTobsInRecord(V, TobData, RecordTobs);
                    TFuncGerePiece(FuncAfterValidePiece)(RecordTobs);
                  end;
                  Result := True;
                  if TOBresult <> nil then
                  begin
                    TOBA := TOB.Create ('PIECE',TOBresult,-1);
                    TOBA.dupliquer(V.Tobpiece,false,true);
                  end;
                end
                else
                  PutError(TobData, TraduireMemoire('Impossible d''enregistrer la pi�ce'));
              end
              else
                PutError(TobData, TraduireMemoire('Impossible d''obtenir un num�ro de pi�ce'));
            end
            else
              PutError(TobData, TraduireMemoire('G�n�ration abandonn�e'));
          end
          else
            PutError(TobData, TraduireMemoire('Le tiers') + ' : ' + CodeTiers + ' ' + TraduireMemoire('n''existe pas'));
        end
        else
          PutError(TobData, TraduireMemoire('Impossible de cr�er la TobPiece'));
      end;
    finally
      If tobData.NomTable = 'LA PIECE' then TobData.PutValue('CLEDOC', V.CleDoc.NaturePiece + ';' + V.CleDoc.Souche + ';' + IntToStr(V.CleDoc.NumeroPiece));
      V.SupprimerTob;
      V.Free;
    end;
  end;
end;

{ TValideNumPiece }
{ -------------------------------------------------------------------------------------------- }
{ ----------------------------------- Validation num�ro de pi�ce ----------------------------- }
{ -------------------------------------------------------------------------------------------- }
procedure TValideNumPiece.GetNumPiece;
var
	NewNum: Integer;
begin
  NewNum := SetNumberAttribution(TOBPiece.GetValue('GP_NATUREPIECEG'),TobPiece.GetValue('GP_SOUCHE'),TOBPiece.GetValue('GP_DATEPIECE'), 1);
  if (NewNum > 0) then CleDoc.NumeroPiece := NewNum;
end;

{ TValideLaPiece }
{ -------------------------------------------------------------------------------------------- }
{ ----------------------------------- Validation de la pi�ce --------------------------------- }
{ -------------------------------------------------------------------------------------------- }
procedure TValideLaPiece.CreerTob;
begin
  { TobPiece }
//  TobPiece := Tob.Create('PIECE', nil, -1);
//  AddLesSupEntete(TobPiece);
  TobPiece := nil; //
  TobPiece_O := TOB.Create('', nil, -1);
  AddLesSupEntete(TobPiece_O);
  TOBVTECOL := TOB.Create ('LES VTE COLL',nil,-1);
  { }
  TobTiers := CreerTobTiers;
  TobAdresses := CreerTobAdresses;
  TobArticles := Tob.Create('ARTICLES', nil, -1);
  TobOuvrage := Tob.Create('LES OUVRAGES', nil, -1);
  TobOuvragesP := Tob.Create('LES OUVRAGES', nil, -1);
  TobCatalogu := Tob.Create('LECATALOGUE', nil, -1);
  TobAffaire := Tob.Create('AFFAIRE', nil, -1);
  TobTarif := Tob.Create('TARIF', nil, -1);
  TobLigneTarif := Tob.Create('_ENTETE_', nil, -1); 
  TobConds := Tob.Create('CONDS', nil, -1);
  TobBases := TOB.Create('BASES', nil, -1);
  TobBasesL := TOB.Create('LES BASES LIGNE', nil, -1);
  TobPorcs := TOB.Create('PORCS', nil, -1);
  TobCpta := CreerTobCpta;
  TobAnaP := TOB.Create('', nil, -1);
  TobAnaS := TOB.Create('', nil, -1);
  TobEches := TOB.Create('Les ECHEANCES', nil, -1);
  TobNomenclature := TOB.Create('NOMENCLATURES', nil, -1);
  TobAcomptes := TOB.Create('', nil, -1);
{V500_002_TS_28/10/2003}
  TOBComms := TOB.Create('COMMERCIAUX', nil, -1);
  TOBTimbres := TOB.Create ('LES TIMBRES',nil,-1);
  TOBSSTRAIT := TOB.Create ('LES SOUS TRAITS',nil,-1);
  TOBAffaireInterv := TOB.Create ('LES CO-SOUSTRAITANTS',nil,-1);
  TOBPieceTrait := TOB.Create ('LES LIGNES EXTRENALISE',nil,-1);
  TOBPieceRG := TOB.Create ('LES PIECES RG',nil,-1);
  TOBBasesRG := TOB.Create ('LES BASES RG',nil,-1);
  TOBLigneRG := TOB.Create ('LES LIGNES RG',nil,-1);
  TOBSITUATIONS := TOB.Create ('LES SITUATIONS',nil,-1);
  TOBpieceRGP := TOB.Create ('LES PIECES RG P',nil,-1);
  TObbasesRGP := TOB.Create ('LES BASES RG P',nil,-1);
  TOBLigneFac := TOB.Create ('LES LIGNES FAC',nil,-1);
  TobPiedBaseP := TOB.Create ('LES PIED BASE PRE',nil,-1);
  TOBrepartTva := TOB.Create ('LA REPARTITION TVA',nil,-1);
  //
  TOBrepartTva.AddChampSupValeur ('BASETVATOT',0);
  TOBrepartTva.AddChampSupValeur('TVATOT',0);
  TOBrepartTva.AddChampSupValeur('TTCTOT',0);
  TOBrepartTva.AddChampSupValeur ('BASERGTOT',0);
  TOBrepartTva.AddChampSupValeur('TVARGTOT',0);
  TOBrepartTva.AddChampSupValeur('TTCRGTOT',0);
  //--
end;

procedure TValideLaPiece.SupprimerTob;
begin
  TOBVTECOL.free;
  TobPiece.Free;
  TobPiece_O.Free;
  TobTiers.Free;
  TobAdresses.Free;
  TobArticles.Free;
  TobCatalogu.Free;
  TobAffaire.Free;
  TobLigneTarif.Free;
  TobTarif.Free;
  TobConds.Free;
  TobBases.Free;
  TobBasesL.Free;
  TobPorcs.Free;
  TobCpta.Free;
  TobAnaP.Free;
  TobAnaS.Free;
  TobEches.Free;
  TobNomenclature.Free;
  TobAcomptes.Free;
  TOBOuvrage.free;
  TOBOuvragesP.free;
{V500_002_TS_28/10/2003}
  TOBComms.free;
  TOBTimbres.free;
  TOBSSTRAIT.free;
  TOBAffaireInterv.free;
  TOBPieceTrait.free;
  TOBPieceRG.free;
  TOBBasesRG.free;
  TOBLigneRG.free;
  TOBSITUATIONS.free;
  TOBpieceRGP.free;
  TObbasesRGP.free;
  TOBLigneFac.free;
  TobPiedBaseP.free;
  TOBrepartTva.free;
end;

// A VOIR : Dupliqu� de facture.pas
procedure TValideLaPiece.InitToutModif;
var
  NowFutur: TDateTime;
begin
  NowFutur := NowH;
  TOBVTECOL.SetAllModifie(true);
  TobPiece.SetAllModifie(True);
  TobOuvrage.SetAllModifie(True);
  TobOuvragesP.SetAllModifie(True);
  TobPiece.SetDateModif(NowFutur);
  TobAdresses.SetAllModifie(True);
  TobBases.SetAllModifie(True);
  TobBasesL.SetAllModifie(True);
  TobPorcs.SetAllModifie(True);
  InvalideModifTiersPiece(TobTiers);
  TobAnaP.SetAllModifie(True);
  TobAnaS.SetAllModifie(True);
  TobEches.SetAllModifie(True);
  TobAcomptes.SetAllModifie(True);
  TobNomenclature.SetAllModifie(True);
{V500_002_TS_28/10/2003}
  TobComms.SetAllModifie(True);
  TOBPieceRG.SetAllModifie(true)  ;
  TOBBasesRG.SetAllModifie(True)    ;
// A voir
//  TobSerie.SetAllModifie(True);
//  TobDesLots.SetAllModifie(True);
(*
  // Modif BTP
  TOBOuvrage.SetAllModifie(True)  ;
  TOBLIENOLE.SetAllModifie(true)  ;
  // --
*)
  TobLigneTarif.SetAllModifie(True); 
end;

// A VOIR : Dupliqu� de facture.pas
procedure TValideLaPiece.ValideLaNumerotation ;
Var
//  ind
  OldNum,NewNum : integer ;
  NaturePieceG : String ;
begin
  NaturePieceG:=TOBPiece.GetValue('GP_NATUREPIECEG');
  //if (NaturePieceG='TRE') or (NaturePieceG='TRV') then Exit;
  if ((Action = taCreat) or (TransfoPiece) or (DuplicPiece)) then
  begin
    OldNum:=TOBPiece.GetValue('GP_NUMERO') ;
    if Not SetDefinitiveNumber(TOBPiece, TOBBases, TOBBasesL, TOBEches, TOBNomenclature, TOBAcomptes, nil, nil, TobLigneTarif, CleDoc.NumeroPiece) then 
      V_PGI.IoError:=oePointage ; 
    if GetInfoParPiece(NaturePieceG, 'GPP_ACTIONFINI') = 'ENR' then TOBPiece.PutValue('GP_VIVANTE','-');
    NewNum:=TOBPiece.GetValue('GP_NUMERO');
    CleDoc.NumeroPiece := NewNum;
    if (OldNum <> NewNum) then
      MajAccRegleDiff(TOBPiece, TOBAcomptes, OldNum) ;
  end;
end;

procedure TValideLaPiece.ValideMaPiece;

  procedure GestionRgUnique(TOBPIECE, TOBPIECERG, TOBBASES, TOBBASESRG, TOBTIers, TOBAffaire, TOBLigneRG: TOB);
  var TOBL, TOBRG: TOB;
  Indice: integer;
  begin
  if TOBPieceRG = nil then exit;
  if TOBPiece.getValue('GP_RGMULTIPLE')='X' then exit;
  if TOBPIeceRG.detail.count > 0 then
  begin
    Indice := 0;
    repeat
      TOBRG := TOBPieceRG.detail[Indice];
      if TOBRG.GEtVAlue('PRG_TAUXRG') = 0 then TOBRG.free else Inc(Indice);
    until Indice >= TOBPieceRG.detail.count;
  end;
  if IsMultiIntervRg (TOBpieceTrait) then
  begin
    TOBL := TOBPIece.findfirst(['GL_TYPELIGNE'], ['RG'], true);
    if Assigned(TOBL) then
    begin
      DeleteTobLigneTarif(TobPiece, Tobl);
      TOBL.free;
    end;
    InsereLigneRGCot(TOBPIece, TOBPIeceRG, TOBBASES, TOBBASESRG, TOBTIers, TOBAffaire, TOBLigneRG, -1);
  end else if not RGMultiple (TOBPiece) then
  begin
    TOBL := TOBPIece.findfirst(['GL_TYPELIGNE'], ['RG'], true);
    if Assigned(TOBL) then
    begin
      DeleteTobLigneTarif(TobPiece, Tobl);
      TOBL.free;
    end;
    InsereLigneRG(TOBPIece, TOBPIeceRG, TOBBASES, TOBBASESRG, TOBTIers, TOBAffaire, TOBLigneRG, -1);
  end;
  end;

var
  OldEcr,OldStk : RMVT ;
  TobCatalogu, TOBL: Tob;
  i : Integer;
BEGIN
  TobCatalogu := nil;
  TransfoPiece := False;
  DuplicPiece := False;
  NewNature := '';
  FillChar(OldEcr,SizeOf(OldEcr),#0);   // ???
  FillChar(OldStk,SizeOf(OldStk),#0);   // ???

  GestionConso := TGestionConso.create;
  { Enregistrement nouvelle pi�ce }
  if V_PGI.IoError=oeOk then
  begin
    InitToutModif;
    ValideLaNumerotation;
    ValideLaCotation(TOBPiece, TOBBases, TOBEches);
    ValideLaPeriode(TOBPiece);
  end;
  if V_PGI.IoError = oeOk then GestionRgUnique(TOBPIECE, TOBPIECERG, TOBBASES, TOBBASESRG, TOBTIers, TOBAffaire, TOBLigneRG);
  if V_PGI.IoError=oeOk then
     ValideLesLignes(TOBPiece, TOBArticles, TobCatalogu, TobNomenclature, TOBOuvrage, nil, nil, False, False, False,True);
  if V_PGI.IoError=oeOk then
     ReajustePiecesPrecedente(TOBPiece, TOBArticles, TobNomenclature, TOBOuvrage);
  if V_PGI.IoError = oeOk then
    ValideLesOuv(TOBOuvrage, TOBPiece);
  if V_PGI.IoError=oeOk then
     ValideLesLignesCompl(TOBPiece, nil);
  if V_PGI.IoError = oeOk then ValideLesBases(TOBPiece,TobBases,TOBBasesL);
  if V_PGI.IoError=oeOk then
     ValideLesAdresses(TobPiece, TobPiece_O, TobAdresses);
  if V_PGI.IoError=oeOk then
     ValideLesArticles(TobPiece, TobArticles);
  if V_PGI.IoError=oeOk then
  begin
    if Assigned(TobCatalogu) then
      ValideLesCatalogues(TobPiece, TobCatalogu);
  end;
  if V_PGI.IoError=oeOk then
    ValideAnalytiques(TobPiece, TobAnaP, TobAnaS);
  if V_PGI.IoError=oeOk then
  begin
    if Action <> taCreat then
    begin
      if ((not DuplicPiece) and (not TransfoPiece)) then Exit;
    end;
    ValideleTiers(TOBPiece, TOBTiers);
  end;
  if V_PGI.IoError=oeOk then
  begin
    if not PassationComptable(TobPiece,TOBOuvrage ,TOBOuvragesP, TobBases, TOBBasesL,TobEches, TOBpieceTrait,TOBAffaireInterv,TobTiers, TobArticles, TobCpta, TobAcomptes
                             , TobPorcs, TOBPieceRG, TOBBasesRG, TOBanaP,TOBAnaS,nil,TOBVTECOL,Dev, OldEcr, OldStk, True) then
      V_PGI.IoError := oeLettrage;
  end;
  LibereParamTimbres;
// if V_PGI.IoError=oeOk then
//   ValideLesLots;
//  if V_PGI.IoError=oeOk then
//    ValideLesSeries;
  if V_PGI.IoError=oeOk then
    ValideLesAcomptes(TobPiece, TobAcomptes);
  if V_PGI.IoError=oeOk then
    ValideLesPorcs(TobPiece,TobPorcs) ;
  if V_PGI.IoError = oeOk then ValideLesRetenues(TOBPiece, TOBPieceRG);
  if V_PGI.IoError = oeOk then ValideLesBasesRG(TOBPiece, TOBBasesRG);

  if (V_PGI.IoError = oeOk) and (TOBVTECOL.detail.count >0) then
  begin
    PrepareInsertCollectif(TOBPiece, TOBVTECOL);
    if TOBVTECOL.detail.Count > 0 then
    begin
      if not TOBVTECOL.InsertDB(nil) then V_PGI.IOError := oeUnknown;
    end;
  end;
  if V_PGI.IoError=oeOk then
  begin
    if not TobPiece.InsertDBByNivel(False) then V_PGI.IoError:=oeUnknown;
  end;
  if V_PGI.IoError=oeOk then
  begin
    if not TobBases.InsertDB(nil) then V_PGI.IoError:=oeUnknown;
  end;
  if V_PGI.IoError=oeOk then
  begin
    if not TobBasesL.InsertDB(nil) then V_PGI.IoError:=oeUnknown;
  end;
  if V_PGI.IoError=oeOk then
  begin
    if not TobEches.InsertDB(nil) then V_PGI.IoError:=oeUnknown;
  end;
  if V_PGI.IoError=oeOk then
  begin
    if not TobAnaP.InsertDB(nil) then V_PGI.IoError:=oeUnknown;
  end;
  if V_PGI.IoError=oeOk then
  begin
    if not TobAnaS.InsertDB(nil) then V_PGI.IoError:=oeUnknown;
  end;
  if V_PGI.IoError=oeOk then
    ValideLesNomen(TobNomenclature);
  if V_PGI.IoError=oeOk then
    TobLigneTarif.InsertDB(Nil);
  {$IFDEF EDI}
  if V_PGI.IoError = oeOk then
    if GetInfoParPiece(CleDoc.NaturePiece, 'GPP_PIECEEDI') = 'X' then
      if IsEDITiers(TobPiece) then
        EDICreateETR(TobPiece, EDIGetFieldFromETS('ETS_CODEMESSAGE', EDIGetCleETS(TobPiece.GetValue('GP_TIERS'), TobPiece.GetValue('GP_NATUREPIECEG'))));
  {$ENDIF}

  if V_PGI.IoError = oeOk then
  begin
      MajTypeFact (TOBPiece, RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIRE')));
      MajAffaire(TOBPiece, nil, '00', 'VAL', TaCreat, False, False, CodeEtat);
  end;

  if V_PGI.IoError = oeOk then
  begin
    if pos(TOBPiece.GetValue ('GP_NATUREPIECEG'),'LBT;BFC;FF')>0  then
    begin
      for i := 0 to TOBPiece.Detail.Count - 1 do
      begin
        TOBL := TOBPiece.Detail[i];
        //FV1 : 14/10/2015 - Pas de g�n�tration des conso si lignes autres qu'Article
        if TOBL.GetValue('GL_TYPELIGNE') <> 'ART' then Continue;
        GestionConso.CreerConso(TOBL, '',TTcoCreat);
        end;
      GestionConso.MajTableConso;
    end;
  end;

  GestionConso.clear;
  GenereLivraisonClients(TOBPiece,taCreat,false,false,false,false,TOBresult);   
  GestionConso.free;
end;

procedure TValideLaPiece.ReajustePiecesPrecedente(TOBPiece, TOBArticles, TobNomenclature, TOBOuvrage: TOB);

  function IsPieceVivante (cledoc : r_cledoc) : Boolean;
  var Req : string;
  begin
    //REQ := 'SELECT 1 FROM LIGNE WHERE ' + WherePiece(cledoc, ttdLigne, true)+' AND GL_TYPELIGNE="ART" AND GL_VIVANTE="X"';
    //La pi�ce passait en Non vivante � partir du moment ou une seule ligne n'est plus vivante...
    Req := 'SELECT 1 FROM LIGNE WHERE GL_NATUREPIECEG="' + cledoc.NaturePiece;
    Req := Req + '" AND GL_SOUCHE="' + cledoc.Souche;
    Req := Req + '" AND GL_NUMERO= ' + IntToStr(CleDoc.NumeroPiece);
    Req := Req + '  AND GL_INDICEG=' + IntToStr(CleDoc.Indice);
    Req := Req + '  AND GL_TYPELIGNE="ART" AND GL_VIVANTE="X"';
    Result := ExisteSQL(Req);
  end;

var II : Integer;
    TOBL,TOBLO,TOBPieceO :  TOB;
    REQ : string;
    QQ : TQuery;
    cledoc : R_CLEDOC;
    colPlus,ColMOins : string;
    lastQteStock : Double;
    GereReliquat : Boolean;
begin
  //
  GereReliquat := (GetInfoParPiece(TOBPiece.GetString('GP_NATUREPIECEG'), 'GPP_RELIQUAT') = 'X');

  TOBPieceO := TOB.Create('PIECE',nil, -1);
  TOBLO := TOB.Create('LIGNE',nil,-1);

  TRY
    // mise ajour des quantit�s restantes dans la piece precedente + mise a jour du stock si necessaire
    for II := 0 to TOBPiece.Detail.count -1 do
    begin
      TOBL := TOBPiece.detail[II];
      if TOBL.GetString('GL_PIECEPRECEDENTE')='' then Continue;
      if TOBL.GetString('GL_TYPELIGNE')<>'ART' then Continue;
      //
      DecodeRefPiece(TOBL.GetString('GL_PIECEPRECEDENTE'),cledoc);
      //
      TOBPieceO.InitValeurs(false);      //
      REQ := 'SELECT * FROM PIECE WHERE ' + WherePiece(cledoc, ttdPiece, true);
      QQ := OpenSQL(REQ,True,1,'',true);
      if not QQ.eof then
      begin
        TOBPieceO.SelectDB('',QQ);
      end;
      //
      Ferme(QQ);
      //
      TOBLO.InitValeurs(false);
      REQ := 'SELECT * FROM LIGNE WHERE '+WherePiece(cledoc,ttdLigne ,True,true);
      QQ := OpenSQL(REQ,True,1,'',true);
      if not QQ.eof then
      begin
        TOBLO.SelectDB('',QQ);
        ColMoins := GetInfoParPiece(TOBLO.GetString('GL_NATUREPIECEG'), 'GPP_QTEMOINS');
        ColPlus := GetInfoParPiece(TOBLO.GetString('GL_NATUREPIECEG'), 'GPP_QTEPLUS');
        lastQteStock := TOBLO.GetDouble('GL_QTEFSTOCK');
        TOBLO.SetDouble('GL_QTESTOCK',TOBL.GetDouble('GL_QTEFACT'));
        MajQteStock (TOBLO,TOBArticles,TOBOuvrage,colPlus,ColMOins,False,1);
        TOBLO.SetDouble('GL_QTESTOCK',lastQteStock);
        if GereReliquat then
        begin
          if CtrlOkReliquat(TOBLO, 'GL') then
          Begin
            TOBLO.SetDouble('GL_MTRESTE',   TOBLO.GetDouble('GL_MTRESTE')-TOBL.GetDouble('GL_MONTANTHTDEV'));
            if TOBLO.GetDouble('GL_MTRESTE') = 0 then TOBLO.PutValue('GL_VIVANTE','-');
            TOBL.SetDouble('GL_MTRELIQUAT', TOBLO.GetDouble('GL_MTRESTE'));
          end
          Else
          begin
            TOBLO.SetDouble('GL_QTERESTE',TOBLO.GetDouble('GL_QTERESTE')-TOBL.GetDouble('GL_QTEFACT'));
            if TOBLO.GetDouble('GL_QTERESTE') = 0 then TOBLO.PutValue('GL_VIVANTE','-');
            TOBL.SetDouble('GL_QTERELIQUAT', TOBLO.GetDouble('GL_QTERESTE'));
          end;

        end;
        TOBLO.PutValue('Gl_DATEMODIF',V_PGI.DateEntree) ;
        TOBLO.UpdateDB(false);
        //
        TOBPieceO.PutValue('GP_DATEMODIF',V_PGI.DateEntree) ;
        if GetInfoParPiece(cledoc.NaturePiece, 'GPP_RELIQUAT') = '-' then
          TOBPieceO.PutValue('GP_VIVANTE','-')
        else
          if not IsPieceVivante(cledoc) then TOBPieceO.PutValue('GP_VIVANTE','-');
        //
        TOBPieceO.UpdateDB(false);
        //
      end;
      Ferme(QQ);
      //
    end;
  FINALLY
    TOBLO.Free;
    FreeAndNil(TOBPieceO);
  END;
end;

end.
