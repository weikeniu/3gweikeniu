using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace hotel3g.Models
{
    public class HotelHelper
    {
        private static System.Web.Caching.Cache cache = System.Web.HttpContext.Current.Cache;


        public static DataTable GetHotelPicNew(string hotelid)
        {
            string sql = @" SELECT B.title,LEFT(StuList,LEN(StuList)-1) as hobby FROM (SELECT title,(SELECT url+',' FROM HotelImg as C
  WHERE C.title=A.title  and C.hotelID=@hotelid FOR XML PATH('')) AS StuList FROM HotelImg A where  hotelid=@hotelid GROUP BY title ) B ";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {
            {"hotelid",new HotelCloud.SqlServer.DBParam{ParamValue=hotelid}}
            });
            return dt;
        }
        /// <summary>
        /// 获取酒店图集字符串
        /// </summary>
        public static string GetHotelPictures(string Hid)
        {
            StringBuilder Rs = new StringBuilder();
            string SqlStr = "SELECT url,title FROM HotelImg WITH(NOLOCK) WHERE hotelID=@Hid";
            DataTable DT = HotelCloud.SqlServer.SQLHelper.Get_DataTable(SqlStr, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "Hid", new HotelCloud.SqlServer.DBParam { ParamValue = Hid } } });
            foreach (DataRow DR in DT.Rows)
                //ashbur
                Rs.AppendFormat("'{0}|{1}',", DR["url"].ToString(), DR["title"].ToString());
            return Rs.ToString();
        }
        public static DataTable GetHotelImages(string Hid)
        {
            StringBuilder Rs = new StringBuilder();
            string SqlStr = "SELECT url,title FROM HotelImg WITH(NOLOCK) WHERE hotelID=@Hid";
            DataTable DT = HotelCloud.SqlServer.SQLHelper.Get_DataTable(SqlStr, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "Hid", new HotelCloud.SqlServer.DBParam { ParamValue = Hid } } });
            return DT;
        }
        /// <summary>
        /// 获得酒店新闻总记录数
        /// </summary>
        public static int GetHotelNewsCount(string Hid)
        {
            string SqlStr = "select count(1) as H  from HotelNews WITH(NOLOCK) where HotelID=@Hid ";
            string res = HotelCloud.SqlServer.SQLHelper.Get_Value(SqlStr, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "Hid", new HotelCloud.SqlServer.DBParam { ParamValue = Hid.ToString() } } });
            return Convert.ToInt32(res);
        }

        /// <summary>
        /// 获取酒店新闻记录数 分页数据操作
        /// </summary>
        public static List<HotelNews> PageNewList(int pageSize, int currentPage, string hid, string filedOrder, out int pageNumSum, out int pageCount,int type=0)
        {
            string strWhere = string.Format(" where hotelid={0} and type={1} AND isview=1 ", hid, type);
            List<HotelNews> list = new List<HotelNews>();
            StringBuilder sqlStr = new StringBuilder();
            int beginPage = ((currentPage - 1) * pageSize) + 1;
            int endPage = currentPage * pageSize;
            try
            {
                sqlStr.Append("select id,hotelid,title,addtime,coverImage ");
                sqlStr.Append("from (select id,hotelid,title,addtime,coverImage,type,row_number() over(order by " + filedOrder + " desc )");
                sqlStr.Append(" as pageNum,isview from HotelNews");
                if (!string.IsNullOrEmpty(strWhere.ToString().Trim())) { sqlStr.Append(strWhere); }
                sqlStr.Append(")" + " as newHotelNews");
                if (string.IsNullOrEmpty(strWhere.ToString().Trim())) { sqlStr.Append(" where "); }
                if (!string.IsNullOrEmpty(strWhere.ToString().Trim())) { sqlStr.Append(strWhere + " and "); }
                sqlStr.Append(" newHotelNews.pageNum between " + beginPage + " and " + endPage + "");
                sqlStr.Append(" order by " + filedOrder + " desc ");
                var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sqlStr.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), null);
                if (dt != null)
                {
                    foreach (System.Data.DataRow dr in dt.Rows)
                    {
                        HotelNews model = new HotelNews();
                        model.Id = Convert.ToInt32(Convert.ToDouble(dr["id"].ToString()));
                        model.HotelID = Convert.ToInt32(Convert.ToDouble(dr["hotelid"].ToString()));
                        model.Title = dr["title"].ToString();
                        model.AddTime = Convert.ToDateTime(dr["addtime"].ToString()).ToString("yy-MM-dd");
                        model.Content = Convert.ToDateTime(dr["addtime"].ToString()) > DateTime.Now.AddDays(-30) ? "1" : "0";
                        model.CoverImage = dr["coverImage"].ToString();
                        list.Add(model);
                    }
                }
                pageCount = GetHotelNewsCount(hid);//总记录数
                pageNumSum = pageCount % pageSize == 0 ? pageCount / pageSize : (pageCount / pageSize) + 1;//总页数
                return list;
            }
            catch (SqlException e) { throw e; }
        }

        /// <summary>
        /// 获取酒店新闻详细信息
        /// </summary>
        public static HotelNews GetNewsDetails(string nid, out int preId, out int afterId, string hotelid)
        {
            string SqlStr = "SELECT id,hotelid,title,coverImage,addtime,content FROM HotelNews WITH(NOLOCK) WHERE id=@nid";
            DataTable DT = HotelCloud.SqlServer.SQLHelper.Get_DataTable(SqlStr, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                {"nid",new HotelCloud.SqlServer.DBParam{ParamValue=nid.ToString()}},
            });
            HotelNews model = new HotelNews();
            if (DT.Rows.Count > 0)
            {
                System.Data.DataRow dr = DT.Rows[0];
                model.Id = Convert.ToInt32(dr["id"].ToString());
                model.HotelID = Convert.ToInt32(dr["hotelid"].ToString());
                model.Title = dr["title"].ToString();
                model.AddTime = Convert.ToDateTime(dr["addtime"].ToString()).ToString("yyyy-MM-dd").ToString();
                model.Content = dr["content"].ToString();
                model.CoverImage = dr["coverImage"].ToString();
            }
            string sql = @"select top 1 id from Hotelnews where hotelid=@hotelid and id<@nid order by id desc ";
            string pid = HotelCloud.SqlServer.SQLHelper.Get_Value(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"nid",new HotelCloud.SqlServer.DBParam{ParamValue=nid}},
            {"hotelid",new HotelCloud.SqlServer.DBParam{ParamValue=hotelid}}
            });
            if (pid.Equals(""))
            {
                preId = Convert.ToInt32(nid);
            }
            else
            {
                preId = Convert.ToInt32(pid);
            }

            string nextid = HotelCloud.SqlServer.SQLHelper.Get_Value("select top 1 id from Hotelnews where hotelid=@hotelid and id>@nid order by id asc", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"nid",new HotelCloud.SqlServer.DBParam{ParamValue=nid}},
            {"hotelid",new HotelCloud.SqlServer.DBParam{ParamValue=hotelid}}
            });

            if (nextid.Equals(""))
            {
                afterId = Convert.ToInt32(nid);
            }
            else
            {
                afterId = Convert.ToInt32(nextid);
            }

            return model;
        }

        /// <summary>
        /// 酒店订单提交保存
        /// </summary>
        public static void OrderSave(HotelOrder hotelorder, UserGuarantee uguarantee, string ishourroom, string lastTime, string WeiXinID, out string res, out string did)
        {
            try
            {
                Hotel hotel = Cache.GetHotel(Convert.ToInt32(hotelorder.HotelID));
                hotel.SmsMobile = Cache.GetMobile(hotel.WeiXinID);
                List<hotel3g.Models.Room> rooms = Cache.GetRoomsForDate(hotel, hotelorder.YinDate, hotelorder.YoutDate);
                string RoomName = "", RatePlanName = "";
                string yPriceStr = "";
                int datePrice = 0;
                foreach (var room in rooms)
                {
                    bool exitLoop = false;
                    foreach (var r in room.RatePlans)
                    {
                        if (r.ID.ToString().Equals(hotelorder.RatePlanID))
                        {
                            RoomName = room.RoomName;
                            RatePlanName = r.RatePlanName;
                            exitLoop = true;
                            string result = "", datestr = "";
                            foreach (var rate in r.Rates)
                            {
                                datestr = rate.Dates.ToString("yyyy-M-dd");
                                result += "price" + datestr + "|" + rate.Price + "|money" + datestr + "|0|";
                                datePrice += rate.Price;
                            }
                            yPriceStr = result;
                            break;
                        }
                    }
                    if (exitLoop) break;
                }
                if (hotel != null)
                {
                    string orderid = "";
                    // string uid = CheckMember(LinkTel, WeiXinID, UserWeiXinID, HotelID, hotel.SubName.ToString(),UserName);
                    //if (!string.IsNullOrEmpty(uid))
                    //{
                    int roomcount = hotelorder.YRoomNum;
                    int Unitprice = datePrice * roomcount;
                    string ordercode = GetOrderCode().ToString();
                    Dictionary<string, HotelCloud.SqlServer.DBParam> param = new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"HotelID",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.HotelID.ToString()}},
                            {"HotelName",new HotelCloud.SqlServer.DBParam{ParamValue=hotel.SubName.ToString()}},
                            {"RoomID",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.RoomID .ToString()}},
                            {"RoomName",new HotelCloud.SqlServer.DBParam{ParamValue=RoomName.ToString()}},
                            {"RatePlanID",new HotelCloud.SqlServer.DBParam{ParamValue= hotelorder.RatePlanID.ToString()}},
                            {"RatePlanName",new HotelCloud.SqlServer.DBParam{ParamValue=RatePlanName.ToString()}},
                            {"yinDate",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.YinDate .ToString()}},
                            {"youtDate",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.YoutDate .ToString()}},
                            {"ishourroom",new HotelCloud.SqlServer.DBParam{ParamValue=ishourroom.ToString()}},
                            {"ySumPrice",new HotelCloud.SqlServer.DBParam{ParamValue=Unitprice.ToString()}},
                            {"sSumPrice",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.sSumPrice.ToString()}},
                            {"yRoomNum",new HotelCloud. SqlServer.DBParam{ParamValue=hotelorder.YRoomNum .ToString()}},
                            {"PayType",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.PayType}},
                            {"lastTime",new HotelCloud.SqlServer.DBParam{ParamValue=lastTime.ToString()}},
                            {"UserName",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.UserName .ToString()}},
                            {"LinkTel",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder. LinkTel.ToString()}},
                            {"UserWeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.UserWeiXinID .ToString()}},
                            {"WeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=WeiXinID.ToString()}},
                            {"HotelTel",new HotelCloud.SqlServer.DBParam{ParamValue=hotel.Tel.ToString()}},
                            {"OrderNO",new HotelCloud.SqlServer.DBParam{ParamValue=ordercode.ToString()}},
                            //memberid {"UserID",new HotelCloud.SqlServer.DBParam{ParamValue=""}},
                            {"UserID",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.memberid}},

                            {"yPriceStr",new HotelCloud.SqlServer.DBParam{ParamValue=yPriceStr}},
                            {"jifen",new HotelCloud.SqlServer.DBParam{ParamValue=((int)(hotel.JifenFav*Unitprice)).ToString()}},
                            {"NetPrice",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.NetPrice.ToString()}},
                            {"RealPrice",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.RealPrice.ToString()}},
                            {"state",new HotelCloud.SqlServer.DBParam{ ParamValue="1"} }
                        };
                    string sql = @"insert into HotelOrder(OrderNO,LinkTel,UserName,UserID,UserWeiXinID,HotelID,HotelName,WeiXinID,RoomID,RoomName,demo,RatePlanID,RatePlanName,yRoomNum,yinDate,youtDate,Ordertime,PayType,lastTime,state,yPriceStr,ySumPrice,sRoomNum,sinDate,soutDate,sPriceStr,sSumPrice,Remark,Source,ip,jifen,NetPrice,RealPrice) values (@OrderNO,@LinkTel,@UserName,@UserID,@UserWeiXinID,@HotelID,@HotelName,@WeiXinID,@RoomID,@RoomName,'',@RatePlanID,@RatePlanName,@yRoomNum,@yinDate,@youtDate,getdate(),@PayType,@lastTime,@state,@yPriceStr,@ySumPrice,0,@yinDate,@youtDate,@yPriceStr,@sSumPrice,'0','3gweb','',@jifen,@NetPrice,@RealPrice) select id = scope_identity()";
                    DataTable DT = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), param);
                    if (DT.Rows.Count > 0) orderid = DT.Rows[0][0].ToString();

                    if (uguarantee != null)
                    {
                        uguarantee.OrderNo = ordercode;
                        UserGuarantee.SaveUserGuarantee(uguarantee);
                    }
                    if (hotelorder.PayType != "0")  //非预付订单发送短信，预付订单待客人付款完成后发送确认短信
                    {
                        //string tsql = @"insert into Tasks(TaskContent,TaskTime,TaskState,weixinid,hotelid,SendState,mobile,orderNO,TaskType) values(@Content,getdate(),0,@Uwx,@Hid,0,@mobile,@orderNO,'2')";
                        //int createStatus = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                        //    {"Content",new HotelCloud.SqlServer.DBParam{ParamValue=string.Format("{7}({0})预订{1}间{2}{3}{4}元,{5}入住{6}退房[微可牛]",
                        //        hotelorder.LinkTel.ToString(),hotelorder.YRoomNum.ToString(),
                        //        RoomName.ToString(),RatePlanName.ToString(),hotelorder.sSumPrice,
                        //        hotelorder.YinDate.ToString("yyyy-MM-dd"),hotelorder.YoutDate.ToString("yyyy-MM-dd"),hotelorder.UserName)}},
                        //    {"Uwx",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.UserWeiXinID}},
                        //    {"Hid",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.HotelID.ToString()}},
                        //    {"mobile",new HotelCloud.SqlServer.DBParam{ParamValue=hotel.SmsMobile}},             
                        //    {"orderNO",new HotelCloud.SqlServer.DBParam{ParamValue=orderid.ToString()}},
                        //});

                        //tsql = @"insert into Tasks(TaskContent,TaskTime,TaskState,weixinid,hotelid,SendState,mobile,orderNO,TaskType) values(@Content,getdate(),0,@Uwx,@Hid,0,@mobile,@orderNO,'2')";
                        //HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "Content", new HotelCloud.SqlServer.DBParam { ParamValue = "您的订单已提交，工作人员会尽快与您联系，核实并确认您的订单信息，以工作人员确认为准。[微可牛]" } }, { "Uwx", new HotelCloud.SqlServer.DBParam { ParamValue = hotelorder.UserWeiXinID } }, { "Hid", new HotelCloud.SqlServer.DBParam { ParamValue = hotelorder.HotelID.ToString() } }, { "mobile", new HotelCloud.SqlServer.DBParam { ParamValue = hotelorder.LinkTel.ToString() } }, { "orderNO", new HotelCloud.SqlServer.DBParam { ParamValue = orderid.ToString() } } });

                    }
                    if (!(hotelorder.CouponID.Equals("0") || string.IsNullOrEmpty(hotelorder.CouponID)))
                    {
                        HotelCloud.SqlServer.SQLHelper.Run_SQL("update couponcontent set IsEmploy=1,EmployTime=getdate(),orderID=@orderid where weixinid=@weixinid and userweixinNo=@userweixinNO and id=@couponid", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"orderid",new HotelCloud.SqlServer.DBParam{ParamValue=orderid}},
                            {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=WeiXinID}},
                            {"userweixinNO",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.UserWeiXinID}},
                            {"couponid",new HotelCloud.SqlServer.DBParam{ParamValue=hotelorder.CouponID}}
                            });
                    }
                    res = "true"; did = ordercode;
                    //}
                    //else{res = "false"; did = "";}
                }
                else { res = "false"; did = ""; }
            }
            catch { res = "false"; did = ""; }

            if (hotelorder.PayType != "0")  //非预付订单发送短信，预付订单待客人付款完成后发送确认短信
            {
                //Task a = new Task(new WeiXinHelper(WeiXinID, "您的订单已经提交\n我们会马上帮您确认，请稍等！", hotelorder.UserWeiXinID).Send);
                //Task a = new Task(new WeiXinHelper(WeiXinID, "您的订单已提交\n工作人员会尽快与您联系，核实并确认您的订单信息，以工作人员确认为准。", hotelorder.UserWeiXinID).Send);
                //a.Start(); 
            }
        }

        /// <summary>
        /// 生成单据号
        /// </summary>
        public static string GetOrderCode()
        {
            return string.Format("w{0}", DateTime.Now.ToString("yyMMddHHmmssfff"));
            // string formcode = "WX";
            //formcode += DateTime.Now.Year.ToString();
            //formcode += DateTime.Now.Month.ToString().Length == 1 ? "0" + DateTime.Now.Month.ToString() : DateTime.Now.Month.ToString();
            //formcode += DateTime.Now.Day.ToString().Length == 1 ? "0" + DateTime.Now.Day.ToString() : DateTime.Now.Day.ToString();
            //formcode += DateTime.Now.Hour.ToString().Length == 1 ? "0" + DateTime.Now.Hour.ToString() : DateTime.Now.Hour.ToString();
            //formcode += DateTime.Now.Minute.ToString().Length == 1 ? "0" + DateTime.Now.Minute.ToString() : DateTime.Now.Minute.ToString();
            //formcode += DateTime.Now.Second.ToString().Length == 1 ? "0" + DateTime.Now.Second.ToString() : DateTime.Now.Second.ToString();
            //if (DateTime.Now.Millisecond.ToString().Length == 1)
            //    formcode += "00" + DateTime.Now.Millisecond.ToString();
            //else if (DateTime.Now.Millisecond.ToString().Length == 2)
            //    formcode += "0" + DateTime.Now.Millisecond.ToString();
            //else
            //    formcode += DateTime.Now.Millisecond.ToString();
            //return formcode;
        }

        /// <summary>
        /// 生成价格字符串
        /// </summary>
        public static string GetOrderTimeStr(string yindata, string youtdata, string yroomnum, int AvgPrice)
        {
            //房价*日期天数*房间数量=ySumPrice                  
            int days = (DateTime.Parse(youtdata) - DateTime.Parse(yindata)).Days;
            if (days > 0 && AvgPrice > 0)
            {
                string result = ""; string datestr = "";
                for (int i = 0; i < days; i++)
                {
                    datestr = DateTime.Parse(yindata).Date.ToString("yyyy-M-dd");
                    result += "price" + datestr + "|" + AvgPrice.ToString() + "|money" + datestr + "|0|";
                }
                return (!result.Equals("")) ? result.Substring(0, result.Length - 1) : result;
            }
            return "";
        }

        /// <summary>
        /// 查看是否已经是会员了 
        /// </summary>
        public static string CheckMember(string m, string hwx, string uwx, string hid, string hname, string username)
        {
            try
            {
                string uid = "";
                Dictionary<string, HotelCloud.SqlServer.DBParam> dbparam = new Dictionary<string, HotelCloud.SqlServer.DBParam>();
                HotelCloud.SqlServer.DBParam mparam = new HotelCloud.SqlServer.DBParam { ParamValue = m.ToString() };
                dbparam.Add("mobile", mparam);
                HotelCloud.SqlServer.DBParam hwxparam = new HotelCloud.SqlServer.DBParam { ParamValue = hwx.ToString() };
                dbparam.Add("WeiXinID", hwxparam);
                DataTable table = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select top 1 id from Hotelmember where mobile=@mobile and WeiXinID=@WeiXinID", HotelCloud.SqlServer.SQLHelper.GetCon(), dbparam);
                if (table.Rows.Count > 0) return table.Rows[0]["id"].ToString();
                string sql = @"insert into Hotelmember(Name,mobile,WeiXinID,password,UserWeiXinID,hotelid) values (@name,@mobile,@WeiXinID,@password,@UserWeiXinID,@hid) select id = scope_identity() ";
                DataTable DT = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                    {"mobile",new HotelCloud.SqlServer.DBParam{ParamValue=m}},
                    {"WeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=hwx}},
                    {"password",new HotelCloud.SqlServer.DBParam{ParamValue=m.Substring(m.Length-6)}},
                    {"UserWeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=uwx}},
                    {"hid",new HotelCloud.SqlServer.DBParam{ParamValue=hid}},
                    {"name",new HotelCloud.SqlServer.DBParam{ParamValue=username}}
                });
                if (DT.Rows.Count > 0) uid = DT.Rows[0][0].ToString();
                string kk = string.Format("{0}:{1}:{2}", m, m.Substring(m.Length - 6), hname);
                string tsql = @"insert into Tasks(TaskContent,TaskTime,TaskState,weixinid,hotelid,orderNO,SendState,mobile,TaskType) values(@Content,getdate(),0,@Hwx,@Hid,0,0,@mobile,'1')";
                int createStatus = HotelCloud.SqlServer.SQLHelper.Run_SQL(tsql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                    {"Content",new HotelCloud.SqlServer.DBParam{ParamValue=string.Format("{0}您已注册为{1}会员，通过微信预订酒店即享会员优惠,会员登录密码为{2}[{3}]", m,hname,m.Substring(m.Length - 6),hname).ToString()}},
                    {"Hwx",new HotelCloud.SqlServer.DBParam{ParamValue=uwx}},
                    {"Hid",new HotelCloud.SqlServer.DBParam{ParamValue=hwx}},
                    {"mobile",new HotelCloud.SqlServer.DBParam{ParamValue=m}}             
                });
                return uid;

            }
            catch { return ""; }
        }

        public static string getTemp(string weixinid)
        {
            string sql = "select top 1 templet from WeiXinNO where WeiXinID=@weixinid";
            string res = HotelCloud.SqlServer.SQLHelper.Get_Value(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "weixinid", new HotelCloud.SqlServer.DBParam { ParamValue = weixinid } } });

            return res;
        }
        /// <summary>
        /// 获取房间信息
        /// </summary>
        /// <param name="roomId"></param>
        /// <returns></returns>
        public static DataTable GetHotelRoom(int roomId, int rateplanId)
        {
            string sql = @"select  H.id,H.roomName,H.BedType,H.BedArea,H.Area,R.zaocan,I.url from HotelRoom as H
                         left join HotelRatePlan as R on R.RoomID=H.id and R.id=@rateplanId
                         left join RoomTypeImg as I on I.roomid=H.id
                         where H.id=@roomId";
            return HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            { "roomId", new HotelCloud.SqlServer.DBParam { ParamValue = roomId.ToString() } }, 
            { "rateplanId", new HotelCloud.SqlServer.DBParam { ParamValue = rateplanId.ToString() } }, 
            });
        }
        /// <summary>
        /// 获取酒店的设施服务
        /// </summary>
        /// <param name="hotelId"></param>
        /// <returns></returns>
        public static DataTable GetHotelService(int hotelId)
        {
            string sql = "select id,WeiXinID,SubName,fuwu,canyin,yule,kefang from hotel with(nolock) where id=@hotelId";
            return HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            { "hotelId", new HotelCloud.SqlServer.DBParam { ParamValue = hotelId.ToString() } } 
            });
        }
        /// <summary>
        /// 获取酒店设施服务的图片
        /// </summary>
        /// <param name="hotelId"></param>
        /// <returns></returns>
        public static DataTable GetHotelFacilityImages(int hotelId)
        {
            string sql = "select fId,hotelId,typeId,facilityName,facilityDescription,facilityImages from dbo.FacilityImages with(nolock)  where hotelId=@hotelId";
            return HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            { "hotelId", new HotelCloud.SqlServer.DBParam { ParamValue = hotelId.ToString() } } 
            });
        }
        /// <summary>
        /// 获取酒店图片
        /// </summary>
        /// <param name="hotelId"></param>
        /// <returns></returns>
        public static DataTable GetHotelRoomImages(int hotelId)
        {
            string SqlStr = @"select R.*,H.roomName from RoomTypeImg as R
                            left join HotelRoom as H on H.hotelID=R.hotelID and H.id=R.roomid
                            where R.hotelID=@hotelId AND R.imgType NOT IN(4,5)";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(SqlStr, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "hotelId", new HotelCloud.SqlServer.DBParam { ParamValue = hotelId.ToString() } } });
            return dt;
        }




        public static Hotel GetMainIndexHotel(int hotelId, bool iscache=false)
        {

            string cacheName = "tels_" + hotelId;
            if (iscache && cache[cacheName] != null)
            {
                return (Hotel)cache[cacheName];
            } 

            string SqlStr = @"select  subName,quanjing,mainpic,Tel,HotelLog  from  hotel with(nolock)  where Id=@hotelId ";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(SqlStr, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "hotelId", new HotelCloud.SqlServer.DBParam { ParamValue = hotelId.ToString() } } });

            Hotel model = new Hotel();
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                model.Quanjing = dt.Rows[i]["quanjing"].ToString();
                model.SubName = dt.Rows[i]["SubName"].ToString();
                model.MainPic = dt.Rows[i]["mainpic"].ToString();
                model.Tel = dt.Rows[i]["Tel"].ToString();
                model.HotelLog = dt.Rows[i]["HotelLog"].ToString();
            }

            if (iscache)
            {
                cache.Insert(cacheName, model, null, DateTime.Now.AddMinutes(30), TimeSpan.Zero);
            }

            return model;
        }


        public static string GetHotelTel(int hotelId)
        {
            string cacheName = "tel_" + hotelId;

            if (cache[cacheName] != null)
            {
                return cache[cacheName].ToString();
            }



            string SqlStr = @"select  tel  from  hotel with(nolock)  where Id=@hotelId ";
            DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(SqlStr, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "hotelId", new HotelCloud.SqlServer.DBParam { ParamValue = hotelId.ToString() } } });

            string tel = string.Empty;

            if (dt.Rows.Count > 0)
            {
                tel = dt.Rows[0]["tel"].ToString();
            }

            if (!string.IsNullOrEmpty(tel))
            {
                cache.Insert("tel_" + hotelId, tel, null, DateTime.Now.AddMinutes(30), TimeSpan.Zero);

            }


            return tel;
        }






    }
    public class HotelNews
    {
        public int Id { get; set; }
        public int HotelID { get; set; }
        public string Title { get; set; }
        public string AddTime { get; set; }
        public string Content { get; set; }
        public string CoverImage { get; set; }
    }
}