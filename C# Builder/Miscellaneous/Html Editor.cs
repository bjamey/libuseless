// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: HTML Editor
//
// Date : unknown
// By   : Tim Anderson      
// ----------------------------------------------------------------------------

using System;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Forms;
using mshtml;
using System.ComponentModel;
using System.Drawing;

namespace onlyconnect
{
    /// Example submitted by Tim Anderson
    /// <summary>
    /// Implements MSHTML as active document in a control
    /// With thanks to Lutz Roeder
    /// 
    /// also thanks to Steven Wood for the HTML Event handling idea
    /// and code.
    /// 
    /// and thanks to Christopher Slee for the region marking
    ///
    ///
    /// Basic Reference:
    /// Activating the MSHTML Editor  Internet Development Index 
    /// --------------------------------------------------------------------------------
    /// This topic describes how to activate the MSHTML Editor from 
    /// Microsoft Visual C++®, Microsoft Visual Basic®, Microsoft JScript®, and Visual Basic Scripting Edition (VBScript). 
    /// The Editor provides a rich set of capabilities and serves as a fine 
    /// "what you see is what you get" (WYSIWYG) HTML editing environment. 
    /// In addition, the Editor includes the ability to customize its behavior. 
    /// For more information, see Related Topics at the end of this topic.


    public class HtmlEditor : Control, IPropertyNotifySink
    {
        private UCOMIConnectionPoint icp;
        private int cookie = -1;
        private string mReadyState = string.Empty;
        private bool bLoadDocumentWhenReady = false;
        private int iLoadAttempts = 0;
        private EncodingType mDocumentEncoding = EncodingType.WindowsCurrent;
        private bool mIsWin98 = false; 
        private bool mAlwaysLoadAnsi = false;

        HtmlSite site;
        String url = String.Empty;
        String sDocument = String.Empty;
        internal bool mDesignMode = false;
        private bool mIsContextMenuEnabled = true;
        internal bool mAllowActivation = true;
        internal  HTMLDocument m_htmldoc = null;
        internal IHTMLElement mcurrentElement = null;
        private IntPtr mDocumentHandle = IntPtr.Zero;
        private bool mCreating = true;

        private NativeWindow mNativeWindow = null;
        private HandleWndProc mNativeDocWindow = null;

        internal bool mEnableActiveContent = true;

        public HtmlEditor() : base()
        {
            //Detect Windows version
            mIsWin98 = (System.Environment.OSVersion.Platform == PlatformID.Win32Windows);
                            
            //force creation of handle, needed to host mshtml
            this.CreateControl();

            //see OnHandleCreated for purpose of mCreating
            mCreating = false;
        
        }

        Boolean IsCreated
        {
            get 
            { 
                return (site != null) && (site.Document != null); 
            }
        }


        public override Boolean PreProcessMessage(ref Message message)
        {
            return false; //handle elsewhere for the moment
            
        }

        internal void setupWndProc()
        {

            if (this.mNativeDocWindow != null)
            {
                this.mNativeDocWindow.ReleaseHandle();
            }

            this.mNativeDocWindow = new HandleWndProc();
            this.mNativeDocWindow.theform = this;
            this.mNativeDocWindow.AssignHandle(this.site.DocumentHandle);
        }

        internal void releaseWndProc()
        {
            if (this.mNativeDocWindow != null)
            {
                this.mNativeDocWindow.ReleaseHandle();
                this.mNativeDocWindow = null;
            }
        }


        internal void InvokeOnKeyDown(KeyEventArgs e)
        {
            this.OnKeyDown(e);
        }

        #region Override WndProc ===============
        override protected void WndProc(ref Message m)
        {
        
            if ((m.Msg == ComSupport.WM_MOUSEACTIVATE) && (site != null))
            {
    
                if (this.DesignMode) 
                {
                    return;
                }
            
                
                IntPtr fromHandle = ComSupport.GetFocus();

                this.mDocumentHandle  = site.DocumentHandle;

                if ((! this.Focused) & (fromHandle != this.Handle) & (fromHandle != this.mDocumentHandle) )
                {
                    ComSupport.SendMessage(this.Handle,ComSupport.WM_SETFOCUS,(int)fromHandle,0);
                }

            }

            if (m.Msg == ComSupport.WM_DESTROY) 
            {
                //? clean up the control here 

            }

            base.WndProc(ref m);

        }

        #endregion Override WndProc ===============


