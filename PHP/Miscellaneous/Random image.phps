<?php /* ----------------------------------------------------------------------
                                                 DTT (c)2006 FSL - FreeSoftLand
   Title: Random image

          Displays a random image on a web page. Images are selected from a
          folder of your choice.

   Date : 31 May 2006
   By   : TotallyPHP - www.totallyphp.co.uk 
---------------------------------------------------------------------------- */

/*
 * Name your images 1.jpg, 2.jpg etc.
 *
 * Add this line to your page where you want the images to 
 * appear: <?php include "randomimage.php"; ?>
 */ 

// Change this to the total number of images in the folder
$total = "11";

// Change to the type of files to use eg. .jpg or .gif
$file_type = ".jpg";

// Change to the location of the folder containing the images
$image_folder = "images/random";

// You do not need to edit below this line

$start = "1";

$random = mt_rand($start, $total);

$image_name = $random . $file_type;

echo "<img src=\"$image_folder/$image_name\" alt=\"$image_name\" />";

?>
