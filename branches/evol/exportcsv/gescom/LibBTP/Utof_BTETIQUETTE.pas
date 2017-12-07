{***********UNITE*************************************************
Auteur  ...... : 
Créé le ...... : 12/03/2015
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : ETIQUETTE ()
Mots clefs ... : TOF;ETIQUETTE
*****************************************************************}
Unit Utof_BTETIQUETTE ;

Interface

Uses StdCtrls, 
     Controls, 
     Classes, 
{$IFNDEF EAGLCLIENT}
     FE_Main,
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF} 
     mul, 
{$else}
     eMul, 
     uTob, 
{$ENDIF}
     forms, 
     sysutils, 
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     Hpanel,
     uTOB,
     UTOF,
     DateUtils,
{$IFDEF EAGLCLIENT}
      utileAGL,
{$ELSE}
      {$IFNDEF DBXPRESS} dbTables, {$ENDIF}Fiche,
{$IFDEF V530}
      EdtEtat,
{$ELSE}
      EdtREtat,
{$ENDIF}
{$ENDIF}
      AglInit,
      EntGC,
      HTB97,
      HQry,
      AffaireUtil,
      vierge,
      Windows;

Type
  TOF_ETIQUETTE = Class (TOF)
    procedure OnArgument (S : String ) ; override ;
    Procedure OnUpdate                 ; Override ;
    procedure OnClose                  ; override ;

  private
    NatureCAB         : THValComboBox;
    QualifCAB         : THValComboBox;
    //
    BSelect1          : TToolbarbutton97;
    BSelect2          : TToolBarButton97;
    BEfface           : TToolBarButton97;
    //
    CodeArticle       : THEdit;
    CodeArticle_      : THEdit;
    //
    CodeTiers         : THEdit;
    CodeTiers_        : THEdit;
    //
    LIBREFOURNISSEUR  : THPanel;
    LIBREARTICLE      : THPanel;
    //
    Affaire           : THCritMaskEdit;
    Part0             : THCritMaskEdit;
    Part1             : THCritMaskEdit;
    Part2             : THCritMaskEdit;
    Part3             : THCritMaskEdit;
    Avenant           : THCritMaskEdit;
    //
    Affaire_          : THCritMaskEdit;
    Part0_            : THCritMaskEdit;
    Part1_            : THCritMaskEdit;
    Part2_            : THCritMaskEdit;
    Part3_            : THCritMaskEdit;
    Avenant_          : THCritMaskEdit;
    //
    PAvances          : TTabSheet;
    PContact          : TTabSheet;
    PFournisseur      : TTabSheet;
    PArticle          : TTabSheet;
    PAffaire          : TTabSheet;
    PTableLibre       : TTabSheet;
    PTableLibre_      : TTabSheet;
    //
    Pages             : THPageControl2;
    //
    TobEtiquette      : TOB;
    //
    StSQL             : String;
    StWhere           : String;
    //
    procedure ArticleOnElipsisClick(Sender: TObject);
    procedure ArticleOnElipsisClick_(Sender: TObject);
    procedure BEffaceOnClick(Sender: TObject);
    procedure BSelect1OnClick(Sender: TObject);
    procedure BSelect2OnClick(Sender: TObject);
    procedure ChargeRequete;
    procedure CreateTOB;
    procedure Controlechamp(Champ, Valeur: String);
    procedure GestionEcranAffaire;
    procedure GestionEcranArticle;
    procedure GestionEcranFournisseur;
    procedure GetObjects;
    procedure NatureCABOnChange(Sender: TObject);
    function  Recupwhere: String;
    function  RecupWhereAffaires: String;
    function  RecupWhereFournisseurs: String;
    function  RecupWhereMarchandises: String;
    function  RecupZoneCheck(Zone1: TCheckBoxState; LibZone: String): String;
    function  RecupZoneDate(Zone1, Zone2 : TdateTime; LibZone : String) : String;
    function  RecupZoneListe(Zone1, LibZone: String): String;
    function  RecupZoneMultiple(Zone1, Zone2, LibZone: String): String;
    function  RecupZoneSimple(Zone1, LibZone: String): String;
    procedure SetScreenEvents;
    procedure TiersOnElipsisClick(Sender: TObject);
    procedure TiersOnElipsisClick_(Sender: TObject);
    function  TransformeValeur(valeurOri: string): String;
    //

  end ;

Implementation

uses  TntStdCtrls,
      FactUtil;

