unit frmSettingsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls;

type

  { TfrmSettings }

  TfrmSettings = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    edtPassword: TEdit;
    edtUsername: TEdit;
    lblPassword: TLabel;
    lblUsername: TLabel;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmSettings: TfrmSettings;

implementation

uses
  frmMainUnit;

{ TfrmSettings }

procedure TfrmSettings.btnOkClick(Sender: TObject);
begin
  frmMain.Username := edtUsername.Text;
  frmMain.Password := edtPassword.Text;
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  edtUsername.Text := frmMain.Username;
  edtPassword.Text := frmMain.Password;
end;

initialization
  {$I frmSettingsUnit.lrs}

end.

