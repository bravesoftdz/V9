{***********UNITE*************************************************
Auteur  ...... :
Cr�� le ...... : 13/04/2001
Modifi� le ... :   /  /
Description .. : Source TOF de la TABLE : APPRECAFF_MUL ()
Mots clefs ... : TOF;APPRECAFF_MUL
*****************************************************************}
Unit UTOFAPPRECAFF_MUL ;

Interface

Uses StdCtrls, Controls, Classes,  forms, sysutils,  ComCtrls,
{$IFDEF EAGLCLIENT}
   emul, MaineAGL,
{$ELSE}
   dbTables, db, HDB, mul, FE_Main,
{$ENDIF}
   HCtrls, HEnt1, HMsgBox, UTOF, HQry, HPanel, 
     UTob,Grids,utofAfBaseCodeAffaire ,dicoaf ,M3FP,
     utofAfPiecePro_Mul,paramsoc,UtilMulTrt,UtofAfSaisDate,
     AffaireRegroupeUtil,UtofAppreciation;

Type
  TOF_APPRECAFF_MUL = Class (TOF_AFBASECODEAFFAIRE)
//    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (Stargument : String ) ; override ;
    procedure OnClose                  ; override ;

    procedure NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_:THEdit); override;
    procedure Appreciation(stpar : string);
    procedure TrtApprec;
    procedure ChangeDate;
(*  On garde tout �a en commentaire � titre d'exemple pour l'affichage de dessins dans les colonnes d'un mul
    {$IFDEF EAGLCLIENT}
    procedure RefreshCrossez;
    procedure OnUpdateNext; override;
    {$ELSE}
    procedure OnGetFieldText(Sender: TField; var Text: string; DisplayText : Boolean);
    {$ENDIF}
    *)
    private
    titre : string;
    zdatapp : string;
    {$IFDEF EAGLCLIENT}
    L : THGrid;
    {$ELSE}
    L : THDBGrid;
    {$Endif}
    Q : TQuery;
//    procedure AfterShow;
  end ;
	// libell�s des messages de la TOF  AFPREPFACT


     const
	TexteMsgAffaire: array[1..7] of string 	= (
          {1}        'Aucune affaire s�lectionn�e'
          {2}        ,'Code Prestation invalide'
          {3}        ,'Date Invalide'
          {4}        ,'Dates Incompatibles'
          {5}        ,'Aucune donn�e s�lectionn�e'
          {6}        ,'G�n�ration en cours'
          {7}        ,'V�rifiez vos dates de g�n�ration'
                     );

Procedure AFLanceFiche_Mul_ApprecAff(Range,Argument:string);

Implementation


procedure TOF_APPRECAFF_MUL.OnLoad;
var F : TFMul ;
    xx_groupby, xx_where, EtatVisa, EcheFact, TypeEche : string;
begin
inherited ;
if not (Ecran is TFMul) then exit ;
F := TFMul(Ecran);

xx_where := '';

try
F.Q.Manuel := True ;

