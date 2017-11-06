using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using hotel3g.Models.Home;
using System.Data;
using WeiXin.Common;
using HotelCloud.Common;
using System.Collections;
using hotel3g.Models;

namespace hotel3g.Controllers
{
    public class MeetingAController : Controller
    {
        [Models.Filter]
        public ActionResult Index()
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            int page = 1;
            int pagesize = 1000;
            int count = 0;


            DateTime date = DateTime.Now.Date;

            DataTable db_meeting = Meeting.GeteMeetingList(hotelweixinId, out count, page, pagesize, date, "", "");
            var meetingList = DataTableToEntity.GetEntities<Meeting>(db_meeting);
            meetingList = meetingList.Where(c => (c.AMPrice > 0 || c.PMPrice > 0 || c.NightPrice > 0 || c.DayPrice > 0) || c.PayType == 1).ToList();

            int hid = Convert.ToInt32(RouteData.Values["Id"]);
            DataTable db_pics = Meeting.GetMeetingPics(hid);
            var picList = DataTableToEntity.GetEntities<RoomTypeImgEntity>(db_pics);

            ViewData["meetingList"] = meetingList;
            ViewData["picList"] = picList;
            ViewData["date"] = date;

            return View();
        }





        [Models.Filter]
        public ActionResult Detail()
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            int hid = Convert.ToInt32(RouteData.Values["Id"]);
            int meetingId = Convert.ToInt32(HCRequest.GetString("meetingId"));

         

            var dbMeeting = Meeting.GeteMeeting(hid, meetingId);
            var meeting = DataTableToEntity.GetEntity<Meeting>(dbMeeting);

            meeting.listMeetingTypeCapacity = new List<MeetingTypeCapacity>();
            if (!string.IsNullOrEmpty(meeting.TypeAndHoldInfo) && meeting.TypeAndHoldInfo.Contains("{"))
            {
                meeting.listMeetingTypeCapacity = Newtonsoft.Json.JsonConvert.DeserializeObject<List<MeetingTypeCapacity>>(meeting.TypeAndHoldInfo);
            }

            ViewData["meeting"] = meeting;


            var date = Convert.ToDateTime(Request.QueryString["date"]);
            List<MeetingRates> rateList = new List<MeetingRates>();

            if (meeting.PayType == 0)
            {
                DataTable dbRates = MeetingRates.GeteMeetingRatesList(hid, meetingId,date);
                rateList = DataTableToEntity.GetEntities<MeetingRates>(dbRates).ToList();
            }
            ViewData["rateList"] = rateList;

            DataTable db_pics = Meeting.GetMeetingPics(hid);
            var picList = DataTableToEntity.GetEntities<RoomTypeImgEntity>(db_pics);
            picList = picList.Where(c => c.RoomId == meetingId).ToList();
            ViewData["picList"] = picList;



            string MemberCardRuleJson = ActionController.getMemberCardIntegralRule(userweixinId, hotelweixinId);
            ViewData["MemberCardRuleJson"] = MemberCardRuleJson;
            Hashtable MemberCardRuleJsonobj = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJson);
            Hashtable ruletable = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJsonobj["rule"].ToString());
            double graderate = WeiXinPublic.ConvertHelper.ToDouble(ruletable["GradeRate"]);
            ViewData["graderate"] = graderate;

            Hotel hotel = HotelHelper.GetMainIndexHotel(hid);
            ViewData["hotelName"] = hotel.SubName;

            return View();
        }


        [Models.Filter]
        [HttpPost]
            public ActionResult GetRateList(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            int meetingId = HotelCloud.Common.HCRequest.getInt("meetingId");

            List<MeetingRates> rateList = new List<MeetingRates>();


            DataTable dbRates = MeetingRates.GeteMeetingRatesList(Convert.ToInt32(id), meetingId);
            rateList = DataTableToEntity.GetEntities<MeetingRates>(dbRates).ToList();

            Newtonsoft.Json.Converters.IsoDateTimeConverter timeFormat = new Newtonsoft.Json.Converters.IsoDateTimeConverter();
            timeFormat.DateTimeFormat = "yyyy-M-d";
            string rateJson = Newtonsoft.Json.JsonConvert.SerializeObject(rateList, timeFormat);

            return Json(new
            {
                Data = rateJson
            }, JsonRequestBehavior.AllowGet);                  

        }

    }
}
