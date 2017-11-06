using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using WeiXinPublic;
using hotel3g.Models;

namespace hotel3g.Common
{
    [Serializable]
    public class UserInfo
    {
        public int Id { get; set; }
        public string WeiXinNO { get; set; }
        public string NickName { get; set; }
        public int Emoney { get; set; }
        public string Name { get; set; }
        public string Mobile { get; set; }
        public string Email { get; set; }
        public string Sex { get; set; }
        public int UserFlag { get; set; }

        public int CouponMoney { get; set; }

        public decimal Balance { get; set; }

        public static UserInfo Assembly(DataTable dt)
        {
            UserInfo info = new UserInfo();
            if (dt != null && dt.Rows.Count > 0)
            {
                info.Id = ConvertHelper.ToInt(dt.Rows[0]["id"]);
                info.WeiXinNO = ConvertHelper.ToString(dt.Rows[0]["userWeiXinNO"]);
                info.NickName = ConvertHelper.ToString(dt.Rows[0]["nickname"]);
                info.Emoney = ConvertHelper.ToInt(dt.Rows[0]["Emoney"]);
                info.Name = ConvertHelper.ToString(dt.Rows[0]["name"]);
                info.Mobile = ConvertHelper.ToString(dt.Rows[0]["mobile"]);
                info.Email = ConvertHelper.ToString(dt.Rows[0]["Email"]);
                info.Sex = ConvertHelper.ToString(dt.Rows[0]["sex"]);
                info.UserFlag = ConvertHelper.ToInt(dt.Rows[0]["userFlag"]);
                info.Balance = ConvertHelper.ToDecimal(dt.Rows[0]["Balance"]);
            }
            return info;
        }
    }

