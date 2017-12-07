{***********UNITE*************************************************
Auteur  ...... : Paie Pgi
Cr�� le ...... : 31/01/2005
Modifi� le ... :   /  /
Description .. : Stockage des proc�dures communes
Mots clefs ... : PAIE;OUTILS
*****************************************************************}
{
PT1   : 31/01/2005 SB V_60 Int�gration de proc. communes
PT2   : 11/07/2005 PH V_60 FQ 11337 On accepte les cumuls alphanum�riques
PT3   : 19/07/2005 SB V_65 Simplification de la function Collezerodevant
PT4   : 19/10/2005 VG V_60 Fonction SupprimeFichier d�plac�e dans PgOutils2
PT5   : 03/04/2006 VG V_65 Ajout fonction PaysISOLibEnvers
PT6   : 05/04/2006 VG V_65 Ajout fonction CalculCleSS
PT7   : 17/07/2006 VG V_70 Ajout fonction PGSupprimeaccent
PT8   : 04/09/2006 VG V_70 Fignolage contr�le du SIRET - FQ N�12076
PT9   : 02/10/2006 PH V_70 Mise en place des controles Paie 50
PT10  : 17/10/2006 VG V_70 Utilisation d'une proc�dure g�n�rique pour supprimer
                           les accents
PT10  : 22/05/2007 VG V_72 D�placement de la fonction TestNumeroSSNaissance
PT11  : 10/10/2007 VG V_80 Correction NODOSSIER en multi PME
PT12  : 31/03/2008 FC V_90 FQ 15310 La civilit� n'est pas mentionn�e uniquement pour les hommes
}
unit PgOutils2;

interface

uses SysUtils,
     HEnt1,
     math,
{$IFDEF EAGLCLIENT}
     UTOB,
{$ELSE}
     {$IFNDEF DBXPRESS}dbtables{BDE},{$ELSE}uDbxDataSet,{$ENDIF}
{$ENDIF}
     HCtrls,
     Controls,
     HMsgBox
     ;

procedure PgAffecteNoDossier ();
procedure ForceNumerique(Buf: string; var Resultat: string);
procedure MajEtabCompl;
function ControlSiret(NoSiret: string): Boolean;
function TestNumeroSS(numss: string; codesexe: string): integer;
function CalculCleSS(NumSS13 : string): integer;
function ColleZeroDevant(Nombre, LongChaine: integer): string;
function RendExerSocialPrec(var MoisE, AnneeE, ComboExer: string; var DebExer, FinExer: TDateTime; Exer: string): Boolean;
function AffectDefautCode(Edit: THedit; Long: integer): string;
function PGRendNoDossier(): string;
procedure ChargementTablette(Prefixe, Typ: string);
procedure InitialiseCombo(var Zone: Tcontrol);
function RendPeriodeEnCours(var ExerPerEncours, DebPer, FinPer: string): Boolean;
function RendExerSocialEnCours(var MoisE, AnneeE, ComboExer: string; var DebExer, FinExer: TDateTime): Boolean;
Function PgGetLibelleTablette(Var NomChamp,ValChamp,Tablette : string) : String;
function SupprimeFichier(FileN: string; Silence: Boolean = False): Boolean;
procedure PaysISOLib(Pays: string; var CodeIso, Libelle: string);
procedure PaysISOLibEnvers(Libelle: string; var CodeIso : string);
function PGUpperCase(const S: string; withAccent: boolean = true): string;
function PGSupprimeaccent(Ch: Char): Char;
function PGControlBL (LimitePaie : Integer) : Boolean ;
procedure TestNumeroSSNaissance (numss, SSNaiss : string; ChampDate : TDateTime;
                                 ChampDept : string; var ResultAnnee,
                                 ResultMois, ResultDepart: Integer);
var
cle: integer;


implementation
uses paramsoc;
{***********A.G.L.***********************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 10/07/2001
Modifi� le ... :   /  /
Description .. : R�cup�ration dans Result du num�ro contenu dans Buf
Suite ........ : apr�s �puration des caract�res non num�riques
Mots clefs ... : PAIE,CHAINE
*****************************************************************}
procedure ForceNumerique(Buf: string; var Resultat: string);
var
i, j: integer;
begin
j := 1;
Resultat := StringOfChar(' ', Length(Buf));

for i := 1 to Length(Buf) do
    if ((Buf[i] >= '0') and (Buf[i] <= '9')) then
       begin
       Resultat[j] := Buf[i];
       j := j + 1;
       end;

