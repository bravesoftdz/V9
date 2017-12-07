{***********UNITE*************************************************
Auteur  ...... : 
Cr�� le ...... : 09/10/2007
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : CPGLGESTION ()
Mots clefs ... : TOF;CPGLGESTION
*****************************************************************}
Unit uTOFCPGLGestion;

Interface

Uses StdCtrls, 
     Controls, 
     Classes, 
{$IFDEF EAGLCLIENT}
     Maineagl,
     eQRS1,
{$ELSE}
     Fe_main,
     DB,
  {$IFDEF DBXPRESS}uDbxDataSet,{$ELSE}dbtables,{$ENDIF}
     QRS1,
{$ENDIF}
     forms,
     sysutils, 
     ComCtrls,
     HCtrls, 
     HEnt1,
     HMsgBox,
     UTOF,
     {$IFDEF MODENT1}
     CPTypeCons,
     {$ENDIF MODENT1}
     Spin,         // TSpinEdit
     TofMeth,      // class(TOF_METH)
     Ent1;         // TExoDate

type
  TOF_CPGLGESTION = class(TOF_METH)

  public

    E_GENERAL        : THEdit;
    E_GENERAL_       : THEdit;
    E_DATECOMPTABLE  : THEdit;
    E_DATECOMPTABLE_ : THEdit;
    E_NUMEROPIECE    : THEdit;
    E_NUMEROPIECE_   : THEdit;
    CPTEXCEPT        : THEdit;
    LIBEQUALIFPIECE  : THEdit;
    E_REFINTERNE     : THEdit;
    E_EXERCICE       : THValComboBox;
    E_DEVISE         : THValComboBox;
    MODESELECT       : THValComboBox;
    YAXE             : THValComboBox;

    E_QUALIFPIECE    : THMultiValComboBox;
    G_CYCLEREVISION  : THEdit;

    // Correspondances
    CORRESP          : THValComboBox;
    CORRESPDE        : THValComboBox;
    CORRESPA         : THValComboBox;

    // Tables Libres
    TABLELIBRE       : THValComboBox;
    LIBREDE          : THEdit;
    LIBREA           : THEdit;

    ECRVALIDE        : TCheckBox;
    ECRLETTRE        : TCheckBox;
    ECRPOINTE        : TCheckBox;
    AFFCENTRA        : TCheckBox;

    DateDebutExo     : THEdit;
    Exercice         : THEdit;

    Pages            : TPageControl;
    RGDevise         : THRadioGroup;
    RUPTURE          : THRadioGroup;
    RUPTURES         : TTabSheet;
    RUPTURETYPE      : THRadioGroup;
    RUPCORRESP       : TGroupBox;
    RUPLIBRES        : TGroupBox;
    RUPGROUPES       : TGroupBox;
    RUPCYCLEREVISION : TCheckBox;

    NIVORUPTURE      : TSpinEdit;
    AFFDEVISE        : THEdit;
    DEVPIVOT         : THEdit;
    XX_RUPTURE       : THEdit;
    AVECRUPTYPE      : THEdit;
    AVECRUPTURE      : THEdit;
    AVECNIVORUPTURE  : THEdit;
    OKENTETE         : THEdit;
    OKRESUME         : THEdit;
    ETATINCOMPLET    : THEdit;

    CBPreview        : TCheckBox;
    CPTCorrespExist  : TCheckBox;
    CPTLibreExist    : TCheckBox;

    procedure OnExitE_General         ( Sender : TObject );
    procedure OnExitE_DateComptable   ( Sender : TObject );
    procedure OnChangeE_Exercice      ( Sender : TObject );
    procedure OnChangeE_Devise        ( Sender : TObject );
    procedure OnClickRupture          ( Sender : TObject );
    procedure OnClickRuptureType      ( Sender : TObject );
    procedure FTimerTimer             ( Sender : TObject );
    procedure OnChangeCorresp         ( Sender : TObject );
    procedure OnChangeTableLibre      ( Sender : TObject );
    procedure OnEnterQualifPiece      ( Sender : TObject ); // SBO - 12/10/2004
    procedure OnClickRupCycleRevision ( Sender : TObject );

    procedure OnLoad                              ; override;
    procedure OnUpdate                            ; override;
    procedure OnArgument( S : string )            ; override;
    procedure OnClose                             ; override;
    procedure OnNew                               ; override;
    procedure ChargementCritEdt                   ; override;
    procedure MySelectFiltre                      ; override;
    procedure OnChangeFiltre ( Sender : TObject ) ; override;

  private
    EdLegale         : Boolean;
    FStArgument      : HString;   // Argument pass� en param�tre
    FStWhereEtat     : HString;   // Condition Where envoy�e � l'�tat
    FBoOkDecoupage   : Boolean;  // D�coupage du grand livre
    FExoDate         : TExoDate; // Contexte de travail sur les dates

    procedure ControleAvantEdition;
    procedure GestionCentralisation;       // Point d'�ntr�e de la centralisation
    procedure SupprimeCentralisation;      // Suppression des �critures "Z"
    procedure EffectueCentralisation;      // Insertion des �critures "Z"
    procedure CBlocageGLGene;              // Blocage dans la Table COURRIER
    procedure CDeBlocageGLGene;            // D�blocage
    function  CEstBloqueGLGene : Boolean;  // Controle de la pr�sence du Verrou

    procedure GenereCumulGL;

    function GenereConditionWhereEtat   : HString;
    function RecupAutresCriteres        : HString;
    function RecupCriteresCommuns       : HString;
    function RecupCriteresModeSelection( vStWhereEtat : HString ) : HString;
    function RenvoiOrderBy              : HString;

    procedure GestionCritereDEV;

{$IFDEF EAGLCLIENT}
{$ELSE}
    procedure GestionTailleGrandLivre( vStwhereCritere : HString );
{$ENDIF}

  end;

////////////////////////////////////////////////////////////////////////////////  
function CPLanceFiche_CPGLGESTION( vStParam: HString = '') : HString ;
function OnMyValideCritereEvent : Boolean;

implementation

uses
   {$IFDEF MODENT1}
     CPProcMetier,
   {$ENDIF MODENT1}
     uLibWindows,  // IIF
     uLibExercice, //CinitComboExercice
     ParamSoc,     // GetParamSocSecur
     uTobDebug,    // TobDebug
     uTob,         // TOB
     Graphics,     // ClWindow
     HQry,         // RecupWhereCritere
     ED_TOOLS,     // InitMoveProgressForm
     AGLInit,      // TheData
     CritEdt,      // ClassCritEdt
     uPrintF1Book, // PDFBatch
     HPdfPrev,     // PreviewPDFFile
     HPdfViewer,   // PrintPDF
     Printers,     // Printer
     LicUtil,      // CryptageSt
{$IFDEF EAGLCLIENT}
     uTileAGL,     // LanceEtatTob
{$ELSE}
     EdtREtat,     // LanceEtatTob
{$ENDIF}

{$IFNDEF EDTQR}
     UTofMulParamGen,
{$ENDIF}
    uLibCalcEdtCompta, // FTobCumulAu
    utilPGI,
    uMultiDossierUtil; // RequeteMultiDossier

