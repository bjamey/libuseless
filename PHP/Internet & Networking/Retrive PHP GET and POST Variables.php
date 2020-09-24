<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Retrive PHP GET and POST Variables

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

$q = explode("&",$_SERVER["QUERY_STRING"]);
foreach ($q as $qi)
{
  if ($qi != "")
  {
    $qa = explode("=",$qi);
    list ($key, $val) = $qa;
    if ($val)
      $$key = urldecode($val);
  }
}

reset ($_POST);
while (list ($key, $val) = each ($_POST))
{
  if ($val)
    $$key = $val;
}

?>
