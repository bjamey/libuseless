// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: C# WebBrowser demo
//
// Date : unknown
// By   : Chua Chee Wee, Singapore
// ----------------------------------------------------------------------------

/*********************************************************
Dependencies: AxInterop.SHDocVw.dll (aximp c:\windows\system\shdocvw.dll)
**********************************************************/
using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Reflection;


namespace WebBrowserNamespace
{
    /// <summary>
    /// Summary description for WinForm3.
    /// </summary>
    public class WebBrowserForm : System.Windows.Forms.Form
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.Container components = null;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Button btnViewWebPage;
        private System.Windows.Forms.TextBox URL;
        protected Object oMissing = System.Reflection.Missing.Value;

        private System.Windows.Forms.StatusBar statusBar;
        private AxSHDocVw.AxWebBrowser WebBrowser;

        public WebBrowserForm()
        {
            //
            // Required for Windows Form Designer support
            //
            InitializeComponent();

            //
            // TODO: Add any constructor code after InitializeComponent call
            //
        }

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        protected override void Dispose( bool disposing )
        {
            if( disposing )
            {
                if (components != null)
                {
                    components.Dispose();
                }
            }
            base.Dispose( disposing );
        }

        #region Windows Form Designer generated code
        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        
        private void InitializeComponent()
        {
            System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(WebBrowserForm));
            this.panel1 = new System.Windows.Forms.Panel();
            this.URL = new System.Windows.Forms.TextBox();
            this.panel2 = new System.Windows.Forms.Panel();
            this.btnViewWebPage = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.statusBar = new System.Windows.Forms.StatusBar();
            this.WebBrowser = new AxSHDocVw.AxWebBrowser();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.WebBrowser)).BeginInit();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.URL);
            this.panel1.Controls.Add(this.panel2);
            this.panel1.Controls.Add(this.label1);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(408, 21);
            this.panel1.TabIndex = 2;
            // 
            // URL
            // 
            this.URL.Dock = System.Windows.Forms.DockStyle.Fill;
            this.URL.Location = new System.Drawing.Point(160, 0);
            this.URL.Name = "URL";
            this.URL.Size = new System.Drawing.Size(168, 20);
            this.URL.TabIndex = 2;
            this.URL.Text = "http://www.borland.com/";
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.btnViewWebPage);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Right;
            this.panel2.Location = new System.Drawing.Point(328, 0);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(80, 21);
            this.panel2.TabIndex = 1;
            // 
            // btnViewWebPage
            // 
            this.btnViewWebPage.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnViewWebPage.Location = new System.Drawing.Point(0, 0);
            this.btnViewWebPage.Name = "btnViewWebPage";
            this.btnViewWebPage.Size = new System.Drawing.Size(75, 20);
            this.btnViewWebPage.TabIndex = 0;
            this.btnViewWebPage.Text = "Go!";
            this.btnViewWebPage.Click += new System.EventHandler(this.btnViewWebPage_Click);
            // 
            // label1
            // 
            this.label1.Dock = System.Windows.Forms.DockStyle.Left;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(0, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(160, 21);
            this.label1.TabIndex = 0;
            this.label1.Text = "Enter web address :  ";
            // 
            // statusBar
            // 
            this.statusBar.Location = new System.Drawing.Point(0, 217);
            this.statusBar.Name = "statusBar";
            this.statusBar.Size = new System.Drawing.Size(408, 19);
            this.statusBar.TabIndex = 4;
            // 
            // WebBrowser
            // 
            this.WebBrowser.Dock = System.Windows.Forms.DockStyle.Fill;
            this.WebBrowser.Enabled = true;
            this.WebBrowser.Location = new System.Drawing.Point(0, 21);
            this.WebBrowser.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("WebBrowser.OcxState")));
            this.WebBrowser.Size = new System.Drawing.Size(408, 196);
            this.WebBrowser.TabIndex = 5;
            this.WebBrowser.NavigateComplete2 += new AxSHDocVw.DWebBrowserEvents2_NavigateComplete2EventHandler(this.WebBrowser_NavigateComplete2);
            // 
            // WebBrowserForm
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.ClientSize = new System.Drawing.Size(408, 236);
            this.Controls.Add(this.WebBrowser);
            this.Controls.Add(this.statusBar);
            this.Controls.Add(this.panel1);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Name = "WebBrowserForm";
            this.Text = "C# Web Browser";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Load += new System.EventHandler(this.WinForm3_Load);
            this.Closed += new System.EventHandler(this.WinForm3_Closed);
            this.panel1.ResumeLayout(false);
            this.panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.WebBrowser)).EndInit();
            this.ResumeLayout(false);
        }
        #endregion

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.Run(new WebBrowserForm());
        }

        private void LoadPage()
        {
          string WebURL = URL.Text;
          WebBrowser.Navigate(WebURL, ref oMissing, ref oMissing,
                              ref oMissing, ref oMissing);
        }

        private void btnViewWebPage_Click(object sender, System.EventArgs e)
        {
          LoadPage();
        }

        private void WinForm3_Load(object sender, System.EventArgs e)
        {
          LoadPage();
        }
        
        private void WinForm3_Closed(object sender, System.EventArgs e)
        {
            
        }

        private void WebBrowser_NavigateComplete2(object sender, AxSHDocVw.DWebBrowserEvents2_NavigateComplete2Event e) {
         statusBar.Text = URL.Text+" loaded.";
        }
    }
}