procedure TOF_ETIQUETTE.OnArgument (S : String ) ;
var i       : Integer;
    IP      : Integer;
    Critere : string;
    Champ   : string;
    Valeur  : string;
begin
  Inherited ;

  Inherited ;
  //
  //Chargement des zones ecran dans des zones programme
  GetObjects;
  //
  CreateTOB;
  //
  Critere := S;
  //
  While (Critere <> '') do
  BEGIN
    i:=pos(':',Critere);
    if i = 0 then i:=pos('=',Critere);
    if i <> 0 then
       begin
       Champ:=copy(Critere,1,i-1);
       Valeur:=Copy (Critere,i+1,length(Critere)-i);
       end
    else
       Champ := Critere;
    Controlechamp(Champ, Valeur);
    Critere:=(Trim(ReadTokenSt(S)));
  END;

  Part0.Text  := 'A';

  Part0_.Text := 'A';

  SetScreenEvents;

  ChargeCleAffaire (Part0, Part1, Part2, Part3, AVENANT, BSelect1, TaCreat, Affaire.text, False);
  ChargeCleAffaire (Part0_, Part1_, Part2_, Part3_, AVENANT_, BSelect2, TaCreat, Affaire_.text, False);  

  NatureCAB.Value := 'MAR';
  
  GestionEcranArticle;

end ;


procedure TOF_ETIQUETTE.OnClose ;
begin
  Inherited ;

  StSQL := 'DELETE FROM BTTMPETQ WHERE BZD_UTILISATEUR = "'+ V_PGI.USer +'"';

  ExecuteSQL(StSQL);

end ;

Procedure TOF_ETIQUETTE.Controlechamp(Champ, Valeur : String);
begin

  if Champ = 'ID'   then NatureCAB.Value := Valeur;

end;

Procedure TOF_ETIQUETTE.GetObjects;
begin
  //
  Affaire := THCritMaskEdit(GetControl('AFF_AFFAIRE'));
  Part0   := THCritMaskEdit(GetControl('AFF_AFFAIRE0'));
  Part1   := THCritMaskEdit(GetControl('AFF_AFFAIRE1'));
  Part2   := THCritMaskEdit(GetControl('AFF_AFFAIRE2'));
  Part3   := THCritMaskEdit(GetControl('AFF_AFFAIRE3'));
  Avenant := THCritMaskEdit(GetControl('AFF_AVENANT'));
  //
  Affaire_:= THCritMaskEdit(GetControl('AFF_AFFAIRE_'));
  Part0_  := THCritMaskEdit(GetControl('AFF_AFFAIRE0_'));
  Part1_  := THCritMaskEdit(GetControl('AFF_AFFAIRE1_'));
  Part2_  := THCritMaskEdit(GetControl('AFF_AFFAIRE2_'));
  Part3_  := THCritMaskEdit(GetControl('AFF_AFFAIRE3_'));
  Avenant_:= THCritMaskEdit(GetControl('AFF_AVENANT_'));
  //
  CodeArticle       := THEdit(GetControl('GA_CODEARTICLE'));
  CodeArticle_      := THEdit(GetControl('GA_CODEARTICLE_'));
  //
  CodeTiers         := THEdit(GetControl('T_TIERS'));
  CodeTiers_        := THEdit(GetControl('T_TIERS_'));
  //
  NatureCAB         := THValComboBox(GetControl('BCB_NATURECAB'));
  QualifCAB         := THValComboBox(GetControl('BCB_QUALIFCODEBARRE'));
  //
  BSelect1          := TToolBarButton97(GetControl('BSELECT1'));
  BSelect2          := TToolBarButton97(GetControl('BSELECT2'));
  Befface           := TToolBarButton97(GetControl('BEFFACE'));
  //
  LIBREFOURNISSEUR  := THPanel(Getcontrol('LIBREFOURNISSEUR'));
  LIBREARTICLE      := THPanel(Getcontrol('LIBREARTICLE'));
  //
  PAvances          := TTabSheet(GetControl('Avances'));
  PFournisseur      := TTabSheet(GetControl('PAGEFOURNISSEUR'));
  PAffaire          := TTabSheet(GetControl('Standards'));
  PArticle          := TTabSheet(GetControl('PAGEARTICLE'));
  PContact          := TTabSheet(Getcontrol('PCONTACT'));
  PTableLibre       := TTabSheet(GetControl('PTABLESLIBRES'));
  PTableLibre_      := TTabSheet(GetControl('PTABLESLIBRES_'));
  //
  Pages             := THPageControl2(GetControl('PAGES'));

