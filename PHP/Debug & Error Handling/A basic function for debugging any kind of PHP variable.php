<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: A basic function for debugging any kind of PHP variable

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/**
 * Simple Debug Function
 *
 * @param mixed $var
 * @param boolean $visible
 * @param boolean $return
 * @return mixed
 */
function varDebug(&$var, $visible = true, $return = false)
{
        $containers = array(
                // $visible == false
                0 => array(
                        'head' => "\n<!--\n\nDEBUG:\n---------------------------------------\n\n",
                        'foot' => "\n\n---------------------------------------\n\n-->\n"
                ),

                // $visible == true
                1 => array(
                        'head' => '<hr /><h1>Debug</h1><p>',
                        'foot' => '</p><hr />'
                )
        );

        $r = var_export($var, true);
        if ($visible) $r = str_replace(array(' ', "\n"), array(' ', "<br />\n"), $r);

        $container = intval($visible);
        $r = $containers[$container]['head'] . $r . $containers[$container]['foot'];

        if ($return) return $r;
        echo $r;
}

/**
 * EXAMPLES:
 */

$a = array('h' => 1, 'e' => 2);

varDebug($a);

/*
OUTPUTS:
<hr /><h1>Debug</h1><p>array (<br />
  'h' => 1,<br />
  'e' => 2,<br />
)</p><hr />
*/

varDebug($a, false);

/*
OUTPUTS:
<!--

DEBUG:
---------------------------------------

array (
  'h' => 1,
  'e' => 2,
)

---------------------------------------

-->
*/

varDebug($a, false, true);

/*
OUTPUTS nothing
*/

?>
