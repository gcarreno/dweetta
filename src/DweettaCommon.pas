unit DweettaCommon;

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

