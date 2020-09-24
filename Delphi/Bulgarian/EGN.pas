// ----------------------------------------------------------------------------
//                                      DTT 1.1.5.0  (c)2006 FSL - FreeSoftLand
// Title: EGN
//
// Date : 08.8.2006
// By   : Dimitar Minchev <mitko@bfu.bg>
// ----------------------------------------------------------------------------

unit egn;

interface

uses StrUtils;

implementation

{
  ������� �� �������� �� ���������� �� ���
  �� ��������� �� ��������� ��������
}
function CheckEGN(var EGN : string) : boolean;
 var
      OK      : boolean;
      A       : Array [0..9] of integer;
      I       : integer;
      SS      : String;
      S       : Word;
begin
    // ����� �� ����������� �����
    A[1] := 2;     A[2] := 4;     A[3] := 8;
    A[4] := 5;     A[5] := 10;    A[6] := 9;
    A[7] := 7;     A[8] := 3;     A[9] := 6;

    Result := true;
    S := 0;

    // ��������
    for I := 1 to 9 do begin
        SS := MidStr(EGN,I,1);
        S  := StrToInt(SS) * A[I] + S;
        if (SS = ' ') then OK := False;
    end;

    // �������� �� ����������
    if (MidStr(EGN,10,1) = ' ') then OK := False;
    S := S mod 11;
    if (S = 10) then S := 0;

    // �����
      if ((StrToInt(MidStr(EGN,3,2)) > 12) or (StrToInt(MidStr(EGN,3,2)) < 1)) and
       ((StrToInt(MidStr(EGN,3,2)) > 32) or (StrToInt(MidStr(EGN,3,2)) < 21)) and
       ((StrToInt(MidStr(EGN,3,2)) > 52) or (StrToInt(MidStr(EGN,3,2)) < 41)) then
        OK := False;

    // ��� �� ������
    if (StrToInt(MidbStr(EGN,5,2)) > 31) or (StrToInt(MidStr(EGN,5,2)) < 1) then
        OK := False;

    // ������������ ��������
    if (StrToInt(MidStr(EGN,10,1)) <> S) or (OK = False) then begin
        Result := FALSE;
    end else
        Result := TRUE;
end;

{
  ������� �� �������� �� ����:
    true  = ���
    false = ����
}
function isMale(var EGN : string) : boolean;
 var X : integer;
begin
    X := -1;
    X := (StrToInt(MidStr(EGN,9,1) mod 2);
    case X of
      0 : Result := TRUE;
      1 : Result := FALSE;
    end;
end;

{

    // TODO: �� ������ �������� ...

    // 1.1. ��������� �� ��������
    yT := Val(SubStr(EGN,3,2);
    // 1.2. �������� �� ���������� �� ��������
    if (yT > 40) then begin
        mYear := 2000;
    end else if (yT > 20) then begin
        mYear := 1900;
    end else
        mYear := 1800;
    // 1.3. �������� �� ������ ��� ��������
    mYear := mYear + Val(Left(EGN,2));

    // 2.1. ��������� �� ������
    mT := Val(SubStr(EGN,3,2));
    // 2.2. ���������� �� ������
    if (mT > 40) then begin
        mMes := mT - 40;
    end else if (mT > 20) then begin
        mMes := mT - 20;
    end else
        mMes := mT;
}

end.

