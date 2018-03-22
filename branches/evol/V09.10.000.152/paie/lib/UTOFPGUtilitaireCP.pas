{***********UNITE*************************************************
Auteur  ...... : PAIE PGI
Cr�� le ...... : 24/07/2001
Modifi� le ... : 24/07/2001
Description .. : Utilitaire Cong�s pay�s
Mots clefs ... : PAIE;CP
*****************************************************************
PT- 1  04/10/2001 SB 562 Modification du chemin de sauvegarde
PT- 2  26/11/2001 SB V563  Moulinette de maj des CP : Changement de fiche
PT- 3  04/10/2001 SB 562 Modification du chemin de sauvegarde
PT- 4  09/10/2001 SB 562 Les mvts Ajp ne doivent pas �tre pris en
                        compte ds les consomm�s
PT- 6  22/11/2001 SB 563 Pour ORACLE, Le champ PCN_CODETAPE doit �tre renseign�
PT- 7  14/01/2002 SB V571 Barre d'evolution compteur CP, all�gement du traitement
PT- 8  15/04/2002 SB V571 Selection du code etablissement possible pour les compteurs CP.
PT- 9  16/04/2002 SB V571 Le compteur Cp ne doit pas �tre calcul� en fonction de la date syst�me
PT- 10 22/10/2002 SB V585 G�n�ration d'�v�nements pour tra�age
PT- 11 22/10/2002 SB V585 Compteur CP : Ne tient pas compte des mvts pri �clat�s
PT- 12 13/12/2002 SB V591 FQ 10346 Si zone salari� non accessible alors on la grise
                                   ColleZerodevant code salari�
PT13   15/10/2003 SB V_42 Maj de date modification de la table des salaries pour introduction PAIE
PT14   12/03/2004 SB V_50 FQ 11162 Encodage de la date de cloture erron� si fin fevrier
PT15   18/03/2004 SB V_50 FQ 11166 Int�gration de nouveau contr�le sur la v�rification CP
PT16-1 29/04/2004 SB V_50 Fq 11166 R�imputation des Pris sur encours m�me si pris non entam�
PT16-2 29/04/2004 SB V_50 Fq 11166 Cas de bouclage
PT17   27/09/2005 SB V65  FQ 12602 Ajout mode silence v�rification CP
PT18   15/11/2005 SB V_65 FQ 12699 Pas de g�n�ration de fichier en mode silence
PT19   17/11/2005 SB V_65 FQ 12700 Ajout contr�le date validit�
PT20   02/06/2006 SB V_65 Optimisation m�moire
PT21   03/07/2006 SB V_65 FQ 13345 Consommation �rron� des acquis post SLD
PT22   12/09/2007 PH V_80 FQ 14744 Affectation PCN_CODERGRPT
PT23   11/10/2007 PH V_80 FQ 14779 Boucle infinie moulinette CP
}
unit UTOFPGUtilitaireCP;

interface
uses Controls, Classes, Graphics, sysutils, ComCtrls, HDebug,
{$IFNDEF EAGLCLIENT}
  db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
{$ENDIF}
{$IFNDEF EAGLSERVER}
  UTOF,
{$ENDIF}
  HTB97, HEnt1, HCtrls, HMsgBox, UTOB, HRichOLE, ed_tools,
  HStatus,
  ULibEditionPaie;

{$IFNDEF EAGLSERVER}
type
  TOF_PGUTILITAIRECP = class(TOF)
  public
    procedure OnArgument(Arguments: string); override;
    procedure OnUpdate; override;
    procedure OnClose; override;
  private
    Fichier, Etab, Traitement: string;
    DateClotCP: TDateTime;
    Tob_Etab: TOB;
    procedure ChangeEtab(Sender: TObject);
    procedure AfficheFichierRapport(Sender: TObject);
    procedure UpdateAnnuleClotureCp;
    procedure UpdateReliquat;
    procedure VerifieCpsal;
    procedure ExitEdit(Sender: TObject);
  end;
{DEB1 PT- 2}
{$ENDIF}

var F: TextFile;
procedure VerificationCP(salarie, Etab: string; Silence: Boolean = False);
procedure RendCompteurCP(Tob_MvtCp: Tob; i: integer; var Pris, Consomme, Rel, ConsRel, Sld: double); { PT15 }
procedure MajCompteurCP(Tob_MvtCp: Tob; Periode, OrdreSld, PeriodeSld: integer; Pris, Consomme, ConsRel, Sld: double; DSld: TDateTime; Silence: Boolean); { PT15 }
procedure EcritLigneMvt(PeriodeCp, Ordre, Codergrpt: integer; TypeConge, Sens, Codetape, Duplique: string; Jours, APayes: double; DatePaiement: TDateTime; Silence: Boolean);
procedure ControleMvtPris(Tob_MvtCp, Tob_InfoCp: TOB; Periode: Integer; Salarie: string; rel: double; Silence: Boolean);
{FIN1 PT- 2}
{ DEB PT15 }
procedure ReImputePriPeriode(Tob_MvtCp, Tob_InfoCp: Tob; Salarie: string; OrdreMax: Integer; silence: boolean);
{ FIN PT15 }
procedure PgWriteln(Silence: Boolean; var F: Text; St: string); { PT18 }


procedure MAJBaseCPAcquis(Verrouillage: Boolean; etab, sal, FileN: string);


implementation

uses EntPaie, PgOutils, P5Def, P5Util, PgCongesPayes, PgOutils2, PgCommun, PgCalendrier;

{ TOF_PGANNULECLOTURECP }
{$IFNDEF EAGLSERVER}

procedure TOF_PGUTILITAIRECP.OnArgument(Arguments: string);
var
  Combo: THValComboBox;
  Q: TQuery;
  Btn: TToolBarButton97;
  Edit: THEdit; //PT- 12
begin
  inherited;
  Traitement := Arguments;
  if Traitement = 'DECLOTURE' then
  begin
    SetControltext('NOMFICHIER', VH_Paie.PGCheminEagl + '\AnnuleCl�tureCp.txt'); //PT- 1
    Ecran.caption := 'Annulation de la cl�ture CP';
  end
  else
    if Traitement = 'RELIQUAT' then
    begin
      SetControltext('NOMFICHIER', VH_Paie.PGCheminEagl + '\Reliquat.txt'); //PT- 1
      Ecran.caption := 'G�n�ration de reliquat';
    end
    else
      if Traitement = 'COMPTEUR' then
      begin
        SetControltext('NOMFICHIER', VH_Paie.PGCheminEagl + '\Rapport.txt'); //PT- 1
        Ecran.caption := 'Compteur';
      //SetControlEnabled('ETABLISSEMENT',False); //PT- 8
      end
      else
        if Traitement = 'VERIFICATION' then
        begin
          SetControltext('NOMFICHIER', VH_Paie.PGCheminEagl + '\V�rificationCp.txt');
          Ecran.caption := 'V�rification des CP';
          SetControlEnabled('SALARIE', True);
          PGIBox('Attention!Ce traitement ne doit �tre utilis� que pour des salari�s ayant des anomalies de cong�s pay�s.#13#10' +
            ' Demander � �tre assister par un technicien en cas d''incertitude.', Ecran.caption);
        end
        else
          if Traitement = 'BASECP' then
          begin
            SetControltext('NOMFICHIER', VH_Paie.PGCheminEagl + '\BaseCp.txt');
            Ecran.caption := 'R�affectation des bases CP';
            SetControlEnabled('SALARIE', True);
          end;


  UpdateCaption(Ecran);
  Combo := THValComboBox(GetControl('ETABLISSEMENT'));
  if Combo <> nil then Combo.OnChange := ChangeEtab;

  Q := OpenSql('SELECT ETB_ETABLISSEMENT,ETB_DATECLOTURECPN FROM ETABCOMPL ' +
    'WHERE ETB_CONGESPAYES="X" ', True);
  Tob_Etab := Tob.Create('Les etab', nil, -1);
  Tob_Etab.LoadDetailDB('ETABCOMPL', '', '', Q, False);
  Ferme(Q);


  Btn := TToolBarButton97(getcontrol('REFRESH'));
  if Btn <> nil then Btn.OnClick := AfficheFichierRapport;
//DEB PT- 12
  Edit := THEdit(GetControl('SALARIE'));
  if Edit <> nil then
  begin
    if not Edit.enabled then Edit.Color := clBtnFace;
    Edit.OnExit := ExitEdit;
  end;
//FIN PT- 12
end;

procedure TOF_PGUTILITAIRECP.ChangeEtab(Sender: TObject);
var
  T: TOB;
  DDebut, Dfin: TdateTime;
begin
  DateClotCP := Idate1900;
  Etab := GetControlText('ETABLISSEMENT');
  T := Tob_Etab.FindFirst(['ETB_ETABLISSEMENT'], [Etab], False);
  if T <> nil then
  begin
    DateClotCP := T.GetValue('ETB_DATECLOTURECPN');
    RechercheDate(DDebut, Dfin, DateClotCP, '0');
    SetControlText('TBPERIODE', 'P�riode en cours du ' + Datetostr(DDebut) + ' au ' + Datetostr(DFin));
    SetControlText('TBDATECLOT', 'Date de cl�ture du ' + Datetostr(DateClotCP));
  end;
end;

procedure TOF_PGUTILITAIRECP.AfficheFichierRapport(Sender: TObject);
var
  S: string;
  TPC: TPageControl;
  T: TTabSheet;
//TT         : TQRProgressForm ; PORTAGECWAS
  FichierRapport: THRichEditOLE;
begin
  FichierRapport := THRichEditOLE(getcontrol('RICHFICHIER'));
  if FichierRapport = nil then exit;
  Fichier := GetControlText('NOMFICHIER');
  if Fichier = '' then exit;
  FichierRapport.Clear;
  if not FileExists(Fichier) then exit;
  AssignFile(F, Fichier);
{$I-}Reset(F); {$I+}
  InitMoveProgressForm(nil, 'Chargement du fichier de rapport � l''�cran', 'Veuillez patienter SVP ...', 100, TRUE, TRUE);

  while not eof(F) do
  begin
    if not MoveCurProgressForm then
    begin
      closeFile(F);
      FiniMoveProgressForm;
    end;
    Readln(F, S);
    MoveCurProgressForm;
    FichierRapport.lines.Add(S);
  end;
  closeFile(F);
  FiniMoveProgressForm;
  T := TTabSheet(GetControl('TBCOMPLEMENT'));
  if T <> nil then
  begin
    TPC := TPageControl(getcontrol('PAGES'));
    if TPC <> nil then TPC.ActivePage := T;
  end;
end;



procedure TOF_PGUTILITAIRECP.OnUpdate;
begin
  if Traitement = 'DECLOTURE' then
    UpdateAnnuleClotureCp
  else
    if Traitement = 'RELIQUAT' then
      UpdateReliquat
    else
      if Traitement = 'COMPTEUR' then
        VerifieCpsal
      else
        if Traitement = 'VERIFICATION' then
          VerificationCP(GetControlText('SALARIE'), GetControlText('ETABLISSEMENT'))
        else
          if Traitement = 'BASECP' then
            MAJBaseCPAcquis(False, GetControlText('ETABLISSEMENT'), GetControlText('SALARIE'), GetControltext('NOMFICHIER'));
end;

procedure TOF_PGUTILITAIRECP.OnClose;
begin
  inherited;
  if Tob_etab <> nil then
  begin
    Tob_Etab.free;
    Tob_Etab := nil;
  end;
end;



procedure TOF_PGUTILITAIRECP.UpdateAnnuleClotureCp;
var
  FinPeriodeN, DebPeriodeN1, FinPeriodeN1, DebPeriodeN2, FinPeriodeN2: Tdatetime;
  Init: word;
  FileN, Salarie, TypMvt, LibMvt, Codetape: string;
//  TProgress: TQRProgressForm ; PORTAGECWAS
  Tob_ADetruire, Tob_Maj: Tob;
  Q: TQuery;
//  F            : TextFile;
  NoOrdre, i, reponse: integer;
begin
  inherited;
  if GetControlText('ETABLISSEMENT') = '' then
  begin
    PGIBox('Veuiller renseigner l''�tablissement!', Ecran.Caption);
    Exit;
  end;

  if IsValidDate(DateToStr(DateClotCP)) then
    FinPeriodeN := DateClotCP
  else
  begin
    PGIBox('La date de cl�ture des CP de l''�tablissement est �rron�e!', Ecran.Caption);
    exit;
  end;

  if GetControlText('NOMFICHIER') = '' then
    SetControltext('NOMFICHIER', VH_Paie.PGCheminEagl + '\AnnuleCl�tureCp.txt'); //PT- 1
  FileN := GetControlText('NOMFICHIER');
  Fichier := FileN;
  if FileExists(FileN) then
  begin
    reponse := HShowMessage('5;;Voulez-vous supprimer le fichier de rapport ' + ExtractFileName(FileN) + ';Q;YN;Y;N', '', '');
    if reponse = 6 then DeleteFile(PChar(FileN))
    else exit;
  end;
  AssignFile(F, FileN);
{$I-}ReWrite(F); {$I+}
  if IoResult <> 0 then begin PGIBox('Fichier inaccessible : ' + FileN, 'Abandon du traitement'); Exit; end;


  FinPeriodeN1 := PlusDate(FinPeriodeN, -1, 'A');
  FinPeriodeN2 := PlusDate(FinPeriodeN1, -1, 'A');
//DebPeriodeN := FinPeriodeN1+1;
  DebPeriodeN1 := FinPeriodeN2 + 1;
  DebPeriodeN2 := PlusDate(DebPeriodeN1, -1, 'A');

  if ExisteSql('SELECT DISTINCT PPU_SALARIE FROM PAIEENCOURS ' +
    'WHERE PPU_ETABLISSEMENT="' + etab + '" ' +
    'AND PPU_DATEFIN>"' + UsDateTime(FinPeriodeN) + '" ') = TRUE then
  begin
    PGIBox('Vous ne pouvez "d�cl�turer" votre p�riode CP : ' +
      'Des bulletins de paie sont aliment�s pour la p�riode du ' + DateToStr(FinPeriodeN + 1) + ' ' +
      'au ' + DateToStr(PlusMois(FinPeriodeN, 1)) + '.', '"D�cl�ture" de cong�s pay�s');
    exit;
  end;

  Init := HShowMessage('2;Cong�s pay�s;Attention, vous allez "decl�turer" la p�riode de cong�s pay�s ' +
    '#13#10( du ' + datetostr(DebPeriodeN2) + ' au ' + datetostr(finPeriodeN2) + '). ' +
    '#13#10Et r�ouvrir la p�riode ( du ' + datetostr(DebPeriodeN1) + ' au ' + datetostr(finPeriodeN1) + '). ' +
    ' #13#10 Attention, la "decl�ture" entra�ne l''�criture de la fiche �tablissement;Q;YNC;N;N;', '', '');
  if Init = mrYes then
  begin
    try
      begintrans;
      Tob_ADetruire := Tob.Create('TOB � D�truire', nil, -1);
      Tob_Maj := Tob.Create('TOB Maj', nil, -1);
      InitMoveProgressForm(nil, '"Decl�ture" des cong�s pay�s', 'Veuillez patienter SVP ...', 5, FALSE, TRUE);
      MoveCurProgressForm('Suppression des mouvements g�n�r�s par la cl�ture');
