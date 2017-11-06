<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    string hotelid = RouteData.Values["id"].ToString();




    List<hotel3g.Repository.RandomLuckyDrawClass> HotelLuckyDraws = ViewData["HotelLuckyDraws"] as List<hotel3g.Repository.RandomLuckyDrawClass>;

    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", ViewData["weixinID"]);
    viewDic.Add("hId", ViewData["hId"]);
    viewDic.Add("uwx", ViewData["userWeiXinID"]);
    
%>
<html xmlns="http://www.w3.org/1999/xhtml">
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
    <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=1.0" rel="stylesheet">
    <link href="http://css.weikeniu.com/css/css.css" rel="stylesheet" type="text/css" />
    <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <link href="http://css.weikeniu.com/css/booklist/new-style.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <script src="http://js.weikeniu.com/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <title>抽奖活动</title>
    <link href="http://js.weikeniu.com/css/css.css" rel="stylesheet" type="text/css">
    <%Html.RenderPartial("JSHeader"); %>
</head>
<body>
    <article class="full-page">
         <%Html.RenderPartial("HeaderA", viewDic);%>
         		<section class="show-body">	
 

			<section class="content2 yu-bpad60" >
            <div>
    <div class="all" id="contain_all">
        <%
            IList<hotel3g.Common.PrizeMsgWrapper> mlist = ViewData["data"] as IList<hotel3g.Common.PrizeMsgWrapper>;
            if (mlist != null)
            {
                foreach (hotel3g.Common.PrizeMsgWrapper item in mlist)
                {%>
        <div class="cshdlb detail_dp" data-id="<%=item.Id %>">
            <div class="cshdlbbt">
                <strong>
                    <%=item.Title %><%=item.Exclusive==1?" (会员专享)":"" %></strong>
            </div>
            <div class="cshdlbtp">
                <%
                    if (item.Type == "dazhuanpan")
                    {%>
                <a href="javascript:void(0)">
                    <img src="../../img/dazhuanpan.png" style="width: 100%; height: 150px" /></a>
                <%}
                    else
                    {%>
                <a href="javascript:void(0)">
                    <img src="../../img/guagua.jpg" style="width: 100%; height: 150px" /></a>
                <%}
                %>
            </div>
        </div>
        <%}
            }
        %>
        <input type="hidden" id="new_page" value="1" />
        <input type="hidden" id="new_sumpage" value="<%=ViewData["sumpage"] %>" />
        <% if (HotelLuckyDraws != null && HotelLuckyDraws.Count > 0)
           { %>
        <hr />
        <% for (int i = 0; i < HotelLuckyDraws.Count; i++)
           { %>
        <div class="cshdlb" data-id="">
            <div class="cshdlbbt">
                <strong>
                    <%=HotelLuckyDraws[i].title %></strong>
            </div>
            <div class="cshdlbtp">
                <a href="/MemberCard/LuckyDrawSignUp/<%=hotelid %>?&key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>&drawid=<%=HotelLuckyDraws[i].id %>">
                    <img src="/img/zhuanpan.jpg" style="width: 100%; height: 150px" /></a>
            </div>
        </div>
        <%} %>
        <%} %>
    </div>
    </div>
    </section>
    </article>
</body>
</html>
<%Html.RenderPartial("JS"); %>
<script type="text/javascript">
    var winHeight = $(window).height();
    $(function () {
        $('#contain_all').on('click', 'div[class*="detail_dp"]', function () {
            var id = $(this).attr('data-id');
            location.href = '/UserA/Sports/<%=ViewData["hId"] %>?sid=' + id + '&key=<%=ViewData["weixinID"]%>@<%=ViewData["userWeiXinID"] %>';
        });

        function template(data) {
            var html = '';
            for (var i = 0, l = data.length; i < l; i++) {
                html += '<div class="cshdlb detail_dp" data-id="' + data[i].Id + '">' +
		            '<div class="cshdlbbt">' +
			            '<strong>' + data[i].Title + '</strong>' +
		            '</div>' +
		            '<div class="cshdlbtp">';
                if (data[i].CoverImage != '') {
                    html += '<a href="javascript:void(0)"><img src="' + data[i].CoverImage + '" style="width: 100%; height:150px"/></a>';
                }
                html += '</div>' +
	            '</div> ';
            }
            return html;
        }
        $(window).scroll(function () {
            var docTop = $(document).scrollTop();
            var contentHeight = $('#contain_all').height();
            if (docTop + winHeight >= contentHeight - 10) {
                var page = parseInt($('#new_page').val()), sumpage = parseInt($('#new_sumpage').val());
                if (page < sumpage) {
                    $.ajax({
                        url: '/Hotel/FetchPrizeSports',
                        data: { wx: '<%=ViewData["weixinID"] %>', page: page + 1 },
                        dataType: 'json',
                        success: function (data) {
                            if (data.data) {
                                if (data.data.length > 0) {
                                    var html = template(data.data);
                                    if (html != '') {
                                        $('#contain_all').append(html);
                                    }
                                    $('#new_page').val(data.page);
                                    $('#new_sumpage').val(data.sumpage);
                                }
                            }
                        }
                    });
                }
            }
        });
    });
</script>
