var couponjson = {};
var orderjson = {};
var phonenumberAry = [1];

function fetchorder() {
    orderjson = $.parseJSON(sys_orderjson);

    fetchlasttime();
    if (orderjson['room']['ConPons'] == 1) {
        fetchcouponlist();
    }
    fetchdemolist();

    //    $('.days').text(orderjson['days']);
    //    $('#indate').text(getdatestr(orderjson['indate']));
    //    $('#outdate').text(getdatestr(orderjson['outdate']));
    //    $('.breakfast').text(orderjson['rateplan']['ZaoCan']);
    //    var area = '--';
    //    if (orderjson['room']['Area'] != '0') {
    //        area = orderjson['room']['Area'].toString();
    //        if (area.indexOf('平方米') > -1) {
    //            area = area.replace('平方米', '㎡');
    //        } else if (area.indexOf('平方') > -1) {
    //            area = area.replace('平方', '㎡');
    //        } else {
    //            area += '㎡';
    //        }
    //    }
    //    $('.area').text(area);
    //    $('.nettype').text(orderjson['room']['NetType']);
    //    var floor = '--';
    //    if (orderjson['room']['Floor'] != '0') {
    //        floor = orderjson['room']['Floor'].toString();
    //    }
    //    $('.floor').text(floor);
    //    var bedtype = orderjson['room']['BedType'];
    //    if (bedtype == '') {
    //        bedtype = '--';
    //    }
    //    $('.bedtype').text(bedtype);
    //    $('.addbed').text(orderjson['room']['AddBed']);
    //    var paystr = '在线支付';
    //    var savestr = '去支付';
    //    // 0 预付     1 现付
    //    if (orderjson['rateplan']['PayType'] == 0) {
    //        $('#marklist .jishi').show();
    //        $('#marklist .prepay').show();
    //        var foregift = parseInt(orderjson['room']['Foregift']);
    //        if (foregift > 0) {
    //            $('.foregift').text(foregift);
    //            $('#foregiftselect').closest('dl').show();
    //        }
    //    } else {
    //        paystr = '到店支付';
    //        savestr = '提交';
    //        $('#marklist .jishi').show();
    //        $('#marklist .facepay').show();
    //    }
    //    $('.paystr').text(paystr);
    //    $('#save').val(savestr);

    //    if (orderjson['rateplan']['IsHourRoom'] == 1) {
    //        $('#lasttime').closest('dl').find('dt').text('使用时段');
    //        $('#lasttimebox div:eq(0)').text('使用时段');
    //        $('#lasttimebox div:eq(1)').hide();
    //    }

    $('#lasttimebox div[lasttime]:first').trigger('click');
    //    $('#demolist div[demo]:first').trigger('click');
    //    $(".tsyq-over").trigger('click');
    //    $('.num-input span.jia').trigger('click');
    //    var roomname = orderjson['room']['RoomName'] + '-' + orderjson['rateplan']['RatePlanName'];
    //    if (orderjson['rateplan']['IsHourRoom'] == 1) {
    //        roomname = orderjson['room']['RoomName'] + '-' + orderjson['rateplan']['HourRoomType'] + '小时钟点房';
    //        $('.breakfast').text('--');
    //    }
    //    $('.roomname').text(roomname);
    calculatePrice();

}

