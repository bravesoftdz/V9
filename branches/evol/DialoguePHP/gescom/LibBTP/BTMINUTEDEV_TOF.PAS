{***********UNITE*************************************************
Auteur  ...... :  LS
Créé le ...... : 11/02/2011
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTMINUTEDEV ()
Mots clefs ... : TOF;BTMINUTEDEV
*****************************************************************}
Unit BTMINUTEDEV_TOF ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,fe_main,
{$else}
     eMul, MainEagl,
{$ENDIF}
     uTob,
     forms,
     Aglinit,
     M3FP,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     SaisUtil,
     stat,
     UTOF ;

Type
  TOF_BTMINUTEDEV = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  private
  	//
  end ;


procedure LanceMinuteDevis(TOBPiece,TOBTiers,TOBOuvrages,TOBOuvragesP,TOBARTicles : TOB; DEV : RDEVISE);

Implementation
uses FactureBTP,FactUtil,factOuvrage,ParamSoc,Factcalc;
var TOBMinute,TOBOUVPP : TOB;

procedure AddlesChamps (TOBDM :TOB);
begin
	TOBDM.AddChampSupValeur('BMN_LIGNE',0);
	TOBDM.AddChampSupValeur('BMN_PARAG','');
	TOBDM.AddChampSupValeur('BMN_SPARAG','');
	TOBDM.AddChampSupValeur('BMN_CATEGORIE',''); // Catégorie : type de ressource
	TOBDM.AddChampSupValeur('BMN_NATURE',''); // Nature de la ligne Fourniture,Salarie,sous traitant, etc..
	TOBDM.AddChampSupValeur('BMN_FAMILLE1',''); // Famille de niveau 1
	TOBDM.AddChampSupValeur('BMN_FAMILLE2',''); // Famille de niveau 1
	TOBDM.AddChampSupValeur('BMN_FAMILLE3',''); // Famille de niveau 1
	TOBDM.AddChampSupValeur('BMN_OUVRAGE',''); // Code ouvrage
	TOBDM.AddChampSupValeur('BMN_UNITEOUV',''); // Unité ouvrage
	TOBDM.AddChampSupValeur('BMN_QTEOUV',''); // Qté ouvrage
	TOBDM.AddChampSupValeur('BMN_ARTICLE',''); // Code article
	TOBDM.AddChampSupValeur('BMN_QTEACH',0.0); // Qte marchandise
	TOBDM.AddChampSupValeur('BMN_UNITEACH',''); // Unite marchandise
	TOBDM.AddChampSupValeur('BMN_PAACH',0.0); // Pa marchandise
	TOBDM.AddChampSupValeur('BMN_MTACH',0.0); // Pa marchandise
	TOBDM.AddChampSupValeur('BMN_QTEHRS',0.0); // Qte MO
	TOBDM.AddChampSupValeur('BMN_UNITEHRS',''); // Unite MO
	TOBDM.AddChampSupValeur('BMN_PAHRS',0.0); // PA MO
	TOBDM.AddChampSupValeur('BMN_MTHRS',0.0); // Mt MO
	TOBDM.AddChampSupValeur('BMN_QTE',0.0); // Qte Unitaire
	TOBDM.AddChampSupValeur('BMN_PUV',0.0); // Pu Vente
	TOBDM.AddChampSupValeur('BMN_MTPUV',0.0); // Montant PV
	TOBDM.AddChampSupValeur('BMN_PR',0.0); // Pu revient
	TOBDM.AddChampSupValeur('BMN_MTPR',0.0); // Montant Revient
end;

procedure  AddLignePrestation (TOBMinute,TOBOUV,TOBL,TOBArticles : TOB; NiveauImbric : integer; LibP1,LibP2 : string);
var prefixe : string;
		TOBArt,TOBDM : TOB;
    NewArt : boolean;
    QQ : TQuery;
