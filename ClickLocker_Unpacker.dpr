program ClickLocker_Unpacker;

uses
  Forms,
  MainForm in 'MainForm.pas' {CLUFrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCLUFrmMain, CLUFrmMain);
  Application.Run;
end.
