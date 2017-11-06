<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%        
    string hotelid = RouteData.Values["id"].ToString();
    string key = HotelCloud.Common.HCRequest.GetString("key");
    string weixinID = "";
    string userWeiXinID = "";
    if (key.Contains("@"))
    {
        
        string[] a = key.Split('@');
        weixinID = a[0];
        userWeiXinID = a[1];
    }
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotelid);
    viewDic.Add("uwx", userWeiXinID);

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html lang="zh-cn">
<head>
	<meta charset="UTF-8" />
	<title>分销客户</title>
	<meta name="format-detection" content="telephone=no">
	<!--自动将网页中的电话号码显示为拨号的超链接-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
	<!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
	<meta name="apple-mobile-web-app-capable" content="yes">
	<!--IOS设备-->
	<meta name="apple-touch-fullscreen" content="yes">
	<!--IOS设备-->
	<meta http-equiv="Access-Control-Allow-Origin" content="*">
	<link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
	<link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
	<link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />
	<script src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
	<script src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
</head>
<body class="ca-overflow">
     <!--//顶部导航-->
     <div class="ca__headNav fixed">
           <div class="head">
                <a class="back"  href="javascript:history.back(-1);"></a>
                <h2 class="tit">分销客户</h2>
           </div>
     </div>
     <% System.Data.DataTable dt = ViewData["dt"] as System.Data.DataTable; %>
     <div class="ca-fx-order" style="display:block">
            <ul>
                 <% foreach (System.Data.DataRow row in dt.Rows)
                    { %>
                  <li class="ca-displayfx">
                       <div class="t-hotel-pht"><img src="<%=row["photo"] %>"></div>
                       <div class="ca-flex ca-source-money">
                             <ul>
                                  <li><h1><%=row["nickname"]%></h1></li>
                                  <li>产生订单：<%=row["fxNum"]%>笔</li>
                                  <li>带来佣金：￥<%=row["fxMoney"]%></li>
                                  <li>分销来源：链接分享</li>
                             </ul>
                       </div>
                       <!--ca-source-money end-->
                       <dl class="ca-time-success-ord">
                            <dt><%=Convert.ToDateTime(row["addtime"]).ToString("yyyy/MM/dd")%></dt>
                            <dd></dd>
                       </dl>
                       <!--ca-time-success-ord en-->
                  </li>
                  <% } %>
            </ul>
     </div>
    <%-- <div class="uc__loading-tips">
        加载中...
     </div>--%>

	<script type="text/javascript">
	    $(function () {
	        //选项卡
	        var tabIndex;
	        $(".tab-nav").children("li").on("click", function () {
	            $(this).addClass("cur").siblings("li").removeClass("cur");
	            tabIndex = $(this).index();
	            $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
	        })
	    })
	</script>
	
</body>
</html>
