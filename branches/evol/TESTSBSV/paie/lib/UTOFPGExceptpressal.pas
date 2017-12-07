{***********UNITE*************************************************
Auteur  ...... : NA
Cr�� le ...... : 26/01/2007
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : EXCEPTPRESSAL_MUL ()
                 Saisie des exceptions de pr�sence pour un salari�
Mots clefs ... : UTOFPGEXCEPTPRESSAL
*****************************************************************
PT1  20/07/2007  FLO         Gestion des saisies et suppressions group�es
}
Unit UTOFPGExceptpressal ;

Interface

Uses StdCtrls, 
     Controls, 
     Classes, 
{$IFNDEF EAGLCLIENT}
     db, 
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF} 
     mul,
     HDB,
     fe_main,
{$else}
     eMul, 
     uTob,
     maineagl,
{$ENDIF}
     forms,
     AglInit ,
     sysutils, 
     ComCtrls,
     HCtrls, 
     HEnt1, 
     HMsgBox,
     P5def,
     HTB97,
     Hqry,
     UTOF ; 

Type
  TOF_PGExceptpressal = Class (TOF)
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;

    private
     GblListe , Selectsal: string;
     procedure ActiveWhere (Sender: TObject);
     procedure ChangeListe(Sender: TObject);
     procedure CreationException(Sender : Tobject);
     procedure Exceptionpresence(Sender : Tobject);
     procedure SuppressionException (Sender : TObject);
     procedure GrilleDblClick (Sender : Tobject);
  end ;

Implementation


