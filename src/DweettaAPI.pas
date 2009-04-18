{*------------------------------------------------------------------------------
  DweettaAPI.pas

  This unit contains the code for the API calls.
  Some of the code and ideas have been pinched from jamiei.

  @Author  $Author$
  @LastChangedBy $LastChangedBy$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit DweettaAPI;

{$I Dweetta.inc}

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
      page: Integer; since: String): TDweettaStatusElementList;
    function Statuses_show(id: integer): TDweettaStatusElement;
    function Statuses_update(status: String; in_reply_to_status_id: Integer): TDweettaStatusElement;
    function Statuses_replies(since_id: Integer; max_id: Integer; since: String;
      page: Integer): TDweettaStatusElementList;
    function Statuses_destroy(id: integer): TDweettaStatusElement;

    { User }
    function Users_friends(id: String; user_id: Integer; screen_name: String;
      page: Integer): TDweettaUserElementList;
    function Users_followers(id: string; user_id: Integer; screen_name: String;
      page: Integer): TDweettaUserElementList;
    function Users_show(id: String; user_id: Integer; screen_name: String): TDweettaUserElement;

    { Direct Messages }
    function DirectMessages_direct_messages(since: String; since_id: Integer;
      page: Integer): TDweettaDirectMessageElementList;
    function DirectMessages_sent(since: String; since_id: Integer; page: Integer): TDweettaDirectMessageElementList;
    function DirectMessages_new(user: String; text: String): TDweettaDirectMessageElement;
    function DirectMessages_destroy(id: integer): TDweettaDirectMessageElementList;

    { Friendships }
    function Friendships_create(id: String; follow: Boolean): TDweettaUserElement;
    function Friendships_destroy(id: String): TDweettaUserElement;
    function Friendships_exists(user_a: String; user_b: String): Boolean;

    { Friends }
    { TODO -ogcarreno -cRefactoring : This needs to return an array of Integers. }
    function Friends_ids(id: String; user_id: Integer; screen_name: String): String;

    { Followers }
    { TODO -ogcarreno -cRefactoring : This needs to return an array of Integers. }
    function Followers_ids(id: String; user_id: Integer; screen_name: String): String;

    { Account }
    function Account_verify_credentials: TDweettaUserElement;
    procedure Account_end_session;
    { TODO -ogcarreno -cRefactoring : Need to specify a constant for device. }
    function Account_update_delivery_device(device: String): TDweettaUserElement;
    function Account_update_profile_colors(profile_background_color: String;
      profile_text_color: String; profile_link_color: String;
      profile_sidebar_fill_color: String; profile_sidebar_border_color: String): TDweettaUserElement;
    function Account_update_profile_image(image: String): TDweettaUserElement;
    { TODO -ogcarreno -cRefactoring : image has to be a binary image format. }
    function Account_update_profile_background_image(image: String; tile: Boolean): TDweettaUserElement;
    function Account_rate_limit_status: Integer;
    function Account_update_profile(name: String; email: String; url: String;
      location: String; description: String): TDweettaUserElement;

    { Favorites }
    function Favorites_favorites(id: String; page: Integer): TDweettaStatusElementList;
    function Favorites_create(id: Integer): TDweettaStatusElement;
    function Favorites_destroy(id: Integer): TDweettaStatusElement;

    { Notifications }
    function Notifications_follow(id: String): TDweettaUserElement;
    function Notifications_leave(id: String): TDweettaUserElement;

    { Blocks }
    function Blocks_create(id: String): TDweettaUserElement;
    function Blocks_destroy(id: String): TDweettaUserElement;

    { Help }
    function Help_test: String;

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
  FParams.Clear;
  try
    Result := TDweettaStatusElementList.Create;
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
  try
    Result := TDweettaStatusElementList.Create;
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
  try
    Result := TDweettaStatusElementList.Create;
    Result.LoadFromString(FDweettaTransport.Get(tsStatusesUserTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Statuses_show(id: integer): TDweettaStatusElement;
begin
  FParams.Clear;
  if id <> 0 then
  begin
    FParams.Add('id=' + IntToStr(id));
  end;
  try
    Result := TDweettaStatusElement.Create;
    Result.LoadFromString(FDweettaTransport.Get(tsStatusesShow, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Statuses_update(status: String;
  in_reply_to_status_id: Integer): TDweettaStatusElement;
begin
  FParams.Clear;
  if status <> '' then
  begin
    FParams.Add('status=' + status);
  end;
  if in_reply_to_status_id <> 0 then
  begin
    FParams.Add('in_reply_to_status_id=' + IntToStr(in_reply_to_status_id));
  end;
  try
    Result := TDweettaStatusElement.Create;
    Result.LoadFromString(FDweettaTransport.Post(tsStatusesUpdate, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Statuses_replies(since_id: Integer; max_id: Integer;
  since: String; page: Integer): TDweettaStatusElementList;
begin
  FParams.Clear;
  if since_id <> 0 then
  begin
    FParams.Add('since_id=' + IntToStr(since_id));
  end;
  if max_id <> 0 then
  begin
    FParams.Add('max_id=' + IntToStr(max_id));
  end;
  if since <> '' then
  begin
    FParams.Add('since=' + since);
  end;
  if page <> 0 then
  begin
    FParams.Add('page=' + IntToStr(page));
  end;
  try
    Result := TDweettaStatusElementList.Create;
    Result.LoadFromString(FDweettaTransport.Get(tsStatusesReplies, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Statuses_destroy(id: integer): TDweettaStatusElement;
begin
  FParams.Clear;
  if id <> 0 then
  begin
    FParams.Add('id=' + IntToStr(id));
  end;
  try
    Result := TDweettaStatusElement.Create;
    Result.LoadFromString(FDweettaTransport.Delete(tsStatusesDestroy, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Users_friends(id: String; user_id: Integer;
  screen_name: String; page: Integer): TDweettaUserElementList;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElementList.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Users_followers(id: string; user_id: Integer;
  screen_name: String; page: Integer): TDweettaUserElementList;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElementList.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Users_show(id: String; user_id: Integer;
  screen_name: String): TDweettaUserElement;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.DirectMessages_direct_messages(since: String;
  since_id: Integer; page: Integer): TDweettaDirectMessageElementList;
begin
  FParams.Clear;
  try
    Result := TDweettaDirectMessageElementList.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.DirectMessages_sent(since: String; since_id: Integer;
  page: Integer): TDweettaDirectMessageElementList;
begin
  FParams.Clear;
  try
    Result := TDweettaDirectMessageElementList.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.DirectMessages_new(user: String; text: String
  ): TDweettaDirectMessageElement;
begin
  FParams.Clear;
  try
    Result := TDweettaDirectMessageElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.DirectMessages_destroy(id: integer
  ): TDweettaDirectMessageElementList;
begin
  FParams.Clear;
  try
    Result := TDweettaDirectMessageElementList.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Friendships_create(id: String; follow: Boolean
  ): TDweettaUserElement;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Friendships_destroy(id: String): TDweettaUserElement;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Friendships_exists(user_a: String; user_b: String
  ): Boolean;
begin
  FParams.Clear;
  try
    Result := False;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Friends_ids(id: String; user_id: Integer;
  screen_name: String): String;
begin
  FParams.Clear;
  try
    Result := '';
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Followers_ids(id: String; user_id: Integer;
  screen_name: String): String;
begin
  FParams.Clear;
  try
    Result := '';
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Account_verify_credentials: TDweettaUserElement;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

procedure TDweettaAPI.Account_end_session;
begin
  FParams.Clear;
  try
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Account_update_delivery_device(device: String
  ): TDweettaUserElement;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Account_update_profile_colors(
  profile_background_color: String; profile_text_color: String;
  profile_link_color: String; profile_sidebar_fill_color: String;
  profile_sidebar_border_color: String): TDweettaUserElement;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Account_update_profile_image(image: String
  ): TDweettaUserElement;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Account_update_profile_background_image(image: String;
  tile: Boolean): TDweettaUserElement;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Account_rate_limit_status: Integer;
begin
  FParams.Clear;
  try
    Result := 100;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Account_update_profile(name: String; email: String;
  url: String; location: String; description: String): TDweettaUserElement;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Favorites_favorites(id: String; page: Integer
  ): TDweettaStatusElementList;
begin
  FParams.Clear;
  try
    Result := TDweettaStatusElementList.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Favorites_create(id: Integer): TDweettaStatusElement;
begin
  FParams.Clear;
  try
    Result := TDweettaStatusElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Favorites_destroy(id: Integer): TDweettaStatusElement;
begin
  FParams.Clear;
  try
    Result := TDweettaStatusElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Notifications_follow(id: String): TDweettaUserElement;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Notifications_leave(id: String): TDweettaUserElement;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Blocks_create(id: String): TDweettaUserElement;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Blocks_destroy(id: String): TDweettaUserElement;
begin
  FParams.Clear;
  try
    Result := TDweettaUserElement.Create;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

function TDweettaAPI.Help_test: String;
begin
  FParams.Clear;
  try
    Result := '';
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  except
  { TODO -ogcarreno -cExceptions : Get execptions treated here.}
  end;
end;

end.

