using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using WeiXin.Models.Home;
using WeiXin.Common;
using HotelCloud.Common;
using System.Transactions;
using System.Web.Routing;
using hotel3g.Repository;

namespace hotel3g.Controllers
{
    public class RechargeController : Controller
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
                return RedirectToAction("MemberRegister", "MemberCard", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key") });
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
        public ActionResult CardPay(string orderNo)
        {
            try
            {

                orderNo = orderNo.ToLower();
                string key = HotelCloud.Common.HCRequest.GetString("key");
                string hotelweixinId = key.Split('@')[0];
                string userweixinId = key.Split('@')[1];

                #region 获取appid Ashbur20170427
                string appid = "wx9f84537c7ce94a29";
                var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 appid from WeiXin..WeiXinNO with(nolock)  where WeiXinID=@WeiXinID and iszhifu=1", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "WeiXinID", new HotelCloud.SqlServer.DBParam { ParamValue = hotelweixinId.Trim() } } });
                if (dt.Rows.Count > 0)
                {
                    foreach (System.Data.DataRow dr in dt.Rows)
                        appid = dr["appid"].ToString().Trim();
                }
                ViewData["appid"] = appid;
                #endregion

                ViewData["edition"] = HotelCloud.SqlServer.SQLHelper.Get_Value("select  edition from WeiXin..WeiXinNO with(nolock)  where WeiXinID=@WeiXinID",
                    HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>                 
                    {{ "WeiXinID", new HotelCloud.SqlServer.DBParam { ParamValue = hotelweixinId.Trim() } }
                    });


                DataTable db_TradeOrder = WeiXin.Models.Home.RechargeUser.GeteRechargUserByTradeOrderNo(orderNo);
                if (db_TradeOrder.Rows.Count > 0)
                {
                    //return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "订单已支付！", key = HotelCloud.Common.HCRequest.GetString("key") });
                }



                if (orderNo.Contains("k"))
                {
                    return View();
                }


                string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;


                DataTable db_member = RechargeCard.GetRechargeMemberInfo(hotelweixinId, userweixinId);

                //if (db_member.Rows.Count == 0)
                //{
                //    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "抱歉，支付失败！", key = HotelCloud.Common.HCRequest.GetString("key") });
                //}



                ViewData["balance"] = 0;
                if (db_member.Rows.Count > 0)
                {
                    ViewData["balance"] = Convert.ToDouble(db_member.Rows[0]["balance"].ToString());
                }
                else
                {
                    if (!userweixinId.Contains(wkn_shareopenid))
                    {
                        MemberHelper.InsertUserAccount(hotelweixinId, userweixinId, "付款生成账号");
                    }
                }


                decimal payMoney = GetPayOrderMoney(orderNo);

                if (payMoney <= 0)
                {
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "找不到该产品！", key = HotelCloud.Common.HCRequest.GetString("key") });
                }

                ViewData["payMoney"] = payMoney;


                int isMustWeixin = 0;

                DataTable db_range = RechargeRange.GetRechargeRange(hotelweixinId);
                var range = DataTableToEntity.GetEntity<RechargeRange>(db_range);
                List<string> list_rang = new List<string>();


                if (!string.IsNullOrEmpty(range.UseRange))
                {
                    list_rang.AddRange(range.UseRange.Split(','));
                }


                //团购预售
                if (orderNo.Contains("p"))
                {
                    if (list_rang.Contains("2") == false)
                    {
                        isMustWeixin = 1;
                    }
                }

                //餐饮
                else if (orderNo.Contains("l"))
                {
                    string canType = HotelCloud.SqlServer.SQLHelper.Get_Value("select Isaround   from T_Stores  with(nolock)   where  StoreId =(select top 1  StoreId  from T_OrderInfo  with(nolock) where  orderCode=@orderCode)",
                           HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {
                                              {"orderCode",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}}   
                         });


                    // 2 3 自营
                    if (canType == "2" || canType == "3")
                    {
                        if (list_rang.Contains("1") == false)
                        {
                            isMustWeixin = 1;
                        }
                    }

                    else
                    {
                        if (list_rang.Contains("4") == false)
                        {
                            isMustWeixin = 1;
                        }
                    }


                }

               //超市
                else if (orderNo.Contains("d"))
                {
                    if (list_rang.Contains("3") == false)
                    {
                        isMustWeixin = 1;
                    }
                }


