{***********UNITE*************************************************
Auteur  ...... : SBO
Cr�� le ...... : 25/11/2005
Modifi� le ... : 25/11/2005
Description .. : Source TOF de la FICHE : VALSIMU
Mots clefs ... : TOF;VALSIMU
*****************************************************************}
Unit CPVALSIMU_TOF;

Interface

Uses StdCtrls, Controls, Classes,
{$IFDEF EAGLCLIENT}
     MaineAGL, eMul,
{$ELSE}
     FE_Main, db, dbtables, mul, HDB,
{$ENDIF}
     forms, sysutils, ComCtrls, HCtrls, HEnt1, HMsgBox, UTOF, HTB97,
     utilPGI, SAISUTIL, Ent1, ED_Tools, SaisComm, Saisie, TiersPayeur, LettUtil, HStatus, DelVisuE,
     uTob,
     uLibAnalytique,
     uLibEcriture,
     ParamSoc,		// GetParamSocSecur YMO
     UtilSais          //    MajSoldesEcritureTOB 
     ;

procedure CPLanceFiche_ValidePiece(vStRange, vStLequel, vStArgs : string);

Type
  TOF_VALSIMU = Class (TOF)
    procedure OnNew                   ; override;
    procedure OnDelete                ; override;
    procedure OnUpdate                ; override;
    procedure OnLoad                  ; override;
    procedure OnArgument (S : String ); override;
    procedure OnDisplay               ; override;
    procedure OnClose                 ; override;
    procedure OnCancel                ; override;
  private

    // Indicateurs
    NowFutur         : TDateTime;       // Date/Heure de modif pour les pi�ces
    FPiecesGener     : TList;           // Liste des pi�ces g�n�r�es
    FPiecesErr       : TList;           // Liste des pi�ces refus�es
    Messages         : TStringList;     // Liste des messages

    // Composants
    E_EXERCICE       : THValComboBox;
    E_DATECOMPTABLE  : THEdit;
    E_DATECOMPTABLE_ : THEdit;
    E_QUALIFPIECE    : THValComboBox;

    QualifGener      : THValComboBox;
    CChoixDate       : TCheckBox;
    DateGeneration   : THEdit;

    {$IFDEF EAGLCLIENT}
      FListe         : THGrid;
    {$ELSE}
      FListe         : THDBGrid;
    {$ENDIF}

    // initialisation
    procedure InitComposants ;
    procedure InitEvenements ;
    procedure InitMessages;
    procedure InitVariables;
    procedure InitPresentation;

    // Fonctions de tests
    function  DateGeneOk : boolean;
    function  AfficheMessage ( vInErr : Integer ) : word ;

    // Traitements
    function  ValideSelection : boolean;
    procedure ValideLaPiece;

    procedure TraiteTPVal;

    // Ev�nements de composants
    procedure FListeDblClick     ( Sender : TObject ) ;
    procedure BOuvrirClick       ( Sender : TObject ) ;
    procedure BZoomPieceClick    ( Sender : TObject ) ;
    procedure CChoixDateClick    ( Sender : TObject ) ;
    procedure ExerciceChange   ( Sender : TObject ) ;
    procedure QualifPieceChange   ( Sender : TObject ) ;
    procedure AuxiElipsisClick(Sender : TObject);
  end;


function CTransformerPiece( vStOrig, vStDest : String ; vTobEcr : TOB ; vBoMajTob : Boolean ; vBoDateForce : Boolean = False ; vDtDateC : TDateTime = 0 ) : Boolean ;

Implementation

uses
    {$IFDEF eAGLCLIENT}
    MenuOLX
    {$ELSE}
    MenuOLG
    {$ENDIF eAGLCLIENT}
    , UTofMulParamGen; {26/04/07 YMO F5 sur Auxiliaire }



/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure CPLanceFiche_ValidePiece(vStRange, vStLequel, vStArgs : string);
begin

  if _Blocage(['nrCloture','nrBatch','nrSaisieModif'],False,'nrBatch') then Exit ;

  AGLLanceFiche ('CP','CPVALSIMU', vStRange, vStLequel, vStArgs );

