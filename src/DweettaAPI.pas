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
  Classes, SysUtils, DweettaTypes, DweettaContainers, DweettaTransport;

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

     function GetRateLimit: Integer;
     function GetRemainingCalls: Integer;
     function GetResponseCode: Integer;
     function GetResponseString: String;
     procedure SetUser(Value: String);
     procedure SetPassword(Value: String);
     procedure SetUserAgent(Value: String);
     procedure SetServer(Value: String);
  public
    constructor Create;
    destructor Destroy; override;

    { Status }
    function Statuses_public_timeline(out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElementList;
    function Statuses_friends_timeline(since: String; since_id: Integer; max_id: Integer;
      count: Integer; page: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElementList;
    function Statuses_user_timeline(id: String; user_id: integer;
      screen_name: String; since_id: Integer; max_id: Integer;
      page: Integer; since: String; out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElementList;
    function Statuses_show(id: integer; out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElement;
    function Statuses_update(status: String; in_reply_to_status_id: Integer;
      out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElement;
    function Statuses_replies(since_id: Integer; max_id: Integer; since: String;
      page: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElementList;
    function Statuses_destroy(id: integer; out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElement;

    { User }
    function Users_friends(id: String; user_id: Integer; screen_name: String;
      page: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElementList;
    function Users_followers(id: string; user_id: Integer; screen_name: String;
      page: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElementList;
    function Users_show(id: String; user_id: Integer; screen_name: String;
      out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;

    { Direct Messages }
    function DirectMessages_direct_messages(since: String; since_id: Integer;
      page: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaDirectMessageElementList;
    function DirectMessages_sent(since: String; since_id: Integer; page: Integer;
      out ResponseInfo: TDweettaResponseInfo): TDweettaDirectMessageElementList;
    function DirectMessages_new(user: String; text: String;
      out ResponseInfo: TDweettaResponseInfo): TDweettaDirectMessageElement;
    function DirectMessages_destroy(id: integer;
      out ResponseInfo: TDweettaResponseInfo): TDweettaDirectMessageElementList;

    { Friendships }
    function Friendships_create(id: String; follow: Boolean;
      out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
    function Friendships_destroy(id: String; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
    function Friendships_exists(user_a: String; user_b: String;
      out ResponseInfo: TDweettaResponseInfo): Boolean;

    { Friends }
    { TODO -ogcarreno -cRefactoring : This needs to return an array of Integers. }
    function Friends_ids(id: String; user_id: Integer; screen_name: String;
      out ResponseInfo: TDweettaResponseInfo): String;

    { Followers }
    { TODO -ogcarreno -cRefactoring : This needs to return an array of Integers. }
    function Followers_ids(id: String; user_id: Integer; screen_name: String;
      out ResponseInfo: TDweettaResponseInfo): String;

    { Account }
    function Account_verify_credentials(out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
    procedure Account_end_session(out ResponseInfo: TDweettaResponseInfo);
    { TODO -ogcarreno -cRefactoring : Need to specify a constant for device. }
    function Account_update_delivery_device(device: String;
      out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
    function Account_update_profile_colors(profile_background_color: String;
      profile_text_color: String; profile_link_color: String;
      profile_sidebar_fill_color: String; profile_sidebar_border_color: String;
      out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
    function Account_update_profile_image(image: String; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
    { TODO -ogcarreno -cRefactoring : image has to be a binary image format. }
    function Account_update_profile_background_image(image: String; tile: Boolean;
      out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
    function Account_rate_limit_status(out ResponseInfo: TDweettaResponseInfo): Integer;
    function Account_update_profile(name: String; email: String; url: String;
      location: String; description: String;out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;

    { Favorites }
    function Favorites_favorites(id: String; page: Integer;
      out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElementList;
    function Favorites_create(id: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElement;
    function Favorites_destroy(id: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElement;

    { Notifications }
    function Notifications_follow(id: String; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
    function Notifications_leave(id: String; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;

    { Blocks }
    function Blocks_create(id: String; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
    function Blocks_destroy(id: String; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;

    { Help }
    function Help_test(out ResponseInfo: TDweettaResponseInfo): String;

    property User: String read FUser write SetUser;
    property Password: String read FPassword write SetPassword;
    property UserAgent: String read FUserAgent write SetUserAgent;
    property Server: String read FServer write SetServer;
    property ResponseCode: Integer read GetResponseCode;
    property ResponseString: String read GetResponseString;
    property RemainingCalls: Integer read GetRemainingCalls;
    property RateLimit: Integer read GetRateLimit;
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

function TDweettaAPI.GetRateLimit: Integer;
begin
  Result := FResponseInfo.RateLimit;
end;

function TDweettaAPI.GetRemainingCalls: Integer;
begin
  Result := FResponseInfo.RemainingCalls;
end;

function TDweettaAPI.GetResponseCode: Integer;
begin
  Result := FResponseInfo.HTTPStatus;
end;

function TDweettaAPI.GetResponseString: String;
begin
  Result := FResponseInfo.HTTPMessage;
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

function TDweettaAPI.Statuses_public_timeline(out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElementList;
begin
  FParams.Clear;
  Result := TDweettaStatusElementList.Create;
  Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Statuses_friends_timeline(since: String; since_id: Integer;
  max_id: Integer; count: Integer; page: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElementList;
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
  Result.LoadFromString(FDweettaTransport.Get(tsStatusesFriendsTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Statuses_user_timeline ( id: String; user_id: integer;
  screen_name: String; since_id: Integer; max_id: Integer; page: Integer;
  since: String; out ResponseInfo: TDweettaResponseInfo) : TDweettaStatusElementList;
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
  Result.LoadFromString(FDweettaTransport.Get(tsStatusesUserTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Statuses_show(id: integer; out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElement;
begin
  FParams.Clear;
  if id <> 0 then
  begin
    FParams.Add('id=' + IntToStr(id));
  end;
  Result := TDweettaStatusElement.Create;
  Result.LoadFromString(FDweettaTransport.Get(tsStatusesShow, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Statuses_update(status: String;
  in_reply_to_status_id: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElement;
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
  Result := TDweettaStatusElement.Create;
  Result.LoadFromString(FDweettaTransport.Post(tsStatusesUpdate, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Statuses_replies(since_id: Integer; max_id: Integer;
  since: String; page: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElementList;
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
  Result := TDweettaStatusElementList.Create;
  Result.LoadFromString(FDweettaTransport.Get(tsStatusesReplies, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Statuses_destroy(id: integer; out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElement;
begin
  FParams.Clear;
  if id <> 0 then
  begin
    FParams.Add('id=' + IntToStr(id));
  end;
  Result := TDweettaStatusElement.Create;
  Result.LoadFromString(FDweettaTransport.Delete(tsStatusesDestroy, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Users_friends(id: String; user_id: Integer;
  screen_name: String; page: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElementList;
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
  if page <> 0 then
  begin
    FParams.Add('page=' + IntToStr(page));
  end;
  Result := TDweettaUserElementList.Create;
  Result.LoadFromString(FDweettaTransport.Get(tsUsersFriends, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Users_followers(id: string; user_id: Integer;
  screen_name: String; page: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElementList;
begin
  FParams.Clear;
  Result := TDweettaUserElementList.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Users_show(id: String; user_id: Integer;
  screen_name: String; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
begin
  FParams.Clear;
  Result := TDweettaUserElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.DirectMessages_direct_messages(since: String;
  since_id: Integer; page: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaDirectMessageElementList;
begin
  FParams.Clear;
  Result := TDweettaDirectMessageElementList.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.DirectMessages_sent(since: String; since_id: Integer;
  page: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaDirectMessageElementList;
begin
  FParams.Clear;
  Result := TDweettaDirectMessageElementList.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.DirectMessages_new(user: String; text: String;
  out ResponseInfo: TDweettaResponseInfo): TDweettaDirectMessageElement;
begin
  FParams.Clear;
  Result := TDweettaDirectMessageElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.DirectMessages_destroy(id: integer;
  out ResponseInfo: TDweettaResponseInfo): TDweettaDirectMessageElementList;
begin
  FParams.Clear;
  Result := TDweettaDirectMessageElementList.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Friendships_create(id: String; follow: Boolean;
  out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
begin
  FParams.Clear;
  Result := TDweettaUserElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Friendships_destroy(id: String; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
begin
  FParams.Clear;
  Result := TDweettaUserElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Friendships_exists(user_a: String; user_b: String;
  out ResponseInfo: TDweettaResponseInfo): Boolean;
begin
  FParams.Clear;
  Result := False;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Friends_ids(id: String; user_id: Integer;
  screen_name: String; out ResponseInfo: TDweettaResponseInfo): String;
begin
  FParams.Clear;
  Result := '';
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Followers_ids(id: String; user_id: Integer;
  screen_name: String; out ResponseInfo: TDweettaResponseInfo): String;
begin
  FParams.Clear;
  Result := '';
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Account_verify_credentials(out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
begin
  FParams.Clear;
  Result := TDweettaUserElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

procedure TDweettaAPI.Account_end_session(out ResponseInfo: TDweettaResponseInfo);
begin
  FParams.Clear;
    //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
    ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Account_update_delivery_device(device: String;
  out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
begin
  FParams.Clear;
  Result := TDweettaUserElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Account_update_profile_colors(
  profile_background_color: String; profile_text_color: String;
  profile_link_color: String; profile_sidebar_fill_color: String;
  profile_sidebar_border_color: String; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
begin
  FParams.Clear;
  Result := TDweettaUserElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Account_update_profile_image(image: String;
  out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
begin
  FParams.Clear;
  Result := TDweettaUserElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Account_update_profile_background_image(image: String;
  tile: Boolean; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
begin
  FParams.Clear;
  Result := TDweettaUserElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Account_rate_limit_status(out ResponseInfo: TDweettaResponseInfo): Integer;
begin
  FParams.Clear;
  Result := 100;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Account_update_profile(name: String; email: String;
  url: String; location: String; description: String; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
begin
  FParams.Clear;
  Result := TDweettaUserElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Favorites_favorites(id: String; page: Integer;
  out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElementList;
begin
  FParams.Clear;
  Result := TDweettaStatusElementList.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Favorites_create(id: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElement;
begin
  FParams.Clear;
  Result := TDweettaStatusElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Favorites_destroy(id: Integer; out ResponseInfo: TDweettaResponseInfo): TDweettaStatusElement;
begin
  FParams.Clear;
  Result := TDweettaStatusElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Notifications_follow(id: String; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
begin
  FParams.Clear;
  Result := TDweettaUserElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Notifications_leave(id: String; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
begin
  FParams.Clear;
  Result := TDweettaUserElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Blocks_create(id: String; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
begin
  FParams.Clear;
  Result := TDweettaUserElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Blocks_destroy(id: String; out ResponseInfo: TDweettaResponseInfo): TDweettaUserElement;
begin
  FParams.Clear;
  Result := TDweettaUserElement.Create;
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

function TDweettaAPI.Help_test(out ResponseInfo: TDweettaResponseInfo): String;
begin
  FParams.Clear;
  Result := '';
  //Result.LoadFromString(FDweettaTransport.Get(tsStatusesPublicTimeline, FParams, FResponseInfo));
  ResponseInfo := FResponseInfo;
end;

end.

