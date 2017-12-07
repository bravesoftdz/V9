{***********UNITE*************************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /
Description .. : Gestion de la saisie group�e des mouvements de pr�sence
Mots clefs ... : MOUVEMENT;PRESENCE;GROUPE;
*****************************************************************
PT1   06/07/2007  FLO  V_80  Limitation d'un �v�nement � la journ�e
PT2   09/08/2007  FLO  V_80  Recalcul automatique des compteurs lors d'une saisie group�e
PT3   30/10/2007  GGU  V_80  Gestion des absences en horaire
}
unit UTOFPGMVTGRP;

interface
uses Classes, Sysutils, Controls, AglInit,StdCtrls,
{$IFNDEF EAGLCLIENT}
  mul, FE_Main, {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF} UTOB,
{$ELSE}
  emul, MaineAgl, Utob,
{$ENDIF}
  Utof,HCtrls,HTB97,HEnt1,PGAnomaliesTraitement;

type
  TOF_PGMVTGRPMUL = class(TOF)
     procedure OnArgument(stArgument: string); override;
     procedure OnLoad ;                        override;
   private
     procedure ExitEditSalarie(Sender: TObject);
     procedure ClickBOuvrir(Sender: TObject);
     procedure OnClickSalarieSortie(Sender: TObject);
     procedure GrilleDblClick (Sender : TObject);
  end;

  TOF_PGMVTGRP = Class (TOF)
     procedure OnArgument (stArgument : String ) ;     override ;
     procedure OnUpdate ;                              override ;
     procedure OnClose;                                override ;
   private
     Grille         : THGrid;      // Grille de saisie
     TobMouvements  : TOB;         // Mouvements saisis
     TobMotifs      : TOB;         // Motifs de pr�sence
     ModeQuantite   : Boolean;     // Indique pour la ligne si la quantit� est saisissable
     TheMul         : TQuery;      // Multi-crit�res de la fen�tre parent
     Mvt            : String;      // Indique pour la ligne le mouvement actuellement saisi
     SaisieValide   : Boolean;     // Indique si la saisie d'une ligne est valide
     Anomalies      : TAnomalies;  // Liste des anomalies du traitement
     Updated        : Boolean;     // Indique si l'update a �t� lanc�e

     procedure MiseEnFormeGrille;
     procedure AfficheValeurDefaut (Row : integer; MouvementExcepte : Boolean = False);

     procedure GrilleCellEnter(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
     procedure GrilleCellExit (Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
     procedure GrilleRowEnter (Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
     procedure GrilleCellKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
     procedure GrilleCellKeyPress(Sender: TObject; var Key: Char);

     procedure GrilleInsereLigne( sender : TObject );
     procedure GrilleDeleteLigne( sender : TObject );
     procedure GrilleDblClick ( sender : TObject );
     procedure GrilleElipsisClick ( sender : TObject );

     procedure CreeMouvements;
   End;

  function ConvertPrefixe(StWhere, DePref, APref: string): string;

implementation
uses P5Def,PGOutils2,Entpaie,PgPresence,Vierge,ParamDat,Windows,HeureUtil,HMsgBox,HQry,Ed_Tools,DB,HDB;

{***********A.G.L.***********************************************
Auteur  ...... : 
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /    
Description .. : Chargement de la fiche
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGMVTGRPMUL.OnArgument(stArgument: string);
var
  ChampSal: THEdit;
  Num: integer;
  Btn: TToolBarButton97;
  Check : TCheckBox;
{$IFNDEF EAGLCLIENT}
  Liste: THDBGrid;
{$ELSE}
  Liste: THGrid;
{$ENDIF}
begin
  inherited;

     // Champs libres de l'onglet Compl�ments
     For Num := 1 To VH_Paie.PGNbreStatOrg Do
     Begin
          If Num > 4 Then Break;
          VisibiliteChampSalarie(IntToStr(Num), GetControl('PSA_TRAVAILN' + IntToStr(Num)), GetControl('TPSA_TRAVAILN' + IntToStr(Num)));
     End;
     VisibiliteStat(GetControl('PSA_CODESTAT'), GetControl('TPSA_CODESTAT'));

     // Compl�tion du num�ro de salari�
     ChampSal := THEdit(GetControl('PSA_SALARIE'));
     if ChampSal <> nil then ChampSal.OnExit := ExitEditSalarie;
     ChampSal := THEdit(GetControl('PSA_SALARIE_'));
     if ChampSal <> nil then ChampSal.OnExit := ExitEditSalarie;

     // Bouton Ouvrir
     Btn := TToolBarButton97(GetControl('BOuvrir'));
     If Btn <> Nil Then Btn.Onclick := ClickBOuvrir;

     // Check-box de sortie
     Check:=TCheckBox(GetControl('CKSORTIE'));
     If Check <> Nil Then Check.OnClick := OnClickSalarieSortie;

     // Double-clic dans la grille
     {$IFNDEF EAGLCLIENT}
          Liste := THDBGrid(GetControl('FListe'));
     {$ELSE}
          Liste := THGrid(GetControl('FListe'));
     {$ENDIF}
     If Liste <> Nil Then Liste.OnDblClick := GrilleDblClick;
end;


{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /    
Description .. : Compl�te le num�ro de salari� avec des 0
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGMVTGRPMUL.ExitEditSalarie(Sender: TObject);
var
  Edit: thedit;
begin
  Edit := THEdit(Sender);

  If Edit <> nil then
    If (VH_Paie.PgTypeNumSal = 'NUM') And (length(Edit.Text) < 11) And (IsNumeric(Edit.Text)) Then
      Edit.Text := AffectDefautCode(Edit, 10);
end;


{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /
Description .. : Click sur le bouton Ouvrir
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGMVTGRPMUL.ClickBOuvrir(Sender: TObject);
var
  Salarie, st : string;
  i: integer;
  Q_Mul: THQuery;
begin
     Q_Mul := THQuery(Ecran.FindComponent('Q'));
     if Q_Mul = nil then exit;

     { Gestion de la s�lection de salari� }
     If (TFMul(Ecran).FListe.nbSelected > 0) or (TFMul(Ecran).FListe.AllSelected) then
     Begin
          If PgiAsk(TraduireMemoire('Voulez-vous g�n�rer des mouvements pour les salari�s s�lectionn�s?'), TraduireMemoire('Saisie group�e de mouvements de pr�sence')) = mrYes Then
          Begin
               St := '';

               { Composition du clause WHERE pour limiter le mul � ces salari�s }
               if (TFmul(Ecran).Fliste.AllSelected = True) then
               begin
                    // Si tout est s�lectionn�
                    TFmul(Ecran).Q.First;
                    while not TFmul(Ecran).Q.EOF do
                    begin
                         Salarie := TFmul(Ecran).Q.FindField('PSA_SALARIE').asString;
                         St := St + ' PSA_SALARIE="' + Salarie + '" OR';
                         TFmul(Ecran).Q.Next;
                    end;
               end
               else
               Begin
                    // Seuls certains salari�s ont �t� s�lectionn�s
                    for i := 0 to TFMul(Ecran).FListe.NbSelected - 1 do
                    begin
                         {$IFDEF EAGLCLIENT}
                              TFMul(Ecran).Q.TQ.Seek(TFMul(Ecran).FListe.Row - 1);
                         {$ENDIF}
                         TFMul(Ecran).FListe.GotoLeBookmark(i);

                         Salarie := TFmul(Ecran).Q.FindField('PSA_SALARIE').AsString;
                         St := St + ' PSA_SALARIE="' + Salarie + '" OR';
                    end;
               End;

               TFMul(Ecran).FListe.ClearSelected;
               
               if St <> '' then St := ' AND (' + Copy(St, 1, Length(st) - 2) + ')';
               SetControlText('XX_WHERE', GetControlText('XX_WHERE') + St);
               TFMul(Ecran).BCherche.Click;

               { R�cup�ration de la Query pour traitement dans la fiche vierge }
               {$IFDEF EAGLCLIENT}
                    if TFMul(Ecran).Fetchlestous then TheMulQ := TOB(Ecran.FindComponent('Q'));
               {$ELSE}
                    TheMulQ := THQuery(Ecran.FindComponent('Q'));
               {$ENDIF}

               { Ouverture de la fiche }
               AglLanceFiche('PAY', 'MVTPRESGRP', '', '', '');

               SetControlText('XX_WHERE', '');
               TheMulQ := nil;
               TFMul(Ecran).BCherche.Click;
          End;
     End
     Else
     Begin
          PGIBox(TraduireMemoire('Aucun salari� n''est s�lectionn�.'), TraduireMemoire('Saisie group�e de mouvements de pr�sence'));
     End;
End;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : FLO
Cr�� le ...... : 01/08/2007
Modifi� le ... :   /  /
Description .. : Double-clic dans la grille
Mots clefs ... :
*****************************************************************}
Procedure TOF_PGMVTGRPMUL.GrilleDblClick(Sender: TObject);
var
  st : string;
  Q_Mul: THQuery;
begin
     Q_Mul := THQuery(Ecran.FindComponent('Q'));
     if Q_Mul = nil then exit;

     { Composition du clause WHERE pour limiter le mul � ces salari�s }
     {$IFDEF EAGLCLIENT}
          TFmul(Ecran).Q.TQ.Seek(TFMul(Ecran).FListe.Row-1) ;
     {$ENDIF}
     Q_Mul := THQuery(Ecran.FindComponent('Q')) ;

     St := ' AND PSA_SALARIE="' + Q_Mul.FindField('PSA_SALARIE').AsString + '"';

     SetControlText('XX_WHERE', GetControlText('XX_WHERE') + St);
     TFMul(Ecran).BCherche.Click;

     { R�cup�ration de la Query pour traitement dans la fiche vierge }
     {$IFDEF EAGLCLIENT}
          if TFMul(Ecran).Fetchlestous then TheMulQ := TOB(Ecran.FindComponent('Q'));
     {$ELSE}
          TheMulQ := THQuery(Ecran.FindComponent('Q'));
     {$ENDIF}

     { Ouverture de la fiche }
     AglLanceFiche('PAY', 'MVTPRESGRP', '', '', '');

     SetControlText('XX_WHERE', '');
     TheMulQ := nil;
     TFMul(Ecran).BCherche.Click;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /    
Description .. : Gestion de la check box de sortie des salari�s
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGMVTGRPMUL.OnClickSalarieSortie(Sender: TObject);
begin
     SetControlenabled('DATEARRET', (GetControltext('CKSORTIE')='X'));
     SetControlenabled('TDATEARRET',(GetControltext('CKSORTIE')='X'));
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /
Description .. : Chargement des donn�es
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGMVTGRPMUL.OnLoad;
var
  DateArret : TDateTime;
  St        : String;
begin
     if  TCheckBox(GetControl('CKSORTIE')) <> nil then
     Begin
          if (GetControlText('CKSORTIE')='X') and (IsValidDate(GetControlText('DATEARRET')))then
          Begin
               DateArret := StrtoDate(GetControlText('DATEARRET'));
               St := ' AND (PSA_DATESORTIE>="'+UsDateTime(DateArret)+'"'+
                     ' OR PSA_DATESORTIE="'+UsdateTime(Idate1900)+'"'+
                     ' OR PSA_DATESORTIE IS NULL)'+
                     ' AND PSA_DATEENTREE <="'+UsDateTime(DateArret)+'" ';
               SetControlText('XX_WHERE',GetControlText('XX_WHERE') + St);
          End;
     End;
end;


{ ----------------------------------------------------------------------------------- }

{ TOF_PGMVTGRP }

{ ----------------------------------------------------------------------------------- }

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /    
Description .. : Ouverture de la fiche
Mots clefs ... :
*****************************************************************}
procedure TOF_PGMVTGRP.OnArgument(stArgument: String);
var
  Btn     : TToolBarButton97;
begin
  Inherited ;

     ModeQuantite := False;
     SaisieValide := True;
     Updated      := False;
     Mvt          := '';

     Grille := THGrid(GetControl('GRILLE')) ;
     if Grille<>Nil then
     begin
          MiseEnFormeGrille;

          Grille.OnElipsisClick := GrilleElipsisClick;
          Grille.OnKeyDown      := GrilleCellKeyDown;
          Grille.OnKeyPress     := GrilleCellKeyPress;
          Grille.OnDblClick     := GrilleDblClick;
          Grille.OnRowEnter     := GrilleRowEnter;
          Grille.OnCellEnter    := GrilleCellEnter;
          Grille.OnCellExit     := GrilleCellExit;

          Btn := TToolBarButton97(GetControl('BINS_LINE'));
          if btn<>nil then btn.OnClick := GrilleInsereLigne;
          
          Btn := TToolBarButton97(GetControl('BDEL_LINE'));
          if btn<>nil then btn.OnClick := GrilleDeleteLigne;
     End;

     if TFVierge(Ecran) <> nil then
     begin
          {$IFDEF EAGLCLIENT}
               TheMul := THQuery(TFVierge(Ecran).FMULQ).TQ;
          {$ELSE}
               TheMul := TFVierge(Ecran).FMULQ;
          {$ENDIF}
     end;

     // Chargement des motifs de pr�sence et de leur type de saisie associ�e : jour ou heure
     TobMotifs := TOB.Create('LesMotifs', Nil, -1);
     TobMotifs.LoadDetailFromSQL('SELECT * FROM MOTIFABSENCE WHERE ##PMA_PREDEFINI## AND PMA_TYPEMOTIF = "PRE"');

     Anomalies := TAnomalies.Create;
     Anomalies.ChangeLibAno(WARN1, TraduireMemoire('Incoh�rence de dates'));
     Anomalies.ChangeLibAno(WARN2, TraduireMemoire('Restrictions'));
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /    
Description .. : Mise � jour des donn�s
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGMVTGRP.OnUpdate;
Var
i              : Integer;
SaisieComplete : Boolean;
begin
     SaisieComplete := True;

     // V�rification que tous les champs soient renseign�s
     For i := 1 to Grille.RowCount-1 Do
     Begin
          if Not ( (Grille.cells[0,i] <> '')                                              // mouvement
               And (IsValidDate(Grille.Cells[1,i])) And (IsValidDate(Grille.cells[3,i]))  // dates
               And (Grille.Cells[1,i] <> StDate1900) And (Grille.Cells[3,i] <> StDate1900)
               And (Grille.Cells[2,i] <> '') And (Grille.cells[4,i] <> '')                // heures de d�but et de fin
               And (Grille.Cells[5,i] <> '') And (Grille.Cells[6,i] <> '')                // nombre d'heures
               And (Grille.cells[7,i] <> '')) Then                                        // libell�
          Begin
               SaisieComplete := False;
               Break;
          End;
     End;

     if (SaisieComplete) And (SaisieValide) Then
     begin
          If (Grille.RowCount > 1) Then
          Begin
               If Not Assigned(TobMouvements) Then TobMouvements := TOB.Create ('LesMouvements', Nil, -1);
               TobMouvements.GetGridDetail(Grille, -1,'', 'MOUVEMENT;DATEDU;HEUREDEBUT;DATEFIN;HEUREFIN;NBHEURES;NBHEURESNUIT;QUANTITE;LIBELLE');

               // Cr�ation des mouvements correspondant
               CreeMouvements;
          End;
     End
     Else PGIError(TraduireMemoire('La saisie n''est pas valide.'));
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /    
Description .. : Fermeture de l'�cran
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGMVTGRP.OnClose;
begin
     // Lib�ration de la TOB de donn�es
     if (Mvt <> '') And (Not Updated) Then
     Begin
          If PgiAsk(TraduireMemoire('Etes-vous s�r de vouloir abandonner la saisie?')) = mrNo Then
          Begin
               LastErrorMsg :='' ;
               LastError := 1;
               Exit;
          End;
     End;

     If Assigned(TobMouvements) Then FreeAndNil(TobMouvements);
     If Assigned(TobMotifs)     Then FreeAndNil(TobMotifs);
     Anomalies.Free;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /    
Description .. : Mise en forme des colonnes de la grille
Mots clefs ... :
*****************************************************************}
procedure TOF_PGMVTGRP.MiseEnFormeGrille;
begin
     // Mouvement
     Grille.ColFormats [0]  := 'CB=PGMOTIFPRESENCE';

     // Date d�but
     Grille.ColTypes   [1]  := 'D';
     Grille.ColFormats [1]  := ShortDateFormat;
     Grille.ColAligns  [1]  := taCenter ;

     // Heure d�but
     Grille.ColTypes   [2]  := 'H';
   //  Grille.ColFormats [2]  := shortTimeFormat;
     Grille.ColFormats [2]  := 'hh:nn';
     Grille.ColAligns  [2]  := taCenter ;
     Grille.ColLengths [2]  := 5;

     // Date fin
     Grille.ColEditables[3] := False; //PT1
     Grille.ColTypes   [3]  := 'D';
     Grille.ColFormats [3]  := ShortDateFormat;
     Grille.ColAligns  [3]  := taCenter ;

     // Heure fin
     Grille.ColTypes   [4]  := 'H';
   //  Grille.ColFormats [4]  := shortTimeFormat;
     Grille.ColFormats [4]  := 'hh:nn';
     Grille.ColAligns  [4]  := taCenter ;
     Grille.ColLengths [4]  := 5;

     // Nb Heures
     Grille.ColEditables[5] := False;
     Grille.ColTypes   [5]  := 'R';
     Grille.ColAligns  [5]  := taRightJustify ;
     Grille.ColLengths [5]  := 6;

     // Nb Heures nuit
     Grille.ColTypes   [6]  := 'R';
     Grille.ColAligns  [6]  := taRightJustify ;
     Grille.ColLengths [6]  := 6;

     // Quantit�
     Grille.ColTypes   [7]  := 'R';
     Grille.ColAligns  [7]  := taRightJustify ;
     Grille.ColLengths [7]  := 6;

     // Libell�
     Grille.ColTypes   [8]  := 'C';
     Grille.ColAligns  [8]  := taLeftJustify ;

     AfficheValeurDefaut(1);
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 26/07/2007
Modifi� le ... :   /  /    
Description .. : Initialise les valeurs d'une ligne de la grille
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGMVTGRP.AfficheValeurDefaut(Row: Integer;  MouvementExcepte : Boolean = False);
begin
     If Not MouvementExcepte Then Grille.CellValues [0,Row] := '';
     Grille.CellValues [1,Row] := StDate1900;
     Grille.CellValues [2,Row] := '00:00';
     Grille.CellValues [3,Row] := StDate1900;
     Grille.CellValues [4,Row] := '00:00';
     Grille.CellValues [5,Row] := '0';
     Grille.CellValues [6,Row] := '0';
     Grille.CellValues [7,Row] := '0';
     Grille.CellValues [8,Row] := '';
     Updated := False;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /    
Description .. : Suppression d'une ligne de la grille
Mots clefs ... :
*****************************************************************}
procedure TOF_PGMVTGRP.GrilleDeleteLigne(Sender: TObject);
var
     bretour : boolean;
begin
     if Grille.RowCount > 2 Then
     Begin
          Grille.CacheEdit;
          Grille.SynEnabled := False;
          Grille.DeleteRow(Grille.Row);
          Grille.MontreEdit;
          Grille.SynEnabled := True;
//          Mvt := Grille.CellValues[0, Grille.Row];       //PT1
          GrilleRowEnter(Nil, Grille.Row, bretour, False); //PT1
          Updated := False;
     End;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /    
Description .. : Insertion d'une nouvelle ligne dans la grille
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGMVTGRP.GrilleInsereLigne(Sender: TObject);
Var Ligne, Colonne : Integer;
    Cancel         : Boolean;
begin
     Ligne   := Grille.Row;
     Colonne := Grille.Col;

     // Positionnement sur la premi�re colonne
     Grille.Col := 0;
     Grille.ElipsisButton:=False;
     Grille.ValCombo.Visible := True;

     // Invoque la sortie de la cellule (non automatique)
     GrilleCellExit(Nil, Colonne , Ligne , Cancel);
     If SaisieValide = False Then Exit;

     // Insertion de la ligne
     Grille.CacheEdit;
     Grille.SynEnabled := False;
     Grille.InsertRow(Grille.Row);
     Grille.Row := Ligne;
     Grille.MontreEdit;
     Grille.SynEnabled := True;

     // Valeurs par d�faut de la ligne
     AfficheValeurDefaut (Ligne);
     Updated := False;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 26/07/2007
Modifi� le ... :   /  /
Description .. : Focus sur une ligne
Mots clefs ... :
*****************************************************************}
procedure TOF_PGMVTGRP.GrilleRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
var
T : TOB;
begin
     // Sauvegarde du mouvement courant
     Mvt := Grille.CellValues[0,Ou];

     // En fonction du mouvement, il faut afficher ou non la quantit� et cacher ou non les nombres d'heures
     T := TobMotifs.FindFirst(['PMA_MOTIFABSENCE'], [Grille.CellValues[0,Ou]], False);
     If T <> Nil Then ModeQuantite := Not ((T.GetValue('PMA_JOURHEURE') = 'HEU') or (T.GetValue('PMA_JOURHEURE') = 'HOR')); //PT3
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /
Description .. : Focus sur une colonne
Mots clefs ... :
*****************************************************************}
procedure TOF_PGMVTGRP.GrilleCellEnter(Sender: TObject; var ACol,ARow: Integer; var Cancel: Boolean);
begin
     //Affichage de l'elipsis
     If (Grille.col=1)  then //PT1
     Begin
          Grille.ElipsisButton:=True;
          Grille.ValCombo.Hide;
     end
     else
          Grille.ElipsisButton:=False;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /
