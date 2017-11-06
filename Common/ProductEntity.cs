using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WeiXin.Models.Home;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Net;
using System.IO;
namespace WeiXin.Common
{
    /// <summary>
    /// 预售产品实体类
    /// </summary>
    public class ProductEntity
    {
        public string Id { get; set; }

        public string ProductType { get; set; }
        public string ProductName { get; set; }
        public string BeginTime { get; set; }
        public string EndTime { get; set; }
        public string EffectiveBeginTime { get; set; }
        public string EffectiveEndTime { get; set; }
        public string LastUpdatetime { get; set; }
        public string SaleChannel { get; set; }
        public string Status { get; set; }
        public string MinPrice { get; set; }
        public string Image { get; set; }

        public string MainPic { get; set; }
        public string BigMainPic { get; set; }
        public string SmallMainPic { get; set; }

        public string Tab { get; set; }
        public string MenPrice { get; set; }
        public string city { get; set; }
        //public string SubName { get; set; }

        //小程序使用
         public double CurrMinPrice { get; set; }  //当前计算最低价格
         public int  MinCount { get; set; }  //剩余数量
         public bool IsNowBuy { get; set; }   // 是否已开始售卖

        public List<Models.Home.SaleProducts_TC> List_SaleProducts_TC { get; set; }

        public static List<ProductEntity> ConvertProductEntity(List<SaleProduct> listSaleProducts)
        {
            List<ProductEntity> list_ProductEntity = new List<ProductEntity>();
            if (listSaleProducts != null)
            {

                foreach (var item in listSaleProducts)
                {

                    ProductEntity productEntity = new ProductEntity();
                    productEntity.Id = item.Id.ToString();
                    productEntity.ProductType = item.ProductType == 0 ? "团购模式" : " 日历模式";
                    productEntity.ProductName = item.ProductName;
                    productEntity.BeginTime = item.BeginTime.ToString();
                    productEntity.EndTime = item.EndTime.ToString();
                    productEntity.EffectiveBeginTime = item.EffectiveBeginTime.ToString();
                    productEntity.EffectiveEndTime = item.EffectiveEndTime.ToString();
                    productEntity.LastUpdatetime = item.LastUpdatetime.ToString();
                    productEntity.SaleChannel = item.SaleChannel;
                    productEntity.Status = item.Status == 0 ? "启用" : "禁用";

                    list_ProductEntity.Add(productEntity);

                }
            }

            return list_ProductEntity;
        }


        public static List<ProductEntity> ConvertProductEntityList(List<SaleProduct> listSaleProducts)
        {
            List<ProductEntity> list_ProductEntity = new List<ProductEntity>();
            if (listSaleProducts != null)
            {

                foreach (var item in listSaleProducts)
                {

                    ProductEntity productEntity = new ProductEntity();
                    productEntity.Id = item.Id.ToString();
                    productEntity.ProductType = item.ProductType.ToString();
                    productEntity.ProductName = item.ProductName;

                    productEntity.BeginTime = item.EndTime.ToString("yyyy-MM-dd HH:mm:ss");
                    productEntity.EndTime = item.EndTime.ToString("yyyy-MM-dd HH:mm:ss");
                    productEntity.EffectiveBeginTime = item.EffectiveBeginTime.ToString();
                    productEntity.EffectiveEndTime = item.EffectiveEndTime.ToString();
                    productEntity.LastUpdatetime = item.LastUpdatetime.ToString();

                    productEntity.SaleChannel = item.SaleChannel;
                    productEntity.Status = item.Status.ToString();

                    productEntity.MinPrice = Models.Home.SaleProduct.GetSaleProductMinPrice(item.Id, item.ProductType).ToString();


                    productEntity.Image = item.ImageList;
                    if (!string.IsNullOrEmpty(item.SmallImageList))
                    {
                        productEntity.Image = item.SmallImageList;
                    }

                    if (!string.IsNullOrEmpty(productEntity.Image))
                    {
                        productEntity.Image = productEntity.Image.Split(',')[0];

                    }


                    list_ProductEntity.Add(productEntity);

                }
            }

            return list_ProductEntity;
        }



