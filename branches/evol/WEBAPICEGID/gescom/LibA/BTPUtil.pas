unit BTPUtil;

interface

uses Classes,HEnt1,Ent1,EntGC,UTob,FactUtil,
{$IFDEF EAGLCLIENT}
{$ELSE}
     DBTables,
{$ENDIF}
     HCtrls,CalcOleGenericAff,ParamSoc,SysUtils,FactComm;

Procedure MajSousAffaire(TobPiece:TOB; CodeAvenant : string;Action : TActionFiche);

implementation

uses AffaireUtil;

Procedure MajSousAffaire(TobPiece:TOB; CodeAvenant : string;Action : TActionFiche);
Var CodeAffaire , Req,NumNouv,NumAnc: string;
    NbPiece, NumAff, i: Integer;
    Result : boolean;
    Part0, Part1, Part2, Part3,Avenant : String;
    CleDocAffaire : R_CLEDOC;
    TOBAffaire : TOB;
    TOBAffaire2 : TOB;
    codessaff, Numpiece, Statutaff : String;
    Q : TQuery ;
BEGIN
CodeAffaire := TobPiece.GetValue('GP_AFFAIRE');

if (TobPiece.Getvalue ('GP_NATUREPIECEG') = VH_GC.AFNatProposition) then
   Statutaff := 'PRO' //devis
else
begin
   Statutaff := 'AFF'; // commandes
   // maj affaire accept�e d'office si commande
   Req := 'UPDATE AFFAIRE SET AFF_ETATAFFAIRE = "ACP" WHERE AFF_AFFAIRE='+'"'+CodeAffaire+'"';
   ExecuteSQL(Req);
