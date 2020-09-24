// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: HTML Site
//
// Date : unknown
// By   : unknown      
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
    /// <summary>
    /// Implements the site on which mshtml is hosted
    /// </summary>
    public class HtmlSite: IDisposable, IOleClientSite, IOleContainer, IDocHostUIHandler,
        IOleInPlaceFrame, IOleInPlaceSite, IOleInPlaceSiteEx, IOleDocumentSite, IAdviseSink,
        IHTMLEditDesigner, IServiceProvider, IOleInPlaceUIWindow, IDocHostShowUI
    {
        HtmlEditor container;
        IOleObject m_document;
        IOleDocumentView view;
        IOleInPlaceActiveObject activeObject;
        int iAdviseCookie = 0;
        IntPtr m_docHwnd = IntPtr.Zero;
        internal bool mFullyActive = false;

        ~HtmlSite()
        {
            Dispose();
        }

        public void Dispose()
        {
            //doc should already be closed, this
            //is defensive
            this.CloseDocument();
        }


        [DispId(-5512)]
        public int setFlags()
        {
            //This determines which features are enabled in the editor

            if (this.container.mEnableActiveContent)
            {
                return (int) ComSupport.DLCTL_DLIMAGES | (int) ComSupport.DLCTL_VIDEOS 
                    | (int) ComSupport.DLCTL_BGSOUNDS | 0;

            }
            else
            {
                return (int) ComSupport.DLCTL_NO_SCRIPTS | (int) ComSupport.DLCTL_NO_JAVA | (int) ComSupport.DLCTL_NO_DLACTIVEXCTLS
                    | (int) ComSupport.DLCTL_NO_RUNACTIVEXCTLS | (int) ComSupport.DLCTL_SILENT | (int) ComSupport.DLCTL_DLIMAGES | 0;
            }

        }

        public HtmlSite(HtmlEditor container)
        {
            if ((container == null) || (container.IsHandleCreated == false)) throw
                                                                                 new ArgumentException();
            this.container = container;
            container.Resize += new EventHandler(this.Container_Resize);
        }

        public Object Document
        {
            get { return m_document; }
        }

        public IntPtr DocumentHandle
        {
            get {return m_docHwnd; }
        }

        public void CreateDocument()
        {
            Debug.Assert(m_document == null, "Must call Close before recreating.");

            Boolean created = false;
            try
            {
                m_document = (IOleObject) new mshtml.HTMLDocument();

                int iRetval = ComSupport.OleRun(m_document);

        
                m_document.SetClientSite(this);
            
                // Lock the object in memory
                iRetval = ComSupport.OleLockRunning(m_document,true,false);
        
            m_document.SetHostNames("HtmlEditor","HtmlEditor");
            m_document.Advise(this, out iAdviseCookie);
    
                    created = true;
            }
            finally
            {
                if (created == false)
                    m_document = null;
            }
        }

        public void ActivateDocument()
        {
            RECT rect = new RECT();
            ComSupport.GetClientRect(container.Handle, rect);
            m_document.DoVerb(OLEIVERB.UIACTIVATE, IntPtr.Zero, this, 0,
                container.Handle, rect);
        }

        public void CloseDocument()
        {

            try
            {
            container.releaseWndProc();
            container.Resize -= new EventHandler(this.Container_Resize);
                if (m_document == null) return;

                
                view.Show(-1);
            
                view.UIActivate(-1);

                view.SetInPlaceSite(null);
    
                try
                {
                //this may raise an exception, however it does work and must
                //be called
                view.CloseView(0);
                }                        
                catch (Exception e)
                {
                    Debug.WriteLine("CloseView raised exception: " + e.Message);
                }
    
                m_document.SetClientSite(null);
    
                ComSupport.OleLockRunning(m_document,false,false);

                if (this.iAdviseCookie != 0)
                {
                    m_document.Unadvise(this.iAdviseCookie);
                }

                try
                {
                    //this could raise an exception too, but it must be called
                m_document.Close((int)tagOLECLOSE.OLECLOSE_NOSAVE);
                }                        
                catch (Exception e)
                {
                    Debug.WriteLine("Close document raised exception: " + e.Message);
                }
                                

                //release COM objects
                int RefCount = 0;

                if (m_document != null) 
                    do
                    {
                    RefCount = Marshal.ReleaseComObject(m_document);
                    } while (RefCount > 0);

                if (view != null)
                    
                    do
                    {
                    RefCount = Marshal.ReleaseComObject(view);
                    } while (RefCount > 0);

                if (activeObject != null) 
                    
                    do
                    {
                    RefCount = Marshal.ReleaseComObject(activeObject);
                    } while (RefCount > 0);
    
                m_document = null;
                view = null;
                activeObject = null;
                container.m_htmldoc = null;
    
            }
            catch (Exception e)
            {
                Debug.WriteLine("Close document raised exception: " + e.Message);

            }
        }

        void Container_Resize(Object src, EventArgs e)
        {
            if (view == null) return;
            RECT rect = new RECT();
            ComSupport.GetClientRect(container.Handle, rect);
            view.SetRect(rect);
        }

        public Boolean TranslateAccelarator(MSG msg)
        {
            if (activeObject != null)
                if (activeObject.TranslateAccelerator(msg) != HRESULT.S_FALSE)
                    return true;

            return false;
        }

        // IOleClientSite

        public int SaveObject()
        {
    
            return HRESULT.S_OK;
        }

        public int GetMoniker(uint dwAssign, uint dwWhichMoniker, out Object ppmk)
        {

            ppmk = null;
            return HRESULT.E_NOTIMPL;
        }

        public int GetContainer(out IOleContainer ppContainer)
        {

            ppContainer = (IOleContainer) this;
            return HRESULT.S_OK;
        }

        public int ShowObject()
        {

            return HRESULT.S_OK;
        }

        public int OnShowWindow(int fShow)
        {

            return HRESULT.S_OK;
        }

        public int RequestNewObjectLayout()
        {

            return HRESULT.S_OK;
        }

        // IOleContainer
        /*
                 *  used to enumerate objects in a compound document
                 *  or lock a container in the running state. 
                 * 
                 * Container and object applications both implement this interface
                 * */

        public int ParseDisplayName(Object pbc, String pszDisplayName, int[]
            pchEaten, Object[] ppmkOut)
        {

            return HRESULT.E_NOTIMPL;
        }

        public int EnumObjects(uint grfFlags, Object[] ppenum)
        {
            return HRESULT.E_NOTIMPL;
        }

        public int LockContainer(bool fLock)
        {
            if (! fLock) 
            {
                Debug.WriteLine ("LockContainer false");
            }
            else
            {
                Debug.WriteLine ("LockContainer true");
            };

            return HRESULT.S_OK;
        }

        // IOleDocumentSite Implementation

        public int ActivateMe(IOleDocumentView pViewToActivate)
        {
            if (pViewToActivate == null) return HRESULT.E_INVALIDARG;
            RECT rect = new RECT();
            ComSupport.GetClientRect(container.Handle, rect);
            view = pViewToActivate;
            int iResult = view.SetInPlaceSite((IOleInPlaceSite)this);
            
            iResult = view.UIActivate(1);
            iResult = view.SetRect(rect);
            int iShow = 1;
            iResult = view.Show(iShow);  //1 is a boolean for True
            return HRESULT.S_OK;
        }

        //IOleWindow implementation

    public int GetWindow(ref IntPtr hwnd)
    {

        hwnd = IntPtr.Zero;

            if (this.container != null)
            {
                hwnd = this.container.Handle;
                return HRESULT.S_OK;
            }
            else
            {
                return HRESULT.E_FAIL;
            }
        }

        public int ContextSensitiveHelp(bool fEnterMode)
        {
            throw new COMException(String.Empty, HRESULT.E_NOTIMPL);
        }


        // IOleInPlaceSite Implementation


        public int CanInPlaceActivate()
        {

            return HRESULT.S_OK;
        }

        public int OnInPlaceActivate()
        {

            return HRESULT.S_OK;
        }

        public int OnUIActivate()
        {
    

            //return HESULT.S_FALSE prevents focus grab
            //but means no caret
            //return HRESULT.S_FALSE;
            return HRESULT.S_OK;
        }

        public int GetWindowContext(out IOleInPlaceFrame ppFrame, out IOleInPlaceUIWindow
            ppDoc, RECT lprcPosRect, RECT lprcClipRect, tagOIFI lpFrameInfo)
        {
    
            ppDoc = null; //set to null because same as Frame window
            ppFrame = (IOleInPlaceFrame) this;
            if (lprcPosRect != null)
            {
                ComSupport.GetClientRect(container.Handle, lprcPosRect);
            }

            if (lprcClipRect != null)
            {
                ComSupport.GetClientRect(container.Handle, lprcClipRect);
            }
            
            //lpFrameInfo.cb = Marshal.SizeOf(typeof(tagOIFI));
            //This value is set by the caller

            lpFrameInfo.fMDIApp = 0;
            lpFrameInfo.hwndFrame = container.Handle;
            lpFrameInfo.hAccel = IntPtr.Zero;
            lpFrameInfo.cAccelEntries = 0;
            return HRESULT.S_OK;
        }

        public int Scroll(Object scrollExtant)
        {
            return HRESULT.E_NOTIMPL;
        }

        public int OnUIDeactivate(int fUndoable)
        {

            return HRESULT.S_OK;
        }

        public int OnInPlaceDeactivate()
        {

            activeObject = null;
            return HRESULT.S_OK;
        }

        public int DiscardUndoState()
        {
            return HRESULT.E_NOTIMPL ;
        }

        public int DeactivateAndUndo()
        {

            return HRESULT.S_OK;
        }

        public int OnPosRectChange(RECT lprcPosRect)
        {
            return HRESULT.S_OK;
        }


        // IOLEInPlaceSiteEx
        public int OnInPlaceActivateEx(out bool pfNoRedraw, int dwFlags)
        {
            pfNoRedraw = false; //false means object needs to redraw


            return HRESULT.S_OK;
        }

        public int OnInPlaceDeactivateEx(bool fNoRedraw)
        {


            if (! fNoRedraw)
            {
                //redraw container
                this.container.Invalidate();
            }

            return HRESULT.S_OK;
        }

        public int RequestUIActivate()
        {


            //return S_FALSE to prevent activation
            //solves focus problems, but no editing

            if (this.container.mAllowActivation) 
            {
                return HRESULT.S_OK;
            }
            else
            {
                return HRESULT.S_FALSE;
            }
            
            
        }

        // IOLEInPlaceUIWindow

        public int GetBorder(RECT lprectBorder)
        {
            return HRESULT.E_NOTIMPL;
        }

        public int RequestBorderSpace(RECT pborderwidths)
        {
            return HRESULT.E_NOTIMPL;
        }

        public int SetBorderSpace(RECT pborderwidths)
        {
            return HRESULT.E_NOTIMPL;
        }


    // IOleInPlaceFrame Implementation

        public int SetActiveObject(IOleInPlaceActiveObject pActiveObject, String
            pszObjName)
        {
Debug.WriteLine("SET ACTIVE OBJECT");
            try
            {
    
                if (pActiveObject == null)
                {
                    container.releaseWndProc();
                    if (this.activeObject != null)
                    {
                        Marshal.ReleaseComObject(this.activeObject);
                    }
                    this.activeObject  = null;
                    this.m_docHwnd = IntPtr.Zero;
                    this.mFullyActive = false;
                }
                else
                {
                    this.activeObject = pActiveObject;
                    this.m_docHwnd = new IntPtr();
                    pActiveObject.GetWindow(ref this.m_docHwnd);
                    this.mFullyActive = true;
                    //we have the handle to the doc so set up WndProc override
                    container.setupWndProc();
                }

            }
            catch (Exception e)
            {
                Debug.WriteLine("Exception: " + e.Message + e.StackTrace);

            }

            return HRESULT.S_OK;
        
        }

        public int InsertMenus(IntPtr hmenuShared, tagOleMenuGroupWidths
            lpMenuWidths)
        {
            return HRESULT.E_NOTIMPL;
        }

        public int SetMenu(IntPtr hmenuShared, IntPtr holemenu, IntPtr
            hwndActiveObject)
        {
            return HRESULT.E_NOTIMPL;
        }

        public int RemoveMenus(IntPtr hmenuShared)
        {
            return HRESULT.E_NOTIMPL;
        }

        public int SetStatusText(String pszStatusText)
        {
            return HRESULT.E_NOTIMPL;
        }

        public int TranslateAccelerator(MSG lpmsg, short wID)
        {
            return HRESULT.S_FALSE;
        }

        // IDocHostUIHandler Implementation

        public int ShowContextMenu(uint dwID, ref tagPOINT ppt,
            [MarshalAs(UnmanagedType.IUnknown)] object pcmdtReserved,
            [MarshalAs(UnmanagedType.IDispatch)]object pdispReserved)
        {
            if (container.IsContextMenuEnabled) 
            {
                if (container.ContextMenu != null) 
                {
                    //show the assigned ContextMenu
                    System.Drawing.Point pt = new System.Drawing.Point (ppt.x,ppt.y);
                    pt = container.PointToClient(pt);
                    container.ContextMenu.Show(container,pt);
                    return HRESULT.S_OK;
                }
                else
                {
                    //show the default IE ContextMenu
                    return HRESULT.S_FALSE;
                }

            }
            else
            {
                return HRESULT.S_OK;
            }
        }

        public int GetHostInfo(DOCHOSTUIINFO info)
        {
            info.cbSize = Marshal.SizeOf(typeof(DOCHOSTUIINFO));
            info.dwDoubleClick = DOCHOSTUIDBLCLICK.DEFAULT;
            info.dwFlags = (int)(DOCHOSTUIFLAG.NO3DBORDER | DOCHOSTUIFLAG.ENABLE_INPLACE_NAVIGATION |
                DOCHOSTUIFLAG.DISABLE_SCRIPT_INACTIVE | DOCHOSTUIFLAG.FLAT_SCROLLBAR);
            info.dwReserved1 = 0;
            info.dwReserved2 = 0;
            return HRESULT.S_OK;
        }

        public int EnableModeless(Boolean fEnable)
        {
            return HRESULT.S_OK;
        }

        public int ShowUI(int dwID, IOleInPlaceActiveObject activeObject, Object
            /* IOleCommandTarget */ commandTarget, IOleInPlaceFrame frame, Object doc)
        {
            return HRESULT.S_OK;
        }

        public int HideUI()
        {
            return HRESULT.S_OK;
        }

        public int UpdateUI()
        {
            if (this.mFullyActive && (this.m_document != null) && (this.container.mDesignMode == true))
            {
                
                try
                {
                    mshtml.HTMLDocument thisdoc = (mshtml.HTMLDocument)m_document;
                                    
                    //we need IDisplayServices to get the caret position
                    mshtml.IDisplayServices ds = (IDisplayServices)thisdoc;

                    if (ds == null) 
                    {
                    return HRESULT.S_OK;
                    }
                
                        
                    IHTMLCaret caret;
                    ds.GetCaret(out caret);

                    if (caret == null) 
                    {
                        Debug.WriteLine ("caret was null");
                        return HRESULT.S_OK;
                    }

                    tagPOINT pt = new tagPOINT();

                    caret.GetLocation(out pt,1);

                    IHTMLElement el = thisdoc.elementFromPoint(pt.x,pt.y);

                    if (el == null) 
                    {
                        Debug.WriteLine ("pt was null");
                        return HRESULT.S_OK;
                    }

                    container.mcurrentElement = el;
                    container.InvokeUpdateUI(el);

                }    
                catch (Exception e)
                {
                    Debug.WriteLine(e.Message + e.StackTrace );

                }
            
            }

            //should always return S_OK unless error
            return HRESULT.S_OK;
        }

        public int OnDocWindowActivate(Boolean fActivate)
        {
            return HRESULT.E_NOTIMPL;
        }

        public int OnFrameWindowActivate(Boolean fActivate)
        {
            return HRESULT.E_NOTIMPL;
        }

        public int ResizeBorder(RECT rect, Object doc, Boolean fFrameWindow)
        {
            return HRESULT.E_NOTIMPL;
        }

        public int GetOptionKeyPath(out IntPtr pbstrKey, uint dw)
        {
            //use this to set your own app-specific preferences

            //eg pbstrKey = Marshal.StringToBSTR("Software\\myapp\\mysettings\\mshtml");
            pbstrKey = IntPtr.Zero;
            return HRESULT.S_OK;

        }

        public int GetDropTarget(Object pDropTarget, out Object ppDropTarget)
        {
            ppDropTarget = null;
            return HRESULT.E_NOTIMPL;
        }

        public int GetExternal(out Object ppDispatch)
        {
            ppDispatch = container.Parent;
            return HRESULT.S_OK;

            //Note from Stephen Wood
            //1. GetExternal function.
            //Please change the following line
            //ppDispatch = container;
            //to
            //ppDispatch = container.Parent;
            //This allows the user to do something like window.external.MyFunction;
            //and get the function fired in the parent container.

        }

        public int TranslateAccelerator(MSG msg, ref Guid group, int nCmdID)
        {
            
            return HRESULT.S_FALSE;
        }

        public int TranslateUrl(int dwTranslate, String strURLIn, out String
            pstrURLOut)
        {
            pstrURLOut = null;
            return HRESULT.E_NOTIMPL;
        }

        public int FilterDataObject(Object pDO, out Object ppDORet)
        {
            ppDORet = null;
            return HRESULT.E_NOTIMPL;
        }

        #region IDocHostShowUI --show message boxes and Help ======================
        //IDocHostShowUI
        /*
             * A host can supply mechanisms that will 
             * show message boxes and Help 
             * by implementing the IDocHostShowUI interface
             * */
        public int ShowMessage(IntPtr hwnd,String lpStrText,
            String lpstrCaption,uint dwType,String lpHelpFile,
            uint dwHelpContext,IntPtr lpresult)
        {
                
            return HRESULT.E_NOTIMPL; 
        }

        public int ShowHelp(IntPtr hwnd,String lpHelpFile,
            uint uCommand,uint dwData,tagPOINT ptMouse,
            Object pDispatchObjectHit) 
        {
                
            return HRESULT.E_NOTIMPL;
        }
            #endregion IDocHostShowUI =============
    


        //IAdviseSink implementation
        public void OnClose()
        {
            Debug.WriteLine("IAdviseSink: Doc called OnClose");
        }

        public void OnDataChange(object pStgmed, object pFormatEtc)
        {
        }

        public void OnRename(UCOMIMoniker pmk)
        {
        }

        public void OnSave()
        {
        }

        public void OnViewChange(int dwAspect, int lindex)
        {
        }

        #region IServiceProvider -- retrieve a service object ========================
        //implementation of IServiceProvider
        /*
             * Defines a mechanism for retrieving a service object; 
             * that is, an object that provides custom support to other objects
             * */
        public int QueryService(ref System.Guid guidservice, ref System.Guid interfacerequested, out IntPtr ppserviceinterface)
        {
                
            int hr = HRESULT.E_NOINTERFACE;
            System.Guid iid_htmledithost = new System.Guid("3050f6a0-98b5-11cf-bb82-00aa00bdce0b");
            System.Guid sid_shtmledithost = new System.Guid("3050F6A0-98B5-11CF-BB82-00AA00BDCE0B");
                

            if ((guidservice == sid_shtmledithost) & (interfacerequested == iid_htmledithost))
            {
                CSnap snapper = new CSnap();
                ppserviceinterface = Marshal.GetComInterfaceForObject(snapper,typeof(IHTMLEditHost));
                if (ppserviceinterface != IntPtr.Zero )
                {
                    hr = HRESULT.S_OK;
                }

            }
            else
            {
                ppserviceinterface = IntPtr.Zero;
            }

            return hr;

        }
            #endregion IServiceProvider ========================

        #region IHTMLEditDesigner change the IE editor's default behavior ==========
        // IHTMLEditDesigner
        /*
             * This custom interface provides methods that enable clients using the editor 
             * to intercept Microsoft® Internet Explorer events 
             * so that they can change the editor's default behavior
             * */
        public int PreHandleEvent(int inEvtDispID,IHTMLEventObj pIEventObj)
        {
                
            //CGID_MSHTML
            //Guid pguidCmdGroup = new Guid("d4db6850-5385-11d0-89e9-00a0c90a90ac");
            System.Guid pguidCmdGroup = new Guid("DE4BA900-59CA-11CF-9592-444553540000");
            onlyconnect.IOleCommandTarget ct = (onlyconnect.IOleCommandTarget)this.m_document;
                                
            int iRetval;
            switch (inEvtDispID)
            {
                case ComSupport.DISPID_IHTMLELEMENT_ONCLICK:
                    break;
                case ComSupport.DISPID_IHTMLELEMENT_ONKEYDOWN:
                    break;
                case ComSupport.DISPID_IHTMLELEMENT_ONKEYUP:
                    break;
                case  ComSupport.DISPID_IHTMLELEMENT_ONKEYPRESS:
                    break;
                case ComSupport.DISPID_MOUSEMOVE:
                    break;
                case ComSupport.DISPID_MOUSEDOWN:
                    break;
                case ComSupport.DISPID_KEYDOWN:
                    //Need to trap Del here
                    if (pIEventObj.keyCode == 46)
                    {
                        //delete
                        if (ct != null)
                        {
                            Object pvaIn = null;
                            Object pvaOut = null;
                            iRetval = ct.Exec(ref pguidCmdGroup,onlyconnect.ComSupport.IDM_DELETE,(int)onlyconnect.OLECMDEXECOPT.OLECMDEXECOPT_DONTPROMPTUSER,ref pvaIn,ref pvaOut);
                        }

                    }

                    break;
                case ComSupport.DISPID_KEYPRESS:
                    Debug.WriteLine ("PreHandle KeyPress -603");
                    //Gets called on keypress
                    //look for Ctrl-n combos
                    if (pIEventObj.ctrlKey)
                    {
                        int iKey = pIEventObj.keyCode;
                        switch (iKey)
                        {
                            case 1: //CTRL-A

                                //select all
                                if (ct != null)
                                {
                                    Object pvaIn = null;
                                    Object pvaOut = null;
                                    iRetval = ct.Exec(ref pguidCmdGroup,onlyconnect.ComSupport.IDM_SELECTALL,(int)onlyconnect.OLECMDEXECOPT.OLECMDEXECOPT_DONTPROMPTUSER,ref pvaIn,ref pvaOut);
                                }


                                break;
                            case 3: //CTRL-C
                                if (ct != null)
                                {
                                    Object pvaIn = null;
                                    Object pvaOut = null;
                                    iRetval = ct.Exec(ref pguidCmdGroup,onlyconnect.ComSupport.IDM_COPY,(int)onlyconnect.OLECMDEXECOPT.OLECMDEXECOPT_DONTPROMPTUSER,ref pvaIn,ref pvaOut);
                                }
                                break;
                            case 22: //CTRL-V
                                if (ct != null)
                                {
                                    Object pvaIn = null;
                                    Object pvaOut = null;
                                    iRetval = ct.Exec(ref pguidCmdGroup,onlyconnect.ComSupport.IDM_PASTE,(int)onlyconnect.OLECMDEXECOPT.OLECMDEXECOPT_DONTPROMPTUSER,ref pvaIn,ref pvaOut);
                                }
                                break;
                            case 24: //CTRL-X
                                if (ct != null)
                                {
                                    Object pvaIn = null;
                                    Object pvaOut = null;
                                    iRetval = ct.Exec(ref pguidCmdGroup,onlyconnect.ComSupport.IDM_CUT,(int)onlyconnect.OLECMDEXECOPT.OLECMDEXECOPT_DONTPROMPTUSER,ref pvaIn,ref pvaOut);
                                }
                                break;
                            case 25: //CTRL-Y
                                if (ct != null)
                                {
                                    Object pvaIn = null;
                                    Object pvaOut = null;
                                    iRetval = ct.Exec(ref pguidCmdGroup,onlyconnect.ComSupport.IDM_REDO,(int)onlyconnect.OLECMDEXECOPT.OLECMDEXECOPT_DONTPROMPTUSER,ref pvaIn,ref pvaOut);
                                }
                                break;
                            case 26: //CTRL-Z
                                if (ct != null)
                                {
                                    Object pvaIn = null;
                                    Object pvaOut = null;
                                    iRetval = ct.Exec(ref pguidCmdGroup,onlyconnect.ComSupport.IDM_UNDO,(int)onlyconnect.OLECMDEXECOPT.OLECMDEXECOPT_DONTPROMPTUSER,ref pvaIn,ref pvaOut);
                                }
                                break;
                            default:
                                //container.InvokeHtmlKeyPress(ref pIEventObj);
                                break;
                        }
                            
                    }
                    container.InvokeHtmlKeyPress(ref pIEventObj);

                    break;
                case ComSupport.DISPID_EVMETH_ONDEACTIVATE:
                    break;
                default:
                    break;
            }
                
            return HRESULT.S_FALSE;
        }

        public int PostHandleEvent(int inEvtDispID,IHTMLEventObj pIEventObj)
        {
                                
            return HRESULT.S_FALSE;
        }

        public int TranslateAccelerator(int inEvtDispID,IHTMLEventObj pIEventObj)
        {
            
            return HRESULT.S_FALSE;
        }

        public int PostEditorEventNotify(int inEvtDispID,IHTMLEventObj pIEventObj)
        {
        
            return HRESULT.S_FALSE;
        }
        #endregion IHTMLEditDesigner ================

    }
}
