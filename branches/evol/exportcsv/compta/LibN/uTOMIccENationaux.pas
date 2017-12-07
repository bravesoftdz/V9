{***********UNITE*************************************************
Auteur  ...... : COSTE Gilles
Cr�� le ...... : 22/02/2001
Modifi� le ... : 22/02/2001
Description .. : Source TOM de la TABLE : ICCELTNAT (ICCELTNAT)
Mots clefs ... : TOM;ICCELTNAT
*****************************************************************}
Unit uTOMIccENationaux ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFDEF EAGLCLIENT}
     MaineAGL,  // AGLLanceFiche
{$ELSE}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     FE_Main,   // AGLLanceFiche
     DbGrids,
{$ENDIF}
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTob,
     UTom,
     IccGlobale,
     Htb97,
     Windows,
     Ent1;

procedure CPLanceFiche_ICCPARAMELEMNAT(psz1,psz2 : String);

Type
  TOM_ICCELTNAT = Class (TOM)
    procedure OnNewRecord                ; override ;
    procedure OnDeleteRecord             ; override ;
    procedure OnUpdateRecord             ; override ;
    procedure OnArgument ( S: String )   ; override ;

    procedure OnKeyDownEcran(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    StdCegidOk : Boolean;
  public

    BInsert, BDelete : TToolBarButton97;
  end;

Implementation

uses
  {$IFDEF MODENT1}
  CPVersion,
  {$ENDIF MODENT1}
  uLibWindows;

procedure CPLanceFiche_ICCPARAMELEMNAT(psz1,psz2 : String);
begin
  AGLLanceFiche('CP','ICCFICELTNAT', '', psz1, psz2);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 14/09/2001
Modifi� le ... : 14/09/2001
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOM_ICCELTNAT.OnArgument ( S: String ) ;
begin
  Inherited ;
  StdCegidOk :=  EstSpecif('51502');

  BInsert := TToolBarButton97(GetControl('BInsert'));
  BDelete := TToolBarButton97(GetControl('BDelete'));
  Ecran.OnKeyDown := OnKeyDownEcran;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 21/11/2001
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOM_ICCELTNAT.OnKeyDownEcran(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_INSERT : BInsert.Click;
    VK_DELETE : if Shift = [ssCtrl] then BDelete.Click;
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 14/09/2001
Modifi� le ... : 14/09/2001
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOM_ICCELTNAT.OnNewRecord ;
begin
  Inherited ;
{$IFNDEF EAGLCLIENT}
  Ecran.ActiveControl := THDBValComboBox(GetControl('ICN_CODETXMOYEN'));
{$ELSE}
  Ecran.ActiveControl := THValComboBox(GetControl('ICN_CODETXMOYEN'));
{$ENDIF}
  SetField('ICN_CODETXMOYEN','0');
  SetField('ICN_DATEVALEUR',Date);
  SetField('ICN_PREDEFINI',IIF(StdCegidOk,'CEG','STD'));
  SetField('ICN_CODETXMOYEN','N02');
  SetField('ICN_ETATICC', 'PRO');
end ;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 14/09/2001
Modifi� le ... : 14/09/2001
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOM_ICCELTNAT.OnDeleteRecord ;
begin
  Inherited;
  if (not StdCegidOk) and (GetField('ICN_PREDEFINI') = 'CEG') then
  begin
    LastError := -1;
    LastErrorMsg := 'Vous ne pouvez pas supprimer un enregistrement CEGID';
    Abort;
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 14/09/2001
Modifi� le ... : 14/09/2001
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOM_ICCELTNAT.OnUpdateRecord ;
begin
  if not StdCegidOk then
  begin
    if GetField('ICN_PREDEFINI') = 'CEG' then
    begin
      LastError := -1;
      LastErrorMsg := 'Vous ne pouvez pas modifier un enregistrement CEGID.';
    end;
  end;

  if GetField('ICN_TXMOYEN') <= 0 then
  begin
    LastError := -1;
    LastErrorMsg := 'Le taux de l''�lement national doit �tre sup�rieur � 0.';
  end;

  if GetField('ICN_TXMOYEN') >= 100 then
  begin
    LastError := -1;
    LastErrorMsg := 'Le taux de l''�l�ment national doit �tre inf�rieur � 100.';
  end;

  Inherited ;
end ;

Initialization
  registerclasses ( [ TOM_ICCELTNAT ] ) ;
end.
