using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Net;
using System.Threading.Tasks;
using System.Drawing.Imaging;
using System.Drawing;
using System.Drawing.Drawing2D;
using HotelCloud.SqlServer;
using System.Data;
using System.Web;

namespace hotel3g.Models.DAL
{
    public static class PromoterDAL
    {
        /// <summary>
        /// 获取图片缓存
        /// </summary>
        /// <param name="Url"></param>
        /// <param name="Name"></param>
        /// <param name="HotelID"></param>
        /// <returns></returns>
        public static string GetPromoterCoverImage(string Url, string Name, string HotelID)
        {
            if (!string.IsNullOrEmpty(Url) && Url.IndexOf("../") < 0)
            {
                string UrlPath = string.Format("{0}Content\\FxImages\\{1}\\", HttpContext.Current.Server.MapPath("~"), HotelID);
                string FileName = string.Format("{0}_{1}.jpg", Name, HotelID);

                string ShowUrl = string.Format("/Content/FxImages/{0}/{1}", HotelID, FileName);
                //判断路径是否存在
                if (!Directory.Exists(UrlPath))
                {
                    //不存在则新增
                    Directory.CreateDirectory(UrlPath);
                }

                string SavePath = UrlPath + FileName;
                //判断是否已下载该图片
                if (!File.Exists(SavePath))
                {
                    Task t = new Task(new Action(() =>
                    {
                        //异步下载图标
                        try
                        {
                            //图片不存在执行下载
                            WebClient Client = new WebClient();
                            Client.DownloadFile(Url, SavePath);
                            Client.Dispose();

                            if (!Name.Equals("LOGO"))
                            {
                                //对图片进行压缩
                                GetPicThumbnail(SavePath, SavePath);
                            }
                        }
                        catch { }
                    }));
                    t.Start();
                }
                return ShowUrl;
            }
            return Url;
        }

        public static hotel3g.PromoterEntitys.WeiXinPublicInfoResponse GetWeiXinPublicInfo(string weixinid)
        {
            string sql = "SELECT TOP 1 WeiXin2Img,appid,weixintype,WeiXinImg FROM dbo.WeiXinNO WITH(NOLOCK) WHERE WeiXinID=@WeiXinID";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                {"WeiXinID",new DBParam{ParamValue=weixinid}}
                });
            if (dt != null && dt.Rows.Count > 0)
            {
                return dt.ToList<hotel3g.PromoterEntitys.WeiXinPublicInfoResponse>()[0];
            }
            return new PromoterEntitys.WeiXinPublicInfoResponse();

        }
        #region GetPicThumbnail
        /// <summary>
        /// 压缩图片
        /// </summary>
        /// <param name="sFile"></param>
        /// <param name="outPath"></param>
        public static void GetPicThumbnail(string sFile, string outPath)
        {
            Bitmap oImage = new Bitmap(sFile);//从图片文件中读取图片流
            Bitmap OldImage = new Bitmap(oImage);//将图片流复制到新的图片流中
            oImage.Dispose();
            //转成jpg
            var eps = new EncoderParameters(1);
            var ep = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, 20L);
            eps.Param[0] = ep;
            var jpsEncodeer = GetEncoder(ImageFormat.Jpeg);
            //保存图片
            OldImage.Save(outPath, jpsEncodeer, eps);
            //释放资源
            OldImage.Dispose();
            ep.Dispose();
            eps.Dispose();
        }
        public static ImageCodecInfo GetEncoder(ImageFormat format)
        {
            ImageCodecInfo[] codecs = ImageCodecInfo.GetImageDecoders();
            foreach (ImageCodecInfo codec in codecs)
            {
                if (codec.FormatID == format.Guid)
                    return codec;
            }
            return null;
        }
        #endregion

        /// <summary>
        /// 
        /// </summary>
        /// <param name="weixinid"></param>
        /// <param name="value"></param>
        public static void SetShareCookie(string weixinid, string value)
        {

            string name = string.Format("wkn_share_{0}", weixinid);

            if (GetShareCookie(name) != null)
            {
                //已存在则移除
                HttpContext.Current.Request.Cookies.Remove(name);
            }
            HttpCookie User = new HttpCookie(name, value);
            User.Expires = DateTime.Now.AddHours(1);
            HttpContext.Current.Response.AppendCookie(User);

        }
        public static string GetShareCookie(string weixinid)
        {
            string name = string.Format("wkn_share_{0}", weixinid);
            if (HttpContext.Current.Request.Cookies[name] != null)
            {
                string ShareCookie = HttpContext.Current.Request.Cookies[name].Value;
                return ShareCookie;
            }
            return "";
        }
        public static string WX_ShareLinkUserWeiXinId
        {
            get
            {
                return "weikeniusharelink";
            }
        }

        /// <summary>
        /// 自动帮客人领取推广员红包
        /// </summary>
        /// <param name="weixinid"></param>
        /// <param name="tel"></param>
        /// <param name="memberid"></param>
        /// <returns></returns>
        public static string SendCustomCoupon(string weixinid, string tel, int memberid, int hid, out bool status)
        {

            if (!string.IsNullOrEmpty(weixinid) && !string.IsNullOrEmpty(tel) && memberid > 0)
            {
                string sql = "SELECT id,moneys,amountlimit,s_JiFen,scopelimit,s_afterDaysCanUse FROM dbo.CouPon WITH(NOLOCK) WHERE weixinID=@WeiXinID AND s_huodongid>0";

                DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                {"WeiXinID",new DBParam{ParamValue=weixinid}}
                });
                string hongbao = string.Empty;
                string typeid = "";
                string amountlimit = "0";
                string jifen = "0";
                string afterdays = "0";

                if (dt != null && dt.Rows.Count > 0)
                {
                    hongbao = dt.Rows[0]["moneys"].ToString();
                    amountlimit = dt.Rows[0]["amountlimit"].ToString();
                    typeid = dt.Rows[0]["id"].ToString();
                    jifen = dt.Rows[0]["s_JiFen"].ToString();

                    afterdays = dt.Rows[0]["s_afterDaysCanUse"].ToString();
                }
                if (string.IsNullOrEmpty(hongbao))
                {
                    status = false;
                    return "参数异常";
                }
                //检验是否已领取
                Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
                Dic.Add("hid", new DBParam { ParamValue = hid.ToString() });
                Dic.Add("money", new DBParam { ParamValue = hongbao.ToString() });
                Dic.Add("tel", new DBParam { ParamValue = tel });
                Dic.Add("promoterid", new DBParam { ParamValue = memberid.ToString() });
                Dic.Add("amountlimit", new DBParam { ParamValue = amountlimit.ToString() });
                Dic.Add("weixinid", new DBParam { ParamValue = weixinid });
                Dic.Add("typeid", new DBParam { ParamValue = typeid });
                Dic.Add("jifen", new DBParam { ParamValue = jifen });
                Dic.Add("afterdays", new DBParam { ParamValue = afterdays });
                sql = @"SELECT COUNT(0) FROM ShareCouponContent WITH(NOLOCK) WHERE weixinid=@weixinid AND tel=@tel";
                string Value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), Dic);
                if (int.Parse(Value) > 0)
                {
                    status = false;
                    return "存在领取记录";
                }
                sql = @"INSERT INTO ShareCouponContent(hid,tel,[money],promoterid,amountlimit,weixinid,typeid,jifen,afterdays)VALUES(@hid,@tel,@money,@promoterid,@amountlimit,@weixinid,@typeid,@jifen,@afterdays)
