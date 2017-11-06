<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%  
    bool flag = false;
    if (Html.ViewData["sharemsg"] != null)
    {
        flag = true;
    } 
%>
<script type="text/javascript">   
    document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
        <%-- %> <%
       if(!flag){ %>
        WeixinJSBridge.call('hideOptionMenu');
       <% }else{%>
            WeixinJSBridge.call('showOptionMenu');
        <%}
     %> --%>
        WeixinJSBridge.call('hideToolbar');
    });
</script>
