using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using hotel3g.Models.DAL;
using HotelCloud.SqlServer;
using hotel3g.Repository;

namespace hotel3g.Models.Home
{
    public class MemberCardCustom
    {
        public int Id { get; set; }
        public string CardName { get; set; }
        public int HotelId { get; set; }
        public string WeixinId { get; set; }
        public int IncreaseType { get; set; }
        public int Rooms { get; set; }
        public decimal BuyMoney { get; set; }
        public int CouponType { get; set; }
        public decimal Discount { get; set; }
        public decimal Reduce { get; set; }
        public decimal JiFen { get; set; }
        public int CardLevel { get; set; }
        public DateTime AddTime { get; set; }
        public DateTime LastUpdateTime { get; set; }

        public decimal MealDiscount { get; set; }
        public decimal MealReduce { get; set; }
        public decimal HongBaoMoney { get; set; }

        public int MealCouponType { get; set; }

        public int Status { get; set; }

        public int GiveJifen { get; set; }

        public static int AddModel(MemberCardCustom model)
        {
            return MemberCardCustomDAL.AddModel(model);
        }

        public static int UpdateModel(MemberCardCustom model)
        {
            return MemberCardCustomDAL.UpdateModel(model);
        }


        public static DataTable GetMemberCardCustomList(string weixinID, out int count, int page, int pagesize, string select, string query)
        {
            return MemberCardCustomDAL.GetMemberCardCustomList(weixinID, out count, page, pagesize, select, query);

        }

        public static DataTable GetModel(int Id, string weixinId)
        {
            return MemberCardCustomDAL.GetModel(Id, weixinId);
        }


        public static int UpdateModelStatus(int Id, string weixinId, int status)
        {
            return MemberCardCustomDAL.UpdateModelStatus(Id, weixinId, status);

        }

    }



    public class MemberCardBuyRecord
    {
        public int Id { get; set; }
        public string OrderNo { get; set; }
        public int HotelId { get; set; }
        public string WeixinId { get; set; }
        public string userWeixinId { get; set; }
        public int CardId { get; set; }
        public decimal BuyMoney { get; set; }
        public string CardName { get; set; }
        public int CardLevel { get; set; }
        public int OrderStatus { get; set; }
        public DateTime AddTime { get; set; }
        public DateTime PayTime { get; set; }

        public string Name { get; set; }
        public string Mobile { get; set; }


        public static int AddModel(MemberCardBuyRecord model)
        {
            return MemberCardBuyRecordDAL.AddModel(model);
        }


