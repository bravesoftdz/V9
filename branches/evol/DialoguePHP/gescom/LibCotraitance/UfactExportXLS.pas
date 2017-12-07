unit UfactExportXLS;

interface

uses UtilXlsBTP,
		UTOB,
    uEntCommun,
    HMsgBox,
    Forms,
    SysUtils,
    UExportPiece,
    graphics,
    classes,
    paramsoc,
    controls,
    HEnt1,
    variants,
    UdefExport,
    TiersUtil;

type
  TcellExcell = record
  	Row : integer;
    Column : integer;
    NbCols : integer;
  end;

  Tinterval = record
  	ligDep : integer;
    ligFin : integer;
  end;

	TexportDocXls = class (Tobject)
  	private
    	fTypeExport : TTypeExport;
      fModeExport : TmodeExport;
    	fExportTOB  : TExportDocTOB;
    	fDocExcel   : string;
      fdocresult  : string;
      fModeAction : TmodeAction;
      fSilent     : boolean;
    	fAffaire    : string;
    	fTOBPiece   : TOB;
    	fTOBOuvrage : TOB;
      fTOBexport  : TOB;
      fnewInst    : boolean;
    	fFournisseur: String;
      fNomFrs     : String;
    	fcledoc     : r_cledoc;
      fWinExcel   : OleVariant;
      fWorkBook   : Variant;
      fWorkSheet  : Variant;

      // Infos sur la structure du document à exporter
      fRefFournisseur : Tcellexcell;
      fRefLibelleLot  : Tcellexcell;
      fRefLigneDoc    : Tcellexcell;
      fRefArtLigne    : Tcellexcell;
      fRefLibelleLigne: Tcellexcell;
      fRefUniteLigne  : Tcellexcell;
      fRefQteLigne    : TCellExcell;
      fRefPuLigne     : TcellExcell;
      fRefMontant     : TcellExcell;
      //
      fparagNiv1  : TInfoFont;
      fparagNiv2  : TInfoFont;
      fparagNiv3  : TInfoFont;
      fparagNiv4  : TInfoFont;
      fparagNiv5  : TInfoFont;
      fparagNiv6  : TInfoFont;
      fparagNiv7  : TInfoFont;
      fparagNiv8  : TInfoFont;
      fparagNiv9  : TInfoFont;
      fouvrage    : TInfoFont;
      fsousDetail : TInfoFont;
      fsoustotal  : TInfoFont;
      fVariante   : TInfoFont;
      //
      fDecalSousDetail: integer;
      fDecalparag     : integer;
      fminCol         : Integer;
      fmaxCol         : integer;

      procedure SetModeAction(const Value: TmodeAction);
    	procedure SetFournisseur(const Value: string);
      procedure SetNomFrs(const Value: string);
    	function RecupereParams: boolean;
      function RecupPresentation : boolean;
      procedure RemplitDocXls;
    	procedure SetInfoDocument(TOBDocument: TOB; NomLot: string);
    	procedure SetTypeExport(const Value: TTypeExport);
   		procedure SetModeExport(const Value: TModeExport);
    public
    	constructor create;
      destructor destroy; override;
      property Affaire : string read fAffaire write fAffaire;
      property Document : TOB read fTOBpiece write fTOBPiece;
      property Ouvrages : TOB read fTOBOuvrage write fTOBOuvrage;
      property CleDoc : r_cledoc read fcledoc write fCledoc;
      property Fournisseur : string read fFournisseur write SetFournisseur;
      property NomFrs : string read fNomFrs write SetNomFrs;
      property ModeAction : TmodeAction read fModeAction write SetModeAction;
      property TypeExport : TTypeExport read fTypeExport write SetTypeExport;
      property ModeExport : TModeExport read fModeExport write SetModeExport;
      property Silencieux : boolean read fSilent write fSilent;
      property NomDocumentResultat : string read fdocresult;
      procedure Genere;
  end;

function GenereDocumentXls (cledoc : r_cledoc;Fournisseur: string) : string;
procedure LanceExportDocument (Affaire,Fournisseur: string); OVERLOAD;
procedure LanceExportDocument (cledoc : r_cledoc;Fournisseur: string); overload
procedure LanceExportDocument (TOBPiece,TOBOuvrages : TOB;Fournisseur: string); overload

implementation

procedure LanceExportDocument (Affaire,Fournisseur: string);
var ExportXlsDoc    : TexportDocXls;
    LibFournisseur  : string;
begin
	if Affaire <> '' then
  begin
    ExportXlsDoc := TexportDocXls.create;
    TRY
      If GetLibTiers('FOU', Fournisseur, LibFournisseur) then
      begin
        ExportXlsDoc.Affaire    := Affaire;
        ExportXlsDoc.ModeExport := TmeExcel;
        ExportXlsDoc.TypeExport := TteCotrait;
        ExportXlsDoc.Fournisseur:= Fournisseur;
        ExportXlsDoc.NomFrs     := LibFournisseur;
        ExportXlsDoc.ModeAction := XmaAffaire;
        ExportXlsDoc.Genere;
      end;
    FINALLY
    	ExportXlsDoc.free;
    End;
  end;
end;

procedure LanceExportDocument (cledoc : r_cledoc;Fournisseur: string );
var ExportXlsDoc    : TexportDocXls;
    LibFournisseur  : string;
