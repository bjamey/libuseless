<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Format File Size

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

        function GetFileSize($nBytes)
        {
                if ($nBytes >= pow(2,40))
                {
                        $strReturn = round($nBytes / pow(1024,4), 2);
                        $strSuffix = "TB";
                }
                elseif ($nBytes >= pow(2,30))
                {
                        $strReturn = round($nBytes / pow(1024,3), 2);
                        $strSuffix = "GB";
                }
                elseif ($nBytes >= pow(2,20))
                {
                        $strReturn = round($nBytes / pow(1024,2), 2);
                        $strSuffix = "MB";
                }
                elseif ($nBytes >= pow(2,10))
                {
                        $strReturn = round($nBytes / pow(1024,1), 2);
                        $strSuffix = "KB";
                }
                else
                {
                        $strReturn = $nBytes;
                        $strSuffix = "Byte";
                }

                if ($strReturn == 1)
                {
                        $strReturn .= " " . $strSuffix;
                }
                else
                {
                        $strReturn .= " " . $strSuffix . "s";
                }

                return $strReturn;
        }

?>
