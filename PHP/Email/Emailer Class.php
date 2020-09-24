<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Emailer Class

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

import mx.events.EventDispatcher;
import mx.utils.Delegate;

class Emailer {

        // required for EventDispatcher:
        public var addEventListener:Function;
        public var removeEventListener:Function;
        private var dispatchEvent:Function;

        // use to communicate with php script
        private var _lv:LoadVars;
        // holds address of sender
        private var _sentFrom:String;

        // constructor
        public function Emailer() {
                EventDispatcher.initialize(this);
                _lv = new LoadVars();
        }

        //
        private function dataReceived(dataxfer_ok:Boolean):Void {
                // if some problem with loadVars transfer, pass back error=2
                if (!dataxfer_ok) dispatchEvent({target:this, type:'mailSent', errorFlag:2});
                // otherwise pass back error code returned from script
                else dispatchEvent({target:this, type:'mailSent', errorFlag:Number(_lv["faultCode"])});
        }

         // Use loadvars object to send data (set to call dataReceived when script returns data)
        public function sendEmail(sub:String, fn:String, fe:String, msg:String, rep:String):Void {
                // if user already sent from this address, show error msg
                if (_sentFrom == fe) dataReceived(false);
                // otherwise set up and send
                else {
                        _sentFrom = fe;
                        // specify function to handle results, make scope = Emailer
                        _lv.onLoad = Delegate.create(this, dataReceived);
                        // set up properties of lv to items to be POSTed
                        _lv.subject = sub;
                        _lv.name = fn;
                        _lv.email = fe;
                        _lv.message = msg;
                        _lv.reply = rep;
                        // call script
                        _lv.sendAndLoad("sendemail.php", _lv, "POST");
                }
        }
}

?>
