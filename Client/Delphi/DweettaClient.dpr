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
  Common in 'Common.pas',
  frmSettingsUnit in 'frmSettingsUnit.pas' {frmSettings};

{$R *.res}

begin
  Application.Initialize;
  {$IFDEF DELPHI2006_UP}
  Application.MainFormOnTaskbar := True;
  {$ENDIF ~DELPHI2006_UP}
  Application.Title := 'Dweetta Client v0.1.0.35';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.Run;
end.
