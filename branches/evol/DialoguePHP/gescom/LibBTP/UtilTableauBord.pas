unit UtilTableauBord;

interface

uses
  Classes,
  Hctrls,
  {$IFNDEF EAGLCLIENT}
  db,
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  Fe_Main,
  {$ELSE}
  MaineAGL,
  {$ENDIF}
  sysutils,
  HEnt1,
  HMsgBox,
  UTOB,
  Entgc,
  AGLInit,
  AGLInitBTP;

type
	ToptPrevuAvanc = (OptDetailDev,OptDetailPBT,OptDetailETU,OptDetailBCE,OptGlobal,OptDetailFAC);
  TChoixPrevuAvanc = set of ToptPrevuAvanc;


procedure AjouteChampSupPrevu(TOBTmp : TOB; Nature : string);
procedure SetprevuAvance (TOBTMP : TOB; NaturePiece : string ; OptionChoixPrevuAvanc : TChoixPrevuAvanc; WherePiece : string='');
procedure AjouteChampSupRealiseDetail (TOBTmp : TOB);
procedure AjouteChampSupFactureDetail (TOBTmp : TOB);

implementation


procedure CumuleprevufactureAutre (TOBTMP: TOB; NaturePiece : string; MontantPa,MontantPr,MontantPV : double);
var LocNaturePiece : string;
begin
  if (NaturePiece = 'FBT') or (NaturePiece = 'ABT') or (NaturePiece = 'FAC') or (NaturePiece = 'AVC') Then
  begin
     TOBTMP.PutValue('FACTURE_AUTRE', TOBTMP.GetValue('FACTURE_AUTRE')+MontantPV);
  end else
  begin
     if NaturePiece = 'AFF' Then LocNaturePiece := 'PBT' else LocNaturePiece := naturePiece;
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_AUTPA', TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_AUTPA')+MontantPA);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_AUTPR', TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_AUTPR')+MontantPR);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_AUTPV', TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_AUTPV')+MontantPV);
     if Naturepiece = 'AFF' Then
     begin
       TOBTMP.PutValue('PREVUPA', TOBTMP.GetValue('PREVUPA') + MontantPA);
       TOBTMP.PutValue('PREVUPR', TOBTMP.GetValue('PREVUPR') + MontantPR);
       TOBTMP.PutValue('PREVUPV', TOBTMP.GetValue('PREVUPV') + MontantPV);
     end;
  end;
end;

procedure CumuleprevufactureSalarie (TOBTMP : TOB ; NaturePiece : string; MontantPa,MontantPr,MontantPV,TpsPrevu : double);
var LocNaturePiece : string;
begin
  if (NaturePiece = 'FBT') or (NaturePiece = 'ABT') or (NaturePiece = 'FAC') or (NaturePiece = 'AVC') Then
  begin
     TOBTMP.PutValue('FACTURE_SALARIE', TOBTMP.GetValue('FACTURE_SALARIE')+MontantPV);
  end else
  begin
     if NaturePiece = 'AFF' Then LocNaturePiece := 'PBT' else LocNaturePiece := naturePiece;
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_MOSALPA',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_MOSALPA') + MontantPA);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_MOSALPR',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_MOSALPR') + MontantPR);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_MOSALPV',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_MOSALPV') + MontantPV);
     TOBTMP.PutValue('TPS_PREVU_'+LocNaturePiece+'_MOSAL',TOBTMP.GetValue('TPS_PREVU_'+LocNaturePiece+'_MOSAL') + TpsPRevu);
     if Naturepiece = 'AFF' Then
     begin
       TOBTMP.PutValue('PREVUPA', TOBTMP.GetValue('PREVUPA') + MontantPA);
       TOBTMP.PutValue('PREVUPR', TOBTMP.GetValue('PREVUPR') + MontantPR);
       TOBTMP.PutValue('PREVUPV', TOBTMP.GetValue('PREVUPV') + MontantPV);
       TOBTMP.PutValue('TPS_PREVU', TOBTMP.GetValue('TPS_PREVU')+ TpsPrevu);
     end;
  end;
end;

procedure CumuleprevufactureInterimaire (TOBTMP : TOB ; NaturePiece : string; MontantPa,MontantPr,MontantPV,TpsPrevu : double);
var LocNaturePiece : string;
begin
  if (NaturePiece = 'FBT') or (NaturePiece = 'ABT') or (NaturePiece = 'FAC') or (NaturePiece = 'AVC') Then
  begin
     TOBTMP.PutValue('FACTURE_INTERIM', TOBTMP.GetValue('FACTURE_INTERIM')+MontantPV);
  end else
  begin
     if NaturePiece = 'AFF' Then LocNaturePiece := 'PBT' else LocNaturePiece := naturePiece;
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_MOINTPA',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_MOINTPA') + MontantPA);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_MOINTPR',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_MOINTPR') + MontantPR);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_MOINTPV',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_MOINTPV') + MontantPV);
     TOBTMP.PutValue('TPS_PREVU_'+LocNaturePiece+'_MOINT',TOBTMP.GetValue('TPS_PREVU_'+LocNaturePiece+'_MOINT') + TpsPRevu);
     if Naturepiece = 'AFF' Then
     begin
       TOBTMP.PutValue('PREVUPA', TOBTMP.GetValue('PREVUPA') + MontantPA);
       TOBTMP.PutValue('PREVUPR', TOBTMP.GetValue('PREVUPR') + MontantPR);
       TOBTMP.PutValue('PREVUPV', TOBTMP.GetValue('PREVUPV') + MontantPV);
     end;
  end;
