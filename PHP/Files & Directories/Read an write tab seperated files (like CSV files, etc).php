<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Read an write tab seperated files (like CSV files, etc)·

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: load and save tab seperated files (PHP)
** Desc: Two simple functions to read an write tab seperated files (like CSV files, etc).(BTW: The files are good readable for humans ;-)
** Example: see below
** Author: Jonas John
*/

//
// save an array as tab seperated text file
//

function write_tabbed_file($filepath, $array, $save_keys=false)
{
    $content = '';

    reset($array);
    while(list($key, $val) = each($array)){

        // replace tabs in keys and values to [space]
        $key = str_replace("\t", " ", $key);
        $val = str_replace("\t", " ", $val);

        if ($save_keys){ $content .=  $key."\t"; }

        // create line:
        $content .= (is_array($val)) ? implode("\t", $val) : $val;
        $content .= "\n";
    }

    if (file_exists($filepath) && !is_writeable($filepath)){
        return false;
    }
    if ($fp = fopen($filepath, 'w+')){
        fwrite($fp, $content);
        fclose($fp);
    }
    else { return false; }
    return true;
}

//
// load a tab seperated text file as array
//
function load_tabbed_file($filepath, $load_keys=false)
{
    $array = array();

    if (!file_exists($filepath)){ return $array; }
    $content = file($filepath);

    for ($x=0; $x < count($content); $x++){
        if (trim($content[$x]) != ''){
            $line = explode("\t", trim($content[$x]));
            if ($load_keys){
                $key = array_shift($line);
                $array[$key] = $line;
            }
            else { $array[] = $line; }
        }
    }
    return $array;
}

/*
** Example usage:
*/

$array = array(
    'line1'  => array('data-1-1', 'data-1-2', 'data-1-3'),
    'line2' => array('data-2-1', 'data-2-2', 'data-2-3'),
    'line3'  => array('data-3-1', 'data-3-2', 'data-3-3'),
    'line4' => 'foobar',
    'line5' => 'hello world'
);

// save the array to the data.txt file:
write_tabbed_file('data.txt', $array, true);

/* the data.txt content looks like this:
line1        data-1-1        data-1-2        data-1-3
line2        data-2-1        data-2-2        data-2-3
line3        data-3-1        data-3-2        data-3-3
line4        foobar
line5        hello world
*/

// load the saved array:
$reloaded_array = load_tabbed_file('data.txt',true);

print_r($reloaded_array);
// returns the array from above

?>
