program Dweetta;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, frmMainUnit, virtualtreeslcl;

begin
  Application.Initialize;
  Application.CreateForm ( TfrmMain, frmMain ) ;
  Application.Run;
end.

