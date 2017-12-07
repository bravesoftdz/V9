{***********UNITE*************************************************
Auteur  ...... :
Cr�� le ...... : 12/10/2005
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : STATGLOBALE ()
Mots clefs ... : TOF;STATGLOBALE
*****************************************************************}
Unit DPTOFSTATGLOBALE;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFNDEF EAGLCLIENT}
     db,
     dbtables,
     mul,
     Fe_Main,
{$else}
     MainEagl,
     eMul,
     uTob,
{$ENDIF}
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOF,
     extctrls,
     DPOutils,
     galOutil,
     galSystem,
     PgiAppli,
     Stat,
     HTB97;

Type
  TOF_STATGLOBALE = Class (TOF)
    procedure OnArgument (S : String ) ; override ;
   private
    SRequete0,SRequete1,SRequete2,SRequete3     : String;
    SRequete4,SRequete5,SRequete6,SRequete7     : String;
    SRequete8,SRequete9,SRequete10,SRequete11   : String;
    SRequete12,SRequete13,SRequete14,SRequete15 : String;
    SRequete16,SRequete17                       : String;

    procedure BLANCEDOSSIER_OnClick(Sender: TObject);
    procedure DOS_NODOSSIER_OnExit(Sender: TObject);
    procedure SANSGRPCONF_OnClick(Sender: TObject);
    procedure BCHERCHE_OnClick(Sender: TObject);
  end ;

//---------------------------------
//--- D�claration des proc�dures
//---------------------------------
procedure LancerStatGlobale;

Implementation

//---------------------------------------------------------
//--- Nom   : LancerStatGlobal
//--- Objet :
//---------------------------------------------------------
procedure LancerStatGlobale;
begin
 AGLLanceFiche('DP','TBSTATGlobale','','','');
end;

//---------------------------------------------------------
//--- Nom   : OnArgument
//--- Objet :
//---------------------------------------------------------
procedure TOF_STATGLOBALE.OnArgument (S : String ) ;
begin
 Inherited ;

{  SRequete:=  'SELECT * FROM DOSSIER '+
              'LEFT JOIN DPTABCOMPTA ON DOS_NODOSSIER=DTC_NODOSSIER '+
              'LEFT JOIN DPTABPAIE ON DOS_NODOSSIER=DTP_NODOSSIER '+
              ',ANNUAIRE '+
              'LEFT JOIN ANNUBIS ON ANN_GUIDPER=ANB_GUIDPER '+
              'LEFT JOIN L02_ENTDECLA ON ANN_GUIDPER=L02_GUIDPER '+
              'LEFT JOIN DPFISCAL ON ANN_GUIDPER=DFI_GUIDPER '+
              'LEFT JOIN DPORGA ON ANN_GUIDPER=DOR_GUIDPER '+
              'LEFT JOIN DPSOCIAL ON ANN_GUIDPER=DSO_GUIDPER '+
              'LEFT JOIN JURIDIQUE ON ANN_GUIDPER=JUR_GUIDPERDOS '+
              'LEFT JOIN DPCONTROLE ON ANN_GUIDPER=DCL_GUIDPER '+
              'LEFT JOIN TIERSCOMPL ON ANN_TIERS=YTC_TIERS '+
              'WHERE DOS_GUIDPER=ANN_GUIDPER'; }


// *** On repasse sur une solution ou l'on introduit tous les champs car en faisant SELECT *
// *** l'AGL interpr�te mal les champ du where DOG_GROUPECONF ET DOG_NODOSSIER et les insert
// *** dans le SELECT.

SRequete0 := 'SELECT '+
             'DOS_ABSENT,DOS_CABINET,DOS_DATEDEPART,DOS_DATERETOUR,DOS_DETAILMAJ,DOS_EWSCREE,'+ // $$$ JP 29/03/07 'DOS_ABSENT,DOS_CABINET,DOS_CODEPER,DOS_DATEDEPART,DOS_DATERETOUR,DOS_DETAILMAJ,DOS_EWSCREE,'+
             'DOS_GROUPECONF,DOS_GUIDPER,DOS_LASERIE,DOS_LIBELLE,DOS_NECDKEY,DOS_NECPDATEARRET,DOS_NECPSEQ,'+
             'DOS_NERECDATE,DOS_NERECNBFIC,DOS_NETEXPERT,DOS_NETEXPERTGED,DOS_NODISQUE,DOS_NODISQUELOC,'+
             'DOS_NODOSSIER,DOS_NOMBASE,DOS_PWDS1,DOS_SERIAS1,DOS_SOCIETE,DOS_TYPEMAJ,DOS_USRS1,DOS_UTILISATEUR,'+
             'DOS_VERROU,DOS_VERSIONBASE,'+
             //LM20070416 DOS_VERSIONSOC,
             'DTC_CA,DTC_DATEDEB,DTC_DATEFIN,DTC_DATESAISIE,DTC_DERNJOURNAL,DTC_DERNSAISIE,DTC_DUREE,'+
             'DTC_ENCOURSSAISIE,DTC_EXCEDBRUT,DTC_LIBEXERCICE,DTC_MARGETOTALE,DTC_MILLESIME,DTC_NBECRITURE,'+
             'DTC_NBENTREEIMMO,DTC_NBLIGNEIMMO,DTC_NBSORTIEIMMO,DTC_NODOSSIER,DTC_RESULTCOURANT,DTC_RESULTEXERC,'+
             'DTC_RESULTEXPLOIT,DTC_TOTACTIFBILAN,DTC_TOTPASSIFBILAN,DTC_UTILISATSAISIE,DTC_VALEURAJOUTEE,';

