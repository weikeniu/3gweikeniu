using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using hotel3g.Models;

namespace hotel3g.Controllers
{
    /// <summary>
    /// 会员中心-分销 
    /// </summary>
    public class MemberFxController : Controller
    {
        /// <summary>
        /// 提现列表
        /// </summary>
        /// <returns></returns>
        public ActionResult FxApplyList(int id)
        {
            int page = HotelCloud.Common.HCRequest.getInt("page");
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string userweixinid = "";
            if (key.Contains("@"))
            {
                userweixinid = key.Split('@')[1];
            }
            //DataTable dt = MemberFxLogic.GetApplyCashList(userweixinid);
            //List<MemberFxCashItem> list = dt.ToList<MemberFxCashItem>();
            //ViewData["list"] = list;
            ViewData["userweixinid"] = userweixinid;
            ViewData["hId"] = id;
            ViewData["key"] = key;

            return View();
        }
        //获取提现列表
        public ActionResult GetApplyList()
        {
            int page = HotelCloud.Common.HCRequest.getInt("page");
            string userweixinid = HotelCloud.Common.HCRequest.GetString("userweixinid");//"用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinid");//"用户微信id"
            DataTable dt = MemberFxLogic.GetApplyCashList(weixinid,userweixinid, page, 10);
            if (dt.Rows.Count > 0)
            {
                List<MemberFxCashItem> list = dt.ToList<MemberFxCashItem>();
                Newtonsoft.Json.Converters.IsoDateTimeConverter timeFormat = new Newtonsoft.Json.Converters.IsoDateTimeConverter();
                timeFormat.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";
                string json = Newtonsoft.Json.JsonConvert.SerializeObject(list, timeFormat);
                return Json(new { success = true, nextpage = page + 1, strjson = json });
            }
            else 
            {
                return Json(new { success = false, nextpage = page + 1, strjson = "" });
            }
        }

        /// <summary>
        /// 分销客户列表
        /// </summary>
        /// <returns></returns>
        public ActionResult FxCustomer(int id)
        {
            int page = HotelCloud.Common.HCRequest.getInt("page");
            string memberId = HotelCloud.Common.HCRequest.GetString("mid");
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string userweixinid = "";
            string weixinid = "";
            if (key.Contains("@"))
            {
                weixinid = key.Split('@')[0];
                userweixinid = key.Split('@')[1];
            }

            DataTable dt = MemberFxLogic.GetShareCustomerList(memberId,weixinid);

            ViewData["dt"] = dt;
            
            ViewData["hId"] = id;
            ViewData["key"] = key;
            return View();
        }

        /// <summary>
        /// 分销订单列表
        /// </summary>
        /// <returns></returns>
        public ActionResult FxOrders(int id)
        {
            int type = HotelCloud.Common.HCRequest.getInt("v");
            int page = HotelCloud.Common.HCRequest.getInt("page");
            string memberId = HotelCloud.Common.HCRequest.GetString("mid");
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = "";
            string userweixinid = "";
            if (key.Contains("@"))
            {
                weixinid = key.Split('@')[0];
                userweixinid = key.Split('@')[1];
            }
            
            int pagesize = 10;
            List<FxOrderCommission> list = new List<FxOrderCommission>();// MemberFxLogic.GetShareOrderList(memberId, weixinid, page, pagesize);
            ViewData["list"] = list;
            ViewData["hId"] = id;
            ViewData["key"] = key;
            return View();
        }

        public ActionResult GetFxOrders()
        {
            int type = HotelCloud.Common.HCRequest.getInt("v");
            int page = HotelCloud.Common.HCRequest.getInt("page");
            string memberId = HotelCloud.Common.HCRequest.GetString("mid");
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = "";
            string userweixinid = "";
            if (key.Contains("@"))
            {
                weixinid = key.Split('@')[0];
                userweixinid = key.Split('@')[1];
            }

            int pagesize = 10;
            List<FxOrderCommission> list = MemberFxLogic.GetShareOrderList(memberId, weixinid, page, pagesize, type);

            if (list.Count > 0)
            { 
                List<FxOrderCommissionV> listV=new List<FxOrderCommissionV> ();
                FxOrderCommissionV m=null;
                foreach (var item in list) 
                {
                    m=new FxOrderCommissionV ();
                    m.row = item.row;
                    m.amount = item.amount;
                    m.createtime = item.createtime;
                    m.fxmoney = item.fxmoney;
                    m.hotelLog = item.hotelLog;
                    m.isjiesuan = item.isjiesuan;
                    m.name = item.name;
                    m.orderCode = item.orderCode;
                    m.payamount = item.payamount;
                    m.Status = item.Status;
                    m.statusname = MemberFxLogic.GetShareOrderStatusName(item);
                    listV.Add(m);
                }
                Newtonsoft.Json.Converters.IsoDateTimeConverter timeFormat = new Newtonsoft.Json.Converters.IsoDateTimeConverter();
                timeFormat.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";
                string json = Newtonsoft.Json.JsonConvert.SerializeObject(listV, timeFormat);
                return Json(new { success = true, nextpage = page + 1, strjson = json });
            }
            else
            {
                return Json(new { success = false, nextpage = page + 1, strjson = "" });
            }
        }

