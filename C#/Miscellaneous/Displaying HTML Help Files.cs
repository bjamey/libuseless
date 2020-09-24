// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Displaying HTML Help Files
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;

namespace DevDistrict
{
        ///
        /// Summary description for Form1.
        ///
        public class Form1 : System.Windows.Forms.Form
        {
                private System.Windows.Forms.HelpProvider helpProvider1;
                private System.Windows.Forms.Button btnShowContents;
                private System.Windows.Forms.Button btnShowIndex;
                private System.Windows.Forms.Button btnSearchHelp;

                private System.ComponentModel.Container components = null;

                public Form1()
                {
                        InitializeComponent();
                }

                private void btnShowContents_Click(object sender, System.EventArgs e)
                {
                        Help.ShowHelp(this, helpProvider1.HelpNamespace);
                }

                private void btnShowIndex_Click(object sender, System.EventArgs e)
                {
                        Help.ShowHelpIndex(this, helpProvider1.HelpNamespace);
                }

                private void btnSearchHelp_Click(object sender, System.EventArgs e)
                {
                        Help.ShowHelp(this, helpProvider1.HelpNamespace, HelpNavigator.Find, "");
                }

                #region Windows Form Designer generated code
                ///
                /// Required method for Designer support - do not modify
                /// the contents of this method with the code editor.
                ///
                private void InitializeComponent()
                {
                        this.helpProvider1 = new System.Windows.Forms.HelpProvider();
                        this.btnShowContents = new System.Windows.Forms.Button();
                        this.btnShowIndex = new System.Windows.Forms.Button();
                        this.btnSearchHelp = new System.Windows.Forms.Button();
                        this.SuspendLayout();
                        //
                        // helpProvider1
                        //
                        this.helpProvider1.HelpNamespace = "C:\\dev\\WindowsApplication40\\htmlhelp.chm";
                        //
                        // btnShowContents
                        //
                        this.btnShowContents.Location = new System.Drawing.Point(8, 8);
                        this.btnShowContents.Name = "btnShowContents";
                        this.btnShowContents.Size = new System.Drawing.Size(96, 23);
                        this.btnShowContents.TabIndex = 0;
                        this.btnShowContents.Text = "Show Contents";
                        this.btnShowContents.Click += new System.EventHandler(this.btnShowContents_Click);
                        //
                        // btnShowIndex
                        //
                        this.btnShowIndex.Location = new System.Drawing.Point(8, 48);
                        this.btnShowIndex.Name = "btnShowIndex";
                        this.btnShowIndex.Size = new System.Drawing.Size(96, 23);
                        this.btnShowIndex.TabIndex = 1;
                        this.btnShowIndex.Text = "Show Index";
                        this.btnShowIndex.Click += new System.EventHandler(this.btnShowIndex_Click);
                        //
                        // btnSearchHelp
                        //
                        this.btnSearchHelp.Location = new System.Drawing.Point(8, 88);
                        this.btnSearchHelp.Name = "btnSearchHelp";
                        this.btnSearchHelp.Size = new System.Drawing.Size(96, 23);
                        this.btnSearchHelp.TabIndex = 2;
                        this.btnSearchHelp.Text = "Search Help";
                        this.btnSearchHelp.Click += new System.EventHandler(this.btnSearchHelp_Click);
                        //
                        // Form1
                        //
                        this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
                        this.ClientSize = new System.Drawing.Size(200, 174);
                        this.Controls.Add(this.btnSearchHelp);
                        this.Controls.Add(this.btnShowIndex);
                        this.Controls.Add(this.btnShowContents);
                        this.Name = "Form1";
                        this.Text = "Form1";
                        this.ResumeLayout(false);

                }
                #endregion

                ///
                /// The main entry point for the application.
                ///
                [STAThread]
                static void Main()
                {
                        Application.Run(new Form1());
                }

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
        }

}
