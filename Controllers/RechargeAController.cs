using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WeiXin.Models.Home;
using System.Data;
using WeiXin.Common;
using HotelCloud.Common;
using System.Transactions;

namespace hotel3g.Controllers
{
    public class RechargeAController : Controller
    {

        [Models.Filter]
        public ActionResult RechargeUser()
        {

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            int page = 1;
            int pagesize = 30;
            int count = 0;

            DataTable dblist = RechargeCard.GeteRechargeCardList(hotelweixinId, out count, page, pagesize, "", "");
            var list = DataTableToEntity.GetEntities<RechargeCard>(dblist);
            ViewData["list"] = list;

            DataTable db_range = RechargeRange.GetRechargeRange(hotelweixinId);
            var range = DataTableToEntity.GetEntity<RechargeRange>(db_range);
            ViewData["range"] = range;


            DataTable db_member = RechargeCard.GetRechargeMemberInfo(hotelweixinId, userweixinId);

            if (db_member.Rows.Count == 0)
            {
                return RedirectToAction("MemberRegister", "MemberCardA", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key") });
            }


            ViewData["balance"] = Convert.ToDouble(db_member.Rows[0]["balance"].ToString());

            ViewData["count"] = count;
            ViewData["page"] = page;
            ViewData["pagesize"] = pagesize;

            return View();


        }


        [Models.Filter]
        public ActionResult RechargeDetail()
        {

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            int page = 1;
            int pagesize = 10;
            int count = 0;

            DataTable dblist = WeiXin.Models.Home.RechargeUser.GeteRechargeUserList(hotelweixinId, userweixinId, out count, page, pagesize, "", "");
            List<RechargeUser> list = DataTableToEntity.GetEntities<RechargeUser>(dblist).ToList();
            list = RechargeUserConvert.RechargeConvertMember(list);
            ViewData["list"] = list;

            ViewData["count"] = count;
            ViewData["page"] = page;
            ViewData["pagesize"] = pagesize;


            return View();


        }



        [Models.Filter]
        public ActionResult PayPasswordEdit()
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            DataTable db_member = RechargeCard.GetRechargeMemberPayPassword(hotelweixinId, userweixinId);

            if (db_member.Rows.Count == 0)
            {
                return RedirectToAction("ProductErrMsg", "ProductA", new { id = RouteData.Values["id"], errmsg = "会员不存在！", key = HotelCloud.Common.HCRequest.GetString("key") });
            }


            ViewData["firstPaypassword"] = 0;

            if (db_member.Rows[0]["pwd"].ToString() == string.Empty)
            {
                ViewData["firstPaypassword"] = 1;
            }


            return View();
        }

        [Models.Filter]
        public ActionResult PayPasswordForgot()
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            DataTable db_member = RechargeCard.GetRechargeMemberPayPassword(hotelweixinId, userweixinId);

            if (db_member.Rows.Count == 0)
            {
                return RedirectToAction("ProductErrMsg", "ProductA", new { id = RouteData.Values["id"], errmsg = "会员不存在！", key = HotelCloud.Common.HCRequest.GetString("key") });
            }

            if (db_member.Rows[0]["pwd"].ToString() == string.Empty)
            {
                return RedirectToAction("PayPasswordEdit", "RechargeA", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key") });
            }


            DataTable db_memberInfo = RechargeCard.GetRechargeMemberInfo(hotelweixinId, userweixinId);

            ViewData["mobile"] = db_memberInfo.Rows[0]["mobile"].ToString();


            return View();
        }





