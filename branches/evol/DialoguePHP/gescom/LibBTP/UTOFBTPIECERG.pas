{***********UNITE*************************************************
Auteur  ...... :
Cr�� le ...... : 29/11/2001
Modifi� le ... :   /  /
Description .. : Source TOF de la TABLE : BTPIECERG ()
Mots clefs ... : TOF;BTPIECERG
*****************************************************************}
Unit UTOFBTPIECERG ;

Interface

Uses StdCtrls, Controls, Classes,  forms, sysutils, ComCtrls,
     HCtrls, HEnt1, HMsgBox, UTOF,UTOB,SaisUtil,M3FP,ENt1,FacTRg,factcalc,
{$IFDEF EAGLCLIENT}
      MaineAgl,
{$ELSE}
      {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}db,Fe_Main, MajTable,
      banquecp,
{$ENDIF}
      Graphics,Dicobtp,HTB97,ENtGC,AGlInit,Math,ParamSoc;
Type
  TOF_BTPIECERG = Class (TOF)
  private
    TOBPiece,TOBPieceRG,TOBBases,TOBPorcs : TOB;
    TauxRg : ThNumedit;
    TypeRg : THValComboBox;
    NumCaution : Thedit;
    BanQue : ThValComboBox;
    NewBanque : TToolbarbutton97;
    MtCaution : ThNumedit;
    DEV : RDevise;
    PorcHt, PorcTTC : double;
    IsCompta : boolean;
    procedure ChangeTaux(Sender: Tobject);
    procedure ChangeType(Sender: Tobject);
    procedure ChangeBanque(Sender: Tobject);
    procedure ClickParamBanque(Sender: Tobject);
    procedure ChangeNumCaution(Sender: Tobject);
    procedure recalculeCaution;
    procedure reinitcaution;
    procedure ChangeMtCaution (Sender:TObject);
    procedure BCOTRAITClick (Sender : Tobject);
  public
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnClose                  ; override ;
  end ;

  const
	TexteMsgCompl: array[1..2] of string 	= (
          {1}        'Vous devez renseigner un type d''application',
          {2}        'Vous devez renseigner un Taux d''application'
            );

Implementation
uses UCotraitance;

procedure TOF_BTPIECERG.ChangeMtCaution (Sender:TObject);
begin
recalculeCaution;
end;

procedure TOF_BTPIECERG.reinitcaution;
begin
SetControlProperty('PRG_CAUTIONMTDEV','value',0);
SetControlProperty('PRG_CAUTIONMT','value',0);
end;

procedure TOF_BTPIECERG.recalculeCaution;
var XP,XC,XE : double;
    SaisieContre : boolean;
begin
SaisieContre := (laTob.getValue('PRG_SAISIECONTRE')='X');
CalculeMontantsAssocie (MtCaution.value,XP,DEV);
SetControlProperty('PRG_CAUTIONMT','value',XP);
end;

procedure TOF_BTPIECERG.OnDelete ;
begin
  Inherited ;
latob.initvaleurs;
if (LaTOB <> Nil) then TheTob := LaTOB ;
ecran.close;
end ;

procedure TOF_BTPIECERG.OnUpdate ;
begin
  Inherited ;

if TypeRg.Value = '' then
   begin
   PGIBoxAF(TexteMsgCompl[1],Ecran.Caption);
   SetFocusControl('PRG_TYPERG') ; TForm(Ecran).ModalResult:=0;
   Exit;
   end;
if TauxRg.Value = 0 then
   begin
   PGIBoxAF(TexteMsgCompl[2],Ecran.Caption);
   SetFocusControl('PRG_TAUXRG') ; TForm(Ecran).ModalResult:=0;
   Exit;
   end;
if ((IsCompta) and ((Banque.value = '') or (NumCaution.text = ''))) or
   (( not IsCompta) and (NumCaution.text = '')) then
   begin
   laTob.putvalue('PRG_CAUTIONMTDEV',0);
   laTob.putvalue('PRG_CAUTIONMT',0);
   end;
if (LaTOB <> Nil) then TheTob := LaTOB ;
end ;

procedure TOF_BTPIECERG.OnLoad ;
begin
  Inherited ;

PorcHt := CalculPort (true,TOBPorcs);
PorcTTC := CalculPort (false,TOBPorcs);
if LaTob.getValue('PRG_TYPERG')='' then
   begin
   SetControlProperty ('PRG_TYPERG','value','HT');
   end;
