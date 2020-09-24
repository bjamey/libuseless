<?php /* ----------------------------------------------------------------------
                                        DTT 1.1.5.0  (c)2006 FSL - FreeSoftLand
   Title: MySQL Erase script

   Date : 09.8.2006
   By   : Dimitar Minchev <mitko@bfu.bg>
---------------------------------------------------------------------------- */

  // connect
  require ("connect.php");
  $link = new connection();
  $link->connect();

/*
  Usage:
  -----
  <a href="erase.php?table=currency&id=10"> Erase </a>
  <img src="erase.php?table=offer&&id=10">
*/

  // query
  $result = mysql_query("DELETE FROM ".$_GET['table']." WHERE id=" . $_GET['id']);
  
  // if SQL suceed
  if ($result) {
    // Record erased
    echo 'Record erased.';
  } else {
    // Can not erase record
    echo 'Can not erase record.';
  }

  // disconnect
  $link->disconnect();
?>

