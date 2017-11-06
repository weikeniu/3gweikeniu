using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using HotelCloud.Common;
using hotel3g.Repository;
using System.Net;
using System.Data;
using hotel3g.Models.Home;
using WeiXin.Common;
using hotel3g.Models;
using WeiXin.Models.Home;
using WeiXin.Models.DAL;
namespace hotel3g.Controllers
{
    public class MemberCardAController : Controller
    {
        [Models.Filter]
        public ActionResult CardList()
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            int hid = Convert.ToInt32(RouteData.Values["Id"]);

            int maxCardLevel = 0;
            DataTable dbmember = WeiXin.Models.Home.RechargeCard.GetRechargeMemberInfo(hotelweixinId, userweixinId);
            if (dbmember.Rows.Count > 0)
            {
                int.TryParse(dbmember.Rows[0]["viptype"].ToString(), out maxCardLevel);

            } 
            //int maxCardLevel = MemberCardBuyRecord.GetMaxCardLevel(hotelweixinId, userweixinId);

            int count = 0;
            DataTable db_CardCustom = MemberCardCustom.GetMemberCardCustomList(hotelweixinId, out count, 1, 50, "", "");
            var memberCardCustomList = DataTableToEntity.GetEntities<Models.Home.MemberCardCustom>(db_CardCustom);


            ViewData["list"] = memberCardCustomList;
            ViewData["maxCardLevel"] = maxCardLevel;


            string hotelName = string.Empty;
            string cardPic = string.Empty;
            string cardLogo = string.Empty;

