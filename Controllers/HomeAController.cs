using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using hotel3g.Models;

namespace hotel3g.Controllers
{
    public class HomeAController : Controller
    {
        private static System.Web.Caching.Cache cache = HttpRuntime.Cache;
        [Models.Filter]
        public ActionResult Main(string id)
        {
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            if (!userWeiXinID.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, userWeiXinID.Split('@')[0]);
            }
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = userWeiXinID.Split('@')[0];
            }
            //int hotelId=HotelCloud.Common.HCRequest.getInt("hId");

            IList<Advertisement> list = new List<Advertisement>();

            string cacheName = string.Format("{0}_{1}", weixinID, "mainindex");
            if (cache[cacheName] != null)
            {
                list = (List<Advertisement>)cache[cacheName];
            }

            else
            {
                list = Advertisement.GetAdvertisementBySort(weixinID);
                cache.Insert(cacheName, list, null, DateTime.Now.AddMinutes(30), TimeSpan.Zero);
            }

            if (list != null && list.Count == 0)
            {
                //创建虚拟
                string[] imgs = { "/img/ad_01.jpg", "/img/ad_02.jpg", "/img/ad_03.jpg", "/img/ad_04.jpg", "/img/ad_05.jpg" };
                string imgwebsite = System.Configuration.ConfigurationManager.AppSettings["imgwebsite"] == null ? "http://admin.weikeniu.com" : System.Configuration.ConfigurationManager.AppSettings["imgwebsite"].ToString();
                foreach (string str in imgs)
                {
                    Advertisement ad = new Advertisement();
                    ad.ImageUrl = imgwebsite + str;
                    list.Add(ad);
                }
            }
            ViewData["ad"] = list;
            ViewData["hId"] = id;
            ViewData["weixinID"] = weixinID;
            ViewData["userWeiXinID"] = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);

            Hotel hotel = new Hotel();
            string cache_hotelName = string.Format("{0}_{1}", id, "mainindex");
            if (cache[cache_hotelName] != null)
            {
                hotel = (Hotel)cache[cache_hotelName];
            }

            else
            {
                hotel = HotelHelper.GetMainIndexHotel(Convert.ToInt32(id));
                cache.Insert(cache_hotelName, hotel, null, DateTime.Now.AddMinutes(30), TimeSpan.Zero);
            }

            ViewData["hotel"] = hotel.SubName;
            ViewData["quanjing"] = hotel.Quanjing;
            ViewData["MainPic"] = hotel.MainPic;


            bool IsBranch = hotel3g.Models.DAL.BranchHelper.IsBranch(weixinID);
            ViewData["IsBranch"] = IsBranch;

            //读取模板style 0：默认 1：简约（Simple） 2：多彩（Colourful）
            hotel3g.Repository.WeiXinAppConfig Config = hotel3g.Repository.MemberHelper.GetHotelAppConfig(weixinID);
            if (Config.style > 0)
            {
             
                //菜单栏
                List<MenuDictionaryResponse> MenuBarList = hotel3g.Models.MenuBarHelper.MenuBarListA(Config.style, weixinID, hotel.Quanjing,userWeiXinID);

                ViewData["MenuBarList"] = MenuBarList;
                
                hotel = HotelHelper.GetMainIndexHotel(Convert.ToInt32(id));
                ViewData["HotelInfo"] = hotel;
            }
            if (!string.IsNullOrEmpty(hotel.MainPic))
            {
                switch (Config.style)
                {
                    case 0: return View();
                    case 1: return View("Simple");
                    case 2: return View("Colourful");
                    case 3: return View("MiniSimple");
                    case 4: return View("MiniColourful");
                    case 5: return View("Dynamic");
                    default: return View();
                }
            }

            return View();
        }


        [Models.Filter]
        public ActionResult CouPon(string id)
        {
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            if (!userWeiXinID.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, userWeiXinID.Split('@')[0]);
            }
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = userWeiXinID.Split('@')[0];
            }
            var dt = hotel3g.Models.CouPon.GetCouPons(weixinID);

            ViewData["weixinID"] = weixinID;
            ViewData["hId"] = id;
            userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            ViewData["userWeiXinID"] = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            ViewData["dt"] = dt;
            //获取已有优惠券
            List<long> MyCoupons = hotel3g.Repository.MemberHelper.GetMyCouPons(weixinID, userWeiXinID);
            ViewData["MyCoupons"] = MyCoupons;
            return View();
        }

    }
}
