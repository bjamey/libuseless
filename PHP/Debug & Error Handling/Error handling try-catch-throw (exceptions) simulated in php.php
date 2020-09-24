<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Error handling try-catch-throw (exceptions) simulated in php

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
   Have a look at this code which shows you how you can convert callback
   functionality in something that's simmilar to Java's try-catch-throw
   functionality and even code layout The code is untested -sorry- assert() and
   assert_options() showed no effect with my php4.02dev, but the idea...

   PHP4 only, less known functions:
*/

function try_catch($try, $catch) {
  global $lambda;

  $catch = 'global $php_errormsg; $exception = unserialize($php_errormsg);
$catch';
  $lambda = create_function("", $catch);
  assert_options( ASSERT_CALLBACK, $lambda);

  assert($try);
}

function throw($classname, $msg) {

  $level = error_reporting(E_ALL);
  $exception = new $classname($msg);
  @trigger_error( serialize($exception) );
  error_reporting ($level);

}

/* Now what's missing above? Right an exception stack. Well that's easy even with
PHP3: */

function try_catch($try, $catch) {
  global $_exception_stack;

  $_exception_stack = array();
  eval($try);
  if (0!=count($_exception_stack)) {
    eval($catch);
    $_exception_stack = array();
  }
}

function throw($classname, $msg) {
  global $_exception_stack;

  if (!isset($_exception_stack))
   $_exception_stack = array();

  $exception = new $classname($msg);
  $_exception_stack[$classname] = $exception;
}

/* Not perfect at all because it lacks a caller id and clears the stack to often,
nevertheless have a look at the idea behind it. */

?>