        protected override void OnHandleCreated(EventArgs e)
        {
            //earlier versions of HtmlEditor always init mshtml
            //here. However, according to BoundsChecker that 
            //causes a memory overrun. It also means that the 
            //document is passed a rect with zero bounds, as 
            //the control has not yet been sized.
            
            //Therefore, mshtml is now initialized for the first
            //time in OnParentChanged. In most cases, that will
            //be when the designer-generated code adds the control
            //to the form's controls collection.

            if (! mCreating)
            {
                initMshtml();
            }
        }

        protected override void OnHandleDestroyed(EventArgs e)
        {
            CleanupControl();
            base.OnHandleDestroyed(e);
        }

        public void ReloadMshtml()
        {
            CleanupControl();
            initMshtml();
        }

        public void CleanupControl()
        {
            if (IsCreated)
            {
                if (cookie != -1)
                {
                    icp.Unadvise(cookie);
                    cookie = -1;
                }

                site.CloseDocument();
                site.Dispose();
                site = null;
                this.m_htmldoc = null;

            }
        }

        void initMshtml()
        {

            //don't create in design mode
            if (this.DesignMode)
            {
                return;
            }

            if (this.IsCreated)
            {
                return; //can't create if already created
            }

            // force creating Host handle since we need it to parent MSHTML
            if (! this.IsHandleCreated)
            {
                IntPtr hostHandle = Handle;
            }

            //get the NativeWindow so we hold onto the handle
            //this.mNativeWindow = NativeWindow.FromHandle(Handle);

            site = new HtmlSite(this);
            site.CreateDocument();
            site.ActivateDocument();
            this.m_htmldoc = (HTMLDocument) site.Document;
    
            if (this.mDesignMode)
            {
                this.m_htmldoc.designMode = "On";
            }

            SetDocEvents();

            if (url != String.Empty) 
            {
                LoadUrl(url);
            }
            else
            {
                //always initialize with at least the blank url
                LoadUrl("About:Blank");
            }

            if (sDocument != String.Empty) 
            {
                LoadDocument(sDocument);
            }
            else
            {
                if (this.mDesignMode)
                {
                    LoadDocument("<html></html>");
                }
            }

            
        }


        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        protected override void Dispose( bool disposing )
        {
            if( disposing )
            {

                if (cookie != -1)
                {
                    icp.Unadvise(cookie);
                    cookie = -1;
                }

                IntPtr ptr = Marshal.GetIDispatchForObject(this);
                int i = Marshal.Release(ptr);
                while (i > 0)
                {
                    i = Marshal.Release(ptr);
                }

                if (this.site != null)
                {
                    this.site.Dispose();
                }

                if (this.mNativeWindow != null)
                {
                    this.mNativeWindow.ReleaseHandle();
                }

            }
            base.Dispose( disposing );
        }



        #region Declare Events ====================================================

        //declare the events
        public event HtmlNavigateEventHandler Navigate;
        public event ReadyStateChangedHandler ReadyStateChanged;
        public event UpdateUIHandler UpdateUI;
        public event HtmlKeyPressHandler HtmlKeyPress; 
        public event HtmlEventHandler HtmlEvent;
        #endregion Declare Events ===========

        #region Invoke Events =========================================================
        //invoke the UpdateUI event
        public void InvokeUpdateUI(mshtml.IHTMLElement ae)
        {
            if (UpdateUI != null)
            {
                HtmlUpdateUIEventArgs ea = new HtmlUpdateUIEventArgs();
                ea.currentElement = ae;
                UpdateUI(this, ea);
            }
        }

        //invoke the ReadyStateChanged event
        public void InvokeReadyStateChanged(String newReadyState)
        {
            if (ReadyStateChanged != null)
            {
                ReadyStateChangedEventArgs ea = new ReadyStateChangedEventArgs(newReadyState);
                ReadyStateChanged(this, ea);
            }
        }
          
        public void InvokeHtmlKeyPress(ref mshtml.IHTMLEventObj eobj)
        {
            if (HtmlKeyPress != null)
            {
                HtmlKeyPressEventArgs ea = new HtmlKeyPressEventArgs(ref eobj);
                HtmlKeyPress(this, ea);
            }
        }

        [DispId(0)]
        public void InvokeHtmlEvent()
        {
            if (HtmlEvent != null)
            {
                // Get the event.
                mshtml.IHTMLEventObj pobjEvent = ((mshtml.IHTMLDocument2)
                    m_htmldoc).parentWindow.@event;
                HtmlEventArgs ea = new HtmlEventArgs(pobjEvent);
                HtmlEvent(this, ea);
            }
            return;
        }
        
        public void InvokeNavigate(String target)
        {
            
            if (Navigate != null) Navigate(this, new HtmlNavigateEventArgs(target));
        }

