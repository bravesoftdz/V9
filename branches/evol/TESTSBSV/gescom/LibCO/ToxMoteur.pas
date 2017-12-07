unit ToxMoteur;

interface

uses {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} Hctrls, SysUtils, uTob, StdCtrls, Dialogs, FactComm,
     FactUtil, FactCpta, SaisUtil, HEnt1, FactNomen, ToxIntegre, ToxMessage,
{$IFNDEF FOS5}
     ToxCash2000,
{$ENDIF}
     UtoxClasses, ParamSoc, Windows;

    
/////////////////////////////////////////////////////////////////////////////////
// Variables Globales
/////////////////////////////////////////////////////////////////////////////////
var NbEnreg    : integer ;
    NbEnregTop : integer ;
    NbMessErr  : integer ;
    IndiceTob  : integer ;
    TobMessage : TOB     ;

////////////////////////////////////////////////////////////////////////////////
// Statuts de la TOX
////////////////////////////////////////////////////////////////////////////////
const   ToxRejeter     = -1 ;
        ToxIntegrer    =  0 ;
        ToxARetraiter  =  1 ;

        BadFormatEvents = -1 ;
        BadFormatCondit = -2 ;
        BadFormatTable  = -3 ;

//////////////////////////////////////////////////////////////////////////////////////////////
// Prototyting des fonctions g�n�riques de la TOX
//
//             TraitementDeLaTox      : fonction g�n�rique de traitement d'uneTOX
//             DetopageDeLaTox        : d�topage d'une TOX
//             ConsulteMessageDeLaTox : consultation des messages d'int�gration dans un TMemo
//             ChargeMessageDeLaTox   : charge les messages d'int�gration et d'erreur
//                                      dans une TOB hierarchis�e des messages
/////////////////////////////////////////////////////////////////////////////////////////////////
function  TraitementDeLaTox       (var Tox : TOB; CpteRendu : Tmemo; AfficheMessage : boolean; AfficheDonnee : boolean ; AfficheErreur : boolean ; IntegrationRapide : boolean ; MajStock : boolean; sDevise : string; sBasculeEuro : boolean) : integer ;
function  DetopageDeLaTox         (var Tox : TOB; CpteRendu : Tmemo) : integer ;
procedure ConsulteMessageDeLaTox  (var Tox : TOB; CpteRendu : Tmemo; AffDonneeIntegree, AffDonneeRejetee : boolean ) ;
procedure ChargeMessageDeLaTox    (var Tox, TobMessAff : TOB; Integre, Rejet : boolean; Var Nbenr, NbErr : integer );
procedure AvantArchivageTox       (Tox : TOB; var ArchivageTox : boolean);

implementation


///////////////////////////////////////////////////////////////////////////////////////
// Topage/D�topage d'une unit� transactionnelle TOX
//
// Rappel : 1 - Unit� Transactionnelle = Plusieurs enregistrements TOX rattach�s
//              Exemple : Ent�te PIECE + LIGNE
//          2 - Le topage se fait sur le champ suppl�mentaire TOX_RESULT :
//                        -> ' ' ou '' pas trait�
//                        -> 'T' en cours de traitement
//                        -> 'R' rejet�
//                        -> 'I' int�gr�
//          3 - Le num�ro d'erreur est stock� dans le champ suppl�mentaire TOX_ERREUR
//
// !!!!!!!!!!!!!!!!!!!!!! Attention : Proc�dure r�cursive !!!!!!!!!!!!!!!!!!!!!!
//
///////////////////////////////////////////////////////////////////////////////////////
procedure TopageUniteTransactionnelle (var ToxInfo : TOB; Top : string );
var ToxTableNext    : TOB	   ;
    ToxInfoNext     : TOB    ;
    NomTableNext    : string ;
    i, j            : integer;
begin

  if ToxInfo.FieldExists ('TOX_RESULT') then
  begin
    Inc ( NbEnregTop ) ;
    //
    // Topage de l'enregistrement Ent�te
    //
    ToxInfo.PutValue ('TOX_RESULT', Top);

    //
    // Topage des enregistrements rattach�s = Tob filles
    //
    for i:=0 to ToxInfo.Detail.Count-1 do
    begin
      ToxTableNext:=ToxInfo.Detail[i];
      if (ToxTableNext.FieldExists('TOX_TABLE')) then
      begin
        NomTableNext := ToxTableNext.GetValue ('TOX_TABLE');
        for j:=0 to ToxTableNext.Detail.Count-1 do
	   	  begin
		      ToxInfoNext := ToxTableNext.Detail[j];
    	    TopageUniteTransactionnelle (ToxInfoNext, Top);
    	  end;
      end;
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////////////
// Topage d'un enregistrement TOX
///////////////////////////////////////////////////////////////////////////////////////
procedure TopageToxEnreg (var ToxInfo : TOB; Integre : boolean ; Erreur : integer) ;
begin

  ToxInfo.PutValue ('TOX_ERREUR', Erreur);

  if not Integre then
  begin
    if Erreur = IntegOK then ToxInfo.PutValue ('TOX_RESULT', 'T')
    else                     ToxInfo.PutValue ('TOX_RESULT', 'R');
  end
  else begin
    if Erreur = IntegOK then ToxInfo.PutValue ('TOX_RESULT', 'I')
    else                     ToxInfo.PutValue ('TOX_RESULT', 'R');
  end;