Resultat := Trim(Resultat);
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie Pgi
Cr�� le ...... : 31/01/2005
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure MajEtabCompl;
var
St, LeChamp: string;
Q: TQuery;
begin
St:= 'SELECT DH_NOMCHAMP'+
     ' FROM DECHAMPS WHERE'+
     ' DH_NOMCHAMP LIKE "ETB_%" AND'+
     ' ((DH_TYPECHAMP LIKE "VARC%") OR (DH_TYPECHAMP="COMBO"))';
Q := OpenSql(St, TRUE,-1,'',true);
while not Q.EOF do
      begin
      LeChamp := Q.FindField('DH_NOMCHAMP').AsString;
      st:= 'UPDATE ETABCOMPL SET '+
           LeChamp+' = "" WHERE '+
           LeChamp+' IS NULL';
      ExecuteSql(st);
      Q.Next;
      end;
Ferme(Q);
St:= 'SELECT DH_NOMCHAMP'+
     ' FROM DECHAMPS WHERE'+
     ' DH_NOMCHAMP LIKE "ETB_%" AND'+
     ' DH_TYPECHAMP="DATE"';
Q := OpenSql(St, TRUE,-1,'',true);
while not Q.EOF do
      begin
      LeChamp := Q.FindField('DH_NOMCHAMP').AsString;
      st:= 'UPDATE ETABCOMPL SET '+
           LeChamp+' = "'+UsDateTime(IDate1900)+'" WHERE '+
           LeChamp+' IS NULL';
      ExecuteSql(st);
      Q.Next;
      end;
Ferme(Q);
St:= 'SELECT DH_NOMCHAMP'+
     ' FROM DECHAMPS WHERE'+
     ' DH_NOMCHAMP LIKE "ETB_%" AND'+
     ' DH_TYPECHAMP="BOOLEAN"';
Q := OpenSql(St, TRUE,-1,'',true);
while not Q.EOF do
      begin
      LeChamp := Q.FindField('DH_NOMCHAMP').AsString;
      st:= 'UPDATE ETABCOMPL SET '+
           LeChamp+' = "-" WHERE '+
           LeChamp+' IS NULL';
      ExecuteSql(st);
      Q.Next;
      end;
Ferme(Q);
St:= 'SELECT DH_NOMCHAMP'+
     ' FROM DECHAMPS WHERE'+
     ' DH_NOMCHAMP LIKE "ETB_%" AND'+
     ' ((DH_TYPECHAMP="DOUBLE") OR (DH_TYPECHAMP="INTEGER"))';
Q := OpenSql(St, TRUE,-1,'',true);
while not Q.EOF do
      begin
      LeChamp := Q.FindField('DH_NOMCHAMP').AsString;
      st:= 'UPDATE ETABCOMPL SET '+
           LeChamp+' = 0 WHERE '+
           LeChamp+' IS NULL';
      ExecuteSql(st);
      Q.Next;
      end;
Ferme(Q);
end;


{***********A.G.L.***********************************************
Auteur  ...... : PAIE
Cr�� le ...... : 26/11/2001
Modifi� le ... : 27/11/2001
Description .. :  fonction de contr�le de validit� du N� Siret (ou SIREN)
Suite ........ : On multiplie les diff�rents chiffres composant le n� par un
Suite ........ : coefficient 1 ou 2 alternativement en comme�ant par le
Suite ........ : dernier chiffre du n� (le 14�me * 1, le 13�me * 2, le 12�me *
Suite ........ : 1...). Pour chaque produit obtenu on ajoute les deux chiffres
Suite ........ : du r�sultat. Le total des r�sultats doit �tre un nombre de
Suite ........ : dizaines se terminant par 0.
Suite ........ : En amont il faut contr�ler si le Siret est renseign� et si la
Suite ........ : taille est correcte (14 pour le SIRET, 9 pour le SIREN)
Mots clefs ... : PAIE,SIRET
*****************************************************************}
function ControlSiret(NoSiret: string): Boolean;
var
coeff, posit, iposit, zcalc, wcalc1, wcalc2, totcalc : Integer;
acalc, scalc : string;
begin
coeff:= 1;
totcalc:= 0;
posit:= Length (NoSiret);
iposit:= posit;

//PT8
if (not (IsNumeric (NoSiret))) then
   begin
   result:= False;
   exit;
   end;
//FIN PT8

while iposit > 0 do
      begin
