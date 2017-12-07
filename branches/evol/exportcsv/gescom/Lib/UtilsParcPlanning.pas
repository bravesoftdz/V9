unit UtilsParcPlanning;

interface

uses  M3FP,
      StdCtrls,
      Controls,
      Classes,
      Forms,
      SysUtils,
      ComCtrls,
      HCtrls,
      HEnt1,
      HMsgBox,
      UTOB,
      UTOF,
      AglInit,
      Agent,
      EntGC,
      StrUtils,
      DateUtils,
      HeureUtil,
      ParamSoc,
      Constantes,
      UProcGen,
      UtilSaisieconso,
{$IFDEF EAGLCLIENT}
      MaineAGL,HPdfPrev,UtileAGL,
{$ELSE}
      {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}Fe_Main,
{$ENDIF}
      HTB97;

    function CalculeDateParcEtireReduit(Item: TOB; var DateD, DateF: TdateTime; var Delai: integer; Cadencement : String): boolean;

    function DeplacementParcMateriel(Item: tob; Materiel : String; Cadencement : String)           : Boolean;
    Function DuplicationParcMateriel(Item : TOB; Materiel : String; Cadencement : String) : boolean;

    function IsParcModifiable(Item: TOB): boolean;
    Procedure MAJParcEvent(DateDep, Datefin : TDateTime; Materiel : String; NumEvent : Integer);
    function ReductionEtirementParcMateriel (Item : TOB; Cadencement : String)  : boolean;

    function UpdateParcMateriel (Materiel : string; NumEvent : integer; DateDebut,DateFin : TdateTime): boolean;

implementation

uses  PlanUtil,
      UtilsParc,
      BTPUtil,
      UdateUtils;

function ReductionEtirementParcMateriel (Item : TOB; Cadencement : String) : boolean;
var DateD       : TDateTime;
    DateF       : TdateTime;
    delai       : integer;
    NumEvent    : integer;
		Materiel    : string;
begin

  Materiel      := Item.GetValue('BEM_CODEMATERIEL');
  NumEvent      := Item.GetValue('BEM_IDEVENTMAT');

  DateD         := Item.GetValue('BEM_DATEDEB');
  DateF         := Item.getValue('BEM_DATEFIN');

	result        := CalculeDateParcEtireReduit (Item,DateD,DateF,Delai, Cadencement);

  if not result then exit;

  if not UpdateParcMateriel (Materiel, NumEvent, DateD, DateF) then	result := false;

end;

function DeplacementParcMateriel (Item : TOB; Materiel : String; Cadencement : String) : boolean;
var MaterielFin : string;
    NumEvent    : Integer;
    DateDep     : TDateTime;
    DateFin     : TDateTime;
    Duree       : Integer;
begin

	result := False;

	if not IsParcModifiable(Item) then Exit;
  //
  MaterielFin	:= Item.GetValue('BEM_CODEMATERIEL');

  DateDep     := StrToDateTime(Item.GetValue('BEM_DATEDEB'));
  Datefin     := StrtoDateTime(Item.GetValue('BEM_DATEFIN'));

  Duree       := StrToInt(CalculNbHeure(DateDep, DateFin));

  NumEvent    := StrToInt(Item.GetValue('BEM_IDEVENTMAT'));

  Result      := CalculeDateParcEtireReduit (Item,DateDep, Datefin, Duree,Cadencement);

  if result then
  begin
    if Materiel = MaterielFin then
      UpdateParcMateriel (Materiel, NumEvent, DateDep, Datefin)
    else
      MajParcEvent(DateDep, DateFin, MaterielFin, NumEvent);
  end;

end;

Function DuplicationParcMateriel(Item : TOB; Materiel : String; Cadencement : String) : boolean;
Var TobMateriel : TOB;
    TobEventMat : TOB;
    STSQL       : string;
    QQ          : TQuery;
    FF          : String;
    PA          : Double;
    PR          : Double;
    PV          : Double;
    x           : Integer;
    NewNumEvent : Integer;
    Duree       : Integer;
