<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: preg_replace technique

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
 This is a useful technique for passing matched data into other
 functions to be evaluated and replaced in parsed strings.

 This example is simple. It rewrites the <img> tag emulating being
 passed thru a proxy.
*/

$html = file_get_contents('http://www.yahoo.com/');
print "$html<br><br>";
$attr= 'src';
$webroot='proxy';
$html=preg_replace('/(\s)?'.$attr.'="([^\s]*?)"/ei',
                   "make_new_img_tag('$attr','$2','$1','$webroot');",
                   $html);
print "<!-- $html -->";


function make_new_img_tag($attr, $filename, $prefix, $webroot) {
    $b64val = base64_encode($filename);
    return $prefix$attr.'="'.$webroot.'/browse/'.$b64val.'"';
}

?>