begin
	if TOBL.NomTable = 'LIGNE' then
  begin
  	preFixe := 'GL';
  end else
  begin
  	preFixe := 'BOP';
  end;
  //
  TOBDM := TOB.Create ('LIGNE MINUTE',TOBMinute,-1);
  AddlesChamps(TOBDM);
  newArt := false;
  TOBART := TOBArticles.findFirst(['GA_ARTICLE'], [TOBL.GetValue(prefixe+'_ARTICLE')],true);
  if TOBART = Nil then
  begin
  	TOBART := TOB.Create('ARTICLE',nil,-1);
    QQ := OpenSQl('SELECT GA_QUALIFUNITEVTE, GA_NATUREPRES,GA_FAMILLENIV1,GA_FAMILLENIV2,'+
    							'GA_FAMILLENIV3,BNP_LIBELLE,BNP_TYPERESSOURCE FROM ARTICLE '+
									'LEFT OUTER JOIN NATUREPREST ON BNP_NATUREPRES=GA_NATUREPRES '+
    						  'WHERE GA_ARTICLE="'+ TOBL.GetValue(prefixe+'_ARTICLE')+'"',true,1,'',true);
    if not QQ.eof then
    begin
    	TOBART.SelectDB('',QQ);
    end;
    ferme(QQ);
    newArt := true;
  end;

  if NiveauImbric > 1 then
  begin
    TOBDM.PutValue('BMN_PARAG',LibP1);
    TOBDM.PutValue('BMN_SPARAG',LIBP2);
  end else if NiveauImbric > 0 then
  begin
    TOBDM.PutValue('BMN_PARAG',LibP1);
    TOBDM.PutValue('BMN_SPARAG','  0 : Hors paragraphe');
  end else
  begin
    TOBDM.PutValue('BMN_PARAG','  0 : Hors paragraphe');
    TOBDM.PutValue('BMN_SPARAG','  0 : Hors paragraphe');
  end;
	TOBDM.PutValue('BMN_CATEGORIE',TOBArt.getValue('BNP_TYPERESSOURCE'));
	TOBDM.PutValue('BMN_NATURE',TOBArt.getValue('GA_NATUREPRES')+' : '+TOBArt.getValue('BNP_LIBELLE'));
	TOBDM.PutValue('BMN_FAMILLE1',rechdom('GCFAMILLENIV1',TOBArt.getValue('GA_FAMILLENIV1'),false)); // Famille de niveau 1
	TOBDM.PutValue('BMN_FAMILLE2',rechdom('GCFAMILLENIV2',TOBArt.getValue('GA_FAMILLENIV2'),false)); // Famille de niveau 1
	TOBDM.PutValue('BMN_FAMILLE3',rechdom('GCFAMILLENIV3',TOBArt.getValue('GA_FAMILLENIV3'),false)); // Famille de niveau 1
  if TOBOUV <> nil then
  begin
		TOBDM.PutValue('BMN_OUVRAGE',TOBOUV.GetValue('GL_CODEARTICLE')+' - '+TOBOUV.GetValue('GL_LIBELLE')+
                                                 ' : '+FloatToStr(TOBOUV.GetValue('GL_QTEFACT'))+
                                                 ' '+TOBOUV.GetValue('GL_QUALIFQTEVTE')); // Code ouvrage + libelle + qté + unité
	  TOBDM.PutValue('BMN_QTEOUV',TOBOUV.GetValue('GL_QTEFACT')); // Qte ouvrage
	  TOBDM.PutValue('BMN_UNITEOUV',TOBOUV.GetValue('GL_QUALIFQTEVTE')); // Unité ouvrage
    if TOBOUV.GetValue('GL_QTEFACT') <> 0 then
  	  TOBDM.PutValue('BMN_QTE',(TOBL.GetValue(prefixe+'_QTEFACT')/TOBOUV.GetValue('GL_QTEFACT'))); // Qte  Unitaire
  end else
  begin
  	TOBDM.PutValue('BMN_OUVRAGE','Hors ouvrage');
	  TOBDM.PutValue('BMN_QTE',TOBL.GetValue(prefixe+'_QTEFACT')); // Qte  Unitaire
  end;
	TOBDM.PutValue('BMN_ARTICLE',TOBL.GetValue(prefixe+'_CODEARTICLE')+' : '+TOBL.GetValue(prefixe+'_LIBELLE')); // Code article
  if pos(TOBArt.getValue('BNP_TYPERESSOURCE'), GetparamSocSecur ('SO_BTMOINTERNE','INT;SAL'))>0  then
  begin
    TOBDM.PutValue('BMN_QTEHRS',TOBL.GetValue(prefixe+'_QTEFACT')); // Qte MO

    // modif brl 30/03/2011 :
    // en attendant l'ajout du champ BOP_QUALIFQTEVTE manquant dans la table LIGNEOUVPLAT
    // on prend l'unité de vente dans la table ARTICLE
    if prefixe = 'BOP' then TOBDM.PutValue('BMN_UNITEHRS',TOBArt.GetValue('GA_QUALIFUNITEVTE'))else // Unite MO
                            TOBDM.PutValue('BMN_UNITEHRS',TOBL.GetValue(prefixe+'_QUALIFQTEVTE')); // Unite MO
    TOBDM.PutValue('BMN_PAHRS',TOBL.GetValue(prefixe+'_DPA')); // PA MO
    TOBDM.PutValue('BMN_MTHRS',TOBL.GetValue(prefixe+'_MONTANTPA')); // Mt MO
  end else
  begin
    TOBDM.PutValue('BMN_QTEACH',TOBL.GetValue(prefixe+'_QTEFACT')); // Qte marchandise
    // modif brl 30/03/2011 :
    // en attendant l'ajout du champ BOP_QUALIFQTEVTE manquant dans la table LIGNEOUVPLAT
    // on prend l'unité de vente dans la table ARTICLE
    if prefixe = 'BOP' then TOBDM.PutValue('BMN_UNITEACH',TOBArt.GetValue('GA_QUALIFUNITEVTE'))else // Unite marchandise
                            TOBDM.PutValue('BMN_UNITEACH',TOBL.GetValue(prefixe+'_QUALIFQTEVTE')); // Unite marchandise
    TOBDM.PutValue('BMN_PAACH',TOBL.GetValue(prefixe+'_DPA')); // Pa marchandise
    TOBDM.PutValue('BMN_MTACH',TOBL.GetValue(prefixe+'_MONTANTPA')); // Pa marchandise
  end;
	TOBDM.PutValue('BMN_PUV',TOBL.GetValue(prefixe+'_PUHTDEV')); // Pu Vente
	TOBDM.PutValue('BMN_MTPUV',TOBL.GetValue(prefixe+'_MONTANTHTDEV')); // Montant PV
	TOBDM.PutValue('BMN_PR',TOBL.GetValue(prefixe+'_DPR')); // Pu Revient
	TOBDM.PutValue('BMN_MTPR',TOBL.GetValue(prefixe+'_MONTANTPR')); // Montant revient
  if TOBOUV <> nil then
  begin
		TOBDM.PutValue('BMN_LIGNE',TOBOUV.GetValue('GL_NUMLIGNE')); // Montant PV
  end else
  begin
		TOBDM.PutValue('BMN_LIGNE',TOBL.GetValue('GL_NUMLIGNE')); // Montant PV
  end;
  if NewArt then TOBArt.free;
