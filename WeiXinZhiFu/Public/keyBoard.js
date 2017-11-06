
    /**
    * 初始化 抹零规则： 0-不自动抹零， 1-自动抹零到元， 2-自动抹零到角， 3-四舍五入到元， 4-四舍五入到角
    * */
    var WXSignature = {};  
    var TradeNo = {};        
    var auto_wiping_zero = 0;
    var order_price = 0;
    var order_sumprice = 0;
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
            url: url, //请求地址
            type: method, //请求方式
            data: data, //请求参数
            dataType: "json",
            success: function (response) {
                // 此处放成功后执行的代码
                var resultData = JSON.parse(response);
                callback(resultData);
            },
            fail: function (status) {
                // 此处放失败后执行的代码
                console.log("ajax执行失败");
                console.log(status);
            }
        });
    }
    function ajax(options) {
        options = options || {};
        options.type = (options.type || "GET").toUpperCase();
        options.dataType = options.dataType || "json";
        //创建 - 非IE6 - 第一步
        if (window.XMLHttpRequest) {
            var xhr = new XMLHttpRequest();
        } else { //IE6及其以下版本浏览器
            var xhr = new ActiveXObject('Microsoft.XMLHTTP');
        }

        //接收 - 第三步
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

        //连接 和 发送 - 第二步
        if (options.type == "GET") {
            xhr.open("GET", options.url + "?" + formatParams(options.data), true);
            xhr.setRequestHeader("token", store.state.userInfo.token);
            xhr.send(JSON.stringify(options.data));
        } else if (options.type == "POST") {
            xhr.open("POST", options.url, true);
            //设置表单提交时的内容类型
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.setRequestHeader("token", store.state.userInfo.token);
            xhr.send(JSON.stringify(options.data));
        }
    }
    function formatParams(data) {
        //格式化参数
        var arr = [];
        for (var name in data) {
            arr.push(encodeURIComponent(name) + "=" + encodeURIComponent(data[name]));
        }
        arr.push(("v=" + Math.random()).replace(".", ""));
        return arr.join("&");
    }
    function keyClickNumber(val) {
        var value = $("#mainMoney").text();
        if (value.length < 11 && validatePrice(val)) {
            var afterVal = value + val;
            $("#mainMoney").text(afterVal);
        }
    }
    function validatePrice(key) {
        var value = $("#mainMoney").text(), checkMoney = value.split("");
        if (
            (checkMoney.indexOf(".") > -1 && key == '.') // 判断是否输入了2个‘.’
            ||
            (checkMoney.length === 0 && key == '.') // 判断第一个是否是‘.’
            ||
            (checkMoney[0] == '0' && checkMoney.length === 1 && key != '.') // 判断开始是否连续输入了两个0
            ||
            ((value + key).split(".")[1] && (value + key).split(".")[1].length > 2) // 限制小数点后最多2位
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
        var reg = /^[+-]?[1-9]?[0-9]*\.[0-9]*$/, reg1 = /^[0-9]*[1-9][0-9]*$/; // reg 为小数 ，reg1为正整数
        if (!reg1.test(value) && !reg.test(value) && value !== '0') { // 不是正整数也不是小数
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
                    location.href = "/WeiXinZhiFu/paysuc.aspx?id=" + TradeNo; //支付成功跳转界面 
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
            //发送post请求实际付款金额 1表示微信支付的操作
            $.ajax({
                data: { "price": order_sumprice, 'openid': $("#openid").val(), weixinid: $("#weixinid").val(), hname: $(".store-name")[0].innerText, hid: $("#hid").val() },
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
    $(function(){
        $(document).on('click', function (e) {
            if (e.target.className.indexOf("item") === -1 && e.target.className != "x-sham-input js-shamInput" && e.target.className != "is-empty" && e.target.className.indexOf("x-submit-btn") === -1) {
                var xId = $("#keyBoard").attr("data-id"); // 哪个模拟输入框 召唤了自定义键盘
                countPrice();
            }
            return true;
        });
        $(".js-shamInput").on("click", function () {
            var that = $(this);
            el = that.attr("data-id");
            $(".x-input-cursor").addClass("hide");
            $("#mainMoney").next().removeClass("hide");
            $('#keyBoard').removeClass("x-mask-show").addClass('x-mask-show');
        });
        $("#confirmPay").click(function () {pay();});
        $(".js-key").on("touchstart", function (event) {
            event.preventDefault();
            var key = $(this).attr("data-number"), // 输入额值
                oldMoney = $("#mainMoney").text(); // 之前的金额
            var reg = /^[+-]?[1-9]?[0-9]*\.[0-9]*$/;
            var reg1 = /^[0-9]*[1-9][0-9]*$/;
            if (key == '×') {
                $("#mainMoney").text(oldMoney.substring(0, oldMoney.length - 1));
								
                countPrice();
            } else if (key == 'down') {
//              $("#keyBoard").removeClass("x-mask-show"); // 关闭自定义键盘
//              $('.x-input-cursor').addClass("hide"); ;
								$(".weixinzhifu-page").hide();
                countPrice();
                $("#mainMoney").prev().hide();
            } else if (key == 'ok') {
//              $("#keyBoard").removeClass("x-mask-show"); // 关闭自定义键盘
//              $('.x-input-cursor').addClass("hide");
								$(".weixinzhifu-page").hide();
                countPrice();
                $("#mainMoney").prev().hide();
            } else {
                keyClickNumber(key);
                $("#mainMoney").removeClass("hide"); // 输入金额
                countPrice();
                $("#mainMoney").prev().hide();
            }
            if ($("#mainMoney").text().length < 1) $("#mainMoney").prev().show(); // 当输入金额为空的时候，显示提示金额
        });
        $('#empty_sum').click(function (e) {
            e.stopPropagation();
            // 清空消费总额
            $('#mainMoney').text('');
            $('#mainMoney').removeClass('hide').addClass('hide');
            $('#mainMoney').prev().css('display', 'initial');
            // 重置实际支付
            $('#confirmPay').text("微信买单 ￥0.00");
            $('.x-input-cursor').removeClass('hide').addClass('hide');
            $('#mainMoney').next().removeClass('hide');
        });
    })
