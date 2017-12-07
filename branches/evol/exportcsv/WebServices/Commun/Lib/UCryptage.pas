unit UCryptage;

interface
uses IdHashMessageDigest,IdHash;

implementation

function MD5(const Text : string) : string;
var
  md5 : TIdHashMessageDigest5;
begin
  md5 := TIdHashMessageDigest5.Create;
  try
    result := md5.AsHex(md5.HashValue (Text)) ;
  finally
    md5.Free;
  end;
end;

end.
