{***********UNITE*************************************************
Auteur  ...... : BM
Cr�� le ...... : 04/09/2002
Modifi� le ... : 28/02/2003 : Compatibilit� CWAS
Description .. : Classe pour la fusion de documents
Mots clefs ... :
*****************************************************************}

unit ClassMenuEvt;

interface

uses
{$IFDEF EAGLCLIENT}
   eMul,
{$ELSE}
   Mul,
{$ENDIF}
   Menus, CLASSMenuElement, HTB97, UTOB;

type
   TMenuEvt = class(TMenuElement)
   public
      Procedure  Init( MyPopUpMenu_p : TPopUpMenu;
                     {dbgListe_p : THDBGrid; qQueryMul_p : THQuery;}
                     frm : TFMul;
                     btChercher_p : TToolbarButton97; bChargeTaches_p : boolean = false;
                     bChargeEtats_p : boolean = false{; bChargeOutlook_p : boolean = false} ); reintroduce; overload;
   private
      btChercher_c : TToolbarButton97;
      bChargeTaches_c : boolean;
      bChargeEtats_c : boolean;
//      bChargeOutlook_c : boolean;

      procedure InitMenuEvt( MyPopUpMenu_p : TPopUpMenu ); reintroduce; overload;

      function  ChargeTypeTaches : TOB;
      function  ChargeTypeEtats : TOB;
      function  ChargeTypeMessages : TOB;

   public

      procedure OnClickEvtTaches(Sender : TObject);
      procedure OnClickEvtEtats(Sender : TObject);
//      procedure OnClickOutlookMessage(Sender : TObject);
   end;

/////////// ENTETES DE FONCTION ET PROCEDURES ////////////

implementation

uses
   GenMenu, hctrls, AGLInitDpJur, DpJurOutils, hmsgbox, SysUtils;

{*****************************************************************
* Proc�dures globales d'acc�s � la classe                        *
*****************************************************************}

{*****************************************************************
* M�thodes de la classe                                          *
*****************************************************************}

{*****************************************************************
Auteur ....... : BM
Date ......... : 04/09/02
Constructor .. : Create
Description .. : Construit et initialise la classe
Param�tres ... : Le menu POPUP
                 le bouton BCHERCHE
                 la grille de la fiche
                 Le query Q de la fiche
*****************************************************************}

procedure TMenuEvt.Init( MyPopUpMenu_p : TPopUpMenu;
                     // dbgListe_p : THDBGrid; qQueryMul_p : THQuery;
                     frm : TFMul;
                     btChercher_p : TToolbarButton97; bChargeTaches_p : boolean = false;
                     bChargeEtats_p : boolean = false{; bChargeOutlook_p : boolean = false} );
begin
   btChercher_c := btChercher_p;
   bChargeTaches_c := bChargeTaches_p;
   bChargeEtats_c := bChargeEtats_p;
//   bChargeOutlook_c := bChargeOutlook_p;

   InitMenuElement( MyPopUpMenu_p, {dbgListe_p, qQueryMul_p} frm );
   InitMenuEvt( MyPopUpMenu_p );
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 18/09/02
Proc�dure .... : InitMenuEvt
Description .. : Ajoute des �l�ments an sous-menu courant
Param�tres ... :
*****************************************************************}

procedure TMenuEvt.InitMenuEvt( MyPopUpMenu_p : TPopUpMenu );
var
   nSousMenu_l, nNbSousMenu_l : integer;
