<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    List<WeiXin.Models.Home.RechargeCard> list = ViewData["list"] as List<WeiXin.Models.Home.RechargeCard>;
    WeiXin.Models.Home.RechargeRange range = ViewData["range"] as WeiXin.Models.Home.RechargeRange;

    List<string> rangetxt = new List<string>();

    if (!string.IsNullOrEmpty(range.UseRange))
    {
        for (int i = 0; i < range.UseRange.Split(',').Length; i++)
        {
            string curr = range.UseRange.Split(',')[i];

            if (curr == "0")
            {
                rangetxt.Add("酒店订房");
            }
            else if (curr == "1")
            {
                rangetxt.Add("自营餐饮");
            }
            else if (curr == "2")
            {
                rangetxt.Add("特惠优选");
            }

            else if (curr == "3")
            {
                rangetxt.Add("酒店超市");
            }

            else if (curr == "4")
            {
                rangetxt.Add("周边商家");
            }
        }
    }




    int page = Convert.ToInt32(ViewData["page"]);
    int pagesize = Convert.ToInt32(ViewData["pagesize"]);
    int count = Convert.ToInt32(ViewData["count"]);
    int pagenum = count % pagesize == 0 ? count / pagesize : count / pagesize + 1;



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

    #region 获取appid Ashbur20170427
    string appid = "wx9f84537c7ce94a29";
    var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable(@"select top 1 appid from WeiXin..WeiXinNO with(nolock)  where WeiXinID=@WeiXinID and iszhifu=1", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { { "WeiXinID", new HotelCloud.SqlServer.DBParam { ParamValue = weixinID.Trim() } } });
    if (dt.Rows.Count > 0)
    {
        foreach (System.Data.DataRow dr in dt.Rows)
            appid = dr["appid"].ToString().Trim();
    }
    ViewData["appid"] = appid;
    #endregion

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();

 

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8" />
    <title>储值卡充值</title>
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
    <link rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/mend-reset.css" />
    <script src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
     <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body>
    <article class="full-page">

            <%Html.RenderPartial("HeaderA", viewDic); %>
           <section class="show-body">			
			<section class="content2">


            	<div class="pg__ucenter">
					<!--//储值卡余额信息-->
					<div class="uc__hdinfo uc__rechargeinfo flexbox">
						<div class="money flex1">
							<h2><i class="ico-uc i1"></i>储值卡余额（元）</h2>
							<label class="num">￥<em><%=ViewData["balance"]%></em></label>
						</div>
						<a class="lk-detail" href="/RechargeA/RechargeDetail/<%=hotelid%>?key=<%=weixinID%>@<%=userWeiXinID %>" ><i class="ico-uc i2"></i>明细</a>
					</div>
					
					<!--//储值卡/卡密充值-->
					<div class="uc__tab-recharge">
						<ul class="tab-nav tab-menu flexbox">
							<li class="flex1 cur">储值卡充值</li>
							<li class="flex1">卡密充值</li>
						</ul>
						<ul class="tab-inner">
							<li class="cur">
								<div class="cnt-card recharge-list">
									<h3>充值金额</h3>
									<ul class="clearfix" id="J__selAmount">

                                     <% foreach (var item in list.OrderBy(c => c.MPrice))
                                        {   %>
		                          	<li data-id="<%=item.Id%>">
                                    <a href="javascript:;">
												<h2><span class="mprice" ><%= Convert.ToDouble(item.MPrice)%></span>元</h2>
												<label class="price">售价：<span class="sprice"><%= Convert.ToDouble(item.Sprice)%></span>元</label>
											</a>
                                    </li>
                                     <%} %>
										 
									</ul>
								</div>
							</li>
							<li>
								<div class="cnt-cami">
									<div class="ipt-row flexbox">
										<label>输入卡密</label>
										<input class="flex1" type="number" name="cami"  id="cardpassword"  />
									</div>
									<div class="btn">									 
                                        <input type="button"  value="提交" class="btn-send"  id="btn_cardpassword"  />
									</div>
								</div>
							</li>
						</ul>
					</div>
					
					<!--//使用说明-->
					<div class="uc__card-instruction">
                     <% if (!string.IsNullOrEmpty(range.Remark))
                        { %>
			
						<div class="item">
							<h2>储值卡使用说明</h2>
							<p class="tips"> <%=range.Remark.Replace("\n","<br/>" ) %></p>
						</div>
                          <%} %>
						
						<div class="item">
							<h2>使用范围</h2>
							<ul class="around clearfix flexbox">
                      

								<li class="flex1" >
									<i class="ico-uc i1"></i>
									<h3>酒店订房</h3>
								</li>
                                 
								<li class="flex1" style="<%=rangetxt.Contains("自营餐饮") ? "" :  "display:none"%>" >
									<i class="ico-uc i2"></i>
									<h3>自营餐饮</h3>
								</li>
								<li class="flex1" style="<%=rangetxt.Contains("特惠优选") ? "" :  "display:none"%>" >
									<i class="ico-uc i3"></i>
									<h3>特惠优选</h3>
								</li>
								<li class="flex1" style="<%=rangetxt.Contains("酒店超市") ? "" :  "display:none"%>" >
									<i class="ico-uc i4"></i>
									<h3>酒店超市</h3>
								</li>
								<li   class="flex1" style="<%=rangetxt.Contains("周边商家") ? "" :  "display:none"%>" >
									<i class="ico-uc i5"></i>
									<h3>周边商家</h3>
								</li>
							</ul>
						</div>
					</div>
				</div> 

            </section>
            </section>
            </article>

            <script type="text/javascript">
                $(function () {
                                 
                    //选项卡
                    var tabIndex;
                    $(".tab-nav").children("li").on("click", function () {
                        $(this).addClass("cur").siblings("li").removeClass("cur");
                        tabIndex = $(this).index();
                        $(this).parent(".tab-nav").siblings(".tab-inner").children("li").eq(tabIndex).addClass("cur").siblings().removeClass("cur");
                    })
                })



                var flag = true;
                $(".recharge-list ul li").click(function () {

                    if (flag == false) {

                        // layer.msg("请不要重复点击");
                        return false;
                    }

                    flag = false;

                    $(".recharge-list ul li").removeClass("selected");
                    $(this).addClass("selected");            

                    $.ajax({
                        url: '/RechargeA/RechargeUserAccount',
                        type: 'post',
                        data: { key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', cardId: $(this).attr("data-id"), mprice: $(this).find(".mprice").text().trim(), sprice: $(this).find(".sprice").text().trim() },
                        dataType: 'json',
                        success: function (ajaxObj) {
                            if (ajaxObj.Status == 0) {

                                window.location.href = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=<%= ViewData["appid"]%>&redirect_uri=http%3a%2f%2fhotel.weikeniu.com%2fWeiXinZhiFu%2fwxOAuthRedirect.aspx&response_type=code&scope=snsapi_base&state=" + ajaxObj.Mess + "#wechat_redirect";

                            }

                            else {
                                layer.msg(ajaxObj.Mess);

                                if (ajaxObj.Mess.indexOf("金额") > -1) {
                                    setTimeout("window.location.href = window.location.href ", 2000);
                                }
                            }
                            flag = true;
                        }


                    });

                });


                $("#btn_cardpassword").click(function () {

                    if ($("#cardpassword").val().trim() == "") {
                        layer.msg("请输入卡密");
                        return false;
                    }


                    if ($("#cardpassword").val().trim().length < 6) {
                        layer.msg("请输入正确的卡密");
                        return false;
                    }

                    $("#btn_cardpassword").attr("disabled", true);

                    $.ajax({
                        url: '/RechargeA/RechargeCardPassword',
                        type: 'post',
                        data: { key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', cardpassword: $("#cardpassword").val().trim() },
                        dataType: 'json',
                        success: function (ajaxObj) {
                            if (ajaxObj.Status == 0) {

                                layer.msg(ajaxObj.Mess);
                                setTimeout("window.location.href = window.location.href ", 2000);
                            }

                            else {

                                layer.msg(ajaxObj.Mess);
                                $("#btn_cardpassword").attr("disabled", false);
                            }
                        }
                    });
                });


	</script>
</body>
</html>
