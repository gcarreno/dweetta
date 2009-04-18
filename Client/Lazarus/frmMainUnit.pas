{*------------------------------------------------------------------------------
  frmMainUnit.pas

  Main form for the Dweetta Client

  @Author  $Author$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit frmMainUnit;

{$I Dweetta.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, VirtualStringTree, VirtualTrees, ComCtrls, PopupNotifier, StdCtrls,
  Dweetta;

type

  { TfrmMain }

  TfrmMain = class ( TForm )
    btnTest: TButton;
    edtUsername: TEdit;
    edtPassword: TEdit;
    panTop: TPanel;
    panClient: TPanel;
    pnMain: TPopupNotifier;
    sbMain: TStatusBar;
    vstTweets: TVirtualStringTree;
    procedure btnTestClick(Sender: TObject);
    procedure FormCreate ( Sender: TObject ) ;
    procedure FormDestroy ( Sender: TObject ) ;
    procedure vstTweetsFreenode ( Sender: Tbasevirtualtree; Node: Pvirtualnode
      ) ;
    procedure vstTweetsGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure vstTweetsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
  private
    { private declarations }
    FDweetta: TDweetta;
  public
    { public declarations }
  end; 

var
  frmMain: TfrmMain;

implementation

uses
  Common, DweettaContainers;

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
end;

procedure TfrmMain.btnTestClick(Sender: TObject);
var
  vNode: PVirtualNode;
  TwitterNode: PDweettaNode;
  TwitterList: TDweettaStatusElementList;
  Index: Integer;
begin
  btnTest.Enabled := False;
  vstTweets.BeginUpdate;
  if vstTweets.RootNodeCount > 0 then
  begin
    vstTweets.Clear;
  end;
  FDweetta.User := edtUsername.Text;
  FDweetta.Password := edtPassword.Text;
  TwitterList := FDweetta.StatusesUserTimeline;
  for Index := 0 to TwitterList.Count -1 do
  begin
    vNode := vstTweets.AddChild(vstTweets.RootNode);
    TwitterNode := vstTweets.GetNodeData(vNode);
    TwitterNode^.NodeType := tntStatus;
    TwitterNode^.TwitterElement := TwitterList.Items[Index];
  end;
  vstTweets.EndUpdate;
  btnTest.Enabled := True;
end;

procedure TfrmMain.FormDestroy ( Sender: TObject ) ;
begin
  FDweetta.Free;
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

