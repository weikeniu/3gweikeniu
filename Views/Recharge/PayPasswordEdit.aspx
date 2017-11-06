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

    ViewData["tipTitle"] = ViewData["firstPaypassword"].ToString() == "1" ? "设置支付密码" : "修改支付密码";

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta name="keywords" content="关键词1,关键词2,关键词3" />
    <meta name="description" content="对网站的描述" />
    <meta name="format-detection" content="telephone=no" />
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes" />
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*" />
    <title><%= ViewData["tipTitle"]%></title>
    <link type="text/css" rel="stylesheet" href="<%= ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <script type="text/javascript" src="<%= ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%= ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <script src="<%= ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body>
    <form class="yu-tpad30r">
    <section class="yu-bgw yu-lpad32r yu-bor tbbor yu-bmar60r">
	 		<div class="yu-grid yu-alignc yu-bor bbor yu-h88r yu-rpad33r"  style="<%=ViewData["firstPaypassword"].ToString()=="1" ? "display:none" : "" %>"   >
	 			<p class="yu-f34r yu-w210r">原密码</p>
	 			<div class="yu-overflow">
	 				<input type="password"  id="ypaypassword"  class="yu-input1 yu-h88r yu-f34r" placeholder="请输入原支付密码"/>
	 			</div>
	 		</div>
	 		<div class="yu-grid yu-alignc yu-bor bbor yu-h88r yu-rpad33r">
	 			<p class="yu-f34r yu-w210r">新密码</p>
	 			<div class="yu-overflow">
	 				<input type="password" id="newpaypassword" class="yu-input1 yu-h88r yu-f34r" placeholder="请输入新支付密码"/>
	 			</div>
	 			
	 		</div>
	 		<div class="yu-grid yu-alignc yu-h88r yu-rpad33r">
	 			<p class="yu-f34r yu-w210r">确认新密码</p>
	 			<div class="yu-overflow">
	 				<input type="password" id="newpaypassword2" class="yu-input1 yu-h88r yu-f34r" placeholder="请再次输入新支付密码"/>
	 			</div>
	 			<p class="ico"></p>
	 		</div>
          <a href="/Recharge/PayPasswordForgot/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>" class="yu-blue2 forget-pw yu-f12r"   style="<%=ViewData["firstPaypassword"].ToString()=="1" ? "display:none" : "" %>" >忘记密码?</a>
	 	</section>
    <input type="hidden" value="<%=ViewData["firstPaypassword"]%>" id="hf_flagpassword" />
    <section class="yu-lrpad32r">  
<input type="button" class="yu-sub2 yu-h88r" value="保存"  id="btn_savepaypassword" />

</section>
    </form>
</body>
</html>
<script type="text/javascript">

    $("#btn_savepaypassword").click(function () {

        
            if($("#hf_flagpassword").val()=="0")
            {
                if ( $("#ypaypassword").val().trim() == "") {
                layer.msg("请输入原密码");
                return false;
            }

            }
      

        if ($("#newpaypassword").val().trim() == "") {
            layer.msg("请输入新密码");
            return false;
        }

        if ($("#newpaypassword").val().trim().length < 6) {
            layer.msg("新密码至少六位");
            return false;
        }

        if ($("#newpaypassword").val().trim() != $("#newpaypassword2").val().trim()) {
            layer.msg("密码不一致");
            return false;
        }


        $("#btn_savepaypassword").attr("disabled", true);

        $.ajax({
            url: '/Recharge/EditPayPassword',
            type: 'post',
            data: { key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', ypaypassword: $("#ypaypassword").val().trim(), newpayPassword: $("#newpaypassword").val().trim() },
            dataType: 'json',
            success: function (ajaxObj) {
                if (ajaxObj.Status == 0) {
                    layer.msg(ajaxObj.Mess);
                    setTimeout("window.location.href ='/user/index/<%=RouteData.Values["id"]%>?key=<%=HotelCloud.Common.HCRequest.GetString("key")%>'", 2000);
                }

                else {
                    layer.msg(ajaxObj.Mess);
                    $("#btn_savepaypassword").attr("disabled", false);
                }
            }


        });

    });
     
</script>
