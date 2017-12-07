unit dpTOFAnnuaire;
// TOF du Multi-crit�re DP LIENANNUAIRE et JUR ANNUAIRE_SEL

interface
uses StdCtrls, Controls, Classes, Windows, forms, sysutils,
  ComCtrls, HCtrls, HEnt1, HMsgBox, UTOF, Menus,
{$IFDEF EAGLCLIENT}
  MaineAgl, eMul,utilEagl,
{$ELSE}
  Fe_Main, HDB, Mul, EdtrEtat,
{$ENDIF}
  utob, HTB97, AGLInit; // $$$ JP 09/01/06 - utob pour tous!

type
  TOF_ANNUAIRE = class(TOF)
  public
    procedure OnArgument(Arguments: string); override;
    procedure OnLoad; override;

  private
    sWhere_Emetteur, sWhere_Dossiers, sWhere_FamPer, sWhere_ClientProspect: string;
    LastFamPer, LastFamPlus: string; // derniers crit�res � r�tablir
    FamPerChangeEvent: TNotifyEvent;
    sChaineRetour : String; // FQ 11523

    m_MnRepSep: TMenuItem;
    m_MnRep: TMenuItem; // $$$ JP 09/01/06 - pour appeller le tel 1 si CTI actif

    procedure ANNFamper_OnChange(Sender: TObject);
    procedure bContacts_OnClick(Sender: TObject);
    procedure bLiens_OnClick(Sender: TObject);
    procedure FListe_OnDblClick(Sender: TObject);
    procedure BINSERT_OnClick(Sender: TObject);
    procedure BTANNUAIRE_OnClick(Sender: TObject);
    procedure BDELETE_OnClick(Sender: TObject);
    procedure BIMPRIMER_OnClick(Sender: TObject);
    procedure BDUPLIQUER_OnClick(Sender: TObject);
    procedure CHKINTVDISPO_OnClick(Sender: TObject);
    procedure CHKINTVDOSSIER_OnClick(Sender: TObject);
    procedure CHKCLIENTPROSPECT_OnClick(Sender: TObject);
    procedure GereIntvDispo;
    procedure ResetTimer(Sender: TObject);
    function ListeCorrecte(nomchp, titrechp: string): Boolean;
    procedure Form_OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    // $$$ JP 09/01/06 - pour r�pertoire t�l�phonique dans menu contextuel
    procedure MajMenuRepertoireTel(sGuidPer: string);

    procedure OnPopupAnn(Sender: TObject);
{$IFDEF BUREAU}
    procedure MContactClick(Sender: TObject);
{$ENDIF BUREAU}
  end;


///////////////// IMPLEMENTATION //////////////////
implementation

uses AnnOutils, galOutil,

     {$IFDEF VER150}
     Variants,
     {$ENDIF}

     dpOutils
{$IFDEF BUREAU}
  , galMenuDisp // $$$ JP 06/01/06 - pour SmallImages
  , entDP // $$$ JP 06/01/06 - pour VH_DP.ctiAlerte
{$ENDIF}
  ;

procedure TOF_ANNUAIRE.OnArgument(Arguments: string);
// par d�faut : re�oit dans Arguments le code famille de personne (xx_FAMPER)
var FamPer: string;
{$IFDEF BUREAU}
  POP: TPopUpMenu;
{$ENDIF}
  i: Integer;

  sGuidPerDos_l: string;

begin
  inherited;

  {$IFDEF BUREAU}
  if VH_DP.SeriaKpmg then
  begin
     // MB : Pour KPMG, ne pas chercher automatiquement
     TFMul(Ecran).AutoSearch :=  asMouette ;
     // gha 01/2008. sans effet sans cette instruction
     TFMul(Ecran).SearchTimer.OnTimer := Nil;
  end;
  {$ENDIF}

  GereDroitsConceptsAnnuaire(Self, Ecran);

  // �vite les access vio, car JUR ANNUAIRE_SEL utilise cette tof
  if (Ecran.Name = 'ANNUAIRE_SEL') or (Ecran.Name = 'ANNUAIRE_SELLITE') then exit;
  // normalement, pour cet �cran, g�rer juste la confidentialite
  // (cf UTofAnnuaire de Juridique)

  // #### les 2 onglets "Infos libres" sont inexploitables
  // #### tant qu'il manque une vue avec left join ANNUBIS...
  // $$$ JP 07/09/2004: c'est le cas depuis au moins socref 657, mais sans doute depuis 654 - vue YYMULANNDOSS
