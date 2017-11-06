using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace hotel3g.Common
{
    public class GlobalConfig
    {
        /// <summary>
        /// 系统异常
        /// </summary>
        public const string ExceptionMessage = "系统异常！";

        public static string WebSite
        {
            get
            {
                return System.Configuration.ConfigurationManager.AppSettings["websiteUrl"].ToString();
            }
        }

        public static string WebKey
        {
            get
            {
                return "lzn128uu";
            }
        }

        public static string ServiceTel
        {
            get
            {
                return System.Configuration.ConfigurationManager.AppSettings["serviceTel"].ToString();
            }
        }

        public static string ConnStr
        {
            get
            {
                return System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString();
            }
        }
    }
}