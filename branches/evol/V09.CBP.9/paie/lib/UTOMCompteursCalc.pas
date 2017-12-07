{***********UNITE*************************************************
Auteur  ...... : FLO
Cr�� le ...... : 26/06/2007
Modifi� le ... :   /  /
Description .. : Source TOM de la TABLE : PRESENCESALARIE (PRESENCESALARIE)
Mots clefs ... : TOM;PRESENCESALARIE
*****************************************************************
PT1  10/08/2007  FLO  Recalcul automatique des compteurs lors d'une modification manuelle
PT2  30/08/2007  FLO  Ne pas g�n�rer de recalcul si suppression d'un compteur � recalculer
}
Unit UTOMCompteursCalc ;

Interface

Uses StdCtrls, 
     Controls, 
     Classes, 
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
{$else}
     eFiche, 
     eFichList, 
{$ENDIF}
     sysutils,
     ComCtrls,
     HEnt1,
     UTob,
     UTOM;

Type
  TOM_PRESENCESALARIE = Class (TOM)
    procedure OnDeleteRecord             ; override ;
    procedure OnUpdateRecord             ; override ;
    procedure OnAfterUpdateRecord        ; override ; //PT1
    procedure OnAfterDeleteRecord        ; override ; //PT1
    procedure OnLoadRecord               ; override ;
    procedure OnChangeField ( F: TField) ; override ;
    procedure OnArgument ( S: String )   ; override ;

  private
    ChangeField : Boolean;
    Salarie     : String;    //PT1
    DateModif   : TDateTime; //PT1
    Recalculer  : Boolean;   //PT2
    procedure ChangeCompteur (Sender : TObject);
    procedure ControleDates;
    end ;

Implementation

Uses PGPresence, HMsgBox, HCtrls;

Const A_INTEGRER = 'AIN';
Const INTEGRE    = 'INP';
Const MANUEL     = 'NON';
Const A_RECALC   = 'ARE'; //PT3
Const SAISIE     = 'SAI';

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 26/06/2007
Modifi� le ... :   /  /
Description .. : Suppression d'un enregistrement
Mots clefs ... :
*****************************************************************}
procedure TOM_PRESENCESALARIE.OnDeleteRecord ;
begin
  Inherited ;

     // Si le compteur est � int�grer ou int�gr�, la suppression est interdite
     If (GetField('PYP_PGINDICATPRES') = INTEGRE) Or (GetField('PYP_PGINDICATPRES') = A_INTEGRER) Then
     Begin
          LastError := 1;
          LastErrorMsg := 'Suppression impossible. Ce compteur est utilis� en paie.';
     End;

     //PT1 - D�but
     If (LastError = 0) Then
     Begin
          Recalculer  := Not (GetField('PYP_PGINDICATPRES') = A_RECALC); //PT3
          Salarie     := GetField('PYP_SALARIE');
          DateModif   := GetField('PYP_DATEDEBUTPRES');
     End;
     //PT1 - Fin
end ;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 26/06/2007
Modifi� le ... :   /  /
Description .. : Cr�ation ou modification d'un enregistrement
Mots clefs ... :
*****************************************************************}
procedure TOM_PRESENCESALARIE.OnUpdateRecord ;
Var Q : TQuery;
    DD : TDateTime;
    Champs : String;
