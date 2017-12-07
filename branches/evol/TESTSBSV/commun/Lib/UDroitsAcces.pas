{***********UNITE*************************************************
Auteur  ...... : MD3
Cr�� le ...... : 27/06/2008
Modifi� le ... :   /  /
Description .. : Stockage en m�moire de l'association entre un tag menu et
Suite ........ : un droit d'acc�s sur les concepts de la DB0 (menu 187).
Suite ........ : Bien penser � purger le tableau en cas de modification des
Suite ........ : droits.
Suite ........ : Rq : la fonction AGL "JaiLeDroitTag" est d�j� bufferis�e
Suite ........ : dans un tableau en m�moire.
Mots clefs ... :
*****************************************************************}
unit UDroitsAcces;

interface

uses
  SysUtils,
{$IFDEF EAGLCLIENT}
  UTob,
{$ELSE}
 {$IFNDEF DBXPRESS} dbtables, {$ELSE}uDbxDataSet, {$ENDIF}
{$ENDIF EAGLCLIENT}
  HCtrls,
  HEnt1;

Type
  TDroitAcces = Record
                    NumTag        : Integer;
                    DroitAcces    : Boolean;
                   end;

Var TabDroitAcces : Array of TDroitAcces;

function  JaiLeDroitAccesDB0 (Const NumTag : Integer) : Boolean;
function  JaiLeDroitTagDB0 (NumTag: Integer) : Boolean;
procedure PurgeDroitsAccesDB0;

// Liste de concepts en DB0
const
  // Annuaire
  ccCreatAnnuaireOuLiens       = 187001 ;
  ccSupprAnnuaireOuLiens       = 187002 ;
  ccModifAnnuaireOuLiens       = 187003 ;
  ccVoirLesLiens               = 187004 ;
  ccParamListeAnnuaire         = 187005 ;
  ccListesAnnSimplifiees       = 187006 ;
  ccModifAnnuaireDossier       = 187007 ; // FQ 11371 nouveau concept pour autoriser les modifs annuaire du dossier en cours

  // Compta
  ccAccesGlobalCompta          = 187100 ;

  // Applications h�berg�es
  ccParamApplisHebergees       = 187200 ;
  ccActiverDossierAsp          = 187205 ;
  ccBusinessLineDepuisSynthese = 187210 ;
  ccEwsDepuisSynthese          = 187215 ;
  ccPubliEwsDepuisSynthese     = 187220 ;
  ccOutilsAssistanceAsp        = 187225 ;
  ccGedAssociationBrancheEws   = 187230 ;

  // GED
  ccSupprimerDocument          = 187300 ;
  ccExtraireDocument           = 187305 ;
  ccConsulterDocumentAutre     = 187310 ;
  ccIntegrerDocument           = 187315 ;
  ccModifierDocument           = 187320 ;

  // Messagerie
  ccSupprimerMessage           = 187400;

  // CTI
  ccUtilisationCTI             = 186000 ;

  // Divers
  ccGroupeTravailAffect        = 26052 ;
  ccCreationDossier            = 26053 ;
  ccGestionMotPasse            = 26055 ;
  ccBlocageDossier             = 26056 ;
  ccAccesDossierSansPWD        = 26058 ;

implementation

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : MD3
Cr�� le ...... : 01/07/2008
Modifi� le ... :   /  /    
Description .. : Interroge les droits d'acc�s en m�moire (en priorit�),
Suite ........ : ou compl�te le tableau des droits (si tag inconnu).
Suite ........ : bTagDB0 permet d'interroger les droits sur la DB0
Suite ........ : m�me si on est connect� � un dossier.
Mots clefs ... : 
*****************************************************************}
function JaiLeDroitAccesDB0 (Const NumTag : Integer) : Boolean;
var Indice, LgTabAcces : Integer;
    bTagTrouve : Boolean;
begin
 Result     := False;
 LgTabAcces := Length(TabDroitAcces);
 bTagTrouve := False;

 // Interroger le tableau
 for Indice := 0 to LgTabAcces-1 do
 begin
   if (TabDroitAcces[Indice].NumTag = NumTag) then
   begin
     Result := TabDroitAcces[Indice].DroitAcces;
     bTagTrouve := True;
     break;
   end;
 end;

 // Compl�ter le tableau
 if Not bTagTrouve then
 begin
   SetLength(TabDroitAcces, LgTabAcces+1);
   TabDroitAcces[LgTabAcces].NumTag := NumTag;
   TabDroitAcces[LgTabAcces].DroitAcces := JaiLeDroitTagDB0(NumTag);
   Result := TabDroitAcces[LgTabAcces].DroitAcces;
 end;
end;

{***********UNITE***********************************************
Auteur  ...... : MD
Cr�� le ...... : 28/11/2003
Modifi� le ... :   /  /
Description .. : Examine les droits sur le n� de tag
Suite ........ : de la branche 187 (Concepts bureau).
Suite ........ : Le test se fait dans la base commune.
Suite ........ : Retourne True si droit ok, False sinon.
Mots clefs ... : CONCEPT;BUREAU;DROITS
*****************************************************************}
function JaiLeDroitTagDB0(NumTag: Integer): Boolean;
// cf JaiLeDroiTag dans HCtrls
var
  St: string;
  Q: TQuery;
  i: integer;
begin
  Result := False;

  Q := OpenSQL('SELECT MN_ACCESGRP FROM '
    + '##DP##.MENU WHERE MN_TAG=' + IntToStr(NumTag) + ' AND MN_LIBELLE <> "-"', True, -1, '', True);
  while not Q.EOF do
  begin
    St := Q.FindField('MN_ACCESGRP').AsString;
    if St = '' then continue;
    Result := St[V_PGI.UserGrp] = '0';
    if Result then break
    else
    // Recherche dans les groupes d�l�gu�s.
      for i := Low(V_PGI.FUserGrps) to High(V_PGI.FUserGrps) do
      begin
        Result := St[V_PGI.FUserGrps[i]] = '0';
        if Result then break;
      end;
    Q.Next;
  end;
  Ferme(Q);
end;

{***********A.G.L.***********************************************
Auteur  ...... : MD3
Cr�� le ...... : 01/07/2008
Modifi� le ... :   /  /    
Description .. : Pensez � utiliser cette fonction pour purger les droits
Suite ........ : d'acc�s en m�moire, si vous les avez modifi� d'une
Suite ........ : par programme (via une fiche comme YYUSERGROUP...)
Mots clefs ... :
*****************************************************************}
procedure PurgeDroitsAccesDB0;
begin
  SetLength(TabDroitAcces, 0);
end;

end.
