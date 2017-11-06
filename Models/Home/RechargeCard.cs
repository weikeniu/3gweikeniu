using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using WeiXin.Models.DAL;
using WeiXin.Common;
using System.Text;
using System.Transactions;

namespace WeiXin.Models.Home
{
    public class RechargeCard
    {
        public int Id { get; set; }
        public string WeixinId { get; set; }
        public int HotelId { get; set; }
        public string Name { get; set; }
        public decimal MPrice { get; set; }
        public decimal Sprice { get; set; }
        public int TotalNum { get; set; }
        public int SaleNum { get; set; }
        public int SaleStatus { get; set; }
        public int PasswordStatus { get; set; }
        public string UseRange { get; set; }
        public DateTime AddTime { get; set; }
        public string AddPerson { get; set; }
        public DateTime LastUpdateTime { get; set; }

        public static int AddRechargeCard(RechargeCard model)
        {
            return RechargeCardDAL.AddRechargeCard(model);
        }


        public static int UpdateRechargeCard(RechargeCard model)
        {
            return RechargeCardDAL.UpdateRechargeCard(model);
        }



        public static DataTable GeteRechargeCard(string weixinId, int Id)
        {
            return RechargeCardDAL.GeteRechargeCard(weixinId, Id);
        }


        public static DataTable GeteRechargeCardList(string weiXinID, out int count, int page, int pagesize, string select, string query)
        {
            return RechargeCardDAL.GeteRechargeCardList(weiXinID, out  count, page, pagesize, select, query);
        }


        public static DataTable GetRechargeMemberInfo(string hotelweiXinId, string userweixinId)
        {
            return RechargeCardDAL.GetRechargeMemberInfo(hotelweiXinId, userweixinId);
        }

        public static DataTable GetRechargeMemberInfoByMobile(string hotelweiXinId, string mobile)
        {
            return RechargeCardDAL.GetRechargeMemberInfoByMobile(hotelweiXinId, mobile);
        }



        public static DataTable GetRechargeMemberPayPassword(string hotelweiXinId, string userweixinId)
        {
            return RechargeCardDAL.GetRechargeMemberPayPassword(hotelweiXinId, userweixinId);
        }

        public static int UpdateRechargeMemberPayPassword(string hotelweiXinId, string userweixinId, string paypassword)
        {

            return RechargeCardDAL.UpdateRechargeMemberPayPassword(hotelweiXinId, userweixinId, paypassword);
        }


        public static int GeteRechargeCardCount(string hotelweiXinId)
        {
            return RechargeCardDAL.GeteRechargeCardCount(hotelweiXinId);
        }




        /// <summary>
        /// 充值会员账户余额
        /// </summary>
        /// <param name="hotelweiXinId"></param>
        /// <param name="userweixinId"></param>
        /// <param name="addmoney">充值金额</param>
        /// <returns></returns>
        public static int UpdateRechargeMemberBalance(string hotelweiXinId, string userWeixinId, decimal addmoney)
        {
            return RechargeCardDAL.UpdateRechargeMemberBalance(hotelweiXinId, userWeixinId, addmoney);

        }

        /// <summary>
        /// 扣除会员账户余额
        /// </summary>
        /// <param name="hotelweiXinId"></param>
        /// <param name="userweixinId"></param>
        /// <param name="reduceMoney">扣除金额</param>
        /// <returns></returns>
        public static int ReduceRechargeMemberBalance(string hotelweiXinId, string userWeixinId, decimal reduceMoney)
        {
            return RechargeCardDAL.ReduceRechargeMemberBalance(hotelweiXinId, userWeixinId, reduceMoney);
        }



        /// <summary>
        /// 微信支付成功后处理
        /// </summary>
        /// <param name="ordeNO"></param>
        /// <returns></returns>
        public static bool DoUserRechargeSuccess(string ordeNO)
        {
            bool flag = false;
            try
            {
                string sql = "select cardId,hotelweixinId,userweixinId,Mprice  from RechargeUser  with(nolock)   where orderNO=@orderNo and orderStatus=0 ";

                DataTable db_RechargeOrder = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>            {
              {"orderNo",new HotelCloud.SqlServer.DBParam{ParamValue=ordeNO}},              
            });

                if (db_RechargeOrder.Rows.Count == 0)
                {
                    return flag;
                }



                DataTable dbMember = RechargeCard.GetRechargeMemberInfo(db_RechargeOrder.Rows[0]["hotelweixinId"].ToString(), db_RechargeOrder.Rows[0]["userweixinId"].ToString());

                if (dbMember.Rows.Count != 1)
                {
                    return false;
                }

                using (TransactionScope scop = new TransactionScope())
                {
                    //销售数量+1
                    sql = "update RechargeCard  set saleNum=saleNum+1  where  weixinId=@weixinId  and Id=@Id ";
                    int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
                {
                  {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=db_RechargeOrder.Rows[0]["hotelweixinId"].ToString()}},
                  {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=db_RechargeOrder.Rows[0]["cardId"].ToString()}},                  
                });

