using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WeiXin.Common;
using WeiXin.Models;
using WeiXin.Models.Home;
using System.Data;
using hotel3g.Repository;
using System.Collections;
using HotelCloud.Common;
using HotelCloud.SqlServer;
using hotel3g.Models.Home;
using hotel3g.Models;
using System.Text;

namespace hotel3g.Controllers
{
    public class ProductController : Controller
    {
        private static System.Web.Caching.Cache cache = HttpRuntime.Cache;

        [Models.Filter]
        public ActionResult ProductList()
        {


            string query = HotelCloud.Common.HCRequest.GetString("query").TrimEnd();
            string select = HotelCloud.Common.HCRequest.GetString("select").TrimEnd();
            int page = HotelCloud.Common.HCRequest.GetInt("page", 1);
            int pagesize = 50;
            if (page < 1)
            {
                page = 1;
            }
            int count = 0;

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            string cacheName = string.Format("{0}_{1}", hotelweixinId.ToLower(), "productlist");

            ProductEntityList list_products = new ProductEntityList();

            list_products.ProductEntity_List = SaleProduct.GetSaleProductsListIndexA(hotelweixinId, out count, page, pagesize, "", "");
            list_products.Count = count;


            List<ProductEntity> productEntity_List = new List<ProductEntity>();

            foreach (var item in list_products.ProductEntity_List)
            {
                item.List_SaleProducts_TC = SaleProducts_TC.GetSaleProducts_TC(Convert.ToInt32(item.Id));

                if (item.ProductType == "0")
                {
                    item.List_SaleProducts_TC = item.List_SaleProducts_TC.Where(c => c.ProductNum > 0 && c.ProductPrice > 0).ToList();

                }

                else if (item.ProductType == "1" && item.List_SaleProducts_TC.Count > 0)
                {
                    List<int> tc_requestIds = item.List_SaleProducts_TC.Select(c => c.Id).ToList<int>();
                    var list_tcPrice = SaleProducts_TC_Price.GetSaleProducts_TC_Price(tc_requestIds);

                    foreach (var item2 in item.List_SaleProducts_TC)
                    {
                        item2.List_SaleProducts_TC_Price = list_tcPrice.Where(c => c.RequestId == item2.Id).ToList();
                    }

                    item.List_SaleProducts_TC = item.List_SaleProducts_TC.Where(c => c.List_SaleProducts_TC_Price.Count > 0).ToList();
                }
            }


            list_products.ProductEntity_List = list_products.ProductEntity_List.Where(c => c.List_SaleProducts_TC.Count > 0).ToList();


            int pagesum = (count % pagesize == 0) ? count / pagesize : count / pagesize + 1;

            //ViewData["products"] = ProductEntity.ConvertProductEntityList(products);
            ViewData["products"] = list_products.ProductEntity_List;

            ViewData["count"] = count;
            ViewData["page"] = page;
            ViewData["pagesize"] = pagesize;
            ViewData["pagesum"] = pagesum;

            return View();
        }


        public ActionResult ProductErrMsg()
        {
            return View();
        }


        [Models.Filter]
        public ActionResult ProductDetail()
        {
            int Id = HotelCloud.Common.HCRequest.getInt("ProductId");
            WeiXin.Models.Home.SaleProduct products = new WeiXin.Models.Home.SaleProduct();


            Newtonsoft.Json.Converters.IsoDateTimeConverter timeFormat = new Newtonsoft.Json.Converters.IsoDateTimeConverter();
            timeFormat.DateTimeFormat = "yyyy-MM-dd";



            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];


            products = WeiXin.Models.Home.SaleProduct.GetSaleProduct(hotelweixinId, Id);

            if (products == null || products.Id == 0)
            {
                //return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "没找到对应的产品", key = HotelCloud.Common.HCRequest.GetString("key") });

                return RedirectToAction("productList", "Product", new { id = RouteData.Values["id"],  key = HotelCloud.Common.HCRequest.GetString("key") });
            }

            if (products.EndTime < DateTime.Now)
            {
                //return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "产品已过期", key = HotelCloud.Common.HCRequest.GetString("key") });
            }