Description .. : Gestion de la touche d'espacement simulant le clic sur l'elipsis
Suite ........ : et gestion des tabulations pour les nb heures / quantit�
Mots clefs ... :
*****************************************************************}
procedure TOF_PGMVTGRP.GrilleCellKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
Var K : Char;
begin
     // Dates
     If (Grille.col=1) {or (Grille.col=3)} then //PT1
     Case Key of
       VK_SPACE :
          Begin
               K :='*';
               ParamDate (Ecran, Sender, K);
          End ;
     End;
     // Tabulations : Si mode quantit�, il faut sauter les heures et vice versa
     If (Shift = []) And (Key = VK_TAB) Then
     Begin
          Case Grille.Col Of
            // On est sur le champ Date d�but -> Quantit�
            1: Begin
                    If ModeQuantite Then
                         Grille.Col := 6;  // + la tabulation, �a fera colonne 7 //PT1
               End;
            // On est sur le champ Heure d�but -> Heure fin
            2: Begin  //PT1
                    If Not ModeQuantite Then
                         Grille.Col := 3  // + la tabulation, �a fera colonne 4
                    Else
                         Grille.Col := 6;
               End;
            // On est sur le champ Date de fin
            3: Begin
                    If ModeQuantite Then
                         Grille.Col := 6;  // + la tabulation, �a fera colonne 7
               End;
            // On est sur le champ Heure de fin
            4: Begin
                    If ModeQuantite Then
                         Grille.Col := 6  // + la tabulation, �a fera colonne 7
                    Else
                         Grille.Col := 5; // on saute le nombre d'heures calcul�
               End;
            // On est sur le champ Nb Heures de nuit
            6 : Begin
                    If (Not ModeQuantite) Then Grille.Col := 7;
                End;
          End;
     End
     Else If (Shift = [ssShift]) And (Key = VK_TAB) Then
     Begin
          Case Grille.Col Of
            // On est sur le champ Date fin, on retourne sur Date de d�but
            3 : If ModeQuantite Then Grille.Col := 2; //PT1
            // On est sur le champ Heure fin, on retourne sur Heure de d�but
            4 : If Not ModeQuantite Then Grille.Col := 3 Else Grille.Col := 2; //PT1
            // On est sur le champ Quantit�, on retourne sur Date de d�but
            7 : If ModeQuantite Then Grille.Col := 2;   //PT1
            // On est sur Nb Heures nuit, on retourne sur l'heure de fin
            6:  Begin
                    Grille.Col := 5;
                End;
            // On est sur le champ Libell�
            8 : Begin
                    If Not ModeQuantite Then Grille.Col := 7;
                End;
          End;
     End;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 26/07/2007
