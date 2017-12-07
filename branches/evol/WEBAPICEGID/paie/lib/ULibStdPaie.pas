unit ULibStdPaie;

interface

uses
    Controls,
    UTob,
{$IFDEF EAGLCLIENT}
    uHttp, MaineAgl,
    CegidPgiUtil,
{$ELSE}
{$IFNDEF DBXPRESS}dbtables,{$ELSE}uDbxDataSet,{$ENDIF}
    Fe_Main,
{$ENDIF}
    UTOZ,
    SysUtils,
    HMsgBox,
    StrUtils,
    HEnt1,
    HCtrls,
    ParamSoc,
    PGCalendrier,
    ULibEditionPaie,
    PgOutils2;

Type TMotif = record
     ControlMotif : TControl;    //TControl
     TitreMotif : string;        //Titre de la fen�tre
     TableMotif : string;        //Table
     ColonneMotif : string;      //Code
     SelectMotif : string;       //Libell�
     WhereMotif : string;        //Condition
     EditMotif : string;         //THEdit
     LabelMotif : string;        //TLabel
     end;

    procedure LancerPaie (NomBase, NomFic, NomModele : string);
    function Traitement_ASC (NomBase, NomFic, NomModele : string) : boolean;
    procedure TraitementCumulPaie (NomBase : string);
    procedure EnregCumulPaieDefaut (TC : TOB);
    function ControleValCumulPaie (Cumul,Predefini:String) : boolean;
    procedure TraitementTable (NomTable, NomBase : string);
    procedure EnregEtablissDefaut (TEtablissFille : TOB);
    function ControleValEtabliss (TEtablissFille : TOB; NomBase : string) : boolean;
    procedure EnregEtabComplDefaut (TEtabComplFille : TOB);
    procedure MajChampOblig(LibChamp : String);
    function ControleValEtabCompl (TEtabComplFille : TOB; NomBase : string) : boolean;
    procedure EnregSalDefaut (TSalariesFille : TOB);
    function ControleValSalaries (TSalariesFille : TOB; NomBase : string) : boolean;
    procedure VerifTablette(Champ,NomTablette,LibCleErr,LibChampErr : String;T : TOB);
    function TestHoraire(HoraireInf, HoraireSup: Double): Boolean;
    function ControleValHistoCumul (THistoCumulFille : TOB; NomBase : string) : boolean;
    procedure EnregAbsenceSalarieDefaut (TAbsenceFille : TOB; NomBase : string);
    function ControleValAbsenceSalarie (TAbsenceFille : TOB; NomBase : string) : boolean;
    function RechercheReprise (Validite : Tdatetime; Salarie, TypeConge,
                               TypeImpute, NomBase : string;
                               TypeConge2 : string='') : Tquery;
    procedure RechercheExerciceCp(Validite: tdatetime; var DTdeb, DtFin: tdatetime);
    function ExtractConnu (Table, NomBase : string; Enregistre : boolean) : boolean;
    function RecupereNomTable (NomFic : string) : string;
    function Extraction (NomFic, NomTable, NomBase : string; TFille : TOB;
                         Enregistre : boolean) : boolean;
    procedure AppliqueLeParam (TExtractFille, TModele : TOB;
                               ChampsModele : string);
    procedure AppliqueParamDefaut (NomTable : string; TExtract : TOB);
    function ControleExtract (NomTable, NomBase : string) : boolean;
    function ControleCumulPresent : boolean;
    function RecupChamp (Fichier, Champ, Where, NomBase : String;
                         var Trouve : boolean) : Variant;

  var
    LeMotif : TMotif;
    F, FRapport : TextFile;
    ChampOblig, Chemin, NomTable, PGTypeNumSal, StTitre : string;
    VerifPresenceParam : Boolean; // pour savoir si on doit faire les contr�les pour savoir
                                  // si les valeurs sont pr�sentes dans les param�tres
    Erreur : Boolean;
    TExtract, TListeFile, TListeZip, Tob_MotifAbs, TModele : TOB;
    NbChampOblig, ResultAnnee,ResultMois,ResultDepart : Integer;
    DTclot : TDateTime;
    TozFile : TOZ;

implementation

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 20/03/2007
Modifi� le ... :   /  /
Description .. : Click sur le bouton "Lancer l'importation" : r�cup�ration des
Suite ........ : donn�es
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
procedure LancerPaie(NomBase, NomFic, NomModele : string);
var
FileName, StMessage : string;
ContinueT : boolean;
begin
AssignFile(F, NomFic);
Reset(F);

//Cr�ation ou modification du fichier .log
FileName:= 'ascpgi.log';
AssignFile(FRapport, FileName);
if FileExists(FileName) then
   Append(FRapport)
else
   ReWrite(FRapport);
Writeln(FRapport, '');
Writeln(FRapport, 'D�but de traitement : '+DateTimeToStr(Now));

//Fonction d'import
ContinueT:= Traitement_ASC (NomBase, NomFic, NomModele);

if (ContinueT = True) then
   begin
   StMessage:='Traitement termin�';
   PGIBox(StMessage, StTitre);
   end;
Writeln(FRapport, StMessage+' : '+DateTimeToStr(Now));
CloseFile(FRapport);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 20/03/2007
Modifi� le ... :   /  /
Description .. : Traitement concernant le fichier ASC
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
function Traitement_ASC (NomBase, NomFic, NomModele : string) : boolean;
var
FichierATraiter, NomFicTable, sWhere : string;
i : integer;
ListeTable : Array[0..11] of string;
TFille : TOB;
begin

VerifPresenceParam := True; // Passer par un PARAMSOC ou autre ???

ListeTable[0]:= 'SOCIETE';
ListeTable[1]:= 'ETABLISS';
ListeTable[2]:= 'ETABCOMPL';
ListeTable[3]:= 'CONVENTIONCOLL';
ListeTable[4]:= 'TAUXAT';
ListeTable[5]:= 'CUMULPAIE';
ListeTable[6]:= 'CHOIXCOD';
ListeTable[7]:= 'SALARIES';
ListeTable[8]:= 'ENFANTSALARIE';
ListeTable[9]:= 'HISTOCUMSAL';
ListeTable[10]:= 'MINIMUMCONVENT';
ListeTable[11]:= 'ABSENCESALARIE';

// initialiser la liste contenant le rapport

// Encadrer la mise � jour des tables par un BeginTrans/CommitTrans/RollBack
{ggg Ne pas bloquer en cas d'erreur
BeginTrans;
}
Erreur := False;

//Construction de la tob sur les donn�es du mod�le
sWhere:= 'SELECT *'+
         ' FROM PGDEFAUTPARAM WHERE'+
         ' PDM_CODE="'+NomModele+'"';
TModele:= TOB.Create ('Le modele', NIL, -1);
TModele.LoadDetailDBFromSQL ('PGDEFAUTPARAM', SWhere);

TozFile:= TOZ.Create;
TozFile.OpenZipFile (NomFic, MoOpen);
TListeZip:= TozFile.ConvertListInTob;
//TobDebug (TListeZip);
TozFile.OpenSession (OsExt);
TListeFile:= TOB.Create ('Mes fichiers', nil, -1);
while (TListeZip.Detail.Count>0) do
      begin
      TFille:= TListeZip.Detail[0];
      FichierATraiter:= TFille.GetValue ('ZF_NAME');
      TozFile.ProcessFile (FichierATraiter);
      TFille.ChangeParent (TListeFile, -1);
      NomTable:= RecupereNomTable (FichierATraiter);
      TFille.AddChampSupValeur ('NOMTABLE', NomTable);
      end;
FreeAndNil (TListeZip);
//TobDebug (TListeFile);

Chemin:= ExtractFileDir (NomFic);
TozFile.SetDirOut (Chemin);
TozFile.CloseSession;
//TozFile.Destroy;
FreeAndNil (TozFile);

for i:=0 to 11 do
    result:= ExtractConnu (ListeTable[i], NomBase, True);

while (TListeFile.Detail.Count>0) do
      begin
      NomFicTable:= TListeFile.Detail[0].GetValue ('ZF_NAME');
      NomTable:= RecupereNomTable (NomFicTable);
//PT1-4 Ne pas traiter les tables inconnues si absence du fichier CEGID.par
      if FileExists('CEGID.par') then
         begin
         NomFicTable:= Chemin+'\'+NomFicTable;
         result:= Extraction (NomFicTable, NomTable, NomBase, TListeFile.Detail[0], True);
{Voir comment garder la trace
         MRecap.Lines.Add (TraduireMemoire ('ERREUR : Fichier '+NomTable+
                                            ' : Traitement impossible'));
}
         Erreur:= True;
         end;
      end;
FreeAndNil (TListeFile);
FreeAndNil (TModele);

{ggg Ne pas bloquer en cas d'erreur
if Erreur then
   RollBack
else
   CommitTrans;
}

//EnregSalDefaut (T);
end;


{***********A.G.L.***********************************************
Auteur  ...... : FC
Cr�� le ...... : 29/03/2007
Modifi� le ... :   /  /
Description .. : Traitement du fichier CUMULPAIE servant � alimenter la 
Suite ........ : table du m�me nom
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
procedure TraitementCumulPaie (NomBase : string);
var
TCumuls,TC : TOB;
i : integer;
NoDoss, Pred : string;
begin
{Voir comment garder la trace
MRecap.Lines.Add (TraduireMemoire ('Traitement du fichier CUMULPAIE'));
}

TCumuls := TOB.Create ('CUMULPAIE', Nil, -1);
for i := 0 to (TExtract.Detail.Count-1) do
    begin
    TC:= TExtract.Detail[i];

// Le pr�d�fini d�pend du num�ro de cumul
       if (((StrToInt (RightStr (TC.GetValue ('PCL_CUMULPAIE'), 1)) = 1) or
          (StrToInt (RightStr (TC.GetValue ('PCL_CUMULPAIE'), 1)) = 3)) and
          (StrToInt (RightStr (TC.GetValue ('PCL_CUMULPAIE'), 2)) > 50)) then
          begin
          Pred:= 'STD';
          NoDoss:= '000000';
          end
       else
       if (((StrToInt (RightStr (TC.GetValue ('PCL_CUMULPAIE'), 1)) = 5) or
          (StrToInt (RightStr (TC.GetValue ('PCL_CUMULPAIE'), 1)) = 7) or
          (StrToInt (RightStr (TC.GetValue ('PCL_CUMULPAIE'), 1)) = 9)) and
          (StrToInt (RightStr (TC.GetValue ('PCL_CUMULPAIE'), 2)) > 50)) then
          begin
          Pred:= 'DOS';
          NoDoss:= V_PGI.NoDossier;
          end
       else
          Pred:= '';

// Faire les controles n�cessaire sur le cumul en cours
    if ControleValCumulPaie (TC.GetValue ('PCL_CUMULPAIE'), Pred) then
       begin
// Renseigner les valeurs par d�faut des champs
       EnregCumulPaieDefaut (TC);

       TC.PutValue ('PCL_PREDEFINI', Pred);
       TC.PutValue ('PCL_NODOSSIER', NoDoss);

// Ins�rer le cumul dans la base
       ExecuteSQL (StringReplace (TC.MakeInsertSql, 'INTO CUMULPAIE',
                                  'INTO '+NomBase+'.dbo.CUMULPAIE',
                                  [RfIgnoreCase]));
       end;
    end;
FreeAndNil (TCumuls);
end;

// Alimentation des valeurs par d�faut non fournies
procedure EnregCumulPaieDefaut (TC : TOB);
begin
  if not TC.IsFieldModified('PCL_THEMECUM') then TC.PutValue('PCL_THEMECUM', '001');
  if not TC.IsFieldModified('PCL_TYPECUMUL') then TC.PutValue('PCL_TYPECUMUL', 'X');
  if not TC.IsFieldModified('PCL_RAZCUMUL') then TC.PutValue('PCL_RAZCUMUL', '00');
end;

// Controle des valeurs du fichier
function ControleValCumulPaie (Cumul,Predefini:String) : boolean;
begin
Result := False;

if (length (Cumul)<2) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('ERREUR : Cumul '+Cumul+' : Le code'+
                                      ' cumul doit comporter 2 caract�res'));
}
   Erreur:= True;
   end;

if (Predefini='DOS') then
   begin
   if (StrToInt (RightStr (Cumul, 1))<>5) and
      (StrToInt (RightStr (Cumul, 1))<>7) and
      (StrToInt (RightStr (Cumul, 1))<>9) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Cumul '+Cumul+' : Pour un'+
                                         ' pr�d�fini Dossier, le code cumul'+
                                         ' doit �tre impair terminant par 5, 7'+
                                         ' ou 9 et sup�rieur � 50'));
}
      Erreur:= True;
      end;
   end
else
if (Predefini='STD') then
   begin
   if (StrToInt (RightStr (Cumul, 1))<>1) and
      (StrToInt (RightStr (Cumul, 1))<>3) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Cumul '+Cumul+' : Pour un'+
                                         ' pr�d�fini Standard, le code cumul'+
                                         ' doit �tre impair terminant par 1 ou'+
                                         ' 3 et sup�rieur � 50'));
}
      Erreur:= True;
      end;
   end
else
if (Predefini='') then
   begin
   Erreur:= True;
   exit;
   end;

Result:= True;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 14/05/2007
Modifi� le ... :   /  /    
Description .. : Traitement du fichier NOMTABLE servant � alimenter la
Suite ........ : table du m�me nom
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
procedure TraitementTable (NomTable, NomBase : string);
var
i:integer;
TTable, TTableFille : TOB;
ControleOK, EstPresent : Boolean;
StReq : string;
RSqlEtablissement : TQuery;
begin
{Voir comment garder la trace
MRecap.Lines.Add (' ');
MRecap.Lines.Add (TraduireMemoire ('Traitement du fichier '+NomTable));
}

if (TExtract.Detail.Count <> 0) then
   begin
   TTable:= TOB.Create (NomTable, nil, -1);
{warning
   TTableFille:= TOB.Create(NomTable, TTable, -1);
}

   if (NomTable='HISTOCUMSAL') then
      TExtract.Detail.Sort ('PHC_ETABLISSEMENT;PHC_SALARIE')
   else
   if (NomTable='ABSENCESALARIE') then
      begin
      TExtract.Detail.Sort ('PCN_SALARIE;PCN_ORDRE');

// Chargement des motifs concernant le type de cong�s
      Tob_MotifAbs:= tob.Create ('tob_motifabs', nil, -1);
      StReq:= 'SELECT PMA_MOTIFABSENCE,PMA_JOURHEURE,PMA_JRSMAXI'+
              ' FROM MOTIFABSENCE';
      Tob_MotifAbs.LoadDetailDBFromSQL ('MOTIFABSENCE', StReq);
      end
   else
   if (NomTable='SALARIES') then
      TExtract.Detail.Sort ('PSA_SALARIE')
   else
   if (NomTable='CUMULPAIE') then
      begin
// Traitement particulier pour le fichier CUMULPAIE
      EstPresent:= ControleCumulPresent;
      if (EstPresent=True) then
         TExtract.Detail.Sort ('PCL_CUMULPAIE');
      end;

   for i := 0 to (TExtract.Detail.Count -1) do
       begin
       TTableFille:= TExtract.detail[i];
       ControleOK:= False;
//Faire les controles n�cessaire sur l'enregistrement en cours
       if (NomTable='HISTOCUMSAL') then
          ControleOK:= ControleValHistoCumul(TTableFille, NomBase)
       else
       if (NomTable='ABSENCESALARIE') then
          begin
          ControleOK:= ControleValAbsenceSalarie(TTableFille, NomBase);
          if (ControleOK) then