//  SetControlVisible('PLIBRE1', False);
//  SetControlVisible('PLIBRE2', False);

  // concept sp�cifique � la fiche DP LIENANNUAIRE
  if not JaiLeDroitConceptBureau(ccParamListeAnnuaire) then
    SetControlVisible('BPARAMLISTE', False);

  sGuidPerDos_l := GetControlText('GUIDPERDOS');

  if (Ecran.Name = 'LIENANNUAIRE') and (sGuidPerDos_l <> '') then
    sWhere_Emetteur := 'ANN_GUIDPER <> "' + sGuidPerDos_l + '"'
  else
    sWhere_Emetteur := '';

  // Pour relancer l'�v�nement apr�s OnChange surcharg�
  if Assigned(THMultiValComboBox(GetControl('ANN_FAMPER')).OnChange) then
    FamPerChangeEvent := THMultiValComboBox(GetControl('ANN_FAMPER')).OnChange;
    // mais on aurait pu aussi utiliser Case TFMul(Ecran).AutoSearch of...

  // Libell� des tables libres
  AfficheLibTablesLibres(Self);

  FamPer := ReadTokenSt(Arguments); // peut �tre vide, exple : appel depuis
           // les liens juridiques : on ne passe pas la fct dans Arguments
           // ou sinon, lorsqu'il s'agit d'un lien juridique, on peut avoir
           // ACT, ASS, GRT... comme FamPer => ce ne sont pas de vraies FamPer
  LastFamPer := FamPer;
  LastFamPlus := '';

  // affectation des �v�nements
  Ecran.OnKeyDown := Form_OnKeyDown;
{$IFDEF BUREAU}
  POP := TPopUpMenu(GetControl('POPUP'));
  if POP <> nil then
  begin
       // $$$ JP 09/01/06 - ajout r�pertoire t�l�phonique, comme pour la liste des dossiers
    POP.Images := FMenuDisp.SmallImages;
    POP.OnPopup := OnPopupAnn;
    m_MnRepSep := TMenuItem.Create(POP);
    m_MnRepSep.Caption := '-';
    m_MnRep := TMenuItem.Create(POP);
    m_MnRep.Caption := 'R�pertoire t�l�phonique';
    POP.Items.Add(m_MnRepSep);
    POP.Items.Add(m_MnRep);
       // $$$

    for i := 0 to POP.Items.Count - 1 do
    begin
      if POP.Items[i].Name = 'bContacts' then
        POP.Items[i].OnClick := bContacts_OnClick
      else if POP.Items[i].Name = 'bLiens' then
      begin
        if not JaiLeDroitConceptBureau(ccVoirLesLiens) then
          POP.Items[i].Visible := False
        else
          POP.Items[i].OnClick := bLiens_OnClick;
      end
      else if POP.Items[i].Name = 'bEvenements' then
        POP.Items[i].Visible := False // evts juridiques cach�s
      else if POP.Items[i].Name = 'bDupliquer' then
      begin
        if not JaiLeDroitConceptBureau(ccCreatAnnuaireOuLiens) or not JaiLeDroitConceptBureau(ccModifAnnuaireOuLiens) then
          POP.Items[i].Visible := False
        else
          POP.Items[i].OnClick := BDUPLIQUER_OnClick;
      end
      else if POP.items [i].Name = 'bAcceder' then
       POP.Items[i].OnClick := BTANNUAIRE_OnClick;
    end;
  end;
{$ENDIF}

  TFMul(Ecran).FListe.OnDblClick := FListe_OnDblClick;
  TToolbarButton97(GetControl('BINSERT')).OnClick := BINSERT_OnClick;
  TToolbarButton97(GetControl('BDELETE')).OnClick := BDELETE_OnClick;
  TToolbarButton97(GetControl('BIMPRIMER')).OnClick := BIMPRIMER_OnClick;
  TToolbarButton97(GetControl('BTANNUAIRE')).OnClick := BTANNUAIRE_OnClick;
  TCheckBox(GetControl('CHKINTVDISPO')).OnClick := CHKINTVDISPO_OnClick;
  TCheckBox(GetControl('CHKINTVDOSSIER')).OnClick := CHKINTVDOSSIER_OnClick;

  if TCheckBox(GetControl('CHKCLIENTPROSPECT')) <> nil then
    TCheckBox(GetControl('CHKCLIENTPROSPECT')).OnClick := CHKCLIENTPROSPECT_OnClick;

  // TToolbarButton97(GetControl('BDUPLIQUER')).OnClick := BDUPLIQUER_OnClick;
  case TFMul(Ecran).AutoSearch of
    asChange: ; // voir onclick de la case
    asExit: // voir proc. InitAutoSearch du mul
      begin
        TCheckBox(GetControl('CHKINTVDISPO')).onExit := TFMul(Ecran).SearchTimerTimer;
        TCheckBox(GetControl('CHKINTVDOSSIER')).onExit := TFMul(Ecran).SearchTimerTimer;

        if TCheckBox(GetControl('CHKCLIENTPROSPECT')) <> nil then
          TCheckBox(GetControl('CHKCLIENTPROSPECT')).onExit := TFMul(Ecran).SearchTimerTimer;
      end;
    asTimer: ; // voir onclick de la case
  end;
  // oubli dans la fiche
  TFMul(Ecran).bSelectAll.visible := True;

  // Bouton Annuaire du lanceur => on utilise le mul LIENANNUAIRE d�tourn� :
  // on change le caption, et on ne traite pas les fonctions...
  if Copy(FamPer, 1, 8) = 'CAPTION=' then
  begin
    LastFamPer := '';
    THMultiValCombobox(GetControl('ANN_FAMPER')).OnChange := ANNFamper_OnChange;
    if Length(FamPer) > 8 then
    begin
      Ecran.Caption := Copy(FamPer, 9, Length(FamPer) - 8);
      updatecaption(Ecran);
    end;
    exit; // *** dans ce cas SORTIE imm�diate ***
  end;

  // Utilisation normale du mul LIENANNUAIRE pour choix d'une personne � lier

  // pour les cas simples, on restreint la s�lection de famille possible
  // � uniquement la famille demand�e
  if (FamPer = 'FIS') or (FamPer = 'ADT') or (FamPer = 'SOC') or (FamPer = 'OGA') then
  begin
    LastFamPlus := 'AND CO_CODE="' + FamPer + '"';
    SetControlProperty('ANN_FAMPER', 'Plus', LastFamPlus);
  end
  else if (FamPer = 'FIL') or (FamPer = 'PFC') or (FamPer = 'TIF') then
  begin
    FamPer := '';
    LastFamPer := '';
    SetControlProperty('ANN_FAMPER', 'Plus', '');
  end
  // sinon, le choix de famille conditionne les types de personne dans la 2�me combo
  else
  begin
    SetControlProperty('ANN_FAMPER', 'Plus', '');
{   // 12/12/02 supprim� sinon on ne voyait jamais ceux de famille vide dans une
    // cr�ation d'associ�s
    LastFamPlus := 'AND CO_CODE<>"FIS" AND CO_CODE<>"ADT" AND CO_CODE<>"SOC" AND CO_CODE<>"OGA"';
    SetControlProperty( 'ANN_FAMPER', 'Plus', LastFamPlus );}
    THMultiValCombobox(GetControl('ANN_FAMPER')).OnChange := ANNFamper_OnChange;
  end;

  // au cas o� type de personne conditionn�
  if FamPer <> '' then
  begin
    // ne pas appeler ANNFamper_OnChange car pdt chargement, .value est vide
    SetControlProperty('ANN_TYPEPER', 'Plus', 'JTP_FAMPER="' + FamPer + '"');
