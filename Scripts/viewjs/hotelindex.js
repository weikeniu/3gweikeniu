var datetype = '';
var updatetime = new Date();
var hoteljson = {};
var ratejson = {};
var imgjson = {};
var MemberCardRuleJson = {};
var SurplusCouponJson = {};
var memberid = '';
var ismember = 0;
var username = '';
var mobile = '';

$(function () {
    $('#days').text(getDays($('#indate').attr('datestr'), $('#outdate').attr('datestr')));

    binddata();

    ratejson = $.parseJSON(sys_ratejson);
    MemberCardRuleJson = $.parseJSON(sys_MemberCardRuleJson);
    hoteljson = $.parseJSON(sys_hoteljson);
    imgjson = ratejson['roomImgs'];

    fetchMemberCardRuleJson(sys_MemberCardRuleJson);
    fetchhotelinfo(sys_hoteljson);
    fetchimgs();
    fetchStatisticsCount(ratejson['StatisticsCount']);

    $('#indatestr').text(getdatestr($("#indate").attr("datestr")));
    $('#outdatestr').text(getdatestr($("#outdate").attr("datestr")));

    getSurplusCouponlist();

    OpCollection("query");
    getShareRooms();

});




function getShareRooms() {
    if (sys_isshare == 1) {

        $(".room-content li[rateplanid]").each(function (i, item) {

            if ($(this).parents("li").find(".btn_orderprice").length == 0) {
                $(this).parents("li").hide();
            }

            if ($(this).find(".btn_orderprice").length == 0) {
                $(this).remove();
            }
        });

    }
}


function getSurplusCouponlist() {

    if (sys_isshare == 1) {

        return;
    }

    if (parseInt($("#takecoupon").attr("data-num")) <= 0) {
        return;
    }

    $.ajax({
        url: '/action/getSurplusCouponlist',
        type: 'post',
        data: { hotelweixinid: sys_hotelWeixinid, userweixinid: sys_userWeixinid },
        success: function (data) {
            var have_nonum = 0;
            SurplusCouponJson = $.parseJSON(data);
            $.each(SurplusCouponJson, function (k, coupon) {
                var div = $('#SurplusCouponlist div.copy').clone(true).removeClass('copy');
                div.attr('couponid', coupon['CouponID']);
                if (coupon['HaveGet'] == 1) {
                    div.addClass('cur');
                }
                else {
                    have_nonum++;
                }
                div.find('.price').text(coupon['Moneys']);
                div.find('.stime').text(coupon['sTimeStr']);
                div.find('.etime').text(coupon['ExtTimeStr']);
                $('#SurplusCouponlist').append(div);
            });
            if (have_nonum > 0) {
                $("#takecoupon").show();
            }
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
            fetchStatisticsCount(_json);
        }
    });
}

function fetchStatisticsCount(_json) {
    //    if (_json['CouPon'] > 0) {
    //        $('#takecoupon').show();
    //    }
}

function getMemberCardIntegralRule() {
    $.ajax({
        url: '/action/getMemberCardIntegralRule',
        type: 'post',
        data: { userWeixinid: sys_userWeixinid, hotelWeixinid: sys_hotelWeixinid },
        success: function (data) {
            fetchMemberCardRuleJson(data);
        }
    });
}

