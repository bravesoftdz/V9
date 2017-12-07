{***********UNITE*************************************************
Auteur  ...... : NA
Cr�� le ...... : 26/01/2007
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : EXCEPTPRESSALGRP ()
                 Saisie group�e des exceptions de pr�sence des salari�s
Mots clefs ... : TOF;UTOFPGEXCEPTPRESSALGRP
*****************************************************************
PT1  20/07/2007  FLO         Gestion des anomalies
}
Unit UTOFPGEXCEPTPRESSALGRP;

Interface

Uses StdCtrls, 
     Controls, 
     Classes, 
{$IFNDEF EAGLCLIENT}
     db, 
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF} 
     mul, 
{$else}
     HQry, 
     eMul, 
{$ENDIF}
     uTob,
     forms,
     sysutils, 
     ComCtrls,
     HCtrls,
     HEnt1,
     HTB97,
     Vierge,
     ed_tools,
     HMsgBox,
     UTobDebug,
     UTOF,
     PGAnomaliesTraitement,
     PGPresence ;

Type
  TOF_PGExceptpressalGRP = Class (TOF)
    procedure OnArgument (S : String ) ; override ;
    procedure OnClose                  ; override ;
  private
    TheMul: TQUERY; // Query recuperee du mul
    Anomalies : TAnomalies;         //PT1
    GestionPres : TGestionPresence; //PT1

    procedure exceptionpresence(Sender : Tobject);
    procedure TrtTypeaffect(sender: TObject);
    procedure creationexception(Tob_Sal : Tob; Ztypeaffect, Zcycleaffect : string; Zdatedebut, Zdatefin : Tdatetime);
    function  ControleException (Salarie : String; dateDeb, dateFin : TDateTime; TypeAffect, CycleAffect: string) : Boolean; //PT1
  end ;

  //PT1 - D�but
  function ControleExisteException (Salarie: String; dateDeb, dateFin: TDateTime; TypeAffect : String; ModeInsert : Boolean = True) : Boolean;
  function ControleExisteAbsence (Salarie : String; dateDeb : TDateTime) : Boolean;
  //PT1 - Fin

Implementation

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 26/01/2007
Modifi� le ... :   /  /    
Description .. : On argument
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGEXCEPTPRESSALGRP.OnArgument (S : String ) ;
var
  COMBOtypeaffect: THValComboBox;
  btn: TToolBarButton97;
begin
  Inherited ;
  COMBOtypeaffect := THValComboBox(GetControl('TYPEAFFECT'));
  If COMBOtypeaffect <> Nil then COMBOtypeaffect.OnExit := TrtTypeaffect;

   if TFVierge(Ecran) <> nil then
   begin
    {$IFDEF EAGLCLIENT}
    TheMul := THQuery(TFVierge(Ecran).FMULQ).TQ;
    {$ELSE}
    TheMul := TFVierge(Ecran).FMULQ;
    {$ENDIF}
    end;

  // Prise en compte de la saisie de cette exception de pr�sence pour les salari�s s�lectionn�s
  Btn := TToolBarButton97(GetControl('B_VALIDER'));
  if btn<>nil then btn.OnClick := Exceptionpresence;

  //PT1 - D�but
  // Param�trage des anomalies
  Anomalies := TAnomalies.Create;
  Anomalies.ChangeLibAno(INFO1, TraduireMemoire('Salari�(s) absent(s) durant cette p�riode:'));
  Anomalies.ChangeLibAno(INFO2, TraduireMemoire('Le cycle normal est identique � l''exception saisie pour le ou les salari�(s) suivant(s) :'));
  Anomalies.ChangeLibAno(WARN1, TraduireMemoire('Une exception a d�j� �t� affect�e sur la p�riode au(x) salari�(s) suivant(s) :'));
  Anomalies.ChangeLibAno(ERR1,  TraduireMemoire('Une exception existe d�j� � cette date pour le ou les salari�(s) suivant(s) :'));
  //PT1 - Fin
end ;

procedure TOF_PGEXCEPTPRESSALGRP.OnClose ;
begin
  Inherited ;
  Anomalies.Free; //PT1
end ;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 26/01/2007
Modifi� le ... :   /  /    
Description .. : Modif type de l'affectation : Initialise la tablette pour le cycle 
Suite ........ : d'affectation
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGEXCEPTPRESSALGRP.TrtTypeaffect;
begin

  if THValComboBox(GetControl('TYPEAFFECT')).value = 'CYC' then
  setcontrolproperty('CYCLEAFFECT','Datatype','PGCYCLE')
  else
  if THValComboBox(GetControl('TYPEAFFECT')).value = 'JOU' then
  setcontrolproperty('CYCLEAFFECT','Datatype','PGJOURNEETYPE')
  else
  if  THValComboBox(GetControl('TYPEAFFECT')).value = 'MOD' then
  setcontrolproperty('CYCLEAFFECT','Datatype','PGMODELECYCLE');
