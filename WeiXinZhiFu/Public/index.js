var pay_type = 1;
var redId = 0;
var order_price = 0;
var additional_price = 0;
var order_sumprice = 0;
var redPriceLimit = 0;
var redPrice = 0;

var el = 'mainMoney';
/**
 * 获取URL中的参数
 * */
function GetRequest() {
    var url = location.search; //获取url中"?"符后的字串
    var theRequest = new Object();
    if (url.indexOf("?") != -1) {
        var str = url.substr(1);
        strs = str.split("&");
        for (var i = 0; i < strs.length; i++) {
            theRequest[strs[i].split("=")[0]] = (strs[i].split("=")[1]);
        }
    }
    return theRequest;
}
var Request = new Object();
Request = GetRequest();

/**
 * 小数点的乘法
 * */
function accMul(arg1,arg2){
    var m=0,s1=arg1.toString(),s2=arg2.toString();
    try{m+=s1.split(".")[1].length}catch(e){}
    try{m+=s2.split(".")[1].length}catch(e){}
    return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m).toFixed(2);
}

/**
 * 检测输入的金额是否正确
 * */
function checkPrice (value,type){
    var reg= /^[+-]?[1-9]?[0-9]*\.[0-9]*$/  , reg1 =  /^[0-9]*[1-9][0-9]*$/ ; // reg 为小数 ，reg1为正整数
    if(!reg1.test(value) && !reg.test(value) && value!=='0'){ // 不是正整数也不是小数
        return false;
    }else if((reg.test(value) && value.split(".")[1].length > 2) || (value*1 < 0.01 && type==2) || (reg.test(value) && value.split(".")[1].length == 0 )){ // 小数点后面最多2位
        return false;
    }
    return true;
}

/**
 * 检测输入的金额是否正确
 * @param  key  输入的内容
 * */
function validatePrice (key){
    var value = $("#"+el).text() , checkMoney = value.split("");
    if(
        (checkMoney.indexOf(".") > -1 && key == '.') // 判断是否输入了2个‘.’
        ||
        (checkMoney.length === 0 && key == '.') // 判断第一个是否是‘.’
        ||
        (checkMoney[0] == '0' && checkMoney.length === 1 && key != '.') // 判断开始是否连续输入了两个0
        ||
        ((value + key).split(".")[1] && (value + key).split(".")[1].length > 2) // 限制小数点后最多2位
        ||
        (el == 'subMoney' && ($("#mainMoney").text()*1 < ($("#subMoney").text() + key)*1))// 限制 不参与优惠金额不能超过消费总额，不然不给输入
    ){
        return false
    }
    return true;
}

/**
 * 点击了数字按钮，在符合金额条件的情况下，金额进行累加
 * */
function keyClickNumber(val){
    var value = $("#"+el).text();
    if(value.length < 7 && validatePrice(val)){
        var afterVal = value + val;
        $("#"+el).text(afterVal);
    }
}

function decimal(num,v)  
{  
    var vv = Math.pow(10,v);  
    return Math.round(num*vv)/vv;  
}   

