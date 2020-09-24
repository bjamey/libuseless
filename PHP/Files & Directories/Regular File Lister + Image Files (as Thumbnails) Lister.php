<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Regular File Lister + Image Files (as Thumbnails) Lister

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

// 2002-06-25 17:44 by Chris Snyder  (csnyder@chxo.com)
// 2002-07-28 16:44 added paging ($skip and $perpage)
// 2002-08-16 11:50 updated for REGISTER_GLOBALS turned off
// 2002-08-25 20:11 listing directories first
// 2003-01-06 12:56 alphabetize folders and files, use apache icons, and don't show thumbs over 500k
// 2003-01-09 18:08 skip-to-files link
// 2003-01-22 18:20 fix alt/title tags for filetype icons, add .zip
// 2003-02-14 10:50 add $filepath suggestion on line 78
// 2003-03-15 19:49 urlencode foldernames
//
// find and list images in path (a folder) as thumbnails
// drop in replacement for fancyindexing -> either drop into an image directory as index.php
//              -OR-  point to script in Apache DirectoryIndex directive:
//                    DirectoryIndex index.html index.htm /cgi-bin/image-list.php

/*
image-list.php -- fancy image indexing using PHP
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

$thumbwidth=80;
$thumbheight=60;
$thumblimit= 800;  // (Max filesize in KB for displaying thumbnail)
$skip= $_REQUEST["skip"];
$perpage= $_REQUEST["perpage"];
$showsource= $_REQUEST["showsource"];
$REQUEST_URI= getenv("REQUEST_URI");
$DOCUMENT_ROOT= getenv("DOCUMENT_ROOT");
$SCRIPT_NAME= getenv("SCRIPT_NAME");
$SCRIPT_FILENAME= getenv("SCRIPT_FILENAME");
$SERVER_SIGNATURE= getenv("SERVER_SIGNATURE");

if ($skip=="") $skip= 0;
if ($perpage=="") $perpage= 48;

function myfilesize($file) {
    // First check if the file exists.
    if(!is_file($file)) exit("File does not exist!");

    // Setup some common file size measurements.
    $kb = 1024;         // Kilobyte
    $mb = 1024 * $kb;   // Megabyte
    $gb = 1024 * $mb;   // Gigabyte
    $tb = 1024 * $gb;   // Terabyte

    // Get the file size in bytes.
    $size = filesize($file);

    if($size < $kb) return $size." B";
    else if($size < $mb) return round($size/$kb,2)." KB";
    else if($size < $gb) return round($size/$mb,2)." MB";
    else if($size < $tb) return round($size/$gb,2)." GB";
    else return round($size/$tb,2)." TB";
    }

if (substr($REQUEST_URI,-1)=="/") {
    $length= strlen($REQUEST_URI)-1;
    $uripath= substr($REQUEST_URI,0,$length);
    }
else {
    $uripath= dirname($REQUEST_URI);
    }
$filepath= $DOCUMENT_ROOT.urldecode($uripath);
// Some users have suggested:
// $filepath= realpath(".");
// instead of using $DOCUMENT_ROOT.
// print "filepath= $filepath and realpath=".realpath(".")." and uripath= $uripath ";

$lastslash= strrpos($uripath,"/");
$parenturi= substr($uripath,0,$lastslash+1);
if ($parenturi=="") $parenturi= "/";
$displayuripath= urldecode($uripath);

// show source code?
if ($showsource) $sourceinfo= "| Script: $SCRIPT_FILENAME ( <a href='#source'>source code</a> )";
else $sourceinfo= "| <a href='$SCRIPT_NAME?showsource=1#source'>show source code</a>";

print "<html>
<head>
<title>$displayuripath</title>
<style type='text/css'>
    body { font-family: Verdana, Geneva, sans-serif; font-size: 12px; background-color: #ffffee;}
    table { font-family: Verdana, Geneva, sans-serif; font-size: 12px; }
    .heading { font-size: 12px; font-weight: bold; background-color: #666677; color: #dddddd; border: 1px; border-style: solid; }
    .oddrow { background-color: #ffffff; }
    .evenrow { background-color: #eeffee; }
</style>
</head>
<body>
<h1>Image index of $displayuripath</h1>
<p><a href='$parenturi'><img src='/icons/back.gif' border=0 hspace=5 align=absmiddle>Up to parent folder</a> | <a href='#files'>Jump to files</a> $sourceinfo</p>";

if ($skip) {
    $prevskip= $skip - $perpage;
    if ($prevskip<0) $prevskip= 0;
    $prevtag= "<a href='?skip=$prevskip'>Previous Page</a>";
    print "<p>$prevtag</p>";
    }

if ($handle = opendir($filepath)) {
    print "
<table cellpadding=5>
    <tr class=heading>
        <td align=center>Icon</td>
        <td>Name</td>
        <td align=center>Filesize</td>
                <td>Timestamp</td>
    </tr>";

        // FIRST PASS for subdirectories only -- makes $mydirarray, which can be sorted alphabetically
        $count= 0;
    while ($file = readdir($handle)) {
        if (substr($file,0,1)==".") continue;
        if ($file=="index.php") continue;
        if (@is_dir("$filepath/$file")) {
                        $mydirarray[$count]="$file";
                        $count= $count+1;
            }
                }
        closedir($handle);

        // now sort and print subfolders...
        if (is_array($mydirarray)) {
                sort($mydirarray);
                reset($mydirarray);
                foreach ($mydirarray AS $key=>$file) {
                        $timestamp= filemtime("$filepath/$file");
                        $modified= date("r", $timestamp);
                        if ($evenrow) {
                                $evenrow=0;
                                $rowclass= "evenrow";
                                }
                        else {
                                $evenrow=1;
                                $rowclass= "oddrow";
                                }
            if ($key==($count-1)) $separator= "<a name='files'> </a>";
            $safefile= urlencode($file);
                        print "
                        <tr class='$rowclass'>
                                <td align=right><img src='/icons/folder.gif' alt=folder title=folder></td>
                                <td><a href='$uripath/$safefile/'>$file/</a>$separator</td>
                                <td align=center>-</td>
                                <td>$modified</td>
                        </tr>";
                        }
                }


        // SECOND PASS for files only
    $handle = opendir($filepath);
    $skipped= 0;
    $index= 0;
    $count= 0;
    while ($file = readdir($handle)) {
        // don't show .dotfiles, self, directories, or links (links are bad??? hmm)
        if (substr($file,0,1)==".") continue;
        if ($file=="index.php") continue;
        if (@is_dir("$filepath/$file")) continue;
        if (@is_link("$filepath/$file")) continue;
        $myfilearray[$count]= $file;
        $count= $count+1;
        }
        closedir($handle);

    // now sort on filename
    if (is_array($myfilearray)) {
        sort($myfilearray);
        reset($myfilearray);
        foreach ($myfilearray AS $key=>$file) {
            if ($index >= $perpage) {
                $shownext= 1;
                break;
                }
            if ($skipped<$skip && $skip!= 0) {
                $skipped= $skipped + 1;
                continue;
                }
            $index= $index + 1;
            $timestamp= filemtime("$filepath/$file");
            $modified= date("r", $timestamp);
            if ($evenrow) {
                $evenrow=0;
                $rowclass= "evenrow";
                }
            else {
                $evenrow=1;
                $rowclass= "oddrow";
                }
            unset($info);
            unset($extrainfo);
            unset($sizetag);
            $filesize= myfilesize("$filepath/$file");
            if ($imagesize=@getimagesize("$filepath/$file",$info)) {
                $width= $imagesize[0];
                $height= $imagesize[1];
                if ($width>$thumbwidth) {
                    $ratio= $thumbwidth / $width;
                    $width=$thumbwidth;
                    $height= $height*$ratio;
                    }
                if ($height>$thumbheight) {
                    $ratio= $thumbheight / $height;
                    $height=$thumbheight;
                    $width= $width*$ratio;
                    }

                switch ($imagesize[2]) {
                    case 5: $icontag= "<img src='/icons/image3.gif' alt=file title='photoshop image'>"; break;
                    case 7: $icontag= "<img src='/icons/image2.gif' alt=file title='tiff image'>"; break;
                    case 8: $icontag= "<img src='/icons/image2.gif' alt=file title='tiff image'>"; break;
                    default: $icontag= "<img src='$uripath/$file' width=$width height=$height alt=image title=image>"; break;
                    }
                $sizetag= "($imagesize[0]x$imagesize[1])";

                if (isset ($info['APP13'])) {
                    $iptc = iptcparse ($info['APP13']);
                    if (is_array($iptc)) {
                        foreach ($iptc AS $key=>$val) {
                            if ($key=="2#000") continue;
                            $extrainfo.="$val[0]<br>";
                            }
                        }
                    }
                // don't show thumbnails bigger than 500K!
                if (filesize("$filepath/$file")>($thumblimit*1024)) $icontag= "<img src='/icons/image2.gif' alt=file title='image'>";
                }
            else {
                // try to determine from extension...
                $lastdot= strrpos($file, ".");
                $extension= strtolower(substr($file,$lastdot+1));
                //flerror("File extension is $extension.");
                switch ($extension) {
                    case "pdf": $icontag= "<img src='/icons/layout.gif' alt=pdf title=pdf>"; break;
                    case "txt": $icontag= "<img src='/icons/text.gif' alt=text title=text>"; break;
                    case "htm": $icontag= "<img src='/icons/text.gif' alt=html title=html>"; break;
                    case "html": $icontag= "<img src='/icons/text.gif' alt=html title=html>"; break;
                    case "wav": $icontag= "<img src='/icons/sound1.gif' alt=sound title=sound>"; break;
                    case "au": $icontag= "<img src='/icons/sound1.gif' alt=sound title=sound>"; break;
                    case "aiff": $icontag= "<img src='/icons/sound1.gif' alt=sound title=sound>"; break;
                    case "mp3": $icontag= "<img src='/icons/sound2.gif' alt=sound title=sound>"; break;
                    case "ogg": $icontag= "<img src='/icons/sound2.gif' alt=sound title=sound>"; break;
                    case "mov": $icontag= "<img src='/icons/movie.gif' alt=video title=video>"; break;
                    case "avi": $icontag= "<img src='/icons/movie.gif' alt=video title=video>"; break;
                    case "mpg": $icontag= "<img src='/icons/movie.gif' alt=video title=video>"; break;
                    case "mpeg": $icontag= "<img src='/icons/movie.gif' alt=video title=video>"; break;
                    case "mp4": $icontag= "<img src='/icons/movie.gif' alt=video title=video>"; break;
                    case "divx": $icontag= "<img src='/icons/movie.gif' alt=video title=video>"; break;
                    case "zip": $icontag= "<img src='/icons/compressed.gif' alt='archive' title='zip archive'>"; break;
                    default: $icontag= "<img src='/icons/generic.gif' alt=file title=file>"; break;
                    }
                }
            // file row
            $safefile= urlencode($file);
            print "
        <tr class='$rowclass'>
            <td valign=top align=right>$icontag</td>
            <td valign=top><a href='$uripath/$safefile'>$file</a> $sizetag</td>
            <td valign=top align=center>$filesize</td>
            <td valign=top>$modified</td>
            </tr>";
            }
        }
    else print "
        <tr>
            <td valign=middle colspan='4'>&nbsp; No files here.</td>
            </tr>";

    print "
    <tr class=heading>
        <td align=center>Image</td>
        <td>Name</td>
        <td align=center>Filesize</td>
        <td>Timestamp</td>
    </tr>
</table>";

    if ($shownext) {
        $nextskip= $skip + $index;
        if ($prevtag) $prevtag .= " | ";
        print "<p>$prevtag <a href='?skip=$nextskip'>Next Page</a></p>";
        }
    elseif ($skip) {
        print "<p>$prevtag</p>";
        }

    print "
<p><a href='$parenturi'><img src='/icons/back.gif' border=0 hspace=5 align=absmiddle>Up to parent folder</a></p>";
    }

if ($showsource) {
    print "<hr><a name='source'> </a><h1>PHP Source:</h1>";
    $void= show_source($SCRIPT_FILENAME);
    }
print "
<hr>
image-list.php Copyright (C) 2003 by Chris Snyder<br>
This program comes with ABSOLUTELY NO WARRANTY.  This is free software, and you are welcome
to redistribute it under certain conditions; please refer to the
<a href='http://www.gnu.org/licenses/gpl.html'>GNU General Public License</a> for details.
</body>
</html>";

?>
