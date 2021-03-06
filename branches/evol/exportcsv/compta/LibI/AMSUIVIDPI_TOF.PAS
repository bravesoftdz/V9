{***********UNITE*************************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 04/05/2006
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : AMSUIVIDPI ()
Mots clefs ... : TOF;AMSUIVIDPI
*****************************************************************}
Unit AMSUIVIDPI_TOF ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFNDEF EAGLCLIENT}
     db,
     fe_main,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
     PrintDbg,
{$else}
     eMul,
     MaineAGL,
     UtileAGL,
{$ENDIF}
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOF,
     uTOB,
     Graphics,
     HPanel,
     Windows, // pour TRect
     Menus,
     HTB97,
     AmDPI,
     AmSyntheseDPI_TOF,
     AmnDeduction_TOF ;

Type
  TOF_AMSUIVIDPI = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
    private
      { Variables }
      fGrille: THGrid;
      fReintegration : double;
      fAmDPI : TAmDPI;
      fTImmoMvtD : TOB;
      fTRepartition : TOB;           // TOB qui alimente fGrille
      fOnSaveKeyDownEcran: procedure(Sender: TObject; var Key: Word; Shift:
                           TShiftState) of object;
      { M�thodes }
      procedure OnOperationDPIClick ( Sender : TObject);
      procedure OnOperationIMMClick ( Sender : TObject);
      procedure OnOperationIMSClick ( Sender : TObject);
      procedure OnOperationSTCClick ( Sender : TObject);
      procedure OnOperationCOOClick ( Sender : TObject);
      procedure OnOperationREIClick ( Sender : TObject);
      procedure OnSyntheseDPIClick ( Sender : TObject);
      procedure ResteDispoLigneCourante ( var Montant, Solde : double);
      function  ParametreOperationEnN (Code :string) : string ;
      function  ParametreSynthese : string ;
      function  ParametreImmobilisation : string ;
      procedure EnableZoomOperations;
      procedure OnEcranResize ( Sender : TObject);
      procedure OnChangeLargeurColonneGrille ( Sender : TObject);
      procedure OnPopUpOperation(Sender: TObject);
      procedure OnPopUpPOPS(Sender: TObject);
      procedure RAZfGrille;
      procedure OnRowEnterLigne(Sender: TObject; Ou: Integer;
                                var Cancel: Boolean; Chg: Boolean);
      procedure OnGrilleCellEnter(Sender: TObject; var ACol,ARow: Integer;
                                   var Cancel: Boolean);
      procedure OnKeyDownLigne(Sender:TObject; var Key:Word; Shift:TShiftState);
      procedure OnKeyDownEcran(Sender:TObject; var Key:Word; Shift:TShiftState);
      procedure FormaterfGrille;
      procedure GriserCellules;
      procedure InitColonneAnnee;
      procedure InitTOBfGrille;
      procedure RechargerfGrille;
      procedure CoordonneesZoneReintegration;
      procedure OnClickBImprimer(Sender: TObject);
  end ;


procedure AMLanceFiche_SuiviDPI;


Implementation

uses ImEnt,
     AMListe_TOF;

const
      COL_ANNEE   = 0;
      COL_MONT    = 1;
      COL_DEJA    = 2;
      COL_UTIL = 3;
      COL_SOLDE = 4;
      LIG_N   = 1;
      LIG_N_1   = 2;
      LIG_N_2   = 3;
      LIG_N_3   = 4;
      LIG_N_4   = 5;
      LIG_N_5   = 6;
      LIG_TOT   = 7;

 procedure AMLanceFiche_SuiviDPI;
 begin
    AGLLanceFiche('AM', 'AMSUIVIDPI','' , '', '');
 end;


 procedure TOF_AMSUIVIDPI.OnNew ;
 begin
   Inherited ;
 end ;

 procedure TOF_AMSUIVIDPI.OnDelete ;
 begin
   Inherited ;
 end ;

 procedure TOF_AMSUIVIDPI.OnUpdate ;
 begin
   Inherited ;
 end ;

 procedure TOF_AMSUIVIDPI.OnLoad ;
 begin
   Inherited ;
 end ;

