using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using hotel3g.Models;
using WeiXin.Common;
using System.Data;
using HotelCloud.SqlServer;
 

namespace hotel3g.Controllers
{




    public class HomeController : Controller
    {

        private static System.Web.Caching.Cache cache = HttpRuntime.Cache;

        //
        // GET: /Home/

        public string Default(string id)
        {
            string msg = HotelCloud.Common.HCRequest.GetString("msg");
            return msg;
        }
        //weixinID={1}&userWeixinNO={2}&pos={3}
        public ActionResult Map(string hotelid, string weixinID, string userWeixinNO, string pos)
        {
            return Redirect(string.Format("http://hotel.weikeniu.com/Hotel/Map/{0}?weixinID={1}&userWeixinNO={2}&pos={3}", hotelid, weixinID, userWeixinNO, pos));
        }

        public ActionResult Index(string hotelid, string weixinID, string userWeixinNO, string pos)
        {
            return Redirect(string.Format("http://hotel.weikeniu.com/Hotel/Index/{0}?weixinID={1}&userWeixinNO={2}", hotelid, weixinID, userWeixinNO));
        }

        public ActionResult Info(string hotelid, string weixinID, string userWeixinNO, string pos)
        {
            return Redirect(string.Format("http://hotel.weikeniu.com/Hotel/Info/{0}?weixinID={1}&userWeixinNO={2}", hotelid, weixinID, userWeixinNO));
        }

        public ActionResult NewsList(string hotelid, string weixinID, string userWeixinNO, string pos)
        {
            return Redirect(string.Format("http://hotel.weikeniu.com/Hotel/NewsinfoList/{0}?weixinID={1}&userWeixinNO={2}", hotelid, weixinID, userWeixinNO));
        }

        public ActionResult Pic(string hotelid, string weixinID, string userWeixinNO, string pos)
        {
            return Redirect(string.Format("http://hotel.weikeniu.com/Hotel/Images/{0}?weixinID={1}&userWeixinNO={2}", hotelid, weixinID, userWeixinNO));
        }

        public ActionResult Maps(string hotelid, string weixinID, string userWeixinNO, string pos)
        {
            return Redirect(string.Format("http://hotel.weikeniu.com/Hotel/Map/{0}?weixinID={1}&userWeixinNO={2}", hotelid, weixinID, userWeixinNO));
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

        public ActionResult GetCouPon(string id)
        {
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinID = HotelCloud.Common.HCRequest.GetString("userWeiXinID");
            string couponID = HotelCloud.Common.HCRequest.GetString("couponid");
            string message = "";
            if (hotel3g.Models.CouPon.GetCouPon(weixinID, userweixinID, couponID, ref message))
            {
                return Json(new
                {
                    error = 0,
                    message = "领取成功！"
                });
            }
            else
            {
                if (string.IsNullOrEmpty(message))
                {
                    return Json(new
                    {
                        error = 1,
                        message = "领取失败,请联系我们！"
                    });
                }
            }
            return Json(new
            {
                error = 1,
                message = "领取失败,请联系我们！"
            });
        }
        [Models.Filter]
        public ActionResult CouPonInfo(string id)
        {
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinID = HotelCloud.Common.HCRequest.GetString("userWeiXinID");
            string couponID = HotelCloud.Common.HCRequest.GetString("couponid");
            ViewData["dt"] = hotel3g.Models.CouPon.LoadCouPon(weixinID, userweixinID, couponID);

            ViewData["weixinID"] = weixinID;
            ViewData["hId"] = id;
            ViewData["userWeiXinID"] = userweixinID;
            return View();
        }


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


            bool IsBranch = hotel3g.Models.DAL.BranchHelper.IsBranch(weixinID);
            ViewData["IsBranch"] = IsBranch;


          
          
            //读取模板style 0：默认 1：简约（Simple） 2：多彩（Colourful）
            hotel3g.Repository.WeiXinAppConfig Config = hotel3g.Repository.MemberHelper.GetHotelAppConfig(weixinID);


            if (Config.style >0)
            {
                //菜单栏
                List<MenuDictionaryResponse> MenuBarList = hotel3g.Models.MenuBarHelper.MenuBarList(Config.style, weixinID, hotel.Quanjing,userWeiXinID);

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
        public ActionResult MainTravel(string id)
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
                list = Advertisement.GetAdvertisementBySort(weixinID,0);
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


            bool IsBranch = hotel3g.Models.DAL.BranchHelper.IsBranch(weixinID);
            ViewData["IsBranch"] = IsBranch;



            string sql = "select weixinName from WeiXinNO with (nolock) where weixinId=@weixinId  ";
             ViewData["weixinname"]= SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()                
                    {{"weixinId",new DBParam(){ParamValue=weixinID}},

                });


            //读取模板style 0：默认 1：简约（Simple） 2：多彩（Colourful）
          //  hotel3g.Repository.WeiXinAppConfig Config = hotel3g.Repository.MemberHelper.GetHotelAppConfig(weixinID);


            //if (Config.style > 0)
            //{
            //    //菜单栏
            //    List<MenuDictionaryResponse> MenuBarList = hotel3g.Models.MenuBarHelper.MenuBarList(Config.style, weixinID, hotel.Quanjing);

            //    ViewData["MenuBarList"] = MenuBarList;

            //    hotel = HotelHelper.GetMainIndexHotel(Convert.ToInt32(id));
            //    ViewData["HotelInfo"] = hotel;
            //}


            //if (!string.IsNullOrEmpty(hotel.MainPic))
            //{
            //    switch (Config.style)
            //    {
            //        case 0: return View();
            //        case 1: return View("Simple");
            //        case 2: return View("Colourful");
            //        case 3: return View("MiniSimple");
            //        case 4: return View("MiniColourful");
            //        case 5: return View("Dynamic");
            //        default: return View();
            //    }
            //}


            //int count = 0;
            //ProductEntityList list_products = new ProductEntityList();
            //var dt = CommodityService.GetSaleProductsListIndex(weixinID, out count, 1, 99, "", "");
            //list_products.ProductEntity_List = ProductEntity.ConvertProductEntityIndexListMall(dt);
            //list_products.Count = count;
            //ViewData["products"] = list_products.ProductEntity_List;


            //string traveledition = string.Empty;
            //string sql = "select traveledition  from WeiXinNO with (nolock) where weixinId=@weixinId  ";
            //DataTable db_open = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()                
            //        {{"weixinId",new DBParam(){ParamValue=weixinID}},
                   
            //    });

            //if (db_open.Rows.Count > 0)
            //{
            //    traveledition = db_open.Rows[0]["traveledition"].ToString();
            //}
            //ViewData["traveledition"] = traveledition;


            ViewData["CommodityTypeTable"] = CommodityService.GetCommodityTypeByWeixinId(weixinID, "","");

            DataTable commodityDataTable = CommodityService.GetCommodityList("", "", "", "", "", "", "",1, weixinID, id, false);

            ViewData["commodityDataTable"] = commodityDataTable;

            return View();
        }
    }
}