begin
   nNbSousMenu_l := JURBoolToInt(bChargeTaches_c) + JURBoolToInt(bChargeEtats_c);// + BoolToInt(bChargeOutlook_c);
   // Si le menu n'est pas vide et que l'on rajoute au moins un �l�ment
   // Ajout d'une s�paration
   if (nMenuDepart_c > -1) and (nNbSousMenu_l > 0) then
      InitPopUpElement( MyPopUpMenu_p, true );

   if bChargeTaches_c then
   begin
      // Si le menu est vide et que l'on rajoute un seul �l�ment
      // Pas de sous menu mais menu direct
      if (nMenuDepart_c = -1) and (nNbSousMenu_l = 1) then
      begin
         InitMenuDepuisTob( MyPopUpMenu_p.Items, ChargeTypeTaches,
                     'CO_ABREGE', 'CO_CODE', OnClickEvtTaches );
      end
      else
      begin
         nSousMenu_l := InitPopUpSubMenu( MyPopUpMenu_p, ChoixUnChamp( 'JEV_ETATDOC' ) );
         InitMenuDepuisTob( MyPopUpMenu_p.Items[nSousMenu_l], ChargeTypeTaches,
                     'CO_ABREGE', 'CO_CODE', OnClickEvtTaches );
      end
   end;

   if bChargeEtats_c then
   begin
      // Si le menu est vide et que l'on rajoute un seul �l�ment
      // Pas de sous menu mais menu direct
      if (nMenuDepart_c = -1) and (nNbSousMenu_l = 1) then
      begin
         InitMenuDepuisTob( MyPopUpMenu_p.Items, ChargeTypeEtats,
                     'CO_ABREGE', 'CO_LIBRE', OnClickEvtEtats );
      end
      else
      begin
         nSousMenu_l := InitPopUpSubMenu( MyPopUpMenu_p, ChoixUnChamp( 'JEV_FAIT' ) );
         InitMenuDepuisTob( MyPopUpMenu_p.Items[nSousMenu_l], ChargeTypeEtats,
                     'CO_ABREGE', 'CO_LIBRE', OnClickEvtEtats );
      end
   end;

{   if bChargeOutlook_c then
   begin
      // Si le menu est vide et que l'on rajoute un seul �l�ment
      // Pas de sous menu mais menu direct
      if (nMenuDepart_c = -1) and (nNbSousMenu_l = 1) then
      begin
         InitMenuDepuisTob( MyPopUpMenu_p.Items, ChargeTypeMessages,
                            'CO_ABREGE', 'CO_CODE', OnClickOutlookMessage );
      end
      else
      begin
         // Ajout d'une s�paration
         if (nNbSousMenu_l > 1) then
            InitPopUpElement( MyPopUpMenu_p, true );

         nSousMenu_l := InitPopUpSubMenu( MyPopUpMenu_p, TTToLibelle('YYMESSAGERIE') );
         InitMenuDepuisTob( MyPopUpMenu_p.Items[nSousMenu_l], ChargeTypeMessages,
                            'CO_ABREGE', 'CO_CODE', OnClickOutlookMessage );
      end
   end;}
end;


{*****************************************************************
Auteur ....... : BM
Date ......... : 18/09/02
Procedure .... : ChargeTypeTaches
Description .. : Charge les types d'�v�nements
Param�tres ... : TOB �v�nement
                 Le menu popup
*****************************************************************}

function  TMenuEvt.ChargeTypeTaches : TOB;
begin
   result := ChargeElementMenu( 'select CO_CODE, CO_ABREGE from COMMUN ' +
                                'WHERE CO_TYPE = "' + TTToTipe('JUETATDOC') + '"' );
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 18/09/02
Procedure .... : ChargeTypeEtats
Description .. : Charge les types d'�v�nements
Param�tres ... : TOB �v�nement
                 Le menu popup
*****************************************************************}

function  TMenuEvt.ChargeTypeEtats : TOB;
begin
   result := ChargeElementMenu( 'select CO_LIBRE, CO_ABREGE from COMMUN ' +
                                'WHERE CO_TYPE = "' + TTToTipe('JUFAIT') + '"' );
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 18/09/02
Procedure .... : ChargeTypeMessages
Description .. : Charge les types d'�v�nements
Param�tres ... : TOB �v�nement
                 Le menu popup
*****************************************************************}

function  TMenuEvt.ChargeTypeMessages : TOB;
begin
   result := ChargeElementMenu( 'select CO_CODE, CO_ABREGE from COMMUN ' +
                                'WHERE CO_TYPE = "' + TTToTipe('YYMESSAGERIE') + '"' );
