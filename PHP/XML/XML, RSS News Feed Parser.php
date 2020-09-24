<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: XMLRSS News Feed Parser

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

// $Id: feedsplitter.php,v 1.7 2004/02/19 20:30:24 csnyder Exp $
//
// 2006-01-17 -- stripping \r (carriage return) and ascii NULL from incoming feed
// 2004-02-19 -- xml parser now expects utf-8 encoding by default, thanks to Edward Spodick for the Chinese feed
//            -- if local.inc is present, you can use it to define HTTP referers that are allowed to use feedplitter
// 2004-01-08 -- added cache headers to response, Super Thanks to Scott McDowell
// 2003-01-25 by Chris Snyder <csnyder@chxo.com>
//
// convert an RSS newsfeed to simple Javascript client-side include
//
// REQUIRES PHP 4.3.0 or better due to several instances of file_get_contents()
//        this is easy enough to work around if necessary, see PHP manual entry for details.


/*
feedsplitter.php -- XML newsfeed parser
Copyright (C) 2003 by Chris Snyder (csnyder@chxo.com)

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

/*
The XML parser uses a modification of the method for creating a poor man's DOM array
that was posted by "mreilly at ZEROSPAM dot MAC dot COM"
at http://www.php.net/manual/en/ref.xml.php on 14-Nov-2002 11:01.
*/

/*
CONTENTS / EXECUTION ORDER:
0) INITIALIZE
1) PARSE REQUEST
2) CACHE CONTROL
3) XML PARSER FUNCTIONS
4) PARSE THE NEWSFEED/CACHE
5) FORMAT PARSED DATA
6) PARSE CONTEXT FILE
7) MERGE DATA WITH CONTEXT
8) OUTPUT AND CLEANUP
*/

// 0) INITIALIZE VARIABLES
// CONFIG has moved to the files below
if ( is_readable('feedsplitter-local.php') ) {
  include_once('feedsplitter-local.php');
}
else {
  include_once('feedsplitter-defaults.php');
}

// local var setup
// life of local cache files in seconds
if ($_REQUEST['recache']!=1) {
  $cachesecs= (60*60*$hours);
}
else {
  $cachesecs= 0;
}
// life of remote caches in seconds
$remotecachesecs= (60 * 60 * $hours);
$patharray = array();
$parsed= array();
$itemindex= 0;
$currenttime= time();
$context= array();


// 1) PARSE REQUEST VARS
// showsource shows the PHP source -- truly open source!
$showsource= $_REQUEST['showsource'];
if ($_REQUEST['debug']) {
  $debug= "<p><a name='debug'>&nbsp;</a></p><hr /><b>Debuging Notes:</b><br />";
  $showdebug= 1;
}
else $debug= "";

// if $hosts_allowed is an array, use it to determine which hosts are allowed to be in the HTTP_REFERER
if ( !empty($hosts_allowed) && is_array($hosts_allowed) && !empty($_SERVER['HTTP_REFERER']) ){
  $referer = parse_url($_SERVER['HTTP_REFERER']);
  if ( !in_array($referer['host'], $hosts_allowed) ){
    exit("document.writeln('Sorry, but this copy of feedsplitter may not be called from $referer[host]. Get your own copy of feedsplitter free from http://chxo.com/feedsplitter/index.php');");
  }
}

// format determines which context template is used
$format= $_REQUEST['format'];
if ($format=="") $format= "test";
if (strpos($format, ".")) {
  print "<b>Error:</b> Invalid format.";
  exit;
}
$contextfile= "$format.xml";

// feed is the URL of the RDF/RSS newsfeed
$feed= $_REQUEST['feed'];
if ($feed=="") $feed = "http://chxo.com/be2/software/feedsplitter/index.rss";
if (strpos($feed, "..") || substr($feed,0,7)!="http://") {
  print "<b>Error:</b> Invalid feed. Must be an http:// url and not contain \"..\".";
  exit;
}

// maxitems determines how many items to list (default is to list all)
$maxitems= $_REQUEST['maxitems'];

// stylesheet will cause the context's native stylesheet to be displayed if there is one
$stylesheet= $_REQUEST['stylesheet'];

// show searchbox and descriptions by default
if ($_REQUEST['showsearch']!="0") $showsearch= 1;
if ($_REQUEST['showdescription']!="0") $showdescription= 1;

// target determines the target of all <a href> tags
if ($_REQUEST['target']) $target= $_REQUEST['target'];



