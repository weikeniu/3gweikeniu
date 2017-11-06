using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using HotelCloud.Common;
using hotel3g.Models;
using System.Data;
using System.IO;

namespace hotel3g.Controllers
{
    /// <summary>
    /// 旅行社拼团
    /// </summary>
    public class TravelThemeController : Controller
    {
        
        #region 旅行社主题拼团首页  主题状态：0召集中 1进行中 2 已结束
        public ActionResult ThemeIndex(int id)
        {
            string key = HCRequest.GetString("key");

            ViewData["key"] = key;
            ViewData["hId"] = id;
            return View();
        }

        public ActionResult GetThemeList(int id) 
        {
            string key = HCRequest.GetString("key");
            string weixinid = "";//酒店微信id
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
            }

            int curpage = HCRequest.getInt("page");//
            int pagesize = HCRequest.getInt("pagesize");
            int sort = HCRequest.getInt("sort");//距离，价格高低 排序
            string themetype = HCRequest.GetString("type");//多个类型逗号隔开
            string endcity = HCRequest.GetString("cityname");
            string keyworks = HCRequest.GetString("keyworks");



            List<LXS_ThemeView> listTheme = TravelThemeLogic.GetThemeList(weixinid, curpage, pagesize, sort, themetype, endcity, keyworks);
            Newtonsoft.Json.Converters.IsoDateTimeConverter timeFormat = new Newtonsoft.Json.Converters.IsoDateTimeConverter();
            timeFormat.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";
            string strJson = Newtonsoft.Json.JsonConvert.SerializeObject(listTheme, timeFormat);
            return Json(
                new
                {
                    success = true,
                    msg = strJson,
                    nextpage = listTheme.Count == pagesize ? curpage + 1 : curpage
                }
            );
        }

        public ActionResult GetThemeLocat(string id)
        {
            string key = HCRequest.GetString("key");
            string weixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
            }

            DataTable dt = TravelThemeLogic.GetThemeLocat(weixinid);