SRequete1 := 'DTP_DATEDEB,DTP_DATEFIN,DTP_DECALAGEPAIE,DTP_EFFECTIF,DTP_LIBEXERCICE,DTP_MILLESIME,'+
             'DTP_MODEREGL,DTP_MONTANTDADS,DTP_NBENTREES,DTP_NBSORTIES,DTP_NODOSSIER,ANN_ALBAT,ANN_ALCP,'+
             'ANN_ALESC,ANN_ALETA,ANN_ALNOAPP,ANN_ALRESID,ANN_ALRUE1,ANN_ALRUE2,ANN_ALRUE3,ANN_ALVILLE,'+
             'ANN_APCPVILLE,ANN_APNOM,ANN_APPAYS,ANN_APPMODIF,ANN_APRUE1,ANN_APRUE2,ANN_APRUE3,ANN_CAPDEV,'+
             'ANN_CAPITAL,ANN_CAPLIB,ANN_CAPLIBDTLIMITE,ANN_CAPLIBFRACTION,ANN_CAPNBTITRE,ANN_CAPVN,'+
             'ANN_CHGTADR,ANN_CLESIRET,ANN_CLETELEPHONE,ANN_CLETELEPHONE2,ANN_CODECJ,ANN_CODEINSEE,ANN_CODEINSTIT,'+
             'ANN_CODENAF,ANN_COMPLTNOADMIN,ANN_CONFIDENTIEL,ANN_COOP,ANN_CV,ANN_CVA,ANN_CVL,'+ // $$$ JP 29/03/07 'ANN_CODENAF,ANN_CODEPER,ANN_COMPLTNOADMIN,ANN_CONFIDENTIEL,ANN_COOP,ANN_CV,ANN_CVA,ANN_CVL,'+
             'ANN_DATECREATION,ANN_DATEMODIF,ANN_DATENAIS,ANN_DEBACT,ANN_DEPTNAIS,';

SRequete2 := 'ANN_DEVISE,ANN_EMAIL,ANN_ENSEIGNE,ANN_ETATCPTABLE,ANN_EVTFAMDATE,ANN_FAMPER,ANN_FAX,ANN_FORME,'+
             'ANN_FORMEGEN,ANN_FORMEGRPPRIVE,ANN_FORMESCI,ANN_FORMESTE,ANN_GRPCONF,ANN_GRPSOC,ANN_GUIDCJ,'+
             'ANN_GUIDPER,ANN_LANGUE,ANN_MINITEL,ANN_MOISCLOTURE,ANN_NATIONALITE,ANN_NATUREAUXI,'+
             'ANN_NBTITDIVPRIO,ANN_NOADMIN,ANN_NODEPTNAIS,ANN_NOIDENTIF,ANN_NOM1,ANN_NOM2,ANN_NOM3,'+
             'ANN_NOMPER,ANN_NOTEOUV,ANN_PAYS,ANN_PERASS1CODE,ANN_PERASS1GUID,ANN_PERASS1QUAL,ANN_PERASS2CODE,'+
             'ANN_PERASS2GUID,ANN_PERASS2QUAL,ANN_PPPM,ANN_PREPONDEIMMO,ANN_PROFESSION,ANN_RCS,ANN_RCSDATE,'+
             'ANN_RCSGEST,ANN_RCSNOREF,ANN_RCSVILLE,ANN_REGMAT,ANN_REGROUPEMENT,ANN_RM,ANN_RMANNEE,ANN_RMDEP,'+
             'ANN_RMNOREF,ANN_SEXE,ANN_SIREN,ANN_SITEWEB,ANN_SITUFAM,ANN_TEL1,ANN_TEL2,ANN_TIERS,ANN_TYPECIV,'+
             'ANN_TYPESCI,';//LM20070412

