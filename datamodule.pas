unit datamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, oracleconnection, sqldb, FileUtil, ZConnection, ZDataset,
  Controls, Graphics;

type

  { TDm }

  //编码记录类型
  TMyEncode = record
    EDate:TDate;
    EKind:string[2];//数据类型，xs / sp / fk
    EDanhao: integer;//销售单号
    EPlainText:string[255];//原始内容
    EEncodeText:string[255];//编码内容
  end;

  TDm = class(TDataModule)
    erpconn: TOracleConnection;
    ImageList1: TImageList;
    InnerQry: TSQLQuery;
    localConn: TZConnection;
    localXsxx: TZQuery;
    pubQry: TSQLQuery;
    qryXsxx: TSQLQuery;
    qryFkxx: TSQLQuery;
    qrySpxx: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    localQry: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    FBitmap:TBitmap;
  public
    EncodeContent: array of TMyEncode;

    procedure PopupNotify(ATitle, AMsg:string);
    function DBReady:boolean;
    procedure ClearXsxxHZ;
    procedure ClearXsxx;
    procedure SaveXsxx(AXiaoshoudanhao:string;AXiaoshoutuihuo:integer;AJiesuanRiqi:TDate;
      AJiuzhenkahao,AJiesuanBingzhong,AYishengmingcheng,AHuanzhexingming,AShenfenzhenghao,AJiesuanhao:string);
    procedure SaveXsxxHz(AXiaoshoudanhao:string;AXiaoshoutuihuo:integer;AZonge,ABingren,AYibao:double);
  end;

var
  Dm: TDm;

implementation

uses
  TplNotifierOSUnit;

{$R *.frm}

{ TDm }

procedure TDm.DataModuleCreate(Sender: TObject);
begin
  FBitmap:=TBitmap.Create;
  ImageList1.GetBitmap(0,FBitmap);
end;

procedure TDm.PopupNotify(ATitle, AMsg: string);
begin
  TplNotifierOS.Execute(Atitle,AMsg,FBitmap);
end;

function TDm.DBReady: boolean;
begin
  Result:=erpconn.Connected and LocalConn.Connected ;
end;

procedure TDm.ClearXsxxHZ;
begin
  with localQry do
  begin
    Close;
    Sql.Clear;
    Sql.Add('delete from xsxx_hz');
    ExecSQL;
  end;
end;

procedure TDm.ClearXsxx;
begin
  with localQry do
  begin
    Close;
    Sql.Clear;
    Sql.Add('delete from xsxx');
    ExecSQL;
  end;
end;

procedure TDm.SaveXsxx(AXiaoshoudanhao: string; AXiaoshoutuihuo: integer;
  AJiesuanRiqi: TDate; AJiuzhenkahao, AJiesuanBingzhong, AYishengmingcheng,
  AHuanzhexingming, AShenfenzhenghao, AJiesuanhao: string);
begin
  with localQry do
  begin
    Close;
    Sql.Clear;
    Sql.Add('insert into xsxx (销售单号,结算日期,就诊卡号,结算病种,医生名称,患者姓名,身份证号,结算号ID,销售退货) ');
    Sql.Add('values (:a,:b,:c,:d,:e,:f,:g,:h,:i)');
    Params.ParamByName('a').AsString:=AXiaoshoudanhao;
    Params.ParamByName('b').AsDate:=AJiesuanriqi;
    Params.ParamByName('c').AsString:=AJiuzhenkahao;
    Params.ParamByName('d').AsString:=AJiesuanbingzhong;
    Params.ParamByName('e').AsString:=AYishengMingcheng;
    Params.ParamByName('f').AsString:=AHuanzheXingming;
    Params.ParamByName('g').AsString:=AShenfenzhenghao;
    Params.ParamByName('h').AsString:=AJiesuanhao;
    Params.ParamByName('i').AsInteger:=AXiaoshoutuihuo;
    ExecSQL;
  end;
end;

procedure TDm.SaveXsxxHz(AXiaoshoudanhao: string; AXiaoshoutuihuo: integer; AZonge,
  ABingren, AYibao: double);
begin
  with localQry do
  begin
    Close;
    Sql.Clear;
    Sql.Add('insert into xsxx_hz (销售单号,销售退货,本次结算费用总额,病人负担金额,医保负担金额) values (:a,:b,:c,:d,:e)');
    Params.ParamByName('a').AsString:=AXiaoshouDanhao;
    Params.ParamByName('b').AsInteger:=AXiaoshoutuihuo;
    Params.ParamByName('c').AsFloat:=AZonge;
    Params.ParamByName('d').AsFloat:=ABingren;
    Params.ParamByName('e').AsFloat:=AYibao;
    ExecSQL;
  end;
end;

end.

