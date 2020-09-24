###############################################################################
##                                               DTT (c)2005 FSL - FreeSoftLand
## Title: Inverts a Table
##
## Date : 12/10/2005
## By   : unknown
###############################################################################

def invert(table):
    index = {}                # empty dictionary
    for key in table.keys():
        value = table[key]
        if not index.has_key(value):
            index[value] = [] # empty list
        index[value].append(key)
    return index
