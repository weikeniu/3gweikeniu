using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WeiXin.Models.Home;
using HotelCloud.Common;
using System.Data;
using System.Net.Mail;
using System.Text;
using System.Net;
using System.Threading.Tasks;
using hotel3g.Models;

using System.IO;
using System.Xml.Linq;
using WeiXin.Common;
using System.Security.Cryptography;
using HotelHotel.Utility;
using WeiXin.Models;

namespace WeiXin.Controllers
{
    public class ProductControllerBAK : Controller
    {

        private static System.Web.Caching.Cache cache = HttpRuntime.Cache;

        string keyOrder = "uts2017yy";
        string userKey = "uiosdflkjsdflkqdsffsdfyusndsfbysht";



        public ActionResult NewIndex(string id)
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
            Hotel hotel = Cache.GetHotel(Convert.ToInt32(id));
            ViewData["hotel"] = hotel.SubName;
            return View();



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
            string sign = key.Split('@')[2];
            if (!IsValidateUser(hotelweixinId, userweixinId, sign))
            {
                return View();
            }


            ProductEntityList list_products = new ProductEntityList();

            string cacheName = string.Format("{0}_{1}", hotelweixinId.ToLower(), "productindex");

            if (cache[cacheName] != null)
            {
                list_products = (ProductEntityList)cache[cacheName];
                count = list_products.Count;
            }

            else
            {
                list_products.ProductEntity_List = Models.Home.SaleProduct.GetSaleProductsListIndex(hotelweixinId, out count, page, pagesize, "", "");
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


        public ActionResult ProductErrMsg()
        {


            return View();
        }




        public ActionResult ProductList(string id)
        {

             return RedirectToAction("ProductList", "ProductA", new { id = RouteData.Values["id"], key = HotelCloud.Common.HCRequest.GetString("key"),s="1" });

            string query = HotelCloud.Common.HCRequest.GetString("query").TrimEnd();
            string select = HotelCloud.Common.HCRequest.GetString("select").TrimEnd();

            int page = HotelCloud.Common.HCRequest.GetInt("page", 1);
            int pagesize = 5;

            if (page < 1)
            {
                page = 1;
            }

            int count = 0;


            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            string sign = ValidateUserSign(hotelweixinId, userweixinId);
            if (string.IsNullOrEmpty(sign))
            {
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "用户参数不合法", key = key });
            }
            ViewData["key"] = key + "@" + sign;


            string cacheName = string.Format("{0}_{1}", hotelweixinId.ToLower(), "productlist");

            ProductEntityList list_products = new ProductEntityList();

            if (cache[cacheName] != null)
            {
                list_products = (ProductEntityList)cache[cacheName];
                count = list_products.Count;
            }

            else
            {
                list_products.ProductEntity_List = Models.Home.SaleProduct.GetSaleProductsListIndex(hotelweixinId, out count, page, pagesize, "", "");
                list_products.Count = count;

                cache.Insert(cacheName, list_products, null, DateTime.Now.AddMinutes(30), TimeSpan.Zero);
            }



            int pagesum = (count % pagesize == 0) ? count / pagesize : count / pagesize + 1;

            //ViewData["products"] = ProductEntity.ConvertProductEntityList(products);
            ViewData["products"] = list_products.ProductEntity_List;

            ViewData["count"] = count;
            ViewData["page"] = page;
            ViewData["pagesize"] = pagesize;
            ViewData["pagesum"] = pagesum;

            return View();
        }





        public ActionResult FetchProductList()
        {

            string query = HotelCloud.Common.HCRequest.GetString("query").TrimEnd();
            string select = HotelCloud.Common.HCRequest.GetString("select").TrimEnd();
            int page = HotelCloud.Common.HCRequest.GetInt("page", 1);
            if (page < 1)
            {
                page = 1;
            }
            int pagesize = 5;
            int count = 0;
            int pagesum = 0;

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            string sign = key.Split('@')[2];
            if (!IsValidateUser(hotelweixinId, userweixinId, sign))
            {
                return View();
            }
            ViewData["key"] = key;

            //var products = Models.Home.SaleProduct.GetSaleProducts(hotelweixinId, out count, page, pagesize, "", "");

            var products = Models.Home.SaleProduct.GetSaleProductsListIndex(hotelweixinId, out count, page, pagesize, "", "");


            pagesum = (count % pagesize == 0) ? count / pagesize : count / pagesize + 1;
            return Json(new
            {
                data = products,
                count = count,
                page = page,
                pagesum = pagesum
            }, JsonRequestBehavior.AllowGet);
        }



