using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Security.Cryptography;
using System.Text;
using System.Net;
using HotelCloud.SqlServer;
using System.Data;

namespace hotel3g.Models.DAL
{
    /// <summary>
    /// 微信jssdk调用配置信息
    /// </summary>
    public static class WeiXinJsSdkDAL
    {
        public static string GetRandomString(int length, bool useNum, bool useLow, bool useUpp, bool useSpe, string custom)
        {
            byte[] b = new byte[4];
            new System.Security.Cryptography.RNGCryptoServiceProvider().GetBytes(b);
            Random r = new Random(BitConverter.ToInt32(b, 0));
            string s = null, str = custom;
            if (useNum == true) { str += "0123456789"; }
            if (useLow == true) { str += "abcdefghijklmnopqrstuvwxyz"; }
            if (useUpp == true) { str += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
            if (useSpe == true) { str += "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"; }
            for (int i = 0; i < length; i++)
            {
                s += str.Substring(r.Next(0, str.Length - 1), 1);
            }
            return s;
        }
        private static string GetSHA1(string content, Encoding encode)
        {
            try
            {
                SHA1 sha1 = new SHA1CryptoServiceProvider();
                byte[] bytes_in = encode.GetBytes(content);
                byte[] bytes_out = sha1.ComputeHash(bytes_in);
                sha1.Dispose();
                string result = BitConverter.ToString(bytes_out);
                result = result.Replace("-", "");
                return result;
            }
            catch (Exception ex)
            {
                throw new Exception("SHA1加密出错：" + ex.Message);
            }
        }
        /// <summary>
        /// 获取jsapi调用凭证
        /// </summary>
        /// <returns></returns>
        private static JsAPIResponse jsapi_ticket(string accesstoken)
        {
            string url = string.Format("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token={0}&type=jsapi", accesstoken);
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls;
            WebClient Client = new WebClient();
            string result = Client.DownloadString(url);
            JsAPIResponse ResultObj = Newtonsoft.Json.JsonConvert.DeserializeObject<JsAPIResponse>(result);
            return ResultObj;
        }
        /// <summary>
        /// 获取缓存token 
        /// </summary>
        /// <param name="weixinid"></param>
        /// <returns></returns>
        public static JsAPIResponse GetTicket(string weixinid)
        {
            string sql = @"SELECT jsapi_ticket,jsapi_expires_in FROM WeiXinNO WITH(NOLOCK) WHERE WeiXinID=@WeiXinID";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("WeiXinID", new DBParam { ParamValue = weixinid });
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);
            JsAPIResponse jsapi = new JsAPIResponse();
            if (dt != null && dt.Rows.Count > 0)
            {
                jsapi.ticket = dt.Rows[0]["jsapi_ticket"].ToString();
                string date = dt.Rows[0]["jsapi_expires_in"].ToString();

                DateTime Error = new DateTime(1991, 1, 1);

                DateTime expires = DateTime.TryParse(date, out Error) ? DateTime.Parse(date) : Error;
                jsapi.expires_in = (DateTime.Now - expires).TotalSeconds;

                //过期重新生成
                if (string.IsNullOrEmpty(date) || jsapi.expires_in >= 7100)
                {
                    //生成调用凭证
                    var Token = hotel3g.Repository.MemberHelper.GetAccessToken(weixinid);
                    jsapi = jsapi_ticket(Token.message);

                    if (jsapi.errcode == 0)
                    {
                        //写入数据库
                        sql = "UPDATE WeiXinNO SET jsapi_ticket=@jsapi_ticket,jsapi_expires_in=GETDATE() WHERE WeiXinID=@WeiXinID";
                        Dic.Add("jsapi_ticket", new DBParam { ParamValue = jsapi.ticket });
                        int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);
                    }


                    return jsapi;
                }

                return jsapi;
            }
            return new JsAPIResponse() { errcode = 1000, errmsg = "查无次账户" };
        }
        /// <summary>
        /// 获取jssdk 签名配置信息
        /// </summary>
        /// <param name="weixinID">酒店微信id</param>
        /// <param name="LocalUrl">调用jssdk的网页地址</param>
        /// <returns></returns>
        public static JsApiSignatureResponse JsApiSignature(string weixinID, string LocalUrl)
        {
            weixinID = "gh_7a64caf61dff";
            //获取jsapi缓存凭证
            JsAPIResponse ticket = WeiXinJsSdkDAL.GetTicket(weixinID);
            JsApiSignatureResponse Signature = new JsApiSignatureResponse();
            Signature.jsapi_ticket = ticket.ticket;

            //时间戳
            TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
            string timespan = Convert.ToInt64(ts.TotalSeconds).ToString();
            Signature.timestamp = timespan;
            Signature.noncestr = WeiXinJsSdkDAL.GetRandomString(16, true, true, true, false, "");
            Signature.url = LocalUrl;// Request.Url.AbsoluteUri; ;

            //字典排序
            Dictionary<string, string> Prems = new Dictionary<string, string>();
            Prems.Add("jsapi_ticket", Signature.jsapi_ticket);
            Prems.Add("noncestr", Signature.noncestr);
            Prems.Add("timestamp", Signature.timestamp);
            Prems.Add("url", Signature.url);

            string PremsStr = "";
            foreach (var item in Prems)
            {
                PremsStr += string.Format("&{0}={1}", item.Key, item.Value);
            }
            PremsStr = PremsStr.Substring(1);

            Signature.signature = GetSHA1(PremsStr, Encoding.UTF8).ToLower();


            string sql = "SELECT appid FROM dbo.WeiXinNO  WITH(NOLOCK) WHERE WeiXinID=@WeiXinID";
            string appid = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                {"WeiXinID",new DBParam{ParamValue=weixinID}}
            });
            Signature.appid = appid;

            return Signature;
        }
    }
    public class JsApiSignatureResponse
    {
        public string appid { get; set; }
        public string noncestr { get; set; }
        public string jsapi_ticket { get; set; }
        public string timestamp { get; set; }
        public string signature { get; set; }
        public string url { get; set; }
    }
    public class JsAPIResponse
    {
        public int errcode { get; set; }
        public string errmsg { get; set; }
        public string ticket { get; set; }
        public double expires_in { get; set; }
    }
}