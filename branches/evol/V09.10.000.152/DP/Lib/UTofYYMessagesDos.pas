{***********UNITE*************************************************
Auteur  ...... : MD
Cr�� le ...... : 18/06/2003
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : YYMESSAGESDOS_MUL
Mots clefs ... : TOF;YYMESSAGESDOS
*****************************************************************}
Unit UTofYYMessagesDos ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFDEF EAGLCLIENT}
     MenuOlx,
{$ELSE}
     MenuOlg,
{$ENDIF}
     HDB,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOF,
     AGLInit,
     UTofYYMessagesParent,
     YNewMessage,
     menus,
     UMailBox,
     UtilMessages,
     HTB97;

Type
  TOF_YYMESSAGESDOS = Class (TOF_YYMESSAGESPARENT)
    procedure OnArgument (S : String ) ; override ;
  private
    procedure FLISTE_OnDblClick(Sender: TObject);
  end;

Implementation

uses
    UDossierSelect,

    {$IFDEF VER150}
    Variants,
    {$ENDIF}

    YMessage, galOutil;


//-------------------------------------
//--- Nom : OnArgument
//-------------------------------------
procedure TOF_YYMESSAGESDOS.OnArgument (S : String ) ;
begin
 Inherited ;
 iMessagerieEnCours := cMsgBoiteReception; // pour tof anc�tre

 //--- On examine uniquement les messages du dossier en cours
 SetControlText('YMS_NODOSSIER', VH_Doss.NoDossier);

 //--- Pour s�lection vide si pas de dossier en cours
 if VH_Doss.NoDossier='' then SetControlText('XX_WHERE', 'AND 1=0');

 //--- Par d�faut, on voit les messages class�s
 TCheckBox(GetControl('YMS_TRAITE')).State := cbChecked;

 //--- Oubli dans la fiche
{$IFDEF EAGLCLIENT}
  THDBGrid(GetControl('FListe')).MultiSelect := True;
{$ELSE}
  THDBGrid(GetControl('FListe')).MultiSelection  := True;
{$ENDIF}

 THDBGrid(GetControl('FLISTE')).OnDblClick := FLISTE_OnDblClick;
end ;

//------------------------------
//--- NOM : FLISTE_OnDblClick
//------------------------------
procedure TOF_YYMESSAGESDOS.FLISTE_OnDblClick(Sender: TObject);
var sNoDossier : String;
begin
 if VarIsNull( GetField('YMS_MSGGUID') ) or ( GetField('YMS_MSGGUID')='' ) then exit;
 sNoDossier := ShowFicheMessage( GetField('YMS_MSGGUID'), False );

 // si on a modifi� le message...
 AGLRefreshDB([LongInt(Ecran), 'FListe'], 2);

 // si on a demand� l'acc�s � un dossier client :
 if sNoDossier <> '' then
  begin
   // s�lectionne le dossier demand�
   if Not LanceContexteDossier(sNoDossier) then exit;

   // Passe au module "Dossier client"
   FMenuG.LanceDispatch(76501);
  end;
end;


Initialization
  registerclasses ( [ TOF_YYMESSAGESDOS ] ) ;
end.

