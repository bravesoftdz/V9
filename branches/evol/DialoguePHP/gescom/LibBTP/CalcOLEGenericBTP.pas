{***********UNITE*************************************************
Auteur  ...... : Franck Vautrain
Créé le ...... : 26/08/2004
Modifié le ... :   /  /
Description .. : Source qui comporte les fonctions utilisables dna sles états
Suite ........ : de la GI/GA et qui sont génériques
Suite ........ : Ont  besoin d'info des paramsoc ou fonctionne seule
Suite ........ : Ce source est fait à partir de fct qui existaient dans d'autres
Suite ........ : sources, et qui ont été mis dans celui_ci pour éviter des
Suite ........ : include en cascade
Mots clefs ... : FONCTION;ETAT
*****************************************************************}
unit CalcOLEGenericBTP;

interface
uses SysUtils, Classes, Utob,EntGc,
  HEnt1, UtilRessource, ParamSoc, HmsgBox,
{$IFNDEF EAGLCLIENT}
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
{$ENDIF}
  HCtrls ,DicoBTP ,TraducAffaire,
  ConfidentAffaire;

function BTPAFGenCalcOLEEtat(sf,sp : string) : variant ;

  // fct utilisées dans d'autres sources GI/GA..
Function BTPCodeAffaireAffiche (CodeAffaire : String; Separateur: string='') : String;forward;
function BTPAfReadParam(var St : String) : string ;
Function BTPHeureBase100To60 ( Heure : Double) : Double;
Procedure BTPCodeAffaireDecoupe(CodeAff : string; Var Part0,Part1, Part2, Part3, Avenant : String; FTypeAction:TActionFiche; SaisieAffaire:Boolean);
Function BTPTestStatutReduit (stStatut : String) : String;
Function BTPTestCodeAvenant (stAvenant : String; Alim00 : Boolean) : String;
Function BTPOLEFormatPeriode (Periode : string; bLib : Boolean) :string;
function BTGetBasesEdt(sf, sp: string): Variant;
function BTGetMilliemeEdt(sf, sp : string) : variant;

Function BTPAfficheCodeAff (Part0,Part1,PArt2,Part3,Avenant : String ) : String; forward;
implementation
function BTPOLEFormatExercice (Exer : string) : String; forward;
function BTPAFLibExercice ( Exercice : string) : String; forward;

Function BTPHeureBase100To60 ( Heure : Double) : Double;
var tmp : double;
BEGIN

if Heure = 0 then
   BEGIN
   	Result := 0;
    Exit;
   END;

tmp := (Frac(Heure)*0.6);

if (tmp = 0) then
   Result := Trunc(Heure)
else
   Result :=Trunc(Heure) + Arrondi(tmp,2);

END;

{***********Gestion des statuts************}
Function BTPTestStatutReduit (stStatut : String) : String;
BEGIN

Result := stStatut;

if (stStatut <> 'A') and
   (stStatut <> 'P') and
   (stStatut <> 'I') and
   (stStatut <> 'W') then Result := 'A';

END;

{ *********Gestion des avenants + Etats ... ***********}
Function BTPTestCodeAvenant (stAvenant : String; Alim00 : Boolean) : String;
BEGIN

// mcd 28/03/03 change VH_GC en Paramsoc
Result := stAvenant;

if (GetParamSoc('SO_AFFGestionAvenant')) and
   (StAvenant = '') and Not
   (Alim00) then exit;

if (stAvenant < '01') or
   (stAvenant > '99') then Result := '00';

END;

{***********A.G.L.***********************************************
Auteur  ...... : Patrice ARANEGA
Créé le ...... : 02/02/2000
Modifié le ... : 17/02/2000
Description .. : Décomposition du code affaire concaténé
Mots clefs ... : AFFAIRE;CODE AFFAIRE
*****************************************************************}
Procedure BTPCodeAffaireDecoupe(CodeAff : string; Var Part0, Part1, Part2, Part3, Avenant : String; FTypeAction:TActionFiche; SaisieAffaire:Boolean);
var i					 : Integer;
		lng				 : Integer;
    posit			 : integer;
    TypeCode 	 : string3;
    Valeur		 : String;
    TexteSel	 : String;
    CodePartie : String;
    Prefixe 	 : string;