begin
  Inherited ;

     // En cr�ation, il faut r�cup�rer certaines valeurs de la table SALARIES et COMPTEURPRESENCE
     If DS.State in [dsInsert] Then
     Begin
          { V�rification de la saisie des champs. Du fait que les dates sont renseign�es par d�faut
            au 01/01/1900, elles sont consid�r�es comme OK. Du coup, on est oblig� de les contr�ler.
            Et pour plus de lisibilit�, on refait tout. }
          If (GetControlText('PYP_SALARIE') = '') Then
          Begin
               LastError := 1;
               Champs := '#13#10- '+TraduireMemoire('le salari�');
          End;

          DD := StrToDate(GetControlText ('PYP_DATEDEBUTPRES'));
          If (DD=0) Or (DD = iDate1900) Then
          Begin
               LastError := 1;
               Champs := Champs + '#13#10- '+TraduireMemoire('la date de d�but');
          End;

          DD := StrToDate(GetControlText ('PYP_DATEFINPRES'));
          If (DD=0) Or (DD = iDate1900) Then
          Begin
               LastError := 1;
               Champs := Champs + '#13#10- '+TraduireMemoire('la date de fin');
          End;

          If (GetControlText('PYP_COMPTEURPRES') = '') Then
          Begin
               LastError := 1;
               Champs := Champs + '#13#10- '+TraduireMemoire('le compteur associ�');
          End;

          If LastError=1 Then
          Begin
               PGIBox(Format(TraduireMemoire('Vous devez renseigner : %s'),[Champs]),TraduireMemoire('Contr�le de saisie'));
               LastErrorMsg := '';
          End;

          ControleDates;
          If LastError <> 0 Then Exit;

          // For�age du compteur car il n'est pas r�cup�r� par l'AGL
          SetField('PYP_COMPTEURPRES', GetControlText('PYP_COMPTEURPRES'));

          // Recherche des informations du salari�
          Q := OpenSQL ('SELECT * FROM SALARIES WHERE PSA_SALARIE="'+GetControlText('PYP_SALARIE')+'"', True);
          If Not Q.EOF Then
          Begin
               SetField('PYP_ETABLISSEMENT', Q.FindField('PSA_ETABLISSEMENT').AsString);
               SetField('PYP_TRAVAILN1',     Q.FindField('PSA_TRAVAILN1').AsString);
               SetField('PYP_TRAVAILN2',     Q.FindField('PSA_TRAVAILN2').AsString);
               SetField('PYP_TRAVAILN3',     Q.FindField('PSA_TRAVAILN3').AsString);
               SetField('PYP_TRAVAILN4',     Q.FindField('PSA_TRAVAILN4').AsString);
               SetField('PYP_CODESTAT',      Q.FindField('PSA_CODESTAT').AsString);
               SetField('PYP_CONVENTION',    Q.FindField('PSA_CONVENTION').AsString);
               SetField('PYP_DADSPROF',      Q.FindField('PSA_DADSPROF').AsString);
               SetField('PYP_DADSCAT',       Q.FindField('PSA_DADSCAT').AsString);
               SetField('PYP_LIBREPCMB1',    Q.FindField('PSA_LIBREPCMB1').AsString);
               SetField('PYP_LIBREPCMB2',    Q.FindField('PSA_LIBREPCMB2').AsString);
               SetField('PYP_LIBREPCMB3',    Q.FindField('PSA_LIBREPCMB3').AsString);
               SetField('PYP_LIBREPCMB4',    Q.FindField('PSA_LIBREPCMB4').AsString);
          End;
          Ferme(Q);
          If LastError <> 0 Then Exit;

          // Recherche des informations du compteur
          Q := OpenSQL ('SELECT PYR_PERIODICITEPRE, PYR_THEMEPRE FROM COMPTEURPRESENCE WHERE PYR_COMPTEURPRES="'+GetControlText('PYP_COMPTEURPRES')+'" AND PYR_DATEVALIDITE="'+UsDateTime(StrToDate(GetControlText('PYR_DATEVALIDITE')))+'"', True);
          If Not Q.EOF Then
          Begin
               SetField('PYP_THEMEPRE',       Q.FindField('PYR_THEMEPRE').AsString);
               SetField('PYP_PERIODICITEPRE', Q.FindField('PYR_PERIODICITEPRE').AsString);
          End;
          Ferme(Q);
          If LastError <> 0 Then Exit;

          // For�age des valeurs de l'�tat, de l'indicateur et du type
          SetField ('PYP_TYPECALPRES',   '001');
          SetField ('PYP_PGINDICATPRES', MANUEL);
          SetField ('PYP_ETATPRES',      SAISIE);
     End
     Else If DS.State In [dsEdit] Then
     Begin
          // En modification, on change l'�tat et l'indicateur (� n'effectuer que si la modification est possible) 
          If GetControlEnabled('PYP_QUANTITEPRES') Then
          Begin
               SetField('PYP_PGINDICATPRES',MANUEL);
               SetField('PYP_ETATPRES',     SAISIE);
          End;
     End;

     //PT1 - D�but
     If (LastError = 0) Then
     Begin
          Recalculer  := Not (GetField('PYP_PGINDICATPRES') = A_RECALC); //PT3
          Salarie     := GetField('PYP_SALARIE');
          DateModif   := GetField('PYP_DATEDEBUTPRES');
     End;
     //PT1 - Fin
