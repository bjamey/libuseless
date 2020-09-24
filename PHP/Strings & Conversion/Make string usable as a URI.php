<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Make string usable as a URI

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

function dirify($s) {
     $s = convert_high_ascii($s);   ## convert high-ASCII chars to 7bit.
     $s = strtolower($s);           ## lower-case.
     $s = strip_tags($s);           ## remove HTML tags.
     $s = preg_replace('!&[^;\s]+;!','',$s);          ## remove HTML entities.
     $s = preg_replace('![^\w\s.]!','',$s);           ## remove non-word/space/period chars.
     $s = preg_replace('!\s+!','-',$s);               ## change space chars to dashes.
     return $s;
}

function convert_high_ascii($s) {
         $HighASCII = array(
                 "!\xc0!" => 'A',    # A`
                 "!\xe0!" => 'a',    # a`
                 "!\xc1!" => 'A',    # A'
                 "!\xe1!" => 'a',    # a'
                 "!\xc2!" => 'A',    # A^
                 "!\xe2!" => 'a',    # a^
                 "!\xc4!" => 'Ae',   # A:
                 "!\xe4!" => 'ae',   # a:
                 "!\xc3!" => 'A',    # A~
                 "!\xe3!" => 'a',    # a~
                 "!\xc8!" => 'E',    # E`
                 "!\xe8!" => 'e',    # e`
                 "!\xc9!" => 'E',    # E'
                 "!\xe9!" => 'e',    # e'
                 "!\xca!" => 'E',    # E^
                 "!\xea!" => 'e',    # e^
                 "!\xcb!" => 'Ee',   # E:
                 "!\xeb!" => 'ee',   # e:
                 "!\xcc!" => 'I',    # I`
                 "!\xec!" => 'i',    # i`
                 "!\xcd!" => 'I',    # I'
                 "!\xed!" => 'i',    # i'
                 "!\xce!" => 'I',    # I^
                 "!\xee!" => 'i',    # i^
                 "!\xcf!" => 'Ie',   # I:
                 "!\xef!" => 'ie',   # i:
                 "!\xd2!" => 'O',    # O`
                 "!\xf2!" => 'o',    # o`
                 "!\xd3!" => 'O',    # O'
                 "!\xf3!" => 'o',    # o'
                 "!\xd4!" => 'O',    # O^
                 "!\xf4!" => 'o',    # o^
                 "!\xd6!" => 'Oe',   # O:
                 "!\xf6!" => 'oe',   # o:
                 "!\xd5!" => 'O',    # O~
                 "!\xf5!" => 'o',    # o~
                 "!\xd8!" => 'Oe',   # O/
                 "!\xf8!" => 'oe',   # o/
                 "!\xd9!" => 'U',    # U`
                 "!\xf9!" => 'u',    # u`
                 "!\xda!" => 'U',    # U'
                 "!\xfa!" => 'u',    # u'
                 "!\xdb!" => 'U',    # U^
                 "!\xfb!" => 'u',    # u^
                 "!\xdc!" => 'Ue',   # U:
                 "!\xfc!" => 'ue',   # u:
                 "!\xc7!" => 'C',    # ,C
                 "!\xe7!" => 'c',    # ,c
                 "!\xd1!" => 'N',    # N~
                 "!\xf1!" => 'n',    # n~
                 "!\xdf!" => 'ss'
         );
         $find = array_keys($HighASCII);
         $replace = array_values($HighASCII);
         $s = preg_replace($find,$replace,$s);
     return $s;
}

?>