SRequete3 := 'ANN_TYPEPER,ANN_UTILISATEUR,ANN_VILLENAIS,ANN_VOIENO,ANN_VOIENOCOMPL,ANN_VOIENOM,ANN_VOIETYPE,'+
             'ANB_APPMODIF,ANB_BOOLLIBRE1,ANB_BOOLLIBRE2,ANB_BOOLLIBRE3,ANB_CHARLIBRE1,ANB_CHARLIBRE2,'+
             'ANB_CHARLIBRE3,ANB_CHOIXLIBRE1,ANB_CHOIXLIBRE2,ANB_CHOIXLIBRE3,ANB_COTISETNS,'+ // $$$ JP 29/03/07 'ANB_CHARLIBRE3,ANB_CHOIXLIBRE1,ANB_CHOIXLIBRE2,ANB_CHOIXLIBRE3,ANB_CODEPER,ANB_COTISETNS,'+
             'ANB_DATECREATION,ANB_DATELIBRE1,ANB_DATELIBRE2,ANB_DATELIBRE3,ANB_DATEMODIF,ANB_GESTIONFISC,'+
             'ANB_GESTIONPATRIM,ANB_GUIDPER,ANB_GUIDPERGRPINT,ANB_OLDCP,ANB_OLDRUE1,ANB_OLDRUE2,ANB_OLDRUE3,'+
             'ANB_OLDVILLE,ANB_OLDVOIENO,ANB_OLDVOIENOCOMPL,ANB_OLDVOIENOM,ANB_OLDVOIETYPE,ANB_UTILISATEUR,'+
             'ANB_VALLIBRE1,ANB_VALLIBRE2,ANB_VALLIBRE3,';

SRequete4 := 'L02_CREATEUR,L02_DATECREATION,L02_DATEMODIF,L02_EXERCICE,L02_GROUPECONF,'+ // $$$ JP 29/03/07 'L02_CODEPER,L02_CREATEUR,L02_DATECREATION,L02_DATEMODIF,L02_EXERCICE,L02_GROUPECONF,'+
             'L02_GUIDPER,L02_GUIDPERFILS,L02_GUIDPERPERE,L02_LIACLOTURE,'+ // $$$ JP 29/03/07 'L02_GUIDPER,L02_GUIDPERFILS,L02_GUIDPERPERE,L02_LIACLOTURE,L02_LIACODEPERFILS,'+
             'L02_LIACOMMENTAIRE,L02_LIACONTROLE,L02_LIADATECOMPTA,L02_LIADATEDEB,'+ // $$$ JP 29/03/07 'L02_LIACODEPERPERE,L02_LIACOMMENTAIRE,L02_LIACONTROLE,L02_LIADATECOMPTA,L02_LIADATEDEB,'+
             'L02_LIADATEDP,L02_LIADATEDPFILS,L02_LIADATEDPPERE,L02_LIADATEECHE,L02_LIADATEEDI,'+
             'L02_LIADATEEFFET,L02_LIADATEFIN,L02_LIADATEIMP,L02_LIAETATDECLA,L02_LIAETATEDI,'+
             'L02_LIALIBELLE,L02_LIALOGICIEL,L02_LIAMILLESIME,L02_LIAMT01,L02_LIAMT02,L02_LIAMT03,'+
             'L02_LIAMT04,L02_LIAMT05,L02_LIAMT06,L02_LIAMT07,L02_LIAMT08,L02_LIAMT09,L02_LIAMT10,'+
             'L02_LIANOMFILS,L02_LIANOMPERE,L02_LIANUMDECLA,L02_LIANUMVERSION,L02_LIAPERIODEDEB,';

SRequete5 := 'L02_LIAPERIODEFIN,L02_LIAREGIME,L02_LIATOPANNUAIRE,L02_LIATOPDP,L02_LIATOPEA,'+
             'L02_LIATOPIMMO,L02_LIATYPECOMPTA,L02_LIATYPETVA,L02_NODOSSIER,L02_UTILISATEUR,'+
             'DFI_ABATTEFIXE,DFI_ACPTEJUIN,DFI_ACTIVFISC,DFI_ACTIVTAXEPRO,DFI_ADHEREOGA,'+
             'DFI_ALLEGETRANS,DFI_ANNEECIVILE,DFI_AUTRESTAXES,DFI_BAFORFAIT,DFI_BENEFFISC,DFI_CA,'+
             'DFI_CAMIONSCARS,DFI_CLEINSPECT,DFI_CONTREVENUSLOC,DFI_CONTSOCSOLDOC,DFI_COTISMIN,'+
             'DFI_CTRLFISC,DFI_DATEADHOGA,DFI_DATEAPPORT,DFI_DATECONVTDFC,DFI_DATECREATION,'+
             'DFI_DATEDEBEXO,DFI_DATEDEBEXOTP,DFI_DATEFINEXO,DFI_DATEFINEXOTP,DFI_DATEMAJBENEF,'+
             'DFI_DATEMODIF,DFI_DATEOPTEXIG,DFI_DATEOPTRDSUP,DFI_DATEOPTREPORT,DFI_DATEOPTRG,'+
             'DOR_REGLEFISC,';//LM20070412

