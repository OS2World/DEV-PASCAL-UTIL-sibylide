
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

UNIT DFM;

//Delphi 2.0 Form Import

INTERFACE

USES Dos,SysUtils,Classes,Forms,StdCtrls,Buttons,ExtCtrls,Dialogs,Editors,Graphics,
     Consts,FormEdit,Sib_Ctrl,Sib_Prj,Projects,Inspect,Sib_Edit,Form_Gen,
     ComCtrls,TabCtrls;

PROCEDURE Import;

IMPLEMENTATION

CONST
     Prop_Unsigned  =$80;
     Prop_Signed    =$81;
     Prop_Float     =$82;
     Prop_Class     =$83;
     Prop_String    =$84;
     Prop_Enum      =$85;
     Prop_Set       =$86;
     Prop_Boolean   =$87;
     Prop_Char      =$88;
     Prop_CString   =$89;
     Prop_ClassVar  =$8a;
     Prop_ProcVar   =$8b;
     Prop_FuncVar   =$8c;
     Prop_Record    =$8d;
     Prop_Link      =$8e; //only used for SCU
     Prop_AnsiString=$8f; //bringt Exception


CONST
    FilerSignature: array[1..4] of Char = 'TPF0';

TYPE
    EDFMError=CLASS(Exception);

    TValueType = (vaNull, vaList, vaInt8, vaInt16, vaInt32, vaExtended,
                  vaString, vaIdent, vaFalse, vaTrue, vaBinary, vaSet, vaLString,
                  vaNil, vaCollection);

    TFilerFlag = (ffInherited, ffChildPos);
    TFilerFlags = set of TFilerFlag;

    PLongInt=^LONGINT;

    TMethod=RECORD
                  Code,Data:POINTER;
            END;


TYPE TPublicComponent=CLASS(TComponent)
        PROCEDURE Loaded;OVERRIDE;
        PROCEDURE LoadedFromSCU(SCUParent:TComponent);OVERRIDE;
        PROCEDURE LoadingFromSCU(SCUParent:TComponent);OVERRIDE;
     END;

TYPE
   PPropertyLink=^TPropertyLink;
   TPropertyLink=RECORD
                       Name:STRING;
                       Instance:TObject;
                       WriteKind:BYTE;
                       WriteProc:POINTER;
                       Next:PPropertyLink;
                 END;

VAR PropertyLinks:PPropertyLink;

VAR LastTabbedNoteBook:TTabbedNoteBook;
    LastNoteBook:TNoteBook;
    LastNoteBookHeight:LongInt;

PROCEDURE AddPropertyLink(CONST Name:STRING;Instance:TObject;WriteKind:BYTE;
                                WriteProc:POINTER);
VAR dummy:PPropertyLink;
BEGIN
     New(Dummy);
     Dummy^.Name:=Name;
     Dummy^.Instance:=Instance;
     Dummy^.WriteKind:=WriteKind;
     Dummy^.WriteProc:=WriteProc;
     Dummy^.Next:=PropertyLinks;
     PropertyLinks:=dummy;
END;

PROCEDURE TPublicComponent.Loaded;
BEGIN
     Inherited Loaded;
END;

PROCEDURE TPublicComponent.LoadedFromSCU(SCUParent:TComponent);
BEGIN
     Inherited LoadedFromSCU(SCUParent);
END;

PROCEDURE TPublicComponent.LoadingFromSCU(SCUParent:TComponent);
BEGIN
     Inherited LoadingFromSCU(SCUParent);
END;

VAR LastSCUForm:TForm;

VAR ActNameTable:POINTER;

FUNCTION GetPropInfo(Instance:TObject;CONST FPropName:STRING):POINTER;
VAR
   s,s1:string;
   p:^longint;
   classinfo:^longint;
LABEL again;
BEGIN
     result:=nil;
     s:=FPropName;
     UpcaseStr(s);
     p:=pointer(Instance);
     p:=pointer(p^);       {vmt}
     inc(p,4);
     classInfo:=pointer(p^);       {classInfo}
again:
     p:=classInfo;
     inc(p,12);
     p:=pointer(p^);               {PropertyInfo}
     inc(p,4);
     ActNameTable:=pointer(p^);
     inc(p,4);
     WHILE p^ AND 255<>0 DO
     BEGIN
          move(p^,s1,p^ AND 255+1);  //Property Name
          UpcaseStr(s1);
          IF s1=s THEN {found}
          BEGIN
              inc(p,length(s1)+1+1); {Name+Scope}
              result:=pointer(p^); {Property type info starting with len}
              exit;
          END;

          inc(p,length(s1)+1+1+4);    {Name+Scope+TypeInfo}
     END;

     {try to process parent}
     p:=ClassInfo;
     inc(p,4);
     IF p^<>0 THEN
     BEGIN
          ClassInfo:=pointer(p^);         {Parent vmt}
          inc(ClassInfo,4);
          ClassInfo:=pointer(ClassInfo^); {Parent ClassInfo}
          goto again;
     END;
END;


PROCEDURE GetClassPropertyValue(I: TComponent;VAR Value;PropInfo:POINTER);
VAR p:pointer;
    Fresult:LONGINT;
    Func:FUNCTION(SelfObj:TObject):LONGINT;
    PropReadWriteSpec:^LONGINT;
    ReadKind:BYTE;
    ReadProc:Pointer;
BEGIN
     PropReadWriteSpec:=PropInfo;   {Save this pointer}
     ReadKind:=PropReadWriteSpec^ and 255;    {0-not avail, 1-variable, 2-proc}
     inc(PropReadWriteSpec);
     ReadProc:=pointer(PropReadWriteSpec^);

     IF ReadKind=0 THEN RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_WRITEONLY));

     IF ReadKind=1 THEN {variable}
     BEGIN
          p:=pointer(I);
          inc(p,longword(ReadProc));
          move(p^,Value,4);
     END
     ELSE
     BEGIN  {method}
          IF ReadKind=2 THEN
          BEGIN
               Func:=ReadProc;
               Fresult:=Func(I);
          END
          ELSE
          BEGIN
               ASM
                  PUSH DWORD PTR I
                  MOV EAX,ReadProc
                  CALLN32 SYSTEM.!VmtCall
                  MOV FResult,EAX
               END;
          END;
          move(Fresult,Value,4);
     END;
END;


