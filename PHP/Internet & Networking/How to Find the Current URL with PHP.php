<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: How to Find the Current URL with PHP

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

  // find out the domain:
  $domain = $_SERVER['HTTP_HOST'];

  // find out the path to the current file:
  $path = $_SERVER['SCRIPT_NAME'];

  // find out the QueryString:
  $queryString = $_SERVER['QUERY_STRING'];

  // put it all together:
  $url = "http://" . $domain . $path . "?" . $queryString;
  echo "The current URL is: " . $url . "<br />";

  // An alternative way is to use REQUEST_URI instead of both
  // SCRIPT_NAME and QUERY_STRING, if you don't need them seperate:
  $url2 = "http://" . $domain . $_SERVER['REQUEST_URI'];
  echo "The alternative way: " . $url2;

?>
