<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    string hid = ViewData["hid"].ToString();
    string key = HotelCloud.Common.HCRequest.GetString("key");
    string hotelweixinid = string.Empty;
    string userweixinid = string.Empty;
    if (!string.IsNullOrEmpty(key) && key.Contains("@"))
    {
        List<string> keylist = key.Split(new string[] { "@" }, StringSplitOptions.RemoveEmptyEntries).ToList();
        hotelweixinid = keylist[0];
        userweixinid = keylist[1];
    }
    string orderid = HotelCloud.Common.HCRequest.GetString("id");

    hotel3g.Models.HotelOrder order = ViewData["order"] as hotel3g.Models.HotelOrder;

    Hashtable CouponInfo = new Hashtable();
    double graderate = 0;
    int couponType = 0;
    double reduce = 0;
    string gradeName = string.Empty;
    if (!string.IsNullOrEmpty(order.CouponInfo))
    {
        CouponInfo = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(order.CouponInfo);
        if (CouponInfo.Count > 0)
        {
            couponType = Convert.ToInt32(CouponInfo["CouponType"]);
            graderate = WeiXinPublic.ConvertHelper.ToDouble(CouponInfo["GradeRate"]);
            reduce = WeiXinPublic.ConvertHelper.ToDouble(CouponInfo["Reduce"]);
            gradeName = WeiXinPublic.ConvertHelper.ToString(CouponInfo["GradeName"]);
        }
    }

    if (graderate > 0)
    {
        graderate = graderate / 10;
    }

    int coupon = WeiXinPublic.ConvertHelper.ToInt(CouponInfo["CouPon"]);
    int isVip = WeiXinPublic.ConvertHelper.ToInt(CouponInfo["IsVip"]);


    bool hasconfirm = !(order.ConfirmOrderDate.CompareTo(Convert.ToDateTime("1900-01-01 01:00:00")) == 0); //是否已确认了
    int paytype = WeiXinPublic.ConvertHelper.ToInt(order.PayType);
    bool haspay = order.AliTradeStatus.Equals("TRADE_FINISHED") && order.AliPayAmount > 0;

    WeiXin.Models.Home.Room room = ViewData["room"] as WeiXin.Models.Home.Room;
    string hoteltel = ViewData["hoteltel"].ToString();
    string address = ViewData["address"].ToString();

    string breakfast = "--";
    if (order.IsHourRoom == 0 && order.RatePlanName.Contains("("))
    {
        Match match_breakfast = Regex.Match(order.RatePlanName, @"[\s\S]*\(([\s\S]*?)\)");
        breakfast = match_breakfast.Groups[1].Value;

    }
    string waitconfirmtime = null;
    if (!hasconfirm)
    {
        if (order.YinDate.Date.CompareTo(order.OrderTime.Date) == 0)
        {
            if (paytype == 0)
            {
                waitconfirmtime = order.AliPayTime.AddHours(2).ToString("HH:mm") + "前";
            }
            else
            {
                waitconfirmtime = order.OrderTime.AddHours(2).ToString("HH:mm") + "前";
            }
        }
        else
        {
            waitconfirmtime = "次日11点前";
        }
    }
    string stateAry = "{ 1: '待确认', 2: '取消', 3: '处理中', 6: '预订成功', 7: '处理中', 9: '已离店', 22: '预订失败' }";
    Dictionary<int, string> statedic = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<int, string>>(stateAry);
    string bookmessage = null;
    string statestr = null;
    string persiststr = null;
    switch (paytype)
    {
        //预付
        case 0:
            {
                if (order.State == 2 || order.State == 22 || order.State == 9)
                {
                    //取消/预订失败/已离店
                    statestr = statedic[order.State];

                    //付款后预订失败，未退款，显示待退款
                    if (order.State == 22 && (order.AliPayAmount != order.RefundFee))
                    {
                        statestr = "待退款";
                    }
                }
                else
                {
                    if (!haspay)
                    {
                        //未付款的待处理订单
                        statestr = "待支付";
                        bookmessage = "酒店将为您保留30分钟，请在" + order.OrderTime.AddMinutes(30).ToString("M月d日 HH:mm") + "前完成在线支付。如超时未支付订单将自动取消。";
                    }
                    else
                    {
                        if (hasconfirm)
                        {
                            //付款已确认订单
                            statestr = "预订成功";
                            bookmessage = string.Format("房间为您保留到{0}的中午12:00", order.YoutDate.ToString("M月d日"));
                        }
                        else
                        {
                            //付款待确认订单
                            statestr = "待确认";
                            bookmessage = string.Format("订单会在{0}完成确认，请稍等片刻，紧急请直接联系酒店", waitconfirmtime);
                        }
                    }
                }
                if (!(order.State == 2 || order.State == 22))
                {
                    if (order.IsHourRoom == 1)
                    {
                        persiststr = "预订成功后，房间将保留到入住当天" + order.HourEndTime;
                    }
                    else
                    {
                        persiststr = "预订成功后，房间将整晚保留";
                    }
                }
            }
            break;
        case 1:
            {
                if (order.State == 2 || order.State == 22 || order.State == 9)
                {
                    statestr = statedic[order.State];
                }
                else
                {
                    if (hasconfirm)
                    {
                        //现付已确认订单
                        statestr = "预订成功";
                        bookmessage = string.Format("房间为您保留到{0}的中午12:00", order.YoutDate.ToString("M月d日"));
                    }
                    else
                    {
                        //现付未确认订单
                        statestr = "待确认";
                        bookmessage = string.Format("订单会在{0}完成确认，请稍等片刻，紧急请直接联系酒店", waitconfirmtime);
                    }
                }
                if (!(order.State == 2 || order.State == 22))
                {
                    persiststr = "预订成功后，房间将保留到入住";
                    if (order.LastTime.Hour <= 6)
                    {
                        persiststr += "次日凌晨" + order.LastTime.ToString("HH:mm");
                    }
                    else
                    {
                        persiststr += "当天" + order.LastTime.ToString("HH:mm");
                    }
                }
            }
            break;
        default:
            break;
    }



    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", hotelweixinid);
    viewDic.Add("hId", hid);
    viewDic.Add("uwx", userweixinid);
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
    <title>订单详情</title>
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/order-details.css" />
    <link href="http://css.weikeniu.com/css/newpay.css" rel="stylesheet" type="text/css" />
    <link href="http://css.weikeniu.com/css/msgbox_ui.css?v=1.0" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #icolist li
        {
            display: none;
        }
    </style>
    <script src="http://js.weikeniu.com/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