// Renseigner les valeurs par d�faut des champs
             EnregAbsenceSalarieDefaut(TTableFille, NomBase);
          end
       else
       if (NomTable='SALARIES') then
          begin
          ControleOK:= ControleValSalaries(TTableFille, NomBase);
          if (ControleOK) then
// Renseigner les valeurs par d�faut des champs
             EnregSalDefaut(TTableFille);
          end
       else
       if (NomTable='ETABLISS') then
          begin
          ControleOK:= ControleValEtabliss(TTableFille, NomBase);
          if (ControleOK) then
// Renseigner les valeurs par d�faut des champs
             EnregEtablissDefaut(TTableFille);
          end
       else
       if (NomTable='ETABCOMPL') then
          begin
          ControleOK:= ControleValEtabCompl (TTableFille, NomBase);
          if (ControleOK) then
// Renseigner les valeurs par d�faut des champs
             EnregEtabComplDefaut(TTableFille);
          end
       else
       if (NomTable='CUMULPAIE') then
          begin
          if (EstPresent=True) then
             TraitementCumulPaie (NomBase);
          ControleOK:= False;
          end
       else
       if (NomTable='SOCIETE') then
          ControleOK:= False
       else
          ControleOK:= True;
          
//Traitement sp�cifique pour le premier �tablissement d�j� cr�� par la compta
       if ((i=0) and ((NomTable='ETABLISS') or (NomTable='ETABCOMPL'))) then
          begin
          if (ControleOK) then
// Mise � jour de l'enregistrement dans la base
             begin
             ExecuteSQL (StringReplace (TTableFille.MakeUpdateSQL,
                                        NomTable+' SET',
                                        NomBase+'.dbo.'+NomTable+' SET',
                                        [RfIgnoreCase]));
             StReq:= 'SELECT ET_ETABLISSEMENT'+
                     ' FROM '+Nombase+'.DBO.ETABLISS'+
                     ' ORDER BY ET_ETABLISSEMENT';
             RSqlEtablissement:= OpenSQL (StReq, True);
             if (not RSqlEtablissement.Eof) then
//--- Maj table PARAMSOC
                ExecuteSQL ('UPDATE '+NomBase+'.dbo.PARAMSOC SET'+
                            ' SOC_DATA="'+RSqlEtablissement.FindField ('ET_ETABLISSEMENT').AsString+'" WHERE'+
                            ' SOC_NOM="SO_ETABLISDEFAUT"');
             Ferme (RSqlEtablissement);
             end;
          end
       else
          begin
          if (ControleOK) then
// Ins�rer l'enregistrement dans la base
             ExecuteSQL (StringReplace (TTableFille.MakeInsertSQL,
                                        'INTO '+NomTable,
                                        'INTO '+NomBase+'.dbo.'+NomTable,
                                        [RfIgnoreCase]));
          end;
       end;
   FreeAndNil (TTable);
   if (NomTable='ABSENCESALARIE') then
      FreeAndNil (Tob_MotifAbs);
   end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : FC
Cr�� le ...... : 02/04/2007
Modifi� le ... :
Description .. : Alimentation des valeurs par d�faut du fichier ETABLISS
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
procedure EnregEtablissDefaut (TEtablissFille : TOB);
begin
  if not TEtablissFille.IsFieldModified('ET_DATELIBRE1') then TEtablissFille.PutValue('ET_DATELIBRE1', IDate1900);
  if not TEtablissFille.IsFieldModified('ET_DATELIBRE2') then TEtablissFille.PutValue('ET_DATELIBRE2', IDate1900);
  if not TEtablissFille.IsFieldModified('ET_DATELIBRE3') then TEtablissFille.PutValue('ET_DATELIBRE3', IDate1900);
  if not TEtablissFille.IsFieldModified('ET_SURSITE') then TEtablissFille.PutValue('ET_SURSITE', 'X');
  if not TEtablissFille.IsFieldModified('ET_NODOSSIER') then TEtablissFille.PutValue('ET_NODOSSIER', V_PGI.NoDossier);
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : FC
Cr�� le ...... : 02/04/2007
Modifi� le ... :
Description .. : Controle des valeurs du fichier ETABLISS
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
function ControleValEtabliss (TEtablissFille : TOB;
                                              NomBase : string) : boolean;
var
St : string;
begin
// A priori renvoie toujours Vrai car on ne fait que signaler les anomalies, rien n'est bloquant
Result:= False;

// Le code �tablissement doit �tre unique
St:= 'SELECT ET_ETABLISSEMENT'+
     ' FROM '+Nombase+'.DBO.ETABLISS WHERE'+
     ' ET_ETABLISSEMENT="'+TEtablissFille.getValue ('ET_ETABLISSEMENT')+'"';
if (ExisteSQL (St)) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('ERREUR : L''�tablissement '+
                                      TEtablissFille.getValue ('ET_ETABLISSEMENT')+
                                      ' existe d�j�'));
}
   Erreur:= True;
   end;

// Le libell� de l'�tablissement doit �tre unique
St:='SELECT ET_ETABLISSEMENT'+
    ' FROM '+Nombase+'.DBO.ETABLISS WHERE'+
    ' ET_LIBELLE="'+TEtablissFille.getValue ('ET_LIBELLE')+'" AND'+
    ' ET_ETABLISSEMENT<>"'+TEtablissFille.getValue ('ET_ETABLISSEMENT')+'"';
if (ExisteSQL (St)) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('ERREUR : Il existe d�j� un'+
                                      ' �tablissement avec le m�me libell� ('+
                                      TEtablissFille.getValue ('ET_ETABLISSEMENT')+
                                      ' '+TEtablissFille.getValue('ET_LIBELLE')+')'));
}
   Erreur := True;
   end;

Result:= True;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : FC
Cr�� le ...... : 02/04/2007
Modifi� le ... :   /  /
Description .. : Alimentation des valeurs par d�faut non fournies du fichier
Suite ........ : ETABCOMPL
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
procedure EnregEtabComplDefaut(TEtabComplFille: TOB);
var
  DateCloture : Tdatetime;
  ANow, MNow, DNow : Word;
begin
  if not TEtabComplFille.IsFieldModified('ETB_DATECLOTURECPN') then
  begin
    // D�terminer la date de cloture CP
    Decodedate(date, ANow, MNow, DNow);
    DateCloture := EncodeDate(ANow, 05, 31);
    if DateCloture <= Now then DateCloture := EncodeDate(ANow + 1, 05, 31);
    TEtabComplFille.PutValue('ETB_DATECLOTURECPN', DateCloture);
  end;
  if not TEtabComplFille.IsFieldModified('ETB_DATEVALTRANS') then TEtabComplFille.PutValue('ETB_DATEVALTRANS', iDate1900);
  if not TEtabComplFille.IsFieldModified('ETB_JOURHEURE') then TEtabComplFille.PutValue('ETB_JOURHEURE', 'HEU');
  if not TEtabComplFille.IsFieldModified('ETB_CODESECTION') then TEtabComplFille.PutValue('ETB_CODESECTION', '1');
  if not TEtabComplFille.IsFieldModified('ETB_PRUDHCOLL') then TEtabComplFille.PutValue('ETB_PRUDHCOLL', '1');
  if not TEtabComplFille.IsFieldModified('ETB_PRUDHSECT') then TEtabComplFille.PutValue('ETB_PRUDHSECT', '4');
  if not TEtabComplFille.IsFieldModified('ETB_PRUDHVOTE') then TEtabComplFille.PutValue('ETB_PRUDHVOTE', '1');
  if not TEtabComplFille.IsFieldModified('ETB_MEDTRAV') then TEtabComplFille.PutValue('ETB_MEDTRAV', -1);
  if not TEtabComplFille.IsFieldModified('ETB_CODEDDTEFP') then TEtabComplFille.PutValue('ETB_CODEDDTEFP', -1);
end;

procedure MajChampOblig(LibChamp : String);
begin
  NbChampOblig := NbChampOblig + 1;
  if (ChampOblig <> '') then
    ChampOblig := ChampOblig + ', ' + LibChamp
  else
    ChampOblig := LibChamp;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : FC
Cr�� le ...... : 02/04/2007
Modifi� le ... :
Description .. : Controle des valeurs du fichier ETABCOMPL
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
function ControleValEtabCompl (TEtabComplFille : TOB;
                                               NomBase : string): boolean;
var
lib, St, StEtab : String;
begin
// A priori renvoie toujours Vrai car on ne fait que signaler les anomalies, rien n'est bloquant
Result:= False;

StEtab:= TEtabComplFille.getValue ('ETB_ETABLISSEMENT')+' '+
         TEtabComplFille.getValue ('ETB_LIBELLE');

// L'�tablissement doit exister dans ETABLISS
St:= 'SELECT ET_ETABLISSEMENT'+
     ' FROM '+Nombase+'.DBO.ETABLISS WHERE'+
     ' ET_ETABLISSEMENT="'+TEtabComplFille.getValue ('ETB_ETABLISSEMENT')+'"';
if (ExisteSQL (St)) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('ERREUR : Etablissement '+
                                      TEtabComplFille.getValue ('ETB_ETABLISSEMENT')+
                                      ' doit exister dans la table ETABLISS'+
                                      ' pour pouvoir saisir des informations'+
                                      ' compl�mentaires'));
}
   Erreur:= True;
   end;

// Le code �tablissement doit �tre unique
St:= 'SELECT ETB_ETABLISSEMENT'+
     ' FROM '+Nombase+'.DBO.ETABCOMPL WHERE'+
     ' ETB_ETABLISSEMENT="'+TEtabComplFille.getValue ('ETB_ETABLISSEMENT')+'"';
if (ExisteSQL (St)) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('AVERTISSEMENT : Des informations'+
                                      ' compl�mentaires existent d�j� pour'+
                                      ' l''�tablissement '+
                                      TEtabComplFille.getValue ('ETB_ETABLISSEMENT')));
}
   end;

// Le libell� de l'�tablissement doit �tre unique
St:= 'SELECT ETB_ETABLISSEMENT'+
     ' FROM '+Nombase+'.DBO.ETABCOMPL WHERE'+
     ' ETB_LIBELLE="'+TEtabComplFille.getValue ('ETB_LIBELLE')+'" AND'+
     ' ETB_ETABLISSEMENT<>"'+TEtabComplFille.getValue ('ETB_ETABLISSEMENT')+'"';
if (ExisteSQL (St)) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('AVERTISSEMENT : Il existe d�j� des'+
                                      ' informations compl�mentaires pour un'+
                                      ' �tablissement ayant le m�me libell� ('+
                                      StEtab+')'));
}
   end;

// ETB_SMIC Test au minimum(smic/conventionnel) si ETB_TYPSMIC saisi
if (TEtabComplFille.getValue ('ETB_TYPSMIC')<>'') and
   (TEtabComplFille.getValue ('ETB_SMIC')='') then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('AVERTISSEMENT : Etablissement '+StEtab+
                                      ' : Il faudrait renseigner la valeur'+
                                      ' Test au minimum(smic/conventionnel)'));
}
   end;
   
// ETB_HORAIREETABL Horaire de r�f�rence
if (TEtabComplFille.getValue ('ETB_HORAIREETABL')='0') then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('ERREUR : Etablissement '+StEtab+' :'+
                                      ' l''horaire de r�f�rence est'+
                                      ' obligatoire.'));
}
   Erreur:= True;
   end;

// Si ETB_CONGESPAYES coch� alors faire les tests li�s aux CP
if (TEtabComplFille.getValue ('ETB_CONGESPAYES')='X') then
   begin
   if (not GetParamSocSecur ('SO_PGCONGES', False)) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Etablissement '+StEtab+' :'+
                                         ' Il faut cocher l''option gestion'+
                                         ' des cong�s pay�s au niveau dossier'+
                                         ' avant de pouvoir la positionner au'+
                                         ' niveau �tablissement.'));
}
      Erreur:= True;
      end;

// ETB_DATECLOTURECPN Date de cloture cp
   if not IsValidDate (string (TEtabComplFille.getValue ('ETB_DATECLOTURECPN'))) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Etablissement '+StEtab+' :'+
                                         ' La date de cl�ture n''est pas'+
                                         ' valide.'));
}
      Erreur:= True;
      end;

// ETB_NBJOUTRAV Controle zone �gale � 5 ou 6
   if ((Valeur (TEtabComplFille.getValue ('ETB_NBJOUTRAV'))>6) or
      (Valeur (TEtabComplFille.getValue ('ETB_NBJOUTRAV'))<5)) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Etablissement '+StEtab+' :'+
                                         ' la zone ETB_NBJOUTRAV doit contenir'+
                                         ' la valeur 5 (ouvr�s) ou (6)'+
                                         ' ouvrables.'));
}
      Erreur:= True;
      end;

// ETB_1ERREPOSH 1er jour de repos obligatoire
   if (TEtabComplFille.getValue ('ETB_1ERREPOSH')='') then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Etablissement '+StEtab+' :'+
                                         ' le 1er jour de repos hebdomadaire'+
                                         ' est obligatoire.'));
}
      Erreur:= True;
      end;

// ETB_2EMEREPOSH 2� jour de repos obligatoire si ETB_NBJOUTRAV = 5
   if (Valeur (TEtabComplFille.getValue ('ETB_NBJOUTRAV'))=5) and
      (TEtabComplFille.getValue ('ETB_2EMEREPOSH')='') then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Etablissement '+StEtab+' :'+
                                         ' le 2�me jour de repos hebdomadaire'+
                                         ' est obligatoire.'));
}
      Erreur:= True;
      end;

// ETB_1ERREPOSH doit �tre diff�rent de ETB_2EMEREPOSH
   if (TEtabComplFille.getValue ('ETB_1ERREPOSH')=TEtabComplFille.getValue ('ETB_2EMEREPOSH')) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('AVERTISSEMENT : Etablissement '+
                                         StEtab+' : le 2�me jour de repos'+
                                         ' hebdomadaire doit �tre diff�rent du'+
                                         ' 1er.'));
}
      end;

// ETB_RELIQUAT la m�thode de gestion de reliquat est obligatoire
   if (TEtabComplFille.getValue ('ETB_RELIQUAT')='') then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Etablissement '+StEtab+' :'+
                                         ' la m�thode de gestion de reliquat'+
                                         ' est obligatoire.'));
}
      Erreur:= True;
      end;

// ETB_VALORINDEMCP la m�thode de valorisation des indemnit� CP est obligatoire
   if (TEtabComplFille.getValue ('ETB_VALORINDEMCP')='') then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Etablissement '+StEtab+' :'+
                                         ' la m�thode de valorisation des'+
                                         ' indemnit� CP est obligatoire'));
}
      Erreur:= True;
      end;

// ETB_MVALOMS la valorisation du maintien est obligatoire
   if (TEtabComplFille.getValue ('ETB_MVALOMS')='') then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Etablissement '+StEtab+' :'+
                                         ' la m�thode de calcul du maintien de'+
                                         ' salaire est obligatoire.'));
}
      Erreur:= True;
      end;

// ETB_NBREACQUISCP nb de jours acquis inf�rieur � 10
   if (Valeur (TEtabComplFille.getValue ('ETB_NBREACQUISCP'))>10) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Etablissement '+StEtab+' :'+
                                         ' le nombre de jour acquis doit �tre'+
                                         ' inf�rieur � 10.'));
}
      Erreur:= True;
      end;

