<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    List<WeiXin.Models.Home.RechargeUser> list = ViewData["list"] as List<WeiXin.Models.Home.RechargeUser>;
    int page = Convert.ToInt32(ViewData["page"]);
    int pagesize = Convert.ToInt32(ViewData["pagesize"]);
    int count = Convert.ToInt32(ViewData["count"]);
    int pagenum = count % pagesize == 0 ? count / pagesize : count / pagesize + 1;

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>储值卡明细</title>
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
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css" />
    <script src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body>
    <!--储值卡明细-->
    <section class="select-page" style="display: block">
	<header class="yu-bor bbor">
	 	<a href="javascript:history.go(-1);" class="back"><div class="new-l-arr"></div></a>
		储值卡明细  
	</header>
	<section class="yu-bgw" id="data_content">

    <% foreach (var item in list)
       { %>
       		<div class="yu-grid yu-lrpad10 yu-tbpad20 yu-bor bbor">
			<div class="yu-overflow">
				<p class="yu-font14"><%=item.PayType==0 ? "现金支付" : "在线支付"  %></p>
				<p class="yu-font12">余额：<%=item.Balance %></p>
			</div>
			<div class="yu-textr">
          
				<p class="yu-font14 yu-fontb"> <%= item.MPrice >0 ? "+" : "" %><%= (item.MPrice)%></p>     
                
				<p class="yu-font12 yu-c99"><%=item.AddTime.ToString("yyyy-MM-dd HH:mm:ss") %></p>
			</div>
		</div>	            
       <%} %>

	</section>

              		
</section>
    <input type="hidden" id="cur_page" value="<%=page%>" />
    <input type="hidden" id="cur_sumpage" value="<%=pagenum%>" />
    <!--end-->

         <section class="loading-page" style="position: fixed; display: none">
			<div class="inner">
				<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
				<img src="http://css.weikeniu.com/images/loading-n.png" />
			</div>
		</section>
</body>
<script>


    var isEnd = false;

    function getMoreData() {
        if (isEnd) {

            return false;
        }

        var cur_page = parseInt($('#cur_page').val());
        var cur_sumpage = parseInt($('#cur_sumpage').val());

        if (cur_page >= cur_sumpage) {
            return false;
        }
        var tmp = {
            page: cur_page + 1,
            key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>'
        };


       // layer.load();
        $(".loading-page").show();

        tmp.select = "";
        tmp.query = "";

        $.ajax({
            data: tmp,
            type: 'post',
            url: '/Recharge/FetchRechargeOrder',
            dataType: 'json'
        }).done(function (data) {
            if (data) {
                var html = '';
                if (data.data) {
                    data.data = $.parseJSON(data.data);
                    for (var i = 0; i < data.data.length; i++) {


                        html += '<div class="yu-grid yu-lrpad10 yu-tbpad20 yu-bor bbor">' +
			'<div class="yu-overflow">' +
				'<p class="yu-font14">' + (data.data[i].PayType == "0" ? "现金支付" : "在线支付") + '</p>' +
				'<p class="yu-font12">余额：' + data.data[i].Balance + '</p>' +
			'</div>' +
			'<div class="yu-textr">' +
				'<p class="yu-font14 yu-fontb">'+ (parseFloat(data.data[i].MPrice) >0  ?  "+" : "") + ''+ parseFloat(data.data[i].MPrice).toFixed(2) + '</p>' +
				'<p class="yu-font12 yu-c99">' + data.data[i].AddTime + '</p>' +
			'</div>' +
		'</div>';
                    }

                    $('#cur_page').val(data.page);
                    $('#cur_sumpage').val(data.pagesum);

                    if (data.count == 0 || data.page >= data.pagesum) {
                        isEnd = true;
                    }
                }

                $('#data_content').append(html);

                if (isEnd) {
                    $("#data_content").append('<p style="text-align:center;color:#aaa;padding:10px 0px 10px 0px;" id="nomore">没有更多了...</p>');
                }

                $(".loading-page").hide();
                //layer.closeAll();
            }

        });
    }


    $(window).scroll(function () {
        var scrollTop = $(this).scrollTop();
        var scrollHeight = $(document).height();
        var windowHeight = $(this).height();
        if (scrollTop + windowHeight == scrollHeight) {
            getMoreData();
        }
    });

</script>
</html>
