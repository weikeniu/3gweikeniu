using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HotelCloud.SqlServer;
using System.Reflection;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.Net;

namespace hotel3g.Models
{
    public class BonusCouponsService
    {
        public string conn = System.Configuration.ConfigurationManager.ConnectionStrings["sqlserver"].ToString();
        //验证用户授权 
        public string BackUrl(string Key) {
            string url = string.Format("https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx6a8acea8df16a84b&redirect_uri=http%3a%2f%2fhotel.weikeniu.com%2fBonusCoupons%2fgrapCouponWeixinInit%3fkey%3dgh_7a64caf61dff%402&response_type=code&scope=snsapi_userinfo&state=" + Key + "#wechat_redirect");
            return url;
        }
   
        //拉去用户微信信息
        public UserWeiXin UserInfo(string Code)
        {
            UserWeiXin weixin = new UserWeiXin();
            weixin.Code = Code;
            string Url = @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx6a8acea8df16a84b&secret=c8f1d6de36c0c75711a6052b3b3159b1&code=" + weixin.Code + @"&grant_type=authorization_code";
            JObject json = GetJson(Url);
            weixin.Access_Token = json["access_token"].ToString().Trim().Replace("\"", "");
            weixin.OpenId = json["openid"].ToString().Trim().Replace("\"", "");
            Url = @"https://api.weixin.qq.com/sns/userinfo?access_token=" + weixin.Access_Token + "&openid=" + weixin.OpenId + "&lang=zh_CN";
            JObject UserInfo = GetJson(Url);
            weixin.Province = UserInfo["province"].ToString();
            weixin.City = UserInfo["city"].ToString();
            weixin.Country = UserInfo["country"].ToString();
            weixin.NickName = UserInfo["nickname"].ToString();
            weixin.HeadImgUrl = UserInfo["headimgurl"].ToString();
            weixin.Sex = UserInfo["sex"].ToString();
             
            return weixin;
        }

        public JObject GetJson(string Url)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(Url);
            request.Method = "GET";
            // 添加header
            System.Net.HttpWebResponse response;
            response = (System.Net.HttpWebResponse)request.GetResponse();
            System.IO.Stream s;
            s = response.GetResponseStream();
            System.IO.StreamReader Reader = new System.IO.StreamReader(s, System.Text.Encoding.UTF8);
            object json = JsonConvert.DeserializeObject(Reader.ReadToEnd());
            JObject jo = (JObject)json;
            return jo;
        }

        public bool NotReceive(string[] IDS, string weixinUserID)
        {
            try {
                string sql = @"SELECT count(0) FROM UserRadomCoupons_wkn WITH(NOLOCK) WHERE id=@id AND weixinID=@weixinID  AND weixinUserID=@weixinUserID";
            string Value= SQLHelper.Get_Value(sql, SQLHelper.Open_Conn(conn), new Dictionary<string, DBParam> { 
            {"id",new DBParam{ParamValue=IDS[1]}},
            {"weixinID",new DBParam{ParamValue=IDS[0]}},
            {"weixinUserID",new DBParam{ParamValue=weixinUserID}}
            });
            
            return Convert.ToInt32(Value)>0?false:true;
            }
            catch { return false; }
            return true;
        }

        //判断奖券是否存在
        public bool CouPonIsExists(string[] IDS) {
            string sql = @"SELECT count(0) FROM RandomCoupon_wkn with(NOLOCK) WHERE id=@id AND weixinID=@weixinID";
            string value = SQLHelper.Get_Value(sql, SQLHelper.Open_Conn(conn), new Dictionary<string, DBParam> { 
            {"id",new DBParam{ParamValue=IDS[1]}},
            {"weixinID",new DBParam{ParamValue=IDS[0]}}
            });
            return Convert.ToInt32(value) > 0 ? true : false;
        }

        //获取奖券信息
        public Coupon_Random RandomAmount(string[] key)
        {

            string sql = @"
select top 1
[id],[weixinID],[TotalAmount],[UsedAmount] ,[sTime] ,[eTime],[AddTime],[MaxReceive]
from [RandomCoupon_wkn] with(nolock)
  where [Enable]=1 and getdate() between [sTime] and [eTime] AND id
  =@id
";
            var dt = SQLHelper.Get_DataTable(sql, SQLHelper.Open_Conn(conn), new Dictionary<string, DBParam> { 
            {"weixinID",new DBParam{ParamValue=key[0]}},
            {"id",new DBParam{ParamValue=key[1]}}
            });
            return ToListEmpty.ToList<Coupon_Random>(dt)[0];
        }

        //整合随机获取的奖金信息
        public Coupon_Random GetBonus(Coupon_Random CounponDetail, UserWeiXin User)
        {
            int MaxValue = CounponDetail.MaxReceive;
            int RandomMoney = new Random().Next(1, MaxValue);

            RandomMoney = CounponDetail.TotalAmount - CounponDetail.UsedAmount > RandomMoney ? RandomMoney : CounponDetail.TotalAmount - CounponDetail.UsedAmount;
            Coupon_Random Detail = new Coupon_Random();
            Detail.id = CounponDetail.id;
            Detail.weixinID = CounponDetail.weixinID;
            Detail.Price = RandomMoney;
            Detail.sTime = CounponDetail.sTime;
            Detail.eTime = CounponDetail.eTime;

            Detail.weixinUserID = User.OpenId;
            Detail.Province = User.Province;
            Detail.City = User.City;
            Detail.Country = User.Country;
            Detail.NickName = User.NickName;
            Detail.UserImg = User.HeadImgUrl;
            Detail.Sex = User.Sex;

            return Detail;
        }

