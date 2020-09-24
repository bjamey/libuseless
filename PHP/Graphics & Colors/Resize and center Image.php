<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Resize and center Image

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

    function miniatura($image, $w, $h) {
        $tam = getimagesize($image);
        $x = (($tam[0] / 2) - ($w / 2));
        $y = (($tam[1] / 2) - ($h / 2));
        $img = imagecreatefromjpeg($image);

        if(($w <= $tam[0]) && ($h <= $tam[1])) {
            $mini = imagecreate($w, $h);
            imagecopyresized($mini, $img, 0, 0, $x, $y, $w, $h, $w, $h);
            return imagejpeg($mini);
            imagedestroy($mini);
        }else {
            return imagejpeg($img);
        }
        imagedestroy($img);
    }

    header("Content-type: image/jpeg");

    // image - local image
    // w - final width
    // h - final height
    echo miniatura($image, $w, $h);
?>
