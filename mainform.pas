unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, nkTitleBar, nkResizer, TplLabelUnit, DB, DateUtils,
  SpkToolbar, spkt_Tab, spkt_Pane, spkt_Buttons, rxctrls, rxdbgrid, BCLabel,
  IniFiles;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    BCLabel1: TBCLabel;
    btnConnectHydee: TSpkLargeButton;
    btnSQL: TSpkLargeButton;
    ds_xsxx: TDataSource;
    ds_fkxx: TDataSource;
    ds_spxx: TDataSource;
    grid_xsxx: TRxDBGrid;
    grid_fkxx: TRxDBGrid;
    grid_spxx: TRxDBGrid;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    nkResizer1: TnkResizer;
    nkTitleBar1: TnkTitleBar;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    RxSpeedButton1: TRxSpeedButton;
    RxSpeedButton2: TRxSpeedButton;
    RxSpeedButton3: TRxSpeedButton;
    Shape1: TShape;
    SpkLargeButton1: TSpkLargeButton;
    SpkLargeButton2: TSpkLargeButton;
    SpkLargeButton3: TSpkLargeButton;
    SpkLargeButton4: TSpkLargeButton;
    SpkLargeButton5: TSpkLargeButton;
    SpkLargeButton6: TSpkLargeButton;
    SpkPane1: TSpkPane;
    SpkPane2: TSpkPane;
    SpkPane3: TSpkPane;
    SpkPane4: TSpkPane;
    SpkTab1: TSpkTab;
    SpkToolbar1: TSpkToolbar;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    procedure btnConnectHydeeClick(Sender: TObject);
    procedure btnSQLClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grid_fkxxDblClick(Sender: TObject);
    procedure grid_spxxDblClick(Sender: TObject);
    procedure grid_xsxxDblClick(Sender: TObject);
    procedure RxSpeedButton1Click(Sender: TObject);
    procedure RxSpeedButton2Click(Sender: TObject);
    procedure RxSpeedButton3Click(Sender: TObject);
    procedure SpkLargeButton2Click(Sender: TObject);
    procedure SpkLargeButton3Click(Sender: TObject);
    procedure SpkLargeButton4Click(Sender: TObject);
    procedure SpkLargeButton5Click(Sender: TObject);
    procedure SpkLargeButton6Click(Sender: TObject);
  private
    FQryDate: TDate;
  public
    procedure ResizePanel;
    procedure Debug(AText: string);//输出调试信息
    procedure InitLocalDb;//初始化本地数据库
    procedure ConnectHangchuang;//连接杭创数据库
    procedure DoEncode;//对查询回来的记录进行编码
    procedure ShowSummary(ADate:TDate);//在页头上显示汇总信息
    procedure FieldToString(AField: TField; var APlainText: string; var AEncodeText: string);//字段名和字段值转换为字符串
  end;

var
  frmMain: TfrmMain;

implementation

uses
  datamodule, selectdatedlg, debugform, progresform, playerform,
  sqlform, aboutform, singlecodeform;

{$R *.frm}

{ TfrmMain }

procedure TfrmMain.RxSpeedButton1Click(Sender: TObject);
begin
  Hide;
  Application.Terminate;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  InitLocalDB;
  RxSpeedButton2Click(nil);
  ResizePanel;
  Dm.PopupNotify('请先连接杭创HIS', '然后查询数据。然后播放编码。');
end;

procedure TfrmMain.grid_fkxxDblClick(Sender: TObject);
var
  j: integer;
  mP, mE: string;
  mPlainText, mEncodeText: string;
begin
  //编码指定的fkxx记录，并显示二维码
  mPlainText := '';
  mEncodeText := '';
  for j := 0 to dm.qryFkxx.Fields.Count - 1 do
  begin
    mP := '';
    mE := '';
    FieldToString(dm.qryFkxx.Fields.Fields[j], mP, mE);
    mPlainText := mPlainText + mP;
    mEncodeText := mEncodeText + mE;
  end;
  if Trim(mEncodeText) <> '' then
  begin
    //弹出显示单张二维码窗口
    frmSingleCode.SetCode('fk:' + mEncodeText);
    frmSingleCode.ShowModal;
  end;
end;

procedure TfrmMain.grid_spxxDblClick(Sender: TObject);
var
  j: integer;
  mP, mE: string;
  mPlainText, mEncodeText: string;
