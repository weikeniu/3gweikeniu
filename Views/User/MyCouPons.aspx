<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    
    IList<hotel3g.Common.CouponInfo> dt = ViewData["dt"] as IList<hotel3g.Common.CouponInfo>;

    ViewDataDictionary jdata = new ViewDataDictionary();
    jdata.Add("weixinID", ViewData["weixinID"]);
    jdata.Add("hId", ViewData["hId"]);
    jdata.Add("uwx", ViewData["userWeiXinID"]);

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();

%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
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
    <title>红包详情</title>
    <link href="<%=ViewData["cssUrl"] %>/css/newpay.css" rel="stylesheet" type="text/css" />
      <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css"/>
                <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/patch.css"/>
<script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <%Html.RenderPartial("JSHeader"); %>
</head>
<body>
    <header class="yu-bor bbor">
 	<a href="javascript:history.go(-1)" class="back"><div class="new-l-arr"></div></a>
 	红包详情
 </header>

   <% if (dt.Count > 0)
      {  %>
    <section class="hb-details">
	<div class="yhq-box select-box">
  
       <% foreach (hotel3g.Common.CouponInfo dr in dt.OrderBy(c => c.State))
          {
              string classcur = "";
              string href = "javascript:void(0)";
              string wuxiao = string.Empty;

              if (dr.State == "0")
              {
                  classcur = "cur";
                  href = string.Format("/hotel/Index/{0}?key={1}@{2}", ViewData["hId"], ViewData["weixinID"], ViewData["userWeiXinID"]);
              }

              else if (dr.State == "1")
              {
                  wuxiao = "已使用";
              }

              else
              {
                  wuxiao = "已过期";
              }                             
                    
             
               %>           


              <div class="row <%=classcur%>">
              	<a href="<%=href%>">
	                <div class="hongbao type1 yu-grid">
	                    <div class="yu-overflow yu-textl">
	                      <p class="yu-bmar10"><i class="yu-font14">￥</i><i class="yu-font30"><%=dr.Moneys%></i></p>
<%
       Dictionary<string, string> ScopeDictionary = new Dictionary<string, string>() { { "0", "订房" }, { "1", "餐饮" }, { "2", "团购预售" }, { "3", "超市" }, { "4", "周边商家" } };
       List<string> scopeArry = string.IsNullOrEmpty(dr.scopelimit) ? new List<string>() : dr.scopelimit.Split(',').ToList<string>();
       string link = string.Format("/Hotel/Index/{0}?key={1}@{2}", ViewData["hId"], ViewData["weixinID"], ViewData["userWeiXinID"]);

       string header = "订房红包";
       if (scopeArry.Count > 0)
       {
           if (scopeArry.Count > 1)
           {
               header = "通用红包";
           }
           else
           {
               header = ScopeDictionary[scopeArry[0]] + "红包";
               switch (dr.scopelimit)
               {
                   case "1":
                       link = string.Format("/DishOrder/DishOrderIndex/{0}?key={1}@{2}", ViewData["hId"], ViewData["weixinID"], ViewData["userWeiXinID"]);
                       break;
                   case "2":
                       link = string.Format("/Supermarket/Index/{0}?key={1}@{2}", ViewData["hId"], ViewData["weixinID"], ViewData["userWeiXinID"]);
                       break;
                   case "3":
                       link = string.Format("/Product/ProductList/{0}?key={1}@{2}", ViewData["hId"], ViewData["weixinID"], ViewData["userWeiXinID"]);
                       break;
                   case "4":
                       link = string.Format("/DishOrder/DishOrderIndex/{0}?key={1}@{2}", ViewData["hId"], ViewData["weixinID"], ViewData["userWeiXinID"]);
                       break;
               }
           }

       }
              
              
              
               %>


	                      <p class="yu-font12"><%=header%></p>
	                      <p class="yu-font14">有效期<%= string.Format("{0}-{1}", Convert.ToDateTime(dr.StartTime).ToString("yyyy.MM.dd"), Convert.ToDateTime(dr.EndTime).ToString("yyyy.MM.dd"))%>   </p>
	                      <p class="yu-font14"><%=ViewData["hotelName"]%></p>
                          <p  class="yu-font14">红包仅限订房使用，不可提现</p>
	                     </div>
	                    <p class="hongbao-state"><span class="type1"><%=wuxiao%></span><span class="type2">去使用</span></p>
	                </div>
                </a>
              </div>

              <% } %>
             </div>
 
  
</section>

<%} else{  %>
      <section class="yu-tpad120r">
	<div class="no-r-ico"></div>
	<p class="yu-c77 yu-f28r yu-textc ">暂无红包记录</p>
</section>

<%} %>
    <%Html.RenderPartial("Footer", jdata); %>
</body>
</html>
<%Html.RenderPartial("JS"); %>
