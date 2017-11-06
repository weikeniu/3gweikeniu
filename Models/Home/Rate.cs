using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace WeiXin.Models.Home
{
    //public class Rate
    //{
    //    public int HotelID { get; set; }
    //    public int RatePlanID { get; set; }
    //    public string Dates { get; set; }
    //    public int Price { get; set; }
    //    public int Available { get; set; }

    //    public int CtripPrice { get; set; }
    //    public int CtripSalePrice { get; set; }
    //    public int ElongPrice { get; set; }
    //    public int ElongSalePrice { get; set; }
    //    public int QunarPrice { get; set; }
    //    public int QunarSalePrice { get; set; }
    //    public int TmallPrice { get; set; }
    //    public int TmallSalePrice { get; set; }

    //    public int CtripState { get; set; }
    //    public int ElongState { get; set; }
    //    public int QunarState { get; set; }
    //    public int TmallState { get; set; }

    //    public static Rate MakeRate(DataRow r)
    //    {
    //        Rate rate = new Rate();
    //        rate.Dates = Convert.ToDateTime(r["Dates"].ToString()).ToString("yyyy-MM-dd");

    //        rate.Available = WeiXinPublic.ConvertHelper.ToInt(r["Available"]);
    //        rate.Price = WeiXinPublic.ConvertHelper.ToInt(r["price"]);

    //        rate.CtripPrice = WeiXinPublic.ConvertHelper.ToInt(r["CtripPrice"]);
    //        rate.CtripSalePrice = WeiXinPublic.ConvertHelper.ToInt(r["CtripSalePrice"]);
    //        rate.ElongPrice = WeiXinPublic.ConvertHelper.ToInt(r["ElongPrice"]);
    //        rate.ElongSalePrice = WeiXinPublic.ConvertHelper.ToInt(r["ElongSalePrice"]);
    //        rate.QunarPrice = WeiXinPublic.ConvertHelper.ToInt(r["QunarPrice"]);
    //        rate.QunarSalePrice = WeiXinPublic.ConvertHelper.ToInt(r["QunarSalePrice"]);
    //        rate.TmallPrice = WeiXinPublic.ConvertHelper.ToInt(r["TmallPrice"]);
    //        rate.TmallSalePrice = WeiXinPublic.ConvertHelper.ToInt(r["TmallSalePrice"]);

    //        rate.CtripState = WeiXinPublic.ConvertHelper.ToInt(r["CtripState"]);
    //        rate.ElongState = WeiXinPublic.ConvertHelper.ToInt(r["ElongState"]);
    //        rate.QunarState = WeiXinPublic.ConvertHelper.ToInt(r["QunarState"]);
    //        rate.TmallState = WeiXinPublic.ConvertHelper.ToInt(r["TmallState"]);

    //        return rate;
    //    }
    //}
}