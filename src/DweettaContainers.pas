{*------------------------------------------------------------------------------
  DweettaContainers.pas

  This unit contains the containers for the Dweetta API responses

  @Author  $Author$
  @LastChangedBy $LastChangedBy$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit DweettaContainers;

{$I Dweetta.inc}

interface

uses
  Classes, SysUtils, Contnrs;

type
  // Forward Declarations
  TDweettaStatusElement = class;

  TDweettaUserElementClass = class of TDweettaUserElement;

{ TDweettaUserElement }

  TDweettaUserElement = class(TObject)
  private
    FId: Integer;
    FName: String;
    FScreenName: String;
    FDescription: String;
    FLocation: String;
    FProfileImageURL: String;
    FURL: String;
    FProtected: Boolean;
    FFollowersCount: Integer;
    FIsExtended: Boolean;
    // Extended
    FProfileBackgroundColor: String;
    FProfileTextColor: String;
    FProfileLinkColor: String;
    FProfileSidebarFillColor: String;
    FProfileSidebarBorderColor: String;
    FFriendsCount: Integer;
    FCreatedAt: String; // Should be TDateTime in next incarnation
    FFavouritesCount: Integer;
    FUTCOffset: Integer; // number of seconds between a user's registered time zone and Coordinated Universal Time
    FTimeZone: String; // This should be treated better internally, next incarnation...
    FProfileBackgroundImageURL: String;
    FProfileBackgroundTile: Boolean;
    FFollowing: Boolean;
    FNotifications: Boolean;
    FStatusesCount: Integer;
    // Status Child Object
    FHasStatus: Boolean;
    FStatus: TDweettaStatusElement;
  public
    constructor Create; overload;
    constructor Create(HasStatus: Boolean); overload;
    destructor Destroy; override;

    function LoadFromString(AInString: String): TDweettaUserElement;

    property Id: Integer read FId write FId;
    property Name: String read FName write FName;
    property ScreenName: String read FScreenName write FScreenName;
    property Description: String read FDescription write FDescription;
    property Location: String read FLocation write FLocation;
    property ProfileImageURL: String read FProfileImageURL write FProfileImageURL;
    property URL: String read FURL write FURL;
    property isProtected: Boolean read FProtected write FProtected;
    property FollowersCount: Integer read FFollowersCount write FFollowersCount;

    property isExtended: Boolean read FIsExtended;
    property ProfileBackgroundColor: String read FProfileBackgroundColor write FProfileBackgroundColor;
    property ProfileTextColor: String read FProfileTextColor write FProfileTextColor;
    property ProfileLinkColor: String read FProfileLinkColor write FProfileLinkColor;
    property ProfileSidebarFillColor: String read FProfileSidebarFillColor write FProfileSidebarFillColor;
    property ProfileSidebarBorderColor: String read FProfileSidebarBorderColor write FProfileSidebarBorderColor;
    property FriendsCount: Integer read FFriendsCount write FFriendsCount;
    property CreatedAt: String read FCreatedAt write FCreatedAt;
    property FavoritesCount: Integer read FFavouritesCount write FFavouritesCount;
    property UTCOffset: Integer read FUTCOffset write FUTCOffset;
    property TimeZone: String read FTimeZone write FTimeZone;
    property ProfileBackgroundImageURL: String read FProfileBackgroundImageURL write FProfileBackgroundImageURL;
    property isProfileBackgroundTiled: Boolean read FProfileBackgroundTile write FProfileBackgroundTile;
    property isFollowing: Boolean read FFollowing write FFollowing;
    property hasNotifications: Boolean read FNotifications write FNotifications;
    property StatusesCount: Integer read FStatusesCount write FStatusesCount;

    property HasStatus: Boolean read FHasStatus;
    property Status: TDweettaStatusElement read FStatus;
  end;

{ TDweettaUserElementList }

  TDweettaUserElementList = class(TObjectList)
  private
    function GetItem(Index: Integer): TDweettaUserElement;
    procedure SetItem(Index: Integer; ADweettaUserElement: TDweettaUserElement);
  public
    procedure LoadFromString(const AInString: String);

    property Items[Index: Integer]: TDweettaUserElement read GetItem write SetItem; default;
  end;

  TDweettaStatusElementClass = class of TDweettaStatusElement;
  
{ TDweettaStatusElement }

  TDweettaStatusElement = class(TObject)
  private
    FCreatedAt: String; // Should be TDateTime in next incarnation
    FId: Integer;
    FText: String;
    FSource: String;
    FTruncated: Boolean;
    FInReplyToStatusID: Integer;
    FInReplyToUserID: Integer;
    FInReplyToScreenName: String; // Present in Basic User Info.
    FFavorited: Boolean;
    // User child object
    FHasUser: Boolean;
    FUser: TDweettaUserElement;
  public
    constructor Create; overload;
    constructor Create(HasUser: Boolean); overload;
    destructor Destroy; override;

    function LoadFromString(AInString: String): TDweettaStatusElement;

    property CreatedAt: String read FCreatedAt write FCreatedAt;
    property Id: Integer read FId write FId;
    property Text: String read FText write FText;
    property Source: String read FSource write FSource;
    property isTruncated: Boolean read FTruncated write FTruncated;
    property InReplyToStatusID: Integer read FInReplyToStatusID write FInReplyToStatusID;
    property InReplyToUserID: Integer read FInReplyToUserID write FInReplyToUserID;
    property InReplyToScreenName: String read FInReplyToScreenName write FInReplyToScreenName;
    property isFavorited: Boolean read FFavorited write FFavorited;
    property HasUser: Boolean read FHasUser;
    property User: TDweettaUserElement read FUser;
  end;

{ TDweettaStatusElementList }

  TDweettaStatusElementList = class(TObjectList)
  private
    function GetItem(Index: Integer): TDweettaStatusElement;
    procedure SetItem(Index: Integer; ADweettaStatusElement: TDweettaStatusElement);
  public
    procedure LoadFromString(const AInString: String);

    property Items[Index: Integer]: TDweettaStatusElement read GetItem write SetItem; default;
  end;

{ TDweettaDirectMessageElement }

  TDweettaDirectMessageElement = class(TObject)
  private
    FId: Integer;
    FSenderID: Integer;
    FText: String;
    FRecipientID: Integer;
    FCreatedAt: String; // Should be TDateTime in next incarnation
    FSenderScreenName: String;
    FRecipientScreenName: String;
    FSender: TDweettaUserElement; // On Basic mode
    FRecipient: TDweettaUserElement; // On Basic mode
  public
    constructor Create; overload;
    constructor Create(const ASender: TDweettaUserElement; const ARecipient: TDweettaUserElement); overload;
    destructor Destroy; override;

    function LoadFromString(AInString: String): TDweettaDirectMessageElement;

    property Id: Integer read FId write FId;
    property SenderID: Integer read FSenderID write FSenderID;
    property Text: String read FText write FText;
    property RecipientID: Integer read FRecipientID write FRecipientID;
    property CreatedAt: String read FCreatedAt write FCreatedAt;
    property SenderScreenName: String read FSenderScreenName write FSenderScreenName;
    property RecipientScreenName: String read FRecipientScreenName write FRecipientScreenName;
    property Sender: TDweettaUserElement read FSender;
    property Recipient: TDweettaUserElement read FRecipient;
  end;

{ TDweettaDirectMessageElementList }

  TDweettaDirectMessageElementList = class(TObjectList)
  private
    function GetItem(Index: Integer): TDweettaDirectMessageElement;
    procedure SetItem(Index: Integer; ADweettaDirectMessageElement: TDweettaDirectMessageElement);
  public
    procedure LoadFromString(const AInString: String);

    property Items[Index: Integer]: TDweettaDirectMessageElement read GetItem write SetItem; default;
  end;

implementation

uses
  SuperObject;

{ Helper Functions }
function LoadUserElement(const AInObject: ISuperObject; HasStatus: Boolean = True): TDweettaUserElement; forward;

function LoadStatusElement(const AInObject: ISuperObject; HasUser: Boolean = True): TDweettaStatusElement;
begin
  Result := TDweettaStatusElement.Create(HasUser);
  Result.FCreatedAt := AInObject['created_at'].AsString;
  Result.FId := AInObject['id'].AsInteger;
  Result.FText := AInObject['text'].AsString;
  Result.FSource := AInObject['source'].AsString;
  Result.FTruncated := AInObject['truncated'].AsBoolean;
  Result.FInReplyToStatusID := AInObject['in_reply_to_status_id'].AsInteger;
  Result.FInReplyToUserID := AInObject['in_reply_to_user_id'].AsInteger;
  Result.FFavorited := AInObject['favorited'].AsBoolean;
  if HasUser then
  begin
    Result.FHasUser:= True;
    Result.FUser := LoadUserElement(AInObject['user'], False);
  end;
end;

function LoadUserElement(const AInObject: ISuperObject; HasStatus: Boolean = True): TDweettaUserElement;
begin
  Result := TDweettaUserElement.Create(HasStatus);
  Result.FId := AInObject['id'].AsInteger;
  Result.FName := AInObject['name'].AsString;
  Result.FScreenName := AInObject['screen_name'].AsString;
  Result.FDescription := AInObject['description'].AsString;
  Result.FLocation := AInObject['location'].AsString;
  Result.FProfileImageURL := AInObject['profile_image_url'].AsString;
  Result.FURL := AInObject['url'].AsString;
  Result.FProtected := AInObject['protected'].AsBoolean;
  Result.FFollowersCount := AInObject['followers_count'].AsInteger;
  if HasStatus then
  begin
    Result.FHasStatus:= True;
    Result.FStatus := LoadStatusElement(AInObject['status'], False);
  end;
end;

function LoadUserExtendedElement(const AInObject: ISuperObject): TDweettaUserElement;
begin
  Result := TDweettaUserElement.Create(False);
  Result.FId := AInObject['id'].AsInteger;
  Result.FName := AInObject['name'].AsString;
  Result.FScreenName := AInObject['screen_name'].AsString;
  Result.FDescription := AInObject['description'].AsString;
  Result.FLocation := AInObject['location'].AsString;
  Result.FProfileImageURL := AInObject['profile_image_url'].AsString;
  Result.FURL := AInObject['url'].AsString;
  Result.FProtected := AInObject['protected'].AsBoolean;
  Result.FFollowersCount := AInObject['followers_count'].AsInteger;
  Result.FIsExtended := True;
  Result.FProfileBackgroundColor:= AInObject['profile_background_color'].AsString;
  Result.FProfileTextColor:= AInObject['profile_text_color'].AsString;
  Result.FProfileLinkColor:= AInObject['profile_link_color'].AsString;
  Result.FProfileSidebarFillColor:= AInObject['profile_sidebar_fill_color'].AsString;
  Result.FProfileSidebarBorderColor:= AInObject['profile_sidebar_border_color'].AsString;
  Result.FFriendsCount:= AInObject['followers_count'].AsInteger;
  Result.FCreatedAt:= AInObject['friends_count'].AsString;
  Result.FFavouritesCount:= AInObject['favourites'].AsInteger;
  Result.FUTCOffset:= AInObject['followers_count'].AsInteger;
  Result.FTimeZone:= AInObject['profile_image_url'].AsString;
  Result.FProfileBackgroundImageURL:= AInObject['profile_image_url'].AsString;
  Result.FProfileBackgroundTile:= AInObject['protected'].AsBoolean;
  Result.FFollowing:= AInObject['protected'].AsBoolean;
  Result.FNotifications:= AInObject['protected'].AsBoolean;
  Result.FStatusesCount:= AInObject['followers_count'].AsInteger;
end;

function LoadDirectMessageElement(const AInObject: ISuperObject): TDweettaDirectMessageElement;
var
  Sender, Recipient: TDweettaUserElement;
begin
  Sender := LoadUserElement(AInObject['sender'], False);
  Recipient := LoadUserElement(AInObject['recipient'], False);
  Result := TDweettaDirectMessageElement.Create(Sender, Recipient);
  Result.FId := AInObject['id'].AsInteger;
  Result.FSenderID := AInObject['sender_id'].AsInteger;
  Result.FText := AInObject['text'].AsString;
  Result.FRecipientID := AInObject['recipient_id'].AsInteger;
  Result.FCreatedAt := AInObject['created_at'].AsString;
  Result.FSenderScreenName := AInObject['sender_screen_name'].AsString;
  Result.FRecipientScreenName := AInObject['recipient_screen_name'].AsString;
end;

{ TDweettaUserElementList }

function TDweettaUserElementList.Getitem ( Index: Integer
  ) : TDweettaUserElement;
begin
  Result := TDweettaUserElement(inherited Get(Index));
end;

procedure TDweettaUserElementList.Setitem ( Index: Integer;
  ADweettaUserElement: TDweettaUserElement ) ;
var
  O: TDweettaUserElement;
begin
  if OwnsObjects then
  begin
    O := GetItem(Index);
    O.Free;
  end;
  Put(Index, Pointer(ADweettaUserElement));
end;

procedure TDweettaUserElementList.LoadFromString(const AInString: String);
var
  Users: ISuperObject;
  Index: Integer;
begin
  Users := SO(AInString);
  if ObjectGetType(Users) = stArray then
  begin
    for Index := 0 to Users.AsArray.Length - 1 do
    begin
      Add(LoadUserElement(Users.AsArray[Index]));
    end;
  end;
end;

{ TDweettaStatusElementList }

function TDweettaStatuselEmentList.Getitem ( Index: Integer
  ) : TDweettaStatusElement;
begin
  Result := TDweettaStatusElement(inherited Get(Index));
end;

procedure TDweettaStatuselEmentList.Setitem ( Index: Integer;
  ADweettaStatusElement: TDweettaStatusElement ) ;
var
  O: TDweettaStatusElement;
begin
  if OwnsObjects then
  begin
    O := GetItem(Index);
    O.Free;
  end;
  Put(Index, Pointer(ADweettaStatusElement));
end;

procedure TDweettaStatusElementList.LoadFromString ( const AInString: String ) ;
var
  Statuses: ISuperObject;
  Index: Integer;
begin
  Statuses := SO(AInString);
  if ObjectGetType(Statuses) = stArray then
  begin
    for Index := 0 to Statuses.AsArray.Length - 1 do
    begin
      Add(LoadStatusElement(Statuses.AsArray[Index]));
    end;
  end;
end;

{ TDweettaDirectMessageElementList }

function TDweettaDirectMessageElementList.Getitem ( Index: Integer
  ) : TDweettaDirectMessageElement;
begin
  Result := TDweettaDirectMessageElement(inherited Get(Index));
end;

procedure TDweettaDirectMessageElementList.Setitem ( Index: Integer;
  ADweettaDirectMessageElement: TDweettaDirectMessageElement ) ;
var
  O: TDweettaDirectMessageElement;
begin
  if OwnsObjects then
  begin
    O := GetItem(Index);
    O.Free;
  end;
  Put(Index, Pointer(ADweettaDirectMessageElement));
end;

procedure TDweettaDirectMessageElementList.LoadFromString(
  const AInString: String);
var
  DirectMessages: ISuperObject;
  Index: Integer;
begin
  DirectMessages := SO(AInString);
  if ObjectGetType(DirectMessages) = stArray then
  begin
    for Index := 0 to DirectMessages.AsArray.Length -1 do
    begin
      Add(LoadDirectMessageElement(DirectMessages.AsArray[Index]));
    end;
  end;
end;

{ TDweettaUserElement }

constructor TDweettauserelement.Create;
begin
  inherited Create;
  FHasStatus := True;
  FStatus := TDweettaStatusElement.Create(False);
end;

constructor TDweettauserelement.Create ( HasStatus: Boolean ) ;
begin
  inherited Create;
  FHasStatus := HasStatus;
  if FHasStatus then
  begin
    FStatus := TDweettaStatusElement.Create(False);
  end
  else
  begin
    FStatus := nil;
  end;
end;

destructor TDweettauserelement.Destroy;
begin
  if (FHasStatus) and (Assigned(FStatus)) then
  begin
    FStatus.Free;
  end;
  inherited Destroy;
end;

function TDweettaUserElement.LoadFromString(AInString: String
  ): TDweettaUserElement;
var
  User: ISuperObject;
begin
  User := SO(AInString);
  Result := LoadUserElement(User);
end;

{ TDweettaStatusElement }

constructor TDweettaStatusElement.Create;
begin
  inherited Create;
  FHasUser := True;
  FUser := TDweettaUserElement.Create(False);
end;

constructor TDweettaStatusElement.Create ( HasUser: Boolean ) ;
begin
  inherited Create;
  FHasUser := HasUser;
  if FHasUser then
  begin
    FUser := TDweettaUserElement.Create(False);
  end
  else
  begin
    FUser := nil;
  end;
end;

destructor TDweettaStatusElement.Destroy;
begin
  if (FHasUser) and (Assigned(FUser)) then
  begin
    FUser.Free;
  end;
  inherited Destroy;
end;

function TDweettaStatusElement.LoadFromString(AInString: String
  ): TDweettaStatusElement;
var
  Status: ISuperObject;
begin
  Status := SO(AInString);
  Result := LoadStatusElement(Status);
end;

{ TDweettaDirectMessageElement }

constructor TDweettaDirectMessageElement.Create;
begin
  inherited Create;
  FSender := TDweettaUserElement.Create(False);
  FRecipient := TDweettaUserElement.Create(False);
end;

constructor TDweettaDirectMessageElement.Create ( const ASender:TDweettaUserElement;
  const ARecipient: TDweettaUserElement ) ;
begin
  inherited Create;
  FSender := ASender;
  FRecipient := ARecipient;
end;

destructor TDweettaDirectMessageElement.Destroy;
begin
  if Assigned(FSender) then
  begin
    FSender.Free;
  end;
  if Assigned(FRecipient) then
  begin
    FRecipient.Free;
  end;
  inherited Destroy;
end;

function TDweettaDirectMessageElement.LoadFromString(AInString: String
  ): TDweettaDirectMessageElement;
var
  DirectMsg: ISuperObject;
begin
  DirectMsg := SO(AInString);
  Result := LoadDirectMessageElement(DirectMsg);
end;

end.
