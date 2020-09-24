// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Set a word or phrase in an input field, clear it onfocus
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
 Set a word or phrase in an input field, clear it onfocus
-->

<!--
  ----------------
  JavaScript code
  ----------------
-->
<script language="Javascript" type="text/javascript">
function initPage() {
    if (document.getElementById) {
        var oInput = document.getElementById("my_input");

        oInput.onfocus = function() {
            if (this.value == this.defaultValue) {
                this.value = "";
            }
        }

        oInput.onblur = function() {
            if (this.value == "") {
                this.value = this.defaultValue;
            }
        }
    }
}

if (window.addEventListener) {
    window.addEventListener("load", initPage, false);
} else {
    window.attachEvent("onload", initPage);
}
</script>


<!--
  ----------
  HTML code
  ----------
-->
<input id="my_input" name="my_input" type="text" value="E-mail">