end;

Procedure TOF_ETIQUETTE.CreateTOB;
begin

  TOBEtiquette := TOB.Create('LES ETIQUETTES',Nil, -1);

end;
Procedure TOF_ETIQUETTE.SetScreenEvents;
begin

  NatureCAB.OnChange := NatureCABOnChange;
  //
  CodeArticle.OnElipsisClick  := ArticleOnElipsisClick;
  CodeArticle_.OnElipsisClick := ArticleOnElipsisClick_;
  //
  CodeTiers.OnElipsisClick    := TiersOnElipsisClick;
  CodeTiers_.OnElipsisClick   := TiersOnElipsisClick_;
  //
  BSelect1.OnClick  := BSelect1OnClick;
  BSelect2.OnClick  := BSelect2OnClick;
  Befface.OnClick   := BEffaceOnClick;


end;

Procedure TOF_ETIQUETTE.ArticleOnElipsisClick(Sender : TObject);
Var SWhere   : String;
    StChamps : String;
begin

	sWhere := ' AND ((GA_TYPEARTICLE="MAR") AND GA_TENUESTOCK="X")';

  StChamps := CodeArticle.Text;

  if CodeArticle.Text <> '' then
    sWhere := 'GA_CODEARTICLE=' + Trim(Copy(CodeArticle.text, 1, 18)) + ';XX_WHERE=' + sWhere
  else
    sWhere := 'XX_WHERE=' + sWhere;

	CodeArticle.text := AGLLanceFiche('BTP', 'BTARTICLE_RECH', '', '', sWhere +';RECHERCHEARTICLE');
  CodeArticle.text := Trim(Copy(CodeArticle.text, 1, 18));

end;
Procedure TOF_ETIQUETTE.ArticleOnElipsisClick_(Sender : TObject);
Var SWhere   : String;
    StChamps : String;
begin

	sWhere := ' AND ((GA_TYPEARTICLE="MAR") AND GA_TENUESTOCK="X")';

  StChamps := CodeArticle_.Text;

  if CodeArticle_.Text <> '' then
    sWhere := 'GA_CODEARTICLE=' + Trim(Copy(CodeArticle_.text, 1, 18)) + ';XX_WHERE=' + sWhere
  else
    sWhere := 'XX_WHERE=' + sWhere;

	CodeArticle_.text := AGLLanceFiche('BTP', 'BTARTICLE_RECH', '', '', sWhere +';RECHERCHEARTICLE');
  CodeArticle_.text := Trim(Copy(CodeArticle_.text, 1, 18));

end;

Procedure TOF_ETIQUETTE.TiersOnElipsisClick(Sender : TObject);
Var StChamps  : string;
begin

  StChamps  := CodeTiers.Text;

  CodeTiers.Text := AGLLanceFiche('GC','GCFOURNISSEUR_MUL','T_TIERS=' + StChamps +';T_NATUREAUXI=FOU','','SELECTION');

end;

Procedure TOF_ETIQUETTE.TiersOnElipsisClick_(Sender : TObject);
Var StChamps  : string;
begin

  StChamps  := CodeTiers_.Text;

  CodeTiers_.Text := AGLLanceFiche('GC','GCFOURNISSEUR_MUL','T_TIERS=' + StChamps +';T_NATUREAUXI=FOU','','SELECTION');

end;

Procedure TOF_ETIQUETTE.BSelect1OnClick(Sender : TObject);
Var StChamps  : String;
begin

  StChamps  := Affaire.Text;

  if GetAffaireEnteteSt(Part0, Part1, Part2, Part3, Avenant, nil, StChamps, false, false, false, True, true,'') then Affaire.text := StChamps;

  ChargeCleAffaire (Part0,Part1,Part2,Part3,Avenant, BSelect1, TaCreat, Affaire.Text, False);

end;

Procedure TOF_ETIQUETTE.BSelect2OnClick(Sender : TObject);
Var StChamps  : String;
begin

  StChamps  := Affaire_.Text;

  if GetAffaireEnteteSt(Part0_, Part1_, Part2_, Part3_, Avenant_, nil, StChamps, false, false, false, True, true,'') then Affaire_.text := StChamps;

  ChargeCleAffaire (Part0_,Part1_,Part2_,Part3_,Avenant_, BSelect2, TaCreat, Affaire_.Text, False);

