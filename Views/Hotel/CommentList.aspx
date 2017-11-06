<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<hotel3g.Models.Home.Comment>>" %>
<%   
    var models = ViewData["models"] as List<hotel3g.Models.Home.Comment>;
%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta name="format-detection" content="telephone=no">
<!--自动将网页中的电话号码显示为拨号的超链接-->
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
<!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
<meta name="apple-mobile-web-app-capable" content="yes">
<!--IOS设备-->
<meta name="apple-touch-fullscreen" content="yes">
<!--IOS设备-->
<meta http-equiv="Access-Control-Allow-Origin" content="*">
<title>酒店评论</title>
    <link type="text/css" rel="stylesheet" href="../../css/booklist/sale-date.css"/>
    <link type="text/css" rel="stylesheet" href="../../css/booklist/fontSize.css"/>
    <link href="../../Scripts/PhotoSwipe/photoswipe.css" rel="stylesheet" type="text/css" />
    <link href="../../Scripts/PhotoSwipe/default-skin/default-skin.css" rel="stylesheet"
        type="text/css" />
<style>
		.circle {
			width: 1.19rem;
			height: 1.19rem;
			position: relative;
			border-radius: 50%;
			background: #12b7f5;
			margin: 0 auto;
		}
		.pie_left, .pie_right {
			width:1.19rem; 
			height:1.19rem;
			position: absolute;
			top: 0;left: 0;
		}
		.left, .right {
			width:1.19rem; 
			height:1.19rem;
			background:#ccc;
			border-radius: 50%;
			position: absolute;
			top: 0;
			left: 0;
		}
		.pie_right, .right {
			clip:rect(0,auto,auto,.595rem);
		}
		.pie_left, .left {
			clip:rect(0,.595rem,auto,0);
		}
		.mask {
			width: 1.03rem;
			height: 1.03rem;
			border-radius: 50%;
			left: .08rem;
			top: .08rem;
			background: #FFF;
			position: absolute;
			text-align: center;
			line-height: 1.03rem;
			font-size: .3rem;
			color: #666;
			display: block;
		}
</style>
</head>
<body>
<section class="loading-page" style="position: fixed;">
	<div class="inner">
		<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
		<img src="http://css.weikeniu.com/images/loading-n.png" />
	</div>
</section>
<input type="hidden" value='<%=ViewData["hotelID"] %>' id="hHID"/>
<input type="hidden" value='<%=ViewData["page"] %>' id="hPage"/>
<input type="hidden" value='<%=ViewData["qFlag"] %>' id="hQFlag"/>
<section class="yu-bgw">
	<div class="yu-pad20r yu-bor bbor yu-grid">
		<div class="yu-w230r">
			<div class="circle">
				<div class="pie_left"><div class="left"></div></div>
				<div class="pie_right"><div class="right"></div></div>
				<div class="mask"><span><%=ViewData["allAvg"]%></span>分</div>
			</div>
			</div>
		<div class="yu-f30r yu-overflow yu-c66 yu-l60r">
		<ul>
			<li class="fl yu-rmar75r">
				卫生：<span class="yu-blue2"><%=ViewData["hssAvg"]%>分</span>
			</li>
			<li class="fl yu-rmar75r">
				设施：<span class="yu-blue2"><%=ViewData["fssAvg"]%>分</span>
			</li>
			<li class="fl yu-rmar75r">
				网络：<span class="yu-blue2"><%=ViewData["nssAvg"]%>分</span>
			</li>
			<li class="fl yu-rmar75r">
				服务：<span class="yu-blue2"><%=ViewData["assAvg"]%>分</span>
			</li>
		</ul>
	</div>
	</div>
	<div class="yu-h100r yu-grid yu-alignc yu-lrpad20r yu-f24r screen">
		<a href="javascript:void(0)" class="yu-blue2 J_qAll">全部（<%=ViewData["allcount"]%>）</a>
		<a href="javascript:void(0)" class="yu-blue2 J_qPic">有图评价（<%=ViewData["hasPicCount"]%>）</a>
	</div>
