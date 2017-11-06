<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    var cardcustom = ViewData["cardcustom"] as hotel3g.Models.Home.MemberCardCustom;
    var memberEntity = ViewData["memberEntity"] as WeiXin.Common.MemberEntity;

    string hotelName = ViewData["hotelName"] == null ? string.Empty : ViewData["hotelName"].ToString();
    string cardPic = ViewData["cardPic"] == null ? string.Empty : ViewData["cardPic"].ToString();
    string cardLogo = ViewData["cardLogo"] == null ? string.Empty : ViewData["cardLogo"].ToString();
    cardPic = cardPic.Replace("html/images", "images/cards");

    

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
<head>
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
    <title>填写订单</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body>
    <article class="full-page">
      <%Html.RenderPartial("HeaderA", viewDic); %>
      		<!--//内容区-->
		<section class="show-body">
			<section class="content2 yu-bpad60">
				
				<div class="pg__ucenter" style="padding-bottom: 0;">
					<!--//会员卡售卖(列表)-->
					<div class="uc__memberCard-sale" style="background: #fff;">
						<ul class="clearfix">
							<li>
							 	<div class="card-cnt type01">

                               <% if (!string.IsNullOrEmpty(cardPic))
                                  { %>
                          
									<img class="card-img" src="<%=cardPic%>" />
                                    <%} %>


									<div class="hd">
                                    <% if (!string.IsNullOrEmpty(cardLogo))
                                       { %>
										<img class="logo fl" src="<%=cardLogo %>" />
                                        <%} %>
										<div class="name">
											<h2><%=hotelName%></h2>
											<p><%=cardcustom.CardName%></p>
										</div>
										<label class="type">终身卡</label>
									</div>
									<div class="ct">
										<div class="inner clearfix">

                                        <%if (cardcustom.CouponType == 0)
                                          { %>
											<div class="discount fl"><em><%=Convert.ToDouble(cardcustom.Discount)%></em> 折</div>
                                            	<div class="tips fl">
												<p>开卡即享预订酒店折扣</p>
												<p>超值会员价</p>
											</div>
                                               
                                            <%}
                                          else
                                          { %>                                
                                           <div class="discount fl">立减 <em><%=Convert.ToDouble(cardcustom.Reduce)%></em> 元</div>     

                                           <div class="tips fl">
												<p>开卡即享预订酒店现金立减</p>
												<p>超值会员价</p>
											</div>
                                           <%} %>
                                           
											
										</div>
									</div>

                                     
									<div class="ft">
										<p>有效期：长期有效</p>
									</div>
								</div>
							</li>
						</ul>
						<div class="notice-tips">
							说明：会员卡为优惠折扣卡，不可储值，不可退换
						</div>
					</div>
					
					<!--//支付密码-->
					<div class="uc__account-info" style="margin-top: .2rem;">
						<div class="form">
							<ul class="clearfix">

                             <% if (!string.IsNullOrEmpty(memberEntity.NickName))
                                { %>
								<li class="row2">
									<div class="inner flexbox">
										<label>微信名称</label>
										<div class="iptbox flex1">
											<div class="divtext"><%=memberEntity.NickName %></div>
										</div>
									</div>
								</li>
                                <%} %>
								<li class="row2">
									<div class="inner flexbox">
										<label>用户名称</label>
										<div class="iptbox flex1">
                                      
                                       
											<input class="ipttext" type="text" name="username" id="username" placeholder="请输入用户名" value="<%=string.IsNullOrEmpty(memberEntity.Name) ? "" :memberEntity.Name %>"   <%=string.IsNullOrEmpty(memberEntity.Name) ? "" :"readonly" %>  />
										</div>
									</div>
								</li>
								<li class="row2">
									<div class="inner flexbox">
										<label>手机号码</label>
										<div class="iptbox flex1">
											<input class="ipttext" type="tel" name="telphone"  id="telphone" placeholder="请输入手机号码" value="<%=string.IsNullOrEmpty(memberEntity.Mobile) ? "" :memberEntity.Mobile %>"   <%=string.IsNullOrEmpty(memberEntity.Mobile) ? "" :"readonly" %>  />
										
                                        
                                       <% string showyzm = string.IsNullOrEmpty(memberEntity.Mobile) ? "" : "display:none"; %>
                                        
                                       
                                        <input type="button" class="btn-getCode"  id="sendcode" value="获取验证码"  style="<%=showyzm %> " />                                  
                                        <div class="btn-getCode" id="P1"  style="display:none">30秒后重新发送</div>

                                       
										</div>
									</div>
								</li>
                                 
								<li class="row2"     style="<%=showyzm %> " >
									<div class="inner flexbox">
										<label>验证码</label>
										<div class="iptbox flex1">
											<input class="ipttext" type="number"  name="vcode" id="vcode" placeholder="请输入验证码" />
										</div>
									</div>
								</li>
                             
							 
							</ul>
						</div>
						<div class="text__tips">
							<p>会员卡开通后，不可退卡</p>
						</div>
					</div>
				</div>
			</section>
			<!--底部-->
			<footer class="yu-grid fix-bottom yu-bor tbor yu-lpad10 sp">
				<div class="yu-overflow yu-f30r">
					<p id="p-total-amount">合计￥<%=Convert.ToDouble(cardcustom.BuyMoney) %></p>
					<p class="yu-grey yu-font12"></p>
				</div>
			 

              <input class="yu-btn yu-bg40"  value="立即支付"  style="border:none" id="btn_buy"></input>
              
			</footer>
		</section>


        </article>
    <script>



        $("#btn_buy").click(function () {

            if ($("#username").val().trim() == "") {
                layer.msg("请输入用户名");
                return false;
            }

            var phonenumber = $('#telphone').val().trim();
            if (!/^1\d{10}$/.test(phonenumber)) {
                layer.msg("请输入正确手机号码");
                return false;
            }

            if (!$("#vcode ").is(":hidden")) {
                if ($("#vcode").val().trim() == "") {
                    layer.msg("请输入验证码");
                    return false;
                }
            }

            $("#btn_buy").attr("disabled", true);

            $.ajax({
                url: '/MemberCardA/UserBuyMemberCard',
                type: 'post',
                data: { Id: '<%=hotelid %>', key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', mobile: $("#telphone").val().trim(), code: $("#vcode").val().trim(), username: $("#username").val().trim(), cardId: '<%= Request.QueryString["CardId"]%>' },
                dataType: 'json',
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {
                        window.location.href = '/Recharge/CardPay/<%=hotelid%>?key=<%=weixinID %>@<%=userWeiXinID %>&paytype=wx&orderNo=' + ajaxObj.Mess;
                    }

                    else {
                        layer.msg(ajaxObj.Mess);
                        $("#btn_buy").attr("disabled", false);
                    }
                }



            });
        });


        $("#sendcode").click(function () {

            var phonenumber = $('#telphone').val().trim();
            if (!/^1\d{10}$/.test(phonenumber)) {
                layer.msg("请输入正确手机号码");
                return false;
            }


            $.ajax({
                url: '/MemberCardA/SendMsg',
                type: 'post',
                data: { key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', mobile: $("#telphone").val().trim() },
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
</body>
</html>