end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
function CTransformerPiece( vStOrig, vStDest : String ; vTobEcr : TOB ; vBoMajTob : Boolean ; vBoDateForce : Boolean ; vDtDateC : TDateTime ) : Boolean ;
Var lTOBPiece  : TOB ;          // Tob de la pi�ce
    lTOBEcr    : TOB ;          // Tob sur ligne d'�criture
    lTOBVentil : TOB ;          // Tob sur ligne d'analytique
    lQEcr      : TQuery ;       // req de chargement de la pi�ce
    lStReq     : String ;       // requ�tes
    lNumPiece  : integer ;      // Num�ro de pi�ce
    lNumL      : integer ;      // Num�ro de ligne
    lNumV      : integer ;      // Num�ro d'axe
    lNumA      : integer ;      // Num�ro de ventilation
    lInNbEnreg : LongInt ;      // Nb d'enregistrement
    lStTrSyn   : String ;       // TR synchro
    lDtModif   : TDateTime ;    // Date / Heure de modif
    lInErr     : Integer ;
    lStRef     : String ;
begin

  Result := False ;

  if vTobEcr = nil then Exit ;

  // ================================
  // ==== Chargement de la pi�ce ====
  // ================================
  lTOBPiece := TOB.Create('',Nil,-1) ;
  lQEcr     := OpenSQL('SELECT * FROM ECRITURE WHERE ' + WhereEcritureTob( tsGene, vTobEcr, False ) , True ) ;
  lTOBPiece.LoadDetailDB('ECRITURE','','', lQEcr, False ) ;
  Ferme(lQEcr) ;
  if lTOBPiece.Detail.Count <= 0 then
    begin
    lTOBPiece.Free ;
    Exit ;
    end ;
  ChargeAnalytique( lTOBPiece ) ;

  // ====================================================
  // ==== D�termination des param�tres de g�n�ration ====
  // ====================================================
  // >> Date comptable
  if not vBoDateForce
    then vDtDateC := lTOBPiece.Detail[0].GetDateTime('E_DATECOMPTABLE') ;
  // Test de la date
  lInErr := DateCorrecte( vDtdateC );
  if lInErr > 0 then
    begin
    Case lInErr of
      1 : vTobEcr.PutValue( 'E_REFLIBRE', Copy( 'Date sur exercice non ouvert', 1, 35 ) ) ;
      2 : vTobEcr.PutValue( 'E_REFLIBRE', Copy( 'Date sur exercice non ouvert', 1, 35 ) ) ;
      3 : vTobEcr.PutValue( 'E_REFLIBRE', Copy( 'Date ant�rieure � cl�ture provisoire', 1, 35 ) ) ;
      4 : vTobEcr.PutValue( 'E_REFLIBRE', Copy( 'Date ant�rieure � cl�ture d�finitive', 1, 35 ) ) ;
      end ;
    lTOBPiece.Free ;
    Exit;
    end ;
  // >> Date / Heure de modif
  lDtModif := NowH ;
  // >> d�termination du num�ro de pi�ce pour le passage en �critures normales
  if vStDest = 'N' then
    begin
    lNumPiece := GetNewNumJal( lTOBPiece.Detail[0].GetValue('E_JOURNAL'), True, vDtDateC ) ;
    if lNumPiece <= 0 then
      begin
      lTOBPiece.Free ;
      Exit ;
      end ;
    end
  else
    lNumPiece := lTOBPiece.Detail[0].GetValue('E_NUMEROPIECE') ;

  // D�termination de la r�f�rence libre
  lStRef := 'Pi�ce de ' + RechDom( 'TTQUALIFPIECE', vStOrig, False ) + ' N� ' + lTOBPiece.Detail[0].GetValue('E_NUMEROPIECE') ;

  // ========================================
  // ==== PARCOURS DES LIGNES D'ECRITURE ====
  // ========================================
  for lNumL := 0 to ( lTOBPiece.Detail.Count - 1 ) do
    begin
    lTobEcr := lTobPiece.Detail[lNumL] ;

    // >> D�termination du TRSYNCHRO pour chaque ligne...
    lStTrSyn := 'RIE';
    if EstComptaTreso and EstCptSyn( lTobEcr.GetString('E_GENERAL'),
                                     lTobEcr.GetString('E_JOURNAL'),
                                     lTobEcr.GetString('E_NATUREPIECE') <> 'ECC')
      then lStTrSyn := 'CRE';

    // ========================================
    // ==== MAJ base des lignes d'�criture ====
    // ========================================
    // >> Ecritures
    lStReq := 'UPDATE ECRITURE SET ' + 'E_QUALIFPIECE="'    + vStDest                         + '", '
                                     + 'E_DATEMODIF="'      + UsTime( lDtModif )              + '", '
                                     + 'E_DATECOMPTABLE="'  + UsDatetime( vDtDateC )          + '", '
                                     + 'E_PERIODE='         + IntToStr( GetPeriode(vDtDateC) )+ ', '
                                     + 'E_SEMAINE='         + IntToStr( NumSemaine(vDtDateC) )+ ', '
                                     + 'E_QUALIFORIGINE="'  + vStOrig                         + '" ' ;
    if vStDest = 'N' then
      lStReq := lStReq               + ', E_NUMEROPIECE='   + IntToStr( lNumPiece )
                                     + ', E_TRESOSYNCHRO="' + lStTrSyn                        + '"' ;
    lStReq := lStReq + ' WHERE ' + WhereEcritureTob( tsGene, lTobEcr ,True ) ;

    lInNbEnreg := ExecuteSQL ( lStReq ) ;
    Result := lInNbEnreg > 0 ;
    // >> Analytique
    if Result then
      begin
      lStReq := 'UPDATE ANALYTIQ SET ' + 'Y_QUALIFPIECE="'    + vStDest                         + '", '
                                       + 'Y_DATEMODIF="'      + UsTime( lDtModif )              + '", '
                                       + 'Y_DATECOMPTABLE="'  + UsDatetime( vDtDateC )            + '", '
                                       + 'Y_PERIODE='         + IntToStr( GetPeriode(vDtDateC) )  + ', '
                                       + 'Y_SEMAINE='         + IntToStr( NumSemaine(vDtDateC) ) ;
      if vStDest = 'N' then
        lStReq := lStReq + ', Y_NUMEROPIECE='   + IntToStr( lNumPiece )           + ', ' ;
      lStReq := lStReq + ' WHERE ' + WhereEcritureTob( tsAnal, lTobEcr ,True ) ;

      ExecuteSQL ( lStReq ) ;
      end ;

    // ======================
    // ==== MAJ des Tobs ====
    // ======================
    lTobEcr.PutValue('E_QUALIFPIECE',   vStDest   ) ;
    lTobEcr.PutValue('E_DATECOMPTABLE', vDtDateC  ) ;
    lTobEcr.PutValue('E_QUALIFORIGINE', vStOrig   ) ;
    lTobEcr.Putvalue('E_DATEMODIF',     lDtModif  ) ;
    lTobEcr.PutValue('E_REFLIBRE',      lStRef    ) ;
    if vStDest = 'N' then
      begin
      lTobEcr.PutValue('E_NUMEROPIECE',   lNumPiece ) ;
      lTobEcr.PutValue('E_TRSYNCHRO',     lStTrSyn  ) ;
      end ;

    // Parcours des lignes d'analytiques
    for lNumA := 0 to lTobEcr.Detail.Count - 1 do
      for lNumV := 0 to lTobEcr.Detail[ lNumA ].Detail.Count - 1 do
        begin
        lTobVentil := lTobEcr.Detail[ lNumA ].Detail[ lNumV ] ;
        lTobVentil.PutValue('Y_QUALIFPIECE',   vStDest   ) ;
        lTobVentil.PutValue('Y_DATECOMPTABLE', vDtDateC  ) ;
        lTobVentil.Putvalue('Y_DATEMODIF',     lDtModif  ) ;
        if vStDest = 'N' then
          lTobVentil.PutValue('Y_NUMEROPIECE', lNumPiece ) ;
        end ;

    end ;


  // ====================================
  // ==== MAJ des soldes des comptes ====
  // ====================================
  if vStDest = 'N' then
    MajSoldesEcritureTOB( lTOBPiece, True ) ;

  // ======================================
  // ==== MAJ TOB param�tre si demand� ====
  // ======================================
  if vBoMajTOB then
    begin
    vTobEcr.PutValue('E_QUALIFPIECE',   vStDest   ) ;
    vTobEcr.PutValue('E_DATECOMPTABLE', vDtDateC  ) ;
    vTobEcr.PutValue('E_QUALIFORIGINE', vStOrig   ) ;
    vTobEcr.Putvalue('E_DATEMODIF',     lDtModif  ) ;
    vTobEcr.PutValue('E_REFLIBRE',      lStRef    ) ;
    if vStDest = 'N' then
      begin
      vTobEcr.PutValue('E_NUMEROPIECE',   lNumPiece ) ;
      vTobEcr.PutValue('E_TRSYNCHRO',     lStTrSyn  ) ;
      end ;
    end ;

  // Lib�ration
  lTobPiece.ClearDetail ;
  lTobPiece.Free ;

