{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 27/10/2017
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BSAISIEAVANCPOC ()
Mots clefs ... : TOF;BSAISIEAVANCPOC
*****************************************************************}
Unit BSAISIEAVANCPOC_TOF ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
{$else}
     eMul,
{$ENDIF}
     uTob,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOF ;
const
   stLigPP  = 'IND;TYPEARTICLE;BM8_FAMILLENIV2;LIBFAMILLE2;BM8_QTEMARCHE;BM8_UNITE;BM8_POURCENTAVANC;BM8_QTEMOIS;BM8_QTECUMUL;BM8_RADQTE;QTEPROJETE;';
   stLigMOI = 'IND;TYPEARTICLE;BM8_FAMILLENIV2;LIBFAMILLE2;BM8_QTEMARCHE;BM8_UNITE;BM8_RADQTE;BM8_QTECUMUL;BM8_POURCENTAVANC;';
   stLigFI  = 'IND;TYPEARTICLE;BM8_FAMILLENIV2;LIBFAMILLE2;BM8_QTEMARCHE;BM8_UNITE;BM8_RADQTE;BM8_RADPU;BM8_RADMT;MTAVANCCALC;SUMQTECONSO;SUMMTCONSO;ECARTDEPENSE;';
   stLigST  = 'IND;TYPEARTICLE;BM8_CODEMARCHE;BM8_FAMILLENIV2;LIBFAMILLE2;BM8_QTEMARCHE;BM8_UNITE;PU;DEPENSECUMUL;DEPENSEESTIME;POURCENTCALC;BM8_POURCENTAVANC;BM8_MTCUMUL;';
   STAVANCSQL = 'SELECT BAVANCTECHDET.*, '+
                '(SELECT CC_LIBELLE FROM CHOIXCOD WHERE CC_TYPE="FN2" AND CC_CODE=BM8_FAMILLENIV2) AS LIBFAMILLE2,'+
                '0 AS QTEPROJETE,'+
                '0 AS MTAVANCCALC,'+
                '0 AS MTCUMULCALC,'+
                '0 AS SUMQTECONSO,'+
                '0 AS SUMMTCONSO,'+
                '0 AS ECARTDEPENSE,'+
                '0 AS DEPENSEESTIME,'+
                '0 AS POURCENTCALC '+
                'FROM BAVANCTECHDET';
Type

  TGSaisie = class (TObject)
    fName : string;
    fGS : THGrid;
    fStCellCur : string;
    fListSaisie : string;
  end;

  TListGs = class(TList)
  private
    function Add(AObject: TGSaisie): Integer;
    function GetItems(Indice: integer): TGSaisie;
    procedure SetItems(Indice: integer; const Value: TGSaisie);
    procedure AddGrille(TG : THgrid; NomGrille, ListeSaisie: String);
  public
    constructor create;
    destructor destroy; override;
    property Items [Indice : integer] : TGSaisie read GetItems write SetItems;
    function findGrille (NomGrille : string ): TGSaisie;
    procedure clear; override;
  end;

  TOF_BSAISIEAVANCPOC = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  private
    TheListGrid : TListGs;
    TOBPP,TOBMOI,TOBFI,TOBST : TOB;
    FFP,FFQ : string;
    // info de siasie sur grille courante
    StGrid: string;
    GS : THGrid;
    stCellCur : string;
    // ---
    procedure ChargeTOBS;
    procedure ChargeGrids;
    procedure PrepareGrids;
    procedure PrepareGrid(Nomgrille : String);
    procedure TraiteChamps(GS : THGrid;NomChamps: string;Colonne : integer);
  end ;

Implementation

procedure TOF_BSAISIEAVANCPOC.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BSAISIEAVANCPOC.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BSAISIEAVANCPOC.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_BSAISIEAVANCPOC.OnLoad ;
begin
  Inherited ;
  ChargeTOBS;
  ChargeGrids;
end ;

