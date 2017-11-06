using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using hotel3g.Models.DAL;
using System.Data;

namespace hotel3g.Models.Home
{
    /// <summary>
    /// 微信Wifi
    /// </summary>
    public class WxWifi
    {
        WxWifiDAL wifiDAL = new WxWifiDAL();
        #region 字段
        public int ID { get; set; }
        /// <summary>
        /// 门店ID（适用于微信卡券、微信门店业务），具体定义参考微信门店，与shop_id一一对应
        /// </summary>
        public int PoiID { get; set; }
        /// <summary>
        /// 门店ID（适用于微信连Wi-Fi业务）
        /// </summary>
        public int ShopID { get; set; }
        /// <summary>
        /// 门店内设备的设备类型，0-未添加设备，1-专业型设备，4-密码型设备，5-portal自助型设备，31-portal改造型设备
        /// </summary>
        public int ProtocolType { get; set; }
        /// <summary>
        /// WIFI名称
        /// </summary>
        public string SSID { get; set; }
        /// <summary>
        /// WIFI密码
        /// </summary>
        public string SSIDPwd { get; set; }
        /// <summary>
        /// 路由器mac地址
        /// </summary>
        public string Bssid { get; set; }
        /// <summary>
        /// 操作类型：1先联网后关注，2先关注后联网 //暂时无用
        /// </summary>
        public int OperationType { get; set; }
        /// <summary>
        /// 状态:1未生效(参数不完整)2生效
        /// </summary>
        public int State { get; set; }
        public string AppId { get; set; }
        /// <summary>
        /// portal型设备必须的参数
        /// </summary>
        public string Secretkey { get; set; }
        /// <summary>
        /// 微信二维码地址
        /// </summary>
        public string QRCodeUrl { get; set; }
        /// <summary>
        /// 本地存放的二维码地址
        /// </summary>
        public string LocalQRCodeUrl { get; set; }
        /// <summary>
        /// AP设备数量
        /// </summary>
        public int ApCount { get; set; }
        /// <summary>
        /// 路由器认证密码
        /// </summary>
        public string PassPwd { get; set; }
        /// <summary>
        /// 公众号名称
        /// </summary>
        public string WxName { get; set; }

        //------以下为viewmodel字段
        public string ProtocolTypeText { get; set; }
        #endregion

        #region 方法
        /// <summary>
        /// 获取拥有有效WIFI的门店集合
        /// </summary>
        /// <returns></returns>
        public List<WxShop> GetHasWifiShops(string hotelWxId)
        {
            var shops = new List<WxShop>();
            var dt = wifiDAL.GetHasWifiShops(hotelWxId);
            foreach (DataRow r in dt.Rows)
            {
                var s = new WxShop();
                s.ID = Convert.ToInt32(r["ID"]);
                s.HotelID = r["HotelID"] == DBNull.Value ? 0 : Convert.ToInt32(r["HotelID"]);
                s.HotelWxID = r["HotelWxID"].ToString();
                s.BusinessName = r["BusinessName"].ToString();
                s.BranchName = r["BranchName"] == DBNull.Value ? "" : r["BranchName"].ToString();
                s.Province = r["Province"] == DBNull.Value ? "" : r["Province"].ToString();
                s.ProvID = r["ProvID"] == DBNull.Value ? 0 : Convert.ToInt32(r["ProvID"]);
                s.City = r["City"] == DBNull.Value ? "" : r["City"].ToString();
                s.CityID = r["CityID"] == DBNull.Value ? 0 : Convert.ToInt32(r["CityID"]);
                s.District = r["District"] == DBNull.Value ? "" : r["District"].ToString();
                s.Address = r["Address"] == DBNull.Value ? "" : r["Address"].ToString();
                s.Telephone = r["Telephone"] == DBNull.Value ? "" : r["Telephone"].ToString();
                s.Categories = r["Categories"] == DBNull.Value ? "" : r["Categories"].ToString();//arr
                s.OffsetType = r["OffsetType"] == DBNull.Value ? 3 : Convert.ToInt32(r["OffsetType"].ToString());
                s.Longitude = r["Longitude"] == DBNull.Value ? "" : r["Longitude"].ToString();
                s.Latitude = r["Latitude"] == DBNull.Value ? "" : r["Latitude"].ToString();
                s.PhotoList = r["PhotoList"] == DBNull.Value ? "" : r["PhotoList"].ToString();//arr
                s.Recommend = r["Recommend"] == DBNull.Value ? "" : r["Recommend"].ToString();
                s.Special = r["Special"] == DBNull.Value ? "" : r["Special"].ToString();
                s.Introduction = r["Introduction"] == DBNull.Value ? "" : r["Introduction"].ToString();
                s.OpenTime = r["OpenTime"] == DBNull.Value ? "" : r["OpenTime"].ToString();
                s.AvgPrice = r["AvgPrice"] == DBNull.Value ? null : (int?)Convert.ToInt32(r["AvgPrice"]);
                s.AvailableState = Convert.ToInt32(r["AvailableState"]);
                s.UpdateStatus = Convert.ToInt32(r["UpdateStatus"]);
                s.PoiID = r["PoiID"] == DBNull.Value ? 0 : Convert.ToInt32(r["PoiID"]);
                s.ShopID = r["ShopID"] == DBNull.Value ? 0 : Convert.ToInt32(r["ShopID"]);
                s.AvailableStateText = GetAvailableStateText(s.AvailableState);
                shops.Add(s);
            }
            return shops;

        }

