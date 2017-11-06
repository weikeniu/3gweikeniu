<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Authentication</title>
</head>
<body>
    <p><a id="target" href="javascript:void(0)">跳转</a></p> 
    <textarea id="url" style="width:80%" rows="10"><%=ViewData["url"]%>
    </textarea>
</body>
</html>
<script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
<script>
    $(function () {
        $("#target").click(function () {
            var url = $("#url").val();
            window.location.href = url;
        });
    })
</script>
