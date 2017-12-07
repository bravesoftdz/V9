unit MenuCaisse;

interface
Uses windows,hent1,hctrls, sysutils, Messages,hmsgBox, HPanel,UiUtil,
{$IFDEF EAGLCLIENT}
     Maineagl,
{$ELSE}
     FE_Main, UEdtComp, LP_Param,
{$ENDIF}
     AGLInit, Forms;


Function MenuDispatchCaisse (Num : integer) : Boolean ;
Procedure LiberationCaisse ;
Function VerifEtatCaisse ( Num : Integer ; AfficheMsg : Boolean  ) : Boolean ;
procedure CAISSEMenuDispatchTT(Num: integer; Action: TActionFiche; Lequel, TT, Range: string);

implementation

Uses entGC,
     FOUtil,FOChoixCaisse,FODefi,FOFermeJour,FOOuvreJour,FOConsultCaisse,TicketFO,
     GrStaMR,GrJH;

const
	// Libell�s des messages
	TexteMessage: array[1..11] of string 	= (
          {1}   'Fonction non disponible : ' ,
          {2}   'Fonction non autoris�e : ',
          {3}   'Pour acc�der � cette fonction, la caisse doit �tre ouverte !' ,
          {4}   'Pour acc�der � cette fonction, la caisse doit �tre ferm�e !' ,
          {5}   'Aucun tiers par d�faut n''a �t� d�fini dans les param�tres soci�t�s.#13#13Vous ne pouvez donc pas cr�er de transfert !',
          {6}   'La nature de pi�ce des transferts n''est pas correctement renseign�e.#13#13Vous ne pouvez donc pas cr�er de transfert !',
          {7}   'Pour acc�der � cette fonction, la caisse doit avoir �t� ouverte au moins une fois !',
          {8}   'Aucun ch�que n''est � remettre en banque !',
          {9}   'Fonction interdite !',
          {10}  'La caisse est d�j� ouverte !',
          {11}  'La caisse est d�j� ferm�e !'
                );



Function MakeLequel ( Prefixe : String ; AvecNumZ : Boolean = False ) : String ;
Var sDateOuv : String ;
BEGIN
sDateOuv := DateToStr(FOGetParamCaisse('GPK_DATEOUV')) ;
Result := Prefixe + '_NATUREPIECEG=FFO;'
        + Prefixe + '_CAISSE=' + FOCaisseCourante + ';'
        + Prefixe + '_DATEPIECE=' + sDateOuv + ';'
        + Prefixe + '_DATEPIECE_=' + sDateOuv ;
if AvecNumZ then
   Result := Result+';'+Prefixe+'_NUMZCAISSE='+IntToStr(FOGetParamCaisse('GPK_NUMZCAISSE')) ;
END ;

procedure LanceMaximise ( Num : integer ; PRien : THPanel ; ForcePanel : boolean ; var ReaffBoutons : boolean ) ;
var FF : Forms.TForm ;
    PP : THPanel;
begin
  FF := nil ;
  PP := nil ;
  if (ForcePanel) or (FOExisteClavierEcran) then
  begin
    FF := Forms.TForm.Create (Application) ;
    PP := FindInsidePanel ;
    if PP <> Nil then
    begin
      InitInside (FF, PP) ;
      FF.Show;
    end;
  end;
  case Num of
    36101 :      // Saisie des tickets de vente
    begin
      CreerTicketFO('FFO') ;
      ReaffBoutons := True ;
    end ;
    36201 :      // Ouverture de la journ�e de vente
    begin
      FOOuvreJournee(PRien) ;
      ReaffBoutons := True ;
    end ;
    36202 :      // Fermeture de la journ�e de vente
    begin
      ReaffBoutons := FOFermeJournee(PRien) ;
    end ;
    36401 :      // Situation Flash
    begin
      if (FOExisteClavierEcran) then FOConsultationCaisse(FOCaisseCourante, '', '', Nil, True)
                                else FOConsultationCaisse(FOCaisseCourante, '', '', FindInsidePanel, True) ;
      ReaffBoutons := True ;
    end ;
  end ;
  if FF <> nil then
  begin
    FF.Close ;
    FF.Free ;
  end ;
  if PP <> nil then PP.CloseInside ;
end ;

Function MenuDispatchCaisse (Num : integer) : Boolean ;
Var sCaisse, sLequel : String ;
{$IFNDEF EAGLCLIENT}
    sNature, sCodeEtat, sTitre : String ;
{$ENDIF}
    ReaffBoutons : Boolean ;
    iNumZ : integer ;
    PRien : THPanel;
