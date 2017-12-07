unit FactRg;

interface


Uses HEnt1, HCtrls, UTOB, Ent1, LookUp, Controls, ComCtrls, StdCtrls, ExtCtrls,
{$IFDEF EAGLCLIENT}
     HPdfPrev,UtileAGL,Maineagl,
{$ELSE}
     {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} FE_Main, DB,
{$IFDEF V530}
      EdtEtat,EdtDoc,
{$ELSE}
      EdtREtat, EdtRDoc,
{$ENDIF}
{$ENDIF}
     SysUtils, Dialogs, Utiltarif, SaisUtil, UtilPGI, AGLInit, FactUtil,
     Math, StockUtil, EntGC, Classes, HMsgBox, FactNomen, FactTOB,
     Echeance, Paramsoc,factcomm,factcalc,FactPiece,FactRgpBesoin,
     uEntCommun,UtilTOBPiece
     ;

function RGMultiple (TOBpiece:TOB):boolean;
procedure InsereLigneRG(TOBPiece,TOBRg,TOBBASEs,TOBBRG,TOBTIers,TOBAffaire,TOBLigneRG: TOB;NumIndice:integer);
procedure RecalculeRG (TOBPorcs,TOBPIECE,TOBPIECERG,TOBBASES,TOBBASESRG : TOB;DEV:Rdevise);
function RecupDebutRG (TOBpiece : TOB;Indice : Integer): Integer;

procedure CalculBaseRG (TOBTiers,TOBPiece,TOBPieceTrait,TOBBasesL,TOBPIeceRG,TOBBasesRg,TOBS: TOB ; TOBPorcs: TOB; R_Valeurs : R_CPercent;DEV:Rdevise;GenerationFac:boolean=false);
function GetCumultextRG (TOBPIeceRG:TOB;Nomchamp : string) : string;
function GetCumulValueRG (TOBPIeceRG:TOB;Nomchamp : string) : variant;
function GetCumulValueTaxeRG (TOBBasesRG:TOB;Nomchamp : string) : variant;
procedure GetCumulRG (TOBPieceRG : TOB; var SommePivot,SommeDevise: double;initial:boolean=false);
procedure FusionneTva (TOBTAXERG,TOBTAXEGLOB,TOBPIECERG,TOBTvaMillieme: TOB;Avoir : boolean=false);
procedure GetLesTaxesRG(TOBBasesRG :TOB; CatTaxe,FamTaxe:String; var RGD,RGP : double) ;
procedure GetLaTaxeRG(TOBB :TOB; var RGD,RGP : double) ;
procedure GetCumulTaxesRG(TOBBasesRG,TOBPieceRG :TOB; var RGD,RGP : double;DEV:Rdevise) ;
procedure GetMontantRG (TOBPIeceRG,TOBBasesRG : TOB;var XD,XP : double;DEV:Rdevise;HtForce:boolean=false;HorsCaution:boolean=false);
procedure ReIndiceLigneRg (TOBPieceRG: TOB;NumLigne,IndiceRg: integer);
procedure ReIndiceLigneBasesRg (TOBBasesRG: TOB;NumLigne,IndiceRg: Integer);
procedure initLigneRg (TOBRG,TOBPIECE : TOB);
procedure ReajusteCautionDocOrigine (TOBPIece,TOBPieceRG:TOB; SensAjout : boolean;TOBPieceRG_O:TOB = nil);
procedure ReinitRGUtilises (TOBPieceRG : TOB);
function CalculPort (EnHt: boolean;TOBPorcs : TOB) : double;
function RestitueMontantCautionUtilise (TOBPieceRG : TOB) : boolean;
procedure EnregistreNumOrdreRG (TOBgenere,TOBPieceRg : TOB);
procedure GetCautionAlreadyUsed (PieceOrigine : string;var CautionUSed,CautionUsedDev : double);
procedure GetReliquatCaution (TOBPieceRg : TOB; var RQ,RQDev : double) ;
procedure GetMontantRGReliquat(TOBPieceRg : TOB; var RGRP,RGRD : double; ForceTTC : boolean=false; UniquementsiTTC : boolean=false) ;
procedure SupprimeRg (TOBPieceRg,TOBBasesRg : TOB; IndiceRg : integer);
procedure VidePieceRGLigne (TOBPieceRG: TOB;Ligne : integer);
procedure CalculeRGSimple (TOBPorcs,TOBPIECE,TOBRG,TOBBASES,TOBBASESRG: TOB;DEV:Rdevise);
procedure RGVersLigne (TOBPiece,TOBPieceRG,TOBBasesRG,TOBLIG,TOBLigneRG : TOB; Applicretenue: boolean; GenerationFac : boolean=false);

const TRGModeInsertion : integer=0;
      TRGModeModif: integer=1;
type RGMode = (RGstd,RGDepass);
implementation
uses factvariante,factureBtp,FactLigneBase;

procedure GetCautionAlreadyUsed (PieceOrigine : string;var CautionUSed,CautionUsedDev : double);
var CD : R_CLEDOC;
		QQ : TQuery;
    req : String;
begin
	CautionUsed := 0;
  CautionUsedDev := 0;
  if PieceOrigine = '' then exit;
  DecodeRefPiece (PieceOrigine,CD);
  req := 'SELECT PRG_CAUTIONMTU,PRG_CAUTIONMTUDEV FROM PIECERG WHERE '+WherePiece (CD,ttdretenuG,true)+
  							 ' AND PRG_NUMLIGNE='+IntToStr(CD.NumLigne);
  TRY
    QQ := OpenSql (Req,true,-1, '', True);
    if not QQ.eof then
    begin
      CautionUsed := QQ.findField('PRG_CAUTIONMTU').asFloat  ;
      CautionUsedDEV := QQ.findField('PRG_CAUTIONMTUDEV').asFloat;
    end;
  FINALLY
  	if assigned(QQ) then ferme (QQ);
  END;
end;

procedure GetMontantRGReliquat(TOBPieceRg : TOB; var RGRP,RGRD : double; ForceTTC : boolean=false; UniquementsiTTC : boolean=false) ;
var Xp,XD : double;
		indice : integer;
    TOBLoc :TOb;
begin
  RGRP := 0 ;RGRD := 0;
  for Indice := 0 to TOBPieceRG.detail.count -1 do
  begin
  	TOBLoc := TOBPieceRG.detail[Indice];
  	if TOBLOC = nil then exit;
    if (TOBLoc.getValue('PRG_TYPERG')='HT') and (UniquementsiTTC) then continue;
    if (TOBLoc.getValue('PRG_TYPERG')='HT') and (not forceTTC) then
    begin
      XP:= TOBLOC.GetValue('PRG_MTHTRG');
      XD:= TOBLOC.GetValue('PRG_MTHTRGDEV');
    end else
    begin
      XP:= TOBLOC.GetValue('PRG_MTTTCRG');
      XD:= TOBLOC.GetValue('PRG_MTTTCRGDEV');
    end;
    if (TOBLoc.GetValue('PRG_NUMCAUTION')<> '') and (TOBLoc.GetValue('PRG_NATUREPIECEG')<> 'ABT') then
    begin
      XP := XP - (TOBLOC.getValue('PRG_CAUTIONMT') - TOBLOC.getValue('CAUTIONUTIL'));
      XD := XD - (TOBLOC.getValue('PRG_CAUTIONMTDEV') - TOBLOC.getValue('CAUTIONUTILDEV'));
    end;
    if TOBLoc.GetValue('PRG_NATUREPIECEG')<> 'ABT' then
    begin
      if XD < 0 then XD := 0;
      if XP < 0 then XP := 0;
    end;
    RGRP := RGRP + XP;
    RGRD := RGRD + XD;
  end;
end;

procedure GetReliquatCaution (TOBPieceRg : TOB; var RQ,RQDev : double) ;
var indice : integer;
		TOBPRG : TOB;
    CautionRecup : boolean;
