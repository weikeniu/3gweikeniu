<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% 
    var products = ViewData["products"] as WeiXin.Models.Home.SaleProduct;
    ViewData["productName"] = products.ProductName;


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
     <title><% = ViewData["productName"]  %> </title> 
    <link href="<%=ViewData["cssUrl"]%>/swiper/swiper-3.4.1.min.css?v=1.0" rel="stylesheet"
        type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/productIndex.css?v=1.1" rel="stylesheet" type="text/css" />
    <link href="<%=ViewData["cssUrl"]%>/Content/ProductIndex/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="<%=ViewData["jsUrl"]%>/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <script src="<%=ViewData["jsUrl"]%>/Content/ProductIndex/jquery-ui.js" type="text/javascript"></script>
    <script src="<%=ViewData["jsUrl"]%>/swiper/swiper-3.4.1.jquery.min.js" type="text/javascript"></script>
</head>
<body>
    <!--详情页内容-->
    <div class="base-page">
        <div id="main">
            <div class="hotel-img-box swiper-container swiper-container-horizontal">
                <div class="swiper-wrapper">
                    <% int picCount = 0; %>
                    <%
                                                
                        string picList = string.IsNullOrEmpty(products.BigImageList) ? products.ImageList : products.BigImageList;
                        int djs = products.BeginTime > DateTime.Now ? 1 : 0;



                        if (picList != null)
                        {
                            picCount = picList.Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries).Length;

                            for (int i = 0; i < picCount; i++)
                            {
                    %>
                    <div class="swiper-slide">
                        <img src="<%=picList.Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries)[i] %>" />
                    </div>
                    <% 
}
                        }%>
                </div>
                
                <div class="mask-bg img-info">
                    <p class="fl">
                      </p>
                    <p class="fr">
                        <span class="num">
                            <%=picCount%></span>张</p>
                </div>
            </div>
            <ul class="hotel-info">
                <li class="sp">
                    <div class="hotel-add">
                        <%=products.ProductName%>
                    </div>
                    <p class="orange">
                        ￥<span class="tcPrice">
                            <% if (products.List_SaleProducts_TC != null && products.List_SaleProducts_TC.Count > 0)
                               { %>
                            <%= Convert.ToDouble(products.List_SaleProducts_TC[0].ProductPrice)%>
                            <%} %>
                        </span>
                    </p>
                </li>
            </ul>
            <div class="rooms-list-box">
                <ul>
                </ul>
            </div>
            <div class="tc-box yu-tmar10 yu-textc yu-red" style="font-size: 16px">
                <span id="t_txt">剩余结束时间：</span><span id="t_d">00天</span> <span id="t_h">00时</span>
                <span id="t_m">00分</span> <span id="t_s">00秒</span>
            </div>
            <div class="tc-box yu-tmar10">
                <!-- <h3>套餐类型</h3> -->
                <ul class="tc_ul">
                    <% int stock = 50; %>
                    <%  if (products.List_SaleProducts_TC != null)
                        {
                            for (int i = 0; i < products.List_SaleProducts_TC.Count; i++)
                            {

                                if (i == 0)
                                {
                                    stock = products.List_SaleProducts_TC[i].ProductNum;

                                }                                            
                                
                    %>
                    <li class="text-ell <%=i==0 ? "cur" : "" %>">
                        <%=products.List_SaleProducts_TC[i].TcName%>
                    </li>
                    <% }

                        } %>
                </ul>
            </div>
            <div class="tc-box">
                <h3>
                    购买数量</h3>
                <div class="buy-num">
                    <span class="sy jian">-</span>
                    <input type="text" class="buy-num-input" value="1">
                    <span class="sy jia">+</span>
                </div>
                <p class="Stock">
                    库存<span><%=stock%></span>件</p>
            </div>
            <div class="tc-details">
                <ul class="tab">
                    <li class="cur">套餐详情</li>
                    <li>图文介绍</li>
                </ul>
                <div class="tab-box cur">
                    <section class="section">
        <h3>有效期</h3>
          <div class="clear"></div>
          <div class="abstract">
            <%=products.EffectiveBeginTime.ToString("yyyy-MM-dd")%> 至  <%=products.EffectiveEndTime.ToString("yyyy-MM-dd")%> 
          </div>
       </section>
                    <section class="section">
        <h3>费用包含</h3>
          <div class="clear"></div>
          <div class="abstract">
            <%=products.FeeInclude%>
          </div>
       </section>
                    <section class="section">
        <h3>费用不含</h3>
          <div class="clear"></div>
          <div class="abstract">
                   <%=products.FeeExclude%>
          </div>
       </section>
                    <section class="section">
        <h3>预定须知</h3>
          <div class="clear"></div>
          <ul class="abstract">
           <%=products.OrderInfo%> 
          </ul>
       </section>
                    <section class="section">
        <h3>退款规则</h3>
          <div class="clear"></div>
          <div class="abstract">
             <%=products.RefundInfo%> 
          </div>
       </section>
                </div>
                <div class="tab-box">
                    <%=products.DetailDes%>
                </div>
                <div class="tab-box">
                    <br />
                    <br />
                    <br />
                    <br />
                </div>
            </div>
        </div>
        <div class="buy-btn">
            立即购买</div>
        <!--详情页内容end-->
    </div>
    <!--end-->
    <script type="text/javascript">

        var jsonTc = '<%=products.Json_SaleProducts_TC %>';
        var arr_Tc = new Array();



        var swiper = new Swiper('.swiper-container', {
            pagination: '.swiper-pagination',
            paginationClickable: true,
            autoplay: 2500,
            autoplayDisableOnInteraction: false,
            loop: true
        });



        $(function () {

            if (jsonTc != "") {
                for (var i = 0; i < $.parseJSON(jsonTc).length; i++) {
                    arr_Tc.push($.parseJSON(jsonTc)[i]);
                }
            }

            $(".tc-box .tc_ul  li").on("click", function () {

                $(this).addClass("cur").siblings().removeClass("cur");
                $(".tcPrice").text(arr_Tc[$(this).index()].ProductPrice);

                $(".Stock span").text(arr_Tc[$(this).index()].ProductNum);

            });
        });



        $(function () {


            $(".tc_ul li").on("click", function () {
                $(this).addClass("cur").siblings().removeClass("cur");
            });

            $(".rooms-date-change").click(function () {

                if (!$(this).hasClass("sp")) {
                    $(".base-page").hide();
                    $(".select-page").show();
                } else {

                    $(".select-page").hide();
                    $(".date-page").show();
                }
            });
            $(".date-page .back").click(function () {
                $(".select-page").show();
                $(".date-page").hide();
            });
            $(".select-page .back").click(function () {
                $(".select-page").hide();
                $(".base-page").show();
            });

            $(".ui-state-default").mouseenter(function () {
            })
            var tabIndex;
            $(".tab").on("click", "li", function () {
                $(this).addClass("cur").siblings().removeClass("cur");
                tabIndex = $(this).index();
                $(".tab-box").eq(tabIndex).addClass("cur").siblings(".tab-box").removeClass("cur");
            })
        })





        var pNum = parseInt($(".buy-num-input").val());
        $(".sy").on("click", function () {
            if ($(this).hasClass("jia")) {


                if ((pNum + 1) > parseInt($(".Stock span").text())) {
                    return false;
                }

                pNum++;
                $(".buy-num-input").val(pNum);
                console.log(pNum)
            } else if ($(this).hasClass("jian") && pNum > 1) {
                pNum--;
                $(".buy-num-input").val(pNum);
                console.log(pNum)
            };
        })





        $(".buy-btn").click(function () {

            if (parseInt($(".buy-num-input").val()) > parseInt($(".Stock span").text())) {
                alert("不能大于库存");
                return false;
            }

            window.location.href = '/Product/ProductConfirmOrder/<%=hotelid%>?key=<%=ViewData["key"]%>&ProductId=<%=Request.QueryString["Id"]%>&tcId=' + arr_Tc[$(".tc_ul").find(".cur").index()].Id + '&buyAmount=' + $(".buy-num-input").val() + '&date=';

        });


    </script>
    <script>
                
        var beginrefresh=0;
        var djs=<%=djs%>;

        function GetRTime() {
            var EndTime = new Date('<%=products.EndTime%>');
            if(djs==1)
            {
               EndTime = new Date('<%=products.BeginTime%>');
               $("#t_txt").text("距离开始日期:");
               $(".buy-btn").css("display","none");

               $("body").css("padding-bottom","0");
            }


            var NowTime = new Date();
            var t = EndTime.getTime() - NowTime.getTime();
            var d = 0;
            var h = 0;
            var m = 0;
            var s = 0;
            if (t >= 0) {
                d = Math.floor(t / 1000 / 60 / 60 / 24);
                h = Math.floor(t / 1000 / 60 / 60 % 24);
                m = Math.floor(t / 1000 / 60 % 60);
                s = Math.floor(t / 1000 % 60);
            }

             else  
            {
                window.clearTimeout(timer1); 

                if(djs==1 && beginrefresh==0)
                {             
                     beginrefresh=1;

                   setTimeout('window.location.href=window.location.href',2000);       
                  
               }
            }      

            document.getElementById("t_d").innerHTML = d + "天";
            document.getElementById("t_h").innerHTML = h + "时";
            document.getElementById("t_m").innerHTML = m + "分";
            document.getElementById("t_s").innerHTML = s + "秒";
        }
       var timer1= setInterval(GetRTime, 0);
    </script>
</body>
</html>
