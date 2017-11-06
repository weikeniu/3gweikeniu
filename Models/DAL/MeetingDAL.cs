using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using hotel3g.Models.Home;
using System.Data;

namespace hotel3g.Models.DAL
{
    public class MeetingDAL
    {
        public static int AddModel(Meeting model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into Meeting(");
            strSql.Append("HoldPerson,DoorInfo,Columns,TypeAndHoldInfo,EquipmentInfo,Status,AddTime,LastUpdateTime,WeixinId,HotelId,Name,Long,Width,Height,Floor,Light,Remark,PayType");
            strSql.Append(") values (");
            strSql.Append("@HoldPerson,@DoorInfo,@Columns,@TypeAndHoldInfo,@EquipmentInfo,@Status,@AddTime,@LastUpdateTime,@WeixinId,@HotelId,@Name,@Long,@Width,@Height,@Floor,@Light,@Remark,@PayType");
            strSql.Append(") ");
            strSql.Append(";select @@IDENTITY");

            string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"HoldPerson",new HotelCloud.SqlServer.DBParam{ParamValue=model.HoldPerson.ToString()}},
             {"DoorInfo",new HotelCloud.SqlServer.DBParam{ParamValue=model.DoorInfo.ToString()}},
              {"Columns",new HotelCloud.SqlServer.DBParam{ParamValue=model.Columns.ToString()}},
              {"TypeAndHoldInfo",new HotelCloud.SqlServer.DBParam{ParamValue=model.TypeAndHoldInfo.ToString()}},
              {"EquipmentInfo",new HotelCloud.SqlServer.DBParam{ParamValue=model.EquipmentInfo.ToString()}},
              {"Status",new HotelCloud.SqlServer.DBParam{ParamValue=model.Status.ToString()}},
              {"AddTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.AddTime.ToString()}},
               {"AddTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.AddTime.ToString()}},
               {"LastUpdateTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.LastUpdateTime.ToString()}},
               {"WeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.WeixinId.ToString()}},
               {"HotelId",new HotelCloud.SqlServer.DBParam{ParamValue=model.HotelId.ToString()}},
              {"Name",new HotelCloud.SqlServer.DBParam{ParamValue=model.Name.ToString()}},
              {"Long",new HotelCloud.SqlServer.DBParam{ParamValue=model.Long.ToString()}},
              {"Width",new HotelCloud.SqlServer.DBParam{ParamValue=model.Width.ToString()}},
              {"Height",new HotelCloud.SqlServer.DBParam{ParamValue=model.Height.ToString()}},
              {"Floor",new HotelCloud.SqlServer.DBParam{ParamValue=model.Floor.ToString()}},
                {"Remark",new HotelCloud.SqlServer.DBParam{ParamValue=model.Remark.ToString()}},
               {"PayType",new HotelCloud.SqlServer.DBParam{ParamValue=model.PayType.ToString()}},
        });

            if (!string.IsNullOrEmpty(obj))
            {
                return Convert.ToInt32(obj);
            }

            return 0;
        }


        public static DataTable GeteMeetingList(string weixinID, out int count, int page, int pagesize, DateTime date, string select, string query)
        {
            StringBuilder tsql = new StringBuilder();
            tsql.Append(@"select count(0) from Meeting  with(nolock) where weixinID=@weixinID   and  Status=1  ");


            StringBuilder sql = new StringBuilder();
            sql.Append(@"select * from (
                     select  ROW_NUMBER() over(order by Id  desc)num  ,*,
Isnull((select top 1 amprice from   meetingrates r with(nolock)  where r.meetingId=m.id  and  date=@date and status=1  ),0)AMPrice,
Isnull((select top 1 PMPrice from   meetingrates r with(nolock)  where r.meetingId=m.id  and  date=@date  and PmStatus=1 ),0)PMPrice,
Isnull((select top 1 NightPrice from   meetingrates r with(nolock)  where r.meetingId=m.id  and  date=@date  and  nightStatus=1 ),0)NightPrice,
Isnull((select top 1 DayPrice from   meetingrates r with(nolock)  where r.meetingId=m.id  and  date=@date and  dayStatus=1 ),0)DayPrice
from Meeting  m  with(Nolock)    where weixinID=@weixinID  and  Status=1   ");

            if (string.IsNullOrEmpty(select))
            {
                sql.Append(") a where a.num between @startID and @endID");
            }
            if (!string.IsNullOrEmpty(select))
            {
                tsql.Append(" and " + select + " like '%'+@query+'%'");
                sql.Append(" and " + select + " like '%'+@query+'%') a where a.num between @startID and @endID"); ;

            }

            string value = HotelCloud.SqlServer.SQLHelper.Get_Value(tsql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},            
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            count = Convert.ToInt32(value);

            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
            {"startID",new HotelCloud.SqlServer.DBParam{ParamValue=((page-1)*pagesize+1).ToString()}},
            {"endID",new HotelCloud.SqlServer.DBParam{ParamValue=(page*pagesize).ToString()}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}},
            {"date",new HotelCloud.SqlServer.DBParam{ParamValue=date.Date.ToString()}},
            });
            return dt;


        }


