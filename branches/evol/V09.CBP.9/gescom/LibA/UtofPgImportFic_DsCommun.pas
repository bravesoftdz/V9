{***********UNITE*************************************************
Auteur  ...... : PH
Cr�� le ...... : 14/06/2001
Modifi� le ... :   /  /
Description .. : Unit de traitement du fichier ext�rieur � la paie
Suite ........ : Utile pour traiter des absences, des saisies d'�l�ments
Suite ........ : de paie provenant d'un autre logiciel,
Suite ........ : de heures de pr�sences et/ou d'absences provenant d'une
Suite ........ : pointeuse
Suite ........ : Utilis� pour r�cup�rer  les absences venant d'une saisie
Suite ........ : d�port�e.
Mots clefs ... : PAIE;ABSENCES;IMPORT
*****************************************************************}
{ PT1 14/06/01 PH
      Rajout libell�s compl�mentaires dans le traitement des lignes absences pour
      prendre en compte les libell�s compl�mentaires lors de la r�cup des absences
      d�port�es
  PT2 09/10/01 PH Rajout traitement ligne Analytique
  PT3 26/11/01 PH R�cup�ration du libell� saisi de l'absence et non pas un libell� forc�
  PT4 26/11/01 PH Incrementation du num�ro d'ordre des mvts de type CP
  PT5 27/11/01 PH Initialisation de tous les champs de la table absencesalarie
  PT6 27/11/01 PH Si on ne g�re pas les cp et que l'on a des lignes de cp,on perd les lignes
                  sans que l'utilisateur le sache
  PT7 18/12/01 PH remplacement strtofloat par valeur sinon erreur de conversion
  PT8 15/02/02 PH test pour les mvts de cp sur mois clos N et N+1 pour prendre les mvts
                  saisis sur le mois precedant (m�me si clos) au dernier mois
  PT9 28/10/2002 SB On consid�re que c'est le salarie qui saisie les mvts absences de l'import
  PT10 30/10/2002 SB On tronque le libell� de l'absence � 35 caract�res
PT11-1 02/12/2002 PH Regroupement lecture du fichier de fa�on � trouver matin et apr�s midi
                     pour le controle que l'absence n'a pas �t� d�j� saisie
PT11-2 02/12/2002 PH Si Salari� sorti et absence d�j� saisie alors OK
PT12   28/01/2003 SB Erreur appli si type separateur diff�rent de celui utilis�
PT13   13/03/2003 PH Traitement des lignes import pr�-ventilations analytiques salari�s
PT14   04/06/2003 PH Cr�ation automatique des sections analytiques lors de l'import si autoris�
// **** Refonte acc�s V_PGI_env ***** V_PGI_env.nodossier remplac� par PgRendNoDossier() *****
PT15   25/08/2003 PH Correction prise en compte traitement analytique ANA et VEN
PT16   28/08/2003 PH Cr�ation des sections en r�cup�rant le libell� de la section
PT17   08/09/2003 PH Destruction des mouvements ANA
PT18   10/09/2003 PH Controle du s�parateur du fichier import et creation automatique fichier rapport
}
unit UtofPgImportFic;

interface
uses  SysUtils,
      HCtrls,
      HEnt1,
      Classes,
      StdCtrls,
{$IFNDEF EAGLCLIENT}
      Db,
      HDB,
      Hqry,
      Fiche,
      dbTables,
      DBCtrls,
      QRe,
{$ELSE}
      eFiche,
{$ENDIF}
      Controls,
      forms,
      ComCtrls,
      HMsgBox,
      Math,
      UTOM,
      UTOB,
      UTOF,
      HTB97,
      ParamSoc,
      Dialogs,
      HRichOLE,
      HStatus,
      ed_tools,
      PGIEnv;
type
     TOF_PGIMPORTFIC = Class (TOF)
     procedure OnArgument(Arguments : String ) ; override ;
     procedure FicChange(Sender : TObject);
     procedure SepChange(Sender : TObject);
     procedure Traiteligne(chaine,S:string);
     procedure Erreur(Chaine,S: string ;NoErreur:integer);
     procedure Anomalie(Chaine,S: string ;NoErreur:integer);
     function  ControleEnrDossier(chaine,S:string):integer;
     procedure ControleEnregMHE_MFP_MLB(TypeEnr,chaine,S:string;Ecrit:boolean);
     procedure ControleEnregMAB(chaine,S:string;Ecrit:boolean);
     procedure ControleEnregANA(TypeEnr,chaine,S:string;Ecrit:boolean);
     procedure ControleEnregVEN (TypeEnr,chaine,S:string;Ecrit:boolean);
     procedure ImprimeClick(Sender: TObject);
     function  ExisteRubrique(Rubrique:string):boolean;
     function  ExisteSection(Axe,Section,LibSect : string):boolean;
     procedure ControleSalarie(TypeEnr,chaine,S,CodeSalarie:string);
     procedure ConsultErreurClick(Sender:Tobject);
     procedure ValideEcran(Top:boolean);
     procedure ImporteFichier;
     function  IsMarqueDebut(S:string):boolean;
     function  IsMarqueFin(S:string):boolean;
     procedure FermeTout;
     function  IsPeriodecloture (Dated, DateF : TDateTime; CasCp : String = '-') : integer;
     function  RendNumOrdre (TypeMvt, CodeSalarie : String) : integer;
     function  PgImportDef (LeNomduFichier, LeTypImp : String; LeSeparateur : Char = '|') : Boolean ;
     procedure ControleFichierImport (Sender:Tobject);
     function  ImportRendPeriodeEnCours (var ExerPerEncours,DebPer,FinPer : String) : Boolean;
     function  ImportRendExerSocialEnCours (var MoisE, AnneeE, ComboExer : String; var DebExer, FinExer : TDateTime) : Boolean;
     function  ImportColleZeroDevant(Nombre , LongChaine : integer) : string ;
     private
     MarqueDebut,MarqueFin,typebase,typetaux,typecoeff,typemontant,SalariePrec,RubPrec: string;
     TFinPer,DateEntree,DateSortie: TDatetime;
     Separateur            : char;
     MarqueFinOk,Erreur_10,ExisteErreur,LibErreur,libanomalie  : boolean;
     RapportErreur : THRichEditOLE;
     Tob_sal, tob_rubrique,Tob_section,Tob_Abs,Tob_HSR,Tob_OrdreAbs,Tob_OrdreHSR,Tob_PaieVentil : tob;
// PT13   13/03/2003 PH Traitement des lignes import pr�-ventilations analytiques salari�s
     Tob_Ventil  : TOB;
     FR          : TextFile;
     F           : TextFile;
     taille      : integer;
     Sep         : Thvalcombobox; // PT18
     NomDuFichier : String ;
     TypImport   : String ;
     public
     end;
{
NoErreur :
5 : Manque marque d�but fichier

}

implementation

//uses P5Def ;
// uses pgCommun ;
{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie Pgi
Cr�� le ...... : 03/02/2003
Modifi� le ... :   /  /
Description .. : fonction d'initialisation d'un mouvement cong�s pay�s
Suite ........ : A appeler avant tout renseignement de nouveau mvt
Mots clefs ... : PAIE;CP
*****************************************************************}
procedure ImportInitialiseTobAbsenceSalarie (TCP  : tob);
begin
  TCP.Putvalue('PCN_TYPEMVT'      ,'CPA');
  TCP.Putvalue('PCN_SALARIE'      ,'');
  TCP.Putvalue('PCN_DATEDEBUT'    ,0);
  TCP.Putvalue('PCN_DATEFIN'      ,0);
  TCP.Putvalue('PCN_ORDRE'        ,0);
  TCP.Putvalue('PCN_TYPECONGE'    ,'');
  TCP.Putvalue('PCN_SENSABS'      ,'');
  TCP.PutValue('PCN_PERIODEPY'    ,-1);
  TCP.Putvalue('PCN_LIBELLE'      ,'');
  TCP.Putvalue('PCN_DATEMODIF'    ,0);
  TCP.Putvalue('PCN_DATESOLDE'    ,0);
  TCP.Putvalue('PCN_DATEVALIDITE' ,0);
  TCP.PutValue('PCN_PERIODECP'    ,-1);
  TCP.Putvalue('PCN_DATEDEBUTABS' ,0);
  TCP.Putvalue('PCN_DATEFINABS'   ,0);
  TCP.Putvalue('PCN_DATEPAIEMENT' ,0);
  TCP.Putvalue('PCN_CODETAPE'     ,'...');//PT-13
  TCP.Putvalue('PCN_JOURS'        ,0);
  TCP.Putvalue('PCN_BASE'         ,0);
  TCP.Putvalue('PCN_NBREMOIS'     ,0);
  TCP.Putvalue('PCN_CODERGRPT'    ,0);
  TCP.PutValue('PCN_MVTDUPLIQUE'  ,'-');
  TCP.Putvalue('PCN_ABSENCE'      ,0);
  TCP.Putvalue('PCN_MODIFABSENCE' ,'-');
  TCP.Putvalue('PCN_APAYES'       ,0);
  TCP.Putvalue('PCN_VALOX'        ,0);
  TCP.Putvalue('PCN_VALOMS'       ,0);
  TCP.Putvalue('PCN_VALORETENUE'  ,0);
  TCP.Putvalue('PCN_MODIFVALO'    ,'-');
  TCP.Putvalue('PCN_PERIODEPAIE'  ,'');
  TCP.Putvalue('PCN_ETABLISSEMENT','');
  TCP.Putvalue('PCN_TRAVAILN1'    ,'');
  TCP.Putvalue('PCN_TRAVAILN2'    ,'');
  TCP.Putvalue('PCN_TRAVAILN3'    ,'');
  TCP.Putvalue('PCN_TRAVAILN4'    ,'');
  TCP.PutValue('PCN_GENERECLOTURE','-');
  // a voir   TCP.PutValue('PCN_CONFIDENTIEL','-');
end;

function  ImportCalculPeriode(DTClot,DTValidite:TDatetime):integer;
var
  Dtdeb,DtFin,DtFinS :TDATETIME;
  aa,mm,jj           : word;
  i                  : integer;