function countPrice(){
	order_price = parseFloat($('#mainMoney').text()?$('#mainMoney').text():'0');
    additional_price = parseFloat($('#subMoney').text()?$('#subMoney').text():'0');
    var max_discount = parseFloat($('#max-discount').attr('val')||'0');
    // var order_sumprice = 0;
    if(order_price<additional_price){
    	additional_price = 0;
    	$('#subMoney').text('');
    	// $('#subMoney').text('');
    	errorMsg('消费总额不能小于不享优惠金额');
    	// 重置不参与优惠金额
        $('#subMoney').text('');
        $('#subMoney').prev().css('display','initial');
        $('#subMoney').removeClass('hide').addClass('hide');
    }
    order_sumprice = decimal(accMul((order_price - additional_price),accMul(parseFloat(returnArr['discount']),0.1)),2)+additional_price;
    var discount_money = (order_price - order_sumprice).toFixed(2);
    // 最高优惠
    if (max_discount > 0 && discount_money > max_discount){
        discount_money = max_discount;
        order_sumprice = decimal(order_price - max_discount,2);
    }
    if(redId>0 && redPrice>0 && order_price >= redPriceLimit){
    	order_sumprice = (order_sumprice - redPrice).toFixed(2)>0?(order_sumprice - redPrice).toFixed(2):0.01;
    }else{
    	if(redId>0){
    		layer.msg("红包限制金额不满足");
    		$('.x-slide-list li').each(function(){
        		if($(this).data('redid')==0){
        			$(this).trigger('click');
        		}
        	});
    	}    	
    }
    order_sumprice = wipingZero(order_sumprice);
    order_sumprice = parseFloat(order_sumprice).toFixed(2);

    // $('#actualPay').text(order_sumprice <= 0 ? '0.00' : order_sumprice);
    $('#confirmPay').text("确认买单 ￥" + (order_sumprice <= 0 ? '0.00' : order_sumprice));
    if(returnArr['discount'] != 10 && discount_money>0){
    	$('.discountMoney').text("￥ -"+discount_money).removeClass('hide');
    }else{
    	$('.discountMoney').addClass('hide');
    }
}