// ####
// ANN_FAMPER<>"FIS" AND ANN_FAMPER<>"INS" AND ANN_FAMPER <>"JRD" AND ANN_FAMPER <>"ADT"
// AND ANN_FAMPER<>"OGA" AND ANN_FAMPER<>"SOC"'
  end;

  // valeur par d�faut demand�e
  // NE PAS METTRE avant d'avoir d�fini la prop. Plus (voir ci-dessus)
  // sinon la pr�selection est perdue.
  THMultiValCombobox(GetControl('ANN_FAMPER')).value := FamPer;

  // pr�s�lection personne morale pour les filiales
  if FamPer = 'FIL' then THRadioGroup(GetControl('ANN_PPPM')).value := 'PM';
  // th�oriquement : propri�taire de fond de commerce,
  // #### mais ce n'est pas une famper => c'est une JTF_FONCTION...
  if FamPer = 'PFC' then THRadioGroup(GetControl('ANN_PPPM')).value := 'PP';

end;

// $$$ JP 09/01/06 - R�pertoire t�l�phonique dans un sous-menu du contexte popup

procedure TOF_ANNUAIRE.MajMenuRepertoireTel(sGuidPer: string);
var
  MN: TMenuItem;
  TobRep, T: TOB;
  i: Integer;
  ligne: string;

  procedure AjouteLigneMnRep(strTel: string = '');
  begin
    MN := TMenuItem.Create(m_MnRep);
    MN.Caption := ligne;
    MN.Checked := (T.GetValue('PRINC') = 'X');

      // $$$ JP: sur click, il faut soit ouvrir la fiche, soit t�l�phoner (si cti activ�)
{$IFDEF BUREAU}
    strTel := Trim(strTel);
    if (VH_DP.ctiAlerte <> nil) and (strTel <> '') then
    begin
      MN.Hint := strTel;
      MN.OnClick := MContactClick;
    end;
{$ENDIF}

    m_MnRep.Add(MN);
  end;

