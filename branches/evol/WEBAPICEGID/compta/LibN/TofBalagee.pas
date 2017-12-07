{***********UNITE*************************************************
Auteur  ...... : St�phane BOUSSERT
Cr�� le ...... : 05/08/2002
Modifi� le ... : 08/08/2002
Description .. : Int�gration dans la Compta S5 le 05/08/2002
Mots clefs ... :
*****************************************************************}
unit TofBalagee;

interface

uses Classes, StdCtrls,
{$IFDEF EAGLCLIENT}
     eQRS1,MaineAGL, UTob,
{$ELSE}
     {$IFNDEF DBXPRESS}dbtables{BDE},{$ELSE}uDbxDataSet,{$ENDIF}
     QRS1,
     FE_Main,
{$ENDIF}
     comctrls,UTof, HCtrls,Ent1,  TofMeth, HTB97, spin,
     Filtre,
     ParamSoc,		//GetParamSocSecur YMO
     SysUtils;

procedure CPLanceFiche_BalanceAgee;
procedure CPLanceFiche_BalanceVentilee;

type
    TOF_BALAGEE = class(TOF_Meth)
  private
  	EtatType				: String;
    NbPeriodes			: Integer;
    Periodicite     : THValComboBox ;
    Devise          : THValComboBox ;
    NatureAuxi      : THValComboBox ;
    DevPivot        : THEdit ;
    Ecart           : THRadioGroup ;
    Affichage       : THRadioGroup ;
    AffMontants     : THRadioGroup ;
    Impression      : THRadioGroup ;
    NbJEcart        : TSpinEdit ;
		DateArrete			: THEdit;
    EnSituation			: TCheckBox;
		ConditionSQL	  : THEdit;
		Gene1,Gene2	    : THEdit;
    QualifPiece 		: THMultiValcomboBox;
    AvecQualifPiece : THEdit;
    BalPrev, BalRet : TRadioButton;
    ChoixTypeTaLi   : THRadioGroup;
    procedure NatureAuxiOnChange (Sender : TObject) ;
    procedure PeriodiciteOnChange (Sender : TObject) ;
    procedure DateArreteOnChange (Sender : TObject) ;
    procedure EcartOnChange (Sender : TObject) ;
    procedure NbJEcartOnChange(Sender : TObject) ;
    procedure EtablissementOnChange (Sender : TObject) ;
    procedure DeviseOnChange (Sender : TObject) ;
    procedure Gene1OnChange (Sender : TObject) ;
    procedure Gene2OnChange (Sender : TObject) ;
    procedure Rupture1OnDblClick (Sender : TObject) ;
    procedure TriParOnDblClick (Sender : TObject) ;
    procedure AffichageOnClick (Sender : TObject) ;
    procedure ImpressionOnClick (Sender : TObject );
    procedure TriParOnChange (Sender : TObject) ;
		function  GetMinMaxCompte(stTable, stCol, stDefaut : String) : String;
    function  GetTabletteColl(stNatureTiers : String) : String;
    function  GetTabletteTiers(stNatureTiers : String) : String;
    function	GetWhereColl(stNatureTiers : String): String;
    procedure GenererConditionSQL;
    procedure ParametreEtatType;
    procedure	CalculPeriodesAvecPeriodicite;
    procedure	CalculPeriodesAvecNbJour;
    procedure BalTypeOnChange(Sender : TObject);
    procedure UpdateOptions( vBoAvecRupt : Boolean ) ;
    procedure OnClickChoixTaLi ( Sender : TObject );
    procedure AuxiElipsisClick         ( Sender : TObject );
  public
    procedure OnArgument(Arguments : string); override ;
    procedure OnLoad; override ;
    procedure OnNew; override ;
    procedure OnUpdate; override ;
  END  ;

Type TTabDate10 = Array[1..10] of TDateTime ;

implementation

uses HEnt1, LicUtil,HMsgBox, UTofMulParamGen,
     TofTLTiersTri, TofTLTiersRupt;{JP 25/08/04 : FQ 13401, 13452, 13671}

{ ==== Pour info : liste des drivers de SGDB possibles ===
		Type TDBDriver = (dbINTRBASE,dbMSSQL,dbORACLE7,dbORACLE8,dbDB2,
    									dbINFORMIX,dbMSACCESS,dbPARADOX,dbSQLANY,
                      dbSQLBASE,dbPOL,dbSYBASE,dbMySQL,dbPROGRESS) ; }
//==============================================================================
procedure CPLanceFiche_BalanceAgee;
begin
  // Etat non utilisable sous ORACLE7
	if V_PGI.Driver = dbORACLE7
    then PGIInfo( 'Cet �tat n''est pas utilisable sous Oracle 7. Veuillez utiliser l''�tat correspondant dans le menu Autres �ditions' , 'Balance Ag�e en situation' )
    else AGLLanceFiche('CP','EPBALAGEE','','','AGEE');
end;
//==============================================================================
procedure CPLanceFiche_BalanceVentilee;
begin
  // Etat non utilisable sous ORACLE7
	if V_PGI.Driver = dbORACLE7
    then PGIInfo( 'Cet �tat n''est pas utilisable sous Oracle 7. Veuillez utiliser l''�tat correspondant dans le menu Autres �ditions' , 'Balance Ventil�e en situation' )
    else AGLLanceFiche('CP','EPBALAGEE','','','VENTIL');
end;
//==============================================================================

PROCEDURE TOF_BALAGEE.OnUpdate ;
VAR St,St1,St2,St3,St4,St5,S,S1,TriLibelle,Order,stTL : string ;
    i : integer;
    stIndice : string;
