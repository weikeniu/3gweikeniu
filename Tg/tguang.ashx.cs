using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace hotel3g.TuiGuang
{
    /// <summary>
    /// tguang 的摘要说明
    /// </summary>
    public class tguang : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {

            string type = context.Request.Form["type"];
            string Id = context.Request.Form["Id"];
            if (type == "ok")
            {
                int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@" update travelsky..elongHbaHotelInfo set  k_Ok=1,k_ok_time=getdate()  where Id=@Id", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {   
                     {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id}}   
                    });


                if (row > 0)
                {

                    context.Response.Write("ok");
                }

            }
            else if (type == "no")
            {
                string reason = context.Request.Form["reason"];
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
                    context.Response.Write("ok");
                }
            }


            else if (type == "hotel")
            {
                string hotelname = context.Request.Form["hotelname"];
                string userName = context.Request.Form["userName"];
                string tel = context.Request.Form["tel"];

                int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@" update travelsky..elongHbaHotelInfo set  yhotelName=@yhotelName,yuserName=@yuserName,ytel=@ytel 
,yTime=getdate() where Id=@Id", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {   
                     {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id}},
                     {"yhotelName",new HotelCloud.SqlServer.DBParam{ParamValue=hotelname}},
                        {"yuserName",new HotelCloud.SqlServer.DBParam{ParamValue=userName}},
                            {"ytel",new HotelCloud.SqlServer.DBParam{ParamValue=tel}}  ,                             
                    });

                if (row > 0)
                {
                    context.Response.Write("ok");
                }


            }

        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}