begin
  result :=-1;
  if DTClot <=idate1900 then exit;  //PT53
  Decodedate(DTclot,aa,mm,jj);
  DtDeb := encodedate(aa-1,mm,jj)+1;
  DtFin := DtClot;
  DtFinS := encodedate(aa+1,mm,jj); 
  if Dtvalidite > Dtfins then
     begin
     result := -9;
     exit;
     end;
  if DtValidite > DtClot then exit;
  result := 0;
  i:= 0;
  while not ((DTValidite >= DtDeb) and (DTValidite <= DtFin)) do
     begin
     i := i+1;
     if i > 50 then exit; // pour ne pas boucler au cas o�....
     result := result +1;
     DtFin := DtDeb -1 ;
     Decodedate(DTFin,aa,mm,jj);
     DtDeb := encodedate(aa-1,mm,jj)+1;
     end;
end;

Function  ImportRendNoDossier () : String;
begin
if (V_PGI_Env = NIL) OR (V_PGI_Env.NoDossier = '') then result := '000000'
  else result := V_PGI_Env.NoDossier;
end;
function PgImpnotVide(T:tob; Const MulNiveau:boolean): boolean;
var
tp : tob;
begin
     result := false;
     if t = nil then
        exit;
     tp := t.findfirst([''],[''],MulNiveau);
     result := (tp<>nil);
end;

procedure TOF_PGIMPORTFIC.OnArgument(Arguments : String ) ;
var
    NomFic,FicRapport   : ThEdit;
    BValider,BImprime,ConsultErreur : TToolbarbutton97;
    st,Stfichier,Sttype: String ;
begin
  st := Arguments ;
  Stfichier := ReadTokenSt (St);
  Sttype := ReadTokenSt (St);
  if Arguments <> '' then PgImportDef (Stfichier,Sttype  )
  else
  begin
  NomFic := THedit (GetControl ('EDTFICIMPORT'));
  taille := 0;
  if Nomfic <> nil then
     Begin
     NomFic.OnChange := FicChange;
     Nomfic.DataType := 'OPENFILE(*.txt;*.*)'
     end;
  FicRapport := THedit (GetControl ('FICRAPPORT'));
  if FicRapport <> nil then
  begin
     FicRapport.OnExit := FicChange;
     FicRapport.DataType := 'OPENFILE(*.txt;*.*)' ;
  end ;
  end ;
  BValider := TToolbarbutton97 (GetControl ('BVALIDER'));
  if BValider <> nil then
     BValider.OnClick := ControleFichierImport;

   BImprime :=  ttoolbarbutton97(getcontrol('BIMPRIMER'));
   if Bimprime <> nil then
      Bimprime.Onclick := ImprimeClick;

   Salarieprec := '';
   RapportErreur := THRichEditOLE(getcontrol('LISTEERREUR'));

   MarqueDebut := '***DEBUT***';
   MarqueFin   := '***FIN***';
   Sep := THValComboBox(getcontrol('SEPARATEUR'));
   if Sep <> nil then
      begin
      Sep.value    := 'TAB';
// PT18   10/09/2003 PH Controle du s�parateur du fichier import et creation automatique fichier rapport
      Sep.OnExit := SepChange;
      Separateur   := #9;
      end;
   ConsultErreur := TToolbarbutton97(getcontrol('CONSULTERREUR'));
   if ConsultErreur <> nil then
         ConsultErreur.Onclick := ConsultErreurClick;
end;

procedure TOF_PGIMPORTFIC.ConsultErreurClick(Sender:Tobject);
var
FicRapport : THedit;
F          : TextFile;
S          : string;
TPC        : TPageControl;
T          : TTabSheet;
i          : integer;
okok       : Boolean;
begin
  if RapportErreur = nil then exit;
  FicRapport := THedit (GetControl ('FICRAPPORT'));
  if FicRapport = Nil then exit;
  RapportErreur.Clear ;
  if FicRapport.Text = '' then exit  ;
  if Not FileExists(FicRapport.text) then exit ;

   valideEcran(false);
   AssignFile(F, FicRapport.Text);
   Reset(F);
   i:=0;
   InitMoveProgressForm (NIL,'Chargement du fichier d''erreurs � l''�cran', 'Veuillez patienter SVP ...',taille,TRUE,TRUE);
   while not eof(F) do
      begin
      i:=i+1;
      Readln(F,S);
      okok := MoveCurProgressForm (IntToStr(i)) ;
      if NOT okok then
         begin
         closeFile(F);
         FiniMoveProgressForm;
         end;
      RapportErreur.lines.Add(S);
      end;

   closeFile(F);
   ValideEcran(true);
   FiniMoveProgressForm;

   T:=TTabSheet(GetControl('TT2')) ;
   if T <> nil then
      begin
      TPC := TPageControl(getcontrol('PAGECONTROL1'));
      if TPC <> nil then
        TPC.ActivePage := T;
      end;
end;
procedure TOF_PGIMPORTFIC.valideEcran(Top:boolean);
begin
  SetControlEnabled('EDTFICIMPORT'  ,top);
  SetControlEnabled('FICRAPPORT'    ,top);
  SetControlEnabled('SEPARATEUR'    ,top);
  SetControlEnabled('BVALIDER'      ,top);
  SetControlEnabled('BFERME'        ,top);
  SetControlEnabled('CONSULTERREUR' ,top);
end;
procedure TOF_PGIMPORTFIC.ControleFichierImport(Sender:Tobject);
var
NomFic,FicRapport : ThEdit;
S,st              : string;
NoErreur,i,ll     : integer;
ExerPerEncours,DebPer,FinPer:string;
Q                 : TQuery;
LeFic,LeRapport   : String ;
begin
  ExisteErreur  := false;
  MarqueFinOk := false;
  i           := 0;
  if TypImport <> 'AUTO' then
  begin
    NomFic      := THedit (GetControl ('EDTFICIMPORT'));
    if NomFic   = Nil then exit;
    if NomFic.Text = '' then
    begin
      PGIBox('Fichier d''import obligatoire', 'Import Fichier');
      exit  ;
     end;
    if Not FileExists(NomFic.text) then
    begin
      PGIBox('Fichier d''import inexistant', 'Import Fichier');
      exit ;
    end;
    FicRapport := THedit (GetControl ('FICRAPPORT'));
    if FicRapport = Nil then exit;
    if FicRapport.Text = '' then
    begin
      PGIBox('Fichier de rapport obligatoire', 'Import Fichier');
      exit  ;
    end;
    if Not FileExists(FicRapport.text) then
    begin
// PT18    PGIBox('Fichier de rapport inexistant', 'Import Fichier'); exit ;
    end;
    valideEcran(false);
    LeFic := NomFic.Text ;
    LeRapport := FicRapport.Text ;
    assignFile(FR, LeRapport);
    Reset(FR);
    ReWrite(FR);
  end
  else
  begin
    LeFic := NomDuFichier ;
    LeRapport:=ExtractFilePath(NomDuFichier) + 'GenerationPaie.log';
    AssignFile(FR, LeRapport);
//    ll := Pos ('.', LeFic) ;
//    LeRapport := Copy (LeFic, 1, ll-1) + '.log' ; // nom du fichier de rapport = .log au lieu de txt
    if Not FileExists(LeRapport) then
    begin
      //AssignFile ( FR, LeFic) ;
{$i-} ReWrite(FR); {$i+}
      If IoResult<>0 Then
      Begin
        PGIBox('Fichier rapport inaccessible : '+LeFic,'Abandon du traitement');
        Exit ;
      End;
      //closeFile ( FR) ;
    end
    else
      Append(FR);
  end ;
   AssignFile(F, LeFic);
   Reset(F);

   liberreur := true;
   S := '';
   While ((not IsMarqueDebut (s)) and (not eof(F))) do
      begin
      Readln(F,S);
      end;
   if eof(F) then
      begin
      Erreur(s,S,5);
      CloseFile(F);
      CloseFile(FR);
      Exit;
      end;
   InitMoveProgressForm (NIL,'Contr�le du fichier d''import', 'Veuillez patienter SVP ...',taille,False,TRUE);

   if not Eof(F) then
      begin
      i := i+1;
      MoveCurProgressForm (IntToStr(i)) ;
      Readln(F,S);
      Noerreur := ControleEnrDossier(S,S);
      if NoErreur <> 0 then
         Erreur(s,S,NoErreur);
      end;
   ExerPerEncours:='';DebPer:='';FinPer:='';  TFinPer :=0;
   if not ImportRendPeriodeEnCours (ExerPerEncours,DebPer,FinPer) then
     Erreur('','',7);
   if FinPer <>'' then
     if Isvaliddate(FinPer) then
        TFinPer := strtodate(FinPer) else
             Erreur('','',7);
   st := 'SELECT PSA_SALARIE,PSA_DATEENTREE,PSA_DATESORTIE,PSA_SUSPENSIONPAIE,PSA_ETABLISSEMENT, '+
         'PSA_TRAVAILN1,PSA_TRAVAILN2,PSA_TRAVAILN3,PSA_TRAVAILN4,PSA_CODESTAT,PSA_CONFIDENTIEL,'+
         'ETB_DATECLOTURECPN,ETB_CONGESPAYES FROM SALARIES LEFT JOIN ETABCOMPL ON PSA_ETABLISSEMENT = ETB_ETABLISSEMENT';
   Q  := opensql(st,true);
   if (not Q.eof) then
          begin
          Tob_sal := TOB.Create ('Table des Salari�s', NIL, -1) ;
          if tob_sal <> nil then
             Tob_sal.loaddetaildb('INFOS SALARIES','','',Q,false,false,-1,0);
          end;
   Ferme(Q);
   st := 'SELECT * FROM REMUNERATION WHERE ##PRM_PREDEFINI## PRM_RUBRIQUE <>""';
   Q  := opensql(st,true);
   if not Q.eof then
          begin
          Tob_rubrique := TOB.Create ('Table des rubriques', NIL, -1) ;
          if tob_rubrique <> nil then
             Tob_rubrique.loaddetaildb('REMUNERATION','','',Q,false,false,-1,0);
          end;
   Ferme(Q);
