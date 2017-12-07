unit UtofTiersRecherche;

interface

uses  StdCtrls,Controls,Classes,forms,sysutils,ComCtrls,
      HCtrls,HEnt1,HMsgBox,UTOF, HDimension,HDB,UTOM,
      AglInit,UTOB,Dialogs,Menus, M3FP, EntGC,ent1, Htb97,
{$IFDEF EAGLCLIENT}
      MaineAGL,eFichList,
{$ELSE}
      Fiche, FichList, mul, db,DBGrids, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}Fe_Main,
{$ENDIF}
      grids,LookUp,
      AglInitGC,UtilGC;

type
     TOF_GCTIERS_RECH = Class (TOF)
        procedure OnArgument(Arguments : String) ; override ;
     private
        BInsert			: TToolBarButton97;
     		procedure SetPlusTypeTiers (Chaine : string);
		    Procedure BInsert_OnClick(Sender: TObject);
     END ;

implementation

procedure TOF_GCTIERS_RECH.OnArgument(Arguments : String) ;
var x : integer;
    st,stArg : string;
Begin
inherited ;
setcontroltext('XX_WHERE',arguments) ;
stArg := Arguments;
while (pos(' ', stArg) > 0) do // pour que le x=pos('T_NATUREAUXI=', stArg) marche bien
begin
  System.Delete (stArg, Pos (' ', stArg), 1);
end;
x:=pos('T_NATUREAUXI=',stArg) ;
st:='';
if x<>0 then st:=copy(stArg,x+14,3);
if VH_GC.GCIfDefCEGID then
   if (st='CLI') and (pos('T_NATUREAUXI="PRO"',stArg) <> 0 ) then st:='PRO' ; // si cli et PRO on force NATUREAUXI � PRO pour creation de prospect par defaut
if (ctxScot in V_PGI.PGIContexte) and (st ='FOU') then
   begin
   Ecran.Caption := 'Recherche d''un fournisseur';
   UpdateCaption(Ecran);
   end;

setcontroltext('NATUREAUXI',st) ;
 if (st='CLI' ) and (Not JaiLeDroitConcept(TConcept(gcCLICreat),False)) then
    BEGIN
    SetControlVisible('BINSERT',False) ;
    SetControlVisible('B_DUPLICATION',False) ;
    END ;
{$IFDEF BTP}
{$IFDEF EAGL}
THGRID(GetCOntrol('Fliste')).SortEnabled := true;
{$ELSE}
THDBGRID(GetCOntrol('Fliste')).SortEnabled := true;
{$ENDIF}
{$ENDIF}

{$IFDEF NOMADE} //Ajout des propspects dans le mul
SetControlText('XX_WHERE',GetControlText('XX_WHERE')+'OR T_NATUREAUXI="PRO"');
{$ENDIF}
SetControlVisible ('PCOMPLEMENT', (st = 'CLI'));
//modif BTP : provoque plantage en recherche tiers
SetControlVisible ('PCOMPLEMENTFOUR', (st = 'FOU'));
if st = 'FOU' then GCMAJChampLibre (TForm (Ecran), False, 'COMBO', 'YTC_TABLELIBREFOU', 3, '');
SetPlusTypeTiers (GetControlText('XX_WHERE'));

BInsert := TToolbarButton97(ecran.FindComponent('BInsert'));
BInsert.OnClick := BInsert_OnClick;

End ;

procedure TOF_GCTIERS_RECH.SetPlusTypeTiers(Chaine: string);
begin
	THEdit(GetCOntrol('T_TIERS')).Plus := 'AND '+Chaine;
end;

procedure TOF_GCTIERS_RECH.BInsert_OnClick(Sender: TObject);
begin
if GetControlText('NATUREAUXI')='CLI' then
{$IFDEF LINE}
  AGLLanceFiche ('BTP', 'BTTIERS_S1', '', '', 'ACTION=CREATION;T_NATUREAUXI=CLI')
{$ELSE}
  AGLLanceFiche ('GC', 'GCTIERS', '', '', 'ACTION=CREATION;T_NATUREAUXI=CLI')
{$ENDIF}
else if GetControlText('NATUREAUXI')='FOU' then
  AGLLanceFiche ('GC', 'GCFOURNISSEUR', '', '', 'ACTION=CREATION;T_NATUREAUXI=FOU');

  TtoolBarButton97(GetCOntrol('Bcherche')).Click;
end;

Initialization
registerclasses([TOF_GCTIERS_RECH]);

end.