{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : ON ARGUMENT de la TOF
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.OnArgument (S : String ) ;
 var VarCancel : Boolean;
 begin
   Inherited ;

   // Initialisation des champs
   Ecran.HelpContext := 0;
   fReintegration := 0;
   SetControlCaption ('mtReintegration', StrFMontant (fReintegration,15 , V_PGI.OkDecV, '' , true));
   fGrille := THGrid ( GetControl ('DPIListe') );
   CoordonneesZoneReintegration;


   // Ev�nements �cran
   TToolbarButton97(GetControl('bSynthese')).OnClick := OnSyntheseDPIClick;
   fOnSaveKeyDownEcran := Ecran.OnKeyDown;
   Ecran.OnKeyDown := OnKeyDownEcran;
   Ecran.OnResize := OnEcranResize;
   Ecran.PopupMenu := TPopupMenu(GetControl('POPS')); // pour d�router le menu clic droit

   // Ev�nements THGRID
   fGrille.OnCellEnter  := OnGrilleCellEnter;
   fGrille.OnRowEnter :=  OnRowEnterLigne;
   fGrille.OnColumnWidthsChanged := OnChangeLargeurColonneGrille;
   fGrille.OnKeyDown := OnKeyDownLigne;

   // Ev�nements Bouton Op�rations
   TPopUpMenu(GetControl('MenuOperation')).OnPopup := OnPopUpOperation;
   TMenuItem(GetControl('DeductionDPI')).OnClick := OnOperationDPIClick;
   TMenuItem(GetControl('AffectImmo')).OnClick := OnOperationIMMClick;
   TMenuItem(GetControl('AffectImmoSortie')).OnClick := OnOperationIMSClick;
   TMenuItem(GetControl('AffectStock')).OnClick := OnOperationSTCClick;
   TMenuItem(GetControl('AffectCoop')).OnClick := OnOperationCOOClick;
   TMenuItem(GetControl('Reintegration')).OnClick := OnOperationREIClick;
   TToolbarButton97(GetControl('BImprimer')).Onclick := OnClickBimprimer;

   // Ev�nements touche contextuelle F11
   TPopUpMenu(GetControl('MenuF11')).OnPopup := OnPopUpOperation;
   TMenuItem(GetControl('DeductionDPI1')).OnClick := OnOperationDPIClick;
   TMenuItem(GetControl('AffectImmo1')).OnClick := OnOperationIMMClick;
   TMenuItem(GetControl('AffectImmoSortie1')).OnClick := OnOperationIMSClick;
   TMenuItem(GetControl('AffectStock1')).OnClick := OnOperationSTCClick;
   TMenuItem(GetControl('AffectCoop1')).OnClick := OnOperationCOOClick;
   TMenuItem(GetControl('Reintegration1')).OnClick := OnOperationREIClick;
   TMenuItem(GetControl('SyntheseDPI')).OnClick := OnSyntheseDPIClick;

   // Ev�nement clic droit dans l'�cran
   TPopUpMenu(GetControl('POPS')).OnPopup := OnPopUpPOPS;

   // Initialisation du tableau
   FormaterfGrille;
   InitColonneAnnee;

   // Chargement du tableau
   InitTOBfGrille;
   RechargerfGrille;

   // Ouverture des op�rations
   OnRowEnterLigne (nil, 1, VarCancel, False);

   // Focus en provoquant un aller-retour sur le Control pr�c�dent
   NextPrevControl(Ecran);
 end ;


 procedure TOF_AMSUIVIDPI.OnClose ;
 begin
   Inherited ;
   fAmDPI.Free;
   fTImmoMvtD.Free;
   if (fTRepartition.Detail.Count <> 0 ) then fTRepartition.ClearDetail;
   fTRepartition.Free;
 end ;

 procedure TOF_AMSUIVIDPI.OnDisplay () ;
 begin
   Inherited ;
 end ;

 procedure TOF_AMSUIVIDPI.OnCancel () ;
 begin
   Inherited ;
 end ;

{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : Formatage des lignes/colonnes du THGRID
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.FormaterfGrille;
 var Masque : string;
 begin
  Masque := StrfMask(V_PGI.OkDecV, '', True);

  fGrille.ColEditables[COL_ANNEE]:=False;
  fGrille.ColWidths[COL_ANNEE]:=170;
  fGrille.ColAligns[COL_ANNEE]:=taCenter ; //tJustify;
  fGrille.Cells[COL_ANNEE,0] := TraduireMemoire('Ann�e');

  fGrille.ColEditables[COL_MONT]:= False;
  fGrille.ColTypes[COL_MONT]:='R';
  fGrille.ColFormats[COL_MONT]:=Masque;
  fGrille.ColWidths[COL_MONT]:=100;
  fGrille.ColAligns[COL_MONT]:=taRightJustify;
  fGrille.Cells[COL_MONT,0] := TraduireMemoire('Montant initial');

  fGrille.ColEditables[COL_DEJA]:= False;
  fGrille.ColTypes[COL_DEJA]:='R';
  fGrille.ColFormats[COL_DEJA]:=Masque;
  fGrille.ColWidths[COL_DEJA]:=100;
  fGrille.ColAligns[COL_DEJA]:=taRightJustify;
  fGrille.Cells[COL_DEJA,0] := TraduireMemoire('D�j� utilis�');

  fGrille.ColEditables[COL_UTIL]:= False;
  fGrille.ColTypes[COL_UTIL]:='R';
  fGrille.ColFormats[COL_UTIL]:=Masque;
  fGrille.ColWidths[COL_UTIL]:=100;
  fGrille.ColAligns[COL_UTIL]:=taRightJustify;
  fGrille.Cells[COL_UTIL,0] := TraduireMemoire('Utilisation');

  fGrille.ColEditables[COL_SOLDE]:= False;
  fGrille.ColTypes[COL_SOLDE]:='R';
  fGrille.ColFormats[COL_SOLDE]:=Masque;
  fGrille.ColWidths[COL_SOLDE]:=100;
  fGrille.ColLengths[COL_SOLDE]:=-1;
  fGrille.ColAligns[COL_SOLDE]:=taRightJustify;
  fGrille.Cells[COL_SOLDE,0] := TraduireMemoire('Solde');

  // Griser certaines cellules
  GriserCellules;

  // Curseur non positionnable sur la ligne TOTAL
  fGrille.RowLengths[LIG_TOT]:=-1;
 end;

{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : Griser les cellules qui ne sont pas alimentables
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.GriserCellules;
 begin
   fGrille.Cells[COL_DEJA,LIG_N] := '#COL#' + IntToStr(clBtnFace);
   fGrille.Cells[COL_UTIL,LIG_N] := '#COL#' + IntToStr(clBtnFace);
//   fGrille.Cells[COL_SOLDE,LIG_N_5] := '#COL#' + IntToStr(clBtnFace);
 end;

{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : Alimentation des titres de ligne du THGRID
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.InitColonneAnnee;
 var j: integer;
 begin
   fAmDPI := TAmDPI.Create;

   // R�cup dates du tableau Exercice de la class fAmDPI
   fAmDPI.ChargeDateDPI;

   for j := 0  to 5 do
   begin
      if fAmDPI.Exercice[j].Code <> '' then
         fGrille.Cells[COL_ANNEE,j+1] := fAmDPI.Exercice[j].EtatCpta // contient le libell�
      else
         fGrille.Cells[COL_ANNEE,j+1] := 'Du ' + DateToStr(fAmDPI.Exercice[j].Deb) +
                                ' au ' + DateToStr(fAmDPI.Exercice[j].Fin);
   end;

   // Derni�re ligne = TOTAL
   fGrille.Cells[0,LIG_TOT] := TraduireMemoire('TOTAL');
 end;


{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : Allocation buffers des TOB n�cessaires au THGRID :
Suite ........ : - fTImmoMvtD    aliment� par les enregs de IMMOMVTD
Suite ........ : - ftRepartition aliment� par fTImmoMvtD
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.InitTOBfGrille;
 begin
   fTImmoMvtD := TOB.Create ('',nil,-1);
   fTRepartition := TOB.Create ('',nil,-1);
 end;


{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : RAZ + Chargement des structures n�cessaires pour alimenter le THGRID :
Suite ........ : - fTImmoMvtD     s'alimente � partir des enregs de IMMOMVTD
Suite ........ : - ftRepartition  s'alimente � partir de fTImmoMvtD
Suite ........ : - fGrille        s'alimente � partir de fTRepartition
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.RechargerfGrille;
 var  Q: TQuery;
      T, TLigne: TOB;
      i,j : integer;
      sDateInv : string;
      dDateInv : TDateTime;
      Mnt, Deja, Util, Solde, nZero : Double;
      TotMnt,TotDeja,TotUtil,TotSolde : double;

 begin
   // RAZ TOBs de travail
   if (fTImmoMvtD.Detail.Count<>0) then  fTImmoMvtD.ClearDetail;
   if (fTRepartition.Detail.Count<>0) then  fTRepartition.ClearDetail;

   // Mise en TOB de la table IMMOMVTD par date d�croissante
   Q := OpenSQL('SELECT IZ_DATE,IZ_SEQUENCE,IZ_MONTANT,IZ_NATURED,IZ_IMMO,IZ_LIBELLE FROM IMMOMVTD ORDER BY IZ_DATE DESC', True);
   fTImmoMvtD.LoadDetailDB('', '', '', Q, false);
   Ferme(Q);

   // Pas de donn�es => fGrille � vider
   if (fTImmoMvtD.Detail.Count=0) then
      begin
      RAZfGrille;
      GriserCellules;
      exit;
      end;

   // Commencer au 1er exercice du tableau, c'est fAmDPI.Exercice[0]
   // car on peut avoir saisi de la DPI sur un exo dont on a ensuite annul� la cl�ture
   i := 0;
   while (fTImmoMvtD.Detail[i].GetValue('IZ_DATE') > fAmDPI.Exercice[0].Fin) do
   begin
   Inc (i);
   if i = fTImmoMvtD.Detail.Count then  Break;
   end;

   // Init variables
   //i := 0;
   //T := fTImmoMvtD.Detail[i];
   //if (T = nil) then  exit;
   if (i < fTImmoMvtD.Detail.Count) then T := fTImmoMvtD.Detail[i]
   else exit;
   TotMnt := 0.00;
   TotDeja := 0.00;
   TotUtil := 0.00;
   TotSolde := 0.00;
   nZero := Arrondi (0.00, V_PGI.OkDecV);
   fReintegration := nZero;

   // Boucler sur chaque exercice <=> sur chaque ligne de fGrille
   // et alimenter fTRepartition � partir des TOBs filles de fTImmoMvtD
   for j:=0 to 5 do
   begin
     TLigne := TOB.Create ('',fTRepartition,-1);
     Mnt := Arrondi (0.00, V_PGI.OkDecV);
     Deja := Arrondi (0.00, V_PGI.OkDecV);
     Util := Arrondi (0.00, V_PGI.OkDecV);
     //Util_N_5 := Arrondi (0.00, V_PGI.OkDecV);  // Utilisation de la ligne N-5

     // Tous les enregs du m�me exo que la ligne j+1
     while (T.GetValue('IZ_DATE') = fAmDPI.Exercice[j].Fin) do
     begin
        sDateInv := COPY (T.GetValue('IZ_LIBELLE'),0, 10);
        if (sDateInv = '') or (sDateInv = '          ') then
            dDateInv := iDate1900
        else
            dDateInv := StrToDate(sDateInv);

        // Nature = DPI <=> montants de la DPI de l'exo j
        if (T.GetValue('IZ_NATURED')='DPI')  then
           Mnt := Arrondi (Mnt + T.GetValue('IZ_MONTANT'),V_PGI.OkDecV)
        else
        begin
           if dDateInv < fAmDPI.Exercice[0].Deb  then
              // Investissement ant�rieur � l'exo en cours <=> D�j� utilis�
              Deja := Arrondi (Deja + T.GetValue('IZ_MONTANT'),V_PGI.OkDecV)
            else
              // Investissement dans l'exo en cours <=> Utilisation
              Util := Arrondi (Util + T.GetValue('IZ_MONTANT'),V_PGI.OkDecV);
        end;

        // Enreg suivant
        Inc(i);
        if (i < fTImmoMvtD.Detail.Count) then T := fTImmoMvtD.Detail[i]
        else  T:= nil;
        if (T=nil) then Break;
     end; // while

     // Forcer champs gris�s � z�ro et calculer la colonne Solde
     case (j+1) of
     LIG_N :   begin
               Deja := nZero;
               Util := nZero;
               Solde := Arrondi ((Mnt-Deja-Util), V_PGI.OkDecV);
               end;
//     LIG_N_5 : begin
//               Solde := nZero;
//               Util_N_5 := Util;
//               end;
     else      begin
               Solde := Arrondi ((Mnt-Deja-Util), V_PGI.OkDecV);
               if (j+1)=LIG_N_5 then fReintegration := Solde;
               end
     end;

     // Ajouter les champs dans la TOB TLigne de la ligne j+1
     TLigne.AddChampSupValeur('EXO', fGrille.Cells[COL_ANNEE, j+1]);
     TLigne.AddChampSupValeur('MONTANT', Mnt);
     TLigne.AddChampSupValeur('DEJA', Deja);
     TLigne.AddChampSupValeur('UTIL', Util);
     TLigne.AddChampSupValeur('SOLDE', Solde);

     // Totaliser
     TotMnt :=  Arrondi (TotMnt + Mnt, V_PGI.OkDecV);
     TotDeja :=  Arrondi (TotDeja + Deja, V_PGI.OkDecV);
     TotUtil :=  Arrondi (TotUtil + Util, V_PGI.OkDecV);
     TotSolde :=  Arrondi (TotSolde + Solde, V_PGI.OkDecV);

     // Sortir de la boucle si on a tout d�roul� fTImmoMvtD
     if (T=nil) then Break;
   end; // for

   // Compl�ter fGrille � 6 lignes si sortie par Break de la boucle for
   for i:=j+1 to 5 do
   begin
     TLigne := TOB.Create ('', fTRepartition,-1);
     TLigne.AddChampSupValeur('EXO', fGrille.Cells[COL_ANNEE, i+1]);
     TLigne.AddChampSupValeur('MONTANT', nZero);
     TLigne.AddChampSupValeur('DEJA', nZero);
     TLigne.AddChampSupValeur('UTIL', nZero);
     TLigne.AddChampSupValeur('SOLDE', nZero);
   end;

   // Ajout ligne TOTAL � fGrille
   TLigne := TOB.Create ('',fTRepartition,-1);
   TLigne.AddChampSupValeur('EXO', fGrille.Cells[COL_ANNEE, LIG_TOT]);
   TLigne.AddChampSupValeur('MONTANT', TotMnt);
   TLigne.AddChampSupValeur('DEJA', TotDeja);
   TLigne.AddChampSupValeur('UTIL', TotUtil);
   TLigne.AddChampSupValeur('SOLDE', Arrondi ((TotMnt-TotDeja-TotUtil), V_PGI.OkDecV));

   // Alimenter fGrille avec les TOBs TLigne filles de fTRepartition
   fTRepartition.PutGridDetail(fGrille,False,False,'EXO;MONTANT;DEJA;UTIL;SOLDE');

   // Re-Griser certaines cellules
   GriserCellules;

   // Montant r�int�gration � effectuer
   //fReintegration := Arrondi ((TotMnt - TotDeja - Util_N_5), V_PGI.OkDecV);
   SetControlCaption ('mtReintegration', StrFMontant (fReintegration,15 , V_PGI.OkDecV, '' , true));
 end;

{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : RAZ de tous les montants de la grille avant rafraichissement
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.RAZfGrille;
 begin
 fGrille.CleanUpInstance;
 fReintegration := Arrondi (0.00, V_PGI.OkDecV);
 SetControlCaption ('mtReintegration', StrFMontant (fReintegration,15 , V_PGI.OkDecV, '' , true));
{   for i := 1 to fGrille.RowCount-1 do
   begin
     fGrille.Cells[COL_MONT, i] := StrfMontant (0.00 , 15 , V_PGI.OkDecV, '' , true);
     fGrille.Cells[COL_DEJA, i] := StrfMontant (0.00 , 15 , V_PGI.OkDecV, '' , true);
     fGrille.Cells[COL_UTIL, i] := StrfMontant (0.00 , 15 , V_PGI.OkDecV, '' , true);
     fGrille.Cells[COL_SOLDE, i] := StrfMontant (0.00 , 15 , V_PGI.OkDecV, '' , true);
   end;}
 end;

 procedure TOF_AMSUIVIDPI.OnPopUpOperation(Sender: TObject);
 begin
   //fEnableLigne := (fGrille.Row <> LIG_N);

   TMenuItem(GetControl('DeductionDPI')).Caption := 'D�duction pour investissement'; // de l''exercice ' +
                                                    //fGrille.Cells[COL_ANNEE, fGrille.Row];
   TMenuItem(GetControl('DeductionDPI1')).Caption := 'D�duction pour investissement'; // de l''exercice ' +
                                                    //fGrille.Cells[COL_ANNEE, fGrille.Row];
   EnableZoomOperations;
 end;


{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 05/06/2006
Modifi� le ... :   /  /
Description .. : Boycott du menu de contexte applicatif ouvert sur le clic droit
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.OnPopUpPOPS(Sender: TObject);
 begin
 // Rien
 end;


{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : Param�tre pass� en entr�e des fonctions d'op�rations
Description .. : En entr�e : code op�ration
Suite ........ : 06/06 Concerne toute op�ration de l'exo N => colonne Utilisation
Mots clefs ... :
*****************************************************************}
 function TOF_AMSUIVIDPI.ParametreOperationEnN (Code :string) : string ;
 var sSepar: string;
     Montant,Solde : double;
     lEncours, i : integer;
 begin
   lEncours := fGrille.Row;
   sSepar := ';';

   // R�cup solde disponible pour l'op�ration :
   // <=> cumul soldes des lignes des exos ant�rieurs � celui de la ligne courante

 { //       + solde exo de la ligne en cours
   if (fTRepartition.Detail.Count <> 0) then
     begin
     for i := (lEncours-1) to (LIG_N_5-1) do
       Solde := Arrondi ((Solde + fTRepartition.Detail[i].GetValue('SOLDE')), V_PGI.OkDecV);
     end; }

   ResteDispoLigneCourante (Montant, Solde);

   // R�cup dates des 6 exos
   for i := 0 to 5 do
     result := result + DateToStr(fAmDPI.Exercice[i].Deb) +
               sSepar + DateToStr(fAmDPI.Exercice[i].Fin) + sSepar;

   // Param�tre d'appel = nature d�duction;
   //                     solde;
   //                     d�but exo N;   fin exo N;
   //                     d�but exo N-1; fin exo N-1;
   //                     d�but exo N-2; fin exo N-2;
   //                     d�but exo N-3; fin exo N-3;
   //                     d�but exo N-4; fin exo N-4;
   //                     d�but exo N-5; fin exo N-5;
   //                     d�but exo ligne courante; fin exo ligne courante;
   result := Code + sSepar + FloatToStr(Solde) + sSepar + result +
                      DateToStr(fAmDPI.Exercice[lEncours-1].Deb) +
             sSepar + DateToStr(fAmDPI.Exercice[lEncours-1].Fin) ;
//PGIInfo (result, 'Param�tre d''appel Op�ration');
 end;


{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 12/05/2006
Modifi� le ... :   /  /
Description .. : Param�tre pass� en entr�e de la fonction de synth�se des DPI
Suite ........ :
Mots clefs ... :
*****************************************************************}
 function TOF_AMSUIVIDPI.ParametreSynthese : string ;
 var sSepar: string;
     i, lEncours : integer;
 begin
   lEncours := fGrille.Row;
   sSepar := ';';

   // R�cup dates des 6 exos
   for i := 0 to 5 do
     result := result + DateToStr(fAmDPI.Exercice[i].Deb) +
               sSepar + DateToStr(fAmDPI.Exercice[i].Fin) + sSepar;

   // Param�tre d'appel = d�but exo N;   fin exo N;
   //                     d�but exo N-1; fin exo N-1;
   //                     d�but exo N-2; fin exo N-2;
   //                     d�but exo N-3; fin exo N-3;
   //                     d�but exo N-4; fin exo N-4;
   //                     d�but exo N-5; fin exo N-5;
   //                     d�but exo ligne courante; fin exo ligne courante
   result := result + DateToStr(fAmDPI.Exercice[lEncours-1].Deb) +
             sSepar + DateToStr(fAmDPI.Exercice[lEncours-1].Fin);

//PGIInfo (result, 'Param�tre d''appel Synth�se');
 end;

{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 21/06/2006
Modifi� le ... :   /  /
Description .. : Param�tre pass� en entr�e de l'affectation � une immo <=> � la liste des immos
Suite ........ :
Mots clefs ... :
*****************************************************************}
 function TOF_AMSUIVIDPI.ParametreImmobilisation : string ;
 var sSepar, stDatesExo, stSoldes: string;
     lEncours, i : integer;
     Montant, Solde : double;
 begin
   lEncours := fGrille.Row;
   sSepar := ';';
   Solde := Arrondi (0.00, V_PGI.OkDecV);
   stDatesExo := '';
   stSoldes := '';

   // R�cup solde ligne en cours
   //if (fTRepartition.Detail.Count <> 0) then
   //   Solde := fTRepartition.Detail[lEncours-1].GetValue('SOLDE');
   //Solde := Valeur (fGrille.Cells[COL_SOLDE, lEncours]);

   // R�cup Solde exos ant�rieurs � la ligne courante
   ResteDispoLigneCourante (Montant, Solde);

   // R�cup dates et soldes 5 exos N-1 � N-5
   for i := 1 to 5 do
     begin
     stDatesExo := stDatesExo + DateToStr(fAmDPI.Exercice[i].Deb) +
                   sSepar + DateToStr(fAmDPI.Exercice[i].Fin) + sSepar;
     stSoldes := stSoldes + FloatToStr(Valeur(fGrille.Cells[COL_SOLDE, i+1]))+ sSepar;
     end;

   // Param�tre d'appel = d�but exo ligne courante; fin exo ligne courante
   //                     solde de la ligne courante;
   //    +
   //                     d�but exo N-1; fin exo N-1;
   //                     d�but exo N-2; fin exo N-2;
   //                     d�but exo N-3; fin exo N-3;
   //                     d�but exo N-4; fin exo N-4;
   //                     d�but exo N-5; fin exo N-5;
   //    +
   //                     solde N-1;
   //                     solde N-2;
   //                     solde N-3;
   //                     solde N-4;
   //                     solde N-5;

   result := DateToStr(fAmDPI.Exercice[lEncours-1].Deb) +
             sSepar + DateToStr(fAmDPI.Exercice[lEncours-1].Fin)+
             sSepar + FloatToStr(Solde) + sSepar +
             stDatesExo + stSoldes;
             //sSepar + FloatToStr(Solde) + sSepar +

//PGIInfo (result, 'Param�tre d''appel Liste des immos');
 end;


{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : Sous-menu Op�ration = D�duction pour investissement
Suite ........ : 06/06 Saisir la DPI de l'ann�e de la ligne courante
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.OnOperationDPIClick(Sender: TObject);
 var stCode, mr: string;
 begin
   stCode := ParametreOperationEnN ('DPI');
   mr := AMLanceFiche_MontantDPI(stCode);

   if mr = IntToStr (mrYes) then
      RechargerfGrille;
 end;

{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : Sous-menu Op�ration = Affectation � une immo
Suite ........ : 06/06 Appel liste des immos
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.OnOperationIMMClick(Sender: TObject);
 var ParamDPI: string;
 begin
   // Ann�e de la ligne courante + solde disponible
   ParamDPI := ParametreImmobilisation;
   // Appel liste des immos
   AMLanceFiche_ListeDesImmobilisations ('', False, taModif, '', ParamDPI);
//AMLanceFiche_ListeDesImmobilisations ('', False, taModif, '');

    RechargerfGrille;
 end;

{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : Sous-menu Op�ration = Affectation � une immo sortie
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.OnOperationIMSClick(Sender: TObject);
 var stCode, mr: string;
 begin
   mr := IntToStr (mrYes);
   stCode := ParametreOperationEnN ('IMS');

//PGIInfo ('Affectation � une immo SORTIE', 'Suivi des DPI');
   mr := AMLanceFiche_MontantDPI(stCode);

   if mr = IntToStr (mrYes) then
      RechargerfGrille;
 end;

{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : Sous-menu Op�ration = Affectation aux stocks
Suite ........ : 06/06 Ligne courante N, on utilise en N des DPI d'exos ant�rieurs � N
Suite ........ : => colonne Utilisation
Suite ........ : Ligne courante N-i, on a utilis� dans un exo avant N la DPI N-i
Suite ........ : => colonne D�j� utilis�
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.OnOperationSTCClick(Sender: TObject);
 var stCode, mr: string;
 begin
   stCode := ParametreOperationEnN ('STC');

   if (fGrille.Row = LIG_N) then
      // Utilisation en N des DPI ant�rieures
      mr := AMLanceFiche_MontantDPI(stCode)
   else
      // Utilisation de la DPI de la ligne courante
      mr := AMLanceFiche_MontantDPI(stCode);

   if mr = IntToStr (mrYes) then
      RechargerfGrille;
 end;

{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : Sous-menu Op�ration = Affectation aux parts de coop�ratives agricoles
Suite ........ : 06/06 Si ligne courante N, on utilise en N des DPI d'exos ant�rieurs � N
Suite ........ : => colonne Utilisation
Suite ........ : Si ligne courante N-i, on a utilis� dans un exo avant N la DPI N-i
Suite ........ : => colonne D�j� utilis�
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.OnOperationCOOClick(Sender: TObject);
 var stCode, mr: string;
 begin
   stCode := ParametreOperationEnN ('COO');

   if (fGrille.Row = LIG_N) then
      // Utilisation en N des DPI ant�rieures
      mr := AMLanceFiche_MontantDPI(stCode)
   else
      // Utilisation de la DPI de la ligne courante
      mr := AMLanceFiche_MontantDPI(stCode);

   if mr = IntToStr (mrYes) then
      RechargerfGrille;
 end;

{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : Sous-menu Op�ration = R�int�gration anticip�e
Suite ........ : 06/06 Si ligne courante N, on utilise en N des DPI d'exos ant�rieurs � N
Suite ........ : => colonne Utilisation
Suite ........ : Si ligne courante N-i, on a utilis� dans un exo avant N la DPI N-i
Suite ........ : => colonne D�j� utilis�
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.OnOperationREIClick(Sender: TObject);
 var stCode, mr: string;
 begin
   stCode := ParametreOperationEnN ('REI');

   if (fGrille.Row = LIG_N) then
      // Utilisation en N des DPI ant�rieures
      mr := AMLanceFiche_MontantDPI(stCode)
   else
      // Utilisation de la DPI de la ligne courante
      mr := AMLanceFiche_MontantDPI(stCode);

   if mr = IntToStr (mrYes) then
      RechargerfGrille;
 end;


{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 12/05/2006
Modifi� le ... :   /  /
Description .. : Bouton Synth�se des DPI
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.OnSyntheseDPIClick(Sender: TObject);
 var stParam, mr: string;
 begin
   mr := IntToStr (mrYes);
   stParam := ParametreSynthese;

   AMLanceFiche_SyntheseDPI(stParam);
   if mr = IntToStr (mrYes) then
      RechargerfGrille;
 end;


{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : Clic sur une ligne du THGRID
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.OnRowEnterLigne(Sender: TObject; Ou: Integer;
 var Cancel: Boolean; Chg: Boolean);
 begin
   //fEnableLigne := (Ou <> LIG_N);
   EnableZoomOperations;

   // Bulle d'aide sur le bouton Op�ration
   TToolbarButton97(GetControl('bOperation')).Hint := 'Op�rations de l''exercice '+fGrille.Cells[COL_ANNEE, fGrille.Row];
 end;

{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : Toutes op�rations visibles sur les lignes des exos < exo en cours
Suite ........ : Ligne de l'exo en cours, 1 seule op�ration(D�duction pour investissement)
Suite ........ : 06/06 Toutes op�rations visibles sur toutes les lignes
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.EnableZoomOperations;
// var  Montant, Solde : double;
 begin
  // Calcul montant initial existe dans les lignes des exos ant�rieurs
  // � celui de la ligne en cours
  //ResteDispoLigneCourante (Montant, Solde);

  // Menu Op�rations toujours visible
  //SetControlVisible('AffectImmo', (fEnableLigne = True) and (Montant <> 0) );
  //SetControlVisible('AffectImmoSortie', (fEnableLigne = True) and (Montant <> 0));
  //SetControlVisible('AffectStock', (fEnableLigne = True) and (Montant <> 0));
  //SetControlVisible('AffectCoop', (fEnableLigne = True) and (Montant <> 0));
  //SetControlVisible('Reintegration', (fEnableLigne = True) and (Montant <> 0));

  // Menu F11
  //SetControlVisible('AffectImmo1', (fEnableLigne = True) and (Montant <> 0));
  //SetControlVisible('AffectImmoSortie1', (fEnableLigne = True) and (Montant <> 0));
  //SetControlVisible('AffectStock1', (fEnableLigne = True) and (Montant <> 0));
  //SetControlVisible('AffectCoop1', (fEnableLigne = True) and (Montant <> 0));
  //SetControlVisible('Reintegration1', (fEnableLigne = True) and (Montant <> 0));
 end;


 procedure TOF_AMSUIVIDPI.ResteDispoLigneCourante ( var Montant, Solde : double);
 var i : integer;
 begin
   Montant := Arrondi (0.00, V_PGI.OkDecV);
   Solde := Arrondi (0.00, V_PGI.OkDecV);

   // Cumul montant initial et cumul solde dans les lignes des exos ant�rieurs
   // � celui de la ligne en cours
   if (fTRepartition.Detail.Count <> 0) then
     begin
     for i := fGrille.Row to (LIG_N_5-1) do
       begin
       Montant := Arrondi ((Montant + fTRepartition.Detail[i].GetValue('MONTANT')), V_PGI.OkDecV);
       Solde := Arrondi ((Solde + fTRepartition.Detail[i].GetValue('SOLDE')), V_PGI.OkDecV);
       end;
     end;
 end;


 // ATTENTION :
 // ACol, ARow repr�sentent la cellule qu'on quitte et pas celle qu'on a cliqu�
 procedure TOF_AMSUIVIDPI.OnGrilleCellEnter(Sender: TObject; var ACol, ARow: Integer;
          var Cancel: Boolean);
 begin
   Inherited;
 end;


{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /
Description .. : Touche actionn�e � partir d'une ligne du THGRID
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.OnKeyDownLigne(Sender: TObject; var Key: Word;
           Shift: TShiftState);
 begin
  case Key of
  VK_INSERT: begin
             Key := 0;
             //fEnableLigne := (fGrille.Row <> LIG_N);
             EnableZoomOperations;
             TPopupMenu(GetControl('MenuOperation')).Popup(Mouse.CursorPos.x,
                        Mouse.CursorPos.y);
             end;
  VK_F11:    begin
             Key := 0;
             //fEnableLigne := (fGrille.Row <> LIG_N);
             EnableZoomOperations;
             TPopupMenu(GetControl('MenuF11')).Popup(Mouse.CursorPos.x,
                        Mouse.CursorPos.y);
             end;
  VK_F5:     begin
             Key := 0;
             TToolbarButton97(GetControl('bSynthese')).Click;
             end;
  end;
 end;


{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :
Description .. : Touche actionn�e � partir de l'�cran
Mots clefs ... :
*****************************************************************}
 procedure TOF_AMSUIVIDPI.OnKeyDownEcran(Sender:TObject; var Key:Word; Shift:TShiftState);
 begin
  case Key of
  VK_F5 : begin
          Key := 0;
          TToolbarButton97(GetControl('bSynthese')).Click;
          end;
  else
          fOnSaveKeyDownEcran(Sender, Key, Shift);
  end;
 end;



{***********A.G.L.***********************************************
Auteur  ...... : Bernadette Tyn�vez
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /    
Description .. : Retaillage de l'�cran par l'utilisateur
Mots clefs ... : 
*****************************************************************}
 procedure TOF_AMSUIVIDPI.OnEcranResize(Sender: TObject);
 begin
  inherited;
  CoordonneesZoneReintegration;
 end;

 procedure TOF_AMSUIVIDPI.OnChangeLargeurColonneGrille(Sender: TObject);
 begin
  inherited;
  CoordonneesZoneReintegration;
 end;

 procedure TOF_AMSUIVIDPI.CoordonneesZoneReintegration;
 var mtR : THLabel ;
     PR : THPanel;
     i , PositionG,PositionW : integer;
     R : TRect;
 begin
  // R�cup position et largeur de la colonne Utilisation
  R := FGrille.CellRect(COL_UTIL,0) ;
  PositionG := R.Left;
  PositionW := R.Right - R.Left + 1;

  // Aligner MtReintegration avec la colonne Utilisation
  PR := THPanel ( GetControl ('PREINTEGRATION') );
  if PR <> nil then
  begin
    for i := 0 to PR.ControlCount - 1 do
    begin
      if PR.Controls[i] is THLabel then
      begin
        mtR := THLabel ( PR.Controls[i] );
        if mtR.Name = 'MTREINTEGRATION' then
           begin
           mtR.Left := PositionG;
           mtR.Width := PositionW;
           mtR.Alignment := taRightJustify;
           end;
      end;
    end;
  end;
 end;

procedure TOF_AMSUIVIDPI.OnClickBImprimer(Sender: TObject);
Var
  Titre : String ;
begin
  Titre := TraduireMemoire('D�ductions pour investissement au ') + DateToStr(VHImmo^.EnCours.Fin);

  // Ligne suppl�mentaire pour pr�senter les r�int�grations
  FGrille.CellValues[COL_ANNEE,fGrille.RowCount]:= 'R�int�grations � effectuer';
  FGrille.CellValues[COL_UTIL, fGrille.RowCount]:= StrFMontant(fReintegration,15,V_PGI.OkDecV,'',True);
  fGrille.RowCount := fGrille.RowCount + 1;

 {$IFDEF EAGLCLIENT}
     PrintDBGrid(Titre, FGrille.ListeParam, '', '');
 {$ELSE}
     PrintDBGrid(FGrille, nil, Titre, '') ;
 {$ENDIF}

  // Retirer la ligne suppl�mentaire
  fGrille.RowCount := fGrille.RowCount - 1;
end;



Initialization
  registerclasses ( [ TOF_AMSUIVIDPI ] ) ;
end.
