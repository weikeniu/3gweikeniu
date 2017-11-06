using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WeiXin.Models.Home;
using System.Text;
using System.Data;
using WeiXin.Common;
namespace WeiXin.Models.DAL
{
    public class RechargeCardDAL
    {
        /// <summary>
        /// 增加一条储值卡数据
        /// </summary>
        public static int AddRechargeCard(RechargeCard model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into RechargeCard(");
            strSql.Append("PasswordStatus,UseRange,AddTime,AddPerson,LastUpdateTime,WeixinId,HotelId,Name,MPrice,Sprice,TotalNum,SaleNum,SaleStatus");
            strSql.Append(") values (");
            strSql.Append("@PasswordStatus,@UseRange,@AddTime,@AddPerson,@LastUpdateTime,@WeixinId,@HotelId,@Name,@MPrice,@Sprice,@TotalNum,@SaleNum,@SaleStatus");
            strSql.Append(") ");
            strSql.Append(";select @@IDENTITY");


            string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"PasswordStatus",new HotelCloud.SqlServer.DBParam{ParamValue=model.PasswordStatus.ToString()}},
             {"UseRange",new HotelCloud.SqlServer.DBParam{ParamValue=model.UseRange}},
              {"AddTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.AddTime.ToString()}},
              {"AddPerson",new HotelCloud.SqlServer.DBParam{ParamValue=model.AddPerson.ToString()}},
              {"LastUpdateTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.LastUpdateTime.ToString()}},
              {"WeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.WeixinId.ToString()}},
              {"HotelId",new HotelCloud.SqlServer.DBParam{ParamValue=model.HotelId.ToString()}},
               {"Name",new HotelCloud.SqlServer.DBParam{ParamValue=model.Name.ToString()}},
               {"MPrice",new HotelCloud.SqlServer.DBParam{ParamValue=model.MPrice.ToString()}},
               {"Sprice",new HotelCloud.SqlServer.DBParam{ParamValue=model.Sprice.ToString()}},
              {"TotalNum",new HotelCloud.SqlServer.DBParam{ParamValue=model.TotalNum.ToString()}},
              {"SaleNum",new HotelCloud.SqlServer.DBParam{ParamValue=model.SaleNum.ToString()}},
              {"SaleStatus",new HotelCloud.SqlServer.DBParam{ParamValue=model.SaleStatus.ToString()}}
        });


            if (!string.IsNullOrEmpty(obj))
            {
                return Convert.ToInt32(obj);
            }

            return 0;


        }


        public static int UpdateRechargeCard(RechargeCard model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("update RechargeCard set ");
            strSql.Append(" PasswordStatus = @PasswordStatus , ");
            strSql.Append(" UseRange = @UseRange , "); ;
            strSql.Append(" LastUpdateTime = @LastUpdateTime , ");
            strSql.Append(" Name = @Name , ");
            strSql.Append(" MPrice = @MPrice , ");
            strSql.Append(" Sprice = @Sprice , ");
            strSql.Append(" SaleStatus = @SaleStatus  ");
            strSql.Append(" where WeixinId=@WeixinId  and Id=@Id ");


            int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"PasswordStatus",new HotelCloud.SqlServer.DBParam{ParamValue=model.PasswordStatus.ToString()}},
             {"UseRange",new HotelCloud.SqlServer.DBParam{ParamValue=model.UseRange}},            
              {"LastUpdateTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.LastUpdateTime.ToString()}},           
               {"Name",new HotelCloud.SqlServer.DBParam{ParamValue=model.Name.ToString()}},
               {"MPrice",new HotelCloud.SqlServer.DBParam{ParamValue=model.MPrice.ToString()}},
               {"Sprice",new HotelCloud.SqlServer.DBParam{ParamValue=model.Sprice.ToString()}},                        
              {"SaleStatus",new HotelCloud.SqlServer.DBParam{ParamValue=model.SaleStatus.ToString()}},
              {"WeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.WeixinId.ToString()}},
              {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=model.Id.ToString()}}
        });

            return row;

        }




        public static DataTable GeteRechargeCard(string weixinId, int Id)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("select Id, PasswordStatus, UseRange, AddTime, AddPerson, LastUpdateTime, WeixinId, HotelId, Name, MPrice, Sprice, TotalNum, SaleNum, SaleStatus  ");
            strSql.Append("  from RechargeCard with(nolock) ");
            strSql.Append(" where  weixinId=@weixinId  and  Id=@Id");

