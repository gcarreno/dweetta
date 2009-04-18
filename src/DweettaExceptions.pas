{*------------------------------------------------------------------------------
  DweettaExceptions.pas

  The exceptions for Dweetta Lib.

  @Author  $Author$
  @LastChangedBy $LastChangedBy$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit DweettaExceptions;

{$I Dweetta.inc}

interface

uses
  Classes, SysUtils; 

type
{ EDweettaTransportError }

  EDweettaTransportError  = class(Exception)
    private
      FHttpStatusCode: Integer;
    public
      constructor Create(HttpErrorCode: Integer); overload;
      constructor Create(HttpErrorCode: Integer; originalReq: String; errorStr: string); overload;

      property HttpStatusCode: Integer read FHttpStatusCode;
  end;

implementation

{ EDweettaTransportError }

constructor EDweettaTransportError.Create ( HttpErrorCode: Integer ) ;
var
  strError: String;
begin
  FHttpStatusCode := HttpErrorCode;
  case HttpErrorCode of
    400: strError := '400 - Bad Request: You may have exceeded the rate limit';
    401: strError := '401 - Not Authorized: either you need to provide authentication credentials, or the credentials provided aren not valid.';
    403: strError := '403 - Forbidden';
    404: strError := '404 - Object Not Found';
    500: strError := '500 - Internal Server Error';
    502: strError := '502 - Bad Gateway, Dweetta may be down or being upgraded';
    503: strError := '503 - Service Unavailable, The Dweetta Servers are overloaded and need more steam.';
    else strError := 'HTTP Status Code: ' + IntToStr(HttpErrorCode) + ' - Oops - Something else went wrong';
  end;

  inherited Create(strError);
end;

constructor EDweettaTransportError.Create ( HttpErrorCode: Integer;
  originalReq: String; errorStr: string ) ;
begin
  FHttpStatusCode := HttpErrorCode;
  // We haven't used originalReq here but it's a copy of the request
  // eg.. <request>/direct_messages/destroy/456.xml</request>

  inherited Create(errorStr);
end;

end.