function calculatePrice() {
    var roomnum = $('#roomnum').val()
    var saleprice = orderjson['price'];
    var discount = orderjson['discount'];
    var nights = parseInt($("#total_days").text());

    ShowHongbao((saleprice - discount * nights) * roomnum);

    var couponprice = parseInt($('#couponprice').text());
    var totalprice = (saleprice - discount * nights) * roomnum - couponprice;
    var discountprice = discount * nights * roomnum + couponprice;
    if (discountprice > 0) {
        $('.discountstr label').text(discountprice);
        $('.discountstr').show();
    }
    var foregift = parseInt($('#foregift').text());
    var actualprice = totalprice + foregift;
    $('#actualprice').text(actualprice);
    $('.actualprice').text(actualprice);
    $('#totalprice').text(totalprice);
    if (orderjson['MemberCardRule']['GradePlus'] > 0) {
        var memberpoints = parseInt(totalprice * orderjson['MemberCardRule']['GradePlus'] * orderjson['MemberCardRule']['equivalence']);
        $('.memberpoints').text(memberpoints);
        if (memberpoints > 0) {
            $('.memberpointsstr').show();
        }
    }

    var alloriginalprice = orderjson['price'] * roomnum;
    $('.alloriginalprice').text(alloriginalprice);
    if (orderjson['discount'] > 0) {

        if (orderjson['MemberCardRule']["CouponType"] == 0) {
            var graderate = (orderjson['MemberCardRule']['GradeRate'] * 10) / 100;
            var p = (orderjson['price'] - orderjson['discount'] * nights) * roomnum;
            $('.discountprice').text(alloriginalprice + ' * ' + graderate + '=￥' + p);
        }

        else {
            var reduceprice = orderjson['MemberCardRule']['Reduce'] * roomnum * nights;
            var p = (orderjson['price'] - orderjson['discount'] * nights) * roomnum;
            $('.discountprice').text(alloriginalprice + ' - ' + reduceprice + '=￥' + p);

        }

        $('.discountprice').closest('li').show();
        $('.alloriginalprice').closest('p').addClass('yu-linet');
    }
}

$(".show").on("click", function () {
    $(this).toggleClass("cur").parent().siblings(".hide").slideToggle();
})

//反回 M月D日 格式
function getdatestr(_date) {
    var date = new Date(_date);
    var month = date.getMonth() + 1;
    var day = date.getDate();
    var str = month.toString() + '月' + day.toString() + '日';
    return str;
}

$(function () {
    fetchorder();
    showphonenumber();

    $("#lb_gradename").text(orderjson['MemberCardRule']['GradeName']);

    if (orderjson['mobile'] != null && orderjson['mobile'] != undefined && orderjson['mobile'].length == 11) {

        var strmobileAry = orderjson['mobile'].split('');
        phonenumberAry = [];

        for (var i = 0; i < strmobileAry.length; i++) {
            phonenumberAry.push(parseInt(strmobileAry[i]));
        }
        showphonenumber();
        $('.phonenumber').val($('.number-bar .scrn-txt').text());
        $('.number-bar .submit').addClass("cur");
    }

    $("#usernamelist .sp:first").val(orderjson['username']);

    var phonenumber = $('.phonenumber').val();
    var username = $('#usernamelist .sp:first').val();
    if (phonenumber != '' && username != '') {
        // window.location.href = '/hotel/index/' + orderjson['room']['HotelID'] + '?key=' + sys_hotelWeixinid + '@' + sys_userWeixinid;
        return false;
    }
});

function comparedate(_firstdate, _seconddate) {
    var firstdate = new Date(_firstdate);
    var seconddate = new Date(_seconddate);
    if (firstdate.getYear() == seconddate.getYear() && firstdate.getMonth() == seconddate.getMonth() && firstdate.getDate() == seconddate.getDate()) {
        return true;
    }
    return false;
}