Modifi� le ... :   /  /
Description .. : Contr�le de saisie des heures et des quantit�s
Mots clefs ... :
*****************************************************************}
procedure TOF_PGMVTGRP.GrilleCellKeyPress(Sender: TObject; var Key: Char);
begin
     If (Grille.Col=2) Or (Grille.Col=4) Then
     Begin
      If ModeQuantite Then Key := Chr(0)
      Else
      Case Key Of
       'A'..'Z', 'a'..'z' :
          Key := Chr(0); // bloquer le caract�re
       '0'..'9' :
          Begin
               // Dizaine d'heures entre 0, 1 et 2
               If Length (Grille.Cells[Grille.Col,Grille.Row]) = 0 Then
                    If (Key > '2') Then Key := Chr(0);
               If Length (Grille.Cells[Grille.Col,Grille.Row]) = 2 Then
               Begin
                    // Dizaine de minutes entre 0 et 5
                    If (Key > '5') Then
                         Key := Chr(0)
                    Else
                    Begin
                         // Ajout du ':'
                         SendKeys(':'+Key);
                         Key := Chr(0);
                    End;
               End;
          End;
       ':' :  // 2 points uniquement en 3e position
          Begin
               If Length (Grille.Cells[Grille.Col,Grille.Row]) <> 2 Then
                    Key := Chr(0);
          End;