function fetchMemberCardRuleJson(data) {
    var _json = $.parseJSON(data);
    MemberCardRuleJson = _json['rule'];
    memberid = _json['memberid'];
    ismember = _json['becomeMember'] ? 0 : 1;
    username = _json['username'];
    mobile = _json['mobile'];

    if (_json['becomeMember']) {
        var memberinfo = _json['memberinfo'];
        var table = $('.hyk-mask .mem-right table');
        if (memberinfo['gift'] > 0) {
            $('.hyk-mask .gift').show();
            $('.hyk-mask .hongbao').text(memberinfo['gift'] * memberinfo['giftnum']);
        }

        if (sys_hid == "29571" || sy_memberbasics==0) {
            return;
        }

        if (sys_isshare == 1) {
            return;
        }

        if ($('.hyk-mask .mem-right table tr.copy').attr("data-custom") > 0) {
            $(".hyk-mask").fadeIn();
            return;
        }
        var membernameAry = ['普通会员', '高级会员', '白银会员', '黄金会员', '钻石会员'];
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
    var days = parseFloat(outdate.getTime()) - parseFloat(indate.getTime());
    var d = days / (24 * 60 * 60 * 1000);
    return d;
}

function gethotelinfo() {
    $.ajax({
        url: '/action/gethotelinfo',
        type: 'post',
        data: { hid: sys_hid, hotelweixinid: sys_hotelWeixinid },
        success: function (data) {
            fetchhotelinfo(data);
        }
    });
}

function fetchhotelinfo(data) {
    hoteljson = $.parseJSON(data);
    $('#hotelname').text(hoteljson['SubName']);
    $('#address').text(hoteljson['Address']);
    $('#hoteltel').text(hoteljson['Tel']);
    $('#calltel').attr('href', 'tel://' + hoteljson['Tel']);
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
                        $('.swiper-container .swiper-wrapper').append($('<div>', { class: 'swiper-slide' }).append($('<img>', { src: img['BigUrl'] })));
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
    var imgcount = 1;
    $.each(imgjson, function (rid, imgs) {
        if (rid == 0) {
            $.each(imgs, function (k, img) {
                if (k > 0 && (img['ImgType'] == 2 || img['ImgType'] == 1)) {
                    $('.swiper-container .swiper-wrapper').append($('<div>', { class: 'swiper-slide' }).append($('<img>', { src: img['BigUrl'] })));
                    imgcount += 1;
                }

            });
        }
    });
    $('.totalindex').text(imgcount);
    createswiper('swiper-container');
}

function getDateFormate(date) {
    var todayYear = parseInt(date.getYear()) + 1900;
    var todayMonth = parseInt(date.getMonth()) + 1;
    if (todayMonth < 10) {
        todayMonth = '0' + todayMonth;
    }

    var todayDay = parseInt(date.getDate());
    if (todayDay < 10) {
        todayDay = '0' + todayDay;
    }

    return todayYear.toString() + '-' + todayMonth.toString() + '-' + todayDay.toString();
}

//$("#datepicker").datepicker({
//    dateFormat: 'yy-mm-dd',
//    dayNamesMin: ["日", "一", "二", "三", "四", "五", "六"],
//    monthNames: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
//    yearSuffix: '年',
//    showMonthAfterYear: true,
//    numberOfMonths: 2,
//    prevText: "上月",
//    nextText: '下月',
//    showButtonPanel: false,
//    onSelect: function (datestr) {
//        var date = new Date(datestr);
//        var month = date.getMonth() + 1;
//        var day = date.getDate();
//        $('#datepicker').hide();
//        if (datetype == 'indate') {
//            $('#indate').text(month.toString() + '-' + day.toString());
//            $('#indate').attr('datestr', datestr);
//            $('#indatestr').text(getdatestr(datestr));
//            dateclick('outdate');
//        } else if (datetype == 'outdate') {
//            var stdate = new Date($('#indate').attr('datestr'));
//            var i = date.getTime() - stdate.getTime();
//            if (i < 0) {
//                $('#indate').text(month.toString() + '-' + day.toString());
//                $('#indate').attr('datestr', datestr);
//                $('#indatestr').text(getdatestr(datestr));
//                dateclick('outdate');
//            } else {
//                $('#outdate').text(month.toString() + '-' + day.toString());
//                $('#outdate').attr('datestr', datestr);
//                $('#outdatestr').text(getdatestr(datestr));
//                getratejson();
//                $('#days').text(getDays($('#indate').attr('datestr'), $('#outdate').attr('datestr')));
//                $(".base-page").show();
//                $(".date-page").hide();
//            }
//        }
//    }
//});

$(document).on('click', '.date-page .back,.date-page .top', function () {
    //    $('.base-page').show();
    //    $('.date-page').hide();
});

$('.rooms-date-change li').click(function () {

    if ($("#datepicker").find(".specialdays").length == 0) {
        $(".ui-state-active").removeClass("ui-state-active");

        var cur_indate = $("#indate").attr("datestr");

        var curr_indate_index = 0;
        var curr_outdate_index = 0;

        for (var i = 0; i < 2; i++) {

            if (i == 1) {
                cur_indate = $("#outdate").attr("datestr");
            }
            var cur_year = cur_indate.split('-')[0];
            var cur_month = cur_indate.split('-')[1].indexOf('0') == 0 ? cur_indate.split('-')[1].replace("0", "") : cur_indate.split('-')[1];
            var cur_day = cur_indate.split('-')[2].indexOf('0') == 0 ? cur_indate.split('-')[2].replace("0", "") : cur_indate.split('-')[2];
            var selectDay = $("td[data-handler='selectDay'][data-year=" + cur_year + "][data-month=" + (parseInt(cur_month) - 1) + "][data-day=" + cur_day + "]");
            if (i == 1) {
                $(selectDay).addClass("specialdays").addClass("last");
                curr_outdate_index = $("td[data-handler='selectDay']").index(selectDay);
            }

            else {
                $(selectDay).addClass("specialdays").addClass("first");
                curr_indate_index = $("td[data-handler='selectDay']").index(selectDay);
            }
        }


        if (curr_outdate_index - curr_indate_index > 1) {

            for (var i = curr_indate_index + 1; i < curr_outdate_index; i++) {
                $($("td[data-handler='selectDay']")[i]).addClass(" ui-range-selected");

            }

        }
    }


    $(".base-page").hide();
    $(".date-page").show();
    $(window).scrollTop(0);

    //  dateclick('indate');
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
    //    $.ajax({
    //        url: '/action/getratejson',
    //        type: 'post',
    //        data: { hid: sys_hid, indate: indate, outdate: outdate, hotelweixinid: sys_hotelWeixinid },
    //        success: function (data) {
    //            $('#roomlistdiv').children().remove();
    //            var _json = $.parseJSON(data);
    //            var hourroomRatesJson = _json['hourroomRates'];
    //            var roomRatesJson = _json['roomRates'];
    //            var roomlistJson = _json['roomlist'];
    //            sys_tokenkey = _json['tokenkey'];
    //            sys_token = _json['token'];
    //        }
    //    });


    $('#roomlistdiv').children().remove();
    $('#roomlistdiv').load('/hotel/roomlistindex/' + sys_hid,
     { hid: sys_hid, indate: indate, outdate: outdate, hotelweixinid: sys_hotelWeixinid, graderate: sys_graderate, key: sys_key, reduce: sys_reduce, coupontype: sys_coupontype, membershow: membershow, gradename: sys_gradename, dingfangmember: sys_dingfangmember, ismember: sys_ismember }, function () {
         binddata();
         ratejson = $.parseJSON(sync_ratejson);
         imgjson = ratejson['roomImgs'];
         sys_tokenkey = ratejson['tokenkey'];
         sys_token = ratejson['token'];
         getShareRooms();
     });
}

function binddata() {
    $('#hourroomlist .room-content li,#roomlist .room-content li').unbind();
    $('#roomlist .room-content li[rateplanid],#hourroomlist .room-content li[rateplanid]').bind('click', function () {
        var that = $(this);
        var available = that.attr('available');
        var isvip = that.attr('isvip');

        if (that.find('.order-btn').hasClass('over')) {
            return;
        }

        if (ismember == 0 && sys_dingfangmember == "1") {
            window.location.href = '/MemberCard/MemberRegister/' + sys_hid + '?key=' + sys_key;
            return;
        }

        if (!that.find('.order-btn').hasClass('over') && available == 1) {
            var roomid = that.attr('roomid');
            var rateplanid = that.attr('rateplanid');
            var ishourroom = that.attr('ishourroom');
            var discount = parseInt(that.find('.discount label').text());
            submitorder(roomid, rateplanid, ishourroom, discount);
        } else if (ismember == 0 && isvip == 1) {
            window.location.href = '/MemberCard/MemberRegister/' + sys_hid + '?key=' + sys_key;
        }



    });


    //    $(".li_showprice").unbind();
    //    $(".li_showprice").bind('click', function () {
    //        $(this).prev().click();
    //    });

    $('.room-content-head').unbind();
    $('.room-content-head').bind("click", function () {
        $(this).toggleClass("cur").siblings(".room-content").slideToggle();
    });

    //浏览大图
    $('#roomlist .room-pic').bind('click', function (event) {

        event.stopPropagation();

        var swiper2 = new Swiper('.swiper-container2', {
            paginationClickable: true,
            autoplayDisableOnInteraction: false,
            loop: true,
            observer: true,
            observeParents: true

        });

        var that = $(this);
        var imgnum = parseInt(that.find('.room-pic-num span').text());
        if (imgnum == 0) {
            return false;
        }
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
        var floor = roomobj['Floor'];
        if (floor == '0') {
            floor = '--';
        }
        $('.big-pic .floor').text(floor);
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

    });
}

//function getratejson() {
//    var indate = $('#indate').attr('datestr');
//    var outdate = $('#outdate').attr('datestr');
//    $.ajax({
//        url: '/action/getratejson',
//        type: 'post',
//        data: { hid: sys_hid, indate: indate, outdate: outdate, hotelweixinid: sys_hotelWeixinid },
//        success: function (data) {
//            fetchratejson(data);
//        }
//    });
//}

function fetchratejson(data) {
    ratejson = $.parseJSON(data);
    imgjson = ratejson['roomImgs'];
    fetchratelist(ratejson);

    $('#hourroomlist .room-content li,#roomlist .room-content li').unbind();
    $('#hourroomlist .room-content li[rateplanid],#roomlist .room-content li[rateplanid]').bind('click', function () {
        var that = $(this);
        if (!that.find('.order-btn').hasClass('over')) {
            var roomid = that.attr('roomid');
            var rateplanid = that.attr('rateplanid');
            var ishourroom = that.attr('ishourroom');
            var discount = parseInt(that.find('.discount label').text());
            submitorder(roomid, rateplanid, ishourroom, discount);
        }
    });
}

//$('#hourroomlist .room-content li[rateplanid],#roomlist .room-content li[rateplanid]').click(function () {
//    var that = $(this);
//    if (!that.find('.order-btn').hasClass('over')) {
//        var roomid = that.attr('roomid');
//        var rateplanid = that.attr('rateplanid');
//        var ishourroom = that.attr('ishourroom');
//        var discount = parseInt(that.find('.discount label').text());
//        submitorder(roomid, rateplanid, ishourroom, discount);
//    }
//});

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
                    var available = parseInt(rateplanitem.attr('available'));
                    if (available == 1) {
                        li.find('.lowestprice').closest('div').addClass('yu-orange');
                    } else {
                        li.find('.lowestprice').closest('div').addClass('yu-grey');
                    }
                } else {
                    li.find('.lowestprice').closest('div').addClass('yu-grey');
                    li.find('.lowestprice').closest('div').find('.yu-font12').hide();
                    li.find('.lowestprice').text('已售完');
                    li.find('.lowestprice').removeClass('yu-font20');
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

//$('.room-content-head').on("click", function () {
//    $(this).toggleClass("cur").siblings(".room-content").slideToggle();
//});

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

$('#calltel').click(function (e) {
    window.location.href = $(this).attr('href');
});

$('#tomap').click(function (e) {
    window.location.href = $(this).attr('href');
});

function submitorder(roomid, rateplanid, ishourroom, discount) {
    var roomkey = 'roomRates';
    if (ishourroom == 1) {
        roomkey = 'hourroomRates';
    }

    var roomtypeid = roomid + '_' + rateplanid;

    if (ratejson[roomkey][roomtypeid]['Available'] == 0 || ratejson[roomkey][roomtypeid]['Price'] == 0) {
        return false;
    }

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
    orderjson['roomstock'] = ratejson[roomkey][roomtypeid]['RoomStock'];
    orderjson['days'] = days;
    orderjson['MemberCardRule'] = MemberCardRuleJson;
    orderjson['discount'] = discount;
    orderjson['hotelname'] = $('#hotelname').text().trim();
    //        orderjson['room']['RateplanList'] = undefined;
    orderjson['tokenkey'] = sys_tokenkey;
    orderjson['token'] = sys_token;
    orderjson['memberid'] = memberid;
    orderjson['username'] = username;
    orderjson['mobile'] = mobile;
    $('#orderform input[name="orderjson"]').val(JSON.stringify(orderjson));
    $('#submitorder').trigger('click');
}

$('#hotelserveli').click(function () {
    window.location.href = $(this).attr('href');
});

$('#groupsalelist li[prodid]').click(function () {
    var prodid = $(this).attr('prodid');
    window.location.href = '/Product/ProductIndex/' + sys_hid + '?key=' + sys_hotelWeixinid + '@' + sys_userWeixinid + '@' + sys_generatesign + '&Id=' + prodid;
});

//领取红包
$(".get-quan").click(function () {
    //  $(".lqhb").fadeIn();
})
$("#SurplusCouponlist .row").on("click", function () {
    var that = $(this);
    if (!that.hasClass('cur')) {
        var couponid = that.attr('couponid');
        $.post('/Home/GetCouPon/' + sys_hid + '?weixinID=' + sys_hotelWeixinid + '&userWeiXinID=' + sys_userWeixinid + '&couponid=' + couponid, function (data) {
            if (data.error == '0') {
                that.addClass("cur");
            } else {
                //WXweb.utils.MsgBox(data.message);
                layer.msg(data.message);

            }
        });
    }
})
$(".get-btn2").click(function () {
    $(".lqhb").fadeOut();
})

//浏览大图
$(".big-pic .close").click(function () {
    $(".big-pic").fadeOut();
})
$('.big-pic .book-btn').click(function () {

    if (ismember == 0 && sys_dingfangmember == "1") {
        window.location.href = '/MemberCard/MemberRegister/' + sys_hid + '?key=' + sys_key;
        return;
    }


    var that = $(this);
    var roomid = that.attr('roomid');
    var rateplanid = that.attr('rateplanid');
    var discount = $('#roomlist li[roomid=' + roomid + '] .rateplanitem[rateplanid=' + rateplanid + '] .discount label').text();
    var ishourroom = $('#roomlist li[roomid=' + roomid + '] .rateplanitem[rateplanid=' + rateplanid + ']').attr('ishourroom');
    submitorder(roomid, rateplanid, ishourroom, discount);
});