BEGIN
  S:='';
  S1:='';
  TriLibelle:='T_AUXILIAIRE' ;
  St:=GetControlText('TRIPAR') ;
  St1:=GetControlText('RUPTURE1') ;
  St2:=GetControlText('RUPTURE2') ;
  if GetControlText('TRILIBELLE')='X'
    then TriLibelle:='T_LIBELLE'
    else TriLibelle:='T_AUXILIAIRE' ;

  // Construction condition sur ruptures tables libres
  // Codes utilis�s pour la gestion des ruptures sur tables libres :
  //    # = non g�r�e
  //    - = g�r�e mais non s�lectionn�e
  //    * = tous les enregistrements de la table (sans fourchette de valeurs)
  //  sinon code de valeur d�but dans St3, fin dans St4
  if St1<>'' then
    For i:=0 to 9 do
      BEGIN
      St3:=ReadTokenSt(St1) ;
      St4:=ReadTokenSt(St2) ;
      if (St3<>'-') and (St3>'#') and (St3<>'') then // unniquement les tables s�lectionn�es
        BEGIN
        if (St3<>'*') then // Si on a une fourchette de valeurs
          begin
            if ChoixTypeTaLi.Value = 'AUX' then
              stTL := '( T_TABLE'+IntToStr(i)+'>="'+St3+'" AND T_TABLE'+IntToStr(i)+'<="'+St4+'" )'
            else if ChoixTypeTaLi.Value = 'CLI' then
              stTL := '( YTC_TABLELIBRETIERS'+IntToHex(i+1,1)+'>="'+St3+'" AND YTC_TABLELIBRETIERS'+IntToHex(i+1,1)+'<="'+St4+'" )'
            else if ChoixTypeTaLi.Value = 'SCL' then
              stTL := '( YTC_RESSOURCE'+IntToHex(i+1,1)+'>="'+St3+'" AND YTC_RESSOURCE'+IntToHex(i+1,1)+'<="'+St4+'" )';
          if not TCheckBox(GetControl('CPTASSOCIES')).Checked then
          begin
            if ChoixTypeTaLi.Value = 'AUX' then
              stTL := '( ' + stTL +' OR ( T_TABLE'+IntToStr(i)+'="" ) ) '
            else if ChoixTypeTaLi.Value = 'CLI' then
              stTL := '( ' + stTL +' OR ( YTC_TABLELIBRETIERS'+IntToHex(i+1,1)+'="" ) ) '
            else if ChoixTypeTaLi.Value = 'SCL' then
              stTL := '( ' + stTL +' OR ( YTC_RESSOURCE'+IntToHex(i+1,1)+'="" ) ) ' ;
          end;
          S := S + ' AND ' +  stTL ;
          end
        else // Sans fourchette de valeur
          if TCheckBox(GetControl('CPTASSOCIES')).Checked then
          begin
            if ChoixTypeTaLi.Value = 'AUX' then
              S := S + ' AND (T_TABLE'+IntToStr(i)+'<>"") ' 
            else if ChoixTypeTaLi.Value = 'CLI' then
              S := S + ' AND (YTC_TABLELIBRETIERS'+IntToHex(i+1,1)+'<>"") '
            else if ChoixTypeTaLi.Value = 'SCL' then
              S := S + ' AND (YTC_RESSOURCE'+IntToHex(i+1,1)+'<>"") ' ;
          end;
        END ;
      END ;

  // conditions auxiliaire
  if (GetControlText('T_AUXILIAIRE')='')  and (GetControlText('T_AUXILIAIRE_')<>'') then
    S:=S+' AND T_AUXILIAIRE<="'+GetControlText('T_AUXILIAIRE_')+'"' ;
  if (GetControlText('T_AUXILIAIRE')<>'') and (GetControlText('T_AUXILIAIRE_')<>'') then
    S:=S+' AND T_AUXILIAIRE>="'+GetControlText('T_AUXILIAIRE')+'" AND T_AUXILIAIRE<="'+GetControlText('T_AUXILIAIRE_')+'"' ;

  // conditions nature auxi
  if TComboBox(GetControl('T_NATUREAUXI')).itemindex<>0 then
    S:=S+' AND T_NATUREAUXI="'+GetControlText('T_NATUREAUXI')+'"' ;

  // Mise en place dans le champ cach�
  SetControlText('WHERE',S) ;

  // MAJ pour gestion des ruptures dans l'�tat
  for i:=0 to 9 do
    begin
    SetControlText('T0'+IntToStr(i),'') ;
    SetControlText('ORDER'+IntToStr(i),'') ;
    end ;
  i := 0 ;
  while St<>'' do
    begin
    St5:=ReadTokenSt(St) ;
    if (St5<>'') then
      begin
        stIndice := copy(St5,3,1);
      if ChoixTypeTaLi.Value = 'AUX' then
        SetControlText('ORDER'+IntToStr(i),'T_TABLE'+stIndice)
      else if ChoixTypeTaLi.Value = 'CLI' then SetControlText('ORDER'+IntToStr(i),'YTC_TABLELIBRETIERS'+stIndice)
      else if ChoixTypeTaLi.Value = 'SCL' then SetControlText('ORDER'+IntToStr(i),'YTC_RESSOURCE'+stIndice);
      SetControlText('T0'+IntToStr(i),St5) ;
      if (St='') then
      begin
        if ChoixTypeTaLi.Value = 'AUX' then
          S1:=S1+'T_TABLE'+copy(St5,3,1)
        else if ChoixTypeTaLi.Value = 'CLI' then S1:=S1+'YTC_TABLELIBRETIERS'+stIndice
        else if ChoixTypeTaLi.Value = 'SCL' then S1:=S1+'YTC_RESSOURCE'+stIndice;
      end
      else
      begin
        if ChoixTypeTaLi.Value = 'AUX' then
          S1:=S1+'T_TABLE'+copy(St5,3,1)+','
        else if ChoixTypeTaLi.Value = 'CLI' then S1:=S1+'YTC_TABLELIBRETIERS'+stIndice+','
        else if ChoixTypeTaLi.Value = 'SCL' then S1:=S1+'YTC_RESSOURCE'+stIndice+',';
      end;
    end ;
    { Mise � jour des requ�tes pour r�cup�rer les libell�s des donn�es des tables libres }
    if ChoixTypeTaLi.Value = 'AUX' then
      SetControlText ('SQL'+IntToStr(i),'select nt_libelle FROM natcpte WHERE nt_typecpte="T0'+stIndice+'" and nt_nature=')
    else if ChoixTypeTaLi.Value = 'CLI' then SetControlText ('SQL'+IntToStr(i),'select yx_libelle FROM choixext WHERE yx_type="LT'+stIndice+'" and yx_code=')
    else if ChoixTypeTaLi.Value = 'SCL' then SetControlText ('SQL'+IntToStr(i),'select ars_libelle FROM ressource WHERE ars_ressource=');
    inc(i) ;
    end ;

  if S1<>''
    then Order:=S1+','+TriLibelle
    else Order:=TriLibelle ;

  TFQRS1(Ecran).WhereSQL:='|'+Order ;

