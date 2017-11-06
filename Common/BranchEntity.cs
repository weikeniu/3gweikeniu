using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace hotel3g.Common.Branch
{
    public class HotelResponse
    {
       public int  id {get;set;}
       public string WeiXinID {get;set;}
       public string SubName {get;set;}
       public string hotelLog {get;set;}
       public string address {get;set;}
       public int cid {get;set;}
       public int rid {get;set;}
       public string tel {get;set;}
       public int star {get;set;}
       public int chainID {get;set;}
       public string openDate {get;set;}
       public string xiuDate {get;set;}
       public string pos {get;set;}
       public string roundValue {get;set;}
       public string AddBedPrice {get;set;}
       public string AutoEatingPrice {get;set;}
       public string huiyi {get;set;}
       public string fuwu {get;set;}
       public string canyin {get;set;}
       public string yule {get;set;}
       public string kefang {get;set;}
       public string yinhang {get;set;}
       public string smsMobile {get;set;}
       public string weixinQQ {get;set;}
       public string Content {get;set;}
       public string jifenFav {get;set;}
       public int signid {get;set;}
       public string ctripurl {get;set;}
       public string elongurl {get;set;}
       public string qunarurl {get;set;}
       public string tmallhid {get;set;}
       public DateTime addtime {get;set;}
       public string QuanJing {get;set;}
       public int enabled {get;set;}
       public int pid { get; set; }
        //当日最低价格
       public int minprice { get; set; }
       public string small_url { get; set; }
    }
}