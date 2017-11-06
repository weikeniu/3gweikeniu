using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace hotel3g.Models
{
    //public class Img
    //{
    //    public int Id { get; set; }
    //    public string Title { get; set; }
    //    public int ImgNum { get; set; }
    //    public string Url { get; set; }
    //    public string RoomID { get; set; }
    //    public string HotelId { get; set; }
    //    public string SmallUrl { get; set; }
    //    public string BigUrl { get; set; }
    //    public int ImgType { get; set; }
    //    public static List<Img> GetHotelImg(string hotelid)
    //    {
    //        //sql = "SELECT url,title FROM HotelImg WITH(NOLOCK) WHERE hotelID=@Hid"
    //        string sql = @"select * from RoomTypeImg where hotelID=@Hid order by ImgNum desc,id desc";
    //        var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(),
    //            new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "Hid", new HotelCloud.SqlServer.DBParam { ParamValue = hotelid } } });
    //        List<Img> imgs = new List<Img>();
    //        List<string> roomids = new List<string>();
    //        foreach (System.Data.DataRow dr in dt.Rows)
    //        {
    //            if (!roomids.Contains(dr["roomid"].ToString()))
    //            {
    //                roomids.Add(dr["roomid"].ToString());
    //                Img im = new Img();
    //                im.Url = dr["url"].ToString();
    //                im.RoomID = dr["roomid"].ToString();
    //                imgs.Add(im);
    //            }
    //        }
    //        return imgs;
    //    }
    //    /// <summary>
    //    /// 获取酒店外观图片 
    //    /// </summary>
    //    /// <param name="row"></param>
    //    /// <param name="hoteId"></param>
    //    /// <returns></returns>
    //    public static IList<Img> GetHotelImage(int row, int hoteId)
    //    {
    //        string sql = string.Format("select top {0} * from RoomTypeImg where hotelID=@hoteId and imgType=1 order by id desc", row);
    //        DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "hoteId", new HotelCloud.SqlServer.DBParam { ParamValue = hoteId.ToString() } } });
    //        IList<Img> imgs = new List<Img>();
    //        foreach (System.Data.DataRow dr in dt.Rows)
    //        {
    //            Img im = new Img();
    //            im.Url = dr["url"].ToString();
    //            im.SmallUrl = dr["small_url"].ToString();
    //            im.BigUrl = dr["big_url"].ToString();
    //            im.Title = string.Empty;//dr["title"].ToString();
    //            imgs.Add(im);
    //        }
    //        return imgs;
    //    }
    //}
}