end;


{*****************************************************************
Auteur ....... : BM
Date ......... : 18/09/02
Proc�dure .... : OnClickEvtTache
Description .. : Proc�dure ex�cut�e lors du click sur les �l�ments
                 du sous menu "T�ches"
Param�tres ... : L'objet
*****************************************************************}

procedure TMenuEvt.OnClickEvtTaches(Sender : TObject);
var
   sValeur_l, sData_l : string;
   nRow_l : integer;
begin
   sValeur_l := OnClickElementMenu( Sender );
   sData_l := 'JUEVENEMENT_MUL|';                           // 0 : Table
   sData_l := sData_l + 'JEV_ETATDOC=' + sValeur_l + '|';   // 1 : Champ � mettre � jour et sa valeur
   sData_l := sData_l + 'JEV_GUIDEVT'; // $$$ JP 15/03/06 - JEV_NOEVT';                        // 2 : Cl� de l'enregistrement

   nRow_l := GrilleParcours( // dbgListe_c, qQueryMul_c,
                             frmMul,
                             sData_l, 3,
                             @InitSetValChamp, @AGLSetValChamp);
   PGIInfo( IntToStr(nRow_l) + ' �l�ments modifi�s', ChoixUnChamp( 'JEV_ETATDOC' ) );
   btChercher_c.Click;
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 18/09/02
Proc�dure .... : OnClickEvtEtat
Description .. : Proc�dure ex�cut�e lors du click sur les �l�ments
                 du sous menu "Etat"
Param�tres ... :
*****************************************************************}

procedure TMenuEvt.OnClickEvtEtats(Sender : TObject);
var
   sValeur_l, sData_l : string;
   nRow_l : integer;
begin
   sValeur_l := OnClickElementMenu( Sender );
   sData_l := 'JUEVENEMENT_MUL|';                        // 0 : Table
   sData_l := sData_l + 'JEV_FAIT=' + sValeur_l + '|';   // 1 : Champ � mettre � jour et sa valeur
   sData_l := sData_l + 'JEV_GUIDEVT'; // $$$ JP 15/03/06 - JEV_NOEVT';                     // 2 : Cl� de l'enregistrement

   nRow_l := GrilleParcours( // dbgListe_c, qQueryMul_c,
                             frmMul, 
                             sData_l, 3,
                             @InitSetValChamp, @AGLSetValChamp );
   PGIInfo( IntToStr(nRow_l) + ' �l�ments modifi�s', ChoixUnChamp( 'JEV_FAIT' ) );
   btChercher_c.Click;
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 18/09/02
Proc�dure .... : OnClickOutlookMessage
Description .. : Proc�dure ex�cut�e lors du click sur les �l�ments
                 du sous menu "Messagerie"
Param�tres ... : L'objet
*****************************************************************}
{procedure TMenuEvt.OnClickOutlookMessage(Sender : TObject);
var
   sValeur_l, sCle_l : string;
begin
   $IFDEF EAGLCLIENT
   qQueryMul_c.TQ.Seek(dbgListe_c.Row - 1);
   $ENDIF
   if qQueryMul_c.FindField('JEV_FAMEVT').AsString <> TTToTipe('YYMESSAGERIE') then
   begin
      PGIInfo( 'Cet �v�nement ne fait pas partie de la famille "' + TTToLibelle('YYMESSAGERIE') + '"', 'Liaison Outlook' );
      Exit;
   end;

   sValeur_l := OnClickElementMenu( Sender );
   sCle_l := 'ACTION=CREATION;;;' +
             qQueryMul_c.FindField('JEV_FAMEVT').AsString + ';' +
             qQueryMul_c.FindField('JEV_NOEVT').AsString + ';' + sValeur_l;

   AGLLanceFiche( 'YY', 'YYEVEN_' + qQueryMul_c.FindField('JEV_FAMEVT').AsString, '', '', sCle_l );
   btChercher_c.Click;
end;}

//////////// IMPLEMENTATION //////////////

end.