// ETB_DATEACQCPANC Date d'acquisition des cp anciennet�
   if (TEtabComplFille.getValue ('ETB_DATEACQCPANC')<>'') then
      if not PgOkFormatDateJJMM (Copy (TEtabComplFille.getValue ('ETB_DATEACQCPANC'), 1, 2)+
                                 Copy (TEtabComplFille.getValue ('ETB_DATEACQCPANC'), 3, 2)) then
         begin
{Voir comment garder la trace
         MRecap.Lines.Add (TraduireMemoire ('ERREUR : Etablissement '+StEtab+
                                            ' : la date Date d''acquisition'+
                                            ' des CP anciennet�e doit �tre au'+
                                            ' format jj/mm.'));
}
         Erreur:= True;
         end;
   end;

// Date Validit� Transport ETB_DATEVALTRANS
if not IsValidDate (string (TEtabComplFille.getValue ('ETB_DATEVALTRANS'))) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('ERREUR : Etablissement '+StEtab+' : La'+
                                      ' date de validit� transport n''est pas'+
                                      ' valide.'));
}
   Erreur:= True;
   end;

// ETB_JOURPAIEMENT jour de paiement compris entre 1 et 31
if (TEtabComplFille.getValue ('ETB_JOURPAIEMENT')<1) or
   (TEtabComplFille.getValue ('ETB_JOURPAIEMENT')>31) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('ERREUR : Etablissement '+StEtab+' : Le'+
                                      ' jour de paiement doit �tre compris'+
                                      ' entre 1 et 31.'));
}
   Erreur:= True;
   end;

// ETB_JOURHEURE Edition du calendrier en jour ou heure
if (TEtabComplFille.getValue ('ETB_JOURHEURE')<>'JOU') and
   (TEtabComplFille.getValue ('ETB_JOURHEURE')<>'HEU') then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('AVERTISSEMENT : Etablissement '+StEtab+
                                      ' : Le mode d''�dition du calendrier'+
                                      ' doit �tre en jour ou heure.'));
}
   end;
   
// V�rification pr�sence valeurs dans les param�tres tablettes
if VerifPresenceParam then
   begin
// ETB_SMIC Test au minimum(smic/conventionnel) si ETB_TYPSMIC saisi
   if (TEtabComplFille.getValue ('ETB_TYPSMIC')='ELN') then
      begin
      Lib:= RechDom ('PGELEMENTNAT', TEtabComplFille.getValue ('ETB_SMIC'),
                     false);
      if (Lib='') or (Lib='Error') then
         begin
{Voir comment garder la trace
         MRecap.Lines.Add (TraduireMemoire ('AVERTISSEMENT : Etablissement '+
                                            StEtab+' : La valeur Test au'+
                                            ' minimum(smic/conventionnel)'+
                                            ' n''existe pas dans le'+
                                            ' param�trage'));
}
         end;
      end
   else
   if (TEtabComplFille.getValue ('ETB_TYPSMIC')='VAR') then
      begin
      Lib:= RechDom ('PGVARIABLE', TEtabComplFille.getValue ('ETB_SMIC'),
                     false);
      if (Lib='') or (Lib='Error') then
         begin
{Voir comment garder la trace
         MRecap.Lines.Add (TraduireMemoire ('AVERTISSEMENT : Etablissement '+
                                            StEtab+' : La valeur Test au'+
                                            ' minimum(smic/conventionnel)'+
                                            ' n''existe pas dans le'+
                                            ' param�trage'));
}
         end;
      end;

// Si ETB_CONGESPAYES coch� alors faire les tests li�s aux CP
   if (TEtabComplFille.getValue ('ETB_CONGESPAYES')='X') then
      begin
// ETB_NBACQUISCP Nombre de jours CP acquis par mois
      VerifTablette ('ETB_NBACQUISCP', 'PGVARIABLE', 'Etablissement '+StEtab,
                     'La variable permettant la d�termination du Nombre de'+
                     ' jours CP acquis par mois', TEtabComplFille);

// ETB_1ERREPOSH 1er jour de repos obligatoire
      VerifTablette ('ETB_1ERREPOSH', 'YYJOURSSEMAINE', 'Etablissement '+StEtab,
                     'Le type du 1er jour de repos hebdomadaire',
                     TEtabComplFille);

// ETB_2EMEREPOSH 2� jour de repos obligatoire si ETB_NBJOUTRAV = 5
      VerifTablette ('ETB_2EMEREPOSH', 'YYJOURSSEMAINE',
                     'Etablissement '+StEtab,
                     'Le type du 2�me jour de repos hebdomadaire',
                     TEtabComplFille);

// ETB_RELIQUAT la m�thode de gestion de reliquat est obligatoire
      VerifTablette ('ETB_RELIQUAT', 'PGRELIQUATCP', 'Etablissement '+StEtab,
                     'La m�thode de gestion de reliquat', TEtabComplFille);

// ETB_VALORINDEMCP la m�thode de valorisation des indemnit� CP est obligatoire
      VerifTablette ('ETB_VALORINDEMCP', 'PGVALORINDEMCP',
                     'Etablissement '+StEtab,
                     'La m�thode de valorisation des indemnit�s CP',
                     TEtabComplFille);

// ETB_MVALOMS la valorisation du maintien est obligatoire
      VerifTablette ('ETB_MVALOMS', 'PGVALOMS', 'Etablissement '+StEtab,
                     'Le type de valorisation du maintien', TEtabComplFille);

// ETB_PAIEVALOMS valeur pr�sente dans la tablette PGPAIEVALOMS
      VerifTablette ('ETB_PAIEVALOMS', 'PGPAIEVALOMS', 'Etablissement '+StEtab,
                     'Le type de salaire retenu pour le maintien',
                     TEtabComplFille);

// ETB_EDITBULCP valeur pr�sente dans la tablette PGEDITBULCP
      VerifTablette ('ETB_EDITBULCP', 'PGEDITBULCP', 'Etablissement '+StEtab,
                     'Le type d''�dition des compteurs sur bulletin',
                     TEtabComplFille);

// ETB_PROFILCGE profil cong�s pay�s
      VerifTablette ('ETB_PROFILCGE', 'PGPROFILCGE', 'Etablissement '+StEtab,
                     'Le type de profil cong�s pay�s', TEtabComplFille);
      end;

// ETB_PERIODBUL Plafond bulletin
   VerifTablette ('ETB_PERIODBUL', 'PGPROFILPERIODE', 'Etablissement '+StEtab,
                  'Le type de plafond bulletin', TEtabComplFille);

// ETB_PROFILRBS profil R�duction loi Fillon
   VerifTablette ('ETB_PROFILRBS', 'PGPROFILRBS', 'Etablissement '+StEtab,
                  'Le type de profil R�duction loi Fillon', TEtabComplFille);

// ETB_PROFILTRANS profil transport
   VerifTablette ('ETB_PROFILTRANS', 'PGPROFILTRANS', 'Etablissement '+StEtab,
                  'Le type de profil de transport', TEtabComplFille);

// ETB_CONVENTION
   VerifTablette ('ETB_CONVENTION', 'PGCONVENTION', 'Etablissement '+StEtab,
                  'Le type de convention', TEtabComplFille);

// ETB_PGMODEREGLE mode de r�gl�ment
   VerifTablette ('ETB_PGMODEREGLE', 'PGMODEREGLE', 'Etablissement '+StEtab,
                  'Le mode de r�glement', TEtabComplFille);

// ETB_MOISPAIEMENT mois de paiement
   VerifTablette ('ETB_MOISPAIEMENT', 'PGMOISPAIEMENT', 'Etablissement '+StEtab,
                  'Le mois de paiement', TEtabComplFille);

// ETB_PAIACOMPTE mode de r�glement des acomptes
   VerifTablette ('ETB_PAIACOMPTE', 'PGMODEREGLE', 'Etablissement '+StEtab,
                  'Le mode de r�glement des acomptes', TEtabComplFille);

// ETB_PAIFRAIS mode de r�glement des frais professionnels
   VerifTablette ('ETB_PAIFRAIS', 'PGMODEREGLE', 'Etablissement '+StEtab,
                  'Le mode de r�glement des frais professionnels',
                  TEtabComplFille);

// ETB_DADSSECTION Section d'�tablissement DADS Bilat�rale
   VerifTablette ('ETB_DADSSECTION', 'PGDADSSECTION', 'Etablissement '+StEtab,
                  'La section d''�tablissement DADS Bilat�rale',
                  TEtabComplFille);

// ETB_TYPDADSSECT type de section d'�tablissement DADS Bilat�rale
   VerifTablette ('ETB_TYPDADSSECT', 'PGDADSTYPE', 'Etablissement '+StEtab,
                  'Le type de section d''�tablissement DADS Bilat�rale',
                  TEtabComplFille);

// ETB_PRUDH section prud'hommale �tablissement
   VerifTablette ('ETB_PRUDH', 'PGPRUDH', 'Etablissement '+StEtab,
                  'La section prud''hommale �tablissement', TEtabComplFille);

// ETB_PRUDHCOLL Coll�ge prud'hommal
   VerifTablette ('ETB_PRUDHCOLL', 'PGCOLLEGEPRUD', 'Etablissement '+StEtab,
                  'Le Coll�ge prud''hommal', TEtabComplFille);

// ETB_PRUDHSECT Section prud'homamle
   VerifTablette ('ETB_PRUDHSECT', 'PGSECTIONPRUD', 'Etablissement '+StEtab,
                  'La Section prud''hommale', TEtabComplFille);

// ETB_PRUDHVOTE Lieu de vote prud'hommal
   VerifTablette ('ETB_PRUDHVOTE', 'PGLIEUVOTEPRUD', 'Etablissement '+StEtab,
                  'Le Lieu de vote pour les prud''hommes', TEtabComplFille);
   end;

Result:= True;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FC
Cr�� le ...... : 03/04/2007
Modifi� le ... :   /  /
Description .. : Alimentation des valeurs par d�faut non fournies du fichier
Suite ........ : SALARIES
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
procedure EnregSalDefaut (TSalariesFille : TOB);
begin
  if not TSalariesFille.IsFieldModified('PSA_TYPEDITORG') then TSalariesFille.PutValue('PSA_TYPEDITORG', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPNBACQUISCP') then TSalariesFille.PutValue('PSA_TYPNBACQUISCP', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_DATANC') then TSalariesFille.PutValue('PSA_DATANC', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_CPACQUISMOIS') then TSalariesFille.PutValue('PSA_CPACQUISMOIS', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_CPACQUISSUPP') then TSalariesFille.PutValue('PSA_CPACQUISSUPP', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPEDITBULCP') then TSalariesFille.PutValue('PSA_TYPEDITBULCP', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_CPACQUISANC') then TSalariesFille.PutValue('PSA_CPACQUISANC', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_CPTYPEMETHOD') then TSalariesFille.PutValue('PSA_CPTYPEMETHOD', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_CPTYPERELIQ') then TSalariesFille.PutValue('PSA_CPTYPERELIQ', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_CPTYPEVALO') then TSalariesFille.PutValue('PSA_CPTYPEVALO', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPREGLT') then TSalariesFille.PutValue('PSA_TYPREGLT', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPDATPAIEMENT') then TSalariesFille.PutValue('PSA_TYPDATPAIEMENT', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_PRISEFFECTIF') then TSalariesFille.PutValue('PSA_PRISEFFECTIF', 'X');
  if not TSalariesFille.IsFieldModified('PSA_UNITEPRISEFF') then TSalariesFille.PutValue('PSA_UNITEPRISEFF', 1);
  if not TSalariesFille.IsFieldModified('PSA_TYPACTIVITE') then TSalariesFille.PutValue('PSA_TYPACTIVITE', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPROFIL') then TSalariesFille.PutValue('PSA_TYPPROFIL', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPERIODEBUL') then TSalariesFille.PutValue('PSA_TYPPERIODEBUL', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPROFILRBS') then TSalariesFille.PutValue('PSA_TYPPROFILRBS', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPROFILAFP') then TSalariesFille.PutValue('PSA_TYPPROFILAFP', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPROFILAPP') then TSalariesFille.PutValue('PSA_TYPPROFILAPP', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPROFILMUT') then TSalariesFille.PutValue('PSA_TYPPROFILMUT', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPROFILPRE') then TSalariesFille.PutValue('PSA_TYPPROFILPRE', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPROFILTSS') then TSalariesFille.PutValue('PSA_TYPPROFILTSS', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPROFILCGE') then TSalariesFille.PutValue('PSA_TYPPROFILCGE', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPROFILANC') then TSalariesFille.PutValue('PSA_TYPPROFILANC', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPROFILFNAL') then TSalariesFille.PutValue('PSA_TYPPROFILFNAL', 'DOS');
  if not TSalariesFille.IsFieldModified('PSA_TYPPROFILTRANS') then TSalariesFille.PutValue('PSA_TYPPROFILTRANS', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPROFILRET') then TSalariesFille.PutValue('PSA_TYPPROFILRET', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPAIACOMPT') then TSalariesFille.PutValue('PSA_TYPPAIACOMPT', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPAIFRAIS') then TSalariesFille.PutValue('PSA_TYPPAIFRAIS', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_DATELIBRE1') then TSalariesFille.PutValue('PSA_DATELIBRE1', IDate1900);
  if not TSalariesFille.IsFieldModified('PSA_DATELIBRE2') then TSalariesFille.PutValue('PSA_DATELIBRE2', IDate1900);
  if not TSalariesFille.IsFieldModified('PSA_DATELIBRE3') then TSalariesFille.PutValue('PSA_DATELIBRE3', IDate1900);
  if not TSalariesFille.IsFieldModified('PSA_DATELIBRE4') then TSalariesFille.PutValue('PSA_DATELIBRE4', IDate1900);
  if not TSalariesFille.IsFieldModified('PSA_DATELIBRE5') then TSalariesFille.PutValue('PSA_DATELIBRE5', IDate1900);
  if not TSalariesFille.IsFieldModified('PSA_DATELIBRE6') then TSalariesFille.PutValue('PSA_DATELIBRE6', IDate1900);
  if not TSalariesFille.IsFieldModified('PSA_DATELIBRE7') then TSalariesFille.PutValue('PSA_DATELIBRE7', IDate1900);
  if not TSalariesFille.IsFieldModified('PSA_DATELIBRE8') then TSalariesFille.PutValue('PSA_DATELIBRE8', IDate1900);
  if not TSalariesFille.IsFieldModified('PSA_ORDREAT') then TSalariesFille.PutValue('PSA_ORDREAT', '1');
  if not TSalariesFille.IsFieldModified('PSA_CATBILAN') then TSalariesFille.PutValue('PSA_CATBILAN', '000');
  if not TSalariesFille.IsFieldModified('PSA_STANDCALEND') then TSalariesFille.PutValue('PSA_STANDCALEND', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPJOURHEURE') then TSalariesFille.PutValue('PSA_TYPJOURHEURE', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_JOURHEURE') then TSalariesFille.PutValue('PSA_JOURHEURE', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPREDREPAS') then TSalariesFille.PutValue('PSA_TYPREDREPAS', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPREDRTT1') then TSalariesFille.PutValue('PSA_TYPREDRTT1', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPREDRTT2') then TSalariesFille.PutValue('PSA_TYPREDRTT2', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPPROFILREM') then TSalariesFille.PutValue('PSA_TYPPROFILREM', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPVIRSOC') then TSalariesFille.PutValue('PSA_TYPVIRSOC', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPACPSOC') then TSalariesFille.PutValue('PSA_TYPACPSOC', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TYPFRAISSOC') then TSalariesFille.PutValue('PSA_TYPFRAISSOC', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_CONFIDENTIEL') then TSalariesFille.PutValue('PSA_CONFIDENTIEL', '0');
  if not TSalariesFille.IsFieldModified('PSA_DADSDATE') then TSalariesFille.PutValue('PSA_DADSDATE', IDate1900);
  if not TSalariesFille.IsFieldModified('PSA_TYPDADSFRAC') then TSalariesFille.PutValue('PSA_TYPDADSFRAC', 'ETB');
  if not TSalariesFille.IsFieldModified('PSA_TOPCONVERT') then TSalariesFille.PutValue('PSA_TOPCONVERT', 'X');
  if not TSalariesFille.IsFieldModified('PSA_ETATBULLETIN') then TSalariesFille.PutValue('PSA_ETATBULLETIN','PBP');
  if not TSalariesFille.IsFieldModified('PSA_NATIONALITE') then TSalariesFille.PutValue('PSA_NATIONALITE', 'FRA');
  if not TSalariesFille.IsFieldModified('PSA_PAYSNAISSANCE') then TSalariesFille.PutValue('PSA_PAYSNAISSANCE', 'FRA');
  if not TSalariesFille.IsFieldModified('PSA_TYPCONVENTION') then TSalariesFille.PutValue('PSA_TYPCONVENTION', 'PER');
  if not TSalariesFille.IsFieldModified('PSA_REGIMESS') then TSalariesFille.PutValue('PSA_REGIMESS', '200');
  if not TSalariesFille.IsFieldModified('PSA_TYPPRUDH') then TSalariesFille.PutValue('PSA_TYPPRUDH', 'ETB');
end;

{***********A.G.L.***********************************************
Auteur  ...... : FC
Cr�� le ...... : 03/04/2007
Modifi� le ... :   /  /
Description .. : Controle des valeurs du fichier SALARIES
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
function ControleValSalaries (TSalariesFille : TOB;
                                              NomBase : string): boolean;
var
Civilite, CleSexe, Lib, Lib1, Lib2, Lib3, Lib4, LibAvetSal, LibErrSal : String;
LibSal, NomJFille, NoSS, Numero, Sexe, St : String;
Nombre, Num, Resultat : integer;
DEntree,DNaissance : TDateTime;
const
Voyelle = ['a', 'e', 'i', 'u', 'y', 'o', 'A', 'E', 'I', 'U', 'Y', 'O'];
begin
// A priori renvoie toujours Vrai car on ne fait que signaler les anomalies, rien n'est bloquant
Result := False;

LibSal:= 'Salari� '+TSalariesFille.getValue ('PSA_SALARIE')+' '+
         TSalariesFille.getValue ('PSA_LIBELLE')+' '+
         TSalariesFille.getValue('PSA_PRENOM');
LibAvetSal:= 'AVERTISSEMENT : '+LibSal;
LibErrSal:= 'ERREUR : '+LibSal;
// Rajouter les �ventuels z�ros de gauche dans le num�ro du salari�
if (PGTypeNumSal = 'NUM') and
   (isnumeric (TSalariesFille.getValue ('PSA_SALARIE'))) and
   (TSalariesFille.getValue ('PSA_SALARIE') <> '') and
   (Length(TSalariesFille.getValue ('PSA_SALARIE')) < 10) then
   TSalariesFille.PutValue ('PSA_SALARIE',
                            ColleZeroDevant (StrToInt (trim (TSalariesFille.getValue ('PSA_SALARIE'))), 10));

// Le salari� ne doit pas d�j� exister
St:= 'SELECT PSA_SALARIE'+
     ' FROM '+Nombase+'.DBO.SALARIES WHERE'+
     ' PSA_SALARIE="'+TSalariesFille.getValue ('PSA_SALARIE')+'"';
if (ExisteSQL (St)) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' d�j� pr�sent'));
}
   Erreur:= True;
   end;

