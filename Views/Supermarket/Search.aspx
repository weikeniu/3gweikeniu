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
    <title>搜索</title>
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/Restaurant.css" />
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
</head>
<body class="yu-tpad50">
    <section class="top-seach-bar">
		<%--<form>--%>
			<div class="yu-grid yu-alignc yu-h50">
				<a href="javascript:history.go(-1)" class="back-btn yu-rmar10"></a>
				<div class="yu-overflow top-seach-input yu-bor bor yu-grid yu-alignc">
					<span class="ico"></span>
					<input id="search_text" type="text" placeholder="请输入商城内商品" />
				</div>
				<input type="button" value="搜索" class="top-seach-btn" onclick="Search()" />
			</div>
		<%--</form>--%>
	</section>
    <section class="yu-bgw yu-bpad20">
		<dl class="history-list yu-bmar20">
			<dt class="yu-bor bbor">历史搜索</dt>
			<dd id="history_dd">
				<%--<div class="yu-bor bbor"><a href="#">毛巾</a></div>
				<div class="yu-bor bbor"><a href="#">行李箱</a></div>
				<div class="yu-bor bbor"><a href="#">水果</a></div>
				<div class="yu-bor bbor"><a href="#">纯棉袜子</a></div>--%>
			</dd>
		</dl>
		
		<div class="clear-history">
			<div class="yu-bor1 bor" onclick="ClearHistory()">
				<span class="ico"></span>
				清空历史搜索
			</div>
		</div>
	</section>
</body>
<script type="text/javascript">
    $(function(){
    //初始化查询历史
        var Search = sessionStorage.SupermarketSearch;
        var SearchHistory = localStorage.SupermarketSearchHistory;
        if(Search != undefined)
            $("#search_text").val(Search);
        if(SearchHistory == undefined || SearchHistory == ""){
            localStorage.SupermarketSearchHistory = "";
        }else{
            SearchHistory = SearchHistory.substring(0, SearchHistory.length - 1);
            var arr = SearchHistory.split("^");
            arr = arr.reverse();
            for(var i =0;i<arr.length && i< 9;i++){
                $("#history_dd").append('<div class="yu-bor bbor"><a  onclick="HistorySearch(\''+arr[i]+'\')">'+arr[i]+'</a></div>');
            }
        }
    });

    //保存查询历史并进行跳转
    function Search() {
        var search = $("#search_text").val();
        var SearchHistory = localStorage.SupermarketSearchHistory;
        if(search.length >= 20)
           search = search.substring(0, 20);
        sessionStorage.SupermarketSearch = search;
        if(search != ""){
            SearchHistory = SearchHistory.substring(0, SearchHistory.length - 1);
            var newSearchHistory = "";
            var temp = "";
            var arr = SearchHistory.split("^");
            var isHave = false;
            for(var i = 0;i<arr.length;i++){
                if(arr[i] == search){
                    isHave = true;
                    temp = arr[i];
                }else{
                    newSearchHistory = newSearchHistory + arr[i] + "^";
                }
            }
            if(!isHave){
                localStorage.SupermarketSearchHistory = localStorage.SupermarketSearchHistory + search + "^";
            }
            else{
                localStorage.SupermarketSearchHistory = newSearchHistory + temp + "^";
            }

            
        }
        location.href = "/Supermarket/Index/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&SupermarketSearch="+ search;
    }

    
    //历史点击事件
    function HistorySearch(str){
        $("#search_text").val(str);

        Search();
    }

    //清空查询历史
    function ClearHistory(){
        localStorage.SupermarketSearchHistory = "";
        $("#history_dd").html("");
    }

    

        $(document).keyup(function(event){
          if(event.keyCode ==13){
            Search();
          }
        });
</script>
</html>