begin

  FF:='#';
  if V_PGI.OkDecV>0 then
  begin
    FF:='# ##0.';
    for x := 1 to V_PGI.OkDecV-1 do
    begin
      FF:=FF+'0';
    end;
    FF:=FF+'0';
  end;

	result := true;

	if not IsParcModifiable(Item) then
  begin
  	result := false;
    exit;
  end;

  if not GetNumCompteur('BEM',iDate1900, NewNumEvent) then
  begin
    PGIError(TexteMessage[7], 'Evènement Matériel');
  	result := false;
    exit;
  end;

  If not ControleCoherence (StrToDate(Item.GetValue('BEM_DATEDEB')),StrToDate(Item.GetValue('BEM_DATEFIN')),0, Item.GetValue('BEM_CODEMATERIEL')) Then Exit;
  
  TobEventMat := TOB.Create('BTEVENTMAT',nil, -1);
  StSQL := 'SELECT * FROM BTEVENTMAT WHERE BEM_IDEVENTMAT=' + IntToStr(Item.GetValue('BEM_IDEVENTMAT'));
  QQ    := OpenSQL(StSql,False,1,'',True);
  if QQ.Eof then
  begin
    Ferme(QQ);
  	result := false;
    Exit;
  end;

  TobEventMat := TOB.Create('BTEVENTMAT',nil, -1);
  TobEventMat.SelectDB('BTEVENTMAT',QQ);
  //
  TobEventMat.PutValue('BEM_IDEVENTMAT',    NewNumEvent);
  TobEventMat.PutValue('BEM_CODEMATERIEL',  Item.GetValue('BEM_CODEMATERIEL'));
  TobEventMat.PutValue('BEM_DATEDEB',       Item.GetValue('BEM_DATEDEB'));
  TobEventMat.PutValue('BEM_DATEFIN',       Item.GetValue('BEM_DATEFIN'));

  Duree       := StrToInt(CalculNbHeure(Item.GetDateTime('BEM_DATEDEB'), Item.GetDateTime('BEM_DATEFIN')));

  TobMateriel := Tob.create('BTMATERIEL', nil, -1);

  if Materiel <> '' then ChargeInfoMateriel(Item.GetValue('BEM_CODEMATERIEL'), TobMateriel);

  //Chargement de la tobItem initiale avec les information de la tobMatériel de destination
  PR  := StrToFloat(FormatFloat(FF, TobMateriel.GetVALUE('BMA_COUT')));
  PA  := StrToFloat(FormatFloat(FF, TobMateriel.GetVALUE('BMA_PA')));
  PV  := StrToFloat(FormatFloat(FF, TobMateriel.GetVALUE('BMA_PV')));

  //
  TobEventMat.PutValue('BEM_PA',            PA);
  TobEventMat.PutValue('BEM_PV',            PV);
  TobEventMat.PutValue('BEM_PR',            PR);
  TobEventMat.PutValue('BEM_NBHEURE',       Duree);
  //
  TobEventMat.InsertOrUpdateDB;
  //
  FreeAndNil(TobMateriel);
  FreeAndNil(TobEventMat);
  //
end;

Procedure MAJParcEvent(DateDep, Datefin : TDateTime; Materiel : String; NumEvent : Integer);
Var TobMateriel : TOB;
    FF          : String;
    PA          : Double;
    PR          : Double;
    PV          : Double;
    x           : Integer;
    STSQL       : string;
    Duree       : Integer;
