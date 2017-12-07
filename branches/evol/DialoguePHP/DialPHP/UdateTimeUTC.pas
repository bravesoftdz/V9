unit UdateTimeUTC;

interface
uses Windows,SysUtils;

const  MinsPerDay = 24 * 60;

function LocaleToGMT(const Value: TDateTime): TDateTime;
function GMTToLocale(const Value: TDateTime): TDateTime;
function GMTNow: TDateTime;

implementation

function GetGMTBias: Integer;
var
  info: TTimeZoneInformation;
  Mode: DWord;
begin
  Mode := GetTimeZoneInformation(info);
  Result := info.Bias;
  case Mode of
    TIME_ZONE_ID_INVALID:
      RaiseLastOSError;
    TIME_ZONE_ID_STANDARD:
      Result := Result + info.StandardBias;
    TIME_ZONE_ID_DAYLIGHT:
      Result := Result + info.DaylightBias;
  end;
end;


function LocaleToGMT(const Value: TDateTime): TDateTime;
begin
  Result := Value + (GetGMTBias / MinsPerDay);
end;

function GMTToLocale(const Value: TDateTime): TDateTime;
begin
  Result := Value - (GetGMTBias / MinsPerDay);
end;

function GMTNow: TDateTime;
begin
  Result := LocaleToGMT(Now);
end;

end.