// Constitution du xx_where
(*if (GetCheckBoxState ('APPRECIEES') = cbGrayed) then
  // On veut les missions appreciees et les non appr�ci�es
  begin
    F.Q.Liste := 'AFMULAPPREC_OK';
    EtatVisa := THValComboBox(GetControl ('ETATVISA')).Value;
    if (EtatVisa <> '') then
      xx_where := '(AFA_ETATVISA="' + EtatVisa + '") AND ';

    EcheFact := '';
    if (GetCheckBoxState ('ECHEFACT') = cbChecked) then
      EcheFact := 'X'
    else
    if (GetCheckBoxState ('ECHEFACT') = cbUnChecked) then
      EcheFact := '-';
    if (EcheFact <> '') then
      xx_where := xx_where + '(AFA_ECHEFACT="' + EcheFact + '") ';

//    xx_where := xx_where + '((AFA_DATEECHE >= "' + UsDateTime( strtodate (GetControlText ('DATEECHE'))) + '" AND AFA_DATEECHE <= "' + UsDateTime( strtodate (GetControlText ('DATEECHE_'))) + '"))';
    xx_groupby := 'AFA_DATEECHE, T_TIERS, AFF_AFFAIRE, AFF_AFFAIRE1, AFF_AFFAIRE2, AFF_AFFAIRE3, AFF_AVENANT, AFF_RESPONSABLE, AFF_LIBELLE, AFA_AFFAIRE';
  end
else*)
if (GetCheckBoxState ('APPRECIEES') = cbChecked) then     
  // On veut les missions appreciees
  // celles qui ont des lignes dans FACTAFF et dans l'intervalle de dates (+ les autres conditions)
  // On a besoin de la date d'echeance dans ce cas
  begin
    F.Q.Liste := 'AFMULAPPREC_OK';
    TypeEche := THValComboBox(GetControl ('TYPECHE')).Value;
    if (TypeEche <> '') then
      xx_where := '(AFA_TYPECHE="' + TypeEche + '") AND ';
    EtatVisa := THValComboBox(GetControl ('ETATVISA')).Value;
    if (EtatVisa <> '') then
      xx_where := xx_where + '(AFA_ETATVISA="' + EtatVisa + '") AND ';

    EcheFact := '';
    if (GetCheckBoxState ('ECHEFACT') = cbChecked) then
      EcheFact := 'X'
    else
    if (GetCheckBoxState ('ECHEFACT') = cbUnChecked) then
      EcheFact := '-';
    if (EcheFact <> '') then
      xx_where := xx_where + '(AFA_ECHEFACT="' + EcheFact + '") AND ';

    xx_where := xx_where + '((AFA_DATEECHE >= "' + UsDateTime( strtodate (GetControlText ('DATEECHE'))) + '" AND AFA_DATEECHE <= "' + UsDateTime( strtodate (GetControlText ('DATEECHE_'))) + '"))';
    xx_groupby := 'AFA_DATEECHE, T_TIERS, T_LIBELLE, AFF_AFFAIRE, AFF_AFFAIRE1, AFF_AFFAIRE2, AFF_AFFAIRE3, AFF_AVENANT, AFF_RESPONSABLE, AFF_LIBELLE, AFA_AFFAIRE, AFA_ETATVISA';
  end
else
if (GetCheckBoxState ('APPRECIEES') = cbUnChecked) then
  // On veut les missions non appreciees
  // celles qui n'ont pas de lignes dans FACTAFF (NULL) Plus
  // celles qui en ont mais en dehors de l'intervalle de dates (+ les autres conditions) et qui n'en n'ont pas dans l'intervalle de date
  // (En fait, celles qui n'ont pas de lignes dans FACTAFF, et celles qui n'en ont pas juste dans l'intervalle)
  // on n'a pas de date d'echeance dans ce cas
  begin
    F.Q.Liste := 'AFMULAPPREC_PASOK';
//    TypeEche := THValComboBox(GetControl ('TYPECHE')).Value;
//    if (TypeEche <> '') then
//      xx_where := '(AFA_TYPECHE="' + TypeEche + '" OR AFA_TYPECHE IS NULL) AND ';
    EtatVisa := THValComboBox(GetControl ('ETATVISA')).Value;
    if (EtatVisa <> '') then
      xx_where := xx_where + '(AFA_ETATVISA="' + EtatVisa + '" OR AFA_ETATVISA IS NULL) AND ';

    EcheFact := '';
    if (GetCheckBoxState ('ECHEFACT') = cbChecked) then
      EcheFact := 'X'
    else
    if (GetCheckBoxState ('ECHEFACT') = cbUnChecked) then
      EcheFact := '-';
    if (EcheFact <> '') then
      xx_where := xx_where + '(AFA_ECHEFACT="' + EcheFact + '" OR AFA_ECHEFACT IS NULL) AND ';

    // celles qui ont des lignes dans FACTAFF mais en dehors de l'intervalle de dates
    xx_where := xx_where + '((AFA_DATEECHE < "' + UsDateTime( strtodate (GetControlText ('DATEECHE'))) + '" OR AFA_DATEECHE > "' + UsDateTime( strtodate (GetControlText ('DATEECHE_'))) + '") OR AFA_DATEECHE IS NULL) ';
    // et qui n'ont pas de lignes dans l'intervalle de date
    xx_where := xx_where + 'AND (AFF_AFFAIRE NOT IN (SELECT AFA_AFFAIRE FROM FACTAFF WHERE (AFA_DATEECHE >= "' + UsDateTime( strtodate (GetControlText ('DATEECHE'))) + '" AND AFA_DATEECHE <= "' + UsDateTime( strtodate (GetControlText ('DATEECHE_'))) + '"  AND AFA_TYPECHE="APP")))';

    xx_groupby := 'T_TIERS, T_LIBELLE, AFF_AFFAIRE, AFF_AFFAIRE1, AFF_AFFAIRE2, AFF_AFFAIRE3, AFF_AVENANT, AFF_RESPONSABLE, AFF_LIBELLE, AFA_AFFAIRE';
  end;