            if (products.Status != 0)
            {
                //return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "产品已下架", key = HotelCloud.Common.HCRequest.GetString("key") });
                return RedirectToAction("productList", "Product", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key") });
            }

            double minPrice = 0;
            double maxPrice = 0;


            products.List_SaleProducts_TC = WeiXin.Models.Home.SaleProducts_TC.GetSaleProducts_TC(products.Id);

            DataTable db = WeiXin.Models.Home.SaleProduct.GetHotelInfo(products.WeiXinId);
            if (db.Rows.Count > 0)
            {
                ViewData["hotelname"] = db.Rows[0]["SubName"].ToString();
                ViewData["tel"] = db.Rows[0]["tel"].ToString();
                ViewData["address"] = db.Rows[0]["address"].ToString();
                ViewData["WeiXin2Img"] = db.Rows[0]["WeiXin2Img"].ToString();
            }

            //团购
            if (products.ProductType == 0)
            {
                products.List_SaleProducts_TC = products.List_SaleProducts_TC.Where(c => c.ProductPrice > 0 && c.ProductNum > 0).OrderBy(c => c.ProductPrice).ToList();         

                if (products.List_SaleProducts_TC != null && products.List_SaleProducts_TC.Count > 0)
                {

                    minPrice = Convert.ToDouble(products.List_SaleProducts_TC.Min(c => c.ProductPrice));
                    maxPrice = Convert.ToDouble(products.List_SaleProducts_TC.Max(c => c.ProductPrice));
                }

            }

            //预售
            else if (products.ProductType == 1)
            {
                foreach (var item in products.List_SaleProducts_TC)
                {
                    item.List_SaleProducts_TC_Price = WeiXin.Models.Home.SaleProducts_TC_Price.GetSaleProducts_TC_Price(item.Id);
                }


                products.List_SaleProducts_TC = products.List_SaleProducts_TC.Where(c => c.List_SaleProducts_TC_Price.Count > 0).ToList();


                if (products.List_SaleProducts_TC != null && products.List_SaleProducts_TC.Count > 0)
                {
                    var t_price = new List<WeiXin.Models.Home.SaleProducts_TC_Price>();
                    products.List_SaleProducts_TC.ForEach(r => { t_price.AddRange(r.List_SaleProducts_TC_Price); });
                    minPrice = Convert.ToDouble(t_price.Min(c => c.Price));
                    maxPrice = Convert.ToDouble(t_price.Max(c => c.Price));
                }

            }

             
            products.Json_SaleProducts_TC = Newtonsoft.Json.JsonConvert.SerializeObject(products.List_SaleProducts_TC, timeFormat);
            ViewData["products"] = products;

            if (minPrice == 0)
            {
                return RedirectToAction("productList", "Product", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key") });
                //return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "产品已售完", key = HotelCloud.Common.HCRequest.GetString("key") });

            }

            ViewData["minPrice"] = minPrice;
            ViewData["maxPrice"] = maxPrice;


            return View();

        }

        [Models.Filter]
        public ActionResult ProductConfirmOrder()
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            int productId = HotelCloud.Common.HCRequest.getInt("productId");
            int tcId = HotelCloud.Common.HCRequest.getInt("TcId");

            DateTime buyDate = DateTime.Now;
            if (!string.IsNullOrEmpty(HotelCloud.Common.HCRequest.GetString("date")))
            {
                buyDate = Convert.ToDateTime(HotelCloud.Common.HCRequest.GetString("date"));

            }
            int buyAmount = HotelCloud.Common.HCRequest.getInt("buyAmount");


            string token = string.Empty;


            var products = WeiXin.Models.Home.SaleProduct.GetSaleProduct(hotelweixinId, productId);


            if (products == null || products.Id == 0)
            {
                //return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "没有找到对应的产品。", key = HotelCloud.Common.HCRequest.GetString("key") });
                return RedirectToAction("productList", "Product", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key") });
            }


            products.List_SaleProducts_TC = WeiXin.Models.Home.SaleProducts_TC.GetSaleProducts_TC(productId);
            products.List_SaleProducts_TC = products.List_SaleProducts_TC.Where(c => c.Id == tcId).ToList();

            if (products.List_SaleProducts_TC == null || products.List_SaleProducts_TC.Count == 0)
            {
                //return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "没有找到对应的套餐。", key = HotelCloud.Common.HCRequest.GetString("key") });
                return RedirectToAction("productList", "Product", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key") });
            }

            //group buy
            if (products.ProductType == 0)
            {
                double totalMoney = Convert.ToDouble(products.List_SaleProducts_TC[0].ProductPrice * buyAmount);
                ViewData["totalMoney"] = totalMoney;

                ViewData["singleMoney"] = products.List_SaleProducts_TC[0].ProductPrice;

            }

            else
            {
                products.List_SaleProducts_TC[0].List_SaleProducts_TC_Price = WeiXin.Models.Home.SaleProducts_TC_Price.GetSaleProducts_TC_Price(products.List_SaleProducts_TC[0].Id);
                var saleProducts_TC_price = products.List_SaleProducts_TC[0].List_SaleProducts_TC_Price.Where(c => c.SaleTime == buyDate).FirstOrDefault();

                double totalMoney = Convert.ToDouble(saleProducts_TC_price.Price * buyAmount);

                ViewData["totalMoney"] = totalMoney;

                ViewData["singleMoney"] = saleProducts_TC_price.Price;
            }


            ViewData["products"] = products;


            DataTable db = WeiXin.Models.Home.SaleProduct.GetHotelInfo(products.WeiXinId);
            if (db.Rows.Count > 0)
            {
                ViewData["hotelname"] = db.Rows[0]["SubName"].ToString();
                ViewData["tel"] = db.Rows[0]["tel"].ToString();
                ViewData["address"] = db.Rows[0]["address"].ToString();
                ViewData["WeiXin2Img"] = db.Rows[0]["WeiXin2Img"].ToString();
            }


            string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;

            DataTable db_member = RechargeCard.GetRechargeMemberInfo(hotelweixinId, userweixinId);

            ViewData["balance"] = 0;
            if (db_member.Rows.Count > 0)
            {
                ViewData["balance"] = Convert.ToDouble(db_member.Rows[0]["balance"].ToString());
            }
            else
            {
                if (!userweixinId.Contains(wkn_shareopenid))
                {
                    MemberHelper.InsertUserAccount(hotelweixinId, userweixinId, "付款生成账号");
                }
            }



            string MemberCardRuleJson = ActionController.getMemberCardIntegralRule(userweixinId, hotelweixinId);

            ViewData["MemberCardRuleJson"] = MemberCardRuleJson;
            Hashtable MemberCardRuleJsonobj = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJson);
            Hashtable ruletable = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJsonobj["rule"].ToString());
            double graderate = WeiXinPublic.ConvertHelper.ToDouble(ruletable["GradeRate"]);
            ViewData["graderate"] = graderate;


            return View();



        }



