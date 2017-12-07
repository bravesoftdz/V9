unit factdomaines;

interface
uses {$IFDEF VER150} variants,{$ENDIF} HEnt1, HCtrls, UTOB,
  {$IFDEF EAGLCLIENT}
  Maineagl,
  {$ELSE}
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} FE_Main, DB, EdtEtat, EdtDoc,
  EdtREtat, EdtRDoc,
  {$ENDIF}
  SysUtils, Dialogs, UtilPGI, AGLInit,
  Math, EntGC, Classes, HMsgBox,
  {$IFDEF CHR}HRReglement, {$ENDIF}
  {$IFDEF GRC}UtilRT,{$ENDIF}
  UtilGC, ParamSoc;

procedure InitDomaineAct;
procedure AppliqueCoefDomaineActOuv (TOBOUV : TOB);
procedure AppliqueCoefDomaineLig (TOBL : TOB);
procedure GetCoefDomaine (Domaine : string; var Coeffg,Coefmarg : double);

implementation
var TOBDOMAINES : TOB;

procedure InitDomaineAct;
begin
	TOBDomaines.clearDetail;
end;

procedure GetCoefDomaine (Domaine : string; var Coeffg,Coefmarg : double);
var QQ : TQuery;
    TOBDOMACT : TOB;
begin
  if Domaine = '' then exit;
  TOBDOMACT := TOBDOMAINES.findFirst(['BTD_CODE'],[Domaine],true);
  if TOBDOMACT = nil then
  begin
    QQ := OpenSql('SELECT * FROM BTDOMAINEACT WHERE BTD_CODE="'+Domaine+'"',true,-1, '', True);
    if not QQ.eof then
    begin
      TOBDOMACT := TOB.create ('BTDOMAINEACT',TOBDOMAINES,-1);
      TOBDOMACT.SelectDB ('',QQ);
    end;
  end;
  if TOBDOMACT <> NIL then
  begin
  	if TOBDOMACT.GetValue('BTD_COEFFG') <> 0 then
    begin
    	Coeffg := TOBDOMACT.GetValue('BTD_COEFFG');
    end;
    if TOBDOMACT.GetValue('BTD_COEFMARG') <> 0 then
    begin
    	CoefMarg := TOBDOMACT.GetValue('BTD_COEFMARG');
    end;
  end;
  ferme(QQ);
end;

procedure AppliqueCoefDomaineLig (TOBL : TOB);
var QQ : TQuery;
    TOBDOMACT : TOB;
begin
  if TOBL.getvalue('GL_DOMAINE')='' then exit;
  TOBDOMACT := TOBDOMAINES.findFirst(['BTD_CODE'],[TOBL.getvalue('GL_DOMAINE')],true);
  if TOBDOMACT = nil then
  begin
    QQ := OpenSql('SELECT * FROM BTDOMAINEACT WHERE BTD_CODE="'+TOBL.getvalue('GL_DOMAINE')+'"',true,-1, '', True);
    if not QQ.eof then
    begin
      TOBDOMACT := TOB.create ('BTDOMAINEACT',TOBDOMAINES,-1);
      TOBDOMACT.SelectDB ('',QQ);
    end;
  end;
  if TOBDOMACT <> NIL then
  begin
  	if TOBDOMACT.GetValue('BTD_COEFFG') <> 0 then
    begin
    	TOBL.putValue('GL_COEFFG',TOBDOMACT.GetValue('BTD_COEFFG')-1);
    end;
    if TOBDOMACT.GetValue('BTD_COEFMARG') <> 0 then
    begin
    	TOBL.putValue('GL_COEFMARG',TOBDOMACT.GetValue('BTD_COEFMARG'));
    end;
  end;
  ferme(QQ);
end;

procedure AppliqueCoefDomaineActOuv (TOBOUV : TOB);
var QQ : TQuery;
    TOBDOMACT : TOB;
begin
  if TOBOUV.getvalue('BLO_DOMAINE')='' then exit;
  TOBDOMACT := TOBDOMAINES.findFirst(['BTD_CODE'],[TOBOUV.getvalue('BLO_DOMAINE')],true);
  if TOBDOMACT = nil then
  begin
    QQ := OpenSql('SELECT * FROM BTDOMAINEACT WHERE BTD_CODE="'+TOBOUV.getvalue('BLO_DOMAINE')+'"',true,-1, '', True);
    if not QQ.eof then
    begin
      TOBDOMACT := TOB.create ('BTDOMAINEACT',TOBDOMAINES,-1);
      TOBDOMACT.SelectDB ('',QQ);
    end;
  end;
  if TOBDOMACT <> NIL then
  begin
  	if TOBDOMACT.GetValue('BTD_COEFFG') <> 0 then
    begin
      TOBOUV.putValue('BLO_COEFFG',TOBDOMACT.GetValue('BTD_COEFFG')-1);
    end;
    if TOBDOMACT.GetValue('BTD_COEFMARG') <> 0 then
    begin
      TOBOUV.putValue('BLO_COEFMARG',TOBDOMACT.GetValue('BTD_COEFMARG'));
    end;
  end;
  ferme(QQ);
end;

INITIALIZATION
  TOBDOMAINES := TOB.Create ('LES DOMAINES',nil,-1);
FINALIZATION
  TOBDOMAINES.free;

end.