begin
  ExportXlsDoc := TexportDocXls.create;
  TRY
    If GetLibTiers('FOU', Fournisseur, LibFournisseur) then
    begin
      ExportXlsDoc.CleDoc  := cledoc ;
      ExportXlsDoc.ModeExport  := TmeExcel;
      ExportXlsDoc.TypeExport := TteCotrait;
      ExportXlsDoc.Fournisseur  := Fournisseur;
      ExportXlsDoc.NomFrs     := LibFournisseur;
      ExportXlsDoc.ModeAction := XmaDocument;
      ExportXlsDoc.Genere;
    end;
  FINALLY
    ExportXlsDoc.free;
  End;
end;

function GenereDocumentXls (cledoc : r_cledoc;Fournisseur: string) : string;
var ExportXlsDoc    : TexportDocXls;
    LibFournisseur  : string;
begin
  Result := '';
  ExportXlsDoc := TexportDocXls.create;
  TRY
    If GetLibTiers('FOU', Fournisseur, LibFournisseur) then
    begin
      ExportXlsDoc.CleDoc     := cledoc ;
      ExportXlsDoc.ModeExport := TmeExcel;
      ExportXlsDoc.TypeExport := TteCotrait;
      ExportXlsDoc.Fournisseur:= Fournisseur;
      ExportXlsDoc.NomFrs     := LibFournisseur;
      ExportXlsDoc.ModeAction := XmaDocument;
      ExportXlsDoc.Silencieux := true;
      ExportXlsDoc.Genere;
      Result := ExportXlsDoc.NomDocumentResultat;
    end;
  FINALLY
    ExportXlsDoc.free;
  End;
end;

procedure LanceExportDocument (TOBPiece,TOBOuvrages : TOB;Fournisseur: string);
var ExportXlsDoc    : TexportDocXls;
    LibFournisseur  : string;
begin
  ExportXlsDoc := TexportDocXls.create;
  TRY
    If GetLibTiers('FOU', Fournisseur, LibFournisseur) then
    begin
      ExportXlsDoc.Document   := TOBPiece;
      ExportXlsDoc.ModeExport := TmeExcel;
      ExportXlsDoc.TypeExport := TteCotrait;
      ExportXlsDoc.Ouvrages   := TOBouvrages;
      ExportXlsDoc.Fournisseur:= Fournisseur;
      ExportXlsDoc.NomFrs     := LibFournisseur;
      ExportXlsDoc.ModeAction := XmaDocument;
      ExportXlsDoc.Genere;
    end;
  FINALLY
    ExportXlsDoc.free;
  End;
end;

{ TexportDocXls }

constructor TexportDocXls.create;
begin
	fTypeExport := TteUndefined;
  fModeExport := TmeUndefined;
	fMinCol := 9999;
  fmaxCol:= 0;
  fSilent := false; // par defaut
  fExportTOB := TExportDocTOB.create;
  fModeAction := XmaDocument;
  fillchar(fcledoc,sizeof(fcledoc),0);
  fTOBExport := TOB.Create ('LESINFOSAEXPORTER',nil,-1);
  fTOBexport.AddChampSupValeur('DESCRIPTIF','');
  //
  fparagNiv1.Font := TFont.Create;
  fparagNiv1.Brush := TBrush.Create;
  //
  fparagNiv2.Font := TFont.Create;
  fparagNiv2.Brush:= Tbrush.Create;
  //
  fparagNiv3.Font := TFont.Create;
  fparagNiv3.Brush:= Tbrush.Create;
  //
  fparagNiv4.Font := TFont.Create;
  fparagNiv4.Brush:= Tbrush.Create;
  //
  fparagNiv5.Font := TFont.Create;
  fparagNiv5.Brush:= Tbrush.Create;
  //
  fparagNiv6.Font := TFont.Create;
  fparagNiv6.Brush:= Tbrush.Create;
  //
  fparagNiv7.Font := TFont.Create;
  fparagNiv7.Brush:= Tbrush.Create;
  //
  fparagNiv8.Font := TFont.Create;
  fparagNiv8.Brush:= Tbrush.Create;
  //
  fparagNiv9.Font := TFont.Create;
  fparagNiv9.Brush:= Tbrush.Create;
  //
  fouvrage.Font := TFont.Create;
  fouvrage.Brush:= Tbrush.Create;
  //
  fsousDetail.Font := TFont.Create;
  fsousDetail.Brush:= Tbrush.Create;
  //
  fVariante.Font := TFont.Create;
  fVariante.Brush:= Tbrush.Create;
  //
  fsoustotal.Font := TFont.Create;
  fsoustotal.Brush:= Tbrush.Create;



end;

destructor TexportDocXls.destroy;
begin
	if not VarIsEmpty(fWinExcel) then
  begin
    fWinExcel.quit;
    fWinExcel := unassigned;
  end;
  FreeAndnil(fExportTOB);
  FreeAndNil(fTOBexport);
  //
  fparagNiv1.Font.free;
  fparagNiv1.Brush.free;
  //
  fparagNiv2.Font.free;
  fparagNiv2.Brush.free;
  //
  fparagNiv3.Font.free;
  fparagNiv3.Brush.free;
  //
  fparagNiv4.Font.free;
  fparagNiv4.Brush.free;
  //
  fparagNiv5.Font.free;
  fparagNiv5.Brush.free;
  //
  fparagNiv6.Font.free;
  fparagNiv6.Brush.free;
  //
  fparagNiv7.Font.free;
  fparagNiv7.Brush.free;
  //
  fparagNiv8.Font.free;
  fparagNiv8.Brush.free;
  //
  fparagNiv9.Font.free;
  fparagNiv9.Brush.free;
  //
  fouvrage.Font.free;
  fouvrage.Brush.free;
  //
  fsousDetail.Font.free;
  fsousDetail.Brush.free;
  //
  fVariante.Font.free;
  fVariante.Brush.free;
  //
  fsoustotal.Font.free;
  fsoustotal.Brush.free;



  inherited;
