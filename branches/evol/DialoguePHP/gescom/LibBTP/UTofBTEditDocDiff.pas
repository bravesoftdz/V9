{***********UNITE*************************************************
Auteur  ...... : Dominique BROSSET
Créé le ...... : 08/02/2001
Modifié le ... : 10/07/2001
Description .. : Edition différée des documents
Mots clefs ... : EDITION;DIFFEREE;DOCUMENT
*****************************************************************}
unit UTofBTEditDocDiff;

interface
uses  StdCtrls,Controls,Classes,forms,sysutils,ComCtrls,
      HCtrls,HEnt1,HMsgBox,UTOF, HDimension,UTOM,AGLInit,
      Utob,HDB,Messages,HStatus,uTofAfBaseCodeAffaire,
{$IFDEF EAGLCLIENT}
      UtileAGL,eMul,MaineAGL,
{$ELSE}
      {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}Fiche, mul, db,DBGrids,   Fe_Main,EdtEtat, EdtDoc,
      uPDFBatch,
{$IFNDEF V530}
      EdtREtat, EdtRDoc,
{$ENDIF}      
{$ENDIF}
{$IFDEF BTP}
      BTPUtil, Paramsoc,UtilReglementAffaire,
{$ENDIF}
{$IFDEF NOMADE}
      UtilPOP,
{$ENDIF}
			hPDFPrev,hPDFViewer,
      {$IFNDEF V530} uRecupSQLModele, {$ENDIF}
      M3VM, M3FP, Hqry, EntGC, FactComm, FactUtil,
      FactTob,Ent1,uEntCommun,UtilTOBPiece ;

Type
     TOF_BTEditDocDiff_Mul = Class (TOF_AFBASECODEAFFAIRE)
        procedure OnArgument (stArgument : string); override;
        procedure LanceEdition ;
        procedure EditeLesDocs (TobPiece : TOB);
        procedure NomsChampsAffaire( Var Aff,Aff0,Aff1,Aff2,Aff3,Aff4,Aff_,Aff0_,Aff1_,Aff2_,Aff3_,Aff4_,Tiers,Tiers_ : THEdit ) ; override ;
        Function  NomCorrect ( NomPDF : String ) : Boolean ;
  private

    IsAvanc : boolean;
    VenteAchat : String;
    Statut		 : String;

    procedure ControleChamp(Champ, Valeur: String);
    procedure ModificationModeleBTP(var OkEtat, BApercu: boolean;
      															var Modele: string; var NbCopies: integer; EditDirect : boolean);
    procedure SetInfoPieces(TobP: TOB; ETATSTANDARD: string;
      OKETAT: boolean; NbExemplaire: integer);
    procedure RenseignePiece(TobP: TOB; var BApercu: boolean;
      var Choix : string; var Modele: string; EditDirect: boolean; var Nbcopies: integer);
    function GetInfoRecapFromModele(TobPiece: TOB): boolean;
    end ;

procedure AGLEditDocDiff_mul(parms:array of variant; nb: integer ) ;

const
// libellés des messages
TexteMessage: array[1..3] of string 	= (
          {1}  'Aucun élément sélectionné'
          {2} ,'Changement d''imprimé.' + #13 + 'Les documents suivants s''éditeront d''après le modèle '
          {2} ,'Trop de documents sélectionnés. Veuiller réduire la sélection'
              );

implementation
uses BTFactImprTOB;

procedure TOF_BTEditDocDiff_Mul.OnArgument (stArgument : string) ;
var stPlus  : String;
    CC      : THValComboBox;
    x				: integer;
    Critere : String;
    ValMul	: String;
    ChampMul: String;
begin
fMulDeTraitement  := true;
inherited ;
	 fTableName := 'PIECE';

Repeat

    Critere:=uppercase(ReadTokenSt(stArgument)) ;
    if Critere<>'' then
        begin
        x:=pos('=',Critere);
        if x<>0 then
           begin
           ChampMul:=copy(Critere,1,x-1);
           ValMul:=copy(Critere,x+1,length(Critere));
           end
        else
           ChampMul := Critere;
        ControleChamp(ChampMul, ValMul);
        end;
until  Critere='';

if statut <> '' then setcontrolText('AFF_STATUTAFFAIRE', Statut);

if VenteAchat <> '' then
	 begin
	 if VenteAchat = 'STOCK' then
		  StPlus := 'AND (GPP_NATUREPIECEG="TEM" OR GPP_NATUREPIECEG="TRE" OR GPP_NATUREPIECEG="EEX" OR GPP_NATUREPIECEG="SEX")'
	 else
		  stplus := 'AND GPP_VENTEACHAT="' + VenteAchat + '"';
   end;

