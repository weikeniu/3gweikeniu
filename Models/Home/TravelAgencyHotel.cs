using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using hotel3g.Models.DAL;
using System.Data;
using HotelCloud.SqlServer;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using hotel3g.Common;

namespace hotel3g.Models.Home
{
    public class TravelAgencyHotel
    {
        #region DAL
        TravelAgencyHotelDAL taHotelDAL = new TravelAgencyHotelDAL();        
        #endregion


        #region 方法
        static System.Web.Caching.Cache cache = HttpRuntime.Cache;

        /// <summary>
        /// 获取该酒店拥有最多分店的城市
        /// </summary>
        /// <param name="HotelWxId"></param>
        /// <returns></returns>
        public Dictionary<int, string> GetSumTopCityForHotel(string hotelWxId) 
        {
            var dic = new Dictionary<int, string>();
            var dt = taHotelDAL.GetSumTopCityForHotel(hotelWxId);
            if (dt.Rows.Count > 0) 
            {
                dic.Add(Convert.ToInt32(dt.Rows[0]["id"]),dt.Rows[0]["city"].ToString());          
            }
            return dic;
        }

        /// <summary>
        /// 获取该酒店下所有分店的品牌、商圈、行政区的条件数据(默认缓存30分钟)
        /// key:1,城市
        /// key:2,行政区
        /// key:3,品牌
        /// key:4,商圈
        /// </summary>
        /// <returns></returns>
        public Dictionary<int, Dictionary<int, string>> GetHasHotelCdtData(string hotelWxId, int cacheSeconds = 30) 
        {
            string cacheKey = "cdtDic_" + hotelWxId;
            var cdtDic = cache.Get(cacheKey) as Dictionary<int, Dictionary<int, string>>;
            if (cdtDic == null)
            {
                var cityDic = new Dictionary<int, string>(); var chainDic = new Dictionary<int, string>();
                var areaDic = new Dictionary<int, string>(); var taDic = new Dictionary<int, string>();
                var cdtDt = taHotelDAL.GetHasHotelCdtData(hotelWxId);
                foreach (DataRow r in cdtDt.Rows)
                {
                    var cdtType = Convert.ToInt32(r["cdtType"]);
                    var cdtId = Convert.ToInt32(r["id"]);
                    var cdtName = r["name"] == DBNull.Value?"":r["name"].ToString();
                    switch (cdtType)
                    {
                        case 1: cityDic.Add(cdtId, cdtName);break;
                        case 2: areaDic.Add(cdtId, cdtName); break;
                        case 3: chainDic.Add(cdtId, cdtName); break;
                        case 4: taDic.Add(cdtId, cdtName); break;
                        default:
                            break;
                    }
                }
                cdtDic = new Dictionary<int, Dictionary<int, string>>() 
                {
                    {1,cityDic},{2,areaDic},{3,chainDic},{4,taDic}
                };
                cache.Insert(cacheKey, cdtDic, null, DateTime.Now.AddSeconds(30), TimeSpan.Zero);
            }
            return cdtDic;
        }

        /// <summary>
        /// 获取该酒店下所有分店的品牌、商圈、行政区的条件ids(默认缓存30分钟)
        /// key:1,城市Ids
        /// key:2,行政区Ids
        /// key:3,品牌Ids
        /// key:4,商圈Ids
        /// </summary>
        /// <returns></returns>
        public Dictionary<int, List<int>> GetHasHotelConditionIDs(string hotelWxId, int cacheSeconds = 30) 
        {
            string cacheKey = "idsDic_"+hotelWxId;
            var idsDic = cache.Get(cacheKey) as Dictionary<int, List<int>>;
            if (idsDic == null)
            {
                idsDic = new Dictionary<int, List<int>>();
                var cityIDs = new List<int>();
                var areaIDs = new List<int>();
                var chainIDs = new List<int>();
                var tradingAreaIDs = new List<int>();
                foreach (DataRow r in taHotelDAL.GetAuditPassHotels(hotelWxId).Rows)
                {
                    //cityIDs.Add(Convert.ToInt32(r["cid"]));
                    cityIDs.Add((r["cid"] != DBNull.Value ? Convert.ToInt32(r["cid"]) : 0));
                    areaIDs.Add((r["rid"] != DBNull.Value ? Convert.ToInt32(r["rid"]) : 0));
                    chainIDs.Add((r["chainID"] != DBNull.Value ? Convert.ToInt32(r["chainID"]) : 0));
                    tradingAreaIDs.Add((r["TradingAreaID"] != DBNull.Value ? Convert.ToInt32(r["TradingAreaID"]) : 0));
                }
                idsDic.Add(1, cityIDs.Where(m => m > 0).Distinct().ToList());
                idsDic.Add(2, areaIDs.Where(m => m > 0).Distinct().ToList());
                idsDic.Add(3, chainIDs.Where(m => m > 0).Distinct().ToList());
                idsDic.Add(4, tradingAreaIDs.Where(m => m > 0).Distinct().ToList());
                cache.Insert(cacheKey, idsDic, null, DateTime.Now.AddSeconds(30), TimeSpan.Zero);
            }
            return idsDic;
        }

