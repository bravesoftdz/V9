unit FactCommBTP;

interface
uses EntGc,Utob,SysUtils,uEntCommun;

function IsPieceGerableReliquat(TOBL : TOB) : boolean;
function EncoderefSel(NaturePieceg, Souche: string; Numero, Indice: integer): string; overload;
function EncoderefSel(TOBP : TOB): string; overload;
function EncoderefSel(cledoc : r_cledoc): string; overload;

implementation

function IsPieceGerableReliquat(TOBL : TOB) : boolean;
BEGIN
	result := (GetInfoParPiece(TOBL.GetValue('GL_NATUREPIECEG'), 'GPP_RELIQUAT')='X');
END;

function EncoderefSel(cledoc : r_cledoc): string; overload;
begin
   result := EncodeRefSel (cledoc.NaturePiece ,Cledoc.Souche,cledoc.NumeroPiece,cledoc.Indice );
end;

function EncoderefSel(TOBP: TOB): string;
var Naturepieceg,Souche : string;
    Numero,IndiceG : integer;
begin
  if TOBP.NomTable = 'PIECE' then
  begin
    Naturepieceg := TOBP.GetValue('GP_NATUREPIECEG');
    Souche := TOBP.GetValue('GP_SOUCHE');
    Numero := TOBP.GetValue('GP_NUMERO');
    IndiceG := TOBP.GetValue('GP_INDICEG');
  end else if TOBP.NomTable = 'LIGNE' then
  begin
    Naturepieceg := TOBP.GetValue('GL_NATUREPIECEG');
    Souche := TOBP.GetValue('GL_SOUCHE');
    Numero := TOBP.GetValue('GL_NUMERO');
    IndiceG := TOBP.GetValue('Gl_INDICEG');
  end;
  result := EncodeRefSel (Naturepieceg,Souche,Numero,IndiceG);
end;

function EncoderefSel (NaturePieceg,Souche : string; Numero,Indice : integer) : string;
begin
  Result := NaturePieceg + ';' + Souche + ';'
    + IntToStr(Numero) + ';' + IntToStr(Indice) + ';'
end;

end.
