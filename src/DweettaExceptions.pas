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
      FHTTPStatusCode: Integer;
      FHTTPMessage: String;
      FOriginalRequest: String;
      FJSONMessage: String;
    public
      constructor Create(aHTTPErrorCode: Integer); overload;
      constructor Create(aHTTPErrorCode: Integer; aOriginalReq: String; aErrorStr: String); overload;
      constructor Create(aHTTPErrorCode: Integer; aOriginalReq: String; aErrorStr: String; aJSONMessage: String); overload;

      property HTTPStatusCode: Integer read FHTTPStatusCode;
      property HTTPMessage: String read FHTTPMessage;
      property OriginalRequest: String read FOriginalRequest;
      property JSONMessage: String read FJSONMessage;
  end;

implementation

{ EDweettaTransportError }

constructor EDweettaTransportError.Create (aHTTPErrorCode: Integer) ;
var
  strError: String;
begin
  FHTTPStatusCode := aHTTPErrorCode;
  case aHTTPErrorCode of
    400: strError := '400 - Bad Request: You may have exceeded the rate limit';
    401: strError := '401 - Not Authorized: either you need to provide authentication credentials, or the credentials provided aren not valid.';
    403: strError := '403 - Forbidden';
    404: strError := '404 - Object Not Found';
    500: strError := '500 - Internal Server Error';
    502: strError := '502 - Bad Gateway, Dweetta may be down or being upgraded';
    503: strError := '503 - Service Unavailable, The Dweetta Servers are overloaded and need more steam.';
    else strError := 'HTTP Status Code: ' + IntToStr(aHTTPErrorCode) + ' - Oops - Something else went wrong';
  end;

  inherited Create(strError);
end;

constructor EDweettaTransportError.Create (aHTTPErrorCode: Integer;
  aOriginalReq: String; aErrorStr: string ) ;
begin
  FHTTPStatusCode := aHTTPErrorCode;
  FOriginalRequest := aOriginalReq;
  FHTTPMessage := aErrorStr;
  inherited Create(aErrorStr);
end;

constructor EDweettaTransportError.Create(aHttpErrorCode: Integer;
  aOriginalReq: String; aErrorStr: String; aJSONMessage: String);
begin
  FHTTPStatusCode := aHTTPErrorCode;
  FOriginalRequest := aOriginalReq;
  FHTTPMessage := aErrorStr;
  FJSONMessage := aJSONMessage;
  inherited Create(aErrorStr);
end;

end.

