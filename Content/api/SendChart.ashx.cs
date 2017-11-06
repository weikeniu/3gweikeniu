using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
namespace hotel3g.Content.api
{
    /// <summary>
    /// SendChart 的摘要说明
    /// </summary>
    public class SendChart : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string phone = context.Request.QueryString["phone"];
            WebClient client = new WebClient();
            string url = string.Format(@"http://new.128uu.com/Operation/Test/PhoneCode/PhoneCode.ashx?type=haven&phone="+phone, phone);
            string json = client.DownloadString(url);
            context.Response.Write(json);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}