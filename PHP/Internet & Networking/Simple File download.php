<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Simple File download

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: File download (PHP)
** Desc: Shows how to create a simple file download by using PHP.The content could also be dynamically generated)
** Example: see below
** Author: Jonas John
*/

// local file that should be send to the client
$local_file = 'test.zip';
// filename that the user gets as default
$download_file = 'your-download-name.zip';

if(file_exists($local_file) && is_file($local_file))
{
    // send headers
    header('Cache-control: private');
    header('Content-Type: application/octet-stream');
    header('Content-Length: '.filesize($local_file));
    header('Content-Disposition: filename='.$download_file);

    // flush content
    flush();

    /*
    ** You can also remove the following part and
    ** replace it trough a database command fetching
    ** the download data
    */
    // open file stream
    $file = fopen($local_file, "rb");

    // send the file to the browser
    print fread ($file, filesize($local_file));

    // close file stream
    fclose($file);}
else {
    die('Error: The file '.$local_file.' does not exist!');
}

?>
