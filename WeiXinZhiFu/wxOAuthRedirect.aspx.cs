using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using hotel3g.Common;
using hotel3g.Repository;

namespace hotel3g.WeiXinZhiFu
{
    [Serializable]
    public partial class wxcheckTokenUrl
    {
        public string access_token { get; set; }
        public string expires_in { get; set; }
        public string refresh_token { get; set; }
        public string openid { get; set; }
        public string scope { get; set; }
    }
    public partial class wxOAuthRedirect : System.Web.UI.Page
    {
        public static string wxJsApiParam { get; set; }
        public static string orderid { get; set; }
        public static string HotelID { get; set; }
        public static string UserWeiXinID { get; set; }
        public static string WeiXinID { get; set; }
        public static string Zhifu { get; set; }
        public static string edition { get; set; }
        public static string storeId { get; set; }
        public static string error { get; set; }

        /** ================获取酒店公众号对应的用户openid========= */
        public static string getopenid(string WeiXinID, string code)
        {
            try
            {
                WxPayAPI.Log.Debug("获取openid".ToString(), WeiXinID + "|" + code);
                /** ================ 微可牛平台助手对应的额appid  secret mchid========= */
                string appid = "wx9f84537c7ce94a29", secret = "0298097591924bdbd67ed5ee28f0c75d", mchid = "1464378202";

                /** ================如果公众号存在商户号========= */
                var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 appkey,appid,mchid from WeiXin..WeiXinNO with(nolock)  where WeiXinID=@WeiXinID and iszhifu=1", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "WeiXinID", new HotelCloud.SqlServer.DBParam { ParamValue = WeiXinID.Trim() } } });
                if (dt.Rows.Count > 0)
                {
                    foreach (System.Data.DataRow dr in dt.Rows)
                    {
                        appid = dr["appid"].ToString().Trim();
                        secret = dr["appkey"].ToString().Trim();
                        mchid = dr["MCHID"].ToString().Trim();
                    }
                }
                hotel3g.Models.Cookies.SetCookies("tb1", WxPayAPI.WxPayConfig.Encrypt(appid), 1, "wx"); 
                hotel3g.Models.Cookies.SetCookies("tb2", WxPayAPI.WxPayConfig.Encrypt(secret), 1, "wx");    
                hotel3g.Models.Cookies.SetCookies("tb3", WxPayAPI.WxPayConfig.Encrypt(mchid), 1, "wx");  

                var checkTokenUrl = string.Format("https://api.weixin.qq.com/sns/oauth2/access_token?appid={0}&secret={1}&code={2}&grant_type=authorization_code", appid, secret, code);
                string CReturnJson = HotelHotel.Utility.HttpWebResponseUtility.Get(checkTokenUrl);
                WxPayAPI.Log.Debug("获取openid".ToString(), CReturnJson);
                wxcheckTokenUrl m = Newtonsoft.Json.JsonConvert.DeserializeObject<wxcheckTokenUrl>(CReturnJson);
                WxPayAPI.Log.Debug("获取openid".ToString(), m.openid);
                return m.openid;
            }
            catch (Exception ex) {
                WxPayAPI.Log.Debug("获取openid报错:".ToString(), ex.Message.ToString());
                return "";
            }
        }
        public void postweixin(string code, string state)
        {
            if (!string.IsNullOrEmpty(code) && !string.IsNullOrEmpty(state))
            { 
                string openid = "", weixinstr = "";
                bool boocuy = true;

                /** ================会员卡销售支付========= */
                if (state.Contains("K")) {
                    var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from WeiXin..MemberCardBuyRecord where OrderNo=@OrderId", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { {"OrderId",new HotelCloud.SqlServer.DBParam{ParamValue=state}}});
                    if (dt.Rows.Count > 0)
                    {
                        foreach (System.Data.DataRow dr in dt.Rows)
                        {
                            openid = getopenid(dr["weixinId"].ToString().Trim(), code);
                            var weixinstrtable = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 weixintype,edition from  WeiXin..WeiXinNO where WeiXinID=@WeiXinID", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "WeiXinID", new HotelCloud.SqlServer.DBParam { ParamValue = dr["weixinId"].ToString().Trim() } } });
                            if (weixinstrtable != null)
                            {
                                if (weixinstrtable.Rows.Count > 0)
                                {
                                    foreach (System.Data.DataRow rd in weixinstrtable.Rows)
                                    {
                                        /** ================判断公众号认证情况========= */
                                        weixinstr = rd["weixintype"].ToString();
                                        edition = rd["edition"].ToString();
                                    }
                                }
                            }
                            if ((string.IsNullOrEmpty(weixinstr) || (weixinstr != "2" && weixinstr != "4")) && dr["weixinId"].ToString().Trim() == "gh_def2f166ed9e")
                                /** ================未认证情况 进行调整到二维码扫描支付========= */
                                Response.Redirect("http://hotel.weikeniu.com/WeiXinZhiFu/qrcode.aspx?OrderNo=" + dr["OrderNo"].ToString().Trim(), false);
                            else
                            {
                                int total_fee = Convert.ToInt32(Convert.ToDecimal(dr["BuyMoney"].ToString()) * 100);

                                /** ================Ashbur微信号对应支付金额 0.01元========= */
                                if (openid == "oPfrcjmqyO33T8a8Dn21Kq-QMAcg") { total_fee = 1; }
                                if (openid == "oUM4bwdTr3DXhUkGf43lGiipmxMA") { total_fee = 1; }
                                if (openid == "oZLQzv-cg1KvGmrTnq0xdxhK-4kc") { total_fee = 1; }

                                if (string.IsNullOrEmpty(openid))
                                    WxPayAPI.Log.Error(this.GetType().ToString(), "wxOAuthRedirect|This page have not get params, cannot be inited, exit...");
                                else
                                {
                                    HotelID = dr["HotelId"].ToString().Trim();
                                    UserWeiXinID = dr["userWeixinId"].ToString().Trim();
                                    WeiXinID = dr["weixinId"].ToString().Trim();

                                    WxPayAPI.WxPayData data = new WxPayAPI.WxPayData();
                                    data.SetValue("body", "会员卡购买");
                                    data.SetValue("attach", "presale"); 
                                    data.SetValue("out_trade_no", dr["OrderNo"].ToString().Trim());
                                    data.SetValue("total_fee", total_fee);
                                    data.SetValue("time_start", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                    data.SetValue("time_expire", DateTime.Now.AddMinutes(30).ToString("yyyyMMddHHmmss"));
                                    data.SetValue("goods_tag", "会员卡消费");
                                    data.SetValue("trade_type", "JSAPI");
                                    data.SetValue("openid", openid);
                                    WxPayAPI.JsApiPay jsApiPay = new WxPayAPI.JsApiPay();
                                    jsApiPay.openid = openid;
                                    jsApiPay.total_fee = total_fee;
                                    WxPayAPI.WxPayData unifiedOrderResult = jsApiPay.GetUnifiedOrderResult(data);
                                    wxJsApiParam = jsApiPay.GetJsApiParameters();
                                    WxPayAPI.Log.Debug(this.GetType().ToString(), "wxJsApiParam : " + wxJsApiParam);
                                }
                            }
                        }
                    }
                    else { WxPayAPI.Log.Debug(this.GetType().ToString(), "无效订单或者非预订订单"); }
                    boocuy = false;
                    return;
                }
          
                /** ================酒店周边购物消费========= */
                if (state.Contains("D"))
                {
                    var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from WeiXin..SupermarketOrder_Levi where OrderId=@OrderId", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"OrderId",new HotelCloud.SqlServer.DBParam{ParamValue=state}}
                        });
                    if (dt.Rows.Count > 0)
                    {
                        foreach (System.Data.DataRow dr in dt.Rows)
                        {
                            openid = getopenid(dr["weixinID"].ToString().Trim(), code);                            
                            var weixinstrtable = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 weixintype,edition from  WeiXin..WeiXinNO where WeiXinID=@WeiXinID", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "WeiXinID", new HotelCloud.SqlServer.DBParam { ParamValue = dr["weixinID"].ToString().Trim() } } });
                            if (weixinstrtable != null)
                            {
                                if (weixinstrtable.Rows.Count > 0)
                                {
                                    foreach (System.Data.DataRow rd in weixinstrtable.Rows)
                                    {
                                        /** ================判断公众号认证情况========= */
                                        weixinstr = rd["weixintype"].ToString();
                                        edition = rd["edition"].ToString();
                                    }
                                }
                            }                                                                                   
                            if ((string.IsNullOrEmpty(weixinstr) || (weixinstr != "2" && weixinstr != "4")) && dr["weixinID"].ToString().Trim() == "gh_def2f166ed9e")
                                Response.Redirect("http://hotel.weikeniu.com/WeiXinZhiFu/qrcode.aspx?OrderNo=" + dr["OrderId"].ToString().Trim(), false);
                            else
                            {
                                int total_fee = Convert.ToInt32(Convert.ToDecimal(dr["Money"].ToString()) * 100);

                                /** ================Ashbur微信号对应支付金额 0.01元========= */
                                if (openid == "oPfrcjmqyO33T8a8Dn21Kq-QMAcg") { total_fee = 1; }
                                if (openid == "oUM4bwdTr3DXhUkGf43lGiipmxMA") { total_fee = 1; }
                                if (openid == "oZLQzv-cg1KvGmrTnq0xdxhK-4kc") { total_fee = 1; }

                                if (string.IsNullOrEmpty(openid))
                                    WxPayAPI.Log.Error(this.GetType().ToString(), "wxOAuthRedirect|This page have not get params, cannot be inited, exit...");
                                else
                                {
                                    HotelID = dr["HotelId"].ToString().Trim();
                                    UserWeiXinID = dr["userweixinID"].ToString().Trim();
                                    WeiXinID = dr["weixinID"].ToString().Trim();            

                                    WxPayAPI.WxPayData data = new WxPayAPI.WxPayData();
                                    data.SetValue("body", "酒店周边购物消费");
                                    data.SetValue("attach", "presale"); 
                                    data.SetValue("out_trade_no", dr["OrderId"].ToString().Trim());
                                    data.SetValue("total_fee", total_fee);
                                    data.SetValue("time_start", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                    data.SetValue("time_expire", DateTime.Now.AddMinutes(30).ToString("yyyyMMddHHmmss"));
                                    data.SetValue("goods_tag", "酒店周边购物消费");
                                    data.SetValue("trade_type", "JSAPI");
                                    data.SetValue("openid", openid);
                                    WxPayAPI.JsApiPay jsApiPay = new WxPayAPI.JsApiPay();
                                    jsApiPay.openid = openid;
                                    jsApiPay.total_fee = total_fee;
                                    WxPayAPI.WxPayData unifiedOrderResult = jsApiPay.GetUnifiedOrderResult(data);
                                    wxJsApiParam = jsApiPay.GetJsApiParameters();
                                    WxPayAPI.Log.Debug(this.GetType().ToString(), "wxJsApiParam : " + wxJsApiParam);
                                }
                            }
                        }
                    }
                    else { WxPayAPI.Log.Debug(this.GetType().ToString(), "无效订单或者非预订订单"); }
                    boocuy = false;
                    return;
                }

                /** ================充值卡消费========= */
                if (state.Contains("C"))
                {
                    var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from WeiXin..RechargeUser where OrderNo=@OrderNo", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=state}}
                        });
                    if (dt.Rows.Count > 0)
                    {
                        foreach (System.Data.DataRow dr in dt.Rows)
                        {
                            openid = getopenid(dr["HotelWeiXinId"].ToString().Trim(), code);                            
                            var weixinstrtable = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 weixintype,edition from  WeiXin..WeiXinNO where WeiXinID=@WeiXinID", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "WeiXinID", new HotelCloud.SqlServer.DBParam { ParamValue = dr["HotelWeiXinId"].ToString().Trim() } } });
                            if (weixinstrtable != null)
                            {
                                if (weixinstrtable.Rows.Count > 0)
                                {
                                    foreach (System.Data.DataRow rd in weixinstrtable.Rows)
                                    {
                                        /** ================判断公众号认证情况========= */
                                        weixinstr = rd["weixintype"].ToString();
                                        edition = rd["edition"].ToString();
                                    }
                                }
                            } 
                            if ((string.IsNullOrEmpty(weixinstr) || (weixinstr != "2" && weixinstr != "4")) && dr["HotelWeiXinId"].ToString().Trim() == "gh_def2f166ed9e")
                                Response.Redirect("http://hotel.weikeniu.com/WeiXinZhiFu/qrcode.aspx?OrderNo=" + dr["OrderNo"].ToString().Trim(), false);
                            else
                            {
                                int total_fee = Convert.ToInt32(Convert.ToDecimal(dr["SPrice"].ToString()) * 100);

                                /** ================Ashbur微信号对应支付金额 0.01元========= */
                                if (openid == "oPfrcjmqyO33T8a8Dn21Kq-QMAcg") { total_fee = 1; }
                                if (openid == "oUM4bwdTr3DXhUkGf43lGiipmxMA") { total_fee = 1; }
                                if (openid == "oZLQzv-cg1KvGmrTnq0xdxhK-4kc") { total_fee = 1; }

                                if (string.IsNullOrEmpty(openid))
                                    WxPayAPI.Log.Error(this.GetType().ToString(), "wxOAuthRedirect|This page have not get params, cannot be inited, exit...");
                                else
                                {
                                    HotelID = dr["HotelId"].ToString().Trim();
                                    UserWeiXinID = dr["UserWeiXinId"].ToString().Trim();
                                    WeiXinID = dr["HotelWeiXinId"].ToString().Trim();

                                    WxPayAPI.WxPayData data = new WxPayAPI.WxPayData();
                                    data.SetValue("body", "充值卡消费");
                                    data.SetValue("attach", "presale"); 
                                    data.SetValue("out_trade_no", dr["OrderNo"].ToString().Trim());
                                    data.SetValue("total_fee", total_fee);
                                    data.SetValue("time_start", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                    data.SetValue("time_expire", DateTime.Now.AddMinutes(30).ToString("yyyyMMddHHmmss"));
                                    data.SetValue("goods_tag", "充值卡消费");
                                    data.SetValue("trade_type", "JSAPI");
                                    data.SetValue("openid", openid);
                                    WxPayAPI.JsApiPay jsApiPay = new WxPayAPI.JsApiPay();
                                    jsApiPay.openid = openid;
                                    jsApiPay.total_fee = total_fee;
                                    WxPayAPI.WxPayData unifiedOrderResult = jsApiPay.GetUnifiedOrderResult(data);
                                    wxJsApiParam = jsApiPay.GetJsApiParameters();
                                    WxPayAPI.Log.Debug(this.GetType().ToString(), "wxJsApiParam : " + wxJsApiParam);
                                }
                            }
                        }
                    }
                    else { WxPayAPI.Log.Debug(this.GetType().ToString(), "无效订单或者非预订订单"); }
                    boocuy = false;
                    return;
                }


                /** ================度假产品消费========= */
                if (state.Contains("P"))
                {
                    var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from WeiXin..SaleProducts_Orders where OrderNo=@OrderNo", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=state}}
                        });
                    if (dt.Rows.Count > 0)
                    {
                        foreach (System.Data.DataRow dr in dt.Rows)
                        {
                            openid = getopenid(dr["HotelWeiXinId"].ToString().Trim(), code);
                            var weixinstrtable = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 weixintype,edition from  WeiXin..WeiXinNO where WeiXinID=@WeiXinID", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "WeiXinID", new HotelCloud.SqlServer.DBParam { ParamValue = dr["HotelWeiXinId"].ToString().Trim() } } });
                            if (weixinstrtable != null)
                            {
                                if (weixinstrtable.Rows.Count > 0)
                                {
                                    foreach (System.Data.DataRow rd in weixinstrtable.Rows)
                                    {
                                        /** ================判断公众号认证情况========= */
                                        weixinstr = rd["weixintype"].ToString();
                                        edition = rd["edition"].ToString();
                                    }
                                }
                            }                                
                            if ((string.IsNullOrEmpty(weixinstr) || (weixinstr != "2" && weixinstr != "4")) && dr["HotelWeiXinId"].ToString().Trim() == "gh_def2f166ed9e")
                                /** ================未认证情况 进行调整到二维码扫描支付  目前这个方式也不OK========= */
                                Response.Redirect("http://hotel.weikeniu.com/WeiXinZhiFu/qrcode.aspx?OrderNo=" + dr["OrderNo"].ToString().Trim(), false);
                            else
                            {
                                int total_fee = Convert.ToInt32(Convert.ToDecimal(dr["OrderMoney"].ToString()) * 100);                                

                                /** ================Ashbur微信号对应支付金额 0.01元========= */
                                if (openid == "oPfrcjmqyO33T8a8Dn21Kq-QMAcg") { total_fee = 1; }
                                if (openid == "oUM4bwdTr3DXhUkGf43lGiipmxMA") { total_fee = 1; }
                                if (openid == "oZLQzv-cg1KvGmrTnq0xdxhK-4kc") { total_fee = 1; }

                                if (string.IsNullOrEmpty(openid))
                                    WxPayAPI.Log.Error(this.GetType().ToString(), "wxOAuthRedirect|This page have not get params, cannot be inited, exit...");
                                else
                                {
                                    HotelID = dr["HotelId"].ToString().Trim();
                                    UserWeiXinID = dr["UserWeiXinId"].ToString().Trim();
                                    WeiXinID = dr["HotelWeiXinId"].ToString().Trim();

                                    WxPayAPI.WxPayData data = new WxPayAPI.WxPayData();
                                    data.SetValue("body", dr["ProductName"].ToString().Trim());
                                    data.SetValue("attach", "presale"); 
                                    data.SetValue("out_trade_no", dr["OrderNo"].ToString().Trim());
                                    data.SetValue("total_fee", total_fee);
                                    data.SetValue("time_start", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                    data.SetValue("time_expire", DateTime.Now.AddMinutes(30).ToString("yyyyMMddHHmmss"));
                                    data.SetValue("goods_tag", dr["ProductName"].ToString().Trim() + "[" + dr["TcName"].ToString().Trim() + "]");
                                    data.SetValue("trade_type", "JSAPI");
                                    data.SetValue("openid", openid);
                                    WxPayAPI.JsApiPay jsApiPay = new WxPayAPI.JsApiPay();
                                    jsApiPay.openid = openid;
                                    jsApiPay.total_fee = total_fee;
                                    WxPayAPI.WxPayData unifiedOrderResult = jsApiPay.GetUnifiedOrderResult(data);
                                    wxJsApiParam = jsApiPay.GetJsApiParameters();
                                    WxPayAPI.Log.Debug(this.GetType().ToString(), "wxJsApiParam : " + wxJsApiParam);
                                }
                            }
                        }
                    }
                    else { WxPayAPI.Log.Debug(this.GetType().ToString(), "无效订单或者非预订订单"); }
                    boocuy = false;
                    return;
                }

