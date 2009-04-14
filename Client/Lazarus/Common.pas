{*------------------------------------------------------------------------------
  Common.pas

  Common variables and definitions for the Dweetta client.

  @Author  $Author$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit Common;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

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