                if (payMoney > Convert.ToDecimal(ViewData["balance"]))
                {
                    isMustWeixin = 1;
                }

                ViewData["isMustWeixin"] = isMustWeixin;

                return View();

            }

            catch (Exception ex)
            {
                Logger.Instance.Error(ex.ToString());


                return RedirectToAction("ProductErrMsg", ViewData["edition"].ToString() == "1" ? "ProductA" : "Product", new { id = RouteData.Values["id"], errmsg = "抱歉，支付失败！", key = HotelCloud.Common.HCRequest.GetString("key") });
            }
        }


        [Models.Filter]
        public ActionResult PayMoney()
        {
            string orderNo = Request.Form["orderNo"].ToLower();
            string payPassword = Request.Form["payPassword"];

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            string edition = Request.QueryString["edition"];
            string errControllerName=edition=="1"  ?  "ProductA": "Product";

            string mess = string.Empty;
            bool isOK = ValidateUserPayPassword(hotelweixinId, userweixinId, payPassword, out mess);



            if (isOK == false)
            {
                return RedirectToAction("ProductErrMsg", errControllerName, new { id = RouteData.Values["id"], errmsg = mess, key = HotelCloud.Common.HCRequest.GetString("key") });
            }

            DataTable db_member = RechargeCard.GetRechargeMemberInfo(hotelweixinId, userweixinId);
            decimal balance = Convert.ToDecimal(db_member.Rows[0]["balance"].ToString());

            decimal payMoney = GetPayOrderMoney(orderNo);

            if (payMoney <= 0)
            {
                return RedirectToAction("ProductErrMsg", errControllerName, new { id = RouteData.Values["id"], errmsg = "找不到该产品！", key = HotelCloud.Common.HCRequest.GetString("key") });
            }

            if (balance < payMoney)
            {
                return RedirectToAction("ProductErrMsg", errControllerName, new { id = RouteData.Values["id"], errmsg = "余额不足！", key = HotelCloud.Common.HCRequest.GetString("key") });
            }



            RechargeUser rechargeUser = new RechargeUser();
            rechargeUser.SPrice = -payMoney;
            rechargeUser.MPrice = rechargeUser.SPrice;
            rechargeUser.IsCardPassword = false;
            rechargeUser.Source = "pay";
            rechargeUser.AddTime = DateTime.Now;
            rechargeUser.HotelWeixinId = hotelweixinId;
            rechargeUser.HotelId = Convert.ToInt32(RouteData.Values["id"]);
            rechargeUser.UserMobile = db_member.Rows[0]["mobile"].ToString();
            rechargeUser.PayType = 1;
            rechargeUser.UserLevel = db_member.Rows[0]["viptype"].ToString();
            rechargeUser.UserWeixinId = userweixinId;
            rechargeUser.UserName = db_member.Rows[0]["name"].ToString();
            rechargeUser.Beforebalance = balance;
            rechargeUser.Balance = rechargeUser.Beforebalance - payMoney;

            rechargeUser.OrderNo = "c" + DateTime.Now.ToString("yyMMddHHmmssfff") + new Random().Next(11, 99);
            rechargeUser.OrderStatus = 1;
            rechargeUser.CardId = 0;

            rechargeUser.TradeOrderNo = orderNo;


            bool opFlag = false;

            int p_Status = 0;

            using (TransactionScope scop = new TransactionScope())
            {
                int rechargeId = WeiXin.Models.Home.RechargeUser.AddRechargeCard(rechargeUser);
                if (rechargeId > 0)
                {
                    int row = RechargeCard.ReduceRechargeMemberBalance(hotelweixinId, userweixinId, payMoney);
                    if (row > 0)
                    {
                        string operationRecord = string.Format("[储值卡支付]:于{0}支付:{1}", DateTime.Now, payMoney);
                        string payType = "储值卡支付";

                        //团购预售
                        if (orderNo.Contains("p"))
                        {

                            string tsql = @"update SaleProducts_Orders set OrderStatus=3, Remark=isnull(Remark,'')+@OperationRecord,IsPay=1,PayTime=getdate(),payType=@payType  where  OrderNo=@OrderNO and  IsPay=0 ";
                            p_Status = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"OrderNO",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}},                                          
                                {"OperationRecord",new HotelCloud.SqlServer.DBParam{ParamValue=operationRecord  }},
                                 {"payType",new HotelCloud.SqlServer.DBParam{ParamValue=payType  }}          
                            });

                            if (p_Status > 0)
                            {
                                //短信发送的用在事物里面有问题
                            }

                        }

                          //餐饮
                        else if (orderNo.Contains("l"))
                        {
                            string tsql = @"update WeiXin..T_OrderInfo set Status=9,payTime=getdate(),orderPayState=1,orderPayType=@payType  where  orderCode=@OrderNO ";
                            int Status = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                     {"OrderNO",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}},   
                     {"payType",new HotelCloud.SqlServer.DBParam{ParamValue=payType}}                                          
                   });

                        }


                       //超市
                        else if (orderNo.Contains("d"))
                        {
                            string tsql = @"update SupermarketOrder_Levi set OrderStatus = 2,PayStatus = 2,PayTime=getdate(),aliPayAmount=@AliPayAmount,payMethod=@payType  where  OrderId =@OrderNO;INSERT INTO [WeiXin].[dbo].[SupermarketOrderLog_Levi]([OrderId],[Context],[LogType],[CreateUser],[CreateTime]) VALUES(@OrderNO,'订单状态流转为:已付款',1,'用户',GETDATE())";

                            int Status = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"OrderNO",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}},  
                                {"AliPayAmount",new HotelCloud.SqlServer.DBParam{ParamValue=(payMoney*100).ToString()}}, 
                                {"payType",new HotelCloud.SqlServer.DBParam{ParamValue=payType}}                  
                            });

                        }

                         //酒店
                        else
                        {

                            string tsql = @"update HotelOrder set Remark=isnull(Remark,'')+@OperationRecord,aliPayAmount=@AliPayAmount,aliPayTime=getdate(),tradeStatus='TRADE_FINISHED',state=24,tradeNo=@TradeNo,payMethod=@payType  where  OrderNO=@OrderNO ";

                            int Status = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"OrderNO",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}},
                                {"TradeNo",new HotelCloud.SqlServer.DBParam{ParamValue=""}},                           
                                {"AliPayAmount",new HotelCloud.SqlServer.DBParam{ParamValue=(payMoney *100).ToString()}},             
                                {"OperationRecord",new HotelCloud.SqlServer.DBParam{ParamValue=operationRecord}},
                                  {"payType",new HotelCloud.SqlServer.DBParam{ParamValue=payType}}       
                            });
                        }


                        opFlag = true;
                        scop.Complete();
                    }
                }
            }


            //支付成功
            if (opFlag)
            {
                if (orderNo.Contains("p"))
                {
                    if (p_Status > 0)
                    {
                        SaleProducts_Orders.DoneOrderSuccess(orderNo);
                    }

                    if (edition == "1")
                    {
                        return RedirectToAction("ProductUserOrderDetail", "productA", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key"), OrderNo = orderNo });
                    }

                    else
                    {
                        return RedirectToAction("ProductUserOrderDetail", "product", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key"), OrderNo = orderNo });
                    }

                }

                if (orderNo.Contains("l"))
                {

                    if (edition == "1")
                    {
                        string storeID = HotelCloud.SqlServer.SQLHelper.Get_Value("SELECT  storeID  FROM WeiXin..T_OrderInfo with(nolock)   where  ordercode=@ordercode", HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"ordercode",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}}
                        });

                        return RedirectToAction("ViewOrderDetail", "DishOrderA", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key"), orderCode = orderNo, storeID = storeID });

                    }

                    else
                    {
                        return RedirectToAction("PaySuccess", "DishOrder", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key"), orderCode = orderNo });
                    }

                }


                if (orderNo.Contains("d"))
                {

                    if (edition == "1")
                    {
                        return RedirectToAction("OrderDetails2", "SupermarketA", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key"), orderid = orderNo });
                    }

                    else
                    {

                        return RedirectToAction("OrderPay", "Supermarket", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key"), orderid = orderNo });
                    }

                }

                else
                {

                    string orderId = HotelCloud.SqlServer.SQLHelper.Get_Value("SELECT  Id  FROM WeiXin..HotelOrder with(nolock)   where  orderNo=@orderNo", HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"orderNo",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}}
                        });


                    if (edition == "1")
                    {

                        Response.Redirect(string.Format("/UserA/OrderInfo/{0}?key={1}&Id={2}", RouteData.Values["id"], HotelCloud.Common.HCRequest.GetString("key"), orderId));
                        return View();

                    }


                    else
                    {
                        //return RedirectToAction("resultNotifyPage.aspx", "WeiXinZhiFu", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key"), code = orderNo, error = "ok" });
                        Response.Redirect(string.Format("/User/OrderInfo/{0}?key={1}&Id={2}", RouteData.Values["id"], HotelCloud.Common.HCRequest.GetString("key"), orderId));
                        return View();

                    }

                }
            }


            //支付失败以后
            if (orderNo.Contains("l"))
            {
                if (edition == "1")
                {
                    string storeID = HotelCloud.SqlServer.SQLHelper.Get_Value("SELECT  storeID  FROM WeiXin..T_OrderInfo with(nolock)   where  ordercode=@ordercode", HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"ordercode",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}}
                        });
                    return RedirectToAction("ViewOrderDetail", "DishOrderA", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key"), orderCode = orderNo, storeID = storeID });

                }

                else
                {

                    return RedirectToAction("PayFail", "DishOrder", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key"), orderCode = orderNo });
                }
            }


            if (orderNo.Contains("d"))
            {
                if (edition == "1")
                {
                    return RedirectToAction("OrderDetails2", "SupermarketA", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key"), orderid = orderNo });

                }

                else
                {
                    return RedirectToAction("PayFail", "Supermarket", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key"), orderid = orderNo });
                }
            }


            if (edition == "1")
            {
                return RedirectToAction("ProductErrMsg", "ProductA", new { id = RouteData.Values["id"], errmsg = "支付失败！", key = HotelCloud.Common.HCRequest.GetString("key") });
            }

            else
            {
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "支付失败！", key = HotelCloud.Common.HCRequest.GetString("key") });
            }

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
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "会员不存在！", key = HotelCloud.Common.HCRequest.GetString("key") });
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
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "会员不存在！", key = HotelCloud.Common.HCRequest.GetString("key") });
            }

            if (db_member.Rows[0]["pwd"].ToString() == string.Empty)
            {
                return RedirectToAction("PayPasswordEdit", "Recharge", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key") });
            }


            DataTable db_memberInfo = RechargeCard.GetRechargeMemberInfo(hotelweixinId, userweixinId);

            ViewData["mobile"] = db_memberInfo.Rows[0]["mobile"].ToString();


            return View();
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
        public ActionResult ValidatePayPassword()
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            string payPassword = HotelCloud.Common.HCRequest.GetString("payPassword");

            int status = -1;
            string mess = "";

            bool isOK = ValidateUserPayPassword(hotelweixinId, userweixinId, payPassword, out mess);

            if (isOK)
            {
                status = 0;
            }


            return Json(new
            {
                Status = status,
                Mess = mess

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
        

        private decimal GetPayOrderMoney(string orderNo)
        {
            decimal payMoney = 0;

            //团购预售
            if (orderNo.Contains("p"))
            {


                var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from SaleProducts_Orders with(nolock) where OrderNo=@OrderNo", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}}
                        });

                payMoney = Convert.ToDecimal(Convert.ToDecimal(dt.Rows[0]["orderMoney"].ToString()));

            }


               //餐饮
            else if (orderNo.Contains("l"))
            {
                var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from T_OrderInfo with(nolock) where orderCode=@OrderNo", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}}
                        });
                payMoney = Convert.ToDecimal(Convert.ToDecimal(dt.Rows[0]["payamount"].ToString()));

            }



               //超市
            else if (orderNo.Contains("d"))
            {
                var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from SupermarketOrder_Levi with(nolock) where OrderId=@OrderId", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"OrderId",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}}
                        });
                payMoney = Convert.ToDecimal(Convert.ToDecimal(dt.Rows[0]["money"].ToString()));

            }

             //酒店
            else
            {
                var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from HotelOrder with(nolock) where OrderNo=@OrderNo", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}}
                        });
                payMoney = Convert.ToDecimal(Convert.ToDecimal(dt.Rows[0]["sSumPrice"].ToString()));

            }

            return payMoney;
        }


        private bool ValidateUserPayPassword(string hotelweixinId, string userweixinId, string payPassword, out string mess)
        {

            DataTable db_member = RechargeCard.GetRechargeMemberPayPassword(hotelweixinId, userweixinId);

            if (db_member.Rows[0]["pwd"].ToString() == string.Empty)
            {
                mess = "未设置支付密码";
            }

            else if (payPassword == db_member.Rows[0]["pwd"].ToString())
            {
                mess = "";
                return true;
            }

            else
            {
                mess = "密码错误";
            }


            return false;
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