function wipingZero(order_sumprice) {
    switch(auto_wiping_zero) {
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

function setRed(){
	redId = 0;
	redPriceLimit = 0;
	redPrice = 0;
	$('.redStr').addClass('hide');
	countPrice();
	if((returnArr.redList[1].length>1 && pay_type==1) || (returnArr.redList[3].length>1 && pay_type==3)){
		$('#haveRed').text('选择红包').attr('havered',1);
		$('.x-arrow-icon').removeClass('hide');
	}else{
		$('#haveRed').text('您没有可用红包').attr('havered',0);
		$('.x-arrow-icon').addClass('hide');
	}
}

function errorMsg(msg){
	$('#errorMsg').text(msg);
	$("#errorMoney").addClass("x-mask-show");
}

function selectRed(e) {
    redId = $(e).data('redid');
	if(order_price<=0 && redId){
		layer.msg("请输入消费总额");
		return false;
	}

	redPriceLimit = $(e).data('pricelimit');
	redPrice = $(e).data('price');
	console.log(redPriceLimit);
	console.log(redPrice);
	if(redId>0){
		$('.redStr').text("￥ -"+redPrice);
		$('.redStr').removeClass('hide');
	}else{
		$('.redStr').addClass('hide');
	}
	console.log(redId);
	countPrice();
	$('#redBag').removeClass('x-mask-show');
}

function closeCheckPopup() {
    $('.fade-mask').removeClass('is-visible');
}

function chooseWechat() {
    $confirmHandle.removeClass('sending');
    countPrice();
    $("#wechatRadio").click();
    $('#confirmPay').click();
    closeCheckPopup();

}

function pay() {
    $confirmHandle = $('#confirmPay');
    if ($confirmHandle.hasClass('sending')) {
        //loading && layer.close(loading);
        return false;
    }else{
        $confirmHandle.addClass('sending');
        countPrice();
        $('#confirmPay').text('提交订单中...');
    }

    // 判断输入的金额是否正确
    if(checkPrice($("#mainMoney").text(),2)){
        if(pay_type==3 && vipAmount<order_sumprice){
            $("#no-remaining").addClass("is-visible"); // 会员余额不足时候弹出
            $confirmHandle.removeClass('sending');
            // countPrice();
            return false;
        }
        if(pay_type==3){
            var loading=layer.load();
        }
        //发送post请求实际付款金额
        $.ajax({
            data: { "price": order_price, 'additional_price': additional_price, 'pay_type': pay_type,'red_id':redId },
            dataType: "json",
            type: 'POST',
            url: orderSaveUrl,
            beforeSend: function () {

            },
            success: function(data) {
                loading && layer.close(loading);
                if (!data.status) {
                    $confirmHandle.removeClass('sending');
                    countPrice();
                    $('.layer-tips').text(data.msg);
                    $('.layer-tips-box').show();
                    setTimeout(function(){//定时器
                        $(".layer-tips-box").hide();//将图片的display属性设置为none
                    }, 2000);
                }else{
                    if (typeof data.signature === 'object' && data.signature !== null){
                        WXSignature = data.signature;
                        orderDetailUrl = data.detail_url;
                        wakeupPaymentWindow();
                        $('#mainMoney').text('');
                        $('#subMoney').text('');
                    }else{
                        window.location.href = data.success_url;
                    }
                }
            }
        });
    }else{
        $confirmHandle.removeClass('sending');
        countPrice();
        layer.msg('输入金额不合法')
    }
}
/**
 * 逻辑方法
 * */
$(function(){

    /**
     * 选择输入的金额，是输入支付金额，还是不参与优惠金额
     * */
    $(".js-shamInput").on("click",function(){
        var that = $(this);
        el = that.attr("data-id");
        $(".x-input-cursor").addClass("hide");
        $("#"+el).next().removeClass("hide");
        $('#keyBoard').removeClass("x-mask-show").addClass('x-mask-show');
    });

    /**
     * 关闭所有弹出框
     * */
    $(".js-close").click(function(){
        $("#openVipService , #redBag , #noVipMoney ,#noVipService ,#errorMoney").removeClass("x-mask-show");
    });

    /**
     * 点击键盘，输入金额
     * */
    $(".js-key").on("touchstart",function(event){
        event.preventDefault();
        var key = $(this).attr("data-number"), // 输入额值
            oldMoney = $("#"+el).text(); // 之前的金额
        	var reg= /^[+-]?[1-9]?[0-9]*\.[0-9]*$/;
        	var reg1 =  /^[0-9]*[1-9][0-9]*$/ ;
        	 if(key == '×'){
                 $("#"+el).text(oldMoney.substring(0,oldMoney.length-1));
                 countPrice();
             }else if(key == 'down'){
                 $("#keyBoard").removeClass("x-mask-show"); // 关闭自定义键盘
                 $('.x-input-cursor').addClass("hide");;
                 countPrice();
                 $("#"+el).prev().hide();
             }else if(key == 'ok'){
                 $("#keyBoard").removeClass("x-mask-show"); // 关闭自定义键盘
                 $('.x-input-cursor').addClass("hide");
                 countPrice();
                 $("#"+el).prev().hide();
                 // pay();
             }else{
            	 /*if(reg.test(oldMoney) && oldMoney.split(".")[1].length == 2){
             		return false;
             	}
             	if(reg1.test(oldMoney) && oldMoney.split(".")[0].length == 8 && key !=='.'){
             		return false;
             	}
             	if(el == 'subMoney' && ($("#mainMoney").text()*1 < ($("#subMoney").text() + key)*1)) {
                    return false;
                }*/
                 keyClickNumber(key);
                 $("#"+el).removeClass("hide"); // 输入金额
                 countPrice();
                 $("#"+el).prev().hide();
             }

            //countPrice();
            if($("#"+el).text().length < 1) $("#"+el).prev().show(); // 当输入金额为空的时候，显示提示金额
    });

    /**
     * 点击清空消费总金额
     */
    $('#empty_sum').click(function (e) {
        e.stopPropagation();
        // 清空消费总额
        $('#mainMoney').text('');
        $('#mainMoney').removeClass('hide').addClass('hide');
        $('#mainMoney').prev().css('display','initial');
        // 重置实际支付
        // $('#actualPay').text('0.00');
        $('#confirmPay').text("确认买单");
        //
        el = 'mainMoney';
        // 重置折扣优惠
        $('.discountMoney').text('');
        // 重置不参与优惠金额
        $('#subMoney').text('');
        $('.x-input-cursor').removeClass('hide').addClass('hide');
        $('#mainMoney').next().removeClass('hide');
        $('#subMoney').prev().css('display','initial');
        $('#subMoney').removeClass('hide').addClass('hide');
    })

    /**
     * 不享优惠金额设置好后，
     * 点击确定，做校验
     * */
    /*$("#noDiscount").on('input', function(){
        if(checkPrice($("#noDiscount").val(),1)){
            $(".js-errSubMoney").addClass("hide");
            // 判断输入不享优惠金额 是否超过了总金额
            if($("#noDiscount").val()*1 > $("#mainMoney").text()*1){
                $("#noDiscount").val('');
                layer.msg('输入金额已超过消费<br>总额，请重新输入');
            }else{
                countPrice();
            }
        }else{
            $("#noDiscount").val('');
            layer.msg('请输入正确的金额');
        }
    });*/

    /**
     * 选择微信支付还是会员卡支付
     * */
    // 选择微信支付
    $("#wechatRadio").click(function(){
        $(this).addClass("active").next().removeClass("active");
        $("p[id*='showText']").addClass("hide");
        $("#showText1").removeClass("hide");
        pay_type=1;
        setRed();
    });
    // 选择会员支付
    $("#vipRadio").click(function(){
    	if(returnArr.storeStatus){
    		if(returnArr.vipSatatus){
    			$(this).addClass("active").prev().removeClass("active");
                $("p[id*='showText']").addClass("hide");
                $("#showText2").removeClass("hide");
                pay_type=3;
                setRed(); 
    		}else{
    			$("#openVipService").addClass("x-mask-show"); // 提示是否进行激活会员
    		}
    		
    	}else{
    		$("#noVipService").addClass("x-mask-show"); // 没有会员服务时候弹出
    	}

    });

    /**
     * 打开红包选择 弹出框
     * */
    $("#openRedBag").click(function(){
    	if($('#haveRed').attr('havered')=='0'){
    		return false;
    	}
    	var redStr = '';
    	if(pay_type==1){
    		for(var i=0;i<returnArr.redList[1].length;i++){
    			redStr+='<li onclick="javascript:selectRed(this)" data-redId="'+returnArr.redList[1][i]['key']+'" data-pricelimit="'+returnArr.redList[1][i]['price']+'" data-price="'+returnArr.redList[1][i]['discount_amount']+'"><span>'+returnArr.redList[1][i]['value']+'</span></li>'
    		}
    	}else{
    		for(var i=0;i<returnArr.redList[3].length;i++){
    			redStr+='<li onclick="javascript:selectRed(this)" data-redId="'+returnArr.redList[3][i]['key']+'" data-pricelimit="'+returnArr.redList[3][i]['price']+'" data-price="'+returnArr.redList[3][i]['discount_amount']+'"><span>'+returnArr.redList[3][i]['value']+'</span></li>'
    		}
    	}
    	$('.x-slide-list').html(redStr);
        $("#redBag").addClass("x-mask-show");
        
    });

    /*$(document).on("click", ".x-slide-list li", function() {
	if(order_price<=0){
		layer.msg("请输入订单金额");
		return false;
	}
	redId = $(this).data('redid');
	redPriceLimit = $(this).data('pricelimit');
	redPrice = $(this).data('price');
	console.log(redPriceLimit);
	console.log(redPrice);
	if(redId>0){
		$('.redStr').text("￥ -"+redPrice);
		$('.redStr').removeClass('hide');
	}else{
		$('.redStr').addClass('hide');
	}
	console.log(redId);
	countPrice();
	$('#redBag').removeClass('x-mask-show');
});*/
    
    /**
     * 最后 确认买单
     * */
    $("#confirmPay").click(function(){
        pay();
    });
    
    $(document).on('click',function(e){
        if(e.target.className.indexOf("item") === -1 && e.target.className != "x-sham-input js-shamInput" && e.target.className != "is-empty" && e.target.className.indexOf("x-submit-btn") === -1){
            var xId = $("#keyBoard").attr("data-id");// 哪个模拟输入框 召唤了自定义键盘
            // $("#"+xId).next(".x-input-cursor").addClass("hide"); // 把输入光标隐藏
            // $("#keyBoard").removeClass("x-mask-show");
            countPrice();
        }
        return true;
    });
});