begin
     // Supprime les anciennes lignes
  for i := m_MnRep.Count - 1 downto 0 do m_MnRep.Delete(i);

     // Cherche liste des contacts
  TobRep := TOB.Create('rep telephone', nil, -1);

  TobRep.LoadDetailFromSQL('SELECT "X" AS PRINC, ANN_CV||" "||ANN_NOM1||" "||ANN_NOM2 AS NOM,'
             //mcd 12/2005  +' ANN_TEL1 AS ANI_TEL1, ANN_TEL2 AS ANI_TEL2, ANN_FAX AS ANI_FAX'
    + ' ANN_TEL1 AS C_TELEPHONE, ANN_TEL2 AS C_TELEX, ANN_FAX AS C_FAX'
    + ' FROM ANNUAIRE WHERE ANN_GUIDPER="' + sGuidPer + '" AND (ANN_TEL1<>"" OR ANN_TEL2<>"" OR ANN_FAX<>"")'
    + ' UNION '
(* mcd 12/2005    +'SELECT "-" AS PRINC, ANI_CV||" "||ANI_NOM||" "||ANI_PRENOM AS NOM,'
    +' ANI_TEL1, ANI_TEL2, ANI_FAX'
    +' FROM ANNUINTERLOC'
    +' WHERE ANI_CODEPER='+sCodePer  *)
    + 'SELECT "-" AS PRINC, C_CIVILITE||" "||C_NOM||" "||C_PRENOM AS NOM,'
    + ' C_TELEPHONE, C_TELEX, C_FAX'
    + ' FROM CONTACT'
    + ' WHERE C_GUIDPER="' + sGuidPer + '" AND (C_TELEPHONE<>"" OR C_TELEX<>"" OR C_FAX<>"")'
    + ' ORDER BY NOM');

  if TobRep.Detail.Count < 1 then
  begin
    m_mnRepSep.Visible := FALSE;
    m_MnRep.Visible := FALSE;
  end
  else
  begin
    m_mnRepSep.Visible := TRUE;
    m_MnRep.Visible := TRUE;
    for i := 0 to TobRep.Detail.Count - 1 do
    begin
      T := TobRep.Detail[i];
              // Attention : on n'a droit qu'� une seule tabulation pour que le popup
              // g�re correctement le multi-colonnage (les autres seraient vus
              // comme des carr�s)
      if T.GetValue('C_TELEPHONE') <> '' then
      begin
        ligne := Trim(T.GetValue('NOM')) + char(9) + 'T�l�phone : ' + T.GetValue('C_TELEPHONE');
        AjouteLigneMnRep(T.GetString('C_TELEPHONE'));
      end;
      if T.GetValue('C_TELEX') <> '' then
      begin
        ligne := Trim(T.GetValue('NOM')) + char(9) + 'Autre t�l. :   ' + T.GetValue('C_TELEX');
        AjouteLigneMnRep(T.GetString('C_TELEX'));
      end;
      if T.GetValue('C_FAX') <> '' then
      begin
        ligne := Trim(T.GetValue('NOM')) + char(9) + 'Fax :            ' + T.GetValue('C_FAX');
        AjouteLigneMnRep;
      end;
    end;
  end;

  TobRep.Free;
