{***********UNITE*************************************************
Auteur  ...... : SBO
Créé le ...... : 06/03/2002
Modifié le ... : 20/02/2004
Description .. : Source TOM de la TABLE : SOUCHE (SOUCHE)
Mots clefs ... : TOM;SOUCHE
*****************************************************************}
Unit SOUCHE_TOM;

//================================================================================
// Interface
//================================================================================
Interface

uses
    StdCtrls,
    Controls,
    Classes,
    forms,
    sysutils,
    ComCtrls,
    HCtrls,
    Ed_tools,
    HEnt1,
    HMsgBox,
    UTOM,
    UTOB,
    SaisUtil,
    UiUtil,
    Graphics,
    Ent1,
    HPanel,
    Hqry,
    HSysMenu,
    UtilPGI,
{$IFDEF EAGLCLIENT}
    eFiche,
    maineagl,
    eFichList,
{$ELSE}
    db,
   {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
		{$IFNDEF EAGLSERVER}
	    FE_main,
		{$ENDIF !EAGLSERVER}
    HDB,
{$ENDIF}
{$IFDEF MODENT1}
  CPTypeCons,
{$ENDIF MODENT1}
	HTB97
    ;

//==================================================
// Externe
//==================================================
{$IFNDEF EAGLSERVER}
  Procedure FicheSouche(Lequel : String) ;
  Procedure FicheSoucheAGL( vTypeCpt : String) ;
  procedure YYLanceFiche_Souche( vStRange, vStLequel, vStArgs : String );
{$ENDIF !EAGLSERVER}
Function  RecalculSoucheSurUnExo(StWhereJal,Souche : String ; Exo : TExoDate ; Ecrit : Boolean) : Integer ;

//==================================================
// Definition de class
//==================================================
Type
    TOM_SOUCHE = Class (TOM)
        procedure OnNewRecord                ; override ;
        procedure OnUpdateRecord             ; override ;
        procedure OnAfterUpdateRecord        ; override ;
        procedure OnLoadRecord               ; override ;
        procedure OnArgument ( S: String )   ; override ;
        procedure OnClose                    ; override ;
        procedure OnAfterDeleteRecord        ; override ;
    private
        Lequel      : String ;      // Type de compteur
        CtrlNumDep  : Boolean ;     // Permet le controle des numéro de départ
        MemoNumDep  : Integer ;     // Memorisation des numéro de départ avant modif

        SH_ANALYTIQUE : TCheckBox ;
        SH_SIMULATION : TCheckBox ;

        procedure AutoriseCheckBox ;
        procedure AutoriseInfosReleve ;
        procedure AutoriseBoutons ;
        procedure GereEcran ;
        function  BudgetDecr : Boolean ;
        function  ChercheJalMvt : Boolean ;
// Conseil - Le symbole est déclaré mais jamais utilisé
//        function  GetNextNumSouche(Souche : String ; Exo : TExoDate) : Integer ;
        procedure OnLoadEtOnAfterUpdate;
        procedure VideChampsSurEnregOk;
        function  CompteurEstEffacable : Boolean;
        procedure ClickCheckBox(Sender: TObject ) ;

        procedure RepliqueMultiSoc( vBoSuppr : Boolean = False ) ;
    end;

//================================================================================
// Implementation
//================================================================================
Implementation

//==================================================
// Definition des variable
//==================================================
// Liste des messages pour LastErrorMsg
var
    MessageListe : Array[1..10] of String = (
    {01}    'La date que vous avez renseignée n''est pas valide',
    {02}    'Vous devez renseigner une date de début et une date de fin',
    {03}    'La date de fin doit être supérieure ou égale à la date de début',
    {04}    'Il ne peut y avoir qu''un seul compteur pour les relevés de factures',
    {05}    'Ce compteur est utilisé par un journal qui est mouvementé. Vous ne pouvez pas décrémenter le numéro de départ',
    {06}    'Ce compteur est utilisé par un budget qui est mouvementé. Vous ne pouvez pas décrémenter le numéro de départ',
    {07}    'Ce compteur est utilisé par des pièces. Vous ne pouvez pas décrémenter le numéro de départ',
    {08}    'Vous devez renseigner un code',
    {09}    'Vous devez renseigner un libellé',
	{10}    'Le code du compteur ne doit pas contenir d''espaces'
            );

//==================================================
// fonctions hors class
//==================================================
{$IFNDEF EAGLSERVER}
Procedure FicheSoucheAGL(vTypeCpt : String);
var
    lStArgs : String;
begin
    lStArgs := 'ACTION=MODIFICATION;' + vTypeCpt;
    YYLanceFiche_Souche(vTypeCpt,'',lStArgs);
end;
{$ENDIF !EAGLSERVER}

{$IFNDEF EAGLSERVER}
Procedure FicheSouche(Lequel : String);
var
    lStArgs : String;
begin
    lStArgs := 'ACTION=MODIFICATION;' + Lequel;
    YYLanceFiche_Souche(Lequel,'',lStArgs)
end;
{$ENDIF !EAGLSERVER}

{$IFNDEF EAGLSERVER}
procedure YYLanceFiche_Souche( vStRange, vStLequel, vStArgs : String );
begin
    if _Blocage(['nrCloture','nrBatch','nrSaisieCreat','nrSaisieModif','nrPointage','nrLettrage','nrEnca','nrDeca'],True,'nrCloture') then Exit ;

    if ( pos('ACTION',vStArgs) <= 0 ) then vStArgs := 'ACTION=MODIFICATION;' + vStArgs ;
    AglLanceFiche('YY','YYSOUCHE',vStRange,vStLequel,vStArgs);

    _Bloqueur('nrCloture',False) ;
end;
{$ENDIF !EAGLSERVER}

Function RecalculSoucheSurUnExo(StWhereJal,Souche : String ; Exo : TExoDate ; Ecrit : Boolean) : Integer;
Var
    Num : Integer;
    SQL : String;
    Q1 : TQuery;
begin
    Num := 0;
    SQL := 'SELECT MAX(E_NUMEROPIECE) FROM ECRITURE WHERE ' + StWhereJal + ' AND E_QUALIFPIECE="N"';
    if (Exo.Code <> '') then SQL := SQL + ' AND E_EXERCICE="' + Exo.Code + '"';

    Q1:=OpenSql(Sql,True);
    if (not Q1.Eof) then Num := Q1.Fields[0].AsInteger;
    Ferme(Q1);

    Inc(Num);

    if (Ecrit) Then
    begin
        SQL:='' ;
                                                             {JP 15/06/05 : FQ 16033 : UPDATE va mieux que UPADTE}
        if (Exo.Code = '')                      then SQL := 'UPDATE SOUCHE SET SH_NUMDEPART=' + IntToStr(Num) + ' WHERE SH_SOUCHE="' + Souche + '"'
        else if (Exo.Code = VH^.Suivant.Code)   then SQL := 'UPDATE SOUCHE SET SH_NUMDEPARTS=' + IntToStr(Num) + ' WHERE SH_SOUCHE="' + Souche + '"'
        else if (Exo.Code = VH^.EnCours.Code)   then SQL := 'UPDATE SOUCHE SET SH_NUMDEPART=' + IntToStr(Num) + ' WHERE SH_SOUCHE="' + Souche + '"'
        else if (Exo.Code = VH^.Precedent.Code) then SQL := 'UPDATE SOUCHE SET SH_NUMDEPARTP=' + IntToStr(Num) + ' WHERE SH_SOUCHE="' + Souche + '"';

        if (SQL <> '') then ExecuteSQL(SQL);
    end;

    result := Num;
end;

//==================================================
// Evenements par default de la TOM
//==================================================
procedure TOM_SOUCHE.OnNewRecord;
begin
  Inherited;

  // Champs non présents sur la fiche
  SetField('SH_TYPE',       Lequel);
  SetField('SH_NUMDEPARTS', 1);
  SetField('SH_NUMDEPARTP', 1);
  SetField('SH_SOUCHEEXO',  '-');
  SetField('SH_DATEDEBUT',  iDate1900 ); // Zone obligatoire !
  SetField('SH_DATEFIN',    iDate1900 ); // Zone obligatoire !

  // Champs présents sur la fiche
  SetField('SH_NUMDEPART',  '1');
  SetControlText('SH_NUMDEPART',  '1');

  CtrlNumDep  := False ;
  MemoNumDep  := 1 ;

  // MAJ Interface
  GereEcran ;
end;

procedure TOM_SOUCHE.OnUpdateRecord;
var code : String;
begin
    Inherited;

    // Test sur le code
    code := GetControlText('SH_SOUCHE');
    if (DS.State = dsInsert) then
    begin
        if (code = '') then   // Code Obligatoire
        begin
            PGIBox(TraduireMemoire(MessageListe[8]),TraduireMemoire(Ecran.caption));
            SetFocusControl('SH_SOUCHE');
            LastError := 1;
            exit;
        end
        else if pos(' ',code)>0 then // aucun blanc dans le code
        begin
            PGIBox(TraduireMemoire(MessageListe[10]),TraduireMemoire(Ecran.caption));
            SetFocusControl('SH_SOUCHE');
            LastError := 1;
            exit;
        end;
    end;

    // Contrôle des numéros de départ
    if (CtrlNumDep or BudgetDecr) then
    begin
        if (StrToInt(GetControlText('SH_NUMDEPART')) < MemoNumDep) then // Décrémenté ?
        begin
            LastError := 1;

            if (Lequel = 'BUD') then PGIBox(TraduireMemoire(MessageListe[6]),TraduireMemoire(Ecran.caption))
            else if (Lequel = 'GES') then PGIBox(TraduireMemoire(MessageListe[7]),TraduireMemoire(Ecran.caption))
            else PGIBox(TraduireMemoire(MessageListe[5]),TraduireMemoire(Ecran.caption));

            if (GetControl('SH_NUMDEPART') <> nil) then // reMAJ du controle
            begin
                SetFocusControl('SH_NUMDEPART');
                SetControlProperty('SH_NUMDEPART','value',MemoNumDep) ;
            end;
            exit;
        end;
    end;

    VideChampsSurEnregOk;
end;

procedure TOM_SOUCHE.OnAfterUpdateRecord;
begin
  Inherited;
  OnLoadEtOnAfterUpdate;

  RepliqueMultisoc ;


  {$IFDEF EAGLCLIENT}
    AvertirCacheServer('SOUCHE');
    RefreshDB ;
  {$ENDIF}
end;

procedure TOM_SOUCHE.OnLoadRecord;
begin
    Inherited;
    //YMO 13&20/09/2006 FQ18783 Normes BOI
    If ((VH^.PaysLocalisation = 'FR') AND (GetField('SH_TYPE') = 'CPT') And (StrToInt(GetControlText('SH_NUMDEPART')) > 1))  then
      SetControlProperty('SH_NUMDEPART','Enabled',False)
    else
      SetControlProperty('SH_NUMDEPART','Enabled',True) ;

    OnLoadEtOnAfterUpdate;
end;

procedure TOM_SOUCHE.OnArgument(S : String);
var
    action : string;
begin
  Inherited;

  Action := ReadTokenSt(S);
  Lequel := ReadTokenSt(S);
  CtrlNumDep := false;

  // Initialisation interface
  if (Ecran <> nil) then
    begin

    // Checkbox "Analytique" et "Simulation"
    SH_ANALYTIQUE := TCheckBox(GetControl('SH_ANALYTIQUE',true));
    SH_SIMULATION := TCheckBox(GetControl('SH_SIMULATION',true));

    // EVT CheckBox
    SH_ANALYTIQUE.OnExit := ClickCheckBox ;
    SH_SIMULATION.OnExit := ClickCheckBox ;

    // contexte d'aide
    if (Lequel='BUD')
      then Ecran.HelpContext := 7577100   // Aide contextuelle spécifique
      else Ecran.HelpContext := 1300000 ; // Aide contextuelle générique

    end;
  // CA - 17/06/2004 - Ne pas autoriser la création de codes souche en minuscule
  SetControlProperty('SH_SOUCHE','CharCase',ecUpperCase);

  // 15107 - Journal uniquement de nature OD
  SetControlProperty('SH_JOURNAL','DATATYPE','TTJALOD');
end;

procedure TOM_SOUCHE.OnClose;
begin
    Inherited;
    if (Ecran <> nil) then
      if (Ecran.Parent is THPanel) then
        _Bloqueur('nrCloture',False);
end;

//==================================================
// Autres fonctions de la class
//==================================================

{***********A.G.L.***********************************************
Auteur  ...... : JP
Créé le ...... : 26/08/2004
Modifié le ... :   /  /
Description .. : FQ 12659 : le plantage sur Ctrl + Fin se faisait sur le
Suite ........ : ferme(Q) sans raisons apparentes. J'ai donc supprimé
Suite ........ : l'utilsation d'un TQuery en faisant un LoadDetailFromSQL
Mots clefs ... :
*****************************************************************}
function TOM_SOUCHE.ChercheJalMvt : Boolean;
var i  : Integer;
    ExoEnCours,ExoSuivant,Journal,Nature : String;
    TOBJournaux : TOB;
    ListeJxAna,ListeJxEcr : String;
    lStSouche       : String ;
    lStBase         : String ;
    lStGroupe       : String ;
begin

  Result := false;

  if Lequel='GES' then Exit ; // Pour la Gescom, les tests sont fait plus tard



  if (DS.State <> dsInsert) then
  begin

    lStSouche := GetControlText('SH_SOUCHE');

    TOBJournaux := TOB.Create('Liste des Journaux',nil,-1);
    try
      TOBJournaux.LoadDetailFromSQL('SELECT J_JOURNAL, J_NATUREJAL FROM JOURNAL WHERE J_COMPTEURNORMAL="' + lStSouche + '" OR J_COMPTEURSIMUL="' + lStSouche + '"');
      ListeJxAna := '';
      ListeJxEcr := '';
      for i := 0 to (TOBJournaux.Detail.Count - 1) do
      begin
        Journal := TOBJournaux.Detail[i].GetValue('J_JOURNAL');
        Nature := TOBJournaux.Detail[i].GetValue('J_NATUREJAL');
        ExoEnCours := VH^.EnCours.Code;
        ExoSuivant := VH^.Suivant.Code;

        if ((Nature = 'ODA') Or (Nature = 'ANA')) then
        begin // Journaux Analytiques
          if (ListeJxAna = '')
            then ListeJxAna := '"' + Journal + '"'
            else ListeJxAna := listeJxAna + ',"' + Journal + '"';
        end
        else
        begin // Journaux ecritures courantes
          if (ListeJxEcr = '')
            then ListeJxEcr := '"' + Journal + '"'
            else ListeJxEcr := listeJxEcr + ',"' + Journal + '"';
        end;
      end;

      // Gestion des modes multisociété
      if EstMultiSoc and EstTablePartagee( 'JOURNAL' ) then
        begin

        result    := False ;

        // Récupératin de la liste des dossiers
        lStGroupe := GetBasesMS ;
        lStBase   := ReadTokenSt( lStGroupe ) ;

        // Test sur toutes les bases
        while lStBase<>'' do
          begin
          // Tests sur les journaux écritures
          if ((listeJxEcr <> '') and (not Result))
            then Result := ExisteSQL('SELECT E_JOURNAL FROM ' + GetTableDossier( lStBase, 'ECRITURE') + ' WHERE E_JOURNAL IN (' + ListeJxEcr + ') AND (E_EXERCICE="' + ExoEnCours + '" OR E_EXERCICE="' + ExoSuivant + '")');
          // Tests sur les journaux Analytiques
          if ((listeJxAna <> '') and (not Result))
            then Result := ExisteSQL('SELECT Y_JOURNAL FROM ' + GetTableDossier( lStBase, 'ANALYTIQ') + ' WHERE Y_JOURNAL IN (' + ListeJxAna + ') AND (Y_EXERCICE="' + ExoEnCours + '" OR Y_EXERCICE="' + ExoSuivant + '")');
          // dossier suivant
          if Result then Break ;
          lStBase  := ReadTokenSt( lStGroupe ) ;
          end ;

        end
      else
        begin

        // Tests sur les journaux écritures
        if (listeJxEcr <> '')
          then Result := ExisteSQL('SELECT E_JOURNAL FROM ECRITURE WHERE E_JOURNAL IN (' + ListeJxEcr + ') AND (E_EXERCICE="' + ExoEnCours + '" OR E_EXERCICE="' + ExoSuivant + '")');
        // Tests sur les journaux Analytiques
        if ((listeJxAna <> '') and (not Result))
          then Result := ExisteSQL('SELECT Y_JOURNAL FROM ANALYTIQ WHERE Y_JOURNAL IN (' + ListeJxAna + ') AND (Y_EXERCICE="' + ExoEnCours + '" OR Y_EXERCICE="' + ExoSuivant + '")');

        end ;

    finally
      if Assigned(TOBJournaux) then TOBJournaux.Free;
    end;
  end;

  CtrlNumDep := Result;

end;

{***********A.G.L.***********************************************
Auteur  ...... : BPY
Créé le ...... : 26/06/2003
Modifié le ... :   /  /
Description .. : Retourne Vrai s'il y a des écritures de budget utilise pour
Suite ........ : savoir s'il on peut décrémenté le compteur de départ
Mots clefs ... :
*****************************************************************}
function TOM_SOUCHE.BudgetDecr : Boolean;
Begin
    if (Lequel <> 'BUD')
      then result := False
      else result := ExisteSql('SELECT BE_BUDGENE FROM BUDECR');
end;

{***********A.G.L.***********************************************
Auteur  ...... : SBO
Créé le ...... : 20/02/2004
Modifié le ... :   /  /
Description .. : Gestion de l'accès aux cases à cocher "Simulation" et
Suite ........ : "Analytique" pour les compteurs comptables
Mots clefs ... :
*****************************************************************}
procedure TOM_SOUCHE.AutoriseCheckBox;
begin
    if Lequel = 'CPT' then
      begin
      ClickCheckBox (nil) ;
      end
    else
      begin
      SH_ANALYTIQUE.Visible := False;
      SH_SIMULATION.Visible := False;
      end ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : BPY
Créé le ...... : 26/06/2003
Modifié le ... :   /  /
Description .. : Retourne le numéro de compteur "Souche" suivant pour l'exercice "Exo"
Mots clefs ... :
*****************************************************************}
{function TOM_SOUCHE.GetNextNumSouche(Souche : String ; Exo : TExoDate) : Integer;
Var
    Jal,StWhereJal : String;
    Q : TQuery;
    TOBJournaux : TOB;
    i : Integer;
begin
    result := 1;

    if (not VH^.MultiSouche) then exit;     // Necessaire uniquement en mode "multi-souche"

    // Récupération des journaux concernés
    TOBJournaux := TOB.Create('Liste des Journaux',nil,-1);
    Q := OpenSQL('SELECT J_JOURNAL FROM JOURNAL WHERE J_COMPTEURNORMAL="' + Souche + '"',true);
    TOBJournaux.LoadDetailDB('JOURNAL','','',Q,False);
    Ferme(Q);

    // Construction de la condition de recherche
    StWhereJal := '';

    for i := 0 to (TOBJournaux.Detail.Count - 1) do
    begin
        Jal := TOBJournaux.Detail[i].GetValue('J_JOURNAL');
        if (StWhereJal = '') Then StWhereJal := 'E_JOURNAL IN ("' + Jal + '"'
        else StWhereJal := StWhereJal + ',"' + Jal + '"';
    end;
    TOBJournaux.Free;

    if (StWhereJal <> '') Then
    begin
        StWhereJal := StWhereJal + ')'; // Finition du IN (...)
        Result := RecalculSoucheSurUnExo(StWhereJal,Souche,Exo,FALSE);
    end;
end;}

