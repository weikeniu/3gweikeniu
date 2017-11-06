using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using WeiXin.Common;
namespace WeiXin.Models.Home
{

    /// <summary>
    /// 预售产品
    /// </summary>
    public class SaleProduct
    {
        public int Id { get; set; }
        public string WeiXinId { get; set; }
        public int UserId { get; set; }
        public int HotelId { get; set; }
        public int ProductType { get; set; }
        public string ProductName { get; set; }
        public int ProductNum { get; set; }
        public DateTime BeginTime { get; set; }
        public DateTime EndTime { get; set; }
        public DateTime EffectiveBeginTime { get; set; }
        public DateTime EffectiveEndTime { get; set; }
        public DateTime LastUpdatetime { get; set; }

        public decimal ProductPrice { get; set; }
        public string DetailDes { get; set; }
        public string SaleChannel { get; set; }
        public int Status { get; set; }


        public string FeeInclude { get; set; }
        public string FeeExclude { get; set; }
        public string OrderInfo { get; set; }
        public string RefundInfo { get; set; }
        public string ImageList { get; set; }
        public string SmallImageList { get; set; }
        public string BigImageList { get; set; }


        public int IsOnlineTaobao { get; set; }
        public int IsOnlineQunar { get; set; }
        public int SysStatus { get; set; }

        public string MainPic { get; set; }
        public string BigMainPic { get; set; }
        public string SmallMainPic { get; set; }

        public string Tab { get; set; }
        public decimal MenPrice { get; set; }

        public int IsUsehongbao { get; set; }

        public List<Models.Home.SaleProducts_TC> List_SaleProducts_TC { get; set; }

        public string Json_SaleProducts_TC { get; set; }


        public static DataTable GetHotelInfo(string weixinId)
        {
            return DAL.SaleProduct.GetHotelInfo(weixinId);
        }

        public static List<SaleProduct> GetSaleProducts(string weiXinID, out int count, int page, int pagesize, string select, string query)
        {

            var dt = DAL.SaleProduct.GetSaleProducts(weiXinID, out count, page, pagesize, select, query);
            List<SaleProduct> saleProductList = new List<SaleProduct>();
            foreach (System.Data.DataRow dr in dt.Rows)
            {
                SaleProduct saleProduct = new SaleProduct();
                saleProduct.Id = Convert.ToInt32(dr["id"].ToString());
                saleProduct.WeiXinId = dr["WeiXinId"].ToString();

                saleProduct.HotelId = Convert.ToInt32(dr["HotelId"].ToString());
                saleProduct.ProductType = Convert.ToInt32(dr["ProductType"].ToString());

                saleProduct.ProductName = dr["ProductName"].ToString();
                saleProduct.ProductNum = Convert.ToInt32(dr["ProductNum"].ToString());
                saleProduct.BeginTime = Convert.ToDateTime(dr["BeginTime"].ToString());
                saleProduct.EndTime = Convert.ToDateTime(dr["EndTime"].ToString());

                saleProduct.EffectiveBeginTime = Convert.ToDateTime(dr["EffectiveBeginTime"].ToString());
                saleProduct.EffectiveEndTime = Convert.ToDateTime(dr["EffectiveEndTime"].ToString());


                saleProduct.ProductPrice = Convert.ToDecimal(dr["ProductPrice"].ToString());
                saleProduct.DetailDes = dr["DetailDes"].ToString();
                saleProduct.SaleChannel = dr["SaleChannel"].ToString();

                saleProduct.Status = Convert.ToInt32(dr["Status"].ToString());
                saleProduct.LastUpdatetime = Convert.ToDateTime(dr["LastUpdateTime"].ToString());

                saleProduct.FeeInclude = dr["FeeInclude"].ToString();
                saleProduct.FeeExclude = dr["FeeExclude"].ToString();

                saleProduct.OrderInfo = dr["OrderInfo"].ToString();
                saleProduct.RefundInfo = dr["RefundInfo"].ToString();
                saleProduct.ImageList = dr["ImageList"].ToString();
                saleProduct.SmallImageList = dr["SmallImageList"].ToString();
                saleProduct.BigImageList = dr["BigImageList"].ToString();

                saleProduct.IsOnlineTaobao = Convert.ToInt32(dr["IsOnlineTaobao"].ToString());
                saleProduct.IsOnlineQunar = Convert.ToInt32(dr["IsOnlineQunar"].ToString());
                saleProduct.SysStatus = Convert.ToInt32(dr["SysStatus"].ToString());

                saleProductList.Add(saleProduct);
            }

            return saleProductList;

        }