const cNbEcrMax = 10000;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 09/10/2007
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
function CPLanceFiche_CPGLGESTION( vStParam : HString = '') : HString;
begin
  Result := AGLLanceFiche('CP', 'CPGLGESTION', '', '', vStParam);
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 10/11/2004
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.OnArgument( S : string );
begin
  inherited;
  FStArgument := S; // R�cup�ratrion des param�tres

  // GCO - 11/07/2006 - FQ 18363
  PAvances := TTabSheet(GetControl('AVANCES', true));
  Pavances.TabVisible := True;
  TFQRS1(Ecran).CritAvancesVisibled := True;

  if FStArgument = 'LEGALE' then EdLegale := True;

  if ReadTokenSt(FStArgument) = 'MULTIDOSSIER' then
  begin
    THLabel(GetControl('TMULTIDOSSIER')).Focuscontrol := nil;
    SetControlVisible( 'MULTIDOSSIER',   True ) ;
    SetControlVisible( 'TMULTIDOSSIER',  True ) ;
    SetControlVisible( 'BVMULTIDOSSIER', True ) ;
    //SetControlVisible( 'RUPTUREMAX',     True ) ;
  end;

  // Branchement de HelpContext
  //Ecran.HelpContext := 

  E_GENERAL   := THEdit(GetControl('EGENERAL', True));
  E_GENERAL_  := THEdit(GetControl('EGENERAL_', True));

  E_DATECOMPTABLE  := THEdit(GetControl('EDATECOMPTABLE', True));
  E_DATECOMPTABLE_ := THEdit(GetControl('EDATECOMPTABLE_', True));
  E_NUMEROPIECE    := THEdit(GetControl('E_NUMEROPIECE', True));
  E_NUMEROPIECE_   := THEdit(GetControl('E_NUMEROPIECE_', True));
  E_REFINTERNE     := THEdit(GetControl('E_REFINTERNE', True));
  E_EXERCICE       := THValComboBox(GetControl('EEXERCICE', True));
  CInitComboExercice(E_EXERCICE);

  E_DEVISE         := THValComboBox(GetControl('E_DEVISE', True));
  E_QUALIFPIECE    := THMultiValComboBox(GetControl('EQUALIFPIECE', True));
  YAXE             := THValComboBox(GetControl('YAXE', True));

  MODESELECT       := THValComboBox(GetControl('MODESELECT', True));
  AFFDEVISE        := THEdit(GetControl('AFFDEVISE', True));
  DEVPIVOT         := THEdit(GetControl('DEVPIVOT', True));
  RGDEVISE         := THRadioGroup(GetControl('RGDEVISE', True));
  CPTEXCEPT        := THEdit(GetControl('CPTEXCEPT', True));

  ECRVALIDE        := TCheckBox(GetControl('ECRVALIDE', True));
  ECRLETTRE        := TCheckBox(GetControl('ECRLETTRE', True));
  ECRPOINTE        := TCheckBox(GetControl('ECRPOINTE', True));
  AFFCENTRA        := TCheckBox(GetControl('AFFCENTRA', True));

  DateDebutExo     := THEdit(GetControl('DATEDEBUTEXO', True));
  Exercice         := THEdit(GetControl('EXERCICE', True));

  Pages            := TPageControl(GetControl('Pages', True));
  RUPTURE          := THRadioGroup(GetControl('RUPTURE', True));
  RUPTURES         := TTabSheet(GetControl('RUPTURES', True));
  RUPTURETYPE      := THRadioGroup(GetControl('RUPTURETYPE', True));
  RUPCORRESP       := TGroupBox(GetControl('RUPCORRESP', True));
  RUPLIBRES        := TGroupBox(GetControl('RUPLIBRES', True));
  RUPGROUPES       := TGroupBox(GetControl('RUPGROUPES', True));
  CORRESP          := THValComboBox(GetControl('CORRESP', True));
  CORRESPDE        := THValComboBox(GetControl('CORRESPDE', True));
  CORRESPA         := THValComboBox(GetControl('CORRESPA', True));

  CBPreview        := TCheckBox(GetControl('FAPERCU', True));
  // Case � cocher : Uniquement les comptes associ�s
  CPTCORRESPEXIST  := TCheckBox(GetControl('CPTCORRESPEXIST', True));
  CPTLIBREEXIST    := TCheckBox(GetControl('CPTLIBRESEXIST', True));

  // Zones cach�es
  XX_RUPTURE       := THEdit(GetControl('XX_RUPTURE', True));
  AVECRUPTYPE      := THEdit(GetControl('AVECRUPTYPE', True));
  AVECRUPTURE      := THEdit(GetControl('AVECRUPTURE', True));
  AVECNIVORUPTURE  := THEdit(GetControl('AVECNIVORUPTURE', True));
  NIVORUPTURE      := TSpinEdit(GetControl('NIVORUPTURE', True));
  OKENTETE         := THEdit(GetControl('OKENTETE', True));
  OKRESUME         := THEdit(GetControl('OKRESUME', True));
  ETATINCOMPLET    := THEdit(GetControl('ETATINCOMPLET', True));

  TABLELIBRE       := THValComboBox(Getcontrol('TABLELIBRE', True));
  LIBREDE          := THEdit(GetControl('LIBREDE', True));
  LIBREA	         := THEdit(GetControl('LIBREA', True));

  LIBEQUALIFPIECE  := THEdit(GetControl('LIBEQUALIFPIECE', True));

  // ---------------------- Cycle de r�vision ----------------------------------
  // Pas de param�tre True pour le GetControl, le GL auxiliaire ne fait pas la r�vision
  G_CYCLEREVISION  := THEdit(GetControl('GCYCLEREVISION', False));
  RUPCYCLEREVISION := TCheckBox(GetControl('RUPCYCLEREVISION', False));

  // ----------------- Init des PROPERTY ---------------------------------------
  E_GENERAL.MaxLength  := VH^.CPta[fbGene].Lg;
  E_GENERAL_.MaxLength := VH^.CPta[fbGene].Lg;

  RUPTURES.TabVisible := False;
  RUPCORRESP.Visible  := False;
  RUPLIBRES.Visible   := False;
  RUPGROUPES.Visible  := True;

  // Type de plan comptable :
  if GetParamSocSecur('SO_CORSGE2', False, True) then
    Corresp.plus := 'AND (CO_CODE = "GE1" OR CO_CODE = "GE2")'
  else
    Corresp.plus := 'AND CO_CODE = "GE1"';

  // ----------------- Branchement des �v�nements ------------------------------
  E_EXERCICE.OnChange   := OnChangeE_Exercice;

  if ( CtxPCl in V_PGI.PgiContexte ) and  ( VH^.CPExoRef.Code <>'' ) then
    E_EXERCICE.Value := CExerciceVersRelatif(VH^.CPExoRef.Code)
  else
    E_EXERCICE.Value := CExerciceVersRelatif(VH^.Entree.Code) ;

  E_General.OnExit         := OnExitE_General;
  E_General_.OnExit        := OnExitE_General;
  CORRESP.OnChange         := OnChangeCorresp;
  TABLELIBRE.OnChange      := OnChangeTableLibre;
  E_DATECOMPTABLE.OnExit   := OnExitE_DateComptable;
  E_DATECOMPTABLE.OnExit   := OnExitE_DateComptable;
  E_DEVISE.OnChange        := OnChangeE_Devise;
  Rupture.OnClick          := OnClickRupture;
  RuptureType.OnClick      := OnClickRuptureType;
  FTimer.OnTimer           := FTimerTimer;
  E_QUALIFPIECE.OnEnter    := OnEnterQualifPiece ; // SBO 12/10/2004

  if (RupCycleRevision <> nil) and (G_CycleRevision <> nil) then // Vaut nil en G�n�ral par Auxiliaire
  begin
    RupCycleRevision.Enabled := VH^.Revision.Plan <> '';
    // GCO - 11/06/2007 - FQ 20630
    G_CycleRevision.Plus := ' AND CCY_EXERCICE = "' + VH^.EnCours.Code + '"';
    RupCycleRevision.OnClick := OnClickRupCycleRevision;
  end;  

  {$IFDEF GIL}
    SetControlProperty('TABDEV', 'TABVISIBLE', True);
  {$ELSE}
    SetControlProperty('TABDEV', 'TABVISIBLE', (V_PGI.Sav) and (V_PGI.PassWord = CryptageSt(DayPass(Date))));
  {$ENDIF}

  // GCO - 03/01/2007 - FQ 19375
  FBoOkDecoupage := True;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 07/11/2005
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.OnUpdate;
begin
  inherited;
  TFQRS1(Ecran).WhereSQL := FStWhereEtat + RenvoiOrderBy;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 28/11/2005
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.GenereCumulGL;
var lTobTemp : Tob;
begin
  if FTobBilanGestion = nil then
  begin
    FTobBilanGestion := Tob.Create('', nil, -1);
    lTobTemp := Tob.Create('', FTobBilanGestion, -1);
    lTobTemp.AddchampSupValeur('NATURE', 'BIL', False);
    lTobTemp := Tob.Create('', FTobBilanGestion, -1);
    lTobTemp.AddchampSupValeur('NATURE', 'CHA', False);
    lTobTemp := Tob.Create('', FTobBilanGestion, -1);
    lTobTemp.AddchampSupValeur('NATURE', 'PRO', False);
    lTobTemp := Tob.Create('', FTobBilanGestion, -1);
    lTobTemp.AddchampSupValeur('NATURE', 'EXT', False);
    lTobTemp.AddchampSupValeur('DEBIT', 0, True);
    lTobTemp.AddchampSupValeur('CREDIT', 0, True);
  end
  else
  begin
    FTobBilanGestion.PutValueAllFille('DEBIT', 0);
    FTobBilanGestion.PutValueAllFille('CREDIT', 0);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 21/12/2005
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.ControleAvantEdition;
var lStsql : string;
    lQuery : TQuery;
