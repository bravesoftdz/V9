{***********UNITE*************************************************
Auteur  ...... : MD
Cr�� le ...... : 15/05/2003
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : YY YYMESSAGES ()
Mots clefs ... : TOF;YMESSAGES
*****************************************************************}
Unit UTofYYMessages ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
     Windows,
{$IFDEF EAGLCLIENT}
     maineagl,
     UTob,
     eMul,
     MenuOLX,
{$ELSE}
     FE_Main,
     Mul,
     MenuOlg,
{$ENDIF}
     HDB,
     HQry,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOF,
     HTB97,
     AGLInit,
     HDTLinks,
     ExtCtrls,
     Grids, Menus, UMailBox, MajTable,
     UTofYYMessagesParent,DBGrids;

Type
  TOF_YYMESSAGES = Class (TOF_YYMESSAGESPARENT)
    procedure OnArgument (S : String ) ; override ;
    procedure OnClose ; override ;
  public
    procedure mnBasculerClick(Sender: TObject);
    procedure FLISTE_OnDblClick(Sender: TObject);

    {$IFNDEF EAGLCLIENT}
    procedure FLISTE_OnDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    {$ENDIF}

    procedure PCBOITE_OnChange(Sender : TObject);
    procedure BIMPORTOUTLOOK_OnClick(Sender: TObject);
    procedure BMAILDOWNLOAD_OnClick(Sender: TObject);
    procedure BGLOBAL_OnClick(Sender : TObject);

    procedure YMS_NODOSSIERElipsisClick(Sender: TObject);
    procedure TimerMsg_OnTimer(Sender: TObject);
    procedure BAgrandirClick(Sender: TObject);
    procedure BReduireClick(Sender: TObject);

//    procedure Form_OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); overload;
    
  private
    PCBoite : TPageControl;
    mvUserFrom, mvUserDest : THMultiValComboBox;
    XXPlus  : String;    // Crit�re de filtrage pour la propri�t� Plus des multivalcombobox
    XXWhere : String;    // Crit�re de filtrage du mul
    BGlobal : TToolBarButton97;
    TimerMsg : TTimer;
    OldDrawColumnCell : TDrawColumnCellEvent ;
    procedure UpdateTitreEcran;
    procedure CustomChangeListeCrit(Plus : Boolean);
    procedure LibereMultiValCombo(mv: THMultiValComboBox);
    procedure SetCritereXXWhere(BoiteEnvoi : Boolean);
    {$IFDEF EAGLCLIENT}
    procedure AfficheDetailDestinataire;
    {$ENDIF}
    function GetDetailDestinataire(sValue : string) : String;
  end ;

/////////////// IMPLEMENTATION ////////////////
Implementation

uses YNewMessage,

     {$IFDEF VER150}
     Variants,
     {$ENDIF}

     YMessage, UtilMessages, galOutil, UtilMulTraitmt, TntGrids,
  TntDBGrids;


//-----------------------
//--- Nom : OnArgument
//-----------------------
procedure TOF_YYMESSAGES.OnArgument (S : String ) ;
// Obligation de g�rer XXWhere en plus de XXPlus, car si on ne donne pas de valeur
// dans les multivalcombo, on n'a pas de filtrage sur les �lts autoris�s par la prop. Plus
var SQL, tmpSQL : String;
    DataTypeLink : TYDataTypeLink;
    tmpIndex : Integer;