end;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 26/01/2007
Modifi� le ... :   /  /    
Description .. : Mise � jour de l'exception de pr�sence pour les salari�s s�lectionn�s
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGEXCEPTPRESSALGRP.Exceptionpresence(sender : Tobject);
var
  tob_salarie, T1 : Tob;
  salarie, typeaffect, cycleaffect : string;
  datedebut, datefin : TDatetime;
  ListeAnomalies : TListBox;
begin

     typeaffect := getcontroltext('TYPEAFFECT');
     Cycleaffect := getcontroltext('CYCLEAFFECT');
     Datedebut := StrToDate(getcontroltext('DATEDEBUT'));
     Datefin := StrToDate(getcontroltext('DATEFIN'));

     If TheMul = nil then exit;

     //PT1 - D�but
     // Vidage des anomalies
     ListeAnomalies := TListbox(Getcontrol('LISTEANOMALIES'));
     ListeAnomalies.Items.Clear;
     Anomalies.Clear;
     //PT1 - Fin

     // lecture des salari�s s�lectionn�s pour les stocker dans la TOB
     Tob_salarie := Tob.Create('Les salari�s',Nil,-1);

     InitMoveProgressForm (NIL,TraduireMemoire('Traitement de l''affectation en cours'), TraduireMemoire('Veuillez patienter SVP ...'),theMul.RecordCount,FALSE,TRUE);
     TheMul.First;

     while Not theMul.EOF do
     begin
          T1 := Tob.Create('Salari�',Tob_salarie,-1);
          T1.AddChampSup('SALARIE',False);
          salarie := themul.findfield('PSA_SALARIE').asstring;
          T1.PutValue('SALARIE',Salarie);
          theMul.Next;
     end;

     //tobdebug(tob_salarie);
     Creationexception(tob_salarie,typeaffect, cycleaffect,datedebut, datefin);

     Anomalies.PutInList(ListeAnomalies);  //PT1

     freeandnil(Tob_salarie);
     FiniMoveProgressForm;

     PgiInfo(TraduireMemoire('Traitement termin�.'),TraduireMemoire('Mise � jour des exceptions de pr�sence des salari�s'));
     
     setcontrolenabled('B_VALIDER', false);
     setcontrolvisible('B_VALIDER', false);

     SetFocusControl('LISTEANOMALIES');
end;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 26/01/2007
Modifi� le ... :   /  /
Description .. : Traitement de l'affectation des salari�s � un cycle
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGEXCEPTPRESSALGRP.CreationException(Tob_Sal : Tob; Ztypeaffect, Zcycleaffect: string; Zdatedebut, Zdatefin : Tdatetime);
var
  sal : string;
  dtdeb, dtfin : Tdatetime;
  TobSalaries, T1 ,TobExceptions , T: Tob;
  i : integer;
begin
     dtdeb := zdatedebut;
     dtfin := zdatefin;

     // Chargement de toutes les informations de pr�sence
     GestionPres := TGestionPresence.Create(True,True,True,True,True,dtdeb,dtfin); //PT1

     TobExceptions := TOB.CREATE('Exception pr�sence salari�', nil, -1);

     // Traitement pour chaque salari� de la TOB
     if TOB_sal <> nil then
     begin
          TobSalaries := TOB_sal.FindFirst([''], [''], TRUE);

          while TobSalaries <> nil do
          begin
               sal := TobSalaries.GetValue('SALARIE');
               MoveCurProgressForm(Format(TraduireMemoire('Traitement du salari� : %s %s'), [Sal, RechDom('PGSALARIE',Sal,False)]));

               // Contr�le de coh�rence de l'exception pour ce salari�
               If ControleException (Sal, dtDeb, dtFin, Ztypeaffect, Zcycleaffect) Then //PT1
               Begin
                    T1 := TOB.CREATE('EXCEPTPRESENCESAL', TobExceptions, -1);
                    T1.PutValue('PYE_SALARIE', sal);
                    T1.putvalue('PYE_TYPEAFFECT', Ztypeaffect);
                    T1.putvalue('PYE_CYCLEAFFECT', Zcycleaffect);
                    T1.putvalue('PYE_DATEDEBUT', dtdeb);
                    T1.putvalue('PYE_DATEFIN', dtfin);
               End;

               TobSalaries := TOB_sal.FindNext([''], [''], TRUE);
          end;

          For i := 0 to TobExceptions.detail.Count - 1 do
          begin
               T := TobExceptions.Detail[i];
               Try
                    T.InsertDB(nil, false);
               Except // Duplicate key
                    Anomalies.Add(ERR1, T.GetValue('PYE_SALARIE') + '  ' + RechDom('PGSALARIE', T.GetValue('PYE_SALARIE'), False));  //PT1
               End;
          end;
          FreeAndNil(TobSalaries);
     end;

     FreeAndNil(GestionPres);    //PT1
     FreeAndNil(TobExceptions);
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 20/07/2007 / PT1
Modifi� le ... :   /  /
Description .. : Contr�le la cr�ation d'une exception pour un salari�
Mots clefs ... :
*****************************************************************}
function TOF_PGEXCEPTPRESSALGRP.ControleException(Salarie: String; dateDeb, dateFin: TDateTime; TypeAffect, CycleAffect: String): Boolean;
Var
    Cycle, TypeCycle : String;
    ExceptionSal,ExceptionCycle : Boolean;
