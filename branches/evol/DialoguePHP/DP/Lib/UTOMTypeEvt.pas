{***********UNITE*************************************************
Auteur  ...... : BM
Cr�� le ...... : 05/11/2002
Modifi� le ... :   /  /
Description .. : Source TOM G�n�rique et TOM h�ritantes pour les
                 TABLES : TOM_JUFORMEJUR, TOM_JUTYPECIVIL,
                 TOM_JUTYPEEVT, TOM_JUTYPEPER
Mots clefs ... : TOM;JUFORMEJUR;JUTYPECIVIL;JUTYPEEVT;JUTYPEPER
*****************************************************************}

Unit UTOMTypeEvt;
//////////////////////////////////////////////////////////////////
Interface
//////////////////////////////////////////////////////////////////
Uses
{$IFDEF EAGLCLIENT}
     MaineAGL,
{$ELSE}
     db, fe_main, 
{$ENDIF}
     Utob,
     Classes,
     SysUtils, HMsgBox, Controls, ubob, hctrls, htb97, Hent1,
     UTOMTypeParam;
//////////////////////////////////////////////////////////////////
Type
   TOM_JUTYPEEVT   = Class (TOM_TYPEPARAM)
      private
         sFamilleEvt_c, sDomaineAct_c : string;

         function  AgendaRecherche ( sFamilleEvt_p : String ) : boolean;
         procedure AgendaInit;
         procedure FiltreInitialiser ( bAgenda_p : boolean ) ;
      public
         procedure OnArgument ( sParams_p : String )   ; override;
         procedure OnNewRecord                ; override;
         procedure OnLoadRecord                        ; override;
         procedure OnChangeField (F : TField) ; override;
         procedure OnDeleteRecord                      ; override;
         procedure OnClickRepriseStd (Sender:TObject);         // $$$JP 02/10/2003: pour reprise enreg. standard par bob

         function  RepriseTypeActivite:integer; // $$$ JP 18/04/07 // $$$ JP 07/10/2003
   end ;
//////////////////////////////////////////////////////////////////
procedure DPLance_TypeActivite;

//////////////////////////////////////////////////////////////////
Implementation

uses UTOM
     {$IFDEF GALDISPATCH}
     ,galMenuDisp
     {$ENDIF}
     ; // $$$ JP 18/04/07

//////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : B.MERIAUX
Cr�� le ...... : 21/10/2003
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure DPLance_TypeActivite;
begin
{ Exemples de param�tres :
   'DOMAINEACT=JUR'
   'DOMAINEACT='
   'FAMEVT=ACT'
   'FAMEVT=DOC|REU|TAC'
   'DOMAINEACT=;FAMEVT=ACT'
}
   AGLLanceFiche('JUR', 'TYPEEVENEMENT', '', '', 'DOMAINEACT=;FAMEVT=ACT');
end;

//////////////////////////////////////////////////////////////////

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : B.MERIAUX
Cr�� le ...... : 21/10/2003
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
{ Exemples de param�tres :
   'DOMAINEACT=JUR'
   'DOMAINEACT='
   'FAMEVT=ACT'
   'FAMEVT=DOC|REU|TAC'
   'DOMAINEACT=;FAMEVT=ACT'
}
procedure TOM_JUTYPEEVT.OnArgument ( sParams_p : String ) ;
var
   bAgenda_l : boolean;
   sParams_l : string;
begin
   Inherited ;
   sParams_l := sParams_p;
   sDomaineAct_c := ReadToKenPipe(sParams_l, 'DOMAINEACT='); //JUR
   sDomaineAct_c := ReadTokenSt(sParams_l); //JUR
   sFamilleEvt_c := ReadToKenPipe(sParams_p, 'FAMEVT='); //JUR
   sFamilleEvt_c := ReadToKenSt(sParams_p); //JUR

   bAgenda_l := AgendaRecherche( sFamilleEvt_c );
   FiltreInitialiser( bAgenda_l );
   if bAgenda_l then
      AgendaInit;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : B.MERIAUX
Cr�� le ...... : 21/10/2003
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOM_JUTYPEEVT.OnNewRecord ;
begin
     inherited;

     SetField ('JTE_DOMAINEACT', sDomaineAct_c);
     if sFamilleEvt_c <> '' then
        SetField ('JTE_FAMEVT', sFamilleEvt_c);
end ;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : JP
Cr�� le ...... : 03/10/2003
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOM_JUTYPEEVT.OnLoadRecord;
begin
   inherited;
   if sFamilleEvt_c = 'ACT' then
   begin
      Ecran.Caption := 'Type d''activit� (agenda) : ' + GetField ('JTE_CODEEVT') + ' - ' + GetField ('JTE_EVTLIBABREGE');
      sTypeElement_f := 'd''activit�';
   end
   else
   begin
      Ecran.Caption := 'Type d''�v�nement : ' + GetField ('JTE_CODEEVT') + ' - ' + GetField ('JTE_EVTLIBELLE');
      sTypeElement_f := 'd''�v�nement';
   end;
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 06/10/02
Proc�dure .... : OnChangeField
Description .. : En mode cr�ation, ajout d'un caract�re sp�cial
                 au code