//   PT2 09/10/01 PH Rajout traitement ligne Analytique
   if GetParamSoc('SO_PGANALYTIQUE') then
   begin
   st := 'SELECT S_AXE,S_SECTION FROM SECTION ORDER BY S_AXE,S_SECTION';
   Q  := opensql(st,true);
   if not Q.eof then
          begin
          Tob_section := TOB.Create ('Table des sections', NIL, -1) ;
          if tob_section <> nil then
             Tob_section.loaddetaildb('SECTION','','',Q,false,false,-1,0);
          end;
   Ferme(Q);
   end;
// FIN PT2
   while not Eof(F) do //Deuxieme passage
         begin
         i := i+1;
         MoveCurProgressForm (IntToStr(i)) ;
         Readln(F, S);
         if MarqueFinOk then
            begin
            Erreur_10 := true;
            Erreur (s,S, 10);
            end;
         St := S;
         St :=  readtokenPipe(St,Separateur);
         if St = MarqueFin then
            begin MarqueFinOk := true;continue end;
         Traiteligne(S,S);
         end;
    if not MarqueFinOk then Erreur('','',15);
    FiniMoveProgressForm;

    if not ExisteErreur then
    begin
      Reset(F);
      ImporteFichier();
      if TypImport = 'AUTO' then
      begin
        Writeln(FR,'La g�n�ration dans la Paie s''est bien pass�e');
        PGIInfo('Les lignes d''activit�e sont transf�r�es dans la paie avec succ�s.#13#10'+
        ' Lancez la g�n�ration de bulletins pour l''int�gration dans les paies.','G�n�ration Paie');
      end
      else
      if RapportErreur <> nil then
      begin
        Writeln(FR,'VOTRE IMPORT S''EST BIEN PASSE');
        //RapportErreur.Lines.add('VOTRE IMPORT S''EST BIEN PASSE');
        PGIInfo('Le fichier a �t� import� avec succ�s.#13#10'+
        ' Lancez la g�n�ration de bulletins pour l''int�gration dans les paies.','Import fichier');
      end;
    end
    else
    begin
      if TypImport <> 'AUTO' then
      PGIBox('Des erreurs d�tect�es n''ont pas permis l''import de votre fichier.#13#10'+
      ' Pour consulter la liste d''erreurs, cliquez le bouton liste','Import de fichier')
      else
      begin
        PGIBox('Des erreurs d�tect�es n''ont pas permis la g�n�ration dans la paie.#13#10'+
        ' Pour consulter la liste d''erreurs, cliquez sur fichier.log W');
        Writeln(FR,'Des erreurs ont �t� d�tect�es dans l''int�gration dans la paie.');
      end;
    end;
    FermeTout;
    valideEcran(true);
end;

function TOF_PGIMPORTFIC.IsMarqueDebut(S:string):boolean;
begin
   result := true;
   if S = MarqueDebut then exit;
   S :=  readtokenPipe(S,Separateur);
   if S = MarqueDebut then exit
   else result:=false;
end;
function TOF_PGIMPORTFIC.IsMarqueFin(S:string):boolean;
begin
   result := true;
   if S = MarqueFin then exit;
   S :=  readtokenPipe(S,Separateur);
   if S = MarqueFin then exit
   else result:=false;
end;

procedure TOF_PGIMPORTFIC.FermeTout;
begin
    CloseFile(F);
    CloseFile(FR);
    if PgImpnotVide(Tob_sal,true) then
      Tob_sal.Free;
    if PgImpnotVide(Tob_rubrique,true) then
      Tob_rubrique.Free;
//   PT2 09/10/01 PH Rajout traitement ligne Analytique
    if Tob_section <> NIL then begin Tob_section.free; tob_section := NIL; end;
end;

procedure TOF_PGIMPORTFIC.ImporteFichier;
var
i                                 : integer;
S,CodeEnr,st,tempo,CodeS,salP     : string;
Tob_S,T                           : tob;
Q                                 : TQuery;
DD,DF                             : TDateTime ;
begin
  SalP := '';
  st := 'SELECT PCN_SALARIE,PCN_TYPEMVT,MAX(PCN_ORDRE) AS NUMORDRE FROM ABSENCESALARIE GROUP BY PCN_SALARIE,PCN_TYPEMVT ORDER BY PCN_SALARIE';
  Q := Opensql(st,true);
//  if Q.eof then
//     begin  Ferme(Q);   exit;     end;
  Tob_OrdreABS := Tob.create('Table des ordre absences maxi',nil,-1);
  Tob_ordreAbs.loaddetaildb('LES ABSENCESALARIES','','',Q,false);
  Ferme(Q);
  if Tob_ordreABS = nil then
     begin     exit;     end;

  st := 'SELECT PSD_SALARIE,MAX(PSD_ORDRE) AS PSD_ORDRE FROM HISTOSAISRUB GROUP BY PSD_SALARIE';
  Q := Opensql(st,true);
//  if Q.eof then
//     begin     Ferme(Q);   exit;     end;
  Tob_OrdreHSR := tob.create('Table des ordre maxi',nil,-1);
  Tob_ordreHSR.addchampsup('PSD_SALARIE',True);
  Tob_ordreHSR.addchampsup('PSD_ORDRE',True);
  Tob_ordreHSR.loaddetaildb('HISTOSAISRUB','','',Q,false);
  Ferme(Q);
  if Tob_ordreHSR = nil then
     begin   exit;     end;

   InitMoveProgressForm (NIL,'Ecriture de la base', 'Veuillez patienter SVP ...',taille,False,TRUE);

   Tob_S := Tob.create('Tob lignes import',Nil,-1);
   Tob_Abs := tob.create('ABSENCES A INSERER',Tob_S,-1);
   Tob_HSR := tob.create('HISTOSAISRUB A INSERER',Tob_S,-1);
// PT2 09/10/01 PH Rajout traitement ligne Analytique
   if GetParamSoc('SO_PGANALYTIQUE') then
// PT13   13/03/2003 PH Traitement des lignes import pr�-ventilations analytiques salari�s
   begin
     Tob_PaieVentil := TOB.Create ('Les Ventils Analytiques', NIL, -1);
     Tob_Ventil := TOB.Create ('Les Pr�ventils Analytiques', NIL, -1);
   end;
   i := 0;
   while not Eof(F) do //Deuxieme passage
         begin
         i := i+1;
         MoveCurProgressForm (IntToStr(i)) ;
         Readln(F, S);
         if isMarqueDebut(S) then
            continue;
         if isMarqueFin(S) then
            break;
         CodeEnr   :=  readtokenPipe(S,Separateur);
         tempo := S;
         if CodeEnr = '000' then
            continue;
// PT13   13/03/2003 PH Traitement des lignes import pr�-ventilations analytiques salari�s
         if CodeEnr = 'VEN' then
         begin
            CodeS := readtokenPipe(tempo,Separateur);
            if CodeS <> SalP then
               begin
               st := 'Salarie '+CodeS+' : enregistrement(s) pr�-ventilations analytiques trait�(s)';
               Anomalie(st,st,98);
               SalP := CodeS;
               end;
           ControleEnregVEN(CodeEnr,S,S,True);
         end
         else
// FIN PT13
         if CodeEnr = 'MAB' then
            begin // Traitement ligne absences
            CodeS := readtokenPipe(tempo,Separateur);
            if CodeS <> SalP then
               begin
               st := 'Salarie '+CodeS+' : enregistrement(s) Absence trait�(s)';
               Anomalie(st,st,98);
               SalP := CodeS;
               end;
            ControleEnregMAB(S,S,True);
            end // Fin traitement ligne absences
            else
            begin
            CodeS := readtokenPipe(tempo,Separateur);
            if CodeS <> SalP then
               begin
               if CodeEnr <> 'ANA' then st := 'Salarie '+CodeS+' : enregistrement(s) MHE ou MLB ou MFP trait�(s)'
                  else st := 'Salarie '+CodeS+' : enregistrement(s) Analytique(s) trait�(s)';
               Anomalie(st,st,98);
               SalP := CodeS;
               end;

            if CodeEnr <> 'ANA' then ControleEnregMHE_MFP_MLB(CodeEnr,S,S,True)
               else ControleEnregANA(CodeEnr,S,S,True);
            end;
         end; // Fin boucle lecture fichier import
try
 BeginTrans;

    if Tob_HSR <> NIL then
      begin
      Tob_HSR.SetAllModifie (TRUE);
      Tob_HSR.InsertOrUpdateDB(false);
      end;
    if Tob_ABS <> NIL then
      begin
      Tob_ABS.SetAllModifie (TRUE);
      Tob_ABS.InsertOrUpdateDB(false);
      end;
    if Tob_PaieVentil <> NIL then
      begin
// PT17   08/09/2003 PH Destruction des mouvements ANA
        SalP := '' ;
        T := Tob_PaieVentil.FindFirst ([''],[''],FALSE);
        While T <> NIL do
        begin
          CodeS := T.GetValue ('PAV_COMPTE');
          DD := T.GetValue ('PAV_DATEDEBUT');
          DF := T.GetValue ('PAV_DATEFIN');
          if CodeS <> SalP then
          begin
            st := 'DELETE FROM PAIEVENTIL WHERE PAV_NATURE LIKE "PG%" AND PAV_COMPTE="'+CodeS+'"'+
                  ' AND PAV_DATEDEBUT >= "'+UsDateTime (DD)+ '" AND PAV_DATEFIN <= "'+UsDateTime (DF)+ '"' ;
            ExecuteSQL(St);
            SalP := CodeS;
          end;
          T := Tob_PaieVentil.FindNext ([''],[''],FALSE);
        end;
// FIN PT17        
      Tob_PaieVentil.SetAllModifie (TRUE);
      Tob_PaieVentil.InsertOrUpdateDB(false);
      end;
// PT13   13/03/2003 PH Traitement des lignes import pr�-ventilations analytiques salari�s
    if Tob_Ventil <> NIL then
      begin
// PT15   25/08/2003 PH Correction destruction des pr�-ventilations analytiques
        SalP := '' ;
        T := Tob_Ventil.FindFirst ([''],[''],FALSE);
        While T <> NIL do
        begin
          CodeS := T.GetValue ('V_COMPTE');
          if CodeS <> SalP then
          begin