begin
	RQ := 0;
  RQDev := 0;
	for Indice := 0 to TOBPIeceRG.detail.count -1 do
  begin
  	TOBPRg := TOBPieceRG.detail[Indice];
    if Indice = 0 then
    begin
			if (TOBPrg.GetValue('PRG_NUMCAUTION')<> '') then
      begin
    		RQ := RQ + TOBPrg.getValue('PRG_CAUTIONMT') - TOBPrg.getValue('CAUTIONUTIL');
    		RQDev := RQDev + TOBPrg.getValue('PRG_CAUTIONMTDEV') - TOBPrg.getValue('CAUTIONUTILDEV');
      end;
    end;
  end;
end;

procedure GetValueRg (TOBLOC: TOB; var RGRP,RGRD :double ;Reliquat:boolean);
var MyCautionrest,CautionUsed,CautionUsedDev : double;
begin
RGRP := 0 ;RGRD := 0;
CautionUsed := 0; CautionUsedDev := 0 ;
if TOBLOC = nil then exit;
RGRP:=TOBLOC.GetValue('PRG_MTTTCRG');
RGRD:=TOBLOC.GetValue('PRG_MTTTCRGDEV');
(*
if (TOBLOC.GetValue('PRG_NUMCAUTION')<> '') and (Reliquat) then
   begin
   if TOBLOC.fieldExists ('PIECEPRECEDENTE') then GetCautionAlreadyUsed (TOBLOC.GetValue('PIECEPRECEDENTE'),
   																																			 CautionUSed,CautionUsedDev);
   MyCautionRest := TOBLOC.GetValue('PRG_CAUTIONMT') - CautionUsed;
   if MyCautionRest < 0 then MyCautionRest := 0;
   RGRP := RGRP - (MyCautionRest) ;
   MyCautionRest := TOBLOC.GetValue('PRG_CAUTIONMTDEV') - CautionUsedDev;
   if MyCautionRest < 0 then MyCautionRest := 0;
   RGRD := RGRD - (MyCautionRest);
   end;
*)
if TOBLoc.getValue('PRG_NATUREPIECEG') <> 'ABT' Then
begin
  if RGRP < 0 then RGRP := 0;
  if RGRD < 0 then RGRD := 0;
end;
end;

procedure GetCumulTaxeByIndice (TOBPIECE,TOBPIECERG,TOBBasesRG:TOB; var TP,TD :double);
var TOBLOC : TOB;
    XD,XP : double;
    RD,RP : double;
    Indice:integer;
    Ratio : double;
    DEV : Rdevise;
begin
TP:=0;TD:=0;
if TOBPIeceRG=nil then exit;
DEV.Code:=TOBPiece.getValue('GP_DEVISE') ; GetInfosDevise(DEV) ;
Indice:=TOBPieceRG.getValue('INDICERG');
// recupere le reliquat de RG par ligne
GetValueRg (TOBPieceRG,RP,RD,true);
GetValueRg (TOBPieceRG,XP,XD,false);
if XD <> 0 then Ratio := RD / XD else Ratio := 0;
// --
if TOBBasesRG=nil then exit;
TOBLOC:=TOBBasesRG.findfirst(['INDICERG'],[Indice],true);
While TOBLOC <> nil do
   begin
   GetLaTaxeRG (TOBLOC,XD,XP);
   TP := TP+(XP*Ratio);
   TD := TD+(XD*Ratio);
   TOBLOC:=TOBBasesRG.findnext(['INDICERG'],[Indice],true);
   end;
TD:=Arrondi (TD,DEV.Decimale );
TP:=Arrondi (TP,V_PGI.okDecv );
end;

procedure ReAjusteMontants ( TOBLOC: TOB;DEV:Rdevise);
begin
if TOBLOC.NomTable = 'PIEDBASERG' then
   begin
   CoordinateMont (TOBLOC,'PBR_VALEURDEV','PBR_VALEURTAXE',DEV);
   CoordinateMont (TOBLOC,'PBR_BASEDEV','PBR_BASETAXE',DEV);
   end else
   if TOBLOC.NomTable = 'PIECERG' then
     begin
     CoordinateMont (TOBLOC,'PRG_MTHTRGDEV','PRG_MTHTRG',DEV);
     CoordinateMont (TOBLOC,'PRG_MTTTCRGDEV','PRG_MTTTCRG',DEV);
     end;
end;

procedure VideBasesRGLigne (TOBBasesRG: TOB;Ligne : integer);
var TOBL : TOB;
begin
if TOBBasesRG = nil then exit;
TOBL := TOBBasesRG.findfirst (['INDICERG'],[Ligne],true);
while TOBL <> nil do
   begin
   TOBL.free;
   TOBL := TOBBasesRG.findnext (['INDICERG'],[Ligne],true);
   end;
end;

procedure CalculeLigneBasesRG(TOBPIECERG,TOBB,TOBBRG: TOB;Taux:double;Dev:Rdevise;IndiceRg:Integer);
begin
TOBBRG.PutValue ('PBR_NATUREPIECEG',TOBB.GetValue('GPB_NATUREPIECEG'));
TOBBRG.PutValue ('PBR_DATEPIECE',TOBB.GetValue('GPB_DATEPIECE'));
TOBBRG.PutValue ('PBR_SOUCHE',TOBB.GetValue('GPB_SOUCHE'));
TOBBRG.PutValue ('PBR_NUMERO',TOBB.GetValue('GPB_NUMERO'));
TOBBRG.PutValue ('PBR_INDICEG',TOBB.GetValue('GPB_INDICEG'));
TOBBRG.Putvalue('INDICERG',IndiceRG);
TOBBRG.PutValue ('PBR_CATEGORIETAXE',TOBB.GetValue('GPB_CATEGORIETAXE'));
TOBBRG.PutValue ('PBR_FAMILLETAXE',TOBB.GetValue('GPB_FAMILLETAXE'));
TOBBRG.PutValue ('PBR_TAUXTAXE',TOBB.GetValue('GPB_TAUXTAXE'));
TOBBRG.PutValue ('PBR_TAUXDEV',DEV.Taux );
TOBBRG.PutValue ('PBR_COTATION',dev.Cotation);
TOBBRG.PutValue ('PBR_DATETAUXDEV',DEV.DateTaux);
TOBBRG.PutValue ('PBR_DEVISE',DEV.Code );
TOBBRG.PutValue ('PBR_SAISIECONTRE',TOBB.GetValue('GPB_SAISIECONTRE'));
TOBBRG.PutValue ('PBR_BASEDEV',arrondi(TOBB.GetValue('GPB_BASEDEV')*Taux,DEV.Decimale  ));
TOBBRG.PutValue ('PBR_VALEURDEV',arrondi(TOBBRG.GetValue('PBR_BASEDEV')*(TOBBRG.GetValue('PBR_TAUXTAXE')/100),DEV.Decimale ));
ReAjusteMontants (TOBBRG,DEV);
end;

procedure DeduitsPortRg (TOBBasesRg,TOBporcs : TOB; Taux : double; DEv : RDevise; IndiceRG : integer);
var Indice : integer;
		TOBP, TOBBRG : TOB;
    MtPort : double;
begin
	if TOBPorcs = nil then exit;
	for Indice := 0 to TOBPorcs.detail.count -1 do
  begin
  	TOBP := TOBporcs.detail[Indice];
    if TOBP.GetValue('GPT_FRAISREPARTIS') = 'X' then Continue; {ce sont des frais donc pas inclus dans le calcul}
    MtPort := Arrondi(TOBP.GetValue('GPT_TOTALHTDEV')*taux,DEV.decimale);
    TOBBRG := TOBBasesRG.findFirst(['INDICERG','PBR_CATEGORIETAXE','PBR_FAMILLETAXE'],[indiceRG,'TX1',TOBP.getValue('GPT_FAMILLETAXE1')],true);
    repeat
    	if TOBBRG <> nil then
      begin
      	TOBBRG.PutValue ('PBR_BASEDEV',arrondi(TOBBRG.GetValue('PBR_BASEDEV')-MtPort,DEV.decimale ));
        TOBBRG.PutValue ('PBR_VALEURDEV',arrondi(TOBBRG.GetValue('PBR_BASEDEV')*(TOBBRG.GetValue('PBR_TAUXTAXE')/100),DEV.Decimale ));
        ReAjusteMontants (TOBBRG,DEV);
      end;
    	TOBBRG := TOBBasesRG.FindNext (['INDICERG','PBR_CATEGORIETAXE','PBR_FAMILLETAXE'],[IndiceRg,'TX1',TOBP.getValue('GPT_FAMILLETAXE1')],true);
    until TOBBRG = nil;
  end;
