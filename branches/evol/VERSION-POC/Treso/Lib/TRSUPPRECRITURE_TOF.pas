{ Unit� : Source TOF de la FICHE : TRSUPPRECRITURE
--------------------------------------------------------------------------------------
    Version   |  Date  | Qui |   Commentaires
--------------------------------------------------------------------------------------
    0.91       23/09/03  JP   Cr�ation de l'unit�
 6.xx.xxx.xxx  20/07/04  JP   Gestion des commissions dans la suppression
 6.50.001.010  26/07/05  JP   FQ 10158 : Suppression des �critures de comptabilit�
 7.05.001.001  10/08/06  JP   Gestion du mutli soci�t�s + suppression du crit�re devise
 7.05.001.001  13/09/06  JP   FQ 10344 : gestion du bouton SelectAll
 8.10.001.004  08/08/07  JP   Gestion des confidentialit�s
 8.10.001.010  20/09/07  JP   FQ 10524 : On �largit la suppression aux flux de saisie automatique et aux ICC
--------------------------------------------------------------------------------------}
unit TRSUPPRECRITURE_TOF;

interface

uses {$IFDEF VER150} variants,{$ENDIF}
  StdCtrls, Controls, Classes,
  {$IFNDEF EAGLCLIENT}
  Mul, FE_Main,
  {$ELSE}
  eMul, MaineAGL,
  {$ENDIF}
  {$IFDEF TRCONF}
  uLibConfidentialite,
  {$ELSE}
  UTOF,
  {$ENDIF TRCONF}
  Forms, SysUtils, HCtrls, HTB97;

type
  {$IFDEF TRCONF}
  TOF_TRSUPPRECRITURE = class (TOFCONF)
  {$ELSE}
  TOF_TRSUPPRECRITURE = class (TOF)
  {$ENDIF TRCONF}
    procedure OnArgument(S : string); override;
  private
    procedure ListeDblClick  (Sender : TObject);
    procedure SupprimerClick (Sender : TObject);
    {26/07/05 : FQ 10158 : Pour la mise � jour du XX_WHERE}
    procedure QualifOnChange (Sender : TObject);
    procedure SlctAllClick   (Sender : TObject);
    procedure NoDossierChange(Sender : TObject);
  end;

procedure TRLanceFiche_Suppression(Dom, Fiche, Range, Lequel, Arguments : string);

implementation

uses
  Commun, Math, UProcGen, Constantes, UProcCommission, UProcSolde,
  HMsgBox, HEnt1, UProcEcriture;

{---------------------------------------------------------------------------------------}
procedure TRLanceFiche_Suppression(Dom, Fiche, Range, Lequel, Arguments : string);
{---------------------------------------------------------------------------------------}
begin
  AglLanceFiche(Dom, Fiche, Range, Lequel, Arguments);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUPPRECRITURE.OnArgument (S : String ) ;
{---------------------------------------------------------------------------------------}
var
  Ctrl : TControl;
