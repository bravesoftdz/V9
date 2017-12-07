unit Recordcomsis;

interface
const
  Formatcol =
  '08%-10.10s%-10.10s%-10.10s%1.1s%-25.25s';

  Formatpar3 =
  '03%-14.14s%-4.4s%20.20s%-2.2s%1.1s%10.10s%1.1s%1.1s%1.1s%1.1s%1.1s%-2.2s%-20.20s'+
  '%1.1s%1.1s%1.1s%-2.2s%-2.2s%-1.1s%1.1s';

  Formatmvtsis =
  'E%-2.2s%-10.10s%-20.20s%-10.10s%1.1s%1.1s%-13.13s%-13.13s%-4.4s%-6.6s%-2.2s%-8.8s%-6.6s%1.1s%-10.10s%-6.6s%1.1s%-3.3s%-13.13s%-6.6s%1.1s%1.1s%-13.13s%-8.8s%-3.3s';

  Formatpar4 = '04%-6.6s%-6.6s%-2.2s%-8.8s%1s%-15.15s%1s%1s%1s';

  Formatjrl = '05%-2.2s%-20.20s%-10.10s%1.1s%1.1s%1.1s%1.1s%1.1s%5.5s%5.5s%11.11s%1.1s%1.1s%1.1s';


type

  ar_dossier = record
	  code,		// code '00'
	  dossier, 	        // n� dossier
	  date_debut,        // date de d�but
	  date_fin,	        // date de fin
	  archivage,         // type d'archivage (E, J, B, R)
          lg_cpt,            // longueur n� compte
          pre_mtp,         	// pr�cision des montants (2 si centimes)
          vers_file,         // version fichier : 05
	  vers_exe, 	        // version programme
          ecriture,          // taille du fichier
          format,		// format �dition : P ou G
          origine,           //origine du fichier pl = P, pme = M, Edificas =E
          monnaie : string;	//monnaie de tenue FRF ou EURO
        end;
  ar_par1 = record
	   code,              // code '01'
	   nom,
	   activite : string;
        end;
  ar_par2 = record
	   code,		// code '02'
	   adr1,
	   adr2,
	   adr3 : string;
        end;
  ar_par3 = record
	   code,		// code '03'
	   siret,
	   ape,
	   tel,
	   std,		        // n� du plan comptable standard
	   cre_cpt,	        // Controle cr�ation nouveau compte (O/N)
	   cpt_resul,	        // n� compte de r�sultat
	   ana,		        // gestion analytique (O/N)
	   stat,		// gestion statistique (O/N)
	   fournisseur,	        // 1er caract�re compte fournisseur
	   client,		// 1er caract�re compte client
	   format,		// format �dition : P ou G
	   lg_piece,	        // longueur n� piece
	   info,		// info. compl�mentaire fiche dossier
	   anouveau,            // indicateur d'anouveau
	   tva,
	   devise,              // GDEV gestion des devises
           v_numc,              // numero d'environnement pour fichier client associ�
           v_numf,              // numero d'environnement pour fichier fournisseur associ�
	   reper_ecr,
	   monnedit : string;	// �dition mention monnaie
        end;
  ar_par4 = record
	   code,		// code '04'
	   date_encours,
	   date_stop,
	   dex_prev,	        // dur�e exercice pr�c�dent
	   password,	        // mot de passe
	   typ,		// type du dossier
	   res_prev,	        // r�sultat de l'exercice pr�c�dent
	   reopen,		// indicateur de r�ouverture
	   cloture,	        // cloture
	   typ_reouv : string;	// type de r�ouverture : 0 pas d'op�ration
					//		 1 en solde
					//		 2 en d�tail
        end;
  ar_jour = record
	   code,		// code = 05
	   journal,	        // code journal
	   lib,		// libelle
	   cpt_aut,	        // num�ro de compte automatique
	   sens,		// sens deb ou cre
	   typ,		// type du journal
	   quan,		// traitement des quantites
	   echeance,	        //�ch�ances
           typconf,
	   ecart,		// ecart tol�r� sur la TVA
           banque,            // Num�ro de banque
           numcpte,           // Num�ro de compte bancaire
           dateimpu,          // Date d'imputation: (O)p�ration ou (V)aleur
	                        //'P'= par pi�ce 'N'= non 'O'= au niveau du folio
	   ecart_euro,
	   monnaie :string;
        end;

  ar_compte = record
	   code,		// code = 'C'
	   compte,	        // n� du compte
	   lib,		// libell� du compte
	   lettre,	        // lettrage auto ou non
	   sold_pro,           // solde progressif ou non
	   typ,		// type du compte
	   mtpdeb,	        // mtp deb exercice pr�c�dent
	   mtpcre,	        // mtp cre
	   taux,
	   tva,
	   monnaie : string
        end;


  ar_cjour = record
	   code,		// code = 'J'
	   journal,	        // code journal
	   lib,		        // libelle du journal
	   cpt_aut,	        // num�ro de compte automatique
	   sens,		// sens deb ou cre
	   typ,		        // type du journal
	   quan,		// traitement des quantites
	   echeance : string;	// �ch�ances
        end;
  ar_colreg = record
	code,		        // code = 08
	cpte,		        // n� compte collectif ou regroupement
	inf,		        // borne inf�rieure
	sup,		        // borne sup�rieure
	typ,		        // type 'C', 'F', 'R'
	libelle : string	// libell� du compte
        end;

  ar_ecr = record
	   code,		// code = 'E'
	   jour,		// jour de l'�criture
	   cpte,		// n� de compte de l'�criture
	   lib,		        // libell�
	   piece,		// n� de piece
	   lettre,		// indicateur de lettrage
	   extra,		// ecr extra-comptable
	   debit,		// mtp debit
	   credit,	        // credit
	   stat,		// code statistique
	   echeance,	        // date d'�ch�ance
	   mode,		// mode de r�glement
	   quan,		// quantit�
	   date_cre,	        // date de cr�ation de l'�criture
           topee,
	   Nocheque,
           date_rel,
           niv_rel,
           devise,
           mtdev,
           date_valeur,
	   suitelettre,       //2�me caract�re de lettrage
	   m_euro,	        //identifiant euro F ou E
	   mteuro,		//contrevaleur euro
	   identecr,		//identifiant pointant sur ecriture
	   autre_monn : string		//indicateur autre monnaie
				//			EUR=EURO, FRF=Franc pour une pr�cision
				//			de la nature debit, credit � blanc correspond
				//			� la monnaie tenue de l'exercice*/
        end;



implementation

end.