end;

// Calcul des elements TVA
procedure CalculeTvaRg (TOBPieceRg,TOBBases,TOBBasesRg,TOBporcs : TOB;DEv:Rdevise;Taux:double;IndiceRG:Integer;Var TotTaxes:double);
var MTTva,MtTvaDev : double;
    Indice : integer;
    TOBB,TOBBRG : TOB;
begin
  if TOBPieceRG = nil then exit;
  TotTaxes:=0;
  VideBasesRGLigne (TOBBasesRg,IndiceRG);
  MTTva:=0; MTTvaDev :=0;
  for Indice:= 0 to TOBBASES.detail.count -1 do
    begin
    TOBB:=TOBBases.detail[Indice];
    TOBBRG := TOB.Create('PIEDBASERG',TOBBASESRG,-1);
    TOBBRG.addChampsupvaleur ('INDICERG',IndiceRG);
    CalculeLigneBasesRG(TOBPIECERG,TOBB,TOBBRG,Taux,DEV,IndiceRg);
  end;
  // Deduction des ports et frais
  DeduitsPortRg (TOBBasesRg,TOBporcs,Taux,DEV,IndiceRG);
  // recalcul des Tvas sur RG
  for Indice:= 0 to TOBBASESRG.detail.count -1 do
  begin
    TOBBRG := TOBBASESRG.detail[indice];
    if (TOBBRG.getValue ('INDICERG')<>IndiceRg) then continue;
    MTTva := MTTva+TOBBRG.GetValue('PBR_VALEURTAXE');
    MTTvaDev := MTTvaDev+TOBBRg.GetValue('PBR_VALEURDEV');
  end;
	TotTaxes := MtTvaDev;
end;

function CalculPort (EnHt: boolean;TOBPorcs : TOB) : double;
var i : integer;
begin
  result := 0;
  if TOBPorcs <> nil then
  begin
    if EnHt then
    begin
      for i := 0 to TOBPorcs.Detail.Count - 1 do
      if TOBPorcs.Detail[i].GetValue('GPT_FRAISREPARTIS') <> 'X' then Result := Result + TOBPorcs.Detail[i].GetValue('GPT_TOTALHTDEV');
    end else
    begin
      for i := 0 to TOBPorcs.Detail.Count - 1 do
      if TOBPorcs.Detail[i].GetValue('GPT_FRAISREPARTIS') <> 'X' then Result := Result + TOBPorcs.Detail[i].GetValue('GPT_TOTALTTCDEV');
    end;
  end;
  Result := Arrondi(Result, 6);
end;

// bouttade
procedure CalculeRGSimple (TOBPorcs,TOBPIECE,TOBRG,TOBBASES,TOBBASESRG: TOB;DEV:Rdevise);

var ValInterm,TauxRg,MontantTaxes : double;
    IndiceRg : integer;
    TypeRg : string;
    XPorcHT,XPorcTTC : double;
begin
if TOBRG = nil then exit;
if TOBRG.GetValue('PRG_TAUXRG') <> 0 then
   begin
   // Taux retenue
   TAuxRg := TOBRG.GetValue('PRG_TAUXRG');
   TypeRg := TOBRG.GetValue('PRG_TYPERG');
   XPorcHt := 0;XPorcTTC := 0;
   // Element HT
   XPorcHt := CalculPort (True,TOBPorcs);
   ValInterm := arrondi ((TOBPIece.getValue('GP_TOTALHTDEV') - XporcHt)*(TauxRg /100),DEV.decimale);
   TOBRG.putvalue('PRG_MTHTRGDEV',ValInterm);
   // Element TTC
   XPorcTTC := CalculPort (False,TOBPorcs);
   ValInterm := arrondi ((TOBPIece.getValue('GP_TOTALTTCDEV') - XPorcTTC)*(TauxRg /100),DEV.decimale);
   TOBRG.putvalue('PRG_MTTTCRGDEV',ValInterm);

   IndiceRg := TOBRG.GetValue('INDICERG');
   // Element bases de tva
   CalculeTvaRg (TOBRG,TOBBases,TOBBasesRg,TOBPorcs,DEv,TauxRg/100,IndiceRG,MontantTaxes);
   // Reajustement Ht ou TTC en fonction du type de retenue
   if TypeRg = 'HT' then
      begin
      TOBRG.putvalue('PRG_MTTTCRGDEV',TOBRG.GetValue('PRG_MTHTRGDEV')  +MontantTaxes);
      end else
      begin
      TOBRG.putvalue('PRG_MTHTRGDEV',TOBRG.GetValue('PRG_MTTTCRGDEV') -MontantTaxes);
      end;
//
   ReAjusteMontants (TOBRG,DEV);
//
   // Element Caution Banquaire
   if (TOBRG.getValue('PRG_NUMCAUTION')='') and (TOBRG.getValue('PRG_BANQUECP')<>'')then
      begin
      if TOBPiece.getValue('GP_NATUREPIECEG')='DBT' then
      	begin
        ValInterm := arrondi ((TOBPIece.getValue('GP_TOTALTTC') - XporcTTC )*(TauxRg /100),V_PGI.okdecv);
        TOBRG.putvalue('PRG_CAUTIONMT',ValInterm);
        ValInterm := arrondi ((TOBPIece.getValue('GP_TOTALTTCDEV') - XporcTTC) *(TauxRg /100),DEV.decimale);
        TOBRG.putvalue('PRG_CAUTIONMTDEV',ValInterm);
      	end;
      end;
   end;
end;

function RecupDebutRG (TOBpiece : TOB;Indice : Integer): Integer;
var
   TOBL : TOB;
   Ind,ITypA: Integer;
begin
result := 0;
if Indice <= 0 then exit;
ITypA :=TOBPiece.detail[Indice].GetNumChamp ('GL_TYPEARTICLE');
for ind := Indice downto 0 do
    begin
    TOBL := TOBPiece.detail[Ind];
    if (TOBL.GetValeur (ITypA) = 'EPO') then
      begin
      // On prend en compte jusqu'a la retenue de garantie précédente
      result := Ind + 1;
      break;
      end;
    end;
end;

procedure VidePieceRGLigne (TOBPieceRG: TOB;Ligne : integer);
var TOBL : TOB;
begin
if TOBPieceRG = nil then exit;
TOBL := TOBPieceRG.findfirst (['INDICERG'],[Ligne],true);
while TOBL <> nil do
   begin
   TOBL.Putvalue('PRG_MTHTRG',0);
   TOBL.Putvalue('PRG_MTHTRGDEV',0);
   TOBL.Putvalue('PRG_MTTTCRG',0);
   TOBL.Putvalue('PRG_MTTTCRGDEV',0);
   if TOBL.getValue('PRG_NUMCAUTION') = '' then
      begin
      TOBL.Putvalue('PRG_CAUTIONMT',0);
      TOBL.Putvalue('PRG_CAUTIONMTDEV',0);
      end;
   TOBL := TOBPieceRG.findnext (['INDICERG'],[Ligne],true);
   end;
end;

procedure AlimenteValoLigneRg (TOBPiece,TOBLIG,TOBPieceRG,TOBBasesRG : TOB;EnHt:boolean; TypeL:RGmode);
var XP,XD,TP,TD : double;
begin
if TypeL = RgStd then
   begin
   TOBLIG.PutValue('GL_QTEFACT',TOBPIECERG.getValue('PRG_TAUXRG'));
   TOBLIG.PutValue('GL_PRIXPOURQTE',100);
   TOBLIG.PutValue('GL_QUALIFQTEVTE','%');
   end;