        [Models.Filter]
        public ActionResult ProductUserOrderDetail(string orderNo)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            ViewData["key"] = key;
            DataTable db_order = SaleProducts_Orders.GetSaleProducts_OrdersA(orderNo, userweixinId);
            var order = DataTableToEntity.GetEntity<WeiXin.Models.Home.SaleProducts_Orders>(db_order);

            ViewData["order"] = order;


            List<SaleProducts_OrdersTuan> list_tuan = new List<SaleProducts_OrdersTuan>();

            if (order.Id > 0 && order.ProductType == 0)
            {
                DataTable db_tuan = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@" select *  from SaleProducts_OrdersTuan  with(nolock)  where OrderId=@OrderId ", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {                        
                     {"OrderId",new HotelCloud.SqlServer.DBParam{ParamValue=order.Id.ToString()}}      
  });

                list_tuan = DataTableToEntity.GetEntities<SaleProducts_OrdersTuan>(db_tuan).ToList();
            }

            ViewData["list_tuan"] = list_tuan;

            DataTable db = WeiXin.Models.Home.SaleProduct.GetHotelInfo(hotelweixinId);
            if (db.Rows.Count > 0)
            {
                ViewData["hotelname"] = db.Rows[0]["SubName"].ToString();
                ViewData["tel"] = db.Rows[0]["tel"].ToString();
                ViewData["address"] = db.Rows[0]["address"].ToString();

            }