end;

///////////////////////////////////////////////////////////////////////////////////////
// D�topage de la TOX
///////////////////////////////////////////////////////////////////////////////////////
function DetopageDeLaTox (var Tox : TOB; CpteRendu : Tmemo) : integer ;
var ToxCondition : TOB 		;
		ToxTable0		 : TOB		;
    ToxInfo0		 : TOB		;
    i,j,k				 : integer;
begin

  result := ToxIntegrer ;
  //
	// TOX MERE CONTENANT LE NOM DE L'EVENEMENT
  //
  if (Tox.FieldExists('EVENEMENT')) then
  begin
    CpteRendu.lines.add('   D�but du d�topage le ' + DateToStr(Date) + ' � ' + TimeToStr(Time));
    NbEnregTop := 0 ;

    for i:=0 to Tox.Detail.Count-1 do
    begin
  	  //
      // TOX CONDITION CONTENANT LA CONDITION
      //
      ToxCondition:=Tox.Detail[i];

      if (ToxCondition.FieldExists('CONDITION')) then
      begin
        for j:=0 to ToxCondition.Detail.Count-1 do
        begin
          //
    	    // TOX TABLE Niveau 0
    	    //
          ToxTable0:=ToxCondition.Detail[j];

          if (ToxTable0.FieldExists('TOX_TABLE')) then
  		    begin
            for k:=0 to ToxTable0.Detail.Count-1 do
            begin
              ToxInfo0 := ToxTable0.Detail[k];
              TopageUniteTransactionnelle (ToxInfo0, 'T');
            end;
  		    end else
          begin
            CpteRendu.lines.add('   Le format de la TOX est incorrect : Nom de la table de niveau 0 n''est pas renseign�');
            result := ToxRejeter ;
            exit ;
          end;
        end;
      end else
      begin
        CpteRendu.lines.add('   Le format de la TOX est incorrect : Pas de nom de condition');
        result := ToxRejeter ;
        exit;
      end;
    end;

    CpteRendu.lines.add('     -> ' + IntToStr (NbEnregTop)  + ' enregistrements trait�s ');
    CpteRendu.lines.add('   Fin du d�topage le ' + DateToStr(Date) + ' � ' + TimeToStr(Time));

  end else
  begin
    CpteRendu.lines.add('   Le format de la TOX est incorrect : Pas de nom d''�v�nement');
    result := ToxRejeter ;
  end;
end;

///////////////////////////////////////////////////////////////////////////////////////
// Descriptif des informations int�gr�es
// Param�tres     1 - NomTable          Nom de la table en cours de traitement
//                2 - ToxInfo           Information en cours d'int�gration = TOB
//                3 - MessErreur        Num�ro d'erreur.
//                                      Erreur > 0      Erreur d'int�gration
//                                      Erreur = 0      Enregistrement int�gr�
//                                      Erreur = -1     Message d'int�gration
//                4 - CpteRendu         TMemo servant d'affichage �cran
///////////////////////////////////////////////////////////////////////////////////////
procedure EditeInfoMessage (NomTable : string; ToxInfo : TOB; MessErreur : integer; CpteRendu : TMemo);
var MessageInfo : string;
begin
  MessageInfo := ToxEditeMessage (NomTable, ToxInfo, MessErreur);
  if (MessageInfo<>'') then
  begin
    if MessErreur = -1 then CpteRendu.lines.add('       ' + MessageInfo)
    else CpteRendu.lines.add('           -> ' + MessageInfo);
  end;
end;

///////////////////////////////////////////////////////////////////////////////////////
// Fonction appelant les fonctions de contr�les ou d'int�gration des �l�ments TOX
// Valeur retourn�e :	 	0 Pas d'erreur
//											1 Erreur lors des contr�les ou lors des MAJ
//
// Remarque : Seuls les enregistrements non trait�s ou en erreur sont pris en compte.
///////////////////////////////////////////////////////////////////////////////////////
function ControleInfo (NomTable : string; var ToxInfo : TOB; Integre : boolean ; CpteRendu : TMemo ; AfficheDonnee : boolean; AfficheErreur : Boolean ; IntegrationRapide : boolean ; MajStock : boolean ; sDevise : string; sBasculeEuro : boolean; TobDev : TOB; CodeSite : string) : integer ;
var EtatEnreg : string ;
    Erreur    : integer ;