        /// <summary>
        /// 获取门店的有效的wifi
        /// </summary>
        /// <param name="shopId"></param>
        /// <returns></returns>
        public List<WxWifi> GetValidWifis(int shopId)
        {
            var wifis = new List<WxWifi>();
            var dt = wifiDAL.GetValidWifis(shopId);
            foreach (DataRow r in dt.Rows)
            {
                var w = new WxWifi();
                w.ID = Convert.ToInt32(r["ID"]);
                w.PoiID = Convert.ToInt32(r["PoiID"]);
                w.ProtocolType = Convert.ToInt32(r["ProtocolType"]);
                w.ProtocolTypeText = GetProtocolTypeText(w.ProtocolType);
                w.OperationType = Convert.ToInt32(r["OperationType"]);
                w.State = Convert.ToInt32(r["State"]);
                w.ShopID = Convert.ToInt32(r["ShopID"]);
                w.SSID = r["SSID"] == DBNull.Value ? "" : r["SSID"].ToString();
                w.SSIDPwd = r["SSIDPwd"] == DBNull.Value ? "" : r["SSIDPwd"].ToString();
                w.Bssid = r["Bssid"] == DBNull.Value ? "" : r["Bssid"].ToString();
                w.Secretkey = r["Secretkey"] == DBNull.Value ? "" : r["Secretkey"].ToString();
                w.QRCodeUrl = r["QRCodeUrl"] == DBNull.Value ? "" : r["QRCodeUrl"].ToString();
                w.ApCount = r["Secretkey"] == DBNull.Value ? 0 : Convert.ToInt32(r["ApCount"]);
                w.LocalQRCodeUrl = r["LocalQRCodeUrl"] == DBNull.Value ? "" : r["LocalQRCodeUrl"].ToString();
                w.AppId = r["AppId"] == DBNull.Value ? "" : r["AppId"].ToString();
                w.PassPwd = r["PassPwd"] == DBNull.Value ? "" : r["PassPwd"].ToString();
                w.WxName = r["WxName"] == DBNull.Value ? "" : r["WxName"].ToString();
                wifis.Add(w);
            }
            return wifis;
        }

        /// <summary>
        /// 获取单个门店wifi信息
        /// </summary>
        /// <returns></returns>
        public WxWifi GetWifiById(int id)
        {
            var w = new WxWifi() { ProtocolTypeText = GetProtocolTypeText(-1) };
            var dt = wifiDAL.GetWifiById(id);
            foreach (DataRow r in dt.Rows)
            {
                w.ID = Convert.ToInt32(r["ID"]);
                w.PoiID = Convert.ToInt32(r["PoiID"]);
                w.ProtocolType = Convert.ToInt32(r["ProtocolType"]);
                w.ProtocolTypeText = GetProtocolTypeText(w.ProtocolType);
                w.OperationType = Convert.ToInt32(r["OperationType"]);
                w.State = Convert.ToInt32(r["State"]);
                w.ShopID = Convert.ToInt32(r["ShopID"]);
                w.SSID = r["SSID"] == DBNull.Value ? "" : r["SSID"].ToString();
                w.SSIDPwd = r["SSIDPwd"] == DBNull.Value ? "" : r["SSIDPwd"].ToString();
                w.Bssid = r["Bssid"] == DBNull.Value ? "" : r["Bssid"].ToString();
                w.Secretkey = r["Secretkey"] == DBNull.Value ? "" : r["Secretkey"].ToString();
                w.QRCodeUrl = r["QRCodeUrl"] == DBNull.Value ? "" : r["QRCodeUrl"].ToString();
                w.ApCount = r["Secretkey"] == DBNull.Value ? 0 : Convert.ToInt32(r["ApCount"]);
                w.LocalQRCodeUrl = r["LocalQRCodeUrl"] == DBNull.Value ? "" : r["LocalQRCodeUrl"].ToString();
                w.AppId = r["AppId"] == DBNull.Value ? "" : r["AppId"].ToString();
                w.PassPwd = r["PassPwd"] == DBNull.Value ? "" : r["PassPwd"].ToString();
                w.WxName = r["WxName"] == DBNull.Value ? "" : r["WxName"].ToString();
            }
            return w;
        }
        #endregion

