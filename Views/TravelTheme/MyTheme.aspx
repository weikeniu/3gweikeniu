<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%
    string css = System.Configuration.ConfigurationManager.AppSettings["cssUrl"];
    string js = System.Configuration.ConfigurationManager.AppSettings["jsUrl"];

    System.Data.DataTable myinfo = (System.Data.DataTable)ViewData["myinfo"];
    System.Data.DataRow myinforow = myinfo.Rows.Count > 0 ? myinfo.Rows[0] : null;

    List<hotel3g.Models.LXS_ThemeView> listTheme = (List<hotel3g.Models.LXS_ThemeView>)ViewData["list"];
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
<title>我的拼团</title>
<link type="text/css" rel="stylesheet" href="<%=css %>/css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="<%=css %>/css/booklist/travel.css"/>
<link type="text/css" rel="stylesheet" href="<%=css %>/css/booklist/font/iconfont.css"/>
<!--<link type="text/css" rel="stylesheet" href="../css/booklist/fontSize.css"/>-->
<script type="text/javascript" src="<%=js %>/Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=js %>/Scripts/fontSize.js"></script>

</head>
<body class="yu-bgw">
	<section class="my-center yu-bgblue2 yu-h180r yu-w-full yu-grid yu-alignc yu-arr">
		<!--<div>
			<div class="my-pic"><img src="../images/fx-order-pht.png" /></div>
			<p class="gender iconfont icon-nu"></p>
		</div>
		<div>
			
		</div>-->
		<div class="my-pic">
			<img src="<%=myinforow==null?"":myinforow["photo"] %>" />
			<p class="gender iconfont icon-nu"></p>
		</div>
		<div class="my-info">
			<h2 class="nickname yu-f30r"><%=myinforow==null?"":myinforow["nickname"] %></h2>
			<label class="addr yu-f22r"><%--广东广州--%></label>
		</div>
	</section>
	
	<section class="tab-con yu-bgw">
		<ul class="tab-nav yu-bor bbor yu-grid yu-alignc yu-h90r yu-f28r yu-textc">
			<li class="cur yu-overflow"><p>发起活动</p></li>
			<li class="yu-overflow"><p>参与活动</p></li>
		</ul>
		<ul class="tab-inner sp">
			<li class="cur" id="listid">
				<%--<a class="yu-grid yu-bor bbor yu-tbpad20r" href="3-1-5旅行社 - 拼团 - 详情.html">
					<div class="yu-w80r yu-f20r yu-textc yu-tpad5r">
						<p class="iconfont icon-tianshu yu-c99 yu-f24r yu-bmar10r"></p>
						<p class="yu-c99 yu-f20r">12天</p>
					</div>
					<div class="yu-rpad20r">
						<div class="yu-grid">
							<p class="yu-f30r yu-bmar20r yu-black">2017年7月2日色达亚青寺年宝唐克诺尔盖扎尕那约伴</p>
							<p class="yu-c99 yu-f22r yu-textr yu-w100r yu-tpad5r">已结束</p>
						</div>
						<div class="yu-grid">
							<div class="yu-overflow yu-c77 yu-f20r">
								<span class="yu-rmar20r">广州</span><span>2017.07.07</span>
							</div>
							<div class="yu-f20r"><div class="user-img"><img src="../images/fx-com-pht.png" /></div><span class="yu-f20r yu-c77">旅行社</span></div>
						</div>
					</div>
				</a>--%>
			</li>
			<li>
			    <%--<a class="yu-grid yu-bor bbor yu-tbpad20r" href="3-1-5旅行社 - 拼团 - 详情.html">
					<div class="yu-w80r yu-f20r yu-textc yu-tpad5r">
						<p class="iconfont icon-tianshu yu-c99 yu-f24r yu-bmar10r"></p>
						<p class="yu-c99 yu-f20r">12天</p>
					</div>
					<div class="yu-rpad20r">
						<div class="yu-grid">
							<p class="yu-f30r yu-bmar20r yu-black">2017年7月2日色达亚青寺年宝唐克诺尔盖扎尕那约伴</p>
							<p class="yu-c99 yu-f22r yu-textr yu-w100r yu-tpad5r">已结束</p>
						</div>
						<div class="yu-grid">
							<div class="yu-overflow yu-c77 yu-f20r">
								<span class="yu-rmar20r">广州</span><span>2017.07.07</span>
							</div>
							<div class="yu-f20r"><div class="user-img"><img src="../images/fx-com-pht.png" /></div><span class="yu-f20r yu-c77">旅行社</span></div>
						</div>
					</div>
				</a>
                <a class="yu-grid yu-bor bbor yu-tbpad20r" href="3-1-5旅行社 - 拼团 - 详情.html">
					<div class="yu-w80r yu-f20r yu-textc yu-tpad5r">
						<p class="iconfont icon-tianshu yu-c99 yu-f24r yu-bmar10r"></p>
						<p class="yu-c99 yu-f20r">12天</p>
					</div>
					<div class="yu-rpad20r">
						<div class="yu-grid">
							<p class="yu-f30r yu-bmar20r yu-black">2017年7月2日色达亚青寺年宝唐克诺尔盖扎尕那约伴</p>
							<p class="yu-c99 yu-f22r yu-textr yu-w100r yu-tpad5r">已结束</p>
						</div>
						<div class="yu-grid">
							<div class="yu-overflow yu-c77 yu-f20r">
								<span class="yu-rmar20r">广州</span><span>2017.07.07</span>
							</div>
							<div class="yu-f20r"><div class="user-img"><img src="../images/fx-com-pht.png" /></div><span class="yu-f20r yu-c77">旅行社</span></div>
						</div>
					</div>
				</a>--%>
			</li>
		</ul>
	</section>
    <section class="loading-page" style="position: fixed;" style="display:none">
    <div class="inner">
	    <img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
	    <img src="http://css.weikeniu.com/images/loading-n.png" />
    </div>