begin
  Inherited ;
  SetControlVisible('BIMPRIMER', False); // l'impression plante car liste virtuelle

  mvUserFrom := THMultiValComboBox(GetControl('YMS_USERFROM'));
  mvUserDest := THMultiValComboBox(GetControl('YMS_USERDEST'));

  //--- Les crit�res du PageControl sont inacessibles par d�faut
  TPageControl(GetControl('Pages')).Align := alNone;
  SetControlVisible('BAgrandir', False);
  SetControlVisible('BReduire', True);
  XXPlus := 'US_UTILISATEUR="'+V_PGI.User+'"';
  XXWhere := 'YMS_USERDEST="'+V_PGI.User+'"';

  //--- Branche les �v�nements
  if GetControl('YMS_NODOSSIER')<>Nil then
    THEdit(GetControl('YMS_NODOSSIER')).OnElipsisClick := YMS_NODOSSIERElipsisClick;

  if ((GetControl('mnImprimer'))<>nil) then
   TMenuItem(GetControl('mnImprimer')).Visible := False;

  if ((GetControl('mnBasculer'))<>nil) then
   begin
    TMenuItem(GetControl('mnBasculer')).OnClick := mnBasculerClick;
    TMenuItem(GetControl('mnBasculer')).Visible := False;
   end;

  BGlobal := TToolBarButton97(GetControl('BGLOBAL'));
  PCBoite := TPageControl(GetControl('PCBOITE'));
  PCBoite.OnChange := PCBOITE_OnChange;
  iMessagerieEnCours := PCBoite.ActivePageIndex;

  TToolBarButton97(GetControl('BIMPORTOUTLOOK')).OnClick := BIMPORTOUTLOOK_OnClick;
  TToolBarButton97(GetControl('BMAILDOWNLOAD')).OnClick := BMAILDOWNLOAD_OnClick;
  TToolBarButton97(GetControl('BAgrandir')).OnClick := BAgrandirClick;
  TToolBarButton97(GetControl('BReduire')).OnClick := BReduireClick;
  TToolBarButton97(GetControl('BINSERT')).OnClick := mnInsertClick;

  //-- Gestion des �v�nements sur la liste --
  if Lst <> nil then
  begin
    OldDrawColumnCell := nil;
    Lst.OnDblClick := FLISTE_OnDblClick;
    {$IFDEF EAGLCLIENT}
    AfficheDetailDestinataire;
    {$ELSE}
    OldDrawColumnCell := Lst.OnDrawColumnCell ;
    Lst.OnDrawColumnCell := FLISTE_OnDrawColumnCell;
    {$ENDIF}
  end;

  // Un user peut voir les mails d'autres users :
  // ce param�trage de droits utilise les tablettes hi�rarchiques
  DataTypeLink := V_DataTypeLinks.FirstMaster('YYUTILISATMASTER', tmpIndex);
  if DataTypeLink<>Nil then
    begin
    // Recherche les users pour lesquels le user en cours peut voir les mails
    tmpSQL := DataTypeLink.GetSql(V_PGI.User, False);
    SQL := GetTabletteSQL('YYUTILISATSLAVE', tmpSQL, True );
    // GetSQL donne les enfants : DataTypeLink.GetSql(V_PGI.User, False) renverra
    // ' EXISTS(SELECT * FROM YDATATYPETREES WHERE (YDT_CODEHDTLINK = "YYUSERMASTERSLAVE")
    //  AND (YDT_MCODE = "CEG") AND (YDATATYPETREES.YDT_SCODE = UTILISAT.US_UTILISATEUR))'
    if ExisteSQL(SQL) then
      begin
      if (GetControl ('mnBasculer') <> nil) then TMenuItem(GetControl('mnBasculer')).Visible := True;
      BGlobal.Visible := True;
      // si vue globale demand�e en argument...
      if S='GLOBAL' then BGlobal.Down := True;
      XXPlus := XXPlus + ' OR (' + tmpSQL + ')';
      // Pour le mul, le crit�re s'applique directement aux destinataires (YMS_USERDEST)
      // plut�t qu'� la s�lection sur la tablette esclave :
      XXWhere := XXWhere + ' OR (' + StringReplace(tmpSQL, 'UTILISAT.US_UTILISATEUR', 'YYMESSAGES_MUL.YMS_USERDEST', [rfReplaceAll]) + ')';
      BGlobal.OnClick := BGLOBAL_OnClick;
      end;
    end;

  // Par d�faut, on ouvre sur la bo�te de r�ception du user en cours...
  mvUserDest.Plus := XXPlus;
  SetCritereXXWhere(False);
  if (BGlobal.Visible) and (BGlobal.Down) then
    // ... globale
    begin
    mvUserDest.Text := '';
    mvUserDest.Enabled := True;
    // par contre, tant pis on ne peut pas changer la liste � cet endroit...
    // TFMul(Ecran).Q.Liste := 'YYMESSAGES_INGLOB'; => access vio !
    end
  else
    // ... ou restreinte
    begin
    mvUserDest.Text := V_PGI.User;
    mvUserDest.Enabled := False;
    end;

  // Pas d'�x�cution automatique des crit�res car on veut contr�ler (crit�res masqu�s)
  if TFMul(Ecran).AutoSearch<>asMouetteForce then
    begin
    TFMul(Ecran).SearchTimer.Enabled := False;
    TFMul(Ecran).SearchTimer.OnTimer := Nil;
    end;

  UpdateTitreEcran;

  // Timer pour rafraichissement liste des messages
  TimerMsg := TTimer.Create(Ecran);
  TimerMsg.Interval := 60000; // 1 minute
  TimerMsg.OnTimer := TimerMsg_OnTimer;
  TimerMsg.Enabled := True;

  // sinon on est perdu, car les crit�res �tendus ne sont pas affich�s
  SetFocusControl('FLISTE');