</head>
<body>
    <section class="yu-bgblue od-top yu-pad10">
    <h1>
        <label class="statestr">
        <%=statestr %>
        </label>
    </h1>
    <p class="bookmessage" style="<%=string.IsNullOrEmpty(bookmessage) ? "display:none" : ""%>">
        <%=bookmessage %></p>
    </section>
    <section class="main">
     <%if (order.sSumPrice > 0)
       { %>
    <div class="yu-grid yu-bor bbor yu-h60 yu-line60 yu-lrpad10">   
        <div class="yu-overflow yu-grid">
            <p class="yu-orange yu-rmar10">
                <span class="paytypestr"><%=paytype == 1 ? "前台支付" : "在线支付"%></span>￥<span class="yu-font20 price"><%=order.sSumPrice%></span></p>
            <p class="yu-grey yu-font14" style="display: none">
                <label class="paystatestr">
                </label>
            </p>
        </div>
        <div class="yu-font14 yu-blue yu-arr type-down yu-rpad20" id="showdetail">
            费用明细</div>
        
    </div>
        <%} %>
    <div>
        <div class="pay-detail sp">
            <div class="yu-pad20">
                <ul class="pay-dateil-list">
                    <li class="yu-grid">
                        <p>
                             <label class="paytypestr">
                             <%=paytype==1 ? "前台支付" : "在线支付"%>
                             </label></p>
                        <p class="yu-overflow">
                            &nbsp;</p>
                        <p class="orange">
                            ￥<label class="actualprice"><%=order.sSumPrice %></label></p>
                    </li>
                    <li class="yu-grid">
                        <p class="yu-greys">
                            房费(<label class="dayrooms"><%=order.IsHourRoom == 1 ? string.Format("{0}间 X {1}小时", order.YRoomNum, order.Hours) : string.Format("{0}间 X {1}晚", order.YRoomNum, (order.YoutDate - order.YinDate).Days)%></label>)</p>
                        <p class="yu-overflow yu-nowrap yu-greys">
                            ----------------------------------------------------------------------------------------</p>
                        <p class="yu-greys <%=graderate>0?"yu-linet":"" %>">
                            ￥<label class="alloriginalprice"><%=order.ySumPrice %></label></p>
                    </li>
                    <%if (graderate > 0 || reduce > 0)
                      {
                      %>
                    <li class="yu-grid">
                        <p class="yu-greys">
                            <%=gradeName%><%=couponType==0  ? "折扣价" :"立减价"%></p>
                        <p class="yu-overflow yu-nowrap yu-greys">
                            ----------------------------------------------------------------------------------------</p>
                        <p class="orange">
                            <label class="discountprice">
                            <% if (couponType == 0)
                               { %>
                            <%=string.Format("{0} * {1} = {2}", order.ySumPrice, graderate, order.sSumPrice + coupon)%>
                            <%}
                               else
                               { %>

                               <%=string.Format("{0} - {1} = {2}", order.ySumPrice, Convert.ToInt32(reduce) * order.YRoomNum, order.sSumPrice + coupon)%>
                            <%} %>
                            </label>
                        </p>
                    </li><%
                             } %>