{$IFDEF NOMADE}
  if VenteAchat = 'VEN' then
     stPlus := stPlus + GetNaturePOP('GPP_NATUREPIECEG');
{$ENDIF} // NOMADE

//*** Blocages des natures de pièces autorisées en affaires
if (ctxAffaire in V_PGI.PGIContexte) and (VenteAchat='ACH') then
   begin
   if ctxScot in V_PGI.PGIContexte then
      begin
      SetControlText('GP_NATUREPIECEG','FF');
      Setcontrolenabled ('GP_NATUREPIECEG',False);
      end
   else
      begin
      stplus:=stPlus + ' AND ((GPP_NATUREPIECEG="CF") or (GPP_NATUREPIECEG="BLF") or (GPP_NATUREPIECEG="FF"))';
      end;
   end;
// **** Fin affaire ***

if not(ctxScot in V_PGI.PGIContexte) then setControlproperty ('GP_NATUREPIECEG','Plus',stplus);

if VenteAchat = 'VEN' then
    begin
    SetControlText ('GP_NATUREPIECEG', 'CC');
    SetControlCaption ('TGP_TIERS', 'Client de');
    end
else
    begin
    if Not (ctxScot in V_PGI.PGIcontexte) then SetControlText ('GP_NATUREPIECEG', 'CF');
    setControlproperty ('GP_TIERS','DataType','GCTIERSFOURN');
    setControlproperty ('GP_TIERS_','DataType','GCTIERSFOURN');
    SetControlText ('TGP_TIERS', 'Fourn. de');
    end;

CC:=THValComboBox(GetControl('GP_DOMAINE'));
if CC<>Nil then PositionneDomaineUser(CC) ;
CC:=THValComboBox(GetControl('GP_ETABLISSEMENT'));
if CC<>Nil then PositionneEtabUser(CC);

{$IFDEF BTP}
//SetControlVisible('PCOMPLEMENT',False);
if VenteAchat = 'VEN' then
    begin
    SetControlVisible ('GP_NATUREPIECEG', False);
    end;
{$ENDIF}

if Not(ctxAffaire in V_PGI.PGIContexte) and Not(ctxGCAFF in V_PGI.PGIContexte) then
   begin
   SetControlVisible ('TGP_AFFAIRE1', False);
   SetControlVisible ('GP_AFFAIRE1', False);
   SetControlVisible ('GP_AFFAIRE2', False);
   SetControlVisible ('GP_AFFAIRE3', False);
   SetControlVisible ('GP_AVENANT', False);
   end;

if not VH_GC.GCMultiDepots then SetControlCaption('TGP_DEPOTDEST','Etablis. destinataire');
{$IFDEF LINE}
SetControlVisible ('TGP_ETABLISSEMENT', False);
SetControlVisible ('GP_ETABLISSEMENT', False);
{$ENDIF}
end;

Procedure TOF_BTEditDocDiff_Mul.ControleChamp(Champ : String;Valeur : String);
Begin

	if Champ='STOCK' then VenteAchat := Champ;
	if Champ='VEN' then VenteAchat := Champ;
  if Champ='ACH' then VenteAchat := Champ;

  //Modif FV pour gestion des type d'affaire dans les mul de recherches
  //if Champ='STATUT' then statut := Valeur;
  if Champ='STATUT' then
     Begin
     if Valeur = 'APP' then
        Begin
	    	SetControlText('XX_WHERE', ' AND SUBSTRING(GP_AFFAIRE,1,1)="W"');
        SetControlText('AFFAIRE0', 'W');
        SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Appel');
        SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Critères Appel');
        SetControlText('TGP_AFFAIRE', 'Code Appel');
        end
     else if Valeur = 'INT' then
        Begin
      	SetControlText('XX_WHERE', ' AND SUBSTRING(GP_AFFAIRE,1,1)="I"');
        SetControlText('AFFAIRE0', 'I');
        SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Contrat');
        SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Critères contrat');
        SetControlText('TGP_AFFAIRE', 'Code Contrat');
        End
     else if Valeur = 'AFF' then
        Begin
      	SetControlText('XX_WHERE', ' AND SUBSTRING(GP_AFFAIRE,1,1)="A"');
        SetControlText('AFFAIRE0', 'A');
        SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Chantier');
        SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Critères Chantier');
        SetControlText('TGP_AFFAIRE', 'Code Chantier');
        end
     else if Valeur = 'GRP' then
        Begin
      	SetControlText('XX_WHERE', ' AND SUBSTRING(GP_AFFAIRE,1,1)="A"');
        SetControlText('AFFAIRE0', 'A');
        SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Affaires');
        SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Critères Affaire');
        SetControlText('TGP_AFFAIRE', 'Code Affaire');
        end
     else if Valeur = 'PRO' then
        Begin
      	SetControlText('XX_WHERE', ' AND SUBSTRING(GP_AFFAIRE,1,1)="P"');
        SetControlText('AFFAIRE0', 'P');
        SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Appel d''offre');
        SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Critères Appel d''offre');
        SetControlText('TGP_AFFAIRE', 'Code Appel d''offre');
        end
     else
        Begin
      	SetControlText('XX_WHERE', '');
        SetControlText('AFFAIRE0', '');
        SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Affaire');
        SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Critères Affaire');
        SetControlText('TGP_AFFAIRE', 'Code Affaire');
        end;
     end;