</section>
<section>
	<ul class="pl-list">
    <%foreach (var m in models)
      {%>
          	<li data-id='<%=m.ID %>' class="yu-lrpad20r yu-bor bbor">
			<div class="yu-grid">
                  <div class="full-img"><img src="<%=m.UserWxAvatar %>" onerror="javascript:this.src='http://wx.qlogo.cn/mmopen/Ty7XRc3ndPPuK3qhZfdYG3TAHACzQEtRKUXicRACQbS102lhTEIPWe6ruicKp4HFtgkvJBY758O8cWQG8K3GVPWH7ic5ZWek6tw/0';" /></div>
                  <div class="ca-flex-two">
                        <div class="fl">
                            <p class="yu-f32r"><%=m.UserWxNickName%></p>
                            <p class="yu-c99 yu-f24r"><%=m.CommentTimeText%></p>
                        </div>
                        <div class="fr ca-new-comment">
                            <p class="yu-f36r yu-blue2"><%=m.AvgScore %>分</p>
                            <p class="yu-c99 yu-f24r"><%=m.RoomType %></p>
                        </div>
                  </div>
                  <!--ca-flex-two end-->
            </div>
            <!--yu-grid end-->
            <p class="yu-f30r yu-c66 ca-martr30"><%=m.Content %></p>
            <%if (m.ImgArr.Count() > 0) 
              {%>
                <div class="ca-coment-imgs">
                  <ul>
                    <%foreach (var i in m.ImgArr)
                      {%>
                        <li><img src='<%=i %>'></li>
                      <%} %>
                  </ul>
                </div>
              <%} %>
            <!--ca-coment-imgs end-->
            <div class="htl_rever-sion" style="display:<%= m.IsReply == 1 ? "block" : "none"%>;">
                  <div class="rev_back"><label>酒店回复：</label><span class="fr yu-blue" data-id='<%=m.ID %>'>展开</span></div>
                  <p class="J_backContent" style="display: none;"></p>
            </div>
		 </li>
      <%} %>
	</ul>
    <p style="text-align:center;color:#aaa;padding:10px 0px 10px 0px;display:none;" id="nomore">没有更多了...</p>
</section>
<!-- PhotoSwipe start -->
<div class="pswp" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="pswp__bg"></div>
    <div class="pswp__scroll-wrap">
        <div class="pswp__container">
            <div class="pswp__item"></div>
            <div class="pswp__item"></div>
            <div class="pswp__item"></div>
        </div>
        <div class="pswp__ui pswp__ui--hidden">

            <div class="pswp__top-bar">
                <div class="pswp__counter"></div>
                <button class="pswp__button pswp__button--close" style="background-image: url(../../Scripts/PhotoSwipe/default-skin/default-skin.png)" title="Close (Esc)"></button>
                <div class="pswp__preloader">
                    <div class="pswp__preloader__icn">
                      <div class="pswp__preloader__cut">
                        <div class="pswp__preloader__donut"></div>
                      </div>
                    </div>
                </div>
            </div>
            <div class="pswp__share-modal pswp__share-modal--hidden pswp__single-tap">
                <div class="pswp__share-tooltip"></div> 
            </div>
            <button class="pswp__button pswp__button--arrow--left" title="Previous (arrow left)">
            </button>
            <button class="pswp__button pswp__button--arrow--right" title="Next (arrow right)">
            </button>
            <div class="pswp__caption">
                <div class="pswp__caption__center"></div>
            </div>
          </div>
        </div>

