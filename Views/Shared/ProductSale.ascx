<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%
    string hotelweixinId = ViewData["weixinID"] != null ? ViewData["weixinID"].ToString() : "";

    string userWeiXinID = ViewData["uwx"] != null ? ViewData["uwx"].ToString() : "";

 

    // string keySign = string.Format("{0}@{1}@{2}", hotelweixinId, userWeiXinID, WeiXin.Common.ValidateSignProduct.GenerateSign(hotelweixinId, userWeiXinID));

    string keySign = string.Format("{0}@{1}", hotelweixinId, userWeiXinID);
    int saleProduct = 0;
    bool lxr = WeiXin.Common.NormalCommon.IsLXSDoMain();

    if (lxr == false)
    {
        if (!string.IsNullOrEmpty(hotelweixinId))
        {
            saleProduct = WeiXin.Models.Home.StatisticsCount.GetStatisticsSaleProductCount(hotelweixinId);
        }
    } 
%>
<% if (lxr == false)
   { %>
<div id="productlist" style="display: none">
    <ul id="ul_producttitle" class="rooms-list sp">
        <li>
            <div class="room-content-head yu-grid noarr">
                <div class="yu-overflow">
                    <div class="room-name text-ell yu-line30">
                        <span class="iconfont icon-tehui yu-blue yu-f26r"></span>抢购</div>
                </div>
                <a href="/Product/productList/<%=ViewData["hId"] %>?key=<%=ViewData["weixinID"] %>@<%=ViewData["uwx"] %>"
                    class="a_more yu-blue yu-line30 yu-rmar20" style="display: none;">更多></a>
            </div>
        </li>
    </ul>

 

    <ul id="ul_productlist" class='rooms-list sp2'>
    </ul>
</div>
<script>


    $(function () {

        var saleproduct = '<%=saleProduct%>';
        if (parseInt(saleproduct) > 0) {

            GetMoreData();
        }


        else {

            if ($("div").hasClass("hotel-img-box") && window.location.href.toLowerCase().indexOf("/home/main") > 0) {

                $(".hotel-img-box").css("height", "200px");
            }
        }
    });


    function GetMoreData() {

        var el = document.getElementById('ul_productlist');
        var myLi = new Array();

        var tmp = {
            page: 1,
            key: '<%=keySign%>'
        };

        $.ajax({
            data: tmp,
            url: '/Product/FetchProductIndexList',
            dataType: 'json',
            async: false
        }).done(function (data) {
            if (data) {
                var html = '';

                if (data.pagesum > data.page) {

                    $(".a_more").css("display", "");
                }

                if (data.data) {

                    if (data.data.length == 0) {

                        if ($("div").hasClass("hotel-img-box") && window.location.href.toLowerCase().indexOf("/home/main") > 0) {

                            $(".hotel-img-box").css("height", "200px");
                        }
                    }

                    else {
                        $("#productlist").css("display", "");

                    }

                    for (var i = 0, l = data.data.length; i < l; i++) {

                        var href = "";
                        var i_qr = "";
                        if (data.data[i].ProductType == 0) {
                            href = '/Product/ProductDetail/<%=ViewData["hId"] %>?key=<%=keySign%>&ProductId=' + data.data[i].Id;
                            //  i_qr = '<span class="babel type3">团购</span>';
                        }

                        else {

                            href = '/Product/ProductDetail/<%=ViewData["hId"]%>?key=<%=keySign%>&ProductId=' + data.data[i].Id;
                            // i_qr = '<span class="babel type2">预售</span> <span class="babel type1">立即确认</span>';
                        }



                        var html = '<a href="' + href + '" class="yu-c11"> ' +
                                    ' <div class="room-content-head yu-grid tgth yu-h120r">' +
                                   '<div class="room-pic yu-rmar30r"><img src="' + data.data[i].Image + '" /> </div>' +
                                   '<div class="yu-overflow">' +
                                   ' <div class="room-name  yu-h70r yu-overflow yu-f26r yu-rpad65r yu-bmar10r">' + data.data[i].ProductName + '</div>' +
                                     ' <div class="yu-c60">' +
                                    '  <span class="yu-f24r">￥</span> <span class="yu-f40r yu-arial">' + data.data[i].MinPrice + '</span>' +
                                       '</div>' +
                                        '</div>' +
                                          '</div>' +
                                         '</a>';
                        myLi.push(html);
                    }
                }
            }
        });


        for (i = 0; i < myLi.length; i++) {
            li = document.createElement('li');
            li.innerHTML = myLi[i];
            el.appendChild(li);
        }

    }



    
           
           
</script>
<%}
   else
   { %>
<script>

    $(function () {
        if ($("div").hasClass("hotel-img-box") && window.location.href.toLowerCase().indexOf("/home/main") > 0) {

            $(".hotel-img-box").css("height", "200px");
        }

    });

</script>
<%} %>