using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using HotelCloud.SqlServer;

namespace hotel3g.Models
{
    public class SupermarketOrderDetailService
    {
        /// <summary>
        /// 根据工单ID获取数据
        /// </summary>
        /// <param name="orderId"></param>
        /// <returns></returns>
        public static DataTable GetDataByOrderId(string orderId)
        {
//            string sql = @"
//                            select t.OrderId, t.weixinID, t.HotelId, t.CommodityId, t.Total,
//                              c.Price, c.Name, c.ImagePath, c.PurchasePoints, c.CanPurchase, c.ImageList
//                              from SupermarketOrderDetail_Levi t , Commodity_Levi c 
//                              where t.CommodityId = c.id and t.OrderId=@OrderId
//                        ";
            string sql = @"
                            select t.OrderId, t.weixinID, t.HotelId, t.CommodityId, t.Total,
                              t.Price, t.Name, t.ImagePath, ISNULL(t.PurchasePoints,0) as PurchasePoints, ISNULL(t.CanPurchase,0) as CanPurchase, t.ImageList
                              from SupermarketOrderDetail_Levi t
                              where t.OrderId=@OrderId
                        ";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"OrderId",new DBParam(){ParamValue=orderId}}
                    });

            return dt;
        }

        /// <summary>
        /// 获取商品已售数量
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static DataTable GetSoldCount(string id)
        {
            string sql = @"
                            
                  select sum(d.Total) from SupermarketOrderDetail_Levi d with(nolock),SupermarketOrder_Levi t with(nolock)
                    where d.OrderId =t.OrderId and t.OrderStatus = 4 and CommodityId=@id
                        ";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"id",new DBParam(){ParamValue=id}}
                    });

            return dt;
        }
    }
}