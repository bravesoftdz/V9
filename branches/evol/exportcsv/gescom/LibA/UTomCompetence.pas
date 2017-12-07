unit UTomCompetence;

interface
uses  StdCtrls,Controls,Classes,forms,sysutils,ComCtrls,
{$IFDEF EAGLCLIENT}
     Maineagl,
{$ELSE}
   {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} db, DBCtrls,FE_Main,
{$ENDIF}
      HCtrls,HEnt1,EntGC,HMsgBox,UTOM,UTOB,HTB97,Dicobtp ;

Type
     TOM_CompetRessource = Class (TOM)
       procedure OnUpdateRecord  ; override ;
       procedure OnNewRecord  ; override ;
       procedure OnChangeField (F : TField)  ; override ;
       procedure OnArgument(stArgument : String ); override;
       private
       CodeSalarie : string;
       CodeRessource : string;
       SaisieTypeSalarie : Boolean;
       END ;
Type
     TOM_Competence = Class (TOM)
       procedure OnUpdateRecord  ; override ;
       procedure OnNewRecord  ; override ;
       procedure OnDeleteRecord  ; override ;
       procedure OnArgument(stArgument : String ); override;
     END;

Type
     TOM_Fonction = Class (TOM)
       procedure OnUpdateRecord  ; override ;
       procedure OnDeleteRecord  ; override ;
     END;
Procedure AFLanceFiche_Competence;
Procedure AFLanceFiche_Fonction(Lequel,Argument:string);

implementation

{ TOM_CompetRessource }
procedure TOM_CompetRessource.OnChangeField(F: TField);
Var Compet : String ;
    P : TPageControl ;
    T1,T2,T3 : TTabSheet ;
    QQ : TQuery ;
begin
Inherited;
If (F.FieldName='ACR_COMPETENCE') then
   BEGIN
   Compet:=GetField('ACR_COMPETENCE') ;
   if Compet<>'' then
      BEGIN
      QQ:=OpenSQL('SELECT ACO_TYPECOMPETENCE FROM COMPETENCE WHERE ACO_COMPETENCE="'+Compet+'"',TRUE) ;
      if QQ.EOF then Compet:='' else Compet:=QQ.Fields[0].AsString ;
      Ferme(QQ) ;
      END ;
   P:=TPageControl(GetControl('ONGLET')) ;
   if P<>Nil then
      BEGIN
      P.ActivePage:=P.Pages[0] ;
      T1:=TTabSheet(GetControl('GLANGUE')) ; if T1<>Nil then T1.TabVisible:=(Compet='LGU') ;
      T2:=TTabSheet(GetControl('GPERMIS')) ;  if T2<>Nil then T2.TabVisible:=(Compet='PER') ;
      T3:=TTabSheet(GetControl('GDIPLOME')) ;  if T3<>Nil then T3.TabVisible:=(Compet='DIP') ;
      P.ActivePage:=P.Pages[0] ;
      END;
   END;
end;

procedure TOM_CompetRessource.OnNewRecord;
Var QQ : TQuery ;
    IMax :integer ;
begin
Inherited;
If SaisieTypeSalarie then
    Begin
    SetField ('ACR_RESSOURCE', CodeRessource);
    QQ:=OpenSQL('SELECT MAX(ACR_RANG) FROM COMPETRESSOURCE WHERE ACR_SALARIE="'+GetField('ACR_SALARIE')+'"',TRUE) ;
    End
Else
    Begin
    QQ:=OpenSQL('SELECT MAX(ACR_RANG) FROM COMPETRESSOURCE WHERE ACR_RESSOURCE="'+GetField('ACR_RESSOURCE')+'"',TRUE) ;
    SetField ('ACR_SALARIE', CodeSalarie);
    End;
if Not QQ.EOF then imax:=QQ.Fields[0].AsInteger+1 else iMax:=1 ;
Ferme(QQ) ;
SetField('ACR_RANG',IMax) ;
SetField('ACR_DATEDEBUT',iDate1900) ;
SetField('ACR_DATEFIN',iDate2099) ;
end;