end;

{***********A.G.L.***********************************************
Auteur  ...... : B. MERIAUX
Cr�� le ...... : 17/07/2003
Modifi� le ... :   /  /
Description .. : Filtre la personne �mettrice du lien pour �viter qu'elle ait un
Suite ........ : lien sur elle-m�me + applique les autres filtres (cases � cocher)
Mots clefs ... :
*****************************************************************}

procedure TOF_ANNUAIRE.OnLoad;
var XXWhere: string;
begin
  // Lien �metteur sur lui-m�me
  XXWhere := sWhere_Emetteur;

  // Si uniquement les familles vides
  if sWhere_FamPer <> '' then
  begin
    if XXWhere <> '' then XXWhere := XXWhere + ' AND ';
    XXWhere := XXWhere + sWhere_FamPer;
  end;

  // Si uniquement les dossiers clients
  if sWhere_Dossiers <> '' then
  begin
    if XXWhere <> '' then XXWhere := XXWhere + ' AND ';
    XXWhere := XXWhere + sWhere_Dossiers;
  end;

  // Si client prospect
  if sWhere_ClientProspect <> '' then
  begin
    if XXWhere <> '' then XXWhere := XXWhere + ' AND ';
    XXWhere := XXWhere + sWhere_ClientProspect;
  end;

  // FQ 11490
  XXWhere := '(' + XXWhere + ') AND (NOT EXISTS (SELECT 1 FROM DOSSIER WHERE DOS_GUIDPER=ANN_GUIDPER AND DOS_NODOSSIER="000STD") )';

  // Crit�re global
  SetControlText('XX_WHERE', XXWhere);

  inherited;
end;



procedure TOF_ANNUAIRE.ANNFamper_OnChange(Sender: TObject);
var lesfamper, unefamper, crit: string;
begin
  // dans le script ANN_FAMPER_Click, y'avait �a :
  // ANN_TYPEPER.Plus := 'JTP_FAMPER="'+ANN_FAMPER.value+'" OR JTP_FAMPER=""';
  // ce qui permet de voir tous les types de personnes qui n'ont pas de famille
  // c'est � dire aucun (pour l'instant, sauf si l'utilisateur peut s'en cr�er)

  // #### on pourrait consulter la liste des famper dans la combo pour, si on
  // choisit "Tous", n'afficher que les typeper d�pendants des famper possibles...
  if THMultiValCombobox(GetControl('ANN_FAMPER')).value <> '' then
  begin
    LastFamPer := THMultiValCombobox(GetControl('ANN_FAMPER')).value;
    lesfamper := LastFamPer;
    crit := '';
    while lesfamper <> '' do
    begin
      unefamper := ReadTokenSt(lesfamper);
      if crit <> '' then crit := crit + ' OR ';
      crit := crit + 'JTP_FAMPER="' + unefamper + '"';
    end;
    SetControlProperty('ANN_TYPEPER', 'Plus', crit);
  end
  else
    SetControlProperty('ANN_TYPEPER', 'Plus', '');

  // Rappelle l'�v�nement d'origine (pour les crit�res de recherche automatiques)
  if Assigned(FamPerChangeEvent) then FamPerChangeEvent(Sender);