begin
  // Remplissage des bornes des comptes g�n�raux
  if (Trim(E_General.Text) = '') or (Trim(E_General_.Text) = '') then
  begin
    // JP 01/07/05 : on ne fait que l'auto-compl�tion que s'il n'y a pas de caract�re joker
    if not TestJoker(E_General.Text) then
    begin
      try
        lStSql := 'SELECT MIN(G_GENERAL)MINI, MAX(G_GENERAL)MAXI FROM GENERAUX ' +
                  'WHERE ' + E_General.Plus;

        lQuery := OpenSql( lStSql , True);
        if not lQuery.Eof then
        begin
          if Trim(E_General.Text) = '' then
            E_General.Text := lQuery.FindField('MINI').AsString;

          if Trim(E_General_.Text) = '' then
            E_General_.Text := lQuery.FindField('MAXI').AsString;
        end;

      finally
        Ferme(lQuery);
      end;
    end;
  end;

  if E_Exercice.ItemIndex = 0 then
  begin
    if (VH^.ExoV8.Code <> '') then
    begin
      if StrToDate(E_DateComptable.Text) < VH^.ExoV8.Deb then
      begin
        PgiInfo('Vous ne pouvez pas saisir une date inf�rieure au ' + DateToStr(VH^.ExoV8.Deb) + '.' + #13 + #10 +
                'La date a �t� modifi�e.', Ecran.Caption);
        E_DateComptable.Text := DateToStr(VH^.ExoV8.Deb);
      end;
    end
    else
    begin
      // GCO - 02/02/2003 FB 12796
      if StrToDate(E_DateComptable.Text) < VH^.Exercices[1].Deb then
      begin
        PgiInfo('Vous ne pouvez pas saisir une date inf�rieure au ' + DateToStr(VH^.Exercices[1].Deb) + '.' + #13 + #10 +
                'La date a �t� modifi�e.', Ecran.Caption);
        E_DateComptable.Text := DateToStr(VH^.Exercices[1].Deb);
      end;
    end;

    FExoDate := CtxExercice.QuelExoDate(StrToDate(E_DateComptable.Text));
  end
  else
  begin
    FExoDate := CtxExercice.QuelExoDate(CRelatifVersExercice(E_Exercice.Value));
    if (StrToDate(E_DateComptable.Text) < FExoDate.Deb) then
    begin
      PgiInfo('Vous ne pouvez pas saisir une date inf�rieure au ' + DateToStr(FExoDate.Deb) + '.' + #13 + #10 +
              'La date a �t� modifi�e.', Ecran.Caption);
      E_DateComptable.Text := DateToStr(FExoDate.Deb);
    end;
  end;

  // Correction du E_QUALIFPIECE, forc� � "N"
  if (E_QualifPiece.Text = '') then
    E_QualifPiece.Text := 'N;';
    
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 07/08/2003
Modifi� le ... : 12/07/2006
Description .. : Pr�pare les composants cach�s DEV
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.GestionCritereDEV;
begin
  // Init des CRI_ qui servent pour l'�tat avec le FExoDate
  AvecRupture.Text     := 'SANS' ;
  AvecRupType.Text     := '' ;
  AvecNivoRupture.Text := '0' ;
  XX_Rupture.Text      := '' ;
  OkEntete.Text        := 'X';
  OkResume.Text        := 'X'; 

  if E_Exercice.ItemIndex = 0 then
    Exercice.Text := '---'
  else
  begin
    Exercice.Text := FExoDate.Code;
  end;

  // Enregistrement de la date de d�but d'exercice s�l�ctionn�
  DateDebutExo.Text := DateToStr(FExoDate.Deb);

  // Affichage en DEVISE ou en DEVISEPIVOT
  RGDevise.Items[0] := '&' + VH^.LibDevisePivot;
  if (RGDevise.Enabled) and (RGDevise.ItemIndex = 1) then
  begin // Affichage en devise
    AFFDEVISE.Text := 'X';
    DEVPIVOT.Text  := TraduireMemoire('Devise');
  end
  else
  begin
    AFFDEVISE.Text := '-';
    DEVPIVOT.Text  := VH^.LibDevisePivot;
  end;

  // Rupture Param�trable
  if Rupture.Value <> 'SANS' then
  begin
    // GCO - 12/02/2007 - FQ 19352
    //if (RUPCYCLEREVISION <> nil) and (not RUPCYCLEREVISION.Checked) then
    //begin
      AvecRupType.Text := RuptureType.Value;
      AvecRupture.Text := Rupture.Value;
    //end;

    // Rupture sur Num�ro de Compte
    if (RuptureType.Value = 'RUPGROUPES') and (NivoRupture.Value > 0) then
      AvecNivoRupture.Text := IntToStr(NivoRupture.Value);

    // Rupture sur champ libre g�n�raux
    if (RuptureType.Value = 'RUPLIBRES') and (TableLibre.ItemIndex >= 0) then
      XX_Rupture.Text := 'G_TABLE' + GetNumTableLibre;

    // Rupture sur plan de correspondance
    if (RuptureType.Value = 'RUPCORRESP') and (Corresp.ItemIndex >= 0) then
    begin
      if Corresp.value = 'GE1' then
        XX_Rupture.Text := 'G_CORRESP1'
      else
        XX_Rupture.Text := 'G_CORRESP2';
    end;
  end; // Fin Rupture Param�trable

  (*
  // NE PAS IMPLEMENTER POUR LE MOMENT
  // GCO - 01/06/2006 - FQ 13051
  EtatIncomplet.Text := '-'; // Par d�faut

  // V�rification des g�n�raux
  if ExisteSQL('SELECT G_GENERAL FROM GENERAUX WHERE ' +
               'G_GENERAL >= "' + E_General.Text + '" AND ' +
               'G_GENERAL <= "' + E_General_.Text + '" AND ' +
               'G_CONFIDENTIEL > "' + V_PGI.Confidentiel + '"') then
    EtatIncomplet.Text := 'X';

  // Si les g�n�raux ne sont pas confidentiels, mais que c'est un GLGENEPARAUXI
  if (EtatIncomplet.Text = '-') and (FBoGeneParAuxi) then
  begin //V�rification des auxiliaires
    if ExisteSQL('SELECT T_AUXILIAIRE FROM TIERS WHERE ' +
                 'T_AUXILIAIRE >= "' + E_Auxiliaire.Text + '" AND ' +
                 'T_AUXILIAIRE <= "' + E_Auxiliaire_.Text + '" AND ' +
                 'T_CONFIDENTIEL > "' + V_PGI.Confidentiel + '"') then
      EtatInComplet.Text := 'X';
  end;
  *)
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... :   /  /
Modifi� le ... : 04/04/2005
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.OnLoad;
begin
  inherited;

  // Remplissage des Zones GENERAL ET AUXILIAIRE et V�rification des dates
  ControleAvantEdition;

  // Gestion des crit�res DEV
  GestionCritereDEV;

  FDateFinEdition := StrToDate(E_DateComptable_.Text);

  // Cr�ation de la requ�te des centralisations et insertion dans la table ECRITURE
  GestionCentralisation;

  // Cr�ation de la condition Where de l'�tat
  FStWhereEtat := GenereConditionWhereEtat;

  FStWhereEtat := CMajRequeteExercice (E_EXERCICE.Value, FStWhereEtat);

  // Calcul des Cumuls ANO et Cumuls Au de la bande �RG6 de l'�tat
  GenereCumulGL;

