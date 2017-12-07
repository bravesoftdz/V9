{ Unit� : Source TOF de la FICHE : TRQRCAHIERTARIFS
--------------------------------------------------------------------------------------
    Version   |  Date  | Qui |   Commentaires
--------------------------------------------------------------------------------------
 6.xx.xxx.xxx  08/07/04  JP   Cr�ation de l'unit�
 8.10.001.004  09/08/07  JP   Branchement de l'anc�tre des �tats

--------------------------------------------------------------------------------------}
unit TRQRCAHIERTARIFS_TOF;

interface

uses
  StdCtrls, Controls, Classes,
  {$IFDEF EAGLCLIENT}
  eQRS1, MaineAGL,
  {$ELSE}
  QRS1, FE_Main,
  {$ENDIF}
  SysUtils, HCtrls, UTOF, HEnt1, LicUtil, uAncetreEtat;

type
  TOF_TRQRCAHIERTARIFS = class(TRANCETREETAT)
    procedure OnArgument(S : string); override;
    procedure AgenceChange(Sender : TObject);
  end;

procedure TRLanceFiche_CahierTarifs(Dom, Fiche, Range, Lequel, Arguments : string);

implementation


{---------------------------------------------------------------------------------------}
procedure TRLanceFiche_CahierTarifs(Dom, Fiche, Range, Lequel, Arguments : string);
{---------------------------------------------------------------------------------------}
begin
  AGLLanceFiche(Dom, Fiche, Range, Lequel, Arguments);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRQRCAHIERTARIFS.OnArgument(S : string );
{---------------------------------------------------------------------------------------}
begin
  inherited;
  Ecran.HelpContext := 150;
  THValComboBox(GetControl('TRC_AGENCE')).OnExit := AgenceChange;
  {08/07/04 : Gestion du param�trage des �tats
   09/08/07 : g�r� dans l'anc�tre
  TFQRS1(Ecran).ChoixEtat := True;
  TFQRS1(Ecran).ParamEtat := V_PGI.Superviseur or (V_PGI.Password = CryptageSt(DayPass(Date)));}
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRQRCAHIERTARIFS.AgenceChange(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  ch : string;
begin
  {On filtre les contrats en fonction de l'agence}
  ch := GetControlText('TRC_AGENCE');
  if (ch <> '') and (Pos('<<', ch) = 0) then
    THMultiValComboBox(GetControl('TRC_CODECONTRAT')).Plus := 'TRC_AGENCE = "' + ch + '"';
  {Remarque : si l'on travaille � la souris, le click sur le bouton du MultiValCombo contrat
              est ex�cut� avnt le OnChange, le OnExit du Combo Agence et Avant le OnEnter du
              multivalcombobox : en fait c'est la cr�ation de la liste de dialogue qui ex�xute
              ces �v�nements. La propi�t� OnDialog est ex�cut� � la fin du DoClick du Multi,
              donc trop tard. Il faudrait que DoClick soit public, ou au moins avoir un pointeur
              comme OnDialog, mais au d�but de DoClick}
end;

initialization
  RegisterClasses([TOF_TRQRCAHIERTARIFS]);

end.
