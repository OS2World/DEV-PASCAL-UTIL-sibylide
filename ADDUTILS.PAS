
{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ     Sibyl Visual Development Environment                                 บ
 บ                                                                          บ
 บ     Copyright (C) 1995,99 SpeedSoft Germany,   All rights reserved.      บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

{ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
 บ                                                                          บ
 บ Sibyl Integrated Development Environment (IDE)                           บ
 บ Object-oriented development system.                                      บ
 บ                                                                          บ
 บ Copyright (C) 1995,99 SpeedSoft GbR, Germany                             บ
 บ                                                                          บ
 บ This program is free software; you can redistribute it and/or modify it  บ
 บ under the terms of the GNU General Public License (GPL) as published by  บ
 บ the Free Software Foundation; either version 2 of the License, or (at    บ
 บ your option) any later version. This program is distributed in the hope  บ
 บ that it will be useful, but WITHOUT ANY WARRANTY; without even the       บ
 บ implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR          บ
 บ PURPOSE.                                                                 บ
 บ See the GNU General Public License for more details. You should have     บ
 บ received a copy of the GNU General Public License along with this        บ
 บ program; if not, write to the Free Software Foundation, Inc., 59 Temple  บ
 บ Place - Suite 330, Boston, MA 02111-1307, USA.                           บ
 บ                                                                          บ
 บ In summary the original copyright holders (SpeedSoft) grant you the      บ
 บ right to:                                                                บ
 บ                                                                          บ
 บ - Freely modify and publish the sources provided that your modification  บ
 บ   is entirely free and you also make the modified source code available  บ
 บ   to all for free (except a fee for disk/CD production etc).             บ
 บ                                                                          บ
 บ - Adapt the sources to other platforms and make the result available     บ
 บ   for free.                                                              บ
 บ                                                                          บ
 บ Under this licence you are not allowed to:                               บ
 บ                                                                          บ
 บ - Create a commercial product on whatever platform that is based on the  บ
 บ   whole or parts of the sources covered by the license agreement. The    บ
 บ   entire program or development environment must also be published       บ
 บ   under the GNU General Public License as entirely free.                 บ
 บ                                                                          บ
 บ - Remove any of the copyright comments in the source files.              บ
 บ                                                                          บ
 บ - Disclosure any content of the source files or use parts of the source  บ
 บ   files to create commercial products. You always must make available    บ
 บ   all source files whether modified or not.                              บ
 บ                                                                          บ
 ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

Unit AddUtils; { Additional Utilities, J”rg Pleumann }

{$IFDEF SPEED}
{$USE32+, H+ }
{$ENDIF SPEED}

interface

uses
  SysUtils;

{ --- File functions --- }

const
  BackupExtension: string = '.bak';
    { Specifies the extension used for
      creating backup files. }

  BackupLongNames: Boolean = False;
    { Decides whether the backup function
      tries to append the extension or not. }

function BackupFile(const FileName: string): string;
  { Creates a backup of the given file. Returns
    the name of the backup file or the empty
    string in case an error occurs. Uses the
    values of the ~BackupExtension~ and
    ~BackupLongNames~ constants. }

(*
function FileCreateTemp(var FileName: string): LongInt;
  { Creates a temporary file. }
function FileCreateUnique(var FileName: string): LongInt;
  { Creates a file with a unique name. }

eventuell alle anderen file-aufrufe nachbauen,
aber mit gescheiten namen.

*)

type
  TForEachFileFunc = function(const FileName: string): Integer;
    { Function prototype for ~ForEachFile~. }

function ForEachFile(const Path: string; Attr: Word; Action: TForEachFileFunc): Integer;
  { Performs given action for all files that
    match the specified path and Attributes.
    Returns the number of files processed of
    the negative result code in case an error
    occured. }

(*
function ForEachFileEx(const Path: string; Attr: Word; Action: TForEachFileFunc): Integer;
  { Wie oben, aber rekursiv in Unterverzeichnisse. }
*)

{ --- Directory functions --- }

function CreateDir(const Name: string): Boolean;
  { Creates a directory. }

function CreateDirEx(const Name: string): Boolean;
  { Creates a directory. Works
    recursively, if needed. }

function DeleteDir(const Name: string): Boolean;
  { Deletes a directory. }

function DeleteDirEx(const Name: string): Boolean;
  { Deletes a directory. Works
    recursively, if needed. }

function DirExists(const Name: string): Boolean;
  { Checks whether given directory exists. }

function GetHomeDir: string;
  { Returns current user's home directory. }

function GetProgramDir: string;
  { Returns application's directory. }

function GetTempDir: string;
  { Returns system's temporary directory. }

function GetWorkingDir: string;
  { Returns current directory. }

{ --- Disk functions --- }

function CharToDisk(Disk: Char): Byte;
  { Converts drive letter to drive number.
    Returns zero for illegal characters. }

function DiskToChar(Disk: Byte): Char;
  { Converts drive number to drive letter.
    Returns zero character for illegal
    drive numbers. }

function GetBootDisk: Byte;
  { Queries the drive on which the
    operating system resides. }

{ --- Language support functions --- }

function GetCodePage: Integer;
  { Gets the current code page. }

function GetPrimaryCodePage: Integer;
  { Gets the system's primary code page. }

function GetSecondaryCodePage: Integer;
  { Gets the system's secondary code page. }

function GetAvailCodePage(Index: Integer): Integer;
  { Get a code page by index. Returns zero
    if index is out of range. }

function GetNumAvailCodePages: Integer;
  { Get number of available code pages. }

procedure SetCodePage(CodePage: Integer);
  { Set the current code page for the
    application. The two code pages
    returned by ~GetPrimaryCodePage~ and
    ~GetSecondaryCodePage~ are allowed. }

function Translate(const S: string; OldCodePage, NewCodePage: Integer): string;
  { Translate a string from one code page to another.
    Returns empty string if either of the two code
    pages is not available. }

{ --- Program information --- }

(*

function GetProgramFileName: string;
  { Returns fully qualified program
    path. }

function GetProgramName: string;
  { Returns program title. }

function GetProgramVersion: string;
  { Returns program version. }

function GetProgramCopyright: string;
function GetProgramDateTime: TDateTime;
*)

{ --- Miscellaneous functions --- }

function GetCompiler: string;
  { Queries compiler name and version. }

function GetEnv(const EnvVar: string): string;
  { Queries environment variable. Returns empty
    string if given variable is undefined. }

function GetEnvDef(const EnvVar, Default: string): string;
  { Queries environment variable. Returns default
    value if given variable is undefined. }

function GetPhysicalMemory: LongInt;
  { Queries physical RAM in bytes. }

function GetTimeZone: string;
  { Returns current time zone. }

function GetUptime: Integer;
  { Queries milliseconds since system
    startup. }

function SetErrorPopups(Value: Boolean): Boolean;
  { Activates or deactivates system's error
    popup windows. Returns the previous state. }

{$IFDEF OS2}
procedure Sleep(MS: LongInt);
  { Sleeps for MS milliseconds. }
{$ENDIF}  

implementation

{$IFDEF OS2}
uses
  OS2Def, BseDos, BseErr, PmWin;
{$ENDIF OS2}

{$IFDEF WIN32}
Uses WinBase;
{$ENDIF}

{ --- File functions --- }

function BackupFile(const FileName: string): string;
begin
  if BackupLongNames then
    Result := FileName + BackupExtension
  else
    Result := ChangeFileExt(FileName, BackupExtension);

  if not SysUtils.CopyFile(FileName, Result) then
    Result := '';
end;

function ForEachFile(const Path: string; Attr: Word; Action: TForEachFileFunc): Integer;
var
  SearchRec: SysUtils.TSearchRec;
  AbsPath, DirName: string;
  FindResult, ActionResult: Integer;
begin
  AbsPath := ExpandFileName(Path);
  DirName := ExtractFilePath(AbsPath);

  Result := 0;
  ActionResult := 0;

  FindResult := FindFirst(Path, Attr, SearchRec);
  try
    while (FindResult = 0) and (ActionResult = 0) do
    begin
      ActionResult := Action(ConcatFileName(DirName, SearchRec.Name));
      FindResult := FindNext(SearchRec);
    end;
  except
    SysUtils.FindClose(SearchRec);
  end;

  if ActionResult <> 0 then Result := - Abs(ActionResult);
end;

{ --- Directory functions --- }

function CreateDir(const Name: string): Boolean;
begin
  {$IFDEF OS2}
  Result := (DosCreateDir(Name, nil) = NO_ERROR);
  {$ENDIF}
  {$IFDEF WIN32}
  result:=CreateDirectory(Name,Nil);
  {$ENDIF}
end;


function CreateDirEx(const Name: string): Boolean;
begin
end;

function DeleteDir(const Name: string): Boolean;
begin
  {$IFDEF OS2}
  Result := (DosDeleteDir(Name) = NO_ERROR);
  {$ENDIF}
  {$IFDEF WIN32}
  Result := RemoveDirectory(Name);
  {$ENDIF}
end;

function DeleteDirEx(const Name: string): Boolean;
begin
end;

function DirExists(const Name: string): Boolean;
const
  Attributes = faDirectory or faArchive or faSysFile or faHidden;
var
  SearchRec: TSearchRec;
  FindResult: Integer;
begin
  FindResult := FindFirst(Name, Attributes, SearchRec);
  Result := (FindResult = 0) and (SearchRec.Attr and faDirectory = faDirectory);
  SysUtils.FindClose(SearchRec);
end;

function GetHomeDir: string;
begin
  Result := ExpandFileName(GetEnv('HOME'));
end;

var
  ProgramPath: string;

function GetProgramDir: string;
begin
  Result := ExtractFilePath(ProgramPath);
  if Length(Result) > 3 then
  begin
    if Result[Length(Result) - 1] <> ':' then
      SetLength(Result, Length(Result) - 1);
  end;
end;

function GetTempDir: string;
begin
  Result := ExpandFileName(GetEnvDef('TEMP', GetEnvDef('TMP', 'C:\')));
end;

function GetWorkingDir: string;
var
  Buffer: cstring;
  QueryResult: Integer;
  Length: LongWord;
begin
  Length := SizeOf(Buffer);
  {$IFDEF OS2}
  QueryResult := DosQueryCurrentDir(0, Buffer, Length);
  if QueryResult = NO_ERROR then Result := Buffer
  else Result := '';
  {$ENDIF}
  {$IFDEF WIN32}
  Length := GetCurrentDirectory(255,Buffer);
  If Length=0 Then Result:=''
  Else Result:=Buffer;
  {$ENDIF}
end;

{ --- Disk functions --- }

function CharToDisk(Disk: Char): Byte;
begin
  case Disk of
    'A'..'Z': Result := Ord(Disk) - Ord('A') + 1;
    'a'..'z': Result := Ord(Disk) - Ord('a') + 1;
  else
    Result := 0;
  end;
end;

function DiskToChar(Disk: Byte): Char;
begin
  case Disk of
    0:     Result := GetWorkingDir[1];
    1..26: Result := Chr((Ord('A') - 1) + Disk)
  else
    Result := #0;
  end;
end;

function GetBootDisk: Byte;
var
  I: Integer;
begin
  {$IFDEF OS2}
  if DosQuerySysInfo(QSV_BOOT_DRIVE,
                     QSV_BOOT_DRIVE,
                     I,
                     SizeOf(Result)) = NO_ERROR then
    Result := I
  else
    Result := 0;
  {$ENDIF}
  {$IFDEF WIN32}
  Result:=3; //C:
  {$ENDIF}
end;

{ --- Language support functions --- }

type
  TULONGArray = array[0..MaxLongInt div SizeOf(LONGWORD) - 1] of LONGWORD;
  PULONGArray = ^TULONGArray;

const
  CodePageArray: PULONGArray = nil;
  CodePageCount: Integer = 0;

procedure CreateCodePageList;
begin
  {$IFDEF OS2}
  CodePageCount := WinQueryCPList(AppHandle,
                                  0,
                                  nil);

  if CodePageCount <> 0 then
  begin
    CodePageArray := AllocMem(CodePageCount * SizeOf(ULONG));

    WinQueryCPList(AppHandle, CodePageCount, CodePageArray^);
  end;
  {$ENDIF}
end;

procedure DestroyCodePageList;
begin
  if CodePageArray <> nil then
    FreeMem(CodePageArray, CodePageCount * SizeOf(LONGWORD));
end;

function GetCodePage: Integer;
var
  Buffer: array[0..2] of LongWord;
  Length: LongWord;
begin
  {$IFDEF OS2}
  if DosQueryCP(SizeOf(Buffer), Buffer[0], Length) = NO_ERROR then
    Result := Buffer[0]
  else
    Result := 0;
  {$ENDIF}
  {$IFDEF WIN32}
  Result:=0;
  {$ENDIF}
end;

function GetPrimaryCodePage: Integer;
var
  Buffer: array[0..2] of LongWord;
  Length: LongWord;
begin
  {$IFDEF OS2}
  if DosQueryCP(SizeOf(Buffer), Buffer[0], Length) = NO_ERROR then
    Result := Buffer[1]
  else
    Result := 0;
  {$ENDIF}
  {$IFDEF WIN32}
  Result:=0;
  {$ENDIF}
end;

function GetSecondaryCodePage: Integer;
var
  Buffer: array[0..2] of LongWord;
  Length: LongWord;
begin
  {$IFDEF OS2}
  if DosQueryCP(SizeOf(Buffer), Buffer[0], Length) = NO_ERROR then
    Result := Buffer[2]
  else
    Result := 0;
  {$ENDIF}
  {$IFDEF WIN32}
  Result:=0;
  {$ENDIF}
end;

function GetAvailCodePage(Index: Integer): Integer;
begin
  if (Index >= 0) and (Index < CodePageCount) then
    Result := CodePageArray^[Index]
  else
    Result := 0;
end;

function GetNumAvailCodePages: Integer;
begin
  Result := CodePageCount;
end;

procedure SetCodePage(CodePage: Integer);
begin
  {$IFDEF OS2}
  DosSetProcessCP(CodePage);
  {$ENDIF}
end;

function Translate(const S: string; OldCodePage, NewCodePage: Integer): string;
var
  Success: Boolean;
  I: Integer;
begin
  {$IFDEF OS2}
  Result := S;
  UniqueStr(Result);

  Success := WinCPTranslateString(AppHandle,
                                  OldCodePage,
                                  PChar(S)^,
                                  NewCodePage,
                                  Length(Result) + 1,
                                  PChar(Result)^);

  if not Success then
  begin
    Result := '';
    Exit;
  end;

  for I := 1 to Length(Result) do
    if Result[I] = #255 then Result[I] := S[I];
  {$ENDIF}
  {$IFDEF WIN32}
  Result:=S;
  {$ENDIF}
end;

{ --- Miscellaneous functions --- }

function GetCompiler: string;
begin
  Result := '';

  {$IFDEF SPEED}
    {$IFDEF VER20}
      Result := 'SpeedSoft Sibyl Version 2.0';
    {$ENDIF}
  {$ENDIF}
end;

function GetEnv(const EnvVar: string): string;
begin
  Result := GetEnvDef(EnvVar, '');
end;

function GetEnvDef(const EnvVar, Default: string): string;
var
  C: cstring;
  {$IFDEF WIN32}
  C1: CString;
  {$ENDIF}
  P: PChar;
begin
  C := UpperCase(EnvVar);
  {$IFDEF OS2}
  if DosScanEnv (C, P) = 0 then
    Result := P^
  else
    Result := Default;
  {$ENDIF}
  {$IFDEF WIN32}
  If GetEnvironmentVariable(C,C1,255)=0 Then Result:=Default
  Else Result:=C;
  {$ENDIF}
end;

function GetPhysicalMemory: LongInt;
begin
  {$IFDEF OS2}
  if DosQuerySysInfo(QSV_TOTPHYSMEM,
                     QSV_TOTPHYSMEM,
                     Result,
                     4) <> NO_ERROR then
    Result := 0;
  {$ENDIF}
  {$IFDEF WIN32}
  Result:=0;
  {$ENDIF}
end;

function GetTimeZone: string;
begin
  {$IFDEF OS2}
  Result := GetEnvDef('TZ', GetEnvDef('TIMEZONE', 'GMT+0'));
  {$ENDIF}
  {$IFDEF WIN32}
  Result:='';
  {$ENDIF}
end;

function GetUptime: Integer;
begin
  {$IFDEF OS2}
  if DosQuerySysInfo(QSV_MS_COUNT,
                     QSV_MS_COUNT,
                     Result,
                     SizeOf(Result)) <> NO_ERROR then
    Result := 0;
  {$ENDIF}
  {$IFDEF WIN32}
  Result:=0;
  {$ENDIF}
end;

const
  ErrorPopups: Boolean = True;

function SetErrorPopups(Value: Boolean): Boolean;
begin
  Result := ErrorPopups;

  {$IFDEF OS2}
  if Value then DosErrorAPI(FERR_ENABLEHARDERR or FERR_ENABLEEXCEPTION)
  else DosErrorAPI(FERR_DISABLEHARDERR or FERR_ENABLEEXCEPTION);
  {$ENDIF}

  ErrorPopups := Value;
end;

{$IFDEF OS2}
procedure Sleep(MS: LongInt);
begin
  {$IFDEF OS2}
  DosSleep(MS);
  {$ENDIF}
  {$IFDEF WIN32}
  WinBase.Sleep(MS);
  {$ENDIF}
end;
{$ENDIF}

initialization
  CreateCodePageList;
  ProgramPath := ExpandFileName(ParamStr(0));

finalization

  ProgramPath := '';
  DestroyCodePageList;
end.

{
GetUserName: string;
GetHostName: string;
GetDomain: string;
GetHostID: LongInt;

GetCountry
GetCountryCode

GetPhysicalMemory
GetTotalMemory

GetOSName               GetOperatingSystem
GetOSVersion            GetOperating

GetCPUName
GetCPUVersion

GetDriveReady           DiskReady
GetDriveLocked          DiskLocked
GetDriveReadOnly        DiskReadOnly
GetDriveType            DiskType
                        DiskAvail

GetHeapSize
GetHeapFree             MemAvail
GetHeapUsed             MemUsed
GetHeapBlocks

GetMaximumPath          GetMaxPathLength
GetPathSeparator        GetPathSeparator
GetUniCodeSupport       GetUniCodeSupport

function GetProgramFileName: string;
function GetProgramName: string;
function GetProgramVersion: string;
function GetProgramCopyright: string;
function GetProgramDateTime: TDateTime;

}