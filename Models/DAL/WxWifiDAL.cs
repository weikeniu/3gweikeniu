using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using HotelCloud.SqlServer;

namespace hotel3g.Models.DAL
{
    public class WxWifiDAL
    {
        /// <summary>
        /// 获取拥有wifi的门店
        /// </summary>
        /// <returns></returns>
        public DataTable GetHasWifiShops(string hotelWxId)
        {
            string sql = "SELECT * FROM dbo.WxShop WITH(NOLOCK) WHERE HotelWxID = @HotelWxID and ShopID IN (SELECT DISTINCT ShopID FROM dbo.WxWifi WITH(NOLOCK) WHERE State = 1)";
            var dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam> 
            { 
                {"HotelWxID",new DBParam{ParamValue=hotelWxId}}
            });
            return dt;
        }

        /// <summary>
        /// 获取门店的有效的wifi
        /// </summary>
        /// <param name="poiId"></param>
        /// <returns></returns>
        public DataTable GetValidWifis(int shopId)
        {
            string sql = "SELECT * FROM dbo.WxWifi WITH(NOLOCK) WHERE ShopID = @ShopID AND State = 1";
            var dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
                {"ShopID",new DBParam{ParamValue=shopId.ToString()}}
            });
            return dt;
        }

        /// <summary>
        /// 获取门店单个WIFI
        /// </summary>
        /// <returns></returns>
        public DataTable GetWifiById(int id)
        {
            string sql = "SELECT TOP 1 * FROM dbo.WxWifi WITH(NOLOCK) WHERE ID = @ID";
            var dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
                {"ID",new DBParam{ParamValue=id.ToString()}}
            });
            return dt;
        }
    }
}