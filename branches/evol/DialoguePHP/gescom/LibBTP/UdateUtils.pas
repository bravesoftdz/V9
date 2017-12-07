unit UdateUtils;

interface
uses {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  Graphics,
  StdCtrls,
  Controls,
  HCtrls,
  HStatus,
  MsgUtil,
  SysUtils,
  Paramsoc,
  uJoursFeries,
	UAFO_Ferie,
  Dateutils,
  heureUtil,
  Windows;

function GetFinJournee : TDateTime;
function GetFinMatinee : TDateTime;
function GetDebutMatinee : TDateTime;
function GetDebutApresMidi : TDateTime;
function DureeJour : double;
Function CalculDureeEvenement(DateDeb,heureDeb,DateFin,heureFin : double) : double; overload;
Function CalculDureeEvenement(DateDebEvt,DateFinEvt: TdateTime) : double; overload;
function AjouteDuree (DateDebutEvt : TdateTime; Duree : integer) : TdateTime;
function JourOuvreSuivant (DateEvt : TdateTime) : TdateTime;
function IsDateClosed (DateCtrl: TdateTime) : boolean;

implementation

function GetDebutMatinee : TDateTime;
begin
  result    := Strtotime(timetostr(GetParamSoc('SO_BTAMDEBUT')));
  if result = 0 then result := StrToTime ('08:00:00');
end;

function GetDebutApresMidi : TDateTime;
begin
  result    := Strtotime(timetostr(GetParamSoc('SO_BTPMDEBUT')));
  if result = 0 then result := StrToTime ('14:00:00');
end;

function GetFinJournee : TDateTime;
begin
  result    := Strtotime(timetostr(GetParamSoc('SO_BTPMFIN')));
  if result = 0 then result := StrToTime ('12:00:00');
end;

function GetFinMatinee : TDateTime;
begin
	result    := Strtotime(timetostr(GetParamSoc('SO_BTAMFIN')));
  if result = 0 then result := StrToTime ('18:00:00');
end;

function DureeJour : double;
var HeureDebAm,HeureDebPm,HeureFinAm,HeureFinPm : TdateTime;
begin
  HeureDebAm := GetDebutMatinee;
  HeureDebPm := GetDebutApresMidi;
  HeureFinAm := GetFinMatinee;
  HeureFinPm := GetFinJournee;
  result := CalculDureeEvenement (heureDebAm,heureFinAm) + CalculDureeEvenement (heureDebPm,heureFinPm);
end;


Function CalculDureeEvenement(DateDeb,heureDeb,DateFin,heureFin : double) : double; overload;
Var FullDateDeb,FullDateFin : TdateTime;
    DiffHours : integer;
    DiffMinutes : integer;
Begin
	result := 0;
  fullDateDeb := StrToDateTime(DateToStr(DateDeb)+FloatToStrTime(heureDeb,'hh:mm'));
  fullDateFin := StrToDateTime(DateToStr(DateFin)+FloatToStrTime(heureFin,'hh:mm'));
  result := CalculDureeEvenement (FullDateDeb,FullDateFin);
end;

Function CalculDureeEvenement(DateDebEvt,DateFinEvt: TdateTime) : double; overload;
var NbMinutes : integer;
    DateDJourAm,DateFJourAm,DateDJourPm,DateFJourPm : TdateTime;
    HeureDebAm,HeureDebPm,HeureFinAm,HeureFinPm : TdateTime;
begin
  HeureDebAm := GetDebutMatinee;
  HeureDebPm := GetDebutApresMidi;
  HeureFinAm := GetFinMatinee;
  HeureFinPm := GetFinJournee;
  //
  DateDJourAM := StrToDate(DateToStr(DateDebEvt))+heureDebAM;
  DateFJourAM := StrToDate(DateToStr(DateDebEvt))+heureFinAM;
  DateDJourPM := StrToDate(DateToStr(DateDebEvt))+HeureDebPM;
  DateFJourPM := StrToDate(DateToStr(DateDebEvt))+HeureFinPM;
  //
  if StrToTime(TimeToStr(DateDebEvt)) > HeureFinAM then // Aprems ?
  begin
    DateDJourAm := StrToDate(DateToStr(DateDebEvt));
    DateFJourAM := StrToDate(DateToStr(DateDebEvt));
  	if StrToTime(TimeToStr(DateDebEvt)) > heureDebPM then  // > deb aprem
    begin
    	DateDJourPm := DateDebEvt;
    end;
  end else if StrToTime(TimeToStr(DateDebEvt)) > HeureDebAM then // > debut matine
  begin
    DateDJourAm := DateDebEvt;
  end;
  //
  if (IsSameDay(DateDebEvt,DateFinEvt)) then
  begin
    if StrToTime(TimeToStr(DateFinEvt)) <= heureFinAM then  // < fin matinée
    begin
      DateFJourAm := DateFinEvt;
    	DateDJourPm := StrToDate(DateToStr(DateDebEvt));
    	DateFJourPM := StrToDate(DateToStr(DateDebEvt));
    end else if StrToTime(TimeToStr(DateFinEvt)) < heureFinPM then  // < fin Journée
    begin
      DateFJourPm := DateFinEvt;
    end;
	end;
  //
  NbMinutes := 0;
  repeat
    if (DateDJourAM > DateFinEvt) then break;
  	NbMinutes := NbMinutes + round(MinutesPan(DateDJourAM,DateFJourAm)) +
    												 round(MinutesPan(DateDJourPM,DateFJourPm));
    // ------------
    // jour suivant
    // ------------
    DateDJourAM := JourOuvreSuivant(StrToDate(DateToStr(DateDjourAM)))+heureDebAm;
    DateFJourAM := StrToDate(DateToStr(DateDJourAM))+heureFinAM;
    //
    DateDJourPM := StrToDate(DateToStr(DateDJourAM))+HeureDebPM;
    DateFJourPM := StrToDate(DateToStr(DateDJourAM))+HeureFinPM;
    if (IsSameDay(DateDJourAM,DateFinEvt)) then
    begin
      if StrToTime(TimeToStr(DateFinEvt)) < HeureFinAM then  // < fin matinée
      begin
        DateFJourAm := DateFinEvt;
        DateDJourPM := DateFinEvt;
        DateFJourPM := DateFinEvt;
      end else if StrToTime(TimeToStr(DateFinEvt)) < heureFinPM then  // < fin Journée
      begin
        DateFJourPm := DateFinEvt;
      end;
    end;
    //
  until 1=2;
  result := NbMinutes;
end;

function AjouteDuree (DateDebutEvt : TdateTime; Duree : integer) : TdateTime;
var min,NbrDay: integer;
	  HeureDebAM,HeureFinAm,heureDebPm,heureFinPM,DateS,heureEvt	: TDateTime;
begin
  HeureDebAm := GetDebutMatinee;
  HeureDebPm := GetDebutApresMidi;
  HeureFinAm := GetFinMatinee;
  HeureFinPm := GetFinJournee;
  DateS := DateDebutEvt;
	for min := 1 to Duree do
  begin
  	DateS := IncMinute(DateS,1);
 	 	HeureEvt := StrToTime(TimeToStr(DateS));
    if (HeureEvt > heureFinAm) and (HeureEvt < heureDebPm) then
    begin
    	DateS := Incminute(StrToDate(DateToStr(DateS)) + HeureDebPm,1) ;
 	 		HeureEvt := StrToTime(TimeToStr(DateS));
    end;
    if HeureEvt > heureFinPm then
    begin
    	DateS := IncMinute(StrToDate(DateToStr(JourOuvreSuivant(DateS))) +heureDebAm,1);
    end;
  end;
  result := DateS;
end;

function JourOuvreSuivant (DateEvt : TdateTime) : TdateTime;
var stop : boolean;
		DateTmp : TdateTime;
begin
	DateTmp := DateEvt;
	stop := false;
  repeat
  	DateTmp := incday(DateTmp,1);
    if not IsDateClosed (DateTmp) then stop := true;
  until stop;
  result := DateTmp;
end;

function IsDateClosed (DateCtrl: TdateTime) : boolean;
var JF : array[0..6] of Integer;    // Liste des jours de fermeture
begin
	result := false;
	if AglJoursFeries(DateCtrl) then
  begin
  	result := true;
    exit;
  end;
  ChargeJourFermeture (JF);
  if TestJourFermeture(DayOfWeek (DateCtrl),JF)  then
  begin
  	result := true;
    exit;
  end;
end;


end.
