// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Get Windows Uptime Information
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

unit Unit_Procs;

interface
   uses Windows, Messages, SysUtils, Variants, Classes,
        Graphics, Controls, Forms;



(* declare functions *)

function GetTickCount: LongInt; external 'Kernel32.dll';        //gettickcount declaration
function GetUptime: string;                                     //format ticks into days, hours, minutes, seconds
function DayOrDays(x: integer): string;

var Days: Integer;
    strResult: string;
    Count, Hours, Minutes, Seconds, Miliseconds: LongInt;

implementation



(*******************************************************************
  Procedure:        GetUptime
  Date:                Jun 11, 2002
  Arguments:        None
  Result:        string
  Description:        (insert description)
*******************************************************************)
function GetUptime: string;
begin

    strResult := '';
    Result := '';
    Count := GetTickCount();

    Miliseconds := Count Mod 1000;
    Count := Count div 1000;
    Days := Count div (24 * 3600);
    If Days > 0 Then Count := Count - (24 * 3600 * Days);
    Hours := Count div 3600;
    If Hours > 0 Then Count := Count - (3600 * Hours);
    Minutes := Count div 60;
    Seconds := Count mod 60;
    strResult := IntToStr(Days) + 'd ' + IntToStr(Hours) + 'h ' + IntToStr(Minutes) + 'm ' + IntToStr(Seconds) + 's';
    Result := strResult;
end;

function DayOrDays(x: integer): string;
begin
        result := 'days';
        if x = 0 then result := 'days';
        if x = 1 then result := 'day';
        if x > 1 then result := 'days';
end;
(*

Declare Function GetTickCount Lib "Kernel32" () As Long

Function FormatCount(Count As Long, Optional FormatType As Byte = 0) As String
Dim Days As Integer, Hours As Long, Minutes As Long, Seconds As Long, Miliseconds As Long

    Miliseconds = Count Mod 1000
    Count = Count \ 1000
    Days = Count \ (24& * 3600&)
    If Days > 0 Then Count = Count - (24& * 3600& * Days)
    Hours = Count \ 3600&
    If Hours > 0 Then Count = Count - (3600& * Hours)
    Minutes = Count \ 60
    Seconds = Count Mod 60

End Function

function GetUptime: string
var Days: Integer;
    strResult: string;
    Count, Hours, Minutes, Seconds, Miliseconds: LongInt;
begin

    strResult: = '';
    Result: = '';
    Count := GetTickCount();

    Miliseconds = Count Mod 1000
    Count = Count div 1000
    Days = Count div (24& * 3600&)
    If Days > 0 Then Count = Count - (24& * 3600& * Days)
    Hours = Count div 3600&
    If Hours > 0 Then Count = Count - (3600& * Hours)
    Minutes = Count div 60
    Seconds = Count mod 60
    strResult: = IntToStr(Days) + 'd ' + IntToStr(Hours) + 'h ' + IntToStr(Minutes) + 'm ' + IntToStr(Seconds) + 's';

end;


*)



end.
