// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Drawing a Gradient Background for a Control
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

using System;
using System.Windows.Forms;
using System.Drawing;
using System.Drawing.Drawing2D;

namespace DevDistrict.Sample
{
        public class GradientPanel : System.Windows.Forms.Panel
        {
                protected override void OnPaint(PaintEventArgs e)
                {
                        base.OnPaint (e);

                        Graphics g = e.Graphics;

                        g.SmoothingMode = SmoothingMode.HighQuality;
                        GraphicsPath gPath = new GraphicsPath();

                        Rectangle r = new Rectangle(0,0,this.Width,this.Height);
                        gPath.AddRectangle(r);

                        LinearGradientBrush lb = new LinearGradientBrush(r,Color.White,Color.Blue,LinearGradientMode.Vertical);

                        g.FillPath(lb,gPath);
                }
        }
}