end;

Procedure TOF_BTEditDocDiff_Mul.NomsChampsAffaire ( Var Aff,Aff0,Aff1,Aff2,Aff3,Aff4,Aff_,Aff0_,Aff1_,Aff2_,Aff3_,Aff4_,Tiers,Tiers_ : THEdit ) ;
BEGIN
Aff:=THEdit(GetControl('GP_AFFAIRE'));
Aff0:=THEdit(GetControl('AFFAIRE0')) ;
Aff1:=THEdit(GetControl('GP_AFFAIRE1')) ;
Aff2:=THEdit(GetControl('GP_AFFAIRE2')) ;
Aff3:=THEdit(GetControl('GP_AFFAIRE3')) ;
Aff4:=THEdit(GetControl('GP_AVENANT'))  ;
END ;

procedure TOF_BTEditDocDiff_Mul.LanceEdition ;
var F : TFMul ;
    TobPiece : TOB ;
    iInd : integer ;
    stWhere, stNature : string ;
    TSql : TQuery ;
    Indice : integer;
begin
F:=TFMul(Ecran);
if(F.FListe.NbSelected=0)and(not F.FListe.AllSelected) then
    begin
{$IFDEF EAGLCLIENT}
{$ELSE}
    if VAlerte<>Nil then VAlerte.Visible:=FALSE ;
{$ENDIF}
    HShowMessage('0;'+F.Caption+';'+TexteMessage[1]+';W;O;O;O;','','') ;
    exit;
    end;

TobPiece := TOB.Create ('', Nil, -1) ;
if TobPiece = nil then exit ;

if F.FListe.AllSelected then
    begin
    stWhere := RecupWhereCritere(F.Pages);
    TSql := OpenSQL ('SELECT count(GP_NUMERO) as nbr FROM PIECE ' + stWhere, True);
    if (not TSql.Eof) and (TSql.FindField ('nbr').AsInteger < 2000) then
        begin
        Ferme (TSql);
        TSql := OpenSQL ('SELECT * FROM PIECE ' + stWhere, True);
        if not TSql.EOF then TobPiece.LoadDetailDB('PIECE', '', '', TSql, False) else TobPiece := nil;
        Ferme (TSql) ;
        end else
        begin
        Ferme (TSql);
        HShowMessage('0;'+TFMUL(Ecran).Caption+';'+TexteMessage[3]+';W;O;O;O;', '', '');
        end;
    end else
    begin
    stWhere := '';
    stNature := GetControlText ('GP_NATUREPIECEG');
    for iInd:=0 to F.FListe.NbSelected-1 do
        begin
        F.FListe.GotoLeBOOKMARK(iInd);
{$IFDEF EAGLCLIENT}
        F.Q.TQ.Seek(F.FListe.Row-1) ;
{$ENDIF}
        if stWhere <> '' then stWhere := stWhere + ' OR ';
        stWhere := stWhere + '(GP_SOUCHE="'  + F.Q.FindField('GP_SOUCHE').AsString + '"' +
                           ' AND GP_NUMERO=' + F.Q.FindField('GP_NUMERO').AsString +
                           ' AND GP_INDICEG=' + F.Q.FindField('GP_INDICEG').AsString + ')';

        end;
    TSql := OpenSql ('SELECT * FROM PIECE WHERE GP_NATUREPIECEG="' + stNature + '" AND (' +
                     stWhere + ')', True);
    if not TSql.EOF then TobPiece.LoadDetailDB('PIECE', '', '', TSql, False) else TobPiece := nil;
    Ferme (TSql);
    end;

if TobPiece.Detail.Count > 0 then
begin
    EditeLesDocs (TobPiece) ;
    if GetControlText ('GP_EDITEE') = '-' then
    begin
    	for Indice := 0 to TOBpiece.detail.count -1 do
      begin
				TobPiece.detail[Indice].UpdateDB(false);
      end;
    end;
end;

if F.FListe.AllSelected then F.FListe.AllSelected:=False else F.FListe.ClearSelected;
F.bSelectAll.Down := False ;
TobPiece.free ;
end;

