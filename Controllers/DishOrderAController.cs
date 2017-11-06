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

namespace hotel3g.Controllers
{
    public class DishOrderAController : Controller
    {
        //订餐首页
        [Models.Filter]
        public ActionResult DishOrderIndex(string id)
        {
            string hId = id;//酒店 id
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
            ViewData["curr_store"] = store == null ? "" : store.StoreName;
            #endregion

            #region 餐厅预订

            List<DiningRoom> DiningRooms = DishOrderLogicA.GetDiningRoomList(hId);
            ViewData["DiningRooms"] = DiningRooms;
            #endregion

            string hotelName = DishOrderLogic.GetHotelName(hId);
            
            //string UnPayorderCode = DishOrderLogic.GetUnPayOrderCode(id.ToString(), storeId.ToString(), userweixinid, EnumOrderStatus.UnPay);
            //if (string.IsNullOrEmpty(UnPayorderCode))//没有检测到已经提交未支付未超时的订单,接着检查是否有未提交的订单，没有则返回一个新的编号
             if(true){
                string orderCode = DishOrderLogicA.GetOrderACode(id.ToString(), storeId.ToString(), userweixinid, EnumOrderStatus.UnSubmit);
                DataTable dt_dish = DishOrderLogic.GetStoreDishByIdOrderCode(storeId.ToString(), orderCode);
                DataTable dt_dishType = DishOrderLogic.GetDishTypeByStoreId(storeId.ToString());
                ViewData["dt_dishType"] = dt_dishType;

                ViewData["list_store"] = list;

                ViewData["dt_dish"] = dt_dish;
                ViewData["orderCode"] = orderCode;
                ViewData["hotelName"] = hotelName;
                ViewData["defmodel"] = defmodel;
                ViewData["orderDishTotalNum"] = DishOrderLogicA.GetOrderDishTotalNum_A(orderCode);

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
            DishOrderLogic.DelDishNumberIs0Details(orderCode);
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
            string Hot = HotelCloud.Common.HCRequest.GetString("Hot");
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            
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
            //if (!HasOrder)//无
            //{
            //    int rows = DishOrderLogic.InserOrder(orderCode, storeId, id.ToString(), userWeiXinID, hotelWeiXinID);
            //}
            OrderInfo model = DishOrderLogicA.GetOrderInfo_A(orderCode, false);
            if (model.orderId == 0) //无订单-添加订单，添加明细
            {
                int rows = DishOrderLogic.InserOrder(orderCode, storeId, id.ToString(), userWeiXinID, hotelWeiXinID);
                resultRows = InserDetail(orderCode, dishId, Hot, userWeiXinID, hotelWeiXinID);
            }
            else
            {
                if (model.Status == Convert.ToInt32(EnumOrderStatus.UnSubmit))
                {
                    resultRows = InserDetail(orderCode, dishId, Hot, userWeiXinID, hotelWeiXinID);

                    #region////设置优惠金额
                    StoresView store = DishOrderLogic.GetStore(int.Parse(storeId));
                    if (store != null)
                    {
                        model = DishOrderLogicA.GetOrderInfo_A(orderCode, false);//重新获取订单信息
                        if ((model.amount + store.bagging) >= store.Minprice) //订单金额+打包费>=商家起送价
                        {
                            //Youhui youhui = DishOrderLogic.GetYouhui(store.YouhuiIDs, (model.amount + store.bagging).ToString());
                            //if (youhui != null)
                            //{
                                DishOrderLogic.UpdateOrderYouHuiMoney(orderCode, 0, store.bagging);
                            //}
                        }
                        else
                        {
                            return Json(new { error = 0, message = "订单金额小于商家起送价:" + store.Minprice });
                        }
                    }

                    decimal Bg = 0;
                    if (store != null)
                    {
                        ViewData["storeName"] = store.StoreName;
                        ViewData["youhuiRemo"] = store.Remo;
                        ViewData["bagging"] = store.bagging;
                        Bg = store.bagging;
                    }
                    int yongjin = store == null ? 0 : store.yongjin; //佣金点
                    int rows = DishOrderLogic.SettingOrderInfoByOrderCode(orderCode, new OrderAddress(), Bg, yongjin);//设置订单信息

                    #endregion///

                }
                else 
                {
                    return Json(new
                    {
                        error = 0,
                        message = "订单已提交！不可修改！"
                    });
                }
            }

            ViewData["orderCode"] = orderCode;
            //DataTable dt_detail = DishOrderLogic.LoadOrderDetails(orderCode);
            //List<OrderDetails> list = dt_detail.ToList<OrderDetails>();
            //string json = Newtonsoft.Json.JsonConvert.SerializeObject(list);
            decimal amount = 0, couponTotalMoney = 0;
            DataTable cc=DishOrderLogicA.GetOrderAmountAndCanCouponMoney(orderCode);
            foreach (DataRow row in cc.Rows) 
            {
                decimal.TryParse(row["amount"] + "", out amount);
                decimal.TryParse(row["couponTotalMoney"] + "", out couponTotalMoney);
            }
            if (resultRows > 0)
            {
                return Json(new
                {
                    error = 1,
                    message = "添加成功！",
                    amount = amount,
                    couponTotalMoney = couponTotalMoney
                });
            }
            else
            {
                return Json(new
                {
                    error = 0,
                    message = "菜品已下架了！"
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
            }
            else //无id对应的菜品[可能pc 端删除]
            {
                resultRows = -1;
            }
            return resultRows;
        }
       
        #endregion

        #region 减菜品,清空

        //减餐
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
            OrderInfo model = DishOrderLogicA.GetOrderInfo_A(orderCode, false);
            if (model.Status == Convert.ToInt32(EnumOrderStatus.UnSubmit))
            {
                DishOrderLogic.ReduceDish(orderCode, dishId);

                #region////设置优惠金额
                //Stores store = DishOrderLogic.GetStore(model.storeID);
                StoresView store = DishOrderLogic.GetStore(int.Parse(storeId));
                if (store != null)
                {
                    if ((model.amount + store.bagging) >= store.Minprice) //订单金额+打包费>=商家起送价
                    {
                        //Youhui youhui = DishOrderLogic.GetYouhui(store.YouhuiIDs, (model.amount + store.bagging).ToString());
                        //if (youhui != null)
                        //{
                            DishOrderLogic.UpdateOrderYouHuiMoney(orderCode, 0, store.bagging);
                        //}
                    }
                    else
                    {
                        return Json(new { error = 0, message = "订单金额小于商家起送价:" + store.Minprice });
                    }
                }
                
                decimal Bg = 0;
                if (store != null)
                {
                    ViewData["storeName"] = store.StoreName;
                    ViewData["youhuiRemo"] = store.Remo;
                    ViewData["bagging"] = store.bagging;
                    Bg = store.bagging;
                }
                int yongjin = store == null ? 0 : store.yongjin; //佣金点
                int rows = DishOrderLogic.SettingOrderInfoByOrderCode(orderCode, new OrderAddress(), Bg, yongjin);//设置订单信息

                #endregion///


                decimal amount = 0, couponTotalMoney = 0;
                DataTable cc = DishOrderLogicA.GetOrderAmountAndCanCouponMoney(orderCode);
                foreach (DataRow row in cc.Rows)
                {
                    decimal.TryParse(row["amount"] + "", out amount);
                    decimal.TryParse(row["couponTotalMoney"] + "", out couponTotalMoney);
                }
                return Json(new
                {
                    error = 1,
                    message = "",
                    amount = amount,
                    couponTotalMoney = couponTotalMoney
                });
            }
            else
            {
                return Json(new
                {
                    error = 0,
                    message = "订单已提交！不可修改！"
                });
            }


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

        #region 购物车,详情预订，餐厅预订

        public ActionResult DishCart(int id)
        {
            string hotelId = id.ToString();
            int storeId = HotelCloud.Common.HCRequest.GetInt("storeId", 0);//餐品商家id
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            string weixinid = key.Contains('@') ? key.Split('@')[0] : "";
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";
            if (string.IsNullOrEmpty(orderCode))
            {
                orderCode = DishOrderLogic.GetOrderCode(hotelId, storeId.ToString(), userweixinid, EnumOrderStatus.UnSubmit);
            }

            int tid = HotelCloud.Common.HCRequest.getInt("tid");
            int eatatstore = Convert.ToInt32(EnumEatAtStore.外卖);
            int openaddress = Convert.ToInt32(EnumStoreOpenAddress.开启) ;//开启地址
            string youhuiids = "";//消费满减活动id= 1,2,3
            int yongjin = 0;//佣金点
            ViewData["ordertips"] = "";//酒店设置的订单提示信息
            StoresView store = DishOrderLogic.GetStore(storeId);
            decimal Bg = 0;
            if (store != null)
            {
                eatatstore = store.eatatstore;
                openaddress = store.openaddress;
                ViewData["storeName"] = store.StoreName;
                ViewData["youhuiRemo"] = store.Remo;
                ViewData["bagging"] = store.bagging;
                Bg = store.bagging;

                if (store.showordertips == 1 && !string.IsNullOrEmpty(store.ordertips)) 
                {
                    ViewData["ordertips"] = store.ordertips;
                }

                yongjin = store.yongjin;
                youhuiids = store.YouhuiIDs;
            }
            ViewData["eatatstore"] = eatatstore;
            ViewData["openaddress"] = openaddress;
            ViewData["youhuiids"] = youhuiids;
            

            OrderAddress address = new OrderAddress();
            string tablenumber = "";
            if (tid == Convert.ToInt32(EnumFromScan.非扫码))
            {
                if (eatatstore == Convert.ToInt32(EnumEatAtStore.外卖))
                {
                    address = DishOrderLogic.GetAddress(userweixinid);
                }
                if (openaddress == Convert.ToInt32(EnumStoreOpenAddress.关闭))
                {
                    address.addressType = 2;
                    address.RoomNo = "";
                    address.Address = "";
                    address.kuaidiAddress = "";
                }
            }
            else {
                tablenumber = DishOrderLogic.GetTableNumber(tid);
            }
            ViewData["tablenumber"] = tablenumber;

            int rows = DishOrderLogic.SettingOrderInfoByOrderCode(orderCode, address, Bg, yongjin, tablenumber);//设置订单信息

            DataTable dt=DishOrderLogicA.GetDishCartDetail(orderCode);
            ViewData["dishCart"] = dt;
            ViewData["address"] = address;
            
            #region //获取可用红包
            // scopelimit,--可以使用的范围(0:酒店订房 1:自营餐饮 2:团购预售 3:酒店超市 4:周边商家) amountlimit--消费需满多少可使用
            var canCouponRows=dt.Select("canCoupon=1");//明细包含可使用红包的菜品
            ViewData["couponDataTable"] = new DataTable();
            if (store != null && canCouponRows.Length>0)
            {
                string scopelimit = store.Isaround == 2 ? "1" : "4";
                var couponDataTable = DishOrderLogic.GetUserCouPonDataTable(weixinid, userweixinid, scopelimit);
                if (couponDataTable.Rows.Count > 0)
                {
                    ViewData["couponDataTable"] = couponDataTable;
                }
            }
            #endregion

            //优惠政策
            decimal sum = 0, Amount = 0;//订单金额
            foreach (DataRow row in dt.Rows)
            {
                decimal discount = 0;
                decimal.TryParse(row["discount"] + "", out discount);
                if (discount > 0)//折扣
                {
                    sum += Convert.ToInt32(row["number"]) * Decimal.Parse(row["price"] + "") * discount / 10;
                }
                else
                {
                    sum += Convert.ToInt32(row["number"]) * Decimal.Parse(row["price"] + "");
                }
                Amount += Convert.ToInt32(row["number"]) * Decimal.Parse(row["price"] + "");
            }
            ViewData["Amount"] = Amount;
            ViewData["hasRule"] = null;
            string MemberCardRuleJson = ActionController.getMemberCardIntegralRule(userweixinid, weixinid);
            Hashtable MemberCardRuleJsonobj = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJson);
            if (MemberCardRuleJsonobj["becomeMember"].ToString().ToLower() == "false")
            {
                hotel3g.Repository.MemberCardIntegralRule rule = Newtonsoft.Json.JsonConvert.DeserializeObject<hotel3g.Repository.MemberCardIntegralRule>(MemberCardRuleJsonobj["rule"].ToString());
                ViewData["hasRule"] = rule;
                if (rule.MealCouponType == 1) //立减
                {
                    sum = sum - rule.MealReduce;
                }
                //if (rule.MealCouponType == 0 && rule.MealGradeRate > 0) //折扣
                //{
                //    sum = sum * rule.MealGradeRate / 10;
                //}
            }

            //获取积分
            ViewData["orderScore"] = 0;
            ViewData["equivalence"] = 0;
            ViewData["GradePlus"] = 0;
            ViewData["IntegralRule"] = new hotel3g.Repository.MemberCardIntegralRule();
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
                ViewData["IntegralRule"] = IntegralRule;
                ViewData["orderScore"] = (int)score;
            }
            ViewData["total"] = sum;

            ViewData["storeId"] = storeId;
            ViewData["key"] = key;
            ViewData["orderCode"] = orderCode;
            ViewData["hId"] = id;

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
                ViewData["data"] = DishOrderLogic.GetTableJsonByStoreId(storeId); 
            }

            #endregion
            return View();
        }

