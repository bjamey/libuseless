// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Check if the speficied Year is a Leap year
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 LeapYear: Return a Boolean if the speficied Year is a Leap
           Year

 Parameters:
      Year = Numeric expression that represents the Year.

 Returns: Boolean
---------------------------------------------------------------- */
function LeapYear(Year)
{
        if(Year % 4 == 0 && Year % 100 != 0 || Year % 400 ==0)
                return true;
        return false;
}
