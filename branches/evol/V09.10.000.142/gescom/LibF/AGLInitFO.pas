{***********UNITE*************************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : Publication de fonctions et de proc�dures du Front Office
Suite ........ : pour les scripts des fiches
Mots clefs ... : FO
*****************************************************************}
unit AGLInitFO;

interface

implementation

uses
  Forms, Graphics, Sysutils, Controls, classes, extctrls, comctrls, stdctrls, mask,
  HMsgBox, Hent1, HCtrls, AGLinit, UIUtil, UTOF, M3FP, printers,
  {$IFDEF EAGLCLIENT}
  eMul, UTOB, eFichList,
  {$ELSE}
  Mul, FichList, dbtables,
  {$ENDIF}
  EntGC, FactComm,
  FODefi, FOUtil, TickUtilFO, EcheanceFO,
  {$IFDEF FOS5}
  FOChoixPave, FOConsultCaisse, UTOFMFOSITUFLASH_MUL, UTOFMFORECAPVEN_MUL,
  {$ENDIF}
  MC_Erreur, TPE_Base, Af_Base, TR_base, LP_View;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : FOSetColor = modifie la couleur d'un contr�le
Suite ........ : (inutile avec les derni�res versions de l'AGL).
Suite ........ :  - Parms[0] = Fiche
Suite ........ :  - Parms[1] = Nom du contr�le
Suite ........ :  - Parms[2] = Nom de la couleur
Mots clefs ... : FO
*****************************************************************}

procedure FOAGLSetFontColor(parms: array of variant; nb: integer);
var FF: TForm;
  Couleur: string;
  Color: TColor;
begin
  FF := TForm(Longint(Parms[0]));
  Couleur := UpperCase(Trim(Parms[2]));
  Color := clNone;
  if Couleur = 'AQUA' then Color := clAqua else
    if Couleur = 'BLACK' then Color := clBlack else
    if Couleur = 'DKGRAY' then Color := clDkGray else
    if Couleur = 'FUCHSIA' then Color := clFuchsia else
    if Couleur = 'GRAY' then Color := clGray else
    if Couleur = 'GREEN' then Color := clGreen else
    if Couleur = 'LIME' then Color := clLime else
    if Couleur = 'LTGRAY' then Color := clLTGray else
    if Couleur = 'MAROON' then Color := clMaroon else
    if Couleur = 'NAVY' then Color := clNavy else
    if Couleur = 'OLIVE' then Color := clOlive else
    if Couleur = 'PURPLE' then Color := clPurple else
    if Couleur = 'RED' then Color := clRed else
    if Couleur = 'SILVER' then Color := clSilver else
    if Couleur = 'TEAL' then Color := clTeal else
    if Couleur = 'WHITE' then Color := clWhite else
    if Couleur = 'YELLOW' then Color := clYellow else
    if Couleur = 'ORANGE' then Color := $00006FDD;
  if Color <> clNone then FoSetFontColor(FF, string(parms[1]), Color);
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 17/06/2002
Modifi� le ... : 17/06/2002
Description .. : FOGetParamCaisse = Retourne un param�tre de la caisse
Suite ........ : courante
Suite ........ :  - Parms[0] = Nom du champ
Mots clefs ... : FO
*****************************************************************}

function FOAGLGetParamCaisse(parms: array of variant; nb: integer): Variant;
begin
  Result := FOGetParamCaisse(Parms[0]);
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : FOLibereCaisse = Lib�re une caisse marqu�e comme en
Suite ........ : cours d'utilisation.
Suite ........ :  - Parms[0] = Code de la caisse
Mots clefs ... : FO
*****************************************************************}

procedure FOAGLLibereCaisse(parms: array of variant; nb: integer);
begin
  FOLibereCaisse(Parms[0]);
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 04/01/2002
Description .. : FOLibereMULCaisse = Lib�re une s�lection d'un MUL de
Suite ........ : caisses marqu�es comme en cours d'utilisation.
Suite ........ :  - Parms[0] = Fiche
Mots clefs ... : FO
*****************************************************************}

procedure FOAGLLibereMULCaisse(parms: array of variant; nb: integer);
var FF: TForm;
  Ind: integer;
  sCaisse, sTexte: string;