PROCEDURE SetupDFM(Form:TForm;CONST FileName:STRING);
VAR Stream:TFileStream;

    FUNCTION ReadValue: TValueType;
    BEGIN
         fillchar(result,SizeOf(result),0);
         Stream.Read(Result, 1); {!!}
    END;

    FUNCTION ReadInteger: Longint;
    VAR
       S: Shortint;
       I: Integer;
    BEGIN
         CASE ReadValue of
             vaInt8:
             BEGIN
                  Stream.Read(S, 1);
                  Result := S;
             END;
             vaInt16:
             BEGIN
                  Stream.Read(I,2);
                  Result := I;
             END;
             vaInt32:Stream.Read(Result, SizeOf(Result));
             ELSE Raise EDFMError.Create(LoadNLSStr(SiIllegalIntegerValue));
         END;
    END;

    FUNCTION NextValue: TValueType;
    BEGIN
         Result := ReadValue;
         Stream.Position:=Stream.Position-1;
    END;

    FUNCTION ReadStr: string;
    VAR
        L: Byte;
    BEGIN
         Stream.Read(L, SizeOf(Byte));
         Result[0]:=chr(L);
         Stream.Read(Result[1], L);
         L:=pos('&',Result);
         WHILE L<>0 DO
         BEGIN
              Result[L]:='~';
              L:=Pos('&',result);
         END;
    END;

    PROCEDURE ReadPrefix(VAR Flags: TFilerFlags; VAR AChildPos:LONGINT);
    VAR
       Prefix: Byte;
    BEGIN
         Flags := [];
         IF Byte(NextValue) AND $F0 = $F0 THEN
         BEGIN
              Prefix := Byte(ReadValue);
              Byte(Flags) := Prefix and $0F;
              IF ffChildPos in Flags then AChildPos := ReadInteger;
         END;
    END;

    FUNCTION ReadIdent: string;
    VAR
       L: Byte;
    BEGIN
         CASE ReadValue OF
             vaIdent:
             BEGIN
                  Stream.Read(L, SizeOf(Byte));
                  Result[0]:=chr(L);
                  Stream.Read(Result[1], L);
             END;
             vaFalse:Result := 'False';
             vaTrue:Result := 'True';
             vaNil:Result := 'nil';
             ELSE RAISE EDFMError.Create(LoadNLSStr(SiIllegalIdentValue));
         END;
    END;

    PROCEDURE CheckValue(Value: TValueType);
    BEGIN
         IF ReadValue <> Value THEN RAISE EDFMError.Create(LoadNLSStr(SiValueCheckFailed));
    END;

    FUNCTION ReadChar: Char;
    BEGIN
         CheckValue(vaString);
         Stream.Read(Result, 1);
         IF Ord(Result) <> 1 THEN RAISE EDFMError.Create(LoadNLSStr(SiIllegalChar));
         Stream.Read(Result, 1);
    END;

    FUNCTION ReadFloat: Extended;
    BEGIN
         IF ReadValue = vaExtended THEN Stream.Read(Result, SizeOf(Result))
         ELSE
         BEGIN
              Stream.Position:=Stream.Position-1;
              Result := ReadInteger;
         END;
    END;

    FUNCTION ReadString: string;
    VAR
       L: LONGINT;
    BEGIN
         L := 0;
         CASE ReadValue OF
             vaString:Stream.Read(L, SizeOf(Byte));
             vaLString:Stream.Read(L, SizeOf(LongInt));
             vaIdent:Stream.Read(L, SizeOf(Byte));
             ELSE RAISE EDFMError.Create(LoadNLSStr(SiIllegalString));
         END;
         Result[0]:=chr(L);
         Stream.Read(Result[1], ord(Result[0]));
         L:=pos('&',Result);
         WHILE L<>0 DO
         BEGIN
              Result[L]:='~';
              L:=Pos('&',result);
         END;
    END;

    FUNCTION ReadSet(SetType: Pointer):LONGINT;
    VAR
       EnumName: string;
    BEGIN
         IF ReadValue <> vaSet THEN RAISE EDFMError.Create(LoadNLSStr(SiIllegalSet));
         {???}
         {EnumType := GetTypeData(SetType)^.CompType;}
         Result := 0;
         WHILE True DO
         BEGIN
              EnumName := ReadStr;
              IF EnumName = '' THEN Break;
              {???}
              {Include(TIntegerSet(Result), EnumValue(EnumType, EnumName));}
         END;
    END;

    PROCEDURE SkipPropValue;
    VAR L:LONGINT;
        b:TValueType;
        EnumName:STRING;
        p:POINTER;
    BEGIN
         L:=0;
         b:=ReadValue;
         CASE b OF
            vaNull:;
            vaInt8:Stream.Position:=Stream.Position+1;
            vaInt16:Stream.Position:=Stream.Position+2;
            vaInt32:Stream.Position:=Stream.Position+4;
            vaExtended:Stream.Position:=Stream.Position+10;
            vaString:
            BEGIN
                 Stream.Read(L, SizeOf(Byte));
                 Stream.Position:=Stream.Position+L;
            END;
            vaFalse, vaTrue,vaNIL:;
            vaLString:
            BEGIN
                 Stream.Read(L, SizeOf(LONGINT));
                 Stream.Position:=Stream.Position+L;
            END;
            vaIdent:ReadStr;
            vaSet:
            BEGIN
                 WHILE True DO
                 BEGIN
                      EnumName := ReadStr;
                      IF EnumName = '' THEN Break;
                 END;
            END;
            vaList:
            BEGIN
                 WHILE NextValue<>vaNull DO SkipPropValue;
                 ReadValue;  //overread vaNull
            END;
            vaBinary:
            BEGIN
                 Stream.Read(L,4); //length of binary data
                 GetMem(p,L);
                 Stream.Read(p^,L);
                 FreeMem(p,L);
            END;
            vaCollection:
            BEGIN
                 WHILE NextValue<>vaNull DO
                 BEGIN
                      IF NextValue<>vaList THEN Raise EDFMError.Create(LoadNLSStr(SiIllegalCollection));
                      ReadValue;  //Overrread vaList (1)
                      WHILE NextValue<>vaNull DO
                      BEGIN
                           ReadStr;  //skip property name
                           SkipPropValue;
                      END;
                      ReadValue; //overread vaNull
                 END;
                 ReadValue;  //overread vaNull
            END;
            ELSE
            BEGIN
                 RAISE EDFMError.Create(FmtLoadNLSStr(SiIllegalValueType,[tostr(ord(b))]));
            END;
         END;
    END;

    PROCEDURE ReadPropValue(Instance:TObject;PropInfo: Pointer;CONST PropName:STRING);
    const
      NilMethod: TMethod = (Code: nil; Data: nil);
    var
      PropType: ^longint;
      TypeLen:longword;
      TypeKind:Byte;
      WriteKind:Byte;
      WriteProc:Pointer;
      lll:longint;
      e:Extended;
      ss:shortstring;
      aValue:TValueType;
      s,s1,Params:STRING;
      b:LONGINT;
      p1:^LONGINT;
      ps:^STRING;
      Info:TPropertyTypeInfo;
      Ok:BOOLEAN;

      PROCEDURE SetPropertyValue(I:TObject;CONST value);
      VAR p:^longint;
          Proc:PROCEDURE(Value:LONGWORD;SelfObj:TObject);
          ProcVar:PROCEDURE(Value:POINTER;SelfObj:TObject);
          pb:^LONGWORD;
          pw:^WORD;
          pl:^LONGWORD;
          l:LONGWORD;
          temp:^string;
          tempAnsi:AnsiString;
      BEGIN
         IF WriteKind=1 THEN {Variable}
         BEGIN
              p:=pointer(I);
              inc(p,longword(WriteProc));
              move(Value,p^,TypeLen);
         END
         ELSE {Method}
         BEGIN
              CASE TypeKind OF
                 Prop_AnsiString:
                 BEGIN
                      temp:=@Value;
                      tempAnsi:=temp^;
                      IF WriteKind=2 THEN
                      BEGIN
                           ProcVar:=pointer(WriteProc);
                           ProcVar(@TempAnsi,I);
                      END
                      ELSE
                      BEGIN
                           l:=LONGWORD(WriteProc);
                           ASM
                              LEA EAX,TempAnsi
                              PUSH EAX
                              PUSH DWORD Ptr I
                              MOV EAX,l
                              CALLN32 SYSTEM.!VMTCALL
                           END;
                      END;
                 END;
                 Prop_Signed,Prop_Unsigned,Prop_Class,Prop_Enum,Prop_Boolean,Prop_Char,Prop_ClassVar:
                 BEGIN
                      Proc:=pointer(WriteProc);
                      CASE TypeLen OF
                        1:
                        BEGIN
                             pb:=@Value;
                             l:=pb^;
                        END;
                        2:
                        BEGIN
                             pw:=@Value;
                             l:=pw^;
                        END;
                        4:
                        BEGIN
                             pl:=@Value;
                             l:=pl^;
                        END
                        ELSE RAISE EDFMError.Create(LoadNLSStr(SiIllegalIntegerSize));  //no valid type size for VAL
                      END; {case}

                      IF WriteKind=2 THEN
                      BEGIN
                           Proc(l,I);
                      END
                      ELSE
                      BEGIN
                           ASM
                              PUSH DWORD PTR l
                              PUSH DWORD PTR I
                              MOV EAX,Proc
                              CALLN32 SYSTEM.!VMTCALL
                           END;
                      END;
                 END;
                 Prop_Float,Prop_String,Prop_Set,Prop_CString,Prop_Record,Prop_ProcVar,Prop_FuncVar:
                 BEGIN
                      IF WriteKind=2 THEN
                      BEGIN
                           ProcVar:=pointer(WriteProc);
                           ProcVar(@Value,I);
                      END
                      ELSE
                      BEGIN
                           l:=LONGWORD(WriteProc);
                           ASM
                              MOV EAX,Value
                              PUSH EAX
                              PUSH DWORD PTR I
                              MOV EAX,l
                              CALLN32 SYSTEM.!VMTCALL
                           END;
                      END;
                 END;
                 ELSE RAISE EDFMError.Create(LoadNLSStr(SiIllegalPropertyType));  //no valid type
              END; {case}
         END;
      END;

      FUNCTION GetIntIdent(PropInfo: Pointer; CONST Ident: STRING;VAR ok:BOOLEAN):longint;
      VAR
        t,Start,Ende: Longint;
        ss,ss1: string;
        PropType:^longint;
        TypeLen:longint;
        TypeKind:Byte;
        pss:^String;
      BEGIN
        ss := Ident;
        UpcaseStr(ss);
        Ok:=FALSE;

        IF ((ss='BSNONE')OR(ss='BSSINGLE')OR(ss='BSSIZEABLE')OR(ss='BSDIALOG')) THEN
          ss:='F'+ss;  {fbsNone,fbsSingle,fbsSizeable,fbsDialog}

        PropType:=PropInfo;
        //Skip read and write access infos
        IF PropType^ AND 255<>0 THEN inc(PropType,5)
        ELSE inc(PropType);
        IF PropType^ AND 255<>0 THEN inc(PropType,5)
        ELSE inc(PropType);

        TypeLen:=PropType^;
        inc(PropType,4);
        TypeKind:=PropType^ AND 255;
        inc(PropType);

        IF TypeKind=Prop_Enum THEN
        BEGIN
             Start:=PropType^;
             inc(PropType,4);
             Ende:=PropType^;
             inc(PropType,4);
             FOR t:=Start TO Ende DO
             BEGIN
                  pss:=pointer(ActNameTable);
                  inc(pss,PropType^);
                  inc(PropType,4);
                  ss1:=pss^;
                  UpcaseStr(ss1);
                  IF ss=ss1 THEN
                  BEGIN
                       result:=t;
                       Ok:=TRUE;
                       exit;
                  END;
             END;
        END
        ELSE
        BEGIN
            WHILE PropType^<>0 DO
            BEGIN
                 pss:=pointer(ActNameTable);
                 inc(pss,PropType^);
                 inc(PropType,4);
                 ss1:=pss^;
                 UpcaseStr(ss1);
                 IF ss=ss1 THEN
                 BEGIN
                      result:=PropType^;
                      Ok:=TRUE;
                      exit;
                 END;
                 inc(PropType,4);  //overread value
            END;
        END;

        ErrorBox(FmtLoadNLSStr(SiIllegalIdent,[Ident]));
      END;


      PROCEDURE SetObjectIdent(Instance: TObject; PropInfo: Pointer;CONST Ident: string);
      VAR
        RootName, Name: string;
        P: Integer;
      BEGIN
        RootName := '';
        Name := Ident;
        P := Pos('.', Ident);
        IF P <> 0 THEN
        BEGIN
          RootName := Copy(Ident, 1, P - 1);
          Name := Copy(Ident, P + 1, MaxInt);
        END;

        AddPropertyLink(Name,Instance,WriteKind,WriteProc);
      END;

    BEGIN
      PropType:=PropInfo;

      IF not Instance.GetPropertyTypeInfo(PropName,Info) THEN RAISE EDFMError.Create('PropertyTypeInfo not found');

      TypeLen:=Info.Size;
      TypeKind:=Info.Typ;

      WriteKind:=Info.Write.Kind; {0-not avail, 1-variable, 2-proc, 3-VMT proc}
      WriteProc:=pointer(Info.Write.VarOffset);

    {?????}
      CASE TypeKind OF
        Prop_Signed,Prop_Unsigned:
        BEGIN
          Ok:=TRUE;
          IF NextValue = vaIdent THEN lll:=GetIntIdent(PropInfo, ReadIdent,Ok)
          ELSE lll:=ReadInteger;
          IF ok THEN
          BEGIN
              IF WriteKind=0 THEN RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_WRITEONLY));
              SetPropertyValue(Instance,lll);
          END;
        END;
        Prop_Boolean:
        BEGIN
          aValue:=ReadValue;
          IF aValue=vaFalse THEN lll:=0
          ELSE IF aValue=vaTrue THEN lll:=1
          ELSE RAISE EDFMError.Create(LoadNLSStr(SiIllegalBoolean));
          IF WriteKind=0 THEN RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
          SetPropertyValue(Instance,lll);
        END;
        Prop_Char:
        BEGIN
          lll:=ord(ReadChar);
          IF WriteKind=0 THEN RAISE EDFMError.Create('');
          SetPropertyValue(Instance,lll);
        END;
        Prop_Enum:
        BEGIN
          lll:=GetIntIdent(PropInfo,ReadIdent,Ok);
          IF Ok THEN
          BEGIN
             IF WriteKind=0 THEN RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
             SetPropertyValue(Instance, lll);
          END;
        END;
        Prop_Float:
        BEGIN
          e:=ReadFloat;
          IF WriteKind=0 THEN RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
          SetPropertyValue(Instance, e);
        END;
        Prop_String,Prop_AnsiString:
        BEGIN
          ss := ReadString;
          IF WriteKind=0 THEN RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
          SetPropertyValue(Instance, ss);
        END;
        Prop_Set:
        BEGIN
          lll:=ReadSet(PropType);
          IF WriteKind=0 THEN RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
          SetPropertyValue(Instance, lll);
        END;
        Prop_Class:
        BEGIN
          CASE NextValue of
            {
            vaNIL:
            BEGIN
            END;
            }
            vaIdent:
            BEGIN
               IF WriteKind=0 THEN RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
               SetObjectIdent(Instance, PropInfo, ReadIdent);
            END;
            ELSE SkipPropValue;
          END; //case
        END;
        Prop_ProcVar,Prop_FuncVar:
        BEGIN
          IF NextValue = vaNil THEN
          BEGIN
            ReadValue;
            IF WriteKind=0 THEN RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
            //SetPropertyValue(Instance, NilMethod);
          END
          ELSE
          BEGIN
            s:=ReadIdent;
            IF WriteKind=0 THEN RAISE EDFMError.Create(LoadNLSStr(SiERR_PROP_READONLY));
            //IF Instance.IDESCU_Data=NIL THEN New(PIDESCU_Data(Instance.IDESCU_Data));

            p1:=PropType;

            //Skip read and write access infos
            IF p1^ AND 255<>0 THEN inc(p1,5)
            ELSE inc(p1);
            IF p1^ AND 255<>0 THEN inc(p1,5)
            ELSE inc(p1);
            inc(p1,4);
            inc(p1);

            b:=p1^;
            inc(p1,4);  //Name (Index)
            Params:='';
            WHILE b<>0 DO
            BEGIN
                 IF Params<>'' THEN Params:=Params+';';
                 ps:=ActNameTable+b;
                 s1:=ps^;

                 b:=p1^ AND 255;
                 inc(p1);
                 CASE b OF
                    1:s1:=Key(_VAR_)+' '+s1;
                    2:;
                    3:s1:=Key(_CONST_)+' '+s1;
                 END;

                 Params:=Params+s1;
                 b:=p1^;         //TypeName
                 inc(p1,4);      //Name (Index)
                 IF b<>0 THEN
                 BEGIN
                      ps:=ActNameTable+b;
                      s1:=ps^;
                      Params:=Params+':'+s1;
                 END;

                 b:=p1^;
                 inc(p1,4);  //Name (Index)
            END; //while

            IF Params='' THEN Params:=';'
            ELSE Params:='('+Params+');';
            InsertMethodValid(LastSCUForm,TControl(Instance),PropName,s,Params);
          END;
        END;
      END;
    END;

    PROCEDURE ReadBitmap(Instance,Component:TComponent;PropName:STRING);
    VAR Bitmap:TBitmap;
        Len:LONGINT;
        p:Pointer;
        Info:TPropertyTypeInfo;
        s:string;
    BEGIN
         ReadValue;           //skip vaBinary
         Stream.Read(Len,4);  //Binary data len

         IF Component IS TImage THEN
         BEGIN
              //skip bitmap name
              s:=ReadStr;
              PropName:='Picture';
         END
         ELSE s:='';

         IF ((Instance IS TIcon)OR(s='TIcon')) THEN Len:=766
         ELSE Stream.Read(Len,4);  //Bitmap len
         GetMem(p,Len);
         Stream.Read(p^,Len);

         IF ((Instance IS TIcon)OR(s='TIcon')) THEN Bitmap:=TIcon.Create
         ELSE Bitmap.Create;

         TRY
            Bitmap.LoadFromMem(p^,Len);
         EXCEPT
            ErrorBox(LoadNLSStr(SiIncompatibleIconBitmapFormat));
            Bitmap.Destroy;
            Bitmap:=NIL;
         END;

         FreeMem(p,Len);
         IF not Component.GetPropertyTypeInfo(PropName,Info) THEN exit;

         CASE Info.Write.Kind OF
             1:
             BEGIN
                  p:=pointer(Component);
                  inc(p,longword(Info.Write.VarOffset));
                  move(Bitmap,p^,4);
             END;
             2,3:CallWriteProp(Component,Pointer(Info.Write.VarOffset),Info.Typ,
                               4,@Bitmap);
         END; {case}

         IF Bitmap<>NIL THEN Bitmap.Destroy;
    END;

    PROCEDURE ReadStringList(List:TStrings);
    BEGIN
         ReadValue;           //skip vaList
         IF ((NextValue<>vaString)AND(NextValue<>vaLString)) THEN
         BEGIN
              Stream.Position:=Stream.Position-1;
              SkipPropValue;
         END
         ELSE
         BEGIN
              List.BeginUpdate;
              WHILE NextValue<>vaNull DO List.Add(ReadString);
              List.EndUpdate;
              ReadValue;           //skip vaNull
         END;
    END;

    PROCEDURE ReadCollection(Collection:TCollection);
    VAR PropName:STRING;
        Item:TCollectionItem;
        PropInfo: POINTER;
        Col:TValueType;
    BEGIN
         Col:=ReadValue;           //skip vaCollection

         IF Col=vaList THEN
         BEGIN
              WHILE NextValue<>vaNull DO
              BEGIN
                   Item:=Collection.Add;

                   TRY
                     IF Item<>NIL THEN PropInfo := GetPropInfo(Item,'Text')
                     ELSE PropInfo:=NIL;
                   EXCEPT
                     PropInfo:=NIL;
                   END;


                   IF PropInfo<>NIL THEN ReadPropValue(Item,PropInfo,'Text')
                   ELSE SkipPropValue;
              END;
         END
         ELSE WHILE NextValue<>vaNull DO
         BEGIN
              IF NextValue<>vaList THEN Raise EDFMError.Create(LoadNLSStr(SiIllegalCollection));

              ReadValue;  //skip vaList

              WHILE NextValue<>vaNull DO
              BEGIN
                   Item:=Collection.Add;

                   PropName:=ReadStr;  //get Property Name

                   TRY
                     IF Item<>NIL THEN PropInfo := GetPropInfo(Item,PropName)
                     ELSE PropInfo:=NIL;
                   EXCEPT
                     PropInfo:=NIL;
                   END;


                   IF PropInfo<>NIL THEN ReadPropValue(Item,PropInfo,PropName)
                   ELSE SkipPropValue;
              END;

              ReadValue;  //skip vaNull
         END;
         ReadValue;  //skip vaNull
    END;

    PROCEDURE ReadProperty(Component:TComponent;VAR Left,Top,Width,Height:LONGINT);
    VAR PropPath:STRING;
        I,L,J:LONGINT;
        Instance:TComponent;
        FPropName:STRING;
        PropInfo: POINTER;
        PropValue: TObject;
        TypeKind:^Byte;
        Info:TPropertyTypeInfo;
    LABEL lab1;
    BEGIN
         PropPath:=ReadStr;
         I:=1;
         L:=Length(PropPath);
         Instance:=Component;
         WHILE True DO
         BEGIN
              J := I;
              WHILE (I <= L) AND (PropPath[I] <> '.') DO Inc(I);
              FPropName := Copy(PropPath, J, I - J);
              IF I > L THEN Break;

              PropInfo := GetPropInfo(Component,FPropName);
              IF PropInfo=NIL THEN
              BEGIN
                   Instance:=NIL;
                   break;
              END;

              PropValue:=NIL;
              TypeKind:=PropInfo;

              //Skip access infos
              IF TypeKind^<>0 THEN inc(TypeKind,5)
              ELSE inc(TypeKind);
              IF TypeKind^<>0 THEN inc(TypeKind,5)
              ELSE inc(TypeKind);
              inc(TypeKind,4);   {overread type len}

              IF TypeKind^ = Prop_Class THEN
              BEGIN
                   GetClassPropertyValue(Instance, PropValue,PropInfo);
              END;

              IF not (PropValue IS TComponent) THEN
              BEGIN
                   IF ((TObject(PropValue) IS TStrings)AND(NextValue=vaList)) THEN
                   BEGIN
                       ReadStringList(TStrings(PropValue));
                       exit;
                   END
                   ELSE
                   BEGIN
                       Instance:=NIL;
                       break;
                   END;
              END
              ELSE IF PropValue IS TCollection THEN
              BEGIN
                   ReadCollection(TCollection(PropValue));
                   exit;
              END;
              Instance := TComponent(PropValue);
              Inc(I);
         END;

         TRY
            IF Instance<>NIL THEN PropInfo := GetPropInfo(Instance,FPropName)
            ELSE PropInfo:=NIL;
         EXCEPT
            PropInfo:=NIL;
         END;

         IF ((Instance=NIL)OR(Instance.Name='Font')) THEN
         BEGIN
              IF Instance IS TFont THEN
              BEGIN
                   IF FPropName='Color' THEN
                   BEGIN
                        Instance:=Component;
                        FPropName:='PenColor';
                        IF Instance.GetPropertyTypeInfo(FPropName,Info) THEN
                        BEGIN
                             ActNameTable:=Info.NameTable;
                             PropInfo:=Info.PropInfo;
                             goto lab1;
                        END;
                   END;
              END;

              SkipPropValue;
         END
         ELSE IF Instance IS TBitmap THEN
         BEGIN
              IF ((FPropName='Data')AND(NextValue=vaBinary)) THEN
              BEGIN
                   ReadBitmap(Instance,Component,'Glyph');
              END
              ELSE SkipPropValue;
         END
         ELSE IF ((Instance IS THeaderControl)OR(Instance IS TStatusBar)) THEN
         BEGIN
              IF ((FPropName='Panels')AND(Instance IS TStatusBar)) THEN
              BEGIN
                   ReadCollection(TStatusBar(Instance).Panels);
                   exit;
              END
              ELSE IF ((FPropName='Sections')AND(Instance IS THeaderControl)) THEN
              BEGIN
                   ReadCollection(THeaderControl(Instance).Sections);
                   exit;
              END;

              IF PropInfo<>NIL THEN goto lab1
              ELSE SkipPropValue;
         END
         ELSE IF PropInfo <> NIL THEN
         BEGIN
              IF Instance IS TControl THEN
              BEGIN