        #endregion Invoke Events ===============

        #region Setup Event Management ======================================================


        void ReadyStateChangeActions()
        {
            
            //defensive - I've known this to be called
            //after doc was deactivated
            if (this.m_htmldoc == null) return;

            mReadyState = this.m_htmldoc.readyState;
    
            if (mReadyState == "complete")
            {
                //if changed to "COMPLETE", set edit designer
                
                if (this.bLoadDocumentWhenReady)
                {
                    this.LoadDocument(string.Empty);
                }
                else
                {
                    if (this.IsDesignMode)
                    {
                        this.SetEditDesigner();
                    }
                }

                //set HTMLEvents
                this.SetHTMLEvents();
            }
            
            //invoke ready state changed event
            this.InvokeReadyStateChanged(mReadyState);
            
        }



        public void SetEditDesigner()
        {
            this.m_htmldoc.designMode = "On";
            onlyconnect.IServiceProvider isp = (onlyconnect.IServiceProvider)m_htmldoc;
            onlyconnect.IHTMLEditServices es;
            System.Guid IHtmlEditServicesGuid = new System.Guid("3050f663-98b5-11cf-bb82-00aa00bdce0b");
            System.Guid SHtmlEditServicesGuid = new System.Guid(0x3050f7f9,0x98b5,0x11cf,0xbb,0x82,0x00,0xaa,0x00,0xbd,0xce,0x0b);
            IntPtr ppv;
            onlyconnect.IHTMLEditDesigner ds = (onlyconnect.IHTMLEditDesigner)site;
            if (isp != null)
            {
                isp.QueryService(ref SHtmlEditServicesGuid,ref IHtmlEditServicesGuid,out ppv);
                es = (onlyconnect.IHTMLEditServices)Marshal.GetObjectForIUnknown(ppv);
                int retval = es.AddDesigner(ds); 
                Marshal.Release(ppv);
            }
        }

        void SetDocEvents()
        {
            this.SetPropertyNotifyEvent();
    
        }

        void SetPropertyNotifyEvent()
        {
    
            if (m_htmldoc != null)
            {
                //get the connection point container
                UCOMIConnectionPointContainer icpc = (UCOMIConnectionPointContainer)m_htmldoc;

                //find the source interface
                //get IPropertyNotifySink interface
                Guid g = new Guid("9BFBBC02-EFF1-101A-84ED-00AA00341D07");

                icpc.FindConnectionPoint(ref g,out icp);

                //pass a pointer to the host to the connection point
                icp.Advise(this,out cookie);
                        
            }
        }


        void SetHTMLEvents()
        {
            if ((m_htmldoc != null) && (HtmlEvent != null))
            {
                //m_htmldoc.onkeydown = this; 
                //keydown does not work, kepress does...
                m_htmldoc.onkeypress = this;
                m_htmldoc.onclick = this;
                m_htmldoc.onfocusin = this;
                m_htmldoc.onfocusout = this;
                m_htmldoc.onselectionchange = this;
            }
        }
        #endregion Setup Event Management ================

        [Browsable(false)]
        public mshtml.IHTMLElement CurrentElement
        {
            get
            {
                return mcurrentElement;
            }
        }

        public EncodingType DocumentEncoding
        {
            get {return mDocumentEncoding;}
            set {mDocumentEncoding = value;}
        }

        public Boolean IsAnsiStreamAlwaysUsed
        {
            get
            {
                return this.mAlwaysLoadAnsi;
            }
            set
            {
                this.mAlwaysLoadAnsi = value;
            }
        }

        public Boolean IsDesignMode
        {
            get {return mDesignMode;}
            set 
            {
                if (value)
                {
                    mDesignMode = true;
                    if (this.m_htmldoc != null) 
                    {
                        
                        this.m_htmldoc.designMode = "On";
                        this.LoadDocument("<html></html>");
                    
                    }
                }
                else
                {
                    mDesignMode = false;
                    if (this.m_htmldoc != null) 
                    {
                        
                        this.m_htmldoc.designMode = "Off";
                        
                    }

                }
            }
        }

        public bool IsContextMenuEnabled
        {
            get 
            {
                return mIsContextMenuEnabled;
            }
            set
            {
                mIsContextMenuEnabled = value;
            }
        }

        public bool IsActivationEnabled
        {
            get 
            {
                return mAllowActivation;
            }
            set
            {
                mAllowActivation = value;
            }
        }


        public bool isActiveContentEnabled
        {
        //This must be set BEFORE the document is created

            get
            {
                return mEnableActiveContent ;
            }
        
            set
            {
                mEnableActiveContent = value;
            }
        }

