{*------------------------------------------------------------------------------
  DweettaAPI.pas

  This unit contains the code for the API calls.
  Some of the code and ideas have been pinched from jamiei.

  @Author
  @Version
-------------------------------------------------------------------------------}
unit DweettaAPI;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, DweettaContainers, DweettaTransport;

type
{ TDweettaAPI }

  TDweettaAPI = class(TObject)
  private
     FDweettaUser: String;
     FDweettaPassword: String;
     FUserAgent: String;
     FServer: String;
     FDweettaTransport: TDweettaTransport;
     FParams: TStringList;
     FResponseInfo: TDweettaResponseInfo;

     procedure SetUser(Value: String);
     procedure SetPassword(Value: String);
     procedure SetUserAgent(Value: String);
     procedure SetServer(Value: String);
  protected
  public
    constructor Create;
    destructor Destroy; override;

    { Status }
    function public_timeline: TDweettaStatusElementList;
    function friends_timeline(since: String; since_id: Integer; max_id: Integer;
      count: Integer; page: Integer): TDweettaStatusElementList;
    function user_timeline(id: String; user_id: integer;
      screen_name: String; since_id: Integer; max_id: Integer;
      page: Integer; since: String): TDweettaStatusElementList; overload;

    { User }

    property User: String read FDweettaUser write SetUser;
    property Password: String read FDweettaPassword write SetPassword;
    property UserAgent: String read FUserAgent write SetUserAgent;
    property Server: String read FServer write SetServer;
  published
  end;

implementation

{ TDweettaAPI }

procedure TDweettaAPI.SetUser ( Value: String ) ;
begin
  if Value <> FDweettaUser then
  begin
    FDweettaUser := Value;
    FDweettaTransport.User := FDweettaUser;
  end;
end;

procedure TDweettaAPI.SetPassword ( Value: String ) ;
begin
  if Value <> FDweettaPassword then
  begin
    FDweettaPassword := Value;
    FDweettaTransport.Password := FDweettaPassword;
  end;
end;

procedure TDweettaAPI.SetUserAgent ( Value: String ) ;
begin
  if Value <> FUserAgent then
  begin
    FUserAgent := Value;
    FDweettaTransport.UserAgent := FUserAgent;
  end;
end;

procedure TDweettaAPI.SetServer ( Value: String ) ;
begin
  if Value <> FServer then
  begin
    FServer := Value;
    FDweettaTransport.Server := FServer;
  end;
end;

constructor TDweettaAPI.Create;
begin
  inherited Create;
  FDweettaTransport := TDweettaTransport.Create;
  FDweettaTransport.Format := '.json';
  FParams := TStringList.Create;
end;

destructor TDweettaAPI.Destroy;
begin
  FParams.Free;
  FDweettaTransport.Free;
  inherited Destroy;
end;

function TDweettaAPI.public_timeline: TDweettaStatusElementList;
begin
  Result := TDweettaStatusElementList.Create;
  FParams.Clear;
  try
    Result.LoadFromString(FDweettaTransport.Get(tsPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.friends_timeline(since: String; since_id: Integer;
  max_id: Integer; count: Integer; page: Integer): TDweettaStatusElementList;
begin
  FParams.Clear;
  if since <> '' then
  begin
    FParams.Add('since=' + since);
  end;
  if since_id <> 0 then
  begin
    FParams.Add('since_id=' + IntToStr(since_id));
  end;
  if max_id <> 0 then
  begin
    FParams.Add('max_id=' + IntToStr(max_id));
  end;
  if count <> 0 then
  begin
    FParams.Add('count=' + IntToStr(count));
  end;
  if page <> 0 then
  begin
    FParams.Add('page=' + IntToStr(page));
  end;
  Result := TDweettaStatusElementList.Create;
  try
    Result.LoadFromString(FDweettaTransport.Get(tsFriendsTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.user_timeline ( id: String; user_id: integer;
  screen_name: String; since_id: Integer; max_id: Integer; page: Integer;
  since: String ) : TDweettaStatusElementList;
begin
  FParams.Clear;
  if id <> '' then
  begin
    FParams.Add('id=' + id);
  end;
  if user_id <> 0 then
  begin
    FParams.Add('user_id=' + IntToStr(user_id));
  end;
  if screen_name <> '' then
  begin
    FParams.Add('screen_name=' + screen_name);
  end;
  if since_id <> 0 then
  begin
    FParams.Add('since_id=' + IntToStr(since_id));
  end;
  if max_id <> 0 then
  begin
    FParams.Add('max_id=' + IntToStr(max_id));
  end;
  if page <> 0 then
  begin
    FParams.Add('page=' + IntToStr(page));
  end;
  if since <> '' then
  begin
    FParams.Add('since=' + since);
  end;
  Result := TDweettaStatusElementList.Create;
  try
    Result.LoadFromString(FDweettaTransport.Get(tsUserTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;


end.