lab1:
                   IF FPropName='Left' THEN Left:=ReadInteger
                   ELSE IF FPropName='Top' THEN Top:=ReadInteger
                   ELSE IF FPropName='Width' THEN Width:=ReadInteger
                   ELSE IF FPropName='Height' THEN
                   BEGIN
                        Height:=ReadInteger;
                        If ((Component IS TNoteBook)Or(Component IS TTabbedNoteBook)) THEN
                         LastNoteBookHeight:=Height;
                   END
                   ELSE IF FPropName='ClientWidth' THEN
                   BEGIN
                        IF Instance IS TForm THEN
                        BEGIN
                             ASM
                                PUSH DWORD PTR Instance
                                CALLN32 Forms._GetAddWidth_
                                MOV I,EAX
                             END;
                             Width:=I+ReadInteger;
                        END
                        ELSE Width:=ReadInteger;
                   END
                   ELSE IF FPropName='ClientHeight' THEN
                   BEGIN
                        IF Instance IS TForm THEN
                        BEGIN
                             ASM
                                PUSH DWORD PTR Instance
                                CALLN32 Forms._GetAddHeight_
                                MOV I,EAX
                             END;
                             Height:=I+ReadInteger;
                        END
                        ELSE Height:=ReadInteger;
                   END
                   ELSE ReadPropValue(Instance,PropInfo,FPropName)
              END
              ELSE ReadPropValue(Instance,PropInfo,FPropName);
         END
         ELSE
         BEGIN
              //read positions, it might be a reference...
              IF NextValue IN [vaInt8,vaInt16,vaInt32] THEN
              BEGIN
                  IF FPropName='Left' THEN Left:=ReadInteger
                  ELSE IF FPropName='Top' THEN Top:=ReadInteger
                  ELSE IF FPropName='Width' THEN Width:=ReadInteger
                  ELSE IF FPropName='Height' THEN
                  BEGIN
                       Height:=ReadInteger;
                       If ((Component IS TNoteBook)Or(Component IS TTabbedNoteBook)) THEN
                         LastNoteBookHeight:=Height;
                  END
                  ELSE SkipPropValue;
              END
              ELSE SkipPropValue;
         END;
    END;


    PROCEDURE ReadState(Component:TComponent;Owner:TComponent);
    VAR
        Left,Top,Width,Height:LONGINT;
        ComponentClass:TComponentClass;
        ReferenceControl:TControl;

        PROCEDURE SetBounds2(Control:TControl;Left,Top,Width,Height:LONGINT);
        VAR  Parent:TControl;
             Bottom:LONGINT;
             ParentClientHeight:LONGINT;
        BEGIN
             IF not (Control IS TControl) THEN exit;
             Parent := TControl(Owner);

             IF Parent IS TPage THEN
             BEGIN
                  IF ((LastTabbedNoteBook<>NIL)OR(LastNoteBook<>NIL)) THEN
                  BEGIN
                       {IF LastTabbedNoteBook<>NIL THEN
                          ParentClientHeight:=LastTabbedNoteBook.PageRect.Top-LastTabbedNoteBook.PageRect.Bottom
                       ELSE
                          ParentClientHeight:=LastNoteBook.ClientRect.Top-LastNoteBook.ClientRect.Bottom;
                       }
                       //subtract NoteBookMargin and TabHeight (hard coded in TabCtrls)
                       ParentClientHeight:=LastNoteBookHeight-10-25;
                  END
                  ELSE
                  BEGIN
                       IF Parent IS TControl THEN ParentClientHeight := Parent.ClientHeight
                       ELSE ParentClientHeight := Screen.Height;
                  END;
             END
             ELSE
             BEGIN
                 IF Parent IS TControl THEN ParentClientHeight := Parent.ClientHeight
                 ELSE ParentClientHeight := Screen.Height;
             END;

             Bottom := ParentClientHeight - Height - Top;
             Control.SetWindowPos(Left,Bottom-1,Width,Height);
        END;

    BEGIN
         Left:=10;
         Top:=200;
         Width:=440;
         Height:=340;
         TRY
           WHILE NextValue<>vaNull DO ReadProperty(Component,Left,Top,Width,Height);

           IF not (Component IS TControl) THEN
             IF ((not (Component IS TComponent))OR(Component.ComponentState*[csReference]<>[])) THEN
               IF Owner IS TControl THEN
           BEGIN
               ComponentClass:=SearchClassByName('TReferenceWindow');

               ReferenceControl:=TControl(ComponentClass.Create(Owner));
               Include(ReferenceControl.ComponentState,csDesigning);
               Include(ReferenceControl.ComponentState,csReferenceControl);
               ASM
                  PUSH DWORD PTR ReferenceControl
                  PUSH DWORD PTR Component
                  CALLN32 Classes.SetReference
               END;
               ReferenceControl.Parent:=TControl(Owner);
               Width:=ReferenceControl.Width;
               Height:=ReferenceControl.Height;
               Component:=TComponent(ReferenceControl);
           END;
         FINALLY
               IF Component IS TControl THEN
               BEGIN
      //              TControl(Component).SetBounds2(Left,Top,Width,Height);
                    SetBounds2(TControl(Component),Left,Top,Width,Height);
                    TForm(Component).Font:=Screen.SmallFont; {typecast to have access to Font}
               END;
         END;
         CheckValue(vaNull);
    END;

    PROCEDURE SkipProperty;
    BEGIN
         ReadStr; { Skips property name }
         SkipPropValue;
    END;

    PROCEDURE SkipComponent(SkipHeader: Boolean);
    VAR
       Flags: TFilerFlags;
       Position: LONGINT;
    BEGIN
         IF SkipHeader THEN
         BEGIN
              ReadPrefix(Flags, Position);
              ReadStr;
              ReadStr;
         END;
         WHILE NextValue<>vaNull DO SkipProperty;
         CheckValue(vaNull);
         WHILE NextValue<>vaNull DO SkipComponent(True);
         CheckValue(vaNull);
    END;


    FUNCTION ReadComponent(Owner: TComponent): TComponent;
    VAR
       CompClass, CompName: string;
       Flags: TFilerFlags;
       Position:LONGINT;
       TheClass:TComponentClass;
       Component:TComponent;

       FUNCTION ComponentCreated: Boolean;
       BEGIN
            Result := not (ffInherited in Flags) AND (Component = nil);
       END;

       FUNCTION Recover(VAR Component: TComponent): Boolean;
       BEGIN
            Result := False;
            IF ComponentCreated THEN Component.Free;
            Component := nil;
            SkipComponent(False);
            Result := TRUE;
       END;

       PROCEDURE CreateComponent;
       BEGIN
            TRY
               TheClass := TComponentClass(SearchClassByName(CompClass));
               IF TheClass=NIL THEN RAISE EDFMError.Create(FmtLoadNLSStr(SiCompClassNotFound,[CompClass]));
               Result := TheClass.Create(LastSCUForm);
               Include(Result.ComponentState,csDesigning);
               TPublicComponent(Result).LoadingFromSCU(Owner);
               Component:=Result;
            EXCEPT
               ON E:Exception DO
               BEGIN
                   IF not Recover(Result) THEN
                   BEGIN
                        raise;
                   END
                   ELSE ErrorBox(FmtLoadNLSStr(SiConvertError,[E.Message]));
               END;
            END;
       END;

       PROCEDURE SetCompName;
       BEGIN
            TRY
               Result.Name:=CompName;
            EXCEPT
               IF not Recover(Result) THEN raise;
            END;
       END;

       BEGIN
            ReadPrefix(Flags, Position);
            CompClass := ReadStr;
            CompName := ReadStr;
            Result := NIL;
            Component:=NIL;
            CreateComponent;

            IF Result <> nil THEN
            BEGIN
                 TRY
                    IF Result IS TTabbedNoteBook THEN
                    BEGIN
                         LastTabbedNoteBook:=TTabbedNoteBook(result);
                         LastTabbedNoteBook.ShowPageHint:=False;
                    END;
                    IF Result IS TNoteBook THEN LastNoteBook:=TNoteBook(result);

                    IF not (ffInherited in Flags) THEN SetCompName;
                    IF Result = nil THEN Exit;
                    ReadState(Result,Owner);
                 EXCEPT
                    IF ComponentCreated THEN Result.Free;
                    RAISE;
                 END;


                 TRY
                    WHILE NextValue<>vaNull DO ReadComponent(result);
                 EXCEPT
                    IF Owner IS TControl THEN
                      IF result IS TControl THEN
                        TControl(Owner).InsertControl(TControl(result));
                    RAISE;
                 END;

                 IF Owner IS TControl THEN
                   IF result IS TControl THEN
                      TControl(Owner).InsertControl(TControl(result));

                 CheckValue(vaNull);

                 TPublicComponent(result).LoadedFromSCU(Owner);
                 TPublicComponent(result).Loaded;
            END;
       END;

