{*------------------------------------------------------------------------------
  DweettaTransport.pas

  This unit contains the code for the HTTP Transport.
  Exception code borrowed from jamiei.

  @Author  $Author$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit DweettaTransport;

{$I Dweetta.inc}

interface

uses
  Classes, SysUtils, DweettaSockets;

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

  TDweettaServices = (tsStatusesPublicTimeline, tsStatusesFriendsTimeline,
    tsStatusesUserTimeline, tsStatusesShow, tsStatusesUpdate, tsStatusesReplies,
    tsStatusesDestroy);

{ TDweettaServiceEndPoints }
var
  TDweettaServiceEndPoints: array[tsStatusesPublicTimeline..tsStatusesDestroy] of string =
    ('/statuses/public_timeline', '/statuses/friends_timeline', '/statuses/user_timeline',
     '/statuses/show', '/statuses/update', '/statuses/replies', '/statuses/destroy');

type
{ TDweettaResponseInfo }

  TDweettaResponseInfo = record
    HTTPStatus: Integer;
    HTTPMessage: String;
    RemainingCalls: Integer;
    RateLimit: Integer;
  end;

{ TDweettaTrasnport }

  TDweettaTransport = class(TObject)
  private
    FUser: String;
    FPassword: String;
    FServer: String;
    FUserAgent: String;
    FFormat: String;
    FDweettaSocket: TDweettaSockets;
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
  end;

implementation

{ TDweettaTransport }

constructor TDweettaTransport.Create;
begin
  inherited Create;
  FDweettaSocket := TDweettaSockets.Create;
end;

destructor TDweettaTransport.Destroy;
begin
  FDweettaSocket.Free;
  inherited Destroy;
end;

function TDweettaTransport.Get(Service: TDweettaServices; const Params: TStringList;
  out ResponseInfo: TDweettaResponseInfo) : String;
var
  URI, HeaderValue: String;
  Index: Integer;
begin
  Result := '';
  case Service of
    tsStatusesPublicTimeline, tsStatusesFriendsTimeline,
    tsStatusesUserTimeline, tsStatusesReplies:begin
      URI := FServer + TDweettaServiceEndPoints[Service] + FFormat;
      if Assigned(Params) then
      begin
        URI := URI + '?';
        for Index := 0 to Params.Count -1 do
        begin
          URI := URI + Params[Index] + '&';
        end;
        SetLength(URI, Length(URI) -1);
      end;
    end;
    tsStatusesShow:begin
      URI := FServer + TDweettaServiceEndPoints[Service] + '/' +  Params.Values['id'] + FFormat;
    end;
    else
      URI := '';
  end;
  if URI <> '' then
  begin
    if FUser <> '' then
    begin
      URI := FUser + ':' + FPassword + '@' + URI;
    end;
    URI := 'http://' + URI;
    if FDweettaSocket.Execute('GET', URI) then
    begin
      Result := FDweettaSocket.Content.Text;
      ResponseInfo.HTTPStatus := FDweettaSocket.Result;
      ResponseInfo.HTTPMessage := FDweettaSocket.ResultText;
      for Index := 0 to FDweettaSocket.Headers.Count -1 do
      begin
        if Pos('X-RateLimit-Remaining', FDweettaSocket.Headers[Index]) > 0 then
        begin
          HeaderValue := Copy(FDweettaSocket.Headers[Index], Pos(':', FDweettaSocket.Headers[Index]) + 1, Length(FDweettaSocket.Headers[Index]));
          ResponseInfo.RemainingCalls := StrToInt(HeaderValue);
        end;
        if Pos('X-RateLimit-Limit', FDweettaSocket.Headers[Index]) > 0 then
        begin
          HeaderValue := Copy(FDweettaSocket.Headers[Index], Pos(':', FDweettaSocket.Headers[Index]) + 1, Length(FDweettaSocket.Headers[Index]));
          ResponseInfo.RateLimit := StrToInt(HeaderValue);
        end;
      end;
    end;
  end;
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

end.