// 18/09/2007 : On ne peut pas refuser toutes les autres touches, sinon �a d�sactive le BackSpace, le couper - copier - coller...
// La saisie est contr�l�e lors du OnExit
//        Else
//          // Refuser
//          Key := Chr(0);
      End;
     End
     // Mode quantit� : Heures non saisissables
     Else If ((Grille.Col=5) Or (Grille.Col=6) Or (Grille.Col=2) Or (Grille.Col=4)) And (ModeQuantite) Then
     Begin
          Key := Chr(0);
     End
     // Mode Heures : Quantit� non saisissable
     Else If (Grille.Col=7) And (Not ModeQuantite) Then
     Begin
          Key := Chr(0);
     End;
end;


{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /
Description .. : Gestion du double-clic �quivalent au clic sur l'elipsis
Mots clefs ... :
*****************************************************************}
procedure TOF_PGMVTGRP.GrilleDblClick(sender: TObject);
Var K : Char;
begin
     If (Grille.col=1) {or (Grille.col=3)} then //PT1
     Begin
          K :='*';
          ParamDate (Ecran, Sender,K);
     End;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /    
Description .. : Clic sur l'elipsis
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGMVTGRP.GrilleElipsisClick(Sender: TObject);
var Key : Char;
begin
     Key := '*';
     ParamDate (Ecran, Sender, Key);
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /    
Description .. : Contr�le de saisie sur sortie d'une cellule
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGMVTGRP.GrilleCellExit(Sender: TObject; var ACol,ARow: Integer; var Cancel: Boolean);
Var 
    DateDeb, DateFin : TDateTime;
    Hdeb, Hfin, NbHeures, NbHeuresNuit : Double;
    T :TOB;
