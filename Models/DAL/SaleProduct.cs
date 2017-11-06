using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;
using WeiXin.Common;


namespace WeiXin.Models.DAL
{
    public class SaleProduct
    {

        public static DataTable GetHotelInfo(string weixinId)
        {
            string sql = @"select h.*,w.WeiXin2Img from Hotel  h with(Nolock)  inner join  weixinNo  w with(nolock) on h.WeixinID=w.WeixinID   where  h.WeixinID=@WeixinID   ";
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"WeixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinId}},
         
            });
            return dt;
        }


        public static DataTable GetSaleProducts(string weiXinID, out int count, int page, int pagesize, string select, string query)
        {

            StringBuilder tsql = new StringBuilder();
            tsql.Append(@"select count(*) from SaleProducts with(Nolock) where WeiXinID=@weiXinID  and  EndTime>GETDATE() and status=0 ");
            StringBuilder sql = new StringBuilder();
            sql.Append(@"select * from (
                     select  ROW_NUMBER() over(order by Id)num  ,* from SaleProducts  s  with(nolock) 
                                where WeiXinID=@weiXinID and  EndTime>GETDATE()  and  status=0 ");
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
            {"weiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinID}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            count = Convert.ToInt32(value);
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinID}},
            {"startID",new HotelCloud.SqlServer.DBParam{ParamValue=((page-1)*pagesize+1).ToString()}},
            {"endID",new HotelCloud.SqlServer.DBParam{ParamValue=(page*pagesize).ToString()}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            return dt;

        }


        public static DataTable GetSaleProductsListIndex2(string weiXinID, out int count, int page, int pagesize, string select, string query)
        {
            StringBuilder tsql = new StringBuilder();
            tsql.Append(@"select count(0) from SaleProducts with(Nolock) where WeiXinID=@weiXinID  and  EndTime>GETDATE() and status=0 ");
            StringBuilder sql = new StringBuilder();

            sql.Append(@"select * from (  select  ROW_NUMBER() over(order by issale desc ,Id)num,* from (
 select   *, CASE WHEN  minPrice =0 then  0 else 1  end  IsSale   from (select  Id, ProductType,ProductName,BeginTime,EndTime, EffectiveBeginTime,EffectiveEndTime,LastUpdatetime,
SaleChannel,Status,ImageList, SmallImageList,BigImageList  ,CASE WHEN  ProductType =0  THEN  
 (select  ISNULL( MIN(ProductPrice),0) from   SaleProducts_TC t    with(nolock)  
  where   RequestId=s.Id  and ProductNum  >0 and  ProductPrice >0) 
  ELSE (select   ISNULL( MIN(Price),0)  from   SaleProducts_TC_Price p  with(nolock)   where  
    RequestId  in(select  id from  SaleProducts_TC   t  with(nolock) where  t.RequestId=s.Id  )   and SaleTime >=CONVERT(varchar(12) , getdate(), 111 )   and  Stock  >0   and  Price >0      ) 
        END   minPrice  from    SaleProducts    s with(Nolock)   where WeiXinID=@weiXinID and  EndTime>GETDATE()  and  status=0   ");

            if (string.IsNullOrEmpty(select))
            {
                sql.Append("  )t )tt ) a where a.num between @startID and @endID");
            }
            if (!string.IsNullOrEmpty(select))
            {
                tsql.Append(" and " + select + " like '%'+@query+'%'");
                sql.Append(" and " + select + " like '%'+@query+'%'  )t )tt) a where a.num between @startID and @endID");
            }

            string value = HotelCloud.SqlServer.SQLHelper.Get_Value(tsql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinID}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            count = Convert.ToInt32(value);
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinID}},
            {"startID",new HotelCloud.SqlServer.DBParam{ParamValue=((page-1)*pagesize+1).ToString()}},
            {"endID",new HotelCloud.SqlServer.DBParam{ParamValue=(page*pagesize).ToString()}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            return dt;

        }



        public static DataTable GetSaleProductsListIndex(string weiXinID, out int count, int page, int pagesize, string select, string query)
        {
            StringBuilder tsql = new StringBuilder();
            tsql.Append(@"select count(0) from SaleProducts with(Nolock) where WeiXinID=@weiXinID  and  EndTime>GETDATE() and status=0  and  minprice >0 ");
            StringBuilder sql = new StringBuilder();

            sql.Append(@"select * from (  select  ROW_NUMBER() over(order by sort desc, minPrice )num,* from (
 select   *  from (select  Id, ProductType,ProductName,BeginTime,EndTime, EffectiveBeginTime,EffectiveEndTime,LastUpdatetime,
SaleChannel,Status,ImageList, SmallImageList,BigImageList , MainPic,BigMainPic,smallMainPic,MenPrice,Tab,minPrice,sort from  SaleProducts s with(Nolock)   where WeiXinID=@weiXinID and  EndTime>GETDATE()  and  status=0  and minPrice >0  ");

            if (string.IsNullOrEmpty(select))
            {
                sql.Append("  )t )tt ) a where a.num between @startID and @endID");
            }
            if (!string.IsNullOrEmpty(select))
            {
                tsql.Append(" and " + select + " like '%'+@query+'%'");
                sql.Append(" and " + select + " like '%'+@query+'%'  )t )tt) a where a.num between @startID and @endID");
            }

            string value = HotelCloud.SqlServer.SQLHelper.Get_Value(tsql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinID}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            count = Convert.ToInt32(value);
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=weiXinID}},
            {"startID",new HotelCloud.SqlServer.DBParam{ParamValue=((page-1)*pagesize+1).ToString()}},
            {"endID",new HotelCloud.SqlServer.DBParam{ParamValue=(page*pagesize).ToString()}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            return dt;

        }


        public static DataTable GetSaleProduct(string weixinId, int productSaleId)
        {
            string sql = @"select [Id] ,[WeiXinId] ,[UserId] ,[HotelId],[ProductType],[ProductName],[ProductNum],[BeginTime],[EndTime],[EffectiveBeginTime]
,[EffectiveEndTime],[ProductPrice],[FeeInclude],[FeeExclude],[OrderInfo],[RefundInfo],[DetailDes],[SaleChannel],[ImageList],[Status],[IsOnlineTaobao],[IsOnlineQunar]
,[LastUpdateTime],[SysStatus],[AddDateTime],[SmallImageList],[BigImageList],[minPrice],mainPic,BigMainPic,smallMainPic,tab,MenPrice,Isusehongbao   from SaleProducts  with(nolock)  where  weixinId=@weixinId  and  Id=@Id  ";
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=productSaleId.ToString()}},
             {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weixinId}},
            });
            return dt;
        }



        public static int GetSaleProductMinPrice(int productSaleId, int productType)
        {
            string sql = "";
            if (productType == 0)
            {
                sql = @"select  ISNULL( MIN(ProductPrice),0) from   SaleProducts_TC t    with(nolock)   where  ProductNum  >0 and  ProductPrice >0  and RequestId=@productSaleId";
            }


            else
            {
                sql = @"select   ISNULL( MIN(Price),0)  from   SaleProducts_TC_Price p  with(nolock)   where  SaleTime >=CONVERT(varchar(12) , getdate(), 111 ) and  Stock  >0 and  Price >0  and RequestId  in(select  id from  SaleProducts_TC   t  with(nolock) where  t.RequestId=@productSaleId  ) ";

            }

            string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"productSaleId",new HotelCloud.SqlServer.DBParam{ParamValue=productSaleId.ToString()}},
         
            });

            return Convert.ToInt32(Convert.ToDouble(obj));

        }


        public static DataTable GetSaleProduct(int productSaleId)
        {
            string sql = @"select * from SaleProducts  with(nolock)  where  Id=@Id   ";
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=productSaleId.ToString()}},
         
            });
            return dt;
        }






        public static int AddSaleProductSale(Models.Home.SaleProduct model)
        {

            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into SaleProducts(");
            strSql.Append("EffectiveEndTime,ProductPrice,DetailDes,SaleChannel,Status,WeiXinId,HotelId,ProductType,ProductName,ProductNum,BeginTime,EndTime,EffectiveBeginTime,UserId,FeeInclude,FeeExclude,OrderInfo,RefundInfo,ImageList");
            strSql.Append(") values (");
            strSql.Append("@EffectiveEndTime,@ProductPrice,@DetailDes,@SaleChannel,@Status,@WeiXinId,@HotelId,@ProductType,@ProductName,@ProductNum,@BeginTime,@EndTime,@EffectiveBeginTime,@UserId,@FeeInclude,@FeeExclude,@OrderInfo,@RefundInfo,@ImageList");
            strSql.Append(") ");
            strSql.Append(";select @@IDENTITY");
            string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"EffectiveEndTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.EffectiveEndTime.ToString()}},
             {"ProductPrice",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductPrice.ToString()}},
              {"DetailDes",new HotelCloud.SqlServer.DBParam{ParamValue=model.DetailDes}},
             {"SaleChannel",new HotelCloud.SqlServer.DBParam{ParamValue=model.SaleChannel.ToString()}},
             
              {"Status",new HotelCloud.SqlServer.DBParam{ParamValue=model.Status.ToString()}},
             {"WeiXinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.WeiXinId.ToString()}},
              {"HotelId",new HotelCloud.SqlServer.DBParam{ParamValue=model.HotelId.ToString()}},
             {"ProductType",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductType.ToString()}},
                {"ProductNum",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductNum.ToString()}},
             
             {"ProductName",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductName.ToString()}},
             {"BeginTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.BeginTime.ToString()}},
              {"EndTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.EndTime.ToString()}},
             {"EffectiveBeginTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.EffectiveBeginTime.ToString()}},
             {"UserId",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserId.ToString()}},

                {"FeeInclude",new HotelCloud.SqlServer.DBParam{ParamValue=model.FeeInclude.ToString()}},
              {"FeeExclude",new HotelCloud.SqlServer.DBParam{ParamValue=model.FeeExclude.ToString()}},
             {"OrderInfo",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderInfo.ToString()}},
             {"RefundInfo",new HotelCloud.SqlServer.DBParam{ParamValue=model.RefundInfo.ToString()}},
               {"ImageList",new HotelCloud.SqlServer.DBParam{ParamValue=model.ImageList.ToString()}},

            });


            if (!string.IsNullOrEmpty(obj))
            {
                return Convert.ToInt32(obj);
            }

            return 0;
        }



        public static int UpdateSaleProductSale(Models.Home.SaleProduct model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("update SaleProducts set ");

            strSql.Append(" EffectiveEndTime = @EffectiveEndTime , ");
            strSql.Append(" ProductPrice = @ProductPrice , ");
            strSql.Append(" DetailDes = @DetailDes , ");
            strSql.Append(" SaleChannel = @SaleChannel , ");
            strSql.Append(" Status = @Status , ");
            strSql.Append(" ProductType = @ProductType , ");
            strSql.Append(" ProductName = @ProductName , ");
            strSql.Append(" ProductNum = @ProductNum , ");
            strSql.Append(" BeginTime = @BeginTime , ");
            strSql.Append(" EndTime = @EndTime , ");
            strSql.Append(" EffectiveBeginTime = @EffectiveBeginTime , ");
            strSql.Append(" LastUpdateTime = getdate() , ");
            strSql.Append(" FeeInclude = @FeeInclude ,  ");
            strSql.Append(" FeeExclude = @FeeExclude ,  ");
            strSql.Append(" OrderInfo = @OrderInfo ,  ");
            strSql.Append(" ImageList = @ImageList ,  ");
            strSql.Append(" RefundInfo = @RefundInfo   ");
            strSql.Append(" where Id=@Id  and WeiXinId=@WeiXinId");


            int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"EffectiveEndTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.EffectiveEndTime.ToString()}},
             {"ProductPrice",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductPrice.ToString()}},
              {"DetailDes",new HotelCloud.SqlServer.DBParam{ParamValue=model.DetailDes}},
             {"SaleChannel",new HotelCloud.SqlServer.DBParam{ParamValue=model.SaleChannel.ToString()}},
             
              {"Status",new HotelCloud.SqlServer.DBParam{ParamValue=model.Status.ToString()}},            
          
             {"ProductType",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductType.ToString()}},
             
             {"ProductName",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductName.ToString()}},

              {"ProductNum",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductNum.ToString()}},
             {"BeginTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.BeginTime.ToString()}},
              {"EndTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.EndTime.ToString()}},
             {"EffectiveBeginTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.EffectiveBeginTime.ToString()}},
                {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=model.Id.ToString()}},
                  {"WeiXinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.WeiXinId.ToString()}},
                  
                {"FeeInclude",new HotelCloud.SqlServer.DBParam{ParamValue=model.FeeInclude.ToString()}},
              {"FeeExclude",new HotelCloud.SqlServer.DBParam{ParamValue=model.FeeExclude.ToString()}},
             {"OrderInfo",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderInfo.ToString()}},
             {"RefundInfo",new HotelCloud.SqlServer.DBParam{ParamValue=model.RefundInfo.ToString()}},
                {"ImageList",new HotelCloud.SqlServer.DBParam{ParamValue=model.ImageList.ToString()}},
                
            });

            return row;
        }








    }



    public class SaleProducts_TC
    {
        public static int AddSaleProducts_TC(Models.Home.SaleProducts_TC model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into SaleProducts_TC(");
            strSql.Append("TcName,RequestId,ProductNum,ProductPrice");
            strSql.Append(") values (");
            strSql.Append("@TcName,@RequestId,@ProductNum,@ProductPrice");
            strSql.Append(") ");
            strSql.Append(";select @@IDENTITY");

            string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"TcName",new HotelCloud.SqlServer.DBParam{ParamValue=model.TcName.ToString()}},
             {"RequestId",new HotelCloud.SqlServer.DBParam{ParamValue=model.RequestId.ToString()}},
               {"ProductNum",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductNum.ToString()}},
               {"ProductPrice",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductPrice.ToString()}}


              });


            if (!string.IsNullOrEmpty(obj))
            {
                return Convert.ToInt32(obj);
            }

            return 0;

        }

        public static int UpdateSaleProducts_TC(Models.Home.SaleProducts_TC model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("update SaleProducts_TC set ");

            strSql.Append(" TcName = @TcName  ,");
            strSql.Append(" ProductNum = @ProductNum,  ");
            strSql.Append(" ProductPrice = @ProductPrice  ");
            strSql.Append(" where Id=@Id ");

            int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"TcName",new HotelCloud.SqlServer.DBParam{ParamValue=model.TcName.ToString()}},      
                {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=model.Id.ToString()}},
                   {"ProductNum",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductNum.ToString()}},
               {"ProductPrice",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductPrice.ToString()}}

              });

            return row;

        }


        public static int DelSaleProducts_TC(int RequestId, List<int> Ids)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("delete from  SaleProducts_TC  where  RequestId=@RequestId   and  Id  in( @Id )  ");

            int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"RequestId",new HotelCloud.SqlServer.DBParam{ParamValue=RequestId .ToString()}},      
                {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=string.Join(",",Ids)}},
           

              });

            return row;

        }



        public static List<Models.Home.SaleProducts_TC> GetSaleProducts_TC(int requesetId)
        {
            List<Models.Home.SaleProducts_TC> list = new List<Models.Home.SaleProducts_TC>();
            StringBuilder strSql = new StringBuilder();
            strSql.Append("select  *  from  SaleProducts_TC  with(Nolock) where RequestId=@RequestId");

            DataTable db = HotelCloud.SqlServer.SQLHelper.Get_DataTable(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {            
             {"RequestId",new HotelCloud.SqlServer.DBParam{ParamValue=requesetId.ToString()}}

              });


            for (int i = 0; i < db.Rows.Count; i++)
            {
                Models.Home.SaleProducts_TC model = new Models.Home.SaleProducts_TC();
                model.Id = Convert.ToInt32(db.Rows[i]["Id"]);
                model.TcName = db.Rows[i]["TcName"].ToString();
                model.ProductPrice = Convert.ToDecimal(db.Rows[i]["ProductPrice"]);
                model.ProductNum = Convert.ToInt32(db.Rows[i]["ProductNum"]);
                model.RequestId = Convert.ToInt32(db.Rows[i]["RequestId"]);
                list.Add(model);
            }

            return list;

        }




    }


    public class SaleProducts_TC_Price
    {


        public static List<Models.Home.SaleProducts_TC_Price> GetSaleProducts_TC_Price(int requesetId)
        {

            List<Models.Home.SaleProducts_TC_Price> list = new List<Models.Home.SaleProducts_TC_Price>();
            StringBuilder strSql = new StringBuilder();
            strSql.Append("select  *  from  SaleProducts_TC_Price with(Nolock) where RequestId=@RequestId  and  SaleTime >=CONVERT(varchar(12) , getdate(), 111 ) and  stock >0  and price >0   ");

            DataTable db = HotelCloud.SqlServer.SQLHelper.Get_DataTable(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {            
             {"RequestId",new HotelCloud.SqlServer.DBParam{ParamValue=requesetId.ToString()}}

              });

            for (int i = 0; i < db.Rows.Count; i++)
            {
                Models.Home.SaleProducts_TC_Price model = new Models.Home.SaleProducts_TC_Price();
                model.Price = Convert.ToDecimal(db.Rows[i]["Price"]);
                model.SaleTime = Convert.ToDateTime(db.Rows[i]["SaleTime"].ToString());
                model.Stock = Convert.ToInt32(db.Rows[i]["Stock"]);

                model.RequestId = Convert.ToInt32(db.Rows[i]["RequestId"]);
                list.Add(model);
            }

            return list;

        }



        public static List<Models.Home.SaleProducts_TC_Price> GetSaleProducts_TC_Price(List<int> requestIds)
        {

            List<Models.Home.SaleProducts_TC_Price> list = new List<Models.Home.SaleProducts_TC_Price>();
            StringBuilder strSql = new StringBuilder();
            strSql.Append(string.Format("select  *  from  SaleProducts_TC_Price with(Nolock) where RequestId  in ({0})  and  SaleTime >=CONVERT(varchar(12) , getdate(), 111 ) and  stock >0  and price >0   ", string.Join(",", requestIds)));

            DataTable db = HotelCloud.SqlServer.SQLHelper.Get_DataTable(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), null);

            for (int i = 0; i < db.Rows.Count; i++)
            {
                Models.Home.SaleProducts_TC_Price model = new Models.Home.SaleProducts_TC_Price();
                model.Price = Convert.ToDecimal(db.Rows[i]["Price"]);
                model.SaleTime = Convert.ToDateTime(db.Rows[i]["SaleTime"].ToString());
                model.Stock = Convert.ToInt32(db.Rows[i]["Stock"]);

                model.RequestId = Convert.ToInt32(db.Rows[i]["RequestId"]);
                list.Add(model);
            }

            return list;

        }
    }

    public class SaleProducts_Orders
    {

        public static int AddSaleSaleProducts_Orders(Models.Home.SaleProducts_Orders model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into SaleProducts_Orders(");
            strSql.Append("UserId,UserWeiXinId,UserName,UserMobile,CheckInTime,CheckOutTime,OrderMoney,ProductType,Remark,OperatorLog,HotelId,OrderStatus,TaoBaoStatus,OrderAddTime,HotelWeiXinId,OrderNo,BookingCount,ProductId,TcId,ProductName,TcName,Token,LinkName");
            strSql.Append(") values (");
            strSql.Append("@UserId,@UserWeiXinId,@UserName,@UserMobile,@CheckInTime,@CheckOutTime,@OrderMoney,@ProductType,@Remark,@OperatorLog,@HotelId,@OrderStatus,@TaoBaoStatus,@OrderAddTime,@HotelWeiXinId,@OrderNo,@BookingCount,@ProductId,@TcId,@ProductName,@TcName,@Token,@LinkName");
            strSql.Append(") ");
            strSql.Append(";select @@IDENTITY");

            string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"UserId",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserId.ToString()}},
        {"UserWeiXinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserWeiXinId }},
        {"UserName",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserName}},
        {"UserMobile",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserMobile }},
         {"CheckInTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.CheckInTime.ToString()}},
         {"CheckOutTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.CheckOutTime.ToString()}},
         {"OrderMoney",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderMoney.ToString()}},
        {"ProductType",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductType.ToString()}},
        {"Remark",new HotelCloud.SqlServer.DBParam{ParamValue=model.Remark}},
         {"OperatorLog",new HotelCloud.SqlServer.DBParam{ParamValue=model.OperatorLog}},
          {"HotelId",new HotelCloud.SqlServer.DBParam{ParamValue=model.HotelId.ToString()}},
            {"OrderStatus",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderStatus.ToString()}},
            {"TaoBaoStatus",new HotelCloud.SqlServer.DBParam{ParamValue=model.TaoBaoStatus}},
              {"OrderAddTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderAddTime.ToString()}},
              {"HotelWeiXinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.HotelWeiXinId}},
              {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderNo.ToString()}},
               {"BookingCount",new HotelCloud.SqlServer.DBParam{ParamValue=model.BookingCount.ToString()}},
                {"ProductId",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductId.ToString()}},
                {"TcId",new HotelCloud.SqlServer.DBParam{ParamValue=model.TcId.ToString()}},
                {"ProductName",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductName}},
               {"TcName",new HotelCloud.SqlServer.DBParam{ParamValue=model.TcName}},
                {"Token",new HotelCloud.SqlServer.DBParam{ParamValue=model.Token}},
             {"LinkName",new HotelCloud.SqlServer.DBParam{ParamValue=model.LinkName}},
                });


            if (!string.IsNullOrEmpty(obj))
            {
                return Convert.ToInt32(obj);
            }

            return 0;

        }

        public static int AddSaleSaleProducts_Orders2(Models.Home.SaleProducts_Orders model)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("insert into SaleProducts_Orders(");
            strSql.Append("UserId,UserWeiXinId,UserName,UserMobile,CheckInTime,CheckOutTime,OrderMoney,ProductType,Remark,OperatorLog,HotelId,OrderStatus,TaoBaoStatus,OrderAddTime,HotelWeiXinId,OrderNo,BookingCount,ProductId,TcId,ProductName,TcName,Token,LinkName,OriginalSaleprice,CouponInfo,Jifen,PayType,Promoterid,FxCommission,fxmoneyprofit");
            strSql.Append(") values (");
            strSql.Append("@UserId,@UserWeiXinId,@UserName,@UserMobile,@CheckInTime,@CheckOutTime,@OrderMoney,@ProductType,@Remark,@OperatorLog,@HotelId,@OrderStatus,@TaoBaoStatus,@OrderAddTime,@HotelWeiXinId,@OrderNo,@BookingCount,@ProductId,@TcId,@ProductName,@TcName,@Token,@LinkName,@OriginalSaleprice,@CouponInfo,@Jifen,@PayType,@Promoterid,@FxCommission,@fxmoneyprofit");
            strSql.Append(") ");
            strSql.Append(";select @@IDENTITY");

            string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {  
            {"UserId",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserId.ToString()}},
        {"UserWeiXinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserWeiXinId }},
        {"UserName",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserName}},
        {"UserMobile",new HotelCloud.SqlServer.DBParam{ParamValue=model.UserMobile }},
         {"CheckInTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.CheckInTime.ToString()}},
         {"CheckOutTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.CheckOutTime.ToString()}},
         {"OrderMoney",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderMoney.ToString()}},
        {"ProductType",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductType.ToString()}},
        {"Remark",new HotelCloud.SqlServer.DBParam{ParamValue=model.Remark}},
         {"OperatorLog",new HotelCloud.SqlServer.DBParam{ParamValue=model.OperatorLog}},
          {"HotelId",new HotelCloud.SqlServer.DBParam{ParamValue=model.HotelId.ToString()}},
            {"OrderStatus",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderStatus.ToString()}},
            {"TaoBaoStatus",new HotelCloud.SqlServer.DBParam{ParamValue=model.TaoBaoStatus}},
              {"OrderAddTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderAddTime.ToString()}},
              {"HotelWeiXinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.HotelWeiXinId}},
              {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderNo.ToString()}},
               {"BookingCount",new HotelCloud.SqlServer.DBParam{ParamValue=model.BookingCount.ToString()}},
                {"ProductId",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductId.ToString()}},
                {"TcId",new HotelCloud.SqlServer.DBParam{ParamValue=model.TcId.ToString()}},
                {"ProductName",new HotelCloud.SqlServer.DBParam{ParamValue=model.ProductName}},
               {"TcName",new HotelCloud.SqlServer.DBParam{ParamValue=model.TcName}},
                {"Token",new HotelCloud.SqlServer.DBParam{ParamValue=model.Token}},
                {"LinkName",new HotelCloud.SqlServer.DBParam{ParamValue=model.LinkName}},

                {"OriginalSaleprice",new HotelCloud.SqlServer.DBParam{ParamValue=model.OriginalSaleprice.ToString()}},
                {"CouponInfo",new HotelCloud.SqlServer.DBParam{ParamValue=model.CouponInfo}},
                {"Jifen",new HotelCloud.SqlServer.DBParam{ParamValue=model.Jifen.ToString()}},

                  {"PayType",new HotelCloud.SqlServer.DBParam{ParamValue=model.PayType.ToString()}},
                  
                  {"Promoterid",new HotelCloud.SqlServer.DBParam{ParamValue=model.Promoterid.ToString()}},                  
                  {"FxCommission",new HotelCloud.SqlServer.DBParam{ParamValue=model.FxCommission.ToString()}},
                  {"fxmoneyprofit",new HotelCloud.SqlServer.DBParam{ParamValue=model.Fxmoneyprofit.ToString()}},
                });
            

            if (!string.IsNullOrEmpty(obj))
            {
                return Convert.ToInt32(obj);
            }

            return 0;

        }

        public static DataTable GetSaleProducts_Orders(int orderId, string hotelWeiXinId)
        {
            string sql = @"select * from SaleProducts_Orders  where  Id=@Id  and HotelWeiXinId=@HotelWeiXinId ";
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=orderId.ToString()}},
             {"HotelWeiXinId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelWeiXinId}},
            });

            return dt;

        }

        public static int HeXiaoTuanProductOrder(int orderId, string hotelWeiXinId, string operlog)
        {
            string sql = @"update SaleProducts_Orders  set  OperatorLog=ISnull(OperatorLog,'') +@OperatorLog,hexiaoStatus=1   where  Id=@Id  and HotelWeiXinId=@HotelWeiXinId ";
            int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=orderId.ToString()}},
             {"HotelWeiXinId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelWeiXinId}},
               {"OperatorLog",new HotelCloud.SqlServer.DBParam{ParamValue=operlog}},
            });

            return row;

        }

        public static int SaveProductOrder(Models.Home.SaleProducts_Orders model)
        {

            string sql = @"update SaleProducts_Orders  set Remark=ISnull(Remark,'') +@Remark,  OperatorLog=ISnull(OperatorLog,'') +@OperatorLog,OrderStatus=@OrderStatus,checkinTime=@checkinTime      where  Id=@Id  and HotelWeiXinId=@HotelWeiXinId ";
            int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=model.Id.ToString()   }},
             {"HotelWeiXinId",new HotelCloud.SqlServer.DBParam{ParamValue=model.HotelWeiXinId   }},
               {"OperatorLog",new HotelCloud.SqlServer.DBParam{ParamValue=model.OperatorLog  }},
                 {"Remark",new HotelCloud.SqlServer.DBParam{ParamValue=model.Remark  }},
                  {"checkinTime",new HotelCloud.SqlServer.DBParam{ParamValue=model.CheckInTime.ToString()  }},
                    {"OrderStatus",new HotelCloud.SqlServer.DBParam{ParamValue=model.OrderStatus.ToString()  }},
            });

            return row;

        }


        public static DataTable GetSaleProducts_Orders(string orderNO, string userWeixinId)
        {
            string sql = @"select * from SaleProducts_Orders  with(nolock)  where  orderNO=@orderNO  and userWeixinId=@userWeixinId ";
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"orderNO",new HotelCloud.SqlServer.DBParam{ParamValue=orderNO.ToString()}},
             {"userWeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=userWeixinId}},
            });

            return dt;
        }


        public static DataTable GetSaleProducts_OrdersA(string orderNO, string userWeixinId)
        {
            string sql = @"select *,(SELECT SmallImageList from  SaleProducts s with(Nolock) where  s.Id= o.ProductId)Pic  from SaleProducts_Orders o  with(nolock)  where  orderNO=@orderNO  and userWeixinId=@userWeixinId ";
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"orderNO",new HotelCloud.SqlServer.DBParam{ParamValue=orderNO.ToString()}},
             {"userWeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=userWeixinId}},
            });

            return dt;
        }


        public static DataTable GetSaleProducts_OrdersByHexiaoma(string hexiaoma)
        {
            string sql = @"select * from SaleProducts_Orders  where   productType=0  and HexiaoStatus=0  and HexiaoMa=@HexiaoMa  ";
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"HexiaoMa",new HotelCloud.SqlServer.DBParam{ParamValue=hexiaoma}},
          
            });

            return dt;
        }


        public static string GetSaleProducts_OrdersByToken(string token)
        {
            string sql = @"select * from SaleProducts_Orders  where  Token=@Token ";
            string tokne_value = HotelCloud.SqlServer.SQLHelper.Get_Value(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"Token",new HotelCloud.SqlServer.DBParam{ParamValue=token.ToString()}}    
            });

            return tokne_value;
        }


        public static DataTable GetSaleProducts_Orders(string userweiXinID, out int count, int page, int pagesize, string select, string query)
        {

            StringBuilder tsql = new StringBuilder();
            tsql.Append(@"select count(*) from SaleProducts_Orders  with(nolock) where UserWeiXinID=@UserWeiXinID ");
            StringBuilder sql = new StringBuilder();
            sql.Append(@"select * from (
                     select  ROW_NUMBER() over(order by Id  desc)num  ,* from SaleProducts_Orders  s
                                where UserWeiXinID=@UserWeiXinID ");
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
            {"UserWeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=userweiXinID}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            count = Convert.ToInt32(value);
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"UserWeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=userweiXinID}},
            {"startID",new HotelCloud.SqlServer.DBParam{ParamValue=((page-1)*pagesize+1).ToString()}},
            {"endID",new HotelCloud.SqlServer.DBParam{ParamValue=(page*pagesize).ToString()}},
            {"query",new HotelCloud.SqlServer.DBParam{ParamValue=query}}
            });
            return dt;

        }


        public static void DoneOrderSuccess(string orderNo)
        {


            try
            {

                string sql = @"select  Id, orderNo,ProductType,TcName,TcId,UserMobile,CheckInTime,userWeixinId,bookingCount from SaleProducts_Orders with(nolock) where  OrderNo=@OrderNo   ";
                System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"OrderNo",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}},
         
            });

                //减少库存
                if (dt.Rows[0]["ProductType"].ToString() == "0")
                {
                    StringBuilder sbtuanSql = new StringBuilder();
                    int bookingCount = Convert.ToInt32(dt.Rows[0]["bookingCount"].ToString());
                    List<int> tuanCodeList = new List<int>();

                    //预定多份生成多份团购
                    for (int i = 0; i < bookingCount; i++)
                    {
                        int tuanCode = new Random().Next(100000000, 999990000);
                        tuanCode = tuanCode + bookingCount + i * 100;

                        tuanCode = new Random(tuanCode).Next(100000000, 999990000);


                        tuanCodeList.Add(tuanCode);
                        sbtuanSql.AppendLine(string.Format("insert  SaleProducts_OrdersTuan (tuancode,orderId,status,patchNo) values({0},{1},{2},{3}) ", tuanCode, dt.Rows[0]["Id"].ToString(), 0, tuanCode));
                    }

                    int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(sbtuanSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), null);


                    //int hexiaoMa = new Random().Next(100000000, 999990000);
                    //    int row = HotelCloud.SqlServer.SQLHelper.Run_SQL("update  SaleProducts_Orders  set  hexiaoma=@hexiaoma where orderNo=@orderNo", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                    //{"orderNo",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo }},
                    //  {"hexiaoma",new HotelCloud.SqlServer.DBParam{ParamValue=hexiaoMa.ToString() }},
                    //});


                    if (row > 0)
                    {
                        row = HotelCloud.SqlServer.SQLHelper.Run_SQL("update  SaleProducts_TC  set  ProductNum=ProductNum-@bookingCount where Id=@Id", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["TcId"].ToString() }},
            {"bookingCount",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["bookingCount"].ToString() }},
            });
                        string content = string.Format(@"您预定的团购套餐{0},预约码:{1}，需提前预约，请妥善保存。[微可牛]", dt.Rows[0]["TcName"].ToString(), string.Join(",", tuanCodeList));
                        string mobile = dt.Rows[0]["UserMobile"].ToString();

                        HotelCloud.SMS.SmsMD20140117 sms = new HotelCloud.SMS.SmsMD20140117();
                        sms.ReceiveMobileNo = mobile;
                        sms.Content = content;
                        string res = sms.Send();
                        if (res == "0")
                        {
                            int rows = HotelCloud.SqlServer.SQLHelper.Run_SQL(@"insert into wkn_smssend(Mobile,SMSContent,SMSCode,Channel,Ip,WeiXinID) values(@Mobile,@SMSContent,@SMSCode,@Channel,@Ip,@WeiXinID);", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {
                                                {"Mobile",new HotelCloud.SqlServer.DBParam{ParamValue=mobile}},
                                                {"SMSContent",new HotelCloud.SqlServer.DBParam{ParamValue=content}},
                                                {"SMSCode",new HotelCloud.SqlServer.DBParam{ParamValue=string.Join(",", tuanCodeList)}},
                                                {"Channel",new HotelCloud.SqlServer.DBParam{ParamValue="抢购预约码"}},
                                                {"Ip",new HotelCloud.SqlServer.DBParam{ParamValue=IpAddressOperation.GetIPAddress()}},
                                                {"WeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["userweixinId"].ToString()  }},
                    });

                        }

                    }

                }


                else
                {

                    int row = HotelCloud.SqlServer.SQLHelper.Run_SQL("update  SaleProducts_TC_Price  set Stock=Stock-@bookingCount where  RequestId=@RequestId and SaleTime=@SaleTime ", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"RequestId",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["TcId"].ToString() }},
            {"SaleTime",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["CheckInTime"].ToString() }},
              {"bookingCount",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["bookingCount"].ToString() }},
         
            });

                }

            }


            catch(Exception ex)
            {
                Logger.Instance.Error(ex.ToString());   
            }
             
        }


        public static int SendPhoneProductOrderMsg(string content, string phone, string OrderNo)
        {

            string tsql = @"insert into Tasks(TaskContent,TaskTime,TaskState,SendState,mobile,TaskType,OrderNo) values(@Content,getdate(),0,0,@mobile,'4',@OrderNo)";

            Dictionary<string, HotelCloud.SqlServer.DBParam> Dic = new Dictionary<string, HotelCloud.SqlServer.DBParam>();
            Dic.Add("Content", new HotelCloud.SqlServer.DBParam { ParamValue = content });
            Dic.Add("mobile", new HotelCloud.SqlServer.DBParam { ParamValue = phone });
            Dic.Add("OrderNo", new HotelCloud.SqlServer.DBParam { ParamValue = OrderNo });

            int Count = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.GetCon(), Dic);
            return Count;
        }
    }

}