SetControlProperty('GP_TOTALHTDEV','value',TOBPiece.getvalue('GP_TOTALHTDEV') - PorcHt);
SetControlProperty('GP_TOTALTTCDEV','value',TOBPiece.getvalue('GP_TOTALTTCDEV') - PorcTTC);
if latob.getValue('PRG_TAUXRG') <> 0 then Setcontrolvisible('Bdelete',true);
if LaTob.getValue('PRG_TAUXRG')= 0 then
   begin
   SetControlProperty ('PRG_TAUXRG','value',5);
   ChangeTaux (self);
   end;
if (laTob.getvalue('PRG_NUMCAUTION') <> '' ) and (LaTob.getValue('PRG_BANQUECP')<>'') then
    begin
    Setcontrolenabled ('PRG_BANQUECP',false);
    Setcontrolenabled ('PRG_CAUTIONMTDEV',false);
    end;
end ;

procedure TOF_BTPIECERG.OnArgument (S : String ) ;
begin
  Inherited ;

  IsCompta := (not GetParamSocSecur('SO_GCDESACTIVECOMPTA',True));
  // Type de retenu de garantie
  TypeRg := THValComboBox (GetControl('PRG_TYPERG'));
  TypeRg.OnChange := ChangeType;
  // Pourcentage de retenue
  TauxRg := THNumEdit(GetControl('PRG_TAUXRG'));
  TauxRg.OnExit  := ChangeTaux;

  BanQue := THValComboBox (GetControl('PRG_BANQUECP'));
  NewBanque := TToolbarButton97 (getcontrol('BANQUEPARAM'));
  if IsCompta then
  begin
    // Code Banque pour la caution banquaire
    BanQue.OnChange := ChangeBanque;
    // Creation d'une nouvelle banque
    NewBanque.OnClick := ClickParamBanque;
  end;
  // Modif du Numero de caution
  Numcaution:= THedit(Getcontrol('PRG_NUMCAUTION'));
  Numcaution.onexit := ChangeNumcaution;
  // Modif Montant de caution
  MtCaution := THNumEdit(GetControl('PRG_CAUTIONMTDEV'));
  MTcaution.OnExit := ChangeMtCaution;
  // Mise en place de TOBPieceRG
  TOBPieceRG := TOB(LaTob);
  // Mise en place de TOBPiece
  TOBPiece := TOB(LaTob.Data );
  DEV.Code:=TOBPiece.GetValue('GP_DEVISE');
  // Mise en place de TOBBases
  TOBBases := TOB(TOBPiece.data);
  // Mise en Place des TOPorcs
  TOBPorcs := TOB(TOBBases.data);
  if (DEV.Code = '') then DEV.Code:=V_PGI.DevisePivot ;
  GetInfosDevise(DEV) ;
  SetControlText ('PRG_DEVISE',DEV.Symbole );
  SetControlText ('PRG_DEVISE1',DEV.Symbole );
  SetControlText ('PRG_DEVISE2',DEV.Symbole );
  if (not IsCompta) then
  begin
    Banque.visible := false;
    NewBanque.visible := false;
    SetControlEnabled ('PRG_NUMCAUTION',true);
    SetControlProperty ('PRG_NUMCAUTION','color',clWindow);
    SetControlProperty('PRG_CAUTIONMTDEV','value',ceil(TOBPIece.getValue('GP_TOTALTTCDEV')*(TauxRg.Value/100)));
    recalculeCaution;
  end;
  if not PieceTraitUsable then SetControlVisible ('BCOTRAIT',false)
  												else TToolbarButton97 (getcontrol('BCOTRAIT')).onClick := BCOTRAITClick;
end ;

procedure TOF_BTPIECERG.ChangeNumCaution (Sender:Tobject ) ;
begin
  if (Numcaution.Text  = '') then
  begin
  	Setcontrolenabled ('PRG_CAUTIONMTDEV',true);
  end else
  begin
  	Setcontrolenabled ('PRG_CAUTIONMTDEV',false);
  end;
  if not isCompta then
  begin
    if TypeRG.Value = 'HT' then
    begin
      PgiBox('On ne peut appliquer une caution bancaire que sur du TTC');
      NumCaution.text := '';
      exit;
    end;
    SetControlProperty('PRG_CAUTIONMTDEV','value',ceil(TOBPIece.getValue('GP_TOTALTTCDEV')*(TauxRg.Value/100)));
    recalculeCaution;
  end;
