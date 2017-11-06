<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
    <link href="../../css/style.css?t=<%=DateTime.Now.ToString("yyyyMMddHHmmsssff") %>"
        rel="stylesheet" type="text/css" />
    <link href="../../Content/default.css" rel="Stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
</head>
<body>
    <section class='top'>
		<a href="javascript:void(0)" onclick="window.history.go(-1)"><p class='back'></p></a> 
		        忘记支付密码
		<p class='card'></p>
	</section>
    <section class='wrap sp '>
		<form class='info-form'>
			<div class='dl-group'>
			<%--   <dl>
				<dt>姓名:</dt>
				<dd><input type='text' id="gustname" placeholder='请输入姓名' /></dd>
			</dl>
            
         <dl>
				<dt>密码:</dt>
				<dd><input type="password" id="gustpwd" placeholder='请输入密码' /></dd>
			</dl>	
            	
            <dl>
				<dt>密码校验:</dt>
				<dd><input type='password' id="gustpwd1" placeholder='请再次输入密码' /></dd>
			</dl>	--%>
                	
			</div>
           
      
               <br />
			<div class='code'>
				<input type='text' class='sp' id="phone" placeholder='请输入会员手机号' />
				<p class='btn' id="sendcode">获取验证码</p>
                <p class='btn' id="P1" style="display:none;">30秒后重新发送</p>
			</div>

            	<div class='dl-group'>
			
				<input type='text' style="width:200px;" id="phonecode" placeholder='请输入验证码' />
				
			</div>
           
			<input type="button" class='type3' id="register" value='验  证' />

		</form>
		
	</section>
</body>
</html>
<script src="../../Scripts/m.hotel.com.core.min.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
        var utils = WXweb.utils;
        var cell = null;
        $("#sendcode").click(function () {
            var phone = $("#phone").val(); 
            if (phone != '<%=ViewData["phone"] %>') {
                utils.MsgBox('手机号验证错误!');
                return;
            }
            if (phone == '') {
                utils.MsgBox('手机号不能为空!');
                // $("#phone").attr("placeholder", "手机号不能为空");
                return;
            }
            var re = /^1\d{10}$/;
            if (!re.test(phone)) { utils.MsgBox('请填写正确的手机号码！'); return; }
            var prem = { phone: phone }
            $(this).hide();
            $("#P1").show();
            setTimeout(function () {
                $("#sendcode").show();
                $("#P1").hide();
            }, 30000)
            $.post("/MemberCard/SendRegisterMsg", prem, function (data, status) {
                cell = data;
                if (cell.state == 1) {
                    cell = data;
                } else {
                    $("#sendcode").show();
                    $("#P1").hide();
                }
                utils.MsgBox(cell.msg);
            });
        });

        $("#register").click(function () {
            var phone = $("#phone").val();
            var phonecode = $("#phonecode").val();
            var gustpwd = $("#gustpwd").val();
            var gustpwd1 = $("#gustpwd1").val();
            if (gustpwd == "") {
                utils.MsgBox('支付密码不能为空！');
                return;
            }
            if (gustpwd != gustpwd1) {
                utils.MsgBox('两次输入的密码不一致！');
                return;
            }
            if (phonecode == '') {
                utils.MsgBox('验证码不能为空！');
                return;
            }
            if (cell == null || cell.state == 0) {
                utils.MsgBox('验证码错误！');
                return;
            }
            //            if (cell.phone != phone) {
            //                utils.MsgBox('手机号于验证手机号不一致！');
            //                return;
            //            }
            var url = '<%=ViewData["MemberRestPassword"] %>&t=pwdrest';
            window.location.href = url;

        });

    })
</script>