// 2) CACHE CONTROL
//
$localfeed= $feedsplitterdata.md5($feed);
if ($debug) $debug.="<p>Looking for cache of $feed at $localfeed...\n";
if (!is_dir($feedsplitterdata)) {
  // attempt to create data dir
  if (!mkdir($feedsplitterdata)) {
    print "<br /><b>Error:</b> Unable to create a cache directory at $feedsplitterdata. Cannot continue.";
    exit;
  }
  elseif ($debug) $debug.="<br />(created new data directory at $feedsplitterdata)\n";
}
if (file_exists($localfeed)) {
  // cache file exists, how old is it? (Note that if recache=1 in request, $cachesecs is set to 0, forcing expiration)
  $cachemtime= filemtime($localfeed);
  $expires= $cachemtime + $cachesecs;
  if ($expires > $currenttime) {
    // cache is fresh, use it as $feed
    $cached= 1;
    $feedsize= filesize($localfeed);
    if ($debug) $debug.="<br />Using cache created on ".date("r",$cachemtime).". (size is $feedsize bytes)
                                <br />&nbsp;Cache expires on ".date("r",$expires)." ($cachesecs seconds from creation).\n";
  }
  else {
    // cache is not so fresh
    $cached= 2;
    if ($debug) $debug.="<br />Cache is older than $cachesecs seconds, will create new.
                                <br />&nbsp;(discarding cache created on ".date("r",$cachemtime).".)\n";
  }
}
else {
  // cache doesn't exist yet
  $cached= 0;
  if ($debug) $debug.="<br />No cache file found at $localfeed.\n";
}

// create $localfeed if necessary
if ($cached==0 || $cached==2) {
  // I use fsockopen because you can set a timeout, but if you're not Unix you can't (?) so use this instead
  //$cachecontents= file_get_contents($feed);
  // start of fsockopen code
  $urlarray= parse_url($feed);
  $feedhost= $urlarray['host'];
  $feeduri= $urlarray['path'];
  if ($urlarray['query']!="") $feeduri.= "?".$urlarray['query'];
  if ($urlarray['fragment']!="") $feeduri.= "#".$urlarray['fragment'];
  $referer= "http://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'];
  $fp= fsockopen($feedhost, 80, $errno, $errstr, $timeout);
  if ($fp) {
    if ($debug) $debug.= "<hr />Progress: ";
    fputs ($fp, "GET $feeduri HTTP/1.0\r\nHost: $feedhost\r\nReferer: $referer\r\nUser-Agent: feedsplitter.php/".'$Date: 2004/02/19 20:30:24 $'." (http://chxo.com)\r\n\r\n");
    while (!feof($fp)) {
      $temp= fgets($fp, 512);
      if ($debug) $response.= $temp;
      if (!$firstblank && trim($temp)!="") continue;
      elseif (!$firstblank) {
        $firstblank= 1;
        continue;
      }
      $cachecontents.= $temp;
      if ($debug) $debug.= "#";
    }
    fclose ($fp);
    if ($debug) $debug.="<hr /><b>Response:</b><br />$response<hr />";
  }
  // end of fsockopen code

  // so what have we got?
  if ($cachecontents=="" && $cached==0) {
    // no cache, no remote, no dice
    if ($debug) print "<br /><b>Error:</b> Unable to open $feed, cannot continue. $debug";
    exit;
  }
  elseif ($cachecontents=="" && $cached==2) {
    // well whaddyaknow? we get to use that stinky old cache after all!
    $feedsize= filesize($localfeed);
    if ($debug) $debug.="<br />Using EXPIRED cache created on ".date("r",$cachemtime).". (size is $feedsize bytes)
                                <br />&nbsp;Cache expired on ".date("r",$expires).".\n";
  }
  else {
    // ah, a nice fresh remote feed, let's cache it

    // 2006-01-17 - csnyder -- stripping the contents of carriage returns and nulls, first
    $cachecontents = str_replace( array("\r","\0"), "", $cachecontents );

    $fp= fopen($localfeed, "w");
    fwrite($fp, $cachecontents);
    fclose($fp);
    $feedsize= filesize($localfeed);
    $cachemtime= time();
    if ($debug) $debug.="<br />Successfully created cache of $feed at $localfeed. (Size is $feedsize bytes)\n";
  }
}

// done with cache control
if ($debug) $debug.="</p><hr/>\n";


