unit singlecodeform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  nkTitleBar, ubarcodes, rxctrls, BCLabel;

type

  { TfrmSingleCode }

  TfrmSingleCode = class(TForm)
    BCLabel1: TBCLabel;
    Label1: TLabel;
    nkTitleBar1: TnkTitleBar;
    QR: TBarcodeQR;
    RxSpeedButton1: TRxSpeedButton;
    procedure RxSpeedButton1Click(Sender: TObject);
  private

  public
    procedure SetCode(AText:string);
  end;

var
  frmSingleCode: TfrmSingleCode;

implementation

{$R *.frm}

{ TfrmSingleCode }

procedure TfrmSingleCode.RxSpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmSingleCode.SetCode(AText: string);
begin
  QR.Text:=AText;
  QR.Generate;
end;

end.