procedure TOF_BSAISIEAVANCPOC.OnArgument (S : String ) ;
var i : Integer;
begin
  Inherited ;
  //
  FFP := '#';
  if V_PGI.OkDecP > 0 then
  begin
    FFP := '0.';
    for i := 1 to V_PGI.OkDecP - 1 do
    begin
      FFP := FFP + '#';
    end;
    FFP := FFP + '0';
  end;
  //
  FFQ := '#';
  if V_PGI.OkDecQ > 0 then
  begin
    FFQ := '0.';
    for i := 1 to V_PGI.OkDecQ - 1 do
    begin
      FFQ := FFQ + '#';
    end;
    FFQ := FFQ + '0';
  end;
  //
  TOBPP := TOB.Create('SAISIE PP',nil,-1);
  TOBMOI := TOB.Create('SAISIE MOI',nil,-1);
  TOBFI := TOB.Create('SAISIE FI',nil,-1);
  TOBST := TOB.Create('SAISIE ST',nil,-1);
  //
  TheListGrid := TListGs.create;
  TheListGrid.AddGrille(THGrid(GetControl('GSPP')),'GSPP',stLigPP);
  TheListGrid.AddGrille(THGrid(GetControl('GSMOI')),'GSMOI',stLigMOI);
  TheListGrid.AddGrille(THGrid(GetControl('GSFI')),'GSFI',stLigFI);
  TheListGrid.AddGrille(THGrid(GetControl('GSST')),'GSST',stLigST);
  //
  //
  PrepareGrids;
end ;

procedure TOF_BSAISIEAVANCPOC.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BSAISIEAVANCPOC.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BSAISIEAVANCPOC.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BSAISIEAVANCPOC.ChargeGrids;
begin

end;

procedure TOF_BSAISIEAVANCPOC.ChargeTOBS;
begin

end;

procedure TOF_BSAISIEAVANCPOC.PrepareGrids;
begin
  PrepareGrid('GSPP');
  PrepareGrid('GSMOI');
  PrepareGrid('GSFI');
  PrepareGrid('GSST');
end;


procedure TOF_BSAISIEAVANCPOC.PrepareGrid ( Nomgrille : String);
var II : Integer;
    STST,STdet : string;
    TGS : TGSaisie;
begin
  TGS := TheListGrid.findGrille(Nomgrille);
  STST := TGS.fListSaisie;
  II := 0;
  STdet := READTOKENST(STST);
  repeat
    if STDET = '' then exit;
    TraiteChamps(TGS.fGS,TGS.fListSaisie,II);
    STdet := READTOKENST(STST);
    inc(II);
  until STdet = '';
end;

