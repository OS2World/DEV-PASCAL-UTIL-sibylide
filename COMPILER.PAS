
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

UNIT Compiler;

INTERFACE

{$IFDEF OS2}
USES Os2Def,BseTib,PmWin,BseDos,PmStdDlg;
{$ENDIF}

{$IFDEF WIN32}
Uses WinBase;
{$ENDIF}

USES Dos,SysUtils,Classes,Forms,Dialogs,Editors,
     SPC_Data,Consts,Projects,Sib_Prj,BaseForm,Sib_Edit,Inspect,
     DAsm,DebugHlp,DisAsm,DbgWatch;

PROCEDURE Run(viaDebug:BOOLEAN);
PROCEDURE Compile;
PROCEDURE Make;
PROCEDURE Build;
PROCEDURE ForceCompile(Action:TCompilerActions;FileName:STRING);
PROCEDURE StopCompiler;
FUNCTION  RunCompiler(Action:TCompilerActions;FileName:STRING):BOOLEAN;
FUNCTION  CheckDependencies(FileName:STRING;VAR cancel:BOOLEAN):BOOLEAN;
FUNCTION  GetFullSourceName(compfile,unitfile:STRING):STRING;
FUNCTION  AutoSaveEnvironment:BOOLEAN;

CONST
    ErrorTable:^CHAR=NIL;  //Compiler errors

CONST
    {$IFDEF OS2}
    SPUExt = '.SPU';
    SRFExt = '.SRF';
    {$ENDIF}
    {$IFDEF Win32}
    SPUExt = '.SPW';
    SRFExt = '.SRW';
    {$ENDIF}

TYPE
    TCompilerThread=CLASS(TThread)
        PROCEDURE Execute;OVERRIDE;
        DESTRUCTOR Destroy;OVERRIDE;
    END;


VAR
    ComponentSPUDir:STRING;
    CompilerThread:TCompilerThread;

PROCEDURE DeleteLanguageSCU(VAR Info:POINTER;VAR InfoLen:LONGINT;Name:STRING);

IMPLEMENTATION

PROCEDURE DeleteLanguageSCU(VAR Info:POINTER;VAR InfoLen:LONGINT;Name:STRING);
VAR p,p1,NameTable,ResourceTable:^LONGWORD;
    dummy:PSCUFileFormat;
    Save:^Byte;
    s:STRING;
    t,t1:longint;
    Flags:BYTE;
    ps,psLang:^STRING;
    Len:LONGWORD;
    NewInfo:POINTER;
    Count,NewLen:LONGWORD;
    App:STRING;
    Msg,Lang:POINTER;
    Size:^LONGWORD;
    Diff:LONGINT;
LABEL again;
BEGIN
     UpcaseStr(Name);
again:
     dummy:=Info;
     WHILE dummy<>NIL DO
     BEGIN
          NameTable:=POINTER(dummy);
          inc(NameTable,dummy^.NameTableOffset);
          ResourceTable:=POINTER(dummy);
          inc(ResourceTable,dummy^.ResourceOffset);

          p:=POINTER(dummy);
          inc(p,dummy^.ObjectOffset);

          p1:=POINTER(dummy);
          inc(p1,sizeof(TSCUFileFormat));
          FOR t:=1 TO dummy^.ObjectCount DO
          BEGIN
               Save:=p1;
               Flags:=p1^ AND 255;       //1- auto create, 2- language info avail
               inc(p1);                  //skip Flag
               inc(p1,(p1^ AND 255)+1);  //skip Form Name
               inc(p1,(p1^ AND 255)+1);  //skip Form Unit Name
               inc(p1,(p1^ AND 255)+1);  //skip Form TypeName

               //If Message Information is available for this form (only for first) remember and skip it !
               IF (Flags AND 8)<>0 THEN
               BEGIN
                    Msg:=POINTER(p1);
                    p:=POINTER(p1);
                    Size:=POINTER(p);
                    inc(p,4); //skip size
                    ps:=POINTER(p); //AppLanguage
                    App:=ps^;
                    inc(p,length(ps^)+1);

                    ps:=POINTER(p);
                    Count:=0;
                    WHILE length(ps^)<>0 DO
                    BEGIN
                         s:=ps^;
                         UpcaseStr(s);
                         IF s=Name THEN //found !
                         BEGIN
                              //erase this section !
                              p:=POINTER(ps);
                              inc(p,length(ps^)+1);
                              Len:=p^;
                              inc(p,4);
                              inc(p,Len);

                              IF (((p^ AND 255)=0)AND(Count=0)) THEN //This is the only entry
                              BEGIN
                                   inc(p); //skip 0
                                   Save^:=Save^ AND not 8; //no message Info
                                   Diff:=1+Len+4+length(ps^)+1+length(App)+1+4;
                                   dec(dummy^.NameTableOffset,Diff);
                                   dec(dummy^.ResourceOffset,Diff);
                                   dec(dummy^.ObjectOffset,Diff);
                                   NewLen:=InfoLen-Diff;
                                   GetMem(NewInfo,NewLen);
                                   p1:=POINTER(NewInfo);
                                   System.Move(Info^,p1^,longword(Msg)-longword(Info));
                                   inc(p1,longword(Msg)-longword(Info));
                                   System.Move(p^,p1^,NewLen-(longword(Msg)-longword(Info)));
                              END
                              ELSE
                              BEGIN
                                   Diff:=Len+4+length(ps^)+1;
                                   dec(dummy^.NameTableOffset,Diff);
                                   dec(dummy^.ResourceOffset,Diff);
                                   dec(dummy^.ObjectOffset,Diff);
                                   NewLen:=InfoLen-Diff;
                                   Size^:=Size^-Diff;
                                   GetMem(NewInfo,NewLen);
                                   p1:=POINTER(NewInfo);
                                   System.Move(Info^,p1^,longword(ps)-longword(Info));
                                   inc(p1,longword(ps)-longword(Info));
                                   System.Move(p^,p1^,NewLen-(longword(ps)-longword(Info)));
                              END;

                              FreeMem(Info,InfoLen);
                              Info:=NewInfo;
                              InfoLen:=NewLen;
                              goto again; //process again !
                         END;

                         p:=POINTER(ps);
                         inc(p,length(ps^)+1);
                         Len:=p^;
                         inc(p,4);
                         inc(p,Len);
                         ps:=POINTER(p);
                         inc(Count);
                    END;

                    inc(p1,p1^);  //skip section
               END;

               //If Language Information is available for this form, remember and skip
               IF Flags AND 2<>0 THEN
               BEGIN
                    Lang:=POINTER(p1);
                    p:=POINTER(p1);
                    Size:=POINTER(p);
                    inc(p,4); //skip size
                    ps:=POINTER(p); //Current language
                    App:=ps^;
                    inc(p,length(ps^)+1);

                    ps:=POINTER(p);
                    Count:=0;
                    WHILE length(ps^)<>0 DO
                    BEGIN
                         psLang:=ps;
                         inc(ps);  //skip 1
                         s:=ps^;
                         UpcaseStr(s);
                         IF s=Name THEN //found !
                         BEGIN
                              //erase this section
                              p:=POINTER(ps);
                              inc(p,length(ps^)+1);

                              Diff:=1+length(ps^)+1;
                              FOR t1:=1 TO 3 DO
                              BEGIN
                                   WHILE (p^ AND 255)<>0 DO
                                   BEGIN
                                        inc(p); //skip 1
                                        ps:=POINTER(p);
                                        Diff:=Diff+1+length(ps^)+1;
                                        inc(p,length(ps^)+1);
                                        inc(p); //skip valuetyp
                                        inc(Diff);
                                        Diff:=Diff+4+p^; //ValueLen
                                        inc(p,4+p^);
                                        inc(p,16);  //skip position and dimensions
                                        inc(Diff,16);
                                   END;
                                   inc(p);  //skip 0
                                   inc(Diff);
                              END;

                              dec(dummy^.NameTableOffset,Diff);
                              dec(dummy^.ResourceOffset,Diff);
                              dec(dummy^.ObjectOffset,Diff);
                              NewLen:=InfoLen-Diff;
                              Size^:=Size^-Diff;
                              GetMem(NewInfo,NewLen);
                              p1:=POINTER(NewInfo);
                              System.Move(Info^,p1^,longword(psLang)-longword(Info));
                              inc(p1,longword(psLang)-longword(Info));
                              System.Move(p^,p1^,NewLen-(longword(psLang)-longword(Info)));

                              FreeMem(Info,InfoLen);
                              Info:=NewInfo;
                              InfoLen:=NewLen;
                              goto again; //process again !
                         END;

                         p:=POINTER(ps);
                         inc(p,length(ps^)+1);
                         Diff:=1+length(ps^)+1;
                         FOR t1:=1 TO 3 DO
                         BEGIN
                              WHILE (p^ AND 255)<>0 DO
                              BEGIN
                                   inc(p); //skip 1
                                   ps:=POINTER(p);
                                   Diff:=Diff+1+length(ps^)+1;
                                   inc(p,length(ps^)+1);
                                   inc(p); //skip valuetyp
                                   inc(Diff);
                                   Diff:=Diff+4+p^; //ValueLen
                                   inc(p,4+p^);
                                   inc(p,16);  //skip position and dimensions
                                   inc(Diff,16);
                              END;
                              inc(p);  //skip 0
                              inc(Diff);
                         END;
                         ps:=POINTER(p);

                         (*
                         IF Count=0 THEN IF length(ps^)=0 THEN IF s='DEFAULT' THEN
                         BEGIN
                              //erase also default if it is the last language...
                              Save^:=Save^ AND not 2; //no language Info
                              inc(p);
                              inc(Diff,4+length(App)+1+1);

                              dec(dummy^.NameTableOffset,Diff);
                              dec(dummy^.ResourceOffset,Diff);
                              dec(dummy^.ObjectOffset,Diff);
                              NewLen:=InfoLen-Diff;
                              GetMem(NewInfo,NewLen);
                              p1:=POINTER(NewInfo);
                              System.Move(Info^,p1^,longword(Lang)-longword(Info));
                              inc(p1,longword(Lang)-longword(Info));
                              System.Move(p^,p1^,NewLen-(longword(Lang)-longword(Info)));

                              FreeMem(Info,InfoLen);
                              Info:=NewInfo;
                              InfoLen:=NewLen;
                              goto again; //process again !
                         END;
                         *)

                         inc(Count);
                    END;

                    inc(p1,p1^);  //skip language info
               END;
          END;

          dummy:=dummy^.NextEntry;
     END;