//PT8
      scalc:= Copy (NoSiret, iposit, 1);
      if ((scalc = '0') or (scalc = '1') or (scalc = '2') or (scalc = '3') or
         (scalc = '4') or (scalc = '5') or (scalc = '6') or (scalc = '7') or
         (scalc = '8') or (scalc = '9')) then
         zcalc:= StrToInt (scalc)
      else
         begin
         result:= False;
         exit;
         end;
//FIN PT8
      zcalc:= zcalc * coeff;
      if (zcalc < 10) then
         acalc:= '0'+IntToStr (zcalc)
      else
         acalc:= IntToStr (zcalc);

      wcalc1:= StrToInt (copy (acalc, 1, 1));
      wcalc2:= StrToInt (copy (acalc, 2, 1));
      totcalc:= totcalc+wcalc1+wcalc2;
      iposit:= iposit-1;
      coeff:= coeff+1;
      if (coeff > 2) then
         coeff:= 1;
      end;
if (copy (IntToStr (totcalc), 2, 1)) <> '0' then
   result:= False
else
   result:= True;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie Pgi
Cr�� le ...... : 31/01/2005
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
function TestNumeroSS(numss: string; codesexe: string): integer;
var
code, i, k, numcle, resultat, temp : integer;
numss13, numsscle, numdep : string;
Corse: Boolean;
begin
k:= length(numss);
resultat:= 0;
Corse:= False;
if ((numss <> '') or (numss = '000000000000000')) then
   begin
   if (resultat = 0) and (k < 15) then
      resultat:= -3;
   if (resultat = -3) and (k = 13) then
      resultat:= -2;

//contr�le du code sexe
   if (k = 15) and (resultat = 0) then
      begin
      if ((numss[1] <> '1') and (numss[1] <> '2') and (numss[1] <> '7') and
         (numss[1] <> '8')) then
         resultat:= -4; //incoh�rence entre code sexe saisie et code sexe conforme
      if ((numss[1] = '1') or (numss[1] = '7')) then //psa_sexe = homme
         begin
         if (codesexe = 'F') then
            resultat:= -5 //Incoh�rence entre psa_sexe et code sexe
         else
            if (numss[1] = '7') then
               resultat:= 3;
         end
      else
         begin
         if ((numss[1] = '2') or (numss[1] = '8')) then //psa_sexe = femme
            begin
            if (codesexe = 'M') then
               resultat:= -6 //Incoh�rence entre psa_sexe et code sexe
            else
               if (numss[1] = '8') then
                  resultat:= 3;
            end;
         end;
      end;

//contr�le du code d�partement Corse
   if (resultat >= 0) then
      begin
      if ((k = 15) and (numss[6] = '2') and
         ((numss[7] = 'A') or (numss[7] = 'B'))) then
         begin
         numdep:= copy(numss, 2, 2);
         if (isnumeric(numdep)) then
            if (strtoint(numdep)>=76) then
               Corse:= True;
         end;

//contr�le de num�ricit� du n� de s�cu
      for i:= 1 to k do
          begin
          if (not((Corse = True) and (i=7))) then
             begin
             if not(numss[i] in ['0'..'9']) then
                resultat:= -7; //non num�rique
             end;
          end;
      end;

//calcul de la cl�
   if ((resultat >= 0) and (k = 15)) then
      begin
//R�cup�ration 13 premier char et cle saisie
      numss13:= Copy(numss, 1, 13);
{PT6
      if (NumSS13[7] = 'A') or (NumSS13[7] = 'B') then
         NumSS13[7] := '0';
      if numss13 <> '' then
         begin
         Num13:= valeur(Numss13);
         numsscle:= numss[14] + numss[15];
         val(numsscle, temp, code);
         numcle:= temp;
         entier:= Int(Num13 / 97);
         DblCle:= 97 - (Num13 - (entier * 97));
         Cle:= StrToInt(FloatToStr(DblCle));
         if (cle <> numcle) and (numcle > 0) then
            resultat:= -1
         end;
}
      Cle:= CalculCleSS (numss13);
      numsscle:= numss[14] + numss[15];
      val(numsscle, temp, code);
      numcle:= temp;
      if (cle <> numcle) and (numcle > 0) then
         resultat:= -1
//FIN PT6
      end;
   end
else
   if numss = '' then
      resultat:= 1;

result := resultat;
end;


