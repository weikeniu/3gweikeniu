using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using hotel3g.Models;
using System.Data;
using System.Web.Script.Serialization;
using WeiXin.Common;
using WeiXin.Models.Home;
using hotel3g.Common;

namespace hotel3g.Controllers
{
    public class TravelAgencyController : Controller
    {
        SupermarketOrderService orderService = new SupermarketOrderService();
        //
        // GET: /TravelAgency/

        [Models.Filter]
        public ActionResult Index()
        {
            return View();
        }

        [Models.Filter]
        public ActionResult ShoppingMall(string id)
        {
            string hotelId = id;
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            string search = HotelCloud.Common.HCRequest.GetString("MallSearch");
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }
            //促销显示
            var pList = CommodityService.GetSaleProductsListToList(weixinid, search,"","");
            ViewData["products"] = pList;

            ViewData["MallSearch"] = search;
            ViewData["hotelId"] = id;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            ViewData["CommodityTypeTable"] = CommodityService.GetCommodityTypeByWeixinId(weixinid, "", search);
            ViewData["CommodityAllTypeTable"] = CommodityService.GetCommodityTypeByWeixinId(weixinid, "", "");
            ViewData["CommodityExtensionTable"] = CommodityService.GetCommodityExtensionByWeixinId(weixinid);
            return View();
        }

        [Models.Filter]
        public ActionResult ShoppingMallByLingZong(string id)
        {
            string hotelId = id;
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            string search = HotelCloud.Common.HCRequest.GetString("MallSearch");
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }
            //促销显示
            var pList = CommodityService.GetSaleProductsListToList(weixinid, search, "", "");
            ViewData["products"] = pList;

