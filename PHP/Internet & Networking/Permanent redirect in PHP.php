<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Permanent redirect in PHP

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

    function redirect($url)
    {
            header("HTTP/1.1 301 Moved Permanently");
            exit(header('Location: ' . $url));
    }

?>
