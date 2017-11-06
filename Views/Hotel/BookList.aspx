<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    string hid = ViewData["hid"].ToString();
    string hotelWeixinid = string.Empty;
    string key = HotelCloud.Common.HCRequest.GetString("key");
    if (ViewData["hotelWeixinid"] != null)
    {
        hotelWeixinid = ViewData["hotelWeixinid"].ToString();
    }
    string userWeixinid = string.Empty;
    if (ViewData["userWeixinid"] != null)
    {
        userWeixinid = ViewData["userWeixinid"].ToString();
    }
    string generatesign = ViewData["generatesign"].ToString();

    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", hotelWeixinid);
    viewDic.Add("hId", hid);
    viewDic.Add("uwx", userWeixinid);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
    <title>酒店订房</title>
    <link href="http://css.weikeniu.com/swiper/swiper-3.4.1.min.css?v=1.0" rel="stylesheet"
        type="text/css" />
    <link href="http://css.weikeniu.com/css/booklist/jquery-ui.css?v=1.0" rel="stylesheet"
        type="text/css" />
    <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=1.0" rel="stylesheet"
        type="text/css" />
    <link href="../../css/booklist/iconfont/iconfont.css?v=1.0" rel="stylesheet" type="text/css" />
    <link href="http://css.weikeniu.com/css/booklist/list.css?v=1.0" rel="stylesheet"
        type="text/css" />
    <link href="http://css.weikeniu.com/css/booklist/newlist.css?v=1.0" rel="stylesheet"
        type="text/css" />
    <link href="http://css.weikeniu.com/css/newpay.css" rel="stylesheet" type="text/css" />
    <link href="../../css/msgbox_ui.css?v=1.0" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .originalprice, .discount
        {
            display: none;
        }
        
        .copy
        {
            display: none;
        }
        
        #hourroomlist, #roomlist, #groupsale, #groupsalelist
        {
            display: none;
        }
        
        #groupsalelist .yu-overflow .babel.type1, #groupsalelist .yu-overflow .babel.type2, #groupsalelist .yu-overflow .babel.type3
        {
            display: none;
        }
    </style>
    <script src="http://js.weikeniu.com/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
