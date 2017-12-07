unit UtilEpurePiece;

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
     uEntCommun,
     UtilTOBPiece,
     UTOB;

procedure	EpureLaPiece (fTOBPiece : TOB);

implementation
uses UtilBTPgestChantier;

procedure	EpureLaPiece (fTOBPiece : TOB);
var cledoc : r_cledoc;
begin
  FillChar(CleDoc, Sizeof(CleDoc), #0);
  CleDoc.NaturePiece := fTOBPiece.getValue('GP_NATUREPIECEG');
  CleDoc.DatePiece := fTOBPiece.getValue('GP_DATEPIECE');
  CleDoc.Souche := fTOBPiece.getValue('GP_SOUCHE');
  CleDoc.NumeroPiece := fTOBPiece.getValue('GP_NUMERO');
  CleDoc.Indice := fTOBPiece.getValue('GP_INDICEG');

  if (fTOBPiece.GetValue('GP_AFFAIREDEVIS') <> '') and (copy(fTOBPiece.GetValue('GP_AFFAIREDEVIS'), 1, 1) = 'Z') and
      ((fTOBPiece.GetValue('GP_NATUREPIECEG')='DBT') or (fTOBPiece.GetValue('GP_NATUREPIECEG')='BCE')) then
  begin
    // suppression de la sous-affaire associée
    if ExecuteSQL('DELETE FROM AFFAIRE WHERE AFF_AFFAIRE="' + fTOBPiece.GetValue('GP_AFFAIREDEVIS') + '"') < 0 then
    begin
      V_PGI.IoError := oeUnknown;
      Exit;
    end;
  end;
  ExecuteSQL('DELETE FROM BTPARDOC WHERE '+WherePiece(CleDoc, ttdParDoc, False));
	if ExecuteSQL('DELETE FROM PIECE WHERE ' + WherePiece(CleDoc, ttdPiece, False)) < 0 then
  begin
    V_PGI.IoError := oeSaisie;
    Exit;
  end;
  if ExecuteSQL('DELETE FROM LIGNE WHERE ' + WherePiece(CleDoc, ttdLigne, False)) < 0 then
  begin
    V_PGI.IoError := oeUnknown;
    Exit;
  end;
  ExecuteSQL('DELETE FROM LIGNECOMPL WHERE ' + WherePiece(CleDoc, ttdLigneCompl, False));
  ExecuteSQL('DELETE FROM PIEDBASE WHERE ' + WherePiece(CleDoc, ttdPiedBase, False));
  ExecuteSQL('DELETE FROM LIGNEBASE WHERE ' + WherePiece(CleDoc, ttdLigneBase, False));
  ExecuteSQL('DELETE FROM PIEDECHE WHERE ' + WherePiece(CleDoc, ttdEche, False));
  ExecuteSQL('DELETE FROM ACOMPTES WHERE GAC_NATUREPIECEG="' + fTOBPiece.GetValue('GP_NATUREPIECEG')+ '" '+
  					 'AND GAC_SOUCHE="' + fTOBPiece.GetValue('GP_SOUCHE')+'" '+
    				 'AND GAC_NUMERO=' + IntToStr(fTOBPiece.GetValue('GP_NUMERO'))+
    				 'AND GAC_INDICEG=' + IntToStr(fTOBPiece.GetValue('GP_INDICEG')));
  ExecuteSQL('DELETE FROM PIEDPORT WHERE GPT_NATUREPIECEG="' + fTOBPiece.GetValue('GP_NATUREPIECEG')+ '" '+
  					 'AND GPT_SOUCHE="' + fTOBPiece.GetValue('GP_SOUCHE')+'" '+
    				 'AND GPT_NUMERO=' + IntToStr(fTOBPiece.GetValue('GP_NUMERO'))+
    				 'AND GPT_INDICEG=' + IntToStr(fTOBPiece.GetValue('GP_INDICEG')));
	if ExecuteSQL('DELETE FROM LIGNEOUV WHERE ' + WherePiece(CleDoc, ttdOuvrage, False)) < 0 then
  begin
    V_PGI.IoError := oeUnknown;
    Exit;
  end;
  ExecuteSQL('DELETE FROM LIGNEOUVPLAT WHERE ' + WherePiece(CleDoc, ttdOuvrageP , False));
  ExecuteSQL('DELETE FROM LIGNEFAC WHERE ' + WherePiece(CleDoc, ttdLigneFac , False));
  ExecuteSQL('DELETE FROM LIGNEPHASES WHERE ' + WherePiece(CleDoc, TtdLignePhase , False));
  ExecuteSQL('DELETE FROM PIECERG WHERE ' + WherePiece(CleDoc, ttdRetenuG, False));
	ExecuteSQL('DELETE FROM PIEDBASERG WHERE ' + WherePiece(CleDoc, ttdBaseRG, False));
  ExecuteSQL('DELETE FROM BTPIECEMILIEME WHERE ' + WherePiece(CleDoc, TTdRepartmill , False));
  ExecuteSql('DELETE FROM LIENSOLE WHERE ' + WherePiece(CleDoc, ttdLienOle, False));
  ExecuteSQL('DELETE FROM PIECEADRESSE WHERE ' + WherePiece(CleDoc, ttdPieceAdr, False));
  ExecuteSQL('DELETE FROM VENTANA WHERE YVA_TABLEANA="GL" AND YVA_IDENTIFIANT LIKE "' + EncodeRefPresqueCPGescom(fTOBPiece) + '"');
  ExecuteSQL('DELETE FROM VENTANA WHERE YVA_TABLEANA="GS" AND YVA_IDENTIFIANT LIKE "' + EncodeRefPresqueCPGescom(fTOBPiece) + '"');
  ExecuteSql('DELETE FROM BVARDOC WHERE ' + WherePiece(CleDoc, ttdVardoc , False));
  ExecuteSql('DELETE FROM LIENDEVCHA WHERE BDA_REFD="'+EncodeLienDevCHA(fTOBPiece)+'"');
end;

end.
