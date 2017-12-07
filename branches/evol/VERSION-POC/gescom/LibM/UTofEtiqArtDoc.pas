unit UTofEtiqArtDoc;

interface

uses  StdCtrls,Controls,Classes,forms,sysutils,ComCtrls,
      HCtrls,HEnt1,HMsgBox,UTOF, HDimension,UTOM,AGLInit,
      Utob,HDB,Messages,HStatus,CalcOleGescom,
{$IFDEF EAGLCLIENT}
      UtileAGL,eMul,MaineAGL,
{$ELSE}
      dbTables,Fiche, mul, db, DBGrids, EdtDoc, QRS1, Fe_Main, EdtEtat,
  {$IFNDEF V530}
      EdtREtat,
  {$ENDIF}
{$ENDIF}
      M3VM , M3FP,Hqry, EntGC, UtilGC,AGLInitGC,
      FactComm, FactUtil;
Type
     TOF_EtiqArtDoc = Class (TOF)
        procedure OnClose ; override ;
        procedure LanceEdition (NomFiche : String );
        //procedure EditeLesEtiq (TobPiece : TOB);
        procedure OnArgument (Argument : String ) ; override ;
     end;

     var Critere : string;

procedure AGLEtiqArtDoc(parms:array of variant; nb: integer ) ;
procedure AGLParamEtiqArtDim (parms:array of variant; nb: integer );
const
// libell�s des messages
TexteMessage: array[1..2] of string 	= (
          {1}  'Aucun �l�ment s�lectionn�'
          {2} ,'Changement d''imprim�.' + #13 + 'Les documents suivants s''�diteront d''apr�s le mod�le '
              );

implementation

procedure TOF_EtiqArtDoc.OnArgument (Argument : String ) ;
var stArgument : string;
begin
inherited ;
stArgument := Argument;
Critere:=uppercase(Trim(ReadTokenSt(stArgument))) ;
if (critere = 'CF') or (critere = 'FCF') then Ecran.Caption:=TraduireMemoire('Etiquettes sur commandes');
if critere = 'BLF' then Ecran.Caption:=TraduireMemoire('Etiquettes sur r�ceptions');
if critere = 'TRE' then Ecran.Caption:=TraduireMemoire('Etiquettes sur transferts');
if critere = 'FFO' then Ecran.Caption:=TraduireMemoire('Etiquettes sur retours de vente');
if critere = 'ALF' then Ecran.Caption:=TraduireMemoire('Etiquettes sur annonces de livraison');
updatecaption(Ecran);
end;

///////////////////////////////////////////////////////////////////////////////////
procedure TOF_EtiqArtDoc.LanceEdition (NomFiche : String ) ;
var F : TFMul ;
{$IFDEF EAGLCLIENT}
    L : THGrid;
{$ELSE}
    L : THDBGrid;
{$ENDIF}
    TobQteFact : TOB ;
    iInd,AncienNbEx,NBEXEMPLAIRE,i_ind1,i_ind2 : integer ;
    Where,stSelect,stFrom,stWhere,stGroupBy,stOrderBy,stInsert : string ;
    TNatPiece,TSouche,TNumero,TIndiceg,numero,RegimePrix,CodeEtat,LibEtat : string ;
    TSql : TQuery ;
    BApercu : boolean;
begin
F:=TFMul(Ecran);
L := F.FListe;
if(L.NbSelected=0)and(not L.AllSelected) then
    begin
{$IFDEF EAGLCLIENT}
{$ELSE}
    if VAlerte<>Nil then VAlerte.Visible:=FALSE ;
{$ENDIF}
    HShowMessage('0;'+F.Caption+';'+TexteMessage[1]+';W;O;O;O;','','') ;
    exit;
    end;
// Suppression des enregistrements
ExecuteSQL('DELETE FROM GCTMPETQ WHERE GZD_UTILISATEUR = "'+V_PGI.USer+'"');
// R�cup�ration des crit�res
Where := RecupWhereCritere(F.Pages) ;
// R�cup�ration du modele d'�tat choisi
CodeEtat := GetControlText ('FETAT');
LibEtat := RechDom('TTMODELETIQART',CodeEtat,FALSE);

// Cr�ation des SQL
stSelect:='SELECT ABS(GL_QTEFACT) GL_QTEFACT';
stFrom:=' FROM PIECE left join LIGNE on GP_NATUREPIECEG=GL_NATUREPIECEG and'+
   ' GP_NUMERO=GL_NUMERO and GP_SOUCHE=GL_SOUCHE and GP_INDICEG=GL_INDICEG  ';
stGroupBy:=' GROUP BY GL_QTEFACT';
stOrderBy:=' ORDER BY ABS(GL_QTEFACT)';

