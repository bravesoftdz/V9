{***********UNITE*************************************************
Auteur  ...... : BM
Cr�� le ...... : 12/03/2003
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
unit UTOFYYAnnulienLst;
/////////////////////////////////////////////////////////////////
interface
/////////////////////////////////////////////////////////////////
uses  UTOF;
/////////////////////////////////////////////////////////////////
Type
  TOF_YYANNULIENLST = Class (TOF)
        procedure OnArgument(Arguments : String ) ; override ;
  private

  END;
/////////////////////////////////////////////////////////////////
implementation
/////////////////////////////////////////////////////////////////
uses
   Classes, HCtrls;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : BM
Cr�� le ...... : 12/03/2003
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOF_YYANNULIENLST.OnArgument(Arguments : String ) ;
var
   sAction_l : string;
begin
   sAction_l := ReadTokenSt(Arguments);
   Ecran.Caption := 'Liens du dossier : '+ Arguments;
end;

/////////////////////////////////////////////////////////////////
Initialization
RegisterClasses([TOF_YYANNULIENLST]) ;
end.
