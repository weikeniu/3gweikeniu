using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HotelCloud.SqlServer;
using System.Data;
using System.Net;
using System.IO;
using System.Text;
using WeiXin.Models.Home;
using HotelCloud.SMS;
using hotel3g.Models.Home;

namespace hotel3g.Repository
{
    public static class MemberHelper
    {
        public static MemberCard GetMemberCardByUserWeiXinNO(string WeiXinID, string UserWeiXinId)
        {
            string sql = string.Format(@"SELECT TOP 1 a.id as memberid,a.cardno,a.Emoney as jifen,a.night,a.address,a.mobile AS phone,a.name,a.sex,a.email,a.photo,a.nickname,a.viptype FROM WeiXin.dbo.Member AS a WITH(NOLOCK)
WHERE a.WeiXinID=@WeiXinID and  a.userWeiXinNO=@userWeiXinNO");



            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"userWeiXinNO",new DBParam{ParamValue=UserWeiXinId}},
            {"WeiXinID",new DBParam{ParamValue=WeiXinID}}
            });
            MemberCard MemberCardInfo = new MemberCard();
            foreach (DataRow row in dt.Rows)
            {
                MemberCardInfo.memberid = row["memberid"].ToString();
                MemberCardInfo.night = int.Parse(string.IsNullOrEmpty(row["night"].ToString()) ? "0" : row["night"].ToString());

                MemberCardInfo.address = row["address"].ToString();
                MemberCardInfo.phone = row["phone"].ToString();
                MemberCardInfo.name = row["name"].ToString();
                MemberCardInfo.sex = row["sex"].ToString();
                MemberCardInfo.email = row["email"].ToString();
                MemberCardInfo.photo = row["photo"].ToString();
                MemberCardInfo.nickname = row["nickname"].ToString();
                MemberCardInfo.viptype = int.Parse(string.IsNullOrEmpty(row["viptype"].ToString()) ? "0" : row["viptype"].ToString());
            }
            return MemberCardInfo;
        }
        public static MemberInfo GetMemberInfo(string WeiXinID)
        {
            string sql = @" SELECT hid ,backgroud,vip0,vip1, vip2,vip3 , vip4,vip0rate,vip1rate ,vip2rate,vip3rate,vip4rate,term,equivalence,cardname,vip0plus,vip1plus,vip2plus,vip3plus,vip4plus,intro,[gift],[autoadd],[giftnum],weixinId,CardLogo FROM dbo.MemberCardDeatil WITH(NOLOCK) WHERE WeiXinID=@WeiXinID
";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"WeiXinID",new DBParam{ParamValue=WeiXinID}}
            });
            MemberInfo Info = new MemberInfo();
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    Info.hid = row["hid"].ToString();
                    Info.backgroud = row["backgroud"].ToString();
                    Info.vip0 = int.Parse(row["vip0"].ToString());
                    Info.vip1 = int.Parse(row["vip1"].ToString());
                    Info.vip2 = int.Parse(row["vip2"].ToString());
                    Info.vip3 = int.Parse(row["vip3"].ToString());
                    Info.vip4 = int.Parse(row["vip4"].ToString());
                    Info.vip0rate = decimal.Parse(row["vip0rate"].ToString());
                    Info.vip1rate = decimal.Parse(row["vip1rate"].ToString());
                    Info.vip2rate = decimal.Parse(row["vip2rate"].ToString());
                    Info.vip3rate = decimal.Parse(row["vip3rate"].ToString());
                    Info.vip4rate = decimal.Parse(row["vip4rate"].ToString());
                    Info.term = int.Parse(row["term"].ToString());
                    Info.equivalence = int.Parse(row["equivalence"].ToString());
                    Info.cardname = row["cardname"].ToString();
                    Info.vip0plus = decimal.Parse(row["vip0plus"].ToString());
                    Info.vip1plus = decimal.Parse(row["vip1plus"].ToString());
                    Info.vip2plus = decimal.Parse(row["vip2plus"].ToString());
                    Info.vip3plus = decimal.Parse(row["vip3plus"].ToString());
                    Info.vip4plus = decimal.Parse(row["vip4plus"].ToString());
                    Info.intro = row["intro"].ToString();
                    Info.weixinId = row["weixinId"].ToString();
                    Info.CardLogo = row["CardLogo"].ToString();

                    int gift = string.IsNullOrEmpty(row["gift"].ToString()) ? 0 : int.Parse(row["gift"].ToString());
                    int autoadd = string.IsNullOrEmpty(row["autoadd"].ToString()) ? 0 : int.Parse(row["autoadd"].ToString());
                    int giftnum = string.IsNullOrEmpty(row["giftnum"].ToString()) ? 0 : int.Parse(row["giftnum"].ToString());
                    Info.gift = gift;
                    Info.autoadd = autoadd;
                    Info.giftnum = giftnum;
                    return Info;
                }
                return null;
            }
            else
            {
                return null;
            }
        }
        public static string GetCardNo(string userWeiXinNO, string weixinID)
        {
            if (string.IsNullOrEmpty(weixinID))
            {
                return "";
            }
            string sql = @"
SELECT TOP 1 cardno FROM dbo.Member WITH(NOLOCK) WHERE    weixinID=@weixinID and userWeiXinNO=@userWeiXinNO";
            string value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"userWeiXinNO",new DBParam{ParamValue=userWeiXinNO}},
           {"weixinID",new DBParam{ParamValue=weixinID}}
            });
            return value;

        }
        public static MemberCard GetMemberCard(string CardNo, string WeiXinID)
        {

            string sql = string.Format(@"SELECT TOP 1 a.id as memberid,b.hid,a.cardno,b.isuse,b.adddate,b.binddate,a.Emoney as jifen,b.money,a.night,b.enabled,a.address,a.mobile AS phone,a.name,b.caozuo,a.sex,a.email,a.photo,a.nickname,a.viptype FROM dbo.Member AS a WITH(NOLOCK)
LEFT JOIN 
dbo.MemberCard AS b WITH(NOLOCK) ON a.cardno=b.cardno
WHERE b.WeiXinID=@WeiXinID and 
b.enabled=1 AND a.cardno=@cardno ");


            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"cardno",new DBParam{ParamValue=CardNo}},
            {"WeiXinID",new DBParam{ParamValue=WeiXinID}}
            });
            MemberCard MemberCardInfo = new MemberCard();
            foreach (DataRow row in dt.Rows)
            {
                MemberCardInfo.memberid = row["memberid"].ToString();
                MemberCardInfo.hid = int.Parse(row["hid"].ToString());
                MemberCardInfo.cardno = row["cardno"].ToString();
                MemberCardInfo.isuse = int.Parse(row["isuse"].ToString());
                MemberCardInfo.adddate = DateTime.Parse(row["adddate"].ToString());
                MemberCardInfo.binddate = row["binddate"].ToString();
                MemberCardInfo.jifen = int.Parse(row["jifen"].ToString());
                MemberCardInfo.money = decimal.Parse(string.IsNullOrEmpty(row["money"].ToString()) ? "0" : row["money"].ToString());
                MemberCardInfo.night = int.Parse(string.IsNullOrEmpty(row["night"].ToString()) ? "0" : row["night"].ToString());
                MemberCardInfo.enabled = int.Parse(row["enabled"].ToString());
                MemberCardInfo.address = row["address"].ToString();
                MemberCardInfo.phone = row["phone"].ToString();
                MemberCardInfo.name = row["name"].ToString();
                MemberCardInfo.sex = row["sex"].ToString();
                MemberCardInfo.email = row["email"].ToString();
                MemberCardInfo.photo = row["photo"].ToString();
                MemberCardInfo.nickname = row["nickname"].ToString();
                MemberCardInfo.viptype = int.Parse(string.IsNullOrEmpty(row["viptype"].ToString()) ? "0" : row["viptype"].ToString());
            }
            return MemberCardInfo;
        }

        public static MemberCard GetFXMemberCard(string userWeiXinNO, string WeiXinID)
        {

            string sql = string.Format(@"SELECT TOP 1 a.id as memberid,a.cardno,a.Emoney as jifen,a.night,a.address,a.mobile AS phone,a.name,a.sex,a.email,a.photo,a.nickname,a.viptype FROM dbo.Member as a WITH(NOLOCK)
WHERE WeiXinID=@WeiXinID AND a.userWeiXinNO=@userWeiXinNO ");


            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"userWeiXinNO",new DBParam{ParamValue=userWeiXinNO}},
            {"WeiXinID",new DBParam{ParamValue=WeiXinID}}
            });
            MemberCard MemberCardInfo = new MemberCard();
            foreach (DataRow row in dt.Rows)
            {
                MemberCardInfo.memberid = row["memberid"].ToString();

                MemberCardInfo.jifen = int.Parse(row["jifen"].ToString());

                MemberCardInfo.night = int.Parse(string.IsNullOrEmpty(row["night"].ToString()) ? "0" : row["night"].ToString());

                MemberCardInfo.address = row["address"].ToString();
                MemberCardInfo.phone = row["phone"].ToString();
                MemberCardInfo.name = row["name"].ToString();
                MemberCardInfo.sex = row["sex"].ToString();
                MemberCardInfo.email = row["email"].ToString();
                MemberCardInfo.photo = row["photo"].ToString();
                MemberCardInfo.nickname = row["nickname"].ToString();
                MemberCardInfo.viptype = int.Parse(string.IsNullOrEmpty(row["viptype"].ToString()) ? "0" : row["viptype"].ToString());
            }

            return MemberCardInfo;
        }

        public static int GetPromoterID(string userWeiXinNO, string WeiXinID)
        {
            string sql = "SELECT promoterid FROM dbo.Member WHERE weixinID=@weixinID AND userWeiXinNO=@userWeiXinNO";
            string value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"WeiXinID",new DBParam{ParamValue=WeiXinID}},
              {"userWeiXinNO",new DBParam{ParamValue=userWeiXinNO}}
            });
            if (string.IsNullOrEmpty(value)) {
                value = "0";
            }
            return int.Parse(value);
        }

        public static decimal GetDiscountByRatePlanID(string rateplanid, string hid)
        {
            string sql = @"SELECT TOP 1 Discount FROM dbo.HotelRatePlan WHERE id=@id and HotelID=@hid";
            string value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"id",new DBParam{ParamValue=rateplanid}},
            {"hid",new DBParam{ParamValue=hid}}

            });
            if (string.IsNullOrEmpty(value) || decimal.Parse(value) == 0)
            {
                return decimal.Parse("1.00");
            }
            else
            {
                return decimal.Parse(value);
            }
        }
        public static string BindMemberCardByWeiXinID(string WeiXinID, string userweixinid, string CardNo, int hid)
        {
            string sql = "SELECT cardno FROM dbo.Member WITH(NOLOCK) WHERE weixinID=@weixinID AND userWeiXinNO=@userWeiXinNO";
            string value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"weixinID",new DBParam{ParamValue=WeiXinID}},
             {"userWeiXinNO",new DBParam{ParamValue=userweixinid}}

            });
            if (!string.IsNullOrEmpty(value))
            {
                return "该会员存在会员卡绑定记录";
            }
            else
            {
                sql = @"UPDATE  dbo.Member SET cardno=@cardno WHERE  weixinID=@weixinID AND userWeiXinNO=@userWeiXinNO";
                int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                 {"cardno",new DBParam{ParamValue=CardNo}},
            {"weixinID",new DBParam{ParamValue=WeiXinID}},
             {"userWeiXinNO",new DBParam{ParamValue=userweixinid}}
             });

                if (Count > 0)
                {
                    sql = @"UPDATE  dbo.MemberCard SET isuse=1 WHERE  cardno=@cardno and WeiXinID=@WeiXinID ";
                    SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"cardno",new DBParam{ParamValue=CardNo}},
             {"hid",new DBParam{ParamValue=hid.ToString()}}
             });
                    return "绑定成功";
                }
                else
                {
                    return "绑定失败";
                }
            }
        }
        public static string GetNotUsedCard(string hid, string WeiXinID)
        {
            string sql = @"SELECT TOP 1 cardno FROM dbo.MemberCard WHERE WeiXinID=@WeiXinID AND isuse=0 and enabled=1 ORDER BY NEWID()";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("WeiXinID", new DBParam { ParamValue = WeiXinID });

            string value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), Dic);


            //已无会员卡 可使用 自动生成一张
            if (string.IsNullOrEmpty(value))
            {
                // sql = @"SELECT TOP 1 isnull(autoadd,0) FROM dbo.MemberCardDeatil WITH(NOLOCK) WHERE WeiXinID=@WeiXinID";
                // //sql = @"SELECT TOP 1 autoadd FROM dbo.MemberCardDeatil WITH(NOLOCK) WHERE WeiXinID=@WeiXinID";
                // string autoadd = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), Dic);
                // if (string.IsNullOrEmpty(autoadd)) {
                //     //如果没有会员卡信息 则默认自动添加会员卡
                //     autoadd = "1";
                // }

                string autoadd = "1";
                //判断酒店设置
                if (int.Parse(autoadd) == 1)
                {
                    string TimeStr = DateTime.Now.ToString("yyMMddHHss");
                    string newCardNo = (TimeStr).ToString().PadLeft(10, '0'); ;
                    if (string.IsNullOrEmpty(hid) || hid.Equals("0"))
                    {
                        hid = DateTime.Now.ToString("yMdHm");
                    }
                    string cardno = string.Format("{0}{1}", hid.ToString(), newCardNo);
                    sql = string.Format(@"INSERT INTO [WeiXin].[dbo].[MemberCard] ([hid] ,[cardno],[caozuo] ,[WeiXinID]) VALUES({0},'{1}','{2}','{3}');
", hid, cardno, "注册自动生成", WeiXinID);
                    int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), null);
                    if (Count > 0)
                    {
                        //新增成功 返回新卡
                        return cardno;
                    }
                }
            }
            return value;
        }
        public static int Register(string CardNo, string WeiXinID, string UserWeiXinID, string Phone, string Pwd, string UserName, string strVipType="")
        {
            string where = string.Empty;
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("weixinID", new DBParam { ParamValue = WeiXinID });
            Dic.Add("CardNo", new DBParam { ParamValue = CardNo });
            Dic.Add("userWeiXinNO", new DBParam { ParamValue = UserWeiXinID });
            Dic.Add("Phone", new DBParam { ParamValue = Phone });
            //Dic.Add("pwd", new DBParam { ParamValue = Pwd });
            Dic.Add("name", new DBParam { ParamValue = UserName });

            string sql = @"
SELECT COUNT(0) FROM dbo.Member AS a WITH(NOLOCK) WHERE a.mobile=@Phone and weixinID=@weixinID  AND userWeiXinNO!=@userWeiXinNO";

            int Count = int.Parse(SQLHelper.Get_Value(sql, SQLHelper.GetCon(), Dic));
            if (Count > 0)
            {
                return 0;
            }
            else
            {
                sql =string.Format(@"
UPDATE dbo.Member SET mobile=@Phone,cardno=@CardNo,name=@name {0} WHERE isnull(cardno,'')='' AND
weixinID=@weixinID AND userWeiXinNO=@userWeiXinNO ", strVipType);
                Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);

                if (Count > 0)
                {
                    sql = @"UPDATE dbo.MemberCard SET isuse=1,binddate=GETDATE()  WHERE cardno=@CardNo";
                    SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);
                }
                return Count;
            }
        }
        public static List<JifenItem> GetJifenDeatil(string WeiXinID, string UserWeiXinID, string hid, int page, string cardno)
        {
            MemberInfo Info = GetMemberInfo(hid);
            if (Info == null)
            {
                Info = new MemberInfo() { term = 1 };
            }
            string sql = string.Format(@"SELECT TOP {0} *  FROM (SELECT ROW_NUMBER() OVER(ORDER BY AddTime DESC
) AS row,OrderID,WeiXinID,UserWeiXinID,JiFen,AddTime,Remark,night FROM dbo.JiFenDetail WITH(NOLOCK)
 WHERE WeiXinID=@WeiXinID AND UserWeiXinID=@UserWeiXinID AND cardno=@cardno AND (status=1 OR remark='超市使用积分') AND  DATEDIFF(year,AddTime,GETDATE())<=@term 
)AS t  WHERE t.row>@row", (page + 1) * 10);
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"WeiXinID",new DBParam{ParamValue=WeiXinID}},
            {"UserWeiXinID",new DBParam{ParamValue=UserWeiXinID}},
{"term",new DBParam{ParamValue=Info.term.ToString()}},
{"row",new DBParam{ParamValue=(page*10).ToString()}},
{"cardno",new DBParam{ParamValue=cardno}}
            });
            List<JifenItem> Result = new List<JifenItem>();
            foreach (DataRow row in dt.Rows)
            {
                JifenItem Item = new JifenItem();
                Item.OrderID = int.Parse(row["OrderID"].ToString());
                Item.night = int.Parse(row["night"].ToString());
                Item.JiFen = int.Parse(row["JiFen"].ToString());
                Item.AddTime = DateTime.Parse(row["AddTime"].ToString()).ToString("yyyy/MM/dd HH:mm:ss");
                Item.Remark = row["Remark"].ToString().Replace("(后台)", "");
                Item.UserWeiXinID = row["Remark"].ToString();
                Item.WeiXinID = row["WeiXinID"].ToString();
                Result.Add(Item);
            }
            return Result;
        }
        public static int UpdateCardInfoByCardNo(string CardNo, string name, string sex, string email, string address)
        {
            string sql = @"UPDATE dbo.Member SET name=@name,sex=@sex,Email=@email,address=@address where cardno=@cardno";
            int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"cardno",new DBParam{ParamValue=CardNo}},
            {"name",new DBParam{ParamValue=name}},
            {"sex",new DBParam{ParamValue=sex}},
            {"email",new DBParam{ParamValue=email}},
            {"address",new DBParam{ParamValue=address}}
            });

            return Count;
        }
        public static int GetLastSendMsgTime(string Phone)
        {
            //string sql = @"SELECT  TOP 1 DATEDIFF(SECOND,SendTime,GETDATE()) FROM Tasks WHERE mobile=@mobile AND TaskContent LIKE '%您的验证码为%' ORDER BY SendTime DESC";
            string sql = "SELECT  TOP 1 DATEDIFF(SECOND,Addtime,GETDATE()) FROM dbo.wkn_smssend WHERE mobile=@mobile AND Channel='用户注册修改' ORDER BY Addtime DESC";

            string Value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"mobile",new DBParam{ParamValue=Phone}}
            });
            int second = int.Parse(string.IsNullOrEmpty(Value) ? "31" : Value);
            return second;
        }
        public static int GetSendNumWithThreeHour(string Phone, string weixinid)
        {
            string sql = @"SELECT COUNT(0) AS sendnum,(180-DATEDIFF(minute,MAX(Addtime),GETDATE())) AS hastime  FROM dbo.wkn_smssend WITH(NOLOCK) WHERE WeiXinID=@WeiXinID AND Mobile=@Mobile AND Channel='用户注册修改' AND DATEDIFF(minute,Addtime,GETDATE())<=180";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"WeiXinID",new DBParam{ParamValue=weixinid}},
            {"mobile",new DBParam{ParamValue=Phone}}
            });

            foreach (DataRow row in dt.Rows)
            {
                int count = int.Parse(row["sendnum"].ToString());
                string hastime = row["hastime"].ToString();
                if (count > 10)
                {
                    return int.Parse(hastime);
                }
                else
                {
                    return 0;
                }
            }
            return 0;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="code">验证码</param>
        /// <param name="phone">电话</param>
        /// <param name="type">标识说明</param>
        /// <param name="weixinid"></param>
        /// <returns></returns>
        public static int SendPhoneCodeMsg(string code, string phone, string weixinid)
        {
            string content = string.Format(@"您的手机验证码为:{0},如非本人操作，请忽略本信息【微可牛】", code);
            string key = "";
            //SMS sms = new SmsZQ20140512();
            SMS sms = new SmsMD20140117();
            sms.ReceiveMobileNo = phone;
            sms.Content = content;

            string result = sms.Send(ref key);
            if (result == "0")
            {
                Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
                Dic.Add("Mobile", new DBParam { ParamValue = phone });
                Dic.Add("SMSContent", new DBParam { ParamValue = content });
                Dic.Add("SMSCode", new DBParam { ParamValue = code });
                Dic.Add("Channel", new DBParam { ParamValue = "用户注册修改" });
                Dic.Add("WeiXinID", new DBParam { ParamValue = weixinid });
                //发送成功 写入一条记录
                string sql = @"
INSERT INTO [WeiXin].[dbo].[wkn_smssend]
           ([Mobile]
           ,[SMSContent]
           ,[SMSCode]
           ,[Channel]
           ,[Addtime]
           ,[Ip]
           ,[WeiXinID])
     VALUES
           (@Mobile
           ,@SMSContent
           ,@SMSCode
           ,@Channel
           ,GETDATE()
           ,''
           ,@WeiXinID
)
";
                int Count = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), Dic);
                return Count;
            }
            return 0;


            //string content = string.Format(@"您的手机验证码为:{0},如非本人操作，请忽略本信息【微可牛】", code);


            //string tsql = @"insert into Tasks(TaskContent,TaskTime,TaskState,SendState,mobile,TaskType) values(@Content,getdate(),0,0,@mobile,'2')";

            //Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            //Dic.Add("Content", new DBParam { ParamValue = content });
            //Dic.Add("mobile", new DBParam { ParamValue = phone });

            //int Count = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.GetCon(), Dic);
            //return Count;
        }
        public static int MemberLogin(string WeiXinID, string UserWeiXinID, string GustName, string Pwd)
        {
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("weixinID", new DBParam { ParamValue = WeiXinID });
            Dic.Add("GustName", new DBParam { ParamValue = GustName });
            Dic.Add("userWeiXinNO", new DBParam { ParamValue = UserWeiXinID });
            Dic.Add("Pwd", new DBParam { ParamValue = Pwd });
            string sql = @"SELECT COUNT(0) FROM dbo.Member WITH(NOLOCK) WHERE userWeiXinNO=@userWeiXinNO AND weixinID=@weixinID AND pwd=@Pwd AND(mobile=@GustName OR cardno=@GustName) ";
            string Count = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), Dic);
            return int.Parse(Count);
        }

        public static int UpdatePassword(string WeiXinID, string UserWeiXinID, string Pwd, string name, string CardNo, bool isnew, string vipstr = "")
        {

            string sql = string.Format(@"UPDATE dbo.Member SET pwd=@pwd{0} {1} WHERE weixinID=@weixinID AND userWeiXinNO=@userWeiXinNO", isnew ? " ,name=@name,cardno=@cardno" : "", vipstr);

            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("pwd", new DBParam { ParamValue = Pwd });
            Dic.Add("weixinID", new DBParam { ParamValue = WeiXinID });
            Dic.Add("userWeiXinNO", new DBParam { ParamValue = UserWeiXinID });
            Dic.Add("name", new DBParam { ParamValue = name });
            Dic.Add("cardno", new DBParam { ParamValue = CardNo });

            int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);

            if (Count > 0 && isnew)
            {
                sql = @"UPDATE dbo.MemberCard SET isuse=1,binddate=GETDATE()  WHERE cardno=@cardno";
                SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);
            }

            return Count;
        }
        public static string GetHotelName(string WeiXinID, string hotelid)
        {
            string sql = @"SELECT TOP 1 SubName,hotelLog FROM dbo.Hotel WITH(NOLOCK) WHERE WeiXinID=@WeiXinID and id=@id";
            string value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>(){
            {"WeiXinID",new DBParam{ParamValue=WeiXinID}},
            {"id",new DBParam{ParamValue=hotelid}}
            });
            return value;
        }
        public static HotelInfoItem GetHotelInfo(string WeiXinID, string hotelid)
        {
            string sql = @"SELECT TOP 1 SubName,hotelLog,MainPic FROM dbo.Hotel WITH(NOLOCK) WHERE WeiXinID=@WeiXinID and id=@id";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>(){
            {"WeiXinID",new DBParam{ParamValue=WeiXinID}},
            {"id",new DBParam{ParamValue=hotelid}}
            });
            foreach (DataRow row in dt.Rows)
            {
                HotelInfoItem Item = new HotelInfoItem();
                string logo = row["hotelLog"].ToString();
                string SubName = row["SubName"].ToString();
                string MainPic = row["MainPic"].ToString();
                Item.SubName = string.IsNullOrEmpty(SubName) ? "" : SubName;
                Item.MainPic = string.IsNullOrEmpty(MainPic) ? "" : MainPic;
                Item.hotelLog = string.IsNullOrEmpty(logo) ? "../../images/newlogo.png" : logo;

                return Item;
            }
            return new HotelInfoItem() { SubName = "", hotelLog = "../../images/newlogo.png" };

        }
        public static WeiXinUserInfo GetUserWeixinInfo(string access_token, string openid)
        {
            string url = string.Format(@"https://api.weixin.qq.com/cgi-bin/user/info?access_token={0}&openid={1}&lang=zh_CN", access_token, openid);
            HttpWebRequest myHttpWebRequest = (HttpWebRequest)WebRequest.Create(url);
            myHttpWebRequest.ContentType = "application/x-www-form-urlencoded";
            myHttpWebRequest.UserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; Q312461; .NET CLR 1.0.3705)";
            myHttpWebRequest.Referer = "https://mp.weixin.qq.com/";
            HttpWebResponse myHttpWebResponse = (HttpWebResponse)myHttpWebRequest.GetResponse();
            Stream responseStream = myHttpWebResponse.GetResponseStream();
            StreamReader responseReader = new StreamReader(responseStream, Encoding.GetEncoding("utf-8"));
            string outdata = responseReader.ReadToEnd();

            return Newtonsoft.Json.JsonConvert.DeserializeObject<WeiXinUserInfo>(outdata);
        }
        /// <summary>
        /// 获取服务器token
        /// </summary>
        /// <param name="weixinid"></param>
        /// <returns></returns>
        public static AccessToken GetAccessToken(string weixinid)
        {
            try
            {
                System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls;
                WebClient Client = new WebClient();
                string json = Client.DownloadString(string.Format("http://www.weikeniu.com/WeixinFeatures/getGetTokenResult.ashx?appid={0}", weixinid)).Replace("\\", "").Replace("\"{", "{").Replace("}\"", "}");
                AccessToken token = Newtonsoft.Json.JsonConvert.DeserializeObject<AccessToken>(json);
                return token;
            }
            catch
            {
                return new AccessToken() { message = "网络异常", error = 0 };
            }

        }
        public static WeiXinAppConfig GetHotelAppConfig(string weixinid)
        {
            WeiXinAppConfig config = new WeiXinAppConfig();
            string sql = @"SELECT TOP 1 appid,appkey,style FROM dbo.WeiXinNO WITH(NOLOCK) WHERE weixinID=@weixinID";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"weixinID",new DBParam{ParamValue=weixinid}}
            });
            foreach (DataRow row in dt.Rows)
            {
                config.appid = row["appid"].ToString();
                config.appkey = row["appkey"].ToString();
                string style = row["style"].ToString();
                config.style = string.IsNullOrEmpty(style) ? 0 : int.Parse(style);
                return config;
            }
            return null;
        }
        public static void UpdateUserWeiXxinPhoto(string WeiXinID, string UserWeiXinID, string CardNo, WeiXinUserInfo UserInfo)
        {
            string sql = @"UPDATE dbo.Member SET photo=@photo,nickname=@nickname WHERE weixinID=@weixinID AND userWeiXinNO=@userWeiXinNO and cardno=@cardno";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("weixinID", new DBParam { ParamValue = WeiXinID });
            Dic.Add("userWeiXinNO", new DBParam { ParamValue = UserWeiXinID });
            Dic.Add("cardno", new DBParam { ParamValue = CardNo });
            Dic.Add("photo", new DBParam { ParamValue = UserInfo.headimgurl });
            Dic.Add("nickname", new DBParam { ParamValue = UserInfo.nickname });
            int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);
        }

        //订单处理状态
        public static string GetHotelOrderStateNameByState(Common.OrderInfoItem OrderItem)
        {
            //现付订单：待确认（待处理），取消，预订成功（已确认），已离店，预订失败（拒单，即不确认）
            //预付订单：待支付（未付款的待处理订单），待确认（已支付），取消，预订失败，预订成功（已确认），已离店
            //团购预售订单的，团购是待支付，待预约，待确认，预约成功，交易成功，取消
            //预售是 待支付 ispay0，待确认，预订成功，交易成功，取消，预订失败



            if (OrderItem.channel == 0)
            {
                if (OrderItem.State == 10)
                {
                    return "取消";
                }
                //酒店
                if (OrderItem.PayType == 0)
                {
                    //预付
                    #region
                    if (OrderItem.State == 1 && OrderItem.tradeStatus != "TRADE_FINISHED" && !(OrderItem.Remark == null || (OrderItem.Remark.ToString().IndexOf("支付成功通知-金额") >= 0)))
                    {
                        return "待支付";//待支付（未付款的待处理订单）
                    }
                    else if (OrderItem.State == 24)
                    {
                        return "待确认";
                    }
                    else if (OrderItem.State == 2 || OrderItem.State == 10)
                    {
                        return "取消";
                    }
                    else if (OrderItem.State == 22 || OrderItem.State == 61)
                    {
                        return "预订失败";
                    }
                    else if (OrderItem.State == 6)
                    {
                        return "预订成功";
                    }
                    else if (OrderItem.State == 9)
                    {
                        return "已离店";
                    }
                    else
                    {
                        return "--";
                    }
                    #endregion
                }
                else
                {
                    //现付
                    #region
                    if (OrderItem.State == 1)
                    {
                        return "待确认";
                    }
                    else if (OrderItem.State == 2 || OrderItem.State == 10)
                    {
                        return "取消";
                    }
                    else if (OrderItem.State == 6)
                    {
                        return "预订成功";
                    }
                    else if (OrderItem.State == 9)
                    {
                        return "已离店";
                    }
                    else if (OrderItem.State == 22 || OrderItem.State == 61)
                    {
                        return "预订失败";
                    }
                    else
                    {
                        return "--";
                    }
                    #endregion
                }

            }
            else if (OrderItem.channel == 1)
            {
                //团购 预售
                //0团购 1预售

                if (OrderItem.ProductType == -1)
                {
                    //团购
                    #region
                    if (OrderItem.IsPay == 0)
                    {
                        //未支付
                        if (OrderItem.State == (int)ProductSaleOrderStatus.待支付)
                        {
                            return "待支付";
                        }

                        else if (OrderItem.State == (int)ProductSaleOrderStatus.取消)
                        {
                            return "取消";
                        }
                    }

                    else
                    {
                        //已支付
                        if (OrderItem.HeXiaoState == (int)ProductSaleOrderTuanStatus.未预约)
                        {
                            return "未预约";
                        }
                        else if (OrderItem.HeXiaoState == (int)ProductSaleOrderTuanStatus.预约中)
                        {
                            return "预约中";
                        }
                        else if (OrderItem.HeXiaoState == (int)ProductSaleOrderTuanStatus.预约成功)
                        {
                            return "预约成功";
                        }
                        else if (OrderItem.HeXiaoState == (int)ProductSaleOrderTuanStatus.预约失败)
                        {
                            return "预约失败";
                        }
                        else if (OrderItem.HeXiaoState == (int)ProductSaleOrderTuanStatus.已使用)
                        {
                            return "已使用";//"交易成功";
                        }
                    }
                    #endregion
                }
                else
                {
                    //预售
                    #region
                    return ((ProductSaleOrderStatus)(OrderItem.State)).ToString();
                    #endregion
                }
            }
            else if (OrderItem.channel == 2)
            {
                if (OrderItem.State == 2 || OrderItem.State == 11 || OrderItem.State == 13 || OrderItem.State == 3)
                {
                    return "取消";
                }

                try
                {
                    return ((EnumOrderStatus)(OrderItem.State)).ToString();
                }
                catch (Exception ex)
                {
                    return "--";
                }
            }
            else if (OrderItem.channel == 3)
            {
                return ((WeiXin.Common.EnumSupermarketOrderStatus)(OrderItem.State)).ToString();
            }
            return "--";

        }
        //插入优惠使用记录
        public static int InsertPreferentialInformation(PreferentialInformationItemClass InformationItemClass)
        {
            string sql = @"
INSERT INTO [dbo].[MemberPreferentialInformation]
           ([OrderNo]
           ,[GradeName]
           ,[GradeRate]
           ,[CouponId]
           ,[Coupon]
)
     VALUES
           (@OrderNo
           ,@GradeName
           ,@GradeRate
           ,@CouponId
           ,@Coupon
)
";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("OrderNo", new DBParam { ParamValue = InformationItemClass.OrderNo });
            Dic.Add("GradeName", new DBParam { ParamValue = InformationItemClass.GradeName });
            Dic.Add("GradeRate", new DBParam { ParamValue = InformationItemClass.GradeRate.ToString() });
            Dic.Add("CouponId", new DBParam { ParamValue = InformationItemClass.CouponId.ToString() });
            Dic.Add("Coupon", new DBParam { ParamValue = InformationItemClass.Coupon.ToString() });
            int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);

            return Count;
        }
        //会员折扣详情
        public static MemberCardIntegralRule IntegralRule(this MemberInfo MemberInfoDeatil, MemberCard MemberCard)
        {

            MemberCardIntegralRule IntegralRule = new MemberCardIntegralRule();
            IntegralRule.CardNo = MemberCard.cardno;
            IntegralRule.GradeRate = 10;


            if (MemberInfoDeatil != null)
            {
                IntegralRule.equivalence = MemberInfoDeatil.equivalence;
                IntegralRule.term = MemberInfoDeatil.term;


                //自定义会员 只要酒店添加过自定义会员按照这种方式处理
                int count = 0;
                DataTable db_CardCustom = MemberCardCustom.GetMemberCardCustomList(MemberInfoDeatil.weixinId, out count, 1, 50, "", "");
                var memberCardCustomList = WeiXin.Common.DataTableToEntity.GetEntities<Models.Home.MemberCardCustom>(db_CardCustom);
                if (memberCardCustomList.Count > 0)
                {
                    var customMember = memberCardCustomList.Where(c => c.CardLevel == MemberCard.viptype).FirstOrDefault();
                    if (customMember != null)
                    {

                        IntegralRule.GradePlus = customMember.JiFen;
                        IntegralRule.GradeName = customMember.CardName;

                        IntegralRule.CouponType = customMember.CouponType;
                        if (customMember.CouponType == 0)
                        {
                            IntegralRule.GradeRate = customMember.Discount;

                        }
                        else
                        {
                            IntegralRule.Reduce = customMember.Reduce;

                        }

                        IntegralRule.MealCouponType = customMember.MealCouponType;
                        if (customMember.MealCouponType == 0)
                        {
                            IntegralRule.MealGradeRate = customMember.MealDiscount;
                        }
                        else
                        {
                            IntegralRule.MealReduce = customMember.MealReduce;
                        }

                        return IntegralRule;
                    }


                    else
                    {
                        IntegralRule.GradeName = "微信粉丝";
                        return IntegralRule;
                    }
                }




                switch (MemberCard.viptype)
                {
                    case 0:
                        IntegralRule.GradeRate = MemberInfoDeatil.vip0rate;
                        IntegralRule.GradePlus = MemberInfoDeatil.vip0plus;
                        IntegralRule.GradeName = "普通会员";
                        return IntegralRule;
                    case 1:
                        IntegralRule.GradeRate = MemberInfoDeatil.vip1rate;
                        IntegralRule.GradePlus = MemberInfoDeatil.vip1plus;
                        IntegralRule.GradeName = "高级会员";
                        return IntegralRule;
                    case 2:
                        IntegralRule.GradeRate = MemberInfoDeatil.vip2rate;
                        IntegralRule.GradePlus = MemberInfoDeatil.vip2plus;
                        IntegralRule.GradeName = "白银会员";
                        return IntegralRule;
                    case 3:
                        IntegralRule.GradeRate = MemberInfoDeatil.vip3rate;
                        IntegralRule.GradePlus = MemberInfoDeatil.vip3plus;
                        IntegralRule.GradeName = "黄金会员";
                        return IntegralRule;

                    case 4:
                        IntegralRule.GradeRate = MemberInfoDeatil.vip4rate;
                        IntegralRule.GradePlus = MemberInfoDeatil.vip4plus;
                        IntegralRule.GradeName = "钻石会员";
                        return IntegralRule;

                    default:
                        IntegralRule.GradeRate = MemberInfoDeatil.vip0rate;
                        IntegralRule.GradePlus = MemberInfoDeatil.vip0plus;
                        IntegralRule.GradeName = "普通会员";
                        return IntegralRule;
                }
            }

            IntegralRule.GradeName = "微信粉丝";
            return IntegralRule;
        }
        //获取当前已领取优惠券
        public static List<long> GetMyCouPons(string weixinID, string userweixinID)
        {
            List<long> CouponIds = new List<long>();
            try
            {
                var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select typeID from couponContent where weixinID=@weixinID and userweixinno=@userweixinno and isnull(typeID,'')!='' --and getdate()<= ExtTime", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=weixinID}},
            {"userweixinno",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinID}}
            });

                foreach (DataRow row in dt.Rows)
                {
                    long id = long.Parse(row["typeID"].ToString());
                    CouponIds.Add(id);
                }
            }
            catch
            {

            }
            return CouponIds;
        }

        //会员注册生成 是添加会员礼包 $*12
        public static int RegisterCouponGift(string weixinid, string userweixinno)
        {

            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("weixinid", new DBParam { ParamValue = weixinid });
            //获取 会员礼包金额
            string sql = @"SELECT TOP 1 CONVERT(VARCHAR(10), isnull(gift,0))+'|'+CONVERT(VARCHAR(10),isnull(giftnum,0))  from dbo.MemberCardDeatil WITH(NOLOCK) WHERE WeiXinID=@weixinid";
            string Value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), Dic);
            string[] giftvalue = Value.Split('|');
            int erro = 0;
            if (int.TryParse(giftvalue[0], out erro) && int.TryParse(giftvalue[1], out erro))
            {
                if (int.Parse(giftvalue[0]) > 0 && int.Parse(giftvalue[1]) > 0)
                {
                    //判断是否只发放一个红包 单个红包有限期1年
                    if (int.Parse(giftvalue[1]) == 1)
                    {
                        DateTime sdate = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-01"));
                        DateTime edate = sdate.AddMonths(12).AddDays(-1);
                        string conpon = DateTime.Now.ToString("yyMMddHHmmssfff");
                        sql = string.Format(@"
insert into CouPonContent(weixinID,moneys,sTime,ExtTime,addTime,IsEmploy,CouPonNO,userweixinNo,giftname) values('{0}','{1}','{2}','{3}',getdate(),0,'{4}','{5}','注册会员礼包');
", weixinid, giftvalue[0], sdate, edate, conpon, userweixinno);
                        int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), null);
                        return Count;
                    }
                    else
                    {
                        string lq = string.Empty;
                        //存在礼包 新增红包
                        for (int i = 0; i < int.Parse(giftvalue[1]); i++)
                        {
                            DateTime sdate = DateTime.Parse(DateTime.Now.AddMonths(i).ToString("yyyy-MM-01"));
                            DateTime edate = sdate.AddMonths(1).AddDays(-1);
                            string conpon = DateTime.Now.AddMilliseconds(i).ToString("yyMMddHHmmssfff");
                            lq += string.Format(@"
insert into CouPonContent(weixinID,moneys,sTime,ExtTime,addTime,IsEmploy,CouPonNO,userweixinNo,giftname) values('{0}','{1}','{2}','{3}',getdate(),0,'{4}','{5}','注册会员礼包');
", weixinid, giftvalue[0], sdate, edate, conpon, userweixinno);
                        }
                        int Count = SQLHelper.Run_SQL(lq, SQLHelper.GetCon(), null);
                        return Count;
                    }
                }
            }
            return 0;

        }
        public static int CouponGiftMoney(string weixinid, string userweixinno)
        {
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("weixinid", new DBParam { ParamValue = weixinid });
            //获取 会员礼包金额
            string sql = @"SELECT TOP 1 CONVERT(VARCHAR(10), isnull(gift,0))+'|'+CONVERT(VARCHAR(10),isnull(giftnum,0))  from dbo.MemberCardDeatil WITH(NOLOCK) WHERE WeiXinID=@weixinid";
            string Value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), Dic);
            string[] giftvalue = Value.Split('|');
            int erro = 0;
            if (int.TryParse(giftvalue[0], out erro) && int.TryParse(giftvalue[1], out erro))
            {
                //返回总金额
                int money = int.Parse(giftvalue[0]) * int.Parse(giftvalue[1]);
                return money;
            }
            return 0;
        }

        //会员推广佣金
        public static int UpdateCommission(string hid, string weixinid, string userweixinno)
        {

            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("weixinID", new DBParam { ParamValue = weixinid });
            Dic.Add("userWeiXinNO", new DBParam { ParamValue = userweixinno });
            string sql = "SELECT mobile FROM dbo.Member WITH(NOLOCK) WHERE weixinID=@weixinID AND userWeiXinNO=@userWeiXinNO";

            string tel = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), Dic);
            if (string.IsNullOrEmpty(tel)) {
                return 0;
            }
            Dic.Add("tel", new DBParam { ParamValue = tel });
            Dic.Add("hid", new DBParam { ParamValue = hid });
            sql = "SELECT id,hid,tel,addtime,money,promoterid,amountlimit,typeid,jifen,afterdays FROM WeiXin.dbo.ShareCouponContent WITH(NOLOCK) WHERE tel=@tel AND weixinid=@weixinID";


           DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);
            int promoterid = 0;
            decimal money = 0;
            int jifen = 0;
            decimal amountlimit = 0;
            int afterdays = 0;


            string typeID = "";
            if (dt.Rows.Count > 0)
            {
                string uid = dt.Rows[0]["promoterid"].ToString();
                string moneystr = dt.Rows[0]["money"].ToString();
                string jifenstr = dt.Rows[0]["jifen"].ToString();
                string afterdaysstr = dt.Rows[0]["afterdays"].ToString();
                typeID = dt.Rows[0]["typeid"].ToString();
                int error = 0;
                decimal moneyerror = 0;
                string amountlimitstr = dt.Rows[0]["amountlimit"].ToString();
                promoterid = int.TryParse(uid, out error) ? int.Parse(uid) : 0;
                afterdays = int.TryParse(afterdaysstr, out error) ? int.Parse(afterdaysstr) : 0;


                money = decimal.TryParse(moneystr, out moneyerror) ? decimal.Parse(moneystr) : 0;
                amountlimit = decimal.TryParse(amountlimitstr, out moneyerror) ? decimal.Parse(amountlimitstr) : 0;
                jifen = int.TryParse(jifenstr, out error) ? int.Parse(jifenstr) : 0;
            }
            sql = "SELECT COUNT(0) FROM dbo.CouPonContent WHERE weixinID=@weixinID AND userweixinNo=@userWeiXinNO AND giftname='推广员红包'";
            string value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), Dic);
            Dic.Add("promoterid", new DBParam { ParamValue = promoterid.ToString() });
            Dic.Add("jifen", new DBParam { ParamValue = jifen.ToString() });
            if (promoterid > 0 && int.Parse(value)<=0)
            {
                //存在推广员 绑定推广员
                sql = "UPDATE dbo.Member SET promoterid=@promoterid WHERE weixinID=@weixinID AND userweixinNo=@userWeiXinNO AND ISNULL(promoterid,0)=0 AND id!=@promoterid";
                int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);
                string sdate = DateTime.Now.AddDays(afterdays).ToString("yyyy-MM-dd");
                string edate = DateTime.Now.AddYears(1).ToString("yyyy-MM-dd");
                string conpon = DateTime.Now.AddMilliseconds(10).ToString("yyMMddHHmmssfff");

                //赠送红包
                sql = string.Format(@"insert into CouPonContent(weixinID,moneys,sTime,ExtTime,addTime,IsEmploy,CouPonNO,userweixinNo,giftname,typeID) values('{0}','{1}','{2}','{3}',getdate(),0,'{4}','{5}','推广员红包','{6}');", weixinid, money, sdate, edate, conpon, userweixinno, typeID);
                Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), null);
            }



            if (jifen > 0 && promoterid>0)
            {
                //积分 发放积分给推广员
                sql = "UPDATE dbo.Member SET Emoney=ISNULL(Emoney,0)+@jifen WHERE weixinID=@weixinID AND id=@promoterid";
                int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);

                if (Count > 0) {
                    sql = "SELECT cardno,userWeiXinNO FROM dbo.Member WITH(NOLOCK) WHERE weixinID=@weixinID AND id=@promoterid";

                    dt = SQLHelper.Get_DataTable(sql,SQLHelper.GetCon(), Dic);
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        string cardno = dt.Rows[0]["cardno"].ToString();
                        string fxopenid = dt.Rows[0]["userWeiXinNO"].ToString();
                        //写入积分记录
                        sql = @"INSERT INTO JiFenDetail (weixinID,userweixinID,JIFen,Remark,status,cardno,UseOrderId)VALUES
(@weixinID,@fxopenid,@JIFen,'推广会员注册送积分',1,@cardno,@userWeiXinNO)";
                        Dic.Add("fxopenid", new DBParam { ParamValue = fxopenid });
                        Dic.Add("cardno", new DBParam { ParamValue = cardno });
                        Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);
                    }
                }
                return Count;
            }
            return 0;
        }

        /// <summary>
        /// 生成会员账户
        /// </summary>
        /// <param name="weixinid"></param>
        /// <param name="userweixinno"></param>
        /// <param name="caozuo">备注说明</param>
        public static void InsertUserAccount(string weixinid, string userweixinno, string caozuo)
        {
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("weixinID", new DBParam { ParamValue = weixinid });
            Dic.Add("userWeiXinNO", new DBParam { ParamValue = userweixinno });
            Dic.Add("caozuo", new DBParam { ParamValue = caozuo });

            string sql = @"
INSERT INTO dbo.WeiXinUser(weixinID,userWeiXinNO,fakeId,typename,nickname) values(@weixinID,@userWeixinNO,'','add','')
INSERT INTO  dbo.Member(weixinID,userWeiXinNO,addtime,caozuo)VALUES(@weixinID,@userWeiXinNO,GETDATE(),@caozuo)
";
            int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);

        }
    }


    public static class WeiXinHtmlRequesHelper
    {
        public static string RequestHtml(string url)
        {

            System.Net.HttpWebRequest request;
            request = (System.Net.HttpWebRequest)WebRequest.Create(url);
            request.Proxy = null;
            request.Method = "Post";
            System.Net.HttpWebResponse response;
            response = (System.Net.HttpWebResponse)request.GetResponse();
            System.IO.Stream s = response.GetResponseStream();
            StreamReader Reader = new StreamReader(s, Encoding.UTF8);
            return Reader.ReadToEnd(); ;
        }
    }
    //当前会员折扣详情
    public class MemberCardIntegralRule
    {
        public string GradeName { get; set; }
        //订房会员折扣
        public decimal GradeRate { get; set; }
        //积分比例
        public decimal GradePlus { get; set; }
        //积分兑换比例
        public int equivalence { get; set; }
        //积分有效期
        public int term { get; set; }
        public string CardNo { get; set; }

        /// <summary>
        /// 订房优惠方式 0 折扣 1立减
        /// </summary>
        public int CouponType { get; set; }

        /// <summary>
        /// 餐饮优惠方式 0 折扣 1立减
        /// </summary>
        public int MealCouponType { get; set; }


        //订房立减金额
        public decimal Reduce { get; set; }


        //餐饮立减金额
        public decimal MealReduce { get; set; }


        //餐饮折扣
        public decimal MealGradeRate { get; set; }

    }

    public class PreferentialInformationItemClass
    {
        public string OrderNo { get; set; }
        public string GradeName { get; set; }
        public decimal GradeRate { get; set; }
        public int CouponId { get; set; }
        public int Coupon { get; set; }
    }

    public class JifenItem
    {
        public int OrderID { get; set; }
        public string WeiXinID { get; set; }
        public string UserWeiXinID { get; set; }
        public int JiFen { get; set; }
        public string AddTime { get; set; }
        public string Remark { get; set; }
        public int night { get; set; }
    }

    public class MemberInfo
    {
        public string hid { get; set; }
        public string weixinId { get; set; }
        public string backgroud { get; set; }
        public int vip0 { get; set; }
        public int vip1 { get; set; }
        public int vip2 { get; set; }
        public int vip3 { get; set; }
        public int vip4 { get; set; }
        public decimal vip0rate { get; set; }
        public decimal vip1rate { get; set; }
        public decimal vip2rate { get; set; }
        public decimal vip3rate { get; set; }
        public decimal vip4rate { get; set; }
        public int term { get; set; }
        public int equivalence { get; set; }
        public string cardname { get; set; }
        public decimal vip0plus { get; set; }
        public decimal vip1plus { get; set; }
        public decimal vip2plus { get; set; }
        public decimal vip3plus { get; set; }
        public decimal vip4plus { get; set; }
        public string intro { get; set; }
        public int gift { get; set; }
        public int autoadd { get; set; }
        public int giftnum { get; set; }

        public string CardLogo { get; set; }
    }

    public class MemberCard
    {
        public string memberid { get; set; }
        public int hid { get; set; }
        public string cardno { get; set; }
        public int isuse { get; set; }
        public DateTime adddate { get; set; }
        public string binddate { get; set; }
        public int jifen { get; set; }
        public decimal money { get; set; }
        public int night { get; set; }
        public int enabled { get; set; }
        public string address { get; set; }
        public string phone { get; set; }
        public string name { get; set; }
        public string sex { get; set; }
        public string email { get; set; }
        public string photo { get; set; }
        public string nickname { get; set; }
        public int viptype { get; set; }
    }
    public class AccessToken
    {
        //public string tooken { get; set; }
        //public DateTime date { get; set; }


        public string message { get; set; }
        public int error { get; set; }

    }
    public class WeiXinAppConfig
    {
        public string appid { get; set; }
        public string appkey { get; set; }
        public int style { get; set; }

    }
    public class WeiXinUserInfo
    {
        public int subscribe { get; set; }
        public string openid { get; set; }
        public string nickname { get; set; }
        public int sex { get; set; }
        public string language { get; set; }
        public string city { get; set; }
        public string province { get; set; }
        public string country { get; set; }
        public string headimgurl { get; set; }
        public int subscribe_time { get; set; }
        public string remark { get; set; }
        public int groupid { get; set; }
        public object[] tagid_list { get; set; }
    }



    //会议抽奖
    public static class RandomLuckyDrawHelper
    {
        public static bool CheckedPwdWithLuckyDrawId(int drawid, string pwd)
        {
            string sql = @"SELECT COUNT(0) FROM [RandomLuckyDraw_wkn]  WITH(NOLOCK) WHERE id=@id AND pwd=@pwd";
            string value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"id",new DBParam{ParamValue=drawid.ToString()}},
            {"pwd",new DBParam{ParamValue=pwd}},
            });
            return int.Parse(value) > 0 ? true : false;
        }
        public static bool UserIsNotExists(int drawid, string userweixinid)
        {
            string sql = @"SELECT COUNT(0) FROM RandomLuckyDrawUsers_wkn WITH(NOLOCK) WHERE drawid=@drawid AND userweixinid=@userweixinid";
            string value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"drawid",new DBParam{ParamValue=drawid.ToString()}},
            {"userweixinid",new DBParam{ParamValue=userweixinid}},
            });
            return int.Parse(value) > 0 ? false : true;
        }
        public static int CreateLuckyDrawUser(int drawid, string photo, string tel, string name, string userweixinid)
        {
            string sql = @"INSERT INTO [WeiXin].[dbo].[RandomLuckyDrawUsers_wkn]
           ([drawid],[photo],[tel],[name],[userweixinid])
     VALUES
           (@drawid ,@photo ,@tel ,@name,@userweixinid)";
            // sql = string.Format(@"INSERT INTO [WeiXin].[dbo].[RandomLuckyDrawUsers_wkn] ([drawid],[photo],[tel],[name],[userweixinid]) VALUES({0},'{1}','{2}','{3}','{4}')", drawid, photo, tel, name, userweixinid);



            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("drawid", new DBParam { ParamValue = drawid.ToString() });
            Dic.Add("photo", new DBParam { ParamValue = photo });
            Dic.Add("tel", new DBParam { ParamValue = tel });
            Dic.Add("name", new DBParam { ParamValue = name });
            Dic.Add("userweixinid", new DBParam { ParamValue = userweixinid });
            int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);
            return Count;

        }
        public static List<RandomLuckyDrawClass> GetRandomLuckyDrawList(int drawid, string weixinid)
        {
            string where = string.Empty;
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("weixinid", new DBParam { ParamValue = weixinid });
            if (drawid > 0)
            {
                where += string.Format(" and id=@id");
                Dic.Add("id", new DBParam { ParamValue = drawid.ToString() });
            }
            string sql = string.Format(@"SELECT  id , title , sdate , edate , drawtype ,  pwd , tel , no1 , no2 ,  no3 , no0 ,isnull(no1num,0) no1num, isnull(no2num,0) no2num,  isnull(no3num,0) no3num, isnull(no0num,0) no0num,intro,[enabled],weixinid FROM [dbo].[RandomLuckyDraw_wkn] WITH(NOLOCK) WHERE weixinid=@weixinid and enabled=1 {0}", where);
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);
            List<RandomLuckyDrawClass> Result = new List<RandomLuckyDrawClass>();

            ///已使用名额
            Dictionary<int, int> DrawHasNum = GetDrawHasNumByDrawId(drawid);
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    RandomLuckyDrawClass item = new RandomLuckyDrawClass();
                    item.id = int.Parse(row["id"].ToString());
                    item.title = row["title"].ToString();
                    item.sdate = DateTime.Parse(row["sdate"].ToString());
                    item.edate = DateTime.Parse(row["edate"].ToString());
                    item.drawtype = int.Parse(row["drawtype"].ToString());
                    item.pwd = row["pwd"].ToString();
                    item.tel = row["tel"].ToString();
                    item.no1 = row["no1"].ToString();
                    item.no2 = row["no2"].ToString();
                    item.no3 = row["no3"].ToString();
                    item.no0 = row["no0"].ToString();
                    item.no1num = row["no1num"].ToString();
                    item.no2num = row["no2num"].ToString();
                    item.no3num = row["no3num"].ToString();
                    item.no0num = row["no0num"].ToString();

                    #region 计算剩余名额
                    item.no1num = string.IsNullOrEmpty(item.no1num) ? "0" : (int.Parse(item.no1num) - DrawHasNum[1]).ToString();
                    item.no2num = string.IsNullOrEmpty(item.no2num) ? "0" : (int.Parse(item.no2num) - DrawHasNum[2]).ToString();
                    item.no3num = string.IsNullOrEmpty(item.no3num) ? "0" : (int.Parse(item.no3num) - DrawHasNum[3]).ToString();
                    item.no0num = string.IsNullOrEmpty(item.no0num) ? "0" : (int.Parse(item.no0num) - DrawHasNum[100]).ToString();

                    #endregion

                    item.intro = row["intro"].ToString();
                    item.weixinid = row["weixinid"].ToString();
                    item.enabled = int.Parse(row["enabled"].ToString());
                    Result.Add(item);
                }
                return Result;
            }
            return null;
        }
        public static RandomLuckyDrawUserClass GetRandomLuckyDrawUserByUserWeiXinIdWithDrawid(string userweixinid, int drawid)
        {
            string sql = @"SELECT drawid ,photo,tel,userweixinid,erronum,errotime,result,addtime,name,enabled FROM [WeiXin].[dbo].[RandomLuckyDrawUsers_wkn]
WITH(NOLOCK) WHERE drawid=@drawid AND userweixinid=@userweixinid and enabled=1";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("drawid", new DBParam { ParamValue = drawid.ToString() });
            Dic.Add("userweixinid", new DBParam { ParamValue = userweixinid });
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);
            List<RandomLuckyDrawUserClass> Results = new List<RandomLuckyDrawUserClass>();

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    RandomLuckyDrawUserClass item = new RandomLuckyDrawUserClass();
                    item.drawid = int.Parse(row["drawid"].ToString());
                    item.name = row["name"].ToString();
                    item.photo = row["photo"].ToString();
                    item.tel = row["tel"].ToString();
                    item.userweixinid = row["userweixinid"].ToString();
                    item.result = row["result"].ToString();
                    item.addtime = DateTime.Parse(row["addtime"].ToString());
                    item.enabled = int.Parse(row["enabled"].ToString());
                    //item.errotime = DateTime.Parse(row["addtime"].ToString());
                    //item.erronum = int.Parse(string.IsNullOrEmpty(row["erronum"].ToString()) ? "0" : row["erronum"].ToString());
                    Results.Add(item);
                }
                return Results[0];
            }
            return null;
        }
        public static RandomLuckyDrawUserClass GetRandomLuckyUser(int drawid)
        {
            string sql = @"SELECT TOP 1 addtime, drawid , photo , tel ,  userweixinid , erronum , errotime , result ,addtime,name,enabled FROM [WeiXin].[dbo].[RandomLuckyDrawUsers_wkn]
WITH(NOLOCK) WHERE drawid=@drawid AND enabled=1 AND drawno=0 ORDER BY NEWID()";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("drawid", new DBParam { ParamValue = drawid.ToString() });
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);
            List<RandomLuckyDrawUserClass> Results = new List<RandomLuckyDrawUserClass>();
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    RandomLuckyDrawUserClass item = new RandomLuckyDrawUserClass();
                    item.drawid = int.Parse(row["drawid"].ToString());
                    item.name = row["name"].ToString();
                    item.photo = row["photo"].ToString();
                    item.tel = row["tel"].ToString();
                    item.userweixinid = row["userweixinid"].ToString();
                    item.result = row["result"].ToString();
                    item.addtime = DateTime.Parse(row["addtime"].ToString());
                    item.enabled = int.Parse(row["enabled"].ToString());
                    item.errotime = DateTime.Parse(row["addtime"].ToString());
                    item.erronum = int.Parse(string.IsNullOrEmpty(row["erronum"].ToString()) ? "0" : row["erronum"].ToString());
                    Results.Add(item);
                }
                return Results[0];
            }
            return null;
        }
        public static int GetRandomLuckyStatus(int drawid)
        {
            string sql = @"SELECT isnull(status,0) FROM [RandomLuckyDraw_wkn]  WITH(NOLOCK) WHERE id=@drawid ";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("drawid", new DBParam { ParamValue = drawid.ToString() });
            string value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), Dic);
            return int.Parse(value);
        }
        public static int UpdateRandomLuckyStatus(int drawid, CacheWithDraw drawcache)
        {
            string sql = @"UPDATE [RandomLuckyDraw_wkn] SET status=@status WHERE id=@drawid ";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("drawid", new DBParam { ParamValue = drawid.ToString() });
            Dic.Add("status", new DBParam { ParamValue = drawcache.status.ToString() });
            int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);
            if (Count > 0)
            {

                BuildCacheWithDrawId(drawid, drawcache);
            }
            return Count;
        }
        public static int CreateLuckyUserMark(int drawid, int drawno, CacheWithDraw drawcache)
        {
            string sql = @"
UPDATE RandomLuckyDrawUsers_wkn SET [current]=0 WHERE [current]=1;
UPDATE RandomLuckyDrawUsers_wkn SET drawno=@drawno,wintime=GETDATE(),[current]=1 WHERE drawid=@drawid AND userweixinid=@userweixinid";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("drawid", new DBParam { ParamValue = drawid.ToString() });
            Dic.Add("userweixinid", new DBParam { ParamValue = drawcache.userweixinid });
            Dic.Add("drawno", new DBParam { ParamValue = drawno.ToString() });
            int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), Dic);
            if (Count > 0)
            {
                UpdateRandomLuckyStatus(drawid, drawcache);
            }
            return Count;
        }
        //获取中奖名单
        public static List<RandomLuckyDrawUserClass> GetLuckyDrawUsers(int drawid, string userweixinid)
        {
            string where = string.Empty;

            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            if (!string.IsNullOrEmpty(userweixinid))
            {
                //where += string.Format(" AND userweixinid=@userweixinid AND DATEDIFF(SECOND,wintime,GETDATE())<=15");

                Dic.Add("userweixinid", new DBParam { ParamValue = userweixinid });
            }
            string sql = string.Format(@"
SELECT drawid,name,wintime,drawno,photo,tel FROM RandomLuckyDrawUsers_wkn WITH(NOLOCK) WHERE drawno>0 
AND ENABLED=1 AND drawid=@drawid {0}
ORDER BY wintime DESC
", where);
            Dic.Add("drawid", new DBParam { ParamValue = drawid.ToString() });
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);
            List<RandomLuckyDrawUserClass> Results = new List<RandomLuckyDrawUserClass>();
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    RandomLuckyDrawUserClass item = new RandomLuckyDrawUserClass();
                    item.drawid = int.Parse(row["drawid"].ToString());
                    item.name = row["name"].ToString();
                    item.photo = row["photo"].ToString();
                    item.tel = row["tel"].ToString();
                    item.drawno = int.Parse(row["drawno"].ToString());
                    string drawtitie = "";
                    switch (item.drawno)
                    {
                        case 1: drawtitie = "一等奖"; break;
                        case 2: drawtitie = "二等奖"; break;
                        case 3: drawtitie = "三等奖"; break;
                        case 100: drawtitie = "特等奖"; break;
                    }
                    item.result = drawtitie;
                    item.wintime = DateTime.Parse(row["wintime"].ToString()).ToString("yyyy/MM/dd HH:mm:ss");
                    Results.Add(item);
                }
                return Results;
            }
            return null;


        }
        //获取已报名且并未中奖的人员列表
        public static List<RandomLuckyDrawUserClass> GetNotLuckyDrawUsers(int drawid, int drawno)
        {
            string sql = @"
SELECT drawid,name,wintime,drawno,photo,tel ,userweixinid FROM RandomLuckyDrawUsers_wkn WITH(NOLOCK) WHERE  drawid=@drawid AND drawno=0 
AND ENABLED=1 
ORDER BY newid()
";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("drawid", new DBParam { ParamValue = drawid.ToString() });
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);
            List<RandomLuckyDrawUserClass> Results = new List<RandomLuckyDrawUserClass>();
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    RandomLuckyDrawUserClass item = new RandomLuckyDrawUserClass();
                    item.drawid = int.Parse(row["drawid"].ToString());
                    item.name = row["name"].ToString();
                    item.photo = row["photo"].ToString();
                    item.tel = row["tel"].ToString();
                    item.drawno = int.Parse(row["drawno"].ToString());
                    item.userweixinid = row["userweixinid"].ToString();
                    string drawtitie = "";
                    item.drawno = item.drawno == 0 ? drawno : item.drawno;
                    switch (item.drawno)
                    {
                        case 1: drawtitie = "一等奖"; break;
                        case 2: drawtitie = "二等奖"; break;
                        case 3: drawtitie = "三等奖"; break;
                        case 100: drawtitie = "特等奖"; break;
                    }
                    item.result = drawtitie;
                    item.wintime = string.IsNullOrEmpty(row["wintime"].ToString()) ? "" : DateTime.Parse(row["wintime"].ToString()).ToString("yyyy/MM/dd HH:mm:ss");
                    Results.Add(item);
                }
                return Results;
            }
            return null;
        }
        //过去用户自己的中奖纪录
        public static List<RandomLuckyDrawUserClass> GetUserLuckyInfo(string userweixinid, int drawid)
        {
            string sql = string.Format(@"
SELECT drawid,name,wintime,drawno,photo,tel,userweixinid FROM RandomLuckyDrawUsers_wkn WITH(NOLOCK) WHERE userweixinid=@userweixinid and drawid=@drawid
ORDER BY wintime DESC
");

            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("userweixinid", new DBParam { ParamValue = userweixinid });
            Dic.Add("drawid", new DBParam { ParamValue = drawid.ToString() });
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);
            List<RandomLuckyDrawUserClass> Results = new List<RandomLuckyDrawUserClass>();
            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    RandomLuckyDrawUserClass item = new RandomLuckyDrawUserClass();
                    item.drawid = int.Parse(row["drawid"].ToString());
                    item.name = row["name"].ToString();
                    item.photo = row["photo"].ToString();
                    item.tel = row["tel"].ToString();
                    item.drawno = int.Parse(row["drawno"].ToString());
                    item.userweixinid = row["userweixinid"].ToString();
                    string drawtitie = "";
                    switch (item.drawno)
                    {
                        case 1: drawtitie = "一等奖"; break;
                        case 2: drawtitie = "二等奖"; break;
                        case 3: drawtitie = "三等奖"; break;
                        case 100: drawtitie = "特等奖"; break;
                    }
                    item.result = drawtitie;
                    item.wintime = string.IsNullOrEmpty(row["wintime"].ToString()) ? "" : DateTime.Parse(row["wintime"].ToString()).ToString("yyyy/MM/dd HH:mm:ss");
                    Results.Add(item);
                }
                return Results;

            }
            return null;
        }

        //开奖奖状态写入文本
        public static void BuildDrawStatusByDrawId(int drawid, int status)
        {
            string path = string.Format("{0}/Config/LuckyDrawStatus/{1}.txt", HttpContext.Current.Server.MapPath("~/"), drawid);
            if (File.Exists(path))
            {
                File.Delete(path);
            }

            try
            {
                using (StreamWriter log = new StreamWriter(path, true))
                {
                    log.Write(status);
                    log.Close();
                    log.Dispose();
                }
            }
            catch { }
        }

        private static System.Web.Caching.Cache cache = HttpRuntime.Cache;

        //开奖状态写入 缓存
        public static void BuildCacheWithDrawId(int drawid, CacheWithDraw DrawCache)
        {
            DrawCache.time = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
            string cachename = string.Format("Status{0}", drawid);
            if (DrawCache != null)
            {
                cache.Insert(cachename, DrawCache, null, DateTime.Now.AddSeconds(20), TimeSpan.Zero);
            }

            try
            {
                //写入日志
                string path = HttpContext.Current.Server.MapPath("~/") + string.Format("\\Config\\LuckyDrawStatus\\{0}Result.txt", drawid);
                if (File.Exists(path))
                {
                    File.Delete(path);
                }
                string content = Newtonsoft.Json.JsonConvert.SerializeObject(DrawCache);
                using (StreamWriter log = new StreamWriter(path, true))
                {
                    log.Write(content);
                    log.Close();
                    log.Dispose();
                }
            }
            catch (Exception ex)
            {
                //写入异常
            }

        }
        //获取开奖状态缓存
        public static CacheWithDraw GetCacheWithDrawId(int drawid)
        {
            string cachename = string.Format("Status{0}", drawid);
            if (cache != null && cache[cachename] != null)
            {

            }
            else
            {
                try
                {
                    //读取日志
                    string path = HttpContext.Current.Server.MapPath("~/") + string.Format("\\Config\\LuckyDrawStatus\\{0}Result.txt", drawid);
                    if (!File.Exists(path))
                    {
                        cache.Insert(cachename, new CacheWithDraw() { status = 0 }, null, DateTime.Now.AddSeconds(20), TimeSpan.Zero);
                    }
                    else
                    {
                        string content = string.Empty;
                        using (StreamReader log = new StreamReader(path, false))
                        {
                            content = log.ReadToEnd();
                            log.Close();
                            log.Dispose();
                        }
                        if (!string.IsNullOrEmpty(content))
                        {
                            CacheWithDraw drawcache = Newtonsoft.Json.JsonConvert.DeserializeObject<CacheWithDraw>(content);
                            if ((drawcache.time - DateTime.Now).Seconds <= 20)
                            {
                                cache.Insert(cachename, drawcache, null, DateTime.Now.AddSeconds(20), TimeSpan.Zero);

                            }
                            else
                            {
                                cache.Insert(cachename, new CacheWithDraw() { status = 0 }, null, DateTime.Now.AddSeconds(20), TimeSpan.Zero);
                            }
                        }

                    }
                }
                catch (Exception ex)
                {
                    //写入异常
                }

                cache.Insert(cachename, new CacheWithDraw() { status = 0 }, null, DateTime.Now.AddSeconds(20), TimeSpan.Zero);

            }
            return cache[cachename] as CacheWithDraw;
        }


        //开奖结果写入文本
        public static void BuildDrawResultByDrawId(int drawid, string jsonresult)
        {
            string path = string.Format("{0}/Config/LuckyDrawStatus/Result{1}.txt", HttpContext.Current.Server.MapPath("~/"), drawid);
            if (File.Exists(path))
            {
                File.Delete(path);
            }
            try
            {
                using (StreamWriter log = new StreamWriter(path, true))
                {

                    log.Write(jsonresult);
                    log.Close();
                    log.Dispose();

                }
            }
            catch { }
        }

        //获取当前已抽奖 名额数
        public static Dictionary<int, int> GetDrawHasNumByDrawId(int drawid)
        {
            string sql = @"SELECT  COUNT(0) AS num ,drawno FROM  RandomLuckyDrawUsers_wkn WITH ( NOLOCK ) WHERE drawid=@drawid AND drawno>0  GROUP BY drawno,drawid";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("drawid", new DBParam { ParamValue = drawid.ToString() });

            Dictionary<int, int> DrawHasNum = new Dictionary<int, int>();
            for (int i = 1; i < 5; i++)
            {
                DrawHasNum.Add(i, 0);
            }
            DrawHasNum.Add(100, 0);
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);

            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    int num = int.Parse(row["num"].ToString());
                    int drawno = int.Parse(row["drawno"].ToString());
                    DrawHasNum[drawno] = num;
                }
            }
            return DrawHasNum;
        }
        //教研手机号是否已注册
        public static bool TelIsExists(string Tel, int drawid)
        {
            string sql = @"SELECT count(0) FROM  WeiXin.dbo.RandomLuckyDrawUsers_wkn WITH(NOLOCK) WHERE drawid=@drawid AND tel=@tel";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("drawid", new DBParam { ParamValue = drawid.ToString() });
            Dic.Add("Tel", new DBParam { ParamValue = Tel });
            string value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), Dic);
            return int.Parse(value) > 0 ? true : false;
        }

    }
    //抽奖报名人员实体
    public class RandomLuckyDrawUserClass
    {
        public int drawid { get; set; }
        public string name { get; set; }
        public string photo { get; set; }
        public string tel { get; set; }
        public string userweixinid { get; set; }
        public int erronum { get; set; }
        public DateTime errotime { get; set; }
        public string result { get; set; }
        public DateTime addtime { get; set; }
        public int enabled { get; set; }
        public int drawno { get; set; }
        public string wintime { get; set; }
    }
    //抽奖信息实体
    public class RandomLuckyDrawClass
    {
        public int id { get; set; }
        public string title { get; set; }
        public DateTime sdate { get; set; }
        public DateTime edate { get; set; }
        public int drawtype { get; set; }
        public string pwd { get; set; }
        public string tel { get; set; }
        public string no1 { get; set; }
        public string no2 { get; set; }
        public string no3 { get; set; }
        public string no0 { get; set; }
        public string no1num { get; set; }
        public string no2num { get; set; }
        public string no3num { get; set; }
        public string no0num { get; set; }
        public string intro { get; set; }
        public int enabled { get; set; }
        public string weixinid { get; set; }
        public DateTime wintime { get; set; }
    }
    public class CacheWithDraw
    {
        public int status { get; set; }
        public string photo { get; set; }
        public string name { get; set; }
        public string title { get; set; }
        public string userweixinid { get; set; }
        public DateTime time { get; set; }
    }

    /// <summary>
    /// 网页授权获取用户信息
    /// </summary>
    public class UnionInfo
    {
        public string access_token { get; set; }
        public int expires_in { get; set; }
        public string refresh_token { get; set; }
        public string openid { get; set; }
        public string scope { get; set; }
        public string unionid { get; set; }
    }


    public class HotelInfoItem
    {
        public string SubName { get; set; }
        public string hotelLog { get; set; }
        public string WeiXinID { get; set; }
        public string MainPic { get; set; }

    }
}