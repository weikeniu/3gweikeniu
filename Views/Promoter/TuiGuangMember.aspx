<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
    <title>领取红包</title>
    <link type="text/css" rel="stylesheet" href="../../css/booklist/sale-date.css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="../../Scripts/fontSize.js"></script>
    <script src="../../Scripts/layer/layer.js" type="text/javascript"></script>
    	<link rel="stylesheet" href="../../css/booklist/mend-reset.css" />
	<link rel="stylesheet" href="../../css/booklist/mend-weikeniu.css" />
    <style>
    .layui-layer-content{max-width:170px;}
    </style>
    <%Html.RenderPartial("JSHeader"); %>
</head>

<body class="bg--6b0cae">
	<%    bool CanRegister = (bool)ViewData["CanRegister"];
         
            %>
            <% if (CanRegister)
               {
                   hotel3g.Repository.MemberCard UserInfoItem = ViewData["UserInfo"] as hotel3g.Repository.MemberCard;
               %> 
	<!-- <>红包推广 -->
	<div class="pg__hbPromotion clearfix">
		<!--//领取红包-->
		<div class="hb__receive hb__receive-vcode">
			<h2 class="amount">￥<%=ViewData["hongbao"] %></h2>
			<div class="vcode-info">
				<p class="tips">验证手机领取红包<%--验证码已发送到--%></p>
				<div class="flexbox">
             
					<input type="text" class="tel flex1" type="tel" placeholder="手机号码" id="phone" />
                 	<button  id="sendcode"  class="btn-send">获取验证码</button>
					<button  id="P1" style="display:none;" class="btn-send">重发<span id="timer" >30</span>s</button>
					<!--<button class="btn-send" disabled>重发59s</button>-->
				</div>
			</div>
			<input class="ipt-text" type="text" name="vcode" placeholder="请输入验证码" id="phonecode"  />
			<a class="btn-receive" id="register" href="javascript:;">领取</a>
		</div>
	</div>
	    <%}
               else
               { %>
    <center>
        暂无可使用会员卡 请联系酒店新增名额</center>
    <%} %>
	<script type="text/javascript">
	    /** __公共函数 */
	    $(function () {
	        //TODO...
	    });

	    /** __自定函数 */
	    $(function () {
	        //TODO...
	    });
	</script>
	
</body>
</html>
<script type="text/javascript">
    $(function () {


        var cell = null;
        $("#sendcode").click(function () {

            var phone = $("#phone").val();
            if (phone == '') {
                layer.msg('手机号不能为空!');
                $("#phone").attr("placeholder", "手机号不能为空");
                return;
            }
            var re = /^1\d{10}$/;
            if (!re.test(phone)) { layer.msg('请填写正确的手机号码！'); return; }
            var timeNum = 30;
            var timerInterval = setInterval(function () {
                timeNum--;
                $("#timer").text(timeNum);
                if (timeNum <= 0) {
                    clearInterval(timerInterval);
                }
            }, 1000);
            var weixinid = '<%=ViewData["weixinID"] %>';
            var prem = { phone: phone, weixinid: weixinid }
            $(this).hide();
            $("#P1").show();

            setTimeout(function () {
                $("#sendcode").show();
                $("#P1").hide();
            }, 30000);

            $.post('/MemberCard/SendRegisterMsg/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@ViewData["userWeiXinID"] %>', prem, function (data, status) {
                cell = data;
                if (cell.state == 1) {
                    cell = data;
                    bindCoupon(phone);
                }
                layer.msg(cell.msg);
            });
        });

        function bindCoupon(tel) {
            //手机号验证成功发放推广员红包
            var hid = '<%=ViewData["hId"] %>';
            var memberid = '<%=Request.QueryString["promoterid"].ToString()%>';
            var weixinid = '<%=ViewData["weixinID"] %>';
           
            var prems = { hid: hid, tel: tel, memberid: memberid, weixinid: weixinid };
            var url = '/Promoter/GetCoupon';
            $.post(url, prems, function (data, status) {
                var status = data.status;
                if (status > 0) {
                    //layer.msg("领取成功");
                } else {
                    //layer.msg(data.msg);
                }
            });
        }

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

            if (phonecode == '') {
                layer.msg('验证码不能为空！');
                return;
            }
            if (cell == null || cell.state == 0) {
                layer.msg('验证码错误！');
                return;
            }
            if (cell.phone != phone) {
                layer.msg('手机号于验证手机号不一致！');
                return;
            }
            if (cell.code != phonecode) {
                layer.msg('验证码错误！');
                return;
            }

            var prem = { weixinid: '<%=ViewData["weixinID"] %>', hid: '<%=ViewData["hId"] %>', userweixinid: '<%=ViewData["userWeiXinID"] %>', name: gustname, phone: cell.phone, gustpwd: gustpwd }
            $.post("/MemberCard/Register", prem, function (data, status) {
                if (data.state == 1) {
                    setTimeout(function () {
                        var url = '<%=ViewData["MemberEditPassword"] %>';
                        window.location.href = url;
                    }, 1500)
                    layer.msg('验证成功！稍后自动跳转...');
                } else {
                    layer.msg(data.msg);
                }
            });
        });

    })
</script>

