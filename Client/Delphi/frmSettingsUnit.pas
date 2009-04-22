{*------------------------------------------------------------------------------
  frmSettingsUnit.pas

  Settings form for the Dweetta Client

  @Author  $Author$
  @LastChangedBy $LastChangedBy$
  @Version $Rev$
-------------------------------------------------------------------------------}
unit frmSettingsUnit;

{$I Dweetta.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmSettings = class(TForm)
    lblUsername: TLabel;
    lblPassword: TLabel;
    edtUsername: TEdit;
    edtPassword: TEdit;
    btnOk: TButton;
    btnCancel: TButton;

    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

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

end.
