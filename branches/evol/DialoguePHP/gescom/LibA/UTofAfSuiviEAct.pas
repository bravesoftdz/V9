{***********UNITE*************************************************
Auteur  ...... :  JP
Cr�� le ...... : 21/05/2002
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : AFSUIVIEACT ()
Mots clefs ... : TOF;AFSUIVIEACT
*****************************************************************}
Unit UTOFAFSUIVIEACT ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFNDEF EAGLCLIENT}
     db,
     dbtables,
     mul,
{$ELSE}
     emul,
{$ENDIF}
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     M3FP,
     HEnt1,
     HMsgBox,
     UtofAfTraducChampLibre,
		 HQry;

Type
  TOF_AFSUIVIEACT = Class (TOF_AFTRADUCCHAMPLIBRE)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnClose                  ; override ;
  end ;

Procedure AFLanceFiche_Suivi_EActivite;

Implementation


uses
{$IFNDEF EAGLCLIENT}
 		fe_main,   affaireole, utofafeactivite_mul,
{$ELSE}

{$ENDIF}
			paramdat, paramsoc, utob, FileCtrl, utobxls, AffaireUtil, UtilMulTrt,
     dicoaf, PGIEnv, htb97, activiteutil, utofaffaireexport_mul, utilga;

var
    PeriodeCtrl       :THEdit;
    DateDebCtrl       :THEdit;
    DateFinCtrl       :THEdit;
    BImportCtrl       :TToolbarButton97;
//    BClotureCtrl      :TToolbarButton97;
    Dernieri          :integer;
    NbEactiviteAvant  :integer;
    NbEActiviteApres  :integer;

procedure UpdateDate (NewDate:TDateTime);
var
   DateDeb, DateFin :TDate;
   txtPeriode       :string;
   Periodicite      :variant;
   iDayOfWeek       :integer;
   Year, Month, Day :Word;
   DateDebutAct     :TDateTime;
   DateFinAct       :TDateTime;
begin
     DateDeb := 0;
     DateFin := 0;
     if NewDate = 0 then
     begin
          DateDebCtrl.Text     := '';
          DateFinCtrl.Text     := '';
          PeriodeCtrl.Text     := '<aucune p�riode d�finie>';
          BImportCtrl.Enabled  := FALSE;
//          BClotureCtrl.Enabled := FALSE;
     end
     else
     begin
          iDayOfWeek := DayOfWeek(NewDate);
          if iDayOfWeek = 1 then
              iDayOfWeek := 7
          else
              iDayOfWeek := iDayOfWeek - 1;
          DecodeDate (NewDate, Year, Month, Day);
          Periodicite := GetParamSoc ('SO_AFEACTPERIODIC');
          if Periodicite = 'SEM' then
          begin
               DateDeb := NewDate - iDayOfWeek + 1;
               DateFin := DateDeb + 6;
               txtPeriode := 'semaine du ' + DateToStr (DateDeb) + ' au ' + DateToStr (DateFin);
          end
          else
              if Periodicite = 'QUI' then
              begin
                   case Month of
                   1, 3, 5, 7, 8, 10, 12:
                      if Day < 16 then
                      begin
                           DateDeb := EncodeDate (Year, Month, 1);
                           DateFin := EncodeDate (Year, Month, 15);
                      end
                      else
                      begin
                           DateDeb := EncodeDate (Year, Month, 16);
                           DateFin := EncodeDate (Year, Month, 31);
                      end;

                   4, 6, 9, 11:
                      if Day < 16 then
                      begin
                           DateDeb := EncodeDate (Year, Month, 1);
                           DateFin := EncodeDate (Year, Month, 15);
                      end
                      else
                      begin
                           DateDeb := EncodeDate (Year, Month, 16);
                           DateFin := EncodeDate (Year, Month, 30);
                      end;

                   2:
                     if Day < 15 then
                     begin
                          DateDeb := EncodeDate (Year, Month, 1);
                          DateFin := EncodeDate (Year, Month, 14);
                     end
                     else
                     begin
                          DateDeb := EncodeDate (Year, Month, 15);
                          if IsLeapYear (Year) = FALSE then
                              DateFin := EncodeDate (Year, Month, 28)
                          else
                              DateFin := EncodeDate (Year, Month, 29);
                     end;
                   end;
                   txtPeriode := 'quinzaine du ' + DateToStr (DateDeb) + ' au ' + DateToStr (DateFin);
              end
              else
                  if Periodicite = 'MEN' then
                  begin
                       case Month of
                       1, 3, 5, 7, 8, 10, 12:
                          begin
                               DateDeb := EncodeDate (Year, Month, 1);
                               DateFin := EncodeDate (Year, Month, 31);
                          end;

                          4, 6, 9, 11:
                          begin
                               DateDeb := EncodeDate (Year, Month, 1);
                               DateFin := EncodeDate (Year, Month, 30);
                          end;

                          2:
                          begin
                               DateDeb := EncodeDate (Year, Month, 1);
                               if IsLeapYear (Year) = FALSE then
                                   DateFin := EncodeDate (Year, Month, 28)
                               else
                                   DateFin := EncodeDate (Year, Month, 29);
                          end;
                       end;

                       txtPeriode := 'Mois de ';
                       case Month of
                       1:
                            txtPeriode := txtPeriode + 'janvier';
                       2:
                            txtPeriode := txtPeriode + 'f�vrier';
                       3:
                            txtPeriode := txtPeriode + 'mars';
                       4:
                            txtPeriode := txtPeriode + 'avril';
                       5:
                            txtPeriode := txtPeriode + 'mai';
                       6:
                            txtPeriode := txtPeriode + 'juin';
                       7:
                            txtPeriode := txtPeriode + 'juillet';
                       8:
                            txtPeriode := txtPeriode + 'ao�t';
                       9:
                            txtPeriode := txtPeriode + 'septembre';
                       10:
                            txtPeriode := txtPeriode + 'octobre';
                       11:
                            txtPeriode := txtPeriode + 'novembre';
                       12:
                            txtPeriode := txtPeriode + 'd�cembre';
                       end;
                       txtPeriode := txtPeriode + ' ' + IntToStr (Year);
                  end;

          PeriodeCtrl.Text := txtPeriode;
          DateDebCtrl.Text := DateToStr (DateDeb);
          DateFinCtrl.Text := DateToStr (DateFin);

          // Si date en dehors de l'intervalle de saisie autoris�e (paramsoc), import impossible