end;

     //contr�le nombre de pi�ces pour l'affaire si code affaire renseign�
     //sinon toujours -1
     if (CodeAffaire <> '') then
        NbPiece := SelectPieceAffaire(CodeAffaire, statutaff, CleDocAffaire) // Lancement avec PRO pour lecture des devis sinon lit les commandes
     else
        NbPiece := -1;

     // Une seule pi�ce pour l'affaire
     if NbPiece < 2 then
     begin
       Codessaff := CodeAffaire;

       // Cr�ation sans code affaire
       if (Action = taCreat) and (CodeAffaire = '') then
       begin
           // cr�ation sous-affaire pour la pi�ce
           // lecture compteur sous-affaire
           NumAff := (GetParamsoc('SO_AFFCOMPTEUR'))+1;
           SetParamSoc('SO_AFFCOMPTEUR',NumAff) ;
           Codessaff := Format ('%.14d',[NumAff]);
           Codessaff := 'Z'+Codessaff+'00';

           TOBAffaire2:=TOB.Create('AFFAIRE',Nil,-1);
           CodeAffaireDecoupe(Codessaff, Part0, Part1, Part2, Part3,Avenant,taConsult,False);
           TOBAffaire2.PutValue('AFF_AFFAIRE', Codessaff);
           TOBAffaire2.PutValue('AFF_AFFAIRE0', 'Z');
           TOBAffaire2.PutValue('AFF_AFFAIRE1', Part1);
           TOBAffaire2.PutValue('AFF_AFFAIRE2', Part2);
           TOBAffaire2.PutValue('AFF_AFFAIRE3', Part3);
           TOBAffaire2.PutValue('AFF_AVENANT', Avenant);
           TOBAffaire2.PutValue('AFF_REFERENCE', '-');
           TOBAffaire2.PutValue('AFF_AFFAIREREF', CodeAffaire);
           TOBAffaire2.PutValue('AFF_STATUTAFFAIRE', '');
           TOBAffaire2.PutValue('AFF_ETATAFFAIRE', 'ENC');
           TOBAffaire2.PutValue('AFF_TIERS', TOBPIECE.GetValue('GP_TIERS'));
           TOBAffaire2.PutValue('AFF_LIBELLE', TOBPIECE.GetValue('GP_REFINTERNE'));
           TOBAffaire2.PutValue('AFF_AFFAIREHT', 'X');

           Result := TOBAffaire2.InsertDB(Nil);
           TOBAffaire2.free;
           TOBAffaire2 := Nil;
       end;

       // cr�ation lien piece/affaire
       NumNouv := EncodeRefPiece(TOBPIECE);
       NumPiece := IntToStr(TOBPIECE.GetValue('GP_NUMERO'));
       if (Action = taCreat) then
       begin
          Req := 'INSERT INTO AFFPIECES '+
                  '(AFP_REFPIECE,AFP_AFFAIREREF,AFP_SSAFFAIRE,AFP_NATUREPIECEG,AFP_SOUCHE,AFP_NUMPIECE) '+
                  ' VALUES '+
                  '("'+NumNouv+'","'+CodeAffaire+'","'+Codessaff+'","'+TOBPIECE.GetValue('GP_NATUREPIECEG')+'","'+TOBPIECE.GetValue('GP_SOUCHE')+'",'+ NumPiece +')';
          ExecuteSQL(Req);
       end
       else
       begin
          Req := 'UPDATE AFFPIECES SET AFP_AFFAIREREF ='+'"'+ Codeaffaire+'" WHERE AFP_REFPIECE='+'"'+NumNouv+'"';
          ExecuteSQL(Req);
          // relecture sous-affaire
          Req := 'SELECT AFP_SSAFFAIRE FROM AFFPIECES WHERE AFP_REFPIECE='+'"'+NumNouv+'"';
          Q := OpenSQL(Req, True);
          Codessaff:=Q.FindField('AFP_SSAFFAIRE').AsString ;
          Ferme(Q);
          // maj affaire r�f�rence dans sous-affaire
          Req := 'UPDATE AFFAIRE SET AFF_AFFAIREREF ='+'"'+ Codeaffaire+'" WHERE AFF_AFFAIRE='+'"'+Codessaff+'"';
          ExecuteSQL(Req);
       end;
     end
     else
     begin
     // Si NbPiece = 2, traitement de maj multipi�ces par affaire � savoir :
     // - maj de l'affaire en cours : code affaire r�f�rence � vrai
     // - cr�ation de la sous-affaire de la 1ere pi�ce et cr�ation de l'enreg. correspondant dans la table lien pi�ces/affaires
     // Si NbPiece > 2 :
     // - cr�ation de la sous-affaire de la nouvelle pi�ce et cr�ation de l'enreg. correspondant dans la table lien pi�ces/affaires

        // cr�ation TOB Affaire
        TOBAffaire:=TOB.Create('AFFAIRE',Nil,-1) ;
        RemplirTOBAffaire(CodeAffaire,TobAffaire);
        TOBAffaire2:=TOB.Create('AFFAIRE',Nil,-1);
        TOBAffaire2.Dupliquer (TOBAffaire, True, true);

        if NbPiece = 2 then
        begin
           if (Statutaff = 'PRO') then
           begin
             // maj affaire r�f�rence si devis
             Req := 'UPDATE AFFAIRE SET AFF_REFERENCE = "X" WHERE AFF_AFFAIRE='+'"'+CodeAffaire+'"';
             ExecuteSQL(Req);
           end;

           // cr�ation sous-affaire pour 1ere pi�ce

           // relecture sous-affaire
           Req := 'SELECT AFP_SSAFFAIRE FROM AFFPIECES WHERE AFP_AFFAIREREF='+'"'+CodeAffaire+'"';
           Q := OpenSQL(Req, True);
           Codessaff:=Q.FindField('AFP_SSAFFAIRE').AsString ;
           Ferme(Q);

           if Codessaff = CodeAffaire then
           begin
             //lecture compteur sous-affaire
             NumAff := (GetParamsoc('SO_AFFCOMPTEUR'))+1;
             SetParamSoc('SO_AFFCOMPTEUR',NumAff) ;
             Codessaff := Format ('%.14d',[NumAff]);
             Codessaff := 'Z'+Codessaff+'00';

             CodeAffaireDecoupe(Codessaff, Part0, Part1, Part2, Part3,Avenant,taConsult,False);
             TOBAffaire2.PutValue('AFF_AFFAIRE', Codessaff);
             TOBAffaire2.PutValue('AFF_AFFAIRE0', 'Z');
             TOBAffaire2.PutValue('AFF_AFFAIRE1', Part1);
             TOBAffaire2.PutValue('AFF_AFFAIRE2', Part2);
             TOBAffaire2.PutValue('AFF_AFFAIRE3', Part3);
             TOBAffaire2.PutValue('AFF_AVENANT', Avenant);
             TOBAffaire2.PutValue('AFF_REFERENCE', '-');
             TOBAffaire2.PutValue('AFF_AFFAIREREF', CodeAffaire);
             TOBAffaire2.PutValue('AFF_STATUTAFFAIRE', '');
             TOBAffaire2.PutValue('AFF_TIERS', TOBPIECE.GetValue('GP_TIERS'));
             TOBAffaire2.PutValue('AFF_ETATAFFAIRE', 'ENC');
             TOBAffaire2.PutValue('AFF_LIBELLE', TOBPIECE.GetValue('GP_REFINTERNE'));
             TOBAffaire2.PutValue('AFF_AFFAIREHT', 'X');

             Result := TOBAffaire2.InsertDB(Nil);

             // maj lien piece/affaire pour la premi�re pi�ce
             Req := 'UPDATE AFFPIECES SET AFP_SSAFFAIRE ='+'"'+ Codessaff +'"'+' WHERE AFP_AFFAIREREF='+'"'+CodeAffaire+'"';
             ExecuteSQL(Req);

             // En cr�ation d'avenant, on met � jour le code sous-affaire
             // avec le nouveau code affaire cr��
             if (codeavenant <> '00') then
             begin
                codeavenant := codessaff;
             end;
           end;

        end;

        if (Action = taCreat) then
        begin
          // cr�ation sous-affaire pour nouvelle pi�ce
          if (CodeAvenant = '00') then
          begin
             // lecture compteur sous-affaire
             NumAff := (GetParamsoc('SO_AFFCOMPTEUR'))+1;
             SetParamSoc('SO_AFFCOMPTEUR',NumAff) ;
             Codessaff := Format ('%.14d',[NumAff]);
             Codessaff := 'Z'+Codessaff+'00';
          end
          else
          begin
             Codessaff := Copy(CodeAvenant,2,14);
             Avenant := '01';
             Part0 := 'Z'+Codessaff+Avenant;
             while (existeaffaire (Part0,'') = true) Do
             begin
                  i := StrToInt (Avenant);
                  Inc(i);
                  Avenant := Format ('%.2d',[i]);
                  Part0 := 'Z'+Codessaff+Avenant;
             end;
             Codessaff := Part0;
          end;

          CodeAffaireDecoupe(Codessaff, Part0, Part1, Part2, Part3,Avenant,taConsult,False);
          TOBAffaire2.PutValue('AFF_AFFAIRE', Codessaff);
          TOBAffaire2.PutValue('AFF_AFFAIRE0', 'Z');
          TOBAffaire2.PutValue('AFF_AFFAIRE1', Part1);
          TOBAffaire2.PutValue('AFF_AFFAIRE2', Part2);
          TOBAffaire2.PutValue('AFF_AFFAIRE3', Part3);
          TOBAffaire2.PutValue('AFF_AVENANT', Avenant);
          TOBAffaire2.PutValue('AFF_REFERENCE', '-');
          TOBAffaire2.PutValue('AFF_AFFAIREREF', CodeAffaire);
          TOBAffaire2.PutValue('AFF_STATUTAFFAIRE', '');
          TOBAffaire2.PutValue('AFF_TIERS', TOBPIECE.GetValue('GP_TIERS'));
          TOBAffaire2.PutValue('AFF_ETATAFFAIRE', 'ENC');
          TOBAffaire2.PutValue('AFF_LIBELLE', TOBPIECE.GetValue('GP_REFINTERNE'));
          TOBAffaire2.PutValue('AFF_AFFAIREHT', 'X');

          Result := TOBAffaire2.InsertDB(Nil);
        end;

        // maj lien piece/affaire
        NumNouv := EncodeRefPiece(TOBPIECE);
        NumPiece := IntToStr(TOBPIECE.GetValue('GP_NUMERO'));
        if (Action = taCreat) then
        begin
           Req := 'INSERT INTO AFFPIECES '+
                  '(AFP_REFPIECE,AFP_AFFAIREREF,AFP_SSAFFAIRE,AFP_NATUREPIECEG,AFP_SOUCHE,AFP_NUMPIECE) '+
                  ' VALUES '+
                  '("'+NumNouv+'","'+CodeAffaire+'","'+Codessaff+'","'+TOBPIECE.GetValue('GP_NATUREPIECEG')+'","'+TOBPIECE.GetValue('GP_SOUCHE')+'",'+ NumPiece +')';
           ExecuteSQL(Req);
        end
        else
        begin
           // relecture sous-affaire
           Req := 'SELECT AFP_SSAFFAIRE FROM AFFPIECES WHERE AFP_REFPIECE='+'"'+NumNouv+'"';
           Q := OpenSQL(Req, True);
           Codessaff:=Q.FindField('AFP_SSAFFAIRE').AsString ;
           Ferme(Q);
           // maj code affaire ref�rence dans sous-affaire
           Req := 'UPDATE AFFAIRE SET AFF_AFFAIREREF ='+'"'+ CodeAffaire +'"'+' WHERE AFF_AFFAIRE ='+'"'+Codessaff+'"';
           ExecuteSQL(Req);
           // maj code affaire ref�rence dans lien sous-affaire/piece
           Req := 'UPDATE AFFPIECES SET AFP_AFFAIREREF ='+'"'+ CodeAffaire +'"'+' WHERE AFP_REFPIECE='+'"'+NumNouv+'"';
           ExecuteSQL(Req);
        end;

        // suppression des TOB Affaire
        TOBAffaire.free;
        TOBAffaire := Nil;
        TOBAffaire2.free;
        TOBAffaire2 := Nil;
     end;
END;

end.