//-----------------------------------
      writeln(F, 'Suppression des mouvements g�n�r�s par la cl�ture');
      Q := OpenSql('SELECT PCN_SALARIE,PCN_ORDRE,PCN_TYPECONGE,PCN_CODETAPE,PCN_LIBELLE ' +
        'FROM ABSENCESALARIE WHERE PCN_ETABLISSEMENT= "' + etab + '"' +
        'AND PCN_GENERECLOTURE = "X" ' +
        'AND ((PCN_TYPECONGE="REL" AND PCN_DATEVALIDITE="' + UsDateTime(FinPeriodeN2) + '") ' +
        'OR  ((PCN_TYPECONGE="REL" OR PCN_TYPECONGE="SLD") AND PCN_DATEVALIDITE="' + UsDateTime(DebPeriodeN1) + '") ' +
        'OR   (PCN_TYPECONGE="ARR" AND PCN_DATEVALIDITE="' + UsDateTime(FinPeriodeN1) + '"))', True);
      Tob_ADetruire.LoadDetailDB('ABSENCESALARIE', '', '', Q, False);
      Ferme(Q);
      for i := 0 to Tob_ADetruire.detail.count - 1 do
      begin
        Salarie := Tob_ADetruire.detail[i].GetValue('PCN_SALARIE');
        NoOrdre := Tob_ADetruire.detail[i].GetValue('PCN_ORDRE');
        TypMvt := Tob_ADetruire.detail[i].GetValue('PCN_TYPECONGE');
        Codetape := RechDom('PGCODETAPECP', Tob_ADetruire.detail[i].GetValue('PCN_CODETAPE'), False);
        LibMvt := Tob_ADetruire.detail[i].GetValue('PCN_LIBELLE');
        writeln(F, Etab + ' ' + Salarie + ' ' + IntToStr(NoOrdre) + ' ' + TypMvt + ' ' + Codetape + ' ' + LibMvt);
      end;
      Tob_ADetruire.DeleteDB(True);
//-----------------------------------
      MoveCurProgressForm('Mise � jour des mouvements pay�s puis clotur�s ou sold�s sur la p�riode(n-1).');
      writeln(F, '');
      writeln(F, 'Mise � jour des mouvements pay�s puis clotur�s ou sold�s sur la p�riode(n-1).');
      Q := OpenSql('SELECT PCN_SALARIE,PCN_ORDRE,PCN_TYPECONGE,PCN_CODETAPE,PCN_LIBELLE ' +
        'FROM ABSENCESALARIE  ' + //SET PCN_CODETAPE="P"
        'WHERE PCN_SALARIE IN (SELECT PSA_SALARIE FROM SALARIES WHERE PSA_ETABLISSEMENT="' + etab + '") ' +
        'AND (PCN_CODETAPE="C" OR PCN_CODETAPE="S") ' +
        'AND ((( PCN_DATEVALIDITE>="' + UsDateTime(DebPeriodeN1) + '" AND PCN_DATEVALIDITE<="' + UsDateTime(FinPeriodeN1) + '" ' +
        '  AND (PCN_MVTDUPLIQUE="X" OR PCN_MVTPRIS="PRI" OR PCN_PERIODEPY=1)) ' +
        'OR (   PCN_DATEVALIDITE>="' + UsDateTime(DebPeriodeN2) + '" AND PCN_DATEVALIDITE<="' + UsDateTime(FinPeriodeN2) + '" ' +
        '   AND PCN_TYPECONGE="CPA")))', True);
      Tob_Maj.LoadDetailDB('ABSENCESALARIE', '', '', Q, False);
      Ferme(Q);
      for i := 0 to Tob_Maj.detail.count - 1 do
      begin
        Salarie := Tob_Maj.detail[i].GetValue('PCN_SALARIE');
        NoOrdre := Tob_Maj.detail[i].GetValue('PCN_ORDRE');
        TypMvt := Tob_Maj.detail[i].GetValue('PCN_TYPECONGE');
        Codetape := RechDom('PGCODETAPECP', Tob_Maj.detail[i].GetValue('PCN_CODETAPE'), False);
        LibMvt := Tob_Maj.detail[i].GetValue('PCN_LIBELLE');
        writeln(F, Etab + ' ' + Salarie + ' ' + IntToStr(NoOrdre) + ' ' + TypMvt + ' ' + Codetape + ' ' + LibMvt);
        Tob_Maj.detail[i].PutValue('PCN_CODETAPE', 'P');
      end;
      Tob_Maj.UpdateDB(True);
      Tob_Maj.ClearDetail;
//-----------------------------------
      MoveCurProgressForm('Mise � jour des mouvements pay�s puis sold�s sur la p�riode(n-2).');
      writeln(F, '');
      writeln(F, 'Mise � jour des mouvements pay�s puis sold�s sur la p�riode(n-2).');
      Q := OpenSql('SELECT PCN_SALARIE,PCN_ORDRE,PCN_TYPECONGE,PCN_CODETAPE,PCN_LIBELLE ' +
        'FROM ABSENCESALARIE  ' + //SET PCN_CODETAPE="P"
        'WHERE PCN_SALARIE IN (SELECT PSA_SALARIE FROM SALARIES WHERE PSA_ETABLISSEMENT="' + etab + '") ' +
        'AND (PCN_CODETAPE="C" OR PCN_CODETAPE="S") ' +
        'AND PCN_DATEVALIDITE>="' + UsDateTime(DebPeriodeN2) + '" ' +
        'AND PCN_DATEVALIDITE<="' + UsDateTime(FinPeriodeN2) + '"  ' +
        'AND PCN_PERIODEPY<>-1 ' +
        'AND EXISTS (SELECT PCN_TYPEMVT FROM ABSENCESALARIE ABS WHERE ABSENCESALARIE.PCN_SALARIE=ABS.PCN_SALARIE ' +
        'AND PCN_TYPECONGE="SLD" AND PCN_GENERECLOTURE="-" AND PCN_TYPEMVT="CPA")', True);
      Tob_Maj.LoadDetailDB('ABSENCESALARIE', '', '', Q, False);
      Ferme(Q);
      for i := 0 to Tob_Maj.detail.count - 1 do
      begin
        Salarie := Tob_Maj.detail[i].GetValue('PCN_SALARIE');
        NoOrdre := Tob_Maj.detail[i].GetValue('PCN_ORDRE');
        TypMvt := Tob_Maj.detail[i].GetValue('PCN_TYPECONGE');
        Codetape := RechDom('PGCODETAPECP', Tob_Maj.detail[i].GetValue('PCN_CODETAPE'), False);
        LibMvt := Tob_Maj.detail[i].GetValue('PCN_LIBELLE');
        writeln(F, Etab + ' ' + Salarie + ' ' + IntToStr(NoOrdre) + ' ' + TypMvt + ' ' + Codetape + ' ' + LibMvt);
        Tob_Maj.detail[i].PutValue('PCN_CODETAPE', 'P');
      end;
      Tob_Maj.UpdateDB(True);
      Tob_Maj.ClearDetail;
//-----------------------------------
      MoveCurProgressForm('Mise � jour des mouvements acquis puis sold�s sur la p�riode(n-2)');
      writeln(F, '');
      writeln(F, 'Mise � jour des mouvements acquis puis sold�s sur la p�riode(n-2)');
      Q := OpenSql('SELECT PCN_SALARIE,PCN_ORDRE,PCN_TYPECONGE,PCN_CODETAPE,PCN_LIBELLE ' +
        'FROM ABSENCESALARIE  ' + //SET PCN_CODETAPE="S"
        'WHERE PCN_SALARIE IN (SELECT PSA_SALARIE FROM SALARIES WHERE PSA_ETABLISSEMENT="' + etab + '") ' +
        'AND (PCN_CODETAPE="C" OR PCN_CODETAPE="S") ' +
        'AND PCN_DATEVALIDITE>="' + UsDateTime(DebPeriodeN2) + '" ' +
        'AND PCN_DATEVALIDITE<="' + UsDateTime(FinPeriodeN2) + '"  ' +
        'AND PCN_PERIODEPY=-1 ' +
        'AND EXISTS (SELECT PCN_TYPEMVT FROM ABSENCESALARIE ABS WHERE ABSENCESALARIE.PCN_SALARIE=ABS.PCN_SALARIE ' +
        'AND PCN_TYPECONGE="SLD" AND PCN_GENERECLOTURE="-" AND PCN_TYPEMVT="CPA")', True);
      Tob_Maj.LoadDetailDB('ABSENCESALARIE', '', '', Q, False);
      Ferme(Q);
      for i := 0 to Tob_Maj.detail.count - 1 do
      begin
        Salarie := Tob_Maj.detail[i].GetValue('PCN_SALARIE');
        NoOrdre := Tob_Maj.detail[i].GetValue('PCN_ORDRE');
        TypMvt := Tob_Maj.detail[i].GetValue('PCN_TYPECONGE');
        Codetape := RechDom('PGCODETAPECP', Tob_Maj.detail[i].GetValue('PCN_CODETAPE'), False);
        LibMvt := Tob_Maj.detail[i].GetValue('PCN_LIBELLE');
        writeln(F, Etab + ' ' + Salarie + ' ' + IntToStr(NoOrdre) + ' ' + TypMvt + ' ' + Codetape + ' ' + LibMvt);
        Tob_Maj.detail[i].PutValue('PCN_CODETAPE', 'S');
      end;
      Tob_Maj.UpdateDB(True);
      Tob_Maj.ClearDetail;
//-----------------------------------
      MoveCurProgressForm('Mise � jour des mouvements acquis puis clotur�s sur la p�riode(n-2)');
      writeln(F, '');
      writeln(F, 'Mise � jour des mouvements acquis puis clotur�s sur la p�riode(n-2)');
      Q := OpenSql('SELECT PCN_SALARIE,PCN_ORDRE,PCN_TYPECONGE,PCN_CODETAPE,PCN_LIBELLE ' +
        'FROM ABSENCESALARIE  ' + //SET PCN_CODETAPE=""
        'WHERE PCN_SALARIE IN (SELECT PSA_SALARIE FROM SALARIES WHERE PSA_ETABLISSEMENT="' + etab + '") ' +
        'AND (PCN_CODETAPE="C" OR PCN_CODETAPE="S") ' +
        'AND PCN_PERIODEPY=-1 ' +
        'AND PCN_DATEVALIDITE>="' + UsDateTime(DebPeriodeN2) + '" ' +
        'AND PCN_DATEVALIDITE<="' + UsDateTime(FinPeriodeN2) + '" ' +
        'AND NOT EXISTS (SELECT PCN_TYPEMVT FROM ABSENCESALARIE ABS WHERE ABSENCESALARIE.PCN_SALARIE=ABS.PCN_SALARIE ' +
        'AND PCN_TYPECONGE="SLD" AND PCN_GENERECLOTURE="-" AND PCN_TYPEMVT="CPA")', True);
      Tob_Maj.LoadDetailDB('ABSENCESALARIE', '', '', Q, False);
      Ferme(Q);
      for i := 0 to Tob_Maj.detail.count - 1 do
      begin
        Salarie := Tob_Maj.detail[i].GetValue('PCN_SALARIE');
        NoOrdre := Tob_Maj.detail[i].GetValue('PCN_ORDRE');
        TypMvt := Tob_Maj.detail[i].GetValue('PCN_TYPECONGE');
        Codetape := RechDom('PGCODETAPECP', Tob_Maj.detail[i].GetValue('PCN_CODETAPE'), False);
        LibMvt := Tob_Maj.detail[i].GetValue('PCN_LIBELLE');
        writeln(F, Etab + ' ' + Salarie + ' ' + IntToStr(NoOrdre) + ' ' + TypMvt + ' ' + Codetape + ' ' + LibMvt);
        Tob_Maj.detail[i].PutValue('PCN_CODETAPE', '...'); //PT- 6
      end;
      Tob_Maj.UpdateDB(True);
      Tob_Maj.ClearDetail;
//-----------------------------------
      MoveCurProgressForm('Mise � jour de la date de cl�ture des CP');
      writeln(F, '');
      writeln(F, 'Mise � jour de la date de cl�ture des CP');
      ExecuteSql('UPDATE ETABCOMPL SET ETB_DATECLOTURECPN="' + USDateTIme(FinPeriodeN1) + '", ' +
        'ETB_DATEMODIF="' + USTIme(Now) + '" ' + //PT13
        'WHERE ETB_ETABLISSEMENT="' + Etab + '" ');
      MoveCurProgressForm('Affectation des p�riodes..');
      writeln(F, '');
      writeln(F, 'Affectation des p�riodes..');
      RecalculePeriode(Etab, FinPeriodeN1);
      MoveCurProgressForm('Mise � jour des donn�es..');
      CommitTrans;
      FiniMoveProgressForm;
    except
      Rollback;
      PGIBox('Une erreur est survenue lors de la "decl�ture" Cong�s pay�s', '"Decl�ture" p�riode CP');
    end;
  end;
end;

procedure TOF_PGUTILITAIRECP.UpdateReliquat;
var
  Datedebutperiode, DatefinPeriodeP, DateDebutPeriodeS: tdatetime;
  Q: TQuery;
  salarie, st, MethodeReliquat, GestionRel, LibMvt: string;
  FileN, AddString, Etablis: string;
  aa, mm, jj: word;
  Noordre, Reliquat: integer;
  T_listesal, T_MVTINS, T_listeMvt, TS: tob;
  PN1, AN1, RN1, BN1, MB1, Valo: double;
  DateSortie, datefinperiode: TDateTime;
//TProgress: TQRProgressForm ; PORTAGECWAS
//F            : TextFile;
begin
  if PgiAsk('Attention vous demandez � g�n�rer les reliquats de la p�riode (n-2).#13#10' +
    'Seul les salari�s de l''etablissement dont la date de cl�ture des CP #13#10' +
    'correspond au 31/05/2002 seront pris en compte. ' +
    '#13#10Voulez-vous continuer?', 'G�n�rations des r�liquats') <> MrYes then Exit;
  if GetControlText('NOMFICHIER') = '' then
    SetControltext('NOMFICHIER', VH_Paie.PGCheminEagl + '\Reliquat.txt'); //PT- 1
  FileN := GetControlText('NOMFICHIER');
  Fichier := FileN;

  if SupprimeFichier(FileN) = False then exit;

  AssignFile(F, FileN);
{$I-}ReWrite(F); {$I+}
  if IoResult <> 0 then begin PGIBox('Fichier inaccessible : ' + FileN, 'Abandon du traitement'); Exit; end;
  writeln(F, 'G�n�ration du reliquat manquant');

  datefinperiode := StrToDate('31/05/2001');

