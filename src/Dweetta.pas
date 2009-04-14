{*------------------------------------------------------------------------------
  Dweetta.pas

  This unit contains the main Dweetta Object

  @Author  $Author$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit Dweetta;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, DweettaAPI, DweettaContainers;

type
{ TDweetta }

  TDweetta = class(TObject)
  private
    FUser: String;
    FPassword: String;
    FDweettaAPI: TDweettaAPI;

    procedure SetUser(Value: String);
    procedure SetPassword(Value: String);
    procedure UpdateAuth;
  public
    constructor Create;
    destructor Destroy; override;

    function StatusesPublicTimeline: TDweettaStatusElementList;
    function StatusesFriendsTimeline: TDweettaStatusElementList; overload;
    function StatusesFriendsTimeline(since: String): TDweettaStatusElementList; overload;
    function StatusesUserTimeline: TDweettaStatusElementList; overload;
    function StatusesUserTimeline(id: String): TDweettaStatusElementList; overload;

    property User: String read FUser write Setuser;
    property Password: String read FPassword write SetPassword;
  end;

implementation

{ TDweetta }

procedure TDweetta.SetUser ( Value: String ) ;
begin
  if Value <> FUser then
  begin
    FUser := Value;
    UpdateAuth;
  end;
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
  FDweettaAPI.UserAgent := 'Dweetta/0.1';
  FDweettaAPI.Server := 'twitter.com';
end;

destructor TDweetta.Destroy;
begin
  FDweettaAPI.Free;
  inherited Destroy;
end;

function TDweetta.StatusesPublicTimeline: TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_public_timeline;
end;

function TDweetta.StatusesFriendsTimeline: TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_friends_timeline('', 0, 0, 0, 0);
end;

function TDweetta.StatusesFriendsTimeline(since: String): TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_friends_timeline(since, 0, 0, 0, 0);
end;

function TDweetta.StatusesUserTimeline: TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_user_timeline('', 0, '', 0, 0, 0, '');
end;

function TDweetta.StatusesUserTimeline ( id: String ) : TDweettaStatusElementList;
begin
  Result := FDweettaAPI.Statuses_user_timeline(id, 0, '', 0, 0, 0, '');
end;

end.

