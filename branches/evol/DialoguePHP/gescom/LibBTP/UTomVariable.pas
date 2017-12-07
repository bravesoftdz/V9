{***********UNITE*************************************************
Auteur  ...... : 
Créé le ...... : 05/09/2003
Modifié le ... :   /  /
Description .. : Source TOM de la TABLE : BVARIABLES (BVARIABLES)
Mots clefs ... : TOM;BVARIABLES
*****************************************************************}
Unit UTomvariable ;

Interface

Uses StdCtrls, 
     Controls, 
     Classes, 
{$IFNDEF EAGLCLIENT}
     db, 
     {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
     Fiche, 
     FichList,
     HDB,
{$else}
     eFiche, 
     eFichList, 
{$ENDIF}
     forms, 
     sysutils, 
     ComCtrls,
     HCtrls, 
     HEnt1, 
     HMsgBox, 
     UTOM, 
     UTob ;

Type
  TOM_BVARIABLES = Class (TOM)
    procedure OnNewRecord                ; override ;
    procedure OnDeleteRecord             ; override ;
    procedure OnUpdateRecord             ; override ;
    procedure OnAfterUpdateRecord        ; override ;
    procedure OnLoadRecord               ; override ;
    procedure OnChangeField ( F: TField) ; override ;
    procedure OnArgument ( S: String )   ; override ;
    procedure OnClose                    ; override ;
    procedure OnCancelRecord             ; override ;
    end ;

Implementation

procedure TOM_BVARIABLES.OnNewRecord ;
begin
  Inherited ;
end ;

procedure TOM_BVARIABLES.OnDeleteRecord ;
begin
  Inherited ;
end ;

procedure TOM_BVARIABLES.OnUpdateRecord ;
begin
  Inherited ;
end ;

procedure TOM_BVARIABLES.OnAfterUpdateRecord ;
begin
  Inherited ;
end ;

procedure TOM_BVARIABLES.OnLoadRecord ;
begin
  Inherited ;
end ;

procedure TOM_BVARIABLES.OnChangeField ( F: TField ) ;
var Q       : Tquery;
    Req     : String;
    Valeur  : string;
    Article : String;
begin
  Inherited ;
  if F.FieldName = 'BVA_CODEVARIABLE' then
  begin
  valeur := GetControlText('BVA_CODEVARIABLE');
  Article :=GetControlText('BVA_ARTICLE');

  if valeur = '' then exit;

  // Recherche de la valeur dans le cas de l'appel d'une variables de type Générales dans un article
  Req := 'SELECT BVA_VALEUR FROM BVARIABLES ';
  Req := Req + 'WHERE (BVA_TYPE="A") ';
  Req := Req + 'AND (BVA_ARTICLE="APPLICATION") ';
  Req := Req + 'AND (BVA_CODEVARIABLE="' + Valeur + '")';

  Q := OpenSql (Req,true);
  if Q.eof then
     Begin
     Req := 'SELECT BVA_VALEUR FROM BVARIABLES ';
	   Req := Req + 'WHERE (BVA_TYPE="G") ';
  	 Req := Req + 'AND (BVA_ARTICLE="GENERAL") ';
  	 Req := Req + 'AND (BVA_CODEVARIABLE="' + Valeur + '")';
	   Q := OpenSql (Req,true);
     if Q.eof then
        Begin
        Req := 'SELECT BVA_VALEUR FROM BVARIABLES ';
	      Req := Req + 'WHERE (BVA_TYPE="B") ';
        Req := Req + 'AND (BVA_ARTICLE="' + Article + '") ';
  	    Req := Req + 'AND (BVA_CODEVARIABLE="' + Valeur + '")';
	      Q := OpenSql (Req,true);
        if Q.eof then
           Valeur := ''
        else
           Valeur := Q.FindField('BVA_VALEUR').AsString;
        End
     else
        Valeur := Q.FindField('BVA_VALEUR').AsString;
     End
  else
     Valeur := Q.FindField('BVA_VALEUR').AsString;

  SetControlText('BVA_VALEUR', Valeur);

  ferme (Q);
  end;
end ;

procedure TOM_BVARIABLES.OnArgument ( S: String ) ;
var Critere  : String;
    Indice   : Integer ;
    ChampMul : String;
    ValMul   : string ;
begin
  Inherited ;

  SetControlVisible ('LIBELLEARTICLE', True);

  // Chargement du critére de sélection
  Critere:=uppercase(Trim(ReadTokenSt(S))) ;

  if Critere = 'APPLICATION' then
     Begin
       SetControlCaption ('LIBELLEARTICLE','VARIABLES APPLICATION');
{$IFDEF EAGLCLIENT}
       THedit(getcontrol('BVA_CODEVARIABLE')).ElipsisButton := False;
{$ELSE}
       THDBedit(getcontrol('BVA_CODEVARIABLE')).ElipsisButton := False;
{$ENDIF}
       exit;
     end
  Else if Critere = 'GENERALES' Then
     Begin
       SetControlCaption ('LIBELLEARTICLE','VARIABLES GENERALES');
{$IFDEF EAGLCLIENT}
       THedit(getcontrol('BVA_CODEVARIABLE')).ElipsisButton := False;
{$ELSE}
       THDBedit(getcontrol('BVA_CODEVARIABLE')).ElipsisButton := False;
{$ENDIF}
       exit;
     end
  Else if Critere = 'DOCUMENTS' then
     Begin
       SetControlCaption ('LIBELLEARTICLE','VARIABLES DOCUMENTS');
       exit;
     end;

  indice:=pos('=',Critere);
  if indice <> 0 then
    begin
      ChampMul:=copy(Critere,1,indice-1);
      ValMul:=copy(Critere,indice+1,length(Critere));
      if champMul = 'LIBELLEARTICLE' then
         begin
          SetControlCaption ('LIBELLEARTICLE',Valmul);
         end ;
    end;

  setControlVisible('BLast', false);
  setControlVisible('BFirst', false);
  setControlVisible('BNext', false);
  setControlVisible('BPrev', false);
end ;

procedure TOM_BVARIABLES.OnClose ;
begin
  Inherited ;

end ;

procedure TOM_BVARIABLES.OnCancelRecord ;
begin
  Inherited ;
end ;

Initialization
  registerclasses ( [ TOM_BVARIABLES ] ) ;
end.

