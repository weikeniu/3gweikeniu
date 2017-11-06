<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<% 
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", ViewData["weixinID"]);
    viewDic.Add("hId", ViewData["hId"]);
    viewDic.Add("uwx", ViewData["userWeiXinID"]);
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<meta charset="UTF-8" />
	<title></title>
	<meta name="format-detection" content="telephone=no">
	<!--自动将网页中的电话号码显示为拨号的超链接-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
	<!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
	<meta name="apple-mobile-web-app-capable" content="yes">
	<!--IOS设备-->
	<meta name="apple-touch-fullscreen" content="yes">
	<!--IOS设备-->
	<meta http-equiv="Access-Control-Allow-Origin" content="*">
	<link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
	<link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/new-style.css" />
	<link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/mend-reset.css" />
	
	<script src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
	<script src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
    <style>
    .selected{background:#12b7f5!important}
    </style>
</head>
<body>
	  <%
            hotel3g.Common.UserInfo user = ViewData["data"]  as hotel3g.Common.UserInfo;
             %>
	<!-- <>主体页面 -->
	<article class="full-page">

		
		<!--//内容区-->
		<section class="show-body">
			<section class="content2">
				
				<div class="pg__ucenter">
					<!--//账号信息-->
					<div class="uc__account-info">
						<div class="hdTxt">填写信息</div>
						<div class="form">
							<ul class="clearfix">
								<li class="row1">
									<div class="inner flexbox">
										<label>真实姓名</label>
										<div class="iptbox flex1">
											<input class="ipttext" type="text" id="txt_name" name="username" value="<%=user.Name %>" placeholder="请输入名称" />
										</div>
									</div>
								</li>
								<li class="row2">
									<div class="inner flexbox">
										<label></label>
										<div class="selbox flex1">
											<span class="sex J__selSex"><i class="male<%=(user.Sex=="男"?" selected":"") %>" data-val="1">男</i><i class="female<%=(user.Sex=="女"?" selected":"") %>" data-val="0">女</i></span>
										</div>
                                        <input type="hidden" value="<%=user.Sex %>" id="txt_sex">
                                        <input type="hidden" value="<%=user.Mobile %>" id="txt_tel"/>
									</div>
								</li>
								<li>
									<div class="inner flexbox">
										<label>邮箱</label>
										<div class="iptbox flex1">
											<input class="ipttext" type="text" id="txt_email" name="email" value="<%=user.Email %>" placeholder="推荐填写QQ邮箱" />
										</div>
									</div>
								</li>
							</ul>
						</div>

						<div class="submit-btn" style="position: relative;">
							<a href="javascript:void(0)"  id="svae_msg" style="background:#12b7f5">保存</a>
						</div>
						<script type="text/javascript">
						    $(function () {
						        $(".J__selSex i").on("click", function () {
						            $(this).addClass("selected").siblings().removeClass("selected");
						            $('#txt_sex').val($(this).text());

						        });
						    });
						</script>
					</div>
				</div>
			</section>
		</section>
	</article>
	   <%  Html.RenderPartial("Footer", viewDic);  %>
</body>
</html>
<script src="../../Scripts/layer/layer.js" type="text/javascript"></script>
<script type="text/javascript">
           $(function () {
             
               $('#svae_msg').on('click', function () {
                   var name = $('#txt_name').val(), sex = $('#txt_sex').val(), tel = $('#txt_tel').val(), email = $('#txt_email').val(), userWeixinNO = '<%=user.WeiXinNO %>';
                   if (name == '') {
                       alert('请填写真实姓名');
                       return false;
                   }
                   if (sex == '') {
                       layer.msg('请选择性别');
                       return false;
                   }
                   if (tel == '') {
                       layer.msg('请填写联系手机号');
                       return false;
                   }
                   //            if(!/^(?:13\d|15[89])-?\d{5}(\d{3}|\*{3})$/.test(tel)){
                   //                alert('请填写正确手机号');
                   //                return false;
                   //            }
                   if (email == '') {
                       layer.msg('请填写QQ邮箱');
                       return false;
                   }
                   if (!/^([a-zA-Z0-9]+[_|_|.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|_|.]?)*[a-zA-Z0-9]+\.(?:com|cn)$/.test(email)) {
                       layer.msg('请填写正确QQ邮箱');
                       return false;
                   }
                   if (userWeixinNO == '') {
                       layer.msg('参数异常，请刷新重试！');
                       return false;
                   }
                   var tmp = {
                       userWeixinNO: userWeixinNO,
                       weixinID: '<%=ViewData["weixinID"] %>',
                       email: email,
                       name: name,
                       mobile: tel,
                       sex: sex
                   };
                   $.post("/User/SaveUserInfo", tmp, function (data) {
                       if (data.error == '0') {
                           layer.msg('保存成功！');
                           location.href = '/User/Index/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=user.WeiXinNO %>';
                       } else {
                           layer.msg(data.message);
                       }
                   });
               });
           });
</script>