Param�tres ... :
*****************************************************************}

procedure TOM_JUTYPEEVT.OnChangeField (F: TField);
var
   bFamAct_l, bFamTra_l :boolean;
   strFieldName         :string;
   strFieldValue        :string;
begin
     // $$$ JP - apparement, en EAGL, pb sur cette variable lorsqu'on utilise la fonction GetField
     strFieldName  := F.FieldName;
     strFieldValue := F.Value;

     inherited ;

     // $$$JP 19/09/03: libell� abr�g� = 35 premiers car. du libell�
     if strFieldName = 'JTE_EVTLIBELLE' then
     begin
          if DS.State <> dsBrowse then
             SetField ('JTE_EVTLIBABREGE', Copy (strFieldValue {F.Value}, 1, 35))
     end
     else if strFieldName = 'JTE_FAMEVT' then
     begin
          bFamAct_l := (strFieldValue = 'ACT');
          bFamTra_l := (strFieldValue = 'TRA');

          SetControlVisible ('JTE_LIENPER', not (bFamAct_l or bFamTra_l));
          SetControlVisible ('JTE_LIENDOS', not (bFamAct_l or bFamTra_l));
          SetControlVisible ('JTE_LIENOP', not (bFamAct_l or bFamTra_l));
          SetControlVisible ('JTE_URGENCE', not (bFamAct_l or bFamTra_l));
          SetControlVisible ('TJTE_URGENCE', not (bFamAct_l or bFamTra_l));

          SetControlVisible ('JTE_CODEARTICLE', bFamAct_l);
          SetControlVisible ('TJTE_CODEARTICLE', bFamAct_l);
          SetControlVisible ('JTE_EXTERNE', bFamAct_l);
          SetControlVisible ('JTE_ABSENCE', bFamAct_l);
          SetControlVisible ('JTE_LIEU', bFamAct_l);
          SetControlVisible ('TJTE_LIEU', bFamAct_l);
          if GetField ('JTE_ABSENCE') = 'X' then
          begin
               SetControlVisible ('JTE_AFFAIRE', bFamAct_l);
               SetControlVisible ('TJTE_AFFAIRE', bFamAct_l);
          end
          else
          begin
               SetControlVisible ('JTE_AFFAIRE', FALSE);
               SetControlVisible ('TJTE_AFFAIRE', FALSE);
          end;
     end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : B. MERIAUX
Cr�� le ...... : 21/07/2003
Modifi� le ... : 21/07/2003
Description .. : controle des liens avec  la table JUTYPEEVT et Gestion
Suite ........ : des codes obligatoires
Mots clefs ... :
*****************************************************************}
procedure TOM_JUTYPEEVT.OnDeleteRecord;
var
   sTitre_l, sCodeCont_l : string;
begin
   Inherited;
   sCodeCont_l := GetField( sCodeChamp_f );
   if TypeParamUtilise( 'JEV_CODEEVT', 'JUEVENEMENT', sCodeCont_l, sTitre_l ) then
   begin
      PGIBox('Suppression interdite, ce type ' + sTypeElement_f + ' est utilis�.', sTitre_l );
      Lasterror := 1;
      Exit;
   end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : B. MERIAUX
Cr�� le ...... : 22/07/2003
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOM_JUTYPEEVT.OnClickRepriseStd (Sender:TObject);
begin
     // Si confirmation, on reprend les donn�es standard dans la table JUTYPEEVT
     if PgiAsk ('Confirmez-vous la reprise des types d''activit� standards ?') = mrYes then
     begin
          // Si en �dition/insertion, on annule...
          if DS.State in [dsEdit, dsInsert] then
             DS.Cancel;

          // Reprise du fichier ascii des standards (.tob)
          // $$$ JP 18/04/07: et rafraichissement si au moins un type d'activit� lu
{$IFDEF GALDISPATCH}
          if RepriseTypeActivite > 0 then
             GalDispatch (76355); // $$$ JP 18/04/07: marche pas en eagl 7 // DS.Refresh;
{$ENDIF}
     end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : B.MERIAUX
Cr�� le ...... : 21/10/2003
Modifi� le ... :   /  /    
Description .. : R�cup�re les crit�res de lancement de la fiche type d'�v�nement
Mots clefs ... :
*****************************************************************}
function TOM_JUTYPEEVT.AgendaRecherche ( sFamilleEvt_p : String ) : boolean;
var
   sCritere_l : string;
   bAgenda_l : boolean;