end ;

//----------------------------
//--- Nom : mnBasculerClick
//----------------------------
procedure TOF_YYMESSAGES.mnBasculerClick(Sender: TObject);
begin
 BGlobal.Down:=not (BGlobal.down);
 BGlobal_OnClick (Sender);
end;

//----------------------------
//--- Nom : BGlobal_OnClick
//----------------------------
procedure TOF_YYMESSAGES.BGLOBAL_OnClick(Sender: TObject);
begin
 PCBOITE_OnChange(Nil);
end;

//-----------------------------
//--- Nom : PCBOITE_OnChange
//-----------------------------
procedure TOF_YYMESSAGES.PCBOITE_OnChange(Sender: TObject);
begin
  // pour la classe anc�tre
  iMessagerieEnCours := PCBoite.ActivePageIndex;

  // Purge crit�res de recherche du mul
  TFMul(Ecran).BNouvRechClick(Nil);

  // Autorise personnalisation de la liste
  TFMul(Ecran).Q.Manuel := True; // m�me si n'emp�che pas la double-�x�cution de req...

  // Par d�faut, on n'affiche que des messages non archiv�s
  SetControlChecked('YMS_TRAITE', False);

  // ci-dessous Inutiles : ne changent rien � la double �x�cution de requ�te
  // TFMul(Ecran).DBListe := '';
  // TFMul(Ecran).Q.Liste := '';

  // Changement DBListe et crit�res
  // #### Pb : r��x�cute inutilement lors du Q.Liste := xxx la vieille requ�te
  // du DBListe du query... ( cf HQry.SetListe => FabricSQL => UpdateSQL => rouvre la req)
  // m�me si on l'a modifi� avant par .DBListe := xxx !!

  // #### Rq : pour l'instant obligation modifier Q.Liste sinon pas de reconstruction
  // des colonnes, � moins qu'il existe un "redessinelagrille selon la nouvelle liste" ???
  case iMessagerieEnCours of

  cMsgBoiteReception :
    begin
    //TFMul(Ecran).DBListe := 'YYMESSAGES_IN';
    LibereMultiValCombo(mvUserFrom);
    SetControlChecked('YMS_BROUILLON', False);
    SetCritereXXWhere(False);
    // Globale
    if (BGlobal.Visible) and ((BGlobal.Down)) then
      begin
      mvUserDest.Plus := XXPlus;
      mvUserDest.Text := '';
      mvUserDest.Enabled := True;
      // liste avec destinataire en toutes lettres
      TFMul(Ecran).SetDBListe('YYMESSAGES_INGLOB');
      end
    // Individuelle
    else
      begin
      mvUserDest.Plus := XXPlus;
      mvUserDest.Text := V_PGI.User;
      mvUserDest.Enabled := False;
      TFMul(Ecran).SetDBListe('YYMESSAGES_IN');
      end;
    end;

  cMsgBoiteDenvoi :
    begin
    LibereMultiValCombo(mvUserDest);
    SetCritereXXWhere(True);
    mvUserFrom.Plus := 'US_UTILISATEUR="'+V_PGI.User+'"';
    mvUserFrom.Text := V_PGI.User;
    mvUserFrom.Enabled := False;
    SetControlChecked('YMS_BROUILLON', False);
    TFMul(Ecran).SetDBListe('YYMESSAGES_OUT');
    end;

  cMsgBrouillons :
    begin
    LibereMultiValCombo(mvUserDest);
    SetCritereXXWhere(True);
    mvUserFrom.Plus := 'US_UTILISATEUR="'+V_PGI.User+'"';
    mvUserFrom.Text := V_PGI.User;
    mvUserFrom.Enabled := False;
    SetControlChecked('YMS_BROUILLON', True);
    TFMul(Ecran).SetDBListe('YYMESSAGES_OUT');
    end;
  end;

  // R�ouverture grille
  // TFMul(Ecran).Q.Open; : => se fait tout seul avec le SetListe
  TFMul(Ecran).Q.Manuel := False; // => ceci n'emp�che pas double-requ�te

  // Maj autom vu qu'on a d�sactiv� le timer
  TFMul(Ecran).BChercheClick(Nil);

  UpdateTitreEcran;