VAR
   Flags:TFilerFlags;
   Position:LONGINT;
   Signature:LONGINT;
   DFMDataLen:LONGINT;
   TypName:STRING;
BEGIN
     LastTabbedNoteBook:=NIL;
     LastNoteBook:=NIL;
     LastNoteBookHeight:=0;
     TRY
        Stream:=NIL;
        FileMode:=fmInput;
        Stream:=TFileStream.Create(FileName,Stream_Open);
        FileMode:=fmInOut;

        Stream.Position:=Stream.Position+3;  //skip 3 Byte header
        WHILE ReadValue<>vaNull DO ;         //Skip name
        Stream.Position:=Stream.Position+2;  //skip $3010
        Stream.Read(DFMDataLen,sizeof(DFMDataLen));
        //we are now at TPF0

        Stream.Read(Signature,sizeof(Signature));
        IF Signature<>LONGINT(FilerSignature) THEN RAISE EDFMError.Create('Illegal signature');

        ReadPrefix(Flags,Position);
        TypName:=ReadStr;              //TypeName (TFORM1)
        Form.Name:=ReadStr;            //Name (Form1)
        ReadState(Form,NIL);
        WHILE NextValue<>vaNull DO ReadComponent(Form);
        CheckValue(vaNull);
     FINALLY
        IF Stream<>NIL THEN Stream.Destroy;
     END;
