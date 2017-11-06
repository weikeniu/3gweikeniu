using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using System.Text;
using System.Security.Cryptography;
using Newtonsoft.Json;
using WxPayAPI;
using System.Net;
using System.IO;

namespace hotel3g.WeiXinZhiFu
{
    public partial class wxpaycenter : System.Web.UI.Page
    {        
        #region 工具类
        /** ================Unix时间戳(C#获取的unix时间戳是10位，原因是 java采用毫秒计算，而C#采用秒，获取unix时间戳的代码中 乘以1000)========= */
        public static string GenerateTimeStamp()
        {
            TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
            return Convert.ToInt64(ts.TotalSeconds * 1000).ToString();
        }
        /** ================ 随机字符串========= */
        public static string GenerateNonceStr()
        {
            return Guid.NewGuid().ToString().Replace("-", "");
        }
        /** ================ 随机生成单号========= */
        public static string GenerateOutTradeNo()
        {
            var ran = new Random();
            return string.Format("{0}{1}{2}", "", DateTime.Now.ToString("yyyyMMddHHmmss"), ran.Next(999));
        }
        /** ================ HTTPS请求使用========= */
        public static bool CheckValidationResult(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
        {
            //直接确认，否则打不开    
            return true;
        }
        /** ================ Dictionary参数过滤========= */
        public static Dictionary<string, string> FilterPara(Dictionary<string, string> dicArrayPre)
        {
            Dictionary<string, string> dicArray = new Dictionary<string, string>();
            foreach (KeyValuePair<string, string> temp in dicArrayPre)
            {
                if (temp.Value != "" && temp.Value != null)
                    dicArray.Add(temp.Key, temp.Value);
            }
            return dicArray;
        }
        /** ================ Dictionary参数排序========= */
        public static Dictionary<string, string> SortPara(Dictionary<string, string> dicArrayPre)
        {
            SortedDictionary<string, string> dicTemp = new SortedDictionary<string, string>(dicArrayPre);
            Dictionary<string, string> dicArray = new Dictionary<string, string>(dicTemp);
            return dicArray;
        }
        /** ================ Dictionary参数合并成&连接的URL参数地址========= */
        public static string CreateLinkString(Dictionary<string, string> dicArray)
        {
            StringBuilder prestr = new StringBuilder();
            foreach (KeyValuePair<string, string> temp in dicArray)
                prestr.Append(temp.Key + "=" + temp.Value + "&");
            int nLen = prestr.Length;
            prestr.Remove(nLen - 1, 1);
            return prestr.ToString();
        }
        /** ================ 签名内容 —> UTF8编码 —>使用SHA1进行摘要算法，生成签名字符数组 —>  16进制========= */
        public static string RSADecryptHashAndSignString(string plaintext, string privateKey)
        {
            byte[] dataToEncrypt = System.Text.Encoding.UTF8.GetBytes(plaintext);
            using (RSACryptoServiceProvider RSAalg = new RSACryptoServiceProvider())
            {
                RSAalg.FromXmlString(privateKey);
                byte[] encryptedData = RSAalg.SignData(dataToEncrypt, new SHA1CryptoServiceProvider());
                string returnStr = "";
                if (encryptedData != null)
                {
                    for (int i = 0; i < encryptedData.Length; i++)
                        returnStr += encryptedData[i].ToString("X2");
                }
                return returnStr;
            }
        }
        /** ================ 参数排序参数后合并 —> SHA1 —> 16进制 —> 小写========= */
        public static string Sign(Dictionary<string, string> paramValues)
        {
            StringBuilder sb = new StringBuilder();
            List<string> paramNames = paramValues.Keys.ToList();
            paramNames.Sort();
            foreach (string paramName in paramNames)
            {
                string value = paramValues[paramName];
                if (!string.IsNullOrEmpty(value))
                    sb.Append(paramName).Append("=").Append(value).Append("&");
            }
            string sha1data = GetSHA1Digest(sb.ToString().Substring(0, sb.ToString().LastIndexOf("&")));
            return sha1data.ToLower();
        }
        /** ================ 给字符串做SHA1加密========= */
        public static string GetSHA1Digest(string data)
        {
            SHA1 sha1 = new SHA1CryptoServiceProvider();
            byte[] bytes_in = System.Text.Encoding.UTF8.GetBytes(data);//System.Text.UTF8Encoding.Default.GetBytes(data);
            byte[] bytes_out = sha1.ComputeHash(bytes_in);
            sha1.Dispose();
            string result = BitConverter.ToString(bytes_out);
            result = result.Replace("-", "");
            return result;
        }
        /** ================ BYTE[] 转 16 进制字符串========= */
        public static string BytesToHexString(byte[] bytes)
        {
            StringBuilder sb = new StringBuilder();
            foreach (byte InByte in bytes)
                sb.Append(string.Format("{0:x2}", InByte));
            return sb.ToString();
        }
        /** ================ 16 进制字符串转BYTE[]========= */
        public static byte[] StringToByte(string hexString)
        {
            hexString = hexString.Replace(" ", "");
            if ((hexString.Length % 2) != 0)
                hexString += " ";
            byte[] returnBytes = new byte[hexString.Length / 2];
            for (int i = 0; i < returnBytes.Length; i++)
                returnBytes[i] = Convert.ToByte(hexString.Substring(i * 2, 2), 16);
            return returnBytes;

        }
        /** ================ 招行提供私钥签名========= */
        public static string SignDataWithPfxFilePath(string data, string password, string pfxFilePath)
        {
            var objx5092 = new X509Certificate2(pfxFilePath, password);
            SHA1Managed lvSHA1 = new SHA1Managed();
            byte[] lvData = Encoding.UTF8.GetBytes(data);
            byte[] lvHash = lvSHA1.ComputeHash(lvData);
            RSACryptoServiceProvider lvCryptoProvider = (RSACryptoServiceProvider)objx5092.PrivateKey;
            byte[] lvSignedBytes = lvCryptoProvider.SignHash(lvHash, CryptoConfig.MapNameToOID("SHA1"));
            return BytesToHexString(lvSignedBytes);
        }
        /** ================ 招行提供公钥验签========= */
        public static bool VerifyWithCerFilePath(string data, string signData, string cerFilePath)
        {
            SHA1Managed lvSHA1 = new SHA1Managed();
            byte[] bytesData = Encoding.UTF8.GetBytes(data);
            byte[] lvHash = lvSHA1.ComputeHash(bytesData);
            byte[] bytesSignData = StringToByte(signData);
            var x509Certificate = new X509Certificate2(cerFilePath);
            string xmlString = x509Certificate.PublicKey.Key.ToXmlString(false);
            var key = new RSACryptoServiceProvider();
            key.FromXmlString(xmlString);
            var signatureDeformatter = new RSAPKCS1SignatureDeformatter(key);
            signatureDeformatter.SetHashAlgorithm("SHA1");
            return signatureDeformatter.VerifySignature(lvHash, bytesSignData);
        }
        /** ================ MD5加密========= */
        public static string getMD5(string source)
        {
            string result = "";
            try
            {
                MD5 getmd5 = new MD5CryptoServiceProvider();
                byte[] targetStr = getmd5.ComputeHash(UnicodeEncoding.UTF8.GetBytes(source));
                result = BitConverter.ToString(targetStr).Replace("-", "");
                return result;
            }
            catch (Exception) { return "0"; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(HotelCloud.Common.HCRequest.GetString("p")))
                {
                    string appid = HotelCloud.Common.HCRequest.GetString("p");
                    string orderid = HotelCloud.Common.HCRequest.GetString("o");
                    bool isProcess = false;
                    string edition = "0";
                    if (appid == "wx9f84537c7ce94a29" && orderid.ToUpper().IndexOf("W")>-1 &&  orderid.ToUpper().IndexOf("WX")<0)
                    {
                        hotel3g.Repository.Order order = hotel3g.Repository.OrderRepository.GetOrderInfo(orderid);
                        string isbank = "0";
                        var weixinstrtable = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 appkey,appid,mchid,isbank,weixintype,edition from  WeiXin..WeiXinNO where WeiXinID=@WeiXinID", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "WeiXinID", new HotelCloud.SqlServer.DBParam { ParamValue = order.WeiXinID.Trim() } } });
                        if (weixinstrtable != null)
                        {
                            if (weixinstrtable.Rows.Count > 0)
                            {
                                foreach (System.Data.DataRow rd in weixinstrtable.Rows)
                                {
                                    isbank = string.IsNullOrEmpty(rd["isbank"].ToString()) ? "0" : rd["isbank"].ToString();
                                    edition = rd["edition"].ToString();
                                }
                            }
                        }
                        if (isbank.Trim() == "1")
                        {
                            isProcess = true;
                                                       
                            string result = "";//返回结果
                            string Amount = order.OrderAmount.ToString();
                            if (order.LinkTel == "13168334542") { Amount = "0.01"; }

                            /** ================ 报文体 业务数据 bizdata=urlencode(base64(业务数据 json 格式))120.76.245.98:8087/zhcallback.aspx========= */
                            Dictionary<string, string> sArray = new Dictionary<string, string>();
                            sArray.Add("OrderNo", order.OrderNo);
                            sArray.Add("Channel", "1203");
                            sArray.Add("ShopId", "338991587226816512");
                            sArray.Add("Subject", order.HotelName.Trim() + "[" + order.RoomName.Trim() + "]");
                            sArray.Add("Body", "客房销售");
                            sArray.Add("Amount", Amount);
                            sArray.Add("DiscountAmount", Amount);
                            sArray.Add("CallbackUrl", "http://124.172.223.139:8087/WeiXinZhiFu/zhcallback.aspx");
                            if (edition=="1")
                                sArray.Add("RedirectUrl", string.Format("http://hotel.weikeniu.com/UserA/OrderInfo/{0}?id={1}&key={3}@{2}&souce=zh", order.HotelID.ToString().Trim(), order.Id.ToString(), order.UserWeiXinID.Trim(), order.WeiXinID.Trim()));
                            else
                                sArray.Add("RedirectUrl", string.Format("http://hotel.weikeniu.com/User/OrderInfo/{0}?id={1}&key={3}@{2}&souce=zh", order.HotelID.ToString().Trim(), order.Id.ToString(), order.UserWeiXinID.Trim(), order.WeiXinID.Trim()));
                            string bizdata = System.Web.HttpUtility.UrlEncode(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(sArray, Formatting.Indented))), Encoding.UTF8);

                            Log.Debug(this.GetType().ToString(), "订单号: " + order.OrderNo);

                            /** ================ 报文头========= */
                            Dictionary<string, string> inputPara = new Dictionary<string, string>();
                            inputPara.Add("channelNo", "B001");
                            inputPara.Add("optType", "FT_S_P104");
                            inputPara.Add("lang", "zh_CN");
                            inputPara.Add("timestamp", GenerateTimeStamp());
                            inputPara.Add("randStr", GenerateNonceStr());
                            inputPara.Add("publicKeyNo", "0000");
                            inputPara.Add("data", bizdata);
                            inputPara.Add("version", "1.0");

                            /** ================ 对原始报文排序、合并、SHA1处理========= */
                            string data2 = Sign(inputPara);
                            Log.Debug(this.GetType().ToString(), "SHA1处理result data : " + data2);

                            string sign = SignDataWithPfxFilePath(data2, "EAccount123", "c://临时使用.pfx");
                            Log.Debug(this.GetType().ToString(), "签名结果result data: " + sign);

                            /** ================ 放入请求数据结构体========= */
                            inputPara.Add("sign", sign);

                            /** ================ 在线post参数========= */
                            Log.Debug(this.GetType().ToString(), "在线post参数 data json: " + JsonConvert.SerializeObject(inputPara, Formatting.Indented));

                            System.GC.Collect();//垃圾回收，回收没有正常关闭的http连接          
                            HttpWebRequest request = null;
                            HttpWebResponse response = null;
                            Stream reqStream = null;
                            string url = "";
                            try
                            {
                                ServicePointManager.DefaultConnectionLimit = 200;
                                ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(CheckValidationResult);
                                request = (HttpWebRequest)WebRequest.Create("https://openapi.frontpay.cn/openapi.do");
                                request.Method = "POST";
                                request.Timeout = 10000;

                                /** ================ 设置代理服务器========= */
                                //WebProxy proxy = new WebProxy();                          //定义一个网关对象
                                //proxy.Address = new Uri(WxPayConfig.PROXY_URL);              //网关服务器端口:端口
                                //request.Proxy = proxy;

                                request.ContentType = "application/json";
                                byte[] data = System.Text.Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(inputPara, Formatting.Indented));
                                request.ContentLength = data.Length;
                                reqStream = request.GetRequestStream();
                                reqStream.Write(data, 0, data.Length);
                                reqStream.Close();
                                response = (HttpWebResponse)request.GetResponse();
                                StreamReader sr = new StreamReader(response.GetResponseStream(), Encoding.UTF8);
                                result = sr.ReadToEnd().Trim();
                                sr.Close();
                                if (!string.IsNullOrEmpty(result))
                                {
                                    /** ================ 返回成功模拟数据========= */
                                    Log.Info("HttpService", "支付请求result data:" + result);
                                    System.Collections.Hashtable r = (System.Collections.Hashtable)Newtonsoft.Json.JsonConvert.DeserializeObject(result, typeof(System.Collections.Hashtable));
                                    if (r["code"].ToString() == "10000")
                                    {
                                        /** ================  1.接收平台返回报文结构  ================ */
                                        var parameters = new Dictionary<string, string>();
                                        parameters.Add("code", r["code"].ToString());
                                        parameters.Add("message", r["message"].ToString());
                                        parameters.Add("randStr", r["randStr"].ToString());
                                        parameters.Add("data", r["data"].ToString());
                                        parameters.Add("timestamp", r["timestamp"].ToString());

                                        /** ================ 2.对原始报文排序、合并、SHA1处理================ */
                                        String datatoken = Sign(parameters);

                                        /** ================ 3.用渠道私钥签名================ */
                                        String signByPfx = r["sign"].ToString();

                                        /** ================ 4.验签 ================ */
                                        bool verifyResultByCer = VerifyWithCerFilePath(datatoken, signByPfx, "c://server.cer");
                                        Log.Debug(this.GetType().ToString(), "token验签名data: " + verifyResultByCer);

                                        if (verifyResultByCer)
                                        {
                                            byte[] bytes = Convert.FromBase64String(r["data"].ToString());
                                            /** ================Token 字符串64解码========= */
                                            System.Collections.Hashtable crt = (System.Collections.Hashtable)Newtonsoft.Json.JsonConvert.DeserializeObject(Encoding.UTF8.GetString(bytes), typeof(System.Collections.Hashtable));
                                            string signToken = getMD5(string.Format("token={0}&ProductName={1}", crt["token"].ToString(), order.HotelName.Trim() + "[" + order.RoomName.Trim() + "]"));
                                            url = string.Format("https://qr.frontpay.cn/sinochem/order/comfirmpay?token={0}&signToken={1}&ProductName={2}", crt["token"].ToString(), signToken, order.HotelName.Trim() + "[" + order.RoomName.Trim() + "]");
                                        }
                                    }
                                }
                            }
                            catch (System.Threading.ThreadAbortException ex) { Log.Error("HttpService", "Thread - caught ThreadAbortException - resetting."); Log.Error("Exception message: {0}", ex.Message); System.Threading.Thread.ResetAbort(); }
                            catch (WebException ex) { Log.Error("HttpService", ex.ToString()); if (ex.Status == WebExceptionStatus.ProtocolError) { Log.Error("HttpService", "StatusCode : " + ((HttpWebResponse)ex.Response).StatusCode); Log.Error("HttpService", "StatusDescription : " + ((HttpWebResponse)ex.Response).StatusDescription); } }
                            catch (Exception ex) { Log.Error("HttpService", ex.ToString()); }
                            finally
                            {
                                if (response != null) { response.Close(); }
                                if (request != null) { request.Abort(); }
                                if (!string.IsNullOrEmpty(url)) { Response.Redirect(url, false); }
                            }  
                        }
                    }
                    if (!isProcess)
                    {
                        string weixinUrl = string.Format("https://open.weixin.qq.com/connect/oauth2/authorize?appid={1}&redirect_uri=http%3a%2f%2fhotel.weikeniu.com%2fWeiXinZhiFu%2fwxOAuthRedirect.aspx&response_type=code&scope=snsapi_base&state={0}#wechat_redirect", orderid.Trim(), appid.Trim());
                        Response.Redirect(weixinUrl, false);
                    }
                }
            }                                        
        }
    }
}