procedure TOM_SOUCHE.OnLoadEtOnAfterUpdate;
begin
  // maj variables
  MemoNumDep  := StrToInt( GetControlText('SH_NUMDEPART') );
  CtrlNumDep  := False;
  // Gestion des accès écran
  GereEcran ;
end;

procedure TOM_SOUCHE.VideChampsSurEnregOk;
begin
  if (Lequel <> 'REL') then
    begin
    SetControlText('SH_MASQUENUM','');
    SetControlText('SH_NATUREPIECE','');
    SetControlText('SH_JOURNAL','');
    end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : SBO
Créé le ...... : 20/02/2004
Modifié le ... :   /  /    
Description .. : Gestion de l'affichage des champs "Nature de pièce",
Suite ........ : "Journal" et "Référence" pour les compteurs de relevés.
Mots clefs ... : 
*****************************************************************}
procedure TOM_SOUCHE.AutoriseInfosReleve;
begin
  // INFOS POUR SH_TYPE = "REL" : Compteur "Relevé"
  // Référence
  SetControlVisible('TSH_MASQUENUM',    (lequel = 'REL') );
  SetControlVisible('SH_MASQUENUM',     (lequel = 'REL') );
  // Combo Nature de pièce
  SetControlVisible('TSH_NATUREPIECE',  (lequel = 'REL') );
  SetControlVisible('SH_NATUREPIECE',   (lequel = 'REL') );
  // Combo Journal
  SetControlVisible('TSH_JOURNAL',      (lequel = 'REL') );
  SetControlVisible('SH_JOURNAL',       (lequel = 'REL') );

