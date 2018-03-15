unit UBTPSequenceCpta;

interface
uses uTob, HEnt1, HCtrls, StdCtrls, Ent1,
     DB,SysUtils,ADODB,Forms,
    {$IFNDEF DBXPRESS} dbtables {$ELSE} uDbxDataSet {$ENDIF}
;
// COMPTA
function CleSequence(TypeSouche,CodeSouche:string;DD:tDateTime;MulTiExo:boolean) : string;
function GetNextSequence(Cle: string; nombre : integer; Entity : integer=0) : integer;
// GC - GRC - BTP
function ConstitueCodeSequenceGC (TypeSouche,CodeSouche : string) : string;


implementation

function wExistTable(Const TableName:String): Boolean;
begin
	Result := TableToNum(TableName) <> 0;
end;

function CodeExo(DD:tDateTime):string;
var i : integer;
begin
  Result:=GetEnCours.Code ;
  If (dd>=GetEnCours.Deb) and (dd<=GetEnCours.Fin) then Result:=GetEnCours.Code
  else If (dd>=GetSuivant.Deb) and (dd<=GetSuivant.Fin) then Result:=GetSuivant.Code
  else If (dd>=GetPrecedent.Deb) and (dd<=GetPrecedent.Fin) then Result:=GetPrecedent.Code
  else For i:=1 To 5 do begin
    If (dd>=GetExoClo[i].Deb) And (dd<=GetExoClo[i].Fin)then Result:=GetExoClo[i].Code;
  end;
end;

function Cop(code:string;long:integer):string;
begin
  Result:=Copy(Code+'----',1,long);
end;

function CleSequence(TypeSouche,CodeSouche:string;DD:tDateTime;MulTiExo:boolean) : string;
begin
  if MultiExo then
    Result:=Cop(TypeSouche,3)+Cop(CodeSouche,3)+cop(CodeExo(DD),3)
  else Result:=Cop(TypeSouche,3)+Cop(CodeSouche,3);
end;

function GetNextSequence(Cle: string; nombre : integer; Entity : integer=0) : integer;
var CNX : TADOConnection;
    QQ : TADOQuery;
    NbRec,OldValue : integer;
    SQL : string;
