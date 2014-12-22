
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

PROGRAM Sibyl;

{$SCU}

{$m 256000,33554432}

{$IFDEF OS2}
USES Os2Def,PMWin,BseDos,BseExcpt;
{$ENDIF}

{$IFDEF Win32}
USES WinDef,WinUser;
{$ENDIF}


USES SysUtils,Messages,Dos,Classes,Forms,Graphics,Buttons,StdCtrls,ExtCtrls,
     FileCtrl,Dialogs,ComCtrls,Grids,Outline,MMedia,DBCtrls,DbBase,Editors,
     TabCtrls,Printers,DockTool;

USES Consts,Projects,BaseEdit,Sib_Prj,BaseForm,Sib_Edit,Navigate,Inspect,
     FormEdit,Form_Gen,Sib_Dlg,Compiler,Sib_Comp,Browser,WinList,
     ToolsApi,IdeTools,ListView,DbLayer,DFM,Sib_Ctrl,Mask,
     ColorGrd,DualList,CheckLB,XplorBtn,EditList,DDEMan,Calendar,
     Chart,Clocks,CoolBar,BmpList,DirOutLn,GlyphBtn,Gradient,Hints,Led,
     ScktComp,Seven,Spin;

{$IFDEF OS2}
Uses INet
{$ENDIF};

Uses DAsm,DebugHlp,DisAsm,DbgWatch;

{$R sibyl}

// {$DEFINE German}

{$IFDEF German}
{$R Sib_Ger}
{$ELSE}
{$R Sib_Eng}
{$ENDIF}

Const
   CM_SIBYLTRACE = $17773; // Added AaronL to try compile...

TYPE
    TMyForm=CLASS(TSibylForm)
         FMinMaxCount:INTEGER;
         Speedbar:TToolbar;
         SpeedPanel:TPanel;
         VDEinitialized:BOOLEAN;
         PROCEDURE CMTrace(VAR Msg:TMessage); message CM_SIBYLTRACE;
         PROCEDURE CMTrace1(VAR Msg:TMessage); message CM_SIBYLTRACE+1;
         PROCEDURE CMTrace2(VAR Msg:TMessage); message CM_SIBYLTRACE+2;
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE SetupShow;OVERRIDE;
         PROCEDURE Resize;OVERRIDE;
         PROCEDURE Close;OVERRIDE;
         PROCEDURE InsertControl(AControl:TControl);OVERRIDE;
         PROCEDURE RemoveControl(AControl:TControl);OVERRIDE;
         PROCEDURE SetBounds(NewLeft,NewTop,NewWidth,NewHeight:LONGINT);OVERRIDE;
         PROCEDURE SetMenuState(Command:TCommand; State:BOOLEAN);
         FUNCTION  GetCommandState(parent,command:TCommand):BOOLEAN;
         PROCEDURE UpdateMenuEntries(parent:TCommand);
         PROCEDURE MenuInit(AMenu:TMenu;Entry:TMenuItem);OVERRIDE;
         PROCEDURE EvSibylIdle(Sender:TObject;VAR Done:BOOLEAN);
         FUNCTION  MainWindowHeight:LONGINT;
         PROCEDURE SpeedbarResize(Sender:TObject);
         PROCEDURE BuildSpeedbar;
         PROCEDURE InsertSpeedbar;
         PROCEDURE RemoveSpeedbar;
         PROCEDURE UpdateSpeedbar;
         PROCEDURE InsertNavigator;
         PROCEDURE RemoveNavigator;
         PROCEDURE SetMinMaxSize(Value:BOOLEAN);
         PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
         PROCEDURE TranslateShortCut(Keycode:TKeyCode;VAR Receiver:TForm);OVERRIDE;
         PROCEDURE EvMainFormMinimize(Sender:TObject);
         PROCEDURE EvMainFormRestore(Sender:TObject);
         PROCEDURE EvSpeedBtnDown(Sender:TObject;Button:TMouseButton;
                                  ShiftState:TShiftState;X,Y:LONGINT);
         PROCEDURE EvSpeedBtnUp(Sender:TObject;Button:TMouseButton;
                                  ShiftState:TShiftState;X,Y:LONGINT);
         PROCEDURE EvShowHint(Sender:TObject);
         PROCEDURE EvTranslateShortCut(Sender:TObject;KeyCode:TKeyCode;VAR Receiver:TForm);
         PROCEDURE EvSpeedButtonDestroyed(Sender:TObject);
         PROCEDURE EvPalettenPopup(Sender:TObject);
         PROCEDURE InformFromDebugger(VAR Msg:TMessage); message WM_SEM1;
         PROCEDURE ProgramReset;
         PROCEDURE UnloadProcess;
         PROCEDURE ScanEvent(VAR KeyCode:TKeyCode;RepeatCount:BYTE);OVERRIDE;
         FUNCTION  MapSystemKeystroke(Key:TKeyCode):BOOLEAN;
         FUNCTION  EmulateWordStar(Key:TKeyCode):BOOLEAN;
         FUNCTION  EmulateCUA(Key:TKeyCode):BOOLEAN;
         FUNCTION  EmulateDefault(Key:TKeyCode):BOOLEAN;
    END;


VAR
    MyMainForm:TMyForm;

CONST
    EnableResize:BOOLEAN=TRUE;
    LastMenuHeight:LONGINT=0;


PROCEDURE InitToolbars;
BEGIN
     EnableResize := FALSE;
     {force}
     IF Project.Settings.ProjectType = pt_Visual
     THEN Include(IdeSettings.StaticToolbars, st_CompPalette);

     IF st_Speedbar IN IdeSettings.StaticToolbars THEN MyMainForm.InsertSpeedbar
     ELSE MyMainForm.RemoveSpeedbar;

     IF st_CompPalette IN IdeSettings.StaticToolbars THEN
     BEGIN
          IF Project.Settings.ProjectType = pt_Visual THEN MyMainForm.InsertNavigator
          ELSE Exclude(IdeSettings.StaticToolbars, st_CompPalette);
     END
     ELSE MyMainForm.RemoveNavigator;

     EnableResize := TRUE;
     MyMainForm.Resize;
END;


{Trace Message von einer Applikation}
PROCEDURE TMyForm.CMTrace(VAR Msg:TMessage);
VAR  psm:PString;
BEGIN
     IF not InDebugger THEN exit;

     psm := PString(Msg.Param1);
     IF psm <> NIL THEN
     BEGIN
          {$IFDEF OS2}
          IF AccessSharedMem(psm) THEN
          BEGIN
               CodeEditor.DebugTrace(psm^);
               {Referenz auf das Shared Memory Objekt wieder freigeben}
               FreeSharedMem(psm, Length(psm^)+1);
          END;
          {$ENDIF}
     END;
END;


CONST
   AppMemList:TList=NIL;
   AppMemMax:LONGWORD=0;

PROCEDURE TMyForm.CMTrace1(VAR Msg:TMessage);
BEGIN
exit;
     IF not InDebugger THEN exit;

     AppMemList.Add(POINTER(Msg.Param1));
     inc(AppMemMax);
END;


PROCEDURE TMyForm.CMTrace2(VAR Msg:TMessage);
BEGIN
exit;
     IF not InDebugger THEN exit;

     AppMemList.Remove(POINTER(Msg.Param1));
END;


{assume, that MainMenu is available}
FUNCTION TMyForm.MainWindowHeight:LONGINT;
VAR  AToolbar:TToolbar;
     i:LONGINT;
BEGIN
     {+1 damit immer ein Resize Event kommt}
     Result := 2 * Screen.SystemMetrics(smCySizeBorder) +
               Screen.SystemMetrics(smCyTitlebar) +1;

     IF Menu.Handle <> 0 THEN inc(Result,Menu.Height)
     ELSE inc(Result,Screen.SystemMetrics(smCyMenu));

     IF (Speedbar <> NIL) OR (Navigator <> NIL) THEN inc(Result,TopToolbarSize);

     {summiere die H”he aller weiteren DockingToolbars}
     FOR i := 0 TO ControlCount-1 DO
     BEGIN
          AToolbar := TToolbar(Controls[i]);
          IF AToolbar IS TToolbar THEN
            IF AToolbar.Alignment = tbBottom THEN inc(Result, AToolbar.Size);
     END;
END;


PROCEDURE TMyForm.InsertControl(AControl:TControl);
VAR  ATop:LONGINT;
     NewHeight:LONGINT;
BEGIN
     IF VDEinitialized AND (not Project.Loading) THEN
     BEGIN
          SetMinMaxSize(FALSE);
          ATop := Top;
          NewHeight := MainWindowHeight;

          IF (Speedbar = NIL) AND (Navigator = NIL) AND
             (((AControl IS TToolbar) AND (TToolbar(AControl).Alignment = tbLeft)) OR
              (AControl IS TNavigator)) THEN inc(NewHeight, TopToolbarSize);

          IF (AControl IS TToolbar) AND (TToolbar(AControl).Alignment = tbBottom)
          THEN inc(NewHeight, TToolbar(AControl).Size);

          Hide;
          SetBounds(Left,ATop,Width,NewHeight);

          Inherited InsertControl(AControl);

          Show;
          SetMinMaxSize(TRUE);
     END
     ELSE Inherited InsertControl(AControl);
END;

PROCEDURE TMyForm.RemoveControl(AControl:TControl);
VAR  ATop:LONGINT;
BEGIN
     IF not (csDestroying IN ComponentState) THEN
     BEGIN
          //das Resizen verursacht GPF in Win32

          {$IFDEF OS2}
          SetMinMaxSize(FALSE);
          ATop := Top;
          {$ENDIF}

          Inherited RemoveControl(AControl);

          {$IFDEF OS2}
          SetBounds(Left,ATop,Width,MainWindowHeight);
          {$ENDIF}

          {$IFDEF OS2}
          SetMinMaxSize(TRUE);
          {$ENDIF}

     END
     ELSE Inherited RemoveControl(AControl);
END;


{$HINTS OFF}
PROCEDURE TMyForm.SpeedbarResize(Sender:TObject);
BEGIN
     IF Speedbar <> NIL THEN
       IF IdeSettings.SpeedbarWidth <> Speedbar.Width THEN
       BEGIN
            IdeSettings.SpeedbarWidth := Speedbar.Width;
            IdeSettings.Modified := TRUE;
       END;
END;
{$HINTS ON}


PROCEDURE TMyForm.BuildSpeedbar;
VAR  t:BYTE;
     yoffs,xoffs:LONGINT;

PROCEDURE InsertToolButton(VAR x,y:LONGINT; Command:TCommand);
VAR  SpeedBtn:TXPLButton;
BEGIN
     SpeedBtn := TXPLButton(AddPalettenItem(SpeedPanel, Command));
     IF SpeedBtn <> NIL THEN
     BEGIN
          Exclude(SpeedBtn.ComponentState, csDetail); {send command to form}
          SpeedBtn.OnDestroy := EvSpeedButtonDestroyed;
          SpeedBtn.OnMouseDown := EvSpeedBtnDown;
          SpeedBtn.OnMouseUp := EvSpeedBtnUp;

          SpeedBtn.SetWindowPos(x,y,SpeedBtn.Width,SpeedBtn.Height);
          inc(x, SpeedBtn.Width);
     END;
END;


BEGIN
     IF SpeedPanel <> NIL THEN exit;

     SpeedPanel.Create(SELF);
     SpeedPanel.Align := alClient;
     SpeedPanel.Caption := '';

     xoffs := 6;
     yoffs := 6;
     FOR t := 0 TO BottomToolButtonList.Count-1 DO       {untere Reihe}
     BEGIN
          IF LONGINT(BottomToolButtonList[t]) <> cmNull THEN
          BEGIN
               InsertToolButton(xoffs,yoffs, LONGINT(BottomToolButtonList[t]));
          END
          ELSE inc(xoffs,5);
     END;

     xoffs := 6;
     inc(yoffs,SpeedButtonSize);
     FOR t := 0 TO TopToolButtonList.Count-1 DO       {obere Reihe}
     BEGIN
          IF LONGINT(TopToolButtonList[t]) <> cmNull THEN
          BEGIN
               InsertToolButton(xoffs,yoffs, LONGINT(TopToolButtonList[t]));
          END
          ELSE inc(xoffs,5);
     END;
END;


PROCEDURE TMyForm.InsertSpeedbar;
BEGIN
     IF Speedbar <> NIL THEN exit;
     IF SpeedPanel = NIL THEN exit;

     Screen.Cursor := crHourglass;

     Speedbar.Create(SELF);
     Speedbar.Alignment := tbLeft;
     Speedbar.Size := IdeSettings.SpeedbarWidth;
     Speedbar.BevelStyle := tbRaised;
     Speedbar.Sizeable := TRUE;
     Speedbar.OnResize := SpeedbarResize;
     Speedbar.PopupMenu := PalettenPopup;

     SpeedPanel.Parent := Speedbar;

     InsertControl(Speedbar);
     SpeedPanel.Invalidate;
     Update;
     Screen.Cursor := crDefault;
END;


PROCEDURE TMyForm.RemoveSpeedbar;
VAR  Toolbar:TToolbar;
BEGIN
     IF Speedbar = NIL THEN exit;
     IF SpeedPanel = NIL THEN exit;

     Screen.Cursor := crHourglass;

     SpeedPanel.Parent := NIL;

     Toolbar := Speedbar;
     Speedbar := NIL;
     Toolbar.Destroy;  {setze vorher Speedbar = NIL wegen AlignToolbars}
     SpeedbarResize(NIL);

     Update;
     Screen.Cursor := crDefault;
END;


PROCEDURE TMyForm.EvSpeedButtonDestroyed(Sender:TObject);
VAR  i:LONGINT;
     Cmd:TCommand;
BEGIN
     IF Sender IS TSpeedButton THEN
     BEGIN
          Cmd := TSpeedButton(Sender).Command;
          i := CommandToIndex(Cmd);
          IF i <> -1 THEN MenuEntries[i].Btn := NIL;
     END;