        /// <summary>
        /// 获取搜索酒店下的分店结果
        /// </summary>
        /// <param name="hq"></param>
        /// <returns></returns>
        public List<TAHotel> GetHotelSeachRes(TravelAgencyHotelQuery hq) 
        {
            var taHotels = new List<TAHotel>();
            var dt = new DataTable();
            var isEnd = false;//是否终止查询
            var kwType = Convert.ToInt32(hq.KeyWordVal.Split(new char[] { ',' })[0]);
            var kwID = Convert.ToInt32(hq.KeyWordVal.Split(new char[] { ',' })[1]);
            var dbParams = new Dictionary<string, string>() 
            {
                {"HotelWxId",hq.HotelWxId},
                {"CityID",hq.CityID.ToString()},
                {"KeyWord",hq.KeyWordText},
                {"KeyWordID",kwID.ToString()}
            };
            var sql = @"SELECT id AS 'HotelID',WeiXinID as HotelWxId,SubName AS 'HotelName',star AS 'Star', MainPic,LowerPrice,pos AS 'LngLat',address AS 'Address',PartnerLevel, SpecificLabel,RecommendSort,ISNULL(CommentAvgScore,-1) AS CommentAvgScore FROM dbo.Hotel WHERE cid = @CityID and WeiXinID = (SELECT top 1 WeiXinID FROM dbo.WeiXinNO WITH(NOLOCK) WHERE  examine=1 and WeiXinID = @HotelWxId ) ";//酒店-城市-审核通过
            var stars = GetStarIdsStr(hq.HType);
            if (stars.Count > 0)//星级档次
                sql += "and star in (" + string.Join(",",stars) + ")";
            if (hq.Price.Equals("1000+")) //价格
            {
                sql += "and LowerPrice > 1000 ";
            }
            else if (!hq.Price.Equals("不限")) 
            {
                sql += "and LowerPrice between " + hq.Price.Split(new char[] { '-' })[0] + " and " + hq.Price.Split(new char[] { '-' })[1] + " ";
            }
            if (kwType == 0) //自定义关键字(品牌-》行政区-》商业区-》酒店名+地址-》百度地图经纬度匹配)
            {
                #region 用户手动输入关键字查询
                string kwSql;
                //1品牌是否有数据
                kwSql = sql + "and chainID IN (SELECT  id FROM dbo.ChainInfo WITH(NOLOCK) WHERE CHARINDEX(chain_name,@KeyWord)>0 OR CHARINDEX(@KeyWord,chain_name)>0) ";
                dt = taHotelDAL.GetHotelSeachRes(kwSql, dbParams);
                if (dt.Rows.Count <= 0)
                {
                    //2行政区
                    kwSql = sql + "and rid IN (SELECT id FROM dbo.RegionInfo With(NOLOCK) WHERE (CHARINDEX(name,@KeyWord)>0 OR CHARINDEX(@KeyWord,name)>0)) ";
                    dt = taHotelDAL.GetHotelSeachRes(kwSql, dbParams);
                    if (dt.Rows.Count <= 0)
                    {
                        //3商业区
                        kwSql = sql + "and TradingAreaID IN (SELECT id FROM dbo.jdwz With(NOLOCK) WHERE city = @CityID and (CHARINDEX(jdwz_name,@KeyWord)>0 OR CHARINDEX(@KeyWord,jdwz_name)>0)) ";
                        dt = taHotelDAL.GetHotelSeachRes(kwSql, dbParams);
                        if (dt.Rows.Count <= 0)
                        {
                            //4酒店名+地址
                            kwSql = sql + "and (CHARINDEX(SubName+address,@KeyWord)>0 OR CHARINDEX(@KeyWord,SubName+address)>0)  ";
                            dt = taHotelDAL.GetHotelSeachRes(kwSql, dbParams);
                            if (dt.Rows.Count <= 0)
                            {
                                isEnd = true;
                                try
                                {
                                    //百度API(http://lbsyun.baidu.com/index.php?title=webapi/guide/webservice-placeapi)
                                    //5百度地图经纬度匹配(用百度地图搜索8公里以内酒店)
                                    var addrData = WxPayAPI.HttpService.Get(string.Format("http://api.map.baidu.com/place/v2/search?query={0}&page_size=1&page_num=0&scope=1&region={1}&output=json&ak=Y4ofkWPl6nHN41oFEZj39HPA", HttpUtility.UrlEncode(hq.KeyWordText), hq.CityName));
                                    var jObj = JsonConvert.DeserializeObject(addrData) as JObject;
                                    if ((int)jObj["status"] == 0 && (int)jObj["total"] > 0)
                                    {
                                        var kwLngLat = jObj["results"][0]["location"]["lng"].ToString() + "," + jObj["results"][0]["location"]["lat"].ToString();
                                        dt = taHotelDAL.GetHotelSeachRes(sql, dbParams);
                                        var hotels = DtFilles.DtToModel<TAHotel>(dt);
                                        foreach (var h in hotels)
                                        {
                                            //计算距离，只展示8公里以内酒店
                                            if (GetDistance(h.LngLat, kwLngLat) <= 8000.0)
                                            {
                                                taHotels.Add(h);
                                            }
                                        }
                                    }
                                }
                                catch (Exception)
                                {
                                }
                            }
                        }

                    }
                } 
                #endregion

            }
            else if (kwType > 0)//选择关键字 
            {
                if (kwType == 1)//品牌
                    sql += "and chainID = @KeyWordID ";
                else if (kwType == 2) //行政区
                    sql += "and rid = @KeyWordID ";
                else if (kwType == 3)//商圈
                    sql += "and TradingAreaID = @KeyWordID ";
                dt = taHotelDAL.GetHotelSeachRes(sql, dbParams);
            }
            else 
            {
                dt = taHotelDAL.GetHotelSeachRes(sql, dbParams);
            }
            if (!isEnd) 
            {
                taHotels = DtFilles.DtToModel<TAHotel>(dt);   
            }
            foreach (var h in taHotels)
            {
                h.Distance = GetDistance(h.LngLat, hq.LngLat);
            }
            switch (hq.SpecSort)
            {
                case 1: //推荐排序：金银铜->特色标签—>手动设置->评分
                    taHotels = (from h in taHotels
                                orderby h.PartnerLevel descending
                                ,h.SpecificLabel descending
                                ,h.RecommendSort descending
                                ,h.CommentAvgScore descending
                                select h).ToList<TAHotel>();
                    break;
                case 2: taHotels = taHotels.OrderBy(h => h.Distance).ToList(); break;//距离排序
                case 3: taHotels = taHotels.OrderBy(h => h.LowerPrice).ToList(); break;//低价排序
                case 4: taHotels = taHotels.OrderByDescending(h => h.LowerPrice).ToList(); break;//高价排序
                case 5: taHotels = taHotels.OrderByDescending(h => h.Star).ToList(); break;//星级排序
                default:
                    break;
            }
            taHotels = taHotels.Skip((hq.Page - 1) * 10).Take(10).ToList();
            if (taHotels.Count > 0)
            {
                var hotelIds = taHotels.Select(h => h.HotelID).ToList();
                //获取多个酒店最近的预订时间(分钟)
                var bookMinDic = GetHotelsLastBookMin(hotelIds);
                //获取多个酒店是否有红包
                var hasCouponDic = GetHotelsHasCoupon(hotelIds);
                //获取多个酒店是否有钟点房
                var hasHourRoom = GetHotelsHasHourRoom(hotelIds);
                foreach (var h in taHotels)
                {
                    h.CommentAvgScore = h.CommentAvgScore < 0.0 ? 5.0 : h.CommentAvgScore;
                    h.CommentAvgScoreText = GetCommentScoreAvgText(h.CommentAvgScore);
                    h.BookRoomMin = bookMinDic[h.HotelID];
                    h.BookRoomMinText = GetBookRoomMinText(bookMinDic[h.HotelID]);
                    h.HasCouPon = hasCouponDic[h.HotelID];
                    h.HasHourRoom = hasHourRoom[h.HotelID];
                    h.SpecificLabelText = GetSpecificLabelText(h.SpecificLabel);
                    h.StarText = GetStarText(h.Star);
                    h.LinkUrl = string.Format("/{0}?key={1}@{2}", h.HotelID, h.HotelWxId, hq.UserWxId);
                }
            }
            return taHotels;
        }