end;

Function TOM_SOUCHE.CompteurEstEffacable : Boolean;
Var
    Souche : String;
begin
    Souche := GetControlText('SH_SOUCHE');
    Result := Souche <> '';

    // Pour les compteurs GESCOM // FQ 13853 Modif SBO 02/09/2004
    if Lequel='GES' then
       begin
       if ExisteSQL('SELECT GP_SOUCHE FROM PIECE WHERE GP_SOUCHE="'+Souche+'"') then
         begin
         Result     := False ;
         CtrlNumDep := True ;
         end
       else
         begin
         Result := not ExisteSQL('SELECT GPP_SOUCHE FROM PARPIECE WHERE GPP_SOUCHE="'+Souche+'"') ;
         if result then
           Result := not ExisteSQL('SELECT GPC_SOUCHE FROM PARPIECECOMPL WHERE GPC_SOUCHE="'+Souche+'"') ;
         end ;

       Exit ;
       end ;
    // FQ 13853 Fin Modif SBO 02/09/2004

  if Result then result := not ExisteSQL('SELECT J_JOURNAL FROM JOURNAL WHERE J_COMPTEURNORMAL="' + Souche + '" OR J_COMPTEURSIMUL="' + Souche + '"');
  if Result then Result := not ExisteSQL('SELECT JR_NUMPLAN,JR_JOURNAL,JR_PREDEFINI FROM JALREF WHERE JR_COMPTEURNORMAL="' + Souche + '" OR JR_COMPTEURSIMUL="' + Souche + '"');
  if Result then Result := not ExisteSQL('SELECT BJ_BUDJAL FROM BUDJAL WHERE BJ_COMPTEURNORMAL="' + Souche + '" OR BJ_COMPTEURSIMUL="' + Souche + '"');