END;


PROCEDURE TMyForm.UpdateSpeedbar;
BEGIN
     IF Speedbar = NIL THEN exit;

     RemoveSpeedbar;
     InsertSpeedbar;
END;


PROCEDURE TMyForm.InsertNavigator;
BEGIN
     IF Navigator <> NIL THEN exit;

     Screen.Cursor := crHourglass;

     InitNavigator(SELF);

     Invalidate;

     IF ComponentViewer <> NIL THEN
     BEGIN
          ComponentViewer.ClearListBox;
          ComponentViewer.FillListBox;
     END;
     Update;
     Screen.Cursor := crDefault;
END;


PROCEDURE TMyForm.RemoveNavigator;
VAR  Nav:TControl;
BEGIN
     IF Navigator = NIL THEN exit;

     Screen.Cursor := crHourglass;

     Nav := Navigator;
     Navigator := NIL;
     Nav.Destroy; {setze vorher Navigator = NIL wegen AlignToolbars}

     Update;
     Screen.Cursor := crDefault;
END;


PROCEDURE RemoveNavigator;
BEGIN
     MyMainForm.RemoveNavigator;
END;


PROCEDURE RegisterDefaultComponents;
BEGIN
     RegisterClasses([TMainMenu,TPopupMenu,TMenuItem,TControl]);

     RegisterClasses([TComponent,TClipBoard,TFont,TCanvas,
       TToolBar,TForm,TTimer,TMenu,TPopupMenu,TScreen,TGraphic,TBitmap,
       TIcon,TPointer,TButton,TRadioButton,TCheckBox,TBitBtn,TSpeedButton,
       TScrollBar,TComboBox,TListBox,TEdit,TGroupBox,TRadioGroup,TTimer,
       TImage,TShape,TProgressBar,TValueSet,TLabel,TOutline,TListView,TMemo,
       TFileListBox,TDriveComboBox,TDirectoryListBox,TFilterComboBox,
       TStringGrid,TGrid,TStrings,TStringList,TList,TReferenceWindow,TThread,
       TOpenDialog,TSaveDialog,TCreateDirDialog,TChangeDirDialog,TFindDialog,
       TReplaceDialog,TColorDialog,TDialog,TFontDialog,TPrintDialog,
       TPrinterSetupDialog, TClassPropertyEditor,TPropertyEditor,
       TVideoWindow,TMediaPlayer,TVideoDevice,TAudioDevice,TBevel,TPanel,
       TMCIDevice,TCDDevice,TVolumeControl,TAnimatedButton,TDBGrid,TTable,
       TDataSource,TDataSet,TDBEdit,TDBImage,TDBMemo,TDBNavigator,TDBText,
       TDBCheckBox,TQuery,TIExpert,TUpDown,TTrackBar,TStringSelectList,
       TDdeServerConv,TDdeServerItem,TDdeClientConv,TDdeClientItem,
       TNotebook,TPage,TTabSet,TTabbedNotebook,TPaintBox,TStatusBar,
       TSizeBorder,THeaderControl,THeaderSections,TDrawGrid,TDockingToolbar,
       TDBListBox,TDBComboBox,TDBRadioGroup,TDBGridColumns,
       TTabPage,TPageControl,TTabSheet,THeader,TImageList,TMaskEdit,
       TSystemOpenDialog,TSystemSaveDialog,TStoredProc,TScrollBox]);
     {Samples}
     RegisterClasses([TColorGrid,TDualList,TCheckListBox,TExplorerButton,
       TEditListBox,TBitmapListBox,TCustomHint,TBalloonHint,TSpinButton,
       TSpinEdit,TPieChart,TDBPieChart,TBarChart,TDBBarChart,
       TServerSocket,TClientSocket,{$IFDEF OS2}THTTPBrowser,TFTP,TTCP,TUDP,{$ENDIF}
       TCalendar,TAnalogClock,TDirectoryOutline,TGlyphButton,
       TOnOffSwitch,TGradient,TSevenSegDisplay,TLed,TCoolBar]);
END;



PROCEDURE TMyForm.SetMinMaxSize(Value:BOOLEAN);
BEGIN
     IF Handle = 0 THEN exit;
     IF not EnableResize THEN exit;

     IF Value THEN inc(FMinMaxCount)
     ELSE dec(FMinMaxCount);

     IF FMinMaxCount > 0 THEN
     BEGIN
          MinTrackHeight := Height;
          MaxTrackHeight := Height;
          MinTrackWidth := IdeSettings.SpeedbarWidth + 150;
          MaxTrackWidth := Screen.Width;
     END
     ELSE
     BEGIN
          MinTrackHeight := 0;
          MaxTrackHeight := MaxInt;
          MinTrackWidth := 0;
          MaxTrackWidth := MaxInt;
     END;
END;


PROCEDURE TMyForm.SetBounds(NewLeft,NewTop,NewWidth,NewHeight:LONGINT);
BEGIN
     IF not EnableResize THEN exit;
     Inherited SetBounds(NewLeft,NewTop,NewWidth,NewHeight);
END;


PROCEDURE TMyForm.SetMenuState(Command:TCommand; State:BOOLEAN);
VAR  i:LONGINT;
     Entry:TMenuItem;
BEGIN
     i := CommandToIndex(Command);
     IF i <> -1 THEN
     BEGIN
          Entry := MenuEntries[i].Menu;
          IF Entry <> NIL THEN Entry.Enabled := State;
     END;
END;

// Function returns whether a specific command is available or not,
// depending on what is currently happening (compiling, etc).
FUNCTION TMyForm.GetCommandState(parent,command:TCommand):BOOLEAN; {2 Params for faster access}
VAR
  TopEdit:TSibEditor;
  TopDesign:TFormEditor;
  visual:BOOLEAN;
BEGIN
  {folgende Kriterien sind generell mit einzubeziehen}
  // ProjectLoaded - es ist ein Projekt aktiv (bei Make CompLib ist zB keins aktiv)
  // InDebugger - Debugger Session luft
  // DebuggerRunning - Applikation im Debugger luft gerade
  // CompilerActive - Compiler luft
  // TopEdit - Aktives Editor Fenster
  // visual - das aktuelle Projekt ist ein visuelles Projekt

  TopEdit := CodeEditor.TopEditor;
  visual := Project.Settings.ProjectType = pt_Visual;


  CASE parent OF
    cmFileMenu:
    BEGIN
      CASE command OF
        cmNewObject: Result := ProjectLoaded;
        cmNew: Result := ProjectLoaded;
        cmOpen: Result := ProjectLoaded;
        cmInsertFile: Result := (TopEdit <> NIL) AND (not TopEdit.ReadOnly);
        cmSave: Result := (TopEdit <> NIL);
        cmSaveAs: Result := (TopEdit <> NIL);
        cmSaveAll: Result := (TopEdit <> NIL);
        cmPrint:
        BEGIN
             IF Printer<>NIL THEN
             BEGIN
                  Result := (TopEdit <> NIL) AND (Printer.Printers.Count > 0) AND (not Printer.Printing);
             END
             ELSE Result:=FALSE;
        END;
        cmCreateDir: Result := TRUE;
        cmChangeDir: Result := TRUE;
        cmExit: Result := ProjectLoaded;
      END;
    END;

    cmEditMenu:
    BEGIN
      IF LastFocusedForm IS TFormEditor THEN
      BEGIN
        TopDesign := TFormEditor(LastFocusedForm);

        CASE command OF
          cmSlidingUndo: Result := FALSE;
          cmRedo: Result := FALSE;
          cmCut: Result := (TopDesign.SelectList.Count > 0);
          cmCopy: Result := (TopDesign.SelectList.Count > 0);
          cmPaste: Result := ClipBoard.IsFormatAvailable(cfComponents);
          cmDelete: Result := (TopDesign.SelectList.Count > 0);
          cmSelectAll: Result := (TopDesign.ControlCount > 0);
          cmDeselectAll: Result := (TopDesign.SelectList.Count > 0);
          cmMacroRecord: Result := FALSE;
          cmMacroPlay: Result := FALSE;
          cmMacroSave: Result := FALSE;
        END;
      END
      ELSE
      BEGIN
        CASE command OF
          cmSlidingUndo: Result := (TopEdit <> NIL) AND (TopEdit.UndoCount > 0);
          cmRedo: Result := (TopEdit <> NIL) AND (TopEdit.RedoCount > 0);
          cmCut: Result := (TopEdit <> NIL) AND (TopEdit.Selected);
          cmCopy: Result := (TopEdit <> NIL) AND (TopEdit.Selected);
          cmPaste: Result := (TopEdit <> NIL) AND (ClipBoard.IsFormatAvailable(cfText));
          cmDelete: Result := (TopEdit <> NIL) AND (TopEdit.Selected);
          cmSelectAll: Result := (TopEdit <> NIL);
          cmDeselectAll: Result := (TopEdit <> NIL) AND (TopEdit.Selected);
          cmMacroRecord: Result := (TopEdit <> NIL) AND (not TopEdit.MacroPlaying);
          cmMacroPlay: Result := (TopEdit <> NIL) AND (not TopEdit.MacroPlaying) AND (not TopEdit.MacroRecording) AND (CodeEditor.MacroList <> NIL);
          cmMacroSave: Result := ProjectLoaded AND (CodeEditor.MacroList <> NIL);
        END;
      END;
    END;

    cmSearchMenu:
    BEGIN
      CASE command OF
        cmFind: Result := (TopEdit <> NIL);
        cmReplace: Result := (TopEdit <> NIL);
        cmSearchAgain: Result := (TopEdit <> NIL) AND (LastFindAction IN [faFind,faReplace]);
        cmIncrementalSearch: Result := (TopEdit <> NIL) AND (LastFindAction <> faIncSearch);
        cmMatchingBrace: Result := (TopEdit <> NIL);
        cmFindInFiles: Result := TRUE;
        cmGotoLine: Result := (TopEdit <> NIL);
        cmGotoLastError: Result := (ErrName <> '');
        cmBookmarks: Result := ProjectLoaded;
      END;
    END;


    cmViewMenu:
    BEGIN
      CASE command OF
        cmProjectManager: Result := ProjectLoaded;
        cmViewBrowser: Result := ProjectLoaded;
        cmWindowList: Result := ProjectLoaded;
        cmMacroList: Result := ProjectLoaded;
        cmClipBoardList: Result := ProjectLoaded;
        cmViewInspector: Result := ProjectLoaded AND visual;
        cmViewComponents: Result := ProjectLoaded AND visual;
        cmViewAlign: Result := ProjectLoaded AND visual;
        cmFormUnit: Result := ProjectLoaded AND visual;
        cmNewForm: Result := ProjectLoaded AND visual;
        cmImport: Result := ProjectLoaded AND visual;
        cmToggleSpeedbar: Result := ProjectLoaded;
        cmToggleNavigator: Result := ProjectLoaded AND visual;
        cmToggleStatusbar: Result := ProjectLoaded;
      END;
    END;
    cmComponentMenu:
    BEGIN
      CASE command OF
        cmNewComponent: Result := ProjectLoaded;
        cmInstallComponents: Result := ProjectLoaded AND (not CompilerActive) AND (not InDebugger);
        cmRemoveComponents: Result := ProjectLoaded AND (not CompilerActive) AND (not InDebugger);
        cmOpenCompLib: Result := ProjectLoaded AND (not CompilerActive) AND (not InDebugger);
        cmRecompileCompLib: Result := ProjectLoaded AND (not CompilerActive) AND (not InDebugger) AND (GetCompLibName <> '');
        cmConfigurePalette: Result := ProjectLoaded AND visual;
        cmLoadTemplateForms: Result := ProjectLoaded AND visual;
        cmSaveTemplateForms: Result := ProjectLoaded AND visual;
        cmViewRepository: Result := ProjectLoaded;
        cmAddToRepository: Result := ProjectLoaded AND visual AND (Project.Forms.Count > 0);
      END;
    END;

    cmDebugMenu:
    BEGIN
      CASE command OF
        cmToggleBreakPoint: Result := ProjectLoaded AND (TopEdit <> NIL);
        cmClearAllBreakPoints: Result := ProjectLoaded AND (BreakpointList.BreakCount > 0) AND (not DebuggerRunning);
        cmGo: Result := ProjectLoaded AND (not CompilerActive) AND (not DebuggerRunning);
        cmGotoDebugCursor: Result := ProjectLoaded AND (not CompilerActive) AND (not DebuggerRunning) AND (TopEdit <> NIL);
        cmStepOver: Result := ProjectLoaded AND (not CompilerActive) AND (not DebuggerRunning);
        cmStepInto: Result := ProjectLoaded AND (not CompilerActive) AND (not DebuggerRunning);
        cmReturnFromFunction: Result := ProjectLoaded AND (not DebuggerRunning) AND InDebugger;
        cmProgramReset: Result := ProjectLoaded AND InDebugger;
        cmProgramReload: Result := ProjectLoaded AND InDebugger;
        cmEvaluateModify: Result := ProjectLoaded AND (not DebuggerRunning) AND InDebugger;
        cmAddWatch: Result := ProjectLoaded AND (not DebuggerRunning);
        cmInspectValue: Result := ProjectLoaded AND (not DebuggerRunning);
        cmWatchpoints: Result := ProjectLoaded AND (not DebuggerRunning);
        cmLocalVariables: Result := ProjectLoaded AND (not DebuggerRunning);
        cmViewWatch: Result := ProjectLoaded AND (not DebuggerRunning);
        cmBreakPoints: Result := ProjectLoaded AND (not DebuggerRunning);
        cmViewDump: Result := ProjectLoaded AND (not DebuggerRunning);
        cmViewSource: Result := ProjectLoaded AND InDebugger;
        cmViewSymbols: Result := ProjectLoaded AND InDebugger;
        cmViewCPU: Result := ProjectLoaded AND (not DebuggerRunning) AND InDebugger;
        {
        cmClearAllBreakPoints,
        cmGo,
        cmGotoDebugCursor,
        cmStepOver,
        cmStepInto,
        cmReturnFromFunction,
        cmProgramReset,
        cmProgramReload,
        cmEvaluateModify,
        cmAddWatch,
        cmInspectValue,
        cmWatchpoints,
        cmLocalVariables,
        cmViewWatch,
        cmBreakPoints,
        cmViewDump,
        cmViewSource,
        cmViewSymbols,
        cmViewCPU: Result := False;
        }
      END;
    END;

    cmProjectMenu:
    BEGIN
      CASE command OF
        cmRun: Result := ProjectLoaded AND (not CompilerActive) AND (GetExeName <> '') AND (not InDebugger);
        cmRunParameters: Result := ProjectLoaded;
        cmCompile: Result := ProjectLoaded AND (not CompilerActive) AND (not InDebugger) AND (GetCompileName <> '');
        cmMake: Result := ProjectLoaded AND (not CompilerActive) AND (not InDebugger) AND (GetMakeName <> '');
        cmBuild: Result := ProjectLoaded AND (not CompilerActive) AND (not InDebugger) AND (GetMakeName <> '');
        cmStopCompiler: Result := CompilerActive;

        cmProjectNew: Result := ProjectLoaded AND (not CompilerActive) AND (not InDebugger);
        cmProjectLoad: Result := ProjectLoaded AND (not CompilerActive) AND (not InDebugger);
        cmProjectClose: Result := ProjectLoaded AND (not CompilerActive) AND (not InDebugger) AND (IdeSettings.LastProject <> '');
        {
        cmRun: Result := ProjectLoaded AND (GetExeName <> '');
        cmRunParameters: Result := ProjectLoaded;
        cmCompile: Result := ProjectLoaded AND (not CompilerActive) AND (GetCompileName <> '');
        cmMake: Result := ProjectLoaded AND (not CompilerActive) AND (GetMakeName <> '');
        cmBuild: Result := ProjectLoaded AND (not CompilerActive) AND (GetMakeName <> '');
        cmStopCompiler: Result := CompilerActive;

        cmProjectNew: Result := ProjectLoaded AND (not CompilerActive);
        cmProjectLoad: Result := ProjectLoaded AND (not CompilerActive);
        cmProjectClose: Result := ProjectLoaded AND (not CompilerActive) AND (IdeSettings.LastProject <> '');
        }
        cmProjectSave: Result := ProjectLoaded AND (IdeSettings.LastProject <> '');
        cmProjectSaveAs: Result := ProjectLoaded;
        cmSetPrimary: Result := ProjectLoaded;
        cmClearPrimary: Result := (ProjectLoaded) AND (Project.Settings.Primary <> '');
        cmProjectSettings: Result := ProjectLoaded;
      END;
    END;

    cmOptionsMenu:
    BEGIN
      CASE command OF
        cmGeneral: Result := TRUE;
        cmCustomize: Result := TRUE;
        cmLanguageSettings: Result := TRUE;
        cmToolOptions: Result := TRUE;
      END;
    END;

    cmWindowMenu:
    BEGIN
      CASE command OF
        cmTile: Result := (TopEdit <> NIL) AND CodeEditor.MDIBehaviour;
        cmCascade: Result := (TopEdit <> NIL) AND CodeEditor.MDIBehaviour;
        cmCloseAll: Result := (TopEdit <> NIL);
        cmMaximizeRestore: Result := (TopEdit <> NIL) AND CodeEditor.MDIBehaviour;
        cmNext: Result := (CodeEditor.MDIChildCount > 1);
        cmPrevious: Result := (CodeEditor.MDIChildCount > 1);
        cmCloseTop: Result := (TopEdit <> NIL);
      END;
    END;

    cmHelpMenu:
    BEGIN
      CASE command OF
        cmHelpContents: Result := TRUE;
        cmHelpIndex: Result := TRUE;
        cmHelpOnHelp: Result := TRUE;
        cmKeysHelp: Result := TRUE;
        cmTopicSearch: Result := (TopEdit <> NIL);
        cmTipoftheday: Result := TRUE;
        cmAbout: Result := TRUE;
      END;
    END;

    cmAlignmentMenu:
    BEGIN
      CASE command OF
        cmAlign1: Result := LastDesignForm <> NIL;
        cmAlign2: Result := LastDesignForm <> NIL;
        cmAlign3: Result := LastDesignForm <> NIL;
        cmAlign4: Result := LastDesignForm <> NIL;
        cmAlign5: Result := LastDesignForm <> NIL;
        cmAlign6: Result := LastDesignForm <> NIL;
        cmAlign7: Result := LastDesignForm <> NIL;
        cmAlign8: Result := LastDesignForm <> NIL;
        cmAlign9: Result := LastDesignForm <> NIL;
        cmAlign10: Result := LastDesignForm <> NIL;
        cmAlign11: Result := LastDesignForm <> NIL;
        cmAlign12: Result := LastDesignForm <> NIL;
        cmAlign13: Result := LastDesignForm <> NIL;
        cmAlign14: Result := LastDesignForm <> NIL;
        cmForceAlign: Result := LastDesignForm <> NIL;
        cmRefresh: Result := LastDesignForm <> NIL;
        cmDelCtrl: Result := LastDesignForm <> NIL;
        cmGridVis: Result := LastDesignForm <> NIL;
        cmSnapToGrid: Result := LastDesignForm <> NIL;
        cmDesignPos: Result := LastDesignForm <> NIL;
      END;
    END;
  END;