</section>
	<script type="text/javascript">
	    $(function () {
	        //选项卡
	        var tabIndex;
	        $(".tab-nav").children("li").on("click", function () {
	            $(this).addClass("cur").siblings("li").removeClass("cur");
	            tabIndex = $(this).index();
	           // $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
               type=tabIndex;
               page = 1;
               isEnd=false;
               getlist();
	        })
	    })


    function loadstate(display) {
        if (display) {
            setTimeout(function () {
                $(".loading-page").hide();
            }, 5000);
            $(".loading-page").show();

        } else {
            $(".loading-page").hide();
        }
    }

    //获取分页
    var page = 1;
    var isEnd = false;
    var type = '0';
    var userweixinid='<%=ViewData["uwx"] %>';
    var url = "/TravelTheme/GetMyThemeList/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>";
        function getlist() {
            loadstate(true);
            if (!isEnd) {
                    $.ajax({ url: url,
                        async: true,
                        data: { page: page,pagesize:10,type:type},
                        type: "post",
                        success: function (data) {
                            //获取成功
                            if (data.success) {
                               if(page == data.nextpage){
                                  //$(".uc__loading-tips").html("没有更多了...");
                                  isEnd=true;
                               }else{
                                  page = data.nextpage;
                                }
                              
                                packList(data.msg);
                            } 
                            loadstate(false);
                        },
                        timeout: 5000,
                        complete: function (XMLHttpRequest, status) {
                            loadstate(false);
                            //请求完成后最终执行参数
                            if (status == 'timeout') {
                                //超时,status还有success,error等值的情况
                                layer.msg('网络超时!')
                            }
                        }
                    });
            } else {
                loadstate(false);
            }
        }

        function packList(json) {
            var html = '';
            var arr = eval('(' + json + ')');
            var status = '';
            $.each(arr, function (i, t) {
                //console.log(arr[i]);
                var creator='旅行社';
                var uwx=arr[i]["userweixinid"];
                if(uwx==''){
                  creator='个人';
                }

                var statusname='<p class="yu-c40 yu-f22r yu-textr yu-w100r yu-tpad5r">召集中</p>'
                var status=arr[i]["status"];
                if(status=='1'){
                    statusname='<p class="yu-c99 yu-f22r yu-textr yu-w100r yu-tpad5r">进行中</p>'
                }
                if(status=='2'){
                    statusname='<p class="yu-c99 yu-f22r yu-textr yu-w100r yu-tpad5r">已结束</p>'
                }
                var img='';//头像url
                if(arr[i]["img"]!=null){
                 img=arr[i]["img"];
                }
                //console.log(uwx+'|'+userweixinid);
               if(type==0 && uwx.toLocaleLowerCase()==userweixinid.toLocaleLowerCase()){
                   html+='<a class="yu-grid yu-bor bbor yu-tbpad20r"href="javascript:ThemeDetail(\''+arr[i]["themeid"]+'\')"><div class="yu-w80r yu-f20r yu-textc yu-tpad5r"><p class="iconfont icon-tianshu yu-c99 yu-f24r yu-bmar10r"></p><p class="yu-c99 yu-f20r">'+arr[i]["days"]+'天</p></div><div class="yu-rpad20r"><div class="yu-grid"><p class="yu-f30r yu-bmar20r yu-black">'+arr[i]["themename"]+'</p>'+statusname+'</div><div class="yu-grid"><div class="yu-overflow yu-c77 yu-f20r"><span class="yu-rmar20r">'+arr[i]["startcity"]+'</span><span>'+arr[i]["createtime"]+'</span></div><div class="yu-f20r"><div class="user-img"><img src="'+img+'"/></div><span class="yu-f20r yu-c77">'+arr[i]["nickname"]+'</span></div></div></div></a>'
               }
               if(type==1){
                   html+='<a class="yu-grid yu-bor bbor yu-tbpad20r"href="javascript:ThemeDetail(\''+arr[i]["themeid"]+'\')"><div class="yu-w80r yu-f20r yu-textc yu-tpad5r"><p class="iconfont icon-tianshu yu-c99 yu-f24r yu-bmar10r"></p><p class="yu-c99 yu-f20r">'+arr[i]["days"]+'天</p></div><div class="yu-rpad20r"><div class="yu-grid"><p class="yu-f30r yu-bmar20r yu-black">'+arr[i]["themename"]+'</p>'+statusname+'</div><div class="yu-grid"><div class="yu-overflow yu-c77 yu-f20r"><span class="yu-rmar20r">'+arr[i]["startcity"]+'</span><span>'+arr[i]["createtime"]+'</span></div><div class="yu-f20r"><div class="user-img"><img src="'+img+'"/></div><span class="yu-f20r yu-c77">'+arr[i]["nickname"]+'</span></div></div></div></a>'
               }
               
            });
            $('#listid').html(html);
        }

        getlist();
        var windowHeight = $(window).height();

        $(window).scroll(function () {
            var scrollTop = $(this).scrollTop(); //滚动高度
            var windowHeight = $(this).height(); //窗口可视高度
            
            var scrollHeight = $("body").get(0).scrollHeight; //窗口内容高度
            
            if (scrollTop + windowHeight == scrollHeight) {
                getlist();
            }
        });


        function ThemeDetail(themeid) {
          window.location.href = '/TravelTheme/ThemeDetail/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&themeid=' + themeid;
      }
</script>
</body>
</html>
