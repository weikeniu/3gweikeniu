using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace hotel3g.Controllers
{
    public class TController : Controller
    { 
        public ActionResult t()
        {
            string Id = HotelCloud.Common.HCRequest.GetString("r").TrimEnd();
            if (!string.IsNullOrEmpty(Id))
            {
                int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@" update travelsky..elongHbaHotelInfo set  clickNum=Isnull(clickNum,0)+1,VisitTime=getdate() where Id=@Id", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {   
                     {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id}}   
                    });
            }

            return View();
        }



        public ActionResult SaveInfo(string type)
        {
            int status = -1;
            string errmsg = string.Empty;

           // string type = HotelCloud.Common.HCRequest.GetString("type"); 
            string Id = HotelCloud.Common.HCRequest.GetString("Id"); 
            if (type == "ok")
            {
                int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@" update travelsky..elongHbaHotelInfo set  k_Ok=1,k_ok_time=getdate()  where Id=@Id", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {   
                     {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id}}   
                    });


                if (row > 0)
                {
                    status = 1;
                    return Json(new
                    {
                        Status = status,
                        Mess = errmsg
                    }, JsonRequestBehavior.AllowGet);
                  
                }

            }


            else if (type == "no")
            {
                string reason = HotelCloud.Common.HCRequest.GetString("reason");
                if (reason != null)
                {
                    reason = reason.TrimEnd(',');
                }

                int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@" update travelsky..elongHbaHotelInfo set  k_No=1,k_No_Reason=@k_No_Reason,k_no_time=getdate()  where Id=@Id", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {   
                     {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id}},
                     {"k_No_Reason",new HotelCloud.SqlServer.DBParam{ParamValue=reason}}   
                    });

                if (row > 0)
                {
                    status = 1;
                    return Json(new
                    {
                        Status = status,
                        Mess = errmsg
                    }, JsonRequestBehavior.AllowGet);
                }
            }


            else if (type == "hotel")
            {
                string hotelname = HotelCloud.Common.HCRequest.GetString("hotelname");
                string userName = HotelCloud.Common.HCRequest.GetString("userName");
                string tel = HotelCloud.Common.HCRequest.GetString("tel");

                int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@" update travelsky..elongHbaHotelInfo set  yhotelName=@yhotelName,yuserName=@yuserName,ytel=@ytel 
,yTime=getdate() where Id=@Id", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {   
                     {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id}},
                     {"yhotelName",new HotelCloud.SqlServer.DBParam{ParamValue=hotelname}},
                        {"yuserName",new HotelCloud.SqlServer.DBParam{ParamValue=userName}},
                            {"ytel",new HotelCloud.SqlServer.DBParam{ParamValue=tel}}  ,                             
                    });

                if (row > 0)
                {
                    status = 1;
                    return Json(new
                    {
                        Status = status,
                        Mess = errmsg
                    }, JsonRequestBehavior.AllowGet);
                }
            }



            return Json(new
            {
                Status = status,
                Mess = errmsg
            }, JsonRequestBehavior.AllowGet);
            
        }

    }
}