            DataTable db = HotelCloud.SqlServer.SQLHelper.Get_DataTable(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
              {"WeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weixinId}},
              {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id.ToString()}}
            });


            return db;

        }




        public static DataTable GeteRechargeCardList(string weiXinID, out int count, int page, int pagesize, string select, string query)
        {

            StringBuilder tsql = new StringBuilder();
            tsql.Append(@"select count(0) from RechargeCard  with(nolock) where weixinId=@weixinId  and  saleStatus=1  and  totalNum >saleNum  and IsEnabled=1   ");


            StringBuilder sql = new StringBuilder();
            sql.Append(@"select * from (
                     select  ROW_NUMBER() over(order by Id  desc)num  ,* from RechargeCard  r  with(Nolock)  
                                where weixinId=@weixinId  and  saleStatus=1  and  totalNum >saleNum  and IsEnabled=1  ");

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
            {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinID}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            count = Convert.ToInt32(value);
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinID}},
            {"startID",new HotelCloud.SqlServer.DBParam{ParamValue=((page-1)*pagesize+1).ToString()}},
            {"endID",new HotelCloud.SqlServer.DBParam{ParamValue=(page*pagesize).ToString()}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            return dt;

        }


        public static DataTable GetRechargeMemberInfo(string hotelweiXinId, string userweixinId)
        {
            StringBuilder strSql = new StringBuilder();

            strSql.Append("Select Id,name,mobile,nickname,cardno, viptype,userWeixinNo,balance  from Member with(nolock) where  weixinId=@weixinId  and  userweixinNo=@userweixinNo");

            DataTable db = HotelCloud.SqlServer.SQLHelper.Get_DataTable(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
              {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelweiXinId}},
              {"userweixinNo",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}}
            });

            return db;
        }


        public static DataTable GetRechargeMemberInfoByMobile(string weiXinId, string mobile)
        {
            StringBuilder strSql = new StringBuilder();

            strSql.Append("Select name,mobile,nickname,cardno, viptype,userWeixinNo,balance  from Member with(nolock) where  weixinId=@weixinId  and  mobile=@mobile  and ISNULL(cardno,'')<>  ''  ");

            DataTable db = HotelCloud.SqlServer.SQLHelper.Get_DataTable(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
              {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinId}},
              {"mobile",new HotelCloud.SqlServer.DBParam{ParamValue=mobile}}
            });

            return db;
        }



        public static DataTable GetRechargeMemberPayPassword(string hotelweiXinId, string userweixinId)
        {
            StringBuilder strSql = new StringBuilder();

            strSql.Append("Select pwd  from Member with(nolock) where  weixinId=@weixinId  and  userweixinNo=@userweixinNo");

            DataTable db = HotelCloud.SqlServer.SQLHelper.Get_DataTable(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
              {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelweiXinId}},
              {"userweixinNo",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}}
            });

            return db;
        }



        public static int GeteRechargeCardCount(string weiXinID)
        {
            StringBuilder tsql = new StringBuilder();
            tsql.Append(@"select count(0) from RechargeCard  with(nolock) where weixinId=@weixinId  and  saleStatus=1  and  totalNum >saleNum   ");

            string value = HotelCloud.SqlServer.SQLHelper.Get_Value(tsql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinID}}
                  });

            return Convert.ToInt32(value);


        }

        public static int UpdateRechargeMemberPayPassword(string hotelweiXinId, string userweixinId, string paypassword)
        {
            StringBuilder strSql = new StringBuilder();

            strSql.Append("update Member set  pwd=@pwd    where  weixinId=@weixinId  and  userweixinNo=@userweixinNo");
            int rows = HotelCloud.SqlServer.SQLHelper.Run_SQL(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
              {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelweiXinId}},
              {"userweixinNo",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}},
                {"pwd",new HotelCloud.SqlServer.DBParam{ParamValue=paypassword}},
            });

            return rows;
        }





        /// <summary>
        /// 充值会员账户余额
        /// </summary>
        /// <param name="hotelweiXinId"></param>
        /// <param name="userweixinId"></param>
        /// <param name="addmoney">充值金额</param>
        /// <returns></returns>
        public static int UpdateRechargeMemberBalance(string hotelweiXinId, string userweixinId, decimal addmoney)
        {
            StringBuilder strSql = new StringBuilder();

            strSql.Append("update  Member set  balance=balance+ @money   where  weixinId=@weixinId  and  userWeiXinNO=@userWeiXinNO ");

            int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
              {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelweiXinId}},
              {"userWeiXinNO",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}},
               {"money",new HotelCloud.SqlServer.DBParam{ParamValue=addmoney.ToString() }}
            });

            return row;
        }




        /// <summary>
        /// 扣除会员账户余额
        /// </summary>
        /// <param name="hotelweiXinId"></param>
        /// <param name="userweixinId"></param>
        /// <param name="reduceMoney">扣除金额</param>
        /// <returns></returns>
        public static int ReduceRechargeMemberBalance(string hotelweiXinId, string userweixinId, decimal reduceMoney)
        {
            StringBuilder strSql = new StringBuilder();

            strSql.Append("update  Member set  balance=balance -  @money   where  weixinId=@weixinId  and  userWeiXinNO=@userWeiXinNO  and  balance>=@money  ");

            int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
              {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelweiXinId}},
              {"userWeiXinNO",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}},
               {"money",new HotelCloud.SqlServer.DBParam{ParamValue=reduceMoney.ToString() }}
            });

            return row;
        }








    }



    public class RechargeUserDAL
    {

        public static int AddRechargeUser(RechargeUser model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into RechargeUser(");
            strSql.Append("SPrice,Beforebalance,balance,PayType,OrderStatus,Source,IsCardPassword,AddTime,OrderNo,HotelWeixinId,HotelId,UserWeixinId,UserName,UserMobile,UserLevel,MPrice,CardId,TradeOrderNo");
            strSql.Append(") values (");
            strSql.Append("@SPrice,@Beforebalance,@balance,@PayType,@OrderStatus,@Source,@IsCardPassword,@AddTime,@OrderNo,@HotelWeixinId,@HotelId,@UserWeixinId,@UserName,@UserMobile,@UserLevel,@MPrice,@CardId,@TradeOrderNo");
            strSql.Append(") ");
            strSql.Append(";select @@IDENTITY");

            string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"SPrice",new HotelCloud.SqlServer.DBParam{ParamValue=model.SPrice.ToString()}},
             {"Beforebalance",new HotelCloud.SqlServer.DBParam{ParamValue=model.Beforebalance.ToString()}},
              {"balance",new HotelCloud.SqlServer.DBParam{ParamValue=model.Balance.ToString()}},
              {"PayType",new HotelCloud.SqlServer.DBParam{ParamValue=model.PayType.ToString()}},
              {"OrderStatus",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderStatus.ToString()}},
              {"Source",new HotelCloud.SqlServer.DBParam{ParamValue=model.Source.ToString()}},
              {"IsCardPassword",new HotelCloud.SqlServer.DBParam{ParamValue=model.IsCardPassword.ToString()}},
               {"AddTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.AddTime.ToString()}},
               {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderNo.ToString()}},
               {"HotelWeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.HotelWeixinId.ToString()}},
               {"HotelId",new HotelCloud.SqlServer.DBParam{ParamValue=model.HotelId.ToString()}},
              {"UserWeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserWeixinId.ToString()}},
              {"UserName",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserName.ToString()}},
              {"UserMobile",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserMobile.ToString()}},
              {"UserLevel",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserLevel.ToString()}},
              {"MPrice",new HotelCloud.SqlServer.DBParam{ParamValue=model.MPrice.ToString()}},
              {"CardId",new HotelCloud.SqlServer.DBParam{ParamValue=model.CardId.ToString()}},
              {"TradeOrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=model.TradeOrderNo}}

        });


            if (!string.IsNullOrEmpty(obj))
            {
                return Convert.ToInt32(obj);
            }

            return 0;
        }


        public static DataTable GeteRechargeUserList(string hotelweiXinId, string userWeixinId, out int count, int page, int pagesize, string select, string query)
        {
            StringBuilder tsql = new StringBuilder();
            tsql.Append(@"select count(0) from RechargeUser  with(nolock) where hotelweixinId=@hotelweixinId   and userWeixinId=@userWeixinId  and  orderStatus=1  ");


            StringBuilder sql = new StringBuilder();
            sql.Append(@"select * from (
                     select  ROW_NUMBER() over(order by Id  desc)num  ,* from RechargeUser  r  with(Nolock)  
                                where hotelweixinId=@hotelweixinId and userWeixinId=@userWeixinId  and  orderStatus=1   ");

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
            {"hotelweixinId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelweiXinId}},
             {"userWeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=userWeixinId}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            count = Convert.ToInt32(value);

            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"hotelweixinId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelweiXinId}},
            {"startID",new HotelCloud.SqlServer.DBParam{ParamValue=((page-1)*pagesize+1).ToString()}},
            {"endID",new HotelCloud.SqlServer.DBParam{ParamValue=(page*pagesize).ToString()}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}},
            {"userWeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=userWeixinId}}
            });
            return dt;


        }



        public static RechargeTJEntity GetTJRechargeCardInfo(string weiXinId)
        {
            RechargeTJEntity model = new RechargeTJEntity();

            StringBuilder strSql = new StringBuilder();
            strSql.AppendLine("Select  Isnull(SUM(mprice),0)price  from RechargeUser  with(nolock)  where HotelweixinId=@weixinId ");

            strSql.AppendLine("select count(distinct UserMobile)num  from RechargeUser  with(nolock)   where HotelweixinId=@weixinId ");

            DataSet ds = HotelCloud.SqlServer.SQLHelper.Get_DataSet(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
            {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinId}},
           
            });

            model.SaleMoney = Convert.ToDecimal(ds.Tables[0].Rows[0]["price"].ToString());
            model.UserCount = Convert.ToInt32(ds.Tables[1].Rows[0]["num"].ToString());

            return model;
        }


        public static DataTable GeteRechargUser(string weixinId, int Id)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("select *   from RechargeUser with(nolock)   where  hotelweixinId=@weixinId  and  Id=@Id ");

            DataTable db = HotelCloud.SqlServer.SQLHelper.Get_DataTable(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
              {"WeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weixinId}},
              {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id.ToString()}}
            });


            return db;

        }



        public static DataTable GeteRechargUserByTradeOrderNo(string tradeOrderNo)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("select *   from RechargeUser with(nolock)   where  tradeOrderNo=@tradeOrderNo  ");

            DataTable db = HotelCloud.SqlServer.SQLHelper.Get_DataTable(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
              {"tradeOrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=tradeOrderNo}}              
            });
            return db;

        }


    }


    public class RechargeUserPasswordDAL
    {
        public static DataTable GeteCardPassword(string weixinId, string cardPassword)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("select * from  RechargeUserPassword   with(nolock) where  weixinId=@weixinId  and  cardPassword=@cardPassword  and  CardStatus=0  ");

            DataTable db = HotelCloud.SqlServer.SQLHelper.Get_DataTable(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
              {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weixinId}},
              {"cardPassword",new HotelCloud.SqlServer.DBParam{ParamValue=cardPassword}}
            });
            return db;
        }


        public static int  UpdateCardPasswordStatus(string weixinId, string cardPassword, int cardStatus)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("update   RechargeUserPassword  set cardStatus=@cardStatus   where  weixinId=@weixinId  and  cardPassword=@cardPassword  and  CardStatus=0  ");

            int  row = HotelCloud.SqlServer.SQLHelper.Run_SQL(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
              {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weixinId}},
              {"cardPassword",new HotelCloud.SqlServer.DBParam{ParamValue=cardPassword}},
             {"cardStatus",new HotelCloud.SqlServer.DBParam{ParamValue=cardStatus.ToString()}}
            });

            return row;
        }
    }


    public class RechargeRangeDAL
    {
        public static int AddModel(RechargeRange model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into RechargeRange(");
            strSql.Append("weixinId,UseRange,Remark");
            strSql.Append(") values (");
            strSql.Append("@weixinId,@UseRange,@Remark ");
            strSql.Append(") ");
            strSql.Append(";select @@IDENTITY");

            string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {              
              {"UseRange",new HotelCloud.SqlServer.DBParam{ParamValue=model.UseRange}},
              {"Remark",new HotelCloud.SqlServer.DBParam{ParamValue=model.Remark}},
              {"WeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.WeixinId.ToString()}}            
              });

            if (!string.IsNullOrEmpty(obj))
            {
                return Convert.ToInt32(obj);
            }
            return 0;
        }



        public static int UpdateModel(RechargeRange model)
        {

            StringBuilder strSql = new StringBuilder();
            strSql.Append("update RechargeRange set ");
            strSql.Append(" UseRange = @UseRange , ");
            strSql.Append(" Remark = @Remark  ");
            strSql.Append(" where weixinId=@weixinId  ");

            int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {             
                {"UseRange",new HotelCloud.SqlServer.DBParam{ParamValue=model.UseRange}},
              {"Remark",new HotelCloud.SqlServer.DBParam{ParamValue=model.Remark}},
              {"WeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.WeixinId.ToString()}}       
            });
            return row;
        }


        public static DataTable GetRechargeRange(string weixinId)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("select *    from RechargeRange with(nolock)  where  weixinId=@weixinId   ");

            DataTable db = HotelCloud.SqlServer.SQLHelper.Get_DataTable(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
            {
              {"WeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weixinId}} 
            });

            return db;
        }

    }
}