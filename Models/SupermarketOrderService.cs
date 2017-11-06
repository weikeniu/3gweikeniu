using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using HotelCloud.SqlServer;
using hotel3g.Repository;
using hotel3g.Common;

namespace hotel3g.Models
{
    public class SupermarketOrderService
    {
        /// <summary>
        /// 根据订单ID获取数据
        /// </summary>
        /// <param name="orderId"></param>
        /// <returns></returns>
        public DataTable GetDataByOrderId(string orderId)
        {
            string sql = @"select OrderId, weixinID, HotelId, userweixinID, Money, PayMethod, PayStatus,OrderStatus,Remark,Linkman,LinkPhone,AddressType,Address,CreateTime,EndTime,DelayedTake, ExpressFee,ExpressCompany,ExpressNo,CanPurchase,PurchasePoints,ISNULL(Refundfee,0) as Refundfee,ISNULL(CardRefundfee,0) as CardRefundfee,CouponMoney,CouponId,ISNULL(promoterid,'0') as promoterid, fxmoney, fxmoneyProfit from SupermarketOrder_Levi t where t.OrderId=@OrderId";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"OrderId",new DBParam(){ParamValue=orderId}}
                    });

            return dt;
        }

        /// <summary>
        /// 订单表、订单详细表插入数据
        /// </summary>
        /// <param name="weixinID"></param>
        /// <param name="userweixinID"></param>
        /// <param name="hotelId"></param>
        /// <param name="remark"></param>
        /// <param name="LinkMan"></param>
        /// <param name="LinkPhone"></param>
        /// <param name="AddressType"></param>
        /// <param name="Address"></param>
        /// <returns></returns>
        public string InsertOrder(string weixinID, string userweixinID, string hotelId, string remark, string LinkMan, string LinkPhone, string AddressType, string Address, string ExpressFee, string CouponId, string CouponMoney)
        {

            ShoppingCartService cartService = new ShoppingCartService();
            CommodityService commodityService = new CommodityService();
            //计算订单总金额
            var shoppingCarDataTable = cartService.GetDataByUserId(hotelId, userweixinID);
            double sum = 0;
            int needPoints = 0;
            int canPoints = 1;

            if (shoppingCarDataTable.Rows.Count > 0)
            {
                lock (this)
                {
                    string orderid = "D" + DateTime.Now.ToString("yyMMddHHmmss") + new Random().Next(100, 0x3e7);
                    string sql = @"INSERT INTO [WeiXin].[dbo].[SupermarketOrderDetail_Levi]
                               ([OrderId]
                               ,[weixinID]
                               ,[HotelId]
                               ,[CommodityId]
                               ,[Total]
                               ,[Name]
                               ,[ImagePath]
                               ,[ImageList]
                               ,[Price]
                               ,[PurchasePoints]
                               ,[CanPurchase]
                                )
                         VALUES
                               (@OrderId
                               ,@weixinID
                               ,@HotelId
                               ,@CommodityId
                               ,@Total
                               ,@Name
                               ,@ImagePath
                               ,@ImageList
                               ,@Price
                               ,@PurchasePoints
                               ,@CanPurchase
                                )";

                    foreach (DataRow data in shoppingCarDataTable.Rows)
                    {

                        SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"OrderId",new DBParam(){ParamValue=orderid}},
                        {"weixinID",new DBParam(){ParamValue=weixinID}},
                        {"HotelId",new DBParam(){ParamValue=hotelId}},
                        {"CommodityId",new DBParam(){ParamValue=data["CommodityId"].ToString()}},
                        {"Total",new DBParam(){ParamValue=data["Total"].ToString()}},
                        {"Name",new DBParam(){ParamValue=data["Name"].ToString()}},
                        {"ImagePath",new DBParam(){ParamValue=data["ImagePath"].ToString()}},
                        {"ImageList",new DBParam(){ParamValue=data["ImageList"].ToString()}},
                        {"Price",new DBParam(){ParamValue=data["Price"].ToString()}},
                        {"PurchasePoints",new DBParam(){ParamValue=data["PurchasePoints"].ToString()}},
                        {"CanPurchase",new DBParam(){ParamValue=data["CanPurchase"].ToString()}}
                    });
                        //减少库存
                        int isTrue = commodityService.ReduceStock(data["CommodityId"].ToString(), int.Parse(data["Total"].ToString()));
                        if (isTrue == 0)
                            return "";
                        //计算总金额
                        sum += double.Parse(data["Price"].ToString()) * int.Parse(data["Total"].ToString());
                        if (int.Parse(data["CanPurchase"].ToString()) == 0)
                        {
                            canPoints = 0;
                        }
                        else
                        {
                            needPoints += int.Parse(data["PurchasePoints"].ToString()) * int.Parse(data["Total"].ToString());
                        }
                    }

                    sum += double.Parse(ExpressFee);
                    if (!string.IsNullOrWhiteSpace(CouponId))
                    {
                        sum -= double.Parse(CouponMoney);
                        var coupon = new CouPon();
                        int couponUpate = coupon.UpdateCouponEmploy(CouponId, orderid);
                        if (couponUpate == 0)
                            return "";
                    }
                    int insert = InsertOrderToDB(orderid, weixinID, userweixinID, hotelId, sum, remark, LinkMan, LinkPhone, AddressType, Address, ExpressFee, canPoints.ToString(), needPoints.ToString(), CouponId, CouponMoney);
                    if (insert == 0)
                        return "";

                    return orderid;
                }
            }
            else
            {
                return "";
            }
        }

        /// <summary>
        /// 订单表、订单详细表插入数据
        /// </summary>
        /// <param name="weixinID"></param>
        /// <param name="userweixinID"></param>
        /// <param name="hotelId"></param>
        /// <param name="remark"></param>
        /// <param name="LinkMan"></param>
        /// <param name="LinkPhone"></param>
        /// <param name="AddressType"></param>
        /// <param name="Address"></param>
        /// <returns></returns>
        public string InsertOrderAlone(string weixinID, string userweixinID, string hotelId, string remark, string LinkMan, string LinkPhone, string AddressType, string Address, string ExpressFee, string CouponId, string CouponMoney, string commodityId, string commodityNum, string OrderSource)
        {

            ShoppingCartService cartService = new ShoppingCartService();
            CommodityService commodityService = new CommodityService();
            //计算订单总金额
            //var shoppingCarDataTable = cartService.GetDataByUserId(hotelId, userweixinID);
            var shoppingCarDataTable = CommodityService.GetDataById(commodityId);
            double sum = 0;
            int needPoints = 0;
            int canPoints = 1;

            if (shoppingCarDataTable.Rows.Count > 0)
            {
                lock (this)
                {
                    string orderid = "D" + DateTime.Now.ToString("yyMMddHHmmss") + new Random().Next(100, 0x3e7);
                    //                    string sql = @"INSERT INTO [WeiXin].[dbo].[SupermarketOrderDetail_Levi]
                    //                               ([OrderId]
                    //                               ,[weixinID]
                    //                               ,[HotelId]
                    //                               ,[CommodityId]
                    //                               ,[Total])
                    //                         VALUES
                    //                               (@OrderId
                    //                               ,@weixinID
                    //                               ,@HotelId
                    //                               ,@CommodityId
                    //                               ,@Total)";
                    string sql = @"INSERT INTO [WeiXin].[dbo].[SupermarketOrderDetail_Levi]
                               ([OrderId]
                               ,[weixinID]
                               ,[HotelId]
                               ,[CommodityId]
                               ,[Total]
                               ,[Name]
                               ,[ImagePath]
                               ,[ImageList]
                               ,[Price]
                               ,[PurchasePoints]
                               ,[CanPurchase]
                                )
                         VALUES
                               (@OrderId
                               ,@weixinID
                               ,@HotelId
                               ,@CommodityId
                               ,@Total
                               ,@Name
                               ,@ImagePath
                               ,@ImageList
                               ,@Price
                               ,@PurchasePoints
                               ,@CanPurchase
                                )";

                    foreach (DataRow data in shoppingCarDataTable.Rows)
                    {

                        //    SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                        //{
                        //    {"OrderId",new DBParam(){ParamValue=orderid}},
                        //    {"weixinID",new DBParam(){ParamValue=weixinID}},
                        //    {"HotelId",new DBParam(){ParamValue=hotelId}},
                        //    {"CommodityId",new DBParam(){ParamValue=commodityId}},
                        //    {"Total",new DBParam(){ParamValue=commodityNum}}
                        //});
                        SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"OrderId",new DBParam(){ParamValue=orderid}},
                        {"weixinID",new DBParam(){ParamValue=weixinID}},
                        {"HotelId",new DBParam(){ParamValue=hotelId}},
                        {"CommodityId",new DBParam(){ParamValue=commodityId}},
                        {"Total",new DBParam(){ParamValue=commodityNum}},
                        {"Name",new DBParam(){ParamValue=data["Name"].ToString()}},
                        {"ImagePath",new DBParam(){ParamValue=data["ImagePath"].ToString()}},
                        {"ImageList",new DBParam(){ParamValue=data["ImageList"].ToString()}},
                        {"Price",new DBParam(){ParamValue=data["Price"].ToString()}},
                        {"PurchasePoints",new DBParam(){ParamValue=data["PurchasePoints"].ToString()}},
                        {"CanPurchase",new DBParam(){ParamValue=data["CanPurchase"].ToString()}}
                    });
                        //减少库存
                        int isTrue = commodityService.ReduceStock(commodityId, int.Parse(commodityNum));
                        if (isTrue == 0)
                            return "";
                        //计算总金额
                        sum += double.Parse(data["Price"].ToString()) * int.Parse(commodityNum);
                        if (int.Parse(data["CanPurchase"].ToString()) == 0)
                        {
                            canPoints = 0;
                        }
                        else
                        {
                            needPoints += int.Parse(data["PurchasePoints"].ToString()) * int.Parse(commodityNum);
                        }
                    }

                    sum += double.Parse(ExpressFee);
                    if (!string.IsNullOrWhiteSpace(CouponId))
                    {
                        sum -= double.Parse(CouponMoney);
                        var coupon = new CouPon();
                        int couponUpate = coupon.UpdateCouponEmploy(CouponId, orderid);
                        if (couponUpate == 0)
                            return "";
                    }
                    int insert = InsertOrderToDB(orderid, weixinID, userweixinID, hotelId, sum, remark, LinkMan, LinkPhone, AddressType, Address, ExpressFee, canPoints.ToString(), needPoints.ToString(), CouponId, CouponMoney, OrderSource);
                    if (insert == 0)
                        return "";

                    return orderid;
                }
            }
            else
            {
                return "";
            }
        }

        public static bool IsInt(string value)
        {
            int IntError = 0;
            return int.TryParse(value, out IntError);

            //return System.Text.RegularExpressions.Regex.IsMatch(value, @"^[+-]?/d*$");
        }

        /// <summary>
        /// 订单表插入数据
        /// </summary>
        /// <param name="orderid"></param>
        /// <param name="weixinID"></param>
        /// <param name="userweixinID"></param>
        /// <param name="hotelId"></param>
        /// <param name="sum"></param>
        /// <param name="remark"></param>
        /// <param name="LinkMan"></param>
        /// <param name="LinkPhone"></param>
        /// <param name="AddressType"></param>
        /// <param name="Address"></param>
        /// <returns></returns>
        public int InsertOrderToDB(string orderid, string weixinID, string userweixinID, string hotelId, double sum, string remark, string LinkMan, string LinkPhone, string AddressType, string Address, string ExpressFee, string CanPurchase, string PurchasePoints, string CouponId, string CouponMoney, string OrderSource="微官网")
        {
            var profitPoint = MemberFxLogic.GetTuiGuangProfit(ProfitType.chaoshi, weixinID, userweixinID, sum - double.Parse(ExpressFee));
            //string shareid = hotel3g.Models.DAL.PromoterDAL.GetShareCookie(weixinID);
            //if (!string.IsNullOrWhiteSpace(shareid) && IsInt(shareid))
            //{
            //    profitPoint.promoterid = int.Parse(shareid);
            //}
            string shareid = "";
            if (userweixinID.IndexOf(hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId) > -1)
            {
                var arr = userweixinID.Split('_');
                if (arr.Length > 1 && IsInt(arr[1]))
                {
                    shareid = arr[1];
                    profitPoint.promoterid = int.Parse(shareid);
                }
            }


            string sql2 = @"INSERT INTO [WeiXin].[dbo].[SupermarketOrder_Levi]
                               ([OrderId]
                               ,[weixinID]
                               ,[HotelId]
                               ,[userweixinID]
                               ,[Money]
                               ,[PayMethod]
                               ,[PayStatus]
                               ,[OrderStatus]
                               ,[Remark]
                               ,[Linkman]
                               ,[LinkPhone]
                               ,[AddressType]
                               ,[Address]
                               ,[ExpressFee]
                               ,[CanPurchase]
                               ,[CouponId]
                               ,[CouponMoney]
                               ,[PurchasePoints]
                               ,[OrderSource]
                               ,[promoterid]
                               ,[fxmoney]
                               ,[fxmoneyProfit]
                               ,[CreateTime])
                         VALUES
                               (@OrderId
                                ,@weixinID
                               ,@HotelId
                               ,@userweixinID
                                ,@Money
                                ,@PayMethod
                                ,@PayStatus
                                ,@OrderStatus
                                ,@Remark
                                ,@Linkman
                                ,@LinkPhone
                                ,@AddressType
                                ,@Address
                                ,@ExpressFee
                                ,@CanPurchase
                                ,@CouponId
                                ,@CouponMoney
                                ,@PurchasePoints
                                ,@OrderSource
                                ,@promoterid
                                ,@fxmoney
                                ,@fxmoneyProfit
                                ,getdate())";

            int insert = SQLHelper.Run_SQL(sql2, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"OrderId",new DBParam(){ParamValue=orderid}},
                        {"weixinID",new DBParam(){ParamValue=weixinID}},
                        {"userweixinID",new DBParam(){ParamValue=userweixinID}},
                        {"HotelId",new DBParam(){ParamValue=hotelId}},
                        {"Money",new DBParam(){ParamValue=sum.ToString()}},
                        {"PayMethod",new DBParam(){ParamValue="微信支付"}},
                        {"PayStatus",new DBParam(){ParamValue="1"}},
                        {"OrderStatus",new DBParam(){ParamValue="1"}},
                        {"Remark",new DBParam(){ParamValue=remark}},
                        {"Linkman",new DBParam(){ParamValue=LinkMan}},
                        {"LinkPhone",new DBParam(){ParamValue=LinkPhone}},
                        {"AddressType",new DBParam(){ParamValue=AddressType}},
                        {"Address",new DBParam(){ParamValue=Address}},
                        {"ExpressFee",new DBParam(){ParamValue=ExpressFee}},
                        {"OrderSource",new DBParam(){ParamValue=OrderSource}},
                        {"CanPurchase",new DBParam(){ParamValue=CanPurchase}},
                        {"CouponId",new DBParam(){ParamValue=CouponId}},
                        {"CouponMoney",new DBParam(){ParamValue=CouponMoney}},
                        {"promoterid",new DBParam(){ParamValue=profitPoint.promoterid.ToString()}},
                        {"fxmoney",new DBParam(){ParamValue=profitPoint.hotelCommission.ToString()}},
                        {"fxmoneyProfit",new DBParam(){ParamValue=profitPoint.userCommission.ToString()}},
                        {"PurchasePoints",new DBParam(){ParamValue=PurchasePoints}}
                    });
            return insert;
        }

        /// <summary>
        /// 取消订单
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public int CancelOrder(string id)
        {
            lock (this)
            {
                string sql = @"Update [WeiXin].[dbo].[SupermarketOrder_Levi] set
                               OrderStatus = 5
                           ,EndTime = getdate()
                           where OrderId=@OrderId;
                          update CouPonContent set IsEmploy = 0 where OrderNO=@OrderId;";

                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"OrderId",new DBParam(){ParamValue=id}}
                    });
            }
        }

        /// <summary>
        /// 返回库存
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public int ReturnCommodity(string commodityId, int total)
        {
            lock (this)
            {
                string sql = @"Update [WeiXin].[dbo].[Commodity_Levi] set
                               Stock = Stock + @Stock
                           where id=@commodityId";

                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"Stock",new DBParam(){ParamValue=total.ToString()}},
                        {"commodityId",new DBParam(){ParamValue=commodityId}}
                    
                    });
            }
        }

        public DataTable ClearShoppingCart(string weixinID, string userweixinID)
        {
            lock (this)
            {
                string sql = "exec ShoppingCartDeleteOverflow @weixinID, @userweixinID";
                DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"weixinID",new DBParam(){ParamValue=weixinID}},
                        {"userweixinID",new DBParam(){ParamValue=userweixinID}}
                    });

                return dt;
            }
        }

        /// <summary>
        /// 延迟收货
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public int DelayedOrder(string id)
        {

            string sql1 = @"select DelayedTake from SupermarketOrder_Levi t where t.OrderId=@OrderId";
            DataTable dt = SQLHelper.Get_DataTable(sql1, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"OrderId",new DBParam(){ParamValue=id}}
                    });

            if (dt.Rows.Count == 0)
                return 0;

            int days = 3;
            if (dt.Rows[0]["DelayedTake"].ToString() != "0" && dt.Rows[0]["DelayedTake"].ToString() != "")
                days = int.Parse(dt.Rows[0]["DelayedTake"].ToString()) + 3;

            lock (this)
            {
                string sql = @"Update [WeiXin].[dbo].[SupermarketOrder_Levi] set
                               DelayedTake = @DelayedTake
                           where OrderId=@OrderId";

                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"DelayedTake",new DBParam(){ParamValue=days.ToString()}},
                        {"OrderId",new DBParam(){ParamValue=id}}
                    });
            }
        }

        public int DeductionPoints(string weixinID, string userweixinID, int needPoints)
        {
            lock (this)
            {
                string sql = @"Update [WeiXin].[dbo].[Member] set
                               Emoney = Emoney - @needPoints
                           where weixinID=@weixinID and userWeiXinNO=@userWeiXinNO and Emoney >= @needPoints";

                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"needPoints",new DBParam(){ParamValue=needPoints.ToString()}},
                        {"weixinID",new DBParam(){ParamValue=weixinID}},
                        {"userWeiXinNO",new DBParam(){ParamValue=userweixinID}}
                    });
            }
        }

        /// <summary>
        /// 订单支付
        /// </summary>
        /// <param name="id"></param>
        /// <param name="PayMethod"></param>
        /// <returns></returns>
        public int PayOrder(string id, string PayMethod)
        {
            lock (this)
            {
                string sql = @"Update [WeiXin].[dbo].[SupermarketOrder_Levi] set
                               PayStatus = 2,
                               OrderStatus = 2
                           ,PayMethod = @PayMethod
                           where OrderId=@OrderId";

                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"OrderId",new DBParam(){ParamValue=id}},
                        {"PayMethod",new DBParam(){ParamValue=PayMethod}}
                    });
            }
        }

        /// <summary>
        /// 确认收货，订单完结
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public int FinishOrder(string id)
        {
            lock (this)
            {
                string sql = @"Update [WeiXin].[dbo].[SupermarketOrder_Levi] set
                               OrderStatus = 4
                           ,EndTime = getdate()
                           where OrderId=@OrderId";

                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"OrderId",new DBParam(){ParamValue=id}}
                    });
            }
        }

        /// <summary>
        /// 创建积分信息
        /// </summary>
        /// <returns></returns>
        public int CreateScore(string weixinID, string userWeiXinID, string orderid)
        {
            MemberInfo Info = MemberHelper.GetMemberInfo(weixinID);

            string cardno = MemberHelper.GetCardNo(userWeiXinID, weixinID);

            if (!string.IsNullOrEmpty(cardno))
            {
                MemberCard MyCard = MemberHelper.GetMemberCard(cardno, weixinID);
                string SupermarketOrderId = "";

                var score = GetScore(ref SupermarketOrderId, Info, cardno, weixinID, orderid);

                string sql2 = "insert into jifendetail (weixinid,userweixinid,jifen,addtime,Remark,orderid,night,cardno,userid) values (@weixinid,@userweixinid,@jifen,@addtime,@Remark,@orderid,@night,@cardno,@userid)";
                int rs = SQLHelper.Run_SQL(sql2, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                        {
                            {"weixinid",new DBParam(){ParamValue=weixinID}},
                            {"userweixinid",new DBParam(){ParamValue=userWeiXinID}},
                            {"jifen",new DBParam(){ParamValue=score.ToString()}},
                            {"addtime",new DBParam(){ParamValue=DateTime.Now.ToString()}},
                            {"orderid",new DBParam(){ParamValue=SupermarketOrderId}},
                            {"Remark",new DBParam(){ParamValue="超市返积分"}},
                            {"night",new DBParam(){ParamValue=(0).ToString()}},
                            {"cardno",new DBParam(){ParamValue=cardno}},
                            {"userid",new DBParam(){ParamValue=MyCard.memberid}},
                        });
                return rs;
            }

            return 0;
        }

        /// <summary>
        /// 使用积分记录
        /// </summary>
        /// <param name="weixinID"></param>
        /// <param name="userWeiXinID"></param>
        /// <param name="orderid"></param>
        /// <returns></returns>
        public int CreateUseScoreLog(string weixinID, string userWeiXinID, string orderid)
        {

            MemberInfo Info = MemberHelper.GetMemberInfo(weixinID);

            string cardno = MemberHelper.GetCardNo(userWeiXinID, weixinID);

            if (!string.IsNullOrEmpty(cardno))
            {
                MemberCard MyCard = MemberHelper.GetMemberCard(cardno, weixinID);
                string SupermarketOrderId = "";

                var score = GetScore(ref SupermarketOrderId, Info, cardno, weixinID, orderid);

                string sql2 = "insert into jifendetail (weixinid,userweixinid,jifen,addtime,Remark,orderid,night,cardno,userid,status,UseOrderId) values (@weixinid,@userweixinid,@jifen,@addtime,@Remark,@orderid,@night,@cardno,@userid,@status,@UseOrderId)";
                int rs = SQLHelper.Run_SQL(sql2, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                        {
                            {"weixinid",new DBParam(){ParamValue=weixinID}},
                            {"userweixinid",new DBParam(){ParamValue=userWeiXinID}},
                            {"jifen",new DBParam(){ParamValue=score.ToString()}},
                            {"addtime",new DBParam(){ParamValue=DateTime.Now.ToString()}},
                            {"orderid",new DBParam(){ParamValue=SupermarketOrderId}},
                            {"Remark",new DBParam(){ParamValue="超市使用积分"}},
                            {"night",new DBParam(){ParamValue=(0).ToString()}},
                            {"cardno",new DBParam(){ParamValue=cardno}},
                            {"userid",new DBParam(){ParamValue=MyCard.memberid}},
                            {"status",new DBParam(){ParamValue="10"}},
                            {"UseOrderId",new DBParam(){ParamValue=orderid}},
                        });
                return rs;
            }

            return 0;
        }

        //红包回滚
        public void RollCoupon(string id, string hotelweixinid, string userweixinid)
        {
            string sql = "update couponcontent set isemploy=0 where OrderNO=@orderid and weixinid=@weixinid and userweixinno=@userweixinid;";
            SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                {
                    {"orderid",new DBParam(){ParamValue=id.ToString()}},
                    {"weixinid",new DBParam(){ParamValue=hotelweixinid}},
                    {"userweixinid",new DBParam(){ParamValue=userweixinid}}
                });
        }

        /// <summary>
        /// 从订单获取订单积分
        /// </summary>
        /// <param name="SupermarketOrderId"></param>
        /// <param name="Info"></param>
        /// <param name="cardno"></param>
        /// <param name="weixinID"></param>
        /// <param name="orderid"></param>
        /// <returns></returns>
        public int GetScore(ref string SupermarketOrderId, MemberInfo Info, string cardno, string weixinID, string orderid)
        {
            MemberCard MyCard = MemberHelper.GetMemberCard(cardno, weixinID);
            MemberCardIntegralRule IntegralRule = MemberHelper.IntegralRule(Info, MyCard);

            var dt = SupermarketOrderDetailService.GetDataByOrderId(orderid);
            double money = 0;
            foreach (DataRow data in dt.Rows)
            {
                money += double.Parse(data["Price"].ToString()) * double.Parse(data["Total"].ToString());
            }

            string sql1 = @"select top 1 id,Money from SupermarketOrder_Levi with (nolock) where OrderId=@OrderId";
            DataTable dt2 = SQLHelper.Get_DataTable(sql1, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                {"OrderId",new HotelCloud.SqlServer.DBParam(){ParamValue=orderid}}
                    });
            //double money = double.Parse(dt.Rows[0]["Money"].ToString());
            SupermarketOrderId = dt2.Rows[0]["id"].ToString();

            var score = money;
            if (IntegralRule.equivalence > 0)
                score = score * IntegralRule.equivalence;
            if ((double)IntegralRule.GradePlus > 0)
                score = score * (double)IntegralRule.GradePlus;
            return (int)Math.Floor(Math.Round(score, 2));
        }

        /// <summary>
        /// 获取用户积分信息
        /// </summary>
        /// <param name="weixinID"></param>
        /// <param name="userWeiXinNO"></param>
        /// <returns></returns>
        public DataTable GetScoreByUser(string weixinID, string userWeiXinNO)
        {
            string sql = @"select Emoney from WeiXin.dbo.Member where weixinID=@weixinID and userWeiXinNO=@userWeiXinNO";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"userWeiXinNO",new DBParam(){ParamValue=userWeiXinNO}},
                        {"weixinID",new DBParam(){ParamValue=weixinID}}
                    });

            return dt;
        }


        /// <summary>
        /// 插入订单日志
        /// </summary>
        /// <param name="OrderId"></param>
        /// <param name="Context"></param>
        /// <param name="LogType"></param>
        /// <param name="CreateUser"></param>
        /// <param name="CreateTime"></param>
        /// <returns></returns>
        public int InsertOrderLog(string OrderId, string Context, int LogType, string CreateUser)
        {

            string sql2 = @"INSERT INTO [WeiXin].[dbo].[SupermarketOrderLog_Levi]
                               ([OrderId]
                               ,[Context]
                               ,[LogType]
                               ,[CreateUser]
                               ,[CreateTime]
                               )
                         VALUES
                               (@OrderId
                               ,@Context
                               ,@LogType
                               ,@CreateUser
                                ,getdate())";

            int insert = SQLHelper.Run_SQL(sql2, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"OrderId",new DBParam(){ParamValue=OrderId}},
                        {"Context",new DBParam(){ParamValue=Context}},
                        {"LogType",new DBParam(){ParamValue=LogType.ToString()}},
                        {"CreateUser",new DBParam(){ParamValue=CreateUser}}
                        //{"CreateTime",new DBParam(){ParamValue=(DateTime.Now).ToString()}}
                    });
            return insert;
        }

        /// <summary>
        /// 根据订单ID获取数据
        /// </summary>
        /// <param name="orderId"></param>
        /// <returns></returns>
        public DataTable GetOrderLogDataByOrderId(string orderId)
        {
            //string sql = @"select id, OrderId,LogType, Context, CreateUser, CreateTime from SupermarketOrderLog_Levi t with(nolock) where t.OrderId=@OrderId order by CreateTime desc";
            string sql = @"  select id, OrderId,LogType, 
            case when Context like '%创建订单%' then '下单时间' 
            when Context like '%已付款%' then '付款时间' 
            when Context like '%退款%' then '退款时间' 
            when Context like '%发货%' then '发货时间' 
            when Context like '%交易成功%' then '成交时间' 
            when Context like '%订单取消%' then '取消时间' 
            else Context end as Context, 
            CreateUser, CreateTime from SupermarketOrderLog_Levi t with(nolock) where t.OrderId=@OrderId order by CreateTime";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"OrderId",new DBParam(){ParamValue=orderId}}
                    });

            return dt;
        }
    }


    /// <summary>
    /// 订单状态枚举
    /// </summary>
    public enum EnumSupermarketOrderStatus
    {
        /// <summary>
        /// 待支付
        /// </summary>
        WaitPay = 1,

        /// <summary>
        /// 待发货
        /// </summary>
        WaitDeliver = 2,

        /// <summary>
        /// 已发货
        /// </summary>
        Delivered = 3,

        /// <summary>
        /// 订单完成
        /// </summary>
        Finish = 4,

        /// <summary>
        /// 订单取消
        /// </summary>
        Cancel = 5,
    }

    /// <summary>
    /// 订单支付状态枚举
    /// </summary>
    public enum EnumSupermarketPayStatus
    {
        /// <summary>
        /// 待支付
        /// </summary>
        WaitPay = 1,

        /// <summary>
        /// 支付完成
        /// </summary>
        Finish = 2,

        /// <summary>
        /// 部分退款
        /// </summary>
        PartRrturn = 3,

        /// <summary>
        /// 全额退款
        /// </summary>
        AllReturn = 4
    }
}