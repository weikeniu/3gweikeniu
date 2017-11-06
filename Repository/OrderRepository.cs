using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using hotel3g.Common;
using HotelHotel.Utility;

namespace hotel3g.Repository
{
    public class OrderRepository
    {
        private const string tableName = "HotelOrder";

        public static Order GetOrderByCode(string code, string wx)
        {
            Order order = null;
            string sql = string.Format(@"select top 1 id,OrderNO,HotelID,HotelName,RoomID,RoomName,RatePlanID,RatePlanName,Remark,LinkTel,UserName,UserWeiXinID,WeiXinID,
            PayType,lastTime,state,PayType,
            yRoomNum,yinDate,youtDate,ySumPrice,NetPrice,realprice from HotelOrder where OrderNO='{0}' and UserWeiXinID='{1}'", code, wx);

            HotelHotel.Utility.SqlWrapper.ExecuteReader(GlobalConfig.ConnStr, sql, (r) =>
            {
                while (r.Read())
                {
                    order = Order.Assembly(r);
                    break;
                }
            });
            return order;
        }

        public static Order GetOrderInfo(int orderId)
        {
            Order order = null;
            string sql = string.Format(@"select id,OrderNO,HotelID,HotelName,RoomID,RoomName,RatePlanID,RatePlanName,Remark,LinkTel,UserName,UserWeiXinID,WeiXinID,
            PayType,lastTime,state,
            yRoomNum,yinDate,youtDate,ySumPrice,NetPrice,realprice from HotelOrder where id={0}", orderId);

            HotelHotel.Utility.SqlWrapper.ExecuteReader(GlobalConfig.ConnStr, sql, (r) =>
            {
                while (r.Read())
                {
                    order = Order.Assembly(r);
                }
            });
            return order;
        }
        public static Order GetOrderInfo(string OrderNO)
        {
            Order order = null;
            string sql = string.Format(@"select id,OrderNO,HotelID,HotelName,RoomID,RoomName,RatePlanID,RatePlanName,Remark,LinkTel,UserName,UserWeiXinID,WeiXinID,
            PayType,lastTime,state,
            yRoomNum,yinDate,youtDate,ySumPrice,NetPrice,realprice,sSumPrice from HotelOrder where OrderNO='{0}'", OrderNO);

            HotelHotel.Utility.SqlWrapper.ExecuteReader(GlobalConfig.ConnStr, sql, (r) =>
            {
                while (r.Read())
                {
                    order = Order.Assembly(r);
                }
            });
            return order;
        }

        /// <summary>
        /// 保存支付订单信息
        /// </summary>
        /// <param name="order"></param>
        /// <returns></returns>
        public static bool SaveAliPayOrder(Order order)
        {
            HotelHotel.Utility.Sql.UpdateScript script = new HotelHotel.Utility.Sql.UpdateScript(tableName);
            if (!string.IsNullOrEmpty(order.TradeStatus))
            {
                script.AddParams("tradeStatus", order.TradeStatus);
            }
            if (!string.IsNullOrEmpty(order.TradeNo))
            {
                script.AddParams("tradeNo", order.TradeNo);
            }
            if (order.TradeAlipayAmount > 0)
            {
                script.AddParams("aliPayAmount", order.TradeAlipayAmount);
            }
            script.AddParams("aliPayTime", order.AlipayTime)
                  .AddParams("state", order.State)
                  .AddParams("Remark", order.Remark)
                  .AddCriteria("id", order.Id);
            int row = SqlWrapper.ExecuteNonQuery(GlobalConfig.ConnStr, script.Execute());
            if (row > 0)
            {
                return true;
            }
            return false;
        }
    }

    [Serializable]
    public class Order
    {
        public int Id { get; set; }
        public string OrderNo { get; set; }
        public string LinkTel { get; set; }
        public string UserName { get; set; }
        public int UserID { get; set; }
        public string LinkUserName { get; set; }
        public string Tel { get; set; }
        public string Request { get; set; }


        public int HotelID { get; set; }
        public string HotelName { get; set; }
        public int RoomID { get; set; }
        public string RoomName { get; set; }
        public int RatePlanID { get; set; }
        public string RatePlanName { get; set; }

        public int RoomNum { get; set; }
        public string ComeDate { get; set; }
        public string LeaveDate { get; set; }
        public string OrderTime { get; set; }

        public string PayType { get; set; }
        public string EarilyTime { get; set; }
        public string LastTime { get; set; }
        public string PriceStr { get; set; }
        public int SumPrice { get; set; }

        public int State { get; set; }
        public string StateName { get; set; }


        public int RoomCount { get; set; }
        public string InDate { get; set; }
        public string OutDate { get; set; }
        public string SPriceStr { get; set; }
        /// <summary>
        /// 实际金额
        /// </summary>
        public int OrderAmount { get; set; }

        public int PriceOrderWay { get; set; }

        public string Remark { get; set; }
        public string HotelAddress { get; set; }

        /// <summary>
        /// 支付宝交易号
        /// </summary>
        public string TradeNo { get; set; }
        /// <summary>
        /// 支付宝交易金额
        /// </summary>
        public decimal TradeAlipayAmount { get; set; }
        /// <summary>
        /// 支付宝交易时间
        /// </summary>
        public string AlipayTime { get; set; }
        /// <summary>
        /// 支付宝交易状态
        /// </summary>
        public string TradeStatus { get; set; }

        public string WeiXinID { get; set; }

        public string UserWeiXinID { get; set; }

        internal static Order Assembly(System.Data.IDataReader r)
        {
            Order order = new Order();
            order.Id = Convert.ToInt32(r["id"]);
            order.OrderNo = Convert.ToString(r["OrderNO"]);
            order.LinkTel = Convert.ToString(r["LinkTel"]);
            order.UserName = Convert.ToString(r["UserName"]);
            //order.UserID = Convert.ToInt32(r["UserID"]);
            order.HotelID = Convert.ToInt32(r["HotelID"]);
            order.HotelName = Convert.ToString(r["HotelName"]);
            order.RoomID = Convert.ToInt32(r["RoomID"]);
            order.RoomName = Convert.ToString(r["RoomName"]);
            //order.Request = Convert.ToString(r["demo"]);
            order.RatePlanID = Convert.ToInt32(r["RatePlanID"]);
            order.RatePlanName = Convert.ToString(r["RatePlanName"]);
            order.RoomNum = Convert.ToInt32(r["yRoomNum"]);
            order.ComeDate = Convert.ToDateTime(r["yinDate"]).ToString("yyyy-MM-dd");
            order.LeaveDate = Convert.ToDateTime(r["youtDate"]).ToString("yyyy-MM-dd");
            //order.OrderTime = Convert.ToDateTime(r["Ordertime"]).ToString("yyyy-MM-dd HH:mm:ss");
            order.PayType = Convert.ToString(r["PayType"]);
            //order.EarilyTime = r.IsDBNull(r.GetOrdinal("earilytime")) == true ? "" : Convert.ToString(r["earilytime"]);
            order.LastTime = Convert.ToString(r["lastTime"]);
            order.State = Convert.ToInt32(r["state"]);
            //order.PriceStr = Convert.ToString(r["yPriceStr"]);
            order.SumPrice = Convert.ToInt32(r["ySumPrice"]);
            order.Remark = r.IsDBNull(r.GetOrdinal("Remark")) ? string.Empty : Convert.ToString(r["Remark"]);
            //order.RoomCount = Convert.ToInt32(r["sRoomNum"]);
            //order.InDate = Convert.ToDateTime(r["sinDate"]).ToString("yyyy-MM-dd");
            //order.OutDate = Convert.ToDateTime(r["soutDate"]).ToString("yyyy-MM-dd");
            //order.SPriceStr = Convert.ToString(r["sPriceStr"]);
            order.OrderAmount = Convert.ToInt32(r["sSumPrice"]);

            //order.LinkUserName = Convert.ToString(r["LinkUserName"]);
            //order.Tel = Convert.ToString(r["Tel"]);
            //order.PriceOrderWay = Convert.ToInt32(r["PriceOrderWay"]);
            //order.StateName = Convert.ToString(r["StateTypeName"]);
            order.WeiXinID = r.IsDBNull(r.GetOrdinal("WeiXinID")) ? string.Empty : Convert.ToString(r["WeiXinID"]);
            order.UserWeiXinID = r.IsDBNull(r.GetOrdinal("UserWeiXinID")) ? string.Empty : Convert.ToString(r["UserWeiXinID"]);
            //order.TradeNo = r.IsDBNull(r.GetOrdinal("tradeNo")) ? string.Empty : r["tradeNo"].ToString();
            //order.TradeAlipayAmount = Convert.ToDecimal(r["aliPayAmount"]);
            //order.TradeStatus = r.IsDBNull(r.GetOrdinal("tradeStatus")) ? string.Empty : r["tradeStatus"].ToString();
            //order.AlipayTime = r.IsDBNull(r.GetOrdinal("aliPayTime")) ? string.Empty : Convert.ToDateTime(r["aliPayTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
            //order.UnionUserNo = r.IsDBNull(r.GetOrdinal("unionUserNo")) ? string.Empty : r["unionUserNo"].ToString();

            //order.StateName = PDS.Common.StatusMappingManage.GetShowStatus(order.State);
            return order;
        }
    }
}