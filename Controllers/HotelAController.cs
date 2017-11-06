using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Peer._128uu.Public;
using hotel3g.Models;
using System.Text;
using HotelCloud.Common;
using System.Data.SqlClient;
using System.Data;
using hotel3g.Common;
using Newtonsoft.Json.Linq;
using System.Collections;
using WeiXin.Models;
using HotelCloud.SqlServer;
using hotel3g.Models.Home;
using WeiXin.Common;

namespace hotel3g.Controllers
{
    public class HotelAController : Controller
    {



        [Models.Filter]
        //酒店全景
        public ActionResult QuanJing(string id)
        {
            Hotel hotel = Cache.GetHotel(Convert.ToInt32(id));
            ViewData["hotel"] = hotel.SubName;
            ViewData["quanjing"] = hotel.Quanjing;

            return View();
        }


        [Models.Filter]
        public ActionResult Index(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelWeixinid = string.Empty;
            string userWeixinid = string.Empty;
            if (!string.IsNullOrEmpty(key) && key.Contains("@"))
            {
                List<string> list = key.Split('@').ToList();
                hotelWeixinid = list[0];
                userWeixinid = list[1];
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeixinid, 30, hotelWeixinid);
                ViewData["hotelWeixinid"] = hotelWeixinid;
                ViewData["userWeixinid"] = userWeixinid;
                ViewData["generatesign"] = WeiXin.Common.ValidateSignProduct.GenerateSign(hotelWeixinid, userWeixinid);
            }
            int hid = Convert.ToInt32(id);
            ViewData["hid"] = hid;
            string firstimgurl = null;
            string MemberCardRuleJson = ActionController.getMemberCardIntegralRule(userWeixinid, hotelWeixinid);
            ViewData["MemberCardRuleJson"] = MemberCardRuleJson;
            Hashtable MemberCardRuleJsonobj = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJson);
            Hashtable ruletable = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJsonobj["rule"].ToString());
            double graderate = WeiXinPublic.ConvertHelper.ToDouble(ruletable["GradeRate"]);
            ViewData["graderate"] = graderate;

            double reduce = WeiXinPublic.ConvertHelper.ToDouble(ruletable["Reduce"]);
            ViewData["reduce"] = reduce;

            int couponType = WeiXinPublic.ConvertHelper.ToInt(ruletable["CouponType"]);
            ViewData["couponType"] = couponType;

            DateTime beginTime = DateTime.Now.Date;
            DateTime endTime = DateTime.Now.AddDays(1).Date;

            //if (DateTime.Now.Hour >= 14)
            //{
            //    beginTime = DateTime.Now.AddDays(1).Date;
            //    endTime = DateTime.Now.AddDays(2).Date;
            //}

            ViewData["beginTime"] = beginTime;
            ViewData["endTime"] = endTime;

            ViewData["ratejson"] = ActionController.getratejson(hid, beginTime, endTime, hotelWeixinid, graderate, out firstimgurl, reduce, couponType);
            Models.Hotel hotel = ActionController.gethotelinfo(hid, hotelWeixinid);
            ViewData["hotel"] = hotel;
            ViewData["firstimgurl"] = firstimgurl;





            //string commentopen = string.Empty;
            //string membershow = string.Empty;
            //string dingfangmember = string.Empty;

            //string sql = "select comment,showmemberprice,dingfang_MemberOnly from WeiXinNO with (nolock) where weixinId=@weixinId  ";
            //DataTable db_open = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()                
            //        {{"weixinId",new DBParam(){ParamValue=hotelWeixinid}},
                   
            //    });

            //if (db_open.Rows.Count > 0)
            //{
            //    commentopen = db_open.Rows[0]["comment"].ToString();
            //    membershow = db_open.Rows[0]["showmemberprice"].ToString();
            //    dingfangmember = db_open.Rows[0]["dingfang_MemberOnly"].ToString();
            //}

            //ViewData["commentopen"] = commentopen;
            //ViewData["membershow"] = membershow;
            //ViewData["dingfangmember"] = dingfangmember;




            ModuleAuthorityResponse ModuleAuthority = hotel3g.Models.DAL.AuthorityHelper.ModuleAuthority(hotelWeixinid);
            ViewData["commentopen"] = ModuleAuthority.comment;
            ViewData["membershow"] = ModuleAuthority.membership_price;
            ViewData["dingfangmember"] = ModuleAuthority.membership_room;

            BaseHotelCommentInfo baseHotelCommentInfo = new BaseHotelCommentInfo();
            if (ModuleAuthority.comment == 1)
            {
                Comment comment = new Comment();
                baseHotelCommentInfo = comment.GetBaseInfo(hid);
            }
            ViewData["baseHotelCommentInfo"] = baseHotelCommentInfo;


            var memberCardCustomList = new List<Models.Home.MemberCardCustom>();
            var memberinfo = new Repository.MemberInfo();
            if (ModuleAuthority.membership_price ==1)
            {               
                memberinfo = hotel3g.Repository.MemberHelper.GetMemberInfo(hotelWeixinid);
                if (memberinfo == null)
                {
                    memberinfo = new Repository.MemberInfo();
                }
            }

              int ismember = Convert.ToBoolean(MemberCardRuleJsonobj["becomeMember"].ToString()) ? 0 : 1;

              //配置显示会员价或领取会员卡
              if (ismember == 0 || ModuleAuthority.membership_price == 1)
              {
                  int customcount = 0;
                  DataTable db_CardCustom = MemberCardCustom.GetMemberCardCustomList(hotelWeixinid, out customcount, 1, 50, "", "");
                  memberCardCustomList = DataTableToEntity.GetEntities<Models.Home.MemberCardCustom>(db_CardCustom).ToList();
              }


            ViewData["customlist"] = memberCardCustomList;
            ViewData["memberinfo"] = memberinfo;


            return View();
        }


        //订单提交界面显示
        [Models.Filter]     
        public ActionResult Fillorder(string id)
        {
            ViewData["hid"] = id;
            string orderjson = HCRequest.GetString("orderjson");
            string key = HotelCloud.Common.HCRequest.GetString("key");
            if (string.IsNullOrEmpty(orderjson))
            {
                return Redirect(string.Format("/hotelA/index/{0}?key={1}", id, key));
            }


            //Hashtable orderjsondic = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(orderjson);

            //int roomId = Convert.ToInt32(orderjsondic["roomid"]);
            //int rateplanId = Convert.ToInt32(orderjsondic["rateplanid"]);

            //string sql = "select ratejson,updatetime from hotelratejson with (nolock) where hotelid=@hotelid";
            //DataTable db = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            //{
            //    {"hotelid",new DBParam(){ParamValue=id.ToString()}}
            //});

            //string ratejson = db.Rows[0]["ratejson"].ToString();
            //var roomlist = Newtonsoft.Json.JsonConvert.DeserializeObject<List<WeiXin.Models.Home.Room>>(ratejson);

            //List<WeiXin.Models.Home.RatePlan> rateplanList = new List<WeiXin.Models.Home.RatePlan>();
            //roomlist.ForEach(r => { rateplanList.AddRange(r.RateplanList); });
            //WeiXin.Models.Home.RatePlan rateplan = rateplanList.Where(c => c.ID == rateplanId).FirstOrDefault();

            //if (rateplan == null)
            //{
            //    rateplan = new WeiXin.Models.Home.RatePlan();
            //    rateplan.RateList = new List<WeiXin.Models.Home.Rate>();
            //}

            //rateplan.RateList = rateplan.RateList.Where(c => Convert.ToDateTime(c.Dates).Date >= DateTime.Now.Date && c.Price > 0 && c.Available == 1).ToList();

            //sql = "select  *  from roomstock with (nolock) where hid=@hotelid  and   stockdate>= CONVERT(date,GETDATE())";
            //DataTable tb = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            //{
            //    {"hotelid",new DBParam(){ParamValue=id.ToString()}}
            //});

            //var list_RoomStock = WeiXin.Common.DataTableToEntity.GetEntities<WeiXin.Models.Home.RoomStock>(tb).ToList();



            //rateplan.RateList.ForEach(r =>
            //{
            //    var curr_stock = list_RoomStock.Where(c => c.Rid == rateplan.RoomID && c.StockDate == Convert.ToDateTime(r.Dates)).FirstOrDefault();
            //    r.RoomStock = curr_stock == null ? 19 : (curr_stock.Quantity - curr_stock.HaveSale > 0 ? curr_stock.Quantity - curr_stock.HaveSale : 0);
            //});

            //if (rateplan.IsOverBook == 1)
            //{
            //    rateplan.RateList.ForEach(c => { c.RoomStock = 99; });
            //}

            //rateplan.RateList = rateplan.RateList.Where(c => c.RoomStock > 0).ToList();

            //ViewData["ratelistjson"] = Newtonsoft.Json.JsonConvert.SerializeObject(rateplan.RateList);
            return View();
        }


       //获取房型报价列表
        [Models.Filter]
        [HttpPost]
        public ActionResult GetRoomPriceList(string id)
        {
           
            string orderjson = HCRequest.GetString("orderjson");
            string key = HotelCloud.Common.HCRequest.GetString("key");


            int roomId = HCRequest.getInt("roomId");
            int rateplanId = HCRequest.getInt("rateplanId");

            string sql = "select ratejson,updatetime from hotelratejson with (nolock) where hotelid=@hotelid";
            DataTable db = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                {"hotelid",new DBParam(){ParamValue=id.ToString()}}
            });

            string ratejson = db.Rows[0]["ratejson"].ToString();
            var roomlist = Newtonsoft.Json.JsonConvert.DeserializeObject<List<WeiXin.Models.Home.Room>>(ratejson);

            List<WeiXin.Models.Home.RatePlan> rateplanList = new List<WeiXin.Models.Home.RatePlan>();
            roomlist.ForEach(r => { rateplanList.AddRange(r.RateplanList); });
            WeiXin.Models.Home.RatePlan rateplan = rateplanList.Where(c => c.ID == rateplanId).FirstOrDefault();

            if (rateplan == null)
            {
                rateplan = new WeiXin.Models.Home.RatePlan();
                rateplan.RateList = new List<WeiXin.Models.Home.Rate>();
            }

            rateplan.RateList = rateplan.RateList.Where(c => Convert.ToDateTime(c.Dates).Date >= DateTime.Now.Date && c.Price > 0 && c.Available == 1).ToList();

            sql = "select stockdate, rid, quantity,actualqty,havesale  from roomstock with (nolock) where hid=@hotelid  and   stockdate>= CONVERT(date,GETDATE())";
            DataTable tb = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                {"hotelid",new DBParam(){ParamValue=id.ToString()}}
            });

            var list_RoomStock = WeiXin.Common.DataTableToEntity.GetEntities<WeiXin.Models.Home.RoomStock>(tb).ToList();



            rateplan.RateList.ForEach(r =>
            {
                var curr_stock = list_RoomStock.Where(c => c.Rid == rateplan.RoomID && c.StockDate == Convert.ToDateTime(r.Dates)).FirstOrDefault();
                r.RoomStock = curr_stock == null ? 19 : (curr_stock.Quantity - curr_stock.HaveSale > 0 ? curr_stock.Quantity - curr_stock.HaveSale : 0);
            });

            if (rateplan.IsOverBook == 1)
            {
                rateplan.RateList.ForEach(c => { c.RoomStock = 99; });
            }

            rateplan.RateList = rateplan.RateList.Where(c => c.RoomStock > 0).ToList();

            return Json(new
            {
                Data = Newtonsoft.Json.JsonConvert.SerializeObject(rateplan.RateList)               
            }, JsonRequestBehavior.AllowGet);
          
        }

        [Models.Filter]
        public ActionResult Info(string id)
        {
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            if (!userWeiXinID.Equals(""))
            {
                weixinid = userWeiXinID.Split('@')[0];
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, weixinid);
            }
            Hotel hotel = Cache.GetHotel(Convert.ToInt32(id));
            ViewData["userWeiXinID"] = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinid);
            ViewData["hotel"] = hotel;
            ViewData["image"] = Img.GetHotelImage(3, hotel.ID);

            //[{name:"广州火车站",juli:8},{name:"白云国际机场28",juli:25},{name:"北京路238",juli:2}]
            string fujin = string.Empty;
            string round = hotel.RoundValue;
            round = "{\"RoundValue\":" + round + "}";
            round = round.Replace("name", "\"name\"").Replace("juli", "\"juli\"");

            //var json =JObject.Parse(round);
            //foreach (var item in json["RoundValue"])
            //{
            //    string name = ((item as JContainer)["name"] as JValue).Value.ToString();
            //    string juli = (item as JContainer)["juli"].ToString();
            //    fujin += string.Format("{0}（{1}公里）；", name, juli);
            //}
            ViewData["fujin"] = fujin;
            ViewData["HotelPictures"] = hotel3g.Common.HotelImage.Assembly(HotelHelper.GetHotelRoomImages(WeiXinPublic.ConvertHelper.ToInt(id)));
            return View();
        }

        /*2017-Haven*/
        /// <summary>
        /// 地图
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult Map(string id)
        {
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (!userWeiXinID.Equals(""))
            {
                weixinid = userWeiXinID.Split('@')[0];
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, weixinid);
            }
            Hotel hotel = Cache.GetHotel(Convert.ToInt32(id));
            ViewData["weixinId"] = weixinid;
            ViewData["userWeiXinID"] = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinid);
            ViewData["hotel"] = hotel;
            ViewData["hId"] = id;
            ViewData["key"] = userWeiXinID;
            return View();
        }

        /// <summary>
        /// 活动列表
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult NewsinfoList(string id)
        {
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (!userWeiXinID.Equals(""))
            {
                weixinid = userWeiXinID.Split('@')[0];
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, weixinid);
            }
            ViewData["userWeiXinID"] = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinid);
            Hotel hotel = Cache.GetHotel(Convert.ToInt32(id));
            ViewData["hotel"] = hotel;
            int temPage = 0, pageCount = 0;
            List<hotel3g.Models.HotelNews> hotelnews = hotel3g.Models.HotelHelper.PageNewList(10, 1, id, "id", out temPage, out pageCount);

            ViewData["pagecount"] = pageCount;
            ViewData["news"] = hotelnews;
            ViewData["sumpage"] = temPage;
            return View();
        }

        /// <summary>
        /// 活动内容
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult NewsInfo(string id)
        {
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            string nid = HCRequest.GetString("nid");
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            if (!userWeiXinID.Equals(""))
            {
                weixinid = userWeiXinID.Split('@')[0];
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, userWeiXinID.Split('@')[0]);
                if (string.IsNullOrEmpty(nid))
                {
                    nid = userWeiXinID.Split('@')[2];
                }
            }
            if (string.IsNullOrEmpty(nid))
                return base.RedirectToAction("NewsinfoList", "Hotel");
            int preid, nextid;
            ViewData["HotelNewsinfo"] = HotelHelper.GetNewsDetails(nid, out preid, out nextid, id);
            ViewData["HotelNewsID"] = nid;
            ViewData["preid"] = nextid;
            ViewData["nextid"] = preid;
            Hotel hotel = Cache.GetHotel(Convert.ToInt32(id));
            ViewData["hotel"] = hotel;

            ViewData["userWeiXinID"] = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinid);
            string s = hotel3g.Models.HotelHelper.getTemp(weixinid);
            return View();
        }

        [Models.Filter]
        public ActionResult HotelService(string id)
        {
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (!userWeiXinID.Equals(""))
            {
                weixinid = userWeiXinID.Split('@')[0];
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, weixinid);
            }
            ViewData["weixinID"] = weixinid;
            ViewData["hId"] = id;
            ViewData["userWeiXinID"] = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinid);

            ViewData["hotel"] = hotel3g.Common.FacilityImages.GetHotel(HotelHelper.GetHotelService(WeiXinPublic.ConvertHelper.ToInt(id)));
            ViewData["facImagfe"] = hotel3g.Common.FacilityImages.Assembly(HotelHelper.GetHotelFacilityImages(WeiXinPublic.ConvertHelper.ToInt(id)));
            return View();
        }
        /// <summary>
        /// 抽奖列表
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult PrizeSports(string id)
        {
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");

            string uxid = string.Empty;
            if (!userWeiXinID.Equals(""))
            {
                weixinid = userWeiXinID.Split('@')[0];
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, userWeiXinID.Split('@')[0]);
                uxid = userWeiXinID.Split('@')[1];
            }
            ViewData["weixinID"] = weixinid;
            ViewData["hId"] = id;
            ViewData["userWeiXinID"] = uxid;// hotel3g.Models.Cookies.GetCookies("userWeixinNO");
            int count = 0;
            int pagesize = 10;
            ViewData["data"] = PrizeMsgWrapper.Assembly(WeiXin.Models.DAL.Activity.FetchActivity(weixinid, pagesize, 1, out count));
            ViewData["count"] = count;
            ViewData["sumpage"] = count % pagesize == 0 ? count / pagesize : count / pagesize + 1;

            List<hotel3g.Repository.RandomLuckyDrawClass> HotelLuckyDraws = hotel3g.Repository.RandomLuckyDrawHelper.GetRandomLuckyDrawList(0, weixinid);
            ViewData["HotelLuckyDraws"] = HotelLuckyDraws;

            return View();
        }



        #region post操作




        [HttpPost]
        [Models.Filter]
        public ActionResult GetUserRatePlan(string id)
        {

            int status = -1;
            string msg = string.Empty;

            double price = 0;
            int available = 0;
            WeiXin.Models.Home.RatePlan ratePlan = new WeiXin.Models.Home.RatePlan();

            try
            {

                string key = HCRequest.GetString("key");
                string hotelweixinId = key.Split('@')[0];
                string userweixinId = key.Split('@')[1];

                int hid = Convert.ToInt32(RouteData.Values["Id"]);
                string roomId = HCRequest.GetString("roomId");
                string rateplanId = HCRequest.GetString("rateplanId");

                string roomTypeId = roomId + "_" + rateplanId;

                DateTime indate = Convert.ToDateTime(HCRequest.GetString("indate")).Date;
                DateTime outdate = Convert.ToDateTime(HCRequest.GetString("outdate")).Date;

                int days = (outdate - indate).Days;
                int hourRoom = Convert.ToInt32(HCRequest.GetString("ishourRoom"));


                string MemberCardRuleJson = ActionController.getMemberCardIntegralRule(userweixinId, hotelweixinId);
                ViewData["MemberCardRuleJson"] = MemberCardRuleJson;
                Hashtable MemberCardRuleJsonobj = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJson);
                Hashtable ruletable = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJsonobj["rule"].ToString());
                double graderate = WeiXinPublic.ConvertHelper.ToDouble(ruletable["GradeRate"]);
                ViewData["graderate"] = graderate;


                double reduce = WeiXinPublic.ConvertHelper.ToDouble(ruletable["Reduce"]);
                ViewData["reduce"] = reduce;

                int couponType = WeiXinPublic.ConvertHelper.ToInt(ruletable["CouponType"]);
                ViewData["couponType"] = couponType;

                string firstimgurl = null;
                string ratejson = ActionController.getratejson(hid, indate, outdate, hotelweixinId, graderate, out firstimgurl, reduce, couponType);

                Hashtable ratejsonobj = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(ratejson);
                List<WeiXin.Models.Home.Room> roomlist = Newtonsoft.Json.JsonConvert.DeserializeObject<List<WeiXin.Models.Home.Room>>(ratejsonobj["roomlist"].ToString());
                Dictionary<string, Hashtable> hourroomRates = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, Hashtable>>(ratejsonobj["hourroomRates"].ToString());
                Dictionary<string, Hashtable> roomRates = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, Hashtable>>(ratejsonobj["roomRates"].ToString());

                if (hourRoom == 1)
                {
                    price = Convert.ToDouble(hourroomRates[roomTypeId]["Price"]);
                    available = Convert.ToInt32(hourroomRates[roomTypeId]["Available"]);
                    ratePlan = roomlist.Where(c => c.ID.ToString() == roomId).FirstOrDefault().RateplanList.Where(c => c.ID.ToString() == rateplanId).FirstOrDefault();

                }


                else
                {
                    price = Convert.ToDouble(roomRates[roomTypeId]["Price"]) * days;
                    available = Convert.ToInt32(roomRates[roomTypeId]["Available"]);
                    ratePlan = roomlist.Where(c => c.ID.ToString() == roomId).FirstOrDefault().RateplanList.Where(c => c.ID.ToString() == rateplanId).FirstOrDefault();
                }

                if (price > 0 && available > 0 && ratePlan.RateList.Count > 0)
                {
                    status = 0;
                }

            }


            catch
            {

            }


            return Json(new
            {
                Price = price,
                Rateplanjson = Newtonsoft.Json.JsonConvert.SerializeObject(ratePlan),
                Status = status,
                Mess = msg
            }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        [Models.Filter]
        public ContentResult saveorderinfo()
        {
            try
            {
                Dictionary<string, object> result = new Dictionary<string, object>();

                string source = "weixinweb";
                string saveinfo = HCRequest.GetString("saveinfo");
                Hashtable saveinfotable = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(saveinfo);
                DateTime now = DateTime.Now;
                string orderno = string.Format("w{0}", now.ToString("yyMMddHHmmssfff"));
                string weixinid = saveinfotable["weixinid"].ToString();
                string userWeixinid = saveinfotable["userWeixinid"].ToString();

                int couponid = Convert.ToInt32(saveinfotable["couponid"]);
                if (couponid > 0)
                {
                    bool couPonEnable = WeiXin.Models.Home.CouPonContent.IsCouPonContentEnable(weixinid, userWeixinid, couponid);
                    if (!couPonEnable)
                    {
                        result.Add("success", false);
                        result.Add("message", "红包已被使用，不能再次使用");
                        string _json = Newtonsoft.Json.JsonConvert.SerializeObject(result);
                        return Content(_json);
                    }

                }

                string token = saveinfotable["token"].ToString();
                string sourceorderid = null;
                try
                {
                    sourceorderid = hotel3g.Models.DES.DESDecrypt(token, "wkn128uu");
                }
                catch (Exception)
                {
                    sourceorderid = DateTime.Now.ToString("yyyyMMddHHmmssffff");
                }



                var tgyModel = hotel3g.Models.MemberFxLogic.GetTuiGuangProfit(ProfitType.kefang, weixinid, userWeixinid, Convert.ToInt32(saveinfotable["ssumprice"])); 

                SQLMerge.MergeScript script = new SQLMerge.MergeScript("hotelorder");
                script.AddInsertField("OrderNO").AddInsertField("LinkTel").AddInsertField("UserName").AddInsertField("UserWeiXinID").AddInsertField("HotelID").AddInsertField("HotelName").AddInsertField("WeiXinID").AddInsertField("RoomID").AddInsertField("RoomName").AddInsertField("demo").AddInsertField("RatePlanID").AddInsertField("RatePlanName").AddInsertField("yRoomNum").AddInsertField("yinDate").AddInsertField("youtDate").AddInsertField("Ordertime").AddInsertField("PayType").AddInsertField("lastTime").AddInsertField("state").AddInsertField("yPriceStr").AddInsertField("ySumPrice").AddInsertField("sSumPrice").AddInsertField("fpSubmitPrice").AddInsertField("Source").AddInsertField("jifen").AddInsertField("ishourroom").AddInsertField("hourstarttime").AddInsertField("hourendtime").AddInsertField("foregift").AddInsertField("foregiftstate")
    .AddInsertField("needinvoice").AddInsertField("invoicestate").AddInsertField("invoicetitle").AddInsertField("CouponInfo").AddInsertField("sourceorderid").AddInsertField("UserID").AddInsertField("isMeeting").AddInsertField("promoterid").AddInsertField("fxCommission").AddInsertField("fxmoneyprofit").AddInsertField("invoicenum");
                script.AddCriteria("Source").AddCriteria("sourceorderid");

                string yPriceStr = string.Empty;
                List<string> priceAry = saveinfotable["priceAry"].ToString().Split(new string[] { "|" }, StringSplitOptions.RemoveEmptyEntries).ToList();
                foreach (string item in priceAry)
                {
                    DateTime time = WeiXinPublic.ConvertHelper.ToDateTime(item.Remove(item.IndexOf(":")));
                    int price = WeiXinPublic.ConvertHelper.ToInt(item.Substring(item.IndexOf(":") + 1));
                    yPriceStr += string.Format("price{0}|{1}|money{0}|0|", time.ToString("yyyy-MM-dd"), price);
                }
                int fpSubmitPrice = 0;
                int sSumPrice = 0;
                int paytype = Convert.ToInt32(saveinfotable["paytype"]);
                if (paytype == 1)
                {
                    fpSubmitPrice = Convert.ToInt32(saveinfotable["ssumprice"]);
                }
                else
                {
                    sSumPrice = Convert.ToInt32(saveinfotable["ssumprice"]);
                }
                int ishourroom = Convert.ToInt32(saveinfotable["ishourroom"]);
                string hourstarttime = null;
                string hourendtime = null;
                string lasttime = null;
                if (ishourroom == 1)
                {
                    hourstarttime = saveinfotable["hourstarttime"].ToString();
                    hourendtime = saveinfotable["hourendtime"].ToString();
                }
                else
                {
                    lasttime = saveinfotable["lasttime"].ToString();
                }
                int needinvoice = Convert.ToInt32(saveinfotable["needinvoice"]);
                string invoicetitle = null;
                string invoicenum = null;
                if (needinvoice == 1)
                {
                    invoicetitle = saveinfotable["invoicetitle"].ToString();
                    invoicenum = saveinfotable["invoicenum"].ToString();
                }
                string demo = null;
                if (!saveinfotable["demo"].ToString().Equals("无"))
                {
                    demo = saveinfotable["demo"].ToString();
                }
             
                Dictionary<string, object> CouponInfoDic = new Dictionary<string, object>();
                if (couponid > 0)
                {
                    CouponInfoDic.Add("CouponId", couponid);
                    CouponInfoDic.Add("CouPon", Convert.ToInt32(saveinfotable["couponprice"]));
                }

                object gradename = saveinfotable["gradename"];
                int isvip = WeiXinPublic.ConvertHelper.ToInt(saveinfotable["isvip"]);
                //会员专享不能享受打折优惠，只有为非会员专享时才添加折扣信息
                if (isvip != 1)
                {
                    double graderate = WeiXinPublic.ConvertHelper.ToDouble(saveinfotable["graderate"]);
                    CouponInfoDic.Add("GradeRate", graderate);
                    CouponInfoDic.Add("Reduce", WeiXinPublic.ConvertHelper.ToDouble(saveinfotable["reduce"]));
                }
                CouponInfoDic.Add("GradeName", gradename == null ? string.Empty : gradename.ToString());
                CouponInfoDic.Add("IsVip", isvip);

                CouponInfoDic.Add("CouponType", WeiXinPublic.ConvertHelper.ToInt(saveinfotable["coupontype"]));

                string couponinfo = Newtonsoft.Json.JsonConvert.SerializeObject(CouponInfoDic);
                int jifen = WeiXinPublic.ConvertHelper.ToInt(saveinfotable["jifen"]);
                DateTime indate = WeiXinPublic.ConvertHelper.ToDateTime(saveinfotable["yindate"]);
                DateTime outdate = WeiXinPublic.ConvertHelper.ToDateTime(saveinfotable["youtdate"]);

                int ismeeting = 0;
                if (saveinfotable["ismeeting"] != null)
                {
                    ismeeting = Convert.ToInt32(saveinfotable["ismeeting"]);
                }


                Dictionary<string, object> dic = new Dictionary<string, object>();
                dic.Add("OrderNO", orderno);
                dic.Add("LinkTel", saveinfotable["linktel"].ToString());
                dic.Add("UserName", saveinfotable["username"].ToString());
                dic.Add("UserWeiXinID", userWeixinid);
                dic.Add("HotelID", saveinfotable["hotelid"].ToString());
                dic.Add("HotelName", saveinfotable["hotelname"].ToString());
                dic.Add("WeiXinID", weixinid);
                dic.Add("UserID", 0);
                dic.Add("RoomID", saveinfotable["roomid"].ToString());
                dic.Add("RoomName", saveinfotable["roomname"].ToString());
                dic.Add("demo", demo);
                dic.Add("RatePlanID", saveinfotable["rateplanid"].ToString());
                dic.Add("RatePlanName", saveinfotable["rateplanname"].ToString());
                dic.Add("yRoomNum", saveinfotable["yroomnum"].ToString());
                dic.Add("yinDate", indate.ToString());
                dic.Add("youtDate", outdate.ToString());
                dic.Add("Ordertime", now);
                dic.Add("PayType", paytype);
                dic.Add("lastTime", lasttime);
                dic.Add("state", 1);    //待处理
                dic.Add("yPriceStr", yPriceStr);
                dic.Add("ySumPrice", Convert.ToInt32(saveinfotable["originalsaleprice"]));
                dic.Add("sSumPrice", sSumPrice);
                dic.Add("fpSubmitPrice", fpSubmitPrice);
                dic.Add("Source", source);
                dic.Add("jifen", jifen);
                dic.Add("ishourroom", saveinfotable["ishourroom"].ToString());
                dic.Add("hourstarttime", hourstarttime);
                dic.Add("hourendtime", hourendtime);
                dic.Add("foregift", saveinfotable["foregift"]);
                dic.Add("foregiftstate", 1);
                dic.Add("needinvoice", needinvoice);
                dic.Add("invoicetitle", invoicetitle);
                dic.Add("invoicestate", 1);
                dic.Add("CouponInfo", couponinfo);
                dic.Add("sourceorderid", sourceorderid);
                dic.Add("ismeeting", ismeeting);
                dic.Add("promoterid", tgyModel.promoterid);
                dic.Add("fxCommission", tgyModel.hotelCommission);
                dic.Add("fxmoneyprofit", tgyModel.userCommission);
                dic.Add("invoicenum", invoicenum);
                script.ListValues.Add(dic);
                string sql = script.SQL();
                
                int rows = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), null);
                result.Add("success", rows > 0);
                if (rows > 0)
                {
                    sql = "select id from hotelorder with (nolock) where source=@source and sourceorderid=@sourceorderid";
                    int orderid = WeiXinPublic.ConvertHelper.ToInt(SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"source",new DBParam(){ParamValue=source}},
                        {"sourceorderid",new DBParam(){ParamValue=sourceorderid}}
                    }));
                    if (couponid > 0)
                    {
                        if (orderid > 0)
                        {
                            sql = "update couponcontent set isemploy=1,employtime=@time,orderid=@orderid where id=@couponid and weixinid=@weixinid and userweixinno=@userweixinid";
                            SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                            {
                                {"time",new DBParam(){ParamValue=now.ToString()}},
                                {"orderid",new DBParam(){ParamValue=orderid.ToString()}},
                                {"couponid",new DBParam(){ParamValue=couponid.ToString()}},
                                {"weixinid",new DBParam(){ParamValue=weixinid}},
                                {"userweixinid",new DBParam(){ParamValue=userWeixinid}}
                            });
                        }
                    }
                    if (jifen > 0)
                    {
                        //sql = "update Member set Emoney+=@Emoney where weixinID=@weixinID and userWeiXinNO=@userWeiXinNO";
                        //int rs = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                        //{
                        //    {"Emoney",new DBParam(){ParamValue=jifen.ToString()}},
                        //    {"weixinID",new DBParam(){ParamValue=weixinid}},
                        //    {"userWeiXinNO",new DBParam(){ParamValue=userWeixinid}},
                        //});

                        string cardno = saveinfotable["cardno"] == null ? string.Empty : saveinfotable["cardno"].ToString();
                        string memberid = saveinfotable["memberid"] == null ? string.Empty : saveinfotable["memberid"].ToString();
                        sql = "insert into jifendetail (weixinid,userweixinid,jifen,addtime,orderid,night,cardno,userid) values (@weixinid,@userweixinid,@jifen,@addtime,@orderid,@night,@cardno,@userid)";
                        int rs = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                        {
                            {"weixinid",new DBParam(){ParamValue=weixinid}},
                            {"userweixinid",new DBParam(){ParamValue=userWeixinid}},
                            {"jifen",new DBParam(){ParamValue=jifen.ToString()}},
                            {"addtime",new DBParam(){ParamValue=DateTime.Now.ToString()}},
                            {"orderid",new DBParam(){ParamValue=orderid.ToString()}},
                            {"night",new DBParam(){ParamValue=(outdate-indate).Days.ToString()}},
                            {"cardno",new DBParam(){ParamValue=cardno}},
                            {"userid",new DBParam(){ParamValue=memberid}},
                        });
                    }

                    //新旧版会议都是调用此方法下单
                    if (ismeeting == 0)
                    {
                        int roomstock = MemberCardBuyRecord.ReduceRoomStock(Convert.ToInt32(saveinfotable["hotelid"].ToString()), Convert.ToInt32(saveinfotable["roomid"].ToString()), indate, outdate, Convert.ToInt32(saveinfotable["yroomnum"].ToString()));
                    }

                    result.Add("message", "提交成功！");
                    result.Add("orderno", orderno);
                    result.Add("orderid", orderid);
                }
                else
                {
                    sql = "select count(1) from hotelorder with (nolock) where source=@source and sourceorderid=@sourceorderid";
                    int c = WeiXinPublic.ConvertHelper.ToInt(SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"source",new DBParam(){ParamValue=source}},
                        {"sourceorderid",new DBParam(){ParamValue=sourceorderid}}
                    }));
                    result.Add("message", c > 0 ? "已存在订单不要重复提交！" : "提交失败！");
                }

                string json = Newtonsoft.Json.JsonConvert.SerializeObject(result);
                return Content(json);
            }
            catch (Exception ex)
            {
                Dictionary<string, object> result = new Dictionary<string, object>();
                result.Add("message", ex.Message + ex.StackTrace);
                result.Add("success", false);
                string json = Newtonsoft.Json.JsonConvert.SerializeObject(result);
                return Content(json);
            }
        }


        #endregion

    }
}