//          BClotureCtrl.Enabled := TRUE;
          IntervalleDatesActivite (DateDebutAct, DateFinAct);
          if (StrToDate (DateDebCtrl.Text) >= DateDebutAct) AND (StrToDate (DateFinCtrl.Text) <= DateFinAct) then
               BImportCtrl.Enabled := TRUE
          else
          begin
               BImportCtrl.Enabled := FALSE;
               PgiInfo ('La p�riode de saisie d�centralis�e n''est pas dans la p�riode de saisie d�finie dans les param�tres soci�t�'+#10+' Vous pouvez g�n�rer les classeurs, mais vous ne pouvez pas les importer ni visualiser les lignes e-activit�', 'Saisie d�centralis�e d''activit�');
          end;
     end;
end;

function SelectPeriode ():boolean;
var
   FParamDate       :TFParamDate;
   DateChoisie      :TDate;
begin
   Result := FALSE;
   FParamDate:=TFParamDate.Create (Application);
   Try
     FParamDate.Width := FParamDate.Width - FParamDate.Choix.Width;
     FParamDate.Choix.Visible:=FALSE;
     if FParamDate.ShowModal=mrOk then
     begin
          DateChoisie := FParamDate.DD;
          UpdateDate (DateChoisie);
          Result := TRUE;
     end;
   finally
          FParamDate.Free;
   end ;
end;

procedure TOF_AFSUIVIEACT.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_AFSUIVIEACT.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_AFSUIVIEACT.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_AFSUIVIEACT.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_AFSUIVIEACT.OnArgument (S : String ) ;
var
   Q       :TQuery;
   MaxDate :TDateTime;
begin
     Inherited ;

     PeriodeCtrl  := THEdit (GetControl('EPERIODE'));
     DateDebCtrl  := THEdit (GetControl('ASA_DATEDEB'));
     DateFinCtrl  := THEdit (GetControl('ASA_DATEFIN'));
     BImportCtrl  := TToolbarButton97 (GetControl('BIMPORT'));
//     BClotureCtrl := TToolbarButton97 (GetControl('BCLOTURE'));
     Q := nil;
     try
         Q := OpenSQL ('SELECT MAX(ASA_DATEDEB) AS MAXDATE FROM SUIVIEACT', TRUE);
         if not Q.eof then
         begin
              MaxDate := Q.FindField('MAXDATE').AsDateTime;
              Ferme (Q);
              UpdateDate (MaxDate);
         end;
     except
     end;

     // Type ressource par d�faut: salari�
     THDBValComboBox (GetControl ('ARS_TYPERESSOURCE')).Value := 'SAL';
end ;

procedure TOF_AFSUIVIEACT.OnClose ;
begin
  Inherited ;
end ;

function AGLShowCalendar (params:array of variant; nb: integer):variant;
begin
     SelectPeriode;
end;

function CompteEActivite:integer;
var
   Q:TQuery;
   SQL:string;
begin
     Result :=0;
     SQL    := 'SELECT COUNT(EAC_DATEACTIVITE) FROM EACTIVITE' ;
     Q      := nil;
     try
        Q := OpenSQL(SQL,True) ;
        if not Q.EOF then
           Result:=Q.Fields[0].AsInteger;
     finally
            Ferme(Q) ;
     end;
end;

procedure AGLGenereSuivi (params:array of variant; nb: integer);
var
   TOBAssistant             :TOB;
   TOBSuivi, TOBSuiviFille  :TOB;
   Q                        :TQuery;
   bDoGeneration            :boolean;
   i                        :integer;
begin
     // Etape pr�liminaire: s�lectionner p�riode de saisie d�centralis�e
     if SelectPeriode = FALSE then
     begin
          PgiInfoAf ('Abandon de la cr�ation d''une nouvelle session', 'Saisie d�centralis�e d''activit�');
          exit;
     end;

     // 1�re �tape: lecture des assistants n'ont encore g�n�r�s dans le suivi de la saisie d�centralis�e (pour la p�riode)
     TOBAssistant  := TOB.Create ('Les assistants', nil, -1); //$$$JP 28/01/03 modif nom tob
     Q             := nil;
     bDoGeneration := FALSE;
     try
         Q := OpenSQL ('SELECT ARS_RESSOURCE FROM RESSOURCE WHERE ARS_RESSOURCE NOT IN (SELECT ASA_RESSOURCE FROM SUIVIEACT WHERE ASA_DATEDEB="' + USDATE (DateDebCtrl) + '" AND ASA_DATEFIN="' + USDATE (DateFinCtrl) + '")',True);
         If (Not Q.EOF) then
         begin
              if PgiAskAf ('Confirmez-vous l''ouverture de la session pour ' + PeriodeCtrl.Text + ' ?', 'Saisie d�centralis�e d''activit�') = mrYes then
              begin
                   TOBAssistant.LoadDetailDB ('','','', Q, TRUE);
                   bDoGeneration := TRUE;
              end;
         end
         else
             PgiInfoAf ('La session est d�j� ouverte pour ' + PeriodeCtrl.Text, 'Saisie d�centralis�e d''activit�');
     finally
             Ferme (Q);
     end;

     // 2�me �tape (si accept�e): g�n�ration des enregistrement manquants de SUIVIEACT
     if bDoGeneration = TRUE then
     begin
          TOBSuivi := nil;
          try
             TOBSuivi := TOB.Create ('Les suivis', nil, -1);
             for i := 0 to TOBAssistant.Detail.Count-1 do
             begin
//                  ExecuteSQL ('INSERT INTO SUIVIEACT (ASA_RESSOURCE, ASA_ETATEACT, ASA_DATEDEB, ASA_DATEFIN) VALUES ("' + TOBAssistant.Detail [i].GetValue ('ARS_RESSOURCE') + '", "ES0", "' + USDATE (DateDebCtrl) + '", "' + USDATE (DateFinCtrl) + '")');
                  TOBSuiviFille := TOB.Create ('SUIVIEACT', TOBSuivi, -1);
                  TOBSuiviFille.PutValue ('ASA_RESSOURCE', TOBAssistant.Detail [i].GetValue ('ARS_RESSOURCE'));
                  TOBSuiviFille.PutValue ('ASA_ETATEACT', 'ES0');
                  TOBSuiviFille.PutValue ('ASA_DATEDEB', StrToDateTime (DateDebCtrl.Text));
                  TOBSuiviFille.PutValue ('ASA_DATEFIN', StrToDateTime (DateFinCtrl.Text));
             end;
             TOBSuivi.InsertOrUpdateDB (TRUE);
          finally
                 TOBSuivi.Free;
                 TOBAssistant.Free;
          end;

          PgiInfoAf ('Session ouverte pour ' + PeriodeCtrl.Text, 'Saisie d�centralis�e d''activit�');
      end
      else
          TOBAssistant.Free;
end;

procedure AGLClotureSuivi (params:array of variant; nb: integer);
var
   Q               :TQuery;
   bDoCloture      :boolean;
   MaxDate         :TDateTime;
begin
     // Si pas de p�riode d�finie, suppression non applicable
     if DateDebCtrl.Text = '' then
     begin
          PgiInfo ('Pas de p�riode d�finie');
          exit;
     end;

     // 1�re �tape: lecture des assistants n'ont encore g�n�r�s dans le suivi de la saisie d�centralis�e (pour la p�riode)
     bDoCloture := FALSE;
     try
        // V�rification si des classeurs encore dans la nature ou pas encore totalement valid�s
        if ExisteSQL ('SELECT ASA_RESSOURCE FROM SUIVIEACT WHERE ASA_ETATEACT<>"ES4"') = TRUE then
        begin
             if PgiAsk ('Tout les classeurs de la p�riode n''ont pas �t� totalement valid�s.' + #10 + ' D�sirez-vous tout de m�me supprimer la session pour ' + PeriodeCtrl.Text + ' ?', 'Saisie d�centralis�e d''activit�') = mrYes then
                bDoCloture := TRUE;
        end
        else
            if PgiAsk ('Confirmez-vous la suppression de la session pour ' + PeriodeCtrl.Text + ' ?', 'Saisie d�centralis�e d''activit�') = mrYes then
               bDoCloture := TRUE;
     finally
     end;

     // 2�me �tape (si accept�e): suppression des enregistrement manquants de SUIVIEACT
     if bDoCloture = TRUE then
     begin
          if PgiAsk ('Etes-vous absolument certain de vouloir supprimer la session pour ' + PeriodeCtrl.Text + ' ?', 'Saisie d�centralis�e d''activit�') = mrYes then
          begin
               Q := nil;
               try
                  ExecuteSQL ('DELETE FROM SUIVIEACT WHERE ASA_DATEDEB="' + USDATE (DateDebCtrl) + '" AND ASA_DATEFIN="' + USDATE (DateFinCtrl) + '"');
               finally
               end;

               PgiInfoAf ('La session pour ' + PeriodeCtrl.Text + ' a �t� supprim�e', 'Saisie d�centralis�e d''activit�');
               try
                  Q := OpenSQL ('SELECT MAX(ASA_DATEDEB) AS MAXDATE FROM SUIVIEACT', TRUE);
                  if not Q.eof then
                  begin
                       MaxDate := Q.FindField('MAXDATE').AsDateTime;
                       Ferme (Q);
                       UpdateDate (MaxDate);
                  end;
               except
               end;
          end;
      end;
end;

procedure AGLGenereClasseur (params:array of variant; nb: integer);
var
   F              :TForm;
   FMul           :TFMul;
   TOBAssist      :TOB;
   strAssist      :string;
   strExist       :string;
   i              :integer;
   AppliPathStd   :string;
begin
     // $$$ JP 07/07/2003: identification r�pertoire des standards am�lior�e
     AppliPathStd := GetAppliPathStd;
     if AppliPathStd = '' then
     begin
          PgiInfo ('Impossible d''identifier le r�pertoire des standards');
          exit;
     end;
{$IFNDEF EAGLCLIENT}
{$IFDEF GIGI}
//       AppliPathStd := 'C:\PGI00\STD\GIS5';
{$ELSE}
  //     AppliPathStd := 'C:\PGI00\STD\GAS5';
{$ENDIF}
{$ENDIF}

     // V�rification que le classeur g�n�rique sda.xls est pr�sent
     if FileExists (AppliPathStd + '\SDA.XLS') = FALSE then
     begin
          PgiInfoAf ('Cr�ation impossible.' + #10 + ' Le classeur mod�le n''est pas pr�sent dans ' + AppliPathStd, 'Saisie d�centralis�e d''activit�');
          exit;
     end;

     // Cr�ation du param�tre repr�sentatif de la liste des �l�ments s�lectionn�s dans le mul
     strAssist := '*';
     F         := TForm (Longint (params [0]));
     FMul      := nil;
     if F is TFMul then
     begin
          FMul := TFMul (F);

          // R�cup�ration des �l�ments s�lectionn�s
          TobAssist := TOB.Create ('Les assistants', nil, -1); //$$$JP 28/01/03 modif nom tob
          TraiteEnregMulListe (FMul, 'ASA_RESSOURCE','AFSUIVIEACT', TobAssist, True);

          // G�n�ration de la chaine avec les codes assistants s�lectionn�s
          // $$$todo: passer directement la tob, plus simple, plus rapide et moins gourmand
          strAssist := '(';
          for i := 0 to TobAssist.Detail.Count-1 do
          begin
               //FMul.FListe.GotoLeBookMark (i);
               if i > 0 then
                  strAssist := strAssist + ',';
               strAssist := strAssist + '"' + TOBAssist.Detail [i].GetValue ('ASA_RESSOURCE') + '"';
          end;
          strAssist := strAssist + ')';
          TOBAssist.Free;

          // G�n�ration de la chaine
{          if FMul.FListe.AllSelected = FALSE then
          begin
               if FMul.FListe.NbSelected > 0 then
               begin
                    strAssist := '(';
                    for i := 0 to FMul.FListe.NbSelected-1 do
                    begin
                         FMul.FListe.GotoLeBookMark (i);
                         if i > 0 then
                            strAssist := strAssist + ',';
                         strAssist := strAssist + '"' + FMul.FListe.Fields [0].Value + '"';
                    end;
                    strAssist := strAssist + ')';
               end
               else
                   strAssist := '';
          end;}
     end;

     // G�n�ration de classeurs uniquement si session ouverte sur un des assistants s�lectionn�s
     if strAssist = '*' then
         strExist := 'SELECT ASA_RESSOURCE FROM SUIVIEACT WHERE ASA_DATEDEB="' + USDATE (DateDebCtrl) + '" AND ASA_DATEFIN="' + USDATE (DateFinCtrl) + '"'
     else
         if strAssist <> '' then
            strExist := 'SELECT ASA_RESSOURCE FROM SUIVIEACT WHERE ASA_DATEDEB="' + USDATE (DateDebCtrl) + '" AND ASA_DATEFIN="' + USDATE (DateFinCtrl) + '" AND ASA_RESSOURCE IN ' + strAssist;
     if strAssist <> '' then
        if ExisteSQL (strExist) = TRUE then
            // $$$JP: AGLLanceFiche interdit
            AFLanceFiche_Mul_ExportAff ('MODESUIVI;DATEDEB=' + DateDebCtrl.Text + ';DATEFIN=' + DateFinCtrl.Text + ';ASSIST=' + strAssist)
//            AGLLanceFiche ('AFF', 'AFFAIREEXPORT_MUL', '', '', 'MODESUIVI;DATEDEB='+DateDebCtrl.Text+';DATEFIN='+DateFinCtrl.Text+';ASSIST='+strAssist)
        else
            PgiInfoAf ('La session pour ' + PeriodeCtrl.Text + ' n''est pas ouverte pour les assistants s�lectionn�s', 'Saisie d�centralis�e d''activit�')
     else
         PgiInfoAf ('Veuillez s�lectionner au moins un assistant', 'Saisie d�centralis�e d''activit�');

     // R�initialiser le mul
     if FMul <> nil then
     begin
          TToolBarButton97 (FMul.LaTOF.GetControl ('bSelectAll')).Down := False;
          FMul.FListe.AllSelected := False;
          FMul.ChercheClick;
     end;
end;

procedure AGLShowEActivite (params:array of variant; nb: integer);
var
//   F            :TForm;
//   FMul         :TFMul;
//   Q            :TQuery;
//   strAssist    :string;
//   i            :integer;
   DateDebutAct :TDateTime;
   DateFinAct   :TDateTime;
begin
     // visualisation eactivit� seulement si dans l'intervalle de saisie d'activit�
     IntervalleDatesActivite (DateDebutAct, DateFinAct);
     if (StrToDate (DateDebCtrl.Text) >= DateDebutAct) AND (StrToDate (DateFinCtrl.Text) <= DateFinAct) then
         AFLanceFiche_Mul_EActivite ('MODESUIVI;DATEDEB='+DateDebCtrl.Text+';DATEFIN='+DateFinCtrl.Text + ';ASSISTANT=' + VarAsType (Params[0], varString))
     else
         PgiInfo ('La p�riode de saisie d�centralis�e n''est pas dans la p�riode de saisie d�finie dans les param�tres soci�t�', 'Saisie d�centralis�e d''activit�');
end;

procedure ImporteUnClasseur (NomFic:string; TOBLesAssist:TOB; bUnPourTous:boolean);
var
   T                                              :TOB;
   sAff0,sAff1,sAff2,sAff3,sAff4,sAffaire,sTiers  :string;
   j, nbAffaires                                  :integer;
   strCode                                        :string;
begin
     // importation classeur dans la tob
     T := TOB.Create('', Nil, -1);
     j := 0;
     if T <> nil then
     begin
          try
             ImportTOBFromXLS (T, NomFic, TRUE, TRUE);
             T.Detail.Sort ('EAC_RESSOURCE;EAC_TIERS;EAC_AFFAIRE0;EAC_AFFAIRE1;-EAC_AFFAIRE2;EAC_AFFAIRE3;EAC_AVENANT');
             while j < T.Detail.Count do
             begin
                  // Code article et code assistant en MAJUSCULES et sans espaces d�but ou fin
                  strCode := T.Detail [j].GetValue ('EAC_RESSOURCE');
                  if strCode <> '' then
                     T.Detail [j].PutValue ('EAC_RESSOURCE', AnsiUpperCase (Trim (strCode)));
                  strCode := T.Detail [j].GetValue ('EAC_CODEARTICLE');
                  if strCode <> '' then
                     T.Detail [j].PutValue ('EAC_CODEARTICLE', AnsiUpperCase (Trim (strCode)));

                  // L'assistant doit �tre s�lectionn� pour �tre import�
                  if TOBLesAssist.FindFirst (['ARS_RESSOURCE'], [T.Detail[j].GetValue ('EAC_RESSOURCE')], FALSE) <> nil then
                  begin
                       // Type d'activit� vide, on consid�re r�alis�
                       if T.Detail[j].GetValue('EAC_TYPEACTIVITE') = '' then
                          T.Detail[j].PutValue('EAC_TYPEACTIVITE', 'REA');

                       // V�rification code affaire
                       if T.Detail[j].GetValue('EAC_AFFAIRE') = '' then
                       begin
//                            NbAffaires := 0;
                            sAff0      := T.Detail [j].GetValue('EAC_AFFAIRE0');
                            sAff1      := T.Detail [j].GetValue('EAC_AFFAIRE1');
                            sAff2      := T.Detail [j].GetValue('EAC_AFFAIRE2');
                            sAff3      := T.Detail [j].GetValue('EAC_AFFAIRE3');
                            sAff4      := T.Detail [j].GetValue('EAC_AVENANT');
                            sTiers     := T.Detail [j].GetValue('EAC_TIERS');
                            sAffaire   := RegroupePartiesAffaire (sAff0, sAff1, sAff2, sAff3, sAff4);
                            NbAffaires := TeststCleAffaire (sAffaire,sAff0,sAff1,sAff2,sAff3,sAff4,sTiers, false, false, false, true);
                            if NbAffaires = 1 then
                            begin
                                 T.Detail [j].PutValue('EAC_AFFAIRE',sAffaire);
                                 T.Detail [j].PutValue('EAC_AFFAIRE0',sAff0);
                                 T.Detail [j].PutValue('EAC_AFFAIRE1',sAff1);
                                 T.Detail [j].PutValue('EAC_AFFAIRE2',sAff2);
                                 T.Detail [j].PutValue('EAC_AFFAIRE3',sAff3);
                                 T.Detail [j].PutValue('EAC_AVENANT',sAff4);
                                 T.Detail [j].PutValue('EAC_TIERS',sTiers);
                            end;

                            // Origine: Saisie D�centralis�e Excel (SDE)
                            T.Detail[j].PutValue('EAC_ACTORIGINE', 'SDE');
                       end;

                       // Num�ro de ligne
                       T.Detail [j].PutValue('EAC_NUMLIGNE', NbEactiviteAvant + 1 + j + dernieri);
                       j := j + 1;
                  end
                  else
                      // On importe pas les ligne pour assistants non s�lectionn�s
                      T.Detail [j].Free;
             end;

             // Mise � jour table eactivit�, et du suivi e-activit� si un classeur pour TOUS les assistants
             if T.Detail.Count > 0 then
             begin
                  T.insertDB (nil,false);
                  if bUnPourTous = TRUE then
                     for j := 0 to T.detail.count-1 do
                     begin
//                         ExecuteSQL ('UPDATE SUIVIEACT SET ASA_ETATEACT = "ES2" WHERE ASA_RESSOURCE="' + T.Detail [j].GetValue ('EAC_RESSOURCE') + '" AND ASA_DATEDEB="' + USDATE (DateDebCtrl) + '" AND ASA_DATEFIN="' + USDATE (DateFinCtrl) + '" AND ASA_ETATEACT<>"ES2"');
                         ExecuteSQL ('UPDATE SUIVIEACT SET ASA_ETATEACT = "ES2" WHERE ASA_RESSOURCE="' + T.Detail [j].GetValue ('EAC_RESSOURCE') + '" AND ASA_DATEDEB="' + USDATE (DateDebCtrl) + '" AND ASA_DATEFIN="' + USDATE (DateFinCtrl) + '" AND ASA_ETATEACT="ES1"');
                         ExecuteSQL ('UPDATE SUIVIEACT SET ASA_ETATEACT = "ES5" WHERE ASA_RESSOURCE="' + T.Detail [j].GetValue ('EAC_RESSOURCE') + '" AND ASA_DATEDEB="' + USDATE (DateDebCtrl) + '" AND ASA_DATEFIN="' + USDATE (DateFinCtrl) + '" AND ASA_ETATEACT="ES4"');
                         Inc (dernieri);
                     end;
             end;
          finally
                 T.Free;
          end;
     end;
end;

procedure AGLRecupClasseur (params:array of variant; nb: integer);
var
   TobAssist      :TOB;
   Q              :TQuery;
   i              :integer;
   sNomRep        :string;
   NomCompletFic  :string;
   F              :TForm;
   FMul           :TFMul;
   strWhere       :string;
   strEtat        :string;
   bImport        :boolean;
   SearchRec      :TSearchRec;
begin
     // R�cup�ration des assistants � importer
     strWhere := '';
     F := TForm (Longint (params [0]));
     if F is TFMul then
     begin
          FMul := TFMul (F);
          if FMul.FListe.AllSelected = FALSE then
          begin
               if FMul.FListe.NbSelected > 0 then
               begin
                    strWhere := 'WHERE ASA_RESSOURCE IN (';
                    for i := 0 to FMul.FListe.NbSelected-1 do
                    begin
                         FMul.FListe.GotoLeBookMark (i);
                         if i > 0 then
                            strWhere := strWhere + ',';
                         strWhere := strWhere + '"' + FMul.FListe.Fields [0].Value + '"';
                    end;
                    strWhere := strWhere + ')';
               end;
          end
          else
          begin
               // Tous s�lectionn�s: on r�cup�re le where du mul
               strWhere := RecupWhereCritere (FMUL.Pages);

               // R�initialiser le mul
               TToolBarButton97 (FMul.LaTOF.GetControl ('bSelectAll')).Down:=false;
               FMul.FListe.AllSelected := False;
               FMul.ChercheClick;
          end;
     end;

     // Importation des classeurs pour les assistants s�lectionn�s
     if strWhere <> '' then
     begin
           TobAssist := TOB.Create ('Les assistants', Nil, -1); //$$$JP 28/01/03 modif nom tob
           Q := nil;
           try
               strWhere := strWhere + ' AND ASA_DATEDEB="' + USDATE (DateDebCtrl) + '" AND ASA_DATEFIN="' + USDATE (DateFinCtrl) + '"';
               strWhere := strWhere + ' AND ASA_RESSOURCE=ARS_RESSOURCE';
               Q := OpenSQL ('SELECT ARS_RESSOURCE, ARS_LIBELLE, ASA_ETATEACT FROM RESSOURCE,SUIVIEACT ' + strWhere, TRUE);
               if not Q.eof then
               begin
                    // R�cup�ration code assistant et libell�
                    TobAssist.LoadDetailDB ('','','', Q, TRUE);
                    Ferme (Q);

                    // R�cup�ration r�pertoire d'importation
                    NomCompletFic := '';
                    sNomRep := GetParamSoc ('SO_AFEACTPATH');
                    sNomRep := Trim (sNomRep);
                    if sNomRep = '' then
                       sNomRep := V_PGI_ENV.PathDos;

                    // $$$JP 07/12/02: pour titre fen�tre import  $$$JP 12/05/03: pas de tof pour AFEACTIMPORT
                    sNomRep := AGLLanceFiche ('AFF', 'AFEACTIMPORT', '','', 'R�pertoire d''import classeur S.D.A.;' + Trim (sNomRep));
                    if sNomRep = '' then
                       exit;

                    // Initialisations et v�rification r�pertoire d'import
                    if not DirectoryExists (sNomRep) then
                    begin
                         PGIInfoAf ('Le r�pertoire ' + sNomRep + ' n''existe pas', 'Saisie d�centralis�e d''activit�');
                         exit;
                    end;

                    // Boucle sur les classeurs assistants � "r�cup�rer" (un classeur par assistants
                    NbEactiviteAvant := CompteEActivite;
                    Dernieri := 0;
                    TOBAssist.Detail.Sort ('ARS_RESSOURCE');
                    for i := 0 to TobAssist.Detail.Count-1 do
                    begin
                         // $$$JP 14/04/2003: gestion nom de fichier sans libell� ressource (qui a pu changer)
                         // Nom du fichier d'import (si pas pr�sent, on ne fait rien)
                         // $$$JP 02/06/03: on doit tester code retour du findfirst, pas le champ name de la structure
                         if FindFirst (sNomRep + '\IMPSDA_' + StringReplace (DateDebCtrl.Text, '/', '', [rfReplaceAll]) + '_' + StringReplace (DateFinCtrl.Text, '/', '', [rfReplaceAll]) + '_' + TobAssist.Detail [i].GetValue ('ARS_RESSOURCE') + '�*.xls', faAnyFile, SearchRec) = 0 then
//                         if SearchRec.Name <> '' then
                         begin
                              // Fichier � "pointer"
                              NomCompletFic := sNomRep + '\' + SearchRec.Name;
//                         NomCompletFic := sNomRep + '\IMPSDA_' + StringReplace (DateDebCtrl.Text, '/', '', [rfReplaceAll]) + '_' + StringReplace (DateFinCtrl.Text, '/', '', [rfReplaceAll]) + '_' + TobAssist.Detail [i].GetValue ('ARS_RESSOURCE') + '�' + TobAssist.Detail [i].GetValue ('ARS_LIBELLE') + '.xls';
  //                       if FileExists (NomCompletFic) then
    //                     begin
                              // V�rification si d�j� import�
                              bImport := TRUE;
                              strEtat := TOBAssist.Detail [i].GetValue ('ASA_ETATEACT');
                              if (strEtat <> 'ES0') and (strEtat <> 'ES1') then
                              begin
                                   if PGIAskAF ('Le classeur de ' + TOBAssist.Detail [i].GetValue ('ARS_RESSOURCE') + ' - ' + TOBAssist.Detail [i].GetValue ('ARS_LIBELLE') + ' a d�j� �t� import�' + #10 + ' D�sirez-vous l''importer de nouveau ?', 'Saisie d�centralis�e d''activit�') <> mrYes then
                                      Bimport := FALSE;
                              end;

                              // Importation si utilisateur ok
                              if bImport = TRUE then
                              begin
                                   ImporteUnClasseur (NomCompletFic, TOBAssist, FALSE);
                                   try
                                      ExecuteSQL ('UPDATE SUIVIEACT SET ASA_ETATEACT = "ES2" WHERE ASA_RESSOURCE="' + TobAssist.Detail [i].GetValue ('ARS_RESSOURCE') + '" AND ASA_DATEDEB="' + USDATE (DateDebCtrl) + '" AND ASA_DATEFIN="' + USDATE (DateFinCtrl) + '" AND ASA_ETATEACT="ES1"');
                                      ExecuteSQL ('UPDATE SUIVIEACT SET ASA_ETATEACT = "ES5" WHERE ASA_RESSOURCE="' + TobAssist.Detail [i].GetValue ('ARS_RESSOURCE') + '" AND ASA_DATEDEB="' + USDATE (DateDebCtrl) + '" AND ASA_DATEFIN="' + USDATE (DateFinCtrl) + '" AND ASA_ETATEACT="ES4"');
                                      RenameFile (NomCompletFic, sNomRep + '\OK_' + ExtractFileName (NomCompletFic));
                                   except
                                         PgiInfoAf ('Mise � jour table SUIVIEACT impossible pour ' + TOBAssist.Detail [i].GetValue ('ARS_RESSOURCE'), 'Saisie d�centralis�e d''activit�'); //MCD Ecran.Caption);
                                   end;
                              end;
                         end;
                         sysutils.FindClose (SearchRec);
                    end;

                    // Tentative d'importation d'un classeur pour tous les assistants (si coch� dans param�tres soci�t�)
                    if GetParamSoc ('SO_AFEACTUNPOURTOUS') = TRUE then
                    begin
                         NomCompletFic := sNomRep + '\IMPSDA_'+ StringReplace (DateDebCtrl.Text, '/', '', [rfReplaceAll]) + '_' + StringReplace (DateFinCtrl.Text, '/', '', [rfReplaceAll]) + '_SaisieActivit�SAct.xls';
                         if FileExists (NomCompletFic) then
                            if PgiAskAf ('Un classeur multi-assistant est pr�sent. D�sirez-vous l''importer ?', 'Saisie d�centralis�e d''activit�') = mrYes then
                               ImporteUnClasseur (NomCompletFic, TOBAssist, TRUE);
                    end;

                    // Nb de ligne apr�s import (JP: normalement toujours >= au nombre avant import)
                    NbEActiviteApres := CompteEActivite;

                    // N lignes ont �t� import�es dans l'e-activit�
                    if (NbEActiviteApres>NbEActiviteAvant) then
                    begin
                         // Visualisation des lignes d'activit�s (toutes, pas seulement celles des assistants s�lectionn�s)
                         PGIInfoAf (inttostr(NbEActiviteApres-NbEActiviteAvant) + ' lignes ont �t� import�es dans l''e-activit�', 'Saisie d�centralis�e d''activit�');

                         // $$$JP 12/05/03: une tof est associ�e au mul
                         AFLanceFiche_Mul_EActivite ('MODESUIVI;DATEDEB='+DateDebCtrl.Text+';DATEFIN='+DateFinCtrl.Text);
                         //AGLLanceFiche ('AFF','AFEACTIVITE_MUL','','','MODESUIVI;DATEDEB='+DateDebCtrl.Text+';DATEFIN='+DateFinCtrl.Text)
                    end
                    else
                        PgiInfoAf ('Aucune ligne n''a �t� import�e', 'Saisie d�centralis�e d''activit�');

                    // JP: pourquoi supprim�es? � priori impossible
                    //if (NbEActiviteApres<NbEActiviteAvant) then // Tout ou partie des lignes de l'e-activit� ont �t� perdues
                    //   PGIInfoAf ('Tout ou partie des lignes de l''e-activit� ont �t� supprim�es', 'Saisie d�centralis�e');
               end
               else
                   PgiInfoAf ('Pas de classeur en attente pour les assistants s�lectionn�s, pour cette p�riode', 'Saisie d�centralis�e d''activit�');
           finally
                  TobAssist.Free;
           end;
      end
      else
          PgiInfoAf ('Veuillez s�lectionner au moins un assistant', 'Saisie d�centralis�e d''activit�');
end;

Procedure AFLanceFiche_Suivi_EActivite;
begin
     AGLLanceFiche ('AFF','AFEACTSUIVI','','','');
end;



Initialization
  registerclasses ( [ TOF_AFSUIVIEACT ] ) ;
  registerAglfunc('ShowCalendar', FALSE, 0, AGLShowCalendar);
  registerAglproc('GenereSuivi', FALSE, 0, AGLGenereSuivi);
  registerAglproc('ClotureSuivi', FALSE, 1, AGLClotureSuivi);
  RegisterAglProc('GenereClasseur', TRUE, 0, AGLGenereClasseur);
  registerAglproc('RecupClasseur', TRUE, 0, AGLRecupClasseur);
  registerAglproc('ShowEActivite', FALSE, 1, AGLShowEActivite);
end.