END;


PROCEDURE TMyForm.UpdateMenuEntries(parent:TCommand);
VAR
  TopEdit:TSibEditor;
  Entry,Entry1:TMenuItem;
  visual:BOOLEAN;
  sc:STRING;
  s:STRING;
  state:BOOLEAN;
  i:LONGINT;
BEGIN
  {folgende Kriterien sind generell mit einzubeziehen}
  // ProjectLoaded - es ist ein Projekt aktiv (bei Make CompLib ist zB keins aktiv)
  // InDebugger - Debugger Session luft
  // DebuggerRunning - Applikation im Debugger luft gerade
  // CompilerActive - Compiler luft
  // TopEdit - Aktives Editor Fenster
  // visual - das aktuelle Projekt ist ein visuelles Projekt

  TopEdit := CodeEditor.TopEditor;
  visual := Project.Settings.ProjectType = pt_Visual;


  {File Menu}
  IF parent = cmFileMenu THEN
  BEGIN
    state := GetCommandState(cmFileMenu, cmNewObject);
    SetMenuState(cmNewObject, state);

    state := GetCommandState(cmFileMenu, cmNew);
    SetMenuState(cmNew, state);

    state := GetCommandState(cmFileMenu, cmOpen);
    SetMenuState(cmOpen, state);

    state := GetCommandState(cmFileMenu, cmInsertFile);
    SetMenuState(cmInsertFile, state);

    state := GetCommandState(cmFileMenu, cmSave);
    SetMenuState(cmSave, state);

    state := GetCommandState(cmFileMenu, cmSaveAs);
    SetMenuState(cmSaveAs, state);

    state := GetCommandState(cmFileMenu, cmSaveAll);
    SetMenuState(cmSaveAll, state);

    state := GetCommandState(cmFileMenu, cmPrint);
    SetMenuState(cmPrint, state);

    state := GetCommandState(cmFileMenu, cmCreateDir);
    SetMenuState(cmCreateDir, state);

    state := GetCommandState(cmFileMenu, cmChangeDir);
    SetMenuState(cmChangeDir, state);

    state := GetCommandState(cmFileMenu, cmExit);
    SetMenuState(cmExit, state);

    state := ProjectLoaded;
    Entry := SibylMainMenu.MenuItems[cmFileMenu];
    FOR i := MaxFileMenu TO Entry.Count-1 DO
    BEGIN
         Entry1 := Entry.Items[i];
         Entry1.Enabled := state;
    END;

    exit;
  END;


  {Edit Menu}
  IF parent = cmEditMenu THEN
  BEGIN
    state := GetCommandState(cmEditMenu, cmSlidingUndo);
    SetMenuState(cmSlidingUndo, state);

    state := GetCommandState(cmEditMenu, cmRedo);
    SetMenuState(cmRedo, state);

    state := GetCommandState(cmEditMenu, cmCut);
    SetMenuState(cmCut, state);

    state := GetCommandState(cmEditMenu, cmCopy);
    SetMenuState(cmCopy, state);

    state := GetCommandState(cmEditMenu, cmPaste);
    SetMenuState(cmPaste, state);

    state := GetCommandState(cmEditMenu, cmDelete);
    SetMenuState(cmDelete, state);

    state := GetCommandState(cmEditMenu, cmSelectAll);
    SetMenuState(cmSelectAll, state);

    state := GetCommandState(cmEditMenu, cmDeselectAll);
    SetMenuState(cmDeselectAll, state);

    state := GetCommandState(cmEditMenu, cmMacroRecord);
    SetMenuState(cmMacroRecord, state);

    state := GetCommandState(cmEditMenu, cmMacroPlay);
    SetMenuState(cmMacroPlay, state);

    state := GetCommandState(cmEditMenu, cmMacroSave);
    SetMenuState(cmMacroSave, state);

    Entry1 := SibylMainMenu.MenuItems[cmMacroRecord];
    IF Entry1 <> NIL THEN
      IF TopEdit <> NIL THEN
      BEGIN
           IF pos('\t',Entry1.Caption) = 0 THEN sc := ''
           ELSE sc := copy(Entry1.Caption,pos('\t',Entry1.Caption),255);
           IF not TopEdit.MacroRecording
           THEN Entry1.Caption := LoadNLSStr(SiMenuRecordMacro) + sc
           ELSE Entry1.Caption := LoadNLSStr(SiMenuStopMacroRecording) + sc;
      END;

    exit;
  END;


  {Search Menu}
  IF parent = cmSearchMenu THEN
  BEGIN
    state := GetCommandState(cmSearchMenu, cmFind);
    SetMenuState(cmFind, state);

    state := GetCommandState(cmSearchMenu, cmReplace);
    SetMenuState(cmReplace, state);

    state := GetCommandState(cmSearchMenu, cmSearchAgain);
    SetMenuState(cmSearchAgain, state);

    state := GetCommandState(cmSearchMenu, cmIncrementalSearch);
    SetMenuState(cmIncrementalSearch, state);

    state := GetCommandState(cmSearchMenu, cmMatchingBrace);
    SetMenuState(cmMatchingBrace, state);

    state := GetCommandState(cmSearchMenu, cmFindInFiles);
    SetMenuState(cmFindInFiles, state);

    state := GetCommandState(cmSearchMenu, cmGotoLine);
    SetMenuState(cmGotoLine, state);

    state := GetCommandState(cmSearchMenu, cmGotoLastError);
    SetMenuState(cmGotoLastError, state);

    state := GetCommandState(cmSearchMenu, cmBookmarks);
    SetMenuState(cmBookmarks, state);

    exit;
  END;


  {View Menu}
  IF parent = cmViewMenu THEN
  BEGIN
    state := GetCommandState(cmViewMenu, cmProjectManager);
    SetMenuState(cmProjectManager, state);

    state := GetCommandState(cmViewMenu, cmViewBrowser);
    SetMenuState(cmViewBrowser, state);

    state := GetCommandState(cmViewMenu, cmWindowList);
    SetMenuState(cmWindowList, state);

    state := GetCommandState(cmViewMenu, cmMacroList);
    SetMenuState(cmMacroList, state);

    state := GetCommandState(cmViewMenu, cmClipBoardList);
    SetMenuState(cmClipBoardList, state);

    state := GetCommandState(cmViewMenu, cmViewInspector);
    SetMenuState(cmViewInspector, state);

    state := GetCommandState(cmViewMenu, cmViewComponents);
    SetMenuState(cmViewComponents, state);

    state := GetCommandState(cmViewMenu, cmViewAlign);
    SetMenuState(cmViewAlign, state);

    state := GetCommandState(cmViewMenu, cmFormUnit);
    SetMenuState(cmFormUnit, state);

    state := GetCommandState(cmViewMenu, cmNewForm);
    SetMenuState(cmNewForm, state);

    state := GetCommandState(cmViewMenu, cmImport);
    SetMenuState(cmImport, state);

    state := GetCommandState(cmViewMenu, cmViewRepository);
    SetMenuState(cmViewRepository, state);

    state := GetCommandState(cmViewMenu, cmToggleSpeedbar);
    SetMenuState(cmToggleSpeedbar, state);

    state := GetCommandState(cmViewMenu, cmToggleNavigator);
    SetMenuState(cmToggleNavigator, state);

    state := GetCommandState(cmViewMenu, cmToggleStatusbar);
    SetMenuState(cmToggleStatusbar, state);

    Entry1 := SibylMainMenu.MenuItems[cmToggleSpeedBar];
    IF Entry1 <> NIL THEN Entry1.Checked := Speedbar <> NIL;
    Entry1 := SibylMainMenu.MenuItems[cmToggleNavigator];
    IF Entry1 <> NIL THEN Entry1.Checked := Navigator <> NIL;
    Entry1 := SibylMainMenu.MenuItems[cmToggleStatusBar];
    IF Entry1 <> NIL THEN Entry1.Checked := CodeEditor.Statusbar <> NIL;

    exit;
  END;


  {Component Menu}
  IF parent = cmComponentMenu THEN
  BEGIN
    state := GetCommandState(cmComponentMenu, cmNewComponent);
    SetMenuState(cmNewComponent, state);

    state := GetCommandState(cmComponentMenu, cmInstallComponents);
    SetMenuState(cmInstallComponents, state);

    state := GetCommandState(cmComponentMenu, cmRemoveComponents);
    SetMenuState(cmRemoveComponents, state);

    state := GetCommandState(cmComponentMenu, cmOpenCompLib);
    SetMenuState(cmOpenCompLib, state);

    state := GetCommandState(cmComponentMenu, cmRecompileCompLib);
    SetMenuState(cmRecompileCompLib, state);

    state := GetCommandState(cmComponentMenu, cmConfigurePalette);
    SetMenuState(cmConfigurePalette, state);

    state := GetCommandState(cmComponentMenu, cmLoadTemplateForms);
    SetMenuState(cmLoadTemplateForms, state);

    state := GetCommandState(cmComponentMenu, cmSaveTemplateForms);
    SetMenuState(cmSaveTemplateForms, state);

    state := GetCommandState(cmComponentMenu, cmViewRepository);
    SetMenuState(cmViewRepository, state);

    state := GetCommandState(cmComponentMenu, cmAddToRepository);
    SetMenuState(cmAddToRepository, state);

    exit;
  END;


  {Debug Menu}
  IF parent = cmDebugMenu THEN
  BEGIN
    state := GetCommandState(cmDebugMenu, cmToggleBreakPoint);
    SetMenuState(cmToggleBreakPoint, state);

    state := GetCommandState(cmDebugMenu, cmClearAllBreakPoints);
    SetMenuState(cmClearAllBreakPoints, state);

    state := GetCommandState(cmDebugMenu, cmGo);
    SetMenuState(cmGo, state);

    state := GetCommandState(cmDebugMenu, cmGotoDebugCursor);
    SetMenuState(cmGotoDebugCursor, state);

    state := GetCommandState(cmDebugMenu, cmStepOver);
    SetMenuState(cmStepOver, state);

    state := GetCommandState(cmDebugMenu, cmStepInto);
    SetMenuState(cmStepInto, state);

    state := GetCommandState(cmDebugMenu, cmReturnFromFunction);
    SetMenuState(cmReturnFromFunction, state);

    state := GetCommandState(cmDebugMenu, cmProgramReset);
    SetMenuState(cmProgramReset, state);

    state := GetCommandState(cmDebugMenu, cmProgramReload);
    SetMenuState(cmProgramReload, state);

    state := GetCommandState(cmDebugMenu, cmEvaluateModify);
    SetMenuState(cmEvaluateModify, state);

    state := GetCommandState(cmDebugMenu, cmAddWatch);
    SetMenuState(cmAddWatch, state);

    state := GetCommandState(cmDebugMenu, cmInspectValue);
    SetMenuState(cmInspectValue, state);

    state := GetCommandState(cmDebugMenu, cmWatchpoints);
    SetMenuState(cmWatchpoints, state);

    state := GetCommandState(cmDebugMenu, cmBreakPoints);
    SetMenuState(cmBreakPoints, state);

    state := GetCommandState(cmDebugMenu, cmLocalVariables);
    SetMenuState(cmLocalVariables, state);

    state := GetCommandState(cmDebugMenu, cmViewSymbols);
    SetMenuState(cmViewSymbols, state);

    state := GetCommandState(cmDebugMenu, cmViewSource);
    SetMenuState(cmViewSource, state);

    state := GetCommandState(cmDebugMenu, cmViewCPU);
    SetMenuState(cmViewCPU, state);

    state := GetCommandState(cmDebugMenu, cmViewWatch);
    SetMenuState(cmViewWatch, state);

    state := GetCommandState(cmDebugMenu, cmViewDump);
    SetMenuState(cmViewDump, state);

    exit;
  END;


  {Project Menu}
  IF parent = cmProjectMenu THEN
  BEGIN
    state := GetCommandState(cmProjectMenu, cmRun);
    SetMenuState(cmRun, state);

    state := GetCommandState(cmProjectMenu, cmRunParameters);
    SetMenuState(cmRunParameters, state);

    state := GetCommandState(cmProjectMenu, cmCompile);
    SetMenuState(cmCompile, state);

    state := GetCommandState(cmProjectMenu, cmMake);
    SetMenuState(cmMake, state);

    state := GetCommandState(cmProjectMenu, cmBuild);
    SetMenuState(cmBuild, state);

    state := GetCommandState(cmProjectMenu, cmStopCompiler);
    SetMenuState(cmStopCompiler, state);

    state := GetCommandState(cmProjectMenu, cmProjectNew);
    SetMenuState(cmProjectNew, state);

    state := GetCommandState(cmProjectMenu, cmProjectLoad);
    SetMenuState(cmProjectLoad, state);

    state := GetCommandState(cmProjectMenu, cmProjectClose);
    SetMenuState(cmProjectClose, state);

    state := GetCommandState(cmProjectMenu, cmProjectSave);
    SetMenuState(cmProjectSave, state);

    state := GetCommandState(cmProjectMenu, cmProjectSaveAs);
    SetMenuState(cmProjectSaveAs, state);

    state := GetCommandState(cmProjectMenu, cmSetPrimary);
    SetMenuState(cmSetPrimary, state);

    state := GetCommandState(cmProjectMenu, cmClearPrimary);
    SetMenuState(cmClearPrimary, state);

    state := GetCommandState(cmProjectMenu, cmProjectSettings);
    SetMenuState(cmProjectSettings, state);

    Entry := SibylMainMenu.MenuItems[cmSetPrimary];
    s := LoadNLSStr(SiMenuSetPrimary);
    IF Project.Settings.Primary <> '' THEN
    BEGIN
         s := s + '  [' + ExtractFileName(Project.Settings.Primary) + ']';
    END;
    Entry.Caption := s;

    state := ProjectLoaded AND (not CompilerActive) AND (not InDebugger);
    //state := ProjectLoaded AND (not CompilerActive);
    Entry := SibylMainMenu.MenuItems[cmProjectMenu];
    FOR i := MaxProjectMenu TO Entry.Count-1 DO
    BEGIN
         Entry1 := Entry.Items[i];
         Entry1.Enabled := state;
    END;

    exit;
  END;


  {Options Menu}
  IF parent = cmOptionsMenu THEN
  BEGIN
    state := GetCommandState(cmOptionsMenu, cmGeneral);
    SetMenuState(cmGeneral, state);

    state := GetCommandState(cmOptionsMenu, cmCustomize);
    SetMenuState(cmCustomize, state);

    state := GetCommandState(cmOptionsMenu, cmLanguageSettings);
    SetMenuState(cmLanguageSettings, state);

    state := GetCommandState(cmOptionsMenu, cmToolOptions);
    SetMenuState(cmToolOptions, state);

    state := TRUE;
    Entry := SibylMainMenu.MenuItems[cmOptionsMenu];
    FOR i := MaxOptionMenu TO Entry.Count-1 DO
    BEGIN
         Entry1 := Entry.Items[i];
         Entry1.Enabled := state;
    END;

    exit;
  END;


  {Window Menu}
  IF parent = cmWindowMenu THEN
  BEGIN
    state := GetCommandState(cmWindowMenu, cmTile);
    SetMenuState(cmTile, state);

    state := GetCommandState(cmWindowMenu, cmCascade);
    SetMenuState(cmCascade, state);

    state := GetCommandState(cmWindowMenu, cmCloseAll);
    SetMenuState(cmCloseAll, state);

    state := GetCommandState(cmWindowMenu, cmMaximizeRestore);
    SetMenuState(cmMaximizeRestore, state);

    state := GetCommandState(cmWindowMenu, cmNext);
    SetMenuState(cmNext, state);

    state := GetCommandState(cmWindowMenu, cmPrevious);
    SetMenuState(cmPrevious, state);

    state := GetCommandState(cmWindowMenu, cmCloseTop);
    SetMenuState(cmCloseTop, state);

    {Maximize/Restore}
    Entry1 := SibylMainMenu.MenuItems[cmMaximizeRestore];
    IF Entry1 <> NIL THEN
      IF TopEdit <> NIL THEN
      BEGIN
           IF pos('\t',Entry1.Caption) = 0 THEN sc := ''
           ELSE sc := copy(Entry1.Caption,pos('\t',Entry1.Caption),255);
           IF TopEdit.WindowState <> wsNormal
           THEN Entry1.Caption := LoadNLSStr(SiMenuRestore) + sc
           ELSE Entry1.Caption := LoadNLSStr(SiMenuMaximize) + sc;
      END;

      exit;
  END;


  {Help Menu}
  IF parent = cmHelpMenu THEN
  BEGIN
    state := GetCommandState(cmHelpMenu, cmHelpContents);
    SetMenuState(cmHelpContents, state);

    state := GetCommandState(cmHelpMenu, cmHelpIndex);
    SetMenuState(cmHelpIndex, state);

    state := GetCommandState(cmHelpMenu, cmHelpOnHelp);
    SetMenuState(cmHelpOnHelp, state);

    state := GetCommandState(cmHelpMenu, cmKeysHelp);
    SetMenuState(cmKeysHelp, state);

    state := GetCommandState(cmHelpMenu, cmTopicSearch);
    SetMenuState(cmTopicSearch, state);

    state := GetCommandState(cmHelpMenu, cmTipoftheday);
    SetMenuState(cmTipoftheday, state);

    state := GetCommandState(cmHelpMenu, cmAbout);
    SetMenuState(cmAbout, state);

    exit;
  END;
