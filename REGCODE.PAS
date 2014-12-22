
     SiSibylDemo                        = 2300;
     SiSibylDemo,                   "Sie benutzen eine Demo Version von SpeedSoft Sibyl. Sie kînnen dieses Programm nur zu Testzwecken benutzen. Verwenden Sie die Datei ORDER.TXT oder http://www.ndrh.de/speed, um Sibyl zu bestellen!"
     SiSibylDemo,                   "You are using a demo version of SpeedSoft Sibyl. You are allowed to use this program for evaluation purposes only. Refer to ORDER.TXT or http://www.ndrh.de/speed to order Sibyl!"

     SiSibylReg                         = 2301;
     SiSibylReg,                    "SIBYL_REG"
     SiSibylReg,                    "SIBYL_REG"

     SiSibylRegError                    = 2302;
     SiSibylRegError,               "Keine gÅltige Registrierungsnummer gefunden! Sibyl startet im Demo Modus!"
     SiSibylRegError,               "No valid registration number found! Sibyl will start in demo mode!"



VAR s,s1:STRING;

  FUNCTION Check(CONST s:STRING):BOOLEAN;
  VAR i,t,t1,i1:LONGWORD;
      c:Integer;
      s1,s2:STRING;
      a:ARRAY[1..6] OF LONGINT;
  BEGIN
      result:=FALSE;

      VAL(s,t,c);
      IF ((c<>0)OR(t=1)) THEN exit;

      //Quersumme der ersten 3 Ziffern mu· durch 3 teilbar sein
      s1:=Copy(s,7,6);
      FOR c:=1 TO 6 DO a[c]:=ord(s1[c])-48;
      VAL(s1,t1,c);
      IF ((c<>0)OR(t1=1)) THEN exit;
      i:=(ord(s1[1])-48)+(ord(s1[2])-48)+(ord(s1[3])-48);
      IF (i MOD 3)<>0 THEN exit;

      //1. Zahl mu· grî·er sein als 3. Zahl
      IF (ord(s1[1])-48)<=(ord(s1[3])-48) THEN exit;

      //1. Zahl mu· kleiner sein als 2. Zahl
      IF (ord(s1[1])-48)>=(ord(s1[2])-48) THEN exit;

      //letzte 3 Ziffern mÅssen eine Primzahl sein
      FOR i:=2 TO 66 DO
        IF (t1 MOD i)=0 THEN exit;

      //1.-3. Zahl ist QuerSumme der letzten 6 Zahlen auf 3 Stellen
      s1:=Copy(s,1,3);
      s2:=tostr(a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[6]*25);
      WHILE length(s2)<3 DO s2:='0'+s2;
      s2[0]:=#3;
      IF s1<>s2 THEN exit;

      //3.-6. Zahl ist Querprodukt der letzten 6 Zahlen auf 3 Stellen
      s1:=Copy(s,4,3);
      i1:=1;
      FOR t:=1 TO 6 DO IF a[t]<>0 THEN i1:=i1*a[t];
      s2:=tostr(i1);
      WHILE length(s2)<3 DO s2:='0'+s2;
      s2[0]:=#3;
      IF s1<>s2 THEN exit;

      result:=TRUE;
  END;


     //S206433964343
     s:=GetEnv(LoadNLSStr(SiSibylReg));
     If length(s)=15 Then
     Begin
          s1:=Copy(s,1,3);
          UpcaseStr(s1);
          //IF ((s1[1]<>'S')OR(s1[2]<>'2')OR(s1[3]<>'0')) THEN goto regerror;
          s1:=Copy(s,4,12);
          IF not Check(s1) THEN goto regerror;
     End
     Else
     Begin
regerror:
         LimitedVersion:=TRUE;
         PostMsg(SibylMainForm.Handle,CM_LIMITED,SiSibylRegError,0);
     End;

     If LimitedVersion
     Then PostMsg(SibylMainForm.Handle,CM_LIMITED,SiSibylDemo,0);

