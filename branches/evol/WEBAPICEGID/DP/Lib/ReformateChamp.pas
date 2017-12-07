{***********UNITE*************************************************
Auteur  ...... : BM
Cr�� le ...... : 26/11/2002
Modifi� le ... :   /  /
Description .. : Proc�dure de d�doublonnage
Mots clefs ... :
*****************************************************************}

unit ReformateChamp;

interface

{*****************************************************************
// Ent�te de proc�dures et fonctions
*****************************************************************}

procedure InitFormats( sCarDebut_p, sCarMixte_p, sCarFin_p, sCarTous_p, sLesSigles_p : string );
procedure RazFormats;
function  ReformateChaine( sChaine_p : string ) : string;
function  SupLesCaract( sChaine_p : string ) : string;
function  SupCaract( sChaine_p, sCarListe_p : string; nMode_p : integer ) : string;
function  DepLesSigles( sChaine_p : string ) : string;
function  CouperSigle( var sChaine_p, sSigAColler_p : string; sSigle_p : string ) : integer;
function  CollerSigle( sChaine_p, sSigle_p : string ) : string;

{*****************************************************************
// Variables et constantes
*****************************************************************}
type typFormats = class
   csCarDebut_g : string;
   csCarMixte_g : string;
   csCarFin_g   : string;
   csCarTous_g  : string;
   csLesSigles_g : string;
end;

const
   csDebut_g = 1;
   csMixte_g = 2;
   csTous_g  = 3;
   csFin_g   = 4;

var csFormats_g : typFormats;

{*****************************************************************
*****************************************************************}

implementation

uses
{$IFNDEF EAGLCLIENT}
{$ELSE}
{$ENDIF}
SysUtils, hCtrls;

{*****************************************************************
Auteur ....... : BM
Date ......... : 28/11/02
Fonction ..... : InitFormats
Description .. : Initialise les caract�res et sigles � traiter
Param�tres ... : La liste des caract�res � supprimer au d�but de la cha�ne
                 La liste des caract�res � supprimer au d�but et � la fin de la cha�ne
                 La liste des caract�res � supprimer � la fin de la cha�ne
                 La liste des caract�res � supprimer sur toute la cha�ne
                 La liste des sigles � reporter � la fin de la cha�ne (s�par�s par ";")
*****************************************************************}
procedure InitFormats( sCarDebut_p, sCarMixte_p, sCarFin_p, sCarTous_p, sLesSigles_p : string );
begin
   csFormats_g := typFormats.Create;
   csFormats_g.csCarDebut_g := sCarDebut_p;
   csFormats_g.csCarMixte_g := sCarMixte_p;
   csFormats_g.csCarFin_g   := sCarFin_p;
   csFormats_g.csCarTous_g  := sCarTous_p;
   csFormats_g.csLesSigles_g := sLesSigles_p;
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 26/11/02
Proc�dure .... : RazFormats
Description .. : Lib�re la m�moire
Param�tres ... :
*****************************************************************}
procedure RazFormats;
begin
   csFormats_g.Free;
end;
{*****************************************************************
Auteur ....... : BM
Date ......... : 26/11/02
Fonction ..... : ReformateChaine
Description .. : Op�rations de d�doublonnage : les caract�res " -_.", les sigles
Param�tres ... : La chaine � traiter
Renvoie ...... : La chaine trait�
*****************************************************************}
function ReformateChaine( sChaine_p : string ) : string;
begin
   sChaine_p := SupLesCaract( sChaine_p );
   sChaine_p := DepLesSigles( sChaine_p );
   result := sChaine_p;
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 26/11/02
Fonction ..... : SupLesCaract
Description .. : Supprime les caract�res "csFormats_g.csCarDebut_g" en d�but de cha�ne
                 et tous les caract�res "csFormats_g.csCarTous_g" de la cha�ne, ...
Param�tres ... : La chaine � traiter
Renvoie ...... : La chaine trait�e
*****************************************************************}
function  SupLesCaract( sChaine_p : string ) : string;
begin
   sChaine_p := SupCaract( sChaine_p, csFormats_g.csCarTous_g,  csTous_g );
   sChaine_p := SupCaract( sChaine_p, csFormats_g.csCarFin_g,   csFin_g );
   sChaine_p := SupCaract( sChaine_p, csFormats_g.csCarMixte_g, csMixte_g );
   sChaine_p := SupCaract( sChaine_p, csFormats_g.csCarDebut_g, csDebut_g );
   result := sChaine_p;
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 26/11/02
Fonction ..... : SupCaract
Description .. : Recherche et supprime un caract�re dans une cha�ne
Param�tres ... : La chaine � traiter, le caract�re � supprimer, le mode de traitement
Renvoie ...... : La chaine trait�
*****************************************************************}
function SupCaract( sChaine_p, sCarListe_p : string; nMode_p : integer ) : string;
var
   nStrPos_l, nCarPos_l : integer;
   bLettre_l : boolean;