        public static List<ProductEntity> GetSaleProductsListIndex(string weiXinID, out int count, int page, int pagesize, string select, string query)
        {

            var dt = DAL.SaleProduct.GetSaleProductsListIndex(weiXinID, out count, page, pagesize, select, query);
            var list = ProductEntity.ConvertProductEntityIndexList(dt);

            return list;
        }



        public static List<ProductEntity> GetSaleProductsListIndexA(string weiXinID, out int count, int page, int pagesize, string select, string query)
        {

            var dt = DAL.SaleProduct.GetSaleProductsListIndex(weiXinID, out count, page, pagesize, select, query);
            var list = ProductEntity.ConvertProductEntityIndexListA(dt);

            return list;
        }


        public static SaleProduct GetSaleProduct(string weiXinID, int saleProductId)
        {
            var dt = DAL.SaleProduct.GetSaleProduct(weiXinID, saleProductId);
            SaleProduct saleProduct = new SaleProduct();

            foreach (System.Data.DataRow dr in dt.Rows)
            {

                saleProduct.Id = Convert.ToInt32(dr["id"].ToString());
                saleProduct.WeiXinId = dr["WeiXinId"].ToString();

                saleProduct.HotelId = Convert.ToInt32(dr["HotelId"].ToString());
                saleProduct.ProductType = Convert.ToInt32(dr["ProductType"].ToString());

                saleProduct.ProductName = dr["ProductName"].ToString();
                saleProduct.ProductNum = Convert.ToInt32(dr["ProductNum"].ToString());
                saleProduct.BeginTime = Convert.ToDateTime(dr["BeginTime"].ToString());
                saleProduct.EndTime = Convert.ToDateTime(dr["EndTime"].ToString());

                saleProduct.EffectiveBeginTime = Convert.ToDateTime(dr["EffectiveBeginTime"].ToString());
                saleProduct.EffectiveEndTime = Convert.ToDateTime(dr["EffectiveEndTime"].ToString());


                saleProduct.ProductPrice = Convert.ToDecimal(dr["ProductPrice"].ToString());
                saleProduct.DetailDes = dr["DetailDes"].ToString();
                saleProduct.SaleChannel = dr["SaleChannel"].ToString();

                saleProduct.Status = Convert.ToInt32(dr["Status"].ToString());
                saleProduct.LastUpdatetime = Convert.ToDateTime(dr["LastUpdateTime"].ToString());

                saleProduct.FeeInclude = dr["FeeInclude"].ToString();
                saleProduct.FeeExclude = dr["FeeExclude"].ToString();

                saleProduct.OrderInfo = dr["OrderInfo"].ToString();
                saleProduct.RefundInfo = dr["RefundInfo"].ToString();
                saleProduct.ImageList = dr["ImageList"].ToString();

                saleProduct.SmallImageList = dr["SmallImageList"].ToString();
                saleProduct.BigImageList = dr["BigImageList"].ToString();

                saleProduct.IsOnlineTaobao = Convert.ToInt32(dr["IsOnlineTaobao"].ToString());
                saleProduct.IsOnlineQunar = Convert.ToInt32(dr["IsOnlineQunar"].ToString());
                saleProduct.SysStatus = Convert.ToInt32(dr["SysStatus"].ToString());

                saleProduct.MenPrice = Convert.ToDecimal(dr["MenPrice"].ToString());
                saleProduct.MainPic = dr["MainPic"].ToString();
                saleProduct.Tab = dr["Tab"].ToString();
                saleProduct.BigMainPic = dr["BigMainPic"].ToString();
                saleProduct.SmallMainPic = dr["SmallMainPic"].ToString();

                saleProduct.IsUsehongbao = Convert.ToInt32(dr["IsUsehongbao"].ToString());

            }

            return saleProduct;
        }


