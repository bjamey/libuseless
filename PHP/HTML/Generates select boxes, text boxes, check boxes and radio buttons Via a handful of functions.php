<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Generates select boxes, text boxes, check boxes and radio buttons· Via a handful of functions·

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */


/***************************************************************************************************
        class:          form_HTML
        author:         chris case - chrisc@brc2.com
        purpose:        provide a library of HTML form elements and acts as a container for the elements.

        public functions:
                                                addSelect               (name)
                                                addSelect_item  (id,value,description)
                                                addTextBox              (name,value)
                                                addCheckBox             (name,value,description)
                                                addRadioButton  (name,value,description)
***************************************************************************************************/
class form_HTML {
        var $method;
        var $action;
        var $name;
        var $class;

        var $elements;
        var $getStatus;

        /* default constructor
         ** purpose: sets the globals */
        function form_HTML($method,$action,$name,$class) {
                $this->method           =       $method;
                $this->action           =       $action;
                $this->name                     =       $name;
                $this->class            =       $class;
                $elements                       =       array();
                $this->getStatus        =       0;
        }
        /* add new element
         ** purpose: adds an entity to the container */
        function addElement( $element ) {
                $element['id']                          =       $this->nextElementID();
                $location                                       =       $element['id'];
                $this->elements[$location]      =       $element;

                return $element['id'];
        }
        /* update element
         ** purpose: updates an existing form element */
        function updateElement( $updatedElement ) {
                $id     =       $updatedElement['id'];
                $this->elements[$id]    =       $updatedElement;
        }
        function nextElementID()        {       return count( $this->elements );        }
        function getElement($id)        {       return $this->elements[$id];            }
        function numElements()          {       return count( $this->elements );        }
        /* get the next element
         ** purpose: each time this is called it gets the next element until the end is reached */
        function getNext() {
                if( $this->getStatus == $this->numElements() ) {        // is this the end of the elements?
                        $this->getStatus        =       0;                                              // reset the sentinal                        return false;                                                                   // indicate ending
                }
                $element        =       $this->getElement( $this->getStatus );
                $this->getStatus++;
                return $element;
        }
        /* add a select box entity to the form
         ** purpose: adds a select box to the container */
        function addSelect($name,$description) {
                $element['type']                        =       'select';
                $element['name']                        =       $name;
                $element['selections']          =       array();
                $element['description']         =       $description;
                $element['beginCode']           =       "<select name='{$element['name']}'>";
                $element['endCode']                     =       "</select>";

                return $this->addElement($element);
        }
        /* add item to a select box instance
         ** purpose: adds an option to a select box entity */
        function addSelect_item($id,$val,$description) {
                // get the element from the array of elements
                $element        =       $this->getElement($id);
                if( $element['type']    != 'select' ) {
                        return false;
                }
                $selections     =       $element['selections'];
                $location       =       count( $selections );
                $selections[$location]['value']                 =       $val;
                $selections[$location]['description']   =       $description;
                $selections[$location]['code']  =
                        "\t\t<option value='{$selections[$location]['value']}'>{$selections[$location]['description']}</option>\n";
                $element['selections']  =       $selections;

                $this->updateElement($element);
        }
        function getSelectItems( $element ) {
                if( $element['type'] != 'select' ) { return false; }
                $selections     =       $element['selections'];
                for( $i = 0; $i < count( $selections ); $i++ ) {
                        $outp   .=      $selections[$i]['code'];
                }
                return $outp;
        }
        /* add a text box
         ** purpose: adds a text box to the container */
        function addTextBox($name,$value,$description) {
                $element['type']                =       'text';
                $element['name']                =       $name;
                $element['value']               =       $value;
                $element['description'] =       $description;
                $element['code']                =       "<input type='text' name='{$element['name']}' value='{$element['value']}'>";

                return $this->addElement($element);
        }
        /* add a check box
         ** purpose: adds a check box to the container */
        function addCheckBox($name,$value,$description) {
                $element['type']                =       'checkbox';
                $element['name']                =       $name;
                $element['value']               =       $value;
                $element['description'] =       $description;
                $element['code']                =       "<input type='checkbox' name='{$element['name']}' value='{$element['value']}'>";

                return $this->addElement($element);
        }
        /* add a radio button
         ** purpose: adds a radio button to the container */
        function addRadioButton($name,$value,$description) {
                $element['type']                =       'radio';
                $element['name']                =       $name;
                $element['value']               =       $value;
                $element['description'] =       $description;
                $element['code']                =       "<input type='radio' value='{$element['value']}' " .
                                                                                "name='{$element['name']}'>";

                return $this->addElement($element);
        }
        /* add a textarea
         ** purpose: adds a textarea to the container */
        function addTextArea($name,$value,$description) {
                $element['type']                =       'textarea';
                $element['name']                =       $name;
                $element['value']               =       $value;
                $element['description'] =       $description;
                $element['code']                =       "<textarea name='{$element['name']}'>{$element['value']}</textarea>";
                return $this->addElement($element);
        }
        /* add a submit button
         ** purpose: add a submit button to the container */
        function addSubmitButton($name,$value) {
                $element['type']        =       'submit';
                $element['name']        =       $name;
                $element['value']       =       $value;
                $element['code']        =       "<input class='submit' type='submit' name='{$element['name']}' value='{$element['value']}'>";

                return $this->addElement($element);
        }
        /* add a hidden field
         ** purpose: add a hidden field to the container */
        function addHiddenField($name,$value) {
                $element['type']                =       'hidden';
                $element['name']                =       $name;
                $element['value']               =       $value;
                $element['code']                =       "<input type='hidden' name='{$element['name']}' value='{$element['value']}'>";

                return $this->addElement($element);
        }
        /* get HTML output as a table
         ** purpose: returns the HTML data from the container with the descriptions on the left
                                 and the form elements on the right */
        function getTableOfElements_1() {
                $outp .= "<form method='{$this->method}' action='{$this->action}' name='{$this->name}'>\n";
                $outp .= "<table class='{$this->class}' cellspacing=0>\n";
                $element        =       $this->getNext();
                while( $element ) {
                        $outp .= "\t";
                        switch($element['type'])
                        {
                                case 'select':
                                        $selectItems    =       $this->getSelectItems( $element );
                                        $outp .=
                                        "<tr>" .
                                        "\n\t<td class='description'>{$element['description']}</td>\n" .
                                        "\t<td>\n" .
                                        "\t" . $element['beginCode'] . "\n" .
                                        $selectItems .
                                        "\t" . $element['endCode'] . "\n" .
                                        "\t</td>\n\t</tr>";
                                        break;
                                case 'text':
                                        $outp .= "<tr><td class='description'>{$element['description']}</td><td style='text-align:left;' class='formElement'>{$element['code']}</td></tr>";
                                        break;
                                case 'checkbox':
                                        $outp .= "<tr><td class='description'>{$element['description']}</td><td style='text-align:left;' class='formElement'>{$element['code']}</td></tr>";
                                        break;
                                case 'radio':
                                        $outp .= "<tr><td class='description'>{$element['description']}</td><td style='text-align:left;' class='formElement'>{$element['code']}</td></tr>";
                                        break;
                                case 'textarea':
                                        $outp .= "<tr><td class='description'>{$element['description']}</td><td style='text-align:left;' class='formElement'>{$element['code']}</td></tr>";
                                        break;
                                case 'submit':
                                        $outp .= "<tr><td>&nbsp;</td><td class='formElement' style='text-align:left;'>{$element['code']}</td></tr>";
                                        break;
                                case 'hidden':
                                        $outp .= $element['code'];
                        }
                        $outp .= "\n";
                        $element        =       $this->getNext();
                }
                $outp .= "</table>\n";
                $outp .= "</form>\n";
                return $outp;
        }
        /* get HTML output as a table
         ** purpose: returns the HTML data from the container with the descriptions on the right
                                 and the form elements on the left */
        function getTableOfElements_2() {
                $outp .= "<form method='{$this->method}' action='{$this->action}' name='{$this->name}' class='{$this->class}'>\n";
                $outp .= "<table>\n";
                $element        =       $this->getNext();
                while( $element ) {
                        $outp .= "\t";
                        switch($element['type'])
                        {
                                case 'select':
                                        $selectItems    =       $this->getSelectItems( $element );
                                        $outp .=
                                        "<tr>\n" .
                                        "\t<td class='formElement'>\n" .
                                        "\t" . $element['beginCode'] . "\n" .
                                        $selectItems .
                                        "\t" . $element['endCode'] . "\n" .
                                        "\t</td>\n" .
                                        "\t<td>{$element['description']}</td>\n" .
                                        "\t</tr>";
                                        break;
                                case 'text':
                                        $outp .= "<tr><td class='formElement'>{$element['code']}</td><td class='description'>{$element['description']}</td></tr>";
                                        break;
                                case 'checkbox':
                                        $outp .= "<tr><td class='formElement'>{$element['code']}</td><td class='description'>{$element['description']}</td></tr>";
                                        break;
                                case 'radio':
                                        $outp .= "<tr><td class='formElement'>{$element['code']}</td><td class='description'>{$element['description']}</td></tr>";
                                        break;
                                case 'textarea':
                                        $outp .= "<tr><td class='formElement'>{$element['code']}</td><td class='description'>{$element['description']}</td></tr>";
                                        break;
                                case 'submit':
                                        $outp .= "<tr><td class='formElement'>{$element['code']}</td><td>&nbsp;</td></tr>";
                                        break;
                        }
                        $outp .= "\n";
                        $element        =       $this->getNext();
                }
                $outp .= "</table>\n";
                $outp .= "</form>\n";
                return $outp;
        }
}

/** test code
$form           =       new form_HTML('post','index.php','mainBody','formClass');
$selectId       =       $form->addSelect('select test','description of the select box');
$form->addSelect_item($selectId,'item1val','item1description');
$form->addSelect_item($selectId,'item2val','item2description');
$form->addTextBox('text_test','text_value_test','description of the text box');
$form->addCheckBox('cb_name','cb_value','cb_description');
$form->addRadioButton('rb_name','rb_value','rb_description');
$form->addTextArea('ta_name','ta_value','description of the textarea');
echo $form->getTableOfElements_1();
echo $form->getTableOfElements_2();
/**/

?>
