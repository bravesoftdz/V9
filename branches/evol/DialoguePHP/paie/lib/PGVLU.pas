{***********UNITE*************************************************
Auteur  ...... : PAIE - MF
Cr�� le ...... : 12/09/2002
Modifi� le ... : 20/01/2004
Description .. : Edition de la VLU
Suite ........ : concerne organisme Assedic, ducs dossier, paiement 
Suite ........ : group�
Mots clefs ... : PAIE, PGDUCS
*****************************************************************}
{
 PT1 : 23/02/2004 : V_5.0 MF FQ 10648  : mise en place dans les �tats
                          cha�n�es des �ditions  de la DUCS
 PT2 : MF 25/07/2005 : V_6.04 FQ  12445 : correction en t�te VLU caisse
                     destinataire
 PT3 : 30/03/2007 : V_702 MF : Modification : l'�dition de la VLU est r�alis�e
                              � partir de l'�dition des DUCS (menu 42354), de
                              l'impression VLU (menu 42303), des �ditions cha�n�es
                              et du process server
}
unit PGVLU;

interface
uses
    Classes,Comctrls, HCtrls,HEnt1 ,
    SysUtils, // PT3  pour d�claration DateToStr
    P5def,    // PT3  pour d�claration CreeJnalEvt
{$IFDEF EAGLCLIENT}
      UtileAGL;
//unused      MaineAgl;
{$ELSE}
      EdtREtat;
{$ENDIF}      

    Procedure EditVLU(Debper,FinPer : TDateTime; Organisme : String;Pages : TPageControl; Chaine : boolean; Apercu : boolean; var StSQL : string); // PT1 PT3

implementation

Procedure EditVLU(Debper,FinPer : TDateTime; Organisme : String;Pages : TPageControl; Chaine : boolean; Apercu : boolean; var StSQL : string);  // PT1 PT3
var
//PT3   StSQL                         : string; // est pass� en param�tre variable
   Trace, TraceE                      : TStringList; //PT3 pour maj jnal des �v�nements

begin
// d PT3
  // maj jnal des �v�nements
  Trace := TStringList.Create;
  TraceE := TStringList.Create;
  Trace.Add ('DUCS : Traitement d''impression des VLU pour la p�riode du '+ DateToStr(DebPer) + ' au '+ DateToStr(FinPer));
// f PT3

   StSQL := 'SELECT POG_ETABLISSEMENT,'+
            'POG_CAISSEDESTIN,'+ // PT2 FQ 12445
            'ET_LIBELLE,ET_SIRET,ET_ADRESSE1,ET_ADRESSE2,ET_ADRESSE3,'+
            'ET_CODEPOSTAL,ET_VILLE,ET_APE,ET_TELEPHONE,ET_FAX,'+
            'POG_ORGANISME,POG_NUMINTERNE,POG_LIBELLE,'+
            'POG_ADRESSE1,POG_ADRESSE2,POG_ADRESSE3,POG_CODEPOSTAL,'+
            'POG_VILLE,'+
            'PDU_ETABLISSEMENT,PDU_ORGANISME,PDU_ABREGEPERIODE,'+
            'PDU_DATEDEBUT, PDU_DATEFIN '+
            'FROM ORGANISMEPAIE '+
            'LEFT JOIN DUCSENTETE ON POG_ORGANISME=PDU_ORGANISME '+
            'AND POG_ETABLISSEMENT = PDU_ETABLISSEMENT '+ //@@
            'LEFT JOIN ETABLISS on POG_ETABLISSEMENT = ET_ETABLISSEMENT '+
            'WHERE POG_ORGANISME ="002" AND POG_DUCSDOSSIER="X" AND '+
            'POG_PAIEGROUPE="X" AND PDU_DATEDEBUT="'+UsDateTime(Debper)+'"'+
            ' AND PDU_DATEFIN="'+USDAteTime(FinPer)+'" '+
            'ORDER BY POG_CAISSEDESTIN DESC, PDU_ETABLISSEMENT'; // PT2 FQ 12445
{d PT3   if (Chaine = True)  then
     begin
      LanceEtat('E','PDU','PVU',Apercu,False,False,Pages,StSQL,'',False);
      V_PGI.NoPrintDialog := True; // pas d'affichage de la fen�tre d'impression
     end
   else}
   if (Chaine <> True)  then
   // si Etat cha�n� ou Impression VLU (menu 42303)
     LanceEtat('E','PDU','PVU',Apercu,False,False,Pages,StSQL,'',False);

  // maj jnal des �v�nements
   Trace.Add ('Fin du traitement d''impression des VLU ');
   CreeJnalEvt('001', '022', 'OK', nil, nil, Trace, TraceE);

   Trace.Free;
   TraceE.Free;
// f PT3
end;

end.
