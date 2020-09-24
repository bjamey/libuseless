<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Get a filename without knowing it's correct case

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
I often pull info from files on NT shares into my Linux/PHP-powered web pages.
The problem I've run in to is that the cases of the files I need aren't constant.
Here is a function that will take a path and a filename. It will search that path for a
file matching that name, regardless of case, and return the name of the file in the
correct case, or null if it doesn't find it. Also included is another function which
this one uses, which gets a list of files for the given directory.

Works with PHP3 and PHP4.
*/

// Source Code

//============================================================
// Give it a path (defaults to .) and a filename. It will return
// null (if the file doesn't exist) or the filename as it appears
// in that path, in the correct case.
function getCasedFilename( $fname, $path="." )
{
    $flist = getFileList( $path);

    while( list($ndx,$f) = each( $flist ) )
    {
      if ( eregi( "$fname", $f ) ) {
           return $f;
      }
    }                

    return null;
}

//============================================================
// Returns a list of all files in the given dir, excluding . and ..
// If no dir is passed, it uses the current dir.
// Returns null if it can't open the dir.
function getFileList( $dirname="." ) {
  $flist = array();
  $dir = opendir( $dirname );

  if ( ! $dir ) { return null; }

  while( $file = readdir( $dir ) )
  {
    if ( ereg( "^.$", $file ) || ereg( "^..$", $file ) ) continue;
    $files[] = $file;
  }
  return $files;
}
?>