END;


PROCEDURE TMyForm.MenuInit(AMenu:TMenu;Entry:TMenuItem);
BEGIN
     Inherited MenuInit(Menu,Entry);

     IF Menu = SibylMainMenu THEN
       IF Entry <> NIL THEN UpdateMenuEntries(Entry.Command);
END;


PROCEDURE TMyForm.EvSibylIdle(Sender:TObject;VAR Done:BOOLEAN);
VAR  i:LONGINT;
     Btn:TSpeedButton;
     LastMainCmd:LONGINT;
     state:BOOLEAN;
BEGIN
     FOR i := 1 TO MaxMenuEntries DO
     BEGIN
          IF MenuEntries[i].Level IN [0,4] THEN
          BEGIN
               LastMainCmd := MenuEntries[i].Cmd;
               continue;
          END;

          Btn := TSpeedButton(MenuEntries[i].Btn);
          IF Btn <> NIL THEN
          BEGIN
               IF not Btn.Showing THEN continue;

               state := GetCommandState(LastMainCmd, MenuEntries[i].Cmd);
               IF Btn.Enabled <> state THEN Btn.Enabled := state;
          END;
     END;
     Done := TRUE;
END;


PROCEDURE TMyForm.SetupComponent;
  PROCEDURE SetupMainMenu;
  VAR  t:BYTE;
       Entry,LastLevel0Entry:TMenuItem;
  BEGIN
       FOR t := 1 TO MaxMenuEntries DO
       BEGIN
            IF MenuEntries[t].Level > 2 THEN exit; {spezial Items}

            Entry.Create(SELF);
            CASE MenuEntries[t].Level OF
              0:
              BEGIN
                   SibylMainMenu.Items.Add(Entry);
                   LastLevel0Entry := Entry;
              END;
              1:
              BEGIN
                   LastLevel0Entry.Add(Entry);
              END;
            END;
            IF MenuEntries[t].Text=0 THEN Entry.Caption:='-'
            ELSE Entry.Caption := LoadNLSStr(MenuEntries[t].Text);
            IF MenuEntries[t].Hint=0 THEN Entry.Hint:=''
            ELSE Entry.Hint := LoadNLSStr(MenuEntries[t].Hint);
            Entry.Command := MenuEntries[t].Cmd;
            Entry.HelpContext := MenuEntries[t].hctx;
            IF Entry.Command = 1 THEN Entry.Enabled := FALSE; {unsupported}

            MenuEntries[t].Menu := Entry;
       END;
  END;

VAR  FontName:STRING;
     PointSize:LONGINT;
     AFont:TFont;
BEGIN
     Inherited SetupComponent;

     Exclude(BorderIcons,biMaximize);    {nicht maximierbar!}
     SibylMainForm := SELF;
     Icon := MainIcon;

     SibylFormId := dwi_MainWindow;
     Name := 'SibylMainForm';
     Caption := 'SpeedSoft Sibyl';
     Color := clLtGray;
     EnableDocking := [tbBottom];

     FMinMaxCount := 0;
     Speedbar := NIL;
     Navigator := NIL;

     SibylMainMenu.Create(SELF);
     SetupMainMenu;
     Menu := SibylMainMenu;

     UpdateFormInitProcs;

     LoadINI(IdeSettings); {INI erst nach Menu laden}

     ShowBitBtnGlyph := IdeSettings.ShowBitBtnGlyph;

     IF IdeSettings.Fonts.ApplicationFont <> '' THEN
       IF SplitFontName(IdeSettings.Fonts.ApplicationFont,FontName,PointSize) THEN
       BEGIN
            AFont := Screen.GetFontFromPointSize(FontName,PointSize);
            IF AFont <> NIL THEN Application.Font := AFont;
       END;


     SetMainMenuShortCuts(IdeSettings.EditOpt.KeyMap); {ShortCuts anhngen}

     StartProject;

     OnMinimize := EvMainFormMinimize;
     OnRestore := EvMainFormRestore;
     OnTranslateShortCut := EvTranslateShortCut;
     Application.OnIdle := EvSibylIdle;
     Application.OnHint := EvShowHint;
     Application.ShowHint := IdeSettings.GlobalHints;

     Screen.Cursor := crAppStart;
END;


PROCEDURE TMyForm.SetupShow;
BEGIN
     Inherited SetupShow;

     PalettenPopup.Create(SELF);
     PalettenPopup.OnPopup := EvPalettenPopup;

     BuildSpeedbar;

     SetupNavigatorPages; {CompLib laden}
     InitToolbars;        {schon an dieser Stelle}

     InitCodeEditor;      {CodeEditor kreieren}
     ReadToolbars;        {Toolbars anordnen aus der INI}

     Show;
     Update;
     SetMinMaxSize(TRUE);

     CodeEditor.Show;     {CodeEditor anzeigen}

     ExecuteProject;

     StopStartupDialog;

     Screen.Cursor := crDefault;

     IF IdeSettings.ShowStartTip THEN TipOfTheDayDialog(FALSE); {kein Fehler zeigen}

     VDEinitialized := TRUE;

     {$IFDEF WIN32}
     SetMinMaxSize(FALSE);
     SetBounds(Left,Top,Width,MainWindowHeight);
     SetMinMaxSize(TRUE);
     {$ENDIF}
