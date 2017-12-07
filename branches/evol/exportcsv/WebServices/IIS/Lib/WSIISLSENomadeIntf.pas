{ Interface invocable IWSIISLSENomade }

unit WSIISLSENomadeIntf;

interface

uses InvokeRegistry, Types, XSBuiltIns, WSNomadeDecl;

type

  { Les interfaces invocables doivent d�river de IInvokable }
  IWSIISLSENomade = interface(IInvokable)
  ['{F4541998-87D2-4994-9035-69121E22E481}']
    { Les m�thodes de l'interface invocable ne doivent pas utiliser la convention }
    { d'appel par d�faut ; stdcall est conseill�e }
    function IsValideConnect ( ParamIn : TWSUserParam) : WideString; stdcall;
    function GetAppels (identificateur : WideString; Depuis : Widestring) : WideString; stdcall;
    function GetAppel (identificateur : WideString; CodeAppel : Widestring) : WideString; stdcall;
  end;

implementation

initialization
  { Les interfaces invocables doivent �tre recens�es }
  InvRegistry.RegisterInterface(TypeInfo(IWSIISLSENomade));

end.
 