unit UtilTOBPiece;

interface

uses hctrls,
  sysutils,HEnt1,
{$IFNDEF EAGLCLIENT}
  uDbxDataSet, DB,
{$ELSE}
  uWaini,
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} DB,
{$ENDIF}
  uhttp,paramsoc,
  utob,uEntCommun;

function CleDocToString(CleDoc: R_CleDoc): string;
procedure DecodeRefPiece(St: string; var CleDoc: R_CleDoc); { NEWPIECE }
function IsOuvrageOkInPiece (naturepiece : string) : Boolean;
function  IsTransfert(NaturePiece : String): Boolean;
procedure LoadLignes(CleDocLigne: R_CleDoc; TobPiece: Tob; WithLigneCompl: Boolean = True; QueLaligne : boolean=false; WithLigneFac:boolean=false);
procedure LoadPieceLignes(CleDocLigne: R_CleDoc; TobPiece: Tob; WithLigneCompl: Boolean = True;QueLaLigne : boolean=false);
function MakeSelectLigneBtp (WithLigneCOmpl : boolean;WithEntetePiece : boolean = false;WithLigneFac : boolean=false) : string;
function MakeSelectLigneOuvBtp (WithLigneFac : boolean=false) : string;
procedure StringToCleDoc(StA: string; var CleDoc: R_CleDoc);
function  WherePiece(CleDoc: R_CleDoc; ttd: T_TableDoc; Totale: boolean; WithNumOrdre: Boolean = False): string; { NEWPIECE }

implementation

procedure LoadPieceLignes(CleDocLigne: R_CleDoc; TobPiece: Tob; WithLigneCompl: Boolean = True;QueLaLigne : boolean=false);
var
  Q: TQuery;
  Req : string;
  WithLigneFac : boolean;
begin
  { Chargement entête de la pièce }
  Req := 'SELECT PIECE.*';
  req := req + ',AFF_GENERAUTO,AFF_OKSIZERO,AFF_ETATAFFAIRE AS ETATDOC FROM PIECE '+
               'LEFT JOIN AFFAIRE ON AFF_AFFAIRE=GP_AFFAIREDEVIS ';
  Req := Req + 'WHERE ' + WherePiece(CleDocLigne, ttdPiece, False);
  Q := OpenSQL(Req, True,-1, '', True);

  TobPiece.SelectDB('', Q);
  Ferme(Q);
  WithLigneFac := (Pos(TOBpiece.GetValue('GP_NATUREPIECEG'),'FBT;DAC')>0);
  LoadLignes(CleDocLigne, TobPiece, WithLigneCompl,QueLaLigne,WithLigneFac);
end;


procedure LoadLignes(CleDocLigne: R_CleDoc; TobPiece: Tob; WithLigneCompl: Boolean = True; QueLaligne : boolean=false; WithLigneFac:boolean=false);
var
  Q: TQuery;
  Sql: String;
begin
  Sql := 'SELECT * FROM LIGNE';
{$IFNDEF EAGLSERVER}
{$IFDEF GPAOLIGHT}
  if WithLigneCompl then
    Sql := MakeSelectLigne;
{$ENDIF GPAOLIGHT}
{$IFDEF BTP}
    Sql := MakeSelectLigneBtp (WithLigneCompl,false,WithLigneFac);
{$ENDIF}
{$ELSE}
    Sql := MakeSelectLigneBtp (WithLigneCompl,false,WithLigneFac);
{$ENDIF}
  Sql := Sql + ' WHERE ' + WherePiece(CleDocLigne, ttdLigne,QueLaLigne,WithLigneCompl) + ' ORDER BY GL_NUMLIGNE';
  Q := OpenSQL(Sql, True,-1, '', True);
  if not Q.eof then TobPiece.LoadDetailDB('LIGNE', '', '', Q, False, True);
  Ferme(Q);
end;

function MakeSelectLigneOuvBtp (WithLigneFac : boolean=false): string;
begin
  result :='SELECT O.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE,';
  if WithLigneFac then
  begin
    result := result +'LIGNEFAC.*,';
  end;
  result := result + '(SELECT T_LIBELLE FROM TIERS WHERE T_NATUREAUXI="FOU" AND T_TIERS=BLO_FOURNISSEUR) AS LIBELLEFOU FROM LIGNEOUV O '+
            'LEFT JOIN NATUREPREST N ON BNP_NATUREPRES=(SELECT GA_NATUREPRES FROM ARTICLE WHERE GA_ARTICLE=O.BLO_ARTICLE) ';
  if WithLigneFac then
  begin
  	result := result + 'LEFT JOIN LIGNEFAC ON BLF_NATUREPIECEG=BLO_NATUREPIECEG AND BLF_SOUCHE=BLO_SOUCHE AND BLF_NUMERO=BLO_NUMERO '+
    									 'AND BLF_INDICEG=BLO_INDICEG AND BLF_UNIQUEBLO=BLO_UNIQUEBLO ';
  end;