GetValueRg (TOBPIECERG,XP,XD,True);
if TOBBasesRG<>nil then
   begin
   GetCumulTaxeByIndice (TOBPIECE,TOBPIECERG,TOBBasesRG,TP,TD);
   end;
if ((EnHt) and (TOBPIecerg.GetValue('PRG_TYPERG')='HT')) or
  ( (not EnHt) and (TOBPIecerg.GetValue('PRG_TYPERG')='TTC')) then
  begin
  if TypeL = RGstd then
     begin
     TOBLIG.PutValue('GL_PUHT',TOBPIECE.getValue('GP_TOTALHT'));
     TOBLIG.PutValue('GL_PUHTDEV',TOBPIECE.getValue('GP_TOTALHTDEV'));
     TOBLIG.PutValue('GL_PUTTC',TOBPIECE.getValue('GP_TOTALTTC'));
     TOBLIG.PutValue('GL_PUTTCDEV',TOBPIECE.getValue('GP_TOTALTTCDEV'));
     end;
  TOBLIG.PutValue('GL_MONTANTHT',XP-TP);
  TOBLIG.PutValue('GL_MONTANTHTDEV',XD-TD);
  TOBLIG.PutValue('GL_MONTANTTTC',XP);
  TOBLIG.PutValue('GL_MONTANTTTCDEV',XD);
  end else
  begin
  if TypeL = RGstd then
     begin
     TOBLIG.PutValue('GL_PUHT',TOBPIECE.getValue('GP_TOTALTTC'));
     TOBLIG.PutValue('GL_PUHTDEV',TOBPIECE.getValue('GP_TOTALTTCDEV'));
     TOBLIG.PutValue('GL_PUTTC',TOBPIECE.getValue('GP_TOTALHT'));
     TOBLIG.PutValue('GL_PUTTCDEV',TOBPIECE.getValue('GP_TOTALHTDEV'));
     end;
  TOBLIG.PutValue('GL_MONTANTHT',XP);
  TOBLIG.PutValue('GL_MONTANTHTDEV',XD);
  TOBLIG.PutValue('GL_MONTANTTTC',XP-TD);
  TOBLIG.PutValue('GL_MONTANTTTCDEV',XD-TD);
  end;
end;
//
procedure RGVersLigne (TOBPiece,TOBPieceRG,TOBBasesRG,TOBLIG,TOBLigneRG : TOB; Applicretenue: boolean; GenerationFac : boolean=false);
var EnHt:boolean;
    CautionUsed , CautionUsedDev : double;
    MyCautionRest : double;
    MaxNumOrdre : integer;
begin
CautionUsed := 0; CautionUsedDev := 0;
if (GenerationFac) and (TOBPieceRG.fieldExists ('PIECEPRECEDENTE')) and (TOBPieceRG.getValue('PRG_NATUREPIECEG')<>'ABT') then
begin
	GetCautionAlreadyUsed (TOBPieceRG.getVAlue('PIECEPRECEDENTE'),CautionUsed,CautionUsedDev);
end;
MyCautionRest:=0;
if TOBPieceRG = nil then exit;
EnHt:=(TOBPiece.GetValue('GP_FACTUREHT')='X');
TOBLIG.Putvalue('GL_TYPELIGNE','RG');
if TOBPIeceRG.GetValue('PRG_CAUTIONMTDEV') <> 0 then
   begin
   MyCautionRest := TOBPIeceRG.GetValue('PRG_CAUTIONMTDEV') - CautionUsedDev - TOBPIeceRG.GetValue('PRG_MTTTCRGDEV');
   if MyCautionRest < 0 then MyCautionRest := 0;
   end;
if (TOBPIECERG.GetValue('PRG_NUMCAUTION')<> '') and (TOBPiece.getValue('PRG_NATUREPIECEG')<>'ABT') then
   begin
      if TOBPIECERG.GetValue('PRG_MTTTCRGDEV') <= (MyCautionrest) then
      begin
   //Caution Bancaire
      TOBLIG.Putvalue('GL_LIBELLE','Caution Bancaire sur Retenue de Garantie')
      end else
      begin
      AlimenteValoLigneRg (TOBPiece,TOBLIG,TOBPieceRG,TOBBasesRG,EnHt,RgDepass);
      TOBLIG.Putvalue('GL_LIBELLE','RG sur dépassement de caution '+TOBPIeceRg.getValue('PRG_TYPERG'));
      //
      TOBLIG.putValue('GL_MONTANTHTDEV',Abs(TOBPIeceRG.GetValue('PRG_CAUTIONMTDEV') - CautionUsedDev - TOBPIeceRG.GetValue('PRG_MTTTCRGDEV')));
      //
      end;
   end else
   begin
      AlimenteValoLigneRg (TOBPiece,TOBLIG,TOBPieceRG,TOBBasesRG,EnHt,RGstd);
      TOBLIG.Putvalue('GL_LIBELLE','Retenue de Garantie '+TOBPIeceRg.getValue('PRG_TYPERG')+' de '+floattostr(TOBPIECERG.GetValue('PRG_TAUXRG'))+ '%');
   end;
if not ApplicRetenue then TOBLIG.Putvalue('GL_NONIMPRIMABLE','X');
if (TOBLigneRG <> nil) and (TOBLigneRG.FieldExists('PIECEPRECEDENTE')) then TOBLIG.PutVAlue ('GL_PIECEPRECEDENTE',TOBLigneRG.GetValue('PIECEPRECEDENTE'));
if (TOBPieceRG <> nil) and (TOBPieceRG.FieldExists('NUMORDRE')) and (TOBPieceRG.GEtVAlue('NUMORDRE') <> 0)  then
begin
	TOBLIG.PutValue('GL_NUMORDRE',TOBPieceRG.GEtVAlue('NUMORDRE'));
end else
begin
	MaxNumOrdre := GetMaxNumOrdre (TOBPiece);
	TOBLIG.PutValue('GL_NUMORDRE',MaxNumordre);
end;

end;

procedure CalculBaseRG (TOBTiers,TOBPiece,TOBPieceTrait,TOBBasesL,TOBPIeceRG,TOBBasesRg,TOBS: TOB ; TOBPorcs: TOB; R_Valeurs : R_CPercent;DEV:Rdevise;GenerationFac:boolean=false);
var
   TOBL,TOBBases,TOBPIECELOC,TOBRG,TOBLLOC,TOBPorcsLoc,TOBBasesLoc,TOBBL: TOB;
   Indice,INdL,IndiceRg : Integer;
   IPuHt,IpuHtdev,IpuTTC,iputtcdev,iMontHt,imontHtDev,iMontTTC : integer;
   iMontTTCdev: integer;
   bid1,bid2,bid3,bid4 : double;
   Applicretenue : boolean;
   PortHt,PortTTC : double;
   NumOrdre : integer;
   TOBB : TOB;
   TOBTaxes : TOB;
