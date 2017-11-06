using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hotel3g.WeiXinZhiFu
{
    public partial class wknopenid : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    bool isgoto = true;
                    if (!string.IsNullOrEmpty(HotelCloud.Common.HCRequest.GetString("state").Trim()))
                    {
                        isgoto = false;
                        if (HotelCloud.Common.HCRequest.GetString("state").Trim() == "1")
                        {
                            var checkTokenUrl = string.Format("https://api.weixin.qq.com/sns/oauth2/access_token?appid={0}&secret={1}&code={2}&grant_type=authorization_code", "wx4231803400779997", "e25c46cede5b31ef22cc166ffc3eed36", HotelCloud.Common.HCRequest.GetString("code"));
                            string CReturnJson = HotelHotel.Utility.HttpWebResponseUtility.Get(checkTokenUrl);
                            wxcheckTokenUrl m = Newtonsoft.Json.JsonConvert.DeserializeObject<wxcheckTokenUrl>(CReturnJson);
                            if (m != null)
                            {
                                hotel3g.Models.Cookies.SetCookies("refresh_token", m.refresh_token, 28, "wx");
                                Response.Redirect("http://wap.weikeniu.com/switch.aspx?openid=" + m.openid.Trim(), false);
                            }
                        }
                        if (HotelCloud.Common.HCRequest.GetString("state").Trim().Contains("C"))
                        {
                            string aid = HotelCloud.Common.HCRequest.GetString("state").Trim().Replace("C", "");
                            string appid = "", storeId = "", weixinid = "", hid = "", appkey = "", weixinstr = "", edition="";
                            var weixinstrtable = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 wkn_Codelist.*,weixintype,appid,appkey,edition from WeiXin..wkn_Codelist with(nolock) inner join WeiXin..WeiXinNO on wkn_Codelist.weixinid=WeiXinNO.WeiXinID  where wkn_Codelist.aid=@aid", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "aid", new HotelCloud.SqlServer.DBParam { ParamValue = aid.ToString() } } });
                            if (weixinstrtable != null)
                            {
                                if (weixinstrtable.Rows.Count > 0)
                                {
                                    foreach (System.Data.DataRow rd in weixinstrtable.Rows)
                                    {
                                        appid = rd["appid"].ToString();
                                        storeId = rd["storeId"].ToString();
                                        appkey = rd["appkey"].ToString();
                                        weixinid = rd["weixinid"].ToString();
                                        hid = rd["hotelid"].ToString();
                                        weixinstr = rd["weixintype"].ToString();
                                        edition = rd["edition"].ToString();
                                    }
                                }
                            }
                            if (weixinstr != "2" && weixinstr != "4") {
                                appkey = "e25c46cede5b31ef22cc166ffc3eed36";
                                appid = "wx4231803400779997"; }
                            var checkTokenUrl = string.Format("https://api.weixin.qq.com/sns/oauth2/access_token?appid={0}&secret={1}&code={2}&grant_type=authorization_code", appid, appkey, HotelCloud.Common.HCRequest.GetString("code"));
                            string CReturnJson = HotelHotel.Utility.HttpWebResponseUtility.Get(checkTokenUrl);
                            wxcheckTokenUrl m = Newtonsoft.Json.JsonConvert.DeserializeObject<wxcheckTokenUrl>(CReturnJson);
                            if (m != null)
                            {
                                hotel3g.Models.Cookies.SetCookies("user_refresh_token", m.refresh_token, 1, appid);
                                if (edition.Contains("1"))
                                    Response.Redirect(string.Format("http://hotel.weikeniu.com/DishOrderA/DishOrderIndex/{4}?key={0}@{2}&storeId={1}&tid={3}", weixinid, storeId, m.openid.Trim(), aid, hid), false);
                                else
                                    Response.Redirect(string.Format("http://hotel.weikeniu.com/DishOrder/DishOrderIndex/{4}?key={0}@{2}&storeId={1}&tid={3}", weixinid, storeId, m.openid.Trim(), aid, hid), false);
                            }
                        }
                    }
                    if (!string.IsNullOrEmpty(HotelCloud.Common.HCRequest.GetString("code").Trim()))
                    {
                        isgoto = false;
                        int code = Convert.ToInt32(HotelCloud.Common.HCRequest.GetString("code").Trim());
                        string appid = "", weixinstr = "", storeId = "", weixinid = "", hid = "", edition="";
                        var weixinstrtable = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 wkn_Codelist.*,weixintype,appid,edition from WeiXin..wkn_Codelist with(nolock) inner join WeiXin..WeiXinNO on wkn_Codelist.weixinid=WeiXinNO.WeiXinID  where wkn_Codelist.aid=@aid", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "aid", new HotelCloud.SqlServer.DBParam { ParamValue = code.ToString() } } });
                        if (weixinstrtable != null)
                        {
                            if (weixinstrtable.Rows.Count > 0)
                            {
                                foreach (System.Data.DataRow rd in weixinstrtable.Rows)
                                {
                                    weixinstr = rd["weixintype"].ToString();
                                    appid = rd["appid"].ToString();
                                    storeId = rd["storeId"].ToString();
                                    weixinid = rd["weixinid"].ToString();
                                    hid = rd["hotelid"].ToString();
                                    edition = rd["edition"].ToString();
                                }
                            }
                        }
                        if (weixinstr != "2" && weixinstr != "4") {appid = "wx4231803400779997";}
                        if (!string.IsNullOrEmpty(hotel3g.Models.Cookies.GetCookies("user_refresh_token", appid)))
                        {
                            var checkTokenUrl = string.Format("https://api.weixin.qq.com/sns/oauth2/refresh_token?appid={0}&grant_type=refresh_token&refresh_token={1}", appid, hotel3g.Models.Cookies.GetCookies("user_refresh_token", "wx"));
                            string CReturnJson = HotelHotel.Utility.HttpWebResponseUtility.Get(checkTokenUrl);
                            WxPayAPI.Log.Debug("refresh_token获取openid".ToString(), CReturnJson);
                            wxcheckTokenUrl m = Newtonsoft.Json.JsonConvert.DeserializeObject<wxcheckTokenUrl>(CReturnJson);
                            if (m != null) {
                                if (edition.Contains("1"))
                                    Response.Redirect(string.Format("http://hotel.weikeniu.com/DishOrderA/DishOrderIndex/{4}?key={0}@{2}&storeId={1}&tid={3}", weixinid, storeId, m.openid.Trim(), code.ToString(), hid), false);
                                else 
                                    Response.Redirect(string.Format("http://hotel.weikeniu.com/DishOrder/DishOrderIndex/{4}?key={0}@{2}&storeId={1}&tid={3}", weixinid, storeId, m.openid.Trim(), code.ToString(), hid), false);
                            }                                
                        }
                        else
                        {
                            string weixinUrl = string.Format("https://open.weixin.qq.com/connect/oauth2/authorize?appid={1}&redirect_uri=http%3a%2f%2fhotel.weikeniu.com%2fWeiXinZhiFu%2fwknopenid.aspx&response_type=code&scope=snsapi_base&state={0}#wechat_redirect", "C" + code.ToString(), appid);                            
                            Response.Redirect(weixinUrl, false);
                        }
                    }
                    if (isgoto)
                    {
                        if (Request.UserAgent.ToLower().Contains("micromessenger"))
                        {
                            if (!string.IsNullOrEmpty(hotel3g.Models.Cookies.GetCookies("refresh_token", "wx")))
                            {

                                var checkTokenUrl = string.Format("https://api.weixin.qq.com/sns/oauth2/refresh_token?appid={0}&grant_type=refresh_token&refresh_token={1}", "wx4231803400779997", hotel3g.Models.Cookies.GetCookies("refresh_token", "wx"));
                                string CReturnJson = HotelHotel.Utility.HttpWebResponseUtility.Get(checkTokenUrl);
                                WxPayAPI.Log.Debug("refresh_token获取openid".ToString(), CReturnJson);
                                wxcheckTokenUrl m = Newtonsoft.Json.JsonConvert.DeserializeObject<wxcheckTokenUrl>(CReturnJson);
                                if (m != null) 
                                    Response.Redirect("http://wap.weikeniu.com/switch.aspx?openid=" + m.openid.Trim(), false);
                            }
                            else
                            {
                                string weixinUrl = string.Format("https://open.weixin.qq.com/connect/oauth2/authorize?appid={1}&redirect_uri=http%3a%2f%2fhotel.weikeniu.com%2fWeiXinZhiFu%2fwknopenid.aspx&response_type=code&scope=snsapi_base&state={0}#wechat_redirect", "1", "wx4231803400779997");
                                Response.Redirect(weixinUrl, false);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    WxPayAPI.Log.Debug("获取openid".ToString(),ex.Message.ToString());
                }
            }
        }
    }
}