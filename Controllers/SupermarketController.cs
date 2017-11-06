using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using hotel3g.Models;
using System.Data;
using System.Net;
using System.IO;
using System.Text;
using Newtonsoft.Json;
using System.Text.RegularExpressions;
using System.Transactions;
using System.Web.Script.Serialization;
using hotel3g.Repository;
using hotel3g.Common;

namespace hotel3g.Controllers
{
    public class SupermarketController : Controller
    {
        ShoppingCartService cartService = new ShoppingCartService();
        SupermarketOrderService orderService = new SupermarketOrderService();
        //
        // GET: /Supermarket/
        [Models.Filter]
        public ActionResult Index(string id)
        {
            string hotelId = id;
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }

            string search = HotelCloud.Common.HCRequest.GetString("SupermarketSearch");
            DataTable commodityDataTable = CommodityService.GetDataByUserId(weixinid, id, userweixinid);
            List<DataRow> rows = commodityDataTable.AsEnumerable().ToList();
            if (!string.IsNullOrWhiteSpace(search))
                rows = rows.Where(r => WeiXinPublic.ConvertHelper.ToString(r["Name"]).Contains(search)).ToList();

            string hotelName = DishOrderLogic.GetHotelName(hotelId);

            ViewData["SupermarketSearch"] = search;
            ViewData["hotelId"] = id;
            ViewData["Address"] = hotelName;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            ViewData["commodityDataTable"] = commodityDataTable;
            ViewData["commodityList"] = rows;
            ViewData["CommodityTypeTable"] = CommodityService.GetCommodityTypeByhotelId(weixinid, hotelId, "");
            //ViewData["CommodityTypeTable2"] = CommodityService.GetCommodityTypeByWeixinId(weixinid, "");
            return View();
        }

        // GET: /Supermarket/Search
        [Models.Filter]
        public ActionResult Search(string id)
        {
            string hotelId = id;
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }

