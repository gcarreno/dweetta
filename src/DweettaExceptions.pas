//      Mozilla Public License.
//
//      The contents of this file are subject to the Mozilla Public License
//      Version 1.1 (the "License"); you may not use this file except in compliance
//      with the License. You may obtain a copy of the License at
//
//      http://www.mozilla.org/MPL/
//
//      Software distributed under the License is distributed on an "AS IS"
//      basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
//      License for the specific language governing rights and limitations under
//      the License.
{**
  DweettaExceptions.pas

  The exceptions for Dweetta Lib.

  @Author  $Author$
}
unit DweettaExceptions;

//  @LastChangedBy $LastChangedBy$
//  @Version $Rev$

{$I Dweetta.inc}

interface

uses
  Classes, SysUtils;

type
{ EDweettaTransportError }
{**
  Exception for transport layer error
}
  EDweettaTransportError  = class(Exception)
    private
      FHTTPStatusCode: Integer;
      FHTTPMessage: String;
      FOriginalRequest: String;
      FJSONMessage: String;
    public
      {**
        Overload constructor with Result Code only

          @param aHTTPErrorCode HTTP Result Code
      }
      constructor Create(aHTTPErrorCode: Integer); overload;
      {**
        Overload constructor with Result Code, Original request and Error Message

          @param aHTTPErrorCode HTTP Result Code
          @param aOriginalRec Original Request
          @param aErrorStr Error Message
      }
      constructor Create(aHTTPErrorCode: Integer; aOriginalReq: String; aErrorStr: String); overload;
      {**
        Overload constructor with Result Code, Original request, Error Message and
        JSON Message

          @param aHTTPErrorCode HTTP Result Code
          @param aOriginalRec Original Request
          @param aErrorStr Error Message
          @param aJSONMessage JSON Error Message
      }
      constructor Create(aHTTPErrorCode: Integer; aOriginalReq: String; aErrorStr: String; aJSONMessage: String); overload;

      {**
        Numerical Status code returned by HTTP call
      }
      property HTTPStatusCode: Integer read FHTTPStatusCode;
      {**
        AlphaNumerical Status code returned by HTTP call
      }
      property HTTPMessage: String read FHTTPMessage;
      {**
        Contains the original call
      }
      property OriginalRequest: String read FOriginalRequest;
      {**
        Contains the JSON message that then endpoint returned
      }
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
  aOriginalReq: String; aErrorStr: String ) ;
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