// Calcul des d�buts et fin de p�riode sur lesquelles on va travailler
  try
    begintrans;
    InitMoveProgressForm(nil, 'Chargement des donn�es', 'Veuillez patienter SVP ...', 100, FALSE, TRUE);

    Decodedate(datefinperiode, aa, mm, jj);
    DateDebutPeriodeS := datefinperiode + 1;
// DateFinPeriodeS   := (EncodeDate(aa+1,mm,jj));
    Datedebutperiode := (PGEncodeDateBissextile(aa - 1, mm, jj) + 1); { PT14 }
 //DatedebutperiodeP := (EncodeDate(aa-2,mm,jj) +1);
    DatefinPeriodeP := DatedebutPeriode - 1;


    T_MVTINS := Tob.create('Mere des lignes a inserer', nil, -1);
    if Etab <> '' then AddString := ' AND PSA_ETABLISSEMENT="' + Etab + '" ' else AddString := '';
    Q := OpenSQL('SELECT PSA_SALARIE,PSA_LIBELLE,PSA_PRENOM,PSA_ETABLISSEMENT,PSA_TRAVAILN1,' +
      'PSA_TRAVAILN2,PSA_TRAVAILN3,PSA_TRAVAILN4,PSA_CODESTAT,PSA_CONFIDENTIEL,' +
      'PSA_CPTYPERELIQ,PSA_RELIQUAT,PSA_DATESORTIE,PSA_CPTYPERELIQ,ETB_RELIQUAT FROM SALARIES ' +
      'LEFT JOIN ETABCOMPL ON PSA_ETABLISSEMENT=ETB_ETABLISSEMENT ' +
      'WHERE ETB_DATECLOTURECPN="05/31/2002" ' + AddString + ' ', True);
    T_ListeSal := TOB.Create('Liste des salarie etablissement', nil, -1);
    T_ListeSal.LoadDetailDB('SALARIES', '', '', Q, False);
    ferme(Q);

    T_listeMvt := Tob.create('ABSENCESALARIE', nil, -1);
    st := 'SELECT * FROM ABSENCESALARIE ' +
      'WHERE PCN_CODERGRPT <> -1 AND PCN_TYPEMVT="CPA" AND PCN_PERIODECP=2 ' +
      'ORDER BY PCN_SALARIE , PCN_DATEVALIDITE ';
    Q := OpenSql(st, TRUE);
    T_listeMvt.LoadDetailDB('ABSENCESALARIE', '', '', Q, False);
    ferme(Q);

 //TProgress.MaxValue:=T_listeMvt.Detail.Count; //PORTAGECWAS
 //TProgress.value:=1; //PORTAGECWAS
    TS := T_ListeSal.FindFirst([''], [''], false);
    while TS <> nil do
    begin //B TS
      DateSortie := TS.GetValue('PSA_DATESORTIE');
      Gestionrel := TS.getvalue('PSA_CPTYPERELIQ');
      if ((Gestionrel <> 'ETB') and (Gestionrel <> 'PER')) then GestionRel := 'ETB';
      if gestionrel = 'ETB' then MethodeReliquat := TS.getvalue('ETB_RELIQUAT')
      else if gestionrel = 'PER' then MethodeReliquat := TS.getvalue('PSA_RELIQUAT');
      Salarie := TS.getvalue('PSA_SALARIE');
      Etablis := TS.getvalue('PSA_ETABLISSEMENT');
      NoOrdre := IncrementeSeqNoOrdre('CPA', SALARIE);

      if MethodeReliquat <> '' then Reliquat := StrToInt(MethodeReliquat) else Reliquat := 5;

      MoveCurProgressForm('Calcul du solde de la p�riode (n-2) du salari� : ' + Etablis + ' : ' + Salarie + ' : ' + TS.getvalue('PSA_LIBELLE') + ' ' + TS.getvalue('PSA_PRENOM'));
   //Recup�ration du solde des CP pour la periode clotur� et la periode ant�rieur
      CompteCp(T_listeMvt, '2', Salarie, 0, PN1, AN1, RN1, BN1, MB1, Valo);
      if (RN1 > 0) and ((DateSortie >= DateDebutPeriodeS) or (Datesortie = idate1900)) then
      begin //Begin IF 1
        MoveCurProgressForm('G�n�ration du reliquat manquant : ' + Etablis + ' : ' + Salarie + ' : ' + TS.getvalue('PSA_LIBELLE') + ' ' + TS.getvalue('PSA_PRENOM'));
        case Reliquat of
          0: begin //Remise � zero
             //Genere reliquat negatif � DateFinperiodeP      Clotur�
              LibMvt := 'Reliquat - au ' + datetostr(datefinPeriodeP) + ' RAZ';
              GenereMvtCloture(T_MVTINS, TS, NoOrdre, 2, 'REL', '-', LibMvt, 'C', DatefinperiodeP, Datefinperiode, RN1, MB1, MB1);
              writeln(F, Etablis + ' ' + Salarie + ' ' + IntToStr(NoOrdre) + ' ' + LibMvt);
            end;
          1: begin //Conservation des droits
            //Genere reliquat negatif � DateFinperiodeP
              if RN1 > 0 then
              begin
                LibMvt := 'Reliquat - au ' + datetostr(datefinPeriodeP);
                GenereMvtCloture(T_MVTINS, TS, NoOrdre, 2, 'REL', '-', LibMvt, 'C', DatefinperiodeP, Datefinperiode, RN1, MB1, MB1);
                NoOrdre := NoOrdre + 1;
                writeln(F, Etablis + ' ' + Salarie + ' ' + IntToStr(NoOrdre) + ' ' + LibMvt);
              end;
            //Incr�mente la periode des mvts de + 1
            end;
          2: begin //Paiement du solde
            //Genere reliquat negatif � DateFinperiodeP
              if RN1 > 0 then
              begin
                LibMvt := 'Reliquat - au ' + datetostr(datefinPeriodeP) + '. Mvt sold� au ' + datetostr(DateDebutPeriode);
                GenereMvtCloture(T_MVTINS, TS, NoOrdre, 2, 'REL', '-', LibMvt, 'S', DatefinperiodeP, Datefinperiode, RN1, MB1, MB1);
                NoOrdre := NoOrdre + 1;
                writeln(F, Etablis + ' ' + Salarie + ' ' + IntToStr(NoOrdre) + ' ' + LibMvt);
              end;
            end;
        end; //End du Case
      end; //End IF 1
      TS := T_ListeSal.FindNext([''], [''], false);
    end; //E TS
    CloseFile(F);
    if Assigned(T_MVTINS) and (T_MVTINS.detail.count>0) then // notVide(T_MVTINS, True) then PT20
    begin //B1
      T_MVTINS.SetAllModifie(TRUE);
      T_MVTINS.InsertDB(nil, true);
      FreeAndNil(T_MVTINS);  //T_MVTINS.Free; PT20
    end; //E1
    FiniMoveProgressForm;
    FreeAndNil(T_listesal); //if notVide(T_listesal, True) then T_listesal.free; PT20
    FreeAndNil(T_listeMvt); //if notVide(T_listeMvt, True) then T_listeMvt.free; PT20
    CommitTrans;
    PgiBox('Le traitement s''est correctement termin�.', 'G�n�ration des reliquats');
  except
    Rollback;
    PGIBox('Une erreur est survenue lors de la g�n�ration des reliquats', 'Cl�ture p�riode CP');
  end;
end;

procedure TOF_PGUTILITAIRECP.VerifieCpsal;
var
  Q: tQuery;
  FileN, st, PeriodeN1, Periode: string;
  Periodei: integer;
  T_ListeSal, T_listeMvt, T, TS, t_etab: tob;
  DDebut, Dfin, DtClot: tdatetime;
  FicRapport: THedit;
  PNa, ANa, RNa, BNa, MBa, PNa1, ANa1, RNa1, BNa1, MBa1, PN, AN, RN, BN, PN1, AN1, RN1, BN1, MB1, valo: double;
//TProgress: TQRProgressForm ; PORTAGECWAS
//F            : TextFile;
begin
  if GetControlText('NOMFICHIER') = '' then
    SetControltext('NOMFICHIER', VH_Paie.PGCheminEagl + '\Rapport.txt'); //PT- 1
  FileN := GetControlText('NOMFICHIER');
  Fichier := FileN;

  if SupprimeFichier(FileN) = False then exit;

  AssignFile(F, FileN);
{$I-}ReWrite(F); {$I+}
  if IoResult <> 0 then begin PGIBox('Fichier inaccessible : ' + FileN, 'Abandon du traitement'); Exit; end;
 //DEB PT- 7
  InitMoveProgressForm(nil, Ecran.caption, 'Veuillez patienter SVP ...', 20, FALSE, TRUE);
  MoveCurProgressForm('Chargement des informations Etablissement..');
//FIN PT- 7
  T_etab := Tob.create('ETAB COMPL', nil, -1);
  St := 'SELECT * FROM ETABCOMPL'; //PT- 8 Ajout du crit�re �tablissement
  if GetControlText('ETABLISSEMENT') <> '' then St := St + ' WHERE ETB_ETABLISSEMENT="' + GetControlText('ETABLISSEMENT') + '"';
  St := St + ' ORDER BY ETB_ETABLISSEMENT';
  Q := Opensql(st, true);
  T_etab.loaddetaildb('ETABCOMPL', '', '', Q, False);
  ferme(Q);
 //DEB PT- 7
  MoveCurProgressForm('Chargement des informations Salari�s..');
  InitMove(100, '');
 //FIN PT- 7
  T_ListeSal := TOB.Create('Liste des salarie', nil, -1);
  st := 'SELECT * FROM SALARIES WHERE (PSA_DATESORTIE < "01/10/1900" or PSA_DATESORTIE = "" ' +
    'OR PSA_DATESORTIE IS NULL or PSA_DATESORTIE>="' + usdatetime(date) + '") ';
  if GetControlText('ETABLISSEMENT') <> '' then St := St + ' AND PSA_ETABLISSEMENT="' + GetControlText('ETABLISSEMENT') + '"';
  St := St + ' ORDER BY PSA_ETABLISSEMENT'; //PT- 8 Ajout du crit�re �tablissement
  Q := OpenSql(st, TRUE);
  T_ListeSal.LoadDetailDB('SALARIES', '', '', Q, False);
  ferme(Q);
  MoveCurProgressForm('Chargement des mouvements CP..');
  T_listeMvt := Tob.create('ABSENCESALARIE', nil, -1);
  st := 'SELECT * FROM ABSENCESALARIE WHERE PCN_TYPEMVT="CPA" AND PCN_PERIODECP<2 AND PCN_CODERGRPT<>-1'; //PT- 11 Modif requ�te
  if GetControlText('ETABLISSEMENT') <> '' then //PT- 8 Ajout du crit�re �tablissement
    St := St + ' AND PCN_SALARIE IN (SELECT PSA_SALARIE FROM SALARIES ' +
      'WHERE PSA_ETABLISSEMENT="' + GetControlText('ETABLISSEMENT') + '")';
  St := St + ' ORDER BY PCN_SALARIE,PCN_DATEVALIDITE';
  Q := OpenSql(st, TRUE);
  T_listeMvt.LoadDetailDB('ABSENCESALARIE', '', '', Q, False);
  ferme(Q);

  T := T_etab.findfirst([''], [''], true);
  while t <> nil do
  begin
    DDebut := 0; Dfin := 0;
    Dtclot := T.getvalue('ETB_DATECLOTURECPN');
    Periodei := CalculPeriode(DtClot, Date);
    Periode := inttostr(Periodei);
    PeriodeN1 := Inttostr(Periodei + 1);
    RechercheDate(DDebut, Dfin, DtClot, Periode);
    TS := T_ListeSal.findfirst(['PSA_ETABLISSEMENT'], [T.getvalue('ETB_ETABLISSEMENT')], true);
    while TS <> nil do
    begin
    //DEB PT- 7
      MoveCur(False);
      MoveCurProgressForm('Contr�le compteur salari� : ' + TS.GetValue('PSA_SALARIE') + ' ' + TS.GetValue('PSA_LIBELLE') + ' ' + TS.GetValue('PSA_PRENOM') + '..');
    //FIn PT- 7
      PN1 := 0; AN1 := 0; RN1 := 0; BN1 := 0; PN := 0; AN := 0; RN := 0; BN := 0; PNa := 0;
      ANa := 0; RNa := 0; BNa := 0; MBa := 0; PNa1 := 0; ANa1 := 0; RNa1 := 0; BNa1 := 0; MBa1 := 0;
    //DEB PT- 7
//    AffichelibelleAcqPri(Periode,TS.getvalue('PSA_SALARIE'),date,PN,AN,RN,BN,MB1,false,False);
      CompteCp(T_listeMvt, Periode, TS.getvalue('PSA_SALARIE'), 0, PN, AN, RN, BN, MB1, valo); //PT- 9 Date remplac� par 0
    //FIN PT- 7
      CompteCpAPAYES(T_listeMvt, Periode, TS.getvalue('PSA_SALARIE'), 0, PNa, ANa, RNa, BNa, MBa); //PT- 9 Date remplac� par 0

      if Arrondi(RN, 2) <> Arrondi(RNa, 2) then
        Writeln(F, 'Salari� ' + ts.getvalue('PSA_SALARIE') + ' p�riode N  Cp Acquis restants non sold�s : ' + floattostr(RN) + ' ; Consomm�s restants non sold�s : ' + floattostr(RNa));

      DDebut := 0; Dfin := 0;
      RechercheDate(DDebut, Dfin, DtClot, PeriodeN1);
    //DEB PT- 7
//    AffichelibelleAcqPri(PeriodeN1,TS.getvalue('PSA_SALARIE'),Date,PN1,AN1,RN1,BN1,MB1,false,False);
      CompteCp(T_listeMvt, PeriodeN1, TS.getvalue('PSA_SALARIE'), 0, PN1, AN1, RN1, BN1, MB1, valo); //PT- 9 Date remplac� par 0
    //FIN PT- 7
      CompteCpAPAYES(T_listeMvt, PeriodeN1, TS.getvalue('PSA_SALARIE'), 0, PNa1, ANa1, RNa1, BNa1, MBa1); //PT- 9 Date remplac� par 0
      if arrondi(RN1, 2) <> arrondi(RNa1, 2) then
        Writeln(F, 'Salari� ' + ts.getvalue('PSA_SALARIE') + ' p�riode N-1 Cp Acquis restants non sold�s : ' + floattostr(RN1) + ' ; Consomm�s restants non sold�s : ' + floattostr(RNa1));

      TS := T_ListeSal.findnext(['PSA_ETABLISSEMENT'], [T.getvalue('ETB_ETABLISSEMENT')], true);
    end;
    T := T_etab.findnext([''], [''], true);
  end;
  T_etab.free; T_listeMvt.free; T_ListeSal.free;
  CloseFile(F);
  FiniMoveProgressForm;
