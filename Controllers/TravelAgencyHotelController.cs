using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using hotel3g.Models.Home;
using HotelHotel.Utility;
using HotelCloud.Common;
using WxPayAPI;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Net;
using System.Security.Cryptography;
using hotel3g.Models;

namespace hotel3g.Controllers
{
    /// <summary>
    /// 旅行社酒店
    /// </summary>
    public class TravelAgencyHotelController : Controller
    {
        TravelAgencyHotel taHotelService = new TravelAgencyHotel();
        
        //
        // GET: /TravelAgencyHotel/

        public ActionResult Index(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            var hotelWxId = key.Split('@')[0];
            var userWxId = key.Split('@')[1];
            var adList = Advertisement.GetAdvertisementBySort(hotelWxId, 1);
            if (adList.Count <= 0)
            {
                //创建虚拟
                string[] imgs = { "/img/ad_01.jpg", "/img/ad_02.jpg", "/img/ad_03.jpg", "/img/ad_04.jpg", "/img/ad_05.jpg" };
                string imgwebsite = System.Configuration.ConfigurationManager.AppSettings["imgwebsite"] == null ? "http://admin.weikeniu.com" : System.Configuration.ConfigurationManager.AppSettings["imgwebsite"].ToString();
                foreach (string str in imgs)
                {
                    adList.Add(new Advertisement() { ImageUrl = imgwebsite + str });
                }
            }
            ViewData["hId"] = id;
            ViewData["adImgs"] = adList;
            ViewData["userWxId"] = userWxId;
            ViewData["hotelWxId"] = hotelWxId;
            ViewData["key"] = key;
            ViewData["defCity"] = taHotelService.GetSumTopCityForHotel(hotelWxId);
            return View();
        }

        public ActionResult List()
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string qJson = HotelCloud.Common.HCRequest.GetString("qJson");
            var hQuery = Newtonsoft.Json.JsonConvert.DeserializeObject<TravelAgencyHotelQuery>(qJson);
            if (hQuery == null) 
            {
                hQuery = new TravelAgencyHotelQuery() //无条件则查询附近数据
                { 
                    QType = 0,
                    InRoomDate = DateTime.Now.ToString("yyyy-MM-dd"),
                    LvRoomDate =DateTime.Now.AddDays(1).ToString("yyyy-MM-dd") 
                };
            }
            hQuery.HotelWxId = key.Split('@')[0];
            hQuery.UserWxId = key.Split('@')[1];
            ViewData["hQuery"] = hQuery;
            ViewData["defCityId"] = taHotelService.GetSumTopCityForHotel(hQuery.HotelWxId).First().Key;
            return View();
        }

        /// <summary>
        /// 获取搜索结果
        /// </summary>
        /// <param name="hQuery"></param>
        /// <returns></returns>
        public JsonResult GetHotelSeachRes(TravelAgencyHotelQuery hQuery) 
        {
            var seachRes = taHotelService.GetHotelSeachRes(hQuery);
            return Json(seachRes, JsonRequestBehavior.AllowGet);
        }
        /// <summary>
        /// 获取该酒店下所有分店的品牌、商圈、行政区的条件ids
        /// </summary>
        /// <returns></returns>
        public JsonResult GetHasHotelConditionIDs(string hotelWxId) 
        {
            var idsDic = taHotelService.GetHasHotelConditionIDs(hotelWxId);
            return Json(JsonConvert.SerializeObject(idsDic), JsonRequestBehavior.AllowGet);
        }
    }
}
