<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Fastcollection.aspx.cs" Inherits="hotel3g.WeiXinZhiFu.Fastcollection" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><%=subname%>&shy;</title>
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
    <meta name="Keywords" content="" />
    <meta name="Description" content="" />
    <!-- Mobile Devices Support @begin -->
    <meta content="application/xhtml+xml;charset=UTF-8" http-equiv="Content-Type">
    <meta content="no-cache,must-revalidate" http-equiv="Cache-Control">
    <meta content="no-cache" http-equiv="pragma">
    <meta content="0" http-equiv="expires">
    <meta content="telephone=no, address=no" name="format-detection">
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <!-- apple devices fullscreen -->
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
    <!-- Mobile Devices Support @end -->
    <link rel="stylesheet" href="/WeiXinZhiFu/Public/style.css?v=20170308" type="text/css" />
    <script type="text/javascript" src="/WeiXinZhiFu/Public/jquery-1.10.2.min.js?v=20170308"></script>
    <script type="text/javascript" src="/WeiXinZhiFu/Public/template-native.js?v=20170308"></script>
    <script type="text/javascript" src="/WeiXinZhiFu/Public/LifeCircle.js?v=20170308"></script>
    <link rel="stylesheet" href="/WeiXinZhiFu/Public/base.css?v=20170308" />
    <style>
        a[target=_blank][title='站长统计']{display: none;}
        .store-info-unregister {
            background-color: #fff;
            text-align: center;
            border-bottom: 11.5px solid #f5f5f9;
        }
        .store-info-unregister .store-name {
            width: 100%;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            padding: 25px 0 10px;
            font-size: 19px;
            color: rgba(25,25,30,0.8);
        }   
        input::-webkit-input-placeholder { /* WebKit browsers */  
            color:    #999;  
        }  
        .sending{background:rgb(176, 163, 163)!important;}                 
    </style>
