<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%        
    string hotelid = RouteData.Values["id"].ToString();
    string key = HotelCloud.Common.HCRequest.GetString("key");
    string weixinID = "";
    string userWeiXinID = "";
    if (key.Contains("@"))
    {
        
        string[] a = key.Split('@');
        weixinID = a[0];
        userWeiXinID = a[1];
    }
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotelid);
    viewDic.Add("uwx", userWeiXinID);

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();

    int tid = HotelCloud.Common.HCRequest.getInt("tid");//桌台号id 
%>

<%
    List<hotel3g.Models.StoresView> list = (List<hotel3g.Models.StoresView>)ViewData["list_store"];
    List<hotel3g.Models.StoresView> diningrooms = list.FindAll(a => a.IsDiningRoom == 1);//自营开启餐厅订位排在第一位
    hotel3g.Models.StoresView defmodel = (hotel3g.Models.StoresView)ViewData["defmodel"];
    if (defmodel != null)
    {
        if (defmodel.IsDiningRoom == 1)
        {
            diningrooms.Insert(0, (hotel3g.Models.StoresView)ViewData["defmodel"]);
        }
    }
    
    var hasdef = defmodel == null ? 0 : 1;// 1有默认
    
    var lcount = list.Count;//餐厅数量
    var storeid = HotelCloud.Common.HCRequest.GetInt("storeId", 0);//选中餐厅id
    var dingweicount = diningrooms.Count;//开启订位餐厅数
    
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


    if (tid!=Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码)) //扫描过来，隐藏头
    {
        title = "isHide";
    }

    //没有选择商家隐藏菜品类型
    string showdishtype = "";
    if (storeid == 0)
    {
        showdishtype = "isHide";
        //只有一家商家，显示菜品类型
        if (lcount == 0) { showdishtype = ""; }
    }
     %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
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
    <title><%=ViewData["curr_store"] + "" == "" ? "酒店订餐" : (storeid == 0 && lcount>0 ? "酒店订餐" : ViewData["curr_store"])%></title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/iconfont-base64.css"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css"/>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" ></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <style type="text/css">
      
       
    </style><%-- .booking-list>li{width:100%} --%>
    <style type="text/css">
        .isHide{display:none;}
    </style>
</head>

