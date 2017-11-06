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
    <title>会员登录</title>
    <link href="../../css/style.css#t=<%=DateTime.Now.ToString("yyyyMMddHHmmsssff") %>" rel="stylesheet" type="text/css" />
    <link href="../../Content/default.css" rel="Stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
</head>
<body>
    <section class='top'>
		<a href="<%=ViewData["HomeMain"] %>"><p class='back'></p></a> 
		        会员登录
		<p class='card'></p>
	</section>
    <section class='wrap sp '>
		<form class='info-form'>
			<div class='dl-group'>
			<dl>
				<dt>账号:</dt>
				<dd><input type='text' id="gustname" placeholder='会员卡号 或 手机号' /></dd>
			</dl>		
			</div>
			<dl>
				<dt>密码:</dt>
				<dd><input type="password" id="gustpwd" placeholder='登录密码' /></dd>

			</dl>	

            <div style="text-align:right;"><a href="<%=ViewData["PwdRest"] %>&t=pwdrest">忘记密码?</a></div>
            <br />
			<input type="button" class='type3' id="loginbtn" value='登  录' />

            <a href="<%=ViewData["MemberInfoCenter"] %>"><input type="button" class="type4" value="领取会员卡" /></a> 

		</form>
	
	</section>
</body>
</html>
<script src="../../Scripts/m.hotel.com.core.min.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
        var utils = WXweb.utils;
        $("#loginbtn").click(function () {
            var gustname = $("#gustname").val();
            var gustpwd = $("#gustpwd").val();
            var weixinid = '<%=ViewData["weixinID"] %>';
            var userweixinid = '<%=ViewData["userWeiXinID"] %>';
            var hid = '<%=ViewData["hId"] %>';
            var prem = { gustname: gustname, gustpwd: gustpwd, weixinid: weixinid, userweixinid: userweixinid,hid:hid };
            if (gustname == '') {
                utils.MsgBox('账号不能为空!');
                return;
            }

            if (gustpwd == '') {
                utils.MsgBox('密码不能为空!');
                return;
            }

            $.post("/MemberCard/MemberLogin", prem, function (data, status) {
                if (data.state == 1) {
                    utils.MsgBox('登陆成功! 稍后自动跳转会员中心');
                    setTimeout(function () {
                        window.location.href = '<%=ViewData["MemberCenterUrl"] %>';
                    }, 1500);
                } else {
                    utils.MsgBox(data.msg);
                }
            });
        });
    });
</script>
