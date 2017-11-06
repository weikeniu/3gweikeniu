<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%   
    hotel3g.Models.Hotel hotel = ViewData["hotel"] as hotel3g.Models.Hotel;

    IList<WeiXin.Models.Img> mlist = ViewData["image"] as IList<WeiXin.Models.Img>;

    string skipPic = "../../images/hotelDefaultPic.png";

    if (mlist != null && mlist.Count > 0)
    {
        skipPic = !string.IsNullOrEmpty(mlist[0].BigUrl) ? mlist[0].BigUrl : mlist[0].Url;
    }

    string weixinID = string.Empty;
    if (hotel != null && !string.IsNullOrEmpty(hotel.WeiXinID))
    {
        weixinID = hotel.WeiXinID;
    }
    else
    {
        weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
        if (weixinID.Equals(""))
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            weixinID = key.Split('@')[0];
        }
    }
    string userweixinid = ViewData["userWeiXinID"] as string;

    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotel.ID);
    viewDic.Add("uwx", userweixinid);


    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"
        name="viewport">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <!-- Mobile Devices Support @begin -->
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
    <meta content="no-cache,must-revalidate" http-equiv="Cache-Control">
    <meta content="no-cache" http-equiv="pragma">
    <meta content="0" http-equiv="expires">
    <meta content="telephone=no, address=no" name="format-detection">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!-- apple devices fullscreen -->
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>
        <%=hotel.SubName %>简介</title>
    <link type="text/css" rel="stylesheet" href="<%= ViewData["cssUrl"]%>/swiper/swiper-3.4.1.min.css" />
    <link type="text/css" rel="stylesheet" href="<%= ViewData["cssUrl"]%>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%= ViewData["cssUrl"]%>/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="<%= ViewData["cssUrl"]%>/css/booklist/new-style.css" />
    <script type="text/javascript" src="<%= ViewData["jsUrl"]%>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%= ViewData["jsUrl"]%>/swiper/swiper-3.4.1.jquery.min.js"></script>
    <link type="text/css" rel="stylesheet" href="<%= ViewData["cssUrl"]%>/css/booklist/fontSize.css" />
    <script type="text/javascript" src="<%= ViewData["jsUrl"]%>/Scripts/fontSize.js"></script>
    <link rel="stylesheet" type="text/css" href="<%= ViewData["cssUrl"]%>/css/photoswipe.css"
        media="all" />
    <link rel="stylesheet" type="text/css" href="<%= ViewData["cssUrl"]%>/css/css.css"
        media="all" />
    <script type="text/javascript" src="http://js.weikeniu.com//Scripts/jquery_wookmark_min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/klass_min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/code_photoswipe_min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery_lazyload.js"></script>
    <style>
        .hotel-img-box
        {
            height: 170px;
            padding-top: 0;
        }
    </style>
</head>
<body>
    <script type="text/javascript">
        (function (window) {
            document.addEventListener('DOMContentLoaded', function () {
                var PhotoSwipe = window.Code.PhotoSwipe;
                var options = { loop: false },
				instance = PhotoSwipe.attach(window.document.querySelectorAll('.uulist li a'), options);
            }, false);
        })(window);
    </script>
    <article class="full-page">
     <% Html.RenderPartial("HeaderA", viewDic); %>

 <section class="show-body">
			
			<section class="content2 yu-bpad120r">
				<div class="tab-con">
					<ul class="tab-nav type0 yu-grid yu-bor bbor yu-f30r"  >
						<li class="yu-overflow cur">酒店介绍</li>
						<li class="yu-overflow">酒店相片</li>
					</ul>
					<ul class="tab-inner">
						<li class="cur">
							<div class="hotel-img-box swiper-container">
							    <div class="swiper-wrapper">

                                  <%
              
                                      if (mlist != null)
                                      {
                                          foreach (WeiXin.Models.Img g in mlist)
                                          { %>
          <div class="swiper-slide">  <img  src="<%=!string.IsNullOrEmpty(g.BigUrl) ?  g.BigUrl :g.Url %>" /></div>

           
                                <%}
                                      }
                                     %>

							      	 
									</div>
							    <div class="swiper-pagination"></div>
							  </div>
							<div class="yu-bgw">
							  	 <div class="yu-pad10 yu-font14 yu-line24"   style="text-indent:2em" >
									 <%=hotel.Content.Replace("\n","<br />") %>
								</div>
							 
							</div>	
							<div class="fix-bottom yu-h50">
								<a href="tel:<%=hotel.Tel %>" class="yu-grid yu-alignc yu-h50 yu-j-c">
									<p class="phone-ico2"></p>
									<p class="yu-c66 yu-f30r">联系电话</p>
								</a>
								
							</div>
						</li>
						<li>
                        <!--酒店图片-->
                  
    <div class="dz">
    </div>
    <div class="all" style="margin-top: 20px; padding-top: 0px; background: #fff;">
        <div class="tianxixxx">
            <%
                IDictionary<string, IList<hotel3g.Common.HotelImage>> dic = ViewData["HotelPictures"] as IDictionary<string, IList<hotel3g.Common.HotelImage>>;
                if (dic != null)
                {
                    int i = 0;
                    foreach (string t in dic.Keys)
                    {
                        IList<hotel3g.Common.HotelImage> list = dic[t];
                        if (list != null && list.Count > 0)
                        {%>
            <h1 class="htitle">
                <%--(i==0?"style='border-radius: 10px 10px 0px 0px;'":"")--%>
                <strong>
                    <%=t %></strong></h1>
            <ul class="uulist">
                <%foreach (hotel3g.Common.HotelImage m in list)
                  {
                      string currImg = !string.IsNullOrEmpty(m.BigUrl) ? m.BigUrl : m.Image;   %>
                <li><a href="<%=currImg %>">
                    <img class="imgload" data-src="<%=currImg %>" /></a></li>
                <% }%>
            </ul>
            <% i++;
                        }
                    }
                } 
            %>
        </div>
    </div>
 
                        </li>
					</ul>
				</div>
			</section>
		</section>

     </article>
    <script>
        var swiper = new Swiper('.swiper-container', {
            pagination: '.swiper-pagination',
            paginationClickable: true,
            // autoplay: 2500,
            autoplayDisableOnInteraction: false,
            loop: true
        });

        $(function () {
            //左导航
            var lSideNum = 0;
            $(".l-side-btn").click(function () {
                if (lSideNum == 0) {
                    $(".full-page").addClass("shin-slide-right").removeClass("shin-slide-left");
                    $(".l-side").fadeIn();
                    lSideNum = 1;
                } else {
                    $(".full-page").removeClass("shin-slide-right").addClass("shin-slide-left");
                    $(".l-side").fadeOut();
                    lSideNum = 0;
                }
            })
            //选项卡
            var tabIndex;
            $(".tab-nav").children("li").on("click", function () {
                $(this).addClass("cur").siblings("li").removeClass("cur");
                tabIndex = $(this).index();
                $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
            })



            $(".imgload").each(function () {
                var url = $(this).attr("data-src");
                $(this).attr("src", url);
                $(this).removeAttr("data-src");
            });


            var s = '<%=Request.QueryString["s"] %>';
            if (s == 1) {
                $($(".tab-nav").children("li")[1]).trigger("click");
            }


        })
    </script>
</body>
</html>
