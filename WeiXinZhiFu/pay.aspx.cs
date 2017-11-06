using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

namespace hotel3g.WeiXinZhiFu
{
    public partial class pay : System.Web.UI.Page
    {
        /** ================ 微可牛平台助手对应的额appid========= */
        protected string appid = "wx9f84537c7ce94a29";
        protected string id = "", hid = "", sql = "";
        protected string type = "0";
        protected Dictionary<string, string> hmanege = new Dictionary<string, string>();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) {                
                try
                {
                    if (HotelCloud.Common.HCRequest.GetString("type") == "yajin") { type = "1"; }
                    if (HotelCloud.Common.HCRequest.GetString("type") == "1") { type = "1"; }
                    if (!string.IsNullOrEmpty(HotelCloud.Common.HCRequest.GetString("id")))
                    {
                        /** ================ WeiXinNO 表  userID 非酒店ID 因为存在分店情况========= */
                        id = Regex.Replace(HotelCloud.Common.HCRequest.GetString("id"), @"[^\d]*", "");
                        sql = "select hotel.WeiXinID,SubName,hotelLog,hotel.address,hotel.id,appkey,appid,MCHID,iszhifu  from WeiXin..hotel with(nolock)  inner join WeiXin..WeiXinNO with(nolock)  on WeiXinNO.WeiXinID=hotel.WeiXinID  where WeiXinNO.userID=@id and hotel.enabled=1";
                    }
                    if (!string.IsNullOrEmpty(HotelCloud.Common.HCRequest.GetString("hid"))) {
                        /** ================ 酒店ID ========= */
                        id = Regex.Replace(HotelCloud.Common.HCRequest.GetString("hid"), @"[^\d]*", "");
                        sql = "select hotel.WeiXinID,SubName,hotelLog,hotel.address,hotel.id,appkey,appid,MCHID,iszhifu  from WeiXin..hotel with(nolock)  inner join WeiXin..WeiXinNO with(nolock)  on WeiXinNO.WeiXinID=hotel.WeiXinID  where hotel.id=@id and hotel.enabled=1";                        
                    }
                    var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "id", new HotelCloud.SqlServer.DBParam { ParamValue = id.Trim() } } });
                    if (dt.Rows.Count > 0)
                    {
                        foreach (System.Data.DataRow dr in dt.Rows)
                        {
                            if (!string.IsNullOrEmpty(HotelCloud.Common.HCRequest.GetString("hid")))
                            {
                                if (HotelCloud.Common.HCRequest.GetString("hid").Trim() == dr["id"].ToString().Trim())
                                    hmanege.Add(dr["id"].ToString().Trim(), dr["SubName"].ToString().Trim());
                            }else{
                                hmanege.Add(dr["id"].ToString().Trim(), dr["SubName"].ToString().Trim());
                            }
                            /** ================ 如果酒店微信号存在对应的商户数据 则需要使用对应酒店appid========= */
                            if (!string.IsNullOrEmpty(dr["MCHID"].ToString().Trim()) && type == "0"  && appid == "wx9f84537c7ce94a29") { appid = dr["appid"].ToString().Trim(); }
                        }
                    }
                    if (hmanege.Count == 1)
                    {
                        /** ================不存在公众号分店的情况 直接调整到相应的支付界面 appid+酒店id========= */
                        Session["openid"] = "";
                        string weixinUrl = string.Format("https://open.weixin.qq.com/connect/oauth2/authorize?appid={1}&redirect_uri=http%3a%2f%2fhotel.weikeniu.com%2fWeiXinZhiFu%2fFastcollection.aspx&response_type=code&scope=snsapi_base&state={0}#wechat_redirect", hmanege.FirstOrDefault().Key.ToString() + "|" + type, appid);
                        Response.Redirect(weixinUrl, false);
                    }
                }
                catch (Exception ex) {
                    WxPayAPI.Log.Debug("Pay", ex.Message.ToString());
                }
            }
        }
    }
}