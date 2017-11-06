<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

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
    <title>编辑信息</title>
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="http://css.weikeniu.com/css/booklist/Restaurant.css" />
    <script type="text/javascript" src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script src="http://css.weikeniu.com/Scripts/layer/layer.js" type="text/javascript"></script>
    <script src="http://css.weikeniu.com/Scripts/drag.js" type="text/javascript"></script>
    <script src="http://css.weikeniu.com/Scripts/js.js" type="text/javascript"></script>
</head>
<body>
    <% Html.RenderPartial("AddressUserControl"); %>
    <div class="yu-pad10">
        <input type="button" value="确定" class="blue-sub" id="save2" />
    </div>
</body>
<script>
    $(function () {
        //快速导航
        $(".fix-btn").click(function () {
            $(this).toggleClass("cur").children(".show-hide").toggleClass("cur");
            $(".fix-right-slide").toggle();
        })


        $("#save").on("click", function () {
            var name = $('#LinkMan').val();
            var phone = $('#LinkPhone').val();
            var address = $("#address").val();
            var room = $('#RoomNo').val();

            var kdaddress = $('#kdaddress').val(); //快递地址

            var type = $("#address-type").val();

            var f = validate();
            if (f) {
                var parm = "&type=" + type + "&kdaddress=" + kdaddress + "&address=" + address + "&name=" + name + "&phone=" + phone + "&room=" + room;
                $.post('/DishOrder/SaveAddress/<%=Html.ViewData["hId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>&userweixinid=<%=ViewData["userweixinid"] %>&orderCode=<%=ViewData["orderCode"] %>' + parm, function (data) {
                    if (data.error == 1) {
                        //                        window.location = "/Supermarket/OrderDetails/<%=ViewData["hotelId"] %>?key=<%=ViewData["weixinid"] %>@<%=ViewData["userweixinid"] %>";
                        location.href = document.referrer;
                    } else {
                        layer.msg(data.message);
                        return false;
                    }
                });
            } else {
                //layer.msg("验证不通过！");
            }



        });
        $("#save2").on("click", function () {
            var name = $('#LinkMan').val();
            var phone = $('#LinkPhone').val();
            var address = $("#address").val();
            var room = $('#RoomNo').val();

            var kdaddress = $('#kdaddress').val(); //快递地址

            var type = $("#address-type").val();
            var typeName = "酒店";
            if (type * 1 == 2) {
                typeName = "快递";
            }

            localStorage.supermarkAddressLinkMan = name;
            localStorage.supermarkAddressLinkPhone = phone;
            localStorage.supermarkAddressAddress = address;
            localStorage.supermarkAddressRoomNo = room;
            localStorage.supermarkAddresskdaddress = kdaddress;
            localStorage.supermarkAddresstype = type;
            localStorage.supermarkAddresstypeName = typeName;
                        location.href = document.referrer;
//            self.opener.location.reload();
        });
    });

</script>
</html>
