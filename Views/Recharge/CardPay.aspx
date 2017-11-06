<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 

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

    string payType = Request.QueryString["payType"];

    //string weixinUrl = string.Format("https://open.weixin.qq.com/connect/oauth2/authorize?appid={1}&redirect_uri=http%3a%2f%2fhotel.weikeniu.com%2fWeiXinZhiFu%2fwxOAuthRedirect.aspx&response_type=code&scope=snsapi_base&state={0}#wechat_redirect", Request.QueryString["orderNO"].Trim(), ViewData["appid"].ToString());
    string weixinUrl = string.Format("http://hotel.weikeniu.com/WeiXinZhiFu/wxpaycenter.aspx?p={1}&o={0}", Request.QueryString["orderNO"].Trim(), ViewData["appid"].ToString());
    if (Convert.ToInt32(ViewData["isMustWeixin"]) == 1 || payType == "wx")
    {
        Response.Redirect(weixinUrl);
    }


    string userhref = string.Format("/user/myorders/{0}?key={1}@{2}", hotelid, weixinID, userWeiXinID);
    string forgothref = string.Format("/Recharge/PayPasswordForgot/{0}?key={1}@{2}", hotelid, weixinID, userWeiXinID);
    if (ViewData["edition"].ToString() == "1")
    {
        userhref = string.Format("/userA/myorders/{0}?key={1}@{2}", hotelid, weixinID, userWeiXinID);
        forgothref = string.Format("/RechargeA/PayPasswordForgot/{0}?key={1}@{2}", hotelid, weixinID, userWeiXinID);
    }

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
    <title>支付方式</title>
    <link type="text/css" rel="stylesheet" href="<%= ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%= ViewData["cssUrl"] %>/css/booklist/Restaurant.css" />
    <script type="text/javascript" src="<%= ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%= ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body>
    <!--基本页-->
    <section class="base-page">
	<header class="yu-bor bbor">

     
      	<a href="<%=userhref %>" class="back"></a>
       
	 	支付方式
	</header>
 

    <%  string curdis = Convert.ToDecimal(ViewData["payMoney"]) > Convert.ToDecimal(ViewData["balance"]) ? "dis" : "";   %>
	<section class="yu-bgw">
		<div class="yu-lrpad10 yu-tbpad20 yu-bor bbor yu-grid yu-arr yu-alignc card-pay">
			<p class="pay-type type1 yu-rmar5 <%=curdis %>"></p>
			<p class="yu-overflow">储值卡支付</p>
		</div>
		<div class="yu-lrpad10 yu-tbpad20 yu-bor bbor yu-grid yu-arr yu-alignc weixin-pay">
			<p class="pay-type type2 yu-rmar5"></p>
			<p class="yu-overflow">微信支付</p>
		</div>
	</section>
</section>
    <section class="date-page">
	<header class="yu-bor bbor">
	 	<a href="#" class="back"></a>
	 	储值卡支付
	</header>
	<section>
		<div class="yu-bgblue2 yu-white yu-textc yu-tbpad20">
			<p class="yu-font40 yu-bmar5">￥<%=ViewData["payMoney"]%></p>
			<p class="yu-font12 balance">卡内余额￥<%=ViewData["balance"]%></p>
		</div>
		<div class="yu-bgw yu-pad10 yu-bor bor">
		<form   method="post"  action="/Recharge/PayMoney/<%=RouteData.Values["id"]%>?key=<%=HotelCloud.Common.HCRequest.GetString("key")%>&edition=<%=ViewData["edition"] %>"   id="payForm" >
				<div class="pay-password yu-grid">
					<div class="yu-bor1 bor yu-overflow password-bor"><input type="password" placeholder="请输入储值卡交易密码"  id="payPassword"  name="payPassword"  /></div>
					<div class="yu-bor1 bor submit-bor"><input type="button"  value="提交"  id="btn_tj"    /></div>
				</div>

                <input  type="hidden" value="<%=HotelCloud.Common.HCRequest.GetString("orderNo") %>"  id="orderNo"  name="orderNo"  />
			</form>
			<div class="yu-overflow yu-tpad10"><a href="<%=forgothref %>" class="fr yu-blue2 yu-font14">忘记密码?</a></div>
		</div>
	</section>
</section>
    <script>

        var payType = '<%=payType %>';
        $(function () {

            //选择方式
            $(".card-pay").click(function () {

                if (!$(this).children().hasClass("dis")) {
                    $(".base-page").hide();
                    $(".date-page").show();
                }
            })
            $(".date-page .back").click(function () {
                $(".base-page").show();
                $(".date-page").hide();
            })
            //密码输入监听
            function checkVal() {
                if ($(".pay-password input[type='password']").val() != "") {
                    $(".pay-password .submit-bor").addClass("cur");
                } else {
                    $(".pay-password .submit-bor").removeClass("cur");
                }
            };
            checkVal();
            $(document).keyup(function () {
                checkVal();
            });


            if (payType == "card") {
                $(".card-pay").trigger('click');
            }

        })

        $("#btn_tj").click(function () {

            if ($("#payPassword").val() == "") {
                return false;
            }

            $("#btn_tj").attr("disabled", true);

            $.ajax({
                url: '/Recharge/ValidatePayPassword',
                type: 'post',
                data: { key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', payPassword: $("#payPassword").val() },
                dataType: 'json',
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {
                        $("#payForm").submit();
                    }

                    else {
                        layer.msg(ajaxObj.Mess);
                        $("#btn_tj").attr("disabled", false);
                    }
                }


            });

        });


        $(".weixin-pay").click(function () {

            window.location.href = '<%=weixinUrl%>';

        });

    </script>
</body>
</html>