        /// <summary>
        /// 获取多个酒店最近的预订时间(分钟)
        /// 规则:超过3小时预订，包括没有预订的，就显示3小时前有预订.如果小于3小时的，大于2小时就显示2小时前有预订，
        /// 阶梯分别是 3小时，2小时，1小时，30分钟，20分钟 10分钟，具体分钟数1-9分钟 小于1分钟就显示 1分钟内有人预订
        /// </summary>
        /// <param name="hotelIds"></param>
        /// <returns></returns>
        public Dictionary<int, int> GetHotelsLastBookMin(List<int> hotelIds) 
        {
            var bookMinDic = new Dictionary<int, int>();
            var dt = taHotelDAL.GetHotelsLastOrderTime(hotelIds);
            //默认(没有订单)
            foreach (var id in hotelIds)
            {
                bookMinDic.Add(id, 181);//3小时
            }
            //有订单
            foreach (DataRow r in dt.Rows)
            {                
                bookMinDic[Convert.ToInt32(r["HotelID"])] = (DateTime.Now - Convert.ToDateTime(r["OrderTime"])).Minutes;
            }
            return bookMinDic;
        }

        /// <summary>
        /// 获取多个酒店是否有优惠卷红包信息
        /// </summary>
        /// <returns></returns>
        public Dictionary<int, bool> GetHotelsHasCoupon(List<int> hotelIds) 
        {
            var hasCouponDic = new Dictionary<int, bool>();
            var dt = taHotelDAL.GetHotelsCouponCount(hotelIds);
            //默认(没有红包记录)
            foreach (var id in hotelIds)
            {
                hasCouponDic.Add(id, false);
            }
            //有红包记录
            foreach (DataRow r in dt.Rows)
            {
                hasCouponDic[Convert.ToInt32(r["HotelId"])] = (Convert.ToInt32(r["Coupon"]) > 0);
            }
            return hasCouponDic;
        }