begin
Result:=True;
ReaffBoutons := False ;
PRien:=THPanel.Create(Nil);
PRien.Visible:=False;
   Case Num of
//====== Saisie =======
   36101 : begin // Saisie d'un ticket
           if VerifEtatCaisse(Num, True) then LanceMaximise (Num, PRien, False, ReaffBoutons) ;
           end ;
   36102 : begin // Consultation d'un ticket
           if VerifEtatCaisse (Num, True) then
              begin
              sLequel := MakeLequel('GP') ;
              AGLLanceFiche('MFO', 'PIECEDEV_MUL', sLequel, '', 'TICKET') ;
              end ;
           end ;
   36103 : begin     // Annulation d'un ticket
           if VerifEtatCaisse (Num, True) then
              begin
              sLequel := MakeLequel('GP') + ';GP_TICKETANNULE=-'
                + ';NEWNATURE=' + FOGetNatureTicket(False, False);
              AGLLanceFiche('MFO', 'ANNULTIC_MUL', sLequel, '', 'ANNULTIC') ;
              end ;
           end ;
   36104 : begin     // Rattachement d'un ticket � un client
           if VerifEtatCaisse (Num, True) then
              begin
              sLequel := MakeLequel('GP', True) + ';GP_TIERS=' + FODonneClientDefaut
                + ';GP_TICKETANNULE=-;NEWNATURE=' + FOGetNatureTicket(False, False);
              AGLLanceFiche('MFO', 'ANNULTIC_MUL', sLequel, '', 'ASSIGNTIC') ;
              end ;
           end ;
   36105 : begin     // Modification des r�glements
           if VerifEtatCaisse (Num, True) then
              begin
              sLequel := MakeLequel('GP', True) ;
              AGLLanceFiche('MFO', 'PIEDECHE_MUL', sLequel, '', 'MODIFICATION') ;
              end ;
           end ;
//====== Journ�e =======
   36201 : begin     // Ouverture de la journ�e de vente
           if VerifEtatCaisse (Num, True) then LanceMaximise (Num, PRien, True, ReaffBoutons) ;
           end ;
   36202 : begin     // Fermeture de la journ�e de vente
           if VerifEtatCaisse (Num, True) then LanceMaximise (Num, PRien, True, ReaffBoutons)
                                          else ReaffBoutons := True ;
           end ;
   36203 : begin     // Etat de la journ�e
           //if VerifEtatCaisse (Num, True) then AGLLanceFiche('MFO','JCAISSE', '', '', '') //NA 28/03/03
           //                               else ReaffBoutons := True ;
           if VerifEtatCaisse (Num, True) then 
              begin
              sCaisse := FOCaisseCourante ;
              iNumZ   := FOGetNumZCaisse(sCaisse) ;
              AGLLanceFiche('MFO', 'JCAISSE', '', '', 'GJC_CAISSE='+sCaisse+';GJC_NUMZCAISSE='+IntToStr(iNumZ)) ;
              end else ReaffBoutons := True ;
           end ;
   36204 : begin     // Liste des ch�ques diff�r�s
           if VerifEtatCaisse (Num, True) then
              begin
              sLequel := MakeLequel('GP')+';MP_TYPEMODEPAIE='+TYPEPAIECHQDIFF ;
              AGLLanceFiche('MFO', 'CHQDIF_MUL', sLequel, '', 'ECHEANCE') ;
              end else ReaffBoutons := True ;
           end ;
   36205 : begin     // Remise en banque
           if VerifEtatCaisse (Num, True) then
              AGLLanceFiche('MFO','REMISEBANQUE','','','CAISSE='+FOCaisseCourante+';NATUREPIECE=FFO') ;
           end ;
   36206 : begin     // Liste des articles vendus
           if VerifEtatCaisse (Num, True) then
              begin
              sLequel := MakeLequel('GL')+';GL_TYPEARTICLE=MAR' ;
              AGLLanceFiche('MFO', 'PIECART_MUL', sLequel, '', 'TICKET') ;
              end else ReaffBoutons := True ;
           end ;