</head>
<body>
    <form method="post" action="/hotel/fillorder/<%=hid %>?key=<%=key %>" id="orderform"
    style="display: none">
    <input type="hidden" name="orderjson" />
    <input type="submit" id="submitorder" />
    </form>
    <div class="base-page">
        <div id="main">
            <div class="hotel-img-box swiper-container swiper-container-horizontal">
                <p class="hotel-name" id="hotelname">
                </p>
                <p class="hotel-img-num">
                    <span class="activeIndex"></span>/<label class="totalindex">0</label></p>
                <div class="swiper-wrapper">
                </div>
                <div class="mask-bg img-info yu-grid" id="takecoupon" style="display: none">
                    <p class="yu-overflow yu-font14">
                        您有酒店红包未领取！【用红包立减】</p>
                    <p class="yu-tpad5">
                        <%--../../Home/CouPon--%>
                        <a href="javascript:;" class="get-quan yu-font14">马上领取</a></p>
                </div>
            </div>
            <ul class="hotel-info">
                <li class="yu-arr" id="tomap"><a href="javascript:;" class="yu-grid">
                    <div class="hotel-add text-ell yu-grey yu-overflow" id="address">
                    </div>
                    <p class="yu-blue yu-font14">
                        地图</p>
                </a></li>
                <li class="yu-arr" id="calltel"><a href="javascript:;" class="yu-grid">
                    <div class="hotel-add text-ell yu-grey yu-overflow">
                        电话：<label id="hoteltel"></label>
                    </div>
                    <p class="yu-blue yu-font14">
                        拨打</p>
                </a></li>
                <li class="yu-arr"><a href="/Hotel/HotelService/<%=hid %>?key=<%=key %>" class="yu-grid">
                    <div class="hotel-add text-ell yu-blue yu-overflow" id="hotelserve">
                        <i class="iconfont yu-grey stopping">&#xe603;</i><%--停车场--%>
                        <i class="iconfont yu-grey wifi">&#xe601;</i><%--wifi--%>
                        <i class="iconfont yu-grey catering">&#xe60a;</i><%--餐饮--%>
                        <i class="iconfont yu-grey luggage">&#xe618;</i><%--行李托管--%>
                        <i class="iconfont yu-grey gymnasium">&#xe61a;</i><%--健身房--%>
                    </div>
                    <p class="yu-blue yu-font14">
                        详情</p>
                </a></li>
            </ul>
            <div class="rooms-list-box">
                <ul class="rooms-date-change">
                    <li><span class="yu-font20 start-date yu-greys" id="indate" datetype="indate"></span>
                        <span class="yu-font12 yu-grey" datetype="indate"><span id="indatestr"></span>入住</span>
                        <span class="border1"></span><span class="yu-font20 end-date yu-greys" id="outdate"
                            datetype="outdate"></span><span class="yu-font12 yu-grey">&nbsp;<span id="outdatestr"
                                datetype="outdate"></span>离店 </span><span class="yu-font12 fr yu-rmar20 yu-blue"
                                    datetype="indate">共<label id="days"></label>晚</span> </li>
                </ul>
            </div>
            <%--钟点房--%>
            <ul class="rooms-list sp2" id="hourroomlist">
                <li>
                    <div class="room-content-head yu-grid">
                        <div class="yu-overflow">
                            <div class="room-name text-ell yu-line30">
                                <i class="iconfont yu-blue yu-font20">&#xe609;</i>钟点房</div>
                        </div>
                        <div class="price-wrap yu-orange">
                            <span class="yu-font12">￥</span>&nbsp;<span class="yu-font20 lowestprice">0</span>&nbsp;<span
                                class="yu-font12">&nbsp;起</span>
                        </div>
                    </div>
                    <ul class="room-content">
                        <li class="yu-grid copy">
                            <div class="yu-overflow yu-greys">
                                <div class="room-name">
                                </div>
                                <div>
                                    (<label class="roomhour">0</label>小时钟点房)</div>
                            </div>
                            <div class="room-price-wrap">
                                <p class="yu-line50">
                                    <i class="yu-font12">￥</i> <i class="yu-font20 price">0</i>
                                </p>
                                <p class="yu-font12 yu-grey originalprice">
                                    ￥<label>0</label></p>
                                <p class="yu-font12 yu-grey discount">
                                    酒店红包￥<label>0</label></p>
                            </div>
                            <div class="order-btn">
                            </div>
                        </li>
                    </ul>
                </li>
            </ul>
            <%--房型列表--%>
            <ul class="rooms-list sp2 yu-tbor1" id="roomlist">
                <li>
                    <div class="load-container load3">
                        <%--<div class="loader">
                            Loading...</div>--%>
                    </div>
                </li>
                <li class="copy">
                    <div class="room-content-head yu-grid">
                        <div class="room-pic">
                            <img src="" alt="" class="roomimg" />
                            <span class="room-pic-num yu-font12"><span>0</span>张</span>
                        </div>
                        <div class="yu-overflow">
                            <div class="room-name text-ell">
                            </div>
                            <div class="text-ell">
                                <span class="yu-font12 yu-greys roominfo">15㎡ 双床1.2m 无窗 有wifi</span></div>
                        </div>
                        <div class="price-wrap">
                            <span class="yu-font12">￥</span> <span class="yu-font20 lowestprice">0</span> <span
                                class="yu-font12">起</span>
                        </div>
                    </div>
                    <ul class="room-content">
                        <li class="yu-grid rateplanitem">
                            <div class="yu-overflow">
                                <div class="room-name text-ell yu-greys rateplanname">
                                </div>
                            </div>
                            <div class="room-price-wrap">
                                <p class="yu-line60">
                                    <i class="yu-font12">￥</i> <i class="yu-font20 price">0</i>
                                </p>
                                <p class="yu-font12 yu-grey originalprice">
                                    ￥<label>0</label></p>
                                <p class="yu-font12 yu-grey discount">
                                    酒店红包￥<label>0</label></p>
                            </div>
                            <div class="order-btn">
                            </div>
                        </li>
                    </ul>
                </li>
            </ul>
            <%--团购特惠--%>
            <%Html.RenderPartial("ProductSale", viewDic); %>
            <%--<ul class="rooms-list sp" id="groupsale">
                <li>
                    <div class="room-content-head yu-grid noarr">
                        <div class="yu-overflow">
                            <div class="room-name text-ell yu-line30">
                                <span class="tuan-ico"></span>团购特惠</div>
                        </div>
                    </div>
                </li>
            </ul>
            <ul class="rooms-list sp2 yu-nobg" id="groupsalelist">
                <%--  <li class="copy">
                    <div class="room-content-head yu-grid tgth">
                        <div class="room-pic">
                            <img src="" alt="" />
                        </div>
                        <div class="yu-overflow">
                            <div class="room-name text-ell">
                            </div>
                            <div class="text-ell">
                            </div>
                            <div>
                                <span class="babel type1">立即确认</span><span class="babel type2">预售</span><span class="babel type3">团购</span></div>
                        </div>
                        <div class="price-wrap yu-orange">
                            <span class="yu-font12">￥</span> <span class="yu-font20 price">0</span>
                        </div>
                    </div>
                </li></ul>--%>
        </div>
    </div>
    <div class="copy">
        <%--团购列表--%>
        <ul class="groupsalelistcopy">
            <li>
                <div class="room-content-head yu-grid tgth">
                    <div class="room-pic">
                        <img src="" alt="" />
                    </div>
                    <div class="yu-overflow">
                        <div class="room-name text-ell">
                        </div>
                        <div class="text-ell">
                        </div>
                        <div>
                            <span class="babel type1">立即确认</span><span class="babel type2">预售</span><span class="babel type3">团购</span></div>
                    </div>
                    <div class="price-wrap yu-orange">
                        <span class="yu-font12">￥</span> <span class="yu-font20 price">0</span>
                    </div>
                </div>
            </li>
        </ul>
    </div>
    <div class="date-page">
        <div class="back">
        </div>
        <div class="top">
            选择日期
        </div>
        <div id="datepicker">
        </div>
    </div>
    <section class="mask hyk-mask">
    <div class="get-card">
        <div class="part1">
            <span class="close"></span>
        </div>
        <div class="part2">
            <h3 class="gift" style="display:none">
                领取会员红包，更多特权更多优惠!</h3>
            <h3 class="gift" style="display:none">
                <label class="hongbao">0</label>元红包【预订立减】</h3>
            <div class="mem-right">
                <h4>
                    会员权益</h4>
                <!-- <h5>会员卡优惠与积分说明</h5> -->
                <table>
                    <tr>
                        <td>
                            特权内容
                        </td>
                        <td>
                            订房优惠
                        </td>
                        <td>
                            积分加成
                        </td>
                    </tr>
                    <tr class="copy">
                        <td>
                        <label class="membername"></label>
                        </td>
                        <td>
                            <label class="viprate"></label>折
                        </td>
                        <td>
                            <label class="vipplus"></label>倍
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="part3">
            <a href="/MemberCard/MemberRegister/<%=hid %>?key=<%=key %>" class="get-btn"></a>
        </div>
    </div>
    </section>
    <!-- 领取红包 -->
    <div class="mask lqhb">
        <div class="mask-inner">
            <div class="row yu-line60 yu-h60 yu-font20 yu-grid yu-bmar10">
                <p class="yu-overflow">
                    酒店红包</p>
            </div>
            <div class="yhq-box select-box" id="SurplusCouponlist">
                <div class="row copy">
                    <div class="hongbao type2 yu-grid">
                        <div class="yu-overflow yu-textl">
                            <p class="yu-bmar10">
                                <i class="yu-font14">￥</i><i class="yu-font30 price">0</i></p>
                            <p class="yu-font14">
                                订房红包</p>
                            <p class="yu-font14">
                                有效期<span class="stime"></span>-<span class="etime"></span></p>
                        </div>
                        <p class="hongbao-state">
                            <span class="type1">立即领取</span><span class="type2">已领取</span></p>
                    </div>
                </div>
            </div>
            <div class="get-btn2">
                完成</div>
        </div>
    </div>
    <div class="mask big-pic">
        <div class="inner">
            <div class="close">
            </div>
            <h3>
                <label class="roomname">
                </label>
            </h3>
            <div class="big-img-box swiper-container2">
                <div class="swiper-wrapper">
                    <%--<div class="swiper-slide">
                        <img src="../images/114.png" /></div>--%>
                </div>
            </div>
            <div class="big-img-detail">
                <table>
                    <tr>
                        <td>
                            早餐：<label class="breakfast"></label>
                        </td>
                        <td>
                            面积：<label class="area"></label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            宽带：<label class="nettype"></label>
                        </td>
                        <td>
                            楼层：<label class="floor"></label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            床型：<label class="bedtype"></label>
                        </td>
                        <td>
                            加床：<label class="addbed"></label>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="yu-grid">
                <p class="yu-overflow yu-line50 yu-lpad10 yu-h50 yu-orange">
                    <i class="yu-font14">￥</i> <i class="yu-font24 price">0</i>
                </p>
                <p class="book-btn">
                    预订</p>
            </div>
        </div>
    </div>
    <%Html.RenderPartial("NewFooter", viewDic); %>
