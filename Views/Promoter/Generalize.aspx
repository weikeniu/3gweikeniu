<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    hotel3g.Models.DAL.JsApiSignatureResponse SignatureResponse = ViewData["signature"] as hotel3g.Models.DAL.JsApiSignatureResponse;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    hotel3g.Repository.MemberCard CurUser = ViewData["CurUser"] as hotel3g.Repository.MemberCard;
    hotel3g.Repository.HotelInfoItem HotelInfo = ViewData["HotelInfo"] as hotel3g.Repository.HotelInfoItem;
%>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8" />
    <title></title>
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=1.0" rel="stylesheet"
        type="text/css" />
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/mend-reset.css" />
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/mend-weikeniu.css" />
    <script src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
    <script src="https://cdn.bootcss.com/html2canvas/0.5.0-beta4/html2canvas.js" type="text/javascript"></script>
    <%--<script src="../../Scripts/html2canvas.js" type="text/javascript"></script>--%>
    <script>
        //        var useragent = navigator.userAgent;
        //        if (useragent.match(/MicroMessenger/i) != 'MicroMessenger') {
        //            // 这里警告框会阻塞当前页面继续加载  
        //            alert('已禁止本次访问：您必须使用微信内置浏览器访问本页面！');
        //            // 以下代码是用javascript强行关闭当前页面  
        //            var opened = window.open('about:blank', '_self');
        //            opened.opener = null;
        //            opened.close();
        //        }
    </script>