end ;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.OnNew;
begin
  Inherited;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.OnDelete;
begin
  Inherited;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.OnUpdate;
begin
  Inherited;

{$IFDEF EAGLCLIENT}
  GereSelectionsGrid(FListe,TFMul(Ecran).Q.TQ);
{$ELSE}
  GereSelectionsGrid(FListe,TFMul(Ecran).Q);
{$ENDIF}
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.OnLoad;
begin
  Inherited;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.OnArgument (S : String );
begin

  Inherited;

  // Param�tres de lancement = Type de pi�ces cibl�es
  SetControlText('E_QUALIFPIECE', 'S');

  // composants
  InitComposants ;
  InitEvenements ;
  InitMessages;
  InitVariables;
  InitPresentation ;

  // Recherche au lancement
  TFMul(Ecran).BChercheClick(nil);

  {JP 18/11/04 : Dans ValidSim c'est inf�rieur et ici �gal, ce qui fait que le mul ne me renvoie
                 aucune requ�te}
  THEdit(GetControl('E_NUMECHE')).Operateur := Inferieur

  if GetParamSocSecur('SO_CPMULTIERS', false) then
    THEdit(GetControl('E_AUXILIAIRE', true)).OnElipsisClick:=AuxiElipsisClick;

end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.OnClose;
begin
  Inherited;
  _Bloqueur('nrBatch',False);

  // Lib�ration m�moire
  VideListe(  FPiecesGener );
  FreeAndNil( FPiecesGener ) ;

  VideListe(  FPiecesErr );
  FreeAndNil( FPiecesErr ) ;

  FreeAndNil( Messages ) ;

