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
<head>
    <meta charset="UTF-8" />
    <title>我的订单</title>
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/new-style.css" />
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/mend-reset.css" />
    <script src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script src="http://css.weikeniu.com/Scripts/fontSize.js"></script>

       <link href="<%=ViewData["jsUrl"] %>/Scripts/mescroll-master/mescroll.min.css" rel="stylesheet"
        type="text/css" />
    <script src="<%=ViewData["jsUrl"] %>/Scripts/mescroll-master/mescroll.min.js" type="text/javascript"></script>
</head>
<body>

    <section class="loading-page" style="position: fixed;">
			<div class="inner">
				<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
				<img src="http://css.weikeniu.com/images/loading-n.png" />
			</div>
		</section>
    <!-- <>主体页面 -->
    <article class="full-page">
     <%
         int tid = HotelCloud.Common.HCRequest.getInt("tid");
         if (tid <= 0)
         {
             Html.RenderPartial("HeaderA", viewDic);
         }
         else {
             hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = new hotel3g.PromoterEntitys.WeiXinShareConfig()
             {
                 title = null,
                 desn = null,
                 logo = null,
                 debug = false,
                 userweixinid = userWeiXinID,
                 weixinid = weixinID,
                 hotelid = int.Parse(hotelid),
                 sharelink = ""
             };

             viewDic.Add("WeiXinShareConfig", WeiXinShareConfig);
             Html.RenderPartial("WeiXinShare", viewDic); 
         } %>
         <section class="show-body">	 
			<section class="content2 mescroll"  id="mescroll" >
            <div class="pg__ucenter">
					<!--//我的订单列表-->
					<div class="uc__userOrder-list" >
						<ul class="clearfix" id="orders_list">
						 
						</ul>
						
						<div class="uc__loading-tips" style="display:none">
							没有更多了...
						</div>
					</div>
				</div>

    </section> 