Begin
    // mcd 28/03/03 passage de tous les VH_GC en GetPAramSoc
  Part1 := '';
  Part2 := '';
  Part3 := '';
  Posit := 0;
  lng := 0;

  If (CodeAff = '') then Exit;

  if part0 = 'W' then
  	 prefixe := 'SO_APP'
  else
     Prefixe := 'SO_AFF';

  // mcd 28/03/03 for i:=1 to NbMaxPartieAffaire do
  for i:=1 to 3 do
    Begin
    // recup des valeurs de la partie du code traitée
    case i of
        1: Begin
           lng:=GetParamSoc(Prefixe + 'Co1Lng');
           TypeCode:=GetParamSoc(Prefixe + 'Co1Type');
           Valeur:=GetParamSoc(Prefixe + 'Co1valeur');
           posit:=2;
           end;
        // Attention le premier car. réservé pour le statut
        2: Begin
        	 lng:= GetParamSoc(Prefixe + 'Co2Lng');
           TypeCode:=GetParamSoc(Prefixe + 'Co2Type');
           GetParamSoc(Prefixe + 'Co2valeur');
           posit:=GetParamSoc(Prefixe + 'Co1Lng')+2;
           End;
        3: Begin
           lng:=GetParamSoc(Prefixe + 'Co3Lng');
           TypeCode:=GetParamSoc(Prefixe + 'Co3Type');
           Valeur:=GetParamSoc(Prefixe + 'Co3valeur');
           posit:=GetParamSoc(Prefixe + 'Co1Lng')+GetParamSoc(Prefixe + 'Co2Lng')+2;
           End;
        End;

    // Attention  longueur Maxi : 15 (car 16 et 17 = avenant )
    if Posit + Lng > 16 then Lng := 16 -Posit;

    If (i <= GetParamSoc(Prefixe + 'CodeNbPartie')) Then
        Begin   // Partie utilisée
        TexteSel:='';
        If( CodeAff<> '') Then TexteSel:= trim(Copy (CodeAff,posit,lng));
        If (SaisieAffaire) then
            Begin
            If (FTypeAction=taCreat) Then
               CodePartie:= ''
            Else
               CodePartie:=TexteSel;
            End
        Else // Code affaire depuis une autre saisie
            Begin
            If (CodeAff<>'') Then
               CodePartie:=TexteSel
            Else
               CodePartie:= '';
            End;

        // spécificitées en fonction du type de zone ...
        // mcd 18/09/01 on ne passe dans cette fct que qd le code aff est renseigné .. il ne faut pas écraser ce qui ets mis dans la zone If (Typecode= 'FIX') Then   CodePartie:=Valeur Else          // Zone fixe
        If ((Pos(Typecode,'CPT;CPM')>0) And SaisieAffaire) Then                    // compteur
            Begin
            If (FTypeAction=taCreat) Then
               CodePartie:=Valeur;
            End;
        End
    Else
        // RAZ de la partie de structure non utilisée
        CodePartie:='';

    case i of
        1: Part1 := CodePartie;
        2: Part2 := CodePartie;
        3: Part3 := CodePartie;
        End;
    End;

  // Traitement du statut et de la zone avenant
  Part0 := BTPTestStatutreduit(Copy(CodeAff,1,1));
  Avenant := BTPTestCodeAvenant(Copy (codeAff,16,2),False);

End;


{***********A.G.L.***********************************************
Auteur  ...... : DESSEIGNET MC
Créé le ...... : 08/08/2000
Modifié le ... : 08/08/2000
Description .. : A partir des 5 partie de l'affaire,Retourne le code affaire
    à afficher / format et zones visibles
Mots clefs ... : AFFAIRE;CODE AFFAIRE
*****************************************************************}
Function BTPAfficheCodeAff (Part0,Part1,PArt2,Part3,Avenant : String ) : String;
Var Separateur: String;
BEGIN
Result := '';
 // mcd 18/09/01 même en GA on met un séparateur if (ctxScot in V_PGI.PGIContexte) then separateur := ' ';
  // mcd 28/03/03 passe tous les VH_GC en GetparamSoc
separateur := ' ';
Result := Part1;

if GetParamSoc('SO_AFFCo2Visible') then
   BEGIN
   if (GetParamSoc('SO_AFFORMATEXER')<>'AUC') then Part2 := BTPAFLibExercice (Part2);
   Result := Result + separateur + Part2;
   END;

if GetParamSoc('SO_AFFCo3Visible') then Result := Result + separateur + Part3;