// L'�tablissement doit exister
St:= 'SELECT ET_ETABLISSEMENT'+
     ' FROM '+Nombase+'.DBO.ETABLISS WHERE'+
     ' ET_ETABLISSEMENT="'+TSalariesFille.getValue ('PSA_ETABLISSEMENT')+'"';
if (ExisteSQL (St)=False) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : L''�tablissement n''existe'+
                                      ' pas.'));
}
   Erreur:= True;
   end
else
   begin
// L'�tablissement doit comporter des informations sur le social ETABCOMPL
   St:= 'SELECT ETB_ETABLISSEMENT'+
        ' FROM '+Nombase+'.DBO.ETABCOMPL WHERE'+
        ' ETB_ETABLISSEMENT="'+TSalariesFille.getValue('PSA_ETABLISSEMENT')+'"';
   if (ExisteSQL (St)=False) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : L''�tablissement ne'+
                                         ' comporte pas d''informations sur le'+
                                         ' social.'));
}
      Erreur:= True;
      end;
   end;

// PSA_TYPNBACQUISCP
if (TSalariesFille.getValue ('PSA_TYPNBACQUISCP') = 'PER') then
   begin
   Lib:= RechDom ('PGVARIABLE', TSalariesFille.getValue ('PSA_NBACQUISCP'), FALSE);
   if (Lib = '') or (Lib = 'Error') then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Le champ jour acquis'+
                                         ' bulletin doit �tre renseign� avec'+
                                         ' une variable existante.'));
}
      Erreur:= True;
      end;
   end;

// Zones obligatoires
ChampOblig:= '';
NbChampOblig:= 0;
if (TSalariesFille.getValue ('PSA_SALARIE') <> '') and
   (length (TSalariesFille.getValue ('PSA_SALARIE'))<11) then
   begin
   if (TSalariesFille.getValue ('PSA_ETABLISSEMENT')='') then
      MajChampOblig ('l''�tablissement');
   if (TSalariesFille.getValue ('PSA_LIBELLE')='') then
      MajChampOblig ('le nom');
   if (TSalariesFille.getValue ('PSA_PRENOM')='') then
      MajChampOblig ('le pr�nom');
   if (TSalariesFille.getValue ('PSA_CIVILITE')='') then
      MajChampOblig ('la civilit�');
   if (TSalariesFille.getValue ('PSA_SEXE')='') then
      MajChampOblig ('le sexe');
   if (TSalariesFille.getValue ('PSA_ADRESSE1')='') then
      MajChampOblig ('l''adresse');
   if (TSalariesFille.getValue ('PSA_CODEPOSTAL')='') then
      MajChampOblig ('le code postal');
   if (TSalariesFille.getValue ('PSA_VILLE')='') then
      MajChampOblig ('la ville');
   if (TSalariesFille.getValue ('PSA_DATEENTREE')=iDate1900) then
      MajChampOblig ('la date d''entr�e');
   end;

Lib:= GetParamSocSecur ('SO_PGLIBCODESTAT', '');
if ((TSalariesFille.getValue ('PSA_CODESTAT')='') and (Lib<>'')) then
   begin
   if (Lib[1] in Voyelle) then
      MajChampOblig ('l''' + Lib)
   else
      MajChampOblig ('le ' + Lib);
   end;

Nombre:= GetParamSocSecur ('SO_PGNBRESTATORG', 0);
if (Nombre <> 0) then
   begin
   Lib1:= GetParamSocSecur ('SO_PGLIBORGSTAT1', '');
   Lib2:= GetParamSocSecur ('SO_PGLIBORGSTAT2', '');
   Lib3:= GetParamSocSecur ('SO_PGLIBORGSTAT3', '');
   Lib4:= GetParamSocSecur ('SO_PGLIBORGSTAT4', '');
   for Num := 1 to Nombre do
       begin
       Numero:= InttoStr (Num);
       if (Num > Nombre) then
          exit;
       if (TSalariesFille.getValue ('PSA_TRAVAILN'+Numero)='') then
          begin
          if ((Num = 1) and (Lib1 <> '')) then
             begin
             if (Lib1[1] in Voyelle) then
                MajChampOblig ('l'''+Lib1)
             else
                MajChampOblig ('le '+Lib1);
             end;
          if ((Num = 2) and (Lib2 <> '')) then
             begin
             if (Lib2[1] in Voyelle) then
                MajChampOblig ('l'''+Lib2)
             else
                MajChampOblig ('le '+Lib2);
             end;
          if ((Num = 3) and (Lib3 <> '')) then
             begin
             if (Lib3[1] in Voyelle) then
                MajChampOblig ('l'''+Lib3)
             else
                MajChampOblig ('le '+Lib3);
             end;
          if ((Num = 4) and (Lib4 <> '')) then
             begin
             if (Lib4[1] in Voyelle) then
                MajChampOblig ('l'''+Lib4)
             else
                MajChampOblig ('le '+Lib4);
             end;
          end;
       end;
   end;

Nombre:= GetParamSocSecur ('SO_PGNBCOMBO', 0);
if (Nombre <> 0) then
   begin
   Lib1:= GetParamSocSecur ('SO_PGLIBCOMBO1', '');
   Lib2:= GetParamSocSecur ('SO_PGLIBCOMBO2', '');
   Lib3:= GetParamSocSecur ('SO_PGLIBCOMBO3', '');
   Lib4:= GetParamSocSecur ('SO_PGLIBCOMBO4', '');

   for Num := 1 to Nombre do
       begin
       Numero:= InttoStr (Num);
       if (Num > Nombre) then
          exit;
       if (TSalariesFille.getValue ('PSA_LIBREPCMB'+Numero)='') then
          begin
          if ((Num = 1) and (Lib1 <> '')) then
             begin
             if (Lib1[1] in Voyelle) then
                MajChampOblig ('l'''+Lib1)
             else
                MajChampOblig ('le '+Lib1);
             end;
          if ((Num = 2) and (Lib2 <> '')) then
             begin
             if (Lib2[1] in Voyelle) then
                MajChampOblig ('l'''+Lib2)
             else
                MajChampOblig ('le '+Lib2);
             end;
          if ((Num = 3) and (Lib3 <> '')) then
             begin
             if (Lib3[1] in Voyelle) then
                MajChampOblig ('l'''+Lib3)
             else
                MajChampOblig ('le '+Lib3);
             end;
          if ((Num = 4) and (Lib4 <> '')) then
             begin
             if (Lib4[1] in Voyelle) then
                MajChampOblig ('l'''+Lib4)
             else
                MajChampOblig ('le '+Lib4);
             end;
          end;
       end;
   end;

if (TSalariesFille.getValue ('PSA_CONDEMPLOI')='P') and
   (TSalariesFille.getValue ('PSA_TAUXPARTIEL') = 0) then
   MajChampOblig ('le taux temps partiel');

if (NbChampOblig > 1) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Les champs suivants sont'+
                                      ' obligatoires : '+ChampOblig));
}
   Erreur:= True;
   end
else
if (NbChampOblig = 1) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Le champ suivant est'+
                                      ' obligatoire : '+ChampOblig));
}
   Erreur:= True;
   end;

// Erreurs li�s au sexe et num�ro de s�curit� sociale
Sexe:= TSalariesFille.getValue ('PSA_SEXE');
NoSS:= TSalariesFille.getValue ('PSA_NUMEROSS');
if (Sexe <> '') then
   begin
   if (NoSS <> '') then
      begin
// Les infos ci dessous seront n�cessaire dans TestNumeroSSNaissance
      if (TSalariesFille.getValue ('PSA_DEPTNAISSANCE')<>'') and
         (TSalariesFille.getValue ('PSA_DATENAISSANCE')<>iDate1900) then
         begin
//Les test sur l'ann�e, le mois et le d�partements de naissance
//sont effectu�s que si le num�ro SS fait 15 caract�res, et avant le test de la cl�
         if (Length(NoSS)=15) or (Length(NoSS)=13) then
            begin
            TestNumeroSSNaissance (NoSS, 'Annee',
                                   TSalariesFille.GetValue ('PSA_DATENAISSANCE'),
                                   TSalariesFille.getValue ('PSA_DEPTNAISSANCE'),
                                   ResultAnnee, ResultMois, ResultDepart);
            TestNumeroSSNaissance (NoSS, 'Mois',
                                   TSalariesFille.GetValue ('PSA_DATENAISSANCE'),
                                   TSalariesFille.getValue ('PSA_DEPTNAISSANCE'),
                                   ResultAnnee, ResultMois, ResultDepart);
            TestNumeroSSNaissance (NoSS, 'Depart',
                                   TSalariesFille.GetValue ('PSA_DATENAISSANCE'),
                                   TSalariesFille.getValue ('PSA_DEPTNAISSANCE'),
                                   ResultAnnee, ResultMois, ResultDepart);
            if (ResultAnnee=-8) then
               begin
{Voir comment garder la trace
               MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : L''ann�e de'+
                                                  ' naissance dans le num�ro'+
                                                  ' de s�curit� sociale est'+
                                                  ' erron�e.'));
}
               Erreur:= True;
               end;
            if (ResultMois=-9) then
               begin
{Voir comment garder la trace
               MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Le mois de'+
                                                  ' naissance dans le num�ro'+
                                                  ' de s�curit� sociale est'+
                                                  ' erron�.'));
}
               Erreur:= True;
               end;
            if (ResultDepart=-10) then
               begin
{Voir comment garder la trace
               MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Le d�partement'+
                                                  ' de naissance dans le'+
                                                  ' num�ro de s�curit�'+
                                                  ' sociale est erron�.'));
}
               Erreur:= True;
               end;
            if (ResultDepart=-12) then
               begin
{Voir comment garder la trace
               MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : La date de naissance'+
                                                  ' du salari� �tant inf�rieure'+
                                                  ' au 01/01/1976, le code du d�partement'+
                                                  ' dans le num�ro de s�curit� sociale'+
                                                  ' ne peut �tre 2A ou 2B.'));
}
               Erreur:= True;
               end;
            end;
         end;

      Resultat:= TestNumeroSS (NoSS, Sexe);
      if (Length (NoSS) <> 0) then
         begin
         CleSexe:= NoSS[1];
         if (Resultat <> 0) then
            begin
            Erreur:= True;
{Voir comment garder la trace
            case Resultat of
                 1: MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Vous'+
                                                       ' n''avez pas renseign�'+
                                                       ' le num�ro de s�curit�'+
                                                       ' sociale.'));
                 3: MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Le num�ro'+
                                                       ' de s�curit� sociale'+
                                                       ' est provisoire. Vous'+
                                                       ' devrez le remplacer'+
                                                       ' par un num�ro d�finitif.'));
                 -2: MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Le num�ro'+
                                                        ' de s�curit� sociale'+
                                                        ' ne comporte pas de'+
                                                        ' cl�.'));
                 -3: MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Le num�ro'+
                                                        ' de s�curit� sociale'+
                                                        ' est incomplet, 15'+
                                                        ' positions'+
                                                        ' obligatoires.'));
                 -7: MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Le num�ro'+
                                                        ' de s�curit� sociale'+
                                                        ' est incorrect. Ce'+
                                                        ' doit �tre une valeur'+
                                                        ' num�rique.'));
                 -5: MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : La cl� sexe'+
                                                        ' est erron�e : "'+CleSexe+'".'+
                                                        ' La cl� sexe du'+
                                                        ' num�ro de s�curit�'+
                                                        ' sociale vaut "2".'));
                 -6: MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : La cl� sexe'+
                                                        ' est erron�e : "'+CleSexe+'".'+
                                                        ' La cl� sexe du'+
                                                        ' num�ro de s�curit�'+
                                                        ' sociale vaut "1".'));
                 -4: begin
                     if (Sexe = 'M') then
                        MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : La'+
                                                           ' cl� sexe est'+
                                                           ' erron�e : "'+
                                                           CleSexe+'". La cl�'+
                                                           ' sexe vaut "1".'));
                     if (Sexe = 'F') then
                        MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : La'+
                                                           ' cl� sexe est'+
                                                           ' erron�e : "'+
                                                           CleSexe+'". La cl�'+
                                                           ' sexe vaut "2".'));
                     end;
                 -1: MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : La cl�'+
                                                        ' est erron�e.'));
                 end;
}
            end;
         end;
      end;
   end;