//PT6
{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 05/04/2006
Modifi� le ... :   /  /
Description .. : Fonction de calcul du num�ro de cl� SS � partir du num�ro
Suite ........ : sur 13 caract�res
Mots clefs ... :
*****************************************************************}
function CalculCleSS(NumSS13 : string): integer;
var
entier, num13 : Extended;
DblCle : Double;
begin
result:= 0;
if (NumSS13[7] = 'A') or (NumSS13[7] = 'B') then
   NumSS13[7] := '0';
if numss13 <> '' then
   begin
   Num13:= valeur(Numss13);
   entier:= Int(Num13 / 97);
   DblCle:= 97 - (Num13 - (entier * 97));
   result:= StrToInt(FloatToStr(DblCle));
   end;
end;
//FIN PT6

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie Pgi
Cr�� le ...... : 31/01/2005
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
function ColleZeroDevant(Nombre, LongChaine: integer): string;
begin
{ DEB PT3 }
if (Length(IntToStr(Nombre)) < LongChaine)  then
   Result:= StringOfChar('0',LongChaine-Length(IntToStr(Nombre)))+IntToStr(Nombre)
else
     Result := IntToStr(Nombre);
{ FIN PT3 }
{ PT3 Mise en commentaire
var  StNombre: string;
TabInt: string;
i, j: integer;

tabResult := '';
for i := 1 to LongChaine do
    begin
    if Nombre < power(10, i) then
       begin
       TabInt := inttostr(Nombre);
//       colle (LongChaine-i z�ro devant]
       for j := 0 to (LongChaine - i - 1) do
           insert('0', TabResult, j);
       result := concat(TabResult, Tabint);
       exit;
       end;
    if i > LongChaine then
       result := inttostr(Nombre);
    end;
}
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie Pgi
Cr�� le ...... : 31/01/2005
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
function RendExerSocialPrec(var MoisE, AnneeE, ComboExer: string; var DebExer, FinExer: TDateTime; Exer: string): Boolean;
var
Q: TQuery;
DatF: TDateTime;
Jour, Mois, Annee: WORD;
begin
result := FALSE;
DebExer := 0;
FinExer := 0;
Q:= OpenSQL ('SELECT *'+
             ' FROM EXERSOCIAL WHERE'+
             ' PEX_ANNEEREFER="'+Exer+'" AND'+
             ' PEX_ACTIF="X"', TRUE,-1,'',true);
if not Q.EOF then
   begin
   DatF := Q.FindField('PEX_FINPERIODE').AsFloat; // Recup date de fin periode en cours
   DecodeDate(DatF, Annee, Mois, Jour);
   MoisE := ColleZeroDevant(Mois, 2);
   ComboExer := Q.FindField('PEX_EXERCICE').AsString; // recup Combo identifiant exercice
   AnneeE := Q.FindField('PEX_ANNEEREFER').AsString; // recup Annee de exercice
   DebExer := Q.FindField('PEX_DATEDEBUT').AsDateTime;
   FinExer := Q.FindField('PEX_DATEFIN').AsDateTime;
   result := TRUE;
   end;
Ferme(Q);
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie Pgi
Cr�� le ...... : 31/01/2005
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
function AffectDefautCode(Edit: THedit; Long: integer): string;
begin
// DEB PT2
if Edit <> nil then
   if (edit.text <> '') AND (IsNumeric (edit.text)) then
      result := ColleZeroDevant(StrToInt(Edit.text), Long)
   else
      begin
      if NOT (IsNumeric (edit.text)) then
         result := edit.text
      else
         result := '';
      end;
// FIN PT2
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie Pgi
Cr�� le ...... : 31/01/2005
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
function PGRendNoDossier(): string;
begin
if V_PGI.NoDossier <> '' then
   result := V_PGI.NoDossier
else
   result := '000000';
end;

procedure PgAffecteNoDossier ();
Var LeDos : String;
begin
leDos:= GetParamSocSecur ('SO_NODOSSIER', '');
{PT11
if (LeDos<>'000000') AND (LeDos<>'') then
   V_PGI.NoDossier:= LeDos
else
if (LeDos='') then
   V_PGI.NoDossier:= '000000';
}
if (LeDos<>'000000') AND (LeDos<>'') then
   V_PGI.NoDossier:= LeDos
else
if ((LeDos='') and (Length (V_PGI.NoDossier)=8)) then
   V_PGI.NoDossier:= '000000';