        //购物车-立即支付
        public ActionResult toPay(int id)
        {
            string hotelId = id.ToString();
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";
            string storeId = HotelCloud.Common.HCRequest.GetString("storeId");

            int addressid = HotelCloud.Common.HCRequest.GetInt("addressid", 0);
            string linkMan = HotelCloud.Common.HCRequest.GetString("linkMan");
            string linkPhone = HotelCloud.Common.HCRequest.GetString("linkPhone");
            string roomno = HotelCloud.Common.HCRequest.GetString("roomno");
            string other = HotelCloud.Common.HCRequest.GetString("other");
            string remo = HotelCloud.Common.HCRequest.GetString("remo");
            string addressType = HotelCloud.Common.HCRequest.GetString("type");
            string hotelName = DishOrderLogic.GetHotelName(hotelId);

            //红包id， 红包金额
            string couponId = HotelCloud.Common.HCRequest.GetString("couponId");
            string couponMoney = HotelCloud.Common.HCRequest.GetString("couponMoney");

            string usetime = HotelCloud.Common.HCRequest.GetString("usetime");
            string jifen = HotelCloud.Common.HCRequest.GetString("jifen");//用餐时间
            string yhamount = HotelCloud.Common.HCRequest.GetString("yhamount");//优惠金额
          
            string manjianmoney = HotelCloud.Common.HCRequest.GetString("manjianmoney");//消费满减金额
            string manjianremo = HotelCloud.Common.HCRequest.GetString("manjianremo");//消费满减信息

            int tid = HotelCloud.Common.HCRequest.getInt("tid");//桌台号id
            string tablenumber = HotelCloud.Common.HCRequest.GetString("tablenumber");//桌台号
            int openaddress = HotelCloud.Common.HCRequest.getInt("openaddress");
            int eatatstore = HotelCloud.Common.HCRequest.getInt("eatatstore");

            int result = 0; string msg = "订单异常！";
            
            OrderInfo order = DishOrderLogic.GetOrderInfo(orderCode);
            if (order.Status == Convert.ToInt32(EnumOrderStatus.UnSubmit))
            {
                if (!DishOrderLogicA.CouponIsCanUse(couponId))
                {
                    return Json(new
                    {
                        error = 0,
                        message = "红包已经被使用过，订单提交失败！请刷新页面重新操作！"
                    });
                }
                else
                {
                    
                    int r = 1;
                    if (tid == Convert.ToInt32(EnumFromScan.非扫码))
                    {
                        if (eatatstore == Convert.ToInt32(EnumEatAtStore.外卖))
                        {
                            if (openaddress == Convert.ToInt32(EnumStoreOpenAddress.关闭))
                            {
                                hotelName = "";
                                roomno = "";
                            }

                            r = DishOrderLogic.InsertOrUpdateAddress2(addressid, linkMan, linkPhone, roomno, userweixinid, hotelName, orderCode, addressType, other, "canyin");
                        }
                        
                    }
                    
                    if (r > 0)
                    {
                        if (tid == Convert.ToInt32(EnumFromScan.非扫码))
                        {
                            if (addressType == "2")//2其他,1酒店
                            {
                                hotelName = other;
                                roomno = "";
                            }
                            if (eatatstore == Convert.ToInt32(EnumEatAtStore.堂食))
                            {
                                hotelName = "";
                                linkMan = "";
                                linkPhone = "";
                                roomno = "";
                            }
                            else
                            {
                                if (openaddress == Convert.ToInt32(EnumStoreOpenAddress.关闭))
                                {
                                    hotelName = "";
                                    roomno = "";
                                }
                            }
                        }
                        else 
                        {
                            hotelName = "";
                            linkMan = "";
                            linkPhone = "";
                            roomno = "";
                        }

                        int rows = DishOrderLogicA.SetOrderAddress_A(orderCode, linkMan, linkPhone, hotelName, roomno, remo, couponId, couponMoney,
                            order.hotelWeixinId, userweixinid, usetime, jifen, yhamount, manjianmoney, manjianremo, tablenumber, tid+"");
                        if (rows > 0)
                        {
                            DishOrderLogic.SetOrderFxmoney(order.hotelWeixinId, userweixinid, orderCode);
                            result = 1;
                            msg = "订单提交成功!";
                        }
                        else
                        {
                            result = 0;
                            msg = "异常订单！！";
                        }
                    }
                }
            }
            else if (order.Status == Convert.ToInt32(EnumOrderStatus.IsPay) || 
                order.orderPayType == Convert.ToInt32(EnumOrderPayStatus.支付成功).ToString()||
                order.Status == Convert.ToInt32(EnumOrderStatus.IsFinish)||
                order.Status == Convert.ToInt32(EnumOrderStatus.IsPeiSongZhong)||
                order.Status == Convert.ToInt32(EnumOrderStatus.IsSure))
            {
                result = order.Status;
                msg = "已支付！无需重复支付！";
            }
            else if (order.Status == Convert.ToInt32(EnumOrderStatus.IsCancel) || 
                order.Status == Convert.ToInt32(EnumOrderStatus.IsBossCancel) || 
                order.Status == Convert.ToInt32(EnumOrderStatus.IsOverTime)||
                order.Status == Convert.ToInt32(EnumOrderStatus.JudanTuikuan))
            {
                result = order.Status;
                msg = "订单已取消！";
            }
            else if (order.Status == Convert.ToInt32(EnumOrderStatus.UnPay)) 
            {
                result = 1;
                msg = "已提交，待支付订单！";
            }

           return Json(
            new
            {
                error = result,
                message = msg
            });
        }