        /// <summary>
        /// 获取多个酒店是否有钟点房信息
        /// </summary>
        /// <param name="hotelIds"></param>
        /// <returns></returns>
        public Dictionary<int, bool> GetHotelsHasHourRoom(List<int> hotelIds) 
        {
            var hasCouponDic = new Dictionary<int, bool>();
            var dt = taHotelDAL.GetHotelHasHourRoom(hotelIds);
            //默认(没有钟点房)
            foreach (var id in hotelIds)
            {
                hasCouponDic.Add(id, false);
            }
            //有钟点房
            foreach (DataRow r in dt.Rows)
            {
                hasCouponDic[Convert.ToInt32(r["HotelID"])] = true;
            }
            return hasCouponDic;
        }

        /// <summary>
        /// 百度坐标计算距离(http://blog.csdn.net/pleasurelong/article/details/26855049)
        /// 几乎没有误差,最多十米内
        /// </summary>
        /// <param name="lnglat1"></param>
        /// <param name="lnglat2"></param>
        /// <returns></returns>
        public double GetDistance(string lnglat1, string lnglat2)
        {
            double lon1 = Convert.ToDouble(lnglat1.Split(new char[] { ',' })[0]);
            double lat1 = Convert.ToDouble(lnglat1.Split(new char[] { ',' })[1]);
            double lon2 = Convert.ToDouble(lnglat2.Split(new char[] { ',' })[0]);
            double lat2 = Convert.ToDouble(lnglat2.Split(new char[] { ',' })[1]);
            // 地球半径
            double EARTH_RADIUS = 6378.137;
            var radLat1 = (Math.PI / 180.0)*lat1;  
            var radLat2 = (Math.PI / 180.0)*lat2 ; 
            var a = radLat1 - radLat2;  
            var b = (Math.PI / 180.0)*lon1 - (Math.PI / 180.0)*lon2;
            var s = 2 * Math.Asin(Math.Sqrt(Math.Pow(Math.Sin(a / 2), 2) + Math.Cos(radLat1) * Math.Cos(radLat2) * Math.Pow(Math.Sin(b / 2), 2)));
            s = s * EARTH_RADIUS;
            s*=1000;
            //s = math.round(s * 10000) / 10000; // 公里
            return s; 
        }