//====== Edition =======
   36301 : begin     // Ticket X
           ReaffBoutons := True ;
           if VerifEtatCaisse (Num, True) then FOLanceImprimeLP(efoTicketX, FOMakeWhereTicketX('GP'), True, Nil) ;
           end ;
   36302 : begin     // Ticket Z
           ReaffBoutons := True ;
           if VerifEtatCaisse (Num, True) then
              begin
              iNumZ := FOGetNumZCaisse(FOCaisseCourante) ;
              sLequel := FOMakeWhereTicketZ('GP', '', iNumZ, iNumZ) ;
              FOLanceImprimeLP(efoTicketZ, sLequel, True, Nil) ;
              end;
           end ;
   36303 : begin     // r�capitulatif par vendeurs
           if VerifEtatCaisse (Num, True) then
              begin
              AGLLanceFiche('MFO','RECAPVEN_MUL','GJC_CAISSE='+FOCaisseCourante,'',ActionToString(taConsult)) ;
              end else ReaffBoutons := True ;
           end ;
   36304 : begin     // liste des r�glements
           ReaffBoutons := True ;
           if VerifEtatCaisse (Num, True) then
              begin
              sLequel := FOMakeWhereTicketX('GPE') ;
              FOLanceImprimeLP(efoListeRegle, sLequel, True, Nil) ;
              end;
           end ;
   36305 : begin     // Impression du bordereau de remise en banque
           ReaffBoutons := True ;
           if VerifEtatCaisse (Num, True) then
              begin
              sLequel := '(MP_TYPEMODEPAIE = "'+TYPEPAIECHEQUE+'" OR MP_TYPEMODEPAIE = "'+TYPEPAIECHQDIFF+'") AND '
                         + 'GPE_DATEREMBNQ ="'+USDateTime(Now)+'" AND GPE_CHQDIFUTIL="X" AND GPE_NATUREPIECEG="FFO"' ;
              FOLanceImprimeLP(efoRemiseBq, sLequel, True, Nil) ;
              end ;
           end ;
//====== Analyses =======
   36401 : begin     // Situation Flash
           if VerifEtatCaisse (Num, True) then LanceMaximise (Num, PRien, False, ReaffBoutons) ;
           end ;
   36402 : begin     // R�partition par mode de paiement
           if VerifEtatCaisse (Num, True) then StatparModeReglement(FindInsidePanel, FOGetNatureTicket(False, False))
                                          else ReaffBoutons := True ;
           end ;
   36403 : begin     // Meilleure journ�e / Meilleure heure
           if VerifEtatCaisse (Num, True) then MeuilleurJouretHour(FindInsidePanel, FOGetNatureTicket(False, False))
                                          else ReaffBoutons := True ;
           end ;
   36404 : begin     // Situation sur plusieurs cl�tures
           if VerifEtatCaisse (Num, True) then
              begin
              sCaisse := FOCaisseCourante ;
              AGLLanceFiche('MFO','SITUFLASH_MUL','GJC_CAISSE='+sCaisse+';GJC_NUMZCAISSE_='+
                            IntToStr(FOGetNumZCaisse(sCaisse)),'','') ;
              end else ReaffBoutons := True ;
           end ;
   36405 :           // Compte-rendu des ventes d�tail
           AGLLanceFiche('GC','GCEDTCRV_MODE','','',''); 
//====== Mod�les d'impression =======
{$IFNDEF EAGLCLIENT}
   36801 : begin     // Tichet
           sNature:=''; sCodeEtat:=''; sTitre:='';
           FODonneCodeEtat (efoTicket, True, sNature, sCodeEtat, sTitre) ;
           Param_LPTexte(Nil, 'T', sNature, sCodeEtat, TRUE) ;
           end ;
   36802 : begin     // Tichet X
           sNature:=''; sCodeEtat:=''; sTitre:='';
           FODonneCodeEtat (efoTicketX, True, sNature, sCodeEtat, sTitre) ;
           Param_LPTexte(Nil, 'T', sNature, sCodeEtat, TRUE) ;
           end ;
   36803 : begin     // Tichet Z
           sNature:=''; sCodeEtat:=''; sTitre:='';
           FODonneCodeEtat (efoTicketZ, True, sNature, sCodeEtat, sTitre) ;
           Param_LPTexte(Nil, 'T', sNature, sCodeEtat, TRUE) ;
           end ;
   36804 : begin     // Ch�que
           sNature:=''; sCodeEtat:=''; sTitre:='';
           FODonneCodeEtat (efoCheque, True, sNature, sCodeEtat, sTitre) ;
           Param_LPTexte(Nil, 'T', sNature, sCodeEtat, TRUE) ;
           end ;
   36805 : begin     // Remise en banque
           sNature:=''; sCodeEtat:=''; sTitre:='';
           FODonneCodeEtat (efoRemiseBq, True, sNature, sCodeEtat, sTitre) ;
           Param_LPTexte(Nil, 'T', sNature, sCodeEtat, TRUE) ;
           end ;
{$ENDIF}
//====== Caisse =======
   36901 : AGLLanceFiche('MFO','PCAISSE','','',ActionToString(taModif)) ; // Param�trage des caisses
   36902 : AGLLanceFiche('MFO','MODIFCAIS_MUL','','',ActionToString(taModif)) ; // Modification en s�rie du param�trage des caisses
   36903 : AGLLanceFiche('MFO','LIBERECAISSE','','',ActionToString(taModif)) ; // Lib�ration des caisses
   36904 : begin     // Param�trage du poste de travail
           ReaffBoutons := True ;
           V_PGI.ZoomOLE := True ;
           sCaisse := AGLLanceFiche('MFO', 'PARAMPOSTE', '', '', ActionToString(taModif)) ;
           V_PGI.ZoomOLE := False ;
           if (sCaisse <> '') and (sCaisse <> FOCaisseCourante) then FOLibereVHGCCaisse ;
           end ;
   36905 : AGLLanceFiche('GC','GCARTFINANCIER','FI','','TYPEARTICLE=FI') ; // operation de caisse
   36906 :       // D�tail des esp�ces
           AglLanceFiche('MFO', 'DETAILESPECES', V_PGI.DevisePivot+';BIL', '' ,'MODE=;DEVISE='+V_PGI.DevisePivot) ;
   36907 :       // Type de d�marque
           AGLLancefiche('MFO', 'DEMARQUE', '', '', '');
   else HShowMessage('2;?caption?;'+TraduireMemoire(TexteMessage[1])+';W;O;O;O;',TitreHalley,IntToStr(Num)) ;
   END ;