</head>
<body onselectstart="return true;" ondragstart="return false;" style="-webkit-user-select:none;-moz-user-select:none;-o-user-select:none;user-select:none;">    
  <%  if (!string.IsNullOrEmpty(WeiXinID)){%>   
    <input type="hidden" name="weixinid" id="weixinid" value="<%=WeiXinID%>" />
    <input type="hidden" name="hid" id="hid" value="<%=hid%>" />
    <input type="hidden" name="code" id="code" value="<%=code%>" />
    <input type="hidden" name="state" id="state" value="<%=state%>" />
    <section class="x-container" style="padding-bottom: 2.4rem;">     
        <div class="x-module-title">
            <span>支出总金额(元)</span>
            <span class="store-name" style=" display:none;"><%=subname%></span>
        </div>
        <!-- 价格输入 start -->
        <div class="x-item">
           <div class="x-money-box" style="border-bottom: 1px solid #f4f5f9;">
               <span style="font-size: 0.25rem;">￥</span>
               <div class="x-sham-input js-shamInput" data-id="mainMoney" style="line-height: 1;"> &nbsp;<!-- 模拟的input -->
                   <!-- 当没有输入金额的时候，显示这个div -->
                   <span class="is-empty" style="top: 2px;left :8px;font-family: 'Arial';font-weight: normal;">0.00</span>
                   <!-- 当输入了金额的时候，显示这个div -->
                   <span id="mainMoney" class="hide" style="position: relative;left: -18px;font-family: 'Arial';font-weight: normal;"></span>
                   <!-- 输入光标 -->
                   <i class="x-input-cursor" style="border-right: 1px solid #020202;display: inline-flex;height: .35rem;margin-left: -.28rem"></i>
               </div>
               <i class="empty-icon" id="empty_sum"></i>
            </div>
        </div>
        <!-- 价格输入 end -->
        <div id="setSubMoney" class="x-des-title">
            <div class="x-money-box" style="padding: 0;width: 100%;border: none;">
                <div class="x-sham-input js-shamInput" data-id="subMoney" style="height: 35px;text-indent: 0;"><!-- 模拟的input -->
                    <!-- 当没有输入金额的时候，显示这个div -->
                    <!--<span class="is-empty" style="top: 2px;left :8px;font-family: 'Arial';font-weight: normal;font-size: .15rem;color: #d1d1d1;">添加备注信息（如姓名，房号，消费内容）</span> -->
                    <!-- 当输入了金额的时候，显示这个div -->
                    <!--<span class="x-input-value hide" id="subMoney" style="position: relative;left: 5px;top: -.34rem;font-family: 'Arial';font-weight: normal;font-size: .2rem;"></span> -->
                    <!-- 输入光标 -->
                    <!--<i class="x-input-cursor hide" style="position: relative;top: -.00rem;margin-left: -4px;"> &nbsp;</i>-->
                    <input type="text" placeholder="添加备注信息（如姓名，房号，消费内容）" name="subContent" id="subContent" style="    font-size: 12px;height: 31px;min-width: 93%;      border: 0;    -webkit-appearance: none;  padding: 0 5px;" >
                </div>
            </div>
        </div>
        <div class="x-pay-box">
            <div class="x-check-way">
                <a id="wechatRadio" class="x-btn x-check-btn x-wechat-btn  <% if(type=="0") {%>active <%} %>" href="pay.aspx?hid=<%=hid %>&type=0">客房消费</a>
                <a id="vipRadio" class="x-btn x-check-btn x-vip-btn <% if(type=="1") {%>active <%} %> " href="pay.aspx?hid=<%=hid %>&type=1">押金缴纳</a>
            </div>
            <p id="showText1" class="margin-top-5 <% if(type=="1") {%>hide <%} %>" style="color: #a9a6a6;">请与酒店人员核实支付金额~</p>
            <p id="showText2" class="margin-top-5 <% if(type=="0") {%>hide <%} %>" style="color: #a9a6a6;">押金缴纳，退房时可退还~</p>
        </div>
        <div class="x-item no-bg-color">
            <div class="x-btn-box">
                <a id="confirmPay" class="x-btn x-submit-btn" href="javascript:void(0)">微信买单 ￥0.00</a>
            </div>
        </div>
    </section>
    <!-- 金额错误提示框 start 加上x-mask-show显示-->
    <div id="errorMoney" class="x-mask-box">
        <div class="x-popup-box x-error-box scale-show">
            <p id="errorMsg">请输入订单金额</p>
            <div class="x-operat-box">
                <a class="x-btn x-confirm-btn js-confirm-btn js-close" href="javascript:void(0)">确认</a>
            </div>
        </div>
    </div>
    <!-- 金额错误提示框 end -->
    <!-- 自定义键盘 start 加上x-mask-show显示-->
    <div id="keyBoard" class="x-mask-box x-mask-show" data-id="mainMoney" style="z-index:9;background-color: rgba(0,0,0,0);height:auto;" v-cloak>
        <div class="x-slide-box pop-up-show">
            <div class="x-key-board">
                <div class="row">
                    <div class="item js-key" data-number="1">1</div>
                    <div class="item js-key" data-number="4">4</div>
                    <div class="item js-key" data-number="7">7</div>
                    <div class="item js-key" data-number=".">.</div>
                </div>
                <div class="row">
                    <div class="item js-key" data-number="2">2</div>
                    <div class="item js-key" data-number="5">5</div>
                    <div class="item js-key" data-number="8">8</div>
                    <div class="item js-key" data-number="0">0</div>
                </div>
                <div class="row">
                    <div class="item js-key" data-number="3">3</div>
                    <div class="item js-key" data-number="6">6</div>
                    <div class="item js-key" data-number="9">9</div>
                    <div class="item js-key no-border-right x-key-del" data-number="down" style="font-size: .15rem;height: .55rem!important;line-height: .55rem!important;">
                        <i class="keyboard-icon"></i>
                    </div>
                </div>
                <div class="row">
                    <div class="item no-border-right js-key x-key-del" data-number="×">
                        <i class="back-icon"></i>
                    </div>
                    <div class="item no-border-bottom js-key no-border-right x-key-ok" data-number="ok" id="confirm_pay">
                        <span style="line-height: 1.2; font-weight: 600; font-size: 18px;">确<br>定</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- 自定义键盘 end -->
    <!--提示框-->
    <div class="layer-tips-box">
        <span class="layer-tips">
        </span>
    </div>
</body>
<style>
    .layer-tips-box{
        position: fixed;
        z-index: 99;
        left:0;
        top:45%;
        width: 100%;
        text-align: center;
        display: none;
    }
    .layer-tips{
        display: inline-block;
        max-width: 90%;
        margin: 0 10%;
        padding: 10px 20px;
        color:#fff;
        background-color: rgba(0,0,0,0.6);
        border-radius: 3px; /* Opera 10.5+, 以及使用了IE-CSS3的IE浏览器 */
        -moz-border-radius: 3px; /* Firefox */
        -webkit-border-radius: 3px; /* Safari 和 Chrome */
    }
</style>
<script type="text/javascript" src="/WeiXinZhiFu/Public/jquery.js?v=20170308"></script>
<script type="text/javascript" src="/WeiXinZhiFu/Public/zepto.min.js?v=20170308"></script>
<script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="/Scripts/layer/layer.js"></script>
<script type="text/javascript">
    /**
    * 初始化 抹零规则： 0-不自动抹零， 1-自动抹零到元， 2-自动抹零到角， 3-四舍五入到元， 4-四舍五入到角
    * */
    var WXSignature = {};  
    var TradeNo = {};        
    var auto_wiping_zero = 0;
    var order_price = 0;
    var order_sumprice = 0;
    var pay_type = <%=type %>;
    if (typeof WeixinJSBridge == "undefined") {
        if (document.addEventListener) {
            document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
        } else if (document.attachEvent) {
            document.attachEvent('WeixinJSBridgeReady', onBridgeReady);
            document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
        }
    } else {onBridgeReady();}    
    function onBridgeReady() { wx.hideOptionMenu(); }
    function xAjax(url, method, data, callback) {
        ajax({
            url: url, 
            type: method,
            data: data, 
            dataType: "json",
            success: function (response) {
                var resultData = JSON.parse(response);
                callback(resultData);
            },
            fail: function (status) {
                console.log("ajax执行失败");
                console.log(status);
            }
        });
    }
    function ajax(options) {
        options = options || {};
        options.type = (options.type || "GET").toUpperCase();
        options.dataType = options.dataType || "json";
        if (window.XMLHttpRequest) {
            var xhr = new XMLHttpRequest();
        } else { 
            var xhr = new ActiveXObject('Microsoft.XMLHTTP');
        }
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4) {
                var status = xhr.status;
                if (status >= 200 && status < 300) {
                    options.success && options.success(xhr.responseText, xhr.responseXML);
                } else {
                    options.fail && options.fail(status);
                }
            }
        }
        if (options.type == "GET") {
            xhr.open("GET", options.url + "?" + formatParams(options.data), true);
            xhr.setRequestHeader("token", store.state.userInfo.token);
            xhr.send(JSON.stringify(options.data));
        } else if (options.type == "POST") {
            xhr.open("POST", options.url, true);
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.setRequestHeader("token", store.state.userInfo.token);
            xhr.send(JSON.stringify(options.data));
        }
    }
    function formatParams(data) {
        var arr = [];
        for (var name in data) {
            arr.push(encodeURIComponent(name) + "=" + encodeURIComponent(data[name]));
        }
        arr.push(("v=" + Math.random()).replace(".", ""));
        return arr.join("&");
    }
    function keyClickNumber(val) {
        var value = $("#mainMoney").text();
        if (value.length < 7 && validatePrice(val)) {
            var afterVal = value + val;
            $("#mainMoney").text(afterVal);
        }
    }
    function validatePrice(key) {
        var value = $("#mainMoney").text(), checkMoney = value.split("");
        if (
            (checkMoney.indexOf(".") > -1 && key == '.') 
            ||
            (checkMoney.length === 0 && key == '.') 
            ||
            (checkMoney[0] == '0' && checkMoney.length === 1 && key != '.') 
            ||
            ((value + key).split(".")[1] && (value + key).split(".")[1].length > 2) 
        ){return false}
        return true;
    }
    function wipingZero(order_sumprice) {
        switch (auto_wiping_zero) {
            case 0:
                return order_sumprice;
                break;
            case '1':
                return Math.floor(order_sumprice);
                break;
            case '2':
                return (Math.floor(order_sumprice * 10)) / 10;
                break;
            case '3':
                return Math.round(order_sumprice);
                break;
            case '4':
                return (Math.round(order_sumprice * 10)) / 10;
                break;
        }
    }
    function countPrice() {
        order_price = parseFloat($('#mainMoney').text() ? $('#mainMoney').text() : '0');
        order_sumprice = wipingZero(order_price);
        order_sumprice = parseFloat(order_price).toFixed(2);
        $('#confirmPay').text("确认买单 ￥" + (order_sumprice <= 0 ? '0.00' : order_sumprice));
    }
    function errorMsg(msg) {
        $('#errorMsg').text(msg);
        $("#errorMoney").addClass("x-mask-show");
    }
    function checkPrice(value, type) {
        var reg = /^[+-]?[1-9]?[0-9]*\.[0-9]*$/, reg1 = /^[0-9]*[1-9][0-9]*$/; 
        if (!reg1.test(value) && !reg.test(value) && value !== '0') { 
            return false;
        } else if ((reg.test(value) && value.split(".")[1].length > 2) || (value * 1 < 0.01 && type == 2) || (reg.test(value) && value.split(".")[1].length == 0)) { // 小数点后面最多2位
            return false;
        }
        return true;
    }
    function wakeupPaymentWindow() {
        WeixinJSBridge.invoke(
            'getBrandWCPayRequest', WXSignature,
            function (res) {
                WXSignature = {};
                if (res.err_msg == "get_brand_wcpay_request:ok") {
                    location.href = "/WeiXinZhiFu/paysuc.aspx?id=" + TradeNo; 
                    return false;
                }
            }
        );
        $confirmHandle.removeClass('sending');
        countPrice();
    }    
    function pay() {
        $confirmHandle = $('#confirmPay');
        if ($confirmHandle.hasClass('sending')) {return false;} else {$confirmHandle.addClass('sending');countPrice();$('#confirmPay').text('提交订单中...');}
        if (checkPrice($("#mainMoney").text(), 2)) {
            $.ajax({
                data: { "price": order_sumprice, 'state': $("#state").val(), 'code': $("#code").val(), weixinid: $("#weixinid").val(), hname: $(".store-name")[0].innerText, hid: $("#hid").val(), type: pay_type, subContent: $("#subContent").val() },
                dataType: "json",
                type: 'POST',
                url: "/WeiXinZhiFu/Fastcollection.aspx",
                beforeSend: function () {

                },
                success: function (ty) {
                    var data = eval('(' + ty + ')');
                    var signature=eval('(' + data.signature + ')');
                    if (!data.status) {
                        $confirmHandle.removeClass('sending');
                        countPrice();
                        $('.layer-tips').text(data.msg);
                        $('.layer-tips-box').show();
                        setTimeout(function () { $(".layer-tips-box").hide(); }, 2000);
                    } else {
                        if (typeof signature === 'object' && signature !== null) {
                            WXSignature = signature;
                            TradeNo = data.TradeNo;
                            wakeupPaymentWindow();
                        } else {
                            $confirmHandle.removeClass('sending');
                            countPrice();
                            layer.msg('支付失败！');
                        }
                    }
                }
            });
        }else{
            $confirmHandle.removeClass('sending');
            countPrice();
            layer.msg('输入金额不合法');
        }
    }
    $(function () {
        $(document).on('click', function (e) {
            if (e.target.className.indexOf("item") === -1 && e.target.className != "x-sham-input js-shamInput" && e.target.className != "is-empty" && e.target.className.indexOf("x-submit-btn") === -1) {
                var xId = $("#keyBoard").attr("data-id");
                countPrice();
            }
            return true;
        });
        $(".js-shamInput").on("click", function () {
            var that = $(this);
            el = that.attr("data-id");
            $(".x-input-cursor").addClass("hide");
            $("#" + el).next().removeClass("hide");
            if (el == "subMoney") 
                $('#keyBoard').removeClass("x-mask-show");
            else 
                $('#keyBoard').removeClass("x-mask-show").addClass('x-mask-show');            
        });
        $("#confirmPay").click(function () { pay(); });
        $(".js-key").on("touchstart", function (event) {
            event.preventDefault();
            var key = $(this).attr("data-number"),
                oldMoney = $("#mainMoney").text();
            var reg = /^[+-]?[1-9]?[0-9]*\.[0-9]*$/;
            var reg1 = /^[0-9]*[1-9][0-9]*$/;
            if (key == '×') {
                $("#mainMoney").text(oldMoney.substring(0, oldMoney.length - 1));
                countPrice();
            } else if (key == 'down') {
                $("#keyBoard").removeClass("x-mask-show");
                $('.x-input-cursor').addClass("hide"); ;
                countPrice();
                $("#mainMoney").prev().hide();
            } else if (key == 'ok') {
                $("#keyBoard").removeClass("x-mask-show");
                $('.x-input-cursor').addClass("hide");
                countPrice();
                $("#mainMoney").prev().hide();
            } else {
                keyClickNumber(key);
                $("#mainMoney").removeClass("hide");
                countPrice();
                $("#mainMoney").prev().hide();
            }
            if ($("#mainMoney").text().length < 1) $("#mainMoney").prev().show();
        });
        $('#empty_sum').click(function (e) {
            e.stopPropagation();
            $('#mainMoney').text('');
            $('#mainMoney').removeClass('hide').addClass('hide');
            $('#mainMoney').prev().css('display', 'initial');
            $('#confirmPay').text("微信买单 ￥0.00");
            $('.x-input-cursor').removeClass('hide').addClass('hide');
            $('#mainMoney').next().removeClass('hide');
        });
//        $("#wechatRadio").click(function () {
//            $(this).addClass("active").next().removeClass("active");
//            $("p[id*='showText']").addClass("hide");
//            $("#showText1").removeClass("hide");
//            pay_type = 0;
//        });
//        $("#vipRadio").click(function () {
//            $(this).addClass("active").prev().removeClass("active");
//            $("p[id*='showText']").addClass("hide");
//            $("#showText2").removeClass("hide");
//            pay_type = 1;
//        });
    })
</script>
<%} %>
<script type="text/javascript">
    var ua = navigator.userAgent.toLowerCase();
    var isWeixin = ua.indexOf('micromessenger') != -1;
    var isAndroid = ua.indexOf('android') != -1;
    var isIos = (ua.indexOf('iphone') != -1) || (ua.indexOf('ipad') != -1);
    if (!isWeixin && window.location.href.indexOf("localhost")<0) {
        document.head.innerHTML = '<title>抱歉，出错了</title><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0"><link rel="stylesheet" type="text/css" href="https://res.wx.qq.com/open/libs/weui/0.4.1/weui.css">';
        document.body.innerHTML = '<div class="weui_msg"><div class="weui_icon_area"><i class="weui_icon_info weui_icon_msg"></i></div><div class="weui_text_area"><h4 class="weui_msg_title">请在微信客户端打开链接</h4></div></div>';
    }
</script>
</html>