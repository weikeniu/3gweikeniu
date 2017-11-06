using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WeiXin.Models.Home;

namespace WeiXin.Common
{
    /// <summary>
    /// 储值卡
    /// </summary>
    public class RechargeEntity
    {
    }

    /// <summary>
    /// 储值卡统计信息
    /// </summary>
    public class RechargeTJEntity
    {
        public decimal SaleMoney { get; set; }

        public decimal ConsumeMoney { get; set; }

        public int UserCount { get; set; }
    }



    public class RechargeUserConvert
    {
        public static List<RechargeUser> RechargeConvertMember(List<RechargeUser> list)
        {
            foreach (var item in list)
            {
                int type = 0;
                int.TryParse(item.UserLevel, out type);
                item.UserLevel = ((EnumVipType)type).ToString();
            }
            return list;
        }


    }

    public enum EnumVipType
    {
        普通会员 = 0,
        高级会员 = 1,
        白银会员 = 2,
        黄金会员 = 3,
        钻石会员 = 4

    }





    public class RoomTypeImgEntity
    {
        public string Url { get; set; }

        public int RoomId { get; set; }

        public string Big_url { get; set; }

        public string Small_url { get; set; }

    }
}