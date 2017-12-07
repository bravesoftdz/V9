unit UtilFichiers;

interface

uses
  Windows,
  Hctrls,
  ParamSoc,
  CBPPath,
  DicoBTP,
  FileCtrl,
  SYSUtils,
  HMsgBox,
  hent1,
{$IFDEF BTP}
  BTPUtil,
{$ENDIF}
{$IFDEF EAGLCLIENT}
  maineagl
{$ELSE}
  Doc_Parser,DBCtrls, Db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} fe_main
{$ENDIF}
     ;

function EnregistreFichier (RepertBase,SousRepertoire:String;Fichini,FicOut : string) : string;
function recupNomfic (nomfic : string): string;
function CopieFichier (nomOrig,Nomdest : string):boolean;
function DeleteFichier (nomfic : string) : boolean;
function CreateFichier (nomfic : string) : boolean;
function ComputerName: string;
function renameFichier (OldFic,NewFic : string) : boolean;
procedure deleteRepertoire (repertoire : string);
function SauvegardeFic (frepertBase,frepert,Repsauv,fuser : string) : boolean;
function RestitueSauve (frepertBase,frepert,RepertSauv,fuser : STRING): boolean;
procedure NettoieSauv (fRepertBase,RepSauve,fuser : string);
function Creationdir (repertoire : string) : boolean;
procedure CreateTheFichierXls(TheNomfic: string);
function RecupRepertbase : string;

// Procedure utilisée dans la gestion des métrés dans la bibliothèque
procedure AnnuleArt(Repertoire,Fichier, RepSauve: string);
function ChargeFicArt(Repertoire,Fichier, Repsauv, fuser: string): boolean;
function SauveFicArt(Repertoire, Fichier, RepertSauv: string): boolean;

//
Function Replace(Str, Car1, Car2: string): string;

implementation


function EnregistreFichier (RepertBase,SousRepertoire:String;Fichini,FicOut : string) : string;
var Repertoire,nomfic,nomOut : string;
begin
result := '';