end;

procedure  AddLigneMarchandise (TOBMinute,TOBOUV,TOBL,TOBArticles : TOB; NiveauImbric : integer; LibP1,LibP2 : string);
var prefixe : string;
		TOBArt,TOBDM : TOB;
    NewArt : boolean;
    QQ : TQuery;
begin
	if TOBL.NomTable = 'LIGNE' then
  begin
  	preFixe := 'GL';
  end else
  begin
  	preFixe := 'BOP';
  end;
  //
  TOBDM := TOB.Create ('LIGNE MINUTE',TOBMinute,-1);
  AddlesChamps(TOBDM);
  newArt := false;
  TOBART := TOBArticles.findFirst(['GA_ARTICLE'], [TOBL.GetValue(prefixe+'_ARTICLE')],true);
  if TOBART = Nil then
  begin
  	TOBART := TOB.Create('ARTICLE',nil,-1);
    QQ := OpenSQl('SELECT GA_QUALIFUNITEVTE, GA_FAMILLENIV1,GA_FAMILLENIV2,GA_FAMILLENIV3 FROM ARTICLE WHERE GA_ARTICLE="'+
                 TOBL.GetValue(prefixe+'_ARTICLE')+'"',true,1,'',true);
    if not QQ.eof then
    begin
    	TOBART.SelectDB('',QQ);
    end;
    newArt := true;
  end;

  if NiveauImbric > 1 then
  begin
    TOBDM.PutValue('BMN_PARAG',LibP1);
    TOBDM.PutValue('BMN_SPARAG',LIBP2);
  end else if NiveauImbric > 0 then
  begin
    TOBDM.PutValue('BMN_PARAG',LibP1);
    TOBDM.PutValue('BMN_SPARAG','  0 : Hors paragraphe');
  end else
  begin
    TOBDM.PutValue('BMN_PARAG','  0 : Hors paragraphe');
    TOBDM.PutValue('BMN_SPARAG','  0 : Hors paragraphe');
  end;
	TOBDM.PutValue('BMN_CATEGORIE','MAR');
	TOBDM.PutValue('BMN_NATURE','Fournitures');
	TOBDM.PutValue('BMN_FAMILLE1',rechdom('GCFAMILLENIV1',TOBArt.getValue('GA_FAMILLENIV1'),false)); // Famille de niveau 1
	TOBDM.PutValue('BMN_FAMILLE2',rechdom('GCFAMILLENIV2',TOBArt.getValue('GA_FAMILLENIV2'),false)); // Famille de niveau 1
	TOBDM.PutValue('BMN_FAMILLE3',rechdom('GCFAMILLENIV3',TOBArt.getValue('GA_FAMILLENIV3'),false)); // Famille de niveau 1
  if TOBOUV <> nil then
  begin
		TOBDM.PutValue('BMN_OUVRAGE',TOBOUV.GetValue('GL_CODEARTICLE')+' - '+TOBOUV.GetValue('GL_LIBELLE')+
                                                 ' : '+FloatToStr(TOBOUV.GetValue('GL_QTEFACT'))+
                                                 ' '+TOBOUV.GetValue('GL_QUALIFQTEVTE')); // Code ouvrage + libelle + qté + unité
	  TOBDM.PutValue('BMN_QTEOUV',TOBOUV.GetValue('GL_QTEFACT')); // Qte ouvrage
	  TOBDM.PutValue('BMN_UNITEOUV',TOBOUV.GetValue('GL_QUALIFQTEVTE')); // Unité ouvrage
    if TOBOUV.GetValue('GL_QTEFACT') <> 0 then
	    TOBDM.PutValue('BMN_QTE',(TOBL.GetValue(prefixe+'_QTEFACT')/TOBOUV.GetValue('GL_QTEFACT'))); // Qte Unitaire
  end else
  begin
  	TOBDM.PutValue('BMN_OUVRAGE','Hors ouvrage');
	  TOBDM.PutValue('BMN_QTE',TOBL.GetValue(prefixe+'_QTEFACT')); // Qte Unitaire
  end;
	TOBDM.PutValue('BMN_ARTICLE',TOBL.GetValue(prefixe+'_CODEARTICLE')+' : '+TOBL.GetValue(prefixe+'_LIBELLE')); // Code article
	TOBDM.PutValue('BMN_QTEACH',TOBL.GetValue(prefixe+'_QTEFACT')); // Qte marchandise
  // modif brl 30/03/2011 :
  // en attendant l'ajout du champ BOP_QUALIFQTEVTE manquant dans la table LIGNEOUVPLAT
  // on prend l'unité de vente dans la table ARTICLE
  if prefixe = 'BOP' then TOBDM.PutValue('BMN_UNITEACH',TOBArt.GetValue('GA_QUALIFUNITEVTE'))else // Unite marchandise
                          TOBDM.PutValue('BMN_UNITEACH',TOBL.GetValue(prefixe+'_QUALIFQTEVTE')); // Unite marchandise
	TOBDM.PutValue('BMN_PAACH',TOBL.GetValue(prefixe+'_DPA')); // Pa marchandise
	TOBDM.PutValue('BMN_MTACH',TOBL.GetValue(prefixe+'_MONTANTPA')); // Pa marchandise
	TOBDM.PutValue('BMN_QTEHRS',0); // Qte MO
	TOBDM.PutValue('BMN_UNITEHRS',''); // Unite MO
	TOBDM.PutValue('BMN_PAHRS',0); // PA MO
	TOBDM.PutValue('BMN_MTHRS',0); // Mt MO
	TOBDM.PutValue('BMN_PUV',TOBL.GetValue(prefixe+'_PUHTDEV')); // Pu Vente
	TOBDM.PutValue('BMN_MTPUV',TOBL.GetValue(prefixe+'_MONTANTHTDEV')); // Montant PV
	TOBDM.PutValue('BMN_PR',TOBL.GetValue(prefixe+'_DPR')); // Pu Revient
	TOBDM.PutValue('BMN_MTPR',TOBL.GetValue(prefixe+'_MONTANTPR')); // Montant revient
  if TOBOUV <> nil then
  begin
		TOBDM.PutValue('BMN_LIGNE',TOBOUV.GetValue('GL_NUMLIGNE')); // Montant PV
  end else
  begin
		TOBDM.PutValue('BMN_LIGNE',TOBL.GetValue('GL_NUMLIGNE')); // Montant PV
  end;
  if NewArt then TOBArt.free;
