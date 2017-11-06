using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
namespace hotel3g.Models
{
    public class User
    {
        public static System.Data.DataTable GetUserInfo(string weixinID, string userweixinID)
        {
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select top 1 * from member where weixinID=@weixinID and userWeixinNO=@userweixinID", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
            {"userweixinID",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinID}}
            });
            return dt;
        }

        public static int GetCouPonMoneys(string weixinID, string userweixinID)
        {
            var value = HotelCloud.SqlServer.SQLHelper.Get_Value("select isnull(SUM(moneys),0) as emoney from  CouPonContent where weixinID=@weixinID and userweixinNo=@userweixinNO and GETDATE() between sTime and ExtTime and IsEmploy=0", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
            {"userweixinNO",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinID}}
            });
            return Convert.ToInt32(value);
        }

        public static System.Data.DataTable GetMyJiFens(string weixinID, string userweixinID)
        {
            var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select * from jifendetail where weixinID=@weixinID and userweixinID=@userweixinID order by id desc", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {
                {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
                {"userweixinID",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinID}}
            }); return dt;
        }

        public static System.Data.DataTable GetMyCouPons(string weixinID, string userweixinID)
        {
            string sql = "select * from couponContent where weixinID=@weixinID and userweixinNO=@userweixinID order by id desc";
             sql = @"select *,b.scopelimit,b.amountlimit from couponContent AS a WITH(NOLOCK)
LEFT JOIN dbo.CouPon AS b WITH(NOLOCK) ON a.typeID=b.id
 where a.weixinID=@weixinID and a.userweixinNO=@userweixinID order by a.id desc";

             var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
            {"userweixinID",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinID}}
            });
            return dt;
        }

        public static System.Data.DataTable GetMyWard(string weixinID, string userweixinID)
        {
            string sql = "select * from PrizeInfo where weixinID=@weixinID and Userweixinno=@userweixinno and PrizeLevel<11 order by id desc";
            var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
            {"userweixinno",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinID}}
            });
            return dt;
        }

        public static System.Data.DataTable GetMyOrders(string weixinID, string userweixinID)
        {
            var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select * from hotelorder where weixinID=@weixinID and userweixinID=@userweixinID order by id desc", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
            {"userweixinID",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinID}}
            });
            return dt;
        }
        public static System.Data.DataTable GetUserOrders(string weixinID, string userweixinID,bool IsLogin)
        {
            string where = string.Empty;
            if (!IsLogin)
            {
              where += string.Format(" AND H.UserID=0");
            }
            string sql = string.Format(@"select H.id,H.OrderNO,H.RoomName,H.yinDate,H.youtDate,H.sSumPrice,T.url,H.state,H.paytype,H.Ordertime,H.UserID,H.yRoomNum,H.HotelName from hotelorder as H WITH(NOLOCK) left join RoomTypeImg as T WITH(NOLOCK) on T.roomid=H.RoomID where weixinID=@weixinID and userweixinID=@userweixinID 
{0}
 order by H.id desc",where);
            var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
            {"userweixinID",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinID}}
            });

            #region 去重复
            DataTable newdatatable = new DataTable();
            newdatatable.Columns.Add("id", Type.GetType("System.String"));
            newdatatable.Columns.Add("OrderNO", Type.GetType("System.String"));
            newdatatable.Columns.Add("RoomName", Type.GetType("System.String"));
            newdatatable.Columns.Add("yinDate", Type.GetType("System.String"));
            newdatatable.Columns.Add("youtDate", Type.GetType("System.String"));
            newdatatable.Columns.Add("sSumPrice", Type.GetType("System.String"));
            newdatatable.Columns.Add("url", Type.GetType("System.String"));
            newdatatable.Columns.Add("state", Type.GetType("System.String"));
            newdatatable.Columns.Add("paytype", Type.GetType("System.String"));
            newdatatable.Columns.Add("Ordertime", Type.GetType("System.String"));
            newdatatable.Columns.Add("UserID", Type.GetType("System.String"));
            newdatatable.Columns.Add("yRoomNum", Type.GetType("System.String"));
            newdatatable.Columns.Add("HotelName", Type.GetType("System.String"));
            foreach (DataRow row in dt.Rows) {
               DataRow[] rows = newdatatable.Select(string.Format(" id={0} and OrderNO='{1}'", row["id"].ToString(), row["OrderNO"].ToString()));
               if (rows.Length == 0) {
                   DataRow rw = newdatatable.NewRow();
                   rw["id"] = row["id"].ToString();
                   rw["OrderNO"] = row["OrderNO"].ToString();
                   rw["RoomName"] = row["RoomName"].ToString();
                   rw["yinDate"] = row["yinDate"].ToString();
                   rw["youtDate"] = row["youtDate"].ToString();
                   rw["sSumPrice"] = row["sSumPrice"].ToString();

                   rw["url"] = row["url"].ToString();
                   rw["state"] = row["state"].ToString();
                   rw["paytype"] = row["paytype"].ToString();
                   rw["Ordertime"] = row["Ordertime"].ToString();
                   rw["UserID"] = row["UserID"].ToString();
                   rw["yRoomNum"] = row["yRoomNum"].ToString();
                   rw["HotelName"] = row["HotelName"].ToString();
                   newdatatable.Rows.Add(rw);
               }
            }


            return newdatatable;
            #endregion
        }

        public static List<hotel3g.Common.OrderInfoItem> GetUserOrders(string weixinID, string userweixinID, int page,int state)
        {
            int row = page > 0 ? page*5 : 0;
            Dictionary<string, HotelCloud.SqlServer.DBParam> Dic = new Dictionary<string, HotelCloud.SqlServer.DBParam>();
            Dic.Add("row", new HotelCloud.SqlServer.DBParam { ParamValue = row.ToString()});
            Dic.Add("weixinID", new HotelCloud.SqlServer.DBParam { ParamValue =weixinID });
            Dic.Add("userweixinID", new HotelCloud.SqlServer.DBParam { ParamValue = userweixinID });
            string where1 = string.Empty;
            string where2 = string.Empty;
            if (state > 0) {
                switch (state) {
                    case 1:
                        where2 = " AND IsPay=1";
                        where1 = " AND [state]=9";
                        break;
                    case 2:
                        where2 += " AND OrderStatus=0";
                        where1 += " AND State=1";
                        break;
                    case 3:
                        where2 = " AND IsPay=1 AND HexiaoStatus=3";
                        where1 = " AND State=61 AND (CHARINDEX('支付成功通知-金额',Remark)>0 OR tradeStatus='TRADE_FINISHED')";
                        break;
                }
            }
            string sql =string.Format(@"
SELECT top 5 * FROM (
SELECT ROW_NUMBER() OVER(ORDER BY t.Ordertime DESC) AS row,* FROM (
--酒店订单
SELECT 0 AS channel,id,OrderNO,RoomName,CONVERT(varchar(10),yinDate,23) as yinDate,CONVERT(varchar(10),youtDate,23) as youtDate,sSumPrice,state as State,paytype as PayType,Ordertime,UserID,yRoomNum,HotelName,
DATEDIFF(day,yinDate,youtDate) AS [days],ySumPrice,0 IsPay,0 HeXiaoState,tradeStatus,Remark,0 ProductType,ishourroom,CONVERT(VARCHAR(100),hourstarttime) as hourstarttime,CONVERT(VARCHAR(100),hourendtime) as hourendtime,fpsubmitprice,0 as storeID,lastTime,isnull(isMeeting,0)isMeeting FROM dbo.HotelOrder WITH(NOLOCK)  WHERE WeiXinID=@weixinID AND UserWeiXinID=@userweixinID 
{0}
UNION ALL
--团购订单
SELECT 1,Id,OrderNO,TcName,CONVERT(varchar(10),CheckInTime,23),CONVERT(varchar(10),CheckOutTime,23),OrderMoney,OrderStatus,0,OrderAddTime,0,BookingCount,ProductName,DATEDIFF(day,CheckInTime,CheckOutTime),OrderMoney,IsPay,HexiaoStatus,'','',ProductType,0,'','',0,0,'',0 FROM dbo.SaleProducts_Orders WITH(NOLOCK) WHERE HotelWeiXinId
 =@weixinID AND UserWeiXinID=@userweixinID 
{1}
UNION ALL
--餐饮订单
SELECT 2,a.orderId,a.orderCode,(a.orderAddress+' '+a.orderRoomNo),CONVERT(varchar(10),payTime,23),CONVERT(varchar(10),payTime,23),payamount,Status,0,submitTime,0,
(SELECT TOP 1 number from dbo.T_OrderDetails WITH(NOLOCK) WHERE orderCode=a.orderCode )   AS number,
(SELECT TOP 1 dishesName from dbo.T_OrderDetails WITH(NOLOCK) WHERE orderCode=a.orderCode ) AS dishesName,

1,amount,orderPayState,0,'','',0AS ProductType,0,'','',0,a.storeID,'',0
FROM dbo.T_OrderInfo AS a WITH(NOLOCK)
 WHERE isnull(Status,0)>0 AND
 hotelWeixinId =@weixinID AND 
 UserWeiXinID=@userweixinID 

UNION ALL
--超市订单
SELECT 3 AS channel,a.id,a.OrderId AS OrderNo,C.Name,CONVERT(VARCHAR(10),a.CreateTime,23) AS yindate,CONVERT(VARCHAR(10),a.CreateTime,23) AS youtdate,
CONVERT(DECIMAL, [Money]) AS sSumPrice,a.OrderStatus,1,a.CreateTime AS OrderTime,0,s.total,Address,0 AS [days],CONVERT(DECIMAL, [Money]) AS ySumPrice,'', 0,'',Remark,0 producttype,0 ishourroom,'','' ,0,0 AS storeID,'',0
 FROM dbo.SupermarketOrder_Levi AS a WITH(NOLOCK)
LEFT JOIN
(SELECT MAX(CommodityId) AS CommodityId,OrderId FROM  dbo.SupermarketOrderDetail_Levi WITH(NOLOCK)GROUP BY OrderId)
AS b ON a.OrderId = b.OrderId 
LEFT JOIN dbo.Commodity_Levi AS c WITH(NOLOCK) ON c.id=b.CommodityId 
left join SupermarketOrderDetail_Levi  s with(nolock)   on s.OrderId=b.OrderId and s.CommodityId=b.CommodityId 
WHERE a.weixinID=@weixinID AND  userweixinID=@userweixinID 
AND b.CommodityId>0

 )AS t
 )AS tb WHERE tb.row>@row", where1, where2);
            
DataTable dt=HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql,HotelCloud.SqlServer.SQLHelper.GetCon(),Dic);
            List<hotel3g.Common.OrderInfoItem> OrderList = dt.ToList<hotel3g.Common.OrderInfoItem>();

          return OrderList;
        }


        public static int UpdateInfo(string weixinID, string userweixinID, string email, string mobile, string sex, string name)
        {
            int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@"update member set email=@email,mobile=@mobile,sex=@sex,name=@name where weixinID=@weixinID and userWeiXinNO=@userweixinNO", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"email",new HotelCloud.SqlServer.DBParam{ParamValue=email}},
            {"mobile",new HotelCloud.SqlServer.DBParam{ParamValue=mobile}},
            {"sex",new HotelCloud.SqlServer.DBParam{ParamValue=sex}},
            {"name",new HotelCloud.SqlServer.DBParam{ParamValue=name}},
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
            {"userweixinNO",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinID}}
            });
            return row;
        }

    }
}