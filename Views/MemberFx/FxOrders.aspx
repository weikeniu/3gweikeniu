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

<html lang="zh-cn">
<head>
	<meta charset="UTF-8" />
	<title>分销订单</title>
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
                <a class="back"  href="javascript:history.back(-1);"></a>
                <h2 class="tit">分销订单</h2>
           </div>
     </div>
     <div>
           <ul class="j-table-show">
                <li class="ca-flex cur1 curTab" onclick="curTab(1)"><a href="javascript:;">全部订单</a></li>
                <li class="ca-flex cur2" onclick="curTab(2)"><a href="javascript:;">已完成单</a></li>
                <li class="ca-flex cur3" onclick="curTab(3)"><a href="javascript:;">待完成单</a></li>
                <li class="ca-flex cur4" onclick="curTab(4)"><a href="javascript:;">失败单</a></li>
           </ul>
     </div>
      <div class="ca-fx-order fx-ord1">
            <ul id="ul_list1">
            </ul>
      </div>
      <div class="ca-fx-order fx-ord2">
            <ul id="ul_list2">
            </ul>
      </div>
       <div class="ca-fx-order fx-ord3">
            <ul id="ul_list3">
            </ul>
      </div>
       <div class="ca-fx-order fx-ord4">
            <ul id="ul_list4">
            </ul>
      </div>
     <div class="uc__loading-tips">
        没有更多了...
     </div>

     
	<script type="text/javascript">
	    //切换效果
	    var v = 1;
	    function curTab(value) {
	        v = value;
	        for (i = 1; i <= 4; i++) {
	            if (i == value) {
	                InitList();
	                $('.cur' + value).addClass('curTab')
	                $('.fx-ord' + value).css('display', 'block');
	            } else {
	                $('.cur' + i).removeClass('curTab')
	                $('.fx-ord' + i).css('display', 'none');
	            }
	            
	        }
	    }
			

	    $(function () {

	        //选项卡
	        var tabIndex;
	        $(".tab-nav").children("li").on("click", function () {
	            $(this).addClass("cur").siblings("li").removeClass("cur");
	            tabIndex = $(this).index();
	            $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
	        })
	    })
	</script>
    <script src="http://js.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>
	<script type="text/javascript">
	    InitList();
	    function InitList() {
	        $('#ul_list' + v).html('');
	        //获取分页
	        var mid = '<%=HotelCloud.Common.HCRequest.GetString("mid") %>'
	        var page = 0;
	        var key = '<%=ViewData["key"] %>';
	        var url = '/MemberFx/GetFxOrders/';
	        var isEnd = false;

	        function getlist() {
	            loadstate(true);
	            if (!isEnd) {
	                if (key != '') {
	                    $.ajax({ url: url,
	                        async: true,
	                        data: { v: v, page: page, key: key, mid: mid },
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
	            //console.log(json);
	            var html = '';
	            var ar = eval('(' + json + ')');
	            var status = '';
	            $.each(ar, function (i, t) {
	                html += '<li class="ca-displayfx"><div class="t-hotel-pht"><img src="' + t.hotelLog + '"></div><div class="ca-flex ca-source-money"><ul><li><h1>' + t.name + '</h1></li><li>金额：￥' + t.payamount + '</li><li>佣金：￥' + t.fxmoney + '</li><li>来源：链接分享</li></ul></div><dl class="ca-time-success-ord"><dt>' + t.createtime + '</dt><dd>' + t.statusname + '</dd></dl></li>';
	            });
	            $('#ul_list'+v).append(html);
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

	    }


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