SRequete6 := 'DFI_DATEOPTRSS,DFI_DATEPRORTVA,DFI_DATEREGFUS,DFI_DECLA1003R,DFI_DECLARATION,'+
             'DFI_DEFICITORDIN,DFI_DEGREVTREDUC,DFI_DEMATERIATDFC,DFI_DISTRIBDIVID,DFI_DOMHORSFRANCE,'+
             'DFI_DROITSAPPORT,DFI_EXIGIBILITE,DFI_EXISTEPVLT,DFI_EXONERATION,DFI_EXONERATIONTP,'+
             'DFI_EXONERE,DFI_EXONERETP,DFI_FRANCPRECPT,DFI_GUIDPER,DFI_GUIDPEROGA,DFI_GUIDPERTETEGRD,'+
             'DFI_IMPODIR,DFI_IMPOINDIR,DFI_IMPSOLFORTUNE,DFI_INTEGRAFISC,DFI_JOURDECLA,DFI_MODEPAIEFISC,'+
             'DFI_MONDECLAEURO,DFI_MTTDEGREVTRED,DFI_NOADHOGA,DFI_NODOSSINSPEC,DFI_NOFRP,'+
             'DFI_NOINSPECTION,DFI_NOINTRACOMM,DFI_NOOGADP,DFI_NOREFTETEGRDP,DFI_OLDBENEFFISC,DFI_OLDCA,'+
             'DFI_OLDREDUC,DFI_OLDREINTEGR,DFI_OPTIONAUTID,DFI_OPTIONEXIG,DFI_OPTIONRDSUP,';

SRequete7 := 'DFI_OPTIONREPORT,DFI_OPTIONRISUP,DFI_OPTIONRSS,DFI_ORIGMAJBENEF,DFI_ORIGMAJCA,'+
             'DFI_PERIODIIMPIND,DFI_PRORATATVA,DFI_PRORTVAREVIS,DFI_REDEVABILITE,DFI_REDUC,'+
             'DFI_REGIMEINSPECT,DFI_REGIMFISCDIR,DFI_REGIMFUSION,DFI_REGLEMENTEURO,DFI_REINTEGR,'+
             'DFI_RESIDENT,DFI_RESULTFISC,DFI_TAUXTVA1,DFI_TAUXTVA2,DFI_TAUXTVA3,DFI_TAXEANNIMM,'+
             'DFI_TAXEFONCIERE,DFI_TAXEGRDSURF,DFI_TAXEPROF,DFI_TAXESALAIRES,DFI_TAXEVEHICSOC,'+
             'DFI_TETEGROUPE,DFI_TYPECA12,DFI_TYPETAXEPRO,DFI_TYPETAXETVA,DFI_UTILISATEUR,DFI_VIGNETTEAUTO,'+
             'DOR_ADHECOTI,DOR_ATTACHEMENT,DOR_BIENFAIS,DOR_BILLETERIE,DOR_CABINETASSOC,DOR_CATEGASSO,'+
             'DOR_CAUSERATTACH,DOR_COMPTESCONSO,DOR_CONVENTIONNE,DOR_DATECREAENT,DOR_DATECREATION,';

SRequete8 := 'DOR_DATEENTREECAB,DOR_DATEMODIF,DOR_DATESNIR,DOR_DATESUPPR,'+ //LM20070412 'DOR_DATEDEBUTEX,DOR_DATEENTREECAB,DOR_DATEFINEX,DOR_DATEMODIF,DOR_DATESNIR,DOR_DATESUPPR,'+
             'DOR_DEPENDANCE,DOR_DONATION,DOR_DONMANUEL,DOR_DONNATURE,DOR_DOSSREF,'+//LM20070412 'DOR_DEPENDANCE,DOR_DONATION,DOR_DONMANUEL,DOR_DONNATURE,DOR_DOSSREF,DOR_DUREE,DOR_DUREEPREC,'+
             'DOR_DUREEVIE,DOR_ETABLISSEMENT,DOR_ETABLTS,DOR_ETBLTSOINS,DOR_EXERCICE,DOR_FERME,DOR_FORMEASSO,'+
             'DOR_GUIDPER,DOR_HONORBNC,DOR_MOTIFNONTRAITE,DOR_MOTIFSUPPR,DOR_NBETABLTS,'+//LM20070412 'DOR_GUIDPER,DOR_HONORBNC,DOR_LOCAGERANCE,DOR_MOTIFNONTRAITE,DOR_MOTIFSUPPR,DOR_NBETABLTS,'+
             'DOR_NBRATTACH,DOR_NODOSSREF,DOR_NONTRAITE,DOR_NOREFPROPDP,DOR_ORIGINECLT,'+
             'DOR_ORIGINESNIR,DOR_PROBLEME,DOR_REGLEBNC,DOR_REMBTPARMBS,DOR_SALARPREP,'+ //LM20070412 'DOR_ORIGINESNIR,DOR_PROBLEME,DOR_REGLEBNC,DOR_REGLEFISC,DOR_REMBTPARMBS,DOR_SALARPREP,'+
             'DOR_SECTEURASSO,DOR_SECTIONBNC,DOR_SPECIALMED,DOR_SUBVENTION,DOR_TENUEEUROCPTA,'+
             'DOR_TENUEEUROGC,DOR_TENUEEUROPAIE,DOR_TYPEASSO,DOR_TYPEPROBLEME,'; //LM20070412 DOR_TYPESCI,';

