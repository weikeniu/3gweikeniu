<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    string css = System.Configuration.ConfigurationManager.AppSettings["cssUrl"];
    string js = System.Configuration.ConfigurationManager.AppSettings["jsUrl"];

    bool hasSignIn = (bool)ViewData["hasSignIn"];

    hotel3g.Models.LXS_ThemeView model = (hotel3g.Models.LXS_ThemeView)ViewData["model"];
    List<hotel3g.Models.LXS_JoinTheme> listJoin = (List<hotel3g.Models.LXS_JoinTheme>)ViewData["listJoin"];
         %>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta name="keywords" content="关键词1,关键词2,关键词3" />
<meta name="description" content="对网站的描述" />
<meta name="format-detection" content="telephone=no">
<!--自动将网页中的电话号码显示为拨号的超链接-->
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
<!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
<meta name="apple-mobile-web-app-capable" content="yes">
<!--IOS设备-->
<meta name="apple-touch-fullscreen" content="yes">
<!--IOS设备-->
<meta http-equiv="Access-Control-Allow-Origin" content="*">
<title>拼团详情</title>
<link type="text/css" rel="stylesheet" href="<%=css %>/css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="<%=css %>/css/booklist/travel.css"/>
<link type="text/css" rel="stylesheet" href="<%=css %>/css/booklist/font/iconfont.css"/>
<!--<link type="text/css" rel="stylesheet" href="../css/booklist/fontSize.css"/>-->
<script type="text/javascript" src="<%=js %>/Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=js %>/Scripts/fontSize.js"></script>
    <script src="<%=js %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body class="yu-bpad120r">
	<article class="yu-bgw base-page">
		<section class="yu-overflow yu-lrpad20r">
			<div class="yu-bor bbor yu-tbpad20r">
					<p class="yu-f30r yu-bmar20r"><%=model.themename %><%--<span class="official-mark">官方</span>--%></p>
					<div class="yu-grid yu-f20r yu-blue2">
						<div class="yu-overflow">
							<div class="user-img"><img src="<%=model.img %>" /></div><span><%=model.nickname %></span>
						</div>
						<div>#<%=model.themetype %></div>
					</div>
			</div>
		</section>
		<section class="yu-lpad20r yu-bmar40r">
			<ul class="yu-f26r">
				<li class="yu-grid yu-alignc yu-h65r yu-l65r">
					<p class="yu-c77 yu-w140r">出发地</p>
					<div class="yu-overflow yu-bor bbor">
						<span><%=model.startcity %></span>
					</div>
				</li>
				<li class="yu-grid yu-alignc yu-h65r yu-l65r">
					<p class="yu-c77 yu-w140r">目的地</p>
					<div class="yu-overflow yu-bor bbor">
                       <% foreach (var city in (model.endcity+"").Split(','))
                          { %>
						<span class="yu-rmar20r"><%=city%></span>
                        <%} %>
						<%--<span class="yu-rmar20r">门源</span>
						<span class="yu-rmar20r">祁连县</span>
						<span class="yu-rmar20r">张掖</span>
						<span class="yu-rmar20r">茶卡盐湖</span>
						<span class="yu-rmar20r">敦煌</span>--%>
					</div>
				</li>
				<li class="yu-grid yu-alignc yu-h65r yu-l65r">
					<p class="yu-c77 yu-w140r">行程日期</p>
					<div class="yu-overflow yu-bor bbor">
						<span><%=model.begintime.ToShortDateString() %>-<%=model.endtime.ToShortDateString() %></span>
						<span class="fr yu-c99 yu-f20r yu-rpad20r">共<%=model.days %>天</span>
					</div>
				</li>
				<li class="yu-grid yu-alignc yu-h65r yu-l65r">
					<p class="yu-c77 yu-w140r">集合日期</p>
					<div class="yu-overflow yu-bor bbor">
						<span class="yu-rmar20r"><%=model.begintime.ToShortDateString() %></span>
						<span><%=model.goingtime %></span>
					</div>
				</li>
				<li class="yu-grid yu-alignc yu-h65r yu-l65r">
					<p class="yu-c77 yu-w140r">活动费用</p>
					<div class="yu-overflow yu-bor bbor">
						<span>
                        <%=model.costtype == 0 ? string.Format("人均分摊 预计{0}元", model.costmoney) : ""%>
                        <%=model.costtype == 1 ? string.Format("固定收费 预计{0}元", model.costmoney) : ""%>
                        <%=model.costtype==2?"免费":"" %>
                        </span>
					</div>
				</li>
				<li class="yu-grid yu-alignc yu-h65r yu-l65r">
					<p class="yu-c77 yu-w140r">参加人数</p>
					<div class="yu-overflow yu-bor bbor" id="J__joinMem">
						<span><%=listJoin.Count%>/<%=model.peoplenumber %></span>
						<span class="fr yu-c99 yu-f20r yu-rmar10 yu-rpad33r yu-arr">全部</span>
					</div>
				</li>
			</ul>
		</section>
		<section class="yu-lrpad20r yu-bpad20r yu-bor bbor">
			<div class="yu-f28r"><%=model.content %></div>
		<ul class="content-pic">
			<%--<li><img src="../images/114.png" /></li>
			<li><img src="../images/114.png" /></li>--%>
            <% foreach (var url in (model.imgurls + "").Split(','))
               {
                   if (url.Length > 10)
                   { %>
                 <li><img src="<%=url %>" /></li>
            <%    }
               }%>
		</ul>
		</section>
		<section class="yu-lrpad20r yu-tpad40r">
			<h3 class="yu-f28r yu-f-wn yu-bmar40r">全部回复</h3>
			<ul>
                <% foreach (var item in listJoin)
                   {
                       if (!string.IsNullOrEmpty(item.message))
                       { %>
				<li class="yu-grid yu-bmar30r" data-name="<%=item.nickname %>" data-name-id="<%=item.joinid %>">
					<div class="user-img type2 yu-rmar20r"><img src="<%=item.img %>" /></div>
					<div class="yu-overflow yu-f28r yu-bor bbor yu-bpad30r">
						<div class="yu-l50r">
							<span class="yu-f28r yu-rmar20r"><%=item.nickname%></span>
							<span class="yu-f20r yu-c99"><%=(DateTime.Now - item.createtime).Hours%>小时前</span>
							<% if ((ViewData["uwx"] + "").ToLower() == (model.userweixinid + "").ToLower())
                              { %>
                            <span class="iconfont icon-pinlun yu-f30r yu-cbb fr u-reply"></span>
                            <%} %>
						</div>
                        <% if (string.IsNullOrEmpty(item.replylist))
                           { %>
                        <div class="yu-f28r">
							<%=item.message%>
						</div>
                        <%}
                           else
                           { %>
                        <div class="quote yu-grid  yu-f24r">
							<a href="#" class="yu-blue2 yu-lrpad15r"><%=item.nickname%></a>
							<div class="yu-c99 yu-overflow"><%=item.message%></div>
						</div>
                        <%} %>

						<%
                    if (!string.IsNullOrEmpty(item.replylist))
                    {
                        string[] strs = item.replylist.Split('|');
                        foreach (string msg in strs)
                        {
                           %>
                             <div class="yu-f28r"><%=msg%></div>
                        <%}
                    }%>
					</div>
				</li>
                <%}
                   } %>
			</ul>
		</section>
	</article>
	
	<!--弹窗(参加人数)-->
	<article class="popup-wrap popup__joinMem" style="display: none;">
		<div class="join-member">
			<div class="hd yu-c99 yu-f24r yu-grid"><span class="yu-flex1">已确认参加<%=listJoin.Count%>人</span> <em><%=string.IsNullOrEmpty(model.userweixinid) ? "个人发起" : "官方发起"%></em></div>
			<div class="bd">
				<ul class="list">
                  <% 
                      int first = 0; 
                     foreach (var item in listJoin)
                     { %>
					<li class="yu-grid yu-alignc">
						<div class="u-img">
							<img src="<%=item.img%>" />
							<p class="sex iconfont icon-nu"></p>
						</div>
						<div class="info yu-flex1 yu-bor bbor">
							<p class="yu-f30r"><%=item.nickname%></p>
							<p class="yu-f24r yu-c99"><%=item.themetype==1?"":(first == 0 ? "发起人" : "成员")%></p><!---themetype==1旅行社发起--->
						</div>
					</li>
                    <%
                        first++;
                     } %>

					<%--<li class="yu-grid yu-alignc">
						<div class="u-img">
							<img src="../images/cp.jpg" />
							<p class="sex iconfont icon-nan"></p>
						</div>
						<div class="info yu-flex1 yu-bor bbor">
							<p class="yu-f30r">山鬼咬</p>
							<p class="yu-f24r yu-c99">成员</p>
						</div>
					</li>--%>
				</ul>
			</div>
		</div>
	</article>
	
	<!--弹窗(报名)-->
	<article class="popup-wrap popup__signUp" style="display: none;">
		<div class="signup-wrap yu-grid yu-grid-column">
			<div class="sign-forms yu-flex1">
				<ul>
					<li>
						<p class="yu-blue2 yu-f28r">基本资料</p>
						<p class="ipt_box"><input type="text" id="username" name="username" placeholder="姓名" /></p>
						<p class="ipt_box"><input type="tel" id="telphone" name="telphone" placeholder="手机号码" /></p>
					</li>
					<li>
						<p class="yu-blue2 yu-f28r">活动留言</p>
						<p class="area_box"><textarea name="message" id="message" maxlength="30" placeholder="30字以内"></textarea></p>
					</li>
					<li>
						<p class="yu-blue2 yu-f28r">活动费用</p>
						<p class="yu-f24r yu-tmar5">参与此次活动费用为：<span class="yu-c40"><%=model.costmoney %>元/人</span></p>
					</li>
					<li>
						<p class="yu-blue2 yu-f28r">活动报名须知</p>
						<p class="yu-c99 yu-f24r yu-underline yu-tmar5">我已阅读并同意声明</p>
					</li>
				</ul>
			</div>
			<div class="ft-btn">
				<a class="J__sureSignUp" href="javascript:Save()">确认报名</a>
			</div>
		</div>
	</article>
	<!--确认报名弹窗-->
	<section class="mask signup-mask" >
		<div class="yu-bgw popup-signup-tip">
			<p class="yu-font18 yu-bmar10">确认提交</p>
			<p class="yu-font16 yu-bmar20 yu-c99">确认资料无误，并填写完毕</p>
			<div class="yu-grid yu-bor tbor yu-h50 yu-line50 yu-font16">
				<p class="yu-overflow yu-bor rbor yu-greys sign-cancel" >取消</p>
				<p class="yu-overflow yu-blue2 sign-ok">确认</p>
			</div>
		</div>
	</section>
	
	<!--确认退出弹窗-->
	<section class="mask quit-mask" >
		<div class="yu-bgw popup-signup-tip">
			<p class="yu-font18 yu-bmar10">确认退出</p>
			<p class="yu-font16 yu-bmar20 yu-c99">是否确认退出该活动</p>
			<div class="yu-grid yu-bor tbor yu-h50 yu-line50 yu-font16">
				<p class="yu-overflow yu-bor rbor yu-greys quit-cancel" >取消</p>
				<p class="yu-overflow yu-blue2 quit-ok">退出</p>
			</div>
		</div>
	</section>
	
	
	<footer class="fix-bottom3 ">
        <% if (model.status != 2)
           { %>
		<div  class="inner yu-grid yu-alignc yu-lrpad20r">
			<p class="iconfont icon-fenxiang yu-blue2 yu-f32r yu-rmar20r"></p>
            <% if ((ViewData["uwx"] + "").ToLower() == (model.userweixinid+"").ToLower())
               { %>
			<input type="text" placeholder="回复" class="yu-overflow reply-input" id="replymsg"/>
            <%} %>
			<!--报名按钮 召集中，未报名，未达到限制人数-->
			<% 
                if (model.status == 0 && !hasSignIn && listJoin.Count<model.peoplenumber)
                { %>
            <input type="button" value="报名" class="btn__signUp yu-btn7 yu-lmar20r" />
            <%} %>
			<input type="button" value="发送" class="btn__replyUp yu-btn7 yu-lmar20r" onclick="javascript:SaveReply()" style="display:none"/>
			<!--报名后退出-->
            <%if (hasSignIn && model.status==0 && (ViewData["uwx"] + "").ToLower() != (model.userweixinid+"").ToLower())
              { %>
			 <div class="btn__quit yu-blue2"><i class="iconfont icon-tuichu"></i> 退出</div>
            <%} %>
		</div>
        <%} %>
	</footer>
	
	<script type="text/javascript">
	    /** ---回复框获取、失去焦点--- */
	    $(".reply-input").focus(function () {
	        $(this).siblings(".btn__signUp").hide();
	        $(this).siblings(".btn__replyUp").show();
	    });
	    $(".reply-input").blur(function () {
	        var that = this;
	        setTimeout(function () {
	            $(that).siblings(".btn__signUp").show();
	            $(that).siblings(".btn__replyUp").hide();
	        }, 300);

	    });
       
	    //点击回复按钮(控制回复人)
	    var uname = '';
	    var joinid = '0';
	    $(".u-reply").on("click", function () {
	        uname = $(this).parents("li").attr("data-name");
	        joinid = $(this).parents("li").attr("data-name-id");
	        //console.log(uname);
	        $(".reply-input").attr("placeholder", "回复" + uname);
	    });


	    /** ---报名--- */
	    $(".btn__signUp").on("click", function () {
	        $(".base-page").hide();
	        $(".popup__signUp").show();
	    });
	    //确认报名