</head>
<body class="bg--8700e6">
    <section class="loading-page" style="position: fixed;">
			<div class="inner">
				<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
				<img src="http://css.weikeniu.com/images/loading-n.png" />
			</div>
		</section>
    <!-- <>我的推广(会员中心) -->
    <div class="pg__myPromotion clearfix">
        <!--//顶部导航-->
        <div class="zone__headNav fixed">
            <div class="head">
                <a class="back" href="javascript:history.back(-1);"></a>
                <h2 class="tit">
                    我的推广</h2>
            </div>
        </div>
        <!--//文字说明-->
        <div class="zone__txtTips">
            <h2>
                <%=string.IsNullOrEmpty(CurUser.nickname) ? CurUser.name : CurUser.nickname %>的专属推广</h2>
            <label>
                长按保存图片，分享给好友赚钱</label>
        </div>
        <!--//大图区域-->
        <div class="zone__bigImg-panel" style="display: none;">
            <div class="bigImg-inner" id="coverpanl">
                <!--//卡片区域-->
                <div class="img__card">
                    <div class="head flexbox">
                        <%--<img class="uimg" src="/Promoter/CoverImage?src=<%=headerurl %>" />--%>
                        <img class="uimg" src="<%=CurUser.photo %>" />
                        <div class="intro flex1">
                            <p>
                                我是<b class="yellow"><%=string.IsNullOrEmpty(CurUser.nickname) ? CurUser.name : CurUser.nickname %></b>，</p>
                            <p>
                                我代<%=HotelInfo.SubName %><b class="yellow">为您发放<%=ViewData["money"] %>元红包！</b></p>
                            <p>
                                长按图片，识别图中二维码关注领取。</p>
                        </div>
                    </div>
                    <div class="main" style="background: #ff4274; border: none;">
                        <div class="logo">
                            <img src="<%=ViewData["HotelLogo"] %>" />
                        </div>
                        <!--<img class="bigimg" src="../images/hotel-bigimg.jpg" />-->
                        <img class="bigimg" src="<%=ViewData["background"] %>" />
                        <!--//二维码-标题-->
                        <div class="foot">
                            <div class="qrcode">
                                <div class="bg">
                                    <h5>
                                        关注酒店，领取红包</h5>
                                    <%--<img src="/Promoter/CoverImage?src=<%=ViewData["Logo"] %>" />--%>
                                    <img src="<%=ViewData["Logo"] %>" />
                                </div>
                            </div>
                            <h2 class="tit2">
                                <em>
                                    <%=HotelInfo.SubName %></em>
                            </h2>
                            <h3 class="desc2">
                                <em>
                                    <%=ViewData["info"]%></em>
                            </h3>
                        </div>
                    </div>
                </div>
                <div class="foot__btn">
                    <a href="#">
                        <%--点击复制二维码地址--%></a>
                </div>
                <div class="box__shadow">
                </div>
            </div>
        </div>
        <!--//网页分享-->
        <div class="zone__similar share-cnt">
            <div class="inner">
                <h3>
                    网页分享</h3>
                <div class="ct">
                    <a class="btn-share J__btnShare" href="javascript:void(0)" id="share">发好友红包，奖励拿不停</a>
                </div>
            </div>
        </div>
        <!--//分享赚钱-->
        <div class="zone__similar share-step">
            <div class="inner">
                <h3>
                    分享赚钱</h3>
                <div class="ct">
                    <div class="row">
                        <p>
                            第一步，转发推广图或分享推广页面到朋友圈与微信好友</p>
                        <p>
                            第二步，从您转发的推广图或页面，输入手机号领取红包</p>
                        <p>
                            第三步，通过转发的推广图或页面识别二维码关注公众号，领取成为公众号微官网会员，此时会给此会员锁定为你推广来的用户，他在微官网进行的订房，抢购，订餐，超市进行消费，你会有佣金奖励</p>
                        <p>
                            第四步，您可以在推广员中心查看佣金信息，及各商品的佣金金额</p>
                    </div>
                    <div class="row">
                        <h2>
                            规则说明：</h2>
                        <p>
                            1、首次分享，您可以得到此推广红包
                        </p>
                        <p>
                            2、您推广的用户需要成为公众号微官网会员，成为会员后的消费才有奖励
                        </p>
                        <p>
                            3、分享后自动带有您独有的推荐码，您的好友访问之后，系统会自动检测并记录客户关系。推广员本人不能成为自己的客户,本人领取自己分享的红包也不予发放</p>
                        <p>
                            4、如果您的好友已被其他人抢先发展成了客户，他就不能成为您的客户，以最早发展成为客户为准。</p>
                        <p>
                            5、分享推广新会员可积分奖励，积分可在酒店内兑换客房、餐券、门票、特产等礼品。</p>
                        <p>
                            6、您发展的客户前三个月在酒店的成功订单都产生佣金，三个月后无佣金。</p>
                        <p>
                            7、领取分享的红包，仅限首次领取的用户
                        </p>
                        <p>
                            8、该红包不可提现，不予其它活动优惠同时使用
                        </p>
                    </div>
                    <div class="row" style="display: none;">
                        <h2>
                            佣金说明：</h2>
                        <% var yongjin = ViewData["yongjin"] as System.Data.DataTable; %>
                        <% if (yongjin != null && yongjin.Rows.Count > 0)
                           {
                               System.Data.DataRow row = yongjin.Rows[0];
                               decimal MoneyError = 0;
                               decimal kefang = decimal.TryParse(row["kefang"].ToString(), out MoneyError) ? decimal.Parse(row["kefang"].ToString()) : 0;
                               decimal canyin = decimal.TryParse(row["canyin"].ToString(), out MoneyError) ? decimal.Parse(row["kefang"].ToString()) : 0;
                               decimal tuangou = decimal.TryParse(row["tuangou"].ToString(), out MoneyError) ? decimal.Parse(row["kefang"].ToString()) : 0; 
                        %>
                        <p>
                            1、【酒店客房】最低佣金率为售价的<%=tuangou * 80 / 100 %>%起</p>
                        <p>
                            2、【自营餐饮】最低佣金率为售价的<%=canyin * 80 / 100%>%起</p>
                        <p>
                            3、【团购预售】最低佣金率为售价的<%=tuangou * 80 / 100%>%起</p>
                        <%}
                           else
                           { %>
                        酒店暂未设置
                        <%} %>
                    </div>
                </div>
            </div>
            <!--查看佣金-->
            <a href="/MemberFx/FxExtensCenter/<%=ViewData["hid"]%>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
                <div class="zone__viewDetail">
                    <div class="clearfix">
                        <h2 class="fl">
                            <i>￥</i>查看佣金详情</h2>
                        <i class="fr css3-arr"></i>
                    </div>
                </div>
            </a>
        </div>
    </div>
    <!--右上角分享提示-->
    <div class="pop__wx-share">
    </div>