        //订餐详情
        public ActionResult DishDetailView(int id) 
        {
            string hotelId = id.ToString();
            int storeId = HotelCloud.Common.HCRequest.GetInt("storeId", 0);//餐品商家id
            string dishId = HotelCloud.Common.HCRequest.GetString("dishId");
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string weixinid = key.Contains('@') ? key.Split('@')[0] : "";
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";

            int tid = HotelCloud.Common.HCRequest.getInt("tid");//桌台号id
            int eatatstore = Convert.ToInt32(EnumEatAtStore.外卖);
            int openaddress = Convert.ToInt32(EnumStoreOpenAddress.开启);
            StoresView store = DishOrderLogic.GetStore(storeId);
            ViewData["ordertips"] = store == null ? "" : ((store.showordertips == 1 && !string.IsNullOrEmpty(store.ordertips)) ? store.ordertips : "");//酒店设置的订单提示信息
            if (store != null) 
            {
                eatatstore = store.eatatstore;
                openaddress = store.openaddress;
            }
            ViewData["eatatstore"] = eatatstore; 
            ViewData["openaddress"] = openaddress;
            ViewData["tablenumber"] = "";//桌台号id

            OrderAddress address = new OrderAddress();
            if (tid == Convert.ToInt32(EnumFromScan.非扫码))
            {
                if (eatatstore == Convert.ToInt32(EnumEatAtStore.外卖))
                {
                    address = DishOrderLogic.GetAddress(userweixinid);
                }
            }
            else
            {
                ViewData["tablenumber"] = DishOrderLogic.GetTableNumber(tid);
            }

            ViewData["address"] = address;

            Dishses model = DishOrderLogic.GetDishsesModel(dishId);
            ViewData["model"] = model == null ? new Dishses() : model;

            #region //获取可用红包
            // scopelimit,--可以使用的范围(0:酒店订房 1:自营餐饮 2:团购预售 3:酒店超市 4:周边商家) amountlimit--消费需满多少可使用
            ViewData["couponDataTable"] = new DataTable();
            if (store != null && model.CanCouPon==1)
            {
                string scopelimit = store.Isaround == 2 ? "1" : "4";
                var couponDataTable = DishOrderLogic.GetUserCouPonDataTable(weixinid, userweixinid, scopelimit);
                if (couponDataTable.Rows.Count > 0)
                {
                    ViewData["couponDataTable"] = couponDataTable;
                }
            }
            #endregion

            //优惠政策
            ViewData["hasRule"] = null;
            decimal sum = model.price;//订单金额
            string MemberCardRuleJson = ActionController.getMemberCardIntegralRule(userweixinid, weixinid);
            Hashtable MemberCardRuleJsonobj = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJson);
            if (MemberCardRuleJsonobj["becomeMember"].ToString().ToLower() == "false")
            {
                hotel3g.Repository.MemberCardIntegralRule rule = Newtonsoft.Json.JsonConvert.DeserializeObject<hotel3g.Repository.MemberCardIntegralRule>(MemberCardRuleJsonobj["rule"].ToString());
                ViewData["hasRule"] = rule;
                if (rule.MealCouponType==1) //立减
                {
                    sum = sum - rule.MealReduce;
                }
                if (rule.MealCouponType == 0 && rule.MealGradeRate > 0 && model.CanDiscount == 1) //折扣
                {
                    sum = sum * rule.MealGradeRate / 10;
                }
            }

