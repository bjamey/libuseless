<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: How to make a color darker

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: darker_color (PHP)
** Desc: This function makes a color darker.You can enter the difference between the colors (default = 20).
** Example:
** Author: Jonas John
*/

function darker_color($color, $dif=20){
    $color = str_replace('#', '', $color);
    if (strlen($color) != 6){ return '000000'; }
    $rgb = '';
    for ($x=0;$x<3;$x++){
        $c = hexdec(substr($color,(2*$x),2)) - $dif;
        $c = ($c < 0) ? 0 : dechex($c);
        $rgb .= (strlen($c) < 2) ? '0'.$c : $c;
    }
    return '#'.$rgb;
}

/*example-start*/
for ($x=1; $x < 20; $x++)
{
    // Start color:
    $c = darker_color('#FF481D', ($x * 3));

    print "<div style='background-color: $c; color: $c; font-size: 50%; padding: 0px;'>.</div>\n";
}
/*example-end*/

?>