begin
  Result := 0 ;

  EtatEnreg := Trim(ToxInfo.GetValue ('TOX_RESULT'));

  if (EtatEnreg = '') or (EtatEnreg = 'R') or (EtatEnreg = 'T') then
  begin
    if Integre = False then inc (NbEnreg);
    //
    // Contr�le et import de l'enregistrement courant
    //
    Erreur := ToxControleInfo (NomTable, ToxInfo, Integre, IntegrationRapide, MajStock, sDevise, sBasculeEuro, TobDev, CodeSite);
    //
    // Topage de l'enregistrement trait�
    //
    TopageToxEnreg (ToxInfo, Integre, Erreur);
    //
    // Affichage de l'information int�gr�e
    //
    if (AfficheDonnee) and (Not Integre) then	EditeInfoMessage (Nomtable, ToxInfo, -1, CpteRendu);
    //
    // Affichage de l'erreur
    //
     if Erreur <> 0	then
    begin
      if (AfficheErreur) then EditeInfoMessage (Nomtable, ToxInfo, Erreur, CpteRendu);
      result := 1;
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////////////
// Fonction de balayage d'une TOX
//
//    -> Cr�ation s'il y a lieu des champs suppl�mentaires de topage des TOX
//		-> Balayage de la TOX et appel des fonctions de contr�les et d'int�gration d'une unit� fonctionnelle
//		-> Retourne le nombre total d'erreurs rencontr�es pour l'unit� transactionnelle
//
// !!!!!!!!!!!!!!!!!!!!!!!!! Attention : Fonction r�cursive !!!!!!!!!!!!!!!!!!!!!!!!!!
//
///////////////////////////////////////////////////////////////////////////////////////
function ControleTox (var NomTable : string; var ToxInfo : TOB; Integre : boolean ; CpteRendu : TMemo; AfficheDonnee : boolean ; AfficheErreur : boolean ; IntegrationRapide : boolean ; MajStock : boolean; sDevise : string; sBasculeEuro : boolean; TobDev : TOB; CodeSite : string) : integer ;
var ToxTableNext    : TOB	   ;
    ToxInfoNext     : TOB    ;
    NomTableNext    : string ;
    i, j            : integer;
    Erreur          : integer;
    ErreurMAJDoc    : integer;
begin
  ErreurMAJDoc := 0;
  //
  // Ajout des champs sp�cifiques "TOX_RESULT" et "TOX_ERREUR"
  //
  if not ToxInfo.FieldExists ('TOX_RESULT') then
  begin
       ToxInfo.AddChampSup ('TOX_RESULT', False);
       ToxInfo.AddChampSup ('TOX_ERREUR', False);
       ToxInfo.PutValue    ('TOX_RESULT', ' ');
       ToxInfo.putValue    ('TOX_ERREUR',  0 );
  end;
  //
  // Traitement de l'enregistrement ent�te
  //
  Erreur := ControleInfo (NomTable, ToxInfo, Integre, CpteRendu, AfficheDonnee, AfficheErreur, IntegrationRapide, MajStock, sDevise, sBasculeEuro, TobDev, CodeSite);
  //
  // Traitement des niveaux inf�rieurs
  //
  for i:=0 to ToxInfo.Detail.Count-1 do
  begin
    //
 	  // TOX TABLE SUIVANTE
    //
    ToxTableNext:=ToxInfo.Detail[i];

    if (ToxTableNext.FieldExists('TOX_TABLE')) then
    begin
      NomTableNext := ToxTableNext.GetValue ('TOX_TABLE');
      for j:=0 to ToxTableNext.Detail.Count-1 do
	   	begin
   	      ToxInfoNext := ToxTableNext.Detail[j];
    	  Erreur      := Erreur + ControleTox (NomTableNext, ToxInfoNext, Integre, CpteRendu, AfficheDonnee, AfficheErreur, IntegrationRapide, MajStock, sDevise, sBasculeEuro, TobDev, CodeSite);
    	end;
    end
    else begin
      if AfficheErreur then CpteRendu.lines.add('   Le format de la TOX est incorrect : Nom de la table n''est pas renseign�');
      Inc (Erreur);
      break;
    end;
  end;
  //
  // Int�gration sp�cifique des pi�ces : Tout doit �tre charg� en TOB pour pouvoir int�grer une pi�ce
  //                                     avec MAJ des stocks .....
  if (NomTable = 'PIECE') AND Integre AND (Erreur = 0) then
  begin
    if AfficheDonnee then CpteRendu.lines.add('       -> Import du document dans la base');

    try
      BeginTrans;
      ErreurMAJDoc := ImportDocument(MajStock, sDevise, sBasculeEuro, TobDev) ;
      CommitTrans ;
    except
      RollBack;
    end;

    if (AfficheErreur) and (ErreurMAJDoc <> 0)	then
    begin
      EditeInfoMessage (Nomtable, ToxInfo, ErreurMAJDoc, CpteRendu);
      Inc (Erreur);
    end;
  end;

  result:=Erreur;
