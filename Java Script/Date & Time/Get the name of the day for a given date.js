// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Get the name of the day for a given date
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 DayOfWeek: Returns a String specifying a name of the day
            for a given date.

 Parameters:
      dDate = Date to evaluate. The Date can be one of the
              following formats: '7/6/2000' or 'July 4, 1830'

 Returns: String
---------------------------------------------------------------- */
function DayOfWeek(dDate)
{
        var ar = new Array();
        ar[0] = "Sunday";   ar[1] = "Monday"; ar[2] = "Tuesday";  ar[3] = "Wednesday";
        ar[4] = "Thursday";        ar[5] = "Friday"; ar[6] = "Saturday";
        var dow = new Date(dDate);
        var day = dow.getDay();
        return ar[day];
}                             
