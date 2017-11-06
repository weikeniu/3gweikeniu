using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace WeiXin.Models.DAL
{
    public class Activity
    {
        public string InsertActivity(string sportname, string start, string end, string kind, string times, string descripe, string weixinid)
        {
            string sql = @"insert into Activitity(SportKind,StartDate,EndDate,SportName,Frequency,Descripe,WeiXinID) values (@sportkind,@startdate,@enddate,@sportname,@times,@descripe,@weixinid) SELECT @@IDENTITY AS [id]";
            string s = HotelCloud.SqlServer.SQLHelper.Get_Value(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"sportname",new HotelCloud.SqlServer.DBParam{ParamValue=sportname}},
            {"startdate",new HotelCloud.SqlServer.DBParam{ParamValue=start}},
            {"enddate",new HotelCloud.SqlServer.DBParam{ParamValue=end}},
            {"sportkind",new HotelCloud.SqlServer.DBParam{ParamValue=kind}},
            {"times",new HotelCloud.SqlServer.DBParam{ParamValue=times}},
            {"descripe",new HotelCloud.SqlServer.DBParam{ParamValue=descripe}},
             {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
            });
            return s;
        }

        public bool insertPrize(string weixinid, string activityid, string level, string properly, int PrizetypeID, string PrizePrice, string PrizeName)
        {
            string sql = @"insert into Prize(weixinID,ActivityID,PrizeLevel,Probability,PrizetypeID,PrizePrice,PrizeName) values(@weixinid,@activityid,@prizelevel,@properly,@prizetypeid,@prizeprice,@prizename)";
            int n = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
            {"activityid",new HotelCloud.SqlServer.DBParam{ParamValue=activityid}},
            {"prizelevel",new HotelCloud.SqlServer.DBParam{ParamValue=level}},
            {"properly",new HotelCloud.SqlServer.DBParam{ParamValue=properly.ToString()}},
            {"prizetypeid",new HotelCloud.SqlServer.DBParam{ParamValue=PrizetypeID.ToString()}},
            {"prizeprice",new HotelCloud.SqlServer.DBParam{ParamValue=PrizePrice}},
            {"prizename",new HotelCloud.SqlServer.DBParam{ParamValue=PrizeName}}
            });
            return n > 0;
        }

        public DataTable GetActivity(string weixinid)
        {
            string sql = @"select (select SubName from Hotel where WeiXinID=@weixinid) as hotelname,Id,SportName,SportKind from Activitity where WeiXinID=@weixinid";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}}
            });
            return dt;
        }
        /// <summary>
        /// 抽奖列表
        /// </summary>
        /// <param name="weixinid"></param>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="count"></param>
        /// <returns></returns>
        public static DataTable FetchActivity(string weixinid, int pageSize, int currentPage,out int count)
        {
            int start = ((currentPage - 1) * pageSize) + 1;
            int end = currentPage * pageSize;
            string tsql = "select COUNT(0) from Activitity where WeiXinID=@weixinid and GETDATE() between StartDate and EndDate ";
            string value = HotelCloud.SqlServer.SQLHelper.Get_Value(tsql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}}
            });
            count = Convert.ToInt32(value);


            string sql = @"select * from (select *,ROW_NUMBER() over(order by id desc)row from Activitity where WeiXinID=@weixinid
                           and GETDATE() between StartDate and EndDate) as F where row>=@start and row<=@end";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
                {"start",new HotelCloud.SqlServer.DBParam{ParamValue=start.ToString()}},
                {"end",new HotelCloud.SqlServer.DBParam{ParamValue=end.ToString()}}
            });
            return dt;
        }

        public bool DelActivity(string weixinid, string sid)
        {
            string sql = "delete from Activitity where WeiXinID=@weixinid and Id=@sid";
            int n = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                {"sid",new HotelCloud.SqlServer.DBParam{ParamValue=sid}},
                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}} 
              });
            return n > 0;
        }
        public bool DelPrize(string weixinid, string sid)
        {
            string sql = "delete from Prize where WeiXinID=@weixinid and ActivityID=@sid";
            int n = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                {"sid",new HotelCloud.SqlServer.DBParam{ParamValue=sid}},
                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}} 
              });
            return n > 0;
        }

        public DataTable GetEditActivityByID(string weixinid, string id)
        {
            string sql = @"select * from Activitity a,Prize b where a.Id=b.ActivityID and a.Id=@id and a.WeiXinID=@weixinid";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                {"id",new HotelCloud.SqlServer.DBParam{ParamValue=id}},
                 {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
            });
            return dt;
        }
        public bool EditActivity(string sportname, string start, string end, string times, string descripe, string weixinid, string id)
        {
            //string sql = @"insert into Prize(weixinID,ActivityID,PrizeLevel,Probability,PrizetypeID,PrizePrice,PrizeName) values(@weixinid,@activityid,@prizelevel,@properly,@prizetypeid,@prizeprice,@prizename)";
            string sql = @"update Activitity set SportName=@sportname,StartDate=@startdate,EndDate=@enddate,Frequency=@times,Descripe=@descripe where WeiXinID=@weixinid and Id=@id";
            int n = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                {"sportname",new HotelCloud.SqlServer.DBParam{ParamValue=sportname}},
                {"startdate",new HotelCloud.SqlServer.DBParam{ParamValue=start}},
                {"enddate",new HotelCloud.SqlServer.DBParam{ParamValue=end}},
                {"times",new HotelCloud.SqlServer.DBParam{ParamValue=times}},
                {"descripe",new HotelCloud.SqlServer.DBParam{ParamValue=descripe}},
                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
                {"id",new HotelCloud.SqlServer.DBParam{ParamValue=id}}
            });
            return n > 0;
        }

        public bool EditPrize(string weixinid, string activityid, string level, string properly, int PrizetypeID, string PrizePrice, string PrizeName)
        {
            //string sql = @"insert into Prize(weixinID,ActivityID,PrizeLevel,Probability,PrizetypeID,PrizePrice,PrizeName) values(@weixinid,@activityid,@prizelevel,@properly,@prizetypeid,@prizeprice,@prizename)";
            string sql = "update Prize set Probability=@properly,PrizetypeID=@prizetypeid,PrizePrice=@prizeprice,PrizeName=@prizename where weixinID=@weixinid and ActivityID=@activityid and PrizeLevel=@prizelevel";
            int n = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
            {"activityid",new HotelCloud.SqlServer.DBParam{ParamValue=activityid}},
            {"prizelevel",new HotelCloud.SqlServer.DBParam{ParamValue=level}},
            {"properly",new HotelCloud.SqlServer.DBParam{ParamValue=properly.ToString()}},
            {"prizetypeid",new HotelCloud.SqlServer.DBParam{ParamValue=PrizetypeID.ToString()}},
            {"prizeprice",new HotelCloud.SqlServer.DBParam{ParamValue=PrizePrice}},
            {"prizename",new HotelCloud.SqlServer.DBParam{ParamValue=PrizeName}}
            });
            return n > 0;
        }

        public DataTable GetPrizeInfo(string weixinid, string sportkind, string activityid)
        {
            string sql = @"select * from Activitity a,Prize b where getdate() between a.StartDate and a.EndDate and a.SportKind=@sportkind and b.ActivityID=a.Id and a.WeiXinID=b.weixinID and a.WeiXinID=@weixinid and b.ActivityID=@activityid";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
                {"sportkind",new HotelCloud.SqlServer.DBParam{ParamValue=sportkind}},{"activityid",new HotelCloud.SqlServer.DBParam{ParamValue=activityid}}
            });
            return dt;
        }

        public DataTable GetPrizeInfoById(string weixinid, int sId)
        {
            string sql = @"select * from Activitity a,Prize b where getdate() between a.StartDate and a.EndDate and a.Id=@sId and b.ActivityID=a.Id and a.WeiXinID=b.weixinID and a.WeiXinID=@weixinid";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
                {"sId",new HotelCloud.SqlServer.DBParam{ParamValue=sId.ToString()}}
            });
            return dt;
        }

        public int CheckTimes(string weixinid, string userweixinid, string activityid)
        {
            string sql = @"select COUNT(1) from PrizeInfo where ActivityID=@activityid and Userweixinno=@userweixinid and weixinID=@weixinid and datediff(day,Choujiangtime ,getdate())=0";
            string n = HotelCloud.SqlServer.SQLHelper.Get_Value(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
            {"activityid",new HotelCloud.SqlServer.DBParam{ParamValue=activityid}},
            {"userweixinid",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinid}},
            });
            return Convert.ToInt32(n);
        }

        public DataTable GetJiLv(string activityid, string weixinid)
        {
            string sql = "select * from Prize where WeiXinID=@weixinid and ActivityID=@activityid";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
                {"activityid",new HotelCloud.SqlServer.DBParam{ParamValue=activityid}}
            });
            return dt;
        }
        public bool InsertResult(string activityid, string weixinid, string userweixinid, string result, int prizelevel)
        {
            string sql = @"insert into  PrizeInfo(ActivityID,Userweixinno,weixinID,Result,Choujiangtime,PrizeLevel) values(@activityid,@userweixinid,@weixinid,@result,getdate(),@prizelevel)";
            int n = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
            {"activityid",new HotelCloud.SqlServer.DBParam{ParamValue=activityid}},
            {"userweixinid",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinid}},
            {"result",new HotelCloud.SqlServer.DBParam{ParamValue=result}},
             {"prizelevel",new HotelCloud.SqlServer.DBParam{ParamValue=prizelevel.ToString()}}
            });
            return n > 0;
        }
        public DataTable AccountPrize(string weixinid, string activityid)
        {
            string sql = @"select (select COUNT(1) from PrizeInfo where ActivityID=@activityid and weixinID=@weixinid ) as total,(select COUNT(1) from PrizeInfo where PrizeLevel<4 and ActivityID=@activityid and weixinID=@weixinid) as prize,(select COUNT(1) from PrizeInfo where PrizeLevel=1 and ActivityID=@activityid and weixinID=@weixinid) as firstprize, (select COUNT(1) from PrizeInfo where PrizeLevel=2 and ActivityID=@activityid and weixinID=@weixinid) as sencondprize,
(select COUNT(1) from PrizeInfo where PrizeLevel=3 and ActivityID=@activityid and weixinID=@weixinid) as thirdprize, (select COUNT(1) from PrizeInfo where PrizeLevel=4 and ActivityID=@activityid and weixinID=@weixinid) as nonprize ";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
                 {"activityid",new HotelCloud.SqlServer.DBParam{ParamValue=activityid}}
            });
            return dt;
        }
        public DataTable PrizeInfoBypage(int pageNumber, int pageSize, string weixinid, out int count, string activityid)
        {
            int start = (pageNumber - 1) * pageSize + 1;
            int end = pageNumber * pageSize;
            string tsql = @"select COUNT(1) from PrizeInfo a,Activitity b where a.PrizeLevel <4 AND a.weixinID=@weixinid and a.ActivityID=b.Id and b.Id=@activityid";
            string sql = @"select * from (select a.Id,a.SportName,a.SportKind,a.Frequency,b.Userweixinno,b.Result,b.Choujiangtime,c.ID AS SID,ROW_NUMBER() over(order by a.Id desc) 
as RowNumber from Activitity a,PrizeInfo b,WeiXinUser c  where C.userWeiXinNO=B.Userweixinno AND a.Id=b.ActivityID and a.Id=@activityid and a.WeiXinID=@weixinid
 and b.PrizeLevel<4 ) z where RowNumber>=@start and RowNumber<=@end";
            string value = HotelCloud.SqlServer.SQLHelper.Get_Value(tsql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
             {"activityid",new HotelCloud.SqlServer.DBParam{ParamValue=activityid}}
            });
            count = Convert.ToInt32(value);
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                {"start",new HotelCloud.SqlServer.DBParam{ParamValue=start.ToString()}},
                {"end",new HotelCloud.SqlServer.DBParam{ParamValue=end.ToString()}},
                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
                 {"activityid",new HotelCloud.SqlServer.DBParam{ParamValue=activityid}}
            });
            return dt;
        }

        public DataTable SelectActivity(string weixinid)
        {
            string sql = @"select Id,SportName from Activitity where WeiXinID=@weixinid";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
            });
            return dt;
        }

        public void InsertCoupon(string weixinid, string moneys, string userweixinno)
        {
            DateTime dt = DateTime.Now;
            DateTime start = DateTime.Now.AddDays(-2);
            DateTime end = DateTime.Now.AddDays(100);
            string conpon = DateTime.Now.ToString("yyMMddHHmmssfff");
            string sql = @"insert into CouPonContent(weixinID,moneys,sTime,ExtTime,addTime,IsEmploy,CouPonNO,userweixinNo) values(@weixinid,@moneys,@stime,@exttime,@addTime,@IsEmploy,@conpon,@userweixinno)";
            int n = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=weixinid}},
            {"moneys",new HotelCloud.SqlServer.DBParam{ParamValue=moneys}},
            {"stime",new HotelCloud.SqlServer.DBParam{ParamValue=start.ToString()}},
            {"exttime",new HotelCloud.SqlServer.DBParam{ParamValue=end.ToString()}},
            {"conpon",new HotelCloud.SqlServer.DBParam{ParamValue=conpon}},
            {"userweixinno",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinno}},
            {"IsEmploy",new HotelCloud.SqlServer.DBParam{ParamValue="0"}},
            {"addTime",new HotelCloud.SqlServer.DBParam{ParamValue=DateTime.Now.ToString()}}
            });
        }
    }
}