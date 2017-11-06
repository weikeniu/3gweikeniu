using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hotel3g.WeiXinZhiFu
{
    public partial class sweepallback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            /** ================接收用户扫码后微信支付系统发送的数据，根据接收的数据生成支付订单，调用【统一下单API】提交支付交易========= */
            if (!IsPostBack) {
                WxPayAPI.NativeNotify resultNotify = new WxPayAPI.NativeNotify(this);
                resultNotify.ProcessNotify();
            }
        }
    }
}