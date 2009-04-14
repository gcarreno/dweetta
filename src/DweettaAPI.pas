{*------------------------------------------------------------------------------
  DweettaAPI.pas

  This unit contains the code for the API calls.
  Some of the code and ideas have been pinched from jamiei.

  @Author  $Author$
  @Version $Rev$
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
     FUser: String;
     FPassword: String;
     FUserAgent: String;
     FServer: String;
     FDweettaTransport: TDweettaTransport;
     FParams: TStringList;
     FResponseInfo: TDweettaResponseInfo;

     procedure SetUser(Value: String);
     procedure SetPassword(Value: String);
     procedure SetUserAgent(Value: String);
     procedure SetServer(Value: String);
  public
    constructor Create;
    destructor Destroy; override;

    { Status }
    function Statuses_public_timeline: TDweettaStatusElementList;
    function Statuses_friends_timeline(since: String; since_id: Integer; max_id: Integer;
      count: Integer; page: Integer): TDweettaStatusElementList;
    function Statuses_user_timeline(id: String; user_id: integer;
      screen_name: String; since_id: Integer; max_id: Integer;
      page: Integer; since: String): TDweettaStatusElementList; overload;

    { User }

    property User: String read FUser write SetUser;
    property Password: String read FPassword write SetPassword;
    property UserAgent: String read FUserAgent write SetUserAgent;
    property Server: String read FServer write SetServer;
  end;

implementation

{ TDweettaAPI }

procedure TDweettaAPI.SetUser ( Value: String ) ;
begin
  if Value <> FUser then
  begin
    FUser := Value;
    FDweettaTransport.User := FUser;
  end;
end;

procedure TDweettaAPI.SetPassword ( Value: String ) ;
begin
  if Value <> FPassword then
  begin
    FPassword := Value;
    FDweettaTransport.Password := FPassword;
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

function TDweettaAPI.Statuses_public_timeline: TDweettaStatusElementList;
begin
  Result := TDweettaStatusElementList.Create;
  FParams.Clear;
  try
    Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Statuses_friends_timeline(since: String; since_id: Integer;
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
    Result.LoadFromString(FDweettaTransport.Get(tsStatusesFriendsTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Statuses_user_timeline ( id: String; user_id: integer;
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
    Result.LoadFromString(FDweettaTransport.Get(tsStatusesUserTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;


end.

