<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Censor bad words

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: fix_badwords (PHP)
** Desc: A simple function to replace "bad words".
** Example:
** Author: Jonas John
*/

function fix_badwords($str, $bad_words, $replace_str)
{
    if (!is_array($bad_words)){ $bad_words = explode(',', $bad_words); }

    for ($x=0; $x < count($bad_words); $x++)
    {
        $fix = isset($bad_words[$x]) ? $bad_words[$x] : '';
        $_replace_str = $replace_str;
        if (strlen($replace_str)==1)
        {
            $_replace_str = str_pad($_replace_str, strlen($fix), $replace_str);
        }

        $str = preg_replace('/'.$fix.'/i', $_replace_str, $str);
    }

    return $str;
}


/*example-start*/

/*
** First example:
*/

// create some test "bla bla"
$str = <<<EOF
This is an test paragraph,
to test this badwords function.
Some bad words: fuck shit.
Sorry for that ;-)
EOF;

// this string will be used to replace the
// bad words:
$replace_str = "@#$*!";

// create a array with words to replace:
$bad_words = array('shit','fuck');

// execute the function:
print fix_badwords($str, $bad_words, $replace_str);
print "<hr/>\n";


/*
Another example:

 This tiny example shows to alternatives:

 1. You can use a string as source for bad words
 2. If you give a "replace string" with the length of one letter
    it will automatically repeated to match the bad word length
*/

print fix_badwords($str, 'fuck,shit,paragraph', '*');

/*example-end*/

?>