END;

PROCEDURE HandlePropertyLinks(Form:TForm);
VAR Next:PPropertyLink;
    p:POINTER;
    Proc:PROCEDURE(Value:LONGWORD;SelfObj:TObject);
    Instance:TObject;
    Component:TComponent;
    t:LONGINT;
BEGIN
     WHILE PropertyLinks<>NIL DO
     BEGIN
        FOR t:=0 TO Form.ComponentCount-1 DO
        BEGIN
             Component:=Form.Components[t];
             IF Component.Name=PropertyLinks^.Name THEN
             BEGIN
                  IF PropertyLinks^.WriteKind=1 THEN {Variable}
                  BEGIN
                       p:=pointer(PropertyLinks^.Instance);
                       inc(p,longword(PropertyLinks^.WriteProc));
                       move(Component,p^,4);
                  END
                  ELSE {Method}
                  BEGIN
                      Proc:=pointer(PropertyLinks^.WriteProc);
                      Instance:=PropertyLinks^.Instance;

                      IF PropertyLinks^.WriteKind=2 THEN
                      BEGIN
                           Proc(LongWord(Component),Instance);
                      END
                      ELSE
                      BEGIN
                           ASM
                              PUSH DWORD PTR Component
                              PUSH DWORD PTR Instance
                              MOV EAX,Proc
                              CALLN32 SYSTEM.!VMTCALL
                           END;
                      END;
                  END;
             END;
        END;
        Next:=PropertyLinks^.Next;
        Dispose(PropertyLinks);
        PropertyLinks:=Next;
     END;
