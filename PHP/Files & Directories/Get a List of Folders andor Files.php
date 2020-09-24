<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Get a List of Folders andor Files

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

  function listFolder($folder, $types = 0)
  {
    $functions = array(
        1 => 'is_dir',
        2 => 'is_file'
      );

    $folderList = array();

    foreach( glob( "$folder/*" ) as $currentItem )
    {
      if( $types == 1 or $types == 2 )
      {
        if( $functions[$types]($currentItem) )
          $folderList[] = basename($currentItem);
      }
      else $folderList[] = basename($currentItem);
    }

    return $folderList;
  }

?>
