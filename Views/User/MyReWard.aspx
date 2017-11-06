<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    System.Data.DataTable dt = ViewData["dt"] as System.Data.DataTable;

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
    <title>中奖记录</title>
 

 <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css"/>
           <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/patch.css"/>
<script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
   
</head>
<body>

    <header class="yu-bor bbor">
 	<a href="javascript:history.go(-1);" class="back"><div class="new-l-arr"></div></a> 	
 	中奖记录
 </header>
 
    <section class="zj-page"> 
     

<dl class="hb-list"> 


   
        <%  if (dt.Rows.Count >0)
            {
                foreach (System.Data.DataRow dr in dt.Rows)
                {
                    string class_ico = dr["Result"].ToString().Contains("优惠券") ? "hb-ico" : "jp-ico";

                    string value = dr["Result"].ToString().Replace("优惠券", "").Replace("元红包", "");
                    decimal num = 0;
                    if (decimal.TryParse(value, out num))
                    {
                        value = dr["Result"].ToString().Replace("元优惠券", "元订房红包");
                    }
                    else
                    {
                        value = dr["Result"].ToString().Replace("元优惠券", "").Replace("元红包", "");
                    }
                    
                       %>
	<dd class="yu-bor bbor yu-bgw  yu-font14">
		<a href="javascript:;" class="yu-grid yu-greys">
 
		<div class="yu-overflow sp">
			<div class="yu-grid">
				<span class="<%=class_ico %>"></span>
				<div class="yu-overflow">
					<p>  <%=value%></p>					 
				</div>
			</div>
		</div>
		<p>  <%=Convert.ToDateTime(dr["Choujiangtime"].ToString()).ToString("yyyy-MM-dd HH:mm:ss")%></p>
		</a>
	</dd>

    <%}
            }%>


            <% else
            { %>
   
                       <section class="yu-tpad120r">
	<div class="no-r-ico"></div>
	<p class="yu-c77 yu-f28r yu-textc ">暂无中奖记录</p>
</section>

            <%  } %>
     
</dl>
</section>
    <%Html.RenderPartial("Footer", jdata); %>
</body>
</html>
<%Html.RenderPartial("JS"); %>