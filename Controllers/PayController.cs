using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Collections.Specialized;
using hotel3g.Repository;
using System.Xml;
using hotel3g.Common;

namespace hotel3g.Controllers
{
    public class PayController : Controller
    {
        log4net.ILog logger = log4net.LogManager.GetLogger(typeof(PayController));
        // GET: /Pay/

        static string Prefix = "wn";
        public ActionResult PayList(string hotelId,string id)
        {
            string ordercode = HotelCloud.Common.HCRequest.GetString("d");
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("ux");

            ViewData["data"] = null;
            if (!string.IsNullOrEmpty(ordercode) && !string.IsNullOrEmpty(userWeiXinID))
            {
                ViewData["data"] = OrderRepository.GetOrderByCode(ordercode, userWeiXinID);
            }

            //获取会员卡
            string cardno = hotel3g.Repository.MemberHelper.GetCardNo(userWeiXinID, weixinID);
            ViewData["cardno"] = cardno;
            ViewData["MemberInfo"] = hotel3g.Repository.MemberHelper.GetMemberInfo(id);
            ViewData["MemberCard"] = hotel3g.Repository.MemberHelper.GetMemberCard(cardno, id);

            return View();
        }

        public ActionResult AlipayPay()
        {
            ViewData["html"] = string.Empty;
            try
            {
                int OrderId = Convert.ToInt32(Request.QueryString["id"]);
                if (OrderId > 0)
                {
                    hotel3g.Repository.Order order = hotel3g.Repository.OrderRepository.GetOrderInfo(OrderId);

                    MemberInfo MemberInfoDeatil = hotel3g.Repository.MemberHelper.GetMemberInfo(order.HotelID.ToString());
                    //获取会员卡

                    string cardno =
                        hotel3g.Repository.MemberHelper.GetCardNo(order.UserWeiXinID, order.WeiXinID);
               
                    MemberCard Card= hotel3g.Repository.MemberHelper.GetMemberCard(cardno, order.HotelID.ToString());
                    decimal Discount = hotel3g.Repository.MemberHelper.GetDiscountByRatePlanID(order.RatePlanID.ToString(),order.HotelID.ToString())/10;

                    //获取会员 折扣
                    decimal rate = 0;

                    #region 
                    if (!string.IsNullOrEmpty(cardno) && MemberInfoDeatil!=null)
                    {
                        if (Card.night >= MemberInfoDeatil.vip4 && MemberInfoDeatil.vip4 >0&& MemberInfoDeatil.vip4rate > 0)
                        {
                            rate = MemberInfoDeatil.vip4rate;
                        }
                        else if (Card.night >= MemberInfoDeatil.vip3 && MemberInfoDeatil.vip3>0 && MemberInfoDeatil.vip3rate > 0)
                        {
                            rate = MemberInfoDeatil.vip3rate;
                        }
                        else if (Card.night >= MemberInfoDeatil.vip2 && MemberInfoDeatil.vip2>0 && MemberInfoDeatil.vip2rate > 0)
                        {
                            rate = MemberInfoDeatil.vip2rate;
                        }
                        else if (Card.night >= MemberInfoDeatil.vip1 && MemberInfoDeatil.vip1>0 && MemberInfoDeatil.vip1rate > 0)
                        {
                            rate = MemberInfoDeatil.vip1rate;
                        }
                        else if (Card.night >= MemberInfoDeatil.vip0 && MemberInfoDeatil.vip0rate > 0)
                        {
                            rate = MemberInfoDeatil.vip0rate;
                        }
                    }
                    #endregion


                    if (order == null || order.PayType != "0")
                    {
                        throw new HttpException(404, "404");
                    }
                    ////////////////////////////////////////////调用授权接口alipay.wap.trade.create.direct获取授权码token////////////////////////////////////////////
                    //返回格式
                    string format = "xml";
                    //必填，不需要修改
                    //返回格式
                    string v = "2.0";
                    //必填，不需要修改
                    //请求号
                    string req_id = DateTime.Now.ToString("yyyyMMddHHmmss");
                    //必填，须保证每次请求都是唯一
                    //req_data详细信息
                    //服务器异步通知页面路径
                    string notify_url = GlobalConfig.WebSite + "/AliPay/AlipayNotify.html";
                    //需http://格式的完整路径，不允许加?id=123这类自定义参数
                    //页面跳转同步通知页面路径
                    string call_back_url = GlobalConfig.WebSite + "/AliPay/AlipayCallback.html";
                    //需http://格式的完整路径，不允许加?id=123这类自定义参数
                    //操作中断返回地址
                    string merchant_url = GlobalConfig.WebSite + "/Pay/Result";
                    //用户付款中途退出返回商户的地址。需http://格式的完整路径，不允许加?id=123这类自定义参数
                    //卖家支付宝帐户
                    string seller_email = WayAlipay.Alipay.Config.SellerEmail;
                    //必填
                    //商户订单号
                    string out_trade_no = Prefix + order.Id.ToString();
                    //商户网站订单系统中唯一订单号，必填
                    //订单名称
                    string subject = order.HotelName.Trim() + "  " + order.RoomName + (string.IsNullOrEmpty(order.RatePlanName) ? "" : string.Format("({0})", order.RatePlanName));
                    //必填
                    //付款金额
                    //string total_fee = ((int)Math.Ceiling((order.OrderAmount * Discount) * (rate / 10))).ToString();
                    string total_fee = ((int)Math.Ceiling(order.OrderAmount * (rate / 10))).ToString();
                    //必填
                    //请求业务参数详细
                    string req_dataToken = "<direct_trade_create_req><notify_url>" + notify_url + "</notify_url><call_back_url>" + call_back_url + "</call_back_url><seller_account_name>" + seller_email + "</seller_account_name><out_trade_no>" + out_trade_no + "</out_trade_no><subject>" + subject + "</subject><total_fee>" + total_fee + "</total_fee><merchant_url>" + merchant_url + "</merchant_url></direct_trade_create_req>";
                    //必填
                    //把请求参数打包成数组
                    Dictionary<string, string> sParaTempToken = new Dictionary<string, string>();
                    sParaTempToken.Add("partner", WayAlipay.Alipay.Config.Partner);
                    sParaTempToken.Add("_input_charset", WayAlipay.Alipay.Config.Input_charset.ToLower());
                    sParaTempToken.Add("sec_id", WayAlipay.Alipay.Config.Sign_type.ToUpper());
                    sParaTempToken.Add("service", "alipay.wap.trade.create.direct");
                    sParaTempToken.Add("format", format);
                    sParaTempToken.Add("v", v);
                    sParaTempToken.Add("req_id", req_id);
                    sParaTempToken.Add("req_data", req_dataToken);

                    //建立请求
                    string sHtmlTextToken = WayAlipay.Alipay.Submit.BuildRequest(sParaTempToken);
                    //URLDECODE返回的信息
                    System.Text.Encoding code = System.Text.Encoding.GetEncoding(WayAlipay.Alipay.Config.Input_charset);
                    sHtmlTextToken = HttpUtility.UrlDecode(sHtmlTextToken, code);

                    //解析远程模拟提交后返回的信息
                    Dictionary<string, string> dicHtmlTextToken = WayAlipay.Alipay.Submit.ParseResponse(sHtmlTextToken);

                    //获取token
                    string request_token = dicHtmlTextToken["request_token"];

                    ////////////////////////////////////////////根据授权码token调用交易接口alipay.wap.auth.authAndExecute////////////////////////////////////////////
                    //业务详细
                    string req_data = "<auth_and_execute_req><request_token>" + request_token + "</request_token></auth_and_execute_req>";
                    //必填

                    //把请求参数打包成数组
                    Dictionary<string, string> sParaTemp = new Dictionary<string, string>();
                    sParaTemp.Add("partner", WayAlipay.Alipay.Config.Partner);
                    sParaTemp.Add("_input_charset", WayAlipay.Alipay.Config.Input_charset.ToLower());
                    sParaTemp.Add("sec_id", WayAlipay.Alipay.Config.Sign_type.ToUpper());
                    sParaTemp.Add("service", "alipay.wap.auth.authAndExecute");
                    sParaTemp.Add("format", format);
                    sParaTemp.Add("v", v);
                    sParaTemp.Add("req_data", req_data);

                    //建立请求
                    string sHtmlText = WayAlipay.Alipay.Submit.BuildRequest(sParaTemp, "get", "确认");
                    ViewData["html"] = sHtmlText;
                }
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("淘宝wap支付调用异常-{0}", ex.Message.ToString());
            }
            return View();
        }

