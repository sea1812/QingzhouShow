unit sqlform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, nkTitleBar, nkResizer, db, rxctrls, rxdbgrid, BCLabel, BCButton;

type

  { TfrmSQL }

  TfrmSQL = class(TForm)
    BCButton1: TBCButton;
    BCLabel1: TBCLabel;
    ds_grid: TDataSource;
    grid_xsxx: TRxDBGrid;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Memo1: TMemo;
    nkResizer1: TnkResizer;
    nkTitleBar1: TnkTitleBar;
    Panel2: TPanel;
    RxSpeedButton1: TRxSpeedButton;
    RxSpeedButton2: TRxSpeedButton;
    Splitter1: TSplitter;
    procedure BCButton1Click(Sender: TObject);
    procedure RxSpeedButton1Click(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
  private

  public

  end;

var
  frmSQL: TfrmSQL;

implementation

uses
  datamodule;
{$R *.frm}

{ TfrmSQL }

procedure TfrmSQL.RxSpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmSQL.BCButton1Click(Sender: TObject);
begin
  if Dm.DBReady=False then
  begin
    MessageDlg('请先连接杭创HIS。',mtWarning,[mbOK],0);
    Exit;
  end;
  if Trim(Memo1.Text)<>'' then
  begin
    with dm.pubQry do
    begin
      Close;
      Sql.Clear;
      Sql.Add(Trim(Memo1.Text));
      Open;
      ds_grid.DataSet:=dm.pubQry;
    end;
  end;
end;

procedure TfrmSQL.RxSpeedButton2Click(Sender: TObject);
begin
  //放大窗口
  Self.Top := Self.Monitor.WorkareaRect.Top;
  Self.Left := Self.Monitor.WorkareaRect.Left;
  Self.Width := Self.Monitor.WorkareaRect.Width;
  Self.Height := Self.Monitor.WorkareaRect.Height;
end;

end.

