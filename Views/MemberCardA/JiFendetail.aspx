<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%    
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", ViewData["weixinID"]);
    viewDic.Add("hId", ViewData["hId"]);
    viewDic.Add("uwx", ViewData["userWeiXinID"]);
    hotel3g.Common.UserInfo user = ViewData["user"] as hotel3g.Common.UserInfo;


     ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
     ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <title>积分明细</title>
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />
    <script src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body>
    <!-- <>主体页面 -->
    <article class="full-page">

        <%Html.RenderPartial("HeaderA", viewDic);%>
		<!--//侧边栏-->
		<section class="show-body">
			<section class="content2">
				
				<div class="pg__ucenter">
					<!--//积分明细-->
					<div class="ca-ivdetail-top">
                        <a class="ca-return-icon fl" href="javascript:void(0)" onclick="window.history.go(-1)"></a>
                        <div class="hd-mx fr"><a href="javascript:;"><i class="ico-hdmx i2"></i>我的积分：<%=user!=null&&user.Emoney>0?user.Emoney:0 %></a></div>
					</div>

                    <div class="uc__storeValCard-details" style="display:none;">
						<div class="no-data">
							<img src="../../images/icon__no-integral.png" />
							<h2>没有更多积分明细了</h2>
							<p>过段时间再来瞧瞧吧</p>
							<a class="back" href="javascript:void(0)" onclick="window.history.go(-1)">返回</a>
						</div>
					</div>

					<div class="uc__integral-details">
						<div class="hd-date">2017年1月</div>
						<ul class="clearfix" id="itempanl">	
						</ul>
						<div class="uc__loading-tips">
							加载中...
						</div>
					</div>
				</div>
			</section>
		</section>
	</article>
</body>
</html>
<script type="text/javascript">
    $(function () {
        $(".uc__storeValCard-details").hide();
        $(".uc__loading-tips").show();
        var loadedPage = 0;
        var pageCount = 1;
        var isPreLoad = true;
        var prem = { page: loadedPage, WeiXinID: '<%=ViewData["weixinID"] %>', UserWeiXinID: '<%=ViewData["userWeiXinID"] %>', hid: '<%=ViewData["hid"] %>' };
        $(window).scroll(function () {
            var scrollTop = $(this).scrollTop();
            if (scrollTop > 40) {
                //$('.screening').addClass('fixheader');
            } else {
                //$('.screening').removeClass('fixheader')
            }
            var scrollHeight = $(document).height();
            var windowHeight = $(this).height();

            if (scrollTop + windowHeight >= (scrollHeight / 4 * 3) && isPreLoad) {
                $(".uc__loading-tips").show();
                if (loadedPage < pageCount) {
                    isPreLoad = false;
                    loadedPage++;
                    pageCount = loadedPage + 1;
                    //触发加载数据
                    GetPageData();

                } else {
                    $(".uc__loading-tips").hide();
                }
            }

        });

        function GetPageData() {
            prem["page"] = loadedPage;
            $.post("/MemberCard/GetJiFendetailList", prem, function (data, status) {
                $(".uc__loading-tips,.uc__storeValCard-details").hide();
                if (data.state == 1) {
                    LoadHtml(data.data);
                    isPreLoad = true;
                    $(".uc__integral-details").show()

                } else {
                    if (loadedPage == 0) {
                        $(".uc__loading-tips,.uc__integral-details").hide();
                        $(".uc__storeValCard-details").show();
                    } else {
                        var html = "<li><center>没有更多数据了...</center></li>";

                        $("#itempanl").append(html);
                    }

                }
            });
        }
        function LoadHtml(data) {

            var json = eval(data);
            var html = '';
            for (var i = 0; i < json.length; i++) {
                html += '<li>';
                html += '<div class="row clearfix">';
                html += '<span class="id fl">17003021475412152</span><em class="val fr">' + json[i].JiFen + '</em>';
                html += '</div>';

                html += '<div class="row clearfix">';
                html += '<em class="total fr"></em>';
                html += '</div>';
                html += '<div class="row r3 clearfix">';
                html += '<label class="tag fl"><i>' + json[i].Remark + '</i></label><em class="time fr">' + json[i].AddTime + '</em>';
                html += '</div>';

                html += '</li>';


            }
            $("#itempanl").append(html);
        }

        GetPageData();
    });
</script>
