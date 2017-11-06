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


    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();
%>
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
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*" />
    <title>填写登录密码</title>

        <link href="<%=ViewData["cssUrl"]%>/css/booklist/sale-date.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/css/booklist/new-style.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <link rel="stylesheet" href="<%=ViewData["cssUrl"]%>/css/booklist/mend-reset.css" />

    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
</head>
<body>
<article class="full-page">

     <%Html.RenderPartial("HeaderA", viewDic);%>

		<section class="show-body">	
 

			<section class="content2" >
    <form class="yu-tpad30r">

    <section class="yu-bgw yu-lpad32r yu-bor tbbor ">
	 		<div class="yu-grid yu-alignc yu-bor bbor yu-h88r yu-rpad33r">

	 			<p class="yu-f34r yu-w210r">用户姓名</p>
	 			<div class="yu-overflow">
                    <input class="yu-input1 yu-h88r yu-f34r" type='text' id="gustname" placeholder="请输入姓名" />
	 			</div>
	 		</div>

	 		<div class="yu-grid yu-alignc yu-bor bbor yu-h88r yu-rpad33r">
	 			<p class="yu-f34r yu-w210r">支付密码</p>
	 			<div class="yu-overflow">
	 				<input type="password" class="yu-input1 yu-h88r yu-f34r" id="gustpwd" placeholder="请输入支付密码" />
	 			</div>
	 		</div>

	 		<div class="yu-grid yu-alignc yu-h88r yu-rpad33r">
	 			<p class="yu-f34r yu-w210r">支付密码</p>
	 			<div class="yu-overflow">
	 				<input type="password" class="yu-input1 yu-h88r yu-f34r" id="gustpwd1" id="gustpwd1" placeholder='请再次输入支付密码'  />
	 			</div>
	 			<p class="ico"></p>
	 		</div>

	 	</section>
    <section class="yu-lrpad32r">
    <input id="register" type="button" class="yu-sub2 yu-h88r" style="background:#FF4400;" value="保存" /></section>
    </form>
    </section>
    </section>
    </article>
</body>
</html>
<script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {

        var cell = null;

        $("#register").click(function () {
            var phone = $("#phone").val();
            var gustname = $("#gustname").val();
            var phonecode = $("#phonecode").val();

            var gustpwd = $("#gustpwd").val();
            var gustpwd1 = $("#gustpwd1").val();

            if (gustname == "") {
                layer.msg('姓名不能为空！');
                return;
            }

            if (gustpwd == "") {
                layer.msg('密码不能为空！');
                return;
            }
            if (gustpwd != gustpwd1) {
                layer.msg('两次输入的密码不一致！');
                return;
            }

            var prem = { weixinid: '<%=ViewData["weixinID"] %>', hid: '<%=ViewData["hId"] %>', userweixinid: '<%=ViewData["userWeiXinID"] %>', gustname: gustname, gustpwd: gustpwd, phone: phone }
            $.post("/MemberCardA/EditMemberPassword", prem, function (data, status) {
                if (data.state == 1) {
                    setTimeout(function () {
                        var url = '<%=ViewData["MemberCenter"] %>';
                        window.location.href = url;
                    }, 500)
                    layer.msg('密码设置成功！稍后自动跳转...');
                } else {
                    layer.msg(data.msg);
                }
            });
        });

    })
</script>
