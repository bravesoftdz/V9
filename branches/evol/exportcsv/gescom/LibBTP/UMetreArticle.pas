unit UMetreArticle;

interface
uses {$IFDEF VER150} variants,{$ENDIF}
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Hctrls,
  ExtCtrls,
  StdCtrls,
  Mask,
  HEnt1,
  HMsgBox,
  EntGC,
  HSysMenu,
  Menus,
  lookup,
  FileCtrl,
  ComObj,
  ActiveX,
  olectnrs,
  {$IFDEF EAGLCLIENT}
  maineagl,
  {$ELSE}
  fe_main,
  db,
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  {$ENDIF}
  BTPUTIL,
  UtilFichiers,
  Dicobtp,
  UTOB,
  AffaireUtil,
  EtudesUtil,
  EtudesExt,
  SaisUtil,
  ParamSoc,
  Hstatus,
  UtilXlsBTP,
  EtudesStruct,
  EtudePiece,
  FactComm,
  CBPPath,
  ComCtrls;

Function ControlMetre(All : boolean = true): boolean;

type TMetreArt = class
  private
    ok_Affiche  : boolean;
    FichierXLS  : string;
    RepSauve    : string;
    RepMetre    : string;
    fusable     : boolean;
    frepert     : string;
    fOleExcel   : TOleContainer;
    fRepertBase : string;
    fRepertLocal: string;
    fNomMachine : string;
    fArticle    : string;
    fTypeArt    : string;
    fForm       : TForm;
    fTimer      : TTimer;
//    function CloseExcel (WithQuestion : boolean = true) : boolean;
    procedure SetArticle(Value: string);
    procedure SetTypeArticle(Value: string);
    function ControleXLS(Fichier: String; var Ok_CellVide : boolean): Boolean;
    procedure TimeElapsed (Sender : TObject);

  public
    constructor create(aowner: Tform; TabMetre : TTabSheet; OleExcel : ToleContainer); overload;
    constructor create; overload;
    destructor destroy; override;

    procedure duplic(Article: string);
    procedure ActiveOle;
    Procedure SauveMetres(Ok_Onglet : Boolean);
    procedure ModifMetres;
    procedure AddNewRecord;
    procedure SauveDim;
    procedure RestoreDim;
    procedure CloseXls;
    procedure DesactiveTimer;

    function validate(Article: string): boolean;
    function ValDec(Article: string): boolean;
    function Supprime(Article: string): boolean;
    function Annule: boolean;
    function FormatArticle(Article: String): string;
    function GesDoc(FromArticle: string; TypeArt: string): string;
    function CopieMetre(Article, NewArticle: string): boolean;
    function CopieVariable(Article, NewArticle: string): boolean;

    function SuppVariable(Article: string): boolean;

    property RepertBase: string read frepertBase;
    property Article: string read fArticle write SetArticle;
    property TypeArticle: string read fTypeArt write SetTypeArticle;
    property Actif: boolean read fusable write fusable;
  end;

implementation
uses  fiche,
      FichList;

{ TMetreArt }

// chargement du type d'Article
procedure TMetreArt.SetTypeArticle(Value: string);
begin
  fTypeArt := Value;
end;