END;

PROCEDURE TOF_BALAGEE.OnArgument(Arguments : string);
VAR Rupture1,Rupture2               : THEdit;
    TriPar                          : THEdit;
BEGIN
  inherited ;
  // M�morisation du type d'�tat (AGEE ou VENTIL)
  EtatType := Arguments;
  // Gestion du filtre et du nb de p�riodes suivant type de l'�tat
  if EtatType = 'VENTIL' then
    begin
    NbPeriodes := 4 ;
    TFQRS1(Ecran).FNomFiltre := 'TEPBALVENTIL' ;
    Ecran.HelpContext := 7556000;
    end
  else
    begin
    NbPeriodes := 5 ;
    TFQRS1(Ecran).FNomFiltre := 'TEPBALAGEE' ;
    Ecran.HelpContext := 7547000;
    end ;

  NatureAuxi    := THValComboBox(GetControl('T_NATUREAUXI'));
  Periodicite   := THValComboBox(GetControl('PERIODICITE'));
  Devise        := THValComboBox(GetControl('DEVISE'));
  DevPivot      := THEdit(GetControlText('DEVPIVOT'));
  Gene1         := THEdit(GetControl('GENERAL'));
  Gene2         := THEdit(GetControl('GENERAL_'));
  DateArrete    := THEdit(GetControl('DATE1'));
  EnSituation   := TCheckBox(GetControl('ENSITUATION'));
  ConditionSQL  := THEdit(GetControl('CONDITIONSQL'));
  Ecart         := THRadioGroup(GetControl('ECART'));
  NbJEcart      := TSpinEdit(GetControl('NBJECART'));
  Rupture1      := THEdit(GetControl('RUPTURE1'));
  Rupture2      := THEdit(GetControl('RUPTURE2'));
  TriPar        := THEdit(GetControl('TRIPAR'));
  Affichage     := THRadioGroup(GetControl('AFFICHAGE')) ;
  AffMontants   := THRadioGroup(GetControl('AFFMONTANTS')) ;
  Impression    := THRadioGroup(GetControl('TIMPRESSION')) ;
  QualifPiece   := THMultiValComboBox(Getcontrol('QUALIFPIECE'));
  AvecQualifPiece :=THEdit(GetControl('AVECQUALIFPIECE'));
  BalPrev       :=TRadioButton(GetControl('BALPREV'));
  BalRet        :=TRadioButton(GetControl('BALRET'));
  ChoixTypeTaLi :=THRadioGroup(GetControl('CHOIXTYPETALI'));
  if Devise<>nil        then BEGIN Devise.OnChange:=DeviseOnChange;Devise.itemindex:=0;Devise.OnChange(NIL) ; END ;
  if ComboEtab<>nil     then BEGIN ComboEtab.OnChange:=EtablissementOnChange;ComboEtab.OnChange(NIL) ; END ;
  if Periodicite<>nil   then BEGIN Periodicite.OnChange:=PeriodiciteOnChange;Periodicite.itemindex:=0 ; END ;
  if DateArrete<>nil    then BEGIN DateArrete.OnChange:=DateArreteOnChange;SetControlText('DATE1',DateToStr(V_PGI.DateEntree)); END ;
  if Ecart<>nil         then BEGIN Ecart.OnClick:=EcartOnChange; Ecart.itemindex:=1;EcartOnChange(NIL) ; END ;
  if NbJEcart<>nil      then BEGIN NbJEcart.OnChange:=NbJEcartOnChange;NbJEcart.text:='30' ; END ;
  if NatureAuxi<>nil    then BEGIN NatureAuxi.OnChange:=NatureAuxiOnChange;NatureAuxi.itemindex:=0; NatureAuxiOnChange(nil); END ;
  if ChoixTypeTaLi <> nil then BEGIN ChoixTypeTaLi.OnClick := OnClickChoixTaLi; ChoixTypeTali.ItemIndex := 0; End;
  if QualifPiece<>nil		then QualifPiece.value := 'N';
  if Affichage<>nil then
    BEGIN
    Affichage.OnClick:=AffichageOnClick;
    Affichage.itemindex:=0;
    SetControlText('DEBIT','E_DEBIT') ;
    SetControlText('CREDIT','E_CREDIT') ;
    SetControlText('COUVERTURE','E_COUVERTURE') ;
    END ;
  if AffMontants<>nil then
    BEGIN
    AffMontants.itemindex:=0;
    SetControlText('AFFMONTANT','NORMAL') ;
    END ;
  if Impression<>nil then
    BEGIN
    Impression.OnClick:=ImpressionOnClick;
    Impression.itemindex:=0;
    SetControlText('IMPRESSION','DECI');
    END ;
  if (Gene1<>nil) and (Gene2<>nil) then
    BEGIN
    Gene1.OnChange:=Gene1OnChange;
    Gene2.OnChange:=Gene2OnChange;
    END ;
  if Rupture1<>nil then Rupture1.OnDblClick:=Rupture1OnDblClick;
  if Rupture2<>nil then Rupture2.OnDblClick:=Rupture1OnDblClick;
  if TriPar<>nil   then
    BEGIN
    TriPar.OnChange:=TriParOnChange;
    TriPar.OnDblClick:=TriParOnDblClick;
    SetControlEnabled('SAUTPAGE',False);
    SetControlEnabled('SURRUPTURE',False);
    END ;
  BalPrev.OnClick := BalTypeOnChange;
  BalRet.OnClick := BalTypeOnChange;
  //=====> Param selon type de balance
  ParametreEtatType;
  // Init options des ruptures
  UpdateOptions(false);
  ChoixTypeTali.Visible := TL_TIERSCOMPL_Actif;

  if GetParamSocSecur('SO_CPMULTIERS', false) then
  begin
    THEdit(GetControl('T_AUXILIAIRE', true)).OnElipsisClick:=AuxiElipsisClick;
    THEdit(GetControl('T_AUXILIAIRE', true)).OnElipsisClick:=AuxiElipsisClick;
  end;