        public static SaleProduct GetSaleProduct(int saleProductId)
        {
            var dt = DAL.SaleProduct.GetSaleProduct(saleProductId);
            SaleProduct saleProduct = new SaleProduct();

            foreach (System.Data.DataRow dr in dt.Rows)
            {

                saleProduct.Id = Convert.ToInt32(dr["id"].ToString());
                saleProduct.WeiXinId = dr["WeiXinId"].ToString();

                saleProduct.HotelId = Convert.ToInt32(dr["HotelId"].ToString());
                saleProduct.ProductType = Convert.ToInt32(dr["ProductType"].ToString());

                saleProduct.ProductName = dr["ProductName"].ToString();
                saleProduct.ProductNum = Convert.ToInt32(dr["ProductNum"].ToString());
                saleProduct.BeginTime = Convert.ToDateTime(dr["BeginTime"].ToString());
                saleProduct.EndTime = Convert.ToDateTime(dr["EndTime"].ToString());

                saleProduct.EffectiveBeginTime = Convert.ToDateTime(dr["EffectiveBeginTime"].ToString());
                saleProduct.EffectiveEndTime = Convert.ToDateTime(dr["EffectiveEndTime"].ToString());


                saleProduct.ProductPrice = Convert.ToDecimal(dr["ProductPrice"].ToString());
                saleProduct.DetailDes = dr["DetailDes"].ToString();
                saleProduct.SaleChannel = dr["SaleChannel"].ToString();

                saleProduct.Status = Convert.ToInt32(dr["Status"].ToString());
                saleProduct.LastUpdatetime = Convert.ToDateTime(dr["LastUpdateTime"].ToString());

                saleProduct.FeeInclude = dr["FeeInclude"].ToString();
                saleProduct.FeeExclude = dr["FeeExclude"].ToString();

                saleProduct.OrderInfo = dr["OrderInfo"].ToString();
                saleProduct.RefundInfo = dr["RefundInfo"].ToString();
                saleProduct.ImageList = dr["ImageList"].ToString();

                saleProduct.SmallImageList = dr["SmallImageList"].ToString();
                saleProduct.BigImageList = dr["BigImageList"].ToString();

                saleProduct.IsOnlineTaobao = Convert.ToInt32(dr["IsOnlineTaobao"].ToString());
                saleProduct.IsOnlineQunar = Convert.ToInt32(dr["IsOnlineQunar"].ToString());
                saleProduct.SysStatus = Convert.ToInt32(dr["SysStatus"].ToString());

            }

            return saleProduct;
        }





        public static int GetSaleProductMinPrice(int productSaleId, int productType)
        {
            return DAL.SaleProduct.GetSaleProductMinPrice(productSaleId, productType);

        }


        public static int AddSaleProduct(SaleProduct model)
        {
            int Id = DAL.SaleProduct.AddSaleProductSale(model);

            return Id;

        }


        public static int UpdateSaleProduct(SaleProduct model)
        {
            int row = DAL.SaleProduct.UpdateSaleProductSale(model);

            return row;

        }




    }




    public class SaleProducts_TC
    {
        public int Id { get; set; }
        public string TcName { get; set; }
        public int ProductNum { get; set; }
        public decimal ProductPrice { get; set; }
        public int RequestId { get; set; }
        public List<Models.Home.SaleProducts_TC_Price> List_SaleProducts_TC_Price { get; set; }

        public static int AddSaleProducts_TC(SaleProducts_TC model)
        {
            int Id = DAL.SaleProducts_TC.AddSaleProducts_TC(model);

            return Id;

        }


        public static int UpdateSaleProduct_TC(SaleProducts_TC model)
        {
            int row = DAL.SaleProducts_TC.UpdateSaleProducts_TC(model);

            return row;

        }


        public static List<Models.Home.SaleProducts_TC> GetSaleProducts_TC(int requestId)
        {
            List<Models.Home.SaleProducts_TC> list = DAL.SaleProducts_TC.GetSaleProducts_TC(requestId);

            return list;

        }


        public static int DelSaleProducts_TC(int RequestId, List<int> Ids)
        {
            int row = DAL.SaleProducts_TC.DelSaleProducts_TC(RequestId, Ids);

            return row;

        }
    }



    public class SaleProducts_TC_Price
    {
        public DateTime SaleTime { get; set; }
        public decimal Price { get; set; }
        public int Stock { get; set; }
        public int RequestId { get; set; }








        public static List<Models.Home.SaleProducts_TC_Price> GetSaleProducts_TC_Price(int requestId)
        {
            List<Models.Home.SaleProducts_TC_Price> list = DAL.SaleProducts_TC_Price.GetSaleProducts_TC_Price(requestId);

            return list;

        }

