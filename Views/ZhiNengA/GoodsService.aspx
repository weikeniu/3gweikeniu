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
    <title>物品借用</title>
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
                           <div class="ca-pro-lends  goods_list">
                            <ul class="ca-displayfx">
                                 <li class="flex1"><span class="ca-pro1"></span><label>衣架</label></li>
                                 <li class="flex1"><span class="ca-pro2"></span><label>茶壶</label></li>
                                 <li class="flex1"><span class="ca-pro3"></span><label>剃须刀</label></li>
                            </ul>
                            <ul class="ca-displayfx">
                                 <li class="flex1"><span class="ca-pro4"></span><label>雨伞</label></li>
                                 <li class="flex1"><span class="ca-pro5"></span><label>浴袍</label></li>
                                 <li class="flex1"><span class="ca-pro6"></span><label>烫斗</label></li>
                            </ul>
                            <ul class="ca-displayfx">
                                 <li class="flex1"><span class="ca-pro7"></span><label>苹果充电器</label></li>
                                 <li class="flex1"><span class="ca-pro8"></span><label>安卓充电器</label></li>
                                 <li class="flex1"><span class="ca-pro9"></span><label>热水器</label></li>
                            </ul>
                      </div>
				     <div class="ca-other-goods">
                           <ul>
                                  <li class="ca-displayfx"><span><h1>其它物品</h1><i></i></span><input type="text" placeholder="其它借用物品" id="other_goods" /></li>
                                <li class="ca-displayfx lasttimeselect"><span><h1>送达时间</h1><i>*</i></span><input type="text" placeholder="请选择送达时间"  id="lasttime" readonly="readonly" /><b></b></li>
                                <li class="ca-displayfx"><span><h1>房号</h1><i>*</i></span><input type="text" placeholder="房间号" id="roomno" /></li>
                              <li class="ca-displayfx"><span><h1>顾客姓名</h1><i>*</i></span><input type="text" placeholder="顾客姓名" id="username" /></li>
                           </ul>
                       
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
                <p class="yu-h110r yu-l110r yu-textc yu-bor bbor yu-f34r">送达时间</p>
             


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
 
    <script type="text/javascript">

        //选择物品
        $(".ca-pro-lends li").click(function () {
            $(this).toggleClass("on")
            $(this).siblings().removeClass("on")
            $(this).parent("ul").siblings().children("li").removeClass("on")
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

            var goodsname = "";

            if ($(".goods_list li.on").length > 0) {

                goodsname = $(".goods_list li.on").find("label").text().trim();
            }

            else {

                goodsname = $("#other_goods").val().trim();
            }

            if (goodsname == "") {
                layer.msg("请选择物品");
                return false;
            }


            if ($("#lasttime").val().trim() == "") {
                layer.msg("请选择送达时间");
                return false;
            }

            if ($("#roomno").val().trim() == "") {
                layer.msg("请输入房号");
                return false;
            }

            if ($("#username").val().trim() == "") {
                layer.msg("请输入姓名");
                return false;
            }

 

            $(".btn-save").attr("disabled", true);


            $.ajax({
                url: '/zhinengA/AddEditServices',
                type: 'post',
                data: { hotelId: '<%=hotelid %>', key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', goods: goodsname, servicetime: $("#lasttime").val().trim(), roomno: $("#roomno").val().trim(), username: $("#username").val().trim(), type: "3" },
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