        [HttpPost]
        [Models.Filter]
        public ActionResult SetPayPassword()
        {

            int status = -1;
            string errmsg = "重置失败";

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            string newpassword = HCRequest.GetString("newpayPassword").Trim();



            string code = HCRequest.GetString("code").Trim();
            string mobile = HCRequest.GetString("mobile").Trim();

            string smsCode = HotelCloud.SqlServer.SQLHelper.Get_Value("select  SmsCode from wkn_smssend with(nolock) where  weixinId=@weixinId and  mobile=@mobile and  addTime>@addTime  and channel=@channel order by addtime desc",
                  HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {
                         {"Mobile",new HotelCloud.SqlServer.DBParam{ParamValue=mobile}},    
                         {"WeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId  }},
                         {"addTime",new HotelCloud.SqlServer.DBParam{ParamValue=DateTime.Now.AddMinutes(-10).ToString() }} ,
                         {"channel",new HotelCloud.SqlServer.DBParam{ParamValue="用户忘记支付密码"  }} 
                      
                });


            if (!string.IsNullOrEmpty(smsCode) && code == smsCode)
            {
                status = 0;
                errmsg = "验证成功";
            }

            else
            {
                errmsg = "验证码已过期，请重新获取！";

                return Json(new
                {
                    Status = status,
                    Mess = errmsg

                }, JsonRequestBehavior.AllowGet);

            }


            int row = RechargeCard.UpdateRechargeMemberPayPassword(hotelweixinId, userweixinId, newpassword);

            if (row > 0)
            {
                status = 0;
                errmsg = "重置成功";
            }


            else
            {
                errmsg = "重置失败";
            }


            return Json(new
            {
                Status = status,
                Mess = errmsg

            }, JsonRequestBehavior.AllowGet);


        }


        [HttpPost]
        [Models.Filter]
        public ActionResult ValidateMsgCode()
        {

            int status = -1;
            string errmsg = "验证码错误";

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            string mobile = HCRequest.GetString("mobile").Trim();
            string Code = HCRequest.GetString("code").Trim();

            string smsCode = HotelCloud.SqlServer.SQLHelper.Get_Value("select  SmsCode from wkn_smssend with(nolock) where  weixinId=@weixinId and  mobile=@mobile and  addTime>@addTime  and channel=@channel  order by addtime desc",
                   HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {
                                              {"Mobile",new HotelCloud.SqlServer.DBParam{ParamValue=mobile}},    
                                              {"WeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId  }},
                                              {"addTime",new HotelCloud.SqlServer.DBParam{ParamValue=DateTime.Now.AddMinutes(-5).ToString()  }},
                                              {"channel",new HotelCloud.SqlServer.DBParam{ParamValue="用户忘记支付密码"  }} 
                });


            if (!string.IsNullOrEmpty(smsCode) && Code == smsCode)
            {
                status = 0;
                errmsg = "验证成功";
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

            string MsgContent = string.Format("忘记支付密码验证码为:{0},5分钟内有效【微可牛】", Code);
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
                                                {"Channel",new HotelCloud.SqlServer.DBParam{ParamValue="用户忘记支付密码"}},
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




        [HttpPost]
        [Models.Filter]
        public ActionResult EditPayPassword()
        {

            int status = -1;
            string errmsg = "保存失败";


            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];


            string ypassword = HCRequest.GetString("ypaypassword").Trim();
            string newpassword = HCRequest.GetString("newpaypassword").Trim();
            DataTable db_member = RechargeCard.GetRechargeMemberPayPassword(hotelweixinId, userweixinId);

            if (ypassword != db_member.Rows[0]["pwd"].ToString())
            {
                errmsg = "原密码错误";
                return Json(new
                {
                    Status = status,
                    Mess = errmsg

                }, JsonRequestBehavior.AllowGet);

            }

            int row = RechargeCard.UpdateRechargeMemberPayPassword(hotelweixinId, userweixinId, newpassword);

            if (row > 0)
            {
                status = 0;
                errmsg = "修改成功";
            }


            else
            {
                errmsg = "修改失败";
            }

            if (ypassword == string.Empty)
            {
                errmsg = errmsg.Replace("修改", "设置");
            }

            return Json(new
            {
                Status = status,
                Mess = errmsg

            }, JsonRequestBehavior.AllowGet);


        }

        [HttpPost]
        [Models.Filter]
        public ActionResult RechargeUserAccount()
        {
            int cardId = Convert.ToInt32(HotelCloud.Common.HCRequest.GetString("cardId"));

            decimal mprice = Convert.ToDecimal(HotelCloud.Common.HCRequest.GetString("mprice"));
            decimal sprice = Convert.ToDecimal(HotelCloud.Common.HCRequest.GetString("sprice"));

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            int status = -1;
            string mess = "";


            DataTable dbcard = RechargeCard.GeteRechargeCard(hotelweixinId, cardId);

            if (dbcard.Rows.Count == 0)
            {
                mess = "储值卡不存在";
                return Json(new
                {
                    Status = status,
                    Mess = mess

                }, JsonRequestBehavior.AllowGet);
            }


            RechargeCard model_card = DataTableToEntity.GetEntity<RechargeCard>(dbcard);


            if (model_card.SaleStatus == 0)
            {
                mess = "储值卡已暂停售卖";
                return Json(new
                {
                    Status = status,
                    Mess = mess

                }, JsonRequestBehavior.AllowGet);

            }
            else if (model_card.SaleNum >= model_card.TotalNum)
            {
                mess = "储值卡已售完";
                return Json(new
                {
                    Status = status,
                    Mess = mess

                }, JsonRequestBehavior.AllowGet);

            }


            else if (model_card.MPrice != mprice || model_card.Sprice != sprice)
            {
                mess = "金额有变化，请重试！";
                return Json(new
                {
                    Status = status,
                    Mess = mess

                }, JsonRequestBehavior.AllowGet);

            }

            if (model_card.Sprice > 0)
            {
                DataTable dbMember = RechargeCard.GetRechargeMemberInfo(hotelweixinId, userweixinId);
                if (dbMember.Rows.Count == 1)
                {
                    RechargeUser rechargeUser = new RechargeUser();
                    rechargeUser.SPrice = model_card.Sprice;
                    rechargeUser.MPrice = model_card.MPrice;
                    rechargeUser.IsCardPassword = false;
                    rechargeUser.Source = "weixin";
                    rechargeUser.AddTime = DateTime.Now;
                    rechargeUser.HotelWeixinId = hotelweixinId;
                    rechargeUser.HotelId = model_card.HotelId;
                    rechargeUser.UserMobile = dbMember.Rows[0]["mobile"].ToString();
                    rechargeUser.PayType = 1;
                    rechargeUser.UserLevel = dbMember.Rows[0]["vipType"].ToString();
                    rechargeUser.UserWeixinId = dbMember.Rows[0]["userWeixinNo"].ToString();
                    rechargeUser.UserName = dbMember.Rows[0]["name"].ToString();
                    rechargeUser.Beforebalance = Convert.ToDecimal(dbMember.Rows[0]["balance"].ToString());
                    rechargeUser.Balance = rechargeUser.Beforebalance + model_card.MPrice;

                    rechargeUser.OrderNo = "c" + DateTime.Now.ToString("yyMMddHHmmssfff") + new Random().Next(11, 99);
                    rechargeUser.OrderStatus = 0;
                    rechargeUser.CardId = cardId;

                    rechargeUser.TradeOrderNo = "";

                    int rechargeId = WeiXin.Models.Home.RechargeUser.AddRechargeCard(rechargeUser);
                    if (rechargeId > 0)
                    {
                        status = 0;
                        mess = rechargeUser.OrderNo;
                    }


                    if (status != 0)
                    {
                        mess = "充值失败";
                    }

                }
                else if (dbMember.Rows.Count > 1)
                {
                    mess = "会员重复";
                }

                else
                {
                    mess = "会员不存在";
                }

            }



            else
            {
                mess = "充值金额不正确";
            }



            return Json(new
            {
                Status = status,
                Mess = mess

            }, JsonRequestBehavior.AllowGet);

        }



        [HttpPost]
        [Models.Filter]
        public ActionResult RechargeCardPassword()
        {
            int status = -1;
            string errmsg = "充值失败";

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            string cardPassword = HCRequest.GetString("CardPassword").Trim();

            DataTable db_cardpassword = RechargeUserPassword.GeteCardPassword(hotelweixinId, cardPassword);

            if (db_cardpassword.Rows.Count == 0)
            {
                errmsg = "无效的卡密";
                return Json(new
                {
                    Status = status,
                    Mess = errmsg

                }, JsonRequestBehavior.AllowGet);

            }

            DataTable dbMember = RechargeCard.GetRechargeMemberInfo(hotelweixinId, userweixinId);

            RechargeUser rechargeUser = new RechargeUser();
            rechargeUser.SPrice = Convert.ToDecimal(db_cardpassword.Rows[0]["SPrice"]);
            rechargeUser.MPrice = Convert.ToDecimal(db_cardpassword.Rows[0]["MPrice"]);
            rechargeUser.IsCardPassword = true;
            rechargeUser.Source = "password";
            rechargeUser.AddTime = DateTime.Now;
            rechargeUser.HotelWeixinId = hotelweixinId;
            rechargeUser.HotelId = Convert.ToInt32(db_cardpassword.Rows[0]["hotelId"]);
            rechargeUser.UserMobile = dbMember.Rows[0]["mobile"].ToString();
            rechargeUser.PayType = 1;
            rechargeUser.UserLevel = dbMember.Rows[0]["vipType"].ToString();
            rechargeUser.UserWeixinId = dbMember.Rows[0]["userWeixinNo"].ToString();
            rechargeUser.UserName = dbMember.Rows[0]["name"].ToString();
            rechargeUser.Beforebalance = Convert.ToDecimal(dbMember.Rows[0]["balance"].ToString());
            rechargeUser.Balance = rechargeUser.Beforebalance + rechargeUser.MPrice;

            rechargeUser.OrderNo = "c" + DateTime.Now.ToString("yyMMddHHmmssfff") + new Random().Next(11, 99);
            rechargeUser.OrderStatus = 1;
            rechargeUser.CardId = Convert.ToInt32(db_cardpassword.Rows[0]["CardId"]);

            rechargeUser.TradeOrderNo = db_cardpassword.Rows[0]["cardPassword"].ToString();


            using (TransactionScope scop = new TransactionScope())
            {
                int rechargeId = WeiXin.Models.Home.RechargeUser.AddRechargeCard(rechargeUser);
                if (rechargeId > 0)
                {
                    int cardrow = RechargeUserPassword.UpdateCardPasswordStatus(hotelweixinId, cardPassword, 1);
                    if (cardrow > 0)
                    {
                        int row = RechargeCard.UpdateRechargeMemberBalance(hotelweixinId, userweixinId, rechargeUser.MPrice);
                        if (row > 0)
                        {
                            status = 0;
                            errmsg = "充值成功";

                            scop.Complete();
                        }
                    }
                }
            }


            return Json(new
            {
                Status = status,
                Mess = errmsg

            }, JsonRequestBehavior.AllowGet);

        }



        [HttpPost]
        [Models.Filter]
        public ActionResult FetchRechargeOrder()
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

            DataTable dblist = WeiXin.Models.Home.RechargeUser.GeteRechargeUserList(hotelweixinId, userweixinId, out count, page, pagesize, "", "");

            List<RechargeUser> list = DataTableToEntity.GetEntities<RechargeUser>(dblist).ToList();
            list = RechargeUserConvert.RechargeConvertMember(list);

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