procedure TOM_CompetRessource.OnUpdateRecord;
Var Compet : string ;
begin
Inherited;
Compet:=GetField('ACR_COMPETENCE') ;
if (Compet='') then
    BEGIN
    LastError:=1 ; LastErrorMsg:='Vous devez renseigner une compétence' ;
    END;
If (GetField('ACR_SALARIE')='') then SetField('ACR_SALARIE','***');
If (GetField('ACR_RESSOURCE')='') then SetField('ACR_RESSOURCE','***');
end;

Procedure TOM_CompetRessource.OnArgument(stArgument : String );
var ii :integer;
Begin
Inherited;
SaisieTypeSalarie := False;
// mcd 23/09/02 tout revu, pour traiter correctement tous les paramètres passés, a lieu de tester de position 1 à 3, ce qui n'est pas le cas si plusieurs paramètres !!!
(*if (Copy(StArgument,1,3)='SAL')then CodeSalarie := Copy (StArgument, 5,length(StArgument)-4);
if (Copy(StArgument,1,3)='RES')then
    Begin CodeRessource := Copy (StArgument, 5,length(StArgument)-4);  SaisieTypeSalarie := True; End;*)
ii:= Pos('SAL',StArgument);
if ii>0 then CodeSalarie := Copy (StArgument, ii+4,length(StArgument)-(ii+3))
 else begin
      ii:= Pos('RES',StArgument);
      if ii>0 then Begin CodeRessource := Copy (StArgument, ii+4,length(StArgument)-(ii+3));  SaisieTypeSalarie := True; End;
      end;
End;

{TOM COMPETENCE}
procedure TOM_Competence.OnNewRecord;
Begin
Inherited;
SetField('ACO_VISIBLEAFFAIRE','X');
SetField('ACO_VISIBLEGRH','X');
end;

procedure TOM_competence.OnDeleteRecord  ;
begin
if ExisteSQL('SELECT ACR_SALARIE FROM COMPETRESSOURCE WHERE ACR_COMPETENCE="'+GetField('ACO_COMPETENCE')+'"') then
   Begin LastError:=1 ; LastErrorMsg:=TraduitGa('Compétence existante dans les compétences par ressource') ; exit; End;
end;

procedure TOM_Competence.OnUpdateRecord;
Begin
Inherited;
if ((GetField('ACO_VISIBLEAFFAIRE')='-') And (GetField('ACO_VISIBLEGRH')='-')) then
   Begin
   LastError:=1 ; LastErrorMsg:='La compétence doit être visible au moins sur un domaine' ;
   End;
SetField ('ACO_COMPETENCE', Trim (GetField('ACO_COMPETENCE')) );
end;

Procedure TOM_Competence.OnArgument(stArgument : String );
Begin
Inherited;
if ctxScot in V_PGI.PGIContexte Then setControlProperty ('ACO_VISIBLEAFFAIRE','Caption','Visible en Gestion Interne');
End;

(*********************  TOM FONCTION de Ressources *****************************)
procedure TOM_Fonction.OnUpdateRecord;
Begin
Inherited;
SetField ('AFO_FONCTION', Trim (GetField('AFO_FONCTION')) );
end;

procedure TOM_Fonction.OnDeleteRecord  ;
begin
if ExisteSQL('SELECT ARS_RESSOURCE FROM RESSOURCE WHERE ARS_FONCTION1="'+GetField('AFO_FONCTION')+
   '" OR ARS_FONCTION2="'+GetField('AFO_FONCTION')+
   '" OR ARS_FONCTION4="'+GetField('AFO_FONCTION')+
   '" OR ARS_FONCTION3="'+GetField('AFO_FONCTION')+'"') then
   Begin LastError:=1 ; LastErrorMsg:=TraduitGa('Fonction existante dans les ressources') ; exit; End;
end;

Procedure AFLanceFiche_Competence;
begin
AGLLanceFiche ('AFF','COMPETENCE','','','');
end;
Procedure AFLanceFiche_Fonction(Lequel,Argument:string);
begin
AGLLanceFiche ('AFF','FONCTION','',lequel,argument);
end;

Initialization
registerclasses([TOM_CompetRessource,TOM_Competence,TOM_Fonction]) ;
end.
