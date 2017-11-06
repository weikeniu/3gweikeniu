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
     <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />
    <script src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
     <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body>

   <article class="full-page"> 
            <%Html.RenderPartial("HeaderA", viewDic); %>
           <section class="show-body">		           	
			<section class="content2">
            
            	 <div class="pg__ucenter">
					<!--//支付密码-->
					<div class="uc__account-info uc__payPwd-info">
						<div class="hdTxt">找回密码</div>
						<div class="form">
							<ul class="clearfix forgot1">
								<li class="row2">
									<div class="inner flexbox">
										<label>手机号码</label>
										<div class="iptbox flex1">
											<input class="ipttext"   id="phone" type="number" name="oldPwd" placeholder="请输入手机号码" value="<%= ViewData["mobile"]  %>" />
										</div>
										<div class="getCode" id="sendcode">获取验证码</div>
                                        <div class="getCode" id="P1"  style="display:none">30秒后重新发送</div>
									</div>
								</li>
								<li class="row2">
									<div class="inner flexbox">
										<label>验证码</label>
										<div class="iptbox flex1"> 
											<input class="ipttext" type="number" name="newPwd" placeholder="请输入验证码"  id="phonecode" />
										</div>
									</div>
								</li>
							
							</ul>

                            <ul class="clearfix forgot2" style="display:none" >
                            	<li class="row2">
									<div class="inner flexbox">
										<label>新密码</label>
										<div class="iptbox flex1">
											<input class="ipttext" type="password" name="newPwd" placeholder="请输入新支付密码"  id="newpaypassword"  />
										</div>
									</div>
								</li>
								<li>
									<div class="inner flexbox">
										<label>确认新密码</label>
										<div class="iptbox flex1">
											<input class="ipttext" type="password" name="repeatPwd" placeholder="请再次输入新支付密码"  id="newpaypassword2" />
										</div>
									</div>
								</li>
                            </ul>
						</div>
						<div class="submit-btn sp forgot1">
							 
							<input type="button" class="btn-save" value="提交" id="btn_yz"  />
						</div>                         

                        <div class="submit-btn sp forgot2" style="display:none">
							 
							<input type="button" class="btn-save" value="提交"  id="btn_savepaypassword" />
						</div>
					 
					</div>
				</div>

            </section>
            </section>
            </article> 
</body>
</html>
<script type="text/javascript">


    $("#sendcode").click(function () {

        if ($("#phone").val().trim() == "") {

            layer.msg("请输入手机号码");
            return false;
        }
        $.ajax({
            url: '/RechargeA/SendMsg',
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
            url: '/RechargeA/ValidateMsgCode',
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
            url: '/RechargeA/SetPayPassword',
            type: 'post',
            data: { key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', mobile: $("#phone").val().trim(), code: $("#phonecode").val().trim(), newpayPassword: $("#newpaypassword").val().trim() },
            dataType: 'json',
            success: function (ajaxObj) {
                if (ajaxObj.Status == 0) {
                    layer.msg(ajaxObj.Mess);
                  setTimeout("window.location.href ='/userA/index/<%=RouteData.Values["id"]%>?key=<%=HotelCloud.Common.HCRequest.GetString("key")%>'", 2000);
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