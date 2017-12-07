{***********UNITE*************************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 02/06/2003
Modifi� le ... :   /  /
Description .. : Unit� qui contient l'ensemble des fonctions et proc�dures
Suite ........ : utilis�es pour la TD Bilat�ral
Mots clefs ... : PAIE;PGDADSB
*****************************************************************}
{
PT1   : 14/01/2004 VG V_50 Adaptation cahier des charges 2003
PT2   : 27/02/2004 VG V_50 Correction pour le calcul des salari�s ayant
                           plusieurs p�riodes d'emploi
PT3   : 31/03/2004 VG V_50 Lors du calcul, les frais professionnels �taient �
                           '' si le montant �tait �gal � 0
PT4   : 08/10/2004 VG V_50 Adaptation cahier des charges 2004
PT5   : 12/10/2006 VG V_70 Suppression du fichier de contr�le - mise en table
                           des erreurs
PT6   : 13/07/2007 VG V_72 "Condition d''emploi" remplac� par "Travail CIPDZ"
                           FQ N�14568
PT7   : 13/11/2007 NA V_80 Prise en compte des r�mun�rations heures sup exon�r�es
}
unit PgDADSBilaterale;

interface

uses
     {$IFDEF VER150}
     Variants,
     {$ENDIF}
     hctrls,
     SysUtils,
     UTob,
     HEnt1,
     HDebug,
     ParamSoc,
     HMsgBox,
     ED_TOOLS,
     PgDADSCommun,
     PgOutils2,
     EntPaie,
{$IFNDEF EAGLCLIENT}
     HStatus,
     {$IFNDEF DBXPRESS} dbTables {$ELSE} uDbxDataSet {$ENDIF};
{$ELSE}
     HStatus;
{$ENDIF}

procedure LibereTOBB;
procedure LibereTOBDADSB;
procedure ChargeTOBSalB(Salarie : string);
procedure DeleteDetailB(Salarie, ValiditeNum : string);
procedure ChargeTOBDADSB;
procedure ChercheDates(Salarie : string; TSalD : TOB; var DateD1, DateF1,
                       DateD2, DateF2 : TDateTime);
procedure CalculDADSB(Salarie : string);
procedure ChargeZones(Salarie : string);

implementation
var REMEXOHSUP : double; // pt7

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 02/06/2003
Modifi� le ... :   /  /
Description .. : Lib�ration des TOBs utilis�es pour la DADSB
Mots clefs ... : PAIE,PGDADSB
*****************************************************************}
procedure LibereTOBB;
begin
LibTOB;

FreeAndNil(TPaie);
FreeAndNil(THistoCumSal);
FreeAndNil(TBase);
FreeAndNil(TRem);
LibereTOBDADSB;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 02/06/2003
Modifi� le ... :   /  /
Description .. : Lib�ration des TOBs destination utilis�es pour la DADSB
Mots clefs ... : PAIE,PGDADSB
*****************************************************************}
procedure LibereTOBDADSB;
begin
TDADSUD.SetAllModifie (TRUE);
TDADSUD.InsertDB(nil,FALSE);
FreeAndNil(TDADSUD);
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 04/06/2003
Modifi� le ... :   /  /
Description .. : Chargement des TOB necessaires au calcul de la DADSB
Suite ........ : pour un salari�
Mots clefs ... : PAIE,PGDADSB
*****************************************************************}
procedure ChargeTOBSalB(Salarie : string);
var
StBase, StHistoCumSal, StPaieCours, StRem, sthistobulhsup : String; // pt7
QRechBase, QRechHistoCumSal, QRechPaieCours, QRechRem, Qrechhistobulhsup : TQuery;  //pt7
begin
ChTOBSal(Salarie);

//Chargement de la TOB PAIEENCOURS
StPaieCours:= 'SELECT PPU_ETABLISSEMENT, PPU_SALARIE, PPU_DATEDEBUT,'+
              ' PPU_DATEFIN, PPU_CBRUTFISCAL, PPU_CNETIMPOSAB, ET_SIRET,'+
              ' ETB_DADSSECTION, ETB_TYPDADSSECT'+
              ' FROM PAIEENCOURS'+
              ' LEFT JOIN ETABLISS ON'+
              ' ET_ETABLISSEMENT=PPU_ETABLISSEMENT'+
              ' LEFT JOIN ETABCOMPL ON'+
              ' ETB_ETABLISSEMENT=PPU_ETABLISSEMENT WHERE'+
              ' PPU_SALARIE = "'+Salarie+'" AND'+
              ' PPU_DATEFIN <= "'+UsDateTime(FinExer)+'" AND'+
              ' PPU_DATEDEBUT >= "'+UsDateTime(DebExer)+'"'+
              ' ORDER BY PPU_DATEDEBUT';
QRechPaieCours:=OpenSql(StPaieCours,TRUE);
TPaie := TOB.Create('Les Paies', NIL, -1);
TPaie.LoadDetailDB('PAIE','','',QRechPaieCours,False);
Ferme(QRechPaieCours);

//Chargement de la TOB HISTOCUMSAL
StHistoCumSal:= 'SELECT PHC_SALARIE, PHC_CUMULPAIE, PHC_MONTANT,'+
                ' PHC_DATEDEBUT, PHC_DATEFIN'+
                ' FROM HISTOCUMSAL WHERE'+
                ' PHC_SALARIE = "'+Salarie+'" AND'+
                ' (PHC_CUMULPAIE="02" OR PHC_CUMULPAIE="09" OR'+
                ' (PHC_CUMULPAIE="13" AND PHC_REPRISE="X") OR'+
                ' (PHC_CUMULPAIE="15" AND PHC_REPRISE="X") OR'+
                ' PHC_CUMULPAIE="20" OR PHC_CUMULPAIE="21") AND'+
                ' PHC_DATEFIN <= "'+UsDateTime(FinExer)+'" AND'+
                ' PHC_DATEDEBUT >= "'+UsDateTime(DebExer)+'"'+
                ' ORDER BY PHC_DATEDEBUT';
QRechHistoCumSal:=OpenSql(StHistoCumSal,TRUE);
THistoCumSal := TOB.Create('Les HistoCum', NIL, -1);
THistoCumSal.LoadDetailDB('HISTOCUM','','',QRechHistoCumSal,False);
Ferme(QRechHistoCumSal);

//Chargement de la TOB DEPORTSAL
StBase:= 'SELECT PHB_ETABLISSEMENT, PHB_SALARIE, PHB_TAUXAT, PHB_BASECOT,'+
         ' PHB_PLAFOND, PHB_TRANCHE1, PHB_TRANCHE2, PHB_TRANCHE3,'+
         ' PHB_MTPATRONAL, PCT_BRUTSS, PCT_PLAFONDSS, PCT_BASECSGCRDS,'+
         ' PCT_BASECRDS, PCT_DADSTOTIMPTSS, PCT_DADSMONTTSS, PCT_DADSEXOBASE,'+
         ' PCT_DADSEPARGNE, PHB_DATEDEBUT, PHB_DATEFIN'+
         ' FROM HISTOBULLETIN'+
         ' LEFT JOIN COTISATION ON'+
         ' PHB_RUBRIQUE=PCT_RUBRIQUE AND'+
         ' PHB_NATURERUB=PCT_NATURERUB WHERE'+
         ' PHB_SALARIE = "'+Salarie+'" AND'+
         ' (PCT_BRUTSS="X" OR PCT_PLAFONDSS="X" OR'+
         ' PCT_BASECSGCRDS="X" OR PCT_BASECRDS="X" OR PCT_DADSTOTIMPTSS="X" OR'+
         ' PCT_DADSMONTTSS="X" OR PCT_DADSEXOBASE <> "" OR'+
         ' PCT_DADSEPARGNE="X" OR PCT_DADSEXOCOT <>"") AND ##PCT_PREDEFINI##'+
         ' PHB_DATEFIN <= "'+UsDateTime(FinExer)+'" AND'+
         ' PHB_DATEDEBUT >= "'+UsDateTime(DebExer)+'" ORDER BY PHB_DATEDEBUT';
QRechBase:=OpenSql(StBase,TRUE);
TBase := TOB.Create('Les Bases', NIL, -1);
TBase.LoadDetailDB('HISTO_BULLETIN','','',QRechBase,False);
Ferme(QRechBase);

