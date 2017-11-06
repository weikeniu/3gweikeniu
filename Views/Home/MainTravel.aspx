<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%    
    
    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string hotelid = RouteData.Values["id"].ToString();

    string quanjing = ViewData["quanjing"] == null ? "" : ViewData["quanjing"].ToString();

    string userWeiXinID = "";
    userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
    if (weixinID.Equals(""))
    {
        string key = HotelCloud.Common.HCRequest.GetString("key");
        string[] a = key.Split('@');
        weixinID = a[0];
        userWeiXinID = a[1];
    }

    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotelid);
    viewDic.Add("uwx", userWeiXinID);

    bool IsBranch = (bool)ViewData["IsBranch"];


    if (!WeiXin.Common.NormalCommon.IsLXSDoMain()  &&  !Request.Url.ToString().Contains("localhost"))
    {
        Response.Redirect(string.Format("/home/Default/{0}?key={1}@{2}&msg={3}", hotelid, weixinID, userWeiXinID, "您的权限不足!请联系微可牛相关人员"));
    }

    System.Data.DataTable dt_Type = ViewData["CommodityTypeTable"] as System.Data.DataTable;

    System.Data.DataTable dt_commodityDataTable = ViewData["commodityDataTable"] as System.Data.DataTable;


    //if (ViewData["traveledition"].ToString() != "1")
    //{
    //    Response.Redirect(string.Format("/home/Default/{0}?key={1}@{2}&msg={3}", hotelid, weixinID, userWeiXinID, "您的权限不足!请联系微可牛相关人员"));
    //}
  


   // var producdtList = ViewData["products"] as List<WeiXin.Common.ProductEntity>;


    IList<hotel3g.Models.Advertisement> adlist = ViewData["ad"] as List<hotel3g.Models.Advertisement>;

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
    <title><%=ViewData["weixinname"]%></title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["jsUrl"] %>/swiper/swiper-3.4.1.min.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/travel.css" />
    <link type="text/css" rel="stylesheet" href="../../css/booklist/font/iconfont.css" />
    <!--<link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css"/>-->
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/swiper/swiper-3.4.1.jquery.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
</head>
<body>
    <article class="base-page">


    <section class="yu-pos-r"   >
		 <div class="yu-grid search-row" style="display:none">
		 	<a class="yu-lpad10r yu-w100r down-arr a_btncity" href="#">
		 		<p class="yu-cw yu-f28r yu-l50r nav-btn1">广州</p>
		 	</a>
		 	<div class="search-bg yu-grid yu-alignc yu-lpad20r">
		 		<p class="iconfont icon-soushuo1 yu-cw yu-f30r yu-rmar20r"></p>
		 		<input type="text" />
		 	</div>
		 </div>
		 <div class="swiper-container yu-h360r">
		    <div class="swiper-wrapper">
 

                <% if (adlist != null && adlist.Count > 0)
                   {
                       foreach (hotel3g.Models.Advertisement ad in adlist)
                       {
                           string href = "javascript:void(0)";

                           if (!string.IsNullOrEmpty(ad.ImageUrl))
                           {
                               if (!string.IsNullOrEmpty(ad.LinkUrl))
                               {
                                   if (ad.LinkUrl.Contains("/Hotel/Fillorder"))
                                       href = ad.LinkUrl + "&userweixinid=" + ViewData["userWeiXinID"];
                                                                              
                                   else if (ad.LinkUrl.ToLower().Contains("http://"))
                                       href = ad.LinkUrl;
                                       
                                   else
                                       href = ad.LinkUrl.Trim() + "@" + ViewData["userWeiXinID"];


                                   href = href.Replace("@{{userweixinID}}", "");
                               }
                                 
                    %>
                    <div class="swiper-slide full-img"">
                        <a href="<%=href %>">
                            <img src="<%=ad.ImageUrl %>" />
                        </a>   
                    </div>
                     

                    <%}
                       }
                   } %>


				</div>
		    <div class="swiper-pagination"></div>
	  	</div>
  	</section>
    <section class="yu-bmar5r">
		<ul class="nav-list yu-bor bbor">
			<li>
				<a href="/TravelAgencyHotel/Index/<%= hotelid%>?key=<%=weixinID %>@<%=userWeiXinID %>">
					<div class="nav-bg type1 iconfont icon-jiudian1"></div>
					<p class="yu-f28r yu-black yu-textc">酒店</p>
				</a>
			</li>


            	<li>
				<a href="/Product/Productlist/<%=hotelid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
					<div class="nav-bg type2 iconfont icon-qianggou4"></div>
					<p class="yu-f28r yu-black yu-textc">抢购</p>
				</a>
			</li>
            <% System.Data.DataRow curRow = dt_Type.Select("name='门票'").FirstOrDefault(); %>

            <%if (curRow != null)
              {  %>
			<li>   
				<a href="/TravelAgency/ShoppingMallByType/<%=hotelid  %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>&type=<%=curRow["id"] %>">
					<div class="nav-bg type3 iconfont icon-menpiao1"></div>
					<p class="yu-f28r yu-black yu-textc">门票</p>
				</a>
			</li>
            <%} %>

                <%  curRow = dt_Type.Select("name='线路'").FirstOrDefault(); %>

                  <%if (curRow != null)
                    {  %>
			<li>
					<a href="/TravelAgency/ShoppingMallByType/<%=hotelid%>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>&type=<%=curRow["id"] %>">
					<div class="nav-bg type4 iconfont icon-xianlu1"></div>
					<p class="yu-f28r yu-black yu-textc">线路</p>
				</a>
			</li>

            <%} %>


			<li>
			<a href="/Hotel/NewsinfoList/<%= hotelid%>?key=<%=weixinID %>@<%=userWeiXinID %>&type=1">
					<div class="nav-bg type5 iconfont icon-gonglue1"></div>
					<p class="yu-f28r yu-black yu-textc">攻略</p>
				</a>
			</li>
	

                <%  curRow = dt_Type.Select("name='租车'").FirstOrDefault(); %>

                  <%if (curRow != null)
                    {  %>

			<li>
			<a href="/TravelAgency/ShoppingMallByType/<%=hotelid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>&type=<%=curRow["id"] %>">
					<div class="nav-bg type8 iconfont icon-zuche1"></div>
					<p class="yu-f28r yu-black yu-textc">租车</p>
				</a>
			</li>

            <%} %>

                 <%  curRow = dt_Type.Select("name='签证'").FirstOrDefault(); %>
                  <%if (curRow != null)
                    {  %>
			<li>
				<a href="/TravelAgency/ShoppingMallByType/<%=hotelid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>&type=<%=curRow["id"] %>">
					<div class="nav-bg type9 iconfont icon-qianzheng1"></div>
					<p class="yu-f28r yu-black yu-textc">签证</p>
				</a>
			</li>

            <%} %>


	 			<li>
				<a href="/TravelAgency/ShoppingMall/<%= hotelid%>?key=<%=weixinID %>@<%=userWeiXinID %>">
					<div class="nav-bg type2 iconfont icon-shangcheng1"></div>
					<p class="yu-f28r yu-black yu-textc">商城</p>
				</a>
			</li>
		
            <li>
				<a href="/dishorder/aroundstores/<%=hotelid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
					<div class="nav-bg type6 iconfont icon-zhoubian"></div>
					<p class="yu-f28r yu-black yu-textc">商家列表</p>
				</a>
			</li>
            <% 
                var ModuleAuthority = hotel3g.Models.DAL.AuthorityHelper.ModuleAuthority(weixinID);
                if (ModuleAuthority.module_pintuan == 1)
                {
                 %>

            <li><a href="/TravelTheme/ThemeIndex/<%=hotelid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
					<div class="nav-bg type7 iconfont icon-pintuan1"></div>
					<p class="yu-f28r yu-black yu-textc">拼团</p>
				</a>
			</li>
            <%} %>
            <li  style="display:none">
				<a href="/home/CouPon/<%=hotelid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
					<div class="nav-bg type3 iconfont icon-hongbao3"></div>
				    	<p class="yu-f28r yu-black yu-textc">红包</p>
				</a>
			</li>


            		<li style="display:none">
				<a href="#">
					<div class="nav-bg type6 iconfont icon-fuwu1"></div>
					<p class="yu-f28r yu-black yu-textc">服务</p>
				</a>
			</li>
		<li>
				
			<a href="/user/Index/<%=hotelid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>">
					<div class="nav-bg type1 iconfont icon-huiyuan1"></div>
					<p class="yu-f28r yu-black yu-textc">会员</p>
				</a>
			</li>
            
			<li style="display:none">
				<a href="#">
					<div class="nav-bg type10 iconfont icon-zhiding1"></div>
					<p class="yu-f28r yu-black yu-textc">自定</p>
				</a>
			</li>

		</ul>
	</section>
    <section class="yu-lrpad20r">
		<div class="yu-h60r yu-grid yu-alignc yu-blue2 yu-l60r">
			<p class="iconfont icon-rexiao yu-f22r yu-rmar10r yu-tpad5r"></p>
			<p class="yu-f24r">热销</p>
		</div>
		<ul class="hot-list">

             <%  for (int i = 0; i < dt_commodityDataTable.Rows.Count; i++)
                 {
                     if (i < 3)
                     {    %>

                 		<li>
				<a href="/TravelAgency/CommodityDetail/<%=hotelid %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>&CommodityID=<%=dt_commodityDataTable.Rows[i]["Id"].ToString()  %>">
					<div class="img"><img src="<%=dt_commodityDataTable.Rows[i]["ImageList"].ToString().Split(',')[0]%>" /></div>
					<div class="yu-f24r yu-l30r yu-black yu-bmar5r  text-ell"><%=dt_commodityDataTable.Rows[i]["name"].ToString()%></div>
					<div class="yu-ov-h yu-bmar10r">
						<div class="mark"><%=dt_commodityDataTable.Rows[i]["CommodityTypeName"].ToString() == string.Empty ? "商城" : dt_commodityDataTable.Rows[i]["CommodityTypeName"].ToString()%> </div>
					</div>
					<div class="yu-c40 yu-f20r">￥<span class="yu-f26r"><%=dt_commodityDataTable.Rows[i]["price"].ToString()%></span></div>
				</a>
			</li>
                     
                <%  }
                 } %>
		</ul>
	</section>
    </article>
    <%Html.RenderPartial("SelectLocat"); %>
    <script src="http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js"></script>
    <script type="text/javascript">

        var swiper = new Swiper('.swiper-container', {
            pagination: '.swiper-pagination',
            paginationClickable: true,
            autoplay: 2500,
            autoplayDisableOnInteraction: false,
            loop: true,
            onSlideChangeStart: function (swiper) {
                $(".hotel-img-mask li").eq(swiper.activeIndex).addClass("cur").siblings().removeClass("cur");
                $(".activeIndex").text(swiper.activeIndex);
            }
        });



        var city = remote_ip_info['city'];
        $(".sp").find(".sp_lab").html(city);
        $(".nav-btn1").html(city);

        $(".a_btncity").click(function () {
            $(".base-page").hide();
            $(".local-page").show();

        });

        function ChangeLocat(locat) {

        }

    </script>
</body>
</html>
