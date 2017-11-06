using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using HotelCloud.Common;
using HotelCloud.SqlServer;
using System.Data;
using System.Collections;
using hotel3g.Models;
using WeiXin.Models;
using hotel3g.Models.Home;
using WeiXin.Common;
using System.Text;

namespace hotel3g.Controllers
{
    public class ActionController : Controller
    {
        public ContentResult gethotelinfo()
        {
            int hid = HCRequest.getInt("hid");
            string hotelweixinid = HCRequest.GetString("hotelweixinid");
            string json = Newtonsoft.Json.JsonConvert.SerializeObject(gethotelinfo(hid, hotelweixinid));
            return Content(json);
        }

        public static Models.Hotel gethotelinfo(int hid, string hotelweixinid)
        {
            string cacheKey = "hotelinfo_" + hotelweixinid + "_" + hid;
            System.Web.Caching.Cache cache = HttpRuntime.Cache;
            Models.Hotel hotel = null;
            try
            {
                if (cache[cacheKey] == null)
                {
                    string sql = "select top 1 subname,address,tel,fuwu,canyin,yule,kefang,opendate,hotellog,pos from hotel with (nolock) where weixinid=@weixinid and id=@hid";
                    DataTable table = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"hid",new DBParam(){ParamValue=hid.ToString()}},
                        {"weixinid",new DBParam(){ParamValue=hotelweixinid}}
                    });
                    hotel = new Hotel();
                    if (table.Rows.Count > 0)
                    {
                        DataRow r = table.Rows[0];
                        hotel.Tel = NormalCommon.StrFilterToJson(r["tel"].ToString());
                        hotel.SubName = NormalCommon.StrFilterToJson(r["SubName"].ToString().Trim());
                        hotel.openDate = NormalCommon.StrFilterToJson(r["openDate"].ToString());
                        hotel.FuWu = NormalCommon.StrFilterToJson(r["FuWu"].ToString());
                        hotel.CanYin = NormalCommon.StrFilterToJson(r["CanYin"].ToString());
                        hotel.YuLe = NormalCommon.StrFilterToJson(r["YuLe"].ToString());
                        hotel.KeFang = NormalCommon.StrFilterToJson(r["KeFang"].ToString());
                        hotel.HotelLog = NormalCommon.StrFilterToJson(r["hotellog"].ToString());
                        hotel.Address = NormalCommon.StrFilterToJson(r["Address"].ToString());
                        hotel.Pos = NormalCommon.StrFilterToJson(r["Pos"].ToString());
                    }
                    string json = Newtonsoft.Json.JsonConvert.SerializeObject(hotel);
                    cache.Insert(cacheKey, json, null, DateTime.Now.AddHours(4), TimeSpan.Zero);
                }
                else
                {
                    hotel = Newtonsoft.Json.JsonConvert.DeserializeObject<Models.Hotel>(cache[cacheKey].ToString());
                }
                if (hotel == null)
                {
                    hotel = new Hotel();
                }
                return hotel;
            }
            catch (Exception)
            {
                hotel = new Hotel();
                return hotel;
            }
        }

        public ContentResult getroomimgs()
        {
            int hid = HCRequest.getInt("hid");
            string hotelweixinid = HCRequest.GetString("hotelweixinid");
            string cacheKey = "roomimgs_" + hotelweixinid;
            System.Web.Caching.Cache cache = HttpRuntime.Cache;
            string json = null;
            if (cache[cacheKey] == null)
            {
                string sql = "select small_url,big_url,url,roomid,imgnum,imgtype from roomtypeimg with (nolock) where hotelid=@hid";
                DataTable tb = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                {
                    {"hid",new DBParam(){ParamValue=hid.ToString()}}
                });

                Dictionary<int, List<Img>> imgs = new Dictionary<int, List<Img>>();
                List<int> roomlist = tb.AsEnumerable().Select(r => WeiXinPublic.ConvertHelper.ToInt(r["roomid"])).Distinct().ToList();
                foreach (int rid in roomlist)
                {
                    List<DataRow> rows = tb.AsEnumerable().Where(r => WeiXinPublic.ConvertHelper.ToInt(r["roomid"]) == rid).ToList();
                    imgs.Add(rid, new List<Img>());
                    foreach (DataRow r in rows)
                    {
                        Img img = new Img();
                        img.ImgNum = WeiXinPublic.ConvertHelper.ToInt(r["imgnum"]);
                        string url = r["url"].ToString();
                        object small_url = r["small_url"];
                        object big_url = r["big_url"];
                        img.SmallUrl = small_url == DBNull.Value ? url : small_url.ToString();
                        img.BigUrl = big_url == DBNull.Value ? url : big_url.ToString();
                        img.ImgType = WeiXinPublic.ConvertHelper.ToInt(r["imgtype"]);
                        imgs[rid].Add(img);
                    }
                    imgs[rid] = imgs[rid].OrderByDescending(item => item.ImgNum).ToList();
                }
                json = Newtonsoft.Json.JsonConvert.SerializeObject(imgs);
                cache.Insert(cacheKey, json, null, DateTime.Now.AddHours(4), TimeSpan.Zero);
            }
            else
            {
                json = cache[cacheKey].ToString();
            }
            return Content(json);
        }

        public ContentResult getratejson()
        {
            int hid = HCRequest.getInt("hid");
            DateTime indate = HCRequest.getDate("indate");
            DateTime outdate = HCRequest.getDate("outdate");
            string hotelweixinid = HCRequest.GetString("hotelweixinid");
            double graderate = WeiXinPublic.ConvertHelper.ToDouble(HCRequest.GetString("graderate"));
            double reduce = WeiXinPublic.ConvertHelper.ToDouble(HCRequest.GetString("reduce"));
            int couponType = WeiXinPublic.ConvertHelper.ToInt(HCRequest.GetString("coupontype"));

            string json = getratejson(hid, indate, outdate, hotelweixinid, graderate, reduce, couponType);
            return Content(json);
        }

        public static string getratejson(int hid, DateTime indate, DateTime outdate, string hotelweixinid, double graderate, double reduce, int couponType)
        {
            string firstimgurl = null;
            return getratejson(hid, indate, outdate, hotelweixinid, graderate, out firstimgurl, reduce, couponType);
        }

        public static string getratejson(int hid, DateTime indate, DateTime outdate, string hotelweixinid, double graderate, out string firstimgurl, double reduce, int couponType)
        {
            DateTime now = DateTime.Now;
            string sql = "select ratejson,updatetime from hotelratejson with (nolock) where hotelid=@hotelid";
            DataTable tb = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                {"hotelid",new DBParam(){ParamValue=hid.ToString()}}
            });
            string ratejson = null;
            if (tb.Rows.Count > 0)
            {
                DataRow r = tb.Rows[0];
                ratejson = r["ratejson"].ToString();
            }

            Dictionary<string, WeiXin.Models.Home.Rate> hourroomRates = new Dictionary<string, WeiXin.Models.Home.Rate>();
            Dictionary<string, WeiXin.Models.Home.Rate> roomRates = new Dictionary<string, WeiXin.Models.Home.Rate>();
            List<WeiXin.Models.Home.Room> roomlist = new List<WeiXin.Models.Home.Room>();
            Dictionary<string, object> dic = new Dictionary<string, object>();

            if (!string.IsNullOrEmpty(ratejson))
            {
                //查询库存
                sql = "select  stockdate, rid, quantity,actualqty,havesale   from roomstock with (nolock) where hid=@hotelid    and stockdate>= CONVERT(date,GETDATE())";
                tb = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                {"hotelid",new DBParam(){ParamValue=hid.ToString()}}
            });

                var list_RoomStock = WeiXin.Common.DataTableToEntity.GetEntities<WeiXin.Models.Home.RoomStock>(tb).ToList();


                roomlist = Newtonsoft.Json.JsonConvert.DeserializeObject<List<WeiXin.Models.Home.Room>>(ratejson);

                


                if (roomlist == null)
                {
                    roomlist = new List<WeiXin.Models.Home.Room>();
                }

                int days = (outdate - indate).Days;
                int hour = DateTime.Now.Hour;
                foreach (WeiXin.Models.Home.Room room in roomlist)
                {
                    room.Remark = null;
                    foreach (WeiXin.Models.Home.RatePlan rateplan in room.RateplanList)
                    {
                        if (rateplan.IsFreeroom == 1 || rateplan.IsDist == 1)
                        {
                            continue;
                        }

                        rateplan.RateList.ForEach(r =>
                        {
                            var curr_stock = list_RoomStock.Where(c => c.Rid == room.ID && c.StockDate == Convert.ToDateTime(r.Dates)).FirstOrDefault(); r.RoomStock = curr_stock == null ? 19 : (curr_stock.Quantity - curr_stock.HaveSale > 0 ? curr_stock.Quantity - curr_stock.HaveSale : 0);
                        });

                        List<WeiXin.Models.Home.Rate> ratelist = rateplan.RateList.Where(ra => Convert.ToDateTime(ra.Dates).CompareTo(indate) >= 0 && Convert.ToDateTime(ra.Dates).CompareTo(outdate) < 0).ToList();
                        string roomtypeid = string.Format("{0}_{1}", room.ID, rateplan.ID);
                        WeiXin.Models.Home.Rate rate = new WeiXin.Models.Home.Rate();
                        if (ratelist.Count > 0)
                        {
                            int sumprice = ratelist.Sum(ra => ra.Price);
                            int _days = ratelist.Count(ra => ra.Price > 0);
                            if (_days == 0)
                            {
                                continue;
                            }
                            int state = 1;
                            if (ratelist.Count < days || ratelist.Exists(ra => ra.Available == 0) || ratelist.Exists(ra => ra.Price <= 0))
                            {
                                state = 0;
                            }
                            ////把实际房态写到携程房态作为临时字段，按照这个字段来排序价格
                            //rate.CtripState = state;
                            ////此价格计划为会员专享，如预订人不是会员，则房态为满房
                            //if (rateplan.IsVip == 1 && graderate == 0)
                            //{
                            //    state = 0;
                            //}
                            rate.Available = state;
                            rate.Price = Convert.ToInt32(Math.Ceiling(sumprice * 1.0 / _days));
                            //把价格写到携程价格作为临时字段，按照这个字段来排序价格
                            rate.CtripPrice = Convert.ToInt32(Math.Ceiling(sumprice * 1.0 / _days));
                            //此价格计划为非会员专享，如有会员折扣，则打折
                            //if (rateplan.IsVip == 0 && graderate > 0)
                            //{
                            //    //rate.CtripPrice = (int)(rate.CtripPrice * graderate / 10);
                            //    rate.CtripPrice = Convert.ToInt32(Math.Ceiling(rate.CtripPrice * graderate / 10));
                            //}

                            //查询当前订房日期的最小库存
                            rate.RoomStock = ratelist.Min(c => c.RoomStock);
                            if (rateplan.IsOverBook == 1)
                            {
                                rate.RoomStock = 99;
                            }



                            if (rate.RoomStock == 0)
                            {
                                rate.Available = 0;
                            }

                            if (rateplan.IsVip == 0)
                            {
                                //折扣
                                if (couponType == 0 && graderate > 0)
                                {
                                    rate.CtripPrice = Convert.ToInt32(rate.CtripPrice * graderate / 10);
                                }
                                //立减金额
                                else if (couponType == 1 && reduce > 0)
                                {
                                    if (rate.CtripPrice > reduce)
                                    {
                                        rate.CtripPrice = Convert.ToInt32(rate.CtripPrice - reduce);
                                    }
                                }
                            }



                        }
                        //只有预订一天的才有钟点房显示，钟点房只支付预付房型
                        if (WeiXinPublic.ConvertHelper.ToInt(rateplan.IsHourRoom) == 1 && rateplan.PayType == "0")
                        {
                            if (days == 1 && rate.Price > 0 && rate.Available == 1)
                            {

                                //非当天或者当天可以预定
                                if (indate.Date.CompareTo(now.Date) != 0 || (indate.Date.CompareTo(now.Date) == 0 && rateplan.EndHour - WeiXinPublic.ConvertHelper.ToInt(rateplan.HourRoomType) > hour))
                                { 
                                    hourroomRates.Add(roomtypeid, rate);
                                }


                            }
                        }
                        else if (WeiXinPublic.ConvertHelper.ToInt(rateplan.IsHourRoom) == 0)
                        {
                            roomRates.Add(roomtypeid, rate);
                        }

                        if (rate.Available == 0)
                        {
                            rateplan.RateList = new List<WeiXin.Models.Home.Rate>();
                        }
                        else
                        {
                            rateplan.RateList = rateplan.RateList.Where(ra => Convert.ToDateTime(ra.Dates).CompareTo(indate) >= 0 && Convert.ToDateTime(ra.Dates).CompareTo(outdate) < 0).ToList();
                        }
                    }
                }

                if (hourroomRates.Count > 0)
                {
                    hourroomRates = hourroomRates.OrderBy(ra =>
                    {
                        if (ra.Value.Available == 1)
                        {
                            return ra.Value.CtripPrice;
                        }
                        return 99999 + ra.Value.CtripPrice;
                    }).ToDictionary(item => item.Key, item => item.Value);
                }

                if (roomRates.Count > 0)
                {
                    roomRates = roomRates.OrderBy(ra =>
                    {
                        if (ra.Value.Available == 1)
                        {
                            return ra.Value.CtripPrice;
                        }
                        return 99999 + ra.Value.CtripPrice;
                    }).ToDictionary(item => item.Key, item => item.Value);
                }
            }
            dic.Add("roomlist", roomlist);
            dic.Add("hourroomRates", hourroomRates);
            dic.Add("roomRates", roomRates);

            Dictionary<int, List<Img>> imgdic = getimglist(hid, hotelweixinid);
            dic.Add("roomImgs", imgdic);
            firstimgurl = null;
            if (imgdic.ContainsKey(0))
            {
                if (imgdic[0].Count > 0)
                {
                    firstimgurl = imgdic[0].First().BigUrl;
                }
            }

            wkn_StatisticsCount StatisticsCount = getStatisticsCount(hid, hotelweixinid);
            dic.Add("StatisticsCount", StatisticsCount);

            string tokenkey = DateTime.Now.Ticks.ToString();
            string token = hotel3g.Models.DES.DESEncrypt(tokenkey, "wkn128uu");
            dic.Add("tokenkey", tokenkey);
            dic.Add("token", token);

            string json = Newtonsoft.Json.JsonConvert.SerializeObject(dic);
            return json;
        }

        public static Dictionary<int, List<WeiXin.Models.Img>> getimglist(int hotelid, string hotelweixinid)
        {
            string cacheKey = "roomimgs_" + hotelweixinid + "_" + hotelid;
            System.Web.Caching.Cache cache = HttpRuntime.Cache;
            string imagejson = null;
            List<Img> list = null;
            try
            {
                if (cache[cacheKey] == null)
                {
                    string sql = "select imagejson from roomimagejson with (nolock) where hotelid=@hotelid";
                    imagejson = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"hotelid",new DBParam(){ParamValue=hotelid.ToString()}}
                    });
                    list = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Img>>(imagejson);
                    if (list != null)
                    {
                        list = list.OrderByDescending(c => c.ImgNum).ToList();
                    }

                    cache.Insert(cacheKey, imagejson, null, DateTime.Now.AddMinutes(10), TimeSpan.Zero);
                }
                else
                {
                    imagejson = cache[cacheKey].ToString();
                    list = Newtonsoft.Json.JsonConvert.DeserializeObject<List<Img>>(imagejson);

                }
            }
            catch (Exception)
            {
            }

            if (list == null)
            {
                list = new List<Img>();
            }

            Dictionary<int, List<Img>> dic = new Dictionary<int, List<Img>>();
            foreach (Img img in list)
            {
                int rid = WeiXinPublic.ConvertHelper.ToInt(img.RoomID);
                if (!dic.ContainsKey(rid))
                {
                    dic.Add(rid, new List<Img>());
                }
                if (string.IsNullOrEmpty(img.SmallUrl))
                {
                    img.SmallUrl = img.Url;
                }
                if (string.IsNullOrEmpty(img.BigUrl))
                {
                    img.BigUrl = img.Url;
                }
                dic[rid].Add(img);
            }
            return dic;
        }

        public ContentResult getStatisticsCount()
        {
            int hid = HCRequest.getInt("hid");
            string userWeixinid = HCRequest.GetString("userWeixinid");
            string hotelWeixinid = HCRequest.GetString("hotelWeixinid");
            wkn_StatisticsCount StatisticsCount = getStatisticsCount(hid, hotelWeixinid);
            string json = Newtonsoft.Json.JsonConvert.SerializeObject(StatisticsCount);
            return Content(json);
        }

        private static wkn_StatisticsCount getStatisticsCount(int hid, string hotelWeixinid)
        {
            string cacheKey = "StatisticsCount_" + hotelWeixinid;
            System.Web.Caching.Cache cache = HttpRuntime.Cache;
            wkn_StatisticsCount StatisticsCount = null;
            try
            {
                if (cache[cacheKey] == null)
                {
                    string sql = "select top 1 SaleProduct,MembershipCard,GGL,Turntable,CouPon from wkn_StatisticsCount with (nolock) where WeixinId=@WeixinId and hotelid=@hotelid";
                    DataTable tb = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"WeixinId",new DBParam(){ParamValue=hotelWeixinid}},
                        {"hotelid",new DBParam(){ParamValue=hid.ToString()}}
                    });
                    StatisticsCount = new wkn_StatisticsCount();
                    if (tb.Rows.Count > 0)
                    {
                        DataRow r = tb.Rows[0];
                        StatisticsCount.SaleProduct = WeiXinPublic.ConvertHelper.ToInt(r["SaleProduct"]);
                        StatisticsCount.MembershipCard = WeiXinPublic.ConvertHelper.ToInt(r["MembershipCard"]);
                        StatisticsCount.GGL = WeiXinPublic.ConvertHelper.ToInt(r["GGL"]);
                        StatisticsCount.Turntable = WeiXinPublic.ConvertHelper.ToInt(r["Turntable"]);
                        StatisticsCount.CouPon = WeiXinPublic.ConvertHelper.ToInt(r["CouPon"]);
                    }
                    cache.Insert(cacheKey, StatisticsCount, null, DateTime.Now.AddMinutes(30), TimeSpan.Zero);
                }
                else
                {
                    StatisticsCount = cache[cacheKey] as wkn_StatisticsCount;
                }
            }
            catch (Exception)
            {
            }

            if (StatisticsCount == null)
            {
                StatisticsCount = new wkn_StatisticsCount();
            }

            //sql = "select count(a.id) c from coupon a with (nolock) left join couponcontent b with (nolock) on a.id=b.typeid and b.userweixinno=@userweixinid where a.weixinid=@hotelweixinid and a.endable=1 and a.exttime>convert(date,getdate()) and b.id is null";
            //int CouPonCount = WeiXinPublic.ConvertHelper.ToInt(SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            //{
            //    {"userweixinid",new DBParam(){ParamValue=userWeixinid}},
            //    {"hotelweixinid",new DBParam(){ParamValue=hotelWeixinid}}
            //}));
            //StatisticsCount.CouPon = CouPonCount;

            return StatisticsCount;
        }

        public ContentResult getgroupsale()
        {
            int hid = HCRequest.getInt("hid");
            string hotelweixinid = HCRequest.GetString("hotelweixinid");
            int count = 0;
            int page = 1;
            int pagesize = 2;
            List<WeiXin.Models.Home.SaleProduct> list = WeiXin.Models.Home.SaleProduct.GetSaleProducts(hotelweixinid, out count, page, pagesize, "", "");
            List<WeiXin.Models.Home.SaleProduct> productlist = new List<WeiXin.Models.Home.SaleProduct>();
            for (int i = 0; i < list.Count; i++)
            {
                if (i < 2)
                {
                    WeiXin.Models.Home.SaleProduct saleproduct = list[i];
                    saleproduct.ProductPrice = WeiXin.Models.Home.SaleProduct.GetSaleProductMinPrice(saleproduct.Id, saleproduct.ProductType);
                    productlist.Add(saleproduct);
                }
            }

            string json = Newtonsoft.Json.JsonConvert.SerializeObject(productlist);
            return Content(json);
        }




        /// <summary>
        /// 收藏功能
        /// </summary>
        /// <returns></returns>
        [Models.Filter]
        [HttpPost]
        public ActionResult Collection()
        {
            int j_status = -1;
            string errmsg = "";

            //0 取消收藏 1收藏
            int collectionStatus = HCRequest.getInt("status");

            string hotelweixinid = HCRequest.GetString("hotelweixinid");
            string userweixinid = HCRequest.GetString("userweixinid");
            int hotelId = HCRequest.getInt("hotelId");
            string type = HCRequest.GetString("type");
            string url = HCRequest.GetString("url");
            string op = HCRequest.GetString("op").ToLower();
            string scName = HCRequest.GetString("scName").ToLower();

            var dic = new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
             {"userweixinId",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinid}},
             {"HotelId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelId.ToString()}},
             {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelweixinid}},
             {"Url",new HotelCloud.SqlServer.DBParam{ParamValue=url}},
             {"Type",new HotelCloud.SqlServer.DBParam{ParamValue=type}},            
             {"Status",new HotelCloud.SqlServer.DBParam{ParamValue=collectionStatus.ToString()}},
             {"Name",new HotelCloud.SqlServer.DBParam{ParamValue=scName}},
            };



            string obj_query = HotelCloud.SqlServer.SQLHelper.Get_Value("select status  from CollectionHotel with(nolock)  where userweixinId=@userweixinId  and HotelId=@HotelId  and Type=@Type ", HotelCloud.SqlServer.SQLHelper.GetCon(), dic);

            //查询操作
            if (op == "query")
            {
                j_status = 0;

                if (!string.IsNullOrEmpty(obj_query) && obj_query.ToString() == "1")
                {
                    errmsg = "ok";
                }

                return Json(new
                {
                    Status = j_status,
                    Mess = errmsg

                }, JsonRequestBehavior.AllowGet);
            }


            if (string.IsNullOrEmpty(obj_query))
            {
                StringBuilder strSql = new StringBuilder();
                strSql.Append("insert into CollectionHotel(");
                strSql.Append("userweixinId,HotelId,weixinId,Url,Type,Status,AddTime,LastUpdateTime,Name");
                strSql.Append(") values (");
                strSql.Append("@userweixinId,@HotelId,@weixinId,@Url,@Type,@Status,getdate(),getdate(),@Name");
                strSql.Append(") ");
                strSql.Append(";select @@IDENTITY");
                string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), dic);

                if (!string.IsNullOrEmpty(obj))
                {
                    j_status = 0;
                }

            }


            else
            {

                StringBuilder strSql = new StringBuilder();
                strSql.Append("update CollectionHotel set ");
                strSql.Append(" Url = @Url , ");
                strSql.Append(" Status = @Status  ,");
                strSql.Append(" Name = @Name  ");
                strSql.Append(" where userweixinId=@userweixinId  and HotelId=@HotelId  and Type=@Type  ");
                int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), dic);
                if (row > 0)
                {
                    j_status = 0;
                }
            }


            return Json(new
            {
                Status = j_status,
                Mess = errmsg

            }, JsonRequestBehavior.AllowGet);

        }


        [Models.Filter]
        public ContentResult getCouponlist()
        {

            //0 1 2 3 4 酒店订房 自营餐饮  团购预售  酒店超市   周边商家
            string hotelweixinid = HCRequest.GetString("hotelweixinid");
            string userweixinid = HCRequest.GetString("userweixinid");
            string type = HCRequest.GetString("type");

            string sql = "select c.id,c.moneys,c.stime,c.exttime,p.amountlimit,p.scopelimit  from couponcontent c with (nolock)  left join  CouPon p with(nolock)  on  c.typeID=p.id  and c.typeID is not null  where c.weixinid=@hotelweixinid and c.userweixinno=@userweixinid and c.isemploy=0 and convert(date,getdate())>=c.stime and c.exttime>=convert(date,getdate())";
            DataTable tb = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                {"hotelweixinid",new DBParam(){ParamValue=hotelweixinid}},
                {"userweixinid",new DBParam(){ParamValue=userweixinid}}
            });
            Dictionary<string, WeiXin.Models.Home.CouPonContent> dic = new Dictionary<string, WeiXin.Models.Home.CouPonContent>();
            foreach (DataRow r in tb.Rows)
            {

                WeiXin.Models.Home.CouPonContent coupon = new WeiXin.Models.Home.CouPonContent();
                coupon.Id = WeiXinPublic.ConvertHelper.ToInt(r["id"]);
                coupon.Moneys = WeiXinPublic.ConvertHelper.ToInt(r["moneys"]);
                coupon.sTime = WeiXinPublic.ConvertHelper.ToDateTime(r["sTime"]);
                coupon.ExtTime = WeiXinPublic.ConvertHelper.ToDateTime(r["ExtTime"]);
                coupon.AmountLimit = Convert.ToInt32(WeiXinPublic.ConvertHelper.ToDouble(r["AmountLimit"]));


                if (type == "hotel")
                {
                    if (WeiXinPublic.ConvertHelper.ToString(r["scopelimit"]) == string.Empty || WeiXinPublic.ConvertHelper.ToString(r["scopelimit"]).Contains("0"))
                    {
                        dic.Add("_" + coupon.Id.ToString(), coupon);
                    }
                }

                else if (type == "tuan")
                {
                    if (WeiXinPublic.ConvertHelper.ToString(r["scopelimit"]).Contains("2"))
                    {
                        dic.Add("_" + coupon.Id.ToString(), coupon);
                    }
                }


            }
            dic = dic.OrderByDescending(cou =>
            {
                return cou.Value.Moneys;
            }).ThenBy(cou =>
            {
                return (cou.Value.ExtTime - default(DateTime)).TotalMinutes;
            }).ToDictionary(item => item.Key, item => item.Value);
            string json = Newtonsoft.Json.JsonConvert.SerializeObject(dic);
            return Content(json);
        }

        public ContentResult getMemberCardIntegralRule()
        {
            string userWeixinid = HCRequest.GetString("userWeixinid");
            string hotelWeixinid = HCRequest.GetString("hotelWeixinid");
            string json = getMemberCardIntegralRule(userWeixinid, hotelWeixinid);
            return Content(json);
        }

        public static string getMemberCardIntegralRule(string userWeixinid, string hotelWeixinid)
        {
            string cardno = hotel3g.Repository.MemberHelper.GetCardNo(userWeixinid, hotelWeixinid);
            Dictionary<string, object> dic = new Dictionary<string, object>();
            hotel3g.Repository.MemberCardIntegralRule rule = new Repository.MemberCardIntegralRule();
            bool becomeMember = false;
            string MemberId = null;
            string username = string.Empty;
            string mobile = string.Empty;

            if (!string.IsNullOrEmpty(cardno))
            {
                hotel3g.Repository.MemberInfo memberinfo = hotel3g.Repository.MemberHelper.GetMemberInfo(hotelWeixinid);
                hotel3g.Repository.MemberCard membercard = hotel3g.Repository.MemberHelper.GetMemberCard(cardno, hotelWeixinid);
                rule = hotel3g.Repository.MemberHelper.IntegralRule(memberinfo, membercard);
                MemberId = membercard.memberid;
                username = membercard.name;
                mobile = membercard.phone;
            }
            else
            {
                hotel3g.Repository.MemberInfo memberinfo = hotel3g.Repository.MemberHelper.GetMemberInfo(hotelWeixinid);
                if (memberinfo != null)
                {
                    memberinfo.intro = null;
                    dic.Add("memberinfo", memberinfo);
                    becomeMember = true;
                }
            }
            dic.Add("becomeMember", becomeMember);
            dic.Add("memberid", MemberId);

            dic.Add("username", username);
            dic.Add("mobile", mobile);

            dic.Add("rule", rule);
            string json = Newtonsoft.Json.JsonConvert.SerializeObject(dic);
            return json;
        }

        [Models.Filter]
        public ContentResult saveorderinfo()
        {
            try
            {
                Dictionary<string, object> result = new Dictionary<string, object>();
                string source = "weixinweb";
                string saveinfo = HCRequest.GetString("saveinfo");
                Hashtable saveinfotable = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(saveinfo);
                DateTime now = DateTime.Now;
                string orderno = string.Format("w{0}", now.ToString("yyMMddHHmmssfff"));
                string weixinid = saveinfotable["weixinid"].ToString();
                string userWeixinid = saveinfotable["userWeixinid"].ToString();
                int couponid = Convert.ToInt32(saveinfotable["couponid"]);
                if (couponid > 0)
                {

                    bool couPonEnable = WeiXin.Models.Home.CouPonContent.IsCouPonContentEnable(weixinid, userWeixinid, couponid);
                    if (!couPonEnable)
                    {
                        result.Add("success", false);
                        result.Add("message", "红包已被使用，不能再次使用");
                        string _json = Newtonsoft.Json.JsonConvert.SerializeObject(result);
                        return Content(_json);
                    }

                    //string sqls = string.Format("select  isemploy from couponcontent with (nolock) where  id=@couponid and weixinid=@weixinid and userweixinno=@userweixinid ", couponid);

                    //string isemploy = SQLHelper.Get_Value(sqls, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    //{
                    //    {"weixinid",new DBParam(){ParamValue=weixinid}},
                    //    {"userweixinid",new DBParam(){ParamValue=userWeixinid}},
                    //     {"couponid",new DBParam(){ParamValue=couponid.ToString()}}
                    //});
                    //if (isemploy != "0")
                    //{
                    //    result.Add("success", false);
                    //    result.Add("message", "红包已被使用，不能再次使用");
                    //    string _json = Newtonsoft.Json.JsonConvert.SerializeObject(result);
                    //    return Content(_json);
                    //}
                }

                string token = saveinfotable["token"].ToString();
                string sourceorderid = null;
                try
                {
                    sourceorderid = hotel3g.Models.DES.DESDecrypt(token, "wkn128uu");
                }
                catch (Exception)
                {
                    sourceorderid = DateTime.Now.ToString("yyyyMMddHHmmssffff");
                }



                var tgyModel = hotel3g.Models.MemberFxLogic.GetTuiGuangProfit(ProfitType.kefang, weixinid, userWeixinid, Convert.ToInt32(saveinfotable["ssumprice"]));

                SQLMerge.MergeScript script = new SQLMerge.MergeScript("hotelorder");
                script.AddInsertField("OrderNO").AddInsertField("LinkTel").AddInsertField("UserName").AddInsertField("UserWeiXinID").AddInsertField("HotelID").AddInsertField("HotelName").AddInsertField("WeiXinID").AddInsertField("RoomID").AddInsertField("RoomName").AddInsertField("demo").AddInsertField("RatePlanID").AddInsertField("RatePlanName").AddInsertField("yRoomNum").AddInsertField("yinDate").AddInsertField("youtDate").AddInsertField("Ordertime").AddInsertField("PayType").AddInsertField("lastTime").AddInsertField("state").AddInsertField("yPriceStr").AddInsertField("ySumPrice").AddInsertField("sSumPrice").AddInsertField("fpSubmitPrice").AddInsertField("Source").AddInsertField("jifen").AddInsertField("ishourroom").AddInsertField("hourstarttime").AddInsertField("hourendtime").AddInsertField("foregift").AddInsertField("foregiftstate")
    .AddInsertField("needinvoice").AddInsertField("invoicestate").AddInsertField("invoicetitle").AddInsertField("CouponInfo").AddInsertField("sourceorderid").AddInsertField("UserID").AddInsertField("promoterid").AddInsertField("fxCommission").AddInsertField("fxmoneyprofit").AddInsertField("invoicenum");
                script.AddCriteria("Source").AddCriteria("sourceorderid");

                string yPriceStr = string.Empty;
                List<string> priceAry = saveinfotable["priceAry"].ToString().Split(new string[] { "|" }, StringSplitOptions.RemoveEmptyEntries).ToList();
                foreach (string item in priceAry)
                {
                    DateTime time = WeiXinPublic.ConvertHelper.ToDateTime(item.Remove(item.IndexOf(":")));
                    int price = WeiXinPublic.ConvertHelper.ToInt(item.Substring(item.IndexOf(":") + 1));
                    yPriceStr += string.Format("price{0}|{1}|money{0}|0|", time.ToString("yyyy-MM-dd"), price);
                }
                int fpSubmitPrice = 0;
                int sSumPrice = 0;
                int paytype = Convert.ToInt32(saveinfotable["paytype"]);
                if (paytype == 1)
                {
                    fpSubmitPrice = Convert.ToInt32(saveinfotable["ssumprice"]);
                }
                else
                {
                    sSumPrice = Convert.ToInt32(saveinfotable["ssumprice"]);
                }
                int ishourroom = Convert.ToInt32(saveinfotable["ishourroom"]);
                string hourstarttime = null;
                string hourendtime = null;
                string lasttime = null;
                if (ishourroom == 1)
                {
                    hourstarttime = saveinfotable["hourstarttime"].ToString();
                    hourendtime = saveinfotable["hourendtime"].ToString();
                }
                else
                {
                    lasttime = saveinfotable["lasttime"].ToString();
                }
                int needinvoice = Convert.ToInt32(saveinfotable["needinvoice"]);
                string invoicetitle = null;
                string invoicenum = null;
                if (needinvoice == 1)
                {
                    invoicetitle = saveinfotable["invoicetitle"].ToString();
                    invoicenum = saveinfotable["invoicenum"].ToString();
                }
                string demo = null;
                if (!saveinfotable["demo"].ToString().Equals("无"))
                {
                    demo = saveinfotable["demo"].ToString();
                }

                Dictionary<string, object> CouponInfoDic = new Dictionary<string, object>();
                if (couponid > 0)
                {
                    CouponInfoDic.Add("CouponId", couponid);
                    CouponInfoDic.Add("CouPon", Convert.ToInt32(saveinfotable["couponprice"]));
                }
                object gradename = saveinfotable["gradename"];
                int isvip = WeiXinPublic.ConvertHelper.ToInt(saveinfotable["isvip"]);
                //会员专享不能享受打折优惠，只有为非会员专享时才添加折扣信息
                if (isvip != 1)
                {
                    double graderate = WeiXinPublic.ConvertHelper.ToDouble(saveinfotable["graderate"]);
                    CouponInfoDic.Add("GradeRate", graderate);
                    CouponInfoDic.Add("Reduce", WeiXinPublic.ConvertHelper.ToDouble(saveinfotable["reduce"]));
                }
                CouponInfoDic.Add("GradeName", gradename == null ? string.Empty : gradename.ToString());
                CouponInfoDic.Add("IsVip", isvip);

                CouponInfoDic.Add("CouponType", WeiXinPublic.ConvertHelper.ToInt(saveinfotable["coupontype"]));

                string couponinfo = Newtonsoft.Json.JsonConvert.SerializeObject(CouponInfoDic);
                int jifen = WeiXinPublic.ConvertHelper.ToInt(saveinfotable["jifen"]);
                DateTime indate = WeiXinPublic.ConvertHelper.ToDateTime(saveinfotable["yindate"]);
                DateTime outdate = WeiXinPublic.ConvertHelper.ToDateTime(saveinfotable["youtdate"]);

                Dictionary<string, object> dic = new Dictionary<string, object>();
                dic.Add("OrderNO", orderno);
                dic.Add("LinkTel", saveinfotable["linktel"].ToString());
                dic.Add("UserName", saveinfotable["username"].ToString());
                dic.Add("UserWeiXinID", userWeixinid);
                dic.Add("HotelID", saveinfotable["hotelid"].ToString());
                dic.Add("HotelName", saveinfotable["hotelname"].ToString());
                dic.Add("WeiXinID", weixinid);
                dic.Add("UserID", 0);
                dic.Add("RoomID", saveinfotable["roomid"].ToString());
                dic.Add("RoomName", saveinfotable["roomname"].ToString());
                dic.Add("demo", demo);
                dic.Add("RatePlanID", saveinfotable["rateplanid"].ToString());
                dic.Add("RatePlanName", saveinfotable["rateplanname"].ToString());
                dic.Add("yRoomNum", saveinfotable["yroomnum"].ToString());
                dic.Add("yinDate", indate.ToString());
                dic.Add("youtDate", outdate.ToString());
                dic.Add("Ordertime", now);
                dic.Add("PayType", paytype);
                dic.Add("lastTime", lasttime);
                dic.Add("state", 1);    //待处理
                dic.Add("yPriceStr", yPriceStr);
                dic.Add("ySumPrice", Convert.ToInt32(saveinfotable["originalsaleprice"]));
                dic.Add("sSumPrice", sSumPrice);
                dic.Add("fpSubmitPrice", fpSubmitPrice);
                dic.Add("Source", source);
                dic.Add("jifen", jifen);
                dic.Add("ishourroom", saveinfotable["ishourroom"].ToString());
                dic.Add("hourstarttime", hourstarttime);
                dic.Add("hourendtime", hourendtime);
                dic.Add("foregift", saveinfotable["foregift"]);
                dic.Add("foregiftstate", 1);
                dic.Add("needinvoice", needinvoice);
                dic.Add("invoicetitle", invoicetitle);
                dic.Add("invoicestate", 1);
                dic.Add("CouponInfo", couponinfo);
                dic.Add("sourceorderid", sourceorderid);
                dic.Add("promoterid", tgyModel.promoterid);
                dic.Add("fxCommission", tgyModel.hotelCommission);
                dic.Add("fxmoneyprofit", tgyModel.userCommission);
                dic.Add("invoicenum", invoicenum);
                script.ListValues.Add(dic);
                string sql = script.SQL();

                int rows = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), null);
                result.Add("success", rows > 0);
                if (rows > 0)
                {
                    sql = "select id from hotelorder with (nolock) where source=@source and sourceorderid=@sourceorderid";
                    int orderid = WeiXinPublic.ConvertHelper.ToInt(SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"source",new DBParam(){ParamValue=source}},
                        {"sourceorderid",new DBParam(){ParamValue=sourceorderid}}
                    }));
                    if (couponid > 0)
                    {
                        if (orderid > 0)
                        {
                            sql = "update couponcontent set isemploy=1,employtime=@time,orderid=@orderid where id=@couponid and weixinid=@weixinid and userweixinno=@userweixinid";
                            SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                            {
                                {"time",new DBParam(){ParamValue=now.ToString()}},
                                {"orderid",new DBParam(){ParamValue=orderid.ToString()}},
                                {"couponid",new DBParam(){ParamValue=couponid.ToString()}},
                                {"weixinid",new DBParam(){ParamValue=weixinid}},
                                {"userweixinid",new DBParam(){ParamValue=userWeixinid}}
                            });
                        }
                    }
                    if (jifen > 0)
                    {
                        //sql = "update Member set Emoney+=@Emoney where weixinID=@weixinID and userWeiXinNO=@userWeiXinNO";
                        //int rs = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                        //{
                        //    {"Emoney",new DBParam(){ParamValue=jifen.ToString()}},
                        //    {"weixinID",new DBParam(){ParamValue=weixinid}},
                        //    {"userWeiXinNO",new DBParam(){ParamValue=userWeixinid}},
                        //});

                        string cardno = saveinfotable["cardno"] == null ? string.Empty : saveinfotable["cardno"].ToString();
                        string memberid = saveinfotable["memberid"] == null ? string.Empty : saveinfotable["memberid"].ToString();
                        sql = "insert into jifendetail (weixinid,userweixinid,jifen,addtime,orderid,night,cardno,userid) values (@weixinid,@userweixinid,@jifen,@addtime,@orderid,@night,@cardno,@userid)";
                        int rs = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                        {
                            {"weixinid",new DBParam(){ParamValue=weixinid}},
                            {"userweixinid",new DBParam(){ParamValue=userWeixinid}},
                            {"jifen",new DBParam(){ParamValue=jifen.ToString()}},
                            {"addtime",new DBParam(){ParamValue=DateTime.Now.ToString()}},
                            {"orderid",new DBParam(){ParamValue=orderid.ToString()}},
                            {"night",new DBParam(){ParamValue=(outdate-indate).Days.ToString()}},
                            {"cardno",new DBParam(){ParamValue=cardno}},
                            {"userid",new DBParam(){ParamValue=memberid}},
                        });
                    }


                    int roomstock = MemberCardBuyRecord.ReduceRoomStock(Convert.ToInt32(saveinfotable["hotelid"].ToString()), Convert.ToInt32(saveinfotable["roomid"].ToString()), indate, outdate, Convert.ToInt32(saveinfotable["yroomnum"].ToString()));

                    result.Add("message", "提交成功！");
                    result.Add("orderno", orderno);
                    result.Add("orderid", orderid);
                }
                else
                {
                    sql = "select count(1) from hotelorder with (nolock) where source=@source and sourceorderid=@sourceorderid";
                    int c = WeiXinPublic.ConvertHelper.ToInt(SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"source",new DBParam(){ParamValue=source}},
                        {"sourceorderid",new DBParam(){ParamValue=sourceorderid}}
                    }));
                    result.Add("message", c > 0 ? "已存在订单不要重复提交！" : "提交失败！");
                }

                string json = Newtonsoft.Json.JsonConvert.SerializeObject(result);
                return Content(json);
            }
            catch (Exception ex)
            {
                Dictionary<string, object> result = new Dictionary<string, object>();
                result.Add("message", ex.Message + ex.StackTrace);
                result.Add("success", false);
                string json = Newtonsoft.Json.JsonConvert.SerializeObject(result);
                return Content(json);
            }
        }

        public ContentResult getorderinfo()
        {
            string hotelweixinid = HCRequest.GetString("hotelweixinid");
            string userweixinid = HCRequest.GetString("userweixinid");
            int orderid = HCRequest.getInt("orderid");

            string sql;
            HotelOrder order = getorderinfo(hotelweixinid, userweixinid, orderid);

            WeiXin.Models.Home.Room room = new WeiXin.Models.Home.Room();
            if (order.ID != 0)
            {
                sql = "select bedtype,addbed,nettype from hotelroom with (nolock) where hotelid=@hotelid and id=@roomid";
                DataTable table = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                {
                    {"hotelid",new DBParam(){ParamValue=order.HotelID.ToString()}},
                    {"roomid",new DBParam(){ParamValue=order.RoomID}}
                });
                if (table.Rows.Count > 0)
                {
                    DataRow r = table.Rows[0];
                    room.AddBed = r["AddBed"].ToString();
                    room.BedType = r["BedType"].ToString();
                    room.NetType = r["NetType"].ToString();
                }
            }

            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("order", order);
            dic.Add("room", room);
            dic.Add("lasttime", order.OrderTime.AddMinutes(30).ToString("M月d日 HH:mm"));
            if (order.IsHourRoom == 0)
            {
                dic.Add("indate", order.YinDate.ToString("M月d日"));
                dic.Add("outdate", order.YoutDate.ToString("M月d日"));
            }
            else
            {
                dic.Add("indate", string.Format("{0} {1}", order.YinDate.ToString("M月d日"), order.HourStartTime));
                dic.Add("outdate", string.Format("{0} {1}", order.YinDate.ToString("M月d日"), order.HourEndTime));
            }
            dic.Add("ordertime", order.OrderTime.ToString());
            dic.Add("hasconfirm", !(order.ConfirmOrderDate.CompareTo(Convert.ToDateTime("1900-01-01 01:00:00")) == 0));
            string waitconfirmtime = null;
            if (order.YinDate.Date.CompareTo(order.OrderTime.Date) == 0)
            {
                waitconfirmtime = order.AliPayTime.AddHours(2).ToString("HH:mm") + "前";
            }
            else
            {
                waitconfirmtime = "次日11点前";
            }
            dic.Add("waitconfirmtime", waitconfirmtime);

            sql = "select tel,address from hotel with (nolock) where id=@hotelid";
            DataTable hoteltable = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                {"hotelid",new DBParam(){ParamValue=order.HotelID.ToString()}}
            });
            string hoteltel = null;
            string address = null;
            if (hoteltable.Rows.Count > 0)
            {
                DataRow r = hoteltable.Rows[0];
                hoteltel = r["tel"].ToString();
                address = r["address"].ToString();
            }
            dic.Add("hoteltel", hoteltel);
            dic.Add("address", address);
            string json = Newtonsoft.Json.JsonConvert.SerializeObject(dic);
            return Content(json);
        }

        public static HotelOrder getorderinfo(string hotelweixinid, string userweixinid, int orderid)
        {
            HotelOrder order = new HotelOrder();
            string sql = "select * from hotelorder with (nolock) where id=@orderid and weixinid=@weixinid and userweixinid=@userweixinid";
            DataTable tb = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                {"orderid",new DBParam(){ParamValue=orderid.ToString()}},
                {"weixinid",new DBParam(){ParamValue=hotelweixinid}},
                {"userweixinid",new DBParam(){ParamValue=userweixinid}},
                {"source",new DBParam(){ParamValue="weixinweb"}}
            });
            if (tb.Rows.Count > 0)
            {
                DataRow r = tb.Rows[0];
                order.ID = WeiXinPublic.ConvertHelper.ToInt(r["ID"]);
                order.PayType = r["PayType"].ToString();
                order.OrderNO = r["orderno"].ToString();
                order.LinkTel = r["linktel"].ToString();
                order.ySumPrice = WeiXinPublic.ConvertHelper.ToInt(r["ysumprice"]);
                if (order.PayType.Equals("0"))
                {
                    order.sSumPrice = WeiXinPublic.ConvertHelper.ToInt(r["sSumPrice"]);
                }
                else
                {
                    order.sSumPrice = WeiXinPublic.ConvertHelper.ToInt(r["fpsubmitprice"]);
                }
                order.YRoomNum = WeiXinPublic.ConvertHelper.ToInt(r["yroomnum"]);
                order.YinDate = WeiXinPublic.ConvertHelper.ToDateTime(r["YinDate"]);
                order.YoutDate = WeiXinPublic.ConvertHelper.ToDateTime(r["YoutDate"]);
                order.RoomName = r["RoomName"].ToString();
                order.HotelName = r["HotelName"].ToString();
                order.RatePlanName = r["RatePlanName"].ToString();
                order.UserName = r["UserName"].ToString();
                order.HotelID = WeiXinPublic.ConvertHelper.ToInt(r["HotelID"]);
                order.RoomID = r["RoomID"].ToString();
                order.State = WeiXinPublic.ConvertHelper.ToInt(r["State"]);
                if (order.State == 0)
                {
                    order.State = 1;
                }
                order.OrderTime = Convert.ToDateTime(r["OrderTime"]);
                order.NeedInvoice = WeiXinPublic.ConvertHelper.ToInt(r["NeedInvoice"]);
                order.InvoiceState = WeiXinPublic.ConvertHelper.ToInt(r["InvoiceState"]);
                order.InvoiceTitle = r["InvoiceTitle"].ToString();
                order.InvoiceNum = r["InvoiceNum"].ToString();
                order.Foregift = WeiXinPublic.ConvertHelper.ToInt(r["Foregift"]);

                order.ConfirmOrderDate = WeiXinPublic.ConvertHelper.ToDateTime(r["ConfirmOrderDate"]);

                order.IsHourRoom = Convert.ToInt32(r["IsHourRoom"]);
                if (order.IsHourRoom == 0)
                {
                    order.Days = (order.YoutDate - order.YinDate).Days;
                }
                else
                {
                    order.HourStartTime = r["HourStartTime"].ToString();
                    order.HourEndTime = r["HourEndTime"].ToString();
                    order.Hours = WeiXinPublic.ConvertHelper.ToInt(order.HourEndTime.Replace(":00", "").Replace(":30", "")) - WeiXinPublic.ConvertHelper.ToInt(order.HourStartTime.Replace(":00", "").Replace(":30", ""));
                }
                order.AliPayAmount = WeiXinPublic.ConvertHelper.ToDecimal(r["AliPayAmount"]);
                order.RefundFee = WeiXinPublic.ConvertHelper.ToDecimal(r["RefundFee"]);
                order.AliTradeStatus = r["tradeStatus"].ToString();
                order.AliPayTime = WeiXinPublic.ConvertHelper.ToDateTime(r["AliPayTime"]);
                order.CouponInfo = r["CouponInfo"].ToString();
                order.isMeeting = r["isMeeting"].ToString();
                double jifen = 0;
                double.TryParse(r["JiFen"].ToString(), out  jifen);
                order.JiFen = jifen;
                order.PayMethod = r["PayMethod"].ToString();
                order.timeLast = r["lastTime"].ToString();
                if (string.IsNullOrEmpty(order.CouponInfo))
                {
                    order.CouponInfo = "{}";
                }
            }
            return order;
        }

        public ContentResult getSurplusCouponlist()
        {
            string hotelweixinid = HCRequest.GetclearString("hotelweixinid", null);
            string userweixinid = HCRequest.GetclearString("userweixinid", null);
            string sql = "select a.moneys,a.stime,a.exttime,a.id,b.id couponcontentid from coupon a with (nolock) left join couponcontent b with (nolock) on a.id=b.typeid and b.userweixinno=@userweixinid where a.weixinid=@hotelweixinid and a.endable=1 and a.exttime>=convert(date,getdate()) and a.surplusqty>0  and ( isnull(a.scopelimit,'')='' or  CHARINDEX('0',isnull(a.scopelimit,'') )>0 ) ";
            DataTable tb = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                {"hotelweixinid",new DBParam(){ParamValue=hotelweixinid}},
                {"userweixinid",new DBParam(){ParamValue=userweixinid}}
            });


            List<hotel3g.Models.CouPon> list = tb.AsEnumerable().Select(r =>
            {

                hotel3g.Models.CouPon coupon = new CouPon();
                coupon.CouponID = r["id"].ToString();
                coupon.ExtTime = WeiXinPublic.ConvertHelper.ToDateTime(r["ExtTime"]);
                coupon.sTime = WeiXinPublic.ConvertHelper.ToDateTime(r["sTime"]);
                coupon.ExtTimeStr = coupon.ExtTime.ToString("yyyy.MM.dd");
                coupon.sTimeStr = coupon.sTime.ToString("yyyy.MM.dd");
                coupon.Moneys = r["Moneys"].ToString();
                coupon.HaveGet = r["couponcontentid"] == DBNull.Value ? 0 : 1;
                return coupon;

            }).ToList();
            string json = Newtonsoft.Json.JsonConvert.SerializeObject(list);
            return Content(json);
        }

        public string clearImgCache()
        {
            string hotelweixinid = HCRequest.GetString("hotelweixinid");
            int hotelid = HCRequest.getInt("hotelid");
            string cacheKey = "roomimgs_" + hotelweixinid + "_" + hotelid;
            object bef = HttpRuntime.Cache[cacheKey];
            //System.Web.Caching.Cache cache = HttpRuntime.Cache;
            //cache.Insert(cacheKey, null, null, DateTime.Now.AddSeconds(-1), TimeSpan.Zero);
            Cache.RemoveCache(cacheKey);
            object aft = HttpRuntime.Cache[cacheKey];
            string json = string.Format("weixinid:{2},bef:{0},aft:{1}", bef == null, aft == null, hotelweixinid);
            return json;
        }

        public ContentResult cancelOrder()
        {
            string hotelweixinid = HCRequest.GetclearString("hotelweixinid", null);
            string userweixinid = HCRequest.GetclearString("userweixinid", null);
            int id = HCRequest.getInt("id");
            string sql = "update hotelorder set state=2 where id=@id and weixinid=@weixinid and userweixinid=@userweixinid";
            int rs = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                {"id",new DBParam(){ParamValue=id.ToString()}},
                {"weixinid",new DBParam(){ParamValue=hotelweixinid}},
                {"userweixinid",new DBParam(){ParamValue=userweixinid}}
            });

            if (rs > 0)
            {
                sql = "update couponcontent set isemploy=0 where orderid=@orderid and weixinid=@weixinid and userweixinno=@userweixinid";
                SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                {
                    {"orderid",new DBParam(){ParamValue=id.ToString()}},
                    {"weixinid",new DBParam(){ParamValue=hotelweixinid}},
                    {"userweixinid",new DBParam(){ParamValue=userweixinid}}
                });
            }

            if (rs > 0)
            {
                int rows = MemberCardBuyRecord.CancelOrderAddCRoomStock(id);
            }

            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("message", rs > 0 ? "取消成功" : "不能取消");
            dic.Add("success", rs > 0);

            string json = Newtonsoft.Json.JsonConvert.SerializeObject(dic);
            return Content(json);
        }

        private class wkn_StatisticsCount
        {
            public int SaleProduct { get; set; }
            public int MembershipCard { get; set; }
            public int GGL { get; set; }
            public int Turntable { get; set; }
            public int CouPon { get; set; }
        }
    }
}