end;

 ///////////////////////////////////////////////////////////////////////////////////////
// Fonctions g�n�riques de traitement d'une TOX
///////////////////////////////////////////////////////////////////////////////////////
function TraitementDeLaTox (var Tox : TOB; CpteRendu : Tmemo; AfficheMessage : boolean; AfficheDonnee : boolean ; AfficheErreur : boolean ; IntegrationRapide : boolean ;  MajStock : boolean; sDevise : string; sBasculeEuro : boolean) : integer ;
var ToxCondition : TOB 		;
	ToxTable0	 : TOB		;
    ToxInfo0	 : TOB		;
    TobDevise    : TOB    ;
    Q            : TQUERY ;
    NomTable0	 : string	;
    CodeSite     : string ;
    NbErreur	 : integer;
    NbErreurDB   : integer;
    NbErr        : integer;
    NbEnrTotal   : integer;
    NbErrTotal   : integer;
    NbErrDBTotal : integer;
    i,j,k				 : integer;
begin
  //
  // Chargement de la TOB des devises permettant de convertir les montants en devise
  //
  TobDevise := TOB.Create('LES DEVISES', Nil, -1) ;
  Q         := OpenSQL('SELECT * FROM DEVISE',True) ;
  TobDevise.LoadDetailDB('DEVISE','','',Q,False) ;
  Ferme(Q) ;

  result := ToxIntegrer ;
  //
	// TOX MERE CONTENANT LE NOM DE L'EVENEMENT
  //
  if (Tox.FieldExists('EVENEMENT')) then
  begin
    if Tox.FieldExists('SITE-EMETTEUR') then CodeSite := Tox.Getvalue('SITE-EMETTEUR')
    else CodeSite := '';

    NbEnrTotal   := 0;
    NbErrTotal   := 0;
    NbErrDBTotal := 0;

    if AfficheMessage then
    begin
      CpteRendu.lines.add('   D�but de l''int�gration le ' + DateToStr(Date) + ' � ' + TimeToStr(Time));
      if CodeSite <> '' then CpteRendu.lines.add('   Code du site �metteur : ' + CodeSite);
      CpteRendu.lines.add ('   Ev�nement '+Tox.GetValue ('EVENEMENT'));
    end;

    for i:=0 to Tox.Detail.Count-1 do
    begin
  	  //
      // TOX CONDITION CONTENANT LA CONDITION
      //
      ToxCondition:=Tox.Detail[i];
      if (ToxCondition.FieldExists('CONDITION')) then
      begin
        if AfficheMessage then
        begin
          CpteRendu.lines.add(' ');
          CpteRendu.lines.add('   Requ�te '+Toxcondition.GetValue ('CONDITION'));
        end;

        for j:=0 to ToxCondition.Detail.Count-1 do
        begin
          //
    	    // TOX TABLE Niveau 0
    	    //
          ToxTable0:=ToxCondition.Detail[j];

          if (ToxTable0.FieldExists('TOX_TABLE')) then
  		    begin
            NomTable0  := ToxTable0.GetValue ('TOX_TABLE');			// Nom de la table principale
						NbErreur   := 0; NbErreurDB := 0; NBEnreg := 0; NbEnregTop := 0 ;

            if AfficheDonnee then
            begin
              CpteRendu.lines.add('   '); CpteRendu.lines.add('   Table principale : ' + NomTable0);
            end;

            for k:=0 to ToxTable0.Detail.Count-1 do
  					begin
              //
              // Contr�le l'unit� transactionnelle (integration = FALSE)
              //
              ToxInfo0 := ToxTable0.Detail[k];
              NbErr    := ControleTox (NomTable0, ToxInfo0, FALSE, CpteRendu, AfficheDonnee, AfficheErreur, IntegrationRapide, MajStock, sDevise, sBasculeEuro, TobDevise, CodeSite);
              //
              // Si pas d'erreur, int�gration de l'unit� transactionnelle (Int�gration = TRUE)
              // Sinon, topage de l'unit� transactionnelle � 'R'
              //
        	  	if NbErr = 0 then
              begin
                NbErreurDB := NbErreurDB + ControleTox (NomTable0, ToxInfo0, TRUE, Cpterendu, AfficheDonnee, AfficheErreur, IntegrationRapide, MajStock, sDevise, sBasculeEuro, TobDevise, CodeSite);
                // MODIF LM 25/02/03 LACOSTE - G�re le plantage lors de la MAJ DB
                if NbErreurDB <>0 then TopageUniteTransactionnelle (ToxInfo0, 'R');
              end else
              begin
                TopageUniteTransactionnelle (ToxInfo0, 'R');
                NbErreur := NbErreurDB + Nberr;
              end;
            end;
            NbEnrTotal   := NbEnrTotal   + NbEnreg;
            NbErrTotal   := NbErrTotal   + NbErreur;
            NbErrDBTotal := NbErrDBTotal + NbErreurDB;
  		    end else
          begin
            if AfficheMessage then CpteRendu.lines.add('   Le format de la TOX est incorrect : Nom de la table de niveau 0 n''est pas renseign�');
            result := ToxRejeter ;
            exit ;
          end;
        end;
      end else
      begin
        if AfficheMessage then CpteRendu.lines.add('   Le format de la TOX est incorrect : Pas de nom de condition');
        result := ToxRejeter ;
        exit;
      end;
    end;

    if AfficheMessage then
    begin
      CpteRendu.lines.add('   ');
      CpteRendu.lines.add('   Int�gration termin�e le ' + DateToStr(Date) + ' � ' + TimeToStr(Time));
      CpteRendu.lines.add('   -> ' + IntToStr (NbEnrTotal)  + ' enregistrements trait�s ');
      CpteRendu.lines.add('   -> ' + IntToStr (NbErrTotal) + ' erreur(s) lors des contr�les');
      if (NbErrDBTotal <> 0) then CpteRendu.lines.add('   Attention : ' + IntToStr(NbErrDBTotal) + ' erreur(s) lors des mises � jour de la base');
    end;
    //
    // S'il y a des erreurs, il faudra la retraiter
    //
    if (NbErrDBTotal <> 0) or (NbErrTotal <> 0) then result := ToxARetraiter;
  end else
  begin
    if AfficheMessage then CpteRendu.lines.add('   Le format de la TOX est incorrect : Pas de nom d''�v�nement');
    result := ToxRejeter ;
  end;

  // Lib�ration de la TOB des devises
  if TobDevise <> nil then
  begin
    TobDevise.free ;
  end;
