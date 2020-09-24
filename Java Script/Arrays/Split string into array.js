// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Split string into array
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!-- ----------------------------------------------------------------
 Split: Returns a zero-based, one-dimensional array containing
        a specified number of substrings

 Parameters:
      Expression = String expression containing substrings and
                   delimiters. If expression is a zero-length
                   string(""), Split returns an empty array,
                   that is, an array with no elements and no
                   data.
      Delimiter  = String character used to identify substring
                   limits. If delimiter is a zero-length
                   string (""), a single-element array
                   containing the entire expression string
                   is returned.

 Returns: String
---------------------------------------------------------------- -->
function Split(Expression, Delimiter)
{
        var temp = Expression;
        var a, b = 0;
        var array = new Array();
                                                                
        if (Delimiter.length == 0)
        {
                array[0] = Expression;
                return (array);
        }

        if (Expression.length == '')
        {
                array[0] = Expression;
                return (array);
        }

        Delimiter = Delimiter.charAt(0);

        for (var i = 0; i < Expression.length; i++)
        {
                a = temp.indexOf(Delimiter);
                if (a == -1)
                {
                        array[i] = temp;
                        break;
                }
                else
                {
                        b = (b + a) + 1;
                        var temp2 = temp.substring(0, a);
                        array[i] = temp2;
                        temp = Expression.substr(b, Expression.length - temp2.length);
                }
        }

        return (array);
}
