' -----------------------------------------------------------------------------
'                                       DTT 1.2.0.4  (c)2008 FSL - FreeSoftLand
'  Title: Wildcard character
' 
'  Date : 01/04/2008
'  By   : Juan Pedro
' -----------------------------------------------------------------------------

underscore _  IS single-CHARACTER wildcard:

SELECT *  FROM  customers  WHERE state  LIKE "T_"
