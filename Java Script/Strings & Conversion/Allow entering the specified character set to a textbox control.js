// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Allow entering the specified character set to a textbox control
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 AllowOnly: This function allow entering just the specified
            Expression to a textbox or textarea control.

 Parameters:
      Expression = Allowed characters.
                   a..z => ONLY LETTERS
                   0..9 => ONLY NUMBERS
                   other symbols...

 Example: use the onKeyPress event to make this function work:
          //Allows only from A to Z
          onKeyPress="AllowOnly('a..z');"

          //Allows only from 0 to 9
          onKeyPress="AllowOnly('0..9');"

          //Allows only A,B,C,1,2 and 3
          onKeyPress="AllowOnly('abc123');"

          //Allows only A TO Z,@,#,$ and %
          onKeyPress="AllowOnly('a..z|@#$%');"

                  //Allows only A,B,C,0 TO 9,.,,,+ and -
          onKeyPress="AllowOnly('ABC|0..9|.,+-');"

 Remarks: Use the pipe "|" symbol to separate a..z from 0..9 and symbols

 Returns: None
---------------------------------------------------------------- */
function AllowOnly(Expression)
{
        Expression = Expression.toLowerCase();
        Expression = Replace(Expression, 'a..z', 'abcdefghijklmnopqrstuvwxyz');
        Expression = Replace(Expression, '0..9', '0123456789');
        Expression = Replace(Expression, '|', '');

        var ch = String.fromCharCode(window.event.keyCode);
        ch = ch.toLowerCase();
        Expression = Expression.toLowerCase();
        var a = Expression.indexOf(ch);
        if (a == -1)
                window.event.keyCode = 0;
}
