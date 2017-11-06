using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hotel3g.WeiXinZhiFu
{
    public partial class paysuc : System.Web.UI.Page
    {
        protected string TradeNo = "", AliPayAmount = "", Addtime = "", SubName = "",error="支付失败";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) {
                try
                {
                    string OrderNO = HotelCloud.Common.HCRequest.GetString("id");
                    var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 Channel,TradeNo,AliPayAmount,wkn_payrecords.Addtime,hotel.SubName from WeiXin..wkn_payrecords  with(nolock)  inner  join WeiXin..hotel with(nolock) on hotel.id=MHid where isnull(MHid,'')!='' and  OrderNO=@OrderNO ", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "OrderNO", new HotelCloud.SqlServer.DBParam { ParamValue = OrderNO.Trim() } } });
                    if (dt.Rows.Count > 0)
                    {
                        foreach (System.Data.DataRow dr in dt.Rows)
                        {
                            if (dr["Channel"].ToString().Trim() == "收款支付回调" || dr["Channel"].ToString().Trim() == "押金支付回调")
                            {
                                TradeNo = dr["TradeNo"].ToString().Trim();
                                AliPayAmount = (Convert.ToDecimal(dr["AliPayAmount"].ToString().Trim()) / 100).ToString();
                                Addtime = dr["Addtime"].ToString().Trim();
                                SubName = dr["SubName"].ToString().Trim();
                                error = "支付成功";
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    WxPayAPI.Log.Debug("paysuc", ex.Message.ToString());
                    error = ex.Message.ToString();
                }
                finally
                {

                }
            }
        }
    }
}