                /** ================ 酒店周边餐饮消费========= */
                if (state.Contains("L"))
                {
                    var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 bagging,amount,youhuiamount,ISNULL(CouponMoney,0) as CouponMoney,hotelid,userweixinid,hotelWeixinId,orderCode,(select sum(AliPayAmount) from  WeiXin..wkn_payrecords where OrderNO=orderCode and Channel='微信支付回调') as zhifu,storeID  from WeiXin..T_OrderInfo where orderCode=@orderCode", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"orderCode",new HotelCloud.SqlServer.DBParam{ParamValue=state}}
                        });
                    if (dt.Rows.Count > 0)
                    {
                        foreach (System.Data.DataRow dr in dt.Rows)
                        {
                            openid = getopenid(dr["hotelWeixinId"].ToString().Trim(), code);
                            var weixinstrtable = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 weixintype,edition from  WeiXin..WeiXinNO where WeiXinID=@WeiXinID", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "WeiXinID", new HotelCloud.SqlServer.DBParam { ParamValue = dr["hotelWeixinId"].ToString().Trim() } } });
                            if (weixinstrtable != null)
                            {
                                if (weixinstrtable.Rows.Count > 0)
                                {
                                    foreach (System.Data.DataRow rd in weixinstrtable.Rows)
                                    {
                                        /** ================判断公众号认证情况========= */
                                        weixinstr = rd["weixintype"].ToString();
                                        edition = rd["edition"].ToString();
                                    }
                                }
                            }                                                           
                            if ((string.IsNullOrEmpty(weixinstr) || (weixinstr != "2" && weixinstr != "4")) && dr["hotelWeixinId"].ToString() == "gh_def2f166ed9e")
                                /** ================未认证情况 进行调整到二维码扫描支付========= */
                                Response.Redirect("http://hotel.weikeniu.com/WeiXinZhiFu/qrcode.aspx?OrderNo=" + dr["orderCode"].ToString().Trim(), false);
                            else
                            {
                                string bagging = dr["bagging"].ToString();
                                string youhuiamount = dr["youhuiamount"].ToString();
                                if (string.IsNullOrEmpty(bagging)) { bagging = "0"; }
                                if (string.IsNullOrEmpty(youhuiamount)) { youhuiamount = "0"; }
                                Zhifu = dr["zhifu"].ToString(); ;
                                if (string.IsNullOrEmpty(Zhifu)) { Zhifu = "0"; }
                                int total_fee = Convert.ToInt32((Convert.ToDecimal(dr["amount"].ToString()) - Convert.ToDecimal(youhuiamount) + Convert.ToDecimal(bagging) - Convert.ToDecimal(dr["CouponMoney"].ToString())) * 100);
                                
                                /** ================Ashbur微信号对应支付金额 0.01元========= */
                                if (openid == "oPfrcjmqyO33T8a8Dn21Kq-QMAcg") { total_fee = 1; }
                                if (openid == "oUM4bwdTr3DXhUkGf43lGiipmxMA") { total_fee = 1; }
                                if (openid == "oZLQzv-cg1KvGmrTnq0xdxhK-4kc") { total_fee = 1; }

                                if (string.IsNullOrEmpty(openid))
                                    WxPayAPI.Log.Error(this.GetType().ToString(), "wxOAuthRedirect|This page have not get params, cannot be inited, exit...");
                                else
                                {
                                    HotelID = dr["hotelid"].ToString().Trim();
                                    UserWeiXinID = dr["userweixinid"].ToString().Trim();
                                    WeiXinID = dr["hotelWeixinId"].ToString().Trim();
                                    storeId = dr["storeId"].ToString().Trim();

                                    WxPayAPI.WxPayData data = new WxPayAPI.WxPayData();
                                    data.SetValue("body", "酒店周边餐饮消费");
                                    data.SetValue("attach", "consumption"); 
                                    data.SetValue("out_trade_no", dr["orderCode"].ToString().Trim());
                                    data.SetValue("total_fee", total_fee);
                                    data.SetValue("time_start", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                    data.SetValue("time_expire", DateTime.Now.AddMinutes(30).ToString("yyyyMMddHHmmss"));
                                    data.SetValue("goods_tag", "酒店周边餐饮消费");
                                    data.SetValue("trade_type", "JSAPI");
                                    data.SetValue("openid", openid);
                                    WxPayAPI.JsApiPay jsApiPay = new WxPayAPI.JsApiPay();
                                    jsApiPay.openid = openid;
                                    jsApiPay.total_fee = total_fee;
                                    WxPayAPI.WxPayData unifiedOrderResult = jsApiPay.GetUnifiedOrderResult(data);
                                    wxJsApiParam = jsApiPay.GetJsApiParameters();
                                    WxPayAPI.Log.Debug(this.GetType().ToString(), "wxJsApiParam : " + wxJsApiParam);
                                }
                            }
                        }
                    }
                    else { WxPayAPI.Log.Debug(this.GetType().ToString(), "无效订单或者非预订订单"); }
                    boocuy = false;
                    return;
                }
                /** ================ 酒店客房销售========= */
                if (boocuy)
                {
                    hotel3g.Repository.Order order = hotel3g.Repository.OrderRepository.GetOrderInfo(state);
                    var weixinstrtable = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 weixintype,edition from  WeiXin..WeiXinNO where WeiXinID=@WeiXinID", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "WeiXinID", new HotelCloud.SqlServer.DBParam { ParamValue = order.WeiXinID.Trim() } } });
                    if (weixinstrtable != null) {
                        if (weixinstrtable.Rows.Count > 0) {
                            foreach (System.Data.DataRow rd in weixinstrtable.Rows)
                            {
                                /** ================判断公众号认证情况========= */
                                weixinstr = rd["weixintype"].ToString();
                                edition = rd["edition"].ToString();
                            }
                        }
                    }
                    if ((string.IsNullOrEmpty(weixinstr) || (weixinstr != "2" && weixinstr != "4")) && order.WeiXinID.Trim() == "gh_def2f166ed9e")
                        /** ================未认证情况 进行调整到二维码扫描支付========= */
                        Response.Redirect("http://hotel.weikeniu.com/WeiXinZhiFu/qrcode.aspx?OrderNo=" + order.OrderNo.ToString(), false);
                    else
                    {
                        if (order == null || order.PayType != "0")
                            WxPayAPI.Log.Debug(this.GetType().ToString(), "无效订单或者非预订订单");
                        else
                        {
                            openid = getopenid(order.WeiXinID.Trim(), code);
                            int total_fee = order.OrderAmount * 100;

                            /** ================Ashbur微信号对应支付金额 0.01元========= */
                            if (openid == "oPfrcjmqyO33T8a8Dn21Kq-QMAcg") { total_fee = 1; }
                            if (openid == "oUM4bwdTr3DXhUkGf43lGiipmxMA") { total_fee = 1; }
                            if (openid == "oZLQzv-cg1KvGmrTnq0xdxhK-4kc") { total_fee = 1; }

                            if (string.IsNullOrEmpty(openid))
                                WxPayAPI.Log.Error(this.GetType().ToString(), "wxOAuthRedirect|This page have not get params, cannot be inited, exit...");
                            else
                            {

                                HotelID = order.HotelID.ToString().Trim();
                                UserWeiXinID = order.UserWeiXinID.Trim();
                                WeiXinID = order.WeiXinID.Trim();
                                if (edition == "1") { orderid = order.Id.ToString(); }
                                orderid = order.Id.ToString();

                                WxPayAPI.WxPayData data = new WxPayAPI.WxPayData();
                                data.SetValue("body", order.HotelName.Trim());
                                data.SetValue("attach", "weikeniuwx");
                                data.SetValue("out_trade_no", order.OrderNo);
                                data.SetValue("total_fee", total_fee);
                                data.SetValue("time_start", DateTime.Now.ToString("yyyyMMddHHmmss"));
                                data.SetValue("time_expire", DateTime.Now.AddMinutes(30).ToString("yyyyMMddHHmmss"));
                                data.SetValue("goods_tag", order.RoomName + "[" + order.RatePlanName + "]");
                                data.SetValue("trade_type", "JSAPI");
                                data.SetValue("openid", openid);
                                WxPayAPI.JsApiPay jsApiPay = new WxPayAPI.JsApiPay();
                                jsApiPay.openid = openid;
                                jsApiPay.total_fee = total_fee;
                                WxPayAPI.WxPayData unifiedOrderResult = jsApiPay.GetUnifiedOrderResult(data);
                                wxJsApiParam = jsApiPay.GetJsApiParameters();
                                WxPayAPI.Log.Debug(this.GetType().ToString(), "wxJsApiParam : " + wxJsApiParam);
                            }
                        }
                    }
                }
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                orderid = "";edition = "";error="0";
                try {
                    WxPayAPI.Log.Debug(this.GetType().ToString(), Request.QueryString["code"].Trim() + "|" + Request.QueryString["state"].Trim().ToUpper());
                    orderid = Request.QueryString["state"].Trim().ToUpper();
                    postweixin(Request.QueryString["code"].Trim(), orderid); }
                catch (Exception ex) {
                    error = "1";
                    WxPayAPI.Log.Debug(this.GetType().ToString(), "微信支付失败，请返回重试:" + ex.Message.ToString());
                }
            }
        }
    }
}