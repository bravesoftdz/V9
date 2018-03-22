{***********UNITE*************************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 24/08/2007
Modifi� le ... :   /  /
Description .. : Outils communs aux imports
Mots clefs ... : PAIE;PG_IMPORT
*****************************************************************}
{
}
unit PgOutilsImport;

interface

uses
  Classes,
{$IFNDEF EAGLCLIENT}
{$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  FE_Main,
{$ELSE}
  uTob,
  MaineAgl,
{$ENDIF}
  Hctrls,
  HEnt1,
  ExtCtrls,
  SysUtils,
  ULibEditionPaie;


  procedure InitCodeSal;
  procedure FinCodeSal;
  function SalarieAbsent (St : string) : boolean;
  function SalarieDansListe (St : string; PeutCreer : boolean;
                             var Code : Integer) : boolean;

var
  ListeCodeSal : TStringList;
  FCodeSal : TRadioGroup;
  Index : integer;
  Num : Longint;

implementation

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 23/08/2007
Modifi� le ... :   /  /
Description .. : Initialisation de la table de correspondance
Mots clefs ... : PAIE;PGIMPORT
*****************************************************************}
procedure InitCodeSal;
Var
Q : TQuery ;
MaxCodeSal : Integer ;
begin
ListeCodeSal:=TStringList.Create ;
ListeCodeSal.Sorted:=TRUE ;
MaxCodeSal:=1 ;
if (FCodeSal.ItemIndex=0) then
   BEGIN
   Q:=OpenSQL('SELECT MAX(PSA_SALARIE) FROM SALARIES',TRUE) ;
   if Not Q.EOF then
      try
      MaxCodeSal:=ValeurI(Q.Fields[0].AsString)+1 ;
      except
            on E: EConvertError do
               MaxCodeSal:= 1;
      end;
   Ferme(Q) ;
   END ;
ListeCodeSal.AddObject('_______',tobject(MaxCodeSal)) ;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 23/08/2007
Modifi� le ... :   /  /
Description .. : Lib�ration de la table de correspondance
Mots clefs ... : PAIE;PGIMPORT
*****************************************************************}
procedure FinCodeSal;
begin
ListeCodeSal.Free;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 24/08/2007
Modifi� le ... :   /  /
Description .. : V�rification de la pr�sence d'un salari� pour permettre la
Suite ........ : cr�ation
Mots clefs ... : PAIE;PGIMPORT
*****************************************************************}
function SalarieAbsent (St : string) : boolean;
Var
StSal : string;
begin
StSal:= 'SELECT PSA_SALARIE FROM SALARIES WHERE PSA_SALARIE="'+St+'"';
Result := ExisteSQL (StSal);
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 23/08/2007
Modifi� le ... :   /  /
Description .. : Gestion de la liste des salari�s
Suite ........ : PeutCr�er : Si = True, cr�ation du salari� possible dans la
Suite ........ : table de correspondance
Mots clefs ... : PAIE;PGIMPORT
*****************************************************************}
function SalarieDansListe (St : string; PeutCreer : boolean;
                           var Code : Integer) : boolean;
Var
i : Integer ;
begin
result := TRUE;
i:=ListeCodeSal.IndexOf(St) ;
if i<0 then
   BEGIN
   if Not PeutCreer then
      BEGIN
      result:=FALSE ;
      Exit ;
      END ;
   if (Index = 0) then
      Code:=Longint(ListeCodeSal.Objects[0]) + Num
   else
      Code:=Longint(ListeCodeSal.Objects[0]);
   ListeCodeSal.AddObject(St,tobject(Code)) ;
   ListeCodeSal.Objects[0]:=tobject(Code+1) ;
   END
else
   BEGIN
   Code:=longint(ListeCodeSal.Objects[i]) ;
   END ;
end;

end.