END;

PROCEDURE EraseUnusedLanguages(VAR p:POINTER;VAR Len:LONGWORD);
VAR s,s1:STRING;
BEGIN
     s:=Project.Settings.InActiveLanguages;
     WHILE s<>'' DO
     BEGIN
          IF pos(';',s)<>0 THEN
          BEGIN
               s1:=Copy(s,1,pos(';',s)-1);
               Delete(s,1,pos(';',s));
          END
          ELSE
          BEGIN
               s1:=s;
               s:='';
          END;

          DeleteLanguageSCU(p,LONGINT(Len),s1);
     END;
END;


TYPE
    TTestTimesReturn=(ttrSourceNotFound,ttrTargetNotFound,
                     ttrTimesEqual,ttrSourceNewer,ttrTargetNewer);

// References were to resdll25 - AaronL
{$IFDEF OS2}
IMPORTS
       PROCEDURE InvokeRes(VAR Params:TPasParams;VAR Return:TPasReturn);
              'RESDLL20' name 'INVOKERES';
END;
{$ENDIF}
{$IFDEF Win32}
IMPORTS
       PROCEDURE InvokeRes(VAR Params:TPasParams;VAR Return:TPasReturn);
              'RESDLL20' name 'INVOKERES';
END;
{$ENDIF}


CONST
    RetFilesLen = 256;

    RetFileType:ARRAY[0..3] OF STRING[4] = ('',SPUExt,'.DLL','.EXE');



PROCEDURE WriteMessage(CONST msg:STRING);
BEGIN
     SetMainStatusText(msg, clBlue,clLtGray);
     CodeEditor.AddMessage(msg);
END;



FUNCTION GetInMemoryEditors:PMemoryList;
VAR  t:LONGINT;
     p:POINTER;
     Len:LONGINT;
     dummy:PMemoryList;
     Edit:TSibEditor;
     SCUMemory:TMemoryStream;
BEGIN
     Result := NIL;
     FOR t := CodeEditorRef.MDIChildCount-1 DOWNTO 0 DO
     BEGIN
          Edit := TSibEditor(CodeEditorRef.MDIChildren[t]);
          IF Edit IS TSibEditor THEN
          BEGIN
               IF Edit.GetText(p,Len,FALSE) THEN
               BEGIN
                    dummy := Result;
                    New(Result);
                    Result^.Name := Edit.FileName;
                    Result^.Adresse := p;
                    Result^.Len := Len;
                    Result^.Modified := Edit.Modified AND Edit.SPUInvalid;
                    Result^.Next := dummy;
               END;
          END;
     END;

     {SCU Information}
     IF Project.Forms.Count > 0 THEN
     BEGIN
          IF GetProjectSCUStream(SCUMemory) THEN
            IF SCUMemory <> NIL THEN
            BEGIN
                 dummy := Result;
                 New(Result);
                 Result^.Name := GetSCUName;
                 Result^.Len := SCUMemory.Size;
                 GetMem(Result^.Adresse, Result^.Len);
                 Result^.Modified := Project.SCUModified;
                 Result^.Next := dummy;
                 {kopieren}
                 SCUMemory.Position := 0;
                 SCUMemory.Read(Result^.Adresse^, Result^.Len);
                 {SCUMemory nicht zerst”ren, da im er Projekt gespeichert wird}

                 EraseUnusedLanguages(Result^.Adresse,Result^.Len);
            END;
     END;
END;


PROCEDURE FreeInMemoryEditors(InMemory:PMemoryList);
VAR  next:PMemoryList;
     p:POINTER;
BEGIN
     WHILE InMemory <> NIL DO
     BEGIN
          next := InMemory^.Next;
          p := InMemory^.Adresse;
          FreeMem(p,InMemory^.Len);
          Dispose(InMemory);
          InMemory := next;
     END;
END;


FUNCTION FileInCodeEditor(unitfile:STRING):STRING;
VAR  i:LONGINT;
     d,n,e:STRING;
     Edit:TSibEditor;
BEGIN
     UpcaseStr(unitfile);

     FOR i := 0 TO CodeEditor.MDIChildCount-1 DO
     BEGIN
          Edit := TSibEditor(CodeEditor.MDIChildren[i]);
          IF Edit IS TSibEditor THEN
          BEGIN
               FSplit(Edit.FileName, d,n,e);
               IF Upcased(n+e) = unitfile THEN
               BEGIN
                    Result := Edit.FileName;
                    exit;
               END;
          END;
     END;

     Result := '';
END;