end;

Procedure TOF_ETIQUETTE.BEffaceOnClick(Sender : TObject);
begin

  Affaire.Text  := '';
  Part0.Text    := '';
  Part1.Text    := '';
  Part2.Text    := '';
  Part3.Text    := '';
  Avenant.Text  := '';

  Affaire_.Text := '';
  Part0_.Text   := '';
  Part1_.Text   := '';
  Part2_.Text   := '';
  Part3_.Text   := '';
  Avenant_.Text := '';

end;


Procedure TOF_ETIQUETTE.NatureCABOnChange(Sender : TObject);
begin

  if      NatureCAB.Value = 'FOU' then GestionEcranFournisseur
  else if NatureCAB.Value = 'MAR' then GestionEcranArticle
  else if NatureCAB.Value = 'AFF' then GestionEcranAffaire
  else                                 GestionEcranArticle;

end;

Procedure TOF_Etiquette.GestionEcranFournisseur;
begin

  QualifCAB.Value           := '128';
  QualifCAB.Enabled         := False;

  PFournisseur.TabVisible   := True;
  PContact.TabVisible       := True;
  PTableLibre_.TabVisible   := True;

  PArticle.TabVisible       := False;
  PAffaire.TabVisible       := False;
  PTableLibre.TabVisible    := False;

  PAvances.TabVisible       := False;

  Pages.ActivePage := PFournisseur;

end;

Procedure TOF_Etiquette.GestionEcranArticle;
begin

  QualifCAB.Value           := '';
  QualifCAB.Enabled         := True;

  PFournisseur.TabVisible   := False;
  PContact.TabVisible       := False;
  PTableLibre_.TabVisible   := False;

  PArticle.TabVisible       := True;
  PAffaire.TabVisible       := False;
  PTableLibre.TabVisible    := True;

  PAvances.TabVisible       := False;

  Pages.ActivePage := PArticle;

end;

Procedure TOF_Etiquette.GestionEcranAffaire;
begin

  QualifCAB.Value           := '128';
  QualifCAB.Enabled         := False;

  PFournisseur.TabVisible   := False;
  PContact.TabVisible       := False;
  PTableLibre_.TabVisible   := False;

  PArticle.TabVisible       := False;
  PAffaire.TabVisible       := True;
  PTableLibre.TabVisible    := False;

  PAvances.TabVisible       := False;

  Pages.ActivePage := PAffaire;

end;


procedure TOF_ETIQUETTE.OnUpdate;
begin
  inherited;

  TOBEtiquette.ClearDetail;

  ExecuteSQL('DELETE FROM BTTMPETQ WHERE BZD_UTILISATEUR = "'+ V_PGI.USer +'"');

  ChargeRequete;

end;

Procedure TOF_ETIQUETTE.ChargeRequete;
Var QEtiq       : TQuery;
    TOBL        : TOB;
    NbEtiq      : Integer;
    NbEnreg     : Integer;
    indice      : Integer;
    i           : Integer;
    RegimePrix  : String;
    LibEnreg    : String;
    LibCompl    : String;