//FIN PT11
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie Pgi
Cr�� le ...... : 31/01/2005
Modifi� le ... :   /  /
Description .. : En validation et en suppression d'enregistrement
Suite ........ : on recharge les tablettes.
Suite ........ : Sur le prefixe de la table on recharge les tablettes concern�s
Suite ........ : On peut recharger qu'une seule tablette en renseignant le type
Mots clefs ... :
*****************************************************************}
procedure ChargementTablette(Prefixe, Typ: string);
var
QQuery: TQuery;
StWhere, StPref, StTyp: string;
begin
StWhere := '';
StPref := '';
StTyp := '';
if Prefixe <> '' then
   StPref:= ' DO_PREFIXE="'+Prefixe+'" ';
if Typ <> '' then
   StTyp:= ' DO_TYPE="'+Typ+'" ';
if StPref <> '' then
   StWhere:= 'WHERE'+StPref;
if (StWhere = '') and (StTyp <> '') then
   StWhere:= 'WHERE'+StTyp;
if (StWhere <> '') and (StTyp <> '') then
   StWhere:= StWhere+'AND'+StTyp;

QQuery:= OpenSql('SELECT DO_COMBO FROM DECOMBOS '+StWhere+'', true,-1,'',true);
while not QQuery.EOF do
      begin
      Avertirtable(QQuery.Findfield('DO_COMBO').asstring);
      QQuery.Next;
      end;
Ferme(QQuery);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie Pgi
Cr�� le ...... : 31/01/2005
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure InitialiseCombo(var Zone: Tcontrol);
var
Combo: THValCombobox;
begin
if zone = nil then exit;
Combo := THValcombobox(Zone);
if ((Combo <> nil) and (Combo.value = '')) then
   Combo.Itemindex := 0;
end;


{***********A.G.L.***********************************************
Auteur  ...... : Paie Pgi
Cr�� le ...... : 31/01/2005
Modifi� le ... :   /  /
Description .. : Fonction qui rend les periodes en cours du dernier exercice
Suite ........ : actif
Mots clefs ... : PAIE
*****************************************************************}
function RendPeriodeEnCours(var ExerPerEncours, DebPer, FinPer: string): Boolean;
var
Q: TQuery;
begin
result := FALSE;
DebPer := DateToStr(idate1900);
FinPer := DateToStr(idate1900);
Q:= OpenSQL ('SELECT *'+
             ' FROM EXERSOCIAL WHERE'+
             ' PEX_ACTIF="X" ORDER BY PEX_ANNEEREFER DESC', TRUE,-1,'',true);
if not Q.EOF then
   begin
   DebPer := Q.FindField('PEX_DEBUTPERIODE').AsString;
   FinPer := Q.FindField('PEX_FINPERIODE').AsString;
   ExerPerEncours := Q.FindField('PEX_EXERCICE').AsString;
   result := TRUE;
   end;
Ferme(Q);
end;

{***********A.G.L.***********************************************
Auteur  ...... : Paie Pgi
Cr�� le ...... : 31/01/2005
Modifi� le ... :   /  /
Description .. : Fonction qui rend l'ann�e et le mois de l'exercice en cours
Suite ........ : Elle donne en fait le dernier exercice Actif
Mots clefs ... : PAIE
*****************************************************************}
function RendExerSocialEnCours(var MoisE, AnneeE, ComboExer: string; var DebExer, FinExer: TDateTime): Boolean;
var
Q: TQuery;
DatF: TDateTime;
Jour, Mois, Annee: WORD;
begin
result := FALSE;
DebExer := idate1900;
FinExer := idate1900;
Q:= OpenSQL ('SELECT *'+
             ' FROM EXERSOCIAL WHERE'+
             ' PEX_ACTIF="X" ORDER BY PEX_ANNEEREFER DESC', TRUE,-1,'',true);
if not Q.EOF then
   begin
   DatF := Q.FindField('PEX_FINPERIODE').AsFloat;
   DecodeDate(DatF, Annee, Mois, Jour);
   MoisE := ColleZeroDevant(Mois, 2);
   ComboExer := Q.FindField('PEX_EXERCICE').AsString;
   AnneeE := Q.FindField('PEX_ANNEEREFER').AsString;
   DebExer := Q.FindField('PEX_DATEDEBUT').AsDateTime;
   FinExer := Q.FindField('PEX_DATEFIN').AsDateTime;
   result := TRUE;
   end;
Ferme(Q);
end;