begin
  //编码指定的spxx记录，并显示二维码
  mPlainText := '';
  mEncodeText := '';
  for j := 0 to dm.qrySpxx.Fields.Count - 1 do
  begin
    mP := '';
    mE := '';
    FieldToString(dm.qrySpxx.Fields.Fields[j], mP, mE);
    mPlainText := mPlainText + mP;
    mEncodeText := mEncodeText + mE;
  end;
  if Trim(mEncodeText) <> '' then
  begin
    //弹出显示单张二维码窗口
    frmSingleCode.SetCode('sp:' + mEncodeText);
    frmSingleCode.ShowModal;
  end;
end;

procedure TfrmMain.grid_xsxxDblClick(Sender: TObject);
var
  j: integer;
  mP, mE: string;
  mPlainText, mEncodeText: string;
begin
  //编码指定的xsxx记录，并显示二维码
  mPlainText := '';
  mEncodeText := '';
  for j := 0 to dm.qryXsxx.Fields.Count - 1 do
  begin
    mP := '';
    mE := '';
    FieldToString(dm.qryXsxx.Fields.Fields[j], mP, mE);
    mPlainText := mPlainText + mP;
    mEncodeText := mEncodeText + mE;
  end;
  if Trim(mEncodeText) <> '' then
  begin
    //弹出显示单张二维码窗口
    if dm.qryXsxx.FieldByName('销售退货').AsInteger=1 then
      frmSingleCode.SetCode('xs:' + mEncodeText)
    else
      frmSingleCode.SetCode('xt:' + mEncodeText);

    frmSingleCode.ShowModal;
  end;
end;

procedure TfrmMain.btnConnectHydeeClick(Sender: TObject);
begin
  //连接杭创数据库
  ConnectHangchuang;
end;

procedure TfrmMain.btnSQLClick(Sender: TObject);
begin
  //SQL查询窗口
  frmSql.Show;
end;

procedure TfrmMain.RxSpeedButton2Click(Sender: TObject);
begin
  //放大窗口
  Self.Top := Self.Monitor.WorkareaRect.Top;
  Self.Left := Self.Monitor.WorkareaRect.Left;
  Self.Width := Self.Monitor.WorkareaRect.Width;
  Self.Height := Self.Monitor.WorkareaRect.Height;
end;

procedure TfrmMain.RxSpeedButton3Click(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TfrmMain.SpkLargeButton2Click(Sender: TObject);
begin
  //显示调试信息窗口
  frmDebug.Show;
  frmDebug.BringToFront;
end;

{procedure TfrmMain.SpkLargeButton3Click(Sender: TObject);
var
  mDate: TDate;
  mDateStr: string;
  mSQL: string;
begin
  //查询数据
  if Dm.DBReady then
  begin
    dlgSelectDate := TdlgSelectDate.Create(Application);
    if dlgSelectDate.ShowModal = mrOk then
    begin
      //Dm.PopupNotify('提示','正在查询数据，请稍候');
      frmProgres.Info('正在查询数据，请稍候……');
      Application.ProcessMessages;
      mDate := dlgSelectDate.editDate.Date;
      mDateStr := IntToStr(YearOf(mDate)) + '/' + IntToStr(MonthOf(mDate)) + '/' + IntToStr(DayOf(mDate));
      FQryDate := mDate;
      //查询xsxx中支付金额合计
      Dm.ClearXsxxHZ;
      with dm.InnerQry do
      begin
        Close;
        Sql.Clear;
        mSQL := 'select 销售单号,销售退货, sum(本次结算费用总额) as 本次结算费用总额, sum(病人负担金额) as 病人负担金额, sum(医保负担金额) as 医保负担金额 from v_hw_xsxx where  to_date(结算日期)=to_date('
          + '''' + mDateStr + '''' + ',' + '''' + 'yyyy/MM/dd' + '''' + ') group by 销售单号,销售退货';
        Sql.Add(mSQL);
        Open;
        First;
        while not Eof do
        begin
          //Save To Local xsxx_hz
          Dm.SaveXsxxHz(FieldByName('销售单号').AsString,FieldByName('销售退货').AsInteger,FieldByName('本次结算费用总额').AsFloat,FieldByName('病人负担金额').AsFloat,FieldByName('医保负担金额').AsFloat);
          Next;
        end;
      end;
      //查询数据
      Dm.ClearXsxx;
      with Dm.qryXsxx do
      begin
        Close;
        Sql.Clear;
        mSQL := 'select distinct 销售单号,结算日期,就诊卡号,结算病种,医生名称,患者姓名,身份证号,销售退货 from v_hw_xsxx where to_date(结算日期)=to_date(' + '''' + mDateStr + '''' + ',' + '''' + 'yyyy/MM/dd' + '''' + ')  order by 销售单号';
        SQl.Add(mSQL);
        //        Sql.Add('select * from v_hw_xsxx where 结算日期=to_date(:jsdate,'+''''+'yyyy/MM/dd'+''''+') order by 销售单号');
        //        Params.ParamByName('jsdate').AsString:=FormatDatetime('yyyy/mm/dd',mDate);
        //        Sql.Add('select * from v_hw_xsxx where 结算日期=:jsdate order by 销售单号');
        //        Params.ParamByName('jsdate').AsDate:=mDate;
        Open;
        First;
        while not eof do
        begin
          Dm.SaveXsxx(FieldByName('销售单号').AsString,
            FieldByName('销售退货').AsInteger,
            FieldByName('结算日期').AsDateTime,
            FieldByName('就诊卡号').AsString,
            FieldByName('结算病种').AsString,
            FieldByName('医生名称').AsString,
            FieldByName('患者姓名').AsString,
            FieldByName('身份证号').AsString,'');
            //FieldByName('结算号ID').AsString);
          Next;
        end;