end;

procedure TexportDocXls.Genere;
var Repert,filenameXls,FilenameXML : string;
begin
	if fTypeExport = TteUndefined then
  begin
  	PgiInfo ('Type d''export non défini',application.name);
    exit;
  end;
	if fModeExport = TmeUndefined then
  begin
  	PgiInfo ('Type d''export non défini',application.name);
    exit;
  end;
	Repert := getparamSocSecur('SO_BTSTOCKAGEEXPORT','');
	if  Repert = '' then
  begin
  	PgiInfo ('veuillez renseigner l''emplacement de stockage des exports',application.name);
    exit;
  end;
	if (fModeAction = XmaAffaire) and (fAffaire='') then
  begin
  	PgiInfo ('Renseignez l''affaire',application.Name );
    exit;
  end else if (fModeAction = XmaDocument) and ((fTOBPiece=nil) or (fTOBPiece.nomtable <> 'PIECE')) and (CleDoc.NaturePiece='') then
  begin
  	PgiInfo ('Renseignez le document',application.Name );
    exit;
  end;
  if fModeExport = TmeExcel then
  begin
    if not OpenExcel(true,fWinExcel,fNewInst) then
    begin
      PgiError ('Excel n''est pas installé sur ce poste',application.name);
      exit;
    end;
  end;
  fTOBexport.clearDetail;
  fTOBexport.InitValeurs(false);
  if fModeExport = TmeExcel then
  begin
    fWorkBook := OpenWorkBook(fDocExcel ,fWinExcel);
    TRY
      if not RecupereParams then
      begin
        PgiInfo ('Paramètrage incorrect du document Excel',Application.name);
        exit;
      end;
    EXCEPT
      exit;
    END;
  end;
  //
  if fModeAction=XmaAffaire then
  begin
  	fExportTOB.Affaire      := faffaire;
    fExportTOB.Fournisseur  := fFournisseur;
    fExportTOB.NomFrs       := fNomFrs;
    fExportTOB.TypeExport   := fTypeExport;
  	fExportTOB.TOBResult    := fTOBexport;
    fExportTOB.constitueExport;
    FilenameXls := fNomFrs + '-' + Ffournisseur+'-'+faffaire+'.xlsx';
    FilenameXML := fNomFrs + '-' + Ffournisseur+'-'+faffaire+'.xml';
  end
  else
  begin
  	if fcledoc.NaturePiece <> '' then
    begin
    	if ffournisseur <> '' then
      begin
      	FilenameXls := fNomFrs+'-'+Ffournisseur+'-'+cledoc.NaturePiece+'-'+inttostr(cledoc.NumeroPiece)+'.xlsx';
      	FilenameXML := fNomFrs+'-'+Ffournisseur+'-'+cledoc.NaturePiece+'-'+inttostr(cledoc.NumeroPiece)+'.xml';
      end
      else
      begin
      	FilenameXls := cledoc.NaturePiece+'-'+inttostr(cledoc.NumeroPiece)+'.xlsx';
      	FilenameXml := cledoc.NaturePiece+'-'+inttostr(cledoc.NumeroPiece)+'.xml';
      end;
      fExportTOB.CleDoc       := fcledoc;
      fExportTOB.Fournisseur  := fFournisseur;
      fExportTOB.NomFrs       := fNomFrs;
      fExportTOB.TypeExport   := fTypeExport;
      fExportTOB.TOBResult    := fTOBexport;
      fExportTOB.constitueExport;
    end
    else
    begin
    	fExportTOB.TOBpiece     := fTOBPiece;
      fExportTOB.Fournisseur  := fFournisseur;
      fExportTOB.NomFrs       := fNomFrs;
      fExportTOB.TypeExport   := fTypeExport;
      fExportTOB.TOBResult    := fTOBexport;
      fExportTOB.constitueExport;
    end;
  end;

  if fTOBExport.detail.count = 0 then exit;

  if fModeExport = TmeExcel then
  begin
    RemplitDocXls;
    DelSheet(fWorkBook,'Dummy');
    DelSheet(fWorkBook,'présentation');
    ExcelSave (fWorkBook ,IncludeTrailingBackslash (Repert)+FileNameXls);
    fdocresult := IncludeTrailingBackslash (Repert)+FileNameXls;
    if not fSilent then
    begin
      if Pgiask ('Document '+FilenameXls+' généré avec succès.#13#10 #13#10 Désirez-vous le visualiser ?')= mryes then
      begin
        if not VarIsEmpty(fWinExcel) then
        begin
          fWinExcel.quit;
          fWinExcel := unassigned;
        end;
        FileExecAndWait (GetExcelPath + 'EXCEL.exe "' + IncludeTrailingBackslash (Repert)+FileNameXls + '"');
      end;
    end;
  end else
  begin
  	fTOBexport.SaveToXmlFile(IncludeTrailingBackslash (Repert)+FileNameXml,true,true,false,'','',false);
  end;
  //
end;

