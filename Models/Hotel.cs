using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace hotel3g.Models
{
    [Serializable]
    public class Hotel
    {
        public int ID { get; set; }
        public string SubName { get; set; }
        public string HotelLog { get; set; }
        public string Address { get; set; }
        public int Cid { get; set; }
        public string Tel { get; set; }
        public int Star { get; set; }
        public int ChainID { get; set; }
        public string openDate { get; set; }
        public string xiuDate { get; set; }
        public string Pos { get; set; }
        public string RoundValue { get; set; }
        public string AddBedPrice { get; set; }
        public string AutoEatingPrice { get; set; }
        public string HuiYi { get; set; }
        public string FuWu { get; set; }
        public string CanYin { get; set; }
        public string YuLe { get; set; }
        public string KeFang { get; set; }
        public double MemberFav { get; set; }
        public double FirstFav { get; set; }
        public string SmsMobile { get; set; }
        public string WeiXinQQ { get; set; }
        public string Content { get; set; }
        public string AdImg { get; set; }
        public double JifenFav { get; set; }
        public string WeiXinID { get; set; }
        public string Quanjing { get; set; }
        public string MainPic { get; set; }
        public string[] StarName = {"经济型酒店","经济型酒店","连锁酒店","三星级酒店","四星级酒店","五星级酒店","酒店式公寓"};
    
        public Hotel() { }
    }
   

}