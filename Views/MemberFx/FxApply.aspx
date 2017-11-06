<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%        
    string hotelid = RouteData.Values["id"].ToString();
    string key = HotelCloud.Common.HCRequest.GetString("key");
    string weixinID = "";
    string userWeiXinID = "";
    if (key.Contains("@"))
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

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <meta charset="UTF-8" />
	<title>申请提现</title>
	<meta name="format-detection" content="telephone=no">
	<!--自动将网页中的电话号码显示为拨号的超链接-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
	<!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
	<meta name="apple-mobile-web-app-capable" content="yes">
	<!--IOS设备-->
	<meta name="apple-touch-fullscreen" content="yes">
	<!--IOS设备-->
	<meta http-equiv="Access-Control-Allow-Origin" content="*">
	<!--<link rel="stylesheet" href="../css/booklist/sale-date.css" />-->
   <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css"/>
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
</head>
<% hotel3g.Models.FxMemberInfo model = (hotel3g.Models.FxMemberInfo)ViewData["model"]; %>
<body class="ca-overflow">
       <!--//顶部导航-->
       <div class="ca__headNav fixed">
             <div class="head">
                  <a class="back" href="javascript:history.back(-1);"></a>
                  <h2 class="tit">申请提现</h2>
             </div>
       </div>
       <!--ca__headNav fixed end-->
       <div class="ca-m-apply">
             <div class="ca-safe-distance">
                   <div class="ca-ablty-amout">提现金额</div>
                   <div class="ca-write-money">￥<input type="text" placeholder="<%=model.CanPutOutCash2 %>" id="CanPutOutCash"></div>
                   <div class="ca-ablty-amout">可提现金额<%=model.CanPutOutCash2%></div>
             </div>
             <!--ca-safe-distance end-->
       </div>
       <!--ca-m-apply end-->
       <div class="ca-refer-to">
             <div class="ca-safe-distance">
                   <ul>
                        <li class="fl">提现到</li>
                        <li class="fr">微信钱包</li>
                   </ul>
             </div>
       </div>
       <!--ca-refer-to end-->
       <div class="ca-btn-safe-dis"><input type="button" value="立即提现" class="ca-wcash-btn"></div>
       <div class="ca-cash-striction">
            <div class="ca-safe-distance">
                  <p class="ca-font-middle">提现说明</p>
                  <p class="ca-font-small">提现申请在审核通过后，提现佣金将转到个人微信钱包。 </p>
            </div>
            <!--ca-safe-distance end-->
       </div>
       <!--ca-cash-striction end-->
	<!--弹窗-->
	    <section class="mask alert">
		    <div class="inner yu-w480r ca-just">
			    <div class="yu-bgw">
				    <p class="yu-lrpad40r yu-tbpad50r yu-textc yu-bor bbor yu-f30r" id="tishi_msg">提示信息</p>
				    <div class="yu-h80r yu-l80r yu-textc yu-c40 yu-f36r yu-grid">
					    <%--<p class="yu-overflow yu-bor rbor yu-c99" id="tishi_sure">确定</p>--%>
					    <p class="yu-overflow mask-close" id="tishi_close">好的，知道了</p>
				    </div>
			    </div>
		    </div>
	    </section>
       
	<script type="text/javascript">
	    $(function () {

	        //选项卡
	        var tabIndex;
	        $(".tab-nav").children("li").on("click", function () {
	            $(this).addClass("cur").siblings("li").removeClass("cur");
	            tabIndex = $(this).index();
	            $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
	        })

	        $(".ca-wcash-btn").on("click", function () {
	            var canmoney = '<%=model.CanPutOutCash2 %>'*1;
	            var money = $("#CanPutOutCash").val();
	            if (money == "") {
	                $('.alert').fadeIn();
	                $('#tishi_msg').html("请输入提现金额");
	                $("#CanPutOutCash").focus();
	                return;
	            } else {
	                if (isNaN(money)) {
	                    $('.alert').fadeIn();
	                    $('#tishi_msg').html("输入格式有误");
	                    $("#CanPutOutCash").focus();
	                    return;
	                }
	                if (parseFloat(money) <= 0) {
	                    $('.alert').fadeIn();
	                    $('#tishi_msg').html("提现金额必须大于0元");
	                    $("#CanPutOutCash").focus();
	                    return;
	                }
	                if (parseFloat(money) > parseFloat(canmoney)) {
	                    $('.alert').fadeIn();
	                    $('#tishi_msg').html("最多可提现金额" + canmoney);
	                    $("#CanPutOutCash").focus();
	                    return;
	                }
	            }

	            $.post('/MemberFx/SaveApply/?m=' + money + '&memberId=<%=model.Id%>&uwx=<%=ViewData["userweixinid"] %>&weixinid=<%=ViewData["weixinid"] %>', function (data) {
	                if (data.success) {
	                    window.location.href = '/MemberFx/FxIndex/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>';
	                } else {
	                    $('.alert').fadeIn();
	                    $('#tishi_msg').html(data.message);
	                    return;
	                }
	            });

	        })

	        $('.mask-close').on('click', function () {
	            $('.alert').fadeOut();
	        })
	    })
	</script>
	
</body>
</html>
