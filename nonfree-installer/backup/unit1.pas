unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ComCtrls, ExtCtrls, DefaultTranslator;

type

  { TMainForm }

  TMainForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    LogMemo: TMemo;
    InstallBtn: TSpeedButton;
    ProgressBar1: TProgressBar;
    UninstallBtn: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure InstallBtnClick(Sender: TObject);
    procedure UninstallBtnClick(Sender: TObject);
  private

  public

  end;

resourcestring
  SInstallConfirmation = 'Install kernel-firmware-nonfree package?';
  SUnInstallConfirmation = 'Uninstall kernel-firmware-nonfree package??';

var
  command: string;
  MainForm: TMainForm;

implementation

uses start_trd;

  {$R *.lfm}

  { TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  bmp: TBitmap;
begin
  //Устраняем баг иконки приложения
  bmp := TBitmap.Create;
  try
    bmp.PixelFormat := pf32bit;
    bmp.Assign(Image1.Picture.Graphic);
    Application.Icon.Assign(bmp);
  finally
    bmp.Free;
  end;
end;

//Install
procedure TMainForm.InstallBtnClick(Sender: TObject);
begin
  if MessageDlg(SConfirmation, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    command :=
      'if [ -d /run/mgalive/ovlsize ]; then echo "Installation on a flash drive is not possible!"; exit 0; fi; '
      + 'urpmi.update -a && urpmi --auto kernel-firmware-nonfree';
    StartCommand.Create(False);
  end;
end;

//UnInstall
procedure TMainForm.UninstallBtnClick(Sender: TObject);
begin
  if MessageDlg(SConfirmation, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    command :=
      '[ -d /run/mgalive/ovlsize ] && exit 0; urpmi.update -a && urpme --auto kernel-firmware-nonfree';
    StartCommand.Create(False);
  end;
end;

end.
