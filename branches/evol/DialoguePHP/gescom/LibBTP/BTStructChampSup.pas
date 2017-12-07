unit BTStructChampSup;

interface
uses
  Windows, SysUtils, Classes,
  {$IFDEF EAGLCLIENT}
  UtileAGL, Maineagl,BTPGetStructure,
  {$ELSE}
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} DB,
  {$ENDIF}
  UTOB,HEnt1,EntGC,Hctrls,UtilchampsSup, variants;

// Structure ligne
procedure MemoriseChampsSupLigneETL (NaturePiece : string;WithLigneCompl:boolean=false;WithEntete:boolean=false);
procedure MemoriseChampsSupPARCL (requete : string);
procedure MemoriseChampsSupLigneOUV (NaturePiece : string);

{$IFNDEF EAGLSERVER}
procedure AddlesChampsSupLigneEtl (TOBL : TOB);
procedure InitStructureETL;
procedure AddlesChampsSupParcl (TOBL : TOB);
procedure InitStructurePARCL;
procedure AddlesChampsSupOuv (TOBL : TOB);
procedure InitStructureOUV;
{$ENDIF}

implementation

{$IFNDEF EAGLSERVER}
uses factTOB,FactCommBTP,UtilTOBPiece;

var TOBStructLig,TOBStructParc,TOBStructLigOuv : TOB;

procedure InitStructureETL;
begin
	if TOBStructLig.detail.count > 0 then TOBSTRUCTLIG.ClearDetail;
end;

procedure InitStructurePARCL;
begin
	if TOBStructParc.detail.count > 0 then TOBStructParc.ClearDetail;
end;

procedure InitStructureOUV;
begin
	if TOBStructLigOuv.detail.count > 0 then TOBStructLigOuv.ClearDetail;
end;

{$ENDIF}

{$IFDEF EAGLCLIENT}
procedure SMemoriseChampsSupLigneETL (TOBST : TOB);
{$ELSE}
procedure SMemoriseChampsSupLigneETL (QQ : TQuery);
{$ENDIF}
var TOBEtalon : TOB;
		Indice : integer;
    NomChamps : string;
begin
	if TOBStructLig.detail.count > 0 then InitStructureETL;
  //
	TOBEtalon := TOB.Create ('LA LIGNE ETALON',TOBStructLig,-1);
  //
{$IFDEF EAGLCLIENT}
	for Indice := 0 to TOBST.ChampsSup.Count  -1 do
  begin
  	NomChamps := TOBST.GetNomChamp(1000+Indice);
		if ExtractPrefixe (NomChamps) = 'GL' then continue; // pour ne prendre que les champs sup
  	TOBEtalon.AddChampSupValeur (NomChamps,getValInitChampsSup(NomChamps));
  end;
{$ELSE}
  for Indice := 0 to QQ.FieldCount -1 do
  begin
  	NomChamps := QQ.Fields[Indice].FieldName;
		if ExtractPrefixe (NomChamps) = 'GL' then continue; // pour ne prendre que les champs sup
  	TOBEtalon.AddChampSupValeur (NomChamps,getValInitChampsSup(NomChamps));
  end;
{$ENDIF}
end;

{$IFDEF EAGLCLIENT}
procedure SMemoriseChampsSupParcL (TOBST : TOB);
{$ELSE}
procedure SMemoriseChampsSupParcL (QQ : TQuery);
{$ENDIF}
var TOBEtalon : TOB;
		Indice : integer;
    NomChamps : string;
