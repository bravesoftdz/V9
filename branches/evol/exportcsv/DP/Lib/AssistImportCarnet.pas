unit AssistImportCarnet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  assist, ComCtrls, HSysMenu, hmsgbox, StdCtrls, ExtCtrls, HTB97, Hctrls,
  Mask, UTob, UTom, HEnt1, HPanel;

type
  TFAssistImportCarnet = class(TFAssist)
    PChoixFichier: TTabSheet;
    lblSelection: THLabel;
    lblAvert1: THLabel;
    lblAvert2: THLabel;
    PImportation: TTabSheet;
    lblAvert3: THLabel;
    lblFichier: THLabel;
    LeFichier: THCritMaskEdit;
    HLabel1: THLabel;
    lblAide: THLabel;
    procedure bFinClick(Sender: TObject);
  private
    { D�clarations priv�es }
    function OutlookToRepert(TobSource, TobDest : TOB): Boolean;
    function GetSeparateurSimple(FichierTxt : String): String;
    procedure CAT_CreerTobFichierTexte (var LaTob : Tob; CheminFichier : String;
     Separateur : String; ListeChamp : String);
  public
    { D�clarations publiques }
  end;

procedure LanceAssistImportCarnet ;


///////////// IMPLEMENTATION //////////////
implementation

uses CAT_FichierTexte;

procedure LanceAssistImportCarnet ;
var F : TFAssistImportCarnet ;
BEGIN
  F := TFAssistImportCarnet.Create(Application) ;
  Try
    F.ShowModal ;
  Finally
    F.Free ;
  end ;
end ;

{$R *.DFM}

procedure TFAssistImportCarnet.bFinClick(Sender: TObject);
var TobOutlook, TobRepert : TOB;
    TomRepert : TOM;
    i : Integer;
    Sep : String;
begin
  inherited;
  // Traitement d�j� fait
  if BFin.Caption='&Fermer' then begin Self.Close; exit; end;

  // Positionnement sur la page de fin
  RestorePage ;
  P.ActivePage := PImportation ;
  PChange(nil) ;

  // Verifs
  if LeFichier.Text='' then
    begin
    PGIInfo('Aucun fichier choisi !', Self.Text);
    exit;
    end;
  if Not FileExists(LeFichier.Text) then
    begin
    PGIInfo('Le fichier n''existe pas !', Self.Text);
    exit;
    end;

  // 2 types de s�parateur possible avec l'export ascii outlook
  Sep := GetSeparateurSimple(LeFichier.Text);
  if Sep='' then
    begin
    PGIInfo('Le fichier n''a pas pu �tre identifi� comme un export Outlook ou Outlook Express.'
     + ' (absence de s�parateur Tabulation, Virgule ou Point-virgule)', Self.Text);
    exit;
    end;

  // Traitement commence
  BFin.Caption := '&Fermer';

  // Lecture fichier texte vers tob, avec suppression de tous les guillemets
  // dans les donn�es et les noms de champs
  // et d�doublonnage des noms de champs apparaissant plusieurs fois
  // (bug export outlook avec 2 champs Titre)
  CAT_CreerTobFichierTexte(TobOutlook, LeFichier.Text, Sep, '');

  // Cr�ation tob cible
  TobRepert := TOB.Create('YREPERTPERSO', Nil, -1) ;
  TomRepert := CreateTom('YREPERTPERSO', Nil, True, True);

  for i:=0 to TobOutlook.Detail.Count-1 do
    begin
    // Champs syst�mes, valeurs par d�faut (initnew)
    TobRepert.InitValeurs;

    // Passer par OnNewRecord de la tom
    TomRepert.InitTob(TobRepert);

    // Copie des champs
    if OutlookToRepert(TobOutlook.Detail[i], TobRepert) then
      begin
      // Passe par le OnUpdate de la tom
      if TomRepert.VerifTOB(TobRepert) then
        begin
        // Cr�ation enreg
        TobRepert.InsertDB(Nil);

        // Passe par le OnAfterUpdate de la tom
        TomRepert.AfterVerifTOB(TobRepert);
        end;
      end;
    end;

  TobRepert.Free;
  TomRepert.Free;
  TobOutlook.Free;

  // Import termin�, le mul affichera les nouveaux enreg...
  Self.Close;
end;

function TFAssistImportCarnet.OutlookToRepert(TobSource, TobDest : TOB): Boolean;
// Transf�re les valeurs des champs Outlook vers YRepertPerso
// Result � True si il y a au moins un nom ou pr�nom
var CC, Fax : String;
    Tel : TStringList;
