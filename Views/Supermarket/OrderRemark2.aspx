<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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
    <title>订单备注</title>
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/Restaurant.css" />
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
</head>
<body>
    <section class="yu-tpad10">
		<form>
			<div class="yu-bgw yu-pad20">
				<h3 class="yu-bmar10 yu-fontn">快速备注</h3>
				<%--<div class="select-list yu-bmar10">
					<p class="yu-bor1 bor">速度加快</p>
					<p class="yu-bor1 bor">帅哥配送</p>	
					<p class="yu-bor1 bor">美女配送</p>	
					<p class="yu-bor1 bor">不要按门铃</p>	
					<p class="yu-bor1 bor">外带其他物品</p>	
				</div>--%>
				<div class="textarea-box">
					<textarea class="textarea-type1 yu-bor bor" maxlength="50"  placeholder="无备注"></textarea>
					<%--<p><span id="textareaLenght">0</span>/50个字</p>--%>
				</div>
			</div>
			<div class="yu-pad10">
				<input type="button" value="返回" class="blue-sub" onclick="history.go(-1)"/>
			</div>
		</form>
	</section>
    <script>
	    $(function () {
        var remark = '<%=ViewData["remark"] %>';
        if (remark != undefined && remark != "") {
            $("textarea").text(remark);
        }

	        $(".select-list").children("p").on("click", function () {
	            $(this).toggleClass("cur");
	            var append = $(this).text() + " ";
	            if ($(this).hasClass("cur")) {
	                var remo = $('.textarea-type1').val();
	                if (remo.length + append.length <= 50) {
	                    $('.textarea-type1').val(remo + append);
	                }
	            } else {
	                var remo = $('.textarea-type1').val();
	                $('.textarea-type1').val(remo.replace(append, ""));
	            }
	        })
	    })

	    $("textarea").on("keyup", function () {
        var str = $("textarea").val();
        $("#textareaLenght").html(str.length);
    });

    </script>
</body>
</html>
