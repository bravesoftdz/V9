{-------------------------------------------------------------------------------------
    Version   |   Date | Qui |   Commentaires
--------------------------------------------------------------------------------------
 1.05.001.002  09/03/04  JP   Mise en place du Type de transaction dans les cat�gories de transaction
 1.2X.000.000  05/04/04  JP   Correction du Bug sur les agios pr�compt�s FQ 10034
 1.2X.000.000  15/04/04  JP   Nouvelle gestion des natures (P, R, S)
 6.xx.xxx.xxx  20/07/04  JP   Gestion des commissions dans la r�alisation et l'int�gration
                              cf AnnulationDenouer et Denouage
 6.00.014.001  17/09/04  JP   Conservation des fichiers PDF FQ 10044
 6.50.001.001  31/03/05  JP   FQ 10223, Nouvelle gestion des erreurs globale � l'application
 6.50.001.003  08/06/05  JP   Dans le cadre de la FQ 10223, remplacement du THQuery et du TRECRITURE
                              par des Tob => concerne l'int�gration et la validation BO
 6.50.001.018  14/09/05  JP   Ajout d'un test sur l'existence du r�pertoire "SO_REPSORTIEPDF"
                              afin d'�viter de planter l'application
 7.00.001.001  12/01/06  JP   FQ 10323 : Correction de la gestion de la TVA
 7.05.001.001  18/09/06  JP   Nouvelle gestion de l'int�gration en compta
 8.00.001.021  20/06/07  JP   FQ 10480 : Gestion du concept VBO
 8.10.001.004  08/08/07  JP   Gestion des confidentialit�s
--------------------------------------------------------------------------------------}
unit TofListeCTerme;

interface

uses {$IFDEF VER150} variants,{$ENDIF}
  {$IFDEF EAGLCLIENT}
  eMul, UtileAGL, 
  {$ELSE}
  HDB ,Mul ,{$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} EdtREtat, HPdfPrev, uPDFBatch,
  {$ENDIF}
  Commun, Constantes, Classes, Hctrls, HTB97, HEnt1, Hmsgbox, AGLInit, Ent1, ULibPieceCompta,
  UTOB, Menus,
  {$IFDEF TRCONF}
  uLibConfidentialite,
  {$ELSE}
  UTOF,
  {$ENDIF TRCONF}
  HStatus, Controls, SysUtils, StdCtrls, ParamSoc, UObjGen;