// Controle contenu des champs Horaires
if TestHoraire (TSalariesFille.getValue ('PSA_HORHEBDO'),
                TSalariesFille.getValue ('PSA_HORAIREMOIS'))=True then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : L''horaire hebdomadaire ne'+
                                      ' peut �tre sup�rieur � l''horaire'+
                                      ' mensuel.'));
}
   Erreur:= True;
   end;
if TestHoraire (TSalariesFille.getValue ('PSA_HORHEBDO'),
                TSalariesFille.getValue('PSA_HORANNUEL'))=True then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : L''horaire hebdomadaire ne'+
                                      ' peut �tre sup�rieur � l''horaire'+
                                      ' annuel.'));
}
   Erreur:= True;
   end;
if TestHoraire (TSalariesFille.getValue ('PSA_HORAIREMOIS'),
                TSalariesFille.getValue('PSA_HORANNUEL'))=True then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : L''horaire mensuel ne peut'+
                                      ' �tre sup�rieur � l''horaire annuel.'));
}
   Erreur:= True;
   end;

// Incoh�rence Civilit�/Sexe/Nom de jeune fille
Civilite:= TSalariesFille.getValue ('PSA_CIVILITE');
NomJFille:= TSalariesFille.getValue ('PSA_NOMJF');
if (Sexe = 'M') and (NomJFille <> '') then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Incoh�rence entre le nom'+
                                      ' de jeune fille et le sexe.'));
}
   Erreur:= True;
   end;
if (((Civilite = 'MLE') or (Civilite = 'MME')) and (Sexe = 'M')) or
   ((Civilite = 'MR') and (Sexe = 'F')) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Incoh�rence entre la'+
                                      ' civilit� et le sexe.'));
}
   Erreur:= True;
   end;
if (Sexe = 'M') and (Civilite = 'MLE') and (NomJFille <> '') then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Incoh�rence entre le nom'+
                                      ' de jeune fille, la civilit� et le'+
                                      ' sexe.'));
}
   Erreur:= True;
   end;
if (Sexe = 'M') and (Civilite <> 'MLE') and (NomJFille <> '') then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Incoh�rence entre le nom'+
                                      ' de jeune fille et le sexe.'));
}
   Erreur:= True;
   end;
if (Sexe <> 'M') and (Civilite = 'MLE') and (NomJFille <> '') then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Incoh�rence entre le nom'+
                                      ' de jeune fille et la civilit�.'));
}
   Erreur:= True;
   end;
if ((Sexe = 'M') or  (Civilite = 'MLE')) and (NomJFille <> '') then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Incoh�rence entre le nom'+
                                      ' de jeune fille et la civilit� et le'+
                                      ' sexe.'));
}
   Erreur:= True;
   end;

// PSA_DATENAISSANCE Date de naissance valide
if not IsValidDate (String (TSalariesFille.getValue ('PSA_DATENAISSANCE'))) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : La date de naissance'+
                                      ' n''est pas valide.'));
}
   Erreur:= True;
   end;

// La date de naissance ne doit pas �tre inf�rieure � la date d'entr�e
DEntree:= TSalariesFille.getValue ('PSA_DATEENTREE');
DNaissance:= TSalariesFille.getValue ('PSA_DATENAISSANCE');
if (DEntree <> idate1900) and (DNaissance <> idate1900) and
   (DEntree < DNaissance) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : La date de naissance ne'+
                                      ' peut �tre sup�rieure � la date'+
                                      ' d''entr�e.'));
}
   Erreur:= True;
   end;

// PSA_DATEENTREE Date d'entr�e
if not IsValidDate (string (TSalariesFille.getValue ('PSA_DATEENTREE'))) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : La date d''entr�e n''est'+
                                      ' pas valide.'));
}
   Erreur:= True;
   end;

// PSA_DATESORTIE Date de sortie
if not IsValidDate (string (TSalariesFille.getValue ('PSA_DATESORTIE'))) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : La date de sortie n''est'+
                                      ' pas valide.'));
}
   Erreur:= True;
   end;

// Pas de motif de sortie si pas de date de sortie
if (TSalariesFille.getValue ('PSA_DATESORTIE')<Idate1900) and
   (TSalariesFille.getValue ('PSA_MOTIFSORTIE')<>'') then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : Aucun motif de sortie ne'+
                                      ' peut �tre saisi car la date de sortie'+
                                      ' n''est pas une date valide.'));
}
   Erreur:= True;
   end;

// PSA_DATEANCIENNETE Date de d�but d'anciennet�
if not IsValidDate (string (TSalariesFille.getValue ('PSA_DATEANCIENNETE'))) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : La date de d�but'+
                                      ' d''anciennet� n''est pas valide.'));
}
   Erreur:= True;
   end;

// PSA_ANCIENPOSTE Anciennet� dans le poste
if not IsValidDate (string (TSalariesFille.getValue ('PSA_ANCIENPOSTE'))) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire (LibErrSal+' : La date d''anciennet� dans'+
                                      ' le poste n''est pas valide.'));
}
   Erreur:= True;
   end;

// V�rification pr�sence valeurs dans les param�tres tablettes
if VerifPresenceParam then
   begin
// PSA_CIVILITE Civilit�
   VerifTablette ('PSA_CIVILITE', 'YYCIVILITE', LibSal, 'La Civilit�',
                  TSalariesFille);

// PSA_SEXE Sexe
   VerifTablette ('PSA_SEXE', 'PGSEXE', LibSal, 'Le sexe', TSalariesFille);

// PSA_PAYS Pays
   VerifTablette ('PSA_PAYS', 'TTPAYS', LibSal, 'Le pays', TSalariesFille);

// PSA_NATIONALITE Nationalit�
   VerifTablette ('PSA_NATIONALITE', 'YYNATIONALITE', LibSal, 'La nationalit�',
                  TSalariesFille);

// PSA_PAYSNAISSANCE Pays de naissance
   VerifTablette ('PSA_PAYSNAISSANCE', 'TTPAYS', LibSal, 'Le pays de naissance',
                  TSalariesFille);

// PSA_SITUATIONFAMIL Situation de famille
   VerifTablette ('PSA_SITUATIONFAMIL', 'PGSITUATIONFAMIL', LibSal,
                  'La situation de famille', TSalariesFille);

// PSA_MOTIFENTREE Motif d'entr�e
   VerifTablette ('PSA_MOTIFENTREE', 'PGMOTIFENTREELIGHT', LibSal,
                  'Le motif d''entr�e', TSalariesFille);

// PSA_MOTIFSORTIE Motif de sortie
   VerifTablette ('PSA_MOTIFSORTIE', 'PGMOTIFSORTIE', LibSal,
                  'Le motif de sortie', TSalariesFille);

// PSA_CATDADS Cat�gorie DUCS
   VerifTablette ('PSA_CATDADS', 'PGCATBILAN', LibSal,
                  'La cat�gorie DUCS', TSalariesFille);

// PSA_CONVENTION Convention collective
   VerifTablette ('PSA_CONVENTION', 'PGCONVENTION', LibSal,
                  'La convention collective', TSalariesFille);

// PSA_CODEEMPLOI Nomenclature PCS
   VerifTablette ('PSA_CODEEMPLOI', 'PGCODEPCSESE', LibSal,
                  'La nomenclature PCS', TSalariesFille);

// PSA_LIBELLEEMPLOI Libell� emploi
   VerifTablette ('PSA_LIBELLEEMPLOI', 'PGLIBEMPLOI',LibSal,
                  'Le libell� emploi', TSalariesFille);

// PSA_QUALIFICATION Qualification
   VerifTablette ('PSA_QUALIFICATION', 'PGLIBQUALIFICATION', LibSal,
                  'La qualification', TSalariesFille);

// PSA_COEFFICIENT Coefficient
   VerifTablette ('PSA_COEFFICIENT', 'PGLIBCOEFFICIENT', LibSal,
                  'Le coefficient', TSalariesFille);

// PSA_INDICE Indice
   VerifTablette ('PSA_INDICE', 'PGLIBINDICE', LibSal,
                  'L''indice', TSalariesFille);

// PSA_NIVEAU Niveau
   VerifTablette ('PSA_NIVEAU', 'PGLIBNIVEAU', LibSal, 'Le niveau',
                  TSalariesFille);

// PSA_EDITORG Organisme � �diter
   VerifTablette ('PSA_EDITORG', 'PGORGANISME1', LibSal,
                  'L''organisme � �diter', TSalariesFille);

// PSA_ACTIVITE Activit�
   VerifTablette ('PSA_ACTIVITE', 'PGACTIVITE', LibSal, 'L''activit�',
                  TSalariesFille);

// PSA_PROFILREM Profil de r�mun�ration
   VerifTablette ('PSA_PROFILREM', 'PGPROFILREM', LibSal,
                  'Le profil r�mun�ration', TSalariesFille);

// PSA_PERIODBUL P�riodicit� plafond
   VerifTablette ('PSA_PERIODBUL', 'PGPROFILPERIODE', LibSal,
                  'La p�riodicit� plafond', TSalariesFille);

// PSA_PROFILTPS Temps partiel
   VerifTablette ('PSA_PROFILTPS', 'PGPROFILTPS', LibSal,
                  'Le type de temps partiel', TSalariesFille);

// PSA_PROFILRBS Profil r�duction loi Fillon
   VerifTablette ('PSA_PROFILRBS', 'PGPROFILRBS', LibSal,
                  'Le profil r�duction loi Fillon', TSalariesFille);

// PSA_REDRTT2 Profil minoration loi Fillon
   VerifTablette ('PSA_REDRTT2', 'PGPROFILRTT2', LibSal,
                  'Le profil minoration loi Fillon', TSalariesFille);

// PSA_REDRTT1 Profil R�duction RTT loi Aubry 2
   VerifTablette ('PSA_REDRTT1', 'PGPROFILRTT1', LibSal,
                  'Le profil r�duction RTT loi Aubry 2', TSalariesFille);

// PSA_REDREPAS Profil R�duction repas
   VerifTablette ('PSA_REDREPAS', 'PGPROFILREPAS', LibSal,
                  'Le profil r�duction repas', TSalariesFille);

// PSA_PROFILAFP Profil abattement frais professionnels
   VerifTablette ('PSA_PROFILAFP', 'PGPROFILAFP', LibSal,
                  'Le profil abattement frais professionnels', TSalariesFille);

// PSA_PROFILAPP Profil gestion des appoints
   VerifTablette ('PSA_PROFILAPP', 'PGPROFILAPP', LibSal,
                  'Le profil gestion des appoints', TSalariesFille);

// PSA_PROFILRET Profil retraite
   VerifTablette ('PSA_PROFILRET', 'PGPROFILRET', LibSal,
                  'Le profil retraite', TSalariesFille);

// PSA_PROFILMUT Profil Cotisations mutuelle
   VerifTablette ('PSA_PROFILMUT', 'PGPROFILMUT', LibSal,
                  'Le profil cotisations mutuelle', TSalariesFille);

// PSA_PROFILPRE Profil Cotisations pr�voyance
   VerifTablette ('PSA_PROFILPRE', 'PGPROFILPRE', LibSal,
                  'Le profil cotisations pr�voyance', TSalariesFille);

// PSA_PROFILTSS Profil taxe sur les salaires
   VerifTablette ('PSA_PROFILTSS', 'PGPROFILTTS', LibSal,
                  'Le profil taxe sur les salaires', TSalariesFille);

// PSA_PROFILFNAL Profil FNAL + 9 salari�s
   VerifTablette ('PSA_PROFILFNAL', 'PGPROFILFNAL', LibSal,
                  'Le profil FNAL + 9 salari�s', TSalariesFille);

// PSA_PROFILTRANS Profil Transport + 9 salari�s
   VerifTablette ('PSA_PROFILTRANS', 'PGPROFILTRANS', LibSal,
                  'Le profil Transport + 9 salari�s', TSalariesFille);

// PSA_CALENDRIER calendrier
   VerifTablette ('PSA_CALENDRIER', 'AFTSTANDCALEN', LibSal, 'Le calendrier',
                  TSalariesFille);

// PSA_PROFILCDD Calcul prime de pr�carit�
   VerifTablette ('PSA_PROFILCDD', 'PGPROFILCDD', LibSal,
                  'Le type de calcul prime de pr�carit�', TSalariesFille);

// PSA_REGIMESS R�gime s�curit� sociale
   VerifTablette ('PSA_REGIMESS', 'PGREGIMESS', LibSal,
                  'Le r�gime de s�curit� sociale', TSalariesFille);

// PSA_DADSCAT Statut cat�goriel
   VerifTablette ('PSA_DADSCAT', 'PGSCATEGORIEL', LibSal,
                  'Le statut cat�goriel', TSalariesFille);

// PSA_DADSPROF Statut professionnel
   VerifTablette ('PSA_DADSPROF', 'PGSPROFESSIONNEL', LibSal,
                  'Le statut professionnel', TSalariesFille);

// PSA_DADSFRACTION Fraction DADS
   VerifTablette ('PSA_DADSFRACTION', 'PGCODESECTION', LibSal,
                  'La fraction DADS', TSalariesFille);

// PSA_TRAVETRANG Type travailleur �tranger ou frontalier
   VerifTablette ('PSA_TRAVETRANG', 'PGTRAVAILETRANGER', LibSal,
                  'Le type travailleur �tranger ou frontalier', TSalariesFille);

// PSA_CONDEMPLOI Condition d'emploi
   if (TSalariesFille.getValue ('PSA_CONDEMPLOI')<>'') then
      begin
      St:= 'SELECT CO_LIBRE'+
           ' FROM COMMUN WHERE'+
           ' CO_TYPE="PCI" AND'+
           ' CO_CODE="'+TSalariesFille.getValue ('PSA_CONDEMPLOI')+'"';
      if (ExisteSQL (St)=False) then
         begin
{Voir comment garder la trace
         MRecap.Lines.Add (TraduireMemoire (LibAvetSal+' : La condition'+
                                            ' d''emploi n''existe pas dans le'+
                                            ' param�trage.'));
}
         end;
      end;

// PSA_PRUDHCOLL Coll�ge prud'hommal
   VerifTablette ('PSA_PRUDHCOLL', 'PGCOLLEGEPRUD', LibSal,
                  'Le coll�ge prud''hommal', TSalariesFille);

// PSA_PRUDHSECT Section prud'hommale
   VerifTablette ('PSA_PRUDHSECT', 'PGSECTIONPRUD', LibSal,
                  'La section prud''hommale', TSalariesFille);