{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 26/01/2007
Modifi� le ... :   /  /    
Description .. : Chargement de la fiche
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGExceptpressal.OnLoad ;

begin
  Inherited ;
//  ActiveWhere (NIL); //PT1
     ChangeListe(Nil);
end ;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 26/01/2007
Modifi� le ... :   /  /
Description .. : On Argument
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGExceptpressal.OnArgument (S : String ) ;
var
CBLISTEVAL : THvalcombobox;
num : integer;
Btn : TToolBarButton97;
{$IFNDEF EAGLCLIENT}
Liste:THDBGrid;
{$ELSE}
Liste:THGrid;
{$ENDIF}
begin
  Inherited ;

  // Lnitialise les champs libres
  For Num := 1 to 4 do
     VisibiliteChampSalarie (IntToStr(Num),GetControl ('PSA_TRAVAILN'+IntToStr(Num)),GetControl ('TPSA_TRAVAILN'+IntToStr(Num)));
     VisibiliteStat (GetControl ('PSA_CODESTAT'),GetControl ('TPSA_CODESTAT')) ;

  // Gestion des boutons "ouvrir" , "insert"  et "double click"
  {$IFNDEF EAGLCLIENT}
  Liste:=THDBGrid(GetControl('FLISTE'));
  {$ELSE}
  Liste:=THGrid(GetControl('FLISTE'));
  {$ENDIF}
  if Liste <> NIL then Liste.OnDblClick := GrilleDblClick;

  Btn := TToolBarButton97(GetControl('Binsert'));
  if btn <> nil then Btn.Onclick := CreationException;   // Cr�ation exception pour un salari�

  Btn := TToolBarButton97(GetControl('BOUVRIR'));
  if btn <> nil then Btn.Onclick := Exceptionpresence;   // Cr�ation exception pour une s�lection de salari�s

  //PT1 - D�but
  Btn := TToolBarButton97(GetControl('BDelete'));
  If Btn <> Nil Then Btn.Onclick := SuppressionException;   // Suppression d'une s�lection d'exceptions 
  //PT1 - Fin

  // Changement de liste
  SetControlText('CBLISTE','EXC'); //PT1
  Cblisteval := THValComboBox(GetControl('CBLISTE'));
  if Assigned(cblisteval) then Cblisteval.Onchange := ChangeListe;

//  ChangeListe(nil);  //PT1

end ;


{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 26/01/2007
Modifi� le ... : 23/07/2007 / PT1
Description .. : Active la clause WHERE
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGExceptpressal.ActiveWhere(Sender: TObject);
var
    StWhere   : String;
    datedebut : TDatetime;
begin
     DateDebut := StrToDate(GetControlText('DATEDEBUT'));
     SetControlText('XX_WHERE','');
     StWhere := '';

     StWhere := RecupWhereCritere(GetControl('PAGES') As TPageControl);
     If StWhere <> '' Then
     Begin
          // Suppression du mot cl� WHERE
          StWhere := Copy(StWhere, 6, Length(StWhere));
          StWhere := StWhere + ' AND ';
     End;

     StWhere := StWhere + '(PSA_DATESORTIE >="'+UsDateTime(DateDebut)+'" OR PSA_DATESORTIE <="'+UsdateTime(iDate1900)+'" OR' +
                ' PSA_DATESORTIE IS NULL) ';

     If SelectSal <> '' Then Stwhere := Stwhere + ' AND ' + SelectSal;

     If GetControlText('CBLISTE') = 'EXC' Then
          StWhere := StWhere + ' AND PYE_DATEDEBUT >= "'+UsDateTime(DateDebut)+'" ';

     SetControlText('XX_WHERE', StWhere);
end;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 26/01/2007
Modifi� le ... : 20/07/2007 / PT1
Description .. : Changement de liste 
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGExceptpressal.ChangeListe(Sender: TObject);
begin
     // Construit la clause Where
     ActiveWhere(nil);

     // Evite de rafra�chir la liste si c'est la m�me qui a �t� res�lectionn�e
     if GblListe = GetControlText('CBLISTE') then exit;

     // D�selection des lignes
     TFMul(Ecran).FListe.ClearSelected; //PT1

     // Changement de la liste associ�e
     if GetControlText('CBLISTE')= 'SAL' then
     Begin
          TFMul(Ecran).SetDBListe('PGMULSALARIE');
          //PT1 - D�but
          SetControlVisible ('BOuvrir', True);
          SetControlVisible ('BDelete', False);
          //PT1 - Fin
     End
     else if GetControlText('CBLISTE')= 'EXC' then
     Begin
          TFMul(Ecran).SetDBListe('PGEXCEPTPRESSAL');
          //PT1 - D�but
          SetControlVisible ('BOuvrir', False);
          SetControlVisible ('BDelete', True);
          //PT1 - Fin
     End;

     // Sauvegarde de la liste en cours
     GblListe := GetControlText('CBLISTE');
     
     // Rafra�chissement de la liste
     If Sender <> Nil Then             //PT1
          TFMul(Ecran).BCherche.Click;
end;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 26/01/2007
Modifi� le ... :   /  /
Description .. : Double click
Mots clefs ... :
*****************************************************************}
procedure TOF_PGExceptpressal.GrilleDblClick (Sender : Tobject);
var Q_Mul:THQuery ;
    St : String;
    {$IFDEF EAGLCLIENT}
    Liste:THGrid;
    {$ENDIF}
begin
    {$IFDEF EAGLCLIENT}
    Liste:=THGrid(GetControl('FLISTE'));
    TFmul(Ecran).Q.TQ.Seek(Liste.Row-1) ;
    {$ENDIF}
    Q_Mul:=THQuery(Ecran.FindComponent('Q'));

    // Si liste exception : Modification d'une exception d�j� saisie
    if GetControlText('CBLISTE')= 'EXC' then
    begin
     st  := Q_MUL.FindField('PYE_SALARIE').AsString +';' + DateTostr(Q_MUL.FindField('PYE_DATEDEBUT').AsDatetime);
  
     AGLLanceFiche('PAY','EXCEPTPRESSAL','',St,'ACTION=MODIFICATION');
     TFMul(Ecran).BCherche.Click;
    end
    else
    // si liste salari�s : saisie d'une exception pour le salari� s�lectionn�
    begin
      st:= 'ACTION=CREATION' + ';' + Q_MUL.FindField('PSA_SALARIE').AsString + ';' + Q_MUL.Findfield('PSA_LIBELLE').asstring  + ';' +
      Q_MUL.Findfield('PSA_PRENOM').Asstring+';'+StDate1900+';'+StDate1900;
      AGLLanceFiche('PAY','EXCEPTPRESSAL','','',st);
    end;
end;

{***********A.G.L.**********************************************************
Auteur  ...... : NA
Cr�� le ...... : 26/01/2007
Modifi� le ... :   /  /
Description .. : Insert : Cr�ation d'une exception de pr�sence d'un salari�

Mots clefs ... :
****************************************************************************}
procedure TOF_PGExceptpressal.CreationException (Sender : Tobject);

begin
    AGLLanceFiche('PAY','EXCEPTPRESSAL','','','ACTION=CREATION');
    TFMul(Ecran).BCherche.Click;
end;

{***********A.G.L.*****************************************************************
Auteur  ...... : NA
Cr�� le ...... : 26/01/2007
Modifi� le ... :   /  /    
Description .. : Saisie d'une exception de pr�sence pour les salari�s s�lectionn�s
Mots clefs ... : 
**********************************************************************************}
procedure TOF_PGExceptpressal.Exceptionpresence (sender : Tobject);
var
  Salarie, st : string;
  i           : integer;
begin

     if (TFmul(Ecran).Fliste.NbSelected = 0) and (not TFmul(Ecran).Fliste.AllSelected) then
     begin
          PGIBOX('Aucun salari� s�lectionn�', Ecran.Caption);
          exit;
     end;

     { Gestion de la s�lection des salari�s}

     if PgiAsk('Saisie d''une exception de pr�sence pour les salari�s s�lectionn�s. Voulez-vous poursuivre ?', Ecran.caption) = mrYes then
     begin  // D2

          St := '';
          if (TFmul(Ecran).Fliste.AllSelected = TRUE) then
          begin   // D3
               // Si tout est s�lectionn�
               TFmul(Ecran).Q.First;
               while not TFmul(Ecran).Q.EOF do
               begin
                    Salarie := TFmul(Ecran).Q.FindField('PSA_SALARIE').asstring;
                    St := St + ' PSA_SALARIE="' + Salarie + '" OR';
                    TFmul(Ecran).Q.Next;
               end;
               TFMul(Ecran).FListe.ClearSelected;
          end
          else
          // lecture de chaque salari� s�lectionn�
          begin
               { Composition du clause WHERE pour limiter le mul � ces salari�s }
               for i := 0 to TFmul(Ecran).Fliste.NbSelected - 1 do
               begin
                    {$IFDEF EAGLCLIENT}
                         TFMul(Ecran).Q.TQ.Seek(TFMul(Ecran).FListe.Row - 1);
                    {$ENDIF}
                    TFMul(Ecran).Fliste.GotoLeBOOKMARK(i);
                    Salarie := TFmul(Ecran).Q.FindField('PSA_SALARIE').asstring;
                    St := St + ' PSA_SALARIE="' + Salarie + '" OR';
               end;
               TFMul(Ecran).FListe.ClearSelected;
          end;

          if St <> '' then St := Copy(St, 1, Length(st) - 2)  ;
          Selectsal :=  St;
          TFMul(Ecran).BCherche.Click;


          { R�cup�ration de la Query pour traitement dans la fiche vierge }
          {$IFDEF EAGLCLIENT}
               if TFMul(Ecran).Fetchlestous then TheMulQ := TOB(Ecran.FindComponent('Q'));
          {$ELSE}
               TheMulQ := THQuery(Ecran.FindComponent('Q'));
          {$ENDIF}

          {Ouverture de la fiche}
          AglLanceFiche('PAY', 'EXCEPTPRESSALGRP', '', '', '');
          
          TheMulQ := nil;
          Selectsal := '';
          TFMul(Ecran).BCherche.Click;
     end; // E2
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 23/07/2007 / PT1
Modifi� le ... :   /  /    
Description .. : Suppression group�e d'exceptions
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGExceptpressal.SuppressionException(Sender: TObject);
Var
     Salarie, St, DateDebut : String;
     i, Reponse             : Integer;
begin
     //PT1 - D�but
     If (TFmul(Ecran).Fliste.NbSelected = 0) And (Not TFmul(Ecran).Fliste.AllSelected) Then
     begin
          PGIBox(TraduireMemoire('Aucune exception n''est s�lectionn�e'), Ecran.Caption);
          Exit;
     End;

     If (TFmul(Ecran).Fliste.NbSelected = 1) Then
          Reponse := PgiAsk(TraduireMemoire('Etes-vous s�r de vouloir supprimer l''exception s�lectionn�e ?'), Ecran.caption)
     Else
          Reponse := PgiAsk(TraduireMemoire('Etes-vous s�r de vouloir supprimer les exceptions s�lectionn�es ?'), Ecran.caption);

     If Reponse = mrYes Then
     Begin
          St := '';

          // Cas 1 : Tout est s�lectionn�
          If (TFmul(Ecran).Fliste.AllSelected = True) Then
          Begin
               TFmul(Ecran).Q.First;
               While Not TFmul(Ecran).Q.EOF Do
               Begin
                    Salarie   := TFmul(Ecran).Q.FindField('PYE_SALARIE').AsString;
                    DateDebut := TFmul(Ecran).Q.FindField('PYE_DATEDEBUT').AsString;
                    St := St + ' (PYE_SALARIE="' + Salarie + '" AND PYE_DATEDEBUT="'+UsDateTime(StrToDate(DateDebut))+'") OR';
                    TFmul(Ecran).Q.Next;
               End;
               TFMul(Ecran).FListe.ClearSelected;
          End
          // Cas 2 : Un certain nombre de salari�s a �t� s�lectionn�
          Else
          Begin
               For i := 0 To TFmul(Ecran).Fliste.NbSelected - 1 Do
               Begin
                    {$IFDEF EAGLCLIENT}
                         TFMul(Ecran).Q.TQ.Seek(TFMul(Ecran).FListe.Row - 1);
                    {$ENDIF}
                    TFMul(Ecran).Fliste.GotoLeBOOKMARK(i);
                    Salarie   := TFmul(Ecran).Q.FindField('PYE_SALARIE').AsString;
                    DateDebut := TFmul(Ecran).Q.FindField('PYE_DATEDEBUT').AsString;
                    St := St + ' (PYE_SALARIE="' + Salarie + '" AND PYE_DATEDEBUT="'+UsDateTime(StrToDate(DateDebut))+'") OR';
               End;
               TFMul(Ecran).FListe.ClearSelected;
          End;

          // Suppression du OR final
          If St <> '' Then St := Copy(St, 1, Length(st) - 2)  ;

          // Ex�cution de la requ�te
          ExecuteSQL ('DELETE FROM EXCEPTPRESENCESAL WHERE '+St);

          // Rafra�chissement de la liste
          TFMul(Ecran).BCherche.Click;
      end;
      //PT1 - Fin
end;

Initialization
  registerclasses ( [ TOF_PGExceptpressal ] ) ;
end.
