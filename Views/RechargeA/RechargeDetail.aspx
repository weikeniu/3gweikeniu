<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    List<WeiXin.Models.Home.RechargeUser> list = ViewData["list"] as List<WeiXin.Models.Home.RechargeUser>;
    int page = Convert.ToInt32(ViewData["page"]);
    int pagesize = Convert.ToInt32(ViewData["pagesize"]);
    int count = Convert.ToInt32(ViewData["count"]);
    int pagenum = count % pagesize == 0 ? count / pagesize : count / pagesize + 1;

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
    <meta charset="UTF-8" />
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
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css?v=1.0" />
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />
    <script src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
    <link href="<%=ViewData["jsUrl"] %>/Scripts/mescroll-master/mescroll.min.css" rel="stylesheet"
        type="text/css" />
    <script src="<%=ViewData["jsUrl"] %>/Scripts/mescroll-master/mescroll.min.js" type="text/javascript"></script>
    <style>
        .content2
        {
            overflow: hidden !important;
        }
    </style>
</head>
<body>
    <article class="full-page">

            <%Html.RenderPartial("HeaderA", viewDic); %>
           <section class="show-body">		           	
			<section class="content2">

            	<div class="pg__ucenter">
				 
					<div class="ca-ivdetail-top">
                        <a class="ca-return-icon fl" href="javascript:history.go(-1)"></a>
                        <div class="hd-mx fr"><i class="ico-hdmx i1"></i>储值卡明细 </div>
					</div>
					<div class="uc__storeValCard-details mescroll"  id="mescroll">
                    <%if (list.Count == 0)
                      { %>
                    	<div class="no-data">
							<img src="../../images/icon__no-recharge.png" />
							<h2>还没有储值卡明细</h2>
							<p>过段时间再来瞧瞧吧</p>
							<a class="back"  href="javascript:history.go(-1)">返回</a>
						</div>
                        <%} %>
					 
						<ul class="clearfix"  id="data_content" >
                          <% foreach (var item in list)
                             { %>
							<li>
								<div class="fl">
									<div class="text fl">
										<h2 class="clamp1"><%=item.PayType == 0 ? "现金支付" : "在线支付"%></h2><label>余额：<%=item.Balance %></label>
									</div>
								</div>
								<div class="fr">
									<div class="text text2 align-r fl">
										<h2 class="clamp1 <%= item.MPrice >0 ? "red" : "" %>"> <%= item.MPrice >0 ? "+" : "" %><%= (item.MPrice)%>  </h2><label class="db"><%=item.AddTime.ToString("yyyy-MM-dd HH:mm:ss") %></label>
									</div>
								</div>
							</li>

                            <%} %>						 
						</ul>	
                      				 
				 </div>                 	 
	</div>
</section>
</section>
</article>
    <input type="hidden" id="cur_page" value="<%=page%>" />
    <input type="hidden" id="cur_sumpage" value="<%=pagenum%>" />
    <section class="loading-page" style="position: fixed; display: none">
			<div class="inner">
				<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
				<img src="http://css.weikeniu.com/images/loading-n.png" />
			</div>
		</section>
</body>
<script>

            var isEnd = false;

			//创建MeScroll对象
			var mescroll = new MeScroll("mescroll", {
				down: {
                    use:false,  
					auto: false, //是否在初始化完毕之后自动执行下拉回调callback; 默认true
					callback: downCallback //下拉刷新的回调
				},
				up: {
					auto: false, //是否在初始化时以上拉加载的方式自动加载第一页数据; 默认false
					callback: upCallback, //上拉回调,此处可简写; 相当于 callback: function (page) { upCallback(page); }
					toTop:{ //配置回到顶部按钮
						src : "/images/mescroll-totop.png", //默认滚动到1000px显示,可配置offset修改
						//offset : 1000
					},
                    htmlNodata:"",
                    htmlLoading:""
				}
      		}); 
    		
			/*下拉刷新的回调 */
			function downCallback(){            
              	mescroll.endSuccess();
			}		
		 
			function upCallback(page){ 
                 getMoreData();                
    	}
 


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


      //  layer.load();
        $(".loading-page").show();

 

        tmp.select = "";
        tmp.query = "";

        $.ajax({
            data: tmp,
            type: 'post',
            url: '/RechargeA/FetchRechargeOrder',
            dataType: 'json'
        }).done(function (data) {
            if (data) {
                var html = '';
                if (data.data) {
                    data.data = $.parseJSON(data.data);
                    for (var i = 0; i < data.data.length; i++) {

                        html += '<li>' +
							'<div class="fl">' +
									'<div class="text fl">' +
										'<h2 class="clamp1">' + (data.data[i].PayType == "0" ? "现金支付" : "在线支付") + '</h2><label>余额：' + data.data[i].Balance + '</label>' +
                                         '</div>' +
								'</div>' +
								'<div class="fr">' +
									'<div class="text text2 align-r fl">' +
										'<h2 class="clamp1">' + (parseFloat(data.data[i].MPrice) >0 ?  "+" : "") + '' + parseFloat(data.data[i].MPrice).toFixed(2) + '</h2><label class="db">' + data.data[i].AddTime + '</label>' +
									'</div>' +
								'</div>' +
							'</li>';
                    }

                    $('#cur_page').val(data.page);
                    $('#cur_sumpage').val(data.pagesum);

                    if (data.count == 0 || data.page >= data.pagesum) {                      
                         isEnd = true;
                    }
                }

                $('#data_content').append(html);

                if (isEnd) {
                       mescroll.endSuccess(0, false); 
                     $("#data_content").after('<p style="text-align:center;color:#aaa;padding:10px 0px 10px 0px;" id="nomore">没有更多了...</p>');
                   
                }

                else
                {
                 mescroll.endSuccess(10, true); 

                }
                $(".loading-page").hide();
              //  layer.closeAll();
            }

        });
    }

//    $(".uc__storeValCard-details").scroll(function () {
//        var scrollTop = $(this).scrollTop();
//        var scrollHeight = $(".uc__storeValCard-details").get(0).scrollHeight;
//        var windowHeight = $(this).height();
//         var headerHeight = $("header").height();       
//       
//        if (scrollTop + windowHeight + headerHeight + 1 >= scrollHeight) {
//            getMoreData();
//        }
//    });

</script>
</html>
