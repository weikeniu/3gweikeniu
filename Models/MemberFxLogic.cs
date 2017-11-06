using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using HotelCloud.SqlServer;
using hotel3g.Models.Home;

namespace hotel3g.Models
{
    /// <summary>
    /// 会员中心分销  
    /// </summary>
    public static class MemberFxLogic
    {
        /// <summary>
        /// 统计分销佣金 
        /// </summary>
        public static int SetMemberFxMoney(string MemberId, string userweixinid, string WeiXinID)
        {
            string sql = @"
begin try  
begin transaction
    UPDATE Member set TotalCash=(SELECT isnull(SUM(ISNULL(fxmoneyProfit,0)),0)m FROM dbo.T_OrderInfo WITH(NOLOCK) WHERE isjiesuan=1 and hotelWeixinId=@WeiXinID and promoterid=@MemberId)
+(SELECT isnull(SUM(ISNULL(fxmoneyProfit,0)),0)m FROM dbo.SupermarketOrder_Levi WITH(NOLOCK) where isjiesuan=1 and PayMethod != '积分支付'  and weixinID=@WeiXinID and promoterid=@MemberID) 
+(select isnull(SUM(ISNULL(fxmoneyProfit,0)),0)m from HotelOrder t WITH(NOLOCK)  where isjiesuan=1 and t.WeiXinID=@WeiXinID and t.promoterid=@MemberId)
+(select isnull(SUM(ISNULL(fxmoneyProfit,0)),0)m from  SaleProducts_Orders   WITH(NOLOCK) where isjiesuan=1 and HotelWeiXinId=@WeiXinID and promoterid=@MemberId)
WHERE Id=@MemberId;
    UPDATE Member set HasPutOutCash=(select ISNULL(SUM(ISNULL(applymoney,0)),0) from T_MemberCash where weixinid=@WeiXinID and userweixinid=@userweixinid and state=1)WHERE Id=@MemberId;
    UPDATE Member set CanPutOutCash=isnull(TotalCash,0)-isnull(HasPutOutCash,0)-(select ISNULL(SUM(ISNULL(applymoney,0)),0) from T_MemberCash where weixinid=@WeiXinID and userweixinid=@userweixinid and state=0) where id=@MemberId  
commit transaction
end try
begin catch
 rollback transaction
end catch          
";
            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
              {"Status",new DBParam(){ParamValue=Convert.ToInt32(EnumOrderStatus.IsFinish).ToString()}},
              {"MemberId",new DBParam(){ParamValue=MemberId}},
              {"userweixinid",new DBParam(){ParamValue=userweixinid}},
              {"WeiXinID",new DBParam(){ParamValue=WeiXinID}}
            });
        }
        /// <summary>
        /// 获取版本 1A版本  其他(老版本)
        /// </summary>
        public static string GetEdition(string WeiXinID)
        {
            string sql = @" SELECT top 1 edition FROM dbo.WeiXinNO where WeiXinID=@WeiXinID";
            return SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"WeiXinID",new DBParam(){ParamValue=WeiXinID}}
                    });
        }

        /// <summary>
        /// 获取会员信息
        /// </summary>
        public static DataTable GetMemberInfo(string userweixinid, string weixinID)
        {
            string sql = @"select top 1
Id, member.weixinID, userWeiXinNO, mobile, Email, sex, addtime, Emoney, userFlag, nickname, name, cardno, address, 
pwd, night, photo, idcard, viptype, leveltime, caozuo, balance, ISNULL(TotalCash,0)TotalCash, isnull(CanPutOutCash,0)CanPutOutCash,ISNULL(HasPutOutCash,0)HasPutOutCash
,(select isnull(SUM(fxmoneyProfit),0)fxmoneyProfit from T_OrderCommission where T_OrderCommission.promoterid=member.Id and T_OrderCommission.weixinid=member.weixinID)TotalCash2
,(select isnull(SUM(fxmoneyProfit),0)fxmoneyProfit from T_OrderCommission where T_OrderCommission.promoterid=member.Id and T_OrderCommission.weixinid=member.weixinID)
-(select isnull(SUM(applymoney),0)applymoney from dbo.T_MemberCash where userweixinid=member.userWeiXinNO and weixinid=member.weixinID and state<>2)CanPutOutCash2
,(select isnull(SUM(applymoney),0)applymoney from dbo.T_MemberCash where userweixinid=member.userWeiXinNO and weixinid=member.weixinID and state<>2)HasPutOutCash2
 from member where userWeiXinNO=@userweixinid and weixinID=@weixinID";
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"userweixinid",new DBParam(){ParamValue=userweixinid}},
                        {"weixinID",new DBParam(){ParamValue=weixinID}}
                    });
        }
        public static DataTable GetMemberInfo(string MemberId)
        {
            string sql = @"select top 1
Id, member.weixinID, userWeiXinNO, mobile, Email, sex, addtime, Emoney, userFlag, nickname, name, cardno, address, 
pwd, night, photo, idcard, viptype, leveltime, caozuo, balance, ISNULL(TotalCash,0)TotalCash, isnull(CanPutOutCash,0)CanPutOutCash,ISNULL(HasPutOutCash,0)HasPutOutCash
,(select isnull(SUM(fxmoneyProfit),0)fxmoneyProfit from T_OrderCommission where T_OrderCommission.promoterid=member.Id and T_OrderCommission.weixinid=member.weixinID)TotalCash2
,(select isnull(SUM(fxmoneyProfit),0)fxmoneyProfit from T_OrderCommission where T_OrderCommission.promoterid=member.Id and T_OrderCommission.weixinid=member.weixinID)
-(select isnull(SUM(applymoney),0)applymoney from dbo.T_MemberCash where userweixinid=member.userWeiXinNO and weixinid=member.weixinID and state<>2)CanPutOutCash2
,(select isnull(SUM(applymoney),0)applymoney from dbo.T_MemberCash where userweixinid=member.userWeiXinNO and weixinid=member.weixinID and state<>2)HasPutOutCash2
 from member where Id=@Id";
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"Id",new DBParam(){ParamValue=MemberId}}
                    });
        }

        /// <summary>
        /// 获取提现列表
        /// </summary>
        /// <returns></returns>
        public static DataTable GetApplyCashList(string userweixinid)
        {
            string sql = @"select id, applymoney, createtime, userweixinid, state, audittime from T_MemberCash where userweixinid=@userweixinid order by createtime desc";
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"userweixinid",new DBParam(){ParamValue=userweixinid}}
                    });
        }
        /// <summary>
        /// 获取提现列表 page=0 ,1,2..
        /// </summary>
        /// <returns></returns>
        public static DataTable GetApplyCashList(string weixinid, string userweixinid, int page, int pagesize)
        {
            int rows = page > 0 ? page * pagesize : 0;
            string sql = @"select top " + pagesize + @" * from (
select *,ROW_NUMBER() OVER(ORDER BY t.createtime DESC) AS row
 from dbo.T_MemberCash t where t.userweixinid=@userweixinid and t.weixinid=@weixinid)tb where tb.row>@rows ";
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"userweixinid",new DBParam(){ParamValue=userweixinid}},
                        {"weixinid",new DBParam(){ParamValue=weixinid}},
                        {"rows",new DBParam(){ParamValue=rows.ToString()}}
                    });
        }

        /// <summary>
        /// 保存申请提现信息
        /// </summary>
        public static int SaveApply(string memberId, string weixinid, string userweixinid, string applymoney)
        {

            string sql = @"insert into T_MemberCash(applymoney,weixinid,userweixinid,state) values(@applymoney,@weixinid,@userweixinid,@state)";
            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"memberId",new DBParam(){ParamValue=memberId}},
                        {"applymoney",new DBParam(){ParamValue=applymoney}},
                        {"weixinid",new DBParam(){ParamValue=weixinid}},
                        {"userweixinid",new DBParam(){ParamValue=userweixinid}},
                        {"state",new DBParam(){ParamValue=Convert.ToInt32(EnumMemberFXStatus.申请提现).ToString()}}
                    });
        }

        /// <summary>
        /// 获取分销客户数
        /// </summary>
        /// <param name="MemberID"></param>
        /// <returns></returns>
        public static string GetShareCustomerNum(string MemberID, string WeiXinID)
        {
            string sql = @"SELECT count(*)num FROM dbo.Member WITH(NOLOCK) WHERE promoterid>0 and WeiXinID=@WeiXinID AND promoterid=@MemberID";
            return SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"MemberID",new DBParam(){ParamValue=MemberID}},
            {"WeiXinID",new DBParam(){ParamValue=WeiXinID}}
            });
        }

        /// <summary>
        /// 获取分销订单数
        /// </summary>
        /// <param name="MemberID"></param>
        /// <returns></returns>
        public static string GetShareOrderNum(string MemberID, string WeiXinID)
        {
            string sql = "select SUM(num)num from(";
            sql += " SELECT count(*)num FROM dbo.T_OrderInfo WITH(NOLOCK) WHERE promoterid>0 and hotelWeixinId=@WeiXinID and promoterid=@MemberID ";//餐饮分销订单数
            sql += " union all ";
            sql += " select COUNT(*)num from SupermarketOrder_Levi   WITH(NOLOCK) where PayMethod != '积分支付' and promoterid>0 and weixinID=@WeiXinID and promoterid=@MemberID ";//超市订单数
            sql += " union all ";
            sql += " select COUNT(*)num from HotelOrder WITH(NOLOCK)  where promoterid>0 and WeiXinID=@WeiXinID and promoterid=@MemberID  ";
            sql += " union all ";
            sql += " select COUNT(*) from  SaleProducts_Orders WITH(NOLOCK) where promoterid>0 and HotelWeiXinId=@WeiXinID  and promoterid=@MemberID  ";
            sql += " )tb";

            //string sql = "select COUNT(1)num from T_OrderCommission where weixinid=@WeiXinID and promoterid=@MemberID";

            return SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"Status",new DBParam(){ParamValue=Convert.ToInt32(EnumOrderStatus.IsFinish).ToString()}},
            {"MemberID",new DBParam(){ParamValue=MemberID}},
            {"WeiXinID",new DBParam(){ParamValue=WeiXinID}}
            });
        }

        /// <summary>
        /// 获取分销订单列表
        /// </summary>
        /// <param name="MemberID"></param>
        /// <returns></returns>
        public static List<FxOrderCommission> GetShareOrderList(string MemberID, string WeiXinID, int page, int pagesize,int type=1)
        {
            int rows = page > 0 ? page * pagesize : 0;
            string sql = "select top " + pagesize + @" * from(";
            sql += @" select *,ROW_NUMBER() OVER(ORDER BY tb.createtime DESC) AS row from ( ";
            sql += "  SELECT '餐饮订单'as name,t.orderCode,t.amount,t.payamount,ISNULL(t.fxmoneyProfit,0)fxmoney,t.Status,isjiesuan,t.submitTime as createtime,h.hotelLog FROM dbo.T_OrderInfo t WITH(NOLOCK) left join hotel h   WITH(NOLOCK) on t.hotelid=h.id WHERE t.hotelWeixinId=@WeiXinID and t.promoterid=@MemberID";
            sql += " union all ";
            sql += " select '超市订单' as name,t.orderid as orderCode,Money as amount,Money as payamount,ISNULL(t.fxmoneyProfit,0)fxmoney,OrderStatus,isjiesuan,createtime ,h.hotelLog from SupermarketOrder_Levi t left join hotel h   WITH(NOLOCK) on t.hotelid=h.id where PayMethod != '积分支付' and t.weixinID=@WeiXinID and t.promoterid=@MemberID";
            sql += " union all ";
            sql += @" select '酒店订房'as name,orderno as orderCode,isnull(t.ySumPrice,0) as amount,isnull(t.aliPayAmount,0)/100 as payamount,ISNULL(t.fxmoneyProfit,0)fxmoney,t.state,isjiesuan,t.Ordertime as createtime, h.hotelLog 
from HotelOrder t WITH(NOLOCK) left join hotel h   WITH(NOLOCK) on t.hotelid=h.id  where t.source='weixinweb' and ismeeting=0 and t.WeiXinID=@WeiXinID and t.promoterid=@MemberID ";
            sql += " union all ";
            sql += @" select '团购订单'as name,orderno as orderCode,ISNULL(OrderMoney,0)amount,ISNULL(OrderMoney,0)payamount,ISNULL(fxmoneyProfit,0)fxmoney,OrderStatus,isjiesuan,OrderAddTime as createtime,h.hotelLog
 from  SaleProducts_Orders   WITH(NOLOCK) left join hotel h   WITH(NOLOCK) on hotelid=h.id    where HotelWeiXinId=@WeiXinID and promoterid=@MemberID  ";
            sql += "  )tb ";
            sql += " )l where l.row>@rows ";

            if (type == 2)//已完成
            {
                sql = "select top " + pagesize + @" * from(";
                sql += @" select *,ROW_NUMBER() OVER(ORDER BY tb.createtime DESC) AS row from ( ";
                sql += "  SELECT '餐饮订单'as name,t.orderCode,t.amount,t.payamount,ISNULL(t.fxmoneyProfit,0)fxmoney,t.Status,isjiesuan,t.submitTime as createtime,h.hotelLog FROM dbo.T_OrderInfo t WITH(NOLOCK) left join hotel h   WITH(NOLOCK) on t.hotelid=h.id WHERE t.hotelWeixinId=@WeiXinID and t.promoterid=@MemberID and isjiesuan=1 ";
                sql += " union all ";
                sql += " select '超市订单' as name,t.orderid as orderCode,Money as amount,Money as payamount,ISNULL(t.fxmoneyProfit,0)fxmoney,OrderStatus,isjiesuan,createtime ,h.hotelLog from SupermarketOrder_Levi t left join hotel h   WITH(NOLOCK) on t.hotelid=h.id where PayMethod != '积分支付' and t.weixinID=@WeiXinID and t.promoterid=@MemberID and isjiesuan=1 ";
                sql += " union all ";
                sql += @" select '酒店订房'as name,orderno as orderCode,isnull(t.ySumPrice,0) as amount,isnull(t.aliPayAmount,0)/100 as payamount,ISNULL(t.fxmoneyProfit,0)fxmoney,t.state,isjiesuan,t.Ordertime as createtime, h.hotelLog 
from HotelOrder t WITH(NOLOCK) left join hotel h   WITH(NOLOCK) on t.hotelid=h.id  where t.source='weixinweb' and ismeeting=0 and t.WeiXinID=@WeiXinID and t.promoterid=@MemberID  and isjiesuan=1 ";
                sql += " union all ";
                sql += @" select '团购订单'as name,orderno as orderCode,ISNULL(OrderMoney,0)amount,ISNULL(OrderMoney,0)payamount,ISNULL(fxmoneyProfit,0)fxmoney,OrderStatus,isjiesuan,OrderAddTime as createtime,h.hotelLog
 from  SaleProducts_Orders   WITH(NOLOCK) left join hotel h   WITH(NOLOCK) on hotelid=h.id    where HotelWeiXinId=@WeiXinID and promoterid=@MemberID  and isjiesuan=1  ";
                sql += "  )tb ";
                sql += " )l where l.row>@rows ";
            }

            if (type == 3)//待完成
            {
                sql = "select top " + pagesize + @" * from(";
                sql += @" select *,ROW_NUMBER() OVER(ORDER BY tb.createtime DESC) AS row from ( ";
                sql += "  SELECT '餐饮订单'as name,t.orderCode,t.amount,t.payamount,ISNULL(t.fxmoneyProfit,0)fxmoney,t.Status,isjiesuan,t.submitTime as createtime,h.hotelLog FROM dbo.T_OrderInfo t WITH(NOLOCK) left join hotel h   WITH(NOLOCK) on t.hotelid=h.id WHERE t.hotelWeixinId=@WeiXinID and t.promoterid=@MemberID and isjiesuan<>1 and t.Status in(1,9,10,14,15) ";
                sql += " union all ";
                sql += " select '超市订单' as name,t.orderid as orderCode,Money as amount,Money as payamount,ISNULL(t.fxmoneyProfit,0)fxmoney,OrderStatus,isjiesuan,createtime ,h.hotelLog from SupermarketOrder_Levi t left join hotel h   WITH(NOLOCK) on t.hotelid=h.id where PayMethod != '积分支付' and t.weixinID=@WeiXinID and t.promoterid=@MemberID and isjiesuan<>1 and OrderStatus<>5";
                sql += " union all ";
                sql += @" select '酒店订房'as name,orderno as orderCode,isnull(t.ySumPrice,0) as amount,isnull(t.aliPayAmount,0)/100 as payamount,ISNULL(t.fxmoneyProfit,0)fxmoney,t.state,isjiesuan,t.Ordertime as createtime, h.hotelLog 
from HotelOrder t WITH(NOLOCK) left join hotel h   WITH(NOLOCK) on t.hotelid=h.id  where t.source='weixinweb' and ismeeting=0 and t.WeiXinID=@WeiXinID and t.promoterid=@MemberID  and isjiesuan<>1 and (t.state<>2 or t.state<>22)";
                sql += " union all ";
                sql += @" select '团购订单'as name,orderno as orderCode,ISNULL(OrderMoney,0)amount,ISNULL(OrderMoney,0)payamount,ISNULL(fxmoneyProfit,0)fxmoney,OrderStatus,isjiesuan,OrderAddTime as createtime,h.hotelLog
 from  SaleProducts_Orders   WITH(NOLOCK) left join hotel h   WITH(NOLOCK) on hotelid=h.id    where HotelWeiXinId=@WeiXinID and promoterid=@MemberID  and isjiesuan<>1 and (OrderStatus<>2 or OrderStatus<>5) ";
                sql += "  )tb ";
                sql += " )l where l.row>@rows ";
            }

            if (type == 4)//失败
            {
                sql = "select top " + pagesize + @" * from(";
                sql += @" select *,ROW_NUMBER() OVER(ORDER BY tb.createtime DESC) AS row from ( ";
                sql += "  SELECT '餐饮订单'as name,t.orderCode,t.amount,t.payamount,ISNULL(t.fxmoneyProfit,0)fxmoney,t.Status,isjiesuan,t.submitTime as createtime,h.hotelLog FROM dbo.T_OrderInfo t WITH(NOLOCK) left join hotel h   WITH(NOLOCK) on t.hotelid=h.id WHERE t.hotelWeixinId=@WeiXinID and t.promoterid=@MemberID and isjiesuan<>1 and t.Status in(2,3,11,13) ";
                sql += " union all ";
                sql += " select '超市订单' as name,t.orderid as orderCode,Money as amount,Money as payamount,ISNULL(t.fxmoneyProfit,0)fxmoney,OrderStatus,isjiesuan,createtime ,h.hotelLog from SupermarketOrder_Levi t left join hotel h   WITH(NOLOCK) on t.hotelid=h.id where PayMethod != '积分支付' and t.weixinID=@WeiXinID and t.promoterid=@MemberID and isjiesuan<>1 and OrderStatus=5";
                sql += " union all ";
                sql += @" select '酒店订房'as name,orderno as orderCode,isnull(t.ySumPrice,0) as amount,isnull(t.aliPayAmount,0)/100 as payamount,ISNULL(t.fxmoneyProfit,0)fxmoney,t.state,isjiesuan,t.Ordertime as createtime, h.hotelLog 
from HotelOrder t WITH(NOLOCK) left join hotel h   WITH(NOLOCK) on t.hotelid=h.id  where t.source='weixinweb' and ismeeting=0 and t.WeiXinID=@WeiXinID and t.promoterid=@MemberID  and isjiesuan<>1 and (t.state=2 or t.state=22)";
                sql += " union all ";
                sql += @" select '团购订单'as name,orderno as orderCode,ISNULL(OrderMoney,0)amount,ISNULL(OrderMoney,0)payamount,ISNULL(fxmoneyProfit,0)fxmoney,OrderStatus,isjiesuan,OrderAddTime as createtime,h.hotelLog
 from  SaleProducts_Orders   WITH(NOLOCK) left join hotel h   WITH(NOLOCK) on hotelid=h.id    where HotelWeiXinId=@WeiXinID and promoterid=@MemberID  and isjiesuan<>1 and (OrderStatus=2 or OrderStatus=5)  ";
                sql += "  )tb ";
                sql += " )l where l.row>@rows ";
            }

            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"Status",new DBParam(){ParamValue=Convert.ToInt32(EnumOrderStatus.IsFinish).ToString()}},
            {"MemberID",new DBParam(){ParamValue=MemberID}},
            {"WeiXinID",new DBParam(){ParamValue=WeiXinID}},
            {"rows",new DBParam(){ParamValue=rows.ToString()}}
            }).ToList<FxOrderCommission>(); ;
        }
        public static string GetShareOrderStatusName(FxOrderCommission model)
        {
            if (model.isjiesuan == 1)
            {
                return "成功订单";
            }
            else
            {
                if (model.name.Contains("餐饮订单"))
                {
                    if (model.Status == Convert.ToInt32(EnumOrderStatus.IsBossCancel) ||
                    model.Status == Convert.ToInt32(EnumOrderStatus.IsCancel) ||
                    model.Status == Convert.ToInt32(EnumOrderStatus.IsOverTime) ||
                    model.Status == Convert.ToInt32(EnumOrderStatus.JudanTuikuan))
                    {
                        return "失败订单";
                    }
                    else
                    {
                        return "待完成单";
                    }
                }
                if (model.name.Contains("超市订单"))
                {
                    if (model.Status == 5)
                    {
                        return "失败订单";
                    }
                    else
                    {
                        return "待完成单";
                    }
                }
                if (model.name.Contains("酒店订房"))
                {
                    if (model.Status == 2 || model.Status == 22)//2取消， 22不确认
                    {
                        return "失败订单";
                    }
                    else
                    {
                        return "待完成单";
                    }
                }
                if (model.name.Contains("团购订单"))
                {
                    if (model.Status == 2 ||model.Status == 5) //
                    {
                        return "失败订单";
                    }
                    else
                    {
                        return "待完成单";
                    }
                }
            }
            return "";
        }
        /// <summary>
        /// 获取分销客户列表
        /// </summary>
        /// <param name="MemberID"></param>
        /// <returns></returns>
        public static DataTable GetShareCustomerList(string MemberID, string WeiXinID)
        {
            string sql = @" SELECT Id,promoterid,nickname,weixinID,userWeiXinNO,photo,addtime,TotalCash,CanPutOutCash,HasPutOutCash 
,(select COUNT(1) FROM dbo.T_OrderInfo where isjiesuan=1 and userweixinid=Member.userWeiXinNO and promoterid=Member.promoterid)+
 (select COUNT(1)  from SupermarketOrder_Levi t where  isjiesuan=1 and PayMethod != '积分支付' and t.userweixinID=Member.userWeiXinNO and t.promoterid=Member.promoterid)+
 (select COUNT(1) from HotelOrder where isjiesuan=1 and UserWeiXinID=Member.userWeiXinNO and promoterid=Member.promoterid)+
 (select COUNT(1) from SaleProducts_Orders where isjiesuan=1 and UserWeiXinID=Member.userWeiXinNO and promoterid=Member.promoterid)
 fxNum
,ISNULL((select sum(ISNULL(t.fxmoneyProfit,0))fxmoney from T_OrderInfo t where  isjiesuan=1 and t.userweixinID=Member.userWeiXinNO and t.promoterid=Member.promoterid),0)
+ISNULL((select sum(ISNULL(t.fxmoneyProfit,0))fxmoney from SupermarketOrder_Levi t where  isjiesuan=1 and PayMethod != '积分支付' and t.userweixinID=Member.userWeiXinNO and t.promoterid=Member.promoterid),0)
+ISNULL((select sum(ISNULL(t.fxmoneyProfit,0))fxmoney from HotelOrder t where isjiesuan=1 and UserWeiXinID=Member.userWeiXinNO and promoterid=Member.promoterid and weixinID=Member.weixinID),0)
+ISNULL((select sum(ISNULL(t.fxmoneyProfit,0))fxmoney from SaleProducts_Orders t where isjiesuan=1 and UserWeiXinID=Member.userWeiXinNO and promoterid=Member.promoterid),0)
fxMoney
FROM dbo.Member where promoterid=@MemberID and weixinID=@WeiXinID  order by addtime desc ";
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
               {"MemberID",new DBParam(){ParamValue=MemberID}},
               {"WeiXinID",new DBParam(){ParamValue=WeiXinID}}
            });
        }


        /// <summary>
        /// 获取酒店分销佣金点
        /// </summary>
        public static DataTable GetHotelYongJinLv(string WeiXinID)
        {
            string sql = "select top 1 * from S_HuoDongTianBao_fenxiao  where weixinid=@WeiXinID ";
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
               {"WeiXinID",new DBParam(){ParamValue=WeiXinID}}
            });
        }


        /// <summary>
        /// 佣金保留[给推广员的佣金比例]
        /// </summary>
        /// <returns></returns>
        public static double TuiGuangProfit()
        {
            try
            {
                if (!System.Configuration.ConfigurationManager.AppSettings.AllKeys.Contains("TuiGuangProfit")) {
                    return 0.8;
                }
                string TuiGuangProfitStr = System.Configuration.ConfigurationManager.AppSettings["TuiGuangProfit"].ToString();
                double ProfitError = 0;
                if (double.TryParse(TuiGuangProfitStr, out ProfitError))
                {
                    double TuiGuangProfitNumber = double.Parse(TuiGuangProfitStr);
                    TuiGuangProfitNumber = TuiGuangProfitNumber >= 1 || TuiGuangProfitNumber < 0 ? 0.2 : TuiGuangProfitNumber;
                    if (TuiGuangProfitNumber >= 0 || TuiGuangProfitNumber <= 1)
                    {
                        return TuiGuangProfitNumber;
                    }
                    else
                    {
                        return 0.8;
                    }
                }
            }
            catch { }
            return 0.8;
        }


        /// <summary>
        /// 获取酒店设置的佣金及推广员可实际获得的佣金
        /// </summary>
        /// <param name="TypeValue"></param>
        /// <param name="weixinid"></param>
        /// <param name="Money"></param>
        /// <returns></returns>
        public static TuiGuangMoney GetTuiGuangProfit(this ProfitType TypeValue, string weixinid, string userweixinid, double Money)
        {
            TuiGuangMoney Result = new TuiGuangMoney() { promoterid=0,hotelCommission = 0, userCommission = 0 };

            int promoterid = 0;
            if (!userweixinid.Contains(DAL.PromoterDAL.WX_ShareLinkUserWeiXinId))
            {
                promoterid = MemberCardBuyRecord.GetPromoterid(weixinid, userweixinid);
                if (promoterid <= 0)
                {
                    //不存在推广员id 
                    return Result;
                }
            }

            Result.promoterid = promoterid;
            string sql = "select kefang,canyin,tuangou,chaoshi from S_HuoDongTianBao_fenxiao with(nolock) where  weixinId=@weixinId";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("weixinId", new DBParam { ParamValue = weixinid });
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);
            if (dt == null || dt.Rows.Count <= 0) {
                return Result;
            }

            string kefangStr = dt.Rows[0]["kefang"].ToString();
            string canyinStr = dt.Rows[0]["canyin"].ToString();
            string tuangouStr = dt.Rows[0]["tuangou"].ToString();
            string chaoshiStr = dt.Rows[0]["chaoshi"].ToString();

            int Error = 0;
            double TuiGuangProfitValue = TuiGuangProfit();


            int ProfitValue = 0;
            switch (TypeValue) {
                case ProfitType.kefang:
                    int kefang = int.TryParse(kefangStr, out Error) ? int.Parse(kefangStr) : 0;
                    ProfitValue = kefang;
                    break;

                case ProfitType.canyin:
                    int canyin = int.TryParse(canyinStr, out Error) ? int.Parse(canyinStr) : 0;
                    ProfitValue = canyin;
                    break;
       case ProfitType.tuangou:
                    int tuangou = int.TryParse(tuangouStr, out Error) ? int.Parse(tuangouStr) : 0;
                    ProfitValue = tuangou;
                    break;

       case ProfitType.chaoshi:
                    int chaoshi = int.TryParse(chaoshiStr, out Error) ? int.Parse(chaoshiStr) : 0;
                 ProfitValue=chaoshi;
                    break;
            }
            Result.hotelCommission = Money * ProfitValue / 100;
            Result.userCommission = Result.hotelCommission * TuiGuangProfitValue;
            return Result;

        }
        /// <summary>
        /// 是否已填报红包活动
        /// </summary>
        /// <param name="weixinid"></param>
        /// <returns>return true 填报 </returns>
        public static bool HasSignFor_hongbao(string weixinid)
        {
            string sql = "select top 1 1 from S_HuoDongTianBao_hongbao where weixinid=@weixinid";
            string str = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"weixinid",new DBParam(){ParamValue=weixinid}}
            });
            if (string.IsNullOrEmpty(str)) 
            {
                return false;
            }
            return true;
        }
    }
    /// <summary>
    /// 获取佣金比例的类型
    /// </summary>
    public enum ProfitType {
        kefang,
        canyin,
        tuangou,
        chaoshi
    }
    /// <summary>
    /// 推广佣金
    /// </summary>
    public class TuiGuangMoney {

        public int promoterid { get; set; }
        /// <summary>
        /// 总佣金
        /// </summary>
        public double hotelCommission { get; set; }
        /// <summary>
        /// 实际返佣给推广员的佣金
        /// </summary>
        public double userCommission { get; set; }
    }



    /// <summary>
    /// 申请提现实体
    /// </summary>
    public class MemberFxCashItem
    {
        //id, applymoney, createtime, userweixinid, state, audittime
        public int id { get; set; }
        public decimal applymoney { get; set; }
        public DateTime createtime { get; set; }
        public string userweixinid { get; set; }
        public string weixinid { get; set; }
        public int state { get; set; }
        public DateTime audittime { get; set; }
    }

    /// <summary>
    /// 推广中心实体
    /// </summary>
    public class FxExtensItem 
    {
        public string name { get; set; }
        public string imgurl { get; set; }
        public decimal memberprice { get; set; }
        public int yjingLv { get; set; }
        public decimal yjing { get; set; }
    }

    /// <summary>
    /// 订单分销佣金
    /// </summary>
    public class FxOrderCommission
    {
        public Int64 row { get; set; }
        public string name { get; set; }
        public string orderCode { get; set; }
        public double amount { get; set; }
        public double payamount { get; set; }
        public decimal fxmoney { get; set; }
        public int Status { get; set; }
        public int isjiesuan { get; set; }
        public DateTime createtime { get; set; }
        public string hotelLog { get; set; }
       
    }
    public class FxOrderCommissionV : FxOrderCommission
    {
        public string statusname { get; set; }
    }
    
    public class FxMemberInfo 
    {
        //Id, member.weixinID, userWeiXinNO, mobile, Email, sex, addtime, Emoney, userFlag, nickname, name, cardno, address, 
//pwd, night, photo, idcard, viptype, leveltime, caozuo, balance, ISNULL(TotalCash,0)TotalCash, isnull(CanPutOutCash,0)CanPutOutCash,ISNULL(HasPutOutCash,0)HasPutOutCash
        public int Id { get; set; }
        public string weixinID { get; set; }
        public string userWeiXinNO { get; set; }
        public string mobile { get; set; }
        public string Email { get; set; }
        public string sex { get; set; }
        public DateTime addtime { get; set; }
        public string nickname { get; set; }
        public string name { get; set; }
        public string cardno { get; set; }
        public string address { get; set; }
        public string photo { get; set; }
        public string idcard { get; set; }
        public string viptype { get; set; }
        public decimal TotalCash { get; set; }
        public decimal CanPutOutCash { get; set; }
        public decimal HasPutOutCash { get; set; }
        /// <summary>
        /// 重新计算得到
        /// </summary>
        public decimal TotalCash2 { get; set; }
        /// <summary>
        ///  重新计算得到
        /// </summary>
        public decimal CanPutOutCash2{ get; set; }
        /// <summary>
        ///  重新计算得到
        /// </summary>
        public decimal HasPutOutCash2 { get; set; }
    }
    /// <summary>
    /// 会员中心分销枚举, 
    /// </summary>
    public enum EnumMemberFXStatus
    {
        申请提现 = 0,
        提现申请审核通过 = 1,
        提现申请审核不通过 = 2
    }
}