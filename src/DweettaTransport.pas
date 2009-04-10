{*------------------------------------------------------------------------------
  DweettaTransport.pas

  This unit contains the code for the HTTP Transport.
  Exception code borrowed from jamiei.

  @Author
  @Version
-------------------------------------------------------------------------------}
unit DweettaTransport;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, HTTPSend;

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

{ TDweettaServices }

  TDweettaServices = (tsPublicTimeline, tsFriendsTimeline, tsUserTimeline);

{ TDweettaServiceEndPoints }
var
  TDweettaServiceEndPoints: array[tsPublicTimeline..tsUserTimeline] of string;

type
{ TDweettaResponseInfo }

  TDweettaResponseInfo = record
    HTTPStatus: Integer;
    HTTPMessage: String;
    RemainingCalls: Integer;
  end;

{ TDweettaTrasnport }

  TDweettaTransport = class(TObject)
  private
    FUser: String;
    FPassword: String;
    FServer: String;
    FUserAgent: String;
    FFormat: String;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    function Get(Service: TDweettaServices; const Params: TStringList;
      out ResponseInfo: TDweettaResponseInfo): String;
    function Post(Service: TDweettaServices; const Params: TStringList;
      out ResponseInfo: TDweettaResponseInfo): String;
    function Delete(Service: TDweettaServices; const Params: TStringList;
      out ResponseInfo: TDweettaResponseInfo): String;

    property User: String read FUser write FUser;
    property Password: String read FPassword write FPassword;
    property Server: String read FServer write FServer;
    property UserAgent: String read FUserAgent write FUserAgent;
    property Format: String read FFormat write FFormat;
  published
  end;

implementation

{ TDweettaTransport }

constructor TDweettaTransport.Create;
begin
  inherited Create;
end;

destructor TDweettaTransport.Destroy;
begin
  inherited Destroy;
end;

function TDweettaTransport.Get ( Service: TDweettaServices; const Params: TStringList;
  out ResponseInfo: TDweettaResponseInfo ) : String;
var
  { Temporary.start }
  FileLines: TStringList;
  { Temporary.end }
  URI: String;
  Index: Integer;
begin
  URI := 'http://' + FServer + TDweettaServiceEndPoints[Service] + FFormat;
  if Assigned(Params) then
  begin
    URI := URI + '?';
    for Index := 0 to Params.Count -1 do
    begin
      URI := URI + Params[Index] + '&';
    end;
    SetLength(URI, Length(URI) -1);
  end;
  { Temporary.start }
  FileLines := TStringList.Create;
  FileLines.LoadFromFile('../Data/public_timeline.json');
  Result:=FileLines.Text;
  FileLines.Free;
  { Temporary.end   }
end;

function TDweettaTransport.Post ( Service: TDweettaServices; const Params: TStringList;
  out ResponseInfo: TDweettaResponseInfo ) : String;
begin
  Result := '';
end;

function TDweettaTransport.Delete ( Service: TDweettaServices; const Params: TStringList;
  out ResponseInfo: TDweettaResponseInfo ) : String;
begin
  Result := '';
end;

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

initialization

  TDweettaServiceEndPoints[tsPublicTimeline] := '/statuses/public_timeline';
  TDweettaServiceEndPoints[tsFriendsTimeline] := '/statuses/friends_timeline';
  TDweettaServiceEndPoints[tsUserTimeline] := '/statuses/user_timeline';

end.

