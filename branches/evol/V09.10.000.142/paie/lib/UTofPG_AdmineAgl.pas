{***********UNITE*************************************************
Auteur  ...... : PH
Cr�� le ...... : 14/06/2001
Modifi� le ... :   /  /
Description .. : Unit administration de la base Saisie d�port�e
Mots clefs ... : PAIE;ABSENCES;PGDEPORTEE
*****************************************************************
PT1 28/10/2002 V585 On ne doit pas tenir compte du champ pcn_validsalarie pour l'export des donn�es
PT2 05/12/2002 V591 SB Etat des mouvements export�s modifi�s
}
unit UtofPG_AdmineAgl;

interface
uses  StdCtrls,Controls,Classes,HTB97,HCtrls,HMsgBox,UTOF,ParamSoc;



Type
     tof_PG_AdmineAgl = Class (TOF)
       private
       procedure BValideClick(Sender: TObject);
       public
       procedure OnArgument(Arguments : String ) ; override ;
     END ;
implementation


procedure tof_PG_AdmineAgl.OnArgument(Arguments: String);
var B : Ttoolbarbutton97;
begin
B := Ttoolbarbutton97(getcontrol('Bvalider'));
if B <> nil then
   B.onclick := BValideClick;
end;

procedure tof_PG_AdmineAgl.BValideClick(Sender: TObject);
var RBTN : TRadioButton;
    rep : Integer;
begin
RBTN := TRadioButton(GetControl ('RBTNABS'));
if RBTN <> NIL then
   begin // On revalide pour l'export vers la base de production les absences export�es
   if RBTN.Checked = TRUE then
    begin
    Rep := PGIAsk ('Cette proc�dure doit �tre utilis�e uniquement pour r�activer #13#10 '+
               'Les absences export�es dont la r�cup�ration n''a pas �t� faite', Ecran.Caption);
    if rep = MrOk then       //PT2 Les mouvements export�s sont top�s ENC et non plus "X", recap fauss�
     ExecuteSQL ('UPDATE ABSENCESALARIE SET PCN_EXPORTOK = "-" WHERE PCN_SAISIEDEPORTEE = "X" '+
     'AND PCN_VALIDRESP = "VAL" AND PCN_EXPORTOK = "ENC"'); {PT1 mise en commentaire PCN_VALIDSALARIE = "VAL" AND}
    end;
   end;
RBTN := TRadioButton(GetControl ('RBTNBLOQ'));
if RBTN <> NIL then
   begin // On bloque l'acc�s � la base car on est en train de faire un export
   if RBTN.Checked = TRUE then SetParamSoc('SO_PGBASEEPAIE','-');
   end;
RBTN := TRadioButton(GetControl ('RBTNBLOQ'));
if RBTN <> NIL then
   begin // On d�bloque l'acc�s � la base
   if RBTN.Checked = TRUE then SetParamSoc('SO_PGBASEEPAIE','X');
   end;
end;

Initialization
registerclasses([tof_PG_AdmineAgl]);
end.