begin
  if TOBPieceRG = nil then exit;
  ApplicRetenue:=(GetInfoParPiece(TOBPIECE.GetValue('GP_NATUREPIECEG'),'GPP_APPLICRG')='X');
  TOBPIECELOC:=TOB.create ('PIECE',nil,-1);
  TOBPorcsLoc := TOB.Create ('LES PORTS LOC',nil,-1);
  TOBBasesLoc := TOB.Create ('LES BASES LIGNES',nil,-1);
  TOBLLOC:=TOB.Create('LIGNE',nil,-1);
  TOBBases := TOB.create('BASES PIED(LIGNES)',nil,-1);
  //
  AddLesSupEntete (TOBpieceLoc);
  TOBPieceLOC.dupliquer (TOBPIECE,false,true);
  ZeroFacture (TOBpieceloc);
  //
  AddLesSupLigne (TOBLLOc,false);
  //
  IndiceRg := TOBS.GetValue('INDICERG');
  TOBPorcsLoc.Dupliquer (TOBPorcs,true,true);
  //
  TOBBasesLoc.Dupliquer (TOBBasesL,true,true);
  // nettoyage avant création
  VidePieceRGLigne (TOBPieceRG,IndiceRG);
  // --
  ZeroLignePourcent(TOBS) ;
  ZeroLignePourcent(TOBLLOC) ;
  IndL := 0;
  IPuHt := 0;
  IPuHtdev := 0;
  IPuTTC := 0;
  IPuttcdev := 0;
  IMOntHt := 0;
  IMOntHtDev := 0;
  IMOntttc := 0;
  IMOntttcDev := 0;
  for Indice := R_Valeurs.Depart to R_Valeurs.Fin do
  begin
    TOBL := GetTOBLigne(TOBPiece,Indice+1 ) ; if TOBL = nil then break;
    NumOrdre := TOBL.getValue('GL_NUMORDRE');
    if Indice = R_Valeurs.Depart then
    begin
      IndL := TOBL.GetNumChamp ('GL_TYPELIGNE');
      // PU HT
      IPuHtDev := TOBL.GetNumChamp ('GL_PUHTDEV');
      IPuHt := TOBL.GetNumChamp ('GL_PUHT');
      // PU TTC
      IPuTTCDev := TOBL.GetNumChamp ('GL_PUTTCDEV');
      IPuTTC := TOBL.GetNumChamp ('GL_PUTTC');
      // Montant Ht
      IMontHt := TOBL.GetNumChamp ('GL_TOTALHT');
      IMontHtDev := TOBL.GetNumChamp ('GL_TOTALHTDEV');
      // Montant TTC
      IMontTTC := TOBL.GetNumChamp ('GL_TOTALTTC');
      IMontTTCDev := TOBL.GetNumChamp ('GL_TOTALTTCDEV');
      // -------
    end;
    if TOBL.GetValeur(INDL) = 'EPO' then break;
    // VARIANTE
    //    if isVariante(TOBL) then continue;
    if (isVariante(TOBL))
    {$IFDEF BTP}
    		or (IsCentralisateurBesoin(TOBL))
		    or (TOBL.GetValue('GL_TYPEARTICLE') = '$#$') then continue;
    {$ENDIF}
    // --
    if (TOBL.getvaleur(INDL) = 'RG' ) then continue;
    if (TOBL.getvalue('GL_ARTICLE') = '' ) then continue;
    SommeLignePiedHT (TOBL,TOBpieceLoc);
    TOBBL := FindLignesbases (numordre,TOBBasesL);
    if TOBBL <> nil then CumuleLesBases (TOBBases, TOBBL,DEV.Decimale);
    (*
    // Maj PU HT
    TOBLLOC.PutValeur(IPuHtDev,TOBLLOC.GetValeur(IpuHtDev)+TOBL.GetValeur(IMontHtDev)) ;
    TOBLLOC.PutValeur(IPuHt,TOBLLOC.GetValeur(IpuHt)+TOBL.GetValeur(IMontHt)) ;
    // Maj Pu TTC
    TOBLLOC.PutValeur(IPuttc,TOBLLOC.GetValeur(IpuTTC)+TOBL.GetValeur(IMontTTC)) ;
    TOBLLOC.PutValeur(IPuttcDev,TOBLLOC.GetValeur(IpuTTCdev)+TOBL.GetValeur(IMontTTCDev)) ;
    //
    *)
  end;
  (*
  TOBPieceLOc.putvalue('GP_TOTALHT',TOBLLOC.getValeur (IpuHt));
  TOBPieceLOc.putvalue('GP_TOTALHTDEV',TOBLLOC.getValeur (IpuhtDev));
  TOBPieceLOc.putvalue('GP_TOTALTTC',TOBLLOC.getValeur (IpuTtc));
  TOBPieceLOc.putvalue('GP_TOTALTTCDEV',TOBLLOC.getValeur (IpuTtcDev));
  *)
  // --
  RecalculPiedPort (tamodif,TOBpieceLoc,TOBporcsloc);
  AddlesPorts (TOBPIECELOC,TOBPorcsLoc,TOBBases,TOBBasesLoc,TOBtiers,DEv,TaCreat);

  TOBRG := TOBPieceRG.findfirst (['INDICERG'],[IndiceRG],true);
  if TOBRG <> nil then
  begin
    CalculeRGSimple (TOBPorcsLoc,TOBPIECELOC,TOBRG,TOBBases,TOBBASESRG,DEV);
    RGVersLigne (TOBPIECELOC,TOBRG,TOBBasesRG,TOBS,nil,Applicretenue,GenerationFac);
  end;
  // nettoyage avant départ
  TOBPIECELOC.free;
  TOBPorcsLoc.free;
  TOBBasesLoc.free;
  TOBLLOC.free;
  TOBBases.free;
end;

function RGMultiple (TOBpiece:TOB):boolean;
var nbr:integer;
		TOBLL : TOB;
begin
  result := false;
  if TOBpiece.getValue('GP_RGMULTIPLE')='X' then
  begin
  	result := true;
    exit;
  end;
end;


procedure InsereLigneRG(TOBPiece,TOBRg,TOBBASEs,TOBBRG,TOBTIers,TOBAffaire,TOBLigneRG: TOB;NumIndice:integer);
var TOBLoc,TOBBRGL:TOB;
    numl,i : integer;
    ApplicRetenue: boolean;
begin
if TOBRG = nil then exit;
if RGMultiple(TOBpiece) then exit;
ApplicRetenue:=(GetInfoParPiece(TOBPIECE.GetValue('GP_NATUREPIECEG'),'GPP_APPLICRG')='X');
if TOBRg.getValue('PRG_TAUXRG') = 0 then exit;
TOBLOC:=NewTOBLigne (TOBPIECE,numIndice+1);
if NumIndice = -1 then NumL:=TOBPiece.Detail.Count else NumL:=NumIndice+1;
InitialiseTOBLigne(TOBPiece,TOBTiers,TOBAffaire,NumL) ;
RGVersLigne (TOBPiece,TOBRG,TOBBRG,TOBLOC,TobLigneRG,ApplicRetenue);
TOBLOC.putvalue('INDICERG',1);
TOBRG.putvalue('PRG_NUMLIGNE',Numl);
TOBRG.putvalue('INDICERG',1);
for i:=0 to TOBBRG.detail.count-1 do
    begin
    TOBBRGL := TOBBRG.detail[i];
    TOBBRGL.putvalue('PBR_NUMLIGNE',Numl);
    TOBBRGL.putvalue('INDICERG',1);
    end;
end;

procedure RecalculeRG (TOBPorcs,TOBPIECE,TOBPIECERG,TOBBASES,TOBBASESRG : TOB;DEV:Rdevise);
var TOBRG : TOB;
BEGIN
if (TOBPieceRG=nil) or (TOBPieceRG.detail.count<>1) then exit;
TOBRG := TOBPIECERG.detail[0];
CalculeRGSimple (TOBPorcs,TOBPIECE,TOBRG,TOBBASES,TOBBASESRG,DEV);
END;

function GetCumultextRG (TOBPIeceRG:TOB;Nomchamp : string) : string;
var ind: integer;
    TOBLOC : TOB;
begin
result := '';
if TOBPieceRG = nil then exit;
for ind:=0 to TOBPIECERG.detail.count -1 do
    begin
    TOBLOc := TOBPIECERG.detail[ind];
    Result:= TOBLoc.GetValue(nomchamp);
    end;
end;

function GetCumulValueRG (TOBPIeceRG:TOB;Nomchamp : string) : variant;
var ind: integer;
    TOBLOC: TOB;
begin
result := 0;
if TOBPieceRG = nil then exit;
for ind:=0 to TOBPIECERG.detail.count -1 do
    begin
    TOBLOc := TOBPIECERG.detail[ind];
    if (Nomchamp='PRG_TAUXRG') then
       begin
       Result:= TOBLOC.GetValue(nomchamp);
       break;
       end;
    if (Nomchamp='PRG_MTHTRGDEV') or (Nomchamp='PRG_MTTTCRGDEV') then
       begin
       result := result + TOBLOC.GetValue(nomchamp);
       end;
    end;
end;

function GetCumulValueTaxeRG (TOBBasesRG:TOB;Nomchamp : string) : variant;
var ind: integer;
    TOBLOC: TOB;