end;

procedure AddOuvragePlat (TOBminute,TOBPiece,TOBTiers,TOBL,TOBOuvrages,TOBOuvragesP,TOBArticles: TOB;Niv: integer; LibP1,LibP2 : string; DEV : Rdevise);
var TOBPlat,TOBOL : TOB;
		Indice,ITypeArt : integer;
begin
  TOBPLat := AddMereLignePlat (TOBOuvragesP,TOBL.GetValue('GL_NUMORDRE'));
  GetOuvragePlat (TOBpiece,TOBL,TOBOuvrages,TOBPlat,TOBTiers,DEV,False);
  for Indice := 0 to TOBPLat.detail.count -1 do
  begin
    TOBOL := TOBPlat.detail[Indice];
    if TOBPiece.GetValue('GP_FACTUREHT')='X' then CalculeLigneHT (TOBOL,nil,TOBPiece,DEV,DEV.decimale)
                                             else CalculeLigneTTC (TOBOL,nil,TOBPiece,DEV,DEV.decimale);
  	if Indice = 0 then
    begin
    	ITypeArt := TOBOL.GetNumChamp('BOP_TYPEARTICLE');
    end;
    if TOBOL.GetValeur(ITypeArt)='PRE' then
    begin
      AddLignePrestation (TOBMinute,TOBL,TOBOL,TOBArticles,Niv,LibP1,LibP2);
    end else
    begin
      AddLigneMarchandise (TOBMinute,TOBL,TOBOL,TOBArticles,Niv,LibP1,LibP2);
    end;
  end;