end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.OnDisplay ();
begin
  Inherited;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.OnCancel ();
begin
  Inherited;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.ExerciceChange(Sender: TObject);
begin
  ExoToDates( E_EXERCICE.Value, E_DATECOMPTABLE, E_DATECOMPTABLE_ );
end;

{***********A.G.L.***********************************************
Auteur  ...... : YMO
Cr�� le ...... : 26/04/2007
Modifi� le ... :   /  /
Description .. : Branchement de la fiche auxiliaire
Mots clefs ... :
*****************************************************************}
procedure TOF_CPVALIDEPIECE.AuxiElipsisClick( Sender : TObject );
begin
     THEdit(Sender).text:= CPLanceFiche_MULTiers('M;' +THEdit(Sender).text + ';' +THEdit(Sender).Plus + ';');
end;


/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.FListeDblClick(Sender: TObject);
begin
  BZoomPieceClick(Nil);
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.BOuvrirClick(Sender: TObject);
begin

  if Not DateGeneOk then Exit ;

  if ValideSelection then
    TFMul(Ecran).BChercheClick(Sender);
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.InitMessages;
begin
  Messages := TStringList.Create ;
  with Messages do
    begin
    Add('0;?caption?;Confirmez-vous la transformation en �critures courantes ?;Q;YN;N;N;');
    Add('1;?caption?;Vous n''avez s�lectionn� aucune �criture.;E;O;O;O;');
    Add('2;LIBRE;LIBRE');
    Add('3;LIBRE;LIBRE');
    Add('4;LIBRE;LIBRE;');
    Add('5;LIBRE;LIBRE;');
    Add('6;?caption?;Voulez-vous voir la liste des �critures courantes g�n�r�es ?;Q;YN;N;N;');
    Add('7;LIBRE;LIBRE;LIBRE;LIBRE;');
    Add('Pi�ce de simulation N�');
    Add('Date sur exercice non ouvert');
    Add('Date sur exercice non ouvert');
    Add('Date ant�rieure � cl�ture provisoire');
    Add('Date ant�rieure � cl�ture d�finitive');
    Add('Validation impossible. Certaines �critures ont �t� modifi�es par un autre utilisateur.');
    Add('Validation non effectu�e.');
    Add('Pi�ce de r�vision N�');
    Add('16;?caption?;La date que vous avez renseign�e n''est pas valide.;W;O;O;O;');
    Add('17;?caption?;La date que vous avez renseign�e n''est pas dans un exercice ouvert.;W;O;O;O;');
    Add('18;?caption?;La date que vous avez renseign�e est ant�rieure � une cl�ture.;W;O;O;O;');
    Add('19;?caption?;La date que vous avez renseign�e est ant�rieure � une cl�ture.;W;O;O;O;');
    Add('20;?caption?;La date que vous avez renseign�e est en dehors des limites autoris�es.;W;O;O;O;');
    Add('Validation des �critures de r�vision en �critures courantes');
    Add('22;');
    end;