// PSA_PRUDHVOTE Bureau de votre des prud'hommes
   VerifTablette ('PSA_PRUDHVOTE', 'PGLIEUVOTEPRUD', LibSal,
                  'Le bureau de vote des prud''hommes', TSalariesFille);
   end;

Result:= True;
end;

procedure VerifTablette(Champ,NomTablette,LibCleErr,LibChampErr : String;T : TOB);
var
  Lib : String;
begin
  if (T.getValue(Champ) <> '') then
  begin
    if (Champ = 'PSA_CODEEMPLOI') then   // cas particulier o� l'on r�cup�re l'abr�g�
      Lib := RechDom(NomTablette,T.getValue(Champ),True)
    else
      Lib := RechDom(NomTablette,T.getValue(Champ),False);
    if (Lib = '') or (Lib = 'Error') then
       begin
{Voir comment garder la trace
       MRecap.Lines.Add (TraduireMemoire('AVERTISSEMENT : ' + LibCleErr + ' : ' + LibChampErr + ' n''existe pas dans le param�trage.'));
}
       end;
  end;
end;

function TestHoraire(HoraireInf, HoraireSup: Double): Boolean;
begin
  Result := False;
  if HoraireSup <> 0 then
  begin
    if HoraireInf > HoraireSup then Result := True;
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : FC
Cr�� le ...... : 06/04/2007
Modifi� le ... :
Description .. : Controle des valeurs du fichier HISTOCUMSAL
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
function ControleValHistoCumul (THistoCumulFille: TOB;
                                                NomBase : string): boolean;
var
St, StHisto : string;
begin
// A priori renvoie toujours Vrai car on ne fait que signaler les anomalies, rien n'est bloquant
Result:= False;

StHisto:= THistoCumulFille.getValue ('PHC_ETABLISSEMENT')+'/'+
          THistoCumulFille.getValue ('PHC_SALARIE')+'/"'+
          DateToStr (THistoCumulFille.getValue ('PHC_DATEDEBUT'))+'"/"'+
          DateToStr (THistoCumulFille.getValue ('PHC_DATEFIN'))+'"/'+
          THistoCumulFille.getValue ('PHC_REPRISE')+'/'+
          THistoCumulFille.getValue ('PHC_CUMULPAIE');

// Si l'enregistrement existe d�j�, erreur
St:= 'SELECT PHC_ETABLISSEMENT'+
     ' FROM '+Nombase+'.DBO.HISTOCUMSAL WHERE'+
     ' PHC_ETABLISSEMENT="'+THistoCumulFille.getValue ('PHC_ETABLISSEMENT')+'" AND'+
     ' PHC_SALARIE="'+THistoCumulFille.getValue ('PHC_SALARIE')+'" AND'+
     ' PHC_DATEDEBUT="'+UsDateTime (THistoCumulFille.getValue ('PHC_DATEDEBUT'))+'" AND'+
     ' PHC_DATEFIN="'+UsDateTime (THistoCumulFille.getValue ('PHC_DATEFIN'))+'" AND'+
     ' PHC_REPRISE="'+THistoCumulFille.getValue ('PHC_REPRISE')+'" AND'+
     ' PHC_CUMULPAIE="'+THistoCumulFille.getValue ('PHC_CUMULPAIE')+'"';
if (ExisteSQL (St)) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('ERREUR : L''historique cumul '+StHisto+
                                      ' existe d�j�'));
}
   Erreur:= True;
   end;

ChampOblig:= '';
NbChampOblig:= 0;
// Champs obligatoires : PHC_ETABLISSEMENT,PHC_SALARIE,PHC_DATEDEBUT,PHC_DATEFIN,PHC_REPRISE,PHC_CUMULPAIE
if (THistoCumulFille.getValue('PHC_ETABLISSEMENT')='') then
   MajChampOblig ('l''�tablissement');
if (THistoCumulFille.getValue ('PHC_SALARIE')='') then
   MajChampOblig (' le salari�');
if (THistoCumulFille.getValue ('PHC_DATEDEBUT')=iDate1900) then
   MajChampOblig (' la date de d�but');
if (THistoCumulFille.getValue ('PHC_DATEFIN')=iDate1900) then
   MajChampOblig (' la date de fin');
if (THistoCumulFille.getValue ('PHC_CUMULPAIE')='') then
   MajChampOblig (' le cumul');

if (NbChampOblig>1) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('ERREUR : Historique cumul '+StHisto+' :'+
                     ' Les champs suivants sont obligatoires : '+ChampOblig));
}
   Erreur:= True;
   end
else
if (NbChampOblig=1) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('ERREUR : Historique cumul '+StHisto+' :'+
                     ' Le champ suivant est obligatoire : '+ChampOblig));
}
   Erreur:= True;
   end;

// V�rifier l'existence de l'�tablissement
if (THistoCumulFille.getValue ('PHC_ETABLISSEMENT')<>'') then
   begin
   St:= 'SELECT ET_ETABLISSEMENT'+
        ' FROM '+Nombase+'.DBO.ETABLISS WHERE'+
        ' ET_ETABLISSEMENT="'+THistoCumulFille.getValue ('PHC_ETABLISSEMENT')+'"';
   if (ExisteSQL (St)=False) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Historique cumul '+StHisto+
                                         ' : L''�tablissement n''existe pas.'));
}
      Erreur:= True;
      end;
   end;

// V�rifier l'existence du salari�
if (THistoCumulFille.getValue ('PHC_SALARIE')<>'') then
   begin
   St:= 'SELECT PSA_SALARIE'+
        ' FROM '+Nombase+'.DBO.SALARIES WHERE'+
        ' PSA_SALARIE="'+THistoCumulFille.getValue ('PHC_SALARIE')+'"';
   if (ExisteSQL (St)=False) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Historique cumul '+StHisto+
                                         ' : Le salari� n''existe pas.'));
}
      Erreur:= True;
      end;
   end;

// V�rifier l'existence du cumul de paie
if (THistoCumulFille.getValue ('PHC_CUMULPAIE')<>'') then
   begin
   St:= 'SELECT PCL_CUMULPAIE'+
        ' FROM CUMULPAIE WHERE'+
        ' PCL_CUMULPAIE="'+THistoCumulFille.getValue ('PHC_CUMULPAIE')+'"';
   if (ExisteSQL (St)=False) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Historique cumul '+StHisto+
                                         ' : Le cumul de paie n''existe pas.'));
}
      Erreur:= True;
      end;
   end;

Result:= True;
end;

// Alimentation des valeurs par d�faut non fournies
procedure EnregAbsenceSalarieDefaut (TAbsenceFille: TOB;
                                                     NomBase : string);
var
  DebutDJ,FinDJ : String;
begin
  if not TAbsenceFille.IsFieldModified('PCN_TYPECONGE') then TAbsenceFille.PutValue('PCN_TYPECONGE', 'PRI');
  if not TAbsenceFille.IsFieldModified('PCN_TYPEMVT') then
  begin
    if (TAbsenceFille.GetValue('PCN_TYPEMVT') = 'PRI') then
      TAbsenceFille.PutValue('PCN_TYPEMVT', 'CPA')
    else
      TAbsenceFille.PutValue('PCN_TYPEMVT', 'ABS');
  end;
  if not TAbsenceFille.IsFieldModified('PCN_MVTPRIS') then TAbsenceFille.PutValue('PCN_MVTPRIS', 'PRI');
  if not TAbsenceFille.IsFieldModified('PCN_PERIODEPY') then TAbsenceFille.PutValue('PCN_PERIODEPY', -1);

  if not TAbsenceFille.IsFieldModified('PCN_PERIODECP') then
  begin
    if (TAbsenceFille.GetValue('PCN_TYPECONGE') = 'PRI') then
      TAbsenceFille.PutValue('PCN_PERIODECP', 0)
    else
      TAbsenceFille.PutValue('PCN_PERIODECP', -1);
  end;
  
  if not TAbsenceFille.IsFieldModified('PCN_MVTORIGINE') then TAbsenceFille.PutValue('PCN_MVTORIGINE', 'SAL');
  if not TAbsenceFille.IsFieldModified('PCN_SENSABS') then TAbsenceFille.PutValue('PCN_SENSABS', '-');
  if not TAbsenceFille.IsFieldModified('PCN_DEBUTDJ') then TAbsenceFille.PutValue('PCN_DEBUTDJ', 'MAT');
  if not TAbsenceFille.IsFieldModified('PCN_FINDJ') then TAbsenceFille.PutValue('PCN_FINDJ', 'PAM');

  if not TAbsenceFille.IsFieldModified('PCN_LIBELLE') and (TAbsenceFille.GetValue('PCN_DATEDEBUTABS') <> iDate1900) and (TAbsenceFille.GetValue('PCN_DATEFINABS') <> iDate1900) then
  begin
    if (TAbsenceFille.GetValue('PCN_DEBUTDJ') <> '') then
      DebutDJ := TAbsenceFille.GetValue('PCN_DEBUTDJ')
    else
      DebutDJ := 'am';
    if (TAbsenceFille.GetValue('PCN_FINDJ') <> '') then
      FinDJ := TAbsenceFille.GetValue('PCN_FINDJ')
    else
      FinDJ := 'pm';
    TAbsenceFille.PutValue('PCN_LIBELLE', 'CP ' + DateToText(TAbsenceFille.GetValue('PCN_DATEDEBUTABS')) + ' ' + DebutDJ + ' au ' + DateToText(TAbsenceFille.GetValue('PCN_DATEFINABS')) + ' ' + FinDJ);
  end;

  if not TAbsenceFille.IsFieldModified('PCN_DATEVALIDITE') then TAbsenceFille.PutValue('PCN_DATEVALIDITE', TAbsenceFille.GetValue('PCN_DATEDEBUTABS'));
  if not TAbsenceFille.IsFieldModified('PCN_CODETAPE') then TAbsenceFille.PutValue('PCN_CODETAPE', '...');
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : FC
Cr�� le ...... : 06/04/2007
Modifi� le ... :
Description .. : Controle des valeurs du fichier ABSENCESALARIE
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
function ControleValAbsenceSalarie (TAbsenceFille: TOB;
                                                    NomBase : string): boolean;
var
Q : TQuery;
Etablissement, SQL, StTypeConge, StTypeMvt : String;
CPEtab, CPSal : Boolean;
DateSortie,DateEntree : TDateTime;
T_MotifAbs : TOB;
YYD, MMD, JJ, YYF, MMF: WORD;
nbj : double;
begin
// A priori renvoie toujours Vrai car on ne fait que signaler les anomalies, rien n'est bloquant
Result:= False;

nbj:= 0;

StTypeConge:= TAbsenceFille.getValue ('PCN_SALARIE')+'/'+
              TAbsenceFille.getValue ('PCN_TYPECONGE')+'/'+
              IntToStr (TAbsenceFille.getValue ('PCN_ORDRE'));
StTypeMvt:= TAbsenceFille.getValue ('PCN_SALARIE')+'/'+
            TAbsenceFille.getValue ('PCN_TYPEMVT')+'/'+
            IntToStr (TAbsenceFille.getValue ('PCN_ORDRE'));

// Si l'enregistrement existe d�j�, erreur
SQL:= 'SELECT PCN_TYPEMVT'+
      ' FROM '+Nombase+'.DBO.ABSENCESALARIE WHERE'+
      ' PCN_TYPEMVT="'+TAbsenceFille.getValue ('PCN_TYPEMVT')+'" AND'+
      ' PCN_SALARIE="'+TAbsenceFille.getValue ('PCN_SALARIE')+'" AND'+
      ' PCN_ORDRE='+IntToStr (TAbsenceFille.getValue ('PCN_ORDRE'))+' AND'+
      ' PCN_RESSOURCE="'+TAbsenceFille.getValue ('PCN_RESSOURCE')+'"';
if (ExisteSQL (SQL)) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('ERREUR : L''absence salari� '+
                                      StTypeConge+' existe d�j�'));
}
   Erreur:= True;
   end;

if (TAbsenceFille.getValue ('PCN_TYPEMVT')='CPA') and
   (TAbsenceFille.getValue ('PCN_TYPECONGE')<>'PRI') then
   T_MotifAbs:= nil
else
   begin
   T_MotifAbs:= nil;
   if (TAbsenceFille.getValue ('PCN_TYPECONGE')<>'') then
      T_MotifAbs:= Tob_MotifAbs.FindFirst (['PMA_MOTIFABSENCE'],
                                           [TAbsenceFille.getValue ('PCN_TYPECONGE')],
                                           False);
   end;

if Assigned(T_MotifAbs) then
   begin
   if ControleGestionMaximum (TAbsenceFille.getValue ('PCN_SALARIE'),
                              TAbsenceFille.getValue ('PCN_TYPECONGE'), T_MotifAbs,
                              TAbsenceFille.getValue ('PCN_DATEDEBUTABS'),
                              Valeur (TAbsenceFille.getValue ('PCN_JOURS')),
                              Valeur (TAbsenceFille.getValue ('PCN_HEURES'))) then
      begin
      if (T_MotifAbs.GetValue ('PMA_JOURHEURE')='JOU') then
         begin
{Voir comment garder la trace
         MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                            StTypeMvt+' : Le nombre de jours'+
                                            ' maximum octroy�s pour ce motif'+
                                            ' est d�pass� : '+
                                            FloatToStr (T_MotifAbs.GetValue ('PMA_JRSMAXI'))));
}
         Erreur:= True;
         end
      else
      if (T_MotifAbs.GetValue ('PMA_JOURHEURE')='HEU') then
         begin
{Voir comment garder la trace
         MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                            StTypeMvt+' : Le nombre d''heures'+
                                            ' maximum octroy�s pour ce motif'+
                                            ' est d�pass� : '+
                                            FloatToStr (T_MotifAbs.GetValue ('PMA_JRSMAXI'))));
}
         Erreur:= True;
         end;
      end;
   end;

// date validit� post�rieure � celle du dernier solde tout compte
if (TAbsenceFille.getValue ('PCN_DATEVALIDITE')<>iDate1900) and
   (TAbsenceFille.getValue ('PCN_TYPEMVT')='CPA') and
   ((TAbsenceFille.getValue ('PCN_TYPECONGE')='AJP') or
   (TAbsenceFille.getValue ('PCN_TYPECONGE')='AJU') or
   (TAbsenceFille.getValue ('PCN_TYPECONGE')='REP') or
   (TAbsenceFille.getValue ('PCN_TYPECONGE')='CPA')) then
   begin
   SQL:= 'SELECT MAX(PCN_DATEVALIDITE) AS DATEVAL'+
         ' FROM '+Nombase+'.DBO.ABSENCESALARIE WHERE'+
         ' PCN_SALARIE="'+TAbsenceFille.getValue ('PCN_SALARIE')+'" AND'+
         ' PCN_TYPEMVT="CPA" AND'+
         ' PCN_TYPECONGE="SLD" AND'+
         ' PCN_GENERECLOTURE="-" ';
   Q:= opensql (SQL, True);
   if not Q.eof then   
      begin
      if TAbsenceFille.getValue ('PCN_DATEVALIDITE')<=Q.FindField ('DATEVAL').AsDateTime then
         begin
{Voir comment garder la trace
         MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                            StTypeMvt+' : La date de validit�'+
                                            ' ne peut �tre ant�rieure � celle'+
                                            ' du dernier solde de tout compte'+
                                            ' : '+DateToStr (Q.FindField ('DATEVAL').AsDateTime)));
}
         Erreur:= True;
         end;
      end;
   Ferme(Q);
   end;