begin
result := 0;
if TOBbasesRG = nil then exit;
for ind:=0 to TOBbasesRG.detail.count -1 do
    begin
    TOBLOc := TOBBasesRG.detail[ind];
    if (Nomchamp='PBR_VALEURDEV') then
       begin
       Result:= result+TOBLOC.GetValue(nomchamp);
       break;
       end;
    end;
end;

procedure GetMontantRG (TOBPIeceRG,TOBBasesRG : TOB;var XD,XP : double;DEV:Rdevise;HtForce:boolean=false;HorsCaution:boolean=false);
var XXD,XXP : double;
    XTD,XTP : double;
    Enht : Boolean;
begin
XD := 0; XP :=0;
if TOBPieceRG = nil then exit;
EnHt := (GetCumulTextRG (TOBPieceRG,'PRG_TYPERG') = 'HT');
GetCumulRG (TOBPieceRG,XXP,XXD,not HorsCaution ); // Valeur residuelle TTC de RG
XD := XXD;
XP := XXP;
if (EnHt) or (HtForce) then
   begin
   GetCumulTaxesRG (TOBBasesRG,TOBPieceRG,XTD,XTP,DEV); // Tva Residuelle
   XD := XXD - XTD;  // HT = TTC - TVA
   XP := XXP - XTP;  // HT = TTC - TVA
   end;
end;

procedure GetCumulRG (TOBPieceRG : TOB; var SommePivot,SommeDevise : double;initial:boolean=false);
var TOBRG : TOB;
    indice : integer;
    MyCautionRest : double;
    LocPivot,LocDevise : double;
begin
SommePivot:=0; SommeDevise := 0;
if (TOBPieceRG=nil) then exit;
for indice:=0 to TOBPieceRG.detail.count -1 do
    begin
    TOBRG := TOBPIeceRG.detail[Indice];
    LocPivot := TOBRG.GetValue('PRG_MTTTCRG');
    LocDevise := TOBRG.GetValue('PRG_MTTTCRGDEV');
    if (TOBRG.GetValue('PRG_NUMCAUTION')<> '') and (not initial) then
       begin
       MyCautionRest := TOBRG.GetValue('PRG_CAUTIONMT') - TOBRG.GetValue('PRG_CAUTIONMTU');
       if MyCautionRest < 0 then MyCautionRest := 0;
       LocPivot:= LocPivot - (MyCautionRest);
       MyCautionRest := TOBRG.GetValue('PRG_CAUTIONMTDEV') - TOBRG.GetValue('PRG_CAUTIONMTUDEV');
       if MyCautionRest < 0 then MyCautionRest := 0;
       LocDevise := LocDevise - (MyCautionRest);
       end;
    if TOBRG.GetValue('PRG_NATUREPIECEG')<>'ABT' then
    begin
      if LocPivot < 0 then LocPivot:=0;
      if LocDevise < 0 then LocDevise:=0;
    end;
    SommePivot := SommePivot + LocPivot;
    SommeDevise := SommeDevise + LocDevise;
    end;
end;

procedure GetRGByIndice (TOBPieceRG:TOB; Indice : integer;var RGRP,RGRD:double; Reliquat: boolean=false);
var TOBLOC : TOB;
begin
RGRP:=0;RGRD:=0;
if TOBPieceRG=nil then exit;
TOBLOC:=TOBPIECERG.findfirst(['INDICERG'],[Indice],true);
if TOBLOC <> nil then
   begin
   GetValueRg (TOBLoc,RGRP,RGRD,Reliquat);
   end;
end;

procedure GetRGByLigne (TOBPieceRG:TOB; Ligne : integer;var RGRP,RGRD:double; Reliquat: boolean=false);
var TOBLOC : TOB;
begin
RGRP:=0;RGRD:=0;
if TOBPieceRG=nil then exit;
TOBLOC:=TOBPIECERG.findfirst(['PRG_NUMLIGNE'],[Ligne],true);
if TOBLOC <> nil then
   begin
   GetValueRg (TOBLoc,RGRP,RGRD,Reliquat);
   end;
end;

procedure RecupPosition (TOBBasesRG:TOB; CatTaxe,CodeTaxe:String; var Mode:integer; var Indice:integer);
var TOBB : TOB;
    ind : integer;
begin
Indice:=-1;
if TOBBasesRG = nil then exit;
Mode:= TRGModeInsertion;
for ind:=0 to TOBBasesRG.detail.count -1 do
    begin
    TOBB:=TOBBasesRG.detail[Ind];
    if (CatTAxe = TOBB.GetValue ('PBR_CATEGORIETAXE')) and (CodeTaxe = TOBB.GetValue ('PBR_FAMILLETAXE')) then
       begin
       Mode := TRGModeModif;
       Indice := ind;
       break;
       end;
    end;
end;

procedure InsereOuUpdate (TOBBasesRG,TOBBasesGlob,TOBPieceRG,TOBTvaMillieme : TOB);
var Indice : integer;
    Mode : integer;
    CatTaxe,Codetaxe : string;
    TOBLOC : TOB;
    DEV:Rdevise;
    Ratio,Millieme : double;
    RGRP,RGRD,RGD,RGP : double;
begin
if TOBBasesRg = nil then exit;
Millieme := 1;
CatTaxe := TOBBasesRg.GetValue('PBR_CATEGORIETAXE');
CodeTaxe := TOBBasesRg.GetValue('PBR_FAMILLETAXE');
(*
TOBMILLIEME := TOBTVAMillieme.findFirst(['BPM_CATEGORIETAXE','BPM_FAMILLETAXE'],[CatTaxe,CodeTaxe],true);
if TOBMillieme <> nil then Millieme := TOBMillieme.GetValue('BPM_MILLIEME')/1000;
*)
RecupPosition ( TOBBasesGlob,CatTaxe,CodeTaxe,Mode,Indice);
if Mode=TRGModeInsertion then
   begin
   TOBLOC:=TOB.create('PIEDBASERG',TOBBasesGlob,Indice);
   TOBLOC.InitValeurs;
   TOBLOC.addChampsupvaleur ('INDICERG',1);
   TOBLOC.putvalue('PBR_NATUREPIECEG',TOBBasesRG.GetValue('PBR_NATUREPIECEG'));
   TOBLOC.putvalue('PBR_DATEPIECE',TOBBasesRG.GetValue('PBR_DATEPIECE'));
   TOBLOC.putvalue('PBR_SOUCHE',TOBBasesRG.GetValue('PBR_SOUCHE'));
   TOBLOC.putvalue('PBR_NUMERO',TOBBasesRG.GetValue('PBR_NUMERO'));
   TOBLOC.putvalue('PBR_INDICEG',TOBBasesRG.GetValue('PBR_INDICEG'));
   TOBLOC.putvalue('PBR_CATEGORIETAXE',TOBBasesRG.GetValue('PBR_CATEGORIETAXE'));
   TOBLOC.putvalue('PBR_FAMILLETAXE',TOBBasesRG.GetValue('PBR_FAMILLETAXE'));
   TOBLOC.putvalue('PBR_TAUXDEV',TOBBasesRG.GetValue('PBR_TAUXDEV'));
   TOBLOC.putvalue('PBR_COTATION',TOBBasesRG.GetValue('PBR_COTATION'));
   TOBLOC.putvalue('PBR_DATETAUXDEV',TOBBasesRG.GetValue('PBR_DATETAUXDEV'));
   TOBLOC.putvalue('PBR_DEVISE',TOBBasesRG.GetValue('PBR_DEVISE'));
   TOBLOC.putvalue('PBR_SAISIECONTRE',TOBBasesRG.GetValue('PBR_SAISIECONTRE'));
   end else
   begin
   TOBLOC:=TOBBasesGlob.detail[Indice];
   end;
   DEV.Code:=TOBBasesRG.getValue('PBR_DEVISE') ; GetInfosDevise(DEV) ;
   // recupere le reliquat de RG par ligne
   GetRGByIndice (TOBPieceRG, TOBBasesRG.GetValue('INDICERG'),RGRP,RGRD,True);
   GetRGByIndice (TOBPieceRG, TOBBasesRG.GetValue('INDICERG'),RGP,RGD);
   if RGD <> 0 then Ratio := RGRD / RGD else Ratio := 0;
   //
