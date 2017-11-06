using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using hotel3g.Models.DAL;
using System.Data;

namespace hotel3g.Models.Home
{  
    public class HotelServices
    {
        public int Id { get; set; }
        public string WeiXinId { get; set; }
        public string UserweixinId { get; set; }
        public int HotelId { get; set; }

        public string ServiceTime { get; set; }

        public string RoomNo { get; set; }
        public string Mobile { get; set; }
        public string Remark { get; set; }

        /// <summary>
        /// 0 清洁，1 叫醒，2洗衣，3物品借用，4前台，5反馈  6 预约发票 7机场接送  8行李寄运
        /// </summary>
        public int Type { get; set; }
        public int Status { get; set; }
        public DateTime AddTime { get; set; }

        public string Goods { get; set; }
        public string UserName { get; set; }

        public string Feedback1 { get; set; }
        public string Feedback2 { get; set; }
        public string Feedback3 { get; set; }
        public string Feedback4 { get; set; }
        public string Feedback5 { get; set; }

        /// <summary>
        /// 发票金额
        /// </summary>
        public decimal FMoney { get; set; }

        /// <summary>
        /// 发票类型
        /// </summary>
        public string FType { get; set; }

        public static int AddHotelServices(Models.Home.HotelServices model)
        {
            return HotelServicesDAL.AddHotelServices(model);
        }

        public static DataTable GetHotelServices(int Id, string userweixinId)
        {
            return HotelServicesDAL.GetHotelServices(Id, userweixinId);
        }

        public static DataTable GeteHotelServicesList(string userweixinId, out int count, int page, int pagesize, string select, string query)
        {
            return HotelServicesDAL.GeteHotelServicesList(userweixinId, out   count, page, pagesize, select, query);

        }

    }



}