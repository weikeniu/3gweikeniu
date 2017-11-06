<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    ViewDataDictionary jdata = new ViewDataDictionary();
    jdata.Add("weixinID", ViewData["weixinID"]);
    jdata.Add("hId", ViewData["hId"]);
    jdata.Add("uwx", ViewData["userWeiXinID"]);


    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();
%>
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
    <title>我的订单</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/order-list.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css?v=1.2" />
    <script src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <style>
        html
        {
            overflow: yes;
        }
    </style>
</head>
<body>
    <section class="loading-page" style="position: fixed;">
			<div class="inner">
				<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
				<img src="http://css.weikeniu.com/images/loading-n.png" />
			</div>
		</section>
    <header class="yu-bor bbor">
 	<a href="javascript:history.back(-1);" class="back"><div class="new-l-arr"></div></a>
 	我的订单
 </header>
    <%--<section class="yu-grid o-tab yu-bor bbor">
 	<div class="yu-overflow cur" state="0">全部</div>
	 <div class="yu-overflow" state="1">有效单</div>
	 <div class="yu-overflow new" state="2">待支付</div>
 	 <%--<div class="yu-overflow" state="3">退款单</div>
</section>--%>
    <div class="order-tab-box">
        <div class="order-tab cur" id="orders_list">
        </div>
    </div>
    <%
        

        ViewDataDictionary viewDic = new ViewDataDictionary();
        viewDic.Add("weixinID", ViewData["weixinID"]);
        viewDic.Add("hId", ViewData["hId"]);
        viewDic.Add("uwx", ViewData["userWeiXinID"]);
        int tid = HotelCloud.Common.HCRequest.getInt("tid");
        if (tid <= 0)
        {
            Html.RenderPartial("Footer", viewDic);
        }
        else {
            hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = new hotel3g.PromoterEntitys.WeiXinShareConfig()
            {
                title = null,
                desn = null,
                logo = null,
                debug = false,
                userweixinid = ViewData["userWeiXinID"].ToString(),
                weixinid = ViewData["weixinID"].ToString(),
                hotelid = int.Parse(ViewData["hId"].ToString()),
                sharelink = ""
            };

            viewDic.Add("WeiXinShareConfig", WeiXinShareConfig);
            Html.RenderPartial("WeiXinShare", viewDic); 
        }
    %>
    <script src="http://js.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
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
            var url = '/User/GetOrderListData';
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
                                    isEnd = true;
                                    $("#nomore").remove();
                                    $("#orders_list").append('<p style="text-align:center;color:#aaa;padding:10px 0px 10px 0px;" id="nomore">没有更多了...</p>');
                                } else {
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
                        //拼装列表
                        html += '<dl class="link" id="' + item.Id + '" isMeeting="' + item.isMeeting + '" orderno="' + item.OrderNo + '" channel="' + item.channel + '" sid="' + item.storeID + '">';
                        html += '<dt class="yu-grid yu-bor bbor">';
                        html += '<div class="ico-part">';
                        html += '<div class="ico-bg type1">';
                        html += '<span class="o-ico type1"></span>';
                        html += '</div></div>';

                        var channel = "";
                        switch (item.channel) {
                            case 0:
                                if (item.isMeeting == 9) {

                                    channel = "餐厅订位";
                                } else {
                                    channel = "酒店订单";
                                }

                                break;
                            case 1: channel = "团购预售"; break;
                            case 2: channel = "酒店餐饮"; break;
                            case 3: channel = "超市订单"; break;
                        }

                        html += '<p class="yu-overflow yu-lred">' + channel + '</p>';
                        html += '<p class="yu-blue yu-font12">' + item.stateCh + '</dt>';
                        html += '<dd class="yu-bor bbor">';
                        html += '<div class="yu-grid yu-bmarPayType10">';

                        var price = item.sSumPrice;
                        if (item.channel == 0 && item.PayType == 1 && item.fpsubmitprice > 0) {
                            price = item.fpsubmitprice;
                        }


                        if (item.isMeeting != 9) {
                            html += '<p class="yu-overflow">' + item.HotelName + '</p><p>￥' + price + '</p></div>';
                        } else {
                            html += '<p class="yu-overflow">' + item.HotelName + '</p><p>--</p></div>';
                        }
                        html += '<div class="yu-grey yu-font12">';

                        if (item.ishourroom != "1") {
                            //                            html += '<p>' + item.yinDate + '至' + item.youtDate + '</p>';
                        }
                        if (item.channel == 2 || item.channel == 3) {
                            html += '<p>' + item.RoomName + '</p>';
                        } else {
                            html += '<p>' + item.RoomName + '(' + (item.PayType == 1 ? "现付" : "预付") + ')</p>';
                        }
                        if (item.ishourroom == "1") {
                            //html += '<p>' + item.yinDate + ' ' + item.hourstarttime + '~' + item.youtDate + ' ' + item.hourendtime + '</p>';
                            html += '<p>' + item.yinDate + ' ' + item.hourstarttime + '~' + item.hourendtime + '</p>';
                        } else {
                            if (item.channel == 0 && item.isMeeting == 9) {
                                html += '<p> </p>';
                            } else {
                                html += '<p>' + (item.channel == 0 ? item.yRoomNum + '间' + item.days + '晚' : '') + '</p>';
                            }
                        }
                        html += ' </div></dd> </dl></dl>';
                    }
                    $("#orders_list").append(html);
                    $(".link").bind("click", function () {
                        var id = $(this).attr("id");
                        var orderno = $(this).attr("orderno");

                        var isMeeting = $(this).attr("isMeeting");

                        var channel = $(this).attr("channel");
                        if (channel == "0") {

                            var url = '/User/OrderInfo/<%=ViewData["hId"] %>?id=' + id + '&key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>';
                            if (isMeeting == '9') {
                                url = '/dishorder/diningroomdetail/<%=ViewData["hId"] %>?ordercode=' + orderno + '&key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>';
                            }
                            window.location.href = url;
                        } else if (channel == "1") {

                            var url = '/Product/ProductUserOrderDetail/<%=ViewData["hId"] %>?OrderNo=' + orderno + '&key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>';
                            window.location.href = url;
                        } else if (channel == "2") {
                            var sid = $(this).attr("sid");
                            var url = '/DishOrder/ViewOrderDetail/<%=ViewData["hId"] %>?storeId=' + sid + '&key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>&orderCode=' + orderno + "&tid=<%=tid %>";
                            window.location.href = url;
                        } else if (channel == "3") {
                            var sid = $(this).attr("sid");
                            //  var url = '/Supermarket/OrderPay/<%=ViewData["hId"] %>?storeId=' + sid + '&key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>&orderid=' + orderno;

                            var url = '/Supermarket/OrderDetails2/<%=ViewData["hId"] %>?storeId=' + sid + '&key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>&orderid=' + orderno;

                            window.location.href = url;
                        }


                    })
                }
            }
            getorderlist();
            var windowHeight = $(window).height();

            $(window).scroll(function () {
                scrollTop = $(this).scrollTop();
                scrollHeight = $(document).height();
                windowHeight = $(this).height();
                if (scrollTop + windowHeight == scrollHeight) {
                    getorderlist();
                }
            });



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