begin
     // Mouvement
     If (ACol = 0) Then
     Begin
          If Mvt <> Grille.CellValues[Acol,ARow] Then
          Begin
               // En fonction du mouvement, il faut afficher ou non la quantit� et interdire ou non les nombres d'heures
               Mvt := Grille.CellValues[Acol,ARow];
               T := TobMotifs.FindFirst(['PMA_MOTIFABSENCE'], [Grille.CellValues[Acol,ARow]], False);
               If T <> Nil Then ModeQuantite := Not ((T.GetValue('PMA_JOURHEURE') = 'HEU') or (T.GetValue('PMA_JOURHEURE') = 'HOR')); //PT3

               // R�initialisation des champs
               AfficheValeurDefaut(ARow, True);

               // Mise � jour du libell�
               Grille.Cells[8,ARow] := RendLibPresence (Grille.CellValues[0,ARow],iDate1900,iDate1900);
          End;
     End
     // Dates + Heures + Nb heures
     Else if ((ACol=1) Or (ACol=2) {Or (ACol=3)} Or (ACol=4) Or (ACol=6)) then //PT1
     Begin
          If (IsValidDate(Grille.Cells[1,ARow])) {And (IsValidDate(Grille.Cells[3,ARow]))} Then //PT1
          Begin
               DateDeb := StrToDate(Grille.Cells[1,ARow]);
               DateFin := StrToDate(Grille.Cells[3,ARow]); 

               // G�n�ration de la date de fin � chaque fois
               If (DateDeb <> iDate1900) {And (DateFin = iDate1900)} Then //PT1
               Begin
                    DateFin := DateDeb;
                    Grille.Cells[3,ARow] := DateToStr(DateFin);
               End;

               // Contr�le des dates : DateDeb <= DateFin //PT1 : Plus la peine
               {If (DateDeb<>iDate1900) And (DateFin<>iDate1900) And (DateFin < DateDeb) Then
               Begin
                    PGIError (TraduireMemoire('La date de fin ne peut �tre inf�rieure � la date de d�but du mouvement.'));
                    Grille.Col := Acol;
                    SaisieValide := False;
                    Exit;
               End;}

               // Mise � jour du libell�
               Grille.Cells[8,ARow] := RendLibPresence (Grille.CellValues[0,ARow],DateDeb,DateFin);
          End
          Else
          Begin
               PGIError (TraduireMemoire('La date n''est pas valide.'));
               Grille.Col := Acol;
               SaisieValide := False;
               Exit;
          End;

          // Contr�le des heures : Si m�me jour, HeureDeb <= HeureFin
          if (ACol=2) Or (ACol=4) Then
          Begin
            If (Grille.Cells[2,ARow] <> '') And (Grille.Cells[4,ARow] <> '') Then
            Begin
               Hdeb := StrTimeToFloat(Grille.Cells[2,ARow], True);
               HFin := StrTimeToFloat(Grille.Cells[4,ARow], True);

               // Si le nombre obtenu est 0 et que l'utilisateur a saisi qqc c'est que la saisie est erron�e
               If ((Hdeb = 0) And (Grille.Cells[2,ARow] <> '00:00')) Or ((HFin = 0) And (Grille.Cells[4,ARow] <> '00:00')) Or
                  (Hdeb >= 24) Or (HFin >= 24) Then
               Begin
                    PGIError (TraduireMemoire('Le format de l''heure est incorrect.'));
                    Grille.Col := Acol;
                    SaisieValide := False;
                    Exit;
               End;

               // G�n�ration de l'heure de fin si l'heure de d�but a �t� renseign�e
               If (Hdeb > 0) And (Hfin = 0) Then
               Begin
                    Hfin := Hdeb;
                    Grille.Cells[4,ARow] := Grille.Cells[2,ARow];
               End;
               
               // Sur la m�me journ�e, l'heure de fin doit �tre > � l'heure de d�but
               If {(DateDeb = DateFin) And} (Hdeb > Hfin) Then //PT1
               Begin
                    PGIError (TraduireMemoire('L''heure de d�but doit pr�c�der l''heure de fin sur une m�me journ�e.'));
                    Grille.Col := Acol;
                    SaisieValide := False;
                    Exit;
               End;
            End;
          End;
          
          // Calcul du nombre d'heures
          if (ACol=2) Or (ACol=4) Or (ACol=6) Then
          Begin
               If Not ModeQuantite Then
               Begin
                    Hdeb := StrTimeToFloat(Grille.Cells[2,ARow], True);
                    HFin := StrTimeToFloat(Grille.Cells[4,ARow], True);
                    NbHeuresNuit := StrToFloat(Grille.Cells[6,ARow]);
                  //  NbHeures := (DateFin-DateDeb)*24 + (Hfin - Hdeb) - NbHeuresNuit;
                    NbHeures := (DateFin-DateDeb)*24 + (Hfin - Hdeb);
                    Grille.Cells[5,ARow] := FloatToStr(NbHeures);
                    If NbHeures < 0 Then
                    Begin
                         PGIError (TraduireMemoire('Le nombre d''heures ne peut-�tre inf�rieur � 0.'));
                         Grille.Col := Acol;
                         SaisieValide := False;
                         Exit;
                    End;
               End;
          End;
     End;
     SaisieValide := True;
