unit UApplication;

interface
uses
  AglInit,
	hctrls,
{$IFDEF EAGLCLIENT}
     MenuOLX,Maineagl,
{$ELSE}
     MenuOLG,Fe_Main,
{$ENDIF}
	LicUtil,
  sysutils,
  HEnt1,
	windows,
  inifiles,
  CBPPath,
  Classes,
  utilpgi,
  forms
  ;

const INIFILE = 'GAMME-PRODUIT.LSE';
      INISEP = 'SEPARATION.LSE';
var
  GCCodesSeria : array[1..12] of string;
  GCTitresSeria : array[1..12] of Hstring;
	GCCodeDomaine : string;
  NumRefObligatoire : string = '998.ZZO';
  VersionInterne : Boolean;

procedure GetInfoApplication;
procedure GetInfoMajApplication;


implementation

procedure InitPlace;
begin
  V_PGI.LaSerie:=S5 ;
  GCCodeDomaine := '00086010'; //
  TitreHalley:='L.S.E Business BTP PLACE' ;
  GCCodesSeria [1] :='00083090'; GCTitresSeria [1] := 'Etudes & Situations';
  GCCodesSeria [2] :='00311090'; GCTitresSeria [2] := 'Récupération des Appels d''offres';
  GCCodesSeria [3] :='00312090'; GCTitresSeria [3] := 'Achats/Stocks';
  GCCodesSeria [4] :='00313090'; GCTitresSeria [4] := 'Gestion des chantiers';
  GCCodesSeria [5] :='00314090'; GCTitresSeria [5] := 'Relations Clients';
  GCCodesSeria [6] :='00316090'; GCTitresSeria [6] := 'Contrats';
  GCCodesSeria [7] :='00416090'; GCTitresSeria [7] := 'Interventions';
  GCCodesSeria [8] :='14900090'; GCTitresSeria [8] := 'Cotraitance';
  GCCodesSeria [9] :='14902090'; GCTitresSeria [9] := 'Sous-traitance';    //
  GCCodesSeria [10] :='14905090'; GCTitresSeria [10] := 'Commerce de détail';    //
  GCCodesSeria [11] :='14906090'; GCTitresSeria [11] := 'Plan de charge chantiers';    //
  GCCodesSeria [12] :='14907090'; GCTitresSeria [12] := 'Parc matériel';    //
end;

procedure SetinitDefaut;
begin
  // définition par défaut
  InitPlace;
  HalSocIni:='cegidpgi.ini' ;
  VersionInterne := false;
end;

procedure GetInfoApplication;
var ExeRepert : string;
		Iexist : Integer;
    IniApplication : Tinifile;
    SeparationCEGIDLSE : Boolean;
    HalSocSpe : string;
