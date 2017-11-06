<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    IList<hotel3g.Common.CouponInfo> dt = ViewData["dt"] as IList<hotel3g.Common.CouponInfo>;
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", ViewData["weixinID"]);
    viewDic.Add("hId", ViewData["hId"]);
    viewDic.Add("uwx", ViewData["userWeiXinID"]);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <title>我的红包</title>
    <meta name="format-detection" content="telephone=no" />
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes" />
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*" />
    <link href="http://css.weikeniu.com/css/newpay.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/new-style.css" />
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/mend-reset.css" />
    <script src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
</head>
<body>
    <!-- <>主体页面 -->
    <article class="full-page">
		<!--//侧边栏-->
      <%Html.RenderPartial("HeaderA", viewDic) ;%>
		<section class="show-body">
                  <section class="content2">

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
                  href = string.Format("/hotelA/Index/{0}?key={1}@{2}", ViewData["hId"], ViewData["weixinID"], ViewData["userWeiXinID"]);
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


              	<a href="<%=href%>">
	                <div class="hongbao type1 yu-grid">
	                    <div class="yu-overflow yu-textl">
	                      <p class="yu-bmar10"><i class="yu-font14">￥</i><i class="yu-font30"><%=dr.Moneys %></i></p>
	                      <p class="yu-font14"><%=header%></p>
	                      <p class="yu-font14">有效期<%= string.Format("{0}-{1}",Convert.ToDateTime(dr.StartTime).ToString("yyyy.MM.dd"), Convert.ToDateTime(dr.EndTime).ToString("yyyy.MM.dd") )%>   </p>
	                      <p class="yu-font14"><%=ViewData["hotelName"] %></p>
                          <p  class="yu-font14">红包仅限订房使用，不可提现</p>
	                     </div>
	                    <p class="hongbao-state"><span class="type1"><%=wuxiao%></span><span class="type2">去使用</span></p>
	                </div>
                </a>
              </div>

              <% } %>
             </div>
             </section>
             </section>
             </article>
</body>
</html>
