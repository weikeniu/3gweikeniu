using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Reflection;
using System.Data;
using HotelCloud.SqlServer;

namespace hotel3g.Models
{
    public class DishOrderClass
    {

    }
    

    /// <summary>
    /// 点餐下单逻辑类
    /// </summary>
    public static class DishOrderLogic
    {
        /// <summary>
        /// 根据酒店id获取酒店自营商家[默认商家]
        /// </summary>
        /// <param name="hotelId"></param>
        /// <returns></returns>
        public static StoresView GetHotelDefaultStore(string hotelId)
        {
            return DishOrderLogic.GetStore(0, hotelId, true);
        }

        /// <summary>
        /// 删除数量小于等于0的订单明细
        /// </summary>
        public static void DelDishNumberIs0Details(string orderCode)
        {
            SQLHelper.Run_SQL("delete T_OrderDetails where isnull(number,0)<1 and orderCode=@orderCode", SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"orderCode",new DBParam(){ParamValue=orderCode}}
                    });
        }

        /// <summary>
        /// 获取商家图片
        /// </summary>
        public static DataTable GetTopStoreImgs(string StoreId, int topNum)
        {
            string sql = "select top " + topNum + " * from T_StoreImgs where storeID=@StoreId";
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"StoreId",new DBParam(){ParamValue=StoreId}}
                    });

        }

        /// <summary>
        /// 获取商家菜品类型
        /// </summary>
        /// <param name="StoreId">商家id</param>
        /// <returns></returns>
        public static DataTable GetDishTypeByStoreId(string StoreId)
        {
            string sqltype = @"select dishesTypeID, dishesTypeName, storeId,(select top 1 ISNULL(bagging,0) from T_Stores where storeId=t.storeId)bagging
            ,(select COUNT(*)n from T_Dishses where dishesTypeID=t.dishesTypeID)dishnum from T_StoresDishesTypes t where t.storeId>0 and t.storeId=@storeId order by sortid desc";
            DataTable dt_dishType = SQLHelper.Get_DataTable(sqltype, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"storeId",new DBParam(){ParamValue=StoreId}}
                    });

            return dt_dishType;
        }

        /// <summary>
        /// 获取周边商家类型
        /// </summary>
        /// <param name="weixinid"></param>
        /// <param name="status">1禁用，0启用</param>
        /// <returns></returns>
        public static DataTable GetStoreType(string weixinid,int status=0) 
        {
            string sql = "select * from T_StoreType where weixinid=@weixinid and status=@status";
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            { "weixinid", new DBParam() { ParamValue = weixinid } },
            { "status", new DBParam() { ParamValue = status.ToString() } }
            });
        }

        /// <summary>
        /// 获取未提交订单编号,库里获取不到则返回一个新创建的编号前4个随机数后3个随机数，中间日期 "Lxxxx日期xx"
        /// </summary>
        public static string GetOrderCode(string hotelId, string storeId, string userWeiXinId, EnumOrderStatus stas)
        {
            string code = SQLHelper.Get_Value("select top 1 orderCode from T_OrderInfo where ISNULL([Status],0)=@stas and storeID=@storeID and hotelid=@hotelid and userweixinid=@userweixinid ", SQLHelper.GetCon(),
                  new Dictionary<string, DBParam>()
                    {
                        {"stas",new DBParam(){ParamValue=Convert.ToInt32(stas).ToString()}},
                        {"storeID",new DBParam(){ParamValue=storeId}},
                        {"userweixinid",new DBParam(){ParamValue=userWeiXinId}},
                        {"hotelid",new DBParam(){ParamValue=hotelId}}
                    });
            if (!string.IsNullOrEmpty(code))
            {
                return code;
            }
            else
            {
                return CreateNewOrderCode();
            }
        }

        /// <summary>
        /// 创建新单号
        /// </summary>
        /// <returns></returns>
        public static string CreateNewOrderCode() 
        {
            string pre = new Random().Next(100, 999).ToString();
            return "L" + pre + DateTime.Now.ToString("yyMMddhhmmssfff");//新订单编号
        }


        /// <summary>
        /// 获取已提交未支付未超时订单编号,提交30分钟内的,精确到秒
        /// </summary>
        public static string GetUnPayOrderCode(string hotelId, string storeId, string userWeiXinId, EnumOrderStatus stas)
        {
            //DATEDIFF(mi,submitTime,GETDATE())<=30  //提交30分钟内
            int LimitedMinutes = System.Configuration.ConfigurationManager.AppSettings["LimitedMinutes"] == "" ? 30 : Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["LimitedMinutes"]);
            int SECOND = LimitedMinutes * 60;
            string sql = @"select top 1 orderCode from T_OrderInfo where DATEDIFF(SECOND,submitTime,GETDATE())<=@SECOND and ISNULL([Status],0)=@stas and storeID=@storeID and hotelid=@hotelid and userweixinid=@userweixinid";
            return SQLHelper.Get_Value(sql, SQLHelper.GetCon(),
                  new Dictionary<string, DBParam>()
                    {
                        {"SECOND",new DBParam(){ParamValue=SECOND.ToString()}},    
                        {"stas",new DBParam(){ParamValue=Convert.ToInt32(stas).ToString()}},
                        {"storeID",new DBParam(){ParamValue=storeId}},
                        {"userweixinid",new DBParam(){ParamValue=userWeiXinId}},
                        {"hotelid",new DBParam(){ParamValue=hotelId}}
                    });
        }

        /// <summary>
        /// 清除2天前的无效单
        /// </summary>
        /// <param name="userweixinId"></param>
        /// <param name="hotelweixinid"></param>
        public static void Clear2daysUnsubmitOrder(string userweixinId, string hotelweixinid)
        {
            try
            {
                    string sql = @"
    delete from T_OrderDetails where orderCode in(select orderCode from T_OrderInfo where Status=0 and DATEDIFF(DAY,oreateTime,GETDATE())>=2 and userweixinid=@userweixinId and hotelWeixinId=@hotelweixinid)
    delete from T_OrderInfo where Status=0 and DATEDIFF(DAY,oreateTime,GETDATE())>=2 and userweixinid=@userweixinId  and hotelWeixinId=@hotelweixinid";
                    SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() {
                   {"userweixinId",new DBParam(){ParamValue=userweixinId}},
                   {"hotelweixinid",new DBParam(){ParamValue=hotelweixinid}}
                });
            }
            catch { }
        }

        /// <summary>
        /// 是否有未提交订单
        /// </summary>
        public static bool IsHasOrderInfo(string orderCode, EnumOrderStatus stas)
        {
            string str = SQLHelper.Get_Value("select top 1 1 from T_OrderInfo where isnull(status,0)=@stas and orderCode=@orderCode", SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
               {"stas",new DBParam(){ParamValue=Convert.ToInt32(stas).ToString()}},
               {"orderCode",new DBParam(){ParamValue=orderCode}}
            });
            if (!string.IsNullOrEmpty(str))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 获取商家菜品
        /// </summary>
        /// <param name="StoreId">商家id</param>
        /// <returns></returns>
        public static DataTable GetStoreDishByIdOrderCode(string StoreId, string OrderCode)
        {
            string sqldish = @"select ISNULL(UseRichText,0)UseRichText,t.DishsesID, DishesTypeID, DishsesName, DishsesDesc, Price, DishesImg, [Status],ISNULL(ShowHot,0)ShowHot,ISNULL(t2.Number,0)Number,t2.orderCode,ISNULL(t2.Hot,0)Hot from T_Dishses t
left join 
(
select Number,o.orderCode,DishsesID,Hot from T_OrderInfo o inner join T_OrderDetails d on o.orderCode=d.orderCode  where o.orderCode=@orderCode
)t2 on t.DishsesID=t2.DishsesID
where ISNULL([status],0)=0 and DishesTypeID in(select dishesTypeID from T_StoresDishesTypes where storeId=@storeId) order by sortindex desc";

            return SQLHelper.Get_DataTable(sqldish, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"storeId",new DBParam(){ParamValue=StoreId}},
                        {"orderCode",new DBParam(){ParamValue=OrderCode}}
                    });
        }

        /// <summary>
        /// 获取商家图片
        /// </summary>
        public static DataTable GetStoreImgById(string StoreId)
        {
            string sqldish = @"select imgID, storeID, imgTitle, imgUrl, createtime from T_StoreImgs where  storeID>0 and storeID=@storeId";

            return SQLHelper.Get_DataTable(sqldish, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"storeId",new DBParam(){ParamValue=StoreId}}
                    });
        }

        /// <summary>
        /// 加载订单明细
        /// </summary>
        /// <param name="ordercode"></param>
        /// <returns></returns>
        public static DataTable LoadOrderDetails(string ordercode)
        {
            string sql = @"select DishsesID,DishesName,ISNULL(discountprice,Price)*Number totalPrice ,Number,orderCode,
(select SUM(Price*Number) from T_OrderDetails where orderCode=t.orderCode)SumPrice,
(select SUM(ISNULL(discountprice,Price)*Number) from T_OrderDetails where orderCode=t.orderCode)disSumPrice,
(select SUM(Number) from T_OrderDetails where orderCode=t.orderCode)SumNum 
from dbo.T_OrderDetails t where t.Number>0 and t.orderCode=@orderCode";
            DataTable dt_detail = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"orderCode",new DBParam(){ParamValue=ordercode}}
                    });

            return dt_detail;
        }

        /// <summary>
        /// 根据酒店id获取餐饮商家,
        /// </summary>
        public static DataTable GetAllDishStores(string hotelId)
        {
            //            string sql = @"select
            // StoreId, StoreName, StoreNickName, StoreAddress, StorePhone, BeginTime, EndTime,bagging, StoreDesc, jingdu, weidu, juli,fenzhong,minprice, Logoimg,t.YouhuiIDs, Isaround, state, hotelid, weixinid
            //,( select remo+''  from T_Youhui where CHARINDEX(','+CONVERT(varchar(10),youhuiid)+',',','+t.YouhuiIDs+',')>0 FOR XML PATH(''))remo
            // from T_Stores t where ISNULL(t.[state],0)<>1 and Isaround<>2 and t.hotelid=" + hotelId;
            string sql = @"select t.* ,( select remo+'  '  from T_Youhui where CHARINDEX(','+CONVERT(varchar(10),youhuiid)+',',','+t.YouhuiIDs+',')>0 order by UsedMoney desc FOR XML PATH(''))remo
 from T_Stores t where isnull(storetype,0)=0 and ISNULL(t.[state],0)<>1 and Isaround<>2 and t.hotelid=" + hotelId;

            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { });

            return dt;
        }

        /// <summary>
        /// 根据微信id获取商家,
        /// </summary>
        public static DataTable GetStoresByWeixinId(string WeixinId,string lng,string lat)
        {
            string sql = @"select t.* ,( select remo+'  '  from T_Youhui where CHARINDEX(','+CONVERT(varchar(10),youhuiid)+',',','+t.YouhuiIDs+',')>0 order by UsedMoney desc FOR XML PATH(''))remo
, case when jingdu<>''  then  dbo.fnGetJuLi(jingdu,weidu,@lng,@lat) else CAST(juli as int) end juli1
 from T_Stores t where ISNULL(t.[state],0)<>1 and Isaround<>2 and t.weixinid=@weixinid";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() {
            {"weixinid",new DBParam(){ParamValue=WeixinId}},
            {"lng",new DBParam(){ParamValue=lng}},
            {"lat",new DBParam(){ParamValue=lat}}
            });

            return dt;
        }

        //根据酒店id 或微信id 获取
        public static DataTable GetStoresByWeixinId(string hotelId,string WeixinId, string lng, string lat,string cityname,string storename)
        {
            string sql = @"select t.* ,( select remo+'  '  from T_Youhui where CHARINDEX(','+CONVERT(varchar(10),youhuiid)+',',','+t.YouhuiIDs+',')>0 order by UsedMoney desc FOR XML PATH(''))remo
, case when jingdu<>''  then  dbo.fnGetJuLi(jingdu,weidu,@lng,@lat) else CAST(juli as int) end juli1
 from T_Stores t
 left join CityInfo c on t.cityid=c.id
where ISNULL(t.[state],0)<>1 and (t.weixinid=@weixinid or t.hotelId=@hotelId)  ";
            if (!string.IsNullOrEmpty(cityname)) 
            {
                sql += " and city=@cityname ";
            }
            if (!string.IsNullOrEmpty(storename)) 
            {
                sql += " and storename like  '%'+@storename+'%'  ";
            }

            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() {
            {"weixinid",new DBParam(){ParamValue=WeixinId}},
            {"lng",new DBParam(){ParamValue=lng}},
            {"lat",new DBParam(){ParamValue=lat}},
            {"cityname",new DBParam(){ParamValue=cityname}},
            {"storename",new DBParam(){ParamValue=storename}},
            {"hotelId",new DBParam(){ParamValue=hotelId}}
            });

            return dt;
        }


        public static OrderDetails GetOrderDetailsModel(string orderCode, string dishId)
        {
            string sql = "select * from T_OrderDetails where orderCode=@orderCode and DishsesID=@dishId";
            List<OrderDetails> list = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
               {"orderCode",new DBParam(){ParamValue=orderCode}},
               {"dishId",new DBParam(){ParamValue=dishId}}
            }).ToList<OrderDetails>();
            if (list.Count > 0)
            {
                return list[0];
            }
            else
            {
                return new OrderDetails();
            }
        }

        #region 加餐

        /// <summary>
        /// 插入订单
        /// </summary>
        public static int InserOrder(string orderCode, string storeId, string hotelId, string userWeiXinID, string hotelWeiXinID)
        {
            string sql = @"INSERT INTO [WeiXin].[dbo].[T_OrderInfo]
                               ([orderCode]
                               ,[oreateTime]
                               ,[Status]
                               ,[storeID]
                               ,[hotelid]
                               ,[userweixinid],hotelWeixinId)
                         VALUES
                               (@orderCode
                               ,@oreateTime
                               ,@Status
                               ,@storeID
                               ,@hotelid
                               ,@userweixinid,@hotelWeixinId)";

            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"orderCode",new DBParam(){ParamValue=orderCode}},
                        {"oreateTime",new DBParam(){ParamValue=DateTime.Now.ToString()}},
                        {"Status",new DBParam(){ParamValue=Convert.ToInt32(EnumOrderStatus.UnSubmit).ToString()}},
                        {"storeID",new DBParam(){ParamValue=storeId}},
                        {"hotelid",new DBParam(){ParamValue=hotelId}},
                        {"userweixinid",new DBParam(){ParamValue=userWeiXinID}},
                        {"hotelWeixinId",new DBParam(){ParamValue=hotelWeiXinID}}
                    });
        }

        //插入订单详细
        public static int InserOrderDetail(string ordercode, Dishses model, string Hot, decimal discount)
        {
            decimal discountprice = model.price;
            if (discount > 0)
            {
                discountprice = model.price * discount / 10;
            }
            string sql = @"insert into T_OrderDetails(orderCode, DishsesID, dishesName, number, price,Hot,canCoupon,discount,discountprice ) values(@orderCode, @DishsesID, @dishesName, @number, @price,@Hot,@canCoupon,@discount,@discountprice ); 
                         update t  set t.amount=(select SUM(Price*number) from dbo.T_OrderDetails where number>0 and orderCode=t.orderCode) from T_OrderInfo t where t.orderCode=@orderCode ;";
            return SQLHelper.Run_SQL(sql,
               SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"orderCode",new DBParam(){ParamValue=ordercode}},
                        {"DishsesID",new DBParam(){ParamValue=model.DishsesID.ToString()}},
                        {"dishesName",new DBParam(){ParamValue=model.DishsesName}},
                        {"number",new DBParam(){ParamValue="1"}},
                        {"price",new DBParam(){ParamValue=model.price.ToString()}},
                        {"Hot",new DBParam(){ParamValue=Hot}},
                        {"canCoupon",new DBParam(){ParamValue=model.CanCouPon.ToString()}},
                        {"discount",new DBParam(){ParamValue=discount.ToString()}},
                        {"discountprice",new DBParam(){ParamValue=discountprice.ToString()}}
                    });
        }
        //修改订单详细
        public static int UpdateOrderDetail(string ordercode, int DishsesID)
        {
            string sql = @"update T_OrderDetails set number=isnull(number,0)+1 where DishsesID=@DishsesID and orderCode=@orderCode ;
                      update t  set t.amount=(select SUM(Price*number) from dbo.T_OrderDetails where number>0 and orderCode=t.orderCode) from T_OrderInfo t where t.orderCode=@orderCode ;";
            return SQLHelper.Run_SQL(sql,
                               SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"orderCode",new DBParam(){ParamValue=ordercode}},
                        {"DishsesID",new DBParam(){ParamValue=DishsesID.ToString()}}
                    });
        }

        //订单详情是否已有菜品
        public static bool HasDish(string dishId, string ordercode)
        {
            string resultStr = SQLHelper.Get_Value("select top 1 1 from T_OrderDetails where ordercode=@ordercode and dishsesid=@dishsesid ", SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"dishsesid",new DBParam(){ParamValue=dishId}},
            {"ordercode",new DBParam(){ParamValue=ordercode}}
            });

            return !string.IsNullOrEmpty(resultStr);
        }

        /// <summary>
        /// 获取菜品实体 //Status=1 表示未售菜品
        /// </summary>
        public static Dishses GetDishsesModel(string dishId)
        {
            //Status=1 表示未售菜品
            //DishsesID, DishesTypeID, DishsesName, DishsesDesc, Price, DishesImg, Status, ShowHot, UseRichText, ITDescribe, Notice, CanDiscount, CanCouPon, ImgList
            string sql = @"select top 1 DishsesID, DishesTypeID, DishsesName, DishsesDesc, Price, DishesImg, Status,ShowHot,UseRichText, ITDescribe, Notice, CanDiscount, CanCouPon, ImgList 
 from dbo.T_Dishses where isnull(Status,0)<>1 and DishsesID=@DishsesID";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(),
                    new Dictionary<string, DBParam>()
                    {
                        {"DishsesID",new DBParam(){ParamValue=dishId}}
                    });
            if (dt != null && dt.Rows.Count > 0)
            {
                return dt.ToList<Dishses>()[0];
            }

            return null;
        }

        //更新订单金额
        public static void UpdateOrderAmount(string ordercode)
        {
            if (!string.IsNullOrEmpty(ordercode))
            {
                SQLHelper.Run_SQL(@"update t  set t.amount=(select SUM(Price*number) from dbo.T_OrderDetails where number>0 and orderCode=t.orderCode) from T_OrderInfo t where t.orderCode=@orderCode ", SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"orderCode",new DBParam(){ParamValue=ordercode}}
                    });
            }
        }

        #endregion

        #region 减菜品,清空

        /// <summary>
        /// 减餐
        /// </summary>
        public static void ReduceDish(string orderCode, string dishId)
        {
            string sql = @"update T_OrderDetails set number=number-1 where number>0 and orderCode=@orderCode and DishsesID=@DishsesID ;
                        delete T_OrderDetails where number=0 and orderCode=@orderCode and DishsesID=@DishsesID ;                           
                        update t  set t.amount=(select SUM(Price*number) from dbo.T_OrderDetails where number>0 and orderCode=t.orderCode) from T_OrderInfo t where t.orderCode=@orderCode";
            SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"orderCode",new DBParam(){ParamValue=orderCode}},
                        {"DishsesID",new DBParam(){ParamValue=dishId}}
                    });
        }

        public static int ClearDish(string orderCode)
        {
            string sql = "delete T_OrderDetails where orderCode=@orderCode; update T_OrderInfo set amount=0,payamount=0,jiesuanjia=0 where orderCode=@orderCode;";
            int rows = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"orderCode",new DBParam(){ParamValue=orderCode}}
                    });
            if (rows > 0)
            {
                UpdateOrderAmount(orderCode);
            }
            return rows;
        }

        #endregion

        #region 单品详情加减餐
        public static int SaveOrderDish(string ordercode, Dishses model, string number, string Hot, decimal discount = 0)
        {
            decimal discountprice = model.price;
            if (discount > 0)
            {
                discountprice = model.price * discount / 10;
            }

            string sql = @"insert into T_OrderDetails(orderCode, DishsesID, dishesName, number, price,Hot,discount,discountprice) values(@orderCode, @DishsesID, @dishesName, @number, @price,@Hot,@discount,@discountprice); 
                         update t  set t.amount=(select SUM(Price*number) from dbo.T_OrderDetails where number>0 and orderCode=t.orderCode) from T_OrderInfo t where t.orderCode=@orderCode ;";
            return SQLHelper.Run_SQL(sql,
               SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"orderCode",new DBParam(){ParamValue=ordercode}},
                        {"DishsesID",new DBParam(){ParamValue=model.DishsesID.ToString()}},
                        {"dishesName",new DBParam(){ParamValue=model.DishsesName}},
                        {"number",new DBParam(){ParamValue=number}},
                        {"price",new DBParam(){ParamValue=model.price.ToString()}},
                        {"Hot",new DBParam(){ParamValue=Hot}},
                        {"discount",new DBParam(){ParamValue=discount.ToString()}},
                        {"discountprice",new DBParam(){ParamValue=discountprice.ToString()}}
                    });
        }

        public static int UpdateOrderDish(string ordercode, int DishsesID, string number)
        {
            string sql = @"update T_OrderDetails set number=@number where DishsesID=@DishsesID and orderCode=@orderCode ;
                      update t  set t.amount=(select SUM(Price*number) from dbo.T_OrderDetails where number>0 and orderCode=t.orderCode) from T_OrderInfo t where t.orderCode=@orderCode ;";
            return SQLHelper.Run_SQL(sql,
                               SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"orderCode",new DBParam(){ParamValue=ordercode}},
                        {"number",new DBParam(){ParamValue=number}},
                        {"DishsesID",new DBParam(){ParamValue=DishsesID.ToString()}}
                    });
        }

        #endregion

        #region 订单支付

        public static DataTable GetDishTableForPay(string orderCode)
        {
            string sql = @"select ISNULL(t.youhuiamount,0)youhuiamount,ISNULL(t.bagging,0)bagging,t.amount,ISNULL(t.payamount,0)payamount,ISNULL(CouponMoney,0)CouponMoney,t.remo,t.userNumber,t.orderAddress,t.orderRoomNo,t.orderLinkMan,t.orderPhone,t.songcanyuan,t.songcanphone,t.songcantime,t.usetime,isnull(t.jifen,0)jifen,t.storeID,
  i.orderCode, i.DishsesID, i.dishesName, i.number, i.price,ISNULL(i.Hot,0)Hot,t.submitTime,t.[Status],t.willArriveTime,t.orderPayType,t.payTime,t.sureTime,t.finishTime 
   ,ISNULL(i.canCouPon,0)canCouPon,ISNULL(i.discount,0)discount,ISNULL(i.discountprice,i.price)discountprice
   ,(select dishesName from T_Dishses where DishsesID=i.DishsesID and ISNULL(Status,0)=1)unsale,isnull(t.manjianmoney,0)manjianmoney,manjianremo,xuhao,tablenumber,isnull(tablenumberid,0)tablenumberid 
  from T_OrderDetails i inner join T_OrderInfo t on t.orderCode=i.orderCode 
  where i.number>0 and i.orderCode=@orderCode";
            Dictionary<string, DBParam> dic = new Dictionary<string, DBParam>();
            dic.Add("orderCode", new DBParam() { ParamValue = orderCode });
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), dic);

            return dt;
        }

        /// <summary>
        /// 获取有明细的订单信息， 找不到订单返回 new OrderInfo();
        /// </summary>
        /// <param name="orderCode"></param>
        /// <returns></returns>
        public static OrderInfo GetOrderInfo(string orderCode)
        {
            string sql = @"  SELECT top 1 t.orderId, t.orderCode, t.amount,isnull(t.youhuiamount,0)youhuiamount,isnull(t.bagging,0)bagging, 
 t.orderAddress,t.orderRoomNo,t.orderLinkMan, t.orderPhone, t.orderPayType, t.orderPayState, t.oreateTime, t.Status, t.storeID, t.userNumber, t.remo,
t.tablenumber,isnull(tablenumberid,0)tablenumberid, 
 t.AddressID, t.hotelid,t.hotelWeixinId, t.userweixinid,t.submitTime,t.payTime,t.willArriveTime,isnull(t.CouponMoney,0)CouponMoney,t.CouponId,t.usetime,isnull(t.jifen,0)jifen,
t.manjianmoney,t.manjianremo,isnull(t.payamount,(t.amount+isnull(t.bagging,0)-isnull(t.youhuiamount,0)-isnull(t.CouponMoney,0)-isnull(t.manjianmoney,0)))payamount
 FROM T_OrderInfo t inner join T_OrderDetails d on t.orderCode=d.orderCode WHERE d.number>0 and t.orderCode=@orderCode";

            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() {
            {"orderCode",new DBParam(){ParamValue=orderCode}}
            });
            if (dt.Rows.Count > 0)
            {
                return dt.Rows[0].ToModel<OrderInfo>();
            }
            else
            {
                return new OrderInfo();
            }
        }
        /// <summary>
        /// 获取有明细的订单信息， 找不到订单返回 new OrderInfo();
        /// </summary>
        public static OrderInfo GetOrderInfo(string orderCode, EnumOrderStatus stas)
        {
            //string sql = "SELECT top 1 orderId, orderCode, amount,isnull(youhuiamount,0)youhuiamount,isnull(bagging,0)bagging,isnull(payamount,0)payamount, orderAddress, orderPhone,orderLinkMan,orderRoomNo, orderPayType, orderPayState, oreateTime, Status, storeID, userNumber, remo, AddressID, hotelid, userweixinid,submitTime,payTime,willArriveTime FROM T_OrderInfo WHERE orderCode=@orderCode and isnull(Status,0)=@stas";
            string sql = @" SELECT top 1 t.orderId, t.orderCode, t.amount,isnull(t.youhuiamount,0)youhuiamount,isnull(t.bagging,0)bagging, 
 t.orderAddress,t.orderRoomNo,t.orderLinkMan, t.orderPhone, t.orderPayType, t.orderPayState, t.oreateTime, t.Status, t.storeID, t.userNumber, t.remo,t.tablenumber,isnull(tablenumberid,0)tablenumberid,  
 t.AddressID, t.hotelid,t.hotelWeixinId, t.userweixinid,t.submitTime,t.payTime,t.willArriveTime,isnull(t.CouponMoney,0)CouponMoney,t.CouponId,t.usetime,isnull(t.jifen,0)jifen,
t.manjianmoney,t.manjianremo,isnull(t.payamount,(t.amount+isnull(t.bagging,0)-isnull(t.youhuiamount,0)-isnull(t.CouponMoney,0)-isnull(t.manjianmoney,0)))payamount
 FROM T_OrderInfo t inner join T_OrderDetails d on t.orderCode=d.orderCode WHERE d.number>0 and  t.orderCode=@orderCode and  isnull(t.Status,0)=@stas";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() {
            {"orderCode",new DBParam(){ParamValue=orderCode}},
            {"stas",new DBParam(){ParamValue=Convert.ToInt32(stas).ToString()}}
            });
            if (dt.Rows.Count > 0)
            {
                return dt.Rows[0].ToModel<OrderInfo>();
            }
            else
            {
                return new OrderInfo();
            }
        }



        /// <summary>
        /// 获取一个默认的验证通过的联系人
        /// </summary>
        /// <param name="userweixinid"></param>
        public static OrderAddress GetAddress(string userweixinid)
        {
            OrderAddress address = new OrderAddress();
            if (userweixinid.Contains(DAL.PromoterDAL.WX_ShareLinkUserWeiXinId)) //朋友分享的
            {
                return address;
            }
            if (!string.IsNullOrEmpty(userweixinid))
            {
                DataTable dt = SQLHelper.Get_DataTable("select top 1 AddressID, LinkMan, LinkPhone, case when isnull(addressType,1)=2 then kuaidiAddress else Address end  Address, RoomNo, isSelected,isValidate, userweixinid,isnull(addressType,1)addressType,kuaidiAddress From T_address where isSelected=1 and userweixinid=@userweixinid ",
                        SQLHelper.GetCon(), new Dictionary<string, DBParam>(){
                {"userweixinid",new DBParam(){ParamValue=userweixinid}}
                });

                if (dt.Rows.Count > 0)
                {
                    address = dt.Rows[0].ToModel<OrderAddress>();
                }
            }
            return address;
        }

        /// <summary>
        /// 获取所有验证通过的联系人
        /// </summary>
        /// <param name="userweixinid"></param>
        public static List<OrderAddress> GetAddressList(string userweixinid)
        {
            List<OrderAddress> list = new List<OrderAddress>();
            if (userweixinid.Contains(DAL.PromoterDAL.WX_ShareLinkUserWeiXinId)) //朋友分享的
            {
                return list;
            }

            if (!string.IsNullOrEmpty(userweixinid))
            {
                DataTable dt = SQLHelper.Get_DataTable("select AddressID, LinkMan, LinkPhone, Address, RoomNo, isSelected,isValidate, userweixinid,isnull(addressType,1)addressType,kuaidiAddress From T_address where  userweixinid=@userweixinid",
                        SQLHelper.GetCon(), new Dictionary<string, DBParam>(){
                {"userweixinid",new DBParam(){ParamValue=userweixinid}}
                });

                if (dt.Rows.Count > 0)
                {
                    list = dt.ToList<OrderAddress>();
                }
            }
            return list;
        }

        /// <summary>
        /// 获取会员属性
        /// </summary>
        /// <param name="userweixinid"></param>
        /// <param name="field">列名例如：mobile</param>
        /// <returns></returns>
        public static string GetMemberField(string userweixinid, string field)
        {
            string sql = "select top 1 " + field + " from Member where ISNULL(cardno,'')<>'' and userWeiXinNO=@userWeiXinNO";
            return SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { { "userWeiXinNO", new DBParam() { ParamValue = userweixinid } } });
        }
        public static string GetMemberPhone(string userweixinid)
        {
            string sql = "select top 1 mobile from Member where ISNULL(cardno,'')<>'' and userWeiXinNO=@userWeiXinNO";
            return SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { { "userWeiXinNO", new DBParam() { ParamValue = userweixinid } } });
        }

        /// <summary>
        /// 获取申请退款原因
        /// </summary>
        public static string GetRefundOrderApplyRemo(string orderCode, EnumRefundStauts stas)
        {
            string sql = "select top 1 remo from T_ApplyRefund where ordercode=@orderCode and applystatus=@applystatus";

            return SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
                {"orderCode",new DBParam(){ParamValue=orderCode}},
                {"applystatus",new DBParam(){ParamValue=Convert.ToInt32(stas).ToString()}}
            });

        }
        /// <summary>
        /// 获取商家,
        /// 默认isDefault=false，
        /// isDefault=false只根据id获取商家,
        /// isDefault=true则根据hotelId直接获取酒店自营商家/或默认商家(2自营,1周边,0=默认)
        /// </summary>
        /// <param name="storeId"></param>
        public static StoresView GetStore(int storeId, string hotelId = "", bool isDefault = false)
        {
            if (isDefault)
            {
                //查自营
                string sql = @" select top 1 t.* ,'' as remo from dbo.T_Stores t where isnull(Isaround,0) in (3,2) and hotelid=@hotelid order by Isaround asc";
                DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                    {"hotelid",new DBParam(){ParamValue=hotelId}}
                    });

                if (dt.Rows.Count > 0)
                {
                    return dt.Rows[0].ToModel<StoresView>();
                }
                else //查默认店铺
                {
                    sql = @" select top 1 t.* ,'' as remo from dbo.T_Stores t where isnull(Isaround,0)=0 and hotelid=@hotelid";
                    dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { { "hotelid", new DBParam() { ParamValue = hotelId } } });
                    if (dt.Rows.Count > 0)
                    {
                        return dt.Rows[0].ToModel<StoresView>();
                    }
                }
            }
            else
            {
                string sql = "select top 1 t.*,'' as remo from dbo.T_Stores t where t.StoreID=@StoreID";
                DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                    {"StoreID",new DBParam(){ParamValue=storeId.ToString()}}
                    });

                if (dt.Rows.Count > 0)
                {
                    return dt.Rows[0].ToModel<StoresView>();
                }
            }

            return null;
        }

        public static Youhui GetYouhui(string youHuiIds, string UsedMoney)
        {
            if (!string.IsNullOrEmpty(youHuiIds))
            {
                youHuiIds = "," + youHuiIds + ",";
                string sql = "select top 1 YouhuiID, UsedMoney, DelMoney, Remo from T_Youhui where  CHARINDEX(','+CONVERT(varchar(10),youhuiid)+',',@youHuiIds)>0 and UsedMoney<=@UsedMoney order by UsedMoney desc";
                DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(),
                    new Dictionary<string, DBParam>() { 
                         {"youHuiIds",new DBParam(){ParamValue=youHuiIds}},
                         {"UsedMoney",new DBParam(){ParamValue=UsedMoney}}
                    });

                if (dt.Rows.Count > 0)
                {
                    return dt.Rows[0].ToModel<Youhui>();
                }
            }

            return null;
        }

        public static string GetHotelName(string hotelId)
        {
            return SQLHelper.Get_Value("select top 1 SubName from hotel where id=@id", SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"id",new DBParam(){ParamValue=hotelId}}
            });
        }

        #endregion


        #region 编辑地址

        public static int InsertOrUpdateAddress(int addressid, string name, string phone, string room, string userweixinid, string address)
        {
            int rows = 0;
            if (addressid == 0)
            {
                rows = SQLHelper.Run_SQL("insert into T_address(LinkMan, LinkPhone, RoomNo, isSelected, userweixinid,[Address],isValidate)values(@name,@phone,@room,1,@userweixinid,@Address,1)", SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                {"name",new DBParam(){ParamValue=name}},
                {"phone",new DBParam(){ParamValue=phone}},
                {"room",new DBParam(){ParamValue=room}},
                {"userweixinid",new DBParam(){ParamValue=userweixinid}},
                {"Address",new DBParam(){ParamValue=address}}
                });
            }
            else
            {
                rows = SQLHelper.Run_SQL("update T_address set isValidate=1,LinkMan=@name, LinkPhone=@phone, RoomNo=@room where AddressID=@addressid", SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                {"name",new DBParam(){ParamValue=name}},
                {"phone",new DBParam(){ParamValue=phone}},
                {"room",new DBParam(){ParamValue=room}},
                {"addressid",new DBParam(){ParamValue=addressid.ToString()}},
                });
            }
            return rows;
        }

        /// <summary>
        /// 编辑送餐地址+设置订单地址
        /// </summary>
        /// <param name="addressid"></param>
        /// <param name="name"></param>
        /// <param name="phone"></param>
        /// <param name="room"></param>
        /// <param name="userweixinid"></param>
        /// <param name="address"></param>
        /// <param name="orderCode"></param>
        /// <returns></returns>
        public static int InsertOrUpdateAddress2(int addressid, string name, string phone, string room, string userweixinid, string address, string orderCode, string type, string kuaidiAddress, string source)
        {
            // 一个手机号对应一个地址
            //            string sql = @"
            //                            update T_OrderInfo set orderAddress=@Address,orderPhone=@phone,orderLinkMan=@name,orderRoomNo=@room where orderCode=@orderCode
            //                            update T_address set isSelected=0 where userweixinid=@userweixinid and LinkPhone<>@phone
            //                            if exists(select 1 from T_address where LinkPhone=@phone and userweixinid=@userweixinid)
            //                            begin 
            //                            update T_address set isSelected=1,isValidate=1, Address=@Address,LinkMan=@name, RoomNo=@room where (AddressID=@addressid or userweixinid=@userweixinid) and LinkPhone=@phone
            //                            end else
            //                            begin
            //                            insert into T_address(LinkMan, LinkPhone, RoomNo, isSelected, userweixinid,[Address],isValidate)values(@name,@phone,@room,1,@userweixinid,@Address,1)
            //                            end";


            //// 一个姓名对应一个地址 update T_OrderInfo set orderAddress=@Address,orderPhone=@phone,orderLinkMan=@name,orderRoomNo=@room where orderCode=@orderCode
            if (userweixinid.Contains(DAL.PromoterDAL.WX_ShareLinkUserWeiXinId)) //朋友分享的不记录联系人地址,直接设置订单地址
            {
                if (source == "canyin")
                {
                    string s = "update T_OrderInfo set orderAddress=@Address,orderPhone=@phone,orderLinkMan=@name,orderRoomNo=@room where orderCode=@orderCode";
                    return SQLHelper.Run_SQL(s, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
                        { 
                           {"orderCode",new DBParam(){ParamValue=orderCode}},
                           {"Address",new DBParam(){ParamValue=address}},
                           {"name",new DBParam(){ParamValue=name}},
                           {"phone",new DBParam(){ParamValue=phone}},
                           {"room",new DBParam(){ParamValue=room}},
                        }
                    );
                }
                return 1;
            }

            if (type == "2") //2其他,1酒店
            {
                room = "";
            }
            if (type == "1")
            {
                kuaidiAddress = "";
            }
            string sql = @"
begin try  
begin transaction
        update T_address set isSelected=0 where userweixinid=@userweixinid and LinkMan<>@name 
        if exists(select 1 from T_address where LinkMan=@name and userweixinid=@userweixinid )
        begin 
        update T_address set isSelected=1,isValidate=1,kuaidiAddress=@kuaidiAddress, Address=@Address,LinkPhone=@phone, RoomNo=@room,addressType=@addressType where (AddressID=@addressid or userweixinid=@userweixinid) and LinkMan=@name
        end else
        begin
        insert into T_address(LinkMan, LinkPhone, RoomNo, isSelected, userweixinid,[Address],isValidate,addressType,kuaidiAddress)values(@name,@phone,@room,1,@userweixinid,@Address,1,@addressType,@kuaidiAddress)
        end

 commit transaction
end try
begin catch
 rollback transaction
end catch ";

            int rows = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                {"name",new DBParam(){ParamValue=name}},
                {"phone",new DBParam(){ParamValue=phone+""}},
                {"room",new DBParam(){ParamValue=room+""}},
                {"userweixinid",new DBParam(){ParamValue=userweixinid+""}},
                {"Address",new DBParam(){ParamValue=address+""}},
                {"addressid",new DBParam(){ParamValue=addressid.ToString()}},
                {"orderCode",new DBParam(){ParamValue=orderCode+""}},
                {"addressType",new DBParam(){ParamValue=type}},
                {"kuaidiAddress",new DBParam(){ParamValue=kuaidiAddress+""}}
                });

            return rows;
        }

        /// <summary>
        /// 手机号是否已经验证过，验证过= return true
        /// </summary>
        public static bool IsValidatePhoneNo(int addressid, string phone)
        {
            string str = SQLHelper.Get_Value("select top 1 1 from dbo.T_Address where AddressID=@addressid and LinkPhone=@phone and isValidate=1", SQLHelper.GetCon()
                , new Dictionary<string, DBParam>() 
                    {
                       {"addressid",new DBParam(){ParamValue=addressid.ToString()}},
                       {"phone",new DBParam(){ParamValue=phone}}
                    });

            return !string.IsNullOrEmpty(str);
        }

        #endregion

        #region 订单备注，用餐人数

        public static string GetOrderRemo(string orderCode)
        {
            return SQLHelper.Get_Value("select top 1 remo from  T_OrderInfo  where orderCode=@orderCode", SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"orderCode",new DBParam(){ParamValue=orderCode}}
            });
        }

        public static int SaveOrderRemo(string orderCode, string userweixinid, string remo)
        {
            return SQLHelper.Run_SQL("update T_OrderInfo set remo=@remo where orderCode=@orderCode and userweixinid=@userweixinid", SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"remo",new DBParam(){ParamValue=remo}},
            {"orderCode",new DBParam(){ParamValue=orderCode}},
            {"userweixinid",new DBParam(){ParamValue=userweixinid}}
            });
        }

        public static int SaveUserNumber(string orderCode, int userNumber)
        {
            return SQLHelper.Run_SQL("update T_OrderInfo set userNumber=@userNumber where orderCode=@orderCode", SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"userNumber",new DBParam(){ParamValue=userNumber.ToString()}},
            {"orderCode",new DBParam(){ParamValue=orderCode}}
            });
        }

        #endregion

        /// <summary>
        /// 根据编号修改订单状态
        /// </summary>
        public static int UpdateOrderStatusByOrderCode(string orderCode, EnumOrderStatus stas)
        {
            Dictionary<string, DBParam> dic = new Dictionary<string, DBParam>() 
            {
              {"stas",new DBParam(){ParamValue=Convert.ToInt32(stas).ToString()}},
              {"orderCode",new DBParam(){ParamValue=orderCode}}
            };
            string sql = "UPDATE T_OrderInfo SET [Status]=@stas where orderCode=@orderCode";
            if (stas == EnumOrderStatus.UnPay)
            {
                sql = "UPDATE T_OrderInfo SET [Status]=@stas,submitTime=@submitTime where orderCode=@orderCode and ISNULL([Status],0)=" + Convert.ToInt32(EnumOrderStatus.UnSubmit);
                dic.Add("submitTime", new DBParam() { ParamValue = DateTime.Now.ToString() });
            }
            if (stas == EnumOrderStatus.IsOverTime)
            {
                sql = @"UPDATE CouPonContent set IsEmploy=0,EmployTime=null,OrderNO='' where id in(select top 1 ISNULL(CouponId,0)CouponId from T_OrderInfo where orderCode=@orderCode);
 UPDATE T_OrderInfo SET [Status]=@stas where orderCode=@orderCode and ISNULL([Status],0)=" + Convert.ToInt32(EnumOrderStatus.UnPay);
            }
            if (stas == EnumOrderStatus.IsPay)
            {
                sql = "UPDATE T_OrderInfo SET [Status]=@stas,payTime=@payTime where orderCode=@orderCode and ISNULL([Status],0)=" + Convert.ToInt32(EnumOrderStatus.UnPay);
                dic.Add("payTime", new DBParam() { ParamValue = DateTime.Now.ToString() });
            }
            if (stas == EnumOrderStatus.IsCancel)
            {
                sql = @"UPDATE CouPonContent set IsEmploy=0,EmployTime=null,OrderNO='' where id in(select top 1 ISNULL(CouponId,0)CouponId from T_OrderInfo where orderCode=@orderCode);
 UPDATE T_OrderInfo SET [Status]=@stas where orderCode=@orderCode and ISNULL([Status],0)=" + Convert.ToInt32(EnumOrderStatus.UnPay);
            }
            if (stas == EnumOrderStatus.IsFinish)
            {
                sql = @"UPDATE T_OrderInfo SET [Status]=@stas,finishTime=@finishTime where orderCode=@orderCode 
     and (ISNULL([Status],0)=" + Convert.ToInt32(EnumOrderStatus.IsPeiSongZhong) + " or ISNULL([Status],0)=" + Convert.ToInt32(EnumOrderStatus.IsSure) + @")";
                dic.Add("finishTime", new DBParam() { ParamValue = DateTime.Now.ToString() });
            }

            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), dic);

        }

        /// <summary>
        /// 根据编号设置订单送货地址,支付金额=（订单金额+打包费-优惠费）， 商家结算价=（支付金额-佣金*支付金额 ）,默认使用人一人,此单还未提交
        /// </summary>
        public static int SettingOrderInfoByOrderCode(string orderCode, OrderAddress model, decimal bagging, int yongjin,string tablenumber="")
        {
            if (model.AddressID > 0)
            {
                Dictionary<string, DBParam> dic = new Dictionary<string, DBParam>() 
                    {
                      {"orderCode",new DBParam(){ParamValue=orderCode}},
                      {"linkMan",new DBParam(){ParamValue=model.LinkMan+""}},
                      {"linkPhone",new DBParam(){ParamValue=model.LinkPhone+""}},
                      {"address",new DBParam(){ParamValue=model.Address+""}},
                      {"roomNo",new DBParam(){ParamValue=model.RoomNo+""}},
                      {"yongjin",new DBParam(){ParamValue=yongjin.ToString()}},
                      {"bagging",new DBParam(){ParamValue=bagging.ToString()}},
                      {"tablenumber",new DBParam(){ParamValue=tablenumber+""}}
                    };

                string sql = @"UPDATE T_OrderInfo SET userNumber=isnull(userNumber,1),orderAddress=@address,orderPhone=@linkPhone,orderLinkMan=@linkMan,orderRoomNo=@roomNo,tablenumber=@tablenumber,bagging=@bagging
                ,payamount=ISNULL(amount,0)+" + bagging + @"-ISNULL(youhuiamount,0)
                ,jiesuanjia=(ISNULL(amount,0)+" + bagging + @"-ISNULL(youhuiamount,0))*(100-@yongjin)/100
where orderCode=@orderCode and isnull(Status,0)=0";
                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), dic);
            }
            else //无联系人历史
            {
                Dictionary<string, DBParam> dic = new Dictionary<string, DBParam>() 
                    {
                      {"orderCode",new DBParam(){ParamValue=orderCode}},
                      {"yongjin",new DBParam(){ParamValue=yongjin.ToString()}},
                      {"bagging",new DBParam(){ParamValue=bagging.ToString()}},
                      {"tablenumber",new DBParam(){ParamValue=tablenumber+""}}
                    };

                string sql = @"UPDATE T_OrderInfo SET userNumber=isnull(userNumber,1),bagging=@bagging
                ,payamount=ISNULL(amount,0)+" + bagging + @"-ISNULL(youhuiamount,0) 
                ,jiesuanjia=(ISNULL(amount,0)+" + bagging + @"-ISNULL(youhuiamount,0))*(100-@yongjin)/100
,orderAddress='',orderPhone='',orderLinkMan='',orderRoomNo='',tablenumber=@tablenumber
where orderCode=@orderCode and isnull(Status,0)=0";
                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), dic);
                //payamount=(ISNULL(amount,0)+isnull(bagging,0)-isnull(youhuiamount,0)-isnull(CouponMoney,0)-isnull(manjianmoney,0))
            }

        }

        /// <summary>
        /// 根据编号和订单消费金额设置 订单优惠金额 ，包装费
        /// </summary>
        public static int UpdateOrderYouHuiMoney(string orderCode, decimal YouhuiMoney, decimal bagging)
        {
            Dictionary<string, DBParam> dic = new Dictionary<string, DBParam>() 
            {
              {"YouhuiMoney",new DBParam(){ParamValue=YouhuiMoney.ToString()}},
              {"orderCode",new DBParam(){ParamValue=orderCode}},
              {"bagging",new DBParam(){ParamValue=bagging.ToString()}}
            };
            string sql = "UPDATE T_OrderInfo SET youhuiamount=@YouhuiMoney,bagging=@bagging where orderCode=@orderCode";

            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), dic);
        }

        /// <summary>
        /// 取消订单
        /// </summary>
        public static int CancelOrder(string orderCode, EnumOrderStatus stas)
        {
            return UpdateOrderStatusByOrderCode(orderCode, stas);
        }

        /// <summary>
        /// 保存申请退款
        /// </summary>
        public static int SaveRefund(string orderCode, string remo, string amount)
        {
            string sql = @"insert into T_ApplyRefund(ordercode, createtime, refundamount, remo, applystatus) 
                                              values(@ordercode, @createtime, @refundamount, @remo, @applystatus)";
            Dictionary<string, DBParam> dic = new Dictionary<string, DBParam>() 
            {
              {"orderCode",new DBParam(){ParamValue=orderCode}}, 
              {"createtime",new DBParam(){ParamValue=DateTime.Now.ToString()}},
              {"refundamount",new DBParam(){ParamValue=amount}},
              {"remo",new DBParam(){ParamValue=remo}},
              {"applystatus",new DBParam(){ParamValue=Convert.ToInt32(EnumRefundStauts.SubmitApply).ToString()}}
            };

            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), dic);
        }

        /// <summary>
        /// 获取用户可使用的红包列表
        /// </summary>
        /// <param name="weixinID"></param>
        /// <param name="userweixinNo"></param>
        /// <param name="scopelimit">1自营餐饮， 4周边餐饮</param>
        /// <param name="amountlimit">消费满x元可用</param>
        /// <returns></returns>
        public static DataTable GetUserCouPonDataTable(string weixinID, string userweixinNo, string scopelimit)
        {
            string sql = @"select cc.id,cc.moneys,cc.sTime,cc.ExtTime,ISNULL(c.amountlimit,0) as amountlimit
                       from CouPonContent cc, CouPon c where cc.typeID=c.id
                      and cc.weixinID=@weixinID and cc.userweixinNo=@userweixinNo
                      and c.scopelimit like '%'+@scopelimit+'%' and c.Endable = 1
                      and cc.ExtTime > GETDATE() and cc.IsEmploy=0  ";

            //and ISNULL(c.amountlimit,0)<=@amountlimit
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(),
                new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                { "weixinID", new HotelCloud.SqlServer.DBParam { ParamValue = weixinID } },
                { "userweixinNo", new HotelCloud.SqlServer.DBParam { ParamValue = userweixinNo } },
                { "scopelimit", new HotelCloud.SqlServer.DBParam { ParamValue = scopelimit } }
                });

            return dt;
        }

        /// <summary>
        /// 提交订单[设置使用红包,消费满减金额信息]
        /// </summary>
        public static int SubOrderByCouPon(string orderCode, string CouponId, string CouponMoney, string weixinID, string userWeiXinNO, string usetime, string jifen, string yhamount, string manjianmoney, string manjianremo, string remo, string tablenumber, string tablenumberid="")
        {
            string sql = @"
            begin try  
            begin transaction
                update T_OrderInfo set [Status]=@nexStatus,oreateTime=GETDATE(),submitTime=GETDATE(),usetime=@usetime,payamount=ISNULL(amount,0)-@youhuiamount-@CouponMoney-@manjianmoney,CouponId=@CouponId,CouponMoney=@CouponMoney,jifen=@jifen,youhuiamount=@youhuiamount,manjianmoney=@manjianmoney,manjianremo=@manjianremo,remo=@remo,tablenumber=@tablenumber,tablenumberid=@tablenumberid
                where orderCode=@orderCode and [Status]=@curStatus
                update CouPonContent set IsEmploy=1,EmployTime=GETDATE(),OrderNO=@orderCode where id=@CouponId
             commit transaction
            end try
            begin catch
              rollback transaction
            end catch
            ";
   
            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
               {"orderCode",new DBParam(){ParamValue=orderCode}},
               {"usetime",new DBParam(){ParamValue=usetime}},
               {"CouponId",new DBParam(){ParamValue=CouponId}},
               {"CouponMoney",new DBParam(){ParamValue=CouponMoney}},
               {"nexStatus",new DBParam(){ParamValue=Convert.ToInt32(EnumOrderStatus.UnPay).ToString()}},
               {"curStatus",new DBParam(){ParamValue=Convert.ToInt32(EnumOrderStatus.UnSubmit).ToString()}},
               {"weixinID",new DBParam(){ParamValue=weixinID}},
               {"userWeiXinNO",new DBParam(){ParamValue=userWeiXinNO}},
               {"jifen",new DBParam(){ParamValue=jifen}},
               {"youhuiamount",new DBParam(){ParamValue=yhamount}},
               {"manjianmoney",new DBParam(){ParamValue=manjianmoney}},
               {"manjianremo",new DBParam(){ParamValue=manjianremo}},
               {"remo",new DBParam(){ParamValue=remo}},
               {"tablenumber",new DBParam(){ParamValue=tablenumber}},
               {"tablenumberid",new DBParam(){ParamValue=tablenumberid}}
            });
        }
        /// <summary>
        /// 设置订单分销佣金
        /// </summary>
        public static int SetOrderFxmoney(string weixinid, string userweixinid, string orderCode)
        {
            double Money = 0;
            string pMoney = SQLHelper.Get_Value("select top 1 isnull(payamount,0)payamount from dbo.T_OrderInfo where orderCode=@orderCode ", SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
                {
                    {"orderCode",new DBParam(){ParamValue=orderCode}}
                });
            double.TryParse(pMoney, out Money);

            TuiGuangMoney model = MemberFxLogic.GetTuiGuangProfit(ProfitType.canyin, weixinid, userweixinid, Money);
            
            if (userweixinid.Contains(DAL.PromoterDAL.WX_ShareLinkUserWeiXinId))
            { 
                int proid=0;
                int.TryParse(userweixinid.Split('_')[1], out proid);
                if (proid > 0) 
                {
                    model.promoterid = proid;
                }
            }
            
            if (model.promoterid > 0)
            {
                string sql = @"update T_OrderInfo set promoterid=@promoterid,fxmoney=@fxmoney,fxmoneyProfit=@fxmoneyProfit where orderCode=@orderCode ";
                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
                {
                    {"promoterid",new DBParam(){ParamValue=model.promoterid+""}},
                    {"fxmoney",new DBParam(){ParamValue=model.hotelCommission+""}},
                    {"fxmoneyProfit",new DBParam(){ParamValue=model.userCommission+""}},
                    {"orderCode",new DBParam(){ParamValue=orderCode}}
                });
            }
            return 0;
        }

        /// <summary>
        /// 堂食，设置订单金地址为餐厅桌台号
        /// </summary>
        public static int SetOrderEatAtStore(string orderCode,string tablenumber,int FromScan) 
        {
            string sql = @"update T_OrderInfo set tablenumber=@tablenumber,orderAddress='',orderPhone='',orderLinkMan='',orderRoomNo='' where orderCode=@orderCode ";
            if (FromScan == Convert.ToInt32(EnumFromScan.非扫码)) 
            {
                sql = @"update T_OrderInfo set tablenumber=@tablenumber where orderCode=@orderCode ";
            }
            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
                {
                    {"orderCode",new DBParam(){ParamValue=orderCode}},
                    {"tablenumber",new DBParam(){ParamValue=tablenumber}}
                });
        }

        /// <summary>
        /// 设置订单序号
        /// 同一天同一店家支付成功的单序号
        /// </summary>
        /// <param name="ordercode">订单号</param>
        public static int SettingOrderXuHao(string ordercode)
        {
            try
            {
                string sql = @"declare @xuhao varchar(50)
select @xuhao=count(1) from T_OrderInfo t where t.orderPayState=1 
and t.hotelWeixinId=(select top 1 hotelWeixinId from T_OrderInfo where ordercode=@ordercode)
and t.storeID=(select top 1 storeID from T_OrderInfo where ordercode=@ordercode)
and t.payTime<=(select top 1 payTime from T_OrderInfo where ordercode=@ordercode)
and CONVERT(char(10),t.submitTime,121)=CONVERT(char(10),GETDATE(),121)
Update T_OrderInfo set xuhao=@xuhao where ordercode=@ordercode";

                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
                    {
                     {"ordercode",new DBParam(){ParamValue=ordercode}}
                    });
            }
            catch
            {
                return 0;
            }
        }

        /// <summary>
        /// 获取桌台号
        /// </summary>
        /// <param name="tid">桌台号id</param>
        public static string GetTableNumber(int tid)
        {
            string sql = @"select top 1 name from wkn_Codelist where aid=@tid";
            return SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
             {"tid",new DBParam(){ParamValue=tid+""}}
            });
        }

        /// <summary>
        /// 获取商家桌台区域
        /// </summary>
        /// <param name="storeid"></param>
        /// <returns></returns>
        public static List<StoreTableArea> GetStoreTableAreaList(int storeid)
        {
            string sql = @"select t.* from T_StoreTableArea t where t.storeid=@storeid order by t.sortindex asc ";

            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
             {"storeid",new DBParam(){ParamValue=storeid+""}}
            }).ToList<StoreTableArea>();

        }

        /// <summary>
        /// 获取区域所有桌台
        /// </summary>
        /// <param name="storeid"></param>
        /// <returns></returns>
        public static List<StoreTables> GetStoreTableList(int storeid)
        {
            string sql = @"select t.* from T_StoreTables t inner join T_StoreTableArea a on t.areaid=a.id where a.storeid=@storeid";
            
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
              {"storeid",new DBParam(){ParamValue=storeid+""}}
            }).ToList<StoreTables>();

        }

        /// <summary>
        /// 获取商家餐台数据
        /// </summary>
        /// <param name="storeid"></param>
        /// <returns></returns>
        public static string GetTableJsonByStoreId(int storeid)
        {
            List<StoreTableArea> listarea = GetStoreTableAreaList(storeid);
            List<StoreTables> listtale = GetStoreTableList(storeid);
            string data = "";
            foreach (var item in listarea)
            {
                List<StoreTables> list = listtale.FindAll(a => a.areaid == item.id);
                string childs = "";
                foreach (var temp in list)
                {
                    if (childs == "")
                    {
                        childs = "{" + string.Format("id:'{0}',value:'{1}'", temp.id, temp.tablename) + "}";
                    }
                    else
                    {
                        childs += ",{" + string.Format("id:'{0}',value:'{1}'", temp.id, temp.tablename) + "}";
                    }
                }
                if (list.Count > 0 && childs != "")
                {
                    if (data == "")
                    {
                        data = "{" + string.Format("id:'{0}',value:'{1}',childs:[$]", item.id, item.areaname).Replace("$", childs) + "}";
                    }
                    else
                    {
                        data += ",{" + string.Format("id:'{0}',value:'{1}',childs:[$]", item.id, item.areaname).Replace("$", childs) + "}";
                    }
                }
            }
            return data;
        }
    }

    /// <summary>
    /// 【新餐饮】点餐逻辑类
    /// </summary>
    public static class DishOrderLogicA
    {
        /// <summary>
        /// 【新餐饮】获取酒店餐厅
        /// </summary>
        public static List<DiningRoom> GetDiningRoomList(string hotelId) 
        {
            string sql = "select * from T_Diningroom where hotelId=@hotelId";

            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
              {"hotelId",new DBParam(){ParamValue=hotelId}}
            });

            return dt.ToList<DiningRoom>(); 
        }

        /// <summary>
        /// 【新餐饮】根据ID获取餐厅
        /// </summary>
        public static DiningRoom GetDiningRoomModel(int DiningRoomID)
        {
            string sql = "select top 1 * from T_Diningroom where DiningRoomID=@DiningRoomID";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
              {"DiningRoomID",new DBParam(){ParamValue=DiningRoomID.ToString()}}
            });
            if (dt.Rows.Count > 0)
            {
                return dt.Rows[0].ToModel<DiningRoom>();
            }
            else 
            {
                return null;
            }
        }

        /// <summary>
        /// 【新餐饮】餐厅预订  订单编号
        /// </summary>
        /// <returns></returns>
        public static string GetNewDiningRoomOrderCode() 
        {
            string pre = new Random().Next(10001, 99999).ToString();
            return "C" + DateTime.Now.ToString("MMddhhmmssfff") + pre;
        }

        /// <summary>
        /// 【新餐饮】生成餐厅座位预订订单
        /// </summary>
        /// <returns></returns>
        public static int CreateBookingDiningRoomOrder(DiningRoomOrder model)
        {
            //            string sql = @"insert T_DiningRoomOrder(DROrderCode, DiningRoomID, DiningRoomName, UseNuber, UseDate, UseTime, LinkMan, Sex, LinkPhone, Beizhu, CreateTime, State, hotelId, useerweixinid)
            //                          values(@DROrderCode,@DiningRoomID, @DiningRoomName, @UseNuber, @UseDate, @UseTime, @LinkMan, @Sex, @LinkPhone, @Beizhu, @CreateTime, @State, @hotelId, @useerweixinid)";

            //            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            //            {
            //               {"DROrderCode",new DBParam(){ParamValue=model.DROrderCode}},
            //               {"DiningRoomID",new DBParam(){ParamValue=model.DiningRoomID.ToString()}},
            //               {"DiningRoomName",new DBParam(){ParamValue=model.DiningRoomName}},
            //               {"UseNuber",new DBParam(){ParamValue=model.UseNuber.ToString()}},
            //               {"UseDate",new DBParam(){ParamValue=model.UseDate}},
            //               {"UseTime",new DBParam(){ParamValue=model.UseTime}},
            //               {"LinkMan",new DBParam(){ParamValue=model.LinkMan}},
            //               {"Sex",new DBParam(){ParamValue=model.Sex}},
            //               {"LinkPhone",new DBParam(){ParamValue=model.LinkPhone}},
            //               {"Beizhu",new DBParam(){ParamValue=model.Beizhu}},
            //               {"CreateTime",new DBParam(){ParamValue=model.CreateTime}},
            //               {"State",new DBParam(){ParamValue=model.State.ToString()}},
            //               {"hotelId",new DBParam(){ParamValue=model.hotelId}},
            //               {"useerweixinid",new DBParam(){ParamValue=model.useerweixinid}}
            //            });

            string sql = @"insert into HotelOrder(OrderNO,LinkTel,UserName,demo,UserWeiXinID,HotelID,HotelName,WeixinID,RoomID,RoomName,yinDate,lastTime,yRoomNum,Ordertime,state,remark,isMeeting,
UserID,RatePlanID,RatePlanName,youtDate,PayType, yPriceStr, ySumPrice, sRoomNum,
sinDate, soutDate, sPriceStr, sSumPrice, Source, sourceorderid, ip,jifen, NetPrice,
realprice, tradeNo, aliPayAmount, tradeStatus, aliPayTime, refundfee, logisticsStatus,
Refuse, taoBaoOrderId, TaoBaoHotelId, TaoBaoRatePlanId, TaoBaoRoomTypeId,taoBaoGId, isGuarantee, taobaoTotalPrice, confirmorderdate,
serviceTimeount, payTime, GuaranteeAmount, canceldate, orderCheckoutDate, fpsubmitprice,
ishourroom, foregift, foregiftstate, needinvoice, invoicestate,CouponInfo, isfreeroom, PayMethod, isdist 
) 
values(@OrderNO,@LinkTel,@UserName,@demo,@UserWeiXinID,@HotelID,@HotelName,@WeixinID,@RoomID,@RoomName,@yinDate,@lastTime,@yRoomNum,@Ordertime,@state,@remark,@isMeeting,
0,0,@RoomName,'1900-01-01',1,'price2017-05-08|1300|money2017-05-08|0|',0,1,
'1900-01-01','1900-01-01','',0,'weixinweb',NEWID(),'',0,1,
0, '', 0, 0, '1900-01-01', 0, 0,
0, 0, 0, 0, 0,0, 0, 0, '1900-01-01',
'1900-01-01', '1900-01-01', 0, '1900-01-01', '1900-01-01', 0, 
0, 0, 0, 0, 0, '',0, '', 0
)";

            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
               {"OrderNO",new DBParam(){ParamValue=model.DROrderCode}},
               {"LinkTel",new DBParam(){ParamValue=model.LinkPhone}},
               {"UserName",new DBParam(){ParamValue=model.LinkMan+"("+model.Sex+")"}},
               {"demo",new DBParam(){ParamValue=model.Beizhu}},
               {"UserWeiXinID",new DBParam(){ParamValue=model.userweixinid}},
               {"HotelID",new DBParam(){ParamValue=model.hotelId}},
               {"HotelName",new DBParam(){ParamValue=model.hotelName}},
               {"WeixinID",new DBParam(){ParamValue=model.hotelweixinid}},
               {"RoomID",new DBParam(){ParamValue=model.DiningRoomID.ToString()}},
               {"RoomName",new DBParam(){ParamValue=model.DiningRoomName}},
               {"yinDate",new DBParam(){ParamValue=model.UseDate}},
               {"lastTime",new DBParam(){ParamValue=model.UseTime}},
               {"yRoomNum",new DBParam(){ParamValue=model.UseNuber.ToString()}},
               {"Ordertime",new DBParam(){ParamValue=DateTime.Now.ToString()}},
               {"state",new DBParam(){ParamValue=Convert.ToInt32(EnumDiningRoomOrderStatus.待跟进).ToString()}},
               {"remark",new DBParam(){ParamValue=""}},
               {"isMeeting",new DBParam(){ParamValue="9"}}
            });
        }

        /// <summary>
        /// 【新餐饮】获取餐厅 订单信息
        /// </summary>
        public static DataTable GetDiningRoomOrderInfo(string diningRoomOrderCode) 
        {
            string sql = @"select top 1 OrderNO,LinkTel,UserName,demo as sex,UserWeiXinID,HotelID,HotelName,WeixinID,RoomID,RoomName,yinDate as usedate,lastTime as usetime,yRoomNum as usernumber,Ordertime,state,remark,isMeeting 
from HotelOrder where OrderNO=@OrderNO and isMeeting=9";
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { { "OrderNO", new DBParam() { ParamValue = diningRoomOrderCode } } });
        }
        /// <summary>
        /// 【新餐饮】取消餐厅 订单信息
        /// </summary>
        public static int UpdateDiningRoomOrderStatus(string diningRoomOrderCode, EnumDiningRoomOrderStatus status)
        {
            string sql = @"update HotelOrder set state=@state where OrderNO=@OrderNO and isMeeting=9";
            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
              { "OrderNO", new DBParam() { ParamValue = diningRoomOrderCode } } ,
              { "state", new DBParam() { ParamValue = Convert.ToInt32(status).ToString() } } }
            );
        }

        /// <summary>
        /// 【新餐饮】获取未提交订单编号,库里获取不到则返回一个新创建的编号
        /// </summary>
        public static string GetOrderACode(string hotelId, string storeId, string userWeiXinId, EnumOrderStatus stas)
        {
            string code = SQLHelper.Get_Value("select top 1 orderCode from T_OrderInfo where ISNULL([Status],0)=@stas and storeID=@storeID and hotelid=@hotelid and userweixinid=@userweixinid ", SQLHelper.GetCon(),
                  new Dictionary<string, DBParam>()
                    {
                        {"stas",new DBParam(){ParamValue=Convert.ToInt32(stas).ToString()}},
                        {"storeID",new DBParam(){ParamValue=storeId}},
                        {"userweixinid",new DBParam(){ParamValue=userWeiXinId}},
                        {"hotelid",new DBParam(){ParamValue=hotelId}}
                    });
            if (!string.IsNullOrEmpty(code))
            {
                return code;
            }
            else
            {
                string pre = new Random().Next(100, 999).ToString();
                return "L" + DateTime.Now.ToString("yyMMddhhmmssfff") + pre;//新订单编号
            }
        }

        /// <summary>
        /// 【新餐饮】获取订单菜品总数量
        /// </summary>
        /// <param name="orderCode"></param>
        /// <returns></returns>
        public static string GetOrderDishTotalNum_A(string orderCode)
        {
            string sql = "select isnull(SUM(number),0)totalnum from T_OrderDetails  where orderCode=@orderCode";
            return SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"orderCode",new DBParam(){ParamValue=orderCode}}
                    });
        }

        /// <summary>
        /// 【新餐饮】获取购物车明细
        /// </summary>
        /// <param name="orderCode"></param>
        /// <returns></returns>
        public static DataTable GetDishCartDetail(string orderCode)
        {
            string sql = @" select t1.*,t2.DishsesDesc,t2.DishesImg from T_OrderDetails t1 left join T_Dishses t2 on t1.DishsesID=t2.DishsesID
 where t1.number>0 and t1.orderCode=@orderCode";

            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"orderCode",new DBParam(){ParamValue=orderCode}}
                    });
        }

        /// <summary>
        /// 【新餐饮】获取订单信息 [ExistsHasDetail=true，加订单有明细条件]
        /// </summary>
        /// <param name="orderCode"></param>
        /// <returns></returns>
        public static OrderInfo GetOrderInfo_A(string orderCode,bool ExistsHasDetail=false) 
        {
            string sql = @"SELECT top 1 t.orderId, t.orderCode, t.amount,isnull(t.youhuiamount,0)youhuiamount,isnull(t.bagging,0)bagging, 
 t.orderAddress,t.orderRoomNo,t.orderLinkMan, t.orderPhone, t.orderPayType, t.orderPayState, t.oreateTime, t.Status, t.storeID, t.userNumber, t.remo, 
 t.AddressID, t.hotelid,t.hotelWeixinId, t.userweixinid,t.submitTime,t.payTime,t.willArriveTime,isnull(t.CouponMoney,0)CouponMoney,t.CouponId,t.usetime,isnull(t.jifen,0)jifen   FROM T_OrderInfo t WHERE t.orderCode=@orderCode";
            if (ExistsHasDetail)
            {
                sql = @" SELECT top 1 t.orderId, t.orderCode, t.amount,isnull(t.youhuiamount,0)youhuiamount,isnull(t.bagging,0)bagging, 
 t.orderAddress,t.orderRoomNo,t.orderLinkMan, t.orderPhone, t.orderPayType, t.orderPayState, t.oreateTime, t.Status, t.storeID, t.userNumber, t.remo, 
 t.AddressID, t.hotelid,t.hotelWeixinId, t.userweixinid,t.submitTime,t.payTime,t.willArriveTime,isnull(t.CouponMoney,0)CouponMoney,t.CouponId,t.usetime,isnull(t.jifen,0)jifen 
  FROM T_OrderInfo t inner join T_OrderDetails d on t.orderCode=d.orderCode WHERE d.number>0 and t.orderCode=@orderCode";
            }
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() {
            {"orderCode",new DBParam(){ParamValue=orderCode}}
            });
            if (dt.Rows.Count > 0)
            {
                return dt.Rows[0].ToModel<OrderInfo>();
            }
            else
            {
                return new OrderInfo();
            }

        }

        /// <summary>
        /// 【新餐饮】获取订单金额，可用红包菜品总金额
        /// </summary>
        /// <param name="orderCode"></param>
        /// <returns></returns>
        public static DataTable GetOrderAmountAndCanCouponMoney(string orderCode)
        {
            string sql = "select top 1 amount,isnull((select SUM(price*number) from dbo.T_OrderDetails where orderCode=T_OrderInfo.orderCode and canCoupon=1),0)couponTotalMoney from T_OrderInfo  where orderCode=@orderCode";
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"orderCode",new DBParam(){ParamValue=orderCode}}
                    });
        }

        /// <summary>
        /// 【新餐饮】设置订单地址信息+状态[已提交待支付]
        /// </summary>
        /// <param name="orderCode"></param>
        /// <returns></returns>
        public static int SetOrderAddress_A(string orderCode, string linkMan, string linkPhone, string hotelName, string roomNo, string remo, string couponId,
            string couponMoney, string weixinID, string userWeiXinNO, string usetime, string jifen, string yhamount, string manjianmoney, string manjianremo, string tablenumber = "", string tablenumberid="")
        {
            string sql = @"
begin try  
begin transaction
    UPDATE T_OrderInfo SET youhuiamount=@youhuiamount,jifen=@jifen,manjianmoney=@manjianmoney,manjianremo=@manjianremo,tablenumber=@tablenumber,tablenumberid=@tablenumberid WHERE orderCode=@orderCode;
    UPDATE T_OrderInfo SET usetime=@usetime,userNumber=isnull(userNumber,1),orderAddress=@address,orderPhone=@linkPhone,orderLinkMan=@linkMan,orderRoomNo=@roomNo,Status=@status,oreateTime=getdate(),submitTime=getdate(),remo=@remo,
    CouponMoney=@couponMoney,CouponId=@couponId,payamount=ISNULL(amount,0)+ISNULL(bagging,0)-ISNULL(youhuiamount,0)-@couponMoney-isnull(manjianmoney,0)
    WHERE orderCode=@orderCode;
    
    update CouPonContent set IsEmploy=1,EmployTime=GETDATE(),OrderNO=@orderCode where id=@couponId
commit transaction
end try
begin catch
 rollback transaction
end catch 
";

            Dictionary<string, DBParam> dic = new Dictionary<string, DBParam>() 
                    {
                      {"orderCode",new DBParam(){ParamValue=orderCode}},
                      {"usetime",new DBParam(){ParamValue=usetime}},
                      {"linkMan",new DBParam(){ParamValue=linkMan}},
                      {"linkPhone",new DBParam(){ParamValue=linkPhone}},
                      {"address",new DBParam(){ParamValue=hotelName}},
                      {"roomNo",new DBParam(){ParamValue=roomNo}},
                      {"remo",new DBParam(){ParamValue=remo}},
                      {"status",new DBParam(){ParamValue=Convert.ToInt32(EnumOrderStatus.UnPay).ToString()}},
                      {"couponId",new DBParam(){ParamValue=couponId}},
                      {"couponMoney",new DBParam(){ParamValue=couponMoney}},
                      {"weixinID",new DBParam(){ParamValue=weixinID}},
                      {"userWeiXinNO",new DBParam(){ParamValue=userWeiXinNO}},
                      {"youhuiamount",new DBParam(){ParamValue=yhamount}},
                      {"jifen",new DBParam(){ParamValue=jifen}},
                      {"manjianmoney",new DBParam(){ParamValue=manjianmoney}},
                      {"manjianremo",new DBParam(){ParamValue=manjianremo}},
                      {"tablenumber",new DBParam(){ParamValue=tablenumber}},
                      {"tablenumberid",new DBParam(){ParamValue=tablenumberid}}
                    };

            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), dic);
        }

        /// <summary>
        /// 【新餐饮】生成餐饮订单
        /// </summary>
        public static int CreateOrder_A(string ordercode, Dishses model, StoresView store, int number, string hotelId, string userweixinid, string hotelWeixinId, string hotelName,
            string roomno, string linkMan, string linkPhone, string remo, string couponId, string couponMoney, string usetime, string jifen, string yhamount, decimal discount,
            string manjianmoney, string manjianremo, string tablenumber = "", string tablenumberid="")
        {
            decimal bagging = 0;
            int yongjin = 0;
            string storeID = "0";
            if (store != null)
            {
                yongjin = store.yongjin;
                bagging = store.bagging;
                storeID = store.StoreId.ToString();
            }
            decimal discountprice = model.price;
            if (discount > 0)
            {
                discountprice = model.price * discount / 10;
            }

            double profitPoint8 = MemberFxLogic.TuiGuangProfit();
            double profitPoint2 = 1 - profitPoint8;
            string sql = @"
begin try  
begin transaction
INSERT INTO [WeiXin].[dbo].[T_OrderInfo]
                               ([orderCode]
                               ,[oreateTime]
                               ,[Status]
                               ,[storeID]
                               ,[hotelid]
                               ,[userweixinid],hotelWeixinId,submitTime,amount,bagging,userNumber,orderLinkMan,orderPhone,orderAddress,orderRoomNo,remo,CouponMoney,CouponId,usetime,jifen,youhuiamount,manjianmoney,manjianremo,tablenumber,tablenumberid)
                         VALUES
                               (@orderCode
                               ,@oreateTime
                               ,@Status
                               ,@storeID
                               ,@hotelid
                               ,@userweixinid,@hotelWeixinId,@submitTime,@amount,@bagging,1,@orderLinkMan,@orderPhone,@orderAddress,@orderRoomNo,@remo,@CouponMoney,@CouponId,@usetime,@jifen,@youhuiamount,@manjianmoney,@manjianremo,@tablenumber,@tablenumberid)
                         insert into T_OrderDetails(orderCode, DishsesID, dishesName, number, price,Hot,discount,discountprice) values(@orderCode, @DishsesID, @dishesName, @number, @price,@Hot,@discount,@discountprice)
                         
  UPDATE T_OrderInfo SET 
    payamount=ISNULL(amount,0)+" + bagging + @"-ISNULL(youhuiamount,0)-ISNULL(CouponMoney,0)-isnull(manjianmoney,0),
    jiesuanjia=(ISNULL(amount,0)+" + bagging + @"-isnull(manjianmoney,0)-ISNULL(youhuiamount,0))*(100-@yongjin)/100.0  WHERE orderCode=@orderCode 

  UPDATE CouPonContent set IsEmploy=1,EmployTime=GETDATE(),OrderNO=@orderCode  WHERE id=@CouponId
  
 commit transaction
end try
begin catch
 rollback transaction
end catch 
";

            Dictionary<string, DBParam> dic = new Dictionary<string, DBParam>();
            dic.Add("orderCode", new DBParam { ParamValue = ordercode });
            dic.Add("usetime", new DBParam { ParamValue = usetime });
            dic.Add("jifen", new DBParam { ParamValue = jifen });
            dic.Add("youhuiamount", new DBParam { ParamValue = yhamount });
            dic.Add("oreateTime", new DBParam { ParamValue = DateTime.Now.ToString() });
            dic.Add("Status", new DBParam { ParamValue = Convert.ToInt32(EnumOrderStatus.UnPay).ToString() });
            dic.Add("storeID", new DBParam { ParamValue = storeID });
            dic.Add("hotelid", new DBParam { ParamValue = hotelId });

            dic.Add("userweixinid", new DBParam { ParamValue = userweixinid });
            dic.Add("hotelWeixinId", new DBParam { ParamValue = hotelWeixinId });
            dic.Add("submitTime", new DBParam { ParamValue = DateTime.Now.ToString() });
            dic.Add("amount", new DBParam { ParamValue = (number * model.price).ToString() });
            dic.Add("yongjin", new DBParam { ParamValue = yongjin.ToString() });
            dic.Add("bagging", new DBParam { ParamValue = bagging.ToString() });
            //
            dic.Add("orderLinkMan", new DBParam { ParamValue = linkMan });
            dic.Add("orderPhone", new DBParam { ParamValue = linkPhone });
            dic.Add("orderAddress", new DBParam { ParamValue = hotelName });
            dic.Add("orderRoomNo", new DBParam { ParamValue = roomno });
            dic.Add("remo", new DBParam { ParamValue = remo });
            dic.Add("CouponMoney", new DBParam { ParamValue = couponMoney });
            dic.Add("CouponId", new DBParam { ParamValue = couponId });

            dic.Add("DishsesID", new DBParam { ParamValue = model.DishsesID.ToString() });
            dic.Add("dishesName", new DBParam { ParamValue = model.DishsesName });
            dic.Add("number", new DBParam { ParamValue = number.ToString() });
            dic.Add("price", new DBParam { ParamValue = model.price.ToString() });
            dic.Add("Hot", new DBParam { ParamValue = "0" });
            dic.Add("discount", new DBParam { ParamValue = discount.ToString() });
            dic.Add("discountprice", new DBParam { ParamValue = discountprice.ToString() });

            dic.Add("manjianmoney", new DBParam { ParamValue = manjianmoney });
            dic.Add("manjianremo", new DBParam { ParamValue = manjianremo });

            dic.Add("tablenumber", new DBParam { ParamValue = tablenumber });
            dic.Add("tablenumberid", new DBParam { ParamValue = tablenumberid });

            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), dic);

        }

        
        /// <summary>
        /// 检查红包是否已被使用
        /// </summary>
        public static bool CouponIsCanUse(string CouponId)
        {
            int tempId=0;
            int.TryParse(CouponId, out tempId);
            if (tempId > 0)
            {
                string sql = "select top 1 1 from CouPonContent where IsEmploy=0 and id=@CouponId";
                string str = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
                {
                  {"CouponId",new DBParam(){ParamValue=CouponId}}
                });
                return !string.IsNullOrEmpty(str);
            }
            else
            {
                return true;
            }
        }

        /// <summary>
        /// 【新餐饮】保存订单积分信息
        /// </summary>
        /// <param name="orderCode"></param>
        /// <returns></returns>
        public static int InserJeFen(string orderCode) 
        {
            OrderInfo order = GetOrderInfo_A(orderCode);
            if (order.orderId > 0 && decimal.Parse(order.jifen) > 0)
            {
                string UserId = GetMemberID(order.hotelWeixinId, order.userweixinid);
                string cardno = hotel3g.Repository.MemberHelper.GetCardNo(order.userweixinid, order.hotelWeixinId);
                string sql = @" INSERT INTO JiFenDetail(weixinID, userweixinID, JIFen, addTime, Remark, orderId, night, cardno, UserId, status, UseOrderId) 
 VALUES(@weixinID, @userweixinID, @JIFen, @addTime, @Remark, @orderId, @night, @cardno, @UserId, @status, @UseOrderId)";

                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
                {
                  {"weixinID",new DBParam(){ParamValue=order.hotelWeixinId}},
                  {"userweixinID",new DBParam(){ParamValue=order.userweixinid}},
                  {"JIFen",new DBParam(){ParamValue=order.jifen}},
                  {"addTime",new DBParam(){ParamValue=DateTime.Now.ToString()}},
                  {"Remark",new DBParam(){ParamValue="餐饮返积分"}},
                  {"orderId",new DBParam(){ParamValue=order.orderId.ToString()}},
                  {"night",new DBParam(){ParamValue="0"}},
                  {"cardno",new DBParam(){ParamValue=cardno}},
                  {"UserId",new DBParam(){ParamValue=UserId}},
                  {"status",new DBParam(){ParamValue="0"}},
                  {"UseOrderId",new DBParam(){ParamValue=order.orderCode}},
                });

            }

            return 0;
        }

        public static string GetMemberID(string weixinid,string userweixinid) 
        {
            string sql = "select top 1 Id from Member where weixinID=@weixinID and userWeiXinNO=@userweixinID";
            return SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
                {
                  {"weixinID",new DBParam(){ParamValue=weixinid}},
                  {"userweixinID",new DBParam(){ParamValue=userweixinid}}
                });
        }
    }


    /// <summary>
    /// 商家
    /// </summary>
    public class Stores
    {
        public int StoreId { get; set; }
        public string StoreName { get; set; }
        public string StoreNickName { get; set; }
        public string StoreAddress { get; set; }
        public string StorePhone { get; set; }
        public string BeginTime { get; set; }
        public decimal bagging { get; set; }
        public string EndTime { get; set; }
        public string StoreDesc { get; set; }
        public string jingdu { get; set; }
        public string weidu { get; set; }
        public string juli { get; set; }
        public string fenzhong { get; set; }
        public decimal Minprice { get; set; }
        public string Logoimg { get; set; }
        public string YouhuiIDs { get; set; }
        /// <summary>
        /// 是否周边，1周边
        /// </summary>
        public int Isaround { get; set; }
        /// <summary>
        /// 预计送达时间
        /// </summary>
        public string yujisongdashijian { get; set; }
        
        /// <summary>
        /// 1未启用
        /// </summary>
        public int state { get; set; }
        public int hotelid { get; set; }
        public string weixinid { get; set; }

        /// <summary>
        /// 佣金点数
        /// </summary>
        public int yongjin { get; set; }


        //餐厅信息     //IsDiningRoom,Foods,Require,BusinessBeginTime,BusinessEndTime
        /// <summary>
        /// 1 开启订位服务，0不开启
        /// </summary>
        public int IsDiningRoom { get; set; }
        /// <summary>
        /// 经营项目
        /// </summary>
        public string Foods { get; set; }
        public string Require { get; set; }
        public string BusinessBeginTime { get; set; }
        public string BusinessEndTime { get; set; }

        /// <summary>
        /// 1 显示订单提示，0 隐藏订单提示
        /// </summary>
        public int showordertips { get; set; }
        /// <summary>
        /// 订单提示信息
        /// </summary>
        public string ordertips { get; set; }

        /// <summary>
        /// 商家类型 [餐饮=0]
        /// </summary>
        public int storetype { get; set; }

        /// <summary>
        /// 商家餐饮地址设置 0开启，1不开启
        /// </summary>
        public int openaddress { get; set; }

        /// <summary>
        /// 是否堂食 1是，0否
        /// </summary>
        public int eatatstore { get; set; }

    }

    public class StoresView : Stores
    {
        public decimal UsedMoney { get; set; }
        public decimal DelMoney { get; set; }
        public string Remo { get; set; }
        /// <summary>
        /// 根据经纬度计算的距离
        /// </summary>
        public decimal juli1 { get; set; }
    }

    public class Youhui
    {
        public int YouhuiID { get; set; }
        public decimal UsedMoney { get; set; }
        public decimal DelMoney { get; set; }
        public string Remo { get; set; }
    }

    /// <summary>
    /// 菜品
    /// </summary>
    public class Dishses
    {
        public int DishsesID { get; set; }
        public int DishesTypeID { get; set; }
        public string DishsesName { get; set; }
        public string DishsesDesc { get; set; }
        public string DishesImg { get; set; }
        public decimal price { get; set; }
        /// <summary>
        /// Status=1 表示未售菜品
        /// </summary>
        public int Status { get; set; }
        /// <summary>
        /// 是否显示辣选择
        /// </summary>
        public int ShowHot { get; set; }
        
        //UseRichText, ITDescribe, Notice, CanDiscount, CanCouPon, ImgList
        /// <summary>
        /// 1图文模式， 0 简单模式
        /// </summary>
        public int UseRichText { get; set; }
        public string ITDescribe { get; set; }
        public string Notice { get; set; }
        /// <summary>
        /// 可使用折扣
        /// </summary>
        public int CanDiscount { get; set; }
        /// <summary>
        /// 可使用红包
        /// </summary>
        public int CanCouPon { get; set; }
        /// <summary>
        /// 图片url串 ‘,’分割
        /// </summary>
        public string ImgList { get; set; }
    }

    public class OrderAddress
    {
        public int AddressID { get; set; }
        public string LinkMan { get; set; }
        public string LinkPhone { get; set; }
        public string Address { get; set; }
        public string RoomNo { get; set; }
        public bool isSelected { get; set; }
        public string userweixinid { get; set; }

        public int addressType { get; set; }
        public string kuaidiAddress { get; set; }
    }

    public class OrderDetails
    {
        public int DishsesID { get; set; }
        public string DishesName { get; set; }
        /// <summary>
        /// 单个菜品总金额
        /// </summary>
        public decimal totalPrice { get; set; }
        public int Number { get; set; }
        /// <summary>
        /// 菜品单价
        /// </summary>
        public decimal Price { get; set; }
        /// <summary>
        /// 订单总金额
        /// </summary>
        public decimal SumPrice { get; set; }
        /// <summary>
        /// 订单折后总金额
        /// </summary>
        public decimal disSumPrice { get; set; }
        /// <summary>
        /// 订单菜品总数量
        /// </summary>
        public int SumNum { get; set; }
        public string orderCode { get; set; }
        /// <summary>
        /// 小中大辣 123(如无则取Dishses中的hot)
        /// </summary>
        public int Hot { get; set; }
    }

    //orderId, orderCode, amount, orderAddress, orderPhone, orderPayType, orderPayState, 
    //oreateTime, Status, storeID, userNumber, remo, AddressID, hotelid, userweixinid
    /// <summary>
    /// 订单信息
    /// </summary>
    public class OrderInfo 
    {
        public int orderId { get; set; }
        public string orderCode { get; set; }
        /// <summary>
        /// 订单金额（1.未减去优惠金额的订单金额,如有优惠金额；2.未加上打包费用,如有打包费用）
        /// </summary>
        public decimal amount { get; set; }
        public decimal youhuiamount { get; set; }
        /// <summary>
        /// 打包费
        /// </summary>
        public decimal bagging { get; set; }
        /// <summary>
        /// 酒店名称
        /// </summary>
        public string orderAddress { get; set; }
        /// <summary>
        /// 订单联系人电话
        /// </summary>
        public string orderPhone { get; set; }
        public string orderPayType { get; set; }
        public string orderPayState { get; set; }
        public DateTime oreateTime { get; set; }

        public int Status { get; set; }
        public int storeID { get; set; }
        public int userNumber { get; set; }
        public string remo { get; set; }
        public int AddressID { get; set; }
        public int hotelid { get; set; }
        public string hotelWeixinId { get; set; }
        public string userweixinid { get; set; }

        public DateTime submitTime { get; set; }
        public DateTime payTime { get; set; }
        /// <summary>
        /// 订单联系人名称
        /// </summary>
        public string orderLinkMan { get; set; }
        /// <summary>
        /// 酒店房间
        /// </summary>
        public string orderRoomNo { get; set; }
        /// <summary>
        /// 订单最后支付金额
        /// </summary>
        public decimal payamount { get; set; }
        /// <summary>
        /// 预计送达时间分钟
        /// </summary>
        public string willArriveTime { get; set; }

        public decimal CouponMoney { get; set; }
        public string CouponId { get; set; }
        /// <summary>
        /// 预计用餐时间
        /// </summary>
        public string usetime { get; set; }
        public string jifen { get; set; }

        public decimal manjianmoney { get; set; }
        public string manjianremo { get; set; }
        /// <summary>
        /// 每日已支付订单序号 V123...
        /// </summary>
        public string xuhao { get; set; }

        public string tablenumber { get; set; }
        public int tablenumberid{ get; set; }
    }

    /// <summary>
    /// 点评
    /// </summary>
    public class EntityDianPing 
    {
        public int DianPingID { get; set; }
        /// <summary>
        /// 商家id
        /// </summary>
        public int StoreId { get; set; }
        /// <summary>
        /// 订单编号
        /// </summary>
        public string orderCode { get; set; }
        /// <summary>
        /// 用户微信id
        /// </summary>
        public string userweixinID { get; set; }
        /// <summary>
        /// 点评内容
        /// </summary>
        public string Context { get; set; }
        /// <summary>
        /// 与描述相符？颗星
        /// </summary>
        public int MiaoShuStar { get; set; }
        /// <summary>
        /// 服务态度？颗星
        /// </summary>
        public int TaiDuStar { get; set; }
        /// <summary>
        /// 评论时间
        /// </summary>
        public DateTime createTime { get; set; }
        /// <summary>
        /// 评论图片url
        /// </summary>
        public string imgurl { get; set; }



        /// <summary>
        /// 保存点评返回最新id
        /// </summary>
        /// <returns></returns>
        public static string Save(EntityDianPing model) 
        {
            string sql = @"insert into T_DianPing(StoreId, orderCode, userweixinID, Context,MiaoShuStar,TaiDuStar,createTime,imgurl) 
                                           values(@StoreId,@orderCode,@userweixinID,@Context,@MiaoShuStar,@TaiDuStar,@createTime,@imgurl) SELECT @@IDENTITY AS ID ;";
            return SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                {"StoreId",new DBParam(){ParamValue=model.StoreId.ToString()}},
                {"orderCode",new DBParam(){ParamValue=model.orderCode}},
                {"userweixinID",new DBParam(){ParamValue=model.userweixinID}},
                {"Context",new DBParam(){ParamValue=model.Context}},
                {"MiaoShuStar",new DBParam(){ParamValue=model.MiaoShuStar.ToString()}},
                {"TaiDuStar",new DBParam(){ParamValue=model.TaiDuStar.ToString()}},
                {"createTime",new DBParam(){ParamValue=DateTime.Now.ToString()}},
                {"imgurl",new DBParam(){ParamValue=model.imgurl}}
            });
        }
    }

    /// <summary>
    /// 餐厅
    /// </summary>
    public class DiningRoom 
    {
        public int DiningRoomID { get; set; }
        public string DiningRoomName { get; set; }
        public string DiningRoomFoods { get; set; }
        public string DiningRoomPhone { get; set; }
        public string DiningRoomRequire { get; set; }
        public string DiningRoomBeginTime { get; set; }
        public string DiningRoomEndTime { get; set; }
        public string DiningRoomLogoImg { get; set; }
        public string DiningRoomDesc { get; set; }
        public string DiningRoomAddress { get; set; }
        public int IsSelf { get; set; }
        public string hotelId { get; set; }
        public string weixinid { get; set; }
        
    }

    /// <summary>
    /// 预订餐厅订单
    /// </summary>
    public class DiningRoomOrder
    {
        public int DROrderID { get; set; }
        public int DiningRoomID { get; set; }
        public string DROrderCode { get; set; }
        public string DiningRoomName { get; set; }
        public int UseNuber { get; set; }
        public string UseDate { get; set; }
        public string UseTime { get; set; }
        public string LinkMan { get; set; }
        /// <summary>
        /// 先生/女士
        /// </summary>
        public string Sex { get; set; }
        public string LinkPhone { get; set; }
        public string Beizhu { get; set; }
        public string CreateTime { get; set; }
        /// <summary>
        ///  1,完成  -1.取消
        /// </summary>
        public int State { get; set; }
        public string hotelName { get; set; }
        public string hotelId { get; set; }
        public string hotelweixinid { get; set; }
        public string userweixinid { get; set; }

    }

    #region  餐台管理

    /// <summary>
    /// 商家桌台区域
    /// </summary>
    public class StoreTableArea
    {
        //id, areaname, hotelweixinid, storeid, sortindex, createTime
        public int id { get; set; }
        /// <summary>
        /// 区域名称
        /// </summary>
        public string areaname { get; set; }
        public string hotelweixinid { get; set; }
        public int storeid { get; set; }
        public int sortindex { get; set; }
        public DateTime createTime { get; set; }
        
    }

    /// <summary>
    /// 商家桌台
    /// </summary>
    public class StoreTables
    {
        //id, areaid, hotelweixinid, storeid, tablename, sortindex, createTime
        public int id { get; set; }
        public int areaid { get; set; }
        public string areaname { get; set; }
        /// <summary>
        /// 桌台号
        /// </summary>
        public string tablename { get; set; }
        public string hotelweixinid { get; set; }
        public int storeid { get; set; }
        public int sortindex { get; set; }
        public DateTime createTime { get; set; }

    }

    #endregion


    #region  餐饮枚举
    /// <summary>
    /// 订单状态枚举
    /// </summary>
    public enum EnumOrderStatus
    {
        /// <summary>
        /// 新添加，未提交支付(只选了菜品)
        /// </summary>
        UnSubmit = 0,

        /// <summary>
        /// 已提交，待支付
        /// </summary>
        UnPay = 1,

        /// <summary>
        /// 订单支付超时 [ps:0414前是2， 0414后超时改为取消状态3]
        /// </summary>
        IsOverTime = 3,//0414前是2， 现超时改为取消状态

        /// <summary>
        /// 取消订单
        /// </summary>
        IsCancel = 3,

        /// <summary>
        /// 已经支付
        /// </summary>
        IsPay = 9,
        /// <summary>
        /// 已确认
        /// </summary>
        IsSure = 10,
        /// <summary>
        /// 拒单/退款
        /// </summary>
        JudanTuikuan = 11,
        /// <summary>
        /// 酒店取消确认过的订单
        /// </summary>
        IsBossCancel = 13,
        /// <summary>
        /// 订单完成(确认收货)交易成功
        /// </summary>
        IsFinish = 14,
        /// <summary>
        /// 配送中
        /// </summary>
        IsPeiSongZhong=15
    }

    /// <summary>
    /// 支付状态, 
    /// </summary>
    public enum EnumOrderPayStatus 
    {
        未支付 = 0,
        支付成功 = 1,
    }
    /// <summary>
    /// 退款状态枚举
    /// </summary>
    public enum EnumRefundStauts 
    {
        /// <summary>
        /// 提交申请
        /// </summary>
        SubmitApply=1,
        /// <summary>
        /// 审核通过
        /// </summary>
        AuditCross=2,
        /// <summary>
        /// 拒绝申请
        /// </summary>
        RejectApply=3

    }
    
    /// <summary>
    /// 商家周边/自营/默认 枚举
    /// </summary>
    public enum EnumStoreType
    {
        /// <summary>
        /// 默认商家0
        /// </summary>
        IsDefault = 0,
        /// <summary>
        ///周边商家1
        /// </summary>
        IsAround = 1,
        /// <summary>
        /// 自营2
        /// </summary>
        IsSelfSale = 2,
        /// <summary>
        /// 所有-1
        /// </summary>
        IsAll = -1
    }

    /// <summary>
    /// 商家地址设置 
    /// </summary>
    public enum EnumStoreOpenAddress
    {
        /// <summary>
        /// 下单时需填姓名电话地址信息
        /// </summary>
        开启 = 0,
        /// <summary>
        /// 下单时需填写姓名电话信息
        /// </summary>
        关闭 = 1,
    }

    /// <summary>
    /// 商家外卖或堂食设置 
    /// </summary>
    public enum EnumEatAtStore
    {
        /// <summary>
        /// 不堂食，下单时需要根据地址设置填写信息
        /// </summary>
        外卖 = 0,
        /// <summary>
        /// 堂食，下单时只需要填写桌台号
        /// </summary>
        堂食 = 1,
    }

    /// <summary>
    /// 是否扫描进入带桌号参数 
    /// </summary>
    public enum EnumFromScan
    {
        /// <summary>
        /// 不是来自扫码点餐走正常流程，桌号id参数=0
        /// </summary>
        非扫码 = 0,
    }

    #endregion

    #region  餐厅订单枚举

    /// <summary>
    /// 餐厅订单枚举, 
    /// </summary>
    public enum EnumDiningRoomOrderStatus
    {
        待跟进 = 1,
        取消=2,
        跟进中 = 6,
        跟进完成=9
    }

    #endregion
    /// <summary>
    /// 扩展方法
    /// </summary>
    public static class DataExtensions
    {
        public static T ToModel<T>(this DataRow dr) where T : class, new()
        {
            return GetModel<T>(dr, true);
        }
        public static T ToModel<T>(this DataRowView row) where T : class, new()
        {
            return GetModel<T>(row.Row, true);
        }
        public static T ToModel<T>(this DataRow dr, bool dateTimeToString) where T : class, new()
        {
            if (dr != null)
                return GetModel<T>(dr, dateTimeToString);
            return null;
        }

        private static T GetModel<T>(DataRow dr, bool dateTimeToString) where T : class, new()
        {
            List<PropertyInfo> infos = typeof(T).GetProperties().ToList();
            T model = new T();
            foreach (PropertyInfo p in infos)
            {
                if (dr.Table.Columns.Contains(p.Name))
                {
                    if (dr[p.Name] != DBNull.Value)
                    {
                        object tempValue = dr[p.Name];
                        if (dr[p.Name].GetType() == typeof(DateTime) && p.PropertyType == typeof(string) && dateTimeToString == true)
                        {
                            tempValue = dr[p.Name].ToString();
                        }
                        try
                        {
                            p.SetValue(model, tempValue, null);
                        }
                        catch
                        {
                        }
                    }
                }
            }
            return model;
        }
    }
}