END;


PROCEDURE TMyForm.ScanEvent(VAR KeyCode:TKeyCode;RepeatCount:BYTE);
BEGIN
     IF KeyCode IN [kbCR,kbEnter] THEN
     BEGIN
          IF LastFocusedForm <> NIL THEN
          BEGIN
               LastFocusedForm.BringToFront;
               LastFocusedForm.Focus;
               IF LastFocusedForm = CodeEditor THEN
                 IF CodeEditor.TopEditor <> NIL
                 THEN CodeEditor.TopEditor.Focus;
          END;
          KeyCode := kbNull;
          exit;
     END;

     IF MapSystemKeystroke(KeyCode) THEN KeyCode := kbNull;

     Inherited ScanEvent(KeyCode,RepeatCount);
     {setzt KeyCode auf jeden Fall -> kbNull}
END;


FUNCTION TMyForm.MapSystemKeystroke(Key:TKeyCode):BOOLEAN;
BEGIN
     CASE IdeSettings.EditOpt.KeyMap OF
       km_WordStar: Result := EmulateWordStar(Key);
       km_CUA:      Result := EmulateCUA(Key);
       km_Default:  Result := EmulateDefault(Key);
       km_Custom:   Result := EmulateDefault(Key);
     END;
END;


FUNCTION TMyForm.EmulateWordStar(Key:TKeyCode):BOOLEAN;
VAR  Cmd:TCommand;
BEGIN
     Result := TRUE;
     Cmd := cmNull;
     CASE Key OF
       kbEsc:      Cmd := cmStopCompiler;
       kbF1:       Cmd := cmTopicSearch;
       kbF2:       Cmd := cmSave;
       kbF3:       Cmd := cmOpen;
       kbF4:       Cmd := cmGotoDebugCursor;
       kbF5:       Cmd := cmMaximizeRestore;
       kbF6:       Cmd := cmNext;
       kbF7:       Cmd := cmStepInto;
       kbF8:       Cmd := cmStepOver;
       kbCtrlF3:   Cmd := cmReturnFromFunction;
       kbF9:       Cmd := cmMake;
       kbF11:      Cmd := cmViewInspector;
       kbF12:      Cmd := cmFormUnit;
       kbAltF3:    Cmd := cmCloseTop;
       kbAltX:     Cmd := cmExit;
       kbAlt0:     Cmd := cmWindowList;
       kbShiftF6:  Cmd := cmPrevious;
       kbCtrlF1:   Cmd := cmTopicSearch;
       kbCtrlF2:   Cmd := cmProgramReset;
       kbCtrlF4:   Cmd := cmCloseTop;
       kbCtrlF5:   Cmd := cmEvaluateModify;
       kbCtrlF7:   Cmd := cmAddWatch;
       kbCtrlF8:   Cmd := cmToggleBreakPoint;
       kbCtrlF9:   Cmd := cmRun;
       kbCtrlF10:  Cmd := cmCompile;
       kbCtrlBreak:Cmd := cmStopCompiler;
       kbCtrlAltF9:Cmd := cmGo;
       kbCtrlM:    CodeEditor.SetMDIMode(not CodeEditor.MDIBehaviour);
       kbCtrlB:    Cmd := cmBookmarks;
       kbCtrlP:    Cmd := cmPrint;
       kbAlt1..kbAlt9: CodeEditor.ActivateEditor(Key-kbAlt1+1); {1..9}
       ELSE Result := FALSE;
     END;
     IF Result THEN CommandEvent(Cmd);
END;


FUNCTION TMyForm.EmulateCUA(Key:TKeyCode):BOOLEAN;
VAR  Cmd:TCommand;
BEGIN
     Result := TRUE;
     Cmd := cmNull;
     CASE Key OF
       kbEsc:      Cmd := cmStopCompiler;
       kbF1:       Cmd := cmTopicSearch;
       kbF2:       Cmd := cmSave;
       kbF3:       Cmd := cmExit;
       kbF4:       Cmd := cmGotoDebugCursor;
       kbF5:       Cmd := cmMaximizeRestore;
       kbF6:       Cmd := cmNext;
       kbF7:       Cmd := cmStepInto;
       kbF8:       Cmd := cmStepOver;
       kbCtrlF3:   Cmd := cmReturnFromFunction;
       kbF9:       Cmd := cmMake;
       kbF11:      Cmd := cmViewInspector;
       kbF12:      Cmd := cmFormUnit;
       kbAltF3:    Cmd := cmCloseTop;
       kbAltX:     Cmd := cmExit;
       kbAlt0:     Cmd := cmWindowList;
       kbShiftF6:  Cmd := cmPrevious;
       kbCtrlF1:   Cmd := cmTopicSearch;
       kbCtrlF2:   Cmd := cmProgramReset;
       kbCtrlF4:   Cmd := cmCloseTop;
       kbCtrlF5:   Cmd := cmEvaluateModify;
       kbCtrlF7:   Cmd := cmAddWatch;
       kbCtrlF8:   Cmd := cmToggleBreakPoint;
       kbCtrlF9:   Cmd := cmRun;
       kbCtrlF10:  Cmd := cmCompile;
       kbCtrlBreak:Cmd := cmStopCompiler;
       kbCtrlAltF9:Cmd := cmGo;
       kbCtrlO:    Cmd := cmOpen;
       kbCtrlM:    CodeEditor.SetMDIMode(not CodeEditor.MDIBehaviour);
       kbCtrlB:    Cmd := cmBookmarks;
       kbCtrlP:    Cmd := cmPrint;
       kbAlt1..kbAlt9: CodeEditor.ActivateEditor(Key-kbAlt1+1); {1..9}
       ELSE Result := FALSE;
     END;
     IF Result THEN CommandEvent(Cmd);
END;


FUNCTION TMyForm.EmulateDefault(Key:TKeyCode):BOOLEAN;
VAR  Cmd:TCommand;
BEGIN
     Result := TRUE;
     Cmd := cmNull;
     CASE Key OF
       kbEsc:      Cmd := cmStopCompiler;
       kbF1:       Cmd := cmTopicSearch;
       kbF4:       Cmd := cmGotoDebugCursor;
       kbF5:       Cmd := cmToggleBreakPoint;
       kbF7:       Cmd := cmStepInto;
       kbF8:       Cmd := cmStepOver;
       kbCtrlF3:   Cmd := cmReturnFromFunction;
       kbF9:       Cmd := cmRun;
       kbF11:      Cmd := cmViewInspector;
       kbF12:      Cmd := cmFormUnit;
       kbAlt0:     Cmd := cmWindowList;
       kbCtrlF1:   Cmd := cmTopicSearch;
       kbCtrlF2:   Cmd := cmProgramReset;
       kbCtrlF4:   Cmd := cmCloseTop;
       kbCtrlF5:   Cmd := cmAddWatch;
       kbCtrlF7:   Cmd := cmEvaluateModify;
     //kbCtrlF9:   Cmd := cmCompileAllModifiedProjectFiles;
       kbCtrlBreak:Cmd := cmStopCompiler;
       kbCtrlAltF9:Cmd := cmGo;
       kbCtrlM:    CodeEditor.SetMDIMode(not CodeEditor.MDIBehaviour);
       kbCtrlB:    Cmd := cmBookmarks;
       kbCtrlP:    Cmd := cmPrint;
       kbAlt1..kbAlt9: CodeEditor.ActivateEditor(Key-kbAlt1+1); {1..9}
       ELSE Result := FALSE;
     END;
     IF Result THEN CommandEvent(Cmd);
END;


PROCEDURE TMyForm.Resize;
BEGIN
     Inherited Resize;

     {falls durch das Sizen die H”he gndert werden muแ, zB 2 Menuzeilen}
     IF Menu.Handle = 0 THEN exit;
     IF LastMenuHeight = Menu.Height THEN exit;
     LastMenuHeight := Menu.Height;
     SetMinMaxSize(FALSE);
     SetBounds(Left,Top,Width,MainWindowHeight);
     SetMinMaxSize(TRUE);
END;


{$HINTS OFF}
PROCEDURE TMyForm.EvMainFormMinimize(Sender:TObject);
VAR  i:LONGINT;
     dwi:TDesktopWinId;
     FormItem:PFormListItem;
     Form:TFormEditor;
     Win:TForm;
     Palette:TDockingPalette;
BEGIN
     {Sibyl Forms}
     FOR dwi := dwi_CodeEditor TO dwi_LastForm DO
     BEGIN
          Win := IdeSettings.DesktopWindows[dwi].Form;
          IF Win IS TForm THEN Win.WindowState := wsMinimized;
     END;
     {Form Designer}
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          Form := TFormEditor(FormItem^.Form);
          IF Form IS TForm THEN Form.WndState := wsMinimized;
     END;
     {Paletten}
     FOR i := 0 TO Paletten.Count-1 DO
     BEGIN
          Palette := TDockingPalette(Paletten.Objects[i]);
          IF Palette.DockingState <> dsFloat THEN continue;
          Win := Palette.Form;
          IF Win IS TForm THEN Win.WindowState := wsMinimized;
     END;
     {Watch Window}
     FOR i := 0 TO InspectWindows.Count-1 DO
     BEGIN
          Win := TForm(InspectWindows.Items[i]);
          IF Win IS TForm THEN Win.WindowState := wsMinimized;
     END;
END;


PROCEDURE TMyForm.EvMainFormRestore(Sender:TObject);
VAR  i:LONGINT;
     dwi:TDesktopWinId;
     FormItem:PFormListItem;
     Form:TFormEditor;
     Win:TForm;
     Palette:TDockingPalette;
BEGIN
     IF VDERestoring THEN exit;
     VDERestoring := TRUE;

     {Sibyl Forms}
     FOR dwi := dwi_MainWindow TO dwi_LastForm DO
     BEGIN
          Win := IdeSettings.DesktopWindows[dwi].Form;
          IF Win IS TForm THEN Win.WindowState := wsNormal;
     END;
     {Form Designer}
     FOR i := 0 TO Project.Forms.Count-1 DO
     BEGIN
          FormItem := Project.Forms.Items[i];
          Form := TFormEditor(FormItem^.Form);
          IF Form IS TFormEditor THEN Form.WndState := wsNormal;
     END;
     {Paletten}
     FOR i := 0 TO Paletten.Count-1 DO
     BEGIN
          Palette := TDockingPalette(Paletten.Objects[i]);
          IF Palette.DockingState <> dsFloat THEN continue;
          Win := Palette.Form;
          IF Win IS TForm THEN Win.WindowState := wsNormal;
     END;
     {Watch Window}
     FOR i := 0 TO InspectWindows.Count-1 DO
     BEGIN
          Win := TForm(InspectWindows.Items[i]);
          IF Win IS TForm THEN Win.WindowState := wsNormal;
     END;

     VDERestoring := FALSE;
END;
{$HINTS ON}


PROCEDURE TMyForm.Close;
VAR  SibylForm:TSibylForm;
     dwi:TDesktopWinId;
BEGIN
     IF not VDEinitialized THEN exit;

     VDETerminating := TRUE;

     IF InDebugger THEN
     BEGIN
          {Debug session active. Terminate?}
          IF Dialogs.MessageBox(LoadNLSStr(SiDebuggerRunning),
                                mtInformation,[mbYes,mbCancel]) = mrCancel THEN
          BEGIN
               VDETerminating := FALSE;
               exit;
          END;

          ProgramReset;
          //WHILE InDebugger DO Application.HandleMessage;
     END;
     IF CompilerActive THEN
     BEGIN
          {Compiler active. Terminate?}
          IF Dialogs.MessageBox(LoadNLSStr(SiCompilerRunning),
                                mtInformation,[mbYes,mbCancel]) = mrCancel THEN
          BEGIN
               VDETerminating := FALSE;
               exit;
          END;

          StopCompiler;
          //WHILE CompilerActive DO Application.HandleMessage;
     END;


     //speichere die Positionen aller sichtbaren Sibyl Forms
     FOR dwi := dwi_MainWindow TO dwi_LastForm DO
     BEGIN
       SibylForm := TSibylForm(IdeSettings.DesktopWindows[dwi].Form);
       IF SibylForm <> NIL THEN SibylForm.StoreDesktopWindowPos;
     END;

     SaveINI(IdeSettings);

     IF not CloseProject(FALSE{!!!}) THEN
     BEGIN
          VDETerminating := FALSE;
          exit;
     END;

     Hide;

     {IDE is closing, notify library experts}
     FreeAllLibraryExperts;
     RemoveExpertsMenu;

     Inherited Close;
END;


PROCEDURE UnloadDebugger;
BEGIN
     EraseCPUAlias;
     UnloadDbgProcess;
     IF CPUWindow<>NIL THEN
     BEGIN
          CPUWindow.UnloadNotify;
          CPUWindow.CodeUpScrolled:=0;
          CPUWindow.VertScrollBar.Position:=0;
          CPUWindow.RightToolBar.RegisterNoteBook.CPURegistersValid:=FALSE;
     END;
     CPUList.Clear;
     IF LastDbgEditor<>NIL THEN
     BEGIN
          LastDbgEditor.SetDebuggerLine(-1);              {clear}
          {Cursor wieder generieren}
          LastDbgEditor.CursorShape := LastDbgEditor.CursorShape;
     END;
     LastDbgEditor:=NIL;
END;


VAR LastSrcFile:STRING;
    LastSrcLine:WORD;
    TheGotoSource:STRING;
    TheGotoLine:WORD;


FUNCTION UpdateDebugWindows(CONST Src:STRING;Line:WORD):LONGWORD;FORWARD;

