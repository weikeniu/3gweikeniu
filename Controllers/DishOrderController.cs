using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using hotel3g.Models;
using System.Data;
using HotelCloud.SqlServer;
using System.Reflection;
using System.IO;
using System.Collections;
using System.Transactions;
using HotelCloud.Common;
using System.Web.Script.Serialization;

namespace hotel3g.Controllers
{
    public class DishOrderController : Controller
    {
        //订餐首页
        [Models.Filter]
        public ActionResult DishOrderIndex(string id)
        {
            string hId = id;//酒店id
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = HotelCloud.Common.HCRequest.GetString("weixinID");//酒店微信id
            string userweixinid = "";
            if (!key.Equals("")&&key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }
            DishOrderLogic.Clear2daysUnsubmitOrder(userweixinid, weixinid);
            int storeId = HotelCloud.Common.HCRequest.GetInt("storeId", 0);//餐品商家id
            StoresView defmodel = DishOrderLogic.GetHotelDefaultStore(hId);//酒店自营或默认商家
            List<StoresView> list = DishOrderLogic.GetAllDishStores(hId).ToList<StoresView>();
            list.Remove(defmodel);
            if (defmodel != null)
            {
                StoresView m = list.Find(a => a.StoreId == defmodel.StoreId);
                list.Remove(m);//移除自营/默认
                if (storeId == 0)
                {
                    storeId = defmodel.StoreId;
                }
            }
            else //无自营默认情况
            { 
                if (list.Count == 1)//周边只有一家
                {
                    storeId = list[0].StoreId;
                }
            }
           
            #region
            StoresView store=DishOrderLogic.GetStore(storeId);//周边选中商家
            ViewData["store"] = store;
            #endregion

            string hotelName = DishOrderLogic.GetHotelName(hId)+"餐饮";
            if (store != null) 
            {
                hotelName = store.storetype != 0 ? store.StoreName : hotelName;
            }
            DataTable dt_dishType = DishOrderLogic.GetDishTypeByStoreId(storeId.ToString());

            //string UnPayorderCode = DishOrderLogic.GetUnPayOrderCode(id.ToString(), storeId.ToString(), userweixinid, EnumOrderStatus.UnPay);
            //if (string.IsNullOrEmpty(UnPayorderCode))//没有检测到已经提交未支付未超时的订单,接着检查是否有未提交的订单，没有则返回一个新的编号
             if(true){
                string orderCode = DishOrderLogic.GetOrderCode(id.ToString(), storeId.ToString(), userweixinid, EnumOrderStatus.UnSubmit);
                DataTable dt_dish = DishOrderLogic.GetStoreDishByIdOrderCode(storeId.ToString(), orderCode);
                DataTable dt_storeImg = DishOrderLogic.GetStoreImgById(storeId.ToString());

                ViewData["dt_storeImg"] = DishOrderLogic.GetTopStoreImgs(storeId.ToString(), 10);
                ViewData["dt_detail"] = DishOrderLogic.LoadOrderDetails(orderCode);

                
                ViewData["list_store"] = list; 

                ViewData["dt_dishType"] = dt_dishType;
                ViewData["dt_dish"] = dt_dish;
                ViewData["dt_storeImg"] = dt_storeImg;
                ViewData["orderCode"] = orderCode;
                ViewData["hotelName"] = hotelName;
                ViewData["defmodel"] = defmodel;

                ViewData["hId"] = hId;
                ViewData["storeId"] = storeId;
                ViewData["weixinID"] = weixinid;
                ViewData["userWeiXinID"] = userweixinid;
                ViewData["key"] = key;
                return View();
            }
            else 
            {
                //http://localhost:6803/DishOrder/OrderPay/28291?key=gh_7a64caf61dff@oPfrcjkxMOvqJBC1Eq-6zMAbwVP8&orderCode=67137771_20170316_115916207
                //跳转到订单支付页面
                //string url = string.Format("/DishOrder/OrderPay/{0}?key={1}&orderCode={2}&storeId={3}", id, key, UnPayorderCode, storeId);
                //return Redirect(url);
                
                //string url = string.Format("/DishOrder/ViewOrderDetail/{0}?key={1}&orderCode={2}&storeId={3}", id, key, UnPayorderCode, storeId);
                //return Redirect(url);
            }
        }

        public ActionResult LoadDishInfo() 
        {
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            string dishId = HotelCloud.Common.HCRequest.GetString("dishId");
            Dishses dish = DishOrderLogic.GetDishsesModel(dishId);
            OrderDetails odetails = DishOrderLogic.GetOrderDetailsModel(orderCode, dishId);
            return Json(
                new
                {
                    error = dish == null ? 0 : 1,
                    message = dish == null ? "获取菜品失败！" : Newtonsoft.Json.JsonConvert.SerializeObject(dish),
                    foodNum = odetails.Number
                }
                );
        }

        #region 加菜品,加订单
        public ActionResult AddDishOrder(int id)
        {
            int resultRows = 0;
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string dishId = HotelCloud.Common.HCRequest.GetString("dishId");
            string storeId = HotelCloud.Common.HCRequest.GetString("storeId");
            string userWeiXinID = key.Contains('@') ? key.Split('@')[1] : HotelCloud.Common.HCRequest.GetString("userWeiXinID");
            string hotelWeiXinID = key.Contains('@') ? key.Split('@')[0] : "";
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            string Hot = HotelCloud.Common.HCRequest.GetString("Hot");
            DishOrderLogic.DelDishNumberIs0Details(orderCode);
            if (string.IsNullOrEmpty(orderCode))
            {
                return Json(new
                {
                    error = 0,
                    message = "订单异常！"
                });
            }
            //ISNULL([Status],0)=0 订单未提交 
            //bool HasOrder = DishOrderLogic.IsHasOrderInfo(orderCode, EnumOrderStatus.UnSubmit);
            OrderInfo order = DishOrderLogicA.GetOrderInfo_A(orderCode, false);
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    if (order.orderId == 0)//无订单
                    {
                        int rows = DishOrderLogic.InserOrder(orderCode, storeId, id.ToString(), userWeiXinID, hotelWeiXinID);
                        if (rows == 0)
                        {
                            throw (new Exception("添加订单异常"));
                        }
                        else
                        {
                            resultRows = InserDetail(orderCode, dishId, Hot, userWeiXinID, hotelWeiXinID);
                        }
                    }
                    else
                    {
                        if (order.Status == Convert.ToInt32(EnumOrderStatus.UnSubmit))
                        {
                            resultRows = InserDetail(orderCode, dishId, Hot, userWeiXinID, hotelWeiXinID);
                        }
                    }

                    ts.Complete();
                }
                catch
                {
                    resultRows = 0;
                }
            }

