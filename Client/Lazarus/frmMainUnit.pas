{*------------------------------------------------------------------------------
  frmMainUnit.pas

  Main form for the Dweetta Client

  @Author  $Author$
  @Version $Id$
-------------------------------------------------------------------------------}
unit frmMainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, VirtualStringTree, ComCtrls, PopupNotifier, Common, Dweetta;

type

  { TfrmMain }

  TfrmMain = class ( TForm )
    panTop: TPanel;
    panClient: TPanel;
    pnMain: TPopupNotifier;
    sbMain: TStatusBar;
    vstTweets: TVirtualStringTree;
    procedure FormCreate ( Sender: TObject ) ;
    procedure FormDestroy ( Sender: TObject ) ;
  private
    { private declarations }
    FDweetta: TDweetta;
  public
    { public declarations }
  end; 

var
  frmMain: TfrmMain;

implementation

{ TfrmMain }

procedure TfrmMain.FormCreate ( Sender: TObject ) ;
begin
  FDweetta := TDweetta.Create;
end;

procedure TfrmMain.FormDestroy ( Sender: TObject ) ;
begin
  FDweetta.Free;
end;

initialization
  {$I frmMainUnit.lrs}

end.