// Absence � cheval sur plusieurs mois
if (TAbsenceFille.getValue ('PCN_DATEDEBUTABS')<>iDate1900) and
   (TAbsenceFille.getValue ('PCN_DATEFINABS')<>iDate1900) and
   (not GetParamSocSecur ('SO_PGABSENCECHEVAL', False)) then
   begin
   if (TAbsenceFille.getValue ('PCN_TYPEMVT')='ABS') or
      (TAbsenceFille.getValue ('PCN_TYPECONGE')='PRI') Then
      begin
      DecodeDate (TAbsenceFille.getValue ('PCN_DATEDEBUTABS'), YYD, MMD, JJ);
      DecodeDate (TAbsenceFille.getValue ('PCN_DATEFINABS'), YYF, MMF, JJ);
      if (MMD <> MMF) or (YYD <> YYF) then
         begin
{Voir comment garder la trace
         MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                            StTypeMvt+' : Vous ne pouvez pas'+
                                            ' saisir une absence � cheval sur'+
                                            ' plusieurs mois.'));
}
         Erreur:= True;
         end;
      end;
   end;

// Nombre de jours ou de mois ou la base obligatoires
if (TAbsenceFille.getValue ('PCN_TYPECONGE')='AJU') AND
   (TAbsenceFille.getValue('PCN_TYPEMVT')='CPA') then
   begin
   if (Valeur (TAbsenceFille.getValue ('PCN_JOURS'))=0) and
      (TAbsenceFille.getValue ('PCN_BASE')=0) and
      (TAbsenceFille.getValue ('PCN_NBREMOIS')=0) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                         StTypeConge+' : Vous devez renseigner'+
                                         ' une valeur pour le nombre de jours,'+
                                         ' de mois ou la base.'));
}
      Erreur:= True;
      end;
   end;

// V�rifier l'existence du salari�
if (TAbsenceFille.getValue ('PCN_SALARIE')<>'') then
   begin
   SQL:= 'SELECT PSA_SALARIE'+
         ' FROM '+Nombase+'.DBO.SALARIES WHERE'+
         ' PSA_SALARIE="'+TAbsenceFille.getValue ('PCN_SALARIE')+'"';
   if (ExisteSQL (SQL)=False) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                         StTypeConge+' : Le salari� n''existe'+
                                         ' pas.'));
}
      Erreur:= True;
      end;
   end;

// Param�tre CONGESPAYES
Q:= opensql ('SELECT PSA_CONGESPAYES, ETB_CONGESPAYES, ETB_ETABLISSEMENT,'+
             ' PSA_DATESORTIE, PSA_DATEENTREE'+
             ' FROM '+Nombase+'.DBO.SALARIES'+
             ' LEFT JOIN ETABCOMPL ON'+
             ' PSA_ETABLISSEMENT=ETB_ETABLISSEMENT WHERE'+
             ' PSA_SALARIE="'+TAbsenceFille.getValue ('PCN_SALARIE')+'" ', TRUE);
if not Q.eof then
   begin
   CPEtab:= (Q.findfield ('ETB_CONGESPAYES').Asstring = 'X');
   CPSal:= (Q.findfield ('PSA_CONGESPAYES').Asstring = 'X');
   Etablissement:= Q.findfield ('ETB_ETABLISSEMENT').Asstring;
   DateSortie:= Q.findfield ('PSA_DATESORTIE').AsDateTime;
   DateEntree:= Q.findfield ('PSA_DATEENTREE').AsDateTime;
   end
else
   begin
   CPEtab:= False;
   CPSal:= False;
   Etablissement:= '';
   DateSortie:= iDate1900;
   DateEntree:= iDate1900;
   end;
Ferme(Q);

if TAbsenceFille.getValue ('PCN_TYPEMVT')='CPA' then
   begin
   if (not GetParamSocSecur ('SO_PGCONGES', False)) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                         StTypeConge+' : Saisie impossible :'+
                                         ' Vous ne g�rez pas les cong�s pay�s'+
                                         ' au niveau dossier.'));
}
      Erreur:= True;
      end
   else
   if (CPEtab=False) and (Etablissement<>'') then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                         StTypeConge+' : Saisie impossible :'+
                                         ' Vous ne g�rez pas les cong�s pay�s'+
                                         ' au niveau �tablissement.'));
}
      Erreur:= True;
      end
   else
   if (CPSal=False) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                         StTypeConge+' : Saisie impossible :'+
                                         ' Vous ne g�rez pas les cong�s pay�s'+
                                         ' au niveau salari�.'));
}
      Erreur:= True;
      end;
   end;

ChampOblig:= '';
NbChampOblig:= 0;
// Champs obligatoires : PCN_TYPEMVT,PCN_SALARIE,PCN_ORDRE, PCN_TYPECONGE
if (TAbsenceFille.getValue ('PCN_TYPEMVT')='') then
   MajChampOblig ('le type de mouvement');
if (TAbsenceFille.getValue ('PCN_SALARIE')='') then
   MajChampOblig ('le matricule salari�');
if (TAbsenceFille.getValue ('PCN_ORDRE')=0) then
   MajChampOblig ('le num�ro d''ordre');
if (TAbsenceFille.getValue ('PCN_TYPECONGE')='') then
   MajChampOblig ('le type d''absence');
if (TAbsenceFille.getValue ('PCN_DATEDEBUTABS')=iDate1900) then
   MajChampOblig ('la date de d�but d''absence');
if (TAbsenceFille.getValue ('PCN_DATEFINABS')=iDate1900) then
   MajChampOblig ('la date de fin d''absence');
if (TAbsenceFille.getValue ('PCN_DATEVALIDITE')=iDate1900) then
   MajChampOblig ('la date de validit�');

if (NbChampOblig>1) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+StTypeConge+
                                      ' : Les champs suivants sont'+
                                      ' obligatoires : '+ChampOblig));
}
   Erreur:= True;
   end
else
if (NbChampOblig = 1) then
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+StTypeConge+
                                      ' : Le champ suivant est obligatoire : '+
                                      ChampOblig));
}
   Erreur:= True;
   end;

// Jours d'absence
if isnumeric (TAbsenceFille.getValue ('PCN_JOURS')) then
   begin
   if (Valeur (TAbsenceFille.getValue ('PCN_JOURS'))<=0) and
      (TAbsenceFille.getValue ('PCN_TYPECONGE')<>'AJU') then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                         StTypeConge+' : Le nombre de jours'+
                                         ' doit �tre positif'));
}
      Erreur:= True;
      end;
   end
else
   begin
{Voir comment garder la trace
   MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+StTypeConge+
                                      ' : Le nombre de jours est invalide.'));
}
   Erreur:= True;
   end;

// Controle des dates d'absence par rapport aux dates d'entr�e / Sortie du salari�
if ((TAbsenceFille.getValue ('PCN_TYPECONGE')='PRI') and
   (TAbsenceFille.getValue ('PCN_TYPEMVT')='CPA')) or
   (TAbsenceFille.getValue ('PCN_TYPEMVT')='ABS') then
   begin
   if ((TAbsenceFille.getValue ('PCN_DATEFINABS')<>iDate1900) and
      (DateSortie>iDate1900) and
      (DateSortie<TAbsenceFille.getValue ('PCN_DATEFINABS'))) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                         StTypeConge+' : La date de fin'+
                                         ' d''absence doit �tre ant�rieure �'+
                                         ' la date de sortie du salari� '+
                                         DateToStr (DateSortie)));
}
      Erreur:= True;
      end;

   if ((TAbsenceFille.getValue ('PCN_DATEDEBUTABS')<>iDate1900) and
      (DateEntree<>iDate1900) and
      (DateEntree>TAbsenceFille.getValue ('PCN_DATEDEBUTABS'))) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                         StTypeConge+' : La date de d�but'+
                                         ' d''absence doit �tre post�rieure �'+
                                         ' la date d''entr�e du salari� '+
                                         DateToStr (DateEntree)));
}
      Erreur:= True;
      end;
   end;

// R�cup�rer la Date de Cl�ture CP ann�e en cours
Q:= opensql ('SELECT ETB_DATECLOTURECPN'+
             ' FROM '+Nombase+'.DBO.ETABCOMPL WHERE'+
             ' ETB_ETABLISSEMENT="'+TAbsenceFille.getValue ('PCN_ETABLISSEMENT')+'" ',
             TRUE);
if not Q.eof then
   DTClot:= Q.findfield ('ETB_DATECLOTURECPN').AsDateTime
else
   DTClot:= iDate1900;
Ferme(Q);

if (TAbsenceFille.getValue ('PCN_TYPECONGE')='CPA') AND
   (TAbsenceFille.getValue ('PCN_TYPEMVT')='CPA') then
   begin
// Vous ne pouvez saisir deux mouvements de type reprise pris sur une m�me p�riode
   Q:= RechercheReprise (TAbsenceFille.getValue ('PCN_DATEVALIDITE'),
                         TAbsenceFille.getValue ('PCN_SALARIE'), 'CPA', 'AC2',
                         'REP');
   if not Q.eof then
      begin
      Q.First;
      while not Q.eof do
            begin
            if (Q.FindField ('PCN_TYPECONGE').AsString='CPA') then
               begin
               if Q.FindField ('PCN_ORDRE').AsInteger<>TAbsenceFille.getValue ('PCN_ORDRE') then
                  begin
{Voir comment garder la trace
                  MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                                     StTypeConge+' : Vous ne pouvez'+
                                                     ' pas saisir deux mouvements'+
                                                     ' de type reprise pris sur'+
                                                     ' une m�me p�riode.'));
}
                  Erreur:= True;
                  end;
               end;
            Q.next;
            end;
      end;

// Le nombre de jours pris repris ne peut �tre sup�rieur au nombre de jours acquis repris
   if not Q.eof then
      begin
      Q.First;
      while not Q.eof do
            begin
            if (Q.FindField ('PCN_TYPECONGE').AsString='REP') then
               nbj:= Q.findfield ('PCN_JOURS').AsFloat;
            Q.next;
            end;
      end;
   if nbj < Valeur (TAbsenceFille.getValue ('PCN_JOURS')) then
      begin
{Voir comment garder la trace
      MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                         StTypeConge+' : Le nombre de jours'+
                                         ' pris repris ne peut pas �tre'+
                                         ' sup�rieur au nombre de jours acquis'+
                                         ' repris : '+ FloatToStr (nbj)));
}
      Erreur:= True;
      end;
   Ferme(Q);
   end;

// Vous ne pouvez saisir deux mouvements de type reprise acquis sur une m�me p�riode
if (TAbsenceFille.getValue ('PCN_TYPECONGE')='REP') AND
   (TAbsenceFille.getValue ('PCN_TYPEMVT')='CPA') then
   begin
   Q:= RechercheReprise (TAbsenceFille.getValue ('PCN_DATEVALIDITE'),
                         TAbsenceFille.getValue ('PCN_SALARIE'), 'REP', NomBase,
                         TAbsenceFille.getValue ('PCN_TYPEIMPUTE'));
   if not Q.eof then
      begin
      if TAbsenceFille.getValue ('PCN_ORDRE')<>Q.FindField ('PCN_ORDRE').AsInteger then
         begin
{Voir comment garder la trace
         MRecap.Lines.Add (TraduireMemoire ('ERREUR : Absence salari� '+
                                            StTypeConge+' : Vous ne pouvez pas'+
                                            ' saisir deux mouvements de type'+
                                            ' reprise acquis sur une m�me'+
                                            ' p�riode.'));
}
         Erreur:= True;
         end;
      end;
   Ferme(Q);
   end;

Result:= True;
end;

function RechercheReprise (Validite : Tdatetime; Salarie,
                                            TypeConge, TypeImpute,
                                            NomBase : string;
                                            TypeConge2 : string='') : Tquery;
var
Q : TQuery;
DtFin, DTDeb : TDateTime;
st, WhereType : string;
begin
if (TypeConge2='') then
   WhereType:= 'PCN_TYPECONGE="'+TypeConge+'"'
else
   WhereType:= '(PCN_TYPECONGE="'+TypeConge+'" OR'+
               ' PCN_TYPECONGE="'+TypeConge2+'")';
RechercheExerciceCp (Validite, DtDeb, DtFin);
st:= 'SELECT PCN_ORDRE,PCN_JOURS,PCN_APAYES'+
     ' FROM '+Nombase+'.DBO.ABSENCESALARIE WHERE'+
     ' PCN_SALARIE="'+Salarie+'" AND'+
     ' PCN_TYPEMVT="CPA" AND '+WhereType+' AND'+
     ' PCN_DATEVALIDITE>="'+USDateTime(DtDeb)+'" AND'+
     ' PCN_DATEVALIDITE<="'+USDateTime(DtFin)+'" AND'+
     ' PCN_TYPEIMPUTE="'+TypeImpute+'"';
Q:= OpenSQL (st, false);
result:= Q;
end;

procedure RechercheExerciceCp(Validite: tdatetime; var DTdeb, DtFin: tdatetime);
var
  aa, mm, jj: word;
  i: integer;
begin
  DtDeb := 0;
  DTfin := 0;
  if Dtclot = 0 then exit;
  decodedate(Dtclot, aa, mm, jj);
  Dtdeb := PGEncodeDateBissextile(aa - 1, mm, jj) + 1;
  DTfin := DTclot;
  i := 0;
  while i < 10 do
  begin
    if ((Validite >= DTDeb) and (Validite <= DtFin)) then exit;
    DtFin := DtDeb - 1;
    decodedate(DtFin, aa, mm, jj);
    Dtdeb := PGEncodeDateBissextile(aa - 1, mm, jj) + 1;
    i := i + 1;
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 27/03/2007
Modifi� le ... :   /  /
Description .. : Proc�dure d'extraction des tables connues
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
function ExtractConnu (Table, NomBase : string; Enregistre : boolean) : boolean;
var
NomFic : string;
TFille : TOB;
begin
TFille:= TListeFile.FindFirst (['NOMTABLE'], [Table], True);
if (TFille <> nil) then
   begin
   NomFic:= TFille.GetValue ('ZF_NAME');
   NomTable:= TFille.GetValue ('NOMTABLE');
   NomFic:= Chemin+'\'+NomFic;
   result:= Extraction (NomFic, NomTable, NomBase, TFille, Enregistre);
   end
else
   result:= False;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 27/03/2007
Modifi� le ... :   /  /
Description .. : Proc�dure de lecture du nom de la table
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
function RecupereNomTable (NomFic : string) : string;
begin
result:= ExtractFileName (NomFic);
result:= Copy (result, 11, Length (result)-14);
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 27/03/2007
Modifi� le ... :   /  /
Description .. : Proc�dure d'extraction
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
function Extraction (NomFic, NomTable, NomBase : string;
                                     TFille : TOB; Enregistre : boolean) : boolean;
begin
TExtract:= TOB.Create (NomTable, nil, -1);
TOBLoadFromFile (NomFic, nil, TExtract);
AppliqueParamDefaut (NomTable, TExtract);
FreeAndNil (TFille);
result:= ControleExtract (NomTable, NomBase);
//TobDebug (TExtract);
if (result=True) then
   TraitementTable (NomTable, NomBase);

DeleteFile (NomFic);   

FreeAndNil (TExtract);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 11/06/2007
Modifi� le ... :   /  /
Description .. : Proc�dure d'application d'un param�tre du mod�le choisi
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
procedure AppliqueLeParam (TExtractFille, TModele : TOB; ChampsModele : string);
var
TModeleD : TOB;
ChampModele2 : string;
begin

