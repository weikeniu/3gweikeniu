<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
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
<head id="Head1" runat="server">
    <title>机场接送</title>
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/jquery-ui.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["jsUrl"] %>/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/css/booklist/jquery-ui.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
    <style>
        .room-num, .room-price-d
        {
            display: none;
        }
    </style>
</head>
<body>
    <!-- <>主体页面 -->
    <article class="full-page">	  

     <%Html.RenderPartial("HeaderA", viewDic);%>
  
		<!--//内容区-->
		<section class="show-body">


             		<section class="content2">
                     <p class="ca-nao-weak">机场接送</p>
                     <div class="ca-other-goods">
                           <ul>
                                <li class="ca-displayfx ca-mine-locationg">
                                           <span><h1>我的位置</h1><i>*</i></span>
                                           <div class="radio-chosed">
                                                <ul>
                                                    <li class="hotel"><p class="fl">酒店</p><em><div></div></em></li>
                                                    <li><p class="fl">机场</p><em><div></div></em></li>

                                                    </ul>
                                                </div>
                                                </li>
                                        
                             
                                <li class="ca-displayfx"><span><h1></h1><i></i></span><input type="text" id="a_address" placeholder="请输入具体位置"></li>
                                <li class="ca-displayfx lasttimeselect data-select"><span><h1>接送时间</h1><i>*</i></span><input type="text" placeholder="请选择日期" id="a_date" ><b></b></li>
                                <li class="ca-displayfx">                                
                                <span><h1>接送人数</h1><i>*</i></span>
                                <input type="text" placeholder="请输入人数" id="a_person">
                                </li>
                   <li class="ca-displayfx">
                   <span><h1>手机号</h1><i>*</i></span>
                        <input type="tel" placeholder="手机号" class="phonenum-input phonenumber">
                        <div class="ca-get-code" style="display:none">
                        <input type="button" value="获取验证码" id="btn_sendcode"  style="display:none">
                        <input type="button" value="30秒后重新发送"  id="P1" style="display:none"  /></div>
                       </li>

        

                              <li class="ca-displayfx custum-last-li" style="display:none"><span><h1>验证码</h1><i>*</i></span><input type="number" placeholder="请输入验证码"   id="yzmcode" /></li>      

                              
                                <li class="ca-displayfx">                                
                                <span><h1>航班信息</h1><i></i></span>
                                <input type="text" placeholder="请输入航班信息" id="airNum">
                                </li>
                           </ul>
                     </div>
                     <!--ca-other-goods end-->
                     <div class="uc__account-info">
                           <div class="submit-btn sp">
                                <input type="button" class="btn-save" value="提交" />
                           </div>
                     </div>
			</section>
            </section>
            
                <!--日历-->
    <section class="data-page">
			<div id="datepicker"></div>
			<div class="fix-bottom yu-bor tbor yu-grid yu-alignc yu-lrpad10 yu-h34r">
				<p class="yu-overflow" style="display:none">选择日期</p>
				<div  style="display:none" >
					<div class="yu-grid yu-alignc">
						<p class="data-btn cal yu-bor1 bor">取消</p>
						<p class="data-btn sub">确定</p>
					</div>
				</div>
			</div>
		</section>
                        </article>
    <script>
        $(".radio-chosed li").click(function () {
            $(this).addClass("font");
            $(this).siblings().removeClass("font");
        });
        var speciald = new Array();
        /*日期选择初始号*/
        var __drp;
        __drp = $("#datepicker").datepicker({
            dateFormat: 'yy-mm-dd',
            dayNamesMin: ["日", "一", "二", "三", "四", "五", "六"],
            monthNames: ["1月", "2月", "3月", "4月", "5月", "6月",
     "7月", "8月", "9月", "10月", "11月", "12月"],
            yearSuffix: '年',
            showMonthAfterYear: true,
            minDate: new Date(),
            maxDate: '+2m',
            numberOfMonths: 2,
            showButtonPanel: false,
            onSelect: function (date, me) {

                $("#a_date").val(date);

                $(".show-body").show();
                $("header").show();
                $(".data-page").hide();


                if (speciald.length < 1) {
                    //speciald.push(date);
                    if ($.inArray(date, speciald) == -1) {
                        speciald.push(date);
                    }

                    console.log(speciald)
                } else {
                    speciald.length = 0;
                    speciald.push(date);
                    console.log(speciald)
                }
            },
            beforeShowDay: function (date) {
                //格式化月份、日
                function formatDate(str) {
                    return str < 10 ? ("0" + str) : str;
                }
                var m = date.getMonth();
                var d = date.getDate();
                var y = date.getFullYear();
                var formatDate = y + "-" + formatDate(m + 1) + "-" + formatDate(d); //此处日期的格式化和speciald中的格式一样
                //inArray实现数组的匹配
                if ($.inArray(formatDate, speciald) != -1) {
                    //此处要返回一个数组，specialdays是添加样式的类
                    return [true, "specialdays", formatDate];
                }
                else {
                    return [true, '', ''];
                }
            }

        });



        $(function () {

            //选择日期
            $(".data-select").on("click", function () {
                $(".show-body").hide();
                $("header").hide();
                $(".data-page").show();
            })
            $(".data-btn.cal").click(function () {
                $(".show-body").show();
                $("header").show();
                $(".data-page").hide();
            })
        })


        function BindData() {

        }




        //只能输入数字
        $(".phonenum-input").keyup(function () {
            this.value = this.value.replace(/[^\d]/g, '');
        })


        $('.btn-save').click(function () {



            if ($(".ca-mine-locationg  .radio-chosed  li.font").length == 0) {
                layer.msg("请选择位置");
                return false;

            }

            if ($("#a_address").val().trim() == "") {
                layer.msg("请输入具体位置");
                return false;
            }

            if ($("#a_date").val().trim() == "") {
                layer.msg("请选择日期");
                return false;
            }

            if ($("#a_person").val().trim() == "") {
                layer.msg("请输入人数");
                return false;
            }


            var phonenumber = $('.phonenumber').val().trim();
            if (!/^1\d{10}$/.test(phonenumber)) {
                layer.msg("请输入正确手机号");
                return false;
            }


            //                if ($("#yzmcode").val().trim() == "") {
            //                    layer.msg("请输入验证码");
            //                    return false;
            //                }

            var myaddress ="从"+$(".ca-mine-locationg  .radio-chosed  li.font .fl").text().trim() + "到" + $("#a_address").val().trim();

            $(".btn-save").attr("disabled", true);




            $.ajax({
                url: '/zhinengA/AddEditServices',
                type: 'post',
                data: { hotelId: '<%=hotelid %>', key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', servicetime: $("#a_date").val(), roomno: myaddress, phonenumber: $(".phonenumber").val().trim(), remark: $("#a_person").val().trim(), yzmcode: $("#yzmcode").val().trim(),  goods:$("#airNum").val().trim(),type: "7" },
                dataType: 'json',
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {
                        layer.msg(ajaxObj.Mess);
                        setTimeout("window.location.href=window.location.href", 2000);
                    }

                    else {
                        layer.msg(ajaxObj.Mess);
                        $(".btn-save").attr("disabled", false);
                    }
                }


            });


        });


        $("#btn_sendcode").click(function () {

            var phonenumber = $('.phonenumber').val().trim();
            if (!/^1\d{10}$/.test(phonenumber)) {
                layer.msg("请输入正确手机号");
                return false;
            }

            $.ajax({
                url: '/zhinengA/SendMsg',
                type: 'post',
                data: { key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', mobile: $(".phonenumber").val().trim(), type: "air" },
                dataType: 'json',
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {
                        layer.msg(ajaxObj.Mess);
                        settime($("#btn_sendcode"));

                    }

                    else {
                        layer.msg(ajaxObj.Mess);

                    }
                }


            });

        });


        var countdown = 30;

        function settime(obj) {

            if (countdown == 0) {
                obj.css("display", "");
                $("#P1").css("display", "none");
                obj.val("获取验证码");
                countdown = 30;
                return;
            } else {
                obj.css("display", "none");

                $("#P1").css("display", "");
                $("#P1").val("" + countdown + "秒后重新发送");
                countdown--;
            }
            setTimeout(function () {
                settime(obj)
            }
    , 1000)
        }

 

    </script>
</body>
</html>