if NomFiche='GCETIARTDOC_MODE' then
// Si la fiche concerne "�tiquette article sur document"
   begin
     TNatPiece:='GP_NATUREPIECEG';
     TSouche:='GP_SOUCHE';
     TNumero:='GP_NUMERO';
     TIndiceg:='GP_INDICEG';
   end
else
// Sinon la fiche concerne "etiquette article sur retour de vente"
   begin
     TNatPiece:='GL_NATUREPIECEG';
     TSouche:='GL_SOUCHE';
     TNumero:='GL_NUMERO';
     TIndiceg:='GL_INDICEG';
   end;
// R�cup�ration des lignes o� GL_ARTICLE n'est pas vide
if Where<>'' then Where:=Where+' AND ' ;
Where :=Where + 'GL_ARTICLE <> ""';
RegimePrix := 'TTC';
// Si on n'a pas tout s�lectionn�, j'ajoute � la clause where les num�ro d'�tiquettes s�lectionn�
if not L.AllSelected then
begin
       InitMove(L.NbSelected,'');
       for iInd:=0 to L.NbSelected-1 do
          BEGIN
               L.GotoLeBOOKMARK(iInd);
               numero:=    F.Q.FindField(TNumero).AsString ;
               if (iInd=0) and (Where<>'') then Where:=Where+' AND ('
               else if Where<>'' then Where:=Where+' OR';
               Where:=Where+' GL_NUMERO="'+numero+'"';
               MoveCur(False);
          END ;
     if Where<>'' then Where:=Where+' )';
     FiniMove;
end;
VH_GC.TOBEdt.ClearDetail ;
initvariable;
// Cr�ation de la Tob des qteFact
TobQteFact := TOB.Create ('', Nil, -1) ;
if EtatMonarchFactorise(LibEtat) then
   begin
   stInsert := 'Insert into GCTMPETQ (GZD_UTILISATEUR, GZD_ARTICLE, GZD_DEPOT,'+
       ' GZD_CODEARTICLE, GZD_REGIMEPRIX, GZD_NUMERO,GZD_SOUCHE, GZD_INDICEG, GZD_NUMLIGNE,GZD_NBETIQDIM,GZD_CODEARTICLEGEN) ' +
       'Select "' + V_PGI.User + '" as GZD_UTILISATEUR, ' +
       'GL_ARTICLE as GZD_ARTICLE, ' +
       'GL_DEPOT as GZD_DEPOT, ' +
       'GL_CODEARTICLE as GZD_CODEARTICLE, ' +
       '"' + RegimePrix + '" as GZD_REGIMEPRIX, '+
       'GL_NUMERO as GZD_NUMERO,'+
       'GL_SOUCHE as GZD_SOUCHE,'+
       'GL_INDICEG as GZD_INDICEG,'+
       'GL_NUMLIGNE as GZD_NUMLIGNE, '+
       'GL_QTEFACT as GZD_NBETIQDIM, '+
       'GA_ARTICLE as GZD_CODEARTICLEGEN '+
       stFrom+'left join ARTICLE  on GA_STATUTART<>"DIM" and GA_CODEARTICLE=GL_CODEARTICLE '+Where;
   ExecuteSQL(stInsert);
   end
else
   begin
   // Ce SQL me permet de r�cup�rer les diff�rentes quantit� des articles, ordonn�e par ordre croissant
   TSql := OpenSQL(stSelect + stFrom + Where + stGroupBy + stOrderBy, True) ;
   if not TSql.EOF then TobQteFact.LoadDetailDB('', '', '', TSql, FAlse)
   else
      begin
      TobQteFact.free;
      TobQteFact := nil;
      end;
   Ferme (TSql) ;
   if TobQteFact<>nil then
      begin
      // Ces quantit�s r�cup�r� vont me permettre d'ins�rer les enregistrements par paquet
      // c'est � dire que j'ins�re tous les enregistrements qui ont une quantit� sup�rieur
      // ou �gale � la quantit� courante.
      for i_ind1:=0 to TobQteFact.Detail.Count-1 do
         begin
              if i_ind1=0 then NBEXEMPLAIRE := TobQteFact.Detail[i_ind1].GetValue('GL_QTEFACT')
              else
                 begin
                      AncienNbEx:=TobQteFact.Detail[i_ind1-1].GetValue('GL_QTEFACT');
                      NBEXEMPLAIRE := TobQteFact.Detail[i_ind1].GetValue('GL_QTEFACT')- AncienNbEx;;
                      if Where<>'' then Where:=Where+' AND ' ;
                      Where :=Where + 'ABS(GL_QTEFACT) <> "'+IntToStr(AncienNbEx)+'"';
                 end;
              for i_ind2:=0 to NBEXEMPLAIRE-1 do
                 begin
                      stInsert := 'Insert into GCTMPETQ (GZD_UTILISATEUR, GZD_ARTICLE, GZD_DEPOT,'+
                               ' GZD_CODEARTICLE, GZD_REGIMEPRIX, GZD_NUMERO,GZD_SOUCHE, GZD_INDICEG, GZD_NUMLIGNE,GZD_CODEARTICLEGEN) ' +
                               'Select "' + V_PGI.User + '" as GZD_UTILISATEUR, ' +
                               'GL_ARTICLE as GZD_ARTICLE, ' +
                               'GL_DEPOT as GZD_DEPOT, ' +
                               'GL_CODEARTICLE as GZD_CODEARTICLE, ' +
                               '"' + RegimePrix + '" as GZD_REGIMEPRIX, '+
                               'GL_NUMERO as GZD_NUMERO,'+
                               'GL_SOUCHE as GZD_SOUCHE,'+
                               'GL_INDICEG as GZD_INDICEG,'+
                               'GL_NUMLIGNE as GZD_NUMLIGNE, '+
                               'GA_ARTICLE as GZD_CODEARTICLEGEN '+stFrom+'left join ARTICLE  on GA_STATUTART<>"DIM" and GA_CODEARTICLE=GL_CODEARTICLE ' + Where;
                      ExecuteSQL(stInsert);
                 end;
         end;
      end;
   end;