// 3) DEFINE XML PARSER FUNCTIONS
//        These parser the XML into an associative array ($parsed) that looks a little like a DOM-- that is,
//        the channel title ends up in $parsed[CHANNEL][TITLE], and items are assigned to $parsed[ITEM][n][TITLE]
//        where n is the item's position in the RDF, starting with 0.
//
function startElement($parser, $name, $attrs="") {
  global $patharray, $debug;
  if ($debug) $debug.="&lt;$name&gt;<blockquote>\n";

  // keep track of the current tag
  array_push($patharray, $name);
}

function endElement($parser, $name) {
  global $patharray, $itemindex, $debug;
  if ($debug) $debug.="</blockquote>&lt;/$name&gt;<br />\n";

  // lose the current tag
  array_pop($patharray);

  // item tracking
  if ($name=="ITEM") {
    $itemindex++;
  }
}

function characterData($parser, $data) {
  global $parsed, $patharray, $itemindex, $debug;
  if ($debug) $debug.="<font color='orange'>$data</font>\n";

  // ignore fields that are just whitespace
  if (trim($data)!="") {
    // $define is used to build the command that creates the associative array via eval() later
    $define = "\$parsed";

    // Add an array entry for each nested level we're currently in.
    // $i=1 skips the <rdf:RDF> level.
    for ($i = 1; $i < count($patharray); $i++) {
      $define .= "['".$patharray[$i]."']";
      if ($patharray[$i]=="ITEM") {
        // items are an array
        $define.= "[$itemindex]";
      }
    }

    // when eval()'d, $define looks like:  $parsed['PARENT']['CHILD'] .= '$data';
    //        the addslashes/stripslashes bit is a kludge against single quotes in $data
    $define .= " .= stripslashes('".addslashes($data)."');";
    eval($define);

    if ($debug) $debug.="<br />$define<br />\n";
  }
}
// end XML Parser functions


// 4) MAIN XML PARSING ENGINE
//
// Create XML parser ...
$xml_parser = xml_parser_create('UTF-8');
xml_parser_set_option($xml_parser, XML_OPTION_CASE_FOLDING, true);
xml_parser_set_option($xml_parser, XML_OPTION_TARGET_ENCODING, 'UTF-8');
xml_set_element_handler($xml_parser, "startElement", "endElement");
xml_set_character_data_handler($xml_parser, "characterData");

// ... and feed it the feed
$data = file_get_contents($localfeed);
if (trim($data)=="") {
  if ($debug || $format=="test") print "Could not open newsfeed.";
  exit;
}
if (!xml_parse($xml_parser, $data, 1)) {
  if ($debug || $format=="test") {
    die(sprintf("XML error: %s at line %d", xml_error_string(xml_get_error_code($xml_parser)), xml_get_current_line_number($xml_parser)));
  }
  else exit;
}
xml_parser_free($xml_parser);


// 5) FORMAT FOR OUTPUT
//
// $parsed is now an array of channel, image, items, and textinput
$channel= $parsed['CHANNEL'];
$image= $parsed['IMAGE'];
if (!is_array($image)) {
  // rss 0.9 puts everything in the channel data
  $image= $channel['IMAGE'];
}
$itemarray= $parsed['ITEM'];
if (!is_array($itemarray)) {
  // rss 0.9 puts everything in the channel data
  $itemarray= $parsed['CHANNEL']['ITEM'];
}
$textinput= $parsed['TEXTINPUT'];

// show source code?
if ($showsource) $sourceinfo= " Script: $SCRIPT_FILENAME ( <a href='#source'>source code</a> )";
else $sourceinfo= " <a href='$SCRIPT_NAME?showsource=1#source'>show source code</a>";
// show jump to debug?
if ($showdebug) $debugjump= "| <a href='#debug'>debugging notes</a>";


// 6) PARSE CONTEXT FILE (format.xml)
// define context parser function (populates $context[] array)
function parseContext($data) {
  global $context, $debug;
  $found= 0;
  $properties= array("preprocess", "postprocess", "channel", "image", "item", "description", "textinput", "stylesheet");
  if ($debug) $debug.= "data= <blockquote>".nl2br(htmlentities($data))."</blockquote>\n";
  foreach ($properties AS $key=>$class) {;
  $classlength= strlen($class) + 2;
  if ($parsestart= strpos( $data, "<$class>") + $classlength) {
    if ($commandout= strpos( $data, "</$class>", $parsestart)) {
      $parselength= $commandout - $parsestart;
      $context[$class]= substr( $data, $parsestart, $parselength);
      if ($debug) $debug.= "context[$class]= substr( data, $parsestart, $commandout ); classlength=$classlength.<br />";
      if ($debug) $debug.= "<b>context[$class]=</b> <blockquote>".nl2br(htmlentities($context[$class]))."</blockquote>\n";
      $found= 1;
    }
  }
  }

  return $found;
}