//   TOBLOC.PutValue('PBR_BASETAXE',RGRP) ;
//   TOBLOC.PutValue('PBR_BASEDEV',RGRD) ;
   TOBLOC.PutValue('PBR_BASETAXE',TOBLOC.GetValue('PBR_BASETAXE')+(TOBBasesRG.GetValue('PBR_BASETAXE')*Ratio)) ;
   TOBLOC.PutValue('PBR_BASEDEV',TOBLOC.GetValue('PBR_BASEDEV')+(TOBBasesRG.GetValue('PBR_BASEDEV')*Ratio)) ;

   TOBLOC.PutValue('PBR_VALEURTAXE',TOBLOC.GetValue('PBR_VALEURTAXE') + (TOBBasesRg.GetValue('PBR_VALEURTAXE')*Ratio)) ;
   if DEV.code <>V_PGI.DevisePivot then
      TOBLOC.PutValue('PBR_VALEURDEV',TOBLOC.GetValue('PBR_VALEURDEV') + (TOBLOC.GetValue('PBR_VALEURDEV')*Ratio))
      else TOBLOC.PutValue('PBR_VALEURDEV',TOBLOC.GetValue('PBR_VALEURTAXE') );
end;

procedure FusionneTva (TOBTAXERG,TOBTAXEGLOB,TOBPIECERG,TOBTvaMillieme: TOB; Avoir : boolean=false);
var indice : integer;
    TOBLOc : TOB;
    DEV : Rdevise;
    XD,Xp,TheMontantRGTTC : double;
begin
TOBTaxeGlob.ClearDetail;
if TOBTaxeRg = nil then exit;
//
GetCumulRG (TOBPIeceRG,XP,XD,True);
TheMontantRGTTC := XD;
GetReliquatCaution (TOBPieceRg,XP,XD);
TheMontantRGTTC := TheMontantRGTTC - XD;
if not Avoir then
begin
  if TheMontantRGTTC < 0 then TheMontantRGTTC := 0;
end;
if TheMontantRgTTc = 0 then exit;
//

for Indice := 0 to TOBTaxeRG.detail.count -1 do
    begin
    TOBLOC:=TOBTaxeRG.detail[Indice];
    InsereouUpdate (TOBLOC,TOBTAXEGLOB,TOBPieceRG,TOBTvaMillieme);
    end;
for Indice := 0 to TOBTaxeGLOB.detail.count -1 do
    begin
    TOBLOC:=TOBTaxeGlob.detail[Indice];
    if Indice = 0 then
       begin
       DEV.Code:=TOBLOC.getValue('PBR_DEVISE') ;
       GetInfosDevise(DEV) ;
       end;
    TOBLOC.putValue('PBR_VALEURDEV',arrondi (TOBLOC.getValue('PBR_VALEURDEV'),DEV.decimale));
    ReAjusteMontants ( TOBLOC,DEV);
    end;
end;

procedure GetLesTaxesRG(TOBBasesRG :TOB; CatTaxe,FamTaxe:String; var RGD,RGP: double) ;
var TOBB : TOB;
begin
RGP:=0 ; RGD:=0 ;
if (TOBBasesRg=nil) then exit;
TOBB:=TOBBasesRG.findfirst(['PBR_CATEGORIETAXE','PBR_FAMILLETAXE'],[CatTaxe,FamTaxe],true);
if TOBB <> nil then
   begin
   GetLaTaxeRG (TOBB,RGD,RGP);
   end;
end;

procedure GetLaTaxeRG(TOBB :TOB; var RGD,RGP: double) ;
begin
RGP := TOBB.getValue('PBR_VALEURTAXE');
RGD := TOBB.getValue('PBR_VALEURDEV');
end;

procedure GetCumulTaxesRG(TOBBasesRG,TOBPieceRG :TOB; var RGD,RGP: double;DEV:Rdevise) ;
var TOBB : TOB;
    indice : integer;
    Ratio : double;
    XD,XP,XRD,XRP : double;
begin
RGP:=0 ; RGD:=0 ;
if (TOBBasesRg=nil) then exit;
for indice := 0 to TOBBasesRg.detail.count -1 do
    begin
    TOBB:=TOBBasesRG.detail[Indice];
    // recupere le reliquat de RG par ligne
    GetRGByIndice (TOBPieceRG, TOBB.GetValue('INDICERG'),XRP,XRD,True);
    GetRGByIndice (TOBPieceRG, TOBB.GetValue('INDICERG'),XP,XD);
    if XD <> 0 then Ratio := XRD / XD else Ratio := 0;
    RGP := RGP + (TOBB.getValue('PBR_VALEURTAXE') * ratio);
    RGD := RGD + (TOBB.getValue('PBR_VALEURDEV') * Ratio);
    end;
RGP := Arrondi(RGP,V_PGI.OkDecV );
RGD := Arrondi(RGD,DEV.decimale);
end;

procedure ReIndiceLigneRg (TOBPieceRG: TOB;NumLigne,IndiceRg: integer);
var TOBL : TOB;
begin
if TOBPieceRG = nil then exit;
TOBL:=TOBPIeceRG.findfirst(['INDICERG'],[IndiceRg],true);
while TOBL <> nil do
   begin
   TOBL.Putvalue('PRG_NUMLIGNE',Numligne);
   TOBL:=TOBPIeceRG.findnext(['INDICERG'],[IndiceRg],true);
   end;
end;

procedure ReIndiceLigneBasesRg (TOBBasesRG: TOB;NumLigne,IndiceRg: Integer);
var TOBL : TOB;
begin
if TOBBasesRG = nil then exit;
TOBL:=TOBBasesRG.findfirst(['INDICERG'],[IndiceRg],true);
while TOBL <> nil do
   begin
   TOBL.Putvalue('PBR_NUMLIGNE',Numligne);
   TOBL:=TOBBasesRG.findnext(['INDICERG'],[IndiceRg],true);
   end;
end;

procedure initLigneRg (TOBRG,TOBPIECE: TOB);
begin
if TOBRG = nil then exit;
TOBRG.PutValue ('PRG_NATUREPIECEG',TOBPIECE.GetValue('GP_NATUREPIECEG'));
TOBRG.PutValue ('PRG_DATEPIECE',TOBPIECE.GetValue('GP_DATEPIECE'));
TOBRG.PutValue ('PRG_SOUCHE',TOBPIECE.GetValue('GP_SOUCHE'));
TOBRG.PutValue ('PRG_NUMERO',TOBPIECE.GetValue('GP_NUMERO'));
TOBRG.PutValue ('PRG_INDICEG',TOBPIECE.GetValue('GP_INDICEG'));
TOBRG.PutValue ('PRG_SAISIECONTRE',TOBPIECE.GetValue('GP_SAISIECONTRE'));
TOBRG.addchampsupValeur ('INDICERG',0);
TOBRG.AddChampSupValeur ('CAUTIONUTIL',0);
TOBRG.AddChampSupValeur ('CAUTIONUTILDEV',0);
end;

function RestitueMontantCautionUtilise (TOBPieceRG : TOB) : boolean;
var TOBLesRG,TOBRG,TOBRGPREC : TOB;
		Q : TQuery;
    indice : integer;
    cledoc : r_cledoc;