// Affectation du xx_where
SetControlText ('XX_WHERE', xx_where);
SetControlText ('XX_GROUPBY', xx_groupby);

finally
F.Q.Manuel := False;
SetActiveTabSheet('P_PARAMETRE');
end;
end;
(*
procedure TOF_APPRECAFF_MUL.AfterShow;
var
  PCumul : THPanel;
begin
inherited;
{$IFDEF EAGLCLIENT}
;
{$ELSE}
PCumul := THPanel(GetControl('PCumul'));
if (PCumul <> nil) then
  begin
    PCumul.Visible := true;
    PCumul.Caption := '  Totaux (' + inttostr (TFMul(Ecran).FListe.DataSource.DataSet.RecordCount ) + ')';
  end;
{$Endif}
end;
*)

(*  On garde tout �a en commentaire � titre d'exemple pour l'affichage de dessins dans les colonnes d'un mul
// R�tablir le masquage des colonnes � chaque updatage sinon elles r�apparaissent
procedure TOF_APPRECAFF_MUL.OnUpdate;
var i : integer;
begin
inherited;
{$IFDEF EAGLCLIENT}
RefreshCrossez;
{$ELSE}
for i := 0 to TFMul(Ecran).FListe.Columns.Count-1 do
  if (AnsiUpperCase(TFMul(Ecran).FListe.Columns[i].Title.Caption) = AnsiUpperCase('Date de l''�cheance')) then
    begin
      TFMul(Ecran).FListe.Columns[i].Field.OnGetText := OnGetFieldText;
      TFMul(Ecran).FListe.Columns[i].Font.Name := 'Wingdings 2';
      TFMul(Ecran).FListe.Columns[i].Font.Size := 10;
    end;
{$ENDIF}
end;

{$IFDEF EAGLCLIENT}
procedure TOF_APPRECAFF_MUL.OnUpdateNext;
begin
inherited;
RefreshCrossez;
end;

procedure TOF_APPRECAFF_MUL.RefreshCrossez;
var i, j : integer;
   FPVCol : integer;
begin
with TFMul(Ecran).FListe do
  for i := 0 to ColCount - 1 do
   if (AnsiUpperCase (Cells[i, 0]) = 'Appr�ci�e') then
    for j := 1 to RowCount - 1 do
     if Cells[i, j] = '' then
       if Cells[FPVCol, j] <> '' then Cells[i, j] := 'X'
                                   else Cells[i, j] := ' ';
end;
{$ELSE}
// Interception de l'affichage de la colonne appr�ci�e pour afficher les coches
procedure TOF_APPRECAFF_MUL.OnGetFieldText(Sender: TField; var Text: string; DisplayText: Boolean);
var
  DateEche, DateDeb, Datefin : string;
begin
  DateEche := TFMul(Ecran).Q.FindField('AFA_DATEECHE').AsString;
  DateDeb := GetControlText ('DATEECHE');
  Datefin := GetControlText ('DATEECHE_');
  if  (TFMul(Ecran).Q.FindField('AFA_DATEECHE').AsString <> '')
      and ((strtodate (DateEche) < strtodate (DateDeb))
        or  (strtodate (DateEche) > strtodate (Datefin)))
    then
      Text := 'P'
    else
      Text := '';
end;
{$ENDIF}
*)


procedure TOF_APPRECAFF_MUL.OnArgument (Stargument : String);
  Var
  Critere, Champ, valeur : String;
  x : integer;

