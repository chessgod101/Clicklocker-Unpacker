unit MainForm;

interface

uses
  Windows, SysUtils, Classes, Forms,
  Dialogs, StdCtrls, Controls, ShellAPI, messages;

type
  TCLUFrmMain = class(TForm)
    PathEdit: TEdit;
    UnpackBtn: TButton;
    BrowseBtn: TButton;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    ExitBtn: TButton;
    procedure UnpackBtnClick(Sender: TObject);
    procedure BrowseBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    protected
    procedure WMDropFiles(var Msg: TMessage); message WM_DROPFILES;
  end;

var
  CLUFrmMain: TCLUFrmMain;
const verStr:ansistring= 'YYYNclocker';

type clickLockerFile= packed record
  size:cardinal;   //size of embedded file;
  resv:array[0..7] of byte;
  typef:array[0..3] of ansichar; //file type extension
  resv2:array[0..8] of byte;
  vStr:array[0..19] of ansiChar; //version string;
end;

implementation

{$R *.dfm}
Function FileExists(filePath:WideString):Boolean;
Var
dwAttrib:Cardinal;
Begin
  dwAttrib := GetFileAttributes(@filePath[1]);
  if (dwAttrib = $FFFFFFFF) or (dwAttrib =FILE_ATTRIBUTE_DIRECTORY) then
    result:=false
  else
    result:=true;
End;

Function RemExt(FName:widestring):widestring;
var
len:cardinal;
Begin
  len:=length(Fname)-length(ExtractFileExt(FName));
  SetLength(result,len);
  CopyMemory(@result[1],@FName[1],len*2);
End;

procedure TCLUFrmMain.UnpackBtnClick(Sender: TObject);
var
  secFileHandle,sHandle:tHandle;
  FileStr,sFileStr:WideString;
  secFileSize,tmp:cardinal;
  infoV:clickLockerFile;
  FileBuf:Array of Byte;
begin
  FileStr:=PathEdit.Text;
  sFileStr:=ExtractFilePath(FileStr);

  if FileExists(FileStr)=false then begin
    MessageBoxW(Application.Handle,PWideChar('Invalid File Path. File Does Not Exist!'),PWideChar('ClickLocker Unpacker'),MB_OK);
    Exit;
  End;

  secfileHandle:=CreateFileW(PWideChar(@FileStr[1]),GENERIC_READ,FILE_SHARE_READ,NIL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL, 0);

  if secFileHandle=INVALID_HANDLE_VALUE then begin
    MessageBoxW(Application.Handle,PWideChar('Error Opening File'),PWideChar('ClickLocker Unpacker'),MB_OK);
    exit;
  End;

  secFileSize:=GetFileSize(secFileHandle, nil);

  SetFilePointer(secFileHandle,secFileSize-45,NIL,FILE_BEGIN);

  if ReadFile(secFileHandle,infoV,45,tmp,NIL)= false then begin
    CloseHandle(secFileHandle);
    MessageBoxW(Application.Handle,PWideChar('Error Reading File'),PWideChar('ClickLocker Unpacker'),MB_OK);
    exit;
  end;

  if CompareMem(@infoV.vStr[0],@verStr[1],11)=false then Begin
    CloseHandle(secFileHandle);
    MessageBoxW(Application.Handle,PWideChar('Not A valid ClickLocker File'),PWideChar('ClickLocker Unpacker'),MB_OK);
    Exit;
  End;

  setlength(FileBuf,infoV.size);
  SetFilePointer(secFileHandle,secFileSize-45-infoV.size,nil,FILE_BEGIN);

  If ReadFile(secFileHandle,FileBuf[0],infoV.size,tmp,NIL)=false then begin
    CloseHandle(secFileHandle);
    MessageBoxW(Application.Handle,PWideChar('Error Reading Embedded File'),PWideChar('ClickLocker Unpacker'),MB_OK);
    exit;
  end;

  CloseHandle(secFileHandle);
  sFileStr:=sFileStr+remExt(ExtractFileName(FileStr))+'_unpacked.'+WideString(infoV.typef);

  sHandle:=CreateFileW(PWideChar(@sFileStr[1]),GENERIC_Write,FILE_SHARE_READ,NIL,CREATE_NEW,FILE_ATTRIBUTE_NORMAL, 0);

  if sHandle= INVALID_HANDLE_VALUE then begin
    MessageBoxW(Application.Handle,PWideChar('Error Creating Unpacked File'),PWideChar('ClickLocker Unpacker'),MB_OK);
    Exit;
  end;

  if WriteFile(sHandle,FileBuf[0],infoV.size,tmp,NIL)= false then begin
    MessageBoxW(Application.Handle,PWideChar('Error Writing Unpacked File'),PWideChar('ClickLocker Unpacker'),MB_OK);
    CloseHandle(sHandle);
    exit;
  end;

  CloseHandle(sHandle);
  MessageBeep(MB_OK);
  MessageBoxW(Application.Handle,PWideChar('File Unpacked Successfully!'),PWideChar('ClickLocker Unpacker'),MB_OK);
end;

procedure TCLUFrmMain.BrowseBtnClick(Sender: TObject);
begin
  if OpenDialog1.Execute=true then
  PathEdit.Text:=OpenDialog1.FileName;
end;

procedure TCLUFrmMain.ExitBtnClick(Sender: TObject);
begin
  ExitProcess(0);
end;

procedure TCLUFrmMain.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle,true);
end;

procedure TCLUFrmMain.FormDestroy(Sender: TObject);
begin
  DragAcceptFiles(Handle,false);
end;

procedure TCLUFrmMain.WMDropFiles(var Msg: TMessage);
var
  l:cardinal;
  s:string;
Begin
  l:=DragQueryFile(Msg.WParam,0,nil,0)+1;
  SetLength(s,l);
  DragQueryFile(Msg.WParam,0,Pointer(s),l);

  if lowercase(TrimRight(ExtractFileExt(s)))='.exe' then
    PathEdit.Text:=s;
End;

end.
