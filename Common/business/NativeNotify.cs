using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WxPayAPI
{
    /// <summary>
    /// 扫码支付模式一回调处理类
    /// 接收微信支付后台发送的扫码结果，调用统一下单接口并将下单结果返回给微信支付后台
    /// </summary>
    public class NativeNotify:Notify
    {
        public NativeNotify(Page page):base(page){}
        public override void ProcessNotify()
        {
            WxPayData notifyData = GetNotifyData();
            //检查openid和product_id是否返回
            if (!notifyData.IsSet("openid") || !notifyData.IsSet("product_id"))
            {
                WxPayData res = new WxPayData();
                res.SetValue("return_code", "FAIL");
                res.SetValue("return_msg", "回调数据异常");
                Log.Info(this.GetType().ToString(), "The data WeChat post is error : " + res.ToXml());
                page.Response.Write(res.ToXml());
                page.Response.End();
            }
            //调统一下单接口，获得下单结果
            string openid = notifyData.GetValue("openid").ToString();
            string product_id = notifyData.GetValue("product_id").ToString();
            WxPayData unifiedOrderResult = new WxPayData();
            try
            {
                unifiedOrderResult = UnifiedOrder(openid, product_id);
            }
            catch(Exception ex)//若在调统一下单接口时抛异常，立即返回结果给微信支付后台
            {
                WxPayData res = new WxPayData();
                res.SetValue("return_code", "FAIL");
                res.SetValue("return_msg", "统一下单失败");
                Log.Error(this.GetType().ToString(), "UnifiedOrder failure : " + res.ToXml());
                page.Response.Write(res.ToXml());
                page.Response.End();
            }

            //若下单失败，则立即返回结果给微信支付后台
            if (!unifiedOrderResult.IsSet("appid") || !unifiedOrderResult.IsSet("mch_id") || !unifiedOrderResult.IsSet("prepay_id"))
            {
                WxPayData res = new WxPayData();
                res.SetValue("return_code", "FAIL");
                res.SetValue("return_msg", "统一下单失败");
                Log.Error(this.GetType().ToString(), "UnifiedOrder failure : " + res.ToXml());
                page.Response.Write(res.ToXml());
                page.Response.End();
            }

            //统一下单成功,则返回成功结果给微信支付后台
            WxPayData data = new WxPayData();
            data.SetValue("return_code", "SUCCESS");
            data.SetValue("return_msg", "OK");
            data.SetValue("appid", WxPayConfig.APPID);
            data.SetValue("mch_id", WxPayConfig.MCHID);
            data.SetValue("nonce_str", WxPayApi.GenerateNonceStr());
            data.SetValue("prepay_id", unifiedOrderResult.GetValue("prepay_id"));
            data.SetValue("result_code", "SUCCESS");
            data.SetValue("err_code_des", "OK");
            data.SetValue("sign", data.MakeSign());

            Log.Info(this.GetType().ToString(), "UnifiedOrder success , send data to WeChat : " + data.ToXml());
            page.Response.Write(data.ToXml());
            page.Response.End();
        }

        private WxPayData UnifiedOrder(string openId,string productId)
        {
            WxPayData req = new WxPayData();            
            if (productId.Contains("C")){
                var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from WeiXin..RechargeUser  where OrderNo=@OrderNo", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                    {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=productId}}
                });
                if (dt.Rows.Count > 0)
                {
                    foreach (System.Data.DataRow dr in dt.Rows)
                    {
                        int total_fee = Convert.ToInt32(Convert.ToDecimal(dr["SPrice"].ToString()) * 100);

                        /** ================Ashbur微信号对应支付金额 0.01元========= */
                        if (openId == "oPfrcjmqyO33T8a8Dn21Kq-QMAcg") { total_fee = 1; }
                        if (openId == "oUM4bwdTr3DXhUkGf43lGiipmxMA") { total_fee = 1; }
                        if (openId == "oZLQzv-cg1KvGmrTnq0xdxhK-4kc") { total_fee = 1; }

                        if (string.IsNullOrEmpty(openId))
                            WxPayAPI.Log.Error(this.GetType().ToString(), "wxOAuthRedirect|This page have not get params, cannot be inited, exit...");
                        else
                        {
                            req.SetValue("body", "充值费用");
                            req.SetValue("attach", "presale"); 
                            req.SetValue("out_trade_no", dr["OrderNo"].ToString().Trim());
                            req.SetValue("total_fee", total_fee);
                            req.SetValue("time_start", DateTime.Now.ToString("yyyyMMddHHmmss"));
                            req.SetValue("time_expire", DateTime.Now.AddMinutes(30).ToString("yyyyMMddHHmmss"));
                            req.SetValue("goods_tag", "充值");
                            req.SetValue("trade_type", "NATIVE");
                            req.SetValue("openid", openId);
                            req.SetValue("product_id", dr["HotelId"].ToString().Trim());
                        }
                    }
                }
                else { WxPayAPI.Log.Debug(this.GetType().ToString(), "无效订单或者非预订订单"); }
            }
            else if (productId.Contains("K"))
            {
                var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from WeiXin..MemberCardBuyRecord  where OrderNo=@OrderNo", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                    {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=productId}}
                });
                if (dt.Rows.Count > 0)
                {
                    foreach (System.Data.DataRow dr in dt.Rows)
                    {
                        int total_fee = Convert.ToInt32(Convert.ToDecimal(dr["BuyMoney"].ToString()) * 100);

                        /** ================Ashbur微信号对应支付金额 0.01元========= */
                        if (openId == "oPfrcjmqyO33T8a8Dn21Kq-QMAcg") { total_fee = 1; }
                        if (openId == "oUM4bwdTr3DXhUkGf43lGiipmxMA") { total_fee = 1; }
                        if (openId == "oZLQzv-cg1KvGmrTnq0xdxhK-4kc") { total_fee = 1; }

                        if (string.IsNullOrEmpty(openId))
                            WxPayAPI.Log.Error(this.GetType().ToString(), "wxOAuthRedirect|This page have not get params, cannot be inited, exit...");
                        else
                        {
                            req.SetValue("body", "会员卡购买");
                            req.SetValue("attach", "presale"); 
                            req.SetValue("out_trade_no", dr["OrderNo"].ToString().Trim());
                            req.SetValue("total_fee", total_fee);
                            req.SetValue("time_start", DateTime.Now.ToString("yyyyMMddHHmmss"));
                            req.SetValue("time_expire", DateTime.Now.AddMinutes(30).ToString("yyyyMMddHHmmss"));
                            req.SetValue("goods_tag", "会员卡消费");
                            req.SetValue("trade_type", "NATIVE");
                            req.SetValue("openid", openId);
                            req.SetValue("product_id", dr["HotelId"].ToString().Trim());
                        }
                    }
                }
                else { WxPayAPI.Log.Debug(this.GetType().ToString(), "无效订单或者非预订订单"); }
            }
            else if (productId.IndexOf("D") > -1)
            {
                var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from WeiXin..SupermarketOrder_Levi where OrderId=@OrderId", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                    {"OrderId",new HotelCloud.SqlServer.DBParam{ParamValue=productId}}
                });
                if (dt.Rows.Count > 0)
                {
                    foreach (System.Data.DataRow dr in dt.Rows)
                    {
                        int total_fee = Convert.ToInt32(Convert.ToDecimal(dr["Money"].ToString()) * 100);

                        /** ================Ashbur微信号对应支付金额 0.01元========= */
                        if (openId == "oPfrcjmqyO33T8a8Dn21Kq-QMAcg") { total_fee = 1; }
                        if (openId == "oUM4bwdTr3DXhUkGf43lGiipmxMA") { total_fee = 1; }
                        if (openId == "oZLQzv-cg1KvGmrTnq0xdxhK-4kc") { total_fee = 1; }

                        if (string.IsNullOrEmpty(openId))
                            WxPayAPI.Log.Error(this.GetType().ToString(), "wxOAuthRedirect|This page have not get params, cannot be inited, exit...");
                        else
                        {
                            req.SetValue("body", "酒店周边超市消费");
                            req.SetValue("attach", "consumption"); 
                            req.SetValue("out_trade_no", dr["OrderId"].ToString().Trim());
                            req.SetValue("total_fee", total_fee);
                            req.SetValue("time_start", DateTime.Now.ToString("yyyyMMddHHmmss"));
                            req.SetValue("time_expire", DateTime.Now.AddMinutes(30).ToString("yyyyMMddHHmmss"));
                            req.SetValue("goods_tag", "酒店周边超市消费");
                            req.SetValue("trade_type", "NATIVE");
                            req.SetValue("openid", openId);
                            req.SetValue("product_id", dr["HotelId"].ToString().Trim());
                        }   
                    }
                }
                else { WxPayAPI.Log.Debug(this.GetType().ToString(), "无效订单或者非预订订单"); } 
            }else  if (productId.Contains("P")){
                var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from WeiXin..SaleProducts_Orders where OrderNo=@OrderNo", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                    {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=productId}}
                });
                if (dt.Rows.Count > 0)
                {
                    foreach (System.Data.DataRow dr in dt.Rows)
                    {
                        int total_fee = Convert.ToInt32(Convert.ToDecimal(dr["OrderMoney"].ToString()) * 100);

                        /** ================Ashbur微信号对应支付金额 0.01元========= */
                        if (openId == "oPfrcjmqyO33T8a8Dn21Kq-QMAcg") { total_fee = 1; }
                        if (openId == "oUM4bwdTr3DXhUkGf43lGiipmxMA") { total_fee = 1; }
                        if (openId == "oZLQzv-cg1KvGmrTnq0xdxhK-4kc") { total_fee = 1; }

                        if (string.IsNullOrEmpty(openId))
                            WxPayAPI.Log.Error(this.GetType().ToString(), "wxOAuthRedirect|This page have not get params, cannot be inited, exit...");
                        else
                        {
                            req.SetValue("body", dr["ProductName"].ToString().Trim());
                            req.SetValue("attach", "presale"); 
                            req.SetValue("out_trade_no", dr["OrderNo"].ToString().Trim());
                            req.SetValue("total_fee", total_fee);
                            req.SetValue("time_start", DateTime.Now.ToString("yyyyMMddHHmmss"));
                            req.SetValue("time_expire", DateTime.Now.AddMinutes(30).ToString("yyyyMMddHHmmss"));
                            req.SetValue("goods_tag", dr["ProductName"].ToString().Trim() + "[" + dr["TcName"].ToString().Trim() + "]");
                            req.SetValue("trade_type", "NATIVE");
                            req.SetValue("openid", openId);
                            req.SetValue("product_id", dr["HotelId"].ToString().Trim());
                        }
                    }
                }
                else { WxPayAPI.Log.Debug(this.GetType().ToString(), "无效订单或者非预订订单"); }
            }
            else if (productId.Contains("L"))
            {
                var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 bagging,amount,youhuiamount,ISNULL(CouponMoney,0) as CouponMoney,hotelid,userweixinid,hotelWeixinId,orderCode,(select sum(AliPayAmount) from  WeiXin..wkn_payrecords where OrderNO=orderCode and Channel='微信支付回调') as zhifu  from WeiXin..T_OrderInfo where orderCode=@orderCode", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"orderCode",new HotelCloud.SqlServer.DBParam{ParamValue=productId}}
                        });
                if (dt.Rows.Count > 0)
                {
                    foreach (System.Data.DataRow dr in dt.Rows)
                    {
                        string bagging = dr["bagging"].ToString();
                        string youhuiamount = dr["youhuiamount"].ToString();
                        if (string.IsNullOrEmpty(bagging)) { bagging = "0"; }
                        if (string.IsNullOrEmpty(youhuiamount)) { youhuiamount = "0"; }
                        int total_fee = Convert.ToInt32((Convert.ToDecimal(dr["amount"].ToString()) - Convert.ToDecimal(youhuiamount) + Convert.ToDecimal(bagging) - Convert.ToDecimal(dr["CouponMoney"].ToString())) * 100);

                        /** ================Ashbur微信号对应支付金额 0.01元========= */
                        if (openId == "oPfrcjmqyO33T8a8Dn21Kq-QMAcg") { total_fee = 1; }
                        if (openId == "oUM4bwdTr3DXhUkGf43lGiipmxMA") { total_fee = 1; }
                        if (openId == "oZLQzv-cg1KvGmrTnq0xdxhK-4kc") { total_fee = 1; }

                        if (string.IsNullOrEmpty(openId))
                            WxPayAPI.Log.Error(this.GetType().ToString(), "wxOAuthRedirect|This page have not get params, cannot be inited, exit...");
                        else
                        {
                            req.SetValue("body", "酒店周边餐饮消费");
                            req.SetValue("attach", "consumption"); 
                            req.SetValue("out_trade_no", dr["orderCode"].ToString().Trim());
                            req.SetValue("total_fee", total_fee);
                            req.SetValue("time_start", DateTime.Now.ToString("yyyyMMddHHmmss"));
                            req.SetValue("time_expire", DateTime.Now.AddMinutes(30).ToString("yyyyMMddHHmmss"));
                            req.SetValue("goods_tag", "酒店周边餐饮消费");
                            req.SetValue("trade_type", "NATIVE");
                            req.SetValue("openid", openId);
                            req.SetValue("product_id", dr["hotelid"].ToString().Trim());
                        }
                    }
                }
                else { WxPayAPI.Log.Debug(this.GetType().ToString(), "无效订单或者非预订订单"); }
            }
            else
            {
                hotel3g.Repository.Order order = hotel3g.Repository.OrderRepository.GetOrderInfo(productId);
                if (order == null || order.PayType != "0")
                    WxPayAPI.Log.Debug(this.GetType().ToString(), "无效订单或者非预订订单");
                else
                {
                    int total_fee = order.OrderAmount * 100;//Convert.ToInt32(((int)Math.Ceiling(order.OrderAmount * (rate / 10))).ToString()) * 100;

                    /** ================Ashbur微信号对应支付金额 0.01元========= */
                    if (openId == "oPfrcjmqyO33T8a8Dn21Kq-QMAcg") { total_fee = 1; }
                    if (openId == "oUM4bwdTr3DXhUkGf43lGiipmxMA") { total_fee = 1; }
                    if (openId == "oZLQzv-cg1KvGmrTnq0xdxhK-4kc") { total_fee = 1; }

                    if (string.IsNullOrEmpty(openId))
                        WxPayAPI.Log.Error(this.GetType().ToString(), "wxOAuthRedirect|This page have not get params, cannot be inited, exit...");
                    else
                    {
                        req.SetValue("body", order.HotelName.Trim());
                        req.SetValue("attach", "weikeniuwx"); 
                        req.SetValue("out_trade_no", order.OrderNo);
                        req.SetValue("total_fee", total_fee);
                        req.SetValue("time_start", DateTime.Now.ToString("yyyyMMddHHmmss"));
                        req.SetValue("time_expire", DateTime.Now.AddMinutes(30).ToString("yyyyMMddHHmmss"));
                        req.SetValue("goods_tag", order.RoomName + "[" + order.RatePlanName + "]");
                        req.SetValue("trade_type", "NATIVE");
                        req.SetValue("openid", openId);
                        req.SetValue("product_id", order.HotelID.ToString());
                    }
                }
            }            
            WxPayData result = WxPayApi.UnifiedOrder(req);
            return result;
        }
    }
}