end;


procedure TOF_ANNUAIRE.bContacts_OnClick(Sender: TObject);
var
  GuidPer: string;
begin
  if GetDataSet.EOF then exit;

  Guidper := GetField('ANN_GUIDPER');
  if Guidper = '' then exit;
  //mcd 12/2005 AGLLanceFiche('YY', 'ANNUINTERLOC_PER',  codeper, '', '');
  AccesContact(GuidPer);
end;

{
procedure TOF_ANNUAIRE.bEvenements_OnClick(Sender: TObject);
var CodePerdos, NumDos, NomPer : String;
    Q1         : TQuery;
begin
  CodePerdos := GetField('ANN_CODEPER');
  if CodePerdos='' then exit;

  NumDos := ''; NomPer := '';
  Q1 := OpenSql('SELECT DOS_NODOSSIER FROM DOSSIER WHERE DOS_CODEPER='+CodePerdos, True);
  if Not Q1.Eof then NumDos := Q1.FindField('DOS_NODOSSIER').Asstring;
  Ferme(Q1);

  Q1:=OpenSQL('SELECT ANN_NOMPER from ANNUAIRE where ANN_CODEPER='+CodePerDos, True) ;
  if Not Q1.EOF then NomPer:=Q1.FindField('ANN_NOMPER').AsString;
  Ferme(Q1) ;

  AglLanceFiche('JUR','EVENEMENT_MUL','JEV_CODEPER='+CodePerDos+';NOMDOSSIER='+Numdos
   +';ANN_NOMPER='+NomPer,'','DOS');
end;
}

procedure TOF_ANNUAIRE.bLiens_OnClick(Sender: TObject);
var
  Guidper: string;
begin
  Guidper := GetField('ANN_GUIDPER');
  if Guidper = '' then exit;
  AglLanceFiche('DP', 'LIENPERSONNE', 'ANL_GUIDPER=' + Guidper, '', Guidper + ';DOS')
end;


procedure TOF_ANNUAIRE.FListe_OnDblClick(Sender: TObject);
// Attention : s'�x�cute aussi sur mouette verte dans la fiche
// (comportement par d�faut de BOuvrirClick des mul)
var Fonction, FamPer: string;
begin
  if GetControlText('PASDELIEN') = 'X' then
    BTANNUAIRE_OnClick(Sender)
  else
  begin
    Fonction := GetControlText('ANLFONCTION');
    if not ListeCorrecte('ANN_FAMPER', 'Famille de personne') then exit;
    FamPer := GetField('ANN_FAMPER');
    // sChaineRetour := ''+GetControlText('CODEPERDOS')+';DP;1;'+Fonction+';'
    //  + VarToStr(GetField('ANN_CODEPER')) ;
    // On connait la fct lors du lancmt de LIENANNUAIRE, inutile de la retourner...

    sChaineRetour := VarToStr(GetField('ANN_GUIDPER'));

    // #### y'en manque pas ?
    if (Fonction = 'FIS') or (Fonction = 'ADT') or (Fonction = 'SOC') or (Fonction = 'OGA') then
    begin
      TFMul(Ecran).Retour := sChaineRetour;
      TFMul(Ecran).ModalResult := 1; // referme la fiche
    end
    else if (FamPer <> 'FIS') and (FamPer <> 'SOC') and (FamPer <> 'OGA') and (FamPer <> 'INS') then
    begin
      TFMul(Ecran).Retour := sChaineRetour;
      TFMul(Ecran).ModalResult := 1 // referme la fiche
    end
    else
    begin
      PGIInfo('Lien impossible', TitreHalley);
      TFMul(Ecran).ModalResult := 0; // emp�che la sortie
    end;
  end;
end;


