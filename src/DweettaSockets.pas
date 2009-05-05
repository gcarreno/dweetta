{*------------------------------------------------------------------------------
  DweettaSockets.pas

  This includes a wrapper around the Sockets lib of choice.
  This version uses Synapse.

  @Author  $Author$
  @LastChangedBy $LastChangedBy$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit DweettaSockets;

{$I Dweetta.inc}

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
  if Assigned(Params) then
  begin
    Data := '';
    for Index := 0 to Params.Count - 1 do
    begin
      Data := Data + Params[Index] + '&';
    end;
    SetLength(Data, Length(Data) - 1);
    FHTTPSend.Document.Write(Pointer(Data)^, Length(Data));
    FHTTPSend.MimeType := 'application/x-www-form-urlencoded';
  end;
  Result := FHTTPSend.HTTPMethod(Method, URL);
end;

end.