begin

  FF:='#';
  if V_PGI.OkDecV>0 then
  begin
    FF:='# ##0.';
    for x := 1 to V_PGI.OkDecV-1 do
    begin
      FF:=FF+'0';
    end;
    FF:=FF+'0';
  end;

  TobMateriel := Tob.create('BTMATERIEL', nil, -1);

  if Materiel <> '' then ChargeInfoMateriel(Materiel, TobMateriel);
  //Chargement de la tobItem initiale avec les information de la tobMatériel de destination
  PR  := StrToFloat(FormatFloat(FF, TobMateriel.GetVALUE('BMA_COUT')));
  PA  := StrToFloat(FormatFloat(FF, TobMateriel.GetVALUE('BMA_PA')));
  PV  := StrToFloat(FormatFloat(FF, TobMateriel.GetVALUE('BMA_PV')));

  Duree   := StrToInt(CalculNbHeure(DateDep, DateFin));

  StSQL :='UPDATE BTEVENTMAT SET ';
  StSQL := StSQL + 'BEM_DATEDEB = "' + USDateTime(DateDep) + '",';
  StSQL := StSQL + 'BEM_DATEFIN = "' + USDateTime(DateFin) + '",';
  StSQL := StSQL + 'BEM_NBHEURE =  ' + IntToStr(round(Duree)) +', ';
  StSQL := StSQL + 'BEM_PA      =  ' + StrfPoint(PA) + ', ';
  StSQL := StSQL + 'BEM_PR      =  ' + StrfPoint(PR) + ', ';
  StSQL := StSQL + 'BEM_PV      =  ' + StrfPoint(PV) + ', ';
  StSQL := StSQL + 'BEM_CODEMATERIEL = "'    + Materiel    + '" ';
  StSQL := StSQL + 'WHERE BEM_IDEVENTMAT = ' + IntToStr(NumEvent);

  if ExecuteSql (StSQL) <= 0 then PGIError('La mise à jour de l''évènement a échouée', 'Erreur Mise à jour');

  //libération de la tobMatériel
  FreeAndNil(TobMateriel);

end;
//
function CalculeDateParcEtireReduit (Item : TOB; var DateD,DateF : TdateTime; var Delai : integer; Cadencement : String): boolean;
begin

	result := true;

  if cadencement = '005' then // journée
  Begin
    Delai	:= 0;
    DateD := Trunc(DateD);
    DateF := Trunc(DateF);
  End
  Else if Cadencement = '004' then  // 1/2 Journée
  begin
    Delai	:= 0;
    DateF := GestionDateFinPourModif (DateF);
  End
  Else if Cadencement = '003' then // heure
  begin
    Delai	:= 0;
    DateF := GestionDateFinPourModif (DateF);
  End
  Else if Cadencement = '002' then // 1/2 heure
  begin
    Delai	:= 0;
    DateF := GestionDateFinPourModif (DateF);
  End
  Else if Cadencement = '001' then // 1/4 heure
  begin
    Delai	:= 0;
    DateF := GestionDateFinPourModif (DateF);
  end;

  Result := ControleCoherence (DateD,DateF,0, Item.GetString('BEM_CODEMATERIEL'));
  
end;

function UpdateParcMateriel (Materiel : string; NumEvent : integer; DateDebut,DateFin : TdateTime): boolean;
var StSQL     : string;
    Duree     : Integer;
begin

	result := true;

  Duree   := StrToInt(CalculNbHeure(DateDebut, DateFin));

  StSQL :='UPDATE BTEVENTMAT SET ';
  StSQL := StSQL + 'BEM_DATEDEB = "' + USDateTime(DateDebut) + '",';
  StSQL := StSQL + 'BEM_DATEFIN = "' + USDateTime(DateFin) + '",';
  StSQL := StSQL + 'BEM_NBHEURE =  ' + IntToStr(round(Duree)) ;
  StSQL := StSQL + 'WHERE BEM_IDEVENTMAT = ' + IntToStr(NumEvent);

  if ExecuteSql (StSQL) <= 0 then result := false;

end;

function IsParcModifiable(Item: TOB): boolean;
begin

  result := False;

  if Item = nil then exit;

  if not assigned(Item) then exit;

  if Item.getValue('BEP_MODIFIABLE') <> 'X' then exit;

	result := True;

end;

end.