        public static List<Models.Home.SaleProducts_TC_Price> GetSaleProducts_TC_Price(List<int> requestIds)
        {
            List<Models.Home.SaleProducts_TC_Price> list = DAL.SaleProducts_TC_Price.GetSaleProducts_TC_Price(requestIds);

            return list;

        }

    }


    public class SaleProducts_Orders
    {
        public int Id { get; set; }
        public int HotelId { get; set; }
        public string HotelWeiXinId { get; set; }
        public string OrderNo { get; set; }
        public int BookingCount { get; set; }
        public int ProductId { get; set; }
        public int TcId { get; set; }
        public string ProductName { get; set; }
        public string TcName { get; set; }
        public int UserId { get; set; }
        public string UserWeiXinId { get; set; }
        public string UserName { get; set; }
        public string UserMobile { get; set; }
        public DateTime CheckInTime { get; set; }
        public DateTime CheckOutTime { get; set; }
        public decimal OrderMoney { get; set; }
        public int ProductType { get; set; }
        public string Remark { get; set; }
        public string OperatorLog { get; set; }
        public int OrderStatus { get; set; }
        public string TaoBaoStatus { get; set; }
        public DateTime OrderAddTime { get; set; }
        public string Token { get; set; }

        public string HexiaoMa { get; set; }

        public int HexiaoStatus { get; set; }
        public bool Ispay { get; set; }
        public DateTime PayTime { get; set; }

        public string LinkName { get; set; }

        public string PayType { get; set; }

        public decimal OriginalSaleprice { get; set; }
        public int Jifen { get; set; }
        public string CouponInfo { get; set; }


        public int Promoterid { get; set; }
        public decimal FxCommission { get; set; }
        public decimal Fxmoneyprofit { get; set; }

        public string Pic { get; set; }

        public static int AddSaleProducts_Orders(SaleProducts_Orders model)
        {
            int Id = DAL.SaleProducts_Orders.AddSaleSaleProducts_Orders(model);

            return Id;

        }

        public static int AddSaleProducts_Orders2(SaleProducts_Orders model)
        {
            int Id = DAL.SaleProducts_Orders.AddSaleSaleProducts_Orders2(model);

            return Id;

        }

        public static DataTable GetSaleProducts_Orders(string orderNO, string userWeixinId)
        {
            DataTable dt = DAL.SaleProducts_Orders.GetSaleProducts_Orders(orderNO, userWeixinId);
            return dt;
        }

        public static DataTable GetSaleProducts_OrdersA(string orderNO, string userWeixinId)
        {
            DataTable dt = DAL.SaleProducts_Orders.GetSaleProducts_OrdersA(orderNO, userWeixinId);
            return dt;
        }


        public static DataTable GetSaleProducts_OrdersByHexiaoma(string hexiaoMa)
        {
            DataTable dt = DAL.SaleProducts_Orders.GetSaleProducts_OrdersByHexiaoma(hexiaoMa);
            return dt;
        }




        public static string GetSaleProducts_OrdersByToken(string token)
        {
            return DAL.SaleProducts_Orders.GetSaleProducts_OrdersByToken(token);
        }


        public static DataTable GetSaleProducts_Orders(int orderId, string hotelWeiXinId)
        {
            DataTable dt = DAL.SaleProducts_Orders.GetSaleProducts_Orders(orderId, hotelWeiXinId);
            return dt;
        }




        public static int HeXiaoTuanProductOrder(int orderId, string hotelWeiXinId, string operlog)
        {
            int row = DAL.SaleProducts_Orders.HeXiaoTuanProductOrder(orderId, hotelWeiXinId, operlog);
            return row;
        }


        public static int SaveProductOrder(SaleProducts_Orders model)
        {
            int row = DAL.SaleProducts_Orders.SaveProductOrder(model);
            return row;
        }


        public static DataTable GetSaleProducts_Orders(string weiXinID, out int count, int page, int pagesize, string select, string query)
        {
            var dt = DAL.SaleProducts_Orders.GetSaleProducts_Orders(weiXinID, out count, page, pagesize, select, query);

            return dt;

        }


        public static void DoneOrderSuccess(string orderNo)
        {
            DAL.SaleProducts_Orders.DoneOrderSuccess(orderNo);

        }

    }



    public class SaleProducts_OrdersTuan
    {

        public Int64 TuanCode { get; set; }
        public int OrderId { get; set; }

        public string UsePerson { get; set; }

