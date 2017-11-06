<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();

    
        
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
<title>商家列表</title>
<link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/travel.css"/>
<link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/font/iconfont.css"/>
<!--<link type="text/css" rel="stylesheet" href="../css/booklist/fontSize.css"/>-->
<script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=ViewData["jsUrl"] %>/swiper/swiper-3.4.1.jquery.min.js"></script>
<script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
<script src="http://js.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body class="">
 <article class="base-page">
<section class="yu-h80r yu-bgw yu-bor bbor yu-grid yu-alignc yu-lpad20r ">
		<div class="yu-overflow yu-rpad20r">
			<div class="search-bg2 yu-grid yu-alignc">
				<span class="iconfont icon-soushuo1 yu-rmar10r search"></span>
				<input type="text" class="yu-overflow" id="keyword" placeholder="搜索商家"/>
				<i class="ico-close J__iptClear">×</i>
			</div>
		</div>
	</section>
<section class="yu-grid yu-lrpad20r yu-h65r yu-bor bbor yu-alignc yu-bmar15r yu-bgw">
	<p class="yu-overflow yu-f24r">当前位置：<span class="current-location"></span></p>
	<span class="icon-shuaxin iconfont yu-blue yu-f36r"  onclick="javascript:location.reload()"></span>
</section>
	<ul class="" id="list_id">
		<%--<li class="yu-bgw yu-lpad20r yu-bmar15r">
			<a href="#">
				<div class="yu-grid yu-tbpad20r">
					<div class="near-pic3 full-img yu-rmar20r"><img src="../images/hotel-bigimg.jpg" /></div>
					<div class="yu-overflow">
						<p class="yu-f26r yu-black">淼鑫猪肚鸡（五羊新城店）</p>
						<div class="yu-f20r yu-c77">
							<p>粤菜</p>
							<p>人均￥56</p>
							<p>距离您<span class="yu-c40">0.8</span>公里</p>
							
						</div>
					</div>
				</div>
				<ul class="yu-c40 yu-f24r">
					<li class="yu-grid yu-alignc yu-h50r yu-bor tbor">
						<p class="iconfont icon-hongbao2 yu-rmar15r yu-f24r"></p>
						<p>新用户10元红包</p>
					</li>
					<li class="yu-grid yu-alignc yu-h50r yu-bor tbor">
						<p class="iconfont icon-zhekou yu-rmar15r yu-f24r"></p>
						<p>全场指定菜品8折起</p>
					</li>
					<li class="yu-grid yu-alignc yu-h50r yu-bor tbor">
						<p class="iconfont icon-manjian yu-rmar15r yu-f24r"></p>
						<p>满80减20，满120减40</p>
					</li>
				</ul>
			</a>
		</li>--%>
	</ul>
	 <div class="uc__loading-tips" style=" text-align:center; font-size:14px; height:30px;"></div>
	
	<footer class="screen-bottom yu-grid yu-alignc yu-f26r yu-c22">
 	<div class="yu-overflow">
 		<div class="yu-grid yu-alignc yu-j-c local-btn2">
 			<p class="yu-rmar10r nav-btn1">城市</p>
 			<p class="arr"></p>
 		</div>
 	</div>
 	<div class="yu-overflow">
 		<div class="yu-grid yu-alignc yu-j-c sort-btn">
 			<p class="yu-rmar10r">推荐排序</p>
 			<p class="arr"></p>
 		</div>
 	</div>
 	<div class="yu-overflow">
 		<div class="yu-grid yu-alignc yu-j-c screen-btn">
 			<p class="yu-rmar10r">筛选</p>
 			<p class="arr"></p>
 		</div>
 	</div>
 </footer>
 <!--排序-->
 <div class="mask sort-mask">
 	<div class="mask-inner ">
 		<ul class="yu-f26r sort-list">
 			<li class="yu-grid yu-alignc" sdata="1">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">距离优先</p>
 			</li>
 			<li class="yu-grid yu-alignc" sdata="2">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">低价优先</p>
 			</li>
 			<li class="yu-grid yu-alignc" sdata="3">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">高价优先</p>
 			</li>
 		</ul>
 	</div>
 </div>
 <!--筛选-->
 <div class="mask screen-mask">
 	<!--<div class="mask-inner yu-lrpad20r">
 		<div class="yu-grid yu-h90r yu-f32r yu-alignc yu-bor bbor yu-textc yu-j-s  yu-bmar60r" >
 			<p class="yu-w120r cancel-btn2">取消</p>
 			<p class="yu-w120r yu-blue2  cancel-btn2">完成</p>
 		</div>
 		<dl class="yu-bor bbor yu-bmar60r">
 			<dt class="yu-f26r yu-c99 yu-bmar30r">价格筛选</dt>
	 		<dd class="yu-grid yu-j-s price-screen">
	 			<div class="cur">不限</div>
	 			<div>0-150</div>
	 			<div>150-300</div>
	 			<div>300-600</div>
	 			<div>600-1000</div>
	 			<div>1000+</div>
	 			
	 		</dd>
	 	</dl>
	 	<dl class="type-screen">
 			<dt class="yu-f26r yu-c99 yu-bmar30r">类别筛选(复选)</dt>
	 		<dd class="yu-grid yu-j-s type-screen">
	 			<div class="cur">不限</div>
	 			<div>经济/客栈</div>
	 			<div>二星/实惠</div>
	 			<div>三星/舒适</div>
	 			<div>四星/高级</div>
	 			<div>五星/豪华</div>
	 			
	 		</dd>
	 	</dl>
 	</div>-->
 	<div class="mask-inner ">
 		<ul class="yu-f26r sort-list">
 			<li class="yu-grid yu-alignc yu-blue" tdata="-1">
 				<p class="iconfont icon-gouxuan yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">全部类别</p>
 			</li>
            <li class="yu-grid yu-alignc" tdata="0">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">餐饮</p>
 			</li>
            <%
                System.Data.DataTable dt = (System.Data.DataTable)ViewData["dt"];
                foreach (System.Data.DataRow row in dt.Rows)
                {
                 %>
 			<li class="yu-grid yu-alignc" tdata="<%=row["id"] %>">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r"><%=row["typename"] %></p>
 			</li>
            <% } %>
 			<%--<li class="yu-grid yu-alignc" tdata="2">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">电影院</p>
 			</li>
 			<li class="yu-grid yu-alignc" tdata="3">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">KTV</p>
 			</li>
 			<li class="yu-grid yu-alignc" tdata="4">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">网吧</p>
 			</li>
 			<li class="yu-grid yu-alignc" tdata="5">
 				<p class="iconfont yu-w70r yu-textc"></p>
 				<p class="yu-overflow yu-bor bbor yu-h65r yu-l65r">酒吧</p>
 			</li>--%>
 		</ul>
 	</div>
 </div>
 </article>
 <div id="allmap" style="display:none;"></div>
 <!--区域-->
 <%Html.RenderPartial("SelectLocat"); %>