//	    $(".J__sureSignUp").on("click", function () {
//	        $(".signup-mask").fadeIn(200);
//	    });
	    $(".sign-ok").on("click", function () {
	        //alert("报名成功");
	        $(".base-page").show();
	        $(".popup__signUp").hide();
	        $(".signup-mask").fadeOut(200);
	    });
	    $(".sign-cancel").on("click", function () {
	        $(".signup-mask").fadeOut(200);
	    });

	    /** ---报名后退出--- */
	    $(".btn__quit").on("click", function () {
	        $(".quit-mask").fadeIn(200);
	    });
	    $(".quit-ok").on("click", function () {
	        //alert("退出成功");
	        var data = { themeid: '<%=model.themeid %>', uwx: '<%=ViewData["uwx"] %>' };
	        $.post('/TravelTheme/QuitOut/', data, function (data) {
	            if (data.success) {
	                window.location.href = '/TravelTheme/ThemeIndex/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>';
	                $(".quit-mask").fadeOut(200);
	            } else {
	                layer.msg('退出失败！');
	            }
	        });
	        
	    });
	    $(".quit-cancel").on("click", function () {
	        $(".quit-mask").fadeOut(200);
	    });


	    /** ---参加人员--- */
	    $("#J__joinMem").on("click", function () {
	        $(".base-page").hide();
	        $(".popup__joinMem").show();
	    });
	    //关闭(参加人员)
	    $(".popup__joinMem").on("click", function () {
	        $(this).hide();
	        $(".base-page").show();
	    })
	</script>

    <script type="text/javascript">
        function Save() {
            var username = $("#username").val();
            var telphone = $("#telphone").val();
            var message = $("#message").val();
            if (username == '') { layer.msg('请输入姓名！'); return false; }
            if (telphone == '') { layer.msg('请输入手机号！'); return false; }

            var data = { username: username, telphone: telphone, message: message,key:'<%=ViewData["key"] %>',themeid:'<%=model.themeid %>' };
            $.post('/TravelTheme/SaveJoin/', data, function (data) {
                if (data.success) {
                    window.location.reload();
                } else {
                    layer.msg(data.msg);
                    setTimeout(function () { window.location.reload(); }, 300);
                }
            });
        }

        function SaveReply() {
            var replymsg = $('#replymsg').val();
            if (replymsg == '') {
                layer.msg('回复内容不能为空！');
                return false;
            }

            var data = { replymsg: replymsg, joinid: joinid, joinname: uname, key: '<%=ViewData["key"] %>', themeid: '<%=model.themeid %>' };
            $.post('/TravelTheme/SaveReply/', data, function (data) {
                if (data.success) {
                    window.location.reload();
                } else {
                    layer.msg(data.msg);
                    setTimeout(function () { window.location.reload(); }, 300);
                }
            });

            uname = '';
            joinid = '0';
            $('#replymsg').val('')
            $(".btn__replyUp").hide();
        }
    </script>
</body>
</html>
