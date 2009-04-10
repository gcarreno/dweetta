{*------------------------------------------------------------------------------
  DweettaClient.lpr

  Dweetta Client project

  @Author  $Author$
  @Version $Rev$
-------------------------------------------------------------------------------}
program DweettaClient;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, frmMainUnit, virtualtreeslcl, Common,
  DweettaTransport, Dweetta, DweettaAPI, DweettaContainers,
  DweettaSockets;

{$IFDEF WINDOWS}
  {$R DweettaClient.rc}
{$ENDIF}

begin
  Application.Initialize;
  Application.CreateForm ( TfrmMain, frmMain ) ;
  Application.Run;
end.

