{Source de la tof TRCUBEECRITURE
--------------------------------------------------------------------------------------
  Version     | Date   | Qui  |   Commentaires
--------------------------------------------------------------------------------------
07.05.001.001  10/10/06   JP   FQ 10331 : cr�ation d'une remise � zero
08.10.001.010  17/09/07   JP   FQ 10500 : Je supprime la double confirmation en ouverture de fiche
--------------------------------------------------------------------------------------}
unit TRREMISEAZERO_TOF;

interface

uses
  StdCtrls, Controls, Classes, Sysutils, UTOF;

type
  TOF_TRREMISEAZERO = class (TOF)
    procedure OnArgument(S : string); override;
    procedure OnUpDate              ; override;
  protected
     mmResult : TMemo;

     procedure MajMemo(Chaine : string);
     procedure LanceTraitement;
     procedure AnnulePremierSynchro(NomBase : string);
     procedure VideTable  ;
     procedure MajParamSoc;
  end;


procedure RemiseAZero;

implementation

uses
  {$IFDEF EAGLCLIENT}
  MaineAGL,
  {$ELSE}
  FE_Main,
  {$ENDIF}
  HCtrls, HEnt1, UtilPgi, HMsgBox, LicUtil, UProcGen, Constantes, ParamSoc, Forms, Commun;

{---------------------------------------------------------------------------------------}
procedure RemiseAZero;
{---------------------------------------------------------------------------------------}
begin
  if not _BlocageMonoPoste(True) then
    Exit;

  try
    if OKToutSeul then begin
      if (V_PGI.Superviseur = True) and (V_PGI.PassWord = CryptageSt(DayPass(Date))) then begin
        {17/09/07 : FQ 10500 : Je supprime la double confirmation en ouverture de fiche
        if HShowMessage('5;Remise � z�ro;Confirmez la remise � z�ro de l''activit� ?;Q;YNC;N;N;', '', '') = mrYes then
          if HShowMessage('6;Remise � z�ro;D�sirez-vous abandonner l''op�ration ?;Q;YNC;Y;Y;', '', '') = mrNo then}
        AGLLanceFiche('TR', 'TRREMISEAZERO', '', '', '');
      end
      else
        HShowMessage('3;Remise � z�ro;Seul un administrateur connect� avec le mot de passe du jour peut effectuer une RAZ d''activit�.;W;O;O;O;', '', '')
    end
    else
      HShowMessage('0;Remise � z�ro;Cette op�ration est impossible : vous devez �tre seul sur le r�seau.;W;O;O;O;', '', '');

  finally
    _DeblocageMonoPoste(True);
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRREMISEAZERO.OnArgument(S: string);
{---------------------------------------------------------------------------------------}
var
  ch : string;
begin
  inherited;
  Ecran.HelpContext := 150;
  mmResult := TMemo(GetControl('MMRESULT'));
  {22/08/08 : FQ 10554 : Correction du libell� de la fiche}
  ch := 'La remise � z�ro purge toutes les tables de la tr�sorerie contenant des mouvements ' +
        'et r�initialise la premi�re synchronisation.';
  SetControlProperty('BLTOP', 'CAPTION', ch);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRREMISEAZERO.OnUpDate;
{---------------------------------------------------------------------------------------}
begin
  inherited;
  if HShowMessage('5;Remise � z�ro;Confirmez la remise � z�ro de l''activit� ?;Q;YNC;N;N;', '', '') = mrYes then
    if HShowMessage('6;Remise � z�ro;D�sirez-vous abandonner l''op�ration ?;Q;YNC;Y;Y;', '', '') = mrNo then
      LanceTraitement;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRREMISEAZERO.LanceTraitement;
{---------------------------------------------------------------------------------------}
var
  s : string;
begin
  BeginTrans;
  try
    if IsTresoMultiSoc then begin
      s := FiltreBaseTreso(True);
      while (s <> '') do AnnulePremierSynchro(ReadTokenSt(s));
    end
    else
      AnnulePremierSynchro('');

    MajMemo(' ');
    VideTable;
    MajMemo(' ');
    MajParamSoc;
    MajMemo(' ');
    MajMemo('TRAITEMENT TERMIN�');
    CommitTrans;
  except
    on E : Exception do begin
      RollBack;
      MajMemo('TRAITEMENT INTERROMPU');
      MajMemo(' ');
      MajMemo(E.Message);
    end;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRREMISEAZERO.VideTable;
{---------------------------------------------------------------------------------------}
begin
  try
    MajMemo('DELETE FROM TRECRITURE = EN COURS');
    ExecuteSQL('DELETE FROM TRECRITURE');
    MajMemo('DELETE FROM TRECRITURE = OK');
    MajMemo(' ');

    MajMemo('DELETE FROM COMPTEURTRESO = EN COURS');
    ExecuteSQL('DELETE FROM COMPTEURTRESO');
    MajMemo('DELETE FROM COMPTEURTRESO = OK');
    MajMemo(' ');

    MajMemo('DELETE FROM COURTSTERMES = EN COURS');
    ExecuteSQL('DELETE FROM COURTSTERMES');
    MajMemo('DELETE FROM COURTSTERMES = OK');
    MajMemo(' ');

    MajMemo('DELETE FROM EQUILIBRAGE = EN COURS');
    ExecuteSQL('DELETE FROM EQUILIBRAGE');
    MajMemo('DELETE FROM EQUILIBRAGE = OK');
    MajMemo(' ');

    MajMemo('DELETE FROM TRVENTEOPCVM = EN COURS');
    ExecuteSQL('DELETE FROM TRVENTEOPCVM');
    MajMemo('DELETE FROM TRVENTEOPCVM = OK');
    MajMemo(' ');

    MajMemo('DELETE FROM TROPCVM = EN COURS');
    ExecuteSQL('DELETE FROM TROPCVM');
    MajMemo('DELETE FROM TROPCVM = OK');
    MajMemo(' ');
  except
    on E : Exception do begin
      MajMemo('ERREUR DANS VIDE TABLE');
      raise;
    end;
  end;

end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRREMISEAZERO.AnnulePremierSynchro(NomBase : string);
{---------------------------------------------------------------------------------------}
begin
  try
    if NomBase <> '' then
      MajMemo('DOSSIER : ' + NomBase);
    MajMemo('REINITAILISE PREMI�RE SYNCHRO = EN COURS');
    ExecuteSQL('UPDATE ' + GetTableDossier(NomBase, 'ECRITURE') + ' SET E_TRESOSYNCHRO = "' + ets_Nouveau +
               '" WHERE E_TRESOSYNCHRO <> "' + ets_Rien + '"');
    MajMemo('REINITAILISATION PREMI�RE SYNCHRO = OK');
    MajMemo(' ');
  except
    on E : Exception do begin
      MajMemo('ERREUR DANS ANNULE PREMI�RE SYNCHRO');
      raise;
    end;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRREMISEAZERO.MajParamSoc;
{---------------------------------------------------------------------------------------}
begin
  try
    SetParamSoc('SO_PREMIERESYNCHRO', False);
    SetParamSoc('SO_TRDATEPREMSYNCHRO', iDate1900);

    MajMemo('PARAM�TRES SOCI�T� = OK');
  except
    on E : Exception do begin
      MajMemo('ERREUR DANS LA MISE � JOUR DES PARAM�TRES SOCI�T�');
      raise;
    end;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRREMISEAZERO.MajMemo(Chaine: string);
{---------------------------------------------------------------------------------------}
begin
  mmResult.Lines.Add(Chaine);
  Application.ProcessMessages;
end;

initialization
  RegisterClasses([TOF_TRREMISEAZERO]);


end.