end;

function MakeSelectLigneBtp (WithLigneCOmpl : boolean;WithEntetePiece : boolean = false;WithLigneFac : boolean=false) : string;
begin
  Result := 'SELECT LIGNE.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE,';
  if WithLigneCompl then Result := Result + 'LIGNECOMPL.*,';
  if WithLigneFac then result := result + 'LIGNEFAC.*,';
  if WithEntetePiece then result := Result + 'GP_REFINTERNE,GP_NUMADRESSEFACT,GP_NUMADRESSELIVR,';
  result:= result +	 'P.BLP_PHASETRA,P.BLP_NUMMOUV,BCO_LIENTRANSFORME,BCO_INDICE,'
          				+  'BCO_TRANSFORME,BCO_QTEVENTE,BCO_QUANTITE,BCO_LIENVENTE,BCO_TRAITEVENTE,'
          				+  'BCO_QTEINIT,BCO_LIENRETOUR,(SELECT T_LIBELLE FROM TIERS WHERE T_NATUREAUXI="FOU" AND T_TIERS=GL_FOURNISSEUR) AS LIBELLEFOU '
                  +  'FROM LIGNE '
                  +  'LEFT JOIN LIGNEPHASES P '
                  +  'ON (P.BLP_NATUREPIECEG = GL_NATUREPIECEG and P.BLP_SOUCHE=GL_SOUCHE AND P.BLP_NUMERO = GL_NUMERO '
                  +  'and P.BLP_INDICEG = GL_INDICEG and P.BLP_NUMORDRE = GL_NUMORDRE) ';
  result := result + 'LEFT JOIN NATUREPREST N ON BNP_NATUREPRES=(SELECT GA_NATUREPRES FROM ARTICLE WHERE GA_ARTICLE=LIGNE.GL_ARTICLE) ';
  if WithLigneCompl Then
  begin
  	result := result + 'LEFT JOIN LIGNECOMPL '
          					 + 'ON (GL_NATUREPIECEG = GLC_NATUREPIECEG and GL_SOUCHE = GLC_SOUCHE AND GL_NUMERO = GLC_NUMERO '
                     + 'AND GL_INDICEG = GLC_INDICEG and GL_NUMORDRE = GLC_NUMORDRE)'

  end;
  if WithLigneFac then
  begin
    result := result + 'LEFT JOIN LIGNEFAC '
                     + 'ON (GL_NATUREPIECEG = BLF_NATUREPIECEG and GL_SOUCHE = BLF_SOUCHE AND GL_NUMERO = BLF_NUMERO '
                     + 'AND GL_INDICEG = BLF_INDICEG and GL_NUMORDRE = BLF_NUMORDRE AND BLF_UNIQUEBLO=0)';
  end;
  if WithEntetePiece then
  begin
  	result := Result + ' LEFT JOIN PIECE ON (GP_NATUREPIECEG=GL_NATUREPIECEG AND GP_NUMERO=GL_NUMERO'
    								 + ' AND GP_SOUCHE=GL_SOUCHE AND GP_INDICEG=GL_INDICEG)';
  end;
  result := result + ' LEFT OUTER JOIN CONSOMMATIONS '
                   + 'ON (BCO_NUMMOUV = BLP_NUMMOUV AND BCO_INDICE=0) ';
end;

function CleDocToString(CleDoc: R_CleDoc): string;
begin
  result := FormatDateTime('ddmmyyyy', CleDoc.DatePiece) + ';';
  result := result + Cledoc.NaturePiece + ';';
  result := result + Cledoc.Souche + ';';
  result := result + inttostr(Cledoc.NumeroPiece) + ';';
  result := result + inttostr(Cledoc.Indice) + ';';
  if cledoc.NumLigne > 0 then result := result + inttostr(Cledoc.NumLigne) + ';'
  else Result := result + ';';
end;
Function Evaluedate ( St : String ) : TDateTime ;
Var dd,mm,yy : Word ;
BEGIN
  Result:=0 ; if St='' then Exit ;
  dd:=StrToInt(Copy(St,1,2)) ; mm:=StrToInt(Copy(St,3,2)) ; yy:=StrToInt(Copy(St,5,4)) ;
  Result:=Encodedate(yy,mm,dd) ;
END ;

procedure DecodeRefPiece(St: string; var CleDoc: R_CleDoc); { NEWPIECE }
var
  StC, StL: string;