END;

FUNCTION ImportDFM(dfmName:STRING; VAR UnitName:STRING):TForm;
VAR  d,n,e:STRING;
     Add:LONGINT;
BEGIN
     Result := NIL;
     PropertyLinks:=NIL;

     FSplit(dfmName,d,n,e);
     UnitName := d + n + '.PAS';
     IF not FileExists(UnitName) THEN
     BEGIN
          ErrorBox(FmtLoadNLSStr(SiCouldNotFindRelUnit,[UnitName]));
          exit;
     END;

     Result := FormEditClass.Create(NIL);
     Include(Result.ComponentState,csDesigning);
     LastSCUForm:=Result;
     TPublicComponent(Result).LoadingFromSCU(NIL);
     TRY
        SetupDFM(Result,dfmName);
     EXCEPT
        ON Ex:Exception DO ErrorBox(FmtLoadNLSStr(SiConvertError,[Ex.Message]));
     END;
     Include(Result.DesignerState,dsAutoCreate); //all Delphi forms are auto-created !
     HandlePropertyLinks(Result);
     TPublicComponent(Result).LoadedFromSCU(NIL);
     TPublicComponent(Result).Loaded;

     IF Result.Menu<>NIL THEN
     BEGIN
          IF Result.Menu.Handle<>0 THEN Add:=Result.Menu.Height
          ELSE Add:=Screen.SystemMetrics(smCyMenu);

          //Realign controls because client height changed
          Result.Height:=Result.Height+Add;
     END;
