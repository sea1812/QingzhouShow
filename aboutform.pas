unit aboutform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, nkTitleBar, rxctrls, BCLabel;

type

  { TfrmAbout }

  TfrmAbout = class(TForm)
    BCLabel1: TBCLabel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    nkTitleBar1: TnkTitleBar;
    RxSpeedButton1: TRxSpeedButton;
    RxSpeedButton2: TRxSpeedButton;
    procedure RxSpeedButton1Click(Sender: TObject);
  private

  public

  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.frm}

{ TfrmAbout }

procedure TfrmAbout.RxSpeedButton1Click(Sender: TObject);
begin
  Close;
end;

end.

