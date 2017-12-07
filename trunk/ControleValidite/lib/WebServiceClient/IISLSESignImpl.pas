{ Fichier d'impl�mentation invocable pour TIISLSESign qui impl�mente IIISLSESign }

unit IISLSESignImpl;

interface

uses InvokeRegistry, Types, XSBuiltIns, IISLSESignIntf;

type

  { TIISLSESign }
  TIISLSESign = class(TInvokableClass, IIISLSESign)
  public
    function echoEnum(const Value: TEnumTest): TEnumTest; stdcall;
    function echoDoubleArray(const Value: TDoubleArray): TDoubleArray; stdcall;
    function echoMyEmployee(const Value: TMyEmployee): TMyEmployee; stdcall;
    function echoDouble(const Value: Double): Double; stdcall;
  end;

implementation

function TIISLSESign.echoEnum(const Value: TEnumTest): TEnumTest; stdcall;
begin
  { A FAIRE : Impl�menter la m�thode echoEnum }
  Result := Value;
end;

function TIISLSESign.echoDoubleArray(const Value: TDoubleArray): TDoubleArray; stdcall;
begin
  { A FAIRE : Impl�menter la m�thode echoDoubleArray }
  Result := Value;
end;

function TIISLSESign.echoMyEmployee(const Value: TMyEmployee): TMyEmployee; stdcall;
begin
  { A FAIRE : Impl�menter la m�thode echoMyEmployee }
  Result := TMyEmployee.Create;
end;

function TIISLSESign.echoDouble(const Value: Double): Double; stdcall;
begin
  { A FAIRE : Impl�menter la m�thode echoDouble }
  Result := Value;
end;

initialization
  { Les classes invocables doivent �tre recens�es }
  InvRegistry.RegisterInvokableClass(TIISLSESign);

end.
 