// chargement des valeurs necessaire à ole gestion des documents Xls Biblio
procedure TMetreArt.SetArticle(Value: string);
var fichier: string;
begin

  if not fusable then exit;

  // Si Code Article est à blanc alors fichier = NewOne
  if Value = '' then
     Begin
     Value := 'NewOne';
     fArticle := Value;
     end;

  // Formatage de l'article dans le cadre d'un Ouvrage
  fArticle := FormatArticle(Value);

  // si le répertoire de base n'existe pas => Création
  FichierXLS := fArticle + '.XLS';

  RepMetre := frepertBase + '\' + 'Bibliotheque' + '\';

  fRepertLocal := FNomMachine + '-' + V_PGI.User;
  if fRepertLocal = '' then
     Begin
     fusable := false;
     exit;
     end;

  RepSauve := RepMetre + 'SauveArt\';
  if not DirectoryExists(RepSauve) then
     CreationDir(RepSauve);

  RepSauve := Repsauve + fRepertLocal + '\';
  if not DirectoryExists(RepSauve) then
     CreationDir(RepSauve);

  fichier := RepSauve + FichierXLS;

  if not fusable then exit;

  if not DirectoryExists(RepMetre) then
     CreationDir(RepMetre);

  // vérification de l'existance d'un fichier de métré pour l'article en question

  {*
  if not fileExists('c:\PGI00\STD\ArticlePgi.xla') then
    begin
      fusable := false;
      PGIBox ('fichier ArticlePgi.xla Introuvable', 'METRE')
    end
  else
    AddVbModuleFromFile('c:\PGI00\STD\', 'ArticlePgi.xla');
  *}

  if not FileExists(RepMetre + fichierXLS) then
     begin
     exit;
     end;

  if not OfficeExcelDispo then
     begin
     PGIBoxAF('Office n''est pas installé sur ce poste', 'METRE');
     exit;
     end;
{FIN YOYO}

  if not ChargeFicArt(RepMetre, fichierXLS, 'SauveArt', fRepertLocal) then
     begin
     PGIBoxAF(traduirememoire('le fichier ' + FichierXLS + ' n''existe pas.'), traduirememoire('METRE'));
     fusable := false;
     exit;
     end;

end;

// Procedure de réaffichage du container Excel
Procedure TMetreArt.ActiveOle;
Begin

  if not fusable then exit;

  FOleExcel.Visible := true;
  FoleExcel.doverb(ovShow);
  FTimer.Enabled := true;

end;

// Procedure de chargement de l'objet OLE
procedure TMetreArt.ModifMetres;
var
  fichier: string;
begin

  if not fusable then exit;

  Ok_Affiche := true;

  // si le répertoire de base n'existe pas => Création
  fichier := RepSauve + FichierXLS;

  // si le fichier Xls n'existe pas on le crée à partir d'un fichier vide
  if not FileExists(fichier) then CreateTheFichierXls(fichier);

  FOleExcel.CreateObjectFromFile(Fichier, false);

  if FoleExcel <> nil then
  begin
    ActiveOle;
  end;

end;

// annulation de la saisie d'un article
function TMetreArt.Annule: boolean;
var Fichier       : string;
//    WorkBook      : Variant;
//    WinNew        : boolean;
//    OleExcel      : Variant;
//    Col           : integer;
//    Lig           : integer;
    Ok_CellVide   : boolean;
begin
	result := fusable;
  if not fusable then exit; 

  AnnuleArt(RepMetre, FichierXls, RepSauve);

  //Verification si les 10 premières lignes du fichier XLs
  //sont renseignées si non suppression fichier xls dans
  //répertoire métrés/bibliothèque
  Fichier := RepMetre + FichierXls;

  if fichier = '' then exit;

  if not FileExists(Fichier) then exit;

  Ok_CellVide := true;

  // création du lien OLE pour la classe référencé par Excel dans
  //la base de registre "Excel.Application"
  if not ControleXLS(fichier, Ok_CellVide) then
     Begin
       if Ok_CellVide then
          DeleteFichier(Fichier)
       else
          Exit;
     end;
end;

constructor TMetreArt.create(aowner: Tform; TabMetre : TTabSheet; OleExcel : ToleContainer);
var fichier : String;
begin
  inherited create;

  fUsable := True;

  if GetParamSoc ('SO_BTMETREBIB') then
    frepertBase := RecupRepertbase
  else
    fUsable := false;

  if frepertBase = '' then fUsable := false;

  if not ControlMetre then fUsable := false;

  FNomMachine := ComputerName ;

  if (fusable) and (not DirectoryExists(fRepertBase)) then
  begin
    PGIBoxAF(traduirememoire('le répertoire ' + fRepertBase + ' n''existe pas.'), traduirememoire('METRE'));
    fUsable := false;
  end;

  fichier := 'c:\PGI00\STD\ArticlePgi.xla';

  //test existance fichier xla...
  if not FileExists(Fichier) then
  begin
    PGIBoxAF(traduirememoire('le fichier ' + fichier + ' n''existe pas.'), traduirememoire('METRE'));
    fUsable := false;
  end;

  Fform := aowner;
  if fusable then
  begin
    FOleExcel := OleExcel;
    fTimer := TTimer.create (Aowner);
    ftimer.Enabled := false;
    fTimer.Interval := 100; // 0.1 sec
    fTimer.OnTimer := TimeElapsed;
    //
    AddVbModuleFromFile('c:\PGI00\STD\', 'ArticlePgi.xla');
    //Modif FV : Version 5 - Version 7
    //AddVbModuleFromFile(IncludeTrailingBackSlash(TcbpPath.GetCegidDistriStd), 'ArticlePgi.xla');
  end;
end;

procedure TMetreArt.duplic(Article: string);
var OFichierXls, OFichier, fichier: string;
begin
  if not fusable then exit;

  Article := FormatArticle(Article);

  OFichierXLS := article + '.XLS';
  Ofichier := RepMetre + OFichierXLS;
  fichier := RepSauve + FichierXLS;

  if FileExists(ofichier) then
    CopieFichier(Ofichier, fichier)
  else
    if not CreateTheFichierXls(fichier) then exit;

  FOleExcel.CreateObjectFromFile(fichier, false);

end;

Procedure TMetreArt.SauveMetres(Ok_Onglet : boolean);
Var Fichier : string;
begin
  if not fusable then exit;

  fichier := RepSauve + FichierXLS;

  Ok_Affiche := Ok_Onglet;

  if (foleExcel <> nil) and (foleExcel.State <> OsEmpty) then
    begin
      FOleExcel.SaveAsDocument(fichier);
    end;

end;

//Sauvegarde temporaire du fichier Xls Ouvrage si appel déclinaison
function TMetreArt.ValDec(Article: string): boolean;
Var Fichier : string;
    Ok_FichierVide : Boolean;
begin
  result := fusable;
  if not fusable then exit;

  fichier := RepSauve + FichierXLS;

  if (foleExcel <> nil) and (foleExcel.State <> OsEmpty) then
    FOleExcel.SaveAsDocument(fichier)
  else
    exit;

  if not ControleXLS(fichier, OK_FichierVide) then
     Begin
       if Ok_FichierVide then
         Exit;
     end;

  SauveFicArt(RepMetre, FichierXLS , RepSauve);


end;

// Enregistrement du fichier Xls au nom de l'article
function TMetreArt.validate(Article: string): boolean;
var fichier, NfichierXls, NFichier: string;
begin
	result := fusable;
  if not fusable then exit;

  Result := false;

  fichier := RepSauve + FichierXLS;

  if not FileExists(fichier) then exit;

  if (foleExcel <> nil) and (foleExcel.State <> OsEmpty) then
    begin
      FOleExcel.SaveAsDocument(fichier);
    end else
    begin
      result := true;
      Exit;
    end;

  Article := FormatArticle(Article);

  NFichierXLS := Article + '.XLS';
  Nfichier := RepSauve + NFichierXLS;

  if fichier <> Nfichier then
     begin
       renameFichier(fichier, Nfichier);
       FichierXLS := NFichierXLS;
     end;

  SauveFicArt(RepMetre, FichierXLS , RepSauve);

  // Ouverture container OLE
  if Ok_Affiche then
  begin
     FOleExcel.doverb(ovShow);
     FTimer.Enabled := true;
  end;

  Result := True;

end;

// duplication du fichier XLS lors de la duplication Nomenclature
function TMetreArt.CopieMetre(Article, NewArticle: string): boolean;
var Fic_Source  : string;
    Fic_Dest    : string;
begin
	result := fusable;
  if not fUsable then Exit;

  Article := FormatArticle(Article);
  Fic_Source := RepMetre + Article + '.XLS';

  //Vérification existance fichier source
  if not FileExists(Fic_Source) then exit;

  NewArticle := FormatArticle(NewArticle);
  Fic_Dest := RepMetre + NewArticle + '.XLS';

  CopieFichier(Fic_Source, Fic_Dest);    

  Result := True;

end;

// duplication des variables associées à l'ouvrage de référence
function TMetreArt.CopieVariable(Article, NewArticle: string): boolean;
var requete : string;
    I       : Integer;
    QQ      : TQuery;
    TobVSce : Tob;
    TobVDes : Tob;
    TobVRes : Tob;
begin
		result := fusable;
  	if not fUsable then Exit;

    TobVSce := TOB.Create('Var Source', nil, -1);
    TobVDes := TOB.Create('Var Dest', nil, -1);

    Requete := 'SELECT * FROM BVARIABLES WHERE BVA_ARTICLE="' + Article + '"';
    QQ := Opensql(Requete, True,-1,'',true);

    if QQ.eof then
      begin
        ferme(QQ);
        exit;
      end;

    TobVSce.LoadDetailDB('BVARIABLES', '', '', QQ, False);

    if TobVSce <> nil then
       if TobVSce.detail.count > 0 then
       begin
        For I:=0 To TobVSce.detail.count-1 do
          Begin
            // Chargement d'une grille avec les enregistrement de la Tob
            TobVRes := Tob.Create('BVARIABLES', TobVDes, -1);
            TobVRes.Putvalue('BVA_TYPE', 'B');
            TobVRes.Putvalue('BVA_ARTICLE', NewArticle);
            TobVRes.Putvalue('BVA_CODEVARIABLE', TobVSce.detail[I].getValue('BVA_CODEVARIABLE'));
            TobVRes.Putvalue('BVA_LIBELLE', TobVSce.detail[I].getValue('BVA_LIBELLE'));
            TobVRes.Putvalue('BVA_VALEUR', TobVSce.detail[I].getValue('BVA_VALEUR'));
            TobVRes.Putvalue('BVA_QTEEXPPOUR', TobVSce.detail[I].getValue('BVA_QTEEXPPOUR'));
          end;
       end;

    TobVDes.InsertOrUpdateDB;

    Ferme(QQ);

    TobVSce.free;
    TobVDes.free;

    result := true;
end;
// Suppression des variables associées à l'ouvrage de référence
function TMetreArt.SuppVariable(Article : string): boolean;
var requete : string;
//    I       : Integer;
//    QQ      : TQuery;
begin
		result := fusable;
    if not fUsable then Exit;

    Requete := 'DELETE FROM BVARIABLES WHERE BVA_ARTICLE="' + Article + '"';
    ExecuteSQL(Requete);

    result := true;
end;

function TMetreArt.Supprime(Article: string): boolean;
begin
	result := fusable;
  if not fusable then exit;

  // suppression du fichier correspondant à l'article
  RepMetre := frepertBase + '\' + 'Bibliotheque' + '\';

  // Formatage de l'article dans le cadre d'un Ouvrage
  Article := FormatArticle(Article);

  if not FileExists(RepMetre + '\' + Article + '.XLS') then exit;

  deletefichier(RepMetre + '\' + Article + '.XLS');

end;

// Controle dans le cas de la suppression
constructor TMetreArt.create;
begin

  if GetParamSoc ('SO_BTMETREBIB') or GetParamSoc ('SO_BTMETREDOC') then
    frepertBase := RecupRepertbase
  else
    frepertbase := '';

  if frepertBase = '' then  exit;

  if not ControlMetre (false) then exit;

  fUsable := true;

end;

// ajout d'un nouvel article
procedure TMetreArt.AddNewRecord;
begin
  if not fusable then exit;

  // Nettoyage du repertoire de sauvegarde
  AnnuleArt(RepMetre, FichierXLS, RepSauve);

end;

// Restauration du fichier dimension principal dans rep de sauvegarde

procedure TMetreArt.RestoreDim;
var RepDim, FichierDim: string;
begin

  if not fUsable then Exit;

  RepDim := RepSauve + 'Dimension\';
  FichierDim := RepDim + Frepert + '.SAV';
  CopieFichier(FichierDim, RepSauve + FichierXLS);
  DeleteFichier(FichierDim);
  DeleteRepertoire(RepDim);

  FOleExcel.CreateObjectFromFile(RepSauve + FichierXLS, false);

  {*
  if not fileExists ('c:\PGI00\STD\ArticlePgi.xla') then
  begin
     fusable := false;
     PGIBoxAF('fichier ArticlePgi.xla Introuvable', 'METRE');
  end
  else
     AddVbModuleFromFile('c:\PGI00\STD\', 'ArticlePgi.xla');
  *}

end;

// Sauvegarde du fichier XLs pour l'article dimensionné principal

procedure TMetreArt.SauveDim;
var RepDim, FichierDim: string;
    Ok_FichierVide : Boolean;
begin
  if not fUsable then Exit;

  RepDim := RepSauve + 'Dimension\';
  FichierDim := RepSauve + FichierXLS;

  if (foleExcel <> nil) and (foleExcel.State <> OsEmpty) then
  begin
    FOleExcel.SaveAsDocument(fichierDim);
    foleExcel.close;
    if not ControleXLS(fichierDim, OK_FichierVide) then
      Begin
       DeleteFichier(FichierDim);
       exit;
      end;
  end;

  if not DirectoryExists(RepDim) then Creationdir(RepDim);

  CopieFichier(FichierDim, repdim + frepert + '.SAV');

  DeleteFichier(FichierDim);

end;
{
function TMetreArt.CloseExcel (WithQuestion : boolean) : boolean;
var Dispatch: IDispatch;
  WinExcel: OleVariant;

  function GetActiveOleObjectEx(const ClassName: string): Boolean;
  var
    ClassID: TCLSID;
    Unknown: IUnknown;
    AResult: HResult;
  begin
    Result := False;
    ClassID := ProgIDToClassID(ClassName);
    AResult := GetActiveObject(ClassID, nil, Unknown);
    if (Unknown = nil) or not Succeeded(AResult) then Exit;
    AResult := Unknown.QueryInterface(IDispatch, Dispatch);
    if not Succeeded(AResult) then Exit;
    Result := True;
  end;

procedure SquizExcel ;
  begin
    WinExcel.DisplayAlerts := False;
    WinExcel.Quit;
    WinExcel := Unassigned;
  end;

function AfterThreeAttempt : boolean;
var Icommence : boolean;
    indice : integer;
begin
  result := false;
  Icommence := GetActiveOleObjectEx('Excel.Application');
  if Icommence then
  begin
    result := true;
    for Indice := 1 to 3 do
    begin
      sleep (1000);
      Icommence := GetActiveOleObjectEx('Excel.Application');
      if not Icommence then BEGIN result := false; break; END;
    end;
  end;
end;

begin
  result := true;
  WinExcel := UnAssigned;
  if AfterThreeAttempt then
  begin
    WinExcel := Dispatch;
    if not VarIsEmpty(WinExcel) then
    begin
      if not WithQuestion then
      begin
        SquizExcel;
      end else
      if (PGIAsk(traduirememoire('Désirez-vous fermer excel ?')) = mryes) then
      begin
        SquizExcel;
      end
      else
        result := false;
    end;
  end;
end;
}


function TMetreArt.FormatArticle(Article: String): String;
begin

  Result := Article;

  if fTypeArt = 'OUV' then
     begin
       Result := trim(Result);
     end;

  Result := Replace(Result, '\', '_');
  Result := Replace(Result, '/', '_');
  Result := Replace(Result, '''', '_');
  Result := Replace(Result, '"', '_');
  //Result := Replace(Result, '.', '_');


end;

destructor TMetreArt.destroy;
begin
//  if FoleExcel <> nil then FoleExcel.free;
  fTimer.free;
  inherited;
end;

// Ouverture du fichier XLS après sauvegarde
procedure TMetreArt.CloseXls;
begin

  if not fUsable then Exit;

  if FoleExcel <> nil then
    begin
      if FoleExcel.state <> osEmpty then
      begin
        FOleExcel.doverb(ovHide);
        FOleExcel.DestroyObject;
      end;
//      freeAndNil(FOleExcel);
      FTimer.Enabled := false;
    end;

end;

// copie du fichier Article dans fichier document
function TMetreArt.GesDoc(FromArticle: string; TypeArt: string): string;

begin;
  if not fUsable then Exit;

  Result := '';
  Self.TypeArticle := TypeArt;
  Self.Article := FromArticle;

  //si code article à blanc on fait rien
  if Article = '' then exit;

  // Formatage de l'article dans le cadre d'un Ouvrage
   fArticle := FormatArticle(FromArticle);
  //if fTypeArt = 'OUV' then
  //   begin
  //     fArticle := trim(fArticle);
  //   end;

  // si le répertoire de base n'existe pas => Création
  FichierXLS := fArticle + '.XLS';
  RepMetre := frepertBase + '\' + 'Bibliotheque' + '\';

  Result := RepMetre + FichierXLS;

  // si le fichier Xls n'existe pas : ficArt = vide
  if not FileExists(Result) then Result := '';

end;


// Vérification que le fichier XLS contient au moins une variable pour
//pouvoir sauvegarder
function TMetreArt.ControleXLS(Fichier : string; var Ok_CellVide : boolean): Boolean;
var // WinNew : boolean;
    Ligne, Colonne : integer;
    XL : Variant;
begin

  Result := False;
  Ok_CellVide := true;

  if not fusable then Exit;

  if not FileExists (Fichier) then CreateTheFichierXls (Fichier);

  if (foleExcel = nil) or (foleExcel.State = OsEmpty) then
    begin
     Ok_CellVide := false;
     exit;
    end;
(*
 if not OpenExcel (true,fWinExcel,WinNew) then
     begin
     PGIBox (TraduireMemoire('Liaison Excel impossible'), TraduireMemoire('Liaison EXCEL'));
     exit;
     end;
 *)
  TRY
    // Verification si une cellule dans les 20 première ligne
    // des 10 premières colonnes est renseignée
    XL := FOleExcel.OleObject;
    For Ligne := 1 to 10 do
      Begin
        For Colonne := 1 to 3 do
          Begin
            if XL.sheets[1].cells[ligne,Colonne].text <> '' then
               begin
                 Ok_CellVide := False;
                 break;
               end;
          End;
          if not Ok_CellVide then break;
      End;


    if Ok_CellVide then
      begin
       Result := false;
       Exit;
      end;
  FINALLY
   // ExcelClose (fwinExcel);
  END;

end;

procedure TMetreArt.TimeElapsed(Sender: TObject);
begin
  if FoleExcel = nil then exit;
  if fOleExcel.Modified then
  begin
    if copy(fform.Name, 1, 9) = 'BTARTICLE' then
      begin
        if not (TFFiche(fform).QFiche.State in [dsEdit,dsInsert]) then TFFiche(fform).QFiche.Edit;
      end
    else if copy(fform.Name, 1, 12) = 'BTPRESTATION' then
      begin
        if not (TFFiche(fform).QFiche.State in [dsEdit,dsInsert]) then TFFiche(fform).QFiche.Edit;
      end
    else if copy(fform.Name, 1, 13) = 'BTARTPOURCENT' then
      begin
        if not (TFFiche(fform).QFiche.State in [dsEdit,dsInsert]) then TFFiche(fform).QFiche.Edit;
      end
    else if fform.Name = 'GCNOMENENT' then
      begin
        if not (TFFicheListe(fform).Ta.State in [dsEdit,dsInsert]) then TFFicheListe(fform).ta.Edit;
      end;
  end;
end;

Function ControlMetre (All : boolean = true) : Boolean;
var Dest : string;
Begin

  Result := True;

  if All then
  begin
    if not fileExists('c:\PGI00\STD\ArticlePgi.xla') then
    //Modif FV : Version 5 - Version 7
    //if not fileExists(IncludeTrailingBackSlash(TCbpPath.GetCegidDistriStd) + 'ArticlePgi.xla') then
    begin
      Result := false;
      Exit;
    end;
  end;

  dest := GetOfficeDir+'XlStart\';
  if not DirectoryExists(dest) then
  begin
    Result := false;
    Exit;
  end;

  if not GetParamSoc('SO_BTMETREDOC') then
  begin
    Result := false;
    Exit;
  end;

End;

procedure TMetreArt.DesactiveTimer;
begin
ftimer.enabled := false;
end;

end.