            ViewData["hotelId"] = id;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            return View();
        }

        // GET: /Supermarket/CommodityRichText
        [Models.Filter]
        public ActionResult CommodityRichText(string id)
        {
            string hotelId = id;
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string commodityId = HotelCloud.Common.HCRequest.GetString("CommodityID");//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }
            var DataTable = CommodityService.GetDataById(commodityId);

            var hotelData = GetHotelBySupermarket(int.Parse(id)).Rows[0];

            ViewData["myPoints"] = 0;
            var userDt = orderService.GetScoreByUser(weixinid, userweixinid);
            if (userDt.Rows.Count > 0)
            {
                ViewData["myPoints"] = userDt.Rows[0]["Emoney"];
            }
            ViewData["Address"] = hotelData["address"];
            ViewData["soldCount"] = SupermarketOrderDetailService.GetSoldCount(commodityId).Rows[0][0];
            ViewData["hotelName"] = DishOrderLogic.GetHotelName(hotelId);
            ViewData["commodityTable"] = DataTable;
            ViewData["hotelId"] = id;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            ViewData["CommodityID"] = commodityId;
            return View();
        }

        // GET: /SupermarketA/OrderDetailsAlone
        [Models.Filter]
        public ActionResult OrderDetailsAlone(string id)
        {
            string hotelId = id;
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string commodityId = HotelCloud.Common.HCRequest.GetString("commodityid");//商品id
            string PayMode = HotelCloud.Common.HCRequest.GetString("PayMode");//支付模式
            string isComeTravel = HotelCloud.Common.HCRequest.GetString("isComeTravel");//是否旅行社进入
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }
            ViewData["commodityId"] = commodityId;
            ViewData["PayMode"] = PayMode;
            ViewData["isComeTravel"] = isComeTravel;


            //计算订单总金额
            var DataTable = CommodityService.GetDataById(commodityId);
            double sum = 0;
            decimal canCouponSum = 0;
            int needPoints = 0;
            int canPoints = 1;
            foreach (DataRow data in DataTable.Rows)
            {
                needPoints = int.Parse(data["PurchasePoints"].ToString());
                canPoints = int.Parse(data["CanPurchase"].ToString());
                sum += double.Parse(data["Price"].ToString());
                if (int.Parse(data["CanCouPon"].ToString()) == 1)
                {
                    canCouponSum += decimal.Parse(data["Price"].ToString());
                }
            }

            ViewData["canPoints"] = canPoints;
            ViewData["needPoints"] = needPoints;
            ViewData["myPoints"] = 0;
            var userDt = orderService.GetScoreByUser(weixinid, userweixinid);
            if (userDt.Rows.Count > 0)
            {
                ViewData["myPoints"] = userDt.Rows[0]["Emoney"];
            }

            //获取可用红包
            var couponDataTable = CouPon.GetUserCouPonDataTable(weixinid, userweixinid, "3");
            ViewData["couponDataTable"] = new DataTable();
            ViewData["canCouponSum"] = canCouponSum;
            if (couponDataTable.Rows.Count > 0 && canCouponSum > 0)
            {
                ViewData["couponDataTable"] = couponDataTable;
                //var q1 = from dt1 in couponDataTable.AsEnumerable()//查询
                //         //orderby dt1.Field<int>("ID") descending//排序
                //         where dt1.Field<decimal>("amountlimit") <= canCouponSum//条件
                //         select dt1;
                //if (q1.Count() > 0)
                //{
                //    ViewData["couponDataTable"] = q1.CopyToDataTable<DataRow>();
                //}
            }

            //获取收货地址
            List<OrderAddress> list = DishOrderLogic.GetAddressList(userweixinid);
            OrderAddress address = list.Find(a => a.isSelected == true);

            ViewData["ExpressFee"] = 0;
            ViewData["hotelName"] = DishOrderLogic.GetHotelName(hotelId);
            ViewData["addressRoomNo"] = "";
            if (address != null)
            {
                var hotelData = SupermarketController.GetHotelBySupermarket(int.Parse(id)).Rows[0];
                ViewData["ExpressFee2"] = hotelData["expressfee"];
                if (address.addressType == 1)
                {
                    ViewData["addressType"] = "酒店";
                    ViewData["addressName"] = address.Address + address.RoomNo;
                    ViewData["addressRoomNo"] = address.RoomNo;
                    ViewData["ExpressFee"] = 0;
                }
                else
                {
                    ViewData["addressType"] = "快递";
                    ViewData["addressName"] = address.kuaidiAddress;
                    try
                    {
                        ViewData["ExpressFee"] = hotelData["expressfee"];
                        ViewData["hotelPhone"] = hotelData["tel"];
                        sum += double.Parse(hotelData["expressfee"].ToString());
                    }
                    catch (Exception e)
                    {
                        ViewData["ExpressFee"] = 0;
                        ViewData["hotelPhone"] = "";
                    }
                }
                ViewData["Address"] = address;
                ViewData["OriginAddressType"] = address.addressType;
            }
            else
            {
                ViewData["Address"] = new OrderAddress();
                ViewData["addressType"] = "酒店";
                ViewData["hotelPhone"] = "";
                ViewData["addressName"] = ViewData["hotelName"];
                ViewData["OriginAddressType"] = 1;
            }

            //获取积分
            ViewData["orderScore"] = 0;
            ViewData["equivalence"] = 1;
            ViewData["GradePlus"] = 1;
            MemberInfo Info = MemberHelper.GetMemberInfo(weixinid);
            string cardno = MemberHelper.GetCardNo(userweixinid, weixinid);
            if (!string.IsNullOrEmpty(cardno))
            {
                MemberCard MyCard = MemberHelper.GetMemberCard(cardno, weixinid);
                MemberCardIntegralRule IntegralRule = MemberHelper.IntegralRule(Info, MyCard);
                var score = sum;
                if (IntegralRule.equivalence > 0)
                {
                    score = score * IntegralRule.equivalence;
                    ViewData["equivalence"] = IntegralRule.equivalence;
                }
                if ((double)IntegralRule.GradePlus > 0)
                {
                    score = score * (double)IntegralRule.GradePlus;
                    ViewData["GradePlus"] = IntegralRule.GradePlus;
                }

                ViewData["orderScore"] = Math.Floor(Math.Round(score, 2));
            }

            ViewData["shoppingCarDataTable"] = DataTable;
            ViewData["amount"] = sum;
            ViewData["hotelId"] = id;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            return View();
        }

        // GET: /Supermarket/OrderDetails
        [Models.Filter]
        public ActionResult OrderDetails(string id)
        {
            string hotelId = id;
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }

            //计算订单总金额
            var shoppingCarDataTable = cartService.GetDataByUserId(id, userweixinid);
            double sum = 0;
            decimal canCouponSum = 0;
            int needPoints = 0;
            int canPoints = 1;
            foreach (DataRow data in shoppingCarDataTable.Rows)
            {
                sum += double.Parse(data["Price"].ToString()) * int.Parse(data["Total"].ToString());
                if (int.Parse(data["CanCouPon"].ToString()) == 1)
                {
                    canCouponSum += decimal.Parse(data["Price"].ToString()) * int.Parse(data["Total"].ToString());
                }
                if (int.Parse(data["CanPurchase"].ToString()) == 0)
                {
                    canPoints = 0;
                }
                else
                {
                    needPoints += int.Parse(data["PurchasePoints"].ToString()) * int.Parse(data["Total"].ToString());
                }
            }

            //获取可用红包
            var couponDataTable = CouPon.GetUserCouPonDataTable(weixinid, userweixinid, "3");
            ViewData["couponDataTable"] = new DataTable();
            if (couponDataTable.Rows.Count > 0 && canCouponSum > 0)
            {
                var q1 = from dt1 in couponDataTable.AsEnumerable()//查询
                         //orderby dt1.Field<int>("ID") descending//排序
                         where dt1.Field<decimal>("amountlimit") <= canCouponSum//条件
                         select dt1;
                if (q1.Count() > 0)
                {
                    ViewData["couponDataTable"] = q1.CopyToDataTable<DataRow>();
                }
            }



            ViewData["NoExpressAmount"] = sum;
            ViewData["canPoints"] = canPoints;
            ViewData["needPoints"] = needPoints;
            ViewData["myPoints"] = 0;
            var userDt = orderService.GetScoreByUser(weixinid, userweixinid);
            if (userDt.Rows.Count > 0)
            {
                ViewData["myPoints"] = userDt.Rows[0]["Emoney"];
            }

            //获取收货地址
            List<OrderAddress> list = DishOrderLogic.GetAddressList(userweixinid);
            OrderAddress address = list.Find(a => a.isSelected == true);

            ViewData["ExpressFee"] = 0;
            ViewData["hotelName"] = DishOrderLogic.GetHotelName(hotelId);
            if (address != null)
            {
                if (address.addressType == 1)
                {
                    ViewData["addressType"] = "酒店";
                    ViewData["addressName"] = address.Address + address.RoomNo;
                    ViewData["ExpressFee"] = 0;
                }
                else
                {
                    ViewData["addressType"] = "快递";
                    ViewData["addressName"] = address.kuaidiAddress;
                    try
                    {
                        var hotelData = GetHotelBySupermarket(int.Parse(id)).Rows[0];
                        ViewData["ExpressFee"] = hotelData["expressfee"];
                        ViewData["hotelPhone"] = hotelData["tel"];
                        sum += double.Parse(hotelData["expressfee"].ToString());
                    }
                    catch (Exception e)
                    {
                        ViewData["ExpressFee"] = 0;
                        ViewData["hotelPhone"] = "";
                    }
                }
                ViewData["Address"] = address;
                ViewData["OriginAddressType"] = address.addressType;
            }
            else
            {
                ViewData["Address"] = new OrderAddress();
                ViewData["addressType"] = "酒店";
                ViewData["hotelPhone"] = "";
                ViewData["addressName"] = ViewData["hotelName"];
                ViewData["OriginAddressType"] = 1;
            }

            //获取积分
            ViewData["orderScore"] = 0;
            ViewData["equivalence"] = 1;
            ViewData["GradePlus"] = 1;
            MemberInfo Info = MemberHelper.GetMemberInfo(weixinid);
            string cardno = MemberHelper.GetCardNo(userweixinid, weixinid);
            if (!string.IsNullOrEmpty(cardno))
            {
                MemberCard MyCard = MemberHelper.GetMemberCard(cardno, weixinid);
                MemberCardIntegralRule IntegralRule = MemberHelper.IntegralRule(Info, MyCard);
                var score = sum;
                if (IntegralRule.equivalence > 0)
                {
                    score = score * IntegralRule.equivalence;
                    ViewData["equivalence"] = IntegralRule.equivalence;
                }
                if ((double)IntegralRule.GradePlus > 0)
                {
                    score = score * (double)IntegralRule.GradePlus;
                    ViewData["GradePlus"] = IntegralRule.GradePlus;
                }

                ViewData["orderScore"] = Math.Floor(Math.Round(score, 2));
            }

            ViewData["shoppingCarDataTable"] = shoppingCarDataTable;
            ViewData["amount"] = sum;
            ViewData["hotelId"] = id;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            return View();
        }

        // GET: /Supermarket/OrderDetails2
        [Models.Filter]
        public ActionResult OrderDetails2(string id)
        {
            string hotelId = id;
            string orderId = HotelCloud.Common.HCRequest.GetString("orderid");
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }

            ViewData["list_ordersLog"] = new DataTable();
            ViewData["PayStatus"] = 0;
            ViewData["addressType"] = "酒店";
            ViewData["shoppingCarDataTable"] = new DataTable();
            ViewData["amount"] = 0;
            ViewData["refundfee"] = 0;
            ViewData["ExpressCompany"] = "";
            ViewData["ExpressNo"] = "";
            ViewData["hotelId"] = "";
            ViewData["ExpressFee"] = 0;
            ViewData["remark"] = "";
            ViewData["OrderStatus"] = 0;
            ViewData["CreateTime"] = new DateTime();
            ViewData["CanPurchase"] = 0;
            ViewData["PurchasePoints"] = 0;
            ViewData["PayMethod"] = "";
            ViewData["isAllowDelayed"] = false;
            ViewData["isShowAllowDelayed"] = true;
            ViewData["DelayedTake"] = 0;
            ViewData["CouponId"] = "";
            ViewData["CouponMoney"] = 0;
            ViewData["express"] = new ExpressData();
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            ViewData["orderId"] = orderId;
            ViewData["hotelId"] = id;
            try
            {
                var orderData = orderService.GetDataByOrderId(orderId).Rows[0];
                double refundfee = 0;
                try
                {
                    refundfee = double.Parse(orderData["Refundfee"].ToString()) + double.Parse(orderData["CardRefundfee"].ToString());
                }
                catch (Exception e) { }
                ViewData["refundfee"] = refundfee;

                //计算订单总金额
                double sum = 0;
                var shoppingCarDataTable = SupermarketOrderDetailService.GetDataByOrderId(orderId);
                foreach (DataRow data in shoppingCarDataTable.Rows)
                {
                    sum += double.Parse(data["Price"].ToString()) * double.Parse(data["Total"].ToString());
                }

                //获取收货地址
                ViewData["hotelName"] = DishOrderLogic.GetHotelName(orderData["HotelId"].ToString());
                ViewData["ExpressFee"] = 0;
                TimeSpan ts = new TimeSpan();    //用于计算是否可延迟收货
                if (!string.IsNullOrWhiteSpace(orderData["AddressType"].ToString()))
                {
                    if (orderData["AddressType"].ToString() == "1")
                    {
                        ViewData["addressType"] = "酒店";
                        ts = DateTime.Now - DateTime.Parse(orderData["CreateTime"].ToString()).AddDays(4);
                    }
                    else
                    {
                        ViewData["addressType"] = "快递";
                        ts = DateTime.Now - DateTime.Parse(orderData["CreateTime"].ToString()).AddDays(12);
                        sum += double.Parse(orderData["ExpressFee"].ToString());
                    }
                    ViewData["addressName"] = orderData["Address"].ToString();
                }
                else
                {
                    ViewData["Address"] = new OrderAddress();
                    ViewData["addressType"] = "酒店";
                    ViewData["addressName"] = ViewData["hotelName"];
                }
                ViewData["Linkman"] = orderData["Linkman"].ToString();
                ViewData["LinkPhone"] = orderData["LinkPhone"].ToString();

                ViewData["isAllowDelayed"] = false;
                ViewData["isShowAllowDelayed"] = true;
                ViewData["DelayedTake"] = orderData["DelayedTake"];
                if (orderData["DelayedTake"].ToString() == "0")
                {
                    ViewData["isAllowDelayed"] = ts.Days >= 0 ? true : false;
                }
                else
                {
                    ViewData["isShowAllowDelayed"] = false;
                }


                //获取快递信息
                Express express = GetExpressData(orderData["ExpressNo"].ToString());
                try
                {
                    ViewData["express"] = express.data[0];
                }
                catch (Exception e)
                {
                    ViewData["express"] = new ExpressData();
                }

                try
                {
                    var hotelData = GetHotelBySupermarket(int.Parse(id)).Rows[0];
                    ViewData["hotelPhone"] = hotelData["tel"];
                }
                catch
                {
                    ViewData["hotelPhone"] = "";
                }

                //获取积分
                ViewData["orderScore"] = 0;
                ViewData["equivalence"] = 1;
                ViewData["GradePlus"] = 1;
                MemberInfo Info = MemberHelper.GetMemberInfo(weixinid);
                string cardno = MemberHelper.GetCardNo(userweixinid, weixinid);
                if (!string.IsNullOrEmpty(cardno))
                {
                    MemberCard MyCard = MemberHelper.GetMemberCard(cardno, weixinid);
                    MemberCardIntegralRule IntegralRule = MemberHelper.IntegralRule(Info, MyCard);
                    var score = sum;
                    if (IntegralRule.equivalence > 0)
                    {
                        score = score * IntegralRule.equivalence;
                        ViewData["equivalence"] = IntegralRule.equivalence;
                    }
                    if ((double)IntegralRule.GradePlus > 0)
                    {
                        score = score * (double)IntegralRule.GradePlus;
                        ViewData["GradePlus"] = IntegralRule.GradePlus;
                    }

                    ViewData["orderScore"] = Math.Floor(Math.Round(score, 2)); ;
                }
                var dbLog = orderService.GetOrderLogDataByOrderId(orderId);
                ViewData["list_ordersLog"] = dbLog;
                ViewData["PayStatus"] = orderData["PayStatus"];

                ViewData["shoppingCarDataTable"] = shoppingCarDataTable;
                ViewData["amount"] = orderData["Money"];
                ViewData["ExpressCompany"] = orderData["ExpressCompany"];
                ViewData["ExpressNo"] = orderData["ExpressNo"];
                ViewData["hotelId"] = orderData["HotelId"].ToString();
                ViewData["ExpressFee"] = orderData["ExpressFee"];
                ViewData["remark"] = orderData["Remark"].ToString();
                ViewData["OrderStatus"] = orderData["OrderStatus"].ToString();
                ViewData["CreateTime"] = orderData["CreateTime"];
                ViewData["CanPurchase"] = orderData["CanPurchase"];
                ViewData["PurchasePoints"] = orderData["PurchasePoints"];
                ViewData["PayMethod"] = orderData["PayMethod"];
                ViewData["CouponId"] = orderData["CouponId"];
                ViewData["CouponMoney"] = orderData["CouponMoney"];
                ViewData["weixinid"] = weixinid;
                ViewData["userweixinid"] = userweixinid;
                ViewData["orderId"] = orderId;
            }
            catch (Exception e) { }
            return View();
        }

        /// <summary>
        /// 编辑收货地址
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult EditAddress(string id)
        {
            string hotelId = id.ToString();
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string storeId = HotelCloud.Common.HCRequest.GetString("storeId");
            string isComeTravel = HotelCloud.Common.HCRequest.GetString("isComeTravel");//是否旅行社进入
            string userweixinid = "";
            if (key.Contains('@'))
            {
                userweixinid = key.Split('@')[1];
            }

            ViewData["isComeTravel"] = isComeTravel;

            //获取会员手机号
            //string mobile = DishOrderLogic.GetMemberPhone(userweixinid);
            //ViewData["MemberMobile"] = string.IsNullOrEmpty(mobile) ? "" : "@"+mobile;

            List<OrderAddress> list = DishOrderLogic.GetAddressList(userweixinid);
            OrderAddress address = list.Find(a => a.isSelected == true); //DishOrderLogic.GetAddress(userweixinid);
            ViewData["list"] = list;

            ViewData["Address"] = address == null ? new OrderAddress() : address;
            if (address != null)
            {
                ViewData["hotelName"] = string.IsNullOrEmpty(address.Address) ? DishOrderLogic.GetHotelName(hotelId) : address.Address;//没有默认地址显示酒店名称
            }
            else
            {
                ViewData["hotelName"] = DishOrderLogic.GetHotelName(hotelId);
            }

            ViewData["hId"] = hotelId;
            ViewData["orderCode"] = orderCode;
            ViewData["key"] = key;
            ViewData["storeId"] = storeId;
            ViewData["userweixinid"] = userweixinid;

            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
            }
            ViewData["hotelId"] = id;
            ViewData["weixinid"] = weixinid;
            return View();
        }

        /// <summary>
        /// 编辑收货地址
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult EditAddress2(string id)
        {
            string hotelId = id.ToString();
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string storeId = HotelCloud.Common.HCRequest.GetString("storeId");
            string userweixinid = "";
            if (key.Contains('@'))
            {
                userweixinid = key.Split('@')[1];
            }

            //获取会员手机号
            //string mobile = DishOrderLogic.GetMemberPhone(userweixinid);
            //ViewData["MemberMobile"] = string.IsNullOrEmpty(mobile) ? "" : "@"+mobile;

            List<OrderAddress> list = DishOrderLogic.GetAddressList(userweixinid);
            OrderAddress address = list.Find(a => a.isSelected == true); //DishOrderLogic.GetAddress(userweixinid);
            ViewData["list"] = list;

            ViewData["Address"] = address == null ? new OrderAddress() : address;
            if (address != null)
            {
                ViewData["hotelName"] = string.IsNullOrEmpty(address.Address) ? DishOrderLogic.GetHotelName(hotelId) : address.Address;//没有默认地址显示酒店名称
            }
            else
            {
                ViewData["hotelName"] = DishOrderLogic.GetHotelName(hotelId);
            }

            ViewData["hId"] = hotelId;
            ViewData["orderCode"] = orderCode;
            ViewData["key"] = key;
            ViewData["storeId"] = storeId;
            ViewData["userweixinid"] = userweixinid;

            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
            }
            ViewData["hotelId"] = id;
            ViewData["weixinid"] = weixinid;
            return View();
        }

        // GET: /Supermarket/OrderRemark
        /// <summary>
        /// 订单备注
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult OrderRemark(string id)
        {
            string hotelId = id;
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }

            ViewData["hotelId"] = id;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            return View();
        }

        // GET: /Supermarket/OrderRemark2
        [Models.Filter]
        public ActionResult OrderRemark2(string id)
        {
            string hotelId = id;
            string orderId = HotelCloud.Common.HCRequest.GetString("orderid");
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }
            ViewData["hotelId"] = "";
            ViewData["remark"] = "";
            ViewData["orderId"] = orderId;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            try
            {
                var orderData = orderService.GetDataByOrderId(orderId).Rows[0];

                ViewData["hotelId"] = orderData["HotelId"].ToString();
                ViewData["remark"] = orderData["Remark"].ToString();
                ViewData["orderId"] = orderId;
                ViewData["weixinid"] = weixinid;
                ViewData["userweixinid"] = userweixinid;
            }
            catch (Exception e) { }
            return View();
        }

        // GET: /Supermarket/OrderPay
        [Models.Filter]
        public ActionResult OrderPay(string id)
        {
            string hotelId = id;
            string orderId = HotelCloud.Common.HCRequest.GetString("orderid");
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }

            ViewData["PayStatus"] = "";
            ViewData["Money"] = 0;
            ViewData["PayMethod"] = "";
            ViewData["Linkman"] = "";
            ViewData["OrderStatus"] = "0";
            ViewData["LinkPhone"] = "";
            ViewData["Address"] = "";
            ViewData["CreateTime"] = "";
            ViewData["HotelId"] = "";
            ViewData["hotelPhone"] = "";
            ViewData["CreateTime"] = new DateTime();

            ViewData["orderId"] = orderId;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;

            //获取订单信息
            var shoppingCarDataTable = orderService.GetDataByOrderId(orderId);
            try
            {
                var orderData = orderService.GetDataByOrderId(orderId).Rows[0];
                ViewData["CanPurchase"] = orderData["CanPurchase"];
                ViewData["PurchasePoints"] = orderData["PurchasePoints"];

                foreach (DataRow data in shoppingCarDataTable.Rows)
                {
                    ViewData["Money"] = data["Money"];
                    ViewData["PayMethod"] = data["PayMethod"];
                    if (data["PayStatus"].ToString() == "1")
                    {
                        ViewData["PayStatus"] = "待支付";
                    }
                    else if (data["PayStatus"].ToString() == "2")
                    {
                        ViewData["PayStatus"] = "支付完成";
                    }
                    else if (data["PayStatus"].ToString() == "3")
                    {
                        ViewData["PayStatus"] = "部分退款";
                    }
                    else if (data["PayStatus"].ToString() == "4")
                    {
                        ViewData["PayStatus"] = "全额退款";
                    }
                    ViewData["Linkman"] = data["Linkman"];
                    ViewData["OrderStatus"] = data["OrderStatus"];
                    ViewData["LinkPhone"] = data["LinkPhone"];
                    ViewData["Address"] = data["Address"];
                    ViewData["CreateTime"] = data["CreateTime"];
                    ViewData["HotelId"] = data["HotelId"];
                }
                try
                {
                    var hotelData = GetHotelBySupermarket(int.Parse(id)).Rows[0];
                    ViewData["hotelPhone"] = hotelData["tel"];
                }
                catch
                {
                    ViewData["hotelPhone"] = "";
                }
            }
            catch (Exception e) { }
            return View();
        }

        // GET: /Supermarket/PayFail
        [Models.Filter]
        public ActionResult PayFail(string id)
        {
            string hotelId = id;
            string orderId = HotelCloud.Common.HCRequest.GetString("orderid");
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }

            ViewData["HotelId"] = hotelId;
            ViewData["orderId"] = orderId;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            return View();
        }

        // GET: /Supermarket/Logistics
        [Models.Filter]
        public ActionResult Logistics(string id)
        {
            string hotelId = id;
            string orderId = HotelCloud.Common.HCRequest.GetString("orderid");
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }

            var orderData = orderService.GetDataByOrderId(orderId).Rows[0];
            //获取快递信息
            Express express = GetExpressData(orderData["ExpressNo"].ToString());
            ViewData["expressCompany"] = orderData["ExpressCompany"];
            ViewData["expressOrder"] = orderData["ExpressNo"];
            ViewData["express"] = express;

            var dtCommodity = SupermarketOrderDetailService.GetDataByOrderId(orderId).Rows;
            //ViewData["imagePath"] = dtCommodity[0]["ImagePath"];
            ViewData["imagePath"] = dtCommodity[0]["ImageList"].ToString().Split(',')[0];
            ViewData["CommodityCount"] = dtCommodity.Count;

            ViewData["isAllowDelayed"] = false;     //订单是否可以延迟付款
            ViewData["isShowAllowDelayed"] = true;  //是否已延迟付款
            if (orderData["DelayedTake"].ToString() == "0")
            {
                int days = 0;
                if (orderData["AddressType"].ToString() == "1")
                {
                    days = 4;
                }
                else
                {
                    days = 12;
                }
                TimeSpan ts = DateTime.Now - DateTime.Parse(orderData["CreateTime"].ToString()).AddDays(days);
                ViewData["isAllowDelayed"] = ts.Days >= 0 ? true : false;
            }
            else
            {
                ViewData["isShowAllowDelayed"] = false;
            }

            ViewData["hotelId"] = orderData["HotelId"].ToString();
            ViewData["OrderStatus"] = orderData["OrderStatus"].ToString();
            ViewData["orderId"] = orderId;
            ViewData["weixinid"] = weixinid;
            ViewData["userweixinid"] = userweixinid;
            return View();
        }

        /// <summary>
        /// 根据快递号获取快递信息
        /// </summary>
        /// <param name="expressId"></param>
        /// <returns></returns>
        [Models.Filter]
        public Express GetExpressData(string expressId)
        {
            try
            {
                string expressOrder = expressId;
                string expressCompanyjson = HttpGet("http://www.kuaidi100.com/autonumber/autoComNum?text=" + expressOrder, "");

                expressCompany expressCompany = JsonConvert.DeserializeObject<expressCompany>(expressCompanyjson);

                string json = HttpGet("http://www.kuaidi100.com/query?type=" + expressCompany.auto[0].comCode + "&postid=" + expressOrder + "&id=1&valicode=&temp=0.9987696469455938", "");

                Express express = JsonConvert.DeserializeObject<Express>(json);
                return express;
            }
            catch (Exception e)
            {
                return new Express();
            }
        }

        /// <summary>
        /// 新增商品到购物车
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult AddCommodityToShoppingCart(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinID = HotelCloud.Common.HCRequest.GetString("userweixinID");
            string CommodityId = HotelCloud.Common.HCRequest.GetString("CommodityId");

            int resultRows = cartService.AddCommdity(weixinID, userweixinID, id, CommodityId, 1);

            return Json(new
            {
                error = resultRows > 0 ? 1 : 0,
                //message = "数据操作错误，请联系管理人员"
                message = "添加失败"
            });
        }

        /// <summary>
        /// 从购物车减少商品
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult ReduceCommodityToShoppingCart(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinID = HotelCloud.Common.HCRequest.GetString("userweixinID");
            string CommodityId = HotelCloud.Common.HCRequest.GetString("CommodityId");

            int resultRows = cartService.ReduceCommdity(weixinID, userweixinID, id, CommodityId);

            return Json(new
            {
                error = resultRows > 0 ? 1 : 0,
                //message = "数据操作错误，请联系管理人员"
                message = "操作过快"
            });
        }

        /// <summary>
        /// 从购物车清空商品
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult ClearCommodityToShoppingCart(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinID = HotelCloud.Common.HCRequest.GetString("userweixinID");

            int resultRows = cartService.ClearCommdity(weixinID, userweixinID, id);

            return Json(new
            {
                error = resultRows > 0 ? 1 : 0,
                //message = "数据操作错误，请联系管理人员"
                message = "清空失败"
            });
        }

        /// <summary>
        /// 把商品批量添加到购物车
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult AddShoppingCart(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinid = HotelCloud.Common.HCRequest.GetString("userweixinID");
            string shoppingCart = HotelCloud.Common.HCRequest.GetString("shoppingCart");

            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }

            JavaScriptSerializer Serializer = new JavaScriptSerializer();
            Dictionary<string, int> dic = Serializer.Deserialize<Dictionary<string, int>>(shoppingCart);

            cartService.ClearCommdity(weixinid, userweixinid, id);
            int resultRows = 0;
            foreach (var data in dic)
            {
                if (data.Value > 0)
                    resultRows += cartService.AddCommdity(weixinid, userweixinid, id, data.Key, data.Value);
            }

            //int resultRows = cartService.AddCommdity(weixinID, userweixinID, id, CommodityId);

            return Json(new
            {
                error = resultRows > 0 ? 1 : 0,
                //message = "数据操作错误，请联系管理人员"
                message = "商品过期，请刷新页面重试"
            });
        }

        /// <summary>
        /// 获取商品信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult GetCommodityInfo(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinid = HotelCloud.Common.HCRequest.GetString("userweixinID");
            string SupermarketSearch = HotelCloud.Common.HCRequest.GetString("SupermarketSearch");
            string type = HotelCloud.Common.HCRequest.GetString("type");
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }
            DataTable commodityDataTable = CommodityService.GetDataByUserId(weixinid, id, userweixinid);
            List<DataRow> rows = commodityDataTable.AsEnumerable().ToList();
            if (!string.IsNullOrWhiteSpace(SupermarketSearch))
                rows = rows.Where(r => WeiXinPublic.ConvertHelper.ToString(r["Name"]).Contains(SupermarketSearch)).ToList();
            DataTable dt2 = commodityDataTable.Clone();
            if (!string.IsNullOrWhiteSpace(type))
            {
                string[] typeArr = type.Substring(0, type.Length - 1).Split(',');
                foreach (string t in typeArr)
                {
                    if (t != "")
                    {
                        var rowsClone = rows;
                        rowsClone = rowsClone.Where(r => (t == (r["CommodityType"].ToString()) || t == (r["Subitem"].ToString())) && r["CommodityType"].ToString() != "").ToList();

                        foreach (var dr in rowsClone)
                            dt2.ImportRow(dr);
                    }
                }
                //rows = rows.Where(r => WeiXinPublic.ConvertHelper.ToString(r["CommodityType"]).Contains(type) || WeiXinPublic.ConvertHelper.ToString(r["Subitem"]).Contains(type)).ToList();
                //rows = rows.Where(r => (type.Contains(r["CommodityType"].ToString()) || type.Contains(r["Subitem"].ToString())) && r["CommodityType"].ToString() != "").ToList();
            }
            else
            {
                foreach (var dr in rows)
                    dt2.ImportRow(dr);
            }
            return Json(new
            {
                data = SerializeDataTable(dt2),
                data2 = SerializeDataTable(commodityDataTable)
            }, JsonRequestBehavior.AllowGet);

        }


        public ActionResult GetShoppingCart(string id)
        { //GetData

            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinid = HotelCloud.Common.HCRequest.GetString("userweixinID");
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }
            DataTable commodityDataTable = ShoppingCartService.GetData(id, userweixinid);
            return Json(new
            {
                data = commodityDataTable.Rows.Count,
            });
        }

        /// <summary>
        /// 创建订单
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult CreateOrder(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinID = HotelCloud.Common.HCRequest.GetString("userweixinID");
            string remark = HotelCloud.Common.HCRequest.GetString("remark");
            string LinkMan = HotelCloud.Common.HCRequest.GetString("LinkMan");
            string LinkPhone = HotelCloud.Common.HCRequest.GetString("LinkPhone");
            string Address = HotelCloud.Common.HCRequest.GetString("Address");
            string AddressType = HotelCloud.Common.HCRequest.GetString("AddressType");
            string ExpressFee = HotelCloud.Common.HCRequest.GetString("ExpressFee");
            string useScorePay = HotelCloud.Common.HCRequest.GetString("useScorePay");
            string CouponId = HotelCloud.Common.HCRequest.GetString("CouponId");
            string CouponMoney = HotelCloud.Common.HCRequest.GetString("CouponMoney");
            //string CanPurchase = HotelCloud.Common.HCRequest.GetString("CanPurchase");
            //string PurchasePoints = HotelCloud.Common.HCRequest.GetString("PurchasePoints");
            string orderId = "";


            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    //检查红包是否可用
                    if (!string.IsNullOrWhiteSpace(CouponId))
                    {
                        bool couponCanUse = WeiXin.Models.Home.CouPonContent.IsCouPonContentEnable(weixinID, userweixinID, int.Parse(CouponId));
                        if (!couponCanUse)
                        {
                            throw new Exception();
                        }
                    }

                    //创建订单
                    orderId = orderService.InsertOrder(weixinID, userweixinID, id, remark, LinkMan, LinkPhone, AddressType, Address, ExpressFee, CouponId, CouponMoney);
                    if (!string.IsNullOrWhiteSpace(orderId))
                    {
                        orderService.InsertOrderLog(orderId, "创建订单", 1, "系统");
                    }
                    else
                    {
                        throw new Exception();
                    }

                    if (useScorePay == "1")
                    {
                        //获取用户积分
                        var myPoints = 0;
                        var userDt = orderService.GetScoreByUser(weixinID, userweixinID);
                        if (userDt.Rows.Count > 0)
                        {
                            myPoints = int.Parse(userDt.Rows[0]["Emoney"].ToString());
                        }
                        var shoppingCarDataTable = cartService.GetDataByUserId(id, userweixinID);
                        //获取订单所需积分
                        int needPoints = 0;
                        foreach (DataRow data in shoppingCarDataTable.Rows)
                        {
                            needPoints += int.Parse(data["PurchasePoints"].ToString()) * int.Parse(data["Total"].ToString());
                        }
                        if (myPoints - needPoints < 0 || shoppingCarDataTable.Rows.Count == 0)
                        {
                            return Json(new
                            {
                                orderId = orderId,
                                error = 2,
                                message = "无法使用积分支付，请使用其他支付方式"
                            });
                        }
                        //用户扣除积分支付订单
                        int result2 = orderService.DeductionPoints(weixinID, userweixinID, needPoints);
                        int result1 = orderService.CreateUseScoreLog(weixinID, userweixinID, orderId);
                        int result = orderService.PayOrder(orderId, "积分支付");
                        if (result2 == 0 || result1 == 0 || result == 0)
                            return Json(new
                            {
                                orderId = orderId,
                                error = 2,
                                message = "无法使用积分支付，请使用其他支付方式"
                            });
                    }

                    cartService.ClearCommdity(weixinID, userweixinID, id);
                    ts.Complete();
                }
                catch (Exception e)
                {

                    TravelAgencyCommon.AddLog("1", e.Message.ToString(), "/Log/MyLoggerPayAPI");
                    TravelAgencyCommon.AddLog("1", e.StackTrace.ToString(), "/Log/MyLoggerPayAPI");
                    //ts.Dispose();
                    return Json(new
                    {
                        orderId = "",
                        error = 1,
                        message = "订单创建失败，请重新选购商品"
                    });
                }
            }

            return Json(new
            {
                orderId = orderId,
                error = 0,
                message = "创建成功"
            });

            //orderId = orderService.InsertOrder(weixinID, userweixinID, id, remark, LinkMan, LinkPhone, AddressType, Address, ExpressFee);
            //if (!string.IsNullOrWhiteSpace(orderId))
            //    orderService.InsertOrderLog(orderId,"创建订单",1,"系统");
            //return Json(new
            //{
            //    orderId = orderId,
            //    message = "数据操作错误，请联系管理人员"
            //});
        }

        /// <summary>
        /// 创建商品详细订单
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult CreateOrderAlone(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinID = HotelCloud.Common.HCRequest.GetString("userweixinID");
            string remark = HotelCloud.Common.HCRequest.GetString("remark");
            string LinkMan = HotelCloud.Common.HCRequest.GetString("LinkMan");
            string LinkPhone = HotelCloud.Common.HCRequest.GetString("LinkPhone");
            string Address = HotelCloud.Common.HCRequest.GetString("Address");
            string AddressType = HotelCloud.Common.HCRequest.GetString("AddressType");
            string ExpressFee = HotelCloud.Common.HCRequest.GetString("ExpressFee");
            string useScorePay = HotelCloud.Common.HCRequest.GetString("useScorePay");
            string commodityId = HotelCloud.Common.HCRequest.GetString("commodityId");
            string commodityNum = HotelCloud.Common.HCRequest.GetString("commodityNum");
            string CouponId = HotelCloud.Common.HCRequest.GetString("CouponId");
            string CouponMoney = HotelCloud.Common.HCRequest.GetString("CouponMoney");
            //string CanPurchase = HotelCloud.Common.HCRequest.GetString("CanPurchase");
            //string PurchasePoints = HotelCloud.Common.HCRequest.GetString("PurchasePoints");
            string orderId = "";
            string OrderSource = "微官网";
            if (!string.IsNullOrWhiteSpace(HotelCloud.Common.HCRequest.GetString("OrderSource")))
            {
                OrderSource = HotelCloud.Common.HCRequest.GetString("OrderSource");
            }

            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    //检查红包是否可用
                    if (!string.IsNullOrWhiteSpace(CouponId))
                    {
                        bool couponCanUse = WeiXin.Models.Home.CouPonContent.IsCouPonContentEnable(weixinID, userweixinID, int.Parse(CouponId));
                        if (!couponCanUse)
                        {
                            throw new Exception();
                        }
                    }
                    //创建订单
                    orderId = orderService.InsertOrderAlone(weixinID, userweixinID, id, remark, LinkMan, LinkPhone, AddressType, Address, ExpressFee, CouponId, CouponMoney, commodityId, commodityNum, OrderSource);
                    if (!string.IsNullOrWhiteSpace(orderId))
                    {
                        orderService.InsertOrderLog(orderId, "创建订单", 1, "系统");
                    }
                    else
                    {
                        throw new Exception();
                    }

                    if (useScorePay == "1")
                    {
                        //获取用户积分
                        var myPoints = 0;
                        var userDt = orderService.GetScoreByUser(weixinID, userweixinID);
                        if (userDt.Rows.Count > 0)
                        {
                            myPoints = int.Parse(userDt.Rows[0]["Emoney"].ToString());
                        }
                        //var shoppingCarDataTable = cartService.GetDataByUserId(id, userweixinID);
                        var shoppingCarDataTable = SupermarketOrderDetailService.GetDataByOrderId(orderId);
                        //获取订单所需积分
                        int needPoints = 0;
                        foreach (DataRow data in shoppingCarDataTable.Rows)
                        {
                            needPoints += int.Parse(data["PurchasePoints"].ToString()) * int.Parse(data["Total"].ToString());
                        }
                        if (myPoints - needPoints < 0 || shoppingCarDataTable.Rows.Count == 0)
                        {
                            return Json(new
                            {
                                orderId = orderId,
                                error = 2,
                                message = "无法使用积分支付，请使用其他支付方式"
                            });
                        }
                        //用户扣除积分支付订单
                        int result2 = orderService.DeductionPoints(weixinID, userweixinID, needPoints);
                        int result1 = orderService.CreateUseScoreLog(weixinID, userweixinID, orderId);
                        int result = orderService.PayOrder(orderId, "积分支付");
                        if (result2 == 0 || result1 == 0 || result == 0)
                            return Json(new
                            {
                                orderId = orderId,
                                error = 2,
                                message = "无法使用积分支付，请使用其他支付方式"
                            });
                    }

                    ts.Complete();
                }
                catch (Exception e)
                {
                    TravelAgencyCommon.AddLog("1", e.Message.ToString(), "/Log/MyLoggerPayAPI");
                    TravelAgencyCommon.AddLog("1", e.StackTrace.ToString(), "/Log/MyLoggerPayAPI");
                    //ts.Dispose();
                    return Json(new
                    {
                        orderId = "",
                        error = 1,
                        message = "订单创建失败，请重新选购商品"
                    });
                }
            }

            return Json(new
            {
                orderId = orderId,
                error = 0,
                message = "创建成功"
            });

            //orderId = orderService.InsertOrder(weixinID, userweixinID, id, remark, LinkMan, LinkPhone, AddressType, Address, ExpressFee);
            //if (!string.IsNullOrWhiteSpace(orderId))
            //    orderService.InsertOrderLog(orderId,"创建订单",1,"系统");
            //return Json(new
            //{
            //    orderId = orderId,
            //    message = "数据操作错误，请联系管理人员"
            //});
        }


        public string CreateOrderAloneAPI(string hotelId, string weixinID, string userweixinID, string remark, string LinkMan, string LinkPhone, string Address, string AddressType, string ExpressFee, string useScorePay, string commodityId, string commodityNum, string CouponId, string CouponMoney, string OrderSource)
        {
            string orderId = "";
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    //检查红包是否可用
                    if (!string.IsNullOrWhiteSpace(CouponId))
                    {
                        bool couponCanUse = WeiXin.Models.Home.CouPonContent.IsCouPonContentEnable(weixinID, userweixinID, int.Parse(CouponId.Trim()));
                        if (!couponCanUse)
                        {
                            throw new Exception();
                        }
                    }
                    //创建订单
                    orderId = orderService.InsertOrderAlone(weixinID, userweixinID, hotelId, remark, LinkMan, LinkPhone, AddressType, Address, ExpressFee, CouponId, CouponMoney, commodityId, commodityNum, OrderSource);
                    if (!string.IsNullOrWhiteSpace(orderId))
                    {
                        orderService.InsertOrderLog(orderId, "创建订单", 1, "系统");
                    }
                    else
                    {
                        throw new Exception();
                    }

                    if (useScorePay == "1")
                    {
                        //获取用户积分
                        var myPoints = 0;
                        var userDt = orderService.GetScoreByUser(weixinID, userweixinID);
                        if (userDt.Rows.Count > 0)
                        {
                            myPoints = int.Parse(userDt.Rows[0]["Emoney"].ToString().Trim());
                        }
                        //var shoppingCarDataTable = cartService.GetDataByUserId(id, userweixinID);
                        var shoppingCarDataTable = SupermarketOrderDetailService.GetDataByOrderId(orderId);
                        //获取订单所需积分
                        int needPoints = 0;
                        foreach (DataRow data in shoppingCarDataTable.Rows)
                        {
                            needPoints += int.Parse(data["PurchasePoints"].ToString().Trim()) * int.Parse(data["Total"].ToString().Trim());
                        }
                        if (myPoints - needPoints < 0 || shoppingCarDataTable.Rows.Count == 0)
                        {
                            return orderId;
                        }
                        //用户扣除积分支付订单
                        int result2 = orderService.DeductionPoints(weixinID, userweixinID, needPoints);
                        int result1 = orderService.CreateUseScoreLog(weixinID, userweixinID, orderId);
                        int result = orderService.PayOrder(orderId, "积分支付");
                        if (result2 == 0 || result1 == 0 || result == 0)
                            return orderId;
                    }

                    ts.Complete();
                }
                catch (Exception e)
                {
                    TravelAgencyCommon.AddLog("1", e.Message.ToString(), "/Log/MyLoggerPayAPI");
                    TravelAgencyCommon.AddLog("1", e.StackTrace.ToString(), "/Log/MyLoggerPayAPI");
                    TravelAgencyCommon.AddLog("1", e.Data.ToString(), "/Log/MyLoggerPayAPI");
                    TravelAgencyCommon.AddLog("1", e.Source.ToString(), "/Log/MyLoggerPayAPI");
                    TravelAgencyCommon.AddLog("1", e.TargetSite.ToString(), "/Log/MyLoggerPayAPI");
                    //ts.Dispose();

                    return "";
                }
            }

            return orderId;

        }

        /// <summary>
        /// 清理购物车
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult ClearShoppingCart(string id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinID = HotelCloud.Common.HCRequest.GetString("userweixinID");
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinID = key.Split('@')[0];//酒店微信id
                userweixinID = key.Split('@')[1];
            }
            var dt = orderService.ClearShoppingCart(weixinID, userweixinID);

            string msg = "订单创建失败，请重新选购 ";
            foreach (DataRow data in dt.Rows)
            {
                msg = msg + data["Name"].ToString() + ",";
            }
            msg = msg.Substring(0, msg.Length - 1);
            return Json(new
            {
                error = dt.Rows.Count > 0 ? 1 : 0,
                message = msg
            });
        }

        /// <summary>
        /// 取消订单
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult CancelOrder(string orderId, string createUser)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
            string userweixinID = HotelCloud.Common.HCRequest.GetString("userweixinID");
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinID = key.Split('@')[0];//酒店微信id
                userweixinID = key.Split('@')[1];
            }
            int resultRows = CancelOrderDo(orderId, createUser, weixinID, userweixinID);
            //using (TransactionScope ts = new TransactionScope())
            //{
            //    try
            //    {
            //        resultRows = orderService.CancelOrder(orderId);
            //        //返回库存
            //        var shoppingCarDataTable = SupermarketOrderDetailService.GetDataByOrderId(orderId);
            //        foreach (DataRow data in shoppingCarDataTable.Rows)
            //        {
            //            orderService.ReturnCommodity(data["CommodityId"].ToString(), int.Parse(data["Total"].ToString()));
            //        }

            //        if (resultRows > 0)
            //            orderService.InsertOrderLog(orderId, "订单状态流转为:订单取消", 1, createUser);
            //        ts.Complete();
            //    }
            //    catch (Exception e)
            //    {
            //        ts.Dispose();
            //    }
            //}
            return Json(new
            {
                error = resultRows > 0 ? 1 : 0,
                message = "订单取消失败，请刷新页面重试"
            });
        }

        public int CancelOrderDo(string orderId, string createUser, string hotelWeixinNo, string userWeixinNo)
        {
            int resultRows = 0;
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    orderService.RollCoupon(orderId, hotelWeixinNo, userWeixinNo);
                    resultRows = orderService.CancelOrder(orderId);
                    //返回库存
                    var shoppingCarDataTable = SupermarketOrderDetailService.GetDataByOrderId(orderId);
                    foreach (DataRow data in shoppingCarDataTable.Rows)
                    {
                        orderService.ReturnCommodity(data["CommodityId"].ToString(), int.Parse(data["Total"].ToString()));
                    }

                    if (resultRows > 0)
                        orderService.InsertOrderLog(orderId, "订单状态流转为:订单取消", 1, createUser);
                    ts.Complete();
                }
                catch (Exception e)
                {
                    ts.Dispose();
                }
            }
            return resultRows;
        }

        /// <summary>
        /// 延迟订单
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult DelayedOrder(string orderid)
        {
            int resultRows = orderService.DelayedOrder(orderid);

            return Json(new
            {
                error = resultRows > 0 ? 1 : 0,
                message = "延迟失败，请刷新页面重试"
            });
        }

        /// <summary>
        /// 确认收货，订单完结
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [Models.Filter]
        public ActionResult FinishOrder(string orderid)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }


            //using (TransactionScope ts = new TransactionScope())
            //{
            //    try
            //    {
            //        var orderData = orderService.GetDataByOrderId(orderid).Rows[0];
            //        int resultRows = orderService.FinishOrder(orderid);
            //        int resultRows2 = 0;

            //        if (resultRows > 0)
            //            orderService.InsertOrderLog(orderid, "订单状态流转为:交易成功", 1, "系统");

            //        if (orderData["PayMethod"].ToString() != "积分支付")
            //            resultRows2 = orderService.CreateScore(weixinid, userweixinid, orderid);

            //        ts.Complete();
            //        return Json(new
            //        {
            //            error = resultRows > 0 ? 1 : 0,
            //            message = "无法确认收货，请刷新页面重试"
            //        });
            //    }
            //    catch (Exception e)
            //    {
            //        ts.Dispose();
            //    }
            //}
            int result = FinishOrderDo(weixinid, userweixinid, orderid);
            if (result > 0)
            {

                return Json(new
                {
                    error = 1,
                    message = "无法确认收货，请刷新页面重试"
                });
            }
            else
            {

                return Json(new
                {
                    error = 0,
                    message = "无法确认收货，请刷新页面重试"
                });
            }
        }

        public int FinishOrderDo(string weixinid, string userweixinid, string orderid)
        {

            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    var orderData = orderService.GetDataByOrderId(orderid).Rows[0];
                    int resultRows = orderService.FinishOrder(orderid);
                    int resultRows2 = 0;

                    if (resultRows > 0)
                        orderService.InsertOrderLog(orderid, "订单状态流转为:交易成功", 1, "系统");

                    if (orderData["PayMethod"].ToString() != "积分支付")
                        resultRows2 = orderService.CreateScore(weixinid, userweixinid, orderid);

                    ts.Complete();
                    return resultRows;
                }
                catch (Exception e)
                {
                    ts.Dispose();
                }
            }
            return 0;
        }

        /// <summary>
        /// 获取酒店的设施服务
        /// </summary>
        /// <param name="hotelId"></param>
        /// <returns></returns>
        [Models.Filter]
        public static DataTable GetHotelBySupermarket(int hotelId)
        {
            string sql = "select id,WeiXinID,SubName,address,fuwu,canyin,yule,kefang,expressfee,tel from hotel where id=@hotelId";
            return HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            { "hotelId", new HotelCloud.SqlServer.DBParam { ParamValue = hotelId.ToString() } } 
            });
        }

        /// <summary>  
        /// GET请求与获取结果  
        /// </summary>  
        public static string HttpGet(string Url, string postDataStr)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(Url + (postDataStr == "" ? "" : "?") + postDataStr);
            request.Method = "GET";
            request.ContentType = "text/html;charset=UTF-8";

            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            Stream myResponseStream = response.GetResponseStream();
            StreamReader myStreamReader = new StreamReader(myResponseStream, Encoding.UTF8);
            string retString = myStreamReader.ReadToEnd();
            myStreamReader.Close();
            myResponseStream.Close();

            return retString;
        }
        /// <summary>DataTable序列化

        /// </summary>

        /// <param name="dt"></param>

        /// <returns></returns>

        public string SerializeDataTable(DataTable dt)
        {

            JavaScriptSerializer serializer = new JavaScriptSerializer();

            List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();

            foreach (DataRow dr in dt.Rows)//每一行信息，新建一个Dictionary<string,object>,将该行的每列信息加入到字典
            {

                Dictionary<string, object> result = new Dictionary<string, object>();

                foreach (DataColumn dc in dt.Columns)
                {

                    result.Add(dc.ColumnName, dr[dc].ToString());

                }

                list.Add(result);

            }

            return serializer.Serialize(list);//调用Serializer方法 

        }
    }

    public class Express
    {
        public string message { get; set; }
        public string nu { get; set; }
        public string ischeck { get; set; }
        public string condition { get; set; }
        public string com { get; set; }
        public string status { get; set; }
        public string state { get; set; }
        public List<ExpressData> data { get; set; }
    }
    public class ExpressData
    {
        public string time { get; set; }
        public string ftime { get; set; }
        public string context { get; set; }
        public string location { get; set; }
    }
    public class expressCompany
    {
        public string comCode { get; set; }
        public string num { get; set; }
        public List<expressCompanyData> auto { get; set; }
    }
    public class expressCompanyData
    {
        public string comCode { get; set; }
        public string id { get; set; }
        public string noCount { get; set; }
        public string noPre { get; set; }
        public string startTime { get; set; }
    }
}
