<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: How to use the build-in function wordwrap to create line breaks by a user definied length

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: wordwrap example (PHP)
** Desc: Shows how to use the build-in function "wordwrap" to create line breaks by a user definied length.
** Example: see below
** Author: Jonas John
*/

// create a long text for testing:
$long_text = 'This is a long text to demonstrate the usage of the ';
$long_text .= 'wordwrap function. ';
$long_text .= 'Fooooooooooooooooobar, just fooling around';

// syntax: wordwrap(input string, line max. width, break chars, cut words)
$new_text = wordwrap($long_text, 15, "<br/>\n", true);

print $new_text;

/*
The output will be:

This is a long<br/>
text to<br/>
demonstrate the<br/>
usage of the<br/>
wordwrap<br/>
function.<br/>
Foooooooooooooo<br/>
ooobar, just<br/>
fooling around
*/

?>
