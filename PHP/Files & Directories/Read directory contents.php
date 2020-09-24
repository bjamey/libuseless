<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Read directory contents

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: dir_list (PHP)
** Desc: Simple function to read directory contents
** Example: dir_list('data/');
** Author: Jonas John
*/

function dir_list($path){

    $files = array();

    if (is_dir($path)){
        $handle = opendir($path);
        while ($file = readdir($handle)) {
            if ($file[0] == '.'){ continue; }

            if (is_file($path.$file)){
                $files[] = $file;
            }
        }
        closedir($handle);
        sort($files);
    }

    return $files;

}

?>
