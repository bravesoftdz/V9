{***********UNITE*************************************************
Auteur  ...... : COSTE Gilles
Cr�� le ...... : 12/10/2006
Modifi� le ... : 16/10/2006
Description .. : Objet des �tats chain�s
Mots clefs ... :
*****************************************************************}
{
PT1 05/08/2003 V_42 SB Ajout de l'�tat r�duction Loi Fillon
PT2 23/02/0004 V_50 MF Ajout des �tats de la DUCS
PT3 14/05/2004 V_50 SB FQ 11197 Int�gration du r�capitulatif de paie
PT4 05/10/2004 V_50 MF Probl�me AGL : fond de page pdf ne s'�dite pas qd pas
                       d'aper�u avant impression. Pas de traitement des DUCS
                       pour la V6.
PT5 11/02/2005 V_60 SB FQ 11923 Correction pour affichage filtre �tat charges sociales
PT6 31/08/2005     PGR FQ 15920 Ajout R�capitulatif des amortissements
21/11/2005 - MBO - ajout de la liste des d�pr�ciations/Reprises
07/12/2005 - TGA - ajout de la liste des changements de conditions
14/12/2005 - MVG - Changement du titre de l'�tat ILC : Changement de conditions et non changement de dotation
27/12/2005 - PGR - FQ 15637 - Ajout de la liste des valorisations
13/01/2006 - MBO - FQ 13036 - Ajout de l'�tat des engagements
06/02/2006 - TGA - ajout de l'�tat des �tiquettes
16/02/2006 - TGA - ajout du suivi des amortissements variables
BTY 02/06  - FQ 13036 - Ajout de l'�tat des dotations simul�es
PT7 02/05/2006 V_65 SB FQ 12988 Ajout etat r�duction produit PAIE
BTY 10/06  - Ajout de l'�tat de suramortissement des primes d'�quipement
BTY 10/06  - Ajout de l'�tat de l'amortissement des subventions
MVG 11/06 - FQ 19257 - Suppression D�claration des DPI
PT8 29/03/2007 MF V_72 Ajout impression des DUCS et VLU
PT9 13/04/2007 Mf V_72 FQ 13970 - Ajout impression des DADSU r�capitulatives
MBO 16/05/2007 FQ 19923 - confusion entre �tat des mutations et r�partition des dotations
MBO 16/05/2007 Ajout des �tats li�s aux amortissements non d�ductibles
BTY 15/11/07 Ajout IFR D�claration immos issues du passage forfait � r�el (Agricoles)
             (contr�le validit� date du passage au r�el fait au d�but de l'�dition AMEDITION_TOF)
PT10 02/01/2008 FC V_81 FQ 14916 Ajout de l'�tat des r�ductions des heures suppl�mentaires
}

unit uObjEtatsChaines;

interface

uses
  Forms,          // Application.ProcessMessages;
  SysUtils,       // StrToInt
  Dialogs,        // TPrintDialog
  HEnt1,          // V_PGI
  Ent1,           // VH^.StopEdition
  HCtrls,         // ReadTokenSt
  HMsgBox,        // PgiError
  CritEdt,        // CritEdtChaine

{$IFDEF COMPTA}
{$IFDEF AMORTISSEMENT}
  AMEDITION_TOF,
{$ENDIF}
  CritSynth,      // EdtSynthCRChaine
  TofMeth,        // AGLLanceFicheEtatChaine
{$ELSE}
{$IFDEF PAIEGRH}
 // uTofPgEtatMul,  // PT2
  uTofPGEtats,
  PgOutils2,      // Etats
{$ENDIF}
{$ENDIF}
  uLibWindows,    // FileExistsDelete
  uTob,           // TOB
  uTobDebug;      // TobDebug

type RecEtat = record
    stType        : string ;
    stID          : string ; // Idendificateur d' Etat ( Sorte de cl� unique )
    stNomFiche    : string ;
    stNomFiltre   : string ;
    stNatureEtat  : string ;
    stCodeEtat    : string ;
    stLibelleEtat : string ;
    NomProcedure: procedure(vCritEdtChaine: TCritEdtChaine);
  end;


type
  TCEtatsChaines = class (TObject)
  public

    FStNomPDF        : HString;
    CritEdtChaine    : TCritEdtChaine ;

    constructor Create;
    procedure InitCritEdtChaine( vUtiliser : Boolean );
    procedure Execute ( vTobListeEtat : Tob ) ; overload ;
    destructor Destroy; override;

  private
    FBoModeCegidPGI     : Boolean ; // Pas de PrintDialog si Appel provenant du Bureau
    FBoOldSilentMode    : Boolean ;
    FBoOldNoPrintDialog : Boolean ;
    FBoOldQRPDF         : Boolean ;
    FBoOldZoomOle       : Boolean ;

    FStOldQRPDFQueue    : string ;

    FInDefaultDocCopies : Integer;
    FInQrPrinterIndex   : Integer;

    FTobYParamEdition : Tob;

    procedure _ChargeYParamEdition;

  end;

{$IFDEF YPARAMEDITION}

{$ELSE}
const  cNbEtat = 58; //PT10

// Tableau de proc�dure � lancer pour editer les �tats
var cListeEtat : array[0..cNbEtat] of RecEtat =
(
(stType : 'PG' ; stID : 'PG01' ; stNomFiche : 'EDITBUL_ETAT'      ; stNomFiltre : 'TEDITBUL_ETAT'     ; stNatureEtat : 'PBP' ; stCodeEtat : 'PBP' ; stLibelleEtat : 'Bulletin de paie'         {$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}),
(stType : 'PG' ; stID : 'PG02' ; stNomFiche : 'CHARGESOCIAL_ETAT' ; stNomFiltre : 'TCHARGESOCIAL_ETA' ; stNatureEtat : 'PSO' ; stCodeEtat : 'PSO' ; stLibelleEtat : 'Charges sociales'         {$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}),
(stType : 'PG' ; stID : 'PG03' ; stNomFiche : 'JOURNALPAIE_ETAT'  ; stNomFiltre : 'TJOURNALPAIE_ETAT' ; stNatureEtat : 'PJP' ; stCodeEtat : 'PJP' ; stLibelleEtat : 'Journal de paie'          {$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}),
(stType : 'PG' ; stID : 'PG04' ; stNomFiche : 'MODEREGLE_ETAT'    ; stNomFiltre : 'TMODEREGLE_ETAT'   ; stNatureEtat : 'PRG' ; stCodeEtat : 'PRG' ; stLibelleEtat : 'Mode de r�glements'       {$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}),
(stType : 'PG' ; stID : 'PG05' ; stNomFiche : 'REDUCTION_ETAT'    ; stNomFiltre : 'TREDUCTION_ETAT'   ; stNatureEtat : 'PRD' ; stCodeEtat : 'PBS' ; stLibelleEtat : 'R�ductions bas salaire'   {$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}),
(stType : 'PG' ; stID : 'PG06' ; stNomFiche : 'REDUCTION_ETAT'    ; stNomFiltre : 'TREDUCTION_ETAT'   ; stNatureEtat : 'PRD' ; stCodeEtat : 'PLA' ; stLibelleEtat : 'R�ductions loi Aubry II'  {$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}),
(stType : 'PG' ; stID : 'PG07' ; stNomFiche : 'REDUCTION_ETAT'    ; stNomFiltre : 'TREDUCTION_ETAT'   ; stNatureEtat : 'PRD' ; stCodeEtat : 'PRP' ; stLibelleEtat : 'R�ductions repas'         {$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}),
(stType : 'PG' ; stID : 'PG08' ; stNomFiche : 'REDUCTION_ETAT'    ; stNomFiltre : 'TREDUCTION_ETAT'   ; stNatureEtat : 'PRD' ; stCodeEtat : 'PLF' ; stLibelleEtat : 'R�ductions loi Fillon'    {$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}), { PT1 }
(stType : 'PG' ; stID : 'PG09' ; stNomFiche : 'REDUCTION_ETAT'    ; stNomFiltre : 'TREDUCTION_ETAT'   ; stNatureEtat : 'PRD' ; stCodeEtat : 'PFN' ; stLibelleEtat : 'R�ductions loi Fillon Notaire CRPCEN'    {$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}), { PT7 }
(stType : 'PG' ; stID : 'PG10' ; stNomFiche : 'RECAPPAIE_ETAT'    ; stNomFiltre : 'TRECAPPAIE_ETAT'   ; stNatureEtat : 'PFI' ; stCodeEtat : 'PRP' ; stLibelleEtat : 'R�capitulatif de paie'    {$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}), { PT3 PT8 }
(stType : 'PG' ; stID : 'PG11' ; stNomFiche : 'REDUCTION_ETAT'    ; stNomFiltre : 'TREDUCTION_ETAT'   ; stNatureEtat : 'PRD' ; stCodeEtat : 'PHS' ; stLibelleEtat : 'R�ductions heures suppl�mentaires'    {$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}), { PT10 }
//PT4 : A r�activer qd correction AGL ok (ne pas oublier modif cNbEtat)
(stType : 'PG' ; stID : 'PG12' ; stNomFiche : 'IMPRDUCS'          ; stNomFiltre : 'TIMPRDUCS'         ; stNatureEtat : 'PDU' ; stCodeEtat : 'DUC' ; stLibelleEtat : 'Ducs'                     {$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}), { PT8 }
(stType : 'PG' ; stID : 'PG13' ; stNomFiche : 'IMPRDUCS'          ; stNomFiltre : 'TIMPRDUCS'         ; stNatureEtat : 'PDU' ; stCodeEtat : 'DUN' ; stLibelleEtat : 'Ducs N�ant'               {$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}), { PT8 }
(stType : 'PG' ; stID : 'PG14' ; stNomFiche : 'IMPRDUCS'          ; stNomFiltre : 'TIMPRDUCS'         ; stNatureEtat : 'PDU' ; stCodeEtat : 'PVU' ; stLibelleEtat : 'VLU (Annexe � la DUCS Assedic)'{$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}), { PT8 }
(stType : 'PG' ; stID : 'PG15' ; stNomFiche : 'EDITDADSPER'       ; stNomFiltre : 'TEDITDADSPER'      ; stNatureEtat : 'PDA' ; stCodeEtat : 'PR6' ; stLibelleEtat : 'DADSU r�capitulative'{$IFDEF PAIEGRH} ; NomProcedure : AGLLanceFichePGEtatChaine {$ENDIF}), { PT9 }

(stType : 'CP' ; stID : 'CP01' ; stNomFiche : 'CPBALGEN'          ; stNomFiltre : 'TCPBALGEN'         ; stNatureEtat : 'BGE' ; stCodeEtat : 'BAL' ; stLibelleEtat : 'Balance g�n�rale'                             {$IFDEF COMPTA } ; NomProcedure : AGLLanceFicheEtatChaine {$ENDIF}),
(stType : 'CP' ; stID : 'CP14' ; stNomFiche : 'CPBALGENAUXI'      ; stNomFiltre : 'TCPBALGENAUXI'     ; stNatureEtat : 'BGX' ; stCodeEtat : 'BGX' ; stLibelleEtat : 'Balance g�n�rale par auxiliaire'              {$IFDEF COMPTA } ; NomProcedure : AGLLanceFicheEtatChaine {$ENDIF}),
(stType : 'CP' ; stID : 'CP02' ; stNomFiche : 'CPGLGENE'          ; stNomFiltre : 'TCPGLGENE'         ; stNatureEtat : 'GLG' ; stCodeEtat : 'GLG' ; stLibelleEtat : 'Comptes et grand livre g�n�ral'               {$IFDEF COMPTA } ; NomProcedure : AGLLanceFicheEtatChaine {$ENDIF}),
(stType : 'CP' ; stID : 'CP12' ; stNomFiche : 'CPGLGENEPARAUXI'   ; stNomFiltre : 'TCPGLGENEPARAUXI'  ; stNatureEtat : 'GLG' ; stCodeEtat : 'GLG' ; stLibelleEtat : 'Grand livre g�n�ral par auxiliaire'           {$IFDEF COMPTA } ; NomProcedure : AGLLanceFicheEtatChaine {$ENDIF}),
(stType : 'CP' ; stID : 'CP03' ; stNomFiche : 'CPBALAUXI'         ; stNomFiltre : 'TCPBALAUXI'        ; stNatureEtat : 'BAU' ; stCodeEtat : 'BAX' ; stLibelleEtat : 'Balance auxiliaire'                           {$IFDEF COMPTA } ; NomProcedure : AGLLanceFicheEtatChaine {$ENDIF}),
(stType : 'CP' ; stID : 'CP15' ; stNomFiche : 'CPBALAUXIGEN'      ; stNomFiltre : 'TCPBALAUXIGEN'     ; stNatureEtat : 'BXG' ; stCodeEtat : 'BXG' ; stLibelleEtat : 'Balance auxiliaire par g�n�ral'               {$IFDEF COMPTA } ; NomProcedure : AGLLanceFicheEtatChaine {$ENDIF}),
(stType : 'CP' ; stID : 'CP04' ; stNomFiche : 'CPGLAUXI'          ; stNomFiltre : 'TCPGLAUXI'         ; stNatureEtat : 'GLA' ; stCodeEtat : 'GLA' ; stLibelleEtat : 'Grand livre auxiliaire'                       {$IFDEF COMPTA } ; NomProcedure : AGLLanceFicheEtatChaine {$ENDIF}),
(stType : 'CP' ; stID : 'CP13' ; stNomFiche : 'CPGLAUXIPARGENE'   ; stNomFiltre : 'TCPGLAUXIPARGENE'  ; stNatureEtat : 'GLA' ; stCodeEtat : 'GLA' ; stLibelleEtat : 'Grand livre auxiliaire par g�n�ral'           {$IFDEF COMPTA } ; NomProcedure : AGLLanceFicheEtatChaine {$ENDIF}),
(stType : 'CP' ; stID : 'CP05' ; stNomFiche : 'CPJALECR'          ; stNomFiltre : 'TCPJALECR'         ; stNatureEtat : 'JDI' ; stCodeEtat : 'JLA' ; stLibelleEtat : 'Journal des �critures'                        {$IFDEF COMPTA } ; NomProcedure : AGLLanceFicheEtatChaine {$ENDIF}),
(stType : 'CP' ; stID : 'CP06' ; stNomFiche : 'EPJALGEN'          ; stNomFiltre : 'TEPJALGEN'         ; stNatureEtat : 'JAC' ; stCodeEtat : 'JCD' ; stLibelleEtat : 'Journal centralisateur'                       {$IFDEF COMPTA } ; NomProcedure : AGLLanceFicheEtatChaine {$ENDIF}),
(stType : 'CP' ; stID : 'CP07' ; stNomFiche : 'EPTABMVT'          ; stNomFiltre : 'TEPTABMVT'         ; stNatureEtat : 'JTA' ; stCodeEtat : 'JTL' ; stLibelleEtat : 'Tableau d''avancement - Mouvements'           {$IFDEF COMPTA } ; NomProcedure : AGLLanceFicheEtatChaine {$ENDIF}),
(stType : 'CP' ; stID : 'CP08' ; stNomFiche : 'EPTABMVT'          ; stNomFiltre : 'TEPTABMVT'         ; stNatureEtat : 'JTA' ; stCodeEtat : 'JTM' ; stLibelleEtat : 'Tableau d''avancement - Montants'             {$IFDEF COMPTA } ; NomProcedure : AGLLanceFicheEtatChaine {$ENDIF}),
(stType : 'CP' ; stID : 'CP09' ; stNomFiche : 'ETATPCLCR'         ; stNomFiltre : 'ETATPCLCR'         ; stNatureEtat : ''    ; stCodeEtat : ''    ; stLibelleEtat : 'Compte de r�sultat'                           {$IFDEF COMPTA } ; NomProcedure : EdtSynthCRChaine        {$ENDIF}),
(stType : 'CP' ; stID : 'CP10' ; stNomFiche : 'ETATPCLSIG'        ; stNomFiltre : 'ETATPCLSIG'        ; stNatureEtat : ''    ; stCodeEtat : ''    ; stLibelleEtat : 'Soldes interm�diaires de gestion'             {$IFDEF COMPTA } ; NomProcedure : EdtSynthSIGChaine       {$ENDIF}),
(stType : 'CP' ; stID : 'CP11' ; stNomFiche : 'ETATPCLBIL'        ; stNomFiltre : 'ETATPCLBIL'        ; stNatureEtat : ''    ; stCodeEtat : ''    ; stLibelleEtat : 'Bilan'                                        {$IFDEF COMPTA } ; NomProcedure : EdtSynthBILChaine       {$ENDIF}),

(stType : 'AM' ; stID : 'AM01' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFILS'            ; stNatureEtat : 'ILS' ; stCodeEtat : 'ILS' ; stLibelleEtat : 'Liste simplifi�e'                          {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM02' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFIAC'            ; stNatureEtat : 'IAC' ; stCodeEtat : 'IAC' ; stLibelleEtat : 'Liste des acquisitions'                    {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM03' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFISO'            ; stNatureEtat : 'ISO' ; stCodeEtat : 'ISO' ; stLibelleEtat : 'Liste de sorties'                          {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM30' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFIMU'            ; stNatureEtat : 'IMU' ; stCodeEtat : 'IMU' ; stLibelleEtat : 'Liste des mutations'                       {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM05' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFILD'            ; stNatureEtat : 'ILD' ; stCodeEtat : 'ILD' ; stLibelleEtat : 'Liste des d�pr�ciations/reprises'          {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM18' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFILC'            ; stNatureEtat : 'ILC' ; stCodeEtat : 'ILC' ; stLibelleEtat : 'Liste des changements de conditions'       {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM19' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFILV'            ; stNatureEtat : 'ILV' ; stCodeEtat : 'ILV' ; stLibelleEtat : 'Liste des valorisations'                   {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
// MVG FQ 19257
//(stType : 'AM' ; stID : 'AM24' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFIDD'            ; stNatureEtat : 'IDD' ; stCodeEtat : 'IDD' ; stLibelleEtat : 'D�claration des DPI'                       {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM04' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFITE'            ; stNatureEtat : 'ITE' ; stCodeEtat : 'ITE' ; stLibelleEtat : 'Tableau d''amortissement �conomique'       {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM09' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFITF'            ; stNatureEtat : 'ITF' ; stCodeEtat : 'ITF' ; stLibelleEtat : 'Tableau d''amortissement fiscal'           {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM11' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFITR'            ; stNatureEtat : 'ITR' ; stCodeEtat : 'ITR' ; stLibelleEtat : 'Suivi des amortissements d�rogatoires'     {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM22' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFITV'            ; stNatureEtat : 'ITV' ; stCodeEtat : 'ITV' ; stLibelleEtat : 'Suivi des amortissements variables'        {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM12' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFITO'            ; stNatureEtat : 'ITO' ; stCodeEtat : 'ITO' ; stLibelleEtat : 'R�partition des dotations'                 {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM10' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFITN'            ; stNatureEtat : 'ITN' ; stCodeEtat : 'ITN' ; stLibelleEtat : 'Plafond de d�ductibilit� fiscale'          {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM27' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFITQ'            ; stNatureEtat : 'ITQ' ; stCodeEtat : 'ITQ' ; stLibelleEtat : 'Quote-part personnelle'                    {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),  //ajout mbo 16.05.07
(stType : 'AM' ; stID : 'AM28' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFIRC'            ; stNatureEtat : 'IRC' ; stCodeEtat : 'IRC' ; stLibelleEtat : 'Remplacement d''un composant'              {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),  //ajout mbo 16.05.07
(stType : 'AM' ; stID : 'AM29' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFIRD'            ; stNatureEtat : 'IRD' ; stCodeEtat : 'IRD' ; stLibelleEtat : 'R�int�grations/d�ductions diverses'        {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),  //ajout mbo 16.05.07
(stType : 'AM' ; stID : 'AM06' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFIPR'            ; stNatureEtat : 'IPR' ; stCodeEtat : 'PRE' ; stLibelleEtat : 'Pr�vision �conomique sur 5 ans'            {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM07' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFIPR'            ; stNatureEtat : 'IPR' ; stCodeEtat : 'PRF' ; stLibelleEtat : 'Pr�vision fiscale sur 5 ans'               {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM08' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFIPM'            ; stNatureEtat : 'IPM' ; stCodeEtat : 'IPM' ; stLibelleEtat : 'Plus ou moins values'                      {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM14' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFIVE'            ; stNatureEtat : 'IVE' ; stCodeEtat : 'IVE' ; stLibelleEtat : 'Inventaire'                                {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM15' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFIVL'            ; stNatureEtat : 'IVL' ; stCodeEtat : 'IVL' ; stLibelleEtat : 'Lettre d''inventaire'                      {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM16' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFITP'            ; stNatureEtat : 'ITP' ; stCodeEtat : 'ITP' ; stLibelleEtat : 'Etat pr�paratoire � la taxe professionnelle'{$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM17' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFIRE'            ; stNatureEtat : 'IRE' ; stCodeEtat : 'IRE' ; stLibelleEtat : 'R�capitulatif des amortissements'          {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),{ PT6 }
(stType : 'AM' ; stID : 'AM20' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFIEG'            ; stNatureEtat : 'IEG' ; stCodeEtat : 'IEG' ; stLibelleEtat : 'Etat des engagements'                      {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM21' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFETI'            ; stNatureEtat : 'IET' ; stCodeEtat : 'IET' ; stLibelleEtat : 'Etiquettes'                                {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM23' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFIDS'            ; stNatureEtat : 'IDS' ; stCodeEtat : 'IDS' ; stLibelleEtat : 'Etat des dotations simul�es'               {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM25' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFITS'            ; stNatureEtat : 'ITS' ; stCodeEtat : 'ITS' ; stLibelleEtat : 'Suramortissement des primes d''�quipement' {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM26' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFITB'            ; stNatureEtat : 'ITB' ; stCodeEtat : 'ITB' ; stLibelleEtat : 'Amortissement des subventions'             {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF}),
(stType : 'AM' ; stID : 'AM31' ; stNomFiche : 'AMEDITION'         ; stNomFiltre : 'QRFIFR'            ; stNatureEtat : 'IFR' ; stCodeEtat : 'IFR' ; stLibelleEtat : 'Biens issus du passage forfait au r�el'    {$IFDEF AMORTISSEMENT} ; NomProcedure : AMLanceFicheEtatChaine {$ENDIF})
);
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
procedure CPEtatsChainesAuto( vStArg : string );
////////////////////////////////////////////////////////////////////////////////

implementation

uses Printers,     // Printer
     uPrintF1Book, // PDFBatch
     HPdfPrev,     // PreviewPDFFile
{$IFDEF EAGLCLIENT}
     UtileAgl,     // StartPdfBatch
{$ELSE}
     //uPdfBatch,    // StartPdfBatch
{$ENDIF}
     cbpPath;      // TCbpPath.GetCegidDistriDoc

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 13/10/2006
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure CPEtatsChainesAuto( vStArg : string );
var lStCtx         : string;
    lStFichierXML  : string;
    lBoEntete      : Boolean;
    lStEncoding    : string;
    lTobSelect     : Tob;
    lCEtatsChaines : TCEtatsChaines;
    lStDateDeb     : string;
    lStDateFin     : string;
// d PT8
    lStNatDeb      : string;
    lStNatFin      : string;
    lStEtabDeb     : string;
    lStEtabFin     : string;
// f PT8
begin
  lTobSelect := Tob.Create('ETATSCHAINES', nil, -1);
  lCEtatsChaines := TCEtatsChaines.Create;
  try
    lStCtx        := ReadTokenSt(vStArg);
    lStFichierXML := GetWindowsTempPath + lStCtx + '_ETATSCHAINES_' + V_PGI.USER + '.XML';
    lBoEntete     := False;
    lStEncoding   := '';
    lTobSelect.LoadFromXMLFile(lStFichierXML, lBOEntete, lStEncoding);

    if lTobSelect.Detail.Count = 0 then
    begin
      PgiError('Erreur au chargement du fichier : ' + lStFichierXML, 'Procedure CPLanceFiche_EtatsChainesAuto');
      Exit;
    end;

    // Cr�ation de l'objet de lancement des �tats chain�s
    lCEtatsChaines.FBoModeCegidPgi := True;

    if lTobSelect.GetBoolean('AUFORMATPDF') then
    begin
      lCEtatsChaines.CritEdtChaine.AuFormatPDF := lTobSelect.GetBoolean('AUFORMATPDF');
      lCEtatsChaines.CritEdtChaine.NomPDF      := lTobSelect.GetString('NOMPDF');
      lCEtatsChaines.CritEdtChaine.MultiPdf    := lTobSelect.GetBoolean('MULTIPDF');
    end;

    // Paie
    if lStCtx = 'PG' then
    begin
      lStDateDeb := lTobSelect.GetString('PGDATEDEB');
      lStDateFin := lTobSelect.GetString('PGDATEFIN');
// d PT8
      lStNatDeb  := lTobSelect.GetString('PGNATDEB');
      lStNatFin  := lTobSelect.GetString('PGNATFIN');
      lStEtabDeb := lTobSelect.GetString('PGETABDEB');
      lStEtabFin := lTobSelect.GetString('PGETABFIN');
// f PT8
      if IsValidDate(lStDateDeb) then lCEtatsChaines.CritEdtChaine.PGDateDeb := StrToDate(lStDateDeb);
      if IsValidDate(lStDateFin) then lCEtatsChaines.CritEdtChaine.PGDateFin := StrToDate(lStDateFin);
// d PT8
      lCEtatsChaines.CritEdtChaine.PGNatDeb  := lStNatDeb;
      lCEtatsChaines.CritEdtChaine.PGNatFin  := lStNatFin;
      lCEtatsChaines.CritEdtChaine.PGEtabDeb := lStEtabDeb;
      lCEtatsChaines.CritEdtChaine.PGEtabFin := lStEtabFin;
// f PT8
    end;

    // Lancement du traitement
    lCEtatsChaines.Execute( lTobSelect );

  finally
    Application.ProcessMessages;
    FreeAndNil(lTobSelect);
    FreeAndNil(lCEtatsChaines);
  end;

end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Constructor TCEtatsChaines.Create;
begin
  // Initialisation du CritEdtChaine pour d�but du traitement
  InitCritEdtChaine( True );

  // Variable pour arr�ter l'�dition des �tats cha�n�s
  VH^.StopEdition := False;

  // R�cup�ration du contexte
  FBoOldSilentMode    := V_PGI.SilentMode;
  FBoOldNoPrintDialog := V_PGI.NoPrintDialog;
  FBoOldQRPDF         := V_PGI.QRPDF;
  FBoOldZoomOle       := V_Pgi.ZoomOle;

  FStOldQRPDFQueue    := V_PGI.QRPDFQueue;

  FInDefaultDocCopies := V_PGI.DefaultDocCopies;
  FInQrPrinterIndex   := V_PGI.QRPrinterIndex;

  FBoModeCegidPgi     := False;

  // Passage en Mode Silencieux
  V_PGI.SilentMode    := True;

  // Mode Inside interdit
  V_Pgi.ZoomOle := True;

  FTobYParamEdition := Tob.Create('', nil, -1);

  // GCO - 24/10/2007
  V_PGI.QRPDFQueue := TempFileName(); // Fichier temporaire de Queue
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 02/07/2002
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TCEtatsChaines.InitCritEdtChaine( vUtiliser : Boolean );
begin
  CritEdtchaine.Utiliser         := vUtiliser;
  CritEdtchaine.NomFiche         := '' ;
  CritEdtchaine.NomFiltre        := '' ;
  CritEdtChaine.NatureEtat       := '' ;
  CritEdtchaine.CodeEtat         := '' ;
  CritEdtChaine.NombreExemplaire := 0;
  CritEdtchaine.FiltreUtilise    := '' ;
  CritEdtChaine.AuFormatPDF      := False;
  CritEdtChaine.NomPDF           := '' ;
  CritEdtChaine.MultiPdf         := False;
  CritEdtChaine.UtiliseCritStd   := False;
  CritEdtChaine.PGDateDeb        := idate1900;
  CritEdtChaine.PGDateFin        := idate1900;
// d PT8
  CritEdtChaine.PGNatDeb         := '' ;
  CritEdtChaine.PGNatFin         := '' ;
  CritEdtChaine.PGEtabDeb        := '' ;
  CritEdtChaine.PGEtabFin        := '' ;
// f PT8
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 05/09/2007
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TCEtatsChaines._ChargeYParamEdition;
var lStSql : HString;
begin
  // CLE YPARAMEDITION
  //YED_TYPEETAT, YED_NATUREETAT, YED_CODEETAT, YED_LANGUE, YED_CODEID, YED_PREDEFINI

  lStSql := 'SELECT YED_TYPEETAT, YED_NATUREETAT, YED_CODEETAT, YED_LIBELLE, ' +
            'YED_CODEID, YED_TYPEFORME, YED_FORME, YED_NOMFILTRE ' +
            'FROM YPARAMEDITION WHERE ' +
            'YED_ETATCHAINE = "X" ORDER BY YED_CODEID';

  FTobYParamEdition.LoadDetailFromSQL( lStSql );
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 04/03/2002
Modifi� le ... : 12/10/2006
Description .. : Traitement des �tats chain�s � partir d' une TOb,
Suite ........ :
Mots clefs ... :
*****************************************************************}
procedure TCEtatsChaines.Execute( vTobListeEtat : Tob );
var itTob : integer ;
    itRec : integer ;
    lPrintDialog : TPrintDialog;
{$IFDEF YPARAMEDITION}
    lTobEtatALancer : Tob;
{$ENDIF}    
begin
  try
    _ChargeYParamEdition;

    if CritEdtchaine.AuFormatPDF then
    begin
      if CritEdtChaine.MultiPdf then
        FStNomPDF := TCBPPath.GetCegidDistriDoc + '\' + V_Pgi.NoDossier + '-' +  ExtractFileName(CritEdtChaine.NomPDF)
      else
        FStNomPDF := CritEdtChaine.NomPDF;
    end;

(*
{$IFDEF EAGLCLIENT}
  LanceEtat('E', 'REV', 'PDG', False, False, False, nil, '','',False);
{$ELSE}
  LanceEtat('E', 'REV', 'PDG', True, False, False, nil, '', '', false);
{$ENDIF} *)

    // GCO - 31/08/2006 - FQ 18600
    lPrintDialog := nil;
    try
      if (not FBoModeCegidPGI) and (not CritEdtChaine.AuFormatPDF) then
      begin
        lPrintDialog := TPrintDialog.Create(nil);
        if not lPrintDialog.Execute then
        begin
          VH^.StopEdition := True;
          Exit;
        end
        else
          // Enregistrement des infos de l'imprimante choisie
          V_Pgi.QRPrinterIndex := Printer.PrinterIndex;
      end;
    finally
      lPrintDialog.Free;
    end;

    // D�marrage de l'impression au format PDF avec un PDFBatch
    if CritEdtChaine.AuFormatPdf then
    begin
      V_Pgi.SilentMode    := True;
      V_Pgi.QRPdf         := True;
      VH^.StopEdition     := False;
      V_Pgi.NoPrintDialog := True;
      THPrintBatch.StartPdfBatch( FStNomPDF ); //StartPdfBatch();
    end;

{$IFDEF EAGLCLIENT}
    //LanceEtat('E', 'REV', 'PDG', True, False, False, nil, '', '', False);
    //if CritEdtChaine.AuFormatPdf then
    //  THPrintBatch.AjoutPdf( V_PGI.QRPDFQueue, True );
{$ENDIF}

    for itTob := 0 to vTobListeEtat.Detail.Count - 1 do
    begin
      if VH^.StopEdition then Break;

      // GCO - 06/09/2006 - Remise � TRUE syst�matique entre chaque �dition
      //V_PGI.NoPrintDialog := True;

      if StrToInt(vTobListeEtat.Detail[itTob].GetValue('NBEXEMPLAIRE')) > 0 then
      begin
      {$IFDEF YPARAMEDITION}
        lTobEtatALancer := FTobYParamEdition.FindFirst(['YED_CODEID'],[vTobListeEtat.Detail[itTob].GetValue('ID')], False);
        if lTobEtatALancer <> nil then
        begin
          CritEdtChaine.NomFiche   := lTobEtatALancer.GetString('YED_FORME');
          CritEdtChaine.NomFiltre  := lTobEtatALancer.GetString('YED_NOMFILTRE');
          CritEdtchaine.NatureEtat := lTobEtatALancer.GetString('YED_NATUREETAT');
          CritEdtchaine.CodeEtat   := lTobEtatALancer.GetString('YED_CODEETAT');
          CritEdtChaine.NombreExemplaire := StrToInt( vTobListeEtat.Detail[itTob].GetValue('NBEXEMPLAIRE'));
        {$IFDEF EAGLCLIENT}
          if CritEdtChaine.AuFormatPdf then
            THPrintBatch.AjoutPdf( V_PGI.QRPDFQueue, True );
        {$ENDIF}
          Application.ProcessMessages;
        end;
      {$ELSE}
        // On parcourt CListeEtat pour trouver la procedure � lancer
        for itRec := 0 to cNbEtat do
        begin
          if (cListeEtat[itRec].stID = vTobListeEtat.Detail[itTob].GetValue('ID')) then
          begin
            CritEdtChaine.NomFiche         := cListeEtat[itRec].stNomFiche;
            CritEdtChaine.NomFiltre        := cListeEtat[itRec].stNomFiltre;
            CritEdtChaine.NatureEtat       := cListeEtat[itRec].stNatureEtat;
            CritEdtChaine.CodeEtat         := cListeEtat[itRec].stCodeEtat;
            CritEdtChaine.NombreExemplaire := StrToInt( vTobListeEtat.Detail[itTob].GetValue('NBEXEMPLAIRE'));
            CritEdtChaine.FiltreUtilise    := vTobListeEtat.Detail[itTob].GetValue('FILTREUTILISE');
            cListeEtat[itRec].NomProcedure(CritEdtChaine);
          {$IFDEF EAGLCLIENT}
            if CritEdtChaine.AuFormatPdf then
              THPrintBatch.AjoutPdf( V_PGI.QRPDFQueue, True );
          {$ENDIF}
            Application.ProcessMessages;
          end;
        end;
      {$ENDIF}
      end;
    end;

  finally
    if CritEdtChaine.AuFormatPdf then
    begin
      THPrintBatch.StopPdfBatch; //CancelPdfBatch;
      //PreviewPDFFile( '', FStNomPDF );
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 04/03/2002
Modifi� le ... : 05/09/2007
Description .. :
Suite ........ :
Mots clefs ... :
*****************************************************************}
destructor TCEtatsChaines.Destroy;
begin
  Application.ProcessMessages;

  // Suppression du fichier si au FORMAT PDF
  if VH^.StopEdition then
  begin
    if CritEdtChaine.AuFormatPDF then
      FileExistsDelete( FStNomPDF );
  end;

  // Restauration du contexte des variables PGI apr�s traitement
  V_PGI.SilentMode       := FBoOldSilentMode;
  V_PGI.NoPrintDialog    := FBoOldNoPrintDialog;
  V_PGI.QRPDF            := FBoOldQRPDF;
  V_Pgi.ZoomOle          := FBoOldZoomOle;
  V_PGI.QRPDFQueue       := FStOldQRPDFQueue;
  V_PGI.DefaultDocCopies := FInDefaultDocCopies;
  V_PGI.QRPrinterIndex   := FInQRPrinterIndex;
  VH^.StopEdition        := False;

  FreeAndNil(FTobYParamEdition);

  inherited;
end;

////////////////////////////////////////////////////////////////////////////////

end.