END;


TYPE
    TSelectSCUDlg=CLASS(TDialog)
         FListBox:TListBox;
         PROCEDURE SetupComponent;OVERRIDE;
    END;

PROCEDURE TSelectSCUDlg.SetupComponent;
BEGIN
     Inherited SetupComponent;

     Caption := LoadNLSStr(SiSelectAFormToImport);
     ClientWidth := 350;
     ClientHeight := 250;

     FListBox := InsertListBox(SELF,20,70,310,160,'');
     FListBox.Focus;

     InsertBitBtnNLS(SELF,20,20,90,30,bkOk,SOkButton,SClickHereToAccept);
     InsertBitBtnNLS(SELF,130,20,90,30,bkCancel,SCancelButton,SClickHereToCancel);
     InsertBitBtnNLS(SELF,240,20,90,30,bkHelp,SHelpButton,SClickHereToGetHelp);
END;

FUNCTION ImportSCU(SCUName:STRING;VAR UnitName:STRING):TForm;
VAR  Stream:TMemoryStream;
     Dlg:TSelectSCUDlg;
     dummy:PSCUFileFormat;
     p,p1:^LONGINT;
     s,s1:STRING;
     SaveSCU:POINTER;
     t:LONGINT;
LABEL Found;
BEGIN
     Result := NIL;

     TRY
        SaveSCU := SCUPointer;
        Stream.Create;
        Stream.LoadFromFile(SCUName);

        Dlg.Create(NIL);
        Dlg.HelpContext := hctxDialogSelectSCU;

        dummy := Pointer(Stream.Memory);

        //This modifies SCUPointer
        ASM
           PUSH DWORD PTR dummy
           CALLN32 SYSTEM.AddSCUData
        END;

        dummy:=SCUPointer;
        WHILE dummy<>NIL DO
        BEGIN
             p := Pointer(dummy);
             inc(p,dummy^.ObjectOffset);
             FOR t := 1 TO dummy^.ObjectCount DO
             BEGIN
                  p1 := p;

                  inc(p,4);
                  inc(p,(p^ AND 255)+1);            //overread inspector class name
                  System.Move(p^,s,(p^ AND 255)+1); //runtime class name
                  Dlg.FListBox.Items.Add(s);

                  p := p1;
                  inc(p,p^);
             END;

             dummy:=dummy^.NextEntry;
        END;

        IF Dlg.FListBox.Items.Count > 0 THEN Dlg.FListBox.ItemIndex := 0;

        IF (Dlg.Execute) AND (Dlg.FListBox.ItemIndex >= 0) THEN
        BEGIN
             s1:=Dlg.FListBox.Items[Dlg.FListBox.ItemIndex];

             dummy:=SCUPointer;
             WHILE dummy<>NIL DO
             BEGIN
                  p := Pointer(dummy);
                  inc(p,dummy^.ObjectOffset);
                  FOR t := 1 TO dummy^.ObjectCount DO
                  BEGIN
                       p1 := p;

                       inc(p,4);
                       inc(p,(p^ AND 255)+1);            //overread inspector class name
                       System.Move(p^,s,(p^ AND 255)+1); //runtime class name
                       IF s=s1 THEN
                       BEGIN
                            SCUPointer:=dummy; {!!}
                            dummy^.UseEntry:=t-1;
                            goto found;
                       END;

                       p := p1;
                       inc(p,p^);
                  END;

                  dummy:=dummy^.NextEntry;
             END;