end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.BZoomPieceClick(Sender: TObject);
begin
{$IFDEF EAGLCLIENT}
  TFMul(Ecran).Q.TQ.Seek(FListe.Row-1);
  TrouveEtLanceSaisie( TFMul(Ecran).Q.TQ, taConsult, GetControlText('E_QUALIFPIECE') ) ;
{$ELSE}
  TrouveEtLanceSaisie( TFMul(Ecran).Q,    taConsult, GetControlText('E_QUALIFPIECE') ) ;
{$ENDIF}
end;


/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.ValideLaPiece;
var  lQEcr    : TQuery ;
     lStReq   : String ;
     lDtDateC : TDateTime ;
     lTobEcr  : TOB ;
begin

  lStReq :=  'SELECT * FROM ECRITURE WHERE '
                 + 'E_JOURNAL="'       + GetField('E_JOURNAL')                       + '" AND '
                 + 'E_EXERCICE="'      + QuelExoDT( GetField('E_DATECOMPTABLE') )    + '" AND '
                 + 'E_DATECOMPTABLE="' + USDATETIME( GetField('E_DATECOMPTABLE') )   + '" AND '
                 + 'E_NUMEROPIECE='    + IntToStr( GetField('E_NUMEROPIECE') )       + ' AND '
                 + 'E_QUALIFPIECE="'   + GetControlText('E_QUALIFPIECE')             + '" AND '
                 + 'E_NUMLIGNE=1 AND E_NUMECHE<2' ;

  lQEcr   := OpenSQL ( lStReq, True ) ;
  if lQEcr.Eof then
    begin
    Ferme( lQEcr ) ;
    Exit ;
    end ;

  lTobEcr := Tob.Create('ECRITURE', nil, -1) ;
  lTobEcr.SelectDB( '', lQEcr ) ;
  Ferme( lQEcr ) ;

  if CChoixDate.Checked
    then lDtDateC := StrToDate( DATEGENERATION.Text )
    else lDtDateC := iDate1900 ;

  if CTransformerPiece( E_QUALIFPIECE.Value, QualifGener.Value, lTobEcr, True, CChoixDate.Checked, lDtDateC )
    then FPiecesErr.Add( lTobEcr )
    else FPiecesGener.Add( lTobEcr ) ;

end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.TraiteTPVal;
var i  : integer;
    O  : TOBM;
    MM : RMVT;
begin
  for i:=0 to FPiecesGener.Count-1 do
    begin
    // Recup TOB
    O  := TOBM( FPiecesGener[i] );
    // Transformation en RMVT
    MM := OBMToIdent(O,False);
    // G�n�ration des Pi�ces sur les TP
    GenerePiecesPayeur(MM);
    end;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