end;

procedure CumuleprevufactureLocation (TOBTMP : TOB ; NaturePiece : string; MontantPa,MontantPr,MontantPV : double);
var LocNaturePiece : string;
begin
  if (NaturePiece = 'FBT') or (NaturePiece = 'ABT') or (NaturePiece = 'FAC') or (NaturePiece = 'AVC') Then
  begin
     TOBTMP.PutValue('FACTURE_LOCATION', TOBTMP.GetValue('FACTURE_LOCATION')+MontantPV);
  end else
  begin
     if NaturePiece = 'AFF' Then LocNaturePiece := 'PBT' else LocNaturePiece := naturePiece;
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_LOCPA',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_LOCPA') + MontantPA);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_LOCPR',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_LOCPR') + MontantPR);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_LOCPV',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_LOCPV') + MontantPV);
     if Naturepiece = 'AFF' Then
     begin
       TOBTMP.PutValue('PREVUPA', TOBTMP.GetValue('PREVUPA') + MontantPA);
       TOBTMP.PutValue('PREVUPR', TOBTMP.GetValue('PREVUPR') + MontantPR);
       TOBTMP.PutValue('PREVUPV', TOBTMP.GetValue('PREVUPV') + MontantPV);
     end;
  end;
end;

procedure CumuleprevufactureMateriel (TOBTMP : TOB; NaturePiece : string; MontantPa,MontantPr,MontantPV : double);
var LocNaturePiece : string;
begin
  if (NaturePiece = 'FBT') or (NaturePiece = 'ABT') or (NaturePiece = 'FAC') or (NaturePiece = 'AVC') Then
  begin
     TOBTMP.PutValue('FACTURE_MATERIEL', TOBTMP.GetValue('FACTURE_MATERIEL')+MontantPV);
  end else
  begin
     if NaturePiece = 'AFF' Then LocNaturePiece := 'PBT' else LocNaturePiece := naturePiece;
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_MATPA',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_MATPA') + MontantPA);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_MATPR',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_MATPR') + MontantPR);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_MATPV',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_MATPV') + MontantPV);
     if Naturepiece = 'AFF' Then
     begin
       TOBTMP.PutValue('PREVUPA', TOBTMP.GetValue('PREVUPA') + MontantPA);
       TOBTMP.PutValue('PREVUPR', TOBTMP.GetValue('PREVUPR') + MontantPR);
       TOBTMP.PutValue('PREVUPV', TOBTMP.GetValue('PREVUPV') + MontantPV);
     end;
  end;
end;

procedure CumuleprevufactureOutillage (TOBTMP : TOB; NaturePiece : string; MontantPa,MontantPr,MontantPV : double);
var LocNaturePiece : string;
begin
  if (NaturePiece = 'FBT') or (NaturePiece = 'ABT') or (NaturePiece = 'FAC') or (NaturePiece = 'AVC') Then
  begin
     TOBTMP.PutValue('FACTURE_OUTIL', TOBTMP.GetValue('FACTURE_OUTIL')+MontantPV);
  end else
  begin
     if NaturePiece = 'AFF' Then LocNaturePiece := 'PBT' else LocNaturePiece := naturePiece;
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_OUTPA',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_OUTPA') + MontantPA);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_OUTPR',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_OUTPR') + MontantPR);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_OUTPV',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_OUTPV') + MontantPV);
     if Naturepiece = 'AFF' Then
     begin
       TOBTMP.PutValue('PREVUPA', TOBTMP.GetValue('PREVUPA') + MontantPA);
       TOBTMP.PutValue('PREVUPR', TOBTMP.GetValue('PREVUPR') + MontantPR);
       TOBTMP.PutValue('PREVUPV', TOBTMP.GetValue('PREVUPV') + MontantPV);
     end;
  end;
end;

procedure CumuleprevufactureSousTraitance (TOBTMP : TOB; NaturePiece : string ;MontantPa,MontantPr,MontantPV,TpsPrevu : double);
var LocNaturePiece : string;
begin
  if (NaturePiece = 'FBT') or (NaturePiece = 'ABT') or (NaturePiece = 'FAC') or (NaturePiece = 'AVC') Then
  begin
     TOBTMP.PutValue('FACTURE_ST', TOBTMP.GetValue('FACTURE_ST')+MontantPV);
  end else
  begin
     if NaturePiece = 'AFF' Then LocNaturePiece := 'PBT' else LocNaturePiece := naturePiece;
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_STPA',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_STPA') + MontantPA);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_STPR',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_STPR') + MontantPR);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_STPV',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_STPV') + MontantPV);
     TOBTMP.PutValue('TPS_PREVU_'+LocNaturePiece+'_ST',TOBTMP.GetValue('TPS_PREVU_'+LocNaturePiece+'_ST') + TpsPrevu);
     if Naturepiece = 'AFF' Then
     begin
       TOBTMP.PutValue('PREVUPA', TOBTMP.GetValue('PREVUPA') + MontantPA);
       TOBTMP.PutValue('PREVUPR', TOBTMP.GetValue('PREVUPR') + MontantPR);
       TOBTMP.PutValue('PREVUPV', TOBTMP.GetValue('PREVUPV') + MontantPV);
     end;
  end;
end;

