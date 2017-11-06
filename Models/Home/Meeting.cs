using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using hotel3g.Models.DAL;
using System.Data;

namespace hotel3g.Models.Home
{
    public class Meeting
    {
        public int Id { get; set; }
        public string WeixinId { get; set; }
        public int HotelId { get; set; }
        public string Name { get; set; }
        public decimal Long { get; set; }
        public decimal Width { get; set; }
        public decimal Height { get; set; }
        public string Floor { get; set; }
        public string Light { get; set; }
        public string HoldPerson { get; set; }
        public string DoorInfo { get; set; }
        public string Columns { get; set; }
        public string TypeAndHoldInfo { get; set; }
        public string EquipmentInfo { get; set; }
        public int Status { get; set; }
        public DateTime AddTime { get; set; }
        public DateTime LastUpdateTime { get; set; }
        public string Remark { get; set; }
        public int  PayType { get; set; }

        public double AMPrice { get; set; }
        public double PMPrice { get; set; }
        public double NightPrice { get; set; }
        public double DayPrice { get; set; }

        public List<MeetingTypeCapacity> listMeetingTypeCapacity { get; set; }


        public static int AddModel(Meeting model)
        {
            return MeetingDAL.AddModel(model);
        }


        public static DataTable GeteMeetingList(string weixinID, out int count, int page, int pagesize, DateTime date, string select, string query)
        {
            return MeetingDAL.GeteMeetingList(weixinID, out  count, page, pagesize,date, select, query);
        }

        public static DataTable GeteMeeting(int hotelId, int Id)
        {
            return MeetingDAL.GeteMeeting(hotelId, Id);
        }

        public static DataTable GetMeetingPics(int hotelId)
        {
           return MeetingDAL.GetMeetingPics(hotelId);

        }
    }


    public class MeetingRates
    {
        public int Id { get; set; }
        public int MeetingId { get; set; }
        public int HotelId { get; set; }
        public decimal AmPrice { get; set; }
        public decimal PmPrice { get; set; }
        public decimal NightPrice { get; set; }
        public decimal DayPrice { get; set; }
        public DateTime Date { get; set; }
        public int Status { get; set; }

        public int PmStatus { get; set; }
        public int NightStatus { get; set; }
        public int DayStatus { get; set; }


        public static int AddModel(MeetingRates model)
        {
            return MeetingRatesDAL.AddModel(model);

        }


        public static DataTable GeteMeetingRatesList(int hotelId,int meetingId)
        {
            return MeetingRatesDAL.GeteMeetingRatesList(hotelId,meetingId);
        }
        public static DataTable GeteMeetingRatesList(int hotelId, int meetingId,DateTime date)
        {
            return MeetingRatesDAL.GeteMeetingRatesList(hotelId, meetingId,date);
        }

      

    }


    public class MeetingTypeCapacity
    {
        public string Key { get; set; }

        public string Name { get; set; }

        public string Person { get; set; }

        public string Remark { get; set; }
    }

}