//        ds_xsxx.DataSet := Dm.qryXsxx;
      end;
      //聚合local xsxx xsxx_hz
      with dm.localXsxx do
      begin
        Close;
        Sql.Clear;
        Sql.Add('');
      end;
      ds_xsxx.DataSet := Dm.localXsxx;
      with dm.qryFkxx do
      begin
        Close;
        Sql.Clear;
        mSQL := 'select * from v_hw_xsxx_fkxx where 销售单号 in (select 销售单号 from v_hw_xsxx where to_date(结算日期)=to_date(' +
          '''' + mDateStr + '''' + ',' + '''' + 'yyyy/MM/dd' + '''' + ')) order by 销售单号';
        //showMessage(mSQL);
        Sql.Add(mSql);
        //        Sql.Add('select * from v_hw_xsxx_fkxx where 销售单号 in (select 销售单号 from v_hw_xsxx where 结算日期=:jsdate) order by 销售单号');
        //        Params.ParamByName('jsdate').AsDate:=mDate;
        Open;
        ds_fkxx.DataSet := dm.qryFkxx;
      end;
      with dm.qrySpxx do
      begin
        Close;
        Sql.Clear;
        mSQL := 'select * from v_hw_xsxx_spxx where 销售单号 in (select 销售单号 from v_hw_xsxx where to_date(结算日期)=to_date(' +
          '''' + mDateStr + '''' + ',' + '''' + 'yyyy/MM/dd' + '''' + ')) order by 销售单号';
        //showMessage(mSQL);
        Sql.Add(mSql);
        //        Sql.Add('select * from v_hw_xsxx_spxx where 销售单号 in (select 销售单号 from v_hw_xsxx where 结算日期=:jsdate) order by 销售单号');
        //        Params.ParamByName('jsdate').AsDate:=mDate;
        Open;
        ds_spxx.DataSet := dm.qrySpxx;
      end;
      dm.qryXsxx.Last;
      dm.qryFkxx.Last;
      dm.qrySpxx.Last;

      if dm.qryXsxx.RecordCount = 0 then
      begin
        Panel6.Caption := '没有查询到数据';
      end
      else
      begin
        Panel6.Caption := FormatDatetime('yyyy-mm-dd', mDate) + '共查询到：销售信息' + IntToStr(dm.qryXsxx.RecordCount) +
          '条记录，付款信息' + IntToStr(dm.qryFkxx.RecordCount) + '条记录，商品信息' + IntToStr(Dm.qrySpxx.RecordCount) + '条记录';
      end;
      Panel6.Visible := True;
      frmProgres.Close;
    end;
  end
  else
  begin
    MessageDlg('请先连接杭创HIS。', mtWarning, [mbOK], 0);
  end;
