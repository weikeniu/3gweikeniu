<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    int PromoterID = (int)ViewData["PromoterID"];

    string hid = ViewData["hId"] as string;
    string key = HotelCloud.Common.HCRequest.GetString("key");
%>
<%
    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string hotelid = RouteData.Values["id"].ToString();
    string userWeiXinID = "";
    userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
    if (weixinID.Equals(""))
    {
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
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <title>注册会员</title>
    <link href="<%=ViewData["cssUrl"]%>/css/booklist/sale-date.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/css/booklist/new-style.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <link rel="stylesheet" href="<%=ViewData["cssUrl"]%>/css/booklist/mend-reset.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
    <style>
        .layui-layer-content
        {
            max-width: 170px;
        }
    </style>
</head>
<body>
    <form>
    <article class="full-page">

     <%Html.RenderPartial("HeaderA", viewDic);%>

		<section class="show-body">	
 

			<section class="content2" >

    <section class="yu-h64r yu-c88 yu-l64r yu-f28r yu-lpad32r yu-bor bbor">
 		基本信息
 	</section>
  
    <section class="yu-bgw yu-lpad32r yu-bor bbor yu-bmar60r">
       <% 
           bool CanRegister = (bool)ViewData["CanRegister"];
         
            %>
            <% if (CanRegister)
               {
                   hotel3g.Repository.MemberCard UserInfoItem = ViewData["UserInfo"] as hotel3g.Repository.MemberCard;
               %> 

               <% if (UserInfoItem != null && !string.IsNullOrEmpty(UserInfoItem.nickname))
                  { %>
               
	 		<div class="yu-grid yu-alignc yu-bor bbor yu-h88r yu-rpad33r">
	 			<p class="yu-f34r yu-w180r">微信昵称</p>
	 			<div class="yu-overflow yu-f34r">
	 			<%=UserInfoItem.nickname %>
	 			</div>
	 			<p class="hy-ico"></p>
	 		</div>

               <%} %>

                   <div class="yu-grid yu-alignc yu-h88r yu-rpad33r yu-bor bbor">
	 			<p class="yu-f34r yu-w180r">姓名</p>
	 			<div class="yu-overflow">
	 				<input type="text" class="yu-input1 yu-h80r yu-f34r" placeholder="您的姓名"  id="gustname" />
	 			</div>
	 			<p class="ico"></p>
	 		</div>


	 		<div class="yu-grid yu-alignc yu-bor bbor yu-h88r yu-rpad33r yu-ov-h">
	 			<p class="yu-f34r yu-w180r">手机</p>
	 			<div class="yu-overflow">
	 				<input type="number" class="yu-input1 yu-h88r yu-f34r" placeholder="手机号码" id="phone" />
	 			</div>
	 			<p class="yzm-btn" id="sendcode" style="cursor:pointer;border:#FF4400 solid 1px;color:#FF4400">获取验证码</p>
                 <p class='btn yzm-btn' id="P1" style="display:none;border:#FF4400 solid 1px;color:#FF4400"><span id="timer" >30</span>秒后重发</p>
	 		</div>
	 		<div class="yu-grid yu-alignc yu-h88r yu-rpad33r">
	 			<p class="yu-f34r yu-w180r">验证码</p>
	 			<div class="yu-overflow">
	 				<input type="text" class="yu-input1 yu-h88r yu-f34r" placeholder="短信验证码"  id="phonecode" />
	 			</div>
	 			<p class="ico"></p>
	 		</div>
	 	</section>
    <section class="yu-lrpad32r">
    <input type="button" id="register"  class="yu-sub2 yu-h88r" style="background:#FF4400;" value="提交" />
        </section>
    <%}
               else
               { %>
    <center>
        暂无可使用会员卡 请联系酒店新增名额</center>
    <%} %>
    
    
    </section>
    </section>
    </article>
    </form>
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
                       bindCoupon(cell.phone);
                }
                layer.msg(cell.msg);
            });
        });

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
            $.post("/MemberCardA/Register", prem, function (data, status) {
                if (data.state == 1) {
                    setTimeout(function () {
                      var url = '/UserA/Index/<%=hid %>?key=<%=key %>';
                        window.location.href = url;
                    }, 1500)
                    layer.msg('验证成功！稍后自动跳转...');
                  
                } else {
                    layer.msg(data.msg);
                }
            });
        });

         
                         function bindCoupon(tel) { 
                          <% if(PromoterID>0){
                    %>
            //手机号验证成功发放推广员红包
            var hid = '<%=ViewData["hId"] %>';
            var memberid = '<%=PromoterID %>';
            var weixinid = '<%=ViewData["weixinID"] %>';
           
                  if (tel != '' && hid != '' && memberid != '' && weixinid != '') {
                 
                    var prem = { hid: hid, tel: tel, memberid: memberid, weixinid: weixinid };
                    var url = '/Promoter/GetCoupon';
                    $.post(url, prem, function (data, status) {
                        var status = data.status;
                       
                    });
                }
              <%
                    } %>
        }
                  

    })
</script>
