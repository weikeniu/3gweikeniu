using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using System.IO;
using System.Drawing.Imaging;
using ThoughtWorks.QRCode.Codec;
using ThoughtWorks.QRCode.Codec.Data;

namespace hotel3g.WeiXinZhiFu
{
    public partial class QRcode : System.Web.UI.Page
    {
        public static string OrderNo { get; set; }
        public static string OrderRoom { get; set; }
        public static string total_fee { get; set; }
        public static string url { get; set; }   

        /// <summary>
        /// 生成二维码
        /// </summary>
        /// <param name="strData">要生成的文字或者数字，支持中文。如： "4408810820 深圳－广州" 或者：4444444444</param>
        /// <param name="qrEncoding">三种尺寸：BYTE ，ALPHA_NUMERIC，NUMERIC</param>
        /// <param name="level">大小：L M Q H</param>
        /// <param name="version">版本：如 8</param>
        /// <param name="scale">比例：如 4</param>
        /// <returns></returns>
        public string CreateCode_Choose(string strData, string qrEncoding, string level, int version, int scale)
        {
            QRCodeEncoder qrCodeEncoder = new QRCodeEncoder();
            string encoding = qrEncoding;
            switch (encoding)
            {
                case "Byte":
                    qrCodeEncoder.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.BYTE;
                    break;
                case "AlphaNumeric":
                    qrCodeEncoder.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.ALPHA_NUMERIC;
                    break;
                case "Numeric":
                    qrCodeEncoder.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.NUMERIC;
                    break;
                default:
                    qrCodeEncoder.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.BYTE;
                    break;
            }

            qrCodeEncoder.QRCodeScale = scale;
            qrCodeEncoder.QRCodeVersion = version;
            switch (level)
            {
                case "L":
                    qrCodeEncoder.QRCodeErrorCorrect = QRCodeEncoder.ERROR_CORRECTION.L;
                    break;
                case "M":
                    qrCodeEncoder.QRCodeErrorCorrect = QRCodeEncoder.ERROR_CORRECTION.M;
                    break;
                case "Q":
                    qrCodeEncoder.QRCodeErrorCorrect = QRCodeEncoder.ERROR_CORRECTION.Q;
                    break;
                default:
                    qrCodeEncoder.QRCodeErrorCorrect = QRCodeEncoder.ERROR_CORRECTION.H;
                    break;
            }
            System.Drawing.Image image = qrCodeEncoder.Encode(strData);
            string filename = DateTime.Now.ToString("yyyymmddhhmmssfff").ToString() + ".jpg";
            string filepath = Server.MapPath(@"~\WeiXinZhiFu\Upload") + "\\" + filename;
            System.IO.FileStream fs = new System.IO.FileStream(filepath, System.IO.FileMode.OpenOrCreate, System.IO.FileAccess.Write);
            image.Save(fs, System.Drawing.Imaging.ImageFormat.Jpeg);
            fs.Close();
            image.Dispose();
            return string.Format(@"/Upload/" + filename);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) {
                OrderNo = HotelCloud.Common.HCRequest.GetString("OrderNo").ToUpper().Trim();
                if (!string.IsNullOrEmpty(OrderNo)) {
                    if (OrderNo.Contains("C"))
                    {
                        var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from WeiXin..RechargeUser where OrderNo=@OrderNo", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=OrderNo}}
                        });
                        if (dt.Rows.Count > 0)
                        {
                            foreach (System.Data.DataRow dr in dt.Rows)
                            {
                                int OrderAmount = Convert.ToInt32(Convert.ToDecimal(dr["SPrice"].ToString()) * 1);
                                OrderRoom ="充值扣款";
                                total_fee = OrderAmount.ToString();
                            }
                        }
                    }
                    else if (OrderNo.Contains("K"))
                    {
                        var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from WeiXin..MemberCardBuyRecord where OrderNo=@OrderNo", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=OrderNo}}
                        });
                        if (dt.Rows.Count > 0)
                        {
                            foreach (System.Data.DataRow dr in dt.Rows)
                            {
                                int OrderAmount = Convert.ToInt32(Convert.ToDecimal(dr["BuyMoney"].ToString()) * 1);
                                OrderRoom = "会员卡购买";
                                total_fee = OrderAmount.ToString();
                            }
                        }
                    }
                    else if (OrderNo.Contains("D"))
                    {
                        var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 *  from WeiXin..SupermarketOrder_Levi where OrderId=@OrderId", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"OrderId",new HotelCloud.SqlServer.DBParam{ParamValue=OrderNo.Trim()}}
                        });
                        if (dt.Rows.Count > 0)
                        {
                            foreach (System.Data.DataRow dr in dt.Rows)
                            {
                                int OrderAmount = Convert.ToInt32(Convert.ToDecimal(dr["Money"].ToString()) * 1);
                                OrderRoom = "酒店周边超市消费";
                                total_fee = OrderAmount.ToString();
                            }
                        }
                    }
                    else if (OrderNo.Contains("P"))
                    {
                        var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 * from WeiXin..SaleProducts_Orders where OrderNo=@OrderNo", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=OrderNo}}
                        });
                        if (dt.Rows.Count > 0)
                        {
                            foreach (System.Data.DataRow dr in dt.Rows)
                            {
                                int OrderAmount = Convert.ToInt32(Convert.ToDecimal(dr["OrderMoney"].ToString()) * 1);
                                OrderRoom = dr["ProductName"].ToString().Trim() + "[" + dr["TcName"].ToString().Trim() + "]";
                                total_fee = OrderAmount.ToString();
                            }
                        }
                    }
                    else if (OrderNo.Contains("L"))
                    {
                        var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 bagging,amount,youhuiamount,hotelid,userweixinid,hotelWeixinId,orderCode,(select sum(AliPayAmount) from  WeiXin..wkn_payrecords where OrderNO=orderCode and Channel='微信支付回调') as zhifu  from WeiXin..T_OrderInfo where orderCode=@orderCode", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"orderCode",new HotelCloud.SqlServer.DBParam{ParamValue=OrderNo.Trim()}}
                        });
                        if (dt.Rows.Count > 0)
                        {
                            foreach (System.Data.DataRow dr in dt.Rows)
                            {
                                string bagging = dr["bagging"].ToString();
                                string youhuiamount = dr["youhuiamount"].ToString();
                                if (string.IsNullOrEmpty(bagging)) { bagging = "0"; }
                                if (string.IsNullOrEmpty(youhuiamount)) { youhuiamount = "0"; }
                                int OrderAmount = Convert.ToInt32((Convert.ToDecimal(dr["amount"].ToString()) - Convert.ToDecimal(youhuiamount) + Convert.ToDecimal(bagging)) * 1);
                                OrderRoom = "酒店周边餐饮消费";
                                total_fee = OrderAmount.ToString();
                            }
                        }
                    }
                    else
                    {
                        hotel3g.Repository.Order order = hotel3g.Repository.OrderRepository.GetOrderInfo(OrderNo.Trim());
                        OrderRoom = order.RoomName + "[" + order.RatePlanName + "]";
                        total_fee = order.OrderAmount.ToString();
                        url = string.Format("http://hotel.weikeniu.com/Hotel/Index/{0}?key={1}@{2}", order.HotelID.ToString(), order.WeiXinID.ToString(), order.UserWeiXinID.ToString());
                    }
                }
                if (HotelCloud.Common.HCRequest.GetString("action") == "code")
                {                    
                    WxPayAPI.NativePay np = new WxPayAPI.NativePay();
                    /** ================得到长连接========= */
                    string long_url = np.GetPrePayUrl(HotelCloud.Common.HCRequest.GetString("OrderNo")); 
                    WxPayAPI.WxPayData data = new WxPayAPI.WxPayData();
                    data.SetValue("long_url", long_url);
                    /** ================减小二维码数据量，提升扫描速度和精确度========= */
                    WxPayAPI.WxPayData Result = WxPayAPI.WxPayApi.ShortUrl(data, 6); 
                    if (Result != null)
                    {
                        if (Result.GetValue("return_code").ToString() == "SUCCESS")
                        {
                            string ShortUrl = Result.GetValue("short_url").ToString();
                            WxPayAPI.Log.Debug("WxPayApi", "ShortUrl  : " + long_url);
                            Response.Write(CreateCode_Choose(ShortUrl, "Byte", "M", 8, 4));
                        }
                    }                    
                    Response.End();
                }
            }
        }
    }
}
