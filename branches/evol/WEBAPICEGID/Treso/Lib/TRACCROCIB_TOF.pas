{ Unit� : Source TOF de la FICHE : TRACCROCIB_TOF
--------------------------------------------------------------------------------------
    Version   |  Date  | Qui |   Commentaires
--------------------------------------------------------------------------------------
 6.00.018.001  12/10/04  JP   Cr�ation de l'unit� FQ 10176
 8.10.001.004  17/08/07  JP   Dans la Continuit� de la FQ 21248 : Ajout de la r�gle d'accrochage sur Pi�ce
--------------------------------------------------------------------------------------}
unit TRACCROCIB_TOF;

interface

uses
  StdCtrls,  Controls,  Classes,
  {$IFNDEF EAGLCLIENT}
  FE_Main,
  {$ELSE}
  MaineAGL,
  {$ENDIF}
  Forms, SysUtils, HCtrls, HMsgBox, UTOF, Vierge, UTob;

type
  TOF_TRACCROCIB = class (TOF)
    procedure OnArgument(S : string); override;
    procedure OnUpdate              ; override;
    procedure OnClose               ; override;
  private
    CbRegle    : THValComboBox;
    chkDateOpe : TCheckBox;
    chkDateVal : TCheckBox;
    chkMontant : TCheckBox;
    chkPiece   : TCheckBox; {17/08/07}
    TobRegle   : TOB;

    procedure CbRegleChange(Sender : TObject);
  end ;

function TRLanceFiche_AccroCib : Boolean;


implementation

uses
  Constantes;

{---------------------------------------------------------------------------------------}
function TRLanceFiche_AccroCib : Boolean;
{---------------------------------------------------------------------------------------}
begin
  Result := AGLLanceFiche('TR', 'TRACCROCIB', '', '', '') <> '';
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRACCROCIB.OnArgument(S : string);
{---------------------------------------------------------------------------------------}
begin
  inherited;
  Ecran.HelpContext := 50000141; {13/11/07 : FQ 21437}

  CbRegle := THValComboBox(GetControl('CBREGLE'));
  CbRegle.OnChange := CbRegleChange;
  TFVierge(Ecran).Retour := '';

  chkDateOpe := TCheckBox(GetControl('BDATEOPE'));
  chkDateVal := TCheckBox(GetControl('BDATEVAL'));
  chkMontant := TCheckBox(GetControl('BMONTANT'));
  chkPiece   := TCheckBox(GetControl('BPIECE')); {17/08/07}

  TobRegle := Tob.Create('_REGLEACCRO', nil, -1);
  TobRegle.LoadDetailFromSQL('SELECT * FROM REGLEACCRO');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRACCROCIB.OnUpdate;
{---------------------------------------------------------------------------------------}
begin
  inherited;
  if HShowMessage('1;' + Ecran.Caption + ';�tes-vous s�r de vouloir mettre � jour les CIB de r�f�rence ?;Q;YNC;N;C', '', '') <> mrYes then Exit;
  if CbRegle.Value <> '' then begin
    ExecuteSQL('UPDATE CIB SET TCI_REGLEACCRO = "' + CbRegle.Value + '" WHERE TCI_BANQUE = "' + CODECIBREF + '"');
    HShowMessage('0;' + Ecran.Caption + ';Les CIB de r�f�rences ont �t� mis � jour;I;O;O;O;', '', '');
    TFVierge(Ecran).Retour := 'VALIDER';
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRACCROCIB.OnClose;
{---------------------------------------------------------------------------------------}
begin
  if Assigned(TobRegle) then FreeAndNil(TobRegle);
  inherited;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRACCROCIB.CbRegleChange(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  Code   : string;
  CurTob : TOB;
begin
  {R�cup�ration de la r�gle d'erreur}
  Code := CbRegle.Value;
  {On recherche dans la table la valeur des champs de la r�gle choisie}
  CurTob := TobRegle.FindFirst(['TRG_REGLEACCRO'], [Code], False);
  {Si la r�le n'a pas �t� trouv�e, on met tous les champs � False}
  if CurTob = nil then begin
    chkDateOpe.Checked := False;
    chkDateVal.Checked := False;
    chkMontant.Checked := False;
    chkPiece  .Checked := False; {17/08/07}
  end

  else begin
    {On affecte les champs de la fiche}
    chkDateOpe.Checked := CurTob.GetValue('TRG_BDATEOPE') = 'X';
    chkDateVal.Checked := CurTob.GetValue('TRG_BDATEVAL') = 'X';
    chkMontant.Checked := CurTob.GetValue('TRG_BMONTANT') = 'X';
    chkPiece  .Checked := CurTob.GetValue('TRG_BPIECE'  ) = 'X'; {17/08/07}
  end;
end;

initialization
  RegisterClasses([TOF_TRACCROCIB]);

end.

