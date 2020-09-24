<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Recursive PHP Syntax Checker

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

 /*
   Recursively checks for all *.php and *.tpl files in the
   directory specified (or the current directory if one is not
   specified) and runs `php -l $file`. Only outputs the errors.
 */

$start_dir = (isset($argv[1])) ? $argv[1] : '.';

check_syntax($start_dir);

function check_syntax($path) {

        foreach(scandir($path) as $file) {

                if($file != '.' && $file != '..') {

                        if(is_dir("$path/$file")) {

                                check_syntax("$path/$file");

                        } else if(preg_match("/.\.(php|tpl)$/", $file)) {

                                $result = `php -l $path/$file`;
                                if($result[0] != 'N') echo $result;
                        }
                }
        }
}


?>
