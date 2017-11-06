using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using HotelCloud.SqlServer;

namespace hotel3g.Models.DAL
{
    /// <summary>
    /// 旅行社酒店DAL
    /// </summary>
    public class TravelAgencyHotelDAL
    {
        /// <summary>
        /// 获取酒店搜索结果
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="dic"></param>
        /// <returns></returns>
        public DataTable GetHotelSeachRes(string sql, Dictionary<string, string> dic) 
        {
            var dbParams = new Dictionary<string, DBParam>();
            if (sql.Contains("@CityID"))
                dbParams.Add("CityID", new DBParam { ParamValue = dic["CityID"] });
            if(sql.Contains("@HotelWxId"))
                dbParams.Add("HotelWxId", new DBParam { ParamValue = dic["HotelWxId"] });
            if (sql.Contains("@KeyWord"))
                dbParams.Add("KeyWord", new DBParam { ParamValue = dic["KeyWord"] });
            if (sql.Contains("@KeyWordID"))
                dbParams.Add("KeyWordID", new DBParam { ParamValue = dic["KeyWordID"] });
            var dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), dbParams);
            return dt == null ? new DataTable() : dt;
        }

        /// <summary>
        /// 获取该酒店下审核通过的所有分店
        /// </summary>
        /// <param name="hotelWxId"></param>
        /// <returns></returns>
        public DataTable GetAuditPassHotels(string hotelWxId) 
        {
            if (Models.DAL.AuthorityHelper.ModuleAuthority(hotelWxId).examine == 0) return new DataTable();
            string sql = "SELECT * FROM dbo.Hotel WITH(NOLOCK) WHERE WeiXinID = @HotelWxId";
            var dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { { "HotelWxId", new DBParam { ParamValue = hotelWxId } } });
            return dt == null ? new DataTable() : dt;
        }

        /// <summary>
        /// 获取该酒店下分店最多的城市
        /// </summary>
        /// <param name="hotelWxId"></param>
        /// <returns></returns>
        public DataTable GetSumTopCityForHotel(string hotelWxId) 
        {
            string sql = "SELECT * FROM dbo.CityInfo WITH(NOLOCK) WHERE id = (SELECT TOP 1 cid FROM dbo.Hotel WITH(NOLOCK) WHERE WeiXinID = @HotelWxId  GROUP BY cid ORDER BY COUNT(1) DESC)";
            var dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { { "HotelWxId", new DBParam { ParamValue = hotelWxId } } });
            return dt == null ? new DataTable() : dt;
        }

        /// <summary>
        /// 获取多个酒店最近的预订时间
        /// </summary>
        /// <param name="hotelId"></param>
        /// <returns></returns>
        public DataTable GetHotelsLastOrderTime(List<int> hotelIds) 
        {
            string sql = string.Format(@"SELECT MAX(OrderTime) AS OrderTime,a.HotelID FROM dbo.HotelOrder a WITH(NOLOCK) WHERE a.HotelID IN ({0}) GROUP BY a.HotelID", string.Join(",", hotelIds));
            var dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>());
            return dt == null ? new DataTable() : dt;
        }

        /// <summary>
        ///获取多个酒店红包数量
        /// </summary>
        /// <param name="hotelIds"></param>
        /// <returns></returns>
        public DataTable GetHotelsCouponCount(List<int> hotelIds) 
        {
            string sql = string.Format(@"select HotelId,Coupon from dbo.wkn_StatisticsCount WITH(NOLOCK) WHERE HotelId in ({0})",string.Join(",",hotelIds));
            var dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>());
            return dt == null ? new DataTable() : dt;
        }

        /// <summary>
        /// 获取多个酒店是否有钟点房
        /// </summary>
        /// <param name="hotelIds"></param>
        /// <returns></returns>
        public DataTable GetHotelHasHourRoom(List<int> hotelIds) 
        {
            string sql = string.Format(@"SELECT DISTINCT HotelID FROM dbo.HotelRatePlan WITH(NOLOCK) WHERE IsHourRoom = 1 AND HotelID IN ({0})",string.Join(",",hotelIds));
            var dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>());
            return dt == null ? new DataTable() : dt;
        }

        /// <summary>
        /// 获取该酒店下所有分店的品牌、商圈、行政区的条件数据
        /// </summary>
        /// <returns></returns>
        public DataTable GetHasHotelCdtData(string hotelWxId) 
        {
            var cityIDs = new List<int>();var areaIDs = new List<int>();
            var chainIDs = new List<int>();var tradingAreaIDs = new List<int>();
            foreach (DataRow r in GetAuditPassHotels(hotelWxId).Rows)
            {
                cityIDs.Add((r["cid"] != DBNull.Value ? Convert.ToInt32(r["cid"]) : 0));
                areaIDs.Add((r["rid"] != DBNull.Value ? Convert.ToInt32(r["rid"]) : 0));
                chainIDs.Add((r["chainID"] != DBNull.Value ? Convert.ToInt32(r["chainID"]) : 0));
                tradingAreaIDs.Add((r["TradingAreaID"] != DBNull.Value ? Convert.ToInt32(r["TradingAreaID"]) : 0));
            }
            var cityJoin = string.Join(",", cityIDs.Distinct().ToList());
            var areaJoin = string.Join(",", areaIDs.Distinct().ToList());
            var chainJoin = string.Join(",", chainIDs.Distinct().ToList());
            var tradingAreaJoin = string.Join(",", tradingAreaIDs.Where(m => m > 0).Distinct().ToList());
            var sql = string.Format(@"SELECT DISTINCT 1 as cdtType,id,city AS name FROM dbo.CityInfo WITH(NOLOCK) WHERE id IN ({0})--城市
UNION ALL
SELECT DISTINCT 2 AS cdtType,id,name FROM dbo.RegionInfo WITH(NOLOCK) WHERE id IN ({1})--行政区
UNION ALL 
SELECT DISTINCT 3 AS cdtType,id,chain_name AS name FROM dbo.ChainInfo WITH(NOLOCK) WHERE id IN ({2}) --品牌
UNION ALL 
SELECT DISTINCT 4 AS cdtType,id,jdwz_name AS name FROM dbo.jdwz WITH(NOLOCK) WHERE id IN ({3})-- 商圈", cityJoin, areaJoin, chainJoin, tradingAreaJoin);
            var dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>());
            return dt;
        }
    }
}