begin

  StWhere := '';

  if GetControlText('RHT') = 'X' then RegimePrix := 'HT' else RegimePrix := 'TTC';

  NbEtiq := 0;

  StWhere := RecupWhere;

  //Lecture pour charger précisément la base temporaire !!!
  If NatureCAB.Value = 'FOU' then
  begin
    StSQL  := 'SELECT COUNT(T_TIERS) FROM TIERS ';
    StSQL  := StSQL + 'LEFT JOIN CONTACT    ON T_AUXILIAIRE=C_AUXILIAIRE ';
    StSQL  := StSQL + 'LEFT JOIN TIERSCOMPL ON T_AUXILIAIRE=YTC_AUXILIAIRE ';
    NbEtiq := StrToInt(GetControlText('NBEXEMPLAIRE2'));
  end
  else if NatureCAB.Value = 'MAR' then
  begin
    NbEtiq := StrToInt(GetControlText('NBEXEMPLAIRE1'));
    StSQL := 'SELECT COUNT(GA_ARTICLE) FROM ARTICLE ';
  end
  else if NatureCAB.Value = 'AFF' then
  begin
    NbEtiq := StrToInt(GetControlText('NBEXEMPLAIRE'));
    StSQL := 'SELECT COUNT(AFF_AFFAIRE) FROM AFFAIRE ';
  end;

  if stWhere <> '' then StSQL := StSQL + ' WHERE ' + stWhere;
  QEtiq := OpenSQL(StSQL, true);

  NbEnreg := QEtiq.Fields[0].AsInteger;

  Ferme(QEtiq);
  if NbEnreg = 0 then exit;

  If NatureCAB.Value = 'FOU' then
  begin
    StSQl := 'SELECT "' + NatureCAB.Value + '" AS NATURECAB, T_TIERS AS CODECAB, ';
    StSQL := StSQL + '"Code128" AS QUALIFCAB, T_TIERS AS CODEBARRE, ';
    StSQL := StSQL + 'T_LIBELLE AS LIBELLE FROM TIERS ';
    StSQL  := StSQL +'LEFT JOIN CONTACT    ON T_AUXILIAIRE=C_AUXILIAIRE ';
    StSQL  := StSQL +'LEFT JOIN TIERSCOMPL ON T_AUXILIAIRE=YTC_AUXILIAIRE ';
    StSQL := StSQL + ' WHERE ' + Stwhere;
  end
  else if NatureCAB.Value = 'MAR' then
  begin
    StSQl := 'SELECT "' + NatureCAB.Value + '" AS NATURECAB, BCB_IDENTIFCAB AS CODECAB, ';
    StSQL := StSQL + 'BCB_QUALIFCODEBARRE AS QUALIFCAB, BCB_CODEBARRE as CODEBARRE, ';
    StSQL := StSQL + 'GA_LIBELLE AS LIBELLE,GA_LIBCOMPL AS LIBCOMPL,GA_PVHT AS PVHT, ';
    StSQL := StSQL + 'GA_PVTTC AS PVTTC, GA_CODEARTICLE,GA_STATUTART ';
    StSQL := StSQL + 'FROM ARTICLE LEFT JOIN BTCODEBARRE ON GA_ARTICLE=BCB_IDENTIFCAB ';
    StSQL := StSQL + ' WHERE ' + Stwhere; 
  end
  else if NatureCAB.Value = 'AFF' then
  begin
    StSQl := 'SELECT "' + NatureCAB.Value + '" AS NATURECAB, SUBSTRING(AFF_AFFAIRE,2,14) AS CODECAB, ';
    StSQL := StSQL + '"Code128" AS QUALIFCAB, SUBSTRING(AFF_AFFAIRE,2,14) AS CODEBARRE, ';
    StSQL := StSQL + 'AFF_LIBELLE AS LIBELLE ';
    StSQl := StSQL + 'FROM AFFAIRE ';
    StSQL := StSQL + ' WHERE ' + Stwhere;
  end;

  QEtiq := OpenSQL(StSQL,true);

  If not QEtiq.eof then
  begin
    TobEtiquette.LoadDetailDB('Etiquette','','',QEtiq,false,true);
    For I := 0 to TobEtiquette.detail.count -1 do
    begin
      TOBL        := TobEtiquette.detail[I];
      LibEnreg    := TobL.GetString('LIBELLE');
      LibEnreg    := StringReplace(LibEnreg, '"', '""',[rfReplaceAll]);
      LibCompl    := TOBL.GetString('LIBCOMPL');
      LibCompl    := StringReplace(LibCompl, '"', '""',[rfReplaceAll]);
      for indice  :=0 to NbEtiq - 1 do
      begin
        if NatureCAB.Value = 'MAR' then
        begin
          if TOBL.GetValue('CODEBARRE') = '' then
          begin
            TOBL.PutValue('NATURECAB', NatureCAB.Value);
            TOBL.PutValue('CODEBARRE', TOBL.GetValue('GA_CODEARTICLE'));
            TOBL.PutValue('CODECAB',   TOBL.GetValue('GA_CODEARTICLE'));
            TOBL.PutValue('QUALIFCAB', 'Code128');
          end;
        end;
        StSQL :='INSERT INTO BTTMPETQ ';
        StSQL := Stsql + '(BZD_UTILISATEUR, BZD_CODE,      BZD_LIBELLE, BZD_LIBCOMPL, ';
        StSQL := StSQL + ' BZD_REGIMEPRIX,  BZD_NBETIQ,    BZD_PVHT,    BZD_PVTTC, ';
        StSQL := StSQL + ' BZD_DEVISEPRINC, BZD_CODEBARRE, BZD_INDICE, ';
        StSQL := StSQL + ' BZD_NATURECAB,   BZD_QUALIFCAB) values (';
        StSQL := StSQL + ' "' + V_PGI.User                + '",';
        StSQL := StSQL + ' "' + TOBL.GetString('CODECAB') + '",';
        StSQL := StSQL + ' "' + Libenreg + '",';
        //
        if TOBL.GetString('NATURECAB') = 'MAR' then
        Begin
          //
          StSQL := StSQL + ' "' + LibCompl + '",';
          //
          StSQL := StSQL + ' "' + RegimePrix + '",';
          StSQL := StSQL + IntToStr(NbEtiq)  + ',';
          StSQL := StSQL + StringReplace(TOBL.GetString('PVHT'),',','.',[rfReplaceAll])  + ',';
          StSQL := StSQL + StringReplace(TOBL.GetString('PVTTC'),',','.',[rfReplaceAll]) + ',';
        end
        else
        begin
          StSQL := StSQL + '"",';
          StSQL := StSQL + '"",';
          StSQL := StSQL + IntToStr(NbEtiq) + ',';
          StSQL := StSQL + '0,';
          StSQL := StSQL + '0,';
        end;
        StSQL := StSQL   + '"' + V_PGI.DevisePivot + '",';
        StSQL := StSQL   + '"' + TOBL.GetString('CODEBARRE') + '",';
        //
        StSQL := StSQL   + '"' + IntToStr(indice+1) + '", ';
        StSQL := StSQL   + '"' + NatureCAB.Value    + '",';
        StSQL := StSQL   + '"' + TOBL.GetString('QUALIFCAB') + '")';
        //
        if ExecuteSQL(StSQL) = 0 then PGIError('Enreg N°' + IntToStr(i) + '  ' + StSQL);
      end;
    end;
  end;

