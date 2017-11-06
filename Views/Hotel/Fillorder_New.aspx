<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% string hotelid = RouteData.Values["id"].ToString();
   string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
   string userweixinID = HotelCloud.Common.HCRequest.GetString("userweixinid");
   string tel = HotelCloud.Common.HCRequest.GetString("tel");
   var dt = ViewData["dt"] as System.Data.DataTable;
   var temp = ViewData["Temp"].ToString();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width,target-densitydpi=medium-dpi,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-touch-fullscreen" content="yes" />
    <title>
        <%=HotelCloud.Common.HCRequest.GetString("hotelName").Trim()+"官网" %></title>
    <link href="/css/style.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .msgbox-ui h1
        {
            display: block;
            text-align: center;
            color: #fff;
            font-size: 13px;
            font-weight: normal;
        }
        .msgbox-ui
        {
            line-height: 1.5;
            margin: 0;
            padding: 0;
            max-width: 190px;
            min-width: 150px;
            z-index: 9999999;
            position: fixed !important;
            top: 50%;
            left: 50%;
            box-shadow: 0 1px 1px -1px white;
            border: 0;
            display: block;
            border-radius: .6em;
            background-color: #222;
            padding: 15px;
            width: 210px;
            opacity: .88;
            height: auto;
            margin-left: -120px;
            margin-top: -43px;
        }
    </style>
    <script type="application/x-javascript">addEventListener('load',function(){setTimeout(function(){scrollTo(0,1);},0);},false);</script>
</head>
<%Html.RenderPartial("JS"); %>
<body>
    <div id="header">
        <a href="javascript:void(0)" onclick="history.go(-1)" class="back">返回上一页</a>
        <h1>
            订单填写</h1>
        <a href="/Hotel/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userweixinID %>" class="home">
            跳转至首页</a>
    </div>
    <div id="container">
        <div class="order">
            <dl class="attr">
                <dt>标准大床房</dt>
                <dd id="indate">
                    入住：2013-08-15</dd>
                <dd id="outdate">
                    退房：2013-08-15</dd>
                <dd class="night">
                </dd>
            </dl>
            <ul class="form">
                <li><span class="key">房型间数</span> <span class="dot dot_right" id="addnum"></span>
                    <input type="text" class="text count" value="1" id="roomcount" readonly />
                    <span class="dot dot_left" id="descnum"></span></li>
                <li><span class="key">到店时间</span>
                    <input type="text" class="text time" value="18:00" readonly="readonly" id="time" />
                </li>
                <li><span class="key">入住人</span>
                    <input type="text" class="text" id="name" />
                </li>
                <li><span class="key">手机号</span>
                    <input type="text" class="text" id="phone" />
                </li>
                <li><span class="key">优惠券</span> <span class="dot dot_down" id="downselect"></span>
                    <input type="text" class="text select" id="couponid" value="不使用" f="0" aid="0" readonly="readonly" />
                </li>
                <li><span class="key">预订总价</span> <span class="price" id="sumprice"></span></li>
            </ul>
            <div class="operation">
                <a href="javascript:void(0)" class="submit" id="button">提交订单</a>
            </div>
        </div>
    </div>
    <div class="msgbox-ui" style="display: none">
        <h1 id="alertcontent">
        </h1>
    </div>
    <div id="footer">
        <ul class="links">
            <li><a href="/Hotel/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userweixinID %>">首页</a></li>
            <li><a href="/Hotel/NewsinfoList/<%=hotelid %>?weixinID=<%=weixinID %>">优惠促销</a></li>
            <li><a href="/User/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userweixinID %>">会员中心</a></li>
            <li><a href="/User/MyOrders/<%=hotelid %>?key=<%=weixinID %>@<%=userweixinID %>">我的订单</a></li>
        </ul>
        <p class="copyright">
            技术支持：<a href="http://www.weikeniu.com/">微可牛</a></p>
    </div>
    <div id="mengban" style="display: none">
    </div>
    <div class="promptbox coupons_list" style="display: none" id="coupons">
        <ul>
            <li class="cur">不使用</li>
            <%foreach (System.Data.DataRow dr in dt.Rows)
              { %>
            <li value="<%=dr["moneys"] %>" aid="<%=dr["id"] %>">
                <%=dr["moneys"] %>元优惠券</li>
            <%} %>
            <%--<li>10元优惠券</li>
            <li>10元优惠券</li>
            <li class="cur">10元优惠券</li>
            <li>10元优惠券</li>
            <li>10元优惠券</li>
            <li>10元优惠券</li>
            <li>10元优惠券</li>
            <li>10元优惠券</li>
            <li>10元优惠券</li>--%>
        </ul>
    </div>
    <div class="promptbox time_list" id="stime" style="display: none">
        <ul>
            <li value="12:00" class="cur">12:00</li>
            <li value="13:00">13:00</li>
            <li value="14:00">14:00</li>
            <li value="15:00">15:00</li>
            <li value="16:00">16:00</li>
            <li value="17:00">17:00</li>
            <li value="18:00">18:00</li>
            <li value="19:00">19:00</li>
            <li value="20:00">20:00</li>
            <li value="21:00">21:00</li>
            <li value="22:00">22:00</li>
            <li value="23:00">23:00</li>
            <li value="23:59">24:00</li>
            <li value="1:00">次日1点</li>
            <li value="2:00">次日2点</li>
            <li value="3:00">次日3点</li>
            <li value="4:00">次日4点</li>
            <li value="5:00">次日5点</li>
        </ul>
    </div>
