program DweettaClient;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, frmMainUnit, virtualtreeslcl,
  DweettaTransport, Dweetta, DweettaAPI, DweettaCommon, DweettaContainers;

{$IFDEF WINDOWS}{$R DweettaClient.rc}{$ENDIF}

begin
  Application.Initialize;
  Application.CreateForm ( TfrmMain, frmMain ) ;
  Application.Run;
end.

