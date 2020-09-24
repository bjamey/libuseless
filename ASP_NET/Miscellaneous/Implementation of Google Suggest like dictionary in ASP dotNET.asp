<!-- --------------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Implementation of Google Suggest like dictionary in ASP dotNET

   Date : 15/05/2007
   By   : FSL
--------------------------------------------------------------------------- -->

<!--
 -----------------
 *** IMPORTANT ***
 -----------------
 This item includes IMPORTANT additional attached files. See "Attachments" tab for further info
-->

<!-- This is an implementation of Google Suggest like dictionary in ASP.NET -->

<%@Page Language="C#"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System.Data.SqlClient"%>
<%@Import Namespace="System.Configuration"%>
<script runat="server">

    public void Page_Load(object sender,EventArgs args)
    {
                string keyword=Request["k"];
                if(keyword!=null && keyword.Trim()!="")
                {
                        string sql="select top 10* from WordList where word like '"+keyword.Trim().Replace("'","''")+"%'";
                        SqlConnection conn=new SqlConnection(ConfigurationSettings.AppSettings["connectionString"]);
                        conn.Open();
                        DataTable dt=new DataTable();
                        SqlCommand command=new SqlCommand(sql,conn);
                        SqlDataAdapter adapter=new SqlDataAdapter(command);
                        adapter.Fill(dt);
                        conn.Close();

                        foreach(DataRow row in dt.Rows)
                        {
                                string meaning=row["Meaning"].ToString();
                                Response.Write("<strong>"+row["Word"].ToString()+"</strong> <i>"+row["Type"].ToString()+"</i>: "+meaning+"<br>");
                        }
        }


    }

</script>
