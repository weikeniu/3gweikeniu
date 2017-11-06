using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using LitJson;
using Newtonsoft.Json.Linq;
using System.Net;

namespace hotel3g.WeiXinZhiFu
{
    public class tAccessToken
    {
        public string message { get; set; }
        public int error { get; set; }

    }
    public partial class Fastcollection : System.Web.UI.Page
    {
        protected string subname = "微可牛演示商家收款", WeiXinID = "", hid = "", Nickname = "", type = "0", state = "", code = "", openid="";

        /** ================ 微可牛平台助手对应的额appid  secret mchid========= */
        protected string appid = "wx9f84537c7ce94a29", secret = "0298097591924bdbd67ed5ee28f0c75d", mchid = "1464378202"; 

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {                
                if (!string.IsNullOrEmpty(HotelCloud.Common.HCRequest.GetString("state").Trim()))
                {
                    state = HotelCloud.Common.HCRequest.GetString("state").Trim();
                    code = HotelCloud.Common.HCRequest.GetString("code").Trim();
                    type = state.Split('|')[1].ToString();//对应类型
                    hid = Regex.Replace(state.Split('|')[0].ToUpper(), @"[^\d]*", "");  //对应酒店id
                    var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 hotel.WeiXinID,SubName,hotelLog,hotel.address,hotel.id,appkey,appid,MCHID,iszhifu  from WeiXin..hotel with(nolock)  inner join WeiXin..WeiXinNO with(nolock)  on WeiXinNO.WeiXinID=hotel.WeiXinID  where hotel.id=@id and hotel.enabled=1", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "id", new HotelCloud.SqlServer.DBParam { ParamValue = hid.Trim() } } });
                    if (dt.Rows.Count > 0)
                    {
                        foreach (System.Data.DataRow dr in dt.Rows)
                        {
                            subname = dr["SubName"].ToString().Trim();
                            WeiXinID = dr["WeiXinID"].ToString().Trim();
                        }
                    }
                }
                /** ================客人实时付款微信下单操作========= */
                if (HotelCloud.Common.HCRequest.GetString("state") != "" && !string.IsNullOrEmpty(HotelCloud.Common.HCRequest.GetString("price")))
                {  
                    System.Web.Script.Serialization.JavaScriptSerializer js = new System.Web.Script.Serialization.JavaScriptSerializer();
                    string result = js.Serialize(new { status = false, msg = "非法操作" });
                    try
                    {                        
                        WeiXinID = HotelCloud.Common.HCRequest.GetString("weixinid");
                        hid = HotelCloud.Common.HCRequest.GetString("hid");
                        if (HotelCloud.Common.HCRequest.GetString("type").Trim().ToString() == "0") //表示客房消费操作
                        {
                            var dty = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 appkey,appid,MCHID from WeiXin..WeiXinNO with(nolock)  where WeiXinID=@WeiXinID and iszhifu=1", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "WeiXinID", new HotelCloud.SqlServer.DBParam { ParamValue = WeiXinID.Trim() } } });
                            if (dty.Rows.Count > 0)
                            {
                                foreach (System.Data.DataRow dry in dty.Rows)
                                {
                                    appid = dry["appid"].ToString().Trim();
                                    secret = dry["appkey"].ToString().Trim();
                                    mchid = dry["MCHID"].ToString().Trim();
                                }
                            }
                        }            
                        hotel3g.Models.Cookies.SetCookies("tb1", WxPayAPI.WxPayConfig.Encrypt(appid), 1, "wx"); 
                        hotel3g.Models.Cookies.SetCookies("tb2", WxPayAPI.WxPayConfig.Encrypt(secret), 1, "wx");   
                        hotel3g.Models.Cookies.SetCookies("tb3", WxPayAPI.WxPayConfig.Encrypt(mchid), 1, "wx");
                        openid = "";

                        /** ================二次付款的相关问题==== */
                        if (string.IsNullOrEmpty(openid) && Session["openid"] != null)
                            openid = Session["openid"].ToString();
                        
                        /** ================获取公众号对应的用户openid=====这里会存在多次获去openid的情况 但是实际上这个是不被允许的==== */
                        if (string.IsNullOrEmpty(openid))
                        {
                            var checkTokenUrl = string.Format("https://api.weixin.qq.com/sns/oauth2/access_token?appid={0}&secret={1}&code={2}&grant_type=authorization_code", appid, secret, HotelCloud.Common.HCRequest.GetString("code"));
                            string CReturnJson = HotelHotel.Utility.HttpWebResponseUtility.Get(checkTokenUrl);
                            WxPayAPI.Log.Debug("获取openid".ToString(), CReturnJson);
                            wxcheckTokenUrl m = Newtonsoft.Json.JsonConvert.DeserializeObject<wxcheckTokenUrl>(CReturnJson);
                            if (m != null)                            
                                openid = m.openid;
                            Session["openid"] = openid.Trim();                                              
                        }
                        if (!string.IsNullOrEmpty(openid))
                        {
                            try
                            {
                                System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls;
                                WebClient Client = new WebClient();
                                string json = Client.DownloadString(string.Format("http://www.weikeniu.com/WeixinFeatures/getGetTokenResult.ashx?appid={0}", appid)).Replace("\\", "").Replace("\"{", "{").Replace("}\"", "}");
                                tAccessToken token = Newtonsoft.Json.JsonConvert.DeserializeObject<tAccessToken>(json);
                                if (token.error == 1)
                                {
                                    string url = string.Format("https://api.weixin.qq.com/cgi-bin/user/info?access_token={0}&openid={1}&lang=zh_CN", token.message.ToString(), openid);
                                    string result1 = HotelHotel.Utility.HttpWebResponseUtility.Get(url);
                                    WxPayAPI.Log.Debug("获取用户基本信息", result1.ToString());
                                    Newtonsoft.Json.Linq.JObject outputObj1 = Newtonsoft.Json.Linq.JObject.Parse(result1);
                                    if (outputObj1 != null)
                                    {
                                        /** ================微信收银台 记录对应的客人信息 便于收银台展示对应的客人信息========= */
                                        Nickname = outputObj1["nickname"].ToString();
                                        var dw = HotelCloud.SqlServer.SQLHelper.Get_DataTable(string.Format("select  * from  WeiXin..wkn_unionmember with(nolock) where openid='{0}'", outputObj1["openid"].ToString().Trim('"')), HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), null);
                                        if (dw.Rows.Count < 1)
                                        {
                                            HotelCloud.SqlServer.SQLHelper.Run_SQL("insert into WeiXin..wkn_unionmember(openid,nickname,city,province,headimgurl,subscribe_time) values (@openid,@nickname,@city,@province,@headimgurl,@subscribe_time)", HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                                {"openid",new HotelCloud.SqlServer.DBParam{ParamValue=outputObj1["openid"].ToString().Trim('"')}},
                                                {"nickname",new HotelCloud.SqlServer.DBParam{ParamValue=outputObj1["nickname"].ToString().Trim('"')}},
                                                {"city",new HotelCloud.SqlServer.DBParam{ParamValue=outputObj1["city"].ToString().Trim('"')}},
                                                {"province",new HotelCloud.SqlServer.DBParam{ParamValue=outputObj1["province"].ToString().Trim('"')}},
                                                {"headimgurl",new HotelCloud.SqlServer.DBParam{ParamValue=outputObj1["headimgurl"].ToString().Trim('"')}},             
                                                {"subscribe_time",new HotelCloud.SqlServer.DBParam{ParamValue=outputObj1["subscribe_time"].ToString()}}                            
                                            });
                                        }
                                    }
                                }
                            }
                            catch (Exception ex)
                            {
                                WxPayAPI.Log.Debug("获取用户基本信息", ex.Message.ToString());
                            }
                            finally
                            {

                            }
                        }
                        string pay_type=HotelCloud.Common.HCRequest.GetString("type");
                        if (string.IsNullOrEmpty(pay_type)) { pay_type = "0"; }
                        int total_fee = Convert.ToInt32((Convert.ToDecimal(HotelCloud.Common.HCRequest.GetString("price")) * 100));

                        //主要是下单时需要openid>>静默获去到》》但是这样是需要code>>但是就是存在跳转的问题

                        string OrderNo = "wx" + DateTime.Now.ToString("yyMMddHHmmss") + new Random().Next(100, 0x3e7);
                        WxPayAPI.WxPayData data = new WxPayAPI.WxPayData();
                        data.SetValue("body", HotelCloud.Common.HCRequest.GetString("hname"));
                        data.SetValue("attach", hid + "|" + WeiXinID + "|" + pay_type);
                        data.SetValue("out_trade_no", OrderNo);
                        data.SetValue("total_fee", total_fee);
                        data.SetValue("time_start", DateTime.Now.ToString("yyyyMMddHHmmss"));
                        data.SetValue("time_expire", DateTime.Now.AddMinutes(10).ToString("yyyyMMddHHmmss"));
                        data.SetValue("goods_tag", "门店销售");
                        data.SetValue("trade_type", "JSAPI");
                        data.SetValue("openid", openid);
                        WxPayAPI.JsApiPay jsApiPay = new WxPayAPI.JsApiPay();
                        jsApiPay.openid = openid;
                        jsApiPay.total_fee = total_fee;
                        WxPayAPI.WxPayData unifiedOrderResult = jsApiPay.GetUnifiedOrderResult(data);
                        result = js.Serialize(new { status = true, msg = "统一下单成功", signature = jsApiPay.GetJsApiParameters(), TradeNo = OrderNo });

                        //需要保留对应的表数据wkn_quickpayment相关数据 
                        string sql = "insert into WeiXin..wkn_quickpayment (WeiXinID,OrderNo,ConsumptionType,ConsumptionContent,OtherRemarks,PaymentStatus,AliPayAmount) values(@WeiXinID,@OrderNo,@ConsumptionType,@ConsumptionContent,@OtherRemarks,'未支付',@AliPayAmount)";
                        int drt = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {  
                            {"ConsumptionType",new HotelCloud.SqlServer.DBParam{ParamValue=pay_type.ToString()}},
                            {"ConsumptionContent",new HotelCloud.SqlServer.DBParam{ParamValue= HotelCloud.Common.HCRequest.GetString("subContent")}},
                            {"OtherRemarks",new HotelCloud.SqlServer.DBParam{ParamValue=""}},
                            {"WeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=WeiXinID.ToString()}},
                            {"AliPayAmount",new HotelCloud.SqlServer.DBParam{ParamValue=total_fee.ToString()}},
                            {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=OrderNo.ToString()}}
                        });                        
                        WxPayAPI.Log.Debug("Fastcollection", result.ToString());
                    }
                    catch (Exception ex)
                    {
                        result = js.Serialize(new { status = false, msg ="支付失败" });
                        WxPayAPI.Log.Debug("Fastcollection", ex.Message.ToString());
                    }
                    finally
                    {                                                
                        Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(result));
                        Response.End();
                    }
                }
            }
        }
    }
}