PROCEDURE ShowCPUWindow(FromIDE:BOOLEAN);
BEGIN
     InitCPUWindow;
     IF not FromIDE THEN
     BEGIN
          LastSrcFile:='';
          LastSrcLine:=0;
     END;
     IF InDebugger THEN UpdateDebugWindows(LastSrcFile,LastSrcLine);
END;


PROCEDURE DebuggerHasEnded;
VAR  i:LONGINT;
BEGIN
     FOR i := 0 TO CodeEditor.MDIChildCount-1
        DO CodeEditor.MDIChildren[i].Invalidate;

     IF CodeEditor.TopEditor <> NIL THEN CodeEditor.TopEditor.CaptureFocus;

exit;
     // Heap Lecks ausgeben
     CodeEditor.DebugTrace(tostr(AppMemList.Count)+' unreleased memory blocks');
     CodeEditor.DebugTrace(tostr(AppMemMax)+' blocks at all');
     AppMemList.Count := 0;
     AppMemMax := 0;
END;


PROCEDURE TMyForm.ProgramReset;
BEGIN
     IF not InDebugger THEN exit;
     UnloadDebugger;
     IF CPUWindow<>NIL THEN
     BEGIN
          CPUWindow.Invalidate;
          CPUWindow.BottomToolBar.Invalidate;
          CPUWindow.BottomToolBar.DumpNoteBook.StackListBox.Clear;
     END;
     UpdateWatchWindow(TRUE);
     InvalidateAllDumps;

     ShowSibylForms;

     DebuggerHasEnded;
END;

PROCEDURE IDEProgramReset;
BEGIN
     MyMainForm.ProgramReset;
END;

PROCEDURE TMyForm.UnloadProcess;
BEGIN
     UnloadDebugger;
     IF CPUWindow<>NIL THEN
     BEGIN
          WITH CPUWindow.RightToolBar.RegisterNoteBook DO Redraw(ClientRect);
          WITH CPUWindow.BottomToolBar.DumpNoteBook DO Redraw(ClientRect);
          CPUWindow.Redraw(CPUWindow.ClientRect);
     END;
     SetMainStatusText(LoadNLSStr(SiProcessTerminated),clBlack,clLtGray);
     ShowSibylForms;

     DebuggerHasEnded;
END;


PROCEDURE TMyForm.CommandEvent(VAR Command:TCommand);
VAR  Editor:TSibEditor;
     FormEditor:TFormEditor;
     x,s:STRING;
     CreateDirDlg:TCreateDirDialog;
     ChangeDirDlg:TChangeDirDialog;
     src,exe:STRING;
     MsgHandled:BOOLEAN;
     cancel:BOOLEAN;
     ExpertIndex,Count,t:LONGINT;
     Expert:TIExpert;
     CFOD:TOpenDialog;
     ret:TMsgDlgReturn;
     Directories:^TDirectories;
     DebugOpt:^TDebuggerOptions;
LABEL LookTarget,NoCompile1,NoCompile2;
BEGIN
     Editor := CodeEditor.TopEditor;
     IF Editor IS TSibEditor THEN Editor.ResetErrorLine
     ELSE Editor := NIL;

     Case Project.Settings.Platform OF
        pf_Standard:
        BEGIN
             {$IFDEF OS2}
             Directories:=@Project.Settings.DirectoriesOS2;
             DebugOpt:=@Project.Settings.DebugOptOS2;
             {$ENDIF}
             {$IFDEF WIN32}
             Directories:=@Project.Settings.DirectoriesWin;
             DebugOpt:=@Project.Settings.DebugOptWin;
             {$ENDIF}
        END;
        pf_OS2:
        BEGIN
             Directories:=@Project.Settings.DirectoriesOS2;
             DebugOpt:=@Project.Settings.DebugOptOS2;
        END;
        pf_WIN32:
        BEGIN
             Directories:=@Project.Settings.DirectoriesWin;
             DebugOpt:=@Project.Settings.DebugOptWin;
        END;
     END;


     //Inherited CommandEvent(Command);

     IF Command IN FormEditorCommands THEN
       IF LastDesignForm <> NIL THEN
       BEGIN
            TFormEditor(LastDesignForm).CommandEvent(Command);
            exit;
       END;

     IF (Command IN FormEditCommands) AND (LastFocusedForm IS TFormEditor) THEN
       IF LastDesignForm <> NIL THEN
       BEGIN
            TFormEditor(LastDesignForm).CommandEvent(Command);
            exit;
       END;

     IF Command IN CodeEditorCommands THEN
     BEGIN
          CodeEditor.CommandEvent(Command);
          exit;
     END;

     MsgHandled := TRUE;

     CASE Command OF
        cmNewObject: NewObject;
        cmCreateDir:
        BEGIN
             CreateDirDlg.Create(SELF);
             CreateDirDlg.HelpContext := hctxDialogCreateDirectory;
             IF CreateDirDlg.Execute THEN
             BEGIN
                  IF CreateDirDlg.ChangeDir
                  THEN ChangeDir(CreateDirDlg.Directory);
             END;
             CreateDirDlg.Destroy;
             Screen.Update;
        END;
        cmChangeDir:
        BEGIN
             ChangeDirDlg.Create(SELF);
             ChangeDirDlg.HelpContext := hctxDialogChangeDirectory;
             IF ChangeDirDlg.Execute THEN
             BEGIN
                  ChangeDir(ChangeDirDlg.Directory);
             END;
             ChangeDirDlg.Destroy;
             Screen.Update;
        END;
        cmPrint:
        BEGIN
             TRY
                PrintDialog;
             EXCEPT
                ON E:Exception DO ErrorBox(E.Message);
             END;
        END;
        cmLastFile1..cmLastFileN:
        BEGIN
             s := GetMenuItem(Command,Project.FilesHistory);
             IF s <> '' THEN
             BEGIN
                  ActivateCodeEditor(NIL);
                  LoadEditor(s,0,0,0,0,TRUE,CursorHome,Fokus,ShowIt);
                  {zur alten Zeile springen wre gut}
                  Project.Modified := TRUE;
             END;
        END;

        {Edit Menu}
        cmSlidingUndo: IF Editor <> NIL THEN SlidingUndoDialog;
        cmGotoLine: GotoLineDialog;
        cmFindInFiles:
        BEGIN
             IF SearchThread = NIL THEN
             BEGIN
                  IF Editor <> NIL THEN
                  BEGIN
                       s := Editor.GetWord(Editor.CursorPos);
                       x := Editor.GetTextAfterWord(Editor.CursorPos);
                  END
                  ELSE
                  BEGIN
                       s := '';
                       x := '';
                  END;
                  FindInFilesDialog(s,x);
             END
             ELSE SearchThread.Terminate;
        END;
        cmBookmarks: BookmarksDialog;

        {View Menu}
        cmViewInspector: InitInspector;
        cmViewComponents: InitComponentViewer;
        cmWindowList: InitWindowList;
        cmMacroList: InitMacroList;
        cmClipBoardList: InitClipBoardWindow;
        cmViewBrowser: InitBrowser;
        cmFormUnit: IF Editor <> NIL THEN OpenRelatedForm(Editor);
        cmNewForm: NewFormWindow('');
        cmImport: Import;
        cmToolbars: ToolbarsDialog;
        cmToggleSpeedbar:
        BEGIN
             IF Speedbar = NIL THEN
             BEGIN
                  InsertSpeedbar;
                  Include(IdeSettings.StaticToolbars, st_Speedbar);
             END
             ELSE
             BEGIN
                  RemoveSpeedbar;
                  Exclude(IdeSettings.StaticToolbars, st_Speedbar);
             END;
        END;
        cmToggleNavigator:
        BEGIN
             IF Navigator = NIL THEN
             BEGIN
                  InsertNavigator;
                  Include(IdeSettings.StaticToolbars, st_CompPalette);
             END
             ELSE
             BEGIN
                  RemoveNavigator;
                  Exclude(IdeSettings.StaticToolbars, st_CompPalette);
             END;
        END;

        {Component Menu}
        cmNewComponent:NewComponent;
        cmConfigurePalette:ConfigurePalette;
        cmInstallComponents:
        BEGIN
             IF InstallComponents THEN RecompileCompLib(TRUE); {Projekt vorher schlieแen}
        END;
        cmRemoveComponents:RemoveComponents;
        cmOpenCompLib:OpenCompLib;
        cmRecompileCompLib:RecompileCompLib(TRUE); {Projekt vorher schlieแen}
        cmViewRepository: ViewRepository;
        cmAddToRepository:
        BEGIN
             FormEditor := TFormEditor(LastFocusedForm);
             IF not (LastFocusedForm IS TFormEditor) THEN FormEditor := NIL;
             AddFormToRepository(FormEditor);
        END;
        cmLoadTemplateForms:LoadTemplateForms;
        cmSaveTemplateForms:SaveTemplateForms;

        {Run Menu}
        cmRun: Run(FALSE); {dont start the debugger}
        cmRunParameters: RunParamDialog;
        cmCompile: Compile;
        cmMake: Make;
        cmBuild: Build;
        cmStopCompiler: StopCompiler;

        {Debug}
        cmAddWatch:
        BEGIN
             IF Editor <> NIL THEN
             BEGIN
                  s := Editor.GetWord(Editor.CursorPos);
                  x := Editor.GetTextAfterWord(Editor.CursorPos);
             END
             ELSE
             BEGIN
                  s := '';
                  x := '';
             END;
             AddWatch(s,x);
             ActivateCodeEditor(Editor);
        END;
        cmInspectValue:
        BEGIN
             InspectExpression;
        END;
        cmWatchPoints:
        BEGIN
             ViewWatchPoints;
        END;
        cmEvaluateModify:
        BEGIN
             IF Editor <> NIL THEN
             BEGIN
                  s := Editor.GetWord(Editor.CursorPos);
                  x := Editor.GetTextAfterWord(Editor.CursorPos);
             END
             ELSE
             BEGIN
                  s := '';
                  x := '';
             END;
             EvaluateModify(s,x);
             ActivateCodeEditor(Editor);
        END;
        cmUnloadProcess:
        BEGIN
             UnloadProcess;
        END;
        cmProgramReset:
        BEGIN
             ProgramReset;
        END;
        cmProgramReload:
        BEGIN
             IF not InDebugger THEN exit;
             UnloadDebugger;
             SendMsg(Handle,CM_COMMAND,cmProgReload,0);
             IF InDebugger THEN SetMainStatusText(LoadNLSStr(SiProcessLoaded),clBlack,clLtGray);
        END;
        cmProgReload:
        BEGIN
             HideSibylForms;
             exe := GetExeName;
             LastCommandFromSrc:=TRUE;
             AddSrcDir(Directories^.LibSrcDir);
             AddSrcDir(Directories^.IncSrcDir);
             DbgSetExceptions(DebugOpt^.RTL_Exceptions,DebugOpt^.SPCC_Exceptions);
             LoadDbgProcess(exe,Project.Settings.RunParam,Handle,Frame.Handle,2);
             IF not InDebugger THEN
             BEGIN
                  ErrorBox(LoadNLSStr(SiErrorLoadingProcess));
                  ShowSibylForms;
             END
             ELSE IF SymbolsWindow<>NIL THEN SymbolsWindow.UpdateSymbols;
             SetOptions(DebugOpt^.Options);
        END;
        cmGo:
        BEGIN
             IF LastDbgEditor<>NIL THEN LastDbgEditor.SetDebuggerLine(-1); {clear}
             LastDbgEditor:=NIL;
             Run(TRUE); {start the debugger!}
        END;
        cmStepInto:
        BEGIN
             ActivateCodeEditor(Editor);
             IF LastDbgEditor=NIL THEN
             BEGIN
LookTarget:
                  IF (not InDebugger) AND (not DebuggerRunning) THEN
                  BEGIN
                       IF not AutoSaveEnvironment THEN exit;
                       ClearBuildList;
                       src := GetMakeName;
                       exe := GetExeName;
                       IF not CheckDependencies(src,cancel) THEN
                       BEGIN
                            IF cancel THEN exit;

                            IF IdeSettings.AskRecompile THEN
                            BEGIN
                                 ret := Dialogs.MessageBox(LoadNLSStr(SiFilesOutOfDate)+#13#10+#13#10+
                                                          LoadNLSStr(SiRebuildFiles),
                                                          mtInformation,mbYesNoCancel);
                                 CASE ret OF
                                   mrYes: ;
                                   mrNo: goto NoCompile1;
                                   mrCancel: exit;
                                 END;
                            END;

                            IF not RunCompiler(Action_Make,src) THEN exit;
                       END;
NoCompile1:
                       {EXE Parameter auch in LoadDbgProcess ndern}
                       HideSibylForms;
                       LastCommandFromSrc:=TRUE;
                       AddSrcDir(Directories^.LibSrcDir);
                       AddSrcDir(Directories^.IncSrcDir);
                       DbgSetExceptions(DebugOpt^.RTL_Exceptions,DebugOpt^.SPCC_Exceptions);
                       LoadDbgProcess(exe,Project.Settings.RunParam,Handle,Frame.Handle,2);
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
                       IF not DebuggerRunning THEN
                       BEGIN
                            LastCommandFromSrc:=FALSE;
                            ShowCPUWindow(FALSE);
                       END;
                       //ELSE ErrorBox('No target window !');
                  END;
             END
             ELSE LastDbgEditor.DebugStepInto;
        END;
        cmStepOver:
        BEGIN
             ActivateCodeEditor(Editor);
             IF LastDbgEditor=NIL THEN goto LookTarget
             ELSE LastDbgEditor.DebugStepOver;
        END;
        cmGotoDebugCursor:
        BEGIN
             ActivateCodeEditor(Editor);
             IF Editor<>NIL THEN
             BEGIN
                  IF not InDebugger THEN
                  BEGIN
                       IF not AutoSaveEnvironment THEN exit;
                       ClearBuildList;
                       src := GetMakeName;
                       exe := GetExeName;
                       // die folgenden Parameter schon hier erfragen, da
                       // sie whrend des Compilierens verndert werden k”nnten
                       TheGotoSource:=Editor.FileName;
                       UpcaseStr(TheGotoSource);
                       TheGotoLine:=Editor.CursorPos.Y;
                       IF not CheckDependencies(src,cancel) THEN
                       BEGIN
                            IF cancel THEN exit;

                            IF IdeSettings.AskRecompile THEN
                            BEGIN
                                 ret := Dialogs.MessageBox(LoadNLSStr(SiFilesOutOfDate)+#13#10+#13#10+
                                                           LoadNLSStr(SiRebuildFiles),
                                                           mtInformation,mbYesNoCancel);
                                 CASE ret OF
                                   mrYes: ;
                                   mrNo: goto NoCompile2;
                                   mrCancel: exit;
                                 END;
                            END;

                            IF not RunCompiler(Action_Make,src) THEN exit;
                       END;