// Create the context array
$data = file_get_contents($contextfile);
if (trim($data)=="") {
  if ($debug || $format=="test") print "Could not open context file.";
  exit;
}
if (!parseContext($data)) {
  if ($debug || $format=="test") {
    print "<b>Error, unable to parse context file $contextfile.</b>";
    exit;
  }
  else exit;
}


// 7) MERGE CONTEXT AND DATA
/*        Context processing order:
preprocess,
stylesheet,
imageRender,
textinputRender,
foreach items ( descriptionRender, itemsRender++ ),
channelRender,
postprocess
*/
if ($debug) $debug.= "<hr /><b>Processing / Rendering bits</b>:<br>\n";

// preprocess
if ($context['preprocess']) {
  if ($debug) $debug.= "<b>preprocess starts:</b><blockquote>\n";
  $void= eval("$context[preprocess]");
  if ($debug) $debug.= "</blockquote><b>preprocess done.</b>\n";
}

// stylesheetRender
if ($stylesheet==1 && $context['stylesheet']) {
  $command= "\$stylesheet= \"".addslashes($context[stylesheet])."\";";
  $void= eval("$command");
  if ($debug) $debug.= "<b>stylesheet= </b><blockquote>".nl2br(htmlentities($stylesheet))."</blockquote>\n";
}

// imageRender
if ($image['URL']!="") {
  $command= "\$imageRender= \"".addslashes($context[image])."\";";
  $void= eval("$command");
  if ($debug) $debug.= "<b>imageRender= </b><blockquote>".nl2br(htmlentities($imageRender))."</blockquote>\n";
}

// textinputRender
if ($showsearch==1 && $textinput['LINK']!="") {
  $command= "\$textinputRender= \"".addslashes($context[textinput])."\";";
  $void= eval("$command");
  if ($debug) $debug.= "<b>textinputRender= </b><blockquote>".nl2br(htmlentities($textinputRender))."</blockquote>\n";
}

// itemsRender
if (is_array($itemarray)) {
  $count= 0;
  foreach ($itemarray AS $key=>$item) {
    if ($maxitems!=0 && $count >= $maxitems) continue;
    if ($showdescription==1 && $item['DESCRIPTION']!="") {
      $command= "\$descriptionRender.= \"".addslashes($context[description])."\";";
      $void= eval("$command");
      if ($debug) $debugalt= "<br\>&nbsp;rendered description<br\>";
    }
    else $descriptionRender= "";
    $command= "\$itemsRender.= \"".addslashes($context[item])."\";";
    $void= eval("$command");
    if ($debug) $debug.= "<b>rendered item</b>$debugalt<br />\n";
    $descriptionRender= "";
    $count++;
  }
}

// channel
$command= "\$channelRender= \"".addslashes($context[channel])."\";";
if ($stylesheet=="0") $stylesheet= "";
$void= eval("$command");
if ($debug) $debug.= "<b>channelRender= </b><blockquote>".nl2br(htmlentities($channelRender))."</blockquote>\n";

// postprocess
if ($context[postprocess]) {
  if ($debug) $debug.= "<b>postprocess starts:</b><blockquote>\n";
  $void= eval("$context[postprocess]");
  if ($debug) $debug.= "</blockquote><b>postprocess done.</b>\n";
}
else {
  // default postprocess
  $output= $channelRender;
}


// 8) OUTPUT AND CLEANUP
if ( !headers_sent() && !$showsource && $_REQUEST['recache']!=1 ){
  // http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.29
  header("Last-Modified: " .date("r", filemtime($localfeed)));

  // http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.21
  header("Expires: " .date("r", strftime(filemtime($localfeed)) + $remotecachesecs));

  //http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9
  header('Cache-Control: public;');
}

print $output;

// showsource part II
if ($showsource) {
  print "<hr/><a name='source'> </a><h1>PHP Source:</h1>\n";
  $void= show_source($SCRIPT_FILENAME);
  print "<hr/><h1>Context File ($contextfile)</h1>";
  $void= show_source($contextfile);
}
if ($showdebug) {
  print $debug;
}

?>