        //获取查找星级档次的star ids
        public List<int> GetStarIdsStr(string starStr)
        {
            var stars = new List<int>();
            var starArr = starStr.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (var s in starArr)
            {
                if (s == "2")//二星及以下 
                {
                    stars.Add(1); stars.Add(2); stars.Add(4); stars.Add(6); stars.Add(9);                 
                }
                if (s == "3") //三星
                {
                    stars.Add(3); stars.Add(10);                
                }
                if (s == "4") //四星
                {
                    stars.Add(7); stars.Add(8); stars.Add(11);              
                }
                if (s == "5") //五星
                {
                    stars.Add(5); stars.Add(12);                 
                }
            }
            return stars;
        }

        public string GetStarText(int star) 
        {
            string starText = string.Empty;
            if (star == 2 || star == 4 || star == 6)
                return "二星级及以下";
            else if (star == 3)
                return "三星级";
            else if (star == 7 || star == 8)
                return "四星级";
            else if (star == 5)
                return "五星级";
            else if (star == 1 || star == 9)
                return "二星级及以下/经济";
            else if (star == 10)
                return "三星级/舒适";
            else if (star == 11)
                return "四星级/高档";
            else if (star == 12)
                return "五星级/豪华";
            else
                return string.Empty;

            //switch (star)
            //{
            //    case 2: starText = "二星级及以下"; break;
            //    case 3: starText = "三星级"; break;
            //    case 4: starText = "四星级"; break;
            //    case 5: starText = "五星级"; break;
            //    case 6: starText = "二星级及以下/经济"; break;
            //    case 7: starText = "三星级/舒适"; break;
            //    case 8: starText = "四星级/高档"; break;
            //    case 9: starText = "五星级/豪华"; break;
            //    default:
            //        break;
            //}
            //return starText;
        }
        public string GetCommentScoreAvgText(double sAvg)
        {
            if (sAvg <= 5.0 && sAvg >= 4.8)
                return "棒级了";
            if (sAvg < 4.8 && sAvg >= 4.5)
                return "非常棒";
            if (sAvg < 4.5 && sAvg <= 4.4)
                return "很好";
            if (sAvg < 4.4 && sAvg <= 4.1)
                return "好";
            if (sAvg < 4.1 && sAvg <= 3.0)
                return "还不错";
            return "";
        }

        public string GetBookRoomMinText(int min) 
        {
            if(min >= 180)
                return "3小时前已有人预订";
            if(min < 180 && min >= 120)
                return "2小时前已有人预订";
            if(min < 120 && min >=60)
                return "1小时前已有人预订";
            if(min < 60 &&  min>=30 )
                return "30分钟前已有人预订";
            if(min < 30 && min >=20)
                return "20分钟前已有人预订";
            if(min < 20 && min >=10)
                return "10分钟前已有人预订";
            if(min < 10 && min >= 1)
                return min+"分钟前已有人预订";
            if(min < 1)
                return "1分钟内已有人预订";
            return "";
        }

        public string GetSpecificLabelText(int label) 
        {
            string text = string.Empty;
            switch (label)
            {
                case 1: text = "人气热卖"; break;
                case 2: text = "超高性价比"; break;
                case 3: text = "试睡员推荐"; break;
                case 4: text = "特色客栈"; break;
                default:
                    break;
            }
            return text;
        }
        #endregion
    }

