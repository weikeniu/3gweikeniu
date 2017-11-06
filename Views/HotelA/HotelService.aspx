<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
    hotel3g.Models.Hotel hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
    IList<hotel3g.Common.FacilityImages> imgs = ViewData["facImagfe"] as IList<hotel3g.Common.FacilityImages>;

    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", ViewData["weixinID"]);
    viewDic.Add("hId", ViewData["hId"]);
    viewDic.Add("uwx", ViewData["userWeiXinID"]);

    ViewData["hotelname"] = hotel.SubName;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
    <title>
        <%= ViewData["hotelname"]%>
        设施服务</title>
    <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=1.0" rel="stylesheet">
    <link href="http://css.weikeniu.com/css/css.css" rel="stylesheet" type="text/css" />
             <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <link href="http://css.weikeniu.com/css/booklist/new-style.css?v=2.0" rel="stylesheet"
        type="text/css" />
    <script src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    
    <style>
    .all {
    overflow: hidden;
}
.jianjietop {
    box-sizing: border-box;
}
.jianjiecon {
    box-sizing: border-box;
}

    </style>
    </head>
<body>
    <article class="full-page">
         <%Html.RenderPartial("HeaderA", viewDic);%>
         		<section class="show-body">	
 

			<section class="content2 yu-bpad60" >
            <div>
<%
    if (!string.IsNullOrEmpty(hotel.FuWu))
    {%>
        <div class="all" style="padding-bottom: 0px;">
        <div class="jianjietop">
            <strong>酒店服务</strong>
        </div>
        <div class="jianjiecon" style="padding: 0px;">
            <p><%=string.IsNullOrEmpty(hotel.FuWu)?string.Empty:hotel.FuWu.Replace(";","；") %></p>
        </div>
    </div>
   <% }
     %>
    
    <%
        if (!string.IsNullOrEmpty(hotel.KeFang))
        {%>
            <div class="all" style="padding-bottom: 0px;">
        <div class="jianjietop">
            <strong>客房设施</strong>
        </div>
        <div class="jianjiecon" style="padding: 0px;">
            <p><%=string.IsNullOrEmpty(hotel.KeFang)?string.Empty:hotel.KeFang.Replace(";","；") %></p>
        </div>
    </div>
        <%}
         %>
    
    <%
        if (!string.IsNullOrEmpty(hotel.CanYin))
        {%>
            <div class="all" style="padding-bottom: 0px;">
        <div class="jianjietop">
            <strong>餐饮设施</strong>
        </div>
        <div class="jianjiecon" style="padding: 0px;">
            <p><%=string.IsNullOrEmpty(hotel.CanYin) ? string.Empty : hotel.CanYin.Replace(";", "；")%></p>
            <%
       
            
                foreach (hotel3g.Common.FacilityImages mg in imgs)
                {
                    //去除空白项图片
                    mg.Images = mg.Images.Where(e => !string.IsNullOrEmpty(e)).ToList();
                    if (mg.TypeId == 3)
                    {
                        if (mg.Images != null && mg.Images.Count > 0)
                        {
                            int i = 1;
                            foreach (string u in mg.Images)
                            {
                                if (i == 1)
                                {%>
                                    <p><strong><%=mg.Title %></strong>：<%=mg.Description %></p>
                                <%}
                                if (!string.IsNullOrEmpty(u))
                                { %>
                                    <center><img src="<%=u %>" /></center>
                                <%}
                                  %>
                             <%
                                 i++;
                            }
                        }
                    }
                }
                 %>
        </div>
    </div>
        <%}
         %>
    
    <%
        if (!string.IsNullOrEmpty(hotel.YuLe))
        {%>
            <div class="all">
        <div class="jianjietop">
            <strong>康体娱乐</strong>
        </div>
        <div class="jianjiecon" style="padding: 0px;">
            <p><%=string.IsNullOrEmpty(hotel.YuLe) ? string.Empty : hotel.YuLe.Replace(";","；")%></p>
            <%
                foreach (hotel3g.Common.FacilityImages mg in imgs)
                {
                    if (mg.TypeId == 4)
                    {
                        if (mg.Images != null)
                        {
                            int i = 1;
                            foreach (string u in mg.Images)
                            {
                                if (i == 1)
                                {%>
                                    <p><strong><%=mg.Title %></strong>：<%=mg.Description %></p>
                                <%}
                                if (!string.IsNullOrEmpty(u))
                                { %>
                                    <center><img src="<%=u %>" /></center>
                               <% }
                                %>
                             <%
                                 i++;
                            }
                        }
                    }
                }
                 %>
        </div>
    </div>
        <%}
         %>
         </div>
    </section>
    </section>
</article>
</body>
</html>