</body>
</html>
<script src="/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
<script src="/Scripts/m.hotel.com.core.min.js" type="text/javascript"></script>
<script type="text/javascript">
    (function ($) {
        //没有滚动条则固定在底部
        if ($(document.body).outerHeight(true) == $(document).height()) $("#footer").css("position", "fixed");
    })(jQuery);
</script>
<script type="text/javascript">
        var flag=0;
//        $(".back").click(function(){
//        history.back(-1);
//        });
            //var utils = WXweb.utils, controllers = WXweb.controllers,OrderJson = utils.getStorage("OrderJson");    
//         var prices=parseInt(OrderJson.sumprice)+parseInt($("#couponid").attr("f"))-parseInt($("#coupons").val()==""?0:parseInt($("#coupons")));
        
         var utils = WXweb.utils, controllers = WXweb.controllers;
        var data = new Array(),Temp = [<%=ViewData["Temp"] %>];
        for(var k in Temp){data.push(Temp[k]);} 
          $("#couponid").click(function () { $("#coupons").css("display","block")});
            OrderJson = {hotelid:data[0], hotelname:data[1], roomid:data[2], roomname:data[3], rateplanid:data[4], rateplanname:data[5], indate:data[6], outdate:data[7], ishourroom:data[8], sumprice:data[9], roomnum:1,lastime:"18:00",username:"",linktel:"",userweixinid:data[10],weixinid:data[11],orderid:"",hoteltel:data[12],coupon:"0"};
                utils.setStorage("OrderJson", JSON.stringify(OrderJson));
            var OrderJson = utils.getStorage("OrderJson");
             var prices=parseInt(OrderJson.sumprice)+parseInt($("#couponid").attr("f"))-parseInt($("#coupons").val()==""?0:parseInt($("#coupons"))); 
              $("#sumprice").html("<dfn>¥</dfn>"+prices);
         $("#indate").html("入住:"+OrderJson.indate);$("#outdate").html("退房:"+OrderJson.outdate);
                var roomCount = 10, totalvalue,num = $("#roomcount").val();
                $("#descnum").bind("click", function () {
                    if (num > 1) {
                        num = --num;
                        totalvalue =parseInt(data[9]) * parseInt(num)-parseInt($("#couponid").attr("f"));
                        $("#roomcount").val(num);                        
                        $("#sumprice").html("<dfn>¥</dfn>"+totalvalue);
                       
                        OrderJson.roomnum = num;
                        OrderJson.sumprice = totalvalue;
                         utils.setStorage("OrderJson", JSON.stringify(OrderJson));
                    }
                });
                $("#addnum").bind("click", function () {
              
                    if (num < roomCount) {
                        num = ++num;
                        totalvalue = parseInt(data[9]) * parseInt(num)-parseInt($("#couponid").attr("f"));
                        $("#roomcount").val(num)                        
                        $("#sumprice").html("<dfn>¥</dfn>"+totalvalue)
                        OrderJson.roomnum = num;
                        OrderJson.sumprice = totalvalue;
                         utils.setStorage("OrderJson", JSON.stringify(OrderJson));
                    }
                });
                            
       
        

