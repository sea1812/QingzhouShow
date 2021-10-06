unit progresform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TfrmProgres }

  TfrmProgres = class(TForm)
    Panel1: TPanel;
  private

  public
    procedure Info(AText:string);
  end;

var
  frmProgres: TfrmProgres;

implementation

{$R *.frm}

{ TfrmProgres }

procedure TfrmProgres.Info(AText: string);
begin
  Panel1.Caption:=AText;
  Panel1.Update;
  Application.ProcessMessages;
  if not Self.Showing then
  begin
    Self.Show;
    Self.BringToFront;
  end;
end;

end.