procedure TOF_ANNUAIRE.BINSERT_OnClick(Sender: TObject);
begin
  AGLLanceFiche('YY', 'ANNUAIRE', '', '', 'ACTION=CREATION;;;;;'+LastFamPer);
  AglRefreshDB([LongInt(Ecran), 'FListe'], 2);
end;


procedure TOF_ANNUAIRE.BTANNUAIRE_OnClick(Sender: TObject);
begin
  if VarIsNull(GetField('ANN_GUIDPER')) then exit;

  // Si on veut scroller parmi les enreg, il faut dire quel est le mul d'origine,
  // sinon malgr� Range vide, on reste bloqu� sur l'enreg pass� dans Lequel,
  // et on ne peut pas faire suivant/pr�c�dent dans la fiche ANNUAIRE ...
//  TheMulQ := Q;
  AGLLanceFiche('YY', 'ANNUAIRE', '', GetField('ANN_GUIDPER'),
    'ACTION=MODIFICATION;;;' + 'DOS');

  // *** Rqs sur l'actualisation de la liste ***
  // TFMul(Ecran).Q.Refresh; => message "Op�ration impossible sur cette table,
  //                       car elle n'est pas index�e de fa�on unique"
  // TFMul(Ecran).BChercheClick(Nil); => ne se repositionne pas sur l'enreg
  // Donc on utilise :
  AglRefreshDB([LongInt(Ecran), 'FListe'], 2);
end;


procedure TOF_ANNUAIRE.BDELETE_OnClick(Sender: TObject);
// suppression d'une s�lection d'enreg dans le mul
begin
  // SupprimeListeEnreg(TFMul(Ecran), 'ANNUAIRE');
  AGLSupprimeListAnnu([LongInt(Ecran)], 1); // suppression sp�cifique � l'annuaire !
  AglRefreshDB([LongInt(Ecran), 'FListe'], 2);
end;

procedure TOF_ANNUAIRE.BIMPRIMER_OnClick(Sender: TObject);
begin
 LanceEtat ('E','DPG','AC1',True,False,False,nil,'','',False);
end;

procedure TOF_ANNUAIRE.GereIntvDispo;
var actif: Boolean;
begin
  actif := not (TCheckBox(GetControl('CHKINTVDISPO')).checked);
  SetControlEnabled('ANN_FAMPER', actif);
  SetControlEnabled('ANN_TYPEPER', actif);
end;

procedure TOF_ANNUAIRE.CHKINTVDISPO_OnClick(Sender: TObject);
begin
  if TCheckBox(GetControl('CHKINTVDISPO')).checked then
  begin
    // oblig� de purger Plus pour �viter que le mul fasse un OR de toutes les valeurs
    // possibles affich�es dans la combo...
    SetControlProperty('ANN_FAMPER', 'Plus', '');
    SetControlText('ANN_FAMPER', '');
    SetControlText('ANN_TYPEPER', '');
    // les intervenants disponibles = ceux sans famille
    sWhere_FamPer := 'ANN_FAMPER=""';
  end
  else
  begin
    // d�coche la case => revient � la pr�c�dente s�lection de familles
    SetControlProperty('ANN_FAMPER', 'Plus', LastFamPlus);
    // #### on aurait pu balayer les items de ANN_FAMPER... pour ne prendre que ceux affich�s ?
    // si annuaire organisation :
    // sWhere_FamPer := 'ANN_FAMPER<>"FIS" AND ANN_FAMPER<>"INS" AND ANN_FAMPER <>"JRD" AND ANN_FAMPER<>"OFM" AND ANN_FAMPER<>"OGA" AND ANN_FAMPER<>"SOC"';
    SetControlText('ANN_FAMPER', LastFamPer);
    // #### que devient TYPEPER qui devrait d�pendre de ce choix...
    sWhere_FamPer := '';
  end;
  GereIntvDispo;

  // voir proc. InitAutoSearch du mul
  case TFMul(Ecran).AutoSearch of
    asChange: TFMul(Ecran).SearchTimerTimer(Sender);
    asTimer: ResetTimer(Sender);
  end;
end;

