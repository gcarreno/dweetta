unit frmMainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, VirtualStringTree;

type

  { TfrmMain }

  TfrmMain = class ( TForm )
    panTop: TPanel;
    panClient: TPanel;
    VirtualStringTree1: TVirtualStringTree;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmMain: TfrmMain;

implementation

initialization
  {$I frmMainUnit.lrs}

end.