</body>
</html>
<script type="text/javascript">
    var sys_hid = '<%=hid %>';
    var sys_userWeixinid = '<%=userWeixinid %>';
    var sys_hotelWeixinid = '<%=hotelWeixinid %>';
    var sys_tokenkey = '';
    var sys_token = '';
    var sys_generatesign = '<%=generatesign %>';
</script>
<script src="http://js.weikeniu.com/swiper/swiper-3.4.1.jquery.min.js" type="text/javascript"></script>
<script src="http://js.weikeniu.com/css/booklist/jquery-ui.min.js" type="text/javascript"></script>
<script src="http://js.weikeniu.com/Scripts/m.hotel.com.core.min.js" type="text/javascript"></script>
<script type="text/javascript">
    var datetype = '';
    var updatetime = new Date();
    var hoteljson = {};
    var ratejson = {};
    var imgjson = {};
    var MemberCardRuleJson = {};
    var SurplusCouponJson = {};

    $(function () {
        var today = new Date();
        var tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000));
        var todayMonth = today.getMonth() + 1;
        var todayDay = today.getDate();
        $('#indate').attr('datestr', getDateFormate(today));
        $('#indate').text(todayMonth.toString() + '-' + todayDay.toString());
        $('#indatestr').text(getdatestr($('#indate').attr('datestr')));
        var tomorrowMonth = tomorrow.getMonth() + 1;
        var tomorrowDay = tomorrow.getDate();
        $('#outdate').attr('datestr', getDateFormate(tomorrow));
        $('#outdate').text(tomorrowMonth.toString() + '-' + tomorrowDay.toString());
        $('#outdatestr').text(getdatestr($('#outdate').attr('datestr')));
        $('#days').text(getDays($('#indate').attr('datestr'), $('#outdate').attr('datestr')));

        getMemberCardIntegralRule();
        //        getimgs();
        gethotelinfo();
        getratejson();
        getStatisticsCount();
        getSurplusCouponlist();
    });

    function getSurplusCouponlist() {
        $.ajax({
            url: '/action/getSurplusCouponlist',
            type: 'post',
            data: { hotelweixinid: sys_hotelWeixinid, userweixinid: sys_userWeixinid },
            success: function (data) {
                SurplusCouponJson = $.parseJSON(data);
                $.each(SurplusCouponJson, function (k, coupon) {
                    var div = $('#SurplusCouponlist div.copy').clone(true).removeClass('copy');
                    div.attr('couponid', coupon['CouponID']);
                    if (coupon['HaveGet'] == 1) {
                        div.addClass('cur');
                    }
                    div.find('.price').text(coupon['Moneys']);
                    div.find('.stime').text(coupon['sTimeStr']);
                    div.find('.etime').text(coupon['ExtTimeStr']);
                    $('#SurplusCouponlist').append(div);
                });
            }
        });
    }

    function createswiper(objname) {
        var swiper = new Swiper('.swiper-container', {
            pagination: '.swiper-pagination',
            paginationClickable: true,
            autoplay: 2500,
            autoplayDisableOnInteraction: false,
            loop: true,
            onSlideChangeEnd: function (swiper) {
                var activeindex = parseInt(swiper.activeIndex);
                activeindex -= 1;
                if (activeindex <= 0) {
                    activeindex += 2;
                }
                $('.activeIndex').text(activeindex);
            }
        });
    }

    function getStatisticsCount() {
        $.ajax({
            url: '/action/getStatisticsCount',
            type: 'post',
            data: { hid: sys_hid, userWeixinid: sys_userWeixinid, hotelWeixinid: sys_hotelWeixinid },
            success: function (data) {
                var _json = $.parseJSON(data);
                if (_json['SaleProduct'] > 0) {
                    //                    getgroupsale();
                }
                if (_json['CouPon'] > 0) {
                    $('#takecoupon').show();
                }
            }
        });
    }

    function getMemberCardIntegralRule() {
        $.ajax({
            url: '/action/getMemberCardIntegralRule',
            type: 'post',
            data: { userWeixinid: sys_userWeixinid, hotelWeixinid: sys_hotelWeixinid },
            success: function (data) {
                var _json = $.parseJSON(data);
                MemberCardRuleJson = _json['rule'];
                if (_json['becomeMember']) {
                    var memberinfo = _json['memberinfo'];
                    var table = $('.hyk-mask .mem-right table');
                    if (memberinfo['gift'] > 0) {
                        $('.hyk-mask .gift').show();
                        $('.hyk-mask .hongbao').text(memberinfo['gift'] * memberinfo['giftnum']);
                    }
                    var membernameAry = ['普通会员', '高级会员', '白金会员', '黄金会员', '钻石会员'];
                    for (var i = 0; i < 5; i++) {
                        var tr = $('.hyk-mask .mem-right table tr.copy').clone(true).removeClass('copy');
                        tr.find('.membername').text(membernameAry[i]);
                        var viprate = memberinfo['vip' + i + 'rate'];
                        if (viprate == 0) {
                            tr.find('.viprate').closest('td').text('--');
                            tr.find('.viprate').remove();
                        } else {
                            tr.find('.viprate').text(viprate.toFixed(1));
                        }
                        var vipplus = memberinfo['vip' + i + 'plus'];
                        if (vipplus == 0) {
                            tr.find('.vipplus').closest('td').text('--');
                            tr.find('.vipplus').remove();
                        } else {
                            tr.find('.vipplus').text(vipplus.toFixed(1));
                        }
                        table.append(tr);
                    }
                    $(".hyk-mask").fadeIn();
                }
            }
        });
    }

    //领取会员卡
    $(".get-card .close").click(function () {
        $(".hyk-mask").fadeOut();
    })

    function getgroupsale() {
        $("#groupsalelist").html('<img src="../../images/login.gif" />');
        $.post("/action/getgroupsale", { hid: sys_hid, hotelweixinid: sys_hotelWeixinid }, function (data) {
            $("#groupsalelist").children().remove();
            var _json = $.parseJSON(data);
            $.each(_json, function (k, prod) {
                var li = $('.groupsalelistcopy li').clone(true).removeClass('copy');
                li.attr('prodid', prod['Id']);
                if (prod['SmallImageList'] != '') {
                    var imagelist = prod['SmallImageList'].toString().split(',');
                    li.find('.room-pic img').attr('src', imagelist[0]);
                }
                li.find('.room-name').text(prod['ProductName']);
                //  1 预售    0 团购
                if (prod['ProductType'] == 1) {
                    li.find('.yu-overflow .babel.type1').show();
                    li.find('.yu-overflow .babel.type2').show();
                } else {
                    li.find('.yu-overflow .babel.type3').show();
                }
                li.find('.price').text(prod['ProductPrice']);
                $('#groupsalelist').append(li);
            });
            $('#groupsale').show();
            $('#groupsalelist').show();
        });
    }

    function getdatestr(datestr) {
        var date = new Date(getDateFormate(new Date(datestr)));
        var today = new Date(getDateFormate(new Date()));
        var days = getDays(today, date);
        if (days == 0) {
            return '今天';
        }
        if (days == 1) {
            return '明天';
        }
        if (days == 2) {
            return '后天';
        }
        var weekary = { 0: '周日', 1: '周一', 2: '周二', 3: '周三', 4: '周四', 5: '周五', 6: '周六' };
        return weekary[date.getDay()];
    }

    function getDays(indate, outdate) {
        var indate = new Date(getDateFormate(new Date(indate)));
        var outdate = new Date(getDateFormate(new Date(outdate)));
        var days = outdate.getTime() - indate.getTime();
        var d = days / (24 * 60 * 60 * 1000);
        return d;
    }

    function gethotelinfo() {
        $.ajax({
            url: '/action/gethotelinfo',
            type: 'post',
            data: { hid: sys_hid, hotelweixinid: sys_hotelWeixinid },
            success: function (data) {
                hoteljson = $.parseJSON(data);
                $('#hotelname').text(hoteljson['SubName']);
                $('#address').text(hoteljson['Address']);
                $('#hoteltel').text(hoteljson['Tel']);
                $('#calltel a').attr('href', 'tel://' + hoteljson['Tel']);
                if (hoteljson['FuWu'].indexOf('无线wifi上网') >= 0) {
                    $('#hotelserve .wifi').addClass('yu-blue');
                }
                if (hoteljson['FuWu'].indexOf('停车') >= 0) {
                    $('#hotelserve .stopping').addClass('yu-blue');
                }
                if (hoteljson['CanYin'] != '') {
                    $('#hotelserve .catering').addClass('yu-blue');
                }
                if (hoteljson['FuWu'].indexOf('行李存放') >= 0) {
                    $('#hotelserve .luggage').addClass('yu-blue');
                }
                if (hoteljson['YuLe'].indexOf('健身房') >= 0) {
                    $('#hotelserve .gymnasium').addClass('yu-blue');
                }
            }
        });
    }

    function getimgs() {
        $.ajax({
            url: '/action/getroomimgs',
            type: 'post',
            data: { hid: sys_hid, hotelweixinid: sys_hotelWeixinid },
            success: function (data) {
                imgjson = $.parseJSON(data);
                var imgcount = 0;
                $.each(imgjson, function (rid, imgs) {
                    $.each(imgs, function (k, img) {
                        if (img['ImgType'] == 2) {
                            $('.swiper-container .swiper-wrapper').append($('<div>', { class: 'swiper-slide' }).append($('<img>', { src: img['BigUrl'], css: { 'max-height': '150px'} })));
                            imgcount += 1;
                        }
                    });
                });
                $('.totalindex').text(imgcount);
                createswiper('swiper-container');
            }
        });
    }

    function fetchimgs() {
        var imgcount = 0;
        $.each(imgjson, function (rid, imgs) {
            $.each(imgs, function (k, img) {
                if (img['ImgType'] == 2) {
                    $('.swiper-container .swiper-wrapper').append($('<div>', { class: 'swiper-slide' }).append($('<img>', { src: img['BigUrl'], css: { 'max-height': '150px'} })));
                    imgcount += 1;
                }
            });
        });
        $('.totalindex').text(imgcount);
        createswiper('swiper-container');
    }

    function getDateFormate(date) {
        var todayYear = date.getYear() + 1900;
        var todayMonth = date.getMonth() + 1;
        var todayDay = date.getDate();
        return todayYear.toString() + '-' + todayMonth.toString() + '-' + todayDay.toString();
    }

    $("#datepicker").datepicker({
        dateFormat: 'yy-mm-dd',
        dayNamesMin: ["日", "一", "二", "三", "四", "五", "六"],
        monthNames: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
        yearSuffix: '年',
        showMonthAfterYear: true,
        numberOfMonths: 2,
        prevText: "上月",
        nextText: '下月',
        showButtonPanel: false,
        onSelect: function (datestr) {
            var date = new Date(datestr);
            var month = date.getMonth() + 1;
            var day = date.getDate();
            $('#datepicker').hide();
            if (datetype == 'indate') {
                $('#indate').text(month.toString() + '-' + day.toString());
                $('#indate').attr('datestr', datestr);
                $('#indatestr').text(getdatestr(datestr));
                dateclick('outdate');
            } else if (datetype == 'outdate') {
                var stdate = new Date($('#indate').attr('datestr'));
                var i = date.getTime() - stdate.getTime();
                if (i < 0) {
                    $('#indate').text(month.toString() + '-' + day.toString());
                    $('#indate').attr('datestr', datestr);
                    $('#indatestr').text(getdatestr(datestr));
                    dateclick('outdate');
                } else {
                    $('#outdate').text(month.toString() + '-' + day.toString());
                    $('#outdate').attr('datestr', datestr);
                    $('#outdatestr').text(getdatestr(datestr));
                    getratejson();
                    $('#days').text(getDays($('#indate').attr('datestr'), $('#outdate').attr('datestr')));
                    $(".base-page").show();
                    $(".date-page").hide();
                }
            }
        }
    });

    $(document).on('click', '.date-page .back,.date-page .top', function () {
        $('.base-page').show();
        $('.date-page').hide();
    });

    $('.rooms-date-change li').click(function () {
        dateclick('indate');
    });

    function dateclick(_datetype) {
        datetype = _datetype;
        if (datetype == '' || datetype == undefined) {
            datetype = 'indate';
        }
        if (datetype == 'indate') {
            minDate = getDateFormate(new Date());
        } else {
            var indate = $('#indate').attr('datestr');
            var dd = new Date((new Date(indate)).getTime() + (24 * 60 * 60 * 1000));
            minDate = getDateFormate(dd);
        }
        $('.date-page .top').text(datetype == 'indate' ? '入住日期' : '离店日期');
        var defaultDate = new Date($('#' + datetype).attr('datestr'));

        //最多预订60天的价格
        maxDate = new Date((new Date()).getTime() + (60 * (24 * 60 * 60 * 1000)));
        $("#datepicker").datepicker('option', 'minDate', minDate);
        $("#datepicker").datepicker('option', 'maxDate', getDateFormate(maxDate));
        $("#datepicker").datepicker('setDate', defaultDate);
        $(".base-page").hide();
        $(".date-page").show();
        $('#datepicker').show();
    }

    function getratejson() {
        var indate = $('#indate').attr('datestr');
        var outdate = $('#outdate').attr('datestr');
        $.ajax({
            url: '/action/getratejson',
            type: 'post',
            data: { hid: sys_hid, indate: indate, outdate: outdate },
            success: function (data) {
                ratejson = $.parseJSON(data);
                imgjson = ratejson['roomImgs'];
                fetchratelist(ratejson);
                fetchimgs();
            }
        });
    }

    function getRulePrice(price) {
        var graderate = parseFloat(MemberCardRuleJson['GradeRate']);
        var pricejson = {};
        if (graderate > 0) {
            var saleprice = parseInt(price * graderate / 10);
            var discount = price - saleprice;
            pricejson['saleprice'] = saleprice;
            pricejson['originalprice'] = price;
            pricejson['discount'] = discount;
        } else {
            pricejson['saleprice'] = price;
        }
        return pricejson;
    }

    function fetchratelist(json) {
        var hourroomRatesJson = json['hourroomRates'];
        var roomRatesJson = json['roomRates'];
        var roomlistJson = json['roomlist'];
        sys_tokenkey = json['tokenkey'];
        sys_token = json['token'];

        $('#roomlist').hide();
        $('#hourroomlist').hide();
        $('#roomlist li[roomid]').remove();
        $('#hourroomlist .room-content li[rateplanid]').remove();
        if (!$.isEmptyObject(hourroomRatesJson)) {
            $.each(hourroomRatesJson, function (roomtypeid, rate) {
                var li = $('#hourroomlist li.copy').clone(true).removeClass('copy');
                var roominfo = getroominfo(roomtypeid, roomlistJson);
                li.find('.room-name').text(roominfo['room']['RoomName']);
                li.find('.roomhour').text(roominfo['rateplan']['HourRoomType']);
                //价格
                var pricejson = getRulePrice(rate['Price']);
                li.find('.price').text(pricejson['saleprice']);
                //roominfo['room']['ConPons'] == 1 &&
                if (pricejson['discount'] != undefined) {
                    li.find('.price').closest('p').removeClass('yu-line50');
                    li.find('.originalprice label').text(pricejson['originalprice']);
                    li.find('.discount label').text(pricejson['discount']);
                    li.find('.originalprice').show();
                    li.find('.discount').show();
                }
                fetchorderbtn(rate, roominfo['rateplan'], li);
                li.attr('rateplanid', roominfo['rateplan']['ID']);
                li.attr('roomid', roominfo['room']['ID']);
                li.attr('ishourroom', 1);
                $('#hourroomlist .room-content').append(li);
            });
            if ($('#hourroomlist .room-content li[rateplanid]').length > 0) {
                $('#hourroomlist').show();
                $('#hourroomlist .lowestprice').text($('#hourroomlist .room-content li[rateplanid] .price:eq(0)').text());
            }
        }

        if (!$.isEmptyObject(roomRatesJson)) {
            $.each(roomRatesJson, function (roomtypeid, rate) {
                var roominfo = getroominfo(roomtypeid, roomlistJson);
                var room = roominfo['room'];
                var roomid = room['ID'];
                var rateplanid = roominfo['rateplan']['ID'];
                if ($('#roomlist li[roomid=' + roomid + ']').length == 0) {
                    var li = $('#roomlist li.copy').clone(true).removeClass('copy');
                    li.attr('roomid', roomid);
                    if (imgjson[roomid] != undefined) {
                        li.find('.roomimg').attr('src', imgjson[roomid][0]['SmallUrl']);
                        li.find('.room-pic-num span').text(imgjson[roomid].length);
                    } else {
                        li.find('.roomimg').attr('src', '../../images/defaultRoomImg.jpg');
                        li.find('.room-pic-num span').text(0);
                    }

                    li.find('.room-name').text(room['RoomName']);
                    var roominfoAry = new Array();
                    if (!(room['Area'] == '' || room['Area'] == '0')) {
                        var area = room['Area'];
                        area = area.replace('平方米', '').replace('平方', '');
                        roominfoAry.push(area + '㎡');
                    }
                    roominfoAry.push(room['BedType']);
                    roominfoAry.push(room['BedArea']);
                    roominfoAry.push(room['Window']);
                    roominfoAry.push(room['NetType']);
                    var roominfostr = roominfoAry.join(' ');
                    li.find('.roominfo').text(roominfostr);

                    var rateplanitem = li.find('.rateplanitem');
                    rateplanitem.attr('roomid', roomid);
                    fetchRateplanItem(room, roominfo['rateplan'], rate, rateplanitem);

                    var saleprice = parseInt(rateplanitem.find('.price').text());
                    if (saleprice > 0) {
                        li.find('.lowestprice').text(saleprice);
                        li.find('.lowestprice').closest('div').addClass('yu-orange');
                    } else {
                        li.find('.lowestprice').closest('div').addClass('yu-grey');
                        li.find('.lowestprice').closest('div').find('.yu-font12').hide();
                        li.find('.lowestprice').text('已售完');
                    }
                    $('#roomlist').append(li);
                } else {
                    var rateplanitem = $('#roomlist .copy .rateplanitem').clone(true);
                    rateplanitem.attr('roomid', roomid);
                    $('#roomlist li[roomid=' + roomid + '] .room-content').append(rateplanitem);
                    fetchRateplanItem(room, roominfo['rateplan'], rate, rateplanitem);
                }
            });
            if ($('#roomlist li[roomid]').length > 0) {
                $('#roomlist').show();
                $('#roomlist li[roomid]:eq(0) .room-content-head').trigger('click');
            }
        }
    }

    function getroominfo(roomtypeid, roomlistJson) {
        var roomid = roomtypeid.substring(0, roomtypeid.indexOf('_'));
        var rateplanid = roomtypeid.substring(roomtypeid.indexOf('_') + 1, 20);
        var info = {};
        $.each(roomlistJson, function (k, room) {
            if (room['ID'] == roomid) {
                info['room'] = room;
                $.each(room['RateplanList'], function (k2, rateplan) {
                    if (rateplan['ID'] == rateplanid) {
                        info['rateplan'] = rateplan;
                        return false;
                    }
                });
                return false;
            }
        });
        return info;
    }

    function fetchorderbtn(rate, rateplan, element) {
        if (rate['Available'] == 1) {
            element.find('.room-price-wrap .price').closest('p').addClass('yu-orange');
            var btnspan = $('<span>');
            switch (rateplan['PayType']) {
                case '0':
                    {
                        btnspan.text('在线付');
                    }
                    break;
                case '1':
                    {
                        //                        if (rateplan['guarantee_type'] == 1) {
                        //                            btnspan.text('担保');
                        //                        } else {
                        //                            btnspan.text('到店付');
                        //                        }
                        btnspan.text('到店付');
                        btnspan.addClass('type1');
                    }
                    break;
            }
            element.find('.order-btn').append(btnspan);
        }
        else if (rate['Available'] == 0) {
            element.find('.room-price-wrap .price').closest('p').addClass('yu-grey');
            element.find('.order-btn').addClass('over');
        }
    }

    $('.room-content-head').on("click", function () {
        $(this).toggleClass("cur").siblings(".room-content").slideToggle();
    });

    function fetchRateplanItem(room, rateplan, rate, rateplanitem) {
        rateplanitem.attr('rateplanid', rateplan['ID']);
        rateplanitem.attr('ishourroom', 0);
        rateplanitem.attr('Available', rate['Available']);
        var rateplanname = rateplan['RatePlanName'] + '(' + rateplan['ZaoCan'] + ')';
        if (rateplan['CheckOutTime'].indexOf('00') >= 0 && rateplan['CheckOutTime'] != '12:00') {
            rateplanname += '(延迟到' + rateplan['CheckOutTime'] + '退房)';
        }
        rateplanitem.find('.rateplanname').text(rateplanname);
        fetchorderbtn(rate, rateplan, rateplanitem);
        var price = parseInt(rate['Price']);
        if (price > 0) {
            var pricejson = getRulePrice(rate['Price']);
            //room['ConPons'] == 1 &&
            if (pricejson['discount'] != undefined) {
                rateplanitem.find('.originalprice label').text(pricejson['originalprice']);
                rateplanitem.find('.originalprice').show();
                rateplanitem.find('.discount label').text(pricejson['discount']);
                rateplanitem.find('.discount').show();
                rateplanitem.find('.price').closest('p').removeClass('yu-line60');
            }
            rateplanitem.find('.price').text(pricejson['saleprice']);
        } else {
            rateplanitem.find('.price').closest('p').hide();
        }
    }

    $('#calltel').click(function () {
        $('#calltel a').trigger('click');
    });

    $('#tomap').click(function () {
        window.location.href = '/Hotel/Map/' + sys_hid;
    });

    $(document).on('click', '.order-btn', function () {
        var that = $(this);
        if (!that.hasClass('over')) {
            var roomid = that.closest('li').attr('roomid');
            var rateplanid = that.closest('li').attr('rateplanid');
            var ishourroom = that.closest('li').attr('ishourroom');
            var discount = parseInt(that.closest('li').find('.discount label').text());
            submitorder(roomid, rateplanid, ishourroom, discount);
        }
    });

    function submitorder(roomid, rateplanid, ishourroom, discount) {
        var roomkey = 'roomRates';
        if (ishourroom == 1) {
            roomkey = 'hourroomRates';
        }
        if (ratejson[roomkey]['Available'] == 0 || ratejson[roomkey]['Price'] == 0) {
            return false;
        }
        var roomtypeid = roomid + '_' + rateplanid;
        var roominfo = getroominfo(roomtypeid, ratejson['roomlist']);
        var orderjson = {};
        orderjson['indate'] = $('#indate').attr('datestr');
        orderjson['outdate'] = $('#outdate').attr('datestr');
        orderjson['room'] = roominfo['room'];
        orderjson['rateplan'] = roominfo['rateplan'];
        orderjson['roomid'] = roomid;
        orderjson['rateplanid'] = rateplanid;
        var days = parseInt($('#days').text());
        orderjson['price'] = ratejson[roomkey][roomtypeid]['Price'] * days;
        orderjson['ishourroom'] = ishourroom;
        orderjson['days'] = days;
        orderjson['MemberCardRule'] = MemberCardRuleJson;
        orderjson['discount'] = discount;
        orderjson['hotelname'] = $('#hotelname').text();
        //        orderjson['room']['RateplanList'] = undefined;
        orderjson['tokenkey'] = sys_tokenkey;
        orderjson['token'] = sys_token;
        $('#orderform input[name="orderjson"]').val(JSON.stringify(orderjson));
        $('#submitorder').trigger('click');
    }

    $('#hotelserve').closest('li').click(function () {
        $(this).find('a').trigger('click');
    });

    $('#groupsalelist li[prodid]').click(function () {
        var prodid = $(this).attr('prodid');
        window.location.href = '/Product/ProductIndex/' + sys_hid + '?key=' + sys_hotelWeixinid + '@' + sys_userWeixinid + '@' + sys_generatesign + '&Id=' + prodid;
    });

    //领取红包
    $(".get-quan").click(function () {
        $(".lqhb").fadeIn();
    })
    $("#SurplusCouponlist .row").on("click", function () {
        var that = $(this);
        if (!that.hasClass('cur')) {
            var couponid = that.attr('couponid');
            $.post('/Home/GetCouPon/' + sys_hid + '?weixinID=' + sys_hotelWeixinid + '&userWeiXinID=' + sys_userWeixinid + '&couponid=' + couponid, function (data) {
                if (data.error == '0') {
                    that.addClass("cur");
                } else {
                    WXweb.utils.MsgBox(data.message);
                }
            });
        }
    })
    $(".get-btn2").click(function () {
        $(".lqhb").fadeOut();
    })

    //浏览大图
    $(document).on('click', '#roomlist .room-pic', function (e) {
        //        
        var that = $(this);
        var roomid = that.closest('li').attr('roomid');
        var rateplanid = that.closest('li').find('.room-content .rateplanitem').attr('rateplanid');
        $('.swiper-container2 .swiper-wrapper').children().remove();
        $.each(imgjson, function (rid, imgs) {
            if (rid == roomid) {
                $.each(imgs, function (k, img) {
                    $('.swiper-container2 .swiper-wrapper').append($('<div>', { class: 'swiper-slide' }).append($('<img>', { src: img['BigUrl'] })));
                });
            }
        });
        var swiper2 = new Swiper('.swiper-container2', {
            paginationClickable: true,
            autoplayDisableOnInteraction: false,
            loop: true
        });
        var state = that.closest('li').find('.room-content .rateplanitem').attr('Available');
        var roominfo = getroominfo(roomid + '_' + rateplanid, ratejson['roomlist']);
        var roomobj = roominfo['room'];
        var rateplanobj = roominfo['rateplan'];
        $('.big-pic .roomname').text(roomobj['RoomName']);
        $('.big-pic .breakfast').text(rateplanobj['ZaoCan']);
        var area = roomobj['Area'];
        if (area != '' && area != '0') {
            area = area.replace('平方米', '').replace('平方', '');
            area += '㎡';
        } else {
            area = '--';
        }
        $('.big-pic .area').text(area);
        $('.big-pic .nettype').text(roomobj['NetType']);
        $('.big-pic .floor').text(roomobj['Floor']);
        $('.big-pic .bedtype').text(roomobj['BedType']);
        $('.big-pic .addbed').text(roomobj['AddBed']);
        $('.big-pic .yu-grid').hide();
        if (state == 1) {
            var price = that.closest('li').find('.room-content .rateplanitem:eq(0) .price').text();
            $('.big-pic .book-btn').attr('roomid', roomid);
            $('.big-pic .book-btn').attr('rateplanid', rateplanid);
            $('.big-pic .price').text(price);
            $('.big-pic .yu-grid').show();
        }
        $(".big-pic").fadeIn();
        e.stopPropagation();
        return;
    });
    $(".big-pic .close").click(function () {
        $(".big-pic").fadeOut();
    })
    $('.big-pic .book-btn').click(function () {
        var that = $(this);
        var roomid = that.attr('roomid');
        var rateplanid = that.attr('rateplanid');
        var discount = $('#roomlist li[roomid=' + roomid + '] .rateplanitem[rateplanid=' + rateplanid + '] .discount label').text();
        var ishourroom = $('#roomlist li[roomid=' + roomid + '] .rateplanitem[rateplanid=' + rateplanid + ']').attr('ishourroom');
        submitorder(roomid, rateplanid, ishourroom, discount);
    });
</script>
