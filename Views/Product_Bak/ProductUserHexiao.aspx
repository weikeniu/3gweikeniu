<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
    var order = ViewData["Order"] as WeiXin.Models.Home.SaleProducts_Orders;

    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string hotelid = RouteData.Values["id"].ToString();
    string userWeiXinID = "";
    userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
    if (weixinID.Equals(""))
    {
        string key = HotelCloud.Common.HCRequest.GetString("key");
        string[] a = key.Split('@');
        weixinID = a[0];
        userWeiXinID = a[1];
    }


    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotelid);
    viewDic.Add("uwx", userWeiXinID);


    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <link href="<%=ViewData["cssUrl"]%>/css/css.css" rel="stylesheet" type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/productIndex.css" rel="stylesheet"
        type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/productList.css" rel="stylesheet"
        type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/ProductOrder.css" rel="stylesheet"
        type="text/css" />
    <script src="<%=ViewData["jsUrl"]%>/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/ProductYu/jquery-ui.css"
        rel="stylesheet" type="text/css" />
    <script src="<%=ViewData["jsUrl"]%>/Content/ProductIndex/ProductYu/jquery-ui.js"
        type="text/javascript"></script>
    <script src="<%=ViewData["jsUrl"]%>/Scripts/layer/layer.js" type="text/javascript"></script>
    <title>用户预约团购订单</title>
    <style>
        .msgbox-ui
        {
            z-index: 9999999;
            position: fixed !important;
            top: 27%;
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
        .msgbox-ui h1
        {
            display: block;
            text-align: center;
            color: #fff;
            font-size: 13px;
        }
        .msgbox-ui
        {
            max-width: 190px;
            min-width: 150px;
        }
    </style>
</head>
<body style="background: #00a0e9">
    <div class="banner cl">
        <ul>
            <li><a href="javascript:void(0)" onclick="history.go(-1)">
                <img src="/img/left_03.png" /></a></li>
            <li class="zhong">预约团购订单 </li>
            <li><a href="/home/main/<%=hotelid%>?key=<%=weixinID %>@<%=userWeiXinID %>">
                <img src="/img/home_05.png" /></a></li></ul>
    </div>
    <div class="base-page list2">
        <div class="back" onclick="location.href='order-list.html'" style="border-color: #fff;">
        </div>
        <div class="top" style="background: none; color: #fff; border: 0; display: none">
            预约团购订单</div>
        <div class="order-info-box sp">
            <ul class="yu-bmar30">
                <li class="yu-grid yu-line40 yu-border-b">
                    <p class="yu-grey yu-font14 yu-dt">
                        订单名称：</p>
                    <p class="yu-overflow">
                        <%=order.ProductName %></p>
                </li>
                <li class="yu-grid yu-line40 yu-border-b">
                    <p class="yu-grey yu-font14 yu-dt">
                        使用人：</p>
                    <input type="text" placeholder="请输入使用人" class="yu-overflow hexiao hexiaoma yuName" />
                </li>
                <li class="yu-grid yu-line40 yu-border-b">
                    <p class="yu-grey yu-font14 yu-dt">
                        使用日期：</p>
                    <input type="text" placeholder="请输入使用日期" class="yu-overflow hexiao hexiaoma yuDate book-date" />
                </li>
                <li class="yu-grid yu-line40 yu-border-b" style="display: none">
                    <p class="yu-grey yu-font14 yu-dt">
                        预约码：</p>
                    <input type="number" placeholder="请输入预约码" class="yu-overflow hexiao hexiaoma" />
                </li>
            </ul>
            <div class="yu-full-btn">
                <input type="button" value="确认" class="btn_hexiao">
            </div>
        </div>
    </div>
    <div class="date-page">
        <div class="back" style="border-color: #fff;">
        </div>
        <div class="top" style="background: none; color: #fff; border: 0">
            选择日期
        </div>
        <div id="datepicker">
        </div>
    </div>
    <script>



        var minTime = '<%=ViewData["effectiveBeginTime"]%>';
        var maxTime = '<%=ViewData["effectiveEndTime"]  %>';


        $(".btn_hexiao").click(function () {

            $(".btn_hexiao").attr("disabled", true);

            if ($(".yuName").val().trim() == "") {

                layer.msg('请输入使用人!');


                $(".btn_hexiao").attr("disabled", false);

                return false;

            }


            if ($(".yuDate").val().trim() == "") {
                layer.msg('请输入使用日期!');

                $(".btn_hexiao").attr("disabled", false);

                return false;
            }



            $.ajax({
                url: '/Product/HotelHexiaoMa',
                type: 'post',
                data: {
                    key: '<%=ViewData["key"]%>', OrderNO: '<%=Request.QueryString["OrderNo"]%>', yuName: $(".yuName").val().trim(), yuDate: $(".yuDate").val().trim()
                },
                dataType: 'json',
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {

                        layer.msg(ajaxObj.Mess);

                        setTimeout(function () { window.location.href = '/Product/ProductUserOrderDetail/<%=hotelid%>?key=<%=ViewData["key"]%>&OrderNO=<%=Request.QueryString["OrderNo"]%>'; }, 1000);


                    }

                    else {
                        $(".btn_hexiao").attr("disabled", false);
                        layer.msg(ajaxObj.Mess);
                    }
                }

            });

        });


        $("#datepicker").datepicker({
            dateFormat: 'yy-mm-dd',
            dayNamesMin: ["日", "一", "二", "三", "四", "五", "六"],
            monthNames: ["1月", "2月", "3月", "4月", "5月", "6月",
      "7月", "8月", "9月", "10月", "11月", "12月"],
            yearSuffix: '年',
            showMonthAfterYear: true,
            minDate: minTime,
            maxDate: maxTime,
            numberOfMonths: 2,
            showButtonPanel: false,
            onSelect: function (selectedDate) {
                sDate = selectedDate;
                // console.log(sDate);
                // $(".ui-datepicker-inline").width("100%");
                $(".base-page").show();
                $(".date-page").hide();
                $(".book-date").val(sDate);
                $(".banner").show();

            }
        });

        $(function () {



            $(".book-date").click(function () {
                $(".base-page").hide();
                $(".date-page").show();
                $(".banner").hide();
            })


            $(".date-page .back").click(function () {
                $(".base-page").show();
                $(".date-page").hide();
                $(".banner").show();


            });

        })
          
   
   
    </script>
</body>
</html>
