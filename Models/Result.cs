using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WeiXin.Models
{
    public class Result
    {
        public bool IsThank { get; set; }
        public bool IsError { get; set; }
        public bool IsWin { get; set; }
        public string WindId { get; set; }
        public string PrizeId { get; set; }
        public string ErrorId { get; set; }
    }
}