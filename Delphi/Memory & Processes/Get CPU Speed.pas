// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: Get CPU speed
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

function GetCPUspeed: double;

const
  DelayTime = 500;                      //  measurement interval (mS)

var
  TimerHi, TimerLo: dword;
  PriorityClass, Priority: integer;

begin
  PriorityClass := GetPriorityClass (GETCURRENTPROCESS);
  Priority      := GetThreadPriority(GETCURRENTTHREAD);

  SetPriorityClass (GETCURRENTPROCESS, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GETCURRENTTHREAD,  THREAD_PRIORITY_TIME_CRITICAL);

  Sleep(10);

  ASM
      DW   310FH           //  RDTSC
      MOV  TimerLo,  EAX
      MOV  TimerHi,  EDX
  END;                                             

  Sleep(DelayTime);

  ASM
      DW   310FH           //  RDTSC
      SUB  EAX,  TimerLo
      SBB  EDX,  TimerHi
      MOV  TimerLo,  EAX
      MOV  TimerHi,  EDX
  END;

  SetThreadPriority(GETCURRENTTHREAD,  Priority);
  SetPriorityClass (GETCURRENTPROCESS, PriorityClass);

  Result := TimerLo / (1000.0 * DelayTime);
end;


procedure TMainForm.Button1tClick(Sender: TObject);
begin
  LabelCPUspeed.Caption := Format('CPU  SPEED:  %F  MHZ', [GetCPUspeed]);
end;


