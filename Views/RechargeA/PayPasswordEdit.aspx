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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8" />
    <title><%= ViewData["tipTitle"]%></title>
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
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
						<div class="hdTxt"><%= ViewData["tipTitle"]%></div>
						<div class="form">
							<ul class="clearfix">
								<li class="row2"  style="<%=ViewData["firstPaypassword"].ToString()=="1" ? "display:none" : "" %>" >
									<div class="inner flexbox">
										<label>原密码</label>
										<div class="iptbox flex1">
											<input class="ipttext" type="password" name="oldPwd" id="ypaypassword" placeholder="请输入原支付密码" />
										</div>
									</div>
								</li>
								<li class="row2">
									<div class="inner flexbox">
										<label>新密码</label>
										<div class="iptbox flex1">
											<input class="ipttext" type="password" name="newPwd" id="newpaypassword" placeholder="请输入新支付密码" />
										</div>
									</div>
								</li>
								<li>
									<div class="inner flexbox">
										<label>确认新密码</label>
										<div class="iptbox flex1">
											<input class="ipttext" type="password" id="newpaypassword2"  name="repeatPwd" placeholder="请再次输入新支付密码" />
										</div>
									</div>
								</li>
							</ul>
						</div>
                        	<div class="yu-pad20r yu-d-b  yu-textr">
                            <a href="/RechargeA/PayPasswordForgot/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>"   class="yu-blue2 yu-f30r"  style="<%=ViewData["firstPaypassword"].ToString()=="1" ? "display:none" : "" %>" >忘记密码？</a>
                            </div>
						<div class="submit-btn sp"  >
						<%--	<a href="#">保存</a>--%>

                            <input type="button"  value="保存" class="btn-save"  id="btn_savepaypassword" />
						</div>
					     <input type="hidden" value="<%=ViewData["firstPaypassword"]%>" id="hf_flagpassword" />
					</div>
				</div>



</section>
</section>
</article>
</body>
<script type="text/javascript">

    $("#btn_savepaypassword").click(function () {

         if($("#hf_flagpassword").val()=="0")
            {
        
            if ($("#ypaypassword").val().trim() == "") {
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
            url: '/RechargeA/EditPayPassword',
            type: 'post',
            data: { key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', ypaypassword: $("#ypaypassword").val().trim(), newpayPassword: $("#newpaypassword").val().trim() },
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
     
</script>
</html>
