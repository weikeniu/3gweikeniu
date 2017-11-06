<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

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
<title>拼团</title>
<link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/travel.css"/>
<link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/font/iconfont.css"/>
<!--<link type="text/css" rel="stylesheet" href="../css/booklist/fontSize.css"/>-->
<script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/fontSize.js"></script>

</head>
<body class="yu-bpad90r">
	<article class="base-page">
	<section class="yu-h80r yu-bgw yu-bor bbor yu-grid yu-alignc">
		<div class="yu-overflow yu-lrpad20r">
			<div class="search-bg2 yu-grid yu-alignc">
				<span class="iconfont icon-soushuo1 yu-rmar10r yu-c99 search"></span>
				<input type="text" class="yu-overflow" id="keyword" placeholder="搜索目的地/景点/活动" />
			</div>
		</div>
		<!--<input type="button" value="约伴" class="sub-btn yu-rmar20r" />-->
		<a href="/TravelTheme/EditTheme/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>">
			<div class="yu-c40 yu-f26r yu-rpad20r">
				<span class="iconfont icon-pintuan yu-f26r"></span>
				<span>约伴</span>
			</div>
		</a>
		
	</section>
	<section class="yu-bgw" id="listid">
		<%--<a class="yu-grid yu-bor bbor yu-tbpad20r" href="3-1-5旅行社 - 拼团 - 详情.html">
			<div class="yu-w80r yu-f20r yu-textc yu-tpad5r">
				<p class="iconfont icon-tianshu yu-blue2 yu-f24r yu-bmar10r"></p>
				<p class="yu-c99">12天</p>
			</div>
			<div class="yu-overflow yu-rpad20r">
				<p class="yu-f30r yu-bmar20r yu-c22">2017年7月2日色达亚青寺年宝唐克诺尔盖扎尕那约伴 <span class="official-mark">官方</span></p>
				<div class="yu-grid yu-f20r yu-c77">
					<div class="yu-overflow">
						<span class="yu-rmar20r">广州</span><span>2017.07.07</span>
					</div>
					<div><div class="user-img"><img src="../images/fx-com-pht.png" /></div><span>昼昼昼</span></div>
				</div>
			</div>
		</a>--%>
	</section>
 <footer class="screen-bottom yu-grid yu-alignc yu-f26r yu-c22">
 	<div class="yu-overflow">
 		<div class="yu-grid yu-alignc yu-j-c yu-h90r local-btn">
 			<p class="yu-rmar10r nav-btn1">广州</p>
 			<p class="arr"></p>
 		</div>
 	</div>
 	<div class="yu-overflow">
 		<div class="yu-grid yu-alignc yu-j-c sort-btn yu-h90r">
 			<p class="yu-rmar10r">推荐排序</p>
 			<p class="arr"></p>
 		</div>
 	</div>
 	<div class="yu-overflow">
 		<div class="yu-grid yu-alignc yu-j-c screen-btn yu-h90r">
 			<p class="yu-rmar10r">类别筛选</p>
 			<p class="arr"></p>
 		</div>
 	</div>
 </footer>
 <a class="fix-me" href="/TravelTheme/MyTheme/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>">
 	<p class="iconfont icon-wode yu-f40r yu-tpad10r"></p>
 	<p class="yu-f26r">我的</p>
 </a>
 </article>
<!--目的地-->