NoCompile2:
                       {EXE Parameter auch in LoadDbgProcess ndern}
                       HideSibylForms;
                       LastCommandFromSrc:=TRUE;
                       AddSrcDir(Directories^.LibSrcDir);
                       AddSrcDir(Directories^.IncSrcDir);
                       DbgSetExceptions(DebugOpt^.RTL_Exceptions,DebugOpt^.SPCC_Exceptions);
                       LoadDbgProcess(exe,Project.Settings.RunParam,Handle,Frame.Handle,4);
                       IF not InDebugger THEN
                       BEGIN
                            ErrorBox(LoadNLSStr(SiErrorLoadingProcess));
                            ShowSibylForms;
                       END
                       ELSE IF SymbolsWindow<>NIL THEN SymbolsWindow.UpdateSymbols;
                       SetOptions(DebugOpt^.Options);
                  END
                  ELSE Editor.DebugGotoLine;
             END
             ELSE ErrorBox(LoadNLSStr(SiNoTargetWindow));
        END;
        cmReturnFromFunction:
        BEGIN
             IF SetReturnFromFunctionBreak THEN Run(TRUE);
        END;
        cmBreakPoints:
        BEGIN
             CodeEditor.ShowControlCentre(BreakpointsIndex,Fokus);
        END;
        cmLocalVariables:
        BEGIN
             ViewLocalVariables;
        END;
        cmToggleBreakPoint:
        BEGIN
             ActivateCodeEditor(Editor);
             IF Editor <> NIL THEN Editor.cmToggleBreakPoint;
             IF BPList <> NIL THEN BPList.UpdateBreaks;
        END;
        cmClearAllBreakPoints:
        BEGIN
             ClearAllBreakPoints;
             IF BPList <> NIL THEN BPList.UpdateBreaks;
        END;
        cmViewSource:
        BEGIN
             ViewSource;
        END;
        cmViewSymbols:
        BEGIN
             ViewSymbols;
        END;
        cmViewDump:
        BEGIN
             NewDumpWindow;
        END;
        cmViewCPU:
        BEGIN
             IF DebuggerRunning THEN
             BEGIN
                  ErrorBox(LoadNLSStr(SiCannotOpenCPUWindow));
                  exit;
             END;
             ShowCPUWindow(TRUE);
        END;
        cmViewWatch:
        BEGIN
             ViewWatch;
        END;

        {Project Menu}
        cmProjectNew:
        BEGIN
             IF CompilerActive THEN exit;
             IF InDebugger THEN exit;
             Expert := GetProjectExpert;

             IF Expert <> NIL THEN Expert.Execute
             ELSE NewProjectDialog;
        END;
        cmProjectLoad:
        BEGIN
             IF CompilerActive THEN exit;
             IF InDebugger THEN exit;
             OpenProject('',TRUE);
        END;
        cmProjectClose:
        BEGIN
             IF CompilerActive THEN exit;
             IF InDebugger THEN exit;
             CloseCurrentProject;
        END;
        cmProjectSave:SaveProject(TRUE);
        cmProjectSaveAs:SaveProjectAs(TRUE);
        cmProjectManager:InitProjectManager;
        cmSetPrimary:
        BEGIN
             CFOD.Create(SELF);
             CFOD.HelpContext := hctxDialogSetPrimary;
             CFOD.Title := LoadNLSStr(SiMenuSetPrimaryHint);
             CFOD.FileName := Project.Settings.Primary;
             CFOD.AddFilter(LoadNLSStr(SiAllFiles)+' (*.*)','*.*');
             CFOD.AddFilter(LoadNLSStr(SiPascalFiles)+' (*.pas)','*.PAS');
             CFOD.FilterIndex := 2;
             CFOD.DefaultExt := GetDefaultExt('*.PAS');
             IF CFOD.Execute THEN
             BEGIN
                  SetPrimaryFile(CFOD.Filename);
                  Project.Modified := TRUE;
             END;
             CFOD.Destroy;
        END;
        cmClearPrimary:
        BEGIN
             SetPrimaryFile('');
             Project.Modified := TRUE;
        END;
        cmProjectSettings:ProjectDialog;
        cmLastProject1..cmLastProjectN:
        BEGIN
             IF CompilerActive THEN exit;
             IF InDebugger THEN exit;
             s := GetMenuItem(Command,ProjectsHistory);
             IF s <> '' THEN OpenProject(s,TRUE);
        END;

        {Experts Menu}
        cmExpert1..cmExpert15:
        BEGIN
             ExpertIndex:=Command-cmExpert1;
             Count:=0;
             FOR t:=0 TO LibExpertInstances.Count-1 DO
             BEGIN
                  Expert:=TIExpert(LibExpertInstances.Items[t]);
                  IF Expert.GetStyle=esStandard THEN
                  BEGIN
                       IF Count=ExpertIndex THEN
                       BEGIN
                            Expert.Execute;
                            break;
                       END
                       ELSE inc(Count);
                  END;
             END;
        END;

        {Options Menu}
        cmGeneral: GeneralDialog;
        cmCustomize: CustomizeDialog;
        cmLanguageSettings: LanguageSettingsDialog;
        cmToolOptions: ToolOptionDialog;

        {Help Menu}
        cmTipoftheday: TipOfTheDayDialog(TRUE);  {Fehler zeigen}
        cmAbout: AboutDialog;

        {sonstige}
        cmNewDock: NewDockingToolbar;

        ELSE MsgHandled := FALSE;
     END;

     IF MsgHandled THEN Command := cmNull;

     Inherited CommandEvent(Command);
END;


PROCEDURE SetDebuggerActive;
BEGIN
     IF CPUWindow<>NIL THEN CPUWindow.SetCPUDebuggerActive;
     {Bitmap ndern in rotes Pause Zeichen?}
END;

PROCEDURE ResetDebuggerActive;
BEGIN
     IF CPUWindow<>NIL THEN CPUWindow.ResetCPUDebuggerActive;
     {Bitmap ndern in grnes Stop Zeichen?}
END;


FUNCTION UpdateDebugWindows(CONST Src:STRING;Line:WORD):LONGWORD;
VAR Buf:TDbgBuf;
    FirstItem,LastItem:LONGWORD;
    Item:PCPUListItem;
    rc:TRect;
    ThePage:TPage;
BEGIN
     result:=0;
     IF Not GetRegisterSet(Buf) THEN
     BEGIN
          IF CPUWindow<>NIL THEN CPUWindow.RightToolBar.RegisterNoteBook.CPURegistersValid:=FALSE;
          ErrorBox(LoadNLSStr(SiCouldNotGetRegisters));
          Buf.EIP:=0;
     END
     ELSE
     BEGIN
          result:=Buf.ESP;
          IF CPUWindow<>NIL THEN
          BEGIN
               CPUWindow.RightToolBar.RegisterNoteBook.CPURegistersValid:=TRUE;
               WITH CPUWindow.RightToolBar.RegisterNoteBook.CPURegisters DO
               BEGIN
                    EAX:=Buf.EAX;
                    EBX:=Buf.EBX;
                    ECX:=Buf.ECX;
                    EDX:=Buf.EDX;
                    ESI:=Buf.ESI;
                    EDI:=Buf.EDI;
                    EBP:=Buf.EBP;
                    ESP:=Buf.ESP;
                    EFLAGS:=Buf.EFLAGS;
                    EIP:=Buf.EIP;
                    CS:=Buf.CS;
                    DS:=Buf.DS;
                    ES:=Buf.ES;
                    FS:=Buf.SS;
                    GS:=Buf.GS;
                    SS:=Buf.SS;
               END;

               CPUWindow.RightToolBar.RegisterNoteBook.FPURegistersValid:=
                  GetCoproRegisterSet(CPUWindow.RightToolBar.RegisterNoteBook.FPURegisters);

               CPUWindow.CurrentAddress:=CPUWindow.RightToolBar.RegisterNoteBook.CPURegisters.EIP;
               IF CPUList.Count>0 THEN
               BEGIN
                    FirstItem:=LONGWORD(CPUWindow.ClientAddrList.First);
                    LastItem:=LONGWORD(CPUWindow.ClientAddrList.Last);
                    IF ((CPUWindow.CurrentAddress<FirstItem)OR(CPUWindow.CurrentAddress>LastItem)) THEN
                    BEGIN
                         EnableSecondList;
                         CPUList.Clear;
                         CPUWindow.InitCPUList(CPUWindow.CurrentAddress);
                         DisableSecondList;
                    END;
               END;

               IF CPUWindow.BottomToolBar.DumpNoteBook.ActivePage=CPUWindow.BottomToolBar.DumpNoteBook.DumpPage.Caption THEN
                 CPUWindow.BottomToolBar.DumpNoteBook.DumpField.Redraw(
                              CPUWindow.BottomToolBar.DumpNoteBook.DumpField.ClientRect);
               CPUWindow.BottomToolBar.DumpNoteBook.UpdateStack;
          END;
     END;

     IF CPUWindow<>NIL THEN
     BEGIN
          ThePage:=TPage(CPUWindow.RightToolBar.RegisterNoteBook.Pages.Objects[CPUWindow.RightToolBar.RegisterNoteBook.PageIndex]);
          rc:=ThePage.ClientRect;
          inc(rc.Left,2);
          inc(rc.Bottom,2);
          dec(rc.Top,2);
          dec(rc.Right,2);
          CPUWindow.RightToolBar.RegisterNoteBook.PaintPage(ThePage,rc);
          ThePage:=TPage(CPUWindow.BottomToolBar.DumpNoteBook.Pages.Objects[CPUWindow.BottomToolBar.DumpNoteBook.PageIndex]);
          ThePage.Refresh;
          CPUWindow.Refresh;
          IF not LastCommandFromSrc THEN CPUWindow.Focus;
          IF CPUList.Count>0 THEN
          BEGIN
              Item:=CPUList.First;
              CPUWindow.CodeUpScrolled:=Item^.Address;
              CPUWindow.VertScrollBar.Position:=CPUWindow.CodeUpScrolled;
          END;
     END;
     IF Line<>0 THEN SetDebuggerActSrcLine(Src,Line);
     LastSrcFile:=Src;
     LastSrcLine:=Line;
     UpdateWatchWindow(TRUE);
     InvalidateAllDumps;
END;


PROCEDURE TMyForm.InformFromDebugger(VAR Msg:TMessage);
VAR ps:^STRING;
    s:STRING;
    NextAction:BYTE;
    DbgReturn:DebugReturn;
    adress:ULONG;
    ret:TMsgDlgReturn;
    ESP:LONGWORD;
LABEL l,l1;
BEGIN
     LockInput(Handle);

     {$IFDEF OS2}
     NextAction:=A_WAITSEM;  {Wait for continue command}
     {$ENDIF}
     {$IFDEF WIN32}
     NextAction:=A_CONTINUE;
     {$ENDIF}
     ps:=POINTER(Msg.Param1);
     s:=ps^;
     SetMainStatusText(s,clBlack,clLtGray);

     GetDebugReturn(DbgReturn);
     case Dbgreturn.msg OF
         DBG_N_SSTEPCOMPLETED:
         BEGIN
              DeleteWorkThread(FALSE);  {Delete debugger thread}
              UpdateDebugWindows(DbgReturn.Source,DbgReturn.Line);

              ResetDebuggerActiveProc;
              SetNextDbgBrk(0,0);  {dont set any breaks}
              goto l;  {No action}
         END;
         DBG_N_WATCHPOINT:
         BEGIN
              DeleteWorkThread(FALSE);  {Delete debugger thread}
              UpdateDebugWindows(DbgReturn.Source,DbgReturn.Line);

              ErrorBox(LoadNLSStr(SiWatchPointHit));

              ResetDebuggerActiveProc;
              SetNextDbgBrk(0,0);  {dont set any breaks}
              goto l;  {No action}
         END;
         DBG_N_EXCEPTION:
         BEGIN
              CASE DbgReturn.Data OF
                XCPT_PROCESS_TERMINATE:
                BEGIN
                     EraseCPUAlias;
                     SendMsg(Handle,CM_COMMAND,cmUnloadProcess,0);
                     {$IFDEF OS2}
                     DosSleep(100);
                     {$ENDIF}
                     SetNextDbgBrk(0,0);  {dont set any breaks}
                     goto l;
                END;
                XCPT_SINGLE_STEP:NextAction:=A_CONTINUE; {Continue}
                XCPT_BREAKPOINT:
                BEGIN
                     CASE DbgReturn.BreakSource OF
                       0: {TRUE Breakpoint}
                       BEGIN
                           DeleteWorkThread(FALSE);  {Delete debugger thread}

                           {$IFDEF OS2}
                           WinSetSysModalWindow(HWND_DESKTOP,0);
                           WinSetWindowPos(Frame.Handle,HWND_TOP,0,0,0,0,SWP_ZORDER OR
                                           SWP_ACTIVATE OR SWP_SHOW);
                           WinFocusChange(HWND_DESKTOP,Frame.Handle,FC_NOLOSEFOCUS OR
                                          FC_NOLOSEACTIVE OR FC_NOLOSESELECTION);
                           {$ENDIF}
                           {$IFDEF WIN32}
                           SetForeGroundWindow(Frame.Handle);
                           If CodeEditor<>Nil Then CodeEditor.BringToFront;
                           {$ENDIF}

                           UpdateDebugWindows(DbgReturn.Source,DbgReturn.Line);

                           ResetDebuggerActiveProc;
                           {Mark breakpoint to set again}
                           IF CPUWindow<>NIL THEN CPUWindow.UnMarkBreakPointAtEIP;
                           {$IFDEF WIN32}
                           NextAction:=A_RETRYXCPT;
                           {$ENDIF}
                           goto l;  {No action}
                       END;
                       2: {Start Breakpoint}
                       BEGIN
                            {Set outstanding BreakPoints}
                            InitBreakPoints; {Setze BreakPoints aus Liste im Debugger}
                            StartReached:=TRUE;