begin
  Inherited;
  titre := ecran.caption;

   // Recup des crit�res
  Critere := (Trim (ReadTokenSt (stArgument)));
  While (Critere <> '') do
    BEGIN
      if (Critere <> '') then
        BEGIN
          X := pos (':', Critere);
          if x <> 0 then
            begin
              Champ := copy (Critere, 1, X - 1);
              Valeur := Copy (Critere, X + 1, length (Critere) - X);
            end;
        END;
      Critere := (Trim (ReadTokenSt (stArgument)));
    END;

   // Gestion des sous affaires
  if not (GereSousAffaire) then
    begin
      SetcontrolVisible ('TAFF_AFFAIREREF', False);
      SetcontrolVisible ('AFFAIREREF1', False);
      SetcontrolVisible ('AFFAIREREF2', False);
      SetcontrolVisible ('AFFAIREREF3', False);
      SetcontrolVisible ('AFFAIREREF4', False);
      SetcontrolVisible ('AFF_ISAFFAIREREF', False);
      SetcontrolVisible ('BSELECTAFF2', False);
    end;

  if not(GetParamsoc ('SO_AFGERELIQUIDE')) then
    begin
      SetcontrolVisible ('TAFF_DATEFACTLIQUID', FALSE);
      SetcontrolVisible ('AFF_DATEFACTLIQUID', FALSE);
    end;

  // C'est le mois pr�c�dent qui nous int�resse
  SetControlText ('DATEECHE_', datetostr (Strtodate (GetControlText('DATEECHE')) - 1));
//  SetControlText ('DATEECHE', datetostr (PlusDate (Strtodate( GetControlText('DATEECHE')), -1, 'M')));
  // Ce ne sont que les echeance APP que l'on veut
  THValComboBox(GetControl ('TYPECHE')).Value := 'APP';

  //TFmul(Ecran).OnAfterFormShow := AfterShow;
end;

procedure TOF_APPRECAFF_MUL.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_APPRECAFF_MUL.NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_:THEdit);
begin
Aff := THEdit (GetControl ('AFF_AFFAIRE'));
Aff0 := THEdit (GetControl ('AFF_AFFAIRE0'));
Aff1 := THEdit (GetControl ('AFF_AFFAIRE1'));
Aff2 := THEdit (GetControl ('AFF_AFFAIRE2'));
Aff3 := THEdit (GetControl ('AFF_AFFAIRE3'));
Aff4 := THEdit (GetControl ('AFF_AVENANT'));
end;

// Fonction de recup�ration des affaires s�lectionn�es par le mul.

procedure TOF_APPRECAFF_MUL.Appreciation (stpar : string);
{$ifndef Eagl}
var
  F     : TFMul;
  zdate : String;
  ret : integer;
{$endif}

begin
  //  if Blocage (['nrGener'],True,'nrGener') then  exit;
 //AFAIREEAGL
{$ifndef Eagl} //AVOIR Eagl Pas OK
  F := TFMul (Ecran);
  L := F.FListe;
  Q := F.Q;

  if (F.FListe.NbSelected = 0) and (not F.FListe.AllSelected) then
  begin
    PGIInfoAF (TexteMsgAffaire[1], titre);
    exit;
  end;

if (GetCheckBoxState ('APPRECIEES') = cbUnChecked) then
  // On ne propose une date que pour les missions non appr�ci�es
  begin
    // mcd 12/02/06Zdate :=AGLLanceFiche('AFF','AFSAISDATE','','','ZORI:A;') ;
(*    Zdate := AFLanceFiche_SaisieDate ('ZORI:A;ZZDATE:' + GetControlText ('DATEECHE_'));
    if (zdate = '0') then
      begin
        PGIInfo ('Traitement abandonn�', titre);
        exit;
      end
    else
      zdatapp := zdate;*)
    // PL le 12/09/03 : on ne veut plus choisir la date, mais on prend la date de fin
    ret := 0;
    zdate := GetControlText('DATEECHE_');

    ret := CtrlDate (zdate);

    if (ret = 1) then
      Begin
        PGIInfo ('la date saisie n''est pas valide', titre);
        Lasterror := 1;
        exit;
      End
    else if (ret = 2)  then
      Begin
        PGIInfo ('la date saisie n''est pas dans un exercice ouvert', titre);
        Lasterror := 1;
        exit;
      End
    else if (ret = 3)  then
      Begin
        PGIInfo ('la date saisie est inf�rieure � l''arr�t� de p�riode', titre);
        Lasterror := 1;
        exit;
      End
    else if (ret = 4)  then
      Begin
        PGIInfo ('l''intervalle de dates saisi n''est pas valide', titre);
        Lasterror := 1;
        exit;
      End;

    zdatapp := zdate;

  end;

  {St:= 'Confirmez vous l''appr�ciation de ces affaires au ' + zdate;
  If (PGIAskAF(st,titre)<> mrYes) then exit;}
  TrtApprec;

   //  	Bloqueur ('nrGener',False);
{$endif}
END;