end;

///////////////////////////////////////////////////////////////////////////////////////
// Fonction permettant d'afficher :
//
//          1 - Un message d�crivant l'enregistrement � traiter
//          2 - Un message d�crivant l'erreur d'int�gration
//
// Param�tres     1 - NomTable                 Nom de la table en cours de traitement
//                2 - ToxInfo                  Information en cours d'int�gration = TOB
//                3 - MessErreur               Num�ro d'erreur.
//                4 - CpteRendu                TMemo servant d'affichage �cran
//                5 - AffDonneeIntegree        Affichage des donn�es int�gr�es
//                6 - AffDonneeRejetee         Affiche des donn�es rej�t�es
//
// 3 possibilit�s d'affichage :
//
//          1 - Donn�es int�gr�es sans erreur  : AffDonnneeIntegree = TRUE et AffDonneeRejetee = FALSE
//          2 - Donn�es int�gr�es avec erreur  : AffDonnneeIntegree = FALSE et AffDonneeRejetee = TRUE
//          3 - Toutes les donn�es             : AffDonnneeIntegree = TRUE et AffDonneeRejetee = TRUE
///////////////////////////////////////////////////////////////////////////////////////
procedure AfficheMessage (NomTable : string; var ToxInfo : TOB; CpteRendu : TMemo ; AffDonneeIntegree : boolean; AffDonneeRejetee : Boolean ) ;
var Erreur        : integer ;
    AfficheErreur : boolean;
begin
    //
    // R�cup�ration de l'erreur
    //
    if (ToxInfo.FieldExists ('TOX_RESULT')) and (ToxInfo.FieldExists ('TOX_ERREUR')) then
    begin
         Erreur := ToxInfo.GetValue ('TOX_ERREUR');
         AfficheErreur := True ;
    end
    else begin
     AfficheErreur := False;
     Erreur := -100;
    end;

    Inc (NbEnreg);
    if (AfficheErreur) and (Erreur <> 0) then Inc (NbMessErr);

    if AffDonneeIntegree then EditeInfoMessage (Nomtable, ToxInfo, -1, CpteRendu);
    if ((AffDonneeRejetee) and (Erreur <> 0)) then
    begin
      if not AffDonneeIntegree then EditeInfoMessage (Nomtable, ToxInfo, -1, CpteRendu);

      if AfficheErreur then EditeInfoMessage (Nomtable, ToxInfo, Erreur, CpteRendu)
      else CpteRendu.lines.add('         -> Attention : ce fichier n''a pas encore �t� trait�');
    end;
end;

