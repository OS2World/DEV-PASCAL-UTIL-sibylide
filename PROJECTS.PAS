
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

UNIT Projects;

INTERFACE

USES
  // hier nicht die Editors importieren, wegen SPC20.EXE
  Dos,Classes,SysUtils,IniFiles;


CONST
  IniVersion          = 'Sibyl Environment Ver2.0';
  ProjectVersion202   = 'Sibyl Project Ver2.02';
  ProjectVersion203   = 'Sibyl Project Ver2.03';
  ProjectVersion      = 'Sibyl Project Ver2.03';
  EditorMacroSignatur = 'Sibyl Editor Macro File Ver2.0  ';
  FileSignaturSize    = 32;

  PlatformStandard    = 'Standard';
  PlatformOS2         = 'OS/2';
  PlatformWin32       = 'Win32';


TYPE
  TPlatform = (pf_Standard, pf_OS2, pf_Win32);

  TCodeGen = SET OF (cg_ASMSource, cg_InlineStrings, cg_Assertions, cg_SaveConstructors);

  TSyntax = SET OF (sx_StrictVAR, sx_CompleteBoolEval);

  TOptimize = SET OF (om_OptimizeCommonSub, om_OptimizePeephole);

  TRuntimeCheck = SET OF (rc_InOut, rc_Overflow, rc_Stack, rc_Range);

  TCompilerOptions = RECORD
    CodeGen: TCodeGen;
    Syntax: TSyntax;
    Optimize: TOptimize;
    Runtime: TRuntimeCheck;
    CondDef: STRING;
  END;


  TWarnings= SET OF (w_w1,w_w2,w_w3,w_w4,w_w5,w_w6,w_w7,w_wall,w_wnone);

  TWarningOptions=RECORD
     Warnings:TWarnings;
     MaxWarnings:LongInt;
     MaxErrors:LongInt;
  END;


  TDataSegment = (ds_Normal, ds_SingleShared);

  TLinkerTarget = (lt_GUI, lt_FullScreen, lt_Window);

  TExePacking = (ep_None, ep_ExePack1, ep_ExePack2);

  TLinkerOptions = RECORD
    DataSegment: TDataSegment;
    LinkerTarget: TLinkerTarget;
    ExePacking: TExePacking;
    RunVDM: Boolean;
    CurrentLanguage:STRING;
    InstallLanguages:STRING;
  END;


  TMemorySizes = RECORD
    Heap: LONGWORD;
    Stack: LONGWORD;
  END;


  TDebugInfo = SET OF (di_LineNumbers, di_LocalSymbols);

  //Bei nderungen auch DbgHelp ndern !
CONST MaxRTLXcpts=30;
CONST RTLXcpts:ARRAY[1..MaxRtlXcpts] OF STRING [20]=
            (
             'Exception',
             'EAbort',
             'EAccessDenied',
             'EConvertError',
             'EDiskFull',
             'EDivByZero',
             'EEndOfFile',
             'EFault',
             'EFileNotFound',
             'EGPFault',
             'EInOutError',
             'EIntError',
             'EIntOverFlow',
             'EInvalidCast',
             'EInvalidFileName',
             'EInvalidHeap',
             'EInvalidInput',
             'EInvalidOp',
             'EInvalidOpCode',
             'EInvalidPointer',
             'EMathError',
             'EOutOfMemory',
             'EOverflow',
             'EPageFault',
             'EProcessorException',
             'ERangeError',
             'ETooManyOpenFiles',
             'EUnderflow',
             'EVariantError',
             'EZeroDivide'
            );

CONST MaxSPCCXcpts=22;
CONST SPCCXcpts:ARRAY[1..MaxSPCCXcpts] OF STRING [20]=
            (
             'EBitsError',
             'EDataBaseError',
             'EIniFileError',
             'EInvalidBitmap',
             'EInvalidCursor',
             'EInvalidIcon',
             'EListError',
             'EListBoxIndexError',
             'EListViewError',
             'EMemoIndexError',
             'EOutlineError',
             'EOutlineIndexError',
             'EOutlineNodeError',
             'EPrinter',
             'ESCUError',
             'ESQLError',
             'EStreamCreateError',
             'EStreamOpenError',
             'EStreamReadError',
             'EStreamSeekError',
             'EStreamWriteError',
             'EStringListError'
            );
TYPE
  TDebuggerOptions = RECORD
    Info: TDebugInfo;
    Options:LONGWORD;
    RTL_Exceptions:LONGWORD;
    SPCC_Exceptions:LONGWORD;
  END;

  TApplicationOptions=RECORD
    ApplicationIcon:String;
  END;

  TEditDir = (edOut, edLib, edLibSrc, edIncSrc, edComp);

  TDirectories = RECORD
    LastDir: STRING;
    OutDir: STRING;
    LibDir: STRING;
    LibSrcDir: STRING;
    IncSrcDir: STRING;
    CompInstallDir: STRING;
    LastEditDir: TEditDir;
  END;


  TProjectType = (pt_Visual, pt_NonVisual);

  TProjectSettings = RECORD
    ProjectName: STRING;
    Platform: TPlatform;
    ProjectType: TProjectType;
    CompOptOS2: TCompilerOptions;
    CompOptWin: TCompilerOptions;
    WarnOptOS2: TWarningOptions;
    WarnOptWin: TWarningOptions;
    LinkOptOS2: TLinkerOptions;
    LinkOptWin: TLinkerOptions;
    MemSizesOS2: TMemorySizes;
    MemSizesWin: TMemorySizes;
    DebugOptOS2: TDebuggerOptions;
    DebugOptWin: TDebuggerOptions;
    DirectoriesOS2: TDirectories;
    DirectoriesWin: TDirectories;
    ApplicationOptOS2:TApplicationOptions;
    ApplicationOptWin:TApplicationOptions;
    RunParam: STRING;
    Primary: STRING;
    SCUName: STRING;
    MainForm: STRING;
    CompLibNameOS2: STRING;
    CompLibNameWin: STRING;
    InActiveLanguages: STRING;
    CurrentLanguage: STRING;
  END;


  TUnsortedAsciiIniFile = CLASS(TAsciiIniFile)
    PROTECTED
       PROCEDURE InitIniFile;OVERRIDE;
  END;



CONST
  TopToolbarSize = 63;
  StatusbarSize = 25;
  SpeedButtonSize = 26;
  NavigatorButtonSize = 28;

VAR
  ProjectBaseDir:STRING;