        //提交奖金信息
        public bool SaveInfo(Coupon_Random Info)
        {
            try {
            #region
            string sql = @"
INSERT INTO [WeiXin].[dbo].[UserRadomCoupons_wkn]
           ([id]
           ,[weixinID]
           ,[weixinUserID]
           ,[Price]
           ,[sTime]
           ,[eTime]
           ,[UserImg]
           ,[Province]
           ,[City]
           ,[Country]
           ,[Sex]
           ,[NickName]
           ,[TelPhone]
)
     VALUES
           (@id
           ,@weixinID
           ,@weixinUserID
           ,@Price
           ,@sTime
           ,@eTime
           ,@UserImg
           ,@Province
           ,@City
           ,@Country
           ,@Sex
           ,@NickName
           ,@TelPhone
)
";
            #endregion

            SQLHelper.Run_SQL(sql, SQLHelper.Open_Conn(conn), new Dictionary<string, DBParam> { 
            {"id",new DBParam{ParamValue=Info.id.ToString()}},
            {"weixinID",new DBParam{ParamValue=Info.weixinID}},
            {"weixinUserID",new DBParam{ParamValue=Info.weixinUserID}},
            {"Price",new DBParam{ParamValue=Info.Price.ToString()}},
            {"sTime",new DBParam{ParamValue=Info.sTime.ToString()}},
            {"eTime",new DBParam{ParamValue=Info.eTime.ToString()}},
            {"UserImg",new DBParam{ParamValue=Info.UserImg}},
            {"Province",new DBParam{ParamValue=Info.Province}},
            {"City",new DBParam{ParamValue=Info.City}},
            {"Country",new DBParam{ParamValue=Info.Country}},
            {"Sex",new DBParam{ParamValue=Info.Sex}},
            {"NickName",new DBParam{ParamValue=Info.NickName}},
            {"TelPhone",new DBParam{ParamValue=Info.TelPhone}}
            });

            return true;
            }
            catch {
                
            }
            return false;
        }

        //获取当前已领取用户
        public List<UserWeiXin> ReceiveUsers(string[] IDS)
        {
        
            string sql = @"select NickName,AddTime,UserImg,Price FROM UserRadomCoupons_wkn with(nolock) WHERE id=@id AND weixinID=@weixinID   ORDER BY AddTime DESC";
            System.Data.DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.Open_Conn(conn), new Dictionary<string, DBParam> { 
            {"id",new DBParam{ParamValue=IDS[1].ToString()}},
            {"weixinID",new DBParam{ParamValue=IDS[0].ToString()}}
            });
            List<UserWeiXin> List = new List<UserWeiXin>();
            foreach (System.Data.DataRow row in dt.Rows) {
                UserWeiXin Item = new UserWeiXin();
                Item.NickName = row["NickName"].ToString();
                Item.AddTime = row["AddTime"].ToString();
                Item.HeadImgUrl = row["UserImg"].ToString();
                Item.Price = row["Price"].ToString();
                List.Add(Item);
            }
            return List;
        }

        //发送验证短信

    }

    public class Coupon_Random
    {
        public int id { get; set; }
        public string weixinID { get; set; }
        public int TotalAmount { get; set; }
        public int UsedAmount { get; set; }
        public DateTime sTime { get; set; }
        public DateTime eTime { get; set; }
        public DateTime AddTime { get; set; }
        public int MaxReceive { get; set; }
        public int Enable { get; set; }
        public string TelPhone { get; set; }

        //领取的奖券
        public string weixinUserID { get; set; }
        public int Price { get; set; }
        public string UserImg { get; set; }
        public string NickName { get; set; }
        public string Province { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        public string Sex { get; set; }
    }

    public class UserWeiXin
    {
        public string Code { get; set; }
        public string OpenId { get; set; }
        public string Access_Token { get; set; }
        public string HeadImgUrl { get; set; }
        public string Province { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        public string NickName { get; set; }
        public string Sex { get; set; }
        public string AddTime { get; set; }
        public string Price { get; set; }

    }
    public static class ToListEmpty
    {
        public static List<T> ToList<T>(this System.Data.DataTable dt) where T : class,new()
        {
            Type type = typeof(T);
            List<T> list = new List<T>();
            string tempName = string.Empty;
            foreach (System.Data.DataRow row in dt.Rows)
            {
                PropertyInfo[] pArray = type.GetProperties();
                T entity = new T();
                foreach (PropertyInfo p in pArray)
                {
                    tempName = p.Name;
                    if (dt.Columns.Contains(tempName))
                    {
                        if (!p.CanWrite) continue;
                        object value = row[tempName];
                        if (value != DBNull.Value) p.SetValue(entity, value, null);
                    }
                }
                list.Add(entity);
            }
            return list;
        }
    }
}