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


    var db = ViewData["db"] as System.Data.DataTable;

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();
 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>预约发票</title>
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
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/css/booklist/jquery-ui.js"></script>
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

            			<section class="content2">
                     <p class="ca-nao-weak">预约发票
                     <a href="javascript:window.location.href='/zhinengA/FaPiaoManager/<%=hotelid%>?key=<%=weixinID %>@<%= userWeiXinID%>';" class="calManager">管理抬头</a>
                     </p>
				     <div class="ca-other-goods rseation-invoice" >
                           <ul>

                             <li class="ca-displayfx qu_fap-type"><span><h1>发票类型</h1><i></i></span><input type="text" placeholder="请选择发票类型" readonly="readonly" id="fp_type" /><b class="f_invoicenames" ></b></li> 
                         
                               <li class="ca-displayfx"><span><h1>公司抬头</h1><i>*</i></span><input type="text" placeholder="请输入公司抬头"  id="head_compnay"/><b class="invoicenames" style="<%= db.Rows.Count==0 ? "display:none" : ""  %>"></b></li>

                                <li class="ca-displayfx"><span><h1>企业税号</h1><i>*</i></span><input type="text" placeholder="请输入企业税号" id="fapiao_no"/></li>
                                  <li class="ca-displayfx" style="<%=Request.QueryString["s"]=="1" ? "" : "display:none" %>"><span><h1>房号</h1><i>*</i></span><input type="text" placeholder="请输入房号" id="roomno"/></li>
                                     <li class="ca-displayfx" style="<%=Request.QueryString["s"]=="1" ? "" : "display:none" %>"><span><h1>入住人</h1><i>*</i></span><input type="text" placeholder="请输入入住人" id="checkinperson"/></li>
         <li class="ca-displayfx data-select" style="<%=Request.QueryString["s"]=="1" ? "" : "display:none" %>"><span><h1>入住日期</h1><i>*</i></span><input type="text" placeholder="请输入入住日期" id="checkindate"/><b></b></li>

                            
                                <li class="ca-displayfx"><span><h1>联系电话</h1><i>*</i></span><input type="text" placeholder="请输入联系电话"  class="phonenum-input phonenumber" /></li>          
                          <li class="ca-displayfx custum-last-li"><span><h1>开票金额</h1><i>*</i></span><input type="text" placeholder="请输入开票金额"  id="fp_money"/></li> 
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
            </section>


            <!--弹窗-->	
        <section class="mask lasttime-mask">
            <div class="mask-bottom-inner yu-bgw">
                <p class="yu-h110r yu-l110r yu-textc yu-bor bbor yu-f34r">抬头名称</p>
                <ul class="yu-lrpad10 yu-c99 hongbao-select t_hongbao-select">

                  <% for (int i = 0; i < db.Rows.Count; i++)
                     { %>
                            
                    <li class="yu-h120r yu-grid yu-alignc yu-bor bbor" data-taxnum="<%=db.Rows[i]["taxnum"].ToString()%>"  data-linktel=" <%=db.Rows[i]["linktel"].ToString()%>">
                        <div class="yu-overflow yu-f30r headname">
                           <%=db.Rows[i]["name"].ToString()%>
                        </div>
                        <p class="copy-radio"></p>
                    </li>

                    <%} %>
                
                </ul>
                <div class="yu-h120r yu-bg40 yu-white yu-l120r yu-textc mask-close yu-f30r">关闭</div>
            </div>
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

                <!--发票类型弹窗-->	
        <section class="mask chosePiaoType">
            <div class="mask-bottom-inner yu-bgw">
                <p class="yu-h110r yu-l110r yu-textc yu-bor bbor yu-f34r">发票类型</p>
                <ul class="yu-lrpad10 yu-c99 hongbao-select f_hongbao-select">               
                    <li class="yu-h120r yu-grid yu-alignc yu-bor bbor">
                        <div class="yu-overflow yu-f30r ftypename">
                            增税-普通发票
                        </div>
                        <p class="copy-radio"></p>
                    </li>
                    <li class="yu-h120r yu-grid yu-alignc yu-bor bbor">
                        <div class="yu-overflow yu-f30r  ftypename">
                           增税-专用发票
                        </div>
                        <p class="copy-radio"></p>
                    </li>
                </ul>
                <div class="yu-h120r yu-bg40 yu-white yu-l120r yu-textc mask-close yu-f30r">关闭</div>
            </div>
        </section>
            </article>
 
    <script>

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
            minDate: '-2m',
            maxDate: '1m',
            numberOfMonths: 2,
            showButtonPanel: false,
            onSelect: function (date, me) {

                $("#checkindate").val(date);

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



        //发票选择类型
              $(".qu_fap-type").click(function(){
				$(".chosePiaoType").fadeIn();
				$(".mask-bottom-inner").addClass("shin-slide-up");
				});


        $(".invoicenames").click(function () {
            $(".lasttime-mask").fadeIn();
            $(".mask-bottom-inner").addClass("shin-slide-up");
        });
        //抬头弹窗控制

        //选择抬头
        $(".t_hongbao-select>li").on("click", function () {

            $(this).addClass("cur").siblings().removeClass("cur");

            $("#head_compnay").val($(this).find(".headname").text().trim());
            $("#fapiao_no").val($(this).attr("data-taxnum"));
            $(".phonenumber").val($(this).attr("data-linktel"));


        });


        //选择发票类型
        $(".f_hongbao-select>li").on("click", function () {

            $(this).addClass("cur").siblings().removeClass("cur");
            $("#fp_type").val($(this).find(".ftypename").text().trim());


        });

        $(".mask-close,.mask").click(function () {
            $(".mask").fadeOut();
        });
        $(".mask-bottom-inner").on("click", function (e) {
            e.stopPropagation();
        });

        //只能输入数字
        $(".phonenum-input").keyup(function () {
            this.value = this.value.replace(/[^\d]/g, '');
        })


        if ($(".hongbao-select>li").length > 0) {
            $($(".hongbao-select>li")[0]).trigger("click");
        }


        $('.btn-save').click(function () {

            if ($("#fp_type").val().trim() == "") {
                layer.msg("请选择发票类型");
                return false;
            }

            if ($("#fapiao_no").val().trim() == "") {
                layer.msg("请输入企业税号");
                return false;
            }

            if ($("#head_compnay").val().trim() == "") {
                layer.msg("请输入公司抬头");
                return false;
            }

            if ('<%=Request.QueryString["s"] %>' == "1") {

                if ($("#roomno").val().trim() == "") {
                    layer.msg("请输入房号");
                    return false;
                }

                if ($("#checkinperson").val().trim() == "") {
                    layer.msg("请输入入住人");
                    return false;
                }

                if ($("#checkindate").val().trim() == "") {
                    layer.msg("请输入入住日期");
                    return false;
                }

            }


            var phonenumber = $('.phonenumber').val().trim();
            if (!/^1\d{10}$/.test(phonenumber)) {
                layer.msg("请输入正确手机号");
                return false;
            }



            if ($("#fp_money").val().trim() == "") {
                layer.msg("请输入开票金额");
                return false;
            }

            if (isNaN($("#fp_money").val().trim())) {
                layer.msg("请输入正确的开票金额");
                return false;
            }

            $(".btn-save").attr("disabled", true);


            $.ajax({
                url: '/zhinengA/AddEditServices',
                type: 'post',
                data: { hotelId: '<%=hotelid %>', key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', fpmoney: $("#fp_money").val().trim(), hotelservice: $("#fapiao_no").val().trim(), phonenumber: $(".phonenumber").val().trim(), goods: $("#head_compnay").val().trim(), roomno: $("#roomno").val().trim(), username: $("#checkinperson").val().trim(), servicetime: $("#checkindate").val().trim(), type: "6", fType: $("#fp_type").val().trim() },
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

    </script>
</body>
</html>
