using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text; 
using System.Data;
using hotel3g.Models.Home;

namespace hotel3g.Models.DAL
{
    public class MemberCardCustomDAL
    {

        /// <summary>
        /// 增加一条数据
        /// </summary>
        public static int AddModel(MemberCardCustom model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into MemberCardCustom(");
            strSql.Append("Reduce,JiFen,CardLevel,AddTime,LastUpdateTime,CardName,HotelId,WeixinId,IncreaseType,Rooms,BuyMoney,CouponType,Discount,Status");
            strSql.Append(") values (");
            strSql.Append("@Reduce,@JiFen,@CardLevel,@AddTime,@LastUpdateTime,@CardName,@HotelId,@WeixinId,@IncreaseType,@Rooms,@BuyMoney,@CouponType,@Discount,@Status");
            strSql.Append(") ");
            strSql.Append(";select @@IDENTITY");
            string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"Reduce",new HotelCloud.SqlServer.DBParam{ParamValue=model.Reduce.ToString()}},
             {"JiFen",new HotelCloud.SqlServer.DBParam{ParamValue=model.JiFen.ToString()}},
              {"CardLevel",new HotelCloud.SqlServer.DBParam{ParamValue=model.CardLevel.ToString()}},
              {"AddTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.AddTime.ToString()}},
              {"LastUpdateTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.LastUpdateTime.ToString()}},
              {"CardName",new HotelCloud.SqlServer.DBParam{ParamValue=model.CardName.ToString()}},
              {"HotelId",new HotelCloud.SqlServer.DBParam{ParamValue=model.HotelId.ToString()}},           
               {"WeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.WeixinId.ToString()}},
               {"IncreaseType",new HotelCloud.SqlServer.DBParam{ParamValue=model.IncreaseType.ToString()}},
               {"Rooms",new HotelCloud.SqlServer.DBParam{ParamValue=model.Rooms.ToString()}},
              {"BuyMoney",new HotelCloud.SqlServer.DBParam{ParamValue=model.BuyMoney.ToString()}},
              {"CouponType",new HotelCloud.SqlServer.DBParam{ParamValue=model.CouponType.ToString()}},
              {"Discount",new HotelCloud.SqlServer.DBParam{ParamValue=model.Discount.ToString()}},
              {"Status",new HotelCloud.SqlServer.DBParam{ParamValue=model.Status.ToString()}},
           
        });

            if (!string.IsNullOrEmpty(obj))
            {
                return Convert.ToInt32(obj);
            }

            return 0;
        }

        public static int  UpdateModel(MemberCardCustom model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("update MemberCardCustom set ");
            strSql.Append(" Reduce = @Reduce , ");
            strSql.Append(" JiFen = @JiFen , ");
            strSql.Append(" CardLevel = @CardLevel , ");
            strSql.Append(" LastUpdateTime = @LastUpdateTime , ");
            strSql.Append(" CardName = @CardName , ");
            strSql.Append(" IncreaseType = @IncreaseType , ");
            strSql.Append(" Rooms = @Rooms , ");
            strSql.Append(" BuyMoney = @BuyMoney , ");
            strSql.Append(" CouponType = @CouponType , ");
            strSql.Append(" Discount = @Discount  ");
            strSql.Append(" where Id=@Id  and WeixinId=@WeixinId");


            int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"Reduce",new HotelCloud.SqlServer.DBParam{ParamValue=model.Reduce.ToString()}},
             {"JiFen",new HotelCloud.SqlServer.DBParam{ParamValue=model.JiFen.ToString()}},
              {"CardLevel",new HotelCloud.SqlServer.DBParam{ParamValue=model.CardLevel.ToString()}},           
              {"LastUpdateTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.LastUpdateTime.ToString()}},
              {"CardName",new HotelCloud.SqlServer.DBParam{ParamValue=model.CardName.ToString()}},           
               {"WeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.WeixinId.ToString()}},
               {"IncreaseType",new HotelCloud.SqlServer.DBParam{ParamValue=model.IncreaseType.ToString()}},
               {"Rooms",new HotelCloud.SqlServer.DBParam{ParamValue=model.Rooms.ToString()}},
              {"BuyMoney",new HotelCloud.SqlServer.DBParam{ParamValue=model.BuyMoney.ToString()}},
              {"CouponType",new HotelCloud.SqlServer.DBParam{ParamValue=model.CouponType.ToString()}},
              {"Discount",new HotelCloud.SqlServer.DBParam{ParamValue=model.Discount.ToString()}},          
              {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=model.Id.ToString()}},      
        });
            return row;

        }