function TexportDocXls.RecupereParams : boolean;
var iRow,Icol,NbCols : integer;
begin
  // Récupération de la présentation
  result := RecupPresentation;
  if not result then exit;
  // mémorisation de l'emplacement du code fournisseur interne (zone non visible)
	iRow := 0; ICol := 0;
 	ExcelFindRange (fWorkBook,'Dummy','REFFOURNISSEUR',iRow,iCol,NbCols);
  //if ICol = 0 then begin result := false; Exit; END;
  fRefFournisseur.Column := Icol;
  fRefFournisseur.Row  := IRow;
  fRefFournisseur.NbCols   := NbCols;
  // mémorisation de l'emplacement du libelle du lot
	iRow := 0; ICol := 0;
 	ExcelFindRange (fWorkBook,'Dummy','REFEXTERNE',iRow,iCol,NbCols);
  //if ICol = 0 then begin result := false; Exit; END;
  fRefLibelleLot.Column := iCol;
  fRefLibelleLot.Row := iRow;
  fRefLibelleLot.NbCols   := NbCols;
  // mémorisation de l'emplacement du lien avec la ligne de document
	iRow := 0; ICol := 0;
 	ExcelFindRange (fWorkBook,'Dummy','REFLIGNE',iRow,iCol,NbCols);
  if ICol = 0 then begin result := false; Exit; END;
  fRefLigneDoc.Column := iCol;
  fRefLigneDoc.Row := iRow; // variable
  fRefLigneDoc.NbCols   := NbCols;
  // mémorisation de la reference de l'article dans le document
	iRow := 0; ICol := 0;
 	ExcelFindRange (fWorkBook,'Dummy','REFARTLIGNE',iRow,iCol,NbCols);
//  if ICol = 0 then begin result := false; Exit; END;
  fRefArtLigne.Column := iCol;
  fRefArtLigne.Row := iRow; // variable
  fRefArtLigne.NbCols   := NbCols;
  if (iCol <> 0) and (icol < fMinCol) then fMinCol := iCol;
  if (iCol <> 0) and (iCol > fMaxCol) then fMaxCol := iCol;

  // mémorisation de l'emplacement du lien avec le libelle de la ligne de document
	iRow := 0; ICol := 0;
 	ExcelFindRange (fWorkBook,'Dummy','LIBELLELIGNE',iRow,iCol,NbCols);
  if ICol = 0 then begin result := false; Exit; END;
  fRefLibelleLigne.Column := iCol;
  fRefLibelleLigne.Row := iRow; // variable
  fRefLibelleLigne.NbCols   := NbCols;
  if (iCol <> 0) and (icol < fMinCol) then fMinCol := iCol;
  if (iCol <> 0) and (iCol > fMaxCol) then fMaxCol := iCol;

  // mémorisation de l'emplacement du lien avec l'unité de la ligne de document
	iRow := 0; ICol := 0;
 	ExcelFindRange (fWorkBook,'Dummy','UNITELIGNE',iRow,iCol,NbCols);
  if ICol = 0 then begin result := false; Exit; END;
  fRefUniteLigne.Column := iCol;
  fRefUniteLigne.Row := iRow; // variable
  fRefUniteLigne.NbCols   := NbCols;
  if (iCol <> 0) and (icol < fMinCol) then fMinCol := iCol;
  if (iCol <> 0) and (iCol > fMaxCol) then fMaxCol := iCol;
  // mémorisation de l'emplacement du lien avec la quantité de la ligne de document
	iRow := 0; ICol := 0;
 	ExcelFindRange (fWorkBook,'Dummy','QTELIGNE',iRow,iCol,NbCols);
  if ICol = 0 then begin result := false; Exit; END;
  fRefQteLigne.Column := iCol;
  fRefQteLigne.Row := iRow; // variable
  fRefQteLigne.NbCols   := NbCols;
  if (iCol <> 0) and (icol < fMinCol) then fMinCol := iCol;
  if (iCol <> 0) and (iCol > fMaxCol) then fMaxCol := iCol;
  // mémorisation de l'emplacement du lien avec le PU de la ligne de document
	iRow := 0; ICol := 0;
 	ExcelFindRange (fWorkBook,'Dummy','PULIGNE',iRow,iCol,NbCols);
  if ICol = 0 then begin result := false; Exit; END;
  fRefPuLigne.Column := iCol;
  fRefPuLigne.Row := iRow; // variable
  fRefPuLigne.NbCols   := NbCols;
  if (iCol <> 0) and (icol < fMinCol) then fMinCol := iCol;
  if (iCol <> 0) and (iCol > fMaxCol) then fMaxCol := iCol;
	iRow := 0; ICol := 0;
 	ExcelFindRange (fWorkBook,'Dummy','MTLIGNE',iRow,iCol,NbCols);
  if ICol <> 0 then
  begin
    fRefMontant.Column := iCol;
    fRefMontant.Row := iRow; // variable
  	fRefMontant.NbCols   := NbCols;
  end;
  if (iCol <> 0) and (icol < fMinCol) then fMinCol := iCol;
  if (iCol <> 0) and (iCol > fMaxCol) then fMaxCol := iCol;
end;