if (GetParamSoc('SO_AFFGestionAvenant')) And (Avenant <> '00') then
    BEGIN
    Result := Result + ' ' + Avenant;
    END;

END;

{***********A.G.L.***********************************************
Auteur  ...... : PATRICE ARANEGA
Créé le ...... : 21/05/2000
Modifié le ... : 21/05/2000
Description .. : Retourne le code affaire affiché / format et zones visibles
Mots clefs ... : AFFAIRE;CODE AFFAIRE
*****************************************************************}
Function BTPCodeAffaireAffiche (CodeAffaire : String; Separateur: string='') : String;
Var Part0,Part1, Part2, Part3,Avenant: String;
BEGIN

Result := '';

 // mcd 18/09/01 même en GA on met un séparateur if (ctxScot in V_PGI.PGIContexte) then separateur := ' ';
 // mcd 28/03/03 passage de tous les VH_GC en GetParamSoc
separateur := ' ';

BTPCodeAffaireDecoupe(CodeAffaire, part0, Part1, Part2, Part3,Avenant,taConsult,False);

Result := Part1;

if GetParamSoc('SO_AFFCo2Visible') then
   BEGIN
   if (GetParamSoc('SO_AFFORMATEXER')<>'AUC') then Part2 := BTPAFLibExercice (Part2);
   Result := Result + separateur + Part2;
   END;

if GetParamSoc('SO_AFFCo3Visible') then Result := Result + separateur + Part3;

if (GetParamSOc('SO_AFFGestionAvenant')) And (Avenant <> '00') then
    BEGIN
    Result := Result + ' ' + Avenant;
    END;
END;


function BTPAFLibExercice ( Exercice : string) : String;
Var TypeExer : String;
BEGIN
  // mcd 28/03/03 passage de tous les VH_GC en GetPAramSoc
Result := Exercice;
TypeExer := GetParamSoc('SO_AFFormatExer');
if TypeExer = 'AUC' then Exit else
 if TypeExer = 'A' then Exit else
  if TypeExer = 'AM'  then
    BEGIN
    if Length(Exercice) < 6 then Exit;
    Result := Copy(Exercice,1,4) +'-'+ Copy(Exercice,5,2);
    END else
   if TypeExer = 'AA' then
     BEGIN
     if Length(Exercice) < 8 then Exit;
     Result := Copy(Exercice,1,4) +'-'+ Copy(Exercice,5,4);
     END;
END;


function BTPOLEFormatExercice (Exer : string) : String;
BEGIN

Result := '';

// mcd 18/09/01 if not (ctxScot in V_PGI.PGIContexte) then Exit;
if GetParamSoc('SO_AfFormatExer')='AUC' then Exit;

Trim(Exer); Result := Exer;

if (Length(Exer) < 5) then Exit;

Result := Copy(Exer,1,4)+'_'+ Copy(Exer, 5, Length(Exer)-4);

END;


Function BTPOLEFormatPeriode (Periode : string; bLib : Boolean) :string;
Var stYear, StMois : string;
    IMois  : integer;
BEGIN
Result := '';
if (Periode = '') or (periode < '111111')  then exit;
stYear := Copy (Periode,1,4);
if bLib then
    BEGIN
    IMois  := StrToInt(Copy(Periode,5,2));
    Result := FirstMajuscule(ShortMonthNames[IMois])+' '+stYear;
    END
else
    BEGIN
    stMois := Copy (Periode,5,2);
    Result := stMois +'/'+ stYear;
    END;
END;

function BTPAfReadParam(var St : String) : string ;
var i : Integer ;
begin

	i:=Pos(';',St);

	if i<=0 then i:=Length(St)+1 ;

	result:=Copy(St,1,i-1) ;
	Delete(St,1,i) ;
	Result := Trim(Result);

end ;

function BTPAFGenCalcOLEEtat(sf,sp : string) : variant ;
Var st1, St2, St3, St4, St5  : string;
 bb : boolean;
 hr1 : TDateTime;
BEGIN

TVarData(Result).VType := varEmpty;
if sf='BTBASE' then
   result := BTGetBasesEdt(sf, sp)
else if sf='BTMILLIEME' then
   result := BTGetMilliemeEdt(sf, sp)
else if sf='FORMATEXERCICE' then
   BEGIN
   st1 := BTPAfReadParam(sp) ;
   if not (ctxScot in V_PGI.PGIContexte) then
   	  BEGIN
      	Result := ' ';
        Exit;
      END;
   Result := BTPOLEFormatExercice (st1);
   Exit;
   END
