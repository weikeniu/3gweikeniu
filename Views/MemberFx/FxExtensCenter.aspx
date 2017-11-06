<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();
 %>
<html lang="zh-cn">
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
<title>推广中心</title>
  <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css?v=1.1"/>
<!--  <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css?v=1.1"/>-->
  <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css?v=1.1"/>
  <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />

<script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
<script src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
</head>
<%
    
    string ratejson = ViewData["ratejson"] + "";
    Hashtable ratejsonobj = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(ratejson);
    List<WeiXin.Models.Home.Room> roomlist = Newtonsoft.Json.JsonConvert.DeserializeObject<List<WeiXin.Models.Home.Room>>(ratejsonobj["roomlist"].ToString());
    Dictionary<string, Hashtable> hourroomRates = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, Hashtable>>(ratejsonobj["hourroomRates"].ToString());
    Dictionary<string, Hashtable> roomRates = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, Hashtable>>(ratejsonobj["roomRates"].ToString());
    int hourroomprice = hourroomRates.Count == 0 ? 0 : WeiXinPublic.ConvertHelper.ToInt(hourroomRates.First().Value["CtripPrice"]);

    Dictionary<string, List<Hashtable>> roomImgs = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, List<Hashtable>>>(ratejsonobj["roomImgs"].ToString());


    System.Data.DataTable dtSaleProduct = (System.Data.DataTable)ViewData["dtSaleProduct"];//团购预售
    
    //佣金率
    int kefang=(int)ViewData["kefang"];
    int canyin = (int)ViewData["canyin"];
    int tuangou = (int)ViewData["tuangou"];
    int chaoshi = (int)ViewData["chaoshi"];
    double Profit = hotel3g.Models.MemberFxLogic.TuiGuangProfit();
    
    List<hotel3g.Models.FxExtensItem> list = new List<hotel3g.Models.FxExtensItem>();
    //钟点房
    if (hourroomRates.Count > 0) 
    {
        hotel3g.Models.FxExtensItem model = new hotel3g.Models.FxExtensItem();
        model.name = "钟点房";
        model.imgurl = "../../images/defaultRoomImg.jpg";
        model.memberprice = hourroomprice;
        model.yjingLv = kefang;
        model.yjing = (model.yjingLv * model.memberprice / 100) * decimal.Parse(Profit.ToString());
        list.Add(model);
    }

    int title = HotelCloud.Common.HCRequest.getInt("t");
 %>
