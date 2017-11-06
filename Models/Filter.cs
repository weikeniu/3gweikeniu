using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace hotel3g.Models
{
    public class Filter : ActionFilterAttribute
    {
        public string LoginUrl { get; set; }
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {

            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("key");
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            if (!userWeiXinID.Equals(""))
            {
                weixinid = userWeiXinID.Split('@')[0];
                hotel3g.Models.Cookies.SetCookies("userWeixinNO", userWeiXinID.Split('@')[1], 30, weixinid);
            }
            else
            {
                /*重定向 规避微信 字符串屏蔽 */
                string pickurl = filterContext.HttpContext.Request.RawUrl.ToLower();
                if (string.IsNullOrEmpty(userWeiXinID) && (pickurl.IndexOf("nid") > -1 || pickurl.IndexOf("sid") > -1) && pickurl.IndexOf("key") > -1 && !(pickurl.IndexOf("&") > -1))
                {
                    string url = pickurl.Replace("key", "&key");
                    filterContext.Result = new RedirectResult(url);
                    return;
                }
            }
            ////校验公众账号 审核状态
            var ModuleAuthority = hotel3g.Models.DAL.AuthorityHelper.ModuleAuthority(weixinid);
            if (ModuleAuthority.examine == 0)
            {
                //账户未审核或取消审核
                try
                {
                    string sourceUrl = filterContext.HttpContext.Request.RawUrl;
                    filterContext.Result = new RedirectResult(("/Home/Default") + "?r=" + (new Random()).Next(0, 1000).ToString() + "&msg=暂时不可用!请联系微可牛相关人员&url=" + HttpUtility.UrlEncode(sourceUrl));
                }
                catch (Exception ex)
                {
                    filterContext.Result = new RedirectResult(("/Home/Default") + "?r=" + (new Random()).Next(0, 1000).ToString() + "&msg=暂时不可用!请联系微可牛相关人员");
                }
            }

            try
            {

                var RouteValues = filterContext.HttpContext.Request.RequestContext.RouteData.Values;
                //部分页面直接放行
                List<string> actions = new List<string>() { "newsinfo", "sports", "maintravel" };
                string CurAction = RouteValues["action"].ToString().ToLower();
                //判断部分放行页面 及没有携带酒店id的异步提交操作
                if (!actions.Contains(CurAction))
                {
                    if (ModuleAuthority.examine == 1)
                    {
                        //判断是否带有酒店id 没有直接放行
                        if (RouteValues.ContainsKey("id"))
                        {
                            string id = RouteValues["id"].ToString();
                            int hid = string.IsNullOrEmpty(id) ? 0 : int.Parse(id);

                            if (hid == 0)
                            {
                                //[controller, hotel]|[action, index]|[id, 28291]
                                string controller = RouteValues.ContainsKey("controller") ? RouteValues["controller"].ToString() : "";
                                string action = RouteValues.ContainsKey("action") ? RouteValues["action"].ToString() : "";
                                string fromurl = string.Format("/{0}/{1}", controller, action);

                                string url = string.Format("/Branch/index/0?key={0}@{1}&fromurl={2}", weixinid, userWeiXinID.Split('@')[1], fromurl);
                                filterContext.Result = new RedirectResult(url);
                            }

                        }
                    }
                }
            }
            catch
            {
                filterContext.Result = new RedirectResult(("/Home/Default") + "?r=" + (new Random()).Next(0, 1000).ToString() + "&msg=参数异常");
            }
            //校验酒店启用状态

            //iphone|ios|android|mini|mobile|mobi|Nokia|Symbian|iPod|iPad|Windows\s+Phone|MQQBrowser|wp7|wp8|UCBrowser7|UCWEB|360\s+Aphone\s+Browser|AppleWebKit
            //HotelCloud.SqlServer.SQLHelper.Run_SQL("insert into ceweixin(value) values('" + (HttpContext.Current.Request.UserAgent ?? "").ToString() + "')", HotelCloud.SqlServer.SQLHelper.GetCon(), null);
            //if (HttpContext.Current.Request.UserAgent.IndexOf("Mobile") < 0 || (HttpContext.Current.Request.UserAgent.IndexOf("MicroMessenger") < 0 && (HttpContext.Current.Request.UserAgent.IndexOf("iPhone") >= 0 || HttpContext.Current.Request.UserAgent.IndexOf("Android") >= 0)))
            //{

            //    filterContext.Result = new RedirectResult(("/Home/Default") + "?r=" + (new Random()).Next(0, 1000).ToString());

            //}
        }
    }
}