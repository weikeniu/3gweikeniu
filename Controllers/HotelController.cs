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
using hotel3g.Models.Home;
using System.IO;
using HotelCloud.SqlServer;
using WeiXin.Common;
using Newtonsoft.Json;

namespace hotel3g.Controllers
{
    public class HotelController : Controller
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



        //提交订单操作
        [HttpPost]
        [Models.Filter]
        public JsonResult SetFillorder(string method)
        {
            //string HotelID = HCRequest.GetString("hotelid");
            //string RoomID = HCRequest.GetString("roomid");
            //string RatePlanID = HCRequest.GetString("rateplanid");
            //string yinDate = HCRequest.GetString("indate");
            //string youtDate = HCRequest.GetString("outdate");
            //string yRoomNum = HCRequest.GetString("roomnum");
            //string UserName = HCRequest.GetString("username");
            //string LinkTel = HCRequest.GetString("linktel");
            string userweixinID = HCRequest.GetString("userweixinid");
            string weixinid = HCRequest.GetString("weixinid");
            string giftCouponid = HCRequest.GetString("giftcoupon");



            //string couponid = HCRequest.GetString("coupon");
            //string sumprice = HCRequest.GetString("sumprice");
            //string netPrice = HCRequest.GetString("netPrice");
            //string numPrice = HCRequest.GetString("RealPrice");

            string UserName = HCRequest.GetString("username");
            UserName = UserName.Remove(UserName.Length - 1, 1);

            HotelOrder hotelorder = new HotelOrder()
            {
                HotelID = Convert.ToInt32(HCRequest.GetString("hotelid")),
                RoomID = HCRequest.GetString("roomid"),
                RatePlanID = HCRequest.GetString("rateplanid"),
                YinDate = Convert.ToDateTime(HCRequest.GetString("indate")),
                YoutDate = Convert.ToDateTime(HCRequest.GetString("outdate")),
                YRoomNum = Convert.ToInt32(HCRequest.GetString("roomnum")),
                UserName = UserName,
                LinkTel = HCRequest.GetString("linktel"),
                UserWeiXinID = userweixinID,
                CouponID = HCRequest.GetString("couponid"),
                sSumPrice = Convert.ToInt32(HCRequest.GetString("sumprice")),
                NetPrice = Convert.ToInt32(HCRequest.GetString("netPrice")),
                RealPrice = Convert.ToInt32(HCRequest.GetString("RealPrice")),
                PayType = HCRequest.GetString("paytype"),
                memberid = HCRequest.GetString("memberid")

            };

            string message = string.Empty;
            if (WeiXinPublic.ConvertHelper.ToInt(giftCouponid) > 0)
            {
                if (!hotel3g.Models.CouPon.GetCouPon(weixinid, userweixinID, giftCouponid, ref message))
                {
                    giftCouponid = "0";
                }
            }

            UserGuarantee uguarantee = null;

            if (HCRequest.GetString("bankType") != "0")
            {
                int temp = 0;
                string cvv = HCRequest.GetString("bankCVV");
                if (!int.TryParse(cvv, out temp))
                {
                    cvv = temp.ToString();
                };

                string validTime = HCRequest.GetString("validTime");
                if (int.TryParse(validTime, out temp))
                {
                    DateTime dt = new DateTime(Convert.ToInt32(("20" + validTime.Substring(2, 2))), Convert.ToInt32(validTime.Substring(0, 2)), 1);
                    dt = dt.AddMonths(1).AddDays(-1);
                    validTime = dt.ToString();
                }
                else
                {
                    validTime = "";
                }
                uguarantee = new UserGuarantee()
                {
                    HotelId = HCRequest.GetString("hotelid"),
                    BankType = HCRequest.GetString("bankType"),
                    BankCardNo = HCRequest.GetString("bankCardNo"),
                    BankCVV = cvv,
                    ValidTime = validTime,
                    Cardholder = HCRequest.GetString("cardholder"),
                    IdentityCard = HCRequest.GetString("identityCard"),
                    IdentityType = HCRequest.GetString("identityType")
                };
            }

            string lastTime = HCRequest.GetString("lastTime");
            string ishourroom = HCRequest.GetString("ishourroom");
            string WeiXinID = HCRequest.GetString("weixinid");

            string res = "", did = "";
            hotel3g.Models.HotelHelper.OrderSave(hotelorder, uguarantee, ishourroom, lastTime, WeiXinID, out res, out did);


            //插入会员折扣 优惠券 信息
            if (!string.IsNullOrEmpty(did) && res.Equals("true"))
            {
                string[] UseCoupon = HCRequest.GetString("UseCoupon").Split('@');
                string[] MemberRate = HCRequest.GetString("MemberRate").Split('@');
                try
                {
                    decimal erro;
                    if (decimal.TryParse(MemberRate[1], out erro))
                    {
                        hotel3g.Repository.PreferentialInformationItemClass InformationItem = new Repository.PreferentialInformationItemClass();
                        InformationItem.Coupon = string.IsNullOrEmpty(UseCoupon[1]) ? 0 : int.Parse(UseCoupon[1]);
                        InformationItem.CouponId = string.IsNullOrEmpty(UseCoupon[0]) ? 0 : int.Parse(UseCoupon[0]);
                        InformationItem.GradeName = MemberRate[0];
                        InformationItem.GradeRate = string.IsNullOrEmpty(MemberRate[1]) ? 0 : decimal.Parse(MemberRate[1]);
                        InformationItem.OrderNo = did.Trim();
                        int Count = hotel3g.Repository.MemberHelper.InsertPreferentialInformation(InformationItem);
                    }
                }
                catch { }
            }


            return Json(new { ok = res, message = did, giftid = giftCouponid });
        }
        [Models.Filter]
        //订单提交界面显示
        public ActionResult Fillorder(string id)
        {
            ViewData["hid"] = id;
            string orderjson = HCRequest.GetString("orderjson");
            string key = HotelCloud.Common.HCRequest.GetString("key");
            if (string.IsNullOrEmpty(orderjson))
            {
                return Redirect(string.Format("/hotel/index/{0}?key={1}", id, key));
            }
            return View();
        }
        [Models.Filter]
        //酒店图集显示
        public ActionResult Images(string id)
        {
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            if (!userWeiXinID.Equals(""))
            {
                weixinid = userWeiXinID.Split('@')[0];
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, weixinid);
            }
            Hotel hotel = Cache.GetHotel(Convert.ToInt32(id));
            ViewData["hotel"] = hotel;
            ViewData["weixinID"] = weixinid;
            ViewData["hId"] = id;
            ViewData["userWeiXinID"] = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinid);

            ViewData["HotelPictures"] = hotel3g.Common.HotelImage.Assembly(HotelHelper.GetHotelRoomImages(WeiXinPublic.ConvertHelper.ToInt(id)));
            return View();

        }

        [Models.Filter]
        public ActionResult PicInfo(string id)
        {
            ViewData["HotelPictures"] = HotelHelper.GetHotelPictures(id);
            string url = HCRequest.GetString("surl").Split('@')[0];
            string weixinid = HCRequest.GetString("surl").Split('@')[1];
            Hotel hotel = Cache.GetHotel(Convert.ToInt32(id));
            ViewData["hotel"] = hotel;
            ViewData["url"] = url;
            ViewData["weixinid"] = weixinid;
            return View();
        }
        [Models.Filter]
        //酒店详细新闻
        public ActionResult Newsinfo(string id)
        {
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");

            int error = 0;
            string nid = HCRequest.GetString("nid");

            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            if (!userWeiXinID.Equals(""))
            {
                weixinid = userWeiXinID.Split('@')[0];
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, userWeiXinID.Split('@')[0]);
            }
            if (string.IsNullOrEmpty(nid) || !int.TryParse(nid, out error))
            {
                return base.RedirectToAction("NewsinfoList", "Hotel", new { id = id, key = userWeiXinID });
            }
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
        //酒店新闻列表显示
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


            int type = 0;
            int.TryParse(Request.QueryString["type"], out type);

            List<hotel3g.Models.HotelNews> hotelnews = hotel3g.Models.HotelHelper.PageNewList(10, 1, id, "id", out temPage, out pageCount, type);

            ViewData["pagecount"] = pageCount;
            ViewData["news"] = hotelnews;
            ViewData["sumpage"] = temPage;



            return View();
        }

        public ActionResult FetchNewinfoList()
        {
            int hid = HotelCloud.Common.HCRequest.getInt("hid", 0);
            int page = HotelCloud.Common.HCRequest.getInt("page", 1);
            if (page <= 0) page = 1;
            int pagesize = HotelCloud.Common.HCRequest.getInt("pagesize", 10);
            int sumpage = 0;
            int count = 0;
            List<hotel3g.Models.HotelNews> hotelnews = hotel3g.Models.HotelHelper.PageNewList(pagesize, page, hid.ToString(), "id", out sumpage, out count);
            return Json(new
            {
                data = hotelnews,
                sumpage = sumpage,
                count = count,
                page = page
            }, JsonRequestBehavior.AllowGet);
        }

        [Models.Filter]
        //订单提交成功界面
        public ActionResult SucOrder(string id)
        {
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            //string s = hotel3g.Models.HotelHelper.getTemp(weixinid);
            return View();
            //if (!s.Equals("1"))
            //{
            //    return View();
            //}
            //else
            //{
            //    return View("SucOrder_New");
            //}
        }

        //获取酒店新闻信息列表
        [Models.Filter]
        public string GetNewsList(string id)
        {
            try
            {
                string hid = id, res = "";
                int page = Convert.ToInt32(HCRequest.GetString("page", "1"));
                int temPage = 0, pageCount = 0;
                List<hotel3g.Models.HotelNews> hotelnews = hotel3g.Models.HotelHelper.PageNewList(10, page, hid, "id", out temPage, out pageCount);
                ListChangeToJson.ListChangeToJson classJson = new ListChangeToJson.ListChangeToJson();
                if (temPage == 0) return "{" + "\"ok\":" + "\"false\"}";
                res = classJson.ArrayToJsonAll(hotelnews, "data");
                return "{" + "\"count\":" + temPage.ToString() + "," + res.Substring(1); ;
            }
            catch { return "{" + "\"ok\":" + "\"false\"}"; }
        }

        //
        // GET: /Hotel/
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

            string gradeName = WeiXinPublic.ConvertHelper.ToString(ruletable["GradeName"]);
            ViewData["gradeName"] = gradeName;

            DateTime indate = DateTime.Now.Date;
            DateTime outdate = DateTime.Now.AddDays(1).Date;
            if (!string.IsNullOrEmpty(HCRequest.GetString("indate")) && !string.IsNullOrEmpty(HCRequest.GetString("outdate")))
            {
                if (HCRequest.getDate("outdate").Date <= DateTime.Now.Date.AddMonths(2))
                {
                    indate = HCRequest.getDate("indate");
                    outdate = HCRequest.getDate("outdate");
                }
            }


            ViewData["indate"] = indate;
            ViewData["outdate"] = outdate;


            ViewData["ratejson"] = ActionController.getratejson(hid, indate, outdate, hotelWeixinid, graderate, out firstimgurl, reduce, couponType);
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

            //控制弹窗
            ViewData["memberbasics"] = ModuleAuthority.module_memberbasics;

            BaseHotelCommentInfo baseHotelCommentInfo = new BaseHotelCommentInfo();
            if (ModuleAuthority.comment==1)
            {
                Comment comment = new Comment();
                baseHotelCommentInfo = comment.GetBaseInfo(hid);
            }
            ViewData["baseHotelCommentInfo"] = baseHotelCommentInfo;



            var memberCardCustomList = new List<Models.Home.MemberCardCustom>();
            var memberinfo = new Repository.MemberInfo();
            if (ModuleAuthority.membership_price == 1)
            {
                memberinfo = hotel3g.Repository.MemberHelper.GetMemberInfo(hotelWeixinid);
                if (memberinfo == null)
                {
                    memberinfo = new Repository.MemberInfo();
                }
            }

            int ismember = Convert.ToBoolean(MemberCardRuleJsonobj["becomeMember"].ToString()) ? 0 : 1;
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


        

        [Models.Filter]
        public ActionResult IndexTravel(string id)
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
            return View();
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
            ViewData["image"] = WeiXin.Models.Img.GetHotelImage(3, hotel.ID);

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

            return View();
        }

        //清理缓存
        public string ClearCache()
        {
            string hotelID = HCRequest.GetString("hotelid");
            string roomID = HCRequest.GetString("roomid");
            string type = HCRequest.GetString("clearType");

            if (type.Equals("hotel"))
            {
                string cacheKey = string.Format("s{0}", Cache.GetCacheName(Convert.ToInt32(hotelID)));
                Cache.SetCache(cacheKey, new Hotel(), -1);
            }

            if (type.Equals("room"))
            {
                Cache.SetRoomsCache(string.Format("rooms_{0}", hotelID), string.Empty, -1);
                Cache.RemoveCache(string.Format("simpleroom_{0}", roomID));
            }
            return string.Empty;
        }

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
            //string s = hotel3g.Models.HotelHelper.getTemp(weixinid);
            Hotel hotel = Cache.GetHotel(Convert.ToInt32(id));
            ViewData["weixinId"] = weixinid;
            ViewData["userWeiXinID"] = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinid);
            ViewData["hotel"] = hotel;
            ViewData["hId"] = id;
            ViewData["key"] = userWeiXinID;
            //if (!s.Equals("1"))
            //{
            return View();
            //}
            //else
            //{
            //    return View("Map_New");
            //}
        }

        #region 新地图
        [Models.Filter]
        public ActionResult Map2(string id)
        {
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (!userWeiXinID.Equals(""))
            {
                weixinid = userWeiXinID.Split('@')[0];
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, weixinid);
            }
            //string s = hotel3g.Models.HotelHelper.getTemp(weixinid);
            Hotel hotel = Cache.GetHotel(Convert.ToInt32(id));
            ViewData["weixinId"] = weixinid;
            ViewData["userWeiXinID"] = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinid);
            ViewData["hotel"] = hotel;
            ViewData["hId"] = id;
            ViewData["key"] = userWeiXinID;

            return View();
        }

        #endregion

        /// <summary>
        /// 仅供地图展示 无需校验
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult MapView(string id)
        {
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");

            Hotel hotel = Cache.GetHotel(Convert.ToInt32(id));
            ViewData["weixinId"] = weixinid;
            ViewData["hotel"] = hotel;
            ViewData["hId"] = id;

            return View();

        }

        /// <summary>
        /// 酒店设施服务
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
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

        public ActionResult FetchPrizeSports()
        {
            string weixinId = HotelCloud.Common.HCRequest.GetString("wx");
            int page = HotelCloud.Common.HCRequest.getInt("page", 1);
            if (page <= 0) page = 1;
            int pagesize = HotelCloud.Common.HCRequest.getInt("pagesize", 10);
            int sumpage = 0;
            int count = 0;
            IList<PrizeMsgWrapper> mlist = PrizeMsgWrapper.Assembly(WeiXin.Models.DAL.Activity.FetchActivity(weixinId, pagesize, 1, out count));
            sumpage = count % pagesize == 0 ? count / pagesize : count / pagesize + 1;
            return Json(new
            {
                data = mlist,
                sumpage = sumpage,
                count = count,
                page = page
            }, JsonRequestBehavior.AllowGet);
        }

        [Models.Filter]
        public ActionResult BookList(string id)
        {
            //string key = HotelCloud.Common.HCRequest.GetString("key");
            //string hotelWeixinid = string.Empty;
            //string userWeixinid = string.Empty;
            //if (!string.IsNullOrEmpty(key) && key.Contains("@"))
            //{
            //    List<string> list = key.Split('@').ToList();
            //    hotelWeixinid = list[0];
            //    userWeixinid = list[1];
            //    hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeixinid, 30, hotelWeixinid);
            //    ViewData["hotelWeixinid"] = hotelWeixinid;
            //    ViewData["userWeixinid"] = userWeixinid;
            //    ViewData["generatesign"] = WeiXin.Common.ValidateSignProduct.GenerateSign(hotelWeixinid, userWeixinid);
            //}
            //int hid = Convert.ToInt32(id);
            //ViewData["hid"] = hid;
            //string firstimgurl = null;
            //ViewData["ratejson"] = ActionController.getratejson(hid, DateTime.Now.Date, DateTime.Now.AddDays(1).Date, hotelWeixinid, out firstimgurl);
            //ViewData["MemberCardRuleJson"] = ActionController.getMemberCardIntegralRule(userWeixinid, hotelWeixinid);
            //Models.Hotel hotel = ActionController.gethotelinfo(hid, hotelWeixinid);
            //ViewData["hotel"] = hotel;
            //ViewData["firstimgurl"] = firstimgurl;
            return View();
        }

        [Models.Filter]
        public ActionResult PayOrder(string id)
        {
            string orderjson = HCRequest.GetString("orderjson");
            return View();
        }

        [Models.Filter]
        public ActionResult roomlistindex(string id)
        {
            int hid = HCRequest.getInt("hid");
            DateTime indate = HCRequest.getDate("indate");
            DateTime outdate = HCRequest.getDate("outdate");
            string hotelweixinid = HCRequest.GetString("hotelweixinid");
            double graderate = WeiXinPublic.ConvertHelper.ToDouble(HCRequest.GetClearStr("graderate"));
            double reduce = WeiXinPublic.ConvertHelper.ToDouble(HCRequest.GetString("reduce"));
            int couponType = WeiXinPublic.ConvertHelper.ToInt(HCRequest.GetString("coupontype"));
            string gradename = HCRequest.GetString("gradename");
            string membershow = HCRequest.GetString("membershow");

            string dingfangmember = HCRequest.GetString("dingfangmember");
            int ismember = WeiXinPublic.ConvertHelper.ToInt(HCRequest.GetString("ismember")); ;

            var memberCardCustomList = new List<Models.Home.MemberCardCustom>();
            var memberinfo = new Repository.MemberInfo();
            if (membershow == "1")
            {
                memberinfo = hotel3g.Repository.MemberHelper.GetMemberInfo(hotelweixinid);
                if (memberinfo == null)
                {
                    memberinfo = new Repository.MemberInfo();
                }
            }

            if (ismember == 0 || membershow == "1")
            {
                int customcount = 0;
                DataTable db_CardCustom = MemberCardCustom.GetMemberCardCustomList(hotelweixinid, out customcount, 1, 50, "", "");
                memberCardCustomList = DataTableToEntity.GetEntities<Models.Home.MemberCardCustom>(db_CardCustom).ToList();
            }



            ViewData["customlist"] = memberCardCustomList;
            ViewData["memberinfo"] = memberinfo;

            ViewData["membershow"] = membershow;


            string ratejson = ActionController.getratejson(hid, indate, outdate, hotelweixinid, graderate, reduce, couponType);
            ViewData["ratejson"] = ratejson;
            ViewData["graderate"] = graderate;

            ViewData["reduce"] = reduce;
            ViewData["coupontype"] = couponType;
            ViewData["gradename"] = gradename;


            ViewData["dingfangmember"] = dingfangmember;
            ViewData["ismember"] = ismember;



            return View();
        }

        #region 评价
        Comment commentService = new Comment();
        [HttpGet]
        public ActionResult Comment()
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            int hotelID = Convert.ToInt32(RouteData.Values["Id"]);
            int orderID = HCRequest.getInt("orderID", 0);
            if (commentService.CurrUserIsComment(hotelID, orderID))
            {
                return RedirectToAction("CommentList/" + hotelID);
            }
            else
            {
                ViewData["hotelID"] = hotelID;
                ViewData["userWeixinID"] = userweixinId;
                ViewData["hotelWeixinID"] = hotelweixinId;
                ViewData["roomType"] = HCRequest.GetString("RoomType", "");
                ViewData["orderID"] = orderID;
                return View();
            }
        }
        /// <summary>
        /// 评价
        /// </summary>
        /// <param name="comment"></param>
        /// <returns></returns>
        [HttpPost]
        public JsonResult Comment(Comment comment)
        {
            if (comment.HotelID > 0 && comment.OrderID > 0 && !string.IsNullOrEmpty(comment.UserWeixinID) && !string.IsNullOrEmpty(comment.HotelWeixinID) && !string.IsNullOrEmpty(comment.Content))
            {
                comment.AvgScore = (decimal)Math.Round((comment.HealthServiceScore + comment.AttitudeServiceScore + comment.FacilityServiceScore + comment.NetworkServiceScore) / 4.0, 1);
                comment.IsShow = true;
                commentService.CommentHotel(comment);
                return Json(new { state = 0, msg = "评价成功!" });
            }
            return Json(new { state = -1, msg = "评价失败!请稍后重试!" });
        }
        /// <summary>
        /// 酒店评价列表
        /// </summary>
        /// <returns></returns>
        public ActionResult CommentList()
        {
            int qFlag = HCRequest.getInt("qFlag", 0);//0全部1有图
            int hotelID = Convert.ToInt32(RouteData.Values["Id"]);//HCRequest.getInt("hotelID", 0);
            int page = HCRequest.getInt("page", 1);
            int pageSize = HCRequest.getInt("pageSize", 10);
            var cBaseInfo = commentService.GetBaseInfo(hotelID);
            if (qFlag == 1)
                ViewData["models"] = cBaseInfo.Comments.Where(c => !string.IsNullOrWhiteSpace(c.Imgs)).Skip((page - 1) * pageSize).Take(pageSize).ToList();
            else
                ViewData["models"] = cBaseInfo.Comments.Skip((page - 1) * pageSize).Take(pageSize).ToList();
            ViewData["hssAvg"] = cBaseInfo.HSSAvg;//综合卫生评分
            ViewData["fssAvg"] = cBaseInfo.FSSAvg;
            ViewData["nssAvg"] = cBaseInfo.NSSAvg;
            ViewData["assAvg"] = cBaseInfo.ASSAvg;
            ViewData["allAvg"] = cBaseInfo.AllAvg;//综合评分
            ViewData["allcount"] = cBaseInfo.CommentAllCount;
            ViewData["hasPicCount"] = cBaseInfo.HasPicCount;//有图片评价数量
            ViewData["hotelID"] = hotelID;
            ViewData["qFlag"] = qFlag;
            ViewData["page"] = page;
            return View();
        }
        /// <summary>
        /// 滑动加载评价信息
        /// </summary>
        /// <returns></returns>
        public JsonResult GetComments()
        {
            int hotelID = HCRequest.getInt("hotelID", 0);
            int qFlag = HCRequest.getInt("qFlag", 0);
            int page = HCRequest.getInt("page", 1);
            int pageSize = HCRequest.getInt("pageSize", 10);
            var comments = new List<Comment>();
            if (qFlag == 1)
            {
                comments = commentService.GetListByHotelID(hotelID).Where(c => !string.IsNullOrWhiteSpace(c.Imgs)).Skip((page - 1) * pageSize).Take(pageSize).ToList();
            }
            else
            {
                comments = commentService.GetListByHotelID(hotelID).OrderByDescending(c => c.CreateTime).Skip((page - 1) * pageSize).Take(pageSize).ToList();
            }
            return Json(comments, JsonRequestBehavior.AllowGet);
        }
        /// <summary>
        /// 获取回复消息
        /// </summary>
        /// <param name="cId"></param>
        /// <returns></returns>
        public JsonResult GetReplyMsg(int cId)
        {
            return Json(new { replyMsg = commentService.GetReplyMsg(cId) }, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// 上传图片
        /// </summary>
        /// <param name="hotelID"></param>
        /// <returns></returns>
        public string UploadImg(int hotelID)
        {
            HttpPostedFileBase file = Request.Files["file"];
            if (file != null && !string.IsNullOrEmpty(file.FileName))
            {
                string Extension = Path.GetExtension(file.FileName).ToLower();
                ///判断图片类型
                if (Extension.Equals(".jpg") || Extension.Equals(".png"))
                {
                    byte[] imgByte = new byte[file.ContentLength];
                    file.InputStream.Read(imgByte, 0, file.ContentLength);
                    img.Upload up = new img.Upload();
                    string newFileName = string.Format("/img/{0}/", hotelID) + DateTime.Now.ToString("yyyyMMddHHmmss_ffff", System.Globalization.DateTimeFormatInfo.InvariantInfo) + Extension;

                    if (imgByte != null && up.UpLoadImg("uoeqoirw0934210890adsflad23", newFileName, imgByte))
                    {
                        return WeiXinPublic.ConfigManage.Get("ImageWebSite") + newFileName;
                    };
                }

            }
            return "#";
        }
        #endregion

        #region Wifi
        WxWifi wifiService = new WxWifi();
        /// <summary>
        /// 免费Wifi页面
        /// </summary>
        /// <returns></returns>
        public ActionResult ToFreeWifiPage(string id) 
        {
            var key = HotelCloud.Common.HCRequest.GetString("key");
            var hotelWxId = key.Split('@')[0];
            var userWxId = key.Split('@')[1];
            var v = HotelCloud.Common.HCRequest.getInt("v",0);//0旧版，1新版
            var passUrl = string.Empty;//认证请求地址
            var wifi = new WxWifi();
            var shop = new WxShop();
            var shops = wifiService.GetHasWifiShops(hotelWxId);
            if (shops.Count == 1) 
            {
                shop = shops[0];
                var wifis = wifiService.GetValidWifis(shop.ShopID);
                if (wifis.Count == 1) 
                {
                    wifi = wifis[0];//该公众号只有一个门店一个WIFI时，则直接展示操作图
                    if (wifi.ProtocolType == 31) 
                    {
                        passUrl = "http://192.168.1.1/cgi-bin/i_free.cgic?module=portal&op=change&passwd=" + MD5Encrypt32(wifi.PassPwd);
                    }
                }
            }
            ViewData["Ads"] = Advertisement.GetAdvertisementBySort(hotelWxId, 3);//广告//TODO
            ViewData["shops"] = shops;
            ViewData["wifiJson"] = JsonConvert.SerializeObject(wifi);//只有一个门店及WIFI
            ViewData["shopJson"] = JsonConvert.SerializeObject(shop);//只有一个门店
            ViewData["passUrl"] = passUrl;
            ViewData["sucRedirctUrl"] = v == 1 ? string.Format("/hotelA/Index/{0}?key={1}@{2}", id, hotelWxId, userWxId) : string.Format("/hotel/Index/{0}?key={1}@{2}", id, hotelWxId, userWxId);
            return View();
        }

        /// <summary>
        /// 免费WIFI页获取门店下所有WIFI
        /// </summary>
        /// <returns></returns>
        public JsonResult GetWiFiForFreeWifiPage()
        {
            int shopId = HCRequest.GetInt("shopId", 0);
            var wifis = wifiService.GetValidWifis(shopId);
            return Json(wifis, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// 获取认证地址
        /// </summary>
        /// <returns></returns>
        public JsonResult GetPassUrl() 
        {
            string passUrl = string.Empty;
            var wifi = wifiService.GetWifiById(HCRequest.GetInt("wifiId", 0));
            if (wifi.ProtocolType == 31 && !string.IsNullOrWhiteSpace(wifi.PassPwd)) 
            {
                passUrl = "http://192.168.1.1/cgi-bin/i_free.cgic?module=portal&op=change&passwd=" + MD5Encrypt32(wifi.PassPwd);
            }
            return Json(passUrl, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// md5加密32位
        /// </summary>
        /// <returns></returns>
        public string MD5Encrypt32(string content)
        {
            var md5 = System.Security.Cryptography.MD5.Create();
            var bs = md5.ComputeHash(Encoding.UTF8.GetBytes(content));
            var sb = new StringBuilder();
            foreach (byte b in bs)
            {
                sb.Append(b.ToString("x2"));
            }
            return sb.ToString();
        }
        #endregion
    }
}