//Chargement de la TOB HISTOBULLETIN/REMUNERATION
StRem:= 'SELECT PHB_SALARIE, PHB_DATEDEBUT, PHB_DATEFIN, PHB_BASEREM,'+
        ' PHB_MTREM, PRM_AVANTAGENAT, PRM_SOMISOL, PRM_RETSALAIRE,'+
        ' PRM_FRAISPROF, PRM_CHQVACANCE, PRM_IMPOTRETSOURC, PRM_INDEXPATRIAT,'+
        ' PRM_HCHOMPAR, PRM_INDEMINTEMP, PRM_INDEMCP, PRM_BTPSALAIRE'+
        ' FROM HISTOBULLETIN'+
        ' LEFT JOIN REMUNERATION ON'+
        ' PHB_RUBRIQUE=PRM_RUBRIQUE AND'+
        ' PHB_NATURERUB=PRM_NATURERUB WHERE'+
        ' PHB_SALARIE = "'+Salarie+'" AND'+
        ' (PRM_AVANTAGENAT = "N" OR PRM_AVANTAGENAT = "L" OR'+
        ' PRM_AVANTAGENAT = "V" OR PRM_AVANTAGENAT = "A" OR'+
        ' PRM_AVANTAGENAT = "T" OR PRM_SOMISOL = "01" OR PRM_SOMISOL = "02" OR'+
        ' PRM_SOMISOL = "03" OR PRM_SOMISOL = "04" OR PRM_SOMISOL = "05" OR'+
        ' PRM_RETSALAIRE = "X" OR PRM_FRAISPROF = "X" OR'+
        ' PRM_CHQVACANCE = "X" OR PRM_IMPOTRETSOURC = "X" OR'+
        ' PRM_INDEXPATRIAT = "X" OR PRM_HCHOMPAR = "X" OR'+
        ' PRM_INDEMINTEMP = "X" OR PRM_INDEMCP = "X" OR'+
        ' PRM_BTPSALAIRE = "X") AND ##PRM_PREDEFINI##'+
        ' PHB_DATEFIN <= "'+UsDateTime(FinExer)+'" AND'+
        ' PHB_DATEDEBUT >= "'+UsDateTime(DebExer)+'" ORDER BY PHB_DATEDEBUT';
QRechRem:=OpenSql(StRem,TRUE);
TRem := TOB.Create('Les R�mun�rations', NIL, -1);
TRem.LoadDetailDB('HISTOBULL','','',QRechRem,False);
Ferme(QRechRem);

// d�but PT7
// Calcul du total de la r�mun�ration hsup exon�r�es HISTOBULLETIN/ COTISATION
StHistobulHsup:= 'SELECT SUM(PHB_BASECOT) as TOTREMHSUP '+
                 ' FROM HISTOBULLETIN '+
                 ' LEFT JOIN COTISATION ON '+
                 ' PHB_NATURERUB=PCT_NATURERUB AND PHB_RUBRIQUE=PCT_RUBRIQUE AND '+
                 ' ##PCT_PREDEFINI## WHERE ' +
                 ' (PCT_ALLEGEMENTA2="X" AND '+
                 ' PHB_DATEFIN <= "'+UsDateTime(FinExer)+'" AND'+
                 ' PHB_DATEDEBUT >= "'+UsDateTime(DebExer)+'" '+
                 ' AND PHB_MTSALARIAL<>0  AND'+
                 ' PHB_SALARIE = "'+Salarie+'")';
Qrechhistobulhsup:=OpenSql(SthistobulHsup,TRUE); 
REMEXOHSUP := 0;
if not Qrechhistobulhsup.EOF then
 REMEXOHSUP := QrechhistobulHsup.findfield('TOTREMHSUP').asfloat;

Ferme(QRechHistobulHsup);
// fin PT7

//TOB destination
ChargeTOBDADSB;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 02/06/2003
Modifi� le ... :   /  /    
Description .. : Suppression des enregistrements d�tail
Mots clefs ... : PAIE,PGDADSB
*****************************************************************}
procedure DeleteDetailB(Salarie, ValiditeNum : string);
var
StDelete : string;
begin
StDelete := 'DELETE FROM DADS2SALARIES WHERE'+
            ' PD2_SALARIE= "'+Salarie+'" AND'+
            ' PD2_VALIDITE = "'+ValiditeNum+'"';
ExecuteSQL(StDelete) ;

end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 02/06/2003
Modifi� le ... :   /  /    
Description .. : Chargement des TOB destination
Mots clefs ... : PAIE,PGDADSB
*****************************************************************}
procedure ChargeTOBDADSB;
begin
TDADSUD := TOB.Create('M�re DADSU D�tail', nil, -1);
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 04/06/2003
Modifi� le ... :   /  /
Description .. : Calcul des dates de d�but et de fin de la p�riode pour la
Suite ........ : DADSB
Mots clefs ... : PAIE,PGDADSB
*****************************************************************}
procedure ChercheDates(Salarie : string; TSalD : TOB; var DateD1, DateF1,
                       DateD2, DateF2 : TDateTime);
var
TPaieD : TOB;
begin
//Calcul des dates de ruptures salari�s
if ((TSalD.GetValue('PSA_DATESORTIE') < DebExer) AND
   (TSalD.GetValue('PSA_DATESORTIE') <> IDate1900) AND
   (TSalD.GetValue('PSA_DATESORTIE') <> null)) then
   begin
   TPaieD := TPaie.FindFirst(['PPU_SALARIE'], [Salarie], TRUE);
   While ((TPaieD <> nil) and
         ((TPaieD.GetValue('PPU_DATEDEBUT')<DebExer) or
         (TPaieD.GetValue('PPU_DATEDEBUT')>FinExer))) do
         TPaieD := TPaie.FindNext(['PPU_SALARIE'], [Salarie], TRUE);
   if ((TPaieD <> nil) and
      (TPaieD.GetValue('PPU_DATEDEBUT')>=DebExer) and
      (TPaieD.GetValue('PPU_DATEDEBUT')<=FinExer)) then
      begin
      if ((DateD1 = IDate1900) or
         (TPaieD.GetValue('PPU_DATEDEBUT')<DateD1)) then
         DateD1 := TPaieD.GetValue('PPU_DATEDEBUT');
      if ((DateF1 = IDate1900) and (TPaieD.GetValue('PPU_DATEFIN')>DateF1)) then
         DateF1 := TPaieD.GetValue('PPU_DATEFIN');
      end;
   end
else
   begin
//PT2
   if ((TSalD.GetValue('PSA_DATEENTREEPREC') >= DebExer) and
      (TSalD.GetValue('PSA_DATEENTREEPREC') <= FinExer)) then
      begin
      if ((DateD1 = IDate1900) or
         (TSalD.GetValue('PSA_DATEENTREEPREC')<DateD1)) then
         DateD1:= TSalD.GetValue('PSA_DATEENTREEPREC');
      if ((TSalD.GetValue('PSA_DATESORTIEPREC') <= FinExer) AND
         (TSalD.GetValue('PSA_DATESORTIEPREC') <> IDate1900) AND
         (TSalD.GetValue('PSA_DATESORTIEPREC') <> null)) then
         begin
         if ((DateF1 = IDate1900) and
            (TSalD.GetValue('PSA_DATESORTIEPREC')>DateF1)) then
            DateF1 := TSalD.GetValue('PSA_DATESORTIEPREC');
         end;
      end
   else
      begin
      if ((TSalD.GetValue('PSA_DATESORTIEPREC') <= FinExer) AND
         (TSalD.GetValue('PSA_DATESORTIEPREC') >= DebExer) AND
         (TSalD.GetValue('PSA_DATESORTIEPREC') <> IDate1900) AND
         (TSalD.GetValue('PSA_DATESORTIEPREC') <> null)) then
         begin
         DateD1 := DebExer;
         if ((DateF1 = IDate1900) and
            (TSalD.GetValue('PSA_DATESORTIEPREC')>DateF1)) then
            DateF1 := TSalD.GetValue('PSA_DATESORTIEPREC');
         end;
      end;
