{***********UNITE*************************************************
Auteur  ...... : PH
Cr�� le ...... : 08/01/2002
Modifi� le ... : 08/01/2002
Description .. : Unit de d�finition de fonctions g�n�riques
Mots clefs ... : PAIE; PGDUCSEDI
*****************************************************************}
{ Il faut definir TENVOI : TOB dans l'unit� qui appelle les fonctions
PT1   : 01/02/2002 VG V571 Fonction de suppression d'un �l�ment de la table
                           ENVOISOCIAL
PT2   : 28/03/2002 VG V571 Modification de la fonction de cr�ation
                           d'enregistrement dans la table ENVOISOCIAL
PT3   : 08/08/2002 MF V585  PGDUCSEDI
                           1- traitement des nouveaux champs de la
                           table ENVOISOCIAL code apllication et serbveur unique
                           2- traitement des nouveaux champs de la
                           table ENVOISOCIAL montant pay�, ducs n�ant et mode
                           de r�glement
// **** Refonte acc�s V_PGI_env ***** V_PGI_env.nodossier remplac� par PgRendNoDossier() *****
PT4   : 23/09/2003 MF V_421 FQ 10829 : pour les envois DUCS s�lection possible
                             de l'�metteur.
PT5   : 03/10/2003 MF V_421 FQ 10872 : initialisation Du nom du fichier �mis
PT6   : 11/04/2007 MF V_702 Modifs Mise en base des fichiers Ducs EDI
}
unit Pg_OutilsEnvoi;

interface

Uses  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
      StdCtrls,Hent1,HCtrls,HMsgBox,ComCtrls,UTOB;

Type TEnvoiSocial = record
     Ordre : integer;
     TypeE : string;
     Millesime : string;
     Periodicite : string;
     DateD : TDateTime;
     DateF : TDateTime;
     Inst : string;
     Siret : string;
     Fraction : string;
     Libelle : string;
     Size : Double;
     NomFic : string;
     Statut : string;
     Monnaie : string;
     CodAppli : string;   // PT3-1
     ServUniq : boolean;  // PT3-1
     MtPaye : double;     // PT3-2
     DucsNeant : boolean; // PT3-2
     ModReglt : string;   // PT3-2
     EmettSoc : string;   // PT4
     Guid1    : string;   // PT6
end;

var     TENVOI : TOB ;

procedure LibereTOBENVOI ;
procedure ChargeTOBENVOI;
procedure CreeEnvoi (Envoi : TEnvoiSocial);
procedure SupprEnvoi (TypeE, Millesime : string; DateDeb, DateFin : TDateTime;
          SIRETDO, Fract, Monnaie : string);


implementation
{$IFNDEF COMPTA}
uses PgOutils2;
{$ENDIF}
{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 23/10/2001
Modifi� le ... :
Description .. : Lib�ration de la TOB destination utilis�es pour
Suite ........ : la cr�ation d'un enregistrement ENVOISOCIAL
Mots clefs ... : PAIE,PGDADSU
*****************************************************************}
procedure LibereTOBENVOI;
begin
TENVOI.SetAllModifie (TRUE);
TENVOI.InsertOrUpdateDB(FALSE);
TENVOI.Free;
TENVOI := nil;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 23/10/2001
Modifi� le ... :   /  /
Description .. : Chargement de TOB des enregistrements ENVOISOCIAL
Mots clefs ... : PAIE,PGDADSU
*****************************************************************}
procedure ChargeTOBENVOI;
begin
TENVOI := TOB.Create('M�re Envoi', nil, -1);
end;


