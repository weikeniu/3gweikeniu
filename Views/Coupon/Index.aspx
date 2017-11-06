<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta name="keywords" content="关键词1,关键词2,关键词3" />
<meta name="description" content="对网站的描述" />
<title>标题</title>
<link type="text/css" rel="stylesheet" href="/css/style.css"/>
    <script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
<script type="text/javascript" src="js/js.js"></script>
</head>
<body>
	<section class="wrap">
		<div class="mask">
			<img src="/images/coupon/lost.png" class="useto"/>
		</div>
		<input type="text" class="pnum" />
		<input type="button" class="getbtn" value="领取红包" />
	</section>
	<script type="text/javascript">
	    $(function () {
	        $(".getbtn").click(function () {
	            $(".mask").show();
	        });
	        $(".mask").click(function () {
	            $(this).hide();
	        })
	    })
	</script>
</body>
</html>
