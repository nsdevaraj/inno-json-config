[Setup]
AppName=My Program
AppVersion=1.5
DefaultDirName={pf}\My Program
OutputDir=userdocs:Inno Setup Examples Output

[Files]
Source: "JSONConfig.dll"; Flags: dontcopy

[code]
function JSONQueryString(FileName, Section, Key, Default: WideString;
  var Value: WideString; var ValueLength: Integer): Boolean;
  external 'JSONQueryString@files:jsonconfig.dll stdcall';
function JSONQueryBoolean(FileName, Section, Key: WideString; 
  Default: Boolean; var Value: Boolean): Boolean;
  external 'JSONQueryBoolean@files:jsonconfig.dll stdcall';
function JSONQueryInteger(FileName, Section, Key: WideString; 
  Default: Int64; var Value: Int64): Boolean;
  external 'JSONQueryInteger@files:jsonconfig.dll stdcall';
function JSONWriteString(FileName, Section, Key, 
  Value: WideString): Boolean;
  external 'JSONWriteString@files:jsonconfig.dll stdcall';
function JSONWriteBoolean(FileName, Section, Key: WideString;
  Value: Boolean): Boolean;
  external 'JSONWriteBoolean@files:jsonconfig.dll stdcall';
function JSONWriteInteger(FileName, Section, Key: WideString;
  Value: Int64): Boolean;
  external 'JSONWriteInteger@files:jsonconfig.dll stdcall';

function BoolToStr(Value: Boolean): string;
begin
  Result := 'True';
  if not Value then
    Result := 'False';
end;

procedure InitializeWizard;
var
  FileName: WideString;
  IntValue: Int64;
  StrValue: WideString;
  StrLength: Integer;
  BoolValue: Boolean;
begin
  // set the source JSON config file path
  FileName := 'c:\Example.json';
  // allocate string buffer to enought length
  SetLength(StrValue, 16);
  // set the buffer length value
  StrLength := Length(StrValue);
  // query string value
  if JSONQueryString(FileName, 'Section_1', 'Key_1', 'Default', StrValue, StrLength) then
    MsgBox('Section_1:Key_1=' + StrValue, mbInformation, MB_OK);
  // query integer value
  if JSONQueryInteger(FileName, 'Section_1', 'Key_2', 0, IntValue) then
    MsgBox('Section_1:Key_2=' + IntToStr(IntValue), mbInformation, MB_OK);
  // query boolean value
  if JSONQueryBoolean(FileName, 'Section_1', 'Key_3', True, BoolValue) then
    MsgBox('Section_1:Key_3=' + BoolToStr(BoolValue), mbInformation, MB_OK);
  // write string
  if not JSONWriteString(FileName, 'Section_1', 'Key_1', 'New string value 1!') then
    MsgBox('JSONWriteString Section_1:Key_1 failed!', mbError, MB_OK);
  // write integer
  if not JSONWriteInteger(FileName, 'Section_1', 'Key_2', 123) then
    MsgBox('JSONWriteInteger Section_1:Key_2 failed!', mbError, MB_OK);
  // write boolean
  if not JSONWriteBoolean(FileName, 'Section_1', 'Key_3', False) then
    MsgBox('JSONWriteBoolean Section_1:Key_3 failed!', mbError, MB_OK);
end;







