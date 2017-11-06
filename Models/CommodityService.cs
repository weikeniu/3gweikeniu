using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using HotelCloud.SqlServer;
using System.Text;
using WeiXin.Common;
using hotel3g.Common;

namespace hotel3g.Models
{
    /// <summary>
    /// 超市商品服务类
    /// </summary>
    public class CommodityService
    {

        /// <summary>
        /// 获取商家菜品类型
        /// </summary>
        /// <param name="StoreId">商家id</param>
        /// <returns></returns>
        public static DataTable GetDataByHotelId(string HotelId)
        {
            string sql = @"select id, Name, Price, Tip, Stock, ImagePath, Describe, PurchasePoints, CanPurchase from Commodity_Levi t where t.HotelId=@HotelId order by Sequence";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"HotelId",new DBParam(){ParamValue=HotelId}}
                    });

            return dt;
        }

        /// <summary>
        /// 获取商品
        /// </summary>
        /// <param name="StoreId">商品id</param>
        /// <returns></returns>
        public static DataTable GetDataById(string Id)
        {
            string sql = @"select top 1 id, Name, Price, Tip, Stock, ImagePath, Describe, PurchasePoints, CanPurchase, CanCouPon, ImageList, Notice, ITDescribe,NoticeApplet,ImageListApplet, UseRichText from Commodity_Levi t where t.id=@Id order by Sequence";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"Id",new DBParam(){ParamValue=Id}}
                    });

            return dt;
        }

        /// <summary>
        /// 根据用户id获取商家菜品类型
        /// </summary>
        /// <param name="HotelId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public static DataTable GetDataByUserId(string HotelId, string userId)
        {
            string sql = @"select id, Name, Price, Tip, Stock, ImagePath, ImageList, Describe, PurchasePoints, CanPurchase, UseRichText,CommodityType,Subitem,
                           (select Total from ShoppingCart_Levi s where s.HotelId=@HotelId and s.userweixinID=@userweixinID and s.CommodityId = t.id) as Total
                           from Commodity_Levi t 
                           where t.HotelId=@HotelId
                            and t.Enabled = 1
                           order by case when Stock=0 then 9999999 else Sequence end";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"HotelId",new DBParam(){ParamValue=HotelId}},
                        {"userweixinID",new DBParam(){ParamValue=userId}}
                    });

            return dt;
        }

        /// <summary>
        /// 根据用户id获取商家菜品类型
        /// </summary>
        /// <param name="HotelId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public static DataTable GetDataByUserId(string weixinId ,string HotelId, string userId)
        {
            string sql = @"select id, Name, Price, Tip, Stock, ImagePath, ImageList, Describe, PurchasePoints, CanPurchase, UseRichText,CommodityType,Subitem,
                           (select Total from ShoppingCart_Levi s where s.HotelId=@HotelId and s.userweixinID=@userweixinID and s.CommodityId = t.id) as Total
                           from Commodity_Levi t 
                           where weixinID = @weixinID
                            and t.HotelId=@HotelId
                            and t.Enabled = 1
                           order by case when Stock=0 then 9999999 else Sequence end";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"weixinID",new DBParam(){ParamValue=weixinId}},
                        {"HotelId",new DBParam(){ParamValue=HotelId}},
                        {"userweixinID",new DBParam(){ParamValue=userId}}
                    });

            return dt;
        }

        /// <summary>
        /// 获取商城产品列表
        /// </summary>
        /// <param name="keyword">搜索关键字</param>
        /// <param name="curpage">当前页</param>
        /// <param name="pageNum">总页数</param>
        /// <returns></returns>
        public static DataTable GetCommodityList(string sort, string keyword, string type, string price, string subitem, string selectCity, string cityName, int curpage, string weixinid, string hid, bool isUseHotelId, int pagesize = 6)
        {
            curpage = curpage > 0 ? curpage - 1 : 0;
            string where = string.Empty;
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            where += " where c.weixinID=@weixinID and c.UseRichText = 1 ";
            Dic.Add("weixinID", new DBParam { ParamValue = weixinid });

            if (isUseHotelId)
            {
                where += " AND c.HotelId=@HotelId ";
            }
            else
            {
                //where += " AND c.HotelId = 0 ";
            }
            Dic.Add("HotelId", new DBParam { ParamValue = hid.ToString() });

            if (!string.IsNullOrEmpty(keyword))
            {
                where += " AND CHARINDEX(@Name,c.Name)>0 ";
                Dic.Add("Name", new DBParam { ParamValue = keyword });
            }

            if (!string.IsNullOrEmpty(type))
            {
                //where += " AND CHARINDEX(@CommodityType,CommodityType)>0 ";
                where += " AND c.CommodityType = @CommodityType";
                Dic.Add("CommodityType", new DBParam { ParamValue = type });
            }

            if (!string.IsNullOrEmpty(subitem))
            {
                where += " AND (CHARINDEX(c.Subitem, @Subitem)>0 or CHARINDEX(c.CommodityType, @Subitem)>0 ) ";
                Dic.Add("Subitem", new DBParam { ParamValue = subitem });
            }

            if (!string.IsNullOrEmpty(price))
            {
                var arr = price.Split(',');
                where += " AND c.Price>=@price1 and  c.Price<=@price2";
                Dic.Add("price1", new DBParam { ParamValue = arr[0] });
                Dic.Add("price2", new DBParam { ParamValue = arr[1] });
            }

            if (!string.IsNullOrWhiteSpace(cityName))
            {
                //where += " AND CHARINDEX((select city from CityInfo ci where ci.id = c.Cid), @cityName)>0 ";
                where += " AND ( CHARINDEX((select city from CityInfo ci where ci.id = c.Cid), @cityName)>0 or CHARINDEX(city, @cityName)>0 )";
                Dic.Add("cityName", new DBParam { ParamValue = cityName });
            }

            string sql_pos = "";
            if (!string.IsNullOrWhiteSpace(selectCity))
            {
                sql_pos = "case when c.pos is not null and c.pos !='' then dbo.fnGetDistance(LEFT(c.pos, CHARINDEX(',',c.pos) - 1),SUBSTRING(c.pos, CHARINDEX(',',c.pos)+1,len(c.pos)),'" + selectCity.Split(',')[0] + "','" + selectCity.Split(',')[1] + "') else 800 end as pos2,";
            }

            if (sort == "推荐排序")
            {
                sort = "ORDER BY  case when Stock=0 then 9999999 else Sequence end";
            }
            else if (sort == "距离优先")
            {
                if (!string.IsNullOrWhiteSpace(selectCity))
                {
                    sort = "ORDER BY case when Stock=0 then 9999999 else pos2 end ";
                }
                else
                {
                    sort = "ORDER BY case when Stock=0 then 9999999 else Sequence end";
                }
            }
            else if (sort == "低价优先")
            {
                sort = "ORDER BY case when Stock=0 then 9999999 else Price end ";
            }
            else if (sort == "高价优先")
            {
                sort = "ORDER BY case when Stock=0 then 9999999 else Price end desc";
            }
            else if (sort == "星级优先")
            {
                sort = "ORDER BY case when Stock=0 then 9999999 else Sequence end";
            }
            else
            {
                sort = "ORDER BY case when Stock=0 then 9999999 else Sequence end";
            }

            string sql = string.Format(@"select TOP 6  * from (
                SELECT ROW_NUMBER() OVER(" + sort + @") AS row,* FROM (
                SELECT  c.id,c.weixinID,c.HotelId,c.Name," + sql_pos + @"c.CommodityType,c.Price,c.Tip,c.Stock,c.ImagePath ,c.ImageList,c.Notice,c.ITDescribe,c.Describe,c.Sequence,c.CreateTime,c.CreateUser,c.EditTime ,c.CanPurchase,c.PurchasePoints,
                (select name from CommodityType_Levi where id= CommodityType) CommodityTypeName,
                c.EditUser,c.Enabled,city.city,h.SubName
                FROM dbo.Commodity_Levi c WITH(NOLOCK)
                left join Hotel h WITH(NOLOCK) on c.HotelId = h.id
                left join CityInfo city WITH(NOLOCK) on h.cid = city.id
                {0}
                )AS t) as tt WHERE tt.row>{1}", where, curpage * pagesize);

            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);
            return dt;
        }

        /// <summary>
        /// 获取商城产品列表
        /// </summary>
        /// <param name="keyword">搜索关键字</param>
        /// <param name="curpage">当前页</param>
        /// <param name="pageNum">总页数</param>
        /// <returns></returns>
        public static DataTable GetCommodityListMain(string sort, string keyword, string type, string price, string subitem, string selectCity,string cityName, int curpage, string weixinid, string hid, bool isUseHotelId, ref int dataCount, int pagesize = 6)
        {
            curpage = curpage > 0 ? curpage - 1 : 0;
            string where = string.Empty;
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            where += " where c.weixinID=@weixinID  ";//and c.UseRichText = 1
            Dic.Add("weixinID", new DBParam { ParamValue = weixinid });

            if (isUseHotelId)
            {
                where += " AND c.HotelId=@HotelId ";
            }
            else
            {
                //where += " AND c.HotelId = 0 ";
            }
            Dic.Add("HotelId", new DBParam { ParamValue = hid.ToString() });

            if (!string.IsNullOrEmpty(keyword))
            {
                where += " AND CHARINDEX(@Name,c.Name)>0 ";
                Dic.Add("Name", new DBParam { ParamValue = keyword });
            }

            if (!string.IsNullOrEmpty(type))
            {
                //where += " AND CHARINDEX(@CommodityType,CommodityType)>0 ";
                where += " AND c.CommodityType = @CommodityType";
                Dic.Add("CommodityType", new DBParam { ParamValue = type });
            }

            if (!string.IsNullOrEmpty(subitem))
            {
                where += " AND (CHARINDEX(c.Subitem, @Subitem)>0 or CHARINDEX(c.CommodityType, @Subitem)>0 ) ";
                Dic.Add("Subitem", new DBParam { ParamValue = subitem });
            }

            if (!string.IsNullOrEmpty(price))
            {
                var arr = price.Split(',');
                where += " AND c.Price>=@price1 and  c.Price<=@price2";
                Dic.Add("price1", new DBParam { ParamValue = arr[0] });
                Dic.Add("price2", new DBParam { ParamValue = arr[1] });
            }

            if (!string.IsNullOrWhiteSpace(cityName))
            {
                //where += " AND CHARINDEX((select city from CityInfo ci where ci.id = c.Cid), @cityName)>0 ";
                where += " AND ( CHARINDEX((select city from CityInfo ci where ci.id = c.Cid), @cityName)>0 or CHARINDEX(city, @cityName)>0 )";
                Dic.Add("cityName", new DBParam { ParamValue = cityName });
            }

            string sql_pos = "";
            if (!string.IsNullOrWhiteSpace(selectCity))
            {
                sql_pos = "case when c.pos is not null and c.pos !='' then dbo.fnGetDistance(LEFT(c.pos, CHARINDEX(',',c.pos) - 1),SUBSTRING(c.pos, CHARINDEX(',',c.pos)+1,len(c.pos)),'" + selectCity.Split(',')[0] + "','" + selectCity.Split(',')[1] + "') else 800 end as pos2,";
            }

            if (sort == "推荐排序")
            {
                sort = "ORDER BY  case when Stock=0 then 9999999 else Sequence end";
            }
            else if (sort == "距离优先")
            {
                if (!string.IsNullOrWhiteSpace(selectCity))
                {
                    sort = "ORDER BY case when Stock=0 then 9999999 else pos2 end ";
                }
                else
                {
                    sort = "ORDER BY case when Stock=0 then 9999999 else Sequence end";
                }
            }
            else if (sort == "低价优先")
            {
                sort = "ORDER BY case when Stock=0 then 9999999 else Price end ";
            }
            else if (sort == "高价优先")
            {
                sort = "ORDER BY case when Stock=0 then 9999999 else Price end desc";
            }
            else if (sort == "星级优先")
            {
                sort = "ORDER BY case when Stock=0 then 9999999 else Sequence end";
            }
            else
            {
                sort = "ORDER BY case when Stock=0 then 9999999 else Sequence end";
            }

            string sql = string.Format(@"select TOP "+pagesize+@"  * from (
                SELECT ROW_NUMBER() OVER(" + sort + @") AS row,* FROM (
                SELECT  c.id,c.weixinID,c.HotelId,c.Name," + sql_pos + @"c.CommodityType,c.Price,c.Tip,c.Stock,c.ImagePath ,c.ImageList,c.Notice,c.ITDescribe,c.Describe,c.Sequence,c.CreateTime,c.CreateUser,c.EditTime ,c.CanPurchase,c.PurchasePoints,
                (select name from CommodityType_Levi where id= CommodityType) CommodityTypeName,
                c.EditUser,c.Enabled,city.city,h.SubName FROM dbo.Commodity_Levi c WITH(NOLOCK)
                left join Hotel h WITH(NOLOCK) on c.HotelId = h.id
                left join CityInfo city WITH(NOLOCK) on h.cid = city.id
                {0}
                )AS t) as tt WHERE tt.row>{1}", where, dataCount);

            dataCount += pagesize;
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);
            return dt;
        }

        /// <summary>
        /// 获取抢购信息
        /// </summary>
        /// <param name="weiXinID"></param>
        /// <param name="count"></param>
        /// <param name="page"></param>
        /// <param name="pagesize"></param>
        /// <param name="select"></param>
        /// <param name="query"></param>
        /// <returns></returns>
        public static DataTable GetSaleProductsListIndex(string weiXinID, out int count, int page, int pagesize, string select, string query, string cityName, string price)
        {
            StringBuilder tsql = new StringBuilder();
            tsql.Append(@"select count(0) from SaleProducts with(Nolock) where WeiXinID=@weiXinID  and  EndTime>GETDATE() and status=0  and  minprice >0 ");
            StringBuilder sql = new StringBuilder();

//            sql.Append(@"select * from (  select  ROW_NUMBER() over(order by sort desc, minPrice )num,* from (
// select   *  from (select  Id, ProductType,ProductName,BeginTime,EndTime, EffectiveBeginTime,EffectiveEndTime,LastUpdatetime,
//SaleChannel,Status,ImageList, SmallImageList,BigImageList , MainPic,MenPrice,Tab,minPrice,sort from  SaleProducts s with(Nolock)   where WeiXinID=@weiXinID and  EndTime>GETDATE()  and  status=0  and minPrice >0  ");
            sql.Append(@"select * from (  select  ROW_NUMBER() over(order by minPrice )num,* from (
                 select   *  from (select  s.Id, s.ProductType,s.ProductName,s.BeginTime,s.EndTime, s.EffectiveBeginTime,s.EffectiveEndTime,s.LastUpdatetime,
                s.SaleChannel,s.Status,s.ImageList, s.SmallImageList,s.BigImageList , s.MainPic,s.MenPrice,s.Tab,s.minPrice, city.city
                from  SaleProducts s with(Nolock)   
                left join CityInfo city WITH(NOLOCK) on s.Cid = city.id

                where s.WeiXinID=@weiXinID and  s.EndTime>GETDATE()  and  s.status=0  and s.minPrice >0  ");

            if (!string.IsNullOrEmpty(cityName))
            {
                sql.Append(" AND CHARINDEX(city.city, @cityName)>0 ");
            }

            if (!string.IsNullOrEmpty(price))
            {
                var arr = price.Split(',');
                sql.Append(" AND s.MenPrice>=" + arr[0] + " and  s.MenPrice<=" + arr[1] + " ");
            }

            if (string.IsNullOrEmpty(select))
            {
                sql.Append("  )t )tt ) a where a.num between @startID and @endID");
            }
            if (!string.IsNullOrEmpty(select))
            {
                tsql.Append(" and " + select + " like '%'+@query+'%'");
                sql.Append(" and " + select + " like '%'+@query+'%'  )t )tt) a where a.num between @startID and @endID");
            }

            string value = HotelCloud.SqlServer.SQLHelper.Get_Value(tsql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinID}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            count = Convert.ToInt32(value);
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinID}},
            {"cityName",new HotelCloud.SqlServer.DBParam{ParamValue=cityName}},
            {"startID",new HotelCloud.SqlServer.DBParam{ParamValue=((page-1)*pagesize+1).ToString()}},
            {"endID",new HotelCloud.SqlServer.DBParam{ParamValue=(page*pagesize).ToString()}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            return dt;

        }

        public static List<ProductEntity> GetSaleProductsListToList(string weixinid, string search, string cityName, string price)
        {
            int count = 0;
            //ProductEntityList list_products = new ProductEntityList();
            //var dt = CommodityService.GetSaleProductsListIndex(weixinid, out count, 1, 99, "", "");
            //list_products.ProductEntity_List = ProductEntity.ConvertProductEntityIndexListMall(dt);
            //list_products.Count = count;
            //ViewData["products"] = list_products.ProductEntity_List;
            ProductEntityList list_products = new ProductEntityList();

            var dt = CommodityService.GetSaleProductsListIndex(weixinid, out count, 1, 99, "ProductName", search, cityName, price);
            list_products.ProductEntity_List = ProductEntity.ConvertProductEntityIndexListMall(dt);
            //list_products.ProductEntity_List = SaleProduct.GetSaleProductsListIndexA(weixinid, out count, 1, 99, "", "");
            list_products.Count = count;

            list_products.ProductEntity_List = TravelAgencyCommon.ProductListDo(list_products.ProductEntity_List);

            list_products.ProductEntity_List = list_products.ProductEntity_List.Where(c => c.List_SaleProducts_TC.Count > 0).ToList();

            return list_products.ProductEntity_List;
        }

        /// <summary>
        /// 获取旅行社商品地址
        /// </summary>
        /// <param name="HotelId"></param>
        /// <param name="userId"></param>
        /// <param name="search"></param>
        /// <returns></returns>
        public static DataTable GetDataTravelAgencyCommdityLocat(string weiXinID, string type, string MallSearch)
        {
            string sql = @"select * from (
                            select city.city,(select city from CityInfo ci where ci.id = c.Cid) as city2 
                            FROM dbo.Commodity_Levi c WITH(NOLOCK)
                            left join Hotel h WITH(NOLOCK) on c.HotelId = h.id
                            left join CityInfo city WITH(NOLOCK) on h.cid = city.id
                            where c.weixinID = @weiXinID ";

            if (!string.IsNullOrWhiteSpace(type)) {
                sql = sql + " and c.CommodityType = @type";
            }
            if (!string.IsNullOrWhiteSpace(MallSearch))
            {
                sql = sql + " AND CHARINDEX(@Name,c.Name)>0 ";
            }

            sql = sql + ") t group by city,city2";

            if (string.IsNullOrWhiteSpace(type)) {
                sql += @"
                    union
                    select city.city, '' from SaleProducts sp 
                    left join CityInfo city on sp.Cid = city.id
                    where sp.weixinID = @weiXinID ";

                if (!string.IsNullOrWhiteSpace(MallSearch))
                {
                    sql = sql + " AND CHARINDEX(@Name,sp.ProductName)>0 ";
                }

                sql += " group by city";
            }

            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"weiXinID",new DBParam(){ParamValue=weiXinID}},
                        {"type",new DBParam(){ParamValue=type}},
                        {"Name",new DBParam(){ParamValue=MallSearch}}
                    });

            return dt;
        }

        /// <summary>
        /// 根据用户id和查询条件获取数据
        /// </summary>
        /// <param name="HotelId"></param>
        /// <param name="userId"></param>
        /// <param name="search"></param>
        /// <returns></returns>
        public static DataTable GetDataSearch(string HotelId, string userId, string search)
        {
            string sql = @"select id, Name, Price, Tip, Stock, ImagePath, Describe,
                           (select Total from ShoppingCart_Levi s where s.HotelId=@HotelId and s.userweixinID=@userweixinID and s.CommodityId = t.id) as Total
                           from Commodity_Levi t 
                           where t.HotelId=@HotelId and t.Name like '%@search%' order by Sequence";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"HotelId",new DBParam(){ParamValue=HotelId}},
                        {"userweixinID",new DBParam(){ParamValue=userId}},
                        {"search",new DBParam(){ParamValue=search}}
                    });

            return dt;
        }

        /// <summary>
        /// 根据微信ID获取商品类型列表
        /// </summary>
        /// <param name="orderid"></param>
        /// <returns></returns>
        public static DataTable GetCommodityTypeByWeixinId(string weixinID, string parentId, string MallSearch, string cityName = "")
        {
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("weixinID", new DBParam { ParamValue = weixinID });

            string sql = @"select ct.id,ct.weixinID,ct.HotelId,ct.Name,ct.ICO,ct.Sequence
                            from CommodityType_Levi ct with(nolock)";

            if (!string.IsNullOrWhiteSpace(parentId))
            {
                sql += @" left join Commodity_Levi c with(nolock) on ct.id = c.Subitem
                            left join Hotel h WITH(NOLOCK) on c.HotelId = h.id
                            left join CityInfo city WITH(NOLOCK) on h.cid = city.id";
            }
            else
            {
                sql += @" left join Commodity_Levi c with(nolock) on ct.id = c.CommodityType
                            left join Hotel h WITH(NOLOCK) on c.HotelId = h.id
                            left join CityInfo city WITH(NOLOCK) on h.cid = city.id";
            }


            sql += " where c.weixinID=@weixinID ";//and c.UseRichText=1 

            if (!string.IsNullOrWhiteSpace(parentId))
            {
                sql += " and ((ct.weixinID = @weixinID and ct.Enabled= 1";
                sql += " and ct.ParentId= @ParentId";
                Dic.Add("ParentId", new DBParam { ParamValue = parentId });
                sql += "))";
            }
            else
            {
                sql += " and ((ct.weixinID = @weixinID and ct.Enabled= 1";
                sql += "  and ISNULL(ct.ParentId,0) = 0";
                sql += "  ) or ct.weixinID = '0')";
            }

            if (!string.IsNullOrEmpty(MallSearch))
            {
                sql += " AND CHARINDEX(@MallSearch, c.Name)>0 ";
                Dic.Add("MallSearch", new DBParam { ParamValue = MallSearch });
            }
            if (!string.IsNullOrEmpty(cityName))
            {
                sql += " AND ( CHARINDEX((select city from CityInfo ci where ci.id = c.Cid), @cityName)>0 or CHARINDEX(city, @cityName)>0 )";
                Dic.Add("cityName", new DBParam { ParamValue = cityName });
            }


            sql += " group by ct.id,ct.weixinID,ct.HotelId,ct.Name,ct.ICO,ct.Sequence order by ct.Sequence";

            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);

            return dt;
        }


        public static DataTable GetCommodityTypeByWeixinId(string weixinID, string MallSearch) {

            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("weixinID", new DBParam { ParamValue = weixinID });

            string sql = @"select ct.id,ct.weixinID,ct.HotelId,ct.Name,ct.ICO,ct.Sequence 
                            from CommodityType_Levi ct with(nolock)  ,Commodity_Levi c with(nolock) 
                            where ct.id = c.Subitem and c.UseRichText=1 
                            and c.weixinID=@weixinID ";

            if (!string.IsNullOrEmpty(MallSearch))
            {
                sql = sql + " AND CHARINDEX(@MallSearch, c.Name)>0 ";
                Dic.Add("MallSearch", new DBParam { ParamValue = MallSearch });
            }

            sql = sql + " group by ct.id,ct.weixinID,ct.HotelId,ct.Name,ct.ICO,ct.Sequence order by ct.Sequence";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);

            return dt;
        }

        /// <summary>
        /// 根据微信ID获取酒店商品类型列表
        /// </summary>
        /// <param name="weixinID"></param>
        /// <param name="hotelId"></param>
        /// <param name="parentId"></param>
        /// <returns></returns>
        public static DataTable GetCommodityTypeByhotelId(string weixinID, string hotelId, string parentId)
        {
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("weixinID", new DBParam { ParamValue = weixinID });
            Dic.Add("HotelId", new DBParam { ParamValue = hotelId });

            string sql = @"select ct.id,ct.weixinID,ct.HotelId,ct.Name,ct.ICO,ct.Sequence from CommodityType_Levi ct with(nolock) ,Commodity_Levi c with(nolock)
                        where ct.id = c.CommodityType and c.HotelId=@HotelId and ((ct.weixinID = @weixinID and ct.Enabled= 1
                        ";
            //if (string.IsNullOrWhiteSpace(type))
            //{
            //    sql = sql + " and CommodityType= @CommodityType";
            //    Dic.Add("CommodityType", new DBParam { ParamValue = type });
            //}

            if (!string.IsNullOrWhiteSpace(parentId))
            {
                sql = sql + " and ct.ParentId= @ParentId";
                Dic.Add("ParentId", new DBParam { ParamValue = parentId });
                sql = sql + "))";
            }
            else
            {
                sql = sql + "  and ISNULL(ct.ParentId,0) = 0";
                sql = sql + "  ) or ct.weixinID = '0')";
            }

            sql = sql + "group by ct.id,ct.weixinID,ct.HotelId,ct.Name,ct.ICO,ct.Sequence order by ct.Sequence";

            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);

            return dt;
        }

        /// <summary>
        /// 获取推荐商品列表
        /// </summary>
        /// <param name="weixinID"></param>
        /// <returns></returns>
        public static DataTable GetCommodityExtensionByWeixinId(string weixinID)
        {
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("weixinID", new DBParam { ParamValue = weixinID });

            string sql = @"select id,weixinID,HotelId,CommodityId,Name,Describe,ImageList from CommodityExtension_Levi with(nolock) 
                        where weixinID = @weixinID
                        ";

            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);

            return dt;
        }

        /// <summary>
        /// 减少库存
        /// </summary>
        /// <param name="id"></param>
        /// <param name="stock"></param>
        /// <returns></returns>
        public int ReduceStock(string id, int stock)
        {

            lock (this)
            {
                string sql = @"update Commodity_Levi set Stock = Stock - @stock where id = @id and Stock - @stock >=0";

                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"id",new DBParam(){ParamValue=id}},
                        {"stock",new DBParam(){ParamValue=stock.ToString()}}
                    });
            }
            //return 0;
        }
    }
}