        public static List<ProductEntity> ConvertProductEntityIndexList(DataTable db)
        {
            List<ProductEntity> list_ProductEntity = new List<ProductEntity>();

            for (int i = 0; i < db.Rows.Count; i++)
            {
                ProductEntity productEntity = new ProductEntity();
                productEntity.Id = db.Rows[i]["Id"].ToString();
                productEntity.ProductType = db.Rows[i]["ProductType"].ToString();
                productEntity.ProductName = db.Rows[i]["ProductName"].ToString();

                productEntity.BeginTime = Convert.ToDateTime(db.Rows[i]["BeginTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.EndTime = Convert.ToDateTime(db.Rows[i]["EndTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.EffectiveBeginTime = Convert.ToDateTime(db.Rows[i]["EffectiveBeginTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.EffectiveEndTime = Convert.ToDateTime(db.Rows[i]["EffectiveEndTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.LastUpdatetime = Convert.ToDateTime(db.Rows[i]["LastUpdatetime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.SaleChannel = db.Rows[i]["SaleChannel"].ToString();
                productEntity.Status = db.Rows[i]["status"].ToString();
                productEntity.MinPrice = Convert.ToDouble(db.Rows[i]["MinPrice"].ToString()).ToString();


                //productEntity.Image = db.Rows[i]["ImageList"].ToString();
                //if (!string.IsNullOrEmpty(db.Rows[i]["SmallImageList"].ToString()))
                //{
                //    productEntity.Image = db.Rows[i]["SmallImageList"].ToString();
                //}
                //if (!string.IsNullOrEmpty(productEntity.Image))
                //{
                //    productEntity.Image = productEntity.Image.Split(',')[0];

                //}


                productEntity.Image = db.Rows[i]["MainPic"].ToString();
                if (!string.IsNullOrEmpty(db.Rows[i]["SmallMainPic"].ToString()))
                {
                    productEntity.Image = db.Rows[i]["SmallMainPic"].ToString();
                }



                list_ProductEntity.Add(productEntity);

            }

            return list_ProductEntity;
        }


        public static List<ProductEntity> ConvertProductEntityIndexListA(DataTable db)
        {
            List<ProductEntity> list_ProductEntity = new List<ProductEntity>();

            for (int i = 0; i < db.Rows.Count; i++)
            {
                ProductEntity productEntity = new ProductEntity();
                productEntity.Id = db.Rows[i]["Id"].ToString();
                productEntity.ProductType = db.Rows[i]["ProductType"].ToString();
                productEntity.ProductName = db.Rows[i]["ProductName"].ToString();

                productEntity.BeginTime = Convert.ToDateTime(db.Rows[i]["BeginTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.EndTime = Convert.ToDateTime(db.Rows[i]["EndTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.EffectiveBeginTime = Convert.ToDateTime(db.Rows[i]["EffectiveBeginTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.EffectiveEndTime = Convert.ToDateTime(db.Rows[i]["EffectiveEndTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.LastUpdatetime = Convert.ToDateTime(db.Rows[i]["LastUpdatetime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.SaleChannel = db.Rows[i]["SaleChannel"].ToString();
                productEntity.Status = db.Rows[i]["status"].ToString();
                productEntity.MinPrice = Convert.ToDouble(db.Rows[i]["MinPrice"].ToString()).ToString();

                productEntity.MenPrice = Convert.ToDouble(db.Rows[i]["MenPrice"].ToString()).ToString();
                productEntity.Tab = db.Rows[i]["tab"].ToString();
                productEntity.MainPic = db.Rows[i]["MainPic"].ToString();
                productEntity.BigMainPic = db.Rows[i]["BigMainPic"].ToString();
                productEntity.SmallMainPic = db.Rows[i]["SmallMainPic"].ToString();

                //productEntity.Image = db.Rows[i]["ImageList"].ToString();
                //if (!string.IsNullOrEmpty(db.Rows[i]["BigImageList"].ToString()))
                //{
                //    productEntity.Image = db.Rows[i]["BigImageList"].ToString();
                //}

                //if (!string.IsNullOrEmpty(productEntity.Image))
                //{
                //    productEntity.Image = productEntity.Image.Split(',')[0];

                //}

                productEntity.Image = db.Rows[i]["MainPic"].ToString();
                if (!string.IsNullOrEmpty(db.Rows[i]["SmallMainPic"].ToString()))
                {
                    productEntity.Image = db.Rows[i]["SmallMainPic"].ToString();
                }

                list_ProductEntity.Add(productEntity);

            }

            return list_ProductEntity;
        }

        public static List<ProductEntity> ConvertProductEntityIndexListMall(DataTable db)
        {
            List<ProductEntity> list_ProductEntity = new List<ProductEntity>();

            for (int i = 0; i < db.Rows.Count; i++)
            {
                ProductEntity productEntity = new ProductEntity();
                productEntity.Id = db.Rows[i]["Id"].ToString();
                productEntity.ProductType = db.Rows[i]["ProductType"].ToString();
                productEntity.ProductName = db.Rows[i]["ProductName"].ToString();

                productEntity.BeginTime = Convert.ToDateTime(db.Rows[i]["BeginTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.EndTime = Convert.ToDateTime(db.Rows[i]["EndTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.EffectiveBeginTime = Convert.ToDateTime(db.Rows[i]["EffectiveBeginTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.EffectiveEndTime = Convert.ToDateTime(db.Rows[i]["EffectiveEndTime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.LastUpdatetime = Convert.ToDateTime(db.Rows[i]["LastUpdatetime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
                productEntity.SaleChannel = db.Rows[i]["SaleChannel"].ToString();
                productEntity.Status = db.Rows[i]["status"].ToString();
                productEntity.MinPrice = Convert.ToDouble(db.Rows[i]["MinPrice"].ToString()).ToString();

                productEntity.MenPrice = Convert.ToDouble(db.Rows[i]["MenPrice"].ToString()).ToString();
                productEntity.Tab = db.Rows[i]["tab"].ToString().ToString();             
                productEntity.MainPic = db.Rows[i]["MainPic"].ToString();
                //productEntity.BigMainPic = db.Rows[i]["BigMainPic"].ToString();
                //productEntity.SmallMainPic = db.Rows[i]["SmallMainPic"].ToString();

                productEntity.city = db.Rows[i]["city"].ToString().ToString();
                //productEntity.SubName = db.Rows[i]["SubName"].ToString().ToString();

                productEntity.Image = db.Rows[i]["ImageList"].ToString();
                if (!string.IsNullOrEmpty(db.Rows[i]["BigImageList"].ToString()))
                {
                    productEntity.Image = db.Rows[i]["BigImageList"].ToString();
                }

                if (!string.IsNullOrEmpty(productEntity.Image))
                {
                    productEntity.Image = productEntity.Image.Split(',')[0];

                }

                list_ProductEntity.Add(productEntity);

            }

            return list_ProductEntity;
        }

    }



    public class ProductEntityList
    {
        public List<ProductEntity> ProductEntity_List { get; set; }

        public int Count { get; set; }
    }

    /// <summary>
    /// 预售产品实体类
    /// </summary>
    public class ProductOrderEntity
    {
        public string Id { get; set; }
        public string OrderNo { get; set; }
        public string BookingCount { get; set; }
        public string ProductId { get; set; }
        public string TcId { get; set; }
        public string ProductName { get; set; }
        public string TcName { get; set; }
        public string UserId { get; set; }
        public string UserWeiXinId { get; set; }
        public string UserName { get; set; }
        public string UserMobile { get; set; }
        public string CheckInTime { get; set; }
        public string CheckOutTime { get; set; }
        public string OrderMoney { get; set; }
        public string ProductType { get; set; }
        public string OrderStatus { get; set; }

        public string IsPay { get; set; }

        public string OrderAddTime { get; set; }

        public static List<ProductOrderEntity> ConvertProductOrderEntity(List<SaleProducts_Orders> listSaleProducts)
        {
            List<ProductOrderEntity> list_ProductEntity = new List<ProductOrderEntity>();
            if (listSaleProducts != null)
            {
                foreach (var item in listSaleProducts)
                {
                    ProductOrderEntity productEntity = new ProductOrderEntity();
                    productEntity.Id = item.Id.ToString();
                    productEntity.OrderNo = item.OrderNo;
                    productEntity.BookingCount = item.BookingCount.ToString();
                    productEntity.TcId = item.TcId.ToString();
                    productEntity.ProductName = item.ProductName;
                    productEntity.TcName = item.TcName;
                    productEntity.UserId = item.UserId.ToString();
                    productEntity.UserWeiXinId = item.UserWeiXinId;
                    productEntity.UserName = item.UserName;
                    productEntity.UserMobile = item.UserMobile;
                    productEntity.CheckInTime = item.CheckInTime.ToString("yyyy-MM-dd");
                    productEntity.CheckOutTime = item.CheckOutTime.ToString("yyyy-MM-dd");
                    productEntity.OrderMoney = item.OrderMoney.ToString();
                    productEntity.ProductType = item.ProductType == 0 ? "团购模式" : " 日历模式";
                    productEntity.OrderStatus = item.OrderStatus.ToString();
                    productEntity.OrderAddTime = item.OrderAddTime.ToString();
                    productEntity.IsPay = item.Ispay ? "已付款" : "未付款";
                    list_ProductEntity.Add(productEntity);

                }
            }

            return list_ProductEntity;
        }

    }


    public class DataTableToEntity
    {

        public static IList<T> GetEntities<T>(DataTable table) where T : new()
        {
            IList<T> entities = new List<T>();
            foreach (DataRow row in table.Rows)
            {
                T entity = new T();
                foreach (var item in entity.GetType().GetProperties())
                {
                    if (row.Table.Columns.Contains(item.Name))
                    {
                        if (DBNull.Value != row[item.Name])
                        {
                            item.SetValue(entity, Convert.ChangeType(row[item.Name], item.PropertyType), null);
                        }
                    }
                }

                entities.Add(entity);
            }
            return entities;
        }

        public static T GetEntity<T>(DataTable table) where T : new()
        {
            T entity = new T();
            foreach (DataRow row in table.Rows)
            {
                foreach (var item in entity.GetType().GetProperties())
                {
                    if (row.Table.Columns.Contains(item.Name))
                    {
                        if (DBNull.Value != row[item.Name])
                        {
                            item.SetValue(entity, Convert.ChangeType(row[item.Name], item.PropertyType), null);
                        }

                    }
                }
            }

            return entity;
        }


    }



    public class MemberEntity
    {

        public string Mobile { get; set; }

        public string Name { get; set; }

        public string NickName { get; set; }

        public string CardNo { get; set; }
    }


    public class ValidateSignProduct
    {

        public static string userKey = "uiosdflkjsdflkqdsffsdfyusndsfbysht";


        public static string GenerateSign(string hotelweiXinId, string userweixinId)
        {
            return Encryption(string.Format("{0}_{1}_{2}", hotelweiXinId, userweixinId, userKey));

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



    public class IpAddressOperation
    {
        public static string GetIPAddress()
        {

            if (HttpContext.Current.Request.ServerVariables["HTTP_VIA"] != null)
            {
                if (HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
                {
                    return HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
                }
                return HttpContext.Current.Request.UserHostAddress;
            }
            return HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        }
    }

    public class NormalCommon
    {

        ///   <summary>
        ///   去除HTML标记
        ///   </summary>
        ///   <param   name=”NoHTML”>包括HTML的源码   </param>
        ///   <returns>已经去除后的文字</returns>
        public static string NoHTML(string Htmlstring)
        {
            //删除脚本
            Htmlstring = Regex.Replace(Htmlstring, @"<script[^>]*?>.*?</script>", "",
            RegexOptions.IgnoreCase);
            //删除HTML 
            Htmlstring = Regex.Replace(Htmlstring, @"<(.[^>]*)>", "",
            RegexOptions.IgnoreCase);
            Htmlstring = Regex.Replace(Htmlstring, @"([\r\n])[\s]+", "",
            RegexOptions.IgnoreCase);
            Htmlstring = Regex.Replace(Htmlstring, @"–>", "", RegexOptions.IgnoreCase);
            Htmlstring = Regex.Replace(Htmlstring, @"<!–.*", "", RegexOptions.IgnoreCase);
            Htmlstring = Regex.Replace(Htmlstring, @"&(quot|#34);", "\"",
            RegexOptions.IgnoreCase);
            Htmlstring = Regex.Replace(Htmlstring, @"&(amp|#38);", "&",
            RegexOptions.IgnoreCase);
            Htmlstring = Regex.Replace(Htmlstring, @"&(lt|#60);", "<",
            RegexOptions.IgnoreCase);
            Htmlstring = Regex.Replace(Htmlstring, @"&(gt|#62);", ">",
            RegexOptions.IgnoreCase);
            Htmlstring = Regex.Replace(Htmlstring, @"&(nbsp|#160);", "   ",
            RegexOptions.IgnoreCase);
            Htmlstring = Regex.Replace(Htmlstring, @"&(iexcl|#161);", "\xa1", RegexOptions.IgnoreCase);
            Htmlstring = Regex.Replace(Htmlstring, @"&(cent|#162);", "\xa2", RegexOptions.IgnoreCase);
            Htmlstring = Regex.Replace(Htmlstring, @"&(pound|#163);", "\xa3", RegexOptions.IgnoreCase);
            Htmlstring = Regex.Replace(Htmlstring, @"&(copy|#169);", "\xa9", RegexOptions.IgnoreCase);
            Htmlstring = Regex.Replace(Htmlstring, @"&#(\d+);", "", RegexOptions.IgnoreCase);
            Htmlstring.Replace("<", "");
            Htmlstring.Replace(">", "");
            Htmlstring.Replace("\r\n", "");
            Htmlstring = HttpContext.Current.Server.HtmlEncode(Htmlstring).Trim();
            return Htmlstring;
        }


        /// <summary>
        /// 是否旅行社域名
        /// </summary>
        public static bool IsLXSDoMain()
        {
            string lxsDomain = System.Configuration.ConfigurationManager.AppSettings["lxsdomain"].ToString();
            string url = HttpContext.Current.Request.Url.ToString().ToLower();

            return url.Contains(lxsDomain);
        }


        /// <summary>
        /// 过滤会影响前端生成JSON的特殊字符
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static string StrFilterToJson(string str)
        {
            if (str == null)
            {
                return str;
            }

            str = str.Replace("'", "");
            str = str.Replace("\"", "");
            str = str.Replace("\\", "");
            str = str.Replace("\t", "");
            str = str.Replace("\n", "");
            str = str.Replace("\r", "");
            str = str.Replace("\b", "");

            return str;
        }



        public static string doPost(string Url, byte[] postData)
        {
            try
            {
                HttpWebRequest myRequest = (HttpWebRequest)WebRequest.Create(Url.ToString());
                myRequest.Method = "POST";
                myRequest.Timeout = 30000;
                myRequest.KeepAlive = true;
                
                myRequest.Headers["Cache-control"] = "no-cache";
                myRequest.Headers["Accept-Language"] = "zh-cn";
                myRequest.UserAgent = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36";
                myRequest.ContentType = "application/x-www-form-urlencoded";
                myRequest.Accept = "*/*";
                myRequest.ContentLength = postData.Length;
                Stream newStream = myRequest.GetRequestStream();
                newStream.Write(postData, 0, postData.Length);
                newStream.Close();
                HttpWebResponse myResponse = (HttpWebResponse)myRequest.GetResponse();
                StreamReader reader = new StreamReader(myResponse.GetResponseStream(), Encoding.GetEncoding("utf-8"));
                string outdata = reader.ReadToEnd();
                reader.Close();

                return outdata;

            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

    }

    /// <summary>
    /// 日志
    /// </summary>
    public static class Logger
    {

        public static log4net.ILog Instance = log4net.LogManager.GetLogger("logError");
    }


}