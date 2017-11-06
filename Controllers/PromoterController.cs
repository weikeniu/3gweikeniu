using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using HotelCloud.Common;
using HotelCloud.SqlServer;
using System.Drawing;
using hotel3g.Models.DAL;
using System.IO;
using System.Net;
using System.Text;
using System.Security.Cryptography;
using System.Data;
using hotel3g.Repository;
using WeiXinLibrary.Entity;
using WeiXinLibrary.Api;


namespace hotel3g.Controllers
{
    public class PromoterController : Controller
    {
        //推广员
        // GET: /Promoter/

        /// <summary>
        /// 推广页面
        /// </summary>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult Generalize(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string[] keys = key.Split('@');
            if (keys.Length == 2)
            {
                string weixinID = keys[0];
                string userWeiXinID = keys[1];

                ViewData["hid"] = id;
                ViewData["weixinID"] = weixinID;
                ViewData["userWeiXinID"] = userWeiXinID;

                hotel3g.Repository.MemberCard CurUser = hotel3g.Repository.MemberHelper.GetFXMemberCard(userWeiXinID, weixinID);


                if (string.IsNullOrEmpty(CurUser.photo))
                {
                    AccessToken TokenItem = MemberHelper.GetAccessToken(weixinID);
                    if (TokenItem.error == 1)
                    {
                        try
                        {
                            WeiXinUserInfo UserInfo = MemberHelper.GetUserWeixinInfo(TokenItem.message, userWeiXinID);
                            CurUser.nickname = UserInfo.nickname;
                            if (!string.IsNullOrEmpty(UserInfo.headimgurl))
                            {
                                CurUser.photo = UserInfo.headimgurl;
                                string sql_ = "UPDATE dbo.Member SET photo=@photo WHERE weixinID=@weixinID AND userWeiXinNO=@userWeiXinNO";
                                Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
                                Dic.Add("photo", new DBParam { ParamValue = CurUser.photo });
                                Dic.Add("weixinID", new DBParam { ParamValue = weixinID });
                                Dic.Add("userWeiXinNO", new DBParam { ParamValue = userWeiXinID });
                                int Count = SQLHelper.Run_SQL(sql_, SQLHelper.GetCon(), Dic);

                            }
                        }
                        catch { }

                    }
                }
                if (!string.IsNullOrEmpty(CurUser.photo))
                {
                    CurUser.photo = PromoterDAL.GetPromoterCoverImage(CurUser.photo, "PHOTO_" + userWeiXinID, id);
                }
                else
                {
                    CurUser.photo = "/images/member/wechat.png";
                }
                ViewData["CurUser"] = CurUser;
                //获取酒店信息
                hotel3g.Repository.HotelInfoItem HotelInfo = hotel3g.Repository.MemberHelper.GetHotelInfo(weixinID, id);
                ViewData["HotelLogo"] = PromoterDAL.GetPromoterCoverImage(HotelInfo.hotelLog, "hotelLog", id);
                ViewData["HotelInfo"] = HotelInfo;

                //获取公众号信息
                //string sql = "SELECT TOP 1 WeiXin2Img,appid,weixintype,WeiXinImg FROM dbo.WeiXinNO WITH(NOLOCK) WHERE WeiXinID=@WeiXinID";
                //DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                //{"WeiXinID",new DBParam{ParamValue=weixinID}}
                //});

                ViewData["weixintype"] = "0";
                hotel3g.PromoterEntitys.WeiXinPublicInfoResponse WeiXinPublicInfo = PromoterDAL.GetWeiXinPublicInfo(weixinID);
                if (WeiXinPublicInfo != null && !string.IsNullOrEmpty(WeiXinPublicInfo.appid))
                {
                    string weixintype = WeiXinPublicInfo.weixintype.ToString();
                    ViewData["weixintype"] = weixintype;
                    if (int.Parse(CurUser.memberid) > 0)
                    {
                        if (weixintype.Equals("4"))
                        {
                            string logourl = QR_Code_Url(int.Parse(CurUser.memberid), weixinID);
                            string Logo = PromoterDAL.GetPromoterCoverImage(logourl, "LOGO", id);
                            ViewData["Logo"] = Logo;
                        }
                        else
                        {
                            string logourl = "http://qr.liantu.com/api.php?text=" + HttpUtility.UrlEncode(string.Format("http://hotel.weikeniu.com/Promoter/Coupon/{0}?hid={1}", CurUser.memberid, id));
                            string Logo = PromoterDAL.GetPromoterCoverImage(logourl, "LOGO", id);
                            //生成跳转链接
                            ViewData["Logo"] = Logo;
                        }

                        if (string.IsNullOrEmpty(HotelInfo.MainPic))
                        {
                            //生成跳转链接
                            string backgroundurl = WeiXinPublicInfo.WeiXinImg;// dt.Rows[0]["WeiXinImg"].ToString();
                            string background = PromoterDAL.GetPromoterCoverImage(backgroundurl, "BACKGROUND", id);
                            ViewData["background"] = background;
                        }
                        else
                        {
                            //生成跳转链接
                            string backgroundurl = HotelInfo.MainPic.Split(';')[0];
                            string background = PromoterDAL.GetPromoterCoverImage(backgroundurl, "BACKGROUND", id);
                            ViewData["background"] = background;
                        }
                    }
                    ViewData["appid"] = WeiXinPublicInfo.appid;// dt.Rows[0]["appid"].ToString();
                }

                //获取红包信息
                string sql = "SELECT moneys,Remark,s_JiFen FROM dbo.CouPon WITH(NOLOCK) WHERE weixinID=@WeiXinID AND s_huodongid>0";
                System.Data.DataTable hongbao = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                {"WeiXinID",new DBParam{ParamValue=weixinID}}
                });
                var Signature = WeiXinJsSdkDAL.JsApiSignature(weixinID, Request.Url.AbsoluteUri);
                ViewData["timespan"] = Signature.timestamp;
                ViewData["signature"] = Signature;