            string sqlStr = @"select  m.backgroud,m.CardLogo,h.subName  from  MemberCardDeatil m with(nolock)   left join  hotel  h with(nolock) on h.Id=m.hid   where  m.hid=@hotelId ";
            DataTable dtCard = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sqlStr, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "hotelId", new HotelCloud.SqlServer.DBParam { ParamValue = hid.ToString() } } });

            if (dtCard.Rows.Count > 0)
            {
                hotelName = dtCard.Rows[0]["subName"].ToString();
                cardPic = dtCard.Rows[0]["backgroud"].ToString();
                cardLogo = dtCard.Rows[0]["cardLogo"].ToString();
            }


            ViewData["hotelName"] = hotelName;
            ViewData["cardPic"] = cardPic;
            ViewData["cardLogo"] = cardLogo;


            return View();
        }


        [Models.Filter]
        public ActionResult CardBuy()
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            int hid = Convert.ToInt32(RouteData.Values["Id"]);

            int cardId = HCRequest.getInt("cardId");

            DataTable db = MemberCardCustom.GetModel(cardId, hotelweixinId);

            if (db.Rows.Count == 0)
            {
                return RedirectToAction("CardList", "MemberCardA", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key") });
            }

            var memberCardCustom = DataTableToEntity.GetEntity<Models.Home.MemberCardCustom>(db);
            ViewData["cardcustom"] = memberCardCustom;

            string hotelName = string.Empty;
            string cardPic = string.Empty;
            string cardLogo = string.Empty;

            string sqlStr = @"select  m.backgroud,m.CardLogo,h.subName  from  MemberCardDeatil m with(nolock)   left join  hotel  h with(nolock) on h.Id=m.hid   where  m.hid=@hotelId ";
            DataTable dtCard = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sqlStr, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "hotelId", new HotelCloud.SqlServer.DBParam { ParamValue = hid.ToString() } } });

            if (dtCard.Rows.Count > 0)
            {
                hotelName = dtCard.Rows[0]["subName"].ToString();
                cardPic = dtCard.Rows[0]["backgroud"].ToString();
                cardLogo = dtCard.Rows[0]["cardLogo"].ToString();
            }

            ViewData["hotelName"] = hotelName;
            ViewData["cardPic"] = cardPic;
            ViewData["cardLogo"] = cardLogo;


            DataTable db_member = RechargeCard.GetRechargeMemberInfo(hotelweixinId, userweixinId);
            if (db_member.Rows.Count == 0)
            {
                MemberHelper.InsertUserAccount(hotelweixinId, userweixinId, "买卡生成账号");
                db_member = RechargeCard.GetRechargeMemberInfo(hotelweixinId, userweixinId);
            }

            var memberEntity = DataTableToEntity.GetEntity<MemberEntity>(db_member);
            ViewData["memberEntity"] = memberEntity;



            return View();

        }



        [HttpPost]
        [Models.Filter]
        public ActionResult UserBuyMemberCard()
        {
            int status = -1;
            string errmsg = "保存失败";

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            int hid = HCRequest.getInt("Id");

            string mobile = HCRequest.GetString("mobile").Trim();
            string code = HCRequest.GetString("code").Trim();
            string username = HCRequest.GetString("username").Trim();
            int cardId = HCRequest.getInt("CardId");

            
            if (!string.IsNullOrEmpty(code))
            {
                DataTable dbMember = RechargeCard.GetRechargeMemberInfoByMobile(hotelweixinId, mobile);
                if (dbMember.Rows.Count > 0)
                {
                    errmsg = "手机号码已绑定";
                    return Json(new
                    {
                        Status = status,
                        Mess = errmsg

                    }, JsonRequestBehavior.AllowGet);
                }

                if (!ValidateMsgCode(key, mobile, code))
                {
                    errmsg = "验证码错误";
                    return Json(new
                    {
                        Status = status,
                        Mess = errmsg

                    }, JsonRequestBehavior.AllowGet);

                }
            }


            DataTable db = MemberCardCustom.GetModel(cardId, hotelweixinId);
            if (db.Rows.Count == 0)
            {
                errmsg = "会员卡不存在";
                return Json(new
                {
                    Status = status,
                    Mess = errmsg

                }, JsonRequestBehavior.AllowGet);

            }


            var memberCardCustom = DataTableToEntity.GetEntity<Models.Home.MemberCardCustom>(db);

            MemberCardBuyRecord model = new MemberCardBuyRecord();

            model.CardId = memberCardCustom.Id;
            model.CardLevel = memberCardCustom.CardLevel;
            model.CardName = memberCardCustom.CardName;
            model.BuyMoney = memberCardCustom.BuyMoney;
            model.OrderNo = "K" + DateTime.Now.ToString("yyMMddHHmmssfff") + new Random().Next(11, 99);
            model.OrderStatus = 0;
            model.AddTime = DateTime.Now;
            model.WeixinId = hotelweixinId;
            model.userWeixinId = userweixinId;
            model.HotelId = hid;
            model.Name = username;
            model.Mobile = mobile;

            int row = MemberCardBuyRecord.AddModel(model);
            if (row > 0)
            {

                status = 0;
                errmsg = model.OrderNo;

                return Json(new
                {
                    Status = status,
                    Mess = errmsg

                }, JsonRequestBehavior.AllowGet);
            }

            return Json(new
            {
                Status = status,
                Mess = errmsg

            }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        [Models.Filter]
        public ActionResult SendMsg()
        {
            int status = -1;
            string errmsg = "发送失败";


            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            string mobile = HCRequest.GetString("mobile").Trim();
            string Code = new Random().Next(100000, 999999).ToString();

            string MsgContent = string.Format("购买会员卡验证码为:{0},5分钟内有效【微可牛】", Code);
            HotelCloud.SMS.SmsMD20140117 sms = new HotelCloud.SMS.SmsMD20140117();

            sms.ReceiveMobileNo = mobile;
            sms.Content = MsgContent;
            string res = sms.Send();
            if (res == "0")
            {
                int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@"insert into wkn_smssend(Mobile,SMSContent,SMSCode,Channel,Ip,WeiXinID) values(@Mobile,@SMSContent,@SMSCode,@Channel,@Ip,@WeiXinID);", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {
                                                {"Mobile",new HotelCloud.SqlServer.DBParam{ParamValue=mobile}},
                                                {"SMSContent",new HotelCloud.SqlServer.DBParam{ParamValue=MsgContent}},
                                                {"SMSCode",new HotelCloud.SqlServer.DBParam{ParamValue=Code}},
                                                {"Channel",new HotelCloud.SqlServer.DBParam{ParamValue="购买会员卡"}},
                                                {"Ip",new HotelCloud.SqlServer.DBParam{ParamValue=GetIPAddress()}},
                                                {"WeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId  }},
                           });

                status = 0;
                errmsg = "发送成功";
            }

            return Json(new
            {
                Status = status,
                Mess = errmsg

            }, JsonRequestBehavior.AllowGet);
        }


        public bool ValidateMsgCode(string key, string mobile, string Code)
        {

            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];



            string smsCode = HotelCloud.SqlServer.SQLHelper.Get_Value("select  SmsCode from wkn_smssend with(nolock) where  weixinId=@weixinId and  mobile=@mobile and  addTime>@addTime  and channel=@channel  order by addtime desc",
                   HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {
                                              {"Mobile",new HotelCloud.SqlServer.DBParam{ParamValue=mobile}},    
                                              {"WeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId  }},
                                              {"addTime",new HotelCloud.SqlServer.DBParam{ParamValue=DateTime.Now.AddMinutes(-5).ToString()  }},
                                              {"channel",new HotelCloud.SqlServer.DBParam{ParamValue="购买会员卡"  }} 
                });


            if (!string.IsNullOrEmpty(smsCode) && Code == smsCode)
            {
                return true;
            }

            return false;

        }


        [Models.Filter]
        public ActionResult PwdRest(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            if (!key.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", key.Split('@')[1], 30, key.Split('@')[0]);
            }
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = key.Split('@')[0];
            }
            string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            string cardno = MemberHelper.GetCardNo(userWeiXinID, weixinID);
            ViewData["MemberRestPassword"] = string.Format("/MemberCard/MemberRestPassword/{0}?key={1}", id, key);
            ViewData["phone"] = MemberHelper.GetMemberCard(cardno, weixinID).phone;


            return View();
        }
        [Models.Filter]
        public ActionResult MemberRestPassword(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            if (!key.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", key.Split('@')[1], 30, key.Split('@')[0]);
            }
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = key.Split('@')[0];
            }

            string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            string cardno = MemberHelper.GetCardNo(userWeiXinID, weixinID);

            ViewData["weixinID"] = weixinID;
            ViewData["hId"] = id;
            ViewData["userWeiXinID"] = userWeiXinID;

            ViewData["MemberCenter"] = string.Format("/UserA/Index/{0}?key={1}", id, key);
            string restphone = hotel3g.Models.Cookies.GetCookies("restphone", "");
            if (string.IsNullOrEmpty(restphone))
            {
                return RedirectToAction("PwdRest", "MemberCardA", new { id = id, key = key });
            }
            return View();
        }
        // GET: /MemberCard/
        [Models.Filter]
        public ActionResult MemberRegister(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            if (!key.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", key.Split('@')[1], 30, key.Split('@')[0]);
            }
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            if (weixinID.Equals(""))
            {
                weixinID = key.Split('@')[0];
                userWeiXinID = key.Split('@')[1];
            }

            ViewData["MemberCenterLogin"] = string.Format("/MemberCardA/MemberCenterLogin/{0}?key={1}", id, key);
            ViewData["MemberEditPassword"] = string.Format("/MemberCardA/MemberEditPassword/{0}?key={1}", id, key);
            ViewData["hId"] = id;
            ViewData["MemberEditPassword"] = string.Format("/MemberCardA/MemberEditPassword/{0}?key={1}", id, key);

            MemberCard UserInfo = MemberHelper.GetMemberCardByUserWeiXinNO(weixinID, userWeiXinID);

            if (UserInfo == null || string.IsNullOrEmpty(UserInfo.memberid))
            {
                //账户不存在 执行新增账户
                string caozuo = string.Format("{0} 注册会员生成账户", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                MemberHelper.InsertUserAccount(weixinID, userWeiXinID, caozuo);
            }

            ViewData["UserInfo"] = UserInfo;

            string cardno = MemberHelper.GetCardNo(userWeiXinID, weixinID);
            if (!string.IsNullOrEmpty(cardno))
            {
                return RedirectToAction("Index", "UserA", new { id = id, key = key });
            }

            string notusedcardno = MemberHelper.GetNotUsedCard(id, weixinID);
            if (string.IsNullOrEmpty(notusedcardno))
            {
                ViewData["CanRegister"] = false;
            }
            else
            {
                ViewData["CanRegister"] = true;

                int count = 0;
                DataTable db_CardCustom = MemberCardCustom.GetMemberCardCustomList(weixinID, out count, 1, 50, "", "");
                var memberCardCustomList = DataTableToEntity.GetEntities<Models.Home.MemberCardCustom>(db_CardCustom);
                memberCardCustomList = memberCardCustomList.OrderBy(c => c.CardLevel).ToList();
                if (memberCardCustomList.Count > 0 && (memberCardCustomList[0].IncreaseType == 1 || memberCardCustomList[0].IncreaseType == 2) && memberCardCustomList[0].BuyMoney > 0)
                {
                    return RedirectToAction("CardList", "MemberCardA", new { id = id, key = key });
                }
            }

            int PromoterID = MemberHelper.GetPromoterID(userWeiXinID, weixinID);
            ViewData["PromoterID"] = PromoterID;
            if (string.IsNullOrEmpty(cardno))
            {
                ViewData["weixinID"] = weixinID;
                ViewData["hId"] = id;
                ViewData["userWeiXinID"] = userWeiXinID;
            }
            else
            {
                //已存在会员卡 跳转登录页面
                // return RedirectToAction("MemberCenterLogin", "MemberCard", new { id = id, key = key });
            }

            return View();
        }
        [Models.Filter]
        public ActionResult MemberEditPassword(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            if (!key.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", key.Split('@')[1], 30, key.Split('@')[0]);
            }
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = key.Split('@')[0];
            }

            string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);

            //获取当前获取当前赠送红包金额
            int Money = MemberHelper.CouponGiftMoney(weixinID, userWeiXinID);
            string query = string.Empty;
            if (Money > 0)
            {
                query = string.Format("&money={0}", Money);
            }
            string sql = @"SELECT COUNT(0) FROM dbo.Member AS a with(NOLOCK) WHERE weixinID=@weixinID AND userWeiXinNO=@userWeiXinNO AND EXISTS(