end;


function TOF_ETIQUETTE.Recupwhere : String;
begin

  If NatureCAB.Value = 'MAR' then
  begin
    Result := RecupWhereMarchandises;
  end
  else If NatureCAB.Value = 'FOU' then
  begin
    Result := RecupWhereFournisseurs;
  end
  Else If NatureCAB.Value = 'AFF' then
  begin
    Result := RecupWhereAffaires;
  end;

end;

Function TOF_ETIQUETTE.RecupWhereMarchandises : String;
Var Zone1 : String;
    Zone2 : String;
    Zone3 : TCheckBoxState;
    Zone4 : TDateTime;
    Zone5 : TDateTime;
    ind   : Integer;
begin

  //
  Zone1  := GetControlText('GA_CODEARTICLE');
  Zone2  := GetControlText('GA_CODEARTICLE_');
  Result := RecupZoneMultiple(zone1, Zone2, 'GA_CODEARTICLE');
  //
  Zone1  := GetControlText('GA_FAMILLENIV1');
  Result := RecupZoneListe(Zone1, 'GA_FAMILLENIV1');
  //
  Zone1  := GetControlText('GA_FAMILLENIV2');
  Result := RecupZoneListe(Zone1, 'GA_FAMILLENIV2');
  //
  Zone1  := GetControlText('GA_FAMILLENIV3');
  Result := RecupZoneListe(Zone1, 'GA_FAMILLENIV3');
  //
  Zone1  := GetControlText('GA_STATUTART');
  Result := RecupZoneListe(Zone1, 'GA_STATUTART');
  //
  Zone3  := THCheckbox(GetControl('GA_FERME')).State;
  Result := RecupZoneCheck(Zone3, 'GA_FERME');
  //
  Zone3  := THCheckbox(GetControl('GA_TENUESTOCK')).State ;
  Result := RecupZoneCheck(Zone3, 'GA_TENUESTOCK');
  //
  Zone4  := StrToDate(GetControlText('GA_DATECREATION'));
  Zone5  := StrToDate(GetControlText('GA_DATECREATION_'));
  Result := RecupZoneDate(Zone4, zone5, 'GA_DATECREATION');
  //
  Zone4  := StrToDate(GetControlText('GA_DATEMODIF'));
  Zone5  := StrToDate(GetControlText('GA_DATEMODIF_'));
  Result := RecupZoneDate(Zone4, zone5, 'GA_DATEMODIF');
  //
  //Tabsheet ==> Table Libres
  //
  For Ind:=1 to 9 do
  begin
    Zone1  := GetControlText('GA_LIBREART' + IntToSTr(Ind));
    Result := RecupZoneListe(Zone1, 'GA_LIBREART' + IntToStr(Ind));
  end;