        public static DataTable GetModel(int Id, string weixinId)
        {
            string strSql = "select  *   from MemberCardCustom  with(nolock) where Id=@Id  and  weixinId=@weixinId  ";
            DataTable  db = HotelCloud.SqlServer.SQLHelper.Get_DataTable(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id.ToString()}},
             {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weixinId.ToString()}}          

            });
            return db;
        }


        public static int UpdateModelStatus(int Id,string weixinId,int status)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("update MemberCardCustom set ");
            strSql.Append(" Status = @Status , ");          
            strSql.Append(" LastUpdateTime = @LastUpdateTime  ");
            strSql.Append(" where Id=@Id  and WeixinId=@WeixinId");
            int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"Id",new HotelCloud.SqlServer.DBParam{ParamValue= Id.ToString()}},
             {"WeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weixinId.ToString()}},
             {"Status",new HotelCloud.SqlServer.DBParam{ParamValue=status.ToString()}},            
               {"LastUpdateTime",new HotelCloud.SqlServer.DBParam{ParamValue=DateTime.Now.ToString()}},
             });


            return row;
        }

        public static DataTable GetMemberCardCustomList(string weixinID, out int count, int page, int pagesize, string select, string query)
        {
            StringBuilder tsql = new StringBuilder();
            tsql.Append(@"select count(0) from MemberCardCustom  with(nolock) where weixinID=@weixinID   and Status=1   ");


            StringBuilder sql = new StringBuilder();
            sql.Append(@"select * from (
                     select  ROW_NUMBER() over(order by cardLevel   )num  ,* from MemberCardCustom  m  with(Nolock)    where weixinID=@weixinID  and Status=1    ");

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
            });
            return dt;


        }



    }




    public class MemberCardBuyRecordDAL
    {

        /// <summary>
        /// 增加一条数据
        /// </summary>
        public static int AddModel(MemberCardBuyRecord model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into MemberCardBuyRecord(");
            strSql.Append("OrderNo,HotelId,WeixinId,userWeixinId,CardId,BuyMoney,CardName,CardLevel,OrderStatus,AddTime,Name,Mobile");
            strSql.Append(") values (");
            strSql.Append("@OrderNo,@HotelId,@WeixinId,@userWeixinId,@CardId,@BuyMoney,@CardName,@CardLevel,@OrderStatus,@AddTime,@Name,@Mobile");
            strSql.Append(") ");
            strSql.Append(";select @@IDENTITY");

            string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderNo.ToString()}},
             {"HotelId",new HotelCloud.SqlServer.DBParam{ParamValue=model.HotelId.ToString()}},
              {"WeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.WeixinId.ToString()}},
              {"userWeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.userWeixinId.ToString()}},
              {"CardId",new HotelCloud.SqlServer.DBParam{ParamValue=model.CardId.ToString()}},
              {"BuyMoney",new HotelCloud.SqlServer.DBParam{ParamValue=model.BuyMoney.ToString()}},
              {"CardName",new HotelCloud.SqlServer.DBParam{ParamValue=model.CardName.ToString()}},           
               {"CardLevel",new HotelCloud.SqlServer.DBParam{ParamValue=model.CardLevel.ToString()}},
              {"OrderStatus",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderStatus.ToString()}},           
               {"AddTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.AddTime.ToString()}},
                  {"Name",new HotelCloud.SqlServer.DBParam{ParamValue=model.Name.ToString()}},           
               {"Mobile",new HotelCloud.SqlServer.DBParam{ParamValue=model.Mobile.ToString()}},
              });


            if (!string.IsNullOrEmpty(obj))
            {
                return Convert.ToInt32(obj);
            }

            return 0;

        }



        public static DataTable GetMemberCardRecordList(string weixinID, string userweixinId, out int count, int page, int pagesize, string select, string query)
        {
            StringBuilder tsql = new StringBuilder();
            tsql.Append(@"select count(0) from MemberCardBuyRecord  with(nolock) where weixinID=@weixinID   and userweixinId=@userweixinId    ");


            StringBuilder sql = new StringBuilder();
            sql.Append(@"select * from (
                     select  ROW_NUMBER() over(order by cardLevel  desc)num  ,* from MemberCardBuyRecord  m  with(Nolock) where  weixinID=@weixinID   and userweixinId=@userweixinId  ");

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
              {"userweixinId",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}},     
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            count = Convert.ToInt32(value);

            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
            {"userweixinId",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}},     
            {"startID",new HotelCloud.SqlServer.DBParam{ParamValue=((page-1)*pagesize+1).ToString()}},
            {"endID",new HotelCloud.SqlServer.DBParam{ParamValue=(page*pagesize).ToString()}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}},            
            });
            return dt;


        }

    }
}