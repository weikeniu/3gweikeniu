using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;

namespace hotel3g.Models
{
    [Serializable]
    public class Rate
    {
        public int Price { get; set; }
        public DateTime Dates { get; set; }
        public int Available { get; set; }
        public int NoMemPrice { get; set; }
        public double NetPrice { get; set; }
        public double NumPrice { get; set; }


        public static DataTable GetRates(string rateplanid, string indate, string outdate)
        {
            string str = "select * from HotelRate where RatePlanID=@rateplanid and dates between @indate and @outdate";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(str, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "rateplanid", new HotelCloud.SqlServer.DBParam { ParamValue = rateplanid } }, { "indate", new HotelCloud.SqlServer.DBParam { ParamValue = indate } }, { "outdate", new HotelCloud.SqlServer.DBParam { ParamValue = outdate } } });
            return dt;
        }
    }
}