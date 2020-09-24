<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Get file extension

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

  /************
    1st method
  ************/

  function file_extension($filename)
  {
      return end(explode(".", $filename));
  }

  /************
    2nd method
  ************/

  function file_extension($filename)
  {
      $path_info = pathinfo($filename);
      return $path_info['extension'];
  }

?>
