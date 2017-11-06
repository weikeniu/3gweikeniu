using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace hotel3g.Models
{
    public class Cookies
    {
        public static string GetCookies(string name,string weixinid) {
            name = string.Format("{1}n{0}", name, weixinid);
            if (HttpContext.Current.Request.Cookies[name] == null) {
                return "";
            }
       

            return HttpContext.Current.Request.Cookies[name].Value;
        }

        public static void SetCookies(string name,string value,int days,string weixinid) {


           
           if (GetCookies(name,weixinid) != "") {
               HttpContext.Current.Response.Cookies[string.Format("{1}n{0}", name,weixinid)].Expires=DateTime.Now.AddDays(-1);
           }
            name = string.Format("{1}n{0}", name,weixinid);
            HttpCookie cookie = new HttpCookie(name, value);
            cookie.Domain = "/";
            cookie.Expires = DateTime.Now.AddDays(days);
            HttpContext.Current.Response.AppendCookie(cookie);
        }
    }
}