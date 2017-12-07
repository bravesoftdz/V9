{ Unit� : Source TOF de la FICHE : TRQRRELEVEBQ
--------------------------------------------------------------------------------------
    Version   |  Date  | Qui |   Commentaires
--------------------------------------------------------------------------------------
 0.91          17/11/03  JP   Cr�ation de l'unit�
 7.05.001.001  24/10/06  JP   Gestion des filtres multi soci�t�s
                              Mise en place de l'anc�tre des �tats
 8.10.001.004  08/08/07  JP   Gestion des confidentialit�s
--------------------------------------------------------------------------------------}
unit TRQRRELEVEBQ_TOF;

interface

uses
  StdCtrls, Controls, Classes,
  {$IFNDEF EAGLCLIENT}
  QRS1, FE_Main,
  {$ELSE}
  eQRS1, MaineAGL,
  {$ENDIF}
  SysUtils, UTOF, uAncetreEtat;

type
  TOF_TRQRRELEVEBQ = class (TRANCETREETAT)
    procedure OnArgument(S : string); override;
    procedure OnLoad                ; override;
  private
  end;

procedure TRLanceFiche_Releve(Dom, Fiche, Range, Lequel, Arguments : string);

implementation

uses
  {$IFDEF TRCONF}
  ULibConfidentialite,
  {$ENDIF TRCONF}
  HCtrls, Commun, HEnt1;

{---------------------------------------------------------------------------------------}
procedure TRLanceFiche_Releve(Dom, Fiche, Range, Lequel, Arguments : string);
{---------------------------------------------------------------------------------------}
begin
  AGLLanceFiche(Dom, Fiche, Range, Lequel, Arguments);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRQRRELEVEBQ.OnArgument(S : string );
{---------------------------------------------------------------------------------------}
begin
  {$IFDEF TRCONF}
  TypeConfidentialite := tyc_Banque + ';';
  {$ENDIF TRCONF}
  inherited;
  Ecran.HelpContext := 150;
  {24/10/06 : On filtre les comptes en fonction des soci�t�s du regroupement Tr�so}
  if not EtatMD then
    THValComboBox(GetControl('TE_GENERAL')).Plus := FiltreBanqueCp(THValComboBox(GetControl('TE_GENERAL')).DataType, '', '');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRQRRELEVEBQ.OnLoad;
{---------------------------------------------------------------------------------------}
var
  Deb : string;
begin
  inherited;
  Deb := DateToStr(DebutAnnee(StrToDate(GetControlText('TE_DATEVALEUR'))));
  {Mise � jour des crit�res de d�but et de fin qui permettent de simuler un extrait bancaire}
  SetControlText('DATEDEB', GetControlText('TE_DATEVALEUR'));
  SetControlText('DATEFIN', GetControlText('TE_DATEVALEUR_'));
  SetControlText('DEBANNEE', Deb);
end;

initialization
  RegisterClasses([TOF_TRQRRELEVEBQ]);
                       
end.