END;

procedure TOF_BALAGEE.OnLoad;
var stTypeEcr : String;
begin
  inherited;
	// Auto-remplissage si comptes auxiliaires non renseign�s
	if (GetControlText('T_AUXILIAIRE')='') then
    SetControlText('T_AUXILIAIRE',GetMinMaxCompte('TIERS', 'MIN(T_AUXILIAIRE)','0'));
	if (GetControlText('T_AUXILIAIRE_')='') then
    SetControlText('T_AUXILIAIRE_',GetMinMaxCompte('TIERS', 'MAX(T_AUXILIAIRE)','ZZZZZZZZZZZZZZZZZ'));
	// Auto-remplissage si comptes collectifs non renseign�s
	if (Gene1.Text='') then
  	begin
    Gene1.Text := GetMinMaxCompte('GENERAUX', 'MIN(G_GENERAL)','0');
		SetControlText('COLLECTIF1',GetControlText('GENERAL'));
    end;
	if (Gene2.Text='') then
  	begin
    Gene2.Text := GetMinMaxCompte('GENERAUX', 'MAX(G_GENERAL)','ZZZZZZZZZZZZZZZZZ');
		SetControlText('COLLECTIF2',GetControlText('GENERAL_'));
    end;
	// Affichage des montants
  if AffMontants.ItemIndex = 1
  	then SetControlText('AFFMONTANT','SIGNES')
    else SetControlText('AFFMONTANT','NORMAL');
	// libell�s pour les types d'�critures...
  AvecQualifPiece.Text := '';
	stTypeEcr := QualifPiece.Value;
	if stTypeEcr <> '' then
    while stTypeEcr <> '' do
	    AvecQualifPiece.Text := AvecQualifPiece.Text
      			+ RechDom(QualifPiece.DataType,ReadTokenSt(stTypeEcr),False)
            + ' '
  else
  	AvecQualifPiece.Text := '<<Tous>>';

  // Si exoV8 renseign�, alors on ne prend que les ecritures post d�but d'exoV8
  if (VH^.ExoV8.Code <> '') then
    SetControlText('DateExoV8', UsDateTime(VH^.ExoV8.Deb) )
  else
    SetControlText('DateExoV8', UsDateTime(iDate1900) ) ;

  // Remplir les conditions SQL
  GenererConditionSQL;
end;

//==============================================================================

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 02/06/2005
Modifi� le ... : 02/06/2005
Description .. : Ajout du param�tre de type de table libre pour appel de la 
Suite ........ : fonction de param�trage des tables libres
Suite ........ : 
Mots clefs ... :
*****************************************************************}
PROCEDURE TOF_BALAGEE.Rupture1OnDblClick (Sender : TObject);
VAR    St,St1,St2,St3,Arg : String ;
       i : integer ;
       OkAssoc : integer ;
BEGIN
  OkAssoc := 0;
  Arg     := GetControlText('RUPTURE1')+'|'+GetControlText('RUPTURE2');
  if GetControlVisible('CHOIXTYPETALI') then
    Arg := Arg + '|' + GetControlText('CHOIXTYPETALI')
  else Arg:= Arg + '|AUX';
  St      := CPLanceFiche_TLTIERSRUPT(Arg); {JP 25/08/04 : FQ 13401, 13452, 13671}
  St1     := ReadTokenPipe(St,'|');
  SetControlText('RUPTURE1',St1);
  SetControlText('RUPTURE2',St);
  for i:=0 to 9 do
    BEGIN
    St2:=ReadTokenSt(St1);
    if (St2<>'#') and (St2<>'-') and (St2<>'') then
      BEGIN
        if ChoixTypeTaLi.Value = 'AUX' then
                St3:=St3+'T0'+IntToStr(i)+';'
        else if ChoixTypeTaLi.Value = 'CLI' then
              St3:=St3+'LT'+IntToHex(i+1,1)+';'
        else St3 :=St3+'AR'+IntToHex(i+1,1)+';';
      OkAssoc:=OkAssoc+1 ;
      END ;
    SetControlText('TRIPAR',St3);
    END ;

  // MAJ interface si aucune rupture s�lectionn�e
  UpdateOptions( OkAssoc > 0 ) ;
  if OkAssoc = 0 then
    begin
    SetControlText('RUPTURE1', '');
    SetControlText('RUPTURE2', '');
    SetControlText('TRIPAR',   '');
    end ;