Function TOF_BTEditDocDiff_Mul.NomCorrect ( NomPDF : String ) : Boolean ;
Var FFText : TextFile ;
BEGIN
Result:=False ;
if NomPDF='' then Exit ;
if Pos('.PDF',NomPDF)<=0 then Exit ;
AssignFile(FFText,NomPDF) ; {$i-} Rewrite(FFText) ; {$i+}
if IoResult=0 then
   BEGIN
   CloseFile(FFText) ; DeleteFile(NomPDF) ;
   Result:=True ;
   END ;
END ;

function TOF_BTEditDocDiff_Mul.GetInfoRecapFromModele(TobPiece : TOB) : boolean;
var SQl : string;
		Q : TQuery;
begin
  result := false;
  SQL:='SELECT BPD_IMPTABTOTSIT FROM BTPARDOC WHERE BPD_NATUREPIECE="'+TOBPiece.getValue('GP_NATUREPIECEG')+
  		 '" AND BPD_SOUCHE="'+TOBPiece.getValue('GP_SOUCHE')+
  		 '" AND BPD_NUMPIECE='+IntToStr(TOBPiece.getValue('GP_NUMERO')) ;
  Q:=OpenSQL(SQL,TRUE) ;
  if Not Q.EOF then
  begin
  	result:=(Q.Fields[0].AsString='X');
  end else
  Begin
    Ferme(Q);
    SQL:='SELECT BPD_IMPTABTOTSIT FROM BTPARDOC WHERE BPD_NATUREPIECE="'+TOBPiece.getValue('GP_NATUREPIECEG')+
    		 '" AND BPD_SOUCHE="'+TOBPiece.getValue('GP_SOUCHE')+'" AND BPD_NUMPIECE=0' ;
    Q:=OpenSQL(SQL,TRUE) ;
    if Not Q.EOF then result:=(Q.Fields[0].AsString='X')
  End;
  Ferme(Q) ;
end;

procedure TOF_BTEditDocDiff_Mul.EditeLesDocs (TobPiece : TOB) ;
var iInd, iNbExemplaire,iNbPiece : integer;
    CleDoc : R_CleDoc;
    stSql, stCle, stModele,stModeleNonDirect,NomPDF,SQLOrder : string;
    TL : TList;
    TT : TStrings;
    BApercu, BAp, BDuplicata, {BFichierPDF, } OldQRThread,OldQR, BEditDirect : boolean;
//    CFichierPDF : TCheckBox ;
    ENomPDF     : THEdit ;
    Pages : TpageControl;
    ImprViaTOB : TImprPieceViaTOB;
    Nbexemplaires : integer;
    recapSituations : boolean;
    TheModele,ModeleR : string;
    UneTOB : TOB;
    BEditionDirect : boolean;
    ChoixDirect,ChoixNonDirect,Choix : string;
    ModeleDirect,ModeleNonDirect : string;
  	ChoixAvancNonDirect :string;
  	ModeleAvancNonDirect : string;
  	ChoixAvancDirect :string;
  	ModeleAvancDirect : string;