//FIN PT2      

   if ((TSalD.GetValue('PSA_DATEENTREE') >= DebExer) and
      (TSalD.GetValue('PSA_DATEENTREE') <= FinExer)) then
      begin
      if (DateD1 = IDate1900) then
         DateD1:= TSalD.GetValue('PSA_DATEENTREE')
      else
         DateD2:= TSalD.GetValue('PSA_DATEENTREE');
      end
   else
         DateD1 := DebExer;

   if ((TSalD.GetValue('PSA_DATESORTIE') <= FinExer) AND
      (TSalD.GetValue('PSA_DATESORTIE') >= DebExer) AND
      (TSalD.GetValue('PSA_DATESORTIE') <> IDate1900) AND
      (TSalD.GetValue('PSA_DATESORTIE') <> null)) then
      begin
      if (DateF1 = IDate1900) then
         DateF1:= TSalD.GetValue('PSA_DATESORTIE')
      else
         DateF2:= TSalD.GetValue('PSA_DATESORTIE');
      end
   else
      begin
      if (DateF1 = IDate1900) then
         DateF1:= FinExer
      else
         DateF2:= FinExer;
      end;
   end;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 02/06/2003
Modifi� le ... :   /  /
Description .. : Pour une p�riode donn�e, calcul des �l�ments qui
Suite ........ : rempliront la table DADS2SALARIES
Mots clefs ... : PAIE,PGDADSB
*****************************************************************}
procedure CalculDADSB(Salarie : string);
var
TBaseD, TDADSUDetail, THistoCumSalD, TRemD, TSalD : TOB;
Buf, Buf2, BufDest, BufOrig, Dept, nom, numero, StEtab , sectionetabl: string;
Total, Tot1, Tot2, Tot3, Tot4, Tot5, Tot100, Tot103, Tot105 : Double;
QRechEtab : TQuery;
DateD1, DateF1, DateD2, DateF2 : TDateTime;
Longueur, ValidSS : integer;
BoolFraisProf : boolean;
ErreurDADSU : TControle;
begin
//PT5
ErreurDADSU.Salarie:= Salarie;
ErreurDADSU.TypeD:= 'TDB';
ErreurDADSU.Num:= 1;
ErreurDADSU.DateDeb:= IDate1900;
ErreurDADSU.DateFin:= IDate1900;
ErreurDADSU.Exercice:= PGExercice;
//FIN PT5

Erreur := False;
DateD1:= IDate1900;
DateF1:= IDate1900;
DateD2:= IDate1900;
DateF2:= IDate1900;

//Recherche du salari� concern� dans la TOB Salari�s
TSalD := TSal.FindFirst(['PSA_SALARIE'], [Salarie], TRUE);

if TSalD <> nil then
   begin
{Ecriture dans le fichier de contr�le du matricule, nom et pr�nom du salari�
concern�}
{PT5
   Writeln(FRapport, '');
   Writeln(FRapport, '');
   Writeln(FRapport, 'Salari� : '+TSalD.GetValue('PSA_SALARIE')+' '+
                     TSalD.GetValue('PSA_LIBELLE')+' '+
                     TSalD.GetValue('PSA_PRENOM'));
}                     

   TDADSUDetail:=TOB.Create ('DADS2SALARIES', TDADSUD, -1);
   TDADSUDetail.PutValue('PD2_SALARIE', Salarie);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_SALARIE');
   TDADSUDetail.PutValue('PD2_VALIDITE', PGExercice);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_VALIDITE');

   StEtab:= 'SELECT ET_ETABLISSEMENT, ET_SIRET, ETB_DADSSECTION,'+
            ' ETB_TYPDADSSECT'+
            ' FROM ETABLISS'+
            ' LEFT JOIN ETABCOMPL ON'+
            ' ETB_ETABLISSEMENT=ET_ETABLISSEMENT WHERE'+
            ' ET_ETABLISSEMENT = "'+TSalD.GetValue('PSA_ETABLISSEMENT')+'"';
   QRechEtab:=OpenSql(StEtab,TRUE);
   if (not QRechEtab.EOF) then
      begin
      BufOrig := QRechEtab.FindField ('ET_SIRET').AsString;
      ForceNumerique(BufOrig, BufDest);
      if ControlSiret(BufDest)=False then
{PT5
         EcrireErreur('          Fiche Etablissement : Le SIRET n''est pas valide', Erreur);
}
         begin
         ErreurDADSU.Segment:= 'PD2_SIRET';
         ErreurDADSU.Explication:= 'Le SIRET de l''�tablissement '+
                                   QRechEtab.FindField('ET_ETABLISSEMENT').AsString+
                                   ' n''est pas valide';
         ErreurDADSU.CtrlBloquant:= True;
         EcrireErreur(ErreurDADSU);
         end;
//FIN PT5
      TDADSUDetail.PutValue ('PD2_SIRET', BufDest);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_SIRET');
      TDADSUDetail.PutValue ('PD2_ETABLISSEMENT',
                             QRechEtab.FindField('ET_ETABLISSEMENT').AsString);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_ETABLISSEMENT');

// d�but pt7 controle section etablissement
sectionetabl := QrechEtab.findfield('ETB_DADSSECTION').asstring;
if  (sectionetabl <> '01') and (sectionetabl <> '02') then
begin
      ErreurDADSU.Segment:= 'PD2_DADSSSECTION';
      ErreurDADSU.Explication:= 'La section de l''�tablissement '+ QRechEtab.FindField('ET_ETABLISSEMENT').AsString+
                                ' n''est pas valide, il a �t� forc� � 01';
      ErreurDADSU.CtrlBloquant:= false;
      EcrireErreur(ErreurDADSU);
      sectionetabl := '01';
end;

//    TDADSUDetail.PutValue ('PD2_SECTIONETAB',
//                             QrechEtab.findfield('ETB_DADSSECTION').asstring);

      TDADSUDetail.PutValue ('PD2_SECTIONETAB',  sectionetabl);
// fin pt7
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_SECTIONETAB');

      TDADSUDetail.PutValue ('PD2_TYPEDADS',
                             QRechEtab.FindField('ETB_TYPDADSSECT').AsString);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_TYPEDADS');
      end;
   Ferme(QRechEtab);