///////////////////////////////////////////////////////////////////////////////////////
// Affichage des informations contenues dans la TOX
//
//		-> Balayage de l'unit� transactionnelle et appel de la fonction AfficheMessage
//
// !!!!!!!!!!!!!!!!!!!!!!!!! Attention : Fonction r�cursive !!!!!!!!!!!!!!!!!!!!!!!!!!
//
///////////////////////////////////////////////////////////////////////////////////////
procedure ConsulteMessage (var NomTable : string; var ToxInfo : TOB; CpteRendu : TMemo; AffDonneeIntegree, AffDonneeRejetee : boolean) ;
var ToxTableNext    : TOB	   ;
    ToxInfoNext     : TOB    ;
    NomTableNext    : string ;
    i, j            : integer;
begin

  AfficheMessage (NomTable, ToxInfo, CpteRendu, AffDonneeIntegree, AffDonneeRejetee);
  //
  // Balayage des niveaux inf�rieurs
  //
  for i:=0 to ToxInfo.Detail.Count-1 do
  begin
    ToxTableNext:=ToxInfo.Detail[i];

    if (ToxTableNext.FieldExists('TOX_TABLE')) then
    begin
      NomTableNext := ToxTableNext.GetValue ('TOX_TABLE');
      for j:=0 to ToxTableNext.Detail.Count-1 do
  	  begin
        ToxInfoNext := ToxTableNext.Detail[j];
        AfficheMessage (NomTableNext, ToxInfoNext, CpteRendu, AffDonneeIntegree, AffDonneeRejetee);
    	end;
    end
    else begin
      CpteRendu.lines.add('   Le format de la TOX est incorrect : Nom de la table n''est pas renseign�');
      break;
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////////////
// Consultation des messages d'int�gration de la TOX
///////////////////////////////////////////////////////////////////////////////////////
procedure ConsulteMessageDeLaTox (var Tox : TOB; CpteRendu : Tmemo; AffDonneeIntegree, AffDonneeRejetee : boolean ) ;
var ToxCondition : TOB 		;
		ToxTable0		 : TOB		;
    ToxInfo0		 : TOB		;
    NomTable0		 : string	;
    i,j,k				 : integer;
begin
  //
	// TOX MERE CONTENANT LE NOM DE L'EVENEMENT
  //
  if (Tox.FieldExists('EVENEMENT')) then
  begin
    for i:=0 to Tox.Detail.Count-1 do
    begin
      NbEnreg   := 0 ;
      NbMessErr := 0 ;
  	  //
      // TOX CONDITION CONTENANT LA CONDITION
      //
      ToxCondition:=Tox.Detail[i];

      if (ToxCondition.FieldExists('CONDITION')) then
      begin
        for j:=0 to ToxCondition.Detail.Count-1 do
        begin
          //
    	    // TOX TABLE Niveau 0
    	    //
          ToxTable0:=ToxCondition.Detail[j];
          if (ToxTable0.FieldExists('TOX_TABLE')) then
  		    begin

            NomTable0  := ToxTable0.GetValue ('TOX_TABLE');			// Nom de la table principale

            for k:=0 to ToxTable0.Detail.Count-1 do
            begin
              ToxInfo0 := ToxTable0.Detail[k];
              ConsulteMessage (NomTable0, ToxInfo0, CpteRendu, AffDonneeIntegree, AffDonneeRejetee);
            end;

            CpteRendu.lines.add('   ');
            if NbEnreg   > 1 then  CpteRendu.lines.add('   -> ' + IntToStr (NbEnreg)   + ' enregistrements trait�s ')
            else                 CpteRendu.lines.add('   -> ' + IntToStr (NbEnreg)     + ' enregistrement trait� ') ;
            if NbMessErr > 1 then CpteRendu.lines.add('   -> ' + IntToStr (NbMessErr)  + ' enregistrements rejet�s')
            else                 CpteRendu.lines.add('   -> ' + IntToStr (NbMessErr)   + ' enregistrement rejet�')
            
  		    end else
          begin
            CpteRendu.lines.add('   Le format de la TOX est incorrect : Nom de la table de niveau 0 n''est pas renseign�');
            exit ;
          end;
        end;
      end else
      begin
        CpteRendu.lines.add('   Le format de la TOX est incorrect : Pas de nom de condition');
        exit;
      end;
    end;
  end else
  begin
    CpteRendu.lines.add('   Le format de la TOX est incorrect : Pas de nom d''�v�nement');
  end;
end;

