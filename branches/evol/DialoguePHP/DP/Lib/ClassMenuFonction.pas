{***********UNITE*************************************************
Auteur  ...... : BM
Cr�� le ...... : 04/09/2002
Modifi� le ... : 28/02/2003 : Compatibilit� CWAS
Description .. : Classe pour la fusion de documents
Mots clefs ... :
*****************************************************************}

unit ClassMenuFonction;

interface

uses
{$IFNDEF EAGLCLIENT}
   FE_Main,
{$ELSE}
   MaineAgl,
{$ENDIF}
   Menus, CLASSMenuElement, UTOB;

type
   TMenuFonction = class(TMenuElement)
   public
      procedure OnClickFonction(Sender : TObject); virtual;

      Procedure Init(MyPopUpMenu_p : TPopUpMenu; nNoOrdre_p : integer;
                     sGuidPerDos_p, sGuidPer_p, sTypeDos_p, sForme_p : string); reintroduce; overload;
   private
         nNoOrdre_c : integer;
         sTypeDos_c, sForme_c, sGuidPerDos_c, sGuidPer_c : string;

      procedure InitMenuFonction(MyPopUpMenu_p : TPopUpMenu); reintroduce; overload;
      function  ChargeTypeFonction : TOB;
   end;

/////////// ENTETES DE FONCTION ET PROCEDURES ////////////

implementation

uses
   GenMenu, SysUtils;

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

procedure TMenuFonction.Init(MyPopUpMenu_p : TPopUpMenu; nNoOrdre_p : integer;
                             sGuidPerDos_p, sGuidPer_p, sTypeDos_p, sForme_p : string);
begin
   sGuidPerDos_c := sGuidPerDos_p;
   nNoOrdre_c := nNoOrdre_p;
   sGuidPer_c := sGuidPer_p;
   sTypeDos_c := sTypeDos_p;
   sForme_c := sForme_p;
   InitMenuElement( MyPopUpMenu_p );
   InitMenuFonction( MyPopUpMenu_p );
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 18/09/02
Proc�dure .... : InitMenuFonction
Description .. : Ajoute des �l�ments an sous-menu courant
Param�tres ... :
*****************************************************************}

procedure TMenuFonction.InitMenuFonction(MyPopUpMenu_p : TPopUpMenu);
begin
   InitMenuDepuisTob( MyPopUpMenu_p.Items, ChargeTypeFonction,
               'JTF_FONCTABREGE', 'JTF_FONCTION', OnClickFonction );
   if MyPopUpMenu_p.Items.Count = 0 then
      InitSubMenu( MyPopUpMenu_p.Items, '<< Vide >>' );
end;


{*****************************************************************
Auteur ....... : BM
Date ......... : 18/09/02
Procedure .... : ChargeTypeFonction
Description .. : Charge les types d'�v�nements
Param�tres ... : TOB �v�nement
                 Le menu popup
*****************************************************************}

function  TMenuFonction.ChargeTypeFonction : TOB;
var
   sRequete_l : string;
begin
   sRequete_l := 'select JTF_FONCTION, JTF_FONCTABREGE, JFT_TRI ' +
                 'from (JUTYPEFONCT left join JUFONCTION on JFT_FONCTION = JTF_FONCTION) ' +
                 'where (JFT_FORME = "' + sForme_c + '" ' +
                 '  AND JFT_TYPEDOS = "' + sTypeDos_c + '" AND JFT_TIERS<> "X") ' +
                 'ORDER BY JFT_TRI';

   result := ChargeElementMenu( sRequete_l );
end;


{*****************************************************************
Auteur ....... : BM
Date ......... : 18/09/02
Proc�dure .... : OnClickFonctionTache
Description .. : Proc�dure ex�cut�e lors du click sur les �l�ments
                 du sous menu "T�ches"
Param�tres ... : L'objet
*****************************************************************}

procedure TMenuFonction.OnClickFonction(Sender : TObject);
var
   sCle_l, sFonction_l : string;
begin
   sFonction_l := OnClickElementMenu( Sender );
   sCle_l := sGuidPerDos_c + ';' + sTypeDos_c + ';' + IntToStr(nNoOrdre_c) + ';'
             //+ IntToStr(sGuidPer_c) + ';' + sFonction_l;
             + sFonction_l + ';' + sGuidPer_c;
   // ne pas passer GetField('ANL_FORME'); en fin de argument !
   AGLLanceFiche('YY', 'FICHELIEN', sCle_l, sCle_l,
     'ACTION=MODIFICATION;' + sCle_l + ';' + sForme_c);
end;


//////////// IMPLEMENTATION //////////////

end.