{***********A.G.L.***********************************************
Auteur  ...... : Paie Pgi
Cr�� le ...... : 04/03/2005
Modifi� le ... :   /  /
Description .. : Recherche le libell� d'une tablette par rapport au suffice du
Suite ........ : champ
Mots clefs ... : PAIE;
*****************************************************************}
Function PgGetLibelleTablette( Var NomChamp,ValChamp,Tablette : string) : String;
Var Q : TQuery;
    St : string;
Begin
Tablette := '';
Q:= OpenSql ('SELECT DO_COMBO,DO_NOMCHAMP'+
             ' FROM DECOMBOS WHERE'+
             ' (DO_NOMCHAMP LIKE "%'+NomChamp+'%" OR'+
             ' DO_COMBO = "'+NomChamp+'") AND'+
             ' (DO_COMBO LIKE "PG%" OR'+
             ' DO_COMBO LIKE "YY%" OR'+
             ' DO_COMBO LIKE "TT%")', True,-1,'',true);
while not Q.eof do
      begin
      if Q.FindField('DO_COMBO').AsString = NomChamp then
         begin //Si NomChamp=NomTablette
         Tablette := Q.FindField('DO_COMBO').asstring;
         Break;
         end;
      St := Q.FindField('DO_NOMCHAMP').AsString;
      while Trim(St) <> '' do //Si NomChamp=Cl� suffixe
            begin
            if ReadTokenSt(St) = NomChamp then
               begin
               Tablette := Q.FindField('DO_COMBO').asstring;
               Break;
               end;
            end;
      if Tablette <> '' then
         break;
      Q.Next;
      end;
Ferme(Q);
//PT12 PB de tablette car pas les m�mes donn�es (Type YCV au lieu de CIV). Tablette sp�cifique
//pour la paie avec MR pour Monsieur au lieu de M. Forcer la tablette YYCIVILITE
if NomChamp = 'CIVILITE' then Tablette := 'YYCIVILITE';
if (Tablette <> '') then
   Result:= RechDom(Tablette, ValChamp, False)
else
   result := '';
End;

{***********A.G.L.***********************************************
Auteur  ...... : PAIE PGI
Cr�� le ...... : 24/07/2001
Modifi� le ... :   /  /
Description .. : Supprime un fichier
Mots clefs ... : PAIE;FICHIER
*****************************************************************}
function SupprimeFichier(FileN: string; Silence: Boolean = False): Boolean;
begin
result := True;
if FileExists(FileN) then
   begin
   if not Silence then
      begin
      if PgiAsk ('Voulez-vous supprimer le fichier '+ExtractFileName(FileN)+'?',
         'Fichier existant :') = MrYes then
         begin
         Result := True;
         DeleteFile(PChar(FileN))
         end
      else
         Result := False;
      end
   else
      begin
      Result := True;
      DeleteFile(PChar(FileN))
      end;
   end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 03/07/2002
Modifi� le ... :   /  /
Description .. : Retourne le code ISO d'un pays sur 2 car et son libell� �
Suite ........ : partir du code ISO sur 3 car
Mots clefs ... : PAYS;CODEISO2;PAIE;PGDADSU
*****************************************************************}
procedure PaysISOLib(Pays: string; var CodeIso, Libelle: string);
var
Q: Tquery;
begin
CodeIso := '';
Libelle := '';
Q:= OpenSql ('SELECT PY_CODEISO2, PY_LIBELLE'+
            ' FROM PAYS WHERE'+
            ' PY_PAYS="'+Pays+'"', True,-1,'',true);
if not Q.EOF then
   begin
   CodeIso := Q.FindField('PY_CODEISO2').asString;
   Libelle := Q.FindField('PY_LIBELLE').asString;
   end;
ferme(Q);
end;

//PT5
{***********A.G.L.***********************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 03/04/2006
Modifi� le ... :   /  /
Description .. : Retourne le code ISO d'un pays sur 3 car �
Suite ........ : partir de son libell�. En cas de pays non trouv�,
Suite ........ : initialisation � 'FRA'
Mots clefs ... : PAYS;CODEISO2;PAIE;PGDADSU
*****************************************************************}
procedure PaysISOLibEnvers(Libelle: string; var CodeIso : string);
var
Q: Tquery;
begin
CodeIso := '';
Libelle := '';
Q:= OpenSql ('SELECT PY_PAYS'+
            ' FROM PAYS WHERE'+
            ' PY_LIBELLE="'+Libelle+'"', True,-1,'',true);
if not Q.EOF then
   CodeIso := Q.FindField('PY_PAYS').asString
