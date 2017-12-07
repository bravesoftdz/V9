unit MSXML2_TLB;

// ************************************************************************ //
// AVERTISSEMENT                                                                 
// -------                                                                    
// Les types d�clar�s dans ce fichier ont �t� g�n�r�s � partir de donn�es lues 
// depuis la biblioth�que de types. Si cette derni�re (via une autre biblioth�que de types 
// s'y r�f�rant) est explicitement ou indirectement r�-import�e, ou la commande "Rafra�chir"  
// de l'�diteur de biblioth�que de types est activ�e lors de la modification de la biblioth�que 
// de types, le contenu de ce fichier sera r�g�n�r� et toutes les modifications      
// manuellement apport�es seront perdues.                                     
// ************************************************************************ //

// PASTLWTR : 1.2
// Fichier g�n�r� le 14/05/2014 17:16:41 depuis la biblioth�que de types ci-dessous.

// ************************************************************************  //
// Bibl. types : c:\Windows\system32\msxml4.dll (1)
// LIBID: {F5078F18-C551-11D3-89B9-0000F81FE221}
// LCID: 0
// Fichier d'aide : 
// Cha�ne d'aide : Microsoft XML, v4.0
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
// Erreurs :
//   Remarque : param�tre 'type' dans IXMLDOMNode.nodeType chang� en 'type_'
//   Conseil : Membre 'implementation' de 'IXMLDOMDocument' modifi� en 'implementation_'
//   Remarque : param�tre 'type' dans IXMLDOMDocument.createNode chang� en 'type_'
//   Remarque : param�tre 'var' dans IXMLDOMSchemaCollection.add chang� en 'var_'
//   Remarque : le symbole 'type' a �t� renomm� en 'type_'
//   Remarque : param�tre 'type' dans ISchemaElement.type chang� en 'type_'
//   Remarque : le symbole 'type' a �t� renomm� en 'type_'
//   Remarque : param�tre 'type' dans ISchemaAttribute.type chang� en 'type_'
//   Remarque : le symbole 'type' a �t� renomm� en 'type_'
//   Remarque : le symbole 'type' a �t� renomm� en 'type_'
// ************************************************************************ //
// *************************************************************************//
// REMARQUE :                                                                      
// Les �l�ments gard�s par $IFDEF_LIVE_SERVER_AT_DESIGN_TIME sont  utilis�s 
// par des propri�t�s qui renvoient des objets pouvant n�cessiter d'�tre  
// explicitement cr��s par un appel de fonction avant tout acc�s via la   
// propri�t�. Ces �l�ments ont �t� d�sactiv�s afin de pr�venir une utilisation  
// accidentelle depuis l'inspecteur d'objets. Vous pouvez les activer en d�finissant  
// LIVE_SERVER_AT_DESIGN_TIME ou en les retirant s�lectivement des blocs 
//  $IFDEF. Cependant, ces �l�ments doivent toujours �tre cr��s par programmation
//  via une m�thode de la CoClasse appropri�e avant d'�tre utilis�s.                          
{$TYPEDADDRESS OFF} // L'unit� doit �tre compil�e sans pointeur � type contr�l�. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS d�clar�s dans la biblioth�que de types. Pr�fixes utilis�s :    
//   Biblioth�ques de types : LIBID_xxxx                                      
//   CoClasses              : CLASS_xxxx                                      
//   DISPInterfaces         : DIID_xxxx                                       
//   Non-DISP interfaces    : IID_xxxx                                        
// *********************************************************************//
const
  // Versions majeure et mineure de la biblioth�que de types
  MSXML2MajorVersion = 4;
  MSXML2MinorVersion = 0;

  LIBID_MSXML2: TGUID = '{F5078F18-C551-11D3-89B9-0000F81FE221}';

  IID_IXMLDOMImplementation: TGUID = '{2933BF8F-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMNode: TGUID = '{2933BF80-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMNodeList: TGUID = '{2933BF82-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMNamedNodeMap: TGUID = '{2933BF83-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMDocument: TGUID = '{2933BF81-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMDocumentType: TGUID = '{2933BF8B-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMElement: TGUID = '{2933BF86-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMAttribute: TGUID = '{2933BF85-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMDocumentFragment: TGUID = '{3EFAA413-272F-11D2-836F-0000F87A7782}';
  IID_IXMLDOMCharacterData: TGUID = '{2933BF84-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMText: TGUID = '{2933BF87-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMComment: TGUID = '{2933BF88-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMCDATASection: TGUID = '{2933BF8A-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMProcessingInstruction: TGUID = '{2933BF89-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMEntityReference: TGUID = '{2933BF8E-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMParseError: TGUID = '{3EFAA426-272F-11D2-836F-0000F87A7782}';
  IID_IXMLDOMDocument2: TGUID = '{2933BF95-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMSchemaCollection: TGUID = '{373984C8-B845-449B-91E7-45AC83036ADE}';
  IID_IXMLDOMNotation: TGUID = '{2933BF8C-7B36-11D2-B20E-00C04F983E60}';
  IID_IXMLDOMEntity: TGUID = '{2933BF8D-7B36-11D2-B20E-00C04F983E60}';
  IID_IXTLRuntime: TGUID = '{3EFAA425-272F-11D2-836F-0000F87A7782}';
  IID_IXSLTemplate: TGUID = '{2933BF93-7B36-11D2-B20E-00C04F983E60}';
  IID_IXSLProcessor: TGUID = '{2933BF92-7B36-11D2-B20E-00C04F983E60}';
  IID_ISAXXMLReader: TGUID = '{A4F96ED0-F829-476E-81C0-CDC7BD2A0802}';
  IID_ISAXEntityResolver: TGUID = '{99BCA7BD-E8C4-4D5F-A0CF-6D907901FF07}';
  IID_ISAXContentHandler: TGUID = '{1545CDFA-9E4E-4497-A8A4-2BF7D0112C44}';
  IID_ISAXLocator: TGUID = '{9B7E472A-0DE4-4640-BFF3-84D38A051C31}';
  IID_ISAXAttributes: TGUID = '{F078ABE1-45D2-4832-91EA-4466CE2F25C9}';
  IID_ISAXDTDHandler: TGUID = '{E15C1BAF-AFB3-4D60-8C36-19A8C45DEFED}';
  IID_ISAXErrorHandler: TGUID = '{A60511C4-CCF5-479E-98A3-DC8DC545B7D0}';
  IID_ISAXXMLFilter: TGUID = '{70409222-CA09-4475-ACB8-40312FE8D145}';
  IID_ISAXLexicalHandler: TGUID = '{7F85D5F5-47A8-4497-BDA5-84BA04819EA6}';
  IID_ISAXDeclHandler: TGUID = '{862629AC-771A-47B2-8337-4E6843C1BE90}';
  IID_IVBSAXXMLReader: TGUID = '{8C033CAA-6CD6-4F73-B728-4531AF74945F}';
  IID_IVBSAXEntityResolver: TGUID = '{0C05D096-F45B-4ACA-AD1A-AA0BC25518DC}';
  IID_IVBSAXContentHandler: TGUID = '{2ED7290A-4DD5-4B46-BB26-4E4155E77FAA}';
  IID_IVBSAXLocator: TGUID = '{796E7AC5-5AA2-4EFF-ACAD-3FAAF01A3288}';
  IID_IVBSAXAttributes: TGUID = '{10DC0586-132B-4CAC-8BB3-DB00AC8B7EE0}';
  IID_IVBSAXDTDHandler: TGUID = '{24FB3297-302D-4620-BA39-3A732D850558}';
  IID_IVBSAXErrorHandler: TGUID = '{D963D3FE-173C-4862-9095-B92F66995F52}';
  IID_IVBSAXXMLFilter: TGUID = '{1299EB1B-5B88-433E-82DE-82CA75AD4E04}';
  IID_IVBSAXLexicalHandler: TGUID = '{032AAC35-8C0E-4D9D-979F-E3B702935576}';
  IID_IVBSAXDeclHandler: TGUID = '{E8917260-7579-4BE1-B5DD-7AFBFA6F077B}';
  IID_IMXWriter: TGUID = '{4D7FF4BA-1565-4EA8-94E1-6E724A46F98D}';
  IID_IMXAttributes: TGUID = '{F10D27CC-3EC0-415C-8ED8-77AB1C5E7262}';
  IID_IMXReaderControl: TGUID = '{808F4E35-8D5A-4FBE-8466-33A41279ED30}';
  IID_IMXSchemaDeclHandler: TGUID = '{FA4BB38C-FAF9-4CCA-9302-D1DD0FE520DB}';
  IID_ISchemaItem: TGUID = '{50EA08B3-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_ISchemaParticle: TGUID = '{50EA08B5-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_ISchemaElement: TGUID = '{50EA08B7-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_ISchema: TGUID = '{50EA08B4-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_ISchemaItemCollection: TGUID = '{50EA08B2-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_ISchemaStringCollection: TGUID = '{50EA08B1-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_ISchemaType: TGUID = '{50EA08B8-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_ISchemaComplexType: TGUID = '{50EA08B9-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_ISchemaAny: TGUID = '{50EA08BC-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_ISchemaModelGroup: TGUID = '{50EA08BB-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_IXMLDOMSchemaCollection2: TGUID = '{50EA08B0-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_ISchemaAttribute: TGUID = '{50EA08B6-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_ISchemaAttributeGroup: TGUID = '{50EA08BA-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_ISchemaIdentityConstraint: TGUID = '{50EA08BD-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_ISchemaNotation: TGUID = '{50EA08BE-DD1B-4664-9A50-C2F40F4BD79A}';
  IID_IXMLElementCollection: TGUID = '{65725580-9B5D-11D0-9BFE-00C04FC99C8E}';
  IID_IXMLDocument: TGUID = '{F52E2B61-18A1-11D1-B105-00805F49916B}';
  IID_IXMLElement: TGUID = '{3F7F31AC-E15F-11D0-9C25-00C04FC99C8E}';
  IID_IXMLDocument2: TGUID = '{2B8DE2FE-8D2D-11D1-B2FC-00C04FD915A9}';
  IID_IXMLElement2: TGUID = '{2B8DE2FF-8D2D-11D1-B2FC-00C04FD915A9}';
  IID_IXMLAttribute: TGUID = '{D4D4A0FC-3B73-11D1-B2B4-00C04FB92596}';
  IID_IXMLError: TGUID = '{948C5AD3-C58D-11D0-9C0B-00C04FC99C8E}';
  IID_IXMLDOMSelection: TGUID = '{AA634FC7-5888-44A7-A257-3A47150D3A0E}';
  DIID_XMLDOMDocumentEvents: TGUID = '{3EFAA427-272F-11D2-836F-0000F87A7782}';
  IID_IDSOControl: TGUID = '{310AFA62-0575-11D2-9CA9-0060B0EC3D39}';
  IID_IXMLHTTPRequest: TGUID = '{ED8C108D-4349-11D2-91A4-00C04F7969E8}';
  IID_IServerXMLHTTPRequest: TGUID = '{2E9196BF-13BA-4DD4-91CA-6C571F281495}';
  IID_IServerXMLHTTPRequest2: TGUID = '{2E01311B-C322-4B0A-BD77-B90CFDC8DCE7}';
  IID_IMXNamespacePrefixes: TGUID = '{C90352F4-643C-4FBC-BB23-E996EB2D51FD}';
  IID_IVBMXNamespaceManager: TGUID = '{C90352F5-643C-4FBC-BB23-E996EB2D51FD}';
  IID_IMXNamespaceManager: TGUID = '{C90352F6-643C-4FBC-BB23-E996EB2D51FD}';
  CLASS_DOMDocument: TGUID = '{F6D90F11-9C73-11D3-B32E-00C04F990BB4}';
  CLASS_DOMDocument26: TGUID = '{F5078F1B-C551-11D3-89B9-0000F81FE221}';
  CLASS_DOMDocument30: TGUID = '{F5078F32-C551-11D3-89B9-0000F81FE221}';
  CLASS_DOMDocument40: TGUID = '{88D969C0-F192-11D4-A65F-0040963251E5}';
  CLASS_FreeThreadedDOMDocument: TGUID = '{F6D90F12-9C73-11D3-B32E-00C04F990BB4}';
  CLASS_FreeThreadedDOMDocument26: TGUID = '{F5078F1C-C551-11D3-89B9-0000F81FE221}';
  CLASS_FreeThreadedDOMDocument30: TGUID = '{F5078F33-C551-11D3-89B9-0000F81FE221}';
  CLASS_FreeThreadedDOMDocument40: TGUID = '{88D969C1-F192-11D4-A65F-0040963251E5}';
  CLASS_XMLSchemaCache: TGUID = '{373984C9-B845-449B-91E7-45AC83036ADE}';
  CLASS_XMLSchemaCache26: TGUID = '{F5078F1D-C551-11D3-89B9-0000F81FE221}';
  CLASS_XMLSchemaCache30: TGUID = '{F5078F34-C551-11D3-89B9-0000F81FE221}';
  CLASS_XMLSchemaCache40: TGUID = '{88D969C2-F192-11D4-A65F-0040963251E5}';
  CLASS_XSLTemplate: TGUID = '{2933BF94-7B36-11D2-B20E-00C04F983E60}';
  CLASS_XSLTemplate26: TGUID = '{F5078F21-C551-11D3-89B9-0000F81FE221}';
  CLASS_XSLTemplate30: TGUID = '{F5078F36-C551-11D3-89B9-0000F81FE221}';
  CLASS_XSLTemplate40: TGUID = '{88D969C3-F192-11D4-A65F-0040963251E5}';
  CLASS_DSOControl: TGUID = '{F6D90F14-9C73-11D3-B32E-00C04F990BB4}';
  CLASS_DSOControl26: TGUID = '{F5078F1F-C551-11D3-89B9-0000F81FE221}';
  CLASS_DSOControl30: TGUID = '{F5078F39-C551-11D3-89B9-0000F81FE221}';
  CLASS_DSOControl40: TGUID = '{88D969C4-F192-11D4-A65F-0040963251E5}';
  CLASS_XMLHTTP: TGUID = '{F6D90F16-9C73-11D3-B32E-00C04F990BB4}';
  CLASS_XMLHTTP26: TGUID = '{F5078F1E-C551-11D3-89B9-0000F81FE221}';
  CLASS_XMLHTTP30: TGUID = '{F5078F35-C551-11D3-89B9-0000F81FE221}';
  CLASS_XMLHTTP40: TGUID = '{88D969C5-F192-11D4-A65F-0040963251E5}';
  CLASS_ServerXMLHTTP: TGUID = '{AFBA6B42-5692-48EA-8141-DC517DCF0EF1}';
  CLASS_ServerXMLHTTP30: TGUID = '{AFB40FFD-B609-40A3-9828-F88BBE11E4E3}';
  CLASS_ServerXMLHTTP40: TGUID = '{88D969C6-F192-11D4-A65F-0040963251E5}';
  CLASS_SAXXMLReader: TGUID = '{079AA557-4A18-424A-8EEE-E39F0A8D41B9}';
  CLASS_SAXXMLReader30: TGUID = '{3124C396-FB13-4836-A6AD-1317F1713688}';
  CLASS_SAXXMLReader40: TGUID = '{7C6E29BC-8B8B-4C3D-859E-AF6CD158BE0F}';
  CLASS_MXXMLWriter: TGUID = '{FC220AD8-A72A-4EE8-926E-0B7AD152A020}';
  CLASS_MXXMLWriter30: TGUID = '{3D813DFE-6C91-4A4E-8F41-04346A841D9C}';
  CLASS_MXXMLWriter40: TGUID = '{88D969C8-F192-11D4-A65F-0040963251E5}';
  CLASS_MXHTMLWriter: TGUID = '{A4C23EC3-6B70-4466-9127-550077239978}';
  CLASS_MXHTMLWriter30: TGUID = '{853D1540-C1A7-4AA9-A226-4D3BD301146D}';
  CLASS_MXHTMLWriter40: TGUID = '{88D969C9-F192-11D4-A65F-0040963251E5}';
  CLASS_SAXAttributes: TGUID = '{4DD441AD-526D-4A77-9F1B-9841ED802FB0}';
  CLASS_SAXAttributes30: TGUID = '{3E784A01-F3AE-4DC0-9354-9526B9370EBA}';
  CLASS_SAXAttributes40: TGUID = '{88D969CA-F192-11D4-A65F-0040963251E5}';
  CLASS_MXNamespaceManager: TGUID = '{88D969D5-F192-11D4-A65F-0040963251E5}';
  CLASS_MXNamespaceManager40: TGUID = '{88D969D6-F192-11D4-A65F-0040963251E5}';
  CLASS_XMLDocument: TGUID = '{CFC399AF-D876-11D0-9C10-00C04FC99C8E}';

// *********************************************************************//
// D�claration d'�num�rations d�finies dans la biblioth�que de types    
// *********************************************************************//
// Constantes pour enum tagDOMNodeType
type
  tagDOMNodeType = TOleEnum;
const
  NODE_INVALID = $00000000;
  NODE_ELEMENT = $00000001;
  NODE_ATTRIBUTE = $00000002;
  NODE_TEXT = $00000003;
  NODE_CDATA_SECTION = $00000004;
  NODE_ENTITY_REFERENCE = $00000005;
  NODE_ENTITY = $00000006;
  NODE_PROCESSING_INSTRUCTION = $00000007;
  NODE_COMMENT = $00000008;
  NODE_DOCUMENT = $00000009;
  NODE_DOCUMENT_TYPE = $0000000A;
  NODE_DOCUMENT_FRAGMENT = $0000000B;
  NODE_NOTATION = $0000000C;

// Constantes pour enum _SOMITEMTYPE
type
  _SOMITEMTYPE = TOleEnum;
const
  SOMITEM_SCHEMA = $00001000;
  SOMITEM_ATTRIBUTE = $00001001;
  SOMITEM_ATTRIBUTEGROUP = $00001002;
  SOMITEM_NOTATION = $00001003;
  SOMITEM_IDENTITYCONSTRAINT = $00001100;
  SOMITEM_KEY = $00001101;
  SOMITEM_KEYREF = $00001102;
  SOMITEM_UNIQUE = $00001103;
  SOMITEM_ANYTYPE = $00002000;
  SOMITEM_DATATYPE = $00002100;
  SOMITEM_DATATYPE_ANYTYPE = $00002101;
  SOMITEM_DATATYPE_ANYURI = $00002102;
  SOMITEM_DATATYPE_BASE64BINARY = $00002103;
  SOMITEM_DATATYPE_BOOLEAN = $00002104;
  SOMITEM_DATATYPE_BYTE = $00002105;
  SOMITEM_DATATYPE_DATE = $00002106;
  SOMITEM_DATATYPE_DATETIME = $00002107;
  SOMITEM_DATATYPE_DAY = $00002108;
  SOMITEM_DATATYPE_DECIMAL = $00002109;
  SOMITEM_DATATYPE_DOUBLE = $0000210A;
  SOMITEM_DATATYPE_DURATION = $0000210B;
  SOMITEM_DATATYPE_ENTITIES = $0000210C;
  SOMITEM_DATATYPE_ENTITY = $0000210D;
  SOMITEM_DATATYPE_FLOAT = $0000210E;
  SOMITEM_DATATYPE_HEXBINARY = $0000210F;
  SOMITEM_DATATYPE_ID = $00002110;
  SOMITEM_DATATYPE_IDREF = $00002111;
  SOMITEM_DATATYPE_IDREFS = $00002112;
  SOMITEM_DATATYPE_INT = $00002113;
  SOMITEM_DATATYPE_INTEGER = $00002114;
  SOMITEM_DATATYPE_LANGUAGE = $00002115;
  SOMITEM_DATATYPE_LONG = $00002116;
  SOMITEM_DATATYPE_MONTH = $00002117;
  SOMITEM_DATATYPE_MONTHDAY = $00002118;
  SOMITEM_DATATYPE_NAME = $00002119;
  SOMITEM_DATATYPE_NCNAME = $0000211A;
  SOMITEM_DATATYPE_NEGATIVEINTEGER = $0000211B;
  SOMITEM_DATATYPE_NMTOKEN = $0000211C;
  SOMITEM_DATATYPE_NMTOKENS = $0000211D;
  SOMITEM_DATATYPE_NONNEGATIVEINTEGER = $0000211E;
  SOMITEM_DATATYPE_NONPOSITIVEINTEGER = $0000211F;
  SOMITEM_DATATYPE_NORMALIZEDSTRING = $00002120;
  SOMITEM_DATATYPE_NOTATION = $00002121;
  SOMITEM_DATATYPE_POSITIVEINTEGER = $00002122;
  SOMITEM_DATATYPE_QNAME = $00002123;
  SOMITEM_DATATYPE_SHORT = $00002124;
  SOMITEM_DATATYPE_STRING = $00002125;
  SOMITEM_DATATYPE_TIME = $00002126;
  SOMITEM_DATATYPE_TOKEN = $00002127;
  SOMITEM_DATATYPE_UNSIGNEDBYTE = $00002128;
  SOMITEM_DATATYPE_UNSIGNEDINT = $00002129;
  SOMITEM_DATATYPE_UNSIGNEDLONG = $0000212A;
  SOMITEM_DATATYPE_UNSIGNEDSHORT = $0000212B;
  SOMITEM_DATATYPE_YEAR = $0000212C;
  SOMITEM_DATATYPE_YEARMONTH = $0000212D;
  SOMITEM_DATATYPE_ANYSIMPLETYPE = $000021FF;
  SOMITEM_SIMPLETYPE = $00002200;
  SOMITEM_COMPLEXTYPE = $00002400;
  SOMITEM_PARTICLE = $00004000;
  SOMITEM_ANY = $00004001;
  SOMITEM_ANYATTRIBUTE = $00004002;
  SOMITEM_ELEMENT = $00004003;
  SOMITEM_GROUP = $00004100;
  SOMITEM_ALL = $00004101;
  SOMITEM_CHOICE = $00004102;
  SOMITEM_SEQUENCE = $00004103;
  SOMITEM_EMPTYPARTICLE = $00004104;
  SOMITEM_NULL = $00000800;
  SOMITEM_NULL_TYPE = $00002800;
  SOMITEM_NULL_ANY = $00004801;
  SOMITEM_NULL_ANYATTRIBUTE = $00004802;
  SOMITEM_NULL_ELEMENT = $00004803;

// Constantes pour enum _SCHEMADERIVATIONMETHOD
type
  _SCHEMADERIVATIONMETHOD = TOleEnum;
const
  SCHEMADERIVATIONMETHOD_EMPTY = $00000000;
  SCHEMADERIVATIONMETHOD_SUBSTITUTION = $00000001;
  SCHEMADERIVATIONMETHOD_EXTENSION = $00000002;
  SCHEMADERIVATIONMETHOD_RESTRICTION = $00000004;
  SCHEMADERIVATIONMETHOD_LIST = $00000008;
  SCHEMADERIVATIONMETHOD_UNION = $00000010;
  SCHEMADERIVATIONMETHOD_ALL = $000000FF;
  SCHEMADERIVATIONMETHOD_NONE = $00000100;

// Constantes pour enum _SCHEMATYPEVARIETY
type
  _SCHEMATYPEVARIETY = TOleEnum;
const
  SCHEMATYPEVARIETY_NONE = $FFFFFFFF;
  SCHEMATYPEVARIETY_ATOMIC = $00000000;
  SCHEMATYPEVARIETY_LIST = $00000001;
  SCHEMATYPEVARIETY_UNION = $00000002;

// Constantes pour enum _SCHEMAWHITESPACE
type
  _SCHEMAWHITESPACE = TOleEnum;
const
  SCHEMAWHITESPACE_NONE = $FFFFFFFF;
  SCHEMAWHITESPACE_PRESERVE = $00000000;
  SCHEMAWHITESPACE_REPLACE = $00000001;
  SCHEMAWHITESPACE_COLLAPSE = $00000002;

// Constantes pour enum _SCHEMAPROCESSCONTENTS
type
  _SCHEMAPROCESSCONTENTS = TOleEnum;
const
  SCHEMAPROCESSCONTENTS_NONE = $00000000;
  SCHEMAPROCESSCONTENTS_SKIP = $00000001;
  SCHEMAPROCESSCONTENTS_LAX = $00000002;
  SCHEMAPROCESSCONTENTS_STRICT = $00000003;

// Constantes pour enum _SCHEMACONTENTTYPE
type
  _SCHEMACONTENTTYPE = TOleEnum;
const
  SCHEMACONTENTTYPE_EMPTY = $00000000;
  SCHEMACONTENTTYPE_TEXTONLY = $00000001;
  SCHEMACONTENTTYPE_ELEMENTONLY = $00000002;
  SCHEMACONTENTTYPE_MIXED = $00000003;

// Constantes pour enum _SCHEMAUSE
type
  _SCHEMAUSE = TOleEnum;
const
  SCHEMAUSE_OPTIONAL = $00000000;
  SCHEMAUSE_PROHIBITED = $00000001;
  SCHEMAUSE_REQUIRED = $00000002;

// Constantes pour enum tagXMLEMEM_TYPE
type
  tagXMLEMEM_TYPE = TOleEnum;
const
  XMLELEMTYPE_ELEMENT = $00000000;
  XMLELEMTYPE_TEXT = $00000001;
  XMLELEMTYPE_COMMENT = $00000002;
  XMLELEMTYPE_DOCUMENT = $00000003;
  XMLELEMTYPE_DTD = $00000004;
  XMLELEMTYPE_PI = $00000005;
  XMLELEMTYPE_OTHER = $00000006;

// Constantes pour enum _SERVERXMLHTTP_OPTION
type
  _SERVERXMLHTTP_OPTION = TOleEnum;
const
  SXH_OPTION_URL = $FFFFFFFF;
  SXH_OPTION_URL_CODEPAGE = $00000000;
  SXH_OPTION_ESCAPE_PERCENT_IN_URL = $00000001;
  SXH_OPTION_IGNORE_SERVER_SSL_CERT_ERROR_FLAGS = $00000002;
  SXH_OPTION_SELECT_CLIENT_SSL_CERT = $00000003;

// Constantes pour enum _SXH_SERVER_CERT_OPTION
type
  _SXH_SERVER_CERT_OPTION = TOleEnum;
const
  SXH_SERVER_CERT_IGNORE_UNKNOWN_CA = $00000100;
  SXH_SERVER_CERT_IGNORE_WRONG_USAGE = $00000200;
  SXH_SERVER_CERT_IGNORE_CERT_CN_INVALID = $00001000;
  SXH_SERVER_CERT_IGNORE_CERT_DATE_INVALID = $00002000;
  SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = $00003300;

// Constantes pour enum _SXH_PROXY_SETTING
type
  _SXH_PROXY_SETTING = TOleEnum;
const
  SXH_PROXY_SET_DEFAULT = $00000000;
  SXH_PROXY_SET_PRECONFIG = $00000000;
  SXH_PROXY_SET_DIRECT = $00000001;
  SXH_PROXY_SET_PROXY = $00000002;

type

// *********************************************************************//
// D�claration Forward des types d�finis dans la biblioth�que de types    
// *********************************************************************//
  IXMLDOMImplementation = interface;
  IXMLDOMImplementationDisp = dispinterface;
  IXMLDOMNode = interface;
  IXMLDOMNodeDisp = dispinterface;
  IXMLDOMNodeList = interface;
  IXMLDOMNodeListDisp = dispinterface;
  IXMLDOMNamedNodeMap = interface;
  IXMLDOMNamedNodeMapDisp = dispinterface;
  IXMLDOMDocument = interface;
  IXMLDOMDocumentDisp = dispinterface;
  IXMLDOMDocumentType = interface;
  IXMLDOMDocumentTypeDisp = dispinterface;
  IXMLDOMElement = interface;
  IXMLDOMElementDisp = dispinterface;
  IXMLDOMAttribute = interface;
  IXMLDOMAttributeDisp = dispinterface;
  IXMLDOMDocumentFragment = interface;
  IXMLDOMDocumentFragmentDisp = dispinterface;
  IXMLDOMCharacterData = interface;
  IXMLDOMCharacterDataDisp = dispinterface;
  IXMLDOMText = interface;
  IXMLDOMTextDisp = dispinterface;
  IXMLDOMComment = interface;
  IXMLDOMCommentDisp = dispinterface;
  IXMLDOMCDATASection = interface;
  IXMLDOMCDATASectionDisp = dispinterface;
  IXMLDOMProcessingInstruction = interface;
  IXMLDOMProcessingInstructionDisp = dispinterface;
  IXMLDOMEntityReference = interface;
  IXMLDOMEntityReferenceDisp = dispinterface;
  IXMLDOMParseError = interface;
  IXMLDOMParseErrorDisp = dispinterface;
  IXMLDOMDocument2 = interface;
  IXMLDOMDocument2Disp = dispinterface;
  IXMLDOMSchemaCollection = interface;
  IXMLDOMSchemaCollectionDisp = dispinterface;
  IXMLDOMNotation = interface;
  IXMLDOMNotationDisp = dispinterface;
  IXMLDOMEntity = interface;
  IXMLDOMEntityDisp = dispinterface;
  IXTLRuntime = interface;
  IXTLRuntimeDisp = dispinterface;
  IXSLTemplate = interface;
  IXSLTemplateDisp = dispinterface;
  IXSLProcessor = interface;
  IXSLProcessorDisp = dispinterface;
  ISAXXMLReader = interface;
  ISAXEntityResolver = interface;
  ISAXContentHandler = interface;
  ISAXLocator = interface;
  ISAXAttributes = interface;
  ISAXDTDHandler = interface;
  ISAXErrorHandler = interface;
  ISAXXMLFilter = interface;
  ISAXLexicalHandler = interface;
  ISAXDeclHandler = interface;
  IVBSAXXMLReader = interface;
  IVBSAXXMLReaderDisp = dispinterface;
  IVBSAXEntityResolver = interface;
  IVBSAXEntityResolverDisp = dispinterface;
  IVBSAXContentHandler = interface;
  IVBSAXContentHandlerDisp = dispinterface;
  IVBSAXLocator = interface;
  IVBSAXLocatorDisp = dispinterface;
  IVBSAXAttributes = interface;
  IVBSAXAttributesDisp = dispinterface;
  IVBSAXDTDHandler = interface;
  IVBSAXDTDHandlerDisp = dispinterface;
  IVBSAXErrorHandler = interface;
  IVBSAXErrorHandlerDisp = dispinterface;
  IVBSAXXMLFilter = interface;
  IVBSAXXMLFilterDisp = dispinterface;
  IVBSAXLexicalHandler = interface;
  IVBSAXLexicalHandlerDisp = dispinterface;
  IVBSAXDeclHandler = interface;
  IVBSAXDeclHandlerDisp = dispinterface;
  IMXWriter = interface;
  IMXWriterDisp = dispinterface;
  IMXAttributes = interface;
  IMXAttributesDisp = dispinterface;
  IMXReaderControl = interface;
  IMXReaderControlDisp = dispinterface;
  IMXSchemaDeclHandler = interface;
  IMXSchemaDeclHandlerDisp = dispinterface;
  ISchemaItem = interface;
  ISchemaItemDisp = dispinterface;
  ISchemaParticle = interface;
  ISchemaParticleDisp = dispinterface;
  ISchemaElement = interface;
  ISchemaElementDisp = dispinterface;
  ISchema = interface;
  ISchemaDisp = dispinterface;
  ISchemaItemCollection = interface;
  ISchemaItemCollectionDisp = dispinterface;
  ISchemaStringCollection = interface;
  ISchemaStringCollectionDisp = dispinterface;
  ISchemaType = interface;
  ISchemaTypeDisp = dispinterface;
  ISchemaComplexType = interface;
  ISchemaComplexTypeDisp = dispinterface;
  ISchemaAny = interface;
  ISchemaAnyDisp = dispinterface;
  ISchemaModelGroup = interface;
  ISchemaModelGroupDisp = dispinterface;
  IXMLDOMSchemaCollection2 = interface;
  IXMLDOMSchemaCollection2Disp = dispinterface;
  ISchemaAttribute = interface;
  ISchemaAttributeDisp = dispinterface;
  ISchemaAttributeGroup = interface;
  ISchemaAttributeGroupDisp = dispinterface;
  ISchemaIdentityConstraint = interface;
  ISchemaIdentityConstraintDisp = dispinterface;
  ISchemaNotation = interface;
  ISchemaNotationDisp = dispinterface;
  IXMLElementCollection = interface;
  IXMLElementCollectionDisp = dispinterface;
  IXMLDocument = interface;
  IXMLDocumentDisp = dispinterface;
  IXMLElement = interface;
  IXMLElementDisp = dispinterface;
  IXMLDocument2 = interface;
  IXMLElement2 = interface;
  IXMLElement2Disp = dispinterface;
  IXMLAttribute = interface;
  IXMLAttributeDisp = dispinterface;
  IXMLError = interface;
  IXMLDOMSelection = interface;
  IXMLDOMSelectionDisp = dispinterface;
  XMLDOMDocumentEvents = dispinterface;
  IDSOControl = interface;
  IDSOControlDisp = dispinterface;
  IXMLHTTPRequest = interface;
  IXMLHTTPRequestDisp = dispinterface;
  IServerXMLHTTPRequest = interface;
  IServerXMLHTTPRequestDisp = dispinterface;
  IServerXMLHTTPRequest2 = interface;
  IServerXMLHTTPRequest2Disp = dispinterface;
  IMXNamespacePrefixes = interface;
  IMXNamespacePrefixesDisp = dispinterface;
  IVBMXNamespaceManager = interface;
  IVBMXNamespaceManagerDisp = dispinterface;
  IMXNamespaceManager = interface;

// *********************************************************************//
// D�claration de CoClasses d�finies dans la biblioth�que de types 
// (REMARQUE: On affecte chaque CoClasse � son Interface par d�faut)              
// *********************************************************************//
  DOMDocument = IXMLDOMDocument2;
  DOMDocument26 = IXMLDOMDocument2;
  DOMDocument30 = IXMLDOMDocument2;
  DOMDocument40 = IXMLDOMDocument2;
  FreeThreadedDOMDocument = IXMLDOMDocument2;
  FreeThreadedDOMDocument26 = IXMLDOMDocument2;
  FreeThreadedDOMDocument30 = IXMLDOMDocument2;
  FreeThreadedDOMDocument40 = IXMLDOMDocument2;
  XMLSchemaCache = IXMLDOMSchemaCollection;
  XMLSchemaCache26 = IXMLDOMSchemaCollection;
  XMLSchemaCache30 = IXMLDOMSchemaCollection;
  XMLSchemaCache40 = IXMLDOMSchemaCollection2;
  XSLTemplate = IXSLTemplate;
  XSLTemplate26 = IXSLTemplate;
  XSLTemplate30 = IXSLTemplate;
  XSLTemplate40 = IXSLTemplate;
  DSOControl = IDSOControl;
  DSOControl26 = IDSOControl;
  DSOControl30 = IDSOControl;
  DSOControl40 = IDSOControl;
  XMLHTTP = IXMLHTTPRequest;
  XMLHTTP26 = IXMLHTTPRequest;
  XMLHTTP30 = IXMLHTTPRequest;
  XMLHTTP40 = IXMLHTTPRequest;
  ServerXMLHTTP = IServerXMLHTTPRequest2;
  ServerXMLHTTP30 = IServerXMLHTTPRequest2;
  ServerXMLHTTP40 = IServerXMLHTTPRequest2;
  SAXXMLReader = IVBSAXXMLReader;
  SAXXMLReader30 = IVBSAXXMLReader;
  SAXXMLReader40 = IVBSAXXMLReader;
  MXXMLWriter = IMXWriter;
  MXXMLWriter30 = IMXWriter;
  MXXMLWriter40 = IMXWriter;
  MXHTMLWriter = IMXWriter;
  MXHTMLWriter30 = IMXWriter;
  MXHTMLWriter40 = IMXWriter;
  SAXAttributes = IMXAttributes;
  SAXAttributes30 = IMXAttributes;
  SAXAttributes40 = IMXAttributes;
  MXNamespaceManager = IVBMXNamespaceManager;
  MXNamespaceManager40 = IVBMXNamespaceManager;
  XMLDocument = IXMLDocument2;


// *********************************************************************//
// D�claration de structures, d'unions et d'alias.                        
// *********************************************************************//
  PWord1 = ^Word; {*}
  PUserType1 = ^_xml_error; {*}

  DOMNodeType = tagDOMNodeType; 
  SOMITEMTYPE = _SOMITEMTYPE; 
  SCHEMADERIVATIONMETHOD = _SCHEMADERIVATIONMETHOD; 
  SCHEMATYPEVARIETY = _SCHEMATYPEVARIETY; 
  SCHEMAWHITESPACE = _SCHEMAWHITESPACE; 
  SCHEMAPROCESSCONTENTS = _SCHEMAPROCESSCONTENTS; 
  SCHEMACONTENTTYPE = _SCHEMACONTENTTYPE; 
  SCHEMAUSE = _SCHEMAUSE; 

  _xml_error = packed record
    _nLine: SYSUINT;
    _pchBuf: WideString;
    _cchBuf: SYSUINT;
    _ich: SYSUINT;
    _pszFound: WideString;
    _pszExpected: WideString;
    _reserved1: LongWord;
    _reserved2: LongWord;
  end;

  XMLELEM_TYPE = tagXMLEMEM_TYPE; 
  SERVERXMLHTTP_OPTION = _SERVERXMLHTTP_OPTION; 
  SXH_SERVER_CERT_OPTION = _SXH_SERVER_CERT_OPTION; 
  SXH_PROXY_SETTING = _SXH_PROXY_SETTING; 

// *********************************************************************//
// Interface   : IXMLDOMImplementation
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF8F-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMImplementation = interface(IDispatch)
    ['{2933BF8F-7B36-11D2-B20E-00C04F983E60}']
    function hasFeature(const feature: WideString; const version: WideString): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMImplementationDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF8F-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMImplementationDisp = dispinterface
    ['{2933BF8F-7B36-11D2-B20E-00C04F983E60}']
    function hasFeature(const feature: WideString; const version: WideString): WordBool; dispid 145;
  end;

// *********************************************************************//
// Interface   : IXMLDOMNode
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF80-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMNode = interface(IDispatch)
    ['{2933BF80-7B36-11D2-B20E-00C04F983E60}']
    function Get_nodeName: WideString; safecall;
    function Get_nodeValue: OleVariant; safecall;
    procedure Set_nodeValue(value: OleVariant); safecall;
    function Get_nodeType: DOMNodeType; safecall;
    function Get_parentNode: IXMLDOMNode; safecall;
    function Get_childNodes: IXMLDOMNodeList; safecall;
    function Get_firstChild: IXMLDOMNode; safecall;
    function Get_lastChild: IXMLDOMNode; safecall;
    function Get_previousSibling: IXMLDOMNode; safecall;
    function Get_nextSibling: IXMLDOMNode; safecall;
    function Get_attributes: IXMLDOMNamedNodeMap; safecall;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; safecall;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; safecall;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; safecall;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; safecall;
    function hasChildNodes: WordBool; safecall;
    function Get_ownerDocument: IXMLDOMDocument; safecall;
    function cloneNode(deep: WordBool): IXMLDOMNode; safecall;
    function Get_nodeTypeString: WideString; safecall;
    function Get_text: WideString; safecall;
    procedure Set_text(const text: WideString); safecall;
    function Get_specified: WordBool; safecall;
    function Get_definition: IXMLDOMNode; safecall;
    function Get_nodeTypedValue: OleVariant; safecall;
    procedure Set_nodeTypedValue(typedValue: OleVariant); safecall;
    function Get_dataType: OleVariant; safecall;
    procedure Set_dataType(const dataTypeName: WideString); safecall;
    function Get_xml: WideString; safecall;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; safecall;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; safecall;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; safecall;
    function Get_parsed: WordBool; safecall;
    function Get_namespaceURI: WideString; safecall;
    function Get_prefix: WideString; safecall;
    function Get_baseName: WideString; safecall;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); safecall;
    property nodeName: WideString read Get_nodeName;
    property nodeValue: OleVariant read Get_nodeValue write Set_nodeValue;
    property nodeType: DOMNodeType read Get_nodeType;
    property parentNode: IXMLDOMNode read Get_parentNode;
    property childNodes: IXMLDOMNodeList read Get_childNodes;
    property firstChild: IXMLDOMNode read Get_firstChild;
    property lastChild: IXMLDOMNode read Get_lastChild;
    property previousSibling: IXMLDOMNode read Get_previousSibling;
    property nextSibling: IXMLDOMNode read Get_nextSibling;
    property attributes: IXMLDOMNamedNodeMap read Get_attributes;
    property ownerDocument: IXMLDOMDocument read Get_ownerDocument;
    property nodeTypeString: WideString read Get_nodeTypeString;
    property text: WideString read Get_text write Set_text;
    property specified: WordBool read Get_specified;
    property definition: IXMLDOMNode read Get_definition;
    property nodeTypedValue: OleVariant read Get_nodeTypedValue write Set_nodeTypedValue;
    property xml: WideString read Get_xml;
    property parsed: WordBool read Get_parsed;
    property namespaceURI: WideString read Get_namespaceURI;
    property prefix: WideString read Get_prefix;
    property baseName: WideString read Get_baseName;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMNodeDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF80-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMNodeDisp = dispinterface
    ['{2933BF80-7B36-11D2-B20E-00C04F983E60}']
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXMLDOMNodeList
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF82-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMNodeList = interface(IDispatch)
    ['{2933BF82-7B36-11D2-B20E-00C04F983E60}']
    function Get_item(index: Integer): IXMLDOMNode; safecall;
    function Get_length: Integer; safecall;
    function nextNode: IXMLDOMNode; safecall;
    procedure reset; safecall;
    function Get__newEnum: IUnknown; safecall;
    property item[index: Integer]: IXMLDOMNode read Get_item; default;
    property length: Integer read Get_length;
    property _newEnum: IUnknown read Get__newEnum;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMNodeListDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF82-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMNodeListDisp = dispinterface
    ['{2933BF82-7B36-11D2-B20E-00C04F983E60}']
    property item[index: Integer]: IXMLDOMNode readonly dispid 0; default;
    property length: Integer readonly dispid 74;
    function nextNode: IXMLDOMNode; dispid 76;
    procedure reset; dispid 77;
    property _newEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface   : IXMLDOMNamedNodeMap
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF83-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMNamedNodeMap = interface(IDispatch)
    ['{2933BF83-7B36-11D2-B20E-00C04F983E60}']
    function getNamedItem(const name: WideString): IXMLDOMNode; safecall;
    function setNamedItem(const newItem: IXMLDOMNode): IXMLDOMNode; safecall;
    function removeNamedItem(const name: WideString): IXMLDOMNode; safecall;
    function Get_item(index: Integer): IXMLDOMNode; safecall;
    function Get_length: Integer; safecall;
    function getQualifiedItem(const baseName: WideString; const namespaceURI: WideString): IXMLDOMNode; safecall;
    function removeQualifiedItem(const baseName: WideString; const namespaceURI: WideString): IXMLDOMNode; safecall;
    function nextNode: IXMLDOMNode; safecall;
    procedure reset; safecall;
    function Get__newEnum: IUnknown; safecall;
    property item[index: Integer]: IXMLDOMNode read Get_item; default;
    property length: Integer read Get_length;
    property _newEnum: IUnknown read Get__newEnum;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMNamedNodeMapDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF83-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMNamedNodeMapDisp = dispinterface
    ['{2933BF83-7B36-11D2-B20E-00C04F983E60}']
    function getNamedItem(const name: WideString): IXMLDOMNode; dispid 83;
    function setNamedItem(const newItem: IXMLDOMNode): IXMLDOMNode; dispid 84;
    function removeNamedItem(const name: WideString): IXMLDOMNode; dispid 85;
    property item[index: Integer]: IXMLDOMNode readonly dispid 0; default;
    property length: Integer readonly dispid 74;
    function getQualifiedItem(const baseName: WideString; const namespaceURI: WideString): IXMLDOMNode; dispid 87;
    function removeQualifiedItem(const baseName: WideString; const namespaceURI: WideString): IXMLDOMNode; dispid 88;
    function nextNode: IXMLDOMNode; dispid 89;
    procedure reset; dispid 90;
    property _newEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface   : IXMLDOMDocument
// Indicateurs : (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF81-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMDocument = interface(IXMLDOMNode)
    ['{2933BF81-7B36-11D2-B20E-00C04F983E60}']
    function Get_doctype: IXMLDOMDocumentType; safecall;
    function Get_implementation_: IXMLDOMImplementation; safecall;
    function Get_documentElement: IXMLDOMElement; safecall;
    procedure _Set_documentElement(const DOMElement: IXMLDOMElement); safecall;
    function createElement(const tagName: WideString): IXMLDOMElement; safecall;
    function createDocumentFragment: IXMLDOMDocumentFragment; safecall;
    function createTextNode(const data: WideString): IXMLDOMText; safecall;
    function createComment(const data: WideString): IXMLDOMComment; safecall;
    function createCDATASection(const data: WideString): IXMLDOMCDATASection; safecall;
    function createProcessingInstruction(const target: WideString; const data: WideString): IXMLDOMProcessingInstruction; safecall;
    function createAttribute(const name: WideString): IXMLDOMAttribute; safecall;
    function createEntityReference(const name: WideString): IXMLDOMEntityReference; safecall;
    function getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; safecall;
    function createNode(type_: OleVariant; const name: WideString; const namespaceURI: WideString): IXMLDOMNode; safecall;
    function nodeFromID(const idString: WideString): IXMLDOMNode; safecall;
    function load(xmlSource: OleVariant): WordBool; safecall;
    function Get_readyState: Integer; safecall;
    function Get_parseError: IXMLDOMParseError; safecall;
    function Get_url: WideString; safecall;
    function Get_async: WordBool; safecall;
    procedure Set_async(isAsync: WordBool); safecall;
    procedure abort; safecall;
    function loadXML(const bstrXML: WideString): WordBool; safecall;
    procedure save(destination: OleVariant); safecall;
    function Get_validateOnParse: WordBool; safecall;
    procedure Set_validateOnParse(isValidating: WordBool); safecall;
    function Get_resolveExternals: WordBool; safecall;
    procedure Set_resolveExternals(isResolving: WordBool); safecall;
    function Get_preserveWhiteSpace: WordBool; safecall;
    procedure Set_preserveWhiteSpace(isPreserving: WordBool); safecall;
    procedure Set_onreadystatechange(Param1: OleVariant); safecall;
    procedure Set_ondataavailable(Param1: OleVariant); safecall;
    procedure Set_ontransformnode(Param1: OleVariant); safecall;
    property doctype: IXMLDOMDocumentType read Get_doctype;
    property implementation_: IXMLDOMImplementation read Get_implementation_;
    property documentElement: IXMLDOMElement read Get_documentElement write _Set_documentElement;
    property readyState: Integer read Get_readyState;
    property parseError: IXMLDOMParseError read Get_parseError;
    property url: WideString read Get_url;
    property async: WordBool read Get_async write Set_async;
    property validateOnParse: WordBool read Get_validateOnParse write Set_validateOnParse;
    property resolveExternals: WordBool read Get_resolveExternals write Set_resolveExternals;
    property preserveWhiteSpace: WordBool read Get_preserveWhiteSpace write Set_preserveWhiteSpace;
    property onreadystatechange: OleVariant write Set_onreadystatechange;
    property ondataavailable: OleVariant write Set_ondataavailable;
    property ontransformnode: OleVariant write Set_ontransformnode;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMDocumentDisp
// Flags :     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF81-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMDocumentDisp = dispinterface
    ['{2933BF81-7B36-11D2-B20E-00C04F983E60}']
    property doctype: IXMLDOMDocumentType readonly dispid 38;
    property implementation_: IXMLDOMImplementation readonly dispid 39;
    property documentElement: IXMLDOMElement dispid 40;
    function createElement(const tagName: WideString): IXMLDOMElement; dispid 41;
    function createDocumentFragment: IXMLDOMDocumentFragment; dispid 42;
    function createTextNode(const data: WideString): IXMLDOMText; dispid 43;
    function createComment(const data: WideString): IXMLDOMComment; dispid 44;
    function createCDATASection(const data: WideString): IXMLDOMCDATASection; dispid 45;
    function createProcessingInstruction(const target: WideString; const data: WideString): IXMLDOMProcessingInstruction; dispid 46;
    function createAttribute(const name: WideString): IXMLDOMAttribute; dispid 47;
    function createEntityReference(const name: WideString): IXMLDOMEntityReference; dispid 49;
    function getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; dispid 50;
    function createNode(type_: OleVariant; const name: WideString; const namespaceURI: WideString): IXMLDOMNode; dispid 54;
    function nodeFromID(const idString: WideString): IXMLDOMNode; dispid 56;
    function load(xmlSource: OleVariant): WordBool; dispid 58;
    property readyState: Integer readonly dispid -525;
    property parseError: IXMLDOMParseError readonly dispid 59;
    property url: WideString readonly dispid 60;
    property async: WordBool dispid 61;
    procedure abort; dispid 62;
    function loadXML(const bstrXML: WideString): WordBool; dispid 63;
    procedure save(destination: OleVariant); dispid 64;
    property validateOnParse: WordBool dispid 65;
    property resolveExternals: WordBool dispid 66;
    property preserveWhiteSpace: WordBool dispid 67;
    property onreadystatechange: OleVariant writeonly dispid 68;
    property ondataavailable: OleVariant writeonly dispid 69;
    property ontransformnode: OleVariant writeonly dispid 70;
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXMLDOMDocumentType
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF8B-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMDocumentType = interface(IXMLDOMNode)
    ['{2933BF8B-7B36-11D2-B20E-00C04F983E60}']
    function Get_name: WideString; safecall;
    function Get_entities: IXMLDOMNamedNodeMap; safecall;
    function Get_notations: IXMLDOMNamedNodeMap; safecall;
    property name: WideString read Get_name;
    property entities: IXMLDOMNamedNodeMap read Get_entities;
    property notations: IXMLDOMNamedNodeMap read Get_notations;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMDocumentTypeDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF8B-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMDocumentTypeDisp = dispinterface
    ['{2933BF8B-7B36-11D2-B20E-00C04F983E60}']
    property name: WideString readonly dispid 131;
    property entities: IXMLDOMNamedNodeMap readonly dispid 132;
    property notations: IXMLDOMNamedNodeMap readonly dispid 133;
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXMLDOMElement
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF86-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMElement = interface(IXMLDOMNode)
    ['{2933BF86-7B36-11D2-B20E-00C04F983E60}']
    function Get_tagName: WideString; safecall;
    function getAttribute(const name: WideString): OleVariant; safecall;
    procedure setAttribute(const name: WideString; value: OleVariant); safecall;
    procedure removeAttribute(const name: WideString); safecall;
    function getAttributeNode(const name: WideString): IXMLDOMAttribute; safecall;
    function setAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; safecall;
    function removeAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; safecall;
    function getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; safecall;
    procedure normalize; safecall;
    property tagName: WideString read Get_tagName;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMElementDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF86-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMElementDisp = dispinterface
    ['{2933BF86-7B36-11D2-B20E-00C04F983E60}']
    property tagName: WideString readonly dispid 97;
    function getAttribute(const name: WideString): OleVariant; dispid 99;
    procedure setAttribute(const name: WideString; value: OleVariant); dispid 100;
    procedure removeAttribute(const name: WideString); dispid 101;
    function getAttributeNode(const name: WideString): IXMLDOMAttribute; dispid 102;
    function setAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; dispid 103;
    function removeAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; dispid 104;
    function getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; dispid 105;
    procedure normalize; dispid 106;
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXMLDOMAttribute
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF85-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMAttribute = interface(IXMLDOMNode)
    ['{2933BF85-7B36-11D2-B20E-00C04F983E60}']
    function Get_name: WideString; safecall;
    function Get_value: OleVariant; safecall;
    procedure Set_value(attributeValue: OleVariant); safecall;
    property name: WideString read Get_name;
    property value: OleVariant read Get_value write Set_value;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMAttributeDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF85-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMAttributeDisp = dispinterface
    ['{2933BF85-7B36-11D2-B20E-00C04F983E60}']
    property name: WideString readonly dispid 118;
    property value: OleVariant dispid 120;
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXMLDOMDocumentFragment
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {3EFAA413-272F-11D2-836F-0000F87A7782}
// *********************************************************************//
  IXMLDOMDocumentFragment = interface(IXMLDOMNode)
    ['{3EFAA413-272F-11D2-836F-0000F87A7782}']
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMDocumentFragmentDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {3EFAA413-272F-11D2-836F-0000F87A7782}
// *********************************************************************//
  IXMLDOMDocumentFragmentDisp = dispinterface
    ['{3EFAA413-272F-11D2-836F-0000F87A7782}']
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXMLDOMCharacterData
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF84-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMCharacterData = interface(IXMLDOMNode)
    ['{2933BF84-7B36-11D2-B20E-00C04F983E60}']
    function Get_data: WideString; safecall;
    procedure Set_data(const data: WideString); safecall;
    function Get_length: Integer; safecall;
    function substringData(offset: Integer; count: Integer): WideString; safecall;
    procedure appendData(const data: WideString); safecall;
    procedure insertData(offset: Integer; const data: WideString); safecall;
    procedure deleteData(offset: Integer; count: Integer); safecall;
    procedure replaceData(offset: Integer; count: Integer; const data: WideString); safecall;
    property data: WideString read Get_data write Set_data;
    property length: Integer read Get_length;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMCharacterDataDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF84-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMCharacterDataDisp = dispinterface
    ['{2933BF84-7B36-11D2-B20E-00C04F983E60}']
    property data: WideString dispid 109;
    property length: Integer readonly dispid 110;
    function substringData(offset: Integer; count: Integer): WideString; dispid 111;
    procedure appendData(const data: WideString); dispid 112;
    procedure insertData(offset: Integer; const data: WideString); dispid 113;
    procedure deleteData(offset: Integer; count: Integer); dispid 114;
    procedure replaceData(offset: Integer; count: Integer; const data: WideString); dispid 115;
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXMLDOMText
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF87-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMText = interface(IXMLDOMCharacterData)
    ['{2933BF87-7B36-11D2-B20E-00C04F983E60}']
    function splitText(offset: Integer): IXMLDOMText; safecall;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMTextDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF87-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMTextDisp = dispinterface
    ['{2933BF87-7B36-11D2-B20E-00C04F983E60}']
    function splitText(offset: Integer): IXMLDOMText; dispid 123;
    property data: WideString dispid 109;
    property length: Integer readonly dispid 110;
    function substringData(offset: Integer; count: Integer): WideString; dispid 111;
    procedure appendData(const data: WideString); dispid 112;
    procedure insertData(offset: Integer; const data: WideString); dispid 113;
    procedure deleteData(offset: Integer; count: Integer); dispid 114;
    procedure replaceData(offset: Integer; count: Integer; const data: WideString); dispid 115;
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXMLDOMComment
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF88-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMComment = interface(IXMLDOMCharacterData)
    ['{2933BF88-7B36-11D2-B20E-00C04F983E60}']
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMCommentDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF88-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMCommentDisp = dispinterface
    ['{2933BF88-7B36-11D2-B20E-00C04F983E60}']
    property data: WideString dispid 109;
    property length: Integer readonly dispid 110;
    function substringData(offset: Integer; count: Integer): WideString; dispid 111;
    procedure appendData(const data: WideString); dispid 112;
    procedure insertData(offset: Integer; const data: WideString); dispid 113;
    procedure deleteData(offset: Integer; count: Integer); dispid 114;
    procedure replaceData(offset: Integer; count: Integer; const data: WideString); dispid 115;
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXMLDOMCDATASection
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF8A-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMCDATASection = interface(IXMLDOMText)
    ['{2933BF8A-7B36-11D2-B20E-00C04F983E60}']
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMCDATASectionDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF8A-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMCDATASectionDisp = dispinterface
    ['{2933BF8A-7B36-11D2-B20E-00C04F983E60}']
    function splitText(offset: Integer): IXMLDOMText; dispid 123;
    property data: WideString dispid 109;
    property length: Integer readonly dispid 110;
    function substringData(offset: Integer; count: Integer): WideString; dispid 111;
    procedure appendData(const data: WideString); dispid 112;
    procedure insertData(offset: Integer; const data: WideString); dispid 113;
    procedure deleteData(offset: Integer; count: Integer); dispid 114;
    procedure replaceData(offset: Integer; count: Integer; const data: WideString); dispid 115;
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXMLDOMProcessingInstruction
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF89-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMProcessingInstruction = interface(IXMLDOMNode)
    ['{2933BF89-7B36-11D2-B20E-00C04F983E60}']
    function Get_target: WideString; safecall;
    function Get_data: WideString; safecall;
    procedure Set_data(const value: WideString); safecall;
    property target: WideString read Get_target;
    property data: WideString read Get_data write Set_data;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMProcessingInstructionDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF89-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMProcessingInstructionDisp = dispinterface
    ['{2933BF89-7B36-11D2-B20E-00C04F983E60}']
    property target: WideString readonly dispid 127;
    property data: WideString dispid 128;
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXMLDOMEntityReference
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF8E-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMEntityReference = interface(IXMLDOMNode)
    ['{2933BF8E-7B36-11D2-B20E-00C04F983E60}']
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMEntityReferenceDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF8E-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMEntityReferenceDisp = dispinterface
    ['{2933BF8E-7B36-11D2-B20E-00C04F983E60}']
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXMLDOMParseError
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {3EFAA426-272F-11D2-836F-0000F87A7782}
// *********************************************************************//
  IXMLDOMParseError = interface(IDispatch)
    ['{3EFAA426-272F-11D2-836F-0000F87A7782}']
    function Get_errorCode: Integer; safecall;
    function Get_url: WideString; safecall;
    function Get_reason: WideString; safecall;
    function Get_srcText: WideString; safecall;
    function Get_line: Integer; safecall;
    function Get_linepos: Integer; safecall;
    function Get_filepos: Integer; safecall;
    property errorCode: Integer read Get_errorCode;
    property url: WideString read Get_url;
    property reason: WideString read Get_reason;
    property srcText: WideString read Get_srcText;
    property line: Integer read Get_line;
    property linepos: Integer read Get_linepos;
    property filepos: Integer read Get_filepos;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMParseErrorDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {3EFAA426-272F-11D2-836F-0000F87A7782}
// *********************************************************************//
  IXMLDOMParseErrorDisp = dispinterface
    ['{3EFAA426-272F-11D2-836F-0000F87A7782}']
    property errorCode: Integer readonly dispid 0;
    property url: WideString readonly dispid 179;
    property reason: WideString readonly dispid 180;
    property srcText: WideString readonly dispid 181;
    property line: Integer readonly dispid 182;
    property linepos: Integer readonly dispid 183;
    property filepos: Integer readonly dispid 184;
  end;

// *********************************************************************//
// Interface   : IXMLDOMDocument2
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF95-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMDocument2 = interface(IXMLDOMDocument)
    ['{2933BF95-7B36-11D2-B20E-00C04F983E60}']
    function Get_namespaces: IXMLDOMSchemaCollection; safecall;
    function Get_schemas: OleVariant; safecall;
    procedure _Set_schemas(otherCollection: OleVariant); safecall;
    function validate: IXMLDOMParseError; safecall;
    procedure setProperty(const name: WideString; value: OleVariant); safecall;
    function getProperty(const name: WideString): OleVariant; safecall;
    property namespaces: IXMLDOMSchemaCollection read Get_namespaces;
    property schemas: OleVariant read Get_schemas write _Set_schemas;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMDocument2Disp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF95-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMDocument2Disp = dispinterface
    ['{2933BF95-7B36-11D2-B20E-00C04F983E60}']
    property namespaces: IXMLDOMSchemaCollection readonly dispid 201;
    property schemas: OleVariant dispid 202;
    function validate: IXMLDOMParseError; dispid 203;
    procedure setProperty(const name: WideString; value: OleVariant); dispid 204;
    function getProperty(const name: WideString): OleVariant; dispid 205;
    property doctype: IXMLDOMDocumentType readonly dispid 38;
    property implementation_: IXMLDOMImplementation readonly dispid 39;
    property documentElement: IXMLDOMElement dispid 40;
    function createElement(const tagName: WideString): IXMLDOMElement; dispid 41;
    function createDocumentFragment: IXMLDOMDocumentFragment; dispid 42;
    function createTextNode(const data: WideString): IXMLDOMText; dispid 43;
    function createComment(const data: WideString): IXMLDOMComment; dispid 44;
    function createCDATASection(const data: WideString): IXMLDOMCDATASection; dispid 45;
    function createProcessingInstruction(const target: WideString; const data: WideString): IXMLDOMProcessingInstruction; dispid 46;
    function createAttribute(const name: WideString): IXMLDOMAttribute; dispid 47;
    function createEntityReference(const name: WideString): IXMLDOMEntityReference; dispid 49;
    function getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; dispid 50;
    function createNode(type_: OleVariant; const name: WideString; const namespaceURI: WideString): IXMLDOMNode; dispid 54;
    function nodeFromID(const idString: WideString): IXMLDOMNode; dispid 56;
    function load(xmlSource: OleVariant): WordBool; dispid 58;
    property readyState: Integer readonly dispid -525;
    property parseError: IXMLDOMParseError readonly dispid 59;
    property url: WideString readonly dispid 60;
    property async: WordBool dispid 61;
    procedure abort; dispid 62;
    function loadXML(const bstrXML: WideString): WordBool; dispid 63;
    procedure save(destination: OleVariant); dispid 64;
    property validateOnParse: WordBool dispid 65;
    property resolveExternals: WordBool dispid 66;
    property preserveWhiteSpace: WordBool dispid 67;
    property onreadystatechange: OleVariant writeonly dispid 68;
    property ondataavailable: OleVariant writeonly dispid 69;
    property ontransformnode: OleVariant writeonly dispid 70;
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXMLDOMSchemaCollection
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {373984C8-B845-449B-91E7-45AC83036ADE}
// *********************************************************************//
  IXMLDOMSchemaCollection = interface(IDispatch)
    ['{373984C8-B845-449B-91E7-45AC83036ADE}']
    procedure add(const namespaceURI: WideString; var_: OleVariant); safecall;
    function get(const namespaceURI: WideString): IXMLDOMNode; safecall;
    procedure remove(const namespaceURI: WideString); safecall;
    function Get_length: Integer; safecall;
    function Get_namespaceURI(index: Integer): WideString; safecall;
    procedure addCollection(const otherCollection: IXMLDOMSchemaCollection); safecall;
    function Get__newEnum: IUnknown; safecall;
    property length: Integer read Get_length;
    property namespaceURI[index: Integer]: WideString read Get_namespaceURI; default;
    property _newEnum: IUnknown read Get__newEnum;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMSchemaCollectionDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {373984C8-B845-449B-91E7-45AC83036ADE}
// *********************************************************************//
  IXMLDOMSchemaCollectionDisp = dispinterface
    ['{373984C8-B845-449B-91E7-45AC83036ADE}']
    procedure add(const namespaceURI: WideString; var_: OleVariant); dispid 2;
    function get(const namespaceURI: WideString): IXMLDOMNode; dispid 3;
    procedure remove(const namespaceURI: WideString); dispid 4;
    property length: Integer readonly dispid 5;
    property namespaceURI[index: Integer]: WideString readonly dispid 0; default;
    procedure addCollection(const otherCollection: IXMLDOMSchemaCollection); dispid 6;
    property _newEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface   : IXMLDOMNotation
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF8C-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMNotation = interface(IXMLDOMNode)
    ['{2933BF8C-7B36-11D2-B20E-00C04F983E60}']
    function Get_publicId: OleVariant; safecall;
    function Get_systemId: OleVariant; safecall;
    property publicId: OleVariant read Get_publicId;
    property systemId: OleVariant read Get_systemId;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMNotationDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF8C-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMNotationDisp = dispinterface
    ['{2933BF8C-7B36-11D2-B20E-00C04F983E60}']
    property publicId: OleVariant readonly dispid 136;
    property systemId: OleVariant readonly dispid 137;
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXMLDOMEntity
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF8D-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMEntity = interface(IXMLDOMNode)
    ['{2933BF8D-7B36-11D2-B20E-00C04F983E60}']
    function Get_publicId: OleVariant; safecall;
    function Get_systemId: OleVariant; safecall;
    function Get_notationName: WideString; safecall;
    property publicId: OleVariant read Get_publicId;
    property systemId: OleVariant read Get_systemId;
    property notationName: WideString read Get_notationName;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMEntityDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF8D-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXMLDOMEntityDisp = dispinterface
    ['{2933BF8D-7B36-11D2-B20E-00C04F983E60}']
    property publicId: OleVariant readonly dispid 140;
    property systemId: OleVariant readonly dispid 141;
    property notationName: WideString readonly dispid 142;
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXTLRuntime
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {3EFAA425-272F-11D2-836F-0000F87A7782}
// *********************************************************************//
  IXTLRuntime = interface(IXMLDOMNode)
    ['{3EFAA425-272F-11D2-836F-0000F87A7782}']
    function uniqueID(const pNode: IXMLDOMNode): Integer; safecall;
    function depth(const pNode: IXMLDOMNode): Integer; safecall;
    function childNumber(const pNode: IXMLDOMNode): Integer; safecall;
    function ancestorChildNumber(const bstrNodeName: WideString; const pNode: IXMLDOMNode): Integer; safecall;
    function absoluteChildNumber(const pNode: IXMLDOMNode): Integer; safecall;
    function formatIndex(lIndex: Integer; const bstrFormat: WideString): WideString; safecall;
    function formatNumber(dblNumber: Double; const bstrFormat: WideString): WideString; safecall;
    function formatDate(varDate: OleVariant; const bstrFormat: WideString; varDestLocale: OleVariant): WideString; safecall;
    function formatTime(varTime: OleVariant; const bstrFormat: WideString; varDestLocale: OleVariant): WideString; safecall;
  end;

// *********************************************************************//
// DispIntf :  IXTLRuntimeDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {3EFAA425-272F-11D2-836F-0000F87A7782}
// *********************************************************************//
  IXTLRuntimeDisp = dispinterface
    ['{3EFAA425-272F-11D2-836F-0000F87A7782}']
    function uniqueID(const pNode: IXMLDOMNode): Integer; dispid 187;
    function depth(const pNode: IXMLDOMNode): Integer; dispid 188;
    function childNumber(const pNode: IXMLDOMNode): Integer; dispid 189;
    function ancestorChildNumber(const bstrNodeName: WideString; const pNode: IXMLDOMNode): Integer; dispid 190;
    function absoluteChildNumber(const pNode: IXMLDOMNode): Integer; dispid 191;
    function formatIndex(lIndex: Integer; const bstrFormat: WideString): WideString; dispid 192;
    function formatNumber(dblNumber: Double; const bstrFormat: WideString): WideString; dispid 193;
    function formatDate(varDate: OleVariant; const bstrFormat: WideString; varDestLocale: OleVariant): WideString; dispid 194;
    function formatTime(varTime: OleVariant; const bstrFormat: WideString; varDestLocale: OleVariant): WideString; dispid 195;
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    function dataType: OleVariant; dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

// *********************************************************************//
// Interface   : IXSLTemplate
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF93-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXSLTemplate = interface(IDispatch)
    ['{2933BF93-7B36-11D2-B20E-00C04F983E60}']
    procedure _Set_stylesheet(const stylesheet: IXMLDOMNode); safecall;
    function Get_stylesheet: IXMLDOMNode; safecall;
    function createProcessor: IXSLProcessor; safecall;
    property stylesheet: IXMLDOMNode read Get_stylesheet write _Set_stylesheet;
  end;

// *********************************************************************//
// DispIntf :  IXSLTemplateDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF93-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXSLTemplateDisp = dispinterface
    ['{2933BF93-7B36-11D2-B20E-00C04F983E60}']
    property stylesheet: IXMLDOMNode dispid 2;
    function createProcessor: IXSLProcessor; dispid 3;
  end;

// *********************************************************************//
// Interface   : IXSLProcessor
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2933BF92-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXSLProcessor = interface(IDispatch)
    ['{2933BF92-7B36-11D2-B20E-00C04F983E60}']
    procedure Set_input(pVar: OleVariant); safecall;
    function Get_input: OleVariant; safecall;
    function Get_ownerTemplate: IXSLTemplate; safecall;
    procedure setStartMode(const mode: WideString; const namespaceURI: WideString); safecall;
    function Get_startMode: WideString; safecall;
    function Get_startModeURI: WideString; safecall;
    procedure Set_output(pOutput: OleVariant); safecall;
    function Get_output: OleVariant; safecall;
    function transform: WordBool; safecall;
    procedure reset; safecall;
    function Get_readyState: Integer; safecall;
    procedure addParameter(const baseName: WideString; parameter: OleVariant; 
                           const namespaceURI: WideString); safecall;
    procedure addObject(const obj: IDispatch; const namespaceURI: WideString); safecall;
    function Get_stylesheet: IXMLDOMNode; safecall;
    property input: OleVariant read Get_input write Set_input;
    property ownerTemplate: IXSLTemplate read Get_ownerTemplate;
    property startMode: WideString read Get_startMode;
    property startModeURI: WideString read Get_startModeURI;
    property output: OleVariant read Get_output write Set_output;
    property readyState: Integer read Get_readyState;
    property stylesheet: IXMLDOMNode read Get_stylesheet;
  end;

// *********************************************************************//
// DispIntf :  IXSLProcessorDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2933BF92-7B36-11D2-B20E-00C04F983E60}
// *********************************************************************//
  IXSLProcessorDisp = dispinterface
    ['{2933BF92-7B36-11D2-B20E-00C04F983E60}']
    property input: OleVariant dispid 2;
    property ownerTemplate: IXSLTemplate readonly dispid 3;
    procedure setStartMode(const mode: WideString; const namespaceURI: WideString); dispid 4;
    property startMode: WideString readonly dispid 5;
    property startModeURI: WideString readonly dispid 6;
    property output: OleVariant dispid 7;
    function transform: WordBool; dispid 8;
    procedure reset; dispid 9;
    property readyState: Integer readonly dispid 10;
    procedure addParameter(const baseName: WideString; parameter: OleVariant; 
                           const namespaceURI: WideString); dispid 11;
    procedure addObject(const obj: IDispatch; const namespaceURI: WideString); dispid 12;
    property stylesheet: IXMLDOMNode readonly dispid 13;
  end;

// *********************************************************************//
// Interface   : ISAXXMLReader
// Indicateurs : (16) Hidden
// GUID        : {A4F96ED0-F829-476E-81C0-CDC7BD2A0802}
// *********************************************************************//
  ISAXXMLReader = interface(IUnknown)
    ['{A4F96ED0-F829-476E-81C0-CDC7BD2A0802}']
    function getFeature(var pwchName: Word; out pvfValue: WordBool): HResult; stdcall;
    function putFeature(var pwchName: Word; vfValue: WordBool): HResult; stdcall;
    function getProperty(var pwchName: Word; out pvarValue: OleVariant): HResult; stdcall;
    function putProperty(var pwchName: Word; varValue: OleVariant): HResult; stdcall;
    function getEntityResolver(out ppResolver: ISAXEntityResolver): HResult; stdcall;
    function putEntityResolver(const pResolver: ISAXEntityResolver): HResult; stdcall;
    function getContentHandler(out ppHandler: ISAXContentHandler): HResult; stdcall;
    function putContentHandler(const pHandler: ISAXContentHandler): HResult; stdcall;
    function getDTDHandler(out ppHandler: ISAXDTDHandler): HResult; stdcall;
    function putDTDHandler(const pHandler: ISAXDTDHandler): HResult; stdcall;
    function getErrorHandler(out ppHandler: ISAXErrorHandler): HResult; stdcall;
    function putErrorHandler(const pHandler: ISAXErrorHandler): HResult; stdcall;
    function getBaseURL(out ppwchBaseUrl: PWord1): HResult; stdcall;
    function putBaseURL(var pwchBaseUrl: Word): HResult; stdcall;
    function getSecureBaseURL(out ppwchSecureBaseUrl: PWord1): HResult; stdcall;
    function putSecureBaseURL(var pwchSecureBaseUrl: Word): HResult; stdcall;
    function parse(varInput: OleVariant): HResult; stdcall;
    function parseURL(var pwchUrl: Word): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : ISAXEntityResolver
// Indicateurs : (16) Hidden
// GUID        : {99BCA7BD-E8C4-4D5F-A0CF-6D907901FF07}
// *********************************************************************//
  ISAXEntityResolver = interface(IUnknown)
    ['{99BCA7BD-E8C4-4D5F-A0CF-6D907901FF07}']
    function resolveEntity(var pwchPublicId: Word; var pwchSystemId: Word; out pvarInput: OleVariant): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : ISAXContentHandler
// Indicateurs : (16) Hidden
// GUID        : {1545CDFA-9E4E-4497-A8A4-2BF7D0112C44}
// *********************************************************************//
  ISAXContentHandler = interface(IUnknown)
    ['{1545CDFA-9E4E-4497-A8A4-2BF7D0112C44}']
    function putDocumentLocator(const pLocator: ISAXLocator): HResult; stdcall;
    function startDocument: HResult; stdcall;
    function endDocument: HResult; stdcall;
    function startPrefixMapping(var pwchPrefix: Word; cchPrefix: SYSINT; var pwchUri: Word; 
                                cchUri: SYSINT): HResult; stdcall;
    function endPrefixMapping(var pwchPrefix: Word; cchPrefix: SYSINT): HResult; stdcall;
    function startElement(var pwchNamespaceUri: Word; cchNamespaceUri: SYSINT; 
                          var pwchLocalName: Word; cchLocalName: SYSINT; var pwchQName: Word; 
                          cchQName: SYSINT; const pAttributes: ISAXAttributes): HResult; stdcall;
    function endElement(var pwchNamespaceUri: Word; cchNamespaceUri: SYSINT; 
                        var pwchLocalName: Word; cchLocalName: SYSINT; var pwchQName: Word; 
                        cchQName: SYSINT): HResult; stdcall;
    function characters(var pwchChars: Word; cchChars: SYSINT): HResult; stdcall;
    function ignorableWhitespace(var pwchChars: Word; cchChars: SYSINT): HResult; stdcall;
    function processingInstruction(var pwchTarget: Word; cchTarget: SYSINT; var pwchData: Word; 
                                   cchData: SYSINT): HResult; stdcall;
    function skippedEntity(var pwchName: Word; cchName: SYSINT): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : ISAXLocator
// Indicateurs : (16) Hidden
// GUID        : {9B7E472A-0DE4-4640-BFF3-84D38A051C31}
// *********************************************************************//
  ISAXLocator = interface(IUnknown)
    ['{9B7E472A-0DE4-4640-BFF3-84D38A051C31}']
    function getColumnNumber(out pnColumn: SYSINT): HResult; stdcall;
    function getLineNumber(out pnLine: SYSINT): HResult; stdcall;
    function getPublicId(out ppwchPublicId: PWord1): HResult; stdcall;
    function getSystemId(out ppwchSystemId: PWord1): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : ISAXAttributes
// Indicateurs : (16) Hidden
// GUID        : {F078ABE1-45D2-4832-91EA-4466CE2F25C9}
// *********************************************************************//
  ISAXAttributes = interface(IUnknown)
    ['{F078ABE1-45D2-4832-91EA-4466CE2F25C9}']
    function getLength(out pnLength: SYSINT): HResult; stdcall;
    function getURI(nIndex: SYSINT; out ppwchUri: PWord1; out pcchUri: SYSINT): HResult; stdcall;
    function getLocalName(nIndex: SYSINT; out ppwchLocalName: PWord1; out pcchLocalName: SYSINT): HResult; stdcall;
    function getQName(nIndex: SYSINT; out ppwchQName: PWord1; out pcchQName: SYSINT): HResult; stdcall;
    function getName(nIndex: SYSINT; out ppwchUri: PWord1; out pcchUri: SYSINT; 
                     out ppwchLocalName: PWord1; out pcchLocalName: SYSINT; out ppwchQName: PWord1; 
                     out pcchQName: SYSINT): HResult; stdcall;
    function getIndexFromName(var pwchUri: Word; cchUri: SYSINT; var pwchLocalName: Word; 
                              cchLocalName: SYSINT; out pnIndex: SYSINT): HResult; stdcall;
    function getIndexFromQName(var pwchQName: Word; cchQName: SYSINT; out pnIndex: SYSINT): HResult; stdcall;
    function getType(nIndex: SYSINT; out ppwchType: PWord1; out pcchType: SYSINT): HResult; stdcall;
    function getTypeFromName(var pwchUri: Word; cchUri: SYSINT; var pwchLocalName: Word; 
                             cchLocalName: SYSINT; out ppwchType: PWord1; out pcchType: SYSINT): HResult; stdcall;
    function getTypeFromQName(var pwchQName: Word; cchQName: SYSINT; out ppwchType: PWord1; 
                              out pcchType: SYSINT): HResult; stdcall;
    function getValue(nIndex: SYSINT; out ppwchValue: PWord1; out pcchValue: SYSINT): HResult; stdcall;
    function getValueFromName(var pwchUri: Word; cchUri: SYSINT; var pwchLocalName: Word; 
                              cchLocalName: SYSINT; out ppwchValue: PWord1; out pcchValue: SYSINT): HResult; stdcall;
    function getValueFromQName(var pwchQName: Word; cchQName: SYSINT; out ppwchValue: PWord1; 
                               out pcchValue: SYSINT): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : ISAXDTDHandler
// Indicateurs : (16) Hidden
// GUID        : {E15C1BAF-AFB3-4D60-8C36-19A8C45DEFED}
// *********************************************************************//
  ISAXDTDHandler = interface(IUnknown)
    ['{E15C1BAF-AFB3-4D60-8C36-19A8C45DEFED}']
    function notationDecl(var pwchName: Word; cchName: SYSINT; var pwchPublicId: Word; 
                          cchPublicId: SYSINT; var pwchSystemId: Word; cchSystemId: SYSINT): HResult; stdcall;
    function unparsedEntityDecl(var pwchName: Word; cchName: SYSINT; var pwchPublicId: Word; 
                                cchPublicId: SYSINT; var pwchSystemId: Word; cchSystemId: SYSINT; 
                                var pwchNotationName: Word; cchNotationName: SYSINT): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : ISAXErrorHandler
// Indicateurs : (16) Hidden
// GUID        : {A60511C4-CCF5-479E-98A3-DC8DC545B7D0}
// *********************************************************************//
  ISAXErrorHandler = interface(IUnknown)
    ['{A60511C4-CCF5-479E-98A3-DC8DC545B7D0}']
    function error(const pLocator: ISAXLocator; var pwchErrorMessage: Word; hrErrorCode: HResult): HResult; stdcall;
    function fatalError(const pLocator: ISAXLocator; var pwchErrorMessage: Word; 
                        hrErrorCode: HResult): HResult; stdcall;
    function ignorableWarning(const pLocator: ISAXLocator; var pwchErrorMessage: Word; 
                              hrErrorCode: HResult): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : ISAXXMLFilter
// Indicateurs : (16) Hidden
// GUID        : {70409222-CA09-4475-ACB8-40312FE8D145}
// *********************************************************************//
  ISAXXMLFilter = interface(ISAXXMLReader)
    ['{70409222-CA09-4475-ACB8-40312FE8D145}']
    function getParent(out ppReader: ISAXXMLReader): HResult; stdcall;
    function putParent(const pReader: ISAXXMLReader): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : ISAXLexicalHandler
// Indicateurs : (16) Hidden
// GUID        : {7F85D5F5-47A8-4497-BDA5-84BA04819EA6}
// *********************************************************************//
  ISAXLexicalHandler = interface(IUnknown)
    ['{7F85D5F5-47A8-4497-BDA5-84BA04819EA6}']
    function startDTD(var pwchName: Word; cchName: SYSINT; var pwchPublicId: Word; 
                      cchPublicId: SYSINT; var pwchSystemId: Word; cchSystemId: SYSINT): HResult; stdcall;
    function endDTD: HResult; stdcall;
    function startEntity(var pwchName: Word; cchName: SYSINT): HResult; stdcall;
    function endEntity(var pwchName: Word; cchName: SYSINT): HResult; stdcall;
    function startCDATA: HResult; stdcall;
    function endCDATA: HResult; stdcall;
    function comment(var pwchChars: Word; cchChars: SYSINT): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : ISAXDeclHandler
// Indicateurs : (16) Hidden
// GUID        : {862629AC-771A-47B2-8337-4E6843C1BE90}
// *********************************************************************//
  ISAXDeclHandler = interface(IUnknown)
    ['{862629AC-771A-47B2-8337-4E6843C1BE90}']
    function elementDecl(var pwchName: Word; cchName: SYSINT; var pwchModel: Word; cchModel: SYSINT): HResult; stdcall;
    function attributeDecl(var pwchElementName: Word; cchElementName: SYSINT; 
                           var pwchAttributeName: Word; cchAttributeName: SYSINT; 
                           var pwchType: Word; cchType: SYSINT; var pwchValueDefault: Word; 
                           cchValueDefault: SYSINT; var pwchValue: Word; cchValue: SYSINT): HResult; stdcall;
    function internalEntityDecl(var pwchName: Word; cchName: SYSINT; var pwchValue: Word; 
                                cchValue: SYSINT): HResult; stdcall;
    function externalEntityDecl(var pwchName: Word; cchName: SYSINT; var pwchPublicId: Word; 
                                cchPublicId: SYSINT; var pwchSystemId: Word; cchSystemId: SYSINT): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : IVBSAXXMLReader
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {8C033CAA-6CD6-4F73-B728-4531AF74945F}
// *********************************************************************//
  IVBSAXXMLReader = interface(IDispatch)
    ['{8C033CAA-6CD6-4F73-B728-4531AF74945F}']
    function getFeature(const strName: WideString): WordBool; safecall;
    procedure putFeature(const strName: WideString; fValue: WordBool); safecall;
    function getProperty(const strName: WideString): OleVariant; safecall;
    procedure putProperty(const strName: WideString; varValue: OleVariant); safecall;
    function Get_entityResolver: IVBSAXEntityResolver; safecall;
    procedure _Set_entityResolver(const oResolver: IVBSAXEntityResolver); safecall;
    function Get_contentHandler: IVBSAXContentHandler; safecall;
    procedure _Set_contentHandler(const oHandler: IVBSAXContentHandler); safecall;
    function Get_dtdHandler: IVBSAXDTDHandler; safecall;
    procedure _Set_dtdHandler(const oHandler: IVBSAXDTDHandler); safecall;
    function Get_errorHandler: IVBSAXErrorHandler; safecall;
    procedure _Set_errorHandler(const oHandler: IVBSAXErrorHandler); safecall;
    function Get_baseURL: WideString; safecall;
    procedure Set_baseURL(const strBaseURL: WideString); safecall;
    function Get_secureBaseURL: WideString; safecall;
    procedure Set_secureBaseURL(const strSecureBaseURL: WideString); safecall;
    procedure parse(varInput: OleVariant); safecall;
    procedure parseURL(const strURL: WideString); safecall;
    property entityResolver: IVBSAXEntityResolver read Get_entityResolver write _Set_entityResolver;
    property contentHandler: IVBSAXContentHandler read Get_contentHandler write _Set_contentHandler;
    property dtdHandler: IVBSAXDTDHandler read Get_dtdHandler write _Set_dtdHandler;
    property errorHandler: IVBSAXErrorHandler read Get_errorHandler write _Set_errorHandler;
    property baseURL: WideString read Get_baseURL write Set_baseURL;
    property secureBaseURL: WideString read Get_secureBaseURL write Set_secureBaseURL;
  end;

// *********************************************************************//
// DispIntf :  IVBSAXXMLReaderDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {8C033CAA-6CD6-4F73-B728-4531AF74945F}
// *********************************************************************//
  IVBSAXXMLReaderDisp = dispinterface
    ['{8C033CAA-6CD6-4F73-B728-4531AF74945F}']
    function getFeature(const strName: WideString): WordBool; dispid 1282;
    procedure putFeature(const strName: WideString; fValue: WordBool); dispid 1283;
    function getProperty(const strName: WideString): OleVariant; dispid 1284;
    procedure putProperty(const strName: WideString; varValue: OleVariant); dispid 1285;
    property entityResolver: IVBSAXEntityResolver dispid 1286;
    property contentHandler: IVBSAXContentHandler dispid 1287;
    property dtdHandler: IVBSAXDTDHandler dispid 1288;
    property errorHandler: IVBSAXErrorHandler dispid 1289;
    property baseURL: WideString dispid 1290;
    property secureBaseURL: WideString dispid 1291;
    procedure parse(varInput: OleVariant); dispid 1292;
    procedure parseURL(const strURL: WideString); dispid 1293;
  end;

// *********************************************************************//
// Interface   : IVBSAXEntityResolver
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {0C05D096-F45B-4ACA-AD1A-AA0BC25518DC}
// *********************************************************************//
  IVBSAXEntityResolver = interface(IDispatch)
    ['{0C05D096-F45B-4ACA-AD1A-AA0BC25518DC}']
    function resolveEntity(var strPublicId: WideString; var strSystemId: WideString): OleVariant; safecall;
  end;

// *********************************************************************//
// DispIntf :  IVBSAXEntityResolverDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {0C05D096-F45B-4ACA-AD1A-AA0BC25518DC}
// *********************************************************************//
  IVBSAXEntityResolverDisp = dispinterface
    ['{0C05D096-F45B-4ACA-AD1A-AA0BC25518DC}']
    function resolveEntity(var strPublicId: WideString; var strSystemId: WideString): OleVariant; dispid 1319;
  end;

// *********************************************************************//
// Interface   : IVBSAXContentHandler
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {2ED7290A-4DD5-4B46-BB26-4E4155E77FAA}
// *********************************************************************//
  IVBSAXContentHandler = interface(IDispatch)
    ['{2ED7290A-4DD5-4B46-BB26-4E4155E77FAA}']
    procedure _Set_documentLocator(const Param1: IVBSAXLocator); safecall;
    procedure startDocument; safecall;
    procedure endDocument; safecall;
    procedure startPrefixMapping(var strPrefix: WideString; var strURI: WideString); safecall;
    procedure endPrefixMapping(var strPrefix: WideString); safecall;
    procedure startElement(var strNamespaceURI: WideString; var strLocalName: WideString; 
                           var strQName: WideString; const oAttributes: IVBSAXAttributes); safecall;
    procedure endElement(var strNamespaceURI: WideString; var strLocalName: WideString; 
                         var strQName: WideString); safecall;
    procedure characters(var strChars: WideString); safecall;
    procedure ignorableWhitespace(var strChars: WideString); safecall;
    procedure processingInstruction(var strTarget: WideString; var strData: WideString); safecall;
    procedure skippedEntity(var strName: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf :  IVBSAXContentHandlerDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {2ED7290A-4DD5-4B46-BB26-4E4155E77FAA}
// *********************************************************************//
  IVBSAXContentHandlerDisp = dispinterface
    ['{2ED7290A-4DD5-4B46-BB26-4E4155E77FAA}']
    procedure startDocument; dispid 1323;
    procedure endDocument; dispid 1324;
    procedure startPrefixMapping(var strPrefix: WideString; var strURI: WideString); dispid 1325;
    procedure endPrefixMapping(var strPrefix: WideString); dispid 1326;
    procedure startElement(var strNamespaceURI: WideString; var strLocalName: WideString; 
                           var strQName: WideString; const oAttributes: IVBSAXAttributes); dispid 1327;
    procedure endElement(var strNamespaceURI: WideString; var strLocalName: WideString; 
                         var strQName: WideString); dispid 1328;
    procedure characters(var strChars: WideString); dispid 1329;
    procedure ignorableWhitespace(var strChars: WideString); dispid 1330;
    procedure processingInstruction(var strTarget: WideString; var strData: WideString); dispid 1331;
    procedure skippedEntity(var strName: WideString); dispid 1332;
  end;

// *********************************************************************//
// Interface   : IVBSAXLocator
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {796E7AC5-5AA2-4EFF-ACAD-3FAAF01A3288}
// *********************************************************************//
  IVBSAXLocator = interface(IDispatch)
    ['{796E7AC5-5AA2-4EFF-ACAD-3FAAF01A3288}']
    function Get_columnNumber: SYSINT; safecall;
    function Get_lineNumber: SYSINT; safecall;
    function Get_publicId: WideString; safecall;
    function Get_systemId: WideString; safecall;
    property columnNumber: SYSINT read Get_columnNumber;
    property lineNumber: SYSINT read Get_lineNumber;
    property publicId: WideString read Get_publicId;
    property systemId: WideString read Get_systemId;
  end;

// *********************************************************************//
// DispIntf :  IVBSAXLocatorDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {796E7AC5-5AA2-4EFF-ACAD-3FAAF01A3288}
// *********************************************************************//
  IVBSAXLocatorDisp = dispinterface
    ['{796E7AC5-5AA2-4EFF-ACAD-3FAAF01A3288}']
    property columnNumber: SYSINT readonly dispid 1313;
    property lineNumber: SYSINT readonly dispid 1314;
    property publicId: WideString readonly dispid 1315;
    property systemId: WideString readonly dispid 1316;
  end;

// *********************************************************************//
// Interface   : IVBSAXAttributes
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {10DC0586-132B-4CAC-8BB3-DB00AC8B7EE0}
// *********************************************************************//
  IVBSAXAttributes = interface(IDispatch)
    ['{10DC0586-132B-4CAC-8BB3-DB00AC8B7EE0}']
    function Get_length: SYSINT; safecall;
    function getURI(nIndex: SYSINT): WideString; safecall;
    function getLocalName(nIndex: SYSINT): WideString; safecall;
    function getQName(nIndex: SYSINT): WideString; safecall;
    function getIndexFromName(const strURI: WideString; const strLocalName: WideString): SYSINT; safecall;
    function getIndexFromQName(const strQName: WideString): SYSINT; safecall;
    function getType(nIndex: SYSINT): WideString; safecall;
    function getTypeFromName(const strURI: WideString; const strLocalName: WideString): WideString; safecall;
    function getTypeFromQName(const strQName: WideString): WideString; safecall;
    function getValue(nIndex: SYSINT): WideString; safecall;
    function getValueFromName(const strURI: WideString; const strLocalName: WideString): WideString; safecall;
    function getValueFromQName(const strQName: WideString): WideString; safecall;
    property length: SYSINT read Get_length;
  end;

// *********************************************************************//
// DispIntf :  IVBSAXAttributesDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {10DC0586-132B-4CAC-8BB3-DB00AC8B7EE0}
// *********************************************************************//
  IVBSAXAttributesDisp = dispinterface
    ['{10DC0586-132B-4CAC-8BB3-DB00AC8B7EE0}']
    property length: SYSINT readonly dispid 1344;
    function getURI(nIndex: SYSINT): WideString; dispid 1345;
    function getLocalName(nIndex: SYSINT): WideString; dispid 1346;
    function getQName(nIndex: SYSINT): WideString; dispid 1347;
    function getIndexFromName(const strURI: WideString; const strLocalName: WideString): SYSINT; dispid 1348;
    function getIndexFromQName(const strQName: WideString): SYSINT; dispid 1349;
    function getType(nIndex: SYSINT): WideString; dispid 1350;
    function getTypeFromName(const strURI: WideString; const strLocalName: WideString): WideString; dispid 1351;
    function getTypeFromQName(const strQName: WideString): WideString; dispid 1352;
    function getValue(nIndex: SYSINT): WideString; dispid 1353;
    function getValueFromName(const strURI: WideString; const strLocalName: WideString): WideString; dispid 1354;
    function getValueFromQName(const strQName: WideString): WideString; dispid 1355;
  end;

// *********************************************************************//
// Interface   : IVBSAXDTDHandler
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {24FB3297-302D-4620-BA39-3A732D850558}
// *********************************************************************//
  IVBSAXDTDHandler = interface(IDispatch)
    ['{24FB3297-302D-4620-BA39-3A732D850558}']
    procedure notationDecl(var strName: WideString; var strPublicId: WideString; 
                           var strSystemId: WideString); safecall;
    procedure unparsedEntityDecl(var strName: WideString; var strPublicId: WideString; 
                                 var strSystemId: WideString; var strNotationName: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf :  IVBSAXDTDHandlerDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {24FB3297-302D-4620-BA39-3A732D850558}
// *********************************************************************//
  IVBSAXDTDHandlerDisp = dispinterface
    ['{24FB3297-302D-4620-BA39-3A732D850558}']
    procedure notationDecl(var strName: WideString; var strPublicId: WideString; 
                           var strSystemId: WideString); dispid 1335;
    procedure unparsedEntityDecl(var strName: WideString; var strPublicId: WideString; 
                                 var strSystemId: WideString; var strNotationName: WideString); dispid 1336;
  end;

// *********************************************************************//
// Interface   : IVBSAXErrorHandler
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {D963D3FE-173C-4862-9095-B92F66995F52}
// *********************************************************************//
  IVBSAXErrorHandler = interface(IDispatch)
    ['{D963D3FE-173C-4862-9095-B92F66995F52}']
    procedure error(const oLocator: IVBSAXLocator; var strErrorMessage: WideString; 
                    nErrorCode: Integer); safecall;
    procedure fatalError(const oLocator: IVBSAXLocator; var strErrorMessage: WideString; 
                         nErrorCode: Integer); safecall;
    procedure ignorableWarning(const oLocator: IVBSAXLocator; var strErrorMessage: WideString; 
                               nErrorCode: Integer); safecall;
  end;

// *********************************************************************//
// DispIntf :  IVBSAXErrorHandlerDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {D963D3FE-173C-4862-9095-B92F66995F52}
// *********************************************************************//
  IVBSAXErrorHandlerDisp = dispinterface
    ['{D963D3FE-173C-4862-9095-B92F66995F52}']
    procedure error(const oLocator: IVBSAXLocator; var strErrorMessage: WideString; 
                    nErrorCode: Integer); dispid 1339;
    procedure fatalError(const oLocator: IVBSAXLocator; var strErrorMessage: WideString; 
                         nErrorCode: Integer); dispid 1340;
    procedure ignorableWarning(const oLocator: IVBSAXLocator; var strErrorMessage: WideString; 
                               nErrorCode: Integer); dispid 1341;
  end;

// *********************************************************************//
// Interface   : IVBSAXXMLFilter
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {1299EB1B-5B88-433E-82DE-82CA75AD4E04}
// *********************************************************************//
  IVBSAXXMLFilter = interface(IDispatch)
    ['{1299EB1B-5B88-433E-82DE-82CA75AD4E04}']
    function Get_parent: IVBSAXXMLReader; safecall;
    procedure _Set_parent(const oReader: IVBSAXXMLReader); safecall;
    property parent: IVBSAXXMLReader read Get_parent write _Set_parent;
  end;

// *********************************************************************//
// DispIntf :  IVBSAXXMLFilterDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {1299EB1B-5B88-433E-82DE-82CA75AD4E04}
// *********************************************************************//
  IVBSAXXMLFilterDisp = dispinterface
    ['{1299EB1B-5B88-433E-82DE-82CA75AD4E04}']
    property parent: IVBSAXXMLReader dispid 1309;
  end;

// *********************************************************************//
// Interface   : IVBSAXLexicalHandler
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {032AAC35-8C0E-4D9D-979F-E3B702935576}
// *********************************************************************//
  IVBSAXLexicalHandler = interface(IDispatch)
    ['{032AAC35-8C0E-4D9D-979F-E3B702935576}']
    procedure startDTD(var strName: WideString; var strPublicId: WideString; 
                       var strSystemId: WideString); safecall;
    procedure endDTD; safecall;
    procedure startEntity(var strName: WideString); safecall;
    procedure endEntity(var strName: WideString); safecall;
    procedure startCDATA; safecall;
    procedure endCDATA; safecall;
    procedure comment(var strChars: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf :  IVBSAXLexicalHandlerDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {032AAC35-8C0E-4D9D-979F-E3B702935576}
// *********************************************************************//
  IVBSAXLexicalHandlerDisp = dispinterface
    ['{032AAC35-8C0E-4D9D-979F-E3B702935576}']
    procedure startDTD(var strName: WideString; var strPublicId: WideString; 
                       var strSystemId: WideString); dispid 1358;
    procedure endDTD; dispid 1359;
    procedure startEntity(var strName: WideString); dispid 1360;
    procedure endEntity(var strName: WideString); dispid 1361;
    procedure startCDATA; dispid 1362;
    procedure endCDATA; dispid 1363;
    procedure comment(var strChars: WideString); dispid 1364;
  end;

// *********************************************************************//
// Interface   : IVBSAXDeclHandler
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {E8917260-7579-4BE1-B5DD-7AFBFA6F077B}
// *********************************************************************//
  IVBSAXDeclHandler = interface(IDispatch)
    ['{E8917260-7579-4BE1-B5DD-7AFBFA6F077B}']
    procedure elementDecl(var strName: WideString; var strModel: WideString); safecall;
    procedure attributeDecl(var strElementName: WideString; var strAttributeName: WideString; 
                            var strType: WideString; var strValueDefault: WideString; 
                            var strValue: WideString); safecall;
    procedure internalEntityDecl(var strName: WideString; var strValue: WideString); safecall;
    procedure externalEntityDecl(var strName: WideString; var strPublicId: WideString; 
                                 var strSystemId: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf :  IVBSAXDeclHandlerDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {E8917260-7579-4BE1-B5DD-7AFBFA6F077B}
// *********************************************************************//
  IVBSAXDeclHandlerDisp = dispinterface
    ['{E8917260-7579-4BE1-B5DD-7AFBFA6F077B}']
    procedure elementDecl(var strName: WideString; var strModel: WideString); dispid 1367;
    procedure attributeDecl(var strElementName: WideString; var strAttributeName: WideString; 
                            var strType: WideString; var strValueDefault: WideString; 
                            var strValue: WideString); dispid 1368;
    procedure internalEntityDecl(var strName: WideString; var strValue: WideString); dispid 1369;
    procedure externalEntityDecl(var strName: WideString; var strPublicId: WideString; 
                                 var strSystemId: WideString); dispid 1370;
  end;

// *********************************************************************//
// Interface   : IMXWriter
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {4D7FF4BA-1565-4EA8-94E1-6E724A46F98D}
// *********************************************************************//
  IMXWriter = interface(IDispatch)
    ['{4D7FF4BA-1565-4EA8-94E1-6E724A46F98D}']
    procedure Set_output(varDestination: OleVariant); safecall;
    function Get_output: OleVariant; safecall;
    procedure Set_encoding(const strEncoding: WideString); safecall;
    function Get_encoding: WideString; safecall;
    procedure Set_byteOrderMark(fWriteByteOrderMark: WordBool); safecall;
    function Get_byteOrderMark: WordBool; safecall;
    procedure Set_indent(fIndentMode: WordBool); safecall;
    function Get_indent: WordBool; safecall;
    procedure Set_standalone(fValue: WordBool); safecall;
    function Get_standalone: WordBool; safecall;
    procedure Set_omitXMLDeclaration(fValue: WordBool); safecall;
    function Get_omitXMLDeclaration: WordBool; safecall;
    procedure Set_version(const strVersion: WideString); safecall;
    function Get_version: WideString; safecall;
    procedure Set_disableOutputEscaping(fValue: WordBool); safecall;
    function Get_disableOutputEscaping: WordBool; safecall;
    procedure flush; safecall;
    property output: OleVariant read Get_output write Set_output;
    property encoding: WideString read Get_encoding write Set_encoding;
    property byteOrderMark: WordBool read Get_byteOrderMark write Set_byteOrderMark;
    property indent: WordBool read Get_indent write Set_indent;
    property standalone: WordBool read Get_standalone write Set_standalone;
    property omitXMLDeclaration: WordBool read Get_omitXMLDeclaration write Set_omitXMLDeclaration;
    property version: WideString read Get_version write Set_version;
    property disableOutputEscaping: WordBool read Get_disableOutputEscaping write Set_disableOutputEscaping;
  end;

// *********************************************************************//
// DispIntf :  IMXWriterDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {4D7FF4BA-1565-4EA8-94E1-6E724A46F98D}
// *********************************************************************//
  IMXWriterDisp = dispinterface
    ['{4D7FF4BA-1565-4EA8-94E1-6E724A46F98D}']
    property output: OleVariant dispid 1385;
    property encoding: WideString dispid 1387;
    property byteOrderMark: WordBool dispid 1388;
    property indent: WordBool dispid 1389;
    property standalone: WordBool dispid 1390;
    property omitXMLDeclaration: WordBool dispid 1391;
    property version: WideString dispid 1392;
    property disableOutputEscaping: WordBool dispid 1393;
    procedure flush; dispid 1394;
  end;

// *********************************************************************//
// Interface   : IMXAttributes
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {F10D27CC-3EC0-415C-8ED8-77AB1C5E7262}
// *********************************************************************//
  IMXAttributes = interface(IDispatch)
    ['{F10D27CC-3EC0-415C-8ED8-77AB1C5E7262}']
    procedure addAttribute(const strURI: WideString; const strLocalName: WideString; 
                           const strQName: WideString; const strType: WideString; 
                           const strValue: WideString); safecall;
    procedure addAttributeFromIndex(varAtts: OleVariant; nIndex: SYSINT); safecall;
    procedure clear; safecall;
    procedure removeAttribute(nIndex: SYSINT); safecall;
    procedure setAttribute(nIndex: SYSINT; const strURI: WideString; 
                           const strLocalName: WideString; const strQName: WideString; 
                           const strType: WideString; const strValue: WideString); safecall;
    procedure setAttributes(varAtts: OleVariant); safecall;
    procedure setLocalName(nIndex: SYSINT; const strLocalName: WideString); safecall;
    procedure setQName(nIndex: SYSINT; const strQName: WideString); safecall;
    procedure setType(nIndex: SYSINT; const strType: WideString); safecall;
    procedure setURI(nIndex: SYSINT; const strURI: WideString); safecall;
    procedure setValue(nIndex: SYSINT; const strValue: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf :  IMXAttributesDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {F10D27CC-3EC0-415C-8ED8-77AB1C5E7262}
// *********************************************************************//
  IMXAttributesDisp = dispinterface
    ['{F10D27CC-3EC0-415C-8ED8-77AB1C5E7262}']
    procedure addAttribute(const strURI: WideString; const strLocalName: WideString; 
                           const strQName: WideString; const strType: WideString; 
                           const strValue: WideString); dispid 1373;
    procedure addAttributeFromIndex(varAtts: OleVariant; nIndex: SYSINT); dispid 1383;
    procedure clear; dispid 1374;
    procedure removeAttribute(nIndex: SYSINT); dispid 1375;
    procedure setAttribute(nIndex: SYSINT; const strURI: WideString; 
                           const strLocalName: WideString; const strQName: WideString; 
                           const strType: WideString; const strValue: WideString); dispid 1376;
    procedure setAttributes(varAtts: OleVariant); dispid 1377;
    procedure setLocalName(nIndex: SYSINT; const strLocalName: WideString); dispid 1378;
    procedure setQName(nIndex: SYSINT; const strQName: WideString); dispid 1379;
    procedure setType(nIndex: SYSINT; const strType: WideString); dispid 1380;
    procedure setURI(nIndex: SYSINT; const strURI: WideString); dispid 1381;
    procedure setValue(nIndex: SYSINT; const strValue: WideString); dispid 1382;
  end;

// *********************************************************************//
// Interface   : IMXReaderControl
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {808F4E35-8D5A-4FBE-8466-33A41279ED30}
// *********************************************************************//
  IMXReaderControl = interface(IDispatch)
    ['{808F4E35-8D5A-4FBE-8466-33A41279ED30}']
    procedure abort; safecall;
    procedure resume; safecall;
    procedure suspend; safecall;
  end;

// *********************************************************************//
// DispIntf :  IMXReaderControlDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {808F4E35-8D5A-4FBE-8466-33A41279ED30}
// *********************************************************************//
  IMXReaderControlDisp = dispinterface
    ['{808F4E35-8D5A-4FBE-8466-33A41279ED30}']
    procedure abort; dispid 1398;
    procedure resume; dispid 1399;
    procedure suspend; dispid 1400;
  end;

// *********************************************************************//
// Interface   : IMXSchemaDeclHandler
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {FA4BB38C-FAF9-4CCA-9302-D1DD0FE520DB}
// *********************************************************************//
  IMXSchemaDeclHandler = interface(IDispatch)
    ['{FA4BB38C-FAF9-4CCA-9302-D1DD0FE520DB}']
    procedure schemaElementDecl(const oSchemaElement: ISchemaElement); safecall;
  end;

// *********************************************************************//
// DispIntf :  IMXSchemaDeclHandlerDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {FA4BB38C-FAF9-4CCA-9302-D1DD0FE520DB}
// *********************************************************************//
  IMXSchemaDeclHandlerDisp = dispinterface
    ['{FA4BB38C-FAF9-4CCA-9302-D1DD0FE520DB}']
    procedure schemaElementDecl(const oSchemaElement: ISchemaElement); dispid 1403;
  end;

// *********************************************************************//
// Interface   : ISchemaItem
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08B3-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaItem = interface(IDispatch)
    ['{50EA08B3-DD1B-4664-9A50-C2F40F4BD79A}']
    function Get_name: WideString; safecall;
    function Get_namespaceURI: WideString; safecall;
    function Get_schema: ISchema; safecall;
    function Get_id: WideString; safecall;
    function Get_itemType: SOMITEMTYPE; safecall;
    function Get_unhandledAttributes: IVBSAXAttributes; safecall;
    function writeAnnotation(const annotationSink: IUnknown): WordBool; safecall;
    property name: WideString read Get_name;
    property namespaceURI: WideString read Get_namespaceURI;
    property schema: ISchema read Get_schema;
    property id: WideString read Get_id;
    property itemType: SOMITEMTYPE read Get_itemType;
    property unhandledAttributes: IVBSAXAttributes read Get_unhandledAttributes;
  end;

// *********************************************************************//
// DispIntf :  ISchemaItemDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08B3-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaItemDisp = dispinterface
    ['{50EA08B3-DD1B-4664-9A50-C2F40F4BD79A}']
    property name: WideString readonly dispid 1457;
    property namespaceURI: WideString readonly dispid 1459;
    property schema: ISchema readonly dispid 1467;
    property id: WideString readonly dispid 1440;
    property itemType: SOMITEMTYPE readonly dispid 1446;
    property unhandledAttributes: IVBSAXAttributes readonly dispid 1478;
    function writeAnnotation(const annotationSink: IUnknown): WordBool; dispid 1483;
  end;

// *********************************************************************//
// Interface   : ISchemaParticle
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08B5-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaParticle = interface(ISchemaItem)
    ['{50EA08B5-DD1B-4664-9A50-C2F40F4BD79A}']
    function Get_minOccurs: OleVariant; safecall;
    function Get_maxOccurs: OleVariant; safecall;
    property minOccurs: OleVariant read Get_minOccurs;
    property maxOccurs: OleVariant read Get_maxOccurs;
  end;

// *********************************************************************//
// DispIntf :  ISchemaParticleDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08B5-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaParticleDisp = dispinterface
    ['{50EA08B5-DD1B-4664-9A50-C2F40F4BD79A}']
    property minOccurs: OleVariant readonly dispid 1455;
    property maxOccurs: OleVariant readonly dispid 1451;
    property name: WideString readonly dispid 1457;
    property namespaceURI: WideString readonly dispid 1459;
    property schema: ISchema readonly dispid 1467;
    property id: WideString readonly dispid 1440;
    property itemType: SOMITEMTYPE readonly dispid 1446;
    property unhandledAttributes: IVBSAXAttributes readonly dispid 1478;
    function writeAnnotation(const annotationSink: IUnknown): WordBool; dispid 1483;
  end;

// *********************************************************************//
// Interface   : ISchemaElement
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08B7-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaElement = interface(ISchemaParticle)
    ['{50EA08B7-DD1B-4664-9A50-C2F40F4BD79A}']
    function Get_type_: ISchemaType; safecall;
    function Get_scope: ISchemaComplexType; safecall;
    function Get_defaultValue: WideString; safecall;
    function Get_fixedValue: WideString; safecall;
    function Get_isNillable: WordBool; safecall;
    function Get_identityConstraints: ISchemaItemCollection; safecall;
    function Get_substitutionGroup: ISchemaElement; safecall;
    function Get_substitutionGroupExclusions: SCHEMADERIVATIONMETHOD; safecall;
    function Get_disallowedSubstitutions: SCHEMADERIVATIONMETHOD; safecall;
    function Get_isAbstract: WordBool; safecall;
    function Get_isReference: WordBool; safecall;
    property type_: ISchemaType read Get_type_;
    property scope: ISchemaComplexType read Get_scope;
    property defaultValue: WideString read Get_defaultValue;
    property fixedValue: WideString read Get_fixedValue;
    property isNillable: WordBool read Get_isNillable;
    property identityConstraints: ISchemaItemCollection read Get_identityConstraints;
    property substitutionGroup: ISchemaElement read Get_substitutionGroup;
    property substitutionGroupExclusions: SCHEMADERIVATIONMETHOD read Get_substitutionGroupExclusions;
    property disallowedSubstitutions: SCHEMADERIVATIONMETHOD read Get_disallowedSubstitutions;
    property isAbstract: WordBool read Get_isAbstract;
    property isReference: WordBool read Get_isReference;
  end;

// *********************************************************************//
// DispIntf :  ISchemaElementDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08B7-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaElementDisp = dispinterface
    ['{50EA08B7-DD1B-4664-9A50-C2F40F4BD79A}']
    property type_: ISchemaType readonly dispid 1476;
    property scope: ISchemaComplexType readonly dispid 1469;
    property defaultValue: WideString readonly dispid 1431;
    property fixedValue: WideString readonly dispid 1438;
    property isNillable: WordBool readonly dispid 1443;
    property identityConstraints: ISchemaItemCollection readonly dispid 1441;
    property substitutionGroup: ISchemaElement readonly dispid 1471;
    property substitutionGroupExclusions: SCHEMADERIVATIONMETHOD readonly dispid 1472;
    property disallowedSubstitutions: SCHEMADERIVATIONMETHOD readonly dispid 1433;
    property isAbstract: WordBool readonly dispid 1442;
    property isReference: WordBool readonly dispid 1444;
    property minOccurs: OleVariant readonly dispid 1455;
    property maxOccurs: OleVariant readonly dispid 1451;
    property name: WideString readonly dispid 1457;
    property namespaceURI: WideString readonly dispid 1459;
    property schema: ISchema readonly dispid 1467;
    property id: WideString readonly dispid 1440;
    property itemType: SOMITEMTYPE readonly dispid 1446;
    property unhandledAttributes: IVBSAXAttributes readonly dispid 1478;
    function writeAnnotation(const annotationSink: IUnknown): WordBool; dispid 1483;
  end;

// *********************************************************************//
// Interface   : ISchema
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08B4-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchema = interface(ISchemaItem)
    ['{50EA08B4-DD1B-4664-9A50-C2F40F4BD79A}']
    function Get_targetNamespace: WideString; safecall;
    function Get_version: WideString; safecall;
    function Get_types: ISchemaItemCollection; safecall;
    function Get_elements: ISchemaItemCollection; safecall;
    function Get_attributes: ISchemaItemCollection; safecall;
    function Get_attributeGroups: ISchemaItemCollection; safecall;
    function Get_modelGroups: ISchemaItemCollection; safecall;
    function Get_notations: ISchemaItemCollection; safecall;
    function Get_schemaLocations: ISchemaStringCollection; safecall;
    property targetNamespace: WideString read Get_targetNamespace;
    property version: WideString read Get_version;
    property types: ISchemaItemCollection read Get_types;
    property elements: ISchemaItemCollection read Get_elements;
    property attributes: ISchemaItemCollection read Get_attributes;
    property attributeGroups: ISchemaItemCollection read Get_attributeGroups;
    property modelGroups: ISchemaItemCollection read Get_modelGroups;
    property notations: ISchemaItemCollection read Get_notations;
    property schemaLocations: ISchemaStringCollection read Get_schemaLocations;
  end;

// *********************************************************************//
// DispIntf :  ISchemaDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08B4-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaDisp = dispinterface
    ['{50EA08B4-DD1B-4664-9A50-C2F40F4BD79A}']
    property targetNamespace: WideString readonly dispid 1474;
    property version: WideString readonly dispid 1481;
    property types: ISchemaItemCollection readonly dispid 1477;
    property elements: ISchemaItemCollection readonly dispid 1434;
    property attributes: ISchemaItemCollection readonly dispid 1427;
    property attributeGroups: ISchemaItemCollection readonly dispid 1426;
    property modelGroups: ISchemaItemCollection readonly dispid 1456;
    property notations: ISchemaItemCollection readonly dispid 1460;
    property schemaLocations: ISchemaStringCollection readonly dispid 1468;
    property name: WideString readonly dispid 1457;
    property namespaceURI: WideString readonly dispid 1459;
    property schema: ISchema readonly dispid 1467;
    property id: WideString readonly dispid 1440;
    property itemType: SOMITEMTYPE readonly dispid 1446;
    property unhandledAttributes: IVBSAXAttributes readonly dispid 1478;
    function writeAnnotation(const annotationSink: IUnknown): WordBool; dispid 1483;
  end;

// *********************************************************************//
// Interface   : ISchemaItemCollection
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08B2-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaItemCollection = interface(IDispatch)
    ['{50EA08B2-DD1B-4664-9A50-C2F40F4BD79A}']
    function Get_item(index: Integer): ISchemaItem; safecall;
    function itemByName(const name: WideString): ISchemaItem; safecall;
    function itemByQName(const name: WideString; const namespaceURI: WideString): ISchemaItem; safecall;
    function Get_length: Integer; safecall;
    function Get__newEnum: IUnknown; safecall;
    property item[index: Integer]: ISchemaItem read Get_item; default;
    property length: Integer read Get_length;
    property _newEnum: IUnknown read Get__newEnum;
  end;

// *********************************************************************//
// DispIntf :  ISchemaItemCollectionDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08B2-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaItemCollectionDisp = dispinterface
    ['{50EA08B2-DD1B-4664-9A50-C2F40F4BD79A}']
    property item[index: Integer]: ISchemaItem readonly dispid 0; default;
    function itemByName(const name: WideString): ISchemaItem; dispid 1423;
    function itemByQName(const name: WideString; const namespaceURI: WideString): ISchemaItem; dispid 1424;
    property length: Integer readonly dispid 1447;
    property _newEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface   : ISchemaStringCollection
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08B1-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaStringCollection = interface(IDispatch)
    ['{50EA08B1-DD1B-4664-9A50-C2F40F4BD79A}']
    function Get_item(index: Integer): WideString; safecall;
    function Get_length: Integer; safecall;
    function Get__newEnum: IUnknown; safecall;
    property item[index: Integer]: WideString read Get_item; default;
    property length: Integer read Get_length;
    property _newEnum: IUnknown read Get__newEnum;
  end;

// *********************************************************************//
// DispIntf :  ISchemaStringCollectionDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08B1-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaStringCollectionDisp = dispinterface
    ['{50EA08B1-DD1B-4664-9A50-C2F40F4BD79A}']
    property item[index: Integer]: WideString readonly dispid 0; default;
    property length: Integer readonly dispid 1447;
    property _newEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface   : ISchemaType
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08B8-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaType = interface(ISchemaItem)
    ['{50EA08B8-DD1B-4664-9A50-C2F40F4BD79A}']
    function Get_baseTypes: ISchemaItemCollection; safecall;
    function Get_final: SCHEMADERIVATIONMETHOD; safecall;
    function Get_variety: SCHEMATYPEVARIETY; safecall;
    function Get_derivedBy: SCHEMADERIVATIONMETHOD; safecall;
    function isValid(const data: WideString): WordBool; safecall;
    function Get_minExclusive: WideString; safecall;
    function Get_minInclusive: WideString; safecall;
    function Get_maxExclusive: WideString; safecall;
    function Get_maxInclusive: WideString; safecall;
    function Get_totalDigits: OleVariant; safecall;
    function Get_fractionDigits: OleVariant; safecall;
    function Get_length: OleVariant; safecall;
    function Get_minLength: OleVariant; safecall;
    function Get_maxLength: OleVariant; safecall;
    function Get_enumeration: ISchemaStringCollection; safecall;
    function Get_whitespace: SCHEMAWHITESPACE; safecall;
    function Get_patterns: ISchemaStringCollection; safecall;
    property baseTypes: ISchemaItemCollection read Get_baseTypes;
    property final: SCHEMADERIVATIONMETHOD read Get_final;
    property variety: SCHEMATYPEVARIETY read Get_variety;
    property derivedBy: SCHEMADERIVATIONMETHOD read Get_derivedBy;
    property minExclusive: WideString read Get_minExclusive;
    property minInclusive: WideString read Get_minInclusive;
    property maxExclusive: WideString read Get_maxExclusive;
    property maxInclusive: WideString read Get_maxInclusive;
    property totalDigits: OleVariant read Get_totalDigits;
    property fractionDigits: OleVariant read Get_fractionDigits;
    property length: OleVariant read Get_length;
    property minLength: OleVariant read Get_minLength;
    property maxLength: OleVariant read Get_maxLength;
    property enumeration: ISchemaStringCollection read Get_enumeration;
    property whitespace: SCHEMAWHITESPACE read Get_whitespace;
    property patterns: ISchemaStringCollection read Get_patterns;
  end;

// *********************************************************************//
// DispIntf :  ISchemaTypeDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08B8-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaTypeDisp = dispinterface
    ['{50EA08B8-DD1B-4664-9A50-C2F40F4BD79A}']
    property baseTypes: ISchemaItemCollection readonly dispid 1428;
    property final: SCHEMADERIVATIONMETHOD readonly dispid 1437;
    property variety: SCHEMATYPEVARIETY readonly dispid 1480;
    property derivedBy: SCHEMADERIVATIONMETHOD readonly dispid 1432;
    function isValid(const data: WideString): WordBool; dispid 1445;
    property minExclusive: WideString readonly dispid 1452;
    property minInclusive: WideString readonly dispid 1453;
    property maxExclusive: WideString readonly dispid 1448;
    property maxInclusive: WideString readonly dispid 1449;
    property totalDigits: OleVariant readonly dispid 1475;
    property fractionDigits: OleVariant readonly dispid 1439;
    property length: OleVariant readonly dispid 1447;
    property minLength: OleVariant readonly dispid 1454;
    property maxLength: OleVariant readonly dispid 1450;
    property enumeration: ISchemaStringCollection readonly dispid 1435;
    property whitespace: SCHEMAWHITESPACE readonly dispid 1482;
    property patterns: ISchemaStringCollection readonly dispid 1462;
    property name: WideString readonly dispid 1457;
    property namespaceURI: WideString readonly dispid 1459;
    property schema: ISchema readonly dispid 1467;
    property id: WideString readonly dispid 1440;
    property itemType: SOMITEMTYPE readonly dispid 1446;
    property unhandledAttributes: IVBSAXAttributes readonly dispid 1478;
    function writeAnnotation(const annotationSink: IUnknown): WordBool; dispid 1483;
  end;

// *********************************************************************//
// Interface   : ISchemaComplexType
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08B9-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaComplexType = interface(ISchemaType)
    ['{50EA08B9-DD1B-4664-9A50-C2F40F4BD79A}']
    function Get_isAbstract: WordBool; safecall;
    function Get_anyAttribute: ISchemaAny; safecall;
    function Get_attributes: ISchemaItemCollection; safecall;
    function Get_contentType: SCHEMACONTENTTYPE; safecall;
    function Get_contentModel: ISchemaModelGroup; safecall;
    function Get_prohibitedSubstitutions: SCHEMADERIVATIONMETHOD; safecall;
    property isAbstract: WordBool read Get_isAbstract;
    property anyAttribute: ISchemaAny read Get_anyAttribute;
    property attributes: ISchemaItemCollection read Get_attributes;
    property contentType: SCHEMACONTENTTYPE read Get_contentType;
    property contentModel: ISchemaModelGroup read Get_contentModel;
    property prohibitedSubstitutions: SCHEMADERIVATIONMETHOD read Get_prohibitedSubstitutions;
  end;

// *********************************************************************//
// DispIntf :  ISchemaComplexTypeDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08B9-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaComplexTypeDisp = dispinterface
    ['{50EA08B9-DD1B-4664-9A50-C2F40F4BD79A}']
    property isAbstract: WordBool readonly dispid 1442;
    property anyAttribute: ISchemaAny readonly dispid 1425;
    property attributes: ISchemaItemCollection readonly dispid 1427;
    property contentType: SCHEMACONTENTTYPE readonly dispid 1430;
    property contentModel: ISchemaModelGroup readonly dispid 1429;
    property prohibitedSubstitutions: SCHEMADERIVATIONMETHOD readonly dispid 1464;
    property baseTypes: ISchemaItemCollection readonly dispid 1428;
    property final: SCHEMADERIVATIONMETHOD readonly dispid 1437;
    property variety: SCHEMATYPEVARIETY readonly dispid 1480;
    property derivedBy: SCHEMADERIVATIONMETHOD readonly dispid 1432;
    function isValid(const data: WideString): WordBool; dispid 1445;
    property minExclusive: WideString readonly dispid 1452;
    property minInclusive: WideString readonly dispid 1453;
    property maxExclusive: WideString readonly dispid 1448;
    property maxInclusive: WideString readonly dispid 1449;
    property totalDigits: OleVariant readonly dispid 1475;
    property fractionDigits: OleVariant readonly dispid 1439;
    property length: OleVariant readonly dispid 1447;
    property minLength: OleVariant readonly dispid 1454;
    property maxLength: OleVariant readonly dispid 1450;
    property enumeration: ISchemaStringCollection readonly dispid 1435;
    property whitespace: SCHEMAWHITESPACE readonly dispid 1482;
    property patterns: ISchemaStringCollection readonly dispid 1462;
    property name: WideString readonly dispid 1457;
    property namespaceURI: WideString readonly dispid 1459;
    property schema: ISchema readonly dispid 1467;
    property id: WideString readonly dispid 1440;
    property itemType: SOMITEMTYPE readonly dispid 1446;
    property unhandledAttributes: IVBSAXAttributes readonly dispid 1478;
    function writeAnnotation(const annotationSink: IUnknown): WordBool; dispid 1483;
  end;

// *********************************************************************//
// Interface   : ISchemaAny
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08BC-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaAny = interface(ISchemaParticle)
    ['{50EA08BC-DD1B-4664-9A50-C2F40F4BD79A}']
    function Get_namespaces: ISchemaStringCollection; safecall;
    function Get_processContents: SCHEMAPROCESSCONTENTS; safecall;
    property namespaces: ISchemaStringCollection read Get_namespaces;
    property processContents: SCHEMAPROCESSCONTENTS read Get_processContents;
  end;

// *********************************************************************//
// DispIntf :  ISchemaAnyDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08BC-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaAnyDisp = dispinterface
    ['{50EA08BC-DD1B-4664-9A50-C2F40F4BD79A}']
    property namespaces: ISchemaStringCollection readonly dispid 1458;
    property processContents: SCHEMAPROCESSCONTENTS readonly dispid 1463;
    property minOccurs: OleVariant readonly dispid 1455;
    property maxOccurs: OleVariant readonly dispid 1451;
    property name: WideString readonly dispid 1457;
    property namespaceURI: WideString readonly dispid 1459;
    property schema: ISchema readonly dispid 1467;
    property id: WideString readonly dispid 1440;
    property itemType: SOMITEMTYPE readonly dispid 1446;
    property unhandledAttributes: IVBSAXAttributes readonly dispid 1478;
    function writeAnnotation(const annotationSink: IUnknown): WordBool; dispid 1483;
  end;

// *********************************************************************//
// Interface   : ISchemaModelGroup
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08BB-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaModelGroup = interface(ISchemaParticle)
    ['{50EA08BB-DD1B-4664-9A50-C2F40F4BD79A}']
    function Get_particles: ISchemaItemCollection; safecall;
    property particles: ISchemaItemCollection read Get_particles;
  end;

// *********************************************************************//
// DispIntf :  ISchemaModelGroupDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08BB-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaModelGroupDisp = dispinterface
    ['{50EA08BB-DD1B-4664-9A50-C2F40F4BD79A}']
    property particles: ISchemaItemCollection readonly dispid 1461;
    property minOccurs: OleVariant readonly dispid 1455;
    property maxOccurs: OleVariant readonly dispid 1451;
    property name: WideString readonly dispid 1457;
    property namespaceURI: WideString readonly dispid 1459;
    property schema: ISchema readonly dispid 1467;
    property id: WideString readonly dispid 1440;
    property itemType: SOMITEMTYPE readonly dispid 1446;
    property unhandledAttributes: IVBSAXAttributes readonly dispid 1478;
    function writeAnnotation(const annotationSink: IUnknown): WordBool; dispid 1483;
  end;

// *********************************************************************//
// Interface   : IXMLDOMSchemaCollection2
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08B0-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  IXMLDOMSchemaCollection2 = interface(IXMLDOMSchemaCollection)
    ['{50EA08B0-DD1B-4664-9A50-C2F40F4BD79A}']
    procedure validate; safecall;
    procedure Set_validateOnLoad(validateOnLoad: WordBool); safecall;
    function Get_validateOnLoad: WordBool; safecall;
    function getSchema(const namespaceURI: WideString): ISchema; safecall;
    function getDeclaration(const node: IXMLDOMNode): ISchemaItem; safecall;
    property validateOnLoad: WordBool read Get_validateOnLoad write Set_validateOnLoad;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMSchemaCollection2Disp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08B0-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  IXMLDOMSchemaCollection2Disp = dispinterface
    ['{50EA08B0-DD1B-4664-9A50-C2F40F4BD79A}']
    procedure validate; dispid 1419;
    property validateOnLoad: WordBool dispid 1420;
    function getSchema(const namespaceURI: WideString): ISchema; dispid 1421;
    function getDeclaration(const node: IXMLDOMNode): ISchemaItem; dispid 1422;
    procedure add(const namespaceURI: WideString; var_: OleVariant); dispid 2;
    function get(const namespaceURI: WideString): IXMLDOMNode; dispid 3;
    procedure remove(const namespaceURI: WideString); dispid 4;
    property length: Integer readonly dispid 5;
    property namespaceURI[index: Integer]: WideString readonly dispid 0; default;
    procedure addCollection(const otherCollection: IXMLDOMSchemaCollection); dispid 6;
    property _newEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface   : ISchemaAttribute
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08B6-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaAttribute = interface(ISchemaItem)
    ['{50EA08B6-DD1B-4664-9A50-C2F40F4BD79A}']
    function Get_type_: ISchemaType; safecall;
    function Get_scope: ISchemaComplexType; safecall;
    function Get_defaultValue: WideString; safecall;
    function Get_fixedValue: WideString; safecall;
    function Get_use: SCHEMAUSE; safecall;
    function Get_isReference: WordBool; safecall;
    property type_: ISchemaType read Get_type_;
    property scope: ISchemaComplexType read Get_scope;
    property defaultValue: WideString read Get_defaultValue;
    property fixedValue: WideString read Get_fixedValue;
    property use: SCHEMAUSE read Get_use;
    property isReference: WordBool read Get_isReference;
  end;

// *********************************************************************//
// DispIntf :  ISchemaAttributeDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08B6-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaAttributeDisp = dispinterface
    ['{50EA08B6-DD1B-4664-9A50-C2F40F4BD79A}']
    property type_: ISchemaType readonly dispid 1476;
    property scope: ISchemaComplexType readonly dispid 1469;
    property defaultValue: WideString readonly dispid 1431;
    property fixedValue: WideString readonly dispid 1438;
    property use: SCHEMAUSE readonly dispid 1479;
    property isReference: WordBool readonly dispid 1444;
    property name: WideString readonly dispid 1457;
    property namespaceURI: WideString readonly dispid 1459;
    property schema: ISchema readonly dispid 1467;
    property id: WideString readonly dispid 1440;
    property itemType: SOMITEMTYPE readonly dispid 1446;
    property unhandledAttributes: IVBSAXAttributes readonly dispid 1478;
    function writeAnnotation(const annotationSink: IUnknown): WordBool; dispid 1483;
  end;

// *********************************************************************//
// Interface   : ISchemaAttributeGroup
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08BA-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaAttributeGroup = interface(ISchemaItem)
    ['{50EA08BA-DD1B-4664-9A50-C2F40F4BD79A}']
    function Get_anyAttribute: ISchemaAny; safecall;
    function Get_attributes: ISchemaItemCollection; safecall;
    property anyAttribute: ISchemaAny read Get_anyAttribute;
    property attributes: ISchemaItemCollection read Get_attributes;
  end;

// *********************************************************************//
// DispIntf :  ISchemaAttributeGroupDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08BA-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaAttributeGroupDisp = dispinterface
    ['{50EA08BA-DD1B-4664-9A50-C2F40F4BD79A}']
    property anyAttribute: ISchemaAny readonly dispid 1425;
    property attributes: ISchemaItemCollection readonly dispid 1427;
    property name: WideString readonly dispid 1457;
    property namespaceURI: WideString readonly dispid 1459;
    property schema: ISchema readonly dispid 1467;
    property id: WideString readonly dispid 1440;
    property itemType: SOMITEMTYPE readonly dispid 1446;
    property unhandledAttributes: IVBSAXAttributes readonly dispid 1478;
    function writeAnnotation(const annotationSink: IUnknown): WordBool; dispid 1483;
  end;

// *********************************************************************//
// Interface   : ISchemaIdentityConstraint
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08BD-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaIdentityConstraint = interface(ISchemaItem)
    ['{50EA08BD-DD1B-4664-9A50-C2F40F4BD79A}']
    function Get_selector: WideString; safecall;
    function Get_fields: ISchemaStringCollection; safecall;
    function Get_referencedKey: ISchemaIdentityConstraint; safecall;
    property selector: WideString read Get_selector;
    property fields: ISchemaStringCollection read Get_fields;
    property referencedKey: ISchemaIdentityConstraint read Get_referencedKey;
  end;

// *********************************************************************//
// DispIntf :  ISchemaIdentityConstraintDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08BD-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaIdentityConstraintDisp = dispinterface
    ['{50EA08BD-DD1B-4664-9A50-C2F40F4BD79A}']
    property selector: WideString readonly dispid 1470;
    property fields: ISchemaStringCollection readonly dispid 1436;
    property referencedKey: ISchemaIdentityConstraint readonly dispid 1466;
    property name: WideString readonly dispid 1457;
    property namespaceURI: WideString readonly dispid 1459;
    property schema: ISchema readonly dispid 1467;
    property id: WideString readonly dispid 1440;
    property itemType: SOMITEMTYPE readonly dispid 1446;
    property unhandledAttributes: IVBSAXAttributes readonly dispid 1478;
    function writeAnnotation(const annotationSink: IUnknown): WordBool; dispid 1483;
  end;

// *********************************************************************//
// Interface   : ISchemaNotation
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {50EA08BE-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaNotation = interface(ISchemaItem)
    ['{50EA08BE-DD1B-4664-9A50-C2F40F4BD79A}']
    function Get_systemIdentifier: WideString; safecall;
    function Get_publicIdentifier: WideString; safecall;
    property systemIdentifier: WideString read Get_systemIdentifier;
    property publicIdentifier: WideString read Get_publicIdentifier;
  end;

// *********************************************************************//
// DispIntf :  ISchemaNotationDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {50EA08BE-DD1B-4664-9A50-C2F40F4BD79A}
// *********************************************************************//
  ISchemaNotationDisp = dispinterface
    ['{50EA08BE-DD1B-4664-9A50-C2F40F4BD79A}']
    property systemIdentifier: WideString readonly dispid 1473;
    property publicIdentifier: WideString readonly dispid 1465;
    property name: WideString readonly dispid 1457;
    property namespaceURI: WideString readonly dispid 1459;
    property schema: ISchema readonly dispid 1467;
    property id: WideString readonly dispid 1440;
    property itemType: SOMITEMTYPE readonly dispid 1446;
    property unhandledAttributes: IVBSAXAttributes readonly dispid 1478;
    function writeAnnotation(const annotationSink: IUnknown): WordBool; dispid 1483;
  end;

// *********************************************************************//
// Interface   : IXMLElementCollection
// Indicateurs : (4432) Hidden Dual OleAutomation Dispatchable
// GUID        : {65725580-9B5D-11D0-9BFE-00C04FC99C8E}
// *********************************************************************//
  IXMLElementCollection = interface(IDispatch)
    ['{65725580-9B5D-11D0-9BFE-00C04FC99C8E}']
    procedure Set_length(p: Integer); safecall;
    function Get_length: Integer; safecall;
    function Get__newEnum: IUnknown; safecall;
    function item(var1: OleVariant; var2: OleVariant): IDispatch; safecall;
    property length: Integer read Get_length write Set_length;
    property _newEnum: IUnknown read Get__newEnum;
  end;

// *********************************************************************//
// DispIntf :  IXMLElementCollectionDisp
// Flags :     (4432) Hidden Dual OleAutomation Dispatchable
// GUID :      {65725580-9B5D-11D0-9BFE-00C04FC99C8E}
// *********************************************************************//
  IXMLElementCollectionDisp = dispinterface
    ['{65725580-9B5D-11D0-9BFE-00C04FC99C8E}']
    property length: Integer dispid 65537;
    property _newEnum: IUnknown readonly dispid -4;
    function item(var1: OleVariant; var2: OleVariant): IDispatch; dispid 65539;
  end;

// *********************************************************************//
// Interface   : IXMLDocument
// Indicateurs : (4432) Hidden Dual OleAutomation Dispatchable
// GUID        : {F52E2B61-18A1-11D1-B105-00805F49916B}
// *********************************************************************//
  IXMLDocument = interface(IDispatch)
    ['{F52E2B61-18A1-11D1-B105-00805F49916B}']
    function Get_root: IXMLElement; safecall;
    function Get_fileSize: WideString; safecall;
    function Get_fileModifiedDate: WideString; safecall;
    function Get_fileUpdatedDate: WideString; safecall;
    function Get_url: WideString; safecall;
    procedure Set_url(const p: WideString); safecall;
    function Get_mimeType: WideString; safecall;
    function Get_readyState: Integer; safecall;
    function Get_charset: WideString; safecall;
    procedure Set_charset(const p: WideString); safecall;
    function Get_version: WideString; safecall;
    function Get_doctype: WideString; safecall;
    function Get_dtdURL: WideString; safecall;
    function createElement(vType: OleVariant; var1: OleVariant): IXMLElement; safecall;
    property root: IXMLElement read Get_root;
    property fileSize: WideString read Get_fileSize;
    property fileModifiedDate: WideString read Get_fileModifiedDate;
    property fileUpdatedDate: WideString read Get_fileUpdatedDate;
    property url: WideString read Get_url write Set_url;
    property mimeType: WideString read Get_mimeType;
    property readyState: Integer read Get_readyState;
    property charset: WideString read Get_charset write Set_charset;
    property version: WideString read Get_version;
    property doctype: WideString read Get_doctype;
    property dtdURL: WideString read Get_dtdURL;
  end;

// *********************************************************************//
// DispIntf :  IXMLDocumentDisp
// Flags :     (4432) Hidden Dual OleAutomation Dispatchable
// GUID :      {F52E2B61-18A1-11D1-B105-00805F49916B}
// *********************************************************************//
  IXMLDocumentDisp = dispinterface
    ['{F52E2B61-18A1-11D1-B105-00805F49916B}']
    property root: IXMLElement readonly dispid 65637;
    property fileSize: WideString readonly dispid 65638;
    property fileModifiedDate: WideString readonly dispid 65639;
    property fileUpdatedDate: WideString readonly dispid 65640;
    property url: WideString dispid 65641;
    property mimeType: WideString readonly dispid 65642;
    property readyState: Integer readonly dispid 65643;
    property charset: WideString dispid 65645;
    property version: WideString readonly dispid 65646;
    property doctype: WideString readonly dispid 65647;
    property dtdURL: WideString readonly dispid 65648;
    function createElement(vType: OleVariant; var1: OleVariant): IXMLElement; dispid 65644;
  end;

// *********************************************************************//
// Interface   : IXMLElement
// Indicateurs : (4432) Hidden Dual OleAutomation Dispatchable
// GUID        : {3F7F31AC-E15F-11D0-9C25-00C04FC99C8E}
// *********************************************************************//
  IXMLElement = interface(IDispatch)
    ['{3F7F31AC-E15F-11D0-9C25-00C04FC99C8E}']
    function Get_tagName: WideString; safecall;
    procedure Set_tagName(const p: WideString); safecall;
    function Get_parent: IXMLElement; safecall;
    procedure setAttribute(const strPropertyName: WideString; PropertyValue: OleVariant); safecall;
    function getAttribute(const strPropertyName: WideString): OleVariant; safecall;
    procedure removeAttribute(const strPropertyName: WideString); safecall;
    function Get_children: IXMLElementCollection; safecall;
    function Get_type_: Integer; safecall;
    function Get_text: WideString; safecall;
    procedure Set_text(const p: WideString); safecall;
    procedure addChild(const pChildElem: IXMLElement; lIndex: Integer; lReserved: Integer); safecall;
    procedure removeChild(const pChildElem: IXMLElement); safecall;
    property tagName: WideString read Get_tagName write Set_tagName;
    property parent: IXMLElement read Get_parent;
    property children: IXMLElementCollection read Get_children;
    property type_: Integer read Get_type_;
    property text: WideString read Get_text write Set_text;
  end;

// *********************************************************************//
// DispIntf :  IXMLElementDisp
// Flags :     (4432) Hidden Dual OleAutomation Dispatchable
// GUID :      {3F7F31AC-E15F-11D0-9C25-00C04FC99C8E}
// *********************************************************************//
  IXMLElementDisp = dispinterface
    ['{3F7F31AC-E15F-11D0-9C25-00C04FC99C8E}']
    property tagName: WideString dispid 65737;
    property parent: IXMLElement readonly dispid 65738;
    procedure setAttribute(const strPropertyName: WideString; PropertyValue: OleVariant); dispid 65739;
    function getAttribute(const strPropertyName: WideString): OleVariant; dispid 65740;
    procedure removeAttribute(const strPropertyName: WideString); dispid 65741;
    property children: IXMLElementCollection readonly dispid 65742;
    property type_: Integer readonly dispid 65743;
    property text: WideString dispid 65744;
    procedure addChild(const pChildElem: IXMLElement; lIndex: Integer; lReserved: Integer); dispid 65745;
    procedure removeChild(const pChildElem: IXMLElement); dispid 65746;
  end;

// *********************************************************************//
// Interface   : IXMLDocument2
// Indicateurs : (4112) Hidden Dispatchable
// GUID        : {2B8DE2FE-8D2D-11D1-B2FC-00C04FD915A9}
// *********************************************************************//
  IXMLDocument2 = interface(IDispatch)
    ['{2B8DE2FE-8D2D-11D1-B2FC-00C04FD915A9}']
    function Get_root(out p: IXMLElement2): HResult; stdcall;
    function Get_fileSize(out p: WideString): HResult; stdcall;
    function Get_fileModifiedDate(out p: WideString): HResult; stdcall;
    function Get_fileUpdatedDate(out p: WideString): HResult; stdcall;
    function Get_url(out p: WideString): HResult; stdcall;
    function Set_url(const p: WideString): HResult; stdcall;
    function Get_mimeType(out p: WideString): HResult; stdcall;
    function Get_readyState(out pl: Integer): HResult; stdcall;
    function Get_charset(out p: WideString): HResult; stdcall;
    function Set_charset(const p: WideString): HResult; stdcall;
    function Get_version(out p: WideString): HResult; stdcall;
    function Get_doctype(out p: WideString): HResult; stdcall;
    function Get_dtdURL(out p: WideString): HResult; stdcall;
    function createElement(vType: OleVariant; var1: OleVariant; out ppElem: IXMLElement2): HResult; stdcall;
    function Get_async(out pf: WordBool): HResult; stdcall;
    function Set_async(pf: WordBool): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : IXMLElement2
// Indicateurs : (4432) Hidden Dual OleAutomation Dispatchable
// GUID        : {2B8DE2FF-8D2D-11D1-B2FC-00C04FD915A9}
// *********************************************************************//
  IXMLElement2 = interface(IDispatch)
    ['{2B8DE2FF-8D2D-11D1-B2FC-00C04FD915A9}']
    function Get_tagName: WideString; safecall;
    procedure Set_tagName(const p: WideString); safecall;
    function Get_parent: IXMLElement2; safecall;
    procedure setAttribute(const strPropertyName: WideString; PropertyValue: OleVariant); safecall;
    function getAttribute(const strPropertyName: WideString): OleVariant; safecall;
    procedure removeAttribute(const strPropertyName: WideString); safecall;
    function Get_children: IXMLElementCollection; safecall;
    function Get_type_: Integer; safecall;
    function Get_text: WideString; safecall;
    procedure Set_text(const p: WideString); safecall;
    procedure addChild(const pChildElem: IXMLElement2; lIndex: Integer; lReserved: Integer); safecall;
    procedure removeChild(const pChildElem: IXMLElement2); safecall;
    function Get_attributes: IXMLElementCollection; safecall;
    property tagName: WideString read Get_tagName write Set_tagName;
    property parent: IXMLElement2 read Get_parent;
    property children: IXMLElementCollection read Get_children;
    property type_: Integer read Get_type_;
    property text: WideString read Get_text write Set_text;
    property attributes: IXMLElementCollection read Get_attributes;
  end;

// *********************************************************************//
// DispIntf :  IXMLElement2Disp
// Flags :     (4432) Hidden Dual OleAutomation Dispatchable
// GUID :      {2B8DE2FF-8D2D-11D1-B2FC-00C04FD915A9}
// *********************************************************************//
  IXMLElement2Disp = dispinterface
    ['{2B8DE2FF-8D2D-11D1-B2FC-00C04FD915A9}']
    property tagName: WideString dispid 65737;
    property parent: IXMLElement2 readonly dispid 65738;
    procedure setAttribute(const strPropertyName: WideString; PropertyValue: OleVariant); dispid 65739;
    function getAttribute(const strPropertyName: WideString): OleVariant; dispid 65740;
    procedure removeAttribute(const strPropertyName: WideString); dispid 65741;
    property children: IXMLElementCollection readonly dispid 65742;
    property type_: Integer readonly dispid 65743;
    property text: WideString dispid 65744;
    procedure addChild(const pChildElem: IXMLElement2; lIndex: Integer; lReserved: Integer); dispid 65745;
    procedure removeChild(const pChildElem: IXMLElement2); dispid 65746;
    property attributes: IXMLElementCollection readonly dispid 65747;
  end;

// *********************************************************************//
// Interface   : IXMLAttribute
// Indicateurs : (4432) Hidden Dual OleAutomation Dispatchable
// GUID        : {D4D4A0FC-3B73-11D1-B2B4-00C04FB92596}
// *********************************************************************//
  IXMLAttribute = interface(IDispatch)
    ['{D4D4A0FC-3B73-11D1-B2B4-00C04FB92596}']
    function Get_name: WideString; safecall;
    function Get_value: WideString; safecall;
    property name: WideString read Get_name;
    property value: WideString read Get_value;
  end;

// *********************************************************************//
// DispIntf :  IXMLAttributeDisp
// Flags :     (4432) Hidden Dual OleAutomation Dispatchable
// GUID :      {D4D4A0FC-3B73-11D1-B2B4-00C04FB92596}
// *********************************************************************//
  IXMLAttributeDisp = dispinterface
    ['{D4D4A0FC-3B73-11D1-B2B4-00C04FB92596}']
    property name: WideString readonly dispid 65937;
    property value: WideString readonly dispid 65938;
  end;

// *********************************************************************//
// Interface   : IXMLError
// Indicateurs : (16) Hidden
// GUID        : {948C5AD3-C58D-11D0-9C0B-00C04FC99C8E}
// *********************************************************************//
  IXMLError = interface(IUnknown)
    ['{948C5AD3-C58D-11D0-9C0B-00C04FC99C8E}']
    function GetErrorInfo(var pErrorReturn: _xml_error): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : IXMLDOMSelection
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {AA634FC7-5888-44A7-A257-3A47150D3A0E}
// *********************************************************************//
  IXMLDOMSelection = interface(IXMLDOMNodeList)
    ['{AA634FC7-5888-44A7-A257-3A47150D3A0E}']
    function Get_expr: WideString; safecall;
    procedure Set_expr(const expression: WideString); safecall;
    function Get_context: IXMLDOMNode; safecall;
    procedure _Set_context(const ppNode: IXMLDOMNode); safecall;
    function peekNode: IXMLDOMNode; safecall;
    function matches(const pNode: IXMLDOMNode): IXMLDOMNode; safecall;
    function removeNext: IXMLDOMNode; safecall;
    procedure removeAll; safecall;
    function clone: IXMLDOMSelection; safecall;
    function getProperty(const name: WideString): OleVariant; safecall;
    procedure setProperty(const name: WideString; value: OleVariant); safecall;
    property expr: WideString read Get_expr write Set_expr;
    property context: IXMLDOMNode read Get_context write _Set_context;
  end;

// *********************************************************************//
// DispIntf :  IXMLDOMSelectionDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {AA634FC7-5888-44A7-A257-3A47150D3A0E}
// *********************************************************************//
  IXMLDOMSelectionDisp = dispinterface
    ['{AA634FC7-5888-44A7-A257-3A47150D3A0E}']
    property expr: WideString dispid 81;
    property context: IXMLDOMNode dispid 82;
    function peekNode: IXMLDOMNode; dispid 83;
    function matches(const pNode: IXMLDOMNode): IXMLDOMNode; dispid 84;
    function removeNext: IXMLDOMNode; dispid 85;
    procedure removeAll; dispid 86;
    function clone: IXMLDOMSelection; dispid 87;
    function getProperty(const name: WideString): OleVariant; dispid 88;
    procedure setProperty(const name: WideString; value: OleVariant); dispid 89;
    property item[index: Integer]: IXMLDOMNode readonly dispid 0; default;
    property length: Integer readonly dispid 74;
    function nextNode: IXMLDOMNode; dispid 76;
    procedure reset; dispid 77;
    property _newEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// DispIntf :  XMLDOMDocumentEvents
// Flags :     (4112) Hidden Dispatchable
// GUID :      {3EFAA427-272F-11D2-836F-0000F87A7782}
// *********************************************************************//
  XMLDOMDocumentEvents = dispinterface
    ['{3EFAA427-272F-11D2-836F-0000F87A7782}']
    procedure ondataavailable; dispid 198;
    procedure onreadystatechange; dispid -609;
  end;

// *********************************************************************//
// Interface   : IDSOControl
// Indicateurs : (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID        : {310AFA62-0575-11D2-9CA9-0060B0EC3D39}
// *********************************************************************//
  IDSOControl = interface(IDispatch)
    ['{310AFA62-0575-11D2-9CA9-0060B0EC3D39}']
    function Get_XMLDocument: IXMLDOMDocument; safecall;
    procedure Set_XMLDocument(const ppDoc: IXMLDOMDocument); safecall;
    function Get_JavaDSOCompatible: Integer; safecall;
    procedure Set_JavaDSOCompatible(fJavaDSOCompatible: Integer); safecall;
    function Get_readyState: Integer; safecall;
    property XMLDocument: IXMLDOMDocument read Get_XMLDocument write Set_XMLDocument;
    property JavaDSOCompatible: Integer read Get_JavaDSOCompatible write Set_JavaDSOCompatible;
    property readyState: Integer read Get_readyState;
  end;

// *********************************************************************//
// DispIntf :  IDSOControlDisp
// Flags :     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID :      {310AFA62-0575-11D2-9CA9-0060B0EC3D39}
// *********************************************************************//
  IDSOControlDisp = dispinterface
    ['{310AFA62-0575-11D2-9CA9-0060B0EC3D39}']
    property XMLDocument: IXMLDOMDocument dispid 65537;
    property JavaDSOCompatible: Integer dispid 65538;
    property readyState: Integer readonly dispid -525;
  end;

// *********************************************************************//
// Interface   : IXMLHTTPRequest
// Indicateurs : (4416) Dual OleAutomation Dispatchable
// GUID        : {ED8C108D-4349-11D2-91A4-00C04F7969E8}
// *********************************************************************//
  IXMLHTTPRequest = interface(IDispatch)
    ['{ED8C108D-4349-11D2-91A4-00C04F7969E8}']
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant; bstrPassword: OleVariant); safecall;
    procedure setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString); safecall;
    function getResponseHeader(const bstrHeader: WideString): WideString; safecall;
    function getAllResponseHeaders: WideString; safecall;
    procedure send(varBody: OleVariant); safecall;
    procedure abort; safecall;
    function Get_status: Integer; safecall;
    function Get_statusText: WideString; safecall;
    function Get_responseXML: IDispatch; safecall;
    function Get_responseText: WideString; safecall;
    function Get_responseBody: OleVariant; safecall;
    function Get_responseStream: OleVariant; safecall;
    function Get_readyState: Integer; safecall;
    procedure Set_onreadystatechange(const Param1: IDispatch); safecall;
    property status: Integer read Get_status;
    property statusText: WideString read Get_statusText;
    property responseXML: IDispatch read Get_responseXML;
    property responseText: WideString read Get_responseText;
    property responseBody: OleVariant read Get_responseBody;
    property responseStream: OleVariant read Get_responseStream;
    property readyState: Integer read Get_readyState;
    property onreadystatechange: IDispatch write Set_onreadystatechange;
  end;

// *********************************************************************//
// DispIntf :  IXMLHTTPRequestDisp
// Flags :     (4416) Dual OleAutomation Dispatchable
// GUID :      {ED8C108D-4349-11D2-91A4-00C04F7969E8}
// *********************************************************************//
  IXMLHTTPRequestDisp = dispinterface
    ['{ED8C108D-4349-11D2-91A4-00C04F7969E8}']
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant; bstrPassword: OleVariant); dispid 1;
    procedure setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString); dispid 2;
    function getResponseHeader(const bstrHeader: WideString): WideString; dispid 3;
    function getAllResponseHeaders: WideString; dispid 4;
    procedure send(varBody: OleVariant); dispid 5;
    procedure abort; dispid 6;
    property status: Integer readonly dispid 7;
    property statusText: WideString readonly dispid 8;
    property responseXML: IDispatch readonly dispid 9;
    property responseText: WideString readonly dispid 10;
    property responseBody: OleVariant readonly dispid 11;
    property responseStream: OleVariant readonly dispid 12;
    property readyState: Integer readonly dispid 13;
    property onreadystatechange: IDispatch writeonly dispid 14;
  end;

// *********************************************************************//
// Interface   : IServerXMLHTTPRequest
// Indicateurs : (4416) Dual OleAutomation Dispatchable
// GUID        : {2E9196BF-13BA-4DD4-91CA-6C571F281495}
// *********************************************************************//
  IServerXMLHTTPRequest = interface(IXMLHTTPRequest)
    ['{2E9196BF-13BA-4DD4-91CA-6C571F281495}']
    procedure setTimeouts(resolveTimeout: Integer; connectTimeout: Integer; sendTimeout: Integer; 
                          receiveTimeout: Integer); safecall;
    function waitForResponse(timeoutInSeconds: OleVariant): WordBool; safecall;
    function getOption(option: SERVERXMLHTTP_OPTION): OleVariant; safecall;
    procedure setOption(option: SERVERXMLHTTP_OPTION; value: OleVariant); safecall;
  end;

// *********************************************************************//
// DispIntf :  IServerXMLHTTPRequestDisp
// Flags :     (4416) Dual OleAutomation Dispatchable
// GUID :      {2E9196BF-13BA-4DD4-91CA-6C571F281495}
// *********************************************************************//
  IServerXMLHTTPRequestDisp = dispinterface
    ['{2E9196BF-13BA-4DD4-91CA-6C571F281495}']
    procedure setTimeouts(resolveTimeout: Integer; connectTimeout: Integer; sendTimeout: Integer; 
                          receiveTimeout: Integer); dispid 15;
    function waitForResponse(timeoutInSeconds: OleVariant): WordBool; dispid 16;
    function getOption(option: SERVERXMLHTTP_OPTION): OleVariant; dispid 17;
    procedure setOption(option: SERVERXMLHTTP_OPTION; value: OleVariant); dispid 18;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant; bstrPassword: OleVariant); dispid 1;
    procedure setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString); dispid 2;
    function getResponseHeader(const bstrHeader: WideString): WideString; dispid 3;
    function getAllResponseHeaders: WideString; dispid 4;
    procedure send(varBody: OleVariant); dispid 5;
    procedure abort; dispid 6;
    property status: Integer readonly dispid 7;
    property statusText: WideString readonly dispid 8;
    property responseXML: IDispatch readonly dispid 9;
    property responseText: WideString readonly dispid 10;
    property responseBody: OleVariant readonly dispid 11;
    property responseStream: OleVariant readonly dispid 12;
    property readyState: Integer readonly dispid 13;
    property onreadystatechange: IDispatch writeonly dispid 14;
  end;

// *********************************************************************//
// Interface   : IServerXMLHTTPRequest2
// Indicateurs : (4416) Dual OleAutomation Dispatchable
// GUID        : {2E01311B-C322-4B0A-BD77-B90CFDC8DCE7}
// *********************************************************************//
  IServerXMLHTTPRequest2 = interface(IServerXMLHTTPRequest)
    ['{2E01311B-C322-4B0A-BD77-B90CFDC8DCE7}']
    procedure setProxy(proxySetting: SXH_PROXY_SETTING; varProxyServer: OleVariant; 
                       varBypassList: OleVariant); safecall;
    procedure setProxyCredentials(const bstrUserName: WideString; const bstrPassword: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf :  IServerXMLHTTPRequest2Disp
// Flags :     (4416) Dual OleAutomation Dispatchable
// GUID :      {2E01311B-C322-4B0A-BD77-B90CFDC8DCE7}
// *********************************************************************//
  IServerXMLHTTPRequest2Disp = dispinterface
    ['{2E01311B-C322-4B0A-BD77-B90CFDC8DCE7}']
    procedure setProxy(proxySetting: SXH_PROXY_SETTING; varProxyServer: OleVariant; 
                       varBypassList: OleVariant); dispid 19;
    procedure setProxyCredentials(const bstrUserName: WideString; const bstrPassword: WideString); dispid 20;
    procedure setTimeouts(resolveTimeout: Integer; connectTimeout: Integer; sendTimeout: Integer; 
                          receiveTimeout: Integer); dispid 15;
    function waitForResponse(timeoutInSeconds: OleVariant): WordBool; dispid 16;
    function getOption(option: SERVERXMLHTTP_OPTION): OleVariant; dispid 17;
    procedure setOption(option: SERVERXMLHTTP_OPTION; value: OleVariant); dispid 18;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant; bstrPassword: OleVariant); dispid 1;
    procedure setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString); dispid 2;
    function getResponseHeader(const bstrHeader: WideString): WideString; dispid 3;
    function getAllResponseHeaders: WideString; dispid 4;
    procedure send(varBody: OleVariant); dispid 5;
    procedure abort; dispid 6;
    property status: Integer readonly dispid 7;
    property statusText: WideString readonly dispid 8;
    property responseXML: IDispatch readonly dispid 9;
    property responseText: WideString readonly dispid 10;
    property responseBody: OleVariant readonly dispid 11;
    property responseStream: OleVariant readonly dispid 12;
    property readyState: Integer readonly dispid 13;
    property onreadystatechange: IDispatch writeonly dispid 14;
  end;

// *********************************************************************//
// Interface   : IMXNamespacePrefixes
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {C90352F4-643C-4FBC-BB23-E996EB2D51FD}
// *********************************************************************//
  IMXNamespacePrefixes = interface(IDispatch)
    ['{C90352F4-643C-4FBC-BB23-E996EB2D51FD}']
    function Get_item(index: Integer): WideString; safecall;
    function Get_length: Integer; safecall;
    function Get__newEnum: IUnknown; safecall;
    property item[index: Integer]: WideString read Get_item; default;
    property length: Integer read Get_length;
    property _newEnum: IUnknown read Get__newEnum;
  end;

// *********************************************************************//
// DispIntf :  IMXNamespacePrefixesDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {C90352F4-643C-4FBC-BB23-E996EB2D51FD}
// *********************************************************************//
  IMXNamespacePrefixesDisp = dispinterface
    ['{C90352F4-643C-4FBC-BB23-E996EB2D51FD}']
    property item[index: Integer]: WideString readonly dispid 0; default;
    property length: Integer readonly dispid 1416;
    property _newEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface   : IVBMXNamespaceManager
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {C90352F5-643C-4FBC-BB23-E996EB2D51FD}
// *********************************************************************//
  IVBMXNamespaceManager = interface(IDispatch)
    ['{C90352F5-643C-4FBC-BB23-E996EB2D51FD}']
    procedure Set_allowOverride(fOverride: WordBool); safecall;
    function Get_allowOverride: WordBool; safecall;
    procedure reset; safecall;
    procedure pushContext; safecall;
    procedure pushNodeContext(const contextNode: IXMLDOMNode; fDeep: WordBool); safecall;
    procedure popContext; safecall;
    procedure declarePrefix(const prefix: WideString; const namespaceURI: WideString); safecall;
    function getDeclaredPrefixes: IMXNamespacePrefixes; safecall;
    function getPrefixes(const namespaceURI: WideString): IMXNamespacePrefixes; safecall;
    function getURI(const prefix: WideString): OleVariant; safecall;
    function getURIFromNode(const strPrefix: WideString; const contextNode: IXMLDOMNode): OleVariant; safecall;
    property allowOverride: WordBool read Get_allowOverride write Set_allowOverride;
  end;

// *********************************************************************//
// DispIntf :  IVBMXNamespaceManagerDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {C90352F5-643C-4FBC-BB23-E996EB2D51FD}
// *********************************************************************//
  IVBMXNamespaceManagerDisp = dispinterface
    ['{C90352F5-643C-4FBC-BB23-E996EB2D51FD}']
    property allowOverride: WordBool dispid 1406;
    procedure reset; dispid 1407;
    procedure pushContext; dispid 1408;
    procedure pushNodeContext(const contextNode: IXMLDOMNode; fDeep: WordBool); dispid 1409;
    procedure popContext; dispid 1410;
    procedure declarePrefix(const prefix: WideString; const namespaceURI: WideString); dispid 1411;
    function getDeclaredPrefixes: IMXNamespacePrefixes; dispid 1412;
    function getPrefixes(const namespaceURI: WideString): IMXNamespacePrefixes; dispid 1413;
    function getURI(const prefix: WideString): OleVariant; dispid 1414;
    function getURIFromNode(const strPrefix: WideString; const contextNode: IXMLDOMNode): OleVariant; dispid 1415;
  end;

// *********************************************************************//
// Interface   : IMXNamespaceManager
// Indicateurs : (16) Hidden
// GUID        : {C90352F6-643C-4FBC-BB23-E996EB2D51FD}
// *********************************************************************//
  IMXNamespaceManager = interface(IUnknown)
    ['{C90352F6-643C-4FBC-BB23-E996EB2D51FD}']
    function putAllowOverride(fOverride: WordBool): HResult; stdcall;
    function getAllowOverride(out fOverride: WordBool): HResult; stdcall;
    function reset: HResult; stdcall;
    function pushContext: HResult; stdcall;
    function pushNodeContext(const contextNode: IXMLDOMNode; fDeep: WordBool): HResult; stdcall;
    function popContext: HResult; stdcall;
    function declarePrefix(var prefix: Word; var namespaceURI: Word): HResult; stdcall;
    function getDeclaredPrefix(nIndex: Integer; var pwchPrefix: Word; var pcchPrefix: SYSINT): HResult; stdcall;
    function getPrefix(var pwszNamespaceURI: Word; nIndex: Integer; var pwchPrefix: Word; 
                       var pcchPrefix: SYSINT): HResult; stdcall;
    function getURI(var pwchPrefix: Word; const pContextNode: IXMLDOMNode; var pwchUri: Word; 
                    var pcchUri: SYSINT): HResult; stdcall;
  end;

// *********************************************************************//
// La classe CoDOMDocument fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLDOMDocument2 expos�e             
// par la CoClasse DOMDocument. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoDOMDocument = class
    class function Create: IXMLDOMDocument2;
    class function CreateRemote(const MachineName: string): IXMLDOMDocument2;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TDOMDocument
// Cha�ne d'aide        : W3C-DOM XML Document (Apartment)
// Interface par d�faut : IXMLDOMDocument2
// DISP Int. D�f. ?     : No
// Interface �v�nements : XMLDOMDocumentEvents
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDOMDocumentProperties= class;
{$ENDIF}
  TDOMDocument = class(TOleServer)
  private
    FOnondataavailable: TNotifyEvent;
    FOnonreadystatechange: TNotifyEvent;
    FIntf:        IXMLDOMDocument2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDOMDocumentProperties;
    function      GetServerProperties: TDOMDocumentProperties;
{$ENDIF}
    function      GetDefaultInterface: IXMLDOMDocument2;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLDOMDocument2);
    procedure Disconnect; override;
    function validate: IXMLDOMParseError;
    procedure setProperty(const name: WideString; value: OleVariant);
    function getProperty(const name: WideString): OleVariant;
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
    property namespaces: IXMLDOMSchemaCollection read Get_namespaces;
    property schemas: OleVariant read Get_schemas write _Set_schemas;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDOMDocumentProperties read GetServerProperties;
{$ENDIF}
    property Onondataavailable: TNotifyEvent read FOnondataavailable write FOnondataavailable;
    property Ononreadystatechange: TNotifyEvent read FOnonreadystatechange write FOnonreadystatechange;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TDOMDocument
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TDOMDocumentProperties = class(TPersistent)
  private
    FServer:    TDOMDocument;
    function    GetDefaultInterface: IXMLDOMDocument2;
    constructor Create(AServer: TDOMDocument);
  protected
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoDOMDocument26 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLDOMDocument2 expos�e             
// par la CoClasse DOMDocument26. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoDOMDocument26 = class
    class function Create: IXMLDOMDocument2;
    class function CreateRemote(const MachineName: string): IXMLDOMDocument2;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TDOMDocument26
// Cha�ne d'aide        : W3C-DOM XML Document (Apartment)
// Interface par d�faut : IXMLDOMDocument2
// DISP Int. D�f. ?     : No
// Interface �v�nements : XMLDOMDocumentEvents
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDOMDocument26Properties= class;
{$ENDIF}
  TDOMDocument26 = class(TOleServer)
  private
    FOnondataavailable: TNotifyEvent;
    FOnonreadystatechange: TNotifyEvent;
    FIntf:        IXMLDOMDocument2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDOMDocument26Properties;
    function      GetServerProperties: TDOMDocument26Properties;
{$ENDIF}
    function      GetDefaultInterface: IXMLDOMDocument2;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLDOMDocument2);
    procedure Disconnect; override;
    function validate: IXMLDOMParseError;
    procedure setProperty(const name: WideString; value: OleVariant);
    function getProperty(const name: WideString): OleVariant;
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
    property namespaces: IXMLDOMSchemaCollection read Get_namespaces;
    property schemas: OleVariant read Get_schemas write _Set_schemas;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDOMDocument26Properties read GetServerProperties;
{$ENDIF}
    property Onondataavailable: TNotifyEvent read FOnondataavailable write FOnondataavailable;
    property Ononreadystatechange: TNotifyEvent read FOnonreadystatechange write FOnonreadystatechange;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TDOMDocument26
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TDOMDocument26Properties = class(TPersistent)
  private
    FServer:    TDOMDocument26;
    function    GetDefaultInterface: IXMLDOMDocument2;
    constructor Create(AServer: TDOMDocument26);
  protected
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoDOMDocument30 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLDOMDocument2 expos�e             
// par la CoClasse DOMDocument30. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoDOMDocument30 = class
    class function Create: IXMLDOMDocument2;
    class function CreateRemote(const MachineName: string): IXMLDOMDocument2;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TDOMDocument30
// Cha�ne d'aide        : W3C-DOM XML Document (Apartment)
// Interface par d�faut : IXMLDOMDocument2
// DISP Int. D�f. ?     : No
// Interface �v�nements : XMLDOMDocumentEvents
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDOMDocument30Properties= class;
{$ENDIF}
  TDOMDocument30 = class(TOleServer)
  private
    FOnondataavailable: TNotifyEvent;
    FOnonreadystatechange: TNotifyEvent;
    FIntf:        IXMLDOMDocument2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDOMDocument30Properties;
    function      GetServerProperties: TDOMDocument30Properties;
{$ENDIF}
    function      GetDefaultInterface: IXMLDOMDocument2;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLDOMDocument2);
    procedure Disconnect; override;
    function validate: IXMLDOMParseError;
    procedure setProperty(const name: WideString; value: OleVariant);
    function getProperty(const name: WideString): OleVariant;
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
    property namespaces: IXMLDOMSchemaCollection read Get_namespaces;
    property schemas: OleVariant read Get_schemas write _Set_schemas;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDOMDocument30Properties read GetServerProperties;
{$ENDIF}
    property Onondataavailable: TNotifyEvent read FOnondataavailable write FOnondataavailable;
    property Ononreadystatechange: TNotifyEvent read FOnonreadystatechange write FOnonreadystatechange;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TDOMDocument30
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TDOMDocument30Properties = class(TPersistent)
  private
    FServer:    TDOMDocument30;
    function    GetDefaultInterface: IXMLDOMDocument2;
    constructor Create(AServer: TDOMDocument30);
  protected
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoDOMDocument40 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLDOMDocument2 expos�e             
// par la CoClasse DOMDocument40. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoDOMDocument40 = class
    class function Create: IXMLDOMDocument2;
    class function CreateRemote(const MachineName: string): IXMLDOMDocument2;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TDOMDocument40
// Cha�ne d'aide        : W3C-DOM XML Document (Apartment)
// Interface par d�faut : IXMLDOMDocument2
// DISP Int. D�f. ?     : No
// Interface �v�nements : XMLDOMDocumentEvents
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDOMDocument40Properties= class;
{$ENDIF}
  TDOMDocument40 = class(TOleServer)
  private
    FOnondataavailable: TNotifyEvent;
    FOnonreadystatechange: TNotifyEvent;
    FIntf:        IXMLDOMDocument2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDOMDocument40Properties;
    function      GetServerProperties: TDOMDocument40Properties;
{$ENDIF}
    function      GetDefaultInterface: IXMLDOMDocument2;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLDOMDocument2);
    procedure Disconnect; override;
    function validate: IXMLDOMParseError;
    procedure setProperty(const name: WideString; value: OleVariant);
    function getProperty(const name: WideString): OleVariant;
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
    property namespaces: IXMLDOMSchemaCollection read Get_namespaces;
    property schemas: OleVariant read Get_schemas write _Set_schemas;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDOMDocument40Properties read GetServerProperties;
{$ENDIF}
    property Onondataavailable: TNotifyEvent read FOnondataavailable write FOnondataavailable;
    property Ononreadystatechange: TNotifyEvent read FOnonreadystatechange write FOnonreadystatechange;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TDOMDocument40
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TDOMDocument40Properties = class(TPersistent)
  private
    FServer:    TDOMDocument40;
    function    GetDefaultInterface: IXMLDOMDocument2;
    constructor Create(AServer: TDOMDocument40);
  protected
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoFreeThreadedDOMDocument fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLDOMDocument2 expos�e             
// par la CoClasse FreeThreadedDOMDocument. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoFreeThreadedDOMDocument = class
    class function Create: IXMLDOMDocument2;
    class function CreateRemote(const MachineName: string): IXMLDOMDocument2;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TFreeThreadedDOMDocument
// Cha�ne d'aide        : W3C-DOM XML Document (Free threaded)
// Interface par d�faut : IXMLDOMDocument2
// DISP Int. D�f. ?     : No
// Interface �v�nements : XMLDOMDocumentEvents
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TFreeThreadedDOMDocumentProperties= class;
{$ENDIF}
  TFreeThreadedDOMDocument = class(TOleServer)
  private
    FOnondataavailable: TNotifyEvent;
    FOnonreadystatechange: TNotifyEvent;
    FIntf:        IXMLDOMDocument2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TFreeThreadedDOMDocumentProperties;
    function      GetServerProperties: TFreeThreadedDOMDocumentProperties;
{$ENDIF}
    function      GetDefaultInterface: IXMLDOMDocument2;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLDOMDocument2);
    procedure Disconnect; override;
    function validate: IXMLDOMParseError;
    procedure setProperty(const name: WideString; value: OleVariant);
    function getProperty(const name: WideString): OleVariant;
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
    property namespaces: IXMLDOMSchemaCollection read Get_namespaces;
    property schemas: OleVariant read Get_schemas write _Set_schemas;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TFreeThreadedDOMDocumentProperties read GetServerProperties;
{$ENDIF}
    property Onondataavailable: TNotifyEvent read FOnondataavailable write FOnondataavailable;
    property Ononreadystatechange: TNotifyEvent read FOnonreadystatechange write FOnonreadystatechange;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TFreeThreadedDOMDocument
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TFreeThreadedDOMDocumentProperties = class(TPersistent)
  private
    FServer:    TFreeThreadedDOMDocument;
    function    GetDefaultInterface: IXMLDOMDocument2;
    constructor Create(AServer: TFreeThreadedDOMDocument);
  protected
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoFreeThreadedDOMDocument26 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLDOMDocument2 expos�e             
// par la CoClasse FreeThreadedDOMDocument26. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoFreeThreadedDOMDocument26 = class
    class function Create: IXMLDOMDocument2;
    class function CreateRemote(const MachineName: string): IXMLDOMDocument2;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TFreeThreadedDOMDocument26
// Cha�ne d'aide        : W3C-DOM XML Document (Free threaded)
// Interface par d�faut : IXMLDOMDocument2
// DISP Int. D�f. ?     : No
// Interface �v�nements : XMLDOMDocumentEvents
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TFreeThreadedDOMDocument26Properties= class;
{$ENDIF}
  TFreeThreadedDOMDocument26 = class(TOleServer)
  private
    FOnondataavailable: TNotifyEvent;
    FOnonreadystatechange: TNotifyEvent;
    FIntf:        IXMLDOMDocument2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TFreeThreadedDOMDocument26Properties;
    function      GetServerProperties: TFreeThreadedDOMDocument26Properties;
{$ENDIF}
    function      GetDefaultInterface: IXMLDOMDocument2;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLDOMDocument2);
    procedure Disconnect; override;
    function validate: IXMLDOMParseError;
    procedure setProperty(const name: WideString; value: OleVariant);
    function getProperty(const name: WideString): OleVariant;
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
    property namespaces: IXMLDOMSchemaCollection read Get_namespaces;
    property schemas: OleVariant read Get_schemas write _Set_schemas;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TFreeThreadedDOMDocument26Properties read GetServerProperties;
{$ENDIF}
    property Onondataavailable: TNotifyEvent read FOnondataavailable write FOnondataavailable;
    property Ononreadystatechange: TNotifyEvent read FOnonreadystatechange write FOnonreadystatechange;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TFreeThreadedDOMDocument26
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TFreeThreadedDOMDocument26Properties = class(TPersistent)
  private
    FServer:    TFreeThreadedDOMDocument26;
    function    GetDefaultInterface: IXMLDOMDocument2;
    constructor Create(AServer: TFreeThreadedDOMDocument26);
  protected
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoFreeThreadedDOMDocument30 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLDOMDocument2 expos�e             
// par la CoClasse FreeThreadedDOMDocument30. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoFreeThreadedDOMDocument30 = class
    class function Create: IXMLDOMDocument2;
    class function CreateRemote(const MachineName: string): IXMLDOMDocument2;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TFreeThreadedDOMDocument30
// Cha�ne d'aide        : W3C-DOM XML Document (Free threaded)
// Interface par d�faut : IXMLDOMDocument2
// DISP Int. D�f. ?     : No
// Interface �v�nements : XMLDOMDocumentEvents
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TFreeThreadedDOMDocument30Properties= class;
{$ENDIF}
  TFreeThreadedDOMDocument30 = class(TOleServer)
  private
    FOnondataavailable: TNotifyEvent;
    FOnonreadystatechange: TNotifyEvent;
    FIntf:        IXMLDOMDocument2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TFreeThreadedDOMDocument30Properties;
    function      GetServerProperties: TFreeThreadedDOMDocument30Properties;
{$ENDIF}
    function      GetDefaultInterface: IXMLDOMDocument2;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLDOMDocument2);
    procedure Disconnect; override;
    function validate: IXMLDOMParseError;
    procedure setProperty(const name: WideString; value: OleVariant);
    function getProperty(const name: WideString): OleVariant;
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
    property namespaces: IXMLDOMSchemaCollection read Get_namespaces;
    property schemas: OleVariant read Get_schemas write _Set_schemas;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TFreeThreadedDOMDocument30Properties read GetServerProperties;
{$ENDIF}
    property Onondataavailable: TNotifyEvent read FOnondataavailable write FOnondataavailable;
    property Ononreadystatechange: TNotifyEvent read FOnonreadystatechange write FOnonreadystatechange;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TFreeThreadedDOMDocument30
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TFreeThreadedDOMDocument30Properties = class(TPersistent)
  private
    FServer:    TFreeThreadedDOMDocument30;
    function    GetDefaultInterface: IXMLDOMDocument2;
    constructor Create(AServer: TFreeThreadedDOMDocument30);
  protected
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoFreeThreadedDOMDocument40 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLDOMDocument2 expos�e             
// par la CoClasse FreeThreadedDOMDocument40. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoFreeThreadedDOMDocument40 = class
    class function Create: IXMLDOMDocument2;
    class function CreateRemote(const MachineName: string): IXMLDOMDocument2;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TFreeThreadedDOMDocument40
// Cha�ne d'aide        : W3C-DOM XML Document (Free threaded)
// Interface par d�faut : IXMLDOMDocument2
// DISP Int. D�f. ?     : No
// Interface �v�nements : XMLDOMDocumentEvents
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TFreeThreadedDOMDocument40Properties= class;
{$ENDIF}
  TFreeThreadedDOMDocument40 = class(TOleServer)
  private
    FOnondataavailable: TNotifyEvent;
    FOnonreadystatechange: TNotifyEvent;
    FIntf:        IXMLDOMDocument2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TFreeThreadedDOMDocument40Properties;
    function      GetServerProperties: TFreeThreadedDOMDocument40Properties;
{$ENDIF}
    function      GetDefaultInterface: IXMLDOMDocument2;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLDOMDocument2);
    procedure Disconnect; override;
    function validate: IXMLDOMParseError;
    procedure setProperty(const name: WideString; value: OleVariant);
    function getProperty(const name: WideString): OleVariant;
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
    property namespaces: IXMLDOMSchemaCollection read Get_namespaces;
    property schemas: OleVariant read Get_schemas write _Set_schemas;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TFreeThreadedDOMDocument40Properties read GetServerProperties;
{$ENDIF}
    property Onondataavailable: TNotifyEvent read FOnondataavailable write FOnondataavailable;
    property Ononreadystatechange: TNotifyEvent read FOnonreadystatechange write FOnonreadystatechange;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TFreeThreadedDOMDocument40
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TFreeThreadedDOMDocument40Properties = class(TPersistent)
  private
    FServer:    TFreeThreadedDOMDocument40;
    function    GetDefaultInterface: IXMLDOMDocument2;
    constructor Create(AServer: TFreeThreadedDOMDocument40);
  protected
    function Get_namespaces: IXMLDOMSchemaCollection;
    function Get_schemas: OleVariant;
    procedure _Set_schemas(otherCollection: OleVariant);
  public
    property DefaultInterface: IXMLDOMDocument2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoXMLSchemaCache fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLDOMSchemaCollection expos�e             
// par la CoClasse XMLSchemaCache. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoXMLSchemaCache = class
    class function Create: IXMLDOMSchemaCollection;
    class function CreateRemote(const MachineName: string): IXMLDOMSchemaCollection;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TXMLSchemaCache
// Cha�ne d'aide        : object for caching schemas
// Interface par d�faut : IXMLDOMSchemaCollection
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TXMLSchemaCacheProperties= class;
{$ENDIF}
  TXMLSchemaCache = class(TOleServer)
  private
    FIntf:        IXMLDOMSchemaCollection;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TXMLSchemaCacheProperties;
    function      GetServerProperties: TXMLSchemaCacheProperties;
{$ENDIF}
    function      GetDefaultInterface: IXMLDOMSchemaCollection;
  protected
    procedure InitServerData; override;
    function Get_length: Integer;
    function Get_namespaceURI(index: Integer): WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLDOMSchemaCollection);
    procedure Disconnect; override;
    procedure add(const namespaceURI: WideString; var_: OleVariant);
    function get(const namespaceURI: WideString): IXMLDOMNode;
    procedure remove(const namespaceURI: WideString);
    procedure addCollection(const otherCollection: IXMLDOMSchemaCollection);
    property DefaultInterface: IXMLDOMSchemaCollection read GetDefaultInterface;
    property length: Integer read Get_length;
    property namespaceURI[index: Integer]: WideString read Get_namespaceURI; default;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TXMLSchemaCacheProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TXMLSchemaCache
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TXMLSchemaCacheProperties = class(TPersistent)
  private
    FServer:    TXMLSchemaCache;
    function    GetDefaultInterface: IXMLDOMSchemaCollection;
    constructor Create(AServer: TXMLSchemaCache);
  protected
    function Get_length: Integer;
    function Get_namespaceURI(index: Integer): WideString;
  public
    property DefaultInterface: IXMLDOMSchemaCollection read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoXMLSchemaCache26 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLDOMSchemaCollection expos�e             
// par la CoClasse XMLSchemaCache26. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoXMLSchemaCache26 = class
    class function Create: IXMLDOMSchemaCollection;
    class function CreateRemote(const MachineName: string): IXMLDOMSchemaCollection;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TXMLSchemaCache26
// Cha�ne d'aide        : object for caching schemas
// Interface par d�faut : IXMLDOMSchemaCollection
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TXMLSchemaCache26Properties= class;
{$ENDIF}
  TXMLSchemaCache26 = class(TOleServer)
  private
    FIntf:        IXMLDOMSchemaCollection;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TXMLSchemaCache26Properties;
    function      GetServerProperties: TXMLSchemaCache26Properties;
{$ENDIF}
    function      GetDefaultInterface: IXMLDOMSchemaCollection;
  protected
    procedure InitServerData; override;
    function Get_length: Integer;
    function Get_namespaceURI(index: Integer): WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLDOMSchemaCollection);
    procedure Disconnect; override;
    procedure add(const namespaceURI: WideString; var_: OleVariant);
    function get(const namespaceURI: WideString): IXMLDOMNode;
    procedure remove(const namespaceURI: WideString);
    procedure addCollection(const otherCollection: IXMLDOMSchemaCollection);
    property DefaultInterface: IXMLDOMSchemaCollection read GetDefaultInterface;
    property length: Integer read Get_length;
    property namespaceURI[index: Integer]: WideString read Get_namespaceURI; default;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TXMLSchemaCache26Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TXMLSchemaCache26
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TXMLSchemaCache26Properties = class(TPersistent)
  private
    FServer:    TXMLSchemaCache26;
    function    GetDefaultInterface: IXMLDOMSchemaCollection;
    constructor Create(AServer: TXMLSchemaCache26);
  protected
    function Get_length: Integer;
    function Get_namespaceURI(index: Integer): WideString;
  public
    property DefaultInterface: IXMLDOMSchemaCollection read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoXMLSchemaCache30 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLDOMSchemaCollection expos�e             
// par la CoClasse XMLSchemaCache30. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoXMLSchemaCache30 = class
    class function Create: IXMLDOMSchemaCollection;
    class function CreateRemote(const MachineName: string): IXMLDOMSchemaCollection;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TXMLSchemaCache30
// Cha�ne d'aide        : object for caching schemas
// Interface par d�faut : IXMLDOMSchemaCollection
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TXMLSchemaCache30Properties= class;
{$ENDIF}
  TXMLSchemaCache30 = class(TOleServer)
  private
    FIntf:        IXMLDOMSchemaCollection;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TXMLSchemaCache30Properties;
    function      GetServerProperties: TXMLSchemaCache30Properties;
{$ENDIF}
    function      GetDefaultInterface: IXMLDOMSchemaCollection;
  protected
    procedure InitServerData; override;
    function Get_length: Integer;
    function Get_namespaceURI(index: Integer): WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLDOMSchemaCollection);
    procedure Disconnect; override;
    procedure add(const namespaceURI: WideString; var_: OleVariant);
    function get(const namespaceURI: WideString): IXMLDOMNode;
    procedure remove(const namespaceURI: WideString);
    procedure addCollection(const otherCollection: IXMLDOMSchemaCollection);
    property DefaultInterface: IXMLDOMSchemaCollection read GetDefaultInterface;
    property length: Integer read Get_length;
    property namespaceURI[index: Integer]: WideString read Get_namespaceURI; default;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TXMLSchemaCache30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TXMLSchemaCache30
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TXMLSchemaCache30Properties = class(TPersistent)
  private
    FServer:    TXMLSchemaCache30;
    function    GetDefaultInterface: IXMLDOMSchemaCollection;
    constructor Create(AServer: TXMLSchemaCache30);
  protected
    function Get_length: Integer;
    function Get_namespaceURI(index: Integer): WideString;
  public
    property DefaultInterface: IXMLDOMSchemaCollection read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoXMLSchemaCache40 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLDOMSchemaCollection2 expos�e             
// par la CoClasse XMLSchemaCache40. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoXMLSchemaCache40 = class
    class function Create: IXMLDOMSchemaCollection2;
    class function CreateRemote(const MachineName: string): IXMLDOMSchemaCollection2;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TXMLSchemaCache40
// Cha�ne d'aide        : object for caching schemas
// Interface par d�faut : IXMLDOMSchemaCollection2
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TXMLSchemaCache40Properties= class;
{$ENDIF}
  TXMLSchemaCache40 = class(TOleServer)
  private
    FIntf:        IXMLDOMSchemaCollection2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TXMLSchemaCache40Properties;
    function      GetServerProperties: TXMLSchemaCache40Properties;
{$ENDIF}
    function      GetDefaultInterface: IXMLDOMSchemaCollection2;
  protected
    procedure InitServerData; override;
    procedure Set_validateOnLoad(validateOnLoad: WordBool);
    function Get_validateOnLoad: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLDOMSchemaCollection2);
    procedure Disconnect; override;
    procedure validate;
    function getSchema(const namespaceURI: WideString): ISchema;
    function getDeclaration(const node: IXMLDOMNode): ISchemaItem;
    property DefaultInterface: IXMLDOMSchemaCollection2 read GetDefaultInterface;
    property validateOnLoad: WordBool read Get_validateOnLoad write Set_validateOnLoad;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TXMLSchemaCache40Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TXMLSchemaCache40
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TXMLSchemaCache40Properties = class(TPersistent)
  private
    FServer:    TXMLSchemaCache40;
    function    GetDefaultInterface: IXMLDOMSchemaCollection2;
    constructor Create(AServer: TXMLSchemaCache40);
  protected
    procedure Set_validateOnLoad(validateOnLoad: WordBool);
    function Get_validateOnLoad: WordBool;
  public
    property DefaultInterface: IXMLDOMSchemaCollection2 read GetDefaultInterface;
  published
    property validateOnLoad: WordBool read Get_validateOnLoad write Set_validateOnLoad;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoXSLTemplate fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXSLTemplate expos�e             
// par la CoClasse XSLTemplate. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoXSLTemplate = class
    class function Create: IXSLTemplate;
    class function CreateRemote(const MachineName: string): IXSLTemplate;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TXSLTemplate
// Cha�ne d'aide        : object for caching compiled XSL stylesheets
// Interface par d�faut : IXSLTemplate
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TXSLTemplateProperties= class;
{$ENDIF}
  TXSLTemplate = class(TOleServer)
  private
    FIntf:        IXSLTemplate;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TXSLTemplateProperties;
    function      GetServerProperties: TXSLTemplateProperties;
{$ENDIF}
    function      GetDefaultInterface: IXSLTemplate;
  protected
    procedure InitServerData; override;
    procedure _Set_stylesheet(const stylesheet: IXMLDOMNode);
    function Get_stylesheet: IXMLDOMNode;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXSLTemplate);
    procedure Disconnect; override;
    function createProcessor: IXSLProcessor;
    property DefaultInterface: IXSLTemplate read GetDefaultInterface;
    property stylesheet: IXMLDOMNode read Get_stylesheet write _Set_stylesheet;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TXSLTemplateProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TXSLTemplate
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TXSLTemplateProperties = class(TPersistent)
  private
    FServer:    TXSLTemplate;
    function    GetDefaultInterface: IXSLTemplate;
    constructor Create(AServer: TXSLTemplate);
  protected
    procedure _Set_stylesheet(const stylesheet: IXMLDOMNode);
    function Get_stylesheet: IXMLDOMNode;
  public
    property DefaultInterface: IXSLTemplate read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoXSLTemplate26 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXSLTemplate expos�e             
// par la CoClasse XSLTemplate26. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoXSLTemplate26 = class
    class function Create: IXSLTemplate;
    class function CreateRemote(const MachineName: string): IXSLTemplate;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TXSLTemplate26
// Cha�ne d'aide        : object for caching compiled XSL stylesheets
// Interface par d�faut : IXSLTemplate
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TXSLTemplate26Properties= class;
{$ENDIF}
  TXSLTemplate26 = class(TOleServer)
  private
    FIntf:        IXSLTemplate;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TXSLTemplate26Properties;
    function      GetServerProperties: TXSLTemplate26Properties;
{$ENDIF}
    function      GetDefaultInterface: IXSLTemplate;
  protected
    procedure InitServerData; override;
    procedure _Set_stylesheet(const stylesheet: IXMLDOMNode);
    function Get_stylesheet: IXMLDOMNode;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXSLTemplate);
    procedure Disconnect; override;
    function createProcessor: IXSLProcessor;
    property DefaultInterface: IXSLTemplate read GetDefaultInterface;
    property stylesheet: IXMLDOMNode read Get_stylesheet write _Set_stylesheet;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TXSLTemplate26Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TXSLTemplate26
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TXSLTemplate26Properties = class(TPersistent)
  private
    FServer:    TXSLTemplate26;
    function    GetDefaultInterface: IXSLTemplate;
    constructor Create(AServer: TXSLTemplate26);
  protected
    procedure _Set_stylesheet(const stylesheet: IXMLDOMNode);
    function Get_stylesheet: IXMLDOMNode;
  public
    property DefaultInterface: IXSLTemplate read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoXSLTemplate30 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXSLTemplate expos�e             
// par la CoClasse XSLTemplate30. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoXSLTemplate30 = class
    class function Create: IXSLTemplate;
    class function CreateRemote(const MachineName: string): IXSLTemplate;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TXSLTemplate30
// Cha�ne d'aide        : object for caching compiled XSL stylesheets
// Interface par d�faut : IXSLTemplate
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TXSLTemplate30Properties= class;
{$ENDIF}
  TXSLTemplate30 = class(TOleServer)
  private
    FIntf:        IXSLTemplate;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TXSLTemplate30Properties;
    function      GetServerProperties: TXSLTemplate30Properties;
{$ENDIF}
    function      GetDefaultInterface: IXSLTemplate;
  protected
    procedure InitServerData; override;
    procedure _Set_stylesheet(const stylesheet: IXMLDOMNode);
    function Get_stylesheet: IXMLDOMNode;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXSLTemplate);
    procedure Disconnect; override;
    function createProcessor: IXSLProcessor;
    property DefaultInterface: IXSLTemplate read GetDefaultInterface;
    property stylesheet: IXMLDOMNode read Get_stylesheet write _Set_stylesheet;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TXSLTemplate30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TXSLTemplate30
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TXSLTemplate30Properties = class(TPersistent)
  private
    FServer:    TXSLTemplate30;
    function    GetDefaultInterface: IXSLTemplate;
    constructor Create(AServer: TXSLTemplate30);
  protected
    procedure _Set_stylesheet(const stylesheet: IXMLDOMNode);
    function Get_stylesheet: IXMLDOMNode;
  public
    property DefaultInterface: IXSLTemplate read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoXSLTemplate40 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXSLTemplate expos�e             
// par la CoClasse XSLTemplate40. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoXSLTemplate40 = class
    class function Create: IXSLTemplate;
    class function CreateRemote(const MachineName: string): IXSLTemplate;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TXSLTemplate40
// Cha�ne d'aide        : object for caching compiled XSL stylesheets
// Interface par d�faut : IXSLTemplate
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TXSLTemplate40Properties= class;
{$ENDIF}
  TXSLTemplate40 = class(TOleServer)
  private
    FIntf:        IXSLTemplate;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TXSLTemplate40Properties;
    function      GetServerProperties: TXSLTemplate40Properties;
{$ENDIF}
    function      GetDefaultInterface: IXSLTemplate;
  protected
    procedure InitServerData; override;
    procedure _Set_stylesheet(const stylesheet: IXMLDOMNode);
    function Get_stylesheet: IXMLDOMNode;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXSLTemplate);
    procedure Disconnect; override;
    function createProcessor: IXSLProcessor;
    property DefaultInterface: IXSLTemplate read GetDefaultInterface;
    property stylesheet: IXMLDOMNode read Get_stylesheet write _Set_stylesheet;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TXSLTemplate40Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TXSLTemplate40
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TXSLTemplate40Properties = class(TPersistent)
  private
    FServer:    TXSLTemplate40;
    function    GetDefaultInterface: IXSLTemplate;
    constructor Create(AServer: TXSLTemplate40);
  protected
    procedure _Set_stylesheet(const stylesheet: IXMLDOMNode);
    function Get_stylesheet: IXMLDOMNode;
  public
    property DefaultInterface: IXSLTemplate read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoDSOControl fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IDSOControl expos�e             
// par la CoClasse DSOControl. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoDSOControl = class
    class function Create: IDSOControl;
    class function CreateRemote(const MachineName: string): IDSOControl;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TDSOControl
// Cha�ne d'aide        : XML Data Source Object
// Interface par d�faut : IDSOControl
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDSOControlProperties= class;
{$ENDIF}
  TDSOControl = class(TOleServer)
  private
    FIntf:        IDSOControl;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDSOControlProperties;
    function      GetServerProperties: TDSOControlProperties;
{$ENDIF}
    function      GetDefaultInterface: IDSOControl;
  protected
    procedure InitServerData; override;
    function Get_XMLDocument: IXMLDOMDocument;
    procedure Set_XMLDocument(const ppDoc: IXMLDOMDocument);
    function Get_JavaDSOCompatible: Integer;
    procedure Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
    function Get_readyState: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDSOControl);
    procedure Disconnect; override;
    property DefaultInterface: IDSOControl read GetDefaultInterface;
    property readyState: Integer read Get_readyState;
    property XMLDocument: IXMLDOMDocument read Get_XMLDocument write Set_XMLDocument;
    property JavaDSOCompatible: Integer read Get_JavaDSOCompatible write Set_JavaDSOCompatible;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDSOControlProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TDSOControl
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TDSOControlProperties = class(TPersistent)
  private
    FServer:    TDSOControl;
    function    GetDefaultInterface: IDSOControl;
    constructor Create(AServer: TDSOControl);
  protected
    function Get_XMLDocument: IXMLDOMDocument;
    procedure Set_XMLDocument(const ppDoc: IXMLDOMDocument);
    function Get_JavaDSOCompatible: Integer;
    procedure Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
    function Get_readyState: Integer;
  public
    property DefaultInterface: IDSOControl read GetDefaultInterface;
  published
    property XMLDocument: IXMLDOMDocument read Get_XMLDocument write Set_XMLDocument;
    property JavaDSOCompatible: Integer read Get_JavaDSOCompatible write Set_JavaDSOCompatible;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoDSOControl26 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IDSOControl expos�e             
// par la CoClasse DSOControl26. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoDSOControl26 = class
    class function Create: IDSOControl;
    class function CreateRemote(const MachineName: string): IDSOControl;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TDSOControl26
// Cha�ne d'aide        : XML Data Source Object
// Interface par d�faut : IDSOControl
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDSOControl26Properties= class;
{$ENDIF}
  TDSOControl26 = class(TOleServer)
  private
    FIntf:        IDSOControl;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDSOControl26Properties;
    function      GetServerProperties: TDSOControl26Properties;
{$ENDIF}
    function      GetDefaultInterface: IDSOControl;
  protected
    procedure InitServerData; override;
    function Get_XMLDocument: IXMLDOMDocument;
    procedure Set_XMLDocument(const ppDoc: IXMLDOMDocument);
    function Get_JavaDSOCompatible: Integer;
    procedure Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
    function Get_readyState: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDSOControl);
    procedure Disconnect; override;
    property DefaultInterface: IDSOControl read GetDefaultInterface;
    property readyState: Integer read Get_readyState;
    property XMLDocument: IXMLDOMDocument read Get_XMLDocument write Set_XMLDocument;
    property JavaDSOCompatible: Integer read Get_JavaDSOCompatible write Set_JavaDSOCompatible;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDSOControl26Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TDSOControl26
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TDSOControl26Properties = class(TPersistent)
  private
    FServer:    TDSOControl26;
    function    GetDefaultInterface: IDSOControl;
    constructor Create(AServer: TDSOControl26);
  protected
    function Get_XMLDocument: IXMLDOMDocument;
    procedure Set_XMLDocument(const ppDoc: IXMLDOMDocument);
    function Get_JavaDSOCompatible: Integer;
    procedure Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
    function Get_readyState: Integer;
  public
    property DefaultInterface: IDSOControl read GetDefaultInterface;
  published
    property XMLDocument: IXMLDOMDocument read Get_XMLDocument write Set_XMLDocument;
    property JavaDSOCompatible: Integer read Get_JavaDSOCompatible write Set_JavaDSOCompatible;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoDSOControl30 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IDSOControl expos�e             
// par la CoClasse DSOControl30. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoDSOControl30 = class
    class function Create: IDSOControl;
    class function CreateRemote(const MachineName: string): IDSOControl;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TDSOControl30
// Cha�ne d'aide        : XML Data Source Object
// Interface par d�faut : IDSOControl
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDSOControl30Properties= class;
{$ENDIF}
  TDSOControl30 = class(TOleServer)
  private
    FIntf:        IDSOControl;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDSOControl30Properties;
    function      GetServerProperties: TDSOControl30Properties;
{$ENDIF}
    function      GetDefaultInterface: IDSOControl;
  protected
    procedure InitServerData; override;
    function Get_XMLDocument: IXMLDOMDocument;
    procedure Set_XMLDocument(const ppDoc: IXMLDOMDocument);
    function Get_JavaDSOCompatible: Integer;
    procedure Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
    function Get_readyState: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDSOControl);
    procedure Disconnect; override;
    property DefaultInterface: IDSOControl read GetDefaultInterface;
    property readyState: Integer read Get_readyState;
    property XMLDocument: IXMLDOMDocument read Get_XMLDocument write Set_XMLDocument;
    property JavaDSOCompatible: Integer read Get_JavaDSOCompatible write Set_JavaDSOCompatible;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDSOControl30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TDSOControl30
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TDSOControl30Properties = class(TPersistent)
  private
    FServer:    TDSOControl30;
    function    GetDefaultInterface: IDSOControl;
    constructor Create(AServer: TDSOControl30);
  protected
    function Get_XMLDocument: IXMLDOMDocument;
    procedure Set_XMLDocument(const ppDoc: IXMLDOMDocument);
    function Get_JavaDSOCompatible: Integer;
    procedure Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
    function Get_readyState: Integer;
  public
    property DefaultInterface: IDSOControl read GetDefaultInterface;
  published
    property XMLDocument: IXMLDOMDocument read Get_XMLDocument write Set_XMLDocument;
    property JavaDSOCompatible: Integer read Get_JavaDSOCompatible write Set_JavaDSOCompatible;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoDSOControl40 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IDSOControl expos�e             
// par la CoClasse DSOControl40. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoDSOControl40 = class
    class function Create: IDSOControl;
    class function CreateRemote(const MachineName: string): IDSOControl;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TDSOControl40
// Cha�ne d'aide        : XML Data Source Object
// Interface par d�faut : IDSOControl
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDSOControl40Properties= class;
{$ENDIF}
  TDSOControl40 = class(TOleServer)
  private
    FIntf:        IDSOControl;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDSOControl40Properties;
    function      GetServerProperties: TDSOControl40Properties;
{$ENDIF}
    function      GetDefaultInterface: IDSOControl;
  protected
    procedure InitServerData; override;
    function Get_XMLDocument: IXMLDOMDocument;
    procedure Set_XMLDocument(const ppDoc: IXMLDOMDocument);
    function Get_JavaDSOCompatible: Integer;
    procedure Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
    function Get_readyState: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDSOControl);
    procedure Disconnect; override;
    property DefaultInterface: IDSOControl read GetDefaultInterface;
    property readyState: Integer read Get_readyState;
    property XMLDocument: IXMLDOMDocument read Get_XMLDocument write Set_XMLDocument;
    property JavaDSOCompatible: Integer read Get_JavaDSOCompatible write Set_JavaDSOCompatible;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDSOControl40Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TDSOControl40
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TDSOControl40Properties = class(TPersistent)
  private
    FServer:    TDSOControl40;
    function    GetDefaultInterface: IDSOControl;
    constructor Create(AServer: TDSOControl40);
  protected
    function Get_XMLDocument: IXMLDOMDocument;
    procedure Set_XMLDocument(const ppDoc: IXMLDOMDocument);
    function Get_JavaDSOCompatible: Integer;
    procedure Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
    function Get_readyState: Integer;
  public
    property DefaultInterface: IDSOControl read GetDefaultInterface;
  published
    property XMLDocument: IXMLDOMDocument read Get_XMLDocument write Set_XMLDocument;
    property JavaDSOCompatible: Integer read Get_JavaDSOCompatible write Set_JavaDSOCompatible;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoXMLHTTP fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLHTTPRequest expos�e             
// par la CoClasse XMLHTTP. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoXMLHTTP = class
    class function Create: IXMLHTTPRequest;
    class function CreateRemote(const MachineName: string): IXMLHTTPRequest;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TXMLHTTP
// Cha�ne d'aide        : XML HTTP Request class.
// Interface par d�faut : IXMLHTTPRequest
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TXMLHTTPProperties= class;
{$ENDIF}
  TXMLHTTP = class(TOleServer)
  private
    FIntf:        IXMLHTTPRequest;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TXMLHTTPProperties;
    function      GetServerProperties: TXMLHTTPProperties;
{$ENDIF}
    function      GetDefaultInterface: IXMLHTTPRequest;
  protected
    procedure InitServerData; override;
    function Get_status: Integer;
    function Get_statusText: WideString;
    function Get_responseXML: IDispatch;
    function Get_responseText: WideString;
    function Get_responseBody: OleVariant;
    function Get_responseStream: OleVariant;
    function Get_readyState: Integer;
    procedure Set_onreadystatechange(const Param1: IDispatch);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLHTTPRequest);
    procedure Disconnect; override;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant; bstrPassword: OleVariant); overload;
    procedure setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString);
    function getResponseHeader(const bstrHeader: WideString): WideString;
    function getAllResponseHeaders: WideString;
    procedure send; overload;
    procedure send(varBody: OleVariant); overload;
    procedure abort;
    property DefaultInterface: IXMLHTTPRequest read GetDefaultInterface;
    property status: Integer read Get_status;
    property statusText: WideString read Get_statusText;
    property responseXML: IDispatch read Get_responseXML;
    property responseText: WideString read Get_responseText;
    property responseBody: OleVariant read Get_responseBody;
    property responseStream: OleVariant read Get_responseStream;
    property readyState: Integer read Get_readyState;
    property onreadystatechange: IDispatch write Set_onreadystatechange;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TXMLHTTPProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TXMLHTTP
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TXMLHTTPProperties = class(TPersistent)
  private
    FServer:    TXMLHTTP;
    function    GetDefaultInterface: IXMLHTTPRequest;
    constructor Create(AServer: TXMLHTTP);
  protected
    function Get_status: Integer;
    function Get_statusText: WideString;
    function Get_responseXML: IDispatch;
    function Get_responseText: WideString;
    function Get_responseBody: OleVariant;
    function Get_responseStream: OleVariant;
    function Get_readyState: Integer;
    procedure Set_onreadystatechange(const Param1: IDispatch);
  public
    property DefaultInterface: IXMLHTTPRequest read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoXMLHTTP26 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLHTTPRequest expos�e             
// par la CoClasse XMLHTTP26. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoXMLHTTP26 = class
    class function Create: IXMLHTTPRequest;
    class function CreateRemote(const MachineName: string): IXMLHTTPRequest;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TXMLHTTP26
// Cha�ne d'aide        : XML HTTP Request class.
// Interface par d�faut : IXMLHTTPRequest
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TXMLHTTP26Properties= class;
{$ENDIF}
  TXMLHTTP26 = class(TOleServer)
  private
    FIntf:        IXMLHTTPRequest;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TXMLHTTP26Properties;
    function      GetServerProperties: TXMLHTTP26Properties;
{$ENDIF}
    function      GetDefaultInterface: IXMLHTTPRequest;
  protected
    procedure InitServerData; override;
    function Get_status: Integer;
    function Get_statusText: WideString;
    function Get_responseXML: IDispatch;
    function Get_responseText: WideString;
    function Get_responseBody: OleVariant;
    function Get_responseStream: OleVariant;
    function Get_readyState: Integer;
    procedure Set_onreadystatechange(const Param1: IDispatch);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLHTTPRequest);
    procedure Disconnect; override;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant; bstrPassword: OleVariant); overload;
    procedure setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString);
    function getResponseHeader(const bstrHeader: WideString): WideString;
    function getAllResponseHeaders: WideString;
    procedure send; overload;
    procedure send(varBody: OleVariant); overload;
    procedure abort;
    property DefaultInterface: IXMLHTTPRequest read GetDefaultInterface;
    property status: Integer read Get_status;
    property statusText: WideString read Get_statusText;
    property responseXML: IDispatch read Get_responseXML;
    property responseText: WideString read Get_responseText;
    property responseBody: OleVariant read Get_responseBody;
    property responseStream: OleVariant read Get_responseStream;
    property readyState: Integer read Get_readyState;
    property onreadystatechange: IDispatch write Set_onreadystatechange;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TXMLHTTP26Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TXMLHTTP26
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TXMLHTTP26Properties = class(TPersistent)
  private
    FServer:    TXMLHTTP26;
    function    GetDefaultInterface: IXMLHTTPRequest;
    constructor Create(AServer: TXMLHTTP26);
  protected
    function Get_status: Integer;
    function Get_statusText: WideString;
    function Get_responseXML: IDispatch;
    function Get_responseText: WideString;
    function Get_responseBody: OleVariant;
    function Get_responseStream: OleVariant;
    function Get_readyState: Integer;
    procedure Set_onreadystatechange(const Param1: IDispatch);
  public
    property DefaultInterface: IXMLHTTPRequest read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoXMLHTTP30 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLHTTPRequest expos�e             
// par la CoClasse XMLHTTP30. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoXMLHTTP30 = class
    class function Create: IXMLHTTPRequest;
    class function CreateRemote(const MachineName: string): IXMLHTTPRequest;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TXMLHTTP30
// Cha�ne d'aide        : XML HTTP Request class.
// Interface par d�faut : IXMLHTTPRequest
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TXMLHTTP30Properties= class;
{$ENDIF}
  TXMLHTTP30 = class(TOleServer)
  private
    FIntf:        IXMLHTTPRequest;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TXMLHTTP30Properties;
    function      GetServerProperties: TXMLHTTP30Properties;
{$ENDIF}
    function      GetDefaultInterface: IXMLHTTPRequest;
  protected
    procedure InitServerData; override;
    function Get_status: Integer;
    function Get_statusText: WideString;
    function Get_responseXML: IDispatch;
    function Get_responseText: WideString;
    function Get_responseBody: OleVariant;
    function Get_responseStream: OleVariant;
    function Get_readyState: Integer;
    procedure Set_onreadystatechange(const Param1: IDispatch);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLHTTPRequest);
    procedure Disconnect; override;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant; bstrPassword: OleVariant); overload;
    procedure setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString);
    function getResponseHeader(const bstrHeader: WideString): WideString;
    function getAllResponseHeaders: WideString;
    procedure send; overload;
    procedure send(varBody: OleVariant); overload;
    procedure abort;
    property DefaultInterface: IXMLHTTPRequest read GetDefaultInterface;
    property status: Integer read Get_status;
    property statusText: WideString read Get_statusText;
    property responseXML: IDispatch read Get_responseXML;
    property responseText: WideString read Get_responseText;
    property responseBody: OleVariant read Get_responseBody;
    property responseStream: OleVariant read Get_responseStream;
    property readyState: Integer read Get_readyState;
    property onreadystatechange: IDispatch write Set_onreadystatechange;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TXMLHTTP30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TXMLHTTP30
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TXMLHTTP30Properties = class(TPersistent)
  private
    FServer:    TXMLHTTP30;
    function    GetDefaultInterface: IXMLHTTPRequest;
    constructor Create(AServer: TXMLHTTP30);
  protected
    function Get_status: Integer;
    function Get_statusText: WideString;
    function Get_responseXML: IDispatch;
    function Get_responseText: WideString;
    function Get_responseBody: OleVariant;
    function Get_responseStream: OleVariant;
    function Get_readyState: Integer;
    procedure Set_onreadystatechange(const Param1: IDispatch);
  public
    property DefaultInterface: IXMLHTTPRequest read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoXMLHTTP40 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLHTTPRequest expos�e             
// par la CoClasse XMLHTTP40. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoXMLHTTP40 = class
    class function Create: IXMLHTTPRequest;
    class function CreateRemote(const MachineName: string): IXMLHTTPRequest;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TXMLHTTP40
// Cha�ne d'aide        : XML HTTP Request class.
// Interface par d�faut : IXMLHTTPRequest
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TXMLHTTP40Properties= class;
{$ENDIF}
  TXMLHTTP40 = class(TOleServer)
  private
    FIntf:        IXMLHTTPRequest;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TXMLHTTP40Properties;
    function      GetServerProperties: TXMLHTTP40Properties;
{$ENDIF}
    function      GetDefaultInterface: IXMLHTTPRequest;
  protected
    procedure InitServerData; override;
    function Get_status: Integer;
    function Get_statusText: WideString;
    function Get_responseXML: IDispatch;
    function Get_responseText: WideString;
    function Get_responseBody: OleVariant;
    function Get_responseStream: OleVariant;
    function Get_readyState: Integer;
    procedure Set_onreadystatechange(const Param1: IDispatch);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXMLHTTPRequest);
    procedure Disconnect; override;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant; bstrPassword: OleVariant); overload;
    procedure setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString);
    function getResponseHeader(const bstrHeader: WideString): WideString;
    function getAllResponseHeaders: WideString;
    procedure send; overload;
    procedure send(varBody: OleVariant); overload;
    procedure abort;
    property DefaultInterface: IXMLHTTPRequest read GetDefaultInterface;
    property status: Integer read Get_status;
    property statusText: WideString read Get_statusText;
    property responseXML: IDispatch read Get_responseXML;
    property responseText: WideString read Get_responseText;
    property responseBody: OleVariant read Get_responseBody;
    property responseStream: OleVariant read Get_responseStream;
    property readyState: Integer read Get_readyState;
    property onreadystatechange: IDispatch write Set_onreadystatechange;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TXMLHTTP40Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TXMLHTTP40
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TXMLHTTP40Properties = class(TPersistent)
  private
    FServer:    TXMLHTTP40;
    function    GetDefaultInterface: IXMLHTTPRequest;
    constructor Create(AServer: TXMLHTTP40);
  protected
    function Get_status: Integer;
    function Get_statusText: WideString;
    function Get_responseXML: IDispatch;
    function Get_responseText: WideString;
    function Get_responseBody: OleVariant;
    function Get_responseStream: OleVariant;
    function Get_readyState: Integer;
    procedure Set_onreadystatechange(const Param1: IDispatch);
  public
    property DefaultInterface: IXMLHTTPRequest read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoServerXMLHTTP fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IServerXMLHTTPRequest2 expos�e             
// par la CoClasse ServerXMLHTTP. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoServerXMLHTTP = class
    class function Create: IServerXMLHTTPRequest2;
    class function CreateRemote(const MachineName: string): IServerXMLHTTPRequest2;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TServerXMLHTTP
// Cha�ne d'aide        : Server XML HTTP Request class.
// Interface par d�faut : IServerXMLHTTPRequest2
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TServerXMLHTTPProperties= class;
{$ENDIF}
  TServerXMLHTTP = class(TOleServer)
  private
    FIntf:        IServerXMLHTTPRequest2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TServerXMLHTTPProperties;
    function      GetServerProperties: TServerXMLHTTPProperties;
{$ENDIF}
    function      GetDefaultInterface: IServerXMLHTTPRequest2;
  protected
    procedure InitServerData; override;
    function Get_status: Integer;
    function Get_statusText: WideString;
    function Get_responseXML: IDispatch;
    function Get_responseText: WideString;
    function Get_responseBody: OleVariant;
    function Get_responseStream: OleVariant;
    function Get_readyState: Integer;
    procedure Set_onreadystatechange(const Param1: IDispatch);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IServerXMLHTTPRequest2);
    procedure Disconnect; override;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant; bstrPassword: OleVariant); overload;
    procedure setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString);
    function getResponseHeader(const bstrHeader: WideString): WideString;
    function getAllResponseHeaders: WideString;
    procedure send; overload;
    procedure send(varBody: OleVariant); overload;
    procedure abort;
    procedure setTimeouts(resolveTimeout: Integer; connectTimeout: Integer; sendTimeout: Integer; 
                          receiveTimeout: Integer);
    function waitForResponse: WordBool; overload;
    function waitForResponse(timeoutInSeconds: OleVariant): WordBool; overload;
    function getOption(option: SERVERXMLHTTP_OPTION): OleVariant;
    procedure setOption(option: SERVERXMLHTTP_OPTION; value: OleVariant);
    procedure setProxy(proxySetting: SXH_PROXY_SETTING); overload;
    procedure setProxy(proxySetting: SXH_PROXY_SETTING; varProxyServer: OleVariant); overload;
    procedure setProxy(proxySetting: SXH_PROXY_SETTING; varProxyServer: OleVariant; 
                       varBypassList: OleVariant); overload;
    procedure setProxyCredentials(const bstrUserName: WideString; const bstrPassword: WideString);
    property DefaultInterface: IServerXMLHTTPRequest2 read GetDefaultInterface;
    property status: Integer read Get_status;
    property statusText: WideString read Get_statusText;
    property responseXML: IDispatch read Get_responseXML;
    property responseText: WideString read Get_responseText;
    property responseBody: OleVariant read Get_responseBody;
    property responseStream: OleVariant read Get_responseStream;
    property readyState: Integer read Get_readyState;
    property onreadystatechange: IDispatch write Set_onreadystatechange;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TServerXMLHTTPProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TServerXMLHTTP
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TServerXMLHTTPProperties = class(TPersistent)
  private
    FServer:    TServerXMLHTTP;
    function    GetDefaultInterface: IServerXMLHTTPRequest2;
    constructor Create(AServer: TServerXMLHTTP);
  protected
    function Get_status: Integer;
    function Get_statusText: WideString;
    function Get_responseXML: IDispatch;
    function Get_responseText: WideString;
    function Get_responseBody: OleVariant;
    function Get_responseStream: OleVariant;
    function Get_readyState: Integer;
    procedure Set_onreadystatechange(const Param1: IDispatch);
  public
    property DefaultInterface: IServerXMLHTTPRequest2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoServerXMLHTTP30 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IServerXMLHTTPRequest2 expos�e             
// par la CoClasse ServerXMLHTTP30. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoServerXMLHTTP30 = class
    class function Create: IServerXMLHTTPRequest2;
    class function CreateRemote(const MachineName: string): IServerXMLHTTPRequest2;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TServerXMLHTTP30
// Cha�ne d'aide        : Server XML HTTP Request class.
// Interface par d�faut : IServerXMLHTTPRequest2
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TServerXMLHTTP30Properties= class;
{$ENDIF}
  TServerXMLHTTP30 = class(TOleServer)
  private
    FIntf:        IServerXMLHTTPRequest2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TServerXMLHTTP30Properties;
    function      GetServerProperties: TServerXMLHTTP30Properties;
{$ENDIF}
    function      GetDefaultInterface: IServerXMLHTTPRequest2;
  protected
    procedure InitServerData; override;
    function Get_status: Integer;
    function Get_statusText: WideString;
    function Get_responseXML: IDispatch;
    function Get_responseText: WideString;
    function Get_responseBody: OleVariant;
    function Get_responseStream: OleVariant;
    function Get_readyState: Integer;
    procedure Set_onreadystatechange(const Param1: IDispatch);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IServerXMLHTTPRequest2);
    procedure Disconnect; override;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant; bstrPassword: OleVariant); overload;
    procedure setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString);
    function getResponseHeader(const bstrHeader: WideString): WideString;
    function getAllResponseHeaders: WideString;
    procedure send; overload;
    procedure send(varBody: OleVariant); overload;
    procedure abort;
    procedure setTimeouts(resolveTimeout: Integer; connectTimeout: Integer; sendTimeout: Integer; 
                          receiveTimeout: Integer);
    function waitForResponse: WordBool; overload;
    function waitForResponse(timeoutInSeconds: OleVariant): WordBool; overload;
    function getOption(option: SERVERXMLHTTP_OPTION): OleVariant;
    procedure setOption(option: SERVERXMLHTTP_OPTION; value: OleVariant);
    procedure setProxy(proxySetting: SXH_PROXY_SETTING); overload;
    procedure setProxy(proxySetting: SXH_PROXY_SETTING; varProxyServer: OleVariant); overload;
    procedure setProxy(proxySetting: SXH_PROXY_SETTING; varProxyServer: OleVariant; 
                       varBypassList: OleVariant); overload;
    procedure setProxyCredentials(const bstrUserName: WideString; const bstrPassword: WideString);
    property DefaultInterface: IServerXMLHTTPRequest2 read GetDefaultInterface;
    property status: Integer read Get_status;
    property statusText: WideString read Get_statusText;
    property responseXML: IDispatch read Get_responseXML;
    property responseText: WideString read Get_responseText;
    property responseBody: OleVariant read Get_responseBody;
    property responseStream: OleVariant read Get_responseStream;
    property readyState: Integer read Get_readyState;
    property onreadystatechange: IDispatch write Set_onreadystatechange;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TServerXMLHTTP30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TServerXMLHTTP30
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TServerXMLHTTP30Properties = class(TPersistent)
  private
    FServer:    TServerXMLHTTP30;
    function    GetDefaultInterface: IServerXMLHTTPRequest2;
    constructor Create(AServer: TServerXMLHTTP30);
  protected
    function Get_status: Integer;
    function Get_statusText: WideString;
    function Get_responseXML: IDispatch;
    function Get_responseText: WideString;
    function Get_responseBody: OleVariant;
    function Get_responseStream: OleVariant;
    function Get_readyState: Integer;
    procedure Set_onreadystatechange(const Param1: IDispatch);
  public
    property DefaultInterface: IServerXMLHTTPRequest2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoServerXMLHTTP40 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IServerXMLHTTPRequest2 expos�e             
// par la CoClasse ServerXMLHTTP40. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoServerXMLHTTP40 = class
    class function Create: IServerXMLHTTPRequest2;
    class function CreateRemote(const MachineName: string): IServerXMLHTTPRequest2;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TServerXMLHTTP40
// Cha�ne d'aide        : Server XML HTTP Request class.
// Interface par d�faut : IServerXMLHTTPRequest2
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TServerXMLHTTP40Properties= class;
{$ENDIF}
  TServerXMLHTTP40 = class(TOleServer)
  private
    FIntf:        IServerXMLHTTPRequest2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TServerXMLHTTP40Properties;
    function      GetServerProperties: TServerXMLHTTP40Properties;
{$ENDIF}
    function      GetDefaultInterface: IServerXMLHTTPRequest2;
  protected
    procedure InitServerData; override;
    function Get_status: Integer;
    function Get_statusText: WideString;
    function Get_responseXML: IDispatch;
    function Get_responseText: WideString;
    function Get_responseBody: OleVariant;
    function Get_responseStream: OleVariant;
    function Get_readyState: Integer;
    procedure Set_onreadystatechange(const Param1: IDispatch);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IServerXMLHTTPRequest2);
    procedure Disconnect; override;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant); overload;
    procedure open(const bstrMethod: WideString; const bstrUrl: WideString; varAsync: OleVariant; 
                   bstrUser: OleVariant; bstrPassword: OleVariant); overload;
    procedure setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString);
    function getResponseHeader(const bstrHeader: WideString): WideString;
    function getAllResponseHeaders: WideString;
    procedure send; overload;
    procedure send(varBody: OleVariant); overload;
    procedure abort;
    procedure setTimeouts(resolveTimeout: Integer; connectTimeout: Integer; sendTimeout: Integer; 
                          receiveTimeout: Integer);
    function waitForResponse: WordBool; overload;
    function waitForResponse(timeoutInSeconds: OleVariant): WordBool; overload;
    function getOption(option: SERVERXMLHTTP_OPTION): OleVariant;
    procedure setOption(option: SERVERXMLHTTP_OPTION; value: OleVariant);
    procedure setProxy(proxySetting: SXH_PROXY_SETTING); overload;
    procedure setProxy(proxySetting: SXH_PROXY_SETTING; varProxyServer: OleVariant); overload;
    procedure setProxy(proxySetting: SXH_PROXY_SETTING; varProxyServer: OleVariant; 
                       varBypassList: OleVariant); overload;
    procedure setProxyCredentials(const bstrUserName: WideString; const bstrPassword: WideString);
    property DefaultInterface: IServerXMLHTTPRequest2 read GetDefaultInterface;
    property status: Integer read Get_status;
    property statusText: WideString read Get_statusText;
    property responseXML: IDispatch read Get_responseXML;
    property responseText: WideString read Get_responseText;
    property responseBody: OleVariant read Get_responseBody;
    property responseStream: OleVariant read Get_responseStream;
    property readyState: Integer read Get_readyState;
    property onreadystatechange: IDispatch write Set_onreadystatechange;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TServerXMLHTTP40Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TServerXMLHTTP40
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TServerXMLHTTP40Properties = class(TPersistent)
  private
    FServer:    TServerXMLHTTP40;
    function    GetDefaultInterface: IServerXMLHTTPRequest2;
    constructor Create(AServer: TServerXMLHTTP40);
  protected
    function Get_status: Integer;
    function Get_statusText: WideString;
    function Get_responseXML: IDispatch;
    function Get_responseText: WideString;
    function Get_responseBody: OleVariant;
    function Get_responseStream: OleVariant;
    function Get_readyState: Integer;
    procedure Set_onreadystatechange(const Param1: IDispatch);
  public
    property DefaultInterface: IServerXMLHTTPRequest2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoSAXXMLReader fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IVBSAXXMLReader expos�e             
// par la CoClasse SAXXMLReader. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoSAXXMLReader = class
    class function Create: IVBSAXXMLReader;
    class function CreateRemote(const MachineName: string): IVBSAXXMLReader;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TSAXXMLReader
// Cha�ne d'aide        : SAX XML Reader (version independent) coclass
// Interface par d�faut : IVBSAXXMLReader
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSAXXMLReaderProperties= class;
{$ENDIF}
  TSAXXMLReader = class(TOleServer)
  private
    FIntf:        IVBSAXXMLReader;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSAXXMLReaderProperties;
    function      GetServerProperties: TSAXXMLReaderProperties;
{$ENDIF}
    function      GetDefaultInterface: IVBSAXXMLReader;
  protected
    procedure InitServerData; override;
    function Get_entityResolver: IVBSAXEntityResolver;
    procedure _Set_entityResolver(const oResolver: IVBSAXEntityResolver);
    function Get_contentHandler: IVBSAXContentHandler;
    procedure _Set_contentHandler(const oHandler: IVBSAXContentHandler);
    function Get_dtdHandler: IVBSAXDTDHandler;
    procedure _Set_dtdHandler(const oHandler: IVBSAXDTDHandler);
    function Get_errorHandler: IVBSAXErrorHandler;
    procedure _Set_errorHandler(const oHandler: IVBSAXErrorHandler);
    function Get_baseURL: WideString;
    procedure Set_baseURL(const strBaseURL: WideString);
    function Get_secureBaseURL: WideString;
    procedure Set_secureBaseURL(const strSecureBaseURL: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IVBSAXXMLReader);
    procedure Disconnect; override;
    function getFeature(const strName: WideString): WordBool;
    procedure putFeature(const strName: WideString; fValue: WordBool);
    function getProperty(const strName: WideString): OleVariant;
    procedure putProperty(const strName: WideString; varValue: OleVariant);
    procedure parse(varInput: OleVariant);
    procedure parseURL(const strURL: WideString);
    property DefaultInterface: IVBSAXXMLReader read GetDefaultInterface;
    property entityResolver: IVBSAXEntityResolver read Get_entityResolver write _Set_entityResolver;
    property contentHandler: IVBSAXContentHandler read Get_contentHandler write _Set_contentHandler;
    property dtdHandler: IVBSAXDTDHandler read Get_dtdHandler write _Set_dtdHandler;
    property errorHandler: IVBSAXErrorHandler read Get_errorHandler write _Set_errorHandler;
    property baseURL: WideString read Get_baseURL write Set_baseURL;
    property secureBaseURL: WideString read Get_secureBaseURL write Set_secureBaseURL;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSAXXMLReaderProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TSAXXMLReader
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TSAXXMLReaderProperties = class(TPersistent)
  private
    FServer:    TSAXXMLReader;
    function    GetDefaultInterface: IVBSAXXMLReader;
    constructor Create(AServer: TSAXXMLReader);
  protected
    function Get_entityResolver: IVBSAXEntityResolver;
    procedure _Set_entityResolver(const oResolver: IVBSAXEntityResolver);
    function Get_contentHandler: IVBSAXContentHandler;
    procedure _Set_contentHandler(const oHandler: IVBSAXContentHandler);
    function Get_dtdHandler: IVBSAXDTDHandler;
    procedure _Set_dtdHandler(const oHandler: IVBSAXDTDHandler);
    function Get_errorHandler: IVBSAXErrorHandler;
    procedure _Set_errorHandler(const oHandler: IVBSAXErrorHandler);
    function Get_baseURL: WideString;
    procedure Set_baseURL(const strBaseURL: WideString);
    function Get_secureBaseURL: WideString;
    procedure Set_secureBaseURL(const strSecureBaseURL: WideString);
  public
    property DefaultInterface: IVBSAXXMLReader read GetDefaultInterface;
  published
    property baseURL: WideString read Get_baseURL write Set_baseURL;
    property secureBaseURL: WideString read Get_secureBaseURL write Set_secureBaseURL;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoSAXXMLReader30 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IVBSAXXMLReader expos�e             
// par la CoClasse SAXXMLReader30. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoSAXXMLReader30 = class
    class function Create: IVBSAXXMLReader;
    class function CreateRemote(const MachineName: string): IVBSAXXMLReader;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TSAXXMLReader30
// Cha�ne d'aide        : SAX XML Reader 3.0 coclass
// Interface par d�faut : IVBSAXXMLReader
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSAXXMLReader30Properties= class;
{$ENDIF}
  TSAXXMLReader30 = class(TOleServer)
  private
    FIntf:        IVBSAXXMLReader;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSAXXMLReader30Properties;
    function      GetServerProperties: TSAXXMLReader30Properties;
{$ENDIF}
    function      GetDefaultInterface: IVBSAXXMLReader;
  protected
    procedure InitServerData; override;
    function Get_entityResolver: IVBSAXEntityResolver;
    procedure _Set_entityResolver(const oResolver: IVBSAXEntityResolver);
    function Get_contentHandler: IVBSAXContentHandler;
    procedure _Set_contentHandler(const oHandler: IVBSAXContentHandler);
    function Get_dtdHandler: IVBSAXDTDHandler;
    procedure _Set_dtdHandler(const oHandler: IVBSAXDTDHandler);
    function Get_errorHandler: IVBSAXErrorHandler;
    procedure _Set_errorHandler(const oHandler: IVBSAXErrorHandler);
    function Get_baseURL: WideString;
    procedure Set_baseURL(const strBaseURL: WideString);
    function Get_secureBaseURL: WideString;
    procedure Set_secureBaseURL(const strSecureBaseURL: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IVBSAXXMLReader);
    procedure Disconnect; override;
    function getFeature(const strName: WideString): WordBool;
    procedure putFeature(const strName: WideString; fValue: WordBool);
    function getProperty(const strName: WideString): OleVariant;
    procedure putProperty(const strName: WideString; varValue: OleVariant);
    procedure parse(varInput: OleVariant);
    procedure parseURL(const strURL: WideString);
    property DefaultInterface: IVBSAXXMLReader read GetDefaultInterface;
    property entityResolver: IVBSAXEntityResolver read Get_entityResolver write _Set_entityResolver;
    property contentHandler: IVBSAXContentHandler read Get_contentHandler write _Set_contentHandler;
    property dtdHandler: IVBSAXDTDHandler read Get_dtdHandler write _Set_dtdHandler;
    property errorHandler: IVBSAXErrorHandler read Get_errorHandler write _Set_errorHandler;
    property baseURL: WideString read Get_baseURL write Set_baseURL;
    property secureBaseURL: WideString read Get_secureBaseURL write Set_secureBaseURL;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSAXXMLReader30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TSAXXMLReader30
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TSAXXMLReader30Properties = class(TPersistent)
  private
    FServer:    TSAXXMLReader30;
    function    GetDefaultInterface: IVBSAXXMLReader;
    constructor Create(AServer: TSAXXMLReader30);
  protected
    function Get_entityResolver: IVBSAXEntityResolver;
    procedure _Set_entityResolver(const oResolver: IVBSAXEntityResolver);
    function Get_contentHandler: IVBSAXContentHandler;
    procedure _Set_contentHandler(const oHandler: IVBSAXContentHandler);
    function Get_dtdHandler: IVBSAXDTDHandler;
    procedure _Set_dtdHandler(const oHandler: IVBSAXDTDHandler);
    function Get_errorHandler: IVBSAXErrorHandler;
    procedure _Set_errorHandler(const oHandler: IVBSAXErrorHandler);
    function Get_baseURL: WideString;
    procedure Set_baseURL(const strBaseURL: WideString);
    function Get_secureBaseURL: WideString;
    procedure Set_secureBaseURL(const strSecureBaseURL: WideString);
  public
    property DefaultInterface: IVBSAXXMLReader read GetDefaultInterface;
  published
    property baseURL: WideString read Get_baseURL write Set_baseURL;
    property secureBaseURL: WideString read Get_secureBaseURL write Set_secureBaseURL;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoSAXXMLReader40 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IVBSAXXMLReader expos�e             
// par la CoClasse SAXXMLReader40. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoSAXXMLReader40 = class
    class function Create: IVBSAXXMLReader;
    class function CreateRemote(const MachineName: string): IVBSAXXMLReader;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TSAXXMLReader40
// Cha�ne d'aide        : SAX XML Reader 4.0 coclass
// Interface par d�faut : IVBSAXXMLReader
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSAXXMLReader40Properties= class;
{$ENDIF}
  TSAXXMLReader40 = class(TOleServer)
  private
    FIntf:        IVBSAXXMLReader;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSAXXMLReader40Properties;
    function      GetServerProperties: TSAXXMLReader40Properties;
{$ENDIF}
    function      GetDefaultInterface: IVBSAXXMLReader;
  protected
    procedure InitServerData; override;
    function Get_entityResolver: IVBSAXEntityResolver;
    procedure _Set_entityResolver(const oResolver: IVBSAXEntityResolver);
    function Get_contentHandler: IVBSAXContentHandler;
    procedure _Set_contentHandler(const oHandler: IVBSAXContentHandler);
    function Get_dtdHandler: IVBSAXDTDHandler;
    procedure _Set_dtdHandler(const oHandler: IVBSAXDTDHandler);
    function Get_errorHandler: IVBSAXErrorHandler;
    procedure _Set_errorHandler(const oHandler: IVBSAXErrorHandler);
    function Get_baseURL: WideString;
    procedure Set_baseURL(const strBaseURL: WideString);
    function Get_secureBaseURL: WideString;
    procedure Set_secureBaseURL(const strSecureBaseURL: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IVBSAXXMLReader);
    procedure Disconnect; override;
    function getFeature(const strName: WideString): WordBool;
    procedure putFeature(const strName: WideString; fValue: WordBool);
    function getProperty(const strName: WideString): OleVariant;
    procedure putProperty(const strName: WideString; varValue: OleVariant);
    procedure parse(varInput: OleVariant);
    procedure parseURL(const strURL: WideString);
    property DefaultInterface: IVBSAXXMLReader read GetDefaultInterface;
    property entityResolver: IVBSAXEntityResolver read Get_entityResolver write _Set_entityResolver;
    property contentHandler: IVBSAXContentHandler read Get_contentHandler write _Set_contentHandler;
    property dtdHandler: IVBSAXDTDHandler read Get_dtdHandler write _Set_dtdHandler;
    property errorHandler: IVBSAXErrorHandler read Get_errorHandler write _Set_errorHandler;
    property baseURL: WideString read Get_baseURL write Set_baseURL;
    property secureBaseURL: WideString read Get_secureBaseURL write Set_secureBaseURL;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSAXXMLReader40Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TSAXXMLReader40
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TSAXXMLReader40Properties = class(TPersistent)
  private
    FServer:    TSAXXMLReader40;
    function    GetDefaultInterface: IVBSAXXMLReader;
    constructor Create(AServer: TSAXXMLReader40);
  protected
    function Get_entityResolver: IVBSAXEntityResolver;
    procedure _Set_entityResolver(const oResolver: IVBSAXEntityResolver);
    function Get_contentHandler: IVBSAXContentHandler;
    procedure _Set_contentHandler(const oHandler: IVBSAXContentHandler);
    function Get_dtdHandler: IVBSAXDTDHandler;
    procedure _Set_dtdHandler(const oHandler: IVBSAXDTDHandler);
    function Get_errorHandler: IVBSAXErrorHandler;
    procedure _Set_errorHandler(const oHandler: IVBSAXErrorHandler);
    function Get_baseURL: WideString;
    procedure Set_baseURL(const strBaseURL: WideString);
    function Get_secureBaseURL: WideString;
    procedure Set_secureBaseURL(const strSecureBaseURL: WideString);
  public
    property DefaultInterface: IVBSAXXMLReader read GetDefaultInterface;
  published
    property baseURL: WideString read Get_baseURL write Set_baseURL;
    property secureBaseURL: WideString read Get_secureBaseURL write Set_secureBaseURL;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoMXXMLWriter fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IMXWriter expos�e             
// par la CoClasse MXXMLWriter. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoMXXMLWriter = class
    class function Create: IMXWriter;
    class function CreateRemote(const MachineName: string): IMXWriter;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TMXXMLWriter
// Cha�ne d'aide        : Microsoft XML Writer (version independent) coclass
// Interface par d�faut : IMXWriter
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMXXMLWriterProperties= class;
{$ENDIF}
  TMXXMLWriter = class(TOleServer)
  private
    FIntf:        IMXWriter;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMXXMLWriterProperties;
    function      GetServerProperties: TMXXMLWriterProperties;
{$ENDIF}
    function      GetDefaultInterface: IMXWriter;
  protected
    procedure InitServerData; override;
    procedure Set_output(varDestination: OleVariant);
    function Get_output: OleVariant;
    procedure Set_encoding(const strEncoding: WideString);
    function Get_encoding: WideString;
    procedure Set_byteOrderMark(fWriteByteOrderMark: WordBool);
    function Get_byteOrderMark: WordBool;
    procedure Set_indent(fIndentMode: WordBool);
    function Get_indent: WordBool;
    procedure Set_standalone(fValue: WordBool);
    function Get_standalone: WordBool;
    procedure Set_omitXMLDeclaration(fValue: WordBool);
    function Get_omitXMLDeclaration: WordBool;
    procedure Set_version(const strVersion: WideString);
    function Get_version: WideString;
    procedure Set_disableOutputEscaping(fValue: WordBool);
    function Get_disableOutputEscaping: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IMXWriter);
    procedure Disconnect; override;
    procedure flush;
    property DefaultInterface: IMXWriter read GetDefaultInterface;
    property output: OleVariant read Get_output write Set_output;
    property encoding: WideString read Get_encoding write Set_encoding;
    property byteOrderMark: WordBool read Get_byteOrderMark write Set_byteOrderMark;
    property indent: WordBool read Get_indent write Set_indent;
    property standalone: WordBool read Get_standalone write Set_standalone;
    property omitXMLDeclaration: WordBool read Get_omitXMLDeclaration write Set_omitXMLDeclaration;
    property version: WideString read Get_version write Set_version;
    property disableOutputEscaping: WordBool read Get_disableOutputEscaping write Set_disableOutputEscaping;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMXXMLWriterProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TMXXMLWriter
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TMXXMLWriterProperties = class(TPersistent)
  private
    FServer:    TMXXMLWriter;
    function    GetDefaultInterface: IMXWriter;
    constructor Create(AServer: TMXXMLWriter);
  protected
    procedure Set_output(varDestination: OleVariant);
    function Get_output: OleVariant;
    procedure Set_encoding(const strEncoding: WideString);
    function Get_encoding: WideString;
    procedure Set_byteOrderMark(fWriteByteOrderMark: WordBool);
    function Get_byteOrderMark: WordBool;
    procedure Set_indent(fIndentMode: WordBool);
    function Get_indent: WordBool;
    procedure Set_standalone(fValue: WordBool);
    function Get_standalone: WordBool;
    procedure Set_omitXMLDeclaration(fValue: WordBool);
    function Get_omitXMLDeclaration: WordBool;
    procedure Set_version(const strVersion: WideString);
    function Get_version: WideString;
    procedure Set_disableOutputEscaping(fValue: WordBool);
    function Get_disableOutputEscaping: WordBool;
  public
    property DefaultInterface: IMXWriter read GetDefaultInterface;
  published
    property encoding: WideString read Get_encoding write Set_encoding;
    property byteOrderMark: WordBool read Get_byteOrderMark write Set_byteOrderMark;
    property indent: WordBool read Get_indent write Set_indent;
    property standalone: WordBool read Get_standalone write Set_standalone;
    property omitXMLDeclaration: WordBool read Get_omitXMLDeclaration write Set_omitXMLDeclaration;
    property version: WideString read Get_version write Set_version;
    property disableOutputEscaping: WordBool read Get_disableOutputEscaping write Set_disableOutputEscaping;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoMXXMLWriter30 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IMXWriter expos�e             
// par la CoClasse MXXMLWriter30. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoMXXMLWriter30 = class
    class function Create: IMXWriter;
    class function CreateRemote(const MachineName: string): IMXWriter;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TMXXMLWriter30
// Cha�ne d'aide        : Microsoft XML Writer 3.0 coclass
// Interface par d�faut : IMXWriter
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMXXMLWriter30Properties= class;
{$ENDIF}
  TMXXMLWriter30 = class(TOleServer)
  private
    FIntf:        IMXWriter;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMXXMLWriter30Properties;
    function      GetServerProperties: TMXXMLWriter30Properties;
{$ENDIF}
    function      GetDefaultInterface: IMXWriter;
  protected
    procedure InitServerData; override;
    procedure Set_output(varDestination: OleVariant);
    function Get_output: OleVariant;
    procedure Set_encoding(const strEncoding: WideString);
    function Get_encoding: WideString;
    procedure Set_byteOrderMark(fWriteByteOrderMark: WordBool);
    function Get_byteOrderMark: WordBool;
    procedure Set_indent(fIndentMode: WordBool);
    function Get_indent: WordBool;
    procedure Set_standalone(fValue: WordBool);
    function Get_standalone: WordBool;
    procedure Set_omitXMLDeclaration(fValue: WordBool);
    function Get_omitXMLDeclaration: WordBool;
    procedure Set_version(const strVersion: WideString);
    function Get_version: WideString;
    procedure Set_disableOutputEscaping(fValue: WordBool);
    function Get_disableOutputEscaping: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IMXWriter);
    procedure Disconnect; override;
    procedure flush;
    property DefaultInterface: IMXWriter read GetDefaultInterface;
    property output: OleVariant read Get_output write Set_output;
    property encoding: WideString read Get_encoding write Set_encoding;
    property byteOrderMark: WordBool read Get_byteOrderMark write Set_byteOrderMark;
    property indent: WordBool read Get_indent write Set_indent;
    property standalone: WordBool read Get_standalone write Set_standalone;
    property omitXMLDeclaration: WordBool read Get_omitXMLDeclaration write Set_omitXMLDeclaration;
    property version: WideString read Get_version write Set_version;
    property disableOutputEscaping: WordBool read Get_disableOutputEscaping write Set_disableOutputEscaping;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMXXMLWriter30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TMXXMLWriter30
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TMXXMLWriter30Properties = class(TPersistent)
  private
    FServer:    TMXXMLWriter30;
    function    GetDefaultInterface: IMXWriter;
    constructor Create(AServer: TMXXMLWriter30);
  protected
    procedure Set_output(varDestination: OleVariant);
    function Get_output: OleVariant;
    procedure Set_encoding(const strEncoding: WideString);
    function Get_encoding: WideString;
    procedure Set_byteOrderMark(fWriteByteOrderMark: WordBool);
    function Get_byteOrderMark: WordBool;
    procedure Set_indent(fIndentMode: WordBool);
    function Get_indent: WordBool;
    procedure Set_standalone(fValue: WordBool);
    function Get_standalone: WordBool;
    procedure Set_omitXMLDeclaration(fValue: WordBool);
    function Get_omitXMLDeclaration: WordBool;
    procedure Set_version(const strVersion: WideString);
    function Get_version: WideString;
    procedure Set_disableOutputEscaping(fValue: WordBool);
    function Get_disableOutputEscaping: WordBool;
  public
    property DefaultInterface: IMXWriter read GetDefaultInterface;
  published
    property encoding: WideString read Get_encoding write Set_encoding;
    property byteOrderMark: WordBool read Get_byteOrderMark write Set_byteOrderMark;
    property indent: WordBool read Get_indent write Set_indent;
    property standalone: WordBool read Get_standalone write Set_standalone;
    property omitXMLDeclaration: WordBool read Get_omitXMLDeclaration write Set_omitXMLDeclaration;
    property version: WideString read Get_version write Set_version;
    property disableOutputEscaping: WordBool read Get_disableOutputEscaping write Set_disableOutputEscaping;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoMXXMLWriter40 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IMXWriter expos�e             
// par la CoClasse MXXMLWriter40. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoMXXMLWriter40 = class
    class function Create: IMXWriter;
    class function CreateRemote(const MachineName: string): IMXWriter;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TMXXMLWriter40
// Cha�ne d'aide        : Microsoft XML Writer 4.0 coclass
// Interface par d�faut : IMXWriter
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMXXMLWriter40Properties= class;
{$ENDIF}
  TMXXMLWriter40 = class(TOleServer)
  private
    FIntf:        IMXWriter;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMXXMLWriter40Properties;
    function      GetServerProperties: TMXXMLWriter40Properties;
{$ENDIF}
    function      GetDefaultInterface: IMXWriter;
  protected
    procedure InitServerData; override;
    procedure Set_output(varDestination: OleVariant);
    function Get_output: OleVariant;
    procedure Set_encoding(const strEncoding: WideString);
    function Get_encoding: WideString;
    procedure Set_byteOrderMark(fWriteByteOrderMark: WordBool);
    function Get_byteOrderMark: WordBool;
    procedure Set_indent(fIndentMode: WordBool);
    function Get_indent: WordBool;
    procedure Set_standalone(fValue: WordBool);
    function Get_standalone: WordBool;
    procedure Set_omitXMLDeclaration(fValue: WordBool);
    function Get_omitXMLDeclaration: WordBool;
    procedure Set_version(const strVersion: WideString);
    function Get_version: WideString;
    procedure Set_disableOutputEscaping(fValue: WordBool);
    function Get_disableOutputEscaping: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IMXWriter);
    procedure Disconnect; override;
    procedure flush;
    property DefaultInterface: IMXWriter read GetDefaultInterface;
    property output: OleVariant read Get_output write Set_output;
    property encoding: WideString read Get_encoding write Set_encoding;
    property byteOrderMark: WordBool read Get_byteOrderMark write Set_byteOrderMark;
    property indent: WordBool read Get_indent write Set_indent;
    property standalone: WordBool read Get_standalone write Set_standalone;
    property omitXMLDeclaration: WordBool read Get_omitXMLDeclaration write Set_omitXMLDeclaration;
    property version: WideString read Get_version write Set_version;
    property disableOutputEscaping: WordBool read Get_disableOutputEscaping write Set_disableOutputEscaping;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMXXMLWriter40Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TMXXMLWriter40
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TMXXMLWriter40Properties = class(TPersistent)
  private
    FServer:    TMXXMLWriter40;
    function    GetDefaultInterface: IMXWriter;
    constructor Create(AServer: TMXXMLWriter40);
  protected
    procedure Set_output(varDestination: OleVariant);
    function Get_output: OleVariant;
    procedure Set_encoding(const strEncoding: WideString);
    function Get_encoding: WideString;
    procedure Set_byteOrderMark(fWriteByteOrderMark: WordBool);
    function Get_byteOrderMark: WordBool;
    procedure Set_indent(fIndentMode: WordBool);
    function Get_indent: WordBool;
    procedure Set_standalone(fValue: WordBool);
    function Get_standalone: WordBool;
    procedure Set_omitXMLDeclaration(fValue: WordBool);
    function Get_omitXMLDeclaration: WordBool;
    procedure Set_version(const strVersion: WideString);
    function Get_version: WideString;
    procedure Set_disableOutputEscaping(fValue: WordBool);
    function Get_disableOutputEscaping: WordBool;
  public
    property DefaultInterface: IMXWriter read GetDefaultInterface;
  published
    property encoding: WideString read Get_encoding write Set_encoding;
    property byteOrderMark: WordBool read Get_byteOrderMark write Set_byteOrderMark;
    property indent: WordBool read Get_indent write Set_indent;
    property standalone: WordBool read Get_standalone write Set_standalone;
    property omitXMLDeclaration: WordBool read Get_omitXMLDeclaration write Set_omitXMLDeclaration;
    property version: WideString read Get_version write Set_version;
    property disableOutputEscaping: WordBool read Get_disableOutputEscaping write Set_disableOutputEscaping;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoMXHTMLWriter fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IMXWriter expos�e             
// par la CoClasse MXHTMLWriter. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoMXHTMLWriter = class
    class function Create: IMXWriter;
    class function CreateRemote(const MachineName: string): IMXWriter;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TMXHTMLWriter
// Cha�ne d'aide        : Microsoft HTML Writer (version independent) coclass
// Interface par d�faut : IMXWriter
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMXHTMLWriterProperties= class;
{$ENDIF}
  TMXHTMLWriter = class(TOleServer)
  private
    FIntf:        IMXWriter;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMXHTMLWriterProperties;
    function      GetServerProperties: TMXHTMLWriterProperties;
{$ENDIF}
    function      GetDefaultInterface: IMXWriter;
  protected
    procedure InitServerData; override;
    procedure Set_output(varDestination: OleVariant);
    function Get_output: OleVariant;
    procedure Set_encoding(const strEncoding: WideString);
    function Get_encoding: WideString;
    procedure Set_byteOrderMark(fWriteByteOrderMark: WordBool);
    function Get_byteOrderMark: WordBool;
    procedure Set_indent(fIndentMode: WordBool);
    function Get_indent: WordBool;
    procedure Set_standalone(fValue: WordBool);
    function Get_standalone: WordBool;
    procedure Set_omitXMLDeclaration(fValue: WordBool);
    function Get_omitXMLDeclaration: WordBool;
    procedure Set_version(const strVersion: WideString);
    function Get_version: WideString;
    procedure Set_disableOutputEscaping(fValue: WordBool);
    function Get_disableOutputEscaping: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IMXWriter);
    procedure Disconnect; override;
    procedure flush;
    property DefaultInterface: IMXWriter read GetDefaultInterface;
    property output: OleVariant read Get_output write Set_output;
    property encoding: WideString read Get_encoding write Set_encoding;
    property byteOrderMark: WordBool read Get_byteOrderMark write Set_byteOrderMark;
    property indent: WordBool read Get_indent write Set_indent;
    property standalone: WordBool read Get_standalone write Set_standalone;
    property omitXMLDeclaration: WordBool read Get_omitXMLDeclaration write Set_omitXMLDeclaration;
    property version: WideString read Get_version write Set_version;
    property disableOutputEscaping: WordBool read Get_disableOutputEscaping write Set_disableOutputEscaping;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMXHTMLWriterProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TMXHTMLWriter
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TMXHTMLWriterProperties = class(TPersistent)
  private
    FServer:    TMXHTMLWriter;
    function    GetDefaultInterface: IMXWriter;
    constructor Create(AServer: TMXHTMLWriter);
  protected
    procedure Set_output(varDestination: OleVariant);
    function Get_output: OleVariant;
    procedure Set_encoding(const strEncoding: WideString);
    function Get_encoding: WideString;
    procedure Set_byteOrderMark(fWriteByteOrderMark: WordBool);
    function Get_byteOrderMark: WordBool;
    procedure Set_indent(fIndentMode: WordBool);
    function Get_indent: WordBool;
    procedure Set_standalone(fValue: WordBool);
    function Get_standalone: WordBool;
    procedure Set_omitXMLDeclaration(fValue: WordBool);
    function Get_omitXMLDeclaration: WordBool;
    procedure Set_version(const strVersion: WideString);
    function Get_version: WideString;
    procedure Set_disableOutputEscaping(fValue: WordBool);
    function Get_disableOutputEscaping: WordBool;
  public
    property DefaultInterface: IMXWriter read GetDefaultInterface;
  published
    property encoding: WideString read Get_encoding write Set_encoding;
    property byteOrderMark: WordBool read Get_byteOrderMark write Set_byteOrderMark;
    property indent: WordBool read Get_indent write Set_indent;
    property standalone: WordBool read Get_standalone write Set_standalone;
    property omitXMLDeclaration: WordBool read Get_omitXMLDeclaration write Set_omitXMLDeclaration;
    property version: WideString read Get_version write Set_version;
    property disableOutputEscaping: WordBool read Get_disableOutputEscaping write Set_disableOutputEscaping;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoMXHTMLWriter30 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IMXWriter expos�e             
// par la CoClasse MXHTMLWriter30. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoMXHTMLWriter30 = class
    class function Create: IMXWriter;
    class function CreateRemote(const MachineName: string): IMXWriter;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TMXHTMLWriter30
// Cha�ne d'aide        : Microsoft HTML Writer 3.0 coclass
// Interface par d�faut : IMXWriter
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMXHTMLWriter30Properties= class;
{$ENDIF}
  TMXHTMLWriter30 = class(TOleServer)
  private
    FIntf:        IMXWriter;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMXHTMLWriter30Properties;
    function      GetServerProperties: TMXHTMLWriter30Properties;
{$ENDIF}
    function      GetDefaultInterface: IMXWriter;
  protected
    procedure InitServerData; override;
    procedure Set_output(varDestination: OleVariant);
    function Get_output: OleVariant;
    procedure Set_encoding(const strEncoding: WideString);
    function Get_encoding: WideString;
    procedure Set_byteOrderMark(fWriteByteOrderMark: WordBool);
    function Get_byteOrderMark: WordBool;
    procedure Set_indent(fIndentMode: WordBool);
    function Get_indent: WordBool;
    procedure Set_standalone(fValue: WordBool);
    function Get_standalone: WordBool;
    procedure Set_omitXMLDeclaration(fValue: WordBool);
    function Get_omitXMLDeclaration: WordBool;
    procedure Set_version(const strVersion: WideString);
    function Get_version: WideString;
    procedure Set_disableOutputEscaping(fValue: WordBool);
    function Get_disableOutputEscaping: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IMXWriter);
    procedure Disconnect; override;
    procedure flush;
    property DefaultInterface: IMXWriter read GetDefaultInterface;
    property output: OleVariant read Get_output write Set_output;
    property encoding: WideString read Get_encoding write Set_encoding;
    property byteOrderMark: WordBool read Get_byteOrderMark write Set_byteOrderMark;
    property indent: WordBool read Get_indent write Set_indent;
    property standalone: WordBool read Get_standalone write Set_standalone;
    property omitXMLDeclaration: WordBool read Get_omitXMLDeclaration write Set_omitXMLDeclaration;
    property version: WideString read Get_version write Set_version;
    property disableOutputEscaping: WordBool read Get_disableOutputEscaping write Set_disableOutputEscaping;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMXHTMLWriter30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TMXHTMLWriter30
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TMXHTMLWriter30Properties = class(TPersistent)
  private
    FServer:    TMXHTMLWriter30;
    function    GetDefaultInterface: IMXWriter;
    constructor Create(AServer: TMXHTMLWriter30);
  protected
    procedure Set_output(varDestination: OleVariant);
    function Get_output: OleVariant;
    procedure Set_encoding(const strEncoding: WideString);
    function Get_encoding: WideString;
    procedure Set_byteOrderMark(fWriteByteOrderMark: WordBool);
    function Get_byteOrderMark: WordBool;
    procedure Set_indent(fIndentMode: WordBool);
    function Get_indent: WordBool;
    procedure Set_standalone(fValue: WordBool);
    function Get_standalone: WordBool;
    procedure Set_omitXMLDeclaration(fValue: WordBool);
    function Get_omitXMLDeclaration: WordBool;
    procedure Set_version(const strVersion: WideString);
    function Get_version: WideString;
    procedure Set_disableOutputEscaping(fValue: WordBool);
    function Get_disableOutputEscaping: WordBool;
  public
    property DefaultInterface: IMXWriter read GetDefaultInterface;
  published
    property encoding: WideString read Get_encoding write Set_encoding;
    property byteOrderMark: WordBool read Get_byteOrderMark write Set_byteOrderMark;
    property indent: WordBool read Get_indent write Set_indent;
    property standalone: WordBool read Get_standalone write Set_standalone;
    property omitXMLDeclaration: WordBool read Get_omitXMLDeclaration write Set_omitXMLDeclaration;
    property version: WideString read Get_version write Set_version;
    property disableOutputEscaping: WordBool read Get_disableOutputEscaping write Set_disableOutputEscaping;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoMXHTMLWriter40 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IMXWriter expos�e             
// par la CoClasse MXHTMLWriter40. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoMXHTMLWriter40 = class
    class function Create: IMXWriter;
    class function CreateRemote(const MachineName: string): IMXWriter;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TMXHTMLWriter40
// Cha�ne d'aide        : Microsoft HTML Writer 4.0 coclass
// Interface par d�faut : IMXWriter
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMXHTMLWriter40Properties= class;
{$ENDIF}
  TMXHTMLWriter40 = class(TOleServer)
  private
    FIntf:        IMXWriter;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMXHTMLWriter40Properties;
    function      GetServerProperties: TMXHTMLWriter40Properties;
{$ENDIF}
    function      GetDefaultInterface: IMXWriter;
  protected
    procedure InitServerData; override;
    procedure Set_output(varDestination: OleVariant);
    function Get_output: OleVariant;
    procedure Set_encoding(const strEncoding: WideString);
    function Get_encoding: WideString;
    procedure Set_byteOrderMark(fWriteByteOrderMark: WordBool);
    function Get_byteOrderMark: WordBool;
    procedure Set_indent(fIndentMode: WordBool);
    function Get_indent: WordBool;
    procedure Set_standalone(fValue: WordBool);
    function Get_standalone: WordBool;
    procedure Set_omitXMLDeclaration(fValue: WordBool);
    function Get_omitXMLDeclaration: WordBool;
    procedure Set_version(const strVersion: WideString);
    function Get_version: WideString;
    procedure Set_disableOutputEscaping(fValue: WordBool);
    function Get_disableOutputEscaping: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IMXWriter);
    procedure Disconnect; override;
    procedure flush;
    property DefaultInterface: IMXWriter read GetDefaultInterface;
    property output: OleVariant read Get_output write Set_output;
    property encoding: WideString read Get_encoding write Set_encoding;
    property byteOrderMark: WordBool read Get_byteOrderMark write Set_byteOrderMark;
    property indent: WordBool read Get_indent write Set_indent;
    property standalone: WordBool read Get_standalone write Set_standalone;
    property omitXMLDeclaration: WordBool read Get_omitXMLDeclaration write Set_omitXMLDeclaration;
    property version: WideString read Get_version write Set_version;
    property disableOutputEscaping: WordBool read Get_disableOutputEscaping write Set_disableOutputEscaping;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMXHTMLWriter40Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TMXHTMLWriter40
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TMXHTMLWriter40Properties = class(TPersistent)
  private
    FServer:    TMXHTMLWriter40;
    function    GetDefaultInterface: IMXWriter;
    constructor Create(AServer: TMXHTMLWriter40);
  protected
    procedure Set_output(varDestination: OleVariant);
    function Get_output: OleVariant;
    procedure Set_encoding(const strEncoding: WideString);
    function Get_encoding: WideString;
    procedure Set_byteOrderMark(fWriteByteOrderMark: WordBool);
    function Get_byteOrderMark: WordBool;
    procedure Set_indent(fIndentMode: WordBool);
    function Get_indent: WordBool;
    procedure Set_standalone(fValue: WordBool);
    function Get_standalone: WordBool;
    procedure Set_omitXMLDeclaration(fValue: WordBool);
    function Get_omitXMLDeclaration: WordBool;
    procedure Set_version(const strVersion: WideString);
    function Get_version: WideString;
    procedure Set_disableOutputEscaping(fValue: WordBool);
    function Get_disableOutputEscaping: WordBool;
  public
    property DefaultInterface: IMXWriter read GetDefaultInterface;
  published
    property encoding: WideString read Get_encoding write Set_encoding;
    property byteOrderMark: WordBool read Get_byteOrderMark write Set_byteOrderMark;
    property indent: WordBool read Get_indent write Set_indent;
    property standalone: WordBool read Get_standalone write Set_standalone;
    property omitXMLDeclaration: WordBool read Get_omitXMLDeclaration write Set_omitXMLDeclaration;
    property version: WideString read Get_version write Set_version;
    property disableOutputEscaping: WordBool read Get_disableOutputEscaping write Set_disableOutputEscaping;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoSAXAttributes fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IMXAttributes expos�e             
// par la CoClasse SAXAttributes. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoSAXAttributes = class
    class function Create: IMXAttributes;
    class function CreateRemote(const MachineName: string): IMXAttributes;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TSAXAttributes
// Cha�ne d'aide        : SAX Attributes (version independent) coclass
// Interface par d�faut : IMXAttributes
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSAXAttributesProperties= class;
{$ENDIF}
  TSAXAttributes = class(TOleServer)
  private
    FIntf:        IMXAttributes;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSAXAttributesProperties;
    function      GetServerProperties: TSAXAttributesProperties;
{$ENDIF}
    function      GetDefaultInterface: IMXAttributes;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IMXAttributes);
    procedure Disconnect; override;
    procedure addAttribute(const strURI: WideString; const strLocalName: WideString; 
                           const strQName: WideString; const strType: WideString; 
                           const strValue: WideString);
    procedure addAttributeFromIndex(varAtts: OleVariant; nIndex: SYSINT);
    procedure clear;
    procedure removeAttribute(nIndex: SYSINT);
    procedure setAttribute(nIndex: SYSINT; const strURI: WideString; 
                           const strLocalName: WideString; const strQName: WideString; 
                           const strType: WideString; const strValue: WideString);
    procedure setAttributes(varAtts: OleVariant);
    procedure setLocalName(nIndex: SYSINT; const strLocalName: WideString);
    procedure setQName(nIndex: SYSINT; const strQName: WideString);
    procedure setType(nIndex: SYSINT; const strType: WideString);
    procedure setURI(nIndex: SYSINT; const strURI: WideString);
    procedure setValue(nIndex: SYSINT; const strValue: WideString);
    property DefaultInterface: IMXAttributes read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSAXAttributesProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TSAXAttributes
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TSAXAttributesProperties = class(TPersistent)
  private
    FServer:    TSAXAttributes;
    function    GetDefaultInterface: IMXAttributes;
    constructor Create(AServer: TSAXAttributes);
  protected
  public
    property DefaultInterface: IMXAttributes read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoSAXAttributes30 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IMXAttributes expos�e             
// par la CoClasse SAXAttributes30. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoSAXAttributes30 = class
    class function Create: IMXAttributes;
    class function CreateRemote(const MachineName: string): IMXAttributes;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TSAXAttributes30
// Cha�ne d'aide        : SAX Attributes 3.0 coclass
// Interface par d�faut : IMXAttributes
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSAXAttributes30Properties= class;
{$ENDIF}
  TSAXAttributes30 = class(TOleServer)
  private
    FIntf:        IMXAttributes;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSAXAttributes30Properties;
    function      GetServerProperties: TSAXAttributes30Properties;
{$ENDIF}
    function      GetDefaultInterface: IMXAttributes;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IMXAttributes);
    procedure Disconnect; override;
    procedure addAttribute(const strURI: WideString; const strLocalName: WideString; 
                           const strQName: WideString; const strType: WideString; 
                           const strValue: WideString);
    procedure addAttributeFromIndex(varAtts: OleVariant; nIndex: SYSINT);
    procedure clear;
    procedure removeAttribute(nIndex: SYSINT);
    procedure setAttribute(nIndex: SYSINT; const strURI: WideString; 
                           const strLocalName: WideString; const strQName: WideString; 
                           const strType: WideString; const strValue: WideString);
    procedure setAttributes(varAtts: OleVariant);
    procedure setLocalName(nIndex: SYSINT; const strLocalName: WideString);
    procedure setQName(nIndex: SYSINT; const strQName: WideString);
    procedure setType(nIndex: SYSINT; const strType: WideString);
    procedure setURI(nIndex: SYSINT; const strURI: WideString);
    procedure setValue(nIndex: SYSINT; const strValue: WideString);
    property DefaultInterface: IMXAttributes read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSAXAttributes30Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TSAXAttributes30
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TSAXAttributes30Properties = class(TPersistent)
  private
    FServer:    TSAXAttributes30;
    function    GetDefaultInterface: IMXAttributes;
    constructor Create(AServer: TSAXAttributes30);
  protected
  public
    property DefaultInterface: IMXAttributes read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoSAXAttributes40 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IMXAttributes expos�e             
// par la CoClasse SAXAttributes40. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoSAXAttributes40 = class
    class function Create: IMXAttributes;
    class function CreateRemote(const MachineName: string): IMXAttributes;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TSAXAttributes40
// Cha�ne d'aide        : SAX Attributes 4.0 coclass
// Interface par d�faut : IMXAttributes
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSAXAttributes40Properties= class;
{$ENDIF}
  TSAXAttributes40 = class(TOleServer)
  private
    FIntf:        IMXAttributes;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSAXAttributes40Properties;
    function      GetServerProperties: TSAXAttributes40Properties;
{$ENDIF}
    function      GetDefaultInterface: IMXAttributes;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IMXAttributes);
    procedure Disconnect; override;
    procedure addAttribute(const strURI: WideString; const strLocalName: WideString; 
                           const strQName: WideString; const strType: WideString; 
                           const strValue: WideString);
    procedure addAttributeFromIndex(varAtts: OleVariant; nIndex: SYSINT);
    procedure clear;
    procedure removeAttribute(nIndex: SYSINT);
    procedure setAttribute(nIndex: SYSINT; const strURI: WideString; 
                           const strLocalName: WideString; const strQName: WideString; 
                           const strType: WideString; const strValue: WideString);
    procedure setAttributes(varAtts: OleVariant);
    procedure setLocalName(nIndex: SYSINT; const strLocalName: WideString);
    procedure setQName(nIndex: SYSINT; const strQName: WideString);
    procedure setType(nIndex: SYSINT; const strType: WideString);
    procedure setURI(nIndex: SYSINT; const strURI: WideString);
    procedure setValue(nIndex: SYSINT; const strValue: WideString);
    property DefaultInterface: IMXAttributes read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSAXAttributes40Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TSAXAttributes40
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TSAXAttributes40Properties = class(TPersistent)
  private
    FServer:    TSAXAttributes40;
    function    GetDefaultInterface: IMXAttributes;
    constructor Create(AServer: TSAXAttributes40);
  protected
  public
    property DefaultInterface: IMXAttributes read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoMXNamespaceManager fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IVBMXNamespaceManager expos�e             
// par la CoClasse MXNamespaceManager. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoMXNamespaceManager = class
    class function Create: IVBMXNamespaceManager;
    class function CreateRemote(const MachineName: string): IVBMXNamespaceManager;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TMXNamespaceManager
// Cha�ne d'aide        : MX Namespace Manager coclass
// Interface par d�faut : IVBMXNamespaceManager
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMXNamespaceManagerProperties= class;
{$ENDIF}
  TMXNamespaceManager = class(TOleServer)
  private
    FIntf:        IVBMXNamespaceManager;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMXNamespaceManagerProperties;
    function      GetServerProperties: TMXNamespaceManagerProperties;
{$ENDIF}
    function      GetDefaultInterface: IVBMXNamespaceManager;
  protected
    procedure InitServerData; override;
    procedure Set_allowOverride(fOverride: WordBool);
    function Get_allowOverride: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IVBMXNamespaceManager);
    procedure Disconnect; override;
    procedure reset;
    procedure pushContext;
    procedure pushNodeContext(const contextNode: IXMLDOMNode; fDeep: WordBool);
    procedure popContext;
    procedure declarePrefix(const prefix: WideString; const namespaceURI: WideString);
    function getDeclaredPrefixes: IMXNamespacePrefixes;
    function getPrefixes(const namespaceURI: WideString): IMXNamespacePrefixes;
    function getURI(const prefix: WideString): OleVariant;
    function getURIFromNode(const strPrefix: WideString; const contextNode: IXMLDOMNode): OleVariant;
    property DefaultInterface: IVBMXNamespaceManager read GetDefaultInterface;
    property allowOverride: WordBool read Get_allowOverride write Set_allowOverride;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMXNamespaceManagerProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TMXNamespaceManager
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TMXNamespaceManagerProperties = class(TPersistent)
  private
    FServer:    TMXNamespaceManager;
    function    GetDefaultInterface: IVBMXNamespaceManager;
    constructor Create(AServer: TMXNamespaceManager);
  protected
    procedure Set_allowOverride(fOverride: WordBool);
    function Get_allowOverride: WordBool;
  public
    property DefaultInterface: IVBMXNamespaceManager read GetDefaultInterface;
  published
    property allowOverride: WordBool read Get_allowOverride write Set_allowOverride;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoMXNamespaceManager40 fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IVBMXNamespaceManager expos�e             
// par la CoClasse MXNamespaceManager40. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoMXNamespaceManager40 = class
    class function Create: IVBMXNamespaceManager;
    class function CreateRemote(const MachineName: string): IVBMXNamespaceManager;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TMXNamespaceManager40
// Cha�ne d'aide        : MX Namespace Manager 4.0 coclass
// Interface par d�faut : IVBMXNamespaceManager
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMXNamespaceManager40Properties= class;
{$ENDIF}
  TMXNamespaceManager40 = class(TOleServer)
  private
    FIntf:        IVBMXNamespaceManager;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMXNamespaceManager40Properties;
    function      GetServerProperties: TMXNamespaceManager40Properties;
{$ENDIF}
    function      GetDefaultInterface: IVBMXNamespaceManager;
  protected
    procedure InitServerData; override;
    procedure Set_allowOverride(fOverride: WordBool);
    function Get_allowOverride: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IVBMXNamespaceManager);
    procedure Disconnect; override;
    procedure reset;
    procedure pushContext;
    procedure pushNodeContext(const contextNode: IXMLDOMNode; fDeep: WordBool);
    procedure popContext;
    procedure declarePrefix(const prefix: WideString; const namespaceURI: WideString);
    function getDeclaredPrefixes: IMXNamespacePrefixes;
    function getPrefixes(const namespaceURI: WideString): IMXNamespacePrefixes;
    function getURI(const prefix: WideString): OleVariant;
    function getURIFromNode(const strPrefix: WideString; const contextNode: IXMLDOMNode): OleVariant;
    property DefaultInterface: IVBMXNamespaceManager read GetDefaultInterface;
    property allowOverride: WordBool read Get_allowOverride write Set_allowOverride;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMXNamespaceManager40Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TMXNamespaceManager40
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TMXNamespaceManager40Properties = class(TPersistent)
  private
    FServer:    TMXNamespaceManager40;
    function    GetDefaultInterface: IVBMXNamespaceManager;
    constructor Create(AServer: TMXNamespaceManager40);
  protected
    procedure Set_allowOverride(fOverride: WordBool);
    function Get_allowOverride: WordBool;
  public
    property DefaultInterface: IVBMXNamespaceManager read GetDefaultInterface;
  published
    property allowOverride: WordBool read Get_allowOverride write Set_allowOverride;
  end;
{$ENDIF}


// *********************************************************************//
// La classe CoXMLDocument fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IXMLDocument2 expos�e             
// par la CoClasse XMLDocument. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoXMLDocument = class
    class function Create: IXMLDocument2;
    class function CreateRemote(const MachineName: string): IXMLDocument2;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoDOMDocument.Create: IXMLDOMDocument2;
begin
  Result := CreateComObject(CLASS_DOMDocument) as IXMLDOMDocument2;
end;

class function CoDOMDocument.CreateRemote(const MachineName: string): IXMLDOMDocument2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DOMDocument) as IXMLDOMDocument2;
end;

procedure TDOMDocument.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F6D90F11-9C73-11D3-B32E-00C04F990BB4}';
    IntfIID:   '{2933BF95-7B36-11D2-B20E-00C04F983E60}';
    EventIID:  '{3EFAA427-272F-11D2-836F-0000F87A7782}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDOMDocument.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IXMLDOMDocument2;
  end;
end;

procedure TDOMDocument.ConnectTo(svrIntf: IXMLDOMDocument2);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TDOMDocument.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TDOMDocument.GetDefaultInterface: IXMLDOMDocument2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TDOMDocument.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDOMDocumentProperties.Create(Self);
{$ENDIF}
end;

destructor TDOMDocument.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDOMDocument.GetServerProperties: TDOMDocumentProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TDOMDocument.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    198: if Assigned(FOnondataavailable) then
         FOnondataavailable(Self);
    -609: if Assigned(FOnonreadystatechange) then
         FOnonreadystatechange(Self);
  end; {case DispID}
end;

function TDOMDocument.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TDOMDocument.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TDOMDocument._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

function TDOMDocument.validate: IXMLDOMParseError;
begin
  Result := DefaultInterface.validate;
end;

procedure TDOMDocument.setProperty(const name: WideString; value: OleVariant);
begin
  DefaultInterface.setProperty(name, value);
end;

function TDOMDocument.getProperty(const name: WideString): OleVariant;
begin
  Result := DefaultInterface.getProperty(name);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDOMDocumentProperties.Create(AServer: TDOMDocument);
begin
  inherited Create;
  FServer := AServer;
end;

function TDOMDocumentProperties.GetDefaultInterface: IXMLDOMDocument2;
begin
  Result := FServer.DefaultInterface;
end;

function TDOMDocumentProperties.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TDOMDocumentProperties.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TDOMDocumentProperties._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

{$ENDIF}

class function CoDOMDocument26.Create: IXMLDOMDocument2;
begin
  Result := CreateComObject(CLASS_DOMDocument26) as IXMLDOMDocument2;
end;

class function CoDOMDocument26.CreateRemote(const MachineName: string): IXMLDOMDocument2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DOMDocument26) as IXMLDOMDocument2;
end;

procedure TDOMDocument26.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F5078F1B-C551-11D3-89B9-0000F81FE221}';
    IntfIID:   '{2933BF95-7B36-11D2-B20E-00C04F983E60}';
    EventIID:  '{3EFAA427-272F-11D2-836F-0000F87A7782}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDOMDocument26.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IXMLDOMDocument2;
  end;
end;

procedure TDOMDocument26.ConnectTo(svrIntf: IXMLDOMDocument2);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TDOMDocument26.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TDOMDocument26.GetDefaultInterface: IXMLDOMDocument2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TDOMDocument26.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDOMDocument26Properties.Create(Self);
{$ENDIF}
end;

destructor TDOMDocument26.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDOMDocument26.GetServerProperties: TDOMDocument26Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TDOMDocument26.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    198: if Assigned(FOnondataavailable) then
         FOnondataavailable(Self);
    -609: if Assigned(FOnonreadystatechange) then
         FOnonreadystatechange(Self);
  end; {case DispID}
end;

function TDOMDocument26.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TDOMDocument26.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TDOMDocument26._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

function TDOMDocument26.validate: IXMLDOMParseError;
begin
  Result := DefaultInterface.validate;
end;

procedure TDOMDocument26.setProperty(const name: WideString; value: OleVariant);
begin
  DefaultInterface.setProperty(name, value);
end;

function TDOMDocument26.getProperty(const name: WideString): OleVariant;
begin
  Result := DefaultInterface.getProperty(name);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDOMDocument26Properties.Create(AServer: TDOMDocument26);
begin
  inherited Create;
  FServer := AServer;
end;

function TDOMDocument26Properties.GetDefaultInterface: IXMLDOMDocument2;
begin
  Result := FServer.DefaultInterface;
end;

function TDOMDocument26Properties.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TDOMDocument26Properties.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TDOMDocument26Properties._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

{$ENDIF}

class function CoDOMDocument30.Create: IXMLDOMDocument2;
begin
  Result := CreateComObject(CLASS_DOMDocument30) as IXMLDOMDocument2;
end;

class function CoDOMDocument30.CreateRemote(const MachineName: string): IXMLDOMDocument2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DOMDocument30) as IXMLDOMDocument2;
end;

procedure TDOMDocument30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F5078F32-C551-11D3-89B9-0000F81FE221}';
    IntfIID:   '{2933BF95-7B36-11D2-B20E-00C04F983E60}';
    EventIID:  '{3EFAA427-272F-11D2-836F-0000F87A7782}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDOMDocument30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IXMLDOMDocument2;
  end;
end;

procedure TDOMDocument30.ConnectTo(svrIntf: IXMLDOMDocument2);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TDOMDocument30.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TDOMDocument30.GetDefaultInterface: IXMLDOMDocument2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TDOMDocument30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDOMDocument30Properties.Create(Self);
{$ENDIF}
end;

destructor TDOMDocument30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDOMDocument30.GetServerProperties: TDOMDocument30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TDOMDocument30.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    198: if Assigned(FOnondataavailable) then
         FOnondataavailable(Self);
    -609: if Assigned(FOnonreadystatechange) then
         FOnonreadystatechange(Self);
  end; {case DispID}
end;

function TDOMDocument30.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TDOMDocument30.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TDOMDocument30._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

function TDOMDocument30.validate: IXMLDOMParseError;
begin
  Result := DefaultInterface.validate;
end;

procedure TDOMDocument30.setProperty(const name: WideString; value: OleVariant);
begin
  DefaultInterface.setProperty(name, value);
end;

function TDOMDocument30.getProperty(const name: WideString): OleVariant;
begin
  Result := DefaultInterface.getProperty(name);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDOMDocument30Properties.Create(AServer: TDOMDocument30);
begin
  inherited Create;
  FServer := AServer;
end;

function TDOMDocument30Properties.GetDefaultInterface: IXMLDOMDocument2;
begin
  Result := FServer.DefaultInterface;
end;

function TDOMDocument30Properties.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TDOMDocument30Properties.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TDOMDocument30Properties._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

{$ENDIF}

class function CoDOMDocument40.Create: IXMLDOMDocument2;
begin
  Result := CreateComObject(CLASS_DOMDocument40) as IXMLDOMDocument2;
end;

class function CoDOMDocument40.CreateRemote(const MachineName: string): IXMLDOMDocument2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DOMDocument40) as IXMLDOMDocument2;
end;

procedure TDOMDocument40.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{88D969C0-F192-11D4-A65F-0040963251E5}';
    IntfIID:   '{2933BF95-7B36-11D2-B20E-00C04F983E60}';
    EventIID:  '{3EFAA427-272F-11D2-836F-0000F87A7782}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDOMDocument40.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IXMLDOMDocument2;
  end;
end;

procedure TDOMDocument40.ConnectTo(svrIntf: IXMLDOMDocument2);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TDOMDocument40.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TDOMDocument40.GetDefaultInterface: IXMLDOMDocument2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TDOMDocument40.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDOMDocument40Properties.Create(Self);
{$ENDIF}
end;

destructor TDOMDocument40.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDOMDocument40.GetServerProperties: TDOMDocument40Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TDOMDocument40.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    198: if Assigned(FOnondataavailable) then
         FOnondataavailable(Self);
    -609: if Assigned(FOnonreadystatechange) then
         FOnonreadystatechange(Self);
  end; {case DispID}
end;

function TDOMDocument40.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TDOMDocument40.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TDOMDocument40._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

function TDOMDocument40.validate: IXMLDOMParseError;
begin
  Result := DefaultInterface.validate;
end;

procedure TDOMDocument40.setProperty(const name: WideString; value: OleVariant);
begin
  DefaultInterface.setProperty(name, value);
end;

function TDOMDocument40.getProperty(const name: WideString): OleVariant;
begin
  Result := DefaultInterface.getProperty(name);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDOMDocument40Properties.Create(AServer: TDOMDocument40);
begin
  inherited Create;
  FServer := AServer;
end;

function TDOMDocument40Properties.GetDefaultInterface: IXMLDOMDocument2;
begin
  Result := FServer.DefaultInterface;
end;

function TDOMDocument40Properties.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TDOMDocument40Properties.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TDOMDocument40Properties._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

{$ENDIF}

class function CoFreeThreadedDOMDocument.Create: IXMLDOMDocument2;
begin
  Result := CreateComObject(CLASS_FreeThreadedDOMDocument) as IXMLDOMDocument2;
end;

class function CoFreeThreadedDOMDocument.CreateRemote(const MachineName: string): IXMLDOMDocument2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FreeThreadedDOMDocument) as IXMLDOMDocument2;
end;

procedure TFreeThreadedDOMDocument.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F6D90F12-9C73-11D3-B32E-00C04F990BB4}';
    IntfIID:   '{2933BF95-7B36-11D2-B20E-00C04F983E60}';
    EventIID:  '{3EFAA427-272F-11D2-836F-0000F87A7782}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFreeThreadedDOMDocument.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IXMLDOMDocument2;
  end;
end;

procedure TFreeThreadedDOMDocument.ConnectTo(svrIntf: IXMLDOMDocument2);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TFreeThreadedDOMDocument.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TFreeThreadedDOMDocument.GetDefaultInterface: IXMLDOMDocument2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TFreeThreadedDOMDocument.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TFreeThreadedDOMDocumentProperties.Create(Self);
{$ENDIF}
end;

destructor TFreeThreadedDOMDocument.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TFreeThreadedDOMDocument.GetServerProperties: TFreeThreadedDOMDocumentProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TFreeThreadedDOMDocument.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    198: if Assigned(FOnondataavailable) then
         FOnondataavailable(Self);
    -609: if Assigned(FOnonreadystatechange) then
         FOnonreadystatechange(Self);
  end; {case DispID}
end;

function TFreeThreadedDOMDocument.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TFreeThreadedDOMDocument.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TFreeThreadedDOMDocument._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

function TFreeThreadedDOMDocument.validate: IXMLDOMParseError;
begin
  Result := DefaultInterface.validate;
end;

procedure TFreeThreadedDOMDocument.setProperty(const name: WideString; value: OleVariant);
begin
  DefaultInterface.setProperty(name, value);
end;

function TFreeThreadedDOMDocument.getProperty(const name: WideString): OleVariant;
begin
  Result := DefaultInterface.getProperty(name);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TFreeThreadedDOMDocumentProperties.Create(AServer: TFreeThreadedDOMDocument);
begin
  inherited Create;
  FServer := AServer;
end;

function TFreeThreadedDOMDocumentProperties.GetDefaultInterface: IXMLDOMDocument2;
begin
  Result := FServer.DefaultInterface;
end;

function TFreeThreadedDOMDocumentProperties.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TFreeThreadedDOMDocumentProperties.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TFreeThreadedDOMDocumentProperties._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

{$ENDIF}

class function CoFreeThreadedDOMDocument26.Create: IXMLDOMDocument2;
begin
  Result := CreateComObject(CLASS_FreeThreadedDOMDocument26) as IXMLDOMDocument2;
end;

class function CoFreeThreadedDOMDocument26.CreateRemote(const MachineName: string): IXMLDOMDocument2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FreeThreadedDOMDocument26) as IXMLDOMDocument2;
end;

procedure TFreeThreadedDOMDocument26.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F5078F1C-C551-11D3-89B9-0000F81FE221}';
    IntfIID:   '{2933BF95-7B36-11D2-B20E-00C04F983E60}';
    EventIID:  '{3EFAA427-272F-11D2-836F-0000F87A7782}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFreeThreadedDOMDocument26.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IXMLDOMDocument2;
  end;
end;

procedure TFreeThreadedDOMDocument26.ConnectTo(svrIntf: IXMLDOMDocument2);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TFreeThreadedDOMDocument26.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TFreeThreadedDOMDocument26.GetDefaultInterface: IXMLDOMDocument2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TFreeThreadedDOMDocument26.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TFreeThreadedDOMDocument26Properties.Create(Self);
{$ENDIF}
end;

destructor TFreeThreadedDOMDocument26.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TFreeThreadedDOMDocument26.GetServerProperties: TFreeThreadedDOMDocument26Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TFreeThreadedDOMDocument26.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    198: if Assigned(FOnondataavailable) then
         FOnondataavailable(Self);
    -609: if Assigned(FOnonreadystatechange) then
         FOnonreadystatechange(Self);
  end; {case DispID}
end;

function TFreeThreadedDOMDocument26.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TFreeThreadedDOMDocument26.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TFreeThreadedDOMDocument26._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

function TFreeThreadedDOMDocument26.validate: IXMLDOMParseError;
begin
  Result := DefaultInterface.validate;
end;

procedure TFreeThreadedDOMDocument26.setProperty(const name: WideString; value: OleVariant);
begin
  DefaultInterface.setProperty(name, value);
end;

function TFreeThreadedDOMDocument26.getProperty(const name: WideString): OleVariant;
begin
  Result := DefaultInterface.getProperty(name);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TFreeThreadedDOMDocument26Properties.Create(AServer: TFreeThreadedDOMDocument26);
begin
  inherited Create;
  FServer := AServer;
end;

function TFreeThreadedDOMDocument26Properties.GetDefaultInterface: IXMLDOMDocument2;
begin
  Result := FServer.DefaultInterface;
end;

function TFreeThreadedDOMDocument26Properties.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TFreeThreadedDOMDocument26Properties.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TFreeThreadedDOMDocument26Properties._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

{$ENDIF}

class function CoFreeThreadedDOMDocument30.Create: IXMLDOMDocument2;
begin
  Result := CreateComObject(CLASS_FreeThreadedDOMDocument30) as IXMLDOMDocument2;
end;

class function CoFreeThreadedDOMDocument30.CreateRemote(const MachineName: string): IXMLDOMDocument2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FreeThreadedDOMDocument30) as IXMLDOMDocument2;
end;

procedure TFreeThreadedDOMDocument30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F5078F33-C551-11D3-89B9-0000F81FE221}';
    IntfIID:   '{2933BF95-7B36-11D2-B20E-00C04F983E60}';
    EventIID:  '{3EFAA427-272F-11D2-836F-0000F87A7782}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFreeThreadedDOMDocument30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IXMLDOMDocument2;
  end;
end;

procedure TFreeThreadedDOMDocument30.ConnectTo(svrIntf: IXMLDOMDocument2);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TFreeThreadedDOMDocument30.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TFreeThreadedDOMDocument30.GetDefaultInterface: IXMLDOMDocument2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TFreeThreadedDOMDocument30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TFreeThreadedDOMDocument30Properties.Create(Self);
{$ENDIF}
end;

destructor TFreeThreadedDOMDocument30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TFreeThreadedDOMDocument30.GetServerProperties: TFreeThreadedDOMDocument30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TFreeThreadedDOMDocument30.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    198: if Assigned(FOnondataavailable) then
         FOnondataavailable(Self);
    -609: if Assigned(FOnonreadystatechange) then
         FOnonreadystatechange(Self);
  end; {case DispID}
end;

function TFreeThreadedDOMDocument30.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TFreeThreadedDOMDocument30.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TFreeThreadedDOMDocument30._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

function TFreeThreadedDOMDocument30.validate: IXMLDOMParseError;
begin
  Result := DefaultInterface.validate;
end;

procedure TFreeThreadedDOMDocument30.setProperty(const name: WideString; value: OleVariant);
begin
  DefaultInterface.setProperty(name, value);
end;

function TFreeThreadedDOMDocument30.getProperty(const name: WideString): OleVariant;
begin
  Result := DefaultInterface.getProperty(name);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TFreeThreadedDOMDocument30Properties.Create(AServer: TFreeThreadedDOMDocument30);
begin
  inherited Create;
  FServer := AServer;
end;

function TFreeThreadedDOMDocument30Properties.GetDefaultInterface: IXMLDOMDocument2;
begin
  Result := FServer.DefaultInterface;
end;

function TFreeThreadedDOMDocument30Properties.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TFreeThreadedDOMDocument30Properties.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TFreeThreadedDOMDocument30Properties._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

{$ENDIF}

class function CoFreeThreadedDOMDocument40.Create: IXMLDOMDocument2;
begin
  Result := CreateComObject(CLASS_FreeThreadedDOMDocument40) as IXMLDOMDocument2;
end;

class function CoFreeThreadedDOMDocument40.CreateRemote(const MachineName: string): IXMLDOMDocument2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FreeThreadedDOMDocument40) as IXMLDOMDocument2;
end;

procedure TFreeThreadedDOMDocument40.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{88D969C1-F192-11D4-A65F-0040963251E5}';
    IntfIID:   '{2933BF95-7B36-11D2-B20E-00C04F983E60}';
    EventIID:  '{3EFAA427-272F-11D2-836F-0000F87A7782}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFreeThreadedDOMDocument40.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IXMLDOMDocument2;
  end;
end;

procedure TFreeThreadedDOMDocument40.ConnectTo(svrIntf: IXMLDOMDocument2);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TFreeThreadedDOMDocument40.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TFreeThreadedDOMDocument40.GetDefaultInterface: IXMLDOMDocument2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TFreeThreadedDOMDocument40.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TFreeThreadedDOMDocument40Properties.Create(Self);
{$ENDIF}
end;

destructor TFreeThreadedDOMDocument40.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TFreeThreadedDOMDocument40.GetServerProperties: TFreeThreadedDOMDocument40Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TFreeThreadedDOMDocument40.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    198: if Assigned(FOnondataavailable) then
         FOnondataavailable(Self);
    -609: if Assigned(FOnonreadystatechange) then
         FOnonreadystatechange(Self);
  end; {case DispID}
end;

function TFreeThreadedDOMDocument40.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TFreeThreadedDOMDocument40.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TFreeThreadedDOMDocument40._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

function TFreeThreadedDOMDocument40.validate: IXMLDOMParseError;
begin
  Result := DefaultInterface.validate;
end;

procedure TFreeThreadedDOMDocument40.setProperty(const name: WideString; value: OleVariant);
begin
  DefaultInterface.setProperty(name, value);
end;

function TFreeThreadedDOMDocument40.getProperty(const name: WideString): OleVariant;
begin
  Result := DefaultInterface.getProperty(name);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TFreeThreadedDOMDocument40Properties.Create(AServer: TFreeThreadedDOMDocument40);
begin
  inherited Create;
  FServer := AServer;
end;

function TFreeThreadedDOMDocument40Properties.GetDefaultInterface: IXMLDOMDocument2;
begin
  Result := FServer.DefaultInterface;
end;

function TFreeThreadedDOMDocument40Properties.Get_namespaces: IXMLDOMSchemaCollection;
begin
    Result := DefaultInterface.namespaces;
end;

function TFreeThreadedDOMDocument40Properties.Get_schemas: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.schemas;
end;

procedure TFreeThreadedDOMDocument40Properties._Set_schemas(otherCollection: OleVariant);
  { Avertissement : cette propri�t� schemas a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.schemas := otherCollection;
end;

{$ENDIF}

class function CoXMLSchemaCache.Create: IXMLDOMSchemaCollection;
begin
  Result := CreateComObject(CLASS_XMLSchemaCache) as IXMLDOMSchemaCollection;
end;

class function CoXMLSchemaCache.CreateRemote(const MachineName: string): IXMLDOMSchemaCollection;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XMLSchemaCache) as IXMLDOMSchemaCollection;
end;

procedure TXMLSchemaCache.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{373984C9-B845-449B-91E7-45AC83036ADE}';
    IntfIID:   '{373984C8-B845-449B-91E7-45AC83036ADE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TXMLSchemaCache.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IXMLDOMSchemaCollection;
  end;
end;

procedure TXMLSchemaCache.ConnectTo(svrIntf: IXMLDOMSchemaCollection);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TXMLSchemaCache.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TXMLSchemaCache.GetDefaultInterface: IXMLDOMSchemaCollection;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TXMLSchemaCache.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TXMLSchemaCacheProperties.Create(Self);
{$ENDIF}
end;

destructor TXMLSchemaCache.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TXMLSchemaCache.GetServerProperties: TXMLSchemaCacheProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TXMLSchemaCache.Get_length: Integer;
begin
    Result := DefaultInterface.length;
end;

function TXMLSchemaCache.Get_namespaceURI(index: Integer): WideString;
begin
    Result := DefaultInterface.namespaceURI[index];
end;

procedure TXMLSchemaCache.add(const namespaceURI: WideString; var_: OleVariant);
begin
  DefaultInterface.add(namespaceURI, var_);
end;

function TXMLSchemaCache.get(const namespaceURI: WideString): IXMLDOMNode;
begin
  Result := DefaultInterface.get(namespaceURI);
end;

procedure TXMLSchemaCache.remove(const namespaceURI: WideString);
begin
  DefaultInterface.remove(namespaceURI);
end;

procedure TXMLSchemaCache.addCollection(const otherCollection: IXMLDOMSchemaCollection);
begin
  DefaultInterface.addCollection(otherCollection);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TXMLSchemaCacheProperties.Create(AServer: TXMLSchemaCache);
begin
  inherited Create;
  FServer := AServer;
end;

function TXMLSchemaCacheProperties.GetDefaultInterface: IXMLDOMSchemaCollection;
begin
  Result := FServer.DefaultInterface;
end;

function TXMLSchemaCacheProperties.Get_length: Integer;
begin
    Result := DefaultInterface.length;
end;

function TXMLSchemaCacheProperties.Get_namespaceURI(index: Integer): WideString;
begin
    Result := DefaultInterface.namespaceURI[index];
end;

{$ENDIF}

class function CoXMLSchemaCache26.Create: IXMLDOMSchemaCollection;
begin
  Result := CreateComObject(CLASS_XMLSchemaCache26) as IXMLDOMSchemaCollection;
end;

class function CoXMLSchemaCache26.CreateRemote(const MachineName: string): IXMLDOMSchemaCollection;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XMLSchemaCache26) as IXMLDOMSchemaCollection;
end;

procedure TXMLSchemaCache26.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F5078F1D-C551-11D3-89B9-0000F81FE221}';
    IntfIID:   '{373984C8-B845-449B-91E7-45AC83036ADE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TXMLSchemaCache26.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IXMLDOMSchemaCollection;
  end;
end;

procedure TXMLSchemaCache26.ConnectTo(svrIntf: IXMLDOMSchemaCollection);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TXMLSchemaCache26.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TXMLSchemaCache26.GetDefaultInterface: IXMLDOMSchemaCollection;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TXMLSchemaCache26.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TXMLSchemaCache26Properties.Create(Self);
{$ENDIF}
end;

destructor TXMLSchemaCache26.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TXMLSchemaCache26.GetServerProperties: TXMLSchemaCache26Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function TXMLSchemaCache26.Get_length: Integer;
begin
    Result := DefaultInterface.length;
end;

function TXMLSchemaCache26.Get_namespaceURI(index: Integer): WideString;
begin
    Result := DefaultInterface.namespaceURI[index];
end;

procedure TXMLSchemaCache26.add(const namespaceURI: WideString; var_: OleVariant);
begin
  DefaultInterface.add(namespaceURI, var_);
end;

function TXMLSchemaCache26.get(const namespaceURI: WideString): IXMLDOMNode;
begin
  Result := DefaultInterface.get(namespaceURI);
end;

procedure TXMLSchemaCache26.remove(const namespaceURI: WideString);
begin
  DefaultInterface.remove(namespaceURI);
end;

procedure TXMLSchemaCache26.addCollection(const otherCollection: IXMLDOMSchemaCollection);
begin
  DefaultInterface.addCollection(otherCollection);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TXMLSchemaCache26Properties.Create(AServer: TXMLSchemaCache26);
begin
  inherited Create;
  FServer := AServer;
end;

function TXMLSchemaCache26Properties.GetDefaultInterface: IXMLDOMSchemaCollection;
begin
  Result := FServer.DefaultInterface;
end;

function TXMLSchemaCache26Properties.Get_length: Integer;
begin
    Result := DefaultInterface.length;
end;

function TXMLSchemaCache26Properties.Get_namespaceURI(index: Integer): WideString;
begin
    Result := DefaultInterface.namespaceURI[index];
end;

{$ENDIF}

class function CoXMLSchemaCache30.Create: IXMLDOMSchemaCollection;
begin
  Result := CreateComObject(CLASS_XMLSchemaCache30) as IXMLDOMSchemaCollection;
end;

class function CoXMLSchemaCache30.CreateRemote(const MachineName: string): IXMLDOMSchemaCollection;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XMLSchemaCache30) as IXMLDOMSchemaCollection;
end;

procedure TXMLSchemaCache30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F5078F34-C551-11D3-89B9-0000F81FE221}';
    IntfIID:   '{373984C8-B845-449B-91E7-45AC83036ADE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TXMLSchemaCache30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IXMLDOMSchemaCollection;
  end;
end;

procedure TXMLSchemaCache30.ConnectTo(svrIntf: IXMLDOMSchemaCollection);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TXMLSchemaCache30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TXMLSchemaCache30.GetDefaultInterface: IXMLDOMSchemaCollection;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TXMLSchemaCache30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TXMLSchemaCache30Properties.Create(Self);
{$ENDIF}
end;

destructor TXMLSchemaCache30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TXMLSchemaCache30.GetServerProperties: TXMLSchemaCache30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function TXMLSchemaCache30.Get_length: Integer;
begin
    Result := DefaultInterface.length;
end;

function TXMLSchemaCache30.Get_namespaceURI(index: Integer): WideString;
begin
    Result := DefaultInterface.namespaceURI[index];
end;

procedure TXMLSchemaCache30.add(const namespaceURI: WideString; var_: OleVariant);
begin
  DefaultInterface.add(namespaceURI, var_);
end;

function TXMLSchemaCache30.get(const namespaceURI: WideString): IXMLDOMNode;
begin
  Result := DefaultInterface.get(namespaceURI);
end;

procedure TXMLSchemaCache30.remove(const namespaceURI: WideString);
begin
  DefaultInterface.remove(namespaceURI);
end;

procedure TXMLSchemaCache30.addCollection(const otherCollection: IXMLDOMSchemaCollection);
begin
  DefaultInterface.addCollection(otherCollection);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TXMLSchemaCache30Properties.Create(AServer: TXMLSchemaCache30);
begin
  inherited Create;
  FServer := AServer;
end;

function TXMLSchemaCache30Properties.GetDefaultInterface: IXMLDOMSchemaCollection;
begin
  Result := FServer.DefaultInterface;
end;

function TXMLSchemaCache30Properties.Get_length: Integer;
begin
    Result := DefaultInterface.length;
end;

function TXMLSchemaCache30Properties.Get_namespaceURI(index: Integer): WideString;
begin
    Result := DefaultInterface.namespaceURI[index];
end;

{$ENDIF}

class function CoXMLSchemaCache40.Create: IXMLDOMSchemaCollection2;
begin
  Result := CreateComObject(CLASS_XMLSchemaCache40) as IXMLDOMSchemaCollection2;
end;

class function CoXMLSchemaCache40.CreateRemote(const MachineName: string): IXMLDOMSchemaCollection2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XMLSchemaCache40) as IXMLDOMSchemaCollection2;
end;

procedure TXMLSchemaCache40.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{88D969C2-F192-11D4-A65F-0040963251E5}';
    IntfIID:   '{50EA08B0-DD1B-4664-9A50-C2F40F4BD79A}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TXMLSchemaCache40.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IXMLDOMSchemaCollection2;
  end;
end;

procedure TXMLSchemaCache40.ConnectTo(svrIntf: IXMLDOMSchemaCollection2);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TXMLSchemaCache40.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TXMLSchemaCache40.GetDefaultInterface: IXMLDOMSchemaCollection2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TXMLSchemaCache40.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TXMLSchemaCache40Properties.Create(Self);
{$ENDIF}
end;

destructor TXMLSchemaCache40.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TXMLSchemaCache40.GetServerProperties: TXMLSchemaCache40Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TXMLSchemaCache40.Set_validateOnLoad(validateOnLoad: WordBool);
begin
  DefaultInterface.Set_validateOnLoad(validateOnLoad);
end;

function TXMLSchemaCache40.Get_validateOnLoad: WordBool;
begin
    Result := DefaultInterface.validateOnLoad;
end;

procedure TXMLSchemaCache40.validate;
begin
  DefaultInterface.validate;
end;

function TXMLSchemaCache40.getSchema(const namespaceURI: WideString): ISchema;
begin
  Result := DefaultInterface.getSchema(namespaceURI);
end;

function TXMLSchemaCache40.getDeclaration(const node: IXMLDOMNode): ISchemaItem;
begin
  Result := DefaultInterface.getDeclaration(node);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TXMLSchemaCache40Properties.Create(AServer: TXMLSchemaCache40);
begin
  inherited Create;
  FServer := AServer;
end;

function TXMLSchemaCache40Properties.GetDefaultInterface: IXMLDOMSchemaCollection2;
begin
  Result := FServer.DefaultInterface;
end;

procedure TXMLSchemaCache40Properties.Set_validateOnLoad(validateOnLoad: WordBool);
begin
  DefaultInterface.Set_validateOnLoad(validateOnLoad);
end;

function TXMLSchemaCache40Properties.Get_validateOnLoad: WordBool;
begin
    Result := DefaultInterface.validateOnLoad;
end;

{$ENDIF}

class function CoXSLTemplate.Create: IXSLTemplate;
begin
  Result := CreateComObject(CLASS_XSLTemplate) as IXSLTemplate;
end;

class function CoXSLTemplate.CreateRemote(const MachineName: string): IXSLTemplate;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XSLTemplate) as IXSLTemplate;
end;

procedure TXSLTemplate.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2933BF94-7B36-11D2-B20E-00C04F983E60}';
    IntfIID:   '{2933BF93-7B36-11D2-B20E-00C04F983E60}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TXSLTemplate.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IXSLTemplate;
  end;
end;

procedure TXSLTemplate.ConnectTo(svrIntf: IXSLTemplate);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TXSLTemplate.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TXSLTemplate.GetDefaultInterface: IXSLTemplate;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TXSLTemplate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TXSLTemplateProperties.Create(Self);
{$ENDIF}
end;

destructor TXSLTemplate.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TXSLTemplate.GetServerProperties: TXSLTemplateProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TXSLTemplate._Set_stylesheet(const stylesheet: IXMLDOMNode);
  { Avertissement : cette propri�t� stylesheet a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.stylesheet := stylesheet;
end;

function TXSLTemplate.Get_stylesheet: IXMLDOMNode;
begin
    Result := DefaultInterface.stylesheet;
end;

function TXSLTemplate.createProcessor: IXSLProcessor;
begin
  Result := DefaultInterface.createProcessor;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TXSLTemplateProperties.Create(AServer: TXSLTemplate);
begin
  inherited Create;
  FServer := AServer;
end;

function TXSLTemplateProperties.GetDefaultInterface: IXSLTemplate;
begin
  Result := FServer.DefaultInterface;
end;

procedure TXSLTemplateProperties._Set_stylesheet(const stylesheet: IXMLDOMNode);
  { Avertissement : cette propri�t� stylesheet a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.stylesheet := stylesheet;
end;

function TXSLTemplateProperties.Get_stylesheet: IXMLDOMNode;
begin
    Result := DefaultInterface.stylesheet;
end;

{$ENDIF}

class function CoXSLTemplate26.Create: IXSLTemplate;
begin
  Result := CreateComObject(CLASS_XSLTemplate26) as IXSLTemplate;
end;

class function CoXSLTemplate26.CreateRemote(const MachineName: string): IXSLTemplate;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XSLTemplate26) as IXSLTemplate;
end;

procedure TXSLTemplate26.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F5078F21-C551-11D3-89B9-0000F81FE221}';
    IntfIID:   '{2933BF93-7B36-11D2-B20E-00C04F983E60}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TXSLTemplate26.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IXSLTemplate;
  end;
end;

procedure TXSLTemplate26.ConnectTo(svrIntf: IXSLTemplate);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TXSLTemplate26.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TXSLTemplate26.GetDefaultInterface: IXSLTemplate;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TXSLTemplate26.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TXSLTemplate26Properties.Create(Self);
{$ENDIF}
end;

destructor TXSLTemplate26.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TXSLTemplate26.GetServerProperties: TXSLTemplate26Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TXSLTemplate26._Set_stylesheet(const stylesheet: IXMLDOMNode);
  { Avertissement : cette propri�t� stylesheet a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.stylesheet := stylesheet;
end;

function TXSLTemplate26.Get_stylesheet: IXMLDOMNode;
begin
    Result := DefaultInterface.stylesheet;
end;

function TXSLTemplate26.createProcessor: IXSLProcessor;
begin
  Result := DefaultInterface.createProcessor;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TXSLTemplate26Properties.Create(AServer: TXSLTemplate26);
begin
  inherited Create;
  FServer := AServer;
end;

function TXSLTemplate26Properties.GetDefaultInterface: IXSLTemplate;
begin
  Result := FServer.DefaultInterface;
end;

procedure TXSLTemplate26Properties._Set_stylesheet(const stylesheet: IXMLDOMNode);
  { Avertissement : cette propri�t� stylesheet a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.stylesheet := stylesheet;
end;

function TXSLTemplate26Properties.Get_stylesheet: IXMLDOMNode;
begin
    Result := DefaultInterface.stylesheet;
end;

{$ENDIF}

class function CoXSLTemplate30.Create: IXSLTemplate;
begin
  Result := CreateComObject(CLASS_XSLTemplate30) as IXSLTemplate;
end;

class function CoXSLTemplate30.CreateRemote(const MachineName: string): IXSLTemplate;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XSLTemplate30) as IXSLTemplate;
end;

procedure TXSLTemplate30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F5078F36-C551-11D3-89B9-0000F81FE221}';
    IntfIID:   '{2933BF93-7B36-11D2-B20E-00C04F983E60}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TXSLTemplate30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IXSLTemplate;
  end;
end;

procedure TXSLTemplate30.ConnectTo(svrIntf: IXSLTemplate);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TXSLTemplate30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TXSLTemplate30.GetDefaultInterface: IXSLTemplate;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TXSLTemplate30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TXSLTemplate30Properties.Create(Self);
{$ENDIF}
end;

destructor TXSLTemplate30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TXSLTemplate30.GetServerProperties: TXSLTemplate30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TXSLTemplate30._Set_stylesheet(const stylesheet: IXMLDOMNode);
  { Avertissement : cette propri�t� stylesheet a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.stylesheet := stylesheet;
end;

function TXSLTemplate30.Get_stylesheet: IXMLDOMNode;
begin
    Result := DefaultInterface.stylesheet;
end;

function TXSLTemplate30.createProcessor: IXSLProcessor;
begin
  Result := DefaultInterface.createProcessor;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TXSLTemplate30Properties.Create(AServer: TXSLTemplate30);
begin
  inherited Create;
  FServer := AServer;
end;

function TXSLTemplate30Properties.GetDefaultInterface: IXSLTemplate;
begin
  Result := FServer.DefaultInterface;
end;

procedure TXSLTemplate30Properties._Set_stylesheet(const stylesheet: IXMLDOMNode);
  { Avertissement : cette propri�t� stylesheet a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.stylesheet := stylesheet;
end;

function TXSLTemplate30Properties.Get_stylesheet: IXMLDOMNode;
begin
    Result := DefaultInterface.stylesheet;
end;

{$ENDIF}

class function CoXSLTemplate40.Create: IXSLTemplate;
begin
  Result := CreateComObject(CLASS_XSLTemplate40) as IXSLTemplate;
end;

class function CoXSLTemplate40.CreateRemote(const MachineName: string): IXSLTemplate;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XSLTemplate40) as IXSLTemplate;
end;

procedure TXSLTemplate40.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{88D969C3-F192-11D4-A65F-0040963251E5}';
    IntfIID:   '{2933BF93-7B36-11D2-B20E-00C04F983E60}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TXSLTemplate40.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IXSLTemplate;
  end;
end;

procedure TXSLTemplate40.ConnectTo(svrIntf: IXSLTemplate);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TXSLTemplate40.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TXSLTemplate40.GetDefaultInterface: IXSLTemplate;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TXSLTemplate40.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TXSLTemplate40Properties.Create(Self);
{$ENDIF}
end;

destructor TXSLTemplate40.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TXSLTemplate40.GetServerProperties: TXSLTemplate40Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TXSLTemplate40._Set_stylesheet(const stylesheet: IXMLDOMNode);
  { Avertissement : cette propri�t� stylesheet a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.stylesheet := stylesheet;
end;

function TXSLTemplate40.Get_stylesheet: IXMLDOMNode;
begin
    Result := DefaultInterface.stylesheet;
end;

function TXSLTemplate40.createProcessor: IXSLProcessor;
begin
  Result := DefaultInterface.createProcessor;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TXSLTemplate40Properties.Create(AServer: TXSLTemplate40);
begin
  inherited Create;
  FServer := AServer;
end;

function TXSLTemplate40Properties.GetDefaultInterface: IXSLTemplate;
begin
  Result := FServer.DefaultInterface;
end;

procedure TXSLTemplate40Properties._Set_stylesheet(const stylesheet: IXMLDOMNode);
  { Avertissement : cette propri�t� stylesheet a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.stylesheet := stylesheet;
end;

function TXSLTemplate40Properties.Get_stylesheet: IXMLDOMNode;
begin
    Result := DefaultInterface.stylesheet;
end;

{$ENDIF}

class function CoDSOControl.Create: IDSOControl;
begin
  Result := CreateComObject(CLASS_DSOControl) as IDSOControl;
end;

class function CoDSOControl.CreateRemote(const MachineName: string): IDSOControl;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSOControl) as IDSOControl;
end;

procedure TDSOControl.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F6D90F14-9C73-11D3-B32E-00C04F990BB4}';
    IntfIID:   '{310AFA62-0575-11D2-9CA9-0060B0EC3D39}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDSOControl.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDSOControl;
  end;
end;

procedure TDSOControl.ConnectTo(svrIntf: IDSOControl);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDSOControl.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDSOControl.GetDefaultInterface: IDSOControl;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TDSOControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDSOControlProperties.Create(Self);
{$ENDIF}
end;

destructor TDSOControl.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDSOControl.GetServerProperties: TDSOControlProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TDSOControl.Get_XMLDocument: IXMLDOMDocument;
begin
    Result := DefaultInterface.XMLDocument;
end;

procedure TDSOControl.Set_XMLDocument(const ppDoc: IXMLDOMDocument);
begin
  DefaultInterface.Set_XMLDocument(ppDoc);
end;

function TDSOControl.Get_JavaDSOCompatible: Integer;
begin
    Result := DefaultInterface.JavaDSOCompatible;
end;

procedure TDSOControl.Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
begin
  DefaultInterface.Set_JavaDSOCompatible(fJavaDSOCompatible);
end;

function TDSOControl.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDSOControlProperties.Create(AServer: TDSOControl);
begin
  inherited Create;
  FServer := AServer;
end;

function TDSOControlProperties.GetDefaultInterface: IDSOControl;
begin
  Result := FServer.DefaultInterface;
end;

function TDSOControlProperties.Get_XMLDocument: IXMLDOMDocument;
begin
    Result := DefaultInterface.XMLDocument;
end;

procedure TDSOControlProperties.Set_XMLDocument(const ppDoc: IXMLDOMDocument);
begin
  DefaultInterface.Set_XMLDocument(ppDoc);
end;

function TDSOControlProperties.Get_JavaDSOCompatible: Integer;
begin
    Result := DefaultInterface.JavaDSOCompatible;
end;

procedure TDSOControlProperties.Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
begin
  DefaultInterface.Set_JavaDSOCompatible(fJavaDSOCompatible);
end;

function TDSOControlProperties.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

{$ENDIF}

class function CoDSOControl26.Create: IDSOControl;
begin
  Result := CreateComObject(CLASS_DSOControl26) as IDSOControl;
end;

class function CoDSOControl26.CreateRemote(const MachineName: string): IDSOControl;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSOControl26) as IDSOControl;
end;

procedure TDSOControl26.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F5078F1F-C551-11D3-89B9-0000F81FE221}';
    IntfIID:   '{310AFA62-0575-11D2-9CA9-0060B0EC3D39}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDSOControl26.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDSOControl;
  end;
end;

procedure TDSOControl26.ConnectTo(svrIntf: IDSOControl);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDSOControl26.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDSOControl26.GetDefaultInterface: IDSOControl;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TDSOControl26.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDSOControl26Properties.Create(Self);
{$ENDIF}
end;

destructor TDSOControl26.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDSOControl26.GetServerProperties: TDSOControl26Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function TDSOControl26.Get_XMLDocument: IXMLDOMDocument;
begin
    Result := DefaultInterface.XMLDocument;
end;

procedure TDSOControl26.Set_XMLDocument(const ppDoc: IXMLDOMDocument);
begin
  DefaultInterface.Set_XMLDocument(ppDoc);
end;

function TDSOControl26.Get_JavaDSOCompatible: Integer;
begin
    Result := DefaultInterface.JavaDSOCompatible;
end;

procedure TDSOControl26.Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
begin
  DefaultInterface.Set_JavaDSOCompatible(fJavaDSOCompatible);
end;

function TDSOControl26.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDSOControl26Properties.Create(AServer: TDSOControl26);
begin
  inherited Create;
  FServer := AServer;
end;

function TDSOControl26Properties.GetDefaultInterface: IDSOControl;
begin
  Result := FServer.DefaultInterface;
end;

function TDSOControl26Properties.Get_XMLDocument: IXMLDOMDocument;
begin
    Result := DefaultInterface.XMLDocument;
end;

procedure TDSOControl26Properties.Set_XMLDocument(const ppDoc: IXMLDOMDocument);
begin
  DefaultInterface.Set_XMLDocument(ppDoc);
end;

function TDSOControl26Properties.Get_JavaDSOCompatible: Integer;
begin
    Result := DefaultInterface.JavaDSOCompatible;
end;

procedure TDSOControl26Properties.Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
begin
  DefaultInterface.Set_JavaDSOCompatible(fJavaDSOCompatible);
end;

function TDSOControl26Properties.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

{$ENDIF}

class function CoDSOControl30.Create: IDSOControl;
begin
  Result := CreateComObject(CLASS_DSOControl30) as IDSOControl;
end;

class function CoDSOControl30.CreateRemote(const MachineName: string): IDSOControl;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSOControl30) as IDSOControl;
end;

procedure TDSOControl30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F5078F39-C551-11D3-89B9-0000F81FE221}';
    IntfIID:   '{310AFA62-0575-11D2-9CA9-0060B0EC3D39}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDSOControl30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDSOControl;
  end;
end;

procedure TDSOControl30.ConnectTo(svrIntf: IDSOControl);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDSOControl30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDSOControl30.GetDefaultInterface: IDSOControl;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TDSOControl30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDSOControl30Properties.Create(Self);
{$ENDIF}
end;

destructor TDSOControl30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDSOControl30.GetServerProperties: TDSOControl30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function TDSOControl30.Get_XMLDocument: IXMLDOMDocument;
begin
    Result := DefaultInterface.XMLDocument;
end;

procedure TDSOControl30.Set_XMLDocument(const ppDoc: IXMLDOMDocument);
begin
  DefaultInterface.Set_XMLDocument(ppDoc);
end;

function TDSOControl30.Get_JavaDSOCompatible: Integer;
begin
    Result := DefaultInterface.JavaDSOCompatible;
end;

procedure TDSOControl30.Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
begin
  DefaultInterface.Set_JavaDSOCompatible(fJavaDSOCompatible);
end;

function TDSOControl30.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDSOControl30Properties.Create(AServer: TDSOControl30);
begin
  inherited Create;
  FServer := AServer;
end;

function TDSOControl30Properties.GetDefaultInterface: IDSOControl;
begin
  Result := FServer.DefaultInterface;
end;

function TDSOControl30Properties.Get_XMLDocument: IXMLDOMDocument;
begin
    Result := DefaultInterface.XMLDocument;
end;

procedure TDSOControl30Properties.Set_XMLDocument(const ppDoc: IXMLDOMDocument);
begin
  DefaultInterface.Set_XMLDocument(ppDoc);
end;

function TDSOControl30Properties.Get_JavaDSOCompatible: Integer;
begin
    Result := DefaultInterface.JavaDSOCompatible;
end;

procedure TDSOControl30Properties.Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
begin
  DefaultInterface.Set_JavaDSOCompatible(fJavaDSOCompatible);
end;

function TDSOControl30Properties.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

{$ENDIF}

class function CoDSOControl40.Create: IDSOControl;
begin
  Result := CreateComObject(CLASS_DSOControl40) as IDSOControl;
end;

class function CoDSOControl40.CreateRemote(const MachineName: string): IDSOControl;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DSOControl40) as IDSOControl;
end;

procedure TDSOControl40.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{88D969C4-F192-11D4-A65F-0040963251E5}';
    IntfIID:   '{310AFA62-0575-11D2-9CA9-0060B0EC3D39}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDSOControl40.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDSOControl;
  end;
end;

procedure TDSOControl40.ConnectTo(svrIntf: IDSOControl);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDSOControl40.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDSOControl40.GetDefaultInterface: IDSOControl;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TDSOControl40.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDSOControl40Properties.Create(Self);
{$ENDIF}
end;

destructor TDSOControl40.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDSOControl40.GetServerProperties: TDSOControl40Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function TDSOControl40.Get_XMLDocument: IXMLDOMDocument;
begin
    Result := DefaultInterface.XMLDocument;
end;

procedure TDSOControl40.Set_XMLDocument(const ppDoc: IXMLDOMDocument);
begin
  DefaultInterface.Set_XMLDocument(ppDoc);
end;

function TDSOControl40.Get_JavaDSOCompatible: Integer;
begin
    Result := DefaultInterface.JavaDSOCompatible;
end;

procedure TDSOControl40.Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
begin
  DefaultInterface.Set_JavaDSOCompatible(fJavaDSOCompatible);
end;

function TDSOControl40.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDSOControl40Properties.Create(AServer: TDSOControl40);
begin
  inherited Create;
  FServer := AServer;
end;

function TDSOControl40Properties.GetDefaultInterface: IDSOControl;
begin
  Result := FServer.DefaultInterface;
end;

function TDSOControl40Properties.Get_XMLDocument: IXMLDOMDocument;
begin
    Result := DefaultInterface.XMLDocument;
end;

procedure TDSOControl40Properties.Set_XMLDocument(const ppDoc: IXMLDOMDocument);
begin
  DefaultInterface.Set_XMLDocument(ppDoc);
end;

function TDSOControl40Properties.Get_JavaDSOCompatible: Integer;
begin
    Result := DefaultInterface.JavaDSOCompatible;
end;

procedure TDSOControl40Properties.Set_JavaDSOCompatible(fJavaDSOCompatible: Integer);
begin
  DefaultInterface.Set_JavaDSOCompatible(fJavaDSOCompatible);
end;

function TDSOControl40Properties.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

{$ENDIF}

class function CoXMLHTTP.Create: IXMLHTTPRequest;
begin
  Result := CreateComObject(CLASS_XMLHTTP) as IXMLHTTPRequest;
end;

class function CoXMLHTTP.CreateRemote(const MachineName: string): IXMLHTTPRequest;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XMLHTTP) as IXMLHTTPRequest;
end;

procedure TXMLHTTP.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F6D90F16-9C73-11D3-B32E-00C04F990BB4}';
    IntfIID:   '{ED8C108D-4349-11D2-91A4-00C04F7969E8}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TXMLHTTP.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IXMLHTTPRequest;
  end;
end;

procedure TXMLHTTP.ConnectTo(svrIntf: IXMLHTTPRequest);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TXMLHTTP.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TXMLHTTP.GetDefaultInterface: IXMLHTTPRequest;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TXMLHTTP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TXMLHTTPProperties.Create(Self);
{$ENDIF}
end;

destructor TXMLHTTP.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TXMLHTTP.GetServerProperties: TXMLHTTPProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TXMLHTTP.Get_status: Integer;
begin
    Result := DefaultInterface.status;
end;

function TXMLHTTP.Get_statusText: WideString;
begin
    Result := DefaultInterface.statusText;
end;

function TXMLHTTP.Get_responseXML: IDispatch;
begin
    Result := DefaultInterface.responseXML;
end;

function TXMLHTTP.Get_responseText: WideString;
begin
    Result := DefaultInterface.responseText;
end;

function TXMLHTTP.Get_responseBody: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseBody;
end;

function TXMLHTTP.Get_responseStream: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseStream;
end;

function TXMLHTTP.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

procedure TXMLHTTP.Set_onreadystatechange(const Param1: IDispatch);
begin
  DefaultInterface.Set_onreadystatechange(Param1);
end;

procedure TXMLHTTP.open(const bstrMethod: WideString; const bstrUrl: WideString);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, EmptyParam, EmptyParam, EmptyParam);
end;

procedure TXMLHTTP.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                        varAsync: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, EmptyParam, EmptyParam);
end;

procedure TXMLHTTP.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                        varAsync: OleVariant; bstrUser: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, bstrUser, EmptyParam);
end;

procedure TXMLHTTP.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                        varAsync: OleVariant; bstrUser: OleVariant; bstrPassword: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, bstrUser, bstrPassword);
end;

procedure TXMLHTTP.setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString);
begin
  DefaultInterface.setRequestHeader(bstrHeader, bstrValue);
end;

function TXMLHTTP.getResponseHeader(const bstrHeader: WideString): WideString;
begin
  Result := DefaultInterface.getResponseHeader(bstrHeader);
end;

function TXMLHTTP.getAllResponseHeaders: WideString;
begin
  Result := DefaultInterface.getAllResponseHeaders;
end;

procedure TXMLHTTP.send;
begin
  DefaultInterface.send(EmptyParam);
end;

procedure TXMLHTTP.send(varBody: OleVariant);
begin
  DefaultInterface.send(varBody);
end;

procedure TXMLHTTP.abort;
begin
  DefaultInterface.abort;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TXMLHTTPProperties.Create(AServer: TXMLHTTP);
begin
  inherited Create;
  FServer := AServer;
end;

function TXMLHTTPProperties.GetDefaultInterface: IXMLHTTPRequest;
begin
  Result := FServer.DefaultInterface;
end;

function TXMLHTTPProperties.Get_status: Integer;
begin
    Result := DefaultInterface.status;
end;

function TXMLHTTPProperties.Get_statusText: WideString;
begin
    Result := DefaultInterface.statusText;
end;

function TXMLHTTPProperties.Get_responseXML: IDispatch;
begin
    Result := DefaultInterface.responseXML;
end;

function TXMLHTTPProperties.Get_responseText: WideString;
begin
    Result := DefaultInterface.responseText;
end;

function TXMLHTTPProperties.Get_responseBody: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseBody;
end;

function TXMLHTTPProperties.Get_responseStream: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseStream;
end;

function TXMLHTTPProperties.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

procedure TXMLHTTPProperties.Set_onreadystatechange(const Param1: IDispatch);
begin
  DefaultInterface.Set_onreadystatechange(Param1);
end;

{$ENDIF}

class function CoXMLHTTP26.Create: IXMLHTTPRequest;
begin
  Result := CreateComObject(CLASS_XMLHTTP26) as IXMLHTTPRequest;
end;

class function CoXMLHTTP26.CreateRemote(const MachineName: string): IXMLHTTPRequest;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XMLHTTP26) as IXMLHTTPRequest;
end;

procedure TXMLHTTP26.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F5078F1E-C551-11D3-89B9-0000F81FE221}';
    IntfIID:   '{ED8C108D-4349-11D2-91A4-00C04F7969E8}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TXMLHTTP26.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IXMLHTTPRequest;
  end;
end;

procedure TXMLHTTP26.ConnectTo(svrIntf: IXMLHTTPRequest);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TXMLHTTP26.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TXMLHTTP26.GetDefaultInterface: IXMLHTTPRequest;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TXMLHTTP26.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TXMLHTTP26Properties.Create(Self);
{$ENDIF}
end;

destructor TXMLHTTP26.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TXMLHTTP26.GetServerProperties: TXMLHTTP26Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function TXMLHTTP26.Get_status: Integer;
begin
    Result := DefaultInterface.status;
end;

function TXMLHTTP26.Get_statusText: WideString;
begin
    Result := DefaultInterface.statusText;
end;

function TXMLHTTP26.Get_responseXML: IDispatch;
begin
    Result := DefaultInterface.responseXML;
end;

function TXMLHTTP26.Get_responseText: WideString;
begin
    Result := DefaultInterface.responseText;
end;

function TXMLHTTP26.Get_responseBody: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseBody;
end;

function TXMLHTTP26.Get_responseStream: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseStream;
end;

function TXMLHTTP26.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

procedure TXMLHTTP26.Set_onreadystatechange(const Param1: IDispatch);
begin
  DefaultInterface.Set_onreadystatechange(Param1);
end;

procedure TXMLHTTP26.open(const bstrMethod: WideString; const bstrUrl: WideString);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, EmptyParam, EmptyParam, EmptyParam);
end;

procedure TXMLHTTP26.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                          varAsync: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, EmptyParam, EmptyParam);
end;

procedure TXMLHTTP26.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                          varAsync: OleVariant; bstrUser: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, bstrUser, EmptyParam);
end;

procedure TXMLHTTP26.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                          varAsync: OleVariant; bstrUser: OleVariant; bstrPassword: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, bstrUser, bstrPassword);
end;

procedure TXMLHTTP26.setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString);
begin
  DefaultInterface.setRequestHeader(bstrHeader, bstrValue);
end;

function TXMLHTTP26.getResponseHeader(const bstrHeader: WideString): WideString;
begin
  Result := DefaultInterface.getResponseHeader(bstrHeader);
end;

function TXMLHTTP26.getAllResponseHeaders: WideString;
begin
  Result := DefaultInterface.getAllResponseHeaders;
end;

procedure TXMLHTTP26.send;
begin
  DefaultInterface.send(EmptyParam);
end;

procedure TXMLHTTP26.send(varBody: OleVariant);
begin
  DefaultInterface.send(varBody);
end;

procedure TXMLHTTP26.abort;
begin
  DefaultInterface.abort;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TXMLHTTP26Properties.Create(AServer: TXMLHTTP26);
begin
  inherited Create;
  FServer := AServer;
end;

function TXMLHTTP26Properties.GetDefaultInterface: IXMLHTTPRequest;
begin
  Result := FServer.DefaultInterface;
end;

function TXMLHTTP26Properties.Get_status: Integer;
begin
    Result := DefaultInterface.status;
end;

function TXMLHTTP26Properties.Get_statusText: WideString;
begin
    Result := DefaultInterface.statusText;
end;

function TXMLHTTP26Properties.Get_responseXML: IDispatch;
begin
    Result := DefaultInterface.responseXML;
end;

function TXMLHTTP26Properties.Get_responseText: WideString;
begin
    Result := DefaultInterface.responseText;
end;

function TXMLHTTP26Properties.Get_responseBody: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseBody;
end;

function TXMLHTTP26Properties.Get_responseStream: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseStream;
end;

function TXMLHTTP26Properties.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

procedure TXMLHTTP26Properties.Set_onreadystatechange(const Param1: IDispatch);
begin
  DefaultInterface.Set_onreadystatechange(Param1);
end;

{$ENDIF}

class function CoXMLHTTP30.Create: IXMLHTTPRequest;
begin
  Result := CreateComObject(CLASS_XMLHTTP30) as IXMLHTTPRequest;
end;

class function CoXMLHTTP30.CreateRemote(const MachineName: string): IXMLHTTPRequest;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XMLHTTP30) as IXMLHTTPRequest;
end;

procedure TXMLHTTP30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F5078F35-C551-11D3-89B9-0000F81FE221}';
    IntfIID:   '{ED8C108D-4349-11D2-91A4-00C04F7969E8}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TXMLHTTP30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IXMLHTTPRequest;
  end;
end;

procedure TXMLHTTP30.ConnectTo(svrIntf: IXMLHTTPRequest);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TXMLHTTP30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TXMLHTTP30.GetDefaultInterface: IXMLHTTPRequest;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TXMLHTTP30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TXMLHTTP30Properties.Create(Self);
{$ENDIF}
end;

destructor TXMLHTTP30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TXMLHTTP30.GetServerProperties: TXMLHTTP30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function TXMLHTTP30.Get_status: Integer;
begin
    Result := DefaultInterface.status;
end;

function TXMLHTTP30.Get_statusText: WideString;
begin
    Result := DefaultInterface.statusText;
end;

function TXMLHTTP30.Get_responseXML: IDispatch;
begin
    Result := DefaultInterface.responseXML;
end;

function TXMLHTTP30.Get_responseText: WideString;
begin
    Result := DefaultInterface.responseText;
end;

function TXMLHTTP30.Get_responseBody: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseBody;
end;

function TXMLHTTP30.Get_responseStream: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseStream;
end;

function TXMLHTTP30.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

procedure TXMLHTTP30.Set_onreadystatechange(const Param1: IDispatch);
begin
  DefaultInterface.Set_onreadystatechange(Param1);
end;

procedure TXMLHTTP30.open(const bstrMethod: WideString; const bstrUrl: WideString);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, EmptyParam, EmptyParam, EmptyParam);
end;

procedure TXMLHTTP30.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                          varAsync: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, EmptyParam, EmptyParam);
end;

procedure TXMLHTTP30.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                          varAsync: OleVariant; bstrUser: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, bstrUser, EmptyParam);
end;

procedure TXMLHTTP30.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                          varAsync: OleVariant; bstrUser: OleVariant; bstrPassword: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, bstrUser, bstrPassword);
end;

procedure TXMLHTTP30.setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString);
begin
  DefaultInterface.setRequestHeader(bstrHeader, bstrValue);
end;

function TXMLHTTP30.getResponseHeader(const bstrHeader: WideString): WideString;
begin
  Result := DefaultInterface.getResponseHeader(bstrHeader);
end;

function TXMLHTTP30.getAllResponseHeaders: WideString;
begin
  Result := DefaultInterface.getAllResponseHeaders;
end;

procedure TXMLHTTP30.send;
begin
  DefaultInterface.send(EmptyParam);
end;

procedure TXMLHTTP30.send(varBody: OleVariant);
begin
  DefaultInterface.send(varBody);
end;

procedure TXMLHTTP30.abort;
begin
  DefaultInterface.abort;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TXMLHTTP30Properties.Create(AServer: TXMLHTTP30);
begin
  inherited Create;
  FServer := AServer;
end;

function TXMLHTTP30Properties.GetDefaultInterface: IXMLHTTPRequest;
begin
  Result := FServer.DefaultInterface;
end;

function TXMLHTTP30Properties.Get_status: Integer;
begin
    Result := DefaultInterface.status;
end;

function TXMLHTTP30Properties.Get_statusText: WideString;
begin
    Result := DefaultInterface.statusText;
end;

function TXMLHTTP30Properties.Get_responseXML: IDispatch;
begin
    Result := DefaultInterface.responseXML;
end;

function TXMLHTTP30Properties.Get_responseText: WideString;
begin
    Result := DefaultInterface.responseText;
end;

function TXMLHTTP30Properties.Get_responseBody: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseBody;
end;

function TXMLHTTP30Properties.Get_responseStream: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseStream;
end;

function TXMLHTTP30Properties.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

procedure TXMLHTTP30Properties.Set_onreadystatechange(const Param1: IDispatch);
begin
  DefaultInterface.Set_onreadystatechange(Param1);
end;

{$ENDIF}

class function CoXMLHTTP40.Create: IXMLHTTPRequest;
begin
  Result := CreateComObject(CLASS_XMLHTTP40) as IXMLHTTPRequest;
end;

class function CoXMLHTTP40.CreateRemote(const MachineName: string): IXMLHTTPRequest;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XMLHTTP40) as IXMLHTTPRequest;
end;

procedure TXMLHTTP40.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{88D969C5-F192-11D4-A65F-0040963251E5}';
    IntfIID:   '{ED8C108D-4349-11D2-91A4-00C04F7969E8}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TXMLHTTP40.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IXMLHTTPRequest;
  end;
end;

procedure TXMLHTTP40.ConnectTo(svrIntf: IXMLHTTPRequest);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TXMLHTTP40.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TXMLHTTP40.GetDefaultInterface: IXMLHTTPRequest;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TXMLHTTP40.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TXMLHTTP40Properties.Create(Self);
{$ENDIF}
end;

destructor TXMLHTTP40.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TXMLHTTP40.GetServerProperties: TXMLHTTP40Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function TXMLHTTP40.Get_status: Integer;
begin
    Result := DefaultInterface.status;
end;

function TXMLHTTP40.Get_statusText: WideString;
begin
    Result := DefaultInterface.statusText;
end;

function TXMLHTTP40.Get_responseXML: IDispatch;
begin
    Result := DefaultInterface.responseXML;
end;

function TXMLHTTP40.Get_responseText: WideString;
begin
    Result := DefaultInterface.responseText;
end;

function TXMLHTTP40.Get_responseBody: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseBody;
end;

function TXMLHTTP40.Get_responseStream: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseStream;
end;

function TXMLHTTP40.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

procedure TXMLHTTP40.Set_onreadystatechange(const Param1: IDispatch);
begin
  DefaultInterface.Set_onreadystatechange(Param1);
end;

procedure TXMLHTTP40.open(const bstrMethod: WideString; const bstrUrl: WideString);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, EmptyParam, EmptyParam, EmptyParam);
end;

procedure TXMLHTTP40.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                          varAsync: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, EmptyParam, EmptyParam);
end;

procedure TXMLHTTP40.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                          varAsync: OleVariant; bstrUser: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, bstrUser, EmptyParam);
end;

procedure TXMLHTTP40.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                          varAsync: OleVariant; bstrUser: OleVariant; bstrPassword: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, bstrUser, bstrPassword);
end;

procedure TXMLHTTP40.setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString);
begin
  DefaultInterface.setRequestHeader(bstrHeader, bstrValue);
end;

function TXMLHTTP40.getResponseHeader(const bstrHeader: WideString): WideString;
begin
  Result := DefaultInterface.getResponseHeader(bstrHeader);
end;

function TXMLHTTP40.getAllResponseHeaders: WideString;
begin
  Result := DefaultInterface.getAllResponseHeaders;
end;

procedure TXMLHTTP40.send;
begin
  DefaultInterface.send(EmptyParam);
end;

procedure TXMLHTTP40.send(varBody: OleVariant);
begin
  DefaultInterface.send(varBody);
end;

procedure TXMLHTTP40.abort;
begin
  DefaultInterface.abort;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TXMLHTTP40Properties.Create(AServer: TXMLHTTP40);
begin
  inherited Create;
  FServer := AServer;
end;

function TXMLHTTP40Properties.GetDefaultInterface: IXMLHTTPRequest;
begin
  Result := FServer.DefaultInterface;
end;

function TXMLHTTP40Properties.Get_status: Integer;
begin
    Result := DefaultInterface.status;
end;

function TXMLHTTP40Properties.Get_statusText: WideString;
begin
    Result := DefaultInterface.statusText;
end;

function TXMLHTTP40Properties.Get_responseXML: IDispatch;
begin
    Result := DefaultInterface.responseXML;
end;

function TXMLHTTP40Properties.Get_responseText: WideString;
begin
    Result := DefaultInterface.responseText;
end;

function TXMLHTTP40Properties.Get_responseBody: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseBody;
end;

function TXMLHTTP40Properties.Get_responseStream: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseStream;
end;

function TXMLHTTP40Properties.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

procedure TXMLHTTP40Properties.Set_onreadystatechange(const Param1: IDispatch);
begin
  DefaultInterface.Set_onreadystatechange(Param1);
end;

{$ENDIF}

class function CoServerXMLHTTP.Create: IServerXMLHTTPRequest2;
begin
  Result := CreateComObject(CLASS_ServerXMLHTTP) as IServerXMLHTTPRequest2;
end;

class function CoServerXMLHTTP.CreateRemote(const MachineName: string): IServerXMLHTTPRequest2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ServerXMLHTTP) as IServerXMLHTTPRequest2;
end;

procedure TServerXMLHTTP.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{AFBA6B42-5692-48EA-8141-DC517DCF0EF1}';
    IntfIID:   '{2E01311B-C322-4B0A-BD77-B90CFDC8DCE7}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TServerXMLHTTP.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IServerXMLHTTPRequest2;
  end;
end;

procedure TServerXMLHTTP.ConnectTo(svrIntf: IServerXMLHTTPRequest2);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TServerXMLHTTP.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TServerXMLHTTP.GetDefaultInterface: IServerXMLHTTPRequest2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TServerXMLHTTP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TServerXMLHTTPProperties.Create(Self);
{$ENDIF}
end;

destructor TServerXMLHTTP.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TServerXMLHTTP.GetServerProperties: TServerXMLHTTPProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TServerXMLHTTP.Get_status: Integer;
begin
    Result := DefaultInterface.status;
end;

function TServerXMLHTTP.Get_statusText: WideString;
begin
    Result := DefaultInterface.statusText;
end;

function TServerXMLHTTP.Get_responseXML: IDispatch;
begin
    Result := DefaultInterface.responseXML;
end;

function TServerXMLHTTP.Get_responseText: WideString;
begin
    Result := DefaultInterface.responseText;
end;

function TServerXMLHTTP.Get_responseBody: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseBody;
end;

function TServerXMLHTTP.Get_responseStream: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseStream;
end;

function TServerXMLHTTP.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

procedure TServerXMLHTTP.Set_onreadystatechange(const Param1: IDispatch);
begin
  DefaultInterface.Set_onreadystatechange(Param1);
end;

procedure TServerXMLHTTP.open(const bstrMethod: WideString; const bstrUrl: WideString);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, EmptyParam, EmptyParam, EmptyParam);
end;

procedure TServerXMLHTTP.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                              varAsync: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, EmptyParam, EmptyParam);
end;

procedure TServerXMLHTTP.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                              varAsync: OleVariant; bstrUser: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, bstrUser, EmptyParam);
end;

procedure TServerXMLHTTP.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                              varAsync: OleVariant; bstrUser: OleVariant; bstrPassword: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, bstrUser, bstrPassword);
end;

procedure TServerXMLHTTP.setRequestHeader(const bstrHeader: WideString; const bstrValue: WideString);
begin
  DefaultInterface.setRequestHeader(bstrHeader, bstrValue);
end;

function TServerXMLHTTP.getResponseHeader(const bstrHeader: WideString): WideString;
begin
  Result := DefaultInterface.getResponseHeader(bstrHeader);
end;

function TServerXMLHTTP.getAllResponseHeaders: WideString;
begin
  Result := DefaultInterface.getAllResponseHeaders;
end;

procedure TServerXMLHTTP.send;
begin
  DefaultInterface.send(EmptyParam);
end;

procedure TServerXMLHTTP.send(varBody: OleVariant);
begin
  DefaultInterface.send(varBody);
end;

procedure TServerXMLHTTP.abort;
begin
  DefaultInterface.abort;
end;

procedure TServerXMLHTTP.setTimeouts(resolveTimeout: Integer; connectTimeout: Integer; 
                                     sendTimeout: Integer; receiveTimeout: Integer);
begin
  DefaultInterface.setTimeouts(resolveTimeout, connectTimeout, sendTimeout, receiveTimeout);
end;

function TServerXMLHTTP.waitForResponse: WordBool;
begin
  Result := DefaultInterface.waitForResponse(EmptyParam);
end;

function TServerXMLHTTP.waitForResponse(timeoutInSeconds: OleVariant): WordBool;
begin
  Result := DefaultInterface.waitForResponse(timeoutInSeconds);
end;

function TServerXMLHTTP.getOption(option: SERVERXMLHTTP_OPTION): OleVariant;
begin
  Result := DefaultInterface.getOption(option);
end;

procedure TServerXMLHTTP.setOption(option: SERVERXMLHTTP_OPTION; value: OleVariant);
begin
  DefaultInterface.setOption(option, value);
end;

procedure TServerXMLHTTP.setProxy(proxySetting: SXH_PROXY_SETTING);
begin
  DefaultInterface.setProxy(proxySetting, EmptyParam, EmptyParam);
end;

procedure TServerXMLHTTP.setProxy(proxySetting: SXH_PROXY_SETTING; varProxyServer: OleVariant);
begin
  DefaultInterface.setProxy(proxySetting, varProxyServer, EmptyParam);
end;

procedure TServerXMLHTTP.setProxy(proxySetting: SXH_PROXY_SETTING; varProxyServer: OleVariant; 
                                  varBypassList: OleVariant);
begin
  DefaultInterface.setProxy(proxySetting, varProxyServer, varBypassList);
end;

procedure TServerXMLHTTP.setProxyCredentials(const bstrUserName: WideString; 
                                             const bstrPassword: WideString);
begin
  DefaultInterface.setProxyCredentials(bstrUserName, bstrPassword);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TServerXMLHTTPProperties.Create(AServer: TServerXMLHTTP);
begin
  inherited Create;
  FServer := AServer;
end;

function TServerXMLHTTPProperties.GetDefaultInterface: IServerXMLHTTPRequest2;
begin
  Result := FServer.DefaultInterface;
end;

function TServerXMLHTTPProperties.Get_status: Integer;
begin
    Result := DefaultInterface.status;
end;

function TServerXMLHTTPProperties.Get_statusText: WideString;
begin
    Result := DefaultInterface.statusText;
end;

function TServerXMLHTTPProperties.Get_responseXML: IDispatch;
begin
    Result := DefaultInterface.responseXML;
end;

function TServerXMLHTTPProperties.Get_responseText: WideString;
begin
    Result := DefaultInterface.responseText;
end;

function TServerXMLHTTPProperties.Get_responseBody: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseBody;
end;

function TServerXMLHTTPProperties.Get_responseStream: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseStream;
end;

function TServerXMLHTTPProperties.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

procedure TServerXMLHTTPProperties.Set_onreadystatechange(const Param1: IDispatch);
begin
  DefaultInterface.Set_onreadystatechange(Param1);
end;

{$ENDIF}

class function CoServerXMLHTTP30.Create: IServerXMLHTTPRequest2;
begin
  Result := CreateComObject(CLASS_ServerXMLHTTP30) as IServerXMLHTTPRequest2;
end;

class function CoServerXMLHTTP30.CreateRemote(const MachineName: string): IServerXMLHTTPRequest2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ServerXMLHTTP30) as IServerXMLHTTPRequest2;
end;

procedure TServerXMLHTTP30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{AFB40FFD-B609-40A3-9828-F88BBE11E4E3}';
    IntfIID:   '{2E01311B-C322-4B0A-BD77-B90CFDC8DCE7}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TServerXMLHTTP30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IServerXMLHTTPRequest2;
  end;
end;

procedure TServerXMLHTTP30.ConnectTo(svrIntf: IServerXMLHTTPRequest2);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TServerXMLHTTP30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TServerXMLHTTP30.GetDefaultInterface: IServerXMLHTTPRequest2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TServerXMLHTTP30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TServerXMLHTTP30Properties.Create(Self);
{$ENDIF}
end;

destructor TServerXMLHTTP30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TServerXMLHTTP30.GetServerProperties: TServerXMLHTTP30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function TServerXMLHTTP30.Get_status: Integer;
begin
    Result := DefaultInterface.status;
end;

function TServerXMLHTTP30.Get_statusText: WideString;
begin
    Result := DefaultInterface.statusText;
end;

function TServerXMLHTTP30.Get_responseXML: IDispatch;
begin
    Result := DefaultInterface.responseXML;
end;

function TServerXMLHTTP30.Get_responseText: WideString;
begin
    Result := DefaultInterface.responseText;
end;

function TServerXMLHTTP30.Get_responseBody: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseBody;
end;

function TServerXMLHTTP30.Get_responseStream: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseStream;
end;

function TServerXMLHTTP30.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

procedure TServerXMLHTTP30.Set_onreadystatechange(const Param1: IDispatch);
begin
  DefaultInterface.Set_onreadystatechange(Param1);
end;

procedure TServerXMLHTTP30.open(const bstrMethod: WideString; const bstrUrl: WideString);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, EmptyParam, EmptyParam, EmptyParam);
end;

procedure TServerXMLHTTP30.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                                varAsync: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, EmptyParam, EmptyParam);
end;

procedure TServerXMLHTTP30.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                                varAsync: OleVariant; bstrUser: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, bstrUser, EmptyParam);
end;

procedure TServerXMLHTTP30.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                                varAsync: OleVariant; bstrUser: OleVariant; bstrPassword: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, bstrUser, bstrPassword);
end;

procedure TServerXMLHTTP30.setRequestHeader(const bstrHeader: WideString; 
                                            const bstrValue: WideString);
begin
  DefaultInterface.setRequestHeader(bstrHeader, bstrValue);
end;

function TServerXMLHTTP30.getResponseHeader(const bstrHeader: WideString): WideString;
begin
  Result := DefaultInterface.getResponseHeader(bstrHeader);
end;

function TServerXMLHTTP30.getAllResponseHeaders: WideString;
begin
  Result := DefaultInterface.getAllResponseHeaders;
end;

procedure TServerXMLHTTP30.send;
begin
  DefaultInterface.send(EmptyParam);
end;

procedure TServerXMLHTTP30.send(varBody: OleVariant);
begin
  DefaultInterface.send(varBody);
end;

procedure TServerXMLHTTP30.abort;
begin
  DefaultInterface.abort;
end;

procedure TServerXMLHTTP30.setTimeouts(resolveTimeout: Integer; connectTimeout: Integer; 
                                       sendTimeout: Integer; receiveTimeout: Integer);
begin
  DefaultInterface.setTimeouts(resolveTimeout, connectTimeout, sendTimeout, receiveTimeout);
end;

function TServerXMLHTTP30.waitForResponse: WordBool;
begin
  Result := DefaultInterface.waitForResponse(EmptyParam);
end;

function TServerXMLHTTP30.waitForResponse(timeoutInSeconds: OleVariant): WordBool;
begin
  Result := DefaultInterface.waitForResponse(timeoutInSeconds);
end;

function TServerXMLHTTP30.getOption(option: SERVERXMLHTTP_OPTION): OleVariant;
begin
  Result := DefaultInterface.getOption(option);
end;

procedure TServerXMLHTTP30.setOption(option: SERVERXMLHTTP_OPTION; value: OleVariant);
begin
  DefaultInterface.setOption(option, value);
end;

procedure TServerXMLHTTP30.setProxy(proxySetting: SXH_PROXY_SETTING);
begin
  DefaultInterface.setProxy(proxySetting, EmptyParam, EmptyParam);
end;

procedure TServerXMLHTTP30.setProxy(proxySetting: SXH_PROXY_SETTING; varProxyServer: OleVariant);
begin
  DefaultInterface.setProxy(proxySetting, varProxyServer, EmptyParam);
end;

procedure TServerXMLHTTP30.setProxy(proxySetting: SXH_PROXY_SETTING; varProxyServer: OleVariant; 
                                    varBypassList: OleVariant);
begin
  DefaultInterface.setProxy(proxySetting, varProxyServer, varBypassList);
end;

procedure TServerXMLHTTP30.setProxyCredentials(const bstrUserName: WideString; 
                                               const bstrPassword: WideString);
begin
  DefaultInterface.setProxyCredentials(bstrUserName, bstrPassword);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TServerXMLHTTP30Properties.Create(AServer: TServerXMLHTTP30);
begin
  inherited Create;
  FServer := AServer;
end;

function TServerXMLHTTP30Properties.GetDefaultInterface: IServerXMLHTTPRequest2;
begin
  Result := FServer.DefaultInterface;
end;

function TServerXMLHTTP30Properties.Get_status: Integer;
begin
    Result := DefaultInterface.status;
end;

function TServerXMLHTTP30Properties.Get_statusText: WideString;
begin
    Result := DefaultInterface.statusText;
end;

function TServerXMLHTTP30Properties.Get_responseXML: IDispatch;
begin
    Result := DefaultInterface.responseXML;
end;

function TServerXMLHTTP30Properties.Get_responseText: WideString;
begin
    Result := DefaultInterface.responseText;
end;

function TServerXMLHTTP30Properties.Get_responseBody: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseBody;
end;

function TServerXMLHTTP30Properties.Get_responseStream: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseStream;
end;

function TServerXMLHTTP30Properties.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

procedure TServerXMLHTTP30Properties.Set_onreadystatechange(const Param1: IDispatch);
begin
  DefaultInterface.Set_onreadystatechange(Param1);
end;

{$ENDIF}

class function CoServerXMLHTTP40.Create: IServerXMLHTTPRequest2;
begin
  Result := CreateComObject(CLASS_ServerXMLHTTP40) as IServerXMLHTTPRequest2;
end;

class function CoServerXMLHTTP40.CreateRemote(const MachineName: string): IServerXMLHTTPRequest2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ServerXMLHTTP40) as IServerXMLHTTPRequest2;
end;

procedure TServerXMLHTTP40.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{88D969C6-F192-11D4-A65F-0040963251E5}';
    IntfIID:   '{2E01311B-C322-4B0A-BD77-B90CFDC8DCE7}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TServerXMLHTTP40.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IServerXMLHTTPRequest2;
  end;
end;

procedure TServerXMLHTTP40.ConnectTo(svrIntf: IServerXMLHTTPRequest2);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TServerXMLHTTP40.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TServerXMLHTTP40.GetDefaultInterface: IServerXMLHTTPRequest2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TServerXMLHTTP40.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TServerXMLHTTP40Properties.Create(Self);
{$ENDIF}
end;

destructor TServerXMLHTTP40.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TServerXMLHTTP40.GetServerProperties: TServerXMLHTTP40Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function TServerXMLHTTP40.Get_status: Integer;
begin
    Result := DefaultInterface.status;
end;

function TServerXMLHTTP40.Get_statusText: WideString;
begin
    Result := DefaultInterface.statusText;
end;

function TServerXMLHTTP40.Get_responseXML: IDispatch;
begin
    Result := DefaultInterface.responseXML;
end;

function TServerXMLHTTP40.Get_responseText: WideString;
begin
    Result := DefaultInterface.responseText;
end;

function TServerXMLHTTP40.Get_responseBody: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseBody;
end;

function TServerXMLHTTP40.Get_responseStream: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseStream;
end;

function TServerXMLHTTP40.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

procedure TServerXMLHTTP40.Set_onreadystatechange(const Param1: IDispatch);
begin
  DefaultInterface.Set_onreadystatechange(Param1);
end;

procedure TServerXMLHTTP40.open(const bstrMethod: WideString; const bstrUrl: WideString);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, EmptyParam, EmptyParam, EmptyParam);
end;

procedure TServerXMLHTTP40.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                                varAsync: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, EmptyParam, EmptyParam);
end;

procedure TServerXMLHTTP40.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                                varAsync: OleVariant; bstrUser: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, bstrUser, EmptyParam);
end;

procedure TServerXMLHTTP40.open(const bstrMethod: WideString; const bstrUrl: WideString; 
                                varAsync: OleVariant; bstrUser: OleVariant; bstrPassword: OleVariant);
begin
  DefaultInterface.open(bstrMethod, bstrUrl, varAsync, bstrUser, bstrPassword);
end;

procedure TServerXMLHTTP40.setRequestHeader(const bstrHeader: WideString; 
                                            const bstrValue: WideString);
begin
  DefaultInterface.setRequestHeader(bstrHeader, bstrValue);
end;

function TServerXMLHTTP40.getResponseHeader(const bstrHeader: WideString): WideString;
begin
  Result := DefaultInterface.getResponseHeader(bstrHeader);
end;

function TServerXMLHTTP40.getAllResponseHeaders: WideString;
begin
  Result := DefaultInterface.getAllResponseHeaders;
end;

procedure TServerXMLHTTP40.send;
begin
  DefaultInterface.send(EmptyParam);
end;

procedure TServerXMLHTTP40.send(varBody: OleVariant);
begin
  DefaultInterface.send(varBody);
end;

procedure TServerXMLHTTP40.abort;
begin
  DefaultInterface.abort;
end;

procedure TServerXMLHTTP40.setTimeouts(resolveTimeout: Integer; connectTimeout: Integer; 
                                       sendTimeout: Integer; receiveTimeout: Integer);
begin
  DefaultInterface.setTimeouts(resolveTimeout, connectTimeout, sendTimeout, receiveTimeout);
end;

function TServerXMLHTTP40.waitForResponse: WordBool;
begin
  Result := DefaultInterface.waitForResponse(EmptyParam);
end;

function TServerXMLHTTP40.waitForResponse(timeoutInSeconds: OleVariant): WordBool;
begin
  Result := DefaultInterface.waitForResponse(timeoutInSeconds);
end;

function TServerXMLHTTP40.getOption(option: SERVERXMLHTTP_OPTION): OleVariant;
begin
  Result := DefaultInterface.getOption(option);
end;

procedure TServerXMLHTTP40.setOption(option: SERVERXMLHTTP_OPTION; value: OleVariant);
begin
  DefaultInterface.setOption(option, value);
end;

procedure TServerXMLHTTP40.setProxy(proxySetting: SXH_PROXY_SETTING);
begin
  DefaultInterface.setProxy(proxySetting, EmptyParam, EmptyParam);
end;

procedure TServerXMLHTTP40.setProxy(proxySetting: SXH_PROXY_SETTING; varProxyServer: OleVariant);
begin
  DefaultInterface.setProxy(proxySetting, varProxyServer, EmptyParam);
end;

procedure TServerXMLHTTP40.setProxy(proxySetting: SXH_PROXY_SETTING; varProxyServer: OleVariant; 
                                    varBypassList: OleVariant);
begin
  DefaultInterface.setProxy(proxySetting, varProxyServer, varBypassList);
end;

procedure TServerXMLHTTP40.setProxyCredentials(const bstrUserName: WideString; 
                                               const bstrPassword: WideString);
begin
  DefaultInterface.setProxyCredentials(bstrUserName, bstrPassword);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TServerXMLHTTP40Properties.Create(AServer: TServerXMLHTTP40);
begin
  inherited Create;
  FServer := AServer;
end;

function TServerXMLHTTP40Properties.GetDefaultInterface: IServerXMLHTTPRequest2;
begin
  Result := FServer.DefaultInterface;
end;

function TServerXMLHTTP40Properties.Get_status: Integer;
begin
    Result := DefaultInterface.status;
end;

function TServerXMLHTTP40Properties.Get_statusText: WideString;
begin
    Result := DefaultInterface.statusText;
end;

function TServerXMLHTTP40Properties.Get_responseXML: IDispatch;
begin
    Result := DefaultInterface.responseXML;
end;

function TServerXMLHTTP40Properties.Get_responseText: WideString;
begin
    Result := DefaultInterface.responseText;
end;

function TServerXMLHTTP40Properties.Get_responseBody: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseBody;
end;

function TServerXMLHTTP40Properties.Get_responseStream: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.responseStream;
end;

function TServerXMLHTTP40Properties.Get_readyState: Integer;
begin
    Result := DefaultInterface.readyState;
end;

procedure TServerXMLHTTP40Properties.Set_onreadystatechange(const Param1: IDispatch);
begin
  DefaultInterface.Set_onreadystatechange(Param1);
end;

{$ENDIF}

class function CoSAXXMLReader.Create: IVBSAXXMLReader;
begin
  Result := CreateComObject(CLASS_SAXXMLReader) as IVBSAXXMLReader;
end;

class function CoSAXXMLReader.CreateRemote(const MachineName: string): IVBSAXXMLReader;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SAXXMLReader) as IVBSAXXMLReader;
end;

procedure TSAXXMLReader.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{079AA557-4A18-424A-8EEE-E39F0A8D41B9}';
    IntfIID:   '{8C033CAA-6CD6-4F73-B728-4531AF74945F}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSAXXMLReader.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IVBSAXXMLReader;
  end;
end;

procedure TSAXXMLReader.ConnectTo(svrIntf: IVBSAXXMLReader);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSAXXMLReader.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSAXXMLReader.GetDefaultInterface: IVBSAXXMLReader;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TSAXXMLReader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSAXXMLReaderProperties.Create(Self);
{$ENDIF}
end;

destructor TSAXXMLReader.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSAXXMLReader.GetServerProperties: TSAXXMLReaderProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TSAXXMLReader.Get_entityResolver: IVBSAXEntityResolver;
begin
    Result := DefaultInterface.entityResolver;
end;

procedure TSAXXMLReader._Set_entityResolver(const oResolver: IVBSAXEntityResolver);
  { Avertissement : cette propri�t� entityResolver a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.entityResolver := oResolver;
end;

function TSAXXMLReader.Get_contentHandler: IVBSAXContentHandler;
begin
    Result := DefaultInterface.contentHandler;
end;

procedure TSAXXMLReader._Set_contentHandler(const oHandler: IVBSAXContentHandler);
  { Avertissement : cette propri�t� contentHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.contentHandler := oHandler;
end;

function TSAXXMLReader.Get_dtdHandler: IVBSAXDTDHandler;
begin
    Result := DefaultInterface.dtdHandler;
end;

procedure TSAXXMLReader._Set_dtdHandler(const oHandler: IVBSAXDTDHandler);
  { Avertissement : cette propri�t� dtdHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.dtdHandler := oHandler;
end;

function TSAXXMLReader.Get_errorHandler: IVBSAXErrorHandler;
begin
    Result := DefaultInterface.errorHandler;
end;

procedure TSAXXMLReader._Set_errorHandler(const oHandler: IVBSAXErrorHandler);
  { Avertissement : cette propri�t� errorHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.errorHandler := oHandler;
end;

function TSAXXMLReader.Get_baseURL: WideString;
begin
    Result := DefaultInterface.baseURL;
end;

procedure TSAXXMLReader.Set_baseURL(const strBaseURL: WideString);
  { Avertissement : cette propri�t� baseURL a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.baseURL := strBaseURL;
end;

function TSAXXMLReader.Get_secureBaseURL: WideString;
begin
    Result := DefaultInterface.secureBaseURL;
end;

procedure TSAXXMLReader.Set_secureBaseURL(const strSecureBaseURL: WideString);
  { Avertissement : cette propri�t� secureBaseURL a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.secureBaseURL := strSecureBaseURL;
end;

function TSAXXMLReader.getFeature(const strName: WideString): WordBool;
begin
  Result := DefaultInterface.getFeature(strName);
end;

procedure TSAXXMLReader.putFeature(const strName: WideString; fValue: WordBool);
begin
  DefaultInterface.putFeature(strName, fValue);
end;

function TSAXXMLReader.getProperty(const strName: WideString): OleVariant;
begin
  Result := DefaultInterface.getProperty(strName);
end;

procedure TSAXXMLReader.putProperty(const strName: WideString; varValue: OleVariant);
begin
  DefaultInterface.putProperty(strName, varValue);
end;

procedure TSAXXMLReader.parse(varInput: OleVariant);
begin
  DefaultInterface.parse(varInput);
end;

procedure TSAXXMLReader.parseURL(const strURL: WideString);
begin
  DefaultInterface.parseURL(strURL);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSAXXMLReaderProperties.Create(AServer: TSAXXMLReader);
begin
  inherited Create;
  FServer := AServer;
end;

function TSAXXMLReaderProperties.GetDefaultInterface: IVBSAXXMLReader;
begin
  Result := FServer.DefaultInterface;
end;

function TSAXXMLReaderProperties.Get_entityResolver: IVBSAXEntityResolver;
begin
    Result := DefaultInterface.entityResolver;
end;

procedure TSAXXMLReaderProperties._Set_entityResolver(const oResolver: IVBSAXEntityResolver);
  { Avertissement : cette propri�t� entityResolver a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.entityResolver := oResolver;
end;

function TSAXXMLReaderProperties.Get_contentHandler: IVBSAXContentHandler;
begin
    Result := DefaultInterface.contentHandler;
end;

procedure TSAXXMLReaderProperties._Set_contentHandler(const oHandler: IVBSAXContentHandler);
  { Avertissement : cette propri�t� contentHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.contentHandler := oHandler;
end;

function TSAXXMLReaderProperties.Get_dtdHandler: IVBSAXDTDHandler;
begin
    Result := DefaultInterface.dtdHandler;
end;

procedure TSAXXMLReaderProperties._Set_dtdHandler(const oHandler: IVBSAXDTDHandler);
  { Avertissement : cette propri�t� dtdHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.dtdHandler := oHandler;
end;

function TSAXXMLReaderProperties.Get_errorHandler: IVBSAXErrorHandler;
begin
    Result := DefaultInterface.errorHandler;
end;

procedure TSAXXMLReaderProperties._Set_errorHandler(const oHandler: IVBSAXErrorHandler);
  { Avertissement : cette propri�t� errorHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.errorHandler := oHandler;
end;

function TSAXXMLReaderProperties.Get_baseURL: WideString;
begin
    Result := DefaultInterface.baseURL;
end;

procedure TSAXXMLReaderProperties.Set_baseURL(const strBaseURL: WideString);
  { Avertissement : cette propri�t� baseURL a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.baseURL := strBaseURL;
end;

function TSAXXMLReaderProperties.Get_secureBaseURL: WideString;
begin
    Result := DefaultInterface.secureBaseURL;
end;

procedure TSAXXMLReaderProperties.Set_secureBaseURL(const strSecureBaseURL: WideString);
  { Avertissement : cette propri�t� secureBaseURL a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.secureBaseURL := strSecureBaseURL;
end;

{$ENDIF}

class function CoSAXXMLReader30.Create: IVBSAXXMLReader;
begin
  Result := CreateComObject(CLASS_SAXXMLReader30) as IVBSAXXMLReader;
end;

class function CoSAXXMLReader30.CreateRemote(const MachineName: string): IVBSAXXMLReader;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SAXXMLReader30) as IVBSAXXMLReader;
end;

procedure TSAXXMLReader30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{3124C396-FB13-4836-A6AD-1317F1713688}';
    IntfIID:   '{8C033CAA-6CD6-4F73-B728-4531AF74945F}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSAXXMLReader30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IVBSAXXMLReader;
  end;
end;

procedure TSAXXMLReader30.ConnectTo(svrIntf: IVBSAXXMLReader);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSAXXMLReader30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSAXXMLReader30.GetDefaultInterface: IVBSAXXMLReader;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TSAXXMLReader30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSAXXMLReader30Properties.Create(Self);
{$ENDIF}
end;

destructor TSAXXMLReader30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSAXXMLReader30.GetServerProperties: TSAXXMLReader30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function TSAXXMLReader30.Get_entityResolver: IVBSAXEntityResolver;
begin
    Result := DefaultInterface.entityResolver;
end;

procedure TSAXXMLReader30._Set_entityResolver(const oResolver: IVBSAXEntityResolver);
  { Avertissement : cette propri�t� entityResolver a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.entityResolver := oResolver;
end;

function TSAXXMLReader30.Get_contentHandler: IVBSAXContentHandler;
begin
    Result := DefaultInterface.contentHandler;
end;

procedure TSAXXMLReader30._Set_contentHandler(const oHandler: IVBSAXContentHandler);
  { Avertissement : cette propri�t� contentHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.contentHandler := oHandler;
end;

function TSAXXMLReader30.Get_dtdHandler: IVBSAXDTDHandler;
begin
    Result := DefaultInterface.dtdHandler;
end;

procedure TSAXXMLReader30._Set_dtdHandler(const oHandler: IVBSAXDTDHandler);
  { Avertissement : cette propri�t� dtdHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.dtdHandler := oHandler;
end;

function TSAXXMLReader30.Get_errorHandler: IVBSAXErrorHandler;
begin
    Result := DefaultInterface.errorHandler;
end;

procedure TSAXXMLReader30._Set_errorHandler(const oHandler: IVBSAXErrorHandler);
  { Avertissement : cette propri�t� errorHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.errorHandler := oHandler;
end;

function TSAXXMLReader30.Get_baseURL: WideString;
begin
    Result := DefaultInterface.baseURL;
end;

procedure TSAXXMLReader30.Set_baseURL(const strBaseURL: WideString);
  { Avertissement : cette propri�t� baseURL a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.baseURL := strBaseURL;
end;

function TSAXXMLReader30.Get_secureBaseURL: WideString;
begin
    Result := DefaultInterface.secureBaseURL;
end;

procedure TSAXXMLReader30.Set_secureBaseURL(const strSecureBaseURL: WideString);
  { Avertissement : cette propri�t� secureBaseURL a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.secureBaseURL := strSecureBaseURL;
end;

function TSAXXMLReader30.getFeature(const strName: WideString): WordBool;
begin
  Result := DefaultInterface.getFeature(strName);
end;

procedure TSAXXMLReader30.putFeature(const strName: WideString; fValue: WordBool);
begin
  DefaultInterface.putFeature(strName, fValue);
end;

function TSAXXMLReader30.getProperty(const strName: WideString): OleVariant;
begin
  Result := DefaultInterface.getProperty(strName);
end;

procedure TSAXXMLReader30.putProperty(const strName: WideString; varValue: OleVariant);
begin
  DefaultInterface.putProperty(strName, varValue);
end;

procedure TSAXXMLReader30.parse(varInput: OleVariant);
begin
  DefaultInterface.parse(varInput);
end;

procedure TSAXXMLReader30.parseURL(const strURL: WideString);
begin
  DefaultInterface.parseURL(strURL);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSAXXMLReader30Properties.Create(AServer: TSAXXMLReader30);
begin
  inherited Create;
  FServer := AServer;
end;

function TSAXXMLReader30Properties.GetDefaultInterface: IVBSAXXMLReader;
begin
  Result := FServer.DefaultInterface;
end;

function TSAXXMLReader30Properties.Get_entityResolver: IVBSAXEntityResolver;
begin
    Result := DefaultInterface.entityResolver;
end;

procedure TSAXXMLReader30Properties._Set_entityResolver(const oResolver: IVBSAXEntityResolver);
  { Avertissement : cette propri�t� entityResolver a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.entityResolver := oResolver;
end;

function TSAXXMLReader30Properties.Get_contentHandler: IVBSAXContentHandler;
begin
    Result := DefaultInterface.contentHandler;
end;

procedure TSAXXMLReader30Properties._Set_contentHandler(const oHandler: IVBSAXContentHandler);
  { Avertissement : cette propri�t� contentHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.contentHandler := oHandler;
end;

function TSAXXMLReader30Properties.Get_dtdHandler: IVBSAXDTDHandler;
begin
    Result := DefaultInterface.dtdHandler;
end;

procedure TSAXXMLReader30Properties._Set_dtdHandler(const oHandler: IVBSAXDTDHandler);
  { Avertissement : cette propri�t� dtdHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.dtdHandler := oHandler;
end;

function TSAXXMLReader30Properties.Get_errorHandler: IVBSAXErrorHandler;
begin
    Result := DefaultInterface.errorHandler;
end;

procedure TSAXXMLReader30Properties._Set_errorHandler(const oHandler: IVBSAXErrorHandler);
  { Avertissement : cette propri�t� errorHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.errorHandler := oHandler;
end;

function TSAXXMLReader30Properties.Get_baseURL: WideString;
begin
    Result := DefaultInterface.baseURL;
end;

procedure TSAXXMLReader30Properties.Set_baseURL(const strBaseURL: WideString);
  { Avertissement : cette propri�t� baseURL a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.baseURL := strBaseURL;
end;

function TSAXXMLReader30Properties.Get_secureBaseURL: WideString;
begin
    Result := DefaultInterface.secureBaseURL;
end;

procedure TSAXXMLReader30Properties.Set_secureBaseURL(const strSecureBaseURL: WideString);
  { Avertissement : cette propri�t� secureBaseURL a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.secureBaseURL := strSecureBaseURL;
end;

{$ENDIF}

class function CoSAXXMLReader40.Create: IVBSAXXMLReader;
begin
  Result := CreateComObject(CLASS_SAXXMLReader40) as IVBSAXXMLReader;
end;

class function CoSAXXMLReader40.CreateRemote(const MachineName: string): IVBSAXXMLReader;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SAXXMLReader40) as IVBSAXXMLReader;
end;

procedure TSAXXMLReader40.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{7C6E29BC-8B8B-4C3D-859E-AF6CD158BE0F}';
    IntfIID:   '{8C033CAA-6CD6-4F73-B728-4531AF74945F}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSAXXMLReader40.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IVBSAXXMLReader;
  end;
end;

procedure TSAXXMLReader40.ConnectTo(svrIntf: IVBSAXXMLReader);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSAXXMLReader40.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSAXXMLReader40.GetDefaultInterface: IVBSAXXMLReader;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TSAXXMLReader40.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSAXXMLReader40Properties.Create(Self);
{$ENDIF}
end;

destructor TSAXXMLReader40.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSAXXMLReader40.GetServerProperties: TSAXXMLReader40Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function TSAXXMLReader40.Get_entityResolver: IVBSAXEntityResolver;
begin
    Result := DefaultInterface.entityResolver;
end;

procedure TSAXXMLReader40._Set_entityResolver(const oResolver: IVBSAXEntityResolver);
  { Avertissement : cette propri�t� entityResolver a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.entityResolver := oResolver;
end;

function TSAXXMLReader40.Get_contentHandler: IVBSAXContentHandler;
begin
    Result := DefaultInterface.contentHandler;
end;

procedure TSAXXMLReader40._Set_contentHandler(const oHandler: IVBSAXContentHandler);
  { Avertissement : cette propri�t� contentHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.contentHandler := oHandler;
end;

function TSAXXMLReader40.Get_dtdHandler: IVBSAXDTDHandler;
begin
    Result := DefaultInterface.dtdHandler;
end;

procedure TSAXXMLReader40._Set_dtdHandler(const oHandler: IVBSAXDTDHandler);
  { Avertissement : cette propri�t� dtdHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.dtdHandler := oHandler;
end;

function TSAXXMLReader40.Get_errorHandler: IVBSAXErrorHandler;
begin
    Result := DefaultInterface.errorHandler;
end;

procedure TSAXXMLReader40._Set_errorHandler(const oHandler: IVBSAXErrorHandler);
  { Avertissement : cette propri�t� errorHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.errorHandler := oHandler;
end;

function TSAXXMLReader40.Get_baseURL: WideString;
begin
    Result := DefaultInterface.baseURL;
end;

procedure TSAXXMLReader40.Set_baseURL(const strBaseURL: WideString);
  { Avertissement : cette propri�t� baseURL a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.baseURL := strBaseURL;
end;

function TSAXXMLReader40.Get_secureBaseURL: WideString;
begin
    Result := DefaultInterface.secureBaseURL;
end;

procedure TSAXXMLReader40.Set_secureBaseURL(const strSecureBaseURL: WideString);
  { Avertissement : cette propri�t� secureBaseURL a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.secureBaseURL := strSecureBaseURL;
end;

function TSAXXMLReader40.getFeature(const strName: WideString): WordBool;
begin
  Result := DefaultInterface.getFeature(strName);
end;

procedure TSAXXMLReader40.putFeature(const strName: WideString; fValue: WordBool);
begin
  DefaultInterface.putFeature(strName, fValue);
end;

function TSAXXMLReader40.getProperty(const strName: WideString): OleVariant;
begin
  Result := DefaultInterface.getProperty(strName);
end;

procedure TSAXXMLReader40.putProperty(const strName: WideString; varValue: OleVariant);
begin
  DefaultInterface.putProperty(strName, varValue);
end;

procedure TSAXXMLReader40.parse(varInput: OleVariant);
begin
  DefaultInterface.parse(varInput);
end;

procedure TSAXXMLReader40.parseURL(const strURL: WideString);
begin
  DefaultInterface.parseURL(strURL);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSAXXMLReader40Properties.Create(AServer: TSAXXMLReader40);
begin
  inherited Create;
  FServer := AServer;
end;

function TSAXXMLReader40Properties.GetDefaultInterface: IVBSAXXMLReader;
begin
  Result := FServer.DefaultInterface;
end;

function TSAXXMLReader40Properties.Get_entityResolver: IVBSAXEntityResolver;
begin
    Result := DefaultInterface.entityResolver;
end;

procedure TSAXXMLReader40Properties._Set_entityResolver(const oResolver: IVBSAXEntityResolver);
  { Avertissement : cette propri�t� entityResolver a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.entityResolver := oResolver;
end;

function TSAXXMLReader40Properties.Get_contentHandler: IVBSAXContentHandler;
begin
    Result := DefaultInterface.contentHandler;
end;

procedure TSAXXMLReader40Properties._Set_contentHandler(const oHandler: IVBSAXContentHandler);
  { Avertissement : cette propri�t� contentHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.contentHandler := oHandler;
end;

function TSAXXMLReader40Properties.Get_dtdHandler: IVBSAXDTDHandler;
begin
    Result := DefaultInterface.dtdHandler;
end;

procedure TSAXXMLReader40Properties._Set_dtdHandler(const oHandler: IVBSAXDTDHandler);
  { Avertissement : cette propri�t� dtdHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.dtdHandler := oHandler;
end;

function TSAXXMLReader40Properties.Get_errorHandler: IVBSAXErrorHandler;
begin
    Result := DefaultInterface.errorHandler;
end;

procedure TSAXXMLReader40Properties._Set_errorHandler(const oHandler: IVBSAXErrorHandler);
  { Avertissement : cette propri�t� errorHandler a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.errorHandler := oHandler;
end;

function TSAXXMLReader40Properties.Get_baseURL: WideString;
begin
    Result := DefaultInterface.baseURL;
end;

procedure TSAXXMLReader40Properties.Set_baseURL(const strBaseURL: WideString);
  { Avertissement : cette propri�t� baseURL a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.baseURL := strBaseURL;
end;

function TSAXXMLReader40Properties.Get_secureBaseURL: WideString;
begin
    Result := DefaultInterface.secureBaseURL;
end;

procedure TSAXXMLReader40Properties.Set_secureBaseURL(const strSecureBaseURL: WideString);
  { Avertissement : cette propri�t� secureBaseURL a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.secureBaseURL := strSecureBaseURL;
end;

{$ENDIF}

class function CoMXXMLWriter.Create: IMXWriter;
begin
  Result := CreateComObject(CLASS_MXXMLWriter) as IMXWriter;
end;

class function CoMXXMLWriter.CreateRemote(const MachineName: string): IMXWriter;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MXXMLWriter) as IMXWriter;
end;

procedure TMXXMLWriter.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{FC220AD8-A72A-4EE8-926E-0B7AD152A020}';
    IntfIID:   '{4D7FF4BA-1565-4EA8-94E1-6E724A46F98D}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMXXMLWriter.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IMXWriter;
  end;
end;

procedure TMXXMLWriter.ConnectTo(svrIntf: IMXWriter);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMXXMLWriter.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMXXMLWriter.GetDefaultInterface: IMXWriter;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TMXXMLWriter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMXXMLWriterProperties.Create(Self);
{$ENDIF}
end;

destructor TMXXMLWriter.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMXXMLWriter.GetServerProperties: TMXXMLWriterProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMXXMLWriter.Set_output(varDestination: OleVariant);
begin
  DefaultInterface.Set_output(varDestination);
end;

function TMXXMLWriter.Get_output: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.output;
end;

procedure TMXXMLWriter.Set_encoding(const strEncoding: WideString);
  { Avertissement : cette propri�t� encoding a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.encoding := strEncoding;
end;

function TMXXMLWriter.Get_encoding: WideString;
begin
    Result := DefaultInterface.encoding;
end;

procedure TMXXMLWriter.Set_byteOrderMark(fWriteByteOrderMark: WordBool);
begin
  DefaultInterface.Set_byteOrderMark(fWriteByteOrderMark);
end;

function TMXXMLWriter.Get_byteOrderMark: WordBool;
begin
    Result := DefaultInterface.byteOrderMark;
end;

procedure TMXXMLWriter.Set_indent(fIndentMode: WordBool);
begin
  DefaultInterface.Set_indent(fIndentMode);
end;

function TMXXMLWriter.Get_indent: WordBool;
begin
    Result := DefaultInterface.indent;
end;

procedure TMXXMLWriter.Set_standalone(fValue: WordBool);
begin
  DefaultInterface.Set_standalone(fValue);
end;

function TMXXMLWriter.Get_standalone: WordBool;
begin
    Result := DefaultInterface.standalone;
end;

procedure TMXXMLWriter.Set_omitXMLDeclaration(fValue: WordBool);
begin
  DefaultInterface.Set_omitXMLDeclaration(fValue);
end;

function TMXXMLWriter.Get_omitXMLDeclaration: WordBool;
begin
    Result := DefaultInterface.omitXMLDeclaration;
end;

procedure TMXXMLWriter.Set_version(const strVersion: WideString);
  { Avertissement : cette propri�t� version a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.version := strVersion;
end;

function TMXXMLWriter.Get_version: WideString;
begin
    Result := DefaultInterface.version;
end;

procedure TMXXMLWriter.Set_disableOutputEscaping(fValue: WordBool);
begin
  DefaultInterface.Set_disableOutputEscaping(fValue);
end;

function TMXXMLWriter.Get_disableOutputEscaping: WordBool;
begin
    Result := DefaultInterface.disableOutputEscaping;
end;

procedure TMXXMLWriter.flush;
begin
  DefaultInterface.flush;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMXXMLWriterProperties.Create(AServer: TMXXMLWriter);
begin
  inherited Create;
  FServer := AServer;
end;

function TMXXMLWriterProperties.GetDefaultInterface: IMXWriter;
begin
  Result := FServer.DefaultInterface;
end;

procedure TMXXMLWriterProperties.Set_output(varDestination: OleVariant);
begin
  DefaultInterface.Set_output(varDestination);
end;

function TMXXMLWriterProperties.Get_output: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.output;
end;

procedure TMXXMLWriterProperties.Set_encoding(const strEncoding: WideString);
  { Avertissement : cette propri�t� encoding a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.encoding := strEncoding;
end;

function TMXXMLWriterProperties.Get_encoding: WideString;
begin
    Result := DefaultInterface.encoding;
end;

procedure TMXXMLWriterProperties.Set_byteOrderMark(fWriteByteOrderMark: WordBool);
begin
  DefaultInterface.Set_byteOrderMark(fWriteByteOrderMark);
end;

function TMXXMLWriterProperties.Get_byteOrderMark: WordBool;
begin
    Result := DefaultInterface.byteOrderMark;
end;

procedure TMXXMLWriterProperties.Set_indent(fIndentMode: WordBool);
begin
  DefaultInterface.Set_indent(fIndentMode);
end;

function TMXXMLWriterProperties.Get_indent: WordBool;
begin
    Result := DefaultInterface.indent;
end;

procedure TMXXMLWriterProperties.Set_standalone(fValue: WordBool);
begin
  DefaultInterface.Set_standalone(fValue);
end;

function TMXXMLWriterProperties.Get_standalone: WordBool;
begin
    Result := DefaultInterface.standalone;
end;

procedure TMXXMLWriterProperties.Set_omitXMLDeclaration(fValue: WordBool);
begin
  DefaultInterface.Set_omitXMLDeclaration(fValue);
end;

function TMXXMLWriterProperties.Get_omitXMLDeclaration: WordBool;
begin
    Result := DefaultInterface.omitXMLDeclaration;
end;

procedure TMXXMLWriterProperties.Set_version(const strVersion: WideString);
  { Avertissement : cette propri�t� version a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.version := strVersion;
end;

function TMXXMLWriterProperties.Get_version: WideString;
begin
    Result := DefaultInterface.version;
end;

procedure TMXXMLWriterProperties.Set_disableOutputEscaping(fValue: WordBool);
begin
  DefaultInterface.Set_disableOutputEscaping(fValue);
end;

function TMXXMLWriterProperties.Get_disableOutputEscaping: WordBool;
begin
    Result := DefaultInterface.disableOutputEscaping;
end;

{$ENDIF}

class function CoMXXMLWriter30.Create: IMXWriter;
begin
  Result := CreateComObject(CLASS_MXXMLWriter30) as IMXWriter;
end;

class function CoMXXMLWriter30.CreateRemote(const MachineName: string): IMXWriter;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MXXMLWriter30) as IMXWriter;
end;

procedure TMXXMLWriter30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{3D813DFE-6C91-4A4E-8F41-04346A841D9C}';
    IntfIID:   '{4D7FF4BA-1565-4EA8-94E1-6E724A46F98D}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMXXMLWriter30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IMXWriter;
  end;
end;

procedure TMXXMLWriter30.ConnectTo(svrIntf: IMXWriter);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMXXMLWriter30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMXXMLWriter30.GetDefaultInterface: IMXWriter;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TMXXMLWriter30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMXXMLWriter30Properties.Create(Self);
{$ENDIF}
end;

destructor TMXXMLWriter30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMXXMLWriter30.GetServerProperties: TMXXMLWriter30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMXXMLWriter30.Set_output(varDestination: OleVariant);
begin
  DefaultInterface.Set_output(varDestination);
end;

function TMXXMLWriter30.Get_output: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.output;
end;

procedure TMXXMLWriter30.Set_encoding(const strEncoding: WideString);
  { Avertissement : cette propri�t� encoding a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.encoding := strEncoding;
end;

function TMXXMLWriter30.Get_encoding: WideString;
begin
    Result := DefaultInterface.encoding;
end;

procedure TMXXMLWriter30.Set_byteOrderMark(fWriteByteOrderMark: WordBool);
begin
  DefaultInterface.Set_byteOrderMark(fWriteByteOrderMark);
end;

function TMXXMLWriter30.Get_byteOrderMark: WordBool;
begin
    Result := DefaultInterface.byteOrderMark;
end;

procedure TMXXMLWriter30.Set_indent(fIndentMode: WordBool);
begin
  DefaultInterface.Set_indent(fIndentMode);
end;

function TMXXMLWriter30.Get_indent: WordBool;
begin
    Result := DefaultInterface.indent;
end;

procedure TMXXMLWriter30.Set_standalone(fValue: WordBool);
begin
  DefaultInterface.Set_standalone(fValue);
end;

function TMXXMLWriter30.Get_standalone: WordBool;
begin
    Result := DefaultInterface.standalone;
end;

procedure TMXXMLWriter30.Set_omitXMLDeclaration(fValue: WordBool);
begin
  DefaultInterface.Set_omitXMLDeclaration(fValue);
end;

function TMXXMLWriter30.Get_omitXMLDeclaration: WordBool;
begin
    Result := DefaultInterface.omitXMLDeclaration;
end;

procedure TMXXMLWriter30.Set_version(const strVersion: WideString);
  { Avertissement : cette propri�t� version a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.version := strVersion;
end;

function TMXXMLWriter30.Get_version: WideString;
begin
    Result := DefaultInterface.version;
end;

procedure TMXXMLWriter30.Set_disableOutputEscaping(fValue: WordBool);
begin
  DefaultInterface.Set_disableOutputEscaping(fValue);
end;

function TMXXMLWriter30.Get_disableOutputEscaping: WordBool;
begin
    Result := DefaultInterface.disableOutputEscaping;
end;

procedure TMXXMLWriter30.flush;
begin
  DefaultInterface.flush;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMXXMLWriter30Properties.Create(AServer: TMXXMLWriter30);
begin
  inherited Create;
  FServer := AServer;
end;

function TMXXMLWriter30Properties.GetDefaultInterface: IMXWriter;
begin
  Result := FServer.DefaultInterface;
end;

procedure TMXXMLWriter30Properties.Set_output(varDestination: OleVariant);
begin
  DefaultInterface.Set_output(varDestination);
end;

function TMXXMLWriter30Properties.Get_output: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.output;
end;

procedure TMXXMLWriter30Properties.Set_encoding(const strEncoding: WideString);
  { Avertissement : cette propri�t� encoding a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.encoding := strEncoding;
end;

function TMXXMLWriter30Properties.Get_encoding: WideString;
begin
    Result := DefaultInterface.encoding;
end;

procedure TMXXMLWriter30Properties.Set_byteOrderMark(fWriteByteOrderMark: WordBool);
begin
  DefaultInterface.Set_byteOrderMark(fWriteByteOrderMark);
end;

function TMXXMLWriter30Properties.Get_byteOrderMark: WordBool;
begin
    Result := DefaultInterface.byteOrderMark;
end;

procedure TMXXMLWriter30Properties.Set_indent(fIndentMode: WordBool);
begin
  DefaultInterface.Set_indent(fIndentMode);
end;

function TMXXMLWriter30Properties.Get_indent: WordBool;
begin
    Result := DefaultInterface.indent;
end;

procedure TMXXMLWriter30Properties.Set_standalone(fValue: WordBool);
begin
  DefaultInterface.Set_standalone(fValue);
end;

function TMXXMLWriter30Properties.Get_standalone: WordBool;
begin
    Result := DefaultInterface.standalone;
end;

procedure TMXXMLWriter30Properties.Set_omitXMLDeclaration(fValue: WordBool);
begin
  DefaultInterface.Set_omitXMLDeclaration(fValue);
end;

function TMXXMLWriter30Properties.Get_omitXMLDeclaration: WordBool;
begin
    Result := DefaultInterface.omitXMLDeclaration;
end;

procedure TMXXMLWriter30Properties.Set_version(const strVersion: WideString);
  { Avertissement : cette propri�t� version a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.version := strVersion;
end;

function TMXXMLWriter30Properties.Get_version: WideString;
begin
    Result := DefaultInterface.version;
end;

procedure TMXXMLWriter30Properties.Set_disableOutputEscaping(fValue: WordBool);
begin
  DefaultInterface.Set_disableOutputEscaping(fValue);
end;

function TMXXMLWriter30Properties.Get_disableOutputEscaping: WordBool;
begin
    Result := DefaultInterface.disableOutputEscaping;
end;

{$ENDIF}

class function CoMXXMLWriter40.Create: IMXWriter;
begin
  Result := CreateComObject(CLASS_MXXMLWriter40) as IMXWriter;
end;

class function CoMXXMLWriter40.CreateRemote(const MachineName: string): IMXWriter;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MXXMLWriter40) as IMXWriter;
end;

procedure TMXXMLWriter40.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{88D969C8-F192-11D4-A65F-0040963251E5}';
    IntfIID:   '{4D7FF4BA-1565-4EA8-94E1-6E724A46F98D}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMXXMLWriter40.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IMXWriter;
  end;
end;

procedure TMXXMLWriter40.ConnectTo(svrIntf: IMXWriter);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMXXMLWriter40.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMXXMLWriter40.GetDefaultInterface: IMXWriter;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TMXXMLWriter40.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMXXMLWriter40Properties.Create(Self);
{$ENDIF}
end;

destructor TMXXMLWriter40.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMXXMLWriter40.GetServerProperties: TMXXMLWriter40Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMXXMLWriter40.Set_output(varDestination: OleVariant);
begin
  DefaultInterface.Set_output(varDestination);
end;

function TMXXMLWriter40.Get_output: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.output;
end;

procedure TMXXMLWriter40.Set_encoding(const strEncoding: WideString);
  { Avertissement : cette propri�t� encoding a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.encoding := strEncoding;
end;

function TMXXMLWriter40.Get_encoding: WideString;
begin
    Result := DefaultInterface.encoding;
end;

procedure TMXXMLWriter40.Set_byteOrderMark(fWriteByteOrderMark: WordBool);
begin
  DefaultInterface.Set_byteOrderMark(fWriteByteOrderMark);
end;

function TMXXMLWriter40.Get_byteOrderMark: WordBool;
begin
    Result := DefaultInterface.byteOrderMark;
end;

procedure TMXXMLWriter40.Set_indent(fIndentMode: WordBool);
begin
  DefaultInterface.Set_indent(fIndentMode);
end;

function TMXXMLWriter40.Get_indent: WordBool;
begin
    Result := DefaultInterface.indent;
end;

procedure TMXXMLWriter40.Set_standalone(fValue: WordBool);
begin
  DefaultInterface.Set_standalone(fValue);
end;

function TMXXMLWriter40.Get_standalone: WordBool;
begin
    Result := DefaultInterface.standalone;
end;

procedure TMXXMLWriter40.Set_omitXMLDeclaration(fValue: WordBool);
begin
  DefaultInterface.Set_omitXMLDeclaration(fValue);
end;

function TMXXMLWriter40.Get_omitXMLDeclaration: WordBool;
begin
    Result := DefaultInterface.omitXMLDeclaration;
end;

procedure TMXXMLWriter40.Set_version(const strVersion: WideString);
  { Avertissement : cette propri�t� version a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.version := strVersion;
end;

function TMXXMLWriter40.Get_version: WideString;
begin
    Result := DefaultInterface.version;
end;

procedure TMXXMLWriter40.Set_disableOutputEscaping(fValue: WordBool);
begin
  DefaultInterface.Set_disableOutputEscaping(fValue);
end;

function TMXXMLWriter40.Get_disableOutputEscaping: WordBool;
begin
    Result := DefaultInterface.disableOutputEscaping;
end;

procedure TMXXMLWriter40.flush;
begin
  DefaultInterface.flush;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMXXMLWriter40Properties.Create(AServer: TMXXMLWriter40);
begin
  inherited Create;
  FServer := AServer;
end;

function TMXXMLWriter40Properties.GetDefaultInterface: IMXWriter;
begin
  Result := FServer.DefaultInterface;
end;

procedure TMXXMLWriter40Properties.Set_output(varDestination: OleVariant);
begin
  DefaultInterface.Set_output(varDestination);
end;

function TMXXMLWriter40Properties.Get_output: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.output;
end;

procedure TMXXMLWriter40Properties.Set_encoding(const strEncoding: WideString);
  { Avertissement : cette propri�t� encoding a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.encoding := strEncoding;
end;

function TMXXMLWriter40Properties.Get_encoding: WideString;
begin
    Result := DefaultInterface.encoding;
end;

procedure TMXXMLWriter40Properties.Set_byteOrderMark(fWriteByteOrderMark: WordBool);
begin
  DefaultInterface.Set_byteOrderMark(fWriteByteOrderMark);
end;

function TMXXMLWriter40Properties.Get_byteOrderMark: WordBool;
begin
    Result := DefaultInterface.byteOrderMark;
end;

procedure TMXXMLWriter40Properties.Set_indent(fIndentMode: WordBool);
begin
  DefaultInterface.Set_indent(fIndentMode);
end;

function TMXXMLWriter40Properties.Get_indent: WordBool;
begin
    Result := DefaultInterface.indent;
end;

procedure TMXXMLWriter40Properties.Set_standalone(fValue: WordBool);
begin
  DefaultInterface.Set_standalone(fValue);
end;

function TMXXMLWriter40Properties.Get_standalone: WordBool;
begin
    Result := DefaultInterface.standalone;
end;

procedure TMXXMLWriter40Properties.Set_omitXMLDeclaration(fValue: WordBool);
begin
  DefaultInterface.Set_omitXMLDeclaration(fValue);
end;

function TMXXMLWriter40Properties.Get_omitXMLDeclaration: WordBool;
begin
    Result := DefaultInterface.omitXMLDeclaration;
end;

procedure TMXXMLWriter40Properties.Set_version(const strVersion: WideString);
  { Avertissement : cette propri�t� version a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.version := strVersion;
end;

function TMXXMLWriter40Properties.Get_version: WideString;
begin
    Result := DefaultInterface.version;
end;

procedure TMXXMLWriter40Properties.Set_disableOutputEscaping(fValue: WordBool);
begin
  DefaultInterface.Set_disableOutputEscaping(fValue);
end;

function TMXXMLWriter40Properties.Get_disableOutputEscaping: WordBool;
begin
    Result := DefaultInterface.disableOutputEscaping;
end;

{$ENDIF}

class function CoMXHTMLWriter.Create: IMXWriter;
begin
  Result := CreateComObject(CLASS_MXHTMLWriter) as IMXWriter;
end;

class function CoMXHTMLWriter.CreateRemote(const MachineName: string): IMXWriter;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MXHTMLWriter) as IMXWriter;
end;

procedure TMXHTMLWriter.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{A4C23EC3-6B70-4466-9127-550077239978}';
    IntfIID:   '{4D7FF4BA-1565-4EA8-94E1-6E724A46F98D}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMXHTMLWriter.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IMXWriter;
  end;
end;

procedure TMXHTMLWriter.ConnectTo(svrIntf: IMXWriter);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMXHTMLWriter.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMXHTMLWriter.GetDefaultInterface: IMXWriter;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TMXHTMLWriter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMXHTMLWriterProperties.Create(Self);
{$ENDIF}
end;

destructor TMXHTMLWriter.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMXHTMLWriter.GetServerProperties: TMXHTMLWriterProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMXHTMLWriter.Set_output(varDestination: OleVariant);
begin
  DefaultInterface.Set_output(varDestination);
end;

function TMXHTMLWriter.Get_output: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.output;
end;

procedure TMXHTMLWriter.Set_encoding(const strEncoding: WideString);
  { Avertissement : cette propri�t� encoding a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.encoding := strEncoding;
end;

function TMXHTMLWriter.Get_encoding: WideString;
begin
    Result := DefaultInterface.encoding;
end;

procedure TMXHTMLWriter.Set_byteOrderMark(fWriteByteOrderMark: WordBool);
begin
  DefaultInterface.Set_byteOrderMark(fWriteByteOrderMark);
end;

function TMXHTMLWriter.Get_byteOrderMark: WordBool;
begin
    Result := DefaultInterface.byteOrderMark;
end;

procedure TMXHTMLWriter.Set_indent(fIndentMode: WordBool);
begin
  DefaultInterface.Set_indent(fIndentMode);
end;

function TMXHTMLWriter.Get_indent: WordBool;
begin
    Result := DefaultInterface.indent;
end;

procedure TMXHTMLWriter.Set_standalone(fValue: WordBool);
begin
  DefaultInterface.Set_standalone(fValue);
end;

function TMXHTMLWriter.Get_standalone: WordBool;
begin
    Result := DefaultInterface.standalone;
end;

procedure TMXHTMLWriter.Set_omitXMLDeclaration(fValue: WordBool);
begin
  DefaultInterface.Set_omitXMLDeclaration(fValue);
end;

function TMXHTMLWriter.Get_omitXMLDeclaration: WordBool;
begin
    Result := DefaultInterface.omitXMLDeclaration;
end;

procedure TMXHTMLWriter.Set_version(const strVersion: WideString);
  { Avertissement : cette propri�t� version a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.version := strVersion;
end;

function TMXHTMLWriter.Get_version: WideString;
begin
    Result := DefaultInterface.version;
end;

procedure TMXHTMLWriter.Set_disableOutputEscaping(fValue: WordBool);
begin
  DefaultInterface.Set_disableOutputEscaping(fValue);
end;

function TMXHTMLWriter.Get_disableOutputEscaping: WordBool;
begin
    Result := DefaultInterface.disableOutputEscaping;
end;

procedure TMXHTMLWriter.flush;
begin
  DefaultInterface.flush;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMXHTMLWriterProperties.Create(AServer: TMXHTMLWriter);
begin
  inherited Create;
  FServer := AServer;
end;

function TMXHTMLWriterProperties.GetDefaultInterface: IMXWriter;
begin
  Result := FServer.DefaultInterface;
end;

procedure TMXHTMLWriterProperties.Set_output(varDestination: OleVariant);
begin
  DefaultInterface.Set_output(varDestination);
end;

function TMXHTMLWriterProperties.Get_output: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.output;
end;

procedure TMXHTMLWriterProperties.Set_encoding(const strEncoding: WideString);
  { Avertissement : cette propri�t� encoding a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.encoding := strEncoding;
end;

function TMXHTMLWriterProperties.Get_encoding: WideString;
begin
    Result := DefaultInterface.encoding;
end;

procedure TMXHTMLWriterProperties.Set_byteOrderMark(fWriteByteOrderMark: WordBool);
begin
  DefaultInterface.Set_byteOrderMark(fWriteByteOrderMark);
end;

function TMXHTMLWriterProperties.Get_byteOrderMark: WordBool;
begin
    Result := DefaultInterface.byteOrderMark;
end;

procedure TMXHTMLWriterProperties.Set_indent(fIndentMode: WordBool);
begin
  DefaultInterface.Set_indent(fIndentMode);
end;

function TMXHTMLWriterProperties.Get_indent: WordBool;
begin
    Result := DefaultInterface.indent;
end;

procedure TMXHTMLWriterProperties.Set_standalone(fValue: WordBool);
begin
  DefaultInterface.Set_standalone(fValue);
end;

function TMXHTMLWriterProperties.Get_standalone: WordBool;
begin
    Result := DefaultInterface.standalone;
end;

procedure TMXHTMLWriterProperties.Set_omitXMLDeclaration(fValue: WordBool);
begin
  DefaultInterface.Set_omitXMLDeclaration(fValue);
end;

function TMXHTMLWriterProperties.Get_omitXMLDeclaration: WordBool;
begin
    Result := DefaultInterface.omitXMLDeclaration;
end;

procedure TMXHTMLWriterProperties.Set_version(const strVersion: WideString);
  { Avertissement : cette propri�t� version a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.version := strVersion;
end;

function TMXHTMLWriterProperties.Get_version: WideString;
begin
    Result := DefaultInterface.version;
end;

procedure TMXHTMLWriterProperties.Set_disableOutputEscaping(fValue: WordBool);
begin
  DefaultInterface.Set_disableOutputEscaping(fValue);
end;

function TMXHTMLWriterProperties.Get_disableOutputEscaping: WordBool;
begin
    Result := DefaultInterface.disableOutputEscaping;
end;

{$ENDIF}

class function CoMXHTMLWriter30.Create: IMXWriter;
begin
  Result := CreateComObject(CLASS_MXHTMLWriter30) as IMXWriter;
end;

class function CoMXHTMLWriter30.CreateRemote(const MachineName: string): IMXWriter;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MXHTMLWriter30) as IMXWriter;
end;

procedure TMXHTMLWriter30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{853D1540-C1A7-4AA9-A226-4D3BD301146D}';
    IntfIID:   '{4D7FF4BA-1565-4EA8-94E1-6E724A46F98D}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMXHTMLWriter30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IMXWriter;
  end;
end;

procedure TMXHTMLWriter30.ConnectTo(svrIntf: IMXWriter);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMXHTMLWriter30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMXHTMLWriter30.GetDefaultInterface: IMXWriter;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TMXHTMLWriter30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMXHTMLWriter30Properties.Create(Self);
{$ENDIF}
end;

destructor TMXHTMLWriter30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMXHTMLWriter30.GetServerProperties: TMXHTMLWriter30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMXHTMLWriter30.Set_output(varDestination: OleVariant);
begin
  DefaultInterface.Set_output(varDestination);
end;

function TMXHTMLWriter30.Get_output: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.output;
end;

procedure TMXHTMLWriter30.Set_encoding(const strEncoding: WideString);
  { Avertissement : cette propri�t� encoding a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.encoding := strEncoding;
end;

function TMXHTMLWriter30.Get_encoding: WideString;
begin
    Result := DefaultInterface.encoding;
end;

procedure TMXHTMLWriter30.Set_byteOrderMark(fWriteByteOrderMark: WordBool);
begin
  DefaultInterface.Set_byteOrderMark(fWriteByteOrderMark);
end;

function TMXHTMLWriter30.Get_byteOrderMark: WordBool;
begin
    Result := DefaultInterface.byteOrderMark;
end;

procedure TMXHTMLWriter30.Set_indent(fIndentMode: WordBool);
begin
  DefaultInterface.Set_indent(fIndentMode);
end;

function TMXHTMLWriter30.Get_indent: WordBool;
begin
    Result := DefaultInterface.indent;
end;

procedure TMXHTMLWriter30.Set_standalone(fValue: WordBool);
begin
  DefaultInterface.Set_standalone(fValue);
end;

function TMXHTMLWriter30.Get_standalone: WordBool;
begin
    Result := DefaultInterface.standalone;
end;

procedure TMXHTMLWriter30.Set_omitXMLDeclaration(fValue: WordBool);
begin
  DefaultInterface.Set_omitXMLDeclaration(fValue);
end;

function TMXHTMLWriter30.Get_omitXMLDeclaration: WordBool;
begin
    Result := DefaultInterface.omitXMLDeclaration;
end;

procedure TMXHTMLWriter30.Set_version(const strVersion: WideString);
  { Avertissement : cette propri�t� version a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.version := strVersion;
end;

function TMXHTMLWriter30.Get_version: WideString;
begin
    Result := DefaultInterface.version;
end;

procedure TMXHTMLWriter30.Set_disableOutputEscaping(fValue: WordBool);
begin
  DefaultInterface.Set_disableOutputEscaping(fValue);
end;

function TMXHTMLWriter30.Get_disableOutputEscaping: WordBool;
begin
    Result := DefaultInterface.disableOutputEscaping;
end;

procedure TMXHTMLWriter30.flush;
begin
  DefaultInterface.flush;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMXHTMLWriter30Properties.Create(AServer: TMXHTMLWriter30);
begin
  inherited Create;
  FServer := AServer;
end;

function TMXHTMLWriter30Properties.GetDefaultInterface: IMXWriter;
begin
  Result := FServer.DefaultInterface;
end;

procedure TMXHTMLWriter30Properties.Set_output(varDestination: OleVariant);
begin
  DefaultInterface.Set_output(varDestination);
end;

function TMXHTMLWriter30Properties.Get_output: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.output;
end;

procedure TMXHTMLWriter30Properties.Set_encoding(const strEncoding: WideString);
  { Avertissement : cette propri�t� encoding a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.encoding := strEncoding;
end;

function TMXHTMLWriter30Properties.Get_encoding: WideString;
begin
    Result := DefaultInterface.encoding;
end;

procedure TMXHTMLWriter30Properties.Set_byteOrderMark(fWriteByteOrderMark: WordBool);
begin
  DefaultInterface.Set_byteOrderMark(fWriteByteOrderMark);
end;

function TMXHTMLWriter30Properties.Get_byteOrderMark: WordBool;
begin
    Result := DefaultInterface.byteOrderMark;
end;

procedure TMXHTMLWriter30Properties.Set_indent(fIndentMode: WordBool);
begin
  DefaultInterface.Set_indent(fIndentMode);
end;

function TMXHTMLWriter30Properties.Get_indent: WordBool;
begin
    Result := DefaultInterface.indent;
end;

procedure TMXHTMLWriter30Properties.Set_standalone(fValue: WordBool);
begin
  DefaultInterface.Set_standalone(fValue);
end;

function TMXHTMLWriter30Properties.Get_standalone: WordBool;
begin
    Result := DefaultInterface.standalone;
end;

procedure TMXHTMLWriter30Properties.Set_omitXMLDeclaration(fValue: WordBool);
begin
  DefaultInterface.Set_omitXMLDeclaration(fValue);
end;

function TMXHTMLWriter30Properties.Get_omitXMLDeclaration: WordBool;
begin
    Result := DefaultInterface.omitXMLDeclaration;
end;

procedure TMXHTMLWriter30Properties.Set_version(const strVersion: WideString);
  { Avertissement : cette propri�t� version a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.version := strVersion;
end;

function TMXHTMLWriter30Properties.Get_version: WideString;
begin
    Result := DefaultInterface.version;
end;

procedure TMXHTMLWriter30Properties.Set_disableOutputEscaping(fValue: WordBool);
begin
  DefaultInterface.Set_disableOutputEscaping(fValue);
end;

function TMXHTMLWriter30Properties.Get_disableOutputEscaping: WordBool;
begin
    Result := DefaultInterface.disableOutputEscaping;
end;

{$ENDIF}

class function CoMXHTMLWriter40.Create: IMXWriter;
begin
  Result := CreateComObject(CLASS_MXHTMLWriter40) as IMXWriter;
end;

class function CoMXHTMLWriter40.CreateRemote(const MachineName: string): IMXWriter;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MXHTMLWriter40) as IMXWriter;
end;

procedure TMXHTMLWriter40.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{88D969C9-F192-11D4-A65F-0040963251E5}';
    IntfIID:   '{4D7FF4BA-1565-4EA8-94E1-6E724A46F98D}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMXHTMLWriter40.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IMXWriter;
  end;
end;

procedure TMXHTMLWriter40.ConnectTo(svrIntf: IMXWriter);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMXHTMLWriter40.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMXHTMLWriter40.GetDefaultInterface: IMXWriter;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TMXHTMLWriter40.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMXHTMLWriter40Properties.Create(Self);
{$ENDIF}
end;

destructor TMXHTMLWriter40.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMXHTMLWriter40.GetServerProperties: TMXHTMLWriter40Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMXHTMLWriter40.Set_output(varDestination: OleVariant);
begin
  DefaultInterface.Set_output(varDestination);
end;

function TMXHTMLWriter40.Get_output: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.output;
end;

procedure TMXHTMLWriter40.Set_encoding(const strEncoding: WideString);
  { Avertissement : cette propri�t� encoding a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.encoding := strEncoding;
end;

function TMXHTMLWriter40.Get_encoding: WideString;
begin
    Result := DefaultInterface.encoding;
end;

procedure TMXHTMLWriter40.Set_byteOrderMark(fWriteByteOrderMark: WordBool);
begin
  DefaultInterface.Set_byteOrderMark(fWriteByteOrderMark);
end;

function TMXHTMLWriter40.Get_byteOrderMark: WordBool;
begin
    Result := DefaultInterface.byteOrderMark;
end;

procedure TMXHTMLWriter40.Set_indent(fIndentMode: WordBool);
begin
  DefaultInterface.Set_indent(fIndentMode);
end;

function TMXHTMLWriter40.Get_indent: WordBool;
begin
    Result := DefaultInterface.indent;
end;

procedure TMXHTMLWriter40.Set_standalone(fValue: WordBool);
begin
  DefaultInterface.Set_standalone(fValue);
end;

function TMXHTMLWriter40.Get_standalone: WordBool;
begin
    Result := DefaultInterface.standalone;
end;

procedure TMXHTMLWriter40.Set_omitXMLDeclaration(fValue: WordBool);
begin
  DefaultInterface.Set_omitXMLDeclaration(fValue);
end;

function TMXHTMLWriter40.Get_omitXMLDeclaration: WordBool;
begin
    Result := DefaultInterface.omitXMLDeclaration;
end;

procedure TMXHTMLWriter40.Set_version(const strVersion: WideString);
  { Avertissement : cette propri�t� version a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.version := strVersion;
end;

function TMXHTMLWriter40.Get_version: WideString;
begin
    Result := DefaultInterface.version;
end;

procedure TMXHTMLWriter40.Set_disableOutputEscaping(fValue: WordBool);
begin
  DefaultInterface.Set_disableOutputEscaping(fValue);
end;

function TMXHTMLWriter40.Get_disableOutputEscaping: WordBool;
begin
    Result := DefaultInterface.disableOutputEscaping;
end;

procedure TMXHTMLWriter40.flush;
begin
  DefaultInterface.flush;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMXHTMLWriter40Properties.Create(AServer: TMXHTMLWriter40);
begin
  inherited Create;
  FServer := AServer;
end;

function TMXHTMLWriter40Properties.GetDefaultInterface: IMXWriter;
begin
  Result := FServer.DefaultInterface;
end;

procedure TMXHTMLWriter40Properties.Set_output(varDestination: OleVariant);
begin
  DefaultInterface.Set_output(varDestination);
end;

function TMXHTMLWriter40Properties.Get_output: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.output;
end;

procedure TMXHTMLWriter40Properties.Set_encoding(const strEncoding: WideString);
  { Avertissement : cette propri�t� encoding a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.encoding := strEncoding;
end;

function TMXHTMLWriter40Properties.Get_encoding: WideString;
begin
    Result := DefaultInterface.encoding;
end;

procedure TMXHTMLWriter40Properties.Set_byteOrderMark(fWriteByteOrderMark: WordBool);
begin
  DefaultInterface.Set_byteOrderMark(fWriteByteOrderMark);
end;

function TMXHTMLWriter40Properties.Get_byteOrderMark: WordBool;
begin
    Result := DefaultInterface.byteOrderMark;
end;

procedure TMXHTMLWriter40Properties.Set_indent(fIndentMode: WordBool);
begin
  DefaultInterface.Set_indent(fIndentMode);
end;

function TMXHTMLWriter40Properties.Get_indent: WordBool;
begin
    Result := DefaultInterface.indent;
end;

procedure TMXHTMLWriter40Properties.Set_standalone(fValue: WordBool);
begin
  DefaultInterface.Set_standalone(fValue);
end;

function TMXHTMLWriter40Properties.Get_standalone: WordBool;
begin
    Result := DefaultInterface.standalone;
end;

procedure TMXHTMLWriter40Properties.Set_omitXMLDeclaration(fValue: WordBool);
begin
  DefaultInterface.Set_omitXMLDeclaration(fValue);
end;

function TMXHTMLWriter40Properties.Get_omitXMLDeclaration: WordBool;
begin
    Result := DefaultInterface.omitXMLDeclaration;
end;

procedure TMXHTMLWriter40Properties.Set_version(const strVersion: WideString);
  { Avertissement : cette propri�t� version a un setter et un getter dont
    les types ne sont pas en concordance. Delphi n'a pas pu g�n�rer une propri�t�
    de cette sorte et utilise donc un Variant � la place. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.version := strVersion;
end;

function TMXHTMLWriter40Properties.Get_version: WideString;
begin
    Result := DefaultInterface.version;
end;

procedure TMXHTMLWriter40Properties.Set_disableOutputEscaping(fValue: WordBool);
begin
  DefaultInterface.Set_disableOutputEscaping(fValue);
end;

function TMXHTMLWriter40Properties.Get_disableOutputEscaping: WordBool;
begin
    Result := DefaultInterface.disableOutputEscaping;
end;

{$ENDIF}

class function CoSAXAttributes.Create: IMXAttributes;
begin
  Result := CreateComObject(CLASS_SAXAttributes) as IMXAttributes;
end;

class function CoSAXAttributes.CreateRemote(const MachineName: string): IMXAttributes;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SAXAttributes) as IMXAttributes;
end;

procedure TSAXAttributes.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{4DD441AD-526D-4A77-9F1B-9841ED802FB0}';
    IntfIID:   '{F10D27CC-3EC0-415C-8ED8-77AB1C5E7262}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSAXAttributes.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IMXAttributes;
  end;
end;

procedure TSAXAttributes.ConnectTo(svrIntf: IMXAttributes);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSAXAttributes.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSAXAttributes.GetDefaultInterface: IMXAttributes;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TSAXAttributes.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSAXAttributesProperties.Create(Self);
{$ENDIF}
end;

destructor TSAXAttributes.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSAXAttributes.GetServerProperties: TSAXAttributesProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TSAXAttributes.addAttribute(const strURI: WideString; const strLocalName: WideString; 
                                      const strQName: WideString; const strType: WideString; 
                                      const strValue: WideString);
begin
  DefaultInterface.addAttribute(strURI, strLocalName, strQName, strType, strValue);
end;

procedure TSAXAttributes.addAttributeFromIndex(varAtts: OleVariant; nIndex: SYSINT);
begin
  DefaultInterface.addAttributeFromIndex(varAtts, nIndex);
end;

procedure TSAXAttributes.clear;
begin
  DefaultInterface.clear;
end;

procedure TSAXAttributes.removeAttribute(nIndex: SYSINT);
begin
  DefaultInterface.removeAttribute(nIndex);
end;

procedure TSAXAttributes.setAttribute(nIndex: SYSINT; const strURI: WideString; 
                                      const strLocalName: WideString; const strQName: WideString; 
                                      const strType: WideString; const strValue: WideString);
begin
  DefaultInterface.setAttribute(nIndex, strURI, strLocalName, strQName, strType, strValue);
end;

procedure TSAXAttributes.setAttributes(varAtts: OleVariant);
begin
  DefaultInterface.setAttributes(varAtts);
end;

procedure TSAXAttributes.setLocalName(nIndex: SYSINT; const strLocalName: WideString);
begin
  DefaultInterface.setLocalName(nIndex, strLocalName);
end;

procedure TSAXAttributes.setQName(nIndex: SYSINT; const strQName: WideString);
begin
  DefaultInterface.setQName(nIndex, strQName);
end;

procedure TSAXAttributes.setType(nIndex: SYSINT; const strType: WideString);
begin
  DefaultInterface.setType(nIndex, strType);
end;

procedure TSAXAttributes.setURI(nIndex: SYSINT; const strURI: WideString);
begin
  DefaultInterface.setURI(nIndex, strURI);
end;

procedure TSAXAttributes.setValue(nIndex: SYSINT; const strValue: WideString);
begin
  DefaultInterface.setValue(nIndex, strValue);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSAXAttributesProperties.Create(AServer: TSAXAttributes);
begin
  inherited Create;
  FServer := AServer;
end;

function TSAXAttributesProperties.GetDefaultInterface: IMXAttributes;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoSAXAttributes30.Create: IMXAttributes;
begin
  Result := CreateComObject(CLASS_SAXAttributes30) as IMXAttributes;
end;

class function CoSAXAttributes30.CreateRemote(const MachineName: string): IMXAttributes;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SAXAttributes30) as IMXAttributes;
end;

procedure TSAXAttributes30.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{3E784A01-F3AE-4DC0-9354-9526B9370EBA}';
    IntfIID:   '{F10D27CC-3EC0-415C-8ED8-77AB1C5E7262}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSAXAttributes30.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IMXAttributes;
  end;
end;

procedure TSAXAttributes30.ConnectTo(svrIntf: IMXAttributes);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSAXAttributes30.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSAXAttributes30.GetDefaultInterface: IMXAttributes;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TSAXAttributes30.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSAXAttributes30Properties.Create(Self);
{$ENDIF}
end;

destructor TSAXAttributes30.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSAXAttributes30.GetServerProperties: TSAXAttributes30Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TSAXAttributes30.addAttribute(const strURI: WideString; const strLocalName: WideString; 
                                        const strQName: WideString; const strType: WideString; 
                                        const strValue: WideString);
begin
  DefaultInterface.addAttribute(strURI, strLocalName, strQName, strType, strValue);
end;

procedure TSAXAttributes30.addAttributeFromIndex(varAtts: OleVariant; nIndex: SYSINT);
begin
  DefaultInterface.addAttributeFromIndex(varAtts, nIndex);
end;

procedure TSAXAttributes30.clear;
begin
  DefaultInterface.clear;
end;

procedure TSAXAttributes30.removeAttribute(nIndex: SYSINT);
begin
  DefaultInterface.removeAttribute(nIndex);
end;

procedure TSAXAttributes30.setAttribute(nIndex: SYSINT; const strURI: WideString; 
                                        const strLocalName: WideString; const strQName: WideString; 
                                        const strType: WideString; const strValue: WideString);
begin
  DefaultInterface.setAttribute(nIndex, strURI, strLocalName, strQName, strType, strValue);
end;

procedure TSAXAttributes30.setAttributes(varAtts: OleVariant);
begin
  DefaultInterface.setAttributes(varAtts);
end;

procedure TSAXAttributes30.setLocalName(nIndex: SYSINT; const strLocalName: WideString);
begin
  DefaultInterface.setLocalName(nIndex, strLocalName);
end;

procedure TSAXAttributes30.setQName(nIndex: SYSINT; const strQName: WideString);
begin
  DefaultInterface.setQName(nIndex, strQName);
end;

procedure TSAXAttributes30.setType(nIndex: SYSINT; const strType: WideString);
begin
  DefaultInterface.setType(nIndex, strType);
end;

procedure TSAXAttributes30.setURI(nIndex: SYSINT; const strURI: WideString);
begin
  DefaultInterface.setURI(nIndex, strURI);
end;

procedure TSAXAttributes30.setValue(nIndex: SYSINT; const strValue: WideString);
begin
  DefaultInterface.setValue(nIndex, strValue);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSAXAttributes30Properties.Create(AServer: TSAXAttributes30);
begin
  inherited Create;
  FServer := AServer;
end;

function TSAXAttributes30Properties.GetDefaultInterface: IMXAttributes;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoSAXAttributes40.Create: IMXAttributes;
begin
  Result := CreateComObject(CLASS_SAXAttributes40) as IMXAttributes;
end;

class function CoSAXAttributes40.CreateRemote(const MachineName: string): IMXAttributes;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SAXAttributes40) as IMXAttributes;
end;

procedure TSAXAttributes40.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{88D969CA-F192-11D4-A65F-0040963251E5}';
    IntfIID:   '{F10D27CC-3EC0-415C-8ED8-77AB1C5E7262}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSAXAttributes40.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IMXAttributes;
  end;
end;

procedure TSAXAttributes40.ConnectTo(svrIntf: IMXAttributes);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSAXAttributes40.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSAXAttributes40.GetDefaultInterface: IMXAttributes;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TSAXAttributes40.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSAXAttributes40Properties.Create(Self);
{$ENDIF}
end;

destructor TSAXAttributes40.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSAXAttributes40.GetServerProperties: TSAXAttributes40Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TSAXAttributes40.addAttribute(const strURI: WideString; const strLocalName: WideString; 
                                        const strQName: WideString; const strType: WideString; 
                                        const strValue: WideString);
begin
  DefaultInterface.addAttribute(strURI, strLocalName, strQName, strType, strValue);
end;

procedure TSAXAttributes40.addAttributeFromIndex(varAtts: OleVariant; nIndex: SYSINT);
begin
  DefaultInterface.addAttributeFromIndex(varAtts, nIndex);
end;

procedure TSAXAttributes40.clear;
begin
  DefaultInterface.clear;
end;

procedure TSAXAttributes40.removeAttribute(nIndex: SYSINT);
begin
  DefaultInterface.removeAttribute(nIndex);
end;

procedure TSAXAttributes40.setAttribute(nIndex: SYSINT; const strURI: WideString; 
                                        const strLocalName: WideString; const strQName: WideString; 
                                        const strType: WideString; const strValue: WideString);
begin
  DefaultInterface.setAttribute(nIndex, strURI, strLocalName, strQName, strType, strValue);
end;

procedure TSAXAttributes40.setAttributes(varAtts: OleVariant);
begin
  DefaultInterface.setAttributes(varAtts);
end;

procedure TSAXAttributes40.setLocalName(nIndex: SYSINT; const strLocalName: WideString);
begin
  DefaultInterface.setLocalName(nIndex, strLocalName);
end;

procedure TSAXAttributes40.setQName(nIndex: SYSINT; const strQName: WideString);
begin
  DefaultInterface.setQName(nIndex, strQName);
end;

procedure TSAXAttributes40.setType(nIndex: SYSINT; const strType: WideString);
begin
  DefaultInterface.setType(nIndex, strType);
end;

procedure TSAXAttributes40.setURI(nIndex: SYSINT; const strURI: WideString);
begin
  DefaultInterface.setURI(nIndex, strURI);
end;

procedure TSAXAttributes40.setValue(nIndex: SYSINT; const strValue: WideString);
begin
  DefaultInterface.setValue(nIndex, strValue);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSAXAttributes40Properties.Create(AServer: TSAXAttributes40);
begin
  inherited Create;
  FServer := AServer;
end;

function TSAXAttributes40Properties.GetDefaultInterface: IMXAttributes;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoMXNamespaceManager.Create: IVBMXNamespaceManager;
begin
  Result := CreateComObject(CLASS_MXNamespaceManager) as IVBMXNamespaceManager;
end;

class function CoMXNamespaceManager.CreateRemote(const MachineName: string): IVBMXNamespaceManager;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MXNamespaceManager) as IVBMXNamespaceManager;
end;

procedure TMXNamespaceManager.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{88D969D5-F192-11D4-A65F-0040963251E5}';
    IntfIID:   '{C90352F5-643C-4FBC-BB23-E996EB2D51FD}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMXNamespaceManager.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IVBMXNamespaceManager;
  end;
end;

procedure TMXNamespaceManager.ConnectTo(svrIntf: IVBMXNamespaceManager);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMXNamespaceManager.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMXNamespaceManager.GetDefaultInterface: IVBMXNamespaceManager;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TMXNamespaceManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMXNamespaceManagerProperties.Create(Self);
{$ENDIF}
end;

destructor TMXNamespaceManager.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMXNamespaceManager.GetServerProperties: TMXNamespaceManagerProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMXNamespaceManager.Set_allowOverride(fOverride: WordBool);
begin
  DefaultInterface.Set_allowOverride(fOverride);
end;

function TMXNamespaceManager.Get_allowOverride: WordBool;
begin
    Result := DefaultInterface.allowOverride;
end;

procedure TMXNamespaceManager.reset;
begin
  DefaultInterface.reset;
end;

procedure TMXNamespaceManager.pushContext;
begin
  DefaultInterface.pushContext;
end;

procedure TMXNamespaceManager.pushNodeContext(const contextNode: IXMLDOMNode; fDeep: WordBool);
begin
  DefaultInterface.pushNodeContext(contextNode, fDeep);
end;

procedure TMXNamespaceManager.popContext;
begin
  DefaultInterface.popContext;
end;

procedure TMXNamespaceManager.declarePrefix(const prefix: WideString; const namespaceURI: WideString);
begin
  DefaultInterface.declarePrefix(prefix, namespaceURI);
end;

function TMXNamespaceManager.getDeclaredPrefixes: IMXNamespacePrefixes;
begin
  Result := DefaultInterface.getDeclaredPrefixes;
end;

function TMXNamespaceManager.getPrefixes(const namespaceURI: WideString): IMXNamespacePrefixes;
begin
  Result := DefaultInterface.getPrefixes(namespaceURI);
end;

function TMXNamespaceManager.getURI(const prefix: WideString): OleVariant;
begin
  Result := DefaultInterface.getURI(prefix);
end;

function TMXNamespaceManager.getURIFromNode(const strPrefix: WideString; 
                                            const contextNode: IXMLDOMNode): OleVariant;
begin
  Result := DefaultInterface.getURIFromNode(strPrefix, contextNode);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMXNamespaceManagerProperties.Create(AServer: TMXNamespaceManager);
begin
  inherited Create;
  FServer := AServer;
end;

function TMXNamespaceManagerProperties.GetDefaultInterface: IVBMXNamespaceManager;
begin
  Result := FServer.DefaultInterface;
end;

procedure TMXNamespaceManagerProperties.Set_allowOverride(fOverride: WordBool);
begin
  DefaultInterface.Set_allowOverride(fOverride);
end;

function TMXNamespaceManagerProperties.Get_allowOverride: WordBool;
begin
    Result := DefaultInterface.allowOverride;
end;

{$ENDIF}

class function CoMXNamespaceManager40.Create: IVBMXNamespaceManager;
begin
  Result := CreateComObject(CLASS_MXNamespaceManager40) as IVBMXNamespaceManager;
end;

class function CoMXNamespaceManager40.CreateRemote(const MachineName: string): IVBMXNamespaceManager;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MXNamespaceManager40) as IVBMXNamespaceManager;
end;

procedure TMXNamespaceManager40.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{88D969D6-F192-11D4-A65F-0040963251E5}';
    IntfIID:   '{C90352F5-643C-4FBC-BB23-E996EB2D51FD}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMXNamespaceManager40.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IVBMXNamespaceManager;
  end;
end;

procedure TMXNamespaceManager40.ConnectTo(svrIntf: IVBMXNamespaceManager);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMXNamespaceManager40.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMXNamespaceManager40.GetDefaultInterface: IVBMXNamespaceManager;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TMXNamespaceManager40.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMXNamespaceManager40Properties.Create(Self);
{$ENDIF}
end;

destructor TMXNamespaceManager40.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMXNamespaceManager40.GetServerProperties: TMXNamespaceManager40Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMXNamespaceManager40.Set_allowOverride(fOverride: WordBool);
begin
  DefaultInterface.Set_allowOverride(fOverride);
end;

function TMXNamespaceManager40.Get_allowOverride: WordBool;
begin
    Result := DefaultInterface.allowOverride;
end;

procedure TMXNamespaceManager40.reset;
begin
  DefaultInterface.reset;
end;

procedure TMXNamespaceManager40.pushContext;
begin
  DefaultInterface.pushContext;
end;

procedure TMXNamespaceManager40.pushNodeContext(const contextNode: IXMLDOMNode; fDeep: WordBool);
begin
  DefaultInterface.pushNodeContext(contextNode, fDeep);
end;

procedure TMXNamespaceManager40.popContext;
begin
  DefaultInterface.popContext;
end;

procedure TMXNamespaceManager40.declarePrefix(const prefix: WideString; 
                                              const namespaceURI: WideString);
begin
  DefaultInterface.declarePrefix(prefix, namespaceURI);
end;

function TMXNamespaceManager40.getDeclaredPrefixes: IMXNamespacePrefixes;
begin
  Result := DefaultInterface.getDeclaredPrefixes;
end;

function TMXNamespaceManager40.getPrefixes(const namespaceURI: WideString): IMXNamespacePrefixes;
begin
  Result := DefaultInterface.getPrefixes(namespaceURI);
end;

function TMXNamespaceManager40.getURI(const prefix: WideString): OleVariant;
begin
  Result := DefaultInterface.getURI(prefix);
end;

function TMXNamespaceManager40.getURIFromNode(const strPrefix: WideString; 
                                              const contextNode: IXMLDOMNode): OleVariant;
begin
  Result := DefaultInterface.getURIFromNode(strPrefix, contextNode);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMXNamespaceManager40Properties.Create(AServer: TMXNamespaceManager40);
begin
  inherited Create;
  FServer := AServer;
end;

function TMXNamespaceManager40Properties.GetDefaultInterface: IVBMXNamespaceManager;
begin
  Result := FServer.DefaultInterface;
end;

procedure TMXNamespaceManager40Properties.Set_allowOverride(fOverride: WordBool);
begin
  DefaultInterface.Set_allowOverride(fOverride);
end;

function TMXNamespaceManager40Properties.Get_allowOverride: WordBool;
begin
    Result := DefaultInterface.allowOverride;
end;

{$ENDIF}

class function CoXMLDocument.Create: IXMLDocument2;
begin
  Result := CreateComObject(CLASS_XMLDocument) as IXMLDocument2;
end;

class function CoXMLDocument.CreateRemote(const MachineName: string): IXMLDocument2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XMLDocument) as IXMLDocument2;
end;

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TDOMDocument, TDOMDocument26, TDOMDocument30, TDOMDocument40, 
    TFreeThreadedDOMDocument, TFreeThreadedDOMDocument26, TFreeThreadedDOMDocument30, TFreeThreadedDOMDocument40, TXMLSchemaCache, 
    TXMLSchemaCache26, TXMLSchemaCache30, TXMLSchemaCache40, TXSLTemplate, TXSLTemplate26, 
    TXSLTemplate30, TXSLTemplate40, TDSOControl, TDSOControl26, TDSOControl30, 
    TDSOControl40, TXMLHTTP, TXMLHTTP26, TXMLHTTP30, TXMLHTTP40, 
    TServerXMLHTTP, TServerXMLHTTP30, TServerXMLHTTP40, TSAXXMLReader, TSAXXMLReader30, 
    TSAXXMLReader40, TMXXMLWriter, TMXXMLWriter30, TMXXMLWriter40, TMXHTMLWriter, 
    TMXHTMLWriter30, TMXHTMLWriter40, TSAXAttributes, TSAXAttributes30, TSAXAttributes40, 
    TMXNamespaceManager, TMXNamespaceManager40]);
end;

end.