SRequete9 := 'DOR_UTILCHEFGROUPE,DOR_UTILISATEUR,DOR_UTILRESPCOMPTA,DOR_UTILRESPJURID,DOR_UTILRESPSOCIAL,'+
             'DOR_VALEURSNIR,DOR_VALSNIRPREC,DOR_VTEPUBLI,DOR_WCATREVENUS,DOR_WETABENTITE,DOR_WNATUREATTEST,'+
             'DOR_WREGIMEIMPO,DOR_WREGIMETVA,DOR_WTYPEIMPO,DSO_ABATFRAISPRO,DSO_ACCORDS,DSO_BTP,DSO_CDD,DSO_CDI,'+
             'DSO_CE,DSO_CEC,DSO_CES,DSO_CIE,DSO_COMITEENT,DSO_CONTAPPRENT,DSO_CONTORIENT,DSO_CONTQUAL,'+
             'DSO_CONVENCOLLEC,DSO_CRE,DSO_CTRLSOC,DSO_DATECREATION,DSO_DATEDADS,DSO_DATEDEBEX,DSO_DATEDERPAIE,'+
             'DSO_DATEEFFECTIF,DSO_DATEEXSOC,DSO_DATEFINEX,DSO_DATEMODIF,DSO_DECLHANDICAP,DSO_DECLMO,DSO_DECUNEMB,'+
             'DSO_DELEGUEPERS,DSO_DELEGUESYND,DSO_EFFAPPRENTIS,DSO_EFFECTIF,DSO_EFFHANDICAP,DSO_EFFMOYEN,'+
             'DSO_ELTVARIAENT,DSO_EMBSAL1,DSO_EMBSAL23,DSO_EPARGNESAL,DSO_EXISTTICKREST,DSO_EXOCHARGES,';

SRequete10:= 'DSO_GESTCONGES,DSO_GESTIONETS,DSO_GUIDPER,DSO_INTERMSPEC,DSO_MTTDADS,DSO_MTTDAS2,'+
             'DSO_MUTSOCAGR,DSO_OLDEFFMOYEN,DSO_ORIGDADS,DSO_ORIGEFFECTIF,DSO_PAIEANALYTIQUE,'+
             'DSO_PAIEANNEESOC,DSO_PAIEAPPOINTS,DSO_PAIECAB,DSO_PAIEDECALEE,DSO_PAIEENT,DSO_PAIEENTSYS,'+
             'DSO_PAIEGENECRIT,DSO_PAIESTATS,DSO_PARTCONSTRUC,DSO_PARTFORMCONT,DSO_PARTICIPATION,'+
             'DSO_PERASSEDIC,DSO_PERIRC,DSO_PERURSSAF,DSO_PLANPAIEACT,DSO_PREVCOLLECT,DSO_PREVFAC,'+
             'DSO_REGPERS,DSO_REMBULLPAIE,DSO_RETCOLLECTIF,DSO_RETRAITEFAC,DSO_TAUXACCTRAV,'+
             'DSO_TAXEAPPRENT,DSO_TELEDADS,DSO_TICKETREST,DSO_TPSPARTIEL,'+
             'DSO_TPSPARTIEL30,DSO_TXSALPERIODIC,DSO_UTILISATEUR,DSO_VERSETRANS,';

SRequete11:= 'JUR_DATEDEBUTEX, JUR_DATEFINEX, JUR_DUREEEX, JUR_LOCAGERANCE, ' + //LM20070412
             'JUR_ACTIVREGL,JUR_AGESTATUT,JUR_AGMAJORITE,JUR_AGPROPPEE,JUR_AGQUORUM,JUR_AGREMCES,'+
             'JUR_AGREMCOM,JUR_AGREMDEC,JUR_APPELPUB,JUR_APPORT,JUR_ARCHIVE,JUR_ARD,JUR_AUGMCAPITAL,'+
             'JUR_BOOLLIBRE1,JUR_BOOLLIBRE2,JUR_BOOLLIBRE3,JUR_CAC,JUR_CAMAJORITE,JUR_CAPDEV,'+
             'JUR_CAPEURO,JUR_CAPITAL,JUR_CAQUORUM,JUR_CHARLIBRE1,JUR_CHARLIBRE2,JUR_CHARLIBRE3,'+
             'JUR_CHOIXLIBRE1,JUR_CHOIXLIBRE2,JUR_CHOIXLIBRE3,JUR_CODEDOS,JUR_COLL,'+ // $$$ JP 29/03/07 'JUR_CHOIXLIBRE1,JUR_CHOIXLIBRE2,JUR_CHOIXLIBRE3,JUR_CODEDOS,JUR_CODEPERDOS,JUR_COLL,'+
             'JUR_COMPTESCONSO,JUR_CONVREGLEM,JUR_CPTESBIL,JUR_CPTESCA,JUR_CPTESDIV,JUR_CPTESEFF,'+
             'JUR_DATEAGO,JUR_DATECAPITAL,JUR_DATECPTES,JUR_DATECREATION,JUR_DATEDEPOT,'+
             'JUR_DATEELEVNOMIN,JUR_DATELIBCAP,JUR_DATELIBRE1,JUR_DATELIBRE2,JUR_DATELIBRE3,';

