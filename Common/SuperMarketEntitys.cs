using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WeiXin.Common
{
    /// <summary>
    /// 超市商品
    /// </summary>
    public class CommodityItem
    {
        public int id { get; set; }
        /// <summary>
        /// 酒店微信id
        /// </summary>
        public string weixinID { get; set; }
        /// <summary>
        /// 酒店id
        /// </summary>
        public int HotelId { get; set; }
        /// <summary>
        /// 商品名称
        /// </summary>
        public string Name { get; set; }
        /// <summary>
        /// 价格
        /// </summary>
        public Double Price { get; set; }
        /// <summary>
        /// 额外费用
        /// </summary>
        public Double Tip { get; set; }
        /// <summary>
        /// 商品总数
        /// </summary>
        public int Stock { get; set; }
        /// <summary>
        /// 商品图片
        /// </summary>
        public string ImagePath { get; set; }
        /// <summary>
        /// 商品描述
        /// </summary>
        public string Describe { get; set; }
        /// <summary>
        /// 商品展示顺序
        /// </summary>
        public int Sequence { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        public DateTime CreateTime { get; set; }

        /// <summary>
        ///创建时间 用于json 输出
        /// </summary>
        public string CreateTimeForJs { get; set; }

        /// <summary>
        /// 创建人
        /// </summary>
        public string CreateUser { get; set; }

        /// <summary>
        /// 编辑时间
        /// </summary>
        public DateTime EditTime { get; set; }
        /// <summary>
        ///编辑时间 用于json 输出
        /// </summary>
        public string EditTimeForJs { get; set; }

        /// <summary>
        /// 编辑人
        /// </summary>
        public string EditUser { get; set; }

        /// <summary>
        ///  状态
        /// </summary>
        public int Enabled { get; set; }
    }

    /// <summary>
    /// 超市商品列表搜索
    /// </summary>
    public class CommoditySearchResponse
    {
        public List<CommodityItem> CommodityList { get; set; }
        public int PageNum { get; set; }
        public int CommodityNum { get; set; }
    }


    /// <summary>
    /// 超市订单
    /// </summary>
    public class SupermarketOrderEntity
    {
        public int id { get; set; }
        /// <summary>
        /// 订单编号
        /// </summary>
        public string OrderId { get; set; }
        /// <summary>
        /// 酒店微信id
        /// </summary>
        public string weixinID { get; set; }
        /// <summary>
        /// 酒店名称
        /// </summary>
        public string SubName { get; set; }
        /// <summary>
        /// 酒店id
        /// </summary>
        public int HotelId { get; set; }
        /// <summary>
        /// 用户微信ID
        /// </summary>
        public string userweixinID { get; set; }
        /// <summary>
        /// 支付金额
        /// </summary>
        public float Money { get; set; }
        /// <summary>
        /// 快递费用
        /// </summary>
        public float ExpressFee { get; set; }
        /// <summary>
        /// 支付方式
        /// </summary>
        public string PayMethod { get; set; }
        /// <summary>
        /// 支付状态 1.等待支付 2.支付完成 3.支付失败
        /// </summary>
        public int PayStatus { get; set; }
        /// <summary>
        /// 订单状态 1.等待支付 2.等待发货 3.已发货 4.交易完成 5.订单取消
        /// </summary>
        public int OrderStatus { get; set; }
        /// <summary>
        /// 订单备注
        /// </summary>
        public string Remark { get; set; }
        /// <summary>
        /// 联系人
        /// </summary>
        public string Linkman { get; set; }
        /// <summary>
        /// 联系人电话
        /// </summary>
        public string LinkPhone { get; set; }
        /// <summary>
        /// 地址类型 1.酒店 2.其他
        /// </summary>
        public int AddressType { get; set; }
        /// <summary>
        /// 送货地址
        /// </summary>
        public string Address { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        public DateTime CreateTime { get; set; }
        /// <summary>
        /// 结束时间
        /// </summary>
        public DateTime EndTime { get; set; }
        /// <summary>
        /// 延迟收货的天数
        /// </summary>
        public int DelayedTake { get; set; }

        /// <summary>
        /// 商品数量
        /// </summary>
        public int total { get; set; }

        /// <summary>
        /// 商品种类数量
        /// </summary>
        public int countCommodity { get; set; }

        /// <summary>
        /// 商品名称
        /// </summary>
        public string CommodityName { get; set; }
    }

    /// <summary>
    /// 超市订单备注
    /// </summary>
    public class SupermarketOrderRemarksEntity
    {
        public int id { get; set; }
        /// <summary>
        /// 订单编号
        /// </summary>
        public string OrderId { get; set; }
        /// <summary>
        /// 内容
        /// </summary>
        public string Context { get; set; }
        /// <summary>
        /// 创建人
        /// </summary>
        public string CreateUser { get; set; }
        /// <summary>
        /// 创建人名称
        /// </summary>
        public string CreateUserName { get; set; }
        /// <summary>
        /// 创建时间
        /// </summary>
        public DateTime CreateTime { get; set; }
    }

    /// <summary>
    /// 订单状态枚举
    /// </summary>
    public enum EnumSupermarketOrderStatus
    {
        /// <summary>
        /// 待支付
        /// </summary>
        //WaitPay = 1,
        待支付= 1,
        /// <summary>
        /// 已支付
        /// </summary>
        //WaitDeliver = 2,
        已支付=2,
        /// <summary>
        /// 已发货
        /// </summary>
        //Delivered = 3,
        已发货=3,
        /// <summary>
        /// 订单完成
        /// </summary>
        //Finish = 4,
        订单完成=4,
        /// <summary>
        /// 订单取消
        /// </summary>
        //Cancel = 5,
        取消=5
    }

    /// <summary>
    /// 订单支付状态枚举
    /// </summary>
    public enum EnumSupermarketPayStatus
    {
        /// <summary>
        /// 待支付
        /// </summary>
        WaitPay = 1,

        /// <summary>
        /// 支付完成
        /// </summary>
        Finish = 2,

        /// <summary>
        /// 支付失败
        /// </summary>
        Fail = 3
    }
}