begin
  FillChar(CleDoc, Sizeof(CleDoc), #0);
  StC := St;
  CleDoc.DatePiece := EvalueDate(ReadTokenSt(StC));
  CleDoc.NaturePiece := ReadTokenSt(StC);
  CleDoc.Souche := ReadTokenSt(StC);
  CleDoc.NumeroPiece := StrToInt(ReadTokenSt(StC));
  CleDoc.Indice := StrToInt(ReadTokenSt(StC));
  StL := ReadTokenSt(StC);
  if StL <> '' then
  begin
    CleDoc.NumLigne := StrToInt(StL);
    CleDoc.NumOrdre := StrToInt(StL); { NEWPIECE }
  end;
end;

procedure StringToCleDoc(StA: string; var CleDoc: R_CleDoc);
var StC: string;
    Dattempo : String;
    IposBlanc : integer;
begin
  StC := uppercase(Trim(ReadTokenSt(StA)));
  if StC = '' then Exit;
  CleDoc.NaturePiece := StC;
  StC := uppercase(Trim(ReadTokenSt(StA)));
  if StC = '' then CleDoc.DatePiece := 0 else
     Begin
     IpoSBlanc := pos(' ', stc);
     if IPosBlanc = 0 then IposBlanc := Length (stc);
     DatTempo := copy(stc, 1,IposBlanc);
     CleDoc.DatePiece := StrToDate(DatTempo);
     end;
  StC := uppercase(Trim(ReadTokenSt(StA)));
  if StC = '' then Exit else CleDoc.Souche := StC;
  StC := uppercase(Trim(ReadTokenSt(StA)));
  if StC = '' then Exit else CleDoc.NumeroPiece := StrtoInt(StC);
  StC := uppercase(Trim(ReadTokenSt(StA)));
  if Stc = '' then Exit else CleDoc.Indice := StrToInt(StC);
end;


function WherePiece(CleDoc: R_CleDoc; ttd: T_TableDoc; Totale: boolean; WithNumOrdre: Boolean = False): string; { NEWPIECE }
var St: string;
  Numpiece: string;
begin
  St := '';
  case ttd of
	  ttdLigneMetre :
      begin
        St := ' BLM_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND BLM_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND BLM_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
          + ' AND BLM_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
    ttdPiece: St := ' GP_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND GP_SOUCHE="' + CleDoc.Souche + '" '
      + ' AND GP_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
        + ' AND GP_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
    ttdPieceTrait: St := ' BPE_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND BPE_SOUCHE="' + CleDoc.Souche + '" '
      + ' AND BPE_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
        + ' AND BPE_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
    ttdLigne:
      begin
        St := ' GL_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND GL_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND GL_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
          + ' AND GL_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
        if Totale then
        begin
          if not WithNumOrdre then
            St := St + ' AND GL_NUMLIGNE=' + IntToStr(CleDoc.NumLigne) + ' '
          else
            St := St + ' AND GL_NUMORDRE=' + IntToStr(CleDoc.NumOrdre) + ' ';
        end;
      end;
      
    ttdTimbres:
      begin
        St := ' BT0_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND BT0_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND BT0_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
          + ' AND BT0_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;

    ttdLigneTarif:
      begin
        St := ' GLT_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND GLT_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND GLT_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
          + ' AND GLT_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
        if Totale then St := St + ' AND GLT_NUMLIGNE=' + IntToStr(CleDoc.NumLigne) + ' ';
      end;

    ttdPieceAdr:
      begin
        St := ' GPA_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND GPA_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND GPA_NUMERO=' + IntToStr(CleDoc.NumeroPiece) + ' AND GPA_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
        if Totale then St := St + ' AND GPA_NUMLIGNE=' + IntToStr(CleDoc.NumLigne) + ' ';
      end;
    ttdPiedBase:
      begin
        St := ' GPB_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND GPB_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND GPB_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
          + ' AND GPB_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
    ttdLigneBase:
      begin
        St := ' BLB_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND BLB_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND BLB_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
          + ' AND BLB_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
    ttdLignefac:
      begin
        St := ' BLF_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND BLF_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND BLF_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
          + ' AND BLF_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
        if Totale then
        begin
          St := St + ' AND BLF_NUMORDRE=' + IntToStr(CleDoc.Numordre) + ' AND BLF_UNIQUEBLO=0 ';
        end;
      end;
    ttdEche:
      begin
        St := ' GPE_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND GPE_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND GPE_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
          + ' AND GPE_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
    ttdNomen:
      begin
        St := ' GLN_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND GLN_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND GLN_NUMERO=' + IntToStr(CleDoc.NumeroPiece) + ' AND GLN_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
    ttdLot:
      begin
        St := ' GLL_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND GLL_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND GLL_NUMERO=' + IntToStr(CleDoc.NumeroPiece) + ' AND GLL_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
    ttdAcompte:
      begin
        St := ' GAC_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND GAC_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND GAC_NUMERO=' + IntToStr(CleDoc.NumeroPiece) + ' AND GAC_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
    ttdPorc:
      begin
        St := ' GPT_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND GPT_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND GPT_NUMERO=' + IntToStr(CleDoc.NumeroPiece) + ' AND GPT_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
    ttdSerie:
      begin
        St := ' GLS_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND GLS_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND GLS_NUMERO=' + IntToStr(CleDoc.NumeroPiece) + ' AND GLS_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
    ttdOuvrage:
      begin
        St := ' BLO_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND BLO_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND BLO_NUMERO=' + IntToStr(CleDoc.NumeroPiece) + ' AND BLO_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
    ttdOuvrageP:
      begin
        St := ' BOP_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND BOP_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND BOP_NUMERO=' + IntToStr(CleDoc.NumeroPiece) + ' AND BOP_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
    ttdLienOle:
      begin
        Numpiece := cledoc.NaturePiece + ':' + cledoc.Souche + ':' + IntToStr(cledoc.NumeroPiece) + ':' + IntToStr(cledoc.indice);
        St := 'LO_TABLEBLOB="GP" AND LO_IDENTIFIANT="' + NumPiece + '"';
      end;
    ttdretenuG:
      begin
        St := ' PRG_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND PRG_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND PRG_NUMERO=' + IntToStr(CleDoc.NumeroPiece) + ' AND PRG_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
    ttdBaseRG:
      begin
        St := ' PBR_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND PBR_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND PBR_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
          + ' AND PBR_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
    ttdSit:
      begin
        St := ' BST_NATUREPIECE="' + CleDoc.NaturePiece + '" AND BST_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND BST_NUMEROFAC=' + IntToStr(CleDoc.NumeroPiece) + ' ';
      end;
    ttdParDoc:
      begin
        St := ' BPD_NATUREPIECE="' + CleDoc.NaturePiece + '" AND BPD_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND BPD_NUMPIECE=' + IntToStr(CleDoc.NumeroPiece) + ' ';
      end;
    ttdAdresse:
      begin
        St := ' ADR_REFCODE="' + CleDoc.NaturePiece + ';' + CleDoc.Souche + ';' + IntToStr(CleDoc.NumeroPiece) + ';"';
      end;
    ttdRevision:
      begin //Affaire-ONYX
        St := ' AFR_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND AFR_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND AFR_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
          + ' AND AFR_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
    ttdVariable:
      begin //Affaire-ONYX
        St := ' AVV_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND AVV_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND AVV_NUMERO=' + IntToStr(CleDoc.NumeroPiece) + ' ';
      end;
    ttdLigneCompl: 
      begin
        St := ' GLC_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND GLC_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND GLC_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
          + ' AND GLC_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
        if Totale then
          St := St + ' AND GLC_NUMORDRE=' + IntToStr(CleDoc.NumOrdre) + ' ';
      end;
    ttdLignePhase:
      begin
        St := ' BLP_NATUREPIECEG="' + CleDoc.NaturePiece + '" '
          + ' AND BLP_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND BLP_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
          + ' AND BLP_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
        if Totale then
          St := St + ' AND BLP_NUMORDRE=' + IntToStr(CleDoc.NumOrdre) + ' ';
      end;
		TTdRepartmill :
      begin
        St := ' BPM_NATUREPIECEG="' + CleDoc.NaturePiece + '" AND BPM_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND BPM_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
          + ' AND BPM_INDICEG=' + IntToStr(CleDoc.Indice) + ' ';
      end;
		TTdVarDoc :
      begin
        St := ' BVD_NATUREPIECE="' + CleDoc.NaturePiece + '" AND BVD_SOUCHE="' + CleDoc.Souche + '" '
          + ' AND BVD_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
          + ' AND BVD_INDICE=' + IntToStr(CleDoc.Indice) + ' ';
      end;
  end;
  Result := St;
end;



function IsOuvrageOkInPiece (naturepiece : string) : Boolean;
begin
	result := false;
  if (Naturepiece = 'DBT') or (Naturepiece = 'FBT') or
     (Naturepiece = 'AFF') or (Naturepiece = 'FAC') or
     (Naturepiece = 'ETU') or (Naturepiece = 'DAC') or
     (Naturepiece = 'BCE') or (Naturepiece = 'AVC') or
     (Naturepiece = GetParamSoc('SO_BTNATBORDEREAUX')) or
     (Naturepiece = 'ABT') or (Naturepiece = 'FRC') or
     (Naturepiece = 'DAP') or (Naturepiece = 'FPR') then Result := true;
end;

function IsTransfert(NaturePiece : String): Boolean;
begin
  if (NaturePiece = 'TEM') or (NaturePiece = 'TRV') or (NaturePiece = 'TRE') then
    Result := True
  else Result := False;
end;

end.