END;

PROCEDURE TOF_BALAGEE.TriParOnChange (Sender : TObject);
BEGIN
if GetControlText('TRIPAR')='' then
  BEGIN
  SetControlChecked('SAUTPAGE',False);
  SetControlChecked('SURRUPTURE',False);
  END else
  BEGIN
  SetControlEnabled('SAUTPAGE',True);
  SetControlEnabled('SURRUPTURE',True);
  end;
END;

PROCEDURE TOF_BALAGEE.TriParOnDblClick (Sender : TObject);
VAR    St,Arg:String;
BEGIN
Arg := GetControlText('TRIPAR');
St  := CPLanceFiche_TLTIERSTRI(Arg); {JP 25/08/04 : FQ 13401, 13452, 13671}
SetControlText('TRIPAR',St);
END;

PROCEDURE TOF_BALAGEE.Gene1OnChange (Sender : TObject);
BEGIN
SetControlText('COLLECTIF1',GetControlText('GENERAL'));
END;

PROCEDURE TOF_BALAGEE.Gene2OnChange (Sender : TObject);
BEGIN
SetControlText('COLLECTIF2',GetControlText('GENERAL_'));
END;

PROCEDURE TOF_BALAGEE.ImpressionOnClick (Sender : TObject);
BEGIN
case Impression.ItemIndex of
  0 : SetControlText('IMPRESSION','DECI');
  1 : SetControlText('IMPRESSION','KILO');
  2 : SetControlText('IMPRESSION','MEGA');
  3 : SetControlText('IMPRESSION','ENTI');
  end;
END;

PROCEDURE TOF_BALAGEE.AffichageOnClick (Sender : TObject) ;
BEGIN
case Affichage.ItemIndex of
  0 : BEGIN SetControlText('DEBIT','E_DEBIT')     ; SetControlText('CREDIT','E_CREDIT')     ; SetControlText('COUVERTURE','E_COUVERTURE') ; END ;
  1 : BEGIN SetControlText('DEBIT','E_DEBITDEV')  ; SetControlText('CREDIT','E_CREDITDEV')  ; SetControlText('COUVERTURE','E_COUVERTUREDEV') ; END ;
  end;
END;

PROCEDURE TOF_BALAGEE.DeviseOnChange (Sender : TObject);
BEGIN
  if Devise.ItemIndex=0 then
	  begin
  	SetControlText('DEVPIVOT','%');
    Affichage.ItemIndex := 0;
    Affichage.Enabled := False;
	  end
  else
  	begin
	  SetControlText('DEVPIVOT',GetControlText('DEVISE'));
    Affichage.Enabled := True;
  	end;
END ;

PROCEDURE TOF_BALAGEE.EtablissementOnChange (Sender : TObject);
BEGIN
if ComboEtab.ItemIndex=0 then SetControlText('ETAB','%')
                         else SetControlText('ETAB',GetControlText('ETABLISSEMENT'));
END;

PROCEDURE TOF_BALAGEE.NatureAuxiOnChange (Sender : TObject) ;
Var CGen, CAux : string ;
BEGIN
inherited ;
SetControlText('T_AUXILIAIRE','');
SetControlText('T_AUXILIAIRE_','');
SetControlText('GENERAL','');
SetControlText('GENERAL_','');
SetControlText('NATUREAUX',GetControlText('T_NATUREAUXI'));
CGen := GetTabletteColl(NatureAuxi.value);
CAux := GetTabletteTiers(NatureAuxi.value);
SetControlProperty('T_AUXILIAIRE','DATATYPE',CAux);
SetControlProperty('T_AUXILIAIRE_','DATATYPE',CAux);
SetControlProperty('GENERAL','DATATYPE',CGen);
SetControlProperty('GENERAL_','DATATYPE',CGen);
END ;

PROCEDURE PeriodiciteChange(Iperiodicite : Integer ; FP10,FP1 : THEdit ; var TabD : TTabDate10) ;
VAR Choix,i : Integer ;
    a,m,j, JMax : Word ;
    DAT : TDATETIME ;