function TOF_CPVALIDEPIECE.ValideSelection: boolean;
var i     : integer ;
    NbD   : integer ;
    io    : TIOErr ;
    Okok  : boolean ;
    Q     : TQuery;
begin

  VideListe(  FPiecesGener );
  VideListe(  FPiecesErr );

  NowFutur := NowH ;
  Result   := False ;

{$IFDEF EAGLCLIENT}
  Q := TFMul(Ecran).Q.TQ;
{$ELSE}
  Q := TFMul(Ecran).Q;
{$ENDIF}

  if FListe.AllSelected then
    begin
    if ((Q.EOF) and (Q.BOF)) then
      begin
      AfficheMessage(1) ;
      Exit;
      end;

    NbD := 100;
    end
  else
    begin
    NbD := FListe.NbSelected;
    if NbD<=0 then
      begin
      AfficheMessage(1);
      Exit;
      end;
    end;

  if AfficheMessage(0) <> mrYes then
    begin
    FListe.ClearSelected;
    FListe.AllSelected := False;
    Exit;
    end;

  Okok := True;
  InitMove(NbD,'');

  if FListe.AllSelected then
    begin
    Q.First;
    while Not Q.EOF do
      begin
      MoveCur(False) ;
      if RevisionActive(Q.FindField('E_DATECOMPTABLE').AsDateTime) then
        begin
        Okok := False;
        Break;
        end;
      Q.Next ;
      end;
    end
  else
    begin
    for i:=0 to NbD-1 do
      begin
      FListe.GotoLeBookMark(i);
      MoveCur(FALSE);
      if RevisionActive( Q.FindField('E_DATECOMPTABLE').AsDateTime ) then
        begin
        Okok := False;
        Break;
        end;
      end;
    end;

  FiniMove;

  if not Okok then Exit;

  InitMove(NbD,'');

  if FListe.AllSelected then
    begin
    Q.First ;
    While Not Q.EOF do
      begin
      MoveCur(FALSE) ;
      io:=Transactions(ValideLaPiece,3) ;
      Case io of
        oeOk : ;
        oeSaisie :  begin MessageAlerte(Messages[13]); FiniMove; Exit; end;
        oeUnknown : begin MessageAlerte(Messages[14]); FiniMove; Exit; end;
        end;
      Q.Next ;
      end;
    end
  else
    begin
    for i:=0 to NbD-1 do
      begin
      Fliste.GotoLeBookMark(i);
      MoveCur(FALSE);
      io := Transactions(ValideLaPiece,5);
      Case io of
        oeOk : ;
        oeSaisie  : begin MessageAlerte(Messages[13]); FiniMove; Exit; end;
        oeUnknown : begin MessageAlerte(Messages[14]); FiniMove; Exit; end;
        end;
      end;
    end;

  FListe.ClearSelected;
  FListe.AllSelected := False;
  FiniMove;

  Result:=True;

  if FPiecesGener.Count>0 then
    begin
    if VH^.OuiTP then
      TraiteTPVal;
    VisuPiecesGenere( FPiecesGener, EcrGen, 1 ) ;
    end;

  if FPiecesErr.Count>0 then
    VisuPiecesGenere( FPiecesErr, EcrGen, 2 ) ;

end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
function TOF_CPVALIDEPIECE.DateGeneOk: boolean;
var Err : integer;
begin

  Result         := True;

  if ( ( DATEGENERATION.Text=StDate1900 ) or (DATEGENERATION.Text='') or (Not CChoixDate.Checked)) then Exit;

  Result         := False;

  // Contr�le la date saisie
  Err            := ControleDate( DATEGENERATION.Text );
  if Err>0 then
    begin
    AfficheMessage( 15 + Err ) ;
    DATEGENERATION.Text := StDate1900;
    Exit;
    end;

  // Test si mode de r�visin est actif pour la date saisie
  if RevisionActive( StrToDate( DATEGENERATION.Text ) ) then
    begin
    DATEGENERATION.Text := StDate1900;
    Exit;
    end;

  Result         := True;

