<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Compressing Zip Files in PHP

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

function compress_handler($in_output)
{
  return gzencode($in_output);
}
if (strpos($_SERVER['HTTP_ACCEPT_ENCODING'],'gzip') !== FALSE)
{
  ob_start('compress_handler');
  header('Content-Encoding: gzip');
}
else
{
  ob_start();
}

?>                      
