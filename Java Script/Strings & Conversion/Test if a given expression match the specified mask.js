// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Test if a given expression match the specified mask
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 Mask: Returns a Boolean if the specified Expression match
       the specified Mask.

 Parameters:
      Expression = String to validate
      Mask       = String that can contain the following
                   options:
                   9 = only numbers (0..9)
                   X = only letters (a..z or A..Z)
                   * = Anything...
 Example: alert(Mask("(954) 572-4419", "(999) 999-9999")); => TRUE
          alert(Mask("33351-820", "99999-9999"));          => FALSE
          alert(Mask("This is a test", "XXXXXX"));         => FALSE
          alert(Mask("This 34 a test", "**************")); => TRUE

 Returns: Boolean
---------------------------------------------------------------- */
function Mask(Expression, Mask)
{
        Mask = Mask.toUpperCase();
        LenStr = Expression.length;
        LenMsk = Mask.length;
        if ((LenStr == 0) || (LenMsk == 0))
                return (false);
        if (LenStr != LenMsk)
                return (false);
        TempString = '';
        for (Count = 0; Count <= Expression.length; Count++)
        {
                StrChar = Expression.substring(Count, Count + 1);
                MskChar = Mask.substring(Count, Count + 1);
                if (MskChar == '9')
                {
                        if(!IsNumber(StrChar))
                                return (false);
                }
                else if (MskChar == 'X')
                {
                        if(!IsChar(StrChar))
                                return (false);
                }
                else if (MskChar == '*')
                {
                        if(!IsAlphanumeric(StrChar))
                                return (false);
                }
                else
                {
                        if (MskChar != StrChar)
                                return (false);
                }
        }
        return (true);
}
