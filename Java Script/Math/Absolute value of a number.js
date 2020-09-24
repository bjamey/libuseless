// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Absolute value of a number
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 Abs: Returns a value of the same type that is passed to it
      specifying the absolute value of a number.

 Parameters:
      Number = The required number argument can be any valid
               numeric expression. If number contains Null,
               false is returned; if it is an uninitialized
               variable, false is returned.

 Returns: Long
---------------------------------------------------------------- */
function Abs(Number)
{
        Number = Number.toLowerCase();
        RefString = "0123456789.-";

        if (Number.length < 1)
                return (false);

        for (var i = 0; i < Number.length; i++)
        {
                var ch = Number.substr(i, 1)
                var a = RefString.indexOf(ch, 0)
                if (a == -1)
                        return (false);
        }

        if (Number < 0)
                return (Number * -1)

        return Number;
}
