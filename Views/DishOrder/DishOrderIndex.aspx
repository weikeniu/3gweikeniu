<!DOCTYPE HTML>
<%
    int tid = HotelCloud.Common.HCRequest.getInt("tid");//aush   桌台号id
    ViewData["tid"] = tid;
%>

<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
    hotel3g.Models.StoresView store = (hotel3g.Models.StoresView)ViewData["store"];//选中的商家
    System.Data.DataTable dtImg = (System.Data.DataTable)ViewData["dt_storeImg"];//选中的商家图片
    List<hotel3g.Models.StoresView> list = (List<hotel3g.Models.StoresView>)ViewData["list_store"];//商家列表
    list = list.OrderByDescending(a => a.Isaround).ToList();
    hotel3g.Models.StoresView defmodel = (hotel3g.Models.StoresView)ViewData["defmodel"];//自营排在第一位
    List<hotel3g.Models.StoresView> diningrooms = list.FindAll(a => a.IsDiningRoom == 1);//开启餐厅订位
    if (defmodel != null)
    {
        if (defmodel.IsDiningRoom == 1)
        {
            diningrooms.Insert(0, defmodel);
        }
    }

    var lcount = list.Count;//餐厅数量
    var storeid = HotelCloud.Common.HCRequest.GetInt("storeId", 0);//选中餐厅id
    var dingweicount = diningrooms.Count;//开启订位餐厅数
    var hasdef = defmodel == null ? 0 : 1;// 1有默认
    // 多个餐厅：默认显示餐厅列表，隐藏餐饮预定tab
    //只有一家餐厅直接显示餐厅预订   
    // 开启定位显示定位头
    //选中餐厅，显示餐厅预订
    string cur1 = "cur", cur2 = "", cur3 = "";           //控制头部tab 选中样式
    string tcur1 = "", tcur2 = "", tcur3 = "";           //控制头部tab状态 ,显示=“” 隐藏=isHide
    string isHide1 = "cur", isHide2 = "", isHide3 = "";  //控制内容状态  显示=cur，隐藏=“”
    string title = "";
    if (lcount > 0 && storeid < 1)
    {
        cur3 = "cur"; cur1 = cur2 = "";
        tcur1 = "isHide";
        isHide3 = "cur"; isHide1 = isHide2 = "";
    }
    //有选中餐厅,无开启定位
    if (storeid > 0 && dingweicount == 0)
    {
        title = "isHide";
    }
    if (storeid == 0 && dingweicount == 0 && lcount == 0)
    {
        title = "isHide";
    }
    if (storeid == 0)
    {
        tcur1 = "isHide";
    }
    else
    {
        tcur3 = "isHide";
    }
    if (dingweicount == 0)
    {
        tcur2 = "isHide";
    }
    if (storeid == 0 && dingweicount > 0 && lcount == 0)
    {
        tcur1 = "";
        tcur3 = "isHide";
        title = "";
    }
    if (hasdef == 0)
    {
        if (lcount == 1)
        {
            if (dingweicount > 0)
            {
                tcur1 = tcur2 = "";
                tcur3 = "isHide";
                isHide2 = isHide3 = "";
                cur2 = cur3 = "";
            }
            else
            {
                tcur1 = "isHide";
                title = "isHide";
                isHide3 = "";
            }
            cur1 = "cur";
            isHide1 = "cur";
            tcur1 = "";
        }
    }
    else
    {
        if (lcount > 0 && storeid == 0)
        {
            tcur1 = "isHide";
            cur3 = "cur";
            tcur3 = "";
            tcur1 = "isHide";
            title = "";
            if (dingweicount > 0)
            {
                tcur2 = "";
            }
        }
    }

    //如果是周边商家，隐藏tab 头
    bool iszbsj = false;
    if (store != null)
    {
        if (store.storetype != 0)
        {
            title = "isHide";
            iszbsj = true;
        }
    }


    if (tid > 0) //扫描过来，隐藏头
    {
        title = "isHide";
    }
