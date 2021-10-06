unit debugform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  nkTitleBar, rxctrls, BCLabel;

type

  { TfrmDebug }

  TfrmDebug = class(TForm)
    BCLabel1: TBCLabel;
    Memo1: TMemo;
    nkTitleBar1: TnkTitleBar;
    RxSpeedButton1: TRxSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure RxSpeedButton1Click(Sender: TObject);
  private

  public

  end;

var
  frmDebug: TfrmDebug;

implementation

{$R *.frm}

{ TfrmDebug }

procedure TfrmDebug.RxSpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmDebug.FormCreate(Sender: TObject);
begin
  Self.Color:=$002E2E2E;
end;

end.