function TexportDocXls.RecupPresentation: boolean;
begin
	result := true;
  //
 	ExcelInfoFontRange (fWorkBook,'présentation','PARAGNIV1',fparagNiv1);
  if fparagNiv1.Font.Name = 'Unknown' then BEGIN result:= false; Exit; END;
  //
 	ExcelInfoFontRange (fWorkBook,'présentation','PARAGNIV2',fparagNiv2);
  if fparagNiv2.Font.Name = 'Unknown' then BEGIN result:= false; Exit; END;
  //
 	ExcelInfoFontRange (fWorkBook,'présentation','PARAGNIV3',fparagNiv3);
  if fparagNiv3.Font.Name = 'Unknown' then BEGIN result:= false; Exit; END;
  //
 	ExcelInfoFontRange (fWorkBook,'présentation','PARAGNIV4',fparagNiv4);
  if fparagNiv4.Font.Name = 'Unknown' then BEGIN result:= false; Exit; END;
  //
 	ExcelInfoFontRange (fWorkBook,'présentation','PARAGNIV5',fparagNiv5);
  if fparagNiv5.Font.Name = 'Unknown' then BEGIN result:= false; Exit; END;
  //
 	ExcelInfoFontRange (fWorkBook,'présentation','PARAGNIV6',fparagNiv6);
  if fparagNiv6.Font.Name = 'Unknown' then BEGIN result:= false; Exit; END;
  //
 	ExcelInfoFontRange (fWorkBook,'présentation','PARAGNIV7',fparagNiv7);
  if fparagNiv7.Font.Name = 'Unknown' then BEGIN result:= false; Exit; END;
  //
 	ExcelInfoFontRange (fWorkBook,'présentation','PARAGNIV8',fparagNiv8);
  if fparagNiv8.Font.Name = 'Unknown' then BEGIN result:= false; Exit; END;
  //
 	ExcelInfoFontRange (fWorkBook,'présentation','PARAGNIV9',fparagNiv9);
  if fparagNiv9.Font.Name = 'Unknown' then BEGIN result:= false; Exit; END;
  //
 	ExcelInfoFontRange (fWorkBook,'présentation','OUVRAGE',fouvrage);
  if fouvrage.Font.Name = 'Unknown' then BEGIN result:= false; Exit; END;
  //
	ExcelInfoFontRange (fWorkBook,'présentation','SOUSDETAIL',fsousDetail);
  if fouvrage.Font.Name = 'Unknown' then BEGIN result:= false; Exit; END;
  //
	ExcelInfoFontRange (fWorkBook,'présentation','SOUSTOTAL',fsoustotal);
  if fouvrage.Font.Name = 'Unknown' then BEGIN result:= false; Exit; END;
  //
	ExcelInfoFontRange (fWorkBook,'présentation','VARIANTE',fVariante);
  if fVariante.Font.Name = 'Unknown' then BEGIN result:= false; Exit; END;
	//
  fDecalSousDetail := StrToInt(ExcelGetValue (fWorkBook,'présentation','DECALSOUSDETAIL'));
  if fDecalSousDetail = 0 then fDecalSousDetail := 3;
	//
  fDecalparag  := StrToInt(ExcelGetValue (fWorkBook,'présentation','DECALPARAG'));
  if fDecalparag = 0 then fDecalparag := 3;
end;


procedure TexportDocXls.SetInfoDocument(TOBDocument : TOB; NomLot : string);
var Indice : integer;
		NomChamps : string;
begin
  for Indice := 0 to TOBDocument.ChampsSup.Count -1 do
  begin
  	NomChamps := TOBDocument.GetNomChamp(1000+indice);
    if NomChamps = 'REFFOURNISSEUR' then
    begin
    	ExcelRangeText(fWorkBook,NomLot,NomChamps,TOBDocument.getstring(nomChamps));
    end else
    begin
    	ExcelRangeValue(fWorkBook,NomLot,NomChamps,TOBDocument.getvalue(nomChamps));
    end;
  end;
end;


procedure TexportDocXls.RemplitDocXls;
var indice,Ind,ligneDepart,LigneFin,decal : integer;
		TOBDocument,TOBL : TOB;
    NomFeuille,nomLot : string;
    LigneXls : integer;
    Formula,SeparPar,SeparSousDet : string;
    separglob : array [1..255] of char;
    intervPar1 : Tinterval;
    intervPar2 : Tinterval;
    intervPar3 : Tinterval;
    intervPar4 : Tinterval;
    intervPar5 : Tinterval;
    intervPar6 : Tinterval;
    intervPar7 : Tinterval;
    intervPar8 : Tinterval;
    intervPar9 : Tinterval;