begin
   if sCarListe_p = '' then
   begin
      result := sChaine_p;
      exit;
   end;
   // Tous les caract�res de la chaine
   if nMode_p = csTous_g then
   begin
      for nCarPos_l := 1 to length(sCarListe_p) do
         sChaine_p := StringReplace( sChaine_p, sCarListe_p[nCarPos_l], '', [rfReplaceAll, rfIgnoreCase]);
   end
   else
   begin
      // Les caract�res de d�but de chaine
      if nMode_p < csFin_g then
      begin
         nStrPos_l := 1;
         bLettre_l := false;
         while( not bLettre_l )  and (nStrPos_l <= Length(sChaine_p)) do
         begin
            nCarPos_l := 1;
            while ( sChaine_p[nStrPos_l] <> sCarListe_p[nCarPos_l] ) and
                  ( nCarPos_l <= length(sCarListe_p) ) do
               inc(nCarPos_l);

            if ( nCarPos_l <= length(sCarListe_p) ) then
               inc(nStrPos_l)
            else
               bLettre_l := true;
         end;
         sChaine_p := Copy(sChaine_p, nStrPos_l, Length(sChaine_p));
      end;
      // Les caract�res de fin de chaine
      if nMode_p >= csMixte_g then
      begin
         nStrPos_l := Length(sChaine_p);
         bLettre_l := false;
         while( not bLettre_l ) and (nStrPos_l >= 1) do
         begin
            nCarPos_l := 1;
            while ( sChaine_p[nStrPos_l] <> sCarListe_p[nCarPos_l] ) and
                  ( nCarPos_l <= length(sCarListe_p) ) do
               inc(nCarPos_l);

            if ( nCarPos_l <= length(sCarListe_p) ) then
               dec(nStrPos_l)
            else
               bLettre_l := true;
         end;
         sChaine_p := Copy(sChaine_p, 1, nStrPos_l );
      end;
   end;
   result := sChaine_p;
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 26/11/02
Fonction ..... : DepLesSigles
Description .. : Recherche les sigles dans une cha�ne et le d�place � la fin
Param�tres ... : La chaine � traiter
Renvoie ...... : La chaine trait�
*****************************************************************}
function  DepLesSigles( sChaine_p : string ) : string;
var
   tsSigle_l : array of string;
   sSigListe_l, sSigAColler_l : string;
   nSigNb_l, nAncNb_l, nNouNb_l : integer;
   bFinOk_l : boolean;
begin
   sSigListe_l := csFormats_g.csLesSigles_g;

   if sSigListe_l = '' then
   begin
      result := sChaine_p;
      exit;
   end;

   nSigNb_l := 0;
   while (sSigListe_l <> '') do
   begin
      SetLength(tsSigle_l, nSigNb_l + 1);
      tsSigle_l[nSigNb_l] := READTOKENST( sSigListe_l);
      nSigNb_l := nSigNb_l + 1;
   end;

   bFinOk_l := false;
   sSigAColler_l := '';
   nAncNb_l := 0;
   nNouNb_l := 0;
   while( not bFinOk_l ) do
   begin
      nSigNb_l := 0;
      while ( nSigNb_l < length(tsSigle_l) ) do
      begin
         nNouNb_l := CouperSigle( sChaine_p, sSigAColler_l, tsSigle_l[nSigNb_l] ) + 1;
         inc(nSigNb_l);
      end;

      bFinOk_l := (nAncNb_l = nNouNb_l);
      nAncNb_l := nNouNb_l;
   end;

   sChaine_p := CollerSigle( sChaine_p, sSigAColler_l );
   result := sChaine_p;
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 26/11/02
Fonction ..... : CouperSigle
Description .. : Recherche les sigles dans une cha�ne et l'en supprime
Param�tres ... : La chaine � traiter, la liste des sigles d�j� coup�s, le sigle � supprimer
Renvoie ...... : 0 si aucun sigle coup�, 1 sinon
*****************************************************************}
function  CouperSigle( var sChaine_p, sSigAColler_p : string; sSigle_p : string ) : integer;
var
   sChaine_l, sSigle_l : string;
begin
   result := 0;
   if Pos( '''', sSigle_p ) = 0 then
   begin
      sSigle_l := UpperCase(sSigle_p) + ' ';
      sChaine_l := UpperCase(Copy( sChaine_p, 1, length(sSigle_p) + 1));
   end
   else
   begin
      sSigle_l := UpperCase(sSigle_p);
      sChaine_l := UpperCase(Copy( sChaine_p, 1, length(sSigle_p)));
   end;
   if sChaine_l = sSigle_l then
   begin
      if sSigAColler_p <> '' then
         sSigAColler_p := sSigAColler_p + ' ';
      sSigAColler_p := sSigAColler_p + Copy( sChaine_p, 1, length(sSigle_p) );
      sChaine_p := Copy( sChaine_p, length(sSigle_l) + 1, length(sChaine_p) );
      sChaine_p := SupCaract( sChaine_p, ' ', csDebut_g );
      result := 1;
   end;
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 26/11/02
Fonction ..... : CollerSigle
Description .. : Colle la liste des sigles � la fin de la cha�ne
Param�tres ... : La chaine � traiter, la liste des sigles
Renvoie ...... : La chaine trait�
*****************************************************************}
function  CollerSigle( sChaine_p, sSigle_p : string ) : string;
begin
   if sSigle_p <> '' then
      sChaine_p := sChaine_p + ' (' +  sSigle_p + ')';
   result := sChaine_p;
end;

end.