if (RepertBase = '') or (SousRepertoire = '') then
   begin
   PGIBoxAF ('Veuillez définir le répertoire de stockage dans les paramètres sociétés','PARAM');
   exit;
   end;
   nomfic := recupNomfic (Fichini);
   nomOut := recupNomfic (FicOut);
   repertoire := RepertBase +'\'+SousRepertoire;
   
   if not DirectoryExists (RepertBase) then
   begin
      if not Creationdir (RepertBase) then exit;
   end;

   if not DirectoryExists (repertoire) then
   begin
      if not Creationdir (repertoire) then exit;
   end;
   if CopieFichier (Fichini,repertoire+'\'+nomOut) then result := Repertoire+'\'+nomOut;
end;


function CopieFichier (nomOrig,Nomdest : string):boolean;
var
FromF, ToF: file;
NumRead, NumWritten: Integer;
Buf: array[1..2048] of Char;
begin
AssignFile(FromF, NomOrig);
{$I-}
Reset(FromF, 1);
{$I+}

if IoResult = 0 then
  begin
  AssignFile(ToF, Nomdest);
  {$I-}
  Rewrite(ToF, 1);
  {$I+}
  if IoResult = 0 then
     begin
     result := true;
     repeat
         BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
         BlockWrite(ToF, Buf, NumRead, NumWritten);
     until (NumRead = 0) or (NumWritten <> NumRead);
     end else Result := false;
  CloseFile(ToF);
  end else result := false;
CloseFile(FromF);
end;

function recupNomfic (nomfic : string): string;
var position : integer;
begin
position := length (nomfic);
repeat
  if copy(nomfic,position,1) = '\' then break;
  dec (position);
until position <= 1;
if position > 1 then result := copy (nomfic,position+1,length(nomfic)-position+1)
                else Result := nomfic;
end;

function DeleteFichier (nomfic : string) : boolean;
begin
result := deleteFile (nomfic);
end;

function CreateFichier (nomfic : string) : boolean;
begin
result := (Filecreate (nomfic)<>-1);
end;

function renameFichier (OldFic,NewFic : string) : boolean;
begin
result := RenameFile (OldFic,NewFic);
end;

procedure deleteRepertoire (repertoire : string);
var nomfic : string;
Rec : TSearchRec;
begin
  Nomfic:= Repertoire+'\*.*';
  if FindFirst (Nomfic,faAnyFile,Rec) = 0 then
     begin
     if (rec.name <> '.') and (rec.name <> '..') then deleteFile (repertoire+'\'+rec.Name);
     while FindNext (Rec) = 0 do
         begin
         if (rec.name <> '.') and (rec.name <> '..') then deleteFile (repertoire+'\'+rec.Name);
         end;
     end;
  FindClose (Rec);
  removedir(Repertoire);
end;

function SauvegardeFic (frepertBase,frepert,Repsauv,fuser : string) : boolean;
var theRepertISauv,TheRepertSauv : string;
    NomFic : string;
    Rec : TSearchRec;
begin
  result := true;
  TheRepertISauv := fRepertBase+'\'+Repsauv;

  if not DirectoryExists (TheRepertISauv) then
  begin
    if not Creationdir (TheRepertISauv) then BEGIN result := false;exit; END;
  end;
  TheRepertSauv := fRepertBase+'\'+Repsauv+'\'+fuser;
  if not DirectoryExists (TheRepertSauv) then
  begin
    if not Creationdir (TheRepertSauv) then BEGIN result := false;exit; END;
  end;

  Nomfic:= frepertBase + '\' +frepert + '\*.*';
  if FindFirst (Nomfic,faAnyFile,Rec) = 0 then
  begin
    if (rec.name <> '.') and (rec.name <> '..') then
    begin
      CopieFichier (frepertBase + '\' + frepert + '\' + rec.name,TheRepertSauv + '\' + rec.Name);
    end;
    while FindNext (Rec) = 0 do
    begin
      if (rec.name <> '.') and (rec.name <> '..') then
      begin
        CopieFichier (frepertBase+'\'+frepert+'\'+rec.name,TheRepertSauv+'\'+rec.Name);
      end;
    end;
  end;
  FindClose (Rec);
end;

function RestitueSauve (frepertBase,frepert,RepertSauv,fuser : string): boolean;
var theRepertSauv : string;
    NomFic : string;
    Rec : TSearchRec;
begin
  result := true;
  TheRepertSauv := fRepertBase+'\'+RepertSauv+'\'+fuser;
  if not DirectoryExists (frepertBase+'\'+frepert) then
  begin
    if not Creationdir (frepertBase+'\'+frepert) then BEGIN result := false;exit; END;
  end;
  // 1ere phase suppression des fichiers du repertoire de stockage
  Nomfic:= frepertBase+'\'+frepert+'\*.*';
  if FindFirst (Nomfic,faAnyFile,Rec) = 0 then
  begin
    if (rec.name <> '.') and (rec.name <> '..') then
    begin
      DeleteFichier (frepertBase+'\'+frepert+'\'+rec.name);
    end;
    while FindNext (Rec) = 0 do
    begin
      if (rec.name <> '.') and (rec.name <> '..') then
      begin
        DeleteFichier (frepertBase+'\'+frepert+'\'+rec.name);
      end;
    end;
  end;
  FindClose (Rec);
  // 2 eme phase restitution des fichiers sauvegardes
  Nomfic:= TheRepertSauv+'\*.*';
  if FindFirst (Nomfic,faAnyFile,Rec) = 0 then
  begin
    if (rec.name <> '.') and (rec.name <> '..') then
    begin
      CopieFichier (TheRepertSauv+'\'+rec.name,frepertBase+'\'+frepert+'\'+rec.name);
    end;
    while FindNext (Rec) = 0 do
    begin
      if (rec.name <> '.') and (rec.name <> '..') then
      begin
        CopieFichier (TheRepertSauv+'\'+rec.name,frepertBase+'\'+frepert+'\'+rec.name);
      end;
    end;
  end;
  FindClose (Rec);
end;

procedure NettoieSauv (fRepertBase,RepSauve,fuser : string);
var theRepertSauv : string;
    NomFic : string;
    Rec : TSearchRec;
begin
  TheRepertSauv := fRepertBase+'\'+RepSauve+'\'+ fUser;
  if not DirectoryExists (TheRepertSauv) then
  begin
    if not Creationdir (TheRepertSauv) then exit;
  end;

  Nomfic:= TheRepertSauv+'\*.*';
  if FindFirst (Nomfic,faAnyFile,Rec) = 0 then
  begin
    if (rec.name <> '.') and (rec.name <> '..') then
    begin
      deleteFichier (TheRepertSauv+'\'+rec.Name);
    end;
    while FindNext (Rec) = 0 do
    begin
      if (rec.name <> '.') and (rec.name <> '..') then
      begin
        deleteFichier (TheRepertSauv+'\'+rec.Name);
      end;
    end;
  end;
  FindClose (Rec);
end;

function Creationdir (repertoire : string) : boolean;
begin
  result:= Createdir (repertoire);
end;

procedure CreateTheFichierXls(TheNomfic: string);
Var RepFicXLS : String;
begin

if TheNomFic = '' then exit;

//Modif FV : Version 5 - Version 7
//RepFicXLS := IncludeTrailingBackSlash(TCbpPath.GetCegidDistriStd);
RepFicXls := 'c:\PGI00\STD\';

if not fileExists(RepFicXLS + 'MetreVide.xls') then
  begin
     PGIBox ('fichier MetreVide.xls Introuvable', 'METRE')
  end
else
  CopieFichier (RepFicXLS + 'MetreVide.xls',TheNomFic);

end;

function RecupRepertbase : string;
begin

	result := GetParamSoc ('SO_BTREPMETR');

 	if result = '' then
  Begin
    PgiBox (traduireMemoire('Veuillez définir le répertoire de stockage des métrés'),TraduireMemoire('METRES'));
    exit
  end;

 	if not DirectoryExists (result) then
  begin
   	if not Creationdir (result) then
     	exit;
  end;

end;

function ChargeFicArt(Repertoire, Fichier, Repsauv, fuser: string): boolean;
var TheRepertSauv: string;
  NomFic: string;
begin

  result := true;

  // Test et creation du repertoire principal de Sauvegarde
  TheRepertSauv := Repertoire + Repsauv;
  if not DirectoryExists(TheRepertSauv) then
  begin
    if not Creationdir(TheRepertSauv) then
    begin
      result := false;
      exit;
    end;
  end;

  // Test et creation du repertoire users de Sauvegarde
  TheRepertSauv := TheRepertSauv + '\' + fuser;
  if not DirectoryExists(TheRepertSauv) then
  begin
    if not Creationdir(TheRepertSauv) then
    begin
      result := false;
      exit;
    end;
  end;

  // Copie du fichier Xls du répertoire biblio vers le repertoire de travail
  Nomfic := repertoire + fichier;

  if FileExists(Nomfic) then
     CopieFichier(nomfic, TheRepertSauv + '\' + fichier);

end;

// Recupération du fichier Xls de l'article
function SauveFicArt(Repertoire, Fichier, RepertSauv: string): boolean;
var {theRepertSauv: string;}
  NomFic: string;
  Rec: TSearchRec;
begin
	result := true;

  if not DirectoryExists(Repertoire) then
  begin
    if not Creationdir(repertoire) then
    begin
      result := false;
      exit;
    end;
  end;
  // 1 eme phase restitution des fichiers sauvegardes
  Nomfic := RepertSauv + fichier;
  if FindFirst(Nomfic, faAnyFile, Rec) = 0 then
  begin
     CopieFichier(nomfic, repertoire + Fichier);
  end;
  FindClose(Rec);

end;

procedure AnnuleArt(Repertoire,Fichier, RepSauve: string);
var NomFic: string;
    Rec: TSearchRec;
begin

  // Si répertoire de sauvegarde n'existe pas Tchao
  if not DirectoryExists(RepSauve) then exit;    

  // suppression du fichier dans le répertoire de sauvegarde
  Nomfic := RepSauve + Fichier;
  if FindFirst(Nomfic, faAnyFile, Rec) = 0 then
  begin
    deleteFichier(nomfic);
  end;

  FindClose(Rec);
end;

//Fonction Trouvant Le nom de L'ordinateur
function ComputerName():string;
var
  mySessionName: string;
Begin

  mySessionName := GetEnvVar('SessionName');

  if mySessionName = '' then
     result := GetEnvVar('ComputerName') // normal
  else
     result := mySessionName ; // tse

end;

// remplace toutes les instances de "Car1" par "Car2" dans "Msg"
function Replace(Str, Car1, Car2: string): string;
begin
    while pos(Car1,Str)>0 do
    begin
    Insert(Car2,Str,pos(Car1,Str));
    Delete(Str,pos(Car1,Str),length(Car1));
    end;
    result := Str;
end;


end.