FUNCTION GetFullSourceName(compfile,unitfile:STRING):STRING;
VAR  d,n,e:STRING;
BEGIN
     Result := '';
     {Maskiere Dateien aus ?...}

     FSplit(unitfile,d,n,e);   {unitfile nur Name und evtl Extension}
     UpcaseStr(e);
     IF e = '' THEN
     BEGIN
          unitfile := unitfile + '.PAS';

          {Suche im IncSrc Verzeichnis}
          d := ProjectIncSrcDir(Project.Settings);
          WHILE d <> '' DO
          BEGIN
               Result := FExpand(GetNextDir(d) + '\' + unitfile);
               IF FileExists(Result) THEN exit;
          END;

          {Suche im LibSrc Verzeichnis}
          d := ProjectLibSrcDir(Project.Settings);
          WHILE d <> '' DO
          BEGIN
               Result := FExpand(GetNextDir(d) + '\' + unitfile);
               IF FileExists(Result) THEN exit;
          END;

          {Suche im Verzeichnis des compilierten Files}
          FSplit(compfile,d,n,e);
          Result := d + unitfile;
          IF FileExists(Result) THEN exit;

          {Suche im aktuellen Verzeichnis}
          Result := FExpand(unitfile);
          IF FileExists(Result) THEN exit;

          {Suche im Editor}
          Result := FileInCodeEditor(unitfile);
          IF FileExists(Result) THEN exit;
     END;

     IF e = '.SRF' THEN
     BEGIN
          unitfile := n + '.RC';

          {Suche im IncSrc Verzeichnis}
          d := ProjectIncSrcDir(Project.Settings);
          WHILE d <> '' DO
          BEGIN
               Result := FExpand(GetNextDir(d) + '\' + unitfile);
               IF FileExists(Result) THEN exit;
          END;

          {Suche im Verzeichnis des compilierten Files}
          FSplit(compfile,d,n,e);
          Result := d + unitfile;
          IF FileExists(Result) THEN exit;

          {Suche im aktuellen Verzeichnis}
          Result := FExpand(unitfile);
          IF FileExists(Result) THEN exit;

          {Suche im Editor}
          Result := FileInCodeEditor(unitfile);
          IF FileExists(Result) THEN exit;
     END;

     IF e = '.SCU' THEN
     BEGIN
          FSplit(GetSCUName,d,n,e);
          Result := FExpand(d + unitfile);
          IF FileExists(Result) THEN exit;

          Result := FExpand(GetOutDir(compfile) + '\' + unitfile);
          IF FileExists(Result) THEN exit;

          {Suche im Lib Verzeichnis}
          d := ProjectLibDir(Project.Settings);
          WHILE d <> '' DO
          BEGIN
               Result := FExpand(GetNextDir(d) + '\' + unitfile);
               IF FileExists(Result) THEN exit;
          END;

          {Suche im aktuellen Verzeichnis}
          Result := FExpand(unitfile);
          IF FileExists(Result) THEN exit;
     END;

     Result := '';
END;


TYPE PThreadParams=^TThreadParams;
     TThreadParams=RECORD
                         pParams:PPasParams;
                         pReturn:PPasReturn;
     END;


PROCEDURE TCompilerThread.Execute;
VAR  Params:PThreadParams;
     dir,name,ext:STRING;
BEGIN
     Params := Parameter;
     FSplit(Params^.pParams^.Quell,dir,name,ext);
     UpcaseStr(ext);

     TRY
        IF ext = '.RC' THEN InvokeRes(Params^.pParams^,Params^.pReturn^)
        ELSE InvokeSpc(Params^.pParams^,Params^.pReturn^);
     EXCEPT
        Params^.pReturn^.Error := TRUE;
        SetCompilerStatusMessage(LoadNLSStr(SiInternalCompError),'',errNone,0,0);
        SendMsg(CodeEditor.Handle,cmOpenMsgWindow,-1,0); {Focus Last}
     END;
END;


DESTRUCTOR TCompilerThread.Destroy;
BEGIN
     Inherited Destroy;
     CompilerThread:=NIL;
END;



PROCEDURE CallInvokeCompiler(VAR Params:TPasParams;VAR Return:TPasReturn);
VAR  dir,name,ext:STRING;
     Param:TThreadParams;
     Edit:TEditor;
BEGIN
     FSplit(Params.Quell,dir,name,ext);
     UpcaseStr(ext);

     IF (ext = '.PAS') OR (ext = '.SCL') OR (ext = '.RC') THEN
     BEGIN
          {force to save .RC, because InMemory is not handled}
          IF ext = '.RC' THEN
          BEGIN
               Edit := GetEditor(Params.Quell);
               IF Edit <> NIL THEN
                 IF Edit.Modified THEN Edit.SaveFile;
          END;

          CodeEditor.CompilerTerminate := FALSE;

          Param.pParams := @Params;
          Param.pReturn := @Return;
          CompilerThread.ExtCreate(TRUE,256*1024,tpNormal,@Param);
          CompilerThread.OnTerminate := CodeEditor.EvCompileThreadEnded;
          CompilerThread.Resume;

          REPEAT
                Application.HandleMessage;
          UNTIL CodeEditor.CompilerTerminate;   {TRUE, wenn Thread beendet oder unterbrochen}

          {TCodeEditor.EvCompileThreadEnded terminates the Loop}
     END;
END;


PROCEDURE StopCompiler;
BEGIN
     IF not CompilerActive THEN exit;

     BreakCompiler;
END;

Type
  TCursorOrIcon=Record
                    Reserved: Word;
                    wType: Word;
                    Count: Word;
  End;


PROCEDURE SetupApplicationIcon(VAR Params:TPasParams);
VAR ApplicationOpt:^TApplicationOptions;
    Platform:TPlatform;
    ss,Dir,Name,Ext:String;
    f:file;
    SaveMode:LongWord;
    pw:^Word;
    pl:^LongInt;
    pb:^Byte;
    Ofs,Len,Len1,Len2,Ofs1,Ofs2,ResLen,ResOffset,ResDataOffset,NextDir:LongWord;
    t:LongInt;
    h,m,s,s100:word;
    dt:DateTime;
    Temp:LongInt;
    IR:TCursorOrIcon;
Label err,err1,err2;
BEGIN
     If Project.Settings.Platform=pf_Standard Then
     Begin
          {$IFDEF OS2}
          Platform:=pf_OS2;
          {$ENDIF}
          {$IFDEF WIN32}
          Platform:=pf_Win32;
          {$ENDIF}
     End
     Else Platform:=Project.Settings.Platform;

     If Platform=pf_OS2 Then ApplicationOpt:=@Project.Settings.ApplicationOptOS2
     Else ApplicationOpt:=@Project.Settings.ApplicationOptWin;

     ss:=ApplicationOpt^.ApplicationIcon;
     If ss='' Then
     BEGIN
          IF Project.Settings.ProjectType = pt_NonVisual THEN
          BEGIN
               ss:=ParamStr(0);
               FSplit(ss,Dir,Name,Ext);
               CASE Platform OF
                 pf_OS2:   ss:=Dir+'default.ico';
                 pf_Win32: ss:=Dir+'wdefault.ico';
               END;
          END
          ELSE exit; //use default icon in Cursors.SRF/SRW
     END;

     SaveMode:=FileMode;
     filemode:=fminput;
     Assign(f,ss);
     {$i-}
     Reset(f);
     {$i+}
     FileMode:=SaveMode;
     If IoResult<>0 Then
     Begin
err:
          SetCompilerStatusMessage(LoadNLSStr(SiInvalidAppIcon)+ss,'',errNone,0,0);
          SetCompilerStatusMessage(LoadNLSStr(SiIgnoringAppIcon),'',errNone,0,0);
          exit;
     End;

     {$I-}
     Len:=FileSize(f);
     {$I+}
     If IoResult<>0 Then
     Begin
err1:
          {$I-}
          Close(f);
          {$I+}
          goto err;
     End;

     If Platform=pf_OS2 Then //OS2 SRF Format
     Begin
          Params.ApplicationIconLen:=Len+2+14;
          GetMem(Params.ApplicationIcon,Params.ApplicationIconLen);

          //Write resource Dir
          pw:=Pointer(Params.ApplicationIcon);

          pw^:=Len;
          inc(pw,2);
          pw^:=1;             {Typ:Icon}
          inc(pw,2);
          pw^:=1;             {Bezeichner der Bitmap}
          inc(pw,2);
          pw^:=Len MOD 65536; {Lnge der Eintrge fr diese Bitmap}
          inc(pw,2);
          pw^:=Len DIV 65536;
          inc(pw,2);
          pw^:=3;             {Object number}
          inc(pw,2);
          pw^:=0;             //Offset low
          inc(pw,2);
          pw^:=0;             //Offset high
          inc(pw,2);

          //Write resource data
          {$I-}
          BlockRead(f,pw^,Len);
          {$I-}
          If IOResult<>0 Then
          Begin
err2:
               FreeMem(Params.ApplicationIcon,Params.ApplicationIconLen);
               Params.ApplicationIcon:=Nil;
               Params.ApplicationIconLen:=0;
               goto err1;
          End;
     End
     Else
     Begin //Win SRW Format
          GetTime(h,m,s,s100);
          dt.hour:=h;
          dt.min:=m;
          dt.sec:=s;
          GetDate(h,m,s,s100);
          dt.year:=h;
          dt.month:=m;
          dt.day:=s;
          packtime(dt,Temp);

          //determine type of ICON and Length of information as well as offsets to data
          {$I-}
          BlockRead(f,IR,sizeof(TCursorOrIcon));
          {$I+}
          if ioresult<>0 then goto err1;
          {$I-}
          Seek(f,0);
          {$I+}
          if ioresult<>0 then goto err1;

          If ((IR.Reserved=0)And(IR.wType In [0,1,2])) Then //Win Icon
          Begin
               Len1:=Len-22; //ohne Header
               Ofs1:=22;     //ohne Header
               Len2:=Len;
               Ofs2:=0;
          End
          Else goto err1;

          ResLen:=Len1; //ICON
          IF ResLen AND 3<>0 THEN
          BEGIN
               FOR t:=1 TO 4-(ResLen AND 3) DO inc(ResLen);
          END;
          ResLen:=ResLen+Len2; //GROUPICON
          IF ResLen AND 3<>0 THEN
          BEGIN
               FOR t:=1 TO 4-(ResLen AND 3) DO inc(ResLen);
          END;

          Params.ApplicationIconLen:=ResLen+2+16+(2*8)+(2*64);
          GetMem(Params.ApplicationIcon,Params.ApplicationIconLen);

          ResOffset:=16;
          ResDataOffset:=ResOffset+2*48;  {fr Directories}
          inc(ResDataOffset,2*24);

          NextDir:=(2*8)+ResOffset;

          //16
          pw:=Params.ApplicationIcon;
          pw^:=ResLen;
          inc(pw,2);
          pl:=Pointer(pw);
          pl^:=0;      {Resource flags}
          inc(pl,4);
          pl^:=Temp;   {Time stamp}
          inc(pl,4);
          pl^:=0;      {Major/minor version}
          inc(pl,4);
          pw:=Pointer(pl);
          pw^:=0;      {Number of name entries}
          inc(pw,2);
          pw^:=2;      {Number of index entries}
          inc(pw,2);
          pl:=Pointer(pw);

          //2*8
          pl^:=3;  {RT_ICON}
          inc(pl,4);
          pl^:=$80000000 OR (NextDir);  {Offset to resources}
          inc(pl,4);
          inc(ResOffset,8);
          inc(NextDir,16+48);
          pl^:=14; {RT_GROUP_ICON}
          inc(pl,4);
          pl^:=$80000000 OR (NextDir);  {Offset to resources}
          inc(pl,4);
          inc(ResOffset,8);
          inc(NextDir,16+48);

          //2*64
          //ICON
          pl^:=0;      {Resource flags}
          inc(pl,4);
          pl^:=Temp;   {Time stamp}
          inc(pl,4);
          pl^:=0;      {Major/Minor version}
          inc(pl,4);
          pw:=Pointer(pl);
          pw^:=0;      {Number of name entries}
          inc(pw,2);
          pw^:=1;      {Number of id entries}
          inc(pw,2);
          pl:=Pointer(pw);
          inc(ResOffset,16);
          Ofs:=ResOffset+(1*8);
          pl^:=1;  {id}
          inc(pl,4);
          pl^:=$80000000 OR Ofs;  {Offset to resources}
          inc(pl,4);
          inc(ResOffset,8);
          pl^:=0;      {Resource flags}
          inc(pl,4);
          pl^:=Temp;   {Time stamp}
          inc(pl,4);
          pl^:=0;      {Major/Minor version}
          inc(pl,4);
          pw:=Pointer(pl);
          pw^:=0;      {Number of name entries}
          inc(pw,2);
          pw^:=1;      {Number of id entries}
          inc(pw,2);
          pl:=Pointer(pw);
          pl^:=0;      {id}
          inc(pl,4);
          pl^:=ResOffset+24;
          inc(pl,4);
          pl^:=ResDataOffset; {Data rva 70058}
          inc(pl,4);
          inc(ResDataOffset,Len1); //ICON Len
          pl^:=Len1;          {Data len}
          inc(pl,4);
          pl^:=0;             {CodePage}
          inc(pl,4);
          pl^:=0;             {reserved}
          inc(pl,4);
          inc(ResOffset,40);
          IF ResDataOffset AND 3<>0 THEN
            FOR t:=1 TO 4-(ResdataOffset AND 3) DO inc(ResDataOffset);
          //GROUPICON
          pl^:=0;      {Resource flags}
          inc(pl,4);
          pl^:=Temp;   {Time stamp}
          inc(pl,4);
          pl^:=0;      {Major/Minor version}
          inc(pl,4);
          pw:=Pointer(pl);
          pw^:=0;      {Number of name entries}
          inc(pw,2);
          pw^:=1;      {Number of id entries}
          inc(pw,2);
          pl:=Pointer(pw);
          inc(ResOffset,16);
          Ofs:=ResOffset+(1*8);
          pl^:=1;  {id}
          inc(pl,4);
          pl^:=$80000000 OR Ofs;  {Offset to resources}
          inc(pl,4);
          inc(ResOffset,8);
          pl^:=0;      {Resource flags}
          inc(pl,4);
          pl^:=Temp;   {Time stamp}
          inc(pl,4);
          pl^:=0;      {Major/Minor version}
          inc(pl,4);
          pw:=Pointer(pl);
          pw^:=0;      {Number of name entries}
          inc(pw,2);
          pw^:=1;      {Number of id entries}
          inc(pw,2);
          pl:=Pointer(pw);
          pl^:=0;      {id}
          inc(pl,4);
          pl^:=ResOffset+24;
          inc(pl,4);
          pl^:=ResDataOffset; {Data rva 70058}
          inc(pl,4);
          inc(ResDataOffset,Len2); //GROUPICON Len
          pl^:=Len2;          {Data len}
          inc(pl,4);
          pl^:=0;             {CodePage}
          inc(pl,4);
          pl^:=0;             {reserved}
          inc(pl,4);
          inc(ResOffset,40);
          IF ResDataOffset AND 3<>0 THEN
            FOR t:=1 TO 4-(ResdataOffset AND 3) DO inc(ResDataOffset);

          //ResourceData ICON
          {$I-}
          Seek(f,Ofs1);
          {$I+}
          If IOResult<>0 Then goto err2;
          {$I-}
          BlockRead(f,pl^,Len1);
          {$I+}
          If IOResult<>0 Then goto err2;
          inc(pl,Len1);
          pb:=Pointer(pl);
          IF Len1 AND 3<>0 THEN
          BEGIN
               FOR t:=1 TO 4-(Len1 AND 3) DO
               BEGIN
                    pb^:=0;
                    inc(pb);
               END;
          END;
          pl:=Pointer(pb);

          //ResourceData GROUPICON
          {$I-}
          Seek(f,Ofs2);
          {$I+}
          If IOResult<>0 Then goto err2;
          {$I-}
          BlockRead(f,pl^,Len2);
          {$I+}
          If IOResult<>0 Then goto err2;
          pb:=Pointer(pl);
          inc(pb,Len2);
          inc(pl,18);
          pl^:=1; //Group Id
          IF Len1 AND 3<>0 THEN
          BEGIN
               FOR t:=1 TO 4-(Len1 AND 3) DO
               BEGIN
                    pb^:=0;
                    inc(pb);
               END;
          END;
     End;

     {$I-}
     Close(f);
     {$I+}
END;

FUNCTION RunCompiler(Action:TCompilerActions;FileName:STRING):BOOLEAN;
VAR  Options:STRING;
     Edit:TSibEditor;
     s,dir,name,ext:STRING;
     i:INTEGER;
     Params:TPasParams;
     Return:TPasReturn;
     RetDataSize:LONGINT;
     ppf:PProjectFile;
     updateBrowser:BOOLEAN;
     Directories:^TDirectories;
LABEL lend;
BEGIN
     Result := FALSE;

     Case Project.Settings.Platform Of
        pf_Standard:
        Begin
             {$IFDEF OS2}
             Directories:=@Project.Settings.DirectoriesOS2;
             {$ENDIF}
             {$IFDEF WIN32}
             Directories:=@Project.Settings.DirectoriesWin;
             {$ENDIF}
        End;
        pf_OS2:
        BEGIN
             Directories:=@Project.Settings.DirectoriesOS2;
        End;
        pf_Win32:
        BEGIN
             Directories:=@Project.Settings.DirectoriesWin;
        END;
     End; //case


     IF FileName = '' THEN exit;

     IF CompilerActive THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiCompilerAlreadyRunning));
          exit;
     END;
     CompilerActive := TRUE;

     ControlCentre.EnableDocking := []; {prevent Docking Operations}

     FOR i := 0 TO CodeEditorRef.MDIChildCount-1 DO
     BEGIN
          Edit := TSibEditor(CodeEditorRef.MDIChildren[i]);
          IF Edit IS TSibEditor THEN Edit.ResetErrorLine;
     END;

     IF FileName = '' THEN goto lend;

     IF IdeSettings.OpenMsgView THEN
     BEGIN
          CodeEditor.ShowControlCentre(BuildIndex,NoFokus);

          IF ControlCentre <> NIL THEN
            IF ControlCentre.Form <> NIL THEN ControlCentre.Form.BringToFront;
     END;

     {Suche nur in den MainFiles}
     ppf := DataProjectMain(FileName);

     IF ppf <> NIL THEN ppf^.CheckSum := 0;  {neue Checksumme}

     CASE Action OF
         Action_Compile: Options := '';
         Action_Make:    Options := '-M';
         Action_Build:   Options := '-B';
         Action_CompLib: Options := '-M-T1';
     END;

     FillChar(Params,sizeof(Params),0);
     Params.Version := 200;  //2.0 Version with GUI output
     Params.Quell := FileName;
     IF Action = Action_CompLib THEN
     BEGIN
          FSplit(GetCompLibName,dir,name,ext);
          NormalizeDir(dir);
          Params.Out := ProjectOutDir(Project.Settings);
          Params.ExeOut := dir;
          Params.Lib := ProjectOutDir(Project.Settings) +';'+
                        ProjectLibDir(Project.Settings) +';'+
                        ProjectCompInstallDir(Project.Settings) +';'+
                        ComponentSPUDir;
          Params.IncSrcDir := ProjectIncSrcDir(Project.Settings) +';'+
                        ComponentSPUDir;
          Params.Params := Options;
          Params.Defines := '';
     END
     ELSE
     BEGIN
          Params.Out := ProjectOutDir(Project.Settings);
          Params.ExeOut := '';
          Params.Lib := ProjectLibDir(Project.Settings) +';'+
                        ProjectCompInstallDir(Project.Settings);
          Params.IncSrcDir := ProjectIncSrcDir(Project.Settings);
          Params.Params := Options + GetCompilerOptions(Project.Settings);
          Params.Defines := GetCompilerDefines(Project.Settings);
     END;
     Params.LibSrc := ProjectLibSrcDir(Project.Settings);
     FSplit(GetSCUName,dir,name,ext);
     NormalizeDir(dir);
     Params.SCUDir := dir;
     Params.InMemory := GetInMemoryEditors;
     Params.MsgProc := @SetCompilerStatusMessage;
     {!!!!!!setze Liste der zustzlichen Resourcen!!!!!!}
     Params.AddResources:=NIL;
     Params.ErrorTable:=ErrorTable;

     FillChar(Return,sizeof(Return),0);
     Return.Error := TRUE; {because of kill thread}

     SetupApplicationIcon(Params);

     CallInvokeCompiler(Params,Return);

     If Params.ApplicationIcon<>Nil Then FreeMem(Params.ApplicationIcon,Params.ApplicationIconLen);

     FreeInMemoryEditors(Params.InMemory);

     IF VDETerminating THEN exit;

     IF Return.Error THEN
     BEGIN
          Result := FALSE;
          IF IdeSettings.EnableSound THEN Beep(600,200);

          IF Return.RetFiles <> NIL THEN
          BEGIN
               RetDataSize := (Return.RetFilesCount+1) * RetFilesLen;

               {das Compilat von "FileName" ist ungltig, weil Fehler aufgetreten ist}
               Edit := GetEditor(FileName);
               IF Edit <> NIL THEN Edit.SPUInvalid := TRUE;

               FOR i := 1 TO Return.RetFilesCount DO
               BEGIN
                    s := GetFullSourceName(FileName,Return.RetFiles^[i]);
                    IF s <> '' THEN
                    BEGIN
                         {merken, das die SPU von "s" gltig ist - wegen Dependency Test}
                         Edit := GetEditor(s);
                         IF Edit <> NIL THEN Edit.SPUInvalid := FALSE;
                    END;
               END;
               FreeAPIMem(Return.RetFiles, RetDataSize);
          END;
     END
     ELSE
     BEGIN
          Result := TRUE;
          IF IdeSettings.EnableSound THEN
          BEGIN
               Beep(800,50);
               Beep(1000,50);
               Beep(1300,50);
          END;
          SetMainStatusText(LoadNLSStr(SiSuccess),clBlack,clLtGray);
          ErrName := '';
          Project.NeedRecompile := FALSE;

          IF Return.RetFiles <> NIL THEN
          BEGIN
               RetDataSize := (Return.RetFilesCount+1) * RetFilesLen;

               {merken, das die Compilat von "FileName" gltig ist - wegen Dependency Test}
               Edit := GetEditor(FileName);
               IF Edit <> NIL THEN Edit.SPUInvalid := FALSE;

               IF (Action <> Action_CompLib) AND (Return.RetType IN [2,3]) THEN
               BEGIN
                    Project.Modified := TRUE;

                    IF ppf <> NIL THEN
                    BEGIN
                         ppf^.CheckSum := RetDataSize;
                         ppf^.ExeExt := RetFileType[Return.RetType];
                    END;

                    updateBrowser := Upcased(ProjectPrimary(Project.Settings)) =
                                     Upcased(FileName);
                    IF updateBrowser THEN
                    BEGIN
                         Project.BrowserFiles.Clear;
                         (* nicht die Exe hinzufgen
                         FSplit(FileName,dir,name,ext);
                         Project.BrowserFiles.Add(name + RetFileType[Return.RetType]);
                         *)
                    END;
                    {Generiere Used_Files Liste}
                    ClearProjectDependencies(FileName);
                    FOR i := 1 TO Return.RetFilesCount DO
                    BEGIN
                         s := GetFullSourceName(FileName,Return.RetFiles^[i]);
                         IF s <> '' THEN
                         BEGIN
                              {SubFile "s" in die Dependency Struktur von "FileName" eintragen}
                              AddProjectDependency(FileName,s);

                              {merken, das die SPU von "s" gltig ist - wegen Dependency Test}
                              Edit := GetEditor(s);
                              IF Edit <> NIL THEN Edit.SPUInvalid := FALSE;
                         END;

                         IF updateBrowser THEN {Browser Info generieren}
                         BEGIN
                              name := Upcased(Return.RetFiles^[i]);
                              IF pos('.SCU',name) > 0 THEN continue;
                              IF pos('.SRF',name) > 0 THEN continue;
                              name := Return.RetFiles^[i] {+ SPUExt}; {no Ext.}
                              Project.BrowserFiles.Add(name); {SPU}
                         END;
                    END;

                    {$IFDEF OS2}
                    // Refresh the ProjectFilesTree
                    IF ProjectFilesTree <> NIL THEN
                    BEGIN
                         // force correct node positions
                         WinSendMsg(ProjectFilesTree.Handle,CM_EXPANDTREE,0,0);
                         WinEnableWindowUpdate(ProjectFilesTree.Handle,False);
                         WinSendMsg(ProjectFilesTree.Handle,CM_COLLAPSETREE,0,0);
                         WinEnableWindowUpdate(ProjectFilesTree.Handle,True);
                    END;
                    {$ENDIF}

                    IF updateBrowser THEN
                      IF IdeSettings.CodeInsight.CodeParameter OR
                         IdeSettings.CodeInsight.CodeCompletion
                      THEN UpdateBrowserInfoProc(FALSE);
               END;
               FreeAPIMem(Return.RetFiles, RetDataSize);
          END;

          IF Action = Action_CompLib THEN
          BEGIN //fge das neue Verzeichnis hinzu
               s := Upcased(ComponentSPUDir) + ';';
               dir := Directories^.CompInstallDir;
               IF pos(s, Upcased(dir) +';') = 0 THEN
               BEGIN {append it}
                    IF dir[Length(dir)] = ';'
                    THEN SetLength(dir, Length(dir)-1);
                    IF dir <> '' THEN dir := dir + ';';
                    Directories^.CompInstallDir := dir + ComponentSPUDir;
               END;
          END;
     END;
lend:
     CompilerActive := FALSE;

     ControlCentre.EnableDocking := [tbBottom]; {enable Docking Operations}
END;


FUNCTION TestFileTimes(Source,Target:STRING;VAR Return:TTestTimesReturn):BOOLEAN;
VAR  year1,month1,day1,hour1,minute1,sec1:WORD;
     dow1,sec100:WORD;
     year2,month2,day2,hour2,minute2,sec2:WORD;
     DirInfo:TSearchRec;
     DT:DateTime;
     Edit:TSibEditor;
     status:INTEGER;
LABEL Second;
BEGIN
     Result := FALSE;
     Return := ttrSourceNewer;

     Edit := GetEditor(Source);
     IF Edit <> NIL THEN
       IF Edit.Modified AND Edit.SPUInvalid THEN {Datei-Zeit des Editors wird verwendet}
       BEGIN
            GetDate(year1,month1,day1,dow1);
            GetTime(hour1,minute1,sec1,sec100);
            goto Second;
       END;

     status := FindFirst(Source, AnyFile, DirInfo);
     IF status = 0 THEN
     BEGIN {Source found}
          SysUtils.FindClose(DirInfo);
          UnpackTime(DirInfo.Time,DT);
          year1 := DT.year;
          month1 := DT.month;
          day1 := DT.day;
          hour1 := DT.hour;
          minute1 := DT.min;
          sec1 := DT.sec;
     END
     ELSE
     BEGIN {Source not found}
          Return := ttrSourceNotFound;
          exit;
     END;

Second:
     status := FindFirst(Target, AnyFile, DirInfo);
     IF status = 0 THEN
     BEGIN {Source found}
          SysUtils.FindClose(DirInfo);
          UnpackTime(DirInfo.Time,DT);
          year2 := DT.year;
          month2 := DT.month;
          day2 := DT.day;
          hour2 := DT.hour;
          minute2 := DT.min;
          sec2 := DT.sec;
     END
     ELSE
     BEGIN {Target not found}
          Return := ttrTargetNotFound;
          exit;
     END;

     IF year1 > year2 THEN exit;
     IF year1 = year2 THEN
     BEGIN
          IF month1 > month2 THEN exit;
          IF month1 = month2 THEN
          BEGIN
               IF day1 > day2 THEN exit;
               IF day1 = day2 THEN
               BEGIN
                    IF hour1 > hour2 THEN exit;
                    IF hour1 = hour2 THEN
                    BEGIN
                         IF minute1 > minute2 THEN exit;
                         IF minute1 = minute2 THEN
                         BEGIN
                              IF sec1 > sec2 THEN exit;
                              IF sec1 = sec2 THEN
                              BEGIN
                                   Result := TRUE;
                                   Return := ttrTimesEqual;
                                   exit;
                              END;
                         END;
                    END;
               END;
          END;
     END;

     Result := TRUE;
     Return := ttrTargetNewer;
END;


FUNCTION CompareSourceSpuExeTimes(source,exe:STRING):BOOLEAN;
VAR  Return:TTestTimesReturn;
     d,n,e,spu:STRING;
LABEL testspuexe;
BEGIN
     Result := FALSE;

     FSplit(source,d,n,e);
     {teste Source - SPU zuerst mit dem OutDir}
     spu := FExpand(GetOutDir(source) + '\' + n + SPUExt);
     IF TestFileTimes(source,spu,Return) THEN {spu newer or equal than source}
     BEGIN
          {spu gefunden, und neuer als die source}
          goto testspuexe;
     END;
     IF Return = ttrSourceNotFound THEN exit;   {kann eigentlich nicht sein}
     IF Return = ttrSourceNewer THEN exit;      {dependencies FALSE}

     {TargetNotFound: teste source - SPU mit dem LibDir, der Reihe nach}
     d := ProjectLibDir(Project.Settings);
     WHILE d <> '' DO
     BEGIN
          spu := FExpand(GetNextDir(d) + '\' + n + SPUExt);
          IF TestFileTimes(source,spu,Return) THEN
          BEGIN
               {spu gefunden, und neuer als die source}
               goto testspuexe;
          END;
          IF Return = ttrSourceNewer THEN exit;      {dependencies FALSE}
     END;
     {test ob SPU im aktuellen Verzeichnis da ist}
     {$i-}
     GetDir(0,d);
     {$i+}
     NormalizeDir(d);
     spu := d + '\' + n + SPUExt;
     IF TestFileTimes(source,spu,Return) THEN {spu newer or equal than source}
     BEGIN
          {spu gefunden, und neuer als die source}
          goto testspuexe;
     END;
     IF Return = ttrSourceNewer THEN exit;      {dependencies FALSE}

     exit; {keine SPU gefunden}

testspuexe:
     Result := TestFileTimes(spu,exe,Return);
END;


CONST //Resultat des Dependency Test anzeigen oder nicht
     DepMsg:BOOLEAN=FALSE;

{Check ohne Compilierung der SPU
 nur SRFs werden neu erstellt wenn ungltig
 liefert TRUE wenn Dependencies Ok ist ansonsten FALSE auch wenn keine Infos da}
FUNCTION CheckDependencies(FileName:STRING;VAR cancel:BOOLEAN):BOOLEAN;
VAR  mpf,ppf,dep:PProjectFile;
     ppfName:STRING;
     exename,s,d,n,e:STRING;
     SPUInvalid:BOOLEAN;
     SRFInvalid:BOOLEAN;
     SCUInvalid:BOOLEAN;
     Return:TTestTimesReturn;
     i:LONGINT;
     depidx:LONGINT;
LABEL nodep;
BEGIN
     Result := FALSE;
     cancel := FALSE;
     IF FileName = '' THEN exit;
     SPUInvalid := FALSE;
     SRFInvalid := FALSE;
     SCUInvalid := FALSE;

     IF not ExistProjectMain(FileName) THEN {nur Zeitvergleich Source - Exe}
     BEGIN
          FSplit(FileName,d,n,e);
          exename := FExpand(GetOutDir(FileName) + '\' + n + '.EXE');
          IF not TestFileTimes(FileName,exename,Return) THEN
          BEGIN  {EXE steht immer im 'GetOutDir'}
               IF DepMsg THEN WriteMessage(FmtLoadNLSStr(SiFileIsCorrupt,[exename]));
               exit;
          END;
          Result := TRUE;
          exit;
     END;

     mpf := DataProjectMain(FileName);
     IF mpf = NIL THEN  {keine Informationen ber Dependencies vorhanden}
     BEGIN
nodep:
          IF DepMsg THEN WriteMessage(FmtLoadNLSStr(SiNoDependencyInfo,[FileName]));
          exit;
     END;

     IF mpf^.ASub = NIL THEN goto nodep;

     depidx := mpf^.ASub.FindFile(DependenciesString);
     IF depidx < 0 THEN goto nodep;
     dep := PProjectFile(mpf^.ASub.Objects[depidx]);

     IF dep = NIL THEN goto nodep;

     FSplit(FileName,d,n,e);
     exename := FExpand(GetOutDir(FileName) + '\' + n + mpf^.ExeExt);

     {Teste zuerst alle Ressourcen, da die beim Make nicht bercksichtigt werden}
     {Teste Dependency Ressourcen}
     IF dep^.ASub <> NIL THEN
     FOR i := 0 TO dep^.ASub.Count-1 DO
     BEGIN
          ppfName := dep^.ASub.Strings[i];
          ppf := PProjectFile(dep^.ASub.Objects[i]);

          FSplit(ppfName,d,n,e);
          UpcaseStr(e);
          IF e = '.RC' THEN
          BEGIN
               s := FExpand(GetOutDir(ppfName) + '\' + n + SRFExt);
               {Test ob RC neuer als SRF}
               IF not TestFileTimes(ppfName,s,Return) THEN
               BEGIN
                    {Starte Resource Compiler}
                    IF not RunCompiler(Action_Compile,ppfName) THEN
                    BEGIN {Abbruch bzw. Fehler bricht auch die Rahmenaktion ab !!!}
                         cancel := TRUE;
                         exit;
                    END;
                    SRFInvalid := TRUE;
               END;
               {Test ob SRF neuer als EXE}
               IF not TestFileTimes(s,exename,Return) THEN SRFInvalid := TRUE;
          END;
     END;

     IF SRFInvalid THEN exit;  {immer Compilieren}


     IF Project.NeedRecompile THEN
     BEGIN
          IF DepMsg THEN WriteMessage(LoadNLSStr(SiProjectModified));
          exit;
     END;

     IF Project.SCUModified AND (Project.LastSCUStream = NIL) THEN
     BEGIN {SCU Stream wurde nach dem letzten "GetProjectSCU" Call wieder modifiziert}
          IF DepMsg THEN WriteMessage(LoadNLSStr(SiSCUModified));
          exit;
     END;


     IF mpf^.CheckSum = 0 THEN  {File noch nicht compiliert seit ADD_Prj}
     BEGIN
          IF DepMsg THEN WriteMessage(FmtLoadNLSStr(SiFileNotYetCompiled,[FileName]));
          exit;
     END;

     IF mpf^.ExeExt = '' THEN  {File noch nicht compiliert seit ADD_Prj}
     BEGIN
          IF DepMsg THEN WriteMessage(FmtLoadNLSStr(SiFileNotYetCompiled,[FileName]));
          exit;
     END;

     {Teste "FileName"}
     IF not TestFileTimes(FileName,exename,Return) THEN
     BEGIN  {EXE steht immer im 'GetOutDir'}
          IF DepMsg THEN WriteMessage(FmtLoadNLSStr(SiFileIsCorrupt,[exename]));
          exit;
     END;

     {Teste Dependency Units}
     IF dep^.ASub <> NIL THEN
     FOR i := 0 TO dep^.ASub.Count-1 DO
     BEGIN
          ppfName := dep^.ASub.Strings[i];
          ppf := PProjectFile(dep^.ASub.Objects[i]);

          FSplit(ppfName,d,n,e);
          UpcaseStr(e);
          IF e = '.PAS' THEN
          BEGIN
               {Vergleiche Source mit m”gl. SPUs und der EXE}
               IF not CompareSourceSpuExeTimes(ppfName,exename)
               THEN SPUInvalid := TRUE;
          END;

          IF e = '.SCU' THEN
          BEGIN
               s := ppfName;
               {Test ob SCU neuer als EXE}
               IF not TestFileTimes(s,exename,Return) THEN SCUInvalid := TRUE;
          END;
     END;

     IF SPUInvalid THEN
     BEGIN
          IF DepMsg THEN WriteMessage(LoadNLSStr(SiSPUInvalid));
          exit;
     END;

     IF SCUInvalid THEN
     BEGIN
          IF DepMsg THEN WriteMessage(LoadNLSStr(SiSCUInvalid));
          exit;
     END;
     Result := TRUE;
END;


FUNCTION AutoSaveEnvironment:BOOLEAN;
BEGIN
     Result := FALSE;
     IF Inspector <> NIL THEN Inspector.WriteBackProperties;

     IF IdeSettings.AutoSave * [as_EditorFiles] <> [] THEN
       IF not SaveFiles(TRUE) THEN exit;

     IF IdeSettings.AutoSave * [as_SCU] <> [] THEN
       IF not SaveSCU THEN exit;

     IF Project.FileName <> '' THEN  //kein geschlossenes Projekt
       IF IdeSettings.AutoSave * [as_Project] <> [] THEN
         IF not SaveProject(FALSE) THEN exit;

     IF IdeSettings.AutoSave * [as_INI] <> [] THEN SaveINI(IdeSettings);

     Result := TRUE;
END;


//kopiert aus Dos.pas
//Parameter: aStartData.InheritOpt:=SSF_INHERTOPT_PARENT;
FUNCTION Exec2(CONST Path: PathStr; CmdLine: STRING):LONGWORD;
type tdata = record
             d1: word;
             d2: word
           end;
VAR
    {$IFDEF OS2}
    aStartData:STARTDATA;
    ObjectBuffer:STRING;
    SessID:LONGWORD;
    SessPID:PID;
    eresult:ExecResultCode;

    tib:PTIB;
    pib:PPIB;
    QueueHandle:HQUEUE;
    PIDS: STRING;
    QUE_NAME:CSTRING;

    Request:REQUESTDATA;         /* Request-identification data */
    DataLength:ULONG;            /* Length of element received */
    DataAddress:POINTER;         /* Address of element received */
    ElementCode:ULONG;           /* Request a particular element */
    NoWait:BOOL;                 /* No wait if queue is empty */
    ElemPriority:BYTE;           /* Priority of element received */

    SEM_NAME:CSTRING;
    SemHandle:HEV;               /* Semaphore handle */
    flAttr:ULONG;                /* Creation attributes */
    fState:BOOLEAN;              /* Initial state of semaphore */
    ulPostCt:LONGWORD;           /* Current post count for the semaphore */

    Queue: QMSG;                  { Message-Queue }
    ahab: hab;

    rc:APIRET;                   /* Return code */
    rdata: ^tdata;
    {$ENDIF}
    {$IFDEF Win32}
    aStartData:StartupInfo;
    aProcessInfo:PROCESS_INFORMATION;
    {$ENDIF}
    c,c1:CSTRING;
BEGIN
     c:=Path;
     c1:=CmdLine;
     {$IFDEF OS2}
     IF ExecViaSession THEN
     BEGIN
          IF NOT AsynchExec THEN
          BEGIN
            DosGetInfoBlocks(tib,pib);
            IF pib=NIL THEN raise EProcessTerm.Create('Can''t retrieve process-id')
            ELSE str(pib^.pib_ulpid,PIDS);
            QUE_NAME:='\QUEUES\TERMQ\'+PIDS+#0;
            rc := DosCreateQueue(QueueHandle,QUE_FIFO OR QUE_CONVERT_ADDRESS,QUE_NAME);
            if rc<>0 THEN raise EProcessTerm.Create('Can''t create exec termination-Queue');
            aStartData.TermQ:=@QUE_NAME;
          END
          ELSE aStartData.TermQ:=NIL;

          aStartData.Length:=sizeof(STARTDATA);
          aStartData.Related:=SSF_RELATED_CHILD;
          aStartData.FgBg:=SSF_FGBG_BACK;
          aStartData.TraceOpt:=SSF_TRACEOPT_NONE;
          aStartData.PgmTitle:=@c;
          aStartData.PgmName:=@c;
          aStartData.PgmInputs:=@c1;
          aStartData.Environment:=NIL;
          aStartData.InheritOpt:=SSF_INHERTOPT_PARENT;
          aStartData.SessionType:=SSF_TYPE_DEFAULT;
          aStartData.IconFile:=NIL;
          aStartData.PgmHandle:=0;
          aStartData.PgmControl:=SSF_CONTROL_VISIBLE;
          aStartData.InitXPos:=0;
          aStartData.InitYPos:=0;
          aStartData.InitXSize:=0;
          aStartData.InitYSize:=0;
          aStartData.Reserved:=0;
          aStartData.ObjectBuffer:=@ObjectBuffer;
          aStartData.ObjectBuffLen:=256;
          DosError:=DosStartSession(aStartData,SessId,SessPid);

          IF DosError<>0 THEN
          BEGIN
            IF NOT AsynchExec THEN
            BEGIN
                rc := DosCloseQueue(QueueHandle);
                if rc<>0 THEN raise EProcessTerm.Create('Can''t close exec termination-Queue');
            END;
            exit;
          END;

          DosSelectSession(SessID);
          IF NOT AsynchExec THEN
          BEGIN
            IF ApplicationType<>1 THEN
            BEGIN
              Request.pid := pib^.pib_ulpid;
              ElementCode := 0;
              NoWait := FALSE;
              SemHandle := 0;
              rc := DosReadQueue(QueueHandle,Request,DataLength,DataAddress,ElementCode,NoWait,ElemPriority,SemHandle);
              if rc<>0 THEN raise EProcessTerm.Create('Can''t read termination-Queue');
              rdata:=DataAddress;
              Result:=rdata^.d2;
              rc := DosFreeMem(DataAddress);
              if rc<>0 THEN raise EProcessTerm.Create('Can''t free QueueData');
              rc := DosCloseQueue(QueueHandle);
              if rc<>0 THEN raise EProcessTerm.Create('Can''t close termination-Queue');
            END
            ELSE
            BEGIN
              SEM_NAME:='\SEM32\TERMQ\'+PIDS+#0;
              flAttr := 0;
              fState := FALSE;
              rc := DosCreateEventSem(SEM_NAME,SemHandle,flAttr,fState);
              if rc<>0 THEN raise EProcessTerm.Create('Can''t create event-semaphore');
              Request.pid := pib^.pib_ulpid;
              ElementCode := 0;
              NoWait := TRUE;
              ahab :=  AppHandle; //WinQueryAnchorBlock(1);
              ulPostCt:=0;
              rc := DosReadQueue(QueueHandle,Request,DataLength,DataAddress,ElementCode,NoWait,ElemPriority,SemHandle);
              IF (rc<>0)AND(rc<>342) THEN raise EProcessTerm.Create('Can''t read termination-Queue');
              WHILE WinGetMsg(ahab,Queue,0,0,0) DO
              BEGIN
                rc := DosQueryEventSem(SemHandle, ulPostCt);
                IF rc<>0 THEN raise EProcessTerm.Create('Can''t query event-semaphore');
                IF ulPostCt>0 THEN BREAK;
                WinDispatchMsg(ahab,Queue);
              END;

              rc := DosCloseEventSem(SemHandle);
              IF rc<>0 THEN raise EProcessTerm.Create('Can''t close event-semaphore');
              rc := DosReadQueue(QueueHandle,Request,DataLength,DataAddress,ElementCode,NoWait,ElemPriority,SemHandle);
              IF rc<>0 THEN raise EProcessTerm.Create('Can''t read termination-Queue');
              rdata:=DataAddress;
              Result:=rdata^.d2;
              rc := DosFreeMem(DataAddress);
              IF rc<>0 THEN raise EProcessTerm.Create('Can''t free QueueData');
              rc := DosCloseQueue(QueueHandle);
              IF rc<>0 THEN raise EProcessTerm.Create('Can''t close termination-Queue');
            END;
          END
          ELSE Result:=SessID;
     END
     ELSE
     BEGIN
          LastExecResult:=0;
          IF AsynchEXEC THEN DosExecPgm(@ObjectBuffer,256,2,c1,
                                        NIL,eresult,c)
          ELSE
          BEGIN
               c1:=#0+c1;
               DosExecPgm(@ObjectBuffer,256,0,c1,
                          NIL,eresult,c);
               LastExecresult:=eresult.CodeResult;
          END;
          Result:=LastExecResult;
     END;
     {$ENDIF}
     {$IFDEF Win32}
     DosError:=0;
     FillChar(aStartData,sizeof(aStartData),0);
     aStartData.cb:=sizeof(aStartData);
     IF not CreateProcess(c,c1,NIL,NIL,FALSE,CREATE_NEW_CONSOLE OR
                          NORMAL_PRIORITY_CLASS,NIL,NIL,
                          aStartData,aProcessInfo) THEN
     BEGIN
          DosError:=1;
          exit;
     END;
     Result:=aProcessInfo.hProcess;
     {$ENDIF}
END;


PROCEDURE Run(viaDebug:BOOLEAN);
VAR  src,exe,param:STRING;
     d,n,e,curdir:STRING;
     cancel:BOOLEAN;
     ret:TMsgDlgReturn;
     Directories:^TDirectories;
     DebugOpt:^TDebuggerOptions;
LABEL NoCompile;
BEGIN
     Case Project.Settings.Platform Of
        pf_Standard:
        Begin
             {$IFDEF OS2}
             Directories:=@Project.Settings.DirectoriesOS2;
             DebugOpt:=@Project.Settings.DebugOptOS2;
             {$ENDIF}
             {$IFDEF WIN32}
             Directories:=@Project.Settings.DirectoriesWin;
             DebugOpt:=@Project.Settings.DebugOptWin;
             {$ENDIF}
        End;
        pf_OS2:
        BEGIN
             Directories:=@Project.Settings.DirectoriesOS2;
             DebugOpt:=@Project.Settings.DebugOptOS2;
        End;
        pf_Win32:
        BEGIN
             Directories:=@Project.Settings.DirectoriesWin;
             DebugOpt:=@Project.Settings.DebugOptWin;
        END;
     End; //case

     IF InDebugger THEN
       IF not DebuggerRunning THEN
     BEGIN
          LastCommandFromSrc := TRUE;
          IF CPUWindow <> NIL THEN CPUWindow.RemarkAllBreaks;
          DebugCommand(DBG_C_GO);
          exit;
     END;
     IF DebuggerRunning THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiProgramAlreadyRunning));
          exit;
     END;

     IF CompilerActive THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiCompilerAlreadyRunning));
          exit;
     END;

     IF not AutoSaveEnvironment THEN exit;
     ClearBuildList;

     src := GetMakeName;
     exe := GetExeName;
     IF not CheckDependencies(src,cancel) THEN
     BEGIN
          IF cancel THEN exit;

          IF IdeSettings.AskRecompile THEN
          BEGIN
               ret := MessageBox(LoadNLSStr(SiFilesOutOfDate)+#13#10+#13#10+
                                 LoadNLSStr(SiRebuildFiles),
                                 mtInformation,mbYesNoCancel);
               CASE ret OF
                 mrYes: ;
                 mrNo: goto NoCompile;
                 mrCancel: exit;
               END;
          END;

          IF not RunCompiler(Action_Make,src) THEN exit;
     END;

NoCompile:
     {Wechseln ins EXE Verzeichnis}
     {$i-}
     GetDir(0,curdir);
     {$i+}
     FSplit(exe,d,n,e);
     NormalizeDir(d);
     {$i-}
     ChangeDir(d);
     {$i+}

     param := Project.Settings.RunParam;
     IF viaDebug THEN
     BEGIN
          HideSibylForms;
          {Programm Parameter auch ndern in SIBYL.PAS (F7,F8,F4)}
          LastCommandFromSrc := TRUE;
          IF CPUWindow <> NIL THEN CPUWindow.RemarkAllBreaks;
          AddSrcDir(Directories^.LibSrcDir);
          AddSrcDir(Directories^.IncSrcDir);
          DbgSetExceptions(DebugOpt^.RTL_Exceptions,DebugOpt^.SPCC_Exceptions);
          LoadDbgProcess(exe,param,Application.MainForm.Handle,
                         Application.MainForm.Frame.Handle,5);
          {Break at start and run again}
          IF not InDebugger THEN
          BEGIN
               ErrorBox(LoadNLSStr(SiErrorLoadingProcess));
               ShowSibylForms;
          END
          ELSE IF SymbolsWindow<>NIL THEN SymbolsWindow.UpdateSymbols;
          SetOptions(DebugOpt^.Options);
     END
     ELSE
     BEGIN
          ClearDebugList;

          {HideSibylForms;}
          Exec2(exe,param);
          {ShowSibylForms;}
     END;
     {$i-}
     ChangeDir(curdir);  //zurck ins alte Verzeichnis
     {$i+}
END;


PROCEDURE Compile;
VAR  s:STRING;
BEGIN
     IF InDebugger THEN exit;

     IF CompilerActive THEN
     BEGIN
          //ErrorBox(LoadNLSStr(SiCompilerAlreadyRunning));
          IF IdeSettings.EnableSound THEN Beep(100,50);
          exit;
     END;

     IF not AutoSaveEnvironment THEN exit;
     ClearBuildList;

     s := GetCompileName;
     IF s = '' THEN exit;

     RunCompiler(Action_Compile,s);
END;


PROCEDURE Make;
VAR  s:STRING;
     cancel:BOOLEAN;
BEGIN
     IF InDebugger THEN exit;

     IF CompilerActive THEN
     BEGIN
          //ErrorBox(LoadNLSStr(SiCompilerAlreadyRunning));
          IF IdeSettings.EnableSound THEN Beep(100,50);
          exit;
     END;

     IF not AutoSaveEnvironment THEN exit;
     ClearBuildList;

     s := GetMakeName;
     IF s = '' THEN exit;

     IF ExistProjectMain(s) THEN {SONST auf jeden Fall Compiler anwerfen}
     BEGIN
          IF CheckDependencies(s,cancel) THEN
          BEGIN
               WriteMessage(LoadNLSStr(SiDependenciesOk));
               exit;
          END
          ELSE IF cancel THEN exit;
     END;

     RunCompiler(Action_Make,s);
END;


PROCEDURE Build;
VAR  s:STRING;
BEGIN
     IF InDebugger THEN exit;

     IF CompilerActive THEN
     BEGIN
          //ErrorBox(LoadNLSStr(SiCompilerAlreadyRunning));
          IF IdeSettings.EnableSound THEN Beep(100,50);
          exit;
     END;

     IF not AutoSaveEnvironment THEN exit;
     ClearBuildList;

     s := GetMakeName;
     IF s = '' THEN exit;

     RunCompiler(Action_Build,s);
END;


PROCEDURE ForceCompile(Action:TCompilerActions;FileName:STRING);
BEGIN
     IF FileName = '' THEN exit;

     IF InDebugger THEN exit;

     IF CompilerActive THEN
     BEGIN
          ErrorBox(LoadNLSStr(SiCompilerAlreadyRunning));
          exit;
     END;

     IF not AutoSaveEnvironment THEN exit;
     ClearBuildList;

     RunCompiler(Action,FileName);
END;



BEGIN
     ComponentSPUDir := '';
     CompilerThread := NIL;
     ForceCompileProc := @ForceCompile;
     StopCompilerProc := @StopCompiler;
END.
