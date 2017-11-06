using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace hotel3g.Models
{
    public class HotelOrder
    {
        public string memberid { get; set; }
        public int ID { get; set; }
        public string OrderNO { get; set; }
        public string LinkTel { get; set; }
        public string UserName { get; set; }
        public int UserID { get; set; }
        public int HotelID { get; set; }
        public string HotelName { get; set; }
        public string RoomName { get; set; }
        public string RoomID { get; set; }
        public string Demo { get; set; }
        public string RatePlanID { get; set; }
        public string RatePlanName { get; set; }
        public int YRoomNum { get; set; }
        public DateTime YinDate { get; set; }
        public DateTime YoutDate { get; set; }
        public DateTime OrderTime { get; set; }
        public DateTime LastTime { get; set; }
        public string PayType { get; set; }
        public int State { get; set; }
        public string StateName { get; set; }
        public string yPriceStr { get; set; }
        public int ySumPrice { get; set; }
        public int sSumPrice { get; set; }
        public double JiFen { get; set; }
        public string UserWeiXinID { get; set; }
        public string HotelTel { get; set; }
        public string CouponID { get; set; }
        /// <summary>
        /// 网络价
        /// </summary>
        public int NetPrice { get; set; }
        /// <summary>
        /// 实际价格
        /// </summary>
        public int RealPrice { get; set; }
        public int IsHourRoom { get; set; }
        public string HourStartTime { get; set; }
        public string HourEndTime { get; set; }
        public int Days { get; set; }
        public string AliTradeStatus { get; set; }
        public decimal AliPayAmount { get; set; }
        public int Hours { get; set; }
        public int InvoiceState { get; set; }
        public int NeedInvoice { get; set; }
        public string InvoiceTitle { get; set; }
        public string InvoiceNum { get; set; }
        public int Foregift { get; set; }
        public DateTime ConfirmOrderDate { get; set; }
        public decimal RefundFee { get; set; }
        public DateTime AliPayTime { get; set; }
        public string CouponInfo { get; set; }

        public string PayMethod { get; set; }

        public string isMeeting { get; set; }

        public string timeLast { get; set; }

        public static HotelOrder GetOrderInfo(string orderID, string weixinid, string userweixinID)
        {
            string sql = @"select top 1 a.id as did,a.OrderNO,a.RatePlanID,a.Ordertime,a.state,a.RatePlanName,a.UserID,a.RoomID,a.RoomName,a.yRoomNum,a.yinDate,a.youtDate,a.lastTime,a.UserName,a.LinkTel,a.yPriceStr,a.ySumPrice,a.sSumPrice,isnull(a.jifen,0) as jf,a.HotelID,a.NetPrice,a.realprice,a.UserWeiXinID,s.statename,Hotel.Tel,a.PayType,isMeeting from HotelOrder a left join hotelorderstate s on a.state=s.id left join Hotel on Hotel.id=a.HotelID where   a.weixinID=@weixinID and a.userweixinID=@userweixinID and a.id=@orderid";
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"orderid",new HotelCloud.SqlServer.DBParam{ParamValue=orderID}},
             {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
             {"userweixinID",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinID}}
            });
            System.Data.DataRow dr = dt.Rows[0];
            HotelOrder order = new HotelOrder();
            order.ID = Convert.ToInt32(dr["did"].ToString());
            order.OrderNO = dr["OrderNO"].ToString();
            order.OrderTime = Convert.ToDateTime(dr["Ordertime"].ToString());
            order.State = Convert.ToInt32(dr["state"].ToString());
            order.UserID = Convert.ToInt32(dr["UserID"].ToString());
            order.RoomName = dr["RoomName"].ToString();
            order.YRoomNum = Convert.ToInt32(dr["yRoomNum"].ToString());
            order.YinDate = Convert.ToDateTime(dr["yinDate"].ToString());
            order.YoutDate = Convert.ToDateTime(dr["youtDate"].ToString());
            order.LastTime = Convert.ToDateTime(dr["lastTime"].ToString());
            order.UserName = dr["UserName"].ToString();
            order.LinkTel = dr["LinkTel"].ToString();
            order.yPriceStr = dr["yPriceStr"].ToString();
            order.ySumPrice = Convert.ToInt32(dr["ySumPrice"].ToString());
            order.RatePlanName = dr["RatePlanName"].ToString();
            order.HotelID = Convert.ToInt32(dr["HotelID"].ToString());
            order.UserWeiXinID = dr["UserWeiXinID"].ToString();
            order.sSumPrice = Convert.ToInt32(dr["sSumPrice"].ToString());
            order.JiFen = Convert.ToDouble(dr["jf"].ToString());
            order.StateName = dr["statename"].ToString();
            order.HotelTel = dr["tel"].ToString();
            order.RoomID = WeiXinPublic.ConvertHelper.ToInt(dr["RoomID"]).ToString();
            order.RatePlanID = WeiXinPublic.ConvertHelper.ToInt(dr["RatePlanID"]).ToString();
            order.PayType = Convert.ToString(dr["paytype"]);
            order.PayMethod = Convert.ToString(dr["PayMethod"]);
            order.isMeeting = dr["isMeeting"].ToString();
            return order;
        }

    }
}