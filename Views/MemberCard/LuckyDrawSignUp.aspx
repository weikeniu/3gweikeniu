<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    hotel3g.Repository.RandomLuckyDrawUserClass UserItem =
ViewData["UserItem"] as hotel3g.Repository.RandomLuckyDrawUserClass;
 
     %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>输入资料参加抽奖</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="../../css/style.css" rel="stylesheet" type="text/css" />
    <link href="../../css/dazhuanpan/style.css?t=<%=DateTime.Now.ToString("yyyyMMddHHmmsssff") %>"
        rel="stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
  
</head>
<body>
  <div class="mask login">
        <div class="inner">
            <h3>
                输入资料参加抽奖</h3>
            <dl>
                <dt>姓名：</dt>
                <dd>
                    <input type="text" id="name" /></dd>
            </dl>
            <dl>
                <dt>手机号：</dt>
                <dd>
                    <input type="text" id="tel" /></dd>
            </dl>
            <dl>
                <dt>密码：</dt>
                <dd>
                    <input type="text" id="pwd" /></dd>
            </dl>
            <div class="btn-box">
                <input type="button" value="提交" class="btn" id="subinfo" />
                <a href="javascript:;" class="close">取消</a>
              
            </div>
        </div>
    </div>
</body>
</html>
<script src="../../Scripts/layer/layer.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
        $(".mask").show();
        $("#subinfo").click(function () {
            var name = $("#name").val();
            var tel = $("#tel").val();
            var pwd = $("#pwd").val();
            var userweixinid = '<%=ViewData["userWeiXinID"] %>';
            var weixinid = '<%=ViewData["WeiXinID"] %>';
            var drawid = '<%=ViewData["drawid"] %>';


            var re = /^1\d{10}$/;
            if (!re.test(tel)) {
                layer.msg('请填写正确的手机号码！'); return;
            }
            var prem = { name: name, tel: tel, pwd: pwd, userweixinid: userweixinid, weixinid: weixinid, drawid: drawid };
            $.post("/MemberCard/RandomLuckyDrawSignUp", prem, function (data, status) {
                var msg = data.msg;
                layer.msg(msg);
                if (data.state > 0) {
                    setTimeout(function () {
                        var url = '<%=ViewData["RandomLuckyDrawNewUrl"] %>';
                        window.location.href = url;
                    }, 1000);
                }
            });

        });
    });
</script>
