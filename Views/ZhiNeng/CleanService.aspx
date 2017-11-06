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
    <title>清洁服务</title>
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
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/Restaurant.css" />
</head>
<body>
    <!-- <>主体页面 -->
    <article class="full-page">	  
		
		<!--//内容区-->
		<section class="show-body">
			<section class="content2">
                     <p class="ca-nao-weak">清洁服务</p>
				     <div class="ca-other-goods">
                           <ul>
                                <li class="ca-displayfx lasttimeselect"><span><h1>清洁时间</h1><i>*</i></span><input type="text" placeholder="请选择清洁时间"  id="lasttime" readonly="readonly" /><b></b></li>
                                <li class="ca-displayfx"><span><h1>房号</h1><i>*</i></span><input type="text" placeholder="房间号" id="roomno" /></li>
                                <li class="ca-displayfx"><span><h1>手机号</h1><i>*</i></span><input type="tel" placeholder="手机号" maxlength="11" class="phonenum-input phonenumber" /></li> 
                           </ul>
                           <div class="ca-why-remind">
                                 <p>特殊要求</p>
                                 <span><textarea placeholder="其他特殊要求" id="txt_remark" ></textarea></span>
                           </div>
                           <!--ca-why-remind end-->
                     </div>
                     <!--ca-other-goods end-->
                     <div class="uc__account-info">
                           <div class="submit-btn sp">
                                <input type="button" class="btn-save" value="提交" />
                           </div>
                     </div>
			</section>
		</section>
		<!--弹窗-->	
        <section class="mask lasttime-mask">
            <div class="mask-bottom-inner yu-bgw">
                <p class="yu-h110r yu-l110r yu-textc yu-bor bbor yu-f34r">清洁时间</p>
                <ul class="yu-lrpad10 yu-c99 hongbao-select">
 
    <li class="yu-h120r yu-grid yu-alignc yu-bor bbor">
                        <div class="yu-overflow yu-f30r">
                        当前
                             </div>
                        <p class="copy-radio"></p>
                    </li>
                <% int currHour = DateTime.Now.Hour; 
                    
                    for (int i = currHour + 1; i <= currHour + 24; i++)
                   {
                       for (int s = 0; s < 2; s++)
                       {
                           
                       %>

                    <li class="yu-h120r yu-grid yu-alignc yu-bor bbor">
                        <div class="yu-overflow yu-f30r">
                        <% if (i >= 24)
                           { %>
                          次日 <%=(i - 24).ToString().PadLeft(2, '0')%>:<%=s==0 ?"00" :"30" %>
                        <%}
                           else
                           {  %>

                            <%=i.ToString().PadLeft(2, '0')%>:<%=s==0 ?"00" :"30" %>
                            <%} %>
                        </div>
                        <p class="copy-radio"></p>
                    </li>
                       
                    <%  }
                   } %>
                 
                </ul>
                <div class="yu-h120r yu-bg40 yu-white yu-l120r yu-textc mask-close yu-f30r">关闭</div>
            </div>
        </section>
	</article>
    <% ViewData["key"] = Request.QueryString["key"]; ViewData["hId"] = hotelid; %>
    <% Html.RenderPartial("QuickNavigation", null); %>
    <script type="text/javascript">
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


            if ($("#lasttime").val().trim() == "") {
                layer.msg("请选择清洁时间");
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

            $(".btn-save").attr("disabled", true);


            $.ajax({
                url: '/zhineng/AddEditServices',
                type: 'post',
                data: { hotelId: '<%=hotelid %>', key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', servicetime: $("#lasttime").val().trim(), roomno: $("#roomno").val().trim(), phonenumber: $(".phonenumber").val().trim(), remark: $("#txt_remark").val().trim(), type: "0" },
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