begin
	RecapSituations := false;
  BEditDirect := TCheckBox(GetControl ('EDITDIRECT')).Checked;
  BApercu := TCheckBox(GetControl ('BAPERCU')).Checked;
  BDuplicata := TCheckBox(GetControl ('BDUPLICATA')).Checked;
	ImprViaTOB := nil;
  Pages:=Nil;
  OldQRThread := V_PGI.QRMultiThread;
  OldQR := V_PGI.QRPDF;
 	ChoixNonDirect := '';
  ModeleNonDirect := '';
  ChoixDirect := '';
  ModeleDirect := '';
  ChoixAvancNonDirect := '';
  ModeleAvancNonDirect := '';
  ChoixAvancDirect := '';
  ModeleAvancDirect := '';
  //
	for iInd := 0 to TobPiece.Detail.count - 1 do
  begin
    if ((Pos(GetControltext('GP_NATUREPIECEG'),'FBT;DAC')>0)) and
    		(pos(RenvoieTypeFact (TobPiece.detail[iind].GetValue('GP_AFFAIREDEVIS')), 'AVA;DAC')>0) then
    begin
    	if BeditDirect then
      begin
        if (ChoixAvancDirect ='') then
        begin
          RenseignePiece (TobPiece.Detail[IInd],BApercu,Choix,stModele,true,Nbexemplaires);
          ChoixAvancDirect := Choix;
          ModeleAvancDirect := stModele;
        end else
        begin
          SetInfoPieces (TOBPiece.detail[iInd],
                        ChoixAvancDirect + ModeleAvancDirect,TOBPiece.detail[0].getValue('OKETAT'),
                        NbExemplaires);
        end;
      end else begin
        if (ChoixAvancNonDirect ='') then
        begin
          RenseignePiece (TobPiece.Detail[IInd],BApercu,Choix,stModele,false,Nbexemplaires);
          ChoixAvancNonDirect := Choix;
          ModeleAvancNonDirect := stModele;
        end else
        begin
          SetInfoPieces (TOBPiece.detail[iInd],
                        ChoixAvancNonDirect + ModeleAvancNonDirect,TOBPiece.detail[0].getValue('OKETAT'),
                        NbExemplaires);
        end;
      end;
    end else
    begin
    	if BeditDirect then
      begin
        if (ChoixDirect ='') then
        begin
          RenseignePiece (TobPiece.Detail[IInd],BApercu,Choix,stModele,true,Nbexemplaires);
          ChoixDirect := Choix;
          ModeleDirect := stModele;
        end else
        begin
          SetInfoPieces (TOBPiece.detail[iInd],
                        ChoixDirect + ModeleDirect,
                        TOBPiece.detail[0].getValue('OKETAT'),
                        NbExemplaires);
        end;
      end else
      begin
        if (ChoixNonDirect ='') then
        begin
          RenseignePiece (TobPiece.Detail[IInd],BApercu,Choix,stModele,false,Nbexemplaires);
          ChoixNonDirect := Choix;
          ModeleNonDirect := stModele;
        end else
        begin
          SetInfoPieces (TOBPiece.detail[iInd],
                        ChoixNonDirect + ModeleNonDirect,
                        TOBPiece.detail[0].getValue('OKETAT'),
                        NbExemplaires);
        end;
      end;
    end;
  end;

  if BEditDirect then
  begin
  	ImprViaTOB := TImprPieceViaTOB.create(ecran);
  end;
  //
  if TOBPiece.detail.count > 0 then bapercu := true;
  //
  TobPiece.Detail.Sort ('ETATSTANDARD_IMPMODELE;GP_NUMERO');
  for iInd := 0 to TobPiece.Detail.Count - 1 do
  begin
    if (Not TobPiece.Detail[iInd].GetValue ('OKETAT')) then Continue;
    
 		RecapSituations := false;

    BEditionDirect := BEditDirect;
    if (Pos(TobPiece.detail[iind].GetValue('GP_NATUREPIECEG'),'FBT;DAC')>0) and (pos(RenvoieTypeFact (TobPiece.detail[iind].GetValue('GP_AFFAIREDEVIS')), 'AVA;DAC')>0) then
    begin
      recapSituations := GetInfoRecapFromModele(TobPiece.detail[iind]);
    end;
    if TOBPiece.detail[iInd].getValue('GP_NATUREPIECEG')='FBT' then
    begin
      CalcReglementSituations (TOBPiece.detail[iInd].getValue('GP_AFFAIRE'));
    end;
    stModele := copy (TobPiece.Detail[iInd].GetValue ('ETATSTANDARD_IMPMODELE'), 2,
    length (TobPiece.Detail[iInd].GetValue ('ETATSTANDARD_IMPMODELE')) - 1);
    stCle := TobPiece.Detail[iInd].GetValue ('GP_NATUREPIECEG') + ';' +
    DateToStr (TobPiece.Detail[iInd].GetValue ('GP_DATEPIECE')) + ';' +
    TobPiece.Detail[iInd].GetValue ('GP_SOUCHE') + ';' +
    IntToStr (TobPiece.Detail[iInd].GetValue ('GP_NUMERO')) + ';' +
    IntToStr (TobPiece.Detail[iInd].GetValue ('GP_INDICEG'));
    StringToCleDoc (stCle, CleDoc);
    if (not BEditionDirect) then
    begin
      {$IFDEF CCS3}
      if TobPiece.Detail[iInd].GetValue ('OKETAT') then
      begin
        stSql:=RecupSQLModele('E','GPJ', stModele,'','','',' WHERE '+WherePiece(CleDoc,ttdPiece,False));
        if (pos('ORDER BY',uppercase(stSql))<=0) then stSql:=stSql+' order by GL_NATUREPIECEG,GL_SOUCHE,GL_NUMERO,GL_INDICEG,GL_NUMLIGNE,GL_ARTICLE' ;
        Pages := TPageControl.Create(Application);
      end else
      begin
        stSql:=RecupSQLModele('L','GPI', stModele,'','','',' WHERE '+WherePiece(CleDoc,ttdPiece,False));
        if (pos('ORDER BY',uppercase(stSql))<=0) then stSQL := stSQL+ ' ORDER BY GL_NUMLIGNE';
      end ;
      {$ELSE}
      if TobPiece.Detail[iInd].GetValue ('OKETAT') then
      begin
        SQLOrder:='';
        stSql:=RecupSQLEtat('E','GPJ', stModele,'','','',' WHERE '+WherePiece(CleDoc,ttdPiece,False),SQLOrder);
        stSql:=stSql+' and GL_NONIMPRIMABLE<>"X"' ;
        if (SQLOrder='') then stSql:=stSql+' order by GL_NATUREPIECEG,GL_SOUCHE,GL_NUMERO,GL_INDICEG,GL_NUMLIGNE,GL_ARTICLE'
                         else stSql:=stSql+' '+SQLOrder;
        Pages := TPageControl.Create(Application);
      END else
      BEGIN
        SQLOrder:='';
        stSql:=RecupSQLEtat('L','GPI', stModele,'','','',' WHERE '+WherePiece(CleDoc,ttdPiece,False),SQLOrder);
        if (SQLOrder='') then stSql := stSql+ ' ORDER BY GL_NUMLIGNE'
                         else stSql:=stSql+' '+SQLOrder;
      END;
      {$ENDIF}
    end else
    begin
      ImprViaTOB.ClearInternal;
      ImprViaTOB.SetDocument (cledoc,false);
      ImprViaTOB.PreparationEtat;
    end;
    if NomPDF='' then BAp:=BApercu else BAp:=True ;
    iNbPiece := StrToInt(TobPiece.Detail[iInd].GetValue ('NBEXEMPLAIRE'));
    if iNbPiece = 0 then iNbPiece :=1;
    for iNbExemplaire := 1 to iNbpiece do
    begin
      TL := TList.Create ;
      TT := TStringList.Create ;
      TT.Add (stSql);
      TL.Add (TT);
      if ((iInd > 0) or (iNbExemplaire > 1)) and (Bap = False) then V_PGI.NoPrintDialog := True;
      if TobPiece.Detail[iInd].GetValue ('OKETAT') then
      BEGIN
        if (iInd = 0) and ((tobpiece.detail.count >1) or (RecapSituations))  and (iNbExemplaire = 1) then
        begin
          StartPDFBatch;
        end;
        if (iInd = TobPiece.Detail.Count - 1) and (tobpiece.detail.count >1) and (iNbExemplaire = iNbpiece) and (not RecapSituations) then
        begin
        	LastPDFBatch;
        end;
    		if (not BEditionDirect) then
        begin
    			if LanceEtat('E','GPJ',stModele,bap,False,False,Nil,trim (stSql),'',BDuplicata)<0 then V_PGI.IoError:=oeUnknown ;
        end else
        begin
          TheModele:=stModele;
          If TheModele = '' Then TheModele := ImprViaTOB.GetModeleAssocie(stModele);
          if TheModele = '' then break;
          UneTOB := ImprViaTOB.TOBAIMPRIMER;
          if LanceEtatTOB ('E','GPJ',TheModele,UneTOB,Bap,false,false,nil,'','',Bduplicata) < 0 then
            V_PGI.IoError:=oeUnknown ;
        end;
        // Edition du recap de situations si besoin est
        if (V_PGI.IoError = OeOk) and (RecapSituations) then
        begin
          if (iInd = TobPiece.Detail.Count - 1) and (iNbExemplaire = iNbpiece) and (RecapSituations) then
          begin
            LastPDFBatch;
          end;
          SQLOrder:='';
          ModeleR:=GetParamsoc('SO_BTETATSIR');
          if ModeleR='' then ModeleR:=Copy(stModele,1,2)+'R';
          stSQL:=RecupSQLEtat('E','GPJ',ModeleR,'','','',' WHERE '+WherePiece(CleDoc,ttdPiece,False),SQLOrder) ;
          stSQL:=stSql+' '+SQLOrder;
          LanceEtat('E','GPJ',ModeleR,bap,False,False,Nil,Trim(stSQL),'',Bduplicata);
        end;
        // ---
        if V_PGI.ioError <> OeOk then CancelPDFBatch;
      END;
      BAp:=false;
      TT.Free;
      TL.Free;
    end;

    if TobPiece.Detail[iInd].GetValue ('OKETAT') then Pages.Free;

    if GetControlText ('GP_EDITEE') = '-' then TobPiece.Detail[iInd].PutValue ('GP_EDITEE', 'X');

    if BEditDirect then
    begin
      ImprViaTOB.ClearInternal;
    end;
    if V_PGI.ioError <> oeOk then break;
  end;
{$IFNDEF EAGLCLIENT}
	if (tobpiece.detail.count >1) or (RecapSituations) then
  begin
  	if Bapercu then
    begin
  		PreviewPDFFile('',GetMultiPDFPath,True);
    end else
    begin
    	PrintPdf(GetMultiPDFPath, '', '');
    end;
  end;
{$ENDIF}
  if BEditDirect then
  begin
  	ImprViaTOB.free;
  end;
  V_PGI.QRPDF := OldQR;
  V_PGI.QRPDFQueue := '';
  V_PGI.QRPDFMerge := '';
  V_PGI.QRMultiThread := OldQRThread;
  V_PGI.PrintToFile := false;
  V_PGI.QRPrinted := false;
  v_pgi.MiseSousPli := False;
  v_pgi.PageMiseSousPli := 0;