found:
             IF dummy<>NIL THEN
             BEGIN
                  Result := FormEditClass.Create(NIL);
                  {Result.ReadFromStream(Stream); bringt Exception}
                  UnitName := Result.UnitName;

                  IF not FileExists(UnitName) THEN
                  BEGIN
                       ErrorBox(FmtLoadNLSStr(SiCouldNotFindRelUnit,[UnitName]));
                  END;
             END;
        END;
        Dlg.Destroy;

     EXCEPT
        IF Result <> NIL THEN Result.Destroy;
        Result := NIL;
        ErrorBox(LoadNLSStr(SiLoadError));
     END;
     Stream.Destroy;
     SCUPointer := SaveSCU;
END;


PROCEDURE Import;
VAR FOD:TOpenDialog;
    ret:BOOLEAN;
    s,d,n,e:STRING;
    UnitName:STRING;
    Form:TForm;
BEGIN
     FOD.Create(NIL);
     FOD.HelpContext := hctxDialogOpenDFMSCU;
     FOD.Caption := LoadNLSStr(SiImportSibylDelphiForm);
     FOD.FileName := '';
     FOD.AddFilter(LoadNLSStr(SiAllFormFiles)+' (*.dfm;*.scu)','*.DFM;*.SCU');
     FOD.AddFilter(LoadNLSStr(SiSibylFormFiles)+' (*.scu)','*.SCU');
     FOD.AddFilter(LoadNLSStr(SiDelphiFormFiles)+' (*.dfm)','*.DFM');
     FOD.DefaultExt := GetDefaultExt('*.DFM;*.SCU');
     ret := FOD.Execute;
     s := FOD.FileName;
     FOD.Destroy;
     Screen.Update;
     IF not ret THEN exit;

     FSplit(s,d,n,e);
     UpcaseStr(e);
     IF e = '.DFM' THEN Form := ImportDFM(s,UnitName) {UnitName ist VAR}
     ELSE Form := ImportSCU(s,UnitName);

     IF Form = NIL THEN exit;

     IF GenImportForm(Form,UnitName,NIL,0) THEN
     BEGIN
          GenUpdateDFM(Form);

          Project.Modified := TRUE;
          Project.SCUModified := TRUE;
          Project.NeedRecompile := TRUE;

          Form.Show;
          Form.Focus;
     END
     ELSE Form.Destroy;  {Form konnte nicht importiert werden}
END;



END.