</section>
    </article>
    <script src="http://js.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {


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
                  getorderlist();         
    	      }
 


            var tabNum;
            $(".o-tab").children("div").on("click", function () {
                $(this).addClass("cur").siblings().removeClass("cur");
                tabNum = $(this).index();
                $(".order-tab").eq(tabNum).addClass("cur").siblings().removeClass("cur");
            });
            //获取分页
            var page = 0;
            var weixinid = '<%=ViewData["weixinID"] %>';
            var userweixinid = '<%=ViewData["userWeiXinID"]%>';
            var state = 0; //0全部  1有效  2 待支付  3退款
            var url = '/UserA/GetOrderListData';
            var isEnd = false;

            $(".yu-overflow").click(function () {
                state = parseInt($(this).attr("state"));
                page = 0;
                isEnd = false;
                $("#orders_list").empty();
                getorderlist();
            });

            //获取分页
            function getorderlist() {
                loadstate(true);
                if (!isEnd) {

                    if (weixinid != '' && userweixinid != '') {
                        var prem = { weixinid: weixinid, userweixinid: userweixinid, page: page, state: state };

                        $.ajax({ url: url,
                            async: true,
                            data: prem,
                            type: "post",
                            success: function (data) {
                                //获取成功
                                if (data.isEnd == 1) {
                                  
                                    mescroll.endSuccess(0, false); 
                                    isEnd = true;
                                    $("#nomore").remove();
                                    $("#orders_list").append('<p style="text-align:center;color:#aaa;padding:10px 0px 10px 0px;" id="nomore">没有更多了...</p>');
                                } else {
                                    mescroll.endSuccess(10, true); 
                                    page = data.nextpage;
                                }
                                packList(data.list);
                                layer.closeAll();
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


                        //                        $.post(url, prem, function (data, status) {
                        //                            if (data.isEnd == 1) {
                        //                                isEnd = true;
                        //                                $("#orders_list").append('<p style="text-align:center;color:#aaa;padding:10px 0px 10px 0px;" id="nomore">没有更多了...</p>');
                        //                            } else {
                        //                                page = data.nextpage;
                        //                            }
                        //                            packList(data.list);
                        //                            layer.closeAll();
                        //                        });
                    }
                } else {
                    loadstate(false);
                }
            }

            //解析数据
            function packList(json) {
                var obj = eval(json);
                if (obj != null && obj.length > 0) {
                    var html = "";
                    for (var i = 0; i < obj.length; i++) {
                        var item = obj[i];

                        var channel = "";
                        var icoClass = "i1";
                        switch (item.channel) {
                            case 0: channel = "酒店-预定"; icoClass = "i3"; break;
                            case 1: channel = "酒店-抢购"; icoClass = "i4"; break;
                            case 2: channel = "酒店-餐饮"; icoClass = "i2"; break;
                            case 3: channel = "酒店-超市"; icoClass = "i1"; break;
                        }



                        var price = item.sSumPrice;
                        if (item.channel == 0 && item.PayType == 1 && item.fpsubmitprice > 0) {
                            price = item.fpsubmitprice;
                        }

                        price = "￥" + price;

                        if (item.isMeeting == 1) {
                            channel = "会议-宴会";
                            icoClass = "i5";

                            if (item.PayType == 1) {
                                price = "";
                            }
                        }
                        else if (item.isMeeting == 9) {

                            icoClass = "i2";
                            channel = "酒店-餐厅";
                            price = "";
                        }

                        if (price == "") {
                            item.stateCh = item.stateCh.replace("待支付", "待跟进").replace("待确认", "待跟进").replace("预订成功", "跟进中").replace("已离店", "跟进完成");
                        }


                        item.stateCh = item.stateCh.replace("已离店", "交易成功");


                        html += '<li class="link" id="' + item.Id + '" orderno="' + item.OrderNo + '" channel="' + item.channel + '" sid="' + item.storeID + '" >';
                        html += '<div class="head clearfix">';
                        html += '<h2 class="fl">';
                        html += '<span class="ico"><i class="' + icoClass + '"></i></span> ';
                        html += '<span class="txt">' + channel + '</span>';
                        html += '</h2>';
                        html += '<label class="status fr">' + item.stateCh + '</label>';
                        html += ' </div> ';
                        html += '<div class="cont">';
                        html += '<div class="ginfo clearfix">';
                        html += '<p class="tit"><a class="fl" href="#">' + item.HotelName + '<i class="arr"></i></a> <label class="price fr">' + price + '</label></p>';
                        html += '<p class="num">';

                        if (item.channel == 1 || item.channel == 2 || item.channel == 3) {
                            html += '<span class="fl">' + item.RoomName + '</span> ';
                            html += '<i class="fr">x' + item.yRoomNum + '</i>';
                            html += "</p>";
                        }

                        else {
                            if (item.isMeeting == 1) {

                                html += '<span class="fl">' + item.RoomName + '</span> ';
                                html += '  <i class="fr">' + item.lastTime + '</i>';
                            }
                            else if (item.isMeeting == 9) {

                                html += '<span class="fl">' + item.RoomName + '</span> ';
                                html += '  <i class="fr">' + item.lastTime + '</i>';
                            }


                            else {

                                html += '<span class="fl">' + item.RoomName + '(' + (item.PayType == 1 ? "现付" : "预付") + ')</span> ';
                                if (item.ishourroom == "1") {

                                    html += '<i class="fr">' + item.yinDate + ' ' + item.hourstarttime + '~' + item.hourendtime + '</i>';
                                }

                                else {

                                    html += '  <i class="fr">' + (item.channel == 0 ? item.yRoomNum + '间' + item.days + '晚' : '') + '</i>';
                                }


                            }

                            html += ' </p>';
                        }

                        html += '<p class="time">' + item.Ordertime + '</p>';
                        html += '</div>';

                        if (price != "") {
                            html += '<div class="total">';
                            html += '总价格：<i>' + price + '</i>';
                            html += '</div>';
                        }

                        html += '	<div class="express" style="display:none">';
                        html += '<a href="#">圆通快递<i class="arr"></i></a>';
                        html += '</div>';
                        html += '</div>';
                        //                        html += '<div class="foot">';
                        //                        html += '<div class="btns">';
                        //                        html += '	<a class="btn_def" href="#">联系商家</a>';
                        //                        html += '	<a class="btn_def" href="#">积分兑换</a> ';
                        //                        html += '	<a class="btn_def active" href="#">确定收货</a>'
                        //                        html += '</div>'
                        //                        html += '</div>';
                        html += '</li>';
                    }
                    $("#orders_list").append(html);
                    $(".link").bind("click", function () {
                        var id = $(this).attr("id");
                        var orderno = $(this).attr("orderno");

                        var channel = $(this).attr("channel");
                        if (channel == "0") {
                            var url = '/Usera/OrderInfo/<%=ViewData["hId"] %>?id=' + id + '&key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>';
                            window.location.href = url;
                        } else if (channel == "1") {

                            var url = '/Producta/ProductUserOrderDetail/<%=ViewData["hId"] %>?OrderNo=' + orderno + '&key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>';
                            window.location.href = url;
                        } else if (channel == "2") {
                            var sid = $(this).attr("sid");
                            var url = '/DishOrdera/ViewOrderDetail/<%=ViewData["hId"] %>?storeId=' + sid + '&key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>&orderCode=' + orderno + "&tid=<%=tid %>";
                            window.location.href = url;
                        } else if (channel == "3") {
                            var sid = $(this).attr("sid");
                            //  var url = '/Supermarket/OrderPay/<%=ViewData["hId"] %>?storeId=' + sid + '&key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>&orderid=' + orderno; 
                            var url = '/SupermarketA/OrderDetails2/<%=ViewData["hId"] %>?storeId=' + sid + '&key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>&orderid=' + orderno;

                            window.location.href = url;
                        }


                    })
                }
            }
            getorderlist();
            var windowHeight = $(window).height();

            //            $(window).scroll(function () {
            //                scrollTop = $(this).scrollTop();
            //                scrollHeight = $(document).height();
            //                windowHeight = $(this).height();
            //                if (scrollTop + windowHeight == scrollHeight) {
            //                    getorderlist();
            //                }
            //            });



//            $(".content2").scroll(function () {
//                var scrollTop = $(this).scrollTop();
//                var scrollHeight = $(".content2").get(0).scrollHeight;
//                var windowHeight = $(this).height();
//                var headerHeight = $("header").height();
//                
//                if (scrollTop + windowHeight + headerHeight+1 >= scrollHeight) {
//                    getorderlist();
//                }
//            });



            if (windowHeight >= 596) {
                page++;
                getorderlist();
            }


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

        });
    </script>
</body>
</html>
