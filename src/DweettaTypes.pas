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

  TDweettaServices = (tsStatusesPublicTimeline, tsStatusesFriendsTimeline,
    tsStatusesUserTimeline, tsStatusesShow, tsStatusesUpdate, tsStatusesReplies,
    tsStatusesDestroy);

{ cDweettaServiceEndPoints }
const
  cDweettaServiceEndPoints: array[tsStatusesPublicTimeline..tsStatusesDestroy] of String =
    ('/statuses/public_timeline', '/statuses/friends_timeline',
     '/statuses/user_timeline', '/statuses/show', '/statuses/update',
     '/statuses/replies', '/statuses/destroy');

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

