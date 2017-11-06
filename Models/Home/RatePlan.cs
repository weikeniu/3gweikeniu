using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace WeiXin.Models.Home
{
    //public class RatePlan
    //{
    //    public int ID { get; set; }
    //    public int HotelID { get; set; }
    //    public int RoomID { get; set; }
    //    public string RatePlanName { get; set; }
    //    public string BedType { get; set; }
    //    public string NetInfo { get; set; }
    //    public string ZaoCan { get; set; }
    //    public int Price1 { get; set; }
    //    public int Price2 { get; set; }
    //    public int Price3 { get; set; }
    //    public int Price4 { get; set; }
    //    public int Price5 { get; set; }
    //    public int Price6 { get; set; }
    //    public int Price7 { get; set; }
    //    public string PayType { get; set; }
    //    public string WarrantCount { get; set; }
    //    public string WarrantTime { get; set; }
    //    public string IsHasCard { get; set; }
    //    public string Discount { get; set; }
    //    public string IsHourRoom { get; set; }
    //    public string HourRoomType { get; set; }
    //    public int StartHour { get; set; }
    //    public int EndHour { get; set; }
    //    public int guarantee_type { get; set; }
    //    public string guarantee_start_time { get; set; }
    //    public string CheckOutTime { get; set; }
    //    public string Guesttype { get; set; }
    //    public int TmallPay { get; set; }
    //    public int CtripPay { get; set; }
    //    public int ElongPay { get; set; }
    //    public int QunarPay { get; set; }
    //    public int IsVip { get; set; }
    //    public int IsFreeroom { get; set; }

    //    private List<Rate> ratelist = new List<Rate>();
    //    public List<Rate> RateList
    //    {
    //        get
    //        {
    //            return ratelist;
    //        }

    //        set
    //        {
    //            ratelist = value;
    //        }
    //    }

    //    private static RatePlan makerateplan(DataRow r)
    //    {
    //        RatePlan rateplan = new RatePlan();
    //        rateplan.ID = Convert.ToInt32(r["id"]);
    //        rateplan.HotelID = Convert.ToInt32(r["hotelid"]);
    //        rateplan.RoomID = Convert.ToInt32(r["roomid"]);
    //        rateplan.BedType = r["bedtype"].ToString();
    //        rateplan.NetInfo = r["netinfo"].ToString();
    //        rateplan.PayType = r["paytype"].ToString();
    //        rateplan.RatePlanName = r["rateplanname"].ToString();
    //        rateplan.IsHourRoom = r["ishourroom"].ToString();
    //        rateplan.HourRoomType = r["HourRoomType"].ToString();
    //        rateplan.ZaoCan = r["zaocan"].ToString();
    //        rateplan.Discount = r["Discount"].ToString();
    //        rateplan.PayType = r["PayType"].ToString();
    //        rateplan.WarrantCount = r["WarrantCount"].ToString();
    //        rateplan.WarrantTime = r["WarrantTime"].ToString();
    //        rateplan.StartHour = WeiXinPublic.ConvertHelper.ToInt(r["StartHour"]);
    //        rateplan.guarantee_start_time = r["guarantee_start_time"].ToString();
    //        rateplan.guarantee_type = WeiXinPublic.ConvertHelper.ToInt(r["guarantee_type"]);
    //        rateplan.CheckOutTime = r["CheckOutTime"].ToString();
    //        rateplan.EndHour = WeiXinPublic.ConvertHelper.ToInt(r["EndHour"]);
    //        rateplan.Guesttype = r["guesttype"].ToString();
    //        rateplan.TmallPay = WeiXinPublic.ConvertHelper.ToInt(r["TmallPay"]);
    //        rateplan.ElongPay = WeiXinPublic.ConvertHelper.ToInt(r["ElongPay"]);
    //        rateplan.CtripPay = WeiXinPublic.ConvertHelper.ToInt(r["CtripPay"]);
    //        rateplan.QunarPay = WeiXinPublic.ConvertHelper.ToInt(r["QunarPay"]);
    //        return rateplan;
    //    }
    //}
}