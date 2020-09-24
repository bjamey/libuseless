<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Convert hex to string and vice versa

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/* Convert string to hex */
function str_to_hex($string){
    $hex='';
    for ($i=0; $i < strlen($string); $i++){
        $hex .= dechex(ord($string[$i]));
    }
    return $hex;
}

/* Convert hex to string */

function hex_to_str($hex){
    $string='';
    for ($i=0; $i < strlen($hex)-1; $i+=2){
        $string .= chr(hexdec($hex[$i].$hex[$i+1]));
    }
    return $string;
}

// example :

$hex = str_to_hex("test sentence...");
// $hex contains 746573742073656e74656e63652e2e2e

print hex_to_str($hex);
// outputs: test sentence...

?>
