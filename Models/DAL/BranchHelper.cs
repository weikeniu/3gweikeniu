using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using HotelCloud.SqlServer;
using hotel3g.Common.Branch;
using System.Reflection;
namespace hotel3g.Models.DAL
{
    public static class BranchHelper
    {
        public static List<HotelResponse> HotelList(string WeiXinID)
        {
            try
            {
                string sql = @" 
SELECT a.id,a.WeiXinID,a.SubName,a.address,a.tel,a.smsMobile,a.Content,a.hotelLog,a.[enabled],isnull(c.minprice,0) as minprice,d.url as small_url FROM dbo.Hotel AS a WITH(NOLOCK)
LEFT JOIN (
SELECT MIN(price) AS minprice,b.HotelID AS hid FROM dbo.HotelRate AS b WITH(NOLOCK)
LEFT JOIN dbo.HotelRatePlan AS rp WITH(NOLOCK) ON b.RatePlanID=rp.id
 WHERE dates=CONVERT(DATE,GETDATE()) AND b.Available=1 AND rp.Enabled=1 AND rp.PayType=0
GROUP BY b.HotelID
) AS c ON a.id=c.hid 
LEFT JOIN (
 SELECT DISTINCT url,hotelID FROM  dbo.RoomTypeImg WITH(NOLOCK) WHERE ImgNum=1  AND  imgType=1
GROUP BY hotelID,url
) AS d  ON a.id=d.hotelID
 WHERE WeiXinID=@WeiXinID AND a.enabled=1
";
                DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"WeiXinID",new DBParam{ParamValue=WeiXinID}}
            });
                if (dt != null)
                {
                    List<HotelResponse> Hotels = dt.ToList<HotelResponse>();
                    return Hotels;
                }
            }
            catch (Exception ex)
            {

            }
            return new List<HotelResponse>();
        }

        public static HotelResponse HotelInfo(string weixinID, int hotelid)
        {
            string sql = "select top 1 pid,SubName,address,cid,rid,tel,star,chainID,openDate,xiuDate,pos,roundValue,smsMobile,weixinQQ,hotel.id,hotelLog,Content,QuanJing from hotel left join cityinfo on cityInfo.id=hotel.cid where weixinID=@weixinID AND hotel.ID=@hotelid";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
                {"hotelid",new HotelCloud.SqlServer.DBParam{ParamValue=hotelid.ToString()}}
            });
            if (dt != null && dt.Rows.Count > 0)
            {
                return dt.ToList<HotelResponse>()[0];
            }
            return new HotelResponse();
        }

        public static bool IsBranch(string WeiXinID)
        {
            string sql = @"SELECT TOP 1 branch FROM dbo.WeiXinNO WHERE WeiXinID=@WeiXinID";
            string Value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"WeiXinID",new DBParam{ParamValue=WeiXinID}}
            });
            return Value.Equals("1") ? true : false;
        }

        public static void BuildCookie(string name, string value, string weixinid)
        {
            string cookiename = string.Format("{0}_{1}", name, weixinid);

            HttpCookie User = new HttpCookie(cookiename, value);
            User.Expires = DateTime.Now.AddDays(7);
            HttpContext.Current.Response.AppendCookie(User);
        }
        public static string GetCookie(string name, string weixinid)
        {
            string cookiename = string.Format("{0}_{1}", name, weixinid);
            if (HttpContext.Current.Request.Cookies[cookiename] != null)
            {
                string UserCookie = HttpContext.Current.Request.Cookies[cookiename].Value;

                return string.IsNullOrEmpty(UserCookie) ? null : UserCookie;
            }
            return null;
        }
        public static string HotelId(string weixinid)
        {
            string sql = @" SELECT TOP 1 id FROM dbo.Hotel WHERE WeiXinID=@WeiXinID ORDER BY addtime ASC";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("WeiXinID", new DBParam { ParamValue = weixinid });
            string Value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), Dic);
            return Value;
        }

        /// <summary>
        /// 此方法不兼容新权限方式 请尽快接入新权限接口
        /// </summary>
        /// <param name="weixinid"></param>
        /// <returns></returns>
        public
            static Examine GetExamine(string weixinid)
        {
            string sql = @"SELECT top 1 examine,pay_examine,supermarketrket,canyin,branch,meeting,TravelEdition,kefang  FROM dbo.WeiXinNO WITH(NOLOCK) WHERE  WeiXinId=@WeiXinID";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam { ParamValue = weixinid }}});

            Examine Examine = new DAL.Examine();
            foreach (DataRow row in dt.Rows)
            {
                string examine = string.IsNullOrEmpty(row["examine"].ToString()) ? "0" : row["examine"].ToString();
                string pay_examine = string.IsNullOrEmpty(row["pay_examine"].ToString()) ? "0" : row["pay_examine"].ToString();
                string supermarketrket = string.IsNullOrEmpty(row["supermarketrket"].ToString()) ? "0" : row["supermarketrket"].ToString();
                string canyin = string.IsNullOrEmpty(row["canyin"].ToString()) ? "0" : row["canyin"].ToString();
                string branch = string.IsNullOrEmpty(row["branch"].ToString()) ? "0" : row["branch"].ToString();
                string meeting = string.IsNullOrEmpty(row["meeting"].ToString()) ? "0" : row["meeting"].ToString();
                string travelEdition = string.IsNullOrEmpty(row["TravelEdition"].ToString()) ? "0" : row["TravelEdition"].ToString();

                string kefang = string.IsNullOrEmpty(row["kefang"].ToString()) ? "0" : row["kefang"].ToString();

                Examine.examine = int.Parse(examine);
                Examine.supermarketrket = int.Parse(supermarketrket);
                Examine.pay_examine = int.Parse(pay_examine);
                Examine.canyin = int.Parse(canyin);
                Examine.branch = int.Parse(branch);
                Examine.meeting = int.Parse(meeting);
                Examine.TravelEdition = int.Parse(travelEdition);

                Examine.kefang = int.Parse(kefang);

                return Examine;
            }
            return Examine;


            //try
            //{
            //    string sql = @"SELECT canyin FROM dbo.WeiXinNO WITH(NOLOCK) WHERE WeiXinID=@weixinid";
            //    string Value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            //{"weixinid",new DBParam{ParamValue=weixinid}}
            //});
            //    if (Value.Equals("1"))
            //    {
            //        return true;
            //    }
            //}
            //catch (Exception ex) {
            //    return false;
            //}
            //return false;
        }
    }

    //菜单权限实体
    public class Examine
    {
        //审核状态
        public int examine { get; set; }
        public int pay_examine { get; set; }
        //超市权限
        public int supermarketrket { get; set; }
        //餐饮权限
        public int canyin { get; set; }
        //分店
        public int branch { get; set; }
        //会议
        public int meeting { get; set; }

        //旅行社
        public int TravelEdition { get; set; }

        //客房
        public int kefang { get; set; }


    }

    public static class DataTableHelper
    {
        public static List<T> ToList<T>(this DataTable dt) where T : class,new()
        {
            Type type = typeof(T);
            List<T> list = new List<T>();
            string tempName = string.Empty;
            foreach (DataRow row in dt.Rows)
            {
                PropertyInfo[] pArray = type.GetProperties();
                T entity = new T();
                foreach (PropertyInfo p in pArray)
                {
                    tempName = p.Name;
                    if (dt.Columns.Contains(tempName))
                    {
                        if (!p.CanWrite) continue;
                        object value = row[tempName];
                        if (value != DBNull.Value) p.SetValue(entity, value, null);
                    }
                }
                list.Add(entity);
            }
            return list;
        }
    }
}