begin
//	fWinExcel.visible := true;
  for Indice := 0 to fTOBexport.detail.count -1 do
  begin
    TOBDocument := fTOBexport.detail[Indice];
    NomFeuille := CopyFeuille(fWorkBook,'Dummy',mcbefore);
    NomLot := 'Lot-'+IntToStr(Indice+1);
    RenommeFeuille (fWorkBook,NomFeuille,NomLot);
    ExcelRangeValue(fWorkBook,NomLot,'DESCRIPTIF',fTOBexport.getvalue('DESCRIPTIF'));
    fWorkSheet := fWorkBook.activeSheet;
    SetInfoDocument(TOBDocument,NomLot);
    LigneXls := fRefLibelleLigne.Row+1; LigneDepart := LigneXls;
    FillChar(SeparGlob,255,ord(' '));
    SeparSousDet := copy(SeparGlob,1,fDecalSousDetail);
    for ind := 0 to TOBDocument.detail.count -1 do
    begin
    	TOBL := TOBDocument.detail[ind];
    	ExcelValue(fWorkSheet,LigneXls-1,frefLigneDoc.Column-1 ,TOBL.getvalue('REFLIGNE') );
			Hiderange (fWorkSheet,LigneXls,frefLigneDoc.Column ,LigneXls,frefLigneDoc.Column);
      //
      SeparPar := '';
      SeparSousDet := '';
      //
      if copy(TOBL.getvalue('TYPELIGNE'),1,2)='TP' then
      begin
    		ExcelValue(fWorkSheet,LigneXls-1,fRefArtLigne.Column-1,' ');
      	Decal := fDecalparag* Round(TOBL.getValue('NIVEAUIMBRIC')-1);
      	if decal > 0 then SeparPar := copy(SeparGlob,1,Decal);
        //
        ExcelValue(fWorkSheet,LigneXls-1,fRefLibelleLigne.Column-1,' ');
        if TOBL.getValue('NIVEAUIMBRIC') = 1 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv1);
          if fRefMontant.column <> 0 then
          begin
            Formula := 'SUM('+GetCelluleName(fRefMontant.Column,LigneXls-1)+':'+GetCelluleName(fRefMontant.Column,IntervPar1.ligDep)+')';
            ExcelSetFontRange (fWorkSheet,LigneXls,fRefMontant.Column ,LigneXls,fRefMontant.Column,fparagNiv1);
            ExcelSetFormule(fWorkSheet,Formula,LigneXls, fRefMontant.Column);
          end;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 2 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv2);
          if fRefMontant.column <> 0 then
          begin
            Formula := 'SUM('+GetCelluleName(fRefMontant.Column,LigneXls-1)+':'+GetCelluleName(fRefMontant.Column,IntervPar2.ligDep)+')';
            ExcelSetFontRange (fWorkSheet,LigneXls,fRefMontant.Column ,LigneXls,fRefMontant.Column,fparagNiv2);
            ExcelSetFormule(fWorkSheet,Formula,LigneXls, fRefMontant.Column);
          end;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 3 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv3);
          if fRefMontant.column <> 0 then
          begin
            Formula := 'SUM('+GetCelluleName(fRefMontant.Column,LigneXls-1)+':'+GetCelluleName(fRefMontant.Column,IntervPar3.ligDep)+')';
            ExcelSetFontRange (fWorkSheet,LigneXls,fRefMontant.Column ,LigneXls,fRefMontant.Column,fparagNiv3);
            ExcelSetFormule(fWorkSheet,Formula,LigneXls, fRefMontant.Column);
          end;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 4 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv4);
          if fRefMontant.column <> 0 then
          begin
            Formula := 'SUM('+GetCelluleName(fRefMontant.Column,LigneXls-1)+':'+GetCelluleName(fRefMontant.Column,IntervPar4.ligDep)+')';
            ExcelSetFontRange (fWorkSheet,LigneXls,fRefMontant.Column ,LigneXls,fRefMontant.Column,fparagNiv4);
            ExcelSetFormule(fWorkSheet,Formula,LigneXls, fRefMontant.Column);
          end;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 5 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv5);
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv4);
          if fRefMontant.column <> 0 then
          begin
            Formula := 'SUM('+GetCelluleName(fRefMontant.Column,LigneXls-1)+':'+GetCelluleName(fRefMontant.Column,IntervPar5.ligDep)+')';
            ExcelSetFontRange (fWorkSheet,LigneXls,fRefMontant.Column ,LigneXls,fRefMontant.Column,fparagNiv5);
            ExcelSetFormule(fWorkSheet,Formula,LigneXls, fRefMontant.Column);
          end;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 6 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv6);
          if fRefMontant.column <> 0 then
          begin
            Formula := 'SUM('+GetCelluleName(fRefMontant.Column,LigneXls-1)+':'+GetCelluleName(fRefMontant.Column,IntervPar6.ligDep)+')';
            ExcelSetFontRange (fWorkSheet,LigneXls,fRefMontant.Column ,LigneXls,fRefMontant.Column,fparagNiv6);
            ExcelSetFormule(fWorkSheet,Formula,LigneXls, fRefMontant.Column);
          end;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 7 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv7);
          if fRefMontant.column <> 0 then
          begin
            Formula := 'SUM('+GetCelluleName(fRefMontant.Column,LigneXls-1)+':'+GetCelluleName(fRefMontant.Column,IntervPar7.ligDep)+')';
            ExcelSetFontRange (fWorkSheet,LigneXls,fRefMontant.Column ,LigneXls,fRefMontant.Column,fparagNiv7);
            ExcelSetFormule(fWorkSheet,Formula,LigneXls, fRefMontant.Column);
          end;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 8 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv8);
          if fRefMontant.column <> 0 then
          begin
            Formula := 'SUM('+GetCelluleName(fRefMontant.Column,LigneXls-1)+':'+GetCelluleName(fRefMontant.Column,IntervPar8.ligDep)+')';
            ExcelSetFontRange (fWorkSheet,LigneXls,fRefMontant.Column ,LigneXls,fRefMontant.Column,fparagNiv8);
            ExcelSetFormule(fWorkSheet,Formula,LigneXls, fRefMontant.Column);
          end;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 9 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv9);
          if fRefMontant.column <> 0 then
          begin
            Formula := 'SUM('+GetCelluleName(fRefMontant.Column,LigneXls-1)+':'+GetCelluleName(fRefMontant.Column,IntervPar9.ligDep)+')';
            ExcelSetFontRange (fWorkSheet,LigneXls,fRefMontant.Column ,LigneXls,fRefMontant.Column,fparagNiv9);
            ExcelSetFormule(fWorkSheet,Formula,LigneXls, fRefMontant.Column);
          end;
        end;
        //
    		ExcelValue(fWorkSheet,LigneXls-1,fRefLibelleLigne.Column-1,SeparPar+TOBL.getvalue('LIBELLELIGNE'));
        //
      end else if copy(TOBL.getvalue('TYPELIGNE'),1,2)='DP' then
      begin
      	Decal := fDecalparag* Round(TOBL.getValue('NIVEAUIMBRIC')-1);
      	if decal > 0 then SeparPar := copy(SeparGlob,1,Decal);
        //
    		ExcelValue(fWorkSheet,LigneXls-1,fRefArtLigne.Column-1,' ');
        if TOBL.getValue('NIVEAUIMBRIC') = 1 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv1);
          IntervPar1.ligDep := LigneXls+1;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 2 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv2);
          IntervPar2.ligDep := LigneXls+1;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 3 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv3);
          IntervPar3.ligDep := LigneXls+1;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 4 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv4);
          IntervPar4.ligDep := LigneXls+1;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 5 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv5);
          IntervPar5.ligDep := LigneXls+1;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 6 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv6);
          IntervPar6.ligDep := LigneXls+1;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 7 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv7);
          IntervPar7.ligDep := LigneXls+1;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 8 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv8);
          IntervPar8.ligDep := LigneXls+1;
        end else if TOBL.getValue('NIVEAUIMBRIC') = 9 then
        begin
        	ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fparagNiv9);
          IntervPar9.ligDep := LigneXls+1;
        end;
    		ExcelValue(fWorkSheet,LigneXls-1,fRefLibelleLigne.Column-1,SeparPar+TOBL.getvalue('LIBELLELIGNE'));
      end else
      begin
      	Decal := fDecalparag* Round(TOBL.getValue('NIVEAUIMBRIC'));
      	if decal > 0 then SeparPar := copy(SeparGlob,1,decal);
        //
    		ExcelValue(fWorkSheet,LigneXls-1,fRefArtLigne.Column-1,' ');
        //
        if TOBL.getValue('TYPELIGNE')='SDO' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefArtLigne.Column ,LigneXls,fRefArtLigne.Column,fsousDetail);
        end else if TOBL.getValue('TYPELIGNE')='OUV' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefArtLigne.Column ,LigneXls,fRefArtLigne.Column,fouvrage);
        end else if TOBL.getValue('TYPELIGNE')='VAR' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefArtLigne.Column ,LigneXls,fRefArtLigne.Column,fvariante);
        end else if TOBL.getValue('TYPELIGNE')='TOT' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefArtLigne.Column ,LigneXls,fRefArtLigne.Column,fsoustotal);
        end;

    		ExcelValue(fWorkSheet,LigneXls-1,fRefArtLigne.Column-1,TOBL.getvalue('REFARTLIGNE'));
        //
        if TOBL.getValue('TYPELIGNE')='SDO' then
        begin
          Decal := fDecalSousDetail;
          if decal > 0 then SeparSousDet  := copy(SeparGlob,1,decal);
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fsousDetail);
        end else if TOBL.getValue('TYPELIGNE')='OUV' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fouvrage);
        end else if TOBL.getValue('TYPELIGNE')='VAR' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fvariante);
        end else if TOBL.getValue('TYPELIGNE')='TOT' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefLibelleLigne.Column ,LigneXls,fRefLibelleLigne.Column,fsoustotal);
        end;
    		ExcelValue(fWorkSheet,LigneXls-1,fRefLibelleLigne.Column-1,SeparPar+SeparSousDet+TOBL.getvalue('LIBELLELIGNE'));
        //
        if TOBL.getValue('TYPELIGNE')='SDO' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefQteLigne.Column ,LigneXls,fRefQteLigne.Column,fsousDetail);
        end else if TOBL.getValue('TYPELIGNE')='OUV' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefQteLigne.Column ,LigneXls,fRefQteLigne.Column,fouvrage);
        end else if TOBL.getValue('TYPELIGNE')='VAR' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefQteLigne.Column ,LigneXls,fRefQteLigne.Column,fvariante);
        end else if TOBL.getValue('TYPELIGNE')='TOT' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefQteLigne.Column ,LigneXls,fRefQteLigne.Column,fsoustotal);
        end;
        ExcelValue(fWorkSheet,LigneXls-1,fRefQteLigne.Column-1,TOBL.getvalue('QTELIGNE'));
        //
        if TOBL.getValue('TYPELIGNE')='SDO' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefUniteLigne.Column ,LigneXls,fRefUniteLigne.Column,fsousDetail);
        end else if TOBL.getValue('TYPELIGNE')='OUV' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefUniteLigne.Column ,LigneXls,fRefUniteLigne.Column,fouvrage);
        end else if TOBL.getValue('TYPELIGNE')='VAR' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefUniteLigne.Column ,LigneXls,fRefUniteLigne.Column,fvariante);
        end else if TOBL.getValue('TYPELIGNE')='TOT' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefUniteLigne.Column ,LigneXls,fRefUniteLigne.Column,fsoustotal);
        end;
        ExcelValue(fWorkSheet,LigneXls-1,fRefUniteLigne.Column-1,TOBL.getvalue('UNITELIGNE'));
        //
        if TOBL.getValue('TYPELIGNE')='SDO' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefPuLigne.Column ,LigneXls,fRefPuLigne.Column,fsousDetail);
        end else if TOBL.getValue('TYPELIGNE')='OUV' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefPuLigne.Column ,LigneXls,fRefPuLigne.Column,fouvrage);
        end else if TOBL.getValue('TYPELIGNE')='VAR' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefPuLigne.Column ,LigneXls,fRefPuLigne.Column,fvariante);
        end else if TOBL.getValue('TYPELIGNE')='TOT' then
        begin
      		ExcelSetFontRange (fWorkSheet,LigneXls,fRefPuLigne.Column ,LigneXls,fRefPuLigne.Column,fsoustotal);
        end;
        ExcelValue(fWorkSheet,LigneXls-1,fRefPuLigne.Column-1,TOBL.getvalue('PULIGNE'));
        if fRefMontant.column <> 0 then
        begin
          Formula := GetCelluleName(fRefQteLigne.Column,LigneXls)+'*'+GetCelluleName(fRefPuLigne.Column,LigneXls);
          if TOBL.getValue('TYPELIGNE')='SDO' then
          begin
            ExcelSetFontRange (fWorkSheet,LigneXls,fRefMontant.Column ,LigneXls,fRefMontant.Column,fsousDetail);
          end else if TOBL.getValue('TYPELIGNE')='OUV' then
          begin
            ExcelSetFontRange (fWorkSheet,LigneXls,fRefMontant.Column ,LigneXls,fRefMontant.Column,fouvrage);
          end else if TOBL.getValue('TYPELIGNE')='VAR' then
          begin
            ExcelSetFontRange (fWorkSheet,LigneXls,fRefMontant.Column ,LigneXls,fRefMontant.Column,fvariante);
        	end else if TOBL.getValue('TYPELIGNE')='TOT' then
        	begin
      			ExcelSetFontRange (fWorkSheet,LigneXls,fRefMontant.Column ,LigneXls,fRefMontant.Column,fsoustotal);
        	end;
          ExcelSetFormule(fWorkSheet,Formula,LigneXls, fRefMontant.Column);
        end;

      end;
      inc(ligneXls);
    end;
    LigneFin := LigneXls-1;
    //
    ExcelMerge (fWorkSheet,LigneDepart,fRefArtLigne.Column,ligneFin, frefArtLigne.NbCols );
    ExcelMerge (fWorkSheet,LigneDepart,fRefLibelleLigne.Column ,LigneFin,fRefLibelleLigne.NbCols );
    ExcelMerge (fWorkSheet,LigneDepart,fRefQteLigne.Column ,LigneFin,fRefQteLigne.NbCols );
    ExcelMerge (fWorkSheet,LigneDepart,fRefUniteLigne.Column ,LigneFin,fRefUniteLigne.NbCols );
    ExcelMerge (fWorkSheet,LigneDepart,fRefPuLigne.Column ,LigneFin,fRefPuLigne.NbCols );
    ExcelMerge (fWorkSheet,LigneDepart,frefmontant.Column ,LigneFin,frefmontant.NbCols );
    //
    Excelborders(fWorkSheet,LigneDepart,fRefArtLigne.Column ,LigneFin,fRefArtLigne.Column ,[XlBleft]);
    //
    Excelborders(fWorkSheet,LigneDepart,fRefLibelleLigne.Column ,LigneFin,fRefLibelleLigne.Column ,[XlBleft]);
    //
    Excelborders(fWorkSheet,LigneDepart,fRefQteLigne.Column ,LigneFin,fRefQteLigne.Column ,[XlBleft]);
    ExcelFormat(fWorkSheet,LigneDepart,fRefQteLigne.Column ,LigneFin,fRefQteLigne.Column ,'# ##0,00;; ;');
    ExcelAlignRange (fWorkSheet,fRefQteLigne.Column -1,ligneDepart-1,fRefQteLigne.Column-1 ,LigneFin-1,taRightJustify);
    //
    Excelborders(fWorkSheet,LigneDepart,fRefUniteLigne.Column ,LigneFin,fRefUniteLigne.Column ,[XlBleft]);
    //
    Excelborders(fWorkSheet,LigneDepart,fRefPuLigne.Column ,LigneFin,fRefPuLigne.Column ,[XlBleft]);
    ExcelFormat(fWorkSheet,LigneDepart,fRefPuLigne.Column ,LigneFin,fRefPuLigne.Column ,'# ##0,00;; ;');
    ExcelAlignRange (fWorkSheet,fRefPuLigne.Column -1,ligneDepart-1,fRefPuLigne.Column-1 ,LigneFin-1,taRightJustify);
    //
    if frefmontant.column <> 0 then
    begin
    	Excelborders(fWorkSheet,LigneDepart,frefmontant.Column ,LigneFin,frefmontant.Column ,[XlBleft]);
    	ExcelFormat(fWorkSheet,LigneDepart,frefmontant.Column ,LigneFin,frefmontant.Column ,'# ##0,00;; ;');
      ExcelAlignRange (fWorkSheet,frefmontant.Column -1,ligneDepart-1,frefmontant.Column-1 ,LigneFin-1,taRightJustify);
    end;
    Excelborders(fWorkSheet,LigneFin,fminCol ,LigneFin,fmaxCol ,[XlBBottom]);
    Excelborders(fWorkSheet,LigneDepart,fMinCol ,LigneFin,fMinCol ,[XlBleft]);
    Excelborders(fWorkSheet,LigneDepart,fMaxCol ,LigneFin,fMaxCol ,[XlBRight]);

  end;
