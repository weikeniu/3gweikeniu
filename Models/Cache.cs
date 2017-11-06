using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using HotelCloud.SqlServer;

namespace hotel3g.Models
{
    public class Cache
    {
        public static Hotel GetHotel(int id)
        {
            string name = GetCacheName(id);
            Hotel hotel = GetCacheForNet(name);
            if (hotel == null)
            {
                hotel = GetDataForDB(id);
                SetCache(name, hotel, 10);
            } return hotel;
        }
        public static string GetCacheName(int id)
        {
            return string.Format("hotel_{0}", id);
        }
        private static System.Web.Caching.Cache cache = HttpRuntime.Cache;
        public static Hotel GetCacheForNet(string name)
        {
            string cacheKey = string.Format("s{0}", name);
            Hotel hotel = cache[cacheKey] as Hotel;
            return hotel;
        }

        public static void SetCache(string name, Hotel hotel, int Minutes)
        {
            string cacheKey = string.Format("s{0}", name);
            //cache.Insert(cacheKey, hotel, null, DateTime.Now.AddHours(hours), TimeSpan.Zero);
            cache.Insert(cacheKey, hotel, null, DateTime.Now.AddMinutes(Minutes), TimeSpan.Zero);
        }
        //public static void SetRoomsCache(string cacheKey, string Roomvalue, int hours)
        public static void SetRoomsCache(string cacheKey, string Roomvalue, int Minutes)
        {
            //cache.Insert(cacheKey, Roomvalue, null, DateTime.Now.AddHours(hours), TimeSpan.Zero);
            cache.Insert(cacheKey, Roomvalue, null, DateTime.Now.AddSeconds(Minutes), TimeSpan.Zero);
        }

        public static void SetCuXiaoCache(string cacheKey, string value, int hours)
        {
            cache.Insert(cacheKey, value, null, DateTime.Now.AddHours(hours), TimeSpan.Zero);
        }

        public static void SetValueCache(string cacheKey, string value, int hours)
        {
            cache.Insert(cacheKey, value, null, DateTime.Now.AddHours(hours), TimeSpan.Zero);
        }

        public static void SetRoomCache(string cacheKey, Room room, int Seconds)
        {
            //cache.Insert(cacheKey, room, null, DateTime.Now.AddHours(hours), TimeSpan.Zero);
            cache.Insert(cacheKey, room, null, DateTime.Now.AddSeconds(Seconds), TimeSpan.Zero);
        }

        public static void SetBankCache(string cacheKey, List<Models.Bank> banks, int hours)
        {
            cache.Insert(cacheKey, banks, null, DateTime.Now.AddHours(hours), TimeSpan.Zero);
        }

        public static void RemoveCache(string cacheKey)
        {
            cache.Remove(cacheKey);
        }

        public static List<Room> GetRooms(int hotelID)
        {
            string name = string.Format("rooms_{0}", hotelID);
            string value = GetRoomsForNet(name);
            List<Room> rooms = new List<Room>();
            if (value==null)
            {
                rooms = GetRoomsForDB(hotelID);
                SetRoomsCache(name, Newtonsoft.Json.JsonConvert.SerializeObject(rooms), 60);
            }
            else
            {
                rooms = (List<Room>)Newtonsoft.Json.JsonConvert.DeserializeObject(value, typeof(List<Room>));
            }
            return rooms;
        }

        public static Room GetRoom(string roomid, string rateplanid)
        {
            string name = string.Format("simpleroom_{0}", roomid);
            //Room room = GetRoomForNet(name);
            //if (room == null)
            //{
            //    room = GetRoomForDB(roomid);
            //    SetRoomCache(name, room, 10);
            //}
            return GetRoomForDB(roomid, rateplanid);
            //return room;
        }

        public static List<Bank> GetBank()
        {
            string name = string.Format("backInfo");
            List<Bank> listBank = GetBankForNet(name);
            if (listBank == null)
            {
                listBank = new List<Bank>();
                foreach (DataRow dr in GetBankForDB().Rows)
                {
                    Bank bank = new Bank()
                    {
                        BankID = dr["bId"].ToString(),
                        BankName = dr["bankName"].ToString()
                    };
                    listBank.Add(bank);
                }
                SetBankCache(name, listBank, 1);
            }
            return listBank;
        }