else if sf='FORMATCODEAFF' then
   BEGIN
     st1 := BTPAfReadParam(sp) ;
     Result := BTPCodeAffaireAffiche(st1);
     Exit;
   END
else if sf='AFFICHECODEAFF' then
   BEGIN
     st1  := BTPAfReadParam(sp) ;
     st2  := BTPAfReadParam(sp) ;
     st3  := BTPAfReadParam(sp) ;
     st4  := BTPAfReadParam(sp) ;
     st5  := BTPAfReadParam(sp) ;
     Result := BTPAfficheCodeAff(st1,st2,st3,st4,st5);
     Exit;
   END
else if sf='VALOPERMISE' then
   BEGIN
     If JaiLeDroitConcept ( cc32 , false) then
		Result := sp
     else
        Result := 0.0;
   END
else if sf='FORMATPERIODE' then
   BEGIN
   	    st1  := BTPAfReadParam(sp) ;    // periode concaténée
   	    st2  := BTPAfReadParam(sp) ;    // libellé ou mois numérique
   	    bb := (st2 = 'LIB');
   	    Result := BTPOLEFormatPeriode (st1, bb);
   END
else if sf='RECUPHEURE' then
//NCX 31/07/01
   BEGIN
   		hr1:= StrToFloat(BTPAfReadParam(sp)) ;    // double à convertir
	    st1 := FormatFloat('0.00',BTPHeureBase100To60(hr1));
    	st2 := ReadTokenPipe(st1,',');
	    If ((st2='00') or (st2='0')) and (st1='00') then
     	   result := ''
        else
           result := st2+'h'+st1;
   END;
END;


function BTReadParam(var St: string): string;
var i: Integer;
begin
  i := Pos(';', St);
  if i <= 0 then i := Length(St) + 1;
  result := Copy(St, 1, i - 1);
  Delete(St, 1, i);
end;

Function BTFindMillieme (Nature, Souche : string;  Numero, Indice : integer) : TOB;
var TOBR: TOB;
  Q: TQuery;
begin
  TOBR := VH_GC.TOBBPM.FindFirst(['NATUREPIECEG', 'SOUCHE', 'NUMERO', 'INDICEG'], [Nature, Souche, Numero, Indice], True);
  if TOBR = nil then
  begin
    TOBR := TOB.Create('', VH_GC.TOBBPM, -1);
    TOBR.addChampSupValeur ('NATUREPIECEG',Nature);
    TOBR.addChampSupValeur ('SOUCHE',Souche);
    TOBR.addChampSupValeur ('NUMERO',Numero);
    TOBR.addChampSupValeur ('INDICEG',Indice);
    Q := OpenSQL('SELECT * FROM BTPIECEMILIEME WHERE BPM_NATUREPIECEG="' +
    						 Nature + '" AND BPM_SOUCHE="' + Souche + '" AND BPM_NUMERO=' + IntToStr(Numero) +
      					 ' AND BPM_INDICEG=' + IntToStr(Indice), True,-1,'',true);
    if not Q.eof then
    begin
    	TOBR.LoadDetailDB('BTPIECEMILIEME', '', '', Q, False, True);
    end;
    Ferme(Q);
  end;
  Result := TOBR;
end;

Function BTFindBase(Nature, Souche : string;  Numero, Indice : integer) : TOB;
var TOBR,TOBRR,TOBR1: TOB;
  Q: TQuery;
  ind : Integer;
