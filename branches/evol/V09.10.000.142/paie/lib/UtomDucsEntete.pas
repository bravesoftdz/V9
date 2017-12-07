{***********UNITE*************************************************
Auteur  ...... : MF
Cr�� le ...... : 16/05/2001
Modifi� le ... : 01/10/2001
Description .. : TOM Saisie-Consultation des DUCS
Suite ........ : impression de la DUCS s�lectionn�e
Suite ........ : maj table DUCSENTETE
Suite ........ : maj table DUCSPAIE
Mots clefs ... : PAIE, PGDUCS
*****************************************************************}
{
PT1 : 01/10/2001 : V562  MF  Modif. calcul du total d�clar� : On exclut les S/T
PT2 : 10/10/2001 : V562  MF
                             1- traitement du bouton Defaire
                             2- Validation et Contr�les sur bouton Imprimer
                             3- On ne contr�le pas le n� MSA (A faire qd on obtient
                                l'algorithme)
PT3 : 15/10/2001 : V562  MF  Modification : la table INSTITUTIONPAYE remplace
                             la table INSTITUTIONPAIE
PT4 : 07/11/2001 : V562  MF
                             1- On n'active les boutons Insertion et Suppression de
                                lignes uniquement sur l'onglet d�tail
                             2- A chaque insertion ou suppression de ligne maj de
                                l'indicateur Neant
PT5 : 27/11/2001 : V569  MF  La fonction ControlSiret est maintenant Publique
                             PgOutils)
PT6 : 03/01/2002 : V571  MF  Contr�le de la saisie des Dates de cessation et
                             de continuation d'activit� par rapport au nombre
                             de salari�s pr�sents et � la derni�re date de sortie.
PT7 : 08/01/2002 : V571  MF
                             1- Correction du contr�le des champs obligatoires sur
                                les lignes d�tail : Dans le cas d'un type Montant
                                il y avait, � tort, un contr�le bloquant.
                             2- Traitement du champ PDD_LIBELLESUITE : modif. de
                                la requ�te utilis�e pour le LanceEtat
PT8 : 25/01/2002 : V571 MF
                             1- Je reviens sur le PT7 : dans le cas d'une
                             codification de type montant "base" et "taux" ne
                             pas renseign�s.

PT9 : 14/02/2002 : V571 MF
                             1- Adaptation pour le traitement des ruptures :
                             1 champ de + dans la cl� de DUCSENTETE et DUCSDETAIL
PT10 : 19/03/2002 : V571 MF  modification requ�te de recherche sur DUCSPARAM
                             pour r�cup�rer en priorit� la codification
                             de type DOS sinon STD sinon CEGID
                             2- correction requ�te (s�lection institution)
PT11 : 29/03/2002 : V571 MF  Modification pour traiter le cas d'une ducs
                                "pernonnalis�e"
PT12 : 18/06/2002 : V582 MF  1- pas de contr�le de validit� des dates
                                 01/01/1900 car il existe d�j� un contr�le
                                 des dates obligatoires.
                             2- Suppression d'un Ducs n�ant impossible
                                quand informations concernant la non
                                occupation de personnel renseign�es .
PT13 : 20/06/2002 : V585 MF  Traitement de la VLU pour les entreprises
                             en paiement group�.
                             (Annexe � la DUCS)
PT14 : 12/07/2002 : V582 MF  suppression du PT8
                             (type "Montant" : "base" et "taux" renseign�s mais
                             inaccesibles)
PT15 : 11/10/2002 : V585 MF  suppression commentaires pour lisibilit� code
                             Plus de contr�le de Base et Taux pour les ligne de
                             type Montant
PT16 : 08/01/2003 : V591 MF  correction initialisations des doubles
PT17 : 13/10/2003 : V591 MF
                             1- Modification du traitement des lignes
                                de la grille (d�tail). Suite � la mise en place
                                de l'AGL V550 la suppression et l'insertion de
                                lignes fonctionnait mal, on ne pouvait plus
                                supprimer la ducs.
                             2- Apr�s Suppression de ducs le traitement passait
                                � tort sur la validation des champs (OnUpdate),
                                au lieu de revenir directement � la liste multi
                                crit�re.
PT18 : 03/02/2003 : V591 MF
                             1- Modification de l'alimentation de la cellule
                                montant. La cellule est aliment�e m�me si le champ
                                est � z�ro. R�sout Pb champ non aliment� qui
                                g�n�rait une anomalie. Correspond aux montants
                                diff�rents de z�ro avant arrondi.
PT19 : 05/03/2003 : V42 MF
                             1- Pour les lignes de type taux AT le montant n'est
                                pas affich� (affich� � '')
PT20 : 13/03/2003 :  V42 MF     MEMCHEK (TOB_Lignes.free et TOB_Lignes := NIL)
PT21 : 11/04/2003 :  V42 MF  correction alimentation codif �dit�e pour ligne de
                             ST (affichait les ZZZZZ dans le cas o� la la codif.
                             ne doit pas �tre �dit�e)
PT22 : 02/07/2003 ; V_421 MF Mise au point CWAS
PT23 : 21/07/2003 : V_421 MF traitement du champ PDU_CENTREPAYEUR
PT24 : 25/09/2003 : V_421 MF La cellule Montant n'est plus cont�l�e. Ainsi pas
                             de blocage en validation.
PT25 : 18/12/2003 : V_5.0 MF FQ 10978 : correction total d�clar� doubl� en visu
                             si dde impression (pb CWAS)
PT26 : 23/02/2004 : V_5.0 MF FQ 10648 : mise en place de la DUCS dans les �tats
                             cha�n�s. (ici modification du nbre de param�tres
                             de la fonction EditVLU)
PT27 : 09/04/2004 : V_5.0 MF FQ 11250 : R�gularisation impossible s'il ne s'agit
                            pas d'un TR annuel
PT28 : 11/10/2004 : V_5.0 MF FQ 11704 : Contr�le des dates : n'est plus fait
                            par rapport � l'exercice en cours. Uniquement conrtr�le
                            date obligatoire
PT29 : 18/11/2004 : V_6.0 MF FQ 11295 : date chgt.taux : elipsis pour calendrier
PT30 : 30/09/2005 : V_6.10 MF on rend le champ type d�claration invisible
PT31 : 09/02/2006 : V_650 MF  DUCS EDI V 4.2
PT32 : 11/04/2006 : V_650 MF  FQ 13002 : les lignes ins�r�es en anomalie ne sont
                              pas affich�es.
PT33 : 07/07/2006 : V_70  MF  DUCS V 4.2 : modifications suite evolution DRA 2005
PT34 : 26/09/2006 : V_700 MF  DUCS V 4.1 : FQ 13480 : zone r�gularisation inaccessible
                              pour ADV assedic
PT35 : 28/12/2006 : V_702 MF  FQ 13742 : pour IRC recherche codification "8"
PT36 : 28/12/2006 : V_702 MF  FQ 13070 : Traitement des codifications ALSACE MOSELLE
PT37 : 30/03/2007 : V_702 MF  Suite modifs pour �tats cha�n�s et Process server
                              Ajout un param�tre fct EditVLU
PT38 : 18/04/2007 : V_72 MF   FQ 13969 : modif traitement des effectifs.
PT40 : 20/06/2008 : V_810 MF  FQ 15564 : correction acces vio CWAS qd insertion de ligne
                              + correction conseils de compile
PT41 : 09/07/2008 : V_810 MF  FQ 15564  : correction PT40 : Qd saisie d'un code ne
                              faisant pas partie de DUCPARAM "indice de liste hors limite"
}
unit UtomDucsEntete;

interface
uses
  {$IFDEF VER150}
  Variants,
  {$ENDIF}
  Controls, Classes, Graphics, forms, sysutils, ComCtrls,
  {$IFDEF EAGLCLIENT}
  UtileAGL, eFiche,
  {$ELSE}
  db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  HDB, Fiche,
  {$IFDEF V530}
  EdtEtat,
  {$ELSE}
  EdtREtat,
  {$ENDIF}
  {$ENDIF}
  HCtrls, HEnt1,
  HMsgBox, LookUp, UTOM, UTOB, HTB97,
  Grids,
  ParamDat,
  PgOutils2,P5Util,
  PGEdtEtat,
  StdCtrls,
  ULibEditionPaie;

