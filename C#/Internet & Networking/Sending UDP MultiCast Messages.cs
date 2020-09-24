// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Sending UDP MultiCast Messages
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
using System.Net.Sockets;
using System.Net;
using System.Threading;

namespace DevDistrict.MultiCastUDP
{
        public class Form1 : System.Windows.Forms.Form
        {
                private System.ComponentModel.Container components = null;

                //The address of the multicast group
                IPAddress groupAddress = IPAddress.Parse("226.254.82.200");

                private IPEndPoint remoteEP;
                private string messageString=null;

                private System.Windows.Forms.Panel panel1;
                private System.Windows.Forms.TextBox txtSend;
                private System.Windows.Forms.Button btnConnect;
                private System.Windows.Forms.TextBox txtOutput;
                private System.Windows.Forms.Button btnDisconnect;

                //Create a UDP client
                UdpClient client=null;

                public Form1()
                {
                        InitializeComponent();
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

                #region Windows Form Designer generated code
                private void InitializeComponent()
                {
                        this.panel1 = new System.Windows.Forms.Panel();
                        this.txtSend = new System.Windows.Forms.TextBox();
                        this.btnConnect = new System.Windows.Forms.Button();
                        this.txtOutput = new System.Windows.Forms.TextBox();
                        this.btnDisconnect = new System.Windows.Forms.Button();
                        this.panel1.SuspendLayout();
                        this.SuspendLayout();
                        //
                        // panel1
                        //
                        this.panel1.Controls.Add(this.btnDisconnect);
                        this.panel1.Controls.Add(this.btnConnect);
                        this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
                        this.panel1.Location = new System.Drawing.Point(0, 0);
                        this.panel1.Name = "panel1";
                        this.panel1.Size = new System.Drawing.Size(616, 40);
                        this.panel1.TabIndex = 0;
                        //
                        // txtSend
                        //
                        this.txtSend.Dock = System.Windows.Forms.DockStyle.Top;
                        this.txtSend.Location = new System.Drawing.Point(0, 40);
                        this.txtSend.Name = "txtSend";
                        this.txtSend.Size = new System.Drawing.Size(616, 20);
                        this.txtSend.TabIndex = 1;
                        this.txtSend.Text = "";
                        this.txtSend.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.txtSend_KeyPress);
                        //
                        // btnConnect
                        //
                        this.btnConnect.Location = new System.Drawing.Point(8, 8);
                        this.btnConnect.Name = "btnConnect";
                        this.btnConnect.TabIndex = 0;
                        this.btnConnect.Text = "Connect";
                        this.btnConnect.Click += new System.EventHandler(this.btnConnect_Click);
                        //
                        // txtOutput
                        //
                        this.txtOutput.Dock = System.Windows.Forms.DockStyle.Fill;
                        this.txtOutput.Location = new System.Drawing.Point(0, 60);
                        this.txtOutput.Multiline = true;
                        this.txtOutput.Name = "txtOutput";
                        this.txtOutput.Size = new System.Drawing.Size(616, 329);
                        this.txtOutput.TabIndex = 2;
                        this.txtOutput.Text = "";
                        //
                        // btnDisconnect
                        //
                        this.btnDisconnect.Location = new System.Drawing.Point(96, 8);
                        this.btnDisconnect.Name = "btnDisconnect";
                        this.btnDisconnect.TabIndex = 1;
                        this.btnDisconnect.Text = "Disconnect";
                        this.btnDisconnect.Click += new System.EventHandler(this.btnDisconnect_Click);
                        //
                        // Form1
                        //
                        this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
                        this.ClientSize = new System.Drawing.Size(616, 389);
                        this.Controls.Add(this.txtOutput);
                        this.Controls.Add(this.txtSend);
                        this.Controls.Add(this.panel1);
                        this.Name = "Form1";
                        this.Text = "Form1";
                        this.panel1.ResumeLayout(false);
                        this.ResumeLayout(false);

                }
                #endregion

                [STAThread]
                static void Main()
                {
                        Application.Run(new Form1());
                }

                ///
                /// Registers Intrest
                ///
                private void Start()
                {
                        client = new UdpClient(11000);
                        remoteEP = new IPEndPoint(groupAddress, 11000);
                        client.JoinMulticastGroup(groupAddress, 2);

                        Thread t = new Thread(new ThreadStart(Listen));
                        t.IsBackground = true;
                        t.Start();
                }

                ///
                /// Deregisters
                ///
                private void Stop()
                {
                        client.DropMulticastGroup(groupAddress);
                        client.Close();
                }

                ///
                /// Blocks on the receive, unblocks when data is retrieved.
                /// If we drop the multicast group this will generate an error
                /// which is why it's wrapped in the try..catch, but should be
                /// handled better than this in a real application
                ///
                private void Listen()
                {
                        while(true)
                        {
                                try
                                {
                                        IPEndPoint ep=null;

                                        Byte[] b = client.Receive(ref ep);
                                        messageString = System.Text.ASCIIEncoding.ASCII.GetString(b);

                                        //Marshal the call to the forms thread
                                        this.Invoke(new MethodInvoker(GotMessage));
                                }
                                catch
                                {
                                }
                        }
                }

                ///
                /// Invoked by the code above to run on the forms thread.
                ///
                public void GotMessage()
                {
                        txtOutput.Text = messageString;
                }

                ///
                /// Sends a message to the multicast group
                ///
                ///