begin
  FF := TForm(Longint(Parms[0]));
  if (FF = nil) or not (FF is TFMul) then Exit;
  if (TFMul(FF).FListe.NbSelected = 0) and (not TFMul(FF).FListe.AllSelected) then Exit;
  sTexte := 'Etes-vous certain de vouloir lib�rer les caisses s�lectionn�es ?#10'
    + '#10Attention aux cons�quences pour les autres utilisateurs !';
  if PGIAsk(sTexte, FF.Caption) <> mrYes then Exit;
  if TFMul(FF).FListe.AllSelected then
  begin
    TFmul(FF).Q.First;
    while not TFmul(FF).Q.EOF do
    begin
      if TFmul(FF).Q.FindField('GPK_INUSE').AsString = 'X' then
      begin
        sCaisse := TFmul(FF).Q.FindField('GPK_CAISSE').AsString;
        FOLibereCaisse(sCaisse);
      end;
      TFmul(FF).Q.NEXT;
    end;
    TFmul(FF).FListe.AllSelected := False;
  end else
  begin
    for Ind := 0 to TFMul(FF).FListe.NbSelected - 1 do
    begin
      TFMul(FF).FListe.GotoLeBookMark(Ind);
      {$IFDEF EAGLCLIENT}
      TFMul(FF).Q.TQ.Seek(TFMul(FF).FListe.Row - 1);
      {$ENDIF}
      if TFmul(FF).Q.FindField('GPK_INUSE').AsString = 'X' then
      begin
        sCaisse := TFmul(FF).Q.FindField('GPK_CAISSE').AsString;
        FOLibereCaisse(sCaisse);
      end;
    end;
    TFMul(FF).FListe.ClearSelected;
    TFMul(FF).Q.First;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : AppelEcheanceFO = consultation ou modification des
Suite ........ : �ch�ances d'un ticket du Front Office
Suite ........ :  - Parms[0] = Cl� du document (format CleDoc)
Suite ........ :  - Parms[1] = Code action
Mots clefs ... : FO
*****************************************************************}

procedure FOAGLAppelEcheance(Parms: array of variant; nb: integer);
var CleDoc: R_CleDoc;
  StA, StM: string;
  Ind: integer;
  Action: TActionFiche;
begin
  FillChar(CleDoc, Sizeof(CleDoc), #0);
  StA := string(Parms[0]);
  StM := string(Parms[1]);
  Action := taModif;
  Ind := Pos('ACTION=', StM);
  if Ind > 0 then
  begin
    StM := ReadTokenSt(StM);
    Action := StringToAction(StM);
  end;
  if Action = tacreat then
  begin
    //CreerPiece (StC) ;
  end else
  begin
    StringToCleDoc(StA, CleDoc);
    SaisirEcheanceFO(CleDoc, Action);
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : FOGetVendeur = recherche d'un vendeur
Suite ........ :  - Parms[0] = Fiche
Suite ........ :  - Parms[1] = Contr�le
Suite ........ :  - Parms[2] = Titre du LookUp
Suite ........ :  - Parms[3] = Zone commerciale
Suite ........ :  - Parms[4] = Code �tablissement
Suite ........ : => Code du vendeur choisi
Mots clefs ... : FO
*****************************************************************}

function FOAGLGetVendeur(Parms: array of variant; nb: integer): variant;
var CC: TComponent;
  FF: TForm;
begin
  Result := '';
  FF := TForm(Longint(Parms[0]));
  CC := FF.FindComponent(string(Parms[1]));
  if (CC <> nil) and (CC is TControl) then
    Result := FOGetVendeur(TControl(CC), string(Parms[2]), string(Parms[3]), string(Parms[4]));
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : FOTestTPE = teste les transmissions avec un TPE
Suite ........ :  - Parms[0] = Fiche
Suite ........ :  - Parms[1] = Caisse
Suite ........ : => '' si OK sinon 'NON'
Mots clefs ... : FO
*****************************************************************}

function FOAGLTestTPE(Parms: array of variant; nb: integer): variant;
var ResultTPE, NumCarte, Autres, EtatTrans: string;
  TPVCARTEB, PORTCarteB, PARAMSTPE, Caisse: string;
  TT: TFOProgressForm;
  FF: TForm;
  Ok: boolean;
begin
  Result := '';
  FF := TForm(Longint(Parms[0]));
  TT := TFOProgressForm.Create(FF, 'Param�trage des p�riph�riques de caisse', 'Test de communication avec le TPE');
  Caisse := string(Parms[1]);
  FODonneParamTPE(Caisse, TPVCARTEB, PORTCarteB, PARAMSTPE);
  Ok := GereAutorisationCB(Caisse, 'CB', FODonneCodeEuro,
    TPVCARTEB, PORTCarteB, PARAMSTPE, ttTPEAchat,
    0.01, ResultTPE, NumCarte, Autres, EtatTrans);
  if not Ok then Result := 'NON';
  if Trim(ResultTPE) <> '' then
  begin
    EtatTrans := TraduireMemoire('Le r�sultat de la demande d''autorisation est :')
      + #13 + ' ' + TraduireMemoire(ResultTPE);
    PGIBox(EtatTrans, 'Gestion du TPE');
  end;
  TT.Free;
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : FOTestAfficheur =  teste l'afficheur externe
Suite ........ :  - Parms[0] = Code de la caisse
Mots clefs ... : FO
*****************************************************************}

