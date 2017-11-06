<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% var producdtList = ViewData["products"] as List<WeiXin.Common.ProductEntity>;
   int page = Convert.ToInt32(ViewData["page"]);
   int pagesum = Convert.ToInt32(ViewData["pagesum"]);

   string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
   string hotelid = RouteData.Values["id"].ToString();

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


   ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
   ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
    <title>团购预售产品列表</title>
    <link href="<%=ViewData["cssUrl"] %>/Content/ProductIndex/productIndex.css?v=1.2"
        rel="stylesheet" type="text/css" />
    <script src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <link href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css?v=1.0" rel="stylesheet"
        type="text/css" />
    <link href="<%=ViewData["cssUrl"] %>/Content/ProductIndex/ProductList.css" rel="stylesheet"
        type="text/css" />
    <link href="../../css/booklist/iconfont/iconfont.css?v=1.0" rel="stylesheet" type="text/css" />
    <script src="<%=ViewData["jsUrl"] %>/Content/ProductIndex/iscroll.js" type="text/javascript"></script>
</head>
<body>
    <div class="base-page list2">
        <div id="wrapper">
            <div id="scroller">
                <div id="pullDown" style="display: none">
                    <span class="pullDownIcon"></span><span class="pullDownLabel">下拉刷新...</span>
                </div>
                <ul class="rooms-list sp" id="thelist">
                    <% foreach (var item in producdtList)
                       {
                           string href = item.ProductType == "0" ? "/Product/ProductIndexGroup/" + hotelid + "?key=" + ViewData["key"] + "&Id=" + item.Id : "/Product/ProductIndex/" + hotelid + "?key=" + ViewData["key"] + "&Id=" + item.Id;
                   
                    %>
                    <li><a href="<%=href %>">
                        <div class="room-content-head yu-grid">
                            <div class="room-pic <%=item.ProductType=="0"  ? "tuan" : "yu"%>">
                                <img src="<%=item.Image %>" />
                            </div>
                            <div class="yu-overflow">
                                <div class="room-name">
                                    <%=item.ProductName%></div>
                                <div class="yu-bmar10">
                                    <i class="yu-font14 yu-orange">￥<%=item.MinPrice%>
                                    </i><i class="yu-font12 yu-grey yu-linethrough"></i>
                                </div>
                                <%  if (item.ProductType == "1")
                                    {%>
                                <i class="yu-mark yu-font12 yu-orange">立即确认</i>
                                <%} %>
                                <div>
                                    <span class="yu-font12 yu-grey">
                                        <%  if (item.ProductType == "0")
                                            { %>
                                        结束日期:<%=item.EndTime%>
                                        <%} %>
                                    </span>
                                </div>
                                <p class="yu-font12 yu-grey yu-line26">
                                </p>
                            </div>
                            <div class="yu-btn yu-tmar30">
                                查看详情</div>
                        </div>
                    </a></li>
                    <%   }%>
                </ul>
                <div id="pullUp">
                    <span class="pullUpIcon"></span><span class="pullUpLabel">上拉加载更多...</span>
                </div>
                <div class="no-more-row" style="display: none">
                    <div class="border">
                    </div>
                    <p>
                        没有数据了</p>
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" id="cur_page" value="<%=page%>" />
    <%Html.RenderPartial("Footer", viewDic); %>
    <script type="text/javascript">
        var myLis = '<li><a href="#"><div class="room-content-head yu-grid"><div class="room-pic tuan"><img src="images/room_03.png" /></div><div class="yu-overflow"><div class="room-name">标准双床房UP</div><div><i class="yu-font14 yu-orange">￥168</i><i class="yu-font12 yu-grey yu-linethrough">￥199</i></div><div ><span class="yu-font12 yu-grey">15㎡ 双床1.2m 无窗 有wifi15㎡ 双床</span></div><p class=" yu-font12 yu-grey yu-line26"><i class="iconfont yu-yellow">&#xe601;</i><i class="iconfont yu-yellow">&#xe60a;</i><i class="iconfont yu-yellow">&#xe612;</i><i class="iconfont yu-yellow">&#xe613;</i></p></div><div class="yu-btn yu-tmar30">查看详情</div></div></a></li>';
        var myLis2 = '<li><a href="#"><div class="room-content-head yu-grid"><div class="room-pic tuan"><img src="images/room_03.png" /></div><div class="yu-overflow"><div class="room-name">标准双床房DOWN</div><div><i class="yu-font14 yu-orange">￥168</i><i class="yu-font12 yu-grey yu-linethrough">￥199</i></div><div ><span class="yu-font12 yu-grey">15㎡ 双床1.2m 无窗 有wifi15㎡ 双床</span></div><p class=" yu-font12 yu-grey yu-line26"><i class="iconfont yu-yellow">&#xe601;</i><i class="iconfont yu-yellow">&#xe60a;</i><i class="iconfont yu-yellow">&#xe612;</i><i class="iconfont yu-yellow">&#xe613;</i></p></div><div class="yu-btn yu-tmar30">查看详情</div></div></a></li>';

        var myLi = new Array();

        var page_num = <%=page%>;
          var pagesum = <%=pagesum%>;

        var myScroll,
 pullDownEl, pullDownOffset,
 pullUpEl, pullUpOffset,
 generatedCount = 0;

        /**
        * 下拉刷新 （自定义实现此方法）
        * myScroll.refresh();  // 数据加载完成后，调用界面更新方法
        */
        function pullDownAction() {

            myScroll.refresh();
            return false;

            setTimeout(function () { // <-- Simulate network congestion, remove setTimeout from production!
                var el, li, i;
                el = document.getElementById('thelist');

                for (i = 0; i < myLi.length; i++) {
                    li = document.createElement('li');
                    // li.innerText = '添加三冰 ' + (++generatedCount);
                    li.innerHTML = myLi[i];

                    el.insertBefore(li, el.childNodes[0]);
                }

                myScroll.refresh();  //数据加载完成后，调用界面更新方法 Remember to refresh when contents are loaded (ie: on ajax completion)
            }, 1000); // <-- Simulate network congestion, remove setTimeout from production!
        }

        /**
        * 滚动翻页 （自定义实现此方法）
        * myScroll.refresh();  // 数据加载完成后，调用界面更新方法
        */
        function pullUpAction() {

            GetMoreData();
            setTimeout(function () { // <-- Simulate network congestion, remove setTimeout from production!
                var el, li, i;
                el = document.getElementById('thelist');

                for (i = 0; i < myLi.length; i++) {
                    li = document.createElement('li');
                    // li.innerText = '添加三冰 ' + (++generatedCount);
                    li.innerHTML = myLi[i];
                    el.appendChild(li);

                   // $(li).bind("click", GoClick);
                }


                myScroll.refresh();  // 数据加载完成后，调用界面更新方法 Remember to refresh when contents are loaded (ie: on ajax completion)

                if (myLi.length == 0   || page_num==pagesum) {

                    $("#pullUp").hide();
                    $(".no-more-row").show();
                }

            }, 1000);      // <-- Simulate network congestion, remove setTimeout from production!




        }

        /**
        * 初始化iScroll控件
        */
        function loaded() {
            pullDownEl = document.getElementById('pullDown');
            pullDownOffset = pullDownEl.offsetHeight;
            pullUpEl = document.getElementById('pullUp');
            pullUpOffset = pullUpEl.offsetHeight;

            myScroll = new iScroll('wrapper', {
                scrollbarClass: 'myScrollbar', /* 重要样式 */
                useTransition: false, /* 此属性不知用意，本人从true改为false */
                topOffset: pullDownOffset,
                onRefresh: function () {
                    if (pullDownEl.className.match('loading')) {
                        pullDownEl.className = '';

                        pullDownEl.querySelector('.pullDownLabel').innerHTML = '下拉刷新...';
                    } else if (pullUpEl.className.match('loading')) {

                        pullUpEl.className = '';
                        pullUpEl.querySelector('.pullUpLabel').innerHTML = '上拉加载更多...';
                    }
                },
                onScrollMove: function () {
                    if (this.y > 5 && !pullDownEl.className.match('flip')) {
                        pullDownEl.className = 'flip';
                        pullDownEl.querySelector('.pullDownLabel').innerHTML = '松手开始更新...';
                        this.minScrollY = 0;
                    } else if (this.y < 5 && pullDownEl.className.match('flip')) {

                        pullDownEl.className = '';
                        pullDownEl.querySelector('.pullDownLabel').innerHTML = '下拉刷新...';
                        this.minScrollY = -pullDownOffset;
                    } else if (this.y < (this.maxScrollY - 5) && !pullUpEl.className.match('flip')) {
                        pullUpEl.className = 'flip';
                        pullUpEl.querySelector('.pullUpLabel').innerHTML = '松手开始更新...';
                        this.maxScrollY = this.maxScrollY;
                    } else if (this.y > (this.maxScrollY + 5) && pullUpEl.className.match('flip')) {
                        pullUpEl.className = '';
                        pullUpEl.querySelector('.pullUpLabel').innerHTML = '上拉加载更多...';
                        this.maxScrollY = pullUpOffset;
                    }
                },
                onScrollEnd: function () {
                    if (pullDownEl.className.match('flip')) {
                        pullDownEl.className = 'loading';
                        pullDownEl.querySelector('.pullDownLabel').innerHTML = '加载中...';
                        pullDownAction(); // Execute custom function (ajax call?)
                    } else if (pullUpEl.className.match('flip')) {
                        pullUpEl.className = 'loading';
                        pullUpEl.querySelector('.pullUpLabel').innerHTML = '加载中...';
                        pullUpAction(); // Execute custom function (ajax call?)
                    }
                }
            });

            setTimeout(function () { document.getElementById('wrapper').style.left = '0'; }, 800);
        }

        //初始化绑定iScroll控件 
        document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
        document.addEventListener('DOMContentLoaded', loaded, false);


        $(function () {

         if( pagesum  <=1)
        {
           $("#pullUp").hide();
             $(".no-more-row").show();
        }      

            $("#wrapper").height($(window).height())
        })




        function GetMoreData() {

            myLi = new Array();

            var tmp = {
                // page: parseInt($("#cur_page").val()) + 1
                page: parseInt(page_num) + 1,
                key: '<%=ViewData["key"]%>'
            };

            $.ajax({
                data: tmp,
                url: '/Product/FetchProductList',
                dataType: 'json',
                async: false
            }).done(function (data) {
                if (data) {
                    var html = '';
                    if (data.data) {
                        for (var i = 0, l = data.data.length; i < l; i++) {
                            var href = "";
                            var endTime = "";
                            var class_tuan = "";
                            var i_qr="";
                            if (data.data[i].ProductType == 0) {
                                href = '/Product/ProductIndexGroup/<%=hotelid%>?key=<%=ViewData["key"]%>&Id=' + data.data[i].Id;
                                class_tuan = "tuan";
                                endTime ="结束日期:"+ data.data[i].EndTime;
                            }

                            else {
                               i_qr="<i class='yu-mark yu-font12 yu-orange'>立即确认</i>";
                              href = '/Product/ProductIndex/<%=hotelid%>?key=<%=ViewData["key"]%>&Id=' + data.data[i].Id;
                                class_tuan = "yu";
                            }



                            var html = '<a href="' + href + '"> ' +
                                    '<div class="room-content-head yu-grid">' +
                                   '<div class="room-pic ' + class_tuan + '"><img src="' + data.data[i].Image + '" /> </div>' +
                                   '<div class="yu-overflow">' +
                                   ' <div class="room-name">' + data.data[i].ProductName + '</div>' +
                                      '<div class="yu-bmar10"><i class="yu-font14 yu-orange">￥' + data.data[i].MinPrice + '</i><i class="yu-font12 yu-grey yu-linethrough"></i></div>' +
                                      ' <div> '+i_qr+'<span class="yu-font12 yu-grey">' + endTime + '</span></div>' +
                                      '<p class="yu-font12 yu-grey yu-line26">' +                                      
                                        '</p>' +
                                       '</div>' +
                                       ' <div class="yu-btn yu-tmar30">    查看详情</div> ' +
                                       '  </div>' +
                                       '</a>';

                            myLi.push(html);
                        }

                        if (myLi.length > 0) {

                            $('#cur_page').val(data.page);
                             page_num = data.page;
                             pagesum=data.pagesum;

                        } 
                        
                                     

                    }
                }
            });

        }


        $(function () {
            $("#thelist li").bind("click", GoClick);


            if ($("#thelist li").length == 0) {
                $("#pullUp").css("display", "none");

                $(".no-more-row").css("display", "");
            }

        });

        function GoClick() {

            //  $('#cur_page').val(1);
        }      
          
        
      

    </script>
</body>
<%Html.RenderPartial("JS"); %>
</html>