</div>
<!-- PhotoSwipe end -->
<script type="text/javascript" src="../../Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="../../Scripts/fontSize.js"></script>
<script src="../../Scripts/PhotoSwipe/photoswipe.min.js" type="text/javascript"></script>
<script src="../../Scripts/PhotoSwipe/photoswipe-ui-default.min.js" type="text/javascript"></script>
<script type="text/javascript">
    var gallery = new Object(); //全局画册变量
    $(function () {
        //展开回复
        $(".pl-list").on('click', '.rev_back span', function () {
            var that = $(this);
            var cId = that.data('id');
            var rDom = that.parent().next('.J_backContent')
            rDom.slideToggle();
            var OTEXT = $(this).text()
            if (OTEXT == "展开") {
                $.get('/Hotel/GetReplyMsg', { cId: cId }, function (data) {
                    rDom.html(data.replyMsg);
                })
                $(this).text("收起")
            } else {
                $(this).text("展开")
            }
        });
        scoreCircle();
        query();
        scrollLoad();
        provImg();
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
    $(".loading-page").hide();
    //分数环形
    function scoreCircle() {
        $('.circle').each(function (index, el) {
            var num = $(this).find('span').text() * 3.6 * 20;
            if (num <= 180) {
                $(this).find('.right').css('transform', "rotate(" + num + "deg)");
            } else {
                $(this).find('.right').css('transform', "rotate(180deg)");
                $(this).find('.left').css('transform', "rotate(" + (num - 180) + "deg)");
            };
        })
    }
    //点击查询
    function query() {
        var hid = $('#hHID').val();
        $('.J_qAll').on('click', function () {
            isEnd = false;$('#hPage').val(1); $('#hQFlag').val(0);
            getComments({ hotelID: hid, page: 1, qFlag: 0 }, false);
        });
        $('.J_qPic').on('click', function () {
            isEnd = false; $('#hPage').val(1);$('#hQFlag').val(1);
            getComments({ hotelID: hid, page: 1, qFlag: 1 }, false);
        });
    }
    //预览图片
    function provImg() {
        $('body').on('click', '.ca-coment-imgs img', function () {
            var items = [];
            var allImgLis = $(this).parents('ul:first').find('li');
            $.each(allImgLis, function (i, it) {
                items.push({ src: $(this).find('img').attr('src'), w: 600, h: 400 })
            })
            if (items.length > 0) {
                //初始化PhotoSwipe
                var pswpElement = document.querySelectorAll('.pswp')[0];
                var options = {
                    index: $(this).parent('li').prevAll().length, //显示第几张       
                    showAnimationDuration: 0, //显示动画时间
                    hideAnimationDuration: 0, //隐藏动画时间
                    bgOpacity: 0.7, //透明度
                    closeOnScroll: true, //禁止页面滚动
                    captionAndToolbarFlipPosition: true
                };
                gallery = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, items, options);
                gallery.init();
            }
        })
    }
    //获取评价信息
    var isEnd = false;
    function getComments(params, isScroll) {
        var defImg = "javascript:this.src='http://wx.qlogo.cn/mmopen/Ty7XRc3ndPPuK3qhZfdYG3TAHACzQEtRKUXicRACQbS102lhTEIPWe6ruicKp4HFtgkvJBY758O8cWQG8K3GVPWH7ic5ZWek6tw/0';";
        if (!isEnd) {
            loadstate(true);
            $("#nomore").hide();
            $.get('/Hotel/GetComments', params, function (data) {
                var html = ''; isEnd = data.length <= 0;
                if (!isEnd) {
                    $.each(data, function (i, item) {
                        html += '<li data-id='+item.ID+' class="yu-lrpad20r yu-bor bbor"><div class="yu-grid"><div class="full-img"><img src="' + item.UserWxAvatar + '"  onerror="' + defImg + '" /></div><div class="ca-flex-two"><div class="fl"><p class="yu-f32r">' + item.UserWxNickName + '</p><p class="yu-c99 yu-f24r">' + item.CommentTimeText + '</p></div><div class="fr ca-new-comment"><p class="yu-f36r yu-blue2">' + item.AvgScore.toFixed(1) + '分</p><p class="yu-c99 yu-f24r">' + item.RoomType + '</p></div></div></div><p class="yu-f30r yu-c66 ca-martr30">' + item.Content + '</p>';
                        if (item.ImgArr.length > 0) {
                            html += '<div class="ca-coment-imgs"><ul>';
                            $.each(item.ImgArr, function (i, it) {
                                html += '<li><img src=' + it + '></li>';
                            });
                            html += '</ul></div>';
                        }
                        var showReplyCss = item.IsReply == 1 ? 'block' : 'none'; //1已回复
                        html += '<div class="htl_rever-sion" style="display:' + showReplyCss + ';"><div class="rev_back"><label>酒店回复：</label><span class="fr yu-blue" data-id=' + item.ID + '>展开</span></div> <p class="J_backContent" style="display: none;"></p> </div>';
                        html += '</li>';
                    });
                } else {
                    $("#nomore").show();
                    //$(window).off('scroll');
                }
                if (!isScroll) {
                    $('.pl-list').html(html);
                } else if (isScroll && html != '') {
                    $('.pl-list').append(html);
                }
                scrollLoad();
                loadstate(false);
            })
        }
    }
    //滑动加载数据
    function scrollLoad() {
//        var hid = $('#hHID').val();
//        var hPage = $('#hPage').val() * 1 + 1; 
//        var qFlag = $('#hQFlag').val()
//        var windowHeight = $(window).height();
//        $(window).scroll(function () {
//            scrollTop = $(this).scrollTop();
//            scrollHeight = $(document).height();
//            windowHeight = $(this).height();
//            if (scrollTop + windowHeight == scrollHeight) {
//                getComments({ hotelID: hid, page: hPage, qFlag: qFlag }, true);
//                $('#hPage').val(hPage);
//            }
//        });
//        if (windowHeight >= 596) {
//            getComments({ hotelID: hid, page: hPage, qFlag: qFlag }, true);
//            $('#hPage').val(hPage);
//        }
        $(window).scroll(function () {
            var hid = $('#hHID').val();
            var hPage = $('#hPage').val() * 1 + 1; 
            var qFlag = $('#hQFlag').val()
            if ($(document).scrollTop() >= $(document).height() - $(window).height()) {
                getComments({ hotelID: hid, page: hPage, qFlag: qFlag }, true);
                $('#hPage').val(hPage);
            }
        })
    }
</script>
</body>
</html>