// PT15   25/08/2003 PH Correction destruction des pr�-ventilation sanalytiques
            ExecuteSQL('DELETE FROM VENTIL WHERE V_NATURE LIKE "SA%" AND V_COMPTE="'+CodeS+'"');
            SalP := CodeS;
          end;
          T := Tob_Ventil.FindNext ([''],[''],FALSE);
        end;
        Tob_Ventil.SetAllModifie (TRUE);
        Tob_Ventil.InsertOrUpdateDB(false);
      end;
// FIN PT13
// FIN PT2
    FiniMoveProgressForm();
    if Tob_ordreHSR <> nil then Tob_ordreHSR.free;
    if Tob_ordreABS <> nil then Tob_ordreABS.free;
    if Tob_S        <> nil then Tob_S.free;
// PT13   13/03/2003 PH Traitement des lignes import pr�-ventilations analytiques salari�s
    if Tob_Ventil   <> nil then Tob_Ventil.free;
    if Tob_PaieVentil <> nil then Tob_PaieVentil.free;
// FIN PT13

 CommitTrans;
Except
 Rollback;
 PGIBox ('Une erreur est survenue lors de l''�criture dans la base', 'Ecriture fichier import');
END;

end;
// ligne absence
{function TOF_PGIMPORTFIC.EcritligneMAB(S:string,T:tob);
var
begin

end;}
procedure TOF_PGIMPORTFIC.Traiteligne(chaine,S:string);
var
CodeEnr : string;
begin

   CodeEnr :=  readtokenPipe(S,Separateur);
   if (CodeEnr = 'MHE') or (CodeEnr = 'MFP')or (CodeEnr = 'MLB') then
      ControleEnregMHE_MFP_MLB(CodeEnr,chaine,S,false)
   else
   if CodeEnr = 'MAB' then ControleEnregMAB(chaine,S,false)
// PT13   13/03/2003 PH Traitement des lignes import pr�-ventilations analytiques salari�s
   else
   if CodeEnr = 'VEN' then ControleEnregVEN (CodeEnr,chaine,S,false)
   else
// PT15   25/08/2003 PH Correction prise en compte traitement analytique ANA
   if CodeEnr = 'ANA' then ControleEnregANA (CodeEnr,chaine,S,false)
   else Erreur ('',S, 20);
end;

function  TOF_PGIMPORTFIC.ControleEnrDossier(chaine,S:string):integer;
var
NoDoss,DossEnCours,ent               : string;
DatedebES,DateFinES,DebExer, FinExer : TDateTime;
MoisE, AnneeE, ComboExer             : string;
aa,mm,jj                             : word;
rep                                  : Integer;
begin
 ent := readtokenPipe(S,Separateur);
 if ent <> '000' then Erreur (chaine,DossEnCours,220);
// **** Refonte acc�s V_PGI_env ***** V_PGI_env.nodossier remplac� par PgRendNoDossier() *****
 if (V_PGI_Env <> NIL) then DossEnCours := ImportRendNoDossier ()
     else DossEnCours := '000000';
  NoDoss := readtokenPipe(S,Separateur);
  if (DossEnCours <> NoDoss) AND (DossEnCours <> '000000') AND (DossEnCours <> '') then
     Erreur (chaine,DossEnCours,230);
  // format US vers format Fran�ais
  {DEB PT12 transtypage incorrect si S=''}
  DecodeDate(idate1900,aa,mm,jj);
  if S<>'' then jj := strtoint(readtokenPipe(S,'/'));
  if S<>'' then mm := strtoint(readtokenPipe(S,'/'));
  if S<>'' then aa := strtoint(readtokenPipe(S,Separateur));
  DatedebES := encodedate(aa,mm,jj);
  DecodeDate(idate1900,aa,mm,jj);
  if S<>'' then jj := strtoint(readtokenPipe(S,'/'));
  if S<>'' then mm := strtoint(readtokenPipe(S,'/'));
  if S<>'' then aa := strtoint(readtokenPipe(S,Separateur));
  DatefinES := encodedate(aa,mm,jj);
  {FIN PT12}

  MoisE := ''; AnneeE := ''; ComboExer := ''; DebExer:= 0; FinExer:=0;
  ImportRendExerSocialEnCours (MoisE, AnneeE, ComboExer,DebExer, FinExer);
  if ((datedebES <> DebExer) or (dateFinES <> FinExer)) AND ((datedebES > Idate1900) AND (dateFinES > Idate1900) ) then
     begin
     Rep := PGIAsk('Les dates d''exercice social du fichier sont diff�rentes de celles de votre entreprise#13#10Voulez-vous quand m�me prendre en compte votre fichier?',
                   'Incoh�rence des dates d''exercice social.');
     if rep <> mrYes then Erreur (chaine,DossEnCours,240);
     end;
result := 0;
end;
procedure TOF_PGIMPORTFIC.ControleEnregMHE_MFP_MLB(TypeEnr,chaine,S:string;Ecrit:boolean);
var
Codesalarie,DateDebutperiode,DateFinperiode,SNoOrdre: string;
Rubrique, typeAlim, libelle,sBase,staux,sCoefficient,sMontant   : string;
TDateDeb,TDateFin : tdatetime;
Base,taux,coeff,montant : double;
Sal,TS,T                : tob;
Ordre, TopCloture       : integer;
begin
  libErreur   := false;
  libanomalie := false;
  Ordre       := 1;
  // contr�le sur le salari�
  Codesalarie := readtokenPipe(S,Separateur);
  if CodeSalarie <> Salarieprec then
     begin
     ControleSalarie(TypeEnr,chaine,S,CodeSalarie);
     end;
  Salarieprec := Codesalarie;
  DateDebutperiode := readtokenPipe(S,Separateur);
  if not Isvaliddate(DatedebutPeriode) then
     Erreur (chaine,DatedebutPeriode,30);
  DateFinperiode   := readtokenPipe(S,Separateur);
  if not Isvaliddate(DateFinPeriode) then
     Erreur (chaine,DateFinPeriode,35);

  TDateDeb := 0; TDateFin := 0;

  if (Isvaliddate(DatedebutPeriode)) and (Isvaliddate(DatefinPeriode)) then
     begin
     TDateDeb := strtodate(DatedebutPeriode);
     TDateFin := strtodate(DatefinPeriode);
     end;

  if TDateFin < TDateDeb then
     Erreur(chaine,DateDebutPeriode + '//' +DateFinPeriode,40);

  Topcloture:= IsPeriodecloture (TDatedeb, TDateFin );
  if TopCloture = 1 then Erreur(Chaine,'',44)
  else
  if TopCloture = 2 then Erreur(Chaine,'',47)
  else
  if TopCloture = 3 then Erreur(Chaine,'',48);

  if (DateSortie > 10) and (DateSortie < TDateDeb) then
     Erreur(Chaine,'',46);

  SNoOrdre    := readtokenPipe(S,Separateur);
  if SnoOrdre = '' then
       Erreur(chaine,SNoOrdre,45);

  Rubrique    := readtokenPipe(S,Separateur);
  if TypeEnr <> 'MLB' then RubPrec := Rubrique;

  TypeBase := '';TypeTaux := '';TypeCoeff:='';TypeMontant:='';
  if (TypeEnr='MHE') or(typeEnr='MFP') then
     begin
     If not ExisteRubrique(Rubrique) then
            Erreur(chaine,Rubrique,50);
     end
     else
     begin
     if Rubrique <> rubPrec then
        Erreur(Chaine, Rubrique,52);
     end;
  libelle := readtokenPipe(S,Separateur);

  TypeAlim    := readtokenPipe(S,Separateur);
  if (TypeAlim = '')  and  (TypeEnr<>'MLB')then
     Erreur(chaine,Rubrique,55);

  if (  (TypeBase    <> '00') and (pos('B',typeAlim)>0) or
        (typeBase    =  '00') and (pos('B',typeAlim)=0) or
        (TypeTaux    <> '00') and (pos('T',typeAlim)>0) or
        (typeTaux    =  '00') and (pos('T',typeAlim)=0) or
        (TypeCoeff   <> '00') and (pos('C',typeAlim)>0) or
        (typeCoeff   =  '00') and (pos('C',typeAlim)=0) or
        (TypeMontant <> '00') and (pos('M',typeAlim)>0) or
        (typeMontant =  '00') and (pos('M',typeAlim)=0) ) and (TypeEnr<>'MLB') then
        Erreur(chaine,Rubrique,57);

  sBase       := readtokenPipe(S,Separateur);
  if pos('B',typeAlim) > 0
     then begin
          if sbase = '' then
             Erreur(chaine,sBase,60)
             else
             if not Isnumeric(sBase) then
                    Erreur(chaine,sBase,60);
          end
     else
          begin
          if sBase <> ''  then
                    Erreur(chaine,sBase,65);
          end;

  staux       := readtokenPipe(S,Separateur);
  if pos('T',typeAlim) > 0
     then begin
          if staux = '' then
             Erreur(chaine,staux,70)
             else
             if not Isnumeric(staux) then
                    Erreur(chaine,staux,70);
          end
     else
          begin
          if staux <> ''  then
                    Erreur(chaine,staux,75);
          end;


  sCoefficient:= readtokenPipe(S,Separateur);
  if pos('C',typeAlim) > 0
     then begin
          if sCoefficient = '' then
             Erreur(chaine,sCoefficient,80)
             else
             if not Isnumeric(sCoefficient) then
                    Erreur(chaine,sCoefficient,80);
          end
     else
          begin
          if sCoefficient <> ''  then
                    Erreur(chaine,sCoefficient,85);
          end;

  sMontant    := readtokenPipe(S,Separateur);
  if pos('M',typeAlim) > 0
     then begin
          if sMontant = '' then
             Erreur(chaine,sMontant,90)
             else
             if not Isnumeric(sMontant) then
                    Erreur(chaine,sMontant,90);
          end
     else
          begin
          if sMontant <> ''  then
             Erreur(chaine,sMontant,95);
          end;

  if not Ecrit then exit;
  Sal := Tob_Sal.findfirst(['PSA_SALARIE'],[CodeSalarie],true);
  if Sal = nil then exit;
  TS := Tob_OrdreHSR.findfirst(['PSD_SALARIE'],[CodeSalarie],true);
  if TS <> nil then
     begin
     Ordre := TS.getvalue('PSD_ORDRE');
     TS.putvalue(('PSD_ORDRE'),Ordre+1);
     end
     else
     begin
     TS := Tob.create('HISTOSAISRUB',Tob_OrdreHSR,-1);
     if Ts <> nil then
        begin
        Ts.putvalue('PSD_SALARIE',CodeSalarie);
        Ts.putValue('PSD_Ordre',1);
        end;
     end;
  if not Ecrit then exit;
  Sal := Tob_Sal.findfirst(['PSA_SALARIE'],[CodeSalarie],true);
  if Sal = nil then exit;
  T := Tob.create('HISTOSAISRUB',TOB_HSR,-1);
  if T = nil then exit;
  TS := Tob_OrdreHSR.findfirst(['PSD_SALARIE'],[CodeSalarie],true);
  if TS <> nil then
     begin
     Ordre := TS.getvalue('PSD_ORDRE');
     TS.putvalue(('PSD_ORDRE'),Ordre+1);
     end
     else
     begin
     TS := Tob.create('HISTOSAISRUB',Tob_OrdreHSR,-1);
     if Ts <> nil then
        begin
        Ts.putvalue('PSD_SALARIE',CodeSalarie);
        Ts.putValue('PSD_Ordre',1);
        end;
     end;
   Base := 0;Taux :=0;Coeff:=0;Montant :=0;
   T.PutValue ('PSD_ORIGINEMVT'  , TypeEnr);
   T.PutValue ('PSD_SALARIE'     , CodeSalarie);
   T.PutValue ('PSD_DATEDEBUT'   , TDateDeb);
   T.PutValue ('PSD_DATEFIN'     , TDateFin);
   T.PutValue ('PSD_RUBRIQUE'    , Rubrique);
   T.PutValue ('PSD_ORDRE'       , Ordre);
   T.PutValue ('PSD_LIBELLE'     , Libelle );
   T.PutValue ('PSD_RIBSALAIRE'  , '');
   T.PutValue ('PSD_BANQUEEMIS'  , '') ;
   T.PutValue ('PSD_TOPREGLE'    , '-');
   T.PutValue ('PSD_TYPALIMPAIE' , typeAlim);
   T.PutValue ('PSD_ETABLISSEMENT', sal.getvalue('PSA_ETABLISSEMENT'));
   if pos('B',typeAlim) > 0 then Base := Valeur(sBase);
   if pos('T',typeAlim) > 0 then Taux := Valeur(sTaux);
   if pos('C',typeAlim) > 0 then Coeff := Valeur(sCoefficient);
   if pos('M',typeAlim) > 0 then Montant := Valeur(sMontant);

   T.PutValue ('PSD_BASE'        , Base);
   T.PutValue ('PSD_TAUX'        , Taux);
   T.PutValue ('PSD_COEFF'       , Coeff);
   T.PutValue ('PSD_MONTANT'     , Montant);
   T.PutValue ('PSD_DATEINTEGRAT', 0);
   T.PutValue ('PSD_DATECOMPT'   , 0);
   T.PutValue ('PSD_AREPORTER'   , '') ;
   T.Putvalue ('PSD_CONFIDENTIEL',sal.getvalue('PSA_CONFIDENTIEL'));