        #region 辅助方法
        /// <summary>
        /// 门店状态
        /// </summary>
        /// <param name="state"></param>
        /// <returns></returns>
        public string GetAvailableStateText(int state)
        {
            string text = string.Empty;
            switch (state)
            {
                case 1: text = "系统错误"; break;
                case 2: text = "已提交"; break;
                case 3: text = "生效"; break;
                case 4: text = "不通过"; break;
                default:
                    break;
            }
            return text;
        }

        /// <summary>
        /// 设备类型
        /// </summary>
        /// <param name="pt"></param>
        /// <returns></returns>
        public string GetProtocolTypeText(int pt)
        {
            string text = "未添加设备";
            switch (pt)
            {
                case 0: text = "未添加设备"; break;
                case 1: text = "专业型设备"; break;
                case 4: text = "密码型设备"; break;
                case 5: text = "portal自助型设备"; break;
                case 31: text = "portal改造型设备"; break;
                default:
                    break;
            }
            return text;
        }
        #endregion
    }

    /// <summary>
    /// 微信一键连wifi Portal认证所需参数。
    /// </summary>
    public class WxPortalWifi
    {
        /// <summary>
        /// 打开方式(1先联网再打开微信关注。2先打开微信关注公众号后再联网)//废弃
        /// </summary>
        public int open_type { get; set; }
        /// <summary>
        ///Y 商家微信公众平台账号
        /// </summary>
        public string appId { get; set; }
        /// <summary>
        ///Y 秘钥 
        /// </summary>
        public string secretkey { get; set; }
        /// <summary>
        ///Y extend里面可以放开发者需要的相关参数集合，最终将透传给运营商认证URL。extend参数只支持英文和数字，且长度不得超过300个字符
        /// </summary>
        public string extend { get; set; }
        /// <summary>
        /// Y 时间戳使用毫秒
        /// </summary>
        public string timestamp { get; set; }
        /// <summary>
        /// Y AP设备所在门店的ID，即shop_id
        /// </summary>
        public int shop_id { get; set; }
        /// <summary>
        /// Y 认证服务端URL，微信客户端将把用户微信身份信息向此URL提交并获得认证放行
        /// </summary>
        public string authUrl { get; set; }
        /// <summary>
        /// Y 用户手机mac地址(安卓设备必需)
        /// </summary>
        public string mac { get; set; }
        /// <summary>
        /// Y AP设备的无线网络名称
        /// </summary>
        public string ssid { get; set; }
        /// <summary>
        /// Y AP设备mac
        /// </summary>
        public string bssid { get; set; }
        /// <summary>
        /// sign = MD5(appId + extend + timestamp + shopId + authUrl + mac + ssid + secretkey);
        /// </summary>
        public string sign { get; set; }

        //-----------自定义参数------
        /// <summary>
        /// 设置认证请求地址
        /// </summary>
        public string PassUrl { get; set; }
        /// <summary>
        /// 公众号名称
        /// </summary>
        public string WxName { get; set; }
        /// <summary>
        /// 标记(0WIFI不存在，1WIFI存在但参数不完整，2WIFI存在参数完整)，用于portal也展示
        /// </summary>
        public int Flag { get; set; }
    }