            return Json(new
            {
                data = DishOrderController.SerializeDataTable(dt)
            }, JsonRequestBehavior.AllowGet);
        }

        #endregion

        #region 我的
        public ActionResult MyTheme(int id) 
        {
            string key=HCRequest.GetString("key");
            string weixinid = "";//酒店微信id
            string uwx = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                uwx= key.Split('@')[1];
            }

            DataTable myinfo = TravelThemeLogic.GetMyMemberInfo(weixinid, uwx);
            ViewData["myinfo"] = myinfo;

            ViewData["hId"] = id;
            ViewData["key"] = key;
            ViewData["uwx"] = uwx;
            return View();
        }
        public ActionResult GetMyThemeList(int id) 
        {
            string key = HCRequest.GetString("key");
            string weixinid = "";//酒店微信id
            string uwx = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                uwx = key.Split('@')[1];
            }

            int curpage = HCRequest.getInt("page");//
            int pagesize = HCRequest.getInt("pagesize");

            List<LXS_ThemeView> listTheme = TravelThemeLogic.GetMyThemeList(uwx, curpage, pagesize);
            Newtonsoft.Json.Converters.IsoDateTimeConverter timeFormat = new Newtonsoft.Json.Converters.IsoDateTimeConverter();
            timeFormat.DateTimeFormat = "yyyy-MM-dd";//"yyyy-MM-dd HH:mm:ss";
            string strJson = Newtonsoft.Json.JsonConvert.SerializeObject(listTheme, timeFormat);
            return Json(
                new
                {
                    success = true,
                    msg = strJson,
                    nextpage = listTheme.Count == pagesize ? curpage + 1 : curpage
                }
            );
        }
        #endregion

        #region 创建主题拼团
        public ActionResult EditTheme(int id)
        {
            ViewData["hId"] = id;
            ViewData["key"] = HCRequest.GetString("key");
            return View();
        }

        public ActionResult SaveTheme() 
        {
            // var data = { theme: theme, startcity: startcity, endcity: endcity, xingchendate: xingchendate, jihetime: jihetime, themetype: themetype,
            //    costtype: costtype, costmoney: costmoney, peoplenumber: peoplenumber, content: content
            string themename = HCRequest.GetString("theme");
            string startcity = HCRequest.GetString("startcity");
            string endcity = HCRequest.GetString("endcity");
            
            string goingtime = HCRequest.GetString("jihetime");
            string themetype = HCRequest.GetString("themetype");
            int costtype = HCRequest.getInt("costtype");
            string costmoney = HCRequest.GetString("costmoney");
            int peoplenumber = HCRequest.getInt("peoplenumber");
            string content = HCRequest.GetString("content");
            int hotelid = HCRequest.getInt("hId");

            string key = HCRequest.GetString("key");
            string weixinid = key.Split('@')[0];
            string userweixinid = key.Split('@')[1]; ;
            string imgurls = HCRequest.GetString("imgurls");

            int days = 0;
            DateTime begintime = DateTime.Now;
            DateTime endtime = DateTime.Now;
            string xingchendate = HCRequest.GetString("xingchendate");
            string[] strs = xingchendate.Split('至');
            if (strs.Length > 1)
            {
                begintime = Convert.ToDateTime(strs[0]);
                endtime = Convert.ToDateTime(strs[1]);
                days = (endtime - begintime).Days;
            }
            else 
            {
                days = 1;
                begintime = Convert.ToDateTime(strs[0]);
                endtime = begintime;
            }
            //themename, startcity, endcity, begintime, endtime, days, goingtime, themetype, costtype, costmoney, peoplenumber, 
//content, status, hotelid, weixinid, userweixinid, createtime
            LXS_Theme model = new LXS_Theme();
            model.themename = themename;
            model.startcity = startcity;
            model.endcity = endcity;
            model.begintime = begintime;
            model.endtime = endtime;
            model.days = days;
            model.goingtime = goingtime.Trim();
            model.themetype = themetype;
            model.costtype = costtype;
            model.costmoney = decimal.Parse(costmoney);
            model.peoplenumber = peoplenumber;
            model.content = content;
            model.status = 0;
            model.hotelid = hotelid;
            model.weixinid = weixinid;
            model.userweixinid = userweixinid;
            model.imgurls = imgurls;
            model.createtime = DateTime.Now;

            string themeid = model.Save(model);
            TravelThemeLogic.SaveJoin("发起人", "", "", userweixinid, themeid);
            return Json(new 
            {
                success = Convert.ToInt32(themeid) > 0,
                msg = Convert.ToInt32(themeid) > 0 ? "发布成功！" : "发布失败！"
            });
        }


        #endregion

        #region 拼团主题详情
        
        //主题内容
        public ActionResult ThemeDetail(int id)
        {
            string themeid = HCRequest.GetString("themeid");
            string key = HCRequest.GetString("key");
            string uwx = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                uwx = key.Split('@')[1];
            }

            LXS_ThemeView model = TravelThemeLogic.GetThemeModel(themeid);
            ViewData["model"] = model;
            ViewData["uwx"] = uwx;

            List<LXS_JoinTheme> listJoin = TravelThemeLogic.GetJoinList(themeid);
            ViewData["listJoin"] = listJoin;

            bool hasSignIn = TravelThemeLogic.HasSignIn(uwx, themeid);
            ViewData["hasSignIn"] = hasSignIn;

            ViewData["hId"] = id;
            ViewData["key"] = key;
            return View();
        }

        //报名参加
        public ActionResult SaveJoin() 
        {
            string key = HCRequest.GetString("key");
            string username = HCRequest.GetString("username");
            string telphone = HCRequest.GetString("telphone");
            string message = HCRequest.GetString("message");
            string themeid = HCRequest.GetString("themeid");
            string uwx = "";
            if (key.Contains('@')) { uwx = key.Split('@')[1]; }
            bool hasSignIn = TravelThemeLogic.HasSignIn(uwx, themeid);
            if (hasSignIn) 
            {
                return Json(new
                {
                    success = false,
                    msg="已经报名过"
                });
            }
            else
            {
                int rows = TravelThemeLogic.SaveJoin(username, telphone, message, uwx, themeid);
                return Json(new
                {
                    success = rows > 0,
                    msg=rows>0?"报名成功":"报名失败"
                });
            }
        }

        public ActionResult QuitOut() 
        {
            string themeid = HCRequest.GetString("themeid");
            string uwx = HCRequest.GetString("uwx");
            int rows = TravelThemeLogic.QuitOut(uwx, themeid);

            return Json(new
            {
                success = rows > 0
            });
        }

        //回复
        public ActionResult SaveReply()
        {
            string key = HCRequest.GetString("key");
            string replymsg = HCRequest.GetString("replymsg");
            string joinid = HCRequest.GetString("joinid");
            string joinname = HCRequest.GetString("joinname");
            string themeid = HCRequest.GetString("themeid");
            string uwx = "";
            if (key.Contains('@')) { uwx = key.Split('@')[1]; }

            LXS_JoinTheme joinmodel = TravelThemeLogic.GetJoinModel(joinid);
            if (joinmodel != null)
            {
                if (joinmodel.state == 0)
                {
                    int rows = TravelThemeLogic.SaveReply(replymsg, joinid, joinname, uwx, themeid);
                    return Json(new
                    {
                        success = rows > 0,
                        msg = rows > 0 ? "回复成功" : "回复失败"
                    });
                }
                else
                {
                    return Json(new
                    {
                        success = false,
                        msg = "该报名已经退出"
                    });
                }
            }
            else
            {
                return Json(new
                {
                    success = false,
                    msg = "不存在该报名人"
                });
            }
        }

        #endregion
    }
}