type
  LigneAction = (Consultation, Creation);
  TOM_DUCSENTETE = class(TOM)
    procedure OnArgument(stArgument: string); override;
    procedure OnChangeField(F: TField); override;
    procedure OnUpdateRecord; override;
    procedure OnLoadRecord; override;
    procedure OnDeleteRecord; override;
    procedure OnClose; override;
    procedure OnCancelRecord; override; 
  private
    Action: LigneAction;
    LaGrille: THGrid;
    LesLignes, TOB_Lignes, TOB_FilleLignes: TOB;
    LaCellule, Nature, etab, organisme, detmess, BaseArr, WBaseArr, MontArr, WMontArr: string;
    Period1, Period2: string;
    DebPer, FinPer: TDateTime;
    Total, Apayer, Acompte, Regularisation: double;
    SousTot, TypeDecl1, TypeDecl2, Neant: boolean;
    DucsDoss: boolean;
    PaieGroupe: boolean;
    LgSt, PosDebSt, LongTot, LongEdit, PosDebEd, NbPages, NbreMois: integer;
    PageCtrl: TPageControl;
    BtnIns, BtnDel: TToolBarButton97;
    NbSal: integer;
    DateMax: TDateTime;
    NoDucs: string;
    RuptGpInt, RuptNumInt: boolean;
    Ligne: integer;
    IndDelete: boolean;
{$IFNDEF DUCS41}
    EcartZe9 : TCheckBox;
{$ENDIF}

    procedure OnExitPeriode(sender: TOBject);
    function FormatLibellePeriode(Periode: string): string;
    procedure DateElipsisclick(Sender: TObject);
    procedure ControlDateDucs(sender: TOBject);
    function InitVarRech(): Boolean;
    procedure GrilleRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
    procedure GrilleRowExit(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
    procedure GrilleCellExit(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
    procedure GrilleCellEnter(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
    procedure GrilleDblClick(Sender: TObject);
    procedure GrilleElipsisClick(Sender: TObject);
    procedure BTnInsClick(Sender: TObject);
    procedure BTnDelClick(Sender: TObject);
    procedure BTImprimer(Sender: TObject);
    procedure GrillePostDrawCell(ACol, ARow: Longint; Canvas: TCanvas; AState: TGridDrawState);
    function MajDucsDetail(NoSiret, CodApe, GpInterne, NoInterne: string): Boolean;
    procedure GrilleClick(Sender: TObject);
    function ZoneGrise(ACol, ARow: Integer): Boolean;
    function CalculTotaux(): Boolean;
    function FormatZoneNum(Acol, Arow: Longint): Boolean;
    procedure ControlValid(var NoSiret, CodApe, GpInterne, NoInterne: string); 
    procedure PageCtrlChange(Sender: TObject);
    procedure EnterActivite(Sender: TObject);
{$IFNDEF DUCS41}
    procedure MajEcartZE9(Sender: TObject);
{$ENDIF}    
  end;

implementation
uses
  PGVLU;
var
    AlsaceMoselle : boolean;

// Chargement de la fiche DUCS_ENTETE
procedure TOM_DUCSENTETE.OnArgument(stArgument: string);
var
  {$IFDEF EAGLCLIENT}
  AbregePeriod, Cessation, Continuation: THEDIT;
  {$ELSE}
  AbregePeriod, Cessation, Continuation: THDBEDIT;
  {$ENDIF}
  BtImprim: TToolBarButton97;
  THTotal, THAPayer: THNumEdit;
{$IFDEF DUCS41}
  Titres : HTStringList;
{$ENDIF}

begin
  inherited;
  IndDelete := False;

  // Grille des lignes de d�tail:
  // ----------------------------
  // �v�nements g�r�s
  LaGrille := THGrid(Getcontrol('GRILLEDETAIL'));
  if LaGrille <> nil then
  begin
    LaGrille.OnCellExit := GrilleCellexit;
    LaGrille.OnCellEnter := GrilleCellEnter;
    LaGrille.OnRowEnter := GrilleRowEnter;
    LaGrille.OnRowExit := GrilleRowExit;
    LaGrille.OnClick := GrilleClick;
    LaGrille.OnElipsisClick := GrilleElipsisClick;
    LaGrille.PostDrawCell := GrillePostDrawCell;
    LaGrille.OnDblClick := GrilleDblClick;

{$IFDEF DUCS41}
    Titres := HTStringList.Create;
    Titres.AddStrings(LaGrille.Titres);
    Titres[8] := 'Com.Urbaine';
    LaGrille.Titres := Titres ;
    Titres.free;
{$ENDIF}
  end
  else exit;

  // Insertion de ligne et suppression de ligne
  BtnIns := TToolBarButton97(GetControl('BINS_LINE'));
  if BtnIns <> nil then
  begin
    BtnIns.OnClick := BTnInsClick;
    BtnIns.Enabled := False;
  end;
  PageCtrl := TPageControl(GetControl('Pages'));
  if PageCtrl <> nil then
  begin
    PageCtrl.ActivePageIndex := 0;
    PageCtrl.OnChange := PageCtrlChange;
  end;

  BtnDel := TToolBarButton97(GetControl('BDEL_LINE'));
  if BtnDel <> nil then
  begin
    BtnDel.OnClick := BTnDelClick;
    BtnDel.Enabled := False;
  end;
  // Impression
  BtImprim := TToolBarButton97(GetControl('BImprimer'));
  if BtImprim <> nil then
  begin
    BtImprim.OnClick := BTImprimer;
    BtImprim.Visible := True; // mise au point CWAS
  end;
  // Code p�riode abr�g� :
  // ---------------------
  // En sortie de champ affichage du libell� de p�riode
  {$IFDEF EAGLCLIENT}
  AbregePeriod := THEdit(GetControl('PDU_ABREGEPERIODE'));
  {$ELSE}
  AbregePeriod := THDBEdit(GetControl('PDU_ABREGEPERIODE'));
  {$ENDIF}
  if AbregePeriod <> nil then AbregePeriod.OnExit := OnExitPeriode;

  // Les Dates :
  // -----------
  // Sur Double Click saisi � l'aide calendrier
  // En sortie de champ Contr�le de la validit�

  // R�cup�ration du Total � d�clarer et du total � payer
  THTotal := THNumEdit(GetControl('TOT_DECLARE'));
  if (THTotal <> nil) then Total := THTotal.Value;
  THAPayer := THNumEdit(GetControl('APAYER'));
  if (THAPayer <> nil) then APayer := THAPayer.Value;


  {$IFDEF EAGLCLIENT}
  Cessation := THEdit(GetControl('PDU_CESSATION'));
  Continuation := THEdit(GetControl('PDU_CONTINUATION'));
  {$ELSE}
  Cessation := THDBEdit(GetControl('PDU_CESSATION'));
  Continuation := THDBEdit(GetControl('PDU_CONTINUATION'));
  {$ENDIF}
  if Cessation <> nil then Cessation.OnEnter := EnterActivite;
  if Continuation <> nil then Continuation.OnEnter := EnterActivite;

{$IFNDEF DUCS41}
   // traitement du bool�en Ecart d'effectif : embauches CNE
   EcartZe9 := TCheckBox(GetControl('ECARTZE9'));
   if EcartZe9 <> nil then EcartZe9.OnExit := MajEcartZE9;
{$ENDIF}
end;   // fin OnArgument

// Modification D'un champ de l'enregistrement DUCSENTETE en cours
procedure TOM_DUCSENTETE.OnChangeField(F: TField);
begin
  inherited;
  if ((F.FieldName = 'PDU_ACOMPTES') or (F.FieldName = 'PDU_REGULARISATION')) then

    // Calcul du total d�clar� et du total � payer
    // Total d�clar� = Somme des Montant de cotisation de chaque ligne d�tail
    // Total � payer = Total d�clar� - Acomptes + R�gularisations
    CalculTotaux();

  if (F.FieldName = 'PDU_CESSATION') then
  begin
    // Si tous les salari�s sont sortis, la date saisie ne doit pas �tre
    // inf�rieure � la derni�re date de sortie des fiches salari�s
    if (GetField('PDU_CESSATION') < DateMax) and (NbSal = 0) and
      (GetField('PDU_CESSATION') <> IDate1900) then
    begin
      PGIBox('! Attention, la date saisie est inf�rieure � la derni�re date de sortie', 'Cessation d''activit� ou maintien sans personnel');
    end;
    if (GetField('PDU_CESSATION') <> IDate1900) then
    begin
      SetField('PDU_CONTINUATION', IDate1900);
    end;
  end;

  if (F.FieldName = 'PDU_CONTINUATION') then
  begin
    if (GetField('PDU_CONTINUATION') < DateMax) and (NbSal = 0) and
      (GetField('PDU_CONTINUATION') <> IDate1900) then
      // Si tous les salari�s sont sortis, la date saisie ne doit pas �tre
      // inf�rieure � la derni�re date de sortie des fiches salari�s
    begin
      PGIBox('! Attention, la date saisie est inf�rieure � la derni�re date de sortie', 'Cessation d''activit� ou maintien sans personnel');
    end;
    if (GetField('PDU_CONTINUATION') <> IDate1900) then
    begin
      SetField('PDU_CESSATION', IDate1900);
    end;
  end;
end;   // fin OnChangeField

// suppression d'en t�te de Ducs : La suppression n'est possible que
// s'il n'existe aucune ligne de cotisation associ�e (table DUCSDETAIL)
procedure TOM_DUCSENTETE.OnDeleteRecord;
var
  NomChamp: array[1..9] of Hstring;
  ValChamp: array[1..9] of variant;
  ExisteCod: Boolean;
begin
  inherited;
  NomChamp[1] := 'PDD_ETABLISSEMENT';
  NomChamp[2] := 'PDD_ORGANISME';
  NomChamp[3] := 'PDD_DATEDEBUT';
  NomChamp[4] := 'PDD_DATEFIN';
  NomChamp[5] := 'PDD_SIRET';
  NomChamp[6] := 'PDD_APE';
  NomChamp[7] := 'PDD_GROUPE';
  NomChamp[8] := 'PDD_NUMERO';
  NomChamp[9] := 'PDD_NUM';

  ValChamp[1] := GetField('PDU_ETABLISSEMENT');
  ValChamp[2] := GetField('PDU_ORGANISME');
  ValChamp[3] := DateToStr(GetField('PDU_DATEDEBUT'));
  ValChamp[4] := DateToStr(GetField('PDU_DATEFIN'));
  ValChamp[5] := GetField('PDU_SIRET');
  ValChamp[6] := GetField('PDU_APE');
  ValChamp[7] := GetField('PDU_GROUPE');
  ValChamp[8] := GetField('PDU_NUMERO');
  ValChamp[9] := GetField('PDU_NUM');
  ExisteCod := PresenceComplexe('DUCSDETAIL', NomChamp, ['=', '=', '=', '=', '=', '=', '=', '=', '='],
    [Valchamp[1], Valchamp[2], UsDateTime(GetField('PDU_DATEDEBUT')), UsDateTime(GetField('PDU_DATEFIN')), Valchamp[5],
    Valchamp[6], Valchamp[7], Valchamp[8], Valchamp[9]],
      ['S', 'S', 'S', 'S', 'S', 'S', 'S', 'S', 'I']);//DB2
  if ExisteCod = TRUE then
  begin
    LastError := 1;
    PGIBox('Attention! il existe des lignes associ�es � cette ent�te,' +
      '#13#10 Vous ne pouvez pas la supprimer!', 'Ent�te DUCS');
  end
  else
  begin
    if (GetField('PDU_CESSATION') <> IDate1900) or
      (GetField('PDU_CONTINUATION') <> IDate1900) or
      (GetField('PDU_SUSPENSION') = 'X') or
      (GetField('PDU_MAINTIENT') = 'X ') then
    begin
      LastError := 1;
      PGIBox('Attention! il s''agit d''une ducs "n�ant",' +
        '#13#10 Vous ne pouvez pas la supprimer!', 'Ent�te DUCS');
    end
    else
    begin
      IndDelete := True;
      Ecran.Close;
    end;
  end;
end;  // fin OnDeleteRecord

// sortie de la fiche
procedure TOM_DUCSENTETE.OnClose;
begin
  inherited;
end;

// sortie du champ PDU_ABREGEPERIODE
// il faut afficher le libell� de p�riode associ�
procedure TOM_DUCSENTETE.OnExitPeriode(sender: TOBject);
var
  {$IFDEF EAGLCLIENT}
  edit: THedit;
  {$ELSE}
  edit: THDBedit;
  {$ENDIF}
  libelle: THLabel;
begin
  {$IFDEF EAGLCLIENT}
  Edit := THEdit(sender);
  {$ELSE}
  Edit := THDBEdit(sender);
  {$ENDIF}

  Libelle := THLabel(GetControl('LIBELLEPERIODE'));
  if (edit <> nil) and (libelle <> nil) then
  begin
    Libelle.Caption := FormatLibellePeriode(Edit.Text);
    if Libelle.Caption = '' then SetField('PDU_ABREGEPERIODE', '');
  end;
end; // fin OnExitPeriode

// Chargement d'une ent�te DUCS
// ----------------------------
// + Chargement des lignes de d�tail associ�es
//   -----------------------------------------
procedure TOM_DUCSENTETE.OnLoadRecord;
var
  {$IFDEF EAGLCLIENT}
  AbregePeriod: THEdit;
  {$ELSE}
  AbregePeriod: THDBEdit;
  {$ENDIF}

  Libelle: THLabel;
  NoSiret, CodApe, declarant, suitdeclarant, teldeclarant, faxdeclarant: string;
  GpInterne, NoInterne: string;
  Q, QL: TQuery;
  DateChgtTaux: TDateTime;
  StSal: string;
  {$IFDEF EAGLCLIENT}
  DbEdit1, DbEdit2, DbEdit3, DbEdit4, DbEdit5, DbEdit6, DbEdit7: THEDIT;
  {$ELSE}
  DbEdit1, DbEdit2, DbEdit3, DbEdit4, DbEdit5, DbEdit6, DbEdit7: THDBEDIT;
  {$ENDIF}

  IndValid: Boolean;

begin
  inherited;
  IndValid := False;
  // modif du ds.state pour parer � une erreur quand double clique sur champ date
  //if not (ds.state in [dsinsert,dsedit]) then ds.edit;@@ si on r� active plus de Bdelete
  // r�cup�ration de la valeur des variables Etab, Organisme, DebPer, FinPer
  InitVarRech();
  Neant := FALSE;

  if (Etab <> '') and (organisme <> '') then
    // R�cup�ration des infos n�cessaires au formatage des diff�rentes Cellules
    // du d�tail
  begin
    Q := OpenSql('SELECT POG_LIBELLE,POG_NATUREORG, POG_SOUSTOTDUCS, POG_LONGTOTAL, ' +
      'POG_POSTOTAL, POG_LONGTOTALE, POG_LONGEDITABLE, POG_POSDEBUT, ' +
      'POG_BASETYPARR, POG_MTTYPARR, ' +
      'POG_PERIODICITDUCS, POG_AUTREPERIODUCS, POG_PERIODCALCUL, ' +
      'POG_AUTPERCALCUL, ' +
      'POG_RUPTGROUPE, POG_RUPTNUMERO, ' + 
      'POG_DUCSDOSSIER,POG_PAIEGROUPE' +
      ' FROM ORGANISMEPAIE ' +
      'WHERE POG_ORGANISME="' + Organisme + '" ' +
      'AND POG_ETABLISSEMENT="' + Etab + '"', True);
    if not Q.eof then
    begin
      ThEdit(GetControl('LIBORGANISME')).Text := Q.FindField('POG_LIBELLE').AsString;
      Nature := Q.FindField('POG_NATUREORG').AsString;
      SousTot := (Q.FindField('POG_SOUSTOTDUCS').Asstring = 'X');
      LgSt := Q.FindField('POG_LONGTOTAL').AsInteger;
      PosDebSt := Q.FindField('POG_POSTOTAL').AsInteger;
      LongTot := Q.FindField('POG_LONGTOTALE').AsInteger;
      LongEdit := Q.FindField('POG_LONGEDITABLE').AsInteger;
      PosDebEd := Q.FindField('POG_POSDEBUT').AsInteger;
      BaseArr := Q.FindField('POG_BASETYPARR').AsString;
      MontArr := Q.FindField('POG_MTTYPARR').AsString;
      Period1 := Q.FindField('POG_PERIODICITDUCS').AsString;
      TypeDecl1 := (Q.FindField('POG_PERIODCALCUL').AsString = 'X');
      Period2 := Q.FindField('POG_AUTREPERIODUCS').AsString;
      TypeDecl2 := (Q.FindField('POG_AUTPERCALCUL').AsString = 'X');
      DucsDoss := (Q.FindField('POG_DUCSDOSSIER').AsString = 'X');
      PaieGroupe := Q.FindField('POG_PAIEGROUPE').AsString = 'X';
      RuptGpInt := (Q.FindField('POG_RUPTGROUPE').Asstring = 'X');
      RuptNumInt := (Q.FindField('POG_RUPTNUMERO').Asstring = 'X');
    end
    else
    begin
      Nature := '';
      SousTot := FALSE;
      LgSt := 0;
      LongTot := 0;
      LongEdit := 0;
      PosDebEd := 0;
      PosDebSt := 0;
      BaseArr := '';
      MontArr := '';
      Period1 := '';
      TypeDecl1 := TRUE;
      Period2 := '';
      TypeDecl2 := TRUE;
      DucsDoss := FALSE;
      PaieGroupe := FALSE;
      RuptGpInt := FALSE; // PortageCWAS
      RuptNumInt := FALSE; // PortageCWAS
    end;
    WBaseArr := BaseArr;
    WMontArr := MontArr;
    Ferme(Q);
  end;
  // Quelle est la derni�re date de sortie des fiches salari�s?
  if (DucsDoss = TRUE) then
    // Ducs Dossier
    StSal := 'SELECT MAX(PSA_DATESORTIE) AS MAXSORTIE' +
      ' FROM SALARIES'
  else
    // Ducs Etablissement
    StSal := 'SELECT MAX(PSA_DATESORTIE) AS MAXSORTIE' +
      ' FROM SALARIES WHERE PSA_ETABLISSEMENT="' + Etab + '"';

  Q := OpenSQL(StSal, TRUE);
  // PortageCWAS
  DateMax := IDate1900;
  if (not Q.EOF) and (Q.FindField('MAXSORTIE').AsString <> '') then
    DateMax := Q.FindField('MAXSORTIE').AsDateTime;
  //  else
  //      DateMax := IDate1900;
  Ferme(Q);
{$IFDEF DUCS41}
   SetControlVisible('FEUILLE1', FALSE);

    SetControlVisible('PDU_TYPBORDEREAU', FALSE);
    SetControlVisible('TPDU_TYPBORDEREAU', FALSE);
{$ENDIF}

  // Les champ PDU_CENTREPAYEUR et TPDU_CENTREPAYEUR visible uniquement pour IRC
  if (Nature <> '300') then
  begin
    SetControlVisible('PDU_CENTREPAYEUR', FALSE);
    SetControlEnabled('PDU_CENTREPAYEUR', FALSE);
    SetControlVisible('TPDU_CENTREPAYEUR', FALSE);
  end
  else
  begin
    SetControlVisible('PDU_CENTREPAYEUR', TRUE);
    SetControlEnabled('PDU_CENTREPAYEUR', TRUE);
    SetControlVisible('TPDU_CENTREPAYEUR', TRUE);
  end;

  // La zone "R�gularisation" ne doit pas �tre renseign�e pour une DUCS
  // ASSEDIC
{$IFNDEF DUCS41}
  if (Nature = '200') then
  begin
    SetcontrolEnabled('PDU_TYPBORDEREAU',True);
    SetControlEnabled('PDU_REGULARISATION', FALSE);
    SetControlVisible('FEUILLE1',True);
  end
  else
    SetControlVisible('FEUILLE1',False);
{$ENDIF}

  // SIRET obligatoire on force la mise � jour
  NoSiret := GetField('PDU_SIRET');
  if (NoSiret = '') and (Nature <> '600') then
    IndValid := TRUE;

  // APE obligatoire  on force la mise � jour
  CodApe := GetField('PDU_APE');
  if (CodApe) = '' then
    IndValid := TRUE;

  // Groupe interne obligatoire pour certaines DUCS  on force la mise � jour
  GpInterne := GetField('PDU_GROUPE');
  if ((GpInterne) = '') and (Nature <> '100') and (Nature <> '200') then
    IndValid := TRUE;

  // Le n� interne : si absent on le signale   on force la mise � jour
  NoInterne := GetField('DPU_NUMERO');
  if (NoInterne) = '' then
    IndValid := TRUE;

  // Infos d�clarant obligatoires  on force la mise � jour
  declarant := GetField('PDU_DECLARANT');
  suitdeclarant := GetField('PDU_DECLARANTSUITE');
  if ((declarant) = '') and ((suitdeclarant) = '') then
    IndValid := TRUE;

  teldeclarant := GetField('PDU_TELEPHONEDECL');
  faxdeclarant := GetField('PDU_FAXDECLARANT');
  if ((teldeclarant) = '') and ((faxdeclarant) = '') then
    IndValid := TRUE;

  // Affichage du libell� de la p�riode
  {$IFDEF EAGLCLIENT}
  AbregePeriod := THEdit(GetControl('PDU_ABREGEPERIODE'));
  {$ELSE}
  AbregePeriod := THDBEdit(GetControl('PDU_ABREGEPERIODE'));
  {$ENDIF}
  Libelle := THLabel(GetControl('LIBELLEPERIODE'));
  if (AbregePeriod <> nil) and (libelle <> nil) then
  begin
    Libelle.Caption := FormatLibellePeriode(AbregePeriod.Text);
    if Libelle.Caption = '' then SetField('PDU_ABREGEPERIODE', '');
  end;

  if (copy(AbregePeriod.Text, 3, 2) <> '00') and
    ((Nature = '100') or  (Nature = '200')) then
  begin
    if (Getfield('PDU_REGULARISATION') = 0.0) then
      SetControlEnabled('PDU_REGULARISATION', FALSE);
  end;

{$IFNDEF DUCS41}
   // traitement du bool�en Ecart d'effectif : embauches CNE
   // la c�ation d'un nouveau champ dans la table �tant impossible on utilise
   // PDU_NBSALQ966 qui n'est pas utilis�.
    if (Getfield('PDU_NBSALQ966') = 0) then
      EcartZE9.checked := False
    else
      EcartZE9.checked := True;
{$ENDIF}

  // Chargement de la TOB des Lignes D�tail
  TOB_Lignes := TOB.Create('Les lignes de cotisation', nil, -1);

  QL := OpenSql('SELECT * FROM DUCSDETAIL ' +
    'WHERE ' +
    '(PDD_ETABLISSEMENT ="' + Etab + '") AND ' +
    '(PDD_ORGANISME ="' + organisme + '") AND ' +
    '(PDD_DATEDEBUT ="' + UsDateTime(DebPer) + '") AND ' +
    '(PDD_DATEFIN = "' + UsDateTime(FinPer) + '") AND ' +
    '(PDD_NUM = ' + NoDucs + ')', TRUE);// DB2

  TOB_Lignes.LoadDetailDB('DUCSDETAIL', '', '', QL, FALSE, FALSE);
  Ferme(QL);
  TOB_Lignes.Detail.Sort('PDD_ETABLISSEMENT;PDD_ORGANISME;PDD_DATEDEBUT;' +
    'PDD_DATEFIN;PDD_INSTITUTION;PDD_CODIFICATION;PDD_DATECHGTTAUX');

  // Calcul du total d�clar� et du total � payer
  // Total d�clar� = Somme des Montant de cotisation de chaque ligne d�tail
  // Total � payer = Total d�clar� - Acomptes + R�gularisations
  //Total := TOB_Lignes.Somme('PDD_MTCOTISAT',[''],[''],TRUE, FALSE);   //PT1 exclure st
  //CalculTotaux();   //PT1 exclure st

  // Sur cellule "type de cotisation" affichage tablette
  LaGrille.ColFormats[1] := 'CB=PGTYPLIGNEDUCS';

  LaGrille.ColTypes[11] := 'D';
  LaGrille.ColFormats[11] := ShortDateFormat;
  LaGrille.ColAligns[11] := taCenter;

  // valeurs des colonnes num�riques cadr�es � droite de la cellule
  LaGrille.ColAligns[4] := taRightJustify;
  LaGrille.ColAligns[5] := taRightJustify;
  LaGrille.ColAligns[6] := taRightJustify;
  LaGrille.ColAligns[7] := taRightJustify;

  // la date de chgt. de taux est cadr�e au centre de la cellule
  LaGrille.ColAligns[11] := taCenter;

  // ElipsisButton mis en place pour recherche en table DUCSPARAM.
  // non op�rant en consultation
  LaGrille.ElipsisButton := FALSE;
  Action := Consultation;

  // "Codification" non modifiable.on se positionne sur la colonne "type"
  LaGrille.col := 1;

  if (TOB_Lignes <> nil) then
  begin
    LesLignes := TOB_Lignes.FindFirst([''], [''], TRUE);
    AlsaceMoselle :=  False;
    if ((TOB_Lignes.Detail.Count > 0) and
        (organisme = '001') and
        (LesLignes.GetValue('PDD_REGIMEALSACE')='X')) then
      AlsaceMoselle :=  True;

    // Alimentation de la grille des lignes d�tail

    Ligne := 1;
    Total := 0.0;

    while LesLignes <> nil do
    begin
      LaGrille.Cells[0, Ligne] := LesLignes.GetValue('PDD_CODIFICATION');
      LaGrille.CellValues[1, Ligne] := LesLignes.GetValue('PDD_TYPECOTISATION');
      LaGrille.Cells[2, Ligne] := Uppercase(LesLignes.GetValue('PDD_LIBELLE'));
      LaGrille.Cells[3, Ligne] := Uppercase(LesLignes.GetValue('PDD_LIBELLESUITE'));
      LaGrille.Cells[4, Ligne] := DoubleToCell(LesLignes.GetValue('PDD_EFFECTIF'), 0);
      LaGrille.Cells[5, Ligne] := DoubleToCell(LesLignes.GetValue('PDD_BASECOTISATION'), 2);

      if LaGrille.CellValues[1, Ligne] <> 'Q' then
        LaGrille.Cells[6, Ligne] := DoubleToCell(LesLignes.GetValue('PDD_TAUXCOTISATION'), 4)
      else
        LaGrille.Cells[6, Ligne] := DoubleToCell(LesLignes.GetValue('PDD_TAUXCOTISATION'), 0);

      LaGrille.Cells[7, Ligne] := StrfMontant(LesLignes.GetValue('PDD_MTCOTISAT'), 15, 2, '', TRUE);

      if (LaGrille.CellValues[1, Ligne] = 'A') then
        LaGrille.Cells[7, Ligne] := '';

{$IFDEF DUCS41}
      LaGrille.Cells[8, Ligne] := LesLignes.GetValue('PDD_COMURBAINE');
{$ELSE}
      LaGrille.Cells[8, Ligne] := LesLignes.GetValue('PDD_CODECOMMUNE');
{$ENDIF}
      LaGrille.Cells[9, Ligne] := LesLignes.GetValue('PDD_CONDITION');
      if (LesLignes.GetValue('PDD_CODIFEDITEE') <> '') or
        (LesLignes.GetValue('PDD_TYPECOTISATION') = 'S') then
        LaGrille.Cells[10, Ligne] := LesLignes.GetValue('PDD_CODIFEDITEE')
      else
        LaGrille.Cells[10, Ligne] := Copy(LesLignes.GetValue('PDD_CODIFICATION'), PosDebEd, LongEdit);
      DateChgtTaux := LesLignes.GetValue('PDD_DATECHGTTAUX');
      if (datechgttaux = IDate1900) then
        LaGrille.Cells[11, Ligne] := ''
      else
        LaGrille.Cells[11, Ligne] := DateToStr(LesLignes.GetValue('PDD_DATECHGTTAUX'));
      LaGrille.Cells[12, Ligne] := LesLignes.GetValue('PDD_INSTITUTION');
      Ligne := Ligne + 1;

      // exclure les ST du total
      if (LesLignes.GetValue('PDD_TYPECOTISATION') <> 'S') then
        Total := Total + LesLignes.GetValue('PDD_MTCOTISAT');


      LesLignes := TOB_Lignes.FindNext([''], [''], TRUE);
      LaGrille.RowCount := LaGrille.RowCount + 1;
    end; // fin while

    CalculTotaux(); 

    LaGrille.RowCount := LaGrille.RowCount - 1;

    // Lib�rartion de la TOB
    TOB_Lignes.Free;
    TOB_Lignes := nil;
  end;
  LaCellule := LaGrille.Cells[1, 1];

  // Calcul du nombre de pages d'�dition
  if (Ligne = 1) then
  begin
    Neant := TRUE;
    NbPages := 1;
  end
  else
  begin
    NbPages := LaGrille.RowCount div 22;
    if (NbPages * 22) < LaGrille.RowCount then NbPages := NbPages + 1;
  end;

  // Contr�le des dates Obligatoire s ou non en fct du type de DUCS
  {$IFDEF EAGLCLIENT}
  DbEdit1 := THEdit(GetControl('PDU_DATEEXIGIBLE'));
  DbEdit2 := THEdit(GetControl('PDU_DATELIMDEPOT'));
  DbEdit3 := THEdit(GetControl('PDU_DATEREGLEMENT'));
  DbEdit4 := THEdit(GetControl('PDU_PAIEMENT'));
  DbEdit5 := THEdit(GetControl('PDU_DATEPREVEL'));
  DbEdit6 := THEdit(GetControl('PDU_CESSATION'));
  DbEdit7 := THEdit(GetControl('PDU_CONTINUATION'));
  {$ELSE}
  DbEdit1 := THDBEdit(GetControl('PDU_DATEEXIGIBLE'));
  DbEdit2 := THDBEdit(GetControl('PDU_DATELIMDEPOT'));
  DbEdit3 := THDBEdit(GetControl('PDU_DATEREGLEMENT'));
  DbEdit4 := THDBEdit(GetControl('PDU_PAIEMENT'));
  DbEdit5 := THDBEdit(GetControl('PDU_DATEPREVEL'));
  DbEdit6 := THDBEdit(GetControl('PDU_CESSATION'));
  DbEdit7 := THDBEdit(GetControl('PDU_CONTINUATION'));
  {$ENDIF}

  if DbEdit1 <> nil then
    // Date EXIGIBLE
  begin
    DbEdit1.OnDblClick := DateElipsisclick;
    if (Nature = '300') or (Nature = '700') then
      // Obligatoire pour IRC et BTP
      DbEdit1.OnExit := ControlDateDucs;
  end;

  if DbEdit2 <> nil then
    // Date limite de d�p�t
  begin
    DbEdit2.OnDblClick := DateElipsisclick;
    if (Nature = '300') or (Nature = '600') or (Nature = '700') then
      // Obligatoire pour IRC, MSA et BTP
      DbEdit2.OnExit := ControlDateDucs;
  end;

  if DbEdit3 <> nil then
    // Date de r�glement (tjs obligatoire)
  begin
    DbEdit3.OnDblClick := DateElipsisclick;
    DbEdit3.OnExit := ControlDateDucs;
  end;

  if (DbEdit4 <> nil) then
    // Date de versement des salaires
  begin
    DbEdit4.OnDblClick := DateElipsisclick;
    if (Neant = FALSE) then
      // Pas obligatoire pour DUCS N�ant
      DbEdit4.OnExit := ControlDateDucs;
  end;

  if DbEdit5 <> nil then
    // Date de pr�l�vement (???)
  begin
    DbEdit5.OnDblClick := DateElipsisclick;
    DbEdit5.OnExit := ControlDateDucs;
  end;

  if DbEdit6 <> nil then
    // Date de Cessation d'activit�
  begin
    DbEdit6.OnDblClick := DateElipsisclick;
    //   if (Neant = TRUE) and (StrToDate(DBEdit6.text) <> IDate1900) then
       // uniqt. Ducs N�ant
    //      DbEdit6.OnExit:=ControlDateDucs;
  end;

  if DbEdit7 <> nil then
    // Date Continuation d'activit�
  begin
    DbEdit7.OnDblClick := DateElipsisclick;
    //   if (Neant = TRUE) then
       // Uniqt. DUCS N�ant
    //      DbEdit7.OnExit:=ControlDateDucs;
  end;

  if (GetControlText('PDU_TYPBORDEREAU') = '915') or
     (GetControlText('PDU_TYPBORDEREAU') = '916') or
     (GetControlText('PDU_TYPBORDEREAU') = '913') or
     (GetControlText('PDU_TYPBORDEREAU') = '914') then
  // D�clarations URSSAF
  begin
    SetControlProperty('TPDU_TOTAPPRENTI', 'Caption','Effectif exclu ');
  end;

  if (IndValid = TRUE) and (IndDelete = False) then
  begin
      // il faut contr�ler l'alimentation des champs obligatoires
      // --------------------------------------------------------
    ControlValid(NoSiret, CodApe, GpInterne, NoInterne);

  end;
  IndDelete := False;
end;    // fin OnLoadRecord

// Contr�le du code abr�g� de p�riode, Formatage du libell� de la p�riode en
// fonction du code abr�g� de p�riode
function TOM_DUCSENTETE.FormatLibellePeriode(Periode: string): string;
var
  An, Mois, Trimestre, LibPeriod: string;
  NumMois, IntMois, IntTrim: integer;
begin
  if Length(Trim(Periode)) <> 4 then
  begin
    PgiBox('Vous devez saisir 4 caract�res num�riques !', 'Code p�riode');
    result := '';
    exit;
  end;
  libperiod := '';
  An := copy(Periode, 1, 2);
  Mois := copy(Periode, 4, 1);
  IntMois := StrToInt(Mois);
  Trimestre := copy(Periode, 3, 1);
  IntTrim := StrToInt(Trimestre);
  if (IntMois > 3) or (IntTrim > 4) then
  begin
    PgiBox('Le mois ne doit pas- �tre > 3 et le trimestre � 4 !', 'Code p�riode : ' + Periode);
    result := '';
    exit;
  end;
  if (Mois <> '0') and (trimestre = '0') then
  begin
    PgiBox('Attention le trimestre est � z�ro !', 'Code p�riode : ' + Periode);
    result := '';
    exit;
  end
  else
    if (Mois <> '0') and (trimestre <> '0') then
    // Il s'agit d'une d�claration mensuelle
  begin
    NumMois := ((StrToInt(Trimestre) - 1) * 3) + StrToInt(Mois);
    Mois := IntToStr(NumMois);
    if Length(Mois) = 1 then Mois := '0' + Mois;
    libperiod := RechDom('PGMOIS', Mois, FALSE) + ' 20' + An;
  end
  else
    if (Mois = '0') and (Trimestre <> '0') then
    // Il s'agit d'une d�claration trimestrielle
    LibPeriod := Trimestre + ' TRIMESTRE 20' + An
  else
    if ((Mois = '0') and (Trimestre = '0')) then
    // Il s'agit d'une d�claration annuelle
    libperiod := 'ANNEE 20' + An;

  result := Uppercase(libperiod);
end;

// Mise � jour de l'ent�te DUCS et des lignes de DETAIL
// il faut contr�ler l'alimentation des champs  obligatoires
procedure TOM_DUCSENTETE.OnUpdateRecord;
var
  NoSiret, CodApe, GpInterne, NoInterne: string;

begin
  inherited;
  // il faut contr�ler l'alimentation des champs obligatoires
  // --------------------------------------------------------
  ControlValid(NoSiret, CodApe, GpInterne, NoInterne);

  // Mise � jour de la table DUCSDETAIL
  // ----------------------------------
  if LastError = 0 then
  begin
    if MajDucsDetail(NoSiret, CodApe, GpInterne, NoInterne) = FALSE then
    begin
      LastError := 1;
      PGIBox('! Attention, anomalie sur une ligne d�tail. ' + detmess,
        'Mis � jour impossible');
      // d PT120
      if TOB_Lignes <> nil then
      begin
        TOB_Lignes.Free;
        TOB_Lignes := nil;
      end;
      // f PT120

    end;
  end;
end;

// Choix date sur calendrier
procedure TOM_DUCSENTETE.DateElipsisclick(Sender: TObject);
var
  key: char;
begin
  if not (ds.state in [dsinsert, dsedit]) then ds.edit;
  key := '*';
  ParamDate(Ecran, Sender, Key);
end;

// Contr�le de la validit� des diff�rentes dates de la fiche (DUCSENTETE):
// -----------------------------------------------------------------------
// Elles doivent �tre comprises dans l'exercice en cours
procedure TOM_DUCSENTETE.ControlDateDucs(sender: TOBject);
var
  {$IFDEF EAGLCLIENT}
  DBEdit: THEdit;
  {$ELSE}
  DBEdit: THDBEdit;
  {$ENDIF}
// PT40 correction conseil MoisE, AnneeE, ComboExer: string;
// PT40  correction conseil DebExer, FinExer: TDateTime;
begin
  {$IFDEF EAGLCLIENT}
  DBEdit := THEdit(Sender);
  {$ELSE}
  DBEdit := THDBEdit(Sender);
  {$ENDIF}
  if DbEdit = nil then exit;

  if (DbEdit.text = '') or
     (DbEdit.text = DateToStr(Idate1900)) or
     not (IsValidDate(DbEdit.text)) then
    begin
      PgiBox('Date obligatoire!', 'Date erron�e : ' + DbEdit.text);
      SetField(DbEdit.name, GetField('PDU_DATEFIN'));
      SetFocusControl(DbEdit.name);
    end;
end;

// R�cup�ration des variables etab, organisme, DebPer et FinPer
// ------------------------------------------------------------
// utilis�es dans les diff�rentes requ�tes SQL d'acc�s aux tables
// � partir de l' Ent�te s�lectionn�e
function TOM_DUCSENTETE.InitVarRech(): Boolean;
var
  NbreJour: Integer;
  //   OkOk     : Boolean;
begin

  Etab := GetField('PDU_ETABLISSEMENT');
  Organisme := GetField('PDU_ORGANISME');

  DebPer := GetField('PDU_DATEDEBUT');
  FinPer := GetField('PDU_DATEFIN');

  NoDucs := GetField('PDU_NUM');

  //     OkOk := DiffMoisJour (DebPer,FinPer,NbreMois,NbreJour);
  DiffMoisJour(DebPer, FinPer, NbreMois, NbreJour);
  NbreMois := NbreMois + 1;
  result := True;

  NbSal := GetField('PDU_TOTFEMMES') + GetField('PDU_TOTHOMMES');
end;

//  Poc�dure dessinant les cellules
// --------------------------------
procedure TOM_DUCSENTETE.GrillePostDrawCell(ACol, ARow: Longint; Canvas: TCanvas; AState: TGridDrawState);
begin
  if (ARow <> 0) then
  begin
    if ZoneGrise(ACol, ARow) then GridGriseCell(LaGrille, Acol, Arow, Canvas)
    else GridDeGriseCell(LaGrille, Acol, Arow, Canvas);
  end; 
end;

// On grise les cellules inaccessibles
// -----------------------------------
function TOM_DUCSENTETE.ZoneGrise(ACol, ARow: Integer): Boolean;
var
  TypeCot: string;
begin
  result := FALSE;

  // Les cellules Codification et type de cotisation sont inaccessibles en consultation
  if ((Action = Consultation) and (Arow <> 0) and (Arow < Ligne) and ((Acol = 0) or (Acol = 1))) or
     ((Action = Creation) and (Arow <> 1) and (Arow < Ligne) and
      (LaGrille.Cells[0, Arow] <> '') and ((Acol = 0) or (Acol = 1))) then
    result := TRUE;

  // La cellule "Communaut� Urbaine" n'est accessible que pour les DUCS URSSAF
  if (nature <> '100') and (Acol = 8) then
  begin
    result := TRUE;
  end;
  // Les cellules "Condition sp�ciale de cotisation" et "Institution" ne sont
  // accessibles que pour les DUCS IRC
  if (nature <> '300') and ((Acol = 9) or (Acol = 12)) then
  begin
    result := TRUE;
  end;

  // Certaines cellules sont inaccessibles en fonction du type de cotisation
  TypeCot := LaGrille.CellValues[1, Arow];
  // Effectif
  if (Acol = 4) and ((TypeCot = 'I') or // Intitul�
    (TypeCot = 'S') or // Sous Total
    (TypeCot = 'A')) then // Taux
    result := TRUE;
  // Base
  if (Acol = 5) and ((TypeCot = 'M') or // Montant
    (TypeCot = 'A') or // Taux
    (TypeCot = 'S') or // Sous Total
    (TypeCot = 'I')) then // Intitul�
    result := TRUE;
  // Taux
  if (Acol = 6) and ((TypeCot = 'M') or // Montant
    (TypeCot = 'B') or // Base
    (TypeCot = 'S') or // Sous Total
    (TypeCot = 'I')) then // Intitul�
    result := TRUE;
  // Montant
  if (Acol = 7) and ((TypeCot = 'B') or // Base
    (TypeCot = 'A') or // Taux
    (TypeCot = 'I')) then // Intitul�
    result := TRUE;
  //Date de chgt de taux
  if (Acol = 11) and ((TypeCot = 'S') or // Sous Total
    (TypeCot = 'I') or // Intitul�
    (TypeCot = 'B') or // Base
    (TypeCot = 'M') or // Montant
    (TypeCot = 'Q')) then // Quantit�
    result := TRUE;
end;

// OnClick sur la Grille
// ---------------------
procedure TOM_DUCSENTETE.GrilleClick(Sender: TObject);
begin
  // En consultation la cellule "Codification" n'est pas modifiable
  // on se positionne sur la cellule suivante
  if (((LaGrille.col = 0) or (LaGrille.col = 1)) and (Action <> Creation)) then
    LaGrille.col := LaGrille.col + 1;

  if (LaGrille.col = 11) then
  LaGrille.ElipsisButton := True;
end;

// Entr�e sur une ligne de la Grille
// ---------------------------------
procedure TOM_DUCSENTETE.GrilleRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
var
  codif: string;
  Q: TQuery;
begin
  // arrondi
  BaseArr := WbaseArr;
  MontArr := WMontArr;
  // R�cup. de la valeur des champs de DUCSPARAM
  Codif := LaGrille.Cells[0, LaGrille.row];
  if (Codif <> '') then
  begin

    if (AlsaceMoselle) then
      Q := OpenSql('SELECT PDP_CODIFALSACE, PDP_TYPECOTISATION, PDP_LIBELLE,' +
                   ' PDP_LIBELLESUITE, PDP_BASETYPARR, PDP_MTTYPARR' +
                   ' FROM DUCSPARAM ' +
                   'WHERE PDP_CODIFALSACE="' + Codif + '"', True)
    else
      Q := OpenSql('SELECT PDP_CODIFICATION, PDP_TYPECOTISATION, PDP_LIBELLE,' +
                   ' PDP_LIBELLESUITE, PDP_BASETYPARR, PDP_MTTYPARR' +
                   ' FROM DUCSPARAM ' +
                   'WHERE PDP_CODIFICATION="' + Codif + '"', True);

    if not Q.eof then
    begin
      if (Action = Creation) then
      begin
        // En cr�ation de ligne (insertion) r�cup type et libell�s
        LaGrille.CellValues[1, LaGrille.row] := Q.FindField('PDP_TYPECOTISATION').AsString;
        LaGrille.Cells[2, LaGrille.row] := Uppercase(Q.FindField('PDP_LIBELLE').AsString);
        LaGrille.Cells[3, LaGrille.row] := Uppercase(Q.FindField('PDP_LIBELLESUITE').AsString);
        LaGrille.Cells[10, LaGrille.row] := Copy(Codif, PosDebEd, LongEdit);
      end;

      // R�cup des type d'arrondis si renseign�s
      if (Q.FindField('PDP_BASETYPARR').AsString <> '') then
        BaseArr := Q.FindField('PDP_BASETYPARR').AsString;
      if (Q.FindField('PDP_MTTYPARR').AsString <> '') then
        MontArr := Q.FindField('PDP_MTTYPARR').AsString;

    end;
    Ferme(Q);
  end;
end;

// Sortie de ligne
// ---------------
procedure TOM_DUCSENTETE.GrilleRowExit(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
begin
  // On force le mode de tratement � "Consultation"
  Action := Consultation;
end;

// clique sur cellule avec elipsis
// -------------------------------
procedure TOM_DUCSENTETE.GrilleElipsisClick(Sender: TObject);
var
  sWhere, nat, codif: string;

begin
  // Affichage de la listes des codifications possibles
  // On s�lectionne les codifications rattach�es � la nature de DUCS
  // Pour info. nature 100 : URSSAF -> codif. 1.......
  //                   200 : ASSEDIC -> codif. 2......
  //                   300 : IRC -> codif. 3...... (AGIRC) ou 4...... (ARRCO)
  //                                5...... (Pr�voyance)
  //                   600 : MSA -> codif. 6......
  //                   700 : BTP -> codif. 7......
  nat := '';
  if (LaGrille.col = 0) then
  begin
    if (nature = '300') then
      nat := 'PDP_CODIFICATION BETWEEN "3" AND "6" OR PDP_CODIFICATION LIKE "8%"'
    else
    begin
      if (AlsaceMoselle) then
        nat := 'PDP_CODIFALSACE LIKE "' + copy(Nature, 1, 1) + '%"'
      else
        nat := 'PDP_CODIFICATION LIKE "' + copy(Nature, 1, 1) + '%"';
    end;

    sWhere := '';
    swhere := '##PDP_PREDEFINI## ' + nat;

    if (AlsaceMoselle) then
      LookUpList(LaGrille, 'Codifications', 'DUCSPARAM', 'PDP_CODIFALSACE', 'PDP_LIBELLE', sWhere, 'PDP_CODIFALSACE', TRUE, -1)
    else
      LookUpList(LaGrille, 'Codifications', 'DUCSPARAM', 'PDP_CODIFICATION', 'PDP_LIBELLE', sWhere, 'PDP_CODIFICATION', TRUE, -1);
  end;

  // Affichage de la liste des Code Communaut�s Urbaines
  if (LaGrille.col = 8) then
  begin
    sWhere := '';
    swhere := 'CO_TYPE = "PUC"';
    LookUpList(LaGrille, 'Codes communaut�s urbaines', 'COMMUN', 'CO_ABREGE', 'CO_LIBELLE', sWhere, 'CO_ABREGE', TRUE, -1);
  end;

  // Affichage de la liste des Conditions sp�ciales de cotisation
  if (LaGrille.col = 9) then
  begin
    sWhere := '';
    swhere := 'CO_TYPE = "PDU"';
    LookUpList(LaGrille, 'Conditions sp�ciales de cotisation', 'COMMUN', 'CO_CODE', 'CO_LIBELLE', sWhere, 'CO_CODE', TRUE, -1);
  end;

  // Affichage de la liste des institutions
  if (LaGrille.col = 12) then
  begin
    codif := Copy(LaGrille.Cells[0, LaGrille.row], 1, 2);

    sWhere := '';
    if (codif = '30') then
      sWhere := 'PIP_INSTITUTION LIKE "' + 'C' + '%"'; // Institions AGIRC

    if (codif = '40') then
      sWhere := 'PIP_INSTITUTION LIKE "' + 'A' + '%"'; // Institutions ARRCO

    LookUpList(LaGrille, 'Institutions', 'INSTITUTIONPAYE', 'PIP_INSTITUTION', 'PIP_ABREGE', sWhere, 'PIP_INSTITUTION', TRUE, -1);
  end;
  if (LaGrille.col = 11) and (LaGrille.row <> 0) then
    DateElipsisclick(Sender);
end;

// Double click sur une cellule du type date de la grille
// ------------------------------------------------------
// Si cellule "Date de chgt. de taux" affichage calendrier
procedure TOM_DUCSENTETE.GrilleDblClick(Sender: TObject);
begin
  if (LaGrille.col = 11) and (LaGrille.row <> 0) then
    DateElipsisclick(Sender);
end;

//  Sortie de cellule
// ------------------
procedure TOM_DUCSENTETE.GrilleCellExit(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
var
  Codif, TypeCot: string;
  Q: TQuery;
  Predef: string;
// d PT40
{$IFDEF EAGLCLIENT}
  KK, SortDos: Integer;
  MaTob: TOB;
{$ENDIF}
// f PT40

begin
  // arrondi
  BaseArr := WbaseArr;
  MontArr := WMontArr;

  // R�cup. de la valeur des champs de DUCSPARAM
  if (Action = Creation) and (Acol = 0) then
  begin
    Codif := LaGrille.Cells[0, LaGrille.row];
    if (Codif <> '') then
    begin
      if (AlsaceMoselle) then
        Q := OpenSql('SELECT PDP_PREDEFINI,PDP_CODIFALSACE, PDP_TYPECOTISATION, PDP_LIBELLE,' +
                     ' PDP_LIBELLESUITE, PDP_BASETYPARR, PDP_MTTYPARR' +
                     ' FROM DUCSPARAM ' +
                     'WHERE ##PDP_PREDEFINI## PDP_CODIFALSACE="' + Codif + '"', True)
      else
        Q := OpenSql('SELECT PDP_PREDEFINI,PDP_CODIFICATION, PDP_TYPECOTISATION, PDP_LIBELLE,' +
                     ' PDP_LIBELLESUITE, PDP_BASETYPARR, PDP_MTTYPARR' +
                     ' FROM DUCSPARAM ' +
                     'WHERE ##PDP_PREDEFINI## PDP_CODIFICATION="' + Codif + '"', True);
      Predef := '';
// d PT40
{$IFDEF EAGLCLIENT}
      SortDos := 0;
      KK := 0;
{$ENDIF}
      while not Q.eof do
      begin
        Predef := Q.FindField('PDP_PREDEFINI').AsString;
        if (Predef = 'DOS') then
        begin
{$IFDEF EAGLCLIENT}
          SortDos := 1;
{$ENDIF}
          break;
        end;
{$IFDEF EAGLCLIENT}
        KK := KK + 1;
{$ENDIF}
        Q.Next;
      end;

// d PT41
      if (Predef <> '') then
      begin
// f PT41
{$IFDEF EAGLCLIENT}
      if (SortDos = 1)  then
        MaTob := Q.Detail[Q.Detail.count - 1]
      else
        MaTob := Q.Detail[KK - 1];
{$ENDIF}

{PT41      if (Predef <> '') then
      begin}
      // En cr�ation de ligne (insertion) r�cup type et libell�s
{$IFNDEF EAGLCLIENT}
        LaGrille.CellValues[1, LaGrille.row] := Q.FindField('PDP_TYPECOTISATION').AsString;
        LaGrille.Cells[2, LaGrille.row] := Uppercase(Q.FindField('PDP_LIBELLE').AsString);
        LaGrille.Cells[3, LaGrille.row] := Uppercase(Q.FindField('PDP_LIBELLESUITE').AsString);

        // R�cup des type d'arrondis si renseign�s
        if (Q.FindField('PDP_BASETYPARR').AsString <> '') then
          BaseArr := Q.FindField('PDP_BASETYPARR').AsString;
        if (Q.FindField('PDP_MTTYPARR').AsString <> '') then
          MontArr := Q.FindField('PDP_MTTYPARR').AsString;
{$ELSE}
        LaGrille.CellValues[1, LaGrille.row] := MaTob.GetValue('PDP_TYPECOTISATION');
        LaGrille.Cells[2, LaGrille.row] := Uppercase(MaTob.GetValue('PDP_LIBELLE'));
        LaGrille.Cells[3, LaGrille.row] := Uppercase(MaTob.GetValue('PDP_LIBELLESUITE'));

        // R�cup des type d'arrondis si renseign�s
        if (MaTob.GetValue('PDP_BASETYPARR') <> '') then
          BaseArr := MaTob.GetValue('PDP_BASETYPARR');

        if (MaTob.GetValue('PDP_MTTYPARR') <> '') then
          MontArr := MaTob.GetValue('PDP_MTTYPARR');
{$ENDIF}
// f PT40

      end;
      LaGrille.Cells[10, LaGrille.row] := Copy(Codif, PosDebEd, LongEdit);
// d PT40
{$IFDEF EAGLCLIENT}
      if (Assigned(MaTob)) then
        FreeandNil (MaTob);
{$ENDIF}
// f PT40
      Ferme(Q);
    end;
  end;

  // r�cup. du type de cotisation
  TypeCot := LaGrille.CellValues[1, Arow];

  if LaCellule <> LaGrille.Cells[ACol, ARow] then
    // La valeur de la cellule a chang�
  begin
    // On passe en ds.edit pour forcer la mise � jour
    if not (ds.state in [dsinsert, dsedit]) then ds.edit;

    // sortie de la cellule type de cotisation
    if (Acol = 1) then
    begin
      // Certaines cellules sont inaccesibles en fonction du type de cotisation
      if (TypeCot = 'I') then // Intitutl�
      begin
        LaGrille.Cells[4, Arow] := ''; //effectif
        LaGrille.Cells[5, Arow] := ''; //Base
        LaGrille.Cells[6, Arow] := ''; //Taux
        LaGrille.Cells[7, Arow] := ''; //Montant
      end;
      if (TypeCot = 'M') then // Montant
      begin
        LaGrille.Cells[5, Arow] := ''; //Base
        LaGrille.Cells[6, Arow] := ''; //Taux
      end;

      if (TypeCot = 'A') then // Taux
      begin
        LaGrille.Cells[4, Arow] := ''; //Effectif
        LaGrille.Cells[5, Arow] := ''; //Base
        LaGrille.Cells[7, Arow] := ''; //Montant
      end;

      if (TypeCot = 'S') then // Sous Total
      begin
        LaGrille.Cells[5, Arow] := ''; //Base
        LaGrille.Cells[6, Arow] := ''; //Taux
      end;

      if (TypeCot = 'B') then // Base
      begin
        LaGrille.Cells[6, Arow] := ''; //Taux
        LaGrille.Cells[7, Arow] := ''; //Montant
      end;
    end;
  end;

  // formatage des diff�rentes cellules num�riques
  if (Acol = 4) or (Acol = 5) or (Acol = 6) or (Acol = 7) then
    FormatZoneNum(Acol, Arow);

  // Les cellules libell� sont forc�es en MAJUSCULES
  if (Acol = 2) or (Acol = 3) then
    LaGrille.Cells[Acol, Arow] := Uppercase(LaGrille.Cells[Acol, Arow]);

  // La Base ou le Taux ont �t� modif�s, il faut recalculer le montant et les Totaux
  if (Acol = 5) or (Acol = 6) then
  begin
    if (LaGrille.col = Acol + 1) then
    begin
      Total := Total - Valeur(LaGrille.Cells[7, Arow]);
      if (LaGrille.Cells[5, Arow] <> '') and (LaGrille.Cells[6, Arow] <> '') then
        LaGrille.Cells[7, Arow] :=
          DoubleToCell(((Valeur(LaGrille.Cells[5, Arow]) *
          Valeur(LaGrille.Cells[6, Arow])) / 100.0), 2);

      FormatZoneNum(7, Arow);
      if (TypeCot <> 'S') then
        Total := Total + Valeur(LaGrille.Cells[7, Arow]);
      CalculTotaux();
    end;
  end;

  // Le Montant est modifi� donc on recalcul les Totaux
  //    --> recalcul cellule 7 + CalculTotaux
  if (Acol = 7) then
  begin
    if (LaGrille.col = Acol + 1) and (TypeCot <> 'S') then
    begin
      // Total d�clar� = Totald�clar�
      //                 - Ancienne valeur de la cellule
      //                 + Nouvelle valeur de la cellule
      Total := Total - Valeur(LaCellule) + Valeur(LaGrille.Cells[Acol, Arow]);
      CalculTotaux();
    end;
  end;

  // La Cellule "Type de cotisation" doit �tre obligatoirement renseign�e
  if (Acol = 1) and (LaGrille.Cells[Acol, Arow] = '') then
    LaGrille.col := LaGrille.col - 1
  else
    // Le type Sous-Total n'est pas autoris� si le champ POG_SOUSTOTDUCS est � FALSE
    if ((Acol = 1) or (Acol = 0)) and (SousTot = FALSE) and (TypeCot = 'S') then
  begin
    PGIBox('Les lignes de type "Sous Total" ne sont pas autoris�es pour cette DUCS', 'Insertion de ligne');
    Action := Consultation;
    if (LaGrille.Row <> 0) and (LaGrille.Row < Ligne) then
    begin
      LaGrille.DeleteRow(LaGrille.Row);
      Ligne := Ligne - 1;
    end;

    if (Ligne = 1) then
      Neant := True
    else
      Neant := False;
    if (LaGrille.col <> 0) then LaGrille.col := LaGrille.col - 1;
  end;

  // En sortie des cellules "Codification" , "Communaut� Urbaine", "Condition
  // sp�ciale de cotisation", "institution" on enl�ve l'elpipsis
  if (Acol = 0) or (Acol = 8) or (Acol = 9) or (Acol = 12) then
    LaGrille.ElipsisButton := FALSE;

end;

// "Entr�e sur une cellule"
// ------------------------
procedure TOM_DUCSENTETE.GrilleCellEnter(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
begin
  LaCellule := LaGrille.Cells[LaGrille.col, LaGrille.row];
  // La cellule "Codificaton" n'est accessible qu'en mode Creation (insertion)
  if (LaGrille.col = 0) then
    if (Action = Consultation) then
    begin
      LaGrille.ElipsisButton := FALSE;
      LaGrille.col := LaGrille.col + 1;
    end
    else
      LaGrille.ElipsisButton := TRUE;

  // La cellule "Communaut� urbaine" n'est accessible que pour des DUCS de type URSSAF
  // les cellules "Conditions sp�ciales de cotisation" et "institution" ne sont
  // accessibles que pour des DUCS de type IRC

  // En fct du type de cotistion certaines cellules sont inaccessibles
  if ZoneGrise(LaGrille.col, LaGrille.row) then
  begin
    if (LaGrille.col = LaGrille.ColCount - 1) then
    begin
      // En fin de ligne on se positionne au d�but de la ligne suivante
      LaGrille.col := 0;
      if (LaGrille.row <> LaGrille.RowCount - 1) then
        LaGrille.row := LaGrille.row + 1;
    end
    else
      LaGrille.col := LaGrille.col + 1;
  end;

          if (LaGrille.col = 8) or (LaGrille.col = 9) or (LaGrille.col = 12) or (LaGrille.col = 11)then
    LaGrille.ElipsisButton := TRUE;
end;

// Insertion d'une ligne d�tail
// ----------------------------
procedure TOM_DUCSENTETE.BTnInsClick(Sender: TObject);
begin
  Action := creation;
  LaGrille.InsertRow(1);
  LaGrille.Col := 0;
  LaGrille.Row := 1;
  LaCellule := LaGrille.Cells[LaGrille.Col, LaGrille.row];
  LaGrille.ElipsisButton := TRUE;
  Ligne := Ligne + 1;

  if (Ligne = 1) then
    Neant := True
  else
    Neant := False;

  // On passe en ds.edit pour forcer la mise � jour
  if not (ds.state in [dsinsert, dsedit]) then ds.edit;
end;

// suppression d'une ligne d�tail
// ------------------------------
procedure TOM_DUCSENTETE.BTnDelClick(Sender: TObject);
begin
  if (LaGrille.Row <> 0) and (LaGrille.Row < Ligne) then
  begin
    LaGrille.DeleteRow(LaGrille.Row);
    Ligne := Ligne - 1;
  end;

  if (Ligne = 1) then
    Neant := True
  else
    Neant := False;
  // On passe en ds.edit pour forcer la mise � jour
  if not (ds.state in [dsinsert, dsedit]) then ds.edit;
end;

// Impression d'une DUCS
// ---------------------
procedure TOM_DUCSENTETE.BTImprimer(Sender: TObject);
var
  StSql, StWhere: string;
  Pages: TPageControl;
begin
  // il faut contr�ler l'alimentation des champs  obligatoires

  if not (ds.state in [dsinsert, dsedit]) then ds.edit;
  TFFiche(Ecran).BValiderClick(Sender);

  if LastError = 0 then
  // Edition
  begin

    StSQL := '';
    Pages := TPageControl(GetControl('Pages'));
    StWhere := 'WHERE ' +
      '(PDU_ETABLISSEMENT ="' + Etab + '") AND ' +
      '(PDU_ORGANISME ="' + organisme + '") AND ' +
      '(PDU_DATEDEBUT ="' + UsDateTime(DebPer) + '") AND ' +
      '(PDU_DATEFIN = "' + UsDateTime(FinPer) + '") AND ' +
    '(PDU_NUM =' + NoDucs + ') ';// DB2
    if (Neant = TRUE) then
    begin
      StSQL := 'SELECT DUCSENTETE.*, ' +
        'ET_ETABLISSEMENT, ET_LIBELLE, ET_ADRESSE1, ET_ADRESSE2, ET_ADRESSE3, ' +
        'ET_CODEPOSTAL, ET_VILLE, ET_TELEPHONE, ET_FAX, ' +
        'POG_ETABLISSEMENT, POG_ORGANISME, POG_LIBELLE, POG_NATUREORG, ' +
        'POG_ADRESSE1, POG_ADRESSE2, POG_ADRESSE3, POG_CODEPOSTAL, ' +
        'POG_PERIODICITDUCS, POG_AUTREPERIODUCS, POG_PERIODCALCUL, POG_AUTPERCALCUL, ' +
        'POG_POSTOTAL,POG_LONGTOTAL,' +
      'POG_VILLE , POG_LONGEDITABLE ,POG_BASETYPARR,' +
        'POG_MTTYPARR ' +
        'FROM DUCSENTETE ' +
        'LEFT JOIN ETABLISS ON PDU_ETABLISSEMENT = ET_ETABLISSEMENT ' +
        'LEFT JOIN ORGANISMEPAIE ON PDU_ETABLISSEMENT = POG_ETABLISSEMENT ' +
        'AND PDU_ORGANISME = POG_ORGANISME ' +
        StWhere;

      FunctPGDebEditDucs();
      LanceEtat('E', 'PDU', 'DUN', True, False, False, Pages, StSQL, '', False);
      FunctPGFinEditDucs();
    end
    else
    begin
      StSQL := 'SELECT DUCSENTETE.*,PDD_CODIFICATION,PDD_CODIFEDITEE, ' +
        'PDD_LIBELLE, PDD_BASECOTISATION,PDD_TAUXCOTISATION, PDD_MTCOTISAT, ' +
        'PDD_EFFECTIF, PDD_TYPECOTISATION, PDD_INSTITUTION, ' +
        'PDD_LIBELLESUITE, ' +
      'ET_ETABLISSEMENT, ET_LIBELLE, ET_ADRESSE1, ET_ADRESSE2, ET_ADRESSE3, ' +
        'ET_CODEPOSTAL, ET_VILLE, ET_TELEPHONE, ET_FAX, ' +
        'POG_ETABLISSEMENT, POG_ORGANISME, POG_LIBELLE, POG_NATUREORG, ' +
        'POG_ADRESSE1, POG_ADRESSE2, POG_ADRESSE3, POG_CODEPOSTAL, ' +
        'POG_PERIODICITDUCS, POG_AUTREPERIODUCS, POG_PERIODCALCUL, POG_AUTPERCALCUL, ' +
        'POG_POSTOTAL,POG_LONGTOTAL,' +
      'POG_VILLE , POG_LONGEDITABLE,POG_BASETYPARR,' +
        'POG_MTTYPARR ' +
        'FROM DUCSENTETE ' +
        'LEFT JOIN ETABLISS ON PDU_ETABLISSEMENT = ET_ETABLISSEMENT ' +
        'LEFT JOIN ORGANISMEPAIE ON PDU_ETABLISSEMENT = POG_ETABLISSEMENT ' +
        'AND PDU_ORGANISME = POG_ORGANISME ' +
        'LEFT JOIN DUCSDETAIL ON  PDU_ETABLISSEMENT =  PDD_ETABLISSEMENT ' +
        'AND PDU_ORGANISME = PDD_ORGANISME AND PDU_DATEDEBUT = PDD_DATEDEBUT ' +
        'AND PDU_DATEFIN = PDD_DATEFIN AND PDU_NUM = PDD_NUM ' + StWhere + ' ' +
      'ORDER BY PDU_ETABLISSEMENT,PDU_ORGANISME,PDU_DATEDEBUT,PDU_DATEFIN,' +
        'PDD_INSTITUTION,PDD_CODIFICATION';
      FunctPGDebEditDucs();
      LanceEtat('E', 'PDU', 'DUC', True, False, False, Pages, StSQL, '', False);
      FunctPGFinEditDucs();
    end;
  end;

  if (organisme = '002') and
    (DucsDoss = True) and
    (PaieGroupe = True) and
    (Neant = False) then
  begin
    EditVLU(Debper, FinPer, Organisme, Pages, False, True, StSQL);
  end;

end;

// Quand Bouton Bdefaire, pour que le bouton Valider soit op�rationnel
// -------------------------------------------------------------------
procedure TOM_DUCSENTETE.OnCancelRecord;
begin
  OnLoadRecord;
end;

// mise � jour de la table DUCSDETAIL � partir de la grille
// --------------------------------------------------------
function TOM_DUCSENTETE.MajDucsDetail(NoSiret, CodApe, GpInterne, NoInterne: string): Boolean;
var
  StrDelDetail, StrInsDetail, TypeCot: string;
  ligneMaj: Integer;
begin
  result := TRUE;
  detmess := '';
  StrDelDetail := '';
  StrInsDetail := '';

  // Chargement de la TOB des Lignes D�tail
  TOB_Lignes := TOB.Create('Les lignes de cotisation', nil, -1);

  //For ligne := 1 to LaGrille.RowCount-1 do
  for ligneMaj := 1 to Ligne - 1 do

  begin // Constitution de la TOB Virtuelle
    // Contr�le des champs obligatoires
    TypeCot := LaGrille.CellValues[1, ligneMaj];

    if (TypeCot = 'S') and (SousTot = FALSE) then
    begin
      PGIBox('Les lignes de type "Sous Total" ne sont pas autoris�es pour cette DUCS', 'Insertion de ligne');
      result := FALSE;
      detmess := detmess + '#13#10 Les lignes de type "Sous Total" ne sont pas autoris�es pour cette DUCS';
      exit;
    end;

    if ((LaGrille.Cells[0, ligneMaj] <> '') and // codif.
      (LaGrille.CellValues[1, ligneMaj] <> '') and // Type  de cotisation
      (LaGrille.Cells[2, ligneMaj] <> '')) and // Libell� cotisation

    ((((TypeCot = 'I') or (TypeCot = 'A') or (TypeCot = 'S')) and // Effectif
      (LaGrille.CellValues[4, ligneMaj] = '')) or
      ((TypeCot <> 'I') and (TypeCot <> 'A') and (TypeCot <> 'S') and
      (LaGrille.CellValues[4, ligneMaj] <> ''))) and

    ((((TypeCot = 'T') or (TypeCot = 'B')) and // Base
      (LaGrille.CellValues[5, ligneMaj] <> '')) or
      ((TypeCot <> 'T') and (TypeCot <> 'B') and
      (LaGrille.CellValues[5, ligneMaj] = '')) or
      ((TypeCot = 'Q') and
      (LaGrille.CellValues[5, ligneMaj] = '') or
      (LaGrille.CellValues[5, ligneMaj] <> '')) or
      ((TypeCot = 'M') and
      (LaGrille.CellValues[5, ligneMaj] = '') or
      (LaGrille.CellValues[5, ligneMaj] <> ''))) and

    ((((TypeCot = 'T') or (TypeCot = 'Q') or (TypeCot = 'A')) and // Taux
      (LaGrille.CellValues[6, ligneMaj] <> '')) or
      ((TypeCot <> 'T') and (TypeCot <> 'Q') and (TypeCot <> 'A') and
      (LaGrille.CellValues[6, ligneMaj] = '')) or
      ((TypeCot = 'M') and
      (LaGrille.CellValues[6, ligneMaj] = '') or
      (LaGrille.CellValues[6, ligneMaj] <> '')))
    then
    begin
      TOB_FilleLignes := TOB.create('DUCSDETAIL', TOB_Lignes, -1);

      TOB_FilleLignes.PutValue('PDD_ETABLISSEMENT', etab);
      TOB_FilleLignes.PutValue('PDD_ORGANISME', organisme);
      TOB_FilleLignes.PutValue('PDD_DATEDEBUT', DebPer);
      TOB_FilleLignes.PutValue('PDD_DATEFIN', FinPer);
      TOB_FilleLignes.PutValue('PDD_NUMORDRE', ligneMaj);
      TOB_FilleLignes.PutValue('PDD_NUM', NoDucs);
      TOB_FilleLignes.PutValue('PDD_CODIFICATION', LaGrille.Cells[0, ligneMaj]);
      TOB_FilleLignes.PutValue('PDD_TYPECOTISATION', LaGrille.CellValues[1, ligneMaj]);
      TOB_FilleLignes.PutValue('PDD_LIBELLE', LaGrille.Cells[2, ligneMaj]);
      TOB_FilleLignes.PutValue('PDD_LIBELLESUITE', LaGrille.Cells[3, ligneMaj]);
      if (LaGrille.CellValues[4, ligneMaj] <> '') then
        TOB_FilleLignes.PutValue('PDD_EFFECTIF', (LaGrille.Cells[4, ligneMaj]))
      else
        TOB_FilleLignes.PutValue('PDD_EFFECTIF', 0);


      if (LaGrille.CellValues[5, ligneMaj] <> '') then
        TOB_FilleLignes.PutValue('PDD_BASECOTISATION', Valeur(LaGrille.Cells[5, ligneMaj]))
      else
        TOB_FilleLignes.PutValue('PDD_BASECOTISATION', 0);

      if (LaGrille.CellValues[6, ligneMaj] <> '') then
        TOB_FilleLignes.PutValue('PDD_TAUXCOTISATION', Valeur(LaGrille.Cells[6, ligneMaj]))
      else
        TOB_FilleLignes.PutValue('PDD_TAUXCOTISATION', 0);
      if (LaGrille.CellValues[7, ligneMaj] <> '') then
        TOB_FilleLignes.PutValue('PDD_MTCOTISAT', Valeur(LaGrille.Cells[7, ligneMaj]))
      else
        TOB_FilleLignes.PutValue('PDD_MTCOTISAT', 0);

{$IFDEF DUCS41}
      TOB_FilleLignes.PutValue('PDD_COMURBAINE', LaGrille.Cells[8, ligneMaj]);
{$ELSE}
      TOB_FilleLignes.PutValue('PDD_CODECOMMUNE', LaGrille.Cells[8, ligneMaj]);
{$ENDIF}
      TOB_FilleLignes.PutValue('PDD_CONDITION', LaGrille.Cells[9, ligneMaj]);
      TOB_FilleLignes.PutValue('PDD_SIRET', NoSiret);
      TOB_FilleLignes.PutValue('PDD_APE', CodApe);
      TOB_FilleLignes.PutValue('PDD_NUMERO', NoInterne);
      TOB_FilleLignes.PutValue('PDD_GROUPE', GpInterne);
      TOB_FilleLignes.PutValue('PDD_CODIFEDITEE', LaGrille.Cells[10, ligneMaj]);
      if (LaGrille.Cells[11, ligneMaj] = '') then
        TOB_FilleLignes.PutValue('PDD_DATECHGTTAUX', IDate1900)
      else
        TOB_FilleLignes.PutValue('PDD_DATECHGTTAUX', StrToDate(LaGrille.Cells[11, ligneMaj]));
      TOB_FilleLignes.PutValue('PDD_INSTITUTION', LaGrille.Cells[12, ligneMaj]);

    end
    else
    begin
      result := FALSE;
      detmess := detmess + '#13#10  Au moins une information obligatoire absente ';
      exit;
    end;
  end;
  try
    begintrans;

    if TOB_Lignes <> nil then TOB_Lignes.SetAllModifie(TRUE);
    StrDelDetail := 'DELETE FROM DUCSDETAIL ' +
      'WHERE ' +
      '(PDD_ETABLISSEMENT ="' + etab + '") AND ' +
      '(PDD_ORGANISME ="' + organisme + '") AND ' +
      '(PDD_DATEDEBUT ="' + UsDateTime(DebPer) + '") AND ' +
      '(PDD_DATEFIN = "' + UsDateTime(FinPer) + '") AND ' +
      '(PDD_NUM = ' + NoDucs + ') ';

    ExecuteSQL(StrDelDetail);

    // fin exclure les ST du total
    Total := 0.0;
    LesLignes := TOB_Lignes.FindFirst([''], [''], TRUE);
    while LesLignes <> nil do
    begin
      if (LesLignes.GetValue('PDD_TYPECOTISATION') <> 'S') then
        Total := Total + LesLignes.GetValue('PDD_MTCOTISAT');
      LesLignes := TOB_Lignes.FindNext([''], [''], TRUE);
    end;
    // fin exclure les ST du total
    CalculTotaux();

    result := TOB_Lignes.InsertDB(nil, FALSE);
    if TOB_Lignes <> nil then
    begin
      TOB_Lignes.Free;
      TOB_Lignes := nil;
    end;

    // Calcul du nombre de pages d'�dition
    NbPages := LaGrille.RowCount div 22;
    if (NbPages * 22) < LaGrille.RowCount then NbPages := NbPages + 1;
    SetField('NBPAGE', NbPages);

    Committrans;

  except
    Rollback;
    PGIBox('! Erreur maj table DUCSDETAIL', '');
  end;
end;

// Calcul du total d�clar� et du total � payer
//--------------------------------------------
// Total d�clar� = Somme des Montant de cotisation de chaque ligne d�tail
// Total � payer = Total d�clar� - Acomptes + R�gularisations
function TOM_DUCSENTETE.CalculTotaux(): Boolean;
var
  {$IFDEF EAGLCLIENT}
  THAcompte, THRegul: THEdit;
  {$ELSE}
  THAcompte, THRegul: THDBEdit;
  {$ENDIF}

begin
  result := TRUE;

  APayer := 0.0;
  Acompte := 0.0;
  Regularisation := 0.0;

  {$IFDEF EAGLCLIENT}
  THAcompte := THEdit(GetControl('PDU_ACOMPTES'));
  THRegul := THEdit(GetControl('PDU_REGULARISATION'));
  {$ELSE}
  THAcompte := THDBEdit(GetControl('PDU_ACOMPTES'));
  THRegul := THDBEdit(GetControl('PDU_REGULARISATION'));
  {$ENDIF}
  if (THAcompte <> nil) and (THAcompte.text <> '') then
    Acompte := Valeur(THAcompte.text);
  if (THRegul <> nil) and (THRegul.text <> '') then
    Regularisation := Valeur(THRegul.text);

  Apayer := Total - Acompte + Regularisation;

  SetControlProperty('TOT_DECLARE', 'Value', Total);
  SetControlProperty('APAYER', 'Value', APayer);
  SetControlProperty('ACOMPTES', 'Value', Acompte);
  SetControlProperty('REGULARISATIONS', 'Value', Regularisation);

end;

// Formatage des cellules num�riques
// -------------------------------
// tient compte du nombre de d�cimales,
// avec s�parateur des milliers
function TOM_DUCSENTETE.FormatZoneNum(Acol, Arow: Longint): Boolean;
var
  CellDeb, CellFin: string;
  NbDec: integer;
  ValZone: double;
begin

  // affectation du nbre de d�cimales
  NbDec := 0;
  if (Acol = 4) then NbDec := 0; // cellule effectif
  if (Acol = 5) then NbDec := 2; // cellule base
  if (Acol = 6) then // cellule taux ou quantit�
    if (LaGrille.CellValues[1, Arow] <> 'Q') then
      NbDec := 4 // cellule taux
    else
      NbDec := 0; // cellule quantit�

  if (Acol = 7) then NbDec := 2; // cellule montant

  // gestion des arrondis
  // P : au plus proche
  // S : � l'unit� sup�rieure
  // I : � l'unit� inf�rieure
  // non renseign� : pas d'arrondi
  if (Acol = 5) or (Acol = 7) then
  begin
    ValZone := Valeur(LaGrille.Cells[Acol, Arow]);
    if (Acol = 5) then
      // Base
    begin
      if (BaseArr <> '') and (BaseArr <> 'P') then
      begin
        ValZone := Int(ValZone);
        if (BaseArr = 'S') then ValZone := ValZone + 1;
      end;
      if (BaseArr = 'P') then
      begin
        ValZone := Arrondi(ValZone, 0);
      end;
    end;
    if (Acol = 7) then
      // Montant
    begin
      if (MontArr <> '') and (MontArr <> 'P') then
      begin
        ValZone := Int(ValZone);
        if (MontArr = 'S') then ValZone := ValZone + 1;
      end;
      if (MontArr = 'P') then
      begin
        ValZone := Arrondi(ValZone, 0);
      end;
    end;
    LaGrille.Cells[Acol, Arow] := DoubleToCell(ValZone, NbDec);
  end;
  // formatage de la cellule
  CellDeb := LaGrille.Cells[Acol, Arow];
  CellFin := CellDeb;
  LaGrille.Cells[Acol, Arow] := DoubleToCell(Valeur(Celldeb), NbDec);

  result := TRUE;
end;

procedure TOM_DUCSENTETE.ControlValid(var NoSiret, CodApe, GpInterne, NoInterne: string);
var
  Mess: string;
  declarant, suitdeclarant, teldeclarant, faxdeclarant: string;

begin
  inherited;
  Mess := '';

  // Infos d�clarant obligatoires
  declarant := GetField('PDU_DECLARANT');
  suitdeclarant := GetField('PDU_DECLARANTSUITE');
  if ((declarant) = '') and ((suitdeclarant) = '') then
  begin
    LastError := 1;
    Mess := Mess + '#13#10 - D�clarant';
    SetFocusControl('PDU_DECLARANT');
  end;

  teldeclarant := GetField('PDU_TELEPHONEDECL');
  faxdeclarant := GetField('PDU_FAXDECLARANT');
  if ((teldeclarant) = '') and ((faxdeclarant) = '') then
  begin
    LastError := 1;
    Mess := Mess + '#13#10 - n� de TEL ou de Fax du d�clarant';
    SetFocusControl('PDU_TELEPHONEDECL');
  end;

  // Le champ "Cotisations � r�gler au plus tard le :"  est une date obligatoire
  if (GetField('PDU_DATEREGLEMENT') = null) or (GetField('PDU_DATEREGLEMENT') = Idate1900) then
  begin
    LastError := 1;
    Mess := Mess + '#13#10 - la date de reglement ';
    SetFocusControl('PDU_DATEREGLEMENT');
  end;

  // Le champ "Salaires vers�s le :"  est une date obligatoire
  if (Neant = FALSE) then
  begin
    if (GetField('PDU_PAIEMENT') = null) or (GetField('PDU_PAIEMENT') = Idate1900) then
    begin
      LastError := 1;
      Mess := Mess + '#13#10 - la date de versement des salaires ';
      SetFocusControl('PDU_PAIEMENT');
    end;
  end;
  // Le champ "D�claration exigible � partir du :"  n'est pas une date obligatoire
  // pour l'URSSAF, l'ASSEDIC, la MSA
  if (GetField('PDU_DATEEXIGIBLE') = null) or (GetField('PDU_DATEEXIGIBLE') = Idate1900) then
    if (Nature <> '100') and (nature <> '200') and (Nature <> '600') and (Nature <> '') then
    begin
      LastError := 1;
      Mess := Mess + '#13#10 - la date d''exigibilit� ';
      SetFocusControl('PDU_DATEEXIGIBLE');
    end;

  // Le champ "Cotisation � r�gler au plus tard de :"  n'est pas une date obligatoire
  // pour l'URSSAF, l'ASSEDIC
  if (GetField('PDU_DATELIMDEPOT') = null) or (GetField('PDU_DATELIMDEPOT') = Idate1900) then
    if (Nature <> '100') and (nature <> '200') and (Nature <> '') then
    begin
      LastError := 1;
      Mess := Mess + '#13#10 - la date limite de d�pot ';
      SetFocusControl('PDU_DATELIMDEPOT');
    end;

  // Num�ro interne obligatoire si rupture sur n� interne
  NoInterne := GetField('PDU_NUMERO');
  if ((NoInterne) = '') and (RuptNumInt = TRUE) then
  begin
    LastError := 1;
    Mess := Mess + '#13#10 - le n� interne ';
    SetFocusControl('PDU_NUMERO');
  end;

  // Groupe interne obligatoire sauf pour URSSAF et ASSEDIC
  GpInterne := GetField('PDU_GROUPE');
  if ((GpInterne) = '') and
    (Nature <> '100') and
    (Nature <> '200') and
    (RuptGpInt = TRUE) then
  begin
    LastError := 1;
    Mess := Mess + '#13#10 - le n� de groupe interne ';
    SetFocusControl('PDU_GROUPE');
  end;

  // APE obligatoire
  CodApe := GetField('PDU_APE');
  if (CodApe) = '' then
  begin
    LastError := 1;
    Mess := Mess + '#13#10 - Code APE';
    SetFocusControl('PDU_APE');
  end;

  // Contr�le du n� Siret
  NoSiret := GetField('PDU_SIRET');

  if Nature <> '600' then
  begin
    if (NoSiret) = '' then
    begin
      LastError := 1;
      Mess := Mess + '#13#10 - N� Siret';
      SetFocusControl('PDU_SIRET');
    end
    else
      if (Length(NoSiret) <> 14) and (Length(NoSiret) <> 9) then
    begin
      LastError := 1;
      Mess := Mess + '#13#10 - N� Siret (incomplet) ';
      SetFocusControl('PDU_SIRET');
    end
    else
      if ControlSiret(NoSiret) <> True then
    begin
      LastError := 1;
      Mess := Mess + '#13#10 - N� Siret (erron�) ';
      SetFocusControl('PDU_SIRET');
    end;
  end;

  if LastError <> 0 then
  begin
    PGIBox('Vous devez renseigner :' + Mess, 'Informations obligatoires');
  end;

  if (Copy(GetField('PDU_ABREGEPERIODE'), 3, 2) <> '00') and (Nature = '100') and
    (GetField('PDU_REGULARISATION') <> 0.0) then
  begin
    LastError := 1;
    PGIBox('Pas de r�gularisation possible', 'Il ne s''agit pas d''un TR');
    SetFocusControl('PDU_REGULARISATION');
  end;
end;

procedure TOM_DUCSENTETE.PageCtrlChange(Sender: TObject);
begin
  if BtnIns <> nil then
  begin
    if (PageCtrl.ActivePageIndex <> 2) then
    begin
      BtnIns.Enabled := False;
      BtnDel.Enabled := False;
    end
    else
    begin
      BtnIns.Enabled := True;
      BtnDel.Enabled := True;
    end;
  end;
end;

// Contr�le du nombre de salari�s pr�sents avant saisie de la date de cessation
// ou de continuation d'activit� sans personnel.
procedure TOM_DUCSENTETE.EnterActivite(Sender: TObject);
begin
  if (NbSal <> 0) then
    PGIBox(' ! Attention, des salari�s sont encore pr�sents.', 'Cessation d''activit� ou maintien sans personnel');
end;

{$IFNDEF DUCS41}
// traitement du bool�en Ecart d'effectif : embauches CNE
// la c�ation d'un nouveau champ dans la table �tant impossible on utilise
// PDU_NBSALQ966 qui n'est pas utilis�.
procedure TOM_DUCSENTETE.MajEcartZE9(Sender: TObject);
begin
    // On passe en ds.edit pour forcer la mise � jour
    if not (ds.state in [dsinsert, dsedit]) then ds.edit;

     if EcartZe9.Checked=True then
        SetField('PDU_NBSALQ966', 1)
     else
        SetField('PDU_NBSALQ966', 0);
end;
{$ENDIF}

initialization
  registerclasses([TOM_DUCSENTETE]);
end.

