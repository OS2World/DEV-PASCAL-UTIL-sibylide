LIBDIR=..\rtl;..\spcc;..\addon
CFLAGS=-D -O0
!include "..\pascal"

all: sibyl.exe spdbg25.dll spc25.exe

spc25.exe: spc25.pas Spc_data.spu Projects.spu
 @if exist spc25.exe del spc25.exe
 spc20 spc25.pas $(OUTDIR) $(LIBDIR) $(INCDIR) -O0 $(CFLAGS) -T2
 @if not exist spc25.exe copy nothing nul 1> nul 2>&1 

spdbg25.dll: spdbg25.pas dbghelp.spu

sibyl.exe: \
 addutils.spu \
 baseedit.spu \
 baseform.spu \
 browser.spu \
 compiler.spu \
 consts.spu \
 dasm.spu \
 dbghelp.spu \
 dbgwatch.spu \
 debughlp.spu \
 dfm.spu \
 disasm.spu \
 formedit.spu \
 form_gen.spu \
 idetools.spu \
 inspect.spu \
 navigate.spu \
 parseobj.spu \
 projects.spu \
 propedit.spu \
 sib_comp.spu \
 sib_ctrl.spu \
 sib_dlg.spu \
 sib_dll.spu \
 sib_edit.spu \
 sib_prj.spu \
 spc_data.spu \
 treelist.spu \
 winlist.spu \
 Sibyl.pas \
 Sibyl.Srf \
 Sib_Eng.srf \
 Sib_Ger.srf

addutils.spu: addutils.pas
baseedit.spu: baseedit.pas dasm.spu consts.spu
baseform.spu: baseform.pas Projects.spu Sib_prj.spu
browser.spu: browser.pas Consts.spu Projects.spu Sib_Ctrl.spu Sib_Prj.spu BaseForm.spu Sib_Edit.spu Compiler.spu TreeList.spu
compiler.spu: compiler.pas SPC_Data.spu Consts.spu Projects.spu Sib_Prj.spu BaseForm.spu Sib_Edit.spu Inspect.spu DAsm.spu DebugHlp.spu DisAsm.spu DbgWatch.spu
consts.spu: consts.pas
dasm.spu: dasm.pas
dbghelp.spu: dbghelp.pas
dbgwatch.spu: dbgwatch.pas DAsm.spu DebugHlp.spu Consts.spu BaseEdit.spu Sib_Ctrl.spu sib_ctrl.pas Projects.spu consts.spu
debughlp.spu: debughlp.pas DAsm.spu Consts.spu BaseEdit.spu Sib_Ctrl.spu Projects.spu
dfm.spu: dfm.pas Consts.spu FormEdit.spu Sib_Ctrl.spu Sib_Prj.spu Projects.spu Inspect.spu Sib_Edit.spu Form_Gen.spu
disasm.spu: disasm.pas Consts.spu DAsm.spu BaseEdit.spu DebugHlp.spu DbgWatch.spu Projects.spu BaseForm.spu Sib_Prj.spu Sib_Ctrl.spu 
formedit.spu: formedit.pas Consts.spu Projects.spu Sib_Prj.spu BaseForm.spu Navigate.spu Inspect.spu Form_Gen.spu Sib_Edit.spu IdeTools.spu
form_gen.spu: form_gen.pas Consts.spu Projects.spu Sib_Edit.spu Sib_Prj.spu ParseObj.spu
idetools.spu: idetools.pas Consts.spu Projects.spu Sib_Prj.spu Sib_Ctrl.spu Sib_Edit.spu Form_Gen.spu
inspect.spu: inspect.pas Consts.spu Projects.spu Sib_Prj.spu Sib_Ctrl.spu Form_Gen.spu PropEdit.spu BaseForm.spu Sib_Edit.spu
navigate.spu: navigate.pas Consts.spu Projects.spu Sib_Ctrl.spu Sib_Prj.spu BaseForm.spu Sib_Comp.spu 
parseobj.spu: parseobj.pas Sib_Prj.spu
projects.spu: projects.pas log.spu
propedit.spu: propedit.pas Sib_Ctrl.spu
sib_comp.spu: sib_comp.pas Consts.spu Sib_Ctrl.spu Sib_Prj.spu Sib_Edit.spu Compiler.spu Form_Gen.spu IdeTools.spu Sib_Dll.spu
sib_ctrl.spu: sib_ctrl.pas consts.spu
sib_dlg.spu: sib_dlg.pas Consts.spu Sib_Ctrl.spu Projects.spu Sib_Prj.spu Form_Gen.spu FormEdit.spu Sib_Edit.spu Inspect.spu BaseForm.spu BaseEdit.spu Dfm.spu Compiler.spu DebugHlp.spu Dasm.spu
sib_dll.spu: sib_dll.pas
sib_edit.spu: sib_edit.pas SPC_Data.spu Consts.spu Projects.spu Sib_Prj.spu ParseObj.spu Sib_Ctrl.spu BaseForm.spu BaseEdit.spu WinList.spu AddUtils.spu DebugHlp.spu DAsm.spu DbgWatch.spu DisAsm.spu
sib_prj.spu: sib_prj.pas Consts.spu Projects.spu BaseEdit.spu Sib_Ctrl.spu DebugHlp.spu DbgWatch.spu
spc_data.spu: spc_data.pas
treelist.spu: treelist.pas
winlist.spu: winlist.pas Consts.spu Projects.spu Sib_Prj.spu BaseForm.spu

Sibyl.Srf: Sibyl.rc
Sib_Eng.srf: Sib_Eng.rc Sibyl.inc
Sib_Ger.srf: Sib_Ger.rc Sibyl.inc