end ;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 10/08/2007 / PT1
Modifi� le ... :   /  /
Description .. : Suite � la suppression d'un enregistrement
Mots clefs ... :
*****************************************************************}
procedure TOM_PRESENCESALARIE.OnAfterDeleteRecord;
begin
  inherited;
     If (LastError = 0) And Recalculer Then CompteursARecalculer(DateModif, Salarie);  //PT3
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 10/08/2007 / PT1
Modifi� le ... :   /  /
Description .. : Suite � la cr�ation ou modification d'un enregistrement
Mots clefs ... :
*****************************************************************}
procedure TOM_PRESENCESALARIE.OnAfterUpdateRecord ;
begin
  Inherited ;
     If (LastError = 0) And Recalculer Then CompteursARecalculer(DateModif, Salarie);  //PT3
end ;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 26/06/2007
Modifi� le ... :   /  /
Description .. : Chargement des donn�es
Mots clefs ... :
*****************************************************************}
procedure TOM_PRESENCESALARIE.OnLoadRecord ;
Var
     Combo  : THValComboBox;
begin
  Inherited ;

     // Si le compteur est � int�grer, ou int�gr�, on ne peut ni le modifier, ni le supprimer
     If (DS.State In [dsEdit,dsBrowse]) And ((GetField('PYP_PGINDICATPRES')=INTEGRE) Or (GetField('PYP_PGINDICATPRES')=A_INTEGRER)) Then
     Begin
          SetControlEnabled ('PYP_QUANTITEPRES', False);
          SetControlEnabled ('BDelete', False);
          SetControlEnabled ('BDefaire', False);
     End;

     // Au chargement de la fiche, il faut renseigner le compteur
     If (DS.State In [dsEdit,dsBrowse]) Then
     Begin
          Combo := THValComboBox(GetControl('COMPTEUR'));
          If Combo <> Nil Then
          Begin
               Combo.Items.Add(GetControlText('PYR_LIBELLE'));
               Combo.Values.Add(GetControlText('PYP_COMPTEURPRES')+';'+GetControlText('PYR_DATEVALIDITE'));
               // S�lection de l'�l�ment
               SetControlText('COMPTEUR', GetControlText('PYP_COMPTEURPRES')+';'+GetControlText('PYR_DATEVALIDITE'));
          End;
          SetControlEnabled ('COMPTEUR', False);
     End;

     Combo := THValComboBox(GetControl('COMPTEUR'));
     If Combo <> Nil Then Combo.OnChange := ChangeCompteur;
end ;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 26/06/2007
Modifi� le ... :   /  /
Description .. : Modification d'un champ
Mots clefs ... :
*****************************************************************}
procedure TOM_PRESENCESALARIE.OnChangeField ( F: TField ) ;
Var
     Q      : TQuery;
     Combo  : THValComboBox;
     AncCpt,Temp : String;
