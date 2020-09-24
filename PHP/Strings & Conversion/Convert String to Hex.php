<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Convert String to Hex

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

  function string2hex($string)
  {
    $hex = NULL;
    for ($i=0; $i < strlen($string); $i++)
    {
      $ord = ord(substr($string,$i,1));
      if($ord < 16) {
    $hex.= '0'.dechex($ord);
      } else {
    $hex.= dechex($ord);
      }
      if ($i && ($i % 32) == 31) {
    $hex.= "\n";
      }
    }
    return $hex;
  }


?>
