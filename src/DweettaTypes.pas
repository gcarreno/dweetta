{*------------------------------------------------------------------------------
  DweettaTypes.pas

  This unit contains misc Dweetta Types

  @Author  $Author$
  @LastChangedBy $LastChangedBy$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit DweettaTypes;

{$I Dweetta.inc}

interface

uses
  Classes, SysUtils; 

type
{ TDweettaServices }

  TDweettaServices = (
    tsStatusesPublicTimeline,
    tsStatusesFriendsTimeline,
    tsStatusesUserTimeline,
    tsStatusesShow,
    tsStatusesUpdate,
    tsStatusesReplies,
    tsStatusesDestroy,
    tsUsersFriends,
    tsUsersFollowers,
    tsUsersShow,
    tsDirectMessagesDirectMessages,
    tsDirectMessagesSent,
    tsDirectMessagesNew,
    tsDirectMessagesDestroy,
    tsFrienshipsCreate,
    tsFriendshipsDestroy,
    tsFriendshipsExists,
    tsFriendsIds,
    tsFollowersIds,
    tsAccountVerifyCredentials,
    tsAccountEndSession,
    tsAccountUpdateLocation,
    tsAccountUpdateDeliveryDevice,
    tsAccountUpdateProfileColors,
    tsAccountUpdateProfileImage,
    tsAccountUpdateProfileBackgroundImage,
    tsAccountRateLimitStatus,
    tsAccountUpdateProfile,
    tsFavoritesFavorites,
    tsFavoritesCreate,
    tsFavoritesDestroy,
    tsNotificationsFollow,
    tsNotificationsLeave,
    tsBlocksCreate,
    tsBlocksDestroy,
    tsHelpTest);

{ cDweettaServiceEndPoints }
const
  cDweettaServiceEndPoints:
    array[tsStatusesPublicTimeline..tsHelpTest] of String =
    ('/statuses/public_timeline',
     '/statuses/friends_timeline',
     '/statuses/user_timeline',
     '/statuses/show',
     '/statuses/update',
     '/statuses/replies',
     '/statuses/destroy',
     '/statuses/friends',
     '/statuses/followers',
     '/users/show',
     '/direct_messages',
     '/direct_messages/sent',
     '/direct_messages/new',
     '/direct_messages/destroy',
     '/friendships/create',
     '/friendships/destroy',
     '/friendships/exists',
     '/friends/ids',
     '/followers/ids',
     '/account/verify_credentials',
     '/account/end_session',
     '/account/update_location',
     '/account/update_delivery_device',
     '/account/update_profile_colors',
     '/account/update_profile_image',
     '/account/update_profile_background_image',
     '/account/rate_limit_status',
     '/account/update_profile',
     '/favorites',
     '/favorites/create',
     'favorites/destroy',
     '/notifications/follow',
     '/notifications/leave',
     '/blocks/create',
     '/blocks/destroy',
     '/help/test');

type
{ TDweettaResponseInfo }

  TDweettaResponseInfo = record
    HTTPStatus: Integer;
    HTTPMessage: String;
    RemainingCalls: Integer;
    RateLimit: Integer;
  end;

implementation

end.