type
  TNumJournal = class
    Journal : string;
  end;

  {$IFDEF TRCONF}
  TOF_ListeCTerme = class (TOFCONF)
  {$ELSE}
  TOF_ListeCTerme = class (TOF)
  {$ENDIF TRCONF}
    procedure OnArgument(Arguments : string); override;
    procedure OnClose                       ; override;
  private
    PopupMenu	: TPopUpMenu;
    MsgAffiche  : Boolean;
    TypeTransac	: string ;
    Categorie   : THValComboBox ;
    Transaction : THValComboBox ;
    NumTransac  : THEdit ;
    BOuvrir     : TToolBarButton97 ;
    BInsert	: TToolBarButton97 ;
    BDelete     : TToolBarButton97 ;
    BFirst      : TToolBarButton97 ;
    BCherche    : TToolBarButton97 ;
    BSelectAll  : TToolBarButton97 ;
    {$IFDEF EAGLCLIENT}
    FListe      : THGrid ;
    {$ELSE}
    FListe      : THDBGrid ;
    {$ENDIF}

    dateCalc	: string ;
    Select 	: boolean ;
    Sens	: string ;

    LImpression : string;

    procedure OnPopUpMenu	(Sender	: TObject);
    procedure CategorieOnChange	(Sender : TObject);
    procedure BOuvrirOnClick	   (Sender : TObject);
    procedure BInsertOnClick	   (Sender : TObject);
    procedure BDeleteOnClick	   (Sender	: TObject);
    procedure MSelectOnClick	   (Sender : TObject);
    procedure DenoueClick       (Sender : TObject);
    procedure DeviseOnChange    (Sender : TObject);
    procedure NoDossierChange   (Sender : TObject);
    procedure SupprimeOperation ;
    procedure AnnulerVBO	       (Sender : TObject);
    procedure ValidationBO	     (Sender : TObject);
    procedure AnnulerDenouer    (Sender : TObject);
    procedure Denouer           (Sender : TObject);
    function  Denouage             : Boolean;
    function  ValiderBO            : Boolean;
    function  AnnulationVBO        : Boolean;
    function  AnnulationDenouer    : Boolean;
    function  SuppressionOperation : Boolean;
    procedure IntegreCompta        ;
  public
    {08/06/05 : Refonte de l'int�gration en compta}
    ObjTva : TObjTVA;
    TobGen : TobPieceCompta;
    procedure Integration(NumTransac : string);
  end;

implementation

uses
  TomCourtsTermes, UProcGen, UProcEcriture, UProcCommission, UProcSolde, FileCtrl,
  UProcEtat, cbpPath;

{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.OnPopupMenu(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  {Il faudra g�rer les droits ici}
  Select := FListe.AllSelected;
  if Select then
    PopupMenu.Items[10].Caption := TraduireMemoire('Tout d�s�lectionner')
  else
    PopupMenu.Items[10].Caption := TraduireMemoire('Tout s�lectionner');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.DenoueClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  if GetCheckBoxState('DENOUE') = cbChecked then
    SetControlText('XX_WHERE', 'TCT_DENOUEUR <> "" AND TCT_DENOUEUR IS NOT NULL')
  else if GetCheckBoxState('DENOUE') = cbUnChecked then
    SetControlText('XX_WHERE', 'TCT_DENOUEUR = "" OR TCT_DENOUEUR IS NULL')
  else
    SetControlText('XX_WHERE', '');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.BOuvrirOnClick(Sender : TObject) ;
{---------------------------------------------------------------------------------------}
begin
  if Length(typeTransac) > 0 then begin
    if GetField('TCT_NUMTRANSAC') <> '' then begin
      if GetField('TCT_VALBO') = 'X' then
        TRLanceFiche_CourtsTermes('TR','TRCOURTSTERMES','',GetField('TCT_NUMTRANSAC'),ActionToString(taConsult) + ';' + Sens + ';' + TypeTransac)
      else
        TRLanceFiche_CourtsTermes('TR','TRCOURTSTERMES','',GetField('TCT_NUMTRANSAC'),ActionToString(taModif) + ';' + Sens + ';' + TypeTransac);
    end ;
  end ;
  BCherche.Click;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.BInsertOnClick(Sender : TObject) ;
{---------------------------------------------------------------------------------------}
begin
  {JP 09/03/04 : Gestion du type de transaction}
  TRLanceFiche_CourtsTermes( 'TR','TRCOURTSTERMES', '','',ActionToString(taCreat) + ';' + sens + ';' + TypeTransac);
  BCherche.Click ;
end ;

{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.BDeleteOnClick(Sender : TObject) ;
{---------------------------------------------------------------------------------------}
begin
  SupprimeOperation ;
  BCherche.Click ;
end ;

{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.MSelectOnClick(Sender : TObject) ;
{---------------------------------------------------------------------------------------}
begin
  if BSelectAll <> Nil then BSelectAll.Click ;
end ;

{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.CategorieOnChange(Sender : TObject) ;
{---------------------------------------------------------------------------------------}
begin
  Transaction.ItemIndex := 0;
  Transaction.plus := 'TTR_CATTRANSAC="'+ Categorie.Value + '"';
end ;

{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.AnnulerVBO(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  i : Integer;
  n : Integer;
  p : Integer;
begin
  {31/03/05 : FQ 10223 : Nouvelle gestion des erreurs}
  InitGestionErreur(CatErr_TRE);

  MsgAffiche := False;
  n := FListe.NbSelected;
  p := 0;

  if (n = 0) then begin
    MessageAlerte(TraduireMemoire('Aucun �l�ment s�lectionn�'));
    exit;
  end;

  if TrShowMessage(Ecran.Caption, 14, '', '') <> mrYes then exit ;

  InitMove(n,'');
  for i := 0 to n - 1 do begin
    FListe.gotoLeBookmark(i);
    MoveCur(False);
    if AnnulationVBO then
      Inc(p);
  end;

  FListe.ClearSelected;
  FListe.Refresh;
  FiniMove;

  if not AfficheMessageErreur(Ecran.Caption, 'Certaines op�rations n''ont pu �tre d�valid�es :') then begin
    if p > 0 then
      HShowMessage('0;' + Ecran.Caption + ';Traitement termin� (' + IntToStr(p) + ' transaction(s) d�valid�e(s)).;I;O;O;O;', '', '')
    else
      HShowMessage('0;' + Ecran.Caption + ';Traitement termin� (aucune transaction n''a �t� d�valid�e).;I;O;O;O;', '', '');
  end;
  BCherche.Click ;
end;

{JP 08/08/03 : Avant l'annulation BO d'une op�ration on s'assure qu'il n'y a pas eu d'�criture
               en comptabilit�, sinon on interdit l'annulation
{---------------------------------------------------------------------------------------}
function TOF_ListeCTerme.AnnulationVBO : Boolean;
{---------------------------------------------------------------------------------------}
var
  SQL       : string ;
  Cle       : string ;
  CompteGen : string ;
  DateComptable : string;
begin
  Result := False;

  if VarToStr(GetField('TCT_STATUT')) = 'X' then begin
    SetErreurTreso(NatErr_Int);
    Exit;
  end;

  if VarToStr(GetField('TCT_VALBO')) <> 'X' then
    Exit;

  Cle := VarToStr(GetField('TCT_NUMTRANSAC'));
  if Cle > '' then begin
    BeginTrans;
    try
      CompteGen := VarToStr(GetField('TCT_COMPTETR'));
      DateComptable := VarToStr(GetField('TCT_DATEDEPART'));
      {Maj de la transaction}
      SQL := 'UPDATE COURTSTERMES SET TCT_VALBO="-", TCT_DENOUEUR = "", TCT_TICKET="-", TCT_LETTRECONFIRM="-", TCT_ORDREPAIE="-" WHERE TCT_NUMTRANSAC="'+cle+'"' ;
      ExecuteSQL(SQL);
      {Suppression des �critures aff�rantes}
      SQL := 'DELETE TRECRITURE WHERE TE_NUMTRANSAC="' + cle + '"' ;
      ExecuteSQL(SQL);

      if (CompteGen > '') and (not FListe.AllSelected) then
        RecalculSolde(CompteGen, DateComptable, 0, True);
      CommitTrans;
      Result := True;
    except
      RollBack;
    end;
  end ;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.ValidationBO(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  i : Integer;
  n : Integer;
  c : string;
  S : string;
begin
  {31/03/05 : FQ 10223 : Nouvelle gestion des erreurs}
  InitGestionErreur(CatErr_TRE);

  n := FListe.NbSelected;

  LImpression := '';

  if (n = 0) then begin
    MessageAlerte(TraduireMemoire('Aucun �l�ment s�lectionn�'));
    exit;
  end;

  if TrShowMessage(Ecran.Caption, 17, '', '') <> mrYes then exit ;

  dateCalc := StDate2099;
  for i := 0 to n - 1 do begin
    FListe.gotoLeBookmark(i);
    if ValiderBO then
      LImpression := LImpression + '"' + VarToStr(GetField('TCT_NUMTRANSAC')) + '",';
  end;
  FListe.ClearSelected;
  FListe.Refresh;

  BCherche.Click ;

  {FQ 10223 : Nouvelle gestion des erreurs}
  AfficheMessageErreur(Ecran.Caption, 'Certaines op�rations n''ont pu �tre valid�es : ');

  {JP 03/03/04 : Il est pr�f�rable de ne pas afficher l'aper�u si on ne demande aucun �tat}
  if (LImpression <> '') and (GetParamSocSecur('SO_TICKETOPE', False) or
     GetParamSocSecur('SO_LETTRECONFIRM', False) or GetParamSocSecur('SO_ORDREPAIEMENT', False)) then begin

    {06/10/06 : Pour la gestion de la fonction de r�cup�ration des paramsoc multi soci�t�s}
    GereDllEtat(True);

    System.Delete(LImpression, Length(LImpression), 1);

    {14/09/05 : Test l'existence du r�pertoire sinon en CWas, cela plante}
    if not DirectoryExists(GetParamSocSecur('SO_REPSORTIEPDF', TcbpPath.GetCegidUserLocalAppData, True)) then begin
      HShowMessage('0;' + Ecran.Caption + ';Le r�pertoire de sortie des �ditions n''existe pas.'#13 +
                                          'Veuillez v�rifier le param�tre soci�t�.;W;O;O;O;', '', '');
      Exit;
    end;

    c := GetParamSocSecur('SO_REPSORTIEPDF', TcbpPath.GetCegidUserLocalAppData) + '\TRANSAC.PDF';
    V_PGI.NoPrintDialog := True;
    V_PGI.QRPDF := True;
    V_PGI.QRPDFQueue := c;
    V_PGI.QRPDFMerge := c;
    try
      LImpression := 'TCT_NUMTRANSAC IN (' + LImpression + ')';
      StartPDFBatch(c);

      if GetParamSocSecur('SO_TICKETOPE', False) then begin
        LanceEtat('E', 'TCT', 'TCT', True, False, False, nil, LImpression, '', False); {Ticket d'Op�ration}
        S := 'UPDATE COURTSTERMES SET TCT_TICKET="X" WHERE ' + LImpression;
        ExecuteSQL(S);
      end;

      if GetParamSocSecur('SO_LETTRECONFIRM', False) then begin
        LanceEtat('E', 'TCL', 'TCL', True, False, False, nil, LImpression, '', False);{Lettre de confirmation}
        S := 'UPDATE COURTSTERMES SET TCT_LETTRECONFIRM="X" WHERE ' + LImpression;
        ExecuteSQL(S);
      end;

      if GetParamSocSecur('SO_ORDREPAIEMENT', False) then begin
        LanceEtat('E', 'TCO', 'TCO', True, False, False, nil, LImpression, '', False);{Ordre de paiement}
        S := 'UPDATE COURTSTERMES SET TCT_ORDREPAIE="X" WHERE ' + LImpression;
        ExecuteSQL(S);
      end;

      CancelPDFBatch;

      {$IFNDEF EAGLCLIENT}
      {FQ 10044 : Copy du fichier PDF car celui g�n�rer par l'AGL est supprimer apr�s l'aper�u}
      CopierFichier(c, GetParamSocSecur('SO_REPSORTIEPDF', TcbpPath.GetCegidUserLocalAppData), 'COURTTERME', 'PDF');
      PreviewPDFFile('', c);
      {$ENDIF}
    finally
      V_PGI.QRPDF := False;
      V_PGI.QRPDFQueue := '';
      V_PGI.QRPDFMerge := '';
      {06/10/06 : Pour la gestion de la fonction de r�cup�ration des paramsoc multi soci�t�s}
      GereDllEtat(False);
    end;
  end;
end;

{---------------------------------------------------------------------------------------}
function TOF_ListeCTerme.ValiderBO : Boolean;
{---------------------------------------------------------------------------------------}
var
  SQL : string ;
  Cle : string ;
  Statut  : string ;
  tEcr    : TOB;
  NbJambe : Integer ;
  DateDe  : TDateTime;
  CodeUnq : string;
  ObjCom  : TObjCommissionTob;
  NbDec   : Integer; {24/05/05}
  Cotat   : Double;  {24/05/05}
  ObjD    : TObjDetailDevise;{24/05/05}
begin
  Result := True;
  {24/05/05 : Gestion du format des montants}
  NbDec := V_PGI.OkDecV;
  Cotat := 1;

  Statut := VarToStr(GetField('TCT_STATUT'));
  if Statut <> 'X' then begin
    Cle := VarToStr(GetField('TCT_NUMTRANSAC'));
    if Cle > '' then begin
      if VarToStr(GetField('TCT_VALBO')) <> 'X' then begin
        BeginTrans;
        try
          DateDe := iDate2099;
          {24/05/05 : Si le traitement ne se fait pas en devise pivot}
          if VarToStr(GetField('TCT_DEVMONTANT')) <> V_PGI.DevisePivot then begin
            ObjD    := TObjDetailDevise.Create;
            try
              TheData := ObjD;
              Cotat := RetPariteEuro(VarToStr(GetField('TCT_DEVMONTANT')), V_PGI.DateEntree);
              {RetPariteEuro renvoie le taux (1 Dev = x.xx �) => on transforme en cotation (1� = x.xx Dev)}
              NbDec := ObjD.NbDecimal;
              if Cotat = 0 then Cotat := 1
                           else Cotat := Arrondi(1 / Cotat, NbDec);
            finally
              TheData := nil;
              if Assigned(ObjD) then FreeAndNil(ObjD);
            end;
          end;

          for NbJambe := 1 to 3 {MAXNBJAMBES} do begin
            tEcr := TOB.Create('TRECRITURE', nil, -1);
            try
              tEcr.SetString('TE_SOCIETE'  , VarToStr(GetField('TCT_SOCIETE')));
              tEcr.SetString('TE_NODOSSIER', VarToStr(GetField('TCT_NODOSSIER')));

              {Initialisation des valeur par d�faut}
              InitNlleEcritureTob(TEcr, VarToStr(GetField('TCT_COMPTETR')), VarToStr(GetField('TCT_NODOSSIER')));
              tEcr.SetString('TE_DEVISE', VarToStr(GetField('TCT_DEVMONTANT')));
              tEcr.SetDouble('TE_COTATION', Cotat);

              tEcr.SetString('TE_LIBELLE', VarToStr(GetField('TCT_LIBELLE')));
              tEcr.SetString('TE_USERCREATION', VarToStr(GetField('TCT_OPERATEURCRE')));
              tEcr.SetString('TE_USERMODIF', VarToStr(GetField('TCT_OPERATEURMOD')));
              tEcr.SetString('TE_USERVALID', V_PGI.User);
              tEcr.SetString('TE_NUMTRANSAC', Cle) ;
              tEcr.SetDateTime('TE_DATECREATION', Date);
              tEcr.SetDateTime('TE_DATEMODIF',    Now);
              tEcr.SetDateTime('TE_DATEVALID',    Date);

              {R�cup�ration du RIB et de l'IBAN}
              GetRibTob(tEcr);

              {On s'assure que le code banque n'est pas vide}
              if Trim(tEcr.GetString('TE_CODEBANQUE')) = '' then
                SetErreurTreso(NatErr_Bqe);

              {JP 26/08/03 : Pour le moment seuls trois type de flux sont g�r�s, et ce en dur : Versement, agios,
                             et tomb�e => restent amortissement et l'autre tomb�e : a Revoir !!!!!!!!!!
                             J'ai cr�� dans Constantes un type TInfosTransac qui permettrait de g�rer les 5 jambes
                             et d'�viter les requ�tes multipes sur la table Transac : GetCodeAFB, GetContrepartie ...}
              {La jambe 1 concerne la mise en place}
              if NbJambe = 1 then begin
                tEcr.SetString('TE_CODECIB', GetCodeAFB(VarToStr(GetField('TCT_TRANSAC')), VERSEMENT));

                tEcr.SetString('TE_CODEFLUX', GetCodeFlux(VarToStr(GetField('TCT_TRANSAC')), VERSEMENT));

                tEcr.SetDouble('TE_MONTANTDEV', Valeur(GetField('TCT_MNTMEP')));
                {JP 02/09/03 : Si les agios/Int�r�ts sont d�duits, on r�cup�re le montant saisi pour "r�ajouter"
                               les agios et int�r�ts et ce dans le but de cr�er une ligne contenant les agios / int�r�ts
                               6000 / 100 / 6000 : on pourrait envisager que 2 jambes 5900 / 6000, � �tudier ....}
                if VarToStr(GetField('TCT_DEDUIT')) = 'X' then
                  tEcr.SetDouble('TE_MONTANTDEV', Valeur(GetField('TCT_MONTANT')));

                {JP 26/08/03 : R�cup�ration du compte de contrepartie dans la table TRANSAC}
                tEcr.SetString('TE_CONTREPARTIETR', GetContrepartie(VarToStr(GetField('TCT_TRANSAC')), VERSEMENT));

                if GetSensFlux(VarToStr(GetField('TCT_TRANSAC')), VERSEMENT) = 'D' then
                begin
                  tEcr.SetDouble('TE_MONTANTDEV', - tEcr.GetDouble('TE_MONTANTDEV'));
                  tEcr.SetString('TE_REFINTERNE', Cle +  ' vers ' + tEcr.GetString('TE_CONTREPARTIETR'));
                end
                else
                  tEcr.SetString('TE_REFINTERNE', Cle + ' de ' + tEcr.GetString('TE_CONTREPARTIETR'));

                tEcr.SetDouble('TE_MONTANT', Arrondi(tEcr.GetDouble('TE_MONTANTDEV') / tEcr.GetDouble('TE_COTATION'), V_PGI.OkDecV));
                tEcr.SetDouble('TE_MONTANTDEV', Arrondi(tEcr.GetDouble('TE_MONTANTDEV'), NbDec));
                tEcr.SetDateTime('TE_DATECOMPTABLE', VarToDateTime(GetField('TCT_DATEDEPART')));
              end ;

              {La jambe 2 concerne les Agios/Int�r�ts}
              if NbJambe = 2 then begin
                tEcr.SetString('TE_CODECIB', GetCodeAFB(VarToStr(GetField('TCT_TRANSAC')), AGIOSINTERETS));

                tEcr.SetString('TE_CODEFLUX', GetCodeFlux(VarToStr(GetField('TCT_TRANSAC')), AGIOSINTERETS));
                tEcr.SetDouble('TE_MONTANTDEV', VarToDle(GetField('TCT_MNTAGIOS')));

                {JP 26/08/03 : R�cup�ration du compte de contrepartie dans la table TRANSAC}
                tEcr.SetString('TE_CONTREPARTIETR', GetContrepartie(VarToStr(GetField('TCT_TRANSAC')), AGIOSINTERETS));

                if GetSensFlux(VarToStr(GetField('TCT_TRANSAC')), AGIOSINTERETS)='D' then
                begin
                  tEcr.SetString('TE_REFINTERNE', Cle + ' vers ' + tEcr.GetString('TE_CONTREPARTIETR'));
                  tEcr.SetDouble('TE_MONTANTDEV', - tEcr.GetDouble('TE_MONTANTDEV'));
                end
                else
                  tEcr.SetString('TE_REFINTERNE', Cle + ' de ' + tEcr.GetString('TE_CONTREPARTIETR'));

                tEcr.SetDouble('TE_MONTANT', Arrondi(tEcr.GetDouble('TE_MONTANTDEV') / tEcr.GetDouble('TE_COTATION'), V_PGI.OkDecV));
                tEcr.SetDouble('TE_MONTANTDEV', Arrondi(tEcr.GetDouble('TE_MONTANTDEV'), NbDec)); {25/05/05}

                {JP 02/09/03 : Si les agios/Int�r�ts sont d�duits, les agios sont pris en compte � la date de d�part}
                if VarToStr(GetField('TCT_DEDUIT')) = 'X' then
                  tEcr.SetDateTime('TE_DATECOMPTABLE', VarToDateTime(GetField('TCT_DATEDEPART')))
                {JP 05/04/04, FQ 10034 : Si les agios/Int�r�ts sont pr�compt�s, les agios sont pris en compte � la date de d�part}
                else if VarToStr(GetField('TCT_PRECOMPTE')) = 'X' then
                  tEcr.SetDateTime('TE_DATECOMPTABLE', VarToDateTime(GetField('TCT_DATEDEPART')))
                else
                  tEcr.SetDateTime('TE_DATECOMPTABLE', VarToDateTime(GetField('TCT_DATEFIN')));
              end ;

              {La jambe 3 concerne la Tomb�e}
              if NbJambe = 3 then begin
                tEcr.SetString('TE_CODECIB', GetCodeAFB(VarToStr(GetField('TCT_TRANSAC')), TOMBEE));

                tEcr.SetString('TE_CODEFLUX', GetCodeFlux(VarToStr(GetField('TCT_TRANSAC')), TOMBEE));

                tEcr.SetDouble('TE_MONTANTDEV', VALEUR(GetField('TCT_MNTTOMBE')));

                {JP 26/08/03 : R�cup�ration du compte de contrepartie dans la table TRANSAC}
                tEcr.SetString('TE_CONTREPARTIETR', GetContrepartie(VarToStr(GetField('TCT_TRANSAC')), TOMBEE));

                if GetSensFlux(VarToStr(GetField('TCT_TRANSAC')), TOMBEE)='D' then begin
                  tEcr.SetString('TE_REFINTERNE', cle + ' vers ' + tEcr.GetString('TE_CONTREPARTIETR'));
                  tEcr.SetDouble('TE_MONTANTDEV', - tEcr.GetDouble('TE_MONTANTDEV'));
                end
                else
                  tEcr.SetString('TE_REFINTERNE', Cle + ' de ' + tEcr.GetString('TE_CONTREPARTIETR'));

                tEcr.SetDouble('TE_MONTANT', Arrondi(tEcr.GetDouble('TE_MONTANTDEV') / tEcr.GetDouble('TE_COTATION'), V_PGI.OkDecV));
                tEcr.SetDouble('TE_MONTANTDEV', Arrondi(tEcr.GetDouble('TE_MONTANTDEV'), NbDec)); {25/05/05}
                tEcr.SetDateTime('TE_DATECOMPTABLE', VarToDateTime(GetField('TCT_DATEFIN')));
              end ;

              {Si le code flux et le code cib sont renseign�s, on part du principe que les autres champs
               sont convenablement renseign�s : on va donc pouvoir �crire dans la table}
              if (tEcr.GetString('TE_CODECIB') <> '') and (tEcr.GetString('TE_CODEFLUX') <> '') then begin
                if tEcr.GetDateTime('TE_DATECOMPTABLE') < DateDe then
                  DateDe := tEcr.GetDateTime('TE_DATECOMPTABLE');

                tEcr.SetString('TE_EXERCICE', VG_ObjetExo.GetExoNodos(tEcr.GetDateTime('TE_DATECOMPTABLE'),
                                                                      tEcr.GetString('TE_NODOSSIER')));
                tEcr.SetDateTime('TE_DATEVALEUR', CalcDateValeur(tEcr.GetString('TE_CODECIB'), tEcr.GetString('TE_GENERAL'), tEcr.GetDateTime('TE_DATECOMPTABLE')));
                {G�n�ration des cl�s}
                CodeUnq := GetNum(CODEUNIQUE, CODEUNIQUE, CODEUNIQUE);
                tEcr.SetString('TE_CLEVALEUR',    RetourneCleEcriture(tEcr.GetDateTime('TE_DATEVALEUR'   ), StrToInt(CodeUnq)));
                tEcr.SetString('TE_CLEOPERATION', RetourneCleEcriture(tEcr.GetDateTime('TE_DATECOMPTABLE'), StrToInt(CodeUnq)));
                SetNum(CODEUNIQUE, CODEUNIQUE, CODEUNIQUE, CodeUnq);

                {Initialisation des soldes}
                tEcr.SetDouble('TE_SOLDEDEV', 	  0);
                tEcr.SetDouble('TE_SOLDEDEVVALEUR', 0);

                ObjCom := TObjCommissionTob.Create(TEcr.GetString('TE_GENERAL'), TEcr.GetString('TE_CODEFLUX'), TEcr.GetDateTime('TE_DATECOMPTABLE'));
                try
                  {16/07/04 : gestion des commissions avant l'�criture de l'op�ration financi�re car le num�ro
                              de transaction peut �tre modifi� dans ObjCom.GenererCommissions}
                  CategorieCurrent := CatErr_COM;
                  ObjCom.GenererCommissions(tEcr);
                  ObjCom.TobEcriture.InsertDB(nil);
                  tEcr.InsertDb(nil);
                finally
                  if Assigned(ObjCom) then FreeAndNil(ObjCom);
                end;
              end;
            finally
              if Assigned(tEcr) then FreeAndNil(tEcr);
            end;
          end; {for NbJambe := 0}

          {On recalcule les soldes � partir de la date la plus ancienne de la transaction en cours.}
          RecalculSolde(VarToStr(GetField('TCT_COMPTETR')), DateToStr(DateDe), 0, True);

          {Mise � jour du champ VBO}
          SQL := 'UPDATE COURTSTERMES SET TCT_VALBO = "X", TCT_OPERATEURVBO = "' +  V_PGI.User +
                  '", TCT_DATEVBO = "' + USDateTime(v_PGI.DateEntree) + '" WHERE TCT_NUMTRANSAC = "' + Cle + '"' ;
          ExecuteSQL(SQL);

          CommitTrans;
        except
          on E : Exception do begin
            Result := False;
            RollBack;
          end;
        end;
      end; {if VarToStr(GetField('TCT_VALBO'))}
    end; {if Cle > '' then}
  end; {if Statut <> 'X' then}
end;

{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.SupprimeOperation;
{---------------------------------------------------------------------------------------}
var
  i : integer;
  n : Integer;
  p : Integer;
begin
  {31/03/05 : FQ 10223 : Nouvelle gestion des erreurs}
  InitGestionErreur(CatErr_TRE);

  n := FListe.NbSelected;

  if (n = 0) then begin
    MessageAlerte(TraduireMemoire('Aucun �l�ment s�lectionn�'));
    exit;
  end;

  if TrShowMessage(Ecran.Caption, 2, '', '') <> mrYes then Exit ;

  InitMove(n, '');
  p := 0;
  for i := 0 to n - 1 do begin
    FListe.gotoLeBookmark(i);
    MoveCur(False);
    if SuppressionOperation then
      Inc(p);
  end;
  FListe.ClearSelected;
  FListe.Refresh;
  FiniMove;

  if not AfficheMessageErreur(Ecran.Caption, 'Certaines op�rations n''ont pu �tre supprim�es :') then begin
    if p > 0 then
      HShowMessage('0;' + Ecran.Caption + ';Traitement termin� (' + IntToStr(p) + ' transaction(s) supprim�e(s)).;I;O;O;O;', '', '')
    else
      HShowMessage('0;' + Ecran.Caption + ';Traitement termin� (aucune transaction n''a �t� supprim�e).;I;O;O;O;', '', '');

    BCherche.Click ;
  end;
end;

{JP 08/08/03 : Avant la suppression d'une op�ration on s'assure qu'il n'y a pas eu d'�criture
               en comptabilit�, sinon on interdit la suppression
{---------------------------------------------------------------------------------------}
function TOF_ListeCTerme.SuppressionOperation : Boolean;
{---------------------------------------------------------------------------------------}
var
  SQL : String ;
  Cle : string ;
begin
  Result := False;

  if VarToStr(GetField('TCT_STATUT')) = 'X' then begin;
    SetErreurTreso(NatErr_Int);
    Exit;
  end;

  Cle := VarToStr(GetField('TCT_NUMTRANSAC'));
  if Cle > '' then begin
    BeginTrans;
    try
      {Suppression de la transaction}
      SQL := 'DELETE FROM COURTSTERMES WHERE TCT_NUMTRANSAC = "' + cle +'"' ;
      ExecuteSQL(SQL);
      {Suppression des �critures aff�rantes}
      SupprimePiece(VarToStr(GetField('TCT_NODOSSIER')), Cle, '', '');

      CommitTrans;
      Result := True;
    except
      Rollback;
    end;
  end ;
end;

{JP 27/08/03 : L'op�ration n'est plus consid�r�e comme r�alis�e. On passe TE_NATURE � vide
               Il n'est possible d'annuler le d�nouement d'une op�ration que si elle n'est
               pas int�gr�e en comptabilit�
{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.AnnulerDenouer(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  i : Integer;
  n : Integer;
  p : Integer;
begin
  {31/03/05 : FQ 10223 : Nouvelle gestion des erreurs}
  InitGestionErreur(CatErr_TRE);

  n := FListe.NbSelected;

  if (n = 0) then begin
    MessageAlerte(TraduireMemoire('Aucun �l�ment s�lectionn�'));
    exit;
  end;

  if HShowMessage('1;Annulation du d�nouage;Vous allez annuler le d�nouage des transactions s�lectionn�es. Confirmez vous l''op�ration ?;Q;YN;N;N', '', '') <> mrYes then Exit ;

  InitMove(n, '');
  p := 0;
  for i := 0 to n - 1 do begin
    FListe.GotoLeBookmark(i);

    MoveCur(False);
    if AnnulationDenouer then Inc(p);
  end;
  FListe.ClearSelected;
  FListe.Refresh;

  FiniMove;
  if not AfficheMessageErreur(Ecran.Caption, 'Certaines op�rations n''ont pu �tre d�nou�es :') then begin
    if p > 0 then
      HShowMessage('0;' + Ecran.Caption + ';Traitement termin� (' + IntToStr(p) + ' transaction(s) annul�e(s)).;I;O;O;O;', '', '')
    else
      HShowMessage('0;' + Ecran.Caption + ';Traitement termin� (aucune transaction n''a �t� annul�e).;I;O;O;O;', '', '');
    {Raffraichissement des champs de la liste en particulier TCT_DENOUEUR}
    BCherche.Click;
  end;
end;

{---------------------------------------------------------------------------------------}
function TOF_ListeCTerme.AnnulationDenouer : Boolean;
{---------------------------------------------------------------------------------------}
var
  SQL : string ;
  Cle : string ;
begin
  Result := False;

  if VarToStr(GetField('TCT_STATUT')) = 'X' then begin;
    SetErreurTreso(NatErr_Int);
    Exit;
  end;

  if VarToStr(GetField('TCT_DENOUEUR')) = '' then
    Exit;

  Cle := VarToStr(GetField('TCT_NUMTRANSAC'));
  if Cle > '' then begin
    BeginTrans;
    try
      {Mise � jour du champ TE_NATURE; JP 15/04/04 : maintenant, on met � "P"}
      UpdatePieceStr(VarToStr(GetField('TCT_NODOSSIER')), Cle, '', '', 'TE_NATURE', na_Prevision);
      SQL := 'UPDATE COURTSTERMES SET TCT_DENOUEUR = "" WHERE TCT_NUMTRANSAC = "' + Cle + '"';
      ExecuteSQL(SQL);
      CommitTrans;
      Result := True;
    except
      RollBack;
    end;
  end ;
end;

{JP 27/08/03 : Une op�ration est consid�r�e comme d�nou�e lorsqu'elle est r�alis�e.
               Il faut qu'elle soit valider back office pour la d�nouer ; on passe
               alors TE_NATURE � "R". On propose l'int�gration en comptabilit�
{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.Denouer(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n, i : Integer;
  IntegreOk : Boolean;
begin
  n := FListe.NbSelected;
  {On vide la tob d'int�gration en comptabilit�}
  TobGen.ClearDetailPC;

  if (n = 0) then begin
    MessageAlerte(TraduireMemoire('Aucun �l�ment s�lectionn�'));
    exit;
  end;

  if HShowMessage('1;' + Ecran.Caption + ';Vous allez d�nouer les transactions s�lectionn�es. Confirmez vous l''op�ration ?;Q;YN;N;N', '', '') <> mrYes then Exit ;

  {On regarde s'il va falloir int�grer les �critures ne comptabilit�}
  IntegreOk := AutoriseFonction(dac_Integration) and
               ((GetParamSocSecur('SO_TRINTEGAUTO', False) = True)  or
                (HShowMessage('0;' + Ecran.Caption + ';Voulez-vous int�grer' +
                              ' en comptabilit� les lignes d�nou�es ?;Q;YN;N;N;', '', '') = mrYes));

  {Boucle sur les lignes s�lectionn�es}
  InitMove(n, '');
  for i := 0 to n - 1 do begin
    FListe.GotoLeBookmark(i);
    MoveCur(False);
    {Si le d�nouage s'est bien pass� et qu'il faut int�grer les �critures en comptabilit� ...}
    if Denouage and IntegreOk then
      {... on pr�pare la Tob qui va cont�nir les �critures au format comptable}
      Integration(VarToStr(GetField('TCT_NUMTRANSAC')));
  end;

  if IntegreOk then
    IntegreCompta
  else
    {FQ10223 : S'il n'y a pas de message d'erreur, on poursuit l'int�gration}
    AfficheMessageErreur(Ecran.Caption, 'Certaines transactions n''ont pu �tre d�nou�es : ');

  FListe.ClearSelected;
  FListe.Refresh;
  FiniMove;
end;

{---------------------------------------------------------------------------------------}
function TOF_ListeCTerme.Denouage : Boolean;
{---------------------------------------------------------------------------------------}
var
  SQL  : string ;
  Cle  : string ;
begin
  {On s'assure que la transaction courante a bien �t� valid�e BO}
  Result := VarToStr(GetField('TCT_VALBO')) = 'X' ;
  if not Result then begin
    CategorieCurrent := CatErr_TRE;
    SetErreurTreso(NatErr_VBO);
    Exit;
  end;

  {Si la transaction a d�j� �t� d�nou�e, on sort}
  if VarToStr(GetField('TCT_DENOUEUR')) <> '' then begin
    Result := False;
    Exit;
  end;

  Cle := VarToStr(GetField('TCT_NUMTRANSAC'));
  if Cle > '' then begin
    BeginTrans;
    {D�nouage propement dit qui se fait en deux temps : ...}
    try
      {... 1/ on passe les �critures attach�es � la transaction � "R"}
      UpdatePieceStr(VarToStr(GetField('TCT_NODOSSIER')), Cle, '', '', 'TE_NATURE', na_Realise);
      {... 2/ on renseigne les champs concernant le denouage de la transaction courante}
      SQL := 'UPDATE COURTSTERMES SET TCT_DENOUEUR="' +  V_PGI.User +
             '", TCT_DATEDENOUAGE="' + USDateTime(v_PGI.DateEntree) + '" WHERE TCT_NUMTRANSAC="' + cle + '"' ;
      ExecuteSQL(SQL);

      CommitTrans;
    except
      on E : Exception do begin
        Result := False;
        RollBack;
      end;
    end;
  end
  else
    {Pour une raison "myst�rieuse", le num�ro de transaction n'est pas renseign�}
    Result := False;
end;

{JP 27/08/03 : Processus d'int�gration en compta des �critures d�nou�es
{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.IntegreCompta;
{---------------------------------------------------------------------------------------}
begin
  {FQ10223 : S'il n'y a pas de message d'erreur, on poursuit l'int�gration}
  AfficheMessageErreur(Ecran.Caption, 'Certaines transactions ne peuvent �tre int�gr�es :');

  {Par pr�caution, th�oriquement arriv� ici, la tob ne peut �tre vide}
  if TobGen.Detail.Count = 0 then begin
    HShowMessage('4;Int�gration en comptabilit�;Il n''y a aucune �criture � g�n�rer.;W;O;O;O;', '', '');
    Exit;
  end;
  {18/09/06 : Nouvelle gestion de l'int�gration}
  TRIntegrationPieces(TobGen, True);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.OnArgument(Arguments : String) ;
{---------------------------------------------------------------------------------------}
begin
  {$IFDEF TRCONF}
  TypeConfidentialite := tyc_Banque + ';';
  {$ENDIF TRCONF}
  inherited ;
  TFMul(Ecran).HelpContext := 150;

  {JP 09/03/04 : Nouveau passage d'argument}
  TypeTransac := ReadTokenSt(Arguments);
  Sens        := ReadTokenSt(Arguments);

  BFirst:=TToolBarButton97(GetControl('BFirst')) ;
  Categorie:=THValComboBox(GetControl('TCT_CATTRANSAC')) ;
  Transaction:=THValComboBox(GetControl('TCT_TRANSAC')) ;
  NumTransac := THEdit(GetControl('TCT_NUMTRANSAC'));
  bOuvrir:=TToolBarButton97(GetControl('BOuvrir')) ;
  BDelete:=TToolBarButton97(GetControl('BDelete')) ;
  BInsert:=TToolBarButton97(GetControl('BInsert')) ;
  BCherche:=TToolBarButton97(GetControl('BCherche')) ;
  BSelectAll:=TToolBarButton97(GetControl('BSelectAll')) ;

  TCheckBox(GetControl('DENOUE')).OnClick := DenoueClick;

  {$IFDEF EAGLCLIENT}
  FListe:=THGrid(GetControl('Fliste')) ;
  {$ELSE}
  FListe:=THDBGrid(GetControl('Fliste')) ;
  {$ENDIF}
  PopupMenu := TPopupMenu(GetControl('POPUPMENU'));

  {JP 09/03/04 : Gestion des types de transaction}
  if TypeTransac = 'TCT' then begin
    if Sens = 'D' then Ecran.Caption := TraduireMemoire('Liste des financements � courts termes')
                  else Ecran.Caption := TraduireMemoire('Liste des placements � courts termes');
  end
  else if TypeTransac = 'MCT' then begin
    if Sens = 'D' then Ecran.Caption := TraduireMemoire('Liste des financements � moyen termes')
                  else Ecran.Caption := TraduireMemoire('Liste des placements � moyen termes');
  end
  else begin
    {..... � compl�ter}
  end;
  
  {JP 09/03/04 : Nouveau champ dans la version 4 de la table CATTRANSAC : TCA_TYPETRANSAC}
  Categorie.Plus := 'TCA_SENS="' + sens + '" AND TCA_TYPETRANSAC = "' + TypeTransac + '"';
  updateCaption(Ecran) ;

  If Categorie<>Nil Then begin
    Categorie.OnChange:=CategorieOnChange ;
    Categorie.ItemIndex:=0 ;
    transaction.ItemIndex:=0 ;
  end ;

  If BOuvrir	<> Nil Then BOuvrir.OnClick:=BOuvrirOnClick ;
  If BFirst	<> Nil Then BFirst.Visible:=False ;
  if FListe	<> nil Then Fliste.OnDblClick:=BOuvrirOnClick ;
  if BInsert	<> Nil then BInsert.OnClick:=BInsertOnClick ;
  if BDelete	<> Nil then BDelete.OnClick:=BDeleteOnClick ;

  if PopupMenu <> nil then begin
    Select := True ;
    PopupMenu.OnPopup := OnPopupMenu;
    PopupMenu.Items[0].OnClick := BInsertOnClick;
    PopupMenu.Items[1].OnClick := BOuvrirOnClick;
    PopupMenu.Items[2].OnClick := BDeleteOnClick;
    PopupMenu.Items[4].OnClick := ValidationBO;
    PopupMenu.Items[5].OnClick := AnnulerVBO;
    PopupMenu.Items[7].OnClick := Denouer;
    PopupMenu.Items[8].OnClick := AnnulerDenouer;
    PopupMenu.Items[10].OnClick := MSelectOnClick;
    TToolBarButton97(GetControl('BVBO'  )).OnClick := ValidationBO;
    TToolBarButton97(GetControl('BDVBO' )).OnClick := AnnulerVBO;
    TToolBarButton97(GetControl('BCPTA' )).OnClick := Denouer;
    TToolBarButton97(GetControl('BDCPTA')).OnClick := AnnulerDenouer;

    {La validation et le d�nouage ne sont pas accessible � tous le monde
     20/06/07 : FQ 10480 : Gestion du concept VBO
    PopupMenu.Items[4].Enabled := V_PGI.Superviseur;
    PopupMenu.Items[5].Enabled := V_PGI.Superviseur;
    PopupMenu.Items[7].Enabled := V_PGI.Superviseur;
    PopupMenu.Items[8].Enabled := V_PGI.Superviseur;
    SetControlEnabled('BVBO'  , V_PGI.Superviseur);
    SetControlEnabled('BDVBO' , V_PGI.Superviseur);
    SetControlEnabled('BCPTA' , V_PGI.Superviseur);
    SetControlEnabled('BDCPTA', V_PGI.Superviseur);}
    CanValidateBO(PopupMenu.Items[4]);
    CanValidateBO(PopupMenu.Items[5]);
    PopupMenu.Items[7].Visible := AutoriseFonction(dac_Integration);
    PopupMenu.Items[8].Visible := AutoriseFonction(dac_Integration);
    CanValidateBO(GetControl('BVBO'));
    CanValidateBO(GetControl('BDVBO'));
    SetControlVisible('BCPTA' , AutoriseFonction(dac_Integration));
    SetControlVisible('BDCPTA', AutoriseFonction(dac_Integration));
  end;

  THValComboBox(GetControl('TCT_DEVMONTANT')).OnChange := DeviseOnChange;

  ActivateXPPopUp(PopupMenu);
  ADDMenuPop(PopupMenu, '', '');
  
  {Objet qui va permettre une �ventuelle gestion de la TVA lors de l'int�gration en comptabilit�}
  ObjTva := TObjTVA.Create;
  {Tob pour le processus d'int�gration en comptabilit�}
  TobGen := TobPieceCompta.Create('�ECRIT', nil, -1);

  {23/10/06 : gestion du multi soci�t�s}
  SetControlVisible('TCT_NODOSSIER' , IsTresoMultiSoc);
  SetControlVisible('TTCT_NODOSSIER', IsTresoMultiSoc);

  {23/10/06 : Gestion des filtres multi soci�t�s sur banquecp et dossier}
  THValComboBox(GetControl('TCT_COMPTETR')).Plus := FiltreBanqueCp(THValComboBox(GetControl('TCT_COMPTETR')).DataType, '', '');
  THMultiValComboBox(GetControl('TCT_NODOSSIER', True)).Plus := 'DOS_NODOSSIER ' + FiltreNodossier;
  THMultiValComboBox(GetControl('TCT_NODOSSIER')).OnChange := NoDossierChange;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.NoDossierChange(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  s : string;
begin
  s := GetControlText('TCT_NODOSSIER');
  if THMultiValComboBox(GetControl('TCT_NODOSSIER')).Tous then s := '';
  THValComboBox(GetControl('TCT_COMPTETR')).Plus := FiltreBanqueCp(THValComboBox(GetControl('TCT_COMPTETR')).DataType, '', s);
  THValComboBox(GetControl('TCT_COMPTETR')).ItemIndex := - 1;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.DeviseOnChange(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  MajAffichageDevise(GetControl('IDEV'), nil, GetControlText('TCT_DEVMONTANT'), sd_Aucun);
end;

{08/06/05 : Processus de pr�paration d'int�gration en comptabilit� d'une transaction
{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.Integration(NumTransac : string);
{---------------------------------------------------------------------------------------}
var
  tEcr  : TOB;
begin
  if NumTransac = '' then Exit;

  tEcr := TOB.Create('���', nil, -1);
  try
    tEcr.LoadDetailFromSQL('SELECT * FROM TRECRITURE WHERE TE_NUMTRANSAC = "' + NumTransac + '"');
    {S'il n'y a pas d'�critures pour la transaction !!?}
    if tEcr.Detail.Count = 0 then Exit;
    {18/09/06 : Nouvelle int�gration des �critures en comptabilit� (gestion du multi-soci�t�s)}
    TRGenererPieceCompta(TobGen, tEcr);
  finally
    if Assigned(tEcr)   then FreeAndNil(tEcr);
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_ListeCTerme.OnClose;
{---------------------------------------------------------------------------------------}
begin
  if Assigned(ObjTva) then FreeAndNil(ObjTva);
  if Assigned(TobGen) then FreeAndNil(TobGen);
  inherited;
end;

initialization
  RegisterClasses([TOF_ListeCTerme]) ;

end.

