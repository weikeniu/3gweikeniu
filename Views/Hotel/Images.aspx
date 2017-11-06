<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
    var imgstr = ViewData["HotelPictures"] as string;
    var hotel = ViewData["hotel"] as hotel3g.Models.Hotel;

    ViewDataDictionary jdata = new ViewDataDictionary();
    jdata.Add("weixinID", ViewData["weixinID"]);
    jdata.Add("hId", ViewData["hId"]);
    jdata.Add("uwx", ViewData["userWeiXinID"]);
    ViewDataDictionary JQ = new ViewDataDictionary();
    jdata.Add("JQ", false);



    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", ViewData["weixinID"]);
    viewDic.Add("hId", ViewData["hId"]);
    viewDic.Add("uwx", ViewData["userWeiXinID"]);
%>
<!DOCTYPE html>
<html>
<head>
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"
        name="viewport">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <!-- Mobile Devices Support @begin -->
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
    <meta content="no-cache,must-revalidate" http-equiv="Cache-Control">
    <meta content="no-cache" http-equiv="pragma">
    <meta content="0" http-equiv="expires">
    <meta content="telephone=no, address=no" name="format-detection">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!-- apple devices fullscreen -->
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>图片</title>
         <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=1.0" rel="stylesheet" >
    <link href="http://css.weikeniu.com/css/css.css?vsion=1.0" rel="stylesheet" type="text/css" />
    <%Html.RenderPartial("JSHeader"); %>
    <script src="http://js.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/css/photoswipe.css" media="all">
    <script type="text/javascript" src="http://js.weikeniu.com//Scripts/jquery_wookmark_min.js"></script>
    <script type="text/javascript" src="../../Scripts/klass_min.js"></script>
    <script type="text/javascript" src="../../Scripts/code_photoswipe_min.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery_lazyload.js"></script>
    <style>
        img
        {
            width: 100% !important;
        }
    </style>
</head>
<body>
    <script type="text/javascript">
        (function (window) {
            document.addEventListener('DOMContentLoaded', function () {
                var PhotoSwipe = window.Code.PhotoSwipe;
                var options = { loop: false },
				instance = PhotoSwipe.attach(window.document.querySelectorAll('.uulist li a'), options);
            }, false);
        })(window);
    </script>
    <div class="dz">
    </div>
    <div class="all" style="margin-top: 20px; padding-top: 0px; background: #fff;">
        <div class="tianxixxx">
            <%
                IDictionary<string, IList<hotel3g.Common.HotelImage>> dic = ViewData["HotelPictures"] as IDictionary<string, IList<hotel3g.Common.HotelImage>>;
                if (dic != null)
                {
                    int i = 0;
                    foreach (string t in dic.Keys)
                    {
                        IList<hotel3g.Common.HotelImage> list = dic[t];
                        if (list != null && list.Count > 0)
                        {%>
            <h1 class="htitle">
                <%--(i==0?"style='border-radius: 10px 10px 0px 0px;'":"")--%>
                <strong>
                    <%=t %></strong></h1>
            <ul class="uulist">
                <%foreach (hotel3g.Common.HotelImage m in list)
                  {
                      string currImg = !string.IsNullOrEmpty(m.BigUrl) ? m.BigUrl : m.Image;   
                      %>
                <li><a href="<%=m.Image %>">
                    <img class="imgload" url="<%=currImg %>" /></a></li>
                <% }%>
            </ul>
            <% i++;
                        }
                    }
                } 
            %>
        </div>
    </div>
    <%Html.RenderPartial("Copyright"); %>
   <%  Html.RenderPartial("Footer", viewDic);  %>
</body>
</html>
<% Html.RenderPartial("JS", JQ); %>
<script>
    $(function () {
        $(".imgload").each(function () {
            var url = $(this).attr("url");
            $(this).attr("src", url);
            $(this).removeAttr("url");
        });
    })
</script>