begin
	if TOBStructParc.detail.count > 0 then InitStructurePARCL;
  //
	TOBEtalon := TOB.Create ('LA LIGNE ETALON',TOBStructParc,-1);
  //
{$IFDEF EAGLCLIENT}
	for Indice := 0 to TOBST.ChampsSup.Count  -1 do
  begin
  	NomChamps := TOBST.GetNomChamp(1000+Indice);
		if ExtractPrefixe (NomChamps) = 'BP1' then continue; // pour ne prendre que les champs sup
  	TOBEtalon.AddChampSupValeur (NomChamps,getValInitChampsSup(NomChamps));
  end;
{$ELSE}
  for Indice := 0 to QQ.FieldCount -1 do
  begin
  	NomChamps := QQ.Fields[Indice].FieldName;
		if ExtractPrefixe (NomChamps) = 'BP1' then continue; // pour ne prendre que les champs sup
  	TOBEtalon.AddChampSupValeur (NomChamps,getValInitChampsSup(NomChamps));
  end;
{$ENDIF}
end;

{$IFDEF EAGLCLIENT}
procedure SMemoriseChampsSupLigneOuv (TOBST : TOB);
{$ELSE}
procedure SMemoriseChampsSupLigneOuv (QQ : TQuery);
{$ENDIF}
var TOBEtalon : TOB;
		Indice : integer;
    NomChamps : string;
begin
	if TOBStructLigOuv.detail.count > 0 then InitStructureOUV;
  //
	TOBEtalon := TOB.Create ('LA LIGNE ETALON',TOBStructLigOuv,-1);
  //
{$IFDEF EAGLCLIENT}
	for Indice := 0 to TOBST.ChampsSup.Count  -1 do
  begin
  	NomChamps := TOBST.GetNomChamp(1000+Indice);
		if ExtractPrefixe (NomChamps) = 'BLO' then continue; // pour ne prendre que les champs sup
  	TOBEtalon.AddChampSupValeur (NomChamps,getValInitChampsSup(NomChamps));
  end;
{$ELSE}
  for Indice := 0 to QQ.FieldCount -1 do
  begin
  	NomChamps := QQ.Fields[Indice].FieldName;
		if ExtractPrefixe (NomChamps) = 'BLO' then continue; // pour ne prendre que les champs sup
  	TOBEtalon.AddChampSupValeur (NomChamps,getValInitChampsSup(NomChamps));
  end;
{$ENDIF}
end;

procedure MemoriseChampsSupLigneOUV (NaturePiece : string);
var WithLigneFac : boolean;
		Sql : String;
{$IFDEF EAGLCLIENT}
		TOBST : TOB;
{$ELSE}
    QQ : TQuery;
{$ENDIF}

begin
  WithLigneFac := (pos(NaturePiece,'FBT;DAC')>0);
	Sql := MakeSelectLigneOuvBtp (WithLigneFac);
  Sql := Sql + ' WHERE 1=2'; // pour ne recup que la structure
{$IFDEF EAGLCLIENT}
	TOBST := BTPGetFieldStructure (Sql);
  SMemoriseChampsSupLigneOuv(TOBST);
  TOBST.free;
{$ELSE}
  QQ := OpenSQL(Sql, True,-1, '', True);
  SMemoriseChampsSupLigneOuv(QQ);
  ferme (QQ);
{$ENDIF}
end;

procedure MemoriseChampsSupLigneETL (NaturePiece : string;WithLigneCompl:boolean=false;WithEntete:boolean=false);
var WithLigneFac : boolean;
		Sql : String;
{$IFDEF EAGLCLIENT}
		TOBST : TOB;
{$ELSE}
    QQ : TQuery;
{$ENDIF}

begin
  WithLigneFac := (pos(NaturePiece,'FBT;DAC')>0);
	Sql := MakeSelectLigneBtp (WithLigneCompl,WithEntete,WithLigneFac);
  Sql := Sql + ' WHERE 1=2'; // pour ne recup que la structure
{$IFDEF EAGLCLIENT}
	TOBST := BTPGetFieldStructure (Sql);
  SMemoriseChampsSupLigneETL(TOBST);
  TOBST.free;
{$ELSE}
  QQ := OpenSQL(Sql, True,-1, '', True);
  SMemoriseChampsSupLigneETL(QQ);
  ferme (QQ);
{$ENDIF}
end;