                    if (row > 0)
                    {

                        //更新订单状态及金额
                        sql = "update RechargeUser set  orderStatus=1,Beforebalance=@Beforebalance,Balance=Mprice + @Beforebalance,addTime=getdate()    where  orderNo=@orderNo ";
                        row = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam>
                {
                    {"orderNo",new HotelCloud.SqlServer.DBParam{ParamValue=ordeNO}},
                     {"Beforebalance",new HotelCloud.SqlServer.DBParam{ParamValue=dbMember.Rows[0]["balance"].ToString()}}                        
                });


                        if (row > 0)
                        {
                            //充值账户

                            row = RechargeCard.UpdateRechargeMemberBalance(db_RechargeOrder.Rows[0]["hotelweixinId"].ToString(), db_RechargeOrder.Rows[0]["userweixinId"].ToString(), Convert.ToDecimal(db_RechargeOrder.Rows[0]["Mprice"].ToString()));

                            //三部曲完成提交
                            if (row > 0)
                            {
                                flag = true;
                                scop.Complete();
                            }
                        }
                    }
                }
            }

            catch (Exception ex)
            {
                Logger.Instance.Error(ex.ToString());

            }
            return flag;
        }
    }


    public class RechargeUser
    {
        public int Id { get; set; }
        public string OrderNo { get; set; }
        public string HotelWeixinId { get; set; }
        public int HotelId { get; set; }
        public string UserWeixinId { get; set; }
        public string UserName { get; set; }
        public string UserMobile { get; set; }
        public string UserLevel { get; set; }
        public decimal MPrice { get; set; }
        public decimal SPrice { get; set; }
        public decimal Beforebalance { get; set; }
        public decimal Balance { get; set; }
        public int PayType { get; set; }
        public int OrderStatus { get; set; }
        public string Source { get; set; }
        public bool IsCardPassword { get; set; }
        public DateTime AddTime { get; set; }
        public int CardId { get; set; }

        public string TradeOrderNo { get; set; }

        public static int AddRechargeCard(RechargeUser model)
        {
            return RechargeUserDAL.AddRechargeUser(model);
        }

        public static DataTable GeteRechargeUserList(string hotelweiXinId, string userWeixinId, out int count, int page, int pagesize, string select, string query)
        {
            return RechargeUserDAL.GeteRechargeUserList(hotelweiXinId, userWeixinId, out  count, page, pagesize, select, query);
        }

        public static RechargeTJEntity GetTJRechargeCardInfo(string weiXinId)
        {

            return RechargeUserDAL.GetTJRechargeCardInfo(weiXinId);

        }


        public static DataTable GeteRechargUser(string weiXinId, int Id)
        {
            return RechargeUserDAL.GeteRechargUser(weiXinId, Id);

        }


        public static DataTable GeteRechargUserByTradeOrderNo(string tradeOrderNo)
        {
            return RechargeUserDAL.GeteRechargUserByTradeOrderNo(tradeOrderNo);

        }
    }


    public class RechargeUserPassword
    {
        public int Id { get; set; }
        public string CardPassword { get; set; }
        public string weixinID { get; set; }
        public int hotelId { get; set; }
        public decimal Mprice { get; set; }
        public decimal Sprice { get; set; }
        public string CardName { get; set; }
        public int CardId { get; set; }
        public int CardStatus { get; set; }
        public DateTime AddTime { get; set; }

        public static DataTable GeteCardPassword(string weixinId, string cardPassword)
        {
            return RechargeUserPasswordDAL.GeteCardPassword(weixinId, cardPassword);
        }


        public static int UpdateCardPasswordStatus(string weixinId, string cardPassword, int cardStatus)
        {
            return RechargeUserPasswordDAL.UpdateCardPasswordStatus(weixinId, cardPassword, cardStatus);
        }
    }



    public class RechargeRange
    {
        public int Id { get; set; }
        public string WeixinId { get; set; }
        public string UseRange { get; set; }
        public string Remark { get; set; }

        public static int AddModel(RechargeRange model)
        {
            return RechargeRangeDAL.AddModel(model);

        }

        public static int UpdateModel(RechargeRange model)
        {
            return RechargeRangeDAL.UpdateModel(model);

        }

        public static DataTable GetRechargeRange(string weixinId)
        {
            return RechargeRangeDAL.GetRechargeRange(weixinId);

        }
    }
}