end;
//   PT2 09/10/01 PH Rajout traitement ligne Analytique Salarie/rubrique
procedure TOF_PGIMPORTFIC.ControleEnregANA(TypeEnr,chaine,S:string;Ecrit:boolean);
var
Codesalarie,DateDebutperiode,DateFinperiode,SNoOrdre  : string;
Rubrique, Axe, Section, CodeAxe,sMontant,LibSect      : string;
TDateDeb,TDateFin                                     : tdatetime;
T                                                     : tob;
TopCloture                                            : integer;
begin
  libErreur   := false;
  libanomalie := false;
  if NOT GetParamSoc('SO_PGANALYTIQUE') then Erreur (chaine,'',101);
  // contr�le sur le salari�
  Codesalarie := readtokenPipe(S,Separateur);
  if CodeSalarie <> Salarieprec then
     begin
     ControleSalarie(TypeEnr,chaine,S,CodeSalarie);
     end;
  Salarieprec := Codesalarie;
  DateDebutperiode := readtokenPipe(S,Separateur);
  if not Isvaliddate(DatedebutPeriode) then
     Erreur (chaine,DatedebutPeriode,30);
  DateFinperiode   := readtokenPipe(S,Separateur);
  if not Isvaliddate(DateFinPeriode) then
     Erreur (chaine,DateFinPeriode,35);
  TDateDeb := 0; TDateFin := 0;
  if (Isvaliddate(DatedebutPeriode)) and (Isvaliddate(DatefinPeriode)) then
     begin
     TDateDeb := strtodate(DatedebutPeriode);
     TDateFin := strtodate(DatefinPeriode);
     end;
  if TDateFin < TDateDeb then
     Erreur(chaine,DateDebutPeriode + '//' +DateFinPeriode,40);
  Topcloture:= IsPeriodecloture (TDatedeb, TDateFin );
  if TopCloture = 1 then
     Erreur(Chaine,'',44);
  if TopCloture = 2 then
     Erreur(Chaine,'',47);
  if TopCloture = 3 then
     Erreur(Chaine,'',48);
  if (DateSortie > 10) and (DateSortie < TDateDeb) then
     Erreur(Chaine,'',46);

  Rubrique    := readtokenPipe(S,Separateur);
  RubPrec := Rubrique;
  If not ExisteRubrique(Rubrique) then Erreur(chaine,Rubrique,50);
  if Rubrique <> rubPrec then Erreur(Chaine, Rubrique,52);
  Axe     := readtokenPipe(S,Separateur);
  if (Axe < 'A1') OR (Axe > 'A5') then Erreur (chaine, Axe, 103);
  Section := readtokenPipe(S,Separateur);

  Smontant := readtokenPipe(S,Separateur);
  if sMontant = '' then
     Erreur(chaine,sMontant,90)
     else
     if not Isnumeric(sMontant) then Erreur(chaine,sMontant,90);
  SNoOrdre := readtokenPipe(S,Separateur);
  if SNoOrdre = '' then
     Erreur(chaine,SNoOrdre,102)
     else
     if not Isnumeric(SNoOrdre) then Erreur(chaine,SNoOrdre,102);

// PT16   28/08/2003 PH Cr�ation des sections en r�cup�rant le libell� de la section
  if S <> '' then LibSect := readtokenPipe(S,Separateur)
  else LibSect := '' ;
  if not ExisteSection (Axe,Section,LibSect) then Erreur (Chaine, Section, 100);
// Fin PT16

  if not Ecrit then exit;
  T := Tob.create('PAIEVENTIL',TOB_Paieventil,-1);
  if T = nil then exit;
  CodeAxe := Copy (Axe, 2,1);
  T.PutValue ('PAV_NATURE', 'PG'+CodeAxe);
  T.PutValue ('PAV_COMPTE', CodeSalarie+';'+Rubrique);
  T.PutValue ('PAV_DATEDEBUT', strtodate(DateDebutperiode));
  T.PutValue ('PAV_DATEFIN', strtodate(DateFinperiode));
  T.PutValue ('PAV_SECTION', Section);
  T.PutValue ('PAV_TAUXMONTANT', Valeur (sMontant));
  T.PutValue ('PAV_TAUXQTE1', 0);
  T.PutValue ('PAV_TAUXQTE2', 0);
  T.PutValue ('PAV_NUMEROVENTIL', StrToInt (SNoOrdre));
  T.PutValue ('PAV_SOCIETE', GetParamSoc('SO_SOCIETE'));
  T.PutValue ('PAV_MONTANT', 0);
  T.PutValue ('PAV_SOUSPLAN1', '');
  T.PutValue ('PAV_SOUSPLAN2', '');
  T.PutValue ('PAV_SOUSPLAN3', '');
  T.PutValue ('PAV_SOUSPLAN4', '');
  T.PutValue ('PAV_SOUSPLAN5', '');
  T.PutValue ('PAV_SOUSPLAN6', '');

end;
{***********A.G.L.***********************************************
Auteur  ...... : PH
Cr�� le ...... : 13/03/2003
Modifi� le ... : 13/03/2003
Description .. : Traitement d'une ligne du fichier import qui remplacera les
Suite ........ : ventilations analytiques salari� qui sont dans la table
Suite ........ : VENTIL.
Suite ........ :
Suite ........ : Elles correspondent  aux pr�-ventilations analytiques.
Mots clefs ... :
*****************************************************************}
//PT13   13/03/2003 PH Traitement des lignes import pr�-ventilations analytiques salari�s
procedure TOF_PGIMPORTFIC.ControleEnregVEN (TypeEnr,chaine,S:string;Ecrit:boolean);
var
  Codesalarie,SNoOrdre,LibSect  : string;
  Axe, Section,CodeAxe,sMontant : string;
  T                             : tob;
begin
  libErreur   := false;
  libanomalie := false;
  if NOT GetParamSoc('SO_PGANALYTIQUE') then Erreur (chaine,'',101);
  // contr�le sur le salari�
  Codesalarie := readtokenPipe(S,Separateur);
  if CodeSalarie <> Salarieprec then  ControleSalarie (TypeEnr,chaine,S,CodeSalarie);
  Salarieprec := Codesalarie;
  Axe     := readtokenPipe(S,Separateur);
  if (Axe < 'A1') OR (Axe > 'A5') then Erreur (chaine, Axe, 103);
  Section := readtokenPipe(S,Separateur);
  Smontant := readtokenPipe(S,Separateur);
  if sMontant = '' then
     Erreur(chaine,sMontant,90)
     else
     if not Isnumeric(sMontant) then Erreur(chaine,sMontant,90);
  SNoOrdre := readtokenPipe(S,Separateur);
  if SNoOrdre = '' then
     Erreur(chaine,SNoOrdre,102)
     else
     if not Isnumeric(SNoOrdre) then Erreur(chaine,SNoOrdre,102);
