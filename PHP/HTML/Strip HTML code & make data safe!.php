<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Strip HTML code & make data safe!

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

// Strip html code

function make_safe($variable)
{
     $variable = htmlentities($variable, ENT_QUOTES);

     if (get_magic_quotes_gpc())
     {
         $variable = stripslashes($variable);
     }

     $variable = mysql_real_escape_string(trim($variable));
     $variable = strip_tags($variable);
     $variable = str_replace("\r\n", "", $variable);

     return $variable;
}

?>