<%if (coupon > 0)
  { 
                               %><li class="yu-grid">
                        <p class="yu-greys">
                            使用红包抵扣</p>
                        <p class="yu-overflow yu-nowrap yu-greys">
                            ----------------------------------------------------------------------------------------</p>
                        <p class="yu-greys">
                            -￥<label class="couponprice"><%=coupon%></label></p>
                    </li><%
                             } %>
                    <%if (order.Foregift > 0)
                      { 
                      %><li class="yu-grid">
                        <p class="yu-greys">
                            提前交酒店押金</p>
                        <p class="yu-overflow yu-nowrap yu-greys">
                            ----------------------------------------------------------------------------------------</p>
                        <p class="yu-greys">
                            ￥<label class="foregift"><%=order.Foregift %></label></p>
                    </li><%
                             } %>
                </ul>
            </div>
        </div>
    </div>
    <% if (!(order.State == 2 || order.State == 22 || order.State == 9 || (paytype == 1 && hasconfirm)))
       {
       %>
       <div class="yu-pad10 yu-bor bbor" id="icolist">
        <ul>
            <%--预付:付款已确认--%>            
            <li class="afterpayico" style="<%=paytype == 0 && haspay && hasconfirm ? "display:block;" : ""%>">
                <p class="orderico type6">
                    <span></span>不可取消或变更</p>
            </li>
            <%--预付:付款未确认--%>
            <li class="beforepayico" style="<%=paytype == 0 && haspay && !hasconfirm ? "display:block;" : ""%>">
                <p class="orderico type6">
                    <span></span>不可取消或变更</p>
            </li>


            <%--现付:未确认--%>
            <li class="cancelico" style="<%=(paytype==1&&!hasconfirm) ? "display:block;" : ""%>">
                <p class="orderico type3">
                    <span></span>免费取消</p>
            </li>

                 <%--预付:未付款--%>
                   <li class="cancelico" style="<%=(paytype==0&&!haspay) ? "display:block;" : ""%>">
                <p class="orderico type6">
                    <span></span>预订后不可以取消或变更</p>
            </li>



            <%--预付:未确认--%>
            <li class="jishiico" style="<%=paytype == 0 && !hasconfirm ? "display:block;" : ""%>;display:none">
                <p class="orderico type1">
                    <span></span>立即确认</p>
            </li>
            <%--预付:带押金且已付款--%>
            <li class="foregiftico" style="<%=paytype == 0 && haspay && hasconfirm && order.Foregift>0 ? "display:block;" : ""%>">
                <p class="orderico type7">
                    <span></span>离店退押金</p>
            </li>
        </ul>
    </div><%
              } %>
   
    <div class="yu-pad10 yu-bor bbor yu-overflow">

     <% if (!(order.State == 2 || order.State == 22) && ((paytype == 0 && !haspay) || paytype == 1))
        {
       %>
    <% if (paytype == 0 && !haspay && order.sSumPrice > 0)
       {
       %><a href="javascript:;" class="order-btn type1 prepaybtn">去支付</a><%
                                                                             } %>
        <%if ((paytype == 0 && !haspay) || (paytype == 1 && !(order.State == 11 || order.State == 9)))
          {
          %><a href="javascript:;" class="order-btn type2 cancelbtn">取消订单</a><%
                                                                                 } %>

        <% }%>
        <% if (order.State == 9 && order.isMeeting == "0" && ViewData["commentopen"] != null && ViewData["commentopen"].ToString() == "1")
           { %>

           <% if (Convert.ToInt32(ViewData["comment"]) == 0)
              { %>
          <a href="/Hotel/Comment/<%=hid %>?key=<%=key %>&orderId=<%=order.ID%>&RoomType=<%=order.RoomName %>" class="order-btn type1">待点评</a>
          <%}
              else
              { %>

            <a href="javascript:void(0)" class="order-btn type2">已点评</a>
          <%} %>
         

        <%} %>

        
    </div>
    </section>
    <section class="main yu-bmar10">
    <div class="yu-grid yu-bor tbbor">
        <a class="yu-bor rbor yu-overflow yu-textc yu-tbpad10 hoteltel" href="tel://<%=hoteltel%>">
            <p class="yu-font16 yu-greys">
                联系酒店</p>
        </a>
    </div>
    </section>
    <section class="main yu-bmar10 yu-lrpad10 yu-bor tbbor">
    <div class="yu-bor bbor yu-tbpad10">
        <p class="yu-bmar5">
            <span class="hotelname"><%=order.HotelName %></span>
        </p>
        <p class="yu-grey yu-font14">
            <span class="address"><%=address %></span>
        </p>
    </div>
    <div class=" yu-tbpad10 copy-info">
        <p class="yu-bmar5">
            <span class="roomname"><%=order.IsHourRoom == 1 ? string.Format("{0}-{1}", order.RoomName, order.Hours + "小时钟点房") : string.Format("{0}-{1}", order.RoomName, order.RatePlanName.Replace("(" + breakfast + ")", ""))%></span>
        </p>
        <div>
            <p class="yu-grey yu-font14 paytype">
                <%=persiststr%></p>
            <p class="yu-grey yu-font14">
                入住：<span class="indate"><%=order.IsHourRoom == 1 ? string.Format("{0} {1}", order.YinDate.ToString("M月d日"), order.HourStartTime) : order.YinDate.ToString("M月d日")%></span>，离店：<span class="outdate"><%=order.IsHourRoom == 1 ? order.HourEndTime : order.YoutDate.ToString("M月d日")%></span> 共<span class="days"><%=order.IsHourRoom == 1 ? string.Format("{0}小时", order.Hours) : string.Format("{0}晚", order.Days)%></span>*<span
                    class="roomnum"><%=order.YRoomNum %></span>间</p>
            <p class="yu-grey yu-font14">
                早餐：<span class="breakfast"><%=breakfast %></span>，宽带：<span class="nettype"><%=room.NetType %></span></p>
            <p class="yu-grey yu-font14">
                床型：<span class="bedtype"><%=room.BedType %></span>，加床：<span class="addbed"><%=room.AddBed %></span></p>
            <p class="yu-grey yu-font14">
                入住人：<span class="username"><%=order.UserName %></span>
            </p>
            <p class="yu-grey yu-font14">
                手机号：<span class="linktel"><%=order.LinkTel %></span>
            </p>
        </div>
    </div>
    </section>
    <section class="main yu-lrpad10 yu-bor tbbor">
    <dl>
        <dt class="yu-bor bbor yu-line40">订单信息</dt>
        <dd class="yu-grey yu-font14 yu-tbpad10">
            <p>
                订单号：<span class="orderno"><%=order.OrderNO %></span></p>
            <p>
                下单时间：<span class="ordertime"><%=order.OrderTime %></span></p>
        </dd>
    </dl>
    <%if (order.NeedInvoice == 1)
      {
      %>
    <dl id="invoiceinfo">
        <dt class="yu-bor bbor yu-line40">发票信息</dt>
        <dd class="yu-grey yu-font14 yu-tbpad10">
            <p>
                发票金额：￥<span class="invoincemoney"><%=order.sSumPrice-order.Foregift %></span>（票面金额）</p>
            <p>
                发票抬头：<span class="invoincetitle"><%=order.InvoiceTitle %></span></p>

                  <p>
                税号：<span class="invoincetitle"><%=order.InvoiceNum %></span></p>
        </dd>
    </dl><%
             } %>
    </section>
    <%Html.RenderPartial("Footer", viewDic); %>
