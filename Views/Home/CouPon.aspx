<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    System.Data.DataTable CouponList = ViewData["dt"] as System.Data.DataTable;

    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", ViewData["weixinID"]);
    viewDic.Add("hId", ViewData["hId"]);
    viewDic.Add("uwx", ViewData["userWeiXinID"]);

    List<long> MyCoupons = ViewData["MyCoupons"] as List<long>;
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
    <title>红包列表</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["jsUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["jsUrl"] %>/css/booklist/new-style.css" />
    <link rel="stylesheet" href="<%=ViewData["jsUrl"] %>/css/booklist/mend-reset.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
</head>
<body class="ca-overflow ca-bg-wihte">
    <!-- <>主体页面 -->
    <section>

    <% if (CouponList != null && CouponList.Rows.Count > 0)
       { %>
     <div class="ca-red-mtop">
                    <div class="ca-safe-distance"> 
                         <ul class="ca-rewards">
                    <% foreach (System.Data.DataRow row in CouponList.Rows)
                       {
                           string money = row["moneys"].ToString();
                           string amountlimit = row["amountlimit"].ToString();
                           if (amountlimit.IndexOf('.') > -1)
                           {
                               amountlimit = amountlimit.Substring(0, amountlimit.IndexOf('.'));
                           }
                            %>
                    
                      <li class="ca-red-bag">
                                    <div class="ca-redbag-amount">
                                          <p><span>￥</span><%=money %></p>
                                          <div class="ca-full-ava"> 
                                          <% if (!string.IsNullOrEmpty(amountlimit) && int.Parse(amountlimit) > 0)
                                             { %>
                                          满<%=amountlimit%>可用
                                          <%}
                                             else
                                             { %>
                                             无限制
                                             <%} %>
                                          </div>
                                    </div>
                                    <%
                                        string scopelimit = row["scopelimit"].ToString();
                                        List<string> scopeArry = string.IsNullOrEmpty(scopelimit) ? new List<string>() : scopelimit.Split(',').ToList<string>();
                            %><div class="ca-gz-fding ca-flex <%= scopeArry.Count>1 && scopeArry.Count<5?"ca-mart-line-small":"ca-mart-line-big" %> ">
                                             <% 
                          
                                                 Dictionary<string, string> ScopeDictionary = new Dictionary<string, string>() { { "0", "订房" }, { "1", "餐饮" }, { "2", "团购预售" }, { "3", "超市" }, { "4", "周边商家" } };




                                                 string link = string.Format("/Hotel/Index/{0}?key={1}@{2}", ViewData["hId"], ViewData["weixinID"], ViewData["userWeiXinID"]);

                                                 string header = "订房红包";
                                                 if (scopeArry.Count > 0)
                                                 {
                                                     if (scopeArry.Count > 1)
                                                     {
                                                         header = "通用红包";
                                                     }
                                                     else
                                                     {
                                                         header = ScopeDictionary[scopeArry[0]] + "红包";
                                                         switch (scopelimit)
                                                         {
                                                             case "1":
                                                                 link = string.Format("/DishOrder/DishOrderIndex/{0}?key={1}@{2}", ViewData["hId"], ViewData["weixinID"], ViewData["userWeiXinID"]);
                                                                 break;
                                                             case "2":
                                                                 link = string.Format("/Supermarket/Index/{0}?key={1}@{2}", ViewData["hId"], ViewData["weixinID"], ViewData["userWeiXinID"]);
                                                                 break;
                                                             case "3":
                                                                 link = string.Format("/Product/ProductList/{0}?key={1}@{2}", ViewData["hId"], ViewData["weixinID"], ViewData["userWeiXinID"]);
                                                                 break;
                                                             case "4":
                                                                 link = string.Format("/DishOrder/DishOrderIndex/{0}?key={1}@{2}", ViewData["hId"], ViewData["weixinID"], ViewData["userWeiXinID"]);
                                                                 break;
                                                         }
                                                     }

                                                 }

                          
                           
                            %><p><%=header %></p><% if (scopeArry.Count > 1 && scopeArry.Count < 5)
                                                    {
                                                        //合并餐饮和周边商家
                                                        if (scopeArry.Contains("1") && scopeArry.Contains("4"))
                                                        {
                                                            scopeArry.Remove("4");
                                                        }
                                       %><div class="ca-time-of-val">(<% for (int i = 0; i < scopeArry.Count; i++)
                                                                         { %><%=i > 0 ? "、" : ""%><%=ScopeDictionary[scopeArry[i]]%><%} %>)</div><%} %><div class="ca-time-of-val">有效期至<%=Convert.ToDateTime(row["ExtTime"].ToString()).ToString("yyyy-MM-dd")%></div></div><% if (!MyCoupons.Contains(long.Parse(row["id"].ToString())))
                                                                                                                                                                                                                                                                               { %><div class="ca-colf40 ca-flex-last receive" data-id="<%=row["id"].ToString() %>">立即领取</div><%}
                                                                                                                                                                                                                                                                               else
                                                                                                                                                                                                                                                                               {
                                            %>
                                       <div class="ca-flex-last ca-colight"><a href="<%=link %>">立即使用</a></div>
                                        <% } %>

                               </li>      
                     
                 <%} %>
                        </ul>
                    </div>
              </div>
    <%}
       else
       { %>
             <div class="ca-no-redbag">
                  <span style="background:#ccc"><em></em></span><p>暂时没有有可领取红包哦</p>
             </div>
       <%} %>

            
	</section>
    <%Html.RenderPartial("Footer", viewDic); %>
</body>
</html>
<script src="../../Scripts/layer/layer.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {

        //领取红包
        $(".receive").click(function () {

            var attr = $(this);
            var index = layer.load(0, {
                shade: [0.2, '#777'] //0.1透明度的白色背景
            });

            var couponid = $(this).attr("data-id");
            if (couponid > 0) {

                var url = '/Home/GetCouPon/<%=ViewData["hId"] %>?weixinID=<%=ViewData["weixinID"] %>&userWeiXinID=<%=ViewData["userWeiXinID"] %>&couponid=' + couponid;

                //超时处理
                var timeout = setTimeout(function () {
                    layer.msg("网络超时！");
                    layer.closeAll();
                }, 10000);

                //提交
                $.post(url, function (data) {

                    clearTimeout(timeout)
                    if (data.error == '0') {
                        $(attr).unbind("click");
                        layer.msg("领取成功!");
                        window.location.reload()
                        //                        window.location.href = '/Home/CouPonInfo/<%=ViewData["hId"] %>?weixinID=<%=ViewData["weixinID"] %>&userWeiXinID=<%=ViewData["userWeiXinID"] %>&couponid=' + id;
                    } else {
                        layer.msg(data.message)
                    }
                    layer.close(index);
                });

            } else {
                layer.close(index);
                layer.msg('数据异常,请刷新重试!');
            }

        });
    })
</script>
