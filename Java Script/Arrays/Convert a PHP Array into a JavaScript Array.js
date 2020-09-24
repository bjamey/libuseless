// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Convert a PHP Array into a JavaScript Array
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
  Converts a PHP array to a JavaScript array

  Takes a PHP array, and returns a string formated as a JavaScript
  array that exactly matches the PHP array.

  @param       array  $phpArray     The PHP array
  @param       string $jsArrayName  The name for the JavaScript array
  @return      string
-->
function get_javascript_array($phpArray, $jsArrayName, &$html = '')
{
       $html .= $jsArrayName . " = new Array(); \r\n ";
       foreach ($phpArray as $key => $value)
       {
               $outKey = (is_int($key)) ? '[' . $key . ']' : "['" . $key . "']";

               if (is_array($value)) {
                       get_javascript_array($value, $jsArrayName . $outKey, $html);
                       continue;
               }
               $html .= $jsArrayName . $outKey . " = ";
               if (is_string($value)) {
                       $html .= "'" . $value . "'; \r\n ";
               } else if ($value === false) {
                       $html .= "false; \r\n";
               } else if ($value === NULL) {
                       $html .= "null; \r\n";
               } else if ($value === true) {
                       $html .= "true; \r\n";
               } else {
                       $html .= $value . "; \r\n";
               }
       }

       return $html;
}
