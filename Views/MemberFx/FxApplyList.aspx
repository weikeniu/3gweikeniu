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
	<title>分销佣金</title>
	<meta name="format-detection" content="telephone=no">
	<!--自动将网页中的电话号码显示为拨号的超链接-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
	<!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
	<meta name="apple-mobile-web-app-capable" content="yes">
	<!--IOS设备-->
	<meta name="apple-touch-fullscreen" content="yes">
	<!--IOS设备-->
	<meta http-equiv="Access-Control-Allow-Origin" content="*">
	<link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css?v=1.1"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css?v=1.1"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css?v=1.1"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css?v=1.1"/>
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js?v=1.1"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js?v=1.1"></script>

</head>
<body class="ca-overflow">
         <section class="loading-page" style="position: fixed;">
			<div class="inner">
				<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
				<img src="http://css.weikeniu.com/images/loading-n.png" />
			</div>
		</section>
     <!--//顶部导航-->
     <div class="ca__headNav fixed">
           <div class="head">
                <a class="back" href="javascript:history.back(-1);"></a>
                <h2 class="tit">分销佣金</h2>
           </div>
     </div>

     <div class="ca-ivdetail-content">
           <div class="ca-fx-title">
               <ul class="ca-displayfx">
                   <li class="ca-flex">日期</li>
                   <li class="ca-flex">金额</li>
                   <li class="ca-flex ca-last-right">状态</li>
               </ul>
          </div>
          <!--ca-fx-title end-->
          <div class="ca-fx-yjing">
                <ul id="ul_list">
                     <%--<li class="ca-displayfx">
                         <p class="fl"><span>2017-7-5 19:20:00</span></p>
                         <dl class="ca-flex ca-displayfx">
                             <dt><em></em></dt>
                             <dd>￥26</dd>
                         </dl>
                         <span class="ca-last-right fl">已经到账</span>
                     </li>
                     <li class="ca-displayfx">
                         <p class="fl"><span>2017-7-5 19:20:00</span></p>
                         <dl class="ca-flex ca-displayfx">
                             <dt><em></em></dt>
                             <dd>￥26</dd>
                         </dl>
                         <span class="ca-last-right fl">已经到账</span>
                     </li>--%>
                </ul>
          </div>
          <!--ca-distri-table end-->
          <div class="uc__loading-tips"></div>
      </div>
      <!--ca-ivdetail-content end-->

    <script src="http://js.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>
	<script type="text/javascript">
	    $(function () {
	        //选项卡
	        var tabIndex;
	        $(".tab-nav").children("li").on("click", function () {
	            $(this).addClass("cur").siblings("li").removeClass("cur");
	            tabIndex = $(this).index();
	            $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
	        });

	        //获取分页
	        var page = 0;
	        var userweixinid = '<%=ViewData["userweixinid"] %>';
	        var weixinid = '<%=weixinID %>';
	        var url = '/MemberFx/GetApplyList/<%=ViewData["hId"] %>';
	        var isEnd = false;

	        function getlist() {
	            loadstate(true);
	            if (!isEnd) {
	                if (userweixinid != '') {
	                    $.ajax({ url: url,
	                        async: true,
	                        data: { userweixinid: userweixinid, page: page, weixinid: weixinid },
	                        type: "post",
	                        success: function (data) {
	                            //获取成功
	                            if (data.success) {
	                                page = data.nextpage;
	                                packList(data.strjson);
	                            } else {
	                                isEnd = true;
	                                $(".uc__loading-tips").html("没有更多了...");
	                            }
	                            loadstate(false);
	                        },
	                        timeout: 5000,
	                        complete: function (XMLHttpRequest, status) {
	                            loadstate(false);
	                            //请求完成后最终执行参数
	                            if (status == 'timeout') {
	                                //超时,status还有success,error等值的情况
	                                layer.msg('网络超时!')
	                            }
	                        }
	                    });
	                }
	            } else {
	                loadstate(false);
	            }
	        }

	        function packList(json) {
	            console.log(json);
	            var html = '';
	            var ar = eval('(' + json + ')');
	            var status = '';
	            $.each(ar, function (i, t) {
	                if (t.state == '<%=Convert.ToInt32(hotel3g.Models.EnumMemberFXStatus.申请提现) %>') { status = '申请提现'; }
	                if (t.state == '<%=Convert.ToInt32(hotel3g.Models.EnumMemberFXStatus.提现申请审核不通过) %>') { status = '审核不通过'; }
	                if (t.state == '<%=Convert.ToInt32(hotel3g.Models.EnumMemberFXStatus.提现申请审核通过) %>') { status = '已到账'; }

	                html += '<li class="ca-displayfx"><p class="fl"><span>' + new Date(t.createtime).Format("yyyy-MM-dd") + '<br/>' + new Date(t.createtime).Format("hh:mm:ss") + '</span></p><dl class="ca-flex ca-displayfx"><dt><em></em></dt><dd>￥' + t.applymoney + '</dd></dl><span class="ca-last-right fl">' + status + '</span></li>';
	            });
	            $('#ul_list').append(html);
	        }

	        getlist();
	        var windowHeight = $(window).height();

	        $(window).scroll(function () {
	            var scrollTop = $(this).scrollTop(); //滚动高度
	            var windowHeight = $(this).height(); //窗口可视高度

	            var scrollHeight = $("body").get(0).scrollHeight; //窗口内容高度
	            //console.log(scrollHeight);
	            if (scrollTop + windowHeight == scrollHeight) {
	                getlist();
	            }
	        });

	        function loadstate(display) {
	            if (display) {
	                setTimeout(function () {
	                    $(".loading-page").hide();
	                }, 5000);
	                $(".loading-page").show();

	            } else {
	                $(".loading-page").hide();
	            }
	        }
	        $(".loading-page").hide();

	    })


	    Date.prototype.Format = function (fmt) { //author: meizz 
	        var o = {
	            "M+": this.getMonth() + 1, //月份 
	            "d+": this.getDate(), //日 
	            "h+": this.getHours(), //小时 
	            "m+": this.getMinutes(), //分 
	            "s+": this.getSeconds(), //秒 
	            "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
	            "S": this.getMilliseconds() //毫秒 
	        };
	        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	        for (var k in o)
	            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
	        return fmt;
	    }
	</script>
	
</body>
</html>
