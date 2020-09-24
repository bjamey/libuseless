<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Copy non-empty directory

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

    /*
    ---------
    Purpose :
    ---------
    This function copy one directory into another.

    --------
    Notes :
    --------
    1.      There is no permissions checking and no error handling so watch out.
    2.      It was tested on Apache 1.3.27 with PHP 4.2.3 and IIS 5.0 with 4.0.5.
    3.      This code was not optimized
    */

    // ===== SOURCE =====

  // Path to this file by server directory structure.
  $cfg_['localftpdir'] = join('/',array_splice(split("/",ereg_replace('\\',
  '/', $PATH_TRANSLATED)), 0, count(split('/',ereg_replace('\\', '/',
  $PATH_TRANSLATED)))-1));

  // REMEMBER - No end backslash.
  $startDir = $cfg_['localftpdir'].'/dir1';
  $startDir = str_replace('//','/',$startDir); // for win systems
  $endDir   = $cfg_['localftpdir'].'/dir2';
  $endDir   = str_replace('//','/',$endDir);   // for win systems

  // Make base directory in end directory.
  $arrCD = explode('/',$startDir);
  mkdir($endDir.$arrCD[count($arrCD)-1],0700);
  $endDir = $endDir.$arrCD[count($arrCD)-1];

  function paste($param) {
   $workDir = $param[0]; // Assign values to variables.
   $endDir  = $param[1]; // It's only for our comfort.
   $var     = $param[2]; //
   $end     = $param[3]; //

   if ($dir = opendir($workDir.$var)) { // Open work directory.
    $dirCount = 0;                      // Assume - there is no other directory in work directory.
    while (($file = readdir($dir)) !== false) { // List all elements.
     // If there is directory and it's not '.' and '..' that not exists in end directory.
     // Choose first meet directory, select name and create it in end directory.
     if ((is_dir($workDir.$var.'/'.$file) && (($file != '.') && ($file != '..')))
  && is_dir($endDir.$var.'/'.$file) == false) {
      $dirCount++; break; // Break while - work directory is not empty.
     }
     if (is_file($workDir.$var.'/'.$file) && is_file($endDir.$var.'/'.$file) ==
  false) {
      copy($workDir.$var.'/'.$file,$endDir.$var.'/'.$file);
     }
    }
    if ($dirCount==0) { // If there was no other directories.
     if ($var == '' || $var == '/') { $end=true; } // And if we are in start directory this means we must finish copying.
     else { // Else...
      $var = str_replace('//','/',$var);
      $arrVar = split('/',$var);
      $arrVar = array_slice($arrVar, 0, count($arrVar)-1);
      $var = join('/',$arrVar); // cut $var path one element from end.
     }
    }
    else {
     mkdir($endDir.$var.'/'.$file,0700); // Make chosen directory in end directory.
     if ($var=='') { $var = '/'.$var.$file; } // Increase $var path.
     else { $var = '/'.$var.'/'.$file; }
     $var = str_replace('//','/',$var);
    }
   } closedir($dir); // Close work dir.

   $param[0] = $workDir; // Assign values to array, ...
   $param[1] = $endDir;  //
   $param[2] = $var;     //
   $param[3] = $end;     //

   return $param; // return array as a function result.
  }

  if ($dir = opendir($startDir)) { // Copy all files from main copied directory to end directory.
   while (($file = readdir($dir)) !== false) {
    if (is_file($startDir.'/'.$file) && is_file($endDir.'/'.$file) == false) {
     copy($startDir.'/'.$file,$endDir.'/'.$file);
    }
   }
  } closedir($dir);

  // Assign starting values...
  $end = false;
  $param[0] = $startDir;
  $param[1] = $endDir;
  $param[2] = '';
  $param[3] = $end;

  // Copy directory.
  while ($end !== true) {
   $param = paste($param);
   $workDir = $param[0];
   $endDir  = $param[1];
   $var     = $param[2];
   $end     = $param[3];
  }

  echo 'Done !';
?>
