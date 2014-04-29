using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using Newtonsoft.Json;
using System.Web.Services; 
using System.Collections.Generic;
public partial class Response : System.Web.UI.Page
{ 
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["Method"] != null)
        {
            string response;
            string method = Request.QueryString["Method"].ToString();
            if (method == "GetString_JSON")
            {
                response = JsonConvert.SerializeObject("Hello World!");
                Response.Write(response);
            }
            if (method == "GetObject_JSON")
            {
                Chart child = new Chart();
                child.Persent = 200;
                child.UserName = "China";
                response = JsonConvert.SerializeObject(child);
                Response.Write(response); 
            }
            if (method == "GetObjects_JSON")
            {

                List<UserInfo> list = new List<UserInfo>();
                list.Add(new UserInfo("001","Yang"));
                list.Add(new UserInfo("002", "long")); 
                response = JsonConvert.SerializeObject(list); 
                Response.Write(response);
            }
            if (method == "GetArray_JSON")
            {
                ArrayList list = new ArrayList();
                list.Add(100);
                list.Add(2);
                list.Add(3);
                list.Add(7);
                list.Add(9);
                list.Add(10);
                response = JsonConvert.SerializeObject(list);
                Response.Write(response);
            } 
            if (Request.QueryString["Method"].ToString() == "GetChart")
            {

                Chart[] charts = new Chart[4];
                Chart chart1 = new Chart();
                chart1.UserName = "China";
                chart1.Persent = 20;

                Chart chart2 = new Chart();
                chart2.UserName = "Japan";
                chart2.Persent = 10;

                Chart chart3 = new Chart();
                chart3.UserName = "USA";
                chart3.Persent = 35;

                Chart chart4 = new Chart();
                chart4.UserName = "Russia";
                chart4.Persent = 35;

                charts[0] = chart1;
                charts[1] = chart2;
                charts[2] = chart3;
                charts[3] = chart4;
                response = JsonConvert.SerializeObject(charts);
                Response.Write(response);
            }

            if (method == "GetString")
            {
                Response.Write("HelloWorld!");
            }
            if (method == "GetAssocObject")
            {
                DataTable table = new DataTable();
                response = JsonConvert.SerializeObject(table);
                Response.Write(response);
            }
        }
    }
    [WebMethod]
    public void GetJSON(string id)
    {
        string response = JsonConvert.SerializeObject("Hello World!");
        Response.Write(response);
    }
}
public class Chart
{
    public string UserName;
    public double Persent;
}
public class UserInfo
{
    public UserInfo(string user_no, string user_name)
    {
        _user_name = user_name;
        _user_no = user_no;
    }

    private string _user_no;
    private string _user_name;

    public string UserNo
    {
        get { return _user_no; }
        set { _user_no = value; }
    }
    public string UserName
    {
        get { return _user_name; }
        set { _user_name = value; }
    }
}