    /// <summary>
    /// 旅行社酒店
    /// </summary>
    public class TAHotel 
    {
        /// <summary>
        /// 酒店ID
        /// </summary>
        public int HotelID { get; set; }
        //酒店微信Id
        public string HotelWxId { get; set; }
        /// <summary>
        /// 酒店名称
        /// </summary>
        public string HotelName { get; set; }
        /// <summary>
        /// 星级档次
        /// </summary>
        public int Star { get; set; }
        public string StarText { get; set; }
        /// <summary>
        /// 展示图片
        /// </summary>
        public string MainPic { get; set; }
        /// <summary>
        /// 最低价
        /// </summary>
        public int LowerPrice { get; set; }
        /// <summary>
        /// 地址
        /// </summary>
        public string Address { get; set; }
        /// <summary>
        /// 经纬度
        /// </summary>
        public string LngLat { get; set; }
        /// <summary>
        /// 附近查询时表示与当前用户距离。
        /// 城市查询时表示与市中心距离。
        /// </summary>
        public double Distance { get; set; }
        /// <summary>
        /// 点击时的链接
        /// </summary>
        public string LinkUrl { get; set; }
        /// <summary>
        /// 是否显示评论分数
        /// </summary>
        //public bool IsShowCommentScoreAvg { get; set; }
        /// <summary>
        /// 综合评分(没有点评默认就5分，4.8分-5分 棒级了 4.5分-4.7分非常棒 4.4分 很好，4.3分到4.1分 好，3.0-4.0还不错，低于3分就不要显示评级)
        /// </summary>
        public double CommentAvgScore { get; set; }
        /// <summary>
        /// 综合评分显示文本
        /// </summary>
        public string CommentAvgScoreText { get; set; }
        /// <summary>
        /// 订房时间(分钟)(超过3小时预订，包括没有预订的，就显示3小时前有预订,如果小于3小时的，大于2小时就显示2小时前有预订，
        /// 阶梯分别是3小时，2小时，1小时，30分钟，20分钟 10分钟，具体分钟数1-9分钟 小于1分钟就显示 1分钟内有人预订)
        /// </summary>
        public int BookRoomMin { get; set; }
        /// <summary>
        /// 订房时间显示文本
        /// </summary>
        public string BookRoomMinText { get; set; }
        /// <summary>
        /// 特色标签
        /// </summary>
        public int SpecificLabel { get; set; }
        /// <summary>
        /// 特色标签显示文本(如 1人气热卖，2优性价比酒店，3试睡员推荐)
        /// </summary>
        public string SpecificLabelText { get; set; }
        /// <summary>
        /// 合作级别（0没有级别1铜牌伙伴2银牌伙伴3金牌伙伴）
        /// </summary>
        public int PartnerLevel { get; set; }
        /// <summary>
        /// 推荐排序
        /// </summary>
        public int RecommendSort { get; set; }
        /// <summary>
        /// 是否有会员红包
        /// </summary>
        public bool HasCouPon { get; set; }
        /// <summary>
        /// 是否有钟点房
        /// </summary>
        public bool HasHourRoom { get; set; }
    }

    /// <summary>
    /// 旅行社酒店查询条件实体
    /// </summary>
    public class TravelAgencyHotelQuery 
    {
        /// <summary>
        /// 0附近查询，1直接查询
        /// </summary>
        public int QType { get; set; }
        /// <summary>
        /// 当前查询用户的微信ID
        /// </summary>
        public string UserWxId { get; set; }
        /// <summary>
        /// 酒店微信ID
        /// </summary>
        public string HotelWxId { get; set; }
        /// <summary>
        /// 城市ID
        /// </summary>
        public int CityID { get; set; }
        public string CityName { get; set; }
        /// <summary>
        /// 入住日期
        /// </summary>
        public string InRoomDate { get; set; }
        /// <summary>
        /// 退房日期
        /// </summary>
        public string LvRoomDate { get; set; }
        /// <summary>
        /// 价格区间
        /// </summary>
        public string Price { get; set; }
        /// <summary>
        /// 星级档次
        /// </summary>
        public string HType { get; set; }
        /// <summary>
        /// 搜索关键字值:格式1,2。表示搜索品牌id为2的数据
        /// -1没有输入关键字，0用户输入的关键字(匹配顺序为: 品牌-》行政区-》商业区-》酒店名+地址-》百度地图经纬度匹配)，1品牌，2行政区
        /// </summary>
        public string KeyWordVal { get; set; }
        /// <summary>
        /// 搜索关键字显示文本
        /// </summary>
        public string KeyWordText { get; set; }
        /// <summary>
        /// 特殊排序:1推荐，2距离，3低价，4高价，5星级
        /// </summary>
        public int SpecSort { get; set; }
        public string LngLat { get; set; }
        public int Page { get; set; }
        public int PageSize { get; set; }
    }
}