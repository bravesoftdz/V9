{***********UNITE*************************************************
Auteur  ...... :  NA
Cr�� le ...... : 03/08/2006
Modifi� le ... :   /  /
Description .. : Source TOM de la TABLE : RESULTSIMUL (RESULTSIMUL)
Mots clefs ... : TOM;RESULTSIMUL
*****************************************************************
PT1    : 12/04/2007  NA  Visu m�thode de calcul pour m�thode r�trospective avec salaire actuel
PT2    : 12/04/2007  NA  Visu des tables IDR utilis�es}

Unit RESULTSIMUL_TOM ;

Interface

Uses StdCtrls, 
     Controls, 
     Classes, 
{$IFNDEF EAGLCLIENT}
     db, 
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF} 
     Fiche, 
     FichList, 
{$else}
     eFiche, 
     eFichList, 
{$ENDIF}
     forms, 
     sysutils, 
     ComCtrls,
     HCtrls, 
     HEnt1, 
     HMsgBox,
     P5Def, 
     UTOM,
     UTob ;

Type
  TOM_RESULTSIMUL = Class (TOM)
    procedure OnNewRecord                ; override ;
    procedure OnDeleteRecord             ; override ;
    procedure OnUpdateRecord             ; override ;
    procedure OnAfterUpdateRecord        ; override ;
    procedure OnAfterDeleteRecord        ; override ;
    procedure OnLoadRecord               ; override ;
    procedure OnChangeField ( F: TField) ; override ;
    procedure OnArgument ( S: String )   ; override ;
    procedure OnClose                    ; override ;
    procedure OnCancelRecord             ; override ;
    end ;

Implementation

procedure TOM_RESULTSIMUL.OnNewRecord ;
begin
  Inherited ;
end ;

procedure TOM_RESULTSIMUL.OnDeleteRecord ;
begin
  Inherited ;
end ;

procedure TOM_RESULTSIMUL.OnUpdateRecord ;
begin
  Inherited ;
end ;

procedure TOM_RESULTSIMUL.OnAfterUpdateRecord ;
begin
  Inherited ;
end ;

procedure TOM_RESULTSIMUL.OnAfterDeleteRecord ;
begin
  Inherited ;
end ;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 03/08/2006
Modifi� le ... :   /  /    
Description .. : Chargement de l'enregistrement
Mots clefs ... : 
*****************************************************************}
procedure TOM_RESULTSIMUL.OnLoadRecord ;
var
codesimul, st, libellesimul, typedep, methcalc, titre, codtab : string;    // pt2
presactu, presfinal : integer;
QQ, Q2 : TQuery;    // pt2
Listmethcalc : Tlistbox;



begin
  Inherited ;
