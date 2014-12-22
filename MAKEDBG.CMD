set beginlibpath=d:\sibyl2\bin
d:\sibyl2\bin\spc20.exe log.pas . ..\lib2.0 . -O0 
d:\sibyl2\bin\spc20.exe dbghelp.pas . ..\lib2.0 . -O0 
d:\sibyl2\bin\spc20.exe spdbg25.pas . ..\lib2.0 . -O0 
del spdbg20.dll
dllrname spdbg25.dll spdbg25=spdbg20
