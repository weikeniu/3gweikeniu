<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
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
    <title>填写登录密码</title>
     <link href="../../css/style.css?t=<%=DateTime.Now.ToString("yyyyMMddHHmmsssff") %>" rel="stylesheet" type="text/css" />
     <link href="../../Content/default.css" rel="Stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
</head>
<body>
	<section class='top'>
		<a href="javascript:void(0);" onclick="window.history.go(-1)"><p class='back'></p></a> 
		       修改支付密码
		<p class='card'></p>
	</section> 
	<section class='wrap sp '>
		<form class='info-form'>
			<div class='dl-group'>
        
       <dl>
				<dt>密码:</dt>
				<dd><input type="password" id="gustpwd" placeholder='请输入密码' /></dd>
			</dl>	
            	
            <dl>
				<dt>密码校验:</dt>
				<dd><input type='password' id="gustpwd1" placeholder='请再次输入密码' /></dd>
			</dl>
                	
			</div>
    <br />

         
			<input type="button" class='type3' id="register" value='保  存' />
		</form>
		
	</section>
</body>
</html>
<script src="../../Scripts/m.hotel.com.core.min.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
        var utils = WXweb.utils;
        var cell = null;

        $("#register").click(function () {
            var phone = $("#phone").val();
            var phonecode = $("#phonecode").val();

            var gustpwd = $("#gustpwd").val();
            var gustpwd1 = $("#gustpwd1").val();

            if (gustpwd == "") {
                utils.MsgBox('密码不能为空！');
                return;
            }
            if (gustpwd != gustpwd1) {
                utils.MsgBox('两次输入的密码不一致！');
                return;
            }

            var prem = { weixinid: '<%=ViewData["weixinID"] %>', hid: '<%=ViewData["hId"] %>', userweixinid: '<%=ViewData["userWeiXinID"] %>', gustname:"", gustpwd: gustpwd}
            $.post("/MemberCard/RestMemberPassword", prem, function (data, status) {
                if (data.state == 1) {
                    setTimeout(function () {
                        var url = '<%=ViewData["MemberCenter"] %>';
                        window.location.href = url;
                    }, 2000)
                    utils.MsgBox('密码设置成功！稍后自动跳转...');
                } else {
                    utils.MsgBox(data.msg);
                }
            });
        });

    })
</script>