</body>
</html>
<script type="text/javascript" src="http://css.weikeniu.com/Scripts/layer/layer.js"></script>
<script type="text/javascript">
    $(function () {
        var caoshi = setTimeout(function () {
            $(".loading-page").hide();
            //超时处理 提示网路超时
            alert("您的网络已经到火星去了");
        }, 10000);

        document.onreadystatechange = subSomething; //当页面加载状态改变的时候执行这个方法. 
        function subSomething() {
            if (document.readyState == "complete") {
                clearTimeout(caoshi);
                setTimeout(function () {

                    //延迟启动 预留图片渲染时间
                    CreateCover();
                }, 1000);
                $(".zone__bigImg-panel").show();
            }
        }

        //生成图片
        function CreateCover() {
            // 加载完成
            var w = $("#coverpanl").width();
            var h = $("#coverpanl").height();
            window.location.href = "#coverpanl";
            //要将 canvas 的宽高设置成容器宽高的 2 倍
            var canvas = document.createElement("canvas");
            canvas.width = w * 2;
            canvas.height = h * 2;
            canvas.style.width = w + "px";
            canvas.style.height = (h * 1) + "px";
            var context = canvas.getContext("2d");
            //然后将画布缩放，将图像放大两倍画到画布上
            //context.scale(1.9, 1.9);
            context.scale(1.9, 1.9);
            html2canvas($("#coverpanl"), {
                canvas: canvas,
                useCORS: true,
                onrendered: function (canvas) {
                    var url = canvas.toDataURL();
                    var cover = $("<img />").attr("src", url).css("width", "100%"); ;
                    //$(".bigImg-inner").remove();
                    $(".zone__bigImg-panel").empty();
                    $(".zone__bigImg-panel").after(cover);
                    //$(".zone__bigImg-panel").append(cover);
                    //$(".zone__bigImg-panel").append(canvas);
                    //$("canvas").attr("style", "width:100%");

                    $('html,body').animate({ scrollTop: 0 }, 'slow');
                    $(".loading-page").hide();
                }
            });
        }

    });
  

</script>
<script type="text/javascript" src="http://css.weikeniu.com/Scripts/layer/layer.js"></script>
<!--微信分享-->
<script src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
<script>
   //分享成功 发放一次红包
    var id = '<%=CurUser.memberid %>'; //服务端设置的id,用于下面拼接生成需要分享的link
    var hid = '<%=ViewData["hid"] %>'
    var shareurl = 'http://hotel.weikeniu.com/Promoter/Coupon?id=' + id + '&hid=' + hid;
   
 
    wx.config({
        debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
        appId: '<%=SignatureResponse.appid %>', // 必填，公众号的唯一标识
        timestamp: '<%=SignatureResponse.timestamp %>', // 必填，生成签名的时间戳
        nonceStr: '<%=SignatureResponse.noncestr %>', // 必填，生成签名的随机串
        signature: '<%=SignatureResponse.signature.ToLower() %>', // 必填，签名，见附录1
        jsApiList: [
        'onMenuShareTimeline', 
        'onMenuShareAppMessage', 
        'hideAllNonBaseMenuItem',
        'hideMenuItems',
        'showMenuItems'] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
    });
    
    wx.ready(function () {
             //隐藏按钮
             wx.hideMenuItems({  
                menuList:[ 
                'menuItem:share:qq',  
                'menuItem:copyUrl',
                'menuItem:share:weiboApp',
                'menuItem:favorite"',
                'menuItem:share:facebook',
                'menuItem:share:QZone',
                'menuItem:editTag',
                'menuItem:delete',
                'menuItem:copyUrl',
                'menuItem:originPage',
                'menuItem:openWithQQBrowser',
                'menuItem:openWithSafari',
                'menuItem:share:email',
                'menuItem:share:brand',
                'menuItem:favorite'
               ]
             }); 
         
        wx.onMenuShareTimeline({
            title: '我在 <%=HotelInfo.SubName %> 领取到了<%=ViewData["money"] %>元红包! 快来领取吧~', // 分享标题
            link: shareurl, // 分享链接
            imgUrl: '<%=HotelInfo.hotelLog %>', // 分享图标
            success: function () {
                // 用户确认分享后执行的回调函数
                //window.location.href = shareurl;
                //分享成功 发放一次红包
                var url = "/Promoter/ShareCoupon/<%=ViewData["hid"]%>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>";
                $.post(url,function(data,status){
                        layer.msg(data.msg);
                });
            },
            cancel: function () {
                // 用户取消分享后执行的回调函数
            }
        });

        wx.onMenuShareAppMessage({
    title: '<%=CurUser.nickname %>代<%=HotelInfo.SubName %>送你<%=ViewData["money"] %>元红包', // 分享标题
    desc: '<%=ViewData["Remark"] %>', // 分享描述
    link: shareurl, // 分享链接
    imgUrl:  '<%=HotelInfo.hotelLog %>', // 分享图标
    type: '', // 分享类型,music、video或link，不填默认为link
    dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
    success: function () { 
        // 用户确认分享后执行的回调函数
          //分享成功 发放一次红包
                var url = "/Promoter/ShareCoupon/<%=ViewData["hid"]%>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>";
                $.post(url,function(data,status){
                layer.msg(data.msg);
                });
    },
    cancel: function () { 
        // 用户取消分享后执行的回调函数
    }
});


    }); 
</script>
<script>
    $(function () {
        //右上角分享
        $(".J__btnShare").on("click", function () {
            $(".pop__wx-share").fadeIn(200);
        });
        $(".pop__wx-share").on("click", function () {
            $(this).fadeOut(200);
        });
    });
</script>