<body>
	<article class="full-page">
        <% if (tid == Convert.ToInt32(hotel3g.Models.EnumFromScan.非扫码))
           { %>
               <%Html.RenderPartial("HeaderA", viewDic);%>
        <%} %>
		<section class="show-body">
			<section class="content2">
            
            <%
                System.Data.DataTable dt_dishType = (System.Data.DataTable)ViewData["dt_dishType"];
                 %>

            <div class="screen-icon <%=showdishtype %>">
					<p class="iconfont icon-zuox screen-icon-btn"></p>
					<p class="iconfont icon-youx screen-icon-btn"></p>
					<ul>
                       <li data="0">
							<p class="screen-icon-bg type1"></p>
							<p class="screen-icon-txt">全部商品</p>
						</li>
                       <% 
                           int idx = 8; 
                          foreach (System.Data.DataRow row in dt_dishType.Rows)
                          {
                              if (Convert.ToInt32(row["dishnum"]) > 0)
                              {%>
						<li data="<%=row["dishesTypeID"]%>">
							<p class="screen-icon-bg type<%=idx %>"></p>
							<p class="screen-icon-txt"><%=row["dishesTypeName"]%></p>
						</li>
                        <% 
                              if(idx<12){idx++;}else{idx=8;}
                              } 
                          }%>
					</ul>
				</div>

				<div class="tab-con">
					<ul class="tab-nav type0 yu-grid yu-bor bbor  <%=title %>" id="ul_titleid">
						<li class="yu-overflow  <%=tcur1 %> <%=cur1 %>"  id="li_1">餐饮预订</li>
                        <% if (list.Count > 0)
                           { %>
						<li class="yu-overflow  <%=tcur3 %> <%=cur3 %>" id="li_3">餐厅列表</li>
						<%} %>
                        <li class="yu-overflow  <%=tcur2 %> <%=cur2 %>" id="li_2">餐厅订位</li>
					</ul>
					<ul class="tab-inner">
                     <!---餐饮预订--->
                        
						<li class="<%=isHide1 %>">
                            <a class="cart" style='position:fixed; <%=ViewData["orderDishTotalNum"]+""=="0"?"display:none":"display:block" %>'>
								<p class="ico" ></p>
								<p class="num" id="gouwuche_num" style='display:block'><%=ViewData["orderDishTotalNum"]%></p>
							</a>
                            <%--<div class="yu-h40 yu-bgw yu-line40 yu-textc yu-font16 yu-tmar10"><%=ViewData["curr_store"]%></div>--%>
							<ul class="booking-list" id="dishlist">
                            <% 
                                decimal bagging = 0;
                                System.Data.DataTable dt_dish = (System.Data.DataTable)ViewData["dt_dish"];
                                
                               foreach (System.Data.DataRow row in dt_dishType.Rows)
                               { %>
                              <div id="div<%=row["dishesTypeID"]%>" data="<%=row["dishesTypeID"]%>">
                            <% 
                                //类型下的菜品
                                System.Data.DataRow[] drs = dt_dish.Select("DishesTypeID='" + row["DishesTypeID"].ToString() + "'");
                                foreach (System.Data.DataRow dish in drs)
                                {
                               %>
								<li>
									<div class="show-header">
										<div class="inner" onclick="javascript:toDishDetailView('<%=dish["DishsesID"] %>','<%=dish["UseRichText"] %>')">
											<img src="<%=dish["DishesImg"]%>" />
                                            <input type="hidden" value='<%=dish["DishsesID"]%>'/>
											<div class="txt-bar yu-grid yu-alignc">
												<p class="yu-overflow"><%=dish["DishsesName"]%></p>
											</div>
										</div>
										<div class="yu-bgw yu-h50 yu-grid yu-alignc yu-bor bbor yu-lrpad10">
											<p class="yu-overflow">￥<%=dish["Price"]%></p>
											<div class="ar yu-grid">
                                            <input type="hidden" class="dish-id" value='<%=dish["DishsesID"]%>' id="hid_dish_<%=dish["DishsesID"]%>" />
											<p class="reduce ico type2" <%=int.Parse(dish["Number"]+"")>0?"style='display:block'":"" %>></p>
											<p class="food-num" <%=int.Parse(dish["Number"]+"")>0?"style='display:block'":"" %>><%=dish["Number"]%></p>
											<p class="add ico type2"></p>
											</div>
										</div>
									</div>
								</li>
                                <% 
                                }
                                 %>
                               </div>
                               <%
                               }
                                %>
							</ul>
						</li>
                       
                       <!---周边餐饮--->
                        
						<li class="<%=isHide3 %>">
							<ul class="booking-list">
                            <% 
                            ////自营商家排到周边餐饮第一家
                           
                            if (defmodel != null && list.Count > 0)
                            {
                             %>
                             <li>
								<a href="#" class="yu-black" onclick="javascript:AroundStore('<%=defmodel.StoreId %>')">
								<div class="show-header">
									<div class="inner">
										<img src="<%=defmodel.Logoimg %>" />
									</div>
									<div class="yu-bgw yu-h50 yu-grid yu-alignc yu-bor bbor yu-lrpad10 yu-arr">
										<p class="yu-overflow"><%=defmodel.StoreName%></p>
									</div>
								</div>
								</a>
								</li>

                             <% } %>

                             <%
                             //List<hotel3g.Models.StoresView> list = (List<hotel3g.Models.StoresView>)ViewData["list_store"];
                             list = list.OrderByDescending(a => a.Isaround).ToList();
                             foreach (var item in list)
                             { 
                            %>
								<li>
									<a href="#" class="yu-black" onclick="javascript:AroundStore('<%=item.StoreId %>')">
									<div class="show-header">
										<div class="inner">
											<img src="<%=item.Logoimg %>" />
										</div>
										<div class="yu-bgw yu-h50 yu-grid yu-alignc yu-bor bbor yu-lrpad10 yu-arr">
											<p class="yu-overflow"><%=item.StoreName %></p>
										</div>
									</div>
									</a>
								</li>
                            <% } %>
							</ul>
						</li>

                        <!---餐厅订位--->
						<li class="<%=isHide2 %>">
							<ul class="booking-list">
                            <% 
                               
                                foreach (var room in diningrooms)
                                {
                                 %>
								<li>
									<a href="/DishOrderA/BookDiningRoom/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&DiningRoomID=<%=room.StoreId %>" class="yu-black">
									<div class="show-header">
										<div class="inner">
											<img src="<%=room.Logoimg%>" />
										</div>
										<div class="yu-bgw yu-h50 yu-grid yu-alignc yu-bor bbor yu-lrpad10 yu-arr">
											<p class="yu-overflow"><%=room.StoreName%></p>
										</div>
									</div>
									</a>
								</li>
                                <% } %>
							</ul>
						</li>

                        
					</ul>
				</div>
			</section>
		</section>
		
	</article>
    
	<script>
	    $(function () {
            
	        //选项卡
	        var tabIndex;
	        $(".tab-nav").children("li").on("click", function () {
	            $(this).addClass("cur").siblings("li").removeClass("cur");
	            tabIndex = $(this).index();
	            $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
	        })

	        //加餐
	        var foodNum = 0;
	        $(".add").on("click", function () {
	            
	            if ($(this).siblings(".food-num").text() == "") {
	                foodNum = 1;
	                $(this).siblings(".food-num").text(foodNum);
	            } else {
	                foodNum = parseInt($(this).siblings(".food-num").text());
	                foodNum++;
	                $(this).siblings(".food-num").text(foodNum);
	            };
	            $(this).siblings().fadeIn();

	            var totalNum = $("#gouwuche_num").text();
	            if (totalNum == "") { totalNum = 0; }
	            $("#gouwuche_num").text(parseInt(totalNum) + 1);
	            $(".cart").fadeIn();

	            var dishId = $(this).siblings(".dish-id").val();
	            addDish(dishId); //点餐
	        });

	        //减餐
	        $(".reduce").on("click", function () {
	            var foodNum = parseInt($(this).siblings(".food-num").text());
	            
	            if (foodNum > 0) {
	                foodNum--;
	                $(this).siblings(".food-num").text(foodNum);

	                var totalNum = $("#gouwuche_num").text();
	                if (totalNum == "" | totalNum==0) { totalNum = 0; } else { totalNum = parseInt(totalNum) - 1; }
	                $("#gouwuche_num").text(totalNum);
	                if (totalNum == 0) {
	                    //$("#gouwuche_num").fadeOut();
                         $(".cart").fadeOut();
	                }
	                if (foodNum == 0) {
	                    $(this).fadeOut().siblings(".food-num").fadeOut();
                       
	                }

	                var dishId = $(this).siblings(".dish-id").val();
	                reduceDish(dishId); //减餐
	            }else{
                  $(".cart").hide();
                };

	        });

	    })

        function toDishDetailView(dishId,UseRichText)
        {
          if(UseRichText==0){
            window.location.href="/DishOrderA/DishDetailView/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>&dishId="+dishId+"&storeId=<%=ViewData["storeId"] %>&tid=<%=tid %>";
           }else{
            window.location.href="/DishOrderA/DishDetailView_Rich/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>&dishId="+dishId+"&storeId=<%=ViewData["storeId"] %>&tid=<%=tid %>";
           }
        }

        function AroundStore(storeId)
        {
            window.location.href="/DishOrderA/DishOrderIndex/<%=Html.ViewData["hId"] %>?key=<%=ViewData["key"] %>&storeId="+storeId;
        }

         //选好了
        $(function () {
        $(".cart").click(function () {
            var gouwuche_num = $('#gouwuche_num').text();
            if (gouwuche_num != ""&&gouwuche_num!='0') {
            var url="/DishOrderA/SettingOrderYouhuiAmount/<%=Html.ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&key=<%=ViewData["key"] %>";
                $.post(url, function (data) {
                        if(data.error==1){
                        window.location = "/DishOrderA/DishCart/<%=Html.ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&key=<%=Html.ViewData["weixinID"] %>@<%=ViewData["userWeiXinID"] %>&tid=<%=tid %>";
                        }else{
                        layer.msg(data.message);
                        window.location.reload();
                        }
                    });
            }else{
              layer.msg("请先选择餐品！！");
            }

        });

    })

	</script>

    <script type="text/javascript">
        //加餐
        function addDish(dishId) {
            var bagging = '<%=bagging %>';
            var Hot =0;
            $.post('/DishOrderA/AddDishOrder/<%=ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&key=<%=ViewData["key"] %>&Hot=' + Hot + '&dishId=' + dishId, function (data) {

                if (data.error == 0) {
                    layer.msg(data.message);
                    window.location.reload();
                    return false;
                } else {
                    
                }
            });
        }

        //减餐
        function reduceDish(dishId) {
            var bagging = '<%=bagging %>';
            $.post('/DishOrderA/ReduceDishOrder/<%=ViewData["hId"] %>?storeId=<%=ViewData["storeId"] %>&orderCode=<%=ViewData["orderCode"] %>&userWeiXinID=<%=ViewData["userWeiXinID"] %>&dishId=' + dishId, function (data) {
                
            });
        }
    </script>

    <script type="text/javascript">
        $(function () {
            //单色图标
            var iconLength = $(".screen-icon").find("li").length,
			    iconClick = 0,
			    leftP = 0.5;
            $(".screen-icon").find("li").on("click", function () {
                $(this).toggleClass("cur").siblings().removeClass("cur");

                var dishtypeid = $(this).attr('data');
                var arr = $('#dishlist').children('div');
                $.each(arr, function (i, t) {
                    if (dishtypeid != 0) {
                        if (dishtypeid == $(t).attr('data')) {
                            $('#div' + $(t).attr('data')).show().siblings().hide();
                        }
                    } else {
                        $('#div' + $(t).attr('data')).show();
                    }
                });

            });
            $(".screen-icon-btn.icon-youx").click(function () {
                if (iconClick < iconLength - 5) {
                    iconClick++;
                    $(".screen-icon ul").animate({ left: -(1.3 * iconClick - leftP) + "rem" }, 100);
                }
            })
            $(".screen-icon-btn.icon-zuox").click(function () {
                if (iconClick > 0) {
                    iconClick--;
                    $(".screen-icon ul").animate({ left: -(1.3 * iconClick - leftP) + "rem" }, 100);
                }
            })
        });
    </script>
</body>
</html>