begin
  SeparationCEGIDLSE := false;
  //
  SetInitDefaut;

  Exerepert := ExtractFilePath (Application.ExeName); // repertoire de l'application

  //
  Iexist := FileOpen(IncludeTrailingBackslash(Exerepert)+INISEP,fmOpenRead );
  if Iexist > 0 then SeparationCEGIDLSE := True;
  FileClose(Iexist);

  if SeparationCEGIDLSE then
  begin
    IniApplication := TiniFile.create (IncludeTrailingBackslash (Exerepert)+INISEP);
    HalSocSpe := IniApplication.ReadString('Application','CEGIDPGIINI','');
    if HalSocSpe <> '' then HalSocIni := HalSocSpe;
  	IniApplication.Free;
  end;

  Iexist := FileOpen(IncludeTrailingBackslash(Exerepert)+INIFILE,fmOpenRead );
  if Iexist < 0 then Exit;
  FileClose(Iexist);

  IniApplication := TiniFile.create (IncludeTrailingBackslash (Exerepert)+INIFILE);
  NomHalley := IniApplication.ReadString('Application','Nom','');
  VersionInterne := IniApplication.ReadString('Application','KIKONEST','')='CNOUS';
  if NomHalley = 'CBTPS5' then
  begin
    // PLACE
    InitPlace;
    //
  end else if NomHalley = 'CBTPS3' then
  begin
    // SUITE
		V_PGI.LaSerie:=S3 ;
    GCCodeDomaine := '00056010';
    TitreHalley:='L.S.E Business BTP SUITE' ;
		GCCodesSeria [1] :='00055090'; GCTitresSeria [1] := 'Etudes & Situations';
    GCCodesSeria [2] :='00084090'; GCTitresSeria [2] := 'Récupération des Appels d''offres';
    GCCodesSeria [3] :='00094090'; GCTitresSeria [3] := 'Achats/Stocks';
    GCCodesSeria [4] :='00210090'; GCTitresSeria [4] := 'Gestion des chantiers';
    GCCodesSeria [5] :='00254090'; GCTitresSeria [5] := 'Relations Clients';
    GCCodesSeria [6] :='00255090'; GCTitresSeria [6] := 'Contrats';
    GCCodesSeria [7] :='00256090'; GCTitresSeria [7] := 'Interventions';
    GCCodesSeria [8] :='14901090'; GCTitresSeria [8] := 'Cotraitance';
    GCCodesSeria [9] :='14903090'; GCTitresSeria [9] := 'Sous-traitance';    //
  	GCCodesSeria [10] :='14904090'; GCTitresSeria [10] := 'Commerce de détail';    //
  	GCCodesSeria [11] :='14906090'; GCTitresSeria [11] := 'Plan de charge chantiers';    //
  	GCCodesSeria [12] :='14907090'; GCTitresSeria [12] := 'Parc matériel';    //
  end else if NomHalley = 'CBTPS1' then
  begin
    // START
		V_PGI.LaSerie:=S3 ;
    GCCodeDomaine := '00595010';
    TitreHalley:='L.S.E Business BTP LINE' ;
		GCCodesSeria [1] :='00055090'; GCTitresSeria [1] := 'Devis - Factures';
    GCCodesSeria [2] :='00084090'; GCTitresSeria [2] := 'Récupération des Appels d''offres';
    GCCodesSeria [3] :='00094090'; GCTitresSeria [3] := 'Achats/Stocks';
    GCCodesSeria [4] :='00210090'; GCTitresSeria [4] := 'Gestion des chantiers';
    GCCodesSeria [5] :='00254090'; GCTitresSeria [5] := 'Relations Clients';
    GCCodesSeria [6] :='00255090'; GCTitresSeria [6] := 'Contrats';
    GCCodesSeria [7] :='00256090'; GCTitresSeria [7] := 'Interventions';
    GCCodesSeria [8] :='14901090'; GCTitresSeria [8] := 'Cotraitance';
    GCCodesSeria [9] :='14903090'; GCTitresSeria [9] := 'Sous-traitance';    //
  	GCCodesSeria [10] :='14904090'; GCTitresSeria [10] := 'Commerce de détail';    //
  	GCCodesSeria [11] :='14906090'; GCTitresSeria [11] := 'Plan de charge chantiers';    //
  	GCCodesSeria [12] :='14907090'; GCTitresSeria [12] := 'Parc matériel';    //
  end;
  IniApplication.Free;
end;

procedure GetInfoMajApplication;
var ExeRepert : string;
		Iexist : Integer;
    IniApplication : Tinifile;
    SeparationCEGIDLSE : Boolean;
    HalSocSpe : string;
begin
  SeparationCEGIDLSE := false;
  //
  HalSocIni:='cegidpgi.ini' ;
  VersionInterne := false;

  Exerepert := ExtractFilePath (Application.ExeName); // repertoire de l'application

  //
  Iexist := FileOpen(IncludeTrailingBackslash(Exerepert)+INISEP,fmOpenRead );
  if Iexist > 0 then SeparationCEGIDLSE := True;
  FileClose(Iexist);

  if SeparationCEGIDLSE then
  begin
    IniApplication := TiniFile.create (IncludeTrailingBackslash (Exerepert)+INISEP);
    HalSocSpe := IniApplication.ReadString('Application','CEGIDPGIINI','');
    if HalSocSpe <> '' then HalSocIni := HalSocSpe;
  	IniApplication.Free;
  end;
end;


end.
