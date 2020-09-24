<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Static Class variables

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
Static class-variables like in java are not known in PHP.
But static function-variables are.
So that's the trick.
*/

class example {
  function &static_classvar ( $setvar='' ) {
    static $classvar;
    if ( $setvar != '' ) {
      $classvar = $setvar;
    }
    return $classvar;
  }
}

/*
Calling this function without parameter just returns the value of $classvar.
When called with parameter the classvar is set to the new value and returns
it.
*/

// Examples:

example::static_classvar( "100" );
echo example::static_classvar();

$test_class = new example();
$other_test_class = new example();

echo $test_class->static_classvar();

$test_class->static_classvar( '5' );

echo $test_class->static_classvar();
echo $other_test_class->static_classvar();
echo example::static_classvar();

?>
