<!DOCTYPE html>
<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
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
    <title>编辑信息</title>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/sale-date.css"/>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/Restaurant.css"/>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/drag.js" type="text/javascript"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/js.js" type="text/javascript"></script>
    <style>
        .cross{ display:none;}
    </style>
</head>
<body>
    <% 
        bool iszbsj = HotelCloud.Common.HCRequest.GetString("iszbsj").ToLower() == "true";
        
        // 1 旅行社版本
        int istravel = WeiXin.Common.NormalCommon.IsLXSDoMain() ? 1 : 0;
        
        int openaddress = (int)ViewData["openaddress"];
        if (istravel == 1)//旅行社
        {
            Html.RenderPartial("AddressUserControlTravel");//旅行社地址[联系人，电话,地址]
        }
        else //酒店
        {
            if (openaddress == 1)//酒店关闭地址设置
            {
                Html.RenderPartial("AddressUserControlZBSJ");//使用新的地址[只有联系人，电话]
            }
            else
            {
                Html.RenderPartial("AddressUserControl");
            }
        }
         %>
    <div class="yu-pad10">
		<input type="button" value="确定" class="blue-sub" id="save"/>
	</div>
     <!--快速导航-->
     <% Html.RenderPartial("QuickNavigation", null); %>
	
<% 
     string key = ViewData["key"] + "";
     string hotelweixinid = key.ToLower().Split('@')[0];
    %>
<script>
    $(function () {
        //gh_1cfa5d6bd23b // 奇葩酒店要求只能在酒店用餐20170607  [下一站天后主题酒店]
        var hotelweixinid='<%=hotelweixinid %>';
        if(hotelweixinid=='gh_1cfa5d6bd23b'){
        $("#kdaddress").val('');
        $('#address-type').val(1);
        $(".kuaidi-address").hide();
        $(".dish-address").show();
        $("#rdo1").attr("checked", true);
        $("#rdo2").attr("checked", false);
        $("#rdo1").parent().addClass("cur");
        $("#rdo2").parent().removeClass("cur");
        $('#otheraddressid').hide();//隐藏其他选择

        //姓名选择，都只显示酒店
        $(".name-select").children("p").on("click", function () {
            $(this).addClass("cur").siblings("p").removeClass("cur");
            $(".name-input").parent().siblings(".close-type1").fadeIn();

            $(".name-input").val($(this).children(".lm").val());
            $("#LinkPhone").val($(this).children(".ph").val());
            $("#code_phone").val($(this).children(".ph").val());
            
            $("#address-type").val(1);
            $("#RoomNo").val($(this).children(".rm").val());
            $("#kdaddress").val('');

            $(".kuaidi-address").hide();
            $(".dish-address").show();
            $("#rdo1").attr("checked", true);
            $("#rdo2").attr("checked", false);
            $("#rdo1").parent().addClass("cur");
            $("#rdo2").parent().removeClass("cur");

            $("#btn-getvalicode,#div-validate-code").addClass("cross");
        })

        }


        $("#save").on("click", function () {
            var name = $('#LinkMan').val();
            var phone = $('#LinkPhone').val();
            var address=$("#address").val();
            var room = $('#RoomNo').val();

            var kdaddress=$('#kdaddress').val();//快递地址
            
            var type=$("#address-type").val();

           var f=validate();
           if(f){
               var parm = "&type="+type+"&kdaddress="+kdaddress+"&address="+address+"&name=" + name + "&phone=" + phone + "&room=" + room+"&source=canyin";
                $.post('/DishOrder/SaveAddress/<%=Html.ViewData["hId"] %>?userweixinid=<%=ViewData["userweixinid"] %>&orderCode=<%=ViewData["orderCode"] %>' + parm, function (data) {
                    if (data.error == 1) {
                        window.location = "/DishOrder/PagePay/<%=Html.ViewData["hId"] %>?orderCode=<%=ViewData["orderCode"] %>&key=<%=ViewData["key"] %>&storeId=<%=ViewData["storeId"] %>";
                    } else {
                            layer.msg(data.message);
                        return false;
                    }
                });
            }else{
               //layer.msg("验证不通过！");
            }

            

        });
    });

     
      
      

//      function yz(v){
//        var a = '/^((//(//d{3}//))|(//d{3}//-))?13//d{9}|15[89]//d{8}$/' ;
//            if( v.length!=11||!v.match(a) ){
//                alert("请输入正确的手机号码");
//            }
//        } 

</script>
<script type="text/javascript">
    function validate() {

        var name = $('#LinkMan').val();
        var phone = $('#LinkPhone').val();
        var address = $("#address").val();
        var room = $('#RoomNo').val();

        var kdaddress = $('#kdaddress').val(); //快递地址
        var c1 = $("#valiCode").val();
        var c2 = $("#code_msg").val();

        var type = $("#address-type").val();
        if (type == "1") {
            if (name != '' && phone != '') {//酒店
                var h = $("#btn-getvalicode").hasClass("cross");
                if (!h && c1 == "") { return false; }
                if (c1 != c2 && !h) {
                    if (c2 == '123abc') {
                        layer.msg("验证码无效，请重新获取验证码！");
                    } else {
                        layer.msg("请输入正确的验证码！");
                    }
                    return false;
                }
                var p = $("#code_phone").val();
                if (phone != p && !h) {
                    layer.msg("手机号与验证手机号不一致！");
                    return false;
                }
            } else {
                layer.msg("请填写联系人/电话 ！");
                return false;
            }
        }
        else if (type == "2") {
            if (name != '' && phone != ''&& type == "2") {//快递
                var h = $("#btn-getvalicode").hasClass("cross");
                if (!h && c1 == "") { return false; }
                if (c1 != c2 && !h) {
                    if (c2 == '123abc') {
                        layer.msg("验证码无效，请重新获取验证码！");
                    } else {
                        layer.msg("请输入正确的验证码！");
                    }
                    return false;
                }
                var p = $("#code_phone").val();
                if (phone != p && !h) {
                    layer.msg("手机号与验证手机号不一致！");
                    return false;
                }
                //旅行社/开启地址的酒店，地址必填
               <% if((openaddress==0)||istravel == 1){ %>
               if(kdaddress==''){
                   layer.msg("请填写地址！");
                    return false;
               }
               <%} %>

            } else {
                layer.msg("请填写联系人/电话！");
                return false;
            }
        } else {
            layer.msg("请填选择收货地址！");
            return false;
        }

        return true;
    }
</script>
</body>
</html>