begin
  {$IFDEF TRCONF}
  TypeConfidentialite := tyc_Banque + ';';
  {$ENDIF TRCONF}
  inherited;
  Ecran.HelpContext := 50000135;
  TFMul(Ecran).FListe.OnDblClick := ListeDblClick;
  TToolbarButton97(GetControl('BDELETE')).OnClick := SupprimerClick;

  {13/09/06 : FQ 10344 : gestion du bouton allselected}
  SetControlVisible('BSELECTALL', True);
  TToolbarButton97(GetControl('BSELECTALL')).OnClick := SlctAllClick;

  {26/07/05 : FQ 10158}
  Ctrl := GetControl('TE_QUALIFORIGINE');
  if Assigned(Ctrl) then begin
    THValComboBox(Ctrl).OnChange := QualifOnChange;
    THValComboBox(Ctrl).ItemIndex := 0;
    {Pour mettre � jour la combo du QualifOrigine}
    QualifOnChange(THValComboBox(Ctrl));
  end;

  {08/08/06 : gestion du multi soci�t�s}
  SetControlVisible('TE_NODOSSIER' , IsTresoMultiSoc);
  SetControlVisible('TTE_NODOSSIER', IsTresoMultiSoc);

  {Gestion des filtres multi soci�t�s sur banquecp et dossier}
  THEdit(GetControl('TE_GENERAL')).Plus := FiltreBanqueCp(THEdit(GetControl('TE_GENERAL')).DataType, '', '');
  THValComboBox(GetControl('TE_NODOSSIER')).Plus := 'DOS_NODOSSIER ' + FiltreNodossier;
  THValComboBox(GetControl('TE_NODOSSIER')).OnChange := NoDossierChange;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUPPRECRITURE.NoDossierChange(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  THEdit(GetControl('TE_GENERAL')).Plus := FiltreBanqueCp(THEdit(GetControl('TE_GENERAL')).DataType, '', GetControlText('TE_NODOSSIER'));
  SetControlText('TE_GENERAL', '');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUPPRECRITURE.ListeDblClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  s : string;
begin
  s := GetField('TE_NODOSSIER') + ';' + GetField('TE_NUMTRANSAC') + ';' +
       VarToStr(GetField('TE_NUMEROPIECE')) + ';' + VarToStr(GetField('TE_NUMLIGNE'));
  AGLLanceFiche('TR', 'TRFICECRITURE', '', s, GetField('TE_NATURE') + ';');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUPPRECRITURE.SupprimerClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n : Integer;
  p : Integer;
  s : string;
  l : TStringList;
  o : TObjDtValeur;
  Clef : TClefCompta; {26/07/05 : FQ 10158}
begin
  {Aucune s�lection, on sort}
  if (TFMul(Ecran).FListe.NbSelected = 0)
  {$IFNDEF EAGLCLIENT}
  and not TFMul(Ecran).FListe.AllSelected
  {$ENDIF}
  then begin
    HShowMessage('0;Suppression d''�critures pr�visionnelles;Veuillez s�lectionner une �criture ?;W;O;O;O;', '', '');
    Exit;
  end;

  {Liste m�morisant les comptes trait�s pour un recalcul des soldes}
  l := TStringList.Create;
  l.Duplicates := dupIgnore;
  l.Sorted := True;
  try
    if HShowMessage('0;' + Ecran.Caption + ';�tes-vous s�r de vouloir supprimer les �critures s�lectionn�es ?;Q;YNC;N;C;', '', '') = mrYes then begin
      BeginTrans;
      try
        {$IFNDEF EAGLCLIENT}
        TFMul(Ecran).Q.First;
        if TFMul(Ecran).FListe.AllSelected then
          while not TFMul(Ecran).Q.EOF do begin
            s := TFMul(Ecran).Q.FindField('TE_GENERAL').AsString;
            p := l.IndexOf(s);
            if p > -1 then
              {On r�cup�re la date la plus ancienne pour le recalcul du compte}
              TObjDtValeur(l.Objects[p]).DateVal := Min(TObjDtValeur(l.Objects[p]).DateVal, TFMul(Ecran).Q.FindField('TE_DATECOMPTABLE').AsDateTime)
            else begin
              o := TObjDtValeur.Create;
              o.DateVal := TFMul(Ecran).Q.FindField('TE_DATECOMPTABLE').AsDateTime;
              l.AddObject(s, o);
            end;

            {20/07/04 : suppression des �critures avec la gestion des commissions}
            if not SupprimeEcriture(Ecran.Caption, TFMul(Ecran).Q.FindField('TE_NUMTRANSAC').AsString,
                                                   TFMul(Ecran).Q.FindField('TE_NUMEROPIECE').AsString,
                                                   TFMul(Ecran).Q.FindField('TE_NUMLIGNE').AsString,
                                                   TFMul(Ecran).Q.FindField('TE_NODOSSIER').AsString) then Break;

            {26/07/05 : FQ 10158 : Dans le cas des �critures comptables il faut remettre TE_TRESOSYNCHRO � CRE}
            if GetControlText('TE_QUALIFORIGINE') = QUALIFCOMPTA then begin
              Clef.Exo := TFMul(Ecran).Q.FindField('TE_EXERCICE').AsString;
              Clef.Jal := TFMul(Ecran).Q.FindField('TE_JOURNAL').AsString;
              Clef.Pce := TFMul(Ecran).Q.FindField('TE_NUMEROPIECE').AsInteger;
              Clef.Lig := TFMul(Ecran).Q.FindField('TE_CPNUMLIGNE').AsInteger;
              Clef.Ech := TFMul(Ecran).Q.FindField('TE_NUMECHE').AsInteger;
              Clef.dtC := TFMul(Ecran).Q.FindField('TE_DATECOMPTABLE').AsDateTime;
              Clef.Qlf := 'N';
              Clef.NoD := TFMul(Ecran).Q.FindField('TE_NODOSSIER').AsString; {10/08/06}
              Clef.Per := GetNumPeriodeTransac(TFMul(Ecran).Q.FindField('TE_NUMTRANSAC').AsString, TFMul(Ecran).Q.FindField('TE_JOURNAL').AsString);
              MajEcritureParClef('E_TRESOSYNCHRO', '"' + ets_Nouveau + '"', Clef);
            end;
            TFMul(Ecran).Q.Next;
          end
        else
        {$ENDIF}

        for n := 0 to TFMul(Ecran).FListe.nbSelected - 1 do begin
          TFMul(Ecran).FListe.GotoLeBookmark(n);
          {$IFDEF EAGLCLIENT}
          TFMul(Ecran).Q.TQ.Seek(TFMul(Ecran).FListe.Row - 1);
          {$ENDIF}

          s := VarToStr(GetField('TE_GENERAL'));
          p := l.IndexOf(s);
          if p > -1 then
            {On r�cup�re la date la plus ancienne pour le recalcul du compte}
            TObjDtValeur(l.Objects[p]).DateVal := Min(TObjDtValeur(l.Objects[p]).DateVal, VarToDateTime(GetField('TE_DATECOMPTABLE')))
          else begin
            o := TObjDtValeur.Create;
            o.DateVal := VarToDateTime(GetField('TE_DATECOMPTABLE'));
            l.AddObject(s, o);
          end;

          {20/07/04 : suppression des �critures avec la gestion des commissions}
          if not SupprimeEcriture(Ecran.Caption, VarToStr(GetField('TE_NUMTRANSAC')),
                                                 VarToStr(GetField('TE_NUMEROPIECE')),
                                                 VarToStr(GetField('TE_NUMLIGNE')),
                                                 VarToStr(GetField('TE_NODOSSIER'))) then Break;

          {26/07/05 : FQ 10158 : Dans le cas des �critures comptables il faut remettre TE_TRESOSYNCHRO � CRE}
          if GetControlText('TE_QUALIFORIGINE') = QUALIFCOMPTA then begin
            Clef.Exo := VarToStr(GetField('TE_EXERCICE'));
            Clef.Jal := VarToStr(GetField('TE_JOURNAL'));
            Clef.Pce := ValeurI(VarToStr(GetField('TE_NUMEROPIECE')));
            Clef.Lig := ValeurI(VarToStr(GetField('TE_CPNUMLIGNE')));
            Clef.Ech := ValeurI(VarToStr(GetField('TE_NUMECHE')));
            Clef.dtC := VarToDateTime(VarToStr(GetField('TE_DATECOMPTABLE')));
            Clef.Qlf := 'N';
            Clef.NoD := VarToStr(GetField('TE_NODOSSIER')); {10/08/06}
            Clef.Per := GetNumPeriodeTransac(GetField('TE_NUMTRANSAC'), GetField('TE_JOURNAL'));
            MajEcritureParClef('E_TRESOSYNCHRO', '"' + ets_Nouveau + '"', Clef);
          end;
        end;
        CommitTrans;
      except
        on E : Exception do begin
          RollBack;
          HShowMessage('0;' + Ecran.Caption + '; Traitement interrompu :'#13 + E.Message + ';E;O;O;O;', '', '');
        end;
      end;

      {Recalcul des soldes}
      for n := 0 to l.Count - 1 do
        RecalculSolde(l[n], DateToStr(TObjDtValeur(l.Objects[n]).DateVal), 0, True);
    end;

  finally
    LibereListe(l, True);
  end;

  {Raffra�chissement de la liste}
  TToolbarButton97(GetControl('BCHERCHE')).Click;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUPPRECRITURE.QualifOnChange(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  if GetControlText('TE_QUALIFORIGINE') = QUALIFCOMPTA then
    SetControlText('XX_WHERE', '')
  else
    {20/09/07 : FQ 10524 : �largir aux flux de saisie automatique et aux ICC}
    SetControlText('XX_WHERE', '(TE_USERCOMPTABLE = "" OR TE_USERCOMPTABLE IS NULL) AND ' +
                   '(TFT_CLASSEFLUX IN ("' + cla_Previ + '", "' + cla_Guide + '", "' + cla_Commission + '", "' + cla_ICC + '"))');
end;

{FQ 10344 : ajout du bouton BSelectAll
{---------------------------------------------------------------------------------------}
procedure TOF_TRSUPPRECRITURE.SlctAllClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  Fiche : TFMul;
begin
  Fiche := TFMul(Ecran);
  {$IFDEF EAGLCLIENT}
  if not Fiche.FListe.AllSelected then begin
    if not Fiche.FetchLesTous then Exit;
  end;
  {$ENDIF}
  Fiche.bSelectAllClick(nil);
end;

initialization
  RegisterClasses ( [ TOF_TRSUPPRECRITURE ] ) ;

end.
