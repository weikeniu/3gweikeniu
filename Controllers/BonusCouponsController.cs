using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using hotel3g.Models;
namespace hotel3g.Controllers
{
    public class BonusCouponsController : Controller
    {
        //
        // GET: /BonusCoupons/

        public ActionResult grapCouponWeixinInit(string key, string code, string state)
        {
            BonusCouponsService BonusCoupons = new BonusCouponsService();
            //诱导用户前往授权网址
            if (state == null || code == null) {
               Response.Redirect(BonusCoupons.BackUrl(key));
            }
           // state = key;
            //参数数组
            //string[] IDS = state.Split('@');
             string[] IDS = key.Split('@');
            //获取用户信息
            UserWeiXin Info=BonusCoupons.UserInfo(code);
            
            /*
            UserWeiXin Info = new UserWeiXin();
            Info.OpenId = "13579246810123";
            Info.HeadImgUrl = "http://wx.qlogo.cn/mmopen/K6CEv0Hv9DeeVP82dN2I7IAKyHpS9wgD0S1blx88EdhOwAF69PzgkLic4jaQhoRNicaquCwkO2Ku8TqIDFhldwteEVzTvXp1Q3/0";
            Info.Province = "安徽省";
            Info.City = "宣城市";
            Info.Country = "广德县";
            Info.NickName = "haven1";
            Info.Sex = "1";
           */
            Session["UserInfo"]= Info;

            ViewData["ReceiveUsers"] = BonusCoupons.ReceiveUsers(IDS);
            //判断您当前奖券是否存在
            ViewData["CouPonIsExists"] = BonusCoupons.CouPonIsExists(IDS);
            //判断用户当前奖券领取情况
            ViewData["NotReceive"] = BonusCoupons.NotReceive(IDS, Info.OpenId);
            return View();
        }

        [HttpPost]
        public ActionResult Verification(FormCollection Form)
        {
            BonusCouponsService BonusCoupons = new BonusCouponsService();
            string[] IDS = Form["key"].Split('@');
            string Phone = Form["phone"].Trim();
            //获取开奖券
            Coupon_Random Coupon = BonusCoupons.RandomAmount(IDS);

            if (Coupon != null&&Session["UserInfo"]!=null)
            {
                UserWeiXin UserInfo = (UserWeiXin)Session["UserInfo"];
                Coupon_Random info=BonusCoupons.GetBonus(Coupon, UserInfo);
                info.TelPhone = Phone;
             if (info!=null)
             {
                 if (BonusCoupons.SaveInfo(info))
                 {
                     //领取成功
                     Session["GetBonusStatus"] = "<font color=#ddd>恭喜您获得"+info.Price+"元奖金红包!</font>";
           
                     //Response.Redirect("grapCouponWeixinInit?key=" + Form["key"]);
                 }
                 else {
                     //保存出现错误
                     Session["GetBonusStatus"] = "2";
                 }
             }
             else {
                 //奖券过期
                 Session["GetBonusStatus"] = "3";
             }
            }
            else 
            {
                //不存在奖券
                 Session["GetBonusStatus"] = "0";
            }
            Response.Redirect("grapCouponWeixinInit?key=" + Form["key"]);
            return View();
        }

    }
}
