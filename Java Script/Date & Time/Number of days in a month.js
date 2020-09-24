// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Number of days in a month
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 DaysInMonth: Return number of days in a month.

 Parameters:
      dDate = Date to process. If date is null, false is
              returned.

 Returns: Integer
---------------------------------------------------------------- */
function DaysInMonth(dDate)
{
        if (dDate == null)
                return (false);

        dDate = new Date(dDate)

        var dt1, cmn1, cmn2, dtt, lflag, dycnt
        var temp1 = dDate.getMonth() + 1;
        var temp2 = dDate.getYear();
        dt1 = new Date(temp2, temp1 - 1, 1)
        cmn1 = dt1.getMonth()
        dtt = dt1.getTime() + 2332800000
        lflag = true
        dycnt = 28
        while (lflag)
        {
                dtt = dtt + 86400000
                dt1.setTime(dtt)
                cmn2 = dt1.getMonth()
                if (cmn1 != cmn2)
                        lflag = false
                else
                        dycnt = dycnt + 1;
        }
        if (dycnt > 31)
                dycnt = 31;

    return dycnt;
}
