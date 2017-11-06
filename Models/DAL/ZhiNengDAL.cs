using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Data;

namespace hotel3g.Models.DAL
{

    public class HotelServicesDAL
    {
        public static int AddHotelServices(Models.Home.HotelServices model)
        {

            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into HotelServices(");
            strSql.Append("WeiXinId,UserweixinId,HotelId,ServiceTime,RoomNo,Mobile,Remark,Type,Status,AddTime,Goods,UserName,Feedback1,Feedback2,Feedback3,Feedback4,Feedback5,FMoney,FType");
            strSql.Append(") values (");
            strSql.Append("@WeiXinId,@UserweixinId,@HotelId,@ServiceTime,@RoomNo,@Mobile,@Remark,@Type,@Status,getdate(),@Goods,@UserName,@Feedback1,@Feedback2,@Feedback3,@Feedback4,@Feedback5,@FMoney,@FType");
            strSql.Append(") ");
            strSql.Append(";select @@IDENTITY");
            string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"WeiXinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.WeiXinId.ToString()}},
             {"UserweixinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserweixinId.ToString()}},
              {"HotelId",new HotelCloud.SqlServer.DBParam{ParamValue=model.HotelId.ToString()}},
             {"ServiceTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.ServiceTime.ToString()}},             
              {"RoomNo",new HotelCloud.SqlServer.DBParam{ParamValue=model.RoomNo.ToString()}},
             {"Mobile",new HotelCloud.SqlServer.DBParam{ParamValue=model.Mobile.ToString()}},
              {"Remark",new HotelCloud.SqlServer.DBParam{ParamValue=model.Remark.ToString()}},
             {"Type",new HotelCloud.SqlServer.DBParam{ParamValue=model.Type.ToString()}},
             {"Status",new HotelCloud.SqlServer.DBParam{ParamValue=model.Status.ToString()}},             
             {"AddTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.AddTime.ToString()}},     
            {"Goods",new HotelCloud.SqlServer.DBParam{ParamValue=model.Goods.ToString()}},             
             {"UserName",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserName.ToString()}},  
              {"Feedback1",new HotelCloud.SqlServer.DBParam{ParamValue=model.Feedback1.ToString()}},  
               {"Feedback2",new HotelCloud.SqlServer.DBParam{ParamValue=model.Feedback2.ToString()}},  
                {"Feedback3",new HotelCloud.SqlServer.DBParam{ParamValue=model.Feedback3.ToString()}},  
                 {"Feedback4",new HotelCloud.SqlServer.DBParam{ParamValue=model.Feedback4.ToString()}},  
                  {"Feedback5",new HotelCloud.SqlServer.DBParam{ParamValue=model.Feedback5.ToString()}},  
                   {"FMoney",new HotelCloud.SqlServer.DBParam{ParamValue=model.FMoney.ToString()}}, 
                     {"FType",new HotelCloud.SqlServer.DBParam{ParamValue=model.FType.ToString()}},  
            });


            if (!string.IsNullOrEmpty(obj))
            {
                return Convert.ToInt32(obj);
            }

            return 0;
        }


        public static DataTable GetHotelServices(int Id, string userweixinId)
        {
            string sql = @"select * from HotelServices  with(nolock)  where  Id=@Id   and UserweixinId=@UserweixinId  ";
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id.ToString()}},
             {"UserweixinId",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId.ToString()}},
         
            });
            return dt;
        }




        public static DataTable GeteHotelServicesList(string userweixinId, out int count, int page, int pagesize, string select, string query)
        {
            StringBuilder tsql = new StringBuilder();
            tsql.Append(@"select count(0) from HotelServices  with(nolock) where userweixinId=@userweixinId    ");

            StringBuilder sql = new StringBuilder();
            sql.Append(@"select * from (
                     select  ROW_NUMBER() over(order by Id  desc)num  ,* from HotelServices  r  with(Nolock)  
                                where userweixinId=@userweixinId    ");

            if (string.IsNullOrEmpty(select))
            {
                sql.Append(") a where a.num between @startID and @endID");
            }
            if (!string.IsNullOrEmpty(select))
            {
                tsql.Append(" and " + select + " like '%'+@query+'%'");
                sql.Append(" and " + select + " like '%'+@query+'%') a where a.num between @startID and @endID");
            }

            string value = HotelCloud.SqlServer.SQLHelper.Get_Value(tsql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"userweixinId",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            count = Convert.ToInt32(value);
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"userweixinId",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}},
            {"startID",new HotelCloud.SqlServer.DBParam{ParamValue=((page-1)*pagesize+1).ToString()}},
            {"endID",new HotelCloud.SqlServer.DBParam{ParamValue=(page*pagesize).ToString()}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            return dt;

        }
    }

}