end;

procedure TOF_BTPIECERG.ClickParamBanque (Sender:Tobject ) ;
begin
//FicheBanqueCP ('',taModif,0);
end;

procedure TOF_BTPIECERG.ChangeTaux (Sender:Tobject ) ;
var XP,XE : double;
    SaisieContre : boolean;
begin
SaisieContre := (laTob.getValue('PRG_SAISIECONTRE')='X');
// Partie HT
SetControlProperty ('PRG_MTHTRGDEV','value',arrondi((TOBPIece.getValue('GP_TOTALHTDEV') - PorcHT)*(TauxRg.Value /100),DEV.decimale));
CalculeMontantsAssocie (THNumEdit(GetControl('PRG_MTHTRGDEV')).value,XP,DEV);
SetControlProperty('PRG_MTHTRG','value',XP);
// Partie TTC
SetControlProperty('PRG_MTTTCRGDEV','value',arrondi((TOBPIece.getValue('GP_TOTALTTCDEV') - PorcTTC)*(TauxRg.Value/100),DEV.decimale));
CalculeMontantsAssocie (THNumEdit(GetControl('PRG_MTTTCRGDEV')).value,XP,DEV);
SetControlProperty('PRG_MTTTCRG','value',XP);
// caution bancaire
if ((IsCompta) and  (Banque.Value <> '') and (numcaution.Text='')) or
   ((not IsCompta) and (NumCaution.text='')) then
   begin
   SetControlProperty('PRG_CAUTIONMTDEV','value',arrondi((TOBPIece.getValue('GP_TOTALTTCDEV') - PorcTTC)*(TauxRg.Value/100),0));
   recalculeCaution;
   end;
end;

procedure TOF_BTPIECERG.ChangeType (Sender:Tobject ) ;
begin
if TypeRG.Value ='TTC' then
   begin
   SetControlVisible ('GP_TOTALHTDEV',false);
   SetControlVisible ('PRG_MTHTRGDEV',false);
   SetControlVisible ('PRG_MTHTRG',false);

   SetControlVisible ('GP_TOTALTTCDEV',true);
   SetControlVisible ('PRG_MTTTCRGDEV',true);
   SetControlVisible ('PRG_MTTTCRG',true);
   end else
   begin
   if ( IsCOmpta and (Banque.Value <> '')) or ((not IsCompta) and (NumCaution.text<> ''))then
   begin
   	PgiBox('On ne peut appliquer une caution bancaire que sur du TTC');
    TypeRg.value := 'TTC';
    exit;
   end;
   SetControlVisible ('GP_TOTALHTDEV',true);
   SetControlVisible ('PRG_MTHTRGDEV',true);
   SetControlVisible ('PRG_MTHTRG',true);

   SetControlVisible ('GP_TOTALTTCDEV',false);
   SetControlVisible ('PRG_MTTTCRGDEV',false);
   SetControlVisible ('PRG_MTTTCRG',false);
   end;
end;

procedure TOF_BTPIECERG.ChangeBanque (Sender:Tobject ) ;
begin
if Banque.Value = '' then
   begin
   SetControlText ('PRG_NUMCAUTION','');
   SetControlEnabled ('PRG_NUMCAUTION',false);
   SetControlProperty ('PRG_NUMCAUTION','color',clbtnFace);
   reinitcaution;
   end else
   begin
   if TypeRG.Value <> 'TTC' then
   begin
   	PgiBox ('Le Type de retenue n''est pas d�fini en TTC');
    Banque.Value := '';
    exit;
   end;
   SetControlEnabled ('PRG_NUMCAUTION',true);
   SetControlProperty ('PRG_NUMCAUTION','color',clWindow);
   SetControlProperty('PRG_CAUTIONMTDEV','value',ceil(TOBPIece.getValue('GP_TOTALTTCDEV')*(TauxRg.Value/100)));
   recalculeCaution;
   end;
end;

procedure TOF_BTPIECERG.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BTPIECERG.BCOTRAITClick(Sender: Tobject);
begin
	//
end;

Initialization
  registerclasses ( [ TOF_BTPIECERG ] ) ;
end.

