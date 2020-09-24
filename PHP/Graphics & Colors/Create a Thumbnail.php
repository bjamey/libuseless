<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Create a Thumbnail

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

function image_create_thumb($filename, $width, $height)
{
        list($image["Width"], $image["Height"], $image["Type"]) = getimagesize($filename);


        switch($image["Type"])
        {
            case IMG_JPG:
            case IMG_JPEG:
                        $im_image = ImageCreateFromJPEG($filename);
                        break;
            case IMG_GIF:
                        $im_image = ImageCreateFromGIF($filename);
                        break;
            case IMG_PNG:
                        $im_image = ImageCreateFromPNG($filename);
                        break;
        }

        if($image["Width"] > $image["Height"])
        {
                $scale = $width / $image["Width"];
                $thumb_width = $width;
                $thumb_height  = floor($image["Height"]*$scale);
        }
        else
        {
                $scale = $height / $image["Height"];
                $thumb_height = $height;
                $thumb_width  = floor($image["Width"]*$scale);
        }

        $im_thumb = @ImageCreateTrueColor($thumb_width, $thumb_height) or die("Cannot Initialize new GD image stream");

        ImageCopyResized($im_thumb, $im_image, 0, 0, 0, 0, $thumb_width, $thumb_height, $image["Width"], $image["Height"]);

        ImageDestroy($im_image);
        ImagePNG($im_thumb, $filename);
        ImageDestroy($im_thumb);

        return true;
}//image_create_thumb($filename, $width, $height)

?>
