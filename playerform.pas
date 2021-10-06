unit playerform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, IniFiles,
  StdCtrls, nkTitleBar, ubarcodes, TplLCDLineUnit, uESelector, rxctrls, BCLabel,
  BCButton;

type

  { TfrmPlayer }

  TfrmPlayer = class(TForm)
    BCButton1: TBCButton;
    BCButton2: TBCButton;
    BCLabel1: TBCLabel;
    Image1: TImage;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    nkTitleBar1: TnkTitleBar;
    Panel1: TPanel;
    Panel3: TPanel;
    plLCDLine1: TplLCDLine;
    QR: TBarcodeQR;
    RxSpeedButton1: TRxSpeedButton;
    Timer1: TTimer;
    uESelector1: TuESelector;
    procedure BCButton1Click(Sender: TObject);
    procedure BCButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure RxSpeedButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public
    count:integer;
    procedure Debug(AText:string);
    procedure LoadSpeed;//加载默认速度参数
    procedure SaveSpeed;//保存当前速度参数
  end;

var
  frmPlayer: TfrmPlayer;

implementation

uses
  datamodule, debugform;

{$R *.frm}

{ TfrmPlayer }

procedure TfrmPlayer.Debug(AText: string);
begin
  if Assigned(frmDebug) then
  begin
    frmDebug.Memo1.Lines.Add(AText);
    if frmDebug.Showing then
      Application.ProcessMessages;
  end;
end;

procedure TfrmPlayer.LoadSpeed;
var
  mIni:TIniFile;
begin
  mIni:=TIniFile.Create(ExtractFilepath(Application.ExeName)+'config.ini');
  uESelector1.Index:=mIni.ReadInteger('player','speed',2);
  mIni.Free;
end;

procedure TfrmPlayer.SaveSpeed;
var
  mIni:TIniFile;
begin
  mIni:=TIniFile.Create(ExtractFilepath(Application.ExeName)+'config.ini');
  mIni.WriteInteger('player','speed',uESelector1.Index);
  mIni.Free;
end;

procedure TfrmPlayer.RxSpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmPlayer.Timer1Timer(Sender: TObject);
begin
  if count>Length(Dm.EncodeContent) then
  begin
    //显示最后一张END码
    QR.Text:='END';
    Qr.Generate;
    Qr.Update;
    Label1.Caption:=inttostr(Count+1)+' / '+inttostr(Length(Dm.EncodeContent)+2);
    Application.ProcessMessages;
    //恢复按钮状态
    Timer1.Enabled:=False;
    BCButton1.Enabled:=True;
    //Edit1.Enabled:=True;
    uESelector1.Enabled:=True;
    RxSpeedButton1.Enabled:=True;
    Dm.PopupNotify('提示','编码播放完毕');
  end;
  //生成
  if count<Length(Dm.EncodeContent) then
  begin
    QR.Text:=Dm.EncodeContent[count].EKind+':'+Dm.EncodeContent[count].EEncodeText;
    Qr.Generate;
    Qr.Update;
    plLCDLine1.Text:=FormatFloat('#0000000',Count);
    Label1.Caption:=inttostr(Count+1)+' / '+inttostr(Length(Dm.EncodeContent)+2);
    Application.ProcessMessages;
  end;
  count:=count+1;
end;

procedure TfrmPlayer.FormShow(Sender: TObject);
begin
  Label1.Caption:='0 / '+inttostr(Length(Dm.EncodeContent)+2);
  //加载默认速度
  LoadSpeed;
end;

procedure TfrmPlayer.BCButton1Click(Sender: TObject);
begin
  RxSpeedButton1.Enabled:=False;
  BCButton1.Enabled:=False;
  uESelector1.Enabled:=False;
  Timer1.Enabled:=False;
  Timer1.Interval:=(uESelector1.Index+1)*1000;
  count:=0;
  plLCDLine1.Text:=FormatFloat('#0000000',Count+1);
  Application.ProcessMessages;
  Timer1.Enabled:=True;
end;

procedure TfrmPlayer.BCButton2Click(Sender: TObject);
begin
  Timer1.Enabled:=False;
  BCButton1.Enabled:=True;
  uESelector1.Enabled:=True;
  RxSpeedButton1.Enabled:=True;
end;

procedure TfrmPlayer.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SaveSpeed;
end;

end.