$("#coupons ul li").mouseover(function(){
$(this).addClass("cur").siblings().removeClass("cur");
});

$("#coupons ul li").click(function(){
var prices=0;
if($(this).attr("aid")==null)
 prices=parseInt(OrderJson.sumprice);
 else
 prices=parseInt(OrderJson.sumprice)-parseInt($(this).val());
 $("#couponid").val($(this).text()).attr("f",$(this).attr("value")).attr("aid",$(this).attr("aid"));                     
                        $("#sumprice").html("<dfn>¥</dfn>"+prices);
$("#coupons").css("display","none");
});


$("#downselect").click(function(){
$("#couponid").click();
});

$("#time").click(function(){
    $("#stime").css("display","block");
});
$("#stime li").mouseover(function(){
$(this).addClass("cur").siblings().removeClass("cur");
});

$("#stime li").click(function(){
    $("#time").val($(this).attr("value")+":00");
     $("#stime").css("display","none");
});


$("#button").click(function(){
var sTel = $('#phone').val().Trim(), re = /^1\d{10}$/;
if($("#name").val()=="")
{
$("#alertcontent").text("请填写入住人姓名");
    $(".msgbox-ui").show();
    dingshi();
    return false;
}
if (!re.test(sTel))
 {
 $("#alertcontent").text("请填写正确的手机号码");
  $(".msgbox-ui").show();
    dingshi();
    return false;
 }
 var sContactName=$("#name").val(),sTel=$("#phone").val();

  OrderJson.username = sContactName;OrderJson.linktel = sTel;OrderJson.lastTime = $('#time').val();
   utils.setStorage("OrderJson", JSON.stringify(OrderJson));
 var param = {
                    hotelid: OrderJson.hotelid,
                    roomid: OrderJson.roomid,
                    rateplanid: OrderJson.rateplanid,
                    indate: OrderJson.indate,
                    outdate: OrderJson.outdate,
                    ishourroom: OrderJson.ishourroom,
                    roomnum: OrderJson.roomnum,
                    lastTime: OrderJson.lastime,
                    username: OrderJson.username,
                    linktel: OrderJson.linktel,
                    userweixinid:OrderJson.userweixinid,
                    weixinid:OrderJson.weixinid,
                    sumprice:OrderJson.sumprice,
                    hoteltel:OrderJson.hoteltel,
                    couponid:$("#couponid").attr("aid")
                };
                $.ajax({
                    url: "/Hotel/SetFillorder",
                    data: param,
                    type: "post",
                    dataType: "json",
                    success: function (b) {
                        if (b && b.ok == "true") {
                            //OrderJson.orderid = b.message;
                            OrderJson.coupon=$("#couponid").attr("f");
                           utils.setStorage("OrderJson", JSON.stringify(OrderJson));
                          $("#alertcontent").text("订单提交成功");
                        $(".msgbox-ui").show();
                        dingshi();
                            window.location.href = "/Hotel/SucOrder/<%=hotelid %>?weixinID=<%=weixinID %>"
                            return;
                        }
                        else{
                        $("#alertcontent").text("订单提交失败");
                        $(".msgbox-ui").show();
                        dingshi();
                      
                        } 
                        }
                        });
              
 
});

function dingshi()
{
 setTimeout(function () {
     $(".msgbox-ui").hide();
        },
        2e3);
}
        function GetDateRegion(BeginDate,EndDate)
            {
                
                var aDate1,aDate2, oDate1, oDate2, iDays;
                aDate1 = BeginDate.split("-");
                oDate1 = new Date(aDate1[1] + '/' + aDate1[2] + '/' + aDate1[0]);   //转换为12/13/2008格式
                aDate2 = EndDate.split("-");
                oDate2 = new Date(aDate2[1] + '/' + aDate2[2] + '/' + aDate2[0]);
                //iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 /24)+1;   //把相差的毫秒数转换为天数
               iDays =(oDate2 - oDate1) / 1000 / 60 / 60 /24;
               
              
                //alert(iDays);
                return iDays;
            }
</script>
