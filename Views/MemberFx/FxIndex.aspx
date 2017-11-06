<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%        
    string hotelid = RouteData.Values["id"].ToString();
    string key = HotelCloud.Common.HCRequest.GetString("key");
    string weixinID = "";
    string userWeiXinID = "";
    if (key.Contains("@"))
    {
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

    string edition = hotel3g.Models.MemberFxLogic.GetEdition(weixinID); 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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
    <title>分销中心</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css"/>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css"/>
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
</head>
<body class="ca-overflow">
<article class="full-page">

<% if (!WeiXin.Common.NormalCommon.IsLXSDoMain())
           { %>
     <% if (edition == "1")
        {
            //A版本菜单
            Html.RenderPartial("HeaderA", viewDic); 
        }
        else {
             //老板本快速导航
            Html.RenderPartial("Footer", viewDic);
        } %>

        <%} %>
     
      <div class="ca-ac-commis">
      <% hotel3g.Models.FxMemberInfo model = (hotel3g.Models.FxMemberInfo)ViewData["model"]; %>
               <div class="ca-apply-for">
                     <ul>
                          <li>累计佣金：<%=model.CanPutOutCash2+model.HasPutOutCash2%>元</li>
                          <li class="ca-kty-cash">可提现佣金</li>
                     </ul>
                     <dl>
                         <dt class="fl"><%=model.CanPutOutCash2%></dt>
                    <dd class="fr"><input type="button" value="申请提现" onClick="window.location.href='/MemberFx/FxApply/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&mid=<%=model.Id%>';"</dd>
                     </dl>
               </div> 
               <!--ca-apply-for end-->
               <div class="ca-tagory-nav">
                    <ul>
                          <li class="ca-flex"><a href="#" onclick="javascript:topage(3)">分销订单<br/><b><%=ViewData["ordNum"]%></b></a></li>
                          <li><a href="#" onclick="javascript:topage(2)">分销客户<br/><b><%=ViewData["cusNum"]%></b></a></li>
                          <li class="last-li"><a href="#" onclick="javascript:topage(1)">已提现<br/><b><%=model.HasPutOutCash%></b><span>元</span></a></li>
                    </ul>
               </div>
               <!--ca-tagory-nav end-->
               <div class="ca-tagory-menus">
                     <ul>
                          <li><a href="/Promoter/Generalize/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>"><i class="i10"></i>我的推广<span></span></a></li>
                          <li><a href="/MemberFx/FxExtensCenter/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>"><i class="i11"></i>分销中心<span></span></a></li>
                        <%--  <li><a href="/Promoter/Generalize/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>"><i class="i11"></i>我的推广<span></span></a></li>--%>
                          <%--<li><a href="javascript:;"><i class="i12"></i>提现设置<span></span></a></li>
                          <li><a href="javascript:;"><i class="i13"></i>如何赚钱<span></span></a></li>--%>
                     </ul>
               </div>
               <!--ca_navbar end-->
      </div>
      <!--ca-ac-commis end-->
</article>
	<script>

	    $(function () {
	        //下拉
	        $(".booking-list>li").on("click", function () {
	            $(this).toggleClass("cur");
	            $(this).find(".slide-bottom").slideToggle(100);
	        })
	        $(".slide-bottom").on("click", function (e) {
	            e.stopPropagation()
	        })
	    })

	    function topage(op) {
           if(op==1){
	        window.location.href = "/MemberFx/FxApplyList/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>";
            }
            if(op==2){
	        window.location.href = "/MemberFx/FxCustomer/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&mid=<%=model.Id%>";
            }
            if(op==3){
	        window.location.href = "/MemberFx/FxOrders/<%=ViewData["hId"] %>?key=<%=ViewData["key"] %>&mid=<%=model.Id%>";
            }
         }
	</script>
</body>
</html>
