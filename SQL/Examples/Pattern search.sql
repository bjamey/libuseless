' -----------------------------------------------------------------------------
'                                       DTT 1.2.0.4  (c)2008 FSL - FreeSoftLand
'  Title: Pattern search
' 
'  Date : 01/04/2008
'  By   : Juan Pedro
' -----------------------------------------------------------------------------

limited search criteria.
note can use NOT IN front OF LIKE:
note that LIKE IS CASE sensitive:

SELECT *  FROM  customers  WHERE NAME LIKE "David%"
OR
SELECT *  FROM  customers  WHERE NAME NOT LIKE "David%"