// Ceci permet de d�s�lectionner le bouton AllSelected et les enregistrements selectionn�s
if F.FListe.AllSelected then F.FListe.AllSelected:=False else F.FListe.ClearSelected;
F.bSelectAll.Down := False ;
if TobQteFact<>nil then TobQteFact.free;
// Suppression des enregistrements et des TOB
ExecuteSQL('DELETE FROM GCTMPETQ WHERE GZD_UTILISATEUR = "'+V_PGI.USer+'" and GZD_COMPTEUR=0');
// R�cup�ration de la coche "apercu avant impression"
BApercu := TCheckBox(TForm(Ecran).FindComponent('FApercu')).Checked;

// Clause where afin d'�tre sure de r�cup�rer ses propres enregistrements
stWhere:= stWhere+' AND GZD_UTILISATEUR="'+V_PGI.USer+'"' ;
// Lancement de l'�tat
EditMonarchSiEtat (LibEtat);
LanceEtat('E','GED',CodeEtat,BApercu,False,False,Nil,stWhere,'',False);
EditMonarch ('');
// Suppression des enregistrements et des TOB
ExecuteSQL('DELETE FROM GCTMPETQ WHERE GZD_UTILISATEUR = "'+V_PGI.USer+'"');
end;

procedure TOF_EtiqArtDoc.OnClose ;
begin
Inherited;
ExecuteSQL('DELETE FROM GCTMPETQ WHERE GZD_UTILISATEUR = "'+V_PGI.USer+'"');
VH_GC.TOBEdt.ClearDetail ;
initvariable;
end;


/////////////// Procedure appell� par le bouton Validation //////////////
// On fait passer en param�tre le nom de la fiche car il y a deux fiches
// ratach� � la m�me TOF ( �tiquette article sur document et �tiquette
// article sur retour de vente )
procedure AGLEtiqArtDoc(parms:array of variant; nb: integer ) ;
var  F : TForm ;
     NomFiche : string;
     MaTOF  : TOF;
begin
F:=TForm(Longint(Parms[0])) ;
NomFiche := string(Parms[1]);
if (F is TFmul) then MaTOF:=TFMul(F).LaTOF
else exit;
if (MaTOF is TOF_EtiqArtDoc) then TOF_EtiqArtDoc(MaTOF).LanceEdition(NomFiche)
else exit;
end;

// Cette proc�dure permet d'ouvrir l'�tat pour le modifier
// lorsqu'on appui sur l'�querre � cot� du COMBO FETAT
// On fait passer en param�tre le modele de l'�tat
procedure AGLParamEtiqArtDim(parms:array of variant; nb: integer ) ;
var CodeEtat, LibEtat : string;
begin
CodeEtat := string(Parms[1]);
LibEtat := RechDom('TTMODELETIQART',CodeEtat,FALSE);
{$IFNDEF EAGLCLIENT}
EditMonarchSiEtat (LibEtat);
EditEtat('E','GED',CodeEtat,TRUE,nil,'','') ;
EditMonarch ('');
AvertirTable ('TTMODELETIQART');
{$ENDIF}
end ;

Initialization
registerclasses([TOF_EtiqArtDoc]);
RegisterAglProc('EtiqArtDoc',TRUE,1,AGLEtiqArtDoc);
RegisterAglProc('ParamEtiqArtDim',TRUE,1,AGLParamEtiqArtDim);
end.
