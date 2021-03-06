
{浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融
 �                                                                          �
 �     Sibyl Visual Development Environment                                 �
 �                                                                          �
 �     Copyright (C) 1995,99 SpeedSoft Germany,   All rights reserved.      �
 �                                                                          �
 藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕}

{浜様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融
 �                                                                          �
 � Sibyl Integrated Development Environment (IDE)                           �
 � Object-oriented development system.                                      �
 �                                                                          �
 � Copyright (C) 1995,99 SpeedSoft GbR, Germany                             �
 �                                                                          �
 � This program is free software; you can redistribute it and/or modify it  �
 � under the terms of the GNU General Public License (GPL) as published by  �
 � the Free Software Foundation; either version 2 of the License, or (at    �
 � your option) any later version. This program is distributed in the hope  �
 � that it will be useful, but WITHOUT ANY WARRANTY; without even the       �
 � implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR          �
 � PURPOSE.                                                                 �
 � See the GNU General Public License for more details. You should have     �
 � received a copy of the GNU General Public License along with this        �
 � program; if not, write to the Free Software Foundation, Inc., 59 Temple  �
 � Place - Suite 330, Boston, MA 02111-1307, USA.                           �
 �                                                                          �
 � In summary the original copyright holders (SpeedSoft) grant you the      �
 � right to:                                                                �
 �                                                                          �
 � - Freely modify and publish the sources provided that your modification  �
 �   is entirely free and you also make the modified source code available  �
 �   to all for free (except a fee for disk/CD production etc).             �
 �                                                                          �
 � - Adapt the sources to other platforms and make the result available     �
 �   for free.                                                              �
 �                                                                          �
 � Under this licence you are not allowed to:                               �
 �                                                                          �
 � - Create a commercial product on whatever platform that is based on the  �
 �   whole or parts of the sources covered by the license agreement. The    �
 �   entire program or development environment must also be published       �
 �   under the GNU General Public License as entirely free.                 �
 �                                                                          �
 � - Remove any of the copyright comments in the source files.              �
 �                                                                          �
 � - Disclosure any content of the source files or use parts of the source  �
 �   files to create commercial products. You always must make available    �
 �   all source files whether modified or not.                              �
 �                                                                          �
 藩様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕}

UNIT Sib_Ctrl;

INTERFACE

USES SysUtils,Messages,Classes,Forms,Graphics,Buttons,StdCtrls,Outline,DockTool,
     XplorBtn,Consts;


TYPE
    TInspectorComboBox=CLASS(TComboBox)
      PRIVATE
         FEdit:TEdit;
      PROTECTED
         PROCEDURE SetupComponent;OVERRIDE;
         PROCEDURE UpdateListBoxPos(VAR ALeft,ABottom,AWidth,AHeight:LONGINT);OVERRIDE;
         PROCEDURE ScanEvent(VAR KeyCode:TKeyCode;RepeatCount:BYTE);OVERRIDE;
      PUBLIC
         PROPERTY AlternateButton;
         PROPERTY Edit:TEdit read FEdit;
    END;


    TUnindexedOutline=CLASS(TOutline)
      PUBLIC
         FUNCTION  AddObjectNode(Node:TOutlineNode;CONST Text:STRING;Data:POINTER):TOutlineNode;
         FUNCTION  AddChildObjectNode(Node:TOutlineNode;CONST Text:STRING;Data:POINTER):TOutlineNode;
         FUNCTION  InsertObjectNode(Node:TOutlineNode;CONST Text:STRING;Data:POINTER):TOutlineNode;
         PROCEDURE DeleteNode(Node:TOutlineNode);
         FUNCTION  IndexOfObject(Data:POINTER):LONGINT;
    END;


    TProjectFilesOutline=CLASS(TUnindexedOutline)
         HandlePopupEvent:BOOLEAN;
         PROCEDURE CheckMenuPopup(pt:TPoint);OVERRIDE;
    END;


    TDockingPalette=CLASS(TDockingToolbar)
      PROTECTED
         PROCEDURE CommandEvent(VAR Command:TCommand);OVERRIDE;
      PUBLIC
         MenuItem:TMenuItem;
         PROPERTY Form;
         PROPERTY Visible;
    END;


    TXPLButton=CLASS(TExplorerButton)
      PRIVATE
         FOnDestroy:TNotifyEvent;
      PROTECTED
         PROCEDURE SetupComponent; OVERRIDE;
      PUBLIC
         DESTRUCTOR Destroy; OVERRIDE;
         PROPERTY OnDestroy:TNotifyEvent read FOnDestroy write FOnDestroy;
    END;


FUNCTION InsertBitBtnRes(Parent:TControl;X,Y,W,H:LONGINT;
           BmpId:LONGWORD;Cmd:TCommand;NewTitle,Hint:STRING):TBitBtn;
FUNCTION InsertInspectorComboBox(Parent:TControl;X,Y,W,H:LONGINT;Style:TComboBoxStyle):TInspectorComboBox;

FUNCTION InsertBitBtnNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;
                         Kind:TBitBtnKind;Caption,Hint:LONGINT):TBitBtn;