end;

Function TOF_ETIQUETTE.RecupWhereAffaires : String;
Var Zone0   : String;
    Zone1   : String;
    Zone2   : string;
    Zone3   : string;
    ZoneA   : string;
    Zone4   : TDateTime;
    Zone5   : TDateTime;
begin

  //
  Zone0   := Part0.Text;
  Zone1   := Part1.Text;
  Zone2   := Part2.Text;
  Zone3   := Part3.Text;
  ZoneA   := Avenant.text;

  if (Zone1 <> '') OR (Zone2 <> '') OR (zone3 <> '') then
    Affaire.text := CodeAffaireRegroupe(Zone0, zone1, Zone2, zone3, ZoneA, taModif, True, False, True)
  else
    Affaire.text := '';
  //
  //
  Zone0   := Part0_.Text;
  Zone1   := Part1_.Text;
  Zone2   := Part2_.Text;
  Zone3   := Part3_.Text;
  ZoneA   := Avenant_.text;

  if (Zone1 <> '') OR (Zone2 <> '') OR (zone3 <> '') then
    Affaire_.text := CodeAffaireRegroupe(Zone0, zone1, Zone2, zone3, ZoneA, taModif, True, False, True)
  else
    Affaire_.text := '';
  //
  Result := RecupZoneMultiple(Affaire.text, Affaire_.text, 'AFF_AFFAIRE');
  //
  Zone1  := GetControlText('AFF_LIBELLE');
  Result := RecupZoneSimple(Zone1, 'AFF_LIBELLE');
  //
  Zone1  := GetControlText('AFF_TIERS');
  Result := RecupZonesimple(Zone1, 'AFF_TIERS');
  //
  Zone1  := GetControlText('AFF_ETABLISSEMENT');
  Result := RecupZoneListe(Zone1, 'AFF_ETABLISSEMENT');
  //
  Zone1  := GetControlText('AFF_ETATAFFAIRE');
  Result := RecupZoneListe(Zone1, 'AFF_ETATAFFAIRE');
  //
  Zone1  := GetControlText('AFF_RESPONSABLE');
  Result := RecupZoneSimple(Zone1, 'AFF_RESPONSABLE');
  //
  Zone4  := StrToDate(GetControlText('AFF_DATEDEBUT'));
  Zone5  := StrToDate(GetControlText('AFF_DATEDEBUT_'));
  Result := RecupZoneDate(Zone4, zone5, 'AFF_DATEDEBUT');
  //
  Zone4  := StrToDate(GetControlText('AFF_DATEFIN'));
  Zone5  := StrToDate(GetControlText('AFF_DATEFIN_'));
  Result := RecupZoneDate(Zone4, zone5, 'AFF_DATEFIN');

end;

Function TOF_ETIQUETTE.RecupWhereFournisseurs : String;
Var Zone1 : String;
    Zone2 : String;
    Zone3 : TCheckBoxState;
    Zone4 : TDateTime;
    Zone5 : TDateTime;
    ind   : Integer;
begin

  //
  Zone1  := GetControlText('T_TIERS');
  Zone2  := GetControlText('T_TIERS_');
  Result := RecupZoneMultiple(zone1, Zone2, 'T_TIERS');
  //
  Zone1  := GetControlText('T_LIBELLE');
  Result := RecupZoneSimple(zone1, 'T_LIBELLE');
  //
  Zone1  := GetControlText('T_CODEPOSTAL');
  Result := RecupZoneSimple(zone1, 'T_CODEPOSTAL');
  //
  Zone1  := GetControlText('T_VILLE');
  Result := RecupZoneSimple(zone1, 'T_VILLE');
  //
  Zone1  := GetControlText('T_PAYS');
  Result := RecupZoneSimple(zone1, 'T_PAYS');
  //
  Zone1  := GetControlText('T_APE');
  Result := RecupZoneSimple(zone1, 'T_APE');
  //
  Zone1  := GetControlText('T_SECTEUR');
  Result := RecupZoneListe(Zone1, 'T_SECTEUR');
  //
  Zone3  := THCheckbox(GetControl('T_FERME')).State;
  Result := RecupZoneCheck(Zone3, 'T_FERME');
  //
  Zone4  := StrToDate(GetControlText('T_DATECREATION'));
  Zone5  := StrToDate(GetControlText('T_DATECREATION_'));
  Result := RecupZoneDate(Zone4, zone5, 'T_DATECREATION');
  //
  Zone4  := StrToDate(GetControlText('T_DATEMODIF'));
  Zone5  := StrToDate(GetControlText('T_DATEMODIF_'));
  Result := RecupZoneDate(Zone4, zone5, 'T_DATEMODIF');
  //
  //Tabsheet ==> contacts
  //
  Zone1  := GetControlText('C_NOM');
  Result := RecupZoneSimple(zone1, 'C_NOM');
  //
  Zone1  := GetControlText('C_FONCTION');
  Result := RecupZoneListe(Zone1, 'C_FONCTION');
  //
  Zone3  := THCheckbox(GetControl('C_PRINCIPAL')).State;
  Result := RecupZoneCheck(Zone3, 'C_PRINCIPAL');
  //
  //Tabsheet ==> TableLibres
  //
  For Ind:=1 to 3 do
  begin
    Zone1  := GetControlText('YTC_TABLELIBREFOU' + IntToSTr(Ind));
    Result := RecupZoneListe(Zone1, 'YTC_TABLELIBREFOU' + IntToStr(Ind));
  end;


