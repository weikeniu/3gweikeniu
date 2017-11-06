using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using HotelCloud.SqlServer;
namespace hotel3g.Models
{
    public class CouPon
    {
        public string CouponID { get; set; }
        public string Moneys { get; set; }
        public DateTime sTime { get; set; }
        public DateTime ExtTime { get; set; }
        public string sTimeStr { get; set; }
        public string ExtTimeStr { get; set; }
        public int HaveGet { get; set; }

        public static System.Data.DataTable GetCouPons(string weixinID)
        {
            var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select moneys,qty,sTime,ExtTime,id,Remark,scopelimit,amountlimit from coupon where weixinID=@weixinID and Endable=1 and getdate() between sTime and ExtTime and (select count(*) from couponContent where weixinID=@weixinID and typeID=coupon.id)<qty order by moneys desc", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}}
            });
            return dt;
        }

        public static DataTable GetMoney(string Coupons)
        {
            DataTable dt = new DataTable();
            if (Coupons != "" && Coupons != null)
            {
                string[] CouponList = Coupons.Split(',');

                string sql = string.Empty;
                for (int i = 0; i < CouponList.Length; i++)
                {
                    sql += i > 0 ? " union all " : "";
                    sql += string.Format(@"select top 1 moneys from CouPon with(nolock) where id={0} and CONVERT(date,GETDATE()) between sTime and ExtTime and Endable=1
", CouponList[i]);


                    //
                }
                dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), null);
            }
            return dt;
        }

        public static System.Data.DataTable LoadCouPon(string weixinID, string userweixinID, string couponid)
        {
            var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select top 1 * from couponContent where weixinID=@weixinID and userweixinno=@userweixinno and typeID=@couponid", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
            {"userweixinno",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinID}},
            {"couponid",new HotelCloud.SqlServer.DBParam{ParamValue=couponid}}
            });
            return dt;
        }

        public static System.Data.DataTable GetMyCouPons(string weixinID, string userweixinID, string price)
        {
            var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select  * from couponContent where weixinID=@weixinID and userweixinno=@userweixinno and moneys<@price and IsEmploy=0 and getdate() between sTime and ExtTime", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
            {"userweixinno",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinID}},
            {"price",new HotelCloud.SqlServer.DBParam{ParamValue=price}}
            });
            return dt;
        }


        public static bool GetCouPon(string weixinID, string userweixinID, string couponid, ref string message)
        {
            if (IsHasCouPons(weixinID, couponid))
            {
                if (CheckIshasCouPon(weixinID, userweixinID, couponid))
                {
                    message = "此类优惠券您已经领取过,领取失败！";
                    return false;
                }
                else
                {
                    int r = HotelCloud.SqlServer.SQLHelper.Run_SQL("insert into couponContent(typeid,weixinID,moneys,sTime,ExtTime,CouPonNO,userweixinNo) select top 1  id,weixinID,moneys,sTime,ExtTime,@couponNO,@userweixinNO from coupon where weixinID=@weixinID and id=@couponid", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                    {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
                    {"couponid",new HotelCloud.SqlServer.DBParam{ParamValue=couponid}},
                    {"couponNO",new HotelCloud.SqlServer.DBParam{ParamValue=DateTime.Now.ToString("yyMMddHHmmssfff")}},
                    {"userweixinNO",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinID}}
                    });

                    if (r > 0)
                    {
                        string sql = "update coupon set surplusqty=surplusqty-1 where id=@couponid";
                        SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                        {
                            {"couponid",new HotelCloud.SqlServer.DBParam{ParamValue=couponid}}
                        });
                    }

                    return r > 0;
                }
            }
            else
            {
                message = "优惠券已被领取完，领取失败！";
                return false;
            }
        }

        public static bool CheckIshasCouPon(string weixinID, string userweixinID, string couponid)
        {
            string value = HotelCloud.SqlServer.SQLHelper.Get_Value("select top 1 1 from couponContent where weixinID=@weixinID and userweixinno=@userweixinno and typeID=@couponid", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
            {"userweixinno",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinID}},
            {"couponid",new HotelCloud.SqlServer.DBParam{ParamValue=couponid}}
            });
            return value.Equals("1");
        }

        public static bool IsHasCouPons(string weixinID, string couponid)
        {
            string value = HotelCloud.SqlServer.SQLHelper.Get_Value("select top 1 1 from coupon where weixinID=@weixinID and id=@couponid and qty>(select count(*) from couponContent where weixinID=@weixinID and typeid=@couponid)", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
            {"couponid",new HotelCloud.SqlServer.DBParam{ParamValue=couponid}}
            });
            return value.Equals("1");
        }

        public static System.Data.DataTable GetRoomCoupons(string WeiXinID, string conponsId, string userweixinno)
        {
            System.Data.DataTable dt = new System.Data.DataTable();
            //检查房型是否支持
            //if (!string.IsNullOrEmpty(conponsId))
            //{
            //    string[] id = conponsId.Split(new string[] { "," }, StringSplitOptions.None);
            //    System.Text.StringBuilder sb = new System.Text.StringBuilder("select  * from couponContent where userweixinno=@userweixinno and IsEmploy=0 and getdate() between sTime and ExtTime and typeID in(");
            //    foreach (var item in id)
            //    {
            //        sb.Append(item + ",");
            //    }
            //    sb.Remove(sb.Length - 1, 1).Append(")");
            //    dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sb.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "userweixinno", new HotelCloud.SqlServer.DBParam { ParamValue = userweixinno } } });
            //}

            //判断房型是否支持优惠券
            if (conponsId.Equals("1"))
            {
                string sql = @"select  * from couponContent where userweixinno=@userweixinno AND weixinID=@weixinID and IsEmploy=0 and getdate() between sTime and ExtTime";
                dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "userweixinno", new HotelCloud.SqlServer.DBParam { ParamValue = userweixinno } }, { "weixinID", new HotelCloud.SqlServer.DBParam { ParamValue = WeiXinID } } });
            }

            return dt;
        }

        /// <summary>
        /// 获取用户红包列表
        /// </summary>
        /// <param name="weixinID"></param>
        /// <param name="userweixinNo"></param>
        /// <param name="scopelimit"></param>
        /// <returns></returns>
        public static DataTable GetUserCouPonDataTable(string weixinID, string userweixinNo, string scopelimit)
        {
            string sql = @"select cc.id,cc.moneys,cc.sTime,cc.ExtTime,ISNULL(c.amountlimit,0) as amountlimit
                       from CouPonContent cc, CouPon c where cc.typeID=c.id
                      and cc.weixinID=@weixinID and cc.userweixinNo=@userweixinNo
                      and c.scopelimit like '%'+@scopelimit+'%' and c.Endable = 1
                      and cc.ExtTime > GETDATE() and cc.IsEmploy=0
                        ";
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(),
                new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                { "weixinID", new HotelCloud.SqlServer.DBParam { ParamValue = weixinID } },
                { "userweixinNo", new HotelCloud.SqlServer.DBParam { ParamValue = userweixinNo } },
                { "scopelimit", new HotelCloud.SqlServer.DBParam { ParamValue = scopelimit } }
                });

            return dt;
        }

        /// <summary>
        /// 超市使用红包后更新记录
        /// </summary>
        /// <param name="id"></param>
        /// <param name="OrderID"></param>
        /// <returns></returns>
        public int UpdateCouponEmploy(string id, string OrderID)
        {
            lock (this)
            {
                string sql = @"update [WeiXin].[dbo].[CouPonContent] set [IsEmploy] = 1,EmployTime = GETDATE(), OrderNO=@OrderID where id=@id";

                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"id",new DBParam(){ParamValue=id}},
                        {"OrderID",new DBParam(){ParamValue=OrderID}}
                    });
            }
        }

        /// <summary>
        /// 红包取消使用
        /// </summary>
        /// <param name="id"></param>
        /// <param name="OrderID"></param>
        /// <returns></returns>
        public int UpdateCouponNotEmploy(string id, string OrderID)
        {
            lock (this)
            {
                string sql = @"update [WeiXin].[dbo].[CouPonContent] set [IsEmploy] = 0 where id=@id";

                return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"id",new DBParam(){ParamValue=id}},
                        {"OrderID",new DBParam(){ParamValue=OrderID}}
                    });
            }
        }
    }
}