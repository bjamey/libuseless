<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Retrieve the size of all files in an directory

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: dir_size (PHP)
** Desc: Returns the filesize of all files in an directory.
** Example: dir_size('data/');
** Author: Jonas John
*/

function dir_size($path)
{

    // use a normalize_path function here
    // to make sure $path contains an
    // ending slash
    // (-> http://codedump.jonasjohn.de/snippets/normalize_path.htm)

    // to display a good lucking size you can use a readable_filesize
    // function, get it here:
    // (-> http://codedump.jonasjohn.de/snippets/readable_filesize.htm)

    $size = 0;

    $dir = opendir($path);
    if (!$dir){return 0;}

    while (($file = readdir($dir)) !== false) {

        if ($file[0] == '.'){ continue; }

        if (is_dir($path.$file)){
            // recursive:
            $size += dir_size($path.$file.DIRECTORY_SEPARATOR);
        }
        else {
            $size += filesize($path.$file);
        }
    }

    closedir($dir);
    return $size;
}

?>