    [Serializable]
    public class OrderInfo
    {
        public int channel { get; set; }
        public int Id { get; set; }
        public string OrderNo { get; set; }
        public string RoomName { get; set; }
        public string RoomImage { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }
        public int SumPrice { get; set; }
        public int State { get; set; }
        public string PayType { get; set; }
        public DateTime Ordertime { get; set; }
        public int UserID { get; set; }
        public int yRoomNum { get; set; }
        public string HotelName { get; set; }
        public static IList<OrderInfo> Assembly(DataTable dt, List<WeiXin.Models.Img> imgs)
        {
            IList<OrderInfo> list = new List<OrderInfo>();
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    OrderInfo f = new OrderInfo();
                    f.Id = ConvertHelper.ToInt(row["id"]);
                    f.OrderNo = ConvertHelper.ToString(row["OrderNO"]);
                    f.RoomName = ConvertHelper.ToString(row["RoomName"]);
                    f.RoomImage = ConvertHelper.ToString(row["url"]);
                    f.State = ConvertHelper.ToInt(row["state"]);
                    f.PayType = ConvertHelper.ToString(row["paytype"]);
                    f.Ordertime = ConvertHelper.ToDateTime(row["Ordertime"]);
                    f.UserID = ConvertHelper.ToInt(row["UserID"]);
                    f.yRoomNum = ConvertHelper.ToInt(row["yRoomNum"]);
                    f.HotelName = ConvertHelper.ToString(row["HotelName"]);
                    if (string.IsNullOrEmpty(f.RoomImage))
                    {
                        foreach (WeiXin.Models.Img g in imgs)
                        {
                            if (g.Title == f.RoomName)
                            {
                                f.RoomImage = g.Url;
                                break;
                            }
                        }
                    }
                    f.StartTime = ConvertHelper.ToDateTime(row["yinDate"]).ToString("yyyy-MM-dd");
                    f.EndTime = ConvertHelper.ToDateTime(row["youtDate"]).ToString("yyyy-MM-dd");
                    f.SumPrice = ConvertHelper.ToInt(row["sSumPrice"]);
                    list.Add(f);
                }
            }
            return list;
        }
    }

    [Serializable]
    public class OrderInfoItem
    {
        public int channel { get; set; }
        public int Id { get; set; }
        public string OrderNo { get; set; }
        public string RoomName { get; set; }
        public string RoomImage { get; set; }
        public string yinDate { get; set; }
        public string youtDate { get; set; }
        public decimal sSumPrice { get; set; }
        public int State { get; set; }
        public int PayType { get; set; }
        public DateTime Ordertime { get; set; }
        public int UserID { get; set; }
        public int yRoomNum { get; set; }
        public string HotelName { get; set; }
        public int days { get; set; }
        public decimal ySumPrice { get; set; }
        public string stateCh { get; set; }
        public int IsPay { get; set; }
        public int HeXiaoState { get; set; }
        public string tradeStatus { get; set; }
        public string Remark { get; set; }
        public int ProductType { get; set; }
        public int ishourroom { get; set; }
        public string hourendtime { get; set; }
        public string hourstarttime { get; set; }
        public int fpsubmitprice { get; set; }

        public string lastTime { get; set; }
        public int isMeeting { get; set; }

        public int storeID { get; set; }

    }

    [Serializable]
    public class HotelRoom
    {
        public int Id { get; set; }
        public string Room { get; set; }
        public string BreakFast { get; set; }
        public string BedType { get; set; }
        public string BedArea { get; set; }
        public string Area { get; set; }
        public string Image { get; set; }

        public static HotelRoom GetRoom(DataTable dt, List<WeiXin.Models.Img> imgs)
        {
            HotelRoom r = new HotelRoom();
            if (dt != null && dt.Rows.Count > 0)
            {
                r.Id = ConvertHelper.ToInt(dt.Rows[0]["id"]);
                r.Room = ConvertHelper.ToString(dt.Rows[0]["roomName"]);
                r.BreakFast = ConvertHelper.ToString(dt.Rows[0]["zaocan"]);
                r.BedArea = ConvertHelper.ToString(dt.Rows[0]["BedArea"]);
                r.Area = ConvertHelper.ToString(dt.Rows[0]["Area"]);
                r.Image = ConvertHelper.ToString(dt.Rows[0]["url"]);
                r.BedType = ConvertHelper.ToString(dt.Rows[0]["BedType"]);
                if (string.IsNullOrEmpty(r.Image))
                {
                    foreach (WeiXin.Models.Img g in imgs)
                    {
                        //if (g.Title == r.Room)
                        //{
                        //    r.Image = g.Url;
                        //    break;
                        //}
                        if (g.RoomID == r.Id.ToString())
                        {
                            r.Image = g.Url;
                            break;
                        }
                    }
                }
            }
            return r;
        }
    }

    [Serializable]
    public class CouponInfo
    {
        public int Id { get; set; }
        public int Moneys { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }
        public string State { get; set; }
        /// <summary>
        /// 红包使用范围
        /// </summary>
        public string scopelimit { get; set; }
        /// <summary>
        /// 红包使用金额限制
        /// </summary>
        public string amountlimit { get; set; }

        public static IList<CouponInfo> Assembly(DataTable tb)
        {
            IList<CouponInfo> list = new List<CouponInfo>();
            if (tb != null)
            {
                foreach (DataRow row in tb.Rows)
                {
                    CouponInfo f = new CouponInfo();
                    f.Id = ConvertHelper.ToInt(row["id"]);
                    f.Moneys = ConvertHelper.ToInt(row["moneys"]);
                    DateTime s = ConvertHelper.ToDateTime(row["sTime"]);
                    DateTime last = ConvertHelper.ToDateTime(row["ExtTime"]);
                    if (s != DateTime.MinValue)
                    {
                        f.StartTime = s.ToString("yyyy-MM-dd");
                    }
                    if (last != DateTime.MinValue)
                    {
                        f.EndTime = last.ToString("yyyy-MM-dd");
                    }
                    int state = ConvertHelper.ToInt(row["IsEmploy"]);

                    //未使用
                    f.State = "0";
                    if (state == 1)
                    {
                        //已使用
                        f.State = "1";
                    }
                    else if (last.Date < DateTime.Now.Date)
                    {
                        //已过期
                        f.State = "2";
                    }

                    ///红包使用范围
                    f.scopelimit = row["scopelimit"].ToString();
                    ///红包使用金额限制
                    f.amountlimit = row["amountlimit"].ToString();

                    list.Add(f);
                }
            }
            return list;
        }
    }

    [Serializable]
    public class HotelImage
    {
        public string Title { get; set; }
        public string Image { get; set; }
        public string BigUrl { get; set; }
        public string SmallUrl { get; set; }

        public static IDictionary<string, IList<HotelImage>> Assembly(DataTable dt)
        {
            IDictionary<string, IList<HotelImage>> dic = new Dictionary<string, IList<HotelImage>>();
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {//99其他1酒店外观2酒店大堂3房型 --2017-07-20 6会议室 7棋牌室 8餐厅 9健身房 10交通游玩 11康体设施 12公共设施 13 周围环境 
                    HotelImage h = new HotelImage();
                    h.Image = ConvertHelper.ToString(row["url"]);
                    h.BigUrl = ConvertHelper.ToString(row["big_url"]);
                    h.SmallUrl = ConvertHelper.ToString(row["small_url"]);

                    h.Title = ConvertHelper.ToString(row["roomName"]);
                    int type = ConvertHelper.ToInt(row["imgType"]);
                    if (type == 1)
                    {
                        h.Title = "酒店外观";
                    }
                    else if (type == 2)
                    {
                        h.Title = "酒店大堂";
                    }
                    else if (type == 99)
                    {
                        h.Title = "其他";
                    }
                    else if (type == 6)
                    {
                        h.Title = "会议室";
                    }
                    else if (type == 7)
                    {
                        h.Title = "棋牌室";
                    }
                    else if (type == 8)
                    {
                        h.Title = "餐厅";
                    }
                    else if (type == 9)
                    {
                        h.Title = "健身房";
                    }
                    else if (type == 10)
                    {
                        h.Title = "交通游玩";
                    }
                    else if (type == 11)
                    {
                        h.Title = "康体设施";
                    }
                    else if (type == 12)
                    {
                        h.Title = "公共设施";
                    }
                    else if (type == 13)
                    {
                        h.Title = "周围环境";
                    }

                    else if (type == 14)
                    {
                        h.Title = "露台景观";
                    }
                    else if (type == 15)
                    {
                        h.Title = "公共区域";
                    }
                    else if (type == 16)
                    {
                        h.Title = "茶室";
                    }
                    else if (type == 17)
                    {
                        h.Title = "餐厅";
                    }
                    else if (type == 18)
                    {
                        h.Title = "吧台";
                    }
                    else if (type == 19)
                    {
                        h.Title = "浴室";
                    }
                    else if (type == 20)
                    {
                        h.Title = "KTV";
                    }
                    else if (type == 21)
                    {
                        h.Title = "咖啡厅";
                    }
                    else if (type == 22)
                    {
                        h.Title = "游泳池";
                    }
                    else if (type == 23)
                    {
                        h.Title = "温泉";
                    }
                    else if (type == 24)
                    {
                        h.Title = "养生馆";
                    }

                    if (!dic.ContainsKey(h.Title))
                    {
                        dic[h.Title] = new List<HotelImage>();
                    }
                    dic[h.Title].Add(h);
                }
            }
            return dic;
        }
    }
    /// <summary>
    /// 设施服务信息
    /// </summary>
    [Serializable]
    public class FacilityImages
    {
        public int Id { get; set; }
        public int TypeId { get; set; }//（1为酒店服务,2为客房设施,3为餐饮接待,4为康体娱乐）
        public string Title { get; set; }
        public string Description { get; set; }
        public IList<string> Images { get; set; }

        public static IList<FacilityImages> Assembly(DataTable dt)
        {
            IList<FacilityImages> list = new List<FacilityImages>();
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    FacilityImages g = new FacilityImages();
                    g.Id = ConvertHelper.ToInt(row["fId"]);
                    g.TypeId = ConvertHelper.ToInt(row["typeId"]);
                    g.Title = ConvertHelper.ToString(row["facilityName"]);
                    g.Description = ConvertHelper.ToString(row["facilityDescription"]);
                    g.Images = ConvertHelper.ToString(row["facilityImages"]).Split(';').ToList<string>();
                    list.Add(g);
                }
            }
            return list;
        }
        public static Hotel GetHotel(DataTable dt)
        {
            Hotel hotel = new Hotel();
            if (dt != null && dt.Rows.Count > 0)
            {
                hotel.ID = ConvertHelper.ToInt(dt.Rows[0]["id"]);
                hotel.WeiXinID = ConvertHelper.ToString(dt.Rows[0]["WeiXinID"]);
                hotel.SubName = ConvertHelper.ToString(dt.Rows[0]["SubName"]);
                hotel.FuWu = ConvertHelper.ToString(dt.Rows[0]["fuwu"]);
                hotel.CanYin = ConvertHelper.ToString(dt.Rows[0]["canyin"]);
                hotel.YuLe = ConvertHelper.ToString(dt.Rows[0]["yule"]);
                hotel.KeFang = ConvertHelper.ToString(dt.Rows[0]["kefang"]);
            }
            return hotel;
        }
    }

    [Serializable]
    public class PrizeMsgWrapper
    {
        public int Id { get; set; }
        public string Type { get; set; }
        public string WeiXinId { get; set; }
        public string Title { get; set; }
        public int Exclusive { get; set; }
        public static IList<PrizeMsgWrapper> Assembly(DataTable dt)
        {
            IList<PrizeMsgWrapper> wplist = new List<PrizeMsgWrapper>();
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    PrizeMsgWrapper w = new PrizeMsgWrapper();
                    w.Id = ConvertHelper.ToInt(row["id"]);
                    w.WeiXinId = ConvertHelper.ToString(row["WeiXinID"]);
                    w.Title = ConvertHelper.ToString(row["SportName"]);
                    w.Type = ConvertHelper.ToString(row["SportKind"]);
                    w.Exclusive = ConvertHelper.ToInt(row["Exclusive"]);
                    wplist.Add(w);
                }
            }
            return wplist;
        }
    }
}