end;

procedure TOF_YYMESSAGES.OnClose ;
begin
  Inherited ;
  TimerMsg.Free;
end ;

procedure TOF_YYMESSAGES.UpdateTitreEcran;
begin
  case PCBoite.ActivePageIndex of
  0 : begin
      if (BGlobal.Visible) and (BGlobal.Down) then
        Ecran.Caption := 'Bo�te de r�ception globale - '+V_PGI.UserName
      else
        Ecran.Caption := 'Bo�te de r�ception - '+V_PGI.UserName ;
      end;
  1 : Ecran.Caption := 'Bo�te d''envoi - '+V_PGI.UserName ;
  2 : Ecran.Caption := 'Brouillons - '+V_PGI.UserName ;
  end;
  UpdateCaption(Ecran);
  {+GHA - FQ 11536}
  {$IFDEF EAGLCLIENT}
  AfficheDetailDestinataire;
  {$ENDIF}
  {-GHA - FQ 11536}
end;

procedure TOF_YYMESSAGES.BIMPORTOUTLOOK_OnClick (Sender : Tobject);
begin
     // Importe dans PGI les mails qui sont s�lectionn�s dans Outlook !
     UserOutlookmailImport;

     // $$$ JP 27/09/05 - il faut FALSE pour ne pas forcer le download de message, juste copie mails vers messages
     //BMAILDOWNLOAD_OnClick(Sender);
     // distribution YMAILS => YMESSAGES pour le user en cours
     MailsToMessages (Ecran, 'Probl�me de r�ception des mails :', '', FALSE);

     // Actualise
     if (PCBoite.ActivePageIndex = cMsgBoiteReception) then
        TFMul(Ecran).BChercheClick(Nil)
     // ou va sur bo�te de r�ception
     else
     begin
          PCBoite.ActivePageIndex := cMsgBoiteReception;
          // pourquoi ne se d�clenche pas ?
          PCBOITE_OnChange(Nil);
     end;
end;

procedure TOF_YYMESSAGES.BMAILDOWNLOAD_OnClick(Sender: TObject);
begin
  // distribution YMAILS => YMESSAGES pour le user en cours
  MailsToMessages(Ecran, 'Probl�me de r�ception des mails :');

  // Actualise
  if (PCBoite.ActivePageIndex = cMsgBoiteReception) then
    TFMul(Ecran).BChercheClick(Nil)
  // ou va sur bo�te de r�ception
  else
    begin
    PCBoite.ActivePageIndex := cMsgBoiteReception;
    // pourquoi ne se d�clenche pas ?
    PCBOITE_OnChange(Nil);
    end;
end;

procedure TOF_YYMESSAGES.FLISTE_OnDblClick(Sender: TObject);
var sNoDossier : String;
begin
  if VarIsNull(GetField('YMS_MSGGUID') ) or ( GetField('YMS_MSGGUID')='' ) then exit;

  if GetControlText('YMS_BROUILLON')='X' then
    ShowNewMessage(GetField('YMS_MSGGUID'))
  else
    sNoDossier:= ShowFicheMessage( GetField('YMS_MSGGUID'), iMessagerieEnCours=cMsgBoiteDenvoi );

  // si on a modifi� le message...
  AGLRefreshDB([LongInt(Ecran), 'FListe'], 2);
  // si on a demand� l'acc�s � un dossier client :
  if sNoDossier <> '' then
  begin
    // s�lectionne le dossier demand�
    if Not LanceContexteDossier(sNoDossier) then exit;

    // Passe au module "Dossier client"
    FMenuG.LanceDispatch(76501);
  end;

  {+GHA - FQ 11536}
  {$IFDEF EAGLCLIENT}
  AfficheDetailDestinataire;
  {$ENDIF}
  {-GHA - FQ 11536}
