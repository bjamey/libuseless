// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Simple Ajax Class
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!-- Simple Ajax Class -->

<html>
   <head>
     <script language="Javascript" type="text/javascript">
        function ajax()
        {
           //---------------------
           // Private Declarations
           //---------------------
           var _request = null;
           var _this = null;

           //--------------------
           // Public Declarations
           //--------------------
           this.GetResponseXML = function()
           {
              return (_request) ? _request.responseXML : null;
           }

           this.GetResponseText = function()
           {
              return (_request) ? _request.responseText : null;
           }

           this.GetRequestObject = function()
           {
              return _request;
           }

           this.InitializeRequest = function(Method, Uri)
           {
              _InitializeRequest();
              _this = this;

              switch (arguments.length)
              {
                 case 2:
                    _request.open(Method, Uri);
                    break;

                 case 3:
                    _request.open(Method, Uri, arguments[2]);
                    break;
              }

              if (arguments.length >= 4) _request.open(Method, Uri, arguments[2], arguments[3]);
              this.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
           }

           this.SetRequestHeader = function(Field, Value)
           {
              if (_request) _request.setRequestHeader(Field, Value);
           }

           this.Commit = function(Data)
           {
              if (_request) _request.send(Data);
           }

           this.Close = function()
           {
              if (_request) _request.abort();
           }

           //---------------------------
           // Public Event Declarations.
           //---------------------------
           this.OnUninitialize = function() { };
           this.OnLoading = function() { };
           this.OnLoaded = function() { };
           this.OnInteractive = function() { };
           this.OnSuccess = function() { };
           this.OnFailure = function() { };

           //---------------------------
           // Private Event Declarations
           //---------------------------
           function _OnUninitialize() { _this.OnUninitialize(); };
           function _OnLoading() { _this.OnLoading(); };
           function _OnLoaded() { _this.OnLoaded(); };
           function _OnInteractive() { _this.OnInteractive(); };
           function _OnSuccess() { _this.OnSuccess(); };
           function _OnFailure() { _this.OnFailure(); };

           //------------------
           // Private Functions
           //------------------
           function _InitializeRequest()
           {
              _request = _GetRequest();
              _request.onreadystatechange = _StateHandler;
           }

           function _StateHandler()
           {
              switch (_request.readyState)
              {
                 case 0:
                    window.setTimeout("void(0)", 100);
                    _OnUninitialize();
                    break;

                 case 1:
                    window.setTimeout("void(0)", 100);
                    _OnLoading();
                    break;

                 case 2:
                    window.setTimeout("void(0)", 100);
                    _OnLoaded();
                    break;

                 case 3:
                    window.setTimeout("void(0)", 100);
                    _OnInteractive();
                    break;

                 case 4:
                    if (_request.status == 200)
                       _OnSuccess();
                    else
                       _OnFailure();

                    return;
                    break;
              }
           }

           function _GetRequest()
           {
              var obj;

              try
              {
                 obj = new XMLHttpRequest();
              }
              catch (error)
              {
                 try
                 {
                    obj = new ActiveXObject("Microsoft.XMLHTTP");
                 }
                 catch (error)
                 {
                    return null;
                 }
              }

              return obj;
           }
        }
     </script>

     <script language="Javascript" type="text/javascript">
        someObject = function()
        {
           this.OnSuccess = function()
           {
              document.getElementById('TextDiv').innerHTML = this.GetResponseText();
           }

           this.GetData = function()
           {
              this.InitializeRequest('POST', 'someAJAX.php');
              this.Commit(null);
           }
        }
        someObject.prototype = new ajax();

        myObject = new someObject();
     </script>
   </head>

   <body>
      <div id="TextDiv">Text</div>
      <input type="button" value="Click Me" onclick="myObject.GetData();" />
   </body>
</html>
