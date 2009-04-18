{*------------------------------------------------------------------------------
  DweettaClient.dpr

  Dweetta Client project

  @Author  $Author$
  @LastChangedBy $LastChangedBy$
  @Version $Rev$
-------------------------------------------------------------------------------}
program DweettaClient;

{$I Dweetta.inc}

uses
  Forms,
  frmMainUnit in 'frmMainUnit.pas' {frmMain},
  Common in 'Common.pas';

{$R *.res}

begin
  Application.Initialize;
  {$IFDEF DELPHI2006_UP}
  Application.MainFormOnTaskbar := True;
  {$ENDIF ~DELPHI2006_UP}
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
