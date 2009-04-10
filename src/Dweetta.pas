{*------------------------------------------------------------------------------
  Dweetta.pas

  This unit contains the main Dweetta Object

  @Author  $Author$
  @Version $Id$
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
    FDweettaUser: String;
    FDweettaPassword: String;
    FDweettaAPI: TDweettaAPI;

    procedure SetUser(Value: String);
    procedure SetPassword(Value: String);
    procedure UpdateAuth;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    function PublicTimeline: TDweettaStatusElementList;
    function FriendsTimeline: TDweettaStatusElementList; overload;
    function FriendsTimeline(since: String): TDweettaStatusElementList; overload;
    function UserTimeline: TDweettaStatusElementList; overload;
    function UserTimeline(id: String): TDweettaStatusElementList; overload;

    property DweettaUser: String read FDweettaUser write FDweettaUser;
    property DweettaPassword: String read FDweettaPassword write FDweettaPassword;
  published
  end;

implementation

{ TDweetta }

procedure TDweetta.SetUser ( Value: String ) ;
begin
  if Value <> FDweettaUser then
  begin
    FDweettaUser := Value;
    UpdateAuth;
  end;
end;

procedure TDweetta.SetPassword ( Value: String ) ;
begin
  if Value <> FDweettaPassword then
  begin
    FDweettaPassword := Value;
    UpdateAuth;
  end;
end;

procedure TDweetta.UpdateAuth;
begin
  FDweettaAPI.User := FDweettaUser;
  FDweettaAPI.Password := FDweettaPassword;
end;

constructor TDweetta.Create;
begin
  inherited Create;
  FDweettaAPI := TDweettaAPI.Create;
  FDweettaAPI.User := FDweettaUser;
  FDweettaAPI.Password := FDweettaPassword;
  FDweettaAPI.UserAgent := 'Dweetta/0.1';
  FDweettaAPI.Server := 'Dweetta.com';
end;

destructor TDweetta.Destroy;
begin
  FDweettaAPI.Free;
  inherited Destroy;
end;

function TDweetta.PublicTimeline: TDweettaStatusElementList;
begin
  Result := FDweettaAPI.public_timeline;
end;

function TDweetta.FriendsTimeline: TDweettaStatusElementList;
begin
  Result := FDweettaAPI.friends_timeline('', 0, 0, 0, 0);
end;

function TDweetta.FriendsTimeline(since: String): TDweettaStatusElementList;
begin
  Result := FDweettaAPI.friends_timeline(since, 0, 0, 0, 0);
end;

function TDweetta.UserTimeline: TDweettaStatusElementList;
begin
  Result := FDweettaAPI.user_timeline('', 0, '', 0, 0, 0, '');
end;

function TDweetta.UserTimeline ( id: String ) : TDweettaStatusElementList;
begin
  Result := FDweettaAPI.user_timeline(id, 0, '', 0, 0, 0, '');
end;

end.

