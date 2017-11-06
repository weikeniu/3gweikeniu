using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using hotel3g.Models;
using HotelCloud.Common;
using System.Data;
using hotel3g.Models.Home;
using System.Text;
using hotel3g.Models.DAL;

namespace hotel3g.Controllers
{
    public class ZhiNengController : Controller
    {
        private static System.Web.Caching.Cache cache = HttpRuntime.Cache;

        public ActionResult Index(string id)
        {
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            if (!userWeiXinID.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, userWeiXinID.Split('@')[0]);
            }
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (weixinID.Equals(""))
            {
                weixinID = userWeiXinID.Split('@')[0];
            }
            //int hotelId=HotelCloud.Common.HCRequest.getInt("hId");

            IList<Advertisement> list = new List<Advertisement>();

            string cacheName = string.Format("{0}_{1}", weixinID, "mainindex");
            if (cache[cacheName] != null)
            {
                list = (List<Advertisement>)cache[cacheName];
            }

            else
            {
                list = Advertisement.GetAdvertisementBySort(weixinID);
                cache.Insert(cacheName, list, null, DateTime.Now.AddMinutes(30), TimeSpan.Zero);
            }


            if (list != null && list.Count == 0)
            {
                //创建虚拟
                string[] imgs = { "/img/ad_01.jpg", "/img/ad_02.jpg", "/img/ad_03.jpg", "/img/ad_04.jpg", "/img/ad_05.jpg" };
                string imgwebsite = System.Configuration.ConfigurationManager.AppSettings["imgwebsite"] == null ? "http://admin.weikeniu.com" : System.Configuration.ConfigurationManager.AppSettings["imgwebsite"].ToString();
                foreach (string str in imgs)
                {
                    Advertisement ad = new Advertisement();
                    ad.ImageUrl = imgwebsite + str;
                    list.Add(ad);
                }
            }
            ViewData["ad"] = list;
            ViewData["hId"] = id;
            ViewData["weixinID"] = weixinID;
            ViewData["userWeiXinID"] = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);

            Hotel hotel = new Hotel();
            string cache_hotelName = string.Format("{0}_{1}", id, "mainindex");
            if (cache[cache_hotelName] != null)
            {
                hotel = (Hotel)cache[cache_hotelName];
            }
            else
            {
                hotel = HotelHelper.GetMainIndexHotel(Convert.ToInt32(id));
                cache.Insert(cache_hotelName, hotel, null, DateTime.Now.AddMinutes(30), TimeSpan.Zero);
            }

            ViewData["hotel"] = hotel.SubName;
            ViewData["quanjing"] = hotel.Quanjing;
            ViewData["tel"] = hotel.Tel;