begin
  Result := -1;
  CNX := TADOConnection.Create(application);
  Cnx.ConnectionString :=DBSOC.ConnectionString;
  CNX.LoginPrompt := false;
  TRY
    CNX.Connected := True;
    Cnx.BeginTrans;
    TRY
      //
      QQ := TADOQuery.Create(Application);
      QQ.Connection := CNX;
      if wExistTable ('CPSEQCORRESP') then
      begin
        SQL := 'SELECT DSQ_VALEUR,DSQ_INCREMENT FROM DESEQUENCES WHERE DSQ_CODE=(SELECT CSC_SEQUENCE FROM CPSEQCORRESP WHERE CSC_METIER='''+Cle+''')';
      end else
      begin
        SQL := 'SELECT DSQ_VALEUR,DSQ_INCREMENT FROM DESEQUENCES WHERE DSQ_CODE='''+Cle+'''';
      end;
      QQ.SQL.Text := SQL;
      QQ.Prepared := True;
      QQ.Open;
      TRY
        if not QQ.Eof then
        begin
          OldValue := QQ.Fields[0].AsInteger;
          Result := OldValue + QQ.fields[1].AsInteger;
        end;
        QQ.Close;
        // -------------------------
        QQ.Active := false;
        QQ.SQL.Clear;
        if wExistTable ('CPSEQCORRESP') then
        begin
          SQL := 'UPDATE DESEQUENCES SET DSQ_VALEUR='+InttoStr(Result)+' WHERE DSQ_CODE=(SELECT CSC_SEQUENCE FROM CPSEQCORRESP WHERE CSC_METIER='''+Cle+''') AND DSQ_VALEUR='+InttoStr(OldValue);
        end else
        begin
          SQL := 'UPDATE DESEQUENCES SET DSQ_VALEUR='+InttoStr(Result)+' WHERE DSQ_CODE='''+Cle+''' AND DSQ_VALEUR='+InttoStr(OldValue);
        end;
        QQ.sql.text := SQL;
        if QQ.ExecSQL = 0 then
        begin
          Result := -1;
          Raise Exception.Create('Erreur mise à jour compteur pièece comptable');
        end;

      FINALLY
        QQ.Free;
      end;

      CNX.CommitTrans;
    EXCEPT
      on E:Exception do
      begin
//        Application.MessageBox (PAnsiChar('Erreur '+#10#13+E.message),'') ;
        CNX.RollbackTrans;
        Raise;
      end;
    end;
  finally
    CNX.Close;
    Cnx.Free;
  end;

end;

function VerifCaractereInterditSouche : string ;
Var ST,NewSt,SauveSt,SH_TYPE : String ;
    Q : tquery ;
    TobS,TobL : tob ;
    TobSAll : tob ;
    i : Integer ;
    Car : Char ;
    OkOk :Boolean ;
begin
  Result:='' ;
  TobS := TOB.Create('', nil, -1);
  TobSAll := TOB.Create('', nil, -1);
  try
    Try
    St:='SELECT * FROM SOUCHE WHERE SH_TYPE IN ("CPT","BUD","REL","TRE") AND SH_SOUCHE LIKE "%.%" ' ;
    Q:=OpenSQL(St,True) ;
    TobS.LoadDetailDB ('SOUCHE', '', '', Q, True);
    Ferme(Q) ;

    St:='SELECT * FROM SOUCHE WHERE SH_TYPE IN ("CPT","BUD","REL","TRE") ' ;
    Q:=OpenSQL(St,True) ;
    TobSAll.LoadDetailDB ('SOUCHE', '', '', Q, True);
    Ferme(Q) ;

    If TobS.Detail.Count>0 then
      begin
      For i:=0 To TobS.Detail.Count-1 Do
        BEGIN

        TobL:=TobS.Detail[i] ;
        SH_TYPE:=TobL.GetValue('SH_TYPE') ;
        St:=TobL.GetValue('SH_SOUCHE') ; SauveSt:=St ;
        Car:='A' ;
        Repeat
        NewSt:=FindEtReplace(St, '.', Car, True);
        OkOk:=TRUE ;

        If TobSAll.FindFirst(['SH_TYPE','SH_SOUCHE'],[SH_TYPE,NewSt],TRUE) <>NIL Then
           begin
           OkOK:=False ;
           If car='Z' then BEGIN OkOk:=TRUE ; Result:=Result+SH_TYPE+';'+SauveSt+';' ; END  Else Car:=Succ(Car) ;
           END ;
        If Not OkOk Then St:=SauveSt ;
        until OkOk ;
        If OkOk then
          begin
          If SH_TYPE='CPT' then
            begin
            ExecuteSQL('UPDATE JOURNAL SET J_COMPTEURNORMAL="'+NewSt+'" WHERE J_COMPTEURNORMAL="'+SauveSt+'" ') ;
            ExecuteSQL('UPDATE JOURNAL SET J_COMPTEURSIMUL="'+NewSt+'" WHERE J_COMPTEURSIMUL="'+SauveSt+'" ');
            end Else
          If SH_TYPE='BUD' then
            begin
            ExecuteSQL('UPDATE BUDJAL SET BJ_COMPTEURNORMAL="'+NewSt+'" WHERE BJ_COMPTEURNORMAL="'+St+'" ');
            ExecuteSQL('UPDATE BUDJAL SET BJ_COMPTEURSIMUL="'+NewSt+'" WHERE BJ_COMPTEURSIMUL="'+St+'" ');
            end ;
          ExecuteSQL('UPDATE SOUCHE SET SH_SOUCHE="'+NewSt+'" WHERE SH_TYPE="'+SH_TYPE+'" AND SH_SOUCHE="'+SauveSt+'" ')
          end;
        END ;
      END ;
    except
      Result:='ERREUR' ;
      raise Exception.Create(traduirememoire('Création Séquence : Problème de transformation des codes souches (Caractère ".")'));
    End ;
  Finally
    TobS.ClearDetail ; TobS.Free ;
    TobSAll.ClearDetail ; TobSAll.Free ;
  end ;
END ;

function OkSouche(Q : tQuery ; St : String) : Boolean ;
Var LeTypeSouche,LaSouche : string ;
begin
  Result:=TRUE ; if St='' Then Exit ;
  LeTypeSouche:=ReadTokenSt(st) ; LaSouche:=ReadTokenSt(st) ;
  If LeTypeSouche='' Then Exit ; If LaSouche='' Then Exit ;
  If (Q.FindField('SH_TYPE').AsString=LeTypeSouche) And (Q.FindField('SH_SOUCHE').AsString=LaSouche) Then Result:=FALSE ;
END ;


// -------------------------------------------------------

function ConstitueCodeSequenceGC (TypeSouche,CodeSouche : string) : string;
begin
  result := 'SH~'+TypeSouche+'~'+CodeSouche;
end;

end.
