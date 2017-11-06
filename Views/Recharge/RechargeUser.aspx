<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    List<WeiXin.Models.Home.RechargeCard> list = ViewData["list"] as List<WeiXin.Models.Home.RechargeCard>;
    WeiXin.Models.Home.RechargeRange range = ViewData["range"] as WeiXin.Models.Home.RechargeRange;   
    

    List<string> rangetxt = new List<string>();

    if (!string.IsNullOrEmpty(range.UseRange))
    {
        for (int i = 0; i < range.UseRange.Split(',').Length; i++)
        {
            string curr = range.UseRange.Split(',')[i];

            if (curr == "0")
            {
                rangetxt.Add("酒店订房");
            }
            else if (curr == "1")
            {
                rangetxt.Add("自营餐饮");
            }
            else if (curr == "2")
            {
                rangetxt.Add("团购预售");
            }

            else if (curr == "3")
            {
                rangetxt.Add("酒店超市");
            }

            else if (curr == "4")
            {
                rangetxt.Add("周边商家");
            }
        }

    }


    int page = Convert.ToInt32(ViewData["page"]);
    int pagesize = Convert.ToInt32(ViewData["pagesize"]);
    int count = Convert.ToInt32(ViewData["count"]);
    int pagenum = count % pagesize == 0 ? count / pagesize : count / pagesize + 1;



    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string hotelid = RouteData.Values["id"].ToString();
    string userWeiXinID = "";
    userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
    if (weixinID.Equals(""))
    {
        string key = HotelCloud.Common.HCRequest.GetString("key");
        string[] a = key.Split('@');
        weixinID = a[0];
        userWeiXinID = a[1];
    }
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotelid);
    viewDic.Add("uwx", userWeiXinID);



    #region 获取appid Ashbur20170427
    string appid = "wx9f84537c7ce94a29";
    var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 appid from WeiXin..WeiXinNO with(nolock)  where WeiXinID=@WeiXinID and iszhifu=1", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "WeiXinID", new HotelCloud.SqlServer.DBParam { ParamValue = weixinID.Trim() } } });
    if (dt.Rows.Count > 0)
    {
        foreach (System.Data.DataRow dr in dt.Rows)
            appid = dr["appid"].ToString().Trim();
    }
    ViewData["appid"] = appid;
    #endregion
 

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();

 

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta name="keywords" content="关键词1,关键词2,关键词3" />
    <meta name="description" content="对网站的描述" />
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">

    <title>储值卡充值</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css" />         
 

    <script src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>

</head>
<body>
    <!--基本页-->
    <section class="base-page">
	<header class="yu-bor bbor">
	 	<a href="/user/Index/<%=hotelid%>?key=<%=weixinID%>@<%=userWeiXinID %>" class="back"><div class="new-l-arr"></div></a>
	 	储值卡
	 	 <a class="details-btn3" href="/Recharge/RechargeDetail/<%=hotelid%>?key=<%=weixinID%>@<%=userWeiXinID %>" >明细</a> 
	</header>
 

<section class="yu-bgblue2 yu-lrpad10 yu-tbpad20 yu-white">
	<p class="yu-font16">储值卡余额（元）</p>
	<p class="yu-fonnt40 yu-bpad30"><%=ViewData["balance"]%></p>
</section>

<section class="tab-con">
	<ul class="tab-nav type0 yu-grid yu-bor bbor">
		<li class="yu-overflow cur">储值卡充值</li>
		<li class="yu-overflow">卡密充值</li>
	</ul>

	<ul class="tab-inner">

		<li class="cur">
<section class="yu-bgw yu-bor tbbor">
	<p class="yu-pad10 yu-bmar20">充值金额</p>
	<div class="recharge-list">
		<ul>
        <% foreach (var item in list.OrderBy(c => c.MPrice))
           {   %>
			<li data-id="<%=item.Id%>">

				<a  href="javascript:;" class="yu-bor bor">
					<p class="yu-font16"><span class="mprice" ><%= Convert.ToDouble(item.MPrice)%></span>元</p>
					<p class="yu-font12">售价:<span class="sprice"><%= Convert.ToDouble(item.Sprice)%></span>元</p>
				</a>
			</li>
        <%}%>	 
		 
		</ul>
	</div>
