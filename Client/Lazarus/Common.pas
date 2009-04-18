{*------------------------------------------------------------------------------
  Common.pas

  Common variables and definitions for the Dweetta client.

  @Author  $Author$
  @LastChangedBy $LastChangedBy$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit Common;

{$I Dweetta.inc}

interface

uses
  Classes, SysUtils;

type
  TDweettaNodeType = (tntEmpty, tntStatus, tntUser, tntUserExtended, tntDirectMessage);

  PDweettaNode = ^TDweettaNode;
  TDweettaNode = record
    NodeType: TDweettaNodeType;
    TwitterElement: TObject;
  end;

implementation

end.

