{*------------------------------------------------------------------------------
  frmMainUnit.pas

  Main form for the Dweetta Client

  @Author  $Author$
  @LastChangedBy $LastChangedBy$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit frmMainUnit;

{$I Dweetta.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, VirtualStringTree, VirtualTrees, ComCtrls, PopupNotifier, StdCtrls,
  frmSettingsUnit, Dweetta;

type

  { TfrmMain }

  TfrmMain = class ( TForm )
    btnSend: TButton;
    btnSettings: TButton;
    edtStatus: TEdit;
    memLog: TMemo;
    panLog: TPanel;
    panTop: TPanel;
    panClient: TPanel;
    pnMain: TPopupNotifier;
    sbMain: TStatusBar;
    Splitter1: TSplitter;
    tmrMain: TTimer;
    vstTweets: TVirtualStringTree;
    procedure btnSendClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure FormCreate ( Sender: TObject ) ;
    procedure FormDestroy ( Sender: TObject ) ;
    procedure tmrMainTimer(Sender: TObject);
    procedure vstTweetsFreenode ( Sender: Tbasevirtualtree; Node: Pvirtualnode
      ) ;
    procedure vstTweetsGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure vstTweetsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
  private
    { private declarations }
    FDweetta: TDweetta;
    FNextCall: TDateTime;
    FRateLimitReset: TDateTime;
    FUsername: String;
    FPassword: String;
    FfrmSettings: TfrmSettings;

    procedure GetTimeLine;
  public
    { public declarations }
    property Username: String read FUsername write FUsername;
    property Password: String read FPassword write FPassword;
  end; 

var
  frmMain: TfrmMain;

implementation

uses
  Common, DateUtils, DweettaContainers;

function GetDweettaNodeText(const ADweettaNode: PDweettaNode): String;
begin
  case ADweettaNode^.NodeType of
    tntEmpty:begin
      Result := 'Empty';
    end;
    tntStatus:begin
      Result := TDweettaStatusElement(ADweettaNode^.TwitterElement).Text;
    end;
    tntUser, tntUserExtended: begin
      Result := TDweettaUserElement(ADweettaNode^.TwitterElement).Name;
    end;
    tntDirectMessage:begin
      Result := 'Direct Message';
    end;
  end;
end;

{ TfrmMain }

procedure TfrmMain.FormCreate ( Sender: TObject ) ;
begin
  FDweetta := TDweetta.Create;
  FNextCall := IncSecond(Now, 3);
  tmrMain.Enabled := True;
end;

procedure TfrmMain.FormDestroy ( Sender: TObject ) ;
begin
  tmrMain.Enabled := False;
  FDweetta.Free;
end;

procedure TfrmMain.GetTimeline;
var
  vNode: PVirtualNode;
  TwitterNode: PDweettaNode;
  TwitterList: TDweettaStatusElementList;
  Index: Integer;
begin
  vstTweets.BeginUpdate;
  if vstTweets.RootNodeCount > 0 then
  begin
    vstTweets.Clear;
  end;
  FDweetta.User := FUsername;
  FDweetta.Password := FPassword;
  sbMain.Panels[0].Text := 'Getting timeline...';
  TwitterList := FDweetta.StatusesFriendsTimeline;
  if memLog.Lines.Count <> 0 then
    memLog.Lines.Add('-----------------------------------------------');
  memLog.Lines.Add('HTTP: ' + IntToStr(FDweetta.ResponseCode) + ':' + FDweetta.ResponseString);
  memLog.Lines.Add('Rate Limit: ' + IntToStr(FDweetta.RateLimit));
  memLog.Lines.Add('Remaining : ' + IntToStr(FDweetta.RemainingCalls));
  sbMain.Panels[0].Text := 'Processing data...';
  for Index := 0 to TwitterList.Count -1 do
  begin
    vNode := vstTweets.AddChild(vstTweets.RootNode);
    TwitterNode := vstTweets.GetNodeData(vNode);
    TwitterNode^.NodeType := tntStatus;
    TwitterNode^.TwitterElement := TwitterList.Items[Index];
  end;
  sbMain.Panels[0].Text := 'Done';
  vstTweets.EndUpdate;
end;

procedure TfrmMain.btnSendClick(Sender: TObject);
begin
  btnSend.Enabled := False;
  tmrMain.Enabled := False;

  tmrMain.Enabled := True;
  btnSend.Enabled := True;
end;

procedure TfrmMain.btnSettingsClick(Sender: TObject);
var
  ModalResult: Integer;
begin
  btnSend.Enabled := False;
  btnSettings.Enabled := False;
  tmrMain.Enabled := False;
  FfrmSettings := TfrmSettings.Create(Self);
  ModalResult := FfrmSettings.ShowModal;
  FfrmSettings.Free;
  tmrMain.Enabled := True;
  btnSettings.Enabled := True;
  btnSend.Enabled := True;
end;

procedure TfrmMain.tmrMainTimer(Sender: TObject);
begin
  sbMain.Panels[0].Text := 'Ready (' + DateTimeToStr(FNextCall) + ')';
  if CompareTime(Now, FNextCall) = -1 then exit;
  if Length(FUsername) = 0 then
  begin
     FNextCall := IncMinute(Now, 2);
     exit;
  end;
  GetTimeline;
  FNextCall := IncMinute(Now, 2);
end;

procedure TfrmMain.vstTweetsFreenode(Sender: Tbasevirtualtree;
  Node: Pvirtualnode);
var
  TwitterNode: PDweettaNode;
begin
  if Assigned(Node) then
  begin
    TwitterNode := Sender.GetNodeData(Node);
    if Assigned(TwitterNode) then
    begin
      if Assigned(TwitterNode^.TwitterElement) then
      begin
        case TwitterNode^.NodeType of
          tntStatus:begin
            TDweettaStatusElement(TwitterNode^.TwitterElement).Free;
          end;
          tntUser, tntUserExtended:begin
            TDweettaUserElement(TwitterNode^.TwitterElement).Free;
          end;
          tntDirectMessage:begin
            TDweettaDirectMessageElement(TwitterNode^.TwitterElement).Free;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.vstTweetsGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TDweettaNode);
end;

procedure TfrmMain.vstTweetsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  TwitterNode: PDweettaNode;
begin
  if Assigned(Node) then
  begin
    TwitterNode := Sender.GetNodeData(Node);
    if Assigned(TwitterNode) then
    begin
      case Column of
        -1,0:begin
          CellText := GetDweettaNodeText(TwitterNode);
        end;
      end;
    end;
  end;
end;

initialization
  {$I frmMainUnit.lrs}

end.

