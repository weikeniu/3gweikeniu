using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hotel3g.TuiGuang
{
    public partial class Tuiguang : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string Id = HotelCloud.Common.HCRequest.GetString("r").TrimEnd();
                if (!string.IsNullOrEmpty(Id))
                {
                    int row = HotelCloud.SqlServer.SQLHelper.Run_SQL(@" update travelsky..elongHbaHotelInfo set  clickNum=Isnull(clickNum,0)+1 where Id=@Id", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> {   
                     {"Id",new HotelCloud.SqlServer.DBParam{ParamValue=Id}}   
                    });
                }

            }
        }
    }
}