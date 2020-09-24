<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: HTML Entitize any string

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
  This function is useful in helping to deter spam bots by
  obfuscating things such as e-mail addresses and URLs that
  are displayed on a web page. While it's not 100% fool proof,
  it does offer some protection.
*/

function html_entitize($string) {
    $encoded = null;

    for ($i = 0, $j = strlen($string); $i < $j; $i += 1) {
        switch (rand(0,1)) {
            case 0:
                $encoded .= sprintf('&#%s;', ord($string[$i]));
                break;
            case 1:
                $encoded .= sprintf('&#x%s;', dechex(ord($string[$i])));
                break;
        }
    }

    return $encoded;
}

/*
--------
Example:
--------
$email = html_entitize('foo@baz.org');

Outputs &#x66;&#111;&#111;&#x40;&#98;&#x61;&#x7a;&#x2e;&#99;&#111;&#109;
*/

?>