end;

procedure TOF_BTEditDocDiff_Mul.ModificationModeleBTP(var OkEtat, BApercu: boolean; var Modele : string; var NbCopies : integer; EditDirect : boolean);
var NouvelleValeur : string;
		Apercu,modeleEtat,IsEtat,stTitre : string;
begin
	if EditDirect then stTitre := 'Sélection du modèle direct'
  							else stTitre := 'Sélection du modèle non direct';
  if BApercu then Apercu:='X' else Apercu:='-' ;
  ModeleEtat:=Modele ;
  NouvelleValeur:=AGLLanceFiche('MBO','VALIDMODELE','','','MODELEETAT='+ModeleEtat+';'
                  +';MODELEETIQ=;APERCU='+Apercu+';APERCUETIQ=-;IMPETIQ=-;TITRE='+stTitre+';'+
                  'NBCOPIE='+IntToStr(NbCopies)+'') ;
  if NouvelleValeur <>'' then
  begin
    IsEtat:=ReadTokenSt(NouvelleValeur) ;
    if IsEtat='X' then OkEtat:=True else OkEtat:=False ;
    Modele:=ReadTokenSt(NouvelleValeur) ;
    Apercu:=ReadTokenSt(NouvelleValeur) ;
    if Apercu='X' then Bapercu:=True else BApercu:=False ;
    NBCopies:=StrToInt(ReadTokenST(NouvelleValeur)) ;
  end else OkEtat:=False ;