end;

procedure ConstitueLaMinute (TOBMinute,TOBPiece,TOBTiers,TOBOUvrages,TOBOuvragesP,TOBArticles : TOB; DEV : Rdevise);

  function ConstitueNumPararag ( NumP1,Nump2 : integer) : string;
  begin
    Result := Format('%3d',[Nump1]);
    if Nump2 > 0 then Result := result + '.'+Format('%3d',[Nump2]);
  end;

var indice : integer;
		TOBL : TOB;
    I1,I2,Niv : integer;
    LibP1,libP2 : string;
    ITypeLigne,ITypeArt,ILibelle,IImbric : integer;
begin
	I1 := 0;
	I2 := 0;
  ITypeLigne := -1;
  ITypeArt := -1;
  ILibelle := -1;
	for Indice := 0 to TOBpiece.detail.count -1 do
  begin
  	TOBL := TOBPiece.detail[Indice];
  	if Indice = 0 then
    begin
    	ITypeLigne := TOBL.GetNumChamp('GL_TYPELIGNE');
    	ITypeArt := TOBL.GetNumChamp('GL_TYPEARTICLE');
    	ILibelle := TOBL.GetNumChamp('GL_LIBELLE');
    	IImbric := TOBL.GetNumChamp('GL_NIVEAUIMBRIC');
    end;
    //
    Niv := TOBL.GetValeur(IImbric);
    //
    if (TOBL.GetValeur(ITypeLigne)<>'ART') AND (Pos(copy(TOBL.GetValeur(ITypeLigne),1,2),'DP;DV;TP;TV')=0) then continue;
    if Pos(copy(TOBL.GetValeur(ITypeLigne),1,2),'DP;DV')>0 then // Début de paragraphe
    begin
    	if StrToInt(copy(TOBL.GetValeur(ITypeLigne),3,1))>2 then continue;
      //
    	if StrToInt(copy(TOBL.GetValeur(ITypeLigne),3,1))=2 then
      begin
      	Inc(I2); LibP2 := ConstitueNumPararag (I1,I2) +' : ' +TOBL.GetValeur(ILibelle);

      end else if StrToInt(copy(TOBL.GetValeur(ITypeLigne),3,1))=1 then
      begin
      	Inc(I1); LibP1 := ConstitueNumPararag (I1,0) +' : ' +TOBL.GetValeur(ILibelle);
        I2 := 0; LibP2 := '';
      end;
    end else if Pos(copy(TOBL.GetValeur(ITypeLigne),1,2),'TP;TV')>0 then // Fin de paragraphe
    begin
    	if StrToInt(copy(TOBL.GetValeur(ITypeLigne),3,1))>2 then continue;
      //
    	if StrToInt(copy(TOBL.GetValeur(ITypeLigne),3,1))=2 then
      begin
      	LibP2 := '';
      end else if StrToInt(copy(TOBL.GetValeur(ITypeLigne),3,1))=1 then
      begin
      	LibP1 := '';
      end;
    end else if  Pos(TOBL.GetValeur(ITypeArt),'OUV;ARP')>0 then // ouvrage ou article en prix posés
    begin
    	AddOuvragePlat (TOBminute,TOBPiece,TOBTiers,TOBL,TOBOuvrages,TOBOuvragesP,TOBArticles,Niv,LibP1,LibP2,DEV);
    end else if TOBL.GetValeur(ITypeArt)='PRE' then
    begin
      AddLignePrestation (TOBMinute,nil,TOBL,TOBArticles,Niv,LibP1,LibP2);
    end else
    begin
      AddLigneMarchandise (TOBMinute,nil,TOBL,TOBArticles,Niv,LibP1,LibP2);
    end;
  end;