end;

//================================================================================
// Initialization
//================================================================================


{***********A.G.L.***********************************************
Auteur  ...... : SBO
Créé le ...... : 20/02/2004
Modifié le ... :   /  /
Description .. : Gestion de l'accès au boutons "Nouveau" et "Supprimer"
Mots clefs ... : 
*****************************************************************}
procedure TOM_SOUCHE.AutoriseBoutons;
Var Ok : Boolean ;
begin

  // Afichage Bouton "NOUVEAU"
  TButton( GetControl('BINSERT', True) ).Visible := not (Lequel = 'REL') ;
  // Accès bouton "NOUVEAU"
  {$IFDEF EAGLCLIENT}
  {JP 20/04/07 : FQ 18252 : L'agl intervient pour l'activation du BInsert : je cache le bouton}
  Ok := GetControlVisible('BInsert');
  if ( (Lequel = 'BUD') and  (DS.Detail.Count > 0) )
    then SetControlVisible('BInsert',False)
    else SetControlVisible('BInsert',Ok);
  {$ELSE}
  Ok := GetControlEnabled('BInsert');
  if ( (Lequel = 'BUD') and not ((DS.Bof) and (DS.Eof)) )
    then SetControlEnabled('BInsert',False)
    else SetControlEnabled('BInsert',Ok);
  {$ENDIF EAGLCLIENT}

  // Affichage du boutons supprimer
  if (Lequel = 'BUD')
    then SetControlVisible('BDelete',False) // Invisible pour les compteurs budgétaires
    else
      begin
      // Accès Bouton supprimer hors mode création et si compteurs non utilisés
      Ok := ((DS.State <> dsInsert) and (not CtrlNumDep));
      if Ok then
        Ok := CompteurEstEffacable;
      SetControlVisible('BDelete',Ok);
      end ;