//PT- 7
  FiniMove; //PT- 7
  PGIBox('Le traitement s''est correctement termin�.', 'Fin de traitement');
end;
{$ENDIF}

procedure RendCompteurCP(Tob_MvtCp: Tob; i: integer; var Pris, Consomme, Rel, ConsRel, Sld: double);
var TCp: Tob;
  TypeConge, Sens, PeriodePaie: string;
begin
  Pris := 0; Consomme := 0; ConsRel := 0; sld := 0; Rel := 0; //OrdreSld:=0; { PT15 }
  TCp := Tob_MvtCp.FindFirst(['PCN_PERIODECP'], ['' + IntToStr(i) + ''], False);
  while TCP <> nil do
  begin
    if TCp.GetValue('PCN_CODERGRPT') <> -1 then
    begin
      TypeConge := TCp.GetValue('PCN_TYPECONGE');
      Sens := TCp.GetValue('PCN_SENSABS');
      if IsAcquis(TypeConge, Sens) then
      begin
        Consomme := Consomme + TCp.GetValue('PCN_APAYES');
        if (TypeConge = 'REL') and (Sens = '+') then
          Rel := Rel + TCp.GetValue('PCN_JOURS');
      end;
      if IsPris(TypeConge) and (TCp.GetValue('PCN_CODETAPE') <> '...') and (TypeConge <> 'AJP') then // PT- 4 Ajout AND (TypeConge<>'AJP') //PT- 6
      begin
        if Sens = '-' then
          Pris := Pris + TCp.GetValue('PCN_JOURS')
        else
          Pris := Pris - TCp.GetValue('PCN_JOURS');
        PeriodePaie := TCp.GetValue('PCN_PERIODEPAIE');
        if (pos('Reliquat', periodepaie) > 0) then ConsRel := ConsRel + TCp.GetValue('PCN_JOURS');
        if (TypeConge = 'SLD') and (TCp.GetValue('PCN_GENERECLOTURE') = '-') then
        begin
          Sld := Sld + TCp.GetValue('PCN_JOURS');
        //OrdreSld:=TCp.GetValue('PCN_ORDRE'); { PT15 }
        end;
      end;
    end;
    TCp := Tob_MvtCp.FindNext(['PCN_PERIODECP'], ['' + IntToStr(i) + ''], False);
  end;
  if Rel < ConsRel then ConsRel := Rel; { PT15 }
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//                      MOULINETTE DE CONTROLE DES CP
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure VerificationCP(salarie, Etab: string; Silence: Boolean = False); { PT17 }
var
  QCP: TQuery;
  Tob_Salarie, Tob_MvtCp, Tob_InfoCp, T_ASupprimer, T, TBis, TPer, TSal: Tob;
  TypeConge, codetape, PeriodePaie, StDate, Reliquat, FileN, sens, Lib, temp, Duplique: string;
  StWhere, nom, prenom, st: string;
  i, ordre, OrdreMax, Codergrpt, periodepy, MaxPeriode, PeriodeCp, OrdreSld, PeriodeSld: integer; { PT15 }
  Jours, Apayes: Double;
  PN, AN, RN, BN, MB, Valo, Pris, Consomme, Rel, ConsRel, sld: double;
  ConsN, RelN, ConsRelN, SldN, AN1, PN1, RN1, ConsN1, RelN1, ConsRelN1, SldN1: Double;
  MvtDuplique, RelPositif: boolean;
  DatePaiement, DateClotureCP, DD, DF, DSld: TdateTime;
  CompteurPer: array[0..10] of string;
begin
  Debug('Paie Pgi : Lancement de la v�rification CP');
  Reliquat := ''; StWhere := '';
  if Salarie <> '' then
  begin
    if (VH_Paie.PgTypeNumSal = 'NUM') and (length(salarie) < 11) and (isnumeric(salarie)) then
      salarie := ColleZeroDevant(StrToInt(salarie), 10);
    StWhere := 'AND PSA_SALARIE="' + salarie + '" ';
  end;
  if Etab <> '' then StWhere := StWhere + 'AND PSA_ETABLISSEMENT="' + Etab + '" ';
 // DEB PT22
  st := 'UPDATE ABSENCESALARIE SET PCN_CODERGRPT=PCN_ORDRE WHERE PCN_TYPECONGE="PRI" AND PCN_CODETAPE="..."'+
        ' AND PCN_TYPEMVT="CPA" AND PCN_CODERGRPT<>PCN_ORDRE';
  if Salarie <> '' then
    St := st + ' AND PCN_SALARIE="'+ salarie + '" ';
  ExecuteSQL (st);