<!--目的地end-->
 <!--排序-->
 <div class="mask sort-mask">
 	<div class="mask-inner ">
 		<ul class="yu-f26r sort-list">
 			<li class="yu-grid yu-alignc yu-blue" sdata="0">
 				<p class="iconfont icon-gouxuan yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">推荐排序</p>
 			</li>
 			<li class="yu-grid yu-alignc"  sdata="3">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">距离优先</p>
 			</li>
 			<li class="yu-grid yu-alignc" sdata="2">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">低价优先</p>
 			</li>
 			<li class="yu-grid yu-alignc" sdata="1">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">高价优先</p>
 			</li>
 		</ul>
 	</div>
 </div>
 <!--筛选-->
 <div class="mask screen-mask">
 	<div class="mask-inner yu-lrpad20r">
 		<div class="yu-grid yu-h90r yu-f32r yu-alignc yu-bor bbor yu-textc yu-j-s  yu-bmar60r" >
 			<p class="yu-w120r cancel-btn2">取消</p>
 			<p class="yu-w120r yu-blue2  cancel-btn2" onclick="javascript:seltype()">完成</p>
 		</div>
	 	<dl class="">
 			<dt class="yu-f26r yu-c99 yu-bmar30r">类别筛选(复选)</dt>
	 		<dd class="yu-grid yu-j-s type-screen">
	 			<div class="cur" id="type-0">不限</div>
	 			<div>休闲户外</div>
		 		<div>山野</div>
		 		<div>旅行</div>
		 		<div>骑行</div>
		 		<div>潜水</div>
		 		<div>自驾</div>
		 		<div>跑步</div>
		 		<div>水上运动</div>
		 		<div>技术攀登</div>
		 		<div>日常锻炼</div>
		 		<div>极限运动</div>
		 		<div>滑雪</div>
		 		<div>公益</div>
		 		<div>其他</div>
	 		</dd>
	 	</dl>
 	</div>
 	 
 </div>


  <!--区域-->
 <%Html.RenderPartial("SelectLocat"); %>
  <div id="allmap" style="display:none;"></div>
<section class="loading-page" style="position: fixed;" style="display:none">
    <div class="inner">
	    <img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
	    <img src="http://css.weikeniu.com/images/loading-n.png" />
    </div>
</section>			

<script type="text/javascript">
    $(function () {
        //底部
        $(".screen-bottom>div").on("click", function () {
            $(this).toggleClass("cur").siblings().removeClass("cur");
        })

        //目的地
        $(".local-btn").click(function () {
            $(".base-page").hide();
            $(".local-page").show();
        })

        //mask通用
        $(".mask").click(function () {
            $(this).fadeOut();
            $(".screen-bottom>div").removeClass("cur");

        })
        $(".mask-inner").click(function (e) {
            e.stopPropagation();
        })
        //排序
        $(".sort-btn").click(function () {
            $(".sort-mask").fadeIn();
        })
        $(".sort-list>li").on("click", function () {
            $(this).addClass("yu-blue").siblings().removeClass("yu-blue");
            $(this).children(".iconfont").addClass("icon-gouxuan").parent().siblings().children(".iconfont").removeClass("icon-gouxuan");
            $(".sort-mask").fadeOut();
            $(".screen-bottom>div").removeClass("cur");

            isEnd = false;
            sort = 0; type = ''; page = 1
            var dd = $('.sort-list').children('.yu-blue');
            $.each(dd, function (i, t) {
                if (typeof ($(this).attr("sdata")) != 'undefined') {
                    sort = $(this).attr("sdata");
                }
            });
            //加载列表
            getlist();
        })

        //筛选
        $(".price-screen>div").on("click", function () {
            $(this).addClass("cur").siblings().removeClass("cur");
        })
        $(".type-screen>div").on("click", function () {
            $(this).toggleClass("cur");

            type = '';
            if ($(this).text() == '不限') {
                $(this).addClass("cur").siblings().removeClass('cur') ;
            } else {
                var tarr = $(".type-screen>div");
                if (tarr.length > 1) {
                    $('#type-0').removeClass("cur");
                }


                $.each(tarr, function (i, t) {
                    if ($(t).hasClass('cur')) {
                        type += $(t).text() + ',';
                    }
                });
                
            }
        })
        $(".cancel-btn2").on("click", function () {
            $(".mask").fadeOut();
            $(".screen-bottom>div").removeClass("cur");
            
        })
        $(".screen-btn").click(function () {
            $(".screen-mask").fadeIn();
        })


    })
    
    //类型帅选完成
    function seltype() {
        //console.log(type);
        isEnd = false;

        getlist();
     }

     function ThemeDetail(themeid) {
         window.location.href = '/TravelTheme/ThemeDetail/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&themeid=' + themeid;
      }
