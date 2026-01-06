unit start_trd;

{$mode objfpc}{$H+}

interface

uses
  Classes, Process, SysUtils, ComCtrls, Forms;

type
  StartCommand = class(TThread)
  private
    // Строка для передачи в ShowLog через Synchronize
    FTempLine: string;

    procedure ShowLog;
    procedure StartProgress;
    procedure StopProgress;

  protected
    procedure Execute; override;

  end;

implementation

uses Unit1;

  { TRD }

procedure StartCommand.Execute;
var
  ExProcess: TProcess;
  Buf: array[0..1023] of ansichar;
  Len: longint;
  Acc: ansistring;
  LinePos: integer;
  S: string;
begin
  FreeOnTerminate := True; //Уничтожить по завершении
  Synchronize(@StartProgress);

  Acc := '';

  try //Вывод лога и прогресса
    ExProcess := TProcess.Create(nil);

    ExProcess.Executable := 'bash';
    ExProcess.Parameters.Add('-c');

    //Группа команд
    ExProcess.Parameters.Add(
      'urpmi --auto kernel-firmware-nonfree');


    ExProcess.Options := [poUsePipes, poStderrToOutPut];
    // , poWaitOnExit (синхронный вывод)


    ExProcess.Execute;

    while ExProcess.Running or (ExProcess.Output.NumBytesAvailable > 0) do
    begin
      Len := ExProcess.Output.NumBytesAvailable;
      if Len > 0 then
      begin
        if Len > SizeOf(Buf) then Len := SizeOf(Buf);
        ExProcess.Output.Read(Buf, Len);
        Acc := Acc + Copy(Buf, 0, Len);
        // аккумулируем байты в строку

        // Разбиваем на строки по LineEnding
        LinePos := Pos(LineEnding, string(Acc));
        while LinePos > 0 do
        begin
          S := Copy(Acc, 1, LinePos - 1);
          FTempLine := S;
          Synchronize(@ShowLog); // добавляем строку в Memo
          Delete(Acc, 1, LinePos + Length(LineEnding) - 1);
          LinePos := Pos(LineEnding, string(Acc));
        end;
      end;
      Sleep(10);
    end;

    // Вывод остатка
    if Acc <> '' then
    begin
      FTempLine := string(Acc);
      Synchronize(@ShowLog);
    end;

  finally
    ExProcess.Free;
    Synchronize(@StopProgress);
  end;
end;

{ БЛОК ОТОБРАЖЕНИЯ ЛОГА }

//Старт команды
procedure StartCommand.StartProgress;
begin
  if Assigned(MainForm) then
    with MainForm do
    begin
      LogMemo.Clear;

      Application.ProcessMessages;
      InstallBtn.Enabled := False;
      UnInstallBtn.Enabled := False;
      ProgressBar1.Style := pbstMarquee;
    end;
end;

//Стоп команды
procedure StartCommand.StopProgress;
begin
  if Assigned(MainForm) then
    with MainForm do
    begin
      Application.ProcessMessages;
      InstallBtn.Enabled := True;
      UnInstallBtn.Enabled := True;
      ProgressBar1.Style := pbstNormal;
    end;
end;

//Вывод лога
procedure StartCommand.ShowLog;
begin
  //Вывод построчно
  if Assigned(MainForm) then
    with MainForm do
    begin
      LogMemo.Lines.Append(FTempLine);

      //Промотать список вниз
      LogMemo.SelStart := Length(MainForm.LogMemo.Text);
      LogMemo.SelLength := 0;
    end;
end;

end.