BEGIN
//Choix:=FPeriodicite.ItemIndex ;
Choix:=IPeriodicite ;
If Choix<=-1 Then Choix:=0 ;
   TabD[10]:=StrToDate(FP10.text) ;       { Calcul � partir de la date d'arr�t�e }
   Case IPeriodicite of
     0,1,2,3,4,5 : for i:=5 downto 1 Do { Pour chaque Fourchette de dates( en partant de la derni�re) , en mensuel }
                       BEGIN
                       DAT:=PlusMois(TabD[i+5],-(Choix+1)) ;
                       DecodeDate(DAT,a,m,j) ;
                       JMax:=StrToInt(FormatDateTime('d',FinDeMois(EncodeDate(a,m,1)))) ;
                       TabD[i]:=PlusMois(TabD[i+5],-(Choix+1))+(JMax-J)+1 ;
                       if i>1 then TabD[i+4]:=TabD[i]-1 ;
                       END ;
     6           : for i:=5 downto 1 Do { Pour chaque Fourchette de dates( en partant de la derni�re) , en Quinzaine }
                       BEGIN
                       DAT:=TabD[i+5] ;
                       DecodeDate(DAT,a,m,j) ;
                       JMax:=StrToInt(FormatDateTime('d',FinDeMois(EncodeDate(a,m,1)))) ;
                       If J<=15 then
                          BEGIN         { Date d�part = (Date d'arriv�e - 15 jours) + 1 jour, si date avant le 15 du mois }
                          TabD[i]:=TabD[i+5]-(15  )+1 ;
                          END Else
                          BEGIN         { Date d�part = (Date d'arriv�e - (Nb jours Max du mois - 15 jours) ) + 1 jour, si date apr�s le 15 du mois }
                          TabD[i]:=TabD[i+5]-(JMax-15)+1 ;
                          END ;
                       if i>1 then TabD[i+4]:=TabD[i]-1 ;
                       END ;
     7           : for i:=5 downto 1 Do { Pour chaque Fourchette de dates( en partant de la derni�re) , en Hebdo }
                       BEGIN            { Date d�part = (Date d'arriv�e - (7 jours+ 1 jours) )  }
                       TabD[i]:=TabD[i+5]-(7)+1 ;
                       if i>1 then TabD[i+4]:=TabD[i]-1 ;
                       END ;
     End ;
END;

PROCEDURE TOF_BALAGEE.PeriodiciteOnChange(Sender : TObject);
BEGIN
inherited ;
CalculPeriodesAvecPeriodicite;
END;

PROCEDURE TOF_BALAGEE.DateArreteOnChange(Sender : TObject);
BEGIN
inherited ;
if not IsValidDate(GetControlText('DATE1')) then exit;
if (EtatType = 'VENTIL') and (TRadioButton(GetControl('BALPREV')).Checked)
	then SetControlText('PERIODE1',GetControlText('DATE1'))
	else SetControlText('PERIODE'+IntToStr(NbPeriodes+5),GetControlText('DATE1'));
EcartOnChange(nil);
END;

PROCEDURE TOF_BALAGEE.EcartOnChange(Sender : TObject);
BEGIN
inherited ;
SetControlVisible('PERIODES',Ecart.ItemIndex=1);
if Ecart.ItemIndex=0 then NbJEcartOnChange(nil)
                     else PeriodiciteOnChange(nil);
END;

PROCEDURE NbJEcartCalculDate(FP10 : THEdit ; NbjEcart : integer ; var TabD : TTabDate10) ;
VAR i : Integer ;
BEGIN
TabD[10]:=StrToDate(FP10.Text) ;       { Calcul � partir de la date d'arr�t�e }
For i:=5 downto 1 do
  BEGIN
    TabD[i]:=TabD[i+5]-(NbJEcart-1);
    if i>1 then TabD[i+4]:=TabD[i]-1;
  end;
END;

PROCEDURE TOF_BALAGEE.NbJEcartOnChange(Sender : TObject);
BEGIN
inherited;
if GetControlText('NBJECART')='' then exit;
CalculPeriodesAvecNbJour;
END ;

function TOF_BALAGEE.GetMinMaxCompte(stTable, stCol, stDefaut : String) : String;
var
	Q : TQuery;
	stWhere : String;
begin
	// Condition d�pend de la nature auxiliaire
	if stTable = 'GENERAUX' then
    if NatureAuxi.Value <> '' then stWhere := GetWhereColl(NatureAuxi.Value)
		else stWhere := ' WHERE G_COLLECTIF="X"'
  else
    if NatureAuxi.Value <> '' then
      stWhere := ' WHERE T_NATUREAUXI="' + NatureAuxi.Value + '"';
	// Requ�te
 	Q := OpenSQL('SELECT ' + stCol +' CODE FROM ' + stTable + stWhere,True);
  if not Q.Eof
  	then Result := Q.FindField('CODE').asString
	  else Result := stDefaut;
  Ferme(Q);
end;

function TOF_BALAGEE.GetTabletteColl(stNatureTiers : String): String;
begin
  if stNatureTiers='CLI' then result := 'TZGCOLLCLIENT' 		else
	  if stNatureTiers='FOU' then result := 'TZGCOLLFOURN' 			else
  		if stNatureTiers='SAL' then result := 'TZGCOLLSALARIE' 		else
			  if stNatureTiers='DIV' then result := 'TZGCOLLDIVERS' 		else
				  if stNatureTiers='AUC' then result := 'TZGCOLLTOUTDEBIT' 	else
					  if stNatureTiers='AUD' then result := 'TZGCOLLTOUTCREDIT' else
           	  result := 'TZGCOLLECTIF';
end;

function TOF_BALAGEE.GetTabletteTiers(stNatureTiers: String): String;
begin
  if stNatureTiers='CLI' then result := 'TZTCLIENT' 		 	else
    if stNatureTiers='FOU' then result := 'TZTFOURN' 				else
      if stNatureTiers='SAL' then result := 'TZTSALARIE' 			else
        if stNatureTiers='DIV' then result := 'TZTDIVERS' 			else
          if stNatureTiers='AUC' then result := 'TZTTOUTDEBIT' 		else
            if stNatureTiers='AUD' then result := 'TZTTOUTCREDIT' 	else
              result := 'TZTTOUS';
end;

function TOF_BALAGEE.GetWhereColl(stNatureTiers : String): String;
begin
  result := ' WHERE G_COLLECTIF="X"';
  if stNatureTiers='CLI' then result := result + ' AND G_NATUREGENE="COC"' 		else
	  if stNatureTiers='FOU' then result := result + ' AND G_NATUREGENE="COF"' 		else
  		if stNatureTiers='SAL' then result := result + ' AND G_NATUREGENE="COS"' 		else
			  if stNatureTiers='DIV' then result := result + ' AND G_NATUREGENE="COD"' 		else
				  if stNatureTiers='AUC' then result := result + ' AND (G_NATUREGENE="COC" OR G_NATUREGENE="COD")' 		else
					  if stNatureTiers='AUD' then result := result + ' AND (G_NATUREGENE="COF" OR G_NATUREGENE="COD")';
end;

procedure TOF_BALAGEE.GenererConditionSQL;
var stWhere, stWhereQP, stTypeEcr : String;
begin
	// Condition sur les comptes g�n�raux
  stWhere := ' AND E_GENERAL>="' + GetControlText('COLLECTIF1') +
  					 '" AND E_GENERAL<="' + GetControlText('COLLECTIF2') + '"';
  // Condition sur le lettrage
	if EnSituation.Checked then
	  stWhere := stWhere + ' AND ((E_ETATLETTRAGE<>"TL" AND E_ETATLETTRAGE<>"RI")'
    											 + ' OR (E_ETATLETTRAGE="TL" AND E_DATEPAQUETMAX>"'
                           + USDateTime(StrToDate(DateArrete.Text)) + '"))'
  else
	  stWhere := stWhere + ' AND E_ETATLETTRAGE<>"TL" AND E_ETATLETTRAGE<>"RI"';
	// Condition sur le type de piece
  stWhere := stWhere + ' AND E_QUALIFPIECE<>"C" AND E_ECRANOUVEAU<>"CLO"'
                     + ' AND E_ECRANOUVEAU<>"OAN"' ;
	stTypeEcr := QualifPiece.Value;
	if stTypeEcr <> '' then
  	begin
    stWhereQP := '';
    while stTypeEcr <> '' do
      if stWhereQP = ''	then stWhereQP := ' AND E_QUALIFPIECE IN ("' + ReadTokenSt(stTypeEcr) + '"'
      									else stWhereQP := stWhereQP + ',"' + ReadTokenSt(stTypeEcr) + '"';
    stWhere := stWhere + stWhereQP + ')';
    end;
  // Condition sur l'etablissement
	if ComboEtab.itemIndex > 0 then
	  stWhere := stWhere + ' AND E_ETABLISSEMENT = "' + ComboEtab.value + '"';
  // Condition sur la devise
	if Devise.itemIndex > 0 then
	  stWhere := stWhere + ' AND E_DEVISE = "' + Devise.value + '"';
  //=======================
  ConditionSQL.Text := stWhere;
end;

procedure TOF_BALAGEE.ParametreEtatType;
var stTitre : String;
begin
	if EtatType = 'VENTIL' then
  	begin
    // Modif titre QRS1
    stTitre := 'Balance ventil�e en situation';
    TFQRS1(Ecran).Caption := stTitre;
    UpdateCaption(Ecran);
    // Pour la balance ventil� seulement 4 p�riodes :
    SetControlVisible('TPERIODE5',False);
    SetControlVisible('PERIODE5',False);
    SetControlVisible('TPERIODE10',False);
    SetControlVisible('PERIODE10',False);
    //Affiche du type de balance (Prevision / Retard)
    SetControlVisible('TBALTYPE',True);
    SetControlVisible('BALPREV',True);
    SetControlVisible('BALRET',True);
    SetControlProperty('BALRET','checked',False);
    SetControlProperty('BALPREV','checked',True);
    // Changement de la nature de l'�tat
    TFQRS1(Ecran).NatureEtat := 'BAV';
		TFQRS1(Ecran).CodeEtat := 'BAV';
    end
  else
  	begin
    // Modif titre QRS1
    stTitre := 'Balance �g�e en situation';
    TFQRS1(Ecran).Caption := stTitre;
    UpdateCaption(Ecran);
    //Cache le type de balance ventil�e (Prevision / Retard)
    SetControlVisible('TBALTYPE',False);
    SetControlVisible('BALPREV',False);
    SetControlVisible('BALRET',False);
    end;
    Ecran.Caption :=TraduireMemoire(Ecran.Caption) ;
    UpdateCaption(Ecran);
end;

procedure TOF_BALAGEE.CalculPeriodesAvecNbJour;
var
	i, NbJours : Integer ;
  Prevision : Boolean;
	TabD : TTabDate10;
begin
	// Initalisation et param�trage suivant type �tat
  NbJours := NbJEcart.value;
	FillChar(TabD,SizeOf(TabD),#0);
  Prevision := (EtatType = 'VENTIL') and (TRadioButton(GetControl('BALPREV')).Checked);

	// Calcul des p�riodes
	if Prevision then
		begin  			// si pr�vision, date d'arrete = date depart
    TabD[1] := StrToDate(DateArrete.Text) + 1;
    for i:=1 to NbPeriodes do
      begin
        TabD[i+5] := TabD[i] + NbJours;
        if i<5 then TabD[i+1] := TabD[i+5] + 1;
      end;
    end
 	else
  	begin				// sinon, date d'arrete = date de fin
    TabD[NbPeriodes+5] := StrToDate(DateArrete.Text);
    for i:=NbPeriodes downto 1 do
      begin
        TabD[i]:=TabD[i+5]-(NbJours-1);
        if i>1 then TabD[i+4]:=TabD[i]-1;
      end;
    end;

	// Remplissage des contr�les
  for i:=1 to 10 do
  	SetControlText('PERIODE'+IntToStr(i),DateToStr(TabD[i]));
end;

procedure TOF_BALAGEE.CalculPeriodesAvecPeriodicite;
var
	i, ChoixPeriode : Integer ;
  an,mois,jour,JMax : Word ;
  DAT : TDATETIME ;
  Prevision : Boolean;
	TabD : TTabDate10;
begin
	// Initalisation et param�trage suivant type �tat
	FillChar(TabD,SizeOf(TabD),#0);
	ChoixPeriode := Periodicite.itemindex;
  Prevision := (EtatType = 'VENTIL') and (TRadioButton(GetControl('BALPREV')).Checked);
	if Prevision
  	then TabD[1] := StrToDate(DateArrete.Text) + 1		 			// si pr�vision, date d'arrete = date depart
  	else TabD[NbPeriodes+5] := StrToDate(DateArrete.Text);	// sinon, date d'arrete = date de fin

	// Calcul en fonction de la p�riodicit� choisie
  case ChoixPeriode of
    0,1,2,3,4,5 :			  			// ===> P�riodicit� de 1 � 6 mois
    	if Prevision then
        for i:=1 to NbPeriodes do  { Pour chaque Fourchette de dates( en partant de la premi�re) , en mensuel }
          begin
          	TabD[i+5]:=PlusMois(TabD[i],(ChoixPeriode+1))-1;
            if i<NbPeriodes then TabD[i+1]:=TabD[i+5]+1 ;
          end
      else
        for i:=NbPeriodes downto 1 do { Pour chaque Fourchette de dates( en partant de la derni�re) , en mensuel }
          begin
          DAT:=PlusMois(TabD[i+5],-(ChoixPeriode+1)) ;
          DecodeDate(DAT,an,mois,jour) ;
          JMax:=StrToInt(FormatDateTime('d',FinDeMois(EncodeDate(an,mois,1)))) ;
          TabD[i]:=PlusMois(TabD[i+5],-(ChoixPeriode+1))+(JMax-jour)+1 ;
          if i>1 then TabD[i+4]:=TabD[i]-1 ;
          end ;
    6           :					    // ===> P�riodicit� de 15 jours
    	if Prevision then
        for i:=1 to NbPeriodes do	{ Pour chaque Fourchette de dates (en partant de la premi�re) , en Quinzaine }
           begin
           TabD[i+5]:=TabD[i]+ 15 ;
           if i<5 then TabD[i+1]:=TabD[i+5]+1 ;
           end
      else
        for i:=5 downto 1 Do { Pour chaque Fourchette de dates( en partant de la derni�re) , en Quinzaine }
           begin
           DAT:=TabD[i+5] ;
           DecodeDate(DAT,an,mois,jour) ;
           JMax:=StrToInt(FormatDateTime('d',FinDeMois(EncodeDate(an,mois,1)))) ;
           if Jour<=15
           	then TabD[i]:=TabD[i+5]-15+1 			{ Date d�part = (Date d'arriv�e - 15 jours) + 1 jour, si date avant le 15 du mois }
           	else TabD[i]:=TabD[i+5]-(JMax-15)+1 ; { Date d�part = (Date d'arriv�e - (Nb jours Max du mois - 15 jours) ) + 1 jour, si date apr�s le 15 du mois }
           if i>1 then TabD[i+4]:=TabD[i]-1 ;
           end;
    7           :             // ===> P�riodicit� de 1 semaine
    	if Prevision then
        for i:=1 to NbPeriodes Do	{ Pour chaque Fourchette de dates( en partant de la premi�re) , en Hebdo }
          begin										{ Date d'arriv�e = (Date de d�part + 7 jours)  }
          TabD[i+5]:=TabD[i]+7;
          if i<5 then TabD[i+1]:=TabD[i+5]+1 ;
          end
			else
		    for i:=5 downto 1 Do  { Pour chaque Fourchette de dates( en partant de la derni�re) , en Hebdo }
          begin            		{ Date d�part = (Date d'arriv�e - (7 jours+ 1 jours) )  }
          TabD[i]:=TabD[i+5]-(7)+1 ;
          if i>1 then TabD[i+4]:=TabD[i]-1 ;
          end ;
  	end ;

		// Remplissage des contr�les
    for i:=1 to 10 do	SetControlText('PERIODE'+IntToStr(i),DateToStr(TabD[i]));
end;

procedure TOF_BALAGEE.BalTypeOnChange(Sender: TObject);
begin
	DateArreteOnChange(nil);
end;

procedure TOF_BALAGEE.OnNew;
begin
  inherited;
	if EtatType = 'VENTIL' then
  	begin
    // Changement de la nature de l'�tat
    TFQRS1(Ecran).NatureEtat := 'BAV'; // VL Erreur sur la nature de l'�tat
		TFQRS1(Ecran).CodeEtat := 'BAV';
    end ;
  // Etat en situation par d�faut
  if FFiltres.Text = '' then
    EnSituation.Checked := True ;  	

end;

procedure TOF_BALAGEE.UpdateOptions(vBoAvecRupt: Boolean);
// MAJ acc�s aux checkbox li�s aux options de ruptures
begin
  if not vBoAvecRupt then
    begin
    SetControlChecked( 'SAUTPAGE',    False );
    SetControlChecked( 'SURRUPTURE',  False );
    end ;
  SetControlChecked( 'CPTASSOCIES', vBoAvecRupt );
  SetControlEnabled( 'CPTASSOCIES', vBoAvecRupt );
  SetControlEnabled( 'SAUTPAGE',    vBoAvecRupt );
  SetControlEnabled( 'SURRUPTURE',  vBoAvecRupt );
end;

procedure TOF_BALAGEE.OnClickChoixTaLi(Sender: TObject);
begin
  SetControlText('RUPTURE1','');
  SetControlText('RUPTURE2','');
  SetControlText('TRIPAR','');
  SetControlEnabled('TRIPAR',(ChoixTypeTaLi.Value <> 'SCL') and (ChoixTypeTaLi.Value <> 'CLI'));
end;

{***********A.G.L.***********************************************
Auteur  ...... : YMO
Cr�� le ...... : 12/04/2007
Modifi� le ... :   /  /
Description .. : Branchement de la fiche auxiliaire
Mots clefs ... :
*****************************************************************}
procedure TOF_BALAGEE.AuxiElipsisClick( Sender : TObject );
begin
     THEdit(Sender).text:= CPLanceFiche_MULTiers('M;' +THEdit(Sender).text + ';' +THEdit(Sender).Plus + ';');
end;

INITIALIZATION
RegisterClasses([TOF_BALAGEE]) ;
END.