end;

procedure TOF_YYMESSAGES.TimerMsg_OnTimer(Sender: TObject);
// actualise r�guli�rement la liste des messages affich�s
var
{$IFDEF EAGLCLIENT}
    iColTri  : Integer;
    bSensTri : Boolean;
{$ELSE}
    colonnetriee : String;
    i : Integer;
{$ENDIF}
begin
  // On ne lance pas le rafraichissement si on est en train de faire des s�lections !
  if (TFMul(Ecran).FListe.nbSelected>0) or (TFMul(Ecran).FListe.AllSelected) then exit;
{$IFDEF EAGLCLIENT}
  iColTri  := Lst.SortedCol;
  bSensTri := Lst.SortDesc;
  // Perd l'ordre de tri en cours
  TToolbarButton97(GetControl('BCHERCHE')).Click;
  // le r�tablit
  Lst.SortGrid(iColTri, bSensTri);
{$ELSE}
  colonnetriee := Lst.SortedCol;
  // si on se r�cup�re un nom de colonne au lieu d'un n� de colonne
  if Not IsNumeric(colonnetriee) then
    begin
    for i:=0 to TFMul(Ecran).FListe.Columns.Count-1 do
      begin
      if TFMul(Ecran).FListe.Columns[i].Field.FieldName=colonnetriee then
        begin
        colonnetriee := IntToStr(i+1);
        break;
        end;
      end;
    end;
  // Perd l'ordre de tri en cours
  TToolbarButton97(GetControl('BCHERCHE')).Click;
  // On le r�tablit
  if IsNumeric(colonnetriee) then
    TFMul(Ecran).FListe.AutoSortColumn(StrToInt(colonnetriee)-1);
{$ENDIF}

  {+GHA - FQ 11536}
  AGLRefreshDB([LongInt(Ecran), 'FListe'], 2);
  {$IFDEF EAGLCLIENT}
  AfficheDetailDestinataire;
  {$ENDIF}
  {-GHA - FQ 11536}
end;

procedure TOF_YYMESSAGES.BAgrandirClick(Sender: TObject);
begin CustomChangeListeCrit(True) ; end;

procedure TOF_YYMESSAGES.BReduireClick(Sender: TObject);
begin CustomChangeListeCrit(False) ; end;

procedure TOF_YYMESSAGES.CustomChangeListeCrit(Plus: Boolean);
// copi� de ChangeListeCrit (agl) mais prend le bon PageControl
// (sinon il prend PCBoite, celui que j'ai cr�� !!)
var
  i: integer;
  C, G: TControl;
  CC: TComponent;
begin
  G := nil;
  for i := 0 to Ecran.ControlCount - 1 do
  begin
    C := Ecran.Controls[i];
    if C is TPageControl then
    begin
      if C.Name<>'PCBOITE' then  // MD
        if Plus then TPageControl(C).Align := AlNone else TPageControl(C).Align := AlTop;
    end else
    begin
      if ((C is TStringGrid) or (C is THGrid) or (C is THDbGrid)
        or (uppercase(C.Name) = 'FLISTE')) then G := C;
    end;
  end;
  CC := Ecran.FindComponent('BAgrandir');
  if CC <> nil then TControl(CC).Visible := not Plus;
  CC := Ecran.FindComponent('BReduire');
  if CC <> nil then TControl(CC).Visible := Plus;
  if G <> nil then if THGrid(G).CanFocus then THGrid(G).SetFocus;
end;

procedure TOF_YYMESSAGES.LibereMultiValCombo(mv: THMultiValComboBox);
begin
  mv.Text := '';
  mv.Plus := '';
  mv.Enabled := True;
end;