PROCEDURE ExpandProjectFile(VAR FName:STRING);
FUNCTION CutProjectFile(CONST FName:STRING):STRING;
FUNCTION FExpand(Path:STRING):STRING;
FUNCTION FExpandProject(Path:STRING):STRING;
FUNCTION ReplaceEnvStrings(CONST Path:STRING):STRING;
FUNCTION ProjectPrimary(CONST Settings:TProjectSettings):STRING;
FUNCTION ProjectOutDir(CONST Settings:TProjectSettings):STRING;
FUNCTION ProjectLibDir(CONST Settings:TProjectSettings):STRING;
FUNCTION ProjectLibSrcDir(CONST Settings:TProjectSettings):STRING;
FUNCTION ProjectIncSrcDir(CONST Settings:TProjectSettings):STRING;
FUNCTION ProjectCompInstallDir(CONST Settings:TProjectSettings):STRING;
FUNCTION ProjectSCUName(CONST Settings:TProjectSettings):STRING;

PROCEDURE InitializeProject(VAR Settings:TProjectSettings);
FUNCTION ReadProject(VAR Settings:TProjectSettings;CONST FileName:STRING):BOOLEAN;
FUNCTION WriteProject(VAR Settings:TProjectSettings;CONST FileName:STRING):BOOLEAN;

FUNCTION IsFlag(s,test:STRING):BOOLEAN;
PROCEDURE AddFlag(VAR s:STRING;CONST flag:STRING);
FUNCTION GetCompilerOptions(CONST Settings:TProjectSettings):STRING;
FUNCTION GetCompilerDefines(CONST Settings:TProjectSettings):STRING;


CONST
  InitCodeEditorProc: POINTER = NIL;
  InitInspectorProc: POINTER = NIL;
  InitCompListProc: POINTER = NIL;
  InitWindowListProc: POINTER = NIL;
  InitBrowserProc: POINTER = NIL;
  InitMacroListProc: POINTER = NIL;
  InitClipboardListProc: POINTER = NIL;
  InitCPUWindowProc: POINTER = NIL;
  InitProjectManagerProc: POINTER = NIL;


IMPLEMENTATION

Uses Dialogs; // for expandpath (AaronL)
   Uses Log; //AaronL

PROCEDURE ExpandProjectFile(VAR FName:STRING);
VAR  s1:STRING;
     len:LONGINT;