begin
	result := true;
	TOBLESRG := TOB.Create ('LES RG INIT', nil,-1);
  for Indice := 0 to TOBPieceRG.detail.count -1 do
  begin
  	TOBRG := TOBPieceRG.detail[Indice];
		if TOBRG.GetValue('PIECEPRECEDENTE') <> '' then
    begin
      DecodeRefPiece (TOBRG.GetValue('PIECEPRECEDENTE'),Cledoc);
      Q:=OpenSQL ( 'SELECT * FROM PIECERG WHERE '+ WherePiece(CleDoc,ttdRetenuG,False)+' AND PRG_NUMLIGNE='+inttostr(cledoc.NumLigne),true,-1, '', True) ;
      if not Q.Eof then
      begin
    		TOBRGPREC := TOB.create ('PIECERG',TOBLESRG,-1);
        TOBRGPREC.SelectDB ('',Q,true);
        TOBRGPREC.PutVAlue('PRG_CAUTIONMTU',TOBRGPREC.GetVAlue('PRG_CAUTIONMTU') - TOBRG.GetValue('PRG_MTTTCRG'));
        TOBRGPREC.PutVAlue('PRG_CAUTIONMTUDEV',TOBRGPREC.GetVAlue('PRG_CAUTIONMTUDEV') - TOBRG.GetValue('PRG_MTTTCRGDEV'));
      end;
      ferme (Q);
    end;
  end;
  if TOBLesRG.detail.count > 0 then
  begin
  	result := TOBLesRG.UpdateDb (false);
  end;
  TOBLEsRG.free;
end;

procedure ReajusteCautionDocOrigine (TOBPIece,TOBPieceRG:TOB; SensAjout : boolean;TOBPieceRG_O:TOB = nil);
var TOBL,TOBRGPREC,TOBPRG_O,TOBLESRG : TOB;
    CleDoc : R_CleDoc;
    XP,XD : double;
    Q : TQuery;
    Indice : integer;
begin
  if TOBPieceRG = nil then exit;
  XP := 0; XD := 0;

  TOBLESRG := TOB.Create ('LES RG INITIALES',nil,-1); // en provenance du devis....

  if (TOBPieceRg_O <> nil) then
  begin
    for indice := 0 to TOBPieceRG_O.detail.count -1 do
    begin
      TOBPRG_O := TOBPieceRG_O.detail[Indice];
      if TOBPRG_O.fieldExists ('PIECEPRECEDENTE') then
      begin
        TOBRGPREC := TOB.create ('PIECERG',TOBLESRG,-1);
        if TOBPRG_O.GetValue('PIECEPRECEDENTE') = '' then continue;
        TOBRGPREC.AddChampSupValeur ('PIECEPRECEDENTE',TOBPRG_O.GetValue('PIECEPRECEDENTE'));
        DecodeRefPiece (TOBPRG_O.GetValue('PIECEPRECEDENTE'),Cledoc);
        Q:=OpenSQL ( 'SELECT * FROM PIECERG WHERE '+ WherePiece(CleDoc,ttdRetenuG,False)+' AND PRG_NUMLIGNE='+inttostr(cledoc.NumLigne),true,-1, '', True) ;
        if not Q.Eof then
        begin
          TOBRGPREC.SelectDB ('',Q,true);
          GetValueRg (TOBPRG_O,XP,XD,false);   // recup de la retenue de garantie utilise
          if TOBRGPREC.GetValue('PRG_CAUTIONMTDEV') <> 0 then
          begin
            TOBRGPREC.PutVAlue('PRG_CAUTIONMTU',TOBRGPREC.GetValue('PRG_CAUTIONMTU')- XP);
            TOBRGPREC.PutVAlue('PRG_CAUTIONMTUDEV',TOBRGPREC.GetValue('PRG_CAUTIONMTUDEV')-XD);
          end;
        end;
        ferme (Q);
      end;
    end;
  end;

  TOBL := TOBPIECE.findfirst(['GL_TYPELIGNE'],['RG'],true);
  WHILE TOBL <> nil do
  BEGIN
    if TOBL.GetValue('GL_PIECEPRECEDENTE') <> '' then
    begin
    	TOBRGPREC := TOBLESRG.findFirst(['PIECEPRECEDENTE'],[TOBL.GetValue('GL_PIECEPRECEDENTE')],true);
      if TOBRGPREC = nil then
      begin
        DecodeRefPiece (TOBL.GetValue('GL_PIECEPRECEDENTE'),Cledoc);
        Q:=OpenSQL ( 'SELECT * FROM PIECERG WHERE '+ WherePiece(CleDoc,ttdRetenuG,False)+' AND PRG_NUMLIGNE='+inttostr(cledoc.NumLigne),true,-1, '', True) ;
        if not Q.Eof then
        begin
					TOBRGPREC := TOB.create ('PIECERG',TOBLesRG,-1);
        	TOBRGPREC.SelectDB ('',Q,true);
        	TOBRGPREC.AddChampSupValeur ('PIECEPRECEDENTE',TOBL.GetValue('GL_PIECEPRECEDENTE'));
        end;
        ferme (Q);
      end;
      if TOBRGPrec <> nil then
      begin
    		GetRGByIndice (TOBPIECERG,TOBL.GetValue('INDICERG'),XP,XD); // recup de la nouvelle retenue de garantie utilisée
        TOBRGPREC.PutVAlue('PRG_CAUTIONMTU',TOBRGPREC.GetValue('PRG_CAUTIONMTU')+XP);
        TOBRGPREC.PutVAlue('PRG_CAUTIONMTUDEV',TOBRGPREC.GetValue('PRG_CAUTIONMTUDEV')+XD);
      end;
      ferme (Q);
    end;
    TOBL := TOBPIECE.findnext(['GL_TYPELIGNE'],['RG'],true);
  END;
  if TOBLESRG.detail.count > 0 then TOBLEsRG.UpdateDb (false);
  TOBLESRG.free;
end;

procedure ReinitRGUtilises (TOBPieceRG : TOB);
var TOBRg : TOB;
    Indice : integer;
begin
if TOBPieceRG = nil then exit;
for Indice := 0 to TOBPieceRG.detail.count -1 do
    begin
    TOBRG := TOBPieceRG.detail[Indice];
    TOBRG.putvalue ('PRG_CAUTIONMTU',0);
    TOBRG.putvalue ('PRG_CAUTIONMTUDEV',0);
    if TOBRG.GetValue('PRG_NATUREPIECEG') = 'DBT' then    // Specif pour la V1 a parametrer plus tard
       begin
       TOBRG.PutVAlue ('PRG_NUMCAUTION','');
       TOBRG.PutVAlue ('PRG_CAUTIONMT',0);
       TOBRG.PutVAlue ('PRG_CAUTIONMTDEV',0);
       end;
    end;
end;

procedure EnregistreNumOrdreRG (TOBgenere,TOBPieceRg : TOB);
var TOBL,TOBRG : TOB;
begin
  TOBL := TOBgenere.findFirst (['GL_TYPELIGNE'],['RG'],true);
	repeat
    if TOBL = nil then break;
    if TOBL.getValue('INDICERG') <> 0 then
    begin
      TOBRG:=TOBPIeceRG.findfirst(['INDICERG'],[TOBL.getValue('INDICERG')],true);
      if TOBRG <> nil then
      begin
      	TOBRG.putValue('NUMORDRE',TOBL.GEtVAlue('GL_NUMORDRE'));
      end;
    end;
  	TOBL := TOBgenere.findNext (['GL_TYPELIGNE'],['RG'],true);
  until TOBL = nil;
end;
(*
procedure CalculeNewResteRg (TOBPieceRG,TOBBasesRG,TOBPieceRGreste,TOBBasesRgReste : TOB);
var Indice : integer;
begin
	for Indice := 0 to TOBPieceRg.detail.count -1 do
  begin
  	// pour chaque ligne de retenue de garantie si le montant excede le montant de caution on met en place
  end;
end;
*)
procedure SupprimeRg (TOBPieceRg,TOBBasesRg : TOB; IndiceRg : integer);
var TOBLOC : TOB;
begin
  if TOBPieceRg=nil then exit;
  TOBLOC:=TOBPieceRg.findfirst(['INDICERG'],[IndiceRg],true);
  While TOBLOC <> nil do
  begin
    TOBLOc.free;
    TOBLOC:=TOBPieceRg.findfirst(['INDICERG'],[IndiceRg],true);
  end;
  //
  if TOBBasesRG=nil then exit;
  TOBLOC:=TOBBasesRG.findfirst(['INDICERG'],[IndiceRg],true);
  While TOBLOC <> nil do
  begin
    TOBLOc.free;
    TOBLOC:=TOBBasesRG.findfirst(['INDICERG'],[IndiceRg],true);
  end;
end;

end.