procedure FOAGLTestAfficheur(Parms: array of variant; nb: integer);
var CurCaisse, CaisseTest: string;
begin
  CurCaisse := FOCaisseCourante;
  CaisseTest := string(Parms[0]);
  FOChargeVHGCCaisse(CaisseTest);
  InitAfficheur;
  if CurCaisse <> CaisseTest then FOChargeVHGCCaisse(CurCaisse);
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : FOTestTiroir =  teste l'ouverture du tiroir caisse
Suite ........ :  - Parms[0] = Fiche
Suite ........ :  - Parms[1] = Type de tiroir
Suite ........ :  - Parms[2] = Port de communication
Suite ........ :  - Parms[3] = Param�tres de communication
Suite ........ : => '' si OK sinon 'NON'
Mots clefs ... : FO
*****************************************************************}

function FOAGLTestTiroir(Parms: array of variant; nb: integer): variant;
var TT: TFOProgressForm;
  FF: TForm;
  Ok: boolean;
begin
  Result := '';
  FF := TForm(Longint(Parms[0]));
  TT := TFOProgressForm.Create(FF, 'Param�trage des p�riph�riques de caisse', 'Test d''ouverture du tiroir caisse');
  Ok := TestOuvreTiroir(string(Parms[1]), string(Parms[2]), string(Parms[3]));
  if not Ok then Result := 'NON';
  TT.Free;
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : FOTestImprimante =  teste 'imprimante ticket
Suite ........ :  - Parms[0] = Fiche
Suite ........ :  - Parms[1] = Clause Where
Suite ........ :  - Parms[2] = Type d'imprimante
Suite ........ :  - Parms[3] = Port de communication
Suite ........ :  - Parms[4] = Param�tres de communication
Suite ........ : => '' si OK sinon 'NON'
Mots clefs ... : FO
*****************************************************************}

function FOAGLTestImprimante(Parms: array of variant; nb: integer): variant;
var Nature, CodeEtat, Titre: string;
  Err: TMC_Err;
  TT: TFOProgressForm;
  FF: TForm;
  Ok: boolean;
begin
  Result := '';
  FF := TForm(Longint(Parms[0]));
  TT := TFOProgressForm.Create(FF, 'Param�trage des p�riph�riques de caisse', 'Test d''impression sur l''imprimante ticket');
  FODonneCodeEtat(efoTicketTest, False, Nature, CodeEtat, Titre);
  Ok := ImprimeLP('T', Nature, CodeEtat, string(Parms[1]), string(Parms[2]), string(Parms[3]),
    string(Parms[4]), True, False, True, nil, Err);
  if not Ok then Result := 'NON';
  TT.Free;
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : ImprimeTicketFO = impression d'un ticket du Front Office
Suite ........ :  - Parms[0] = Cl� du document (format CleDoc)
Suite ........ :  - Parms[1] = Avec choix du mod�le d'impression
Mots clefs ... : FO
*****************************************************************}

{$IFDEF FOS5}
procedure FOAGLImprimeTicket(Parms: array of variant; nb: integer);
var CleDoc: R_CleDoc;
  Modele: string;
begin
  FillChar(CleDoc, Sizeof(CleDoc), #0);
  StringToCleDoc(string(Parms[0]), CleDoc);
  if (nb > 1) and (Trim(UpperCase(string(Parms[1]))) = 'CHOIX') then
  begin
    with Printer do
    begin
      if Printers.Count > 1 then
        FOImprimerLaPiece(nil, nil, nil, nil, CleDoc, True, True, False, True)
      else
      begin
        Modele := FOChoisirPave('Choix du mod�le d''impression', 'GCIMPMODELEFO',
          'MO_TYPE="T" AND MO_NATURE="' + NATUREMODTICKET + '"');
        if Modele <> '' then
          FOImprimeTexte(nil, CleDoc, NATUREMODTICKET, Modele, V_PGI.LanguePerso, True, True);
      end;
    end;
  end else
  begin
    FOImprimerLaPiece(nil, nil, nil, nil, CleDoc, True, True);
  end;
end;
{$ENDIF}

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : FOLanceImprimeLP = lance une impression de ticket � partir
Suite ........ : de la requ�te SQL d'un MUL
Suite ........ :  - Parms[0] = Fiche
Suite ........ :  - Parms[1] = Type d'impression
Suite ........ :  - Parms[2] = Clause Where (inutile pour les Mul)
Mots clefs ... : FO
*****************************************************************}

