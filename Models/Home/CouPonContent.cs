using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HotelCloud.SqlServer;

namespace WeiXin.Models.Home
{
    public class CouPonContent
    {
        public int Id { get; set; }
        public int Moneys { get; set; }
        public DateTime sTime { get; set; }
        public DateTime ExtTime { get; set; }

        public int AmountLimit { get; set; }


        /// <summary>
        /// 判断红包是否可以使用
        /// </summary>
        /// <param name="weixinId"></param>
        /// <param name="userweixinId"></param>
        /// <param name="couponId"></param>
        /// <returns></returns>
        public static bool IsCouPonContentEnable(string weixinId, string userweixinId, int couponId)
        {
            string sqls = @"select  count(*) from couponcontent with (nolock) where  id=@couponid and weixinid=@weixinid and 
            userweixinno=@userweixinid  and  isemploy=0 and convert(date,getdate())>=stime and exttime>=convert(date,getdate())  ";

            string str = SQLHelper.Get_Value(sqls, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                         {"weixinid",new DBParam(){ParamValue=weixinId}},
                         {"userweixinid",new DBParam(){ParamValue=userweixinId}},
                         {"couponid",new DBParam(){ParamValue=couponId.ToString()}}
                    });


            int count = 0;
            int.TryParse(str , out count);

            if (count > 0)
            {
                return true;
            }
            return false;

        }

    }

}
