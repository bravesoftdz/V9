unit uEntCommun;

interface

uses HEnt1;

Const CodeISOFR = 'FR' ; //XMG 14/07/03
      CodeISOES = 'ES' ; //XMG 14/07/03
      CodeISOBE = 'BE';  //SDA le 27/12/2007 - Belgique
      MaxSousPlan = 6 ;
      MaxAxe  = 5 ;

const XmodeCreat = 1;
			XmodeMaj = 2;
			XmodeRemplace = 3;
Type
	TSousPlan = Record
              Code,Lib : String ;
              Debut,Longueur : Integer ;
              ListeSP : HTStringList ;
              End ;

  R_CLEDOC = RECORD
                NaturePiece,Souche : String3 ;
                DatePiece   : TDateTime ;
                NumeroPiece,NumLigne,NumOrdre : Integer ;
                Indice,NoPersp : integer ;
                UniqueBlo : integer;
             END ;
  {ne pas changer l'ordre des 5 premiers (axes)}
  TFichierBase = (fbAxe1,fbAxe2,fbAxe3,fbAxe4,fbAxe5,fbGene,fbAux,fbJal,fbBudGen,fbBudJal,
                     fbImmo,fbSect,fbCorresp,fbNatCpt,
                     fbBudSec1,fbBudSec2,fbBudSec3,fbBudSec4,fbBudSec5,
                     fbAxe1SP1,fbAxe1SP2,fbAxe1SP3,fbAxe1SP4,fbAxe1SP5,fbAxe1SP6,
                     fbAxe2SP1,fbAxe2SP2,fbAxe2SP3,fbAxe2SP4,fbAxe2SP5,fbAxe2SP6,
                     fbAxe3SP1,fbAxe3SP2,fbAxe3SP3,fbAxe3SP4,fbAxe3SP5,fbAxe3SP6,
                     fbAxe4SP1,fbAxe4SP2,fbAxe4SP3,fbAxe4SP4,fbAxe4SP5,fbAxe4SP6,
                     fbAxe5SP1,fbAxe5SP2,fbAxe5SP3,fbAxe5SP4,fbAxe5SP5,fbAxe5SP6,
                     fbRubrique,fbNone
                     ) ;
	TSousPlanAxe = Array[fbAxe1..fbAxe5,1..MaxSousPlan] Of TSousPlan ;

	TsetFichierBase = Set of TFichierBase ;

  TClesDocs = Array of R_CleDoc;
  Type T_TableDoc = (ttdPiece, ttdLigne, ttdLigneTarif, ttdPiedBase, ttdEche,
  									 ttdNomen, ttdLot, ttdAcompte, ttdPorc, ttdOuvrage, ttdLienOle,
                     ttdPieceAdr, ttdSerie, ttdretenuG, ttdBaseRg, ttdSit, ttdParDoc,
                     ttdAdresse, ttdRevision, ttdVariable, ttdLigneCompl, TtdLignePhase,
                     TTdRepartmill,ttdLigneBase,ttdOuvrageP,ttdLignefac,ttdVarDoc,ttdLigneMetre,
                     ttdPieceTrait,ttdTimbres,ttdLigneOUVP,ttdPieceInterv,ttdPieceDemPrix,TTdArticleDemPrix,
                     TtdDetailDemPrix,TtdFournDemprix);

  
implementation

end.




