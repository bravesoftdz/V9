{ Unit� : Anc�tre des TOFS pour QRS1
--------------------------------------------------------------------------------------
    Version   |  Date  | Qui |   Commentaires
--------------------------------------------------------------------------------------
 7.05.001.001  24/10/06  JP   Regroupements des traitements commun aux Etats
 8.10.001.004  08/08/07  JP   Gestion des confidentialit�s
--------------------------------------------------------------------------------------}
unit uAncetreEtat;

interface

uses
  StdCtrls, Controls, Classes, Sysutils,
  {$IFNDEF EAGLCLIENT}
  QRS1,
  {$ELSE}
  eQRS1,
  {$ENDIF}
  {$IFDEF TRCONF}
  uLibConfidentialite,
  {$ELSE}
  UTOF,
  {$ENDIF TRCONF}
  HCtrls;

type
  {$IFDEF TRCONF}
  TRANCETREETAT = class (TOFCONF)
  {$ELSE}
  TRANCETREETAT = class (TOF)
  {$ENDIF TRCONF}
    procedure OnArgument(S : string); override;
    procedure OnClose               ; override;
  private
    procedure GereParamEtat;
    procedure GereComboDevise;
  protected
    EtatMD       : Boolean; {Etat de l'entr�e de menu Multi soci�t�s}
    AvecParamSoc : Boolean; {Etat contenant des ParamSoc}
  public
    ComboDevise : THValComboBox;

    procedure DeviseOnChange(Sender : TObject); virtual;
  end;


implementation

uses
  HEnt1, LicUtil, Commun, ExtCtrls, UProcEtat;


{---------------------------------------------------------------------------------------}
procedure TRANCETREETAT.OnArgument(S : string);
{---------------------------------------------------------------------------------------}
begin
  inherited;
  {Autorisation du choix de l'�tat et de son param�trage}
  GereParamEtat;
  {R�cup�re la combo devise}
  GereComboDevise;
  {A True, s'il s'agit d'un QRS1 Multi soci�t�s, dans le sens des regroupements MultiSoc et non pas Tr�so}
  EtatMD := Copy(TFQRS1(Ecran).Name, Length(TFQRS1(Ecran).Name) - 1, 2) = 'MD';
  {Pour la gestion de la fonction de r�cup�ration des paramsoc multi soci�t�s}
  if AvecParamSoc then GereDllEtat(True);
end;

{---------------------------------------------------------------------------------------}
procedure TRANCETREETAT.OnClose;
{---------------------------------------------------------------------------------------}
begin
  {Pour la gestion de la fonction de r�cup�ration des paramsoc multi soci�t�s}
  if AvecParamSoc then GereDllEtat(False);
  inherited;
end;

{---------------------------------------------------------------------------------------}
procedure TRANCETREETAT.DeviseOnChange(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  AssignDrapeau(TImage(GetControl('IDEV')), ComboDevise.Value);
end;

{---------------------------------------------------------------------------------------}
procedure TRANCETREETAT.GereParamEtat;
{---------------------------------------------------------------------------------------}
begin
  TFQRS1(Ecran).ChoixEtat := True;
  TFQRS1(Ecran).ParamEtat := V_PGI.Superviseur or (V_PGI.Password = CryptageSt(DayPass(Date)));
end;

{---------------------------------------------------------------------------------------}
procedure TRANCETREETAT.GereComboDevise;
{---------------------------------------------------------------------------------------}
var
  n : Integer;
begin
  for n := 0 to Ecran.ComponentCount - 1 do
    if (Pos('_DEVISE', Ecran.Components[n].Name) > 0) and (Ecran.Components[n] is THValComboBox) then begin
      ComboDevise := THValComboBox(Ecran.Components[n]);
      Break;
    end;

  if Assigned(ComboDevise) then
    ComboDevise.OnChange := DeviseOnChange;
end;

end.