else
   CodeIso := 'FRA';

ferme(Q);
end;
//FIN PT5

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 15/07/2002
Modifi� le ... :   /  /
Description .. : Remplace les minuscules par des majuscules non
Suite ........ : accentu�es
Mots clefs ... : PAIE;PGDADSU
*****************************************************************}
function PGUpperCase(const S: string; withAccent: boolean = true): string;
var
Ch: Char;
L: Integer;
Source, Dest: PChar;
begin
L:= Length(S);
SetLength(Result, L);
Source:= Pointer(S);
Dest:= Pointer(Result);
while L <> 0 do
      begin
      Ch:= Source^;
      if withAccent then
{PT10
         begin
         if Ch in ['�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�'] then
            Ch := 'a'
         else
         if Ch in ['�', '�'] then
            Ch := 'c'
         else
         if Ch in ['�', '�', '�', '�', '�', '�', '�', '�'] then
            Ch := 'e'
         else
         if Ch in ['�', '�', '�', '�', '�', '�', '�', '�'] then
            Ch := 'i'
         else
         if Ch in ['�', '�'] then
            Ch := 'n'
         else
         if Ch in ['�', '�', '�', '�', '�', '�', '�', '�', '�', '�'] then
            Ch := 'o'
         else
         if Ch in ['�', '�', '�', '�', '�', '�', '�', '�'] then
            Ch := 'u'
         else
         if Ch in ['�', '�'] then
            Ch := 'y';
         end;
}
         Ch:= PGSupprimeaccent (Ch);
//FIN PT10
      if (Ch >= 'a') and (Ch <= 'z') then
         Dec (Ch, 32);
      Dest^:= Ch;
      Inc (Source);
      Inc (Dest);
      Dec (L);
      end;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 17/07/2006
Modifi� le ... :   /  /
Description .. : Remplace les caract�res par des caract�res non
Suite ........ : accentu�es
Mots clefs ... : PAIE;PGDADSU
*****************************************************************}
function PGSupprimeaccent(Ch: Char): Char;
begin
result:= Ch;
if Ch in ['�', '�', '�', '�', '�', '�', '�'] then
   result:= 'a'
else
if Ch in ['�', '�', '�', '�', '�', '�', '�'] then
   result:= 'A'
else
if Ch in ['�'] then
   result:= 'c'
else
if Ch in ['�'] then
   result:= 'C'
else
if Ch in ['�', '�', '�', '�'] then
   result:= 'e'
else
if Ch in ['�', '�', '�', '�'] then
   result:= 'E'
else
if Ch in ['�', '�', '�', '�'] then
   result:= 'i'
else
if Ch in ['�', '�', '�', '�'] then
   result:= 'I'
else
if Ch in ['�'] then
   result:= 'n'
else
if Ch in ['�'] then
   result:= 'N'
else
if Ch in ['�', '�', '�', '�', '�'] then
   result:= 'o'
else
if Ch in ['�', '�', '�', '�', '�'] then
   result:= 'O'
else
if Ch in ['�', '�', '�', '�'] then
   result:= 'u'
else
if Ch in ['�', '�', '�', '�'] then
   result:= 'U'
else
if Ch in ['�'] then
   result:= 'y'
else
if Ch in ['�'] then
   result:= 'Y';
end;

// DEB PT9
function PGControlBL (LimitePaie : Integer) : Boolean ;
var St : String;
    Q : TQuery;
    NbreS : Integer;
begin
  st := 'Select count (*) FROM SALARIES WHERE PSA_DATESORTIE <= "' + UsDateTime(IDate1900) + '" OR PSA_DATESORTIE > "' + UsDateTime(Now) + '"';
  Q := OpenSql(St, TRUE,-1,'',true);
  if not Q.EOF then NbreS := Q.Fields[0].AsInteger;
  ferme(Q);
  if NbreS > LimitePaie then result := FALSE
  else result := true;
end;
// FIN PT9

//PT10
{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 14/05/2007
Modifi� le ... :   /  /
Description .. : fonction de contr�le des num�ro SS pour : ann�e, mois et d�partement de naissance
Mots clefs ... : PAIE;PGDADSU
*****************************************************************}
procedure TestNumeroSSNaissance (numss, SSNaiss : string; ChampDate : TDateTime;
                                 ChampDept : string; var ResultAnnee,
                                 ResultMois, ResultDepart: Integer);