</section>
</li>

<li>	

			<section class="yu-bmar10 yu-pos-r yu-bgw">
				<div class="yu-grid yu-lrpad10 yu-bgw ">
					<p class="yu-font14 yu-rmar10 yu-w60 yu-line60">输入卡密</p>
					<div class="yu-overflow ">
						<input type="number" class="yu-input1 yu-font18" value="" id="cardpassword"  />
					 
					</div>
					<!--<div><p class="s-v-card-ico1 type1"></p></div>-->
				</div>
				 
				
				
			</section>
			<div class="yu-pad10"><input type="button" class="blue-sub" value="提交"  id="btn_cardpassword"  /></div>
			
		</li>
</ul>

</section>

<dl class="yu-lrpad10 yu-tbpad20">



 <% if (!string.IsNullOrEmpty(range.Remark))
    { %>
					<dt class="yu-font16 yu-bmar10">储值卡使用说明</dt>
					<dd class="yu-font14 yu-c66 yu-bmar10">
						 <%=range.Remark.Replace("\n","<br/>" ) %>
					</dd>
                    <%} %>
                   
			 
					<dt class="yu-font16 yu-bmar10">使用范围</dt>
					<dd class="yu-font14 yu-c66 yu-bmar10">
                    <ol class="yu-lpad20">

                    <% if (rangetxt.Count > 0)
                       { %>
                        <% foreach (var item in rangetxt)
                           {%>
                           	<li><%=item%></li>
                        <%  } %>
						 <%} %>

                         <% else
                             { %>
                         <li>酒店订房</li>
                        
                         <%} %>

                         </ol>
					</dd>
             
                  
				</dl>
</section>
    <!--基本页end-->
    <script>

        $(function () {
            //选项卡
            var tabIndex;
            $(".tab-nav").children("li").on("click", function () {
                $(this).addClass("cur").siblings("li").removeClass("cur");
                tabIndex = $(this).index();
                $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
            })
        })


        var flag = true;
        $(".recharge-list ul li").click(function () {

            if (flag == false) {

                // layer.msg("请不要重复点击");
                return false;
            }

            flag = false;

            $(".recharge-list ul li").removeClass("cur");
            $(this).addClass("cur");

            $.ajax({
                url: '/Recharge/RechargeUserAccount',
                type: 'post',
                data: { key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', cardId: $(this).attr("data-id"), mprice: $(this).find(".mprice").text().trim(), sprice: $(this).find(".sprice").text().trim() },
                dataType: 'json',
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {

                        window.location.href = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=<%=ViewData["appid"]%>&redirect_uri=http%3a%2f%2fhotel.weikeniu.com%2fWeiXinZhiFu%2fwxOAuthRedirect.aspx&response_type=code&scope=snsapi_base&state=" + ajaxObj.Mess + "#wechat_redirect";

                    }

                    else {
                        layer.msg(ajaxObj.Mess);

                        if (ajaxObj.Mess.indexOf("金额") > -1) {
                            setTimeout("window.location.href = window.location.href ", 2000);
                        }
                    }
                    flag = true;
                }


            });

        });



        $("#btn_cardpassword").click(function () {

            if ($("#cardpassword").val().trim() == "") {
                layer.msg("请输入卡密");
                return false;
            }


            if ($("#cardpassword").val().trim().length < 6) {
                layer.msg("请输入正确的卡密");
                return false;
            }

            $("#btn_cardpassword").attr("disabled", true);

            $.ajax({
                url: '/Recharge/RechargeCardPassword',
                type: 'post',
                data: { key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', cardpassword: $("#cardpassword").val().trim() },
                dataType: 'json',
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {

                        layer.msg(ajaxObj.Mess);
                        setTimeout("window.location.href = window.location.href ", 2000);
                    }

                    else {

                        layer.msg(ajaxObj.Mess);
                        $("#btn_cardpassword").attr("disabled", false);
                    }
                }
            });
        });

 
    
    </script>
</body>
</html>
