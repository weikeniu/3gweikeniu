using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using HotelCloud.SqlServer;

namespace hotel3g.Models
{
    public class ShoppingCartService
    {

        /// <summary>
        /// 获取用户购物车信息
        /// </summary>
        /// <param name="HotelId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public DataTable GetDataByUserId(string HotelId, string userweixinID)
        {
            string sql = @"select t.CommodityId,t.Total , c.Name, c.Price, c.ImagePath, c.Stock, c.PurchasePoints, c.CanPurchase, c.CanCouPon, c.ImageList
                              from ShoppingCart_Levi t , Commodity_Levi c
                              where t.CommodityId = c.id
                              and t.HotelId = @HotelId
                              and t.userweixinID = @userweixinID";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"HotelId",new DBParam(){ParamValue=HotelId}},
                        {"userweixinID",new DBParam(){ParamValue=userweixinID}}
                    });

            return dt;
        }

        /// <summary>
        /// 获取用户购物车信息
        /// </summary>
        /// <param name="HotelId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public static DataTable GetData(string HotelId, string userweixinID)
        {
            string sql = @"select t.CommodityId,t.Total 
                              from ShoppingCart_Levi t
                              where 1=1
                              and t.HotelId = @HotelId
                              and t.userweixinID = @userweixinID";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"HotelId",new DBParam(){ParamValue=HotelId}},
                        {"userweixinID",new DBParam(){ParamValue=userweixinID}}
                    });

            return dt;
        }

        /// <summary>
        /// 添加商品到购物车
        /// </summary>
        /// <param name="weixinID"></param>
        /// <param name="userweixinID"></param>
        /// <param name="hotelId"></param>
        /// <param name="CommodityId"></param>
        /// <returns></returns>
        public int AddCommdity(string weixinID, string userweixinID, string hotelId, string CommodityId, int commodityTotal)
        {

            string sql1 = "select TOP 1 Total from ShoppingCart_Levi t where t.HotelId=@HotelId and t.CommodityId=@CommodityId and t.userweixinID=@userweixinID";
            DataTable dt = SQLHelper.Get_DataTable(sql1, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"HotelId",new DBParam(){ParamValue=hotelId}},
                        {"userweixinID",new DBParam(){ParamValue=userweixinID}},
                        {"CommodityId",new DBParam(){ParamValue=CommodityId}}
                    });

            if (dt.Rows.Count > 0)
            {
                lock (this)
                {
                    string sql = @"update [WeiXin].[dbo].[ShoppingCart_Levi] set [Total] = @Total where HotelId=@HotelId and CommodityId=@CommodityId and userweixinID=@userweixinID";

                    int total = (int)dt.Rows[0]["Total"] + commodityTotal;

                    return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"HotelId",new DBParam(){ParamValue=hotelId}},
                        {"CommodityId",new DBParam(){ParamValue=CommodityId}},
                        {"userweixinID",new DBParam(){ParamValue=userweixinID}},
                        {"Total",new DBParam(){ParamValue=total.ToString()}}
                    });
                }
            }
            else
            {
                lock (this)
                {
                    string sql2 = "select TOP 1 Stock from Commodity_Levi t where t.weixinID = @weixinID and t.HotelId=@HotelId and t.id=@CommodityId";
                    DataTable dt2 = SQLHelper.Get_DataTable(sql2, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"HotelId",new DBParam(){ParamValue=hotelId}},
                        {"CommodityId",new DBParam(){ParamValue=CommodityId}},
                        {"weixinID",new DBParam(){ParamValue=weixinID}}
                    });

                    if (dt2.Rows.Count > 0) {
                        if (int.Parse(dt2.Rows[0]["Stock"].ToString()) >= commodityTotal) {


                            string sql = @"INSERT INTO [WeiXin].[dbo].[ShoppingCart_Levi]
                               ([weixinID]
                               ,[userweixinID]
                               ,[HotelId]
                               ,[CommodityId]
                               ,[Total])
                         VALUES
                               (@weixinID
                               ,@userweixinID
                               ,@HotelId
                               ,@CommodityId
                               ,@Total)";

                            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"weixinID",new DBParam(){ParamValue=weixinID}},
                        {"userweixinID",new DBParam(){ParamValue=userweixinID}},
                        {"HotelId",new DBParam(){ParamValue=hotelId}},
                        {"CommodityId",new DBParam(){ParamValue=CommodityId}},
                        {"Total",new DBParam(){ParamValue=commodityTotal.ToString()}}
                    });
                        }
                    }
                }
            }
            return 0;
        }

        /// <summary>
        /// 从购物车中减少商品
        /// </summary>
        /// <param name="weixinID"></param>
        /// <param name="userweixinID"></param>
        /// <param name="hotelId"></param>
        /// <param name="CommodityId"></param>
        /// <returns></returns>
        public int ReduceCommdity(string weixinID, string userweixinID, string hotelId, string CommodityId)
        {

            string sql1 = @"select TOP 1 Total from ShoppingCart_Levi t where t.HotelId=@HotelId and t.CommodityId=@CommodityId and t.userweixinID=@userweixinID";
            DataTable dt = SQLHelper.Get_DataTable(sql1, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"HotelId",new DBParam(){ParamValue=hotelId}},
                        {"userweixinID",new DBParam(){ParamValue=userweixinID}},
                        {"CommodityId",new DBParam(){ParamValue=CommodityId}}
                    });

            if (dt.Rows.Count > 0)
            {
                if ((int)dt.Rows[0]["Total"] > 1)
                {
                    lock (this)
                    {
                        string sql = @"update [WeiXin].[dbo].[ShoppingCart_Levi] set [Total] = @Total where HotelId=@HotelId and CommodityId=@CommodityId and userweixinID=@userweixinID";

                        int total = (int)dt.Rows[0]["Total"] - 1;

                        return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"HotelId",new DBParam(){ParamValue=hotelId}},
                        {"CommodityId",new DBParam(){ParamValue=CommodityId}},
                        {"userweixinID",new DBParam(){ParamValue=userweixinID}},
                        {"Total",new DBParam(){ParamValue=total.ToString()}}
                    });
                    }
                }
                else
                {
                    return DeleteCommdity(weixinID, userweixinID, hotelId, CommodityId); ;
                }
            }
            else
            {
                return 0;
            }
        }

        /// <summary>
        /// 从购物车中删除商品
        /// </summary>
        /// <param name="weixinID"></param>
        /// <param name="userweixinID"></param>
        /// <param name="hotelId"></param>
        /// <param name="CommodityId"></param>
        /// <returns></returns>
        public int DeleteCommdity(string weixinID, string userweixinID, string hotelId, string CommodityId)
        {
            lock (this)
            {
                string sql = @"delete [WeiXin].[dbo].[ShoppingCart_Levi] where HotelId=@HotelId and CommodityId=@CommodityId and userweixinID=@userweixinID";

                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"HotelId",new DBParam(){ParamValue=hotelId}},
                        {"CommodityId",new DBParam(){ParamValue=CommodityId}},
                        {"userweixinID",new DBParam(){ParamValue=userweixinID}}
                    });
            }
        }

        /// <summary>
        /// 从购物车中清空商品
        /// </summary>
        /// <param name="weixinID"></param>
        /// <param name="userweixinID"></param>
        /// <param name="hotelId"></param>
        /// <param name="CommodityId"></param>
        /// <returns></returns>
        public int ClearCommdity(string weixinID, string userweixinID, string hotelId)
        {
            lock (this)
            {
                string sql = @"delete [WeiXin].[dbo].[ShoppingCart_Levi] where HotelId=@HotelId and userweixinID=@userweixinID";

                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"HotelId",new DBParam(){ParamValue=hotelId}},
                        {"userweixinID",new DBParam(){ParamValue=userweixinID}}
                    });
            }
        }
    }
}