end;

{***********A.G.L.***********************************************
Auteur  ...... : SBO
Créé le ...... : 20/02/2004
Modifié le ... : 20/02/2004
Description .. : Gestion affichage et accès des éléments d'interface
Mots clefs ... : 
*****************************************************************}
procedure TOM_SOUCHE.GereEcran;
begin
  // MAJ INTERFACE
  if Ecran = nil then Exit ;

  ChercheJalMvt; // renseigne CtrlNumDep

  AutoriseInfosReleve;
  AutoriseBoutons ;
  AutoriseCheckBox;

end;

{***********A.G.L.***********************************************
Auteur  ...... : SBO
Créé le ...... : 20/02/2004
Modifié le ... : 20/02/2004
Description .. : Gestion de l'exclusion des coches Analytiques / Simulation
Suite ........ : pour les compteurs comptables.
Mots clefs ... :
*****************************************************************}
procedure TOM_SOUCHE.ClickCheckBox(Sender: TObject);
begin
  SH_SIMULATION.Enabled := (not CtrlNumDep) and (not SH_ANALYTIQUE.Checked);
  SH_ANALYTIQUE.Enabled := (not CtrlNumDep) and (not SH_SIMULATION.Checked);
end;


procedure TOM_SOUCHE.OnAfterDeleteRecord;
begin
  inherited;
  RepliqueMultiSoc( True ) ;
