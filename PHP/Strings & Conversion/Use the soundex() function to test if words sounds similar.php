<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Use the soundex() function to test if words sounds similar

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: soundex (PHP)
** Desc: Shows how to use the soundex() function to test if words sounds similar.
** Example: see below
** Author: Jonas John
*/

$word2find = 'stupid';

$words = array(
    'stupid',
    'stu and pid',
    'hello',
    'foobar',
    'stpid',
    'supid',
    'stuuupid',
    'sstuuupiiid',
);

while(list($id, $str) = each($words))
{
    $soundex_code = soundex($str);

    if (soundex($word2find) == $soundex_code)
    {
        print '"' . $word2find . '" sounds like ' . $str;
    }
    else {
        print '"' . $word2find . '" sounds not like ' . $str;
    }

    print "\n";
}

/*
result:

"stupid" sounds like stupid
"stupid" sounds not like stu and pid
"stupid" sounds not like hello
"stupid" sounds not like foobar
"stupid" sounds like stpid
"stupid" sounds not like supid
"stupid" sounds like stuuupid
"stupid" sounds like sstuuupiiid
*/

?>
