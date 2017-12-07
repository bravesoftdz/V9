{ Unit� : Source TOF du Mul : TRMULCIB
--------------------------------------------------------------------------------------
    Version   |  Date  | Qui | Commentaires
--------------------------------------------------------------------------------------
 1.20.001.001  08/03/04  JP   Cr�ation de l'unit�  en remplacement des fiches TRCIBREFERENCE
                              (probl�me d'index) et TRREGLEACCRO (Trop grand nombre de
                              requ�tes pour les comboBoxes de la grille)
 6.00.018.001  12/10/04  JP   FQ 10176 : Affectation en s�rie des r�gles d'accrcochage
 7.00.001.010  06/06/06  JP   FQ 10362 : Impossible d'appeler la Fiche des Cib
 8.10.001.004  14/08/07  JP   FQ 21248 : Ajout de la r�gle d'accrochage sur Pi�ce dans l'ent�te
--------------------------------------------------------------------------------------}
unit TRMULCIB_TOF ;

interface

uses {$IFDEF VER150} variants,{$ENDIF}
  StdCtrls, Controls, Classes, HTB97,
  {$IFNDEF EAGLCLIENT}
  mul, FE_Main,
  {$ELSE}
  eMul, MaineAGL,
  {$ENDIF}
  Forms, SysUtils, HCtrls, HEnt1, UTOF, UTOB;

type
  TOF_TRMULCIB = Class (TOF)
    procedure OnArgument(S : string); override;
    procedure OnDisplay             ; override;
    procedure OnClose               ; override;
  private
    TobRegle   : TOB;
    chkDateOpe : TCheckBox;
    chkDateVal : TCheckBox;
    chkMontant : TCheckBox;
    chkPiece   : TCheckBox; {FQ 21248}

    procedure ChargeTobRegles;
    procedure MajRegle;
    procedure ListeDblClick(Sender : TObject);
    procedure BInsertClick (Sender : TObject);
    procedure BDeleteClick (Sender : TObject);
    procedure BRegleClick  (Sender : TObject);
    procedure MajAccrochage(Sender : TObject); {12/10/04 : FQ 10176}
  end ;

procedure TRLanceFiche_MulCIB(Dom, Fiche, Range, Lequel, Arguments : string);

implementation

uses
  TomCIB, Constantes, HMsgBox, REGLEACCRO_TOM, TRACCROCIB_TOF;