procedure FOAGLLanceImprimeLP(Parms: array of variant; nb: integer);
var Where, St: string;
  FF: TForm;
  TypeEtat: TTypeEtatFO;
begin
  // R�cup�ration du type d'�tat
  St := (string(Parms[1]));
  St := UpperCase(Trim(St));
  TypeEtat := efoTicket;
  if St = 'TICKET' then TypeEtat := efoTicket else
    if St = 'TICKETX' then TypeEtat := efoTicketX else
    if St = 'TICKETZ' then TypeEtat := efoTicketZ else
    if St = 'RECAPVEND' then TypeEtat := efoRecapVend else
    if St = 'LISTEREGLE' then TypeEtat := efoListeRegle else
    if St = 'TICKETTEST' then TypeEtat := efoTicketTest else
    if St = 'LISTEARTVENDU' then TypeEtat := efoListeArtVendu else
    ;
  // R�cup�ration de la clause WHERE
  Where := '';
  FF := TForm(Integer(Parms[0]));
  if FF is TFMul then Where := FoExtractWhere(TPageControl(TFMul(FF).Pages))
  else Where := (string(Parms[2]));
  FOLanceImprimeLP(TypeEtat, Where, False, nil);
end;

{***********A.G.L.***********************************************
Auteur  ...... : O. TARCY
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : FOLanceRecapVen = lance l'impression du r�capitulatif par
Suite ........ : vendeur au format ticket
Suite ........ :  - Parms[0] = Code de la caisse
Suite ........ :  - Parms[1] = Num�ro de journ�e inf�rieur
Suite ........ :  - Parms[2] = Num�ro de journ�e sup�rieur
Mots clefs ... : FO
*****************************************************************}

procedure FOAGLLanceRecapVen(Parms: array of variant; nb: integer);
var sCaisse: string;
  sNumZInf, sNumZSup: integer;
begin
  sCaisse := (string(Parms[0]));
  sNumZInf := (integer(Parms[1]));
  sNumZSup := (integer(Parms[2]));
  FOLanceImprimeLP(efoRecapVend, FOMakeWhereRecapVendeurs('GP', sCaisse, sNumZInf, sNumZSup), True, nil);
end;

{***********A.G.L.***********************************************
Auteur  ...... : O. TARCY
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : SituationFlash = lance la Situation Flash
Suite ........ :  - Parms[0] = Code de la caisse
Suite ........ :  - Parms[1] = Num�ro de journ�e inf�rieur
Suite ........ :  - Parms[2] = Num�ro de journ�e sup�rieur
Mots clefs ... : FO
*****************************************************************}

{$IFDEF FOS5}
procedure FOAGLSituationFlash(Parms: array of variant; nb: integer);
begin
  FOConsultationCaisse(string(Parms[0]), string(Parms[1]), string(Parms[2]), FindInsidePanel, False);
end;
{$ENDIF}

{***********A.G.L.***********************************************
Auteur  ...... : O. TARCY
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : FOVisu = Ex�cute la fonction de visualisation de la TOF
Suite ........ : associ�e
Suite ........ :  - Parms[0] = Fiche
Mots clefs ... : FO
*****************************************************************}

{$IFDEF FOS5}
procedure FOAGLVisu(Parms: array of variant; nb: integer);
var FF: TForm;
  MaTOF: TOF;
begin
  FF := TForm(Longint(Parms[0]));
  if (FF is TFmul) then MaTOF := TFMul(FF).LaTOF else Exit;
  if (MaTOF is TOF_MFOSITUFLASH_MUL) then TOF_MFOSITUFLASH_MUL(MaTOF).FOVisu else
    if (MaTOF is TOF_MFORECAPVEN_MUL) then TOF_MFORECAPVEN_MUL(MaTOF).FOVisuTicket else Exit;
end;
{$ENDIF}

{***********A.G.L.***********************************************
Auteur  ...... : O. TARCY
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : FODebListe = Se positionne sur la 1�re ligne de la liste d'un
Suite ........ : Mul
Suite ........ :  - Parms[0] = Fiche
Mots clefs ... : FO
*****************************************************************}

{$IFDEF FOS5}
procedure FOAGLDebListe(Parms: array of variant; nb: integer);
var FF: TForm;
  MaTOF: TOF;