begin
  // Le tronquage � la longueur maxi du destinataire se fait tout seul pour les varchar
  // Les champs ne sont pas forc�ment tous dans le fichier d'export, donc test FielExists
  // La cl� YRP_CODEREP, YRP_USER est aliment�e par la tom
  Result := False;

  // ---- D�nomination
  if TobSource.FieldExists('Nom') and (TobSource.GetValue('Nom')<>'') then
    begin Result := True; TobDest.PutValue('YRP_NOM', TobSource.GetValue('Nom') ); end;
  // Outlook Express
  // - on prend "Nom"+A0 qui repr�sente le vrai nom,
  //        car "Nom" sans A0 repr�sente un champ concat�n� nom_pr�nom
  // - sauf si champ pr�nom n'existe pas, dans ce cas garder "Nom" qui est plus riche !
  if TobSource.FieldExists('Nom'+#160) and (TobSource.GetValue('Nom'+#160)<>'')
  and TobSource.FieldExists('Pr�nom') then
    begin Result := True; TobDest.PutValue('YRP_NOM', TobSource.GetValue('Nom'+#160) ); end;
  // Rien trouv�
  if Not Result then exit;

  // ---- Pr�nom
  if TobSource.FieldExists('Pr�nom') and (TobSource.GetValue('Pr�nom')<>'') then
    TobDest.PutValue('YRP_PRENOM', TobSource.GetValue('Pr�nom') );

  // ---- Civilit�
  // Rq : il y a 2 champs "Titre" dans l'export Outlook !
  // mais heureusement CAT_CreerTobFichierTexte renomme le 2� en Titre_1 ...
  if TobSource.FieldExists('Titre') and (TobSource.GetValue('Titre')<>'') then
    begin
    CC := UpperCase(TobSource.GetValue('Titre'));
    // Tentative de correspondance Outlook (libre!) => PGI (tablette personnalisable !)
    if (CC='DR.') or (CC='DOCTEUR') then CC := 'DR'
    else if (CC='M.') or (CC='MONSIEUR') or (CC='MR.') then CC := 'MR'
    else if (CC='ME') or (CC='MADEMOISELLE') or (CC='MLLE') or (CC='MLLE.') then CC := 'MLE'
    else if (CC='MM') or (CC='MESSIEURS') or (CC='MMS') then CC := 'MM.'
    else if (CC='MME.') or (CC='MADAME') then CC := 'MME';
    if (CC<>'') and (Length(CC)<4) and
     ExisteSQL('SELECT CC_CODE FROM CHOIXCOD WHERE CC_TYPE="CIV" AND CC_CODE="'+CC+'"') then
      TobDest.PutValue('YRP_CIVILITE', CC );
    end;

  // ---- N� de t�l�phone
  Tel := TStringList.Create;
  // ** Outlook **
  if TobSource.FieldExists('T�l�phone (bureau)') and (TobSource.GetValue('T�l�phone (bureau)')<>'') then
    Tel.Add(TobSource.GetValue('T�l�phone (bureau)'));
  if TobSource.FieldExists('T�l�phone (domicile)') and (TobSource.GetValue('T�l�phone (domicile)')<>'') then
    Tel.Add(TobSource.GetValue('T�l�phone (domicile)'));
  if TobSource.FieldExists('T�l�phone (autre)') and (TobSource.GetValue('T�l�phone (autre)')<>'') then
    Tel.Add(TobSource.GetValue('T�l�phone (autre)'));
  if TobSource.FieldExists('T�l. mobile') and (TobSource.GetValue('T�l. mobile')<>'') then
    Tel.Add(TobSource.GetValue('T�l. mobile'));
  // Autres champs disponibles :
  //   T�l�phone 2 (bureau) => peu utilis� ?
  //   T�l�phone 2 (domicile) => peu utilis� ?
  //   T�l�phone (voiture) => obsol�te
  //   T�l�phone soci�t� => pas repr�sentatif du contact
  //   T�l�phone principal => peu utilis� ?
  // ** Outlook Express **
  if TobSource.FieldExists('T�l�phone professionnel') and (TobSource.GetValue('T�l�phone professionnel')<>'') then
    Tel.Add(TobSource.GetValue('T�l�phone professionnel'));
  if TobSource.FieldExists('T�l�phone personnel') and (TobSource.GetValue('T�l�phone personnel')<>'') then
    Tel.Add(TobSource.GetValue('T�l�phone personnel'));
  if TobSource.FieldExists('T�l�phone mobile') and (TobSource.GetValue('T�l�phone mobile')<>'') then
    Tel.Add(TobSource.GetValue('T�l�phone mobile'));
  // ** Insertion **
  if Tel.Count>0 then TobDest.PutValue('YRP_TEL1', Tel[0] );
  if Tel.Count>1 then TobDest.PutValue('YRP_TEL2', Tel[1] );
  Tel.Free;

  // ---- N� de fax
  Fax := '';
  // ** Outlook **
  if TobSource.FieldExists('T�l�copie (bureau)') then
    Fax := TobSource.GetValue('T�l�copie (bureau)');
  if (Fax='') and TobSource.FieldExists('T�l�copie (domicile)') then
    Fax := TobSource.GetValue('T�l�copie (domicile)');
  if (Fax='') and TobSource.FieldExists('T�l�copie (autre)') then
    Fax := TobSource.GetValue('T�l�copie (autre)');
  // ** Outlook express **
  if (Fax='') and TobSource.FieldExists('T�l�copie professionnelle') then
    Fax := TobSource.GetValue('T�l�copie professionnelle');
  if (Fax='') and TobSource.FieldExists('T�l�copie personnelle') then
    Fax := TobSource.GetValue('T�l�copie personnelle');
  // ** Insertion **
  if Fax<>'' then TobDest.PutValue('YRP_FAX', Fax );

  // ---- Internet
  if TobSource.FieldExists('Adresse de messagerie') then
    TobDest.PutValue('YRP_EMAIL', TobSource.GetValue('Adresse de messagerie') );
end;

function TFAssistImportCarnet.GetSeparateurSimple(FichierTxt : String): String;
// FichierTxt : chemin d'un export txt outlook existant
// Recherche dans la 1�re ligne le s�parateur, avec par ordre de pr�f�rence :
// tab / point virgule / virgule / rien !
// Corrige cette premi�re ligne (liste de champs) pour corriger l'export Outlook :
//  il contient 2 champs "Titre" !
var F : TextFile;
    S : String;
begin
  Result := '';
  AssignFile(F, FichierTxt);
  Reset(F);
  Readln(F, S);
  CloseFile(F);

  if Pos(#9, S)>0 then
    Result := #9
  else if Pos(';', S)>0 then
    Result := ';'
  else if Pos(',', S)>0 then
    Result := ',';
end;

//-----------------------------------------------------------------------------
//--- Nom   : CAT_CreerTobFichierTexte
//--- Objet : Cr�e et intialise la tob � partir d'�l�ment d'un fichier texte
//---         Si ChChamp est vide alors on consid�re que la description
//---         des champs est la premi�re ligne du fichier Texte.
//---         Supprime les guillemets dans les noms de champ et les donn�es
//-----------------------------------------------------------------------------
procedure TFAssistImportCarnet.CAT_CreerTobFichierTexte (var LaTob : Tob; CheminFichier : String;
  Separateur : String; ListeChamp : String);
var FichierTob                    : TFichierTexte;
    ChaineSource                  : AnsiString;
    TobChamp,TobEnreg,TobResultat : Tob;
    Indice,NumChamp               : Integer;
    ChValeur                      : String;
begin
 if Not CAT_OuvrirFichierTexte (FichierTob,CheminFichier,MODE_LIRE) then
  PgiInfo ('Impossible d''ouvrir le fichier '+CheminFichier)
 else
  begin
   if (ListeChamp='') then
    begin
     CAT_LireFichierTexte (FichierTob,ListeChamp);
     ListeChamp:=StringReplace(ListeChamp,Separateur,'|',[rfReplaceAll]);
     ListeChamp:=StringReplace(ListeChamp,'"','',[rfReplaceAll]);

     //--- Cr�ation de la tob contenant les noms de champ
     TobChamp:=TOB.Create('', Nil, -1);
     while (ListeChamp<>'') do
      begin
       TobEnreg:=Tob.Create ('',TobChamp,-1);
       TobEnreg.AddChampSupValeur ('Champ',ReadToKenPipe (ListeChamp,'|'));
      end;

     //--- Recherche et remplace les noms de champ identiques
     for Indice:=0 to TobChamp.Detail.Count-1 do
      begin
       NumChamp:=0;
       ChValeur:=TobChamp.Detail [Indice].GetValue ('Champ');
       TobResultat:=TobChamp.FindFirst(['Champ'],[ChValeur],True);

       while TobResultat<>Nil do
        begin
         if (NumChamp>0) then
          TobResultat.PutValue ('Champ',ChValeur+'_'+IntToStr (NumChamp));

         inc (NumChamp);
         TobResultat:=TobChamp.FindNext(['Champ'],[ChValeur],True);
        end;
      end;

     //--- Construit une chaine de caract�re contenant la liste des champs
     ListeChamp:='';
     for Indice:=0 to TobChamp.Detail.Count-1 do
      ListeChamp:=ListeChamp+TobChamp.Detail [Indice].GetValue ('Champ')+'|';

     TobChamp.Free;
    end;

   LaTob:=TOB.Create('',Nil,0);
   while not CAT_FinFichierTexte (FichierTob) do
    begin
     CAT_LireFichierTexte (FichierTob,ChaineSource);
     ChaineSource:=StringReplace(ChaineSource,Separateur,'|',[rfReplaceAll]);
     ChaineSource:=StringReplace(ChaineSource,'"','',[rfReplaceAll]);
     TobEnreg:=TOB.Create('',LaTob,-1);
     TobEnreg.LoadFromSt(ListeChamp,'|',ChaineSource,'|');
    end;

   CAT_FermerFichierTexte (FichierTob);
  end;
end;



end.