begin
     Result := True;

     // Contr�le des exceptions existantes du m�me type
     If Not ControleExisteException (Salarie, dateDeb, dateFin, TypeAffect) Then
     Begin
          Anomalies.Add(WARN1, Salarie + '  ' + RechDom('PGSALARIE', Salarie, False));
          Result := False;
     End;

     // Contr�le que le cycle normal du salari� ne soit pas d�j� le m�me que l'exception
     If Result Then
     Begin
          GestionPres.GetJourneeTypeSalarie(dateDeb, Salarie, Cycle, TypeCycle, ExceptionSal, ExceptionCycle, False);
          If (TypeAffect = TypeCycle) And (CycleAffect = Cycle) AND (ExceptionSal = false) Then
          Begin
               Anomalies.Add(INFO2, Salarie + '  ' + RechDom('PGSALARIE', Salarie, False));
          End;
     End;

     // Contr�le que le salari� soit pr�sent � la date indiqu�e, sinon message d'alerte
     If Result Then
     Begin
          If ControleExisteAbsence (Salarie, dateDeb) Then
          Begin
               Anomalies.Add(INFO1, Salarie + '  ' + RechDom('PGSALARIE', Salarie, False));
          End;
     End;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 22/07/2007 / PT1
Modifi� le ... :   /  /    
Description .. : Contr�le l'existence d'une exception d'un type particulier 
Suite ........ : (rythme ou mod�le de cycle) sur une p�riode d�finie
Param�tres ... : Salari�, dates de d�but et de fin de l'exception, type de l'exception
Suite ........ : Mode insertion : True si dsInsert, False si dsEdit
Mots clefs ... : EXCEPTION;CHEVAUCHE;
*****************************************************************}
function ControleExisteException (Salarie: String; dateDeb, dateFin: TDateTime; TypeAffect : String; ModeInsert : Boolean = True) : Boolean;
Var
  TobExcept, T : TOB;
  i : Integer;
  DateDebTemp, DateFinTemp : TDateTime;
  Requete : String;
Begin
     Result := True;

     // Chargement des exceptions existantes pour ce salari�
     TobExcept := TOB.Create('LesExceptions', Nil, -1);
     Requete := 'SELECT PYE_DATEDEBUT,PYE_DATEFIN FROM EXCEPTPRESENCESAL WHERE PYE_SALARIE="'+Salarie+'"';
     If Not ModeInsert Then Requete := Requete + ' AND PYE_DATEDEBUT <> "'+UsDateTime(dateDeb)+'"';
     TobExcept.LoadDetailDBFromSQL('EXCEPTPRESENCESAL', Requete);

     // Contr�le de chevauchement avec d'autres exceptions
     For i := 0 To (TobExcept.Detail.Count - 1) Do
     Begin
          T := TobExcept.Detail[i];

          DateDebTemp := T.GetValue('PYE_DATEDEBUT');
          DateFinTemp := T.GetValue('PYE_DATEFIN');

          If ( ((dateDeb >= DateDebTemp) And (dateDeb <= DateFinTemp)) Or
               ((dateFin >= DateDebTemp) And (dateFin <= DateFinTemp)) Or
               ((dateDeb <= DateDebTemp) And (dateFin >= DateFinTemp)) Or
               ((dateDeb >= DateDebTemp) And (dateFin <= DateFinTemp))) Then
          Begin
               Result := False;
               Break;
          End;
     End;
     FreeAndNil(TobExcept);
End;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 22/07/2007 / PT1
Modifi� le ... :   /  /    
Description .. : D�termine si le salari� est absent au d�but de l'exception
Param�tres ... : Salari�, date de d�but de l'exception
Mots clefs ... : EXCEPTION;ABSENT;
*****************************************************************}
function ControleExisteAbsence (Salarie : String; dateDeb : TDateTime) : boolean;
Begin
     Result := ExisteSQL('SELECT 1 FROM ABSENCESALARIE WHERE PCN_SALARIE="'+Salarie+'" AND PCN_DATEDEBUTABS<="'+UsDateTime(dateDeb)+'" AND PCN_DATEFINABS>="'+UsDateTime(dateDeb)+'" AND PCN_TYPEMVT<>"PRE"');
End;

Initialization
  registerclasses ( [ TOF_PGEXCEPTPRESSALGRP ] ) ;
end.
