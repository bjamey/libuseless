<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Convert XML to Array using PHP

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

       function xml2array($xml)
       {
               $xmlary = array();

               $reels = '/<(\w+)\s*([^\/>]*)\s*(?:\/>|>(.*)<\/\s*\\1\s*>)/s';
               $reattrs = '/(\w+)=(?:"|\')([^"\']*)(:?"|\')/';

               preg_match_all($reels, $xml, $elements);

               foreach ($elements[1] as $ie => $xx) {
                       $xmlary[$ie]["name"] = $elements[1][$ie];

                       if ($attributes = trim($elements[2][$ie])) {
                               preg_match_all($reattrs, $attributes, $att);
                               foreach ($att[1] as $ia => $xx)
                                       $xmlary[$ie]["attributes"][$att[1][$ia]] = $att[2][$ia];
                       }

                       $cdend = strpos($elements[3][$ie], "<");
                       if ($cdend > 0) {
                               $xmlary[$ie]["text"] = substr($elements[3][$ie], 0, $cdend - 1);
                       }

                       if (preg_match($reels, $elements[3][$ie]))
                               $xmlary[$ie]["elements"] = xml2array($elements[3][$ie]);
                       else if ($elements[3][$ie]) {
                               $xmlary[$ie]["text"] = $elements[3][$ie];
                       }
               }

               return $xmlary;
       }

?>