SRequete12:= 'JUR_DATEMODIF,JUR_DATEPARUTION,JUR_DATEREPENG,JUR_DATESTAT,JUR_DATEXP,JUR_DEBACT,'+
             'JUR_DETAILPROPCAP,JUR_DOSLIBELLE,JUR_DTLIMINSCRIACT,JUR_DTMODIFSTAT,JUR_DUREE,'+
             'JUR_DURMANDADM,JUR_DURMANDDG,JUR_DURMANDGRT,JUR_DURMANDPCA,JUR_ELEVENOMIN,JUR_FORME,'+
             'JUR_GERNONPROP,JUR_GESTDRTSOCIAUX,JUR_GRP,JUR_GRPCONF,JUR_GRTSTAT,JUR_GUIDPERDOS,'+
             'JUR_IMPODIR,JUR_INFOSTAT,JUR_ISBAIL,JUR_KBIS,JUR_LIMAGEADM,JUR_LIMAGEADMPC,JUR_LIMAGEDG,'+
             'JUR_LIMAGEGRT,JUR_LIMAGEPCA,JUR_LIMLIEUAG,JUR_LIMLIEUAGTXT,JUR_LIQUID,JUR_LIQUIDDATE,'+
             'JUR_MOISCLOTURE,JUR_NATUREAUGM,JUR_NATUREGERANCE,JUR_NBADMIN,JUR_NBADMIN3ANS,'+
             'JUR_NBADMINCT,JUR_NBADMINDG,JUR_NBADMINPDG,JUR_NBADMMAX,JUR_NBADMMIN,JUR_NBAGEATTEINT,';

SRequete13:= 'JUR_NBASSMAX,JUR_NBASSMIN,JUR_NBCAC,JUR_NBCCT,JUR_NBCONVREGLEM,JUR_NBDGMAX,JUR_NBDGMIN,'+
             'JUR_NBDROITSVOTE,JUR_NBGRTMAX,JUR_NBGRTMIN,JUR_NBPROPCAP,JUR_NBTITRESAUGM,JUR_NBTITRESCLOT,'+
             'JUR_NBTITRESGER,JUR_NBTITRESOUV,JUR_NBTITRESRED,JUR_NOMDOS,JUR_NOMPER,JUR_NOTEOUV,'+
             'JUR_NOUVNOMIN,JUR_NREDG,JUR_NRESTAT,JUR_NUMSTATDURSOC,JUR_ORGDIRECTION,JUR_POUVTRFSS,'+
             'JUR_PREMEX,JUR_PRTASUIVRE,JUR_PRTDATEAG,JUR_PRTRECONST,JUR_RANGEMENT,JUR_RCSDATE,'+
             'JUR_RCSGEST,JUR_REDRESS,JUR_REPDOC,JUR_RESP,JUR_STATBORDENR,JUR_STATDATEENR,'+
             'JUR_STATLIEUENR,JUR_SUIVISOC,JUR_TTNBMINADM,JUR_TTNBMINASS,JUR_TTPART1,JUR_TTPART1TXT,'+
             'JUR_TTPART2,JUR_TTPART2TXT,JUR_TTPART3,JUR_TTPART3TXT,JUR_TYPEACTIV,JUR_TYPEGERANCE,';

SRequete14:= 'JUR_UTILISATEUR,JUR_VALLIBRE1,JUR_VALLIBRE2,JUR_VALLIBRE3,JUR_VALNOMINCLOT,JUR_VALNOMINOUV,JUR_VOIXPREP,'+
             'DCL_DATECREATION,DCL_DATEFINREDR,DCL_DATEMODIF,DCL_DATENOTIF,DCL_DATEPAIEMENT,DCL_DETAILCTRL,'+
             'DCL_ETATREDR,DCL_EXERCDEB,DCL_EXERCFIN,DCL_GUIDPER,DCL_NATUREREDR,DCL_NOORDRE,'+
             'DCL_NOREFORG,DCL_REDRACCEPT,DCL_REDRENVISAG,DCL_TYPECTRL,DCL_UTILISATEUR,DCL_VERIFICATEUR,'+
             'YTC_ACCELERATEUR,YTC_AUTOEDITETIQ,YTC_AUTOEDITOT,YTC_AUTOGENEPRIVE,YTC_AUXILIAIRE,'+
             'YTC_AVANTAGE,YTC_BOOLLIBRE1,YTC_BOOLLIBRE2,YTC_BOOLLIBRE3,YTC_CODECATA,YTC_CODEPORT,'+
             'YTC_CODEPRODTRA,YTC_COMMSPECIAL,YTC_DAS2,YTC_DATELIBRE1,YTC_DATELIBRE2,YTC_DATELIBRE3,'+
             'YTC_DATELIBREFOU1,YTC_DATELIBREFOU2,YTC_DATELIBREFOU3,YTC_DEPOT,YTC_DOCDATEDELIV,';