///////////////////////////////////////////////////////////////////////////////////////
// ChargeMessage
// Ajout des champs suppl�mentaires MESS_DONNEE et MESS_ERREUR et initialisation de ces
// deux messages
///////////////////////////////////////////////////////////////////////////////////////
procedure ChargeMessage (NomTable : string; var ToxInfo, Mess : TOB; Integre, Rejet : boolean ) ;
var Erreur : integer ;
begin
  //
  // R�cup�ration du num�ro d'erreur
  //
  if (ToxInfo.FieldExists ('TOX_RESULT')) and (ToxInfo.FieldExists ('TOX_ERREUR')) then Erreur := ToxInfo.GetValue ('TOX_ERREUR')
  else Erreur := -100;
  if (Erreur = 0) and (ToxInfo.FieldExists ('TOX_RESULT')) AND (ToxInfo.GetValue ('TOX_RESULT')='R') then
  begin
   Erreur := 1000;
  end;
  //
  // Indice l'enregistrement pour nous permettre de l'afficher + tard
  //
  if not ToxInfo.FieldExists ('TOX_INDICE') then ToxInfo.AddChampSup ('TOX_INDICE', False);
  Inc (IndiceTob);
  ToxInfo.PutValue ('TOX_INDICE', IndiceTob);
  //
  // Chargement des messages d'int�gration et des messages d'erreur
  //
  if ( (Integre = True) and ((Erreur = 0) or (Erreur = -100))) or ( (Rejet = True) and (Erreur > 0) ) then
  begin
    Mess := Tob.Create ('', TobMessage, -1);
    Mess.AddChampSup ('TABLE'      , False); Mess.PutValue ('TABLE'      , NomTable);
    Mess.AddChampSup ('MESS_DONNEE', False); Mess.PutValue ('MESS_DONNEE', ToxEditeMessage (NomTable, ToxInfo, -1));
    Mess.AddChampSup ('MESS_ERREUR', False); Mess.PutValue ('MESS_ERREUR', ToxEditeMessage (NomTable, ToxInfo, Erreur));
    Mess.AddChampSup ('ERREUR'     , False); Mess.PutValue ('ERREUR'     , Erreur);
    Mess.AddChampSup ('INDICE'     , False); Mess.PutValue ('INDICE'     , IndiceTob);
  end;
  //
  // Maj des compteurs d'enregistrements et d'erreurs
  //
  Inc (NbEnreg);
  if  Erreur > 0  then Inc (NbMessErr);
end;

///////////////////////////////////////////////////////////////////////////////////////
// Chargement dans la TOX des messages d'int�gration et des messages d'erreur
//
//		-> Balayage de l'unit� transactionnelle
//
// !!!!!!!!!!!!!!!!!!!!!!!!! Attention : Fonction r�cursive !!!!!!!!!!!!!!!!!!!!!!!!!!
//
///////////////////////////////////////////////////////////////////////////////////////
procedure ChargeMessageTox (NomTable : string; var ToxInfo : TOB; Integre, Rejet : Boolean) ;
var ToxTableNext    : TOB	   ;
    ToxInfoNext     : TOB    ;
    TobMess         : TOB    ;
    NomTableNext    : string ;
    i, j            : integer;
begin
  //
  // Initialisation de la TOB fille des messages
  //
  TobMess := nil ;
  ChargeMessage (NomTable, ToxInfo, TobMess, Integre, Rejet);

  if TobMess <> nil then
  begin
    //
    // Balayage des niveaux inf�rieurs
    //
    for i:=0 to ToxInfo.Detail.Count-1 do
    begin
      TobMessage := TobMess;

      ToxTableNext := ToxInfo.Detail[i];

      if (ToxTableNext.FieldExists('TOX_TABLE')) then
      begin
        NomTableNext := ToxTableNext.GetValue ('TOX_TABLE');
        for j:=0 to ToxTableNext.Detail.Count-1 do
  	    begin
          ToxInfoNext := ToxTableNext.Detail[j];
          ChargeMessageTox (NomTableNext, ToxInfoNext, Integre, Rejet);
    	  end;
      end
    end;
  end;
end;

///////////////////////////////////////////////////////////////////////////////////////
// TOX ayant un mauvais format
// On ne peut pas charger les messages associ�s !!!
///////////////////////////////////////////////////////////////////////////////////////
procedure ChargeMessageBadTox (ErreurFormat : integer) ;
var TobMess         : TOB    ;
begin
  TobMess := Tob.Create ('', TobMessage, -1);
  TobMess.AddChampSup ('TABLE'      , False);
  TobMess.PutValue    ('TABLE'      , 'Non D�finie');
  TobMess.AddChampSup ('MESS_DONNEE', False);
  TobMess.PutValue    ('MESS_DONNEE', 'Non D�finie');
  TobMess.AddChampSup ('MESS_ERREUR', False);

  if ErreurFormat = BadFormatEvents then
  begin
    TobMess.PutValue ('MESS_ERREUR', 'Le Format du fichier est incorrect ! Le nom de l''�v�nement n''est pas d�fini');
  end else
  if ErreurFormat = BadFormatCondit then
  begin
    TobMess.PutValue ('MESS_ERREUR', 'Le Format du fichier est incorrect ! Le nom de la condition n''est pas d�fini');
  end else
  if ErreurFormat = BadFormatTable then
  begin
    TobMess.PutValue ('MESS_ERREUR', 'Le Format du fichier est incorrect ! Le nom de la table n''est pas d�fini');
  end;
