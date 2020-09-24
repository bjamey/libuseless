// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Cookie Handler
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

function Cookie(name)
{
  this.name = name;
}

Cookie.prototype.set = function(value, expires, path, domain, secure)
{
  if( expires )
  {
    var date = new Date();
                date.setTime(date.getTime()+(expires*86400000));
                var expires = "; expires=" + date.toGMTString();
  }

  document.cookie = this.name + '=' + escape(value)
    + ( expires ? '; expires=' + expires : '' )
    + ( '; path=' + ( path ? path : '/' ) )
    + ( domain ? '; domain=' + domain : '' )
    + ( secure ? '; secure' : '' );
}

Cookie.prototype.get = function()
{
  if( !this.exists() ) return;

  var nameEQ = this.name + '=';
  var cookies = document.cookie.split(';');

  for( current in cookies )
  {
    var c = cookies[current].replace(/^\s+/, '');
    if( c.indexOf(nameEQ) == 0 ) return c.substr(nameEQ.length);
  }
}

Cookie.prototype.drop = function() { this.set('', 0); }

Cookie.prototype.exists = function()
{
  return ( document.cookie.indexOf(this.name + '=') != -1 );
}
