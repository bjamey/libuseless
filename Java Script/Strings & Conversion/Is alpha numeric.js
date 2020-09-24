// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Is alpha numeric
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 IsAlphanumeric: Returns a Boolean value indicating whether an
                 expression can be evaluated as a number or
                 char.

 Parameters:
      Expression = Variant containing a numeric expression or
                   string expression.

 Returns: Boolean
---------------------------------------------------------------- */
function IsAlphanumeric(Expression)
{
        Expression = Expression.toLowerCase();
        RefString = "abcdefghijklmnopqrstuvwxyz0123456789 ";

        if (Expression.length < 1)
                return (false);

        for (var i = 0; i < Expression.length; i++)
        {
                var ch = Expression.substr(i, 1)
                var a = RefString.indexOf(ch, 0)
                if (a == -1)
                        return (false);
        }
        return(true);
}