{$IFDEF EAGLCLIENT}

{$ELSE}
  // GCO - 20/12/2005 - Correction PB BDE si trop d'ecritures � imprimer 900000
  // GCO - 03/01/2007 - FQ 19375
  if FBoOkDecoupage then
    GestionTailleGrandLivre( FStWhereEtat );
{$ENDIF}

end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 17/02/2004
Modifi� le ... : 18/02/2004
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.OnNew;
begin
  inherited;
  SupprimeCentralisation;

  // Init des composants si pas de Filtre DEFAUT
  if FFiltres.Text = '' then
  begin
    YAXE.Value                := 'A1'; 
    ModeSelect.Value          := 'FOU';
    E_QualifPiece.Text        := 'N;';
    if (ComboEtab.Enabled) and (ComboEtab.ItemIndex < 0) then
      ComboEtab.ItemIndex := 0;
    E_Devise.ItemIndex := 0;
  end;

  OnChangeE_Devise( nil );
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 10/10/2007
Modifi� le ... : __/__/____
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.OnClose;
begin
  if Assigned(FTobBilanGestion) then FreeAndNil(FTobBilanGestion);
  SupprimeCentralisation;
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 26/10/2005
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOF_CPGLGESTION.OnExitE_DateComptable(Sender: TObject);
var lExoDate : TExoDate;
begin
  // GCO - 26/10/2005 - FQ 14967
  if E_Exercice.ItemIndex <> 0 then
    lExoDate := CtxExercice.QuelExoDate(CRelatifVersExercice(E_Exercice.Value));
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 26/10/2007
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOF_CPGLGESTION.OnChangeE_Exercice(Sender: TObject);
begin
  if E_Exercice.ItemIndex = 0 then
  begin
    if VH^.ExoV8.Code <> '' then
      E_DateComptable.Text := DateToStr(VH^.ExoV8.Deb)
    else
      // Date de d�but du premier Exercice
      E_DateComptable.Text := DateToStr(VH^.Exercices[1].Deb);
    E_DateComptable_.Text  := '30/12/2099';
  end
  else
    CExoRelatifToDates ( E_EXERCICE.Value, E_DATECOMPTABLE, E_DATECOMPTABLE_);
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 05/12/2002
Modifi� le ... :   /  /
Description .. : Changement de la Devise et
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.OnChangeE_Devise(Sender: TObject);
begin
  RGDevise.Enabled := (E_Devise.ItemIndex <> 0) and (E_Devise.Value <> V_PGI.DevisePivot);
  if E_Devise.ItemIndex = 0 then
    RGDevise.ItemIndex := 0;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 10/10/2007
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.OnClickRupture(Sender: TObject);
begin
  Ruptures.TabVisible := (Rupture.ItemIndex <> 0);
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 10/10/2007
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOF_CPGLGESTION.OnClickRuptureType(Sender: TObject);
begin
  RupGroupes.Visible := (RuptureType.ItemIndex = 0);
  RupLibres.Visible  := (RuptureType.ItemIndex = 1);
  RupCorresp.Visible := (RuptureType.ItemIndex = 2);

  if RuptureType.ItemIndex = 1 then
  begin
    TableLibre.ItemIndex := 0;
    OnChangeTableLibre(nil);
  end;

  if RuptureType.ItemIndex = 2 then
  begin
    if Corresp.Items.Count >= 1 then
      Corresp.ItemIndex := 1
    else
      Corresp.ItemIndex := 0;

    OnChangeCorresp(nil);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 10/10/2007
Modifi� le ... :   /  /
Description .. :
Mots clefs ... : 
*****************************************************************}
procedure TOF_CPGLGESTION.FTimerTimer(Sender: TObject);
begin
  if FCritEdtChaine <> nil then
  begin
    // GCO - 03/01/2007 - FQ 19375
    FBoOkDecoupage := False;

    with FCritEdtChaine do
    begin
      if CritEdtChaine.UtiliseCritStd then
      begin
        E_Exercice.Value      := CritEdtChaine.Exercice.Code;
        E_DateComptable.Text  := DateToStr(CritEdtChaine.Exercice.Deb);
        E_DateComptable_.Text := DateToStr(CritEdtChaine.Exercice.Fin);

        // GCO - 03/08/2007 - FQ 19377
        ModeSelect.Value      := CritEdtChaine.ModeSelection;
        E_QualifPiece.Value   := CritEdtChaine.TypeEcriture;
      end;
    end;
  end;
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 10/10/2007
Modifi� le ... : __/__/____
Description .. :
Mots clefs ... :
*****************************************************************}
function TOF_CPGLGESTION.RecupAutresCriteres : HString;
begin
  // Borne Max de E_DATECOMPTABLE
  Result := ' AND E_DATECOMPTABLE <="' + USDateTime(StrToDate(E_DateComptable_.Text)) + '"' ;

  // E_Exercice, E_DATECOMPTABLE ne peuvent etre pris par le RecupWhereCriteres
  Result := Result + ' AND E_DATECOMPTABLE >="' + USDateTime(StrToDate(E_DateComptable.Text)) + '"';

  if E_Exercice.ItemIndex <> 0 then // Tous
    Result := Result + ' AND E_EXERCICE ="' + cRelatifVersExercice(E_Exercice.Value) + '"';
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 10/10/2007
Modifi� le ... : __/__/____
Description .. : R�cup�re les crit�res communs � la condition WHERE
Mots clefs ... :
*****************************************************************}
function TOF_CPGLGESTION.RecupCriteresCommuns : HString;
var lStListeCptExcept    : string;
    lStCptExcept         : string;
    lStValEQualifPiece   : string;
    lStLibEQualifPiece   : string;
    lStTemp              : string;
