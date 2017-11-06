using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using HotelCloud.Common;
using hotel3g.Common.Branch;
namespace hotel3g.Controllers
{
    public class BranchController : Controller
    {
        //
        // GET: /Branch/
     
        public ActionResult Index(string id)
        {
            //获取信息
            string key = HCRequest.GetString("key");

            if (!string.IsNullOrEmpty(key) && key.Split('@').Length == 2)
            {
                string weixinid = key.Split('@')[0];
                string userweixinid = key.Split('@')[1];
                ViewData["weixinid"] = weixinid;
                ViewData["userweixinid"] = userweixinid;

                if (string.IsNullOrEmpty(weixinid) || string.IsNullOrEmpty(userweixinid))
                {
                    return RedirectToAction("Home", "Default");
                }
                string fromurl=HCRequest.GetString("fromurl");

                if (fromurl.ToLower().IndexOf("newsinfo")>-1)
                {
                    fromurl = "/Hotel/NewsinfoList";
                }

                if (!string.IsNullOrEmpty(fromurl))
                {
                    ViewData["fromurl"] = fromurl;

                    string CookieName = "CurBranchHotel";
                    string hid = hotel3g.Models.DAL.BranchHelper.GetCookie(CookieName, weixinid);
                    int CurHotel = string.IsNullOrEmpty(hid) ? 0 : int.Parse(hid);
                    bool isBranch = hotel3g.Models.DAL.BranchHelper.IsBranch(weixinid);

                    if (CurHotel > 0)
                    {
                        //fromurl = string.Format("http://www.weikeniu.com{0}/{1}?{2}", fromurl, CurHotel, key,Server.MapPath("~"));
                       
                        //Uri Url=new Uri(HttpUtility.HtmlDecode(fromurl));

                        //return RedirectToAction(Url.Segments[2], Url.Segments[1], new { id = CurHotel, key = key });
                    }

                }
                else {
                    ViewData["fromurl"] = "/Home/Main";
                }
                List<hotel3g.Common.Branch.HotelResponse> BranchHotel = hotel3g.Models.DAL.BranchHelper.HotelList(weixinid);
                ViewData["BranchHotel"] = BranchHotel;
            }
            return View();
        }
        [HttpPost]
        public JsonResult CurHotel() {
            int hid = HCRequest.getInt("hid");
            string weixinid=HCRequest.GetString("weixinid");
            if (hid > 0 && !string.IsNullOrEmpty(weixinid))
            {
                string CookieName = "CurBranchHotel";
                hotel3g.Models.DAL.BranchHelper.BuildCookie(CookieName, hid.ToString(), weixinid);
            }
            return null;
        }

    }
}