            DataTable db_time = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@" select EffectiveBeginTime, EffectiveEndTime from SaleProducts  with(nolock)  where Id=@Id", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {                        
                     {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=order.ProductId.ToString()}}      
  });

            if (db_time.Rows.Count > 0)
            {
                ViewData["effectiveBeginTime"] = Convert.ToDateTime(db_time.Rows[0]["effectiveBeginTime"]).ToString("yyyy-MM-dd");

                if (DateTime.Now.Date > Convert.ToDateTime(ViewData["effectiveBeginTime"]))
                {
                    ViewData["effectiveBeginTime"] = DateTime.Now.ToString("yyyy-MM-dd");
                }


                ViewData["effectiveEndTime"] = Convert.ToDateTime(db_time.Rows[0]["effectiveEndTime"]).ToString("yyyy-MM-dd");

                if (DateTime.Now.Date.AddMonths(2) < Convert.ToDateTime(ViewData["effectiveEndTime"]))
                {
                    ViewData["effectiveEndTime"] = DateTime.Now.Date.AddMonths(2).ToString("yyyy-MM-dd");
                }
            }


            return View();

        }

        [Models.Filter]
        [HttpPost]
        public ActionResult ProductPay()
        {
            int status = -1;
            string errmsg = "";

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            string saveinfo = HCRequest.GetString("saveinfo");
            Hashtable saveinfotable = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(saveinfo);

            int couponid = Convert.ToInt32(saveinfotable["couponid"]);
            if (couponid > 0)
            {
                bool couPonEnable = WeiXin.Models.Home.CouPonContent.IsCouPonContentEnable(hotelweixinId, userweixinId, couponid);
                if (!couPonEnable)
                {
                    errmsg = "红包已被使用，不能再次使用";
                    return Json(new
                    {
                        Status = status,
                        Mess = errmsg

                    }, JsonRequestBehavior.AllowGet);
                }
            }

            SaleProducts_Orders order = new SaleProducts_Orders();

            if (saveinfotable["orderno"] != null && saveinfotable["orderno"].ToString() != string.Empty)
            {
                DataTable db_order = WeiXin.Models.Home.SaleProducts_Orders.GetSaleProducts_Orders(saveinfotable["orderno"].ToString(), userweixinId);
                order = DataTableToEntity.GetEntity<WeiXin.Models.Home.SaleProducts_Orders>(db_order);

                if (order.Ispay)
                {
                    errmsg = "订单已付款";
                    return Json(new
                    {
                        Status = status,
                        Mess = errmsg

                    }, JsonRequestBehavior.AllowGet);

                }

                if ((DateTime.Now - order.OrderAddTime).TotalMinutes > 30)
                {
                    errmsg = "支付超时，订单已关闭";
                    return Json(new
                    {
                        Status = status,
                        Mess = errmsg

                    }, JsonRequestBehavior.AllowGet);

                }
            }



            order.ProductId = Convert.ToInt32(saveinfotable["productid"]);
            order.TcId = Convert.ToInt32(saveinfotable["tcid"]);
            order.BookingCount = Convert.ToInt32(saveinfotable["bookingcount"]);
            order.CheckOutTime = order.CheckInTime = Convert.ToDateTime(saveinfotable["traveldate"]);

            string token = string.Empty;
            if (saveinfotable["t"] == null || saveinfotable["t"].ToString() == string.Empty)
            {
                TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
                token = string.Format("{0}", Convert.ToInt64(ts.TotalMilliseconds).ToString());
            }

            else
            {
                token = saveinfotable["t"].ToString();
            }



            var products = WeiXin.Models.Home.SaleProduct.GetSaleProduct(hotelweixinId, order.ProductId);

            token = string.Format("{0}_{1}", products.HotelId, token);
            string before_token = WeiXin.Models.Home.SaleProducts_Orders.GetSaleProducts_OrdersByToken(token);
            if (!string.IsNullOrEmpty(before_token))
            {
                errmsg = "请不要重复提交订单";

                return Json(new
                {
                    Status = status,
                    Mess = errmsg

                }, JsonRequestBehavior.AllowGet);
            }


            products.List_SaleProducts_TC = WeiXin.Models.Home.SaleProducts_TC.GetSaleProducts_TC(products.Id);

            order.OrderAddTime = DateTime.Now;
            order.ProductName = products.ProductName;
            order.LinkName = order.UserName = saveinfotable["lxr_name"].ToString();
            order.UserMobile = saveinfotable["lxr_mobile"].ToString();



            order.UserWeiXinId = userweixinId;

            order.HotelWeiXinId = products.WeiXinId;
            order.HotelId = products.HotelId;

            order.Token = token;

            order.OrderNo = "p" + DateTime.Now.ToString("yyMMddHHmmssfff") + new Random().Next(11, 99);


            var tc_product = products.List_SaleProducts_TC.Where(c => c.Id == order.TcId).FirstOrDefault();
            order.TcName = tc_product.TcName;
            order.ProductType = products.ProductType;


            // grooup buy
            if (products.ProductType == 0)
            {
                if (products.BeginTime > DateTime.Now)
                {

                    errmsg = "产品还未开始预售";

                    return Json(new
                    {
                        Status = status,
                        Mess = errmsg

                    }, JsonRequestBehavior.AllowGet);


                }

                if (products.EndTime < DateTime.Now)
                {
                    errmsg = "产品已过期";

                    return Json(new
                    {
                        Status = status,
                        Mess = errmsg

                    }, JsonRequestBehavior.AllowGet);

                }

                // int hexiaoMa = new Random().Next(100000000, 999990000);      


                //  order.OrderMoney = Convert.ToDecimal(tc_product.ProductPrice * order.BookingCount);

            }

            else
            {
                var tc_priceList = WeiXin.Models.Home.SaleProducts_TC_Price.GetSaleProducts_TC_Price(order.TcId);
                var tc_price = tc_priceList.Where(c => c.SaleTime == order.CheckInTime).FirstOrDefault();
                // order.OrderMoney = Convert.ToDecimal(order.BookingCount * tc_price.Price);

            }


            order.OrderMoney = Convert.ToDecimal(saveinfotable["ssumprice"]);
            order.OriginalSaleprice = Convert.ToDecimal(saveinfotable["originalsaleprice"]);

            order.Remark = "";
            order.TaoBaoStatus = "";
            order.OperatorLog = "";
            order.OrderStatus = 0;


            Dictionary<string, object> CouponInfoDic = new Dictionary<string, object>();
            if (couponid > 0)
            {
                CouponInfoDic.Add("CouponId", couponid);
                CouponInfoDic.Add("CouPon", Convert.ToInt32(saveinfotable["couponprice"]));
            }
            object gradename = saveinfotable["gradename"];
            CouponInfoDic.Add("GradeRate", WeiXinPublic.ConvertHelper.ToDouble(saveinfotable["graderate"]));
            CouponInfoDic.Add("GradeName", gradename == null ? string.Empty : gradename.ToString());
            CouponInfoDic.Add("IsVip", WeiXinPublic.ConvertHelper.ToInt(saveinfotable["isvip"]));
            order.CouponInfo = Newtonsoft.Json.JsonConvert.SerializeObject(CouponInfoDic);

            order.Jifen = Convert.ToInt32(saveinfotable["jifen"]);

            order.PayType = saveinfotable["zhifutype"].ToString() == "card" ? "储值卡支付" : "微信支付";

            var tgyModel = hotel3g.Models.MemberFxLogic.GetTuiGuangProfit(ProfitType.tuangou, products.WeiXinId, userweixinId, Convert.ToDouble(order.OrderMoney));

            order.Promoterid = tgyModel.promoterid;
            order.FxCommission = Convert.ToDecimal(tgyModel.hotelCommission);
            order.Fxmoneyprofit = Convert.ToDecimal(tgyModel.userCommission);

            int Id = WeiXin.Models.Home.SaleProducts_Orders.AddSaleProducts_Orders2(order);

            if (Id > 0)
            {
                status = 0;

                if (couponid > 0)
                {

                    string sql = "update couponcontent set isemploy=1,employtime=@time,orderid=@orderid where id=@couponid and weixinid=@weixinid and userweixinno=@userweixinid";
                    int row = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                            {
                                {"time",new DBParam(){ParamValue=DateTime.Now.ToString()}},
                                {"orderid",new DBParam(){ParamValue=Id.ToString()}},
                                {"couponid",new DBParam(){ParamValue=couponid.ToString()}},
                                {"weixinid",new DBParam(){ParamValue=hotelweixinId}},
                                {"userweixinid",new DBParam(){ParamValue=userweixinId}}
                            });

                }

                if (order.Jifen > 0)
                {

                    string cardno = saveinfotable["cardno"] == null ? string.Empty : saveinfotable["cardno"].ToString();
                    string memberid = saveinfotable["memberid"] == null ? string.Empty : saveinfotable["memberid"].ToString();
                    string sql = "insert into jifendetail (weixinid,userweixinid,jifen,addtime,orderid,night,cardno,userid) values (@weixinid,@userweixinid,@jifen,@addtime,@orderid,@night,@cardno,@userid)";
                    int rs = SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                        {
                            {"weixinid",new DBParam(){ParamValue=hotelweixinId}},
                            {"userweixinid",new DBParam(){ParamValue=userweixinId}},
                            {"jifen",new DBParam(){ParamValue=order.Jifen.ToString()}},
                            {"addtime",new DBParam(){ParamValue=DateTime.Now.ToString()}},
                            {"orderid",new DBParam(){ParamValue=Id.ToString()}},
                            {"night",new DBParam(){ParamValue="1"}},
                            {"cardno",new DBParam(){ParamValue=cardno}},
                            {"userid",new DBParam(){ParamValue=memberid}},
                        });
                }


                return Json(new
                {
                    Status = status,
                    Mess = order.OrderNo

                }, JsonRequestBehavior.AllowGet);

            }



            errmsg = "抱歉，下单失败";
            return Json(new
            {
                Status = status,
                Mess = errmsg

            }, JsonRequestBehavior.AllowGet);


        }

        [Models.Filter]
        [HttpPost]
        public ActionResult CancelOrder()
        {

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            string orderNo = HotelCloud.Common.HCRequest.GetString("orderNo");
            int orderId = HCRequest.getInt("orderId");

            string sql = @"update    SaleProducts_Orders  set orderStatus=2     where  orderNo=@orderNo  and userWeixinId=@userWeixinId ";
            int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"orderNo",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo.ToString()}},
             {"userWeixinId",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}},
            });


            int status = -1;
            string errmsg = "";


            if (row > 0)
            {
                sql = "update couponcontent set isemploy=0 where orderid=@orderid and weixinid=@weixinid and userweixinno=@userweixinid";
                SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                {
                    {"orderid",new DBParam(){ParamValue=orderId.ToString()}},
                    {"weixinid",new DBParam(){ParamValue=hotelweixinId}},
                    {"userweixinid",new DBParam(){ParamValue=userweixinId}}
                });

                status = 0;
                errmsg = "取消成功";

                return Json(new
                {
                    Status = status,
                    Mess = errmsg

                }, JsonRequestBehavior.AllowGet);
            }


            errmsg = "取消失败";

            return Json(new
            {
                Status = status,
                Mess = errmsg

            }, JsonRequestBehavior.AllowGet);
        }




        [Models.Filter]
        [HttpPost]
        public ActionResult UseTuanCode()
        {
            int status = -1;
            string errmsg = "操作失败";

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            string tuancode = HotelCloud.Common.HCRequest.GetString("tuancode").Trim();
            int orderId = HCRequest.getInt("orderId");

            string sql = @"update  SaleProducts_OrdersTuan  set Status=@Status     where  OrderId=@OrderId  and TuanCode=@TuanCode ";
            int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"OrderId",new HotelCloud.SqlServer.DBParam{ParamValue=orderId.ToString()}},
             {"TuanCode",new HotelCloud.SqlServer.DBParam{ParamValue=tuancode}},
             {"Status",new HotelCloud.SqlServer.DBParam{ParamValue=((int)ProductSaleOrderTuanStatus.已使用).ToString()}},
            });

            if (row > 0)
            {
                status = 0;
                errmsg = "操作成功";


            }

            return Json(new
                 {
                     Status = status,
                     Mess = errmsg

                 }, JsonRequestBehavior.AllowGet);

        }


        [Models.Filter]
        [HttpPost]
        public ActionResult HotelHexiaoMa()
        {

            string orderNo = HotelCloud.Common.HCRequest.GetString("OrderNo").TrimEnd();
            string yuName = HotelCloud.Common.HCRequest.GetString("yuName").TrimEnd();
            DateTime yuDate = Convert.ToDateTime(HotelCloud.Common.HCRequest.GetString("yuDate"));
            string tuanCode = HotelCloud.Common.HCRequest.GetString("tuanCode").TrimEnd();
            int orderId = Convert.ToInt32(HotelCloud.Common.HCRequest.GetString("orderId").TrimEnd());

            string yutype = HotelCloud.Common.HCRequest.GetString("yutype").TrimEnd();
            int yunum = Convert.ToInt32(HotelCloud.Common.HCRequest.GetString("yunum"));

            int status = -1;
            string errmsg = string.Empty;


            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            //DataTable db_order = SaleProducts_Orders.GetSaleProducts_Orders(orderNo, userweixinId);
            //var order = DataTableToEntity.GetEntity<WeiXin.Models.Home.SaleProducts_Orders>(db_order);


            int row = 0;

            string patchNo = DateTime.Now.ToString("MMddHHmmssfff");

            //批量预约
            if (yutype == "more")
            {
                tuanCode = HotelCloud.SqlServer.SQLHelper.Get_Value("select tuanCode  from  SaleProducts_OrdersTuan t with(Nolock) where  orderId=@orderId and Status in(0,3)   order by tuanCode", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {                   
                      {"orderId",new HotelCloud.SqlServer.DBParam{ParamValue=orderId.ToString()}}                      
                });

                row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@" update SaleProducts_OrdersTuan set Status=@Status,useDate=@useDate, usePerson=@usePerson,PatchNo=@PatchNo  where tuanCode  in  (select top  " + yunum + "  tuanCode  from  SaleProducts_OrdersTuan t with(Nolock) where  orderId=@orderId and Status in(0,3)   order by tuanCode )", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {   
                     {"Status",new HotelCloud.SqlServer.DBParam{ParamValue= ((int)ProductSaleOrderTuanStatus.预约中).ToString()}}  ,     
                     {"useDate",new HotelCloud.SqlServer.DBParam{ParamValue=yuDate.ToString()}}  ,  
                     {"usePerson",new HotelCloud.SqlServer.DBParam{ParamValue=yuName}}  ,  
                      {"orderId",new HotelCloud.SqlServer.DBParam{ParamValue=orderId.ToString()}},  
                        {"PatchNo",new HotelCloud.SqlServer.DBParam{ParamValue=patchNo.ToString()}}       
                });
            }


           //单个预约      
            else
            {

                DataTable db_tuan = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select  * from  SaleProducts_OrdersTuan with(nolock) where tuanCode=@tuanCode  and OrderId=@OrderId",
                       HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {   
                     {"tuanCode",new HotelCloud.SqlServer.DBParam{ParamValue=tuanCode}}  ,     
                     {"OrderId",new HotelCloud.SqlServer.DBParam{ParamValue=orderId.ToString()}} ,  
                         
                   });

                int tuanStatus = Convert.ToInt32(db_tuan.Rows[0]["status"].ToString());

                if ((tuanStatus == (int)ProductSaleOrderTuanStatus.未预约 || tuanStatus == (int)ProductSaleOrderTuanStatus.预约失败))
                {
                    row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@" update SaleProducts_OrdersTuan set Status=@Status,useDate=@useDate, usePerson=@usePerson,PatchNo=@PatchNo   where tuanCode=@tuanCode", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {   
                     {"Status",new HotelCloud.SqlServer.DBParam{ParamValue= ((int)ProductSaleOrderTuanStatus.预约中).ToString()}}  ,     
                     {"useDate",new HotelCloud.SqlServer.DBParam{ParamValue=yuDate.ToString()}}  ,  
                     {"usePerson",new HotelCloud.SqlServer.DBParam{ParamValue=yuName}}  ,  
                      {"tuanCode",new HotelCloud.SqlServer.DBParam{ParamValue=tuanCode}}  , 
                        {"PatchNo",new HotelCloud.SqlServer.DBParam{ParamValue=patchNo.ToString()}}    
  });
                }

                else
                {
                    errmsg = "找不到可预约产品！";
                }

            }


            if (row > 0)
            {
                string log = string.Format("用户申请预约");
                row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@"insert into dbo.wkn_operatingrecord(weixinid,orderno,operator,operationdate,description) values(@weixinid,@orderno,@operator,@operationdate,@description) ", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {                             
                                {"orderno",new HotelCloud.SqlServer.DBParam{ParamValue=orderNo}},                                 
                                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=hotelweixinId}}, 
                                {"operator",new HotelCloud.SqlServer.DBParam{ParamValue="用户"}},
                                {"operationdate",new HotelCloud.SqlServer.DBParam{ParamValue=DateTime.Now.ToString()}},
                                {"description",new HotelCloud.SqlServer.DBParam{ParamValue=log}}
                            });

                status = 0;
                errmsg = "预约成功";

                string postStr = string.Format("action=yuyue&orderId={0}&tuancode={1}", orderId, tuanCode);
                byte[] postData = Encoding.UTF8.GetBytes(postStr);
                string html = NormalCommon.doPost(System.Configuration.ConfigurationManager.AppSettings["sendwxmsg_url"].ToString(), postData);
            }

            else
            {
                errmsg = "预约失败！";
            }

            return Json(new
            {
                Status = status,
                Mess = errmsg
            }, JsonRequestBehavior.AllowGet);
        }


        public ActionResult FetchProductIndexList()
        {
            string query = HotelCloud.Common.HCRequest.GetString("query").TrimEnd();
            string select = HotelCloud.Common.HCRequest.GetString("select").TrimEnd();
            int page = HotelCloud.Common.HCRequest.GetInt("page", 1);
            if (page < 1)
            {
                page = 1;
            }
            int pagesize = 2;
            int count = 0;
            int pagesum = 0;

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];



            ProductEntityList list_products = new ProductEntityList();

            string cacheName = string.Format("{0}_{1}", hotelweixinId.ToLower(), "productindex");

            if (cache[cacheName] != null)
            {
                list_products = (ProductEntityList)cache[cacheName];
                count = list_products.Count;
            }

            else
            {
                list_products.ProductEntity_List = SaleProduct.GetSaleProductsListIndex(hotelweixinId, out count, page, pagesize, "", "");
                list_products.Count = count;

                cache.Insert(cacheName, list_products, null, DateTime.Now.AddMinutes(30), TimeSpan.Zero);
            }

            pagesum = (count % pagesize == 0) ? count / pagesize : count / pagesize + 1;
            return Json(new
            {
                data = list_products.ProductEntity_List,
                count = count,
                page = page,
                pagesum = pagesum
            }, JsonRequestBehavior.AllowGet);
        }


        public ActionResult ClearCache(string cacheName)
        {
            if (!string.IsNullOrEmpty(cacheName))
            {
                cache.Remove(cacheName);

                return Json(new
                {
                    Mess = "ok"
                }, JsonRequestBehavior.AllowGet);


            }

            return Json(new
            {
                Mess = ""
            }, JsonRequestBehavior.AllowGet);

        }

    }
}
