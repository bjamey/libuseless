<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Converts a CSV file to a simple XML file

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/**
 * Converts a CSV file to a simple XML file
 *
 * @param string $file
 * @param string $container
 * @param string $rows
 * @return string
 */
function csv2xml($file, $container = 'data', $rows = 'row')
{
        $r = "<{$container}>\n";
        $row = 0;
        $cols = 0;
        $titles = array();

        $handle = @fopen($file, 'r');
        if (!$handle) return $handle;

        while (($data = fgetcsv($handle, 1000, ',')) !== FALSE)
        {
             if ($row > 0) $r .= "\t<{$rows}>\n";
             if (!$cols) $cols = count($data);
             for ($i = 0; $i < $cols; $i++)
             {
                  if ($row == 0)
                  {
                       $titles[$i] = $data[$i];
                       continue;
                  }

                  $r .= "\t\t<{$titles[$i]}>";
                  $r .= $data[$i];
                  $r .= "</{$titles[$i]}>\n";
             }
             if ($row > 0) $r .= "\t</{$rows}>\n";
             $row++;
        }
        fclose($handle);
        $r .= "</{$container}>";

        return $r;
}
?>
