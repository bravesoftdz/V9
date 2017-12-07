unit UserialiseLSE;

interface
Uses Classes,
     sysutils,
     Hent1,
     forms,
     CLKBtpLib_TLB ;

function  GetSeriaLSE(ID,CodeProduit,version: string;Qte:double;DateFinSeria : TdateTime) : string;

implementation

function GetSeriaLSE(ID, CodeProduit, version: string;Qte: double; DateFinSeria : TDateTime): string;
var Cversion : string;
		WinSeria : TBuilder;
    YY,MM,DD : word;
    DateReal : TdateTime;
begin
	WinSeria := TBuilder.create(application);

	result := '';
  if (ID = '') or (Codeproduit='') or (version='') then exit;
  if length (Id) < 5 then ID := copy('00000',1,(5-length(Id)))+id;
  Cversion := copy(version,1,2)+'0';
	if Assigned(WinSeria) then
  begin
  	TRY
    	if DateFinSeria = StrToDate('31/12/2099') then
      begin
				result := WinSeria.GetKey ( StrToInt(Id)+21531,Widestring(CodeProduit+Cversion),strtoint(floattostr(Qte)));
      end else
      begin
				DateReal := FINDEMOIS(DateFinSeria);
      	DecodeDate(DateReal,YY,MM,DD);
				result := WinSeria.GetTempKey  ( StrToInt(Id)+21531,Widestring(CodeProduit+Cversion),strtoint(floattostr(Qte)),MM,YY);
      end;
    EXCEPT
    	result := '';
    End;
  end;
  if assigned(WinSeria) then WinSeria.free;
end;

end.
