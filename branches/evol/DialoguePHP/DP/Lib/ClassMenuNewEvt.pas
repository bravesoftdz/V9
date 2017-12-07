{***********UNITE*************************************************
Auteur  ...... : BM
Cr�� le ...... : 04/09/2002
Modifi� le ... : 28/02/2003 : Compatibilit� CWAS
Description .. : Classe pour la fusion de documents
Mots clefs ... :
*****************************************************************}

unit ClassMenuNewEvt;

interface

uses
   Menus, CLASSMenuElement, HTB97, UTOB;

type
   TMenuNewEvt = class(TMenuElement)
   private
      btNouveau_c : TToolbarButton97;
      sRestriction_c : string;
      procedure InitMenuNewEvt( MyPopUpMenu_p : TPopUpMenu ); reintroduce; overload;
      function  ChargeTypeEvt : TOB;

   public
      sFamEvtNew_c : string;
      Procedure Init( MyPopUpMenu_p : TPopUpMenu; btNouveau_p : TToolbarButton97;
                      sRestriction_p : string = ''); reintroduce; overload;
      procedure OnClickNewEvt(Sender : TObject);
   end;


/////////// IMPLEMENTATION ////////////

implementation

uses
   GenMenu, hctrls;

{*****************************************************************
* M�thodes de la classe                                          *
*****************************************************************}

{*****************************************************************
Auteur ....... : BM
Date ......... : 04/09/02
Constructor .. : Create
Description .. : Construit et initialise la classe
Param�tres ... : Le menu POPUP
                 le bouton BNEWEVT
                 L'�cran
*****************************************************************}

Procedure TMenuNewEvt.Init( MyPopUpMenu_p : TPopUpMenu; btNouveau_p : TToolbarButton97;
                            sRestriction_p : string = '');
begin
   InitMenuElement( MyPopUpMenu_p );
   btNouveau_c := btNouveau_p;
   sRestriction_c := sRestriction_p;
   InitMenuNewEvt( MyPopUpMenu_p );
end;


{*****************************************************************
Auteur ....... : BM
Date ......... : 18/09/02
Proc�dure .... : InitMenuNewEvt
Description .. : Initialise le popup menu
Param�tres ... : Le menu POPUP
*****************************************************************}

procedure TMenuNewEvt.InitMenuNewEvt( MyPopUpMenu_p : TPopUpMenu );
begin
   InitMenuDepuisTob( MyPopUpMenu_p.Items, ChargeTypeEvt,
                      'CC_LIBELLE', 'CC_CODE', OnClickNewEvt );
end;


{*****************************************************************
Auteur ....... : BM
Date ......... : 18/09/02
Fonction ..... : ChargeTypeEvt
Description .. : Charge les types d'�v�nements
Param�tres ... :
Renvoie ...... : TOB �v�nement
*****************************************************************}

function  TMenuNewEvt.ChargeTypeEvt : TOB;
var
   sRequete_l : string;
begin
   sRequete_l := 'SELECT CC_CODE, CC_LIBELLE ' +
                 'FROM CHOIXCOD ' +
                 'WHERE CC_TYPE = "' + TTToTipe('JUFAMEVT') + '" ';
   if sRestriction_c <> '' then
      sRequete_l := sRequete_l + 'AND ' + sRestriction_c + ' ';
   sRequete_l := sRequete_l + 'ORDER BY CC_LIBELLE';
   Result := ChargeElementMenu( sRequete_l );
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 18/09/02
Proc�dure .... : OnClickNewEvt
Description .. : Proc�dure ex�cut�e lors du click sur les �l�ments
                 du menu
Param�tres ... : L'objet
*****************************************************************}

procedure TMenuNewEvt.OnClickNewEvt(Sender : TObject);
begin
   sFamEvtNew_c := OnClickElementMenu( Sender );
   btNouveau_c.Click;
end;

//////////// IMPLEMENTATION //////////////

end.
