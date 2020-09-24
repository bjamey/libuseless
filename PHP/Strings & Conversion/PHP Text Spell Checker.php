<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: PHP Text Spell Checker

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

// 2002-10-10 by Chris Snyder
// this script uses aspell, but not the internal php spelling functions which are somewhat crippled by only being able to check words, not whole documents (as of ~php 4.2.2)
// requires that aspell be installed and working at /usr/local/bin/aspell -- see http://aspell.sourceforge.net/

// 2003-01-19 -- updated tempfile to use PHP's tempfile creation mech., also bumped year
// 2003-01-24 -- fixed bug that caused improper handling of words with no suggested corrections (thanks, Dekeyzer Stephane!)
// 2003-05-06 -- fixed a bug causing bad things to happen when multiple instances of incorrect words were found on any given line  (thanks, Dallas Brown!)
//             -- also fixed script so that $opener and $closer work for custom labeling of errors (thanks again, Dallas Brown!)

/*
spellcheck.php -- aspell-based spellchecker implemented in PHP
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

$text= $_POST['text'];
$showsource= $_GET['showsource'];

//
// file paths and the aspell command have moved down below line 58
//

// show source code part I
if ($showsource) $sourceinfo= "Script: $_SERVER[SCRIPT_FILENAME] ( <a href='#source'>source code</a> )";
else $sourceinfo= "<a href='$_SERVER[SCRIPT_NAME]?showsource=1#source'>show PHP source code</a>";
if (trim($text)!="") {
    $showsource= 0;
    $sourceinfo= "";
    }

print "<html>
<head>
<title>$uripath</title>
<style type='text/css'>
    body { font-family: Verdana, Geneva, sans-serif; font-size: 12px; line-height: 18px; background-color: #ffffdd;}
    table { font-family: Verdana, Geneva, sans-serif; font-size: 12px; }
    .heading { font-size: 12px; font-weight: bold; background-color: #666677; color: #dddddd; border: 1px; border-style: solid; }
    .oddrow { background-color: #ffffff; }
    .evenrow { background-color: #eeffee; }
</style>
</head>
<body>
<h1>Spell Check Some Text</h1>
<p>$sourceinfo</p>";

// if text+check is supplied, first open and create $temptext, then spell check
if (trim($text)!="" && ($_POST['submit']=="check" || $_POST['submit']=="re-check")) {

    // HERE'S WHERE YOU MIGHT NEED TO CHANGE FILE PATHS, etc.
    //
    // set up some vars and create a tempfile
    // tempnam() is a PHP function that creates a unique tempfile in the specified path,
    //    with the specified prefix
    $temptext= tempnam("/tmp", "spelltext");

    // if you spellcheck alot of HTML, add the -H flag to aspell to put it in SGML mode
    $aspellcommand= "cat $temptext | /usr/local/bin/aspell -a";

    // these three determine how errors are flagged ($indicator is a description of what $opener and $closer do)
    $indicator= "bold";
    $opener= "<b>";
    $closer= "</b>";
    //
    // END OF CONFIGURATION


    if ($fd=fopen($temptext,"w")) {
        $textarray= explode("\n",$text);
        fwrite($fd,"!\n");
        foreach($textarray as $key=>$value) {
            // adding the carat to each line prevents the use of aspell commands within the text...
            fwrite($fd,"^$value\n");
            }
        fclose($fd);

        // next create tempdict and temprepl (skipping for now...)

        // next run aspell
        $return= shell_exec($aspellcommand);

    // now unlink that tempfile
    $ureturn= unlink($temptext);

        //next parse $return and $text line by line, eh?
        $returnarray= explode("\n",$return);
        $returnlines= count($returnarray);
        $textlines= count($textarray);

        //print "text has $textlines lines and return has $returnlines lines.";
        $lineindex= -1;
        $poscorrect= 0;
        $counter= 0;
        foreach($returnarray as $key=>$value) {
            // if there is a correction here, processes it, else move the $textarray pointer to the next line
            if (substr($value,0,1)=="&") {
                //print "Line $lineindex correction:".$value."<br>";
                $correction= explode(" ",$value);
                $word= $correction[1];
                $absposition= substr($correction[3],0,-1)-1;
                $position= $absposition+$poscorrect;
                $niceposition= $lineindex.",".$absposition;
                $suggstart= strpos($value,":")+2;
                $suggestions= substr($value,$suggstart);
                $suggestionarray= explode(", ",$suggestions);
                //print "I found <b>$word</b> at $position. Will suggest $suggestions.<br>";

                // highlight in text
                $beforeword= substr($textarray[$lineindex],0,$position);
                $afterword= substr($textarray[$lineindex],$position+strlen($word));
                $textarray[$lineindex]= $beforeword."$opener$word$closer".$afterword;

                // kludge for multiple words in one line ("<b></b>" adds 7 chars to subsequent positions, for instance)
                $poscorrect= $poscorrect+strlen("$opener$closer");

                // build the correction form
                $counter= $counter+1;
                $formbody.= "<tr>
                                <td align='right'>$word</td>
                                <td>
                                    <input type='hidden' name='position$counter' value='$niceposition'>
                                    <input type='hidden' name='incorrect$counter' value=\"$word\">
                                    <select name='suggest$counter' onChange=\"document.corrector.correct$counter.value=this.value;\">
                                    <option value=\"$word\" selected>$word (as-is)</option>
                                    ";
                foreach ($suggestionarray as $key=>$value) {
                    $formbody.= "<option value=\"$value\">$value</option>
                                ";
                    }
                $inputlen= strlen($word)+5;
                $formbody.= "<option value=''>custom:</option>
                                    </select>
                                    <input type='text' name='correct$counter' value=\"$word\" size='$inputlen'>
                                </td>
                              </tr>";
                }

            elseif (substr($value,0,1)=="#") {
                //print "Line $lineindex unknown:".$value."<br>";
                $correction= explode(" ",$value);
                $word= $correction[1];
                $absposition= $correction[2] - 1;
                $position= $absposition+$poscorrect;
                $niceposition= $lineindex.",".$absposition;
                $suggestions= "no suggestions";
                $suggestionarray= explode(", ",$suggestions);
                //print "I found <b>$word</b> at $position. Will suggest $suggestions.<br>";

                // highlight in text
                $beforeword= substr($textarray[$lineindex],0,$position);
                $afterword= substr($textarray[$lineindex],$position+strlen($word));
                $textarray[$lineindex]= $beforeword."$opener$word$closer".$afterword;

                // kludge for multiple words in one line ("<b></b>" adds 7 chars to subsequent positions)
                $poscorrect= $poscorrect+strlen("$opener$closer");

                // build the correction form
                $counter= $counter+1;
                $formbody.= "<tr>
                                <td align='right'>$word</td>
                                <td>
                                    <input type='hidden' name='position$counter' value='$niceposition'>
                                    <input type='hidden' name='incorrect$counter' value=\"$word\">
                                    <select name='suggest$counter' onChange=\"document.corrector.correct$counter.value=this.value;\">
                                    <option value=\"$word\" selected>$word (as-is)</option>
                                    ";
                $inputlen= strlen($word)+3;
                $formbody.= "<option value=''>custom:</option>
                                    </select>
                                    <input type='text' name='correct$counter' value=\"$word\" size='$inputlen'>
                                </td>
                              </tr>";
                }

            else {
                //print "Done with line $lineindex, next line...<br><br>";
                $poscorrect=0;
                $lineindex= $lineindex+1;
                }
            }
        }
    print "<hr>Uncorrected Text (potential errors in $opener$indicator$closer):<blockquote>";
    foreach ($textarray as $key=>$value) {
        print $value."<br>";
        }
    print "</b><!-- comment catcher --></blockquote>";

    $htmltext= htmlentities($text);
    if ($formbody=="") $formbody= "<tr><td>&nbsp;</td><td><br><b>No errors!</b><br>Click 'correct' to continue with text unchanged.<br>&nbsp;</td></tr>";
    print "<hr><h3>Correction form:</h3>
    <form name='corrector' action='spellcheck.php' method='post'>
    <input type='hidden' name='text' value=\"$htmltext\">
    <table>
    $formbody
    <tr>
      <td>&nbsp;</td>
      <td><input type='submit' name='submit' value='correct'>
          <input type='reset' name='reset' value='reset form'>
      </td>
    </tr>
    </table>
    </form>";

    //print "<hr>Return:".nl2br($return);
    }

// or if text+correct is specified, make the indicated corrections
elseif (trim($text)!="" && $_POST['submit']=="correct") {
    $textarray= explode("\n",$text);

    $index= 1;
    $lastlineindex= 0;
    $poscorrect= 0;

    // look through list of positions and make corrections
    while (isset($_POST["position$index"])) {
        $positionarray= explode(",",$_POST["position$index"]);
        $lineindex= $positionarray[0];
        $absposition= $positionarray[1];

        if ($lastlineindex==$lineindex) {
            $position= $absposition+$poscorrect;
            }
        else {
            $poscorrect= 0;
            $position= $absposition;
            }
        $lastlineindex= $lineindex;
        $correct= $_POST["correct$index"];
        $incorrect= $_POST["incorrect$index"];
        //print "Found correction at $lineindex,$absposition. Replacing ";

        $before= substr($textarray[$lineindex],0,$position);
        $after= substr($textarray[$lineindex],$position+strlen($incorrect));
        $textarray[$lineindex]= $before.$correct.$after;

        $poscorrect= (strlen($correct)-strlen($incorrect))+$poscorrect;
        //print "Position correction is now $poscorrect.<br>";
        $index= $index+1;
        }

    //print "Original text:<br>";
    //print nl2br($text);
    //print "<hr>";

    foreach ($textarray as $key=>$value) {
        $newtext.=$value;
        }
    print "
    <form action='spellcheck.php' method='post'>
        <h3>Your Corrected Text:</h3><br>
        <textarea name='text' cols='60' rows='10'>$newtext</textarea><br>
        <input type='submit' name='submit' value='re-check'> | <a href='spellcheck.php'>Clear/Restart</a> | <a href='spellcheck.php?showsource=1#source'>Show Source</a>
    </form>";
    }

// otherwise, show the initial form
else {
    print "
    <form action='spellcheck.php' method='post'>
        Text to Check:<br>
        <textarea name='text' cols='60' rows='10'>$newtext</textarea><br>
        <input type='submit' name='submit' value='check'>
    </form>";
    }

// show source code part II
if ($showsource) {
    print "<hr><a name='source'> </a><h1>PHP Source:</h1>";
    $void= show_source($_SERVER['SCRIPT_FILENAME']);
    }

print "
<hr>
spellcheck.php Copyright (C) 2003 by Chris Snyder<br>
This program comes with ABSOLUTELY NO WARRANTY.  This is free software, and you are welcome
to redistribute it under certain conditions; please refer to the
<a href='http://www.gnu.org/licenses/gpl.html'>GNU General Public License</a> for details.
</body>
</html>";
?>

