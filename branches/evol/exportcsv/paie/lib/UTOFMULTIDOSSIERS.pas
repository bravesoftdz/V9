{***********UNITE*************************************************
Auteur  ...... : FLO
Cr�� le ...... : 15/11/2007
Modifi� le ... :   /  /
Description .. : Visualisation et s�lection des dossiers d'un regroupement
Mots clefs ... : MULTIDOSSIER;REGROUPEMENT;DOSSIER;
*****************************************************************
  N� |    Date    | Aut.| Version  |                Description
PT1  | 14/12/2007 | FLO | V8.02.07 | Externalisation du chargement des dossiers
}
unit UTOFMULTIDOSSIERS;

interface
uses
  Windows, Messages, SysUtils, Forms, HEnt1, HCtrls,
  {$IFNDEF EAGLCLIENT}  Db,  {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF} {$ENDIF}
  Classes, StdCtrls, UTOF;

type
  TOF_MULTIDOSSIERS = class(TOF)
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
  private
    Grille: THGrid;
    Mode,CodeReg,Selection,AnneeRef : String;
    procedure Valide (Sender : TObject);
    procedure SelectAll  (Sender : TObject);
  end;

implementation

uses HTB97,HMsgBox,HSysMenu,UTob,Vierge,PGOutils;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 17/11/2007
Modifi� le ... :   /  /
Description .. : Chargement de l'�cran
Mode g�r�s ... : <vide>, EXERSOCIAL
Mots clefs ... :
*****************************************************************}
procedure TOF_MULTIDOSSIERS.OnArgument (S : String) ;
var Temp : String;
Begin
    Temp      := ReadTokenSt(S);
    If Pos('|', Temp) > 0 Then 
    Begin
    	Mode     := ReadTokenPipe(Temp,'|');
    	AnneeRef := ReadTokenPipe(Temp,'|');
    End
    Else Mode := Temp;
    CodeReg   := ReadTokenSt(S);
    Selection := S;

    Grille  := THGrid(GetControl('GRLISTEDOS'));
    TToolbarButton97(GetControl('BValider')).OnClick := Valide;
    TToolbarButton97(GetControl('BSelectAll')).OnClick := SelectAll;
End;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 17/11/2007
Modifi� le ... :   /  /
Description .. : Chargement des dossiers du regroupement
Mots clefs ... :
*****************************************************************}
procedure TOF_MULTIDOSSIERS.OnLoad;
Begin
	If Not ChargeDossiersDuRegroupement (CodeReg, Grille, Mode, AnneeRef, Selection) Then //PT1
    Begin
        TToolBarButton97(GetControl('BFerme')).Click;
        Exit;
    End;

   	TFVierge(Ecran).Width := 600;
    
    // Adaptation de la taille des colonnes
    TFVierge(Ecran).HMTrad.ResizeGridColumns (Grille);
End;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 17/11/2007
Modifi� le ... :   /  /
Description .. : Retourne les dossiers s�lectionn�s sur validation
Mots clefs ... :
*****************************************************************}
procedure TOF_MULTIDOSSIERS.Valide(Sender: TObject);
var i : integer;
    ListeDossiers,NomsDossiers : String;
begin
    // Retourne les �l�ments s�lectionn�s
    if (Grille.NbSelected=0) and (TToolbarButton97(GetControl('BSelectAll')).Down=False) then
    begin
        PGIBox(TraduireMemoire('Aucun �l�ment s�lectionn�'),TFVierge(Ecran).Caption);
        LastError := 1;
        Exit;
    end;

    // Parcours des �l�ments s�lectionn�s
    For i := 0 to Grille.RowCount-1 do
    begin
        If Grille.IsSelected(i) Then
        Begin
            ListeDossiers := ListeDossiers + Grille.CellValues[0,i] + ';';
            NomsDossiers  := NomsDossiers  + Grille.CellValues[1,i] + ';';
        End;
    end;

    // On retourne la liste des dossiers avec leur nom
    If ListeDossiers <> '' Then TFVierge(Ecran).Retour := Copy(ListeDossiers, 1, Length(ListeDossiers)-1) + '|' + Copy(NomsDossiers, 1, Length(NomsDossiers)-1);
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 17/11/2007
Modifi� le ... :   /  /
Description .. : Bouton "S�lectionner tout"
Mots clefs ... :
*****************************************************************}
procedure TOF_MULTIDOSSIERS.SelectAll(Sender: TObject);
begin
    Grille.AllSelected := Not Grille.AllSelected;
end;

initialization
  registerclasses([TOF_MULTIDOSSIERS]);
end.