FUNCTION InsertSpeedButtonNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;
                              BitmapId:LONGWORD;Caption,Hint:LONGINT):TSpeedButton;
FUNCTION InsertXPLButtonNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;
                            BitmapId:LONGWORD;Hint:LONGINT;flat:BOOLEAN):TXPLButton;
FUNCTION InsertGroupBoxNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;
                           Caption:LONGINT):TGroupBox;
FUNCTION InsertRadioButtonNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;
                              Caption,Hint:LONGINT):TRadioButton;
FUNCTION InsertCheckBoxNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;
                        Caption,Hint:LONGINT):TCheckBox;
FUNCTION InsertLabelNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;
                        Caption:LONGINT):TLabel;
FUNCTION InsertButtonNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;
                         Caption,Hint:LONGINT):TButton;

PROCEDURE SetExplorerBtnLook(flat:BOOLEAN);

VAR
    Paletten:TStringList;
    XPLList:TList;


IMPLEMENTATION


FUNCTION InsertBitBtnNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;Kind:TBitBtnKind;Caption,Hint:LONGINT):TBitBtn;
BEGIN
     Result.Create(Parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.TabStop := TRUE;
     IF Hint<>0 THEN Result.Hint := LoadNLSStr(Hint);
     Result.Parent := Parent;
     Result.Kind := Kind;
     Result.Caption := LoadNLSStr(Caption);
END;

FUNCTION InsertSpeedButtonNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;BitmapId:LONGWORD;Caption,Hint:LONGINT):TSpeedButton;
BEGIN
     Result.Create(Parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := LoadNLSStr(Caption);
     Result.TabStop := FALSE;
     IF Hint<>0 THEN Result.Hint := LoadNLSStr(Hint);
     IF BitmapId <> 0 THEN Result.Glyph.LoadFromResourceId(BitmapId);
     Result.Parent := Parent;
END;

FUNCTION InsertXPLButtonNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;BitmapId:LONGWORD;Hint:LONGINT;flat:BOOLEAN):TXPLButton;
BEGIN
     Result.Create(Parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Flat := flat;
     IF Hint<>0 THEN Result.Hint := LoadNLSStr(Hint);
     IF BitmapId <> 0 THEN Result.Glyph.LoadFromResourceId(BitmapId);
     Result.Parent := Parent;
END;

FUNCTION InsertGroupBoxNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;
                           Caption:LONGINT):TGroupBox;
BEGIN
     Result.Create(Parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := LoadNLSStr(Caption);
     Result.Parent := Parent;
END;

FUNCTION InsertRadioButtonNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;Caption,Hint:LONGINT):TRadioButton;
BEGIN
     Result.Create(Parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := LoadNLSStr(Caption);
     Result.TabStop := TRUE;
     IF Hint<>0 THEN Result.Hint := LoadNLSStr(Hint);
     Result.Parent := Parent;
END;


FUNCTION InsertCheckBoxNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;Caption,Hint:LONGINT):TCheckBox;
BEGIN
     Result.Create(Parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := LoadNLSStr(Caption);
     Result.TabStop := TRUE;
     IF Hint<>0 THEN Result.Hint := LoadNLSStr(Hint);
     Result.Parent := Parent;
END;

FUNCTION InsertLabelNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;
                        Caption:LONGINT):TLabel;