procedure TOF_YYMESSAGES.YMS_NODOSSIERElipsisClick(Sender: TObject);
var St, codper : String;
begin
  // retourne NoDossier;CodePer;Nom1
  St := AGLLanceFiche('YY','YYDOSSIER_SEL', '','',GetControlText('YMS_NODOSSIER'));
  if St<>'' then
    begin
    SetControlText('YMS_NODOSSIER', READTOKENST(St));
    codper := READTOKENST(St);
    SetControlCaption('DOS_LIBELLE', READTOKENST(St));
    // ou GetNomCompPer(codper)
    end
  else
    begin
    SetControlText('YMS_NODOSSIER', '');
    SetControlCaption('DOS_LIBELLE', '');
    end;
end;

procedure TOF_YYMESSAGES.SetCritereXXWhere(BoiteEnvoi : Boolean);
// Utilise le crit�re XXWhere dans XX_Where
// selon affichage boite d'envoi ou pas, et existence du champ pour la g�rer
begin
  if BoiteEnvoi then
    // filtrage boite d'envoi plus simple que boite de r�ception !
    SetControlText('XX_WHERE', 'YMS_INBOX="X"')
  else
    SetControlText('XX_WHERE', '(' + XXWhere + ') AND YMS_INBOX="-"');
end;

{+GHA - 12/2007 - Affichage le d�tail des destinataires du message}
{$IFDEF EAGLCLIENT}
procedure TOF_YYMESSAGES.AfficheDetailDestinataire;
var
  i,j : integer;
  bColExist : boolean;
  s_AllDest,s_AllDestDetail,
  s_Value,s_user : string;
  Cols : TStrings;
begin
  // V�rif l'existence du champ YMS_ALLDEST dans la liste.
  bColExist := false;

  for i:=0 to Lst.ColCount-1 do
  begin
    if SameText('YMS_ALLDEST',Lst.ColNames[i]) then
    begin
      bColExist := true;
      break;
    end;
    Application.ProcessMessages;
  end;

  // Modification du contenu de la colonne en correspondance avec le champ YMS_ALLDEST.
  if bColExist then
  begin
    Cols := TStringList.Create;
    try
      Lst.BeginUpdate;

      Cols.AddStrings(Lst.Cols[i].AnsiStrings);

      for j:=1 to Cols.Count-1 do
      begin
        if Cols[j] <> '' then
          Cols[j] := GetDetailDestinataire(Cols[j]);

        Application.ProcessMessages;
      end;

      Lst.Cols[i].Clear;
      Lst.Cols[i].AddStrings(Cols);
      Lst.EndUpdate;
    finally
      Cols.Free;
    end;
  end;
end;
{$ENDIF}

{$IFNDEF EAGLCLIENT}
// Mode 2 tiers
procedure TOF_YYMESSAGES.FLISTE_OnDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Value : String ;
  Text,s_ColName  : String ;
  Rc    : TRect ;
begin
  s_ColName := Lst.Columns.Items[DataCol].FieldName;

  // V�rif l'existence du champ YMS_ALLDEST dans la liste.
  if SameText('YMS_ALLDEST',s_ColName) then
  begin
    Value := Lst.Columns[DataCol].Field.AsString;

    if Value <> '' then
    begin
      Text := GetDetailDestinataire(Value);
      Rc := Rect ;
      Lst.Canvas.FillRect( Rc );
      Lst.Canvas.TextRect( Rc, (Rc.Left+3), (Rc.Top+Rc.Bottom) div 2 -5 , Text);
    end;
  end;

  if Assigned( OldDrawColumnCell ) then
    OldDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;
{$ENDIF}

function TOF_YYMESSAGES.GetDetailDestinataire(sValue: string): String;
var
  s_user,s_detail,s_AllDestDetail : string;
begin
  // Recherche du libelle pour chaque destinataire
  result := '';
  s_AllDestDetail := '';

  while sValue <> '' do
  begin
    s_user   := READTOKENST(sValue);
    s_detail := RechDom('TTUTILISATEUR',s_user ,FALSE);
    s_detail := s_detail+'('+s_user+')';

    if s_AllDestDetail <> '' then
      s_AllDestDetail := s_AllDestDetail+';';

    s_AllDestDetail := s_AllDestDetail+s_detail;
    Application.ProcessMessages;
  end;
  result := s_AllDestDetail;
end;
{-GHA - 12/2007}


Initialization
  registerclasses ( [ TOF_YYMESSAGES ] ) ;
end.

