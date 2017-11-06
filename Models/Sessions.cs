using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Peer._128uu.Public
{
   public class Sessions
    {
       public Sessions() { 
       
       }

       public static void SetSession(string name,string value) {
           System.Web.HttpContext.Current.Session[name] = value;
       }

       public static string GetSession(string name, string defaultVal) {
           if (System.Web.HttpContext.Current.Session[name] == null) {
               SetSession(name, defaultVal);
               return defaultVal;
           } return System.Web.HttpContext.Current.Session[name].ToString();
       }
    }
}
