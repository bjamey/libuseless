// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Check if the specified Expression is a valid email address
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 IsEmail: Returns a Boolean if the specified Expression is a
          valid e-mail address. If Expression is null, false
          is returned.

 Parameters:
      Expression = e-mail to validate.

 Returns: Boolean
---------------------------------------------------------------- */
function IsEmail(Expression)
{
        if (Expression == null)
                return (false);

        var supported = 0;
        if (window.RegExp)
        {
                var tempStr = "a";
                var tempReg = new RegExp(tempStr);
                if (tempReg.test(tempStr)) supported = 1;
        }
        if (!supported)
                return (Expression.indexOf(".") > 2) && (Expression.indexOf("@") > 0);
        var r1 = new RegExp("(@.*@)|(\\.\\.)|(@\\.)|(^\\.)");
        var r2 = new RegExp("^.+\\@(\\[?)[a-zA-Z0-9\\-\\.]+\\.([a-zA-Z]{2,3}|[0-9]{1,3})(\\]?)$");
        return (!r1.test(Expression) && r2.test(Expression));
}