procedure TOF_BSAISIEAVANCPOC.TraiteChamps(GS: THGrid; NomChamps: string; Colonne: integer);
begin
  if NomChamps='IND' then
  begin
    GS.cells[Colonne,0] := ' ';
    GS.ColWidths [Colonne] := 20;
    GS.ColEditables[Colonne] := false;
  end else if NomChamps='TYPEARTICLE' then
  begin
    GS.cells[Colonne,0] := ' ';
    GS.ColWidths[colonne] := 48;
    GS.ColAligns[Colonne] := taLeftJustify;
  end else if NomChamps='BM8_FAMILLENIV2' then
  begin
    GS.cells[Colonne,0] := 'Référence';
    GS.ColWidths[colonne] := 48;
    GS.ColLengths[colonne] := 3;
    GS.ColAligns[Colonne] := taLeftJustify;
  end else if NomChamps='LIBFAMILLE2' then
  begin
    GS.cells[Colonne,0] := 'Analytique';
    GS.ColWidths[colonne] := 50*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 70;
    GS.ColAligns[Colonne] := taLeftJustify;
  end else if NomChamps='BM8_QTEMARCHE' then
  begin
    GS.cells[Colonne,0] := 'Quantité';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := FFQ+';'+FFQ+'; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='BM8_UNITE' then
  begin
    GS.cells[Colonne,0] := 'Unité';
    GS.ColWidths[colonne] := 5*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 5;
    GS.ColAligns[Colonne] := taCenter;
  end else if NomChamps='BM8_POURCENTAVANC' then
  begin
    GS.cells[Colonne,0] := '% Avct';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := '#0.00;#0.00; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='BM8_QTEMOIS' then
  begin
    GS.cells[Colonne,0] := 'Qté Avct';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := FFQ+';'+FFQ+'; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='BM8_QTECUMUL' then
  begin
    GS.cells[Colonne,0] := 'Qté Dépensés Cumul.';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := FFQ+';'+FFQ+'; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='BM8_RADQTE' then
  begin
    GS.cells[Colonne,0] := 'Qté RAD';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := FFQ+';'+FFQ+'; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='BM8_QTECUMUL' then
  begin
    GS.cells[Colonne,0] := 'Qté Fin chantier';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := FFQ+';'+FFQ+'; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='BM8_RADPU' then
  begin
    GS.cells[Colonne,0] := 'RAD Pu';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := FFP+';'+FFP+'; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='BM8_RADMT' then
  begin
    GS.cells[Colonne,0] := 'RAD Mt';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := '#0 000.00;#0 000.00; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='MTAVANCCALC' then
  begin
    GS.cells[Colonne,0] := 'Mt Avanc. Calc.';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := '#0 000.00;#0 000.00; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='SUMQTECONSO' then
  begin
    GS.cells[Colonne,0] := 'Qté Cumulé Cons.';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := FFQ+';'+FFQ+'; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='SUMMTCONSO' then
  begin
    GS.cells[Colonne,0] := 'Mt Cumulé Cons.';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := '#0 000.00;#0 000.00; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='ECARTDEPENSE' then
  begin
    GS.cells[Colonne,0] := 'Variation M/M-1';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := '#0 000.00;#0 000.00; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='PU' then
  begin
    GS.cells[Colonne,0] := 'Pu Achat';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := FFP+';'+FFP+'; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='DEPENSECUMUL' then
  begin
    GS.cells[Colonne,0] := 'Dépenses Cumul.';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := '#0 000.00;#0 000.00; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='DEPENSEESTIME' then
  begin
    GS.cells[Colonne,0] := 'Dépenses Estimées';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := '#0 000.00;#0 000.00; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='POURCENTCALC' then
  begin
    GS.cells[Colonne,0] := '% Avct calc.';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := '#0.00;#0.00; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end else if NomChamps='BM8_MTCUMUL' then
  begin
    GS.cells[Colonne,0] := 'MT Avct corrigé';
    GS.ColWidths[colonne] := 12*GS.canvas.TextWidth('w');
    GS.ColLengths[colonne] := 12;
    GS.ColFormats[colonne] := '#0.00;#0.00; ;';
    GS.ColAligns[Colonne] := taRightJustify;
  end;
end;

{ TListGs }

function TListGs.Add(AObject: TGSaisie): Integer;
begin
	Result := inherited ADD(Aobject);
end;

procedure TListGs.AddGrille(TG : THgrid; NomGrille, ListeSaisie: String);
var TT : TGSaisie;
begin
  TT := TGSaisie.Create;
  TT.fName := NomGrille;
  TT.fGS := TG;
  TT.fListSaisie := ListeSaisie;
  add(TT);
end;

procedure TListGs.clear;
var indice : integer;
begin
  if count > 0 then
  begin
    for Indice := count -1 downto 0 do
    begin
      if TGSaisie(Items [Indice])<> nil then
      begin
         TGSaisie (Items [Indice]).free;
         Items[Indice] := nil;
      end;
    end;
  end;
  inherited;
end;

constructor TListGs.create;
begin

end;

destructor TListGs.destroy;
begin
	clear;
  inherited;
end;

function TListGs.findGrille(NomGrille: string): TGSaisie;
var Indice : integer;
begin
  result := nil;
  for Indice := 0 to Count -1 do
  begin
    if Items[Indice].fName = NomGrille then
    begin
      result:=Items[Indice];
      break;
    end;
  end;
end;

function TListGs.GetItems(Indice: integer): TGSaisie;
begin
  result := TGSaisie (Inherited Items[Indice]);
end;

procedure TListGs.SetItems(Indice: integer; const Value: TGSaisie);
begin
  Inherited Items[Indice]:= Value;
end;

Initialization
  registerclasses ( [ TOF_BSAISIEAVANCPOC ] ) ;
end.
