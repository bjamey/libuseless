// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Add or delete an item from a SELECT HTML object at runtime
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!-- ----------------------------------------------------------------
 ComboAdd: Add a new item to a SELECT HTML object at runtime.

 Parameters:
      Object = SELECT Object ID
      Value  = Value of the String ... <option VALUE="?????">....</option>
      String = String to add.

 Returns: None
---------------------------------------------------------------- -->
function ComboAdd(Object, Value, String)
{
        Value = Trim(Value)
        String = Trim(String)

        if (Value.length < 1 || String.length < 1)
                return false

        Object[Object.length] = new Option(String, Value);
        Object.selectedIndex = Object.length;
}

<!-- ----------------------------------------------------------------
 ComboDel: Delete the current/selected item from a SELECT
           HTML object at runtime.

 Parameters:
      Object = SELECT Object ID

 Returns: None
---------------------------------------------------------------- -->
function ComboDel(Object)
{
        var selected_index = Object.selectedIndex
        if (selected_index >= 0)
        {
                Object.options[Object.selectedIndex] = null;
                if (selected_index > 0)
                        Object.selectedIndex = selected_index
                else
                        Object.selectedIndex = 0;
        }
}