end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.CChoixDateClick(Sender: TObject);
begin
  if CChoixDate.Checked then
    begin
    DateGeneration.Enabled := True ;
    if ( DateGeneration.Text = StDate1900 ) then
      DateGeneration.Text := DateToStr( V_PGI.DateEntree );
    end
  else
    begin
    DateGeneration.Text    := StDate1900;
    DateGeneration.Enabled := False;
    end ;
end;


procedure TOF_CPVALIDEPIECE.InitComposants ;
begin
  // R�cup�ration des contr�les
  E_EXERCICE         := THValComboBox( GetControl('E_EXERCICE', True)       );
  E_DATECOMPTABLE    := THEdit(        GetControl('E_DATECOMPTABLE', True)  );
  E_DATECOMPTABLE_   := THEdit(        GetControl('E_DATECOMPTABLE_', True) );
  DATEGENERATION     := THEdit(        GetControl('DATEGENERATION', True)   );
  CChoixDate         := TCheckBox(     GetControl('CCHOIXDATE', True)       );
  QualifGener        := THValComboBox( GetControl('QUALIFGENER', True)      );

  FListe             := TFMul(Ecran).FListe;

end ;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TOF_CPVALIDEPIECE.InitEvenements;
begin
  // Ev�nements sur les boutons
  TToolBarButton97( GetControl('BZOOMPIECE', True) ).OnClick := BZoomPieceClick ;
  TCheckBox(        GetControl('CCHOIXDATE', True) ).OnClick := CChoixDateClick ;
  TToolbarButton97( GetControl('BOUVRIR', true)    ).OnClick := BOuvrirClick    ;

  // Ev�nements sur les crit�res de recherche
  E_EXERCICE.OnChange           := EXERCICEChange    ;
  E_QUALIFPIECE.OnChange        := QualifPieceChange ;

  // Ev�nements sur la liste
  FListe.OnDblClick             := FListeDblClick     ;

end;

procedure TOF_CPVALIDEPIECE.InitPresentation;
begin

  DATEGENERATION.Text   := stDate1900;

  // Dates comptables
  E_DATECOMPTABLE.Text  := StDate1900;
  E_DATECOMPTABLE_.Text := StDate2099;

  // Exercice (entra�ne normalement la maj des dates...)
  if VH^.Suivant.Code<>''
    then E_EXERCICE.Value := VH^.Suivant.Code
    else E_EXERCICE.Value := VH^.Encours.Code;

  // Dates d'�ch�ances
  SetControlText('E_DATEECHEANCE',  StDate1900 );
  SetControlText('E_DATEECHEANCE_', StDate2099 );

  // 1er Journal
  SetControlProperty('E_JOURNAL', 'ITEMINDEX', 0 ) ;

  // Etablissement
  PositionneEtabUser(GetControl('E_ETABLISSEMENT', True));

  // Titre et HelpContext en fonction du mode
{ En plus
  if GetControlText('E_QUALIFPIECE') = 'R' then
    begin
    Ecran.Caption := HM.Mess[21];
    UpdateCaption(Ecran);
    Ecran.HelpContext:=7662000 ;
    end
  else
    Ecran.HelpContext:=7281000;
}
end;

procedure TOF_CPVALIDEPIECE.InitVariables;
begin
  FPiecesGener  := TList.Create;
  FPiecesErr    := TList.Create;
end;

function TOF_CPVALIDEPIECE.AfficheMessage(vInErr: Integer) : Word ;
begin
  result := HShowMessage( Messages[ vInErr ], Ecran.Caption, '' ) ;
end;

procedure TOF_CPVALIDEPIECE.QualifPieceChange(Sender: TObject);
begin
  if (E_QualifPiece.Value = 'S') or ( E_QualifPiece.Value = 'R') then
    begin
    // Type de pi�ce g�n�r�e bloquer � "Normal"
    QualifGener.Enabled := False ;
    QualifGener.Value := 'N'
    end
  else
    begin
    // Type de pi�ce g�n�r�e non bloqu�, simulation par d�faut
    QualifGener.Enabled := True ;
    QualifGener.Value := 'S'
    end ;
end;

Initialization
  registerclasses ( [ TOF_CPVALIDEPIECE ] );
end.