            [Browsable(false)]
            public HTMLDocument Document
        {
            get
            {
                if (site == null)
                {
                    return null;
                }

                if (site.Document != null) 
                {
                    return (HTMLDocument)site.Document;
                }
                else
                {
                    return null;
                }
            }
        }

        public void setStyleSheet(string sFileName)
        {
            if (this.m_htmldoc == null)
            {
                return;
            }
    
            if (this.m_htmldoc.readyState.ToLower() == "complete")
            {
                m_htmldoc.createStyleSheet(sFileName,0);
            }

        }
    

        public void LoadDocument(String documentVal)
        {
            if ((documentVal != string.Empty) | (! this.bLoadDocumentWhenReady))
            {
                //if doc is waiting to load, it is already in string variable
                sDocument = documentVal;
                this.bLoadDocumentWhenReady = false;
            }
            else
            {
                this.bLoadDocumentWhenReady = false;
                this.iLoadAttempts += 1;
            }

            if (!IsCreated)
            {
                throw new HtmlEditorException("Document not created");
            }

            if ( (this.m_htmldoc.readyState.ToLower() != "complete") & (this.m_htmldoc.readyState.ToLower() != "interactive"))
                //try to load on interactive as well as complete
            
            {
                if (iLoadAttempts < 2)
                {
                    this.bLoadDocumentWhenReady = true;
                    return;
                }
                else
                {
                    throw new HtmlEditorException("Document not ready");
                }
            }


            if ((sDocument == null) || (sDocument == String.Empty)) 
            {
                sDocument = "<html><body></body></html>"; 
            }
    
            UCOMIStream stream = null;

            if (this.mIsWin98 | this.mAlwaysLoadAnsi) 
            {
                ComSupport.CreateStreamOnHGlobal(Marshal.StringToHGlobalAnsi(sDocument), 1, out
                    stream);
            }
            else
            {
                ComSupport.CreateStreamOnHGlobal(Marshal.StringToHGlobalUni(sDocument), 1, out
                    stream);        
            }
            
            
            if (stream == null) 
            {
                throw new HtmlEditorException("Could not allocate document stream");
            }

            if (this.mIsWin98)
            {
                //This code fixes a problem in Win98 - Framework bug? - where the string 
                //is sometimes incorrectly terminated
                //It assumes an ANSI string

                ulong thesize = 0;
                IntPtr ptr = IntPtr.Zero;
    
                int iSizeOfIntPtr = Marshal.SizeOf(typeof(Int64));
                ptr = Marshal.AllocHGlobal(iSizeOfIntPtr);

                if (ptr == IntPtr.Zero )
                {
                    throw new HtmlEditorException("Could not load document");
                }
    
                //seek to end of stream
                stream.Seek(0,2,ptr );
                //read the size
                thesize = (ulong)Marshal.ReadInt64(ptr);
                //free the pointer
                Marshal.FreeHGlobal(ptr);
        
                //2nd param, 0 is beginning, 1 is current, 2 is end
   
                if (thesize != (ulong)sDocument.Length + 1)
                {
                    //fix the size by truncating the stream
                    Debug.Assert(true,"Size of stream is unexpected","The size of the stream is not equal to the length of the string passed to it.");
                    stream.SetSize((sDocument.Length) +1);
                }

            }

            //set stream to start
            stream.Seek(0,0,IntPtr.Zero);

            IPersistStreamInit persistentStreamInit = (IPersistStreamInit)
                this.m_htmldoc;
            if (persistentStreamInit != null)
            {
                int iRetVal = 0;
                iRetVal = persistentStreamInit.InitNew();
                if (iRetVal == HRESULT.S_OK)
                {
                    //this is a fix for exception raised in UpdateUI
                    site.mFullyActive = false;

                    iRetVal = persistentStreamInit.Load(stream);
    
                    if (iRetVal != HRESULT.S_OK)
                    {
                        throw new HtmlEditorException("Could not load document");
                    }
                }
                else
                {
                    throw new HtmlEditorException("Could not load document");
                }
                persistentStreamInit = null;
            }
            else
            {
                throw new HtmlEditorException("Could not load document");
            }

            stream = null;
            this.iLoadAttempts = 0;
    
        }
        

        public void LoadUrl(String url)
        {
            this.url = url;
            
            if (!IsCreated) return;

            //this is a workaround for a problem calling Caret.SetLocation before it
            //is ready, in UpdateUI
            site.mFullyActive = false;

            utils.LoadUrl(ref this.m_htmldoc,url);

        }