        public ActionResult AliPaySuccess(string hotelid)
        {
            ViewData["user"] = "/";
            //PocketLZN.Domain.UserInfo user = PocketLZN.Common.FunSession.GetSession() as PocketLZN.Domain.UserInfo;
            //if (user != null)
            //{
            //    ViewData["user"] = "/account/orders";
            //}
            string code = Request.QueryString["code"];
            ViewData["code"] = code;
            ViewData["error"] = Session["alipay_error"];
            ViewData["data"] = null;
            try
            {
                string order = Request.QueryString["d"];
                if (!string.IsNullOrEmpty(order))
                {
                    Order wp = OrderRepository.GetOrderInfo(Convert.ToInt32(order));
                    if (wp != null)
                    {
                        if (hotelid == wp.HotelID.ToString())
                        {
                            ViewData["data"] = wp;
                        }
                    }
                }
            }
            catch (Exception ex)
            {

            }
            return View();
        }

        public ActionResult Result()
        {
            //return View();
            /*异常支付*/
            logger.ErrorFormat("wap支付中断");
            return Redirect("/");
        }



        /// <summary>
        /// 支付宝异步通知
        /// </summary>
        /// <returns></returns>
        [ValidateInput(false)]
        public string Notify()
        {
            bool flag = false;
            string error = string.Empty;
            try
            {
                logger.ErrorFormat("wap支付异步回调");
                int hotelId = 0;
                Dictionary<string, string> sPara = GetRequestPost();
                if (sPara.Count > 0)//判断是否有带返回参数
                {
                    WayAlipay.Alipay.Notify aliNotify = new WayAlipay.Alipay.Notify();
                    bool verifyResult = aliNotify.VerifyNotify(sPara, Request.Form["sign"]);
                    if (verifyResult)//验证成功
                    {
                        /////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        //请在这里加上商户的业务逻辑程序代码
                        //——请根据您的业务逻辑来编写程序（以下代码仅作参考）——
                        //获取支付宝的通知返回参数，可参考技术文档中服务器异步通知参数列表
                        //解密（如果是RSA签名需要解密，如果是MD5签名则下面一行清注释掉）
                        sPara = aliNotify.Decrypt(sPara);
                        //XML解析notify_data数据
                        try
                        {
                            XmlDocument xmlDoc = new XmlDocument();
                            xmlDoc.LoadXml(sPara["notify_data"]);
                            //商户订单号
                            string out_trade_no = xmlDoc.SelectSingleNode("/notify/out_trade_no").InnerText;
                            //支付宝交易号
                            string trade_no = xmlDoc.SelectSingleNode("/notify/trade_no").InnerText;
                            //交易状态
                            string trade_status = xmlDoc.SelectSingleNode("/notify/trade_status").InnerText;

                            //日志记录
                            logger.ErrorFormat("wap支付异步回调信息{0}-{1}", out_trade_no, xmlDoc.InnerXml.ToString());
                            if (trade_status == "TRADE_FINISHED" || trade_status == "TRADE_SUCCESS")
                            {
                                //判断该笔订单是否在商户网站中已经做过处理
                                //如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
                                //如果有做过处理，不执行商户的业务程序
                                //注意：
                                //该种交易状态只在两种情况下出现
                                //1、开通了普通即时到账，买家付款成功后。
                                //2、开通了高级即时到账，从该笔交易成功时间算起，过了签约时的可退款时限（如：三个月以内可退款、一年以内可退款等）后。
                                flag = OrderHandle(true, out_trade_no, trade_no, trade_status, xmlDoc.SelectSingleNode("/notify/total_fee").InnerText, out hotelId);
                            }
                            else
                            {
                                error = trade_status;
                            }

                        }
                        catch (Exception exc)
                        {
                            flag = false;
                            logger.ErrorFormat("wap支付异步回调异常-{0}", exc.Message.ToString());
                        }
                        //——请根据您的业务逻辑来编写程序（以上代码仅作参考）——
                        /////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    }
                    else//验证失败
                    {
                        error = "fail";
                    }
                }
                else
                {
                    error = "无通知参数";
                }
            }
            catch (Exception ex)
            {
                flag = false;
                logger.ErrorFormat("wap支付异步回调异常-{0}", ex.Message.ToString());
            }
            if (flag)
            {
                error = "success";
            }
            string result = flag == true ? "success" : "fail";
            return result;
        }

        /// <summary>
        /// 支付宝回调
        /// </summary>
        /// <returns></returns>
        public ActionResult OrderTrade()
        {
            bool flag = false;
            string error = string.Empty;
            Dictionary<string, string> sPara = GetRequestGet();
            string out_trade_no = string.Empty;

            int hotelId = 0;
            if (sPara.Count > 0)//判断是否有带返回参数
            {
                WayAlipay.Alipay.Notify aliNotify = new WayAlipay.Alipay.Notify();
                bool verifyResult = aliNotify.VerifyReturn(sPara, Request.QueryString["sign"]);

                if (verifyResult)//验证成功
                {
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    //请在这里加上商户的业务逻辑程序代码
                    //——请根据您的业务逻辑来编写程序（以下代码仅作参考）——
                    //获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表
                    //商户订单号
                    out_trade_no = Request.QueryString["out_trade_no"];
                    //支付宝交易号
                    string trade_no = Request.QueryString["trade_no"];
                    //交易状态
                    string result = Request.QueryString["result"];
                    //判断是否在商户网站中已经做过了这次通知返回的处理
                    //如果没有做过处理，那么执行商户的业务程序
                    //如果有做过处理，那么不执行商户的业务程序
                    //打印页面
                    //日志记录
                    logger.ErrorFormat("wap支付同步回调信息{0}-{1}", out_trade_no, Request.Url);
                    if (result == "success")
                    {
                        flag = OrderHandle(false, out_trade_no, trade_no, "TRADE_FINISHED", "0", out hotelId);
                    }
                    //——请根据您的业务逻辑来编写程序（以上代码仅作参考）——
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
                }
                else//验证失败
                {
                    error = "验证失败";
                }
            }
            else
            {
                error = "无返回参数";
            }
            if (flag)
            {
                error = "success";
            }
            Session["alipay_error"] = error;
            return RedirectToAction("AliPaySuccess", new { hotelId = hotelId, code = (flag == true ? "0000" : "1000"), key = HotelHotel.Utility.Utility.GetGuidString(), d = out_trade_no.Replace(Prefix, "") });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="Async">是否异步</param>
        /// <param name="OutTradeNo"></param>
        /// <param name="tradeNo"></param>
        /// <param name="tradeStatus"></param>
        /// <param name="aliPayAmount"></param>
        /// <returns></returns>
        private bool OrderHandle(bool Async, string OutTradeNo, string tradeNo, string tradeStatus, string aliPayAmount, out int hotelId)
        {
            bool flag = false;
            int xhotelid = 0;
            try
            {
                int orderId = Convert.ToInt32(OutTradeNo.Replace(Prefix, ""));
                decimal orderAmount = Convert.ToDecimal(aliPayAmount);
                if (orderId > 0)
                {
                    Order order = OrderRepository.GetOrderInfo(orderId);
                    if (order != null && order.Id > 0)
                    {
                        xhotelid = order.HotelID;
                        if ((order.TradeStatus == "TRADE_FINISHED" || order.TradeStatus == "TRADE_SUCCESS") && order.TradeAlipayAmount > 0)
                        {
                            hotelId = xhotelid;
                            //已经处理了
                            return true;
                        }
                        else
                        {
                            order.TradeAlipayAmount = orderAmount;
                            if (!Async)
                            {
                                order.TradeAlipayAmount = order.OrderAmount;
                                aliPayAmount = order.TradeAlipayAmount.ToString();
                            }
                            order.TradeNo = tradeNo;
                            order.TradeStatus = tradeStatus;
                            order.AlipayTime = DateTime.Now.ToString();
                            order.State = 10;//已付款
                            order.Remark = order.Remark + string.Format(" [::{1}wap支付宝({2})支付成功{0}]", aliPayAmount, DateTime.Now.ToString(), Async == true ? "异步" : "同步");
                            flag = OrderRepository.SaveAliPayOrder(order);
                            //发送短信
                            hotel3g.Models.Hotel hotel = hotel3g.Models.Cache.GetHotel(Convert.ToInt32(order.HotelID));
                            hotel.SmsMobile = hotel3g.Models.Cache.GetMobile(hotel.WeiXinID);
                            string tsql = @"insert into Tasks(TaskContent,TaskTime,TaskState,weixinid,hotelid,SendState,mobile,orderNO,TaskType) values(@Content,getdate(),0,@Uwx,@Hid,0,@mobile,@orderNO,'2')";
                            int createStatus = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"Content",new HotelCloud.SqlServer.DBParam{ParamValue=string.Format("{7}({0})预订{1}间{2}{3}{4}元,{5}入住{6}退房[微可牛]",
                                    order.LinkTel.ToString(),order.RoomNum.ToString(),
                                    order.RoomName.ToString(),order.RatePlanName.ToString(),order.SumPrice,
                                    order.ComeDate,order.LeaveDate,order.UserName)}},
                                {"Uwx",new HotelCloud.SqlServer.DBParam{ParamValue=order.UserWeiXinID}},
                                {"Hid",new HotelCloud.SqlServer.DBParam{ParamValue=order.HotelID.ToString()}},
                                {"mobile",new HotelCloud.SqlServer.DBParam{ParamValue=hotel.SmsMobile}},             
                                {"orderNO",new HotelCloud.SqlServer.DBParam{ParamValue=order.Id.ToString()}},
                            });

                            tsql = @"insert into Tasks(TaskContent,TaskTime,TaskState,weixinid,hotelid,SendState,mobile,orderNO,TaskType) values(@Content,getdate(),0,@Uwx,@Hid,0,@mobile,@orderNO,'2')";
                            HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "Content", new HotelCloud.SqlServer.DBParam { ParamValue = "您的订单已提交，工作人员会尽快与您联系，核实并确认您的订单信息，以工作人员确认为准。[微可牛]" } }, { "Uwx", new HotelCloud.SqlServer.DBParam { ParamValue = order.UserWeiXinID } }, { "Hid", new HotelCloud.SqlServer.DBParam { ParamValue = order.HotelID.ToString() } }, { "mobile", new HotelCloud.SqlServer.DBParam { ParamValue = order.LinkTel.ToString() } }, { "orderNO", new HotelCloud.SqlServer.DBParam { ParamValue = order.Id.ToString() } } });


                            if (!flag)
                            {
                                logger.ErrorFormat(string.Format("::wap支付回调保存失败:{0}-{1}-{2}-{3}", order.Id, tradeNo, tradeStatus, aliPayAmount));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("处理支付回调异常-{0}", ex.Message.ToString());
            }
            hotelId = xhotelid;
            return flag;
        }
        /// <summary>
        /// 获取支付宝GET过来通知消息，并以“参数名=参数值”的形式组成数组
        /// </summary>
        /// <returns>request回来的信息组成的数组</returns>
        public Dictionary<string, string> GetRequestGet()
        {
            int i = 0;
            Dictionary<string, string> sArray = new Dictionary<string, string>();
            NameValueCollection coll;
            //Load Form variables into NameValueCollection variable.
            coll = Request.QueryString;

            // Get names of all forms into a string array.
            String[] requestItem = coll.AllKeys;

            for (i = 0; i < requestItem.Length; i++)
            {
                sArray.Add(requestItem[i], Request.QueryString[requestItem[i]]);
            }

            return sArray;
        }

        /// <summary>
        /// 获取支付宝POST过来通知消息，并以“参数名=参数值”的形式组成数组
        /// </summary>
        /// <returns>request回来的信息组成的数组</returns>
        public Dictionary<string, string> GetRequestPost()
        {
            int i = 0;
            Dictionary<string, string> sArray = new Dictionary<string, string>();
            NameValueCollection coll;
            //Load Form variables into NameValueCollection variable.
            coll = Request.Form;

            // Get names of all forms into a string array.
            String[] requestItem = coll.AllKeys;

            for (i = 0; i < requestItem.Length; i++)
            {
                sArray.Add(requestItem[i], Request.Form[requestItem[i]]);
            }

            return sArray;
        }
    }
}
