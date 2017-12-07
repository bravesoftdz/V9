{ Unit� : Source TOF de la FICHE : TRCALCULICC
--------------------------------------------------------------------------------------
    Version    |  Date  | Qui |   Commentaires
--------------------------------------------------------------------------------------
 7.09.001.001   17/10/06  JP   Cr�ation de l'unit� : Calcul des ICC
 7.09.001.010   27/03/07  JP   FQ 10421 : possibilit� de saisir la date de fin
 8.00.002.002   30/07/07  JP   Nouvelle gestion des soldes qui ne sont plus stock�s dans la base
--------------------------------------------------------------------------------------}
unit TRCALCULICC_TOF;

interface

uses
  {$IFDEF EAGLCLIENT}
  MaineAGL, UtileAGL,
  {$ELSE}
  FE_MAIN, EdtREtat,{$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
  {$ENDIF}
  StdCtrls, Controls, UTob, Classes, SysUtils, UTOF;


type
  TOF_TRCALCULICC = class (TOF)
    procedure OnArgument (S : string); override;
    procedure OnUpdate               ; override;
    procedure OnClose                ; override;
  protected
    Interets : Double;
    SensCred : Boolean;
    TobEtat  : TOB;
    FKeyDown : TKeyEvent;

    procedure CalculInterets;
    procedure CalculTauxMoyen;
  public
    procedure CalculOnClick(Sender : TObject);
    procedure BTauxOnClick (Sender : TObject);
    procedure SoldeOnClick (Sender : TObject);
    procedure EcranKeyDown (Sender: TObject; var Key: Word; Shift: TShiftState);
  end;


function TRLanceFiche_CalculIcc(Arguments : string) : string;

implementation

uses
  Vierge, HCtrls, HEnt1, HMsgBox, TRMULTAUXICC_TOF, Commun, Constantes,
  UProcSolde, HTB97, Math;

{---------------------------------------------------------------------------------------}
function TRLanceFiche_CalculIcc(Arguments : string) : string;
{---------------------------------------------------------------------------------------}
begin
  Result := AglLanceFiche('TR', 'TRCALCULICC', '', '', Arguments);
end ;

{---------------------------------------------------------------------------------------}
procedure TOF_TRCALCULICC.OnArgument(S : string);
{---------------------------------------------------------------------------------------}
var
  Q : TQuery;
  D : string;
  B : string;
  G : string;
begin
  inherited;
  Ecran.HelpContext := 150;

  if S <> '' then begin
    G := ReadTokenSt(S);
    SetControlText('EDGENERAL', G);
    SetControlEnabled('EDGENERAL', False);
  end;

  {On commence � chercher les dates de d�but et de fin d'exercice de la date pass�e en param�tre}
  if S <> '' then begin
    B := GetInfosSocFromBQ(G, False).RT;
    D := ReadTokenSt(S);
    Q := OpenSQL('SELECT EX_DATEDEBUT, EX_DATEFIN FROM EXERCICE WHERE "' + UsDateTime(StrToDate(D)) +
                 '" BETWEEN EX_DATEDEBUT AND EX_DATEFIN', True, -1, '', False, B);
    if not Q.EOF then begin
      {On m�morise la date de d�but d'exercice pour la cr�ation du flux}
      LaTOB.SetDateTime('TE_DATEVALID', Q.FindField('EX_DATEDEBUT').AsDateTime);
      SetControlText('EDDU' , Q.FindField('EX_DATEDEBUT').AsString);
      SetControlText('EDDU_', Q.FindField('EX_DATEFIN').AsString);
    end else begin
      SetControlText('EDDU' , DateToStr(DebutAnnee(StrToDate(D))));
      SetControlText('EDDU_', DateToStr(FinAnnee  (StrToDate(D))));
    end;
  end;

  if S <> '' then
    SensCred := ReadTokenSt(S) = 'C'
  else
    PGIError(TraduireMemoire('Impossible de r�cup�rer le sens du Flux.'#13'Le sens sera consid�rer comme d�biteur.'));

  {On limite l'affichage aux comptes courants des dossiers du regroupement Tr�so}
  THEdit(GetControl('EDGENERAL')).Plus := FiltreBanqueCp(tcp_Tous, tcb_Courant, '');

  TToolbarButton97(GetControl('BCALCUL')).OnClick := CalculOnClick;
  TToolbarButton97(GetControl('BTAUX'  )).OnClick := BTauxOnClick;
  TToolbarButton97(GetControl('BSOLDE' )).OnClick := SoldeOnClick;

  {30/07/07/ : Dans la nouvelle gestion des soldes, le recalcul des soldes est inutile}
  if IsNewSoldes then begin
    (GetControl('BSOLDE' ) as TToolbarButton97).Visible := False;
    (GetControl('BCALCUL') as TToolbarButton97).Left := (GetControl('BTAUX' ) as TToolbarButton97).Left;
    (GetControl('BTAUX'  ) as TToolbarButton97).Left := (GetControl('BSOLDE') as TToolbarButton97).Left;
  end;

  TobEtat := TOB.Create('�INTERETSCC', nil, -1);
  TFVierge(Ecran).Retour := '';
  {27/03/07 : FQ 10421 : Activation de la date de fin}
  THEdit(GetControl('EDDU_')).ReadOnly := False;

  FKeyDown := Ecran.OnKeyDown;
  Ecran.OnKeyDown := EcranKeyDown;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRCALCULICC.OnUpdate;
{---------------------------------------------------------------------------------------}
begin
  inherited;
  TFVierge(Ecran).Retour := 'OK';
  LaTOB.SetDouble('MONTANT', Interets);
  LaTOB.SetDateTime('DEBUT', StrToDate(GetControlText('EDDU')));
  LaTOB.SetDateTime('FIN', StrToDate(GetControlText('EDDU_')));
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRCALCULICC.OnClose;
{---------------------------------------------------------------------------------------}
begin
  if Assigned(TobEtat) then FreeAndNil(TobEtat);
  inherited;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRCALCULICC.CalculOnClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  TobEtat.ClearDetail;
  CalculInterets;
  THNumEdit(GetControl('EDTAUX')).Value := Interets;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRCALCULICC.SoldeOnClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  RecalculSolde(GetControlText('EDGENERAL'), GetControlText('EDDU'), 0, True);
  PGIBox(TraduireMemoire('Recalcul termin�'), Ecran.Caption);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRCALCULICC.BTauxOnClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  TRLance_FicheTauxIcc(GetControlText('EDGENERAL') + ';');
end;

{1 / Il est prudent de commencer par un recalcul des soldes sur le compte concern�
 2 / Les int�r�ts sont calcul�s sur toutes les �critures courantes (pr�visionnelles et r�alis�es)
 3 / Il faut que les int�r�ts couvrent toute la p�riode, sinon, on applique 0 comme taux
{---------------------------------------------------------------------------------------}
procedure TOF_TRCALCULICC.CalculInterets;
{---------------------------------------------------------------------------------------}
var
  TobTaux   : TOB;
  Q         : TQuery;
  DateDeb   : TDateTime;
  DateFin   : TDateTime;
  Solde     : Double;
  Coherence : Boolean;
  F         : TOB;

      {--------------------------------------------------------------------}
      procedure CalculTaux;
      {--------------------------------------------------------------------}
      var
        Taux  : Double;
        T     : TOB;
        n     : Integer;
        Jours : Integer;
        Test  : TDateTime;
      begin
        Jours := Trunc(DateFin - DateDeb);
        {Si l'op�ration n'est pas la derni�re du jour, on sort car ce que le veut
         r�cup�rer et traiter, c'est le solde � la fin de la journ�e}
        if Jours = 0 then Exit;
        {Test sert � v�rifier qu'il y ait des taux sur toute la p�riode et aux calculs par niveaux}
        Test := DateDeb;

        for n := 0 to TobTaux.Detail.Count - 1 do begin
          T := TobTaux.Detail[n];
          {Si la p�riode de validit� du solde courant ne correspond pas �
           la validit� du taux courant, on passe au taux suivant}
          if T.GetDateTime('ICD_DATEAU') < DateDeb then Continue;
          {Si la p�riode de validit� du solde courant est ant�rieure
           � la validit� du taux courant, on quitte la boucle}
          if T.GetDateTime('ICD_DATEDU') > DateFin then Break;

          {Il y a des trous dans la saisie des taux}
          if (Test + 1) < T.GetDateTime('ICD_DATEDU') then
            Coherence := False;
          Taux  := T.GetDouble('ICD_TAUX');
          Jours := Trunc(Min(T.GetDateTime('ICD_DATEAU'), DateFin) - Test);
          Interets := Interets + (Jours * Solde * Taux) / (100 * 365);
          F := TOB.Create('�ICC', TobEtat, -1);
          F.AddChampSupValeur('TAUX', Taux);
          F.AddChampSupValeur('INTERETS', Arrondi((Jours * Solde * Taux) / (100 * 365), V_PGI.OkDecV));
          F.AddChampSupValeur('JOURS', Jours);
          F.AddChampSupValeur('SOLDE', Solde);
          F.AddChampSupValeur('DATED', Test);
          F.AddChampSupValeur('DATEF', Min(T.GetDateTime('ICD_DATEAU'), DateFin));
          F.AddChampSupValeur('GENERAL', GetControlText('EDGENERAL'));
          F.AddChampSupValeur('TAUX', Taux);
          F.AddChampSupValeur('LIBELLE', T.GetString('BQ_LIBELLE'));

          Test := T.GetDateTime('ICD_DATEAU');
          if Test > DateFin then Break;
        end;
        {Les taux ne couvrent pas toutes la p�riode de validit� du solde courant}
        if DateFin > Test then Coherence := False;
      end;

begin
  Interets := 0;
  Coherence := True;

  DateDeb := StrToDateTime(GetControlText('EDDU')) - 1;
  DateFin := DateDeb;

  TobTaux := Tob.Create('�TAUX', nil, -1);
  try
    TobTaux.LoadDetailFromSQL('SELECT ICD_DATEDU, ICD_DATEAU, ICD_TAUX, BQ_LIBELLE FROM ICCTAUXCOMPTE ' +
                     'LEFT JOIN BANQUECP ON BQ_CODE = ICD_GENERAL WHERE ' +
                     'ICD_GENERAL = "' + GetControlText('EDGENERAL') + '" AND ((ICD_DATEDU BETWEEN "' +
                     UsDateTime(StrToDateTime(GetControlText('EDDU'))) + '" AND "' +
                     UsDateTime(StrToDateTime(GetControlText('EDDU_'))) + '") ' +
                     ' OR (ICD_DATEAU > "' + UsDateTime(StrToDateTime(GetControlText('EDDU_'))) + '" AND ' +
                     'ICD_DATEDU < "' + UsDateTime(StrToDateTime(GetControlText('EDDU'))) + '") ' +
                     'OR (ICD_DATEAU BETWEEN "' +
                     UsDateTime(StrToDateTime(GetControlText('EDDU'))) + '" AND "' +
                     UsDateTime(StrToDateTime(GetControlText('EDDU_'))) + '")) ' +
                     'ORDER BY ICD_DATEAU');

    if TobTaux.Detail.Count > 0 then begin
      {Test de la coh�rence des taux sur la p�riode : il faut au moins des taux au d�but et � la fin de la p�riode}
      if (TobTaux.Detail[0].GetDateTime('ICD_DATEDU') > DateDeb + 1) or
         (TobTaux.Detail[TobTaux.Detail.Count - 1].GetDateTime('ICD_DATEAU') < StrToDateTime(GetControlText('EDDU_'))) then
        Coherence := False;

      {Calcul du dernier solde avant le d�but de la p�riode}
      Solde := GetSoldeInit(GetControlText('EDGENERAL'), DateToStr(DateDeb + 1), '', True);
      if StrFPoint(Solde) = '0.001' then Solde := 0;
      {R�cup�ration des soldes sur la p�riode tri�es par les Clefs de valeurs croissantes}
      Q := OpenSQL('SELECT TE_DATEVALEUR, TE_SOLDEDEVVALEUR, TE_MONTANTDEV FROM TRECRITURE ' +
                   'WHERE TE_GENERAL = "' + GetControlText('EDGENERAL') +
                   '"AND TE_DATEVALEUR BETWEEN "' +
                   UsDateTime(StrToDateTime(GetControlText('EDDU'))) + '" AND "' +
                   UsDateTime(StrToDateTime(GetControlText('EDDU_'))) + '" ' +
                   'ORDER BY TE_DATEVALEUR, TE_CLEVALEUR', True);
      try
        if not Q.EOF then begin
          if IsNewSoldes then
            {Calcul du solde initial en d�but de p�riode, auquel on ajoutera les op�ration de la requ�te}
            Solde := GetSoldeInit(GetControlText('EDGENERAL'), GetControlText('EDDU'), '', True);

          while not Q.EOF do begin
            DateFin := Q.FindField('TE_DATEVALEUR').AsDateTime;
            CalculTaux;

            if not IsNewSoldes then
              Solde := Q.FindField('TE_SOLDEDEVVALEUR').AsFloat
            else
              Solde := Solde + Q.FindField('TE_MONTANTDEV').AsFloat;

            DateDeb := DateFin;
            Q.Next;
          end; {while not Q.EOF}

          {Si la derni�re op�ration est ant�rieure � la date de fin, on calcul les taux sur la fin de l'exercice}
          if DateFin < StrToDateTime(GetControlText('EDDU_')) then begin
            DateFin := StrToDateTime(GetControlText('EDDU_'));
            CalculTaux;
          end;
        end {if not Q.EOF}

        else begin
          DateFin := StrToDateTime(GetControlText('EDDU_'));
          CalculTaux;
        end;

      finally
        Ferme(Q);
        Interets := Arrondi(Interets, V_PGI.OkDecV);
        if not Coherence or (Interets = 0) then
          PGIBox(TraduireMemoire('La saisie des taux n''est pas coh�rente.'#13'Les int�r�ts calcul�s ne sont qu''une approximation.'));

        if (SensCred and (Interets < 0)) or (not SensCred and (Interets > 0)) then begin
          PGIError(TraduireMemoire('Les int�r�ts calcul�s (' + FloatToStr(Interets) + ') ne correspondent pas au sens du flux.'#13'Traitement interrompu.'));
          Interets := 0;
          TFVierge(Ecran).BFerme.Click;
        end
        else begin
          CalculTauxMoyen;
          LanceEtatTob('E', 'TIC', 'TIC', TobEtat, True, False, False, nil, '', 'Int�r�ts des comptes courants', False);
          Interets := Abs(Interets);
        end;
      end;{Finally}
    end {if TobTaux.Detail.Count > 0}

    else begin
      PGIError(TraduireMemoire('Il n''y a pas de taux sur la p�riode pour ce compte.'#13'Traitement interrompu.'));
      BTauxOnClick(GetControl('BTAUX'));
    end;
  finally
    FreeAndNil(TobTaux);
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRCALCULICC.EcranKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
{---------------------------------------------------------------------------------------}
begin
  if (Key = Ord('C')) and (ssCtrl in Shift) then
    CalculOnClick(GetControl('BCALCUL'))
  else if (Key = Ord('S')) and (ssCtrl in Shift) then
    SoldeOnClick(GetControl('BSOLDE'))
  else if (Key = Ord('T')) and (ssCtrl in Shift) then
    BTauxOnClick(GetControl('BTAUX'));

  FKeyDown(Sender, Key, Shift);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRCALCULICC.CalculTauxMoyen;
{---------------------------------------------------------------------------------------}
var
  n    : Integer;
  Base : Double;
  Taux : Double;
begin
  Base := 0;
  Taux := 0;
  for n := 0 to TobEtat.Detail.Count - 1 do
   Base := Base + TobEtat.Detail[n].GetDouble('SOLDE') * TobEtat.Detail[n].GetInteger('JOURS');
  if Base <> 0 then
    for n := 0 to TobEtat.Detail.Count - 1 do
      Taux := Taux + TobEtat.Detail[n].GetDouble('SOLDE') * TobEtat.Detail[n].GetInteger('JOURS') *
                     TobEtat.Detail[n].GetDouble('TAUX') / Base;
  for n := 0 to TobEtat.Detail.Count - 1 do
    TobEtat.Detail[n].AddChampSupValeur('MOYENNE', Taux);
end;

initialization
  RegisterClasses([TOF_TRCALCULICC]);

end.

