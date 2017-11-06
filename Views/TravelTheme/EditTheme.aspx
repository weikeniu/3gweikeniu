<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    string css = System.Configuration.ConfigurationManager.AppSettings["cssUrl"];
    string js = System.Configuration.ConfigurationManager.AppSettings["jsUrl"];
        
         %>

<!DOCTYPE HTML>
<html>
<head>
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
<title>旅行社-约伴</title>
<link type="text/css" rel="stylesheet" href="<%=css %>/css/booklist/jquery-ui.css"/>
<link type="text/css" rel="stylesheet" href="<%=css %>/css/booklist/sale-date.css"/>

<link type="text/css" rel="stylesheet" href="<%=css %>/css/booklist/Restaurant.css"/>
<link type="text/css" rel="stylesheet" href="<%=css %>/css/booklist/new-style.css"/>

<link type="text/css" rel="stylesheet" href="<%=css %>/css/booklist/travel.css"/>
<link type="text/css" rel="stylesheet" href="<%=css %>/css/booklist/font/iconfont.css"/>
<link type="text/css" rel="stylesheet" href="<%=css %>/css/booklist/fontSize.css"/>
<link href="../../Scripts/webuploader/webuploader.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=js %>/Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=js %>/css/booklist/jquery-ui.js"></script>
<script type="text/javascript" src="<%=js %>/css/booklist/date-range-picker.js"></script>
<script type="text/javascript" src="<%=js %>/Scripts/fontSize.js"></script>
<script src="<%=js %>/Scripts/layer/layer.js" type="text/javascript"></script>
<script src="../../Scripts/webuploader/webuploader.js" type="text/javascript"></script>
<style>
    .specialdays.last::after{content:"结束"}
    .specialdays.first::after{content:"出发"}
	body{
		overflow: auto;
		max-width: 7.5rem;
	}
	.date-page{
		max-width: 7.5rem;
		margin: 0 auto;
	}
	.room-num{
		display: none;
	}
	#datepicker{
		max-width: 7.5rem;
		padding-bottom: 1.2rem;
		box-sizing: border-box;
	}
	.room-price-d{
		display: none;
	}
	.ui-datepicker td span, .ui-datepicker td a{
		line-height: 1.08rem;
	}
	#datepicker .specialdays a{
		line-height: .8rem;
	}
	.specialdays.first::after,.specialdays.last::after{
		top: .55rem;
	}
	.data-btn.sub{
		background: #12B7F5;
	}
	.ui-datepicker th{
		background: #12B7F5;	
		border:1px solid  #17a7d0;
	}
	.fix-bottom {
	    left: auto !important;
	    max-width: 750px;
	    height: 1.2rem;
	}
	.tab-nav.type3 > .cur{
		border-bottom: 0;
		height: 1rem;
		line-height: 1rem;
	}
