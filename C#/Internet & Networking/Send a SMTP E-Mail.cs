// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Send a SMTP E-Mail
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

using System;
using System.Web.Mail;

namespace DevDistrict.Sample
{
        public class SendMail
        {
                public void Send(string serverName, string to, string from, string subject)
                {
                        SmtpMail.SmtpServer = serverName;

                        MailMessage m = new MailMessage();
                        m.To = to;
                        m.From = from;
                        m.Subject = subject;
                        m.Body = body;

                        SmtpMail.Send(m);
                }
        }
}
