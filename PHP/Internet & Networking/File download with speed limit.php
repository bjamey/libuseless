<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: File download with speed limit

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: File download with speed limit (PHP)
** Desc: This snippet shows you how to limit the download rate of a file download.
** Author: Jonas John
*/

// local file that should be send to the client
$local_file = 'test-file.zip';

// filename that the user gets as default
$download_file = 'your-download-name.zip';

// set the download rate limit (=> 20,5 kb/s)
$download_rate = 20.5;
if(file_exists($local_file) && is_file($local_file))
{
    // send headers
    header('Cache-control: private');
    header('Content-Type: application/octet-stream');
    header('Content-Length: '.filesize($local_file));
    header('Content-Disposition: filename='.$download_file);

    // flush content
    flush();

    // open file stream
    $file = fopen($local_file, "r");

    while(!feof($file))
    {
        // send the current file part to the browser
        print fread($file, round($download_rate * 1024));

        // flush the content to the browser
        flush();

        // sleep one second
        sleep(1);
    }

    // close file stream
    fclose($file);}
else {
    die('Error: The file '.$local_file.' does not exist!');
}
?>