//PT2
{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 23/10/2001
Modifi� le ... :   /  /
Description .. : Cr�ation d'un �l�ment ENVOISOCIAL dans la TOB associ�e
Mots clefs ... : PAIE,PGDADSU
*****************************************************************}
procedure CreeEnvoi (Envoi : TEnvoiSocial);
var
TENVOID : Tob;
begin
TENVOID:=TOB.Create ('ENVOISOCIAL', TENVOI, -1);
TENVOID.PutValue('PES_CHRONOMESS', Envoi.Ordre);
TENVOID.PutValue('PES_TYPEMESSAGE', Envoi.TypeE);
TENVOID.PutValue('PES_MILLESSOC', Envoi.Millesime);
TENVOID.PutValue('PES_PGPERIODICITE', Envoi.Periodicite);
TENVOID.PutValue('PES_DATEDEBUT', Envoi.DateD);
TENVOID.PutValue('PES_DATEFIN', Envoi.DateF);
TENVOID.PutValue('PES_INSTITUTION', Envoi.Inst);
TENVOID.PutValue('PES_SIRETDO', Envoi.Siret);
TENVOID.PutValue('PES_FRACTIONDADS', Envoi.Fraction);
TENVOID.PutValue('PES_LIBELLE', Envoi.Libelle);
TENVOID.PutValue('PES_DATECREATION', Date);
TENVOID.PutValue('PES_CREERPAR', V_PGI.User);
TENVOID.PutValue('PES_TAILLEFIC', Envoi.Size);
TENVOID.PutValue('PES_FICHIERRECU', Envoi.NomFic);
TENVOID.PutValue('PES_STATUTENVOI', Envoi.Statut);
// **** Refonte acc�s V_PGI_env ***** V_PGI_env.nodossier remplac� par PgRendNoDossier() *****
{$IFDEF COMPTA}
  if V_PGI.NoDossier <> '' then
    TENVOID.PutValue('PES_NUMDOSSIER', V_PGI.NoDossier)
  else
    TENVOID.PutValue('PES_NUMDOSSIER', '000000');
{$ELSE}
  TENVOID.PutValue('PES_NUMDOSSIER', PgRendNoDossier() );
{$ENDIF}
TENVOID.PutValue('PES_MONNAIEDECL', Envoi.Monnaie);
//d PT3-1
TENVOID.PutValue('PES_CODAPPLI', Envoi.CodAppli);
if  (Envoi.ServUniq = True) then
  TENVOID.PutValue('PES_SERVUNIQ', 'X')
else
  TENVOID.PutValue('PES_SERVUNIQ', '-');
// f PT3-1
// d PT3-2
TENVOID.PutValue('PES_MTPAYER', Envoi.MtPaye);
if (Envoi.ducsNeant = true) then
  TENVOID.PutValue('PES_NEANT', 'X')
else
  TENVOID.PutValue('PES_NEANT', '-');
  TENVOID.PutValue('PES_PAIEMODE', Envoi.ModReglt);
// f PT3-2
TENVOID.PutValue('PES_EMETSOC', Envoi.EmettSoc); // PT4
TENVOID.PutValue('PES_FICHIEREMIS',''); // PT5

TENVOID.PutValue('PES_GUID1',Envoi.Guid1); // PT6
end;
//FIN PT2


//PT1
{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 01/02/2002
Modifi� le ... :   /  /
Description .. : Suppression des �l�ments ENVOISOCIAL
Mots clefs ... : PAIE,PGDADSU
*****************************************************************}
procedure SupprEnvoi (TypeE, Millesime : string; DateDeb, DateFin : TDateTime;
          SIRETDO, Fract, Monnaie : string);
var
StDelete : string;
begin
StDelete := 'DELETE FROM ENVOISOCIAL WHERE'+
            ' PES_TYPEMESSAGE = "'+TypeE+'" AND '+
            ' PES_MILLESSOC = "'+Millesime+'" AND'+
            ' PES_PGPERIODICITE = "A" AND'+
            ' PES_DATEDEBUT = "'+UsDateTime(DateDeb)+'" AND'+
            ' PES_DATEFIN = "'+UsDateTime(DateFin)+'" AND'+
            ' PES_SIRETDO = "'+SIRETDO+'" AND'+
            ' PES_FRACTIONDADS = "'+Fract+'" AND'+
            ' PES_MONNAIEDECL = "'+Monnaie+'"';
ExecuteSQL(StDelete) ;

end;
//FIN PT1


end.