";
                int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);

                if (Count > 0)
                {
                    //检验手机号是否已注册
                    sql = "SELECT userWeiXinNO FROM dbo.Member WITH(NOLOCK) WHERE weixinID=@weixinid AND mobile=@tel";
                    string userWeiXinNO = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), Dic);
                    if (!string.IsNullOrEmpty(userWeiXinNO) && userWeiXinNO.Length > 10)
                    {
                        int interror = 0;
                        int afterdays_ = int.TryParse(afterdays, out interror) ? int.Parse(afterdays) : 0;

                        //已存在账户 直接赠送红包
                        string sdate = DateTime.Now.AddDays(afterdays_).ToString("yyyy-MM-dd");
                        string edate = DateTime.Now.AddYears(1).ToString("yyyy-MM-dd");
                        string conpon = DateTime.Now.AddMilliseconds(10).ToString("yyMMddHHmmssfff");

                        sql = string.Format(@"insert into CouPonContent(weixinID,moneys,sTime,ExtTime,addTime,IsEmploy,CouPonNO,userweixinNo,giftname,typeID) values('{0}','{1}','{2}','{3}',getdate(),0,'{4}','{5}','推广员红包','{6}');", weixinid, hongbao, sdate, edate, conpon, userWeiXinNO, typeid);
                        Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), null);
                    }
                }
                if (Count > 0)
                {
                    status = true;
                }
                else
                {
                    status = false;
                }

                return Count > 0 ? "领取成功" : "领取失败";
            }
            status = false;
            return "参数异常";
        }
    }
}
namespace hotel3g.PromoterEntitys
{
    /// <summary>
    /// 微信js分享参数配置
    /// </summary>
    public class WeiXinShareConfig
    {
        /// <summary>
        /// 酒店微信id
        /// </summary>
        public string weixinid { get; set; }
        /// <summary>
        /// 用户的openid
        /// </summary>
        public string userweixinid { get; set; }
        /// <summary>
        /// 分享的酒店id
        /// </summary>
        public int hotelid { get; set; }
        /// <summary>
        /// 分享的标题
        /// </summary>
        public string title { get; set; }
        /// <summary>
        /// 分享的内容说明
        /// </summary>
        public string desn { get; set; }
        /// <summary>
        /// 分享显示的图标
        /// </summary>
        public string logo { get; set; }
        /// <summary>
        /// 要分享的地址
        /// </summary>
        public string sharelink { get; set; }

        /// <summary>
        /// 是否开启调试模式
        /// </summary>
        public bool debug { get; set; }
    }

    /// <summary>
    /// 微信号信息实体
    /// </summary>
    public class WeiXinPublicInfoResponse
    {
        public string WeiXin2Img { get; set; }
        public string appid { get; set; }
        public int weixintype { get; set; }
        public string WeiXinImg { get; set; }
    }
}