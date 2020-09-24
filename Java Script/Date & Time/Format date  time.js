// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Format date  time
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 FormatDateTime: Returns an expression formatted as a date or
                 time. If DateTime is null then false is
                 returned.

 Parameters:
      DateTime   = Date/Time expression to be formatted
      FormatType = Numeric value that indicates the date/time
                   format used. If omitted, GeneralDate is used
                   0 = Very Long Date/Time Format (Mon Jul 10, 12:02:30 am EDT 2000)
                   1 = Long Date/Time Format (Monday, July 10, 2000)
                   2 = Short Date (1/10/00)
                   3 = Long Time (4:20 PM)
                   4 = Military Time (14:43)

 Returns: String
---------------------------------------------------------------- */
function FormatDateTime(DateTime, FormatType)
{
        if (DateTime == null)
                return (false);

        if (FormatType < 0)
                FormatType = 1;

        if (FormatType > 4)
                FormatType = 1;

        var strDate = new String(DateTime);

        if (strDate.toUpperCase() == "NOW")
        {
                var myDate = new Date();
                strDate = String(myDate);
        }
        else
        {
                var myDate = new Date(DateTime);
                strDate = String(myDate);
        }

        var Day = new String(strDate.substring(0, 3));
        if (Day == "Sun") Day = "Sunday";
        if (Day == "Mon") Day = "Monday";
        if (Day == "Tue") Day = "Tuesday";
        if (Day == "Wed") Day = "Wednesday";
        if (Day == "Thu") Day = "Thursday";
        if (Day == "Fri") Day = "Friday";
        if (Day == "Sat") Day = "Saturday";

        var Month = new String(strDate.substring(4, 7)), MonthNumber = 0;
        if (Month == "Jan") { Month = "January"; MonthNumber = 1; }
        if (Month == "Feb") { Month = "February"; MonthNumber = 1; }
        if (Month == "Mar") { Month = "March"; MonthNumber = 1; }
        if (Month == "Apr") { Month = "April"; MonthNumber = 1; }
        if (Month == "May") { Month = "May"; MonthNumber = 1; }
        if (Month == "Jun") { Month = "June"; MonthNumber = 1; }
        if (Month == "Jul") { Month = "July"; MonthNumber = 1; }
        if (Month == "Aug") { Month = "August"; MonthNumber = 1; }
        if (Month == "Sep") { Month = "September"; MonthNumber = 1; }
        if (Month == "Oct") { Month = "October"; MonthNumber = 1; }
        if (Month == "Nov") { Month = "November"; MonthNumber = 1; }
        if (Month == "Dec") { Month = "December"; MonthNumber = 1; }

        var curPos = 11;
        var MonthDay = new String(strDate.substring(8, 10));
        if (MonthDay.charAt(1) == " ")
        {
                MonthDay = "0" + MonthDay.charAt(0);
                curPos--;
        }

        var MilitaryTime = new String(strDate.substring(curPos, curPos + 5));
        var Year = new String(strDate.substring(strDate.length - 4, strDate.length));

        // Format Type decision time!
        if (FormatType == 1)
                strDate = Day + ", " + Month + " " + MonthDay + ", " + Year;
        else if (FormatType == 2)
                strDate = MonthNumber + "/" + MonthDay + "/" + Year.substring(2,4);
        else if (FormatType == 3)
        {
                var AMPM = MilitaryTime.substring(0,2) >= 12 && MilitaryTime.substring(0,2) != "24" ? " PM" : " AM";
                if (MilitaryTime.substring(0,2) > 12)
                        strDate = (MilitaryTime.substring(0,2) - 12) + ":" + MilitaryTime.substring(3,MilitaryTime.length) + AMPM;
                else
                {
                        if (MilitaryTime.substring(0,2) < 10)
                                strDate = MilitaryTime.substring(1,MilitaryTime.length) + AMPM;
                        else
                        strDate = MilitaryTime + AMPM;
                }
        }
        else if (FormatType == 4)
                strDate = MilitaryTime;

        return strDate;
}
