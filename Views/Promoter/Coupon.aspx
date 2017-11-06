<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">--%>
<!DOCTYPE html>
<%
    string Money = ViewData["hongbao"] as string;

    hotel3g.Repository.HotelInfoItem HotelInfo =
     ViewData["HotelInfo"] as hotel3g.Repository.HotelInfoItem;
%>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8" />
    <title>领取红包</title>
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <link rel="stylesheet" href="../../css/booklist/sale-date.css"></link>
    <link rel="stylesheet" href="../../css/booklist/mend-reset.css" />
    <link rel="stylesheet" href="../../css/booklist/mend-weikeniu.css" />

    <script src="../../Scripts/jquery-1.8.0.min.js"></script>
    <script src="../../Scripts/fontSize.js"></script>

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
<% if (!string.IsNullOrEmpty(Money))
   { %>

          <script src="../../Scripts/layer/layer.js" type="text/javascript"></script>
                <script>
                    $(function () {

                        var hid = '<%=ViewData["hid"] %>';
                        var memberid = '<%=ViewData["memberid"] %>';
                        var weixinid = '<%=ViewData["WeiXinID"] %>';

                        $("#subinfo").click(function () {
                            var tel = $("#tel").val();

                            var re = /^1\d{10}$/;
                            if (!re.test(tel)) { layer.msg('请填写正确的手机号码！'); return; }



                            if (tel != '' && hid != '' && memberid != '' && weixinid != '') {
                                var success = '/Promoter/CouponDeatil?hid=' + hid + '&tel=' + tel + '&weixinid=' + weixinid + '&id=<%=ViewData["memberid"] %>';
                                jsonArryPush(tel, success);
                                var prem = { hid: hid, tel: tel, memberid: memberid, weixinid: weixinid };
                                var url = '/Promoter/GetCoupon';
                                $.post(url, prem, function (data, status) {
                                    var status = data.status;
                                    if (status > 0) {
                                        jsonArryPush(tel, null);

                                        window.location.href = success;
                                    } else {
                                        alert(data.msg);
                                    }
                                });
                            }


                        });
                        var weixinid = '<%=ViewData["WeiXinID"] %>';
                        var logname = weixinid + memberid;
                        var storage = window.localStorage;



                        //检查缓存是否存在记录
                        function jsonArryPush(tel, url) {
                            var json = storage.getItem(logname);
                            jsonArry = null;
                            if (json == null || json == 'null' || json == '') {
                                jsonArry = [];
                            } else {
                                jsonArry = JSON.parse(json);
                            }
                            var has = $.inArray(tel, jsonArry);
                            if (has < 0 && url != null) {
                                jsonArry.push(tel);
                                var json = JSON.stringify(jsonArry);
                                storage.setItem(logname, json);
                            } else {
                                if (url != null) {
                                    $("#tishi_msg").text("您已经领取过此红包了");
                                    $("#alertmsg").show();
                                    //window.location.href = url;
                                    return;
                                }
                            }
                        }

                        var LOG = storage.getItem(logname);

                        if (LOG != null && LOG != "") {
                            var tel = eval(LOG)[0];
                            if (tel != '') {
                                var success = '/Promoter/CouponDeatil?hid=' + hid + '&tel=' + tel + '&weixinid=' + weixinid + '&id=<%=ViewData["memberid"] %>';
                                window.location.href = success;
                                //                    $("#tishi_msg").text("存在领取记录");
                                //                    $("#alertmsg").show();
                            }
                        }

                        $("#tishi_close").click(function () {
                            $("#alertmsg").hide();
                        });
                    });
    </script>

<body class="bg--6b0cae">
    <%
        hotel3g.Repository.MemberCard UserInfo =
               ViewData["UserInfo"] as hotel3g.Repository.MemberCard;
	        %>
         

    <!-- <>红包推广 -->
    <div class="pg__hbPromotion clearfix">
        <!-- //二维码 -->
        <div class="hb__qrcode">
            <!--<img src="../images/icon__hb-qrcode.png" />-->
            <div class="qrcode">
                <div class="bg">
                    <h5>
                        关注酒店，更多优惠</h5>
                    <img src="<%=ViewData["Logo"] %>">
                </div>
            </div>
            <h2 class="tit2">
                <em>
                    <%=HotelInfo.SubName %></em>
            </h2>
            <h3 class="desc2">
                <em>
                    <%=ViewData["info"] %></em>
            </h3>
        </div>
        <!--//文字提示-->
        <div class="hb__msgTips flexbox clearfix">
            <img class="uimg" src="<%=UserInfo.photo %>" />
            <div class="msgbox flex1">
                <i class="arr"></i><i class="arr arr2"></i><span class="txt">嗨~我是<%=UserInfo.nickname%>，这是我家酒店，送你一个红包，要快领取哦~~！</span>
            </div>
        </div>
        <!--//领取红包-->
        <div class="hb__receive">
            <h2 class="amount">
                ￥<%=ViewData["hongbao"]%></h2>
            <input class="ipt-text" type="tel" name="telphone" id="tel" placeholder="请输入手机号码" />
            <a class="btn-receive" href="javascript:;" id="subinfo">领取</a>
        </div>
    </div>
  <!--弹窗-->
	    <section class="mask alert" id="alertmsg">
		    <div class="inner yu-w480r">
			    <div class="yu-bgw">
				    <p class="yu-lrpad40r yu-tbpad50r yu-textc yu-bor bbor yu-f30r" id="tishi_msg">请您输入必填信息</p>
				    <div class="yu-h80r yu-l80r yu-textc yu-c40 yu-f36r yu-grid">
					    <%--<p class="yu-overflow yu-bor rbor yu-c99">确定</p>--%>
					    <p class="yu-overflow mask-close" id="tishi_close">好的，知道了</p>
					
				    </div>
			    </div>
		    </div>
	    <section>


</body>
<%}
   else
   { %>
<body>
    页面不见了
</body>
<%} %>
</html>