{---------------------------------------------------------------------------------------}
procedure TRLanceFiche_MulCIB(Dom, Fiche, Range, Lequel, Arguments : string);
{---------------------------------------------------------------------------------------}
begin
  AGLLanceFiche(Dom, Fiche, Range, Lequel, Arguments);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULCIB.OnArgument (S : String ) ;
{---------------------------------------------------------------------------------------}
begin
  inherited;
  Ecran.HelpContext := 50000144; {13/11/07 : FQ 21437}

                                   
  TFMul(Ecran).FListe.OnDblClick := ListeDblClick;

  TFMul(Ecran).Binsert.OnClick := BInsertClick;
  TToolbarButton97(GetControl('BDELETE')).OnClick := BDeleteClick;
  TToolbarButton97(GetControl('BAPPLIQUER')).OnClick := MajAccrochage; {12/10/04 : FQ 10176}

  Ecran.Caption := 'Liste des CIB de r�f�rence';
  UpdateCaption(Ecran);

  chkDateOpe := TCheckBox(GetControl('BDATEOPE'));
  chkDateVal := TCheckBox(GetControl('BDATEVAL'));
  chkMontant := TCheckBox(GetControl('BMONTANT'));
  chkPiece   := TCheckBox(GetControl('BPIECE')); {14/07/08 : FQ 21248}

  {Tob contenant les r�gles d'accrochage et leurs carect�ristiques}
  TToolbarButton97(GetControl('BREGLE')).OnClick := BRegleClick;
  TobRegle := Tob.Create('_REGLEACCRO', nil, -1);
  ChargeTobRegles;

  Application.ProcessMessages;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULCIB.ListeDblClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  Predef : string;
begin
  {$IFDEF EAGLCLIENT}
  {29/11/04 : en eAgl, il faut le code banque et le code cib dans le range}
//  TRLanceFiche_CIB('TR','TRFICCIB', CODECIBREF + ';' + VarToStr(GetField('TCI_CODECIB')), '', 'ACTION=MODIFICATION;' + tc_Reference);
  {$ELSE}
//  TRLanceFiche_CIB('TR','TRFICCIB', CODECIBREF, VarToStr(GetField('TCI_CODECIB')) + ';' + VarToStr(GetField('TCI_MODEPAIE')) + ';',  'ACTION=MODIFICATION;' + tc_Reference);
  {$ENDIF}
  {06/06/06 : FQ 10362 : A priori, il y eu uniformisation de la gestion du range}               // + VarToStr(GetField('TCI_MODEPAIE')) + ';', '',
  if CtxPcl in V_PGI.PGIContexte then Predef := 'CEG'
                                 else Predef := 'STD';

  { 19/06/07 : Cela n'est pas n�cessaire si l'on est pass� de 750 � 842 ou plus.
     Le probl�me se posait pour les socref ant�rieures � la 832. Voir MajHalley.MajVer828 et MajHalley.MajVer832
  if not (CtxPcl in V_PGI.PGIContexte) then begin
    if ExisteSQL('SELECT TCI_CODECIB FROM CIB WHERE TCI_PREDEFINI = "CEG" OR TCI_PREDEFINI = "" OR TCI_PREDEFINI IS NULL') then
      ExecuteSQL('UPDATE CIB SET TCI_PREDEFINI = "STD"');
  end; }

  TRLanceFiche_CIB('TR','TRFICCIB', Predef + ';' + CODECIBREF + ';' +
                   VarToStr(GetField('TCI_CODECIB')) + ';', '', 'ACTION=MODIFICATION;' + tc_Reference);

  {JP 04/05/04 : La recherche en retour n'est pas tr�s pratique en cr�ation ou modification, d'o�
                 l'ajout du test sur V_PGI.AutoSearch}
  if V_PGI.AutoSearch then TFMul(Ecran).BCherche.Click;
end;


{---------------------------------------------------------------------------------------}
procedure TOF_TRMULCIB.BInsertClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  TRLanceFiche_CIB('TR','TRFICCIB', CODECIBREF, '', 'ACTION=CREATION;' + tc_Reference);
  {JP 04/05/04 : La recherche en retour n'est pas tr�s pratique en cr�ation ou modification, d'o�
                 l'ajout du test sur V_PGI.AutoSearch}
  if V_PGI.AutoSearch then TFMul(Ecran).BCherche.Click;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULCIB.BDeleteClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n   : Integer;
  SQL : string;
  MD  : TModalResult;
begin
  if TFMul(Ecran).FListe.nbSelected = 0 then begin
    HShowMessage('0;' + Ecran.Caption + ';Auncun �l�ment n''est s�lectionn�.;W;O;O;O;', '', '');
    Exit;
  end;
  {14/01/05 : La suppression sur les cib par banque est un peu lourde : cette option offre plus de souplesse !}
  MD :=  HShowMessage('1;' + Ecran.Caption + ';Voulez-vous : '#13 +
                      '   - Supprimer les enregistrents s�lectionn�s pour toutes les banques [oui] ?'#13 +
                      '   - Supprimer les enregistrents s�lectionn�s uniquement en r�f�rence [non] ?'#13 +
                      '   - Annuler [annuler] ?;Q;YNC;C;C;', '', '');
  if MD = mrCancel then Exit;

  for n := 0 to TFMul(Ecran).FListe.nbSelected - 1 do begin
    TFMul(Ecran).FListe.GotoLeBookmark(n);
    if MD = mrYes then
      SQL := 'DELETE FROM CIB WHERE TCI_CODECIB = "'
    else
      SQL := 'DELETE FROM CIB WHERE TCI_BANQUE = "'+ CODECIBREF + '" AND TCI_CODECIB = "';
    SQL := SQL + VarToStr(GetField('TCI_CODECIB')) + '" AND TCI_MODEPAIE = "' + VarToStr(GetField('TCI_MODEPAIE')) + '"';
    ExecuteSQL(SQL);
  end;

  TFMul(Ecran).BCherche.Click;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULCIB.OnDisplay;
{---------------------------------------------------------------------------------------}
begin
  inherited;
  MajRegle;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULCIB.ChargeTobRegles;
{---------------------------------------------------------------------------------------}
begin
  {Mise � jour de la tob des r�gles d'accrochage}
  TobRegle.ClearDetail;
  TobRegle.LoadDetailFromSQL('SELECT * FROM REGLEACCRO');
end;

{Bouton d'acc�s au param�trage des r�gles d'accrochage
{---------------------------------------------------------------------------------------}
procedure TOF_TRMULCIB.BRegleClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  {Appel de l'�cran de param�trage}
  TRLanceFiche_ParamRegleAccro('TR', 'TRFICHEACCROCHAGE', '', '', '');
  {On recharge la tob contenant les r�gles}
  ChargeTobRegles;
  {Rafra�chissement de la tablette dans le mul}
  THValComboBox(GetControl('TCI_REGLEACCRO')).Reload;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULCIB.MajAccrochage(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  if TRLanceFiche_AccroCib then
    TFMul(Ecran).BCherche.Click;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULCIB.MajRegle;
{---------------------------------------------------------------------------------------}
var
  Code   : string;
  CurTob : TOB;
begin
  {R�cup�ration de la r�gle d'erreur}
  Code := VarToStr(GetField('TCI_REGLEACCRO'));
  {On recherche dans la table la valeur des champs de la r�gle choisie}
  CurTob := TobRegle.FindFirst(['TRG_REGLEACCRO'], [Code], False);
  {Si la r�le n'a pas �t� trouv�e, on met tous les champs � False}
  if CurTob = nil then begin
    chkDateOpe.Checked := False;
    chkDateVal.Checked := False;
    chkMontant.Checked := False;
    chkPiece  .Checked := False;{14/07/08 : FQ 21248}
  end

  else begin
    {On affecte les champs de la fiche}
    chkDateOpe.Checked := CurTob.GetValue('TRG_BDATEOPE') = 'X';
    chkDateVal.Checked := CurTob.GetValue('TRG_BDATEVAL') = 'X';
    chkMontant.Checked := CurTob.GetValue('TRG_BMONTANT') = 'X';
    chkPiece  .Checked := CurTob.GetValue('TRG_BPIECE'  ) = 'X';{14/07/08 : FQ 21248}
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULCIB.OnClose;
{---------------------------------------------------------------------------------------}
begin
  inherited;
  if Assigned(TobRegle) then FreeAndNil(TobRegle);
end;

initialization
  RegisterClasses([TOF_TRMULCIB]);

end.
