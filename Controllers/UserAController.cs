using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using HotelCloud.Common;
using System.Data;
using WeiXin.Models;
using hotel3g.Models;
using hotel3g.Repository;
using HotelCloud.SqlServer;
using WeiXin.Models.Home;
using hotel3g.Models.Home;
using WeiXin.Common;

namespace hotel3g.Controllers
{
    public class UserAController : Controller
    {

        [Models.Filter]
        public ActionResult MyBuy(string id)
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
            ViewData["weixinID"] = weixinID;
            ViewData["hId"] = id;
            userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            ViewData["userWeiXinID"] = userWeiXinID;
            return View();
        }


        [Models.Filter]
        public ActionResult MyInvoice(string id)
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
            ViewData["weixinID"] = weixinID;
            ViewData["hId"] = id;
            userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            ViewData["userWeiXinID"] = userWeiXinID;
            return View();
        }





        // GET: /User/
        [Models.Filter]//旧版 后续删除
        public ActionResult Index1(string id)
        {
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            string key = userWeiXinID;

            if (!userWeiXinID.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, userWeiXinID.Split('@')[0]);
            }
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = userWeiXinID.Split('@')[0];
                userWeiXinID = userWeiXinID.Split('@')[1];
            }
            else
            {
                userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            }
            string cardno = hotel3g.Repository.MemberHelper.GetCardNo(userWeiXinID, weixinID);
            if (string.IsNullOrEmpty(cardno))
            {
                return RedirectToAction("MemberRegister", "MemberCard", new { id = id, key = key });
            }
            hotel3g.Repository.MemberInfo Info = hotel3g.Repository.MemberHelper.GetMemberInfo(weixinID);



            ViewData["Info"] = Info;
            ViewData["weixinID"] = weixinID;
            ViewData["hId"] = id;
            ViewData["userWeiXinID"] = userWeiXinID;
            hotel3g.Common.UserInfo user = hotel3g.Common.UserInfo.Assembly(hotel3g.Models.User.GetUserInfo(weixinID, userWeiXinID));
            user.CouponMoney = hotel3g.Models.User.GetCouPonMoneys(weixinID, userWeiXinID);
            ViewData["data"] = user;

            hotel3g.Repository.MemberCard MyCard = hotel3g.Repository.MemberHelper.GetMemberCard(cardno, weixinID);

            MemberCardIntegralRule IntegralRule = MemberHelper.IntegralRule(Info, MyCard);
            ViewData["IntegralRule"] = IntegralRule;

            #region 获取用户微信头像
            if ((string.IsNullOrEmpty(MyCard.photo) || string.IsNullOrEmpty(MyCard.nickname)) && !string.IsNullOrEmpty(userWeiXinID))
            {
                AccessToken Token = MemberHelper.GetAccessToken(weixinID);

                if (Token.error == 1)
                {
                    hotel3g.Repository.WeiXinUserInfo WeiXinUserInfo = hotel3g.Repository.MemberHelper.GetUserWeixinInfo(Token.message, userWeiXinID);
                    MyCard.photo = WeiXinUserInfo.headimgurl;
                    hotel3g.Repository.MemberHelper.UpdateUserWeiXxinPhoto(weixinID, userWeiXinID, cardno, WeiXinUserInfo);
                }
            }
            #endregion

            ViewData["MyCard"] = MyCard;
            ViewData["cardno"] = cardno;
            string MemberRegister = string.Format("/MemberCard/MemberRegister/{0}?key={1}", id, key);
            string MemberCenterLogin = string.Format("/MemberCard/MemberCenterLogin/{0}?key={1}", id, key);
            string MemberCenterUrl = string.Format("/MemberCard/MemberCenter/{0}?key={1}", id, key);
            string LoginOut = string.Format("/MemberCard/LoginOut/{0}?key={1}", id, key);
            string PwdRest = string.Format("/MemberCard/PwdRest/{0}?key={1}", id, key);
            ViewData["PwdRest"] = PwdRest;


            ViewData["MemberRegister"] = MemberRegister;
            ViewData["MemberCenterLogin"] = MemberCenterLogin;
            ViewData["MemberCenterUrl"] = MemberCenterUrl;
            ViewData["LoginOut"] = LoginOut;
            return View();
        }

        // GET: /User/
        [Models.Filter]
        public ActionResult Index(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string[] keys = key.Split('@');
            if (!string.IsNullOrEmpty(key) && keys.Length == 2)
            {
                string weixinID = keys[0];
                string userWeiXinID = keys[1];

                string cardno = hotel3g.Repository.MemberHelper.GetCardNo(userWeiXinID, weixinID);
                if (string.IsNullOrEmpty(cardno))
                {
                    return RedirectToAction("MemberRegister", "MemberCardA", new { id = id, key = key });
                }
                hotel3g.Repository.MemberInfo Info = hotel3g.Repository.MemberHelper.GetMemberInfo(weixinID);
                ViewData["Info"] = Info;
                ViewData["weixinID"] = weixinID;
                ViewData["hId"] = id;
                ViewData["userWeiXinID"] = userWeiXinID;
                hotel3g.Common.UserInfo user = hotel3g.Common.UserInfo.Assembly(hotel3g.Models.User.GetUserInfo(weixinID, userWeiXinID));
                user.CouponMoney = hotel3g.Models.User.GetCouPonMoneys(weixinID, userWeiXinID);
                ViewData["data"] = user;

                hotel3g.Repository.MemberCard MyCard = hotel3g.Repository.MemberHelper.GetMemberCard(cardno, weixinID);
                MemberCardIntegralRule IntegralRule = MemberHelper.IntegralRule(Info, MyCard);
                ViewData["IntegralRule"] = IntegralRule;

                #region 获取用户微信头像
                if ((string.IsNullOrEmpty(MyCard.photo) || string.IsNullOrEmpty(MyCard.nickname)) && !string.IsNullOrEmpty(userWeiXinID))
                {
                    AccessToken Token = MemberHelper.GetAccessToken(weixinID);

                    if (Token.error == 1)
                    {
                        hotel3g.Repository.WeiXinUserInfo WeiXinUserInfo = hotel3g.Repository.MemberHelper.GetUserWeixinInfo(Token.message, userWeiXinID);
                        MyCard.photo = WeiXinUserInfo.headimgurl;
                        hotel3g.Repository.MemberHelper.UpdateUserWeiXxinPhoto(weixinID, userWeiXinID, cardno, WeiXinUserInfo);
                    }
                }
                #endregion

                ViewData["MyCard"] = MyCard;
                string MemberRegister = string.Format("/MemberCardA/MemberRegister/{0}?key={1}", id, key);
                string MemberCenterUrl = string.Format("/MemberCardA/MemberCenter/{0}?key={1}", id, key);
                string PwdRest = string.Format("/MemberCard/PwdRestA/{0}?key={1}", id, key);
                ViewData["PwdRest"] = PwdRest;
                ViewData["MemberRegister"] = MemberRegister;
                ViewData["MemberCenterUrl"] = MemberCenterUrl;


                ViewData["rechargeCount"] = RechargeCard.GeteRechargeCardCount(weixinID);


                int count = 0;
                DataTable db_CardCustom = MemberCardCustom.GetMemberCardCustomList(weixinID, out count, 1, 50, "", "");
                var memberCardCustomList = DataTableToEntity.GetEntities<Models.Home.MemberCardCustom>(db_CardCustom);
                ViewData["list"] = memberCardCustomList;
                bool HasSignFor_hongbao = MemberFxLogic.HasSignFor_hongbao(weixinID);
                ViewData["HasSignFor_hongbao"] = HasSignFor_hongbao;
             
            }

         
            return View();
        }

        [Models.Filter]
        public ActionResult UserInfo(string id)
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
            userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);




            ViewData["weixinID"] = weixinID;
            ViewData["hId"] = id;
            ViewData["userWeiXinID"] = userWeiXinID;
            ViewData["data"] = hotel3g.Common.UserInfo.Assembly(hotel3g.Models.User.GetUserInfo(weixinID, userWeiXinID));
            return View();
        }
        [Models.Filter]
        public ActionResult JiFen(string id)
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
            userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            ViewData["dt"] = hotel3g.Models.User.GetMyJiFens(weixinID, userWeiXinID);
            return View();
        }
        [Models.Filter]
        public ActionResult MyCouPons(string id)
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
            ViewData["weixinID"] = weixinID;
            ViewData["hId"] = id;
            userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            ViewData["userWeiXinID"] = userWeiXinID;
            ViewData["dt"] = Common.CouponInfo.Assembly(hotel3g.Models.User.GetMyCouPons(weixinID, userWeiXinID));

            ViewData["hotelName"] = MemberHelper.GetHotelName(weixinID, id);


            return View();
        }
        [Models.Filter]
        public ActionResult MyReWard(string id)
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
            ViewData["weixinID"] = weixinID;
            ViewData["hId"] = id;
            userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            ViewData["userWeiXinID"] = userWeiXinID;
            ViewData["dt"] = hotel3g.Models.User.GetMyWard(weixinID, userWeiXinID);
            return View();
        }
        [Models.Filter]
        public ActionResult MyOrders1(string id)
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
            ViewData["weixinID"] = weixinID;
            ViewData["hId"] = id;

            userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            ViewData["userWeiXinID"] = userWeiXinID;

            string cardno = hotel3g.Repository.MemberHelper.GetCardNo(userWeiXinID, weixinID); ;
            bool IsLogin = !string.IsNullOrEmpty(cardno);

            ViewData["dt"] = Common.OrderInfo.Assembly(hotel3g.Models.User.GetUserOrders(weixinID, userWeiXinID, IsLogin), Img.GetHotelImg(id));
            return View();
        }

        [Models.Filter]
        public ActionResult MyOrders(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string[] keys = key.Split('@');
            if (!string.IsNullOrEmpty(key) && keys.Length == 2)
            {
                string weixinID = keys[0];
                string userWeiXinID = keys[1];

                ViewData["weixinID"] = weixinID;
                ViewData["hId"] = id;
                ViewData["userWeiXinID"] = userWeiXinID;

                string cardno = hotel3g.Repository.MemberHelper.GetCardNo(userWeiXinID, weixinID); ;
                bool IsLogin = !string.IsNullOrEmpty(cardno);
                ViewData["dt"] = null;// Common.OrderInfo.Assembly(hotel3g.Models.User.GetUserOrders(weixinID, userWeiXinID, IsLogin), Img.GetHotelImg(id));
            }
            return View();
        }
        [Models.Filter]
        public JsonResult GetOrderListData()
        {
            string userWeiXinID = HCRequest.GetString("userweixinid");
            string WeiXinID = HCRequest.GetString("weixinid");
            int page = HCRequest.getInt("page");
            int state = HCRequest.getInt("state");
            List<Common.OrderInfoItem> OrderList = hotel3g.Models.User.GetUserOrders(WeiXinID, userWeiXinID, page, state);

            if (OrderList.Count > 0)
            {
                //整合订单状态
                List<Common.OrderInfoItem> PackOrderList = new List<Common.OrderInfoItem>();

                foreach (Common.OrderInfoItem Item in OrderList)
                {
                    Item.stateCh = MemberHelper.GetHotelOrderStateNameByState(Item);
                    PackOrderList.Add(Item);
                }


                Newtonsoft.Json.Converters.IsoDateTimeConverter timeFormat = new Newtonsoft.Json.Converters.IsoDateTimeConverter();
                timeFormat.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";

                string json = Newtonsoft.Json.JsonConvert.SerializeObject(PackOrderList,timeFormat);
                return Json(new { isEnd = 0, nextpage = page + 1, list = json });
            }
            else
            {
                //没有更多
                return Json(new { isEnd = 1, nextpage = page, list = "" });
            }

        }


        [Models.Filter]
        public ActionResult OrderInfo(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinid = string.Empty;
            string userweixinid = string.Empty;
            if (!string.IsNullOrEmpty(key) && key.Contains("@"))
            {
                List<string> keylist = key.Split(new string[] { "@" }, StringSplitOptions.RemoveEmptyEntries).ToList();
                hotelweixinid = keylist[0];
                userweixinid = keylist[1];
            }
            int orderid = HCRequest.getInt("id");
            HotelOrder order = ActionController.getorderinfo(hotelweixinid, userweixinid, orderid);
            ViewData["order"] = order;
            string hoteltel = null;
            string address = null;
            WeiXin.Models.Home.Room room = new WeiXin.Models.Home.Room();
            if (order.ID != 0)
            {
                string sql = "select bedtype,addbed,nettype from hotelroom with (nolock) where hotelid=@hotelid and id=@roomid";
                DataTable table = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                {
                    {"hotelid",new DBParam(){ParamValue=order.HotelID.ToString()}},
                    {"roomid",new DBParam(){ParamValue=order.RoomID}}
                });
                if (table.Rows.Count > 0)
                {
                    DataRow r = table.Rows[0];
                    room.AddBed = r["AddBed"].ToString();
                    room.BedType = r["BedType"].ToString();
                    room.NetType = r["NetType"].ToString();
                }

                sql = "select tel,address from hotel with (nolock) where id=@hotelid";
                DataTable hoteltable = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                {
                    {"hotelid",new DBParam(){ParamValue=order.HotelID.ToString()}}
                });
                if (hoteltable.Rows.Count > 0)
                {
                    DataRow r = hoteltable.Rows[0];
                    hoteltel = r["tel"].ToString();
                    address = r["address"].ToString();
                }
            }
            ViewData["room"] = room;
            ViewData["hoteltel"] = hoteltel;
            ViewData["address"] = address;

            ViewData["hid"] = id;

            return View();
        }

        public ActionResult SaveUserInfo(string id)
        {
            string orderid = HotelCloud.Common.HCRequest.GetString("id");
            string email = HotelCloud.Common.HCRequest.GetString("email");
            string name = HotelCloud.Common.HCRequest.GetString("name");
            string mobile = HotelCloud.Common.HCRequest.GetString("mobile");
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("userWeixinNO"); //hotel3g.Models.Cookies.GetCookies("userWeixinNO");
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            string sex = HotelCloud.Common.HCRequest.GetString("sex");
            if (string.IsNullOrEmpty(userWeiXinID) || string.IsNullOrEmpty(weixinID))
            {
                return Json(new
                {
                    error = 1,
                    message = "参数异常,保存失败！"
                });
            }

            int row = hotel3g.Models.User.UpdateInfo(weixinID, userWeiXinID, email, mobile, sex, name);
            if (row > 0)
            {
                return Json(new
                {
                    error = 0,
                    message = "保存成功！"
                });
            }
            return Json(new
            {
                error = 1,
                message = "保存失败！"
            });
        }

        public ActionResult Guaguale(string id)
        {

            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            string key = userWeiXinID;
            if (!userWeiXinID.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, userWeiXinID.Split('@')[0]);

            }
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinid.Equals(""))
            {
                weixinid = userWeiXinID.Split('@')[0];
            }
            string userweixinid = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinid);
            DataTable dt = new WeiXin.Models.Home.Activity().GetPrizeInfo(weixinid, "guaguale", id);
            dt = dt.AsEnumerable().OrderByDescending(item => item["id"]).AsDataView().Table;



            ViewData["dt"] = dt;
            ViewData["userweixin"] = userweixinid;
            ViewData["weixinid"] = weixinid;
            string activityid = "0"; int times = 0;
            if (dt.Rows.Count > 0)
            {
                //判断是否会员专属
                int Exclusive = Convert.ToInt32(dt.Rows[0]["Exclusive"].ToString());
                string cardno = hotel3g.Repository.MemberHelper.GetCardNo(userweixinid, weixinid);
                if (string.IsNullOrEmpty(cardno) && Exclusive == 1)
                {
                    return RedirectToAction("MemberCenterLogin", "MemberCard", new { id = id, key = key });
                }


                activityid = dt.Rows[0]["Id"].ToString();
                times = Convert.ToInt32(dt.Rows[0]["Frequency"].ToString());
            }
            else
            {
                //return Redirect("/User/Error/" + id + "?weixinID=" + weixinid);
                string errorUrl = string.Format("/User/Error/{0}?key={1}@{2}", id, weixinid, userweixinid);
                return Redirect(errorUrl);
            }
            return View();
        }

        //public ActionResult CheckTime()
        //{
        //    string weixinid = HCRequest.GetString("weixinid");
        //    string userweixinid = HCRequest.GetString("FromUserName");
        //    string activityid = HCRequest.GetString("activityid");
        //    int Frequency =Convert.ToInt32( HCRequest.GetString("Frequency"));
        //    int n = new WeiXin.Models.Home.Activity().CheckTimes(weixinid, userweixinid, activityid);
        //    if (n < Frequency)
        //    {
        //        return Content("302");
        //    }
        //    else
        //    {
        //        return Content("500");
        //    }
        //}

        public ActionResult Properprize()
        {
            string userweixin = HCRequest.GetString("FromUserName");
            string weixinid = HCRequest.GetString("weixinid");
            string activityid = HCRequest.GetString("activityid");
            DataTable dt = new WeiXin.Models.Home.Activity().GetJiLv(activityid, weixinid);
            string first = dt.Rows[0]["Probability"].ToString();
            string sencond = dt.Rows[1]["Probability"].ToString();
            string third = dt.Rows[2]["Probability"].ToString();
            decimal firstprize = Convert.ToDecimal(Math.Round(Convert.ToDecimal(first), 2));
            decimal sencondprize = Convert.ToDecimal(Math.Round(Convert.ToDecimal(sencond), 2));
            decimal thirdprize = Convert.ToDecimal(Math.Round(Convert.ToDecimal(third), 2));
            int prizefirst = Convert.ToInt32(firstprize * 100);
            int prizesencond = Convert.ToInt32(sencondprize * 100);
            int prizethird = Convert.ToInt32(thirdprize * 100);
            Random r = new Random();
            int s = r.Next(1, 10000);
            string result = ""; string prizeinfo = "";
            int prizelevel = 4;
            WeiXin.Models.Home.Activity activity = new WeiXin.Models.Home.Activity();
            DataTable dtinfo = new WeiXin.Models.Home.Activity().GetPrizeInfo(weixinid, "guaguale", activityid);
            DataTable dtprize = new WeiXin.Models.Home.Activity().GetPrizeInfo(weixinid, "guaguale", activityid);
            int times = 0;
            if (dt.Rows.Count > 0)
            {
                activityid = dtprize.Rows[0]["Id"].ToString();
                times = Convert.ToInt32(dtprize.Rows[0]["Frequency"].ToString());
            }
            int n1 = new WeiXin.Models.Home.Activity().CheckTimes(weixinid, userweixin, activityid);
            if (n1 > times - 1)
            {
                return Content("105");
            }
            if (s <= prizefirst)
            {

                prizelevel = 1; prizeinfo = dtinfo.Rows[0]["PrizeName"].ToString();
                if (dtinfo.Rows[0]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                {
                    string money = dtinfo.Rows[0]["PrizeName"].ToString().Replace("元订房红包", "");
                    activity.InsertCoupon(weixinid, money, userweixin);
                }
                result = "一等奖";
                if (activity.InsertResult(activityid, weixinid, userweixin, prizeinfo, prizelevel))
                {
                    return Content("101");
                }
                else
                {
                    return Content("error");
                }
            }
            else if (s <= prizefirst + prizesencond && s > prizefirst)
            {
                prizelevel = 2; prizeinfo = dtinfo.Rows[1]["PrizeName"].ToString();
                if (dtinfo.Rows[1]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                {
                    string money = dtinfo.Rows[1]["PrizeName"].ToString().Replace("元订房红包", "");
                    activity.InsertCoupon(weixinid, money, userweixin);
                }
                result = "二等奖";
                if (activity.InsertResult(activityid, weixinid, userweixin, prizeinfo, prizelevel))
                {
                    return Content("102");
                }
                else
                {
                    return Content("error");
                }

            }
            else if (s > prizefirst + prizesencond && s <= prizefirst + prizesencond + prizethird)
            {
                prizelevel = 3;
                prizeinfo = dtinfo.Rows[2]["PrizeName"].ToString();
                if (dtinfo.Rows[2]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                {
                    string money = dtinfo.Rows[2]["PrizeName"].ToString().Replace("元订房红包", "");
                    activity.InsertCoupon(weixinid, money, userweixin);
                }
                result = "三等奖";
                if (activity.InsertResult(activityid, weixinid, userweixin, prizeinfo, prizelevel))
                {
                    return Content("103");
                }
                else
                {
                    return Content("error");
                }
            }
            else
            {
                prizelevel = 4;
                prizeinfo = dtinfo.Rows[3]["PrizeName"].ToString();
                if (dtinfo.Rows[3]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                {
                    string money = dtinfo.Rows[3]["PrizeName"].ToString().Replace("元订房红包", "");
                    activity.InsertCoupon(weixinid, money, userweixin);
                }
                result = "谢谢参与";
                if (activity.InsertResult(activityid, weixinid, userweixin, prizeinfo, prizelevel))
                {
                    return Content("104");
                }
                else
                {
                    return Content("error");
                }
            }
        }
        [Models.Filter]
        public ActionResult dazhuanpan(string id)
        {
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            if (!userWeiXinID.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, userWeiXinID.Split('@')[0]);
            }
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (string.IsNullOrEmpty(weixinid))
            {
                weixinid = userWeiXinID.Split('@')[0];
            }
            weixinid = userWeiXinID.Split('@')[0];

            string userweixinid = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinid);
            DataTable dt = new WeiXin.Models.Home.Activity().GetPrizeInfo(weixinid, "dazhuanpan", id);
            dt = dt.AsEnumerable().OrderByDescending(item => item["id"]).AsDataView().Table;
            ViewData["weixinid"] = weixinid;
            ViewData["dt"] = dt;
            ViewData["userweixin"] = userweixinid;
            ViewData["hotelid"] = id;
            string activityid = "0"; int times = 0;
            if (dt.Rows.Count > 0)
            {
                activityid = dt.Rows[0]["Id"].ToString();
                times = Convert.ToInt32(dt.Rows[0]["Frequency"].ToString());
            }
            else
            {

                string errorUrl = string.Format("/User/Error/{0}?key={1}@{2}", id, weixinid, userweixinid);
                return Redirect(errorUrl);
                //return Redirect("/User/Error/" + id + "?weixinID=" + weixinid);
            }
            return View();
        }

        public ActionResult Error(string id)
        {
            string key = HCRequest.GetString("key");
            string[] keys = key.Split('@');
            ViewData["keys"] = keys;

            return View();
        }

        public JsonResult checkdazhuanpan()
        {
            string userweixinid = HCRequest.GetString("FromUserName");
            string weixinid = HCRequest.GetString("weixinid");
            string activityid = HCRequest.GetString("activityid");
            DataTable dt = new WeiXin.Models.Home.Activity().GetJiLv(activityid, weixinid);
            string first = "";
            string sencond = "";
            string third = "";


            decimal firstprize = 0;
            decimal sencondprize = 0;
            decimal thirdprize = 0;

            decimal fourprize1 = 0;
            decimal fiveprize1 = 0;
            decimal sixprize1 = 0;
            decimal sevenprize1 = 0;
            decimal eightprize1 = 0;
            decimal freeprize1 = 0;

            int prizefirst = 0;
            int prizesencond = 0;
            int prizethird = 0;


            //4~8等奖 
            string four1 = "", five1 = "", six1 = "", seven1 = "", eight1 = "", free1 = "";

            int prizefour1 = 0, prizefive1 = 0, prizesix1 = 0, prizeseven1 = 0, prizeeight1 = 0, prizefree1 = 0;


            int Frequency = 0;
            if (dt.Rows.Count > 0)
            {
                first = dt.Rows[0]["Probability"].ToString();
                sencond = dt.Rows[1]["Probability"].ToString();
                third = dt.Rows[2]["Probability"].ToString();

                //4~8等奖 
                #region
                if (dt.Rows.Count >= 5)
                {
                    four1 = dt.Rows[4]["Probability"].ToString();
                    fourprize1 = Convert.ToDecimal(Math.Round(Convert.ToDecimal(four1), 2));
                    prizefour1 = Convert.ToInt32(fourprize1 * 100);
                }
                if (dt.Rows.Count >= 6)
                {
                    five1 = dt.Rows[5]["Probability"].ToString();
                    fiveprize1 = Convert.ToDecimal(Math.Round(Convert.ToDecimal(five1), 2));
                    prizefive1 = Convert.ToInt32(fiveprize1 * 100);
                }
                if (dt.Rows.Count >= 7)
                {
                    six1 = dt.Rows[6]["Probability"].ToString();
                    sixprize1 = Convert.ToDecimal(Math.Round(Convert.ToDecimal(six1), 2));
                    prizesix1 = Convert.ToInt32(sixprize1 * 100);
                }
                if (dt.Rows.Count >= 8)
                {
                    seven1 = dt.Rows[7]["Probability"].ToString();
                    sevenprize1 = Convert.ToDecimal(Math.Round(Convert.ToDecimal(seven1), 2));
                    prizeseven1 = Convert.ToInt32(sevenprize1 * 100);
                }
                if (dt.Rows.Count >= 9)
                {
                    eight1 = dt.Rows[8]["Probability"].ToString();
                    eightprize1 = Convert.ToDecimal(Math.Round(Convert.ToDecimal(eight1), 2));
                    prizeeight1 = Convert.ToInt32(eightprize1 * 100);
                }
                if (dt.Rows.Count >= 10)
                {
                    free1 = dt.Rows[9]["Probability"].ToString();
                    freeprize1 = Convert.ToDecimal(Math.Round(Convert.ToDecimal(free1), 2));
                    prizefree1 = Convert.ToInt32(freeprize1 * 100);
                }
                #endregion

                firstprize = Convert.ToDecimal(Math.Round(Convert.ToDecimal(first), 2));
                sencondprize = Convert.ToDecimal(Math.Round(Convert.ToDecimal(sencond), 2));
                thirdprize = Convert.ToDecimal(Math.Round(Convert.ToDecimal(third), 2));


                prizefirst = Convert.ToInt32(firstprize * 100);
                prizesencond = Convert.ToInt32(sencondprize * 100);
                prizethird = Convert.ToInt32(thirdprize * 100);
                Frequency = Convert.ToInt32(HCRequest.GetString("frequency"));
            }
            int n = new WeiXin.Models.Home.Activity().CheckTimes(weixinid, userweixinid, activityid);
            DataTable dtinfo = new WeiXin.Models.Home.Activity().GetPrizeInfo(weixinid, "dazhuanpan", activityid);
            WeiXin.Models.Home.Activity activity = new WeiXin.Models.Home.Activity();
            Result rs = new Result(); int result = 0;
            string prizename = ""; string prizeinfo = ""; int prizelevel = 4;
            int avg = (int)Math.Floor((10000 - prizefirst - prizesencond - prizethird) * 1.0 / 6);
            DataTable dtprize = new WeiXin.Models.Home.Activity().GetPrizeInfo(weixinid, "dazhuanpan", activityid);
            int times = 0;
            if (dt.Rows.Count > 0)
            {
                activityid = dtprize.Rows[0]["Id"].ToString();
                times = Convert.ToInt32(dtprize.Rows[0]["Frequency"].ToString());
            }
            int n1 = new WeiXin.Models.Home.Activity().CheckTimes(weixinid, userweixinid, activityid);
            rs.ErrorId = "0";
            if (n1 > times - 1)
            {
                result = 116;
                rs.IsError = true;
                rs.IsThank = true;
                rs.IsWin = false;
                rs.ErrorId = "-100";
            }
            else if (n1 < times)
            {
                Random r = new Random();
                int s = r.Next(1, 10000);
                if (s <= prizefirst)
                {
                    rs.IsWin = true;
                    rs.IsThank = false;
                    rs.IsError = false;
                    result = 109;
                    prizename = "一等奖";
                    prizeinfo = dtinfo.Rows[0]["PrizeName"].ToString();
                    prizelevel = 1;
                    if (dtinfo.Rows[0]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                    {
                        string money = dtinfo.Rows[0]["PrizeName"].ToString().Replace("元订房红包", "");
                        activity.InsertCoupon(weixinid, money, userweixinid);
                    }
                }
                else if (s <= prizefirst + prizesencond && s > prizefirst)
                {
                    rs.IsWin = true;
                    rs.IsThank = false;
                    rs.IsError = false;
                    result = 110;
                    prizename = "二等奖";
                    prizeinfo = dtinfo.Rows[1]["PrizeName"].ToString();
                    prizelevel = 2;
                    if (dtinfo.Rows[1]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                    {
                        string money = dtinfo.Rows[1]["PrizeName"].ToString().Replace("元订房红包", "");
                        activity.InsertCoupon(weixinid, money, userweixinid);
                    }
                }
                else if (s > prizefirst + prizesencond && s <= prizefirst + prizesencond + prizethird)
                {
                    rs.IsWin = true;
                    rs.IsThank = false;
                    rs.IsError = false;
                    result = 111;
                    prizename = "三等奖";
                    prizeinfo = dtinfo.Rows[2]["PrizeName"].ToString();
                    prizelevel = 3;
                    if (dtinfo.Rows[2]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                    {
                        string money = dtinfo.Rows[2]["PrizeName"].ToString().Replace("元订房红包", "");
                        activity.InsertCoupon(weixinid, money, userweixinid);
                    }
                }

                #region 新增奖项
                else
                    if (dt.Rows.Count >= 10 && s > prizefirst + prizesencond + prizethird && s <= prizefirst + prizesencond + prizethird + prizefour1)
                    {
                        rs.IsWin = true;
                        rs.IsThank = false;
                        rs.IsError = false;
                        result = 214;
                        prizename = "四等奖";
                        prizeinfo = dtinfo.Rows[4]["PrizeName"].ToString();
                        prizelevel = 5;
                        if (dtinfo.Rows[4]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                        {
                            string money = dtinfo.Rows[5]["PrizeName"].ToString().Replace("元订房红包", "");
                            activity.InsertCoupon(weixinid, money, userweixinid);
                        }
                    }
                    else if (dt.Rows.Count >= 10 && s > prizefirst + prizesencond + prizethird + fourprize1 && s <= prizefirst + prizesencond + prizethird + prizefour1 + prizefive1)
                    {
                        rs.IsWin = true;
                        rs.IsThank = false;
                        rs.IsError = false;
                        result = 215;
                        prizename = "五等奖";
                        prizeinfo = dtinfo.Rows[5]["PrizeName"].ToString();
                        prizelevel = 6;
                        if (dtinfo.Rows[5]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                        {
                            string money = dtinfo.Rows[5]["PrizeName"].ToString().Replace("元订房红包", "");
                            activity.InsertCoupon(weixinid, money, userweixinid);
                        }
                    }
                    else if (dt.Rows.Count >= 10 && s > prizefirst + prizesencond + prizethird + prizefour1 + prizefive1 && s <= prizefirst + prizesencond + prizethird + prizefour1 + prizefive1 + prizesix1)
                    {
                        rs.IsWin = true;
                        rs.IsThank = false;
                        rs.IsError = false;
                        result = 216;
                        prizename = "六等奖";
                        prizeinfo = dtinfo.Rows[6]["PrizeName"].ToString();
                        prizelevel = 7;
                        if (dtinfo.Rows[6]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                        {
                            string money = dtinfo.Rows[6]["PrizeName"].ToString().Replace("元订房红包", "");
                            activity.InsertCoupon(weixinid, money, userweixinid);
                        }
                    }
                    else if (dt.Rows.Count >= 10 && s > prizefirst + prizesencond + prizethird + prizefour1 + prizefive1 + prizesix1 && s <= prizefirst + prizesencond + prizethird + prizefour1 + prizefive1 + prizesix1 + prizeseven1)
                    {
                        rs.IsWin = true;
                        rs.IsThank = false;
                        rs.IsError = false;
                        result = 217;
                        prizename = "七等奖";
                        prizeinfo = dtinfo.Rows[7]["PrizeName"].ToString();
                        prizelevel = 8;
                        if (dtinfo.Rows[7]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                        {
                            string money = dtinfo.Rows[7]["PrizeName"].ToString().Replace("元订房红包", "");
                            activity.InsertCoupon(weixinid, money, userweixinid);
                        }
                    }

                    else if (dt.Rows.Count >= 10 && s > prizefirst + prizesencond + prizethird + prizefour1 + prizefive1 + prizesix1 + prizeseven1 && s <= prizefirst + prizesencond + prizethird + prizefour1 + prizefive1 + prizesix1 + prizeseven1 + prizeeight1)
                    {
                        rs.IsWin = true;
                        rs.IsThank = false;
                        rs.IsError = false;
                        result = 218;
                        prizename = "八等奖";
                        prizeinfo = dtinfo.Rows[8]["PrizeName"].ToString();
                        prizelevel = 9;
                        if (dtinfo.Rows[8]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                        {
                            string money = dtinfo.Rows[8]["PrizeName"].ToString().Replace("元订房红包", "");
                            activity.InsertCoupon(weixinid, money, userweixinid);
                        }
                    }


                    else if (dt.Rows.Count >= 10 && s > prizefirst + prizesencond + prizethird + prizefour1 + prizefive1 + prizesix1 + prizeseven1 + prizeeight1 && s <= prizefirst + prizesencond + prizethird + prizefour1 + prizefive1 + prizesix1 + prizeseven1 + prizeeight1 + prizefree1)
                    {
                        rs.IsWin = true;
                        rs.IsThank = false;
                        rs.IsError = false;
                        result = 219;
                        prizename = "免单";
                        prizeinfo = dtinfo.Rows[9]["PrizeName"].ToString();
                        prizelevel = 10;
                        //if (dtinfo.Rows[9]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                        //{
                        //    string money = dtinfo.Rows[9]["PrizeName"].ToString().Replace("元订房红包", "");
                        //    activity.InsertCoupon(weixinid, money, userweixinid);
                        //}
                    }

                #endregion


                    else if (s > prizefirst + prizesencond + prizethird + fourprize1 + fiveprize1 + sixprize1 + sevenprize1 + eightprize1 + freeprize1 && s <= prizefirst + prizesencond + prizethird + fourprize1 + fiveprize1 + sixprize1 + sevenprize1 + eightprize1 + freeprize1 + avg)
                    {
                        rs.IsWin = false;
                        rs.IsThank = true;
                        rs.IsError = false;
                        result = 112;
                        prizename = "谢谢参与";
                        prizelevel = 4;
                        prizeinfo = dtinfo.Rows[3]["PrizeName"].ToString();
                        if (dtinfo.Rows[3]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                        {
                            string money = dtinfo.Rows[3]["PrizeName"].ToString().Replace("元订房红包", "");
                            activity.InsertCoupon(weixinid, money, userweixinid);
                        }
                    }
                    else if (s > prizefirst + prizesencond + prizethird + fourprize1 + fiveprize1 + sixprize1 + sevenprize1 + eightprize1 + freeprize1 + avg && s <= prizefirst + prizesencond + prizethird + fourprize1 + fiveprize1 + sixprize1 + sevenprize1 + eightprize1 + freeprize1 + 2 * avg)
                    {
                        rs.IsWin = false;
                        rs.IsThank = true;
                        rs.IsError = false;
                        result = 113;
                        prizename = "不要灰心";
                        prizelevel = 4;
                        prizeinfo = dtinfo.Rows[3]["PrizeName"].ToString();
                        if (dtinfo.Rows[3]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                        {
                            string money = dtinfo.Rows[3]["PrizeName"].ToString().Replace("元订房红包", "");
                            activity.InsertCoupon(weixinid, money, userweixinid);
                        }
                    }
                    else if (s > prizefirst + prizesencond + prizethird + fourprize1 + fiveprize1 + sixprize1 + sevenprize1 + eightprize1 + freeprize1 + 2 * avg && s <= prizefirst + prizesencond + prizethird + fourprize1 + fiveprize1 + sixprize1 + sevenprize1 + eightprize1 + freeprize1 + 3 * avg)
                    {
                        rs.IsWin = false;
                        rs.IsThank = true;
                        rs.IsError = false;
                        result = 114;
                        prizename = "要加油哦";
                        prizelevel = 4;
                        prizeinfo = dtinfo.Rows[3]["PrizeName"].ToString();
                        if (dtinfo.Rows[3]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                        {
                            string money = dtinfo.Rows[3]["PrizeName"].ToString().Replace("元订房红包", "");
                            activity.InsertCoupon(weixinid, money, userweixinid);
                        }
                    }
                    else if (s > prizefirst + prizesencond + prizethird + fourprize1 + fiveprize1 + sixprize1 + sevenprize1 + eightprize1 + freeprize1 + 3 * avg && s <= prizefirst + prizesencond + prizethird + fourprize1 + fiveprize1 + sixprize1 + sevenprize1 + eightprize1 + freeprize1 + 4 * avg)
                    {
                        rs.IsWin = false;
                        rs.IsThank = true;
                        rs.IsError = false;
                        result = 115;
                        prizelevel = 4;
                        prizename = "运气先攒着";
                        prizeinfo = dtinfo.Rows[3]["PrizeName"].ToString();
                        if (dtinfo.Rows[3]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                        {
                            string money = dtinfo.Rows[3]["PrizeName"].ToString().Replace("元订房红包", "");
                            activity.InsertCoupon(weixinid, money, userweixinid);
                        }
                    }
                    else if (s > prizefirst + prizesencond + prizethird + fourprize1 + fiveprize1 + sixprize1 + sevenprize1 + eightprize1 + freeprize1 + 3 * avg && s <= prizefirst + prizesencond + prizethird + fourprize1 + fiveprize1 + sixprize1 + sevenprize1 + eightprize1 + freeprize1 + 4 * avg)
                    {
                        rs.IsWin = false;
                        rs.IsThank = true;
                        rs.IsError = false;
                        result = 116;
                        prizename = "再接再厉";
                        prizelevel = 4;
                        prizeinfo = dtinfo.Rows[3]["PrizeName"].ToString();
                        if (dtinfo.Rows[3]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                        {
                            string money = dtinfo.Rows[3]["PrizeName"].ToString().Replace("元订房红包", "");
                            activity.InsertCoupon(weixinid, money, userweixinid);
                        }
                    }
                    else
                    {
                        rs.IsWin = false;
                        rs.IsThank = true;
                        rs.IsError = false;
                        rs.ErrorId = "-101";
                        result = 117;
                        prizename = "祝你好运";
                        prizelevel = 4;
                        prizeinfo = dtinfo.Rows[3]["PrizeName"].ToString();
                        if (dtinfo.Rows[3]["PrizeName"].ToString().IndexOf("元订房红包") > 0)
                        {
                            string money = dtinfo.Rows[3]["PrizeName"].ToString().Replace("元订房红包", "");
                            activity.InsertCoupon(weixinid, money, userweixinid);
                        }
                    }
            }
            rs.PrizeId = result.ToString();
            // WeiXin.Models.Home.Activity activity = new WeiXin.Models.Home.Activity();
            if (rs.ErrorId != "-100")
            {
                activity.InsertResult(activityid, weixinid, userweixinid, prizeinfo, prizelevel);

            }
            return Json(rs, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// 优惠活动
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult Sports(string id)
        {
            //new Common.LogManage().Error(Request.Url);
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            string key = userWeiXinID;
            string uxid = string.Empty;
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            int sportId = HotelCloud.Common.HCRequest.getInt("sid");
            if (!userWeiXinID.Equals(""))
            {
                weixinid = userWeiXinID.Split('@')[0];
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, userWeiXinID.Split('@')[1]);
                uxid = userWeiXinID.Split('@')[1];
            }
            DataTable dt = new WeiXin.Models.Home.Activity().GetPrizeInfoById(weixinid, sportId);
            string type = "";
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {

                    //判断是否会员专属
                    int Exclusive = Convert.ToInt32(dt.Rows[0]["Exclusive"].ToString());
                    string cardno = hotel3g.Repository.MemberHelper.GetCardNo(uxid, weixinid);
                    if (string.IsNullOrEmpty(cardno) && Exclusive == 1)
                    {
                        return RedirectToAction("MemberRegister", "MemberCardA", new { id = id, key = key });
                    }

                    type = WeiXinPublic.ConvertHelper.ToString(dt.Rows[0]["SportKind"]);
                }
                else
                {
                    //
                    return Redirect(string.Format("/HotelA/PrizeSports/{0}?key={1}", id, userWeiXinID));
                    //return Redirect("/User/Error/" + id + "?weixinID=" + weixinid);
                }
            }
            ViewData["weixinid"] = weixinid;
            ViewData["dt"] = dt;
            ViewData["hotelid"] = id;
            ViewData["userweixin"] = uxid;// hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinid);
            if (type == "dazhuanpan")
                return View("DaZhuanPan");
            else
                return View("GuaGuaLe");
        }

        [Models.Filter]
        public ActionResult OrderInfo_new(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinid = string.Empty;
            string userweixinid = string.Empty;
            if (!string.IsNullOrEmpty(key) && key.Contains("@"))
            {
                List<string> keylist = key.Split(new string[] { "@" }, StringSplitOptions.RemoveEmptyEntries).ToList();
                hotelweixinid = keylist[0];
                userweixinid = keylist[1];
            }
            int orderid = HCRequest.getInt("id");
            HotelOrder order = ActionController.getorderinfo(hotelweixinid, userweixinid, orderid);
            ViewData["order"] = order;
            string hoteltel = null;
            string address = null;
            WeiXin.Models.Home.Room room = new WeiXin.Models.Home.Room();
            if (order.ID != 0)
            {
                string sql = "select bedtype,addbed,nettype from hotelroom with (nolock) where hotelid=@hotelid and id=@roomid";
                DataTable table = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                {
                    {"hotelid",new DBParam(){ParamValue=order.HotelID.ToString()}},
                    {"roomid",new DBParam(){ParamValue=order.RoomID}}
                });
                if (table.Rows.Count > 0)
                {
                    DataRow r = table.Rows[0];
                    room.AddBed = r["AddBed"].ToString();
                    room.BedType = r["BedType"].ToString();
                    room.NetType = r["NetType"].ToString();
                }

                sql = "select tel,address from hotel with (nolock) where id=@hotelid";
                DataTable hoteltable = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                {
                    {"hotelid",new DBParam(){ParamValue=order.HotelID.ToString()}}
                });
                if (hoteltable.Rows.Count > 0)
                {
                    DataRow r = hoteltable.Rows[0];
                    hoteltel = r["tel"].ToString();
                    address = r["address"].ToString();
                }
            }
            ViewData["room"] = room;
            ViewData["hoteltel"] = hoteltel;
            ViewData["address"] = address;

            ViewData["hid"] = id;
            return View();
        }


        [Models.Filter]
        [HttpPost]
        public ActionResult Userfeedback()
        { 
            string orderNo = HotelCloud.Common.HCRequest.GetString("OrderNo").TrimEnd();
            int  yroomNum = Convert.ToInt32(HotelCloud.Common.HCRequest.GetString("yroomNum"));
            string yroomNo = HotelCloud.Common.HCRequest.GetString("yroomno").TrimEnd();
            DateTime yuDate = Convert.ToDateTime(HotelCloud.Common.HCRequest.GetString("yuDate"));


            int status = -1;
            string errmsg = string.Empty;


            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];


            string log = string.Format("客人反馈房间数:{0},房间号:{1},离店日期:{2}",yroomNum,yroomNo,yuDate.ToString("yyyy-MM-dd"));

           int  row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@"insert into dbo.wkn_operatingrecord(weixinid,orderno,operator,operationdate,description) values(@weixinid,@orderno,@operator,@operationdate,@description) ", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {                             
                                {"orderno",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}},                                 
                                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=hotelweixinId}}, 
                                {"operator",new HotelCloud.SqlServer.DBParam{ParamValue="用户"}},
                                {"operationdate",new HotelCloud.SqlServer.DBParam{ParamValue=DateTime.Now.ToString()}},
                                {"description",new HotelCloud.SqlServer.DBParam{ParamValue=log}}
                            });


           if (row > 0)
           {
               status = 0;
               errmsg = "反馈成功";

           }

           else
           {
               errmsg = "反馈失败";
           }



           return Json(new
           {
               Status = status,
               Mess = errmsg
           }, JsonRequestBehavior.AllowGet);

        }


        [HttpPost]
        [Models.Filter]
        public ActionResult FetchMyInvoice()
        {
            string query = HotelCloud.Common.HCRequest.GetString("query").Trim();
            string select = HotelCloud.Common.HCRequest.GetString("select").Trim();

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            int page = HotelCloud.Common.HCRequest.GetInt("page", 1);
            if (page < 1)
            {
                page = 1;
            }
            int pagesize = 10;

            int count = 0;
            int pagesum = 0;

            DataTable dblist = HotelServices.GeteHotelServicesList(userweixinId, out count, page, pagesize, "type", "6");


            List<HotelServices> list = DataTableToEntity.GetEntities<HotelServices>(dblist).ToList();

            foreach (var item in list)
            {
                item.Feedback4 = item.AddTime.ToString("yyyy-MM-dd");
                item.Feedback5 = item.AddTime.ToString("MM-dd");

            }

            Newtonsoft.Json.Converters.IsoDateTimeConverter timeFormat = new Newtonsoft.Json.Converters.IsoDateTimeConverter();
            timeFormat.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";


            pagesum = (count % pagesize == 0) ? count / pagesize : count / pagesize + 1;
            return Json(new
            {
                data = Newtonsoft.Json.JsonConvert.SerializeObject(list, timeFormat),
                count = count,
                page = page,
                pagesum = pagesum
            }, JsonRequestBehavior.AllowGet);
        }
    }
}