            ViewData["MallSearch"] = search;
            ViewData["hotelId"] = id;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            ViewData["CommodityTypeTable"] = CommodityService.GetCommodityTypeByWeixinId(weixinid, "", search);
            ViewData["CommodityAllTypeTable"] = CommodityService.GetCommodityTypeByWeixinId(weixinid, "", "");
            ViewData["CommodityExtensionTable"] = CommodityService.GetCommodityExtensionByWeixinId(weixinid);
            return View();
        }

        [Models.Filter]
        public ActionResult ShoppingMallByType(string id)
        {
            string hotelId = id;
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            string type = HotelCloud.Common.HCRequest.GetString("type");
            string search = HotelCloud.Common.HCRequest.GetString("MallSearch");
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }

            ViewData["MallSearch"] = search;
            ViewData["type"] = type;
            ViewData["hotelId"] = id;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;

            //if (!string.IsNullOrWhiteSpace(type))
            //{
            //    ViewData["CommodityTypeSubitemTable"] = CommodityService.GetCommodityTypeByWeixinId(weixinid, type, search);
            //}
            //else
            //{
            //    ViewData["CommodityTypeSubitemTable"] = CommodityService.GetCommodityTypeByWeixinId(weixinid, search);
            //}
            //ViewData["CommodityTypeSubitemTable"] = CommodityService.GetCommodityTypeByWeixinId(weixinid, type, search);
            return View();
        }

        [Models.Filter]
        public ActionResult ShoppingMallByNearby(string id)
        {
            string hotelId = id;
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            string type = HotelCloud.Common.HCRequest.GetString("type");
            string search = HotelCloud.Common.HCRequest.GetString("MallSearch");
            string cityName = HotelCloud.Common.HCRequest.GetString("cityName");
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }

            ViewData["MallSearch"] = search;
            ViewData["type"] = type;
            ViewData["hotelId"] = id;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            //if (!string.IsNullOrWhiteSpace(type))
            //{
            //    ViewData["CommodityTypeSubitemTable"] = CommodityService.GetCommodityTypeByWeixinId(weixinid, type, search);
            //}
            //else
            //{
            //    ViewData["CommodityTypeSubitemTable"] = CommodityService.GetCommodityTypeByWeixinId(weixinid, search);
            //}
            //ViewData["CommodityTypeSubitemTable"] = CommodityService.GetCommodityTypeByWeixinId(weixinid, type, search, cityName);
            return View();
        }

        [Models.Filter]
        public ActionResult CommodityDetail(string id) {

            string hotelId = id;
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string commodityId = HotelCloud.Common.HCRequest.GetString("CommodityID");//商品id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }
            ViewData["myPoints"] = 0;
            var userDt = orderService.GetScoreByUser(weixinid, userweixinid);
            if (userDt.Rows.Count > 0)
            {
                ViewData["myPoints"] = userDt.Rows[0]["Emoney"];
            }
            var DataTable = CommodityService.GetDataById(commodityId);

            ViewData["CommodityID"] = commodityId;
            ViewData["soldCount"] = SupermarketOrderDetailService.GetSoldCount(commodityId).Rows[0][0];
            ViewData["hotelId"] = id;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            ViewData["commodityTable"] = DataTable;
            return View();
        }

        [Models.Filter]
        public ActionResult SelectCity(string id) {

            string hotelId = id;
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }

            ViewData["hotelId"] = id;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            return View();
        }

        /// <summary>
        /// 获取商品信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult GetCommodityInfo(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinid = HotelCloud.Common.HCRequest.GetString("userweixinID");
            string MallSearch = HotelCloud.Common.HCRequest.GetString("MallSearch");
            string type = HotelCloud.Common.HCRequest.GetString("type");
            string sort = HotelCloud.Common.HCRequest.GetString("sort");
            string price = HotelCloud.Common.HCRequest.GetString("price");
            string selectCity = HotelCloud.Common.HCRequest.GetString("selectCity");
            string cityName = HotelCloud.Common.HCRequest.GetString("cityName");
            string subitem = HotelCloud.Common.HCRequest.GetString("subitem");
            int curpage = HotelCloud.Common.HCRequest.getInt("curpage");
            int pagesize = HotelCloud.Common.HCRequest.getInt("pagesize");
            if (pagesize < 1) {
                pagesize = 6;
            }
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }
            DataTable commodityDataTable = CommodityService.GetCommodityList(sort, MallSearch, type, price, subitem, selectCity,cityName, curpage, weixinid, id, false, pagesize);
            return Json(new
            {
                data = SerializeDataTable(commodityDataTable)
            }, JsonRequestBehavior.AllowGet);

        }

        /// <summary>
        /// 获取商品地址
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult GetDataTravelAgencyCommdityLocat(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinid = HotelCloud.Common.HCRequest.GetString("userweixinID");
            string type = HotelCloud.Common.HCRequest.GetString("type");
            string MallSearch = HotelCloud.Common.HCRequest.GetString("MallSearch");
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }
            DataTable commodityDataTable = CommodityService.GetDataTravelAgencyCommdityLocat(weixinid, type, MallSearch);
            return Json(new
            {
                data = SerializeDataTable(commodityDataTable)
            }, JsonRequestBehavior.AllowGet);

        }

        /// <summary>
        /// 获取搜索结果类型选项
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult GetSearchCommdityType(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinid = HotelCloud.Common.HCRequest.GetString("userweixinID");
            string MallSearch = HotelCloud.Common.HCRequest.GetString("MallSearch");
            string type = HotelCloud.Common.HCRequest.GetString("type");
            string cityName = HotelCloud.Common.HCRequest.GetString("cityName");
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }
            DataTable commodityDataTable = CommodityService.GetCommodityTypeByWeixinId(weixinid, type, MallSearch, cityName);
            return Json(new
            {
                data = SerializeDataTable(commodityDataTable)
            }, JsonRequestBehavior.AllowGet);

        }

        /// <summary>
        /// 获取促销产品信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult GetSaleProductsListToList(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }
            string MallSearch = HotelCloud.Common.HCRequest.GetString("MallSearch");
            string cityName = HotelCloud.Common.HCRequest.GetString("cityName");
            string price = HotelCloud.Common.HCRequest.GetString("price");
            var pList = CommodityService.GetSaleProductsListToList(weixinid, MallSearch, cityName, price);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            return Json(new
            {
                data = serializer.Serialize(pList)
            }, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// 获取商品信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult GetCommodityInfoMain(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinid = HotelCloud.Common.HCRequest.GetString("userweixinID");
            string MallSearch = HotelCloud.Common.HCRequest.GetString("MallSearch");
            string type = HotelCloud.Common.HCRequest.GetString("type");
            string sort = HotelCloud.Common.HCRequest.GetString("sort");
            string price = HotelCloud.Common.HCRequest.GetString("price");
            string selectCity = HotelCloud.Common.HCRequest.GetString("selectCity");
            string cityName = HotelCloud.Common.HCRequest.GetString("cityName");
            string subitem = HotelCloud.Common.HCRequest.GetString("subitem");
            int curpage = HotelCloud.Common.HCRequest.getInt("curpage");
            int pagesize = HotelCloud.Common.HCRequest.getInt("pagesize");
            int dataCount = HotelCloud.Common.HCRequest.getInt("dataCount");
            if (pagesize < 1)
            {
                pagesize = 6;
            }
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }
            DataTable commodityDataTable = CommodityService.GetCommodityListMain(sort, MallSearch, type, price, subitem, selectCity,cityName, curpage, weixinid, id, false, ref dataCount,pagesize);
            return Json(new
            {
                dataCount = dataCount,
                data = SerializeDataTable(commodityDataTable)
            }, JsonRequestBehavior.AllowGet);

        }

        /// <summary>DataTable序列化

        /// </summary>

        /// <param name="dt"></param>

        /// <returns></returns>

        public string SerializeDataTable(DataTable dt)
        {

            JavaScriptSerializer serializer = new JavaScriptSerializer();

            List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();

            foreach (DataRow dr in dt.Rows)//每一行信息，新建一个Dictionary<string,object>,将该行的每列信息加入到字典
            {

                Dictionary<string, object> result = new Dictionary<string, object>();

                foreach (DataColumn dc in dt.Columns)
                {

                    result.Add(dc.ColumnName, dr[dc].ToString());

                }

                list.Add(result);

            }

            return serializer.Serialize(list);//调用Serializer方法 

        }
    }
}
