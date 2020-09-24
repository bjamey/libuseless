<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Caching for dynamic content

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

  /*
  ** Function: Caching for dynamic content (PHP)
  ** Desc: This snippet shows you how to send a Last-Modified and an ETag header tohelp browsers caching the website.This will make your website really faster :-)
  ** Example: see below
  ** Author: Jonas John
  */

  // start buffering
  ob_start();

  print '<html>';

  // put your content in here:
  print '<h1>Content</h1>';

  print '<ul>';
  for ($x=0; $x < 10; $x++)
  {
      print "<li>List item $x</li>";
  }
  print '</ul>';

  print '</html>';

  // or include() something here


  // get page content
  $content = ob_get_contents();

  // clear buffer
  ob_end_clean();



  // generate unique ID with MD5
  $hash = md5($content);

  // set last change, load this from
  // a database or something else
  // or filectime('filename.htm');
  $last_change = 1144055759;


  // set expire time to one hour
  $expires = 3600;


  // get request headers:
  $headers = apache_request_headers();
  // you could also use getallheaders() or $_SERVER

  header('Content-Type: text/html');

  // default headers:
  header('Content-language: en');

  header('Cache-Control: max-age=3600'); // must-revalidate
  header('Expires: '.gmdate('D, d M Y H:i:s', $last_change+$expires).' GMT');

  // last modified
  header('Last-Modified: '.gmdate('D, d M Y H:i:s', $last_change).' GMT');

  // send etag
  header('ETag: '.$hash);

  $modified_since = false;
  if (isset($headers['If-Modified-Since']) and strtotime($headers['If-Modified-Since']) == $last_change)
  {
      $modified_since =  true;
  }

  $none_match = false;
  if (isset($headers['If-None-Match']) and ereg($hash, $headers['If-None-Match']))
  {
      $none_match = true;
  }

  if ($modified_since or $none_match)
  {
      // the content did not get modified:
      header('HTTP/1.1 304 Not Modified');

      // close the connection:
      header('Connection: close');

      // dont send the content
  }
  else
  {
      // okay found!
      header('HTTP/1.1 200 OK');

      header('Content-Length: '.strlen($content));

      // send content
      print $content;
  }

?>
