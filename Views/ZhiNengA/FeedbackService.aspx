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
    <meta charset="UTF-8" />
    <title>宾客反馈</title>
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
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body>
    <!-- <>主体页面 -->
    <article class="full-page">	  
		 <%Html.RenderPartial("HeaderA", viewDic);%>
		<!--//内容区-->
		<section class="show-body">
			<section class="content2">
                     <p class="ca-nao-weak">宾客反馈</p>
				     <div class="ca-other-goods">
                           <ul>
                                <li class="ca-displayfx "><span><h1>宾客姓名</h1><i>*</i></span><input type="text" placeholder="请输入您的名字"  id="username"   /></li>
                                <li class="ca-displayfx"><span><h1>房号</h1><i>*</i></span><input type="text" placeholder="房间号" id="roomno" /></li>
                                <li class="ca-displayfx"><span><h1>手机号</h1><i>*</i></span><input type="tel" placeholder="手机号" maxlength="11" class="phonenum-input phonenumber" /></li> 
                           </ul>
                          
                     </div>

                           <!--ca-other-goods end-->
                     <div class="ca-bk-feedback">
                          <div class="ca-safe-distance">
                               <h2>1.您是否受到酒店周到的服务？</h2>
                               <textarea placeholder="说说您的感受" id="hotelservice"></textarea>
                          </div>
                          <!--ca-safe-distance end-->
                     </div>
                     <!--ca-bk-feedback end-->
                     <div class="ca-bk-feedback">
                          <div class="ca-safe-distance">
                               <h2>2.在您入住期间，您最满意的是什么？</h2>
                               <textarea placeholder="说说您最满意的地方" id="bestmanyi"></textarea>
                          </div>
                          <!--ca-safe-distance end-->
                     </div>
                     <!--ca-bk-feedback end-->
                     <div class="ca-bk-feedback">
                          <div class="ca-safe-distance">
                               <h2>3.我们如何能提高您的整体满意度？</h2>
                               <textarea placeholder="说说还有那些不满意的地方" id="bestbumanyi"></textarea>
                          </div>
                          <!--ca-safe-distance end-->
                     </div>
                     <!--ca-bk-feedback end-->
                     <div class="ca-bk-feedback">
                          <div class="ca-safe-distance">
                               <h2>4.您会再度光临<%=ViewData["hotel"]%>吗？</h2>
                               <div class="ca-come-agin again-hotel">
                                    <ul class="ca-displayfx">
                                        <li class="flex1"><em><b></b></em><span>肯定会</span></li>
                                        <li class="flex1"><em><b></b></em><span>也许会</span></li>
                                        <li class="flex1"><em><b></b></em><span>肯定不会</span></li>
                                    </ul>
                               </div>
                          </div>
                          <!--ca-safe-distance end-->
                     </div>
                     <!--ca-bk-feedback end-->
                     <div class="ca-bk-feedback">
                          <div class="ca-safe-distance">
                               <h2>5.您的其它宝贵意见和建议：</h2>
                               <textarea placeholder="说说其它意见跟建议" id="otheryijian" ></textarea>
                          </div>
                          <!--ca-safe-distance end-->
                     </div>
                     <!--ca-bk-feedback end-->
                     <div class="ca-thinks-feedback">谢谢您的反馈</div>


                     <!--ca-other-goods end-->
                     <div class="uc__account-info">
                           <div class="submit-btn sp">
                                <input type="button" class="btn-save" value="提交" />
                           </div>
                     </div>
			</section>
		</section>
		<!--弹窗-->	
      
	</article>
     <script type="text/javascript">

        $(".ca-come-agin li").click(function () {
            $(this).addClass("curren");
            $(this).siblings().removeClass("curren")
        });

        //最晚到店
        $(".lasttimeselect").click(function () {
            $(".lasttime-mask").fadeIn();
            $(".mask-bottom-inner").addClass("shin-slide-up");

        });
        //选择时间
        $(".hongbao-select>li").on("click", function () {
            $(this).addClass("cur").siblings().removeClass("cur");
        });
        $(".mask-close").click(function () {
            $(".mask").fadeOut();
        });

        $(".mask-bottom-inner").on("click", function (e) {
            // e.stopPropagation();
        });


        $(document).on('click', '.lasttime-mask li', function () {
            var lasttime = $(this).find("div").text().trim();
            $('#lasttime').val(lasttime);
            $(this).parents(".mask").fadeOut();
        });

        //只能输入数字
        $(".phonenum-input").keyup(function () {
            this.value = this.value.replace(/[^\d]/g, '');
        })

    


        $('.btn-save').click(function () {


            if ($("#username").val().trim() == "") {
                layer.msg("请输入姓名");
                return false;
            }

            if ($("#roomno").val().trim() == "") {
                layer.msg("请输入房号");
                return false;
            }


            var phonenumber = $('.phonenumber').val().trim();
            if (!/^1\d{10}$/.test(phonenumber)) {
                layer.msg("请输入正确手机号");
                return false;
            }

            var againhotel = "";
            if ($(".again-hotel  li.curren").find("span").length > 0) {

                againhotel = $(".again-hotel  li.curren").find("span").text().trim();
            }

            $(".btn-save").attr("disabled", true);


            $.ajax({
                url: '/zhinengA/AddEditServices',
                type: 'post',
                data: { hotelId: '<%=hotelid %>', key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', username: $("#username").val().trim(), roomno: $("#roomno").val().trim(), phonenumber: $(".phonenumber").val().trim(), hotelservice: $("#hotelservice").val().trim(), bestmanyi: $("#bestmanyi").val().trim(), bestbumanyi: $("#bestbumanyi").val().trim(), againhotel: againhotel, otheryijian: $("#otheryijian").val().trim(), type: "5" },
                dataType: 'json',
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {
                        layer.msg(ajaxObj.Mess);
                        setTimeout("window.location.href=window.location.href", 2000);
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