begin
  Result := ' AND ' + ConvertitCaractereJokers(E_GENERAL, E_GENERAL_, 'G_GENERAL');

  // GCO - 11/07/2006 - FQ 18363
  lStTemp := RecupWhereCritere(Pages);
  if lStTemp <> '' then
    lStTemp := Copy(lStTemp, 6, length(lStTemp)); // D�gage le mot WHERE

  Result := Result + ' AND ' + lStTemp;

  // Prise en compte du VH^.ExoV8 afin de cacher les ecritures ant�rieures
  // uniquement en date de situation
  //if (CBEnSituation.Checked or AFFANOUVEAU.Checked) and (VH^.ExoV8.Code <> '') then
  //  Result := Result + ' AND E_DATECOMPTABLE >= "' + UsDateTime(VH^.ExoV8.Deb) + '" ';

  // S�lection du type d'�critures et  Traduction du E_QualifPiece
  TraductionTHMultiValComboBox( E_QualifPiece, lStValEQualifPiece, lStLibEQualifPiece, 'E_QUALIFPIECE', False, '"Z"');

  LibEQualifPiece.Text := lStLibEQualifPiece;

  if Trim(lStValEqualifPiece) <> '' then
    Result := Result + ' AND ' + lStValEQualifPiece;

  // Ecritures valid�es
  if ECRValide.State <> CbGrayed then
  begin
    if ECRValide.Checked then
      Result := Result + ' AND E_VALIDE = "X" '
    else
      Result := Result + ' AND E_VALIDE = "-" ';
  end;

  // Ecritures Lettr�s
  if ECRLettre.State <> CbGrayed then
  begin
    if ECRLettre.Checked then
      Result := Result + ' AND (E_ETATLETTRAGE = "TL" OR E_ETATLETTRAGE = "PL") '
    else
      Result := Result + ' AND (E_ETATLETTRAGE = "RI" OR E_ETATLETTRAGE = "AL" ) ';
  end;

  // Ecritures Point�es
  if ECRPointe.State <> CbGrayed then
  begin
    if ECRPointe.Checked then
      Result := Result + ' AND E_REFPOINTAGE <> "" '
    else
      Result := Result + ' AND E_REFPOINTAGE = "" ';
  end;

  // (D�bit <> 0 ou Cr�dit <> 0) et (Ecritures non d�truites)
  Result := Result + ' AND (E_DEBIT <> 0 OR E_CREDIT <> 0) AND E_CREERPAR <> "DET"' ;

  if (RupCycleRevision <> nil) and
     (RupCycleRevision.Checked) and
     (G_CycleRevision.Text <> '')then
  begin
    if TestJoker(G_CycleRevision.Text) then // GCO - 14/09/2007 - FQ 20913
      Result := Result + ' AND ' + ClauseAvecJoker(G_CycleRevision.Text, 'G_CYCLEREVISION')
    else
      Result := Result + ' AND G_CYCLEREVISION LIKE "' + G_CycleRevision.Text + '%"';
  end;

  // Comptes d'exceptions (les comptes peuvent �tre s�par�s par des ',' ou ';')
  if CptExcept.Text <> '' then
  begin
    lStListeCptExcept := FindEtReplace(CptExcept.Text, ',', ';', True);
    while (lStListeCptExcept <> '') do
    begin
      lStCptExcept := Trim(ReadTokenSt(lStListeCptExcept));
      if lStCptExcept <> '' then
        Result := Result + ' AND G_GENERAL NOT LIKE "' + lStCptExcept + '%"';
    end;
  end;

  // Gestion du V_Pgi.Confidentiel
  Result := Result + ' AND ' + CGenereSQLConfidentiel('G');

  // Rupture Param�trable
  if Rupture.Value <> 'SANS' then
  begin
    // Rupture sur champ libre g�n�raux
    if (RuptureType.Value = 'RUPLIBRES') and (TableLibre.ItemIndex >= 0) then
    begin
      if CPTLibreExist.Checked then
      begin
        // GCO - 04/09/2006 - FQ 18432
        Result := Result + ' AND G_TABLE' + GetNumTableLibre + ' <> ''';

        if Trim(LibreDe.Text) <> '' then
          Result := Result + ' AND G_TABLE' + GetNumTableLibre + '>= "' + LibreDe.Text + '"';

        if Trim(LibreA.Text) <> '' then
          Result := Result + ' AND G_TABLE' + GetNumTableLibre + '<= "' + LibreA.Text + '"';
      end;
    end;

    // Rupture sur plan de correspondance
    if (RuptureType.Value = 'RUPCORRESP') and (Corresp.ItemIndex >= 0) then
    begin
      if CPTCorrespExist.Checked then
      begin
        if Corresp.Value = 'GE1' then
        begin
          // GCO - 04/09/2006 - FQ 18432
          Result := Result + ' AND G_CORRESP1 <> ''';

          if Trim(CorrespDe.Text) <> '' then
            Result := Result + ' AND G_CORRESP1 >= "' + CorrespDe.Text + '"';

          if Trim(CorrespA.Text) <> '' then
            Result := Result + ' AND G_CORRESP1 <= "' + CorrespA.Text + '"';
        end
        else
        begin
          // GCO - 04/09/2006 - FQ 18432
          Result := Result + ' AND G_CORRESP2 <> ''';

          if Trim(CorrespDe.Text) <> '' then
            Result := Result + ' AND G_CORRESP2 >= "' + CorrespDe.Text + '"';

          if Trim(CorrespA.Text) <> '' then
            Result := Result + ' AND G_CORRESP2 <= "' + CorrespA.Text + '"';
        end;
      end;
    end;
  end; // Fin Rupture Param�trable
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 05/08/2003
Modifi� le ... :   /  /
Description .. : Changement de la rupture sur les plans de correspondance
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.OnChangeCorresp(Sender: TObject);
begin
  if RuptureType.value <> 'RUPCORRESP' then Exit;
  CorrespToCodes(Corresp,TComboBox(CorrespDe),TComboBox(CorrespA));
  CorrespDe.ItemIndex := 0 ;
  CorrespA.ItemIndex  := CorrespA.Items.Count - 1 ;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 05/08/2003
Modifi� le ... :   /  /    
Description .. : Changement de la rupture sur les Tables Libres
Mots clefs ... : 
*****************************************************************}
procedure TOF_CPGLGESTION.OnChangeTableLibre(Sender: TObject);
begin
  if TableLibre.ItemIndex < 0 then
  begin
    LibreDe.DataType := '';
    LibreA.DataType  := '';
    LibreDe.Text     := '';
    LibreA.Text      := '';
  end
  else
  begin
    LibreDe.DataType := 'TZNATGENE' + GetNumTableLibre;
    LibreA.DataType  := 'TZNATGENE' + GetNumTableLibre;
    //LibreDe.Text     := '';
    //LibreA.Text      := '';
  end;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 12/09/2003