PRien.Free;
end ;

///////////////////////////////////////////////////////////////////////////////////////
//  VerifEtatCaisse
///////////////////////////////////////////////////////////////////////////////////////
Procedure LiberationCaisse ;
begin
FOLibereVHGCCaisse ;
end;

Function VerifEtatCaisse ( Num : Integer ; AfficheMsg : Boolean  ) : Boolean ;
Var EtatCaisse : String ;
    NoErr      : Integer ;
BEGIN
NoErr := 2 ;
// V�rification si une caisse est s�lectionn�e
if (not FOVerifieVHGCCaisse) or (not FOCaisseDisponible) then
   BEGIN
   Result := False ;         
   if FOChoixCodeCaisse then FOChgStatus else Exit ;
   END ;
// Rechargement des param�tres et de l'�tat de la caisse (ouverte, ferm�e, non ouverte...)
EtatCaisse := ETATJOURCAISSE[1] ;
EtatCaisse := FOEtatCaisse(FOCaisseCourante) ;
// V�rification de l'�tat de la caisse en fonction de la ligne de menu choisie
Case Num of
   36101 ,          // Saisie des tickets de vente
   36103 ,          // Annulation d'un ticket
   36104 ,          // Modification des r�glements
   36105 ,          // Rattachement d'un ticket � un client
   36301 :          // Ticket X
         BEGIN
         Result := (EtatCaisse = ETATJOURCAISSE[2]) ;                // la journ�e doit �tre ouverte
         NoErr := 3 ;
         END ;
   36201 :          // Ouverture de la journ�e de vente
         BEGIN
         Result := (EtatCaisse <> ETATJOURCAISSE[2]) ;               // la caisse est d�j� ouverte
         NoErr := 10 ;
         END ;
   36202 :          // Fermeture de la journ�e de vente
         BEGIN
         Result := (EtatCaisse = ETATJOURCAISSE[2]) ;                // la caisse est d�j� ferm�e
         NoErr := 11 ;
         END ;
   36203 :          // Etat de la journ�e
         BEGIN
         Result := (EtatCaisse <> ETATJOURCAISSE[1]) ;               // la journ�e doit �tre d�finie
         NoErr := 7 ;
         END ;
   36302 :          // Ticket Z
         BEGIN
         Result := (EtatCaisse <> ETATJOURCAISSE[2]) ;               // la journ�e doit �tre ferm�e
         NoErr := 4 ;
         END ;
   else Result := True ;
   END ;
if (not Result) and (AfficheMsg) then
   BEGIN
   HShowMessage('2;?caption?;'+TraduireMemoire(TexteMessage[NoErr])+';W;O;O;O;',TitreHalley,'')
   END ;
END ;

procedure CAISSEMenuDispatchTT(Num: integer; Action: TActionFiche; Lequel, TT, Range: string);
begin
  case Num of
    112200: {Lancement de l'�diteur de ticket} FODispatchParamModele(Num, Action, Lequel, TT, Range);
  end;
end;

end.