end;
}
procedure TfrmMain.SpkLargeButton3Click(Sender: TObject);
var
  mDate: TDate;
  mDateStr: string;
  mSQL: string;
begin
  //查询数据
  if Dm.DBReady then
  begin
    dlgSelectDate := TdlgSelectDate.Create(Application);
    if dlgSelectDate.ShowModal = mrOk then
    begin
      //Dm.PopupNotify('提示','正在查询数据，请稍候');
      frmProgres.Info('正在查询数据，请稍候……');
      Application.ProcessMessages;
      mDate := dlgSelectDate.editDate.Date;
      mDateStr := IntToStr(YearOf(mDate)) + '/' + IntToStr(MonthOf(mDate)) + '/' + IntToStr(DayOf(mDate));
      FQryDate := mDate;
      //查询xsxx中支付金额合计
      {with dm.InnerQry do
      begin
        Close;
        Sql.Clear;
        mSQL := 'select sum(本次结算费用总额) as aa, sum(病人负担金额) as bb, sum(医保负担金额) as cc from v_hw_xsxx where  to_date(结算日期)=to_date('
          + '''' + mDateStr + '''' + ',' + '''' + 'yyyy/MM/dd' + '''' + ')';
        //        mSQL:='select sum(支付金额) as aa from v_hw_xsxx_fkxx where 销售单号 in (select 销售单号 from v_hw_xsxx where to_date(结算日期)=to_date('+''''+mDateStr+''''+','+''''+'yyyy/MM/dd'+''''+'))';
        Sql.Add(mSQL);
        Open;
        First;
        Label9.Caption := FormatFloat('#0.00', FieldByName('aa').AsFloat) + ' 病人负担金额：' +
          FormatFloat('#0.00', FieldByName('bb').AsFloat) + ' 医保负担金额：' + FormatFloat('#0.00', FieldByName('cc').AsFloat);
      end;}

      //查询数据
      with Dm.qryXsxx do
      begin
        Close;
        Sql.Clear;
        //mSQL := 'select * from v_hw_xsxx where to_date(结算日期)=to_date(' + '''' + mDateStr + '''' + ',' + '''' + 'yyyy/MM/dd' + '''' + ') group by 销售单号,销售退货 order by 销售单号';
        //mSQL:='select 销售单号,结算日期,就诊卡号,结算病种,医生名称,患者姓名,身份证号,销售退货,sum(本次结算费用总额) as 本次结算费用总额, sum(病人负担金额) as 病人负担金额, sum(医保负担金额) as 医保负担金额 from v_hw_xsxx where to_date(结算日期)=to_date(' + '''' + mDateStr + '''' + ',' + '''' + 'yyyy/MM/dd' + '''' + ')  group by 销售单号,结算日期,就诊卡号,结算病种,医生名称,患者姓名,身份证号,销售退货 order by 销售单号';
        //mSQL:='select 销售单号,结算日期,就诊卡号,医生名称,患者姓名,身份证号,销售退货,sum(本次结算费用总额) as 本次结算费用总额, sum(病人负担金额) as 病人负担金额, sum(医保负担金额) as 医保负担金额 from v_hw_xsxx where to_date(结算日期)=to_date(' + '''' + mDateStr + '''' + ',' + '''' + 'yyyy/MM/dd' + '''' + ')  group by 销售单号,结算日期,就诊卡号,医生名称,患者姓名,身份证号,销售退货 order by 销售单号';
        mSQL:='select '+''''+mDatestr+''''+' as 结算日期,销售单号,就诊卡号,医生名称,患者姓名,身份证号,销售退货,sum(本次结算费用总额) as 本次结算费用总额, sum(病人负担金额) as 病人负担金额, sum(医保负担金额) as 医保负担金额 from v_hw_xsxx where to_date(结算日期)=to_date(' + '''' + mDateStr + '''' + ',' + '''' + 'yyyy/MM/dd' + '''' + ')  group by 销售单号,就诊卡号,医生名称,患者姓名,身份证号,销售退货 order by 销售单号';
        SQl.Add(mSQL);
        //        Sql.Add('select * from v_hw_xsxx where 结算日期=to_date(:jsdate,'+''''+'yyyy/MM/dd'+''''+') order by 销售单号');
        //        Params.ParamByName('jsdate').AsString:=FormatDatetime('yyyy/mm/dd',mDate);
        //        Sql.Add('select * from v_hw_xsxx where 结算日期=:jsdate order by 销售单号');
        //        Params.ParamByName('jsdate').AsDate:=mDate;
        Open;
        ds_xsxx.DataSet := Dm.qryXsxx;
      end;
      with dm.qryFkxx do
      begin
        Close;
        Sql.Clear;
        mSQL := 'select * from v_hw_xsxx_fkxx where 销售单号 in (select 销售单号 from v_hw_xsxx where to_date(结算日期)=to_date(' +
          '''' + mDateStr + '''' + ',' + '''' + 'yyyy/MM/dd' + '''' + ')) order by 销售单号';
        //showMessage(mSQL);
        Sql.Add(mSql);
        //        Sql.Add('select * from v_hw_xsxx_fkxx where 销售单号 in (select 销售单号 from v_hw_xsxx where 结算日期=:jsdate) order by 销售单号');
        //        Params.ParamByName('jsdate').AsDate:=mDate;
        Open;
        ds_fkxx.DataSet := dm.qryFkxx;
      end;
      with dm.qrySpxx do
      begin
        Close;
        Sql.Clear;
        mSQL := 'select * from v_hw_xsxx_spxx where 销售单号 in (select 销售单号 from v_hw_xsxx where to_date(结算日期)=to_date(' +
          '''' + mDateStr + '''' + ',' + '''' + 'yyyy/MM/dd' + '''' + ')) order by 销售单号';
        //showMessage(mSQL);
        Sql.Add(mSql);
        //        Sql.Add('select * from v_hw_xsxx_spxx where 销售单号 in (select 销售单号 from v_hw_xsxx where 结算日期=:jsdate) order by 销售单号');
        //        Params.ParamByName('jsdate').AsDate:=mDate;
        Open;
        ds_spxx.DataSet := dm.qrySpxx;
      end;
      //显示统计汇总信息
      ShowSummary(mDate);
      //  Label9.Caption := FormatFloat('#0.00', FieldByName('aa').AsFloat) + ' 病人负担金额：' +
      //    FormatFloat('#0.00', FieldByName('bb').AsFloat) + ' 医保负担金额：' + FormatFloat('#0.00', FieldByName('cc').AsFloat);

      dm.qryXsxx.Last;
      dm.qryFkxx.Last;
      dm.qrySpxx.Last;

      if dm.qryXsxx.RecordCount = 0 then
      begin
        Panel6.Caption := '没有查询到数据';
      end
      else
      begin
        //Panel6.Caption := FormatDatetime('yyyy-mm-dd', mDate) + '共查询到：销售信息' + IntToStr(dm.qryXsxx.RecordCount) +
        //  '条记录，付款信息' + IntToStr(dm.qryFkxx.RecordCount) + '条记录，商品信息' + IntToStr(Dm.qrySpxx.RecordCount) + '条记录';
      end;
      Panel6.Visible := True;
      frmProgres.Close;
    end;
  end
  else
  begin
    MessageDlg('请先连接杭创HIS。', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMain.SpkLargeButton4Click(Sender: TObject);
begin
  if Dm.DBReady then
  begin
    //播放编码，先生成全部编码条文
    frmProgres.Info('正在对数据编码……');
    DoEncode;
    frmProgres.Close;
    //显示播放窗口
    frmPlayer := TfrmPlayer.Create(Application);
    frmPlayer.ShowModal;
    frmPlayer.Free;
    frmPlayer := nil;
  end
  else
  begin
    MessageDlg('请先连接杭创HIS。', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmMain.SpkLargeButton5Click(Sender: TObject);
begin
  //软件说明窗口
  frmAbout.ShowModal;
end;

procedure TfrmMain.SpkLargeButton6Click(Sender: TObject);
var
  mLength: integer;
  i, j: integer;
  mPlainText, mEncodeText: string;
  mP, mE: string;
  mDanhao:TStrings;
begin
  if MessageDlg('将从选中的记录开始播放其后的数据编码，确定继续吗？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    mDanhao:=TStringList.Create;
    SetLength(Dm.EncodeContent, 0);
    grid_xsxx.SelectedRows.Clear;
    //选中当前所在记录
    grid_xsxx.SelectedRows.CurrentRowSelected := True;
    //先设定XSXX的编码数组内容长度
    mLength := dm.qryXsxx.RecordCount - dm.qryXsxx.RecNo + 1;
    SetLength(Dm.EncodeContent, mLength);
    //ShowMessage(IntToStr(mLength));
    //回到选中记录处开始循环
    i := 0;
    dm.qryXsxx.GotoBookmark(grid_xsxx.SelectedRows.Items[0]);
    with dm.qryXsxx do
    begin
      while not EOF do
      begin
        Debug('xs'+inttostr(i)+' '+FieldByName('销售单号').AsString);
        mDanhao.Add(FieldByName('销售单号').AsString);
        mPlainText := '';
        mEncodeText := '';
        for j := 0 to Fields.Count - 1 do
        begin
          mP := '';
          mE := '';
          FieldToString(Fields.Fields[j], mP, mE);
          mPlainText := mPlainText + mP;
          mEncodeText := mEncodeText + mE;
        end;
        if FieldByName('销售退货').AsString='1' then
          Dm.EncodeContent[i].EKind := 'xs'
        else
          Dm.EncodeContent[i].EKind := 'xt';
        Dm.EncodeContent[i].EDate := FQryDate;
        Dm.EncodeContent[i].EDanhao := FieldByName('销售单号').AsInteger;
        Dm.EncodeContent[i].EPlainText := mPlainText;
        Dm.EncodeContent[i].EEncodeText := mEncodeText;
        i := i + 1;
        Next;
      end;
    end;
    //循环FKXX
    with dm.qryFkxx do
    begin
      First;
      while not Eof do
      begin
        if mDanhao.IndexOf(FieldByName('销售单号').AsString)<>-1 then
        begin
          Debug('fk'+inttostr(i)+' '+FieldByName('销售单号').AsString);
          SetLength(Dm.EncodeContent, Length(Dm.EncodeContent)+1);
          mPlainText := '';
          mEncodeText := '';
          for j := 0 to Fields.Count - 1 do
          begin
            mP := '';
            mE := '';
            FieldToString(Fields.Fields[j], mP, mE);
            mPlainText := mPlainText + mP;
            mEncodeText := mEncodeText + mE;
          end;
          Dm.EncodeContent[i].EKind := 'fk';
          Dm.EncodeContent[i].EDate := FQryDate;
          Dm.EncodeContent[i].EDanhao := FieldByName('销售单号').AsInteger;
          Dm.EncodeContent[i].EPlainText := mPlainText;
          Dm.EncodeContent[i].EEncodeText := mEncodeText;
          i:=i+1;
        end;
        Next;
      end;
    end;
    //循环SPXX
    with dm.qrySpxx do
    begin
      First;
      while not Eof do
      begin
        if mDanhao.IndexOf(FieldByName('销售单号').AsString)<>-1 then
        begin
          Debug('sp'+inttostr(i)+' '+FieldByName('销售单号').AsString);
          SetLength(Dm.EncodeContent, Length(Dm.EncodeContent)+1);
          mPlainText := '';
          mEncodeText := '';
          for j := 0 to Fields.Count - 1 do
          begin
            mP := '';
            mE := '';
            FieldToString(Fields.Fields[j], mP, mE);
            mPlainText := mPlainText + mP;
            mEncodeText := mEncodeText + mE;
          end;
          Dm.EncodeContent[i].EKind := 'sp';
          Dm.EncodeContent[i].EDate := FQryDate;
          Dm.EncodeContent[i].EDanhao := FieldByName('销售单号').AsInteger;
          Dm.EncodeContent[i].EPlainText := mPlainText;
          Dm.EncodeContent[i].EEncodeText := mEncodeText;
          i:=i+1;
        end;
        Next;
      end;
    end;
    //清理
    grid_xsxx.SelectedRows.Clear;
    mDanhao.Free;
    //显示播放窗口
    frmPlayer := TfrmPlayer.Create(Application);
    frmPlayer.ShowModal;
    frmPlayer.Free;
    frmPlayer := nil;

  end;
end;

procedure TfrmMain.ResizePanel;
begin
  //重新排布Panel
  Panel3.Width := Self.Width div 3;
  Panel4.Height := Panel3.Height div 2;
end;

procedure TfrmMain.Debug(AText: string);
begin
  if Assigned(frmDebug) then
  begin
    frmDebug.Memo1.Lines.Add(AText);
    if frmDebug.Showing then
      Application.ProcessMessages;
  end;
end;

procedure TfrmMain.InitLocalDb;
begin
  Dm.localConn.LibraryLocation := 'sqlite3.dll';
  Dm.localconn.Database := 'local.db';
  try
    Dm.localconn.Connect;
    Dm.PopupNotify('环境准备', '本地数据库已连接');
  except
    MessageDlg('连接本地数据库失败。', mtError, [mbOK], 0);
    Application.Terminate;
  end;
end;

procedure TfrmMain.ConnectHangchuang;
var
  mIni: TIniFile;
  mPort: integer;
begin
  //连接杭创数据库
  if Dm.erpconn.Connected then
    Exit;
  mIni := TIniFile.Create(ExtractFilepath(Application.ExeName) + 'config.ini');
  mPort := mIni.ReadInteger('common', 'port', 1521);
  Dm.erpconn.HostName := mIni.ReadString('common', 'host', '124.132.151.51');
  Dm.erpconn.Params.Add('port=' + IntToStr(mPort));
  Dm.erpconn.DatabaseName := mIni.ReadString('common', 'database', 'hydee');
  Dm.erpconn.UserName := mIni.ReadString('common', 'user', 'h2');
  Dm.erpconn.Password := mIni.ReadString('common', 'pwd', 'hydeesoft');
  mIni.Free;
  try
    Dm.erpconn.Open;
    Label2.Caption := '杭创HIS已连接';
    Label2.Font.Color := clLime;
    //btnConnectHydee.Checked := True;
    MessageDlg('已连接杭创HIS，请查询数据后播放编码。', mtInformation, [mbOK], 0);
  except
    Label2.Caption := '连接杭创HIS失败';
    Label2.Font.Color := clRed;
    MessageDlg('连接杭创HIS失败。', mtError, [mbOK], 0);
  end;
end;

procedure TfrmMain.DoEncode;
var
  mCount: integer;
  i, j: integer;
  mPlainText, mEncodeText: string;
  mP, mE: string;
begin
  //ShowMessage(IntToStr(grid_xsxx.SelectedRows.Count));
  //对查询回来的记录进行编码，填充到 Dm.EncodeContent数组
  //设置数组长度
  dm.qryXsxx.Last;
  dm.qryFkxx.Last;
  dm.qrySpxx.Last;
  mCount := dm.qryXsxx.RecordCount + Dm.qryFkxx.RecordCount + Dm.qrySpxx.RecordCount;
  SetLength(Dm.EncodeContent, mCount);
  Debug('设置编码缓冲区长度=' + IntToStr(mCount));
  i := 0;
  //编码xsxx
  with Dm.qryXsxx do
  begin
    First;
    while not EOF do
    begin
      mPlainText := '';
      mEncodeText := '';
      for j := 0 to Fields.Count - 1 do
      begin
        mP := '';
        mE := '';
        FieldToString(Fields.Fields[j], mP, mE);
        mPlainText := mPlainText + mP;
        mEncodeText := mEncodeText + mE;
      end;
      if FieldByName('销售退货').AsString='1' then
        Dm.EncodeContent[i].EKind := 'xs'
      else
        Dm.EncodeContent[i].EKind := 'xt';
      Dm.EncodeContent[i].EDate := FQryDate;
      Dm.EncodeContent[i].EDanhao := FieldByName('销售单号').AsInteger;
      Dm.EncodeContent[i].EPlainText := mPlainText;
      Dm.EncodeContent[i].EEncodeText := mEncodeText;
      Debug('XS/XT:' + IntToStr(i));
      Next;
      i := i + 1;
    end;
  end;
  //编码fkxx
  with Dm.qryFkxx do
  begin
    First;
    while not EOF do
    begin
      mPlainText := '';
      mEncodeText := '';
      for j := 0 to Fields.Count - 1 do
      begin
        mP := '';
        mE := '';
        FieldToString(Fields.Fields[j], mP, mE);
        mPlainText := mPlainText + mP;
        mEncodeText := mEncodeText + mE;
      end;
      Dm.EncodeContent[i].EKind := 'fk';
      Dm.EncodeContent[i].EDate := FQryDate;
      Dm.EncodeContent[i].EDanhao := FieldByName('销售单号').AsInteger;
      Dm.EncodeContent[i].EPlainText := mPlainText;
      Dm.EncodeContent[i].EEncodeText := mEncodeText;
      Next;
      i := i + 1;
    end;
  end;
  //编码spxx
  with Dm.qrySpxx do
  begin
    First;
    while not EOF do
    begin
      mPlainText := '';
      mEncodeText := '';
      for j := 0 to Fields.Count - 1 do
      begin
        mP := '';
        mE := '';
        FieldToString(Fields.Fields[j], mP, mE);
        mPlainText := mPlainText + mP;
        mEncodeText := mEncodeText + mE;
      end;
      Dm.EncodeContent[i].EKind := 'sp';
      Dm.EncodeContent[i].EDate := FQryDate;
      Dm.EncodeContent[i].EDanhao := FieldByName('销售单号').AsInteger;
      Dm.EncodeContent[i].EPlainText := mPlainText;
      Dm.EncodeContent[i].EEncodeText := mEncodeText;
      Next;
      i := i + 1;
    end;
  end;
end;

procedure TfrmMain.ShowSummary(ADate:TDate);
var
  mTotalRecords:integer;
  mXsRecords:integer;
  mXtRecords:integer;
  mFkRecords:integer;
  mSpRecords:integer;
  mXsJine:double;
  mXtJine:double;
begin
  mXsRecords:=0;
  mXtRecords:=0;
  mXsJine:=0;
  mXtJine:=0;
  with dm.qryXsxx do
  begin
    First;
    while not Eof do
    begin
      if FieldByName('销售退货').AsInteger=1 then
      begin
        mXsRecords:=mXsRecords+1;
        mXsJine:=mXsJine+FieldByName('本次结算费用总额').AsFloat;
      end
      else
      begin
        mXtRecords:=mXtRecords+1;
        mXtJine:=mXtJine+FieldByName('本次结算费用总额').AsFloat;
      end;
      Next;
    end;
  end;
  dm.qryFkxx.Last;
  dm.qrySpxx.Last;
  dm.qryXsxx.Last;
  mFkRecords:=dm.qryFkxx.RecordCount;
  mSpRecords:=dm.qrySpxx.RecordCount;
  mTotalRecords:=mXsRecords+mXtRecords+mFkRecords+mSpRecords;

  panel6.Caption:=FormatDatetime('yyyy-mm-dd',ADate)+'共查询'+inttostr(mTotalRecords)+'条记录，其中：销售'+inttostr(mXsRecords)+'条；退货'+inttostr(mXtRecords)+'条；付款'+inttostr(mFkRecords)+'条；商品'+inttostr(mSpRecords)+'条';
  Label9.Caption:=FormatFloat('#0.000',mXsJine+mXtJine)+'，其中销售合计'+FormatFloat('#0.00',mXsJine)+' 退货合计'+formatFloat('#0.00',mXtJine);
end;

procedure TfrmMain.FieldToString(AField: TField; var APlainText: string; var AEncodeText: string);

  function EncodeFieldName(AName: string): string;
  begin
    case AName of
      '销售单号': Result := 'a';
      '结算日期': Result := 'b';
      '就诊卡号': Result := 'c';
      '结算病种': Result := 'd';
      '医生名称': Result := 'e';
      '患者姓名': Result := 'f';
      '身份证号': Result := 'g';
      '本次结算费用总额': Result := 'h';
      '病人负担金额': Result := 'i';
      '医保负担金额': Result := 'j';
      '结算号ID': Result := 'k';
      '支付方式代码': Result := 'l';
      '支付方式名称': Result := 'm';
      '支付金额': Result := 'n';
      '商品编码': Result := 'o';
      '商品名称': Result := 'p';
      '批号': Result := 'q';
      //         '销售单价':Result:='r';
      //         '销售数量':Result:='s'; 已改成单价和数量
      '单价': Result := 'r';
      '数量': Result := 's';
      '开方医生': Result := 't';
      '处方识别': Result := 'u';//SPXX里新增加的
      '销售退货': Result := 'v';
      '行号': Result := 'z';
      else
        Result := AName;
    end;
  end;

begin
  APlainText := AField.FieldName + '~' + AField.AsString + '^';
  AEncodeText := EncodeFieldName(AField.FieldName) + '~' + AField.AsString + '^';
end;

end.
