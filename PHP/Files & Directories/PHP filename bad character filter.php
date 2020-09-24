<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: PHP filename bad character filter

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

  function replace_bad_filename_chars($filename) {
    $filtered_filename = "";

    $patterns = array(
      "/\s/", # Whitespace
      "/\&/", # Ampersand
      "/\+/"  # Plus
    );
    $replacements = array(
      "_",   # Whitespace
      "and", # Ampersand
      "plus" # Plus
    );

    $filename = preg_replace($patterns,$replacements,$filename);
    for ($i=0;$i<strlen($filename);$i++) {
      $current_char = substr($filename,$i,1);
      if (ctype_alnum($current_char) == TRUE || $current_char == "_" || $current_char == ".") {
        $filtered_filename .= $current_char;
      }
    }

    return $filtered_filename;
  }

?>
