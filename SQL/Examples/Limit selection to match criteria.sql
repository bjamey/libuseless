' -----------------------------------------------------------------------------
'                                       DTT 1.2.0.4  (c)2008 FSL - FreeSoftLand
'  Title: Limit selection to match criteria
' 
'  Date : 01/04/2008
'  By   : Juan Pedro
' -----------------------------------------------------------------------------

limit selection TO MATCH criteria:
note that while SQL IS NOT CASE senstive, DATA IS:
SELECT  *   FROM bikes  WHERE  NAME = "Beene"
