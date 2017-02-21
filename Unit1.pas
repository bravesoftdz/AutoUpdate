unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CRCunit, FileCtrl, ComCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Edit1: TEdit;
    ProgressBar1: TProgressBar;
    procedure UpdateList(StartDir: string; List: TStringList);
    procedure Button1Click(Sender: TObject);
    function CountFiles(ADirectory: String): Integer;
  private
    { Private declarations }
  public
  end;

var
  Form1: TForm1;
  List: TStringList;
  Dir: String;

implementation

{$R *.dfm}

function TForm1.CountFiles(ADirectory: String): Integer;
var
  Rec: TSearchRec;
  sts: Integer;
begin
  Result := 0;
  sts := FindFirst(ADirectory + '\*.*', faAnyFile, Rec);
  if sts = 0 then
  begin
    repeat
      if ((Rec.Attr and faDirectory) <> faDirectory) then
        Inc(Result)
      else if (Rec.Name <> '.') and (Rec.Name <> '..') then
        Result := Result + CountFiles(ADirectory + '\' + Rec.Name);
    until FindNext(Rec) <> 0;
    SysUtils.FindClose(Rec);
  end;
end;

procedure TForm1.UpdateList(StartDir: string; List: TStringList);
var
  SearchRec: TSearchRec;
  Fold: String;
begin
  if StartDir[Length(StartDir)] <> '\' then
    StartDir := StartDir + '\';
  if FindFirst(StartDir + '*.*', faAnyFile, SearchRec) = 0 then
  begin
    repeat
      Application.ProcessMessages;
      if (SearchRec.Attr and faDirectory) <> faDirectory then
      begin
        Fold := StringReplace(StartDir, Dir, '', [rfReplaceAll, rfIgnoreCase]);
        List.Add(Fold + SearchRec.Name + '=' +
          IntToHex(GetFileCRC(StartDir + SearchRec.Name), 8));
        ProgressBar1.Position := ProgressBar1.Position + 1;
      end
      else if (SearchRec.Name <> '..') and (SearchRec.Name <> '.') then
        UpdateList(StartDir + SearchRec.Name + '\', List);
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
Var
  Folder: String;
begin
  Memo1.Clear;
  SelectDirectory('Выберите папку :', '', Folder, [sdNewFolder, sdNewUI]);
  if Folder <> '' then
  begin
    Edit1.Text := Folder;
    ProgressBar1.Max := CountFiles(Folder);
    List := TStringList.Create;
    Dir := Folder;
    UpdateList(Dir, List);
    List.SaveToFile('C:\UpdateList.dwn');
    Memo1.Lines.LoadFromFile('C:\UpdateList.dwn');
    Form1.Caption := 'Файл сохранен : "C:\UpdateList.dwn"   ' +
      IntToStr(List.Count)+' Файлов';
    List.Free;
    WinExec('EXPLORER /e, ' + '"c:\"', SW_SHOW);
    ProgressBar1.Position := 0;
  end;
end;

end.