function fetchlasttime() {
    var ary = undefined;
    if (orderjson['rateplan']['IsHourRoom'] == 1) {
        ary = new Array();
        var now = new Date();
        var hour = now.getHours();
        var minute = now.getMinutes();
        var eHour = parseInt(orderjson['rateplan']['EndHour']) - parseInt(orderjson['rateplan']['HourRoomType']);
        var endhour = parseInt(orderjson['rateplan']['EndHour']);
        var starthour = parseInt(orderjson['rateplan']['StartHour']);
        var nottoday = false;
        if (!comparedate(now, orderjson['indate']) || starthour > hour) {
            hour = starthour;
            nottoday = true;

        } 

        var hourroomtype = parseInt(orderjson['rateplan']['HourRoomType']);
        if (eHour > hour || nottoday) {
            var hourindex = minute < 30 ? 0 : 1;
            if (nottoday) {
                hourindex = 0;
            }
            for (var i = hourindex; i <= eHour - hour; i++) {
                var _sthour = hour + i;
                var _enhour = _sthour + parseInt(orderjson['rateplan']['HourRoomType']);
                for (var j = 0; j < 2; j++) {
                    if (j == 0 && _sthour >= hour) {
                        if (nottoday || _sthour > hour) {
                            ary.push(_sthour + ':00-' + _enhour + ':00');
                        }

                    } else if (j == 1 && _enhour < endhour) {
                        ary.push(_sthour + ':30-' + _enhour + ':30');
                    }
                }
            }
        }
    } else {
        ary = ['18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '凌晨3点'];
    }
    var that = $('#lasttimebox .select-box');
    $('#lasttimebox .select-box div[lasttime]').remove();
    $('#lasttimebox div[lasttime]').unbind();
    $.each(ary, function (k, v) {
        var div = $('#lasttimebox .copy').clone(true).removeClass('copy');
        div.find('label').text(v);
        div.attr('lasttime', v);
        that.append(div);
        $('#lasttimebox div[lasttime]').bind('click', function () {
            var lasttime = $(this).attr('lasttime');
            $('#lasttime').text(lasttime);
            $(this).parents(".mask").fadeOut();
        });
    });
}

function fetchcouponlist() {
    var that = $('#couponlist .select-box');
    $('#couponlist .select-box div[couponid]').remove();
    if (orderjson['rateplan']['IsVip'] == 0) {
        $.ajax({
            url: '/action/getCouponlist',
            type: 'post',
            data: { hotelWeixinid: sys_hotelWeixinid, userWeixinid: sys_userWeixinid, key: sys_key, type: "hotel" },
            success: function (data) {
                couponjson = $.parseJSON(data);
                $('#couponlist div[couponid]').unbind();
                $.each(couponjson, function (k, coupon) {
                    var div = $('#couponlist .copy').clone(true).removeClass('copy');
                    div.find('.couponmoney').text(coupon['Moneys']);
                    div.find('.couponstdate').text(getcoupondatestr(coupon['sTime']));
                    div.find('.couponendate').text(getcoupondatestr(coupon['ExtTime']));
                    div.find('.couponqiyong').text(coupon['AmountLimit']);
                    div.attr('couponid', coupon['Id']);
                    div.attr('amountlimit', coupon['AmountLimit']);
                    that.append(div);
                    //                    $('#couponlist div[couponid]').bind('click', function () {
                    //                        $('#couponlist .select-box div[couponid]').removeClass('cur');
                    //                        $(this).addClass('cur');
                    //                    });
                });
                if ($('#couponlist .select-box div[couponid]').length > 0) {

                    $('#couponprice').closest('dl').show();
                    calculatePrice();

                    //                    $('#couponlist .select-box div[couponid]:first').trigger('click');
                    //                    $(".yhq-over").trigger('click');
                }
            }
        });
    }
}




function ShowHongbao(curr_price) {

    var no_hb = "";
    $(".yhq-box .row[couponid]").each(function (i, item) {



        if ($(this).find(".couponmoney").text().trim() >= parseFloat(curr_price) || parseFloat($(this).attr("amountlimit")) > parseFloat(curr_price)) {

            $(this).addClass("dis");

            $(this).find(".nocan_hongbao").hide();
            $(this).find(".nocan_hongbao2").hide();

            if (parseFloat($(this).attr("amountlimit")) > parseFloat(curr_price)) {
                $(this).find(".nocan_hongbao").show();
            }
            else {
                $(this).find(".nocan_hongbao2").show();
            }


            $(this).find(".hongbao-state  .type1").text("不可用");

            if ($(this).hasClass("cur")) {
                $(this).removeClass("cur");
                $('#couponprice').text("0");
                $('#couponprice').attr('couponid', 0);
                no_hb = "sys";
            }
        }

        else {

            $(this).removeClass("dis");

            $(this).find(".nocan_hongbao").hide();
            $(this).find(".nocan_hongbao2").hide();
            $(this).find(".hongbao-state  .type1").text("未使用");

        }
    });


    if ($(".yhq-box .row.cur[couponid]").length == 0 && $('.yhq-box .row[couponid]:not(".dis")').length > 0) {

        var curr_hongbao_li = $('.yhq-box .row[couponid]:not(".dis"):first');
        $(curr_hongbao_li).addClass("cur").siblings().removeClass("cur");
        ExcuSelecthongbao();

    }

    if ($('.yhq-box .row[couponid].dis').length > 0) {

        var curr_dis = $('.yhq-box .row[couponid].dis');
        $('.yhq-box .row[couponid].dis').remove();
        $(".yhq-box").append(curr_dis);

    }



    $(".tip_wuhongbao").hide();
    $(".tip_youhongbao").show();
    $(".tip_wuhongbao").text("暂无可用");

    if ($('.yhq-box .row[couponid]:not(.dis)').length == 0) {
        $(".tip_wuhongbao").show();
        $(".tip_youhongbao").hide();
    }


    $('.yhq-box .row[couponid]').unbind();
    $('.yhq-box .row[couponid]').bind('click', function () {
        if ($(this).hasClass("dis")) {
            return;
        }
        $(this).addClass("cur").siblings().removeClass("cur");



    });

}



//返回yyyy.MM.dd格式
function getcoupondatestr(_date) {
    var date = new Date(_date.match(/\d+/)[0] * 1);
    var year = date.getYear() + 1900;
    var month = date.getMonth() + 1;
    var day = date.getDate();
    if (month < 10) {
        month = '0' + month;
    }
    if (day < 10) {
        day = '0' + day;
    }
    return year.toString() + '.' + month.toString() + '.' + day.toString();
}

function fetchdemolist() {
    var ary = ['无', '尽量安排无烟房', '尽量安排吸烟房', '尽量安排高层']; //'尽量安排大床', '尽量安排双床'
    var that = $('#demolist .select-box');
    $('#demolist .select-box div[demo]').remove();
    $('#demolist div[demo]').unbind();
    $.each(ary, function (k, v) {
        var div = $('#demolist .copy').clone(true).removeClass('copy');
        div.find('label').text(v);
        div.attr('demo', v);
        that.append(div);
        $('#demolist div[demo]').bind('click', function () {
            $('#demolist .select-box div[demo]').removeClass('cur');
            $(this).addClass('cur');
        });
    });
}

$('.num-input span').click(function () {
    if ($(this).hasClass('cur')) {
        var value = parseInt($(this).attr('addvalue'));
        var roomnum = parseInt($('#roomnum').val()) + value;
        $('#roomnum').val(roomnum);
        $('.roomnum').val(roomnum);
        $('.roomnum').text(roomnum);
        var maxRoomnum = orderjson['roomstock'];
        if (maxRoomnum > 8) {
            maxRoomnum = 8;
        }
        var minRoomnum = 1;
        if (value == -1) {
            if (roomnum == minRoomnum) {
                $('.num-input .jian').removeClass('cur');
            }
            $('.num-input .jia').addClass('cur');
            $('#usernamelist input:last').remove();
        } else if (value == 1) {
            if (roomnum == maxRoomnum) {
                $('.num-input .jia').removeClass('cur');
            }
            if (roomnum > minRoomnum) {
                $('.num-input .jian').addClass('cur');
            }
            //            var text = '房间' + roomnum + '每间房只需填一位';
            var text = '入住人姓名';
            $('#usernamelist').append($('<input>', { type: 'text', placeholder: text, class: 'input-type1 sp' }));
        }
        calculatePrice();
    }
});

//最晚到店
$(".lasttimeselect").click(function () {
    var lasttime = $('#lasttime').text();
    $('#lasttimebox .select-box div[lasttime]').removeClass('cur');
    $('#lasttimebox .select-box div[lasttime="' + lasttime + '"]').addClass('cur');
    $(".lasttime").fadeIn(500);
})
//$(document).on('click', '#lasttimebox div[lasttime]', function () {
//    var lasttime = $(this).attr('lasttime');
//    $('#lasttime').text(lasttime);
//    $(this).parents(".mask").fadeOut();
//});

// 特殊要求
$(".tsyq-type").click(function () {
    var demo = $('#demo').text();
    $('#demolist .select-box div[demo]').removeClass('cur');
    $('#demolist .select-box div[demo="' + demo + '"]').addClass('cur');
    $(".tsyq").fadeIn(500);
})
$(".tsyq-over").click(function () {
    $(".tsyq").fadeOut();
    var demo = $('#demolist .select-box div.cur').attr('demo');
    $('#demo').text(demo);
})
//$(document).on('click', '#demolist div[demo]', function () {
//    $('#demolist .select-box div[demo]').removeClass('cur');
//    $(this).addClass('cur');
//});

$(".cancel").click(function () {
    $(".mask").fadeOut();
})

//发票
$('#needinvoice').click(function () {
    $('#invoicetitle').closest('dl').fadeOut();
    $('#invoicenum').closest('dl').fadeOut();
    $(this).toggleClass('cur');
    $(this).attr('needinvoice', 0);
    if ($(this).hasClass("cur")) {

        $('#invoicetitle').closest('dl').fadeIn();
        $('#invoicenum').closest('dl').fadeIn();
        $(this).attr('needinvoice', 1);
    }
});

//押金
$('#foregiftselect').click(function () {
    $('#foregift').closest('dl').fadeOut();
    $(this).toggleClass('cur');
    var foregift = 0;
    if ($(this).hasClass("cur")) {
        $('#foregift').closest('dl').fadeIn();
        $('.pay-detail .pay-dateil-list .foregift').closest('li').fadeIn();
        foregift = parseInt(orderjson['room']['Foregift']);
    } else {
        $('.pay-detail .pay-dateil-list .foregift').closest('li').fadeOut();
    }
    $('#foregift').text(foregift);
    calculatePrice();
});

//优惠券
$(".yhq-select").click(function () {
    var couponid = $('#couponprice').attr('couponid');
    $('#couponlist .select-box div[couponid]').removeClass('cur');
    $('#couponlist .select-box div[couponid] .couponitem').addClass('yu-orange');
    $('#couponlist .select-box div[couponid="' + couponid + '"] .couponitem').removeClass('yu-orange');
    $('#couponlist .select-box div[couponid="' + couponid + '"]').addClass('cur');
    $(".yhq").fadeIn(500);

})
$(".yhq-over").click(function () {
    $(".yhq").fadeOut();

    ExcuSelecthongbao();
    calculatePrice();
})


function ExcuSelecthongbao() {

    var couponid = $('#couponlist .select-box div.cur').attr('couponid');
    if (couponid == undefined) {
        return;
    }

    $('#couponprice').attr('couponid', couponid);
    var money = couponjson['_' + couponid]['Moneys'];
    $('#couponprice').text(money);
    $('.couponprice').text(money);
    if (money > 0) {
        $('.pay-detail .pay-dateil-list .couponprice').closest('li').show();
    }

}
//$(document).on('click', '#couponlist div[couponid]', function () {
//    $('#couponlist .select-box div[couponid]').removeClass('cur');
//    $(this).addClass('cur');
//});

//明细
$(".details-btn2").click(function () {
    $(".pay-detail").toggle();
    $(this).toggleClass("cur");

})



//手机号码
$('.phonenumber').click(function () {
    showphonenumber();
    $(".number-bar").show();
})
$('.number-bar .num-key-row .num-k').click(function () {
    $('.number-bar .submit').removeClass("cur");
    if (phonenumberAry.length < 11) {
        phonenumberAry.push(parseInt($(this).text()));
    }
    if (phonenumberAry.length == 11) {
        $('.number-bar .submit').addClass("cur");
    }
    showphonenumber();
});
$('.number-bar .num-key-row .del').click(function () {
    if (phonenumberAry.length == 1) {
        return false;
    }
    $('.number-bar .submit').removeClass("cur");
    phonenumberAry.pop();
    showphonenumber();
});
$(".slide-bar").click(function () {
    $(".number-bar").fadeOut();
})
$('.number-bar .submit').click(function () {
    if ($(this).hasClass('cur')) {
        $('.phonenumber').val($('.number-bar .scrn-txt').text());
        $(".number-bar").fadeOut();
    }
});
function showphonenumber() {
    var numtxt = '';
    $.each(phonenumberAry, function (k, v) {
        if (k == 3 || k == 6 || k == 9) {
            numtxt += ' ';
        }
        numtxt += v.toString();
    });
    $('.number-bar .scrn-txt').text(numtxt);
}

//保存
$('#save').click(function () {
    $('#save').prop('disabled', true);
    var nameary = new Array();
    var isnameempty = false;
    $.each($('#usernamelist input'), function () {
        var name = $(this).val();
        if (name == '') {
            isnameempty = true;
            $(this).focus();
            return false;
        }
        nameary.push(name);
    });
    if (isnameempty) {
        WXweb.utils.MsgBox('请输入房间入住人姓名！');
        $('#save').prop('disabled', false);
        return false;
    }
    var username = nameary.join('|');
    if (!isNaN(username)) {
        WXweb.utils.MsgBox('入住人不能填入数字！');
        $('#save').prop('disabled', false);
        return false;
    }

    var phonenumber = $('.phonenumber').val().trim();
    if (phonenumber == '') {
        WXweb.utils.MsgBox('请输入手机号！');
        $('#save').prop('disabled', false);
        $('.phonenumber').trigger('click');
        return false;
    }
    var needinvoice = parseInt($('#needinvoice').attr('needinvoice'));
    var invoicetitle = $('#invoicetitle').val();
    var invoicenum = $('#invoicenum').val().trim();

    if (needinvoice == 1 && invoicetitle == '') {
        WXweb.utils.MsgBox('请输入发票抬头！');
        $('#save').prop('disabled', false);
        $('#invoicetitle').focus();
        return false;
    }

    if (needinvoice == 1 && invoicenum == '') {
        WXweb.utils.MsgBox('请输入纳税人识别号！');
        $('#save').prop('disabled', false);
        $('#invoicenum').focus();
        return false;
    }


    //写入信息保存
    var saveinfo = {};
    var roomnum = parseInt($('#roomnum').val());
    saveinfo['yroomnum'] = roomnum;
    saveinfo['username'] = username;
    saveinfo['linktel'] = phonenumberAry.join('');
    saveinfo['needinvoice'] = needinvoice;
    if (needinvoice == 1) {
        saveinfo['invoicetitle'] = invoicetitle;
        saveinfo['invoicenum'] = invoicenum;
    }
    var foregift = parseInt($('#foregift').text());
    saveinfo['foregift'] = foregift;
    var actualprice = parseInt($('.actualprice:eq(0)').text());
    saveinfo['ssumprice'] = actualprice;
    saveinfo['roomid'] = orderjson['roomid'];
    saveinfo['rateplanid'] = orderjson['rateplanid'];
    saveinfo['hotelid'] = orderjson['room']['HotelID'];
    saveinfo['roomname'] = orderjson['room']['RoomName'];
    saveinfo['hotelname'] = orderjson['hotelname'];
    saveinfo['ishourroom'] = orderjson['ishourroom'];
    var lasttime = $('#lasttime').text();
    saveinfo['yindate'] = orderjson['indate'];
    saveinfo['youtdate'] = orderjson['outdate'];
    var rateplanname = orderjson['rateplan']['RatePlanName'] + '(' + orderjson['rateplan']['ZaoCan'] + ')';
    if (orderjson['ishourroom'] == 1) {
        var hourtimeary = lasttime.toString().split('-');
        saveinfo['hourstarttime'] = hourtimeary[0];
        saveinfo['hourendtime'] = hourtimeary[1];
        rateplanname = orderjson['rateplan']['HourRoomType'] + '小时钟点房';
    } else {
        saveinfo['lasttime'] = lasttime;
    }
    saveinfo['rateplanname'] = rateplanname;
    saveinfo['weixinid'] = sys_hotelWeixinid;
    saveinfo['userWeixinid'] = sys_userWeixinid;
    var paytype = orderjson['rateplan']['PayType'];
    saveinfo['paytype'] = paytype;
    var priceAry = new Array();
    $.each(orderjson['rateplan']['RateList'], function (k, rate) {
        priceAry.push(rate['Dates'] + ':' + rate['Price']);
    });
    saveinfo['priceAry'] = priceAry.join('|');
    var memberpoints = parseInt($('.memberpoints').text());
    saveinfo['jifen'] = memberpoints;
    saveinfo['demo'] = $('#demo').text();
    saveinfo['token'] = orderjson['token'];
    saveinfo['cardno'] = orderjson['MemberCardRule']['CardNo'];
    saveinfo['memberid'] = orderjson['memberid'];

    //以下信息保存到 couponinfo 字段
    saveinfo['originalsaleprice'] = orderjson['price'] * roomnum;
    saveinfo['couponid'] = $('#couponprice').attr('couponid');
    saveinfo['couponprice'] = parseInt($('#couponprice').text());
    saveinfo['graderate'] = orderjson['MemberCardRule']['GradeRate'];
    saveinfo['gradename'] = orderjson['MemberCardRule']['GradeName'];

    saveinfo['coupontype'] = orderjson['MemberCardRule']['CouponType'];
    saveinfo['reduce'] = orderjson['MemberCardRule']['Reduce'] * parseInt($("#total_days").text());

    saveinfo['isvip'] = orderjson['rateplan']['IsVip'];

    $.ajax({
        url: '/action/saveorderinfo/' + sys_hid + '?key=' + sys_key,
        type: 'post',
        data: { saveinfo: JSON.stringify(saveinfo) },
        success: function (data) {
            var _json = $.parseJSON(data);
            if (_json['success']) {
                if (paytype == 0) {
                    //预付跳转到微信支付页面
                    //window.location.href = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx4231803400779997&redirect_uri=http%3a%2f%2fhotel.weikeniu.com%2fWeiXinZhiFu%2fwxOAuthRedirect.aspx&response_type=code&scope=snsapi_base&state=" + _json['orderno'] + "#wechat_redirect";
                    window.location.href = '/Recharge/CardPay/' + orderjson['room']['HotelID'] + '?key=' + sys_hotelWeixinid + '@' + sys_userWeixinid + '&orderno=' + _json['orderno'];
                } else if (paytype == 1) {
                    //现付跳转到订单列表
                    //window.location.href = '/User/MyOrders/' + orderjson['room']['HotelID'] + '?key=' + sys_hotelWeixinid + '@' + sys_userWeixinid;
                    //现付下单跳转到订单详情 2017-6-5
                    //User/OrderInfo/28291?id=71421&key=gh_7a64caf61dff@oPfrcjhjFtDdV4IK6RzV8ScbapOQ
                    window.location.href = '/User/OrderInfo/' + orderjson['room']['HotelID'] + '?id=' + _json['orderid'] + '&key=' + sys_hotelWeixinid + '@' + sys_userWeixinid;
                }
            }
            else {
                WXweb.utils.MsgBox(_json['message']);
                $('#save').prop('disabled', false);
            }
        }
    });
});
