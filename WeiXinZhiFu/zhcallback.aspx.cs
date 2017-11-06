using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Specialized;
using System.Text;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.IO;

namespace hotel3g.WeiXinZhiFu
{
    public partial class zhcallback : System.Web.UI.Page
    {
        #region 工具类
        /** ================得到Get参数集合========= */
        public Dictionary<string, string> GetRequestGet()
        {
            int i = 0;
            Dictionary<string, string> sArray = new Dictionary<string, string>();
            NameValueCollection coll;
            coll = Request.QueryString;
            String[] requestItem = coll.AllKeys;
            for (i = 0; i < requestItem.Length; i++)
                sArray.Add(requestItem[i], Request.QueryString[requestItem[i]]);
            return sArray;
        }
        /** ================得到Post参数集合========= */
        public Dictionary<string, string> GetRequestPost()
        {
            int i = 0;
            Dictionary<string, string> sArray = new Dictionary<string, string>();
            NameValueCollection coll;
            coll = Request.Form;
            String[] requestItem = coll.AllKeys;
            for (i = 0; i < requestItem.Length; i++)
                sArray.Add(requestItem[i], Request.Form[requestItem[i]]);
            return sArray;
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
            byte[] bytes_in = System.Text.Encoding.UTF8.GetBytes(data);
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
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            #region POST数据
            if (Request.HttpMethod == "POST")
            {
                System.Web.Script.Serialization.JavaScriptSerializer js = new System.Web.Script.Serialization.JavaScriptSerializer();
                string retMsgJson = "{\"code\":\"1\",\"message\":\"处理通知结果异常\",\"data\":\"eyJzdGF0dXMiOiJzdWNjZXNzIn0%3d\"}";
                try
                {
                    string error = string.Empty;
                    Stream s = System.Web.HttpContext.Current.Request.InputStream;
                    byte[] b = new byte[s.Length];
                    s.Read(b, 0, (int)s.Length);
                    string ToJson = Encoding.UTF8.GetString(b);
                    WxPayAPI.Log.Info("招行支付回调Json数据", ToJson);
                    System.Collections.Hashtable r = (System.Collections.Hashtable)Newtonsoft.Json.JsonConvert.DeserializeObject(ToJson, typeof(System.Collections.Hashtable));

                    /** ================  1.接收平台返回报文结构  ================ */
                    var inputPara = new Dictionary<string, string>();
                    inputPara.Add("channelNo", r["channelNo"].ToString());
                    inputPara.Add("optType", r["optType"].ToString());
                    inputPara.Add("lang", r["lang"].ToString());
                    inputPara.Add("randStr", r["randStr"].ToString());
                    inputPara.Add("publicKeyNo", r["publicKeyNo"].ToString());
                    inputPara.Add("data", r["data"].ToString());
                    inputPara.Add("timestamp", r["timestamp"].ToString());
                    inputPara.Add("version", r["version"].ToString());

                    /** ================ 2.对原始报文排序、合并、SHA1处理================ */
                    String data = Sign(inputPara);

                    /** ================ 3.用渠道私钥签名================ */
                    String signByPfx = r["sign"].ToString();

                    /** ================ 4.验签 ================ */
                    bool verifyResultByCer = VerifyWithCerFilePath(data, signByPfx, "c://server.cer");

                    WxPayAPI.Log.Info("招行支付回调验签结果", verifyResultByCer.ToString());
                    if (verifyResultByCer)
                    {
                        /** ================Token 字符串64解码========= */
                        byte[] bytes = Convert.FromBase64String(r["data"].ToString());
                        System.Collections.Hashtable crt = (System.Collections.Hashtable)Newtonsoft.Json.JsonConvert.DeserializeObject(Encoding.UTF8.GetString(bytes), typeof(System.Collections.Hashtable));
                        string ShopId = crt["ShopId"].ToString();
                        string OrderNo = crt["OrderNo"].ToString();
                        string OrderStatus = crt["OrderStatus"].ToString();
                        string Amount = crt["Amount"].ToString();
                        string remark = "";
                        if (OrderStatus == "-2") { remark = "[微信支付]:招行接口返回订单状态:未知"; }
                        if (OrderStatus == "-1") { remark = "[微信支付]:招行接口返回订单状态:未处理"; }
                        if (OrderStatus == "0") { remark = "[微信支付]:招行接口返回订单状态:未知"; }
                        if (OrderStatus == "1") { remark = "[微信支付]:招行接口返回订单状态:成功" + DateTime.Now.ToString() + "支付" + Amount + "元</br>"; }
                        if (OrderStatus == "2") { remark = "[微信支付]:招行接口返回订单状态:处理中"; }
                        if (OrderStatus == "3") { remark = "[微信支付]:招行接口返回订单状态:撤销"; }
                        if (OrderStatus == "4") { remark = "[微信支付]:招行接口返回订单状态:关闭"; }
                        if (OrderStatus == "5") { remark = "[微信支付]:招行接口返回订单状态:退款"; }
                        string tsql = "update WeiXin..HotelOrder set Remark=isnull(Remark,'')+@OperationRecord,state=7  where  OrderNO=@OrderNO;";
                        string AliPayAmount=(Convert.ToDecimal(Amount)*100).ToString();
                        if (OrderStatus == "1") 
                            tsql = @"insert into WeiXin..wkn_payrecords(OrderNO,TradeNo,UserWeiXinID,AliPayAmount,OperationRecord,Channel,Mchid) values(@OrderNO,@TradeNo,@UserWeiXinID,@AliPayAmount,@OperationRecord,'招行支付回调',@Mchid); update WeiXin..HotelOrder set Remark=isnull(Remark,'')+@OperationRecord,aliPayAmount=@AliPayAmount,aliPayTime=getdate(),tradeStatus='TRADE_FINISHED',state=24,tradeNo=@TradeNo  where  OrderNO=@OrderNO;";    
                        int Status = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.Open_Conn(System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ConnectionString.ToString()), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                                {"OrderNO",new HotelCloud.SqlServer.DBParam{ParamValue=OrderNo.Trim()}},
                                {"TradeNo",new HotelCloud.SqlServer.DBParam{ParamValue=OrderNo.Trim()}},
                                {"Mchid",new HotelCloud.SqlServer.DBParam{ParamValue=ShopId}},
                                {"UserWeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=""}},                                
                                {"AliPayAmount",new HotelCloud.SqlServer.DBParam{ParamValue=AliPayAmount.ToString()}},             
                                {"OperationRecord",new HotelCloud.SqlServer.DBParam{ParamValue=remark}}                            
                        });
                        if (Status>0)
                            retMsgJson = "{\"code\":\"0\",\"message\":\"处理通知结果OK\",\"data\":\"eyJzdGF0dXMiOiJzdWNjZXNzIn0%3d\"}";
                        else
                            retMsgJson = "{\"code\":\"1\",\"message\":\"处理通知结果异常\",\"data\":\"eyJzdGF0dXMiOiJzdWNjZXNzIn0%3d\"}";
                    }
                }
                catch (Exception ex)
                {
                    retMsgJson = "{\"code\":\"1\",\"message\":\"处理通知结果异常\",\"data\":\"eyJzdGF0dXMiOiJzdWNjZXNzIn0%3d\"}";
                    WxPayAPI.Log.Info("招行支付", ex.Message.ToString());
                }
                finally
                {
                    WxPayAPI.Log.Info("招行支付返回", retMsgJson.ToString());
                    Response.Write(retMsgJson);
                    Response.End();
                }
            }
            #endregion
        }
    }
}