begin
  FF := TForm(Longint(Parms[0]));
  if (FF is TFmul) then MaTOF := TFMul(FF).LaTOF else Exit;
  if (MaTOF is TOF_MFORECAPVEN_MUL) then TOF_MFORECAPVEN_MUL(MaTOF).FODebListe else Exit;
end;
{$ENDIF}

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : FOAffichePhotoArt = affiche la photo d'un article
Suite ........ :  - Parms[0] = Fiche
Suite ........ :  - Parms[1] = Code article
Suite ........ :  - Parms[2] = Contr�le image
Mots clefs ... : FO
*****************************************************************}

procedure FOAGLAffichePhotoArt(Parms: array of variant; nb: integer);
var FF: TForm;
  CC: TComponent;
  CodeArt: string;
begin
  FF := TForm(Longint(Parms[0]));
  CodeArt := string(Parms[1]);
  if CodeArt = '' then Exit;
  CC := FF.FindComponent(string(Parms[2]));
  if CC is TImage then FOAffichePhotoArticle(CodeArt, TImage(CC));
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 11/04/2003
Description .. : FOInPGIContexte = v�rifie si un contexte est actif
Suite ........ :  - Parms[0] = Contexte � v�rifier
Suite ........ : => True ou False
Suite ........ :
Suite ........ : Attention utiliser � la place : Agl_V_Pgi
Mots clefs ... : FO
*****************************************************************}

function FOAGLInPGIContexte(parms: array of variant; nb: integer): variant;
var Ctx: TContexte_PGI;
  Stg: string;
begin
  Result := False;
  Stg := Uppercase(Trim(string(Parms[0])));
  if Stg = '' then Exit;
  if Stg = 'CTXSTANDARD' then Ctx := ctxStandard else
    if Stg = 'CTXGESCOM' then Ctx := ctxGescom else
    if Stg = 'CTXNEGOCE' then Ctx := ctxNegoce else
    if Stg = 'CTXAFFAIRE' then Ctx := ctxAffaire else
    if Stg = 'CTXSCOT' then Ctx := ctxScot else
    if Stg = 'CTXTEMPO' then Ctx := ctxTempo else
    if Stg = 'CTXMODE' then Ctx := ctxMode else
    if Stg = 'CTXCOMPTA' then Ctx := ctxCompta else
    if Stg = 'CTXPCL' then Ctx := ctxPCL else
    if Stg = 'CTXPAIE' then Ctx := ctxPaie else
    if Stg = 'CTXGRC' then Ctx := ctxGRC else
    if Stg = 'CTXCHR' then Ctx := ctxCHR else
    if Stg = 'CTXBTP' then Ctx := ctxBTP else
    if Stg = 'CTXTRANSPORT' then Ctx := ctxTransport else
    if Stg = 'CTXECOMMERCE' then Ctx := ctxECommerce else
    if Stg = 'CTXFO' then Ctx := ctxFO else
    if Stg = 'CTXDP' then Ctx := ctxDP else Exit;
  Result := (Ctx in V_PGI.PGIContexte);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : FOTraduire = traduction d'un texte
Suite ........ : (inutile avec les derni�res versions de l'AGL).
Suite ........ :  - Parms[0] = Texte � traduire
Suite ........ : => Texte traduit
Mots clefs ... : FO
*****************************************************************}

function FOAGLTraduire(parms: array of variant; nb: integer): variant;
begin
  Result := TraduireMemoire(string(Parms[0]));
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 23/07/2001
Description .. : FOComboDeleteValue = Supprime un code dans un
Suite ........ : combo.
Suite ........ :  - Parms[0] = Fiche
Suite ........ :  - Parms[1] = Contr�le Combo
Suite ........ :  - Parms[2] = Code � supprimer de la liste
Mots clefs ... : FO
*****************************************************************}

procedure FOAGLComboDeleteValue(parms: array of variant; nb: integer);
var FF: TForm;
  CC: TComponent;
  Val: string;
begin
  FF := TForm(Longint(Parms[0]));
  if FF = nil then Exit;
  CC := FF.FindComponent(string(parms[1]));
  Val := string(Parms[2]);
  if (Val <> '') and (CC <> nil) and (CC is THValComboBox) then
    FOComboDeleteValue(THValComboBox(CC), Val);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2001
Modifi� le ... : 27/11/2001
Description .. : FOTypeArtAutorise = fabrique un ordre IN d'un SELECT �
Suite ........ : partir de la liste des types d'articles autoris�s pour une
Suite ........ : nature de pi�ce.
Suite ........ :  - Parms[0] = Nature de pi�ce
Suite ........ :  - Parms[1] = Nom du champ
Suite ........ : => liste des types d'articles autoris�s
Mots clefs ... : FO
*****************************************************************}

