// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Checks, unchecks or switch the values of the checkboxes in a form
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!-- ----------------------------------------------------------------
 CheckBoxes: Checks, unchecks or switch the values of the
             checkboxes in a form.

 Parameters:
    - f_form: String. Name of the Form <FORM...>
    - Start : Number: Checkbox to start with (0 to start from
              the first one
    - Length: Number: How many checkboxes after the Start
              you want to check, uncheck or switch
    - Method: Strign: c = Check, u = Uncheck, s = Switch

 Returns: None
---------------------------------------------------------------- -->
function CheckBoxes(f_form, Start, Length, Method)
{
        var s_type = ''

        Method = Method.toLowerCase()

        if (Start == 0) {Start = 0} else {Start = Start - 1}
        if (Length == 0) {Length = f_form.elements.length}

        for (var i = Start; i < Start + Length; i++)
        {
                s_type = f_form.elements[i]
                if (s_type.type == 'checkbox')
                {
                        if (Method == 'c')
                                s_type.checked = true
                        if (Method == 'u')
                                s_type.checked = false
                        if (Method == 's')
                                s_type.checked = !s_type.checked
                }
        }

        return
}
