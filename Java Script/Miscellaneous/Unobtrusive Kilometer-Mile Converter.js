// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Unobtrusive Kilometer-Mile Converter
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Unobtrusive Kilometer/Mile Converter

function init ()
{
    if(!document.getElementById) return false;

    var kiloField = document.getElementById('kilos'),mileField = document.getElementById('miles');
    kiloField.onchange = function() {kilo2mile(this, mileField);};
}

<!--
   AddIfValid function lifted from
   http://help.lockergnome.com/lofiversion/index.php/t33046.html
   then extended to include isNaN
-->
function AddIfValid(field)
{
        if ((field.value.length == 0) || (field.value == null) || isNaN(field.value))
        {
            return 0;
        } else {
            return eval(field.value);
        }
}

function kilo2mile (kiloField, mileField)
{
    var tmpVal = 0;
    tmpVal = parseFloat((AddIfValid(kiloField) * 62.137) /100);
    mileField.value = tmpVal.toFixed(2);
}

window.onload = init;     
