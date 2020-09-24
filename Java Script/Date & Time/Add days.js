// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Add days
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 AddDays: Returns a Date containing a date to which a
          specified days interval has been added to the
          current date.

 Parameters:
      DaysToAdd = Numeric expression that is the interval of
                  days you want to add to the actual date.

 Returns: Date/String
---------------------------------------------------------------- */
function AddDays(DaysToAdd)
{
        var newdate = new Date();
        var newtimems = newdate.getTime() + (DaysToAdd * 24 * 60 * 60 * 1000);
        newdate.setTime(newtimems);
        return newdate.toLocaleString();
}
