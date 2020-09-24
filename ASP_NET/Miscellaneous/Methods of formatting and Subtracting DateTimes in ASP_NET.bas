' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Methods of formatting and Subtracting DateTimes in ASP·NET
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'Uses the AddDays method to subtract X number of days
Public Function Date2()
  Dim NewTime as DateTime
  NewTime = DateTime.Now.AddDays(-7)
  Dim s as string = NewTime
  return s
End Function

'Thanks to Paul Czywczynski for this idea
'This probably (In My opinion) Offers the most flexibility found so far
'Change where the MM/dd/yyyy to whatever
'response.write(System.String.Format("{0:d}",NewTime))      "    
'would return just the name of the Day
Function Date3()
  Dim NewTime as DateTime = now.addDays(-7)
  response.write(System.String.Format("{0:MM/dd/yyyy}",NewTime))
End Function


Function Date4()
Dim NewTime as DateTime
  NewTime = now.addDays(-7)
  return NewTime.ToString()
End Function

- General Formatting Techniques


'Uses the toLongTimeString method
Public Function Date5()
  Dim NewTime as DateTime
  NewTime = Now()
  return newtime.toLongTimeString()
End Function

'Uses the toShortTimeString method
Public Function Date6()
  Dim NewTime as DateTime
  NewTime = Now()
  return newtime.toShortTimeString()
End Function

'Uses the toLongDateString method
Public Function Date7()
  Dim NewTime as DateTime
  NewTime = Now()
  return newtime.toLongDateString()
End Function

'Uses the toShortDateString method
Public Function Date8()
  Dim NewTime as DateTime
  NewTime = Now()
  return newtime.toShortDatestring()
End Function

'Using FormatDateTime Function


'Uses FormatDateTime function General format
Function Date9()
  Dim NewTime as DateTime
  NewTime = DateTime.Now.Subtract( New TimeSpan(7, 0, 0, 0) )
  return formatdatetime(NewTime, 0)
End Function

'Uses FormatDateTime function LongDate format
Function Date10()
  Dim NewTime as DateTime
  NewTime = DateTime.Now.Subtract( New TimeSpan(7, 0, 0, 0) )
  return formatdatetime(NewTime, 1)
End Function

'Uses FormatDateTime function ShortDate format
Function Date11()
  Dim NewTime as DateTime
  NewTime = DateTime.Now.Subtract( New TimeSpan(7, 0, 0, 0) )
  return formatdatetime(NewTime, 2)
End Function

'Uses FormatDateTime function LongTime format
Function Date12()
  Dim NewTime as DateTime
  NewTime = DateTime.Now.Subtract( New TimeSpan(7, 0, 0, 0) )
  return formatdatetime(NewTime, 3)
End Function

'Uses FormatDateTime function ShortTime format
Function Date13()
  Dim NewTime as DateTime
  NewTime = DateTime.Now.Subtract( New TimeSpan(7, 0, 0, 0) )
  return formatdatetime(NewTime, 4)
End Function

'Display Specific parts of the Date(DAY, MONTH, TIME)


'Bring Back just the name of the Day
Function Date14()
  Dim NewTime as DateTime = now.addDays(-7)
  dim s as string
  s = (System.String.Format("{0:dddd}",NewTime))
  Return s
End Function

'Returns the Integer of what day of week
Function Date15()
  Dim MyDate as DateTime
  Dim MyWeekDay as Integer
  MyDate = Now.AddDays(-5)
  MyWeekDay = Weekday(MyDate)
  return MyWeekDay
End Function

'Returns the Month Integer
Function Date16()
  Dim MyDate as DateTime
  Dim MyMonth as Integer
  MyDate = Now.AddDays(-5)
  MyMonth = Month(MyDate)
  return MyMonth
End Function

'Returns just a formatted string
'This method provides just formatting but
'Very flexible with not a lot of code
Function Date17()
  Dim MyDate as String
  MyDate = Format(Now(), "yyyy")
  return MyDate
End Function
</script>