procedure MemoriseChampsSupPARCL (requete : string);
var
{$IFDEF EAGLCLIENT}
		TOBST : TOB;
{$ELSE}
    QQ : TQuery;
{$ENDIF}

begin
{$IFDEF EAGLCLIENT}
	TOBST := BTPGetFieldStructureParc (requete);
  SMemoriseChampsSupParcL(TOBST);
  TOBST.free;
{$ELSE}
  QQ := OpenSQL(requete, True,-1, '', True);
  SMemoriseChampsSupParcL(QQ);
  ferme (QQ);
{$ENDIF}
end;

{$IFNDEF EAGLSERVER}
procedure AddlesChampsSupLigneEtl (TOBL : TOB);
var Indice : integer;
		TOBEtl : TOB;
    NomChamps : string;
begin
	if TOBStructLig.detail.count = 0 then exit;
  TOBEtl := TOBStructLig.detail[0];
  //
  for Indice := 0 to TOBETL.NombreChampSup -1 do
  begin
  	NomChamps := TOBEtl.GetNomChamp(1000+Indice);
{$IFDEF EAGLCLIENT}
    if ExtractPrefixe(NomChamps) = 'GL' then continue;
{$ENDIF}
    if not TOBL.FieldExists(NomChamps) then
    begin
  		TOBL.AddChampSupValeur (NomChamps,TOBEtl.Getvaleur(1000+Indice));
    end else
    begin
      if varisnull(TOBL.GetValue(Nomchamps)) then
  		  TOBL.putvalue (NomChamps,TOBEtl.Getvaleur(1000+Indice));
    end;
  end;
end;
{$ENDIF}

{$IFNDEF EAGLSERVER}
procedure AddlesChampsSupParcl (TOBL : TOB);
var Indice : integer;
		TOBEtl : TOB;
    NomChamps : string;
begin
	if TOBStructParc.detail.count = 0 then exit;
  TOBEtl := TOBStructParc.detail[0];
  //
  for Indice := 0 to TOBETL.NombreChampSup -1 do
  begin
  	NomChamps := TOBEtl.GetNomChamp(1000+Indice);
{$IFDEF EAGLCLIENT}
    if ExtractPrefixe(NomChamps) = 'BP1' then continue;
{$ENDIF}
    if not TOBL.FieldExists(NomChamps) then
    begin
  		TOBL.AddChampSupValeur (NomChamps,TOBEtl.Getvaleur(1000+Indice));
    end;
  end;
end;
{$ENDIF}

{$IFNDEF EAGLSERVER}
procedure AddlesChampsSupOuv (TOBL : TOB);
var Indice : integer;
		TOBEtl : TOB;
    NomChamps : string;
begin
	if TOBStructParc.detail.count = 0 then exit;
  TOBEtl := TOBStructParc.detail[0];
  //
  for Indice := 0 to TOBETL.NombreChampSup -1 do
  begin
  	NomChamps := TOBEtl.GetNomChamp(1000+Indice);
{$IFDEF EAGLCLIENT}
    if ExtractPrefixe(NomChamps) = 'BLO' then continue;
{$ENDIF}
    if not TOBL.FieldExists(NomChamps) then
    begin
  		TOBL.AddChampSupValeur (NomChamps,TOBEtl.Getvaleur(1000+Indice));
    end;
  end;
end;
{$ENDIF}

{$IFNDEF EAGLSERVER}
INITIALIZATION
TOBSTRUCTLIG := TOB.Create (' LA  STRUCTURE LIGNE',nil,-1);
TOBStructParc := TOB.Create (' LA  STRUCTURE PARCL',nil,-1);
TOBStructLigOuv := TOB.Create (' LA  STRUCTURE OUVRAGE',nil,-1);
FINALIZATION
TOBSTRUCTLIG.free;
TOBStructParc.free;
TOBStructLigOuv.free;
{$ENDIF}

end.