SELECT 0 FROM dbo.ShareCouponContent WITH(NOLOCK) WHERE tel=a.mobile
)";
            string Value = HotelCloud.SqlServer.SQLHelper.Get_Value(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>(){
            {"weixinID",new HotelCloud.SqlServer.DBParam{ ParamValue=weixinID}},
            {"userWeiXinNO",new HotelCloud.SqlServer.DBParam{ ParamValue=userWeiXinID}}
            });


            if (int.Parse(Value) > 0)
            {
                ViewData["MemberCenter"] = string.Format("/UserA/MyCouPons/{0}?key={1}", id, key);
            }
            else
            {

                ViewData["MemberCenter"] = string.Format("/UserA/Index/{0}?key={1}{2}", id, key, query);
            }
            ViewData["weixinID"] = weixinID;
            ViewData["hId"] = id;
            ViewData["userWeiXinID"] = userWeiXinID;
            string cardno = MemberHelper.GetCardNo(userWeiXinID, weixinID);
            if (!string.IsNullOrEmpty(cardno))
            {
                //已存在会员卡 跳转会员中心
                return RedirectToAction("Index", "UserA", new { id = id, key = key });
            }
            return View();
        }
        public ActionResult LoginOut(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            if (!key.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", key.Split('@')[1], 30, key.Split('@')[0]);
            }
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = key.Split('@')[0];
            }
            string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);

            return RedirectToAction("MemberCenterLogin", "MemberCard", new { id = id, key = key });
        }
        [Models.Filter]
        public ActionResult MemberCenterLogin(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            if (!key.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", key.Split('@')[1], 30, key.Split('@')[0]);
            }
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = key.Split('@')[0];
            }
            string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);

            // string MemberLoginStatus = hotel3g.Models.Cookies.GetCookies("MemberLoginStatus");
            // if (MemberLoginStatus == id)
            // {
            //     return RedirectToAction("Index", "User", new { id = id, key = key });
            // }
            ViewData["weixinID"] = weixinID;
            ViewData["hId"] = id;
            ViewData["userWeiXinID"] = userWeiXinID;


            string MemberRegister = string.Format("/MemberCardA/MemberRegister/{0}?key={1}", id, key);
            string MemberCenterUrl = string.Format("/UserA/Index/{0}?key={1}", id, key);
            string MemberInfoCenter = string.Format("/MemberCardA/MemberCenter/{0}?key={1}", id, key);
            string PwdRest = string.Format("/MemberCardA/PwdRest/{0}?key={1}", id, key);
            string HomeMain = string.Format("/HomeA/Main/{0}?key={1}", id, key);
            ViewData["MemberRegister"] = MemberRegister;
            ViewData["MemberInfoCenter"] = MemberInfoCenter;
            ViewData["PwdRest"] = PwdRest;
            ViewData["MemberCenterUrl"] = MemberCenterUrl;
            ViewData["HomeMain"] = HomeMain;
            return View();
        }
        [Models.Filter]
        public ActionResult MemberCenter(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string[] keys = key.Split('@');
            if (keys.Length >= 2)
            {
                string weixinID = keys[0];
                string userWeiXinID = keys[1];

                MemberInfo Info = MemberHelper.GetMemberInfo(weixinID);
                HotelInfoItem HotelInfo = MemberHelper.GetHotelInfo(weixinID, id);
                ViewData["HotelInfo"] = HotelInfo;
                ViewData["Info"] = Info;
                string HomeMainUrl = string.Format("/HomeA/Main/{0}?key={1}", id, key);
                ViewData["HomeMainUrl"] = HomeMainUrl;

                string MyOrdersUrl = string.Format("/UserA/MyOrders/{0}?key={1}", id, key);
                ViewData["MyOrdersUrl"] = MyOrdersUrl;


                string MemberRegister = string.Format("/MemberCardA/MemberRegister/{0}?key={1}", id, key);
                string MemberCenterUrl = string.Format("/MemberCardA/MemberCenter/{0}?key={1}", id, key);

                ViewData["MemberRegister"] = MemberRegister;
                ViewData["MemberCenterUrl"] = MemberCenterUrl;

                ViewData["weixinID"] = weixinID;
                ViewData["hId"] = id;
                ViewData["userWeiXinID"] = userWeiXinID;

                string cardno = MemberHelper.GetCardNo(userWeiXinID, weixinID);

                if (!string.IsNullOrEmpty(cardno))
                {
                    MemberCard MyCard = MemberHelper.GetMemberCard(cardno, weixinID);
                    MemberCardIntegralRule IntegralRule = MemberHelper.IntegralRule(Info, MyCard);
                    ViewData["IntegralRule"] = IntegralRule;

                    string jifendeatilurl = string.Format("/MemberCardA/JiFendetail/{0}?key={1}", id, key);
                    ViewData["jifendeatilurl"] = jifendeatilurl;
                    string EditMemberCardUrl = string.Format("/MemberCardA/EditMemberCard/{0}?key={1}", id, key);
                    ViewData["EditMemberCardUrl"] = EditMemberCardUrl;
                }
                else
                {
                    //不存在会员卡 跳转注册页面
                    //return RedirectToAction("MemberRegister", "MemberCard", new { id = id, key = key });
                }


                int count = 0;
                DataTable db_CardCustom = MemberCardCustom.GetMemberCardCustomList(weixinID, out count, 1, 50, "", "");
                var memberCardCustomList = DataTableToEntity.GetEntities<Models.Home.MemberCardCustom>(db_CardCustom);
                ViewData["list"] = memberCardCustomList;

                hotel3g.Models.Cookies.SetCookies("restphone", "", -1, "");

                int canyin = 0;

                var ModuleAuthority = hotel3g.Models.DAL.AuthorityHelper.ModuleAuthority(weixinID);

                if (ModuleAuthority != null)
                {
                    canyin = ModuleAuthority.module_meals;
                }
                ViewData["canyin"] = canyin;


                return View();
            }
            else
            {
                return null;
            }
        }
        [Models.Filter]
        public ActionResult EditMemberCard(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            if (!key.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", key.Split('@')[1], 30, key.Split('@')[0]);
            }
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = key.Split('@')[0];
            }
            string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);


            string cardno = MemberHelper.GetCardNo(userWeiXinID, weixinID);
            if (!string.IsNullOrEmpty(cardno))
            {
                return RedirectToAction("Index", "User", new { id = id, key = key });
            }



            string MemberCenterUrl = string.Format("/MemberCardA/MemberCenter/{0}?key={1}", id, key);
            ViewData["MemberCenterUrl"] = MemberCenterUrl;
            ViewData["cardno"] = cardno;
            MemberCard MyCard = MemberHelper.GetMemberCard(cardno, id);
            ViewData["MyCard"] = MyCard;
            return View();
        }
        [Models.Filter]
        public JsonResult EditMemberCardByGust()
        {
            string name = HCRequest.GetString("name");
            string email = HCRequest.GetString("email");
            string address = HCRequest.GetString("address");
            string cardno = HCRequest.GetString("cardno");
            int sex = HCRequest.GetInt("sex", 1);
            if (string.IsNullOrEmpty(name))
            {
                return Json(new { state = 0, msg = "姓名不能为空" });
            }
            if (string.IsNullOrEmpty(email))
            {
                return Json(new { state = 0, msg = "邮箱不能为空" });
            }
            if (string.IsNullOrEmpty(address))
            {
                return Json(new { state = 0, msg = "地址不能为空" });
            }
            int Count = MemberHelper.UpdateCardInfoByCardNo(cardno, name, sex.ToString(), email, address);
            if (Count > 0)
            {
                return Json(new { state = 1 });
            }
            return Json(new { state = 0, msg = "保存失败" });
        }
        [Models.Filter]
        public ActionResult JiFendetail(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");

            string[] keys = key.Split('@');

            if (keys.Length >= 2)
            {
                string weixinID = keys[0];
                string userWeiXinID = keys[1];
                ViewData["weixinID"] = weixinID;
                ViewData["userWeiXinID"] = userWeiXinID;
                ViewData["hid"] = id;
                string cardno = MemberHelper.GetCardNo(userWeiXinID, weixinID);
                if (string.IsNullOrEmpty(cardno))
                {
                    return RedirectToAction("MemberRegister", "MemberCard", new { id = id, key = key });
                }

                hotel3g.Common.UserInfo user = hotel3g.Common.UserInfo.Assembly(hotel3g.Models.User.GetUserInfo(weixinID, userWeiXinID));
                ViewData["user"] = user;

                string MemberCenterUrl = string.Format("/MemberCardA/MemberCenter/{0}?key={1}", id, key);
                ViewData["MemberCenterUrl"] = MemberCenterUrl;

                string page = HotelCloud.Common.HCRequest.GetString("page");
            }
            return View();
        }
        [Models.Filter]
        public JsonResult GetJiFendetailList()
        {
            string WeiXinID = HotelCloud.Common.HCRequest.GetString("WeiXinID");
            string hid = HotelCloud.Common.HCRequest.GetString("hid");
            string page_ = HotelCloud.Common.HCRequest.GetString("page");
            string UserWeiXinID = HotelCloud.Common.HCRequest.GetString("UserWeiXinID");

            string Cardno = MemberHelper.GetCardNo(UserWeiXinID, WeiXinID);

            int page = 0;
            if (int.TryParse(page_, out page))
            {
                page = int.Parse(page_);
            }
            List<JifenItem> jifendeatil = MemberHelper.GetJifenDeatil(WeiXinID, UserWeiXinID, hid, page, Cardno);
            if (jifendeatil.Count == 0)
            {
                return Json(new { state = 0, msg = "没有更多数据了!", data = "[]" });
            }
            string data = Newtonsoft.Json.JsonConvert.SerializeObject(jifendeatil);
            return Json(new { state = 1, data = data });
        }
        [Models.Filter]
        public JsonResult SendRegisterMsg()
        {
            string phone = HCRequest.GetString("phone");
            string weixinid = HCRequest.GetString("weixinid");

            if (string.IsNullOrEmpty(phone.Trim()))
            {
                return Json(new { state = 0, msg = "手机号不能为空!" });
            }
            Random rd = new Random(Guid.NewGuid().GetHashCode());
            int Code = rd.Next(10000, 99999);

            int sendnum = MemberHelper.GetSendNumWithThreeHour(phone, weixinid);
            if (sendnum > 0)
            {
                return Json(new { state = 0, msg = string.Format("验证码发送过于频繁请{0}分钟后尝试发送", sendnum), code = "", phone = phone });
            }

            int sec = MemberHelper.GetLastSendMsgTime(phone);

            if (sec < 30)
            {
                return Json(new { state = 0, msg = string.Format("请{0}秒后发送验证码", 30 - sec), code = "", phone = phone });
            }

            int Count = MemberHelper.SendPhoneCodeMsg(Code.ToString(), phone, weixinid);

            if (Count > 0)
            {
                hotel3g.Models.Cookies.SetCookies("restphone", phone, 1, "");

            }
            return Json(new { state = 1, msg = "验证码已发送至您的手机,请耐心等待!", code = Code, phone = phone });
        }
        [Models.Filter]
        [HttpPost]
        public JsonResult Register()
        {
            //获取获取空会员卡
            string hid = HCRequest.GetString("hid");
            string name = HCRequest.GetString("name");
            string phone = HCRequest.GetString("phone");
            string weixinid = HCRequest.GetString("weixinid");
            string CardNo = MemberHelper.GetNotUsedCard(hid, weixinid);
            string gustpwd = HCRequest.GetString("gustpwd");
      
            string t = HCRequest.GetString("pwdrest");

            if (string.IsNullOrEmpty(CardNo) && !t.Equals("pwdrest"))
            {

                return Json(new { state = 0, msg = "暂无可使用会员卡 请联系酒店新增名额" });
            }
            else
            {
                ///绑定会员卡
                string WeiXinID = HCRequest.GetString("weixinid");
                string UserWeiXinID = HCRequest.GetString("userweixinid");

                int count = 0;
                DataTable db_CardCustom = MemberCardCustom.GetMemberCardCustomList(WeiXinID, out count, 1, 50, "", "");
                var memberCardCustomList = DataTableToEntity.GetEntities<Models.Home.MemberCardCustom>(db_CardCustom);
                var curCard = memberCardCustomList.Where(c => c.IncreaseType == 0 && c.Rooms == 0).OrderByDescending(c => c.CardLevel).FirstOrDefault();
                string strVipType = string.Empty;
                int hbmoney = 0;
                int givejifen = 0;
                if (curCard != null)
                {
                    strVipType = " , viptype=" + curCard.CardLevel;
                    hbmoney = Convert.ToInt32(curCard.HongBaoMoney);
                    givejifen = Convert.ToInt32(curCard.GiveJifen);
                }

                string cardno = MemberHelper.GetCardNo(UserWeiXinID, WeiXinID);

                int Count = MemberHelper.Register(CardNo, WeiXinID, UserWeiXinID, phone, gustpwd, name, strVipType);
                if (Count > 0)
                {
                    //发放优惠
                    if (string.IsNullOrEmpty(cardno))
                    {
                      
                        //会员注册赠送订房红包
                        MemberHelper.RegisterCouponGift(WeiXinID, UserWeiXinID);

                        //绑定推广员赠送订房红包
                        MemberHelper.UpdateCommission(hid, WeiXinID, UserWeiXinID);

                        //会员卡升级送红包
                        if (hbmoney > 0)
                        {
                            int rows = MemberCardBuyRecord.AddCardCoupon(WeiXinID, UserWeiXinID, hbmoney, curCard.Id);
                        }


                        //会员卡升级送积分
                        if (givejifen > 0)
                        {
                            DataTable dbmember = WeiXin.Models.Home.RechargeCard.GetRechargeMemberInfo(WeiXinID, UserWeiXinID);
                            int userId = 0;
                            if (dbmember.Rows.Count > 0)
                            {
                                int.TryParse(dbmember.Rows[0]["Id"].ToString(), out userId);
                            }

                            int rows = MemberCardBuyRecord.AddCardJifen(WeiXinID, UserWeiXinID, userId, CardNo, givejifen, curCard.Id);
                            if (rows > 0)
                            {
                                int row = MemberCardBuyRecord.UpdateUserJifen(WeiXinID, UserWeiXinID, givejifen);
                            }
                        }
                    }


                    return Json(new { state = 1 });
                }
                else
                {
                    return Json(new { state = 0, msg = "领取失败!该手机号可能已绑定会员卡" });
                }
            }
        }
        [Models.Filter]
        [HttpPost]
        public JsonResult MemberLogin()
        {
            string gustname = HCRequest.GetString("gustname");
            string gustpwd = HCRequest.GetString("gustpwd");
            string hid = HCRequest.GetString("hid");
            string WeiXinID = HCRequest.GetString("weixinid");
            string UserWeiXinID = HCRequest.GetString("userweixinid");

            if (string.IsNullOrEmpty(gustname) || string.IsNullOrEmpty(gustpwd))
            {
                return Json(new { state = 0, msg = "账户或密码不能为空!" });
            }


            int Login = MemberHelper.MemberLogin(WeiXinID, UserWeiXinID, gustname, gustpwd);
            if (Login > 0)
            {
                //登录状态写入cookie
                // hotel3g.Models.Cookies.SetCookies("MemberLoginStatus", hid, 10);

                return Json(new { state = 1, msg = "登录成功" });
            }

            return Json(new { state = 0, msg = "登录失败!" });
        }
        [Models.Filter]
        [HttpPost]
        public JsonResult EditMemberPassword()
        {
            string gustname = HCRequest.GetString("gustname");
            string gustpwd = HCRequest.GetString("gustpwd");
            string WeiXinID = HCRequest.GetString("weixinid");
            string UserWeiXinID = HCRequest.GetString("userweixinid");
            string hid = HCRequest.GetString("hid");
            string phone = HCRequest.GetString("phone");
            string CardNo = MemberHelper.GetNotUsedCard(hid, WeiXinID);


            if (string.IsNullOrEmpty(gustname))
            {
                return Json(new { state = 0, msg = "名称不能为空!" });
            }

            if (string.IsNullOrEmpty(gustpwd) || gustpwd.Length < 6 || gustpwd.Length > 15)
            {
                return Json(new { state = 0, msg = "密码位数6~15个字符" });
            }

            int count = 0;
            DataTable db_CardCustom = MemberCardCustom.GetMemberCardCustomList(WeiXinID, out count, 1, 50, "", "");
            var memberCardCustomList = DataTableToEntity.GetEntities<Models.Home.MemberCardCustom>(db_CardCustom);
            var curCard = memberCardCustomList.Where(c => c.IncreaseType == 0 && c.Rooms == 0).OrderByDescending(c => c.CardLevel).FirstOrDefault();
            string strVipType = string.Empty;
            int hbmoney = 0;
            int givejifen = 0;
            if (curCard != null)
            {
                strVipType = " , viptype=" + curCard.CardLevel;
                hbmoney = Convert.ToInt32(curCard.HongBaoMoney);

                givejifen = Convert.ToInt32(curCard.GiveJifen);
            }

            string cardno = MemberHelper.GetCardNo(UserWeiXinID, WeiXinID);

            int Count = MemberHelper.UpdatePassword(WeiXinID, UserWeiXinID, gustpwd, gustname, CardNo, true, strVipType);

            if (Count > 0)
            {
                if (string.IsNullOrEmpty(cardno))
                {
                    //会员注册赠送优惠券
                    MemberHelper.RegisterCouponGift(WeiXinID, UserWeiXinID);

                    //绑定推广员赠送订房红包
                    MemberHelper.UpdateCommission(hid, WeiXinID, UserWeiXinID);


                    //会员卡升级送红包
                    if (hbmoney > 0)
                    {
                        int rows = MemberCardBuyRecord.AddCardCoupon(WeiXinID, UserWeiXinID, hbmoney, curCard.Id);
                    }

                    //会员卡升级送积分
                    if (givejifen > 0)
                    { 
                        
                        DataTable dbmember = WeiXin.Models.Home.RechargeCard.GetRechargeMemberInfo(WeiXinID, UserWeiXinID);
                        int userId = 0;
                        if (dbmember.Rows.Count > 0)
                        {
                            int.TryParse(dbmember.Rows[0]["Id"].ToString(), out userId);
                        }

                        int rows = MemberCardBuyRecord.AddCardJifen(WeiXinID, UserWeiXinID, userId, CardNo, givejifen, curCard.Id);
                        if (rows > 0)
                        {
                            int row = MemberCardBuyRecord.UpdateUserJifen(WeiXinID, UserWeiXinID, givejifen);

                        }
                    }

                }
                return Json(new { state = 1, msg = "登录成功" });
            }
            return Json(new { state = 0, msg = "保存失败" });
        }
        [Models.Filter]
        [HttpPost]
        public JsonResult RestMemberPassword()
        {
            string gustname = "";
            string phone = HCRequest.GetString("phone");
            string gustpwd = HCRequest.GetString("gustpwd");
            string WeiXinID = HCRequest.GetString("weixinid");
            string UserWeiXinID = HCRequest.GetString("userweixinid");
            string hid = HCRequest.GetString("hid");
            string CardNo = MemberHelper.GetNotUsedCard(hid, WeiXinID);

            if (string.IsNullOrEmpty(gustpwd) || gustpwd.Length < 6 || gustpwd.Length > 15)
            {
                return Json(new { state = 0, msg = "密码位数6~15个字符" });
            }

            int Count = MemberHelper.UpdatePassword(WeiXinID, UserWeiXinID, gustpwd, gustname, CardNo, false);
            if (Count > 0)
            {
                //登录状态写入cookie
                hotel3g.Models.Cookies.SetCookies("MemberLoginStatus", hid, 10, WeiXinID);
                return Json(new { state = 1, msg = "登录成功" });

            }
            return Json(new { state = 0, msg = "保存失败" });
        }

        #region  //会议抽奖
        [Models.Filter]
        public ActionResult RandomLuckyDraw(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            int drawid = HCRequest.getInt("drawid");
            ViewData["userinfo"] = string.Format("/MemberCardA/UserLuckyDrawInfo/{0}?key={1}&drawid={2}", id, key, drawid);
            string uwxid = string.Empty;
            if (!key.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", key.Split('@')[1], 30, key.Split('@')[0]);
                uwxid = key.Split('@')[1];
            }

            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = key.Split('@')[0];
            }
            string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            userWeiXinID = string.IsNullOrEmpty(uwxid) ? userWeiXinID : uwxid;





            if (drawid == 0 || string.IsNullOrEmpty(weixinID) || string.IsNullOrEmpty(userWeiXinID))
            {
                //参数不齐全
                return View();
            }
            List<RandomLuckyDrawClass> RandomLuckyDrawList = RandomLuckyDrawHelper.GetRandomLuckyDrawList(drawid, weixinID);
            RandomLuckyDrawUserClass UserItem = RandomLuckyDrawHelper.GetRandomLuckyDrawUserByUserWeiXinIdWithDrawid(userWeiXinID, drawid);
            if (RandomLuckyDrawList != null && RandomLuckyDrawList.Count == 1)
            {
                ViewData["RandomLuckyDrawDeatil"] = RandomLuckyDrawList[0];
                List<RandomLuckyDrawUserClass> NotLuckyUsers = RandomLuckyDrawHelper.GetNotLuckyDrawUsers(drawid, 0);
                string json = NotLuckyUsers != null && NotLuckyUsers.Count > 0 ? Newtonsoft.Json.JsonConvert.SerializeObject(NotLuckyUsers) : "";
                ViewData["NotLuckyUsers"] = json;

            }
            else
            {
                ViewData["RandomLuckyDrawDeatil"] = null;
            }



            ViewData["UserItem"] = UserItem;
            ViewData["userWeiXinID"] = userWeiXinID;
            ViewData["weixinID"] = weixinID;
            ViewData["drawid"] = drawid;

            return View();
        }
        [Models.Filter]
        public ActionResult UserLuckyDrawInfo(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string uwxid = string.Empty;
            if (!key.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", key.Split('@')[1], 30, key.Split('@')[0]);
                uwxid = key.Split('@')[1];
            }

            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = key.Split('@')[0];
            }
            string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            userWeiXinID = string.IsNullOrEmpty(uwxid) ? userWeiXinID : uwxid;

            int drawid = HotelCloud.Common.HCRequest.getInt("drawid");
            List<RandomLuckyDrawUserClass> UserLuckyDrawInfo = RandomLuckyDrawHelper.GetUserLuckyInfo(userWeiXinID, drawid);
            ViewData["UserLuckyDrawInfo"] = UserLuckyDrawInfo;

            return View();
        }
        [Models.Filter]
        [HttpPost]
        public JsonResult RandomLuckyDrawSignUp()
        {
            int drawid = HCRequest.getInt("drawid");
            string userweixinid = HCRequest.GetString("userweixinid");
            string weixinid = HCRequest.GetString("weixinid");
            string name = HCRequest.GetString("name");


            if (string.IsNullOrEmpty(name))
            {
                return Json(new { state = 0, msg = "名称不能为空!" });
            }
            if (name.Length <= 1 || name.Length >= 20)
            {
                return Json(new { state = 0, msg = "名称长度限1~20个字符!" });
            }
            string tel = HCRequest.GetString("tel");
            if (string.IsNullOrEmpty(tel))
            {
                return Json(new { state = 0, msg = "手机号不能为空!" });
            }
            //判断手机号是否已注册
            bool TelIsExists = RandomLuckyDrawHelper.TelIsExists(tel, drawid);
            if (TelIsExists)
            {
                return Json(new { state = 0, msg = "手机号已被使用!" });
            }

            string pwd = HCRequest.GetString("pwd");
            //验证密码
            bool isTrue = RandomLuckyDrawHelper.CheckedPwdWithLuckyDrawId(drawid, pwd);
            if (!isTrue)
            {
                return Json(new { state = 0, msg = "密码错误!" });
            }
            //判断该微信是否未报名
            bool UserIsNotExists = RandomLuckyDrawHelper.UserIsNotExists(drawid, userweixinid);
            if (!UserIsNotExists)
            {
                return Json(new { state = 0, msg = "请不要重复报名" });
            }
            #region 获取用户微信头像
            AccessToken Token = MemberHelper.GetAccessToken(weixinid);
            WeiXinUserInfo UserInfo = new WeiXinUserInfo();
            if (Token.error == 1)
            {
                UserInfo = hotel3g.Repository.MemberHelper.GetUserWeixinInfo(Token.message, userweixinid);
            }

            #endregion

            int Count = RandomLuckyDrawHelper.CreateLuckyDrawUser(drawid, UserInfo.headimgurl, tel, name, userweixinid);
            return Json(new { state = Count, msg = Count > 0 ? "报名成功" : "报名失败" });
        }
        [Models.Filter]
        public JsonResult GetLuckyDrawUser()
        {
            int drawid = HCRequest.getInt("drawid");
            int drawno = HCRequest.getInt("drawno");
            int maxnum = HCRequest.getInt("maxnum");
            if (maxnum < 2)
            {
                return Json(new { status = 100, msg = "报名人数不足!" });
            }


            int status = RandomLuckyDrawHelper.GetRandomLuckyStatus(drawid);
            if (status != 1)
            {
                return Json(new { state = 0, msg = "抽奖尚未开始" });
            }
            if (drawid == 0)
            {
                return Json(new { state = 0, msg = "无抽奖对象" });
            }

            List<RandomLuckyDrawUserClass> LuckyUsers = RandomLuckyDrawHelper.GetNotLuckyDrawUsers(drawid, drawno);
            Random rd = new Random(Guid.NewGuid().GetHashCode());
            int luckynum = rd.Next(0, LuckyUsers.Count - 1);
            RandomLuckyDrawUserClass LuckyUser = LuckyUsers[luckynum];
            //抽奖停止 标识幸运用户

            string drawtitle = "谢谢参与";
            switch (drawno)
            {
                case 1: drawtitle = "一等奖"; break;
                case 2: drawtitle = "二等奖"; break;
                case 3: drawtitle = "三等奖"; break;
                case 4: drawtitle = "四等奖"; break;
                case 5: drawtitle = "五等奖"; break;
                case 100: drawtitle = "特等奖"; break;
            }
            CacheWithDraw drawcache = new CacheWithDraw() { status = 2, userweixinid = LuckyUser.userweixinid, title = drawtitle, photo = LuckyUser.photo, name = LuckyUser.name };
            int Count = RandomLuckyDrawHelper.CreateLuckyUserMark(drawid, drawno, drawcache);


            RandomLuckyDrawHelper.BuildDrawResultByDrawId(drawid, Newtonsoft.Json.JsonConvert.SerializeObject(LuckyUser));


            return Json(new { drawtitle = drawtitle, name = LuckyUser.name, photo = LuckyUser.photo, tel = LuckyUser.tel, status = Count, userweixinid = LuckyUser.userweixinid }); ;
        }
        [Models.Filter]
        public JsonResult UpdateLuckyDrawStartStatus()
        {
            int drawid = HCRequest.getInt("drawid");
            int status = HCRequest.getInt("status");
            int Count = RandomLuckyDrawHelper.UpdateRandomLuckyStatus(drawid, new CacheWithDraw() { status = 1 });


            return Json(new { state = Count, status = status });
        }
        [Models.Filter]
        public JsonResult GetLuckyDrawStartStatus()
        {
            int drawid = HCRequest.getInt("drawid");
            int status = RandomLuckyDrawHelper.GetRandomLuckyStatus(drawid);
            return Json(new { state = status });
        }
        //获取中奖名单
        [Models.Filter]
        public JsonResult GetLuckyDrawUsers()
        {
            int drawid = HCRequest.getInt("drawid");
            List<RandomLuckyDrawUserClass> LuckyDrawUsers = RandomLuckyDrawHelper.GetLuckyDrawUsers(drawid, null);
            string json = Newtonsoft.Json.JsonConvert.SerializeObject(LuckyDrawUsers);
            return Json(new { list = json, count = (LuckyDrawUsers == null ? 0 : LuckyDrawUsers.Count) });
        }
        //获取未中奖名单
        [Models.Filter]
        public JsonResult GetNotLuckyDrawUsers()
        {
            int drawid = HCRequest.getInt("drawid");
            List<RandomLuckyDrawUserClass> NotLuckyDrawUsers = RandomLuckyDrawHelper.GetNotLuckyDrawUsers(drawid, 0);
            string json = Newtonsoft.Json.JsonConvert.SerializeObject(NotLuckyDrawUsers);
            return Json(new { list = json, count = (NotLuckyDrawUsers == null ? 0 : NotLuckyDrawUsers.Count) });
        }
        public JsonResult CoutmerGetNotLuckyDrawUsers()
        {
            int drawid = HCRequest.getInt("drawid");
            string userweixinid = HCRequest.GetString("userweixinid");

            //判断抽奖是否已停止
            int status = RandomLuckyDrawHelper.GetRandomLuckyStatus(drawid);
            RandomLuckyDrawUserClass LuckyUser = RandomLuckyDrawHelper.GetRandomLuckyUser(drawid);
            if (LuckyUser == null)
            {
                return Json(new { status = 4, msg = "网络异常!" });
            }
            if (status == 2)
            {
                //抽奖结束获取自己的抽奖结果
                List<RandomLuckyDrawUserClass> LuckyDrawUsers = RandomLuckyDrawHelper.GetLuckyDrawUsers(drawid, userweixinid);
                //if (LuckyDrawUsers != null && LuckyDrawUsers.Count > 0) {

                CacheWithDraw drawcache = new CacheWithDraw() { status = 2, name = LuckyUser.name, userweixinid = LuckyUser.userweixinid, photo = LuckyUser.photo, title = LuckyUser.result };
                RandomLuckyDrawHelper.UpdateRandomLuckyStatus(drawid, drawcache);
                if (LuckyDrawUsers != null && LuckyDrawUsers.Count > 0)
                {
                    return Json(new { status = 2, name = LuckyDrawUsers[0].name, photo = LuckyDrawUsers[0].photo, msg = "&nbsp;恭喜&nbsp;" + LuckyDrawUsers[0].name + "获得了" + LuckyDrawUsers[0].result });

                }
                // }
            }
            return Json(new { status = status });
        }

        [Models.Filter]
        public ActionResult LuckyDrawSignUp(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            int drawid = HCRequest.getInt("drawid");

            ViewData["userinfo"] = string.Format("/MemberCardA/UserLuckyDrawInfo/{0}?key={1}&drawid={2}", id, key, drawid);
            string uwxid = string.Empty;
            if (!key.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", key.Split('@')[1], 30, key.Split('@')[0]);
                uwxid = key.Split('@')[1];
            }

            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = key.Split('@')[0];
            }
            string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            userWeiXinID = uwxid;

            List<RandomLuckyDrawClass> RandomLuckyDrawList = RandomLuckyDrawHelper.GetRandomLuckyDrawList(drawid, weixinID);
            RandomLuckyDrawUserClass UserItem = RandomLuckyDrawHelper.GetRandomLuckyDrawUserByUserWeiXinIdWithDrawid(userWeiXinID, drawid);

            if (UserItem != null || (RandomLuckyDrawList.Count > 0 && RandomLuckyDrawList[0].sdate < DateTime.Parse(
                DateTime.Now.ToString("yyyy-MM-dd HH:00:00"))))
            {
                //已注册跳转活动页面 或已过注册日期
                return RedirectToAction("RandomLuckyDrawNew", "MemberCard", new { id = id, key = key, drawid = drawid });
            }

            ViewData["UserItem"] = UserItem;
            ViewData["userWeiXinID"] = userWeiXinID;
            ViewData["weixinID"] = weixinID;
            ViewData["drawid"] = drawid;

            ViewData["RandomLuckyDrawUrlNew"] = string.Format("/MemberCardA/RandomLuckyDraw/{0}?key={1}&drawid={2}", id, key, drawid);

            return View();
        }
        #endregion


        #region 新会议抽将
        public ActionResult RandomLuckyDrawNew(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            int drawid = HCRequest.getInt("drawid");
            ViewData["userinfo"] = string.Format("/MemberCardA/UserLuckyDrawInfo/{0}?key={1}&drawid={2}", id, key, drawid);
            string uwxid = string.Empty;
            if (!key.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", key.Split('@')[1], 30, key.Split('@')[0]);
                uwxid = key.Split('@')[1];
            }

            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = key.Split('@')[0];
            }
            string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            userWeiXinID = string.IsNullOrEmpty(uwxid) ? userWeiXinID : uwxid;
            if (drawid == 0 || string.IsNullOrEmpty(weixinID) || string.IsNullOrEmpty(userWeiXinID))
            {
                //参数不齐全
                return View();
            }
            List<RandomLuckyDrawClass> RandomLuckyDrawList = RandomLuckyDrawHelper.GetRandomLuckyDrawList(drawid, weixinID);
            RandomLuckyDrawUserClass UserItem = RandomLuckyDrawHelper.GetRandomLuckyDrawUserByUserWeiXinIdWithDrawid(userWeiXinID, drawid);
            if (RandomLuckyDrawList != null && RandomLuckyDrawList.Count == 1)
            {
                ViewData["RandomLuckyDrawDeatil"] = RandomLuckyDrawList[0];
            }
            else
            {
                ViewData["RandomLuckyDrawDeatil"] = null;
            }
            ViewData["UserItem"] = UserItem;
            ViewData["userWeiXinID"] = userWeiXinID;
            ViewData["weixinID"] = weixinID;
            ViewData["drawid"] = drawid;

            return View();
        }

        //随机抽取幸运儿
        [Models.Filter]
        public JsonResult GetLuckyDrawUserNew()
        {
            int drawid = HCRequest.getInt("drawid");
            int drawno = HCRequest.getInt("drawno");
            int status = RandomLuckyDrawHelper.GetRandomLuckyStatus(drawid);
            CacheWithDraw drawcache = null;

            if (status != 1)
            {
                drawcache = new CacheWithDraw() { status = 0 };
                RandomLuckyDrawHelper.BuildCacheWithDrawId(drawid, drawcache);
                return Json(new { state = 0, msg = "抽奖尚未开始" });
            }
            if (drawid == 0)
            {
                drawcache = new CacheWithDraw() { status = 0 };
                RandomLuckyDrawHelper.BuildCacheWithDrawId(drawid, drawcache);
                return Json(new { state = 0, msg = "无抽奖对象" });
            }

            List<RandomLuckyDrawUserClass> LuckyUsers = RandomLuckyDrawHelper.GetNotLuckyDrawUsers(drawid, drawno);
            if (LuckyUsers == null || LuckyUsers.Count == 0)
            {

                drawcache = new CacheWithDraw() { status = 0 };
                RandomLuckyDrawHelper.BuildCacheWithDrawId(drawid, drawcache);
                return Json(new { state = 0, msg = "人数不足" });
            }
            Random rd = new Random(Guid.NewGuid().GetHashCode());
            int luckynum = rd.Next(0, LuckyUsers.Count - 1);
            //随机获取得奖人
            RandomLuckyDrawUserClass LuckyUser = LuckyUsers[luckynum];
            string drawtitle = "谢谢参与";
            switch (drawno)
            {
                case 1: drawtitle = "一等奖"; break;
                case 2: drawtitle = "二等奖"; break;
                case 3: drawtitle = "三等奖"; break;
                case 4: drawtitle = "四等奖"; break;
                case 5: drawtitle = "五等奖"; break;
                case 100: drawtitle = "特等奖"; break;
            }
            drawcache = new CacheWithDraw() { name = LuckyUser.name, status = 2, photo = LuckyUser.photo, title = drawtitle, userweixinid = LuckyUser.userweixinid };

            //抽奖停止 标识幸运用户
            int Count = RandomLuckyDrawHelper.CreateLuckyUserMark(drawid, drawno, drawcache);

            //将开奖结果写入缓存
            //RandomLuckyDrawHelper.BuildCacheWithDrawId(drawid, drawcache);
            return Json(new { status = 2, name = LuckyUser.name, photo = LuckyUser.photo, title = drawtitle, userweixinid = LuckyUser.userweixinid });
        }
        //获取开奖状态
        [Models.Filter]
        public JsonResult GetLuckyDrawStatusById()
        {
            int drawid = HCRequest.getInt("drawid");
            CacheWithDraw drawcache = RandomLuckyDrawHelper.GetCacheWithDrawId(drawid);
            return Json(new { status = drawcache.status, photo = drawcache.photo, name = drawcache.name, title = drawcache.title, userweixinid = drawcache.userweixinid });
        }
        public ActionResult RandomLuckyDrawNewPC(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            int drawid = HCRequest.getInt("drawid");
            ViewData["userinfo"] = string.Format("/MemberCardA/UserLuckyDrawInfo/{0}?key={1}&drawid={2}", id, key, drawid);
            string uwxid = string.Empty;
            if (!key.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", key.Split('@')[1], 30, key.Split('@')[0]);
                uwxid = key.Split('@')[1];
            }

            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = key.Split('@')[0];
            }
            string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            userWeiXinID = string.IsNullOrEmpty(uwxid) ? userWeiXinID : uwxid;
            if (drawid == 0 || string.IsNullOrEmpty(weixinID) || string.IsNullOrEmpty(userWeiXinID))
            {
                //参数不齐全
                return View();
            }
            List<RandomLuckyDrawClass> RandomLuckyDrawList = RandomLuckyDrawHelper.GetRandomLuckyDrawList(drawid, weixinID);
            RandomLuckyDrawUserClass UserItem = RandomLuckyDrawHelper.GetRandomLuckyDrawUserByUserWeiXinIdWithDrawid(userWeiXinID, drawid);
            if (RandomLuckyDrawList != null && RandomLuckyDrawList.Count == 1)
            {
                ViewData["RandomLuckyDrawDeatil"] = RandomLuckyDrawList[0];
            }
            else
            {
                ViewData["RandomLuckyDrawDeatil"] = null;
            }
            ViewData["UserItem"] = UserItem;
            ViewData["userWeiXinID"] = userWeiXinID;
            ViewData["weixinID"] = weixinID;
            ViewData["drawid"] = drawid;

            return View();
        }

        #endregion

        #region 微信鉴权页
        public ActionResult Authentication()
        {
            string code = Request.QueryString["code"];
            //酒店微信id
            string WeiXinId = Request.QueryString["weixinid"];
            string hotelid = Request.QueryString["hotelid"];
            //获取配置信息
            WeiXinAppConfig Config = MemberHelper.GetHotelAppConfig(WeiXinId);
            if (string.IsNullOrEmpty(code))
            {
                //目标页
                string target = HttpUtility.UrlEncode(string.Format("{0}/{1}", Request.QueryString["target"], hotelid));
                ///静默授权返回页
                string redirect_uri = HttpUtility.UrlEncode(string.Format("http://hotel.weikeniu.com/MemberCardA/Authentication?weixinid={0}", WeiXinId));
                //获取授权
                string url = string.Format("https://open.weixin.qq.com/connect/oauth2/authorize?appid={0}&redirect_uri={1}&response_type=code&scope=snsapi_base&state={2}#wechat_redirect", Config.appid, redirect_uri, target);
                return Redirect(url);
            }
            else
            {
                //已授权 获取accesstoken
                string url = string.Format("https://api.weixin.qq.com/sns/oauth2/access_token?appid={0}&secret={1}&code={2}&grant_type=authorization_code", Config.appid, Config.appkey, code);
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls;
                string json = WeiXinHtmlRequesHelper.RequestHtml(url);
                UnionInfo Info = Newtonsoft.Json.JsonConvert.DeserializeObject<UnionInfo>(json);
                ///拼接最终链接
                string state = Request.QueryString["state"];
                url = string.Format("{0}?key={1}@{2}", state, WeiXinId, Info.openid);
                return Redirect(url);
            }
        }
        #endregion

        #region 微信鉴权页参数
        public ActionResult Authentication1()
        {
            string code = Request.QueryString["code"];
            //酒店微信id
            string WeiXinId = Request.QueryString["weixinid"];
            string hotelid = Request.QueryString["hotelid"];
            //获取配置信息
            WeiXinAppConfig Config = MemberHelper.GetHotelAppConfig(WeiXinId);
            if (string.IsNullOrEmpty(code))
            {
                //目标页
                string target = HttpUtility.UrlEncode(string.Format("{0}/{1}", Request.QueryString["target"], hotelid));
                int id = HCRequest.getInt("id");
                string queryid = id > 0 ? "&id=" + id.ToString() : "";
                ///静默授权返回页
                string redirect_uri = HttpUtility.UrlEncode(string.Format("http://hotel.weikeniu.com/MemberCardA/Authentication1?weixinid={0}{1}", WeiXinId, queryid));
                //获取授权
                string url = string.Format("https://open.weixin.qq.com/connect/oauth2/authorize?appid={0}&redirect_uri={1}&response_type=code&scope=snsapi_base&state={2}#wechat_redirect", Config.appid, redirect_uri, target);
                return Redirect(url);
            }
            else
            {
                int id = HCRequest.getInt("id");
                //已授权 获取accesstoken
                string url = string.Format("https://api.weixin.qq.com/sns/oauth2/access_token?appid={0}&secret={1}&code={2}&grant_type=authorization_code", Config.appid, Config.appkey, code);
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls;
                string json = WeiXinHtmlRequesHelper.RequestHtml(url);
                UnionInfo Info = Newtonsoft.Json.JsonConvert.DeserializeObject<UnionInfo>(json);
                ///拼接最终链接
                string state = Request.QueryString["state"];
                string query2 = "";
                //判断携带的参数
                if (state.ToLower().IndexOf("newsinfo") > -1)
                {
                    query2 = id > 0 ? "&nid=" + id.ToString() : "";
                }
                else if (state.ToLower().IndexOf("sports") > -1)
                {
                    query2 = id > 0 ? "&sid=" + id.ToString() : "";
                }

                url = string.Format("{0}?key={1}@{2}{3}", state, WeiXinId, Info.openid, query2);
                return Redirect(url);
            }
        }
        #endregion


        public string GetIPAddress()
        {
            if (Request.ServerVariables["HTTP_VIA"] != null)
            {
                if (Request.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
                {
                    return Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
                }
                return Request.UserHostAddress;
            }
            return Request.ServerVariables["REMOTE_ADDR"].ToString();
        }


    }
}