function FOAGLTypeArtAutorise(parms: array of variant; nb: integer): variant;
begin
  Result := FOFabriqueListeTypArt(string(Parms[0]), string(Parms[1]));
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 04/01/2002
Modifi� le ... : 04/01/2002
Description .. : FOGetSynRegKey = lit une cl� de registe.
Suite ........ :  - Parms[0] = Nom de la cl� de registre
Suite ........ :  - Parms[1] = Valeur par d�faut
Suite ........ : => liste des types d'articles autoris�s
Mots clefs ... : FO
*****************************************************************}

function FOAGLGetSynRegKey(parms: array of variant; nb: integer): variant;
begin
  Result := GetSynRegKey(string(Parms[0]), Parms[1], True);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 04/01/2002
Modifi� le ... : 04/01/2002
Description .. : FOSaveSynRegKey = met � jour un cl� de registe.
Suite ........ :  - Parms[0] = Nom de la cl� de registre
Suite ........ :  - Parms[1] = Valeur
Mots clefs ... : FO
*****************************************************************}

procedure FOAGLSaveSynRegKey(parms: array of variant; nb: integer);
begin
  SaveSynRegKey(string(Parms[0]), Parms[1], True);
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 10/12/2002
Modifi� le ... : 10/12/2002
Description .. : FOMulOptions = Active certains options du MUL
Suite ........ : associ�e
Suite ........ :  - Parms[0] = Fiche
Suite ........ :  - Parms[1] = option SANSFILTRE ou AGRANDIR
Mots clefs ... : FO
*****************************************************************}

procedure FOAGLMulOptions(Parms: array of variant; nb: integer);
var FF: TForm;
  Stg: string;
begin
  FF := TForm(Longint(Parms[0]));
  if not (FF is TFMul) then Exit;
  Stg := Trim(UpperCase(string(Parms[1])));
  if Stg = 'SANSFILTRE' then
    TFMul(FF).FiltreDisabled := True
  else if Stg = 'AGRANDIR' then
    TFMul(FF).BAgrandir.Click;
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 16/05/2003
Modifi� le ... : 16/05/2003
Description .. : FORepriseOpCaisseLies = Reprise de l'historique des
Suite ........ : op�rations de caisse pour la liaison des r�glements
Suite ........ :  - Parms[0] = Cl� du document (format CleDoc)
Mots clefs ... : FO
*****************************************************************}

procedure FOAGLRepriseOpCaisseLies(Parms: array of variant; nb: integer);
var
  FF: TForm;
  Ind, NbOk, NbErr: integer;
  sTexte: string;
  {****************************************************************************}
  procedure LanceReprise;
  var
    CleDoc: R_CleDoc;
  begin
    FillChar(CleDoc, Sizeof(CleDoc), #0);
    CleDoc.NaturePiece := TFMul(FF).Q.FindField('GL_NATUREPIECEG').AsString;
    CleDoc.DatePiece := TFMul(FF).Q.FindField('GL_DATEPIECE').AsDateTime;
    CleDoc.Souche := TFMul(FF).Q.FindField('GL_SOUCHE').AsString;
    CleDoc.NumeroPiece := TFMul(FF).Q.FindField('GL_NUMERO').AsInteger;
    CleDoc.Indice := TFMul(FF).Q.FindField('GL_INDICEG').AsInteger;
    CleDoc.NumLigne := TFMul(FF).Q.FindField('GL_NUMLIGNE').AsInteger;

    if FORepriseOpCaisseLies(CleDoc) then
      Inc(NbOk)
    else
      Inc(NbErr);
  end;
  {****************************************************************************}
begin
  FF := TForm(Longint(Parms[0]));
  if (FF = nil) or not (FF is TFMul) then Exit;
  if (TFMul(FF).FListe.NbSelected = 0) and (not TFMul(FF).FListe.AllSelected) then Exit;

  sTexte := 'Confirmez-vous la reprise des op�rations de caisse s�lectionn�es ?';
  if PGIAsk(sTexte, FF.Caption) <> mrYes then Exit;
  NbOk := 0;
  NbErr := 0;

  if TFMul(FF).FListe.AllSelected then
  begin
    TFmul(FF).Q.First;
    while not TFmul(FF).Q.EOF do
    begin
      LanceReprise;
      TFmul(FF).Q.Next;
    end;
    TFmul(FF).FListe.AllSelected := False;
  end else
  begin
    for Ind := 0 to TFMul(FF).FListe.NbSelected - 1 do
    begin
      TFMul(FF).FListe.GotoLeBookMark(Ind);
      {$IFDEF EAGLCLIENT}
      TFMul(FF).Q.TQ.Seek(TFMul(FF).FListe.Row - 1);
      {$ENDIF}
      LanceReprise;
    end;
    TFMul(FF).FListe.ClearSelected;
    TFMul(FF).Q.First;
  end;
  sTexte := IntToStr(NbOk) + TraduireMemoire(' op�ration(s) de caisse ont �t� reprise(s) avec succ�s');
  if NbErr > 0 then
    sTexte := sTexte + '#10'+ IntToStr(NbErr) + TraduireMemoire(' op�ration(s) de caisse ont rencontr� un probl�me');
  PGIInfo(sTexte, FF.Caption);
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 16/05/2003
Modifi� le ... : 16/05/2003
Description .. : FORepriseReglementsLies = Reprise de l'historique des
Suite ........ : r�glements pour la liaison des r�glements
Suite ........ :  - Parms[0] = Cl� du document (format CleDoc)
Mots clefs ... : FO
*****************************************************************}