            string sql = @"select  userid   from  WeiXinNO with(nolock)  where weixinid=@weixinid ";
            string userId = HotelCloud.SqlServer.SQLHelper.Get_Value(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "weixinid", new HotelCloud.SqlServer.DBParam { ParamValue = weixinID } } });

            ViewData["userId"] = userId;
 

            return View();
        }


        [Models.Filter]
        public ActionResult FanYi(string id)
        {
            return View();
        }
        [Models.Filter]
        public ActionResult DaChe(string id)
        {
            return View();
        }


        public ActionResult WakeService()
        {
            return View();
        }
        public ActionResult CleanService()
        {
            return View();
        }


        public ActionResult WaterClothesService()
        {
            return View();
        }


        public ActionResult GoodsService()
        {
            return View();
        }

        public ActionResult FrontService()
        {
            return View();
        }

        public ActionResult FeedbackService(string id)
        {

            Hotel hotel = new Hotel();
            string cache_hotelName = string.Format("{0}_{1}", id, "mainindex");
            if (cache[cache_hotelName] != null)
            {
                hotel = (Hotel)cache[cache_hotelName];
            }
            else
            {
                hotel = HotelHelper.GetMainIndexHotel(Convert.ToInt32(id));
                cache.Insert(cache_hotelName, hotel, null, DateTime.Now.AddMinutes(30), TimeSpan.Zero);
            }

            ViewData["hotel"] = hotel.SubName;
            return View();
        }


        public ActionResult FaPiaoService()
        {

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            int hid = Convert.ToInt32(RouteData.Values["Id"]);

            string usermobile = string.Empty;
            DataTable dbmember = WeiXin.Models.Home.RechargeCard.GetRechargeMemberInfo(hotelweixinId, userweixinId);
            if (dbmember.Rows.Count > 0)
            {
                usermobile = dbmember.Rows[0]["mobile"].ToString();
            }


            string sql = "select * from  fapiaoManager   with(Nolock)  where userweixinid=@userweixinid  order by isdefault desc";

            if (!string.IsNullOrEmpty(usermobile))
            {
                sql = "select * from  fapiaoManager with(Nolock)  where usermobile=@usermobile  or  userweixinid=@userweixinid  order by isdefault desc";
            }

            DataTable db = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {     
                 {"usermobile",new HotelCloud.SqlServer.DBParam{ParamValue=usermobile.ToString()}},
                 {"userweixinid",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId.ToString()}}

                });



            ViewData["db"] = db;


            return View();
        }


        public ActionResult AirportService()
        {
            return View();
        }

        public ActionResult BaggageService()
        {
            return View();
        }

        public ActionResult AddFaPiao()
        {
            int Id = HCRequest.getInt("Id");

            if (Id > 0)
            {
                string uId = HCRequest.GetString("uId");

                DataTable db = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select * from  fapiaoManager with(Nolock)  where Id=@Id and userweixinid=@userweixinid", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {     
               {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id.ToString()}},
               {"userweixinid",new HotelCloud.SqlServer.DBParam{ParamValue=uId.ToString()}},
            });

                ViewData["name"] = db.Rows[0]["name"].ToString();
                ViewData["taxnum"] = db.Rows[0]["taxnum"].ToString();
                ViewData["linktel"] = db.Rows[0]["linktel"].ToString();
            }


            return View();
        }

        public ActionResult FaPiaoManager()
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            int hid = Convert.ToInt32(RouteData.Values["Id"]);


            string usermobile = string.Empty;
            DataTable dbmember = WeiXin.Models.Home.RechargeCard.GetRechargeMemberInfo(hotelweixinId, userweixinId);
            if (dbmember.Rows.Count > 0)
            {
                usermobile = dbmember.Rows[0]["mobile"].ToString();
            }


            string sql = "select * from  fapiaoManager   with(Nolock)  where userweixinid=@userweixinid  order by isdefault desc";

            if (!string.IsNullOrEmpty(usermobile))
            {
                sql = "select * from  fapiaoManager with(Nolock)  where usermobile=@usermobile  or  userweixinid=@userweixinid  order by isdefault desc ";
            }

            DataTable db = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {     
                 {"usermobile",new HotelCloud.SqlServer.DBParam{ParamValue=usermobile.ToString()}},
                 {"userweixinid",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId.ToString()}}

                });



            ViewData["db"] = db;


            return View();


        }


        [HttpPost]
        [Models.Filter]
        public ActionResult AddEditServices()
        {
            int status = -1;
            string errmsg = "保存失败";

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            int hotelId = HotelCloud.Common.HCRequest.getInt("hotelId");

            string servicetime = HCRequest.GetString("servicetime").Trim();
            string roomno = HCRequest.GetString("roomno").Trim();
            string phonenumber = HCRequest.GetString("phonenumber").Trim();
            string remark = HCRequest.GetString("remark").Trim();
            int type = Convert.ToInt32(HCRequest.GetString("type"));

            string goods = HCRequest.GetString("goods").Trim();
            string username = HCRequest.GetString("username").Trim();

            string yzmcode = HCRequest.GetString("yzmcode").Trim();

            string feedback1 = HCRequest.GetString("hotelservice").Trim();
            string feedback2 = HCRequest.GetString("bestmanyi").Trim();
            string feedback3 = HCRequest.GetString("bestbumanyi").Trim();
            string feedback4 = HCRequest.GetString("againhotel").Trim();
            string feedback5 = HCRequest.GetString("otheryijian").Trim();
            string ftype = HCRequest.GetString("fType").Trim();

            decimal fpmoney = 0;
            if (!string.IsNullOrEmpty(HCRequest.GetString("fpmoney")))
            {
                fpmoney = Convert.ToDecimal(HCRequest.GetString("fpmoney"));
            }

            //  if (type == 4 || type == 7)
            if (1 == 2)
            {
                string channel = "用户前台服务";
                if (type == 7)
                {
                    channel = "用户机场服务";
                }
                string smsCode = HotelCloud.SqlServer.SQLHelper.Get_Value("select  SmsCode from wkn_smssend with(nolock) where  weixinId=@weixinId and  mobile=@mobile and  addTime>@addTime  and channel=@channel  order by addtime desc",
                       HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {
                                              {"Mobile",new HotelCloud.SqlServer.DBParam{ParamValue=phonenumber}},    
                                              {"WeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId }},
                                              {"addTime",new HotelCloud.SqlServer.DBParam{ParamValue=DateTime.Now.AddMinutes(-5).ToString()  }},
                                              {"channel",new HotelCloud.SqlServer.DBParam{ParamValue=channel  }} 
                });


                if (string.IsNullOrEmpty(smsCode) || yzmcode != smsCode)
                {
                    status = -1;
                    errmsg = "验证码错误";
                    return Json(new
                    {
                        Status = status,
                        Mess = errmsg

                    }, JsonRequestBehavior.AllowGet);

                }

            }
            HotelServices model = new HotelServices();
            model.WeiXinId = hotelweixinId;
            model.UserweixinId = userweixinId;
            model.AddTime = DateTime.Now;
            model.Mobile = phonenumber;
            model.RoomNo = roomno;
            model.ServiceTime = servicetime;
            model.Remark = remark;
            model.Type = type;
            model.Goods = goods;
            model.UserName = username;

            model.Feedback1 = feedback1;
            model.Feedback2 = feedback2;
            model.Feedback3 = feedback3;
            model.Feedback4 = feedback4;
            model.Feedback5 = feedback5;
            model.FMoney = fpmoney;
            model.FType = ftype;


            model.HotelId = hotelId;
            int rows = HotelServices.AddHotelServices(model);

            if (rows > 0)
            {
                status = 0;
                errmsg = "保存成功";


                // 0 清洁，1 叫醒，2洗衣，3物品借用，4前台，5反馈  6 预约发票 7机场接送  8行李寄运
                string k_userName = string.Empty;
                string k_serviceName = string.Empty;
                string k_yudate = string.Empty;
                string k_yuresult = string.Empty;
                string k_remark = string.Empty;
                if (type == 0){k_serviceName = "清洁服务";k_userName = "手机号" + phonenumber + " 房号" + roomno;k_yudate = servicetime;k_remark = string.IsNullOrEmpty(remark) ? "" : "特殊要求: " + remark; }
                if (type == 1){k_serviceName = "叫醒服务";k_userName = "手机号" + phonenumber + " 房号" + roomno;k_yudate = servicetime;k_remark = string.IsNullOrEmpty(remark) ? "" : "提醒事由: " + remark; }
                if (type == 2){k_serviceName = "洗衣服务";k_userName = "手机号" + phonenumber + " 房号" + roomno;k_yudate = servicetime;k_remark = string.IsNullOrEmpty(remark) ? "" : "特殊要求: " + remark; }
                if (type == 3){k_serviceName = "物品借用";k_userName = username +  " 房号" +roomno;k_yudate = servicetime;k_remark = "借用物品: "+goods;}
                if (type == 4){k_serviceName = "前台服务";k_userName = "手机号" + phonenumber + " 房号" + roomno; ;k_yudate = "";k_remark = string.IsNullOrEmpty(remark) ? "" : "服务内容: " + remark; }
                if (type == 7) { k_serviceName = "机场接送"; k_userName = "手机号" + phonenumber; k_yudate = servicetime; k_remark = "接送人数: " + remark + "\n服务内容: " + roomno + (!string.IsNullOrEmpty(goods) ? "\n航班信息: " + goods : ""); }
                if (type == 8)
                {
                    k_serviceName = "行李寄运";
                    k_userName = "手机号" + phonenumber + " 房号" + roomno;
                    k_yudate = "";
                    k_remark = "收件人: " + username + "\n收件电话: " + feedback1 + "\n收件地址: " + feedback2 + "\n寄送物品: " + goods + (string.IsNullOrEmpty(remark) ? "" : "其它说明: " + remark);
                }
                if (type == 6)
                {
                    k_serviceName = "预约发票:" + ftype;
                    k_userName = username + " 房号" + roomno;
                    k_yudate ="默认退房领取";
                    k_remark = "请登录微可牛后台详细查询发票内容";
                }
                if (k_serviceName != string.Empty)
                {
                    string postStr = string.Format("action=services&k_serviceName={0}&k_userName={1}&k_yudate={2}&k_remark={3}&k_hid={4}", k_serviceName, k_userName, k_yudate, k_remark,hotelId);
                    byte[] postData = Encoding.UTF8.GetBytes(postStr);
                    WeiXin.Common.NormalCommon.doPost(System.Configuration.ConfigurationManager.AppSettings["sendwxmsg_url"].ToString(), postData);
                } 
            }
            return Json(new{Status = status,Mess = errmsg}, JsonRequestBehavior.AllowGet);
        }



        [HttpPost]
        [Models.Filter]
        public ActionResult AddEditFaPiao()
        {
            int status = -1;
            string errmsg = "保存失败";

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            int hotelId = HotelCloud.Common.HCRequest.getInt("hotelId");

            string f_name = HCRequest.GetString("f_name").Trim();
            string f_no = HCRequest.GetString("f_no").Trim();
            string phonenumber = HCRequest.GetString("phonenumber").Trim();

            int Id = HCRequest.getInt("Id");
            string uId = HCRequest.GetString("uId");
            string type = HCRequest.GetString("type");

            string usermobile = string.Empty;
            DataTable dbmember = WeiXin.Models.Home.RechargeCard.GetRechargeMemberInfo(hotelweixinId, userweixinId);
            if (dbmember.Rows.Count > 0)
            {
                usermobile = dbmember.Rows[0]["mobile"].ToString();
            }


            if (type == "del")
            {
                int rows = HotelCloud.SqlServer.SQLHelper.Run_SQL("delete from  FapiaoManager where Id=@Id and userweixinId=@userweixinid ", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {     
                 {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id.ToString()}},
                 {"userweixinid",new HotelCloud.SqlServer.DBParam{ParamValue=uId}}

                });

                if (rows > 0)
                {
                    status = 0;
                    errmsg = "删除成功";
                }
            }




            else if (type == "default")
            {
                string sql = "update   fapiaoManager    set  IsDefault=0   where userweixinid=@userweixinid ";

                if (!string.IsNullOrEmpty(usermobile))
                {
                    sql = "update   fapiaoManager    set  IsDefault=0    where usermobile=@usermobile  or  userweixinid=@userweixinid   ";
                }

                sql += " update   fapiaoManager    set  IsDefault=1      where Id=@Id and userweixinId=@uId  ";

                int rows = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {     
                 {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id.ToString()}},
                 {"userweixinid",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}},
                  {"uId",new HotelCloud.SqlServer.DBParam{ParamValue=uId}},
                  {"usermobile",new HotelCloud.SqlServer.DBParam{ParamValue=usermobile}}
                });

                if (rows > 0)
                {
                    status = 0;
                    errmsg = "设置成功";
                }
            }


            else
            {


                if (Id == 0)
                {

                    StringBuilder strSql = new StringBuilder();
                    strSql.Append("insert into FapiaoManager(");
                    strSql.Append("HotelId,weixinId,userweixinId,UserMobile,Name,TaxNum,LinkTel");
                    strSql.Append(") values (");
                    strSql.Append("@HotelId,@weixinId,@userweixinId,@UserMobile,@Name,@TaxNum,@LinkTel");
                    strSql.Append(") ");
                    strSql.Append(";select @@IDENTITY");
                    string obj = HotelCloud.SqlServer.SQLHelper.Get_Value(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"HotelId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelId.ToString()}},
             {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=hotelweixinId}},
              {"userweixinId",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}},
             {"Name",new HotelCloud.SqlServer.DBParam{ParamValue=f_name}},             
              {"TaxNum",new HotelCloud.SqlServer.DBParam{ParamValue=f_no}},
             {"LinkTel",new HotelCloud.SqlServer.DBParam{ParamValue=phonenumber}},
              {"UserMobile",new HotelCloud.SqlServer.DBParam{ParamValue=usermobile}},
            });

                    if (Convert.ToInt32(obj) > 0)
                    {
                        status = 0;
                        errmsg = "添加成功";
                    }
                }



                else
                {
                    StringBuilder strSql = new StringBuilder();
                    strSql.Append("update  FapiaoManager  set  ");
                    strSql.Append("UserMobile=@UserMobile ,");
                    strSql.Append("Name=@Name ,");
                    strSql.Append("TaxNum=@TaxNum ,");
                    strSql.Append("LinkTel=@LinkTel ");
                    strSql.Append(" where Id=@Id   and userweixinId=@userweixinId");


                    int rows = HotelCloud.SqlServer.SQLHelper.Run_SQL(strSql.ToString(), HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {     
             {"Name",new HotelCloud.SqlServer.DBParam{ParamValue=f_name}},             
              {"TaxNum",new HotelCloud.SqlServer.DBParam{ParamValue=f_no}},
             {"LinkTel",new HotelCloud.SqlServer.DBParam{ParamValue=phonenumber}},
              {"UserMobile",new HotelCloud.SqlServer.DBParam{ParamValue=usermobile}},
               {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id.ToString()}},
                {"userweixinId",new HotelCloud.SqlServer.DBParam{ParamValue=uId}},
            });

                    if (rows > 0)
                    {
                        status = 0;
                        errmsg = "保存成功";
                    }

                }


            }

            return Json(new
            {
                Status = status,
                Mess = errmsg

            }, JsonRequestBehavior.AllowGet);


        }

        [HttpPost]
        [Models.Filter]
        public ActionResult SendMsg()
        {
            int status = -1;
            string errmsg = "发送失败";


            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            string mobile = HCRequest.GetString("mobile").Trim();
            string Code = new Random().Next(100000, 999999).ToString();

            string type = HCRequest.GetString("type").Trim();

            string MsgContent = string.Format("前台服务验证码为:{0},5分钟内有效【微可牛】", Code);
            string channel = "用户前台服务";

            if (type == "air")
            {
                string.Format("机场接送验证码为:{0},5分钟内有效【微可牛】", Code);
                channel = "用户机场服务";
            }

            HotelCloud.SMS.SmsMD20140117 sms = new HotelCloud.SMS.SmsMD20140117();

            sms.ReceiveMobileNo = mobile;
            sms.Content = MsgContent;
            string res = sms.Send();
            if (res == "0")
            {
                int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@"insert into wkn_smssend(Mobile,SMSContent,SMSCode,Channel,Ip,WeiXinID) values(@Mobile,@SMSContent,@SMSCode,@Channel,@Ip,@WeiXinID);", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {
                                                {"Mobile",new HotelCloud.SqlServer.DBParam{ParamValue=mobile}},
                                                {"SMSContent",new HotelCloud.SqlServer.DBParam{ParamValue=MsgContent}},
                                                {"SMSCode",new HotelCloud.SqlServer.DBParam{ParamValue=Code}},
                                                {"Channel",new HotelCloud.SqlServer.DBParam{ParamValue= channel}},
                                                {"Ip",new HotelCloud.SqlServer.DBParam{ParamValue=GetIPAddress()}},
                                                {"WeiXinID",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId  }},
                           });

                status = 0;
                errmsg = "发送成功";
            }

            return Json(new
            {
                Status = status,
                Mess = errmsg

            }, JsonRequestBehavior.AllowGet);
        }




        public string GetIPAddress()
        {
            if (Request.ServerVariables["HTTP_VIA"] != null)
            {
                if (Request.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
                {
                    return Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
                }
                return Request.UserHostAddress;
            }
            return Request.ServerVariables["REMOTE_ADDR"].ToString();
        }



    }
}
