using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using HotelCloud.SqlServer;

namespace WeiXin.Models.Home
{
    //public class Room
    //{
    //    public int ID { get; set; }
    //    public int HotelID { get; set; }
    //    public string RoomName { get; set; }
    //    public string Img { get; set; }
    //    public string BedArea { get; set; }
    //    public string Area { get; set; }
    //    public string Floor { get; set; }
    //    public string NetType { get; set; }
    //    public string Remark { get; set; }
    //    public string BedType { get; set; }
    //    public string Window { get; set; }
    //    public string ConPons { get; set; }
    //    public string GiftConPon { get; set; }
    //    public int IsChildRoom { get; set; }
    //    public string RatePlanID { get; set; }
    //    public string Enable { get; set; }
    //    public string Breakfast { get; set; }
    //    public string AddBed { get; set; }
    //    public string RoomTypeId { get; set; }
    //    public string RoomTypeName { get; set; }
    //    public string Veranda { get; set; }
    //    public string Bathroom { get; set; }
    //    public string Aircon { get; set; }
    //    public string Hotwater { get; set; }
    //    public int Foregift { get; set; }

    //    private static Room makeroom(DataRow r)
    //    {
    //        Room room = new Room();
    //        room.ID = Convert.ToInt32(r["id"]);
    //        room.HotelID = Convert.ToInt32(r["hotelid"]);
    //        room.Area = r["area"].ToString();
    //        room.BedArea = r["bedarea"].ToString();
    //        room.BedType = r["bedtype"].ToString();
    //        room.Floor = r["floor"].ToString();
    //        room.Img = r["img"].ToString();
    //        room.NetType = r["nettype"].ToString();
    //        room.Remark = r["remark"].ToString();
    //        room.RoomName = r["roomName"].ToString();
    //        room.AddBed = r["AddBed"].ToString();
    //        room.Window = r["WindowType"].ToString();
    //        room.Enable = r["Enabled"].ToString();
    //        room.ConPons = WeiXinPublic.ConvertHelper.ToString(r["ConPons"]);
    //        room.GiftConPon = WeiXinPublic.ConvertHelper.ToString(r["GiftConPon"]);
    //        room.IsChildRoom = WeiXinPublic.ConvertHelper.ToInt(r["IsChildRoom"]);
    //        room.Bathroom = r["Bathroom"].ToString();
    //        room.Aircon = r["Aircon"].ToString();
    //        room.Hotwater = r["Hotwater"].ToString();
    //        room.Veranda = r["Veranda"].ToString();
    //        return room;
    //    }

    //    private List<RatePlan> rateplanlist = new List<RatePlan>();
    //    public List<RatePlan> RateplanList
    //    {
    //        get
    //        {
    //            return rateplanlist;
    //        }
    //        set
    //        {
    //            rateplanlist = value;
    //        }
    //    }
    //}
}