// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Restrict input to alphanumeric and uppercase
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
Restrict input to alphanumeric and uppercase
-->

<!--
  ------------
  HTML Code :
  ------------
-->

<input type="text" onkeydown="f(this)" onkeyup="f(this)"
  onblur="f(this)" onclick="f(this)" />

<!--
  ------------------
  Javascript Code :
  ------------------
-->

<script language="javascript">
function f(o) {
        o.value = o.value.toUpperCase().replace(/([^0-9A-Z])/g,"");
}
</script>