End;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 27/07/2007
Modifi� le ... :   /  /    
Description .. : Cr�ation des mouvements saisis
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGMVTGRP.CreeMouvements;
Var ListeAno                                         : TListBox;
    Salarie, SalLib, StSQL                           : String;
    T,T2,TobGroupe,TobNew,TobExistant,TobSalaries    : TOB;
    Ordre                                            : Integer;
    Res                                              : ShortInt;
    Quantite                                         : Real;
begin
     // V�rification que l'utilisateur ait le droit de cr�er les mouvements pour les salari�s s�lectionn�s
     If TheMul = nil then exit;

     // Vidage des anomalies
     ListeAno := TListBox (GetControl('LISTEANOMALIES'));
     ListeAno.Items.Clear;
     Anomalies.Clear;

     InitMoveProgressForm(Nil, TraduireMemoire('Cr�ation des mouvements'), TraduireMemoire('Veuillez patienter SVP ...'), TheMul.RecordCount, FALSE, TRUE);

     // Chargement des �l�ments existants pour le num�ro d'ordre qui doit �tre unique
     MoveCurProgressForm(TraduireMemoire('Chargement des �l�ments existants...'));
     TobExistant := TOB.Create ('LesOrdres', Nil, -1);
     TheMul.First;
     StSQL := 'WHERE PCN_SALARIE IN (';
     While Not TheMul.Eof Do
     Begin
          StSQL := StSQL + '"' + TheMul.FindField('PSA_SALARIE').AsString + '"';
          TheMul.Next;
          If Not TheMul.Eof Then StSQL := StSQL + ',';
     End;
     StSQL := StSQL + ')';
     TobExistant.LoadDetailFromSQL('SELECT PCN_SALARIE,MAX(PCN_ORDRE) AS MAX_ORDRE FROM ABSENCESALARIE '+StSQL+' AND PCN_TYPEMVT="PRE" GROUP BY PCN_SALARIE');

     // Chargement des informations compl�mentaires des salari�s
     TobSalaries := TOB.Create ('LesSalaries', Nil, -1);
     TobSalaries.LoadDetailFromSQL('SELECT PSA_SALARIE, PSA_TRAVAILN1, PSA_TRAVAILN2, PSA_TRAVAILN3, PSA_TRAVAILN4, PSA_CODESTAT,PSA_CONFIDENTIEL FROM SALARIES '+ConvertPrefixe(StSQL,'PCN','PSA'));

     TobGroupe := TOB.Create ('LesMouvementsSaisis', Nil, -1);
     TheMul.First;

     // Parcours des salari�s
     While Not TheMul.Eof Do
     Begin
          Salarie := TheMul.FindField('PSA_SALARIE').AsString;

          // V�rification des droits de mise � jour du salari�
          SalLib  := RechDom('PGSALARIE', Salarie, False);
          If SalLib = '' Then
               Anomalies.Add(ERR1, Format(TraduireMemoire('Vous ne pouvez pas saisir de mouvements pour le salari� %s.'),[Salarie]))
          Else
          Begin
               MoveCurProgressForm(Format(TraduireMemoire('Traitement du salari� : %s  %s'), [Salarie, SalLib]));

               Ordre := 1;
               T2 := TobExistant.FindFirst(['PCN_SALARIE'], [Salarie], False);
               If T2 <> Nil Then Ordre := T2.GetInteger('MAX_ORDRE') + 1;

               // Cr�ation de chaque mouvement saisi
               T := TobMouvements.FindFirst ([''] ,[''], False);
               While T <> Nil Do
               Begin
                    // Contr�les de validit�
                    T2 := TobMotifs.FindFirst(['PMA_MOTIFABSENCE'],[T.GetValue('MOUVEMENT')], False);
                    If ((T2.GetValue('PMA_JOURHEURE') = 'HEU') or (T2.GetValue('PMA_JOURHEURE') = 'HOR')) Then //PT3
                         Quantite := StrToFloat(T.GetValue('NBHEURES'))+StrToFloat(T.GetValue('NBHEURESNUIT'))
                    Else
                         Quantite := StrToFloat(T.GetValue('QUANTITE'));

                    Res := ControleMouvementsPresence ('CREATION', T2, Salarie, T.GetValue('MOUVEMENT'),
                                                       StrToDate(T.GetValue('DATEDU')), StrToDate(T.GetValue('DATEFIN')),
                                                       StrToDateTime(T.GetValue('HEUREDEBUT')), StrToDateTime(T.GetValue('HEUREFIN')),
                                                       Quantite, Ordre, '', TheMul.FindField('PSA_DATEENTREE').AsDateTime,
                                                       TheMul.FindField('PSA_DATESORTIE').AsDateTime);

                    If Res = 15 Then
                         Anomalies.Add(WARN1, Format(TraduireMemoire('Un mouvement d''absence existe d�j� sur la p�riode pour le salari� %s.'), [Salarie]))
                    Else If Res = 16 Then
                         Anomalies.Add(WARN1, Format(TraduireMemoire('La date de fin de mouvement doit �tre ant�rieure � la date de sortie du salari� %s.'), [Salarie]))
                    Else If Res = 17 Then
                         Anomalies.Add(WARN2, Format(TraduireMemoire('La quantit� maximum octroy�e pour le motif "%s" est d�pass�e : %s.'), [RechDom('PGMOTIFPRESENCE', T.GetValue('MOUVEMENT'), False),T2.GetString('PMA_JRSMAXI')]))
                    Else If Res = 18 Then
                         Anomalies.Add(WARN2, Format(TraduireMemoire('Le nombre d''heures maximum octroy� pour le motif "%s" est d�pass� : %s.'), [RechDom('PGMOTIFPRESENCE', T.GetValue('MOUVEMENT'), False),T2.GetString('PMA_JRSMAXI')]))
                    Else If Res = 23 Then
                         Anomalies.Add(WARN1, Format(TraduireMemoire('La date de d�but du mouvement doit �tre post�rieure � la date d''entr�e du salari� %s.'), [Salarie]))
                    Else if Res = 32 Then
                         Anomalies.Add(WARN1, Format(TraduireMemoire('Un mouvement de pr�sence existe d�j� sur la p�riode pour le salari� %s.'), [Salarie]));

                    If Res = 0 Then
                    Begin
                         // Cr�ation des donn�es dans la TOB
                         TobNew := TOB.Create ('ABSENCESALARIE', TobGroupe, -1);

                         TobNew.PutValue('PCN_TYPEMVT',          'PRE');
                         TobNew.PutValue('PCN_SALARIE',          Salarie);
                         TobNew.PutValue('PCN_GUID',             AglGetGUID());
                         TobNew.PutValue('PCN_ORDRE',            Ordre);
                         TobNew.PutValue('PCN_TYPECONGE',        T.GetValue('MOUVEMENT'));
                         TobNew.PutValue('PCN_DATEDEBUTABS',     StrToDate(T.GetValue('DATEDU')));
                         TobNew.PutValue('PCN_DATEFINABS',       StrToDate(T.GetValue('DATEFIN')));
                         TobNew.PutValue('PCN_DATEVALIDITE',     StrToDate(T.GetValue('DATEFIN')));
                         TobNew.PutValue('PCN_HDEB',             StrToTime(T.GetValue('HEUREDEBUT')));
                         TobNew.PutValue('PCN_HFIN',             StrToTime(T.GetValue('HEUREFIN')));
                         TobNew.PutValue('PCN_HEURES',           StrToFloat(T.GetValue('NBHEURES')));
                         TobNew.PutValue('PCN_NBHEURESNUIT',     StrToFloat(T.GetValue('NBHEURESNUIT')));
                         TobNew.PutValue('PCN_JOURS',            StrToFloat(T.GetValue('QUANTITE')));
                         TobNew.PutValue('PCN_LIBELLE',          T.GetValue('LIBELLE'));

                         TobNew.PutValue('PCN_ETABLISSEMENT',    TheMul.FindField('PSA_ETABLISSEMENT').AsString);
                         T2 := TobSalaries.FindFirst(['PSA_SALARIE'], [Salarie], False);
                         If T2 <> Nil Then
                         Begin
                              TobNew.PutValue('PCN_TRAVAILN1',   T2.GetValue('PSA_TRAVAILN1'));
                              TobNew.PutValue('PCN_TRAVAILN2',   T2.GetValue('PSA_TRAVAILN2'));
                              TobNew.PutValue('PCN_TRAVAILN3',   T2.GetValue('PSA_TRAVAILN3'));
                              TobNew.PutValue('PCN_TRAVAILN4',   T2.GetValue('PSA_TRAVAILN4'));
                              TobNew.PutValue('PCN_CODESTAT',    T2.GetValue('PSA_CODESTAT'));
                              TobNew.PutValue('PCN_CONFIDENTIEL',T2.GetValue('PSA_CONFIDENTIEL'));
                         End;

                         // Valeurs par d�faut
                         TobNew.PutValue('PCN_MVTORIGINE',       'SAL');
                         TobNew.PutValue('PCN_ETATPOSTPAIE',     'VAL');
                         TobNew.PutValue('PCN_CODETAPE',         '...');
                         TobNew.PutValue('PCN_VALIDSALARIE',     'SAL');
                         TobNew.PutValue('PCN_VALIDRESP',        'VAL');
                         TobNew.PutValue('PCN_EXPORTOK',         'X');

                         Ordre := Ordre + 1;
                    End;

                    T := TobMouvements.FindNext([''] ,[''], False);
               End;
          End;
          TheMul.Next;
     End;

     // Insertion en base des donn�es cr��es
     If (TobGroupe <> Nil) And (TobGroupe.Detail.Count > 0) Then
     Begin
          Try
               BeginTrans;
               MoveCurProgressForm(TraduireMemoire('Mise � jour des donn�es...'));
               TobGroupe.InsertDB(Nil);

               //PT2 - D�but
               // Tri pour avoir la date de d�but la plus ancienne � chaque fois en premier
               TobGroupe.Detail.Sort('PCN_SALARIE;PCN_DATEDEBUTABS');
               // Recalcul des compteurs pour les salari�s qui ont �t� trait�s
               T := TobGroupe.FindFirst([''],[''],False);
               Salarie := '';
               While T <> Nil Do
               Begin
                    // une demande par salari�
                    If Salarie <> T.GetValue('PCN_SALARIE') Then
                    Begin
                         // Demande de recalcul des compteurs pour la date trouv�e
                         CompteursARecalculer(T.GetDateTime('PCN_DATEDEBUTABS'), T.GetValue('PCN_SALARIE'));
                         Salarie := T.GetValue('PCN_SALARIE');
                    End;
                    T := TobGroupe.FindNext([''], [''], False);
               End;
               //PT2 - Fin

               CommitTrans;

               PGIInfo(TraduireMemoire('Traitement effectu�.'), TraduireMemoire('Cr�ation des mouvements'));

               Updated := True;
          Except
               Rollback;
               Updated := False;
               PGIError (TraduireMemoire('Une erreur est survenue lors de l''�criture des lignes de mouvement.'));
          End;
     End
     Else
     Begin
          PGIInfo (TraduireMemoire('Aucune ligne de mouvement n''a �t� g�n�r�e.'),TraduireMemoire('Cr�ation des mouvements'));
          Updated := False;
     End;

     // Lib�ration des objets en m�moire
     FreeAndNil(TobGroupe);
     FreeAndNil(TobExistant);
     FreeAndNil(TobSalaries);
     FiniMoveProgressForm;

     // Mise � jour de la liste des anomalies
     Anomalies.PutInList(ListeAno);
     (GetControl('PAGES') As THPageControl2).ActivePageIndex := 1; //2e onglet
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 25/07/2007
Modifi� le ... :   /  /    
Description .. : Conversion des pr�fixes de colonnes
Mots clefs ... : 
*****************************************************************}
function ConvertPrefixe(StWhere, DePref, APref: string): string;
var
  pospref: integer;
begin
  if StWhere <> '' then
    while Pos(DePref, StWhere) > 0 do
    begin
      pospref := Pos(DePref, StWhere);
      StWhere[(pospref + 1)] := APref[2];
      StWhere[(pospref + 2)] := APref[3];
    end;
  result := Trim(StWhere);
end;

initialization
  registerclasses([TOF_PGMVTGRPMUL, TOF_PGMVTGRP]);
end.

