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
  DweettaSocketsSynapse.pas

  This includes a wrapper around the Sockets lib of choice.
  This version uses Synapse.

  @Author  $Author$
  @LastChangedBy $LastChangedBy$
  @Version $Rev$
-------------------------------------------------------------------------------}
interface

uses
  Classes, SysUtils, HTTPSend;

type

{ TDweettaSockets }
  TDweettaSockets = class(TObject)
  private
    FHTTPSend: THTTPSend;

    function GetHeaders: TStringList;
    function GetContent: TStringList;
    function GetResult: Integer;
    function GetResultText: String;
    function GetUserAgent: String;
    procedure SetUserAgent(const AValue: String);
  public
    constructor Create;
    destructor Destroy; override;

    function Execute(Method, URL: String; const Params: TStringList = nil): Boolean;

    property UserAgent: String read GetUserAgent write SetUserAgent;
    property Headers: TStringList read GetHeaders;
    property Content: TStringList read GetContent;
    property Result: Integer read GetResult;
    property ResultText: String read GetResultText;
  end;

implementation

uses
  DweettaUtils;

{ TDweettaSockets }

function TDweettaSockets.GetHeaders: TStringList;
begin
  Result := FHTTPSend.Headers;
end;

function TDweettaSockets.GetContent: TStringList;
begin
  Result := TStringList.Create;
  Result.LoadFromStream(FHTTPSend.Document);
end;

function TDweettaSockets.GetResult: Integer;
begin
  Result := FHTTPSend.ResultCode;
end;

function TDweettaSockets.GetResultText: String;
begin
  Result := FHTTPSend.ResultString;
end;

function TDweettaSockets.GetUserAgent: String;
begin
  Result := FHTTPSend.UserAgent;
end;

procedure TDweettaSockets.SetUserAgent(const AValue: String);
begin
  FHTTPSend.UserAgent := AValue;
end;

constructor TDweettaSockets.Create;
begin
  inherited Create;
  FHTTPSend := THTTPSend.Create;
end;

destructor TDweettaSockets.Destroy;
begin
  FHTTPSend.Free;
  inherited Destroy;
end;

function TDweettaSockets.Execute(Method, URL: String; const Params: TStringList = nil): Boolean;
var
  Index: Integer;
  Data: String;
begin
  FHTTPSend.Clear;
  if (Assigned(Params)) and (Params.Count > 0) then
  begin
    Data := URLEncodeParams(Params, false);
    FHTTPSend.Document.Write(Pointer(Data)^, Length(Data));
    FHTTPSend.MimeType := 'application/x-www-form-urlencoded';
  end;
  Result := FHTTPSend.HTTPMethod(Method, URL);
end;