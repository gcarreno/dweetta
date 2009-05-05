{*------------------------------------------------------------------------------
  DweettaTransport.pas

  This unit contains the code for the HTTP Transport.
  Exception code borrowed from jamiei.

  @Author  $Author$
  @LastChangedBy $LastChangedBy$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit DweettaTransport;

{$I Dweetta.inc}

interface

uses
  Classes, SysUtils, DweettaTypes, DweettaSockets, DweettaExceptions;

type

{ TDweettaTransport }

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

uses
  DateUtils, SuperObject;

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
  ErrorObject: ISuperObject;
  URI, HeaderValue, OriginalReq, JSONMessage: String;
  Index: Integer;
begin
  { TODO 1 -ogcarreno -cDRY : Refactor repeated code into functions or procedures }
  Result := '[()]';
  URI := '';
  case Service of
    tsStatusesPublicTimeline, tsStatusesFriendsTimeline,
    tsStatusesUserTimeline, tsStatusesReplies:begin
      URI := FServer + cDweettaServiceEndPoints[Service] + FFormat;
      if Assigned(Params) then
      begin
        URI := URI + '?';
        for Index := 0 to Params.Count -1 do
        begin
          URI := URI + Params[Index] + '&';
        end;
        SetLength(URI, Length(URI) - 1);
      end;
    end;
    tsStatusesShow:begin
      URI := FServer + cDweettaServiceEndPoints[Service] + '/' +  Params.Values['id'] + FFormat;
      Params.Delete(Params.IndexOf('id'));
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
    if FDweettaSocket.Execute('GET', URI, Params) then
    begin
      Result := FDweettaSocket.Content.Text;
      ResponseInfo.HTTPStatus := FDweettaSocket.Result;
      ResponseInfo.HTTPMessage := FDweettaSocket.ResultText;
      if ResponseInfo.HTTPStatus = 200 then
      begin
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
          if Pos('X-RateLimit-Reset', FDweettaSocket.Headers[Index]) > 0 then
          begin
            HeaderValue := Copy(FDweettaSocket.Headers[Index], Pos(':', FDweettaSocket.Headers[Index]) + 1, Length(FDweettaSocket.Headers[Index]));
            ResponseInfo.RateLimitReset := UnixToDateTime(StrToInt(HeaderValue));
          end;
        end;
      end
      else
      begin
        ErrorObject := SO(Result);
        OriginalReq := ErrorObject['request'].AsString;
        JSONMessage := ErrorObject['error'].AsString;
        raise EDweettaTransportError.Create(ResponseInfo.HTTPStatus, OriginalReq, ResponseInfo.HTTPMessage, JSONMessage);
      end;
    end
    else
    begin
      raise EDweettaTransportError.Create(FDweettaSocket.Result, '', FDweettaSocket.ResultText, '');
    end;
  end;
end;

function TDweettaTransport.Post (Service: TDweettaServices; const Params: TStringList;
  out ResponseInfo: TDweettaResponseInfo) : String;
var
  ErrorObject: ISuperObject;
  URI, HeaderValue, OriginalReq, JSONMessage: String;
  Index: Integer;
begin
  { TODO 1 -ogcarreno -cDRY : Refactor repeated code into functions or procedures }
  Result := '[()]';
  URI := '';
  case Service of
    tsStatusesUpdate:begin
      URI := FServer + cDweettaServiceEndPoints[Service] + FFormat;
    end;
  end;
  if URI <> '' then
  begin
    if FUser <> '' then
    begin
      URI := FUser + ':' + FPassword + '@' + URI;
    end;
    URI := 'http://' + URI;
    if FDweettaSocket.Execute('POST', URI, Params) then
    begin
      Result := FDweettaSocket.Content.Text;
      ResponseInfo.HTTPStatus := FDweettaSocket.Result;
      ResponseInfo.HTTPMessage := FDweettaSocket.ResultText;
      if ResponseInfo.HTTPStatus = 200 then
      begin
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
          if Pos('X-RateLimit-Reset', FDweettaSocket.Headers[Index]) > 0 then
          begin
            HeaderValue := Copy(FDweettaSocket.Headers[Index], Pos(':', FDweettaSocket.Headers[Index]) + 1, Length(FDweettaSocket.Headers[Index]));
            ResponseInfo.RateLimitReset := UnixToDateTime(StrToInt(HeaderValue));
          end;
        end;
      end
      else
      begin
        ErrorObject := SO(Result);
        OriginalReq := ErrorObject['request'].AsString;
        JSONMessage := ErrorObject['error'].AsString;
        raise EDweettaTransportError.Create(ResponseInfo.HTTPStatus, OriginalReq, ResponseInfo.HTTPMessage, JSONMessage);
      end;
    end
    else
    begin
      raise EDweettaTransportError.Create(FDweettaSocket.Result, '', FDweettaSocket.ResultText, '');
    end;
  end;
end;

function TDweettaTransport.Delete (Service: TDweettaServices; const Params: TStringList;
  out ResponseInfo: TDweettaResponseInfo) : String;
var
  ErrorObject: ISuperObject;
  URI, HeaderValue, OriginalReq, JSONMessage: String;
  Index: Integer;
begin
  Result := '[()]';
  URI := '';

  { TODO 1 -ogcarreno -cMissingCode : Insert the case statement. }

  if URI <> '' then
  begin
    if FUser <> '' then
    begin
      URI := FUser + ':' + FPassword + '@' + URI;
    end;
    URI := 'http://' + URI;
    if FDweettaSocket.Execute('DELETE', URI, Params) then
    begin
      Result := FDweettaSocket.Content.Text;
      ResponseInfo.HTTPStatus := FDweettaSocket.Result;
      ResponseInfo.HTTPMessage := FDweettaSocket.ResultText;
      if ResponseInfo.HTTPStatus = 200 then
      begin
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
      end
      else
      begin
        ErrorObject := SO(Result);
        OriginalReq := ErrorObject['request'].AsString;
        JSONMessage := ErrorObject['error'].AsString;
        raise EDweettaTransportError.Create(ResponseInfo.HTTPStatus, OriginalReq, ResponseInfo.HTTPMessage, JSONMessage);
      end;
    end
    else
    begin
      raise EDweettaTransportError.Create(FDweettaSocket.Result, '', FDweettaSocket.ResultText, '');
    end;
  end;
end;

end.