</style>
</head>
<body class="yu-font12">
	<!--约伴-->
    <input type="hidden" id="hid_isstartcity" value="0"/><!--选择0出发还是2目的地-->
	<article class="partner-page base-page">
		<div class="partner-wrap yu-grid yu-grid-column">
			<div class="forms-box yu-flex1 yu-lrpad20r">
				<ul> 
					<li class="yu-grid yu-alignc">
						<label class="lbl yu-f28r">约伴主题</label> <input class="ipt_text yu-flex1" type="text" name="theme" id="theme"/>
					</li>
					<li class="yu-grid yu-alignc" id="J__startPlace"><label class="lbl yu-f28r">出发地</label> <em class="res yu-flex1"></em><i class="yu-arr" id="startcityid"></i></li>
					<li class="yu-grid yu-alignc" id="J__endPlace">
						<label class="lbl yu-f28r">目的地</label>
						<div class="yu-f28r yu-l70r yu-grid yu-w-full J__multiPlace">
							<span class="yu-c99 J__place yu-rpad20r yu-textr yu-flex1">可添加多个地点</span>
							<i class="icon-add yu-blue2"></i>
						</div>
						<div class="yu-f28r yu-l70r yu-grid yu-w-full J__multiPlace">
							<span class="J__place yu-rpad20r yu-flex1" id="endcityid">
								<%--<a class="plist"><em class="iconfont icon-dingwei1"></em>青海<i class="i_xx">×</i></a>
								<a class="plist"><em class="iconfont icon-dingwei1"></em>青海<i class="i_xx">×</i></a>
								<a class="plist"><em class="iconfont icon-dingwei1"></em>青海<i class="i_xx">×</i></a>
								<a class="plist"><em class="iconfont icon-dingwei1"></em>青海<i class="i_xx">×</i></a>--%>
							</span>
							<i class="icon-add yu-blue2" id="endcity_addid">+</i>
						</div>
					</li>
					<li class="yu-grid yu-alignc" id="J__travelDate"><label class="lbl yu-f28r">行程日期</label><em class="res yu-flex1"></em><i class="yu-arr" id="xingchendate"></i></li>
					<li class="yu-grid yu-alignc" id="J__setTime"><label class="lbl yu-f28r">集合时间</label> <em class="res yu-flex1"></em><i class="yu-arr" id="jihetime"></i></li>
					<li class="yu-grid yu-alignc" id="J__activityType"><label class="lbl yu-f28r">活动类型</label> <em class="res yu-flex1"></em><i class="yu-arr" id="themetype"></i></li>
					
					<li class="yu-grid yu-alignc yu-tbpad20r">
						<label class="yu-f28r">活动费用</label>
						<div class="activity-cost yu-flex1 J__activityCost">
							<i class="btn__avg cur" data-type="0">人均分摊</i><i class="btn__fixed" data-type="1">固定收费</i><i class="btn__free" data-type="2">免费</i>
						</div>
					</li>
					<li class="yu-grid yu-alignc">
						<div class="expect__input yu-flex1 yu-f28r">
							<span class="lbl_cost">人均分摊</span> 预计：<input class="ipt_cost" id="costmoney" type="number" />元/人
						</div>
					</li>
					
					<li class="yu-grid yu-alignc">
						<label class="lbl yu-f28r">人数限定</label> <input class="ipt_text yu-flex1" id="peoplenumber" type="number" name="memNumLimit" /> 
                        <!--<span class="yu-c99 yu-f28r">15人以内</span>-->
					</li>
					
					<li>
						<p class="yu-grid yu-f28r yu-l70r"><em class="yu-flex1">活动内容</em> <span class="pic yu-c99 yu-f28r uplimg" id="uploadbar">上传图片<i class="icon-add yu-blue2">+</i></span></p>
						<ul id="imglist">
                        <%--    <li><img src="http://admin.weikeniu.com/img/28291/20170827162840_3854.jpg"><p><b class="del"></b></p></li>
                            <li><img src="http://admin.weikeniu.com/img/28291/20170827162918_2223.jpg"><p><b class="del"></b></p></li>--%>
                        </ul>

                        <textarea class="ipt_area" name="content" id="content" placeholder="输入活动内容..."></textarea>
					</li>
				</ul>
			</div>
			<div class="ft-btn">
				<a class="publish" href="javascript:SendTheme();">发布</a>
			</div>
		</div>
	</article>
	
    <!--区域-->
   <%Html.RenderPartial("SelectLocat"); %>
   <div id="allmap" style="display:none;"></div>
	<!--出发地/出发地-->
	
	<!--出发地end-->
	
	<!--日历-->
	<article class="date-page">
		<div id="datepicker"></div>
			<div class="fix-bottom yu-bor tbor yu-grid yu-alignc yu-lrpad10 yu-h34r">
				<p class="yu-overflow ">行程共<span class="selectNum">1</span>天</p>
				<div>
					<div class="yu-grid yu-alignc">
						<p class="data-btn cal yu-bor1 bor">取消</p>
						<p class="data-btn sub">确定</p>
					</div>
				</div>
			</div>
	</article>
	<!--日历end-->
	
	<!--集合时间--> 
	<section class="mask lasttime-mask">
		<div class="mask-bottom-inner yu-bgw">
			<p class="yu-h110r yu-l110r yu-textc yu-bor bbor yu-f34r">集合时间</p>
			<ul class="yu-lrpad10 yu-c99 yu-blue2 hongbao-select">
				<% 
		            
				    for (int i = 1; i < 25; i++){ %>
                <li class="yu-h120r yu-grid yu-alignc yu-bor bbor">
					<div class="yu-overflow yu-f30r">
						<%=i+":00" %>
					</div>
					<p class="copy-radio blue"></p>
				</li>
                <%} %>
				<%--<li class="yu-h120r yu-grid yu-alignc yu-bor bbor">
					<div class="yu-overflow yu-f30r">
						19:00
					</div>
					<p class="copy-radio blue"></p>
				</li>--%>
			</ul>
			<div class="yu-h120r yu-bgblue2 yu-white yu-l120r yu-textc mask-close yu-f30r">关闭</div>
		</div>
	</section>
	
	 <!--活动类型-->
	<div class="mask screen-mask">
	 	<div class="mask-inner yu-lrpad20r">
	 		<div class="yu-grid yu-h90r yu-f32r yu-alignc yu-bor bbor yu-textc yu-j-s  yu-bmar60r" >
	 			<p class="yu-w120r cancel-btn2">取消</p>
	 			<p class="yu-w120r yu-blue2  sure-btn2">完成</p>
	 		</div>
		 	<dl class="yu-bpad30r">
	 			<dt class="yu-f26r yu-c99 yu-bmar30r">类别筛选(复选)</dt>
		 		<dd class="yu-grid yu-j-s type-screen">
		 			<div class="cur">不限</div>
		 			<div>休闲户外</div>
		 			<div>山野</div>
		 			<div>旅行</div>
		 			<div>骑行</div>
		 			<div>潜水</div>
		 			<div>自驾</div>
		 			<div>跑步</div>
		 			<div>水上运动</div>
		 			<div>技术攀登</div>
		 			<div>日常锻炼</div>
		 			<div>极限运动</div>
		 			<div>滑雪</div>
		 			<div>公益</div>
		 			<div>其他</div>
		 		</dd>
		 	</dl>
	 	</div>
	</div>
	
	
   
	<script type="text/javascript">
	    var selThemeType = '';
        function BindData() { }

	    var dClickNum = 0;
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
	        //maxDate: '2016-12-31',
	        numberOfMonths: 2,
	        showButtonPanel: false,
	        onSelect: function (date) {
	            if (dClickNum == 0) {
	                //console.log("第一次")
	                dClickNum = 1;
	            } else {
	                //console.log("第二次")
	                dClickNum = 0;
	                //
	            }
	        }
	    });


	    /** ---活动费用(文本框控制)--- */
	    $(".J__activityCost i").on("click", function () {
	        var type = $(this).attr("data-type");
	        console.log(type);

	        $(this).addClass("cur").siblings().removeClass("cur");
	        if (type == 0 || type == 1) {
	            $(".expect__input").parent("li").show();
	            $(".expect__input .lbl_cost").text($(this).text());
	        } else if (type == 2) {
	            $(".expect__input").parent("li").hide();
	        }
	    });

	    /** ---出发地、目的地--- */
	    $("#J__startPlace").on("click", function () {
	        $("#hid_isstartcity").val(0);
            
            $(".partner-page").hide();
	        $(".local-page").show();
	    });
	    //$("#J__endPlace,.icon-add").on("click", function () {
	    $("#endcity_addid").on("click", function () {
	        $("#hid_isstartcity").val(2);
           
            $(".partner-page").hide();
	        $(".local-page").show();
	    });

	    $(".select-item>p").on("click", function () {
	        $(this).addClass("cur").siblings().removeClass("cur");
	        $(".partner-page,base-page").show();
	        $(".local-page").hide();
	    });
	    $(".letter dd>p").on("click", function () {
	        $(this).addClass("cur").siblings().removeClass("cur");
	        $(".partner-page").show();
	        $(".local-page").hide();
	    });
	    $(".plist").live("click", ".i_xx", function (e) {
	        $(this).remove();
	        e.preventDefault();
	    });

	    /** ---行程日期(日历)--- */
	    $("#J__travelDate").on("click", function () {
	        $(".partner-page").hide();
	        $(".date-page").show();
	    });
	    $(".data-btn.cal").click(function () {
	        $(".partner-page").show();
	        $(".date-page").hide();
	    });
	    //行程日期确定
	    $(".sub").click(function () {
	        $(".partner-page").show();
	        $(".date-page").hide();
	        speciald.sort();//排序
	        //console.log(speciald.sort());
	        $("#xingchendate").html(('' + speciald).replace(',', '至'));
	    });

	    /** ---集合时间--- */
	    $("#J__setTime").click(function () {
	        $(".lasttime-mask").fadeIn();
	        $(".mask-bottom-inner").addClass("shin-slide-up");
	    });
	    //集合时间确定
	    $(".hongbao-select>li").on("click", function () {
	        $(this).addClass("cur").siblings().removeClass("cur");
	        $("#jihetime").html($(this).text());
	        $(".mask").fadeOut();
	    });
	    $(".mask-close,.mask").click(function () {
	        $(".mask").fadeOut();
	    });
	    $(".mask-bottom-inner, .mask-inner").on("click", function (e) {
	        e.stopPropagation();
	    });

	    /** ---活动类型--- */
	    $("#J__activityType").on("click", function () {
	        $(".screen-mask").fadeIn();
	    });
	    $(".cancel-btn2").on("click", function () {
	        $(".mask").fadeOut();
	    });
	    $(".sure-btn2").on("click", function () {
	        $(".mask").fadeOut();

	        var k = 0;
	        selThemeType = '';
	        var tarr = $(".type-screen>div");
	        $.each(tarr, function (i, t) {
	            if ($(this).hasClass("cur")) {
	                if (k == 0) {
	                    selThemeType = $(this).text();
	                } else {
	                    selThemeType += ',' + $(this).text();
	                }
	                k++;
	            }
	            $("#themetype").html(selThemeType);
	        });
	    });
	    $(".type-screen>div").on("click", function () {
	        $(this).toggleClass("cur");
	        var that = $(this).text();
	        if (that == '不限') {
	            $(this).siblings().removeClass("cur");
	        } else {
	            $($(".type-screen>div")[0]).removeClass("cur");
	        }

	    });
	</script>
    
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=Y4ofkWPl6nHN41oFEZj39HPA"></script>
<script type="text/javascript">
    var cityname = '';
    function ChangeLocat(locat, locatName) {
        cityname = locatName;
        var isSelectBeginOrEndCity=$("#hid_isstartcity").val()*1; //2=目的地城市
        if (locat == '' || locatName == '') {
            if (isSelectBeginOrEndCity == 2) {
                $("#endcityid").empty();
            } else {
                $("#startcityid").html('');
            }

        } else {
            if (isSelectBeginOrEndCity == 2) {
                var html = '<a class="plist"><em class="iconfont icon-dingwei1"></em><span class="listendcity">' + locatName + '</span><i class="i_xx">×</i></a>';
                var arrr = $("#endcityid").children('a');
                var count = 0;
                for (var i = 0; i < arrr.length; i++) {
                    if (($(arrr[i]).find('.listendcity').text()) == locatName) {
                        count++;
                     }
                }
                if (count == 0) {
                    $("#endcityid").append(html);
                }

            } else {
                $("#startcityid").html(locatName);
            }
        }
    }

    new BMap.LocalCity().get(function (res) {
        //获取当前用户所在城市,酒店有该城市数据则替换默认城市。
        var city = res.name.replace('市', '');
        $(".sp").find(".sp_lab").html(city);
        $(".letter dd>p").each(function () {
            if (city.indexOf($(this).find(".sp_lab").html()) > -1) {
                $(".sp").find(".sp_hid").val($(this).find(".sp_hid").val());
                //lnglat = $(this).find(".sp_hid").val();
            }
        });
    });
    </script>