SRequete15:= 'YTC_DOCDATEEXPIR,YTC_DOCIDENTITE,YTC_DOCOBSERV,YTC_DOCORIGINE,YTC_EDITRA,'+
             'YTC_ETABLISSEMENT,YTC_FAMREG,YTC_INCOTERM,YTC_INDEMNITE,YTC_LIEUDISPO,YTC_MODEEXP,'+
             'YTC_MODELE,YTC_MODELEBON,YTC_MODELETXT,YTC_NADRESSEFAC,YTC_NADRESSELIV,'+
             'YTC_NOTRECODCOMPTA,YTC_NOTRECODETIERS,YTC_PALMARESTRA,YTC_PATHFICPRIVE,YTC_PROFESSION,'+
             'YTC_QUALIFLINEAIRE,YTC_QUALIFPOIDS,YTC_QUALIFVOLUME,YTC_REMUNERATION,YTC_REPRESENTANT2,'+
             'YTC_REPRESENTANT3,YTC_RESSOURCE1,YTC_RESSOURCE2,YTC_RESSOURCE3,YTC_SCHEMAGEN,'+
             'YTC_SECTEURGEO,YTC_SOUCHEOT,YTC_STATIONEDI,YTC_SURTAXE,YTC_TABLELIBREFOU1,'+
             'YTC_TABLELIBREFOU2,YTC_TABLELIBREFOU3,YTC_TABLELIBRETIERS1,YTC_TABLELIBRETIERS2,';

SRequete16:= 'YTC_TABLELIBRETIERS3,YTC_TABLELIBRETIERS4,YTC_TABLELIBRETIERS5,YTC_TABLELIBRETIERS6,'+
             'YTC_TABLELIBRETIERS7,YTC_TABLELIBRETIERS8,YTC_TABLELIBRETIERS9,YTC_TABLELIBRETIERSA,'+
             'YTC_TARIFSPECIAL,YTC_TAUXREPR1,YTC_TAUXREPR2,YTC_TAUXREPR3,YTC_TEXTELIBRE1,'+
             'YTC_TEXTELIBRE2,YTC_TEXTELIBRE3,YTC_TIERS,YTC_TIERSEXPE,YTC_TIERSLIVRE,YTC_TIMBRE,'+
             'YTC_TYPEECHANGE,YTC_TYPEFOURNI,YTC_VALLIBRE1,YTC_VALLIBRE2,YTC_VALLIBRE3,YTC_VALLIBREFOU1,';

SRequete17:= 'YTC_VALLIBREFOU2,YTC_VALLIBREFOU3 FROM DOSSIER '+
             'LEFT JOIN DPTABCOMPTA ON DOS_NODOSSIER=DTC_NODOSSIER '+
             'LEFT JOIN DPTABPAIE ON DOS_NODOSSIER=DTP_NODOSSIER , ANNUAIRE '+
             'LEFT JOIN ANNUBIS ON ANN_GUIDPER=ANB_GUIDPER '+
             'LEFT JOIN L02_ENTDECLA ON ANN_GUIDPER=L02_GUIDPER '+
             'LEFT JOIN DPFISCAL ON ANN_GUIDPER=DFI_GUIDPER '+
             'LEFT JOIN DPORGA ON ANN_GUIDPER=DOR_GUIDPER '+
             'LEFT JOIN DPSOCIAL ON ANN_GUIDPER=DSO_GUIDPER '+
             'LEFT JOIN JURIDIQUE ON ANN_GUIDPER=JUR_GUIDPERDOS '+
             'LEFT JOIN DPCONTROLE ON ANN_GUIDPER=DCL_GUIDPER '+
             'LEFT JOIN TIERSCOMPL ON ANN_TIERS=YTC_TIERS WHERE DOS_GUIDPER=ANN_GUIDPER ';

 //--- Filtrage/positionnement
 InitialiserComboGroupeConf (THMultiValCombobox(GetControl('GROUPECONF')));

 //--- Initialisation de la multiValCombobox LISTEAPPLICATION
 if THMultiValComboBox (GetControl ('ListeApplication'))<>Nil then
  InitialiserComboApplication (THMultiValComboBox (GetControl ('LISTEAPPLICATION')));

 TToolBarButton97(GetControl('BCHERCHE')).OnClick := BCHERCHE_OnClick;
 TToolBarButton97(GetControl('bLanceDossier')).OnClick := BLANCEDOSSIER_OnClick;
 THCritMaskEdit(GetControl('DOS_NODOSSIER')).OnExit := DOS_NODOSSIER_OnExit;
 TCheckbox(GetControl('SANSGRPCONF')).OnClick := SANSGRPCONF_OnClick;

 AfficheLibTablesLibres(Self);

 TFStat(Ecran).FiltreDisabled:=True ;