                if (hongbao != null && hongbao.Rows.Count > 0)
                {
                    ViewData["Remark"] = hongbao.Rows[0]["Remark"].ToString();
                    ViewData["money"] = hongbao.Rows[0]["moneys"].ToString();
                    ViewData["info"] = hongbao.Rows[0]["Remark"].ToString();
                    ViewData["jifen"] = hongbao.Rows[0]["s_JiFen"].ToString();
                }
            }

            return View();
        }
        public ActionResult TuiGuangMember(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            if (!key.Equals(""))
            {
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", key.Split('@')[1], 30, key.Split('@')[0]);
            }
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
            if (weixinID.Equals(""))
            {
                weixinID = key.Split('@')[0];
                userWeiXinID = key.Split('@')[1];
            }

            ViewData["MemberCenterLogin"] = string.Format("/MemberCard/MemberCenterLogin/{0}?key={1}", id, key);
            //ViewData["MemberEditPassword"] = string.Format("/MemberCard/MemberEditPassword/{0}?key={1}", id, key);
            ViewData["hId"] = id;

            //获取是否开启了新版
            string sql = "SELECT edition FROM dbo.WeiXinNO WHERE WeiXinID=@WeiXinID";
            string value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"WeiXinID",new DBParam{ParamValue=weixinID}}
            });

            if (value.Equals("1"))
            {
                ViewData["MemberEditPassword"] = string.Format("/MemberCardA/MemberEditPassword/{0}?key={1}", id, key);
            }
            else
            {
                ViewData["MemberEditPassword"] = string.Format("/MemberCard/MemberEditPassword/{0}?key={1}", id, key);
            }

            MemberCard UserInfo = MemberHelper.GetMemberCardByUserWeiXinNO(weixinID, userWeiXinID);

            if (UserInfo == null || string.IsNullOrEmpty(UserInfo.memberid))
            {
                if (string.IsNullOrEmpty(UserInfo.memberid))
                {
                    //账户不存在 执行新增账户
                    string caozuo = string.Format("{0} 注册会员生成账户", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    MemberHelper.InsertUserAccount(weixinID, userWeiXinID, caozuo);
                }
            }

            //获取红包信息
            sql = "SELECT moneys FROM dbo.CouPon WITH(NOLOCK) WHERE weixinID=@WeiXinID AND s_huodongid>0";
            DataTable hongbao = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                {"WeiXinID",new DBParam{ParamValue=weixinID}}
                });


            if (hongbao != null && hongbao.Rows.Count > 0)
            {
                ViewData["hongbao"] = hongbao.Rows[0]["moneys"].ToString();
            }
            else
            {
                ViewData["hongbao"] = "0";
            }

            ViewData["UserInfo"] = UserInfo;

            string cardno = MemberHelper.GetCardNo(userWeiXinID, weixinID);
            if (!string.IsNullOrEmpty(cardno))
            {
                return RedirectToAction("Index", (value.Equals("1") ? "UserA" : "User"), new { id = id, key = key });
            }

            string notusedcardno = MemberHelper.GetNotUsedCard(id, weixinID);
            if (string.IsNullOrEmpty(notusedcardno))
            {
                ViewData["CanRegister"] = false;
            }
            else
            {
                ViewData["CanRegister"] = true;
            }


            if (string.IsNullOrEmpty(cardno))
            {
                ViewData["weixinID"] = weixinID;
                ViewData["hId"] = id;
                ViewData["userWeiXinID"] = userWeiXinID;
            }
            else
            {
                //已存在会员卡 跳转登录页面
                // return RedirectToAction("MemberCenterLogin", "MemberCard", new { id = id, key = key });
            }

            return View();
        }
        public ActionResult HotelQRCode()
        {
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinid");
            int hid = HotelCloud.Common.HCRequest.getInt("hid");
            int id = HotelCloud.Common.HCRequest.getInt("id");

            if (id <= 0 || hid <= 0)
            {
                return View();
            }
            ViewData["hid"] = hid;
            //获取酒店信息
            hotel3g.Repository.HotelInfoItem HotelInfo = hotel3g.Repository.MemberHelper.GetHotelInfo(weixinID, hid.ToString());
            ViewData["HotelInfo"] = HotelInfo;

            //获取公众号信息
            string sql = "   SELECT TOP 1 WeiXin2Img,appid,weixintype,WeiXinImg,WeiXinNO FROM dbo.WeiXinNO WITH(NOLOCK) WHERE WeiXinID=@WeiXinID";

            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { { "WeiXinID", new DBParam { ParamValue = weixinID } } });

            if (dt != null && dt.Rows.Count > 0)
            {
                ViewData["WeiXinNO"] = dt.Rows[0]["WeiXinNO"].ToString();
                ViewData["WeiXin2Img"] = dt.Rows[0]["WeiXin2Img"].ToString();
                ViewData["QR_Code"] = dt.Rows[0]["WeiXin2Img"].ToString();

                string weixintype = dt.Rows[0]["weixintype"].ToString();
                if (id > 0)
                {
                    if (weixintype.Equals("4"))
                    {

                        ViewData["QR_Code"] = QR_Code_Url(id, weixinID);
                    }
                    else
                    {
                        //生成跳转链接
                        ViewData["QR_Code"] = "http://qr.liantu.com/api.php?text=" + HttpUtility.UrlEncode(string.Format("http://hotel.weikeniu.com/Promoter/Coupon/{0}?hid={1}", id, hid));
                    }
                }
            }
            return View();
        }
        public string QR_Code_Url(int id, string weixinid)
        {
            string sql = @"SELECT top 1 fxqrcode FROM dbo.Member WITH(NOLOCK) WHERE weixinID=@weixinID AND Id=@Id";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                  {"weixinID",new DBParam{ParamValue=weixinid }},
                {"Id",new DBParam{ParamValue=id.ToString()}}
                });
            if (dt.Rows.Count > 0)
            {
                string Value = dt.Rows[0]["fxqrcode"].ToString();

                if (string.IsNullOrEmpty(Value))
                {
                    //没有专属二维码 获一次
                    QR_CodeRequestHeader RequestHeader = new QR_CodeRequestHeader();
                    RequestHeader.action_name = "QR_LIMIT_STR_SCENE";
                    RequestHeader.action_info = new WeiXinLibrary.Entity.Action_Info() { scene = new WeiXinLibrary.Entity.Scene() { scene_str = id.ToString() } };

                    AccessToken TokenItem = MemberHelper.GetAccessToken(weixinid);
                    if (TokenItem.error == 1)
                    {
                        QR_CodeResponse QR_Code = RequestHeader.QR_Code(TokenItem.message);
                        ViewData["QR_Code"] = QR_Code.qrcode;
                        ///写入数据库
                        sql = "UPDATE dbo.Member SET fxqrcode=@fxqrcode WHERE id=@id";
                        int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
 {"fxqrcode",new DBParam{ParamValue=QR_Code.qrcode}},
                       {"id",new DBParam{ParamValue=id.ToString()}}
                       });
                        return QR_Code.qrcode;
                    }
                }
                else
                {
                    return Value;
                }
            }
            return null;
        }
        public ActionResult Coupon(int id)
        {
            //推广人id
            int memberid = id;
            int hid = HCRequest.getInt("hid");
            ViewData["memberid"] = memberid;
            ViewData["hid"] = hid;
            string sql = @"SELECT photo,nickname FROM dbo.Member WITH(NOLOCK) WHERE Id=@Id";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"Id",new DBParam{ParamValue=memberid.ToString()}}
            });
            MemberCard UserInfo = new MemberCard();
            if (dt != null && dt.Rows.Count > 0)
            {
                UserInfo.nickname = dt.Rows[0]["nickname"].ToString();
                UserInfo.photo = dt.Rows[0]["photo"].ToString();
            }
            ViewData["UserInfo"] = UserInfo;

            //获取酒店信息
            sql = @"SELECT TOP 1 WeiXinID,SubName,hotelLog FROM dbo.Hotel WITH(NOLOCK) WHERE id=@id";
            dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>(){
            {"id",new DBParam{ParamValue=hid.ToString()}}
            });
            HotelInfoItem HotelInfo = new HotelInfoItem();
            foreach (DataRow row in dt.Rows)
            {
                string logo = row["hotelLog"].ToString();
                string SubName = row["SubName"].ToString();
                string WeiXinID = row["WeiXinID"].ToString();
                HotelInfo.SubName = string.IsNullOrEmpty(SubName) ? "" : SubName;
                HotelInfo.hotelLog = string.IsNullOrEmpty(logo) ? "../../images/newlogo.png" : logo;
                HotelInfo.WeiXinID = string.IsNullOrEmpty(WeiXinID) ? "" : WeiXinID;
            }
            ViewData["HotelInfo"] = HotelInfo;

            //获取公众号信息
            sql = "SELECT TOP 1 WeiXin2Img,appid,weixintype FROM dbo.WeiXinNO WITH(NOLOCK) WHERE WeiXinID=@WeiXinID";
            DataTable dts = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                {"WeiXinID",new DBParam{ParamValue=HotelInfo.WeiXinID}}
                });


            if (dts != null && dts.Rows.Count > 0)
            {
                if (memberid > 0)
                {
                    string weixintype = dts.Rows[0]["weixintype"].ToString();
                    if (weixintype.Equals("4"))
                    {
                        ViewData["Logo"] = QR_Code_Url(memberid, HotelInfo.WeiXinID);
                    }
                    else
                    {
                        //获取公众号信息
                        sql = "SELECT TOP 1 WeiXin2Img FROM dbo.WeiXinNO WITH(NOLOCK) WHERE WeiXinID=@WeiXinID";
                        string value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                {"WeiXinID",new DBParam{ParamValue=HotelInfo.WeiXinID}}
                });
                        ViewData["Logo"] = value;
                    }
                }
            }

            //获取红包信息

            sql = "SELECT moneys,amountlimit,Remark FROM dbo.CouPon WITH(NOLOCK) WHERE weixinID=@WeiXinID AND s_huodongid>0";

            DataTable hongbao = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                {"WeiXinID",new DBParam{ParamValue=HotelInfo.WeiXinID}}
                });


            if (hongbao != null && hongbao.Rows.Count > 0)
            {
                ViewData["hongbao"] = hongbao.Rows[0]["moneys"].ToString();
                ViewData["info"] = hongbao.Rows[0]["Remark"].ToString();
                ViewData["zuiDiXiaoFei"] = hongbao.Rows[0]["amountlimit"].ToString();
            }

            ViewData["WeiXinID"] = HotelInfo.WeiXinID;
            return View();
        }

        public ActionResult CouponDeatil()
        {
            string tel = HCRequest.GetString("tel");
            int hid = HCRequest.getInt("hid");
            int id = HCRequest.getInt("id"); ;

            ViewData["hid"] = hid;
            ViewData["id"] = id;

            string weixinid = HCRequest.GetString("weixinid");
            ViewData["weixinid"] = weixinid;
            string sql = @"SELECT id,hid,tel,addtime,[money],promoterid,jifen FROM ShareCouponContent WITH(NOLOCK) WHERE hid=@hid AND tel=@tel";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("hid", new DBParam { ParamValue = hid.ToString() });
            Dic.Add("tel", new DBParam { ParamValue = tel });
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);
            ViewData["CouponDeatil"] = dt;

            //获取酒店信息
            hotel3g.Repository.HotelInfoItem HotelInfo = hotel3g.Repository.MemberHelper.GetHotelInfo(weixinid, hid.ToString());
            ViewData["HotelInfo"] = HotelInfo;



            //获取公众号信息
            sql = "SELECT TOP 1 WeiXin2Img,appid,weixintype,WeiXinImg FROM dbo.WeiXinNO WITH(NOLOCK) WHERE WeiXinID=@WeiXinID";
            dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                {"WeiXinID",new DBParam{ParamValue=weixinid}}
                });


            if (dt != null && dt.Rows.Count > 0)
            {
                string weixintype = dt.Rows[0]["weixintype"].ToString();
                if (id > 0)
                {
                    if (weixintype.Equals("4"))
                    {

                        ViewData["Logo"] = QR_Code_Url(id, weixinid);

                    }
                    else
                    {
                        //生成跳转链接
                        ViewData["Logo"] = dt.Rows[0]["WeiXin2Img"].ToString();
                    }

                }
            }


            //红包金额
            sql = "SELECT moneys,amountlimit,Remark,scopelimit FROM dbo.CouPon WITH(NOLOCK) WHERE weixinID=@WeiXinID AND s_huodongid>0";

            System.Data.DataTable hongbao = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                {"WeiXinID",new DBParam{ParamValue=weixinid}}
                });
            if (hongbao != null && hongbao.Rows.Count > 0)
            {
                ViewData["money"] = hongbao.Rows[0]["moneys"].ToString();
                ViewData["info"] = hongbao.Rows[0]["Remark"].ToString();
                ViewData["zuiDiXiaoFei"] = hongbao.Rows[0]["amountlimit"].ToString();

                ViewData["scopelimit"] = hongbao.Rows[0]["scopelimit"].ToString();
            }

            return View();
        }

        public JsonResult ShareCoupon()
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string[] keys = key.Split('@');
            if (keys.Length == 2)
            {
                string weixinID = keys[0];
                string userWeiXinID = keys[1];

                if (string.IsNullOrEmpty(weixinID) || string.IsNullOrEmpty(userWeiXinID))
                {
                    return Json(new { status = 0, msg = "信息不全" });
                }

                Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
                Dic.Add("weixinID", new DBParam { ParamValue = weixinID });
                Dic.Add("userweixinNo", new DBParam { ParamValue = userWeiXinID });
                //判断是否首次分享
                string sql = "SELECT COUNT(0) FROM dbo.CouPonContent WHERE weixinID=@weixinID AND userweixinNo=@userweixinNo AND giftname='推广员分享红包'";

                string Value = SQLHelper.Get_Value(sql, SQLHelper.GetCon(), Dic);

                if (int.Parse(Value) <= 0)
                {

                    sql = "SELECT id,moneys,amountlimit FROM dbo.CouPon WITH(NOLOCK) WHERE weixinID=@weixinid AND s_huodongid>0";

                    DataTable hongbao = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                {"WeiXinID",new DBParam{ParamValue=weixinID}}
                });

                    string money = "0";
                    string amountlimit = "0";
                    string typeID = "";
                    if (hongbao != null && hongbao.Rows.Count > 0)
                    {
                        money = hongbao.Rows[0]["moneys"].ToString();
                        amountlimit = hongbao.Rows[0]["amountlimit"].ToString();
                        money = string.IsNullOrEmpty(money) ? "0" : money;
                        amountlimit = string.IsNullOrEmpty(amountlimit) ? "0" : amountlimit;
                        typeID = hongbao.Rows[0]["id"].ToString();
                    }

                    string sdate = DateTime.Now.ToString("yyyy-MM-dd");
                    string edate = DateTime.Now.AddYears(1).ToString("yyyy-MM-dd");

                    string conpon = DateTime.Now.AddMilliseconds(10).ToString("yyMMddHHmmssfff");

                    if (string.IsNullOrEmpty(typeID))
                    {
                        //酒店未设置红包 不发放
                        return Json(new { status = 1, msg = "已分享" });
                    }

                    //赠送红包
                    sql = string.Format(@"insert into CouPonContent(weixinID,moneys,sTime,ExtTime,addTime,IsEmploy,CouPonNO,userweixinNo,giftname,typeID) values('{0}','{1}','{2}','{3}',getdate(),0,'{4}','{5}','推广员分享红包',{6});", weixinID, money, sdate, edate, conpon, userWeiXinID, typeID);
                    int Count = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), null);
                    return Json(new { status = Count, msg = Count > 0 ? "分享成功!" : "失败" });
                }
                else
                {
                    return Json(new { status = 0, msg = "已分享!" });
                }
            }
            return Json(new { status = 0, msg = "信息不全" });
        }

        /// <summary>
        /// 领取红包
        /// </summary>
        /// <returns></returns>
        public JsonResult GetCoupon()
        {
            string tel = HCRequest.GetString("tel");
            int hid = HCRequest.getInt("hid");
            int memberid = HCRequest.getInt("memberid");
            string weixinid = HCRequest.GetString("weixinid");
            bool status = false;
            string msg = PromoterDAL.SendCustomCoupon(weixinid, tel, memberid, hid, out status);
            return Json(new { status = status ? 1 : 0, msg = msg });
        }
        /// <summary>
        /// 跨域图图片代理
        /// </summary>
        public void CoverImage()
        {
            string src = HotelCloud.Common.HCRequest.GetString("src");
            if (!string.IsNullOrEmpty(src))
            {
                WebRequest myrequest = WebRequest.Create(src);
                WebResponse myresponse = myrequest.GetResponse();
                Stream imgstream = myresponse.GetResponseStream();
                System.Drawing.Image img = System.Drawing.Image.FromStream(imgstream);

                MemoryStream ms = new MemoryStream();
                img.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);
                Response.ClearContent(); //需要输出图象信息 要修改HTTP头 
                Response.ContentType = "image/gif";

                Response.BinaryWrite(ms.ToArray());
            }
        }



    }


}