end;

procedure TOM_SOUCHE.RepliqueMultiSoc(vBoSuppr: Boolean);
var lStBase         : String ;
    lStGroupe       : String ;
    lStSQL          : String ;
    lStFrom         : String ;
    lBoInBase       : Boolean ;
begin

  if not EstMultiSoc then Exit ;
  if not EstTablePartagee( 'JOURNAL' ) then Exit ;

  lStGroupe := GetBasesMS ;

  // Parcours des bases du regroupements
  while lStGroupe <> '' do
    begin

    lStBase := ReadTokenSt( lStGroupe ) ;
    lStBase := ReadTokenPipe( lStBase , '|' ) ;
    if (lStBase = V_PGI.SchemaName) or ( Trim( lStBase ) = '' ) then Continue ;

    lStSQL := '' ;
    lStFrom := GetTableDossier( lStBase, 'SOUCHE' ) ;

    // test présence en base
//    lBoInBase := ExisteSQL('SELECT SH_SOUCHE FROM ' + lStFrom + ' WHERE SH_TYPE="' + GetField('SH_TYPE') + '" AND SH_SOUCHE = "' + GetField('SH_SOUCHE') + '"') ;
    lBoInBase := PresenceComplexe( lStFrom ,
                                   ['SH_SOUCHE','SH_TYPE'],
                                   ['=','='],
                                   [ GetField('SH_SOUCHE'), GetField('SH_TYPE') ],
                                   ['S','S'] ) ;

    // SUPPRESSION
    if ( vBoSuppr  and lBoInBase ) then
      begin
      lStSQL  := 'DELETE FROM ' + lStFrom
                 + ' WHERE SH_TYPE="' + GetField('SH_TYPE')
                 + '" AND SH_SOUCHE="' + GetField('SH_SOUCHE') + '"' ;
      end
    // INSERTION POUR REPLICATION
    else if (not vBoSuppr) and (not lBoInBase) then
      begin
      lStSQL  := 'INSERT INTO ' + lStFrom + ' '
                  + '(SH_TYPE, SH_SOUCHE, SH_LIBELLE, SH_ABREGE, SH_NATUREPIECE,'
                  +  'SH_NUMDEPART, SH_JOURNAL, SH_MASQUENUM, SH_SOCIETE, SH_DATEDEBUT,'
                  +  'SH_DATEFIN, SH_FERME, SH_ANALYTIQUE, SH_NATUREPIECEG, SH_SIMULATION,'
                  +  'SH_NUMDEPARTS, SH_NUMDEPARTP, SH_SOUCHEEXO, SH_RESERVEWEB)'
                  +  ' VALUES ("' + GetField('SH_TYPE')        + '","' + GetField('SH_SOUCHE')
                          + '","' + GetField('SH_LIBELLE')     + '","' + GetField('SH_ABREGE')
                          + '","' + GetField('SH_NATUREPIECE') + '",'  + IntToStr( GetField('SH_NUMDEPART') )
                          + ',"'  + GetField('SH_JOURNAL')     + '","' + GetField('SH_MASQUENUM')
                          + '","' + GetField('SH_SOCIETE')     + '","' + USDateTime( GetField('SH_DATEDEBUT') )
                          + '","' + USDateTime( GetField('SH_DATEFIN') )
                          + '","' + GetField('SH_FERME')       + '","' + GetField('SH_ANALYTIQUE')
                          + '","' + GetField('SH_NATUREPIECEG')+ '","' + GetField('SH_SIMULATION')
                          + '",'  + IntToStr( GetField('SH_NUMDEPARTS') )  + ',' + IntToStr( GetField('SH_NUMDEPARTP') )
                          + ',"'  + GetField('SH_SOUCHEEXO')   + '","' + GetField('SH_RESERVEWEB') + '")' ;

      end ;

      if lStSQL<>'' then
        ExecuteSQL( lStSQL ) ;

    end ;

end;

Initialization
    registerclasses([TOM_SOUCHE]);
end.




