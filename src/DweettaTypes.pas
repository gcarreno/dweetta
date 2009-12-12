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
  DweettaTypes.pas

  This unit contains misc Dweetta Types

  @Author  $Author$
}
unit DweettaTypes;

//  @LastChangedBy $LastChangedBy$
//  @Version $Rev$

{$I Dweetta.inc}

interface

uses
  Classes, SysUtils;

type
{ TDweettaServices }
  {**
    List of all the Twitter API service endpoints
  }
  TDweettaServices = (
      { Statuses }
    tsStatusesPublicTimeline,
    tsStatusesFriendsTimeline,
    tsStatusesUserTimeline,
    tsStatusesShow,
    tsStatusesUpdate,
    tsStatusesReplies,
    tsStatusesDestroy,
      { Users }
    tsUsersFriends,
    tsUsersFollowers,
    tsUsersShow,
      { Direct Messages }
    tsDirectMessagesDirectMessages,
    tsDirectMessagesSent,
    tsDirectMessagesNew,
    tsDirectMessagesDestroy,
      { Friendship }
    tsFriendshipsCreate,
    tsFriendshipsDestroy,
    tsFriendshipsExists,
    tsFriendsIds,
      { Followers }
    tsFollowersIds,
      { Account }
    tsAccountVerifyCredentials,
    tsAccountEndSession,
    tsAccountUpdateLocation,
    tsAccountUpdateDeliveryDevice,
    tsAccountUpdateProfileColors,
    tsAccountUpdateProfileImage,
    tsAccountUpdateProfileBackgroundImage,
    tsAccountRateLimitStatus,
    tsAccountUpdateProfile,
      { Favorites }
    tsFavoritesFavorites,
    tsFavoritesCreate,
    tsFavoritesDestroy,
      { Notifications }
    tsNotificationsFollow,
    tsNotificationsLeave,
      { Blocks }
    tsBlocksCreate,
    tsBlocksDestroy,
      { Help }
    tsHelpTest);

const
{ cDweettaServiceEndPoints }
  {**
    List of the Paths to the Twitter API end points
  }
  cDweettaServiceEndPoints:
    array[tsStatusesPublicTimeline..tsHelpTest] of String =
    (  { Statuses }
     '/statuses/public_timeline',
     '/statuses/friends_timeline',
     '/statuses/user_timeline',
     '/statuses/show',
     '/statuses/update',
     '/statuses/replies',
     '/statuses/destroy',
       { Users }
     '/statuses/friends',
     '/statuses/followers',
     '/users/show',
       { Direct Messages }
     '/direct_messages',
     '/direct_messages/sent',
     '/direct_messages/new',
     '/direct_messages/destroy',
       { Friendship }
     '/friendships/create',
     '/friendships/destroy',
     '/friendships/exists',
     '/friends/ids',
        { Followers }
     '/followers/ids',
       { Account }
     '/account/verify_credentials',
     '/account/end_session',
     '/account/update_location',
     '/account/update_delivery_device',
     '/account/update_profile_colors',
     '/account/update_profile_image',
     '/account/update_profile_background_image',
     '/account/rate_limit_status',
     '/account/update_profile',
       { Favorites }
     '/favorites',
     '/favorites/create',
     '/favorites/destroy',
       { Notifications }
     '/notifications/follow',
     '/notifications/leave',
       { Blocks }
     '/blocks/create',
     '/blocks/destroy',
       { Help }
     '/help/test');

type
{ TDweettaParams }
  {**
    List of the major categories of Twitter params
  }
  TDweettaParams = (
    tpUserId,
    tpScreenName,
    tpStatusId,
    tpSince,
    tpSinceId,
    tpStatus
  );
{ TDweettaParamsData }
  {**
    Record to hold params data
  }
  TDweettaParamsData = record
    paramName: String;
    paramSize: Integer;
    dataType: String;
    defaultValue: String;
  end;

const
{ cDweettaParamInfo }
  {**
    Param info
  }
  cDweettaParamInfo:
    array[tpUserId..tpStatus] of TDweettaParamsData =
    (
      (paramName: 'id'; paramSize: 0; dataType: 'int'; defaultValue: '0'),
      (paramName: 'screen_name'; paramSize: 0; dataType: 'str'; defaultValue: ''),
      (paramName: 'id'; paramSize: 0; dataType: 'int'; defaultValue: '0'),
      (paramName: 'since'; paramSize: 0; dataType: 'str'; defaultValue: ''),
      (paramName: 'since_id'; paramSize: 0; dataType: 'int'; defaultValue: '0'),
      (paramName: 'status'; paramSize: 140; dataType: 'str'; defaultValue: '')
    );

type
{ TDweettaResponseInfo }
  {**
    Data to simplify return of multiple values inside HTTP callings
  }
  TDweettaResponseInfo = record
    HTTPStatus: Integer;
    HTTPMessage: String;
    RemainingCalls: Integer;
    RateLimit: Integer;
    RateLimitReset: TDateTime;
  end;

implementation

end.