var
aa, mm, jj: word;
DateNaissanceSS: TDateTime;
AnneeSS, DepartNaissanceSS, MoisSS, TestMoisSS, TestNumDepartSS: string;
begin
if (SSNaiss='Annee') then
   ResultAnnee:= 0
else
if (SSNaiss='Mois') then
   ResultMois:= 0
else
if (SSNaiss='Depart') then
   ResultDepart:= 0;

if (SSNaiss='Mois') or (SSNaiss='Annee') then
   begin
   TestMoisSS:= Copy (numss, 4, 2);
   if IsNumeric (TestMoisSS) then
      begin
      if (StrToInt (TestMoisSS)>=20) and (StrToInt (TestMoisSS)<=42) then
         begin
         resultMois:= 0;
         ResultAnnee:= 0;
         exit;
         end;
      if StrToInt (TestMoisSS)>=50 then
         begin
         resultMois:= 0;
         ResultAnnee:= 0;
         exit;
         end;
      end;
   end;

if (SSNaiss = 'Mois') then
   begin
   if (numss<>'') or (numss='000000000000000') then
      begin
      DateNaissanceSS:= ChampDate;
      if DateNaissanceSS<>idate1900 then
         begin
         DecodeDate (DateNaissanceSS, aa, mm, jj);
         if mm<10 then
            MoisSS:= '0'+IntToStr (mm)
         else
            MoisSS:= IntToStr (mm);
         if (NumSS[4]<>MoisSS[1]) or (NumSS[5]<>MoisSS[2]) then
            ResultMois:= -9;
         end;
      end;
   end;

if (SSNaiss='Annee') then
   begin
   if ((numss<>'') or (numss='000000000000000')) then
      begin
      DateNaissanceSS:= ChampDate;
      if DateNaissanceSS<>idate1900 then
         begin
         DecodeDate (DateNaissanceSS, aa, mm, jj);
         AnneeSS:= IntToStr (aa);
         if (NumSS[2]<>AnneeSS[3]) or (NumSS[3]<>AnneeSS[4]) then
            ResultAnnee:= -8;
         end;
      end;
   end;

if (SSNaiss='Depart') then
   begin
//Controle d�partement de naissance 75 du numss <> departement de naissance
//si Annee de naissance >= 1964 et <= 1968 alors Ok
   if ((numss<>'') or (numss='000000000000000')) then
      begin
      TestNumDepartSS:= Copy (numss, 6, 2);
      if (TestNumDepartSS='  ') or (Copy (TestNumDepartSS, 1, 1)=' ') or
         (Copy (TestNumDepartSS, 2, 1)=' ') then
         Exit;
      if IsNumeric (TestNumDepartSS) then
         begin
         if (StrToInt (TestNumDepartSS)>=91) and
            (StrToInt (TestNumDepartSS)<=96) and (ChampDept='99') then
            exit;
         end;
      if IsNumeric (ChampDept) then
         if (StrToInt (ChampDept)>=91) and (StrToInt(ChampDept)>=95) then
            exit;
      DepartNaissanceSS:= ChampDept;
      DateNaissanceSS:= ChampDate;
      aa:= 0;
      if DateNaissanceSS <> idate1900 then
         DecodeDate (DateNaissanceSS, aa, mm, jj);
      if Length (DepartNaissanceSS) = 2 then
         begin
         if (NumSS[6]<>DepartNaissanceSS[1]) or
            (NumSS[7]<>DepartNaissanceSS[2]) then
            ResultDepart:= -10;
         if (Copy (NumSS, 6, 2)='75') and
            (Copy (DepartNaissanceSS, 1, 2)<>Copy (NumSS, 6, 2)) and
            (aa <= 1968) then
            ResultDepart:= 0;
         if (DateNaissanceSS >= StrToDate ('01/01/1976')) then //salari�s n�s en corse
            begin
            if ((Copy (NumSS, 6, 2)='2A') or (Copy (NumSS, 6, 2)='2B')) and
               (DepartNaissanceSS = '20') then
               ResultDepart:= 0;
            end
         else
            begin
            if (DateNaissanceSS<>IDate1900) and ((Copy (NumSS, 6, 2)='2A') or
               (Copy (NumSS, 6, 2)='2B')) then
               ResultDepart:= -12;
            if (Copy (NumSS, 6, 2)='20') and ((DepartNaissanceSS='2A') or
               (DepartNaissanceSS = '2B')) then
               ResultDepart:= 0;
            end;
         end;
      end;
   end;
end;
//FIN PT10

end.