            ViewData["orderCode"] = orderCode;
            if (resultRows > 0)
            {
                DataTable dt_detail = DishOrderLogic.LoadOrderDetails(orderCode);
                List<OrderDetails> list = dt_detail.ToList<OrderDetails>();
                string json = Newtonsoft.Json.JsonConvert.SerializeObject(list);
                return Json(new
                {
                    error = 1,
                    message = json
                });
            }
            else
            {
                return Json(new
                {
                    error = 0,
                    message = "订单异常！请刷新后重新操作！"
                });
            }
        }

        private int InserDetail(string ordercode, string dishId, string Hot, string userweixinid, string weixinid) 
        {
            int resultRows = 0;
            Dishses model = DishOrderLogic.GetDishsesModel(dishId);
            if (model != null)
            {
                decimal discount = 0;//默认无折扣
                if (model.CanDiscount == 1) //餐品可折扣
                {
                    string MemberCardRuleJson = ActionController.getMemberCardIntegralRule(userweixinid, weixinid);
                    Hashtable MemberCardRuleJsonobj = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJson);
                    if (MemberCardRuleJsonobj["becomeMember"].ToString().ToLower() == "false")
                    {
                        hotel3g.Repository.MemberCardIntegralRule rule = Newtonsoft.Json.JsonConvert.DeserializeObject<hotel3g.Repository.MemberCardIntegralRule>(MemberCardRuleJsonobj["rule"].ToString());
                        if (rule.MealCouponType == 0 && rule.MealGradeRate > 0) //折扣
                        {
                            discount = rule.MealGradeRate;
                        }
                    }
                }
                bool hasDish = DishOrderLogic.HasDish(dishId, ordercode);
                if (!hasDish)
                {
                    resultRows = DishOrderLogic.InserOrderDetail(ordercode, model, Hot, discount);
                }
                else
                {
                    resultRows = DishOrderLogic.UpdateOrderDetail(ordercode, model.DishsesID);
                }

                //DishOrderLogic.UpdateOrderAmount(ordercode);
            }
            else //无id对应的菜品[可能pc 端删除]
            {
                resultRows = -1;
            }
            return resultRows;
        }
       
        #endregion

        #region 减菜品,清空
        public ActionResult ReduceDishOrder(int id)
        {
            string hotelId = id.ToString();
            string storeId = HotelCloud.Common.HCRequest.GetString("storeId");
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("userWeiXinID");
            string dishId = HotelCloud.Common.HCRequest.GetString("dishId");
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            if (string.IsNullOrEmpty(orderCode))
            {
                orderCode = DishOrderLogic.GetOrderCode(hotelId, storeId, userWeiXinID, EnumOrderStatus.UnSubmit);
            }
            DishOrderLogic.ReduceDish(orderCode, dishId);

            DataTable dt_detail = DishOrderLogic.LoadOrderDetails(orderCode);
            List<OrderDetails> list = dt_detail.ToList<OrderDetails>();
            string json = Newtonsoft.Json.JsonConvert.SerializeObject(list);
            return Json(new
            {
                error = list.Count > 0 ? 1 : 0,
                message = json
            });
        }

        public ActionResult ClearDish(int id)
        {
            string hotelId = id.ToString();
            string storeId = HotelCloud.Common.HCRequest.GetString("storeId");
            string userWeiXinID = HotelCloud.Common.HCRequest.GetString("userWeiXinID");
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            if (string.IsNullOrEmpty(orderCode))
            {
                orderCode = DishOrderLogic.GetOrderCode(hotelId, storeId, userWeiXinID, EnumOrderStatus.UnSubmit);
            }
            
            int rows = DishOrderLogic.ClearDish(orderCode);
            return Json(new
            {
                error = rows,
                message = rows > 0 ? "成功！" : "失败！"
            });
        }

        #endregion

        #region 单品详情【图文模式】
        //订餐详情【图文模式】
        [Models.Filter]
        public ActionResult DishDetailView_Rich(int id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string weixinid = key.Contains('@') ? key.Split('@')[0] : "";
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";
            string storeId = HotelCloud.Common.HCRequest.GetString("storeId");
            string orderCode = DishOrderLogic.GetOrderCode(id.ToString(), storeId.ToString(), userweixinid, EnumOrderStatus.UnSubmit);

            string dishId = HotelCloud.Common.HCRequest.GetString("dishId");
            Dishses model = DishOrderLogic.GetDishsesModel(dishId);
            ViewData["model"] = model == null ? new Dishses() : model;
            decimal total =model.price;
            int number = 1;

            decimal discount = 0;//默认无折扣
            if (model.CanDiscount == 1) //餐品可折扣
            {
                string MemberCardRuleJson = ActionController.getMemberCardIntegralRule(userweixinid, weixinid);
                Hashtable MemberCardRuleJsonobj = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJson);
                if (MemberCardRuleJsonobj["becomeMember"].ToString().ToLower() == "false")
                {
                    hotel3g.Repository.MemberCardIntegralRule rule = Newtonsoft.Json.JsonConvert.DeserializeObject<hotel3g.Repository.MemberCardIntegralRule>(MemberCardRuleJsonobj["rule"].ToString());
                    if (rule.MealCouponType == 0 && rule.MealGradeRate > 0) //折扣
                    {
                        discount = rule.MealGradeRate;
                    }
                }
            }
            ViewData["discount"] = discount;


            string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;////微信分享
            if (!userweixinid.Contains(wkn_shareopenid))
            {
                OrderDetails detail = DishOrderLogic.GetOrderDetailsModel(orderCode, dishId);
                if (detail.DishsesID == Convert.ToInt32(dishId) || detail.Number > 0)
                {
                    total = detail.Price * detail.Number;
                    number = detail.Number;
                }
                if (discount > 0)
                {
                    total = total * discount / 10;
                }
            }

            ViewData["total"] = total;
            ViewData["number"] = number;

            Stores store = DishOrderLogic.GetStore(Convert.ToInt32(storeId));
            ViewData["hotelName"] = store == null ? DishOrderLogic.GetHotelName(id + "") : store.StoreName;

            ViewData["orderCode"] = orderCode;
            ViewData["dishId"] = dishId;
            ViewData["storeId"] = storeId;
            ViewData["hId"] = id;
            ViewData["key"] = key;
            return View();
        }

        //public ActionResult RichViewToBuy_backup() 
        //{
        //    int resultRows = 0;
        //    string key = HotelCloud.Common.HCRequest.GetString("key");
        //    string weixinid = key.Contains('@') ? key.Split('@')[0] : "";
        //    string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";
        //    string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
        //    string storeId = HotelCloud.Common.HCRequest.GetString("storeId");
        //    string hId = HotelCloud.Common.HCRequest.GetString("hId");
        //    string dishId = HotelCloud.Common.HCRequest.GetString("dishId");
        //    string num = HotelCloud.Common.HCRequest.GetString("num");
        //    string Hot = HotelCloud.Common.HCRequest.GetString("Hot");
            
        //    string disc = HotelCloud.Common.HCRequest.GetString("discount");//折扣
        //    decimal discount = 0;
        //    decimal.TryParse(disc, out discount);

        //    DishOrderLogic.DelDishNumberIs0Details(orderCode);
        //    if (string.IsNullOrEmpty(orderCode))
        //    {
        //        return Json(new
        //        {
        //            error = 0,
        //            message = "订单异常！"
        //        });
        //    }
        //    //ISNULL([Status],0)=0 订单未提交
        //    bool HasOrder = DishOrderLogic.IsHasOrderInfo(orderCode, EnumOrderStatus.UnSubmit);
        //    if (!HasOrder)//无
        //    {
        //        int rows = DishOrderLogic.InserOrder(orderCode, storeId, hId, userweixinid, weixinid);
        //    }
        //    resultRows = InserDish(orderCode, dishId, num, Hot, discount);
        //    if (resultRows > 0)
        //    {
        //        return Json(new
        //        {
        //            error = 1,
        //            message = "提交成功！",
        //            ordercode = orderCode
        //        });
        //    }
        //    else
        //    {
        //        return Json(new
        //        {
        //            error = 0,
        //            message = "菜品已下架了！"
        //        });
        //    }
        //}
        public ActionResult RichViewToBuy()
        {
            int resultRows = 0;
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string weixinid = key.Contains('@') ? key.Split('@')[0] : "";
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";
            string storeId = HotelCloud.Common.HCRequest.GetString("storeId");
            string hId = HotelCloud.Common.HCRequest.GetString("hId");
            string dishId = HotelCloud.Common.HCRequest.GetString("dishId");
            string num = HotelCloud.Common.HCRequest.GetString("num");
            string Hot = HotelCloud.Common.HCRequest.GetString("Hot");

            string disc = HotelCloud.Common.HCRequest.GetString("discount");//折扣
            decimal discount = 0;
            decimal.TryParse(disc, out discount);

            string newOrderCode = "L" + DateTime.Now.ToString("yyMMddhhmmssfff") + new Random().Next(100, 999).ToString();
            int rows = DishOrderLogic.InserOrder(newOrderCode, storeId, hId, userweixinid, weixinid);
            Dishses model = DishOrderLogic.GetDishsesModel(dishId);
            resultRows=DishOrderLogic.SaveOrderDish(newOrderCode, model, num, Hot, discount);
            if (resultRows > 0)
            {
                return Json(new
                {
                    error = 1,
                    message = "提交成功！",
                    ordercode = newOrderCode
                });
            }
            else
            {
                return Json(new
                {
                    error = 0,
                    message = "菜品已下架了！",
                    ordercode = newOrderCode
                });
            }
        }
        private int InserDish(string orderCode, string dishId, string number, string Hot, decimal discount) 
        {
            int resultRows = 0;
            Dishses model = DishOrderLogic.GetDishsesModel(dishId);
            if (model != null)
            {
                bool hasDish = DishOrderLogic.HasDish(dishId, orderCode);
                if (!hasDish)
                {
                    resultRows = DishOrderLogic.SaveOrderDish(orderCode, model, number, Hot,discount);
                }
                else
                {
                    resultRows = DishOrderLogic.UpdateOrderDish(orderCode, model.DishsesID, number);
                }

                //DishOrderLogic.UpdateOrderAmount(ordercode);
            }
            else //无id对应的菜品[可能pc 端删除]
            {
                resultRows = -1;
            }
            return resultRows;
        }
        #endregion

        #region 订单支付

        //首页选好餐品跳转页面(已生成待支付订单)
        public ActionResult PagePay(int id)
        {
            string hotelId = id.ToString();
            int storeId = HotelCloud.Common.HCRequest.GetInt("storeId", 0);//餐品商家id
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = key.Contains('@') ? key.Split('@')[0] : "";
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            if (string.IsNullOrEmpty(orderCode))
            {
                orderCode = DishOrderLogic.GetOrderCode(hotelId, storeId.ToString(), userweixinid, EnumOrderStatus.UnSubmit);
            }
            
            string tablenumber = "";
            int tid = HCRequest.getInt("tid");//桌台号id
            if (tid > 0) 
            {
                tablenumber= DishOrderLogic.GetTableNumber(tid);
            }
            ViewData["tablenumber"] =tablenumber;

            ViewData["ordertips"]="";
            StoresView store = DishOrderLogic.GetStore(storeId);
            decimal Bg = 0;
            string youhuiids = "";//消费满减活动id= 1,2,3
            int yongjin = 0;//佣金点
            bool iszbsj = false;
            int eatatstore = Convert.ToInt32(EnumEatAtStore.外卖);//默认不堂食
            int openaddress = Convert.ToInt32(EnumStoreOpenAddress.开启); ;//开启地址
            if (store != null)
            {
                eatatstore = store.eatatstore;
                openaddress=store.openaddress;
                ViewData["storeName"] = store.StoreName;
                ViewData["youhuiRemo"] = store.Remo;
                ViewData["bagging"] = store.bagging;
                Bg = store.bagging;
                yongjin = store.yongjin;
                youhuiids = store.YouhuiIDs;
                ViewData["ordertips"] = (store.showordertips == 1 && !string.IsNullOrEmpty(store.ordertips)) ? store.ordertips : "";//酒店设置的订单提示信息
                iszbsj = store.storetype != 0;
            }
            ViewData["eatatstore"] = eatatstore;
            ViewData["openaddress"] = openaddress;
            ViewData["youhuiids"] = youhuiids;
            ViewData["iszbsj"] = iszbsj;

            OrderAddress address = new OrderAddress();
            if (tid == Convert.ToInt32(EnumFromScan.非扫码))
            {
                address = DishOrderLogic.GetAddress(userweixinid);
                // 1 旅行社版本
                if (WeiXin.Common.NormalCommon.IsLXSDoMain() && address.addressType != 2)
                {
                    address = DishOrderLogic.GetAddressList(key.Split('@')[1]).FindAll(a => a.addressType == 2)[0];
                    address.Address = address.kuaidiAddress;
                    address.RoomNo = "";
                }
                if (openaddress == Convert.ToInt32(EnumStoreOpenAddress.关闭))//酒店关闭地址，清空地址信息 
                {
                    address.Address = "";
                    address.RoomNo = "";
                    address.kuaidiAddress = "";
                }

                if (eatatstore == Convert.ToInt32(EnumEatAtStore.堂食) && !WeiXin.Common.NormalCommon.IsLXSDoMain()) //堂食，非旅行社版本
                {
                    address = new OrderAddress();
                }
            }

            int rows = DishOrderLogic.SettingOrderInfoByOrderCode(orderCode, address, Bg, yongjin, tablenumber);//设置订单信息


            DataTable dt_dish = DishOrderLogic.GetDishTableForPay(orderCode);
            decimal Amount = 0;
            decimal YouhuiMoney = 0;
            decimal Bagging = 0;
            decimal PayAmount = 0;
            string remo = "";
            string userNumber = "";
            if (dt_dish.Rows.Count > 0)
            {
                Amount = Convert.ToDecimal(dt_dish.Rows[0]["amount"]);
                //YouhuiMoney = Convert.ToDecimal(dt_dish.Rows[0]["youhuiamount"]);
                Bagging = Convert.ToDecimal(dt_dish.Rows[0]["bagging"]);
                PayAmount = Convert.ToDecimal(dt_dish.Rows[0]["payamount"]); //Amount - YouhuiMoney + Bagging;//支付金额=订单总金额-优惠金额
                remo = Convert.ToString(dt_dish.Rows[0]["remo"]);
                userNumber = Convert.ToString(dt_dish.Rows[0]["userNumber"]);

                if (userweixinid.Contains(hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId)) //朋友分享的[订单当地在编辑地址时已经设置了]
                {
                    address.LinkMan = dt_dish.Rows[0]["orderLinkMan"] + "";
                    address.LinkPhone = dt_dish.Rows[0]["orderPhone"] + "";
                    address.Address = dt_dish.Rows[0]["orderAddress"] + "";
                    address.RoomNo = dt_dish.Rows[0]["orderRoomNo"] + "";
                    address.AddressID = string.IsNullOrEmpty(address.LinkMan) ? 0 : 99999999;
                }
            }
            string unsale = "";
            foreach (DataRow row in dt_dish.Rows) 
            {
                if (!string.IsNullOrEmpty(row["unsale"] + ""))
                {
                    unsale += row["unsale"]+"、";
                }
            }
            ViewData["unsale"] = unsale;

            //ViewData["hotelName"] = string.IsNullOrEmpty(address.Address) ? DishOrderLogic.GetHotelName(hotelId) : address.Address;
            ViewData["dt_dish"] = dt_dish;
            ViewData["Amount"] = Amount;
            ViewData["PayAmount"] = PayAmount;
            
            ViewData["remo"] = remo;
            ViewData["userNumber"] = userNumber;
            ViewData["address"] = address;

            ViewData["hId"] = hotelId;
            ViewData["storeId"] = storeId;
            ViewData["orderCode"] = orderCode;
            ViewData["key"] = key;
            ViewData["isview"] = HotelCloud.Common.HCRequest.GetInt("isview", 0);

            
            #region  获取可用红包
           
            int canCoupon = 0;
            decimal canCouponTotalMoney = 0;
            foreach (DataRow row in dt_dish.Rows)
            {
                if (Convert.ToInt32(row["canCouPon"]) == 1)
                {
                    canCouponTotalMoney += decimal.Parse(row["price"] + "") * Convert.ToInt32(row["number"]);
                    canCoupon++;
                }
                //if (Convert.ToInt32(row["discount"]) > 0)//折扣大于0
                //{
                //    canDiscount++;
                //}
            }
            // scopelimit,--可以使用的范围(0:酒店订房 1:自营餐饮 2:团购预售 3:酒店超市 4:周边商家) amountlimit--消费需满多少可使用
            ViewData["couponDataTable"] = new DataTable();
            if (store != null && canCoupon > 0)
            {
                string scopelimit = store.Isaround == 2 ? "1" : "4";
                var couponDataTable = DishOrderLogic.GetUserCouPonDataTable(weixinid, userweixinid, scopelimit);
                if (couponDataTable.Rows.Count > 0)
                {
                    var drs = couponDataTable.Select("amountlimit<=" + canCouponTotalMoney);
                    if (drs.Length > 0)
                    {
                        ViewData["couponDataTable"] = drs.CopyToDataTable();
                    }
                }
            }

            #endregion

            //优惠政策
            decimal sum = Amount;//订单金额
            
            ViewData["hasRule"] = null;

            string MemberCardRuleJson = ActionController.getMemberCardIntegralRule(userweixinid, weixinid);
            Hashtable MemberCardRuleJsonobj = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJson);
            if (MemberCardRuleJsonobj["becomeMember"].ToString().ToLower() == "false")
            {
                hotel3g.Repository.MemberCardIntegralRule rule = Newtonsoft.Json.JsonConvert.DeserializeObject<hotel3g.Repository.MemberCardIntegralRule>(MemberCardRuleJsonobj["rule"].ToString());
                ViewData["hasRule"] = rule;
                if (rule.MealCouponType == 1) //立减
                {
                    sum = Amount - rule.MealReduce;
                    YouhuiMoney = rule.MealReduce;
                }

                if (rule.MealCouponType == 0) //折扣
                {
                    sum = 0;//折扣重新计算金额
                    foreach (System.Data.DataRow row in dt_dish.Rows)
                    {
                        decimal discount = 0;
                        decimal.TryParse(row["discount"] + "", out discount);
                        if (discount > 0)//菜品有折扣
                        {
                            sum += Convert.ToInt32(row["number"]) * Decimal.Parse(row["price"] + "") * discount / 10;
                            YouhuiMoney += (decimal.Parse(row["price"] + "") - decimal.Parse(row["discountprice"] + "")) * Convert.ToInt32(row["number"]);
                        }
                        else
                        {
                            sum += Convert.ToInt32(row["number"]) * Decimal.Parse(row["price"] + "");
                        }
                    }
                }
            }
            
            ViewData["YouhuiMoney"] = YouhuiMoney;

            //获取积分
            ViewData["orderScore"] = 0;
            ViewData["equivalence"] = 1;
            ViewData["GradePlus"] = 1;
            hotel3g.Repository.MemberInfo Info = hotel3g.Repository.MemberHelper.GetMemberInfo(weixinid);
            string cardno = hotel3g.Repository.MemberHelper.GetCardNo(userweixinid, weixinid);
            if (!string.IsNullOrEmpty(cardno))
            {
                hotel3g.Repository.MemberCard MyCard = hotel3g.Repository.MemberHelper.GetMemberCard(cardno, weixinid);
                hotel3g.Repository.MemberCardIntegralRule IntegralRule = hotel3g.Repository.MemberHelper.IntegralRule(Info, MyCard);
                var score = sum;
                if (IntegralRule.equivalence > 0)
                {
                    score = score * IntegralRule.equivalence;
                    ViewData["equivalence"] = IntegralRule.equivalence;
                }
                if (IntegralRule.GradePlus > 0)
                {
                    score = score * IntegralRule.GradePlus;
                    ViewData["GradePlus"] = IntegralRule.GradePlus;
                }
                ViewData["orderScore"] = (int)score;
            }
            ViewData["total"] = sum;

            #region 计算消费满xx元减x元
            ViewData["manjian_model"] = new Youhui();
            Youhui youhui = DishOrderLogic.GetYouhui(youhuiids, sum + "");
            if (youhui != null) 
            {
                ViewData["manjian_model"] = youhui;
            }
            #endregion

            #region 桌台下拉
            if (store != null)
            {
                ViewData["data"] = DishOrderLogic.GetTableJsonByStoreId(store.StoreId);
            }
            #endregion

            return View();
        }

        public ActionResult PaySuccess(int id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            OrderInfo orderinfo = DishOrderLogic.GetOrderInfo(orderCode);
            Stores store = DishOrderLogic.GetStore(orderinfo.storeID);
            
            int eatatstore = Convert.ToInt32(EnumEatAtStore.外卖);
            if (store != null)
            {
                eatatstore = store.eatatstore;
            }
            ViewData["eatatstore"] = eatatstore;

            ViewData["songdashijian"] = store==null?"":store.yujisongdashijian;
            ViewData["model"] = orderinfo;

            ViewData["key"] = key;
            ViewData["hId"] = id;
            return View();
        }

        public ActionResult PayFail(int id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            OrderInfo orderinfo = DishOrderLogic.GetOrderInfo(orderCode);
            
           
            Stores store = DishOrderLogic.GetStore(orderinfo.storeID);

            if (orderinfo.orderId > 0) 
            {
                CalculateTime(orderinfo.orderCode, orderinfo.submitTime, orderinfo.Status);
            }

            int eatatstore = Convert.ToInt32(EnumEatAtStore.外卖);
            if (store != null) 
            {
                eatatstore = store.eatatstore;
            }
            ViewData["eatatstore"] = eatatstore;

            ViewData["songdashijian"] = store == null ? "" : store.yujisongdashijian;
            
            ViewData["model"] = orderinfo;
            

            ViewData["key"] = key;
            ViewData["hId"] = id;
            ViewData["storeId"] = orderinfo.storeID;
            ViewData["orderCode"] = orderCode;
            return View();
        }

        public ActionResult OrderPay(int id)
        {
            string hotelId = id.ToString();
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            string key = HotelCloud.Common.HCRequest.GetString("key");
            int storeId = HotelCloud.Common.HCRequest.getInt("storeId",0);

            OrderInfo orderinfo = DishOrderLogic.GetOrderInfo(orderCode,EnumOrderStatus.UnPay);//找不到订单，返回new 实例
            if (!string.IsNullOrEmpty(orderinfo.orderCode))
            {
                string hotelName = DishOrderLogic.GetHotelName(hotelId);
                CalculateTime(orderCode, orderinfo.submitTime,orderinfo.Status);//计算订单剩余支付时间
                
                ViewData["hId"] = hotelId;
                ViewData["key"] = key;
                ViewData["orderCode"] = orderCode;
                ViewData["storeId"] = storeId;

                ViewData["hotelName"] = hotelName;
                ViewData["model"] = orderinfo;

                StoresView store = DishOrderLogic.GetStore(orderinfo.storeID);
                ViewData["ordertips"] = store == null ? "" : ((store.showordertips == 1 && !string.IsNullOrEmpty(store.ordertips)) ? store.ordertips : "");//酒店设置的订单提示信息
                
                int eatatstore = Convert.ToInt32(EnumEatAtStore.外卖);
                if (store != null)
                {
                    eatatstore = store.eatatstore;
                }
                ViewData["eatatstore"] = eatatstore;


                return View();
            }
            else //无待支付订单,返回首页点餐
            {
                string url = string.Format("/DishOrder/DishOrderIndex/{0}?key={1}&storeId={2}", id, key, storeId);
                return Redirect(url);
            }
        }
        //计算订单剩余支付时间,默认30分钟
        private void CalculateTime(string orderCode, DateTime submitTime, int orderStatus)
        {
            int LimitedMinutes = System.Configuration.ConfigurationManager.AppSettings["LimitedMinutes"] + "" == "" ? 30 : Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["LimitedMinutes"]);
            TimeSpan ts = DateTime.Now - submitTime.AddMinutes(LimitedMinutes);
            if (ts.TotalSeconds < 0 && orderStatus == Convert.ToInt32(EnumOrderStatus.UnPay))//还在30分钟支付时间范围内
            {
                string m = Math.Abs(ts.Minutes) < 10 ? "0" + Math.Abs(ts.Minutes).ToString() : Math.Abs(ts.Minutes).ToString();
                string s = Math.Abs(ts.Seconds) < 10 ? "0" + Math.Abs(ts.Seconds).ToString() : Math.Abs(ts.Seconds).ToString();
                ViewData["time"] = string.Format("{0}:{1}", m, s);
                ViewData["TotalSeconds"] = Math.Abs(ts.Minutes) * 60 + Math.Abs(ts.Seconds);
            }
            else //订单超时
            {
                ViewData["time"] = "00:00";
                ViewData["TotalSeconds"] = -99;
                if (orderStatus == Convert.ToInt32(EnumOrderStatus.UnPay))
                {
                    DishOrderLogic.UpdateOrderStatusByOrderCode(orderCode, EnumOrderStatus.IsOverTime);
                }
            }
        }

        //提交订单到待支付
        public ActionResult SendOrderToPay()
        {
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            string CouponId = HotelCloud.Common.HCRequest.GetString("CouponId");
            string CouponMoney = HotelCloud.Common.HCRequest.GetString("CouponMoney");

            string usetime = HotelCloud.Common.HCRequest.GetString("usetime");//用餐时间
            string jifen = HotelCloud.Common.HCRequest.GetString("jifen");
            string yhamount = HotelCloud.Common.HCRequest.GetString("yhamount");//立减/折扣的金额
            string manjianmoney = HotelCloud.Common.HCRequest.GetString("manjianmoney");//消费满减金额
            string manjianremo = HCRequest.GetString("manjianremo");//消费满减信息

            string remo = HCRequest.GetString("remo");//订单备注
            int eatatstore = HCRequest.getInt("eatatstore");//0不堂食，1堂食
            string tablenumber = HCRequest.GetString("tablenumber");//桌台号
            int tid = HCRequest.getInt("tid");//扫码桌台号id

            OrderInfo order = DishOrderLogic.GetOrderInfo(orderCode);
            if (order.orderId > 0)
            {
                if (order.Status == Convert.ToInt32(EnumOrderStatus.UnSubmit))
                {
                    string key = HCRequest.GetString("key");
                    if (Convert.ToInt32(CouponId) > 0)
                    {
                        //oliver这个方法再次验证是否使用 或者过期
                        bool canuse = WeiXin.Models.Home.CouPonContent.IsCouPonContentEnable(key.Split('@')[0], key.Split('@')[1], Convert.ToInt32(CouponId));
                        //if (!DishOrderLogicA.CouponIsCanUse(CouponId))
                        if (!canuse)
                        {
                            return Json(new
                            {
                                error = 0,
                                message = "红包已使用过或者过期，订单提交失败！请刷新页面重新操作！"
                            });
                        }
                    }

                    //DishOrderLogic.SetOrderEatAtStore(order.orderCode, tablenumber, tid);//设置桌台号tablenumberid

                    int rows = DishOrderLogic.SubOrderByCouPon(orderCode, CouponId, CouponMoney, order.hotelWeixinId, order.userweixinid, usetime, jifen, yhamount, manjianmoney, manjianremo, remo, tablenumber, tid.ToString());
                    DishOrderLogic.SetOrderFxmoney(order.hotelWeixinId, order.userweixinid, orderCode);
                    return Json(new
                    {
                        error = rows > 0 ? 1 : 0,
                        message = rows > 0 ? "提交订单成功！" : "提交订单失败！"
                    });

                }
                else if (order.Status == Convert.ToInt32(EnumOrderStatus.IsOverTime))
                {
                    return Json(new
                    {
                        error = 3,
                        message = "订单已取消！无需支付"
                    });
                }
                else if (order.Status == Convert.ToInt32(EnumOrderStatus.IsCancel))
                {
                    return Json(new
                    {
                        error = 4,
                        message = "订单已取消！无需支付！"
                    });
                }
                else if (order.orderPayState == Convert.ToInt32(EnumOrderPayStatus.支付成功).ToString())//支付状态
                {
                    return Json(new
                    {
                        error = 2,
                        message = "订单已支付成功！无需重新支付！"
                    });
                }
                else if (order.Status == Convert.ToInt32(EnumOrderStatus.IsPay))
                {
                    return Json(new
                    {
                        error = 2,
                        message = "订单已支付！无需重新支付！"
                    });
                }
                else if (order.Status == Convert.ToInt32(EnumOrderStatus.IsFinish))
                {
                    return Json(new
                    {
                        error = 5,
                        message = "已交易成功！无需支付！"
                    });
                }
                else if (order.Status == Convert.ToInt32(EnumOrderStatus.IsBossCancel))
                {
                    return Json(new
                    {
                        error = 6,
                        message = "订单已取消！无需支付！"
                    });
                }
                else
                {
                    return Json(new
                    {
                        error = 1,
                        message = "去支付"
                    });
                }

            }
            else
            {
                return Json(new
                {
                    error = 7,
                    message = "无内容空订单！"
                });
            }
            
        }

        //订单超时
        public ActionResult SaveOrderOverTime()
        {
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");

            int rows = DishOrderLogic.UpdateOrderStatusByOrderCode(orderCode, EnumOrderStatus.IsOverTime);

            return Json(new
            {
                error = rows > 0 ? 1 : 0,
                message = rows > 0 ? "成功！" : "失败！"
            });
        }
        
        //设置订单优惠金额
        public ActionResult SettingOrderYouhuiAmount(int id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            
            OrderInfo orderinfo = DishOrderLogic.GetOrderInfo(orderCode);
            if (orderinfo.orderId > 0)
            {
                Stores store = DishOrderLogic.GetStore(orderinfo.storeID);
                if (store != null)
                {
                    if ((orderinfo.amount + store.bagging) >= store.Minprice) //订单金额+打包费>=商家起送价
                    {
                        //Youhui youhui = DishOrderLogic.GetYouhui(store.YouhuiIDs, (orderinfo.amount + store.bagging).ToString());
                        //if (youhui != null)
                        //{
                            DishOrderLogic.UpdateOrderYouHuiMoney(orderCode, 0, store.bagging);
                        //}
                        
                        return Json(new { error = 1, message = "" });

                    }
                    else
                    {
                        return Json(new { error = 0, message = "订单金额小于商家起送价:" + store.Minprice });
                    }
                }
                else
                {
                    return Json(new { error = 0, message = "商家信息异常!请刷新页面重新选餐品!" });
                }
            }
            else
            {
                return Json(new { error = 0, message = "无明细的空订单!请先选餐品!" });
            }
        }

        
        public ActionResult GetYouhuiAmount() 
        {
            string payamount=HCRequest.GetString("pamount");
            string ids = HCRequest.GetString("ids");
            Youhui youhui = DishOrderLogic.GetYouhui(ids, payamount);
            decimal money=0;
            string msg = "";
            if (youhui != null) 
            {
                money = youhui.DelMoney;
                msg = youhui.Remo;
            }
            return Json(
                   new { money = money ,msg=msg}
                   );
        }
        #endregion

        #region 订单详情
        
        public ActionResult ViewOrderDetail(int id) 
        {
            int storeId = HotelCloud.Common.HCRequest.GetInt("storeId", 0);//餐品商家id
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            //扫码点餐
            int tid = HotelCloud.Common.HCRequest.getInt("tid");

            DataTable dt_dish = DishOrderLogic.GetDishTableForPay(orderCode);
            decimal Amount = 0;
            decimal YouhuiMoney = 0;
            decimal Bagging = 0;
            decimal PayAmount = 0, CouponMoney=0;
            string remo = "";
            string userNumber = "", willArriveTime = "", songcanyuan = "", songcanphone = "", songcantime = "", usetime = "", jifen = "0";
            decimal manjianmoney = 0;//消费满减金额
            string manjianremo = "";//消费满减备注


            ViewData["tablenumberid"] = 0;
            int Status = -110;
            if (dt_dish.Rows.Count > 0)
            {
                Status = Convert.ToInt32(dt_dish.Rows[0]["Status"]);

                manjianmoney = Convert.ToDecimal(dt_dish.Rows[0]["manjianmoney"]);
                manjianremo = dt_dish.Rows[0]["manjianremo"]+"";
                CouponMoney = Convert.ToDecimal(dt_dish.Rows[0]["CouponMoney"]);
                Amount = Convert.ToDecimal(dt_dish.Rows[0]["amount"]);
                YouhuiMoney = Convert.ToDecimal(dt_dish.Rows[0]["youhuiamount"]);
                Bagging= Convert.ToDecimal(dt_dish.Rows[0]["bagging"]);
                PayAmount = Convert.ToDecimal(dt_dish.Rows[0]["payamount"]);//Amount - YouhuiMoney + Bagging;//支付金额=订单总金额-优惠金额+打包费用
                remo = Convert.ToString(dt_dish.Rows[0]["remo"]);
                userNumber = Convert.ToString(dt_dish.Rows[0]["userNumber"]);
                willArriveTime = dt_dish.Rows[0]["willArriveTime"] + "";
                usetime = dt_dish.Rows[0]["usetime"] + "";
                jifen = dt_dish.Rows[0]["jifen"] + "";

                songcanyuan = dt_dish.Rows[0]["songcanyuan"] + "";
                songcanphone = dt_dish.Rows[0]["songcanphone"] + "";
                songcantime = dt_dish.Rows[0]["songcantime"] + "";

                ViewData["linkman"] = dt_dish.Rows[0]["orderLinkMan"];
                ViewData["linkphone"] = dt_dish.Rows[0]["orderPhone"];
                ViewData["hotel"] = dt_dish.Rows[0]["orderAddress"];
                ViewData["roomNo"] = dt_dish.Rows[0]["orderRoomNo"];
                ViewData["tablenumber"] = dt_dish.Rows[0]["tablenumber"];
                ViewData["tablenumberid"] = dt_dish.Rows[0]["tablenumberid"];

                //倒计时剩余时间
                if (dt_dish.Rows[0]["submitTime"] != null)
                {
                    DateTime submitTime = Convert.ToDateTime(dt_dish.Rows[0]["submitTime"]);
                    CalculateTime(orderCode, submitTime, Status);//计算订单剩余支付时间
                }
            }
            
            //
            //if (Status == Convert.ToInt32(EnumOrderStatus.UnPay)) //待支付单跳转到支付倒计时页面
            //{
            //    return RedirectToAction("OrderPay", new { id = id, orderCode = orderCode, key = key, storeId = storeId });
            //}

            #region 状态

            if (Status == Convert.ToInt32(EnumOrderStatus.IsOverTime) ||
                Status == Convert.ToInt32(EnumOrderStatus.IsCancel) ||
                Status == Convert.ToInt32(EnumOrderStatus.JudanTuikuan) ||
                Status == Convert.ToInt32(EnumOrderStatus.IsBossCancel) ||
                Status == 2) //2,3,11,13
            {
                ViewData["StatusName"] = "取消";
            }
            if (Status == Convert.ToInt32(EnumOrderStatus.IsSure))
            {
                ViewData["StatusName"] = "已确认";
            } 
            if (Status == Convert.ToInt32(EnumOrderStatus.UnPay))
            {
                ViewData["StatusName"] = "待付款";
            } 
            if (Status == Convert.ToInt32(EnumOrderStatus.IsPay))
            {
                ViewData["StatusName"] = "已付款";
            }
            if (Status == Convert.ToInt32(EnumOrderStatus.UnSubmit))
            {
                ViewData["StatusName"] = "未提交";
            } 
            if (Status == Convert.ToInt32(EnumOrderStatus.IsFinish))
            {
                ViewData["StatusName"] = "交易成功";
            }
            if (Status == Convert.ToInt32(EnumOrderStatus.IsPeiSongZhong))
            {
                ViewData["StatusName"] = "配送中";
            }

            #endregion

            ViewData["Status"] = Status;
            ViewData["ordertips"] = "";
            StoresView store = DishOrderLogic.GetStore(storeId);

            ViewData["eatatstore"] = Convert.ToInt32(EnumEatAtStore.外卖);
            
            bool iszbsj = false;
            if (store != null)
            {
                ViewData["eatatstore"] = store.eatatstore;
                ViewData["storeName"] = store.StoreName;
                ViewData["youhuiRemo"] = store.Remo;
                ViewData["storePhone"] = store.StorePhone;
                ViewData["ordertips"] = (store.showordertips == 1 && !string.IsNullOrEmpty(store.ordertips)) ? store.ordertips : "";//酒店设置的订单提示信息
                iszbsj = store.storetype != 0;
            }
            ViewData["iszbsj"] = iszbsj;
            ViewData["manjianmoney"] = manjianmoney;//消费满减金额
            ViewData["manjianremo"] = manjianremo;//消费满减备注

            ViewData["dt_dish"] = dt_dish;
            ViewData["PayAmount"] = PayAmount;
            ViewData["CouponMoney"] = CouponMoney; 
            ViewData["YouhuiMoney"]=YouhuiMoney;
            ViewData["bagging"] = Bagging;
            ViewData["remo"] = remo;
            ViewData["userNumber"] = userNumber;
            ViewData["willArriveTime"] = willArriveTime;
            ViewData["usetime"] = usetime;
            ViewData["jifen"] = jifen;
            ViewData["songcanyuan"] = songcanyuan;
            ViewData["songcanphone"] = songcanphone; 
            ViewData["songcantime"] = songcantime;

            ViewData["hId"] = id;
            ViewData["key"] = key;
            ViewData["storeId"] = storeId;
            ViewData["orderCode"] = orderCode;

            //是否已点评过
            //string r = SQLHelper.Get_Value("select top 1 1 from T_DianPing where orderCode=@orderCode", SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            //{
            //  {"orderCode",new DBParam(){ParamValue=orderCode}}
            //});
            //ViewData["HasDianPing"] =  string.IsNullOrEmpty(r);
            
            ViewData["HasDianPing"] = false;
            return View();
        }

        #endregion

        #region 编辑地址

        public ActionResult EditAddress(int id) 
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

            Stores store = DishOrderLogic.GetStore(Convert.ToInt32(storeId));
            int openaddress = 0;
            if (store != null) 
            {
                openaddress = store.openaddress;
            }
            ViewData["openaddress"] = openaddress;

            //获取会员手机号
            //string mobile = DishOrderLogic.GetMemberPhone(userweixinid);
            //ViewData["MemberMobile"] = string.IsNullOrEmpty(mobile) ? "" : "@"+mobile;

            List<OrderAddress> list = DishOrderLogic.GetAddressList(userweixinid);
            OrderAddress address = list.Find(a => a.isSelected == true); //DishOrderLogic.GetAddress(userweixinid);
            ViewData["list"] = list;

            ViewData["Address"] = address == null ? new OrderAddress() : address;
            //if (address != null)
            //{
            //    ViewData["hotelName"] = string.IsNullOrEmpty(address.Address) ? DishOrderLogic.GetHotelName(hotelId) : address.Address;//没有默认地址显示酒店名称
            //}
            //else {
            //    ViewData["hotelName"] = DishOrderLogic.GetHotelName(hotelId);
            //}
            ViewData["hotelName"] = DishOrderLogic.GetHotelName(hotelId);

            ViewData["hId"] = hotelId;
            ViewData["orderCode"] = orderCode;
            ViewData["key"] = key;
            ViewData["storeId"] = storeId;
            ViewData["userweixinid"] = userweixinid;
            return View();
        }

        public ActionResult SaveAddress(int id)
        {
            int addressid = HotelCloud.Common.HCRequest.GetInt("addressid", 0);
            string userweixinid = HotelCloud.Common.HCRequest.GetString("userweixinid");
            string name = HotelCloud.Common.HCRequest.GetString("name");
            string phone = HotelCloud.Common.HCRequest.GetString("phone");
            string room = HotelCloud.Common.HCRequest.GetString("room");
            string address = HotelCloud.Common.HCRequest.GetString("address");
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            
            string kdaddress = HotelCloud.Common.HCRequest.GetString("kdaddress");
            string type = HotelCloud.Common.HCRequest.GetString("type");

            string source = HotelCloud.Common.HCRequest.GetString("source");//canyin

            int rows = DishOrderLogic.InsertOrUpdateAddress2(addressid, name, phone, room, userweixinid, address, orderCode, type, kdaddress, source);
            return Json(new
            {
                error = rows > 0 ? 1 : 0,
                message = rows > 0 ? "保存成功！" : "保存失败！"
            });

            //if (DishOrderLogic.IsValidatePhoneNo(addressid, phone))
            //{
            //    int rows = DishOrderLogic.InsertOrUpdateAddress(addressid, name, phone, room, userweixinid, address);
            //    return Json(new
            //    {
            //        error = rows > 0 ? 1 : 0,
            //        message = rows > 0 ? "保存成功！" : "保存失败！"
            //    });
            //}
            //else
            //{
            //    string content = string.Format("订单将送到 {0}[微可牛]", address + room);
            //    string url = string.Format("http://app.hotelhotel.cn/api/sentsms.ashx?mobile={0}&content={1}", phone, content);
            //    string str = WxPayAPI.HttpService.Post("", url, false, 3);
            //    str = str.Replace("\"", "").Replace("\\", "\""); //"{\"error\":1,\"message\":\"发送成功\"}"
            //    if (!string.IsNullOrEmpty(str))
            //    {
            //        ErrorResult result = Newtonsoft.Json.JsonConvert.DeserializeObject<ErrorResult>(str);
            //        if (result.error == "1")
            //        {
            //            int rows = DishOrderLogic.InsertOrUpdateAddress(addressid, name, phone, room, userweixinid, address);
            //            return Json(new
            //            {
            //                error = rows > 0 ? 1 : 0,
            //                message = rows > 0 ? "保存成功！" : "保存失败！"
            //            });
            //        }
            //        else
            //        {
            //            return Json(new
            //            {
            //                error = 0,
            //                message = string.Format("号码{0}无效！", phone)
            //            });
            //        }
            //    }
            //    else 
            //    {
            //        return Json(new
            //        {
            //            error = 0,
            //            message = "短信验证接口返回异常！"
            //        });
            //    }
            //}
        }

        //获取验证码
        public ActionResult GetValidateCode()
        {
            string phone = HotelCloud.Common.HCRequest.GetString("phone");
            Random r = new Random();
            string code=r.Next(100000, 999999).ToString();
            string content = string.Format("手机验证码 {0}[微可牛]", code);
            string url = string.Format("http://app.hotelhotel.cn/api/sentsms.ashx?mobile={0}&content={1}&way=md", phone, content);
            string str = WxPayAPI.HttpService.Post("", url, false, 3);
            str = str.Replace("\"", "").Replace("\\", "\""); //"{\"error\":1,\"message\":\"发送成功\"}"
            if (!string.IsNullOrEmpty(str))
            {
                ErrorResult result = Newtonsoft.Json.JsonConvert.DeserializeObject<ErrorResult>(str);
                if (result.error == "1")
                {
                    return Json(new
                    {
                        error = 1,
                        message = code,
                        phone = phone
                    });
                }
                else 
                {
                    return Json(new
                    {
                        error = 0,
                        message = "获取验证码失败",
                        phone = phone
                    });
                }
            }
            else
            {
                return Json(new
                {
                    error = 0,
                    message = "获取验证码失败！",
                    phone = phone
                });
            }
        }

        #endregion

        #region 订单备注，用餐人数

        public ActionResult OrderRemo(int id) 
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            string storeId = HotelCloud.Common.HCRequest.GetString("storeId");

            string remo = DishOrderLogic.GetOrderRemo(orderCode);

            ViewData["remo"] = remo;

            ViewData["hId"] = id;
            ViewData["storeId"] = storeId;
            ViewData["orderCode"] = orderCode;
            ViewData["key"] = key;
            
            return View();
        }

        public ActionResult SaveOrderRemo() 
        {
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            string remo = HotelCloud.Common.HCRequest.GetString("remo");
            string key=HotelCloud.Common.HCRequest.GetString("key");
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";

            int rows = DishOrderLogic.SaveOrderRemo(orderCode, userweixinid, remo);
            return Json(new
            {
                error = rows > 0 ? 1 : 0,
                message = rows > 0 ? "保存成功！" : "保存失败！"
            });
        }

        public ActionResult SaveUserNumber() 
        {
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            int userNumber = HotelCloud.Common.HCRequest.getInt("n");

            OrderInfo order = DishOrderLogic.GetOrderInfo(orderCode);
            if (order.Status == Convert.ToInt32(EnumOrderStatus.UnSubmit)) //未提交订单才修改人数
            {
                int rows = DishOrderLogic.SaveUserNumber(orderCode, userNumber);
                return Json(new
                {
                    error = rows > 0 ? 1 : 0,
                    message = rows > 0 ? "保存成功！" : "保存失败！"
                });
            }
            else
            {
                return Json(new
                {
                    error =  0,
                    message = "已生成订单！不能修改！"
                });
            
            }
        }

        public ActionResult ValidateOrderStatus()
        {
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");

            OrderInfo order = DishOrderLogic.GetOrderInfo(orderCode);
            if (order.Status == Convert.ToInt32(EnumOrderStatus.UnSubmit)) //未提交订单才可修改信息
            {
                return Json(new
                {
                    error = 1,
                    message = ""
                });
            }
            else
            {
                return Json(new
                {
                    error = 0,
                    message = "已生成订单！不能修改信息！"
                });
            }
        }
        #endregion

        #region 取消订单，确认收货[订单完成]

        //取消订单
        public ActionResult CancelOrder(int id)
        {
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string storeId = HotelCloud.Common.HCRequest.GetString("storeId");

            int rows = DishOrderLogic.CancelOrder(orderCode, EnumOrderStatus.IsCancel);//已提交，待支付的订单才可取消
            return Json(new
            {
                error = rows > 0 ? 1 : 0,
                message = rows > 0 ? "订单取消成功！" : "订单取消失败！"
            });
        }

        //确认收货 订单完成
        public ActionResult FinishOrder()
        {
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            string storeId = HotelCloud.Common.HCRequest.GetString("storeId");
            int rows=0;
            using (TransactionScope ts = new TransactionScope()) 
            {
                try
                {
                    rows = DishOrderLogic.UpdateOrderStatusByOrderCode(orderCode, EnumOrderStatus.IsFinish);//已提交，待支付的订单才可取消
                    DishOrderLogicA.InserJeFen(orderCode);
                    ts.Complete();
                }
                catch 
                {
                    rows = 0;
                }
            }
            
            return Json(new
            {
                error = rows > 0 ? 1 : 0,
                message = rows > 0 ? "确认收货成功！" : "确认收货失败！"
            });
        }

        #endregion

        #region 申请退款
        public ActionResult ApplyRefund(int id) 
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            OrderInfo order = DishOrderLogic.GetOrderInfo(orderCode);
            string ApplyRemo = DishOrderLogic.GetRefundOrderApplyRemo(orderCode, EnumRefundStauts.SubmitApply);

            ViewData["ApplyRemo"] = ApplyRemo;
            ViewData["orderinfo"] = order;

            ViewData["key"] = key;
            ViewData["orderCode"] = orderCode;
            ViewData["storeId"] = order.storeID;
            ViewData["hId"] = id;

            return View();
        }

        public ActionResult SaveRefund() 
        {
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            string remo = HotelCloud.Common.HCRequest.GetString("remo");

            OrderInfo orderinfo = DishOrderLogic.GetOrderInfo(orderCode);
            decimal PayAmount = orderinfo.amount - orderinfo.youhuiamount + orderinfo.bagging;
            int rows = DishOrderLogic.SaveRefund(orderCode, remo, PayAmount.ToString());

            return Json(new
            {
                error = rows > 0 ? 1 : 0,
                message = rows > 0 ? "提交申请成功！" : "提交申请失败！"
            });
        }

        #endregion

        #region 评论，点评
        public ActionResult DianPing(int id) 
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            string storeId = HotelCloud.Common.HCRequest.GetString("storeId");
            ViewData["key"] = key;
            ViewData["orderCode"] = orderCode;
            ViewData["storeId"] = storeId;
            ViewData["hId"] = id;
            return View();
        }

        public string SaveDianPing() 
        {
            string hId = HotelCloud.Common.HCRequest.GetString("hId");
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            int storeId = HotelCloud.Common.HCRequest.getInt("storeId");

            string Context = HotelCloud.Common.HCRequest.GetString("content");
            int MiaoShuStar = HotelCloud.Common.HCRequest.getInt("miaoshuStar");
            int TaiDuStar = HotelCloud.Common.HCRequest.getInt("taiduStar");
            string img_url = "";
            //upload img begin
            HttpPostedFileBase file = Request.Files["dianping_file"];
            if (file != null)
            {
                if (file.ContentLength > 0)
                {
                    string fileExtion = Path.GetExtension(file.FileName).ToLower();//获取扩展名.
                    string newfileNmae = DateTime.Now.ToString("yyyyMMddHHmmssfff") + new Random().Next(1, 10000).ToString() + fileExtion; ;
                    string Direct = "/img/store/dianping/";
                    string directoryPath = Server.MapPath(Direct);
                    if (!Directory.Exists(directoryPath))
                    {
                        Directory.CreateDirectory(directoryPath);
                    }
                    file.SaveAs(directoryPath + newfileNmae);
                    img_url = WeiXinPublic.ConfigManage.Get("ImageWebSiteLocal") + Direct + newfileNmae;
                }
            }
            //upload img  end


            EntityDianPing model = new EntityDianPing();
            model.StoreId = storeId;
            model.orderCode = orderCode;
            model.userweixinID = userweixinid;
            model.Context = Context;
            model.MiaoShuStar = MiaoShuStar;
            model.TaiDuStar = TaiDuStar;
            model.imgurl = img_url;
            model.createTime = DateTime.Now;
            string ID =  EntityDianPing.Save(model);

            if (string.IsNullOrEmpty(ID))
            {
                return "<script>alert('保存评论失败！');window.history.go(-1);</script>";
            }
            else 
            {
                string url = string.Format("/DishOrder/ViewOrderDetail/{0}?key={1}&orderCode={2}&storeId={3}", hId, key, orderCode, storeId);
                return "<script>window.location.href='" + url + "';</script>";
            }
            
            //return Json(new { error = string.IsNullOrEmpty(ID) ? 0 : 1, message = string.IsNullOrEmpty(ID) ? "评价失败！" : "评价成功！" });
        }

        #endregion

        #region //餐厅预订
        public ActionResult BookDiningRoom(int id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            int DiningRoomID = HotelCloud.Common.HCRequest.getInt("DiningRoomID", 0);

            //DiningRoom room = DishOrderLogicA.GetDiningRoomModel(DiningRoomID);
            StoresView room = DishOrderLogic.GetStore(DiningRoomID);//周边选中商

            ViewData["room"] = room;
            ViewData["roomId"] = DiningRoomID;
            ViewData["key"] = key;
            ViewData["hId"] = id;
            return View();
        }

        /// <summary>
        /// 餐厅订单详情
        /// </summary>
        public ActionResult DiningRoomDetail(int id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");

            DataTable dt = DishOrderLogicA.GetDiningRoomOrderInfo(orderCode);
            int Status = -110;
            if (dt.Rows.Count > 0)
            {
                //OrderNO,LinkTel,UserName,demo as sex,UserWeiXinID,HotelID,HotelName,WeixinID,RoomID,RoomName,yinDate as usedate,lastTime as usetime,
                //yRoomNum as usernumber,Ordertime,state,remark,isMeeting

                ViewData["UserName"] = dt.Rows[0]["UserName"];
                ViewData["LinkTel"] = dt.Rows[0]["LinkTel"];
                ViewData["sex"] = dt.Rows[0]["sex"];

                ViewData["HotelName"] = dt.Rows[0]["HotelName"];
                ViewData["HotelTel"] = hotel3g.Models.HotelHelper.GetHotelTel(id);

                ViewData["remark"] = dt.Rows[0]["remark"];
                ViewData["Ordertime"] = dt.Rows[0]["Ordertime"];
                ViewData["RoomName"] = dt.Rows[0]["RoomName"];

                ViewData["usedate"] = dt.Rows[0]["usedate"];
                ViewData["usetime"] = dt.Rows[0]["usetime"];
                ViewData["usernumber"] = dt.Rows[0]["usernumber"];
                ViewData["remark"] = dt.Rows[0]["remark"];

                int.TryParse(dt.Rows[0]["state"] + "", out Status);
            }

            #region 状态

            if (Status == Convert.ToInt32(EnumDiningRoomOrderStatus.待跟进))
            {
                ViewData["StatusName"] = "待跟进";
                ViewData["cue"] = "您的信息已成功提交，酒店一般会在1小时内尽快联系您，如果紧急，请直接电话联系酒店";
            }
            if (Status == Convert.ToInt32(EnumDiningRoomOrderStatus.跟进中))
            {
                ViewData["StatusName"] = "跟进中";
                ViewData["cue"] = "订单酒店跟进中,请耐心等待.";
            }
            if (Status == Convert.ToInt32(EnumDiningRoomOrderStatus.跟进完成))
            {
                ViewData["StatusName"] = "跟进完成";
            }
            if (Status == Convert.ToInt32(EnumDiningRoomOrderStatus.取消))
            {
                ViewData["StatusName"] = "取消";
            }

            #endregion

            ViewData["Status"] = Status;

            ViewData["hId"] = id;
            ViewData["key"] = key;
            ViewData["orderCode"] = orderCode;

            return View();
        }

        #endregion

        #region 周边商店[旅行社]
        //周边商店
        public ActionResult AroundStores(string id) 
        {
            string hId = id;//酒店id
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = "";//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }

            DataTable dt = DishOrderLogic.GetStoreType(weixinid);

            ViewData["dt"] = dt;
            ViewData["hId"] = hId;
            ViewData["key"] = key;
            return View();
        }

        public ActionResult GetAroundStores(string id) 
        {
            string key = HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string weixinid = "";//酒店微信id
            string userweixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
                userweixinid = key.Split('@')[1];
            }

            int sort = HCRequest.getInt("sort");//距离，价格高低 排序
            int type = HCRequest.getInt("type");//类型帅选
            int curpage = HCRequest.getInt("page");//
            int pagesize = HCRequest.getInt("pagesize");

            string cityname = HCRequest.GetString("cityname");
            string storename = HCRequest.GetString("storename");
            string lnglat = HCRequest.GetString("lnglat");
            string lng="0";
            string lat = "0";
            if (lnglat != "") 
            {
                lng = lnglat.Split(',')[0];
                lat = lnglat.Split(',')[1];
            }

            List<StoresView> listAll = DishOrderLogic.GetStoresByWeixinId(id,weixinid, lng, lat, cityname, storename).ToList<StoresView>();
            List<StoresView> list = new List<StoresView>();
            if (type >-1)
            {
                listAll = listAll.FindAll(a => a.storetype == type);
            }

            list = listAll.Take(curpage * pagesize).ToList<StoresView>();

            if (sort == 1) { list = list.OrderBy(a => a.juli1).ToList(); }
            if (sort == 2) { list = list.OrderBy(a => a.Minprice).ToList(); }
            if (sort == 3) { list = list.OrderByDescending(a => a.Minprice).ToList(); }
            
            string strJson=Newtonsoft.Json.JsonConvert.SerializeObject(list);
            return Json(
                new
                {
                    success = true,
                    msg = strJson,
                    nextpage = list.Count < listAll.Count? curpage + 1 : curpage
                }
            );
        }


        public ActionResult GetStoreLocat(string id) 
        {
            string key = HCRequest.GetString("key");
            string weixinid = "";
            if (!key.Equals("") && key.Contains("@"))
            {
                weixinid = key.Split('@')[0];//酒店微信id
            }

            string sql = @"select * from (
select city.city,(select city from CityInfo ci where ci.id = c.cityid) as city2 
FROM T_Stores c WITH(NOLOCK)
left join Hotel h WITH(NOLOCK) on c.HotelId = h.id
left join CityInfo city WITH(NOLOCK) on h.cid = city.id
where c.weixinID=@weixinid
) t
group by city,city2";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
                    {
                        {"weixinid",new DBParam(){ParamValue=weixinid}}
                    });

            return Json(new
            {
                data =SerializeDataTable(dt)
            }, JsonRequestBehavior.AllowGet);
        }
        
        /// <summary>
        /// DataTable序列化
        /// </summary>
        /// <param name="dt"></param>
        /// <returns></returns>
        public static string SerializeDataTable(DataTable dt)
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

        #endregion
    }
   

     class ErrorResult 
    {
        public string error { get; set; }
        public string message { get; set; }
    }
    /// <summary>
    /// 扩展方法
    /// </summary>
    public static class DataExtensions
    {
        #region
        /// <summary>
        /// DataRow扩展方法：将DataRow类型转化为指定类型的实体
        /// </summary>
        /// <typeparam name="T">实体类型</typeparam>
        /// <returns></returns>
        public static T ToModel<T>(this DataRow dr) where T : class, new()
        {
            return GetModel<T>(dr, true);
        }
        public static T ToModel<T>(this DataRowView row) where T : class, new()
        {
            return GetModel<T>(row.Row, true);
        }

        /// <summary>
        /// DataRow扩展方法：将DataRow类型转化为指定类型的实体
        /// </summary>
        /// <typeparam name="T">实体类型</typeparam>
        /// <param name="dateTimeToString">是否需要将日期转换为字符串，默认为转换,值为true</param>
        /// <returns></returns>
        /// <summary>
        public static T ToModel<T>(this DataRow dr, bool dateTimeToString) where T : class, new()
        {
            if (dr != null)
                return GetModel<T>(dr, dateTimeToString);
            return null;
        }

        public static List<T> ToList<T>(this DataView dv) where T : class,new()
        {
            if (dv != null)
                return ToList<T>(dv.Table, true);
            return null;
        }
        /// <summary>
        /// DataTable扩展方法：将DataTable类型转化为指定类型的实体集合
        /// </summary>
        /// <typeparam name="T">实体类型</typeparam>
        /// <returns></returns>
        public static List<T> ToList<T>(this DataTable dt) where T : class, new()
        {
            return ToList<T>(dt, true);
        }

        /// <summary>
        /// DataTable扩展方法：将DataTable类型转化为指定类型的实体集合
        /// </summary>
        /// <typeparam name="T">实体类型</typeparam>
        /// <param name="dateTimeToString">是否需要将日期转换为字符串，默认为转换,值为true</param>
        /// <returns></returns>
        public static List<T> ToList<T>(this DataTable dt, bool dateTimeToString) where T : class, new()
        {
            List<T> list = new List<T>();

            if (dt != null)
            {
                List<PropertyInfo> infos = new List<PropertyInfo>();

                Array.ForEach<PropertyInfo>(typeof(T).GetProperties(), p =>
                {
                    if (dt.Columns.Contains(p.Name) == true)
                    {
                        infos.Add(p);
                    }
                });

                SetList<T>(list, infos, dt, dateTimeToString);
            }

            return list;
        }

        #region 私有方法

        private static T GetModel<T>(DataRow dr, bool dateTimeToString) where T : class, new()
        {
            List<PropertyInfo> infos = typeof(T).GetProperties().ToList();
            T model = new T();
            foreach (PropertyInfo p in infos)
            {
                if (dr.Table.Columns.Contains(p.Name))
                {
                    if (dr[p.Name] != DBNull.Value)
                    {
                        object tempValue = dr[p.Name];
                        if (dr[p.Name].GetType() == typeof(DateTime) && p.PropertyType == typeof(string) && dateTimeToString == true)
                        {
                            tempValue = dr[p.Name].ToString();
                        }
                        try
                        {
                            p.SetValue(model, tempValue, null);
                        }
                        catch
                        {
                        }
                    }
                }
            }
            return model;
        }

        private static void SetList<T>(List<T> list, List<PropertyInfo> infos, DataTable dt, bool dateTimeToString) where T : class, new()
        {
            foreach (DataRow dr in dt.Rows)
            {
                T model = new T();

                infos.ForEach(p =>
                {
                    if (dr[p.Name] != DBNull.Value)
                    {
                        object tempValue = dr[p.Name];
                        if (dr[p.Name].GetType() == typeof(DateTime) && p.PropertyType == typeof(string) && dateTimeToString == true)
                        {
                            tempValue = dr[p.Name].ToString();
                        }
                        try
                        {
                            p.SetValue(model, tempValue, null);
                        }
                        catch { }
                    }
                });
                list.Add(model);
            }
        }

        #endregion
        #endregion
    }
}