end;

function TOF_ETIQUETTE.RecupZoneMultiple(Zone1, Zone2, LibZone : String) : String;
begin

  if zone1 = Zone2 then
  begin
    if Pos(zone1,'%') <> 0 then
    begin
      If Result <> '' then Result := Result + ' AND ';
      Result := result + Libzone + ' LIKE "' + Zone1 + '" '
    end
    else
    begin
      If Result <> '' then Result := Result + ' AND ';
      If Zone1 <> ''  then Result := Result + LibZone + '="' + Zone1 + '" '
    end;
  end
  else
  begin
    If Result <> '' then Result := Result + ' AND ';
    Result := Result + Libzone + '>="' + Zone1 + '" AND ' + Libzone + '<="' + Zone2 + '" ';
  end;

end;

function TOF_ETIQUETTE.RecupZoneSimple(Zone1, LibZone : String) : String;
Begin

  If Zone1 <> '' then
  begin
    If Result <> '' then Result := Result + ' AND ';
    Result := Result + LibZone + '="' + Zone1 + '" ';
  end;

end;

function TOF_ETIQUETTE.RecupZoneListe(Zone1, LibZone : String) : String;
Begin

  Zone1  := TransformeValeur(Zone1);
  if (Zone1 = '') or (Zone1 = '<<Tous>>') then
    exit
  else
  begin
    If Result <> '' then Result := Result + ' AND ';
    Result := Result + Libzone + ' IN ("'+ Zone1 + '") '
  end;

end;

function TOF_ETIQUETTE.RecupZoneCheck(Zone1 : TCheckBoxState; LibZone : String) : String;
Begin

  If Zone1 = CbGrayed then Exit;

  If Zone1 = CbChecked then 
  begin
    If Result <> '' then Result := Result + ' AND ';
    Result := Result + LibZone + ' ="X" '
  end
  Else
  begin
    If Result <> '' then Result := Result + ' AND ';
    Result := Result + LibZone + ' ="-" ';
  end;

end;

function TOF_ETIQUETTE.RecupZoneDate(Zone1, Zone2 : TdateTime; LibZone : String) : String;
var aa,mm,jj : Word;
    D1,D2 : TDateTime;
Begin

  If Result <> '' then Result := Result + ' AND ';
  D1 := Zone1;
  DecodeDate(D1,aa,mm,jj);
  D1 := EncodeDate(aa,mm,jj);

  D2 := IncDay(Zone2); 
  DecodeDate(D2,aa,mm,jj);
  D2 := EncodeDate(aa,mm,jj);

  Result := Result + LibZone + ' >="' + UsDateTime(D1) + '" AND ' + Libzone + ' <="' + UsDateTime(D2) + '" ';

end;

function TOF_ETIQUETTE.TransformeValeur(ValeurOri : string) : String;
var StVal       : string;
    valeurListe : string;
begin
  result:='';

  if valeurOri='' then exit;

  valeurListe := valeurOri;

  repeat
    stVal:=ReadToKenSt(valeurListe);
    if stVal <> '' then
    begin
      if result = '' then
        result :=stVal
      else
        result:=result+'","'+stVal;
    end;
  until stVal='';

end;

Initialization
  registerclasses ( [ TOF_ETIQUETTE ] ) ;
end.