end;

procedure TOF_BTEditDocDiff_Mul.RenseignePiece (TobP : TOB; var BApercu : boolean; var Choix : string; var Modele: string; EditDirect : boolean; var Nbcopies : integer);
var
		QTiers : TQuery;
    stEtatStandard, Suff : string;
    NaturePiece, {Modele,} Domaine, Etab :string;
    OkEtat: boolean;
begin
if (not TOBP.FieldExists ('ETATSTANDARD_IMPMODELE')) then
begin
  TobP.AddChampSup ('ETATSTANDARD_IMPMODELE', True);
  TobP.AddChampSup ('NBEXEMPLAIRE', true);
  TobP.AddChampSup ('OKETAT', True);
end;

NaturePiece:=TobP.GetValue('GP_NATUREPIECEG') ; OkEtat:=False ;
Etab:=TobP.GetValue('GP_ETABLISSEMENT') ; Domaine:=TobP.GetValue('GP_DOMAINE') ;
Suff:='' ; if TobP.GetValue('GP_SAISIECONTRE')='X' then Suff:='CON' ;
Modele:='' ;
if NbCopies = 0 then
begin
	NbCopies:=GetInfoParPiece(NaturePiece,'GPP_NBEXEMPLAIRE') ; if ((NbCopies<0) or (NbCopies>99)) then NbCopies:=0 ;
end;

{Recherche sur profils tiers}
QTiers := OpenSQL('SELECT GTP_IMPMODELE' + Suff + ', GTP_IMPETAT' + Suff
       + ', GTP_NBEXEMPLAIRE FROM TIERSPIECE WHERE GTP_TIERS="' + TobP.GetValue ('GP_TIERS')
       + '" AND GTP_NATUREPIECEG="' + TobP.GetValue ('GP_NATUREPIECEG') + '"',false);
if not QTiers.Eof then
   BEGIN
   Modele:=QTiers.FindField('GTP_IMPETAT'+Suff).AsString ;
   if Modele<>'' then OkEtat:=True else Modele:=QTiers.FindField('GTP_IMPMODELE'+Suff).AsString ;
   NbCopies:=QTiers.FindField('GTP_NBEXEMPLAIRE').AsInteger ; if ((NbCopies<0) or (NbCopies>99)) then NbCopies:=0 ;
   stEtatStandard := '4';
   END ;
Ferme(QTiers);

