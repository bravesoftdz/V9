{***********UNITE*************************************************
Auteur  ...... : B. M�riaux
Cr�� le ...... : 11/12/2006
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
unit UFImgListe;
/////////////////////////////////////////////////////////////////
interface
/////////////////////////////////////////////////////////////////
uses
  Forms, ImgList, Classes, Controls, Sysutils, Menus, HImgList;
/////////////////////////////////////////////////////////////////
const iImgIns_g = 0;
const iImgDup_g = 3;
const iImgMod_g = 1;
const iImgRen_g = 4;
const iImgDel_g = 2;
const iImgInsTxt_g = 5;
const iImgMax_g = 7;
/////////////////////////////////////////////////////////////////
type
  TFImgListe = class(TForm)
    BiblioActes: THImageList;
    NiveauxInsee: THImageList;
    RFIcones_f : TImageList;
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;
/////////////////////////////////////////////////////////////////
var
  FImgListe: TFImgListe;
/////////////////////////////////////////////////////////////////
implementation
/////////////////////////////////////////////////////////////////
{$R *.DFM}
/////////////////////////////////////////////////////////////////
end.