    /// <summary>
    /// 微信门店
    /// </summary>
    public class WxShop
    {
        //--------门店基础信息字段（重要）--------
        /// <summary>
        /// 商户自己的id，用于后续审核通过收到poi_id 的通知时，做对应关系。请商户自己保证唯一识别性.非必填
        /// </summary>
        public int ID { get; set; }
        /// <summary>
        ///酒店ID //暂时无用
        /// </summary>
        public int HotelID { get; set; }
        /// <summary>
        /// 酒店微信ID
        /// </summary>
        public string HotelWxID { get; set; }
        /// <summary>
        /// 门店名称（仅为商户名，如：国美、麦当劳，不应包含地区、地址、分店名等信息，错误示例：北京国美）15个汉字或30个英文字符内.必填
        /// </summary>
        public string BusinessName { get; set; }
        /// <summary>
        /// 分店名称（不应包含地区信息，不应与门店名有重复，错误示例：北京王府井店）20个字以内.必填
        /// </summary>
        public string BranchName { get; set; }
        /// <summary>
        /// 门店所在的省份（直辖市填城市名,如：北京市）10个字以内.必填
        /// </summary>
        public string Province { get; set; }
        public int ProvID { get; set; }
        /// <summary>
        /// 	门店所在的城市10个字以内.必填
        /// </summary>
        public string City { get; set; }
        public int CityID { get; set; }
        /// <summary>
        /// 	门店所在地区10个字以内.必填
        /// </summary>
        public string District { get; set; }
        public int DistrictID { get; set; }
        /// <summary>
        /// 门店所在的详细街道地址（不要填写省市信息）（东莞等没有“区”行政区划的城市，该字段可不必填写。其余城市必填。）
        /// </summary>
        public string Address { get; set; }
        /// <summary>
        /// 门店的电话（纯数字，区号、分机号均由“-”隔开）.必填
        /// </summary>
        public string Telephone { get; set; }
        /// <summary>
        /// 门店的类型（不同级分类用“,”隔开，如：美食，川菜，火锅。详细分类参见附件：微信门店类目表）.必填
        /// </summary>
        public string Categories { get; set; }
        /// <summary>
        /// 坐标类型：1 为火星坐标2 为sogou经纬度3 为百度经纬度4 为mapbar经纬度5 为GPS坐标6 为sogou墨卡托坐标.必填
        /// </summary>
        public int OffsetType { get; set; }
        /// <summary>
        /// 门店所在地理位置的经度.必填
        /// </summary>
        public string Longitude { get; set; }
        /// <summary>
        /// 门店所在地理位置的纬度（经纬度均为火星坐标，最好选用腾讯地图标记的坐标）.必填
        /// </summary>
        public string Latitude { get; set; }
        //--------门店服务信息字段--------
        /// <summary>
        /// 图片列表，url 形式，可以有多张图片，尺寸为640*340px。必须为上一接口生成的url。图片内容不允许与门店不相关，不允许为二维码、员工合照（或模特肖像）、营业执照、无门店正门的街景、地图截图、公交地铁站牌、菜单截图等.非必填
        /// </summary>
        public string PhotoList { get; set; }
        /// <summary>
        /// 推荐品，餐厅可为推荐菜；酒店为推荐套房；景点为推荐游玩景点等，针对自己行业的推荐内容200字以内.非必填
        /// </summary>
        public string Recommend { get; set; }
        /// <summary>
        /// 特色服务，如免费wifi，免费停车，送货上门等商户能提供的特色功能或服务.非必填
        /// </summary>
        public string Special { get; set; }
        /// <summary>
        /// 商户简介，主要介绍商户信息等300字以内.非必填
        /// </summary>
        public string Introduction { get; set; }
        /// <summary>
        /// 营业时间，24 小时制表示，用“-”连接，如8:00-20:00.非必填
        /// </summary>
        public string OpenTime { get; set; }
        /// <summary>
        /// 人均价格，大于0 的整数.非必填
        /// </summary>
        public int? AvgPrice { get; set; }
        /// <summary>
        /// 门店是否可用状态。1 表示系统错误、2 表示审核中、3 审核通过、4 审核驳回
        /// </summary>
        public int AvailableState { get; set; }
        /// <summary>
        /// 扩展字段是否正在更新中。1 表示扩展字段正在更新中，尚未生效，不允许再次更新； 0 表示扩展字段没有在更新中或更新已生效，可以再次更新
        /// </summary>
        public int UpdateStatus { get; set; }
        /// <summary>
        /// 微信生成的门店ID（适用于微信卡券、微信门店业务），具体定义参考微信门店，与shop_id一一对应
        /// </summary>
        public int PoiID { get; set; }
        /// <summary>
        /// 门店ID(用于WIFI)
        /// </summary>
        public int ShopID { get; set; }

        //-----------viewModel字段----
        /// <summary>
        /// 状态显示文本
        /// </summary>
        public string AvailableStateText { get; set; }
    }
}