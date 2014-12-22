
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

UNIT SIB_DLL;

INTERFACE


FUNCTION LoadDLL(Name:STRING):LONGWORD;
FUNCTION FreeDLL(VAR Handle:LONGWORD):BOOLEAN;
FUNCTION GetDLLProcAddress(Handle:LONGWORD;CONST ProcName:STRING):POINTER;


IMPLEMENTATION

{$IFDEF OS2}
USES BseDos;
{$ENDIF}
{$IFDEF Win32}
USES WinBase;
{$ENDIF}


FUNCTION LoadDLL(Name:STRING):LONGWORD;
{$IFDEF OS2}
VAR  c:CSTRING;
{$ENDIF}
BEGIN
     {$IFDEF OS2}
     IF DosLoadModule(c,255,Name,Result) <> 0 THEN Result := 0;
     {$ENDIF}
     {$IFDEF Win32}
     Result := LoadLibrary(Name);
     {$ENDIF}
END;


FUNCTION FreeDLL(VAR Handle:LONGWORD):BOOLEAN;
BEGIN
     Result := FALSE;
     {$IFDEF OS2}
     IF Handle <> 0 THEN Result := DosFreeModule(Handle) = 0;
     {$ENDIF}
     {$IFDEF Win32}
     IF Handle <> 0 THEN Result := FreeLibrary(Handle);
     {$ENDIF}
     IF Result THEN Handle := 0;
END;


FUNCTION GetDLLProcAddress(Handle:LONGWORD;CONST ProcName:STRING):POINTER;
VAR  c:CSTRING;
BEGIN
     c := ProcName;
     {$IFDEF OS2}
     IF DosQueryProcAddr(Handle,0,c,Result) <> 0 THEN Result := NIL;
     {$ENDIF}
     {$IFDEF Win32}
     Result := GetProcAddress(Handle,c);
     {$ENDIF}
END;



INITIALIZATION
END.

