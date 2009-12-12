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
{**
  Dweetta.pas

  This unit contains the main Dweetta Object.

  The idea behind this is to have a less technical Interface.

    @todo refactor TDweetta to be a TComponent descendent

  @Author  $Author$
}
unit Dweetta;

//  @LastChangedBy $LastChangedBy$
//  @Version $Rev$

{$I Dweetta.inc}

interface

uses
  Classes, SysUtils, DweettaTypes, DweettaAPI, DweettaContainers;

type
{ TDweetta }
  {**
    Wrapper around the DweettaAPI in order to overload some calls
  }
  TDweetta = class(TObject)
  private
    FUser: String;
    FPassword: String;
    FDweettaAPI: TDweettaAPI;
    FResponseInfo: TDweettaResponseInfo;

    function GetRateLimit: Integer;
    function GetRateLimitReset: TDateTime;
    function GetRemainingCalls: Integer;
    function GetResponseCode: Integer;
    function GetResponseString: String;
    procedure SetUser(Value: String);
    procedure SetPassword(Value: String);
    procedure UpdateAuth;
  public
    constructor Create;
    destructor Destroy; override;

    {**
      Twitter Statuses::Public Timeline

        @returns A list of Status Elements
    }
    function StatusesPublicTimeline: TDweettaStatusElementList;

    {**
      Twitter Statuses::Friends Timeline overloaded

        @returns A list of Status Elements
    }
    function StatusesFriendsTimeline: TDweettaStatusElementList; overload;
    {**
      Twitter Statuses::Friends Timeline overloaded

        @param since Filter by date
        @returns A list of Status Elements
    }
    function StatusesFriendsTimeline(since: TDateTime): TDweettaStatusElementList; overload;
    {**
      Twitter Statuses::Friends Timeline overloaded

        @param count Filter by ammount
        @returns A list of Status Elements
    }
    function StatusesFriendsTimeline(count: Integer): TDweettaStatusElementList; overload;
    {**
      Twitter Statuses::Friends Timeline overloaded

        @param page Filter by page
        @returns A list of Status Elements
    }
    function StatusesFriendsTimelinePage(page: Integer): TDweettaStatusElementList;

    {**
      Twitter Statuses::User Timeline overloaded

        @returns A list of Status Elements
    }
    function StatusesUserTimeline: TDweettaStatusElementList; overload;
    {**
      Twitter Statuses::User Timeline overloaded

        @param id Filter by user ID
        @returns A list of Status Elements
    }
    function StatusesUserTimeline(id: Integer): TDweettaStatusElementList; overload;
    {**
      Twitter Statuses::User Timeline overloaded

        @param id Filter by user ID
        @param page Filter by page
        @returns A list of Status Elements
    }
    function StatusesUserTimeline(id: integer; page: Integer): TDweettaStatusElementList; overload;
    {**
      Twitter Statuses::User Timeline overloaded

        @param id Filter by user ID
        @param since Filter by date
        @returns A list of Status Elements
    }
    function StatusesUserTimeline(id: Integer; since: TDateTime): TDweettaStatusElementList; overload;
    {**
      Twitter Statuses::User Timeline overloaded

        @param screen_name Filter by user Screen Name
        @returns A list of Status Elements
    }
    function StatusesUserTimeline(screen_name: String): TDweettaStatusElementList; overload;
    {**
      Twitter Statuses::User Timeline overloaded

        @param screen_name Filter by user Screen Name
        @param page Filter by page
        @returns A list of Status Elements
    }
    function StatusesUserTimeline(screen_name: String; page: Integer): TDweettaStatusElementList; overload;
    {**
      Twitter Statuses::User Timeline overloaded

        @param screen_name Filter by user Screen Name
        @param since Filter by date
        @returns A list of Status Elements
    }
    function StatusesUserTimeline(screen_name: String; since: TDateTime): TDweettaStatusElementList; overload;
    {**
      Twitter Statuses::User Timeline overloaded

        @param since Filter by date
        @returns A list of Status Elements
    }
    function StatusesUserTimeline(since: TDateTime): TDweettaStatusElementList; overload;

    {**
      Twitter Statuses::Show

        @param id Filter by Status ID
        @returns A Status Element
    }
    function StatusesShow(id: Integer): TDweettaStatusElement;

    {**
      Twitter Statuses::Update overloaded

        @param status The text of the status
        @returns A Status Element
    }
    function StatusesUpdate(status: String): TDweettaStatusElement; overload;
    {**
      Twitter Statuses::Update overloaded

        @param status The text of the status
        @param in_reply_to_status_id The status ID from with we are replying
        @returns A Status Element
    }
    function StatusesUpdate(status: String; in_reply_to_status_id: Integer): TDweettaStatusElement; overload;

    {**
      Twitter Statuses::Replies overloaded

        @returns A List of Status Elements
    }
    function StatusesReplies: TDweettaStatusElementList; overload;
    {**
      Twitter Statuses::Replies overloaded

        @param since_id Filter by Status ID
        @returns A List of Status Elements
    }
    function StatusesReplies(since_id: Integer): TDweettaStatusElementList; overload;

    {**
      Twitter Statuses::Destroy

        @param id The status ID to delete
        @returns A Status Element
    }
    function StatusesDestroy(id: Integer): TDweettaStatusElement;

    {**
      Holds the Username for auth
    }
    property User: String read FUser write Setuser;
    {**
      Holds the Password for auth
    }
    property Password: String read FPassword write SetPassword;
    {**
      Holds the last numerical HTTP response code
    }
    property ResponseCode: Integer read GetResponseCode;
    {**
      Holds the last alphanumerical HTTP response code
    }
    property ResponseString: String read GetResponseString;
    {**
      Holds the remaining API calls upon last request
    }
    property RemainingCalls: Integer read GetRemainingCalls;
    {**
      Holds the Rate Limit of API Calls upon last request
    }
    property RateLimit: Integer read GetRateLimit;
    {**
      Holds when the Rate Limit expires upon last request
    }
    property RateLimitReset: TDateTime read GetRateLimitReset;
  end;