</body>
</html>
<script type="text/javascript">
    var sys_hid = '<%=hid %>';
    var sys_hotelweixinid = '<%=hotelweixinid %>';
    var sys_userweixinid = '<%=userweixinid %>';
    var sys_orderid = '<%=orderid %>';
    var sys_orderno = '<%=order.OrderNO %>';
</script>
<script src="http://js.weikeniu.com/Scripts/m.hotel.com.core.min.js" type="text/javascript"></script>
<script type="text/javascript">
    var orderjson = {};

    $(function () {
        //        getorderinfo();
    });

    function getorderinfo() {
        $.ajax({
            url: '/action/getorderinfo',
            type: 'post',
            data: { hid: sys_hid, hotelweixinid: sys_hotelweixinid, userweixinid: sys_userweixinid, orderid: sys_orderid },
            success: function (data) {
                $('.foregiftico').hide(); //预付:带押金且已付款
                $('.beforepayico').hide(); //预付:付款未确认
                $('.cancelico').hide(); //预付:未付款/现付:未确认
                $('.jishiico').hide(); //预付:未确认
                $('.afterpayico').hide(); //预付:付款已确认

                var _json = $.parseJSON(data);
                orderjson = _json['order'];
                var paytype = parseInt(orderjson['PayType']);
                var state = orderjson['State'];
                var stateAry = { 1: '待确认', 2: '取消', 3: '处理中', 6: '预订成功', 7: '处理中', 9: '已离店', 22: '预订失败' };
                var statestr = '';
                var paytypestr = '';
                var bookmessage = '';
                switch (paytype) {
                    case 0:
                        {
                            paytypestr = '在线支付';
                            if (state == 2 || state == 22 || state == 9) {
                                //取消/预订失败/已离店
                                statestr = stateAry[state];

                                //付款后预订失败，未退款，显示待退款
                                if (state == 22 && (orderjson['AliPayAmount'] != orderjson['RefundFee'])) {
                                    statestr = '待退款';
                                }
                            } else {
                                if (!(orderjson['AliTradeStatus'] == 'TRADE_FINISHED' && orderjson['AliPayAmount'] > 0)) {
                                    //未付款的待处理订单
                                    statestr = '待支付';
                                    bookmessage = '酒店将为您保留30分钟，请在' + _json['lasttime'] + '前完成在线支付。如超时未支付订单将自动取消。';
                                } else {
                                    if (_json['hasconfirm']) {
                                        //付款已确认订单
                                        statestr = '预订成功';
                                        bookmessage = '房间为您保留到' + _json['outdate'] + '的中午12:00';
                                    } else {
                                        //付款待确认订单
                                        statestr = '待确认';
                                        bookmessage = '订单会在' + _json['waitconfirmtime'] + '完成确认，请稍等片刻，紧急请直接联系酒店';
                                    }
                                }
                            }
                        }
                        break;
                    case 1:
                        {
                            paytypestr = '前台支付';
                            if (state == 2 || state == 22 || state == 9) {
                                statestr = stateAry[state];
                            } else {
                                if (_json['hasconfirm']) {
                                    statestr = '预订成功';
                                    bookmessage = '房间为您保留到入住当天' + _json['lasttime'];
                                } else {
                                    statestr = '待确认';
                                    bookmessage = '订单会在' + _json['waitconfirmtime'] + '完成确认，请稍等片刻，紧急请直接联系酒店';
                                }
                            }
                        }
                        break;
                }
                if (state == 2 || state == 22) {
                    bookmessage = '订单已取消，需要请先重新预订';
                }
                if (state == 9) {
                    bookmessage = '房间已经成功入住，期待您再次入住';
                }
                $('.paytypestr').text(paytypestr);
                $('.statestr').text(statestr);
                if (bookmessage != '') {
                    $('.bookmessage').text(bookmessage).show();
                }

                if (!(state == 2 || state == 22 || state == 9)) {
                    if (paytype == 1) {
                        if (!_json['hasconfirm']) {
                            $('.cancelbtn').show();
                            $('.prepaybtn').closest('div').show();
                            $('.cancelico').show();
                        }
                    } else if (paytype == 0) {
                        var paystatestr = '';
                        if (!(orderjson['AliTradeStatus'] == 'TRADE_FINISHED' && orderjson['AliPayAmount'] > 0)) {
                            $('.prepaybtn').show();
                            $('.cancelbtn').show();
                            $('.prepaybtn').closest('div').show();
                            paystatestr = '未支付';
                            $('.cancelico').show();
                        } else {
                            paystatestr = '已支付';
                            if (orderjson['Foregift'] > 0) {
                                $('.foregiftico').show();
                            }
                            if (_json['hasconfirm']) {
                                $('.afterpayico').show();
                            } else {
                                $('.beforepayico').show();
                            }
                        }
                        if (!_json['hasconfirm']) {
                            $('.jishiico').show();
                        }
                        $('.paystatestr').text(paystatestr);
                        //                        $('.paystatestr').closest('p').show();
                    }
                }
                if ($('#icolist ul li:visible').length > 0) {
                    $('#icolist').show();
                }

                if (orderjson['Foregift'] > 0) {
                    $('.foregift').text(orderjson['Foregift']);
                    $('.pay-detail .foregift').closest('li').show();
                }

                $('.price').text(orderjson['sSumPrice']);
                var needinvoice = parseInt(orderjson['NeedInvoice']);
                if (needinvoice == 1) {
                    $('.invoincetitle').text(orderjson['InvoiceTitle']);
                    $('.invoincemoney').text(orderjson['sSumPrice'] - orderjson['Foregift']);
                    $('#invoiceinfo').show();
                }
                $('.ordertime').text(_json['ordertime']);
                $('.orderno').text(orderjson['OrderNO']);
                $('.indate').text(_json['indate']);
                $('.outdate').text(_json['outdate']);
                $('.roomnum').text(orderjson['YRoomNum']);
                var breakfast = '';
                var roomname = '';
                if (orderjson['IsHourRoom'] == 1) {
                    breakfast = '--';
                    roomname = orderjson['RoomName'] + '--' + orderjson['Hours'] + '小时钟点房';
                    $('.days').text(orderjson['Hours'] + '小时');
                    $('.dayrooms').text(orderjson['YRoomNum'] + '间 X ' + orderjson['Hours'] + '小时');
                } else {
                    breakfast = orderjson['RatePlanName'].toString().substr(orderjson['RatePlanName'].toString().length - 3, 2);
                    var rateplanname = orderjson['RatePlanName'].toString().replace('(' + breakfast + ')', '');
                    roomname = orderjson['RoomName'] + '--' + rateplanname;
                    $('.days').text(orderjson['Days'] + '晚');
                    $('.dayrooms').text(orderjson['YRoomNum'] + '间 X ' + orderjson['Days'] + '晚');
                }
                $('.breakfast').text(breakfast);
                $('.roomname').text(roomname);
                $('.nettype').text(_json['room']['NetType']);
                var bedtype = _json['room']['BedType'];
                if (bedtype == '' || bedtype == null) {
                    bedtype = '--';
                }
                $('.bedtype').text(bedtype);
                var addbed = _json['room']['AddBed'];
                if (addbed == '' || addbed == null) {
                    addbed = '--';
                }
                $('.addbed').text(addbed);
                $('.username').text(orderjson['UserName']);
                $('.linktel').text(orderjson['LinkTel']);
                $('.hotelname').text(orderjson['HotelName']);
                $('.address').text(_json['address']);
                $('.hoteltel').attr('href', 'tel://' + _json['hoteltel']);
                $('.actualprice').text(orderjson['sSumPrice']);
                $('.alloriginalprice').text(orderjson['ySumPrice']);
                var couponinfo = $.parseJSON(orderjson['CouponInfo']);
                if (couponinfo['GradeRate'] != undefined && couponinfo['GradeRate'] > 0) {
                    var saleprice = orderjson['sSumPrice'] + couponinfo['CouPon'];
                    var graderate = couponinfo['GradeRate'] / 10;
                    $('.discountprice').text(orderjson['ySumPrice'].toString() + ' * ' + graderate.toString() + ' = ' + saleprice.toString());
                    $('.discountprice').closest('li').show();
                    $('.alloriginalprice').closest('p').addClass('yu-linet');
                }
                if (couponinfo['CouPon'] != undefined && couponinfo['CouPon'] > 0) {
                    $('.couponprice').text(couponinfo['CouPon']);
                    $('.couponprice').closest('li').show();
                }
            }
        });
    }

    $('.cancelbtn').click(function () {
        $.ajax({
            url: '/action/cancelOrder',
            type: 'post',
            data: { id: sys_orderid, hotelweixinid: sys_hotelweixinid, userweixinid: sys_userweixinid },
            success: function (data) {
                var _json = $.parseJSON(data);
                if (_json['success']) {
                    $('#icolist').hide();
                    $('.cancelbtn').closest('div').hide();
                    $('.statestr').text('取消');
                    $('.bookmessage').text('订单已取消，需要请先重新预订');
                    $('.bookmessage').show();
                }
                WXweb.utils.MsgBox(_json['message']);
            }
        });
    });

    $('.prepaybtn').click(function () {
        //        window.location.href = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx4231803400779997&redirect_uri=http%3a%2f%2fhotel.weikeniu.com%2fWeiXinZhiFu%2fwxOAuthRedirect.aspx&response_type=code&scope=snsapi_base&state=' + sys_orderno + '#wechat_redirect';

        window.location.href = '/recharge/CardPay/<%=hid%>?key=<%=hotelweixinid %>@<%=userweixinid %>&orderno=' + sys_orderno;
    });

    $('#showdetail').parent().click(function () {
        $(".pay-detail").fadeToggle();
        $(this).toggleClass("type-up")
    })
</script>
