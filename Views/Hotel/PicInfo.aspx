<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%var imgstr = ViewData["HotelPictures"].ToString();
  string url = ViewData["url"].ToString();
  string hotelid = RouteData.Values["id"].ToString();
  string weixinID = ViewData["weixinid"].ToString();
  string userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO",weixinID);
  var arr = imgstr.Split(',');
  //int index = 0;
  //for (int i = 0; i < arr.Length - 1; i++)
  //{
  //    if (arr[i].Split('|')[0].Replace("'", "") == url)
  //    {
  //        index = i;
  //    }
  //}
 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width,target-densitydpi=medium-dpi,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-touch-fullscreen" content="yes" />
    <title>我的公众号</title>
    <link href="../../css/style.css" rel="stylesheet" type="text/css" />
    <script type="application/x-javascript">addEventListener('load',function(){setTimeout(function(){scrollTo(0,1);},0);},false);</script>
</head>
<%Html.RenderPartial("JS"); %>
<body class="hotel_pic">
    <div class="wrap">
        <ul class="focus" id="focus">
            <%-- <%var arr = imgstr.Split(',');
        for(int i=0;i<arr.Length-1;i++)
          {
           %>
           <li style="display:none" ><img src="<%=arr[i].Split('|')[0].Replace("'","") %>" title="<%=arr[i].Split('|')[1].Replace("'","") %>" width="100%"></li>

           <%} %>--%>
            <li>
                <img id="imgshow" src="<%=url %>" width="100%" style="opacity: 68; -webkit-transform: translate3d(0px, 0px, 0px);" /></li>
        </ul>
        <div class="operation">
            <a href="javascript:;" class="pre">上一页</a> <span id="title">标准大床房</span> <a href="javascript:;"
                class="next" id="nextimg">下一页</a>
        </div>
    </div>
    <div id="navigation">
        <ul>
            <li><a href="/Hotel/Index/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>">预订</a></li>
            <li><a href="/Hotel/Info/<%=hotelid %>?weixinID=<%=weixinID %>">简介</a></li>
            <li class="cur"><a href="/Hotel/images/<%=hotelid %>?weixinID=<%=weixinID %>">图片</a></li>
            <li><a href="/Hotel/Map/<%=hotelid %>?weixinID=<%=weixinID %>">地图</a></li>
        </ul>
    </div>
</body>
</html>
  <script src="/Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
  <script src="http://code.jquery.com/mobile/1.0a4.1/jquery.mobile-1.0a4.1.min.js"></script>
<script type="text/javascript">

    $("#focus>li").css({ "height": ($(document).height() - 90) + "px", "line-height": ($(document).height() - 90) + "px" });

    /*菜单导航*/
    $("#navigation>ul>li").each(function () {
        $(this).click(function () {
            $(this).attr("class", "cur").siblings("li").removeClass();
        });
    });
    var index = 0;
    var imgs = new Array();
    var imgstr = "<%=imgstr %>";
    imgstr = imgstr.replace(/\'/g, "");
    var data = imgstr.toString().split(",");
    for (var i = 0; i < data.length - 1; i++) {

        imgs.push(data[i]);
        var url = "<%=url %>";
        if (data[i].split("|")[0] == url) {
            index = i;
        }
    }
    $(".next").click(function () {
        if (index < imgs.length - 1) {
            $(".pre").show();
            index++;
            var nextimg = imgs[index].split("|")[0];
          
            $("#imgshow").attr("src", nextimg);
            $("#title").html(imgs[index].split("|")[1]);
        }
        else {
            $(".next").hide();
        }
    });
    $(".pre").click(function () {
        if (index > 0) {
            $(".next").show();
            index--;
            var preimg = imgs[index].split("|")[0];
            $("#imgshow").attr("src", preimg);
            $("#title").html(imgs[index].split("|")[1]);
        }
        else {
            $(".pre").hide();
        }
    });

    $("#imgshow").bind("swiperight", function () {
        if (index < imgs.length - 1) {
            $(".pre").show();
            index++;
            var nextimg = imgs[index].split("|")[0];
            $("#imgshow").attr("src", nextimg);
            $("#title").html(imgs[index].split("|")[1]);
        }
        else {
            $(".next").hide();
        }
       
    });
    $("#imgshow").bind("swipeleft", function () {
        if (index > 0) {
            $(".next").show();
            index--;
            var preimg = imgs[index].split("|")[0];
            $("#imgshow").attr("src", preimg);
            $("#title").html(imgs[index].split("|")[1]);
        }
        else {
            $(".pre").hide();
        }
    });
</script>