<body class="ca-overflow">
      <!--//顶部导航-->
     <div class="ca__headNav fixed">
           <div class="head">
                <a class="back" href="javascript:history.back(-1);"></a>
                <h2 class="tit">酒店推广中心</h2>
           </div>
     </div>
     <div>
           <ul class="j-table-show">
                <li class="ca-flex cur1 <%=(title==1||title==0)?"curTab":""%>" onclick="curTab(1)"><a href="javascript:;">默认</a></li>
                <li class="ca-flex cur2 <%=title==2?"curTab":""%>" onclick="curTab(2)"><a href="javascript:;">价格</a></li>
                <li class="ca-flex cur3 <%=title==3?"curTab":""%>" onclick="curTab(3)"><a href="javascript:;">总佣金</a></li>
           </ul>
     </div>
     <div class="ca-hotel-ext-center Sub1" id="sub1">
          <ul>
               <!----房型--->
                <%
                    List<string> roomidlist = roomRates.Select(item => item.Key.Remove(item.Key.IndexOf("_"))).Distinct().ToList();
                    roomRates.Add("-1", null);
                    for (int i = 0; i < roomidlist.Count; i++)
                    {
                        string roomname = null;
                        int lowestprice = 0;
                        string roomid = "-1";
                        string imgurl = null;
                        WeiXin.Models.Home.Room room = null;
                        if (i > -1)
                        {
                            roomid = roomidlist[i];
                            room = roomlist.FirstOrDefault(r => r.ID.ToString().Equals(roomid));
                            if (room != null)
                            {
                                roomname = room.RoomName;
                            }
                        }
                        
                        Dictionary<string, Hashtable> roomratelist = roomRates.Where(r => r.Key.StartsWith(roomid)).ToDictionary(r => r.Key, r => r.Value);
                        if (i > -1)
                        {
                            int _price = WeiXinPublic.ConvertHelper.ToInt(roomratelist.First().Value["CtripPrice"]);
                            
                            lowestprice = _price;
                        }
                        
                        List<Hashtable> imglist = new List<Hashtable>();
                        if (roomImgs.ContainsKey(roomid))
                        {
                            imglist = roomImgs[roomid];
                            if (imglist.Count > 0)
                            {
                                imgurl = imglist.First()["SmallUrl"].ToString();
                            }
                        }
                        else
                        {
                            imgurl = "../../images/defaultRoomImg.jpg";
                        }
                     
                        hotel3g.Models.FxExtensItem model = new hotel3g.Models.FxExtensItem();
                        model.name = roomname;
                        model.imgurl = imgurl;
                        model.memberprice = lowestprice;
                        model.yjingLv = kefang;
                        model.yjing = (model.yjingLv * model.memberprice / 100) * decimal.Parse(Profit.ToString());
                        list.Add(model);
                    } %>
                <!---团购预售---->
                <% foreach (System.Data.DataRow row in dtSaleProduct.Rows)
                   {
                       hotel3g.Models.FxExtensItem model = new hotel3g.Models.FxExtensItem();
                       model.name = row["ProductName"]+"";
                       model.imgurl = (row["SmallImageList"] + "").Split(',')[0];
                       model.memberprice = Convert.ToDecimal(row["minPrice"]);
                       model.yjingLv = tuangou;
                       model.yjing = (model.yjingLv * model.memberprice / 100) * decimal.Parse(Profit.ToString());
                       list.Add(model);
                   } %>

               <%
                   string sort = HotelCloud.Common.HCRequest.GetString("s");
                   //if (title == 2) 
                   //{
                   //    if (sort == "desc")
                   //    {
                   //        list = list.OrderByDescending(a => a.memberprice).ToList();
                   //    }
                   //    else 
                   //    {
                   //        list = list.OrderBy(a => a.memberprice).ToList();
                   //    }
                   //}
                   //if (title == 3)
                   //{
                   //    if (sort == "desc")
                   //    {
                   //        list = list.OrderByDescending(a => a.yjing).ToList();
                   //    }
                   //    else
                   //    {
                   //        list = list.OrderBy(a => a.yjing).ToList();
                   //    }
                   //}
                   
                   foreach (hotel3g.Models.FxExtensItem item in list) 
                   {
                   %>
                   <li>
                     <div class="ca-safe-distance ca-displayfx">
                           <div class="ca-rooms-pht"><img src="<%=item.imgurl %>"></div>
                           <div class="ca-big-bedroom ca-flex">
                                 <h1><%=item.name%></h1>
                                 <p>会员价：￥<%=item.memberprice.ToString("f2")%></p>
                                 <div class="ca-all-gene"><span>总佣金：</span><span class="ca-f40">￥<%=item.yjing.ToString("f2")%></span><i><%--（<%=kefang %>%）--%></i></div>
                           </div>
                           <div class="ca-displayfx ca-goto-money"><a href="/Promoter/Generalize/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>"><input type="button" value="去赚钱" class="btn-go-eran"></a></div>
                     </div>
                  </li>
                   <%
                   }
                    %>
          </ul>
     </div>
     <!--Sub1 end-->
     <div class="ca-hotel-ext-center Sub2" id="sub2_asc">
          <ul>
              <% 
                  List<hotel3g.Models.FxExtensItem> list2asc = list.OrderBy(a => a.memberprice).ToList();
                 foreach (hotel3g.Models.FxExtensItem item in list2asc)
                 { %>
                <li>
                     <div class="ca-safe-distance ca-displayfx">
                           <div class="ca-rooms-pht"><img src="<%=item.imgurl %>"></div>
                           <div class="ca-big-bedroom ca-flex">
                                 <h1><%=item.name%></h1>
                                 <p>会员价：￥<%=item.memberprice.ToString("f2")%></p>
                                 <div class="ca-all-gene"><span>总佣金：</span><span class="ca-f40">￥<%=item.yjing.ToString("f2")%></span><i><%--（<%=kefang %>%）--%></i></div>
                           </div>
                           <div class="ca-displayfx ca-goto-money"><a href="/Promoter/Generalize/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>"><input type="button" value="去赚钱" class="btn-go-eran"></a></div>
                     </div>
                  </li>
                <% } %>
          </ul>
     </div>
     <div class="ca-hotel-ext-center Sub2" id="sub2_desc">
          <ul>
              <% 
                  List<hotel3g.Models.FxExtensItem> list2desc = list.OrderByDescending(a => a.memberprice).ToList();
                  foreach (hotel3g.Models.FxExtensItem item in list2desc)
                 { %>
                <li>
                     <div class="ca-safe-distance ca-displayfx">
                           <div class="ca-rooms-pht"><img src="<%=item.imgurl %>"></div>
                           <div class="ca-big-bedroom ca-flex">
                                 <h1><%=item.name%></h1>
                                 <p>会员价：￥<%=item.memberprice.ToString("f2")%></p>
                                 <div class="ca-all-gene"><span>总佣金：</span><span class="ca-f40">￥<%=item.yjing.ToString("f2")%></span><i><%--（<%=kefang %>%）--%></i></div>
                           </div>
                           <div class="ca-displayfx ca-goto-money"><a href="/Promoter/Generalize/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>"><input type="button" value="去赚钱" class="btn-go-eran"></a></div>
                     </div>
                  </li>
                <% } %>
          </ul>
     </div>
     <!--Sub2 end-->
       <div class="ca-hotel-ext-center Sub2" id="sub3_asc">
          <ul>
              <% 
                  List<hotel3g.Models.FxExtensItem> list3asc = list.OrderBy(a => a.yjing).ToList();
                  foreach (hotel3g.Models.FxExtensItem item in list3asc)
                 { %>
                <li>
                     <div class="ca-safe-distance ca-displayfx">
                           <div class="ca-rooms-pht"><img src="<%=item.imgurl %>"></div>
                           <div class="ca-big-bedroom ca-flex">
                                 <h1><%=item.name%></h1>
                                 <p>会员价：￥<%=item.memberprice.ToString("f2")%></p>
                                 <div class="ca-all-gene"><span>总佣金：</span><span class="ca-f40">￥<%=item.yjing.ToString("f2")%></span><i><%--（<%=kefang %>%）--%></i></div>
                           </div>
                           <div class="ca-displayfx ca-goto-money"><a href="/Promoter/Generalize/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>"><input type="button" value="去赚钱" class="btn-go-eran"></a></div>
                     </div>
                  </li>
                <% } %>
          </ul>
     </div>
       <div class="ca-hotel-ext-center Sub2" id="sub3_desc">
          <ul>
              <% 
                  List<hotel3g.Models.FxExtensItem> list3desc = list.OrderByDescending(a => a.yjing).ToList();
                  foreach (hotel3g.Models.FxExtensItem item in list3desc)
                 { %>
                <li>
                     <div class="ca-safe-distance ca-displayfx">
                           <div class="ca-rooms-pht"><img src="<%=item.imgurl %>"></div>
                           <div class="ca-big-bedroom ca-flex">
                                 <h1><%=item.name%></h1>
                                 <p>会员价：￥<%=item.memberprice.ToString("f2")%></p>
                                 <div class="ca-all-gene"><span>总佣金：</span><span class="ca-f40">￥<%=item.yjing.ToString("f2")%></span><i><%--（<%=kefang %>%）--%></i></div>
                           </div>
                           <div class="ca-displayfx ca-goto-money"><a href="/Promoter/Generalize/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>"><input type="button" value="去赚钱" class="btn-go-eran"></a></div>
                     </div>
                  </li>
                <% } %>
          </ul>
     </div>
     <!--Sub3 end-->
	<script>
	    //切换效果
	    $(function () {
	        $("#sub1").show();
	        $("#sub2_asc,#sub2_desc,#sub3_asc,#sub3_desc").hide();
	    });

	    var sort = '<%=sort %>';
	    function curTab(value) {
	        if (sort == 'desc' || sort == '') {
	            sort = 'asc';
	        } else {
	            sort = 'desc';
	        }
	        //alert(sort);
	        if (value == 1) {
	            $(".cur1").addClass('curTab').siblings().removeClass('curTab');
	            $("#sub1").show();
	            $("#sub2_asc,#sub2_desc,#sub3_asc,#sub3_desc").hide();
	        }
	        if (value == 2) {
	            $(".cur2").addClass('curTab').siblings().removeClass('curTab'); ;
	            if (sort == 'asc') {
	                $("#sub2_asc").show();
	                $("#sub1,#sub2_desc,#sub3_asc,#sub3_desc").hide();
	            } else {
	                $("#sub2_desc").show();
	                $("#sub1,#sub2_asc,#sub3_asc,#sub3_desc").hide();
                }
	        }
	        if (value == 3) {
	            $(".cur3").addClass('curTab').siblings().removeClass('curTab'); ;
	            if (sort == 'asc') {
	                $("#sub3_asc").show();
	                $("#sub1,#sub2_asc,#sub2_desc,#sub3_desc").hide();
	            } else {
	                $("#sub3_desc").show();
	                $("#sub1,#sub2_asc,#sub2_desc,#sub3_asc").hide();
	            }
	        }
	        //	        if (value == 1) {
	        //	            window.location.href = '/MemberFx/FxExtensCenter/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&t=1&s=';
	        //	        }
	        //	        if (value == 2) {
	        //	            window.location.href = '/MemberFx/FxExtensCenter/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&t=2&s=' + sort;
	        //	        }
	        //	        if (value == 3) {
	        //	            window.location.href = '/MemberFx/FxExtensCenter/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&t=3&s=' + sort;
	        //	        }
	    }


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
	        //下拉
	        $(".booking-list>li").on("click", function () {
	            $(this).toggleClass("cur");
	            $(this).find(".slide-bottom").slideToggle(100);
	        })
	        $(".slide-bottom").on("click", function (e) {
	            e.stopPropagation()
	        })
	    })
	</script>
</body>
</html>
