<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    hotel3g.Repository.MemberCard MemberCard = ViewData["MyCard"] as hotel3g.Repository.MemberCard;    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta name="keywords" content="关键词1,关键词2,关键词3" />
    <meta name="description" content="对网站的描述" />
    <meta name="format-detection" content="telephone=no" />
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes" />
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*" />
    <title>修改会员卡信息</title>
    <link href="../../css/style.css?t=<%=DateTime.Now.ToString("yyyyMMddHHmmsssff") %>" rel="stylesheet" type="text/css" />
    <link href="../../Content/default.css" rel="Stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
</head>
<body>
    <section class='top'>
		<a  href="javascript:void(0)" onclick="window.history.go(-1)"><p class='back'></p></a> 
		填写会员资料
		<p class='card'></p>
	</section>
    <section class='wrap sp '>
		<form class='info-form'>
			<div class='dl-group'>
			<dl>
				<dt>姓名:</dt>
				<dd><input type='text' value="<%=MemberCard.name %>" id="name" name="name" placeholder='请输入姓名' /></dd>
			</dl>		
			<dl>
				<dt>性别:</dt>
				<dd><select class='type1' id="sex" name="sex"><option <%=MemberCard.sex==1?" selected ":"" %> value="1">男</option><option <%=MemberCard.sex==0?" selected ":""%>  value="0">女</option></select></dd>
			</dl>	

            	<dl>
				<dt>邮箱:</dt>
				<dd><input type='text' id="email" name="email"  value="<%=MemberCard.email %>" placeholder='请输入邮箱' /></dd>
			</dl>	

            <dl>
				<dt>地址:</dt>
				<dd><input type='text' id="address" name="address"  value="<%=MemberCard.address %>" placeholder='请输入地址' /></dd>
			</dl>	

			</div>
	
			<input type="button" class='type3' id="subinfo" value='提  交'/>
			<%--<input type='submit' class='type4' value='绑定已有实体卡'>--%>

		</form>
		
	</section>
</body>
</html>
<script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
<script src="../../Scripts/m.hotel.com.core.min.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
        var utils = WXweb.utils;
        $("#subinfo").click(function () {
            var name = $("#name").val();
            var email = $("#email").val();
            var address = $("#address").val();
            var sex = $("#sex").val();
            if (name == '') {
                utils.MsgBox('姓名不能为空!');
                $("#name").focus();
                return;
            }
            if (email == '') {
                utils.MsgBox('邮箱不能为空!');
                $("#email").focus();
                return;
            }
            if (address == '') {
                utils.MsgBox('地址不能为空!');
                $("#address").focus();
                return;
            }

            var prem = { cardno: '<%=ViewData["cardno"] %>', name: name, email: email, address: address, sex: sex };
            $.post("/MemberCard/EditMemberCardByGust", prem, function (data, status) {
                if (data.state == 1) {
                    utils.MsgBox('保存成功!');
                } else {
                    utils.MsgBox(data.msg);
                }
            })

        });


    })
</script>