if (TExtractFille.FieldExists (ChampsModele)=False) then
   begin
   if (ChampsModele='ET_ACTIVITE') then
      ChampModele2:= 'CBACTIVITE'
   else
      ChampModele2:= ChampsModele;
   TModeleD:= TModele.FindFirst (['PDM_NOMCHAMP'], [ChampModele2], True);
   if (TModeleD<>nil) then
      TExtractFille.AddChampSupValeur (ChampsModele,
                                       TModeleD.GetValue ('PDM_PGVALEUR'), True);
   end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 29/05/2007
Modifi� le ... :   /  /
Description .. : Proc�dure d'application des param�tres du mod�le choisi
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
procedure AppliqueParamDefaut (NomTable : string; TExtract : TOB);
var
TExtractFille : TOB;
ChampsModeleSO : Array[0..20] of string;
ChampsModeleET : Array[0..1] of string;
ChampsModeleETB : Array[0..61] of string;
ChampsModelePSA : Array[0..8] of string;
i : integer;
begin
ChampsModeleSO[0]:= 'SO_PGRACINEAUXI';
ChampsModeleSO[1]:= 'SO_PGNUMAUXI';
ChampsModeleSO[2]:= 'SO_PGTYPENUMSAL';
ChampsModeleSO[3]:= 'SO_PGINCSALARIE';
ChampsModeleSO[4]:= 'SO_PGTIERSAUXIAUTO';
ChampsModeleSO[5]:= 'SO_PGDECALAGE';
ChampsModeleSO[6]:= 'SO_PGDECALAGEPETIT';
ChampsModeleSO[7]:= 'SO_PGANALYTIQUE';
ChampsModeleSO[8]:= 'SO_PGCONGES';
ChampsModeleSO[9]:= 'SO_PGMODIFLIGNEIMP';
ChampsModeleSO[10]:= 'SO_PGABSENCE';
ChampsModeleSO[11]:= 'SO_PGABSENCECHEVAL';
ChampsModeleSO[12]:= 'SO_PGCHR6SEMAINE';
ChampsModeleSO[13]:= 'SO_PGMSA';
ChampsModeleSO[14]:= 'SO_PGINTERMITTENTS';
ChampsModeleSO[15]:= 'SO_PGBTP';
ChampsModeleSO[16]:= 'SO_PGRESPONSABLES';
ChampsModeleSO[17]:= 'SO_PGCOEFFEVOSAL';
ChampsModeleSO[18]:= 'SO_PGSAISIEARRET';
ChampsModeleSO[19]:= 'SO_PGTICKETRESTAU';
ChampsModeleSO[20]:= 'SO_PGPCS2003';

ChampsModeleET[0]:= 'ET_ACTIVITE';
ChampsModeleET[1]:= 'ET_JURIDIQUE';

ChampsModeleETB[0]:= 'ETB_HORAIREETABL';
ChampsModeleETB[1]:= 'ETB_SMIC';
ChampsModeleETB[2]:= 'ETB_PCTFRAISPROF';
ChampsModeleETB[3]:= 'ETB_TAUXVERSTRANS';
ChampsModeleETB[4]:= 'ETB_NBJOUTRAV';
ChampsModeleETB[5]:= 'ETB_NBREACQUISCP';
ChampsModeleETB[6]:= 'ETB_NBACQUISCP';
ChampsModeleETB[7]:= 'ETB_NBRECPSUPP';
ChampsModeleETB[8]:= 'ETB_VALANCCP';
ChampsModeleETB[9]:= 'ETB_DATEACQCPANC';
ChampsModeleETB[10]:= 'ETB_VALODXMN';
ChampsModeleETB[11]:= 'ETB_TYPSMIC';
ChampsModeleETB[12]:= 'ETB_STANDCALEND';
ChampsModeleETB[13]:= 'ETB_JOURHEURE';
ChampsModeleETB[14]:= 'ETB_MEDTRAVGU';
ChampsModeleETB[15]:= 'ETB_CODEDDTEFPGU';
ChampsModeleETB[16]:= 'ETB_PROFILREM';
ChampsModeleETB[17]:= 'ETB_PERIODBUL';
ChampsModeleETB[18]:= 'ETB_REDREPAS';
ChampsModeleETB[19]:= 'ETB_REDRTT1';
ChampsModeleETB[20]:= 'ETB_PROFILAFP';
ChampsModeleETB[21]:= 'ETB_PROFILRET';
ChampsModeleETB[22]:= 'ETB_PROFILMUT';
ChampsModeleETB[23]:= 'ETB_PROFILANCIEN';
ChampsModeleETB[24]:= 'ETB_PROFIL';
ChampsModeleETB[25]:= 'ETB_PROFILRBS';
ChampsModeleETB[26]:= 'ETB_REDRTT2';
ChampsModeleETB[27]:= 'ETB_PROFILPRE';
ChampsModeleETB[28]:= 'ETB_PROFILTSS';
ChampsModeleETB[29]:= 'ETB_PROFILAPP';
ChampsModeleETB[30]:= 'ETB_PROFILTRANS';
ChampsModeleETB[31]:= 'ETB_PROFILCGE';
ChampsModeleETB[32]:= 'ETB_1ERREPOSH';
ChampsModeleETB[33]:= 'ETB_EDITBULCP';
ChampsModeleETB[34]:= 'ETB_RELIQUAT';
ChampsModeleETB[35]:= 'ETB_2EMEREPOSH';
ChampsModeleETB[36]:= 'ETB_BASANCCP';
ChampsModeleETB[37]:= 'ETB_TYPDATANC';
ChampsModeleETB[38]:= 'ETB_VALORINDEMCP';
ChampsModeleETB[39]:= 'ETB_MVALOMS';
ChampsModeleETB[40]:= 'ETB_PAIEVALOMS';
ChampsModeleETB[41]:= 'ETB_MOISPAIEMENT';
ChampsModeleETB[42]:= 'ETB_PGMODEREGLE';
ChampsModeleETB[43]:= 'ETB_BCMODEREGLE';
ChampsModeleETB[44]:= 'ETB_BCMOISPAIEMENT';
ChampsModeleETB[45]:= 'ETB_PAIACOMPTE';
ChampsModeleETB[46]:= 'ETB_PAIFRAIS';
ChampsModeleETB[47]:= 'ETB_CODESECTION';
ChampsModeleETB[48]:= 'ETB_PRUDHCOLL';
ChampsModeleETB[49]:= 'ETB_PRUDHSECT';
ChampsModeleETB[50]:= 'ETB_PRUDHVOTE';
ChampsModeleETB[51]:= 'ETB_PRUDH';
ChampsModeleETB[52]:= 'ETB_DADSSECTION';
ChampsModeleETB[53]:= 'ETB_TYPDADSSECT';
ChampsModeleETB[54]:= 'ETB_SUBROGATION';
ChampsModeleETB[55]:= 'ETB_PERIODCT';
ChampsModeleETB[56]:= 'ETB_TRANS9SAL';
ChampsModeleETB[57]:= 'ETB_CONGESPAYES';
ChampsModeleETB[58]:= 'ETB_JOURPAIEMENT';
ChampsModeleETB[59]:= 'ETB_BCJOURPAIEMENT';
ChampsModeleETB[60]:= 'ETB_JEDTDU';
ChampsModeleETB[61]:= 'ETB_JEDTAU';

ChampsModelePSA[0]:= 'PSA_UNITEPRISEFF';
ChampsModelePSA[1]:= 'PSA_SALAIRETHEO';
ChampsModelePSA[2]:= 'PSA_ETATBULLETIN';
ChampsModelePSA[3]:= 'PSA_PROFILTPS';
ChampsModelePSA[4]:= 'PSA_REGIMESS';
ChampsModelePSA[5]:= 'PSA_DADSCAT';
ChampsModelePSA[6]:= 'PSA_DADSPROF';
ChampsModelePSA[7]:= 'PSA_UNITETRAVAIL';
ChampsModelePSA[8]:= 'PSA_PRISEFFECTIF';

TExtractFille:= TExtract.FindFirst([''], [''], TRUE);
//TobDebug (TModele);
if (NomTable='SOCIETE') then
   begin
   for i:= 0 to 20 do
       AppliqueLeParam (TExtractFille, TModele, ChampsModeleSO[i]);
   end
else
if (NomTable='ETABLISS') then
   begin
   for i:= 0 to 1 do
       AppliqueLeParam (TExtractFille, TModele, ChampsModeleET[i]);
   end
else
if (NomTable='ETABCOMPL') then
   begin
   for i:= 0 to 61 do
       AppliqueLeParam (TExtractFille, TModele, ChampsModeleETB[i]);
   end
else
if (NomTable='SALARIES') then
   begin
   for i:= 0 to 8 do
       AppliqueLeParam (TExtractFille, TModele, ChampsModelePSA[i]);
   end;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 26/03/2007
Modifi� le ... :   /  /
Description .. : Proc�dure de contr�le de coh�rence de la TOB
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
function ControleExtract (NomTable, NomBase : string) : boolean;
var
TFille, TParamSoc, TParamSocFille : TOB;
i : integer;
StSQL : string;
begin
result:= True;
if (NomTable='SOCIETE') then
   begin
   TFille:= TExtract.FindFirst ([''], [''], True);
   TFille.PutValue ('SO_VERSIONBASE',
                    RecupChamp ('SOCIETE', 'SO_VERSIONBASE', '', NomBase,
                                result));
   TParamSoc:= TOB.Create ('PARAMSOC', nil, -1);
   TParamSoc.LoadDetailDB ('PARAMSOC', '', '', nil, False);
   For i:=0 to TFille.NombreChampReel do
       begin
       TParamSocFille:= TParamSoc.FindFirst (['SOC_NOM'], [TFille.GetNomChamp (i)], True);
       if ((TParamSocFille <> nil) and ((TFille.GetNomChamp (i)='SO_SOCIETE') or
          (TFille.GetNomChamp (i)='SO_LIBELLE') or
          (TFille.GetNomChamp (i)='SO_ADRESSE1') or
          (TFille.GetNomChamp (i)='SO_ADRESSE2') or
          (TFille.GetNomChamp (i)='SO_ADRESSE3') or
          (TFille.GetNomChamp (i)='SO_CODEPOSTAL') or
          (TFille.GetNomChamp (i)='SO_VILLE') or
          (TFille.GetNomChamp (i)='SO_PAYS') or
          (TFille.GetNomChamp (i)='SO_TELEPHONE') or
          (TFille.GetNomChamp (i)='SO_FAX') or
          (TFille.GetNomChamp (i)='SO_TELEX') or
          (TFille.GetNomChamp (i)='SO_APE') or
          (TFille.GetNomChamp (i)='SO_SIRET') or
          (TFille.GetNomChamp (i)='SO_DATEDEBUTEURO') or
          (TFille.GetNomChamp (i)='SO_PGRACINEAUXI') or
          (TFille.GetNomChamp (i)='SO_PGNUMAUXI') or
          (TFille.GetNomChamp (i)='SO_PGTYPENUMSAL') or
          (TFille.GetNomChamp (i)='SO_PGINCSALARIE') or
          (TFille.GetNomChamp (i)='SO_PGTIERSAUXIAUTO') or
          (TFille.GetNomChamp (i)='SO_PGDECALAGE') or
          (TFille.GetNomChamp (i)='SO_PGDECALAGEPETIT') or
          (TFille.GetNomChamp (i)='SO_PGANALYTIQUE') or
          (TFille.GetNomChamp (i)='SO_PGCONGES') or
          (TFille.GetNomChamp (i)='SO_PGMODIFLIGNEIMP') or
          (TFille.GetNomChamp (i)='SO_PGABSENCE') or
          (TFille.GetNomChamp (i)='SO_PGABSENCECHEVAL') or
          (TFille.GetNomChamp (i)='SO_PGCHR6SEMAINE') or
          (TFille.GetNomChamp (i)='SO_PGMSA') or
          (TFille.GetNomChamp (i)='SO_PGINTERMITTENTS') or
          (TFille.GetNomChamp (i)='SO_PGBTP') or
          (TFille.GetNomChamp (i)='SO_PGRESPONSABLES') or
          (TFille.GetNomChamp (i)='SO_PGCOEFFEVOSAL') or
          (TFille.GetNomChamp (i)='SO_PGSAISIEARRET') or
          (TFille.GetNomChamp (i)='SO_PGTICKETRESTAU') or
          (TFille.GetNomChamp (i)='SO_PGPCS2003'))) then
          begin
          TParamSocFille.PutValue ('SOC_DATA', TFille.GetValeur (i));

          StSQL:= StringReplace (TParamSocFille.MakeUpdateSQL, 'PARAMSOC',
                                 NomBase+'.dbo.PARAMSOC', [RfIgnoreCase]);
          if (StSQL<>'') then
             begin
             StSQL:= StSQL+' WHERE SOC_NOM="'+TFille.GetNomChamp (i)+'"';
             ExecuteSQL (StSQL);
             end;
          end;
       end;
   PGTypeNumSal:= GetParamSocSecur ('SO_PGTYPENUMSAL', '');
   FreeAndNil (TParamSoc);
   end;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 29/03/2007
Modifi� le ... :   /  /
Description .. : Fonction de Controle d'existence des cumuls import�s
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
function ControleCumulPresent : boolean;
Var
StSQL : string;
TCumul, TCumulD, TFille, TInconnu, TPresent : TOB;
begin
StSQL:= 'SELECT * FROM CUMULPAIE WHERE ##PCL_PREDEFINI##';
TInconnu:= TOB.Create('CUMULPAIE', NIL, -1);
TPresent:= TOB.Create('CUMULPAIE', NIL, -1);
TCumul:= TOB.Create('CUMULPAIE', NIL, -1);
TCumul.LoadDetailDBFromSQL ('CUMULPAIE', StSQL);
TFille:= TExtract.FindFirst ([''], [''], True);
While (TFille<>nil) do
      begin
      TCumulD:= TCumul.FindFirst (['PCL_CUMULPAIE'],
                                  [TFille.GetValue ('PCL_CUMULPAIE')], True);
      if (TCumulD<>nil) then
         TFille.ChangeParent(TPresent, -1)
      else
         TFille.ChangeParent(TInconnu, -1);
      TFille:= TExtract.FindNext ([''], [''], True);
      end;

if (TInconnu.Detail.Count<>0) then
   begin
   TFille:= TInconnu.FindFirst ([''], [''], True);
   While (TFille<>nil) do
         begin
         TFille.ChangeParent(TExtract, -1);
         TFille:= TInconnu.FindNext ([''], [''], True);
         end;
   result:= True;
   end
else
   result:= False;
//TobDebug (TExtract);
FreeAndNil (TCumul);
FreeAndNil (TInconnu);
FreeAndNil (TPresent);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 26/03/2007
Modifi� le ... :   /  /
Description .. : Fonction de reprise d'un champ de la base
Mots clefs ... : PAIE;PG_IMPORTASC
*****************************************************************}
function RecupChamp (Fichier, Champ, Where, NomBase : String;
                                      var Trouve : boolean) : Variant;
Var
Q : TQuery;
SQL : String;
BEGIN
SQL:= 'SELECT '+Champ+' FROM '+Nombase+'.DBO.'+Fichier+' '+Where;
Q:= OpenSQL(SQL,TRUE);
Trouve:= (not Q.EOF);
if (not Q.Eof) then
   result:= Q.Fields[0].Value;
Ferme (Q);
END;



end.
