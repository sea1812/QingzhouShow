unit selectdatedlg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, nkTitleBar, rxctrls, BCLabel, BCButton, DateUtils;

type

  { TdlgSelectDate }

  TdlgSelectDate = class(TForm)
    BCButton1: TBCButton;
    BCLabel1: TBCLabel;
    editDate: TDateEdit;
    Label1: TLabel;
    nkTitleBar1: TnkTitleBar;
    RxSpeedButton1: TRxSpeedButton;
    procedure BCButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RxSpeedButton1Click(Sender: TObject);
  private

  public

  end;

var
  dlgSelectDate: TdlgSelectDate;

implementation

{$R *.frm}

{ TdlgSelectDate }

procedure TdlgSelectDate.RxSpeedButton1Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TdlgSelectDate.FormShow(Sender: TObject);
begin
  editDate.Date:=Today();
end;

procedure TdlgSelectDate.BCButton1Click(Sender: TObject);
begin
  if Trim(editDate.Text)='' then
  begin

  end
  else
  begin
    ModalResult:=mrOK;
  end;
end;

end.