procedure TOF_APPRECAFF_MUL.TrtApprec;
var
  TobMAff, TobDet : TOB; // Toutes les affaires s�lectionn�es
  wi : integer;
  ret, zaff, zori : string;

begin
	if (GetParamSoc ('SO_AFAPPPOINT') = true) then
    zori := 'COM'
  else
    zori := 'SIM';

  TobMAff := Tob.Create ('les affaires', NIL, -1);
  try
  TraiteEnregMulListe (TFMul(Ecran), 'AFF_AFFAIRE', 'AFAFFTIERS', TobMAff, True);

  for wi := 0 to TobMAff.Detail.count - 1 do
    Begin
      TobDet := TobMAff.Detail[wi];
      zaff := tobDet.GetValue ('AFF_AFFAIRE');

      if (GetCheckBoxState ('APPRECIEES') = cbChecked) then
        // Si les missions sont appr�ci�es, il faut r�cup�rer leur date d'appr�ciation
        begin
          zdatapp := TobDet.GetValue ('AFA_DATEECHE');
        end;

      if (zori = 'SIM') then
    	  Ret := AFLanceFiche_AppreciationNiv0 ('ZORI:' + zori + ';ZAFF:' + zaff + ';ZDATAPP:' + zdatapp + ';')
      else
     	  Ret := AFLanceFiche_AppreciationCompl ('ZORI:' + zori + ';ZAFF:' + zaff + ';ZDATAPP:' + zdatapp + ';');

      if ret = 'STOP' then break;
    end;

  finally
    //	RecupMultiSelect(Q,L,TobMAff);
    TobMAff.free;
  end;

end;

procedure TOF_APPRECAFF_MUL.ChangeDate;
var
  DateDeb, DateApp : TDateTime;
begin
DateApp := strtodate (GetControlText ('DATEECHE_'));
DateDeb := DebutDeMois (DateApp);
if (isValidDate( datetostr (DateDeb))) then
  SetControlText ('DATEECHE', datetostr (DateDeb))
else
  SetControlText ('DATEECHE', GetControlText ('DATEECHE_'));
end;

procedure AGLapprecaffmul_Appreciation( parms: array of variant; nb: integer );
var  F : TForm;
     LaTof : TOF;
begin
  F := TForm (Longint (Parms[0]));
  if (F is TFMul) then Latof := TFMul(F).Latof else LaTof := nil;
  if (Latof is TOF_APPRECAFF_MUL) then
    TOF_APPRECAFF_MUL(LaTof).Appreciation (Parms[1]);
end;
(*
Procedure AFLanceFiche_Mul_ApprecAff(Range,Argument:string);
begin
  AGLLanceFiche ('AFF','APPRECAFF_MUL',Range,'',Argument);
end;
*)

Procedure AFLanceFiche_Mul_ApprecAff (Range, Argument : string);
begin
  AGLLanceFiche ('AFF', 'APPRECAFFNEW_MUL', Range, '', Argument);
end;


procedure AGLChangeDate (parms : array of variant; nb : integer);
var  F : TForm ;
     MaTOF  : TOF;
begin
F := TForm (Longint (Parms[0]));
if (F is TFMul) then MaTOF := TFMul (F).LaTOF else exit;
if (MaTOF is TOF_APPRECAFF_MUL) then TOF_APPRECAFF_MUL (MaTOF).ChangeDate else exit;
end;

Initialization
  registerclasses ( [ TOF_APPRECAFF_MUL ] ) ;
	RegisterAglProc( 'Appreciation', True, 1, AGLapprecaffmul_Appreciation);
	RegisterAglProc( 'ChangeDate', True, 0, AGLChangeDate);
end.