{Si le Num�ro de s�cu est renseign� : remplissage, sinon, en fonction de la
civilit�, renseignement par les valeurs "de repli"}
   if (TSalD.GetValue('PSA_NUMEROSS') = null) then
      ValidSS := 1
   else
      ValidSS := TestNumeroSS(TSalD.GetValue('PSA_NUMEROSS'),
                              TSalD.GetValue('PSA_SEXE'));
   if ((ValidSS = 0) or (ValidSS = 2)) then
      begin
      TDADSUDetail.PutValue ('PD2_NUMEROSS', TSalD.GetValue('PSA_NUMEROSS'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_NUMEROSS');
      end
   else
      begin
      if (TSalD.GetValue('PSA_CIVILITE') = 'MR') then
         begin
         TDADSUDetail.PutValue ('PD2_NUMEROSS', '199999999999999');
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_NUMEROSS');
{PT5
         EcrireErreur('          Le N� de s�curit� Sociale est invalide, il a'+
                      ' �t� forc� � 1999999999999', Erreur);
}
         ErreurDADSU.Segment:= 'PD2_NUMEROSS';
         ErreurDADSU.Explication:= 'Le N� de s�curit� Sociale est invalide, il'+
                                   ' a �t� forc� � 1999999999999';
         ErreurDADSU.CtrlBloquant:= False;
         EcrireErreur(ErreurDADSU);
//FIN PT5
         end
      else
         begin
         TDADSUDetail.PutValue ('PD2_NUMEROSS', '299999999999999');
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_NUMEROSS');
{PT5
         EcrireErreur('          Le N� de s�curit� Sociale est invalide, il a'+
                      ' �t� forc� � 2999999999999', Erreur);
}
         ErreurDADSU.Segment:= 'PD2_NUMEROSS';
         ErreurDADSU.Explication:= 'Le N� de s�curit� Sociale est invalide, il'+
                                   ' a �t� forc� � 2999999999999';
         ErreurDADSU.CtrlBloquant:= False;
         EcrireErreur(ErreurDADSU);
//FIN PT5
         end
      end;

   if TSalD.GetValue('PSA_DATENAISSANCE') <> null then
      begin
      TDADSUDetail.PutValue ('PD2_DATENAISSANCE',
                             TSalD.GetValue('PSA_DATENAISSANCE'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_DATENAISSANCE');
      end;
{Si le pays de naissance est la France, alors, r�cup�ration du d�partement et
message d'erreur si la commune de naissance et le d�partement de naissance ne
sont pas renseign�s . Si le pays de naissance n'est pas la France, alors
d�partement = '99'}
   if (TSalD.GetValue('PSA_PAYSNAISSANCE') = 'FRA') then
      begin
      Dept := '';
      if ((TSalD.GetValue('PSA_DEPTNAISSANCE') <> '') and
         (TSalD.GetValue('PSA_DEPTNAISSANCE') <> null)) then
         Dept := TSalD.GetValue('PSA_DEPTNAISSANCE');
      if (Dept = '20A') then
         Dept := '2A';
      if (Dept = '20B') then
         Dept := '2B';
      TDADSUDetail.PutValue ('PD2_DEPART', Dept);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_DEPART');
      if ((TSalD.GetValue('PSA_COMMUNENAISS') = '') or
         (TSalD.GetValue('PSA_COMMUNENAISS') = null)) then
{PT5
         EcrireErreur('          Fiche Salari� : Commune de naissance', Erreur);
}
         begin
         ErreurDADSU.Segment:= 'PD2_COMMUNENAISS';
         ErreurDADSU.Explication:= 'La commune de naissance n''est pas'+
                                   ' renseign�e';
         ErreurDADSU.CtrlBloquant:= True;
         EcrireErreur(ErreurDADSU);
         end;
//FIN PT5

      if ((TSalD.GetValue('PSA_DEPTNAISSANCE') = '') or
         (TSalD.GetValue('PSA_DEPTNAISSANCE') = null)) then
{PT5
         EcrireErreur('          Fiche Salari� : D�partement de naissance', Erreur);
}
         begin
         ErreurDADSU.Segment:= 'PD2_DEPART';
         ErreurDADSU.Explication:= 'Le d�partement de naissance n''est pas'+
                                   ' renseign�';
         ErreurDADSU.CtrlBloquant:= True;
         EcrireErreur(ErreurDADSU);
         end;
//FIN PT5
      end
   else
      begin
      TDADSUDetail.PutValue ('PD2_DEPART', '99');
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_DEPART');
      end;

{Si le pays de naissance n'est pas renseign�, cr�ation de l'enregistrement avec
'' (champ obligatoire) et erreur}
   if ((TSalD.GetValue('PSA_PAYSNAISSANCE') <> '') and
      (TSalD.GetValue('PSA_PAYSNAISSANCE') <> null)) then
      begin
      TDADSUDetail.PutValue ('PD2_PAYS', TSalD.GetValue('PSA_PAYSNAISSANCE'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_PAYS');
      end
   else
      begin
      TDADSUDetail.PutValue ('PD2_PAYS', '');
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_PAYS');
{PT5
      EcrireErreur('          Fiche Salari� : Pays de naissance', Erreur);
}
      ErreurDADSU.Segment:= 'PD2_PAYS';
      ErreurDADSU.Explication:= 'Le pays de naissance n''est pas renseign�';
      ErreurDADSU.CtrlBloquant:= True;
      EcrireErreur(ErreurDADSU);
//FIN PT5
      end;

{R�cup�ration de la commune de naissance}
   if ((TSalD.GetValue('PSA_COMMUNENAISS') <> '') and
      (TSalD.GetValue('PSA_COMMUNENAISS') <> null)) then
      begin
      TDADSUDetail.PutValue ('PD2_COMMUNENAISS',
                            TSalD.GetValue('PSA_COMMUNENAISS'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_COMMUNENAISS');
      end;

   TDADSUDetail.PutValue ('PD2_CIVILITE', TSalD.GetValue('PSA_CIVILITE'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_CIVILITE');
   if ((TSalD.GetValue('PSA_CIVILITE') = '') or
      (TSalD.GetValue('PSA_CIVILITE') = null)) then
{PT5
      EcrireErreur('          Fiche Salari� : Civilit�', Erreur);
}
      begin
      ErreurDADSU.Segment:= 'PD2_CIVILITE';
      ErreurDADSU.Explication:= 'La civilit� n''est pas renseign�e';
      ErreurDADSU.CtrlBloquant:= True;
      EcrireErreur(ErreurDADSU);
      end;
//FIN PT5

{Si le nom de jeune fille est renseign�, je le prends comme nom patronymique
sinon, je prends le nom}
   if ((TSalD.GetValue('PSA_NOMJF') = '') or
      (TSalD.GetValue('PSA_NOMJF') = null)) then
      begin
      TDADSUDetail.PutValue ('PD2_NOMMARITAL', TSalD.GetValue('PSA_LIBELLE'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_NOMMARITAL');
      end
   else
      begin
      TDADSUDetail.PutValue ('PD2_NOMJF', TSalD.GetValue('PSA_NOMJF'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_NOMJF');
      TDADSUDetail.PutValue ('PD2_NOMMARITAL', TSalD.GetValue('PSA_LIBELLE'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_NOMMARITAL');
      end;

{Si le pr�nom n'est pas renseign�, �criture d'une erreur dans le fichier de
contr�le}
   if ((TSalD.GetValue('PSA_PRENOM') = '') or
      (TSalD.GetValue('PSA_PRENOM') = null)) then
{PT5
      EcrireErreur('          Fiche Salari� : Pr�nom', Erreur)
}
      begin
      ErreurDADSU.Segment:= 'PD2_PRENOMDADS';
      ErreurDADSU.Explication:= 'Le pr�nom n''est pas renseign�';
      ErreurDADSU.CtrlBloquant:= True;
      EcrireErreur(ErreurDADSU);
      end
//FIN PT5
   else
      begin
      TDADSUDetail.PutValue ('PD2_PRENOMDADS', TSalD.GetValue('PSA_PRENOM'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_PRENOMDADS');
      end;

{Concat�nation de adresse2 et adresse3 afin de remplir le compl�ment d'adresse}
   Buf := '';
   if ((TSalD.GetValue('PSA_ADRESSE2') <> '') and
      (TSalD.GetValue('PSA_ADRESSE2') <> null)) then
      begin
      if ((TSalD.GetValue('PSA_ADRESSE3') <> '') and
         (TSalD.GetValue('PSA_ADRESSE3') <> null)) then
         Buf := TSalD.GetValue('PSA_ADRESSE2')+' '+
                TSalD.GetValue('PSA_ADRESSE3')
      else
         Buf := TSalD.GetValue('PSA_ADRESSE2');
      end
   else
      if ((TSalD.GetValue('PSA_ADRESSE3') <> '') and
         (TSalD.GetValue('PSA_ADRESSE3') <> null)) then
         Buf := TSalD.GetValue('PSA_ADRESSE3');
   if (Buf <> '') then
      begin
{v�rification que la longueur ne d�passe pas 32, sinon, tronquage}
      Longueur := Length(Buf);
      if (Longueur > 32) then
         begin
         Buf := Copy(Buf,1,32);
{PT5
         EcrireErreur('L''adresse est trop longue, v�rifiez qu''elle est conforme � :', Erreur);
         EcrireErreur('   Adresse 1 : N� et Rue', Erreur);
         EcrireErreur('   Adresse 2 : Compl�ment (escalier ...)', Erreur);
         EcrireErreur('   Adresse 3 : Compl�ment (R�sidence ...)', Erreur);
}
         ErreurDADSU.Segment:= 'PD2_ADRCOMPL';
         ErreurDADSU.Explication:= 'L''adresse a �t� tronqu�e';
         ErreurDADSU.CtrlBloquant:= False;
         EcrireErreur(ErreurDADSU);
//FIN PT5
         end;
      TDADSUDetail.PutValue ('PD2_ADRCOMPL', Buf);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_ADRCOMPL');
      end;

{Adresse1 est coup�e en 2 : d'un c�t�, le num�ro, de l'autre c�t�, le nom}
   numero := '';
   nom := '';
   if ((TSalD.GetValue('PSA_ADRESSE1') <> '') and
      (TSalD.GetValue('PSA_ADRESSE1') <> null)) then
      AdresseNormalisee (TSalD.GetValue('PSA_ADRESSE1'), numero, nom);

   if (numero <> '') then
      begin
      TDADSUDetail.PutValue ('PD2_ADRNUM', numero);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_ADRNUM');
      end;

   if (nom <> '') then
      begin
{v�rification que la longueur ne d�passe pas 26, sinon, tronquage}
      Longueur := Length(nom);
      if (Longueur > 26) then
         begin
         nom := Copy(nom,1,26);
{PT5
         EcrireErreur('L''adresse est trop longue, v�rifiez qu''elle est conforme � :', Erreur);
         EcrireErreur('   Adresse 1 : N� et Rue', Erreur);
         EcrireErreur('   Adresse 2 : Compl�ment (escalier ...)', Erreur);
         EcrireErreur('   Adresse 3 : Compl�ment (R�sidence ...)', Erreur);
}
         ErreurDADSU.Segment:= 'PD2_ADRNOM';
         ErreurDADSU.Explication:= 'L''adresse a �t� tronqu�e';
         ErreurDADSU.CtrlBloquant:= False;
         EcrireErreur(ErreurDADSU);
//FIN PT5
         end;
      TDADSUDetail.PutValue ('PD2_ADRNOM', nom);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_ADRNOM');
      end;
{On ne r�cup�re le code postal que s'il est renseign� et qu'il est num�rique sur
5 chiffres}
   if ((TSalD.GetValue('PSA_CODEPOSTAL') = '') or
      (TSalD.GetValue('PSA_CODEPOSTAL') = null) or
      (TSalD.GetValue('PSA_CODEPOSTAL') < '00000') or
      (TSalD.GetValue('PSA_CODEPOSTAL') > '99999')) then
{PT5
      EcrireErreur('          Fiche Salari� : Code Postal', Erreur)
}
      begin
      ErreurDADSU.Segment:= 'PD2_CODEPOSTAL';
      ErreurDADSU.Explication:= 'Le code postal est erronn�';
      ErreurDADSU.CtrlBloquant:= True;
      EcrireErreur(ErreurDADSU);
      end
//FIN PT5
   else
      begin
      TDADSUDetail.PutValue ('PD2_CODEPOSTAL',
                             TSalD.GetValue('PSA_CODEPOSTAL'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_CODEPOSTAL');
      end;

{On ne r�cup�re la ville que si elle est renseign�e, sinon, message d'erreur}
   if ((TSalD.GetValue('PSA_VILLE') = '') or
      (TSalD.GetValue('PSA_VILLE') = null)) then
{PT5
      EcrireErreur('          Fiche Salari� : Adresse', Erreur)
}
      begin
      ErreurDADSU.Segment:= 'PD2_BUREAUDISTRIB';
      ErreurDADSU.Explication:= 'Le bureau distributeur n''est pas renseign�';
      ErreurDADSU.CtrlBloquant:= True;
      EcrireErreur(ErreurDADSU);
      end
//FIN PT5
   else
      begin
      TDADSUDetail.PutValue ('PD2_BUREAUDISTRIB', TSalD.GetValue('PSA_VILLE'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_BUREAUDISTRIB');
      end;

   if ((TSalD.GetValue('PSA_LIBELLEEMPLOI') <> '') and
      (TSalD.GetValue('PSA_LIBELLEEMPLOI') <> null) and
      (RechDom('PGLIBEMPLOI',
               TSalD.GetValue('PSA_LIBELLEEMPLOI'), FALSE) <> '')) then
      begin
      Buf := RechDom('PGLIBEMPLOI', TSalD.GetValue('PSA_LIBELLEEMPLOI'), FALSE);
      Longueur := Length(Buf);
      if (Longueur > 30) then
         begin
         Buf := Copy(Buf,1,30);
{PT5
         EcrireErreur('          Le libell� d''emploi est trop long, il a �t� copi� sur 30 caract�res', Erreur);
}
         ErreurDADSU.Segment:= 'PD2_EMPLOIQUALIF';
         ErreurDADSU.Explication:= 'Le libell� d''emploi est trop long, il a'+
                                   ' �t� copi� sur 30 caract�res';
         ErreurDADSU.CtrlBloquant:= False;
         EcrireErreur(ErreurDADSU);
//FIN PT5
         end;
      TDADSUDetail.PutValue ('PD2_EMPLOIQUALIF', Buf);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_EMPLOIQUALIF');
      end
   else
      begin
      TDADSUDetail.PutValue ('PD2_EMPLOIQUALIF', '');
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_EMPLOIQUALIF');
{PT5
      EcrireErreur('          Fiche Salari� : Libell� emploi', Erreur);
}
      ErreurDADSU.Segment:= 'PD2_EMPLOIQUALIF';
      ErreurDADSU.Explication:= 'Le libell� d''emploi n''est pas renseign�';
      ErreurDADSU.CtrlBloquant:= True;
      EcrireErreur(ErreurDADSU);
//FIN PT5
      end;

   if ((TSalD.GetValue('PSA_CODEEMPLOI') <> '')  and
      (TSalD.GetValue('PSA_CODEEMPLOI') <> null)) then
      begin
      TDADSUDetail.PutValue ('PD2_CODEEMPLOI',
                             TSalD.GetValue('PSA_CODEEMPLOI'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_CODEEMPLOI');
      end;

   ChercheDates(Salarie, TSalD, DateD1, DateF1, DateD2, DateF2);
   if ((DateD1 <> Idate1900) and (DateF1 <> IDate1900)) then
      begin
      ForceNumerique(DateToStr(DateD1), Buf);
      Buf := Copy(Buf, 1, 4);
      ForceNumerique(DateToStr(DateF1), Buf2);
      Buf2 := Copy(Buf2, 1, 4);
      TDADSUDetail.PutValue ('PD2_PERIODE1', Buf+Buf2);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_PERIODE1');
      end;
   if ((DateD2 <> Idate1900) and (DateF2 <> IDate1900)) then
      begin
      ForceNumerique(DateToStr(DateD2), Buf);
      Buf := Copy(Buf, 1, 4);
      ForceNumerique(DateToStr(DateF2), Buf2);
      Buf2 := Copy(Buf2, 1, 4);
      TDADSUDetail.PutValue ('PD2_PERIODE2', Buf+Buf2);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_PERIODE2');
      end;

   Buf := '';
   if ((TSalD.GetValue('PSA_CONDEMPLOI') <> '') and
      (TSalD.GetValue('PSA_CONDEMPLOI') <> null)) then
      Buf := TSalD.GetValue('PSA_CONDEMPLOI');

   if ((Buf <> 'C') and (Buf <> 'I') and (Buf <> 'P') and (Buf <> 'D')) then
      begin
      Buf := 'C';
{PT5
      EcrireErreur('          Fiche Salari� : Condition d''emploi a �t� forc�e � ''Temps plein''', Erreur);
}
      ErreurDADSU.Segment:= 'PD2_CONDEMPLOI';
{PT6
      ErreurDADSU.Explication:= 'La condition d''emploi a �t� forc�e �'+
                                ' ''Temps plein''';
}
      ErreurDADSU.Explication:= 'Le travail CIPDZ a �t� forc� � ''Temps plein''';
//FIN PT6
      ErreurDADSU.CtrlBloquant:= False;
      EcrireErreur(ErreurDADSU);
//FIN PT5
      end;
      TDADSUDetail.PutValue ('PD2_CONDEMPLOI', Buf);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_CONDEMPLOI');

   TDADSUDetail.PutValue ('PD2_TRAVETRANG', TSalD.GetValue('PSA_TRAVETRANG'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_TRAVETRANG');

   TDADSUDetail.PutValue ('PD2_SORTIEDEFINIT',
                         TSalD.GetValue('PSA_SORTIEDEFINIT'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_SORTIEDEFINIT');

   Tot100 := 0;
   THistoCumSalD := THistoCumSal.FindFirst(['PHC_SALARIE', 'PHC_CUMULPAIE'],
                                           [Salarie, '02'], TRUE);
   While ((THistoCumSalD <> nil) and
         ((THistoCumSalD.GetValue('PHC_DATEDEBUT')<DebExer) or
         (THistoCumSalD.GetValue('PHC_DATEDEBUT')>FinExer))) do
         begin
         if ((THistoCumSalD.GetValue('PHC_DATEFIN')>DebExer) and
            (THistoCumSalD.GetValue('PHC_DATEFIN')<FinExer)) then
            Tot100 := Tot100 + THistoCumSalD.GetValue('PHC_MONTANT');
         THistoCumSalD := THistoCumSal.FindNext(['PHC_SALARIE', 'PHC_CUMULPAIE'],
                                                [Salarie, '02'], TRUE);
         end;
   While ((THistoCumSalD <> nil) and
         (THistoCumSalD.GetValue('PHC_DATEDEBUT')>=DebExer) and
         (THistoCumSalD.GetValue('PHC_DATEDEBUT')<=FinExer)) do
         begin
         Tot100 := Tot100 + THistoCumSalD.GetValue('PHC_MONTANT');
         THistoCumSalD := THistoCumSal.FindNext(['PHC_SALARIE', 'PHC_CUMULPAIE'],
                                                [Salarie, '02'], TRUE);
         end;
   if (Tot100 < 0) then
      Tot100 := 0;
   TDADSUDetail.PutValue ('PD2_BASEBRUTE', FloatToStr(Arrondi(Tot100, 0)));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_BASEBRUTE');
   if (Tot100 = 0) then
{PT5
      EcrireErreur('          Saisie compl�mentaire Salari� : La base brute fiscale est �gale � 0.'+#13#10+
                   '                 S''il s''agit d''un salari� Apprenti, vous devez lui faire un contrat.'+#13#10+
                   '                 Si le salari� appartient � une autre cat�gorie, effectuez les v�rifications qui s''imposent.', Erreur);
}
      begin
      ErreurDADSU.Segment:= 'PD2_BASEBRUTE';
      ErreurDADSU.Explication:= 'La base brute fiscale est �gale � 0';
      ErreurDADSU.CtrlBloquant:= False;
      EcrireErreur(ErreurDADSU);
      end;
//FIN PT5

   Tot103 := 0;
   TRemD := TRem.FindFirst(['PHB_SALARIE', 'PRM_INDEXPATRIAT'],
                           [Salarie, 'X'], TRUE);
   While ((TRemD <> nil) and
         ((TRemD.GetValue('PHB_DATEDEBUT')<DebExer) or
         (TRemD.GetValue('PHB_DATEDEBUT')>FinExer))) do
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_INDEXPATRIAT'],
                                [Salarie, 'X'], TRUE);
   While ((TRemD <> nil) and
         (TRemD.GetValue('PHB_DATEDEBUT')>=DebExer) and
         (TRemD.GetValue('PHB_DATEDEBUT')<=FinExer)) do
         begin
         Tot103 := Tot103 + TRemD.GetValue('PHB_MTREM');
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_INDEXPATRIAT'],
                                [Salarie, 'X'], TRUE);
         end;
   if (Tot103 > 0) then
      begin
      TDADSUDetail.PutValue ('PD2_INDEMEXPATRI', FloatToStr(Arrondi(Tot103, 0)));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_INDEMEXPATRI');
      end;

   Tot1 := 0;
   Tot2 := 0;
   Tot3 := 0;
   Tot4 := 0;
   Tot5 := 0;
   TRemD := TRem.FindFirst(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                           [Salarie, 'N'], TRUE);
   While ((TRemD <> nil) and
         ((TRemD.GetValue('PHB_DATEDEBUT')<DebExer) or
         (TRemD.GetValue('PHB_DATEDEBUT')>FinExer))) do
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                                [Salarie, 'N'], TRUE);
   While ((TRemD <> nil) and
         (TRemD.GetValue('PHB_DATEDEBUT')>=DebExer) and
         (TRemD.GetValue('PHB_DATEDEBUT')<=FinExer)) do
         begin
         Tot1 := Tot1 + TRemD.GetValue('PHB_MTREM');
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                                [Salarie, 'N'], TRUE);
         end;
   TRemD := TRem.FindFirst(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                           [Salarie, 'L'], TRUE);
   While ((TRemD <> nil) and
         ((TRemD.GetValue('PHB_DATEDEBUT')<DebExer) or
         (TRemD.GetValue('PHB_DATEDEBUT')>FinExer))) do
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                                [Salarie, 'L'], TRUE);
   While ((TRemD <> nil) and
         (TRemD.GetValue('PHB_DATEDEBUT')>=DebExer) and
         (TRemD.GetValue('PHB_DATEDEBUT')<=FinExer)) do
         begin
         Tot2 := Tot2 + TRemD.GetValue('PHB_MTREM');
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                                [Salarie, 'L'], TRUE);
         end;
   TRemD := TRem.FindFirst(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                           [Salarie, 'V'], TRUE);
   While ((TRemD <> nil) and
         ((TRemD.GetValue('PHB_DATEDEBUT')<DebExer) or
         (TRemD.GetValue('PHB_DATEDEBUT')>FinExer))) do
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                                [Salarie, 'V'], TRUE);
   While ((TRemD <> nil) and
         (TRemD.GetValue('PHB_DATEDEBUT')>=DebExer) and
         (TRemD.GetValue('PHB_DATEDEBUT')<=FinExer)) do
         begin
         Tot3 := Tot3 + TRemD.GetValue('PHB_MTREM');
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                                [Salarie, 'V'], TRUE);
         end;
   TRemD := TRem.FindFirst(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                           [Salarie, 'A'], TRUE);
   While ((TRemD <> nil) and
         ((TRemD.GetValue('PHB_DATEDEBUT')<DebExer) or
         (TRemD.GetValue('PHB_DATEDEBUT')>FinExer))) do
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                                [Salarie, 'A'], TRUE);
   While ((TRemD <> nil) and
         (TRemD.GetValue('PHB_DATEDEBUT')>=DebExer) and
         (TRemD.GetValue('PHB_DATEDEBUT')<=FinExer)) do
         begin
         Tot4 := Tot4 + TRemD.GetValue('PHB_MTREM');
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                                [Salarie, 'A'], TRUE);
         end;
   TRemD := TRem.FindFirst(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                           [Salarie, 'T'], TRUE);
   While ((TRemD <> nil) and
         ((TRemD.GetValue('PHB_DATEDEBUT')<DebExer) or
         (TRemD.GetValue('PHB_DATEDEBUT')>FinExer))) do
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                                [Salarie, 'T'], TRUE);
   While ((TRemD <> nil) and
         (TRemD.GetValue('PHB_DATEDEBUT')>=DebExer) and
         (TRemD.GetValue('PHB_DATEDEBUT')<=FinExer)) do
         begin
         Tot5 := Tot5 + TRemD.GetValue('PHB_MTREM');
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_AVANTAGENAT'],
                                [Salarie, 'T'], TRUE);
         end;
   Tot105:= Tot1+Tot2+Tot3+Tot4+Tot5;
   if (Tot105 > 0) then
      begin
      TDADSUDetail.PutValue ('PD2_AVANTAGENATV', FloatToStr(Arrondi(Tot105, 0)));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_AVANTAGENATV');
      end;

   Buf := '';
   if (Tot1 > 0) then
      Buf := 'N'
   else
      Buf := ' ';

   if (Tot2 > 0) then
      Buf := Buf + 'L'
   else
      Buf := Buf + ' ';

   if (Tot3 > 0) then
      Buf := Buf + 'V'
   else
      Buf := Buf + ' ';

   if (Tot4 > 0) then
      Buf := Buf + 'A'
   else
      Buf := Buf + ' ';
   TDADSUDetail.PutValue ('PD2_AVANTAGENATN', Buf);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_AVANTAGENATN');

   if (Tot5>0) then
      Buf:= 'T'
   else
      Buf:= ' ';
   TDADSUDetail.PutValue ('PD2_NTIC', Buf);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_NTIC');

   Total := 0;
   TRemD := TRem.FindFirst(['PHB_SALARIE', 'PRM_RETSALAIRE'],
                           [Salarie, 'X'], TRUE);
   While ((TRemD <> nil) and
         ((TRemD.GetValue('PHB_DATEDEBUT')<DebExer) or
         (TRemD.GetValue('PHB_DATEDEBUT')>FinExer))) do
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_RETSALAIRE'],
                                [Salarie, 'X'], TRUE);
   While ((TRemD <> nil) and
         (TRemD.GetValue('PHB_DATEDEBUT')>=DebExer) and
         (TRemD.GetValue('PHB_DATEDEBUT')<=FinExer)) do
         begin
         Total := Total + TRemD.GetValue('PHB_MTREM');
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_RETSALAIRE'],
                                [Salarie, 'X'], TRUE);
         end;
   if (Total > 0) then
      begin
      TDADSUDetail.PutValue ('PD2_RETENUESALV', FloatToStr(Arrondi(Total, 0)));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_RETENUESALV');
      end;

   if (TSalD.GetValue('PSA_REMPOURBOIRE') = 'X') then
      begin
      TDADSUDetail.PutValue ('PD2_REMPOURBOIRE',
                             TSalD.GetValue('PSA_REMPOURBOIRE'));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_REMPOURBOIRE');
      end;

   Total := 0;
   TRemD := TRem.FindFirst(['PHB_SALARIE', 'PRM_FRAISPROF'],
                           [Salarie, 'X'], TRUE);
   While ((TRemD <> nil) and
         ((TRemD.GetValue('PHB_DATEDEBUT')<DebExer) or
         (TRemD.GetValue('PHB_DATEDEBUT')>FinExer))) do
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_FRAISPROF'],
                                [Salarie, 'X'], TRUE);
   While ((TRemD <> nil) and
         (TRemD.GetValue('PHB_DATEDEBUT')>=DebExer) and
         (TRemD.GetValue('PHB_DATEDEBUT')<=FinExer)) do
         begin
         Total := Total + TRemD.GetValue('PHB_MTREM');
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_FRAISPROF'],
                                [Salarie, 'X'], TRUE);
         end;
   BoolFraisProf := FALSE;
   if (Total > 0) then
      begin
      TDADSUDetail.PutValue ('PD2_FRAISPROFM', FloatToStr(Arrondi(Total, 0)));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_FRAISPROFM');
      end;

   Buf := '';
   if (TSalD.GetValue('PSA_ALLOCFORFAIT') = 'X') then
      begin
      BoolFraisProf := TRUE;
      Buf := 'F';
      end
   else
      Buf := ' ';

   if (TSalD.GetValue('PSA_REMBJUSTIF') = 'X') then
      begin
      BoolFraisProf := TRUE;
      Buf := Buf + 'R';
      end
   else
      Buf := Buf + ' ';

   if (TSalD.GetValue('PSA_PRISECHARGE') = 'X') then
      begin
      BoolFraisProf := TRUE;
      Buf := Buf + 'P';
      end
   else
      Buf := Buf + ' ';

   if (TSalD.GetValue('PSA_AUTREDEPENSE') = 'X') then
      begin
      BoolFraisProf := TRUE;
      Buf := Buf + 'D';
      end
   else
      Buf := Buf + ' ';

   if ((BoolFraisProf = FALSE) and (Total > 0)) then
{PT5
      EcrireErreur('          Saisie compl�mentaire Salari� : Le montant des'+
                   ' frais professionnels est �gal � '+FloatToStr(Arrondi(Total, 0))+#13#10+
                   '                 mais aucune zone correspondante n''est coch�e', Erreur);
}
      begin
      ErreurDADSU.Segment:= 'PD2_FRAISPROFN';
      ErreurDADSU.Explication:= 'Le montant des frais professionnels est �gal'+
                                ' �'+FloatToStr(Arrondi(Total, 0))+' mais'+
                                ' aucune zone correspondante n''est coch�e';
      ErreurDADSU.CtrlBloquant:= True;
      EcrireErreur(ErreurDADSU);
      end;
//FIN PT5
   TDADSUDetail.PutValue ('PD2_FRAISPROFN', Buf);
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_FRAISPROFN');

   Total := 0;
   TRemD := TRem.FindFirst(['PHB_SALARIE', 'PRM_CHQVACANCE'],
                           [Salarie, 'X'], TRUE);
   While ((TRemD <> nil) and
         ((TRemD.GetValue('PHB_DATEDEBUT')<DebExer) or
         (TRemD.GetValue('PHB_DATEDEBUT')>FinExer))) do
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_CHQVACANCE'],
                                [Salarie, 'X'], TRUE);
   While ((TRemD <> nil) and
         (TRemD.GetValue('PHB_DATEDEBUT')>=DebExer) and
         (TRemD.GetValue('PHB_DATEDEBUT')<=FinExer)) do
         begin
         Total := Total + TRemD.GetValue('PHB_MTREM');
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_CHQVACANCE'],
                                [Salarie, 'X'], TRUE);
         end;
   if (Total > 0) then
      begin
      TDADSUDetail.PutValue ('PD2_CHQVACANCEM', FloatToStr(Arrondi(Total, 0)));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_CHQVACANCEM');
      end;

   Total := 0;
   Tot1 := 0;
   Tot2 := 0;
   TBaseD := TBase.FindFirst(['PHB_SALARIE', 'PCT_DADSTOTIMPTSS'],
                             [Salarie, 'X'], TRUE);
   While ((TBaseD <> nil) and
         ((TBaseD.GetValue('PHB_DATEDEBUT')<DebExer) or
         (TBaseD.GetValue('PHB_DATEDEBUT')>FinExer))) do
         TBaseD := TBase.FindNext(['PHB_SALARIE', 'PCT_DADSTOTIMPTSS'],
                                  [Salarie, 'X'], TRUE);
   While ((TBaseD <> nil) and
         (TBaseD.GetValue('PHB_DATEDEBUT')>=DebExer) and
         (TBaseD.GetValue('PHB_DATEDEBUT')<=FinExer)) do
         begin
         Total := Total + TBaseD.GetValue('PHB_BASECOT');
         Tot1 := Tot1 + TBaseD.GetValue('PHB_TRANCHE2');
         Tot2 := Tot2 + TBaseD.GetValue('PHB_TRANCHE3');
         TBaseD := TBase.FindNext(['PHB_SALARIE', 'PCT_DADSTOTIMPTSS'],
                                  [Salarie, 'X'], TRUE);
         end;
   if (Total > 0) then
      begin
      TDADSUDetail.PutValue ('PD2_TOTALIMPOSAB', FloatToStr(Arrondi(Total, 0)));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_TOTALIMPOSAB');
      end;

   TDADSUDetail.PutValue ('PD2_REMMULTIETAB', '      ');
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_REMMULTIETAB');

   if (Tot1 > 0) then
      begin
      TDADSUDetail.PutValue ('PD2_BASEIMPO1', FloatToStr(Arrondi(Tot1, 0)));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_BASEIMPO1');
      end;

   if (Tot2 > 0) then
      begin
      TDADSUDetail.PutValue ('PD2_BASEIMPO2', FloatToStr(Arrondi(Tot2, 0)));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_BASEIMPO2');
      end;

   Total := 0;
   TRemD := TRem.FindFirst(['PHB_SALARIE', 'PRM_IMPOTRETSOURC'],
                           [Salarie, 'X'], TRUE);
   While ((TRemD <> nil) and
         ((TRemD.GetValue('PHB_DATEDEBUT')<DebExer) or
         (TRemD.GetValue('PHB_DATEDEBUT')>FinExer))) do
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_IMPOTRETSOURC'],
                                [Salarie, 'X'], TRUE);
   While ((TRemD <> nil) and
         (TRemD.GetValue('PHB_DATEDEBUT')>=DebExer) and
         (TRemD.GetValue('PHB_DATEDEBUT')<=FinExer)) do
         begin
         Total := Total + TRemD.GetValue('PHB_MTREM');
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_IMPOTRETSOURC'],
                                [Salarie, 'X'], TRUE);
         end;
   if (Total > 0) then
      begin
      TDADSUDetail.PutValue ('PD2_RETENUESOURC', FloatToStr(Arrondi(Total, 0)));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_RETENUESOURC');
      end;

   Total := 0;
   TBaseD := TBase.FindFirst(['PHB_SALARIE', 'PCT_DADSEPARGNE'],
                             [Salarie, 'X'], TRUE);
   While ((TBaseD <> nil) and
         ((TBaseD.GetValue('PHB_DATEDEBUT')<DebExer) or
         (TBaseD.GetValue('PHB_DATEDEBUT')>FinExer))) do
         TBaseD := TBase.FindNext(['PHB_SALARIE', 'PCT_DADSEPARGNE'],
                                  [Salarie, 'X'], TRUE);
   While ((TBaseD <> nil) and
         (TBaseD.GetValue('PHB_DATEDEBUT')>=DebExer) and
         (TBaseD.GetValue('PHB_DATEDEBUT')<=FinExer)) do
         begin
         Total := Total + TBaseD.GetValue('PHB_BASECOT');
         TBaseD := TBase.FindNext(['PHB_SALARIE', 'PCT_DADSEPARGNE'],
                                  [Salarie, 'X'], TRUE);
         end;
   if (Total > 0) then
      begin
      TDADSUDetail.PutValue ('PD2_EPARGNERETRAI',
                             FloatToStr(Arrondi(Total, 0)));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_EPARGNERETRAI');
      end;

   Tot1 := 0;
   Tot2 := 0;
   THistoCumSalD := THistoCumSal.FindFirst(['PHC_SALARIE', 'PHC_CUMULPAIE'],
                                           [Salarie, '09'], TRUE);
   While ((THistoCumSalD <> nil) and
         ((THistoCumSalD.GetValue('PHC_DATEDEBUT')<DebExer) or
         (THistoCumSalD.GetValue('PHC_DATEDEBUT')>FinExer))) do
         THistoCumSalD := THistoCumSal.FindNext(['PHC_SALARIE', 'PHC_CUMULPAIE'],
                                                [Salarie, '09'], TRUE);
   While ((THistoCumSalD <> nil) and
         (THistoCumSalD.GetValue('PHC_DATEDEBUT')>=DebExer) and
         (THistoCumSalD.GetValue('PHC_DATEDEBUT')<=FinExer)) do
         begin
         Tot1 := Tot1 + THistoCumSalD.GetValue('PHC_MONTANT');
         THistoCumSalD := THistoCumSal.FindNext(['PHC_SALARIE', 'PHC_CUMULPAIE'],
                                                [Salarie, '09'], TRUE);
         end;
   TRemD := TRem.FindFirst(['PHB_SALARIE', 'PRM_HCHOMPAR'],
                           [Salarie, 'X'], TRUE);
   While ((TRemD <> nil) and
         ((TRemD.GetValue('PHB_DATEDEBUT')<DebExer) or
         (TRemD.GetValue('PHB_DATEDEBUT')>FinExer))) do
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_HCHOMPAR'],
                                [Salarie, 'X'], TRUE);
   While ((TRemD <> nil) and
         (TRemD.GetValue('PHB_DATEDEBUT')>=DebExer) and
         (TRemD.GetValue('PHB_DATEDEBUT')<=FinExer)) do
         begin
         Tot2 := Tot2 + TRemD.GetValue('PHB_MTREM');
         TRemD := TRem.FindNext(['PHB_SALARIE', 'PRM_HCHOMPAR'],
                                [Salarie, 'X'], TRUE);
         end;
   Total := Tot1-Tot2;
   if Total < 0 then
      Total := 0;
   TDADSUDetail.PutValue ('PD2_REVENUSACTIV', FloatToStr(Arrondi(Total, 0)));
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_REVENUSACTIV');

   if ((Total = 0) and (Tot103 = 0) and (Tot105 = 0)) then
      begin
      if (Tot100 = 0) then
         begin
         TDADSUDetail.PutValue ('PD2_CODEABSENCE', 'I');
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_CODEABSENCE');
         end
      else
         begin
         TDADSUDetail.PutValue ('PD2_CODEABSENCE', 'K');
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_CODEABSENCE');
         end;
      end
   else
      begin
      TDADSUDetail.PutValue ('PD2_CODEABSENCE', ' ');
Debug('Paie PGI/Calcul TD Bilat�ral : PD2_CODEABSENCE');
      end;

   Total := 0;
   THistoCumSalD := THistoCumSal.FindFirst(['PHC_SALARIE', 'PHC_CUMULPAIE'],
                                           [Salarie, '21'], TRUE);
   While ((THistoCumSalD <> nil) and
         ((THistoCumSalD.GetValue('PHC_DATEDEBUT')<DebExer) or
         (THistoCumSalD.GetValue('PHC_DATEDEBUT')>FinExer))) do
         begin
         if ((THistoCumSalD.GetValue('PHC_DATEFIN')>DebExer) and
            (THistoCumSalD.GetValue('PHC_DATEFIN')<FinExer)) then
            Total := Total + THistoCumSalD.GetValue('PHC_MONTANT');
         THistoCumSalD := THistoCumSal.FindNext(['PHC_SALARIE', 'PHC_CUMULPAIE'],
                                                [Salarie, '21'], TRUE);
         end;
   While ((THistoCumSalD <> nil) and
         (THistoCumSalD.GetValue('PHC_DATEDEBUT')>=DebExer) and
         (THistoCumSalD.GetValue('PHC_DATEDEBUT')<=FinExer)) do
         begin
         Total := Total + THistoCumSalD.GetValue('PHC_MONTANT');
         THistoCumSalD := THistoCumSal.FindNext(['PHC_SALARIE', 'PHC_CUMULPAIE'],
                                                [Salarie, '21'], TRUE);
         end;
   if Total < 0 then
      begin
      Total := 0;
{PT5
      EcrireErreur('          Saisie compl�mentaire Salari� : Le nombre d''heures salari�es �tait n�gatif, il a �t� forc� � 0', Erreur);
}
      ErreurDADSU.Segment:= 'PD2_NBREHEURE';
      ErreurDADSU.Explication:= 'Le nombre d''heures salari�es �tait n�gatif,'+
                                ' il a �t� forc� � 0';
      ErreurDADSU.CtrlBloquant:= False;
      EcrireErreur(ErreurDADSU);
//FIN PT5
      end;
   TDADSUDetail.PutValue ('PD2_NBREHEURE', FloatToStr(Arrondi(Total, 0)));
   Debug('Paie PGI/Calcul TD Bilat�ral : PD2_NBREHEURE');

// debut PT7
  if (RemExoHsup > 0) then
  begin
      TDADSUDetail.PutValue ('PD2_INDEMIMPATRI', FloatToStr(Arrondi(RemExoHsup, 0)));
      Debug('Paie PGI/Calcul TD Bilat�ral : PD2_INDEMIMPATRI');
  end;
// fin pt7

   end;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 12/06/2003
Modifi� le ... :   /  /
Description .. : ChargeZones
Mots clefs ... : PAIE;PGDADSB
*****************************************************************}
procedure ChargeZones(Salarie : string);
var
BufDest, NomFic : String;
begin
ForceNumerique(GetParamSoc('SO_SIRET'), BufDest);
if ControlSiret(BufDest)=False then
   PGIBox ('Le SIRET de la soci�t� n''est pas valide.#13#10'+
           'Vous devez le v�rifier en y acc�dant par le module#13#10'+
           'Param�tres/menu Comptabilit�/#13#10'+
           'commande Param�tres comptables/Coordonn�es.#13#10'+
           'Si vous travaillez en environnement multi-dossiers,#13#10'+
           'vous pouvez y acc�der par le Bureau PGI/Annuaire',
           'Calcul TD Bilat�ral');
{$IFDEF EAGLCLIENT}
NomFic := VH_Paie.PGCheminEagl+'\'+BufDest+'_TDB_PGI.log';
{$ELSE}
NomFic := V_PGI.DatPath+'\'+BufDest+'_TDB_PGI.log';
{$ENDIF}

InitMoveProgressForm (NIL,'Calcul en cours', 'Veuillez patienter SVP ...',1,FALSE,TRUE);
InitMove(1,'');

{PT5
AssignFile(FRapport, NomFic);
if FileExists(NomFic) then
   Append(FRapport)
else
   ReWrite(FRapport);
Writeln(FRapport, '');
Maintenant := Now;
Writeln(FRapport, 'D�but de calcul : '+DateTimeToStr(Maintenant));
}

if Salarie<>'' then
   begin
   if (isnumeric(Salarie) AND (VH_PAIE.PgTypeNumSal='NUM')) then
      Salarie:=ColleZeroDevant(StrToInt(Salarie),10);

   try
      begintrans;
      ChargeTOBSalB (Salarie);
      DeleteErreur (Salarie, 'TDB');	//PT5
      CalculDADSB (Salarie);
      LibereTOBB;
      CommitTrans;
   Except
      Rollback;
{PT5
      Maintenant := Now;
      Writeln (FRapport, 'Salari� '+Salarie+' : Calcul TD Bilat�ral annul� : '+
               DateTimeToStr(Maintenant));
}               
      END;
   end;

PGIBox('Traitement termin�','Calcul TD Bilat�ral');
{PT5
Maintenant := Now;
Writeln(FRapport, 'Calcul TD Bilat�ral termin� : '+DateTimeToStr(Maintenant));
CloseFile(FRapport);
}
FiniMove;
FiniMoveProgressForm;
end;

end.