begin
  TOBRR := TOB.Create('LES ABSES',nil,-1);
  TOBR := VH_GC.TOBGCB.FindFirst(['NATUREPIECEG', 'SOUCHE', 'NUMERO', 'INDICEG'], [Nature, Souche, Numero, Indice], True);
  if TOBR = nil then
  begin
    TOBR := TOB.Create('', VH_GC.TOBGCB, -1);
    TOBR.addChampSupValeur ('NATUREPIECEG',Nature);
    TOBR.addChampSupValeur ('SOUCHE',Souche);
    TOBR.addChampSupValeur ('NUMERO',Numero);
    TOBR.addChampSupValeur ('INDICEG',Indice);
  end else
  begin
    TOBR.ClearDetail;
  end;
  Q := OpenSQL('SELECT * FROM PIEDBASE WHERE GPB_NATUREPIECEG="' +
               Nature + '" AND GPB_SOUCHE="' + Souche + '" AND GPB_NUMERO=' + IntToStr(Numero) +
               ' AND GPB_INDICEG=' + IntToStr(Indice), True,-1,'',true);
  if not Q.eof then
  begin
    TOBRR.LoadDetailDB('PIEDBASE', '', '', Q, False, True);
    for ind := 0 to TOBRR.Detail.count -1 do
    begin
      TOBR1 := TOBR.FindFirst(['GPB_CATEGORIETAXE','GPB_FAMILLETAXE'],
                              [TOBRR.Detail[Ind].GetValue('GPB_CATEGORIETAXE'),
                               TOBRR.Detail[Ind].GetValue('GPB_FAMILLETAXE')],True);
      if TOBR1 = nil then
      begin
        TOBR1 := TOB.Create('PIEDBASE',TOBR,-1);
        TOBR1.Dupliquer(TOBRR.detail[Ind],False,true);
      end else
      begin
        TOBR1.PutValue('GPB_BASETAXE',TOBR1.GetValue('GPB_BASETAXE')+TOBRR.detail[ind].GetValue('GPB_BASETAXE'));
        TOBR1.PutValue('GPB_VALEURTAXE',TOBR1.GetValue('GPB_VALEURTAXE')+TOBRR.detail[ind].GetValue('GPB_VALEURTAXE'));
        TOBR1.PutValue('GPB_BASEDEV',TOBR1.GetValue('GPB_BASEDEV')+TOBRR.detail[ind].GetValue('GPB_BASEDEV'));
        TOBR1.PutValue('GPB_VALEURDEV',TOBR1.GetValue('GPB_VALEURDEV')+TOBRR.detail[ind].GetValue('GPB_VALEURDEV'));
        TOBR1.PutValue('GPB_BASETAXETTC',TOBR1.GetValue('GPB_BASETAXETTC')+TOBRR.detail[ind].GetValue('GPB_BASETAXETTC'));
        TOBR1.PutValue('GPB_BASETTCDEV',TOBR1.GetValue('GPB_BASETTCDEV')+TOBRR.detail[ind].GetValue('GPB_BASETTCDEV'));
        TOBR1.PutValue('GPB_BASETTCDEV',TOBR1.GetValue('GPB_BASETTCDEV')+TOBRR.detail[ind].GetValue('GPB_BASETTCDEV'));
      end;
    end;
  end;
  Ferme(Q);
  //
  Result := TOBR;
  TOBRR.free;
end;

function BTGetBasesEdt(sf, sp: string): Variant;
var Nature, Souche, St, Champ : string;
  Numero, Indice, ii: integer;
  TOBB: TOB;
begin
    Result := '';
    St := sp;
    Champ := BTReadParam(st);
    ii := ValeurI(BTReadParam(st));
    Nature := BTReadParam(St);
    Souche := BTReadParam(St);
    Numero := ValeurI(BTReadParam(St));
    Indice := ValeurI(BTReadParam(St));
    TOBB := BTFindBase(Nature, Souche, Numero, Indice);
    if TOBB = nil then Exit;
    if ii > TOBB.Detail.Count then Exit;
    if not TOBB.Detail[ii - 1].FieldExists('GPB_' + Champ) then Exit;
    Result := TOBB.Detail[ii - 1].GetValue('GPB_' + Champ);
end;

function BTGetMilliemeEdt(sf, sp : string) : variant;
var Nature, Souche, St, Champ: string;
  Numero, Indice, ii: integer;
  TOBB: TOB;
begin
    Result := '';
    St := sp;
    Champ := BTReadParam(st);
    ii := ValeurI(BTReadParam(st));
    Nature := BTReadParam(St);
    Souche := BTReadParam(St);
    Numero := ValeurI(BTReadParam(St));
    Indice := ValeurI(BTReadParam(St));
    TOBB := BTFindMillieme(Nature, Souche, Numero, Indice);
    if TOBB = nil then Exit;
    if ii > TOBB.Detail.Count then Exit;
    if (Champ = 'EXIST') then
    BEGIN
    	result := 'Ok';
    END ELSE
    BEGIN
      if not TOBB.Detail[ii - 1].FieldExists('BPM_' + Champ) then Exit;
      Result := TOBB.Detail[ii - 1].GetValue('BPM_' + Champ);
    END;
end;


end.