            //获取积分
            ViewData["orderScore"] = 0;
            ViewData["equivalence"] = 0;
            ViewData["GradePlus"] = 0;
            ViewData["IntegralRule"] = new hotel3g.Repository.MemberCardIntegralRule();
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
                ViewData["IntegralRule"] = IntegralRule;
                ViewData["orderScore"] = (int)score;
            }
            ViewData["total"] = sum;


            ViewData["storeId"] = storeId;
            ViewData["dishId"] = dishId;
            ViewData["key"] = key;
            ViewData["hId"] = id;

            // 计算消费满xx元减x元
            string youhuiids = store == null ? "" : store.YouhuiIDs;
            ViewData["youhuiids"] = youhuiids;
            ViewData["manjian_model"] = new Youhui();
            Youhui youhui = DishOrderLogic.GetYouhui(youhuiids, sum + "");
            if (youhui != null)
            {
                ViewData["manjian_model"] = youhui;
            }

            #region 桌台下拉
            if (store != null)
            {
                ViewData["data"] = DishOrderLogic.GetTableJsonByStoreId(storeId);
            }

            #endregion

            return View();
        }

        //订餐详情-立即支付
        public ActionResult DishDetailViewToPay(int id)
        {
            string hotelId = id.ToString();
            string storeId = HotelCloud.Common.HCRequest.GetString("storeId");
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";
            string hotelWeiXinID = key.Contains('@') ? key.Split('@')[0] : "";

            int addressid = HotelCloud.Common.HCRequest.GetInt("addressid", 0);
            string linkMan = HotelCloud.Common.HCRequest.GetString("linkMan");
            string linkPhone = HotelCloud.Common.HCRequest.GetString("linkPhone");
            string roomno = HotelCloud.Common.HCRequest.GetString("roomno");
            string other = HotelCloud.Common.HCRequest.GetString("other");
            string remo = HotelCloud.Common.HCRequest.GetString("remo");
            string addressType = HotelCloud.Common.HCRequest.GetString("type");
            string hotelName = DishOrderLogic.GetHotelName(hotelId);

            string dishId = HotelCloud.Common.HCRequest.GetString("dishId");
            int foodnum = HotelCloud.Common.HCRequest.GetInt("foodnum", 0);

            string couponId = HotelCloud.Common.HCRequest.GetString("couponId");//红包id，
            string couponMoney = HotelCloud.Common.HCRequest.GetString("couponMoney");//红包金额
            string usetime = HotelCloud.Common.HCRequest.GetString("usetime");//用餐时间
            string jifen = HotelCloud.Common.HCRequest.GetString("jifen");//用餐时间
            string yhamount = HotelCloud.Common.HCRequest.GetString("yhamount");//优惠金额

            string manjianmoney = HotelCloud.Common.HCRequest.GetString("manjianmoney");//消费满减金额
            string manjianremo = HotelCloud.Common.HCRequest.GetString("manjianremo");//消费满减信息
            
            string disc = HotelCloud.Common.HCRequest.GetString("discount");//折扣
            decimal discount = 0;
            decimal.TryParse(disc, out discount);

            string tablenumber = HotelCloud.Common.HCRequest.GetString("tablenumber");//桌台号
            int openaddress = HotelCloud.Common.HCRequest.getInt("openaddress");
            int eatatstore = HotelCloud.Common.HCRequest.getInt("eatatstore");

            int tid = HotelCloud.Common.HCRequest.getInt("tid");//桌台号id

            if (!DishOrderLogicA.CouponIsCanUse(couponId))
            {
                return Json(new
                {
                    error = 0,
                    message = "红包已经被使用过，订单提交失败！请刷新页面重新操作！"
                });
            }
            else
            {
                //新单号
                string newOrderCode = DishOrderLogicA.GetOrderACode(hotelId, "-1", userweixinid, EnumOrderStatus.UnSubmit);
                if (tid == Convert.ToInt32(EnumFromScan.非扫码))
                {
                    if (eatatstore == Convert.ToInt32(EnumEatAtStore.外卖))
                    {
                        if (openaddress == Convert.ToInt32(EnumStoreOpenAddress.关闭))
                        {
                            roomno = ""; hotelName = ""; other = "";
                        }
                        int r = DishOrderLogic.InsertOrUpdateAddress2(addressid, linkMan, linkPhone, roomno, userweixinid, hotelName, newOrderCode, addressType, other, "canyin");
                    }
                }

                StoresView store = DishOrderLogic.GetStore(Convert.ToInt32(storeId));
                Dishses model = DishOrderLogic.GetDishsesModel(dishId);

                if (tid == Convert.ToInt32(EnumFromScan.非扫码))
                {
                    if (addressType == "2")//2其他,1酒店
                    {
                        hotelName = other;
                        roomno = "";
                    }
                    if (openaddress == Convert.ToInt32(EnumStoreOpenAddress.关闭))
                    {
                        roomno = ""; hotelName = ""; other = "";
                    }
                    if (eatatstore == Convert.ToInt32(EnumEatAtStore.堂食))
                    {
                        hotelName = ""; linkMan = ""; linkPhone = ""; roomno = ""; other = "";
                    }
                }
                else
                {
                    hotelName = ""; linkMan = ""; linkPhone = ""; roomno = ""; other = "";
                }

                int rows = DishOrderLogicA.CreateOrder_A(newOrderCode, model, store, foodnum, hotelId, userweixinid, hotelWeiXinID, hotelName, roomno,
                    linkMan, linkPhone, remo, couponId, couponMoney, usetime, jifen, yhamount,discount,manjianmoney,manjianremo,tablenumber,tid+"");
                if (rows > 0)
                {
                    DishOrderLogic.SetOrderFxmoney(hotelWeiXinID, userweixinid, newOrderCode);
                }
                return Json(new
                {
                    error = rows > 0 ? 1 : 0,
                    message = rows > 0 ? "订单提交成功！" : "订单提交失败！",
                    orderCode = newOrderCode
                });
            }
        }

        //订餐详情【图文模式】
        public ActionResult DishDetailView_Rich(int id) 
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string weixinid = key.Contains('@') ? key.Split('@')[0] : "";
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";

            string storeId = HotelCloud.Common.HCRequest.GetString("storeId");
            string dishId = HotelCloud.Common.HCRequest.GetString("dishId");

            Dishses model = DishOrderLogic.GetDishsesModel(dishId);
            ViewData["model"] = model == null ? new Dishses() : model;

            Stores store = DishOrderLogic.GetStore(Convert.ToInt32(storeId));
            ViewData["hotelName"] = store == null ? DishOrderLogic.GetHotelName(id + "") : store.StoreName;

            ViewData["dishId"] = dishId;
            ViewData["storeId"] = storeId;
            ViewData["hId"] = id;
            ViewData["key"] = key;
            return View();
        }

        //餐厅预订
        public ActionResult BookDiningRoom(int id) 
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            int DiningRoomID = HotelCloud.Common.HCRequest.getInt("DiningRoomID",0);

            //DiningRoom room = DishOrderLogicA.GetDiningRoomModel(DiningRoomID);
            StoresView room = DishOrderLogic.GetStore(DiningRoomID);//周边选中商
            
            ViewData["room"] = room;
            ViewData["roomId"] = DiningRoomID;
            ViewData["key"] = key;
            ViewData["hId"] = id;
            return View();
        }