Modifi� le ... : 12/09/2003
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.OnExitE_General(Sender: TObject);
begin
  // GCO - 04/09/2007 - FQ 21324
  if (csDestroying in Ecran.ComponentState) then Exit;

  if Trim(THEdit(Sender).Text) = '' then Exit;

  {JP 01/07/05 : on ne fait que l'auto-compl�tion que s'il n'y a pas de caract�re joker}
  if HasJoker(Sender) then Exit;

  if ExisteSql('SELECT G_GENERAL FROM GENERAUX WHERE G_GENERAL = "' + BourreEtLess(THEdit(Sender).Text, fbGene) + '"') then
  begin
    if Length(THEdit(Sender).Text) < VH^.Cpta[fbGene].Lg then
      THEdit(Sender).Text := BourreEtLess( THEdit(Sender).Text, fbGene);
  end
  else
    THEdit(Sender).ElipsisClick(nil);
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 20/12/2005
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.GestionCentralisation;
begin
  SupprimeCentralisation;
  if AFFCentra.Checked then
  begin
    if Transactions( EffectueCentralisation, 1 ) <> OeOk then
    begin
      PgiInfo('Erreur lors de la centralisation', Ecran.Caption);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 01/10/2003
Modifi� le ... :   /  /
Description .. : Supprime les �critures de centralisation g�n�r�es par les
Suite ........ : grand livres dont le E_Qualifpiece="Z"
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.SupprimeCentralisation;
begin
  try
    if CEstBloqueGLGene then
    begin
      BeginTrans;
      ExecuteSQL('DELETE FROM ECRITURE WHERE E_QUALIFPIECE="Z" AND E_UTILISATEUR = "' + V_PGI.User + '"');
      CDeBlocageGLGene; // Suppression du verrou dans la Table COURRIER
      CommitTrans;
    end;
  except
    on E: Exception do
    begin
      PgiError('Impossible de supprimer les enregistrements temporaires du Grand Livre', Ecran.Caption);
      RollBack;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 11/05/2004
Modifi� le ... :   /  /
Description .. : Effectue la centralisation des �critures dans la TABLE ECRITURES
suite ........ : en cr�ant des mouvements typ�s Z dans E_QUALIFPIECE
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.EffectueCentralisation;
var
  lQuery         : TQuery;
  lStSql         : string;
  lSt            : string;
  //lStTemp        : string;
  lStPeriode     : string;
  lDateFinDeMois : TDateTime;
  lNumLigne      : Integer;
  lNumeroPiece   : Integer;
begin
  try
    try
      lQuery := OpenSql('SELECT MAX(E_NUMEROPIECE) LENUM FROM ECRITURE WHERE E_QUALIFPIECE = "Z"', True);
      if lQuery.FindField('LENUM').AsInteger <> 0 then
        lNumeroPiece := lQuery.FindField('LENUM').AsInteger
      else
        lNumeroPiece := 1;
      Ferme(lQuery);

      // Requ�te des �critures centralis�es
      lStSql := 'SELECT DISTINCT E_GENERAL, ' + 
                'E_EXERCICE, E_PERIODE, E_JOURNAL, E_DEVISE, E_ETABLISSEMENT, ' +
                'SUM(E_DEBIT) DEBIT, SUM(E_CREDIT) CREDIT, ' +
                'SUM(E_DEBITDEV) DEBITDEV, SUM(E_CREDITDEV) CREDITDEV FROM ECRITURE ' +
                'LEFT JOIN GENERAUX ON G_GENERAL = E_GENERAL ' +
                'LEFT JOIN JOURNAL  ON J_JOURNAL = E_JOURNAL ' +
                'WHERE J_CENTRALISABLE = "X" AND G_CENTRALISABLE = "X"';

      lStSql := lStSql + ' AND G_VENTILABLE' + Copy(YAxe.Value, 2, 1) + '= "-"';

      lStSql := lStSql + ' '+ RecupAutresCriteres + RecupCriteresCommuns +
                ' GROUP BY E_GENERAL, ' +
                'E_EXERCICE, E_PERIODE, E_JOURNAL, E_DEVISE, E_ETABLISSEMENT ' +
                'ORDER BY E_GENERAL, E_EXERCICE, E_PERIODE, E_JOURNAL';

      lQuery := OpenSql(lStSql, True);
      if not lQuery.Eof then
      begin
        // Cr�ation d'un verrou en Table COURRIER pour la pr�sence de
        // Centralisation Mensuelle dans la Table ECRITURE
        CBlocageGLGene;
        InitMoveProgressForm(Ecran, Ecran.Caption, 'Traitement des centralisations en cours...', RecordsCount(lQuery), True, True);

        lNumLigne := 1;
        while not lQuery.Eof do
        begin
          if not MoveCurProgressForm('Compte ' + lQuery.FindField('E_GENERAL').AsString + ' - ' + 'Centralisation Mensuelle') then
            Break;

          lStPeriode := IntToStr(lQuery.FindField('E_PERIODE').AsInteger);
          lDateFinDeMois := StrToDate('01/' + Copy(lStPeriode, 5, 2) + '/' +  Copy(lStPeriode, 1, 4));
          lDateFinDeMois := FinDeMois(ldateFinDeMois);

          lSt := 'INSERT INTO ECRITURE (E_UTILISATEUR, E_GENERAL, E_EXERCICE, E_JOURNAL, ' +
                 'E_DATECOMPTABLE, E_PERIODE, E_QUALIFPIECE, E_LIBELLE, E_DATEMODIF, ' +
                 'E_NUMEROPIECE, E_NUMLIGNE, E_NUMECHE, E_ECRANOUVEAU,' +
                 'E_DEBIT, E_CREDIT, E_DEBITDEV, E_CREDITDEV, E_CONFIDENTIEL, E_CREERPAR, ' +
                 'E_QTE1, E_QTE2, E_DATEECHEANCE, E_DEVISE, E_ETABLISSEMENT, E_ETATLETTRAGE) ' +
                 'VALUES (' +
                 '"' + string(V_PGI.User) + '",' +
                 '"' + lQuery.FindField('E_GENERAL').AsString + '",';

          lSt := lSt + '"' + lQuery.FindField('E_EXERCICE').AsString + '",' +
                 '"' + lQuery.FindField('E_JOURNAL').AsString + '",' +
                 '"' + UsDateTime(lDateFinDeMois) + '",' +
                 '"' + lQuery.FindField('E_PERIODE').AsString + '",' +
                 '"Z", "Centralisation mensuelle",' +
                 '"' + UsDateTime(lDateFinDeMois) + '",' +
                 IntToStr( lNumeroPiece ) + ',' + IntToStr(lNumLigne) + ', 0, "N",' +
                 VariantToSql(lQuery.FindField('DEBIT').AsFloat) + ',' +
                 VariantToSql(lQuery.FindField('CREDIT').AsFloat) + ',' +
                 VariantToSql(lQuery.FindField('DEBITDEV').AsFloat) + ',' +
                 VariantToSql(lQuery.FindField('CREDITDEV').AsFloat) + ',' +
                 '"0", "SAI", ' + // E_CONFIDENTIEL A ZERO, E_CREERPAR = SAI
                 '"0", "0", "' + UsDateTime( iDate1900 ) + '",' +
                 '"' + lQuery.FindField('E_DEVISE').AsString + '",' +
                 '"' + lQuery.FindField('E_ETABLISSEMENT').AsString + '", "RI")';

          ExecuteSql(lSt);
          Inc(lNumLigne);
          lQuery.Next;
        end;
      end;
    except
      on E: Exception do PgiError(E.Message, Ecran.Caption);
    end;
  finally
    Ferme(lQuery);
    FiniMoveProgressForm;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 01/04/2004
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
function TOF_CPGLGESTION.CEstBloqueGLGene: Boolean;
var lStSql  : string ;
    lQuery  : TQuery ;
begin
  Result := False;

  lStSql := 'SELECT MG_EXPEDITEUR FROM COURRIER WHERE ' +
            'MG_UTILISATEUR = "' + W_W + '" AND MG_TYPE=4000 AND ' +
            'MG_EXPEDITEUR = "' + String(V_PGI.User) + '"';

  lQuery := nil;
  try
    try
      lQuery := OpenSql(lStSql,True) ;
      Result := not lQuery.Eof ;
    except
      on E: Exception do PgiError('Erreur de requ�te SQL : ' + E.Message, 'Fonction : CEstBloqueGLGene');
    end;
  finally
    Ferme(lQuery);
  end;
end ;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 01/04/2004
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.CBlocageGLGene;
begin
  try
    if not CEstBloqueGLGene then
    begin
      ExecuteSQL('INSERT INTO COURRIER(MG_UTILISATEUR, MG_TYPE, MG_LIBELLE, '+
                 'MG_DATE, MG_EXPEDITEUR) VALUES("' + W_W + '",4000, ' +
                 '"Centralisation Mensuelle","'+USTime(Now)+'","' + V_PGI.User + '")');
    end;
  except
    on E: Exception do PgiError('Erreur de requ�te SQL : ' + E.Message, 'Fonction : CBlocageGLGene');
  end;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 01/04/2004
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.CDeBlocageGLGene;
begin
  try
    ExecuteSQL('DELETE FROM COURRIER WHERE MG_UTILISATEUR = "' + W_W + '" ' +
               'AND MG_TYPE=4000 ' +
               'AND MG_EXPEDITEUR = "' + String(V_PGI.User) + '"');
  except
    on E: Exception do PgiError('Erreur de requ�te SQL : ' + E.Message, 'Fonction : CDeBlocageGLGene');
  end;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 17/01/2006
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOF_CPGLGESTION.OnChangeFiltre(Sender: TObject);
begin
  inherited;
  CExoRelatifToDates(E_EXERCICE.Value, E_DATECOMPTABLE, E_DATECOMPTABLE_, True);
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 12/10/2004
Modifi� le ... :   /  /
Description .. : Afin de rendre apparent le focus sur la
Suite ........ : THMultiValComboBax, car en readOnly, on perd le curseur
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.OnEnterQualifPiece(Sender: TObject);
begin
  CSelectionTextControl( Sender ) ;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 14/04/2005
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOF_CPGLGESTION.OnClickRupCycleRevision(Sender: TObject);
begin
  G_CycleRevision.Enabled := (RupCycleRevision.Checked);
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 06/09/2005
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOF_CPGLGESTION.ChargementCritEdt;
begin
  inherited;

  if (TheData <> nil) and (TheData is (ClassCritEdt)) then
  begin
    E_General.Text  := ClassCritEdt(TheData).CritEdt.Cpt1;
    E_General_.Text := ClassCritEdt(TheData).CritEdt.Cpt2;
    E_Exercice.Value := CExerciceVersRelatif(ClassCritEdt(TheData).CritEdt.Exo.Code);

    // Date de D�but de l'�dition
    E_DateComptable.Text  := DateToStr(ClassCritEdt(TheData).CritEdt.Date1);

    // Date de Fin de l'�dition
    E_DateComptable_.Text := DateToStr(ClassCritEdt(TheData).CritEdt.Date2);

    // Num�ro de Pi�ce
    //JP 26/08/04 : FQ 14062 : avec l'autocompl�tion, si NumPiece1 = 0 et NumPiece2 = 9999999,
    //                         on se retrouve E_NUMEROPIECE � 99999999
    // GCO - 05/09/2005 - FQ 16320
    if ClassCritEdt(TheData).CritEdt.GL.NumPiece1 > 0 then
      E_NUMEROPIECE.Text  := IntToStr(ClassCritEdt(TheData).CritEdt.GL.NumPiece1);

    if ClassCritEdt(TheData).CritEdt.GL.NumPiece2 > 0 then
      E_NUMEROPIECE_.Text := IntToStr(ClassCritEdt(TheData).CritEdt.GL.NumPiece2);


    // GCO - 26/12/2005 - FQ 11773
    AffCentra.Checked   := ClassCritEdt(TheData).CritEdt.GL.AvecDetailCentralise;

    // R�f�rence Interne
    E_REFINTERNE.Text := ClassCritEdt(TheData).CritEdt.ReferenceInterne;

    // E_Qualifpi�ce
    E_QUALIFPIECE.Text := FindEtReplace(ClassCritEdt(TheData).CritEdt.QualifPiece, '!', ';', True);

    // Etablissement
    ComboEtab.Value := ClassCritEdt(TheData).CritEdt.Etab;

    // Devise
    E_DEVISE.Value := ClassCritEdt(TheData).CritEdt.DeviseSelect;

    // Ecritures valid�es ( '' = Grayed, OUI = Checked sinon not Checked
    if (ClassCritEdt(TheData).CritEdt.Valide = '') then
      ECRVALIDE.State := cbGrayed
    else
      ECRVALIDE.Checked := (ClassCritEdt(TheData).CritEdt.Valide = 'OUI');

    // Ecritures Lettr�es ( 0 = Grayed, 1 = not Checked sinon 2 = Checked
    if (ClassCritEdt(TheData).CritEdt.GL.Lettrable = 0) then
      ECRLETTRE.State   := cbGrayed
    else
      ECRLETTRE.Checked := (ClassCritEdt(TheData).CritEdt.GL.Lettrable = 2);

    // Cycle de r�vision pour le GL G�n�ral uniquement
    if (ClassCritEdt(TheData).CritEdt.GL.CycleDeRevision <> '') and
       (RupCycleRevision <> nil) and
       (G_CycleRevision <> nil) then
    begin
      Rupture.ItemIndex := 1;
      RupCycleRevision.Checked := True;
      G_CycleRevision.Text := ClassCritEdt(TheData).CritEdt.GL.CycleDeRevision;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 20/10/2005
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOF_CPGLGESTION.MySelectFiltre;
var lExoDate : TExoDate;
begin
  inherited;
  lExoDate := CtxExercice.QuelExoDate(CRelatifVersExercice(E_Exercice.Value));

  if (CtxExercice.QuelExo(E_DateComptable.Text, False) <> lExoDate.Code) and
     (CtxExercice.QuelExo(E_DateComptable_.Text, False) <> lExoDate.Code) then
  begin
    CExoRelatifToDates(E_EXERCICE.Value, E_DATECOMPTABLE, E_DATECOMPTABLE_);
  end;

  // GCO - 30/07/2007 - FQ 21180
  if E_QUALIFPIECE.Value = '' then
  begin
    E_Qualifpiece.SelectAll;
    E_Qualifpiece.Text := TraduireMemoire('<<Tous>>');
  end;

  (*
  // SBO - 20/08/2007 - FQ 21250 ( violation d'acc�s en cr�ation de filtre )
  if (G_CycleRevision<>nil) and (G_CycleRevision.Value = '') then
  begin
    G_CycleRevision.SelectAll;
    G_CycleRevision.Text := TraduireMemoire('<<Tous>>');
  end;*)
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 10/10/2007
Modifi� le ... : __/__/____
Description .. :
Mots clefs ... :
*****************************************************************}
{$IFDEF EAGLCLIENT}
{$ELSE}
procedure TOF_CPGLGESTION.GestionTailleGrandLivre( vStwhereCritere : HString );
var lStSelect   : string;          //
    lStGroupBy  : string;          //
    lStMini     : string;          //
    lStCompte   : string;          // Fourchette de comte que l'on ajoute au Where
    lStFileName : string;          // Nom du fichier temp du PDFBatch
    lBoOldNoPrintDialog : Boolean; //
    lBoOldQRPdf         : Boolean;
    lBoAbort            : Boolean;
    lNumPage, lNbEcr, i : integer; //
    lTotalPage : integer;
    lNbEcrMax           : integer; // Nombre d'�critures MAX avant de couper le GL
    lTobTrancheCompte   : Tob;     // Liste des fourchettes de Compte
    lTobDecoupage       : Tob;     // Nb d'�critures � imprimer par Compte
    lTobTemp            : Tob;     // Tob de Traitement