        protected override void OnParentChanged( System.EventArgs e)
        {
            if (site == null)
            {
                initMshtml();
            }

            base.OnParentChanged(e);
        }

        protected override void OnPaint(PaintEventArgs pevent)
        {
            if (this.DesignMode)
            {
                pevent.Graphics.FillRectangle(System.Drawing.Brushes.White ,this.ClientRectangle);
            }
            
            base.OnPaint(pevent);
        }

        public String GetDocumentSource()
        {
            if (!IsCreated) return null;

            HTMLDocument  thedoc = this.Document;

            if (thedoc == null) return null;

            return utils.GetDocumentSource(ref thedoc,this.mDocumentEncoding);
            
        }
        
    
        #region Basic functions -- print etc. =======================================
        public void print(bool bPreview)
        {
            this.print(bPreview,string.Empty,true);

        }

        public void print(bool bPreview, String sTemplatePath)
        {
            this.print(bPreview,string.Empty,true);

        }

        public void print(bool bPreview,String sTemplatePath,bool bPromptUser)
        {
            if (this.m_htmldoc == null)
            {
                throw new HtmlEditorException("Nothing to print");
    
            }
                
    
            if (this.m_htmldoc.readyState.ToLower() != "complete")
            {
                throw new HtmlEditorException("Cannot print when document is loading");
            }

            //get the command target
            IOleCommandTarget ct = (IOleCommandTarget)this.m_htmldoc;

            if (ct == null)
            {
                throw new HtmlEditorException("Error printing document");
            }


            //print the document
            System.Guid pguidCmdGroup = new Guid("DE4BA900-59CA-11CF-9592-444553540000");
            
            Object pvaIn;

            if (sTemplatePath == string.Empty)
            {
                pvaIn = null;
            }
            else if (! File.Exists(sTemplatePath))
            {
                pvaIn = null;
            }
            else
            {
                pvaIn = sTemplatePath;
            }

            Object pvaOut = null;
            int iRetval;

            uint iPromptUser;
            
            if (bPromptUser)
            {
                iPromptUser = (int)OLECMDEXECOPT.OLECMDEXECOPT_PROMPTUSER;
            }
            else
            {
                iPromptUser = (int)OLECMDEXECOPT.OLECMDEXECOPT_DONTPROMPTUSER;
            }
                        
            if (bPreview)
            {
                iRetval = ct.Exec(ref pguidCmdGroup,ComSupport.IDM_PRINTPREVIEW,iPromptUser,ref pvaIn,ref pvaOut);
        
            }
            else
            {
                iRetval = ct.Exec(ref pguidCmdGroup,ComSupport.IDM_PRINT,iPromptUser,ref pvaIn,ref pvaOut);
            }

        }

        #endregion Basic functions ==========================




        #region IPropertyNotifySink -- notifications of property changes =====================

        //implementation of IPropertyNotifySink -- notifications of property changes
        /*
             * The IPropertyNotifySink interface is implemented 
             * by a sink object 
             * to receive notifications about property changes 
             * from an object that supports IPropertyNotifySink as an "outgoing" interface. 
             * */

        public int OnChanged(int iDispID)
        {
    
            if (iDispID == ComSupport.DISPID_READYSTATE)
            {
                this.ReadyStateChangeActions ();
            }

            if (iDispID == ComSupport.DISPID_UNKNOWN)
                //true if more than one property has changed
            {
        
                if (this.m_htmldoc.readyState != this.mReadyState)
                {
                    this.ReadyStateChangeActions ();
                }

            
            }
            return HRESULT.S_OK; 
        }

        public int OnRequestEdit(int iDispID)
        {
            return HRESULT.S_OK; //indicates change is allowed
        }

        #endregion IPropertyNotifySink ===============


    }

    class HandleWndProc: NativeWindow
    {
        internal HtmlEditor theform;

        protected override void WndProc(ref Message message)
        {
            if (message.Msg == ComSupport.WM_KEYDOWN)
            {
                Keys k;
                
                k = (Keys)message.WParam.ToInt32();

                if (ComSupport.GetKeyState((int)Keys.ControlKey) < 0)
                    k = k | Keys.Control;

                if (ComSupport.GetKeyState((int)Keys.Alt) < 0)
                    k = k | Keys.Alt;

                if (ComSupport.GetKeyState((int)Keys.ShiftKey) < 0)
                    k = k | Keys.Shift;

                theform.InvokeOnKeyDown(new KeyEventArgs(k));
            }

            base.WndProc(ref message);
        }
    }

    public enum EncodingType
    {
        UTF7,
        UTF8,
        Unicode,
        ASCII,
        WindowsCurrent
    }
}