begin
   bAgenda_l := false;
   bCodeModifiable_f := true;   
   sCritere_l := Trim(ReadTokenPipe(sFamilleEvt_p, '|'));
   while (sCritere_l <> '') and ( not bAgenda_l ) do
   begin
      if (sCritere_l = 'ACT') then
      begin
         sFamilleEvt_c := 'ACT';
         bAgenda_l := true;
         bCodeModifiable_f := false;
      end;
      sCritere_l := Trim(ReadTokenPipe(sFamilleEvt_p, '|'));
   end;
   result := bAgenda_l;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : B.MERIAUX
Cr�� le ...... : 22/10/2003
Modifi� le ... :   /  /
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOM_JUTYPEEVT.FiltreInitialiser (bAgenda_p:boolean);
var
   sFiltreTablette_l, sFiltreListe_l : string;
begin
   // $$$JP 02/10/2003: si pas profil activit� d'agenda (ACT), il ne faut pas les voir
   if not bAgenda_p then
   begin
        sFiltreTablette_l := ' AND CC_CODE<>"ACT"';
        sFiltreListe_l    := 'JTE_FAMEVT<>''ACT''';
   end
   else
   begin
        sFiltreTablette_l := ' AND CC_CODE="ACT"';
        sFiltreListe_l    := 'JTE_FAMEVT=''ACT''';
   end;

   SetControlProperty ('JTE_FAMEVT', 'Plus', sFiltreTablette_l);
   FiltreActiver      (sFiltreListe_l);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : JP
Cr�� le ...... : 7/10/2003
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
function TOM_JUTYPEEVT.RepriseTypeActivite:integer; // $$$ JP 07/10/2003 // $$$ JP 18/04/07
var
   TOBTypes    :TOB;
   TOBUnType   :TOB;
   i, iNoLoad  :integer;
   bNoLoad     :boolean;
begin
   Result  := 0; // $$$ JP 18/04/07
   iNoLoad := 0;
   bNoLoad := TRUE;
   TOBTypes := TOB.Create ('', nil, -1);
   try
      TOBTypes.LoadDetailFile (ChangeStdDatPath ('$STD\BUREAU\JUTYPEEVT500.TOB', True)); // RepLocal + '\BOB\DPS5\JUTYPEEVT500.TOB');
      if TOBTypes.Detail.Count = 0 then
          iNoLoad := -1
      else
      begin
           for i := 0 to TOBTypes.Detail.Count-1 do
           begin
               TOBUnType := TOBTypes.Detail [i];
               if ExisteSQL ('SELECT JTE_CODEEVT FROM JUTYPEEVT WHERE JTE_CODEEVT="' + TOBUnType.GetValue ('JTE_CODEEVT') + '"') = FALSE then
               begin
                    TOBUnType.InsertDB (nil);
                    bNoLoad := FALSE;
               end
               else
                   iNoLoad := iNoLoad + 1;
           end;
           Result := TOBTypes.Detail.Count - iNoLoad;
      end;
   finally
          TOBTypes.Free;
          if bNoLoad = TRUE then
              if iNoLoad = -1 then
                  PgiInfo ('Types d''activit� standard non repris (fichierJUTYPEEVT500.BOB introuvable ou illisible)')
              else
                  PgiInfo ('Aucun type d''activit� standard repris, car ils existent d�j�')
          else
              if iNoLoad > 0 then
                 if iNoLoad > 1 then
                     PgiInfo (IntToStr (iNoLoad) + ' types d''activit� standard non repris car ils existent d�j�')
                 else
                     PgiInfo (IntToStr (iNoLoad) + ' type d''activit� standard non repris car il existe d�j�')
              else
                  PgiInfo ('Tous les types d''activit� standard ont �t� repris');
   end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : B.MERIAUX
Cr�� le ...... : 21/10/2003
Modifi� le ... :   /  /
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOM_JUTYPEEVT.AgendaInit;
begin
   SetControlProperty ('JTE_CODEARTICLE', 'Plus', 'AND GA_TYPEARTICLE="PRE"');
   SetControlVisible ('BREPRISESTD', TRUE);
   TToolbarButton97 (GetControl ('BREPRISESTD')).OnClick := OnClickRepriseStd;

   // Propose de charger le bob des pr�d�finis STD
   if ExisteSQL ('SELECT JTE_CODEEVT FROM JUTYPEEVT WHERE JTE_FAMEVT="ACT"') = FALSE then
       if PgiAsk ('Il n''existe aucun type d''activit� agenda' + #10 + ' D�sirez-vous reprendre les standards CEGID?') = mrYes then
           RepriseTypeActivite
       else
          PgiInfo ('Il n''existe aucun type d''activit� agenda. Vous devez imp�rativement en cr�er pour pouvoir utiliser le module agenda');
end;

//////////////////////////////////////////////////////////////////

Initialization
   registerclasses ( [ TOM_JUTYPEEVT ] ) ;
end.