implementation

uses
  DweettaUtils;

{ TDweetta }

procedure TDweetta.SetUser ( Value: String ) ;
begin
  if Value <> FUser then
  begin
    FUser := Value;
    UpdateAuth;
  end;
end;

function TDweetta.GetRateLimit: Integer;
begin
  Result := FResponseInfo.RateLimit;
end;

function TDweetta.GetRateLimitReset: TDateTime;
begin
  Result := FResponseInfo.RateLimitReset;
end;

function TDweetta.GetRemainingCalls: Integer;
begin
  Result := FResponseInfo.RemainingCalls;
end;

function TDweetta.GetResponseCode: Integer;
begin
  Result := FResponseInfo.HTTPStatus;
end;

function TDweetta.GetResponseString: String;
begin
  Result := FResponseInfo.HTTPMessage;
end;

procedure TDweetta.SetPassword ( Value: String ) ;
begin
  if Value <> FPassword then
  begin
    FPassword := Value;
    UpdateAuth;
  end;
end;

procedure TDweetta.UpdateAuth;
begin
  FDweettaAPI.User := FUser;
  FDweettaAPI.Password := FPassword;
end;

constructor TDweetta.Create;
begin
  inherited Create;
  FDweettaAPI := TDweettaAPI.Create;
  FDweettaAPI.User := FUser;
  FDweettaAPI.Password := FPassword;
  FDweettaAPI.UserAgent := 'Dweetta/0.1 (http://dweetta.assembla.com)';
  FDweettaAPI.Server := 'twitter.com';
end;

destructor TDweetta.Destroy;
begin
  FDweettaAPI.Free;
  inherited Destroy;
end;

function TDweetta.StatusesPublicTimeline: TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_public_timeline(FResponseInfo);
end;

function TDweetta.StatusesFriendsTimeline: TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_friends_timeline('', 0, 0, 0, 0, FResponseInfo);
end;

function TDweetta.StatusesFriendsTimeline(since: TDateTime): TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_friends_timeline(DateTimeToInternetTime(since), 0, 0, 0, 0, FResponseInfo);
end;

function TDweetta.StatusesFriendsTimeline(count: Integer): TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_friends_timeline('', 0, 0, count, 0, FResponseInfo);
end;

function TDweetta.StatusesFriendsTimelinePage(page: Integer): TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_friends_timeline('', 0, 0, 0, page, FResponseInfo);
end;

function TDweetta.StatusesUserTimeline: TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_user_timeline('', 0, '', 0, 0, 0, '', FResponseInfo);
end;

function TDweetta.StatusesUserTimeline(id: integer; page: Integer): TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_user_timeline(IntToStr(id), 0, '', 0, 0, page, '', FResponseInfo);
end;

function TDweetta.StatusesUserTimeline(id: Integer; since: TDateTime): TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_user_timeline(IntToStr(id), 0, '', 0, 0, 0, DateTimeToInternetTime(since), FResponseInfo);
end;

function TDweetta.StatusesUserTimeline(screen_name: String): TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_user_timeline('', 0, screen_name, 0, 0, 0, '', FResponseInfo);
end;

function TDweetta.StatusesUserTimeline (id: Integer) : TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_user_timeline(IntToStr(id), 0, '', 0, 0, 0, '', FResponseInfo);
end;

function TDweetta.StatusesUserTimeline(screen_name: String; page: Integer): TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_user_timeline('', 0, screen_name, 0, 0, page, '', FResponseInfo);
end;

function TDweetta.StatusesUserTimeline(screen_name: String; since: TDateTime): TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_user_timeline('', 0, screen_name, 0, 0, 0, DateTimeToInternetTime(since), FResponseInfo);
end;

function TDweetta.StatusesUserTimeline(since: TDateTime): TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_user_timeline('', 0, '', 0, 0, 0, DateTimeToInternetTime(since), FResponseInfo);
end;

function TDweetta.StatusesShow(id: Integer): TDweettaStatusElement;
begin
  Result := FDweettaAPI.Statuses_show(id, FResponseInfo);
end;

function TDweetta.StatusesUpdate(status: String): TDweettaStatusElement;
begin
  Result := FDweettaAPI.Statuses_update(status, 0, FResponseInfo);
end;

function TDweetta.StatusesUpdate(status: String; in_reply_to_status_id: Integer): TDweettaStatusElement;
begin
  Result := FDweettaAPI.Statuses_update(status, in_reply_to_status_id, FResponseInfo);
end;

function TDweetta.StatusesReplies: TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_replies(0, 0, '', 0, FResponseInfo);
end;

function TDweetta.StatusesReplies(since_id: Integer): TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_replies(since_id, 0, '', 0, FResponseInfo);
end;

function TDweetta.StatusesDestroy(id: Integer): TDweettaStatusElement;
begin
  Result := FDweettaAPI.Statuses_destroy(id, FResponseInfo);
end;

end.