begin
  TFQRS1(Ecran).OnValideCritereEvent := nil; // Conditionne le Critok du TQRS1

  lBoAbort := False;

  lTobTrancheCompte := Tob.Create('', nil, -1);

  lStSelect  := 'SELECT E_GENERAL';
  lStGroupBy := ' GROUP BY E_GENERAL';

  lStSelect := lStSelect + ', COUNT(*) TOTAL FROM GENERAUX ' +
               'LEFT JOIN ECRITURE ON E_GENERAL = G_GENERAL ' +
               'LEFT JOIN ANALYTIQ ON Y_GENERAL = E_GENERAL AND ' +
               'Y_JOURNAL = E_JOURNAL AND Y_EXERCICE = E_EXERCICE AND ' +
               'E_DATECOMPTABLE = Y_DATECOMPTABLE AND ' +
               'Y_NUMEROPIECE = E_NUMEROPIECE AND ' +
               'Y_NUMLIGNE = E_NUMLIGNE AND Y_AXE = "' + YAxe.Value + '" ' +
               'LEFT JOIN JOURNAL ON J_JOURNAL  = E_JOURNAL ' +
               'LEFT JOIN SECTION ON S_SECTION = Y_SECTION WHERE ';

  lTobDecoupage := Tob.Create('', nil, -1);
  lTobDecoupage.LoadDetailFromSQL( lStSelect + vStWhereCritere + lStGroupBy + ' ORDER BY E_GENERAL');

  // GCO - 26/12/2005 - D�coupage possible si au moins deux comptes �dit�s
  if lTobDecoupage.Detail.Count > 1 then
  begin
    lNbEcr := 0;
    lNbEcrMax := GetSynRegKey('CPGLENREGMAX', cNbEcrMax, True);

    lStMini := E_General.Text;
    for i := 0 to lTobDecoupage.Detail.Count-1 do
    begin
      lNbEcr := lNbEcr + lTobDecoupage.Detail[i].GetInteger('TOTAL');
      if lNbEcr >= lNbEcrMax then
      begin
        lNbEcr := 0;
        lTobTemp := Tob.Create('', lTobTrancheCompte, -1);
        lTobTemp.AddChampSupValeur('MINI', lStMini);
        lTobTemp.AddChampSupValeur('MAXI', lTobDecoupage.Detail[i].GetString('E_GENERAL'));
        if i <> lTobDecoupage.Detail.Count-1 then
          lStMini := lTobDecoupage.Detail[i+1].GetString('E_GENERAL')
        else
          lStMini := E_General_.Text; // Derni�re ligne
      end;
    end;

    // Faut Faire la derni�re tranche
    if lTobTrancheCompte.Detail.Count <> 0 then
    begin
      lTobTemp := Tob.Create('', lTobTrancheCompte, -1);
      lTobTemp.AddChampSupValeur('MINI', lStMini);
      lTobTemp.AddChampSupValeur('MAXI', E_General_.Text);
    end;

    // Edition d�coup�e de l'�tat
    if lTobTrancheCompte.Detail.Count <> 0 then
    begin
      lBoOldNoPrintDialog := V_Pgi.NoPrintDialog;
      lBoOldQRPdf         := V_Pgi.QRPdf;

      V_Pgi.QRPdf := True;

      // CritOk devient FALSE, Plus de OnUpdate pour le QRS1
      TFQRS1(Ecran).OnValideCritereEvent := OnMyValideCritereEvent;

      lStFileName := TempFileName();
    {$IFDEF EAGLCLIENT}
      StartPdfBatch(lStFileName);
    {$ELSE}
      THPrintBatch.StartPdfBatch(lStFileName);
    {$ENDIF}

      // Changement de la CLAUSE WHERE de l'�tat
      lTotalPage := 0;
      for i := 0 to lTobTrancheCompte.Detail.count -1 do
      begin
        if not lBoAbort then
        begin
          OkEntete.Text := IIF(i = 0, 'X', '-');
          OkResume.Text := IIF(i = lTobTrancheCompte.Detail.count -1, 'X', '-');
          lStCompte := ' AND G_GENERAL >= "' + lTobTrancheCompte.Detail[i].GetString('MINI') + '" AND ' +
                       'G_GENERAL <= "' + lTobTrancheCompte.Detail[i].GetString('MAXI') + '"';

        {$IFDEF EAGLCLIENT}
          lNumPage := LanceEtatTob('E', TFQRS1(Ecran).NatureEtat, TFQRS1(Ecran).CodeEtat, nil, CBPreview.Checked, False, False, Pages, FStWhereEtat + lStCompte + RenvoiOrderBy, Ecran.caption, False,0, '', lTotalPage);
        {$ELSE}
          lNumPage := LanceEtatTob('E', TFQRS1(Ecran).NatureEtat, TFQRS1(Ecran).CodeEtat, nil, CBPreview.Checked, False, False, Pages, FStWhereEtat + lStCompte + RenvoiOrderBy, Ecran.caption, False,0,'',nil, lTotalPage);
        {$ENDIF}
          // GCO - 13/09/2006 - FQ 18667
          lTotalPage := lTotalPage + lNumPage;

          if lNumPage = -1 then
            lBoAbort := True;

          if not CBPreview.Checked then
            V_PGI.NoPrintDialog := True;

          THPrintBatch.AjoutPdf(V_PGI.QrPdfQueue, True);
        end;
      end;

    {$IFDEF EAGLCLIENT}
      CancelPDFBatch;
    {$ELSE}
      THPrintBatch.StopPdfBatch();
    {$ENDIF}

      if CbPreview.Checked then
        PreviewPDFFile(Ecran.Caption, lStFileName, True)
      else
        PrintPDF(lStFileName, Printer.Printers[Printer.PrinterIndex], '');

      // Remise en place du Contexte
      V_Pgi.NoPrintDialog := lBoOldNoPrintDialog;
      V_Pgi.QRPdf := lBoOldQRPdf;
    end;
  end;

  FreeAndNil(lTobDecoupage);
  FreeAndNil(lTobTrancheCompte);
