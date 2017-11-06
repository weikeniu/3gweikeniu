using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using hotel3g.Common;
using hotel3g.Repository;

namespace hotel3g.WeiXinZhiFu
{
    public partial class resultNotifyPage : System.Web.UI.Page
    {
        public static hotel3g.Repository.Order order = new hotel3g.Repository.Order();
        public static string error = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    string code = Request.QueryString["code"].Trim();
                    error = Request.QueryString["error"].Trim();
                    if (!string.IsNullOrEmpty(code))
                    {
                        var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select top 1 id,OrderNO,HotelID,LinkTel,HotelName,RoomName,RatePlanName,yRoomNum,yinDate,youtDate,ySumPrice,tradeNo,aliPayAmount,tradeStatus,UserWeiXinID,WeiXinID,UserName from HotelOrder where OrderNO=@OrderNO", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                            {"OrderNO",new HotelCloud.SqlServer.DBParam{ParamValue=code}}
                        });
                        if (dt.Rows.Count > 0)
                        {
                            foreach (System.Data.DataRow dr in dt.Rows)
                            {
                                order.Id = Convert.ToInt32(dr["id"].ToString());
                                order.OrderNo = Convert.ToString(dr["OrderNO"].ToString());
                                order.HotelID = Convert.ToInt32(dr["HotelID"].ToString());
                                order.LinkTel = Convert.ToString(dr["LinkTel"].ToString());
                                order.HotelName = Convert.ToString(dr["HotelName"].ToString());
                                order.RoomName = Convert.ToString(dr["RoomName"].ToString());
                                order.RatePlanName = Convert.ToString(dr["RatePlanName"].ToString());
                                order.RoomNum = Convert.ToInt32(dr["yRoomNum"].ToString());
                                order.ComeDate = Convert.ToDateTime(dr["yinDate"].ToString()).ToString("yyyy-MM-dd");
                                order.LeaveDate = Convert.ToDateTime(dr["youtDate"].ToString()).ToString("yyyy-MM-dd");
                                order.SumPrice = Convert.ToInt32(dr["ySumPrice"].ToString());
                                order.OrderAmount = Convert.ToInt32(dr["ySumPrice"].ToString());
                                order.TradeNo = dr["tradeNo"].ToString();
                                order.TradeAlipayAmount = Convert.ToDecimal(dr["aliPayAmount"].ToString());
                                order.TradeStatus = dr["tradeStatus"].ToString();
                                order.UserWeiXinID = Convert.ToString(dr["UserWeiXinID"].ToString());
                                order.WeiXinID = Convert.ToString(dr["WeiXinID"].ToString());
                                order.UserName = Convert.ToString(dr["UserName"].ToString());
                            }
                        }
                    }
                }
                catch (Exception ex) { 
                    
                }
            }
        }
    }
}