codesimul:= getfield('PSR_CODESIMUL');
st := 'SELECT PSL_LIBELLE, PSL_TYPEDEPART, PSL_METHCALCUL, PSL_DATESIMUL FROM SIMULATION Where PSL_CODESIMUL = "'+codesimul+'"';
QQ := OPENSQL(st, True);

  if not QQ.Eof then begin
  libellesimul := QQ.findfield('PSL_LIBELLE').Asstring;
  typedep := QQ.findfield('PSL_TYPEDEPART').Asstring;
  methcalc := QQ.findfield('PSL_METHCALCUL').Asstring;

  end;

  ferme (QQ);
  titre := codesimul + ' ' + libellesimul;
  Ecran.Caption := Ecran.Caption  + ' ' + titre ;
  UpdateCaption(Ecran);

  // Affichage de la m�thode de calcul
  listmethcalc := TListbox(Getcontrol('METHCALCUL'));
  listmethcalc.Items.clear;

  if  methcalc = '001' then
  listmethcalc.items.Add('M�thode de calcul : M�thode des unit�s de cr�dit projet�es (PBO)');
  if methcalc = '002' then
  listmethcalc.items.Add('M�thode de calcul : M�thode r�trospective pure (RP)');
  if methcalc = '003' then listmethcalc.items.Add('M�thode de calcul : M�thode r�trospective avec salaire de fin de carri�re (RSFC)');
  if methcalc = '004' then listmethcalc.items.Add('M�thode de calcul : M�thode r�trospective avec salaire actuel (ABO)'); // PT4


  listmethcalc.items.Add('Engagement IFC  ('+ floattostr(getfield('PSR_INDEMNLEGALE'))+') = ');
  listmethcalc.items.Add(' Salaire actuel  ('+floattostr(getfield('PSR_SALAIREACTU')) +') * ');
  if (methcalc <> '002') and (methcalc <> '004') then
  // si m�thode de calcul <> m�thode r�trospective pure ou r�trosp salaire actuel PT4
  listmethcalc.items.Add(' Revalorisation  ('+ floattostr(getfield('PSR_REVALORISATION'))+') * ');

  listmethcalc.items.Add(' Nb de mois acquis  ('+ floattostr(getfield('PSR_MOISACQUIS'))+') * ');
  listmethcalc.items.Add(' Probabilit� de survie  ('+ floattostr(getfield('PSR_PROBASUIVIE'))+' / 100) * ');
  listmethcalc.items.Add(' Probabilit� de pr�sence  ('+ floattostr(getfield('PSR_PROBAPRESENCE'))+'/ 100) * ');

  if (methcalc = '001') or (methcalc = '004') or (typedep = 'DV') then
  listmethcalc.items.Add(' Actualisation  ('+ floattostr(getfield('PSR_ACTUALISATION'))+' / 100) *') else
  listmethcalc.items.Add(' Actualisation  ('+ floattostr(getfield('PSR_ACTUALISATION'))+'/ 100)');

  if (methcalc = '001') or (methcalc = '004') then
  begin  // si m�thode des unit�s de cr�dit projet�es  ou r�trospective avec salaire actuel PT4
    presactu := (getfield('PSR_ANCIENACTUAA')  * 12 )+ getfield('PSR_ANCIENACTUMM');
    presfinal := (getfield('PSR_ANCIENFINALAA') * 12) + getfield('PSR_ANCIENFINALMM');
    if typedep = 'DV' then
    listmethcalc.items.Add(' Anciennet� actuelle  ('+ inttostr(presactu)+') / anciennet� finale'+
    '('+ inttostr(presfinal) +') *') else
    listmethcalc.items.Add(' Anciennet� actuelle  ('+ inttostr(presactu)+') / anciennet� finale'+
    ' ('+ inttostr(presfinal) +')');
  end;

  if typedep = 'DV' then  // si d�part volontaire
  listmethcalc.items.Add(' Taux de charge  ( 1 + ('+ floattostr(getfield('PSR_TXCHARGE'))+' / 100))');


  // Pt2 recherche du nom des tables IDR
  codtab := getfield('PSR_CODTABSUR');
  QQ:=opensql('select PTI_LIBELLE from CODTAB WHERE PTI_CODTAB = "'+codtab+'"', true);
  if not QQ.EOF then setcontroltext('NOMTABLESUR', QQ.findfield('PTI_LIBELLE').asstring);
  codtab := getfield('PSR_CODTABDROIT');
  QQ:=opensql('select PTI_LIBELLE from CODTAB WHERE PTI_CODTAB = "'+codtab+'"', true);
  if not QQ.EOF then setcontroltext('NOMTABLEMOIS', QQ.findfield('PTI_LIBELLE').asstring);
  codtab := getfield('PSR_CODTABREVAL');
  QQ:=opensql('select PTI_LIBELLE from CODTAB WHERE PTI_CODTAB = "'+codtab+'"', true);
  if not QQ.EOF then setcontroltext('NOMTABLEREV', QQ.findfield('PTI_LIBELLE').asstring);
  codtab := getfield('PSR_CODTABTUR');
  QQ:=opensql('select PTI_LIBELLE from CODTAB WHERE PTI_CODTAB = "'+codtab+'"', true);
  if not QQ.EOF then setcontroltext('NOMTABLEPRES', QQ.findfield('PTI_LIBELLE').asstring);
  ferme(qq);
  // fin pt2

end ;

procedure TOM_RESULTSIMUL.OnChangeField ( F: TField ) ;
begin
  Inherited ;
end ;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 04/08/2006
Modifi� le ... :   /  /    
Description .. : Argument
Mots clefs ... : 
*****************************************************************}
procedure TOM_RESULTSIMUL.OnArgument ( S: String ) ;
Var
num : integer;
begin
  Inherited ;
  // Recherche des libell�s des zones TRAVAIL, COMBO, CODESTAT
  for Num := 1 to 4 do
  begin
  VisibiliteChampSalarie(IntToStr(Num), GetControl('PSR_TRAVAILN' + IntToStr(Num)), GetControl('TPSR_TRAVAILN' + IntToStr(Num)));
  VisibiliteChamplibresal(IntToStr(Num), GetControl('PSR_LIBREPCMB' +IntToStr(Num)),GetControl('TPSR_LIBREPCMB' + IntToStr(Num)));
  setcontrolenabled('PSR_TRAVAILN' + IntToStr(Num), false);
  setcontrolenabled('PSR_LIBREPCMB' + IntToStr(Num), false);
  end;
  VisibiliteStat(GetControl('PSR_CODESTAT'), GetControl('TPSR_CODESTAT'));
  SetControlEnabled('PSR_CODESTAT',False);
end ;

procedure TOM_RESULTSIMUL.OnClose ;
begin
  Inherited ;
end ;

procedure TOM_RESULTSIMUL.OnCancelRecord ;
begin
  Inherited ;
end ;

Initialization
  registerclasses ( [ TOM_RESULTSIMUL ] ) ; 
end.
