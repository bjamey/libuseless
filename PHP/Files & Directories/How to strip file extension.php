<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: How to strip file extension

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

        function strip_ext($name)
        {
                $ext = strrchr($name, '.');

                if($ext !== false)
                {
                        $name = substr($name, 0, -strlen($ext));
                }

                return $name;
        }

        // demonstration
        $filename = 'file_name.txt';
        echo strip_ext($filename)."n";

        // to get the file extension, do
        echo end(explode('.',$filename))."n";

?>