l1:
                            DeleteWorkThread(FALSE);  {Delete debugger thread}
                            IF CPUWindow<>NIL THEN
                              CPUWindow.BottomToolBar.DumpNoteBook.DumpField.DumpAddr:=$20000;
                            ESP:=UpdateDebugWindows(DbgReturn.Source,DbgReturn.Line);
                            IF StackBase=0 THEN StackBase:=ESP;

                            ResetDebuggerActiveProc;
                            SetNextDbgBrk(0,0);  {dont set any breaks}
                            IF not LastCommandFromSrc THEN
                             IF CPUWindow<>NIL THEN CPUWindow.Focus;
                            {$IFDEF WIN32}
                            SetForeGroundWindow(Frame.Handle);
                            If CodeEditor<>Nil Then CodeEditor.BringToFront;
                            NextAction:=A_RETRYXCPT;
                            {$ENDIF}
                            goto l;  {No action}
                       END;
                       3: {Goto line Breakpoint}
                       BEGIN
                            goto l1; {Track line}
                       END;
                       4: {Goto line Break if debugger was not active}
                       BEGIN
                            IF not GetAdressfromLine(TheGotoSource,TheGotoLine,adress) THEN
                            BEGIN
                                ErrorBox(LoadNLSStr(SiNoCodeGeneratedForThisLine));
                                goto l1; {Track Line}
                            END;

                            {Set outstanding BreakPoints}
                            InitBreakPoints; {Setze BreakPoints aus Liste im Debugger}

                            {Set goto Breakpoint}
                            IF not SetBreakPoint(adress,3) THEN
                            BEGIN
                                 ErrorBox(LoadNLSStr(SiCouldNotSetBreakPoint));
                                 goto l1; {Track Line}
                            END;

                            StartReached:=TRUE;
                            ESP:=UpdateDebugWindows('',0);
                            IF StackBase=0 THEN StackBase:=ESP;

                            NextAction:=A_CONTINUE; {Continue Run}
                       END;
                       5:  {Run Break if Debugger was not active}
                       BEGIN
                            {Set outstanding BreakPoints}
                            InitBreakPoints; {Setze BreakPoints aus Liste im Debugger}
                            StartReached:=TRUE;
                            ESP:=UpdateDebugWindows('',0);
                            IF StackBase=0 THEN StackBase:=ESP;

                            NextAction:=A_CONTINUE; {Continue Run}
                       END;
                       ELSE NextAction:=A_CONTINUE; {SSTEP Break}
                     END; {case}
                END;
                XCPT_ASYNC_PROCESS_TERMINATE:NextAction:=A_CONTINUE; {Continue}
                XCPT_GUARD_PAGE_VIOLATION:NextAction:=A_CONTINUE; {Continue}
                ELSE {other exception}
                BEGIN
                     {$IFDEF WIN32}
                     SetForeGroundWindow(Frame.Handle);
                     If CodeEditor<>Nil Then CodeEditor.BringToFront;
                     {$ENDIF}

                     {Set source file information}
                     UpdateDebugWindows(DbgReturn.Source,DbgReturn.Line);

                     s:=DbgReturn.Source;
                     IF DbgReturn.Line<>0 THEN s:=s+'('+tostr(DbgReturn.Line)+')';
                     ret:=MessageBox(FmtLoadNLSStr(SiExceptionOccured,[DbgReturn.Errstr,s])+#13#10+
                                     LoadNLSStr(SiAbortTerminates)+#13#10+
                                     LoadNLSStr(SiRetryWillStop)+#13#10+
                                     LoadNLSStr(SiIgnoreWillRunHandlers),
                                     mtError,mbAbortRetryIgnore);
                     IF ret=mrAbort THEN
                     BEGIN {Do not call Exception handlers}
                          UnlockInput;
                          DeleteWorkThread(FALSE);
                          UnlockInput;
                          UnloadProcess;
                          SendMsg(Handle,CM_COMMAND,cmUnloadProcess,0);
                          {$IFDEF OS2}
                          DosSleep(100);
                          {$ENDIF}
                          ResetDebuggerActiveProc;
                          SetNextDbgBrk(0,0);  {dont set any breaks}
                          NextAction:=A_ABORTXCPT;
                          goto l;
                     END
                     ELSE IF ret=mrRetry THEN
                     BEGIN
                          NextAction:=A_RETRYXCPT;
                          //goto l1;
                     END
                     ELSE
                     BEGIN
                          IF LastDbgEditor<>NIL THEN LastDbgEditor.SetDebuggerLine(-1); {clear}
                          LastDbgEditor:=NIL;

                          NextAction:=A_RUNXCPT; {Run Exception Handlers}
                     END;
                END;
              END; {case}
         END;
         DBG_N_PROCTERM:
         BEGIN
              SendMsg(Handle,CM_COMMAND,cmUnloadProcess,0);
              {$IFDEF OS2}
              DosSleep(100);
              {$ENDIF}
              UpdateWatchWindow(TRUE);
              goto l;
         END;
         DBG_N_ERROR:
         BEGIN
              SendMsg(Handle,CM_COMMAND,cmUnloadProcess,0);
              ErrorBox(FmtLoadNLSStr(SiDebuggerError,[s]));
              goto l;
         END;
     end; {case}

     IF NextAction=A_WAITSEM THEN
     BEGIN
          ResetDebuggerActiveProc;
          CreateEventSem;
     END;

     IF NextAction=A_CONTINUE THEN UnlockInput;

     SetNextDbgBrk(0,0);  {dont set any breaks}
     {$IFDEF OS2}
     SetNextAction(NextAction);
     {$ENDIF}
l:
     {$IFDEF WIN32}
     SetNextAction(NextAction);
     {$ENDIF}
     Msg.Handled:=TRUE;
END;


{$HINTS OFF}
PROCEDURE TMyForm.EvSpeedBtnDown(Sender:TObject;Button:TMouseButton;
                                 ShiftState:TShiftState;X,Y:LONGINT);
VAR  i:LONGINT;
BEGIN
     IF Button <> mbLeft THEN exit;

     i := CommandToIndex(TSpeedButton(Sender).Command);
     IF i <> -1 THEN
     BEGIN
          SetMainStatusText(LoadNLSStr(MenuEntries[i].Hint), clBlack, clLtGray);
     END;
END;


PROCEDURE TMyForm.EvSpeedBtnUp(Sender:TObject;Button:TMouseButton;
                                 ShiftState:TShiftState;X,Y:LONGINT);
BEGIN
     IF Button <> mbLeft THEN exit;

     SetMainStatusText('', clBlack, clLtGray);
END;


PROCEDURE TMyForm.EvPalettenPopup(Sender:TObject);
VAR  i:LONGINT;
     Item:TMenuItem;
     Panel:TDockingPalette;
BEGIN
     FOR i := 0 TO PalettenPopup.Items.Count-1 DO
     BEGIN
          Item := PalettenPopup.Items[i];
          IF Item.Tag <> 0 THEN
          BEGIN
               //Update State
               Panel := TDockingPalette(Item.Tag);
               Item.Checked := Panel.DockingState <> dsHide;
               Item.Enabled := (Panel <> ControlCentre) OR (CanSwitchDockingState);
          END;
     END;
END;
{$HINTS ON}


PROCEDURE TMyForm.EvShowHint(Sender:TObject);
VAR  s:STRING;
BEGIN
     IF StatusPanel = NIL THEN exit;  {Nothing to do}

     IF Sender IS TControl THEN
     BEGIN
          s := GetLongHint(TControl(Sender).Hint);
          SetMainStatusText(s,clBlack,clLtGray);
     END
     ELSE
     IF Sender IS TApplication THEN
     BEGIN
          s := Application.Hint;
          SetMainStatusText(s,clBlack,clLtGray);
     END;
END;


PROCEDURE TMyForm.EvTranslateShortCut(Sender:TObject;Keycode:TKeyCode;VAR Receiver:TForm);
BEGIN
     {allgemeine Accelerators werden hier an das MainWindow weitergeleitet}
     IF Sender = SELF THEN exit;                      {Rekursion vermeiden}

     IF KeyCode IN
       [{MainMenu} kbAlt, kbF10, kbAltSpace,
        {MainMenu Items Englisch}
        kbAltF, kbAltE, kbAltS, kbAltV, kbAltC, kbAltD, kbAltP, kbAltO, kbAltT,
        kbAltW, kbAltH,
        {MainMenu Items Deutsch}
        kbAltD, kbAltB, kbAltS, kbAltA, kbAltK, kbAltG, kbAltP, kbAltO, kbAltT,
        kbAltF, kbAltH] THEN
     BEGIN
          Receiver := SELF;
          IF WindowState = wsMinimized THEN WindowState := wsNormal;
          IF (not Showing) THEN Show;
     END;
END;


PROCEDURE TMyForm.TranslateShortCut(Keycode:TKeyCode;VAR Receiver:TForm);
BEGIN
     Inherited TranslateShortCut(Keycode,Receiver);

(* geht nicht
     IF KeyCode = kbAlt THEN
     BEGIN
          {$IFDEF OS2}
          IF LastFocusedForm <> NIL THEN
          BEGIN
               LastFocusedForm.BringToFront;
               LastFocusedForm.Focus;
               IF LastFocusedForm = CodeEditor THEN
                 IF CodeEditor.TopEditor <> NIL
                 THEN CodeEditor.TopEditor.Focus;
          END;
          {$ENDIF}
     END;
*)
END;


FUNCTION GetHelpFileName:STRING;
VAR  s,d,n,e:STRING;
     i:INTEGER;
BEGIN
     FSplit(ParamStr(0),d,n,e);
     Result := d +'SIBYL.HLP '+d+'OS2API.HLP';
     FOR i := 1 TO ParamCount DO
     BEGIN
          s := ParamStr(i);
          s := FExpand(s);
          UpcaseStr(s);
          FSplit(s,d,n,e);
          IF pos('.HLP',e) <> 0 THEN Result := Result + ' ' + s;
     END;
END;


PROCEDURE InitLanguage;
VAR Languages:PVDELanguageList;
    Table:POINTER;
    p:^LONGINT;
    dummy:^WORD;
    Len:LONGWORD;
BEGIN
     Languages:=ReadVDELanguageList(FALSE);

     IF Languages=NIL THEN //set compiler error table
     BEGIN

     END;

     WHILE Languages<>NIL DO
     BEGIN
          IF Languages^.Active THEN
            IF Languages^.Name<>'Default' THEN
          BEGIN
               GetMem(Table,Languages^.TableLen+4);
               Move(Languages^.Table^,Table^,Languages^.TableLen);
               p:=POINTER(Table);
               inc(p,Languages^.TableLen);
               p^:=0;
               ASM
                  PUSH DWORD PTR Table
                  CALLN32 SYSTEM.AddStringTableRes
               END;
          END;
          Languages:=Languages^.Next;
     END;

     //Set Compiler Error Table
     dummy:=FindStringTableRes('SIBYL_NLS_Default',Len);
     inc(dummy,4); //skip Min and Max Index
     WHILE dummy^<370 DO //suche compiler Fehlermeldungen
     BEGIN
          inc(dummy,2);
          inc(dummy,(dummy^ AND 255)+1);
     END;
     IF dummy^<>370 THEN dummy:=NIL;
     ErrorTable:=Pointer(dummy);
END;



BEGIN
     MainIcon.Create;
     MainIcon.LoadFromResourceName('MainForm');
     InspectorIcon.Create;
     InspectorIcon.LoadFromResourceName('ISpector');
     WatchIcon.Create;
     WatchIcon.LoadFromResourceName('Watch');
     EditIcon.Create;
     EditIcon.LoadFromResourceName('Edit');
     InspectIcon.Create;
     InspectIcon.LoadFromResourceName('Inspect');
     CpuWinIcon.Create;
     CpuWinIcon.LoadFromResourceName('CpuWin');

     ASM
        MOVB SYSTEM.InheritsSoftMode,1        {!!! wegen COMPLIB.DLL !!!}
        MOVB CLASSES.InsideDesigner,1
     END;
     AsynchExec := TRUE;
     RegisterDefaultClassesProc := @RegisterDefaultComponents;
     InitToolbarsProc := @InitToolbars;
     RemoveNavigatorProc := @RemoveNavigator;
     ShowCPUWindowProc := @ShowCPUWindow;

     AppMemList.Create;

     ProgramResetProc := @IdeProgramReset;
     SetDebuggerActiveCallBack := SetDebuggerActive;
     ResetDebuggerActiveCallBack := ResetDebuggerActive;

     TRY
       InitLanguage;
     EXCEPT
     END;

     RegisterDefaultComponents;

     Application.Create;
     {Initialisierung}
     IF not Application.DBCSSystem THEN Application.Font := Screen.SmallFont;
// Can't use this til FP4 AaronL
//     Application.GradientTitlebar := True;

     RunStartupDialog;

     Application.HelpFile := GetHelpFileName;
     Application.HelpWindowTitle := LoadNLSStr(SiSibylHelp);
     Application.KeysHelpContext := hctxKeysHelp;
     Application.CreateForm(TMyForm,MyMainForm);
     Application.Run;
     Application.Destroy;
END.