<section class="loading-page" style="position: fixed;" style="display:none">
    <div class="inner">
	    <img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
	    <img src="http://css.weikeniu.com/images/loading-n.png" />
    </div>
</section>
<script type="text/javascript">
    $(function () {
        $(".screen-bottom>div").on("click", function () {
            $(this).toggleClass("cur").siblings().removeClass("cur");
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

        $(".type-screen>div").on("click", function () {
            $(this).toggleClass("cur");
        })
        $(".cancel-btn2").on("click", function () {
            $(".mask").fadeOut();
            $(".screen-bottom>div").removeClass("cur");
        })
        $(".screen-btn").click(function () {
            $(".screen-mask").fadeIn();
        })
        $(".local-btn2").click(function () {
            $(".base-page").hide();
            $(".local-page").show();
        })

        //清空文本框
        $(".J__iptClear").on("click", function () {
            $(this).siblings("input").val("").focus();
        })
    })
 
  function AroundStore(storeId,storetype)
        {
           if(storetype==1){ //餐饮跳到餐饮
             
           }
           window.location.href="/DishOrder/DishOrderIndex/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId="+storeId;
        }
</script>
<script type="text/javascript">
    var lnglat='';
    $(function () {
           // 百度地图API功能
            var map = new BMap.Map("allmap");
            var geolocation = new BMap.Geolocation();
            geolocation.getCurrentPosition(function (r) {
                loadstate(true);
                if (this.getStatus() == BMAP_STATUS_SUCCESS) {
                    var mk = new BMap.Marker(r.point);
                    map.addOverlay(mk);
                    map.panTo(r.point);

                    var geoc = new BMap.Geocoder();
                    geoc.getLocation(r.point, function (rs) {
                        var addComp = rs.addressComponents;
                        //                    alert(addComp.province + ", " + addComp.city + ", " + addComp.district + ", " + addComp.street + ", " + addComp.streetNumber);
                        $(".current-location").html(addComp.province + addComp.city + addComp.district + addComp.street + addComp.streetNumber);
                    });
                    lnglat = r.point.lng + ',' + r.point.lat;
            
                    //加载列表
                    getlist();
                }
                else {
                    alert('failed' + this.getStatus());
                }
            }, { enableHighAccuracy: true });
               
               })
         
           //获取分页
           var page = 1;
           var isEnd = false;
           var type = -1;
           var sort = 0;
           var cityname='';

          $(".sort-list>li").on("click", function () {
            $(this).addClass("yu-blue").siblings().removeClass("yu-blue");
            $(this).children(".iconfont").addClass("icon-gouxuan").parent().siblings().children(".iconfont").removeClass("icon-gouxuan");
            $(".sort-mask,.screen-mask").fadeOut();
            $(".screen-bottom>div").removeClass("cur");
            isEnd=false;
            sort = 0; type = -1;page = 1
            var dd = $('.sort-list').children('.yu-blue');
            $.each(dd, function (i, t) {
                if (typeof ($(this).attr("sdata")) != 'undefined') {
                    sort = $(this).attr("sdata");
                }
                if (typeof ($(this).attr("tdata")) != 'undefined') {
                    type = $(this).attr("tdata");
                }
            });
            //加载列表
            getlist();
        });
        
      

        var url = "/DishOrder/GetAroundStores/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>";
        function getlist() {
            var storename=$('#keyword').val();
            console.log('isEnd='+isEnd+'type='+type+'  sort='+sort +'  page='+page+'lnglat='+lnglat+'cityname='+cityname+'storename='+storename);
            loadstate(true);
            if (!isEnd) {
                    $.ajax({ url: url,
                        async: true,
                        data: { page: page,type:type,sort:sort,pagesize:10,lnglat:lnglat,cityname:cityname,storename:storename},
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
                var jl=arr[i]["juli1"]==null?"0":arr[i]["juli1"];
                var price=arr[i]["Minprice"]*1;
                var youhui=arr[i]["Remo"];
                var src=arr[i]["Logoimg"];
                if(src==''){
                   src='/images/lxs_zbsj_default.png';
                }
                html+='<li class="yu-bgw yu-lpad20r yu-bmar15r"><a href="javascript:AroundStore(\''+arr[i]["StoreId"]+'\',\''+arr[i]["storetype"]+'\')"><div class="yu-grid yu-tbpad20r"><div class="near-pic3 full-img yu-rmar20r"><img src="'+src+'"/></div><div class="yu-overflow"><p class="yu-f26r yu-black">'+arr[i]["StoreName"]+'</p><div class="yu-f20r yu-c77">';
                if(jl>0){html+='<p>距离<span class="yu-c40">'+jl+'</span>km</p>';}
                if(price>0){html+='<p>￥'+price+'起</p>';}
                html+='</div></div></div>';
                if(youhui!=null){
                  html+='<ul class="yu-c40 yu-f24r"><li class="yu-grid yu-alignc yu-h50r yu-bor tbor"><p class="iconfont icon-manjian yu-rmar15r yu-f24r"></p><p>'+youhui+'</p></li></ul>';
                }
                html+='</a></li>';
            });
            $('#list_id').html(html);
        }

        //getlist();
        var windowHeight = $(window).height();

        $(window).scroll(function () {
            var scrollTop = $(this).scrollTop(); //滚动高度
            var windowHeight = $(this).height(); //窗口可视高度

            var scrollHeight = $("body").get(0).scrollHeight; //窗口内容高度
            if (scrollTop + windowHeight == scrollHeight) {
                getlist();
            }
        });

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
        
      $(".search").on('click',function(){
            page = 1;
            isEnd = false;
            type = -1;
            sort = 0;
            keyword=$('#keyword').val();
            getlist();
      });

      //根据位置搜索
    function ChangeLocat(locat, locatName) {
        if(locat==''||locatName=='')
        {
           window.location.reload();
        }else{
            page = 1;
            isEnd = false;
            type = -1;
            sort = 0;
            lnglat=locat;
            cityname=locatName;
        
            getlist();
        }
    }
   
</script>
<script type="text/javascript">
  
</script>
<script type="text/javascript" src="http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js"></script>
<script type="text/javascript">

    $(".local-btn2").click(function () {
        $(".base-page").hide();
        $(".local-page").show();
    })
    var hasDataCityName = "";
    var hasDataCityName2 = "";
    //获取周边商家城市地址
    function GetDataStoreLocat() {
        $.ajax({
            type: "post",
            url: '/DishOrder/GetStoreLocat/<%=ViewData["hotelId"] %>?key=<%=ViewData["key"] %>',
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
    <script>
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
