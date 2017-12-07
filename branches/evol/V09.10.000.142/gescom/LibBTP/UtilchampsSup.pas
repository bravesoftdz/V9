unit UtilchampsSup;

interface
uses HCtrls,
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} DB,
Hent1;

function getValInitChampsSup(nomchamp : string) : variant;
implementation

function TypeDeChamp(NomChamp: String) : String;
var
  iTable, iChamp: Integer;
  s: String;
begin
  Result := '';
  iTable := TableToNum(PrefixeToTable(ExtractPrefixe(NomChamp)));
  iChamp := ChampToNum(NomChamp);
	if iChamp <> -1 then
  begin
    s := V_PGI.DECHAMPS[iTable, iChamp].tipe;
    if (s = 'INTEGER') or (s = 'SMALLINT') then Result := 'I'
    else if (s = 'DOUBLE') or (s = 'EXTENDED') or (s = 'DOUBLE') or (s = 'RATE') then Result := 'N'
    else if (s = 'DATE') then Result := 'D'
    else if (s = 'BLOB') or (s = 'DATA') then Result := 'M'
    else if (s = 'BOOLEAN') then Result := 'B'
    else Result := 'C';
  end;
end;

function getValInitChampsSup(nomchamp : string) : variant;
begin
  if (TypeDeChamp(NomChamp) = 'I') or (TypeDeChamp(NomChamp) = 'N') then
  	result := 0
  else if (TypeDeChamp(NomChamp) = 'D') then
  	result := iDate1900
  else if (TypeDeChamp(NomChamp) = 'B') then
  	result := '-'
  else
  	result := '';
end;

end.
