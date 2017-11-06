using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using HotelCloud.SqlServer;

namespace hotel3g.Models
{
    public class UserGuarantee
    {
        public string GID { get; set; }
        public string OrderNo { get; set; }
        public string HotelId { get; set; }
        public string BankType { get; set; }
        public string BankCardNo { get; set; }
        public string BankCVV { get; set; }
        public string ValidTime { get; set; }
        public string Cardholder { get; set; }
        public string IdentityCard { get; set; }
        public string IdentityType { get; set; }

        public static void SaveUserGuarantee(UserGuarantee uguarantee)
        {
            string str = "insert into UserGuarantee(orderNo,hotelId,bankType,bankCardNo,bankCVV,validTime,cardholder,identityCard,identityType,remark,createDate,modifiedDate) values(@orderNo,@hotelId,@bankType,@bankCardNo,@bankCVV,@validTime,@cardholder,@identityCard,@identityType,@remark,@datetime,@datetime)";
            int result = SQLHelper.Run_SQL(str, SQLHelper.GetCon(), new Dictionary<string, DBParam> { 
            { "orderNo", new DBParam { ParamValue = uguarantee.OrderNo } }, 
            { "hotelId", new DBParam { ParamValue = uguarantee.HotelId } }, 
            { "bankType", new DBParam { ParamValue = uguarantee.BankType } }, 
            { "bankCardNo", new DBParam { ParamValue = uguarantee.BankCardNo } }, 
            { "bankCVV", new DBParam { ParamValue = uguarantee.BankCVV } }, 
            { "validTime", new DBParam { ParamValue = uguarantee.ValidTime } },
            { "cardholder", new DBParam { ParamValue = uguarantee.Cardholder } }, 
            { "identityCard", new DBParam { ParamValue = uguarantee.IdentityCard } },
            { "identityType", new DBParam { ParamValue = uguarantee.IdentityType } },
            { "remark", new DBParam { ParamValue = string.Empty } },
            { "datetime", new DBParam { ParamValue = DateTime.Now.ToString() } }
            });
        }
    }
}