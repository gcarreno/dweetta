unit frmMainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, VirtualStringTree, ComCtrls, PopupNotifier, Dweetta;

type

  { TfrmMain }

  TfrmMain = class ( TForm )
    panTop: TPanel;
    panClient: TPanel;
    pnMain: TPopupNotifier;
    sbMain: TStatusBar;
    vstTweets: TVirtualStringTree;
  private
    { private declarations }
    FDweetta: TDweetta;
  public
    { public declarations }
  end; 

var
  frmMain: TfrmMain;

implementation

initialization
  {$I frmMainUnit.lrs}

end.

