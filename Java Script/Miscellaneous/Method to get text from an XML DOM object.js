// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Method to get text from an XML DOM object
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Method to get text from an XML DOM object
function getTextFromXML( oNode, deep )
{
    var s = "";
    var nodes = oNode.childNodes;

    for (var i = 0; i < nodes.length; i++) {
        var node = nodes[i];

        if (node.nodeType == Node.TEXT_NODE) {
            s += node.data;
        } else if (deep == true && (node.nodeType == Node.ELEMENT_NODE || node.nodeType == Node.DOCUMENT_NODE
                                       || node.nodeType == Node.DOCUMENT_FRAGMENT_NODE)) {
            s += getTextFromXML(node, true);
        };
    }

    ;
    return s;
}                           