// PT16   28/08/2003 PH Cr�ation des sections en r�cup�rant le libell� de la section
  if S <> '' then LibSect := readtokenPipe(S,Separateur)
  else LibSect := '' ;
  if not ExisteSection (Axe,Section,LibSect) then Erreur (Chaine, Section, 100);
// Fin PT16
  if not Ecrit then exit;
  T := Tob.create('VENTIL',TOB_Ventil,-1);
  if T = nil then exit;
  CodeAxe := Copy (Axe, 2,1);
  T.PutValue ('V_NATURE', 'SA'+CodeAxe);
  T.PutValue ('V_COMPTE', CodeSalarie);
  T.PutValue ('V_SECTION', Section);
  T.PutValue ('V_TAUXMONTANT', Valeur (sMontant));
  T.PutValue ('V_TAUXQTE1', 0);
  T.PutValue ('V_TAUXQTE2', 0);
  T.PutValue ('V_NUMEROVENTIL', StrToInt (SNoOrdre));
  T.PutValue ('V_SOCIETE', GetParamSoc('SO_SOCIETE'));
  T.PutValue ('V_MONTANT', 0);
  T.PutValue ('V_SOUSPLAN1', '');
  T.PutValue ('V_SOUSPLAN2', '');
  T.PutValue ('V_SOUSPLAN3', '');
  T.PutValue ('V_SOUSPLAN4', '');
  T.PutValue ('V_SOUSPLAN5', '');
  T.PutValue ('V_SOUSPLAN6', '');
end;

// Test existance section axe analytique
function  TOF_PGIMPORTFIC.ExisteSection(Axe,Section,LibSect :string):boolean;
var
T,T1 : tob;
ll   : Integer ;
begin
  result := false;
  If not PgImpnotVide(tob_section, true) then     exit;
  T := Tob_section.findfirst(['S_AXE','S_SECTION'],[Axe,Section],true);
  if T = nil then
  begin
// PT14   04/06/2003 PH Cr�ation automatique des sections analytiques lors de l'import si autoris�
    if GetParamSoc('SO_PGCREATIONSECTION') then
    begin
      T  := TOB.Create ('LES SECTIONS', NIL, -1);
// PT15   25/08/2003 PH Correction creation automatique des sections analytiques
      T1 := TOB.Create ('SECTION', T, -1);
      T1.PutValue ('S_SECTION', Section);
//PT16   28/08/2003 PH Cr�ation des sections en r�cup�rant le libell� de la section
      if LibSect <> '' then
      begin
        T1.PutValue ('S_LIBELLE', LibSect) ;
        ll := StrLen (PChar (LibSect)) ;
        if ll > 17 then ll := 17 ;
        if ll > 0 then T1.PutValue ('S_ABREGE', Copy (LibSect, 1, ll))
        else T1.PutValue ('S_ABREGE', 'Section paie ');
      end
      else
      begin
        T1.PutValue ('S_LIBELLE','Section paie '+Section) ;
        T1.PutValue ('S_ABREGE', 'Section paie ');
      end;
// FIN PT16
      T1.PutValue ('S_SENS', 'M');
      T1.PutValue ('S_SOLDEPROGRESSIF', 'X') ;
      T1.PutValue ('S_AXE',Axe);
      T.InsertDB (Nil,FALSE) ;
      T1.ChangeParent (Tob_section, -1) ;
      Tob_section.Detail.Sort('S_AXE;S_SECTION') ;
      FreeAndNil (T) ;
// PT15   25/08/2003 PH Creation section OK
      result := true;
    end;
// FIN PT14
  end
  else result := true;
end;

// FIN PT2
// Fonction de r�cup�ration d'un mvt de type Absence
procedure TOF_PGIMPORTFIC.ControleEnregMAB(chaine,S:string;Ecrit:boolean);
var
CodeSalarie,DateDebutAbs,DateFinAbs,st  : string;
TDateDeb,TDateFin,Dateclot              : tdatetime;
NbJ,NbH,MotifAbs,Libelle                : string;
Q                                       : tquery;
T,Sal                                   : tob;
Ordre, TopCloture                       : integer;
LibCompl1,LibCompl2,Dj,Fj               : String;
OkOk,SalSorti                           : Boolean;
begin
  libErreur   := false;
  libanomalie := false;
  // contr�le sur le salari�
  Codesalarie := readtokenPipe(S,Separateur);
  if CodeSalarie <> Salarieprec then
     begin
     ControleSalarie('MAB',Chaine,S,CodeSalarie);
     end;
  Salarieprec := Codesalarie;
  DateDebutAbs := readtokenPipe(S,Separateur);
  if not Isvaliddate(DateDebutAbs) then
     Erreur (chaine,DateDebutAbs,110);
  DateFinAbs   := readtokenPipe(S,Separateur);
  if not Isvaliddate(DateFinAbs) then
     Erreur (chaine,DateFinAbs,120);
  TDateDeb := 0; TDateFin := 0;
  if (Isvaliddate(DateDebutAbs)) and (Isvaliddate(DateFinAbs)) then
     begin
     TDateDeb := strtodate(DateDebutAbs);
     TDateFin := strtodate(DateFinAbs);
     end;
  if TDateFin < TDateDeb then
     Erreur(chaine,DateDebutAbs + '//' +DateFinAbs,130);
//  PT8 15/02/02 PH test pour les mvts de cp sur mois clos N et N+1
  Topcloture:= IsPeriodecloture (TDatedeb, TDateFin, 'X');
  if TopCloture = 1 then Erreur(Chaine,'',44)
  else
  if TopCloture = 2 then Erreur(Chaine,'',47)
  else
  if TopCloture = 3 then Erreur(Chaine,'',48);

  if (DateSortie > 10) and (DateSortie < TDateDeb) then Erreur(Chaine,'',46);
//  PT11-1 02/12/2002 PH Regroupement lecture du fichier pour controle existance absence avec
//  les bornes matin apr�s midi
  NbJ      := readtokenPipe(S,Separateur);
  if not isNumeric(Nbj) then
     if Nbj <> '' then Erreur(chaine, Nbj,150);

  NbH      := readtokenPipe(S,Separateur);
  if not isNumeric(NbH) then
     if ((NbH <> '') and (isNumeric(NbJ))) then
        Erreur(chaine, NbH,160);

  MotifAbs := readtokenPipe(S,Separateur);
  Libelle    := readtokenPipe(S,Separateur);
// PT1 14/06/01 PH Rajout r�cup libell� compl�mentaires
  LibCompl1  := readtokenPipe(S,Separateur);
  LibCompl2  := readtokenPipe(S,Separateur);
  Dj         := readtokenPipe(S,Separateur);
  Fj         := readtokenPipe(S,Separateur);
  if Dj = '' then Dj := 'MAT';
  if Fj = '' then Fj := 'PAM';
//  PT11 02/12/2002 PH Modification de la requete pour prendre en compte les demi journ�es
  st := 'SELECT PCN_DATEDEBUTABS,PCN_DATEFINABS,PCN_TYPECONGE,PCN_TYPEMVT FROM ABSENCESALARIE '+
        ' WHERE PCN_SALARIE = "'+CodeSalarie+'" AND PCN_DEBUTDJ="'+DJ+'" AND PCN_FINDJ="'+FJ+'"'+
        ' AND (PCN_TYPECONGE = "PRI" OR '+
        ' (PCN_TYPEMVT = "ABS" AND PCN_SENSABS="-"))'+
        ' AND ((PCN_DATEDEBUTABS >="'+usdatetime(TDateDeb)+'" AND PCN_DATEDEBUTABS <= "'+
        usdatetime(TDateFin)+'")'+
        'OR (PCN_DATEFINABS >="'+usdatetime(TDateDeb)+'" AND PCN_DATEDEBUTABS <= "'+
        usdatetime(TDateFin)+'")' +
       'OR (PCN_DATEFINABS >="'+usdatetime(TDateFin)+'" AND PCN_DATEDEBUTABS <= "'+
        usdatetime(TDateDeb)+'")'+
        'OR(PCN_DATEFINABS <="'+usdatetime(TDateFin)+'" AND PCN_DATEDEBUTABS >= "'+
        usdatetime(TDateDeb)+'"))';
// FIN PT11-1
  OkOk := TRUE;
  SalSorti := FALSE;
  Q := opensql(st, True);
  if not Q.eof then
   begin // Absence d�j� existante
   Sal := Tob_Sal.findfirst(['PSA_SALARIE'],[CodeSalarie],true);
//  PT11-2 02/12/2002 PH si les absences sont d�j� saisies et que le salari� est sorti alors OK
   if Sal = nil then OkOk := FALSE
    else
    begin
    if ((Sal.GetValue('PSA_DATESORTIE')) <> NULL) OR (Sal.GetValue('PSA_DATESORTIE') > Idate1900)
     then SalSorti := TRUE ELSE OkOk := FALSE;
    end;
   if NOT OkOk then Erreur(chaine,'',140);
// FIN PT11-2
   end;
  ferme(Q);

  Q := opensql('SELECT PMA_MOTIFABSENCE FROM MOTIFABSENCE WHERE ##PMA_PREDEFINI## PMA_MOTIFABSENCE ="'
           +Motifabs+'"',true);
  if Q.eof then Erreur(Chaine, MotifAbs,170);
  ferme(Q);

  if not Ecrit then exit;
//  PT11-2 02/12/2002 PH si les absences sont d�j� saisies et que le salari� est sorti alors OK
  if OkOk  AND SalSorti then exit; // On ne traite pas la ligne du fichier d'import

  Sal := Tob_Sal.findfirst(['PSA_SALARIE'],[CodeSalarie],true);
  if Sal = nil then exit;
// PT6 27/11/01 PH Si on ne g�re pas les cp et que l'on a des lignes de cp,on perd les lignes
  if (Sal.getvalue('ETB_CONGESPAYES') <> 'X') and (MotifAbs = 'PRI') then
     begin
     Erreur(chaine,CodeSalarie,27);
     exit;
     end;
  T := Tob.create('ABSENCESALARIE',TOB_ABS,-1);
  if T = nil then exit;

