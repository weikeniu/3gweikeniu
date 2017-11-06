using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hotel3g.WeiXinZhiFu
{   
    public partial class nativeNotifyPage : System.Web.UI.Page
    {
        public string error = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                /** ================微信支付回调界面========= */
                WxPayAPI.ResultNotify resultNotify = new WxPayAPI.ResultNotify(this);
                resultNotify.ProcessNotify();                                
            }
        }
    }
}