procedure FOAGLRepriseReglementsLies(Parms: array of variant; nb: integer);
var
  FF: TForm;
  Ind, NbOk, NbErr: integer;
  sTexte: string;
  {****************************************************************************}
  procedure LanceReprise;
  var
    CleDoc: R_CleDoc;
  begin
    FillChar(CleDoc, Sizeof(CleDoc), #0);
    CleDoc.NaturePiece := TFMul(FF).Q.FindField('GPE_NATUREPIECEG').AsString;
    CleDoc.DatePiece := TFMul(FF).Q.FindField('GPE_DATEPIECE').AsDateTime;
    CleDoc.Souche := TFMul(FF).Q.FindField('GPE_SOUCHE').AsString;
    CleDoc.NumeroPiece := TFMul(FF).Q.FindField('GPE_NUMERO').AsInteger;
    CleDoc.Indice := TFMul(FF).Q.FindField('GPE_INDICEG').AsInteger;
    CleDoc.NumLigne := TFMul(FF).Q.FindField('GPE_NUMECHE').AsInteger;

    if FORepriseReglementsLies(CleDoc) then
      Inc(NbOk)
    else
      Inc(NbErr);
  end;
  {****************************************************************************}
begin
  FF := TForm(Longint(Parms[0]));
  if (FF = nil) or not (FF is TFMul) then Exit;
  if (TFMul(FF).FListe.NbSelected = 0) and (not TFMul(FF).FListe.AllSelected) then Exit;

  sTexte := 'Confirmez-vous la reprise des r�glements s�lectionn�s ?';
  if PGIAsk(sTexte, FF.Caption) <> mrYes then Exit;
  NbOk := 0;
  NbErr := 0;

  if TFMul(FF).FListe.AllSelected then
  begin
    TFmul(FF).Q.First;
    while not TFmul(FF).Q.EOF do
    begin
      LanceReprise;
      TFmul(FF).Q.Next;
    end;
    TFmul(FF).FListe.AllSelected := False;
  end else
  begin
    for Ind := 0 to TFMul(FF).FListe.NbSelected - 1 do
    begin
      TFMul(FF).FListe.GotoLeBookMark(Ind);
      {$IFDEF EAGLCLIENT}
      TFMul(FF).Q.TQ.Seek(TFMul(FF).FListe.Row - 1);
      {$ENDIF}
      LanceReprise;
    end;
    TFMul(FF).FListe.ClearSelected;
    TFMul(FF).Q.First;
  end;
  sTexte := IntToStr(NbOk) + TraduireMemoire(' r�glement(s) ont �t� repris avec succ�s');
  if NbErr > 0 then
    sTexte := sTexte + '#10'+ IntToStr(NbErr) + TraduireMemoire(' r�glement(s) ont rencontr� un probl�me');
  PGIInfo(sTexte, FF.Caption);
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 09/07/2003
Modifi� le ... : 09/07/2003
Description .. : FOGetNatureTicket = retourne la naturte de pi�ce des 
Suite ........ : tickets
Suite ........ :  - Parms[0] = pour les tickets en attente
Suite ........ :  - Parms[1] = avec les s�parateurs SQL ("FFO")
Mots clefs ... : FO
*****************************************************************}

function FOAGLGetNatureTicket(parms: array of variant; nb: integer): variant;
var
  EnAttente, PourSql: boolean;
begin
  EnAttente := boolean(Parms[0]);
  PourSql := boolean(Parms[1]);
  Result := FOGetNatureTicket(EnAttente, PourSql);
end;