end ;

//---------------------------------------------------------
//--- Nom   : BLANCEDOSSIER_OnClick
//--- Objet :
//---------------------------------------------------------
procedure TOF_STATGLOBALE.BLANCEDOSSIER_OnClick(Sender: TObject);
var St,NumDossier : String;
begin
 St := AGLLanceFiche('YY','YYDOSSIER_SEL', '','',GetControlText ('DOS_NODOSSIER'));
 if St<>'' then
  begin
   NumDossier:=READTOKENST(St);
   SetControlText ('DOS_NODOSSIER',NumDossier);
   SetControlText ('DOS_NODOSSIER_',NumDossier);
  end;
end;

//---------------------------------------------------------
//--- Nom   : DOS_NODOSSIER_OnExit
//--- Objet :
//---------------------------------------------------------
procedure TOF_STATGLOBALE.DOS_NODOSSIER_OnExit(Sender: TObject);
var nodoss: String;
begin
  nodoss := GetControlText('DOS_NODOSSIER');
  if nodoss = '' then exit;
  if not IsNoDossierOk (nodoss) then
    begin
    PgiInfo('Le num�ro de dossier n''est pas correct (uniquement majuscules ou chiffres).', TitreHalley);
    SetFocusControl('DOS_NODOSSIER');
    exit;
    end;
end;

procedure TOF_STATGLOBALE.SANSGRPCONF_OnClick(Sender: TObject);
begin
  GereCheckboxSansGrpConf(TCheckbox(GetControl('SANSGRPCONF')), THMultiValCombobox(GetControl('GROUPECONF')) );
end;

//---------------------------------------------------------
//--- Nom   : BCHERCHE_OnClick
//--- Objet :
//---------------------------------------------------------
procedure TOF_STATGLOBALE.BCHERCHE_OnClick(Sender: TObject);
var SMessage,s  : String;
begin
 Inherited ;
 SMessage:='Le temps de calcul pour afficher cet �cran peut �tre important... '+#10+#13+
           ' Voulez-vous continuer ?';
 if (PGIAsk (SMessage,TitreHalley))=MrYes then
  begin
   TFStat(Ecran).FSQL.Lines.Clear;
   TFStat(Ecran).FSQL.Lines.add(SRequete0);
   TFStat(Ecran).FSQL.Lines.add(SRequete1);
   TFStat(Ecran).FSQL.Lines.add(SRequete2);
   TFStat(Ecran).FSQL.Lines.add(SRequete3);
   TFStat(Ecran).FSQL.Lines.add(SRequete4);
   TFStat(Ecran).FSQL.Lines.add(SRequete5);
   TFStat(Ecran).FSQL.Lines.add(SRequete6);
   TFStat(Ecran).FSQL.Lines.add(SRequete7);
   TFStat(Ecran).FSQL.Lines.add(SRequete8);
   TFStat(Ecran).FSQL.Lines.add(SRequete9);
   TFStat(Ecran).FSQL.Lines.add(SRequete10);
   TFStat(Ecran).FSQL.Lines.add(SRequete11);
   TFStat(Ecran).FSQL.Lines.add(SRequete12);
   TFStat(Ecran).FSQL.Lines.add(SRequete13);
   TFStat(Ecran).FSQL.Lines.add(SRequete14);
   TFStat(Ecran).FSQL.Lines.add(SRequete15);
   TFStat(Ecran).FSQL.Lines.add(SRequete16);
   TFStat(Ecran).FSQL.Lines.add(SRequete17);
   s := GererCritereGroupeConf (THMultiValCombobox(GetControl('GROUPECONF')),TcheckBox (GetControl ('SANSGRPCONF')).Checked) ;
   if s<>'' then TFStat(Ecran).FSql.Lines.add(' and ' + s ) ;//LM20060416
   TFStat(Ecran).FSql.Lines.add(GererCritereApplication (THMultiValComboBox (GetControl ('LISTEAPPLICATION'))));
   TFStat(Ecran).FSql.Lines.add(GererCritereDivers ());
   TFStat(Ecran).BChercheClick (Self);
  end;
end;

Initialization
  registerclasses ( [ TOF_STATGLOBALE ] ) ;
end.