end;

procedure LanceMinuteDevis(TOBPiece,TOBTiers,TOBOuvrages,TOBOuvragesP,TOBARTicles : TOB; DEV : RDEVISE);
var Titre : string;
begin
 	TOBMinute := TOB.Create ('LA MINUTE',nil,-1);
  TOBOUVPP := TOB.Create ('LES OV PLATS',nil,-1);
  TRY
  	ConstitueLaMinute (TOBMinute,TOBPiece,TOBTiers,TOBOUvrages,TOBOuvPP,TOBArticles,DEV);
    titre := 'LIBELLE=Minute '+
    				 rechdom('GCNATUREPIECEG',TOBpiece.getValue('GP_NATUREPIECEG'),false)+
             ' N° '+Inttostr(TOBPiece.getValue('GP_NUMERO'))+ ' - Client : '+ TOBPiece.getValue('GP_TIERS')+' '+TOBTiers.getValue('T_LIBELLE') ;
    V_PGI.AutoSearch := true;
    AGLLanceFiche('BTP','BTMINUTEDEVIS','','',Titre);
    V_PGI.AutoSearch := false;
  FINALLY
  	TOBMinute.free;
    TOBOUVPP.free;
  END;
end;

procedure TOF_BTMINUTEDEV.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTMINUTEDEV.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTMINUTEDEV.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_BTMINUTEDEV.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTMINUTEDEV.OnArgument (S : String ) ;
var St1 : String;
begin
  Inherited ;
	st1 := Copy(S, 0, Pos('=',S) - 1);
  if st1 = 'LIBELLE' then
  begin
    st1 := Copy(S, Pos('=',S) + 1, 255);
    ecran.Caption := st1;
  end;
  TFStat (Ecran).LaTOB := TOBminute;

end ;

procedure TOF_BTMINUTEDEV.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BTMINUTEDEV.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTMINUTEDEV.OnCancel () ;
begin
  Inherited ;
end ;

Initialization
  registerclasses ( [ TOF_BTMINUTEDEV ] ) ; 
end.