//  Ordre := IncrementeSeqNoOrdre('CPA',codeSalarie);
//   PT4 26/11/01 PH Incrementation du num�ro d'ordre des mvts de type CP
  if MotifAbs='PRI' then Ordre := RendNumOrdre ('CPA',CodeSalarie)
   else Ordre := RendNumOrdre ('ABS',CodeSalarie);
  ImportInitialiseTobAbsenceSalarie(T);
  T.PutValue('PCN_SALARIE'      ,Codesalarie);
  if MotifAbs='PRI' then
  T.PutValue('PCN_TYPEMVT'      ,'CPA')
  else  T.PutValue('PCN_TYPEMVT'      ,'ABS');
  T.PutValue('PCN_ORDRE'        ,Ordre);
  T.PutValue('PCN_CODERGRPT'    ,Ordre);
  T.PutValue('PCN_DATEDEBUT'    ,TDateDeb);
  if MotifAbs <> 'PRI' then T.PutValue('PCN_DATEFIN'      ,TDateFin)
   else T.PutValue('PCN_DATEFIN', 2); // On force la date de fin pourf les CP � idate1900
  T.PutValue('PCN_DATEDEBUTABS' ,TDateDeb);
  T.PutValue('PCN_DATEFINABS'   ,TDateFin);
  T.PutValue('PCN_TYPECONGE'    ,MotifAbs);
  if MotifAbs = 'PRI' then
     T.PutValue('PCN_MVTPRIS'   ,MotifAbs);
  T.PutValue('PCN_SENSABS'      ,'-');
// PT3 26/11/01 PH R�cup�ration du libell� saisi de l'absence
//  T.PutValue('PCN_LIBELLE'      ,'Mvt d''import');
  T.PutValue('PCN_LIBELLE'      ,Copy(Libelle,1,35)); //PT10
// PT1 14/06/01 PH Rajout r�cup libell� compl�mentaires et matin/AP
  T.PutValue('PCN_LIBCOMPL1'      ,LibCompl1);
  T.PutValue('PCN_LIBCOMPL2'      ,LibCompl2);
  T.PutValue('PCN_DEBUTDJ'        ,Dj);
  T.PutValue('PCN_FINDJ'          ,Fj);

  T.PutValue('PCN_DATEMODIF'    ,Date );
  T.PutValue('PCN_DATEVALIDITE' ,TDateFin);
  Dateclot                       := Sal.getvalue('ETB_DATECLOTURECPN');
  T.PutValue('PCN_PERIODECP'    , ImportCalculPeriode(Dateclot,TDatefin));
  if Nbj = '' then NBj := '0';
//   PT7 18/12/01 PH remplacement strtofloaat par valeur sinon erreur de conversion
  T.PutValue('PCN_JOURS'        ,VALEUR(Nbj));
  if NbH = '' then NBH := '0';
  T.PutValue('PCN_HEURES'       ,VALEUR(NbH));
//   PT5 27/11/01 PH Initialisation de tous les champs de la table absencesalarie
  T.PutValue('PCN_SAISIEDEPORTEE','X');
  T.PutValue('PCN_VALIDRESP','VAL');
  T.PutValue('PCN_VALIDSALARIE','SAL');   //PT9
  T.PutValue('PCN_EXPORTOK','X');

  T.PutValue('PCN_ETABLISSEMENT',Sal.getvalue('PSA_ETABLISSEMENT'));
  T.Putvalue('PCN_TRAVAILN1'    ,Sal.getvalue('PSA_TRAVAILN1'));
  T.Putvalue('PCN_TRAVAILN2'    ,Sal.getvalue('PSA_TRAVAILN2'));
  T.Putvalue('PCN_TRAVAILN3'    ,Sal.getvalue('PSA_TRAVAILN3'));
  T.Putvalue('PCN_TRAVAILN4'    ,Sal.getvalue('PSA_TRAVAILN4'));
  T.Putvalue('PCN_CODESTAT'     ,Sal.getvalue('PSA_CODESTAT'));
  T.Putvalue('PCN_CONFIDENTIEL' ,Sal.getvalue('PSA_CONFIDENTIEL'));

end;

procedure TOF_PGIMPORTFIC.Erreur(Chaine,S:string;NoErreur:integer);
var
st : string;
begin
 ExisteErreur  := true;
 if not liberreur then
{       RapportErreur.lines.Add('Erreur sur l''enregistrement ||   '+ chaine);}
   begin
   Writeln(FR,'');
   Writeln(FR,'Erreur sur l''enregistrement ||   '+ chaine);
   taille := taille +2;
   end;
 Liberreur := true;
 case  NoErreur of
   5        :  st := 'Marque de d�but de fichier non trouv�e';
   7        :  st := 'Impossible de r�cup�rer l''exercice social en cours - rejet du fichier';
   10       :  st := 'Des enregistrements ont �t� d�tect�s apr�s la marque de fin de fichier';
   15       :  st := 'Marque de fin de fichier non trouv�e';
   20       :  st := 'Code Enregistrement inexistant';
   25       :  st := 'Code salari� inexistant dans ce dossier';
   26       :  st := 'Salarie en suspension de paye';
   27       :  st := 'L''�tablissement auquel appartient le salari� ne g�re pas les CP alors que des CP pris sont trouv�s';
   30       :  st := 'Date d�but de p�riode non valide';
   35       :  st := 'Date fin de p�riode non valide';
   40       :  st := 'la date fin de p�riode est ant�rieure � la date d�but de p�riode';
   44       :  st := 'Il n''y a pas d''exercice social actif correspondant � ces dates';
   45       :  st := 'Num�ro d''ordre obligatoire';
   46       :  st := 'Attention, salari� sorti';
   47       :  st := 'Le mois de la date d�but est une p�riode clotur�e';
   48       :  st := 'Le mois de la date fin est une p�riode clotur�e';
   50       :  st := 'Rubrique inexistante';
   52       :  st := 'La rubrique d''une ligne de commentaire doit �tre pr�c�d�e d''un enregistrement faisant r�f�rence � cette m�me rubrique';
   53       :  st := 'La rubrique d''une ligne analytique doit �tre pr�c�d�e d''un enregistrement faisant r�f�rence � cette m�me rubrique';
   55       :  st := 'Type alimentation obligatoire';
   57       :  st := 'L''alimentation de la rubrique est diff�rente de celui du plan de paie';
   60       :  st := 'La base doit �tre renseign�e et �tre num�rique';
   65       :  st := 'La base ne doit pas �tre renseign�e';
   70       :  st := 'Le taux doit �tre renseign� et �tre num�rique';
   75       :  st := 'Le taux ne doit pas �tre renseign�';
   80       :  st := 'Le coefficient doit �tre renseign� et �tre num�rique';
   85       :  st := 'Le coefficient ne doit pas �tre renseign�';
   90       :  st := 'Le montant doit �tre renseign� et �tre num�rique';
   95       :  st := 'Le montant ne doit pas �tre renseign�';
   100      :  st := 'Section analytique inconnue';
   101      :  st := 'Il y a des lignes analytiques alors que vous ne gerez pas l''analytique';
   102      :  st := 'Le num�ro de ventilation analytique doit �tre renseign� et �tre num�rique';
   110      :  st := 'Date d�but absence non valide';
   120      :  st := 'Date fin absence non valide';
   130      :  st := 'La date d�but doit �tre ant�rieure � la date de fin';
   140      :  st := 'il existe d�j� une absence pour ce salari� � cette p�riode';
   150      :  st := 'Nombre de jours non num�rique';
   160      :  st := 'Nombre d''heures non num�rique';
   170      :  st := 'Code motif inexistant dans la table';
   220      :  st := 'Code enregistrement de la ligne Dossier-soci�t� erron�';
   230      :  st := 'Le num�ro de dossier est erron�';
   240      :  st := 'Erreur de structure de l''enregistrement';
    else    st := 'une erreur a �t� d�tect�e dans votre fichier,veuillez le v�rifier'
   end;
   Writeln(FR,st);
   taille := taille +1;
{   if RapportErreur <> nil then
      RapportErreur.lines.Add(St+' ||  '+S);}
end;

procedure TOF_PGIMPORTFIC.Anomalie(Chaine,S:string;NoErreur:integer);
var
st : string;
begin
 if not libanomalie then
   begin
   if Noerreur <> 98 then
      Writeln(FR,'Erreur non bloquante sur l''enregistrement ||   '+ chaine);
   end;
 Libanomalie := true;
 case  NoErreur of
   26       :  st := 'Salarie en suspension de paye';
   98       :  st := S;
    else    st := 'une erreur a �t� d�tect�e dans votre fichier,veuillez le v�rifier'
   end;
   Writeln(FR,st);
   taille := taille +1;
end;

procedure TOF_PGIMPORTFIC.SepChange(Sender : TObject);
begin
// PT18   10/09/2003 PH Controle du s�parateur du fichier import et creation automatique fichier rapport
   if Sep <> nil then
   if (Sep.value = 'TAB') OR (Copy (Sep.Value,1,3)='Tab') then Separateur := #9
   else if (Sep.value = 'PIP') OR (Copy (Sep.Value,1,3)='Pip')then Separateur := '|'
   else if (Sep.value = 'PVI') OR (Copy (Sep.Value,1,3)='Poi')then Separateur := ';';
end;
function  TOF_PGIMPORTFIC.ExisteRubrique(Rubrique:string):boolean;
var
T :tob;
begin
  result := false;
  If not PgImpnotVide(tob_rubrique, true) then     exit;

   T := Tob_rubrique.findfirst(['PRM_RUBRIQUE','PRM_PREDEFINI'],[rubrique,'DOS'],true);
   if T = nil then
      T := Tob_rubrique.findfirst(['PRM_RUBRIQUE','PRM_PREDEFINI'],[rubrique,'STD'],true);
      if T = nil then
         T := Tob_rubrique.findfirst(['PRM_RUBRIQUE','PRM_PREDEFINI'],[rubrique,'CEG'],true);
  if T = nil then exit;
  TypeBase    := T.getvalue('PRM_TYPEBASE');
  TypeTaux    := T.getvalue('PRM_TYPETAUX');
  TypeCoeff   := T.getvalue('PRM_TYPECOEFF');
  TypeMontant := T.getvalue('PRM_TYPEMONTANT');
  result := true;
