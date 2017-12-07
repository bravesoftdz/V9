unit EpurationChantiers;

interface
Uses Classes,
     Windows,
     sysutils,
     ComCtrls,
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
     Fe_Main,
{$ELSE}
     MainEagl,
{$ENDIF}
     HCtrls,
     Hpanel,
     HEnt1,
     HMsgBox,
     Vierge,
     EntGc,
     BTPUtil,
     ExtCtrls,
     SaisUtil,
     UtilPgi,
     UtilEpurePiece,
     UTOB;

type
	TEpurationChantier = class (TObject)
  	private
    	fTOBChantier : TOB;
      fchantier : string;
      fresult : integer;
      function ControleChantierSupp : boolean;
      procedure TraiteChantier;
    	procedure SetChantier(const Value: TOB);
    public
      property Chantier : TOB read fTOBChantier write SetChantier;
      property result : integer read fresult;
      procedure lancetraitement;
  end;

function TraitementEpurationChantier (TOBChantier : TOB) : integer;

implementation

function TraitementEpurationChantier (TOBChantier: TOB) : integer;
var EpurationChantier : TEpurationChantier;
begin
   EpurationChantier := TEpurationChantier.create;
   EpurationChantier.Chantier := TOBChantier;
   TRY
     EpurationChantier.lanceTraitement;
   FINALLY
     result := EpurationChantier.Result;
   	 EpurationChantier.free;
   END;
end;

{ TEpurationChantier }

function TEpurationChantier.ControleChantierSupp: boolean;
begin
  // Verification que les clotures de facturation ont bien été effectuées
  result := not (ExisteSql ('SELECT AFF_ETATAFFAIRE FROM PIECE LEFT JOIN AFFAIRE ON AFF_AFFAIRE=GP_AFFAIREDEVIS '+
                 'WHERE GP_NATUREPIECEG="DBT" AND GP_AFFAIRE="'+fchantier+'" AND '+
                 'AFF_ETATAFFAIRE <> "TER"'));
end;


procedure TEpurationChantier.lancetraitement;
var io   : TIoErr ;
begin
	if ControleChantierSupp then
  begin
    Io := Transactions (TraiteChantier, 0);
    Case Io of
      oeUnKnown :BEGIN
                  fResult := -1;
                 END;
    end;
  end else
  begin
  	fresult := 1;
  end;

end;

procedure TEpurationChantier.SetChantier(const Value: TOB);
begin
  fTOBChantier := Value;
  fChantier := fTOBChantier.getValue('AFF_AFFAIRE');
end;

procedure TEpurationChantier.TraiteChantier;
var TOBPiece,TOBP : TOB;
		Indice : integer;
begin
	TOBPiece := TOB.Create ('LES PIECES',nil,-1);
  TOBPiece.LoadDetailDBFromSQL('PIECE','SELECT GP_NATUREPIECEG,GP_SOUCHE,GP_NUMERO,GP_INDICEG,GP_AFFAIRE,GP_AFFAIREDEVIS FROM PIECE WHERE GP_AFFAIRE="'+fCHantier+'"',false,true);
  For Indice := 0 to TOBPiece.detail.count-1 do
  begin
    TOBP := TOBPiece.detail[indice];
    EpureLaPiece (TOBP);
    if V_PGI.Ioerror <> OeOk then break;
  end;
  if V_PGI.ioError = OeOk then
  begin
  	ExecuteSql ('DELETE FROM BDETETUDE WHERE BDE_AFFAIRE="'+fchantier+'"');
  	ExecuteSql ('DELETE FROM BSITUATIONS WHERE BST_AFFAIRE="'+fchantier+'"');
  	ExecuteSql ('DELETE FROM BSTRDOC WHERE BSD_AFFAIRE="'+fchantier+'"');
  	ExecuteSql ('DELETE FROM BTMEMOFACTURE WHERE BMF_AFFAIRE="'+fchantier+'"');
  	ExecuteSql ('DELETE FROM CONSOMMATIONS WHERE BCO_AFFAIRE="'+fchantier+'"');
  	ExecuteSql ('DELETE FROM PHASESCHANTIER WHERE BPC_AFFAIRE="'+fchantier+'"');
  	ExecuteSql ('DELETE FROM AFFAIRE WHERE AFF_AFFAIRE="'+fchantier+'"');
  end;
end;

end.
