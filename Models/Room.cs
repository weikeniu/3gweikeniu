using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace hotel3g.Models
{
    [Serializable]
    public class Room
    {
        public int ID { get; set; }
        public string RoomName { get; set; }
        public string BedArea { get; set; }
        public string Area { get; set; }
        public string Floor { get; set; }
        public string NetType { get; set; }
        public string BedType { get; set; }
        public string Remark { get; set; }
        public string Img { get; set; }
        public string Window { get; set; }
        public string CouponsID { get; set; }
        public string AddBed { get; set; }
        public int RoomTypeId { get; set; }
        public int IsChildRoom { get; set; }
        public List<RatePlan> RatePlans { get; set; }
        public List<CouPon> Coupons { get; set; }
        public List<string> RoomTypeImgs { get; set; }
    }
}