        public DateTime UseDate { get; set; }


        public int Status { get; set; }

        public DateTime AddTime { get; set; }

        //非数据库字段 小程序显示使用
        public string StrStatus { get; set; }
        public string StrUseDate { get; set; }
    }

    /// <summary>
    /// 预售订单状态及团购未付款取消状态
    /// </summary>
    public enum ProductSaleOrderStatus
    {
        待支付 = 0,
        已付款 = 1,
        取消 = 2,
        待确认 = 3,
        已确认 = 4,
        确认失败 = 5,
        交易成功 = 6
    }

    /// <summary>
    /// 团购已付款状态
    /// </summary>
    public enum ProductSaleOrderTuanStatus
    {
        未预约 = 0,
        预约中 = 1,
        预约成功 = 2,
        预约失败 = 3,
        已使用 = 4
    }

    /// <summary>
    /// 酒店餐饮订单状态
    /// </summary>
    public enum EnumOrderStatus
    {
        /// <summary>
        /// 新添加，未提交支付(只选了菜品)
        /// </summary>
        //UnSubmit=0,
        新添加 = 0,
        /// <summary>
        /// 已提交，待支付
        /// </summary>
        //UnPay=1,
        待支付 = 1,
        /// <summary>
        /// 订单超时
        /// </summary>
        //IsOverTime=2,
        订单超时 = 2,
        /// <summary>
        /// 取消订单
        /// </summary>
        //IsCancel=3,
        取消 = 3,
        /// <summary>
        /// 已经支付
        /// </summary>
        //IsPay = 9,
        已支付 = 9,
        /// <summary>
        /// 已确认
        /// </summary>
        //IsSure = 10,
        已确认 = 10,
        /// <summary>
        /// 拒单/退款
        /// </summary>
        //JudanTuikuan = 11
        拒单 = 11,
        取消订单 = 13,
        已完成 = 14,
        配送中 = 15
    }



    public class StatisticsCount
    {
        public int Id { get; set; }
        public string WeixinId { get; set; }
        public int HotelId { get; set; }
        public int SaleProduct { get; set; }
        public int MembershipCard { get; set; }
        public int GGL { get; set; }
        public int Turntable { get; set; }
        public int Coupon { get; set; }



        public static StatisticsCount GetStatisticsCount(string weixinId)
        {
            string sql = @"select * from wkn_StatisticsCount  with(nolock)  where  weixinId=@weixinId   ";
            System.Data.DataTable dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weixinId}}             
            });

            StatisticsCount model = new StatisticsCount();

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                model.Id = Convert.ToInt32(dt.Rows[i]["Id"].ToString());
                model.WeixinId = dt.Rows[i]["WeixinId"].ToString();
                model.HotelId = Convert.ToInt32(dt.Rows[i]["HotelId"].ToString());
                model.SaleProduct = Convert.ToInt32(dt.Rows[i]["SaleProduct"].ToString());
                model.MembershipCard = Convert.ToInt32(dt.Rows[i]["MembershipCard"].ToString());
                model.GGL = Convert.ToInt32(dt.Rows[i]["GGL"].ToString());
                model.Turntable = Convert.ToInt32(dt.Rows[i]["Turntable"].ToString());
                model.Coupon = Convert.ToInt32(dt.Rows[i]["Coupon"].ToString());
            }
            return model;

        }


        private static System.Web.Caching.Cache cache = HttpRuntime.Cache;
        public static int GetStatisticsSaleProductCount(string weixinId)
        {
            int saleproduct = 0;
            string cache_name = string.Format("{0}_{1}", weixinId, "saleproductcount");

            if (cache[cache_name] != null)
            {
                saleproduct = (int)cache[cache_name];
            }

            else
            {
                string sql = @"select SaleProduct from wkn_StatisticsCount  with(nolock)  where  weixinId=@weixinId   ";
                string str_saleProduct = HotelCloud.SqlServer.SQLHelper.Get_Value(sql, HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
            {"weixinId",new HotelCloud.SqlServer.DBParam{ParamValue=weixinId}}             
            });
                if (!string.IsNullOrEmpty(str_saleProduct))
                {
                    saleproduct = Convert.ToInt32(str_saleProduct);
                }
                cache.Insert(cache_name, saleproduct, null, DateTime.Now.AddMinutes(30), TimeSpan.Zero);

            }

            return saleproduct;

        }
    }





}