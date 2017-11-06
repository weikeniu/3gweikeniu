<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%

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
    <title>忘记支付密码</title>
    <link type="text/css" rel="stylesheet" href="<%= ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <script type="text/javascript" src="<%= ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%= ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <script src="<%= ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body>

<section class="yu-h64r yu-c88 yu-l64r yu-f28r yu-lpad32r yu-bor bbor">
 		找回密码
 	</section>
 	 
	 	<section class="yu-bgw yu-lpad32r yu-bor bbor yu-bmar60r forgot1">
	 	 
	 		<div class="yu-grid yu-alignc yu-bor bbor yu-h88r yu-rpad33r">
	 			<p class="yu-f34r yu-w180r">手机</p>
	 			<div class="yu-overflow">
	 				<input type="text" class="yu-input1 yu-h88r yu-f34r" placeholder="手机号码"  id="phone"  value="<%= ViewData["mobile"]  %>"   readonly="readonly"  />
	 			</div>
	 			<p class="yzm-btn"  id="sendcode">获取验证码</p>
               <p class='yzm-btn' id="P1" style="  display:none">30秒后重新发送</p>
	 		</div>
	 		<div class="yu-grid yu-alignc yu-h88r yu-rpad33r">
	 			<p class="yu-f34r yu-w180r">验证码</p>
	 			<div class="yu-overflow">
	 				<input type="number" class="yu-input1 yu-h88r yu-f34r" placeholder="短信验证码" id="phonecode"/>
	 			</div>
	 			<p class="ico"></p>
	 		</div>
	 	</section>
	 	<section class="yu-lrpad32r forgot1"><input type="button" class="yu-sub2 yu-h88r" value="提交"  id="btn_yz" /></section>
 
    <section class="yu-bgw yu-lpad32r yu-bor tbbor yu-bmar60r forgot2"  style="display:none" >
	 	 
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
	 	</section>

        <section class="yu-lrpad32r forgot2" style="display:none" >
        <input type="button" class="yu-sub2 yu-h88r" value="提交"  id="btn_savepaypassword" /></section>

</body>
</html>
<script type="text/javascript">


    $("#sendcode").click(function () {

        if ($("#phone").val().trim() == "") {

            layer.msg("请输入手机号码");
            return false;
        }
        $.ajax({
            url: '/Recharge/SendMsg',
            type: 'post',
            data: { key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', mobile: $("#phone").val().trim() },
            dataType: 'json',
            success: function (ajaxObj) {
                if (ajaxObj.Status == 0) {
                    layer.msg(ajaxObj.Mess);
                    settime($("#sendcode"));

                }

                else {
                    layer.msg(ajaxObj.Mess);

                }
            }


        });

    });



    $("#btn_yz").click(function () {

        if ($("#phone").val().trim() == "") {

            layer.msg("请输入手机号码");
            return false;
        }

        $("#btn_yz").attr("disabled", true);

        $.ajax({
            url: '/Recharge/ValidateMsgCode',
            type: 'post',
            data: { key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', mobile: $("#phone").val().trim(), code: $("#phonecode").val().trim() },
            dataType: 'json',
            success: function (ajaxObj) {
                if (ajaxObj.Status == 0) {
                    layer.msg(ajaxObj.Mess);
                    $(".forgot2").show();
                    $(".forgot1").hide();

                }

                else {
                    layer.msg(ajaxObj.Mess);
                    $("#btn_yz").attr("disabled", false);
                }
            }


        });


    });


    $("#btn_savepaypassword").click(function () {


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
            url: '/Recharge/SetPayPassword',
            type: 'post',
            data: { key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', mobile: $("#phone").val().trim(), code: $("#phonecode").val().trim(), newpayPassword: $("#newpaypassword").val().trim() },
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


    var countdown = 30;

    function settime(obj) {

        if (countdown == 0) {
            obj.css("display", "");
            $("#P1").css("display", "none");
            obj.text("发送验证码");
            countdown = 30;
            return;
        } else {
            obj.css("display", "none");

            $("#P1").css("display", "");
            $("#P1").text("" + countdown + "秒后重新发送");
            countdown--;
        }
        setTimeout(function () {
            settime(obj)
        }
    , 1000)
    }



</script>
