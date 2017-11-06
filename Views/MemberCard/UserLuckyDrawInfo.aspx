<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%  
    List<hotel3g.Repository.RandomLuckyDrawUserClass> UserLuckyDrawInfo =
    ViewData["UserLuckyDrawInfo"] as List<hotel3g.Repository.RandomLuckyDrawUserClass>;    
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的中奖纪录</title>
    <script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <link href="../../css/dazhuanpan/style.css#<%=DateTime.Now.ToString("yyyyMMddHHmmsssff")%>" rel="stylesheet" type="text/css" />
</head>
<body style="overflow-x: hidden;">
    <section class="top-box">

		<h3>我的中奖记录</h3>
		<a href="javascript:void(0);" onclick="history.go(-1);" class="back"></a>
		<div class="head-img"><img style="border:none" class="head-img" src="<%=UserLuckyDrawInfo[0].photo %>" /></div>
        <% if (UserLuckyDrawInfo != null && UserLuckyDrawInfo.Count > 0)
           { %>
        <p class="phone-num">*******<%=UserLuckyDrawInfo[0].tel.Substring(6)%></p>
        <%}
           else
           { 
           %>
           <p class="phone-num">--</p>
           <%
               } %>
		
	</section>
    <section class="info-box">
		<ul class="prize-list">
        <% if (UserLuckyDrawInfo != null && UserLuckyDrawInfo.Count > 0)
           { %>
        
        <% for (int i = 0; i < UserLuckyDrawInfo.Count; i++)
           {
               if (UserLuckyDrawInfo[i].drawno > 0)
               {
                %>
             <li>
				<p class="prize-info"><%=UserLuckyDrawInfo[i].result%></p>
				<p class="prize-data"><%=UserLuckyDrawInfo[i].wintime%></p>
			</li>
        <%}
           } %>

        <%} %>
		</ul>
	</section>
</body>
</html>