<script type="text/javascript">

    function SendTheme() {
        var imgurls = '';
        var arr = $("#imglist").find("img");
        $.each(arr, function (i, t) {
            if (i == 0) {
                imgurls = $(this).attr("src");
            } else {
                imgurls += ',' + $(this).attr("src");
            }
        });
        //console.log(imgurls);

        var theme = $('#theme').val();
        var startcity = $('#startcityid').html();
        if (theme == '') { layer.msg('主题不能为空！'); return false; }
        if (startcity == '') { layer.msg('出发地不能为空！'); return false; }
        var endcity = "";
        var endcity_arrr = $("#endcityid").children('a');
        for (var i = 0; i < endcity_arrr.length; i++) {
            if (i == 0) {
                endcity = $(endcity_arrr[i]).find('.listendcity').text();
            } else {
                endcity += ',' + $(endcity_arrr[i]).find('.listendcity').text()
            }
        }
        if (endcity == '') { layer.msg('目的地不能为空！'); return false; }
        var xingchendate = $('#xingchendate').html();
        if (xingchendate == '') { layer.msg('行程日期不能为空！'); return false; }
        var jihetime = $('#jihetime').html();
        if (jihetime == '') { layer.msg('集合时间不能为空！'); return false; }
        var themetype = $('#themetype').html();
        if (themetype == '') { layer.msg('活动类型不能为空！'); return false; }

        var costtype = '0';
        var cost_arr = $(".J__activityCost i");
        for (var i = 0; i < cost_arr.length; i++) {
            if ($(cost_arr[i]).hasClass('cur')) {
                costtype = $(cost_arr[i]).attr('data-type');
            }
        }

        var costmoney = '0'; //0人均,1固定,2免费
        if (costtype != 2) {
            costmoney = $('#costmoney').val();
            if (costmoney <= 0) {
                layer.msg('金额必须大于0元');
                return false;
            }
        }

        var peoplenumber = $('#peoplenumber').val() * 1;
        if (peoplenumber <= 0) { layer.msg('人数必须大于0！'); return false; }
        var content = $('#content').val();
        if (content == '') { layer.msg('活动内容不能为空！'); return false; }

        var data = { theme: theme, startcity: startcity, endcity: endcity, xingchendate: xingchendate, jihetime: jihetime, themetype: themetype,
            costtype: costtype, costmoney: costmoney, peoplenumber: peoplenumber, content: content,imgurls:imgurls,
            hId: '<%=ViewData["hId"] %>', key: '<%=ViewData["key"] %>'
        };
        $.post('/TravelTheme/SaveTheme/', data, function (data) {
            if (data.success) {
                window.location.reload();
            } else {
                layer.msg('发布失败！');
            }
        });

    }
    </script>