BEGIN
  IF pos('.\',FName) = 1 THEN
  BEGIN
    delete(FName,1,2);
    FName := ProjectBaseDir + FName;
    exit;
  END;

  IF pos('..\',FName) <> 1 THEN exit;

  {gemeinsame Basis ersetzen}
  s1 := ProjectBaseDir;
  WHILE pos('..\',FName) = 1 DO
  BEGIN
     len := Length(s1)-1;
     WHILE (len > 3) AND (s1[len] <> '\') DO dec(len);
     SetLength(s1,len);
     delete(FName,1,3);
  END;
  IF pos('.\',FName) = 1 THEN delete(FName,1,2);

  FName := s1 + FName;
END;


FUNCTION CutProjectFile(CONST FName:STRING):STRING;
VAR  s,s1:STRING;
     maxbase,len,p,i:LONGINT;
BEGIN
  Result := FName;
  s := FName;
  UpcaseStr(s);
  IF pos(ProjectBaseDir,s) = 1 THEN
  BEGIN
    delete(Result,1,Length(ProjectBaseDir));
    Result := '.\' + Result;
    exit;
  END;

  {finde gemeinsame Basis}
  maxbase := 0;
  len := Length(ProjectBaseDir);
  IF Length(FName) < len THEN len := Length(FName);

  FOR i := 1 TO len DO
  BEGIN
    IF ProjectBaseDir[i] = s[i] THEN inc(maxbase)
    ELSE break;
  END;
  {gehe bis zu letzten Backslash zurck}
  WHILE (maxbase > 0) AND (ProjectBaseDir[maxbase] <> '\') DO dec(maxbase);

  IF maxbase = 0 THEN exit;   {keine gemeinsame Basis}

  delete(Result,1,maxbase);
  Result := '.\' + Result;

  s1 := ProjectBaseDir;
  delete(s1,1,maxbase);

  p := pos('\',s1);
  WHILE p > 0 DO
  BEGIN
    delete(s1,1,p);
    Result := '..\' + Result;
    p := pos('\',s1);
  END;
END;


FUNCTION FExpandProject(Path:STRING):STRING;
var
   projDir :  string;
BEGIN
  Result := '';
  IF Path = '' THEN exit;
  Path := ReplaceEnvStrings(Path);
  IF Path = '' THEN exit;
  //relative Pfade sind relativ zum SPR File
  IF ProjectBaseDir <> '' THEN
  begin
     projdir:= ProjectBaseDir;
     if projdir[ length( projdir ) ] = '\' then
        delete( projdir, length( projdir ), 1 );

    Result := ExpandPath(Path, projdir)
  end
  ELSE
    Result := DOS.FExpand(Path);   
END;


FUNCTION FExpand(Path:STRING):STRING;
BEGIN
  Result := '';
  IF Path = '' THEN exit;
  Path := ReplaceEnvStrings(Path);
  IF Path = '' THEN exit;
  //relative Pfade sind relativ zum aktuellen Verzeichnis
  Result := DOS.FExpand(Path);
END;


FUNCTION ReplaceEnvStrings(CONST Path:STRING):STRING;
VAR
  p,i,c:INTEGER;
  env:STRING;
BEGIN
  Result := Path;
  {ersetze %Environment% Variable}
  WHILE pos('%',Result) > 0 DO
  BEGIN
    p := pos('%',Result);
    c := 0;
    env := '';
    FOR i := p+1 TO Length(Result) DO
      IF Result[i] = '%' THEN
      BEGIN
        env := copy(Result,p+1,c);
        break;
      END
      ELSE inc(c);

    IF env = '' THEN break; {kein Endezeichen gefunden}

    UpcaseStr(env);
    env := GetEnv(env);
    IF env <> '' THEN
    BEGIN
         {markiere % im EnvStr}
         FOR i := 1 TO Length(env) DO
           IF env[i] = '%' THEN env[i] := chr(255);

         delete(Result,p,c+2);  {2x %}
         insert(env,Result,p)
    END
    ELSE Result[p] := chr(255);   {markieren}
  END;

  FOR i := 1 TO Length(Result) DO
    IF ord(Result[i]) = 255 THEN Result[i] := '%';
END;


FUNCTION ProjectPrimary(CONST Settings:TProjectSettings):STRING;
BEGIN
  Result := FExpandProject(Settings.Primary);
END;

FUNCTION ProjectOutDir(CONST Settings:TProjectSettings):STRING;
BEGIN
   LogStr( 'ProjectOutDir' );
  Case Settings.Platform Of
     pf_Standard:
     Begin
          {$IFDEF OS2}
          Result := FExpandProject(Settings.DirectoriesOS2.OutDir);
          {$ENDIF}
          {$IFDEF WIN32}
          Result := FExpandProject(Settings.DirectoriesWin.OutDir);
          {$ENDIF}
     End;
     pf_OS2:Result := FExpandProject(Settings.DirectoriesOS2.OutDir);
     pf_Win32:Result := FExpandProject(Settings.DirectoriesWin.OutDir);
  End; //case
   LogStr( '  Result= '+ Result );
END;

FUNCTION ProjectLibDir(CONST Settings:TProjectSettings):STRING;
BEGIN
  Case Settings.Platform Of
     pf_Standard:
     Begin
          {$IFDEF OS2}
          Result := FExpandProject(Settings.DirectoriesOS2.LibDir);
          {$ENDIF}
          {$IFDEF WIN32}
          Result := FExpandProject(Settings.DirectoriesWin.LibDir);
          {$ENDIF}
     End;
     pf_OS2:Result := FExpandProject(Settings.DirectoriesOS2.LibDir);
     pf_Win32:Result := FExpandProject(Settings.DirectoriesWin.LibDir);
  End; //case

END;

FUNCTION ProjectLibSrcDir(CONST Settings:TProjectSettings):STRING;
BEGIN
  Case Settings.Platform Of
     pf_Standard:
     Begin
          {$IFDEF OS2}
          Result := FExpandProject(Settings.DirectoriesOS2.LibSrcDir);
          {$ENDIF}
          {$IFDEF WIN32}
          Result := FExpandProject(Settings.DirectoriesWin.LibSrcDir);
          {$ENDIF}
     End;
     pf_OS2:Result := FExpandProject(Settings.DirectoriesOS2.LibSrcDir);
     pf_Win32:Result := FExpandProject(Settings.DirectoriesWin.LibSrcDir);
  End; //case

END;

FUNCTION ProjectIncSrcDir(CONST Settings:TProjectSettings):STRING;
BEGIN
  Case Settings.Platform Of
     pf_Standard:
     Begin
          {$IFDEF OS2}
          Result := FExpandProject(Settings.DirectoriesOS2.IncSrcDir);
          {$ENDIF}
          {$IFDEF WIN32}
          Result := FExpandProject(Settings.DirectoriesWin.IncSrcDir);
          {$ENDIF}
     End;
     pf_OS2:Result := FExpandProject(Settings.DirectoriesOS2.IncSrcDir);
     pf_Win32:Result := FExpandProject(Settings.DirectoriesWin.IncSrcDir);
  End; //case

END;

FUNCTION ProjectCompInstallDir(CONST Settings:TProjectSettings):STRING;
BEGIN
  Case Settings.Platform Of
     pf_Standard:
     Begin
          {$IFDEF OS2}
          Result := FExpandProject(Settings.DirectoriesOS2.CompInstallDir);
          {$ENDIF}
          {$IFDEF WIN32}
          Result := FExpandProject(Settings.DirectoriesWin.CompInstallDir);
          {$ENDIF}
     End;
     pf_OS2:Result := FExpandProject(Settings.DirectoriesOS2.CompInstallDir);
     pf_Win32:Result := FExpandProject(Settings.DirectoriesWin.CompInstallDir);
  End; //case

END;

FUNCTION ProjectSCUName(CONST Settings:TProjectSettings):STRING;
BEGIN
  Result := FExpandProject(Settings.SCUName);
END;


{fill Settings with hard coded values}
PROCEDURE InitializeProject(VAR Settings:TProjectSettings);
VAR t:LONGWORD;
BEGIN
  FillChar(Settings,SizeOf(Settings),0);

  Settings.ProjectName := '';
  Settings.ProjectType := pt_Visual;
  Settings.Platform:=pf_Standard;

  Settings.CompOptOS2.Codegen := [cg_Assertions];
  Settings.CompOptOS2.Syntax := [];
  Settings.CompOptOS2.Optimize := [om_OptimizeCommonSub,om_OptimizePeephole];
  Settings.CompOptOS2.Runtime := [];
  Settings.CompOptOS2.CondDef := '';
  Settings.CompOptWin:=Settings.CompOptOS2;

  Settings.ApplicationOptOS2.ApplicationIcon:='';
  Settings.ApplicationOptWin:=Settings.ApplicationOptOS2;

  Settings.WarnOptOS2.Warnings:=[w_w2,w_w3,w_w4,w_w5,w_w6,w_w7];
  Settings.WarnOptOS2.MaxWarnings:=200;
  Settings.WarnOptOS2.MaxErrors:=10;
  Settings.WarnOptWin:=Settings.WarnOptOS2;

  Settings.LinkOptOS2.DataSegment := ds_Normal;
  Settings.LinkOptOS2.LinkerTarget := lt_GUI;
  Settings.LinkOptOS2.ExePacking := ep_ExePack2;
  Settings.LinkOptOS2.RunVDM := TRUE;
  Settings.LinkOptOS2.CurrentLanguage:='Default';
  Settings.LinkOptOS2.InstallLanguages:='';
  Settings.LinkOptWin:=Settings.LinkOptOS2;

  Settings.MemSizesOS2.Heap := 8192; {kByte}
  Settings.MemSizesOS2.Stack := 256; {kByte}
  Settings.MemSizesWin:=Settings.MemSizesOS2;

  Settings.DebugOptOS2.Info := [di_LineNumbers, di_LocalSymbols];
  Settings.DebugOptOS2.Options:=0;
  //Turn on all RTL exceptions
  Settings.DebugOptOS2.RTL_Exceptions:=0;
  FOR t:=1 TO MaxRTLXcpts DO Settings.DebugOptOS2.RTL_Exceptions:=Settings.DebugOptOS2.RTL_Exceptions OR 1 SHL (t-1);
  //Turn on all SPCC exceptions
  Settings.DebugOptOS2.SPCC_Exceptions:=0;
  FOR t:=1 TO MaxSPCCXcpts DO Settings.DebugOptOS2.SPCC_Exceptions:=Settings.DebugOptOS2.SPCC_Exceptions OR 1 SHL (t-1);
  Settings.DebugOptWin:=Settings.DebugOptOS2;

  Settings.DirectoriesOS2.LastDir := '';
  Settings.DirectoriesOS2.OutDir := '';
  Settings.DirectoriesOS2.LibDir := '';
  Settings.DirectoriesOS2.LibSrcDir := '';
  Settings.DirectoriesOS2.IncSrcDir := '';
  Settings.DirectoriesOS2.CompInstallDir := '';
  Settings.DirectoriesOS2.LastEditDir := edOut;
  Settings.DirectoriesWin:=Settings.DirectoriesOS2;

  Settings.RunParam := '';
  Settings.Primary := '';
  Settings.SCUName := '';
  Settings.MainForm := '';
  Settings.CompLibNameOS2 := '';  {wird spter upgedated}
  Settings.CompLibNameWin := '';  {wird spter upgedated}
  Settings.InActiveLanguages:='';
  Settings.CurrentLanguage:='';
END;


PROCEDURE TUnsortedAsciiIniFile.InitIniFile;
BEGIN
  SectionSort := TRUE;
  IdentSort := FALSE;
END;


FUNCTION IsFlag(s,test:STRING):BOOLEAN;
CONST
  NoSeparators = ['0'..'9','A'..'Z','_','','','”','','','','แ'];
VAR
  p:INTEGER;
BEGIN
  Result := FALSE;
  UpcaseStr(s);
  UpcaseStr(test);
  p := pos(test,s);
  IF p = 0 THEN exit;
  {Test Separator}
  IF p > 1 THEN
    IF s[p-1] IN NoSeparators THEN exit;
  IF p + Length(test) <= Length(s) THEN
    IF s[p+Length(test)] IN NoSeparators THEN exit;
  Result := TRUE;
END;


FUNCTION ReadProject(VAR Settings:TProjectSettings;CONST FileName:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  Section:STRING;
  Version:STRING;
  s:STRING;

  PROCEDURE ReadCompOpt(VAR CompOpt:TCompilerOptions;Const Section:String);
  Var
     s:STRING;
  BEGIN
       WITH CompOpt DO
       BEGIN
         s := ini.ReadString(Section,'CodeGeneration','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'ASMSource') THEN Include(CodeGen,cg_ASMSource)
           ELSE Exclude(CodeGen,cg_ASMSource);
           IF IsFlag(s,'InlineStrings') THEN Include(CodeGen,cg_InlineStrings)
           ELSE Exclude(CodeGen,cg_InlineStrings);
           IF IsFlag(s,'Assertions') THEN Include(CodeGen,cg_Assertions)
           ELSE Exclude(CodeGen,cg_Assertions);
           IF IsFlag(s,'SaveConstructors') THEN Include(CodeGen,cg_SaveConstructors)
           ELSE Exclude(CodeGen,cg_SaveConstructors);
         END;

         s := ini.ReadString(Section,'Syntax','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'StrictVAR') THEN Include(Syntax,sx_StrictVAR)
           ELSE Exclude(Syntax,sx_StrictVAR);
           IF IsFlag(s,'CompleteBoolEval') THEN Include(Syntax,sx_CompleteBoolEval)
           ELSE Exclude(Syntax,sx_CompleteBoolEval);
         END;

         s := ini.ReadString(Section,'Optimize','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'OptimizeCommonSub') THEN Include(Optimize,om_OptimizeCommonSub)
           ELSE Exclude(Optimize,om_OptimizeCommonSub);
           IF IsFlag(s,'OptimizePeephole') THEN Include(Optimize,om_OptimizePeephole)
           ELSE Exclude(Optimize,om_OptimizePeephole);
         END;

         s := ini.ReadString(Section,'RuntimeCheck','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'InOut') THEN Include(Runtime,rc_InOut)
           ELSE Exclude(Runtime,rc_InOut);
           IF IsFlag(s,'Overflow') THEN Include(Runtime,rc_Overflow)
           ELSE Exclude(Runtime,rc_Overflow);
           IF IsFlag(s,'Stack') THEN Include(Runtime,rc_Stack)
           ELSE Exclude(Runtime,rc_Stack);
           IF IsFlag(s,'Range') THEN Include(Runtime,rc_Range)
           ELSE Exclude(Runtime,rc_Range);
         END;

         CondDef := ini.ReadString(Section,'CondDefine',CondDef);
       END;
  END;

  PROCEDURE ReadWarnOpt(VAR WarnOpt:TWarningOptions;Const Section:String);
  VAR s:STRING;
  BEGIN
       WITH WarnOpt DO
       BEGIN
         s := ini.ReadString(Section,'Warnings','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'W1') THEN Include(Warnings,W_W1)
           ELSE Exclude(Warnings,W_W1);
           IF IsFlag(s,'W2') THEN Include(Warnings,W_W2)
           ELSE Exclude(Warnings,W_W2);
           IF IsFlag(s,'W3') THEN Include(Warnings,W_W3)
           ELSE Exclude(Warnings,W_W3);
           IF IsFlag(s,'W4') THEN Include(Warnings,W_W4)
           ELSE Exclude(Warnings,W_W4);
           IF IsFlag(s,'W5') THEN Include(Warnings,W_W5)
           ELSE Exclude(Warnings,W_W5);
           IF IsFlag(s,'W6') THEN Include(Warnings,W_W6)
           ELSE Exclude(Warnings,W_W6);
           IF IsFlag(s,'W7') THEN Include(Warnings,W_W7)
           ELSE Exclude(Warnings,W_W7);
           IF IsFlag(s,'WAll') THEN Include(Warnings,W_WAll)
           ELSE Exclude(Warnings,W_WAll);
           IF IsFlag(s,'WNone') THEN Include(Warnings,W_WNone)
           ELSE Exclude(Warnings,W_WNone);
         END;

         MaxWarnings:=ini.ReadInteger(Section,'MaxWarnings',MaxWarnings);
         MaxErrors:=ini.ReadInteger(Section,'MaxErrors',MaxErrors);
       END;
  END;

  PROCEDURE ReadLinkOpt(VAR LinkOpt:TLinkerOptions;Const Section:String);
  VAR s:STRING;
  BEGIN
       WITH LinkOpt DO
       BEGIN
         s := ini.ReadString(Section,'DataSegment','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'Normal') THEN DataSegment := ds_Normal;
           IF IsFlag(s,'SingleShared') THEN DataSegment := ds_SingleShared;
         END;

         s := ini.ReadString(Section,'LinkerTarget','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'GUI') THEN LinkerTarget := lt_GUI;
           IF IsFlag(s,'FullScreen') THEN LinkerTarget := lt_FullScreen;
           IF IsFlag(s,'Window') THEN LinkerTarget := lt_Window;
         END;

         s := ini.ReadString(Section,'ExePacking','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'None') THEN ExePacking := ep_None;
           IF IsFlag(s,'ExePack1') THEN ExePacking := ep_ExePack1;
           IF IsFlag(s,'ExePack2') THEN ExePacking := ep_ExePack2;
         END;

         RunVDM := ini.ReadBool(Section,'RunVDM',RunVDM);

         CurrentLanguage := ini.ReadString(Section,'CurrentLanguage',CurrentLanguage);
         InstallLanguages := ini.ReadString(Section,'InstallLanguages',InstallLanguages);
       END;

  END;

  PROCEDURE ReadDebugOpt(Var DebugOpt:TDebuggerOptions;Const Section:String);
  VAR s:String;
  BEGIN
       WITH DebugOpt DO
       BEGIN
         s := ini.ReadString(Section,'DebugInfo','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'LineNumbers') THEN Include(Info,di_LineNumbers)
           ELSE Exclude(Info,di_LineNumbers);
           IF IsFlag(s,'LocalSymbols') THEN Include(Info,di_LocalSymbols)
           ELSE Exclude(Info,di_LocalSymbols);
         END;

         Options := ini.ReadInteger(Section,'Dbg_Options',Options);

         RTL_Exceptions := ini.ReadInteger(Section,'RTL_Exceptions',RTL_Exceptions);
         SPCC_Exceptions := ini.ReadInteger(Section,'SPCC_Exceptions',SPCC_Exceptions);
       END;
  END;

  PROCEDURE ReadDirectories(VAR Directories:TDirectories;Const Section:String);
  BEGIN
       WITH Directories DO
       BEGIN
         LastDir := ini.ReadString(Section,'LastDir',LastDir);
         OutDir := ini.ReadString(Section,'OutDir',OutDir);
         LibDir := ini.ReadString(Section,'LibDir',LibDir);
         LibSrcDir := ini.ReadString(Section,'LibSrcDir',LibSrcDir);
         IncSrcDir := ini.ReadString(Section,'IncSrcDir',IncSrcDir);
         CompInstallDir := ini.ReadString(Section,'CompInstallDir',CompInstallDir);
   (*
         s := ini.ReadString(Section,'LastEditDir','?');
         IF s <> '?' THEN
         BEGIN
           IF IsFlag(s,'edOut') THEN LastEditDir := edOut;
           IF IsFlag(s,'edLib') THEN LastEditDir := edLib;
           IF IsFlag(s,'edLibSrc') THEN LastEditDir := edLibSrc;
           IF IsFlag(s,'edIncSrc') THEN LastEditDir := edIncSrc;
           IF IsFlag(s,'edComp') THEN LastEditDir := edComp;
         END;
   *)
       END;
  END;

BEGIN
  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    {Section General}
    Section := 'General';
    WITH Settings DO
    BEGIN
      Version := ini.ReadString(Section,'Version',ProjectVersion);
      ProjectName := ini.ReadString(Section,'ProjectName',ProjectName);
      UpcaseStr(ProjectName);

      s := ini.ReadString(Section,'ProjectType','?');
      IF s <> '?' THEN
      BEGIN
        IF IsFlag(s,'Visual') THEN ProjectType := pt_Visual;
        IF IsFlag(s,'NonVisual') THEN ProjectType := pt_NonVisual;
      END;

      RunParam := ini.ReadString(Section,'RunParameter',RunParam);
      InActiveLanguages := ini.ReadString(Section,'InActiveLanguages',InActiveLanguages);
      CurrentLanguage := ini.ReadString(Section,'CurrentLanguage',CurrentLanguage);
      s := ini.ReadString(Section,'Platform','?');
      IF s <> '?' THEN
      BEGIN
           IF IsFlag(s,PlatformStandard) THEN Platform := pf_Standard;
           IF IsFlag(s,PlatformOS2) THEN Platform := pf_OS2;
           IF IsFlag(s,PlatformWin32) THEN Platform := pf_Win32;
      END
      Else Platform:=pf_Standard;
    END;

    {Section Component Library}
    IF Version = ProjectVersion202 THEN
    BEGIN
         {Filenames in section "General"}
         Section := 'General';
         WITH Settings DO
         BEGIN
           CompLibNameOS2 := ini.ReadString(Section,'CompLibName',CompLibNameOS2);
           ExpandProjectFile(CompLibNameOS2);
         End;

         Section := 'Win32 Component Library';
         WITH Settings DO
         BEGIN
           CompLibNameWin := ini.ReadString(Section,'Win32CompLibName',CompLibNameWin);
           ExpandProjectFile(CompLibNameWin);
         END;
    END
    ELSE
    BEGIN
         Section := 'Component Library';
         WITH Settings DO
         BEGIN
           CompLibNameOS2 := ini.ReadString(Section,'CompLibName',CompLibNameOS2);
           ExpandProjectFile(CompLibNameOS2);
         End;

         Section := 'Win32 Component Library';
         WITH Settings DO
         BEGIN
           CompLibNameWin := ini.ReadString(Section,'CompLibName',CompLibNameWin);
           ExpandProjectFile(CompLibNameWin);
         END;
    END;

    {Section SCU}
    Section := 'SCU';
    WITH Settings DO
    BEGIN
      SCUName := ini.ReadString(Section,'SCUName',SCUName);
      ExpandProjectFile(SCUName);
      MainForm := ini.ReadString(Section,'MainForm',MainForm);
    END;

    {Section Project Files}
    Section := 'Project Files';
    WITH Settings DO
    BEGIN
      Primary := ini.ReadString(Section,'Primary',Primary);
      ExpandProjectFile(Primary);
    END;

    {Section Compiler Options}
    ReadCompOpt(Settings.CompOptOS2,'Compiler Options');
    Settings.CompOptWin:=Settings.CompOptOS2;
    ReadCompOpt(Settings.CompOptWin,'Win32 Compiler Options');

    {Section Application Options}
    Section := 'Application Options';
    WITH Settings.ApplicationOptOS2 DO
    BEGIN
      s := ini.ReadString(Section,'ApplicationIcon','?');
      IF s <> '?' THEN ApplicationIcon:=s;
    END;
    Settings.ApplicationOptWin:=Settings.ApplicationOptOS2;

    Section := 'Win32 Application Options';
    WITH Settings.ApplicationOptWin DO
    BEGIN
      s := ini.ReadString(Section,'ApplicationIcon','?');
      IF s <> '?' THEN ApplicationIcon:=s;
    END;


    {Section Compiler Warnings}
    ReadWarnOpt(Settings.WarnOptOS2,'Compiler Warnings');
    Settings.WarnOptWin:=Settings.WarnOptOS2;
    ReadWarnOpt(Settings.WarnOptWin,'Win32 Compiler Warnings');

    {Section Linker Options}
    ReadLinkOpt(Settings.LinkOptOS2,'Linker Options');
    Settings.LinkOptWin:=Settings.LinkOptOS2;
    ReadLinkOpt(Settings.LinkOptWin,'Win32 Linker Options');

    {Section Memory Sizes}
    Section := 'Memory Sizes';
    WITH Settings.MemSizesOS2 DO
    BEGIN
      Heap := ini.ReadInteger(Section,'Heap',Heap);
      Stack := ini.ReadInteger(Section,'Stack',Stack);
    END;
    Settings.MemSizesWin:=Settings.MemSizesOS2;

    Section := 'Win32 Memory Sizes';
    WITH Settings.MemSizesWin DO
    BEGIN
      Heap := ini.ReadInteger(Section,'Heap',Heap);
      Stack := ini.ReadInteger(Section,'Stack',Stack);
    END;

    {Section Debugger Options}
    ReadDebugOpt(Settings.DebugOptOS2,'Debugger Options');
    Settings.DebugOptWin:=Settings.DebugOptOS2;
    ReadDebugOpt(Settings.DebugOptWin,'Win32 Debugger Options');

    {Section Directories}
    ReadDirectories(Settings.DirectoriesOS2,'Directories');
    Settings.DirectoriesWin:=Settings.DirectoriesOS2;
    ReadDirectories(Settings.DirectoriesWin,'Win32 Directories');

    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
END;


PROCEDURE AddFlag(VAR s:STRING;CONST flag:STRING);
BEGIN
     IF s = '' THEN s := flag
     ELSE s := s + ',' + flag;
END;


FUNCTION WriteProject(VAR Settings:TProjectSettings;CONST FileName:STRING):BOOLEAN;
VAR
  ini:TUnsortedAsciiIniFile;
  Section:STRING;

  PROCEDURE WriteCompOpt(VAR CompOpt:TCompilerOptions;Const Section:STRING);
  VAR s:STRING;
  BEGIN
       ini.EraseSection(Section);
       WITH CompOpt DO
       BEGIN
         s := '';
         IF CodeGen * [cg_ASMSource] <> [] THEN AddFlag(s,'ASMSource');
         IF CodeGen * [cg_InlineStrings] <> [] THEN AddFlag(s,'InlineStrings');
         IF CodeGen * [cg_Assertions] <> [] THEN AddFlag(s,'Assertions');
         IF CodeGen * [cg_SaveConstructors] <> [] THEN AddFlag(s,'SaveConstructors');
         ini.WriteString(Section,'CodeGeneration',s);

         s := '';
         IF Syntax * [sx_StrictVAR] <> [] THEN AddFlag(s,'StrictVAR');
         IF Syntax * [sx_CompleteBoolEval] <> [] THEN AddFlag(s,'CompleteBoolEval');
         ini.WriteString(Section,'Syntax',s);

         s := '';
         IF Optimize * [om_OptimizeCommonSub] <> [] THEN AddFlag(s,'OptimizeCommonSub');
         IF Optimize * [om_OptimizePeephole] <> [] THEN AddFlag(s,'OptimizePeephole');
         ini.WriteString(Section,'Optimize',s);

         s := '';
         IF Runtime * [rc_InOut] <> [] THEN AddFlag(s,'InOut');
         IF Runtime * [rc_Overflow] <> [] THEN AddFlag(s,'Overflow');
         IF Runtime * [rc_Stack] <> [] THEN AddFlag(s,'Stack');
         IF Runtime * [rc_Range] <> [] THEN AddFlag(s,'Range');
         ini.WriteString(Section,'RuntimeCheck',s);

         ini.WriteString(Section,'CondDefine',CondDef);
       END;
  END;

  PROCEDURE WriteWarnOpt(Var WarnOpt:TWarningOptions;Const Section:STRING);
  VAR s:STRING;
  BEGIN
       ini.EraseSection(Section);
       WITH WarnOpt DO
       BEGIN
         s := '';
         IF Warnings * [W_W1] <> [] THEN AddFlag(s,'W1');
         IF Warnings * [W_W2] <> [] THEN AddFlag(s,'W2');
         IF Warnings * [W_W3] <> [] THEN AddFlag(s,'W3');
         IF Warnings * [W_W4] <> [] THEN AddFlag(s,'W4');
         IF Warnings * [W_W5] <> [] THEN AddFlag(s,'W5');
         IF Warnings * [W_W6] <> [] THEN AddFlag(s,'W6');
         IF Warnings * [W_W7] <> [] THEN AddFlag(s,'W7');
         IF Warnings * [W_WAll] <> [] THEN AddFlag(s,'WAll');
         IF Warnings * [W_WNone] <> [] THEN AddFlag(s,'WNone');
         ini.WriteString(Section,'Warnings',s);

         ini.WriteInteger(Section,'MaxWarnings',MaxWarnings);
         ini.WriteInteger(Section,'MaxErrors',MaxErrors);
       END;
  END;

  PROCEDURE WriteLinkOpt(VAR LinkOpt:TLinkerOptions;Const Section:STRING);
  BEGIN
       ini.EraseSection(Section);
       WITH LinkOpt DO
       BEGIN
         CASE DataSegment OF
           ds_Normal:       ini.WriteString(Section,'DataSegment','Normal');
           ds_SingleShared: ini.WriteString(Section,'DataSegment','SingleShared');
         END;

         CASE LinkerTarget OF
           lt_GUI:        ini.WriteString(Section,'LinkerTarget','GUI');
           lt_FullScreen: ini.WriteString(Section,'LinkerTarget','FullScreen');
           lt_Window:     ini.WriteString(Section,'LinkerTarget','Window');
         END;

         CASE ExePacking OF
           ep_None:     ini.WriteString(Section,'ExePacking','None');
           ep_ExePack1: ini.WriteString(Section,'ExePacking','ExePack1');
           ep_ExePack2: ini.WriteString(Section,'ExePacking','ExePack2');
         END;

         ini.WriteBool(Section,'RunVDM',RunVDM);

         ini.WriteString(Section,'CurrentLanguage',CurrentLanguage);
         ini.WriteString(Section,'InstallLanguages',InstallLanguages);
       END;
  END;

  PROCEDURE WriteDebugOpt(VAR DebugOpt:TDebuggerOptions;Const Section:STRING);
  VAR s:STRING;
  BEGIN
       ini.EraseSection(Section);
       WITH DebugOpt DO
       BEGIN
         s := '';
         IF Info * [di_LineNumbers] <> [] THEN AddFlag(s,'LineNumbers');
         IF Info * [di_LocalSymbols] <> [] THEN AddFlag(s,'LocalSymbols');
         ini.WriteString(Section,'DebugInfo',s);

         ini.WriteInteger(Section,'Dbg_Options',Options);

         ini.WriteInteger(Section,'RTL_Exceptions',RTL_Exceptions);
         ini.WriteInteger(Section,'SPCC_Exceptions',SPCC_Exceptions);
       END;
  END;

  PROCEDURE WriteDirectories(VAR Directories:TDirectories;Const Section:STRING);
  BEGIN
       ini.EraseSection(Section);
       WITH Directories DO
       BEGIN
         ini.WriteString(Section,'LastDir',LastDir);
         ini.WriteString(Section,'OutDir',OutDir);
         ini.WriteString(Section,'LibDir',LibDir);
         ini.WriteString(Section,'LibSrcDir',LibSrcDir);
         ini.WriteString(Section,'IncSrcDir',IncSrcDir);
         ini.WriteString(Section,'CompInstallDir',CompInstallDir);
   (*
         CASE LastEditDir OF
           edOut:    ini.WriteString(Section,'LastEditDir','edOut');
           edLib:    ini.WriteString(Section,'LastEditDir','edLib');
           edLibSrc: ini.WriteString(Section,'LastEditDir','edLibSrc');
           edIncSrc: ini.WriteString(Section,'LastEditDir','edIncSrc');
           edComp:   ini.WriteString(Section,'LastEditDir','edComp');
         END;
   *)
       END;
  END;

BEGIN
  Result := FALSE;
  TRY
    ini := NIL;
    ini := TUnsortedAsciiIniFile.Create(FileName);

    {Section General}
    Section := 'General';
    ini.EraseSection(Section);
    ini.WriteString(Section,'Version',ProjectVersion);
    WITH Settings DO
    BEGIN
      ini.WriteString(Section,'ProjectName',ProjectName);
      CASE ProjectType OF
        pt_Visual:    ini.WriteString(Section,'ProjectType','Visual');
        pt_NonVisual: ini.WriteString(Section,'ProjectType','NonVisual');
      END;
      ini.WriteString(Section,'RunParameter',RunParam);
      ini.WriteString(Section,'InActiveLanguages',InActiveLanguages);
      ini.WriteString(Section,'CurrentLanguage',CurrentLanguage);
      CASE Platform OF
           pf_Standard: ini.WriteString(Section,'Platform',PlatformStandard);
           pf_OS2:      ini.WriteString(Section,'Platform',PlatformOS2);
           pf_Win32:    ini.WriteString(Section,'Platform',PlatformWin32);
      END;
    END;

    Section := 'Component Library';
    ini.EraseSection(Section);
    WITH Settings DO
    BEGIN
      ini.WriteString(Section,'CompLibName',CutProjectFile(CompLibNameOS2));
    END;

    Section := 'Win32 Component Library';
    ini.EraseSection(Section);
    WITH Settings DO
    BEGIN
      ini.WriteString(Section,'CompLibName',CutProjectFile(CompLibNameWin));
    END;

    {Section SCU}
    Section := 'SCU';
    ini.EraseSection(Section);
    WITH Settings DO
    BEGIN
      ini.WriteString(Section,'SCUName',CutProjectFile(SCUName));
      ini.WriteString(Section,'MainForm',MainForm);
    END;

    {Section Project Files}
    Section := 'Project Files';
    ini.EraseSection(Section);
    WITH Settings DO
    BEGIN
      ini.WriteString(Section,'Primary',CutProjectFile(Primary));
    END;

    {Section Compiler Options}
    WriteCompOpt(Settings.CompOptOS2,'Compiler Options');
    WriteCompOpt(Settings.CompOptWin,'Win32 Compiler Options');

    {Section Application Options}
    Section := 'Application Options';
    ini.EraseSection(Section);
    WITH Settings.ApplicationOptOS2 DO
    BEGIN
        ini.WriteString(Section,'ApplicationIcon',ApplicationIcon);
    END;

    {Section Application Options}
    Section := 'Win32 Application Options';
    ini.EraseSection(Section);
    WITH Settings.ApplicationOptWin DO
    BEGIN
        ini.WriteString(Section,'ApplicationIcon',ApplicationIcon);
    END;


    {Section Compiler Warnings}
    WriteWarnOpt(Settings.WarnOptOS2,'Compiler Warnings');
    WriteWarnOpt(Settings.WarnOptWin,'Win32 Compiler Warnings');

    {Section Linker Options}
    WriteLinkOpt(Settings.LinkOptOS2,'Linker Options');
    WriteLinkOpt(Settings.LinkOptWin,'Win32 Linker Options');

    {Section Memory Sizes}
    Section := 'Memory Sizes';
    ini.EraseSection(Section);
    WITH Settings.MemSizesOS2 DO
    BEGIN
      ini.WriteInteger(Section,'Heap',Heap);
      ini.WriteInteger(Section,'Stack',Stack);
    END;

    {Section Memory Sizes}
    Section := 'Win32 Memory Sizes';
    ini.EraseSection(Section);
    WITH Settings.MemSizesWin DO
    BEGIN
      ini.WriteInteger(Section,'Heap',Heap);
      ini.WriteInteger(Section,'Stack',Stack);
    END;


    {Section Debugger Options}
    WriteDebugOpt(Settings.DebugOptOS2,'Debugger Options');
    WriteDebugOpt(Settings.DebugOptWin,'Win32 Debugger Options');

    {Section Directories}
    WriteDirectories(Settings.DirectoriesOS2,'Directories');
    WriteDirectories(Settings.DirectoriesWin,'Win32 Directories');

    ini.Refresh;
    Result := TRUE;
    ini.Destroy;
  EXCEPT
    IF ini <> NIL THEN ini.Destroy;
  END;
END;



FUNCTION GetCompilerOptions(CONST Settings:TProjectSettings):STRING;
VAR CompOpt:TCompilerOptions;
    WarnOpt:TWarningOptions;
    LinkOpt:TLinkerOptions;
    DebugOpt:TDebuggerOptions;
    MemSizes:TMemorySizes;
Label OS2,Win;
BEGIN
  Case Settings.Platform Of
     pf_Standard:
     Begin
          {$IFDEF OS2}
          goto OS2;
          {$ENDIF}
          {$IFDEF WIN32}
          goto Win;
          {$ENDIF}
     End;
     pf_OS2:
     Begin
OS2:
          CompOpt:=Settings.CompOptOS2;
          WarnOpt:=Settings.WarnOptOS2;
          LinkOpt:=Settings.LinkOptOS2;
          DebugOpt:=Settings.DebugOptOS2;
          MemSizes:=Settings.MemSizesOS2;
     End;
     pf_Win32:
     Begin
Win:
          CompOpt:=Settings.CompOptWin;
          WarnOpt:=Settings.WarnOptWin;
          LinkOpt:=Settings.LinkOptWin;
          DebugOpt:=Settings.DebugOptWin;
          MemSizes:=Settings.MemSizesWin;
     End;
  End; //case

  Result := '';

  CASE Settings.Platform OF
      pf_OS2:      Result := Result + '-OS2';
      pf_Win32:    Result := Result + '-W32';
      {$IFDEF OS2}
      pf_Standard: Result := Result + '-OS2';
      {$ENDIF}
      {$IFDEF Win32}
      pf_Standard: Result := Result + '-W32';
      {$ENDIF}
  END;

  WITH CompOpt DO
  BEGIN
    IF CodeGen * [cg_ASMSource] <> [] THEN Result := Result + '-A';
    IF CodeGen * [cg_InlineStrings] <> [] THEN Result := Result + '-Z';
    IF CodeGen * [cg_Assertions] <> [] THEN Result := Result + '-$C+';
    IF CodeGen * [cg_SaveConstructors] <> [] THEN Result := Result + '-$TRY+';

    IF Syntax * [sx_StrictVAR] <> [] THEN Result := Result + '-V';
    IF Syntax * [sx_CompleteBoolEval] <> [] THEN Result := Result + '-C';

    IF Optimize * [om_OptimizeCommonSub,om_OptimizePeephole]=[] THEN Result := Result+'-O0' //no optimization
    ELSE
    BEGIN
         IF Optimize * [om_OptimizeCommonSub,om_OptimizePeephole]=[om_OptimizeCommonSub] THEN Result := Result+'-O1'
         ELSE IF Optimize * [om_OptimizeCommonSub,om_OptimizePeephole]=[om_OptimizePeephole] THEN Result := Result+'-O2'
         ELSE Result := Result+'-O3'; //all optimizations
    END;

    IF Runtime * [rc_InOut] = [] THEN Result := Result + '-$I-';
    IF Runtime * [rc_Overflow] <> [] THEN Result := Result + '-$Q+';
    IF Runtime * [rc_Stack] <> [] THEN Result := Result + '-$S+';
    IF Runtime * [rc_Range] <> [] THEN Result := Result + '-$R+';
  END;

  WITH WarnOpt DO
  BEGIN
     IF Warnings * [w_WAll] <> [] THEN Result:=Result+'-$WA+'
     ELSE IF Warnings * [w_WNone] <> [] THEN Result:=Result+'-$WA-'
     ELSE
     BEGIN
          IF Warnings * [w_W1] <> [] THEN Result:=Result+'-$W1+';
          IF Warnings * [w_W2] = [] THEN Result:=Result+'-$W2-';
          IF Warnings * [w_W3] = [] THEN Result:=Result+'-$W3-';
          IF Warnings * [w_W4] = [] THEN Result:=Result+'-$W4-';
          IF Warnings * [w_W5] = [] THEN Result:=Result+'-$W5-';
          IF Warnings * [w_W6] = [] THEN Result:=Result+'-$W6-';
          IF Warnings * [w_W7] = [] THEN Result:=Result+'-$W7-';
     END;

     IF MaxWarnings <> 200 THEN Result:=Result+'-WC'+tostr(MaxWarnings);
     IF MaxErrors <> 10 THEN Result:=Result+'-EC'+tostr(MaxErrors);
  END;

  WITH LinkOpt DO
  BEGIN
    IF DataSegment = ds_SingleShared THEN Result := Result + '-%M';

    CASE LinkerTarget OF
      lt_GUI:        Result := Result + '-T1';
      lt_Window:     Result := Result + '-T2';
      lt_FullScreen: Result := Result + '-T3';
    END;

    CASE ExePacking OF
      ep_None:     ;
      ep_ExePack1: IF Not (di_LineNumbers IN DebugOpt.Info)
                   THEN Result := Result + '-P1';
      ep_ExePack2: IF Not (di_LineNumbers IN DebugOpt.Info)
                   THEN Result := Result + '-P2';
    END;

    IF RunVDM THEN
      IF Not (di_LineNumbers IN DebugOpt.Info)
      THEN Result := Result + '-VDM';
  END;

  WITH DebugOpt DO
  BEGIN
    IF Info * [di_LineNumbers] <> [] THEN
    BEGIN
         Result := Result + '-D';
         IF Info * [di_LocalSymbols] <> [] THEN Result := Result + '-L';
    END;
  END;

  WITH MemSizes DO
  BEGIN
    IF Stack > 256 THEN Result := Result + '-%S' + tostr(Stack)
    ELSE Result := Result + '-%S256';
    IF HeapSize > 8192 THEN Result := Result + '-%H' + tostr(Heap)
    ELSE Result := Result + '-%H8192';
  END;
END;


FUNCTION GetCompilerDefines(CONST Settings:TProjectSettings):STRING;
VAR CompOpt:TCompilerOptions;
BEGIN
  Case Settings.Platform Of
     pf_Standard:
     Begin
          {$IFDEF OS2}
          CompOpt:=Settings.CompOptOS2;
          {$ENDIF}
          {$IFDEF WIN32}
          CompOpt:=Settings.CompOptWin;
          {$ENDIF}
     End;
     pf_OS2:CompOpt:=Settings.CompOptOS2;
     pf_Win32:CompOpt:=Settings.CompOptWin;
  End; //case

  Result := CompOpt.CondDef;
  WHILE Result[Length(Result)]=#32 DO dec(result[0]);
  WHILE ((length(result)>0)AND(Result[1]=#32)) DO Result:=Copy(Result,2,length(Result)-1);
END;



BEGIN
END.