{Recherche sur "les "PARPIECE}
if Modele='' then
   BEGIN
   {Etat Nature/Domaine}
   stEtatStandard := '3' ;
   Modele:=GetInfoParPieceDomaine(NaturePiece,Domaine,'GDP_IMPETAT'+Suff) ;
   if Modele<>'' then  OkEtat:=True else
      BEGIN
      {Document Nature/Domaine}
      Modele:=GetInfoParPieceDomaine(NaturePiece,Domaine,'GDP_IMPMODELE'+Suff) ;
      if Modele='' then
         BEGIN
         stEtatStandard := '2' ;
         {Etat Nature/Etablissement}
         Modele:=GetInfoParPieceCompl(NaturePiece,Etab,'GPC_IMPETAT'+Suff) ;
         if Modele<>'' then OkEtat:=True else
            BEGIN
            {Document Nature/Etablissement}
            Modele:=GetInfoParPieceCompl(NaturePiece,Etab,'GPC_IMPMODELE'+Suff) ;
            if Modele='' then
               BEGIN
               stEtatStandard := '1' ;
               if EditDirect then
               begin
            		 Modele:=GetInfoParPiece(NaturePiece, 'GPP_IMPMODELE');
                 if Modele <> '' then OkEtat := true;
               end else
               begin
                {Etat Nature}
                 Modele:=GetInfoParPiece(NaturePiece,'GPP_IMPETAT'+Suff) ;
                {Modèle Nature}
                 if Modele<>'' then OkEtat:=True else Modele:=GetInfoParPiece(NaturePiece,'GPP_IMPMODELE'+Suff) ;
               end;
               END ;
            END ;
         END ;
      END ;
   END ;

// Recherche sur Paramsoc
if Modele='' then begin stEtatStandard := '0' ; Modele:=VH_GC.GCImpModeleDefaut ; end;

// --- Modif BTP
// Recherche spéciale pour le modèle des situations de travaux (BTP)
{$IFDEF BTP}
  if (Pos(NaturePiece,'FBT;DAC')>0) and (pos(RenvoieTypeFact (TobP.GetValue('GP_AFFAIREDEVIS')), 'AVA;DAC')>0) then
  begin
    if EditDirect then
    begin
      // Récupérer le modèle des situations dans les paramètres
      Modele:=GetParamsoc('SO_BTETATSITDIR');
    end else
    begin
      // Récupérer le modèle des situations dans les paramètres
      Modele:=GetParamsoc('SO_BTETATSIT');
    end;
    OkEtat:=True;
  end;

  if OkEtat then
  begin
    if GetInfoParPiece(NaturePiece, 'GPP_VALMODELE') = 'X' then
  	begin
      ModificationModeleBTP(OkEtat, BApercu, Modele,NbCopies,EditDirect);
    end;
  end;
  if Bapercu then TCheckBox(GetControl ('BAPERCU')).Checked := true
  					 else TCheckBox(GetControl ('BAPERCU')).Checked := false;

{$ENDIF}
Choix := stEtatStandard;
TobP.PutValue ('ETATSTANDARD_IMPMODELE', stEtatStandard + Modele);
TobP.PutValue ('OKETAT', OkEtat);
TobP.PutValue ('NBEXEMPLAIRE', NbCopies);
if GetInfoParPiece(NaturePiece,'GPP_ACTIONFINI') = 'IMP' then TobP.PutValue ('GP_VIVANTE', '-');
end;



procedure TOF_BTEditDocDiff_Mul.SetInfoPieces (TobP : TOB; ETATSTANDARD : string; OKETAT : boolean; NbExemplaire : integer);
var naturePiece : string;
begin
	NaturePiece:=TobP.GetValue('GP_NATUREPIECEG') ;
  if (not TOBP.fieldExists('ETATSTANDARD_IMPMODELE')) then
  begin
    TobP.AddChampSup ('ETATSTANDARD_IMPMODELE', True);
    TobP.AddChampSup ('NBEXEMPLAIRE', true);
    TobP.AddChampSup ('OKETAT', True);
  end;
  TobP.PutValue ('ETATSTANDARD_IMPMODELE', ETATSTANDARD);
  TobP.PutValue ('OKETAT', OKETAT);
  TobP.PutValue ('NBEXEMPLAIRE', NbExemplaire);
  if GetInfoParPiece(NaturePiece,'GPP_ACTIONFINI') = 'IMP' then TobP.PutValue ('GP_VIVANTE', '-');
end;

/////////////// Procedure appellé par le bouton Validation //////////////
procedure AGLEditDocDiff_mul(parms:array of variant; nb: integer ) ;
var  F : TForm ;
     MaTOF  : TOF;
begin
F:=TForm(Longint(Parms[0])) ;
if (F is TFmul) then MaTOF:=TFMul(F).LaTOF else exit;
if (MaTOF is TOF_BTEditDocDiff_Mul) then TOF_BTEditDocDiff_Mul(MaTOF).LanceEdition else exit;
end;

Initialization
registerclasses([TOF_BTEditDocDiff_Mul]);
RegisterAglProc('BTEditDocDiff_mul',TRUE,1,AGLEditDocDiff_mul);
end.
