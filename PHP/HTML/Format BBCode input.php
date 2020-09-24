<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Format BBCode input

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

function bbcode_format($var) {
        $search = array(
                '/\[b\](.*?)\[\/b\]/is',
                '/\[i\](.*?)\[\/i\]/is',
                '/\[u\](.*?)\[\/u\]/is',
                '/\[img\](.*?)\[\/img\]/is',
                '/\[url\](.*?)\[\/url\]/is',
                '/\[url\=(.*?)\](.*?)\[\/url\]/is'
                );

        $replace = array(
                '<strong>$1</strong>',
                '<em>$1</em>',
                '<u>$1</u>',
                '<img src="$1" />',
                '<a href="$1">$1</a>',
                '<a href="$1">$2</a>'
                );

        $var = preg_replace ($search, $replace, $var);

        return $var;
}
?>