        public ActionResult ProductIndexGroup()
        {
            int Id = HotelCloud.Common.HCRequest.getInt("Id");
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            return RedirectToAction("ProductDetail", "ProductA", new { id = RouteData.Values["id"], key = hotelweixinId + "@" + userweixinId, ProductId = Id, s = "1" });


            Models.Home.SaleProduct products = new Models.Home.SaleProduct();

            Newtonsoft.Json.Converters.IsoDateTimeConverter timeFormat = new Newtonsoft.Json.Converters.IsoDateTimeConverter();
            timeFormat.DateTimeFormat = "yyyy-MM-dd";

            if (Id > 0)
            {
             
                string sign = key.Split('@')[2];
                if (!IsValidateUser(hotelweixinId, userweixinId, sign))
                {
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "签名不合法", key = key });
                }
                ViewData["key"] = key;


                products = Models.Home.SaleProduct.GetSaleProduct(hotelweixinId, Id);

                if (products == null || products.Id == 0 || products.ProductType == 1)
                {
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "没找到对应的产品", key = HotelCloud.Common.HCRequest.GetString("key") });
                }


                if (products.BeginTime > DateTime.Now)
                {
                    // return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "产品还未开始预售。", key = HotelCloud.Common.HCRequest.GetString("key") });
                }

                if (products.EndTime < DateTime.Now)
                {
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "产品已过期。", key = HotelCloud.Common.HCRequest.GetString("key") });
                }

                if (products.Status != 0)
                {
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "产品已下架", key = HotelCloud.Common.HCRequest.GetString("key") });
                }

                products.List_SaleProducts_TC = Models.Home.SaleProducts_TC.GetSaleProducts_TC(products.Id);

                DataTable db = Models.Home.SaleProduct.GetHotelInfo(products.WeiXinId);
                if (db.Rows.Count > 0)
                {
                    ViewData["hotelname"] = db.Rows[0]["SubName"].ToString();
                }


                products.List_SaleProducts_TC = products.List_SaleProducts_TC.Where(c => c.ProductPrice > 0 && c.ProductNum > 0).ToList();

                products.Json_SaleProducts_TC = Newtonsoft.Json.JsonConvert.SerializeObject(products.List_SaleProducts_TC, timeFormat);

            }

            ViewData["products"] = products;


            double minPrice = 0;
            double maxPrice = 0;


            if (products.List_SaleProducts_TC != null && products.List_SaleProducts_TC.Count > 0)
            {

                minPrice = Convert.ToDouble(products.List_SaleProducts_TC.Min(c => c.ProductPrice));

                maxPrice = Convert.ToDouble(products.List_SaleProducts_TC.Max(c => c.ProductPrice));
            }


            if (minPrice == 0)
            {
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "产品已售完", key = HotelCloud.Common.HCRequest.GetString("key") });

            }


            ViewData["key"] = HotelCloud.Common.HCRequest.GetString("key");

            ViewData["minPrice"] = minPrice;
            ViewData["maxPrice"] = maxPrice;


            return View();
        }



        public ActionResult ProductPay(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            string sign = key.Split('@')[2];
            if (!IsValidateUser(hotelweixinId, userweixinId, sign))
            {
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "签名不合法", key = key });
            }
            ViewData["key"] = key;


            SaleProducts_Orders order = new SaleProducts_Orders();

            if (!string.IsNullOrEmpty(HotelCloud.Common.HCRequest.GetString("orderNo")))
            {

                DataTable db_order = Models.Home.SaleProducts_Orders.GetSaleProducts_Orders(HotelCloud.Common.HCRequest.GetString("orderNo"), userweixinId);

                order = DataTableToEntity.GetEntity<Models.Home.SaleProducts_Orders>(db_order);

                if (order.Ispay)
                {
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "订单已付款！", key = key });
                }

                if ((DateTime.Now - order.OrderAddTime).TotalMinutes > 30)
                {
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "支付超时，订单已关闭。", key = key });

                }

                ViewData["order"] = order;

                return View();
            }



            order.ProductId = Convert.ToInt32(Request.Form["ProductId"]);
            order.TcId = Convert.ToInt32(Request.Form["tcId"]);
            order.BookingCount = Convert.ToInt32(Request.Form["BookingCount"]);
            order.CheckOutTime = order.CheckInTime = Convert.ToDateTime(Request.Form["TravelDate"]);

            string token = Request.Form["t"];

            string signorder = string.Format("{0}_{1}_{2}_{3}_{4}_{5}", order.ProductId, order.TcId, order.BookingCount, order.CheckInTime.ToString("yyyy-MM-dd"), token, keyOrder);
            signorder = Encryption(signorder);


            if (Request.Form["sign"] != signorder)
            {
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "非法的请求！", key = key });
            }

            var products = Models.Home.SaleProduct.GetSaleProduct(hotelweixinId, order.ProductId);

            token = string.Format("{0}_{1}", products.HotelId, token);
            string before_token = Models.Home.SaleProducts_Orders.GetSaleProducts_OrdersByToken(token);
            if (!string.IsNullOrEmpty(before_token))
            {
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "请不要重复提交订单", key = key });
            }


            products.List_SaleProducts_TC = Models.Home.SaleProducts_TC.GetSaleProducts_TC(products.Id);



            order.OrderAddTime = DateTime.Now;
            order.ProductName = products.ProductName;
            order.LinkName = order.UserName = Request.Form["lxr_name"].ToString();
            order.UserMobile = Request.Form["lxr_mobile"].ToString();



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
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "产品还未开始预售。", key = key });
                }

                if (products.EndTime < DateTime.Now)
                {
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "产品已过期。", key = key });
                }

                // int hexiaoMa = new Random().Next(100000000, 999990000);      


                order.OrderMoney = Convert.ToDecimal(tc_product.ProductPrice * order.BookingCount);

            }

            else
            {
                var tc_priceList = Models.Home.SaleProducts_TC_Price.GetSaleProducts_TC_Price(order.TcId);
                var tc_price = tc_priceList.Where(c => c.SaleTime == order.CheckInTime).FirstOrDefault();
                order.OrderMoney = Convert.ToDecimal(order.BookingCount * tc_price.Price);

            }

            order.Remark = "";
            order.TaoBaoStatus = "";
            order.OperatorLog = "";
            order.OrderStatus = 0;


            int Id = Models.Home.SaleProducts_Orders.AddSaleProducts_Orders(order);

            if (Id > 0)
            {
                return RedirectToAction("ProductPay", "Product", new { OrderNo = order.OrderNo, key = key });
            }

            return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "抱歉，下单失败", key = key });
        }



        public ActionResult ProductConfirmOrder()
        {

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            string sign = key.Split('@')[2];
            if (!IsValidateUser(hotelweixinId, userweixinId, sign))
            {
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "签名不合法", key = key });
            }
            ViewData["key"] = key;




            int productId = HotelCloud.Common.HCRequest.getInt("productId");
            int tcId = HotelCloud.Common.HCRequest.getInt("TcId");

            DateTime buyDate = DateTime.Now;
            if (!string.IsNullOrEmpty(HotelCloud.Common.HCRequest.GetString("date")))
            {
                buyDate = Convert.ToDateTime(HotelCloud.Common.HCRequest.GetString("date"));

            }
            int buyAmount = HotelCloud.Common.HCRequest.getInt("buyAmount");


            string token = string.Empty;
            string t = HotelCloud.Common.HCRequest.GetString("t");
            if (string.IsNullOrEmpty(t))
            {
                TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
                token = string.Format("{0}", Convert.ToInt64(ts.TotalMilliseconds).ToString());

                string signorder = string.Format("{0}_{1}_{2}_{3}_{4}_{5}", productId, tcId, buyAmount, buyDate.ToString("yyyy-MM-dd"), token, keyOrder);
                signorder = Encryption(signorder);

                return RedirectToAction("ProductConfirmOrder", "Product", new { key = key, productId = productId, tcId = tcId, date = buyDate.ToString("yyyy-MM-dd"), buyAmount = buyAmount, t = token, sign = signorder });
            }


            var products = Models.Home.SaleProduct.GetSaleProduct(hotelweixinId, productId);

            if (products == null || products.Id == 0)
            {
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "没有找到对应的产品。", key = HotelCloud.Common.HCRequest.GetString("key") });
            }


            products.List_SaleProducts_TC = Models.Home.SaleProducts_TC.GetSaleProducts_TC(productId);
            products.List_SaleProducts_TC = products.List_SaleProducts_TC.Where(c => c.Id == tcId).ToList();

            if (products.List_SaleProducts_TC == null || products.List_SaleProducts_TC.Count == 0)
            {
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "没有找到对应的套餐。", key = HotelCloud.Common.HCRequest.GetString("key") });
            }

            //group buy
            if (products.ProductType == 0)
            {
                double totalMoney = Convert.ToDouble(products.List_SaleProducts_TC[0].ProductPrice * buyAmount);
                ViewData["totalMoney"] = totalMoney;

            }

            else
            {
                products.List_SaleProducts_TC[0].List_SaleProducts_TC_Price = Models.Home.SaleProducts_TC_Price.GetSaleProducts_TC_Price(products.List_SaleProducts_TC[0].Id);
                var saleProducts_TC_price = products.List_SaleProducts_TC[0].List_SaleProducts_TC_Price.Where(c => c.SaleTime == buyDate).FirstOrDefault();

                double totalMoney = Convert.ToDouble(saleProducts_TC_price.Price * buyAmount);

                ViewData["totalMoney"] = totalMoney;



            }

            ViewData["key"] = HotelCloud.Common.HCRequest.GetString("key");
            ViewData["products"] = products;

            return View();
        }



        public ActionResult ProductIndex()
        {
            int Id = HotelCloud.Common.HCRequest.getInt("Id");
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            return RedirectToAction("ProductDetail", "ProductA", new { id = RouteData.Values["id"], key = hotelweixinId + "@" + userweixinId, ProductId = Id, s = "1" });



            Models.Home.SaleProduct products = new Models.Home.SaleProduct();

            Newtonsoft.Json.Converters.IsoDateTimeConverter timeFormat = new Newtonsoft.Json.Converters.IsoDateTimeConverter();
            timeFormat.DateTimeFormat = "yyyy-MM-dd";

            if (Id > 0)
            {

               
                string sign = key.Split('@')[2];
                if (!IsValidateUser(hotelweixinId, userweixinId, sign))
                {
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "签名不合法", key = key });
                }
                ViewData["key"] = key;


                products = Models.Home.SaleProduct.GetSaleProduct(hotelweixinId, Id);

                if (products == null || products.Id == 0 || products.ProductType == 0)
                {
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "没找到对应的产品", key = HotelCloud.Common.HCRequest.GetString("key") });
                }

                if (products.EndTime < DateTime.Now)
                {
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "产品已过期", key = HotelCloud.Common.HCRequest.GetString("key") });
                }

                if (products.Status != 0)
                {
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "产品已下架", key = HotelCloud.Common.HCRequest.GetString("key") });
                }

                products.List_SaleProducts_TC = Models.Home.SaleProducts_TC.GetSaleProducts_TC(products.Id);


                DataTable db = Models.Home.SaleProduct.GetHotelInfo(products.WeiXinId);
                if (db.Rows.Count > 0)
                {
                    ViewData["hotelname"] = db.Rows[0]["SubName"].ToString();
                }

                foreach (var item in products.List_SaleProducts_TC)
                {
                    item.List_SaleProducts_TC_Price = Models.Home.SaleProducts_TC_Price.GetSaleProducts_TC_Price(item.Id);
                }

                products.List_SaleProducts_TC = products.List_SaleProducts_TC.Where(c => c.List_SaleProducts_TC_Price.Count > 0).ToList();

                products.Json_SaleProducts_TC = Newtonsoft.Json.JsonConvert.SerializeObject(products.List_SaleProducts_TC, timeFormat);

            }

            ViewData["products"] = products;


            int minPrice = 0;
            int maxPrice = 0;


            if (products.List_SaleProducts_TC != null && products.List_SaleProducts_TC.Count > 0)
            {
                var t_price = new List<Models.Home.SaleProducts_TC_Price>();
                products.List_SaleProducts_TC.ForEach(r => { t_price.AddRange(r.List_SaleProducts_TC_Price); });
                minPrice = Convert.ToInt32(t_price.Min(c => c.Price));
                maxPrice = Convert.ToInt32(t_price.Max(c => c.Price));
            }


            if (minPrice == 0)
            {
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "产品已售完", key = HotelCloud.Common.HCRequest.GetString("key") });

            }





            ViewData["minPrice"] = minPrice;
            ViewData["maxPrice"] = maxPrice;


            return View();
        }



        public ActionResult ProductUserOrders(string id)
        {

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];

            string sign = ValidateUserSign(hotelweixinId, userweixinId);
            if (string.IsNullOrEmpty(sign))
            {
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "用户参数不合法", key = key });
            }
            ViewData["key"] = key + "@" + sign;


            int count = 0;
            int page = 1;
            int pageSize = int.MaxValue;

            DataTable db_order = SaleProducts_Orders.GetSaleProducts_Orders(userweixinId, out count, page, pageSize, "", "");
            var list_orders = DataTableToEntity.GetEntities<Models.Home.SaleProducts_Orders>(db_order).ToList();

            ViewData["Orders"] = list_orders;

            return View();

        }



        public ActionResult ProductUserOrderDetail(string orderNo)
        {


            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            string sign = string.Empty;


            //当没有签名字符启用查询验证
            if (key.Split('@').Length <= 2)
            {
                sign = ValidateUserSign(hotelweixinId, userweixinId);
                if (string.IsNullOrEmpty(sign))
                {
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "用户参数不合法", key = key });
                }
                ViewData["key"] = key + "@" + sign;
                return RedirectToAction("ProductUserOrderDetail", "Product", new { orderNo = orderNo, key = ViewData["key"] });

            }

            sign = key.Split('@')[2];
            if (!IsValidateUser(hotelweixinId, userweixinId, sign))
            {
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "签名不合法", key = key });
            }
            ViewData["key"] = key;



            DataTable db_order = SaleProducts_Orders.GetSaleProducts_Orders(orderNo, userweixinId);
            var order = DataTableToEntity.GetEntity<Models.Home.SaleProducts_Orders>(db_order);

            ViewData["order"] = order;



            return View();

        }


        public ActionResult ProductUserHexiao(string orderNo)
        {

            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            string sign = key.Split('@')[2];
            if (!IsValidateUser(hotelweixinId, userweixinId, sign))
            {
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "签名不合法", key = key });
            }
            ViewData["key"] = key;

            DataTable db_order = SaleProducts_Orders.GetSaleProducts_Orders(orderNo, userweixinId);
            var order = DataTableToEntity.GetEntity<Models.Home.SaleProducts_Orders>(db_order);


            if (order.Id > 0)
            {



                if (order.ProductType == 0)
                {

                    //未使用或失败
                    if (order.HexiaoStatus == 0 || order.HexiaoStatus == 3)
                    {
                        ViewData["order"] = order;
                    }

                    else
                    {
                        return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "已经预约过产品！", key = HotelCloud.Common.HCRequest.GetString("key") });
                    }
                }


                else
                {
                    return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "非团购产品无需预约！", key = HotelCloud.Common.HCRequest.GetString("key") });

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
                }
            }

            else
            {
                return RedirectToAction("ProductErrMsg", "Product", new { id = RouteData.Values["id"], errmsg = "找不到预约产品！", key = HotelCloud.Common.HCRequest.GetString("key") });
            }

            return View();
        }






        public ActionResult HotelHexiaoMa()
        {


            string orderNo = HotelCloud.Common.HCRequest.GetString("OrderNo").TrimEnd();
            string yuName = HotelCloud.Common.HCRequest.GetString("yuName").TrimEnd();
            DateTime yuDate = Convert.ToDateTime(HotelCloud.Common.HCRequest.GetString("yuDate"));


            int status = -1;
            string errmsg = string.Empty;


            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinId = key.Split('@')[0];
            string userweixinId = key.Split('@')[1];
            string sign = key.Split('@')[2];
            if (!IsValidateUser(hotelweixinId, userweixinId, sign))
            {
                errmsg = "签名不合法";
                return Json(new
                {
                    Status = status,
                    Mess = errmsg
                }, JsonRequestBehavior.AllowGet);

            }
            ViewData["key"] = key;



            DataTable db_order = SaleProducts_Orders.GetSaleProducts_Orders(orderNo, userweixinId);
            var order = DataTableToEntity.GetEntity<Models.Home.SaleProducts_Orders>(db_order);

            if (order.Id > 0 && order.ProductType == 0 && order.Ispay && (order.HexiaoStatus == (int)ProductSaleOrderTuanStatus.未预约 || order.HexiaoStatus == (int)ProductSaleOrderTuanStatus.预约失败))
            {

                int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@" update SaleProducts_Orders set HexiaoStatus=1,CheckInTime=@CheckInTime,CheckOutTime=@CheckOutTime,UserName=@UserName  where Id=@Id", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {   
                     {"CheckInTime",new HotelCloud.SqlServer.DBParam{ParamValue=yuDate.ToString()}}  ,     
                     {"CheckOutTime",new HotelCloud.SqlServer.DBParam{ParamValue=yuDate.ToString()}}  ,  
                     {"UserName",new HotelCloud.SqlServer.DBParam{ParamValue=yuName}}  ,  
                     {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=order.Id.ToString()}}      
  });
                if (row > 0)
                {
                    string log = string.Format("用户申请预约");
                    row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@"insert into dbo.wkn_operatingrecord(weixinid,orderno,operator,operationdate,description) values(@weixinid,@orderno,@operator,@operationdate,@description) ", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {                             
                                {"orderno",new HotelCloud.SqlServer.DBParam{ParamValue=order.OrderNo}},                                 
                                {"weixinid",new HotelCloud.SqlServer.DBParam{ParamValue=order.HotelWeiXinId}}, 
                                {"operator",new HotelCloud.SqlServer.DBParam{ParamValue="用户"}},
                                {"operationdate",new HotelCloud.SqlServer.DBParam{ParamValue=DateTime.Now.ToString()}},
                                {"description",new HotelCloud.SqlServer.DBParam{ParamValue=log}}
                            });

                    status = 0;
                    errmsg = "预约成功";
                }


                else
                {
                    errmsg = "预约失败";

                }

            }

            else
            {
                errmsg = "找不到预约产品！";
            }

            return Json(new
            {
                Status = status,
                Mess = errmsg
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



        /// <summary>
        /// 验证酒店及用户合法并生成签名
        /// </summary>
        /// <param name="hotelweiXinId"></param>
        /// <param name="userweixinId"></param>
        /// <returns></returns>
        private string ValidateUserSign(string hotelweiXinId, string userweixinId)
        {
            string Id = HotelCloud.SqlServer.SQLHelper.Get_Value("select Id from Member  with(nolock)  where   weixinID=@weixinID    and userWeiXinNO=@userWeiXinNO",
                  HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {                             
                                {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=hotelweiXinId,}},   
                                 {"userWeiXinNO",new HotelCloud.SqlServer.DBParam{ParamValue=userweixinId}}
                              });


            if (!string.IsNullOrEmpty(Id))
            {
                return Encryption(string.Format("{0}_{1}_{2}", hotelweiXinId, userweixinId, userKey));
            }

            return string.Empty;
        }


        /// <summary>
        /// 验证签名是否正确
        /// </summary>
        /// <param name="hotelweiXinId"></param>
        /// <param name="userweixinId"></param>
        /// <param name="sign"></param>
        /// <returns></returns>

        private bool IsValidateUser(string hotelweiXinId, string userweixinId, string sign)
        {
            if (sign == Encryption(string.Format("{0}_{1}_{2}", hotelweiXinId, userweixinId, userKey)))
            {
                return true;
            }

            return false;

        }



        /// <summary> 
        /// 加密 
        /// </summary> 
        /// <param name="pInput">输入的字符串</param> 
        /// <returns>加密后的结果</returns> 
        public static string Encryption(string pInput)
        {
            MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
            byte[] val, hash;
            val = Encoding.UTF8.GetBytes(pInput);
            hash = md5.ComputeHash(val);
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < hash.Length; i++)
            {
                sb.Append(hash[i].ToString("x").PadLeft(2, '0'));
            }
            return sb.ToString();
        }

    }
}
