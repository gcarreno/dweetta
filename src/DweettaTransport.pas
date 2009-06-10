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

    function ExecuteQuery(const Method: String; const URI: String;
      var ResponseInfo: TDweettaResponseInfo; const Params: TStringList): String;
    procedure GetRateLimits(var ResponseInfo: TDweettaResponseInfo);
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
  DateUtils, SuperObject, DweettaUtils;

{ TDweettaTransport }

procedure TDweettaTransport.GetRateLimits(var ResponseInfo: TDweettaResponseInfo);
var
  Index: Integer;
  HeaderValue: String;
begin
  for Index := 0 to FDweettaSocket.Headers.Count -1 do
  begin
    if Pos('X-RateLimit-Remaining', FDweettaSocket.Headers[Index]) > 0 then
    begin
      HeaderValue := Copy(FDweettaSocket.Headers[Index], Pos(':',
        FDweettaSocket.Headers[Index]) + 1, Length(FDweettaSocket.Headers[Index]
        ));
      ResponseInfo.RemainingCalls := StrToInt(HeaderValue);
    end;
    if Pos('X-RateLimit-Limit', FDweettaSocket.Headers[Index]) > 0 then
    begin
      HeaderValue := Copy(FDweettaSocket.Headers[Index], Pos(':',
        FDweettaSocket.Headers[Index]) + 1, Length(FDweettaSocket.Headers[Index]
        ));
      ResponseInfo.RateLimit := StrToInt(HeaderValue);
    end;
    if Pos('X-RateLimit-Reset', FDweettaSocket.Headers[Index]) > 0 then
    begin
      HeaderValue := Copy(FDweettaSocket.Headers[Index], Pos(':',
        FDweettaSocket.Headers[Index]) + 1, Length(FDweettaSocket.Headers[Index]
        ));
      ResponseInfo.RateLimitReset := UnixToDateTime(StrToInt(HeaderValue));
    end;
  end;
end;

function TDweettaTransport.ExecuteQuery(const Method: String; const URI: String;
  var ResponseInfo: TDweettaResponseInfo; const Params: TStringList): String;
var
  JSONMessage: String;
  OriginalReq: String;
  ErrorObject: ISuperObject;
begin
  Result := '';
  if FDweettaSocket.Execute(Method, URI, Params) then
  begin
    Result := FDweettaSocket.Content.Text;
    ResponseInfo.HTTPStatus := FDweettaSocket.Result;
    ResponseInfo.HTTPMessage := FDweettaSocket.ResultText;
    if ResponseInfo.HTTPStatus = 200 then
    begin
      GetRateLimits(ResponseInfo);
    end
    else
    begin
      ErrorObject := SO(Result);
      OriginalReq := ErrorObject['request'].AsString;
      JSONMessage := ErrorObject['error'].AsString;
      raise EDweettaTransportError.Create(ResponseInfo.HTTPStatus, OriginalReq,
        ResponseInfo.HTTPMessage, JSONMessage);
    end;
  end
  else
  begin
    raise EDweettaTransportError.Create(FDweettaSocket.Result, '',
      FDweettaSocket.ResultText, '');
  end;
end;

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
  URI: String;
begin
  Result := '[()]';
  URI := '';

  case Service of
    tsStatusesPublicTimeline, tsStatusesFriendsTimeline,
    tsStatusesUserTimeline, tsStatusesReplies, tsUsersFriends, tsUsersFollowers,
    tsDirectMessagesDirectMessages, tsDirectMessagesSent, tsFriendshipsExists:begin
      URI := FServer + cDweettaServiceEndPoints[Service] + FFormat;
      if (Assigned(Params)) and (Params.Count > 0) then
      begin
        URI := URI + '?' + URLEncodeParams(Params, true);
      end;
    end;
    tsStatusesShow, tsUsersShow:begin
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
    Result := ExecuteQuery('GET', URI, ResponseInfo, Params);
  end;
end;

function TDweettaTransport.Post (Service: TDweettaServices; const Params: TStringList;
  out ResponseInfo: TDweettaResponseInfo) : String;
var
  ErrorObject: ISuperObject;
  URI, HeaderValue, OriginalReq, JSONMessage: String;
  Index: Integer;
begin
  Result := '[()]';
  URI := '';

  case Service of
    tsStatusesUpdate, tsDirectMessagesNew:begin
      URI := FServer + cDweettaServiceEndPoints[Service] + FFormat;
    end;
    tsFriendshipsCreate:begin
      URI := FServer + cDweettaServiceEndPoints[Service] + '/' +  Params.Values['id'] + FFormat;
      Params.Delete(Params.IndexOf('id'));
    end;
  end;

  if URI <> '' then
  begin
    if FUser <> '' then
    begin
      URI := FUser + ':' + FPassword + '@' + URI;
    end;
    URI := 'http://' + URI;
    Result := ExecuteQuery('POST', URI, ResponseInfo, Params);
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

  case Service of
    tsStatusesDestroy, tsDirectMessagesDestroy, tsFriendshipsDestroy:begin
      URI := FServer + cDweettaServiceEndPoints[Service] + '/' +  Params.Values['id'] + FFormat;
      Params.Delete(Params.IndexOf('id'));
    end;
  end;

  if URI <> '' then
  begin
    if FUser <> '' then
    begin
      URI := FUser + ':' + FPassword + '@' + URI;
    end;
    URI := 'http://' + URI;
    Result := ExecuteQuery('DELETE', URI, ResponseInfo, Params);
  end;
end;

end.

