using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace hotel3g.Models
{
    [Serializable]
    public class RatePlan
    {
        public int ID { get; set; }
        public string RatePlanName { get; set; }
        public string NetInfo { get; set; }
        public string BedType { get; set; }
        public string ZaoCan { get; set; }
        public int AvgPrice { get; set; }
        public int SumPrice { get; set; }
        public int NonMemSumPrice { get; set; }
        public int AvgNonMemPrice { get; set; }
        public int IsHourRoom { get; set; }
        public int State { get; set; }/*0满房,2部分满,1可订*/
        public string PayType { get; set; }
        public string WarrantCount { get; set; }
        public string WarrantTime { get; set; }
        public double Discount { get; set; }
        public double SumNumPrice { get; set; }
        public double SumNetPrice { get; set; }
        public int guarantee_type { get; set; }
        public string guarantee_start_time { get; set; }
        public List<Rate> Rates { get; set; }
    }
}