end;
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 20/12/2005
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
function OnMyValideCritereEvent : Boolean;
begin
  Result := False;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 10/10/2007
Modifi� le ... : __/__/____
Description .. :
Mots clefs ... :
*****************************************************************}
function TOF_CPGLGESTION.RenvoiOrderBy : HString;
begin
  Result := ' ORDER BY ';

  if (RupCycleRevision <> nil) and (RupCycleRevision.Checked) then
    Result := Result + ' G_CYCLEREVISION,';

  if not ((Rupture.ItemIndex = 0) or
         ((Rupture.ItemIndex <> 0) and (RuptureType.ItemIndex = 0))) then
  begin
    Result := Result + XX_Rupture.Text + ', ';
  end;

  Result := Result + 'E_GENERAL, ';

  // Probl�me SIC, on trie sur l'index E_EXERCICE, E_DATECOMPTABLE d�s qu'un
  // exercice est s�lectionn�.
  // GCO - 25/05/2005 - FQ 15707 - Pas de tri sur exercice si un exo selectionn�
  // et A-Nouveaux d�taill�s.
  if (E_Exercice.ItemIndex = 0) then
    Result := Result + 'E_DATECOMPTABLE,E_EXERCICE,'
  else
    Result := Result + 'E_EXERCICE,E_DATECOMPTABLE,';

  Result := Result + 'E_PERIODE, E_JOURNAL, E_NUMEROPIECE, E_NUMLIGNE';
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 10/10/2007
Modifi� le ... : __/__/____
Description .. : La requ�te va se pr�senter sous cette forme WHERE
Suite ........ : ((1) or (2) or (3)) AND Criteres Communs
Mots clefs ... :
*****************************************************************}
function TOF_CPGLGESTION.GenereConditionWhereEtat : HString;
begin
  Result := '(';
  
  // (1) Termin� ((D�tail ANO) si coch�)

  // D�but de r�cup�ration des �critures A-Nouveaux PGI(2)
  // Toujours r�cup�r� l'ANO pour forcer une rupture dans l'�tat
  Result := Result + '(';
  Result := Result + 'E_DATECOMPTABLE >= "' + UsDateTime(StrToDate(DateDebutExo.Text)) + '"'
                   + ' AND E_QUALIFPIECE = "N"';

  if E_Exercice.ItemIndex <> 0 then
  begin
    Result := Result + ' AND E_EXERCICE="' + CRelatifVersExercice(E_EXERCICE.Value) + '" AND ' +
                       'E_DATECOMPTABLE <= "' + UsDateTime(StrToDate(E_DateComptable.Text)) + '"'
  end;


  Result := Result + ' AND (E_ECRANOUVEAU="OAN" OR E_ECRANOUVEAU="H")';

  Result := Result + ') OR ';
  // (2) Termin� ( OAN )

  // D�but de R�cup�ration des �critures concern�es par les crit�res (3)
  Result := Result + '(E_ECRANOUVEAU = "N"';

  // Si centralisation des �critures, plus la peine de r�cup�rer les ECR dont le
  // Compte et le journal sont centralisatibles, car celles ci sont cr�er une
  // seule �criture Typ� E_QUALIFPIECE = "Z" ( voir EffectueCentralisation )
  if AffCentra.Checked then
    Result  := Result  + ' AND ((G_CENTRALISABLE = "-" OR J_CENTRALISABLE = "-") OR ' +
               'G_VENTILABLE' + Copy(YAxe.Value, 2, 1) + '= "X")';

  Result := Result  + ' ' + RecupAutresCriteres ;
  // (3) Termin�

  Result := Result + ')';

  // Ajout des �critures de Centralisation dans la condition Where de la requ�te
  // On ne prend que les Ecritures "Z" du User, en effet plusieurs utilisateurs
  // peuvent faire un grand livre avec centralisation en m�me temps.
  if AFFCentra.Checked then
    Result := Result + ' OR (E_QUALIFPIECE="Z" AND E_UTILISATEUR = "' + string(V_PGI.User) + '")';

  // Fermeture dela parenth�se principale qui englobe tous les ( (1) OR (2) OR (3) )
  Result := Result + ')';

  // Ajout des crit�res communs
  Result := Result + RecupCriteresCommuns;

  Result := Result + RecupCriteresModeSelection(Result);
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 27/03/2006
Modifi� le ... :   /  /
Description .. : 
Mots clefs ... : 
*****************************************************************}
function TOF_CPGLGESTION.RecupCriteresModeSelection( vStWhereEtat : HString ) : HString;
begin
  Result := '';

  if ModeSelect.Value = 'FOU' then
    Exit; // Tous les Comptes

  // Mode de s�lection
  if ModeSelect.Value = 'EXO' then
  begin // Comptes mouvement�s sur l'exercice
    Result := Result + ' AND (E_GENERAL IN (SELECT DISTINCT E_GENERAL FROM ECRITURE WHERE ' +
              vStWhereEtat + '))';
  end
  else
  if ModeSelect.Value = 'NSL' then
  begin // Comptes non sold�s
    Result := Result + ' AND (E_GENERAL IN (SELECT DISTINCT E_GENERAL FROM ECRITURE WHERE ' +
              vStWhereEtat + ' GROUP BY E_GENERAL HAVING SUM(E_DEBIT) <> SUM( E_CREDIT))) ';
  end
  else
  if ModeSelect.Value = 'PER' then
  begin // Comptes mouvement�s sur la p�riode
    Result := Result + ' AND (E_GENERAL IN (SELECT DISTINCT E_GENERAL FROM ECRITURE WHERE ' +
              vStWhereEtat + '))';
  end;
end;

////////////////////////////////////////////////////////////////////////////////

Initialization
  registerclasses ( [ TOF_CPGLGESTION ] ) ;
end.
