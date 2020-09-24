<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Reading a TAB Delimited File

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

  $filename = "Book1.txt";
  $fd = fopen($filename,"r");
  $contents = fread ($fd,filesize ($filename));
  fclose($fd);

  $splitcontents = explode(" ", $contents);
  $counter = 0;

  foreach($splitcontents as $data)
  {
          echo $counter++;
          echo ":  " . $data;
  }
?>