end;

procedure TexportDocXls.SetFournisseur(const Value: string);
begin
  fFournisseur := Value;
end;

procedure TexportDocXls.SetNomFrs(const Value: string);
begin
  fNomFrs := FormatNomLib(Value);
end;

procedure TexportDocXls.SetModeAction(const Value: TmodeAction);
begin
  fModeAction := Value;
end;

procedure TexportDocXls.SetTypeExport(const Value: TTypeExport);
begin
  fTypeExport := Value;
  if fTypeExport = TteCotrait then fDocExcel := GetparamSocSecur('SO_EXPMODELECOTRAIT','C:\PGI00\STD\MODELECOTRAIT.xlsx')
  else if fTypeExport = TteDevis then fDocExcel := GetparamSocSecur('SO_EXPMODELEDEVIS','C:\PGI00\STD\MODELEDEVIS.xlsx')
  else if fTypeExport = TteSousTrait then fDocExcel := GetparamSocSecur('SO_EXPMODELESOUSTRAIT','C:\PGI00\STD\MODELESOUSTRAIT.xlsx');
//  fdocExcel :=  'C:\PGI00\STD\CHIFFRAGELOT.xlsx';
//  fdocExcel :=  'C:\PGI00\STD\MODELEDEVIS.xlsx';
end;

procedure TexportDocXls.SetModeExport(const Value: TModeExport);
begin
  fModeExport := Value;
end;

end.
