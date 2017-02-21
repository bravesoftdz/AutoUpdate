unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CRCunit, StdCtrls, FileCtrl, IdComponent, IdHTTP, ComCtrls, StrUtils,
  IdURI;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure UpdateList(StartDir: string; List: TStringList);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  UList: TStringList;
  Dir: String;

implementation

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
var
  i: integer;
  stream: TFileStream;
  http: TIdHTTP;
  cd, d, url: string;
begin
  ProgressBar1.Position := 0;
  ProgressBar1.Max := UList.Count;
  for i := 0 to UList.Count - 1 do
  begin
    http := TIdHTTP.Create;
    Application.ProcessMessages;
    ProgressBar1.Position := ProgressBar1.Position + 1;

    d := Dir + UList.Names[i];
    cd := copy(d, 0, Length(d) - Pos('\', AnsiReverseString(d)));
    if DirectoryExists(d) = False then
      ForceDirectories(cd);

    stream := TFileStream.Create(Dir + UList.Names[i], fmCreate);
    url := 'http://dl.dropbox.com/u/7335408/MC' + StringReplace(UList.Names[i],
      '\', '/', [rfReplaceAll, rfIgnoreCase]);
    try
      try
        http.Get(TIdURI.ParamsEncode(url), stream);
      except
        on E: Exception do
      end;
    finally
      FreeAndNil(http);
      FreeAndNil(stream);
    end;
  end;
  ProgressBar1.Position := 0;
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
        if UList.Values[(Fold + SearchRec.Name)
          ] = IntToHex(GetFileCRC(StartDir + SearchRec.Name), 8) then
          UList.Delete(UList.IndexOf(Fold + SearchRec.Name + '=' + UList.Values
            [(Fold + SearchRec.Name)]));
      end
      else if (SearchRec.Name <> '..') and (SearchRec.Name <> '.') then
      begin
        UpdateList(StartDir + SearchRec.Name + '\', List);
      end;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
Var
  Path: String;
  stream: TFileStream;
  http: TIdHTTP;
begin
  SelectDirectory('Выберите папку :', '', Path, [sdNewFolder, sdNewUI]);
  if Path <> '' then
  begin
    Dir := Path;
    UList := TStringList.Create;
    http := TIdHTTP.Create;

    stream := TFileStream.Create('C:/UpdateList.dwn', fmCreate);
    try
      http.Get('http://theproject1.net/download/UpdateList.dwn', stream);
    finally
      FreeAndNil(http);
      FreeAndNil(stream);
    end;
    UList.LoadFromFile('C:\UpdateList.dwn');
    UpdateList(Path, UList);
    Label1.Caption := Label1.Caption + ' ' + IntToStr(UList.Count) + ' файлов';
  end;
end;

end.