BEGIN
     Result.Create(Parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := LoadNLSStr(Caption);
     Result.AutoSize := FALSE;  {!}
     Result.Parent := Parent;
END;

FUNCTION InsertButtonNLS(Parent:TControl;Left,Bottom,Width,Height:LONGINT;Caption,Hint:LONGINT):TButton;
BEGIN
     Result.Create(Parent);
     Result.SetWindowPos(Left,Bottom,Width,Height);
     Result.Caption := LoadNLSStr(Caption);
     Result.TabStop := TRUE;
     IF Hint<>0 THEN Result.Hint := LoadNLSStr(Hint);
     Result.Parent := Parent;
END;


FUNCTION InsertBitBtnRes(Parent:TControl;X,Y,W,H:LONGINT;
           BmpId:LONGWORD;Cmd:TCommand;NewTitle,Hint:STRING):TBitBtn;
BEGIN
     Result.Create(Parent);
     Result.SetWindowPos(X,Y,W,H);
     Result.Caption := NewTitle;
     Result.TabStop := TRUE;
     Result.Hint := Hint;
     Result.Kind := bkCustom;
     IF BmpId <> 0 THEN Result.Glyph.LoadFromResourceId(BmpId);
     Result.ModalResult := Cmd;
     Result.Command := Cmd;
     Result.Parent := Parent;
END;


FUNCTION InsertInspectorComboBox(Parent:TControl;X,Y,W,H:LONGINT;Style:TComboBoxStyle):TInspectorComboBox;
BEGIN
     result.Create(Parent);
     result.Style := Style;
     result.SetWindowPos(X,Y,W,H);
     result.Parent := Parent;
END;



{ TInspectorComboBox }

PROCEDURE TInspectorComboBox.SetupComponent;
VAR  i:LONGINT;
     Comp:TControl;
BEGIN
     Inherited SetupComponent;  {insert the FEdit}

     FOR i := 0 TO ControlCount-1 DO
     BEGIN
          Comp := Controls[i];
          IF Comp IS TEdit THEN FEdit := TEdit(Comp);
     END;
END;


PROCEDURE TInspectorComboBox.UpdateListBoxPos(VAR ALeft,ABottom,AWidth,AHeight:LONGINT);
VAR  NewWidth:LONGINT;
BEGIN
     Inherited UpdateListBoxPos(ALeft,ABottom,AWidth,AHeight); {oben/unten}

     NewWidth := AWidth;
     IF NewWidth < 120 THEN NewWidth := 120;
     IF NewWidth > Parent.Width
     THEN NewWidth := Parent.Width - Screen.SystemMetrics(smCxVScroll);
     ALeft := ALeft + AWidth - NewWidth;
     AWidth := NewWidth;
END;


PROCEDURE TInspectorComboBox.ScanEvent(VAR KeyCode:TKeyCode;RepeatCount:BYTE);
BEGIN
     IF KeyCode IN [kbCUp,kbCDown] THEN
     BEGIN
          IF OnScan <> NIL THEN
          BEGIN
               OnScan(SELF,KeyCode);
               KeyCode := kbNull;
               exit;
          END;
     END;
     Inherited ScanEvent(KeyCode,RepeatCount);
END;


{ TUnidexedOutline }

FUNCTION TUnindexedOutline.AddObjectNode(Node:TOutlineNode;CONST Text:STRING;Data:POINTER):TOutlineNode;
BEGIN
     IF Node = NIL THEN Result := AddChildObjectNode(Node,Text,Data)
     ELSE Result := AttachNode(Node,Text,Data,oaAdd);
END;


FUNCTION TUnindexedOutline.AddChildObjectNode(Node:TOutlineNode;CONST Text:STRING;Data:POINTER):TOutlineNode;
BEGIN
     Result := AttachNode(Node,Text,Data,oaAddChild)
END;


FUNCTION TUnindexedOutline.InsertObjectNode(Node:TOutlineNode;CONST Text:STRING;Data:POINTER):TOutlineNode;
BEGIN
     IF Node = NIL THEN Result := AddChildObjectNode(Node,Text,Data)
     ELSE Result := AttachNode(Node,Text,Data,oaInsert);
END;


PROCEDURE TUnindexedOutline.DeleteNode(Node:TOutlineNode);
BEGIN
     IF Node <> NIL THEN
     BEGIN
          IF Node.Parent <> NIL THEN Node.Destroy {Parent = NIL bei RootNode}
          ELSE NodeError;
     END
     ELSE NodeError;
END;


FUNCTION TUnindexedOutline.IndexOfObject(Data:POINTER):LONGINT;
VAR  i:LONGINT;
     Node:TOutlineNode;
BEGIN
     FOR i := 1 TO ItemCount DO
     BEGIN
          Node := Items[i];
          IF Node <> NIL THEN
            IF Node.Data = Data THEN
            BEGIN
                 Result := i;
                 exit;
            END;
     END;
     Result := -1;
END;


{ TProjectFilesOutline }


PROCEDURE TProjectFilesOutLine.CheckMenuPopup(pt:TPoint);
BEGIN
     Inherited CheckMenuPopup(pt);

     HandlePopupEvent := TRUE;
     {$IFDEF OS2}
     MouseClick(mbRight,[],pt.X,pt.Y); {l�se das Event aus}
     {$ENDIF}
     {$IFDEF WIN32}
     If OnMouseClick <> Nil Then OnMouseClick(Self,mbRight,[],pt.X,pt.Y);
     {$ENDIF}
     HandlePopupEvent := FALSE;
END;



{ TDockingPalette }

PROCEDURE TDockingPalette.CommandEvent(VAR Command:TCommand);
BEGIN
     SendMsg(Application.MainForm.Handle, CM_COMMAND, Command, 0);
     Command := cmNull;
END;



{ TXPLButton }

PROCEDURE SetExplorerBtnLook(flat:BOOLEAN);
VAR  i:LONGINT;
     Btn:TXPLButton;
     Control:TControl;
     ParentList:TList;
BEGIN
     ParentList.Create;

     FOR i := 0 TO XPLList.Count-1 DO
     BEGIN
          Btn := TXplButton(XPLList[i]);
          Btn.Flat := flat;
          IF Btn.Showing THEN
            IF ParentList.IndexOf(Btn.Parent) < 0 THEN ParentList.Add(Btn.Parent);
     END;

     FOR i := 0 TO ParentList.Count-1 DO
     BEGIN
          Control := TControl(ParentList[i]);
          Control.Invalidate;
     END;

     ParentList.Destroy;
END;


PROCEDURE TXPLButton.SetupComponent;
BEGIN
     Inherited SetupComponent;

     ParentColor := TRUE;
     XPLList.Add(SELF);
END;


DESTRUCTOR TXPLButton.Destroy;
BEGIN
     IF FOnDestroy <> NIL THEN FOnDestroy(SELF);
     XPLList.Remove(SELF);

     Inherited Destroy;
END;



BEGIN
     XPLList.Create;
END.
