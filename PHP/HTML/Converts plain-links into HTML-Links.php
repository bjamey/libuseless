<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Converts plain-links into HTML-Links

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: text2links (PHP)
** Desc: Converts plain-links into HTML-Links
** Example:
** Author: Jonas John
*/

function text2links($str = '')
{
    if($str=='' or !preg_match('/(http|www\.|@)/i', $str)) { return $str; }

    $lines = explode("\n", $str);
    $new_text = '';

    while (list($k,$l) = each($lines))
    {
        // replace links:
        $l = preg_replace("/([ \t]|^)www\./i", "\\1http://www.", $l);
        $l = preg_replace("/([ \t]|^)ftp\./i", "\\1ftp://ftp.", $l);

        $l = preg_replace("/(http:\/\/[^ )\r\n!]+)/i",
            "<a href=\"\\1\">\\1</a>", $l);

        $l = preg_replace("/(https:\/\/[^ )\r\n!]+)/i",
            "<a href=\"\\1\">\\1</a>", $l);

        $l = preg_replace("/(ftp:\/\/[^ )\r\n!]+)/i",
            "<a href=\"\\1\">\\1</a>", $l);

        $l = preg_replace(
            "/([-a-z0-9_]+(\.[_a-z0-9-]+)*@([a-z0-9-]+(\.[a-z0-9-]+)+))/i",
            "<a href=\"mailto:\\1\">\\1</a>", $l);

        $new_text .= $l."\n";
    }

    return $new_text;
}

/*example-start*/

$text = "Visit http://codedump.jonasjohn.de or www.jonasjohn.de :-)";

print text2links($text);

/*example-end*/

?>
