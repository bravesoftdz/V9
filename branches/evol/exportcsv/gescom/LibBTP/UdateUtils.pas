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
  UProcGen,
  uTOB,
  Windows;

function GetDebJournee : TDateTime;
function GetFinJournee : TDateTime;
function GetFinMatinee : TDateTime;
function GetDebutMatinee : TDateTime;
function GetDebutApresMidi : TDateTime;
function GetFinApresMidi : TDateTime;
function DureeJour : double;
Function CalculDureeEvenement(DateDeb,heureDeb,DateFin,heureFin : double) : double; overload;
Function CalculDureeEvenement(DateDebEvt,DateFinEvt: TdateTime) : double; overload;
function AjouteDuree (DateDebutEvt : TdateTime; Duree : integer) : TdateTime;
function JourOuvreSuivant (DateEvt : TdateTime) : TdateTime;
function IsDateClosed (DateCtrl: TdateTime) : boolean;
function isJourFerie (DateCtrl : TdateTime): boolean;
function HeureBase100ToMinutes (DelaiBase100 : Double) : integer;
function ConstitueMois (TheDate : TDateTime) : string;
function Unite2Heures (Unite : string) : Double;
implementation
uses EntGC;

function Unite2Heures (Unite : string) : Double;
var TOBM : TOB;
    XV,XA : Double ;
begin
  TOBM:=VH_GC.MTOBMEA.FindFirst(['GME_QUALIFMESURE','GME_MESURE'],['TEM',Unite],False) ;
  XV:=0 ; if TOBM<>Nil then XV:=TOBM.GetValue('GME_QUOTITE') ; if XV=0 then XV:=1.0 ;
  TOBM:=VH_GC.MTOBMEA.FindFirst(['GME_QUALIFMESURE','GME_MESURE'],['TEM','H'],False) ;
  XA:=0 ; if TOBM<>Nil then XA:=TOBM.GetValue('GME_QUOTITE') ; if XA=0 then XA:=1.0 ;
  Result:=XV/XA ;
end;

function ConstitueMois (TheDate : TDateTime) : string;
begin
	Result := IntToStr(YearOf(TheDate))+format('%2.2d',[MonthOf(TheDate)])
end;

function HeureBase100ToMinutes (DelaiBase100 : Double) : integer;
var Nbhrs : Double;
		MinutesFrombase100 : Double;
    Interm : Extended;
begin
  Nbhrs := Trunc(DelaiBase100)*60;
  Interm := Frac(DelaiBase100) * 30 / 0.5;
	MinutesFrombase100 := trunc(Interm);
  Result := StrToInt(FloatToStr(NbHrs + MinutesFrombase100));
end;

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

function GetFinApresMidi : TDateTime;
begin
  result    := Strtotime(timetostr(GetParamSoc('SO_BTPMFIN')));
  if result = 0 then result := StrToTime ('18:00:00');
end;

function GetFinMatinee : TDateTime;
begin
	result    := Strtotime(timetostr(GetParamSoc('SO_BTAMFIN')));
  if result = 0 then result := StrToTime ('12:00:00');
end;

function GetDebJournee : TDateTime;
begin

  result := Strtotime(timetostr(GetParamSocSecur('SO_HEUREDEB','08:00:00')));

end;

function GetFinJournee : TDateTime;
begin

  result := Strtotime(timetostr(GetParamSocSecur('SO_HEUREFIN','18:00:00')));

end;

function DureeJour : double;
var HeureDebAm,HeureDebPm,HeureFinAm,HeureFinPm : TdateTime;
    NbhrsDeb,NbHrsFin : Double;
begin
  HeureDebAm := GetDebutMatinee;
  HeureDebPm := GetDebutApresMidi;
  HeureFinAm := GetFinMatinee;
  HeureFinPm := GetFinApresMidi;
  NbhrsDeb := round(MinutesPan(HeureDebAm,HeureFinAm));
  NbHrsFin :=  round(MinutesPan(HeureDebPm,HeureFinPm));
  result := NbhrsDeb + NbHrsFin ;
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
  HeureFinPm := GetFinApresMidi;
  //
  DateDJourAM := StrToDate(DateToStr(DateDebEvt))+HeureDebAM;
  DateFJourAM := StrToDate(DateToStr(DateDebEvt))+HeureFinAM;
  DateDJourPM := StrToDate(DateToStr(DateDebEvt))+HeureDebPM;
  DateFJourPM := StrToDate(DateToStr(DateDebEvt))+HeureFinPM;
  //
  DateDJourAm := DateDebEvt;
  if DateDebEvt > DateDJourAM then // Aprems ?
  begin
  	if DateDebEvt > DateDJourPM then  // > deb aprem
    begin
    	DateDJourAM := DateDebEvt;
    	DateDJourPM := DateDebEvt;
    end;
  end;
  //
  if (IsSameDay(DateDebEvt,DateFinEvt)) then
  begin
    DateFJourPM := DateFinEvt;
    if DateFinEvt <= DateFJourAM then  // < fin matinée
    begin
    	DateFJourAM := DateFinEvt;
    	DateDJourPM := DateFinEvt;
    	DateFJourPM := DateFinEvt;
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
      DateFJourPM := DateFinEvt;
      if DateFinEvt < DateDJourPM then
      begin
        DateDJourPm := DateFinEvt;
      end;
      if DateFinEvt < DateFJourAm then
      begin
        DateFJourAm := DateFinEvt;
      end;
      if DateFinEvt < DateDJourAm then
      begin
        DateDJourAm := DateFinEvt;
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
  HeureFinPm := GetFinApresMidi;
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

function isJourFerie (DateCtrl : TdateTime): boolean;
const CalendarClosedYear = 1972;
var Y,M,D : word;
    II,I : integer;
    EasterDate,tmpDate : TdateTime;
    S : String;
begin
  result := true;
  // Cherche parmi les jours fériés (voir TOM_CALENDRIER.LoadJourFerie)
  DecodeDate(DateCtrl, Y, M, D);
  EasterDate  := CalculPaques(Y);
  tmpDate     := EncodeDate(CalendarClosedYear, M, D); // Rend l'année neutre
  //
  for II := 0 to VH_GC.TOBTABFERIE.detail.count -1 do
	begin
		S := VH_GC.TOBTABFERIE.detail[II].getString('CO_LIBRE');
		if S[1] = 'P' then	// Date à calculer par rapport à Pâques
		begin	// Extrait le décalage (<200)
			if S = 'P' then
				I := 0
			else	// P+
				I := StrToInt(Copy(S, 3, 9));
			if DateCtrl = (EasterDate+I) then
				Exit;
		end
		else	// Date fixe
			if tmpDate = StrToDate(S) then
				Exit;
	end;
  result := false;
end;


end.