<script type="text/javascript">
    //上传图片
    var uploader = WebUploader.create({
        // 选完文件后，是否自动上传。
        auto: true,
        // swf文件路径
        swf: '../../Scripts/webuploader/Uploader.swf',
        // 文件接收服务端。
        server: '/Hotel/UploadImg?hotelID= <%=Convert.ToInt32(ViewData["hId"])%> ',
        // 选择文件的按钮。可选。
        // 内部根据当前运行是创建，可能是input元素，也可能是flash.
        pick: '#uploadbar',
        // 只允许选择图片文件。
        accept: {
            title: 'Images',
            extensions: 'gif,jpg,jpeg,bmp,png',
            mimeTypes: 'image/jpg,image/jpeg,image/png'
        }
    });
    uploader.on('uploadSuccess', function (file, response) {//上传成功
        $('#imglist').append('<li><img src="' + response._raw.toString() + '"><p><b class="del"></b></p></li>');
        var Plen = $("#imglist li").length
        $("#imglist").find("em").html(Plen - 1);
        if (Plen == 6) {
            $('#uploadbar input[type="file"]').attr('disabled', 'disabled');
            $(".uplimg").hide();
        }
    });
    uploader.on('uploadError', function (file) {//上传失败
        layer.msg("上传出错!请稍后重试!");
    });
    
    </script>
</body>

<style>
    img{width:420px; height:300px; float:left; margin:0 2px 2px 5px;}
    #select-item p
    {
        display: block;
    }
    .letter dd p
    {
        display: block;
    }
    .letter dt
    {
        display: block;
    }
</style>
</html>