</script>
<script>
    loadstate(false);
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
    var type = '';
    var sort = 0;
    var cityname='';

    var url = "/TravelTheme/GetThemeList/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>";
        function getlist() {
            var keyworks=$('#keyword').val();
            console.log('isEnd='+isEnd+'type='+type+'  sort='+sort +'  page='+page+'cityname='+cityname+'keyworks='+keyworks);
            loadstate(true);
            if (!isEnd) {
                    $.ajax({ url: url,
                        async: true,
                        data: { page: page,pagesize:10,sort:sort,type:type,cityname:cityname,keyworks:keyworks},
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
                var title='<span class="official-mark">官方</span>';
                var creator='旅行社';
                var uwx=arr[i]["userweixinid"];
                if(uwx!=''){
                  creator='个人';
                  title='';
                }
                html+='<a class="yu-grid yu-bor bbor yu-tbpad20r" href="javascript:ThemeDetail(\''+arr[i]["themeid"]+'\')"><div class="yu-w80r yu-f20r yu-textc yu-tpad5r"><p class="iconfont icon-tianshu yu-blue2 yu-f24r yu-bmar10r"></p><p class="yu-c99 yu-f20r">'+arr[i]["days"]+'天</p></div><div class="yu-overflow yu-rpad20r"><p class="yu-f30r yu-bmar20r yu-c22">'+arr[i]["themename"]+title+'</p><div class="yu-grid yu-f20r yu-c77"><div class="yu-overflow"><span class="yu-rmar20r">'+arr[i]["startcity"]+'</span><span>'+arr[i]["createtime"]+'</span></div><div><div class="user-img"><img src="'+arr[i]["img"]+'"/></div><span>'+arr[i]["nickname"]+'</span></div></div></div></a>'
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


    $(".search").on('click', function () {
        page = 1;
        isEnd = false;
        type = '';
        sort = 0;
        keyword = $('#keyword').val();
        getlist();
    });

    //根据位置搜索
    function ChangeLocat(locat, locatName) {
        if (locat == '' || locatName == '') {
            window.location.reload();
        } else {
            page = 1;
            isEnd = false;
            type = '';
            sort = 0;
            lnglat = locat;
            cityname = locatName;

            getlist();
        }
    }


    var hasDataCityName = "";
    var hasDataCityName2 = "";
    //获取周边商家城市地址
    function GetDataStoreLocat() {
        $.ajax({
            type: "post",
            url: '/TravelTheme/GetThemeLocat/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>',
            dataType: 'json'
        }).done(function (data) {
            var newdata = $.parseJSON(data["data"]);
            if (newdata.length == 0) {
            } else {

                //控制地址显示
                for (var i = 0; i < newdata.length; i++) {
                    hasDataCityName = hasDataCityName + newdata[i].city + ",";
                    hasDataCityName2 = hasDataCityName2 + newdata[i].city2 + ",";
                }

                ClearCur();
                HideLocat();

                HideAll();
                ShowLocal(hasDataCityName, hasDataCityName2);
            }
        });
    }
    GetDataStoreLocat();

</script>

<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=Y4ofkWPl6nHN41oFEZj39HPA"></script>
<script type="text/javascript">
    new BMap.LocalCity().get(function (res) {
        //获取当前用户所在城市,酒店有该城市数据则替换默认城市。
        var city = res.name.replace('市', '');
        $(".sp").find(".sp_lab").html(city);
        $(".letter dd>p").each(function () {
            if (city.indexOf($(this).find(".sp_lab").html()) > -1) {
                $(".sp").find(".sp_hid").val($(this).find(".sp_hid").val());
                //lnglat = $(this).find(".sp_hid").val();
            }
        });
    });
    </script>
</body>
</html>
