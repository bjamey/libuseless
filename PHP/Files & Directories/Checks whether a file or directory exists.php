<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Checks whether a file or directory exists

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

  $filename = '/path/to/foo.txt';

  if (file_exists($filename))
  {
     echo "The file $filename exists";
  } else {
     echo "The file $filename does not exist";
  }

?>
