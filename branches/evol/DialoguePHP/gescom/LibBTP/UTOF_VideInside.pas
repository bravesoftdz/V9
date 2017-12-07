{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 26/03/2004
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : VIDEINSIDE ()
Mots clefs ... : TOF;VIDEINSIDE
*****************************************************************}
Unit UTOF_VideInside ;

Interface

Uses StdCtrls, 
     Controls, 
     Classes, 
{$IFNDEF EAGLCLIENT}
     FE_Main,
     db,
     {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
{$else}
     Maineagl,
     eMul,
{$ENDIF}
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOF,
     AglInit,
     SaisieConsommations,
     BTMODELHEBDO_TOF,
{$IFDEF LINE}
     BTCLOTUREEX_TOF,
{$ENDIF}
     REGENERECONSO_tof
     ,BTTVA_TOF;

Type
  TOF_VIDEINSIDE = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  end ;

procedure SaisirHorsInside (Nomfiche : string;Param : string='');

Implementation
uses fichcomm {$IFDEF LINE},AssistparamSocBTP {$ENDIF};

procedure SaisirHorsInside(Nomfiche : string; param:string='');
var S : string;
begin
	S :='FICHE='+NomFiche;
  if Param <> '' then S := S + ';'+ param;
  AGLLanceFiche('BTP','BTVIDEINSIDE','','',S) ;
end;

procedure TOF_VIDEINSIDE.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_VIDEINSIDE.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_VIDEINSIDE.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_VIDEINSIDE.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_VIDEINSIDE.OnArgument (S : String ) ;
var position : integer;
    laFiche : string;
    Argument : string;
begin
  Inherited ;

  Position :=  Pos('FICHE=',S);
  if Position > 0 then laFiche := copy(S,7,255);
  Argument := READTOKENST(S);
  if lafiche = '' then exit;
  if laTob <> nil then TheTOB := LATOB;

  ecran.Caption := LaFiche;
  if lafiche='PARAMSOC' then
  begin
{$IFDEF LINE}
  	AppelParamSociete;
{$ENDIF}
  end
  else if lafiche ='MODPAIE' then
  begin
  	FicheModePaie_AGL(' ');
  end else if lafiche ='GCUNITEMESURE' then
  begin
  	AGLLanceFiche('GC',LaFiche,'','','');
  end else if Lafiche = 'GCCODECPTA' then
  begin
  	AGLLanceFiche('GC',LaFiche,'','','');
  end else if Lafiche = 'SAISIECONSOMMATIONS' then SaisieConsommation
  else if Lafiche = 'SAISIEINTERVENTION' then SaisieIntervention
  else if Lafiche = 'TVA' then
  begin
  	ecran.caption := '';
  	ParamTVATPF(true);
  end else if LaFiche = 'BTREGENERECONSO' then GestionRegenerationConso
{$IFDEF LINE}
  Else if (LaFiche = 'BTPARSOCCPTAGS1') Or
    			(LaFiche = 'BTPARAMSOCS') or
          (LaFiche = 'BTPARAMGENS1') or
          (LaFiche = 'BTPARAMSOCPART') Then
       AGLLanceFiche('BTP',LaFiche,'','','ALONE')
  //else if Lafiche = 'BTENVOIECRS1' then
  // 		 AGLLANCEFICHE('BTP','BTENVOIECRS1','','','MODIFICATION')
  //else if Lafiche = 'BTRECUPDOSS1' then
  // 		 AGLLANCEFICHE('BTP','BTRECUPDOSS1','','','MODIFICATION')
  else if Lafiche = 'BTCPTPIECE_S1' then
	     AGLLanceFiche('BTP',LaFiche,'','','NATURE=DBT;NUMERO=0')
  else if LaFiche = 'BTCLOTUREEX' then BTClotureEx
{$ENDIF}
  else if LaFiche = 'GCSELDOCREA_MUL' then AGLLANCEFICHE ('GC',laFiche,'','','ACTION=MODIFICATION')
  else if LaFiche = 'BTAPPELINT' then AGLLANCEFICHE ('BTP',laFiche,'','',Argument)
  else AGLLANCEFICHE ('BTP',laFiche,'','','ACTION=MODIFICATION');

end ;

procedure TOF_VIDEINSIDE.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_VIDEINSIDE.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_VIDEINSIDE.OnCancel () ;
begin
  Inherited ;
end ;

Initialization
  registerclasses ( [ TOF_VIDEINSIDE ] ) ; 
end.

