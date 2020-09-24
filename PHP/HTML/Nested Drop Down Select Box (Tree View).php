<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Nested Drop Down Select Box (Tree View)

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

 
/***************************************************************************************************
        class:          dropDownSelectBox
        author:         chris case - chrisc@brc2.com
        purpose:        select box which allows n levels of nesting.

        public functions:       dropDownSelectBox(nameOfSelectBox,formName,selectBoxDescription,pixelWidth)
                                                addItem(nestLevel,itemLabel,itemValue)
                                                get()
***************************************************************************************************/
class dropDownSelectBox {
        var $selectName;        // name of the select box
        var $items;             // array of items in the select box
        var $numItems;          // number of items in the select box
        var $formName;          // name of the form to submit
        var $description;       // default description
        var $pixelWidth;        // the width of the drop down box
        var $itemSelected;      // the option to be set by default

        /* default constructor */
        function dropDownSelectBox($selectName,$formName,$description,$pixelWidth,$itemSelected) {
                $this->selectName               =       $selectName;
                $this->items                    =       array();
                $this->defaultPadding   =       $defaultPadding;
                $this->description              =       $description;
                $this->formName                 =       $formName;
                $this->pixelWidth               =       $pixelWidth;
                $this->itemSelected             =       $itemSelected;

                $this->numItems =       0;      // initialization
        }
        /* add item to the dropdown box
         ** purpose: adds an item to the select box's container for later output */
        function addItem($nestLevel,$label,$value) {
                $itemInfo['label']              =       $label;
                $itemInfo['nestLevel']  =       $nestLevel;
                $itemInfo['value']              =       $value;
                $this->items[$this->numItems]   =       $itemInfo;
                $this->numItems++;
        }
        /* get the html/javaScript selectbox output
         ** purpose: outputs the contents of the select box's container */
        function get() {
                $retval .=
                "<select name='{$this->selectName}' style='margin-bottom:6px;font-size:10px;width:{$this->pixelWidth};'>" .
                "<option class='select_lvl_0' value=''>[{$this->description}]</option>";
END;
                for( $i = 0 ; $i < $this->numItems; $i++ ) {
                        $itemInfo       =       $this->items[$i];
                        $label          =       $itemInfo['label'];
                        $nestLvl        =       $itemInfo['nestLevel'];
                        $value          =       $itemInfo['value'];

                        if( $value == $this->itemSelected ) {
                                $attrib =       'selected';
                        }else{
                                $attrib =       '';
                        }

                        $retval .=      "<option $attrib " .
                                                        "onClick='document.{$this->formName}.submit();return false;' " .
                                                        "class='select_lvl_{$nestLvl}'" .
                                                        "value='$value'>" .
                                                        $label .
                                                "</option>\n";
                }
                $retval .= "</select>\n";
                return $retval;
        }
}
/* testcode
$ddsb   =       new dropDownSelectBox('name','formname','description',150);
$ddsb->addItem(0,'test1',1);
$ddsb->addItem(1,'test1-1',2);
$ddsb->addItem(2,'test2-1',4);
$ddsb->addItem(1,'test1-2',5);
$ddsb->addItem(0,'test2',3);
echo $ddsb->get();
/**/

?>
