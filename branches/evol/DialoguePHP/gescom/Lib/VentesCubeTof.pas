{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 27/07/2001
Modifié le ... :   /  /
Description .. : Source TOF de la TABLE : GCVENTES ()
Mots clefs ... : TOF;GCVENTES
*****************************************************************}
Unit VentesCubeTof ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
     sysutils,
     ComCtrls,
     Forms,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOF,
     UtilGC;

Type
  TOF_GCVENTES = Class (TOF)
    procedure OnArgument (S : String ) ; override ;
  end ;

Implementation

procedure TOF_GCVENTES.OnArgument (S : String ) ;
Var i : integer ;
    //Suf,Nam,Titre : String ;
    AuMoinsUn : boolean;
begin
  Inherited ;
{for i:=1 to 10 do
    BEGIN
    if i<10 then Suf:=IntToStr(i) else Suf:='A' ;
    Nam:='GP_LIBRETIERS'+Suf ; GCTitreZoneLibre(Nam,Titre) ; SetControlCaption('T'+Nam,Titre);
    Nam:='GL_LIBREART'+Suf   ; GCTitreZoneLibre(Nam,Titre) ; SetControlCaption('T'+Nam,Titre);
    END ;}
AuMoinsUn:=False;
For i:=1 to 10 do if i<10 then AuMoinsUn:=(ChangeLibre2('TGP_LIBRETIERS'+intToStr(i),TForm(Ecran)) or AuMoinsUn)
                          else AuMoinsUn:=(ChangeLibre2('TGP_LIBRETIERSA',TForm(Ecran))or AuMoinsUn);

{$IFDEF LINE}
	setcontrolproperty('GL_REPRESENTANT', 'Visible', False);
	setcontrolproperty('GL_ETABLISSEMENT', 'Visible', False);


 	setcontrolproperty('GP_LIBRETIERS1', 'Visible', False);
  setcontrolproperty('GP_LIBRETIERS2', 'Visible', False);
  setcontrolproperty('GP_LIBRETIERS3', 'Visible', False);
  setcontrolproperty('GP_LIBRETIERS4', 'Visible', False);
  setcontrolproperty('GP_LIBRETIERS5', 'Visible', False);
//
 	setcontrolproperty('GL_LIBREART1', 'Visible', False);
  setcontrolproperty('GL_LIBREART2', 'Visible', False);
  setcontrolproperty('GL_LIBREART3', 'Visible', False);
  setcontrolproperty('GL_LIBREART4', 'Visible', False);
  setcontrolproperty('GL_LIBREART5', 'Visible', False);
//
	setcontrolproperty('TGL_REPRESENTANT', 'Visible', False);
	setcontrolproperty('TGL_ETABLISSEMENT', 'Visible', False);
//
 	setcontrolproperty('TGP_LIBRETIERS1', 'Visible', False);
  setcontrolproperty('TGP_LIBRETIERS2', 'Visible', False);
  setcontrolproperty('TGP_LIBRETIERS3', 'Visible', False);
  setcontrolproperty('TGP_LIBRETIERS4', 'Visible', False);
  setcontrolproperty('TGP_LIBRETIERS5', 'Visible', False);
//
 	setcontrolproperty('TGL_LIBREART1', 'Visible', False);
  setcontrolproperty('TGL_LIBREART2', 'Visible', False);
  setcontrolproperty('TGL_LIBREART3', 'Visible', False);
  setcontrolproperty('TGL_LIBREART4', 'Visible', False);
  setcontrolproperty('TGL_LIBREART5', 'Visible', False);

{$ENDIF}

MajChampsLibresArticle(TForm(Ecran),'GL',(not AuMoinsUn),'PCOMPLEMENTS','PCOMPLEMENTS');
{$IFDEF BTP}
If (S = 'I') or (S = 'W') then
  THMultiValComboBox(GetControl('GL_NATUREPIECEG')).Plus := 'AND (GPP_NATUREPIECEG="FAC" OR GPP_NATUREPIECEG="AVC")'
else
  THMultiValComboBox(GetControl('GL_NATUREPIECEG')).Plus := 'AND (GPP_NATUREPIECEG="FBT" OR GPP_NATUREPIECEG="ABT" OR GPP_NATUREPIECEG="FAC" OR GPP_NATUREPIECEG="AVC" OR GPP_NATUREPIECEG="DBT")';
THEdit(GetControl('GL_TIERSFACTURE')).Plus := 'AND T_NATUREAUXI="CLI"';
{$ENDIF}
end ;

Initialization
  registerclasses ( [ TOF_GCVENTES ] ) ; 
end.

