<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Convert Hex to String

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

  function hex2string($hex)
  {
    $string = NULL;
    $hex = str_replace(array("\n","\r"), "", $hex);
    for ($i=0; $i < $strlen($hex);$i++)
    {
      $string.= chr(hexdec(substr($hex, $i, 2)));
    }
    return $string;
  }


?>