end;
procedure TOF_PGIMPORTFIC.FicChange(Sender : TObject);
var LeFic, St   : String ;
    F           : TextFile ;
begin
// PT18   10/09/2003 PH Controle du s�parateur du fichier import et creation automatique fichier rapport
  if Not Assigned ( Sender) then exit ;
  LeFic := THEdit ( Sender).Text ;
  if LeFic = '' then exit ;
  if THEdit (Sender).Name = 'FICRAPPORT' then
  begin
    if Not FileExists ( LeFic) then
    begin
      AssignFile ( F, LeFic) ;
{$i-} ReWrite(F); {$i+} If IoResult<>0 Then Begin PGIBox('Fichier inaccessible : '+LeFic,'Abandon du traitement');Exit ; End;
      closeFile ( F) ;
    end ;
  end
  else
  begin
    AssignFile ( F, LeFic) ;
    reset (F) ;
    ReadLn ( F, St );
    ReadLn ( F, St );
    if Sep <> NIL then
    begin
      if Pos (';', St) > 0 then  Sep.Value := 'PVI'
      else if Pos ('|', St) > 0 then  Sep.Value := 'PIP' ;
    end ;
    closeFile ( F) ;
  end ;
// FIN PT18
end;
procedure TOF_PGIMPORTFIC.ImprimeClick(Sender: TObject);
var
MPages:tpagecontrol;
begin
{$IFNDEF EAGLCLIENT}
 MPages := TPageControl(getcontrol('PAGECONTROL1'));
 if MPages <> nil then
 PrintPageDeGarde(MPages,TRUE,TRUE,FALSE,Ecran.Caption,0) ;
{$ENDIF}
end;

procedure TOF_PGIMPORTFIC.ControleSalarie(TypeEnr,chaine,S,CodeSalarie:string);
var
t : tob;
begin
  DateEntree  := 0; DateSortie := 0;
  if tob_sal = nil then
     Erreur (chaine,Codesalarie,25) else
     begin
       t := Tob_Sal.findfirst(['PSA_SALARIE'],[Codesalarie],true);
       if t = nil then Erreur (chaine,Codesalarie,25)
       else
       if (T.GetValue ('PSA_SUSPENSIONPAIE') = 'X') then Anomalie (chaine,Codesalarie,26);
     end;
end;
// La periode contenent ces dates est elle clotur�e ?
// result = 0 : non
//          1 : pas d'exercice social trouv�
//          2 : Mois date d�but clotur�
//          3 : Mois date de fin clotur�
//
//  PT8 15/02/02 PH test pour les mvts de cp sur mois clos N et N+1
function TOF_PGIMPORTFIC.IsPeriodecloture (Dated, DateF : TDateTime; CasCp : String = '-') : integer;
var  Q : TQuery;
     aa,mmd,mmf,jj : WORD;
     trouve      : boolean;
     Cloture : string;
     DebExer,FinExer:tdatetime;
     d,f :integer;
begin
trouve := false;
Q:=OpenSQL('SELECT * FROM EXERSOCIAL WHERE PEX_ACTIF="X" ORDER BY PEX_ANNEEREFER',TRUE) ;
While Not Q.EOF do
  begin
  DebExer := Q.FindField ('PEX_DATEDEBUT').AsDateTime;
  FinExer := Q.FindField ('PEX_DATEFIN').AsDateTime;
  if (debExer<=DateD) and (FinExer >= Datef) then
     begin trouve := true; break; end;
  Q.Next ;
end ;
Cloture := Q.FindField('PEX_CLOTURE').asstring;
Ferme (Q);
if not trouve then
   Begin
   result := 1;// pas d'exercice social actif correspondant � ces dates
   exit;
   end;

decodedate(Dated, aa,mmd,jj);
decodedate(dateF, aa,mmf,jj);
if GetParamSoc('SO_PGDECALAGE') = TRUE then
   begin
   if mmd = 12 then d := 1 else d:= mmd+1;
   if mmf = 12 then f := 1 else f:= mmf+1;
   end
   else
   begin
   d := mmd ; f := mmf ;
   end;
//  PT8 15/02/02 PH test pour les mvts de cp sur mois clos N et N+1
   if CasCp = 'X' then
      begin
      result := 0;
      if (Cloture[d] = 'X') then
         begin
         if d < 12 then
          begin
          if Cloture[d + 1] = 'X'  then result := 2;
          end else result := 2;
         end;
      if (result = 0) AND (Cloture[f] = 'X') then
         begin
         if f < 12 then
          begin
          if Cloture[f + 1] = 'X'  then result := 3;
          end else result := 3;
         end;
      end
      else
      begin
      if Cloture[d] = 'X' then result := 2
         else
         if Cloture [f] = 'X' then result := 3
         else
         result := 0;
      end;
//  FIN PT8
end;

function TOF_PGIMPORTFIC.RendNumOrdre (TypeMvt, CodeSalarie : String) : integer;
var Ordre    : Integer;
    T1       : TOB;
begin
T1 := Tob_OrdreAbs.findFirst (['PCN_SALARIE','PCN_TYPEMVT'],[CodeSalarie,TypeMvt],FALSE);
if T1 <> NIL then
         begin
         Ordre := T1.GetValue ('NUMORDRE')+ 1;
         T1.PutValue ('NUMORDRE',Ordre);
         end
         else
         begin
         Ordre := 1;
         T1 := TOB.Create ('LES NUMORDRES ABSENCESALARIE',Tob_OrdreAbs, -1);
         T1.AddChampSup ('PCN_SALARIE', FALSE);
         T1.AddChampSup ('PCN_TYPEMVT', FALSE);
         T1.AddChampSup ('NUMORDRE', FALSE);
         T1.PutValue ('PCN_SALARIE', CodeSalarie);
         T1.PutValue ('PCN_TYPEMVT', TypeMvt);
         T1.PutValue ('NUMORDRE', Ordre);
         end;
result := Ordre;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Dev Paie
Cr�� le ...... : 11/09/2003
Modifi� le ... :   /  /
Description .. : Le nom du fichier obligatoirement renseign� avec une
Suite ........ : extension tq .t (.txt,.trt,.ttt ....)
Suite ........ : Fichier existant obligatoirement
Suite ........ : Le Type d'import = 'AUTO' sinon consid�r� comme appli paie
Suite ........ : Le s�parateur est un Char := |
Suite ........ :
Suite ........ : Test si creation du fichier de rapport peut �tre cr�er mais
Suite ........ : il aura une extension en .log au lieu de .trt
Mots clefs ... : PAIE;GIGA
*****************************************************************}

Function TOF_PGIMPORTFIC.PgImportDef (LeNomduFichier, LeTypImp : String; LeSeparateur : Char = '|') : Boolean ;
begin
  result := FALSE ;
  if LeNomDuFichier = '' then exit ;
  if Not FileExists (LeNomduFichier) then exit ;
  if Pos ('.', LeNomduFichier) <= 0 then exit ;
  if LeTypImp <> 'AUTO' then exit ;
  if (LeSeparateur <> '|') then exit ;
  Separateur   := LeSeparateur ;
  NomDuFichier := LeNomDuFichier ;
  TypImport    := LeTypImp ;
  result       := TRUE ;
end;

function TOF_PGIMPORTFIC.ImportRendPeriodeEnCours (var ExerPerEncours,DebPer,FinPer : String) : Boolean;
var  Q : TQuery;
begin
result:=FALSE;
DebPer := DateToStr(idate1900);
FinPer := DateToStr(idate1900);
Q:=OpenSQL('SELECT * FROM EXERSOCIAL WHERE PEX_ACTIF="X" ORDER BY PEX_ANNEEREFER DESC',TRUE) ;
if Not Q.EOF then
  begin
  DebPer:=Q.FindField ('PEX_DEBUTPERIODE').AsString;
  FinPer:=Q.FindField ('PEX_FINPERIODE').AsString;
  ExerPerEncours:=Q.FindField ('PEX_EXERCICE').AsString;
  result:=TRUE;
//  PT1
  end ;
Ferme (Q);
end;

function TOF_PGIMPORTFIC.ImportRendExerSocialEnCours (var MoisE, AnneeE, ComboExer : String; var DebExer, FinExer : TDateTime) : Boolean;
var  Q : TQuery;
     DatF : TDateTime;
     Jour, Mois, Annee : WORD;
begin
result:=FALSE;
DebExer := idate1900;
FinExer := idate1900;
Q:=OpenSQL('SELECT * FROM EXERSOCIAL WHERE PEX_ACTIF="X" ORDER BY PEX_ANNEEREFER DESC',TRUE) ;
if Not Q.EOF then
  begin
  DatF := Q.FindField ('PEX_FINPERIODE').AsFloat;//Q.Fields[7].AsFloat; // Recup date de fin periode en cours
  DecodeDate (DatF, Annee, Mois, Jour);
  MoisE:=ImportColleZeroDevant (Mois, 2);
  ComboExer := Q.FindField ('PEX_EXERCICE').AsString;//Q.Fields[0].AsString; // recup Combo identifiant exercice
  AnneeE := Q.FindField ('PEX_ANNEEREFER').AsString;//Q.Fields[8].AsString; // recup Annee de exercice
  DebExer := Q.FindField ('PEX_DATEDEBUT').AsDateTime;
  FinExer := Q.FindField ('PEX_DATEFIN').AsDateTime;
  result:=TRUE;
// PT1
  end ;
Ferme (Q);
end;

function TOF_PGIMPORTFIC.ImportColleZeroDevant(Nombre , LongChaine : integer) : string ;
var
tabResult : string ;
TabInt : string;
i,j : integer;
begin
tabResult := '';
   for i := 1 to LongChaine do begin
      if Nombre < power(10,i) then
      begin
         TabInt := inttostr(Nombre);
        // colle (LongChaine-i z�ro devant]
         for j := 0 to  (LongChaine-i-1)
                      do insert('0',TabResult,j);
         result := concat(TabResult,Tabint);
         exit;
      end;
    if i > LongChaine then result := inttostr(Nombre);
   end;
end;


Initialization
registerclasses([TOF_PGIMPORTFIC]) ;

end.