procedure CumuleprevufactureFourniture (TOBTMP : TOB; NaturePiece : string ; MontantPa,MontantPr,MontantPV : double);
var LocNaturePiece : string;
begin
  if (NaturePiece = 'FBT') or (NaturePiece = 'ABT') or (NaturePiece = 'FAC') or (NaturePiece = 'AVC') Then
  begin
     TOBTMP.PutValue('FACTURE_FOURNITURE', TOBTMP.GetValue('FACTURE_FOURNITURE')+MontantPV);
  end else
  begin
     if NaturePiece = 'AFF' Then LocNaturePiece := 'PBT' else LocNaturePiece := naturePiece;
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_FOURNPA',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_FOURNPA') + MontantPA);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_FOURNPR',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_FOURNPR') + MontantPR);
     TOBTMP.PutValue('PREVU_'+LocNaturePiece+'_FOURNPV',TOBTMP.GetValue('PREVU_'+LocNaturePiece+'_FOURNPV') + MontantPV);
     if Naturepiece = 'AFF' Then
     begin
       TOBTMP.PutValue('PREVUPA', TOBTMP.GetValue('PREVUPA') + MontantPA);
       TOBTMP.PutValue('PREVUPR', TOBTMP.GetValue('PREVUPR') + MontantPR);
       TOBTMP.PutValue('PREVUPV', TOBTMP.GetValue('PREVUPV') + MontantPV);
     end;
  end;
end;

