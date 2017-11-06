using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WeiXin.Common;
using WeiXin.Models.Home;
using System.IO;

namespace hotel3g.Common
{
    public class TravelAgencyCommon
    {
        public static List<ProductEntity> ProductListDo(List<ProductEntity> ProductEntity_List)
        {

            try
            {
                List<ProductEntity> productEntity_List = new List<ProductEntity>();

                foreach (var item in ProductEntity_List)
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
                return ProductEntity_List;
            }
            catch (Exception e)
            {
                return new List<ProductEntity>();
            }
        }


        public static void AddLog(string stateCode, string msg, string saveFolder)
        {
            string tishiMsg = "";
            try
            {
                string fileName = DateTime.Now.ToString("yyyy-MM-dd");
                // string filePath = AppDomain.CurrentDomain.BaseDirectory + saveFolder;

                string filePath = System.Web.HttpContext.Current.Server.MapPath("~") + saveFolder;
                if (Directory.Exists(filePath) == false)
                {
                    Directory.CreateDirectory(filePath);
                }
                string fileAbstractPath = filePath + "\\" + fileName + ".txt";
                FileStream fs = new FileStream(fileAbstractPath, FileMode.Append);
                StreamWriter sw = new StreamWriter(fs);
                //开始写入     
                string time = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");
                msg = time + "，" + msg + System.Environment.NewLine;

                sw.Write(msg);
                //清空缓冲区               
                sw.Flush();
                //关闭流               
                sw.Close();
                sw.Dispose();
                fs.Close();
                fs.Dispose();

                tishiMsg = "写入日志成功";
            }
            catch (Exception ex)
            {
                string datetime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");
                tishiMsg = "[" + datetime + "]写入日志出错：" + ex.Message;
            }
        }  
    }
}