end;

//////////////////////////////////////////////////////////////////////////////////////
// Consultation des messages d'int�gration de la TOX
///////////////////////////////////////////////////////////////////////////////////////
procedure ChargeMessageDeLaTox (var Tox, TobMessAff : TOB; Integre, Rejet : boolean; Var Nbenr, NbErr : integer );
var ToxCondition : TOB 		;
    ToxTable0	 : TOB		;
    ToxInfo0	 : TOB		;
    NomTable0	 : string	;
    i,j,k	 : integer;
begin
  Nbenr := 0 ; NbErr := 0;
  //
	// TOX MERE CONTENANT LE NOM DE L'EVENEMENT
  //
  if (Tox.FieldExists('EVENEMENT')) then
  begin
    NbEnreg   := 0 ;               // Initialise le nombre d'enregistrements
    NbMessErr := 0 ;               // Initialise le nombre d'erreurs
    IndiceTob := 0 ;               // Initialise l'indice de TOB

    for i:=0 to Tox.Detail.Count-1 do
    begin
  	  //
      // TOX CONDITION CONTENANT LA CONDITION
      //
      ToxCondition:=Tox.Detail[i];

      if (ToxCondition.FieldExists('CONDITION')) then
      begin
        for j:=0 to ToxCondition.Detail.Count-1 do
        begin
          //
    	  // TOX TABLE Niveau 0
    	  //
          ToxTable0:=ToxCondition.Detail[j];
          if (ToxTable0.FieldExists('TOX_TABLE')) then
  	    begin
            NomTable0  := ToxTable0.GetValue ('TOX_TABLE');			// Nom de la table principale
            for k:=0 to ToxTable0.Detail.Count-1 do
            begin
              ToxInfo0   := ToxTable0.Detail[k];
              TobMessage := TobMessAff ;
              ChargeMessageTox (NomTable0, ToxInfo0, Integre, Rejet);
            end;
  	    end else
            begin
            TobMessage := TobMessAff ;
            ChargeMessageBadTox (BadFormatTable);
            exit ;
            end;
        end;
      end else
      begin
        TobMessage := TobMessAff ;
        ChargeMessageBadTox (BadFormatCondit);
        exit;
      end;
    end;
    NbEnr := NbEnreg ;
    NbErr := NbMessErr ;
  end else
  begin
    TobMessage := TobMessAff ;
    ChargeMessageBadTox (BadFormatEvents);
  end;
end;

//////////////////////////////////////////////////////////////////////////////////////
// Traitement de la TOX avant l'archivage
// Utilit� :
//
//         1 - Si site en CASH 2000, les informations seront transform�es et un fichier ASCII sera g�n�r�
//             Le code retour est False (on ne cr�e pas de fichier TOX
//         2 - On peut toper les pi�ces extraites pour interdire les modifications d�s l'envoi TOX
//
///////////////////////////////////////////////////////////////////////////////////////
procedure AvantArchivageTox (Tox : TOB; var ArchivageTox : boolean);
var LeSite                 : TCollectionSite  ;
    CodeSite               : string           ;
    Cash2000               : boolean          ;
    NumerosCaisse          : string           ;
    Variable               : TCollectionVariable ;
begin

  ArchivageTox := True ;
  Cash2000     := False ;
  //
  // Le site destinataire est-il un site CASH 2000 ?
  //
  if Tox.FieldExists('SITE') then
  begin
    CodeSite := Tox.Getvalue('SITE');
    //
    // Chargement des sites
    //
    LeSite:=TX_LesSites.Find(CodeSite) ;
    if LeSite<>Nil then
    begin
      Variable:=LeSite.LesVariables.Find('$CASH2000') ;
      if Variable<>Nil then Cash2000:=(Variable.SVA_VALUE = 'X') ;
      if Cash2000 then
      begin
        Variable:=LeSite.LesVariables.Find('$CAISSE') ;
        if Variable<>Nil then NumerosCaisse:=Variable.SVA_VALUE  ;
      end;
    end ;
  end;

  if Cash2000 then
  begin
{$IFNDEF FOS5}
    //
    // Archivage au format CASH 2000
    //
    AvantArchivageToxPourCASH (Tox, CodeSite, NumerosCaisse) ;
    ArchivageTox := False ;                                    // Pas d'archivage TOX : on s'en occupe
{$ENDIF}
  end else ArchivageTox := True ;

end;

end.