procedure AjouteChampSupPrevu(TOBTmp : TOB; Nature : string);
begin
  {Depuis prévision}
    (* Autre *)
  TOBTMP.addchampsup('PREVU_'+Nature+'_AUTPA', false); TOBTMP.PutValue('PREVU_'+Nature+'_AUTPA', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_AUTPR', false); TOBTMP.PutValue('PREVU_'+Nature+'_AUTPR', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_AUTPV', false); TOBTMP.PutValue('PREVU_'+Nature+'_AUTPV', 0.0);
    (* fourniture *)
  TOBTMP.addchampsup('PREVU_'+Nature+'_FOURNPA', false); TOBTMP.PutValue('PREVU_'+Nature+'_FOURNPA', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_FOURNPR', false); TOBTMP.PutValue('PREVU_'+Nature+'_FOURNPR', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_FOURNPV', false); TOBTMP.PutValue('PREVU_'+Nature+'_FOURNPV', 0.0);
    (* Main oeuvre interne *)
  TOBTMP.addchampsup('PREVU_'+Nature+'_MOSALPA', false); TOBTMP.PutValue('PREVU_'+Nature+'_MOSALPA', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_MOSALPR', false); TOBTMP.PutValue('PREVU_'+Nature+'_MOSALPR', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_MOSALPV', false); TOBTMP.PutValue('PREVU_'+Nature+'_MOSALPV', 0.0);
  TOBTMP.addchampsup('TPS_PREVU_'+Nature+'_MOSAL', false); TOBTMP.PutValue('TPS_PREVU_'+Nature+'_MOSAL', 0.0);
    (* Main oeuvre interimaire *)
  TOBTMP.addchampsup('PREVU_'+Nature+'_MOINTPA', false); TOBTMP.PutValue('PREVU_'+Nature+'_MOINTPA', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_MOINTPR', false); TOBTMP.PutValue('PREVU_'+Nature+'_MOINTPR', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_MOINTPV', false); TOBTMP.PutValue('PREVU_'+Nature+'_MOINTPV', 0.0);
  TOBTMP.addchampsup('TPS_PREVU_'+Nature+'_MOINT', false); TOBTMP.PutValue('TPS_PREVU_'+Nature+'_MOINT', 0.0);
    (* Location *)
  TOBTMP.addchampsup('PREVU_'+Nature+'_LOCPA', false); TOBTMP.PutValue('PREVU_'+Nature+'_LOCPA', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_LOCPR', false); TOBTMP.PutValue('PREVU_'+Nature+'_LOCPR', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_LOCPV', false); TOBTMP.PutValue('PREVU_'+Nature+'_LOCPV', 0.0);
    (* Materiel *)
  TOBTMP.addchampsup('PREVU_'+Nature+'_MATPA', false); TOBTMP.PutValue('PREVU_'+Nature+'_MATPA', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_MATPR', false); TOBTMP.PutValue('PREVU_'+Nature+'_MATPR', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_MATPV', false); TOBTMP.PutValue('PREVU_'+Nature+'_MATPV', 0.0);
    (* Outillage *)
  TOBTMP.addchampsup('PREVU_'+Nature+'_OUTPA', false); TOBTMP.PutValue('PREVU_'+Nature+'_OUTPA', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_OUTPR', false); TOBTMP.PutValue('PREVU_'+Nature+'_OUTPR', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_OUTPV', false); TOBTMP.PutValue('PREVU_'+Nature+'_OUTPV', 0.0);
    (* Sous Traitance *)
  TOBTMP.addchampsup('PREVU_'+Nature+'_STPA', false); TOBTMP.PutValue('PREVU_'+Nature+'_STPA', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_STPR', false); TOBTMP.PutValue('PREVU_'+Nature+'_STPR', 0.0);
  TOBTMP.addchampsup('PREVU_'+Nature+'_STPV', false); TOBTMP.PutValue('PREVU_'+Nature+'_STPV', 0.0);
  TOBTMP.addchampsup('TPS_PREVU_'+Nature+'_ST', false); TOBTMP.PutValue('TPS_PREVU_'+Nature+'_ST', 0.0);
end;

procedure AjouteChampSupRealiseDetail (TOBTmp : TOB);
begin
  TOBTMP.addchampsup('REALISE_AUTRE_PA', false); TOBTMP.PutValue('REALISE_AUTRE_PA', 0.0);
  TOBTMP.addchampsup('REALISE_AUTRE_PR', false); TOBTMP.PutValue('REALISE_AUTRE_PR', 0.0);
  TOBTMP.addchampsup('REALISE_AUTRE_PV', false); TOBTMP.PutValue('REALISE_AUTRE_PV', 0.0);
  // Fourniture deja definie
  TOBTMP.addchampsup('REALISE_SAL_PA', false); TOBTMP.PutValue('REALISE_SAL_PA', 0.0);
  TOBTMP.addchampsup('REALISE_SAL_PR', false); TOBTMP.PutValue('REALISE_SAL_PR', 0.0);
  TOBTMP.addchampsup('REALISE_SAL_PV', false); TOBTMP.PutValue('REALISE_SAL_PV', 0.0);
  //
  TOBTMP.addchampsup('REALISE_LOC_PA', false); TOBTMP.PutValue('REALISE_LOC_PA', 0.0);
  TOBTMP.addchampsup('REALISE_LOC_PR', false); TOBTMP.PutValue('REALISE_LOC_PR', 0.0);
  TOBTMP.addchampsup('REALISE_LOC_PV', false); TOBTMP.PutValue('REALISE_LOC_PV', 0.0);
  //
  TOBTMP.addchampsup('REALISE_OUTIL_PA', false); TOBTMP.PutValue('REALISE_OUTIL_PA', 0.0);
  TOBTMP.addchampsup('REALISE_OUTIL_PR', false); TOBTMP.PutValue('REALISE_OUTIL_PR', 0.0);
  TOBTMP.addchampsup('REALISE_OUTIL_PV', false); TOBTMP.PutValue('REALISE_OUTIL_PV', 0.0);
  //
  TOBTMP.addchampsup('REALISE_ST_PA', false); TOBTMP.PutValue('REALISE_ST_PA', 0.0);
  TOBTMP.addchampsup('REALISE_ST_PR', false); TOBTMP.PutValue('REALISE_ST_PR', 0.0);
  TOBTMP.addchampsup('REALISE_ST_PV', false); TOBTMP.PutValue('REALISE_ST_PV', 0.0);
  //
  TOBTMP.addchampsup('REALISE_MAT_PA', false); TOBTMP.PutValue('REALISE_MAT_PA', 0.0);
  TOBTMP.addchampsup('REALISE_MAT_PR', false); TOBTMP.PutValue('REALISE_MAT_PR', 0.0);
  TOBTMP.addchampsup('REALISE_MAT_PV', false); TOBTMP.PutValue('REALISE_MAT_PV', 0.0);
  //
  TOBTMP.addchampsup('REALISE_INTERIM_PA', false); TOBTMP.PutValue('REALISE_INTERIM_PA', 0.0);
  TOBTMP.addchampsup('REALISE_INTERIM_PR', false); TOBTMP.PutValue('REALISE_INTERIM_PR', 0.0);
  TOBTMP.addchampsup('REALISE_INTERIM_PV', false); TOBTMP.PutValue('REALISE_INTERIM_PV', 0.0);

end;

procedure AjouteChampSupFactureDetail (TOBTmp : TOB);
begin
  TOBTMP.addchampsup('FACTURE_FOURNITURE', false); TOBTMP.PutValue('FACTURE_FOURNITURE', 0.0);
  TOBTMP.addchampsup('FACTURE_AUTRE', false); TOBTMP.PutValue('FACTURE_AUTRE', 0.0);
  TOBTMP.addchampsup('FACTURE_SALARIE', false); TOBTMP.PutValue('FACTURE_SALARIE', 0.0);
  TOBTMP.addchampsup('FACTURE_LOCATION', false); TOBTMP.PutValue('FACTURE_LOCATION', 0.0);
  TOBTMP.addchampsup('FACTURE_OUTIL', false); TOBTMP.PutValue('FACTURE_OUTIL', 0.0);
  TOBTMP.addchampsup('FACTURE_ST', false); TOBTMP.PutValue('FACTURE_ST', 0.0);
  TOBTMP.addchampsup('FACTURE_MATERIEL', false); TOBTMP.PutValue('FACTURE_MATERIEL', 0.0);
  TOBTMP.addchampsup('FACTURE_INTERIM', false); TOBTMP.PutValue('FACTURE_INTERIM', 0.0);
end;

procedure SetPrevuAvancePBT (TOBTMP : TOB; OptionChoixPrevuAvanc : TChoixPrevuAvanc);
var req : string;
		QQ : TQuery;
    MontantPA, MontantPr,MontantPV, AvancePa,AvancePr,AvancePv,TpsPrevu,TpsAvance : double;
begin
  // Récupération du prévu
  Req := 'SELECT BNP_TYPERESSOURCE,SUM(GL_QTEFACT*GL_DPA) AS ACHAT, '+
  			 'SUM(GL_QTEFACT*GL_DPR) AS REVIENT, '+
         'SUM(GL_TOTALHTDEV) AS VENTE, ' +
         'SUM(GL_QTEFACT) AS TPS_PREVU';
  // .. et de l'avance
  Req := Req + ',SUM(GL_QTEPREVAVANC*GL_DPA) AS AVANCEPA'+
  						 ',SUM(GL_QTEPREVAVANC*GL_DPR) AS AVANCEPR'+
               ',SUM(GL_TOTALHTDEV*(GL_POURCENTAVANC/100.0)) AS AVANCEPV'+
               ',SUM(GL_QTEPREVAVANC) AS TPS_AVANCE' ;
  Req := Req + ' FROM LIGNE ' +
  						 'LEFT JOIN ARTICLE ON GA_ARTICLE=GL_ARTICLE '+
               'LEFT JOIN NATUREPREST ON BNP_NATUREPRES=GA_NATUREPRES '+
               'WHERE GL_NATUREPIECEG = "PBT" AND GL_TYPELIGNE LIKE "AR%" AND GL_AFFAIRE="' + TOBTMP.GetValue('BCO_AFFAIRE') + '"' +
               'GROUP BY GL_AFFAIRE,BNP_TYPERESSOURCE';
  QQ := OpenSql (req,True);

  while not QQ.eof do
  begin
    MontantPA := QQ.findfield('ACHAT').AsFloat;
    MontantPR := QQ.findfield('REVIENT').AsFloat;
    MontantPV := QQ.findfield('VENTE').AsFloat;
    AvancePA := QQ.findfield('AVANCEPA').AsFloat;
    AvancePR := QQ.findfield('AVANCEPR').AsFloat;
    AvancePV := QQ.findfield('AVANCEPV').AsFloat;
    TpsPrevu := QQ.findfield('TPS_PREVU').AsFloat;
    TpsAvance := QQ.findfield('TPS_PREVU').AsFloat;

    TOBTMP.PutValue('PREVUPA', TOBTMP.GetValue('PREVUPA') + MontantPA);
    TOBTMP.PutValue('PREVUPR', TOBTMP.GetValue('PREVUPR') + MontantPR);
    TOBTMP.PutValue('PREVUPV', TOBTMP.GetValue('PREVUPV') + MontantPV);

    TOBTMP.PutValue('AVANCEPA', TOBTMP.GetValue('AVANCEPA') + AvancePa);
    TOBTMP.PutValue('AVANCEPR', TOBTMP.GetValue('AVANCEPR') + AvancePr);
    TOBTMP.PutValue('AVANCEPV', TOBTMP.GetValue('AVANCEPV') + AvancePV);

    if QQ.findField ('BNP_TYPERESSOURCE').asstring = 'SAL' then
    begin
      TOBTMP.PutValue('TPS_PREVU', TOBTMP.GetValue('TPS_PREVU')+ TpsPrevu);
      TOBTMP.PutValue('TPS_AVANCE', TOBTMP.GetValue('TPS_AVANCE') + TpsAvance);
    end;

    if OptDetailPBT in OptionChoixPrevuAvanc then
    begin
      if QQ.findField ('BNP_TYPERESSOURCE').asstring = 'SAL' then
      begin
        // prevu salarie
        CumuleprevufactureSalarie (TOBTMP,'PBT',MontantPa,MontantPr,MontantPV,TpsPrevu);
      end else if QQ.findField ('BNP_TYPERESSOURCE').asstring = 'AUT' then
      begin
        // prevu autre
        CumuleprevufactureAutre (TOBTMP,'PBT',MontantPa,MontantPr,MontantPV);
      end else if QQ.findField ('BNP_TYPERESSOURCE').asstring = 'INT' then
      begin
        // prevu interimaire
        CumuleprevufactureInterimaire (TOBTMP,'PBT',MontantPa,MontantPr,MontantPV,TpsPrevu);
      end else if QQ.findField ('BNP_TYPERESSOURCE').asstring = 'LOC' then
      begin
        // prevu location
        CumuleprevufactureLocation (TOBTMP,'PBT',MontantPa,MontantPr,MontantPV);
      end else if QQ.findField ('BNP_TYPERESSOURCE').asstring = 'MAT' then
      begin
        // prevu materiel
        CumuleprevufactureMateriel (TOBTMP,'PBT',MontantPa,MontantPr,MontantPV);
      end else if QQ.findField ('BNP_TYPERESSOURCE').asstring = 'OUT' then
      begin
        // prevu outillage
        CumuleprevufactureOutillage (TOBTMP,'PBT',MontantPa,MontantPr,MontantPV);
      end else if QQ.findField ('BNP_TYPERESSOURCE').asstring = 'ST' then
      begin
        // prevu sous traitance
        CumuleprevufactureSousTraitance (TOBTMP,'PBT',MontantPa,MontantPr,MontantPV,TpsPrevu);
      end else
      begin
        // prevu fourniture
        CumuleprevufactureFourniture (TOBTMP,'PBT',MontantPa,MontantPr,MontantPV);
      end;
    end;
    QQ.next;
  end;
  Ferme(QQ);
end;

procedure ChargelesLignesTB (TOBLIgne,TOBPiece : TOB);
var Req : string;
		QQ : TQuery;
begin
	Req := 'SELECT BNP_TYPERESSOURCE,GL_NATUREPIECEG,GL_TYPEARTICLE,GL_TYPENOMENC,GL_ARTICLE,GL_NUMLIGNE,GL_NUMORDRE,GL_INDICENOMEN,GL_QTEFACT,GL_DPA,GL_DPR,GL_TOTALHTDEV,GL_PUHTDEV FROM LIGNE '+
  			 'LEFT JOIN ARTICLE ON GA_ARTICLE=GL_ARTICLE '+
         'LEFT JOIN NATUREPREST ON BNP_NATUREPRES=GA_NATUREPRES '+
         'WHERE '+
         'GL_TYPELIGNE="ART" ' + // on ne prend que les lignes de type article (les commentaires...pfff)
         'AND GL_NATUREPIECEG = "'+TOBPiece.getValue('GP_NATUREPIECEG')+ '" '+
         'AND GL_SOUCHE="' + TOBPiece.GetValue('GP_SOUCHE') + '" ' +
         'AND GL_NUMERO=' + IntToStr(TOBPiece.GetValue('GP_NUMERO')) + ' '+
         'AND GL_INDICEG=' + IntToStr(TOBPiece.GetValue('GP_INDICEG')) + ' '+
         'ORDER BY GL_NUMLIGNE';
  QQ := OpenSql (req,true);
  TOBLigne.loadDetailDb ('LIGNE','','',QQ,false);
  ferme (QQ);
end;

procedure ConstitueOuvragesTB (TOBPiece,TOBOuvrage,TOBLocOuvrage : TOB);
var Lig : integer;
		indice : integer;
    TOBLig ,TOBNOuv, TOBPere, TOBnewDet,TOBL : TOB;
    LigneN1,LigneN2,LigneN3,LigneN4,LigneN5 : integer;
    IndiceOuv : integer;
begin
	// Initialisation
	Lig := 0;
  IndiceOuv := 0;
  TOBNouv := nil;
  //
	for Indice := 0 TO TOBLocOuvrage.detail.count -1 do
  begin
    TOBLig := TOBLocOuvrage.detail[Indice];
    if TOBLIg.getValue('BLO_NUMLIGNE') <> Lig then
    begin
    	// rupture sur N° de ligne --> donc nouvel ouvrage
      TOBNOuv := TOB.create ('NEW OUV',TOBOuvrage,-1);
      Lig := TOBLIg.getValue('BLO_NUMLIGNE');
      TOBL := TOBPiece.findFirst(['GL_NUMLIGNE'],[Lig],true);
      if TOBL<> nil then TOBL.putValue('GL_INDICENOMEN',TOBOuvrage.detail.count);
    end;
    LigneN1 := TOBLig.GetValue('BLO_N1');
    LigneN2 := TOBLig.GetValue('BLO_N2');
    LigneN3 := TOBLig.GetValue('BLO_N3');
    LigneN4 := TOBLig.GetValue('BLO_N4');
    LigneN5 := TOBLig.GetValue('BLO_N5');

    if LigneN5 > 0 then
    begin
			TOBPere:=TOBNOuv.FindFirst(['BLO_NUMLIGNE','BLO_N1','BLO_N2','BLO_N3','BLO_N4','BLO_N5'],[Lig,LigneN1,LigneN2,LigneN3,LigneN4,0],True) ;
    end else
    if LigneN4 > 0 then
    begin
    	TOBPere:=TOBNOuv.FindFirst(['BLO_NUMLIGNE','BLO_N1','BLO_N2','BLO_N3','BLO_N4','BLO_N5'],[Lig,LigneN1,LigneN2,LigneN3,0,0],True) ;
    end else
    if LigneN3 > 0 then
    begin
    	TOBPere:=TOBNOuv.FindFirst(['BLO_NUMLIGNE','BLO_N1','BLO_N2','BLO_N3','BLO_N4','BLO_N5'],[Lig,LigneN1,LigneN2,0,0,0],True) ;
    end else
    if LigneN2 > 0 then
    begin
      TOBPere:=TOBNOuv.FindFirst(['BLO_NUMLIGNE','BLO_N1','BLO_N2','BLO_N3','BLO_N4','BLO_N5'],[Lig,LigneN1,0,0,0,0],True) ;
    end else
    begin
    	TOBPere:=TOBNOuv;
    end;

    if TOBPere<>Nil then
    BEGIN
       TOBNewDet:=TOB.Create('LIGNEOUV',TOBPere,-1) ;
       TOBNewDet.Dupliquer(TOBLig,False,True) ;
    END;
  end;
end;

procedure ChargelesOuvragesTB (TOBOuvrage,TOBPiece : TOB);
var Req : string;
		QQ : TQuery;
    TOBLocOuvrage : TOB;
begin
	TOBLocOuvrage := TOB.Create ('OUV LU',nil,-1);
	Req := 'SELECT BNP_TYPERESSOURCE,BLO_TYPEARTICLE,BLO_NATUREPIECEG,BLO_ARTICLE,BLO_QTEFACT,BLO_DPA,BLO_REMISEPIED,'+
  			 'BLO_DPR,BLO_PUHTDEV,BLO_QTEDUDETAIL,BLO_NUMLIGNE,BLO_N1,BLO_N2,BLO_N3,BLO_N4,BLO_N5 FROM LIGNEOUV '+
  			 'LEFT JOIN ARTICLE ON GA_ARTICLE=BLO_ARTICLE '+
         'LEFT JOIN NATUREPREST ON BNP_NATUREPRES=GA_NATUREPRES '+
         'WHERE '+
         'AND BLO_NATUREPIECEG = "'+TOBPiece.getValue('GP_NATUREPIECEG')+'" '+
         'AND BLO_SOUCHE="' + TOBPiece.GetValue('GP_SOUCHE') + '" ' +
         'AND BLO_NUMERO=' + IntToStr(TOBPiece.GetValue('GP_NUMERO')) + ' '+
         'AND BLO_INDICEG=' + IntToStr(TOBPiece.GetValue('GP_INDICEG')) + ' '+
         'ORDER BY BLO_NUMLIGNE,BLO_N1,BLO_N2,BLO_N3,BLO_N4,BLO_N5';
  QQ := OpenSql (req,true);
  TOBLocOuvrage.loadDetailDb ('LIGNEOUV','','',QQ,false);
  ferme (QQ);
  ConstitueOuvragesTB (TOBPiece,TOBOuvrage,TOBLocOuvrage);
  TOBLocOuvrage.free;
end;

procedure TraiteLigneTB (TOBTMP,TOBL : TOB);
var MontantPa,MontantPr,MontantPv,TpsPrevu : double;
		NaturePiece : string;
begin
	NaturePiece := TOBL.GetValue('GL_NATUREPIECEG');
  MontantPA := TOBL.GetValue('GL_QTEFACT')*TOBL.GetValue('GL_DPA');
  MontantPR := TOBL.GetValue('GL_QTEFACT')*TOBL.GetValue('GL_DPR');
  MontantPV := TOBL.GetValue('GL_TOTALHTDEV');
  TpsPrevu := TOBL.GetValue('GL_QTEFACT');
  //
  (*
  TOBTMP.PutValue('PREVUPA', TOBTMP.GetValue('PREVUPA') + MontantPA);
  TOBTMP.PutValue('PREVUPR', TOBTMP.GetValue('PREVUPR') + MontantPR);
  TOBTMP.PutValue('PREVUPV', TOBTMP.GetValue('PREVUPV') + MontantPV);
  *)
  //
  if TOBL.GetValue('GL_TYPEARTICLE')='POU' then
  begin
    // Article de type pourcentage
    MontantPA := 0 ;
    MontantPR := 0;
    MontantPV := (TpsPrevu*TOBL.GetValue('GL_PUHTDEV')/100);
  end;
  if TOBL.GetValue('BNP_TYPERESSOURCE') = 'SAL' then
  begin
    // prevu salarie
    CumuleprevufactureSalarie (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV,TpsPrevu);
  end else if TOBL.GetValue('BNP_TYPERESSOURCE') = 'AUT' then
  begin
    // prevu autre
    CumuleprevufactureAutre (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV);
  end else if TOBL.GetValue('BNP_TYPERESSOURCE') = 'INT' then
  begin
    // prevu interimaire
    CumuleprevufactureInterimaire (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV,TpsPrevu);
  end else if TOBL.GetValue('BNP_TYPERESSOURCE') = 'LOC' then
  begin
    // prevu location
    CumuleprevufactureLocation (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV);
  end else if TOBL.GetValue('BNP_TYPERESSOURCE') = 'MAT' then
  begin
    // prevu materiel
    CumuleprevufactureMateriel (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV);
  end else if TOBL.GetValue('BNP_TYPERESSOURCE') = 'OUT' then
  begin
    // prevu outillage
    CumuleprevufactureOutillage (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV);
  end else if TOBL.GetValue('BNP_TYPERESSOURCE') = 'ST' then
  begin
    // prevu sous traitance
    CumuleprevufactureSousTraitance (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV,TpsPrevu);
  end else
  begin
    // prevu fourniture
    CumuleprevufactureFourniture (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV);
  end;
end;

procedure TraiteLigneDetailOuvrageTB (TOBTMP,TOBL : TOB;Qte,QteDuDetail : double);
var MontantPa,MontantPr,MontantPv,TpsPrevu : double;
		NaturePiece : string;
begin
	NaturePiece := TOBL.GetValue('BLO_NATUREPIECEG');
  TpsPrevu := Qte/QteDudetail;
  MontantPA := (TpsPrevu*TOBL.GetValue('BLO_DPA')) ;
  MontantPR := (TpsPrevu*TOBL.GetValue('BLO_DPR'));
  MontantPV := (TpsPrevu*TOBL.GetValue('BLO_PUHTDEV'));
  if TOBL.GetValue('BLO_TYPEARTICLE')='POU' then
  begin
    // Article de type pourcentage
    MontantPA := 0 ;
    MontantPR := 0;
    MontantPV := (TpsPrevu*TOBL.GetValue('BLO_PUHTDEV')/100);
  end;
	if TOBL.GetValue('BLO_REMISEPIED') then
  begin
  	MontantPV := MontantPV - (MontantPV * (TOBL.GetValue('BLO_REMISEPIED')/100.0));
  end;
  if TOBL.GetValue('BNP_TYPERESSOURCE') = 'SAL' then
  begin
    // prevu salarie
    CumuleprevufactureSalarie (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV,TpsPrevu);
  end else if TOBL.GetValue('BNP_TYPERESSOURCE') = 'AUT' then
  begin
    // prevu autre
    CumuleprevufactureAutre (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV);
  end else if TOBL.GetValue('BNP_TYPERESSOURCE') = 'INT' then
  begin
    // prevu interimaire
    CumuleprevufactureInterimaire (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV,TpsPrevu);
  end else if TOBL.GetValue('BNP_TYPERESSOURCE') = 'LOC' then
  begin
    // prevu location
    CumuleprevufactureLocation (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV);
  end else if TOBL.GetValue('BNP_TYPERESSOURCE') = 'MAT' then
  begin
    // prevu materiel
    CumuleprevufactureMateriel (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV);
  end else if TOBL.GetValue('BNP_TYPERESSOURCE') = 'OUT' then
  begin
    // prevu outillage
    CumuleprevufactureOutillage (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV);
  end else if TOBL.GetValue('BNP_TYPERESSOURCE') = 'ST' then
  begin
    // prevu sous traitance
    CumuleprevufactureSousTraitance (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV,TpsPrevu);
  end else
  begin
    // prevu fourniture
    CumuleprevufactureFourniture (TOBTMP,NaturePiece,MontantPa,MontantPr,MontantPV);
  end;
end;

procedure TraiteDetailOuvrageTB (TOBTMP,TOBOUV : TOB; Qte,QteDuDetail : double);
var QteSui,QteDuDetailSui : double;
		Indice : integer;
    TOBDet : TOB;
begin
  for indice := 0 to TOBOUV.detail.count -1 do
  begin
  	TOBDet := TOBOUV.detail[Indice];
    QteSui := Qte * TOBDet.GetValue('BLO_QTEFACT');
    if TOBDet.GetValue('BLO_QTEDUDETAIL') <> 0 then
    begin
       QteDuDetailSui := QteDudetail * TOBDet.GetValue('BLO_QTEDUDETAIL');
    end else
    begin
       QteDuDetailSui := QteDudetail;
    end;
    if TOBDet.detail.count > 0 then
    begin
      TraiteDetailOuvrageTB (TOBTMP,TOBDet,QteSui,QteDuDetailSui);
    end else
    begin
    	TraiteLigneDetailOuvrageTB (TOBTMP,TOBdet,QteSui,QteDuDetailSui);
    end;
  end;
end;

procedure TraiteOuvrageTB (TOBTMP,TOBL,TOBOuvrage : TOB);
var IndiceOuv : integer;
		TOBOuv : TOB;
begin
  IndiceOuv := TOBL.GetValue('GL_INDICENOMEN'); if IndiceOuv =0 then exit;
  TOBOuv := TOBOuvrage.detail[IndiceOuv-1];   if TOBOUv = nil then exit;
  TraiteDetailOuvrageTB (TOBTMP,TOBOUV,TOBL.GetValue('GL_QTEFACT'),1);
end;

procedure TraiteLaPieceTB (TOBTMP,TOBPiece,TOBOuvrage : TOB);
var Indice : integer;
		TOBL : TOB;
begin
	for indice := 0 to TOBPiece.detail.count -1 do
  begin
    TOBL := TOBPiece.detail[Indice];
    if (Pos (TOBL.GetValue('GL_TYPEARTICLE'),'OUV;OU1;ARP') > 0) and (TOBL.GetValue('GL_INDICENOMEN')>0) then
    begin
    	TraiteOuvrageTB (TOBTMP,TOBL,TOBOuvrage);
    end else
    begin
    	TraiteLigneTB (TOBTMP,TOBL);
    end;
  end;
end;

procedure DefiniPrevuDetail (TOBTMP,TOBPiece: TOB ; NaturePiece : string; OptionChoixPrevuAvanc: TChoixPrevuAvanc);
var TOBLignes,TOBOuvrages : TOB;
begin
	TOBLignes := TOB.Create ('LA PIECE',nil,-1);
  TOBLignes.Dupliquer (TOBPiece,false,true);
  TOBOuvrages := TOB.Create ('LES OUVRAGES',nil,-1);

  ChargelesLignesTB (TOBLIgnes,TOBPiece);
  ChargelesOuvragesTB (TOBOuvrages,TOBLignes);
  TraiteLaPieceTB (TOBTMP,TOBLignes,TOBOuvrages);

  TOBLIgnes.free;
  TOBOuvrages.free;
end;
                                                    
procedure SetPrevuAvanceADetaille (TOBTMP : TOB; NaturePiece : string; OptionChoixPrevuAvanc: TChoixPrevuAvanc; WherePiece : String);
var Req : String;
    TOBPieces,TOBInterm : TOB;
    QQ : TQuery;
    Indice : integer;
    Critere : string;
    RefAffaire : string;
begin
	TOBPieces := TOB.Create ('LES PIECES',nil,-1);
  RefAffaire := 'GP_AFFAIREDEVIS';
  if Naturepiece = 'DBT' then Critere := ' AND AFF_ETATAFFAIRE IN ("ACP","TER") '
  else if Naturepiece = 'AFF' then BEGIN Critere := ' AND AFF_ETATAFFAIRE IN ("ENC","TER") '; RefAffaire:='GP_AFFAIRE'; END
  else if NaturePiece = 'ETU' then Critere := ' AND AFF_ETATAFFAIRE="ACP"';

  if WherePiece = '' then
  	WherePiece := ' GP_NATUREPIECEG="'+NaturePiece+'" '+'AND GP_AFFAIRE="'+TOBTMP.GetValue('BCO_AFFAIRE') + '"';

	Req := 'SELECT GP_NATUREPIECEG,GP_SOUCHE,GP_NUMERO,GP_INDICEG FROM PIECE '+
  			 'LEFT JOIN AFFAIRE ON AFF_AFFAIRE='+RefAffaire+' WHERE '+
  			 WherePiece +
         Critere;

  QQ := OPenSql (req,true);
  TOBPieces.LoadDetailDB ('PIECE','','',QQ,false);
  Ferme (QQ);

  for indice := 0 to TOBPieces.detail.count -1 do
  begin
    DefiniPrevuDetail (TOBTMP,TOBPIeces.detail[Indice],NaturePiece,OptionChoixPrevuAvanc);
  end;

  TOBPIeces.free;
end;

procedure SetprevuAvance (TOBTMP : TOB; NaturePiece : string ; OptionChoixPrevuAvanc : TChoixPrevuAvanc; WherePiece : string='');
begin
	if NaturePiece = 'PBT' then SetPrevuAvancePBT (TOBTMP,OptionChoixPrevuAvanc)
  else SetPrevuAvanceADetaille (TOBTMP,NaturePiece,OptionChoixPrevuAvanc,WherePiece);
end;

end.
