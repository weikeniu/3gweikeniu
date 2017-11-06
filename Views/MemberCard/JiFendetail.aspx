<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

    <%    
        ViewDataDictionary viewDic = new ViewDataDictionary();
        viewDic.Add("weixinID", ViewData["weixinID"]);
        viewDic.Add("hId", ViewData["hId"]);
        viewDic.Add("uwx", ViewData["userWeiXinID"]);
   

        ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
        ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta name="keywords" content="关键词1,关键词2,关键词3" />
    <meta name="description" content="对网站的描述" />
    <meta name="format-detection" content="telephone=no" />
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes" />
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*" />
    <title>积分明细</title>
  
    <link href="<%=ViewData["cssUrl"] %>/css/style.css?t=1.1"
        rel="stylesheet" type="text/css" />
    <link href="<%=ViewData["cssUrl"] %>/Content/default.css" rel="Stylesheet" type="text/css" /> 
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />  
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script> 
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body > 
 
    <header class="yu-bor bbor">
 	<a href="javascript:history.back(-1);" class="back"><div class="new-l-arr"></div></a>
 	积分明细
 </header>

    <section class='wrap sp'>
		<ul>
		</ul>
		<div class='mes-tabbox'>
			<div class='cur'>
				<ul class='message-list' id="itempanl">
				<!--展示区-->
				</ul>
			</div>
		</div>
	</section>

    <%Html.RenderPartial("Footer", viewDic); %>
</body>
</html>
 
<script type="text/javascript">
    $(function () {
        // var utils = WXweb.utils;
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
                if (loadedPage < pageCount) {
                    isPreLoad = false;
                    loadedPage++;
                    pageCount = loadedPage + 1;
                    //触发加载数据
                    GetPageData();
                }
            }

        });

        function GetPageData() {
            prem["page"] = loadedPage;
            $.post("/MemberCard/GetJiFendetailList", prem, function (data, status) {
                if (data.state == 1) {
                    LoadHtml(data.data);
                    isPreLoad = true;
                } else {
                    // utils.MsgBox(data.msg);
                    layer.msg(data.msg);
                }
            });
        }
        function LoadHtml(data) {
           
            var json = eval(data);
            var html = '';
            for (var i = 0; i < json.length; i++) {

                html += '<li style="content:inherit;padding-left:20px">';
              //  html += '<img src="../../images/member/littlecard.jpg" />';
                html += '<div class="text">';
                html += '<p>' + '[' + (json[i].Remark == '超市使用积分' ? "-" : "") + json[i].JiFen + ']&nbsp; ' + json[i].Remark + '</p>';
                html += '<p>' + json[i].AddTime + '</p>';
                html += '</div>';
                html += '</li>'
            }
            $("#itempanl").append(html);
        }

        GetPageData();
    });
</script>
