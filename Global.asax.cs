using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace hotel3g
{
    // 注意: 有关启用 IIS6 或 IIS7 经典模式的说明，
    // 请访问 http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute("alipaycallback", "AliPay/AlipayCallback.html", new { controller = "Pay", action = "OrderTrade" });
            routes.MapRoute("alipaynotify", "AliPay/AlipayNotify.html", new { controller = "Pay", action = "Notify" });

            routes.MapRoute(
                "Default", // 路由名称
                "{controller}/{action}/{id}", // 带有参数的 URL
                new { controller = "Hotel", action = "Map", id = UrlParameter.Optional } // 参数默认值
            );
            routes.MapRoute(
              "Post",
              "{controller}/{action}/{hotelid}/{weixinID}/{userWeixinNO}/{pos}",
              new { controller = "Home", action = "Map" }
          );

        }

        protected void Application_Start()
        {
            try
            {
                log4net.Config.XmlConfigurator.Configure(new Uri(System.AppDomain.CurrentDomain.BaseDirectory + "Config\\log4net.config.xml"));
            }
            catch (Exception ex)
            {
                new Common.LogManage().Error("Application_Start Exception:"+ex.Message.ToString());
            }
            AreaRegistration.RegisterAllAreas();

            RegisterRoutes(RouteTable.Routes);
        }
    }
}