        public static DataTable GeteMeeting(int hotelId, int Id)
        {
            string sql = "select  *  from Meeting  with(nolock) where Id=@Id   and  hotelId=@hotelId   and  Status=1  ";

            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
             {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id.ToString()}},   
              {"hotelId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelId.ToString()}},   
            });
            return dt;
        }



        public static DataTable GetMeetingPics(int hotelId)
        {
            string sql = "select   roomId,url,small_url,big_url from RoomTypeImg  with(nolock) where hotelId=@hotelId  and imgType=4 ";

            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"hotelId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelId.ToString()}}        
            });
            return dt;

        }

    }



    public class MeetingRatesDAL
    {

        public static int AddModel(MeetingRates model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into MeetingRates(");
            strSql.Append("MeetingId,HotelId,AmPrice,PmPrice,NightPrice,DayPrice,Date,Status");
            strSql.Append(") values (");
            strSql.Append("@MeetingId,@HotelId,@AmPrice,@PmPrice,@NightPrice,@DayPrice,@Date,@Status");
            strSql.Append(") ");
            strSql.Append(";select @@IDENTITY");

            string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"MeetingId",new HotelCloud.SqlServer.DBParam{ParamValue=model.MeetingId.ToString()}},
             {"HotelId",new HotelCloud.SqlServer.DBParam{ParamValue=model.HotelId.ToString()}},
              {"AmPrice",new HotelCloud.SqlServer.DBParam{ParamValue=model.AmPrice.ToString()}},
              {"PmPrice",new HotelCloud.SqlServer.DBParam{ParamValue=model.PmPrice.ToString()}},
              {"NightPrice",new HotelCloud.SqlServer.DBParam{ParamValue=model.NightPrice.ToString()}},
              {"DayPrice",new HotelCloud.SqlServer.DBParam{ParamValue=model.DayPrice.ToString()}},
              {"Date",new HotelCloud.SqlServer.DBParam{ParamValue=model.Date.ToString()}},
               {"Status",new HotelCloud.SqlServer.DBParam{ParamValue=model.Status.ToString()}}               
        });

            if (!string.IsNullOrEmpty(obj))
            {
                return Convert.ToInt32(obj);
            }
            return 0;

        }


        public static DataTable GeteMeetingRatesList(int hotelId,int meetingId)
        {
            string sql = "select  *  from MeetingRates  with(nolock) where meetingId=@meetingId   and  date>= CONVERT(varchar(12) , getdate(), 111 )  and  hotelId=@hotelId   and (Status=1 or pmstatus=1 or  nightstatus=1 or  dayStatus=1 )   ";

            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
             {"meetingId",new HotelCloud.SqlServer.DBParam{ParamValue=meetingId.ToString()}},   
              {"hotelId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelId.ToString()}},   
            });
            return dt;

        }


        public static DataTable GeteMeetingRatesList(int hotelId, int meetingId,DateTime date)
        {
            string sql = "select  *  from MeetingRates  with(nolock) where meetingId=@meetingId   and  date=@date  and  hotelId=@hotelId   and (Status=1 or pmstatus=1 or  nightstatus=1 or  dayStatus=1 )   ";

            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
             {"meetingId",new HotelCloud.SqlServer.DBParam{ParamValue=meetingId.ToString()}},   
              {"hotelId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelId.ToString()}},   
               {"date",new HotelCloud.SqlServer.DBParam{ParamValue=date.ToString("yyyy-MM-dd")}},   
            });
            return dt;

        }
 

    }
}