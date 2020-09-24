' -----------------------------------------------------------------------------
'                                       DTT 1.2.0.4  (c)2008 FSL - FreeSoftLand
'  Title: INTERSECT
' 
'  Date : 01/04/2008
'  By   : Juan Pedro
' -----------------------------------------------------------------------------

use OF INTERSECT -  returns ONLY the ROWS FOUND by BOTH queries
SELECT NAME  FROM customers INTERSECT  SELECT NAME FROM friends

