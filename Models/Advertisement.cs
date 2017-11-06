using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using WeiXinPublic;

namespace hotel3g.Models
{
    /// <summary>
    /// 广告管理
    /// </summary>
    public class Advertisement
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string ImageUrl { get; set; }
        public string LinkUrl { get; set; }

        public static IList<Advertisement> GetAdvertisementBySort(string weiXinId, int sort = 0)
        {

            IList<Advertisement> list = new List<Advertisement>();

            string sql = "select adId,adName,adUrl,adImage from advertisement with(nolock) where weixinId=@weixinId";
            if (sort >= 0)
            {
                sql = "select adId,adName,adUrl,adImage from advertisement with(nolock) where weixinId=@weixinId  and sort=@sort";
            }

            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinId}},
             {"sort",new HotelCloud.SqlServer.DBParam{ParamValue=sort.ToString()}}
            });
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    Advertisement ad = new Advertisement();
                    ad.Id = ConvertHelper.ToInt(row["adId"]);
                    ad.Name = ConvertHelper.ToString(row["adName"]);
                    ad.LinkUrl = ConvertHelper.ToString(row["adUrl"]);
                    ad.ImageUrl = ConvertHelper.ToString(row["adImage"]);
                    list.Add(ad);
                }
            }
            return list;
        }


        public static IList<Advertisement> GetAdvertisement(string weiXinId)
        {
            IList<Advertisement> list = new List<Advertisement>();

            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select adId,adName,adUrl,adImage from advertisement with(nolock) where weixinId=@weixinId", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinId}}
            });
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    Advertisement ad = new Advertisement();
                    ad.Id = ConvertHelper.ToInt(row["adId"]);
                    ad.Name = ConvertHelper.ToString(row["adName"]);
                    ad.LinkUrl = ConvertHelper.ToString(row["adUrl"]);
                    ad.ImageUrl = ConvertHelper.ToString(row["adImage"]);
                    list.Add(ad);
                }
            }
            return list;
        }
    }
}