        /// <summary>
        /// 分销中心
        /// </summary>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult FxIndex(int id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string userweixinid = "";
            string weixinid = "";
            if (key.Contains("@"))
            {
                weixinid = key.Split('@')[0];
                userweixinid = key.Split('@')[1];
            }

            //int result = MemberFxLogic.SetMemberFxMoney(MemberID, userweixinid, weixinid);
            //DataTable dt = MemberFxLogic.GetMemberInfo(MemberID);
            DataTable dt = MemberFxLogic.GetMemberInfo(userweixinid, weixinid);
            FxMemberInfo model = new FxMemberInfo();
            if (dt.Rows.Count > 0)
            {
                model=dt.Rows[0].ToModel<FxMemberInfo>();
            }
            string MemberID = model.Id + "";
            ViewData["model"] = model;
            ViewData["cusNum"] = model == null ? "0" : MemberFxLogic.GetShareCustomerNum(MemberID, weixinid);
            ViewData["ordNum"] = model == null ? "0" : MemberFxLogic.GetShareOrderNum(MemberID, weixinid);

            ViewData["hId"] = id;
            ViewData["key"] = key;
            return View(); 
        }

        /// <summary>
        /// 申请提现
        /// </summary>
        /// <returns></returns>
        public ActionResult FxApply(int id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string userweixinid = "";
            string weixinid = "";
            if (key.Contains("@"))
            {
                weixinid = key.Split('@')[0];
                userweixinid = key.Split('@')[1];
            }
            string MemberId = HotelCloud.Common.HCRequest.GetString("mid");

            
            DataTable dt = MemberFxLogic.GetMemberInfo(MemberId);
            FxMemberInfo model = new FxMemberInfo();
            if (dt.Rows.Count > 0)
            {
                model = dt.Rows[0].ToModel<FxMemberInfo>();
            }
            ViewData["model"] = model;
            
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            ViewData["hId"] = id;
            ViewData["key"] = key;

            return View();
        }
        /// <summary>
        /// 提交申请
        /// </summary>
        /// <returns></returns>
        public ActionResult SaveApply()
        {
            string money = HotelCloud.Common.HCRequest.GetString("m");
            string userweixinid = HotelCloud.Common.HCRequest.GetString("uwx");
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinid");
            string memberId = HotelCloud.Common.HCRequest.GetString("memberId");
            int rows = MemberFxLogic.SaveApply(memberId, weixinid, userweixinid, money);
            return Json(
                new
                {
                    success = rows > 0,
                    message = rows > 0 ? "提现申请提交成功！" : "提现申请提交失败！"
                });
        }

        /// <summary>
        /// 酒店推广中心
        /// </summary>
        /// <returns></returns>
        public ActionResult FxExtensCenter(int id) 
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string hotelWeixinid = key.Split('@')[0];
            double graderate = 0, reduce = 0;
            int couponType = 0;
            string firstimgurl = null;
            string ratejson = ActionController.getratejson(id, DateTime.Now.Date, DateTime.Now.AddDays(1).Date, hotelWeixinid, graderate, out firstimgurl, reduce, couponType);
            

            int count=0,page=1,pagesize=100;
            //List<WeiXin.Models.Home.SaleProduct> list = WeiXin.Models.Home.SaleProduct.GetSaleProducts(hotelWeixinid, out count, page, pagesize, "", "");
            var dtSaleProduct = WeiXin.Models.DAL.SaleProduct.GetSaleProducts(hotelWeixinid, out count, page, pagesize, "", "");
            ViewData["dtSaleProduct"] = dtSaleProduct;

            DataTable dt = MemberFxLogic.GetHotelYongJinLv(hotelWeixinid);
            if (dt.Rows.Count > 0)
            {
                ViewData["kefang"] = dt.Rows[0]["kefang"];
                ViewData["canyin"] = dt.Rows[0]["canyin"];
                ViewData["tuangou"] = dt.Rows[0]["tuangou"];
                ViewData["chaoshi"] = dt.Rows[0]["chaoshi"];
            }
            else
            {
                ViewData["kefang"] = 0;
                ViewData["canyin"] = 0;
                ViewData["tuangou"] = 0;
                ViewData["chaoshi"] = 0;
            }
            
            ViewData["ratejson"] = ratejson;
            ViewData["hId"] = id;
            ViewData["key"] = key;
            return View();
        }
    }
}