{***********A.G.L.***********************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 21/07/2003
Modifi� le ... : 21/07/2003
Description .. : Filtre les caisses avec l'�tablissement d�fini pour l'utilisateur
Suite ........ :  - Parms[0] = Fiche
Suite ........ :  - Parms[1] = Contr�le Combo pour la caisse
Suite ........ :  - Parms[2] = Contr�le Combo pour l'�tablissement
Mots clefs ... : FO
*****************************************************************}

procedure FOAGLPositionneCaisseUser(parms: array of variant; nb: integer);
var
  FF: TForm;
  CC: TComponent;
  Caisse, Etab: THValComboBox;
  Stg: string;
begin
  FF := TForm(Longint(Parms[0]));
  if FF = nil then Exit;
  Caisse := nil;
  Stg := string(parms[1]);
  if Stg <> '' then
  begin
    CC := FF.FindComponent(Stg);
    if (CC <> nil) and (CC is THValComboBox) then
      Caisse := THValComboBox(CC);
  end;
  Etab := nil;
  Stg := string(parms[2]);
  if Stg <> '' then
  begin
    CC := FF.FindComponent(Stg);
    if (CC <> nil) and (CC is THValComboBox) then
      Etab := THValComboBox(CC);
  end;
  FOPositionneCaisseUser(Caisse, Etab);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 10/12/2002
Modifi� le ... : 10/12/2002
Description .. : D�claration des fonctions pour les scripts
Mots clefs ... : FO
*****************************************************************}

procedure InitM3FrontOffice;
begin
{$IFDEF FOS5}
  RegisterAglProc('ImprimeTicketFO', FALSE, 1, FOAGLImprimeTicket);
  RegisterAglProc('FOSituationFlash', FALSE, 1, FOAGLSituationFlash);
  RegisterAglProc('FOVisu', TRUE, 0, FOAGLVisu);
  RegisterAglProc('FODebListe', TRUE, 0, FOAGLDebListe);
{$ENDIF}
  RegisterAglProc('FOSetColor', TRUE, 2, FOAGLSetFontColor);
  RegisterAglFunc('FOGetParamCaisse', FALSE, 1, FOAGLGetParamCaisse);
  RegisterAglProc('FOLibereCaisse', FALSE, 1, FOAGLLibereCaisse);
  RegisterAglProc('FOLibereMULCaisse', TRUE, 1, FOAGLLibereMULCaisse);
  RegisterAglProc('AppelEcheanceFO', FALSE, 2, FOAGLAppelEcheance);
  RegisterAglFunc('FOGetVendeur', TRUE, 5, FOAGLGetVendeur);
  RegisterAglFunc('FOTestTPE', TRUE, 1, FOAGLTestTPE);
  RegisterAglProc('FOTestAfficheur', FALSE, 1, FOAGLTestAfficheur);
  RegisterAglFunc('FOTestTiroir', TRUE, 3, FOAGLTestTiroir);
  RegisterAglFunc('FOTestImprimante', TRUE, 3, FOAGLTestImprimante);
  RegisterAglProc('FOLanceImprimeLP', TRUE, 2, FOAGLLanceImprimeLP);
  RegisterAglProc('FOLanceRecapVen', FALSE, 3, FOAGLLanceRecapVen);
  RegisterAglProc('FOAffichePhotoArt', TRUE, 2, FOAGLAffichePhotoArt);
  RegisterAglFunc('FOInPGIContexte', FALSE, 1, FOAGLInPGIContexte);
  RegisterAglFunc('FOTraduire', FALSE, 1, FOAGLTraduire);
  RegisterAglProc('FOComboDeleteValue', TRUE, 3, FOAGLComboDeleteValue);
  RegisterAglFunc('FOTypeArtAutorise', FALSE, 2, FOAGLTypeArtAutorise);
  RegisterAglFunc('FOGetSynRegKey', FALSE, 2, FOAGLGetSynRegKey);
  RegisterAglProc('FOSaveSynRegKey', FALSE, 2, FOAGLSaveSynRegKey);
  RegisterAglProc('FOMulOptions', TRUE, 2, FOAGLMulOptions);
  RegisterAglProc('FORepriseOpCaisseLies', TRUE, 0, FOAGLRepriseOpCaisseLies);
  RegisterAglProc('FORepriseReglementsLies', TRUE, 0, FOAGLRepriseReglementsLies);
  RegisterAglFunc('FOGetNatureTicket', FALSE, 2, FOAGLGetNatureTicket);
  RegisterAglProc('FOPositionneCaisseUser', TRUE, 3, FOAGLPositionneCaisseUser);
end;

initialization
  InitM3FrontOffice;

end.
