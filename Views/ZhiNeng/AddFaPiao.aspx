<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
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
    <title>添加抬头</title>
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["jsUrl"] %>/css/booklist/mend-reset.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["jsUrl"] %>/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body>
    <!-- <>主体页面 -->
    <article class="full-page">	  
  
		<!--//内容区-->
		<section class="show-body">

        		<section class="content2">
                     <p class="ca-nao-weak">添加抬头</p>
				     <div class="ca-other-goods">
                           <ul>
                                <li class="ca-displayfx"><span><h1>抬头名称</h1><i>*</i></span><input type="text"  value="<%=  ViewData["name"]  %>"  placeholder="请输入抬头名称" id="f_name">
                           </li>
                                <li class="ca-displayfx"><span><h1>企业税号</h1><i>*</i></span><input type="text"   value="<%=  ViewData["taxnum"]  %>"  placeholder="请输入企业税号" id="f_no"></li>
                                <li class="ca-displayfx custum-last-li"><span><h1>联系电话</h1><i>*</i></span><input class="phonenum-input phonenumber"  type="tel" placeholder="请输入联系电话"   value="<%=  ViewData["linktel"]  %>"  /></li> 
                                
                           </ul>
                     </div>
                     <!--ca-other-goods end-->
                     <div class="uc__account-info">
                           <div class="submit-btn sp">
                                <input type="button" class="btn-save" value="提交" />
                           </div>
                     </div>
			</section>
        

        </section>
        </article>
    <% ViewData["key"] = Request.QueryString["key"]; ViewData["hId"] = hotelid; %>
    <% Html.RenderPartial("QuickNavigation", null); %>
    <script>


        //只能输入数字
        $(".phonenum-input").keyup(function () {
            this.value = this.value.replace(/[^\d]/g, '');
        })



        $('.btn-save').click(function () {

            if ($("#f_name").val().trim() == "") {
                layer.msg("请输入抬头名称");
                return false;
            }


            if ($("#f_no").val().trim() == "") {
                layer.msg("请输入企业税号");
                return false;
            }
 

            if ($(".phonenumber").val().trim() == "") {
                layer.msg("请输入联系电话");
                return false;
            }

       

            var phonenumber = $('.phonenumber').val().trim();
            if (!/^1\d{10}$/.test(phonenumber)) {
                layer.msg("请输入正确手机号");
                return false;
            }


            $(".btn-save").attr("disabled", true);

            $.ajax({
                url: '/zhineng/AddEditFaPiao',
                type: 'post',
                data: { hotelId: '<%=hotelid %>', key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', f_name: $("#f_name").val().trim(), phonenumber: $(".phonenumber").val().trim(), f_no: $("#f_no").val().trim(),Id:'<%=Request.QueryString["Id"] %>',uId:'<%=Request.QueryString["uId"] %>'  },
                dataType: 'json',
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {
                        layer.msg(ajaxObj.Mess);
                        setTimeout("window.location.href='/zhineng/fapiaomanager/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>' ", 2000);
                    }

                    else {
                        layer.msg(ajaxObj.Mess);
                        $(".btn-save").attr("disabled", false);
                    }
                }


            });


        });


    </script>
</body>
</html>
