unit MainUnit;

interface

uses
  SysUtils, Math, SuperObject;

type
  TJSONConfigFile = class
  strict private
    FSuperObject: ISuperObject;
  public
    constructor Create(FileName: PWideChar); reintroduce;
    destructor Destroy; override;
    function SaveToFile(FileName: PWideChar): Boolean;
    function QueryString(Section, Key, Default: PWideChar;
      var Value: PWideChar; var ValueLength: Integer): Boolean;
    function QueryBoolean(Section, Key: PWideChar; Default: Boolean;
      var Value: Boolean): Boolean;
    function QueryInteger(Section, Key: PWideChar; Default: Int64;
      var Value: Int64): Boolean;
    function WriteString(Section, Key, Value: PWideChar): Boolean;
    function WriteBoolean(Section, Key: PWideChar; Value: Boolean): Boolean;
    function WriteInteger(Section, Key: PWideChar; Value: Int64): Boolean;
  end;

function JSONQueryString(FileName, Section, Key, Default: PWideChar;
  var Value: PWideChar; var ValueLength: Integer): Boolean; stdcall;
function JSONQueryBoolean(FileName, Section, Key: PWideChar; Default: Boolean;
  var Value: Boolean): Boolean; stdcall;
function JSONQueryInteger(FileName, Section, Key: PWideChar; Default: Int64;
  var Value: Int64): Boolean; stdcall;
function JSONWriteString(FileName, Section, Key,
  Value: PWideChar): Boolean; stdcall;
function JSONWriteBoolean(FileName, Section, Key: PWideChar;
  Value: Boolean): Boolean; stdcall;
function JSONWriteInteger(FileName, Section, Key: PWideChar;
  Value: Int64): Boolean; stdcall;

implementation

function JSONQueryString(FileName, Section, Key, Default: PWideChar;
  var Value: PWideChar; var ValueLength: Integer): Boolean;
var
  JSONConfigFile: TJSONConfigFile;
begin
  JSONConfigFile := TJSONConfigFile.Create(FileName);
  try
    Result := JSONConfigFile.QueryString(Section, Key, Default, Value,
      ValueLength);
  finally
    JSONConfigFile.Free;
  end;
end;

function JSONQueryBoolean(FileName, Section, Key: PWideChar; Default: Boolean;
  var Value: Boolean): Boolean;
var
  JSONConfigFile: TJSONConfigFile;
begin
  JSONConfigFile := TJSONConfigFile.Create(FileName);
  try
    Result := JSONConfigFile.QueryBoolean(Section, Key, Default, Value);
  finally
    JSONConfigFile.Free;
  end;
end;

function JSONQueryInteger(FileName, Section, Key: PWideChar; Default: Int64;
  var Value: Int64): Boolean;
var
  JSONConfigFile: TJSONConfigFile;
begin
  JSONConfigFile := TJSONConfigFile.Create(FileName);
  try
    Result := JSONConfigFile.QueryInteger(Section, Key, Default, Value);
  finally
    JSONConfigFile.Free;
  end;
end;

function JSONWriteString(FileName, Section, Key,
  Value: PWideChar): Boolean;
var
  JSONConfigFile: TJSONConfigFile;
begin
  JSONConfigFile := TJSONConfigFile.Create(FileName);
  try
    Result := JSONConfigFile.WriteString(Section, Key, Value);
    if Result then
      Result := JSONConfigFile.SaveToFile(FileName);
  finally
    JSONConfigFile.Free;
  end;
end;

function JSONWriteBoolean(FileName, Section, Key: PWideChar;
  Value: Boolean): Boolean;
var
  JSONConfigFile: TJSONConfigFile;
begin
  JSONConfigFile := TJSONConfigFile.Create(FileName);
  try
    Result := JSONConfigFile.WriteBoolean(Section, Key, Value);
    if Result then
      Result := JSONConfigFile.SaveToFile(FileName);
  finally
    JSONConfigFile.Free;
  end;
end;

function JSONWriteInteger(FileName, Section, Key: PWideChar;
  Value: Int64): Boolean;
var
  JSONConfigFile: TJSONConfigFile;
begin
  JSONConfigFile := TJSONConfigFile.Create(FileName);
  try
    Result := JSONConfigFile.WriteInteger(Section, Key, Value);
    if Result then
      Result := JSONConfigFile.SaveToFile(FileName);
  finally
    JSONConfigFile.Free;
  end;
end;

{ TJSONConfigFile }

constructor TJSONConfigFile.Create(FileName: PWideChar);
begin
  inherited Create;
  try
    FSuperObject := TSuperObject.ParseFile(FileName, True);
  except
    FSuperObject := nil;
  end;
end;

destructor TJSONConfigFile.Destroy;
begin
  FSuperObject := nil;
  inherited Destroy;
end;

function TJSONConfigFile.QueryBoolean(Section, Key: PWideChar;
  Default: Boolean; var Value: Boolean): Boolean;
var
  PathObject: ISuperObject;
begin
  Result := False;
  Value := Default;
  if Assigned(FSuperObject) then
  begin
    PathObject := FSuperObject.O[String(Section) + '.' + String(Key)];
    if Assigned(PathObject) then
    begin
      Result := True;
      Value := PathObject.AsBoolean;
    end;
  end;
end;

function TJSONConfigFile.QueryInteger(Section, Key: PWideChar;
  Default: Int64; var Value: Int64): Boolean;
var
  PathObject: ISuperObject;
begin
  Result := False;
  Value := Default;
  if Assigned(FSuperObject) then
  begin
    PathObject := FSuperObject.O[String(Section) + '.' + String(Key)];
    if Assigned(PathObject) then
    begin
      Result := True;
      Value := PathObject.AsInteger;
    end;
  end;
end;

function TJSONConfigFile.QueryString(Section, Key, Default: PWideChar;
  var Value: PWideChar; var ValueLength: Integer): Boolean;
var
  S: string;
  PathObject: ISuperObject;
begin
  Result := False;
  ValueLength := Min(Length(String(Default)), ValueLength);
  StrLCopy(Value, Default, ValueLength);
  if Assigned(FSuperObject) then
  begin
    PathObject := FSuperObject.O[String(Section) + '.' + String(Key)];
    if Assigned(PathObject) then
    begin
      Result := True;
      S := PathObject.AsString;
      ValueLength := Min(ValueLength, Length(S));
      if Assigned(Value) and (ValueLength > 0) then
        StrPLCopy(Value, S, ValueLength);
    end;
  end;
end;

function TJSONConfigFile.SaveToFile(FileName: PWideChar): Boolean;
begin
  Result := False;
  if Assigned(FSuperObject) then
    Result := FSuperObject.SaveTo(String(FileName)) > 0;
end;

function TJSONConfigFile.WriteBoolean(Section, Key: PWideChar;
  Value: Boolean): Boolean;
begin
  Result := False;
  if Assigned(FSuperObject) then
  begin
    Result := True;
    FSuperObject.B[String(Section) + '.' + String(Key)] := Value;
  end;
end;

function TJSONConfigFile.WriteInteger(Section, Key: PWideChar;
  Value: Int64): Boolean;
begin
  Result := False;
  if Assigned(FSuperObject) then
  begin
    Result := True;
    FSuperObject.I[String(Section) + '.' + String(Key)] := Value;
  end;
end;

function TJSONConfigFile.WriteString(Section, Key,
  Value: PWideChar): Boolean;
begin
  Result := False;
  if Assigned(FSuperObject) then
  begin
    Result := True;
    FSuperObject.S[String(Section) + '.' + String(Key)] := String(Value);
  end;
end;

end.