//        select top 1 OrderNO,LinkTel,UserName,demo as sex,UserWeiXinID,HotelID,HotelName,WeixinID,RoomID,RoomName,
//yinDate,lastTime,yRoomNum as useNumber,Ordertime,state,remark,isMeeting from HotelOrder where isMeeting =9
        
        //餐厅预订订单
        public ActionResult Booking(int id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string hotelweixinid = key.Contains('@') ? key.Split('@')[0] : "";
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";

            DiningRoomOrder model = new DiningRoomOrder();
            model.LinkMan = HotelCloud.Common.HCRequest.GetString("lianxiren");
            model.LinkPhone = HotelCloud.Common.HCRequest.GetString("lianxidianhua");
            model.Sex = HotelCloud.Common.HCRequest.GetString("sex") == "1" ? "先生" : "女士";
            model.UseDate = HotelCloud.Common.HCRequest.GetString("usedate");
            model.UseTime = HotelCloud.Common.HCRequest.GetString("usetime");
            model.UseNuber = HotelCloud.Common.HCRequest.getInt("number");
            model.Beizhu = HotelCloud.Common.HCRequest.GetString("beizhu");
            model.DROrderCode = DishOrderLogicA.GetNewDiningRoomOrderCode();
            model.DiningRoomID = HotelCloud.Common.HCRequest.getInt("roomId", 0);
            model.userweixinid = userweixinid;
            //DiningRoom d = DishOrderLogicA.GetDiningRoomModel(model.DiningRoomID);
            //model.DiningRoomName = d == null ? "" : d.DiningRoomName;//商家作为餐厅
            model.DiningRoomName = SQLHelper.Get_Value("select top 1 StoreName from T_Stores where StoreId=" + model.DiningRoomID, SQLHelper.GetCon(), null);

            model.hotelId = id.ToString();
            model.hotelweixinid = hotelweixinid;
            model.hotelName = DishOrderLogic.GetHotelName(model.hotelId);
            model.State = 0;
            model.CreateTime = DateTime.Now.ToString();

            if (string.IsNullOrEmpty(model.DiningRoomName))
            {
                return Json(new
                {
                    error = 0,
                    message = string.Format("无效的餐厅ID {0}，预订失败!", model.DiningRoomID)
                });
            }

            string msg = "餐厅预订失败！";
            int rows = 0;
            if (model.UseNuber > 0)
            {
                rows = DishOrderLogicA.CreateBookingDiningRoomOrder(model);
                if (rows > 0)
                {
                    msg = "餐厅预订成功";
                    try
                    {
                        string str = Newtonsoft.Json.JsonConvert.SerializeObject(model);
                        string sql = "insert into T_DiningRoomOrder(DROrderCode,DiningRoomName,Beizhu,CreateTime)values(@DROrderCode,'对应HotelOrder餐厅预订信息',@Beizhu,GETDATE())";
                        SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
                {"DROrderCode",new DBParam(){ParamValue=model.DROrderCode}},
                {"Beizhu",new DBParam(){ParamValue=str}}
                });
                    }
                    catch { }
                }
            }
            else
            {
                msg = "餐厅预订用餐人数不能少于1人！";
            }

            return Json(new
            {
                error = rows > 0 ? 1 : 0,
                message = msg
            });
        }

        #endregion

        #region 餐饮订单详情

        public ActionResult ViewOrderDetail(int id)
        {
            int storeId = HotelCloud.Common.HCRequest.GetInt("storeId", 0);//餐品商家id
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");

            DataTable dt_dish = DishOrderLogic.GetDishTableForPay(orderCode);
            decimal Amount = 0;
            decimal YouhuiMoney = 0;
            decimal Bagging = 0;
            decimal PayAmount = 0, CouponMoney = 0;
            string remo = "";
            string userNumber = "", willArriveTime = "", songcanyuan = "", songcanphone = "", songcantime = "", usetime = "", jifen="0";

            ViewData["tablenumberid"] = 0;
            int Status = -110;
            if (dt_dish.Rows.Count > 0)
            {
                Status = Convert.ToInt32(dt_dish.Rows[0]["Status"]);

                storeId = Convert.ToInt32(dt_dish.Rows[0]["storeID"]);
                Amount = Convert.ToDecimal(dt_dish.Rows[0]["amount"]);
                YouhuiMoney = Convert.ToDecimal(dt_dish.Rows[0]["youhuiamount"]);
                Bagging = Convert.ToDecimal(dt_dish.Rows[0]["bagging"]);
                PayAmount = Convert.ToDecimal(dt_dish.Rows[0]["payamount"]);//Amount - YouhuiMoney + Bagging;//支付金额=订单总金额-优惠金额+打包费用-红包
                remo = Convert.ToString(dt_dish.Rows[0]["remo"]);
                CouponMoney = Convert.ToDecimal(dt_dish.Rows[0]["CouponMoney"]);

                
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
                ViewData["submitTime"] = dt_dish.Rows[0]["submitTime"] + "";
                ViewData["payTime"] = dt_dish.Rows[0]["payTime"] + "";
                ViewData["payType"] = dt_dish.Rows[0]["orderPayType"] + "";
                ViewData["sureTime"] = dt_dish.Rows[0]["sureTime"] + "";
                ViewData["finishTime"] = dt_dish.Rows[0]["finishTime"] + "";

                ViewData["manjianremo"] = dt_dish.Rows[0]["manjianremo"] + "";
                ViewData["tablenumber"] = dt_dish.Rows[0]["tablenumber"] + "";
                ViewData["tablenumberid"] = dt_dish.Rows[0]["tablenumberid"] + "";
            }

            #region 状态

            if (Status == Convert.ToInt32(EnumOrderStatus.IsOverTime) ||
                Status == Convert.ToInt32(EnumOrderStatus.IsCancel) ||
                Status == Convert.ToInt32(EnumOrderStatus.JudanTuikuan) ||
                Status == Convert.ToInt32(EnumOrderStatus.IsBossCancel) ||
                Status == 2) //2,3,11,13
            {
                ViewData["StatusName"] = "取消";
                ViewData["cue"] = "订单已取消";
            }
            if (Status == Convert.ToInt32(EnumOrderStatus.IsSure))
            {
                ViewData["StatusName"] = "已确认";
                ViewData["cue"] = "商家已接单，稍后配送";
            }
            if (Status == Convert.ToInt32(EnumOrderStatus.UnPay))
            {
                ViewData["StatusName"] = "待付款";
                ViewData["cue"] = "等待买家付款";
            }
            if (Status == Convert.ToInt32(EnumOrderStatus.IsPay))
            {
                ViewData["StatusName"] = "已付款";
                ViewData["cue"] = "等待商家处理订单";
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
                ViewData["cue"] = "商家正在配送中";
            }

            #endregion

            ViewData["Status"] = Status;
            ViewData["ordertips"] = "";
            StoresView store = DishOrderLogic.GetStore(storeId);
            if (store != null)
            {
                ViewData["storeName"] = store.StoreName;
                ViewData["youhuiRemo"] = store.Remo;
                ViewData["storePhone"] = store.StorePhone;
                ViewData["ordertips"] = (store.showordertips == 1 && !string.IsNullOrEmpty(store.ordertips)) ? store.ordertips : "";//酒店设置的订单提示信息
            }

            ViewData["dt_dish"] = dt_dish;
            ViewData["PayAmount"] = PayAmount;
            ViewData["CouponMoney"] = CouponMoney;
            ViewData["YouhuiMoney"] = YouhuiMoney;
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

            //ViewData["HasDianPing"] = string.IsNullOrEmpty(r);

            return View();
        }

        public ActionResult ViewOrderDetail_blue(int id)
        {
            int storeId = HotelCloud.Common.HCRequest.GetInt("storeId", 0);//餐品商家id
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");

            DataTable dt_dish = DishOrderLogic.GetDishTableForPay(orderCode);
            decimal Amount = 0, CouponMoney = 0;
            decimal YouhuiMoney = 0;
            decimal Bagging = 0;
            decimal PayAmount = 0;
            string remo = "";
            string userNumber = "", willArriveTime = "", songcanyuan = "", songcanphone = "", songcantime = "", usetime = "", jifen = "0";

            ViewData["tablenumberid"] =0;
            int Status = -110;
            if (dt_dish.Rows.Count > 0)
            {
                Status = Convert.ToInt32(dt_dish.Rows[0]["Status"]);

                CouponMoney = Convert.ToDecimal(dt_dish.Rows[0]["CouponMoney"]);
                Amount = Convert.ToDecimal(dt_dish.Rows[0]["amount"]);
                YouhuiMoney = Convert.ToDecimal(dt_dish.Rows[0]["youhuiamount"]);
                Bagging = Convert.ToDecimal(dt_dish.Rows[0]["bagging"]);
                PayAmount = Convert.ToDecimal(dt_dish.Rows[0]["payamount"]);//Amount - YouhuiMoney + Bagging;//支付金额=订单总金额-优惠金额+打包费用-红包
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
                ViewData["submitTime"] = dt_dish.Rows[0]["submitTime"] + "";
                ViewData["payTime"] = dt_dish.Rows[0]["payTime"] + "";
                ViewData["payType"] = dt_dish.Rows[0]["orderPayType"] + "";
                ViewData["sureTime"] = dt_dish.Rows[0]["sureTime"] + "";
                ViewData["finishTime"] = dt_dish.Rows[0]["finishTime"] + "";

                ViewData["manjianremo"] = dt_dish.Rows[0]["manjianremo"] + "";
                ViewData["tablenumber"] = dt_dish.Rows[0]["tablenumber"] + "";
                ViewData["tablenumberid"] = dt_dish.Rows[0]["tablenumberid"] + "";
            }

            #region 状态

            if (Status == Convert.ToInt32(EnumOrderStatus.IsOverTime) ||
                Status == Convert.ToInt32(EnumOrderStatus.IsCancel) ||
                Status == Convert.ToInt32(EnumOrderStatus.JudanTuikuan) ||
                Status == Convert.ToInt32(EnumOrderStatus.IsBossCancel) ||
                Status == 2) //2,3,11,13
            {
                ViewData["StatusName"] = "取消";
                ViewData["cue"] = "订单已取消";
            }
            if (Status == Convert.ToInt32(EnumOrderStatus.IsSure))
            {
                ViewData["StatusName"] = "已确认";
                ViewData["cue"] = "商家已接单，稍后配送";
            }
            if (Status == Convert.ToInt32(EnumOrderStatus.UnPay))
            {
                ViewData["StatusName"] = "待付款";
                ViewData["cue"] = "等待买家付款";
            }
            if (Status == Convert.ToInt32(EnumOrderStatus.IsPay))
            {
                ViewData["StatusName"] = "已付款";
                ViewData["cue"] = "等待商家处理订单";
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
                ViewData["cue"] = "商家正在配送中";
            }

            #endregion

            ViewData["Status"] = Status;
            ViewData["ordertips"] = "";
            StoresView store = DishOrderLogic.GetStore(storeId);
            if (store != null)
            {
                ViewData["storeName"] = store.StoreName;
                ViewData["youhuiRemo"] = store.Remo;
                ViewData["storePhone"] = store.StorePhone;
                ViewData["ordertips"] = (store.showordertips == 1 && !string.IsNullOrEmpty(store.ordertips)) ? store.ordertips : "";//酒店设置的订单提示信息
            }

            ViewData["dt_dish"] = dt_dish;
            ViewData["PayAmount"] = PayAmount;
            ViewData["CouponMoney"] = CouponMoney;
            ViewData["YouhuiMoney"] = YouhuiMoney;
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

            //ViewData["HasDianPing"] = string.IsNullOrEmpty(r);

            return View();
        }
        #endregion


        #region 餐厅订单详情

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

        //取消餐厅订单
        public ActionResult CancelDiningRoomOrder(int id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            DataTable dt = DishOrderLogicA.GetDiningRoomOrderInfo(orderCode);
            int Status = -110;
            if (dt.Rows.Count > 0)
            {
                int.TryParse(dt.Rows[0]["state"] + "", out Status);
            }

            if (Status == Convert.ToInt32(EnumDiningRoomOrderStatus.待跟进))
            {
                int rows = DishOrderLogicA.UpdateDiningRoomOrderStatus(orderCode, EnumDiningRoomOrderStatus.取消);
                if (rows > 0)
                {
                    return Json(new { error = 1, message = "取消成功" });
                }
                else
                {
                    return Json(new { error = 0, message = "取消失败" });
                }
            }
            else if (Status == Convert.ToInt32(EnumDiningRoomOrderStatus.跟进中))
            {
                return Json(new { error = 0, message = "订单酒店正跟进中" });
            }
            else if (Status == Convert.ToInt32(EnumDiningRoomOrderStatus.跟进完成))
            {
                return Json(new { error = 0, message = "订单跟进完成" });
            }
            else if (Status == Convert.ToInt32(EnumDiningRoomOrderStatus.取消))
            {
                return Json(new { error = 0, message = "订单已取消" });
            }
            else
            {
                return Json(new { error = 0, message = "订单信息异常" });
            }
        }
        #endregion

        #region 取消订单,确认收货[订单完成]

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
            int rows = 0;
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









        #region 订单支付

        //首页选好餐品跳转页面(已生成待支付订单)
        public ActionResult PagePay(int id)
        {
            string hotelId = id.ToString();
            int storeId = HotelCloud.Common.HCRequest.GetInt("storeId",0);//餐品商家id
            string key = HotelCloud.Common.HCRequest.GetString("key");//"酒店微信id@用户微信id"
            string userweixinid = key.Contains('@') ? key.Split('@')[1] : "";
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            if (string.IsNullOrEmpty(orderCode))
            {
                orderCode = DishOrderLogic.GetOrderCode(hotelId, storeId.ToString(), userweixinid,EnumOrderStatus.UnSubmit);
            }

            OrderAddress address = DishOrderLogic.GetAddress(userweixinid);

            StoresView store = DishOrderLogic.GetStore(storeId);
            decimal Bg = 0;
            if (store != null)
            {
                ViewData["storeName"] = store.StoreName;
                ViewData["youhuiRemo"] = store.Remo;
                ViewData["bagging"] = store.bagging;
                Bg = store.bagging;
            }
            int yongjin = store == null ? 0 : store.yongjin; //佣金点

            int rows = DishOrderLogic.SettingOrderInfoByOrderCode(orderCode, address,Bg, yongjin);//设置订单信息
           

            DataTable dt_dish =DishOrderLogic.GetDishTableForPay(orderCode);
            decimal Amount = 0;
            decimal YouhuiMoney =  0;
            decimal Bagging = 0;
            decimal PayAmount =  0;
            string remo = "";
            string userNumber = "";
            if (dt_dish.Rows.Count > 0)
            {
                Amount = Convert.ToDecimal(dt_dish.Rows[0]["amount"]);
                YouhuiMoney = Convert.ToDecimal(dt_dish.Rows[0]["youhuiamount"]);
                Bagging = Convert.ToDecimal(dt_dish.Rows[0]["bagging"]);
                PayAmount = Convert.ToDecimal(dt_dish.Rows[0]["payamount"]); //Amount - YouhuiMoney + Bagging;//支付金额=订单总金额-优惠金额
                remo = Convert.ToString(dt_dish.Rows[0]["remo"]);
                userNumber = Convert.ToString(dt_dish.Rows[0]["userNumber"]);

                
            }


            ViewData["hotelName"] = string.IsNullOrEmpty(address.Address) ? DishOrderLogic.GetHotelName(hotelId) : address.Address;
            ViewData["dt_dish"] = dt_dish;
            ViewData["PayAmount"] = PayAmount;
            ViewData["YouhuiMoney"] = YouhuiMoney;
            ViewData["remo"] = remo;
            ViewData["userNumber"] = userNumber;
            ViewData["address"] = address;

            ViewData["hId"] = hotelId;
            ViewData["storeId"] = storeId;
            ViewData["orderCode"] = orderCode;
            ViewData["key"] = key;
            ViewData["isview"] = HotelCloud.Common.HCRequest.GetInt("isview",0);
            return View();
        }

        public ActionResult PaySuccess(int id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            OrderInfo orderinfo = DishOrderLogic.GetOrderInfo(orderCode);
            OrderAddress address = DishOrderLogic.GetAddress(orderinfo.userweixinid);
            string hotelName=DishOrderLogic.GetHotelName(orderinfo.hotelid+"");
            Stores store = DishOrderLogic.GetStore(orderinfo.storeID);

            ViewData["songdashijian"] = store==null?"":store.yujisongdashijian;
            ViewData["hotelName"] = hotelName;
            ViewData["model"] = orderinfo;
            ViewData["address"] = address;

            ViewData["key"] = key;
            ViewData["hId"] = id;
            return View();
        }

        public ActionResult PayFail(int id)
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            string orderCode = HotelCloud.Common.HCRequest.GetString("orderCode");
            OrderInfo orderinfo = DishOrderLogic.GetOrderInfo(orderCode);
            OrderAddress address = DishOrderLogic.GetAddress(orderinfo.userweixinid);
            string hotelName = DishOrderLogic.GetHotelName(orderinfo.hotelid + "");
            Stores store = DishOrderLogic.GetStore(orderinfo.storeID);

            if (orderinfo.orderId > 0) 
            {
                CalculateTime(orderinfo.orderCode, orderinfo.submitTime, orderinfo.Status);
            }

            ViewData["songdashijian"] = store == null ? "" : store.yujisongdashijian;
            ViewData["hotelName"] = hotelName;
            ViewData["model"] = orderinfo;
            ViewData["address"] = address;

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
            int fromview = HotelCloud.Common.HCRequest.getInt("fromview",0);//

            OrderInfo order = DishOrderLogic.GetOrderInfo(orderCode);
            if (order.orderId > 0)
            {
                if (order.Status == Convert.ToInt32(EnumOrderStatus.UnSubmit))
                {
                    int rows = DishOrderLogic.UpdateOrderStatusByOrderCode(orderCode, EnumOrderStatus.UnPay);//提交订单
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
            
            //if (fromview != 1) //生成订单页面提交支付 pagepay
            //{
               
            //}
            //else  //订单详细页面提交支付 vieworderdetail
            //{
               
            //}
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

            int rows = DishOrderLogic.InsertOrUpdateAddress2(addressid, name, phone, room, userweixinid, address, orderCode, type, kdaddress, "canyin");
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
            string content = string.Format("餐饮配送手机验证码 {0}[微可牛]", code);
            string url = string.Format("http://app.hotelhotel.cn/api/sentsms.ashx?mobile={0}&content={1}", phone, content);
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

        //public ActionResult UploadDianPingImg()
        //{
        //    System.Collections.Hashtable hash = new System.Collections.Hashtable();

        //    string StroeId = HotelCloud.Common.HCRequest.GetString("StroeId");//商家storeid
        //    int tmpId = 0;
        //    int.TryParse(StroeId, out tmpId);
        //    if (tmpId <= 0)
        //    {
        //        hash["error"] = 1;
        //        hash["message"] = "商家信息未异常";
        //    }

        //    HttpPostedFileBase file = Request.Files["imgFile"];

        //    if (file == null)
        //    {
        //        hash["error"] = 1;
        //        hash["message"] = "请选择文件";
        //        return Json(hash);
        //    }
        //    int maxSize = 1000000;
        //    string fileTypes = WeiXinPublic.ConfigManage.Get("ImageType", "gif,jpg,png");
        //    string fileName = file.FileName;
        //    string fileExt = Path.GetExtension(fileName).ToLower();
        //    System.Collections.ArrayList fileTypeList = System.Collections.ArrayList.Adapter(fileTypes.Split(','));
        //    if (file != null)
        //    {
        //        if (!fileTypeList.Contains(fileExt.Substring(1)))
        //        {
        //            hash["error"] = 1;
        //            hash["message"] = "文件类型不正确,支持" + fileTypes;
        //            return Json(hash);
        //        }
        //    }

        //    if (file.InputStream == null || file.InputStream.Length > maxSize)
        //    {
        //        hash["error"] = 1;
        //        hash["message"] = "上传文件大小超过限制";
        //        return Json(hash);
        //    }
        //    string newFileName = string.Format("/img/store/{0}/dianping/", StroeId) + DateTime.Now.ToString("yyyyMMddHHmmss_ffff", System.Globalization.DateTimeFormatInfo.InvariantInfo) + fileExt;
        //    byte[] imgByte = new byte[file.ContentLength];
        //    img.Upload up = new img.Upload();
        //    try
        //    {
        //        file.InputStream.Read(imgByte, 0, file.ContentLength);
        //        if (imgByte != null && up.UpLoadImg("uoeqoirw0934210890adsflad23", newFileName, imgByte))
        //        {
        //            //插入表
        //            StoreImg img = new StoreImg();
        //            img.imgUrl = WeiXinPublic.ConfigManage.Get("ImageWebSite") + newFileName; ;
        //            img.storeID = Convert.ToInt32(DianPuID);
        //            img.createtime = DateTime.Now;
        //            img.imgTitle = "商家图片";

        //            string id = StoreImg.Save(img);
        //            hash["error"] = 0;
        //            hash["url"] = img.imgUrl + "#" + id;
        //        }
        //        else
        //        {
        //            hash["error"] = 1;
        //            hash["message"] = "图片保存失败,请稍后再试！";
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        new Common.LogManage().Error("图片上传错误UpLoadImage Exception:" + ex.Message.ToString());
        //        hash["error"] = 1;
        //        hash["message"] = "图片保存失败,请稍后再试！";
        //    }

        //    return Json(hash);
        //}

        #endregion

    }
   
}