procedure TOF_ANNUAIRE.CHKINTVDOSSIER_OnClick(Sender: TObject);
begin
  if TCheckBox(GetControl('CHKINTVDOSSIER')).checked then
    // Uniquement les clients
    sWhere_Dossiers := 'EXISTS (SELECT DOS_GUIDPER FROM DOSSIER WHERE DOS_GUIDPER=ANN_GUIDPER)'
  else
    // Tous
    sWhere_Dossiers := '';

  // voir proc. InitAutoSearch du mul
  case TFMul(Ecran).AutoSearch of
    asChange: TFMul(Ecran).SearchTimerTimer(Sender);
    asTimer: ResetTimer(Sender);
  end;
end;

procedure TOF_ANNUAIRE.CHKCLIENTPROSPECT_OnClick(Sender: TObject);
begin
  if TCheckBox(GetControl('CHKCLIENTPROSPECT')).checked then
    // Uniquement les clients prospect
    sWhere_ClientProspect := 'ANN_TIERS<>"" AND ANN_TIERS IS NOT NULL'
  else
    // Tous
    sWhere_ClientProspect := '';

  // voir proc. InitAutoSearch du mul
  case TFMul(Ecran).AutoSearch of
    asChange: TFMul(Ecran).SearchTimerTimer(Sender);
    asTimer: ResetTimer(Sender);
  end;
end;

procedure TOF_ANNUAIRE.BDUPLIQUER_OnClick(Sender: TObject);
var sCle: string;
begin
  sCle := DupliquerAnnuaire(GetField('ANN_GUIDPER'));
  AGLLanceFiche('YY', 'ANNUAIRE', sCle, sCle, '');
  AGLRefreshDB([LongInt(Ecran), 'FListe'], 2);
end;

procedure TOF_ANNUAIRE.ResetTimer(Sender: TObject);
begin
 // idem proc dans Mul
  TFMul(Ecran).SearchTimer.Enabled := False;
  TFMul(Ecran).SearchTimer.Enabled := True;
end;


function TOF_ANNUAIRE.ListeCorrecte(nomchp, titrechp: string): Boolean;
begin
  Result := True;
  if not ChampEstDansQuery(nomchp, TFMul(Ecran).Q) then
  begin
    Result := False;
    PGIInfo('La colonne "' + titrechp + '" ne figure pas dans votre param�trage de liste.' + #13 + #10
      + 'Veuillez la rajouter dans "Afficher les colonnes suivantes".', TitreHalley);
    TButton(GetControl('BPARAMLISTE')).Click;
  end;
end;


procedure TOF_ANNUAIRE.Form_OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  case Key of

  // Nouveau dossier : Ctrl + N
    78: if (Shift = [ssCtrl]) and GetControl('BINSERT').Visible then
        BINSERT_OnClick(nil);

  // Suppression : Ctrl + Suppr
    VK_DELETE:
      if (Shift = [ssCtrl]) and (TFMul(Ecran).FListe.Focused) and GetControl('BDELETE').Visible then
        BDELETE_OnClick(nil);

  // F11 = affichage du popup
    VK_F11: begin
        TPopupMenu(GetControl('POPUP')).Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
            // �vite de traiter le F11 par d�faut de Pgi (=vk_choixmul=double clic ds grid)
        Key := 0;
      end;
  else
    TFMul(Ecran).FormKeyDown(Sender, Key, Shift);
  end;
end;

procedure TOF_ANNUAIRE.OnPopupAnn(Sender: TObject);
begin
  MajMenuRepertoireTel(GetField('ANN_GUIDPER'));
end;

{$IFDEF BUREAU}

procedure TOF_ANNUAIRE.MContactClick(Sender: TObject);
var
  strTel: string;
begin
  strTel := TMenuItem(Sender).Hint;
  if strTel <> '' then
    if PgiAsk('Appeler le ' + strTel + ' ?') = mrYes then
      VH_DP.ctiAlerte.MakeCall(strTel);
end;
{$ENDIF}

initialization
  registerclasses([TOF_ANNUAIRE]);
end.