%>
<html>
<head runat="server">
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
    <title>
        <% =ViewData["hotelName"]%></title>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/swiper/swiper-3.4.1.min.css?v=1.0" />
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/sale-date.css?v=1.0" />
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/Restaurant.css?v=1.1" />
    <link href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/fontSize.css?v=1.1"
        rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/jquery-1.8.0.min.js?v=1.0"></script>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/swiper/swiper-3.4.1.jquery.min.js?v=1.0"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/drag.js"
        type="text/javascript"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/js.js"
        type="text/javascript"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/fontSize.js"
        type="text/javascript"></script>
    <style type="text/css">
        .isHide
        {
            display: none;
        }
        .big-food-box{background:#fff;}
    </style>
</head>
<body>
    <div class="tab-con">
        <ul class="tab-nav type0 yu-grid yu-bor bbor bl <%=title %>" id="ul_titleid">
            <li class="yu-overflow <%=tcur1 %> <%=cur1 %>" id="li_1">酒店餐饮</li>
            <li class="yu-overflow <%=tcur3 %> <%=cur3 %>" id="li_3">
                <%=HotelCloud.Common.HCRequest.GetString("key").Split('@')[0].ToLower() == "gh_43a7f36f94eb" ? "酒店餐厅" : "餐厅列表"%></li>
            <li class="yu-overflow <%=tcur2 %> <%=cur2 %>" id="li_2">餐厅订位</li>
        </ul>
        <ul class="tab-inner">
            <li id="near-list1" class="<%=isHide1 %>">
                <div class="base-page">
                    <div id="main">
                        <div class="hotel-img-box swiper-container">
                            <p class="hotel-name">
                                <%= store == null ? "" : store.StoreName%></p>
                            <p class="hotel-img-num">
                                <span class="activeIndex"></span>/<span class="activeTotalCount"><%=dtImg.Rows.Count %></span></p>
                            <div class="swiper-wrapper">
                                <%  
                                    foreach (System.Data.DataRow row in dtImg.Rows)
                                    {
                                %>
                                <div class="swiper-slide">
                                    <img src="<%=row["imgUrl"] %>" /></div>
                                <%
                                    }
                                %>
                            </div>
                            <!--<div class="swiper-pagination"></div>-->
                            <% 
                                //gh_ba192989d6cb 珠海万悦酒店
                                var kkey = HotelCloud.Common.HCRequest.GetString("key");
                                if (kkey.Split('@')[0].ToLower() != "gh_ba192989d6cb".ToLower())
                                {
                            %>
                            <div class="hotel-img-mask">
                                <ul>
                                    <li class="cur">
                                        <%=ViewData["hotelName"]%></li>
                                </ul>
                            </div>
                            <%
}
                            %>
                        </div>
                    </div>
                    <section class="main">
	                     <div class="tab-con">
		                    <ul class="tab-nav yu-grid type1 yu-bor bbor">
			                    <li class="yu-overflow cur"><p><%=iszbsj ? "商品" : "点菜"%><p/></li>
			                    <li class="yu-overflow"><p>图片<p/></li>
		                    </ul>
		                    <ul class="tab-inner">
			                    <li class="cur">
				                     <div class="yu-grid tab-con">
                                        <!-- 菜品类型-->
				                        <ul class="tab-nav type2">
						<%
                            int rowscount = 0;
                            System.Data.DataTable dttype = (System.Data.DataTable)ViewData["dt_dishType"];
                            decimal bagging = 0;
                            bool tempb = dttype.Rows.Count > 0 ? decimal.TryParse(dttype.Rows[0]["bagging"] + "", out bagging) : true;
                            foreach (System.Data.DataRow row in dttype.Rows)
                            {
                                //if (Convert.ToInt32(row["dishnum"]) > 0) //类型下有菜品才显示 20170817
                                //{
                                if (rowscount == 0)
                                {
                            %>
                               <li class="cur yu-bor bbor"><%=row["dishesTypeName"]%></li>
                            <%  }
                                    else
                                    { 
                                %>
                                <li class="yu-bor bbor"><%=row["dishesTypeName"]%></li>
                                <%
}
                                    rowscount++;
                                //}
                            }
                            %>
				       </ul>
                    <!-- 菜品<ul class="tab-inner yu-overflow">-->
			        <div class="tab-inner-scroll yu-overflow">
                    <%
                        rowscount = 0;
                        System.Data.DataTable dt_dish = (System.Data.DataTable)ViewData["dt_dish"];
                        foreach (System.Data.DataRow row in dttype.Rows)
                        {
                            System.Data.DataRow[] drs = dt_dish.Select("DishesTypeID='" + row["DishesTypeID"].ToString() + "'");
                            
                            %>
						        <dl class="food-list" <%=drs.Length==0?"style='display:none;'":"" %>>
							        <dt><%=row["dishesTypeName"]%></dt>
							        <dd>
                                       <%//foreach (System.Data.DataRow dish in dt_dish.Rows)
foreach (System.Data.DataRow dish in drs)
{
                                                 %>
                                                      <div class="yu-grid yu-alignc yu-bor bbor">
									                    <div class="food-pic" UseRichText="<%=dish["UseRichText"] %>">
                                                           <img src="<%=dish["DishesImg"]%>" />
                                                           <input type="hidden" value='<%=dish["DishsesID"]%>'/>
                                                         </div>
									                    <div class="yu-overflow yu-tpad5">
										                    <p class="yu-font14"><%=dish["DishsesName"]%></p>
										                    <%--<p class="yu-font12 yu-grey yu-bmar5">月售186 赞99</p>--%>
										                    <div class="yu-grid yu-alignc">
											                    <p class="yu-overflow yu-orange"><i class="yu-font12">￥</i><i class="yu-font18"><%=dish["Price"]%></i></p>
											                    <div class="ar yu-grid <%=int.Parse(dish["Number"]+"")>0?"hasD":"" %>">
                                                                    <input type="hidden" class="dish-id" value='<%=dish["DishsesID"]%>' id="hid_dish_<%=dish["DishsesID"]%>" />
												                    <p class="reduce ico"></p>
												                    <p class="food-num"><%=dish["Number"]%></p>
												                    <p class="add ico"></p>
											                    </div>
										                    </div>
									                    </div>
								                    </div>
                                        <% } %>
							        </dd>
						        </dl>
                            <% 
rowscount++;
                        }%>
				</div>
				                     </div>
			                     </li>

            <!-- 图片-->
			<li  class="yu-bgf3 yu-bpad60">
			
                <%
                    System.Data.DataTable dt_Img = (System.Data.DataTable)ViewData["dt_storeImg"];
                    if (dt_Img.Rows.Count > 0)
                    {
                        int tcount = dt_Img.Rows.Count / 2;// 0 2 4 6 8 | 1 3 5 7   
                        for (int i = 0; i < tcount; i++)
                        {
                            int before = i * 2;
                            int after = i * 2 + 1;
                        
                       %>
                          <div class="yu-grid yu-tbpad20r pro-img-row">
                             <a>
                               <div class="food-box yu-bor1 bor">
							        <div class="food-pic2">
								        <img src="<%=dt_Img.Rows[before]["imgUrl"]%>" />
							        </div>
							        <%--<div class="yu-grid">
								        <p class="yu-overflow yu-black"></p>
								        <p class="yu-orange"><i class="yu-font12">￥</i><i class="yu-font16"><%=dt_dish.Rows[before]["Price"]%></i></p>
							        </div>--%>
						        </div>
                             </a>
                             <a>
                                 <div class="food-box yu-bor1 bor">
							            <div class="food-pic2">
								            <img src="<%=dt_Img.Rows[after]["imgUrl"]%>" />
							            </div>
							           <%-- <div class="yu-grid">
								            <p class="yu-overflow yu-black"><%=dt_Img.Rows[after]["DishsesName"]%></p>
								            <p class="yu-orange"><i class="yu-font12">￥</i><i class="yu-font16"><%=dt_Img.Rows[after]["Price"]%></i></p>
							            </div>--%>
						            </div>
                             </a>
                          </div>
                       <%
}
                        if (dt_Img.Rows.Count % 2 > 0)
                        {
                            %>
                            <div class="yu-grid yu-tbpad20r pro-img-row">
                                <a>
                                <div class="food-box yu-bor1 bor">
							        <div class="food-pic2">
								        <img src="<%=dt_Img.Rows[dt_Img.Rows.Count-1]["imgUrl"]%>" />
							        </div>
						        </div>
                                </a>
                                <a></a>
                            </div>
                            <%
}
                    }
                       
                 %>
			</li>
		</ul>
	                     </div>
                    </section>
                </div>
                <!--end-->
                <!--底栏-->
                <% System.Data.DataTable dt_detail = (System.Data.DataTable)ViewData["dt_detail"];  %>
                <section class="mask bottomMask"></section>
                <input type="hidden" value="<%=dt_detail.Rows.Count>0?1:0%>" id="showcar" />
                <section class="yu-grid fix-bottom yu-bor tbor yu-lpad10 touch_action">
	<div class="food-details up-slide-ani">
		<dl>
			<dt class="yu-grid yu-bor bbor yu-h40 yu-alignc yu-lrpad10">
				<span class="ico type1"></span>
				<p class="yu-rmar10"><%=ViewData["hotelName"]%></p>
				<p class="yu-font12 yu-lgrey yu-overflow"><%=iszbsj ? "" : "餐饮将送到此酒店"%></p>
				<div class="yu-grid yu-alignc yu-greys clearall">
					<span class="ico type3"></span>
					清空
				</div>
			</dt>
			<dd>
				<%
                    foreach (System.Data.DataRow row in dt_detail.Rows)
                    { 
                         %>
                             <div class="yu-grid yu-bor bbor yu-h50 yu-alignc yu-lrpad10">
					            <p class="yu-overflow"><%=row["DishesName"]%></p>
					            <p class="yu-orange yu-rmar20"><i class="yu-font12">￥</i><i class="yu-font20"><%=row["totalPrice"]%></i></p>
					            <div class="ar yu-grid <%=int.Parse(row["Number"]+"")>0?"hasD":"" %>">
                                <input type="hidden" class="dish-id" value='<%=row["DishsesID"]%>' id='h_<%=row["DishsesID"]%>' />
								<p class="reduce ico"></p>
								<p class="food-num"><%=row["Number"]%></p>
								<p class="add ico"></p>
							    </div>
				            </div>
                         <%
                             }   
				%>
			</dd>
		</dl>
		<div class="yu-grid yu-alignc yu-h50 yu-lrpad10">
			<p>包装费</p>
			<div class="yu-overflow yu-orange"><i class="yu-font12">￥</i>
            <i class="yu-font20" id="li-bagging"><%=bagging%></i> </div>
		</div>
	</div>
	<div class="gwc-ico"><i class="num" style='display:<%=dt_detail.Rows.Count>0?"inline":""%>'><%=dt_detail.Rows.Count>0?dt_detail.Rows[0]["SumNum"]:""%></i><span></span></div>
	<div class="yu-overflow yu-orange"><%--<i class="yu-font26">共</i>--%><i class="yu-font14" id="lt-rmb-mark"><%=dt_detail.Rows.Count > 0 ? "￥" : ""%></i>
    <i class="yu-font26"><%=dt_detail.Rows.Count > 0 ? (decimal.Parse(dt_detail.Rows[0]["disSumPrice"]+"")+bagging).ToString() : ""%></i></div>
	<div class="yu-greys yu-arr type-up yu-rpad20 yu-rmar10 yu-font14">明细</div>
	<div class="yu-btn"><%=dt_detail.Rows.Count > 0 ? "选好了" : "请选择"%></div>
	
</section>
                <!--end-->
                <!--mask-->
                <section class="mask bigimg">
	            <div class="inner">
		            <div class="big-food-box swiper-container2">
                    <div class="swiper-wrapper" id="div_big-title">
                      <div class="swiper-slide" >
                          <img alt="" id="big-title-img" class="big-title-img"/>
                      </div>
                  </div>
                 </div>
                                                                                                                                                                                                   <div class="big-food-details">
     	<p class="yu-font20 yu-bmar5" id="big-dishname"></p>
     	<%--<p class="yu-grey yu-font12 yu-bmar10">月售186 赞99</p>--%>
        <div class="yu-grid yu-grey yu-font12 yu-bmar10 big-dish-desc">
     		<p class="yu-rmar5">描述 :</p>
     		<p class="yu-overflow">
     			<span id="big-dish-desc"><%--剁椒鱼头大份腊肉炒花菜一份西红柿炒蛋一份上汤青菜一份水果一份--%></span>	
     		</p>
     	</div>
        <div <%=iszbsj?"style='display:none'":"" %>>
        	<div class="la-select">
     		<div data="1">
     			<span class="ico"></span>
     			<p class="yu-bor1 bor">小辣</p>
     		</div>
     		<div data="2">
     			<span class="ico"></span>
     			<p class="yu-bor1 bor">中辣</p>
     		</div>
     		<div data="3">
     			<span class="ico"></span>
     			<p class="yu-bor1 bor">大辣</p>
     		</div>
            <input type="hidden" id="hid-la-value" value="0"/>
     	</div>
        </div>
     	<div class="yu-grid">
     		<p class="yu-overflow yu-orange yu-font20" id="big-dishprice"><i class="yu-font12">￥</i></p>
     		<div class="ar yu-grid">
                        <input type="hidden" class="dish-id"/>
						<p class="reduce ico" id="big-bar-btn-reduce"></p>
						<p class="food-num" id="big-bar-btn-num"></p>
						<p class="add ico" id="big-bar-btn-add"></p>
				</div>
     	</div>
     </div>
	            </div>
            </section>
            </li>
            <!---周边餐饮-->
            <li id="near-list" class="<%=isHide3 %>">
                <section class="yu-bgw">
                <% 
                    
                    ////自营商家排到周边餐饮第一家
                    if (defmodel != null)
                    {
                     %>
                      <div class="yu-pad10 yu-bor bbor">
				        <a href="javascript:;" class="yu-grid" onclick="javascript:AroundStore('<%=defmodel.StoreId %>')">
					        <div class="near-pic"><img src="<%=defmodel.Logoimg %>" /></div>
					        <div class="yu-overflow">
					        <div class="yu-grid yu-alignc">
						        <div class="yu-overflow  yu-bmar5">
                                   <div class="yu-overflow">
							        <h3 class="yu-font14 yu-fontn yu-black fl yu-rmar5"><%=defmodel.StoreName%></h3>
                                    <% if (defmodel.Isaround == 2 || defmodel.Isaround == 3)
                                       { %>
                                    <p class="self-sale">自营</p>
                                    <% } %>
                                    </div>
							        <p class="yu-font12">
								        <span class="yu-lgrey"><%=(string.IsNullOrEmpty(defmodel.juli) || defmodel.juli == "0") ? "" : defmodel.juli + "km"%></span>
								        <span class="yu-blue"><%=(string.IsNullOrEmpty(defmodel.fenzhong) || defmodel.fenzhong+""=="0") ? "" : defmodel.fenzhong + "分钟"%></span>
							        </p>
						        </div>
						        <div>
                                   <% if (defmodel.Minprice > 0)
                                      { %>
							        <i class="yu-orange yu-font12">￥</i>
							        <span class="yu-orange yu-font20"><%=defmodel.Minprice%></span>
							        <i class="yu-lgrey yu-font14">起</i>
                                    <%} %>
						        </div>
					        </div>
					        <div>
						        <p>
                                   <% if (!string.IsNullOrEmpty(defmodel.Remo))
                                      { %>
							        <span class="copyico type2">减</span>
							        <span class="yu-grey yu-font14"><%=defmodel.Remo%></span>
                                    <% } %>
						        </p>
					        </div>
				        </div>
				        </a>
			        </div>
                    <% }  %>

                     <%  //遍历周边商家
                         foreach (var item in list)
                         { 
                        %>
                       <div class="yu-pad10 yu-bor bbor">
				        <a href="javascript:;" class="yu-grid"  onclick="javascript:AroundStore('<%=item.StoreId %>')">
					        <div class="near-pic"><img src="<%=item.Logoimg %>" /></div>
					        <div class="yu-overflow">
					        <div class="yu-grid yu-alignc">
						        <div class="yu-overflow  yu-bmar5">
							         <div class="yu-overflow">
                                     <h3 class="yu-font14 yu-fontn yu-black fl yu-rmar5"><%=item.StoreName %></h3>
                                     <% if (item.Isaround == 3 || item.Isaround == 2)
                                        { %>
                                     <p class="self-sale">自营</p>
                                     <% } %>
                                     </div>
							        <p class="yu-font12">
								        <span class="yu-lgrey"><%=(string.IsNullOrEmpty(item.juli) || item.juli == "0") ? "" : item.juli + "km"%></span>
								        <span class="yu-blue"><%=(string.IsNullOrEmpty(item.fenzhong) || item.fenzhong+""=="0") ? "" : item.fenzhong + "分钟"%></span>
							        </p>
						        </div>
						        <div>
                                 <% if (item.Minprice > 0)
                                    { %>
							        <i class="yu-orange yu-font12">￥</i>
							        <span class="yu-orange yu-font20"><%=item.Minprice%></span>
							        <i class="yu-lgrey yu-font14">起</i>
                                <% } %>
						        </div>
					        </div>
					        <div>
						        <%--
                                 <!--暂不做折扣--->
                                 <p class="yu-bmar5">
							        <span class="copyico type1">惠</span>
							        <span class="yu-grey yu-font14">本店会员全场9.8折</span>
						        </p>--%>
						        <p>
                                 <% 
                                     if (!string.IsNullOrEmpty(item.Remo))
                                     { %>
							        <span class="copyico type2">减</span>
							        <span class="yu-grey yu-font14"><%=item.Remo%></span>
                                 <% 
                                     } %>
						        </p>
					        </div>
				        </div>
				        </a>
			        </div>
                        <%}
                         %>
			        
                  
		        </section>
            </li>
            <li id="near-list2" class='<%=isHide2 %>'>
                <!----餐厅座位预订--->
                <ul class="booking-list">
                    <% foreach (var room in diningrooms)
                       { %>
                    <li><a href="/DishOrder/BookDiningRoom/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&DiningRoomID=<%=room.StoreId %>"
                        class="yu-black">
                        <div class="show-header">
                            <div class="inner">
                                <img src="<%=room.Logoimg%>">
                            </div>
                            <div class="yu-bgw yu-h50 yu-grid yu-alignc yu-bor bbor yu-lrpad10 yu-arr">
                                <p class="yu-overflow yu-f30r">
                                    <%=room.StoreName %></p>
                            </div>
                        </div>
                    </a></li>
                    <% } %>
                </ul>
            </li>
        </ul>
        <!--快速导航-->
        <%
            Html.RenderPartial("QuickNavigation", null);
        %>
    </div>
    <script src="http://css.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>
    <script type="text/javascript">

        //大图
        $(function () {

            //加减餐
            var foodNum = 0;
            $("#big-bar-btn-add").click(function () {
                $(".yu-btn").text("选好了");
                if ($(this).siblings(".food-num").text() == "") {
                    foodNum = 1;
                    $(this).siblings(".food-num").text(foodNum);
                } else {
                    foodNum = parseInt($(this).siblings(".food-num").text());
                    foodNum++;
                    $(this).siblings(".food-num").text(foodNum);
                };
                $(this).siblings().fadeIn();
                //$(".gwc-ico .num").text(totalNum);
                var totalNum = $(".gwc-ico .num").text();
                if (totalNum == "") { totalNum = 0; }
                $(".gwc-ico .num").text(parseInt(totalNum) + 1);
                $(".gwc-ico .num").fadeIn();

                var dishId = $(this).siblings(".dish-id").val();
                addDish(dishId); //点餐
            });

            $("#big-bar-btn-reduce").click(function () {
                foodNum = parseInt($(this).siblings(".food-num").text());
                if (foodNum > 0) {
                    foodNum--;
                    $(this).siblings(".food-num").text(foodNum);
                    //$(".gwc-ico .num").text(totalNum);
                    var totalNum = $(".gwc-ico .num").text();
                    if (totalNum == "") { totalNum = 0; } else { totalNum = parseInt(totalNum) - 1; }
                    $(".gwc-ico .num").text(totalNum);

                    totalNum == 0 ? $(".yu-btn").text("请选择") : $(".yu-btn").text("选好了");
                    if (totalNum == 0) {
                        $(".yu-btn").text("请选择");
                        $(".gwc-ico .num").fadeOut();
                    }
                    if (foodNum == 0 && $(this).parents("dl").hasClass("food-list")) {
                        $(this).fadeOut().siblings(".food-num").fadeOut();
                    }

                    var dishId = $(this).siblings(".dish-id").val();
                    reduceDish(dishId); //减餐
                };
            });
        });
    </script>
    <script type="text/javascript">
        var swiper = new Swiper('.swiper-container', {
            pagination: '.swiper-pagination',
            paginationClickable: true,
            // autoplay: 2500,
            autoplayDisableOnInteraction: false,
            loop: true,
            onSlideChangeStart: function (swiper) {
                //$(".hotel-img-mask li").eq(swiper.activeIndex).addClass("cur").siblings().removeClass("cur");
                if (swiper.activeIndex > parseInt($('.activeTotalCount').text())) {
                    $(".activeIndex").text(1);
                } else if (swiper.activeIndex < 1) {
                    $(".activeIndex").text($('.activeTotalCount').text());
                } else {
                    $(".activeIndex").text(swiper.activeIndex);
                }
            }
        });


        $(function () {
            //scroll高度
	        var overH=$(window).height()-648*$("body").width()/750;
        //	将高度封装成函数
	        function scrollH(){
		        $(".tab-nav.type2").height(overH);
		        $(".tab-inner-scroll").height(overH);
		        $(".food-list").last().css("padding-bottom",overH-110);
		        $(".tab-nav.type2>li").last().css("margin-bottom","1.2rem");
	        };
	        scrollH();
	        $(".tab-nav.type2").scroll(function(e){
		        e.preventDefault();
	        });

            //选项卡
            var tabIndex;
            $(".tab-nav").children("li").on("click", function () {
                $(this).addClass("cur").siblings("li").removeClass("cur");
                tabIndex = $(this).index();
                $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
            });

            //创建一个数组 储存每个dl的高度
            var scrollNum = [];
            var scrollLength = $(".tab-inner-scroll").children(".food-list").length;
            for (var i = 0; i < scrollLength; i++) {
                scrollNum[i] = $(".tab-inner-scroll").children(".food-list").eq(i).height();
            }
            // console.log(scrollNum);

            //每个dl的高度 相加前面所有dl的高度即为滚动到其的高度
            function scrollSum(n) {
                var yuSum = 0;
                for (var j = 0; j < n; j++) {
                    yuSum += scrollNum[j];
                }
                return yuSum;
            }

            //滚动时相应的tab切换样式
            $(".tab-inner-scroll").scroll(function () {
                var scrolltop = $(this).scrollTop();
                //console.log(scrolltop)
                if(scrolltop>20){
			        $("#main").slideUp(100);
			        overH=$(window).height()-226*$("body").width()/750;
			        scrollH();
		        }else{
			        $("#main").slideDown(100);
			        overH=$(window).height()-648*$("body").width()/750;
			        scrollH();
		        }
                //笨方法
                if (scrolltop >= scrollSum(1) && scrolltop < scrollSum(2)) {
                    $(".tab-nav.type2").children("li").eq(1).addClass("cur").siblings().removeClass("cur");
                } else if (scrolltop >= scrollSum(2) && scrolltop < scrollSum(3)) {
                    $(".tab-nav.type2").children("li").eq(2).addClass("cur").siblings().removeClass("cur");
                } else if (scrolltop >= scrollSum(3) && scrolltop < scrollSum(4)) {
                    $(".tab-nav.type2").children("li").eq(3).addClass("cur").siblings().removeClass("cur");
                } else if (scrolltop >= scrollSum(4) && scrolltop < scrollSum(5)) {
                    $(".tab-nav.type2").children("li").eq(4).addClass("cur").siblings().removeClass("cur");
                } else if (scrolltop >= scrollSum(5) && scrolltop < scrollSum(6)) {
                    $(".tab-nav.type2").children("li").eq(5).addClass("cur").siblings().removeClass("cur");
                } else if (scrolltop >= scrollSum(6)) {
                    $(".tab-nav.type2").children("li").eq(6).addClass("cur").siblings().removeClass("cur");
                } else {
                    $(".tab-nav.type2").children("li").eq(0).addClass("cur").siblings().removeClass("cur");
                }
            })
            //点击tab时滚动到相应高度
            $(".tab-nav.type2").children("li").on("click", function () {
                $(".tab-inner-scroll").scrollTop(scrollSum($(this).index()));
            })
            ///<!--- end---->



            //加减餐
            var foodNum = 0;
            $(".food-list,.food-details").find("dd").on("click", ".add", function () {

                $(".yu-btn").text("选好了");
                if ($(this).siblings(".food-num").text() == "") {
                    foodNum = 1;
                    $(this).siblings(".food-num").text(foodNum);
                } else {
                    foodNum = parseInt($(this).siblings(".food-num").text());
                    foodNum++;
                    $(this).siblings(".food-num").text(foodNum);
                };
                $(this).siblings().fadeIn();
                //$(".gwc-ico .num").text(totalNum);
                var totalNum = $(".gwc-ico .num").text();
                if (totalNum == "") { totalNum = 0; }
                $(".gwc-ico .num").text(parseInt(totalNum) + 1);
                $(".gwc-ico .num").fadeIn();

                var dishId = $(this).siblings(".dish-id").val();
                addDish(dishId); //点餐
            });

            $(".food-list,.food-details").find("dd").on("click", ".reduce", function () {
                foodNum = parseInt($(this).siblings(".food-num").text());
                if (foodNum > 0) {
                    foodNum--;
                    $(this).siblings(".food-num").text(foodNum);
                    //$(".gwc-ico .num").text(totalNum);
                    var totalNum = $(".gwc-ico .num").text();
                    if (totalNum == "") { totalNum = 0; } else { totalNum = parseInt(totalNum) - 1; }
                    $(".gwc-ico .num").text(totalNum);

                    totalNum == 0 ? $(".yu-btn").text("请选择") : $(".yu-btn").text("选好了");
                    if (totalNum == 0) {
                        $(".yu-btn").text("请选择");
                        $(".gwc-ico .num").fadeOut();
                    }
                    if (foodNum == 0 && $(this).parents("dl").hasClass("food-list")) {
                        $(this).fadeOut().siblings(".food-num").fadeOut();
                    }

                    var dishId = $(this).siblings(".dish-id").val();
                    reduceDish(dishId); //减餐
                };
            });

            //大图
            var innerH;
            $(".mask").click(function () {
                $(this).fadeOut();
            })
            $(".mask .inner").click(function (e) {
                e.stopPropagation();
            })

            //弹出腊味选择
            $(".food-pic").on("click", function () {
                var UseRichText = $(this).attr('UseRichText'); //1图文模式，0简洁模式
                var dishId = $(this).children("input:hidden").val();
                if (UseRichText == 1) {
                     window.location.href="/DishOrder/DishDetailView_Rich/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>&dishId="+dishId+"&storeId=<%=ViewData["storeId"] %>&tid=<%=tid %>";
                } else {
                    LoadDishInfo(dishId);

                    $(".bigimg").fadeIn();
                    var swiper2 = new Swiper('.swiper-container2', {
                        paginationClickable: true,
                        autoplayDisableOnInteraction: false,
                        //loop: true
                    });
                    //大图弹窗高度
                    innerH = $(".bigimg .inner").height();
                    $(".bigimg .inner").css("margin-top", -innerH / 2)
                }
            });

            //选择辣味
            $(".la-select").children("div").on("click", function () {
                $('#hid-la-value').val("0");
                if ($(this).hasClass("cur")) {
                    $(this).removeClass("cur");
                } else {
                    $('#hid-la-value').val(($(this).attr('data'))); //设置腊味
                    $(this).addClass("cur").siblings().removeClass("cur");
                }
            })

            //明细
            $(".fix-bottom").click(function () {
                var showcar = $("#showcar").val();
                if (showcar == "1") {
                    $(".food-details").toggle();
                    $(this).find(".yu-arr").toggleClass("type-up").toggleClass("type-down");
                    $(".bottomMask").fadeToggle();
                }
            })
            $(".fix-bottom .yu-btn").click(function (e) {
                e.stopPropagation();
            })
            $(".food-details").click(function (e) {
                e.stopPropagation();
            })
            $(".bottomMask").click(function () {
                $(".food-details").toggle();
                $(".fix-bottom").find(".yu-arr").toggleClass("type-up").toggleClass("type-down");
                //		$(".bottomMask").fadeOut();
            })
            //清空
            $(".clearall").click(function () {
                $.post('/DishOrder/ClearDish/<%=ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&userWeiXinID=<%=ViewData["userWeiXinID"] %>',
                function (data) {
                    if (data.error != '0') {
                        //$(this).parent("dt").siblings("dd").remove();
                        $(".food-details>dl>dd").empty(); //移除明细
                        $(".gwc-ico .num").text('').removeAttr('style');
                        $('p[class="reduce ico"]').removeAttr('style').removeClass('hasD'); //隐藏减按钮
                        $(".yu-btn").text("请选择");
                        $(".yu-font26").text(''); //总价
                        $("#lt-rmb-mark").text(''); //￥符号
                        $(".food-num").text('');
                        //$(".food-num").siblings(".reduce").removeAttr('style');
                        $('p[class="reduce ico"]').parent().removeClass('hasD');

                        $("#showcar").val(0);
                    }
                });

            })




        })
    </script>
    <script type="text/javascript">
        //load 大图
        function LoadDishInfo(dishId)
        {
            //先清空大图
            $("#big-dishname,#big-dishprice").html('');
            $.post('/DishOrder/LoadDishInfo/?orderCode=<%=ViewData["orderCode"] %>&dishId='+dishId,function(data)
            {
              if(data.error==1)
              {
                  $("#hid-la-value").siblings().removeClass("cur");
                  var json=eval('('+data.message+')');
                  $("#big-dishname").html(json["DishsesName"]);
                  $("#big-dishprice").html('<i class="yu-font12">￥</i>'+json["price"]);
                  $("#big-bar-btn-num").html(data.foodNum);
                  $("#big-bar-btn-reduce").siblings(".dish-id").val(json["DishsesID"]);
                  
                  var url=json["DishesImg"];
                   $("#div_big-title").html("");
                     //$(".big-title-img").attr("src",url);
                    $("#div_big-title").append('<div class="swiper-slide" style="background:url('+url+') no-repeat center;background-size:contain;"></div>');
                  
                  if(json["ShowHot"]==1){
                    $(".la-select").hide();
                  }else{$(".la-select").show();}
                  
                  var desc=json["DishsesDesc"]+"";
                  if(desc.length>0&&desc.toLowerCase()!="null"){
                     $('.big-dish-desc').show();
                  }else{
                     $('.big-dish-desc').hide();
                  }
                  $('#big-dish-desc').html(desc);

              }else
              {
                 layer.msg(data.message);
              }
              
            });
        }
        //加餐
        function addDish(dishId) {
            //var bagging = $('div .yu-lrpad10').find('div').children('.yu-font20').text();//包装费
            var bagging='<%=bagging %>';
            var Hot=$('#hid-la-value').val();
            $.post('/DishOrder/AddDishOrder/<%=ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&key=<%=ViewData["key"] %>&Hot='+Hot+'&dishId=' + dishId, function (data) {
                
                if(data.error==0){
                    layer.msg(data.message);
                    setTimeout(function(){ window.location.reload();},500);
                    return false;
                }else{
                var html = "";
                var arr = eval("(" + data.message + ")");
                if (arr.length > 0) {
                    var num=0;
                    for (var i = 0; i < arr.length; i++) {
                        num+=parseInt(arr[i]["Number"]);
                        html += '<div class="yu-grid yu-bor bbor yu-h50 yu-alignc yu-lrpad10">'
                              + '<p class="yu-overflow">' + arr[i]["DishesName"] + '</p>'
                              + '<p class="yu-orange yu-rmar20">'
                              + '<i class="yu-font12">￥</i>'
                              + '<i class="yu-font20">' + arr[i]["totalPrice"] + '</i></p>'
                              + '<div class="ar yu-grid"><input type="hidden" class="dish-id" value="' + arr[i]["DishsesID"] + '" id="hid_deta_dish_' + arr[i]["DishsesID"] + '"/>'
                              + '<p class="reduce ico"></p><p class="food-num">' + arr[i]["Number"] + '</p><p class="add ico"></p></div>'
                              + '</div>';
                    }
                    //console.log(arr[0]);
                    //var sum=Number(arr[0]["SumPrice"])+Number(bagging);//总价=菜品总价+包装费
                    var sum=Number(arr[0]["disSumPrice"])+Number(bagging);//总价=菜品折后总价+包装费
                    $(".food-details>dl>dd").html(html);
                    $(".yu-font26").html(sum);
                    $("#lt-rmb-mark").text('￥');

                    var dd = $('#hid_deta_dish_' + dishId).siblings(".food-num").text();
                    $('#hid_dish_' + dishId).siblings(".food-num").text(dd);
                    $('#hid_dish_' + dishId).siblings(".food-num").css({display:'block'});
                    $('#hid_dish_' + dishId).siblings(".reduce").css({display:'block'});
                    
                    //总数
                    $(".gwc-ico .num").css({display:'block'});
                    $(".gwc-ico .num").text(num);
                    num == 0 ? $(".yu-btn").text("请选择") : $(".yu-btn").text("选好了");

                    $("#showcar").val(1);
                }else{
                   $("#showcar").val(0);
                }
               }
            });
        }

        //减餐
        function reduceDish(dishId) {
            var bagging='<%=bagging %>';
            $.post('/DishOrder/ReduceDishOrder/<%=ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&userWeiXinID=<%=ViewData["userWeiXinID"] %>&dishId=' + dishId, function (data) {
                var html = "";
                var SumPrice = "";
                var RMB='';
                var arr = eval("(" + data.message + ")");
                if (arr.length > 0) {
                    for (var i = 0; i < arr.length; i++) {

                        html += '<div class="yu-grid yu-bor bbor yu-h50 yu-alignc yu-lrpad10">'
                              + '<p class="yu-overflow">' + arr[i]["DishesName"] + '</p>'
                              + '<p class="yu-orange yu-rmar20">'
                              + '<i class="yu-font12">￥</i>'
                              + '<i class="yu-font20">' + arr[i]["totalPrice"] + '</i></p>'
                              + '<div class="ar yu-grid"><input type="hidden" class="dish-id" value="' + arr[i]["DishsesID"] + '" id="hid_deta_dish_' + arr[i]["DishsesID"] + '"/>'
                              + '<p class="reduce ico"></p><p class="food-num">' + arr[i]["Number"] + '</p><p class="add ico"></p></div>'
                              + '</div>';
                    }
                    
                    //SumPrice =Number(arr[0]["SumPrice"])+Number(bagging);//总价=菜品总价+包装费
                    SumPrice =Number(arr[0]["disSumPrice"])+Number(bagging);//总价=菜品折后总价+包装费
                    RMB="￥";

                    $("#showcar").val(1)
                }else{
                   $("#showcar").val(0)
                }

                $(".food-details>dl>dd").html(html);
                $(".yu-font26").html(SumPrice);
                $("#lt-rmb-mark").text(RMB);
                //调整首页餐品数量
                var dd = $('#hid_deta_dish_' + dishId).siblings(".food-num").text();
                $('#hid_dish_' + dishId).siblings(".food-num").text(dd);
                if (dd == "") {
                    $('#hid_dish_' + dishId).siblings('.reduce').css({display:'none'}); //隐藏减按钮
                }
            });
        }
        
        //选好了
        $(function () {
            $(".yu-btn").click(function () {
                
                var btn = $(this).text();
                if (btn == "选好了") {
                var sumprice=$(".yu-font26").html();//菜品总价+打包费
                var minprice='<%= store == null ? 0 : store.Minprice%>';//起送价
                
                if(Number(sumprice)<Number(minprice))
                {
                  layer.msg("订单金额小于商家起送价:"+minprice);
                  return;
                }
                
                var url="/DishOrder/SettingOrderYouhuiAmount/<%=Html.ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&key=<%=ViewData["key"] %>";
                    $.post(url, function (data) {
                         if(data.error==1){
                         window.location = "/DishOrder/PagePay/<%=Html.ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>&tid=<%=tid %>";
                         }else{
                           layer.msg(data.message);
                         }
                     });
                }

            });

        })

        function AroundStore(storeId)
        {
           window.location.href="/DishOrder/DishOrderIndex/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId="+storeId;
        }

        
    </script>
</body>
</html>