        public static string GetCuXiao(int hotelID)
        {
            string name = string.Format("cuxiao_{0}", hotelID);
            string value = GetCuXiaoCacheForNet(name);
            if (value == null)
            {
                value = GetCuXiaoValueForDB(hotelID);
                SetCuXiaoCache(name, value, 1);
            } return value;
        }

        public static string GetCuXiaoCacheForNet(string name)
        {
            return cache[name] as string;
        }

        public static string GetCuXiaoValueForDB(int hotelID)
        {
            string sql = @"select top 1 Convert(nvarchar(10),sDate,120)+'至'+Convert(nvarchar(10),eDate,120)+':'+content from hotelcuxiao where hotelid=@hotelid and sDate<=getdate() and datediff(d,getdate(),eDate)>=0 and isnull(content,'')!=''";
            string value = HotelCloud.SqlServer.SQLHelper.Get_Value(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"hotelid",new HotelCloud.SqlServer.DBParam{ParamValue=hotelID.ToString()}}
            }); return value;
        }

        public static string GetHotelID(string weixinID)
        {
            string value = GetHotelIDForNet(weixinID);
            if (value == null)
            {
                value = GetHotelIDForDB(weixinID);
                SetValueCache(weixinID, value, 1);
            } return value;
        }

        public static string GetHotelIDForNet(string weixinID)
        {
            return cache[weixinID] as string;
        }

        public static string GetHotelIDForDB(string weixinID)
        {
            string sql = "select top 1 id from hotel where weixinID=@weixinID";
            string value = HotelCloud.SqlServer.SQLHelper.Get_Value(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}}
            }); return value;
        }

        public static List<Room> GetRoomsForDate(Hotel hotel, DateTime indate, DateTime outdate)
        {
            List<Room> rooms = new List<Room>();
            rooms = GetRooms(hotel.ID);
            foreach (Room r in rooms)
            {
                foreach (RatePlan p in r.RatePlans)
                {
                    List<Rate> rates = p.Rates.Where(e => (e.Dates >= indate.Date) && (e.Dates < outdate)).ToList();
                    int m = 0;
                    foreach (var rate in rates)
                    {
                        if (rate.Price > 0)
                        {
                            m++;
                            //rate.NoMemPrice = rate.Price;
                            //rate.Price = (int)(rate.Price * (hotel.MemberFav * 0.1) - hotel.FirstFav);
                            if (p.Discount > 0)
                            {
                                rate.NumPrice = rate.Price * 0.1 * p.Discount;
                                rate.NetPrice = rate.Price * 1.0;
                            }
                            else
                            {
                                rate.NetPrice = 0;
                                rate.NumPrice = rate.Price * 1.0;
                            }
                        }
                        else
                        {
                            rate.Available = 0;
                        }
                    }
                    p.Rates = rates;
                    if (rates.Count > 0)
                    {
                        //p.SumPrice = rates.Sum(e => e.Price);
                        //p.AvgPrice = (int)p.SumPrice / (m == 0 ? 1 : m);
                        //p.NonMemSumPrice = rates.Sum(e => e.NoMemPrice);
                        //p.AvgNonMemPrice = (int)p.NonMemSumPrice / (m == 0 ? 1 : m);

                        p.SumNetPrice = rates.Sum(e => e.NetPrice);
                        p.SumNumPrice = rates.Sum(e => e.NumPrice);
                        //p.AvgNonMemPrice = (int)(Math.Round(p.SumNetPrice / (m == 0 ? 1 : m)));
                        //p.AvgPrice = (int)(Math.Round(p.SumNumPrice / (m == 0 ? 1 : m)));

                        p.AvgNonMemPrice = (int)p.SumNetPrice;
                        p.AvgPrice = (int)(Math.Round(p.SumNumPrice));

                        int n = p.Rates.Where(e => e.Available == 1).Count();
                        p.State = (n == p.Rates.Count ? 1 : (n > 0 ? 2 : 0));
                    }
                }
                r.RatePlans = r.RatePlans.OrderBy(p =>
                {
                    if (p.State == 1)
                    {
                        return p.AvgPrice;
                    }
                    else
                    {
                        return 99999;
                    }
                }).ToList();
            }
            //rooms.OrderBy
            return rooms.OrderBy(r => { if (r.RatePlans.Count > 0) { return r.RatePlans.First().AvgPrice; } else { return 99999; } }).ToList();
        }

        public static string GetRoomsForNet(string name)
        {
            string value = cache[name] as string;
            return value;
        }

        public static Room GetRoomForNet(string name)
        {
            Room value = cache[name] as Room;
            return value;
        }

        public static List<Bank> GetBankForNet(string name)
        {
            List<Bank> value = cache[name] as List<Bank>;
            return value;
        }

        public static List<Room> GetRoomsForDB(int hotelID)
        {
            string sql = @"select roomName,BedArea,Area,Floor,NetType,r.BedType,r.RoomTypeId,r.IsChildRoom,Remark,p.RoomID,e.RatePlanID,
                           p.RatePlanName,p.ishourRoom,p.BedType as RatePlanBedType,
                           p.NetInfo,p.zaocan,p.Discount,e.price,e.dates,e.Available,p.PayType
                           from HotelRoom r with(nolock)
                           inner join HotelRatePlan p with(nolock)
                           on r.id=p.RoomID 
                           inner join HotelRate e with(nolock)
                           on e.RatePlanID=p.id
                           where r.hotelID=@hotelID and r.Enabled=1 and p.Enabled=1 
                           order by r.id,p.id,dates";
            var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"hotelID",new HotelCloud.SqlServer.DBParam{ParamValue=hotelID.ToString()}}
            });
            List<Room> rooms = new List<Room>();
            Room room = new Room();
            List<RatePlan> RatePlans = new List<RatePlan>();
            RatePlan rateplan = new RatePlan();
            List<Rate> Rates = new List<Rate>();
            string croomID = "";
            string cRatePlanID = "";
            foreach (System.Data.DataRow dr in dt.Rows)
            {
                if (!cRatePlanID.Equals(dr["RatePlanID"].ToString()))
                {
                    if (!cRatePlanID.Equals(""))
                    {
                        rateplan.Rates = Rates;
                        RatePlans.Add(rateplan);
                    }
                    cRatePlanID = dr["RatePlanID"].ToString();
                    rateplan = new RatePlan();
                    rateplan.BedType = dr["rateplanbedtype"].ToString();
                    rateplan.NetInfo = dr["netinfo"].ToString();
                    rateplan.ID = WeiXinPublic.ConvertHelper.ToInt(dr["rateplanid"]);
                    rateplan.RatePlanName = dr["rateplanname"].ToString();
                    rateplan.ZaoCan = dr["zaocan"].ToString();
                    rateplan.IsHourRoom = WeiXinPublic.ConvertHelper.ToInt(dr["isHourRoom"]);
                    rateplan.Discount = WeiXinPublic.ConvertHelper.ToDouble(dr["Discount"]);
                    rateplan.PayType = Convert.ToString(dr["paytype"]);
                    Rates = new List<Rate>();
                }
                if ((!croomID.Equals(dr["RoomID"].ToString())))
                {
                    if (!croomID.Equals(""))
                    {
                        room.RatePlans = RatePlans;
                        rooms.Add(room);
                    }
                    croomID = dr["RoomID"].ToString();
                    room = new Room();
                    room.Area = dr["area"].ToString();
                    room.BedArea = dr["bedarea"].ToString();
                    room.BedType = dr["bedtype"].ToString();
                    room.Floor = dr["floor"].ToString();
                    room.ID = Convert.ToInt32(dr["roomID"].ToString());
                    room.NetType = dr["nettype"].ToString();
                    room.Remark = dr["Remark"].ToString();
                    room.RoomName = dr["RoomName"].ToString();
                    room.IsChildRoom = WeiXinPublic.ConvertHelper.ToInt(dr["IsChildRoom"]);
                    room.RoomTypeId = WeiXinPublic.ConvertHelper.ToInt(dr["RoomTypeId"]);
                    RatePlans = new List<RatePlan>();
                }

                Rate r = new Rate();
                r.Available = Convert.ToInt32(dr["Available"].ToString());
                r.Dates = Convert.ToDateTime(dr["dates"].ToString());
                r.Price = Convert.ToInt32(dr["Price"].ToString());
                Rates.Add(r);
            }
            if (dt.Rows.Count > 0)
            {
                rateplan.Rates = Rates;
                RatePlans.Add(rateplan);
                room.RatePlans = RatePlans;
                rooms.Add(room);
            }
            return rooms;
        }

        public static Room GetRoomForDB(string roomid,string rateplanid)
        {
            string str = "select top 1 a.*,b.zaocan,b.PayType,b.warrantCount,b.warrantTime,b.guarantee_type,b.guarantee_start_time from HotelRoom a left join HotelRatePlan b on a.id=b.RoomID where a.id=@roomid and b.id=@rateplanid and b.Enabled=1";
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(str, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            { "roomid", new HotelCloud.SqlServer.DBParam { ParamValue = roomid } },
            { "rateplanid", new HotelCloud.SqlServer.DBParam { ParamValue = rateplanid } }
            });
            Room room = new Room();
            List<RatePlan> rateplans = new List<RatePlan>();
            RatePlan rateplan = new RatePlan();
            foreach (System.Data.DataRow dr in dt.Rows)
            {
                room.Area = dr["Area"].ToString();
                room.BedArea = dr["BedArea"].ToString();
                room.BedType = dr["BedType"].ToString();
                room.Floor = dr["Floor"].ToString();
                room.ID = WeiXinPublic.ConvertHelper.ToInt(dr["ID"]);
                room.NetType = dr["NetType"].ToString();
                room.RoomName = dr["RoomName"].ToString();
                room.Window = dr["WindowType"].ToString();
                room.AddBed = dr["AddBed"].ToString();
                room.IsChildRoom = WeiXinPublic.ConvertHelper.ToInt(dr["IsChildRoom"]);
                rateplan.ZaoCan = dr["zaocan"].ToString();
                rateplan.PayType = dr["PayType"].ToString();
                rateplan.WarrantCount = dr["WarrantCount"].ToString();
                rateplan.WarrantTime = dr["WarrantTime"].ToString();
                rateplan.guarantee_type = WeiXinPublic.ConvertHelper.ToInt(dr["guarantee_type"]);
                rateplan.guarantee_start_time = dr["guarantee_start_time"].ToString();
                rateplans.Add(rateplan);
                room.RatePlans = rateplans;
                room.CouponsID = WeiXinPublic.ConvertHelper.ToString(dr["Conpons"]);

                string rid = room.ID.ToString();
                if (WeiXinPublic.ConvertHelper.ToInt(dr["IsChildRoom"]) == 1)
                {
                    rid = WeiXinPublic.ConvertHelper.ToString(dr["RoomTypeId"]);
                }

                List<string> imgs = new List<string>();
                foreach (DataRow item in GetRoomTypeImgs(dr["hotelID"].ToString(), rid).Rows)
                {
                    imgs.Add(item["url"].ToString());
                }
                room.RoomTypeImgs = imgs;
            }
            return room;
        }

        public static DataTable GetBankForDB()
        {
            string str = "select * from Bank";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(str, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>());
            return dt;
        }

        public static Hotel GetDataForDB(int ID)
        {
            string sql = @"select top 1 url,WeiXinID,SubName,HotelLog,address,tel,star,chainID,
            openDate,xiuDate,pos,roundValue,AddBedPrice,AutoEatingPrice,huiyi,fuwu,canyin,
            yule,kefang,memberFav,firstFav,isnull(jifenFav,0) jf,smsMobile,weixinQQ,content,quanjing  
            from Hotel with(nolock)  left join RoomTypeImg  with(nolock) on RoomTypeImg.hotelID=Hotel.id and ImgNum=1 where hotel.id=@id ";
            var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                {"id",new HotelCloud.SqlServer.DBParam{ParamValue=ID.ToString()}}
            });
            Hotel hotel = new Hotel();
            if (dt.Rows.Count > 0)
            {
                System.Data.DataRow dr = dt.Rows[0];
                hotel.ID = ID;
                hotel.WeiXinID = dr["WeiXinID"].ToString();
                hotel.AddBedPrice = dr["addbedprice"].ToString();
                hotel.Address = dr["address"].ToString();
                hotel.AutoEatingPrice = dr["autoeatingprice"].ToString();
                hotel.CanYin = dr["canyin"].ToString();
                hotel.ChainID = Convert.ToInt32(dr["chainid"].ToString());
                hotel.Content = dr["content"].ToString();
                hotel.FirstFav = Convert.ToDouble(dr["firstfav"].ToString());
                hotel.FuWu = dr["fuwu"].ToString();
                hotel.HotelLog = dr["hotellog"].ToString();
                hotel.HuiYi = dr["huiyi"].ToString();
                hotel.KeFang = dr["kefang"].ToString();
                hotel.MemberFav = Convert.ToDouble(dr["memberFav"].ToString());
                hotel.openDate = dr["opendate"].ToString();
                hotel.Pos = dr["pos"].ToString();
                hotel.RoundValue = dr["roundvalue"].ToString();
                hotel.SmsMobile = dr["smsmobile"].ToString();
                hotel.Star = Convert.ToInt32(dr["star"].ToString());
                hotel.SubName = dr["subname"].ToString();
                hotel.Tel = dr["tel"].ToString();
                hotel.WeiXinQQ = dr["weixinqq"].ToString();
                hotel.xiuDate = dr["xiudate"].ToString();
                hotel.YuLe = dr["yule"].ToString();
                hotel.JifenFav = Convert.ToDouble(dr["jf"].ToString());
                hotel.AdImg = dr["url"].ToString().Equals("") ? "/Content/images/news-top.png" : dr["url"].ToString();
                hotel.Quanjing = dr["Quanjing"].ToString();
    
            } return hotel;
        }

        public static DataTable GetRoomTypeImgs(string hotelid, string roomid)
        {
            string str = "select * from RoomTypeImg where hotelID=@hotelID and roomid=@roomid";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(str, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "hotelid", new HotelCloud.SqlServer.DBParam { ParamValue = hotelid } }, { "roomid", new HotelCloud.SqlServer.DBParam { ParamValue = roomid } } });
            return dt;
        }

        public static DataTable GetRoomPrice(string rateplanId, string startDate, string endDate)
        {
            string str = "select * from HotelRate where RatePlanID=@rateplanid and dates >= @startDate and dates < @endDate";
            DataTable dt = SQLHelper.Get_DataTable(str, SQLHelper.GetCon(), new Dictionary<string, DBParam> { { "rateplanId", new DBParam { ParamValue = rateplanId } }, { "startDate", new DBParam { ParamValue = startDate } }, { "endDate", new DBParam { ParamValue = endDate } } });
            return dt;
        }

        public static DataTable GetFillOrderInfo(string roomid, string rateplanid)
        {
            string str = "select a.roomName,a.GiftConPon,b.IsHourRoom,b.RatePlanName,b.Discount from HotelRoom a left join HotelRatePlan b on a.id=b.RoomID where a.id=@roomid and b.id=@rateplanid";
            DataTable dt = SQLHelper.Get_DataTable(str, SQLHelper.GetCon(), new Dictionary<string, DBParam> { { "roomid", new DBParam { ParamValue = roomid } }, { "rateplanid", new DBParam { ParamValue = rateplanid } } });
            return dt;
        }

        public static int GetGiftCouponPrice(string couponid)
        {
            int price = 0;
            string sql = "select moneys from CouPon where id=@couponid and GETDATE() between sTime and ExtTime and Endable=1";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam> { { "couponid", new DBParam { ParamValue = couponid } } });
            foreach (DataRow dr in dt.Rows)
            {
                price = WeiXinPublic.ConvertHelper.ToInt(dr["moneys"]);
            }
            return price;
        }

        public static string GetMobile(string WeiXinID)
        {
            string sql = "select SmsMobile from hotel where weixinID=@WeiXinID";
            string smsMobile = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam> { { "WeiXinID", new DBParam { ParamValue = WeiXinID } } });
            return smsMobile;
        }
    }
}