// FIN PT22
{$IFNDEF EAGLSERVER}
  if not Silence then { PT18 }
  begin
    FileN := VH_Paie.PGCheminEagl + '\V�rificationCp.txt'; //PT- 3
    if SupprimeFichier(FileN, Silence) = False then exit; { PT17 }
    AssignFile(F, FileN);
{$I-}ReWrite(F); {$I+}
    if IoResult <> 0 then
    begin
      PGIBox('Fichier inaccessible : ' + FileN, 'Abandon du traitement'); { PT17 }
      Exit;
    end;
  end;
{$ENDIF}
  Debug('Paie Pgi : Chargement des salari�s');
  QCP := OpenSql('SELECT PSA_SALARIE,PSA_LIBELLE,PSA_PRENOM,PSA_ETABLISSEMENT,' +
    'PSA_CPTYPERELIQ,PSA_RELIQUAT,' +
    'ETB_DATECLOTURECPN,ETB_RELIQUAT FROM SALARIES ' +
    'LEFT JOIN ETABCOMPL ON PSA_ETABLISSEMENT=ETB_ETABLISSEMENT ' +
    'WHERE ETB_CONGESPAYES="X" ' + StWhere + ' ' +
    'AND PSA_SALARIE IN (SELECT PCN_SALARIE FROM ABSENCESALARIE WHERE PCN_TYPEMVT="CPA") ' +
    'ORDER BY PSA_SALARIE', True);
  if not QCP.eof then
  begin
    Tob_Salarie := Tob.Create('La liste des salari�s', nil, -1);
    Tob_Salarie.LoadDetailDB('SALARIES', '', '', QCP, False);
    Ferme(QCP);
  end
  else
  begin
    if not Silence then
    begin
      Pgibox('Aucun mouvement � traiter.', 'Abandon du traitement'); { PT17 }
      Writeln(F, 'Aucun mouvement � traiter.Fin de traitement.');
      CloseFile(F);
    end;
    Ferme(QCP);
    Exit;
  end;
  TSal := Tob_Salarie.FindFirst([''], [''], False);
  while TSal <> nil do
  begin
    Etab := TSal.GetValue('PSA_ETABLISSEMENT');
    Salarie := TSal.GetValue('PSA_SALARIE');
    Nom := TSal.GetValue('PSA_LIBELLE');
    Prenom := TSal.GetValue('PSA_PRENOM');
    if TSal.GetValue('PSA_CPTYPERELIQ') = 'PER' then
      Reliquat := TSal.GetValue('PSA_RELIQUAT')
    else
      Reliquat := TSal.GetValue('ETB_RELIQUAT');
    DateClotureCP := TSal.GetValue('ETB_DATECLOTURECPN');

    PgWriteln(Silence, F, 'Verification des CP pour le salari� : ' + Etab + ' ' + Salarie + ' ' + Nom + ' ' + Prenom); { PT18 }
    Debug('Paie Pgi : Chargement des absences du salari� : ' + Salarie);
    QCP := OpenSql('SELECT * FROM ABSENCESALARIE ' +
      'WHERE PCN_SALARIE="' + salarie + '" AND PCN_TYPEMVT="CPA" ' +
      'ORDER BY PCN_PERIODECP DESC,PCN_DATEVALIDITE ', true); { PT19 }
    if not QCP.eof then
    begin
      Tob_MvtCp := Tob.create('ABSENCESALARIE', nil, -1);
      Tob_MvtCp.LoadDetailDB('ABSENCESALARIE', '', '', QCP, False);
    end;
    Ferme(QCP);

    PgWriteln(Silence, F, 'M�thode de reliquat : ' + Rechdom('PGRELIQUATCP', Reliquat, False)); { PT18 }
    Debug('Paie Pgi : Chargement des p�riodes CP du salari� : ' + Salarie);
    QCP := OpenSql('SELECT MAX(PCN_PERIODECP) AS PER FROM ABSENCESALARIE ' +
      'WHERE PCN_SALARIE="' + salarie + '" AND PCN_TYPEMVT="CPA" ', true);
    Tob_InfoCp := Tob.create('Les infos cp', nil, -1);
    if not QCP.eof then MaxPeriode := QCP.Findfield('PER').AsInteger
    else MaxPeriode := -1;
    Ferme(QCP);
    PgWriteln(Silence, F, ''); { PT18 }
    PgWriteln(Silence, F, 'Descriptif des periodes CP'); { PT18 }
    for i := 0 to MaxPeriode do
    begin
      Debug('Paie Pgi : Traitement de la p�riode CP : ' + IntToStr(i));
      T := Tob.create('La periode Cp', Tob_InfoCp, -1);
      T.AddchampSup('PERIODE', False);
      T.AddchampSup('DEBUTPERIODE', False);
      T.AddchampSup('FINPERIODE', False);
      T.PutValue('PERIODE', i);
      DD := PlusDate((PlusDate(DateClotureCP, -1, 'A') + 1), -i, 'A');
      T.PutValue('DEBUTPERIODE', DD);
      DF := PlusDate(DateClotureCP, -i, 'A');
      T.PutValue('FINPERIODE', DF);
      PgWriteln(Silence, F, ' P�riode ' + IntToStr(i) + ' Debut : ' + DateToStr(DD) + ' Fin : ' + DateToStr(DF)); { PT18 }
    end;
    PgWriteln(Silence, F, ''); { PT18 }
    if Tob_MvtCp.detail.count > 0 then
    begin
      PgWriteln(Silence, F, 'Liste des mvts Cp :'); { PT18 }
      PgWriteln(Silence, F, 'P�riode' + #9 + 'Ordre' + #9 + 'TypeConge' + #9 + 'Sens' + #9 + 'NbJour' + #9 + 'Consomm�' + #9 + 'Top�' + #9 + 'Eclat�' + #9 + 'Dupliqu�' + #9 + 'DatePaiement'); { PT18 }
    end
    else
      PgWriteln(Silence, F, 'Aucuns mvts � v�rifier'); { PT18 }
    OrdreMax := 0; { PT15 }
    Debug('Paie Pgi : Traitement des mouvements CP du salarie : ' + Salarie);
    for i := 0 to Tob_MvtCp.detail.count - 1 do
    begin
      PeriodeCp := Tob_MvtCp.detail[i].GetValue('PCN_PERIODECP');
      TypeConge := Tob_MvtCp.detail[i].GetValue('PCN_TYPECONGE');
      periodepy := Tob_MvtCp.detail[i].GetValue('PCN_PERIODEPY');
      codetape := Tob_MvtCp.detail[i].GetValue('PCN_CODETAPE');
      Codergrpt := Tob_MvtCp.detail[i].GetValue('PCN_CODERGRPT');
      ordre := Tob_MvtCp.detail[i].GetValue('PCN_ORDRE');
      if Ordre > OrdreMax then OrdreMax := Ordre; { PT15 }
      Duplique := Tob_MvtCp.detail[i].GetValue('PCN_MVTDUPLIQUE');
      MvtDuplique := (Duplique = 'X');
      DatePaiement := Tob_MvtCp.detail[i].GetValue('PCN_DATEPAIEMENT');
      PeriodePaie := Tob_MvtCp.detail[i].GetValue('PCN_PERIODEPAIE');
      Jours := Tob_MvtCp.detail[i].GetValue('PCN_JOURS');
      Apayes := Tob_MvtCp.detail[i].GetValue('PCN_APAYES');
      Sens := Tob_MvtCp.detail[i].GetValue('PCN_SENSABS');
      Debug('Paie Pgi : Traitement du mouvement de type ' + Typeconge + ' et d''ordre ' + IntToStr(Ordre));
      EcritLigneMvt(PeriodeCp, Ordre, Codergrpt, TypeConge, Sens, Codetape, Duplique, Jours, APayes, DatePaiement, silence); { PT18 }
    {       //Coh�rence PeriodeCp et mvt Clotur�
      if (PeriodeCp>1) and ((codetape='...') or (Codetape='')) then
        Begin
        writeln (F,'** Periode Cp > 1 : affectation Consomm� et Code etape **');
        if
        Tob_MvtCp.detail[i].PutValue('PCN_APAYES',Jours);
        Tob_MvtCp.detail[i].PutValue('PCN_CODETAPE','C');
        End; }
           //Coh�rence du compteur jours et consomm�
      if Jours < Apayes then
      begin
        PgWriteln(Silence, F, '** Consomm� > NbJour : affectation Consomm� := Nbjour **'); { PT18 }
        Tob_MvtCp.detail[i].PutValue('PCN_APAYES', Jours);
      end;
          //Correction bug mvt pris � �clater non top� comme Pay�
      if (TypeConge = 'PRI') and (Codergrpt = -1) and (periodepy <> -1) and (Codetape = '...') then //PT- 6
      begin
        PgWriteln(Silence, F, '** Mvt �clat� non top� comme pay� **'); { PT18 }
        Tob_MvtCp.detail[i].PutValue('PCN_CODETAPE', 'P');
      end;
      codetape := Tob_MvtCp.detail[i].GetValue('PCN_CODETAPE');
        //Correction bug mvt pris �clat� sur reliquat dont date paiement erronn�
      if (TypeConge = 'PRI') and (MvtDuplique) and (periodepy <> -1) and (DatePaiement < 10) and (pos('Reliquat', periodepaie) > 0) then
      begin
        StDate := Trim(Copy(PeriodePaie, Pos('01/', PeriodePaie), Length(PeriodePaie)));
        if isvaliddate(StDate) then
        begin
          PgWriteln(Silence, F, '** Date de paiement non affect�e **'); { PT18 }
          Tob_MvtCp.detail[i].PutValue('PCN_DATEPAIEMENT', PlusDate(StrToDate(StDate), 1, 'A') - 1);
        end;
        DatePaiement := Tob_MvtCp.detail[i].GetValue('PCN_DATEPAIEMENT');
      end;
       //Coh�rence date de paiement et periodecp
      if (TypeConge = 'PRI') and (Codetape = 'P') then
      begin
        Tper := Tob_InfoCp.FindFirst(['PERIODE'], ['' + IntToStr(PeriodeCp) + ''], False);
        if Tper <> nil then
          if (DatePaiement < Tper.GetValue('DEBUTPERIODE')) or (DatePaiement > Tper.GetValue('FINPERIODE')) then { PT15 }
          begin
            PgWriteln(Silence, F, '** Date de paiement non comprise dans la p�riode de l''exercice **'); { PT18 }
            Tob_MvtCp.detail[i].PutValue('PCN_DATEPAIEMENT', Tper.GetValue('FINPERIODE'));
          end;
      end;
      { DEB PT15 }
      if (Codetape = 'C') and (PeriodeCp < 2) then
      begin
        PgWriteln(Silence, F, '** Mvt p�riode ouverte top� clotur� **'); { PT18 }
        if (TypeConge = 'PRI') then Tob_MvtCp.detail[i].PutValue('PCN_CODETAPE', 'P')
        else Tob_MvtCp.detail[i].PutValue('PCN_CODETAPE', '...')
      end;
      if ((TypeConge = 'AJU') or (TypeConge = 'AJP')) and (sens = '-') and (PeriodeCp < 2) then
      begin
        PgWriteln(Silence, F, '** Mvt d''ajustement - consomm� � tord **'); { PT18 }
        Tob_MvtCp.detail[i].PutValue('PCN_APAYES', 0);
      end;
      if (PeriodeCp > 1) and (Codetape = '...') then
      begin
        PgWriteln(Silence, F, '** Mvt clotur� non top� clotur� **'); { PT18 }
        Tob_MvtCp.detail[i].PutValue('PCN_CODETAPE', 'C');
      end;
      if (TypeConge = 'SLD') and (Codetape = '...') and (PeriodeCp < 2) and (Tob_MvtCp.detail[i].GetValue('PCN_GENERECLOTURE') = '-') then
      begin
        PgWriteln(Silence, F, '** Mvt SLD non top� pay� **'); { PT18 }
        Tob_MvtCp.detail[i].PutValue('PCN_CODETAPE', 'P');
      end;
      { FIN PT15 }
    end;
    //R�affectation des pris �clat�s sur periode n si restant sur n-1
    PgWriteln(Silence, F, ''); { PT18 }
    PgWriteln(Silence, F, 'Imputation des PRI pay� sur p�riode n-1 ou n si n�cessaire'); { PT18 }
    Debug('Paie Pgi : R�imputation des PRI sur les p�riodes ouvertes');
    ReImputePriPeriode(Tob_MvtCp, Tob_InfoCp, Salarie, OrdreMax, silence); { PT15 } { PT18 }
    //R�affectation des compteurs par periode et du codetape
    if (MaxPeriode <> -1) and (Tob_MvtCp.detail.count > 0) then
    begin
      Debug('Paie Pgi : Recherche de mouvement sold�');
      OrdreSld := 0; PeriodeSld := 50; DSld := idate1900; { DEB PT15 } { PT19 }
      T := Tob_MvtCp.FindFirst(['PCN_TYPECONGE', 'PCN_GENERECLOTURE', 'PCN_MVTDUPLIQUE'], ['SLD', '-', '-'], False);
      while T <> nil do
      begin
        if DSld <= T.GetValue('PCN_DATEVALIDITE') then { DEB PT19 }
        begin
          DSld := T.GetValue('PCN_DATEVALIDITE');
          if T.GetValue('PCN_ORDRE') > OrdreSld then OrdreSld := T.GetValue('PCN_ORDRE');
          if T.GetValue('PCN_PERIODECP') < PeriodeSld then PeriodeSld := T.GetValue('PCN_PERIODECP');
        end; { FIN PT19 }
        T := Tob_MvtCp.FindNext(['PCN_TYPECONGE', 'PCN_GENERECLOTURE', 'PCN_MVTDUPLIQUE'], ['SLD', '-', '-'], False);
      end; { FIN PT15 }
      for i := 1 downto 0 do
      begin
        Debug('Paie Pgi : D�compte des soldes sur p�riode ' + IntToStr(i));
        CompteCP(Tob_MvtCp, IntToStr(i), Salarie, 0, PN, AN, RN, BN, MB, Valo);
        Rel := 0;
        //V�rification des mvts pay�s et �clat�s
        T := Tob_MvtCp.FindFirst(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_SENSABS'], ['' + IntToStr(i) + '', 'REL', '+'], False);
        while T <> nil do
        begin
          Rel := Rel + T.GetValue('PCN_JOURS');
          T := Tob_MvtCp.FindNext(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_SENSABS'], ['' + IntToStr(i) + '', 'REL', '+'], False);
        end;
        Debug('Paie Pgi : Analyse des PRI sur p�riode ' + IntToStr(i));
        ControleMvtPris(Tob_MvtCp, Tob_InfoCp, i, Salarie, rel, silence); { PT18 }
        Debug('Paie Pgi : Evalue diff�rence PRI/CONSOMME sur p�riode ' + IntToStr(i));
        RendCompteurCP(Tob_MvtCp, i, Pris, Consomme, Rel, ConsRel, Sld); { PT15 }
        Debug('Paie Pgi : Mise � jour des consomm�s sur p�riode ' + IntToStr(i));
        MajCompteurCP(Tob_MvtCp, i, OrdreSld, PeriodeSld, Pris, Consomme, ConsRel, Sld, DSld, silence); { PT15 } { PT18 } { PT19 }
      end;
    end;
    PgWriteln(Silence, F, ''); { PT18 }
    PgWriteln(Silence, F, 'Fin de v�rification pour le salari� : ' + Etab + ' ' + Salarie + ' ' + Nom + ' ' + Prenom); { PT18 }
    PgWriteln(Silence, F, ''); { PT18 }
    try
      BeginTrans;
      Debug('Paie Pgi : Mise � jour des mouvements CP');
      Tob_MvtCp.SetAllModifie(TRUE);
      Tob_MvtCp.InsertOrUpdateDB(TRUE);
      CommitTrans;
    except
      Rollback;
      PgWriteln(Silence, F, 'Une erreur est survenue lors de la mise � jour des mvts CP de : ' + Etab + ' ' + Salarie + ' ' + Nom + ' ' + Prenom); { PT18 }
    end;
    Debug('Paie Pgi : Lib�ration de la m�moire');
    FreeAndNil(Tob_MvtCp); { PT15 }
    FreeAndNil(Tob_InfoCp); { PT15 }
    TSal := Tob_Salarie.FindNext([''], [''], False);
  end;
  if not Silence then { PT18 }
  begin
    CloseFile(F);
    PgiBox('Traitement termin�.', 'V�rification Cp :'); { PT17 }
  end;
  if Tob_Salarie <> nil then Tob_Salarie.free;
  Debug('Paie Pgi : Fin de la v�rification CP');
end;

procedure ControleMvtPris(Tob_MvtCp, Tob_InfoCp: TOB;
  Periode: Integer; Salarie: string; rel: double; Silence: Boolean);
var
  TPris, TPrisEclate, Tob_Dupliquer, T_ASupprimer, T, TFille, TInfo: Tob;
  Ordre: Integer;
  Pris, PrisDuplique, PrisDupliqueRel, ConsoReliq: Double;
  Base, Absence, AbsenceManu, Valox, ValoMS, ValoRetenue, ValoManuelle: Double;
  PeriodePaie, StWhere: string;
  Eclate: Boolean;
begin
  ConsoReliq := 0;
  PgWriteln(Silence, F, ''); { PT18 }
  PgWriteln(Silence, F, 'Contr�le des mvts pris pay�s sur p�riode ' + IntToStr(Periode)); { PT18 }
  T_ASupprimer := TOB.Create('Les mvts � supprimer', nil, -1);
  Tob_Dupliquer := TOB.Create('Les mvts dupliqu�s', nil, -1);
  Tob_Dupliquer.Dupliquer(Tob_MvtCp, TRUE, TRUE, TRUE);
  TInfo := Tob_InfoCp.FindFirst(['PERIODE'], ['' + IntToStr(Periode) + ''], False);
  TPris := Tob_Dupliquer.FindFirst(['PCN_TYPECONGE', 'PCN_PERIODECP', 'PCN_CODETAPE', 'PCN_MVTDUPLIQUE'], ['PRI', '' + IntToStr(Periode) + '', 'P', '-'], False);
  while TPris <> nil do
  begin
    PrisDuplique := 0; Eclate := False;
    PrisDupliqueRel := 0; PeriodePaie := '';
    Ordre := TPris.GetValue('PCN_ORDRE');
    Pris := TPris.GetValue('PCN_JOURS');
    Base := TPris.GetValue('PCN_BASE');
    Absence := TPris.GetValue('PCN_ABSENCE'); AbsenceManu := TPris.GetValue('PCN_ABSENCEMANU');
    Valox := TPris.GetValue('PCN_VALOX'); ValoMS := TPris.GetValue('PCN_VALOMS');
    ValoRetenue := TPris.GetValue('PCN_VALORETENUE'); ValoManuelle := TPris.GetValue('PCN_VALOMANUELLE');
    PeriodePaie := TPris.GetValue('PCN_PERIODEPAIE');
    if (pos('Reliquat', periodepaie) > 0) then ConsoReliq := ConsoReliq + Pris;
  //Recherche si mvts Dupliqu�s existent et calcul du nb de jours pris dupliqu�s et du nb de mvt
  //A �x�cuter que sur consommation du reliquat
    TPrisEclate := Tob_MvtCp.FindFirst(['PCN_TYPECONGE', 'PCN_PERIODECP', 'PCN_MVTDUPLIQUE', 'PCN_CODERGRPT'], ['PRI', '' + IntToStr(Periode) + '', 'X', '' + IntToStr(Ordre) + ''], False);
    while (TPrisEclate <> nil) and (Rel > 0) and (Rel - ConsoReliq > 0) do
    begin
      Eclate := True;
      TPris.PutValue('PCN_CODERGRPT', -1);
      PeriodePaie := TPrisEclate.GetValue('PCN_PERIODEPAIE');
      if (pos('Reliquat', periodepaie) > 0) then
        PrisDupliqueRel := PrisDupliqueRel + TPrisEclate.GetValue('PCN_JOURS')
      else
        PrisDuplique := PrisDuplique + TPrisEclate.GetValue('PCN_JOURS');
      PgWriteln(Silence, F, 'V�rification du mvt PRI dupliqu� d''ordre:' + IntToStr(TPrisEclate.GetValue('PCN_ORDRE'))); { PT18 }
      TPrisEclate.changeparent(T_ASupprimer, -1);
      TPrisEclate := Tob_MvtCp.FindNext(['PCN_TYPECONGE', 'PCN_PERIODECP', 'PCN_MVTDUPLIQUE', 'PCN_CODERGRPT'], ['PRI', '' + IntToStr(Periode) + '', 'X', '' + IntToStr(Ordre) + ''], False);
    end;
    if (Eclate = True) and (Pris <> PrisDuplique + PrisDupliqueRel) and (Rel > 0) and (Pris - (Rel - ConsoReliq) > 0) then //Le mvt PRI<> SUM PRI DUPLIQUE { PT15 }
    begin
    //Reg�n�ration des mvt PRI dupliqu�
      T := T_ASupprimer.FindFirst([''], [''], False);
      if T <> nil then
      begin
        PgWriteln(Silence, F, 'Reg�n�ration des mvts PRI dupliqu�s'); { PT18 }
        TFille := TOB.Create('Les mvts dupliqu�s reg�n�r�s', Tob_MvtCp, -1);
        TFille.Dupliquer(T, TRUE, TRUE, TRUE);
        TFille.PutValue('PCN_JOURS', (Rel - ConsoReliq));
        TFille.PutValue('PCN_HEURES', (Rel - ConsoReliq) * 7);
        TFille.PutValue('PCN_PERIODEPY', TFille.GetValue('PCN_PERIODECP'));
        if Base <> 0 then TFille.PutValue('PCN_BASE', (Arrondi(Base * (Rel - ConsoReliq) / Pris, 2))) else TFille.PutValue('PCN_BASE', 0);
        if Absence <> 0 then TFille.PutValue('PCN_ABSENCE', (Arrondi(Absence * (Rel - ConsoReliq) / Pris, 2))) else TFille.PutValue('PCN_ABSENCE', 0);
        if AbsenceManu <> 0 then TFille.PutValue('PCN_ABSENCEMANU', (Arrondi(AbsenceManu * (Rel - ConsoReliq) / Pris, 2))) else TFille.PutValue('PCN_ABSENCEMANU', 0);
        if ValoX <> 0 then TFille.PutValue('PCN_VALOX', (Arrondi(ValoX * (Rel - ConsoReliq) / Pris, 2))) else TFille.PutValue('PCN_VALOX', 0);
        if ValoMS <> 0 then TFille.PutValue('PCN_VALOMS', (Arrondi(ValoMS * (Rel - ConsoReliq) / Pris, 2))) else TFille.PutValue('PCN_VALOMS', 0);
        if ValoRetenue <> 0 then TFille.PutValue('PCN_VALORETENUE', (Arrondi(ValoRetenue * (Rel - ConsoReliq) / Pris, 2))) else TFille.PutValue('PCN_VALORETENUE', 0);
        if ValoManuelle <> 0 then TFille.PutValue('PCN_VALOMANUELLE', (Arrondi(ValoManuelle * (Rel - ConsoReliq) / Pris, 2))) else TFille.PutValue('PCN_VALOMANUELLE', 0);
        if TInfo <> nil then TFille.PutValue('PCN_PERIODEPAIE', 'Reliquat au ' + datetostr(TInfo.GetValue('DEBUTPERIODE'))) else TFille.PutValue('PCN_PERIODEPAIE', 'Reliquat');
        EcritLigneMvt(Periode, TFille.GetValue('PCN_ORDRE'), ordre, 'PRI', '-', 'P', 'X', (Rel - ConsoReliq), 0, TFille.GetValue('PCN_DATEPAIEMENT'), silence); { PT18 }
        TFille := TOB.Create('Les mvts dupliqu�s reg�n�r�s', Tob_MvtCp, -1);
        TFille.Dupliquer(T, TRUE, TRUE, TRUE);
        TFille.PutValue('PCN_ORDRE', T.GetValue('PCN_ORDRE') + 1);
        TFille.PutValue('PCN_JOURS', Pris - (Rel - ConsoReliq));
        TFille.PutValue('PCN_HEURES', (Pris - Rel - ConsoReliq) * 7);
        TFille.PutValue('PCN_PERIODEPY', TFille.GetValue('PCN_PERIODECP'));
        if Base <> 0 then TFille.PutValue('PCN_BASE', (Arrondi(Base * (Pris - Rel - ConsoReliq) / Pris, 2))) else TFille.PutValue('PCN_BASE', 0);
        if Absence <> 0 then TFille.PutValue('PCN_ABSENCE', (Arrondi(Absence * (Pris - Rel - ConsoReliq) / Pris, 2))) else TFille.PutValue('PCN_ABSENCE', 0);
        if AbsenceManu <> 0 then TFille.PutValue('PCN_ABSENCEMANU', (Arrondi(AbsenceManu * (Pris - Rel - ConsoReliq) / Pris, 2))) else TFille.PutValue('PCN_ABSENCEMANU', 0);
        if ValoX <> 0 then TFille.PutValue('PCN_VALOX', (Arrondi(ValoX * (Pris - Rel - ConsoReliq) / Pris, 2))) else TFille.PutValue('PCN_VALOX', 0);
        if ValoMS <> 0 then TFille.PutValue('PCN_VALOMS', (Arrondi(ValoMS * (Pris - Rel - ConsoReliq) / Pris, 2))) else TFille.PutValue('PCN_VALOMS', 0);
        if ValoRetenue <> 0 then TFille.PutValue('PCN_VALORETENUE', (Arrondi(ValoRetenue * (Pris - Rel - ConsoReliq) / Pris, 2))) else TFille.PutValue('PCN_VALORETENUE', 0);
        if ValoManuelle <> 0 then TFille.PutValue('PCN_VALOMANUELLE', (Arrondi(ValoManuelle * (Pris - Rel - ConsoReliq) / Pris, 2))) else TFille.PutValue('PCN_VALOMANUELLE', 0);
        if TInfo <> nil then TFille.PutValue('PCN_PERIODEPAIE', 'P�riode du ' + datetostr(TInfo.GetValue('DEBUTPERIODE')) + ' au ' + datetostr(TInfo.GetValue('FINPERIODE'))) else TFille.PutValue('PCN_PERIODEPAIE', 'P�riode');
        EcritLigneMvt(Periode, TFille.GetValue('PCN_ORDRE'), ordre, 'PRI', '-', 'P', 'X', Pris - (Rel - ConsoReliq), 0, TFille.GetValue('PCN_DATEPAIEMENT'), silence); { PT18 }
        try
          BeginTrans;
          StWhere := 'AND (';
          T := T_ASupprimer.FindFirst([''], [''], False);
          while T <> nil do
          begin
            if Trim(StWhere) <> 'AND (' then StWhere := StWhere + 'OR ';
            PgWriteln(Silence, F, '** Suppression du mvt erron� PRI dupliqu�s d''ordre : ' + IntToStr(T.GetValue('PCN_ORDRE')) + '**'); { PT18 }
            StWhere := StWhere + ' PCN_ORDRE=' + IntTOStr(T.GetValue('PCN_ORDRE')) + ' ';
            T := T_ASupprimer.FindNext([''], [''], False);
          end;
          if Trim(StWhere) <> 'AND (' then
          begin
            StWhere := StWhere + ')';
            ExecuteSql('DELETE FROM ABSENCESALARIE WHERE PCN_TYPEMVT="CPA" ' +
              'AND PCN_TYPECONGE="PRI" AND PCN_SALARIE="' + Salarie + '" ' + StWhere + ' ');
          end;
       // If T_ASupprimer<>nil then T_ASupprimer.DeleteDB(False);
          CommitTrans;
        except
          Rollback;
          PgWriteln(Silence, F, 'Une erreur est survenue lors de la suppression des mvts CP du salari� : ' + Salarie); { PT18 }
        end;
      end;
    end
    else
    begin
      T := T_ASupprimer.FindFirst([''], [''], False);
      while T <> nil do
      begin
        T.changeparent(Tob_MvtCp, -1);
        T := T_ASupprimer.FindNext([''], [''], False);
      end;
    end;
    TPris := Tob_Dupliquer.FindNext(['PCN_TYPECONGE', 'PCN_PERIODECP', 'PCN_CODETAPE', 'PCN_MVTDUPLIQUE'], ['PRI', '' + IntToStr(Periode) + '', 'P', '-'], False);
  end;
  if Tob_Dupliquer <> nil then Tob_Dupliquer.free;
  if T_ASupprimer <> nil then T_ASupprimer.free;
end;

procedure EcritLigneMvt(PeriodeCp, Ordre,
  Codergrpt: integer; TypeConge, Sens, Codetape, Duplique: string; Jours,
  APayes: double; DatePaiement: TDateTime; Silence: Boolean);
var lib: string;
begin
  Lib := '';
  Lib := IntToStr(PeriodeCp) + #9 + IntToStr(Ordre) + #9 + TypeConge + #9#9 + Sens + #9 + FloatToStr(Jours) +
    #9 + FloatToStr(APayes) + #9#9 + Codetape + #9 + IntToStr(Codergrpt) + #9 + Duplique + #9 + DateToStr(DatePaiement);
{Temp:=StringOfChar(' ',7); Temp[4]:=IntToStr(PeriodeCp)[1];  Lib:=Temp;
Temp:=StringOfChar(' ',5); Insert(IntToStr(Ordre),Temp,(4-Length(IntToStr(Ordre)))); Lib:=Lib+' '+TrimRight(Temp)+' ';
Lib:=Lib+'     '+TypeConge+'   ';
Lib:=Lib+'  '+Sens+'  ';
Temp:=StringOfChar(' ',6); Insert(FloatToStr(Jours),Temp,(6-Length(FloatToStr(Jours)))); Lib:=Lib+' '+TrimRight(Temp)+'  ';
Temp:=StringOfChar(' ',8); Insert(FloatToStr(APayes),Temp,(8-Length(FloatToStr(APayes)))); Lib:=Lib+' '+TrimRight(Temp);
Temp:=StringOfChar(' ',4); if Codetape<>'...' then Temp[2]:=Codetape[1]; Lib:=Lib+' '+Temp; //PT- 6
Temp:=StringOfChar(' ',6); Insert(IntToStr(Codergrpt),Temp,(6-Length(IntToStr(Codergrpt)))); Lib:=Lib+' '+TrimRight(Temp)+' ';
Temp:=StringOfChar(' ',8); Temp[4]:=Duplique[1];  Lib:=Lib+' '+TrimRight(Temp);
Lib:=Lib+'      '+DateToStr(DatePaiement);  }
  PgWriteln(Silence, F, Lib); { PT18 }
end;

procedure MajCompteurCP(Tob_MvtCp: Tob; Periode, OrdreSld, PeriodeSld: integer; Pris, Consomme, ConsRel, Sld: double; DSld: TDateTime; Silence: Boolean);
var
  TCPMaj: Tob;
  i,Ordre: integer;
  TypeConge, Sens: string;
  Trouve: Boolean; { PT15 }
  DValid: TDateTime;
begin
  if not Assigned(Tob_MvtCp) then exit; { PT19 }
  Tob_MvtCp.Detail.Sort('PCN_PERIODECP DESC,PCN_DATEVALIDITE,PCN_ORDRE'); { PT19 }
  PgWriteln(Silence, F, ''); { PT18 }
  PgWriteln(Silence, F, 'V�rification des compteurs sur p�riode ' + IntToStr(Periode)); { PT18 }
  Trouve := False; { PT15 }
  if Arrondi(Consomme, 2) <> Arrondi(pris, 2) then
    PgWriteln(Silence, F, 'Ecart entre consomm�e(' + FloatToStr(Consomme) + ') et pris(' + FloatToStr(Pris) + ') sur p�riode ' + IntToStr(Periode) + ''); { PT18 }
  PgWriteln(Silence, F, 'P�riode' + #9 + 'Ordre' + #9 + 'TypeConge' + #9 + 'Sens' + #9 + 'NbJour' + #9 + 'Consomm�' + #9 + 'Top�' + #9 + 'Eclat�' + #9 + 'Dupliqu�' + #9 + 'DatePaiement'); { PT18 }
  if ConsRel > 0 then
  begin
    TCPMaj := Tob_MvtCp.FindFirst(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_SENSABS'], ['' + IntToStr(Periode) + '', 'REL', '+'], False);
    if TCPMaj <> nil then
    begin
      Trouve := True; { DEB PT15 }
      if ConsRel > TCPMaj.GetValue('PCN_JOURS') then TCPMaj.PutValue('PCN_APAYES', Arrondi(TCPMaj.GetValue('PCN_JOURS'), 2))
      else TCPMaj.PutValue('PCN_APAYES', Arrondi(ConsRel, 2));
      Pris := Arrondi(Pris - ConsRel, 2);
      if (OrdreSld > TCPMaj.GetValue('PCN_ORDRE')) or (TCPMaj.GetValue('PCN_PERIODECP') > PeriodeSld) then { PT15 }
      begin
        TCPMaj.PutValue('PCN_CODETAPE', 'S');
        Sld := Arrondi(Sld - TCPMaj.GetValue('PCN_JOURS'), 2);
      end { FIN PT15 }
      else
        TCPMaj.PutValue('PCN_CODETAPE', '...');
      PgWriteln(Silence, F, '** Maj du reliquat **'); { PT18 }
      EcritLigneMvt(Periode, TCPMaj.GetValue('PCN_ORDRE'), TCPMaj.GetValue('PCN_CODERGRPT'),
        'REL', '+', TCPMaj.GetValue('PCN_CODETAPE'), '-', TCPMaj.GetValue('PCN_JOURS'),
        TCPMaj.GetValue('PCN_APAYES'), TCPMaj.GetValue('PCN_DATEPAIEMENT'), silence); { PT18 }
    end;
  end;
//  TCPMaj := Tob_MvtCp.FindFirst(['PCN_PERIODECP'], ['' + IntToStr(Periode) + ''], False);
  PgWriteln(Silence, F, '** R�affectation des consomm�s et Code �tape **'); { PT18 }
  Tob_MvtCp.Detail.Sort('PCN_PERIODECP DESC,PCN_DATEVALIDITE,PCN_ORDRE'); { PT21 }
  For i := 0 to Tob_MvtCp.detail.count-1 do                               { PT21 }
    Begin
    TCPMaj := Tob_MvtCp.detail[i];                                        { PT21 }
    if TCPMaj.GetValue('PCN_PERIODECP') <> Periode then Continue;         { PT21 }
    TypeConge := TCPMaj.GetValue('PCN_TYPECONGE');
    Sens := TCPMaj.GetValue('PCN_SENSABS');
    Ordre := TCPMaj.GetValue('PCN_ORDRE');
    DValid := TCPMaj.GetValue('PCN_DATEVALIDITE'); { PT19 }
    if (IsAcquis(TypeConge, Sens) and (TypeConge <> 'REL') and not (((TypeConge = 'AJU') or (TypeConge = 'AJP')) and (Sens = '-'))) or ((TypeConge = 'AJP') and (Sens = '+')) then { PT15 }
    begin
      if ((OrdreSld > Ordre) and (DSld >= DValid)) or (TCPMaj.GetValue('PCN_PERIODECP') > PeriodeSld) then { PT15 } { PT19 }
      begin { DEB PT15 }
        TCPMaj.PutValue('PCN_CODETAPE', 'S');
        Sld := Arrondi(Sld - TCPMaj.GetValue('PCN_JOURS'), 2);
      end { FIN PT15 }
      else
        TCPMaj.PutValue('PCN_CODETAPE', '...'); //PT- 6
      if Pris >= TCPMaj.GetValue('PCN_JOURS') then
      begin
        TCPMaj.PutValue('PCN_APAYES', Arrondi(TCPMaj.GetValue('PCN_JOURS'), 2));
        Pris := Arrondi(Pris - TCPMaj.GetValue('PCN_JOURS'), 2); { PT15 }
      end
      else
      begin
        TCPMaj.PutValue('PCN_APAYES', Arrondi(Pris, 2));
        Pris := 0;
      end;
    end
    else { DEB PT15 }
      if (TypeConge = 'REL') and (Sens = '+') and (ConsRel = 0) then
      begin
        TCPMaj.PutValue('PCN_CODETAPE', '...');
        TCPMaj.PutValue('PCN_APAYES', 0);
      end
      else
        if ((TypeConge = 'AJP') or (TypeConge = 'AJU')) and (Sens = '-') then
        begin
          TCPMaj.PutValue('PCN_APAYES', 0);
          if ((OrdreSld > Ordre) and (DSld >= DValid)) or (TCPMaj.GetValue('PCN_PERIODECP') > PeriodeSld) then { PT19 }
            TCPMaj.PutValue('PCN_CODETAPE', 'S')
          else
            TCPMaj.PutValue('PCN_CODETAPE', '...');
        end; { FIN PT15 }
    EcritLigneMvt(Periode, ordre, TCPMaj.GetValue('PCN_CODERGRPT'),
      TypeConge, Sens, TCPMaj.GetValue('PCN_CODETAPE'), TCPMaj.GetValue('PCN_MVTDUPLIQUE'),
      TCPMaj.GetValue('PCN_JOURS'), TCPMaj.GetValue('PCN_APAYES'), TCPMaj.GetValue('PCN_DATEPAIEMENT'), silence); { PT18 }
    //TCPMaj := Tob_MvtCp.FindNext(['PCN_PERIODECP'], ['' + IntToStr(Periode) + ''], False); { PT21 }
  end;
  { DEB PT15 Si pris restant et reliquat non trait� alors sans doute pris sur reliquat non r�f�renc� }
  { On consomme quand m�me le reliquat + }
  if (Pris > 0) and (Trouve = False) then
  begin
    TCPMaj := Tob_MvtCp.FindFirst(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_SENSABS'], ['' + IntToStr(Periode) + '', 'REL', '+'], False);
    if Assigned(TCPMaj) then
    begin
      if (OrdreSld > TCPMaj.GetValue('PCN_ORDRE')) or (TCPMaj.GetValue('PCN_PERIODECP') > PeriodeSld) then { PT15 }
        TCPMaj.PutValue('PCN_CODETAPE', 'S')
      else
        TCPMaj.PutValue('PCN_CODETAPE', '...');
      if Pris >= TCPMaj.GetValue('PCN_JOURS') then
        TCPMaj.PutValue('PCN_APAYES', Arrondi(TCPMaj.GetValue('PCN_JOURS'), 2))
      else
        TCPMaj.PutValue('PCN_APAYES', Arrondi(Pris, 2));
    end;
  end;
   { FIN PT15 }
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 18/03/2004
Modifi� le ... :   /  /
Description .. : V�rifie la coh�rence des PRI sur Acquis sur p�riodes
Suite ........ : ouvertes
Mots clefs ... : PAIE;CONGESPAYES
*****************************************************************}
{ DEB PT15 }

procedure ReImputePriPeriode(Tob_MvtCp, Tob_InfoCp: Tob; Salarie: string; OrdreMax: Integer; silence: boolean);
var
  AN1, PN1, RN1, PN, AN, RN, BN, MB, Valo, Pris, SurPris: double;
  T, T1, T2, Tper: Tob;
  Rgrpt, Ordre, OrdreCp, i: Integer;
  DateDebPer1, DateFinPer1, DateDebPer, DateFinPer: TDateTime;
begin
  DateDebPer := Idate1900;
  DateFinPer := Idate1900;
  DateDebPer1 := Idate1900;
  DateFinPer1 := Idate1900;
  Debug('Paie Pgi : Evaluation des acquis, pris sur N');
  CompteCP(Tob_MvtCp, '0', Salarie, 0, PN, AN, RN, BN, MB, Valo);
  Debug('Paie Pgi : Evaluation des acquis, pris sur N-1');
  CompteCP(Tob_MvtCp, '1', Salarie, 0, PN1, AN1, RN1, BN, MB, Valo);
  AN1 := Arrondi(AN1, 2);
  PN1 := Arrondi(PN1, 2);
  RN1 := Arrondi(RN1, 2);
  PN := Arrondi(PN, 2);
  RN := Arrondi(RN, 2);
  { PRI SUR N ALORS QUE RESTE SUR N-1 }
  if (RN1 > 0) and (PN > 0) then
  begin
    Debug('Paie Pgi : RESTANT SUR N-1 & PRI sur N');
     //Tri� pour d�buter sur le dernier CP Pri pay�s
    Tob_MvtCp.Detail.Sort('PCN_PERIODECP,PCN_DATEVALIDITE DESC,PCN_CODERGRPT');
    PgWriteln(Silence, F, ''); { PT18 }
    PgWriteln(Silence, F, 'Acquis restant sur N-1 de ' + FloatToStr(RN1) + ' et pris sur N de ' + FloatToStr(PN) + '!'); { PT18 }
    Tper := Tob_InfoCp.FindFirst(['PERIODE'], ['1'], False);
    if Assigned(Tper) then
    begin
      DateDebPer1 := Tper.GetValue('DEBUTPERIODE');
      DateFinPer1 := Tper.GetValue('FINPERIODE');
    end;
     //il peut s'agir de mouvements principaux PRI sur la p�riode N
    T := Tob_MvtCp.FindFirst(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODETAPE'], ['0', 'PRI', 'P'], False);
    while Assigned(T) and (RN1 > 0) and (PN > 0) do
    begin
      Rgrpt := T.GetValue('PCN_CODERGRPT');
      Ordre := T.GetValue('PCN_ORDRE');
      if (Rgrpt <> -1) and (T.GetValue('PCN_MVTDUPLIQUE') <> 'X') then
      begin
          //Le restant est inf�rieur ou �gal au mouvement PRI
        if (RN1 >= T.GetValue('PCN_JOURS')) then
        begin
              //Changement de p�riode du PRI
          PgWriteln(Silence, F, 'Affectation � la p�riode n-1 du mvt PRI d''ordre : ' + IntToStr(T.GetValue('PCN_ORDRE')) + ' '); { PT18 }
          T.PutValue('PCN_PERIODECP', 1);
          T.PutValue('PCN_PERIODEPY', 1);
          T.PutValue('PCN_DATEPAIEMENT', DateFinPer1);
          T.PutValue('PCN_PERIODEPAIE', 'P�riode du ' + DateToStr(DateDebPer1) + ' au ' + DateToStr(DateFinPer1));
          RN1 := Arrondi(RN1 - T.GetValue('PCN_JOURS'), 2);
          PN := Arrondi(PN - T.GetValue('PCN_JOURS'), 2);
        end
        else
              //Le restant est Sup�rieur au mouvement PRI
        begin
              //Eclatement du mouvement PRI sur deux p�riodes
          Pris := T.GetValue('PCN_JOURS');
          T1 := TOB.Create('ABSENCESALARIE', Tob_MvtCp, -1);
          T1.Dupliquer(T, True, True, True);
          T2 := TOB.Create('ABSENCESALARIE', Tob_MvtCp, -1);
          T2.Dupliquer(T, True, True, True);
          Inc(OrdreMax); T1.PutValue('PCN_ORDRE', OrdreMax);
          Inc(OrdreMax); T2.PutValue('PCN_ORDRE', OrdreMax);
              //Mvt � imputer sur periode 1
          T1.PutValue('PCN_JOURS', RN1);
          T1.PutValue('PCN_MVTDUPLIQUE', 'X');
          T1.PutValue('PCN_CODERGRPT', T.GetValue('PCN_CODERGRPT'));
          T1.PutValue('PCN_PERIODECP', 1);
          T1.PutValue('PCN_PERIODEPY', 1);
          T1.PutValue('PCN_DATEPAIEMENT', DateFinPer1);
          T1.PutValue('PCN_PERIODEPAIE', 'P�riode du ' + DateToStr(DateDebPer1) + ' au ' + DateToStr(DateFinPer1));
          T1.PutValue('PCN_VALOX', Arrondi((RN1 * T1.GetValue('PCN_VALOX') / Pris), 2));
          T1.PutValue('PCN_VALOMS', Arrondi((RN1 * T1.GetValue('PCN_VALOMS') / Pris), 2));
          T1.PutValue('PCN_VALORETENUE', Arrondi((RN1 * T1.GetValue('PCN_VALORETENUE') / Pris), 2));
          T1.PutValue('PCN_VALOMANUELLE', 0);
              //Mvt � imputer sur periode 0
          T2.PutValue('PCN_JOURS', Arrondi(Pris - RN1, 2));
          T2.PutValue('PCN_MVTDUPLIQUE', 'X');
          T2.PutValue('PCN_CODERGRPT', T.GetValue('PCN_CODERGRPT'));
          T2.PutValue('PCN_VALOX', Arrondi((T2.GetValue('PCN_JOURS') * T2.GetValue('PCN_VALOX') / Pris), 2));
          T2.PutValue('PCN_VALOMS', Arrondi((T2.GetValue('PCN_JOURS') * T2.GetValue('PCN_VALOMS') / Pris), 2));
          T2.PutValue('PCN_VALORETENUE', Arrondi((T2.GetValue('PCN_JOURS') * T2.GetValue('PCN_VALORETENUE') / Pris), 2));
              //Mvt parent
          T.PutValue('PCN_CODERGRPT', -1);
          T.PutValue('PCN_PERIODEPAIE', '');
          RN1 := 0; PN := 0;
        end;
      end
      else {Modification du mouvement �clat� alors }
      begin
        if (Rgrpt = -1) then Rgrpt := Ordre;
        T1 := Tob_MvtCp.FindFirst(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODERGRPT', 'PCN_CODETAPE'], ['0', 'PRI', IntToStr(Rgrpt), 'P'], False);
        if Assigned(T1) then
          if Pos('Reliquat',T1.GetValue('PCN_PERIODEPAIE')) > 0 then // PT23
            T1 := Tob_MvtCp.FindNext(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODERGRPT', 'PCN_CODETAPE'], ['0', 'PRI', IntToStr(Rgrpt), 'P'], False);
        if Assigned(T1) then
        begin
              //Restant n-1 superieur ou �gal au pris �clat�
          if (RN1 >= T1.GetValue('PCN_JOURS')) then
          begin
                 //Changement de p�riode du PRI �clat�
            T1.PutValue('PCN_PERIODECP', 1);
            T1.PutValue('PCN_PERIODEPY', 1);
            T1.PutValue('PCN_DATEPAIEMENT', DateFinPer1);
            T1.PutValue('PCN_PERIODEPAIE', 'P�riode du ' + DateToStr(DateDebPer1) + ' au ' + DateToStr(DateFinPer1));
            RN1 := Arrondi(RN1 - T1.GetValue('PCN_JOURS'), 2);
            PN := Arrondi(PN - T1.GetValue('PCN_JOURS'), 2);
          end
          else
          begin
                 //Eclatement du mvt PRI �clat� sur deux p�riodes
                 //D�versage du pri �clat� du N sur nouveau pri eclat� sur le N-1
            Pris := T1.GetValue('PCN_JOURS');
                 //Mvt dupliqu� sur periode 1
            T2 := TOB.Create('ABSENCESALARIE', Tob_MvtCp, -1);
            T2.Dupliquer(T1, True, True, True);
            Inc(OrdreMax);
            T2.PutValue('PCN_ORDRE', OrdreMax);
            T2.PutValue('PCN_JOURS', RN1);
            T2.PutValue('PCN_PERIODECP', 1);
            T2.PutValue('PCN_PERIODEPY', 1);
            T2.PutValue('PCN_DATEPAIEMENT', DateFinPer1);
            T2.PutValue('PCN_PERIODEPAIE', 'P�riode du ' + DateToStr(DateDebPer1) + ' au ' + DateToStr(DateFinPer1));
            T2.PutValue('PCN_VALOX', Arrondi((RN1 * T2.GetValue('PCN_VALOX') / Pris), 2));
            T2.PutValue('PCN_VALOMS', Arrondi((RN1 * T2.GetValue('PCN_VALOMS') / Pris), 2));
            T2.PutValue('PCN_VALORETENUE', Arrondi((RN1 * T2.GetValue('PCN_VALORETENUE') / Pris), 2));
            T2.PutValue('PCN_VALOMANUELLE', 0);
                 //Mvt eclat� reste sur periode 0
            T1.PutValue('PCN_JOURS', Arrondi(Pris - RN1, 2));
            T1.PutValue('PCN_VALOX', Arrondi((T1.GetValue('PCN_JOURS') * T1.GetValue('PCN_VALOX') / Pris), 2));
            T1.PutValue('PCN_VALOMS', Arrondi((T1.GetValue('PCN_JOURS') * T1.GetValue('PCN_VALOMS') / Pris), 2));
            T1.PutValue('PCN_VALORETENUE', Arrondi((T1.GetValue('PCN_JOURS') * T1.GetValue('PCN_VALORETENUE') / Pris), 2));
            RN1 := 0; PN := 0;
          end;
        end;
      end;
      T := Tob_MvtCp.FindNext(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODETAPE'], ['0', 'PRI', 'P'], False);
    end;
    Tob_MvtCp.Detail.Sort('PCN_PERIODECP DESC,PCN_ORDRE');
  end
  else { SI PRIS N-1 > ACQUIS N-1 ET QUE RESTE SUR N }
    if (PN1 > AN1) and (RN >= Arrondi(PN1 - AN1, DCP)) then { PT16-1 }
    begin
      Debug('Paie Pgi : SURPRIS SUR N-1 & RESTANT SUR N');
      SurPris := Arrondi(PN1 - AN1, DCP);
      Tob_MvtCp.Detail.Sort('PCN_PERIODECP DESC,PCN_ORDRE DESC');
      Tper := Tob_InfoCp.FindFirst(['PERIODE'], ['0'], False);
      if Assigned(Tper) then
      begin
        DateDebPer := Tper.GetValue('DEBUTPERIODE');
        DateFinPer := Tper.GetValue('FINPERIODE');
      end;
      T := Tob_MvtCp.FindFirst(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODETAPE'], ['1', 'PRI', 'P'], False);
      while Assigned(T) and (SurPris > 0) and (RN > 0) do
      begin
        Rgrpt := T.GetValue('PCN_CODERGRPT');
        OrdreCp := T.GetValue('PCN_ORDRE'); { PT16-2 }
          { On ne traite pas les pris sur reliquat }
        if Pos('Reliquat', T.GetValue('PCN_PERIODEPAIE')) > 0 then // PT23
        begin
          T := Tob_MvtCp.FindNext(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODETAPE'], ['1', 'PRI', 'P'], False);
            { DEB PT16-2 }
          if OrdreCp = T.GetValue('PCN_ORDRE') then
          begin { Des fois que le findnext tombe sur la m�me fille, on passe au suivant }
            T := Tob_MvtCp.FindNext(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODETAPE'], ['1', 'PRI', 'P'], False);
            if OrdreCp = T.GetValue('PCN_ORDRE') then break;
          end;
            { FIN PT16-2 }
          Continue;
        end;
          { On ne traite pas les pris �clat�s que si mouvement parent �clat� sur N-1 & N }
        if (T.GetValue('PCN_MVTDUPLIQUE') = 'X') then
        begin
          T1 := Tob_MvtCp.FindFirst(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_ORDRE', 'PCN_CODETAPE'], ['0', 'PRI', IntToStr(Rgrpt), 'P'], False);
          if not Assigned(T1) then
          begin
            T := Tob_MvtCp.FindNext(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODETAPE'], ['1', 'PRI', 'P'], False);
               { DEB PT16-2 }
            if (OrdreCp = T.GetValue('PCN_ORDRE')) OR (T.GetValue('PCN_ORDRE') < OrdreCp) then // PT23
            begin { Des fois que le findnext tombe sur la m�me fille, on passe au suivant }
              T := Tob_MvtCp.FindNext(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODETAPE'], ['1', 'PRI', 'P'], False);
              if OrdreCp = T.GetValue('PCN_ORDRE') then break;
            end;
               { FIN PT16-2 }
            Continue;
          end;
        end;
          { On ne traite pas les mouvements pris parents }
        if (Rgrpt = -1) then
        begin
          T := Tob_MvtCp.FindNext(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODETAPE'], ['1', 'PRI', 'P'], False);
            { DEB PT16-2 }
          if OrdreCp = T.GetValue('PCN_ORDRE') then
          begin { Des fois que le findnext tombe sur la m�me fille, on passe au suivant }
            T := Tob_MvtCp.FindNext(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODETAPE'], ['1', 'PRI', 'P'], False);
            if OrdreCp = T.GetValue('PCN_ORDRE') then break;
          end;
            { FIN PT16-2 }
          Continue;
        end;
          { Traitement des mouvements PRIS }
          { le surplus de pris est sup�rieur au PRI trouv�, changement de p�riode }
        if (SurPris >= T.GetValue('PCN_JOURS')) then
        begin
          T.PutValue('PCN_PERIODECP', 0);
          T.PutValue('PCN_PERIODEPY', 0);
          T.PutValue('PCN_DATEPAIEMENT', DateFinPer);
          T.PutValue('PCN_PERIODEPAIE', 'P�riode du ' + DateToStr(DateDebPer) + ' au ' + DateToStr(DateFinPer));
          SurPris := Arrondi(SurPris - T.GetValue('PCN_JOURS'), 2);
        end
        else
          { le surplus de pris est inf�rieur ou �gal au PRI trouv� }
             { Eclatement du mouvement dans le cas d'un mouvement non �clat� }
          if (SurPris < T.GetValue('PCN_JOURS')) and (T.GetValue('PCN_MVTDUPLIQUE') <> 'X') then
          begin
                //Eclatement du mouvement PRI sur deux p�riodes
            Pris := T.GetValue('PCN_JOURS');
            T1 := TOB.Create('ABSENCESALARIE', Tob_MvtCp, -1);
            T1.Dupliquer(T, True, True, True);
            T2 := TOB.Create('ABSENCESALARIE', Tob_MvtCp, -1);
            T2.Dupliquer(T, True, True, True);
            Inc(OrdreMax); T1.PutValue('PCN_ORDRE', OrdreMax);
            Inc(OrdreMax); T2.PutValue('PCN_ORDRE', OrdreMax);
                //Mvt � imputer sur periode N
            T1.PutValue('PCN_JOURS', SurPris);
            T1.PutValue('PCN_MVTDUPLIQUE', 'X');
            T1.PutValue('PCN_CODERGRPT', T.GetValue('PCN_CODERGRPT'));
            T1.PutValue('PCN_PERIODECP', 0);
            T1.PutValue('PCN_PERIODEPY', 0);
            T1.PutValue('PCN_DATEPAIEMENT', DateFinPer);
            T1.PutValue('PCN_PERIODEPAIE', 'P�riode du ' + DateToStr(DateDebPer) + ' au ' + DateToStr(DateFinPer));
            T1.PutValue('PCN_VALOX', Arrondi((Surpris * T1.GetValue('PCN_VALOX') / Pris), 2));
            T1.PutValue('PCN_VALOMS', Arrondi((Surpris * T1.GetValue('PCN_VALOMS') / Pris), 2));
            T1.PutValue('PCN_VALORETENUE', Arrondi((Surpris * T1.GetValue('PCN_VALORETENUE') / Pris), 2));
            T1.PutValue('PCN_VALOMANUELLE', 0);
                //Mvt � imputer sur periode N-1
            T2.PutValue('PCN_JOURS', Arrondi(Pris - Surpris, 2));
            T2.PutValue('PCN_MVTDUPLIQUE', 'X');
            T2.PutValue('PCN_CODERGRPT', T.GetValue('PCN_CODERGRPT'));
            T2.PutValue('PCN_VALOX', Arrondi((T2.GetValue('PCN_JOURS') * T2.GetValue('PCN_VALOX') / Pris), 2));
            T2.PutValue('PCN_VALOMS', Arrondi((T2.GetValue('PCN_JOURS') * T2.GetValue('PCN_VALOMS') / Pris), 2));
            T2.PutValue('PCN_VALORETENUE', Arrondi((T2.GetValue('PCN_JOURS') * T2.GetValue('PCN_VALORETENUE') / Pris), 2));
                //Mvt parent
            T.PutValue('PCN_CODERGRPT', -1);
            T.PutValue('PCN_PERIODEPAIE', '');
            T.PutValue('PCN_PERIODECP', 0);
            T.PutValue('PCN_PERIODEPY', 0);
            T.PutValue('PCN_DATEPAIEMENT', DateFinPer);
            SurPris := 0; RN := Arrondi(RN - SurPris, 2);
          end
          else
             { Eclatement du mouvement �clat� de la periode N-1 vers la p�riode N }
            if (SurPris < T.GetValue('PCN_JOURS')) and (T.GetValue('PCN_MVTDUPLIQUE') = 'X') then
            begin
              Pris := T.GetValue('PCN_JOURS');
              T1 := TOB.Create('ABSENCESALARIE', Tob_MvtCp, -1);
              T1.Dupliquer(T, True, True, True);
              Inc(OrdreMax); T1.PutValue('PCN_ORDRE', OrdreMax);
                   //Mvt � imputer sur periode 0
              T1.PutValue('PCN_JOURS', SurPris);
              T1.PutValue('PCN_MVTDUPLIQUE', 'X');
              T1.PutValue('PCN_CODERGRPT', T.GetValue('PCN_CODERGRPT'));
              T1.PutValue('PCN_PERIODECP', 0);
              T1.PutValue('PCN_PERIODEPY', 0);
              T1.PutValue('PCN_DATEPAIEMENT', DateFinPer);
              T1.PutValue('PCN_PERIODEPAIE', 'P�riode du ' + DateToStr(DateDebPer) + ' au ' + DateToStr(DateFinPer));
              T1.PutValue('PCN_VALOX', Arrondi((Surpris * T1.GetValue('PCN_VALOX') / Pris), 2));
              T1.PutValue('PCN_VALOMS', Arrondi((Surpris * T1.GetValue('PCN_VALOMS') / Pris), 2));
              T1.PutValue('PCN_VALORETENUE', Arrondi((Surpris * T1.GetValue('PCN_VALORETENUE') / Pris), 2));
              T1.PutValue('PCN_VALOMANUELLE', 0);
                   //Mvt imput� sur periode 1
              T.PutValue('PCN_JOURS', Arrondi(Pris - SurPris, 2));
              T.PutValue('PCN_VALOX', Arrondi((T.GetValue('PCN_JOURS') * T.GetValue('PCN_VALOX') / Pris), 2));
              T.PutValue('PCN_VALOMS', Arrondi((T.GetValue('PCN_JOURS') * T.GetValue('PCN_VALOMS') / Pris), 2));
              T.PutValue('PCN_VALORETENUE', Arrondi((T.GetValue('PCN_JOURS') * T.GetValue('PCN_VALORETENUE') / Pris), 2));
              T.PutValue('PCN_VALOMANUELLE', 0);
              SurPris := 0; RN := Arrondi(RN - SurPris, 2);
            end;
        T := Tob_MvtCp.FindNext(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODETAPE'], ['1', 'PRI', 'P'], False);
      end;
      Tob_MvtCp.Detail.Sort('PCN_PERIODECP DESC,PCN_ORDRE');
    end;
   { R�affectation des mouvements parents affich�s sur mauvaise p�riode }
  for i := 1 downto 0 do
  begin
    T := Tob_MvtCp.FindFirst(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODERGRPT', 'PCN_CODETAPE'], [IntToStr(i), 'PRI', '-1', 'P'], False);
    Ordre := 0;
    while Assigned(T) do
    begin
      if T.GetValue('PCN_ORDRE') = ordre then break;
      Ordre := T.GetValue('PCN_ORDRE');
      T1 := Tob_MvtCp.FindFirst(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODERGRPT', 'PCN_CODETAPE'], [IntToStr(i), 'PRI', IntToStr(ordre), 'P'], False);
      if not assigned(T1) then
      begin
        T.PutValue('PCN_PERIODECP', IntToStr(i + 1));
        T.PutValue('PCN_PERIODEPY', IntToStr(i + 1));
        Tper := Tob_InfoCp.FindFirst(['PERIODE'], [IntToStr(i + 1)], False);
        if Assigned(Tper) then
          T.PutValue('PCN_DATEPAIEMENT', Tper.GetValue('FINPERIODE'));
      end;
      T := Tob_MvtCp.FindNext(['PCN_PERIODECP', 'PCN_TYPECONGE', 'PCN_CODERGRPT', 'PCN_CODETAPE'], [IntToStr(i), 'PRI', '-1', 'P'], False);
    end;
  end;
end;
{ FIN PT15 }

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure MAJBaseCPAcquis(Verrouillage: Boolean; etab, sal, FileN: string);
var
  Tob_MvtErrone, Tob_Acquis, TFils: Tob;
  Q: TQuery;
  i, ordre: Integer;
  Salarie, StWhere: string;
//TT         : TQRProgressForm ; PORTAGECWAS
  TEvent: TStringList; //PT- 10
begin
{Le Boolean verrouillage d�finit le mode manuel ou transparent de l'utilisation de la moulinette
Selon le source d'appel je verrouille ou non sur le boolean de la table SALARIES
Attention si cr�ation salari� entre 2 lancements le test n'est pas bloquant}
  if Verrouillage then
  begin
    if not ExisteSql('SELECT PSA_SALARIE FROM SALARIES WHERE PSA_BOOLLIBRE8="-" ') then
      exit;
  end
  else
    InitMoveProgressForm(nil, 'Mise � jour des mouvements CP Acquis', 'Veuillez patienter SVP ...', 100, TRUE, TRUE);

//DEB PT- 10
  AssignFile(F, FileN);
{$I-}ReWrite(F); {$I+}
  if IoResult <> 0 then begin PGIBox('Fichier inaccessible : ' + FileN, 'Abandon du traitement'); Exit; end;
//FIN PT- 10

  StWhere := '';
  if sal <> '' then StWhere := ' AND PCN_SALARIE="' + Sal + '" ';
  if etab <> '' then StWhere := StWhere + ' AND PCN_ETABLISSEMENT="' + Etab + '" ';
{Cr�ation de la tob des mouvements erronn�s}
  Q := OpenSql('SELECT PCN_SALARIE,PCN_ORDRE,PHC_DATEDEBUT,PHC_DATEFIN,PCN_BASE,SUM(PHC_MONTANT) AS MONTANT  ' +
    'FROM ABSENCESALARIE ' +
    'LEFT JOIN HISTOCUMSAL ON PCN_SALARIE=PHC_SALARIE AND PCN_DATEDEBUT=PHC_DATEDEBUT AND PCN_DATEFIN=PHC_DATEFIN ' +
    'WHERE PCN_TYPEMVT="CPA" AND PCN_TYPECONGE="ACQ" AND PHC_CUMULPAIE="11" AND (PCN_BASE<>PHC_MONTANT) AND PCN_CODETAPE="..." ' + //PT21 Ajout PCN_TYPEMVT="CPA"
    StWhere + 'GROUP BY PCN_SALARIE,PCN_ORDRE,PHC_DATEDEBUT,PHC_DATEFIN,PCN_BASE', True);
  if Q.eof then
  begin
    Ferme(Q);
    Writeln(F, 'Aucun mouvement d''acquis �rron�.Traitement termin�.');
    CloseFile(F);
    if not Verrouillage then
    begin
      FiniMoveProgressForm;
      PGIBox('Aucun mouvement d''acquis �rron�.Traitement termin�.', 'Cong�s pay�s');
    end;
    Exit;
  end;
  Tob_MvtErrone := TOB.Create('MVT ERRONE', nil, -1);
  Tob_MvtErrone.LoadDetaildb('MVT ERRONE', '', '', Q, False);
  Ferme(Q);
{Cr�ation de la tob des mouvements acquis � mettre � jour}
  Q := OpenSql('SELECT * FROM ABSENCESALARIE ' +
    'WHERE PCN_TYPECONGE="ACQ" AND PCN_CODETAPE="..." AND PCN_TYPEMVT="CPA" ' + StWhere, True); //PT21 PCN_TYPEMVT="CPA"
  if Q.eof then
  begin
    tob_MvtErrone.free; Ferme(Q);
    writeln(F, 'Aucun mouvement d''acquis �rron�.Traitement termin�.');
    CloseFile(F);
    if not Verrouillage then
    begin
      FiniMoveProgressForm;
      PGIBox('Aucun mouvement d''acquis �rron�.Traitement termin�.', 'Cong�s pay�s');
    end;
    Exit;
  end;
  Tob_Acquis := Tob.Create('ABSENCESALARIE', nil, -1);
  Tob_Acquis.LoadDetailDB('ABSENCESALARIE', '', '', Q, True);
  Ferme(Q);
//DEB PT- 10
  TEvent := TStringList.create;
  TEvent.Add('R�affectation de la base des acquis cong�s');
  TEvent.Add('Nombre de mouvement acquis � r�affecter : ' + IntToStr(Tob_MvtErrone.Detail.count));
  Salarie := '';
//FIN //PT- 10
  for i := 0 to Tob_MvtErrone.Detail.count - 1 do
  begin
    if Tob_MvtErrone.Detail[i].GetValue('PCN_SALARIE') <> Salarie then //PT- 10
      TEvent.Add('Salari� concern� : ' + Tob_MvtErrone.Detail[i].GetValue('PCN_SALARIE'));
    Salarie := Tob_MvtErrone.Detail[i].GetValue('PCN_SALARIE');
    Ordre := Tob_MvtErrone.Detail[i].GetValue('PCN_ORDRE');
  //if not Verrouillage then TT.Value:=i ; PORTAGECWAS
    if (Salarie <> '') and (Ordre > 0) then
      TFils := TOB_Acquis.FindFirst(['PCN_SALARIE', 'PCN_ORDRE'], [Salarie, Ordre], False)
    else TFils := nil;
    if TFils <> nil then
    begin
    { R�affectation du Cumul11 � la base sur les mvts erronn�s }
      if TFils.GetValue('PCN_BASE') <> Tob_MvtErrone.Detail[i].GetValue('MONTANT') then
        TFils.PutValue('PCN_BASE', Tob_MvtErrone.Detail[i].GetValue('MONTANT'));
      if not Verrouillage then
        MoveCurProgressForm('Mise � jour de la base des acquis du salari� : ' + Salarie); ;
    end;
  end;
{Si Tob acquis modifi� alors mise � jour...}
  if Tob_Acquis.IsOneModifie then
  begin
    try
      beginTrans; //DEB PT16 Suppression du delete DB
       {ExecuteSql('DELETE '+
           'FROM ABSENCESALARIE '+
           'WHERE PCN_TYPECONGE="ACQ" AND PCN_CODETAPE="..." ');}
      for i := 0 to TOB_Acquis.Detail.count - 1 do
      begin
        if TOB_Acquis.detail[i].IsOneModifie then
        begin
          TOB_Acquis.detail[i].SetAllModifie(TRUE);
          TOB_Acquis.detail[i].InsertOrUpdateDB;
        end; //FIN  PT16 Au lieu du TOb_Mere.InsertQB qui ins�re un enr � blanc et fait planter au deuxi�me passage
      end; //on fait un insertorupdate sur chaque fille modifi�..Traitement alleg�
      ExecuteSql('UPDATE SALARIES SET PSA_BOOLLIBRE8="X"');
      CommitTrans;
      TEvent.Add('Le traitement de r�affectation s''est bien termin�.');
      CreeJnalEvt('002', '130', 'OK', nil, nil, TEvent); //PT- 10
    except
      Rollback;
      TEvent.Add('Une erreur est survenue lors du traitement de r�affectation.');
      CreeJnalEvt('002', '130', 'ERR', nil, nil, TEvent); //PT- 10
    end;
  end;
//DEB PT- 10
  for i := 0 to TEvent.Count - 1 do writeln(F, TEvent.Strings[i]);
  CloseFile(F);
  if TEvent <> nil then TEvent.free;
//FIN PT- 10
  Tob_Acquis.free;
  Tob_MvtErrone.free;
  if not Verrouillage then
  begin
    FiniMoveProgressForm;
    PGIBox('Traitement termin�.', 'Cong�s pay�s');
  end;
end;


{$IFNDEF EAGLSERVER}

procedure TOF_PGUTILITAIRECP.ExitEdit(Sender: TObject);
var edit: thedit;
begin
  edit := THEdit(Sender);
  if edit <> nil then
    if (VH_Paie.PgTypeNumSal = 'NUM') and (length(Edit.text) < 11) and (isnumeric(edit.text)) then
      edit.text := AffectDefautCode(edit, 10);
end;
{$ENDIF}
{ DEB PT18 }

procedure PgWriteln(Silence: Boolean; var F: Text; st: string);
begin
  if not Silence then writeln(F, St);
end;
{ FIN PT18 }


initialization
{$IFNDEF EAGLSERVER}
  registerclasses([TOF_PGUTILITAIRECP]);
{$ENDIF}
end.