        public static int GetMaxCardLevel(string hotelweixinId, string userweixinId)
        {
            string cardlevelMax = HotelCloud.SqlServer.SQLHelper.Get_Value("select   isnull(max(cardLevel),0)  from  MemberCardBuyRecord  wiht(nolock)  where weixinId=@weixinId  and userweixinId=@userweixinId   and orderStatus=1  ", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelweixinId}},
              {"userweixinId",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}}
              });
            return Convert.ToInt32(cardlevelMax);
        }



        public static DataTable GetMemberCardCustomList(string weixinID, string userweixinId, out int count, int page, int pagesize, string select, string query)
        {
            return MemberCardBuyRecordDAL.GetMemberCardRecordList(weixinID, userweixinId, out count, page, pagesize, select, query);

        }

        /// <summary>
        /// 购买会员卡成功后处理订单
        /// </summary>
        /// <param name="orderNo"></param>
        public static void DoneOrderSuccess(string orderNo)
        {
            try
            {
                System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select * from  MemberCardBuyRecord  wiht(nolock)  where orderno=@orderno and  orderstatus=0 ", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"orderNo",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}}
              });


                if (dt.Rows.Count == 0)
                {
                    return;
                }

                int row = HotelCloud.SqlServer.SQLHelper.Run_SQL("update  MemberCardBuyRecord  set orderStatus=1,payTime=getdate() where orderno=@orderno", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"orderNo",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}}
              });

                if (row > 0)
                {


                    int levelRows = HotelCloud.SqlServer.SQLHelper.Run_SQL("update  Member  set viptype=@viptype   where weixinId=@weixinId  and userweixinno=@userweixinno ", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {                
                            {"viptype",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["CardLevel"].ToString()}},
                             {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["weixinId"].ToString()}},
                              {"userweixinno",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["userweixinId"].ToString()}}
                      });


                    DataTable db_member = WeiXin.Models.Home.RechargeCard.GetRechargeMemberInfo(dt.Rows[0]["weixinId"].ToString(), dt.Rows[0]["userweixinId"].ToString());


                    if (db_member.Rows[0]["cardNO"].ToString() == string.Empty)
                    {
                        //没有会员卡生成会员卡号

                        string cardNo = hotel3g.Repository.MemberHelper.GetNotUsedCard(dt.Rows[0]["hotelId"].ToString(), dt.Rows[0]["weixinId"].ToString());

                        if (!string.IsNullOrEmpty(cardNo))
                        {

                            int updateRows = HotelCloud.SqlServer.SQLHelper.Run_SQL("update  MemberCard  set isuse=1 , binddate=getdate()    where weixinId=@weixinId  and cardno=@cardno ", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {              
                         {"cardno",new HotelCloud.SqlServer.DBParam{ParamValue=cardNo}},
                         {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["weixinId"].ToString()}}
              
                         });

                            if (updateRows > 0)
                            {
                                updateRows = HotelCloud.SqlServer.SQLHelper.Run_SQL("update  Member  set cardno=@cardno, name=@name,mobile=@mobile   where weixinId=@weixinId  and userweixinno=@userweixinno ", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {                
                            {"cardno",new HotelCloud.SqlServer.DBParam{ParamValue=cardNo}},
                             {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["weixinId"].ToString()}},
                              {"userweixinno",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["userweixinId"].ToString()}},
                                {"name",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["name"].ToString()}},
                                {"mobile",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["mobile"].ToString()}}
                             });

                                if (updateRows > 0)
                                {
                                    //会员注册赠送订房红包
                                    MemberHelper.RegisterCouponGift(dt.Rows[0]["weixinId"].ToString(), dt.Rows[0]["userweixinId"].ToString());

                                    //绑定推广员赠送订房红包
                                    MemberHelper.UpdateCommission(dt.Rows[0]["hotelid"].ToString(), dt.Rows[0]["weixinId"].ToString(), dt.Rows[0]["userweixinId"].ToString());

                                    //推广员送红包

                                    int PromoterID = MemberHelper.GetPromoterID(dt.Rows[0]["userweixinId"].ToString(), dt.Rows[0]["weixinId"].ToString());

                                    if (PromoterID > 0)
                                    {
                                        bool pstatus = false;
                                        string pstr = PromoterDAL.SendCustomCoupon(dt.Rows[0]["weixinId"].ToString(), dt.Rows[0]["mobile"].ToString(),   Convert.ToInt32(db_member.Rows[0]["Id"].ToString()), Convert.ToInt32(dt.Rows[0]["hotelid"].ToString()), out pstatus);

                                    }
                                }
                            }
                        }

                    }            

                    //送红包   积分
                    DataTable dt_hb = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select  hongbaomoney,givejifen from   MemberCardCustom  with(nolock) where Id=@Id", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {                
                            {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=dt.Rows[0]["CardId"].ToString()}}              
                      });

                    if (dt_hb.Rows.Count > 0)
                    {
                        string hongbaomoney = dt_hb.Rows[0]["hongbaomoney"].ToString();
                        if (!string.IsNullOrEmpty(hongbaomoney) && Convert.ToInt32(Convert.ToDecimal(hongbaomoney)) > 0)
                        {
                            int hbmoney = Convert.ToInt32(Convert.ToDecimal(hongbaomoney));
                            int rows = AddCardCoupon(dt.Rows[0]["weixinId"].ToString(), dt.Rows[0]["userweixinId"].ToString(), hbmoney, Convert.ToInt32(dt.Rows[0]["cardId"].ToString()));
                        }

                        int givejifen = Convert.ToInt32(dt_hb.Rows[0]["givejifen"].ToString());

                        if (givejifen > 0)
                        {
                           //重新获取会员最新信息
                            DataTable dbmember_new = WeiXin.Models.Home.RechargeCard.GetRechargeMemberInfo(dt.Rows[0]["weixinId"].ToString(), dt.Rows[0]["userweixinId"].ToString());
                           
                            int userId = 0;
                            string cardno = string.Empty;
                            if (dbmember_new.Rows.Count > 0)
                            {
                                int.TryParse(dbmember_new.Rows[0]["Id"].ToString(), out userId);
                                cardno = dbmember_new.Rows[0]["cardno"].ToString();
                            }


                            int row_jifen = AddCardJifen(dt.Rows[0]["weixinId"].ToString(), dt.Rows[0]["userweixinId"].ToString(), userId, cardno, givejifen, Convert.ToInt32(dt.Rows[0]["cardId"].ToString()));
                            if (row_jifen > 0)
                            {
                                row_jifen = MemberCardBuyRecord.UpdateUserJifen(dt.Rows[0]["weixinId"].ToString(), dt.Rows[0]["userweixinId"].ToString(), givejifen);

                            }
                        }

                    }

                }

            }

            catch (Exception ex)
            {

                WeiXin.Common.Logger.Instance.Error(ex.ToString());
            }

        }


        /// <summary>
        /// 插入一条会员卡升级送红包
        /// </summary>
        /// <param name="hotelweixinId"></param>
        /// <param name="userweixinId"></param>
        /// <param name="money"></param>
        /// <param name="cardId"></param>
        /// <returns></returns>
        public static int AddCardCoupon(string hotelweixinId, string userweixinId, int money, int cardId)
        {

            string sql = string.Format(@"insert into CouPonContent(weixinID,moneys,sTime,ExtTime,addTime,IsEmploy,CouPonNO,userweixinNo,giftname,cardId) values(@weixinID,@moneys,@sTime,@ExtTime,getdate(),0,@CouPonNO,@userweixinNo,@giftname,@cardId ) ");

            int rows = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {  
                            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=hotelweixinId}},      
                            {"moneys",new HotelCloud.SqlServer.DBParam{ParamValue=money.ToString()}}, 
                            {"sTime",new HotelCloud.SqlServer.DBParam{ParamValue=DateTime.Now.Date.ToString()}}, 
                            {"ExtTime",new HotelCloud.SqlServer.DBParam{ParamValue=DateTime.Now.Date.AddDays(60).ToString()}}, 
                            {"CouPonNO",new HotelCloud.SqlServer.DBParam{ParamValue=DateTime.Now.ToString("yyMMddHHmmssfff")}}, 
                           {"userweixinNo",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}}, 
                            {"giftname",new HotelCloud.SqlServer.DBParam{ParamValue="会员升级送红包"}}, 
                            {"cardId",new HotelCloud.SqlServer.DBParam{ParamValue= cardId.ToString()}}, 
                      });

            return rows;

        }



        /// <summary>
        /// 会员卡升级送积分
        /// </summary>
        /// <param name="hotelweixinId"></param>
        /// <param name="userweixinId"></param>
        /// <param name="userId"></param>
        /// <param name="cardno"></param>
        /// <param name="jifen"></param>
        /// <param name="cardId"></param>
        /// <returns></returns>
        public static int AddCardJifen(string hotelweixinId, string userweixinId, int userId, string cardno, int jifen, int cardId)
        {

            string sql = "insert into jifendetail (weixinid,userweixinid,jifen,addtime,orderid,night,cardno,userid,remark,cardId,status) values (@weixinid,@userweixinid,@jifen,@addtime,@orderid,@night,@cardno,@userid,@remark,@cardId,1)";

            int rows = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                        {
                            {"weixinid",new DBParam(){ParamValue=hotelweixinId}},
                            {"userweixinid",new DBParam(){ParamValue=userweixinId}},
                            {"jifen",new DBParam(){ParamValue=jifen.ToString()}},
                            {"addtime",new DBParam(){ParamValue=DateTime.Now.ToString()}},
                            {"orderid",new DBParam(){ParamValue="0"}},
                            {"night",new DBParam(){ParamValue="0" }},
                            {"cardno",new DBParam(){ParamValue=cardno}},
                            {"userid",new DBParam(){ParamValue=userId.ToString()}},
                           {"remark",new DBParam(){ParamValue="会员升级送积分"}},
                           {"cardId",new DBParam(){ParamValue= cardId.ToString()}}
                        });

            return rows;

        }

        /// <summary>
        /// 更新用户积分
        /// </summary>
        /// <param name="hotelweixinId"></param>
        /// <param name="userweixinId"></param>
        /// <param name="userId"></param>
        /// <param name="cardno"></param>
        /// <param name="jifen"></param>
        /// <param name="cardId"></param>
        /// <returns></returns>
        public static int UpdateUserJifen(string hotelweixinId, string userweixinId, int jifen)
        {
            int rows = SQLHelper.Run_SQL("update  Member  set emoney=emoney+ @jifen  where weixinId=@weixinId  and   userWeiXinNO=@userWeiXinNO ",
                                SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                                   {     
                                       {"weixinId",new DBParam(){ParamValue=hotelweixinId}},
                                       {"userWeiXinNO",new DBParam(){ParamValue=userweixinId}},
                                       {"jifen",new DBParam(){ParamValue=jifen.ToString()}},
                                   });


            return rows;

        }




        public static int GetPromoterid(string weixinId, string userweixinId)
        {
            string sql_m = @"select promoterid from Member  with(nolock)  where  weixinId=@weixinId  and userweixinno=@userweixinno  and  DATEADD(M,3,addtime) >= getdate()  and  ISNULL(cardno,'')<>''  ";
            string str_promoterid = HotelCloud.SqlServer.SQLHelper.Get_Value(sql_m, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weixinId}},
             {"userweixinno",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}}  
            });


            int promoterid = 0;
            int.TryParse(str_promoterid, out promoterid);

            return promoterid;

        }


        public static decimal GetRatefxCommission(string weixinId, bool istuan = false)
        {

            string sql_m = @"select kefang from S_HuoDongTianBao_fenxiao  with(nolock)  where  weixinId=@weixinId ";

            if (istuan)
            {
                sql_m = @"select tuangou from S_HuoDongTianBao_fenxiao  with(nolock)  where  weixinId=@weixinId ";
            }

            string str_fxCommission = HotelCloud.SqlServer.SQLHelper.Get_Value(sql_m, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weixinId}},            
            });


            decimal fxCommission = 0;
            decimal.TryParse(str_fxCommission, out fxCommission);
            return fxCommission;

        }


        /// <summary>
        /// 下单减少房型销售的库存
        /// </summary>
        /// <param name="hid"></param>
        /// <param name="rid"></param>
        /// <param name="indate"></param>
        /// <param name="outdate"></param>
        /// <param name="rooms"></param>
        /// <returns></returns>
        public static int ReduceRoomStock(int hid, int rid, DateTime indate, DateTime outdate, int rooms)
        {

            string sql = "update roomstock set havesale=havesale+@rooms    where hid=@hid and rid=@rid and stockdate>=@indate and stockdate<@outdate ";
            int rowStock = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                            {
                                {"hid",new DBParam(){ParamValue=hid.ToString()}},
                                {"rid",new DBParam(){ParamValue=rid.ToString()}},
                                {"indate",new DBParam(){ParamValue=indate.ToString()}},
                                {"outdate",new DBParam(){ParamValue=outdate.ToString()}},
                                {"rooms",new DBParam(){ParamValue=rooms.ToString()}},
                            });

            return rowStock;
        }


        /// <summary>
        /// 取消订单增加库存
        /// </summary>
        /// <param name="orderId"></param>
        /// <returns></returns>
        public static int CancelOrderAddCRoomStock(int orderId)
        {
            string sql = "select  hotelid,RoomID,yRoomNum,yinDate,youtDate from hotelorder with(nolock) where id=@Id  and ismeeting=0   ";
            DataTable db = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()                            
                             {
                                {"Id",new DBParam(){ParamValue=orderId.ToString()}}, 
                            });

            if (db.Rows.Count == 0)
            {
                return 0;

            }
            sql = "update roomstock set havesale=havesale - @rooms    where hid=@hid and rid=@rid and stockdate>=@indate and stockdate<@outdate and havesale>=@rooms  ";
            int rowStock = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                            {
                                {"hid",new DBParam(){ParamValue=db.Rows[0]["hotelid"].ToString()}},
                                {"rid",new DBParam(){ParamValue=db.Rows[0]["RoomID"].ToString()}},
                                {"indate",new DBParam(){ParamValue=db.Rows[0]["yinDate"].ToString()}},
                                {"outdate",new DBParam(){ParamValue=db.Rows[0]["youtDate"].ToString()}},
                                {"rooms",new DBParam(){ParamValue=db.Rows[0]["yRoomNum"].ToString()}},
                            });

            return rowStock;

        }
    }

}