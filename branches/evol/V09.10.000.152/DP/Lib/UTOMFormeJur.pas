{***********UNITE*************************************************
Auteur  ...... : BM
Cr�� le ...... : 05/11/2002
Modifi� le ... :   /  /
Description .. : Source TOM_JUFORMEJUR
Mots clefs ... : TOM;JUFORMEJUR
*****************************************************************}

Unit UTOMFormeJur;
//////////////////////////////////////////////////////////////////
Interface
//////////////////////////////////////////////////////////////////
Uses
{$IFDEF EAGLCLIENT}
     UTob, eFichList,
{$ELSE}
     db, FichList,
{$ENDIF}
     Classes, UTOMTypeParam, HTB97, HmsgBox, controls, UFNewForme,
     hctrls, HEnt1;

//////////////////////////////////////////////////////////////////
Type
   TOM_JUFORMEJUR  = Class (TOM_TYPEPARAM)
         procedure OnArgument ( sParams_p : String )   ; override;
         procedure OnNewRecord                ; override ;
         procedure OnLoadRecord; override;        
         procedure OnUpdateRecord             ; override ;
         procedure OnAfterUpdateRecord        ; override ;
         procedure OnDeleteRecord        ; override ;

         procedure OnClick_BNewForme(Sender : TObject);
         procedure OnClick_BDuplique(Sender : TObject); override;
      private
         bNew_c : boolean;
         sCode_c : string;
end ;

//////////////////////////////////////////////////////////////////
Implementation
//////////////////////////////////////////////////////////////////
{***********A.G.L.Priv�.*****************************************
Auteur  ...... : B. MERIAUX
Cr�� le ...... : 22/07/2003
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
procedure TOM_JUFORMEJUR.OnArgument ( sParams_p : String ) ;
begin
   Inherited ;
   sTypeElement_f := 'de forme juridique';
   if GetControl('BNEWFORME') <> nil then
      TToolbarButton97(GetControl('BNEWFORME')).OnClick := OnClick_BNewForme;
end;

{*****************************************************************
Auteur ....... : BM
Date ......... : 05/10/02
Proc�dure .... : OnNewRecord
Description .. : Force le champ PREDEFINI avec 'STD' pour que les
                 donn�es ne soient pas �cras�es au rechargement de
                 socref
Param�tres ... :
*****************************************************************}

procedure TOM_JUFORMEJUR.OnNewRecord;
begin
   Inherited ;
   SetField( 'JFJ_FORMEGEN', 'DIV');
   SetField( 'JFJ_CONTROLE', '-');
   SetField( 'JFJ_LIENS', '-');
   SetControlEnabled('BNEWFORME', false);
//   sCode_c := '';
   bNew_c := true;
end ;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : BM
Cr�� le ...... : 06/07/2005
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOM_JUFORMEJUR.OnLoadRecord;
begin
   Inherited ;
   if V_PGI.SAV then
      SetControlEnabled('BNEWFORME', true)   
   else
      SetControlEnabled('BNEWFORME', not bCEG_c and not bNew_c);
end ;

{*****************************************************************
Auteur ....... : BM
Date ......... : 05/10/02
Proc�dure .... : OnUpdateRecord
Description .. : En mode cr�ation, ajout d'un caract�re sp�cial
                 au code (forc�ment STD)
Param�tres ... :
*****************************************************************}

procedure TOM_JUFORMEJUR.OnUpdateRecord ;
begin
   Inherited ;
   if DS.State = dsInsert then
   begin
      SetField( 'JFJ_CODEINT', IncCompteur( 'JUFORMEJUR', 'JFJ_CODEINT' ) );
      SetField( 'JFJ_FORMEABREGE2', GetField ( 'JFJ_FORMEABREGE' ) );
   end;
end ;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : BM
Cr�� le ...... : 06/07/2005
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOM_JUFORMEJUR.OnAfterUpdateRecord ;
begin
   Inherited ;
   if bNew_c then
   begin
      if PGIAsk('Voulez-vous cr�er les fonctions associ�es' + #13#10 +
                '� cette nouvelle forme juridique?', Ecran.Caption) = mrYes then
         NewForme(GetField('JFJ_FORME'), GetField('JFJ_FORMEABREGE'), 'STE', sCode_c);
      SetControlEnabled('BNEWFORME', not bCEG_c);
   end;

   bNew_c := false;
   sCode_c := '';
end ;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : BM
Cr�� le ...... : 06/07/2005
Modifi� le ... :   /  /
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOM_JUFORMEJUR.OnDeleteRecord ;
begin
   Inherited ;
   DelForme(GetField('JFJ_FORME'), 'STE');
end ;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : BM
Cr�� le ...... : 05/07/2005
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... :
*****************************************************************}
procedure TOM_JUFORMEJUR.OnClick_BNewForme(Sender : TObject);
begin
   inherited;
   NewForme(GetField('JFJ_FORME'), GetField('JFJ_FORMEABREGE'), 'STE', '');
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : B.MERIAUX
Cr�� le ...... : 11/07/2005
Modifi� le ... : 11/07/2005
Description .. : 
Mots clefs ... : 
*****************************************************************}
procedure TOM_JUFORMEJUR.OnClick_BDuplique(Sender : TObject);
begin
   sCode_c := GetField('JFJ_FORME');
   inherited;
end;
//////////////////////////////////////////////////////////////////

Initialization
   registerclasses ( [ TOM_JUFORMEJUR ] ) ;
end.