begin
  Inherited ;

     If ChangeField = False Then Exit;

     If Ds.State In [DsInsert] Then
     Begin
          // Actualisation de la combo des compteurs en fonction de la date de d�but saisie
          If (F.FieldName = 'PYP_DATEDEBUTPRES') And (StrToDate(GetControlText('PYP_DATEDEBUTPRES')) <> iDate1900) Then
          Begin
               // R�cup�ration de la combo
               Combo := THValComboBox(GetControl('COMPTEUR'));

               If Combo <> Nil Then
               Begin
                    ChangeField := False;

                    // R�initialisation de la combo pour ne pas avoir de probl�me
                    Combo.Items.Clear; Combo.Values.Clear;
                    SetControlText('PYP_COMPTEURPRES', '');
                    SetControlText('PYR_DATEVALIDITE', '');
                    SetControlText('PYR_LIBELLE', '');

                    AncCpt := '';
                    Q := OpenSQL ('SELECT PYR_COMPTEURPRES, PYR_LIBELLE, MAX(PYR_DATEVALIDITE) AS DATEVALIDITE FROM COMPTEURPRESENCE '+
                    ' WHERE ##PYR_PREDEFINI## AND (PYR_DATEVALIDITE <= "'+UsDateTime(StrToDate(GetControlText('PYP_DATEDEBUTPRES')))+'")' +
                    ' GROUP BY PYR_COMPTEURPRES, PYR_DATEVALIDITE, PYR_LIBELLE ORDER BY PYR_COMPTEURPRES, PYR_DATEVALIDITE DESC', True);
                    While Not Q.Eof Do
                    Begin
                         If AncCpt <> Q.FindField('PYR_COMPTEURPRES').AsString Then
                         Begin
                              Temp := Q.FindField('PYR_COMPTEURPRES').AsString;
                              Temp := Temp + ';';
                              Temp := Temp + DateToStr(Q.FindField('DATEVALIDITE').AsDateTime);
                              Combo.Values.Add(Temp);
                              Combo.Items.Add(Q.FindField('PYR_LIBELLE').AsString);

                              AncCpt := Q.FindField('PYR_COMPTEURPRES').AsString;
                         End;
                         Q.Next;
                    End;
                    Ferme(Q);

                    ChangeField := True;
               End;
          End;

          // Contr�le de coh�rence des dates
          If (F.FieldName = 'PYP_DATEFINPRES') Or (F.FieldName = 'PYP_DATEDEBUTPRES') Then
               ControleDates;
     End;
end ;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 26/06/2007
Modifi� le ... :   /  /
Description .. : Chargement de l'�cran
Mots clefs ... :
*****************************************************************}
procedure TOM_PRESENCESALARIE.OnArgument ( S: String ) ;
Var
     Action, DateVal, Libelle, Compteur : String;
begin
  Inherited ;

     ChangeField := True;

     // R�cup�ration des param�tres en entr�e
     Action  := ReadTokenSt(S);
     Compteur:= ReadTokenSt(S);
     DateVal := ReadTokenSt(S);
     Libelle := ReadTokenSt(S);

     SetControlText('PYP_COMPTEURPRES', Compteur);
     SetControlText('PYR_DATEVALIDITE', DateVal);
     SetControlText('PYR_LIBELLE', Libelle);

     {$IFDEF EAGLCLIENT}
          SetControlText('PYP_DATEDEBUTPRES', DateToStr(iDate1900));
          SetControlText('PYP_DATEFINPRES',   DateToStr(iDate1900));
     {$ENDIF}
end ;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 26/06/2007
Modifi� le ... :   /  /
Description .. : Contr�le la validit� des dates saisies
Mots clefs ... :
*****************************************************************}
procedure TOM_PRESENCESALARIE.ControleDates;
Var 
    DD,DF : TDateTime;
begin
     // Contr�le des dates de d�but et de fin
     DD := StrToDate(GetControlText('PYP_DATEDEBUTPRES'));
     DF := StrToDate(GetControlText('PYP_DATEFINPRES'));
     If (DD <> iDate1900) And (DF <> iDate1900) And (DD > DF) Then
     Begin
          LastError := 1;
          LastErrorMsg := TraduireMemoire('La date de d�but doit �tre inf�rieure ou �gale � la date de fin');
     End;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 26/06/2007
Modifi� le ... :   /  /
Description .. : Actualisation de champs sur changement de compteur
Mots clefs ... :
*****************************************************************}
procedure TOM_PRESENCESALARIE.ChangeCompteur(Sender: TObject);
Var
     Temp : String;
begin
     // Actualisation du libell� du compteur
     SetControlText ('PYR_LIBELLE', THValComboBox(Sender).Text);

     // Mise � jour de la r�f�rence du compteur dans les champs cach�s
     Temp := THValComboBox(Sender).Value;
     SetControlText('PYP_COMPTEURPRES',ReadTokenSt(Temp));
     SetControlText('PYR_DATEVALIDITE',ReadTokenSt(Temp));
end;

Initialization
  registerclasses ( [ TOM_PRESENCESALARIE ] ) ; 
end.

